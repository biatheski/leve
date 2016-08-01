//  Leve, Recebimento de Contas a Pagar
//  Copyright (C) 1992-2015 Fabiano Biatheski - biatheski@gmail.com

//  See the file LICENSE.txt, included in this distribution,
//  for details about the copyright.

//  This software is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

//  History
//    10/09/2015 20:38 - Binho
//      Initial commit github

#include "inkey.ch"

#ifdef RDD_ADS
  #include "ads.ch" 
#endif

function Pgto ()

if NetUse( "FornARQ", .t. )
  VerifIND( "FornARQ" )
    
  lOpenForn := .t.

  #ifdef DBF_NTX 
    set index to FornIND1, FornIND2
  #endif
else
  lOpenForn := .f.  
endif

if NetUse( "PortARQ", .t. )
  VerifIND( "PortARQ" )
  
  lOpenPort := .t.
  
  #ifdef DBF_NTX 
    set index to PortIND1, PortIND2
  #endif
else
  lOpenPort := .f.  
endif

if NetUse( "PagaARQ", .t. )
  VerifIND( "PagaARQ" )
  
  lOpenPaga := .t.
  
  #ifdef DBF_NTX 
    set index to PagaIND1, PagaIND2, PagaIND3, PagaIND4, PagaIND5, PagaIND6
  #endif
else
  lOpenPaga := .f.  
endif

//  Variaveis de Entrada para Item
nNota  := nForn := nPort := nMora := 0
cNota  := space(12)
cDcto  := space(20)
cObse  := space(45)
cForn  := cPort := space(04)
dEmis  := dVcto := dPgto := ctod('  /  /  ')
nValor := nAcre := nDesc := nJuro := nPago := 0

//  Tela Item
Janela ( 03, 05, 21, 72, mensagem( 'Janela', 'Pgto', .f. ), .t. )

setcolor ( CorJanel + ',' + CorCampo )
@ 05,18 say 'Nota'
@ 06,12 say 'Fornecedor'

@ 08,10 say 'Data Emissão'
@ 08,40 say 'Dcto. Origem' 
@ 09,07 say 'Data Vencimento'
@ 10,08 say 'Data Pagamento'

@ 12,12 say 'Valor Nota'
@ 13,11 say 'Juro Mensal'
@ 13,41 say 'Mora Diária'

@ 15,13 say 'Descontos'
@ 15,47 say 'Juros'
@ 16,12 say 'Valor Pago'
@ 17,12 say 'Observação'
@ 18,12 say '  Portador'
 
MostOpcao( 20, 07, 19, 48, 61 ) 
tPgto := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Item
select PagaARQ
set order    to 1
set relation to Forn into FornARQ, to Port into PortARQ
if lOpenPaga
  dbgobottom ()
endif  
do while  .t.
   select FornARQ
  set order to 1
  
  select PortARQ
  set order to 1
  
  select PagaARQ
  set order    to 1
  set relation to Forn into FornARQ, to Port into PortARQ

  Mensagem('Pgto','Janela')

  cStat := space(04)
  restscreen( 00, 00, 23, 79, tPgto )
  MostPaga()

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostPaga'
  cAjuda   := 'Pgto'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()

  @ 05,23 get nNota   pict '9999999999-99'
  @ 06,23 get nForn   pict '999999' valid ValidForn ( 06, 23, "PagaARQ" )
  read
    
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. nNota == 0 .or. nForn == 0
    exit
  endif
  
  cNota := strzero( nNota, 12 )
  cForn := strzero( nForn, 06 )

  //  Verificar existencia do Produto para Incluir ou Alterar
  select PagaARQ
  set order to 1
  dbseek( cNota + cForn, .f. )
  if eof()
    Alerta ( mensagem( 'Alerta', 'PgtoEof', .f. ) )
    loop
  else
    cStat := 'alte'
  endif

  Mensagem ( 'Pgto', cStat )

  MostPaga ()

  if dPgto != ctod ('  /  /  ')
    Alerta( mensagem( 'Alerta', 'PgtoOff', .f. ) )
  endif   
    
  EntrPgto ()

  Confirmar ( 20, 07, 19, 48, 61, 3 )
  
  if lastkey () == K_ESC .or. cStat == 'loop'
    loop
  endif
   
  if cStat == 'prin'
    PrinPaga (.f.)
  endif
    
  if cStat == 'excl'
    ExclRegi ()
  endif
    
  if cStat == 'alte' .or. cStat == 'incl'
    if RegLock()
      replace Pgto  with dPgto
      replace Desc  with nDesc
      replace Juro  with nJuro
      replace Pago  with nPago
      replace Obse  with cObse
      replace Port  with cPort
      dbunlock ()
    endif
  endif
  
  if EmprARQ->Caixa == "X"
    cHist := FornARQ->Nome

    DestLcto ()
  endif
