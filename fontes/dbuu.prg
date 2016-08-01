//  Leve, DBU - Database Utility
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

function DBU()
  cArquivo := alias()  
  tMostra  := savescreen( 00, 00, 24, 79 )
  cDBUNew  := CriaTemp(0)
  aArqui   := {}
  
  aadd( aArqui, { "Marc",       "C", 001, 0 } )
  aadd( aArqui, { "Arqu",       "C", 008, 0 } )
  aadd( aArqui, { "Desc",       "C", 035, 0 } )

  dbcreate( cDBUNew, aArqui )
   
  if NetUse( cDBUNew, .f. )
    cDBUNew := alias ()
  
  endif

  select EstrARQ
  set order  to 1
  set filter to !empty( Desc )
  dbgotop()
  do while !eof()
    select( cDBUNew )
    if AdiReg()
      if RegLock()
        replace Arqu     with EstrARQ->Arqu
        replace Desc     with EstrARQ->Desc   
        dbunlock() 
      endif  
    endif
    
    select EstrARQ
    dbskip()
  enddo
  
  select EstrARQ
  set filter to
  
  select( cDBUNew )
  dbgotop()

  Janela( 03, 12, 20, 56, 'Consulta de Arquivos', .f. ) 
  setcolor ( CorJanel + ',' + CorCampo )

  oFile         := TBrowseDb( 05, 13, 18, 55 )
  oFile:headsep := chr(194)+chr(196)
  oFile:footsep := chr(193)+chr(196)
  oFile:colsep  := chr(179)

  oFile:addColumn( TBColumnNew(" ", {|| Marc } ) )
  oFile:addColumn( TBColumnNew("Arquivo", {|| left( Arqu, 7 ) } ) )
  oFile:addColumn( TBColumnNew("Descrição", {|| left( Desc, 33 ) } ) )
           
  lExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ''
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 16, 18, 56, nTotal )
    
  oFile:freeze := 1
  oFile:colPos := 2
   
  setcolor ( CorCampo )
  @ 19,23 say space(30)
    
  setcolor( CorJanel + ',' + CorCampo )
  @ 06,12 say chr(195)
  @ 06,56 say chr(180)
  @ 18,12 say chr(195)
  @ 18,56 say chr(180)
  @ 19,14 say 'Consulta'

  do while !lExitRequested
    Mensagem( '<Alt+S> Estrutura, <ALT+V> Browse, <ALT+R> Atualizar, <ALT+I> Indices, <ALT+Z> Zap' )

    oFile:forcestable()

    PosiDBF( 03, 56 )
    
    iif( BarraSeta, BarraSeta( nLinBarra, 06, 18, 56, nTotal ), NIL )

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
      case cTecla == K_ALT_A
        dbgotop()
        do while !eof()
          if RegLock()
            replace Marc     with "X"
            dbunlock()
          endif  
          dbskip()
        enddo
        
        dbgotop()
        oFile:refreshall()
      case cTecla == K_SPACE
        if empty( Marc )
          if RegLock()
            replace Marc      with "X"
            dbunlock()
          endif  
        else
          if RegLock()
            replace Marc      with " "
            dbunlock()
          endif  
        endif
        
        oFile:refreshall()
      case cTecla == K_ALT_R
        nRec := recno ()
        tAtua    := savescreen( 00, 00, 23, 79 )
        
        if RegLock()
          replace Marc     with "X"
          dbunlock()
        endif  
          
        dbgotop ()
        do while !eof()          
          if !empty(Marc)
          cFileNew := CriaTemp(0)
          cArquOld := alltrim( Arqu )
          aEstrNew := CriaARQ( cArquOld, .f. )

          dbcreate( cFileNew, aEstrNew )

          if NetUse( cFileNew, .f. )
            cArquNew := alias ()
          endif  
 
          if NetUse( cArquOld, .f. )
            cArquOld := alias ()
            aEstrOld := dbstruct()
          endif  

          Janela( 11, 23, 17, 61, "Banco de Dados", .f. )
          setcolor ( CorJanel + "," + CorCampo )

          @ 13,25 say "Aguarde! Atualizando arquivo(s)..."

          @ 15,25 say ' Nome'
          @ 16,25 say 'Campo'
          
          setcolor( CorCampo  )
          @ 15,31 say cArquOld
          
          dbgotop()
          do while !eof()
            select( cArquNew )
            if AdiReg()
              for nL := 1 to len( aEstrOld )
                cCamp := aEstrOld[ nL, 1 ]
                cTipo := aEstrOld[ nL, 2 ]
                cTama := aEstrOld[ nL, 3 ]
                cDeci := aEstrOld[ nL, 4 ]
                
                nElem := ascan( aEstrNew, { |nElem| alltrim( upper( nElem[1] ) ) == alltrim( upper( cCamp ) ) } )
                
                @ 15,45 say recno()   pict '999999'                 
                @ 16,31 say space(10) 
                @ 16,31 say cCamp
                @ 16,42 say cTipo
                @ 16,44 say cTama     pict '999' 
                @ 16,48 say cDeci     pict '999'
                
                if nElem > 0
                  cValo := &cArquOld->&cCamp
                  
                  if ( upper( cCamp ) == "PROD" .or. upper( cCamp ) == "CLIE" ) .and.;
                     left( &cArquOld->&cCamp, 4 ) == "9999"
                     
                    cValo := '999999'
                  else                
                    if upper( cCamp ) == "CLIE" .or. upper( cCamp ) == "FORN" .or.;
                      upper( cCamp ) == "REPR" .or. upper( cCamp ) == "COND" .or.;
                      upper( cCamp ) == "TRAN" .or. upper( cCamp ) == "PORT" .or.;
                      upper( cCamp ) == "VEIC" .or. upper( cCamp ) == "COBR" .or.;
                      upper( cCamp ) == "GRUP" .or. upper( cCamp ) == "SUBG" .or.;
                      upper( cCamp ) == "LCTO" .or. upper( cCamp ) == "CONT" .or.;
                      upper( cCamp ) == "PROD"
                   
                      cValo := strzero( val( &cArquOld->&cCamp ), 6 )
                    endif  
                  endif  
                  
                  if upper( cCamp ) == "SEQU"
                    cValo := strzero( val( &cArquOld->&cCamp ), 4 )
                  endif  
                                    
                  if RegLock()
                    replace &cCamp      with cValo 
                  endif  
                endif  
              next
              dbunlock()
            endif  
            
            select( cArquOld )
            dbskip()
          enddo
            
          close 
          
          select( cArquNew )
          close
          
          #ifdef DBF_CDX
            cExtARQ := '.fpt'
          #endif
          #ifdef DBF_NTX
            cExtARQ := '.dbt'
          #endif

          ferase( cCaminho + HB_OSpathseparator() + alltrim( EmprARQ->Direto ) + HB_OSpathseparator() + cArquOld )

          if file(cCaminho + HB_OSpathseparator() + alltrim( EmprARQ->Direto ) + HB_OSpathseparator() + cArquOld + cExtARQ )
            ferase( cCaminho + HB_OSpathseparator() + alltrim( EmprARQ->Direto ) + HB_OSpathseparator() + cArquOld + cExtARQ )
          endif  
          
          select IndeARQ
          set order to 1
          dbseek( cArquOld, .f. )
          do while left( Arqu, len( cArquOld ) ) == cArquOld
          
            #ifdef DBF_NTX
              ferase( cCaminho + HB_OSpathseparator() + alltrim( EmprARQ->Direto ) + HB_OSpathseparator() + alltrim( Inde ) + ".ntx" )
            #endif

            #ifdef DBF_CDX
              ferase( cCaminho + HB_OSpathseparator() + alltrim( EmprARQ->Direto ) + HB_OSpathseparator() + alltrim( Arqu ) + ".cdx" )
            #endif

            ferase( cCaminho + HB_OSpathseparator() + alltrim( EmprARQ->Direto ) + HB_OSpathseparator() + alltrim( Arqu ) + ".dbf" )

            dbskip()
          enddo

            copy file ( cFileNew ) to ( cCaminho + HB_OSpathseparator() + alltrim( EmprARQ->Direto ) + HB_OSpathseparator() + cArquOld + ".dbf" )

            if file ( left( cFileNew, len( cFileNew ) - 3 ) + right( cExtARQ, 3 ) )
              copy file ( left( cFileNew, len( cFileNew ) - 3 ) + right( cExtARQ, 3 ) ) to ( cCaminho + HB_OSpathseparator() + alltrim( EmprARQ->Direto ) + HB_OSpathseparator() + cArquOld + cExtARQ )
            endif  
        
            ferase( cFileNew )
            if file ( left( cFileNew, len( cFileNew ) - 3 ) + right( cExtARQ, 3 ) )
              ferase( left( cFileNew, len( cFileNew ) - 3 ) + right( cExtARQ, 3 ) )
            endif  
          endif
          
          select( cDBUNew )
          
          if RegLock()
            replace Marc     with " "
            dbunlock()
          endif
          
          dbskip()
        enddo 
        
        restscreen( 00, 00, 23, 79, tAtua )
     
        select( cDBUNew )
        go nRec

        setcolor ( CorJanel + "," + CorCampo )
        
        oFile:refreshAll()
      case cTecla == K_ALT_P
        if ConfAlte()
          if NetUse( alltrim( Arqu ), .f. )
 
            pack
          endif  
          
          close 
        endif  

        select( cDBUNew )
        
        oFile:refreshAll()
      case cTecla == K_ALT_Z
        if ConfAlte()
          if NetUse( alltrim( Arqu ), .f., 30 )
 
            zap
          endif  
          
          close 
        endif  
        
        select( cDBUNew )
        
        oFile:refreshAll()
      case cTecla == K_ALT_V
        if NetUse( alltrim( Arqu ), .f. )
             
          VisuStru ()
          
          close
        endif  
        
        select( cDBUNew )
        
        oFile:refreshAll()
      case cTecla == K_ALT_I
        CriaIndi ()
        
        select( cDBUNew )
        
        oFile:refreshAll()
      case cTecla == K_ALT_S
        if NetUse( alltrim( Arqu ), .f. )
          cArquTMP := alias()
          cStruARQ := CriaTemp(0)
                  
          COPY TO &cStruARQ STRUCTURE EXTENDED
          
          if NetUse( cStruARQ, .f. )
            ModiStru ()            

            close
          endif 
          
          ferase( cStruARQ )

          select( cArquTMP )
          close
        endif  
                 
        select( cDBUNew )
        
        oFile:refreshAll()
      case cTecla == K_ALT_Z
        select( cDBUNew )

        if ConfAlte()
          dbgotop()
          do while !eof()
            if !empty( Marc )
              cArqu := alltrim( Arqu ) + '.DBF'

              ferase( cArqu )
              
              if RegLock() 
                replace Marc  with space(1)
                dbunlock()
              endif             
            endif
            dbskip()
          enddo  

          dbgotop()

          oFile:refreshAll()
        endif

        lExitRequested := .f.
    endcase
  enddo

  close

