//  Leve, Controle de Veiculos
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

function Veic( xAlte )
  local GetList := {}
  
if SemAcesso( 'Veic' )
  return NIL
endif  

if NetUse( "VeicARQ", .t. )
  VerifIND( "VeicARQ" )
  
  lOpenVeic := .t.

  #ifdef DBF_NTX
    set index to VeicIND1, VeicIND2
  #endif
else
  lOpenVeic := .f.
endif

//  Variaveis de Entrada
cCoVe  := space(04)
nVeic  := 0
cNoVe  := space(30)
cPlaca := space(12)

//  Tela Veic
Janela ( 06, 05, 14, 62, mensagem( 'Janela', 'Veic', .f. ), .t. )

setcolor ( CorJanel + ',' + CorCampo )
@ 08,10 say '   Codigo'
@ 10,10 say 'Descrição'
@ 11,10 say '    Placa'

MostOpcao( 13, 07, 19, 38, 51 ) 
tVeic := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Veic
select VeicARQ
set order to 1
if lOpenVeic
  dbgobottom ()
endif  
do while .t.
  select VeicARQ
  set order to 1

  restscreen( 00, 00, 23, 79, tVeic )

  Mensagem('Veic', 'Janela' )

  cStat := space(4)
  MostVeic()
  
  if Demo ()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostVeic'
  cAjuda   := 'Veic'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  if lastkey() == K_ALT_A
    nVeic := val( Veic )
  else    
    if xAlte 
      @ 08,20 get nVeic              pict '999999'
      read
    else
      nVeic := 0
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
  
  cCoVe := strzero( nVeic, 6 )
  setcolor( CorCampo )
  @ 08,20 say cCoVe
  
  //  Verificar existencia do Lancamento para Incluir ou Alterar
  select VeicARQ
  set order to 1
  dbseek( cCoVe, .f. )
  if eof()
    cStat :=  'incl'
  else
    cStat :=  'alte'
  endif
  
  Mensagem ('Veic', cStat )

  MostVeic ()
  EntrVeic ()

  Confirmar( 13, 07, 19, 38, 51, 3 )

  if cStat == 'excl'
    ExclRegi ()
  endif

  if cStat == 'prin'
    PrinVeic(.f.)
  endif  
    
  if cStat == 'incl'
    if cCoVe == '000000'
      cCoVe := '000001'
    endif    

    set order to 1  
    do while .t.
      dbseek( cCoVe, .f. )
      if found()
        nVeic := val( cCoVe ) + 1               
        cCoVe := strzero( nVeic, 6 )
      else 
        exit   
      endif
    enddo

    if AdiReg()
      if RegLock()
        replace Veic         with cCoVe
        dbunlock ()
      endif
    endif
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Nome         with cNoVe
      replace Placa        with cPlaca
      dbunlock ()
    endif
    
    if !xAlte
      xAlte := .t.
      keyboard(chr(27))
    endif  
  endif
enddo

if lOpenVeic
  select VeicARQ
  close 
endif

return NIL

//
// Entra Dados do Lançamento de Veiculo
//
function EntrVeic ()
  local GetList := {}
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,20 get cNoVe                valid !empty( cNoVe )
  @ 11,20 get cPlaca
  read
return NIL

//
// Mostra Dados do Veiculo 
//
function MostVeic ()
  if cStat != 'incl' 
    cCoVe := Veic
    nVeic := val( Veic )
  endif
  
  cNoVe  := Nome
  cPlaca := Placa
      
  setcolor ( CorCampo )
  @ 10,20 say cNoVe
  @ 11,20 say cPlaca
  
  PosiDBF( 06, 62 )
return NIL

