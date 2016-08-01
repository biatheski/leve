//  Leve, Cadastro de CEP
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

function CEPe( xAlte )
  local GetList := {}
  
if SemAcesso( 'CEPe' )
  return NIL
endif  

if NetUse( "CEPeARQ", .t. )
  VerifIND( "CEPeARQ" )

  lOpenCEPe := .t.
  
  #ifdef DBF_NTX
    set index to CEPeIND1, CEPeIND2, CEPeIND3, CEPeIND4
  #endif  
else
  lOpenCEPe := .f.
endif

//  Variaveis de Entrada
cUF   := space(02)
qCEP  := 0
qEnde := qBair := space(60)
qCida := space(30)

//  Tela CEP
Janela ( 05, 09, 14, 61, mensagem( 'Janela', 'CEP', .f. ), .t. )

setcolor ( CorJanel + ',' + CorCampo )
@ 07,11 say '      CEP'

@ 09,11 say 'Descrição'
@ 10,11 say '   Bairro'
@ 11,11 say '   Cidade                               UF'

MostOpcao( 13, 11, 23, 37, 50 ) 
tCEPe := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de CEP
select CEPeARQ
set order to 1
if lOpenCEPe
  dbgobottom ()
endif  
do while .t.
  select CEPeARQ
  set order to 1

  Mensagem('CEPe', 'Janela' )

  restscreen( 00, 00, 23, 79, tCEPe )
  cStat := space(4)
  MostCEPe()
  
  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostCEPe'
  cAjuda   := 'CEPe'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  if lastkey() == K_ALT_A
    qCEP := CEP 
  else    
    @ 07,21 get qCEP               pict '99999-999'
    read
  endif  
       
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. qCEP == 0
    exit
  endif
  
  //  Verificar existencia do CEP para Incluir ou Alterar
  select CEPeARQ
  set order to 1
  dbseek( str( qCEP ), .f. )
  if eof()
    cStat :=  'incl'
  else
    cStat :=  'alte'
  endif

  Mensagem ('CEPe', cStat )
  
  MostCEPe ()
  EntrCEPe ()

  Confirmar( 13, 11, 23, 37, 50, 3 ) 

  if cStat == 'excl'
    ExclRegi ()
  endif

  if cStat == 'prin'
    PrinCEPe(.f.)
  endif  
    
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace CEP          with qCEP
        dbunlock ()
      endif
    endif
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Ende         with qEnde
      replace Bair         with qBair
      replace Cida         with qCida
      replace UF           with cUF  
      dbunlock ()
    endif
  endif
enddo 

if lOpenCEPe
  select CEPeARQ
  close 
endif
return NIL

//
// Entra Dados do CEP
//
function EntrCEPe ()
  local GetList := {}
  
  do while .t.
    lAlterou := .f.

    setcolor ( CorJanel + ',' + CorCampo )
    @ 09,21 get qEnde                    pict '@S40'
    @ 10,21 get qBair                    pict '@S25'
    @ 11,21 get qCida                    pict '@S25'
    @ 11,54 get cUF                      pict '@!' valid ValidUF( 11, 54, "CEPeARQ" )
    read
    
    if qEnde     != Ende; lAlterou := .t.
    elseif qBair != Bair; lAlterou := .t.
    elseif qCida != Cida; lAlterou := .t.
    elseif cUF   != UF;   lAlterou := .t.
    endif
    
    if !Saindo(lAlterou)
      loop
    endif
    exit
  enddo  
return NIL

//
// Mostra Dados do CEP
//
function MostCEPe ()
  setcolor ( CorCampo )
  if cStat != 'incl' 
    qCEP := CEP 

    @ 07,21 say qCEP                   pict '99999-999'
  endif
  
  qEnde := Ende
  qCida := Cida
  qBair := Bair
  cUF   := UF
        
  @ 09,21 say qEnde                    pict '@S40'
  @ 10,21 say qBair                    pict '@S25'
  @ 11,21 say qCida                    pict '@S25'
  @ 11,54 say cUF                      pict '@!'
 
  PosiDBF( 05, 61 )
return NIL