//  ferase( cCaminho + HB_OSpathseparator() + "TEMP" + HB_OSpathseparator() + cDBUNEW + cExtARQ )
  
  select EstrARQ
  set order  to 1
  set filter to
  
  restscreen( 00, 00, 24, 79, tMostra )
return NIL

//
// Modifica Estrutura - ALT+S 
//
function ModiStru()
  sMostra   := savescreen( 00, 00, 24, 79 )
  
  Janela( 05, 17, 21, 51, 'Estrutura do ' + alltrim( EstrARQ->Arqu ), .f. ) 
  setcolor ( CorJanel + ',' + CorCampo )

  oStru         := TBrowseDb( 07, 18, 21, 50 )
  oStru:headsep := chr(194)+chr(196)
  oStru:footsep := chr(193)+chr(196)
  oStru:colsep  := chr(179)

  oStru:addColumn( TBColumnNew("Descrição      ", {|| Field_Name } ) )
  oStru:addColumn( TBColumnNew("Tipo     ",       {|| iif( Field_Type == "C", "Caracter", iif( Field_Type == "N", "Num‚rico", iif( Field_Type == "D", "Data", iif( Field_Type == "M", "Memo","Logico" ) ) ) ) } ) )
  oStru:addColumn( TBColumnNew("Tam",             {|| Field_Len } ) )
  oStru:addColumn( TBColumnNew("Dec",             {|| Field_Dec } ) )
           
  iExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ''
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 16, 21, 51, nTotal )
    
  oStru:freeze := 1
  oStru:colPos := 2
   
  setcolor( CorJanel + ',' + CorCampo )
  @ 08,17 say chr(195)
  @ 08,51 say chr(180)

  do while !iExitRequested
    Mensagem( '<ENTER> Alterar, <INSERT> Incluir, <DELETE> Apagar, <ALT+S> Salva' )

    oStru:forcestable()

    PosiDBF( 05, 51 )
    
    iif( BarraSeta, BarraSeta( nLinBarra, 08, 21, 51, nTotal ), NIL )

    if oStru:stable
      if oStru:hitTop .or. oStru:hitBottom
        tone( 125, 0 )        
      endif  

      sTecla := Teclar(0)
    endif
 
    do case
      case sTecla == K_DOWN;        oStru:down()
      case sTecla == K_UP;          oStru:up()
      case sTecla == K_PGDN;        oStru:pageDown()
      case sTecla == K_PGUP;        oStru:pageUp()
      case sTecla == K_CTRL_PGUP;   oStru:goTop()
      case sTecla == K_CTRL_PGDN;   oStru:goBottom()
      case sTecla == K_RIGHT;       oStru:right()
      case sTecla == K_LEFT;        oStru:left()
      case sTecla == K_HOME;        oStru:home()
      case sTecla == K_END;         oStru:end()
      case sTecla == K_CTRL_LEFT;   oStru:panLeft()
      case sTecla == K_CTRL_RIGHT;  oStru:panRight()
      case sTecla == K_CTRL_HOME;   oStru:panHome()
      case sTecla == K_CTRL_END;    oStru:panEnd()
      case sTecla == K_ESC;         iExitRequested := .t.
      case sTecla == K_DEL
        if RegLock()
          dbdelete()
          dbunlock()
        endif
          
        oStru:refreshAll()  
      case sTecla == K_INS
        if AdiReg()
          if RegLock()
            replace Field_Type     with "C"
            dbunlock()
          endif
        endif

        dbgobottom ()

        oStru:goBottom() 
        oStru:refreshAll()  

        oStru:forcestable()
          
        cName := Field_Name
        cTipo := Field_Type
        nTama := Field_Len
        nDeci := Field_Dec
        
        setcolor( CorCampo )
        do case 
          case cTipo == "C"; @ oStru:rowpos() + 08, 34 say "Caracter "
          case cTipo == "N"; @ oStru:rowpos() + 08, 34 say "Num‚rico "
          case cTipo == "M"; @ oStru:rowpos() + 08, 34 say "Memo     "
          case cTipo == "D"; @ oStru:rowpos() + 08, 34 say "Data     "
          case cTipo == "L"; @ oStru:rowpos() + 08, 34 say "Logico   "
        endcase   
                      
        setcolor ( CorJanel + ',' + CorCampo )
        @ oStru:rowpos() + 08, 18 get cName   pict '@!' 
        @ oStru:rowpos() + 08, 34 get cTipo   pict '@!' valid TipoType(cTipo)
        @ oStru:rowpos() + 08, 44 get nTama   pict '999'
        @ oStru:rowpos() + 08, 48 get nDeci   pict '999'
        read
        
        if lastkey() != K_ESC
          if RegLock()
            replace Field_Name    with cName
            replace Field_Type    with cTipo
            replace Field_Len     with nTama
            replace Field_Dec     with nDeci
            dbunlock()
          endif
        else
          if RegLock()
            dbdelete()
            dbunlock()
          endif    
        endif    
        oStru:refreshAll()
        oStru:goBottom()
      case sTecla == K_ENTER
        cName := Field_Name
        cTipo := Field_Type
        nTama := Field_Len
        nDeci := Field_Dec
        
        setcolor( CorCampo )
        do case 
          case cTipo == "C"; @ oStru:rowpos() + 08, 34 say "Caracter "
          case cTipo == "N"; @ oStru:rowpos() + 08, 34 say "Num‚rico "
          case cTipo == "M"; @ oStru:rowpos() + 08, 34 say "Memo     "
          case cTipo == "D"; @ oStru:rowpos() + 08, 34 say "Data     "
          case cTipo == "L"; @ oStru:rowpos() + 08, 34 say "Logico   "
        endcase   
                      
        setcolor ( CorJanel + ',' + CorCampo )
        @ oStru:rowpos() + 08, 18 get cName        pict '@!'
        @ oStru:rowpos() + 08, 34 get cTipo        pict '@!' 
        @ oStru:rowpos() + 08, 44 get nTama        pict '999'
        @ oStru:rowpos() + 08, 48 get nDeci        pict '999'
        read
        
        if lastkey() != K_ESC
          if RegLock()
            replace Field_Name    with cName
            replace Field_Type    with cTipo
            replace Field_Len     with nTama
            replace Field_Dec     with nDeci
            dbunlock()
          endif
        endif    
        oStru:refreshAll()
    endcase
  enddo
  
  restscreen( 00, 00, 24, 79, sMostra )
