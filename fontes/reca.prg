//  Leve, Recados - Agendar Recados
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

function Recado()
  cArquivo  := alias()  
  tMostra   := savescreen( 00, 00, 24, 79 )

  if NetUse( "RecaARQ", .t. )
    VerifIND( "RecaARQ" )
  
    lOpenReca := .t.
    
    #ifdef DBF_NTX
      set index to RecaIND1, RecaIND2, RecaIND3
    #endif  
  else
    lOpenReca := .f.
  endif

  select RecaARQ
  set order to 3
  dbgotop()

  Janela( 03, 12, 20, 58, mensagem( 'Janela', 'Reca', .f. ), .f. ) 
  setcolor ( CorJanel + ',' + CorCampo )

  oFile         := TBrowseDb( 05, 13, 18, 57 )
  oFile:headsep := chr(194)+chr(196)
  oFile:footsep := chr(193)+chr(196)
  oFile:colsep  := chr(179)

  oFile:addColumn( TBColumnNew("Data",      {|| Data } ) )
  oFile:addColumn( TBColumnNew("Hora",      {|| Hora } ) )
  oFile:addColumn( TBColumnNew("Titulo",    {|| left( Titu, 25 ) } ) )
           
  lExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ''
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 16, 18, 68, nTotal )
    
  oFile:freeze := 1
  oFile:colPos := 2
   
  setcolor ( CorCampo )
  @ 19,23 say space(30)
    
  setcolor( CorJanel + ',' + CorCampo )
  @ 06,12 say chr(195)
  @ 06,58 say chr(180)
  @ 18,12 say chr(195)
  @ 18,58 say chr(180)
  @ 19,14 say 'Consulta'

  do while !lExitRequested
    Mensagem( 'LEVE', 'Browse' )

    oFile:forcestable()

    PosiDBF( 03, 58 )
    
    iif( BarraSeta, BarraSeta( nLinBarra, 06, 18, 68, nTotal ), NIL )

    if oFile:stable
      if oFile:hitTop .or. oFile:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
 
    do case
      case cTecla == K_DOWN;        oFile:down()
      case cTecla == K_UP;          oFile:up()
      case cTecla == K_PGDN;        oFile:pageDown()
      case cTecla == K_PGUP;        oFile:pageUp()
      case cTecla == K_CTRL_PGUP;   oFile:goTop()
      case cTecla == K_CTRL_PGDN;   oFile:goBottom()
      case cTecla == K_RIGHT;       oFile:right()
      case cTecla == K_LEFT;        oFile:left()
      case cTecla == K_HOME;        oFile:home()
      case cTecla == K_END;         oFile:end()
      case cTecla == K_CTRL_LEFT;   oFile:panLeft()
      case cTecla == K_CTRL_RIGHT;  oFile:panRight()
      case cTecla == K_CTRL_HOME;   oFile:panHome()
      case cTecla == K_CTRL_END;    oFile:panEnd()
      case cTecla == K_ESC .or. cTecla == K_ENTER;  lExitRequested := .t.
      case cTecla == K_INS
        tInsert := savescreen( 00, 00, 23, 79 )
        Janela( 06, 13, 18, 56, mensagem( 'Janela', 'ConsReca', .f. ), .t. )
        setcolor( CorJanel )
        @ 08,15 say 'Titulo'
        @ 10,18 say '[ ] Diariamente' 
        @ 11,18 say '[ ] Semanalmente' 
        @ 12,18 say '[ ] Mensalmente'
        @ 13,18 say '[ ] Somente uma vez'
        @ 14,18 say '[ ] Ao iniciar o LEVE'
        @ 15,18 say '[ ] Ao sair do LEVE'
        
        setcolor( CorCampo )
        @ 17,32 say ' Confimar '
        @ 17,44 say ' Cancelar '
        
        setcolor( CorAltKC )
        @ 17,33 say 'C'
        @ 17,46 say 'a'
        
        cTitu := space(40)
        cDiar := cSema := cMens := cUma := cLogin := cLogout := space(1)
        
        @ 08,22 get cTitu     pict '@S30'
        @ 10,19 get cDiar     pict '@!' valid TipoReca(cDiar,1)
        @ 11,19 get cSema     pict '@!' valid TipoReca(cSema,2)
        @ 12,19 get cMens     pict '@!' 
        @ 13,19 get cUma      pict '@!' 
        @ 14,19 get cLogin    pict '@!' 
        @ 15,19 get cLogout   pict '@!' 
        read
        
        restscreen( 00, 00, 23, 79, tInsert )
        select RecaARQ
        if lastkey () != K_ESC .and. ConfAlte ()
          do case 
            case cDiar == "X"
              if AdiReg()
                if RegLock()
                  replace Titu          with cTitu
                  replace Diar          with cDiar
                  replace Sema          with cSema
                  replace Mens          with cMens  
                  replace Uma           with cUma
                  replace Login         with cLogin
                  replace Logout        with cLogout                  
                   
                  replace DataIni       with dDataIni
                  replace HoraIni       with cHoraIni 
                  replace Todo          with cTodo
                  replace Dura          with cDura            
                  replace Cada          with cCada            
                  replace Dias          with nDias            
                  dbunlock()
                endif
                dbunlock() 
              endif
          endcase
        endif    
        
        oFile:refreshAll()
      case cTecla == K_BS
        cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
      
        setcolor ( CorCampo )
        @ 19,23 say space(30)
        @ 19,23 say cLetra
      case cTecla >= 32 .and. cTecla <= 128
        cLetra += chr( cTecla )    

        if len( cLetra ) > 30
          cLetra := ''
        endif  
     
        setcolor ( CorCampo )
        @ 19,23 say space(30)
        @ 19,23 say cLetra

        dbseek( cLetra, .t. )
        oFile:refreshAll()
    endcase
  enddo
  
  select RecaARQ
  
  if lOpenReca
    close
  endif  

  restscreen( 00, 00, 24, 79, tMostra )