//
// Imprime dados do Veiculo
//
function PrinVeic( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "VeicARQ", .t. )
      VerifIND( "VeicARQ" )

      #ifdef DBF_NTX
        set index to VeicIND1, VeicIND2
      #endif
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 06, 27, 10, 56, mensagem( 'Janela', 'PrinVeic', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,30 say 'Veiculo Inicial'
  @ 09,30 say '  Veiculo Final'

  select VeicARQ
  set order to 1
  dbgotop ()
  nVeicIni := val( Veic )
  dbgobottom ()
  nVeicFin := val( Veic )

  @ 08,46 get nVeicIni    pict '999999'      valid ValidARQ( 99, 99, "VeicARQ", "Código" , "Veic", "Descrição", "Nome", "Veic", "nVeicIni", .t., 6, "Consulta de Veiculos", "VeicARQ", 40 )    
  @ 09,46 get nVeicFin    pict '999999'      valid ValidARQ( 99, 99, "VeicARQ", "Código" , "Veic", "Descrição", "Nome", "Veic", "nVeicFin", .t., 6, "Consulta de Veiculos", "VeicARQ", 40 ) .and. nVeicFin >= nVeicIni
  read
  
  if lastkey () == K_ESC
    select VeicARQ
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

  cVeicIni := strzero( nVeicIni, 6 )
  cVeicFin := strzero( nVeicFin, 6 )

  select VeicARQ
  set order  to 1
  dbseek( cVeicIni, .t. )
  do while Veic >= cVeicIni .and. Veic <= cVeicFin .and. !eof()
    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
      
      lInicio := .f.
    endif
      
    if nLin == 0
      Cabecalho( 'Veiculo', 80, 3 )
      CabVeic()
    endif
      
    @ nLin, 01 say Veic                 pict '999999'
    @ nLin, 12 say Nome
    @ nLin, 50 say Placa
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
      replace Titu       with "Relatório de Veiculo"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
    close
  endif  

  select VeicARQ
  if lAbrir
    close
  else
    set order to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
  return NIL
return NIL

function CabVeic ()
  @ 02,01 say 'Veículo  Descrição                                     Placa'

  nLin := 4
retur NIL

//
// Consulta Todas Contas a Receber 
//
function ConsReceber ()
  local cCorAtual := setcolor()
  
  if NetUse( "ReprARQ", .t. )
    VerifIND( "ReprARQ" )
  
    aOpenRepr := .t.

    #ifdef DBF_NTX
      set index to ReprIND1, ReprIND2
    #endif
  else
    aOpenRepr := .f.
  endif
  
  if NetUse( "ReceARQ", .t. )
    VerifIND( "ReceARQ" )
   
    aOpenRece := .t.

    #ifdef DBF_NTX
      set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
    #endif
  else
    aOpenRece := .f.
  endif

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )
  
    aOpenClie := .t.

    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
    #endif
  else
    aOpenClie := .f.  
  endif
  
  rTotalGeral := rSubTotal   := 0
  dVctoIni    := ctod( '01/01/1990' )
  dVctoFin    := ctod( '31/12/2015' )
  tTelaRcto   := savescreen( 00, 00, 23, 79 )
  dData       := dtos( ctod( '  /  /  ' ) )
  lCalcJuro   := .t.
  
  if EmprARQ->Periodo == "X"
    Janela( 09, 24, 13, 50, mensagem( 'LEVE', 'Periodo', .f. ), .f. )
    Mensagem( 'Veic', 'ConsTodas' )

    setcolor( CorJanel )
    @ 11,26 say 'Vcto. Inicial'
    @ 12,26 say '  Vcto. Final'
  
    @ 11,40 get dVctoIni      pict '99/99/9999'
    @ 12,40 get dVctoFin      pict '99/99/9999' valid dVctoFin >= dVctoIni
    read
    
    if lastkey() == K_ESC
      if aOpenClie
        select ClieARQ
        close
      endif  
  
      if aOpenRece 
        select ReceARQ
        close
      endif  
  
      if aOpenRepr 
        select ReprARQ
        close
      endif  
    
      restscreen( 00, 00, 23, 79, tTelaRcto )
      return NIL
    endif  
  endif  
  
  select ReceARQ
  set order to 3
  dbseek( dData, .t. )
  
  do while empty( Pgto ) .and. !eof ()
    if !empty( dVctoIni )
      if Vcto >= dVctoIni .and. Vcto <= dVctoFin
        rTotalGeral += ( ( Valor - Desc ) + VerJuro() )
      endif  
    endif
    dbskip ()
  enddo      
  
  if rTotalGeral == 0
    Alerta( mensagem( 'Alerta', 'ConsTodas', .f. ) )
  
    if aOpenRece 
      select ReceARQ
      close
    endif  
  
    if aOpenRepr 
      select ReprARQ
      close
    endif  
 
    if aOpenClie
      select ClieARQ
      close
    endif  
    
    restscreen( 00, 00, 23, 79, tTelaRcto )

    return NIL
  endif  
    
  Janela ( 03, 01, 20, 76, mensagem( 'Janela', 'ConsTodas', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )
  
  select ClieARQ
  set order to 1
  
  select ReprARQ
  set order to 1

  select ReceARQ
  set order    to 3
  set relation to Clie into ClieARQ, to Repr into ReprARQ
  
  bFirst := {|| dbseek( dData, .t. ) }
  bLast  := {|| dbseek( dData, .t. ), dbskip(-1) }
  bWhile := {|| empty( Pgto ) }
  bFor   := {|| empty( Pgto ) .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin }
  
  oReceber         := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oReceber:nTop    := 5
  oReceber:nLeft   := 2
  oReceber:nBottom := 18
  oReceber:nRight  := 75
  oReceber:headsep := chr(194)+chr(196)
  oReceber:colsep  := chr(179)
  oReceber:footsep := chr(193)+chr(196)

  oReceber:addColumn( TBColumnNew(" ",       {|| Marc } ) )
  oReceber:addColumn( TBColumnNew("Cliente", {|| iif( Clie == '999999', left( Cliente, 15 ), left( ClieARQ->Nome, 15 ) ) + ' ' + Clie } ) )
  oReceber:addColumn( TBColumnNew("Nota",    {|| transform( val( Nota ), '999999-99' ) } ) )
  oReceber:addColumn( TBColumnNew("Tipo",    {|| iif( Tipo == 'P', 'Pedido', iif( Tipo == 'N', 'Nota  ','O.S.  ' ) ) } ) )
  oReceber:addColumn( TBColumnNew("Emis.",   {|| Emis } ) )
  oReceber:addColumn( TBColumnNew("Vcto.",   {|| Vcto } ) )
  oReceber:addColumn( TBColumnNew("Total",   {|| transform( VerTotal(), '@E 99,999.99' ) } ) )
  oReceber:addColumn( TBColumnNew("Valor",   {|| transform( Valor, '@E 99,999.99' ) } ) )
  oReceber:addColumn( TBColumnNew("Juros",   {|| transform( VerJuro(), '@E 99,999.99' ) } ) )
              
  lAdiciona      := .f.
  lMais          := .t.
  lExitRequested := .f.
  nLinBarra      := 1
  cSequ          := space(2)
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 6, 18, 76, nTotal )
  
  setcolor( CorJanel + ',' + CorCampo )
  @ 06,01 say chr(195)
  @ 18,01 say chr(195)
  @ 19,05 say 'Sub-Total'
  @ 19,52 say 'Total Geral'
  
  setcolor( CorCampo )
  @ 19,15 say rSubTotal                  pict '@E 999,999.99'
  @ 19,64 say rTotalGeral                pict '@E 999,999.99'

  oReceber:refreshAll()

  do while !lExitRequested
    Mensagem( 'Veic', 'ConsTodas2' ) 
    
    oReceber:forcestable() 

    PosiDBF( 03, 76 )

    iif( BarraSeta, BarraSeta( nLinBarra, 6, 18, 76, nTotal ), NIL )
    
    if oReceber:stable
      if oReceber:hitTop .or. oReceber:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oReceber:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oReceber:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oReceber:down()
      case cTecla == K_UP;         oReceber:up()
      case cTecla == K_PGDN;       oReceber:pageDown()
      case cTecla == K_PGUP;       oReceber:pageUp()
      case cTecla == K_LEFT;       oReceber:left()
      case cTecla == K_RIGHT;      oReceber:right()
      case cTecla == K_CTRL_PGUP;  oReceber:goTop()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_ALT_J
        rTotalGeral := 0
        rSubTotal   := 0
        
        if lCalcJuro
          lCalcJuro := .f.
        else
          lCalcJuro := .t.
        endif    

        select ReceARQ
        set order to 3
        dbseek( dData, .t. )
        do while empty( Pgto ) .and. !eof ()
          rTotalGeral += ( ( Valor - Desc ) + VerJuro() )
          
          if Marc == "X"
            rSubTotal += ( ( Valor - Desc ) + VerJuro() )
          endif
            
          dbskip ()
        enddo      

        setcolor( CorCampo )
        @ 19,15 say rSubTotal                  pict '@E 999,999.99'
        @ 19,64 say rTotalGeral                pict '@E 999,999.99'
        
        oReceber:gotop()           
        oReceber:refreshAll()

        lExitRequested := .f.
      case cTecla == K_ALT_A;   tReceTela   := savescreen( 00, 00, 22, 79 )
        Rcto(.t.)

        rTotalGeral := 0
        rSubTotal   := 0

        restscreen( 00, 00, 22, 79, tReceTela )

        select ReceARQ
        set order to 3
        dbseek( dData, .t. )
        do while empty( Pgto ) .and. !eof ()
          rTotalGeral += ( ( Valor - Desc ) + VerJuro() )
          
          if Marc == "X"
            rSubTotal += ( ( Valor - Desc ) + VerJuro() )
          endif
            
          dbskip ()
        enddo      

        setcolor( CorCampo )
        @ 19,15 say rSubTotal                  pict '@E 999,999.99'
        @ 19,64 say rTotalGeral                pict '@E 999,999.99'
        
        oReceber:gotop()           
        oReceber:refreshAll()

        lExitRequested := .f.
      case cTecla == K_ALT_R
        tReceTela   := savescreen( 00, 00, 22, 79 )
        rTotalGeral := rSubTotal   := 0
        nNota       := val( Nota )
        cNota       := Nota

        nPago       := ( Valor - Desc ) + VerJuro()

        if RegLock()
          replace Marc        with "X"
          replace Pgto        with date ()
          replace Juro        with VerJuro()
          replace Pago        with nPago
          dbunlock()
        endif

        PrinRcbo (.f.)

        restscreen( 00, 00, 22, 79, tReceTela )
        
        select ReceARQ
        set order to 3
        dbseek( dData, .t. )
        do while empty( Pgto ) .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin .and. !eof ()
          rTotalGeral += ( ( Valor - Desc ) + VerJuro() )
           
          if Marc == "X"
            rSubTotal += ( ( Valor - Desc ) + VerJuro() )
          endif
      
          dbskip ()
        enddo      

        setcolor( CorCampo )
        @ 19,15 say rSubTotal                  pict '@E 999,999.99'
        @ 19,64 say rTotalGeral                pict '@E 999,999.99'

        select ReceARQ
        set order to 3
        dbseek( dData, .t. )
        
        oReceber:refreshAll()

        lExitRequested := .f.
      case cTecla == K_SPACE
        if ReceARQ->Marc == ' '
          rSubTotal += ( ( Valor - Desc ) + VerJuro() )
        else  
          rSubTotal -= ( ( Valor - Desc ) + VerJuro() )

          if rSubTotal < 0
            rSubTotal := 0
          endif  
        endif  

        if RegLock()
          if ReceARQ->Marc == ' '
            replace Marc      with "X"
          else
            replace Marc      with ' '
          endif    
          dbunlock ()
        endif  
        
        setcolor( CorCampo )
        @ 19,15 say rSubTotal                  pict '@E 999,999.99'
        
        oReceber:refreshAll()
      case cTecla == K_ALT_P
        tAlte := savescreen( 00, 00, 24, 79 )         
        Janela( 06, 20, 12, 55, mensagem( 'Janela', 'Atencao', .f. ), .t. )          
        setcolor( CorJanel )
        @ 08,22 say 'Vocˆ tem certeza que gostaria de'
        @ 09,22 say 'fazer o Recebimento autom tico ?'

        if ConfLine( 11, 43, 1 )
          rTotalGeral := 0
          rSubTotal   := 0
          aNotas      := {}
       
          select ReceARQ
          set order to 3
          dbseek( dData, .t. )
          do while empty( Pgto ) .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin .and. !eof ()
            if empty( Marc )
              dbskip ()
              loop
            else  
              aadd( aNotas, recno() )
            endif  
            dbskip ()
          enddo
        
          for nH := 1 to len( aNotas )
            go aNotas[ nH ]
            if RegLock()
              replace Marc       with space(01)
              replace Pgto       with date()
              replace Pago       with ( Valor - Desc ) + Juro 
              dbunlock ()
            endif
          next  
          
          select ReceARQ
          set order to 3
          dbseek( dData, .t. )
          do while empty( Pgto ) .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin .and. !eof ()
            rTotalGeral += ( ( Valor - Desc ) + VerJuro() )
             
            if Marc == "X"
              rSubTotal += ( ( Valor - Desc ) + VerJuro() )
            endif
      
            dbskip ()
          enddo      

          setcolor( CorCampo )
          @ 19,15 say rSubTotal                  pict '@E 999,999.99'
          @ 19,64 say rTotalGeral                pict '@E 999,999.99'
        
          dbseek( dData, .t. )
        endif
        
        restscreen( 00, 00, 23, 79, tAlte )  
        
        oReceber:refreshAll()
      case cTecla == K_ALT_F
        tSele := savescreen( 00, 00, 23, 79 )
        Janela( 09, 24, 13, 51, mensagem( 'LEVE', 'Periodo', .f. ), .f. )
        Mensagem( 'Veic', 'ConsTodas' )

        setcolor( CorJanel )
        @ 11,26 say 'Vcto. Inicial'
        @ 12,26 say '  Vcto. Final'
  
        dVctoFin := date()

        @ 11,40 get dVctoIni      pict '99/99/9999'
        @ 12,40 get dVctoFin      pict '99/99/9999' valid dVctoFin >= dVctoIni
        read

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tSele )
          dVctoFin := ctod( '31/12/2015' )
          loop
        endif
        
        rTotalGeral := 0
        rSubTotal   := 0
          
          select ReceARQ
          set order to 3
          dbgotop()
          do while !eof ()
            if empty( Pgto ) .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin
              rTotalGeral += ( ( Valor - Desc ) + VerJuro() )
             
              if Marc == "X"
                rSubTotal += ( ( Valor - Desc ) + VerJuro() )
              endif
            endif  
            dbskip ()
          enddo      
        restscreen( 00, 00, 23, 79, tSele ) 

          setcolor( CorCampo )
          @ 19,15 say rSubTotal                  pict '@E 999,999.99'
          @ 19,64 say rTotalGeral                pict '@E 999,999.99'
        
          dbseek( dData, .t. )


        setcolor( CorCampo )
        @ 19,15 say rSubTotal                  pict '@E 999,999.99'
        @ 19,64 say rTotalGeral                pict '@E 999,999.99'
        
        oReceber:gotop()
        oReceber:refreshAll()
    endcase
  enddo  

  select ReceARQ
  set order to 8
  dbgotop()
  do while .t.
    dbseek( "X", .f. )
    
    if found () 
      if RegLock()
        replace Marc         with space(01)
        dbunlock ()
      endif
    else
      exit
    endif    
  enddo      
  
  if aOpenRece 
    select ReceARQ
    close
  endif  

  if aOpenRepr 
    select ReprARQ
    close
  endif  
  
  if aOpenClie
    select ClieARQ
    close
  endif  
  
  setcolor( cCorAtual )
  restscreen( 00, 00, 23, 79, tTelaRcto )
