//  Leve, Contas
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

function Cont( xAlte )
  local GetList := {}
  
if SemAcesso( 'Cont' )
  return NIL
endif  

if NetUse( "ContARQ", .t. )
  VerifIND( "ContARQ" )
  
  lOpenCont := .t.

  #ifdef DBFCDX
    set index to ContIND1, ContIND2
  #endif  
else
  lOpenCont := .f.
endif

//  Variaveis de Entrada para Conta
cCont := space(02)
nTipo := 0
cNome := space(30)
cTipo := space(01)

//  Tela Cont
Janela ( 04, 05, 12, 62, mensagem( 'Janela', 'Cont', .f. ), .t. )

setcolor ( CorJanel + ',' + CorCampo )
@ 06,10 say '   Codigo'
@ 08,10 say 'Descrição'
@ 09,10 say '     Tipo'

MostOpcao( 11, 07, 19, 38, 51 ) 
tCont := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Cont
select ContARQ
set order to 1
if lOpenCont
  dbgobottom ()
endif  
do while  .t.
  Mensagem('Cont', 'Janela' )

  select ContARQ
  set order to 1

  restscreen( 00, 00, 23, 79, tCont )
  cStat := space(4)
  MostCont()
  
  if Demo ()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostCont'
  cAjuda   := 'Cont'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  @ 06,20 get cCont              
  read
  
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC 
    exit
  endif
  
  //  Verificar existencia do Lancamento para Incluir ou Alterar
  select ContARQ
  set order to 1
  dbseek( cCont, .f. )
  if eof()
    cStat :=  'incl'
  else
    cStat :=  'alte'
  endif

  Mensagem ('Cont', cStat )
  
  MostCont ()
  EntrCont ()

  Confirmar( 11, 07, 19, 38, 51, 3 )

  if cStat == 'prin'
    PrinCont (.f.)
  endif
    
  if cStat == 'excl'
    ExclRegi ()
  endif
    
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Cont       with cCont
        dbunlock ()
      endif
    endif  
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Nome         with cNome
      replace Tipo         with cTipo
      dbunlock ()
    endif
    
    if !xAlte
      xAlte := .t.
      keyboard(chr(27))
    endif  
  endif
enddo

if lOpenCont
  select ContARQ
  close
endif  

return NIL

//
// Entra com os dados da Conta
//
function EntrCont ()
  local GetList := {}
  local aOpcoes := {}

  aadd( aOpcoes, { ' Débito ',  2, 'D', 09, 20, "Tipo da Conta - Débito." } )
  aadd( aOpcoes, { ' Crédito ', 2, 'C', 09, 29, "Tipo da Conta - Crédito." } )
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,20 get cNome               pict '@S40'
  read
  
  if lastkey () == K_ESC
    return NIL
  endif  
  
  nTipo := HCHOICE( aOpcoes, 2, nTipo )
  cTipo := iif( nTipo == 1, 'D', 'C' )
return NIL

// 
// Mostra dados da Conta
//
function MostCont ()
  if cStat != 'incl' 
    cCont := Cont
    nCont := val( Cont )
  endif
  
  cNome := Nome
  cTipo := Tipo
  nTipo := iif( cTipo == 'D', 1, 2 )

  setcolor ( CorCampo )
  @ 09,20 say ' D‚bito '
  @ 09,29 say ' Cr‚dito '
      
  setcolor ( CorCampo )
  @ 08,20 say cNome               pict '@S40'
  
  do case 
    case cTipo == 'D'
      setcolor ( CorOpcao )
      @ 09,20 say ' D‚bito '
      
      setcolor ( CorAltKO )
      @ 09, 21 say 'D'
    case cTipo == 'C'  
      setcolor ( CorOpcao )
      @ 09,29 say ' Cr‚dito '
      
      setcolor ( CorAltKO )
      @ 09,30 say 'C'
  endcase
  
  PosiDBF( 04, 62 )
return NIL