return NIL

function TipoReca(xTipo,nOrde)
  local lOk     := .f.
  local tReca   := savescreen( 00, 00, 23, 79 )
  local GetList := {}
  
  do case
    case nOrde == 1
      if xTipo == "X" 
        Janela( 10, 21, 18, 46, 'Definir...', .f. )
        setcolor( CorJanel )
        @ 12,24 say 'Data'
        @ 13,24 say 'Hora'
        @ 15,25 say '[ ] Todos os dias'
        @ 16,25 say '[ ] Durante a semana'
        @ 17,25 say '[ ] A Cada     Dias'
        
        dDataIni := date()
        cHoraIni := time()
        
        cTodo    := " "
        cDura    := " " 
        cCada    := " " 
        nDias    := 0
        
        setcolor( CorCampo )
        @ 17,36 say nDias     pict '999'

        setcolor( CorJanel + ',' + CorCampo )
        @ 12,29 get dDataIni    pict '99/99/9999'            
        @ 13,29 get cHoraIni    pict '99:99:99'
        @ 15,26 get cTodo       pict '@!'
        @ 16,26 get cDura       pict '@!' 
        @ 17,26 get cCada       pict '@!' 
        read
        if cCada == "X"
          @ 17,36 get nDias     pict '999'  valid nDias > 0
        endif
      endif

      lOk := .t.
    case nOrde == 2
      if xTipo == "X" 
        Janela( 08, 21, 18, 61, 'Definir...', .f. )
        setcolor( CorJanel )
        @ 10,25 say 'Hora'
        @ 12,23 say 'A cada     semanas'
        @ 14,23 say '[ ] segunda-feira   [ ] sexta-feira'
        @ 15,23 say '[ ] terça-feira     [ ] s bado'
        @ 16,23 say '[ ] quarta-feira    [ ] domingo'
        @ 17,23 say '[ ] quinta-feira'

        cHoraIni := time()
        
        nCada    := 0
        cSegu    := cTerc := cQuar := cQuin := " "
        cSext    := cSaba := cDomi := " "
        
        setcolor( CorCampo )

        setcolor( CorJanel + ',' + CorCampo )
        @ 10,30 get cHoraIni    pict '99:99:99'
        @ 12,30 get nCada       pict '999'
        @ 14,24 get cSegu       pict '@!'
        @ 15,24 get cTerc       pict '@!' 
        @ 16,24 get cQuar       pict '@!' 
        @ 17,24 get cQuin       pict '@!' 
        @ 14,44 get cSext       pict '@!' 
        @ 15,44 get cSaba       pict '@!' 
        @ 16,44 get cDomi       pict '@!' 
        read
      endif     
  endcase  
  
  restscreen( 00, 00, 23, 79, tReca )
return(lOk)