return NIL

function TipoType(cTipo)
  lOk := .f.

  do case
    case cTipo == "C"; @ oStru:rowpos() + 08, 34 say "Caracter "; lOk := .t.
    case cTipo == "N"; @ oStru:rowpos() + 08, 34 say "Num‚rico "; lOk := .t.
    case cTipo == "M"; @ oStru:rowpos() + 08, 34 say "Memo     "; lOk := .t.
      nTama := 10
      lOk   := .t.
      keyboard(chr(13)+chr(13))
    case cTipo == "D"; @ oStru:rowpos() + 08, 34 say "Data     "; lOk := .t.
      nTama := 8
      lOk   := .t.
      keyboard(chr(13)+chr(13))
    case cTipo == "L"; @ oStru:rowpos() + 08, 34 say "Logico   "
      nTama := 1
      lOk   := .t.
      keyboard(chr(13)+chr(13))
    otherwise
      Alerta( space(47) + "Tipo Invalido !" ) 
  endcase   
return(lOk)

//
// Visualizar Estrutura - ALT+V 
//
function VisuStru()
  vMostra := savescreen( 00, 00, 24, 79 )

  Janela( 05, 02, 21, 75, 'Visualizando ' + alltrim( EstrARQ->Arqu ), .f. ) 
  setcolor ( CorJanel + ',' + CorCampo )

  aArqu := dbstruct()
  nLen  := 0
  oStru := TBrowseDb()

  @ 08,02 say chr(195)+replicate(chr(196),72)+chr(180)

  for n := 1 to len( aArqu )
    cName := aArqu[ n, 1 ]
    nLen  += ( aArqu[ n, 3 ] + aArqu[ n, 4 ] )

    oStru:addColumn( TBColumnNew( cName, {|| &cName } ) )
  next
  
  oStru:nTop    := 07
  oStru:nBottom := 21
  oStru:nLeft   := 03                      // Centralizar !
  oStru:nRight  := 74
  oStru:headsep := chr(194)+chr(196)
  oStru:footsep := chr(193)+chr(196)
  oStru:colsep  := chr(179)

  iExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ''
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 16, 21, 75, nTotal )
    
  oStru:freeze := 1
  oStru:colPos := 2
   
  setcolor( CorJanel + ',' + CorCampo )

  do while !iExitRequested
    Mensagem( '<ENTER> Alterar, <ESC> Retornar, <ALT+S> Salva' )

    oStru:forcestable()

    PosiDBF( 05, 75 )
    
    iif( BarraSeta, BarraSeta( nLinBarra, 08, 21, 75, nTotal ), NIL )

    if oStru:stable
      if oStru:hitTop .or. oStru:hitBottom
        tone( 125, 0 )        
      endif  

      sTecla := Teclar(0)
    endif
 
    do case
      case sTecla == K_DOWN;        oStru:down()
      case sTecla == K_UP;          oStru:up()
      case sTecla == K_PGDN;        oStru:pageDown()
      case sTecla == K_PGUP;        oStru:pageUp()
      case sTecla == K_CTRL_PGUP;   oStru:goTop()
      case sTecla == K_CTRL_PGDN;   oStru:goBottom()
      case sTecla == K_RIGHT;       oStru:right()
      case sTecla == K_LEFT;        oStru:left()
      case sTecla == K_HOME;        oStru:home()
      case sTecla == K_END;         oStru:end()
      case sTecla == K_CTRL_LEFT;   oStru:panLeft()
      case sTecla == K_CTRL_RIGHT;  oStru:panRight()
      case sTecla == K_CTRL_HOME;   oStru:panHome()
      case sTecla == K_CTRL_END;    oStru:panEnd()
      case sTecla == K_DEL
        if RegLock()         
          dbdelete()
 	  dbunlock()
          oStru:refreshAll()
        endif 	
      case sTecla == K_ESC;         iExitRequested := .t.
      case sTecla == K_ENTER
      /*
                      
        setcolor ( CorJanel + ',' + CorCampo )
        @ oStru:rowpos() + 08, 18 get cName        pict '@!'
        read
        
        if lastkey() != K_ESC
          if RegLock()
            replace Field_Name    with cName
            dbunlock()
          endif
        endif    
        oStru:refreshAll()
        */
    endcase
  enddo
  
  restscreen( 00, 00, 24, 79, vMostra )
