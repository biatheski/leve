//  Leve, Transportadoras
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

function Trns( xAlte )
  local GetList := {}

if SemAcesso( 'Tran' )
  return NIL
endif  

if NetUse( "TranARQ", .t. )
  VerifIND( "TranARQ" )
  
  lOpenTran := .t.

  #ifdef DBF_NTX
    set index to TranIND1, TranIND2
  #endif
else
  lOpenTran := .f.
endif

//  Variaveis de Entrada para Transportadora
nTran     := nCEP     := 0
cTran     := space(4)
cFone     := cFax     := cBairro  := cViaTra  := space(14)
cNome     := space(45)
cEnde     := space(34)
cCidade   := space(30)
cUF       := space(2)
cCGC      := space(14)
cInscEstd := space(20)
cContato  := space(40)

//  Tela Transportadora
Janela ( 03, 06, 19, 75, mensagem( 'Janela', 'Trns', .f. ), .t. )

setcolor ( CorJanel )
@ 05,08 say '      Codigo'
@ 07,08 say 'Razão Social'

@ 09,08 say '    Endereço'
@ 09,56 say 'CEP'
@ 10,08 say '      Cidade'
@ 10,57 say 'UF'
@ 11,08 say '      Bairro'
@ 11,36 say 'Fone'
@ 11,56 say 'Fax'

@ 13,08 say ' Via Trasnp.'
@ 14,08 say '     Contato'

@ 16,08 say '  Insc. CNPJ'
@ 16,41 say 'Insc. Estad.'

MostOpcao( 18, 08, 20, 51, 64 ) 
tTran := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Transportadora
select TranARQ
set order to 1
if lOpenTran
  dbgobottom ()
