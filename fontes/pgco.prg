//  Leve, Pagamento de conhecimento 
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

function PgCo( xAlterar )

if NetUse( "TranARQ", .t. )
  VerifIND( "TranARQ" )

  lOpenTran := .t.

  #ifdef DBF_NTX
    set index to TranIND1, TranIND2
  #endif
else
  lOpenTran := .f.
endif

if NetUse( "FornARQ", .t. )
  VerifIND( "FornARQ" )
  
  lOpenForn := .t.

  #ifdef DBF_NTX
    set index to FornIND1, FornIND2
  #endif
else
  lOpenForn := .f.
endif

if NetUse( "ConhARQ", .t. )
  VerifIND( "ConhARQ" )
  
  lOpenConh := .t.

  #ifdef DBF_NTX
    set index to ConhIND1, ConhIND2, ConhIND3, ConhIND4
  #endif
else
  lOpenConh := .f.
endif

//  Variaveis de Entrada para Item
nConh     := nTran   := nForn   := 0
cConh     := space(07)
cTran     := cForn   := space(04)
dEmis     := ctod('  /  /  ')
dVcto     := ctod('  /  /  ')
dPgto     := ctod('  /  /  ')
nValor    := nPago := nNotaFisc := 0
nQtde     := nPeso := nTabela   := nDesconto := 0
cObse     := space(50)
cEspecie  := space(10)

//  Tela Item
Janela ( 03, 05, 18, 72, mensagem( 'Janela', 'PgCo', .f. ), .t. )
  
setcolor ( CorJanel + ',' + CorCampo )
@ 05,07 say '     Fornecedor'
@ 06,07 say ' Transportadora'
@ 07,07 say '   Conhecimento                   Nota Fiscal'

@ 09,07 say '   Data Emissão                         Qtde.'
@ 10,07 say 'Data Vencimento                       Espêcie'
@ 11,07 say ' Data Pagamento                       Peso KG'

@ 13,07 say '  Valor Conhec.                  Valor Tabela'
@ 14,07 say '       Desconto                    Valor Pago'
@ 15,07 say '     Observação'
 
MostOpcao( 17, 07, 19, 48, 61 ) 
tConh := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Item
select ConhARQ
set order    to 1
set relation to Tran into TranARQ
if lOpenConh             
  dbgobottom ()
endif  
do while  .t.
  cStat := space(04)
  
  select FornARQ
  set order to 1
  
  select TranARQ
  set order to 1
  
  select ConhARQ
  set order    to 1
  set relation to Tran into TranARQ, Forn into FornARQ

  Mensagem('Pgco','Janela')

  restscreen( 00, 00, 23, 79, tConh )
  MostConh(xAlterar)
  
  if Demo ()
    exit
  endif  
  
  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostConh'
  cAjuda   := 'PgCo'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
 
  @ 05,23 get nForn      pict '999999' valid ValidForn( 05, 23, "ConhARQ" )
  @ 06,23 get nTran      pict '999999' valid ValidARQ ( 06, 23, "ConhARQ", "Código" , "Tran", "Descrição", "Nome", "Trns", "nTran", .t., 6, "Consulta de Transportadora", "TranARQ", 40 )  
  @ 07,23 get nConh      pict '9999999'
  read
    
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC
    exit
  endif

  cConh := strzero( nConh, 7 )
  cForn := strzero( nForn, 6 )
  cTran := strzero( nTran, 6 )

  //  Verificar existencia do Produto para Incluir ou Alterar
  select ConhARQ
  set order to 1
  dbseek( cForn + cTran + cConh, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif

  Mensagem ('Conh',cStat )

  MostConh (xAlterar)
  
  if nPago != 0
    Alerta( mensagem( 'Alerta', 'PgCo', .f. ) )
  endif
    
  EntrPgCo (xAlterar)
 
  Confirmar( 17, 07, 19, 48, 61, 3 )
  
  if lastkey() == K_ESC
    loop
  endif  

  if cStat == 'prin'
    PrinConh (.f.)
  endif
    
  if cStat == 'excl'
    ExclRegi ()
  endif
    
  if cStat == 'alte' 
    if RegLock()
      replace Pgto        with dPgto
      replace Pago        with nPago 
      dbunlock ()
    endif
  endif
          
  if EmprARQ->Caixa == "X"
    cNota := cConh
    cHist := TranARQ->Nome

    DestLcto ()
  endif
enddo

if lOpenTran
  select TranARQ
  close
endif  

if lOpenForn
  select FornARQ
  close
endif  

if lOpenConh
  select ConhARQ
  close
endif  
return NIL

//
// Calcula Desconto
//
function CPgDesc( xDesconto )
  nPago := nValor - xDesconto
return(.t.)


//
// Entra Dados do Item
//
function EntrPgCo (xAlterar)
  if empty( dPgto )
    dPgto := date ()
    nPago := nValor - nDesconto
  endif
  
  do while .t.
    lAlterou := .f.
  
    setcolor ( CorJanel + ',' + CorCampo )
    @ 11,23 get dPgto         pict '99/99/9999'
    @ 14,23 get nDesconto     pict '@E 999,999,999.99' valid CPgDesc( nDesconto )
    @ 14,53 get nPago         pict '@E 999,999,999.99'
    read
    
    if dPgto         != Pgto;     lAlterou := .t.
    elseif nDesconto != Desconto; lAlterou := .t.
    elseif nPago     != Pago;     lAlterou := .t.
    endif
    
    if !Saindo(lAlterou)
      loop
    endif
    exit  
  enddo  
return NIL