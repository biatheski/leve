//  Leve, Portadores
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

function Port( xAlte )
  local GetList := {}
  
if SemAcesso( 'Port' )
  return NIL
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

//  Variaveis de Entrada
cCoPo := space(04)
nPort := 0
cNoPo := space(30)

//  Tela Port
Janela ( 06, 05, 13, 62, mensagem( 'Janela', 'Port', .f. ), .t. )

setcolor ( CorJanel + ',' + CorCampo )
@ 08,10 say '   Codigo'
@ 10,10 say 'Descrição'

MostOpcao( 12, 07, 19, 38, 51 ) 
tPort := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Port
select PortARQ
set order to 1
if lOpenPort
  dbgobottom ()
endif  
do while .t.
  select PortARQ
  set order to 1

  Mensagem('Port', 'Janela' )

  restscreen( 00, 00, 23, 79, tPort )
  cStat := space(4)
  MostPort()
  
  if Demo ()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostPort'
  cAjuda   := 'Port'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  if lastkey() == K_ALT_A
    nPort := val( Port )
  else    
    if xAlte 
      @ 08,20 get nPort              pict '999999'
      read
    else
      nPort := 0
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
  cCoPo := strzero( nPort, 6 )
  @ 08,20 say cCoPo
  
  //  Verificar existencia do Lancamento para Incluir ou Alterar
  select PortARQ
  set order to 1
  dbseek( cCoPo, .f. )
  if eof()
    cStat :=  'incl'
  else
    cStat :=  'alte'
  endif

  Mensagem( 'Port', cStat )
  
  MostPort ()
  EntrPort ()

  Confirmar( 12, 07, 19, 38, 51, 3 )

  if cStat == 'excl'
    ExclRegi ()
  endif

  if cStat == 'prin'
    PrinPort(.f.)
  endif  
    
  if cStat == 'incl'
    if cCoPo == '000000'
      cCoPo := '000001'
    endif    

    set order to 1  
    do while .t.
      dbseek( cCoPo, .f. )
      if found()
        nPort := val( cCoPo ) + 1               
        cCoPo := strzero( nPort, 6 )
      else 
        exit   
      endif
    enddo

    if AdiReg()
      if RegLock()
        replace Port         with cCoPo
        dbunlock ()
      endif
    endif
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Nome         with cNoPo
      dbunlock ()
    endif
    
    if !xAlte
      xAlte := .t.
      keyboard(chr(27))
    endif  
  endif
enddo

if lOpenPort
  select PortARQ
  close 
endif

return NIL

//
// Entra Dados do Portador
//
function EntrPort ()
  local GetList := {}
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,20 get cNoPo                valid !empty( cNoPo )
  read
return NIL

//
// Mostra Dados do Portador
//
function MostPort ()
  if cStat != 'incl' 
    cCoPo := Port
    nPort := val( Port )
  endif
  
  cNoPo := Nome
      
  setcolor ( CorCampo )
  @ 10,20 say cNoPo
  
  PosiDBF( 06, 62 )
return NIL