return NIL

//
// Modificar Indices - ALT+I 
//
function CriaIndi()
  sMostra := savescreen( 00, 00, 24, 79 )
  cArqu   := alltrim( EstrARQ->Arqu ) 
  
  select IndeARQ
  set order to 1
  
  Janela( 05, 17, 21, 51, 'Indices do ' + alltrim( EstrARQ->Arqu ), .f. ) 
  setcolor ( CorJanel + ',' + CorCampo )

  bFirst := {|| dbseek( cArqu, .t. ) }
  bLast  := {|| dbseek( cArqu, .t. ), dbskip(-1) }
  bWhile := {|| left( Arqu, len( cArqu ) ) == cArqu }
  bFor   := {|| left( Arqu, len( cArqu ) ) == cArqu }
  
  oStru          := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oStru:nTop     := 7
  oStru:nLeft    := 18
  oStru:nBottom  := 21
  oStru:nRight   := 50
  oStru:headsep  := chr(194)+chr(196)
  oStru:colsep   := chr(179)
  oStru:footsep  := chr(193)+chr(196)

  oStru:addColumn( TBColumnNew("Arquivo", {|| Inde } ) )
  oStru:addColumn( TBColumnNew("Chave",   {|| Chav } ) )
           
  iExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ''
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 16, 21, 51, nTotal )
    
  oStru:freeze := 1
  oStru:colPos := 2
   
  setcolor( CorJanel + ',' + CorCampo )
  @ 08,17 say chr(195)
  @ 08,51 say chr(180)

  do while !iExitRequested
    Mensagem( '<ENTER> Alterar, <INSERT> Incluir, <DELETE> Apagar' )

    oStru:forcestable()

    PosiDBF( 05, 51 )
    
    iif( BarraSeta, BarraSeta( nLinBarra, 08, 21, 51, nTotal ), NIL )

    if oStru:stable
      if oStru:hitTop .or. oStru:hitBottom
        tone( 125, 0 )        
      endif  

      sTecla := Teclar(0)
    endif
 
    do case
      case sTecla == K_DOWN;        oStru:down()
      case sTecla == K_UP;          oStru:up()
      case sTecla == K_PGDN;        oStru:pageDown()
      case sTecla == K_PGUP;        oStru:pageUp()
      case sTecla == K_CTRL_PGUP;   oStru:goTop()
      case sTecla == K_CTRL_PGDN;   oStru:goBottom()
      case sTecla == K_RIGHT;       oStru:right()
      case sTecla == K_LEFT;        oStru:left()
      case sTecla == K_HOME;        oStru:home()
      case sTecla == K_END;         oStru:end()
      case sTecla == K_CTRL_LEFT;   oStru:panLeft()
      case sTecla == K_CTRL_RIGHT;  oStru:panRight()
      case sTecla == K_CTRL_HOME;   oStru:panHome()
      case sTecla == K_CTRL_END;    oStru:panEnd()
      case sTecla == K_ESC;         iExitRequested := .t.
      case sTecla == K_DEL
        if RegLock()
          dbdelete()
          dbunlock()
        endif
          
        oStru:refreshAll()  
      case sTecla == K_INS
        if AdiReg()
          if RegLock()
            replace Arqu     with cArqu
            dbunlock()
          endif
        endif

        dbgobottom ()

        oStru:goBottom() 
        oStru:refreshAll()  

        oStru:forcestable()
          
        cInde := Inde
        cChav := Chav
        
        setcolor ( CorJanel + ',' + CorCampo )
        @ oStru:rowpos() + 08, 18 get cInde   pict '@!' 
        @ oStru:rowpos() + 08, 34 get cChav   pict '@!'
        read
        
        if lastkey() != K_ESC
          if RegLock()
            replace Inde          with cInde
            replace Chav          with cChav
            dbunlock()
          endif
        else
          if RegLock()
            dbdelete()
            dbunlock()
          endif    
        endif    
        oStru:refreshAll()
        oStru:goBottom()
      case sTecla == K_ENTER
        cName := Field_Name
        cTipo := Field_Type
        nTama := Field_Len
        nDeci := Field_Dec
        
        setcolor( CorCampo )
        do case 
          case cTipo == "C"; @ oStru:rowpos() + 08, 34 say "Caracter "
          case cTipo == "N"; @ oStru:rowpos() + 08, 34 say "Num‚rico "
          case cTipo == "M"; @ oStru:rowpos() + 08, 34 say "Memo     "
          case cTipo == "D"; @ oStru:rowpos() + 08, 34 say "Data     "
          case cTipo == "L"; @ oStru:rowpos() + 08, 34 say "Logico   "
        endcase   
                      
        setcolor ( CorJanel + ',' + CorCampo )
        @ oStru:rowpos() + 08, 18 get cName        pict '@!'
        @ oStru:rowpos() + 08, 34 get cTipo        pict '@!' 
        @ oStru:rowpos() + 08, 44 get nTama        pict '999'
        @ oStru:rowpos() + 08, 48 get nDeci        pict '999'
        read
        
        if lastkey() != K_ESC
          if RegLock()
            replace Field_Name    with cName
            replace Field_Type    with cTipo
            replace Field_Len     with nTama
            replace Field_Dec     with nDeci
            dbunlock()
          endif
        endif    
        oStru:refreshAll()
    endcase
  enddo
  
  restscreen( 00, 00, 24, 79, sMostra )
return NIL