//
// Imprime dados do CEP
//
function PrinCEPe( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "CEPeARQ", .t. )
      VerifIND( "CEPeARQ" )

      #ifdef DBF_NTX
        set index to CEPeIND1, CEPeIND2, CEPeIND3
      #endif    
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 06, 27, 10, 52, mensagem( 'Janela', 'PrinCEP', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,30 say 'CEP Inicial'
  @ 09,30 say '  CEP Final'

  select CEPeARQ
  set order to 1
  dbgotop ()
  nCEPeIni := 0
  nCEPeFin := 99999999

  @ 08,41 get nCEPeIni    pict '9999'
  @ 09,41 get nCEPeFin    pict '9999'
  read
  
  if lastkey () == K_ESC
    select CEPeARQ
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
  lInicio  := .t.

  select CEPeARQ
  set order to 1
  dbseek( str( nCEPeIni ), .t. )
  do while CEPe >= nCEPeIni .and. CEPe <= nCEPeFin .and. !eof()
    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on

      lInicio := .f.
    endif  
    
    if nLin == 0
      Cabecalho( 'CEP', 132, 6 )
      CabCEPe()
    endif
      
    @ nLin, 01 say CEPe                 pict '99999-999'
    @ nLin, 11 say Ende                 pict '@S40'
    @ nLin, 52 say cBair                pict '@S20'  
    @ nLin, 73 say cCida                pict '@S20'  
    @ nLin, 94 say cUF                  pict '@!'
    nLin ++

    if nLin >= pLimite
      Rodape(132) 

      cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
      cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

      set printer to ( cArqu2 )
      set printer on
    endif

    dbskip ()
  enddo
  
  if !lInicio
    Rodape(132)
  endif  
 
  set printer to
  set printer off
  set device  to screen

  if Imprimir( cArqu3, 132 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Relatório de CEP"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 132
      replace Empr       with cEmpresa
      dbunlock ()
    endif
    close
  endif  

  select CEPeARQ
  if lAbrir
    close
  else
    set order to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
  return NIL
return NIL

function CabCEPe ()
  @ 02,01 say 'CEP       Endereço                                 Bairro               Cidade               UF' 

  nLin := 4
retur NIL

//
// Mostra os CEP
//
function ConsCEP()

  local cArquivo  := alias()  
  local tMostra   := savescreen( 00, 00, 24, 79 )

  if NetUse( "CEPeARQ", .t. )
    VerifIND( "CEPeARQ" )
  
    lAbriCEPe := .t.

    #ifdef DBF_NTX
      set index to CEPeIND1, CEPeIND2, CEPeIND3, CEPeIND4
    #endif  
  else
    lAbriCEPe := .f.  
  endif

  select CEPeARQ
  set order to 2
  dbgotop ()

  Janela( 03, 02, 20, 76, mensagem( 'Janela', 'ConsCEP', .f. ), .f. ) 
  setcolor ( CorJanel + ',' + CorCampo )

  oCEP         := TBrowseDb( 05, 03, 18, 75 )
  oCEP:headsep := chr(194)+chr(196)
  oCEP:footsep := chr(193)+chr(196)
  oCEP:colsep  := chr(179)

  oCEP:addColumn( TBColumnNew("CEP",       {|| transform( CEP, '99999-999' ) } ) )
  oCEP:addColumn( TBColumnNew("Descrição", {|| left( Ende, 30 ) } ) )
  oCEP:addColumn( TBColumnNew("Bairro",    {|| left( Bair, 15 ) } ) )
  oCEP:addColumn( TBColumnNew("Cidade",    {|| left( Cida, 15 ) } ) )
  oCEP:addColumn( TBColumnNew("UF",        {|| UF } ) )
            
  lExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ''
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 06, 18, 76, nTotal )
    
  oCEP:freeze := 1
  oCEP:colPos := 2
   
  setcolor ( CorCampo )
  @ 19,13 say space(50)
    
  setcolor( CorJanel + ',' + CorCampo )
  @ 19,04 say 'Consulta'
  @ 06,02 say chr(195)
  @ 18,02 say chr(195)

  do while !lExitRequested
    Mensagem( 'LEVE', 'Browse' )

    oCEP:forceStable()
    
    PosiDBF( 03, 76 )
        
    iif( BarraSeta, BarraSeta( nLinBarra, 06, 18, 76, nTotal ), NIL )

    if oCEP:stable
      if oCEP:hitTop .or. oCEP:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
    
    do case
      case cTecla == K_DOWN;        oCEP:down()
      case cTecla == K_UP;          oCEP:up()
      case cTecla == K_PGDN;        oCEP:pageDown()
      case cTecla == K_PGUP;        oCEP:pageUp()
      case cTecla == K_CTRL_PGUP;   oCEP:goTop()
      case cTecla == K_CTRL_PGDN;   oCEP:goBottom()
      case cTecla == K_RIGHT;       oCEP:right()
      case cTecla == K_LEFT;        oCEP:left()
      case cTecla == K_HOME;        oCEP:home()
      case cTecla == K_END;         oCEP:end()
      case cTecla == K_CTRL_LEFT;   oCEP:panLeft()
      case cTecla == K_CTRL_RIGHT;  oCEP:panRight()
      case cTecla == K_CTRL_HOME;   oCEP:panHome()
      case cTecla == K_CTRL_END;    oCEP:panEnd()
      case cTecla == K_ENTER
        lOk            := .t.
        lExitRequested := .t.
      case cTecla == K_ESC;         lExitRequested := .t.
      case cTecla == K_ALT_A;       tAlte          := savescreen( 00, 00, 23, 79 )
        CEPe (.t.)
        
        select CEPeARQ
        set order to 2
        dbseek(CEPeARQ->Ende,.f.)

        oCEP:refreshAll()

        restscreen( 00, 00, 23, 79, tAlte )

        lExitRequested := .f.        
        cLetra         := ''
      case cTecla == K_INS
        tAlte := savescreen( 00, 00, 23, 79 )
        
        CEPe (.f.)
        
        select CEPeARQ
        set order to 2
        dbseek(CEPeARQ->Ende,.f.)

        oCEP:refreshAll()

        restscreen( 00, 00, 23, 79, tAlte )

        lExitRequested := .f.        
        cLetra         := ''
      case cTecla == K_BS
        cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
      
        setcolor ( CorCampo )
        @ 19,13 say space(50)
        @ 19,13 say cLetra
      case cTecla >= 32 .and. cTecla <= 128
        lLetra := .f.
      
        do case
          case oCEP:ColPos == 1;       lLetra := .t.   
            set order to 1
          case oCEP:ColPos == 2;       lLetra := .t.     
            set order to 2
          case oCEP:ColPos == 3;       lLetra := .t.     
            set order to 3
          case oCEP:ColPos == 4;       lLetra := .t.     
            set order to 4
        endcase
        
        if lLetra     
          cLetra += chr( cTecla )    

          if len( cLetra ) > 50
            cLetra := ''
          endif  
     
          setcolor ( CorCampo )
          @ 19,13 say space(50)
          @ 19,13 say cLetra
         
          dbseek( cLetra, .t. )
        endif  

        oCEP:refreshAll()
    endcase
    
    select CEPeARQ
  enddo

  if lAbriCEPe 
    select CEPeARQ
    close
  endif  

  restscreen( 00, 00, 24, 79, tMostra )
return NIL