//
// Imprime dados do Portador
//
function PrinPort( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "PortARQ", .t. )
      VerifIND( "PortARQ" )

      #ifdef DBF_NTX
        set index to PortIND1, PortIND2
      #endif
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 06, 27, 10, 56, mensagem( 'Janela ', 'PrinPort', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,30 say 'Portador Inicial'
  @ 09,30 say '  Portador Final'

  select PortARQ
  set order to 1
  dbgotop ()
  nPortIni := val( Port )
  dbgobottom ()
  nPortFin := val( Port )

  @ 08,47 get nPortIni    pict '999999'        valid ValidARQ( 99, 99, "PortARQ", "Código" , "Port", "Descrição", "Nome", "Port", "nPortIni", .t., 6, "Consulta de Portadores", "PortARQ", 40 )
  @ 09,47 get nPortFin    pict '999999'        valid ValidARQ( 99, 99, "PortARQ", "Código" , "Port", "Descrição", "Nome", "Port", "nPortFin", .t., 6, "Consulta de Portadores", "PortARQ", 40 ) .and. nPortFin >= nPortIni  
  read
  
  if lastkey () == K_ESC
    select PortARQ
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

  cPortIni := strzero( nPortIni, 6 )
  cPortFin := strzero( nPortFin, 6 )
  lInicio  := .t.

  select PortARQ
  set order to 1
  dbseek( cPortIni, .t. )
  do while Port >= cPortIni .and. Port <= cPortFin .and. !eof()
    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on

      lInicio := .f.
    endif  
    
    if nLin == 0
      Cabecalho( 'Portadores', 80, 3 )
      CabPort()
    endif
      
    @ nLin, 05 say Port                 pict '999999'
    @ nLin, 12 say Nome
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
      replace Titu       with "Relatório de Portadores"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
    close
  endif  

  select PortARQ
  if lAbrir
    close
  else
    set order to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
  return NIL
return NIL

function CabPort ()
  @ 02,01 say 'Portador Descrição'

  nLin := 4
retur NIL

//
// Consulta de Contas a Receber Todas
//
function ConsTodas ()
  if NetUse( "PortARQ", .t. )
    VerifIND( "PortARQ" )
  
    jOpenPort := .t.

    #ifdef DBF_NTX
      set index to PortIND1, PortIND2
    #endif
  else
    jOpenPort := .f.
  endif

  if NetUse( "CobrARQ", .t. )
    VerifIND( "CobrARQ" )
  
    jOpenCobr := .t.

    #ifdef DBF_NTX
      set index to CobrIND1, CobrIND2
    #endif
  else
    jOpenCobr := .f.
  endif

  if NetUse( "ReceARQ", .t. )
    VerifIND( "ReceARQ" )
  
    jOpenRece := .t.

    #ifdef DBF_NTX
      set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
    #endif
  else 
    select ReceARQ
    
    nRegistrs := recno()
    jOpenRece := .f.
  endif

  cClients    := ClieARQ->Clie
  nTotalPago  := nTotalPagar := 0
  nOtimo      := nBom        := 0
  aPortador   := {}
  aCobrador   := {}
  nRegular    := 0
  lCalcJuro   := .t.
  
  select ReceARQ
  set order    to 5
  set relation to Cobr into CobrARQ, to Port into PortARQ
  dbseek( cClients, .t. )
  
  do while Clie == cClients .and. !eof()
    if !empty( Pgto )
      nDias := Pgto - Vcto
      
      if nDias < 20
        nOtimo ++
      endif
      
      if nDias >= 21 .and. nDias <= 40
        nBom ++
      endif
      
      if nDias >= 41
        nRegular ++
      endif
              
      nTotalPago += Pago
    else
      if date() - Vcto > 20
        nRegular ++
      endif  
      
      nTotalPagar += Valor
    endif  

    nPortElem := ascan( aPortador, { |nElem| nElem[1] == Port } )
      
    if nPortElem > 0
      aPortador[ nPortElem, 3 ] += 1
    else
      aadd( aPortador, { Port, PortARQ->Nome, 1 } ) 
    endif  

    nCobrElem := ascan( aCobrador, { |nElem| nElem[1] == Cobr } )
      
    if nCobrElem > 0
      aCobrador[ nCobrElem, 3 ] += 1
    else
      aadd( aCobrador, { Cobr, CobrARQ->Nome, 1 } ) 
    endif  

    dbskip ()
  enddo      
  
  if nTotalPago == 0 .and. nTotalPagar == 0
    if jOpenPort
      select PortARQ
      close
    endif  

    if jOpenCobr
      select CobrARQ
      close
    endif  
  
    if jOpenRece
      select ReceARQ
      close
    else
      select ReceARQ
      set order to 1
      go nRegistrs
    endif  
  
    select ClieARQ
    set order to 2

    return NIL
  endif  
               
  tTelaRcto := savescreen( 00, 00, 23, 79 )

  Janela ( 03, 01, 20, 75, mensagem( 'Janela', 'ConsTodas', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )

  select ReceARQ
  set order to 5
  bFirst := {|| dbseek( cClients, .t. ) }
  bLast  := {|| dbseek( cClients, .t. ), dbskip(-1) }
  bFor   := {|| Clie == cClients }
  bWhile := {|| Clie == cClients }
  
  oTodas          := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oTodas:nTop     := 7
  oTodas:nLeft    := 2
  oTodas:nBottom  := 18
  oTodas:nRight   := 74
  oTodas:headsep  := chr(194)+chr(196)
  oTodas:colsep   := chr(179)
  oTodas:footsep  := chr(193)+chr(196)

  oTodas:addColumn( TBColumnNew("Nota",  {|| transform( val( Nota ), '999999-99' ) } ) )
  oTodas:addColumn( TBColumnNew("Emis.", {|| Emis } ) )
  oTodas:addColumn( TBColumnNew("Vcto.", {|| Vcto } ) )
  oTodas:addColumn( TBColumnNew("Pgto.", {|| Pgto } ) )
  oTodas:addColumn( TBColumnNew("Valor", {|| transform( Valor, '@E 999,999.99' ) } ) )
  oTodas:addColumn( TBColumnNew("Juros", {|| transform( VerJuro(), '@E 9,999.99' ) } ) )
  oTodas:addColumn( TBColumnNew("Pago",  {|| transform( Pago, '@E 999,999.99' ) } ) )
  oTodas:addColumn( TBColumnNew("Portador", {|| left( PortARQ->Nome, 20 ) + ' ' + Port } ) )
  oTodas:addColumn( TBColumnNew("Cobrador", {|| left( CobrARQ->Nome, 20 ) + ' ' + Cobr } ) )
  
  lAdiciona      := .f.
  lMais          := .t.
  lExitRequested := .f.
  nLinBarra      := 1
  cSequ          := space(2)
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 8, 18, 75, nTotal )

  setcolor( CorJanel + ',' + CorCampo )
  @ 08,01 say chr(195)
  @ 18,01 say chr(195)
  @ 05,10 say 'Cliente'

  @ 19,05 say 'Total Pago'
  @ 19,52 say 'Total Pagar'
  
  setcolor( CorCampo )
  @ 05,18 say cClients
  @ 05,25 say ClieARQ->Nome
  
  if nOtimo > nBom .and. nOtimo > nRegular
    @ 05,64 say 'Otimo'
  endif
  
  if nBom >= nOtimo .and. nBom >= nRegular
    @ 05,64 say 'Bom'
  endif
  
  if nRegular > nOtimo .and. nRegular > nBom
    @ 05,64 say 'Regular'
  endif
  
  @ 19,16 say nTotalPago                 pict '@E 999,999.99'
  @ 19,64 say nTotalPagar                pict '@E 999,999.99'

/*  
  if len( aCobrador ) > 0 .or. len( aPortador ) > 0
    tTelas := savescreen( 00, 00, 23, 79 )

    oTodas:refreshAll()
    oTodas:forcestable() 
  
    Janela( 04, 08, 14, 64, 'Resumo...', .f. )
    Mensagem( 'Consulta do resumo de contas a receber, tecle <ENTER> para continuar...')
    setcolor( CorJanel + ',' + CorCampo )
    @ 06,10 say 'Portador            Qtde.   Cobrador            Qtde.'
    
    nLinn := 7
    nTota := 0
    
    for nL := 1  to len( aPortador )
      @ nLinn,10 say aPortador[ nL, 1 ] + " " + left( aPortador[ nL, 2 ], 15 ) 
      @ nLinn,31 say aPortador[ nL, 3 ]                         pict '9999'
      nLinn ++
      nTota += aPortador[ nL, 3 ]
    next
   
    if nTota > 0
      @ nLinn,25 say 'Total'
      @ nLinn,31 say nTota       pict '9999'
    endif 

    nLinn := 7
    nTota := 0
    
    for nL := 1  to len( aCobrador )
      @ nLinn,38 say aCobrador[ nL, 1 ] + " " + left( aCobrador[ nL, 2 ], 20 )
      @ nLinn,59 say aCobrador[ nL, 3 ]                         pict '9999'
      nLinn ++
      nTota += aCobrador[ nL, 3 ]
    next
   
    if nTota > 0
      @ nLinn,53 say 'Total'
      @ nLinn,59 say nTota       pict '9999'
    endif 
    
    Teclar(0)
        
    restscreen( 00, 00, 23, 79, tTelas )
  endif  
*/
  oTodas:refreshAll()

  do while !lExitRequested
    Mensagem( 'Port', 'ConsTodas' )

    oTodas:forcestable() 
    
    PosiDBF( 03, 75 )

    iif( BarraSeta, BarraSeta( nLinBarra, 8, 18, 75, nTotal ), NIL )
    
    if oTodas:stable
      if oTodas:hitTop .or. oTodas:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oTodas:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oTodas:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oTodas:down()
      case cTecla == K_UP;         oTodas:up()
      case cTecla == K_PGDN;       oTodas:pageDown()
      case cTecla == K_PGUP;       oTodas:pageUp()
      case cTecla == K_CTRL_PGUP;  oTodas:goTop()
      case cTecla == K_CTRL_PGDN;  oTodas:gobottom()
      case cTecla == K_RIGHT;      oTodas:right()
      case cTecla == K_LEFT;       oTodas:left()
      case cTecla == K_HOME;       oTodas:home()
      case cTecla == K_END;        oTodas:end()
      case cTecla == K_CTRL_LEFT;  oTodas:panLeft()
      case cTecla == K_CTRL_RIGHT; oTodas:panRight()
      case cTecla == K_CTRL_HOME;  oTodas:panHome()
      case cTecla == K_CTRL_END;   oTodas:panEnd()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_ENTER;      lExitRequested := .t.
      case cTecla == K_F1
        tAjud := savescreen( 00, 00, 23, 79 )
        Janela( 04, 13, 09, 60, mensagem( 'Janela', 'ConsTodas1', .f. ), .f. )
        setcolor( CorJanel )
        @ 06,15 say 'Pagamento at‚ com 20 dias de atraso  Otimo'
        @ 07,15 say 'Pagamento entre 21 a 40 dias atraso  Bom'              
        @ 08,15 say '  Pagamento com mais 41 dias atraso  Regular'
        Teclar(0)
        restscreen( 00, 00, 23, 79, tAjud )
    endcase
  enddo  
    
  if jOpenRece
    select ReceARQ
    close
  else
    select ReceARQ
    set order to 1
    go nRegistrs
  endif  
  
  select ClieARQ
  set order to 2
  
  restscreen( 00, 00, 23, 79, tTelaRcto )
return NIL