//
// Relatório das Contas Cadastradas
//
function PrinCont ( lAbrir )

  local cArqu2  := CriaTemp( 5 )
  local cArqu3  := right ( cArqu2, 8 )

  local cRData  := date()
  local cRHora  := time()
  
  local GetList := {}

  if lAbrir
    if NetUse( "ContARQ", .t. )
      VerifIND( "ContARQ" )

      #ifdef DBFCDX
        set index to ContIND1, ContIND2
      #endif  
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 06, 23, 10, 50, mensagem( 'Janela', 'PrinCont', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,30 say 'Conta Inicial'
  @ 09,30 say '  Conta Final'
  
  select ContARQ
  set order to 1
  dbgotop ()
  nContIni := val( Cont )
  dbgobottom ()
  nContFin := val( Cont )

  @ 08,44 get nContIni     pict '999999'   valid ValidARQ( 99, 99, "ContARQ", "Codigo", "Cont", "Descrição", "Nome", "Cont", "nContIni", .t., 6, "Consulta de Contas", "ContARQ", 40 )
  @ 09,44 get nContFin     pict '999999'   valid ValidARQ( 99, 99, "ContARQ", "Codigo", "Cont", "Descrição", "Nome", "Cont", "nContFin", .t., 6, "Consulta de Contas", "ContARQ", 40 ) .and. nContFin >= nContIni
  read

  if lastkey() == K_ESC
    select ContARQ
    if lAbrir
      close
    else
      set order to 1
      dbgobottom ()
    endif
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  Aguarde ()

  nPag     := 1
  nLin     := 0
  cArqu2   := cArqu2 + "." + strzero( nPag, 3 )
  cContIni := strzero( nContIni, 6 )
  cContFin := strzero( nContFin, 6 )
  lInicio  := .t.

  select ContARQ
  set order to 1
  dbseek( cContIni, .t. )
  do while Cont >= cContIni .and. Cont <= cContFin .and. !eof ()
    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
      
      lInicio := .f.
    endif  

    if nLin == 0
      Cabecalho( 'Contas', 80, 4 )
      CabCont()
    endif
       
    @ nLin,00 say Cont
    @ nLin,15 say alltrim( Nome )
    @ nLin,50 say iif( Tipo == 'D', 'DEBITO', 'CREDITO' )
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
      replace Titu       with "Relatório de Contas"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
    close
  endif

  select ContARQ
  if lAbrir
    close
  else
    set order  to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabCont()
  @ 02,00 say 'Codigo'
  @ 02,15 say 'Descrição'
  @ 02,50 say 'Tipo'

  nLin := 4
return NIL

//
// Verifica se o Usuario tem Acesso
//
function SemAcesso( pArquivo )
  select UsMeARQ
  set order to 1

  cModulo := cEmpresa
  
  do case 
    case pArquivo == 'Empr';  cMenu := '01.01.00';  cItem := '01'
    case pArquivo == 'Fisi';  cMenu := '02.01.00';  cItem := '01'
    case pArquivo == 'Clie';  cMenu := '02.01.00';  cItem := '02'
    case pArquivo == 'Clin';  cMenu := '02.01.00';  cItem := '03'
    case pArquivo == 'Natu';  cMenu := '02.02.00';  cItem := '01'
    case pArquivo == 'Cond';  cMenu := '02.02.00';  cItem := '02'
    case pArquivo == 'Tran';  cMenu := '02.02.00';  cItem := '03'
    case pArquivo == 'Port';  cMenu := '02.02.00';  cItem := '04'
    case pArquivo == 'Cobr';  cMenu := '02.02.00';  cItem := '05'
    case pArquivo == 'CEPe';  cMenu := '02.02.00';  cItem := '06'
    case pArquivo == 'Esta';  cMenu := '02.02.00';  cItem := '07'
    case pArquivo == 'Veic';  cMenu := '02.02.00';  cItem := '08'
    case pArquivo == 'PaMa';  cMenu := '02.02.00';  cItem := '11'
    case pArquivo == 'Repr';  cMenu := '02.02.00';  cItem := '12'
    case pArquivo == 'Agen';  cMenu := '05.02.00';  cItem := '01'
    case pArquivo == 'Forn';  cMenu := '02.00.00';  cItem := '04'
    case pArquivo == 'Prod';  cMenu := '02.00.00';  cItem := '06'
    case pArquivo == 'Grup';  cMenu := '02.00.00';  cItem := '07'
    case pArquivo == 'SubG';  cMenu := '02.00.00';  cItem := '08'
    case pArquivo == 'Lcto';  cMenu := '02.03.00';  cItem := '01'
    case pArquivo == 'Caix';  cMenu := '02.03.00';  cItem := '02'
    case pArquivo == 'Cont';  cMenu := '02.03.00';  cItem := '03'
    case pArquivo == 'Banc';  cMenu := '02.03.00';  cItem := '05'
    case pArquivo == 'Agci';  cMenu := '02.03.00';  cItem := '06'
    case pArquivo == 'Estq';  cMenu := '02.04.00';  cItem := '07'
    case pArquivo == 'Atri';  cMenu := '04.07.00';  cItem := '01'
    case pArquivo == 'Cotd';  cMenu := '04.07.00';  cItem := '02'
    case pArquivo == 'PrAt';  cMenu := '04.07.00';  cItem := '03'
    case pArquivo == 'CaPr';  cMenu := '04.07.00';  cItem := '04'
    case pArquivo == 'Redu';  cMenu := '04.07.00';  cItem := '05'
    case pArquivo == 'MeEm';  cMenu := '02.02.00';  cItem := '10'
    case pArquivo == 'MeRe';  cMenu := '02.02.00';  cItem := '11'
    case pArquivo == 'Cust';  cMenu := '02.02.00';  cItem := '12'
    case pArquivo == 'Idio';  cMenu := '02.02.00';  cItem := '13'
  endcase  
    
  dbseek( cUsuario + cModulo + cMenu + cItem, .f. )
  if !found()  
    Alerta( mensagem ( 'Alerta', 'SemAcesso', .f. ) )

    lFudeu := .t.
  else
    lFudeu := .f.  
  endif
return( lFudeu )