enddo

if lOpenPaga
  select PagaARQ
  close
endif  

if lOpenForn
  select FornARQ
  close
endif  

if lOpenPort
  select PortARQ
  close
endif  

return NIL

//
// Calcula do Juro
//
function CalcJuro ( xPara )  
  
  if xPara == 'R'
    if dPgto > dVcto .and. Juro == 0
      nDias := ( dVcto - dPgto )
  
      if nDias < 31
        nJuro := ( dPgto - dVcto ) * ( ( nValor - nDesc ) * ( nAcre / 30 ) / 100 )
      else  
        nMes   := int( nDias / 30 ) + 1
        nTotal := ( nValor - nDesc )
        
        for nU := 1 to nMes
          nJurinho := ( nTotal * nAcre ) / 100         
          nTotal   += nJurinho
        next
        
        nJuro := nTotal - ( nValor - nDesc )
         
        if nJuro < 0
          nJuro := 0
        endif  
      endif
    else
      nJuro := Juro
    endif
  
    setcolor( CorCampo )
    @ 14,55 say nJuro   pict '@E 999,999,999.99'
  else
    if dPgto > dVcto .and. Juro == 0
      nJuro := ( dPgto - dVcto ) * ( ( nValor - nDesc ) * ( nAcre / 30 ) / 100 )
    else
      nJuro := Juro
    endif
  
    setcolor( CorCampo )
    @ 15,53 say nJuro   pict '@E 999,999,999.99'
  endif 

  setcolor ( CorJanel + ',' + CorCampo )
return(.t.)

//
// Entra Pgto da Duplicata 
//
function EntrPgto ()
  if empty( dPgto )
    dPgto := date()
  endif  
  
  do while .t.
    lAlterou := .f.
  
    setcolor ( CorJanel + ',' + CorCampo )
    @ 10,23 get dPgto   pict '99/99/9999'           valid CalcJuro('P')
    @ 15,23 get nDesc   pict '@E 999,999,999.99'
    @ 15,53 get nJuro   pict '@E 999,999,999.99'  valid CalcPg() 
    @ 16,23 get nPago   pict '@E 999,999,999.99'
    @ 17,23 get cObse   pict '@S40'
    @ 18,23 get nPort   pict '999999'             valid ValidARQ( 18, 23, "PagaARQ", "Código" , "Port", "Descrição", "Nome", "Port", "nPort", .t., 6, "Consulta de Portadores", "PortARQ", 40 )
    read

    if dPgto     != Pgto;        lAlterou := .t.
    elseif nDesc != Desc;        lAlterou := .t.
    elseif nJuro != Juro;        lAlterou := .t.
    elseif nPago != Pago;        lAlterou := .t.
    elseif cObse != Obse;        lAlterou := .t.
    elseif nPort != val( Port ); lAlterou := .t.
    endif
    
    if !Saindo (lAlterou)
      loop
    endif
    exit  
  enddo  

  cPort := strzero( nPort, 6 )
return NIL

function CalcPg ()
  if nPago == 0
    nPago := nValor - nDesc + nJuro
  endif 
return(.t.)