endif  
do while  .t.
  select TranARQ
  set order to 1

  Mensagem ( 'Trns', 'Janela' )

  restscreen( 00, 00, 23, 79, tTran )
  cStat := space(04)
  MostTran()
  
  if Demo ()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostTran'
  cAjuda   := 'Tran'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
   
  if lastkey() == K_ALT_A  
    nTran := val( Tran )
  else 
    if xAlte
      @ 05,21 get nTran          pict '999999'
      read
    else  
      nTran := 0
    endif  
  endif
     
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC
    exit
  endif
  
  setcolor ( CorCampo )
  cTran := strzero( nTran, 6 )
  @ 05,21 say cTran

  //  Verifica existencia do Transportadora para Incluir ou Alterar
  select TranARQ
  set order to 1
  dbseek( cTran, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif

  Mensagem( 'Trns', cStat )  
  MostTran()
  EntrTran()

  Confirmar ( 18, 08, 20, 51, 64, 3 )

  if cStat == 'prin'
    PrinTran (.f.)
  endif
    
  if cStat == 'excl'
    ExclRegi ()
  endif
   
  if cStat == 'incl'
    if cTran == '000000'
      cTran := '000001'
    endif    

    set order to 1  
    do while .t.
      dbseek( cTran, .f. )
      if found()
        nTran := val( cTran ) + 1               
        cTran := strzero( nTran, 6 )
      else 
        exit   
      endif
    enddo

    if AdiReg()
      if RegLock()
        replace Tran       with cTran
        dbunlock ()
      endif
    endif 
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Nome       with cNome 
      replace Ende       with cEnde
      replace Cidade     with cCidade
      replace CEP        with nCEP
      replace UF         with cUF
      replace Bairro     with cBairro
      replace CGC        with cCGC
      replace InscEstd   with cInscEstd
      replace Fone       with cFone
      replace Fax        with cFax
      replace ViaTra     with cViaTra
      replace Contato    with cContato
      dbunlock ()
    endif
    
    if !xAlte
      xAlte := .t.
      keyboard(chr(27))
    endif
  endif
enddo

if lOpenTran
  select TranARQ
  close 
endif

return NIL

//
// Entra Dados do Transportadora
//
function EntrTran()
  local GetList := {}

  do while .t.
    lAlterou := .f.
    
    setcolor ( CorJanel + ',' + CorCampo )
    @ 07,21 get cNome 
    @ 09,21 get cEnde       pict '@S34'
    @ 09,60 get nCEP        pict '99999-999'
    @ 10,21 get cCidade       
    @ 10,60 get cUF         pict '@!' valid ValidUf ( 10, 60, "TranARQ" )
    @ 11,21 get cBairro       pict '@S14'  
    @ 11,41 get cFone       
    @ 11,60 get cFax        
    @ 13,21 get cViaTra
    @ 14,21 get cContato
    @ 16,21 get cCGC        pict '@R 99.999.999/9999-99' valid ValidCGC( cCGC )
    @ 16,54 get cInscEstd
    read

    if cNome         != Nome;     lAlterou := .t.
    elseif cEnde     != Ende;     lAlterou := .t.
    elseif nCEP      != CEP;      lAlterou := .t.
    elseif cCidade   != Cidade;   lAlterou := .t.
    elseif cUF       != UF;       lAlterou := .t.
    elseif cBairro   != Bairro;   lAlterou := .t.
    elseif cFone     != Fone;     lAlterou := .t.
    elseif cFax      != Fax;      lAlterou := .t.
    elseif cViaTra   != ViaTra;   lAlterou := .t.
    elseif cContato  != Contato;  lAlterou := .t.
    elseif cCGC      != CGC;      lAlterou := .t.
    elseif cInscEstd != InscEstd; lAlterou := .t.
    endif
    
    if !Saindo(lAlterou)
      loop
    endif
    exit  
  enddo  
return NIL

//
// Mostra Dados do Transportadora
//
function MostTran()
  if cStat != 'incl'
    nTran   := val( Tran )
    cTran   := Tran
  endif  
    
  cNome     := Nome 
  cEnde     := Ende
  cCidade   := Cidade
  nCEP      := CEP
  cBairro   := Bairro
  cUF       := UF
  cCGC      := CGC
  cInscEstd := InscEstd
  cFone     := Fone
  cFax      := Fax
  cViaTra   := ViaTra
  cContato  := Contato

  setcolor ( CorCampo )
  @ 07,21 say cNome 
  @ 09,21 say cEnde       pict '@S34' 
  @ 09,60 say nCEP        pict '99999-999'
  @ 10,21 say cCidade
  @ 10,60 say cUF         pict '@!'
  @ 11,21 say cBairro       pict '@S14'  
  @ 11,41 say cFone       
  @ 11,60 say cFax        
  @ 13,21 say cViaTra
  @ 14,21 say cContato
  @ 16,21 say cCGC        pict '@R 99.999.999/9999-99'
  @ 16,54 say cInscEstd
  
  PosiDBF( 03, 75 )
return NIL

//
// Imprime dados do Transportadora
//
function PrinTran ( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "TranARQ", .t. )
      VerifIND( "TranARQ" )

      #ifdef DBF_NTX
        set index to TranIND1, TranIND2
      #endif
    endif
  endif  
  
  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 06, 25, 10, 57, mensagem( 'Janela', 'PrinTrns', .f. ), .f. )

  setcolor ( Corjanel + ',' + CorCampo )
  @ 08,27 say 'Transportadora Inicial'
  @ 09,27 say '  Transportadora Final'

  select TranARQ
  set order to 1
  dbgotop ()
  nTranIni := val( Tran )
  dbgobottom ()
  nTranFin := val( Tran )

  @ 08,50 get nTranIni    pict '999999'  valid ValidARQ( 99, 99, "TranARQ", "Código" , "Tran", "Descrição", "Nome", "Tran", "nTranIni", .t., 6, "Consulta de Transportadora", "TranARQ", 30 )
  @ 09,50 get nTranFin    pict '999999'  valid ValidARQ( 99, 99, "TranARQ", "Código" , "Tran", "Descrição", "Nome", "Tran", "nTranFin", .t., 6, "Consulta de Transportadora", "TranARQ", 30 ) .and. nTranFin >= nTranIni
  read

  if lastkey() == K_ESC
    select TranARQ
    if lAbrir
      close
    else
      dbgobottom ()
    endif
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  Aguarde ()
  
  nPag     := 1
  nLin     := 0
  cArqu2   := cArqu2 + "." + strzero( nPag, 3 )
  lInicio  := .t.

  cTranIni := strzero( nTranIni, 6 )
  cTranFin := strzero( nTranFin, 6 )

  select TranARQ
  set order  to 1
  dbseek( cTranIni, .t. )
  do while Tran >= cTranIni .and. Tran <= cTranFin .and. !eof()
    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
      
      lInicio := .f.
    endif
      
    if nLin == 0
      Cabecalho( 'Transportadora', 80, 3 )
      CabTran()
    endif
      
    @ nLin, 00 say Tran     
    @ nLin, 08 say Nome 
    nLin ++

    if nLin >= pLimite
      Rodape(80) 

      cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
      cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

      set printer to ( cArqu2 )
      set printer on
    endif

    dbskip ()
  enddo
  
  if !lInicio
    Rodape(80)
  endif  
 
  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 80 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with 'Relatório de Transportadora'
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
    close
  endif
  
  select TranARQ
  if lAbrir
    close
  else
    set order  to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabTran ()
  @ 02, 00 say 'Cod'
  @ 02, 06 say 'Raz„o Social'

  nLin := 04
return NIL