return NIL

//
//  Consulta de Contas a Pagar
//
function ConsPagar ()

  if NetUse( "FornARQ", .t. )
    VerifIND( "FornARQ" )
  
    pAbriForn := .t.

    #ifdef DBF_NTX
      set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
    #endif
  else
    pAbriForn := .f.  
  endif

  if NetUse( "PagaARQ", .t. )
    VerifIND( "PagaARQ" )

    pAbriPaga := .t.
  
    #ifdef DBF_NTX
      set index to PagaIND1, PagaIND2, PagaIND3, PagaIND4, PagaIND5, PagaIND6
    #endif
  else
    pAbriPaga := .f.  
  endif
  
  cCorAtual   := setcolor()
  dData       := dtos( ctod('  /  /   ') )
  nTotalGeral := 0
  dVctoIni    := ctod( '01/01/1990' )
  dVctoFin    := ctod( '31/12/2015' )
  tTelaRcto   := savescreen( 00, 00, 23, 79 )
  
  if EmprARQ->Periodo == "X"
    Janela( 09, 24, 13, 50, mensagem( 'LEVE', 'Periodo', .f. ), .f. )
    Mensagem( 'Veic', 'ConsPagar' )

    setcolor( CorJanel )
    @ 11,26 say 'Vcto. Inicial'
    @ 12,26 say '  Vcto. Final'
  
    @ 11,40 get dVctoIni      pict '99/99/9999'
    @ 12,40 get dVctoFin      pict '99/99/9999' valid dVctoFin >= dVctoIni
    read
   
    if lastkey() == K_ESC
      if pAbriPaga
        select PagaARQ
        close
      endif  

      if pAbriForn
        select FornARQ
        close
      endif     
        
      restscreen( 00, 00, 23, 79, tTelaRcto )
      return NIL
    endif  
  endif  
  
  select PagaARQ
  set order  to 3
  dbseek( dData, .t. )
  do while empty( Pgto ) .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin .and. !eof ()
    if Vcto < date() .and. Juro == 0
      nJuro := ( date() - Vcto ) * ( ( Valor - Desc ) * ( Acre / 30 ) / 100 )
    else
      nJuro := Juro
    endif

    nTotalGeral += ( ( Valor - Desc ) + nJuro )

    dbskip ()
  enddo      
  
  if nTotalGeral == 0
    Alerta( mensagem( 'Alerta', 'ConsPagar', .f. ) ) 

    if pAbriPaga
      select PagaARQ
      close
    endif  
    
    if pAbriForn
      select FornARQ
      close
    endif  
    
    restscreen( 00, 00, 23, 79, tTelaRcto )
    return NIL
  endif  

  Janela ( 03, 01, 20, 76, mensagem( 'Janela', 'ConsPagar', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )
  
  select FornARQ
  set order to 1

  select PagaARQ
  set order    to 3
  set relation to Forn into FornARQ

  bFirst := {|| dbseek( dData, .t. ) }
  bLast  := {|| dbseek( dData, .t. ), dbskip(-1) }
  bWhile := {|| empty( Pgto ) }
  bFor   := {|| empty( Pgto ) .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin } 
  
  oPagar           := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oPagar:nTop      := 5
  oPagar:nLeft     := 2
  oPagar:nBottom   := 18
  oPagar:nRight    := 75
  oPagar:headsep   := chr(194)+chr(196)
  oPagar:colsep    := chr(179)
  oPagar:footsep   := chr(193)+chr(196)
  oPagar:colorSpec := CorJanel

  oPagar:addColumn( TBColumnNew(" ",          {|| Marc } ) )
  oPagar:addColumn( TBColumnNew("Fornecedor", {|| left( FornARQ->Nome, 17 ) + ' ' + Forn } ) )
  oPagar:addColumn( TBColumnNew("Nota",       {|| transform( val( Nota ), '9999999999-99' ) } ) ) 
  oPagar:addColumn( TBColumnNew("Emis.",      {|| Emis } ) )
  oPagar:addColumn( TBColumnNew("Vcto.",      {|| Vcto } ) )
  oPagar:addColumn( TBColumnNew("Total",      {|| transform( Valor + iif( Vcto < date() .and. Juro == 0, ( date() - Vcto ) * (  ( Valor - Desc ) * ( Acre / 30 ) / 100 ), Juro ), '@E 999,999.99' ) } ) )
  oPagar:addColumn( TBColumnNew("Valor",      {|| transform( Valor, '@E 999,999.99' ) } ) )
  oPagar:addColumn( TBColumnNew("Juros",      {|| transform( iif( Vcto < date() .and. Juro == 0, ( date() - Vcto ) * (  ( Valor - Desc ) * ( Acre / 30 ) / 100 ), Juro ), '@E 9,999.99' ) } ) )
              
  oPagar:refreshAll ()
  
  lAdiciona      := .f.
  lMais          := .t.
  lExitRequested := .f.
  nLinBarra      := 1
  nSubTotal      := 0
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 6, 18, 76, nTotal )
  
  setcolor( CorJanel + ',' + CorCampo )
  @ 06,01 say chr(195)
  @ 18,01 say chr(195)
  @ 19,05 say 'Sub-Total'
  @ 19,49 say 'Total Geral'
  
  setcolor( CorCampo )
  @ 19,15 say nSubTotal                  pict '@E 999,999.99'
  @ 19,61 say nTotalGeral                pict '@E 999,999.99'

  do while !lExitRequested
    Mensagem( 'Veic', 'ConsPagar1' )
    
    oPagar:forcestable() 
    
    PosiDBF( 03, 76 )

    iif( BarraSeta, BarraSeta( nLinBarra, 6, 18, 76, nTotal ), NIL )
    
    if oPagar:stable
      if oPagar:hitTop .or. oPagar:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oPagar:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oPagar:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oPagar:down()
      case cTecla == K_UP;         oPagar:up()
      case cTecla == K_PGDN;       oPagar:pageDown()
      case cTecla == K_PGUP;       oPagar:pageUp()
      case cTecla == K_LEFT;       oPagar:left()
      case cTecla == K_RIGHT;      oPagar:right()
      case cTecla == K_CTRL_PGUP;  oPagar:goTop()
      case cTecla == K_ESC
        select PagaARQ
        set order to 3
        dbseek( dData, .t. )
        do while empty( Pgto ) .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin .and. !eof ()
          if RegLock()
            replace Marc      with space(01)
            dbunlock ()
          endif  
          dbskip ()
        enddo
      
        oPagar:refreshAll()

        lExitRequested := .t.
      case cTecla == K_ALT_P
        tAlte := savescreen( 00, 00, 24, 79 )         
        Janela( 06, 20, 12, 55, mensagem( 'Janela', 'Atencao', .f. ), .t. )          
        setcolor( CorJanel )
        @ 08,22 say 'Vocˆ tem certeza que gostaria de'
        @ 09,22 say 'fazer o Pagamento autom tico ?'

        if ConfLine( 11, 43, 1 )
          nTotalGeral := 0
          nSubTotal   := 0
          aNotas      := {}
       
          select PagaARQ
          set order to 3
          dbseek( dData, .t. )
          do while empty( Pgto ) .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin .and. !eof ()
            if empty( Marc )
              dbskip ()
              loop
            else
              aadd( aNotas, recno() )
            endif  
          
            dbskip ()
          enddo
 
          for nJ := 1 to len( aNotas )
            go aNotas[ nJ ] 
            if RegLock()
              replace Marc       with space(01)
              replace Pgto       with date()
              replace Pago       with ( Valor - Desc ) + Juro 
              dbunlock ()
            endif  

            if EmprARQ->Caixa == "X" 
              dPgto := date()
              nPago := ( PagaARQ->Valor - PagaARQ->Desc ) + PagaARQ->Juro 
              cNota := PagaARQ->Nota
              cHist := FornARQ->Nome
      
             DestLcto ()
           endif
         next
 
         dbseek( dData, .t. )
         do while empty( Pgto ) .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin .and. !eof ()
           if Vcto < date() .and. Juro == 0
             nJuro := ( date() - Vcto ) * ( ( Valor - Desc ) * ( Acre / 30 ) / 100 )
           else
             nJuro := Juro
           endif
            
           if !empty( Marc )
             nSubTotal += ( Valor - Desc ) + nJuro 
           endif  
          
           nTotalGeral += ( Valor - Desc ) + nJuro 

           dbskip ()
         enddo      
        
          dbseek( dData, .t. )

          setcolor( CorCampo )
          @ 19,15 say nSubTotal                  pict '@E 999,999.99'
          @ 19,61 say nTotalGeral                pict '@E 999,999.99'
        endif

        restscreen( 00, 00, 24, 79, tAlte )
        
        oPagar:refreshAll()
      case cTecla == K_ENTER .or. cTecla == K_ALT_A
        tPagaTela := savescreen( 00, 00, 22, 79 )

        Pgto(.t.)

        restscreen( 00, 00, 22, 79, tPagaTela )

        select PagaARQ
        set order to 3
        dbseek( dData, .t. )
        do while empty( Pgto ) .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin .and. !eof ()
          if Vcto < date() .and. Juro == 0
            nJuro := ( date() - Vcto ) * ( ( Valor - Desc ) * ( Acre / 30 ) / 100 )
          else
            nJuro := Juro
          endif
        
          if !empty( Marc )
            nSubTotal += ( Valor - Desc ) + nJuro 
          endif  
          
          nTotalGeral += ( Valor - Desc ) + nJuro 

          dbskip ()
        enddo      

        setcolor( CorCampo )
        @ 19,15 say nSubTotal                  pict '@E 999,999.99'
        @ 19,61 say nTotalGeral                pict '@E 999,999.99'

        oPagar:gotop()
        oPagar:refreshAll()

        lExitRequested := .f.
      case cTecla == K_SPACE
        if RegLock()
          if PagaARQ->Marc == ' '
            replace Marc      with "X"
     
            if Vcto < date() .and. Juro == 0
               nJuro := ( date() - Vcto ) * ( ( Valor - Desc ) * ( Acre / 30 ) / 100 )
             else
               nJuro := Juro
             endif
          
             nSubTotal += ( Valor - Desc ) + nJuro 
          else
            replace Marc      with ' '
     
            if Vcto < date() .and. Juro == 0
               nJuro := ( date() - Vcto ) * ( ( Valor - Desc ) * ( Acre / 30 ) / 100 )
             else
               nJuro := Juro
             endif
          
             nSubTotal -= ( Valor - Desc ) + nJuro 
          endif    
          dbunlock ()
        endif  
        
        setcolor( CorCampo ) 
        @ 19,15 say nSubTotal                  pict '@E 999,999.99'
        
        oPagar:refreshAll()
      case cTecla == K_ALT_F
        tSele := savescreen( 00, 00, 23, 79 )
        Janela( 09, 24, 13, 51, mensagem( 'LEVE', 'Periodo', .f. ), .f. )
        Mensagem( 'Veic', 'ConsPagar' )

        setcolor( CorJanel )
        @ 11,26 say 'Vcto. Inicial'
        @ 12,26 say '  Vcto. Final'
  
        dVctoFin := date()

        @ 11,40 get dVctoIni      pict '99/99/9999'
        @ 12,40 get dVctoFin      pict '99/99/9999' valid dVctoFin >= dVctoIni
        read

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tSele )
          dVctoFin    := ctod( '31/12/2015' )
          loop
        endif
        restscreen( 00, 00, 23, 79, tSele ) 

        nSubTotal   := 0
        nTotalGeral := 0
       
        select PagaARQ
        set order to 3
        dbgotop()
        do while !eof ()
          if empty( Pgto ) .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin
          if Vcto < date() .and. Juro == 0
            nJuro := ( date() - Vcto ) * ( ( Valor - Desc ) * ( Acre / 30 ) / 100 )
          else
            nJuro := Juro
          endif
        
          if !empty( Marc )
            nSubTotal += ( Valor - Desc ) + nJuro 
          endif  
          
          nTotalGeral += ( Valor - Desc ) + nJuro 
          endif
          dbskip ()
        enddo      

        setcolor( CorCampo )
        @ 19,15 say nSubTotal                  pict '@E 999,999.99'
        @ 19,61 say nTotalGeral                pict '@E 999,999.99'
        
        oPagar:gotop()
        oPagar:refreshAll()
    endcase
  enddo  
  
  select PagaARQ
  set order to 6
  dbgotop()
  do while .t.
    dbseek( "X", .f. )
    
    if found () 
      if RegLock()
        replace Marc         with space(01)
        dbunlock ()
      endif
    else
      exit
    endif    
  enddo      
 
  if pAbriPaga
    select PagaARQ
    close
  endif  
  
  if pAbriForn
    select FornARQ
    close
  endif         
  
  setcolor( cCorAtual )
  restscreen( 00, 00, 23, 79, tTelaRcto )
return NIL