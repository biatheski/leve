//  Leve, Itens do Menu
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

function ItMe ()

//  Variaveis para Entrada de dados
tItmeTela := savescreen( 00, 00, 23, 79 )
aOpcoes   := {}
aArqui    := {}
cItMeARQ  := CriaTemp(0)
cItMeIND1 := CriaTemp(1)
cChave    := "Modu + Menu + Item"

aadd( aArqui, { "Modu",      "C", 004, 0 } )
aadd( aArqui, { "Modulo",    "C", 010, 0 } )
aadd( aArqui, { "Menu",      "C", 008, 0 } )
aadd( aArqui, { "Item",      "C", 002, 0 } )
aadd( aArqui, { "Desc",      "C", 040, 0 } )
aadd( aArqui, { "Tama",      "N", 002, 0 } )
aadd( aArqui, { "Tecl",      "N", 002, 0 } )
aadd( aArqui, { "Linh",      "N", 002, 0 } )
aadd( aArqui, { "Colu",      "N", 002, 0 } )
aadd( aArqui, { "Mens",      "C", 079, 0 } )
aadd( aArqui, { "ExPr",      "L", 001, 0 } )
aadd( aArqui, { "Acao",      "C", 025, 0 } )
aadd( aArqui, { "Regi",      "N", 008, 0 } )
aadd( aArqui, { "Lixo",      "L", 001, 0 } )
aadd( aArqui, { "Novo",      "L", 001, 0 } )

dbcreate( cItMeARQ, aArqui )
   
if NetUse( cItMeARQ, .f. )
  cItMeTMP := alias ()
    
  #ifdef DBF_CDX
    index on &cChave tag &cItMeIND1
  #endif
  
  #ifdef DBF_NTX
    index on &cChave to &cItMeIND1

    set index to &cItMeIND1
  #endif  
endif
  
if NetUse( "IdioARQ", .t. )
  VerifIND( "IdioARQ" )

  #ifdef DBF_NTX
    set index to IdioIND1, IdioIND2
  #endif  
endif
 
select IdioARQ
set order to 1
dbgotop()
if val( Idio ) == 0
  if AdiReg()
    replace Idio          with '01'
    replace Nome          with 'Portuguˆs'
    dbunlock()
  endif
endif
Janela ( 01, 02, 21, 76, mensagem( 'Janela', 'ItMe', .f. ), .t. )
setcolor ( CorJanel + ',' + CorCampo )

@ 03,03 say '  Empresa' 
@ 04,03 say '     Menu                          Idioma'  

@ 06,03 say ' N. Descrição          Ta Li Co Mensagem                     X Ação' 

@ 07,02 say chr(195) + replicate( chr(196), 73 ) + chr(180)

@ 07,06 say chr(194)
@ 07,25 say chr(194)
@ 07,28 say chr(194)
@ 07,31 say chr(194)
@ 07,34 say chr(194)
@ 07,63 say chr(194)
@ 07,65 say chr(194)

for nY := 8 to 18
  @ nY,06 say chr(179)
  @ nY,25 say chr(179)
  @ nY,28 say chr(179)
  @ nY,31 say chr(179)
  @ nY,34 say chr(179)
  @ nY,63 say chr(179)
  @ nY,65 say chr(179)
next  
  
@ 19,02 say chr(195) + replicate( chr(196), 73 ) + chr(180)
@ 19,06 say chr(193)
@ 19,25 say chr(193)
@ 19,28 say chr(193)
@ 19,31 say chr(193)
@ 19,34 say chr(193)
@ 19,63 say chr(193)
@ 19,65 say chr(193)
   
MostOpcao( 20, 04, 16, 52, 65 ) 
tItMe := savescreen( 00, 00, 24, 79 )

do while .t.
  Mensagem( 'ItMe', 'Janela' )
 
  cStat := cStatAux := space(04)
  restscreen( 00, 00, 23, 79, tItMe )
  
  select( cItMeTMP )
  set order to 1
  zap
  
  //  Entrar com Novo Codigo

  cAjuda  := 'ItMe' 
  lAjud   := .t.
  nModu   := nIdio  := 0
  cModu   := space(04)
  cMenu   := space(08)
  cStat   := space(04)

  setcolor( CorCampo )
  @ 03,20 say space(40)
  @ 04,45 say nIdio          pict '99'
  @ 04,48 say space(10)

  setcolor ( CorJanel + ',' + CorCampo )
  @ 03,13 get nModu       pict '999999' valid ValidARQ( 03, 13, "EmprARQ", "Código", "Empr", "Descrição", "Nome", "Empr", "nModu", .t., 6, "Consulta de Empresas", "EmprARQ", 40 )
  @ 04,13 get cMenu       pict "99.99.99" 
  @ 04,45 get nIdio       pict '99'  valid ValidARQ( 04, 45, "EmprARQ", "Código", "Idio", "Descrição", "Nome", "Idio", "nIdio", .t., 2, "Consulta de Idiomas", "IdioARQ", 10 )
  read
  
  if lastkey() == K_ESC .or. nModu == 0
    exit
  endif
  
  cModu := strzero( nModu, 6 )
  cIdio := strzero( nIdio, 2 )

  //  Verificar existencia das Notas para Incluir ou Alterar
  select MenuARQ
  set order to 1
  dbseek( cIdio + cModu + cMenu , .t. )
  do while !eof() .and. Modu == cModu .and. Menu == cMenu .and. Idio == cIdio
    nRegi := recno ()
    cStat := 'incl'
    
    select( cItMeTMP )
    if AdiReg()
      if RegLock()
        replace Modu     with cModu
        replace Menu     with cMenu
        replace Modulo   with MenuARQ->Modulo
        replace Item     with MenuARQ->Item
        replace Desc     with MenuARQ->Desc
        replace Tama     with MenuARQ->Tama
        replace Tecl     with MenuARQ->Tecl
        replace Linh     with MenuARQ->Linh
        replace Colu     with MenuARQ->Colu
        replace Mens     with MenuARQ->Mens
        replace ExPr     with MenuARQ->ExPr
        replace Acao     with MenuARQ->Acao
        replace Regi     with nRegi
        replace Novo     with .f.
        replace Lixo     with .f.
        dbunlock ()
      endif
    endif
    
    select MenuARQ
    dbskip ()
  enddo
  
  EntrItIt()

  Confirmar( 20, 04, 16, 52, 65, 3 ) 
  
  if cStat == 'loop' .or. lastkey() == K_ESC
    loop
  endif  

  if cStat == 'prin'
 
  endif
    
  if cStat == 'excl'

  endif
  
  GravItem ()
enddo

select IdioARQ
close

select( cItMeTMP )
close
ferase( cItMeARQ )
ferase( cItMeIND1 )

restscreen( 00, 00, 23, 79, tItMeTela )

return NIL

//
// Entra com os itens 
//
function EntrItIt()
  if lastkey() == K_ESC .or. lastkey() == K_PGDN
    return NIL
  endif 

  select( cItMeTMP )
  set order    to 1

  bFirst := {|| dbseek( '01', .t. ) }
  bLast  := {|| dbseek( '99', .t. ), dbskip(-1) }
  bFor   := {|| .t. }
  bWhile := {|| .t. }

  oColuna           := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oColuna:nTop      := 6
  oColuna:nLeft     := 4
  oColuna:nBottom   := 19
  oColuna:nRight    := 75
  oColuna:headsep   := chr(194)+chr(196)
  oColuna:colsep    := chr(179)
  oColuna:footsep   := chr(193)+chr(196)
  oColuna:colorSpec := CorJanel

  oColuna:addColumn( TBColumnNew("N.",       {|| Item } ) )
  oColuna:addColumn( TBColumnNew("Descrição",{|| left( Desc, 18 ) } ) )
  oColuna:addColumn( TBColumnNew("Ta",       {|| Tama } ) )
  oColuna:addColumn( TBColumnNew("Li",       {|| transform( Linh, '@E 99' ) } ) )
  oColuna:addColumn( TBColumnNew("Co",       {|| transform( Colu, '@E 99' ) } ) )
  oColuna:addColumn( TBColumnNew("Mensagem", {|| left( Mens, 28 ) } ) )
  oColuna:addColumn( TBColumnNew("X",        {|| Expr } ) )
  oColuna:addColumn( TBColumnNew("ação",     {|| left( Acao, 10 ) } ) )
            
  lExitRequested := .f.
  lAdiciona      := .f.
  lAltera        := .f.
  cSequ          := space(02)
  nSequ          := 0
  nItem          := 0
  nLin           := 9

  oColuna:goBottom()

  do while !lExitRequested
    Mensagem ( 'ItMe', 'EntrItIt' )
 
    oColuna:forcestable()
   
    cTecla := Teclar(0)

    if oColuna:hitTop .or. oColuna:hitBottom
      tone( 125, 0 )
    endif

    do case
      case cTecla == K_DOWN;        oColuna:down()
      case cTecla == K_UP;          oColuna:up()
      case cTecla == K_LEFT;        oColuna:left()
      case cTecla == K_RIGHT;       oColuna:right()
      case cTecla == K_PGUP;        oColuna:pageUp()
      case cTecla == K_CTRL_PGUP;   oColuna:goTop()
      case cTecla == K_PGDN;        oColuna:pageDown()
      case cTecla == K_CTRL_PGDN;   oColuna:goBottom()
      case cTecla == K_ESC;         lExitRequested := .t.
      case cTecla == 46;            lExitRequested := .t.
      case cTecla == K_ENTER
        if val( Item ) > 0
          do case 
            case oColuna:colPos == 1
              lAdiciona := .f.
           
              EntrItItMe( lAdiciona, oColuna, nLin )
            case oColuna:colPos == 2
              cDesc := Desc
  
              nLin  := 07 + oColuna:rowPos
    
              set key K_ALT_P to PrinSeta ()
              setcolor ( CorJanel + ',' + CorCampo )  
              @ nLin, 07 get cDesc         pict '@S18'  
              read

              set key K_ALT_P to 
              
              if lastkey() != K_ESC
                if RegLock()
                  replace Desc     with cDesc
                  dbunlock()
                endif
       
                oColuna:refreshAll()  
              endif
            
            case oColuna:colPos == 3
              nTama := Tama
  
              nLin  := 07 + oColuna:rowPos
    
              setcolor ( CorJanel + ',' + CorCampo )  
              @ nLin, 26 get nTama      pict '99'
              read
              
              if lastkey() != K_ESC
                if RegLock()
                  replace Tama     with nTama
                  dbunlock()
                endif
       
                oColuna:refreshAll()  
              endif
            
            case oColuna:colPos == 4
              nLinh := Linh
  
              nLin  := 07 + oColuna:rowPos
    
              setcolor ( CorJanel + ',' + CorCampo )  
              @ nLin, 29 get nLinh      pict '99'
              read
              
              if lastkey() != K_ESC
                if RegLock()
                  replace Linh     with nLinh
                  dbunlock()
                endif
       
                oColuna:refreshAll()  
              endif
            
            case oColuna:colPos == 5
              nColu := Colu
  
              nLin  := 07 + oColuna:rowPos
    
              setcolor ( CorJanel + ',' + CorCampo )  
              @ nLin, 32 get nColu         pict '99'  
              read
              
              if lastkey() != K_ESC
                if RegLock()
                  replace Colu     with nColu
                  dbunlock()
                endif
       
                oColuna:refreshAll()  
              endif
            
            case oColuna:colPos == 6
              cMens := Mens
  
              nLin  := 07 + oColuna:rowPos
    
              setcolor ( CorJanel + ',' + CorCampo )  
              @ nLin, 35 get cMens         pict '@S28'  
              read
              
              if lastkey() != K_ESC
                if RegLock()
                  replace Mens     with cMens
                  dbunlock()
                endif
       
                oColuna:refreshAll()  
              endif
           endcase   
            
        endif
      case cTecla == K_INS
        nRegi := recno()
        
        dbgotop()                
        do while !eof()
          nItem := val( Item )
          dbskip()
        enddo

        go nRegi

        do while lastkey() != K_ESC    
          lAdiciona := .t.
          
          EntrItItMe( lAdiciona, oColuna, nLin )
        enddo  
      case cTecla == K_DEL
        if RegLock()
          replace Lixo      with .t.  
            
          dbdelete ()
          dbunlock ()
    
          oColuna:refreshAll()  
        endif  
      case cTecla == K_ALT_A
         ItenMenu( lAdiciona, oColuna, nLin )

         oColuna:refreshAll()  
    endcase
  enddo
return NIL  

//
// Entra Itens do Menu
//
function EntrItItMe( lAdiciona, oColuna, nLin )
  if lAdiciona 
    cItem := strzero( nItem + 1, 2 )
      
    if AdiReg()
      if RegLock()
        replace Item            with cItem
        replace Novo            with .t.
        replace Lixo            with .f.
        dbunlock ()
      endif
    endif    
    
    dbgobottom ()

    oColuna:goBottom() 
    oColuna:refreshAll()  

    oColuna:forcestable()

    Mensagem( 'ItMe', 'ItMeIncl' )
  else
    Mensagem( 'ItMe', 'ItMeAlte' )
  endif  

  cItem  := Item
  nItem  := val( Item )
  cDesc  := Desc
  nLinh  := Linh
  nColu  := Colu 
  cMens  := Mens
  nTama  := Tama
  
  lExPr  := ExPr 
  cAcao  := Acao
  nLin   := 07 + oColuna:rowPos

  set key K_ALT_P to PrinSeta ()
    
  setcolor ( CorJanel + ',' + CorCampo )
  @ nLin, 04 get cItem         pict '99' 
  @ nLin, 07 get cDesc         pict '@S18'  
  @ nLin, 26 get nTama         pict '99'
  @ nLin, 29 get nLinh         pict '99'
  @ nLin, 32 get nColu         pict '99'
  @ nLin, 35 get cMens         pict '@S28'  
  @ nLin, 64 get lExpr         pict '@!'  
  @ nLin, 66 get cAcao         pict '@S10'  
  read

  set key K_ALT_P  to  
  set key K_UP     to
     
  if lastkey () == K_ESC
    if lAdiciona
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif  
    endif  

    oColuna:refreshCurrent()  
    return NIL
  endif  
  
  if RegLock()
    replace Item            with cItem
    replace Desc            with cDesc
    replace Linh            with nLinh
    replace Colu            with nColu
    replace Tama            with nTama
    replace Linh            with nLinh
    replace Mens            with cMens
    replace ExPr            with lExPr
    replace Acao            with cAcao
    replace Lixo            with .f.
    dbunlock ()
  endif
  
  oColuna:refreshAll()  
return NIL     

//
// Entra o estoque
//
function GravItem()
  
  set deleted off   
    
  select( cItMeTMP )
  set order to 1 
  dbgotop ()
  do while !eof ()
    if empty( Item )
      dbskip ()
      loop
    endif  
      
    nRegi := Regi
    lLixo := Lixo
      
    if Novo
      if Lixo
        dbskip ()
        loop
      endif  
    
      select MenuARQ
      if AdiReg()
        if RegLock()
          replace Modu     with cModu
          replace Menu     with cMenu
          replace Idio     with cIdio
          replace Modulo   with &cItMeTMP->Modulo
          replace Item     with &cItMeTMP->Item
          replace Desc     with &cItMeTMP->Desc
          replace Tama     with &cItMeTMP->Tama
          replace Tecl     with &cItMeTMP->Tecl
          replace Linh     with &cItMeTMP->Linh
          replace Colu     with &cItMeTMP->Colu
          replace Mens     with &cItMeTMP->Mens
          replace ExPr     with &cItMeTMP->ExPr
          replace Acao     with &cItMeTMP->Acao
          dbunlock ()
        endif
      endif   
    else 
      select MenuARQ
      go nRegi
      
      if lLixo
        if RegLock()
          dbdelete ()
          dbunlock ()
        endif
      else  
        if RegLock()
          replace Modulo   with &cItMeTMP->Modulo
          replace Item     with &cItMeTMP->Item
          replace Desc     with &cItMeTMP->Desc
          replace Tama     with &cItMeTMP->Tama
          replace Tecl     with &cItMeTMP->Tecl
          replace Linh     with &cItMeTMP->Linh
          replace Colu     with &cItMeTMP->Colu
          replace Tama     with &cItMeTMP->Tama
          replace Mens     with &cItMeTMP->Mens
          replace ExPr     with &cItMeTMP->ExPr
          replace Acao     with &cItMeTMP->Acao
          dbunlock ()
        endif  
      endif
    endif 
      
    select( cItMeTMP )
    dbskip ()
  enddo  
   
  set deleted on
  
  select MenuARQ
return NIL


//
// Criar Duplicata
//  
function CriaDP ()
  local tModi := savescreen( 00, 00, 23, 79 ) 

  if NetUse( "CampARQ", .t. )
    VerifIND( "CampARQ" )

    #ifdef DBF_NTX
      set index to CampIND1, CampIND2
    #endif  
  endif

  if NetUse( "DuplARQ", .t. )
    VerifIND( "DuplARQ" )

    #ifdef DBF_NTX
      set index to DuplIND1
    #endif  
  endif
  
  select DuplARQ
  set order to 1
  Janela( 05, 10, 17, 63, mensagem( 'Janela', 'CriaDP', .f. ), .f. )  
  Mensagem( 'ItMe', 'CriaDP' )

  setcolor( CorJanel + ',' + CorCampo )
  oDuplicata           := TBrowseDB( 07, 11, 15, 62 )
  oDuplicata:headsep   := chr(194)+chr(196)
  oDuplicata:colsep    := chr(179)
  oDuplicata:footsep   := chr(193)+chr(196)
  oDuplicata:colorSpec := CorJanel
 
  oDuplicata:addColumn( TBColumnNew( 'Descrição', {|| left( Desc, 20 ) } ) )
  oDuplicata:addColumn( TBColumnNew( 'Col.',       {|| iif( Colu == 1, ' 80', '132' ) } ) )
  oDuplicata:addColumn( TBColumnNew( 'Com.',       {|| iif( Comp == 1, 'Sim', 'Não' ) } ) )
  oDuplicata:addColumn( TBColumnNew( 'Esp.',       {|| iif( Espa == 1, '1/6' + chr(34), '1/8' + chr(34) ) } ) )
  oDuplicata:addColumn( TBColumnNew( 'Linha',      {|| QtLinha } ) )
  
  oDuplicata:goTop ()

  lExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ''
  cAjuda         := 'Dupl' 
  lAjud          := .f.
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 08, 15, 63, nTotal )

  setcolor ( CorCampo )
  @ 16,26 say space(32)

  setcolor( CorJanel + ',' + CorCampo )
  @ 08,10 say chr(195)
  @ 15,10 say chr(195)
  @ 16,17 say 'Consulta'
    
  do while !lExitRequested
    Mensagem( 'ItMe', 'CriaDP1' )

    oDuplicata:forcestable() 

    iif( BarraSeta, BarraSeta( nLinBarra, 08, 15, 63, nTotal ), NIL )
       
    if oDuplicata:stable
      if oDuplicata:hitTop .or. oDuplicata:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oDuplicata:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oDuplicata:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
      
    do case
      case cTecla == K_DOWN;       oDuplicata:down()
      case cTecla == K_UP;         oDuplicata:up()
      case cTecla == K_PGDN;       oDuplicata:pageDown()
      case cTecla == K_PGUP;       oDuplicata:pageUp()
      case cTecla == K_CTRL_PGUP;  oDuplicata:goTop()
      case cTecla == K_CTRL_PGDN;  oDuplicata:goBottom()
      case cTecla == K_F1;         Ajuda()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_INS
        tFiscal := savescreen( 00, 00, 23, 79 )
        
        Janela( 08, 07, 14, 67, mensagem( 'Janela', 'CriaDP1', .f. ), .f. )
        Mensagem( 'ItMe', 'CriaDP2' )

        setcolor( CorJanel + ',' + CorCampo )
        @ 10,09 say '   Descrição'
        @ 12,09 say '  Impressora                       Compactar'
        @ 13,09 say ' Espaçamento                    Qtde. Linhas'
        
        setcolor( CorCampo )
        @ 10,22 say space(30)
        @ 12,22 say ' 80 Col '
        @ 12,31 say ' 132 Col '
        @ 12,54 say ' Sim '
        @ 12,60 say ' Não '
        @ 13,22 say ' 1/6" '
        @ 13,29 say ' 1/8" '
        @ 13,54 say '    '

        setcolor( CorAltKC )
        @ 12,23 say '8'
        @ 12,32 say '1'
        @ 12,55 say 'S'
        @ 12,61 say 'N'
        @ 13,23 say '1'
        @ 13,32 say '8'

        cDesc    := space(30)
        nColu    := 1
        nComp    := 1
        nEspa    := 1
        nQtLinha := 0

        setcolor( CorJanel )
        @ 10,22 get cDesc                  pict '@!'
        read

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        aOpc := {}

        aadd( aOpc, { ' 80 Col ', 2,  '8', 12, 22, "Impressora 80 coluna." } )
        aadd( aOpc, { ' 132 Col ', 2, '1', 12, 31, "Impressora 132 colunas." } )

        nColu := HCHOICE( aOpc, 2, nColu )

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        aOpc := {}

        aadd( aOpc, { ' Sim ', 2, 'S', 12, 54, "Compactar a letra. (Letra Menor)" } )
        aadd( aOpc, { ' Não ', 2, 'N', 12, 60, "Não Compactar a letra. (Letra Normal)" } )

        nComp := HCHOICE( aOpc, 2, nComp )

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        aOpc  := {}

        aadd( aOpc, { ' 1/6" ', 2, '1', 13, 22, "Configurar o espaçamento entre linha. (Espaçamento Maior)" } )
        aadd( aOpc, { ' 1/8" ', 4, '8', 13, 29, "Configurar o espaçamento entre linha. (Espaçamento Menor)" } )

        nEspa := HCHOICE( aOpc, 2, nEspa )

        setcolor( CorJanel )
        @ 13,54 get nQtLinha                  pict '9999'
        read
        
        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        select DuplARQ
        set order to 1
        dbgobottom ()

        nCod := Codigo + 1
        
        if AdiReg()
          if RegLock()
            replace Desc            with cDesc
            replace Colu            with nColu
            replace Comp            with nComp
            replace Espa            with nEspa
            replace QtLinha         with nQtLinha
            replace Codigo          with nCod
            dbunlock ()
          endif
        endif
        
        CaseLayout ()     
        Duplicata ()  

        restscreen( 00, 00, 23, 79, tFiscal )

        oDuplicata:refreshAll()
      case cTecla == K_BS
        cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
      
        setcolor ( CorCampo )
        @ 16,26 say space(32)
        @ 16,26 say cLetra
      case cTecla >= 32 .and. cTecla <= 128
        cLetra += chr( cTecla )    
        
        if len( cLetra ) > 32
          cLetra := '' 
        endif
       
        setcolor ( CorCampo )
        @ 16,26 say space(32)
        @ 16,26 say cLetra

        dbseek( cLetra, .t. )
        oDuplicata:refreshAll()
      case cTecla == K_DEL
        if ConfAlte ()
          ferase( cCaminho + HB_OSpathseparator() + "LAYOUT" + HB_OSpathseparator() + "DP-" + strzero( Codigo, 4 ) + ".TXT" )
        
          if RegLock()
            dbdelete ()  
            dbunlock ()
          endif  
        endif
        
        oDuplicata:refreshAll()
      case cTecla == K_ENTER
        CaseLayout ()     
        Duplicata ()  
    endcase
  enddo  
  
  select DuplARQ
  close
  select CampARQ
  close
  
  restscreen( 00, 00, 23, 79, tModi )
return NIL  
                                                  // Define o layout do campo memo      
function CaseLayout ()      
  if Comp == 1                    // Compactar - Sim
    if Colu == 1                  // Coluna - 80
      nTama := 132
    else
      nTama := 232
    endif
  else
    if Colu == 1
      nTama := 80
    else
      nTama := 132
    endif
  endif

  if RegLock()
    replace Tama           with nTama
    dbunlock ()
  endif
return NIL        

//
// Layout da Duplicata
//
function Duplicata ()
  local tFisc := savescreen( 00, 00, 23, 79 )

  Janela( 01, 01, 21, 78, mensagem( 'Janela', 'Duplicata', .f. ), .F. )
  Mensagem( "ItMe", "Duplicata" )
                     
  cTxt    := memoread( cCaminho + HB_OSpathseparator() + 'LAYOUT' + HB_OSpathseparator() + 'DP-' + strzero( Codigo, 4 ) + '.TXT' )
  cLayout := memoedit( cTxt, 02, 03, 20, 77, .t., "OutMemo", Tama + 1, , , 1, 0 )
  
  select DuplARQ
  
  if lastkey() == K_CTRL_W   
    nHandle := fcreate( cCaminho + HB_OSpathseparator() + "LAYOUT" + HB_OSpathseparator() + "DP-" + strzero( Codigo, 4 ) + ".TXT", 0 )
 
    fwrite( nHandle, cLayout + chr(13) + chr(10) )       

    fclose( nHandle )
  endif  

  restscreen( 00, 00, 23, 79, tFisc )
return NIL

function OutMemo( wModo, wlin , wCol )
  setcolor( CorCabec )
  @ 01,60 say "Lin: " + str( wLin, 2 ) + " Col: " + str( wCol, 3 )

  setcolor( CorJanel )
  nKey    := lastkey()
  cRetVal := 0
  cAlias  := alias ()
  
  do case 
    case nKey == K_CTRL_RET;      cRetVal := K_ESC
    case nKey == K_ALT_F;         tALT    := savescreen( 00, 00, 23, 79 )
      Aguarde ()
      
      if !TestPrint( 1 )
        set device to screen
        return NIL
      endif     
  
      setprc( 0, 0 )

      if &cAlias->Comp == 1
        @ 00,00 say chr(15)
      else  
        @ 00,00 say chr(18)
      endif  
      
      if &cAlias->Espa == 1
        @ 00,00 say chr(27) + '@'
      else
        @ 00,00 say chr(27) + chr(48)
      endif  
      
      if &cAlias->Tama == 132
        cLinha := '123456789d123456789v123456789t123456789q123456789c123456789s123456789s123456789o123456789n123456789c123456789d123456789v123456789 '
      else
        cLinha := '123456789d123456789v123456789t123456789q123456789c123456789s123456789s12345678 '
      endif  
      
      nLin := 0
        
      for nLinhas := 1 to &cAlias->QtLinha
        @ nLin,00 say cLinha + strzero( nLinhas, 2 )
        nLin ++
      next

      set device to screen
      restscreen( 00, 00, 23, 79, tALT )
    case nKey == K_F4
      CadeCampo ()
  endcase

  setcolor( CorJanel )
return( cRetVal )

//
// Mostra os tipos de vari veis
//
function MostTipo( xTipo )
  setcolor( CorCampo )
  do case
    case upper( cTipo ) == 'C'
      @ 10,27 say 'Caracter  '
    case upper( cTipo ) == 'V'
      @ 10,27 say 'Vari vel  '
    case upper( cTipo ) == 'N'
      @ 10,27 say 'Num‚rico  '
    case upper( cTipo ) == 'D'
      @ 10,27 say 'Data      '
    case upper( cTipo ) == 'I'
      @ 10,27 say 'Itens     '
    case upper( cTipo ) == 'M'
      @ 10,27 say 'Memo      '
    case upper( cTipo ) == 'O' 
      @ 10,27 say 'Observação'
    otherwise
      Alerta( mensagem( 'Alerta', 'MostTipo', .f. ) )
  endcase    
  
  cTipo := upper( xTipo )

  setcolor( CorJanel + ',' + CorCampo )
return(.t.)

//
// Escolhe campo para o layout
//
function CadeCampo ()    
  select CampARQ
  set order to 1

  tCampo := savescreen( 00, 00, 23, 79 )

  Janela ( 03, 02, 17, 75, mensagem( 'Janela', 'CadeCampo', .f. ), .f. )

  oCampo           := TBrowseDb( 5, 3, 15, 74 )
  oCampo:headsep   := chr(194)+chr(196)
  oCampo:colsep    := chr(179)
  oCampo:footsep   := chr(193)+chr(196)
  oCampo:colorSpec := CorJanel

  oCampo:addColumn( TBColumnNew("Descrição",    {|| Desc } ) )
  oCampo:addColumn( TBColumnNew("Vari vel",     {|| left( Campo, 30 ) } ) )
  oCampo:addColumn( TBColumnNew("Arquivo",      {|| Arquivo } ) )
  oCampo:addColumn( TBColumnNew("Tipo",         {|| Tipo } ) )
  oCampo:addColumn( TBColumnNew("Tamanho",      {|| Tamanho } ) )
  oCampo:addColumn( TBColumnNew("Mascara",      {|| Mascara } ) )
  oCampo:addColumn( TBColumnNew("Campo Layout", {|| View } ) )

  oCampo:gotop ()

  lExitRequested := .f.
  nLinBarra      := 1
  nTotal         := lastrec()
  cLetra         := ''
  BarraSeta      := BarraSeta( nLinBarra, 6, 15, 74, nTotal )

  setcolor ( CorCampo )
  @ 16,14 say space(32)

  setcolor( CorJanel + ',' + CorCampo )
  @ 06,02 say chr(195)
  @ 15,02 say chr(195)
  @ 16,05 say 'Consulta'

  do while !lExitRequested
    Mensagem( 'ItMe', 'CadeCampo' )

    oCampo:forcestable()

    iif( BarraSeta, BarraSeta( nLinBarra, 6, 15, 74, nTotal ), NIL )

    if oCampo:stable
      if oCampo:hitTop .or. oCampo:hitBottom
        tone( 125, 0 )
      endif
      
      cTecla := Teclar(0)
    endif

    do case
      case cTecla == K_DOWN
        if !oCampo:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal
          endif
        endif
      case cTecla == K_UP
        if !oCampo:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif
        endif
    endcase

    do case
      case cTecla == K_DOWN;       oCampo:down()
      case cTecla == K_UP;         oCampo:up()
      case cTecla == K_PGDN;       oCampo:pageDown()
      case cTecla == K_PGUP;       oCampo:pageUp()
      case cTecla == K_LEFT;       oCampo:left()
      case cTecla == K_RIGHT;      oCampo:right()
      case cTecla == K_CTRL_PGUP;  oCampo:goTop()
      case cTecla == K_CTRL_PGDN;  oCampo:gobottom()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_BS
        cLetra := substr( cLetra, 1, len( cLetra ) - 1 )

        setcolor ( CorCampo )
        @ 16,14 say space(32)
        @ 16,14 say cLetra
      case cTecla >= 32 .and. cTecla <= 128
        cLetra += upper( chr( cTecla ) )

        if len( cLetra ) > 32
          cLetra := ''
        endif

        setcolor ( CorCampo )
        @ 16,14 say space(32)
        @ 16,14 say cLetra

        dbseek( cLetra, .t. )
        oCampo:refreshAll()
      case cTecla == K_ALT_A
        tAltera := savescreen( 00, 00, 23, 79 )
        Janela( 06, 10, 15, 70, mensagem( 'Janela', 'CadeCampo1', .f. ), .f. )
        Mensagem( 'ItMe', 'CadeCampo1' ) 

        setcolor( CorJanel + ',' + CorCampo )
        @ 08,12 say '   Descrição'
        @ 09,12 say '    Vari vel'
        @ 10,12 say '        Tipo'
        @ 11,12 say '     Arquivo'
        @ 12,12 say '     Tamanho'
        @ 13,12 say '     Mascara'
        @ 14,12 say 'Campo Layout'

        cDesc    := Desc
        cCampo   := Campo
        cTipo    := Tipo
        cArquivo := Arquivo
        nTamanho := Tamanho
        cMascara := Mascara
        cView    := View

        setcolor( CorCampo )
        do case
          case upper( cTipo ) == 'C'
            @ 10,27 say 'Caracter  '
          case upper( cTipo ) == 'V'
            @ 10,27 say 'Vari vel  '
          case upper( cTipo ) == 'N'
            @ 10,27 say 'Num‚rico  '
          case upper( cTipo ) == 'D'
            @ 10,27 say 'Data      '
          case upper( cTipo ) == 'I'
            @ 10,27 say 'Itens     '
          case upper( cTipo ) == 'M'
            @ 10,27 say 'Memo      '
          case upper( cTipo ) == 'O'
            @ 10,27 say 'Observação'
          otherwise
            @ 10,27 say '          '
        endcase

        setcolor( CorJanel + ',' + CorCampo )

        @ 08,25 get cDesc                 pict '@!'
        @ 09,25 get cCampo                pict '@S43'
        @ 10,25 get cTipo                 valid MostTipo( cTipo )
        @ 11,25 get cArquivo
        @ 12,25 get nTamanho              pict '999'
        @ 13,25 get cMascara
        @ 14,25 get cView
        read
        
        if lastkey() != K_ESC
          if RegLock()
            replace Tipo          with cTipo
            replace Desc          with cDesc
            replace Campo         with cCampo
            replace Arquivo       with cArquivo
            replace Tamanho       with nTamanho
            replace Mascara       with cMascara
            replace View          with cView
            dbunlock ()
          endif

          oCampo:refreshAll()
        endif
        restscreen( 00, 00, 23, 79, tAltera )
      case cTecla == K_DEL
        if RegLock ()
          dbdelete ()
          dbunlock ()
        endif

        oCampo:refreshAll()
      case cTecla == K_INS
        tAltera := savescreen( 00, 00, 23, 79 )
        Janela( 06, 10, 15, 70, mensagem( 'Janela', 'CadeCampo3', .f. ), .f. )

        setcolor( CorCampo )
        @ 10,27 say '       '

        setcolor( CorJanel + ',' + CorCampo )
        @ 08,12 say '   Descrição'
        @ 09,12 say '    Vari vel'
        @ 10,12 say '        Tipo'
        @ 11,12 say '     Arquivo'
        @ 12,12 say '     Tamanho'
        @ 13,12 say '     Mascara'
        @ 14,12 say 'Campo Layout'

        cDesc    := space(30)
        cCampo   := space(100)
        cArquivo := space(08)
        nTamanho := 0
        cTipo    := space(01)
        cMascara := space(20)
        cView    := space(20)

        @ 08,25 get cDesc                 pict '@!' 
        @ 09,25 get cCampo                pict '@S43'
        @ 10,25 get cTipo                 valid MostTipo( cTipo )
        @ 11,25 get cArquivo

        nTamanho := len( alltrim( cCampo ) )

        @ 12,25 get nTamanho              pict '999'
        @ 13,25 get cMascara
        @ 14,25 get cView
        read

        if lastkey() != K_ESC
          if AdiReg()
            if RegLock()
              replace Tipo          with cTipo
              replace Desc          with cDesc
              replace Campo         with cCampo
              replace Arquivo       with cArquivo
              replace Tamanho       with nTamanho
              replace Mascara       with cMascara
              replace View          with cView
              dbunlock ()
            endif
          endif

          oCampo:refreshAll()
        endif
        restscreen( 00, 00, 23, 79, tAltera )
      case cTecla == K_ENTER;         lExitRequested := .t.
        keyboard( alltrim( View ) )
    endcase
  enddo

  lExitRequested := .f.
  restscreen( 00, 00, 23, 79, tCampo )
return NIL

//
// Criar Nota
//  
function CriaNP ()
  local tModi := savescreen( 00, 00, 23, 79 ) 

  if NetUse( "CampARQ", .t. )
    VerifIND( "CampARQ" )

    #ifdef DBF_NTX
      set index to CampIND1, CampIND2
    #endif  
  endif

  if NetUse( "NoPrARQ", .t. )
    VerifIND( "NoPrARQ" )

    #ifdef DBF_NTX
      set index to NoPrIND1
    #endif  
  endif
  
  select NoPrARQ
  set order to 1
  Janela( 05, 10, 17, 63, mensagem( 'Janela', 'CriaNP', .f. ), .f. )  

  setcolor( CorJanel + ',' + CorCampo )
  oNota           := TBrowseDB( 07, 11, 15, 62 )
  oNota:headsep   := chr(194)+chr(196)
  oNota:colsep    := chr(179)
  oNota:footsep   := chr(193)+chr(196)
  oNota:colorSpec := CorJanel
 
  oNota:addColumn( TBColumnNew( 'Descrição', {|| left( Desc, 15 ) } ) )
  oNota:addColumn( TBColumnNew( 'Col.',       {|| iif( Colu == 1, ' 80', '132' ) } ) )
  oNota:addColumn( TBColumnNew( 'Com.',       {|| iif( Comp == 1, 'Sim', 'Não' ) } ) )
  oNota:addColumn( TBColumnNew( 'Esp.',       {|| iif( Espa == 1, '1/6' + chr(34), '1/8' + chr(34) ) } ) )
  oNota:addColumn( TBColumnNew( 'Linha',      {|| QtLinha } ) )

  oNota:goTop ()

  lExitRequested := .f.
  nLinBarra      := 1
  cAjuda         := 'NPro'
  lAjud          := .f.
  cLetra         := ''
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 08, 15, 63, nTotal )

  setcolor ( CorCampo )
  @ 16,26 say space(32)

  setcolor( CorJanel + ',' + CorCampo )
  @ 08,10 say chr(195)
  @ 15,10 say chr(195)
  @ 16,17 say 'Consulta'
    
  do while !lExitRequested
    Mensagem( 'ItMe', 'CriaNP')

    oNota:forcestable() 

    iif( BarraSeta, BarraSeta( nLinBarra, 08, 15, 63, nTotal ), NIL )
       
    if oNota:stable
      if oNota:hitTop .or. oNota:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oNota:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oNota:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
      
    do case
      case cTecla == K_DOWN;       oNota:down()
      case cTecla == K_UP;         oNota:up()
      case cTecla == K_PGDN;       oNota:pageDown()
      case cTecla == K_PGUP;       oNota:pageUp()
      case cTecla == K_CTRL_PGUP;  oNota:goTop()
      case cTecla == K_CTRL_PGDN;  oNota:goBottom()
      case cTecla == K_F1;         Ajuda ()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_INS
        tFiscal := savescreen( 00, 00, 23, 79 )
        
        Janela( 08, 07, 14, 67, mensagem( 'Janela', 'CriaNP1', .f. ), .f. )
        Mensagem( 'ItMe', 'CriaNP1' )

        setcolor( CorJanel + ',' + CorCampo )
        @ 10,09 say '   Descrição'
        @ 12,09 say '  Impressora                       Compactar'
        @ 13,09 say ' Espaçamento                    Qtde. Linhas'
        
        setcolor( CorCampo )
        @ 10,22 say space(30)
        @ 12,22 say ' 80 Col '
        @ 12,31 say ' 132 Col '
        @ 12,54 say ' Sim '
        @ 12,60 say ' Não '
        @ 13,22 say ' 1/6" '
        @ 13,29 say ' 1/8" '
        @ 13,54 say '    '

        setcolor( CorAltKC )
        @ 12,23 say '8'
        @ 12,32 say '1'
        @ 12,55 say 'S'
        @ 12,61 say 'N'
        @ 13,23 say '1'
        @ 13,32 say '8'

        cDesc    := space(30)
        nColu    := 1
        nComp    := 1
        nEspa    := 1
        nQtLinha := 0

        setcolor( CorJanel )
        @ 10,22 get cDesc             pict '@!'
        read

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        aOpc := {}

        aadd( aOpc, { ' 80 Col ', 2,  '8', 12, 22, "Impressora 80 coluna." } )
        aadd( aOpc, { ' 132 Col ', 2, '1', 12, 31, "Impressora 132 colunas." } )

        nColu := HCHOICE( aOpc, 2, nColu )

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        aOpc := {}

        aadd( aOpc, { ' Sim ', 2, 'S', 12, 54, "Compactar a letra. (Letra Menor)" } )
        aadd( aOpc, { ' Não ', 2, 'N', 12, 60, "Não Compactar a letra. (Letra Normal)" } )

        nComp := HCHOICE( aOpc, 2, nComp )

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        aOpc  := {}

        aadd( aOpc, { ' 1/6" ', 2, '1', 13, 22, "Configurar o espaçamento entre linha. (Espaçamento Maior)" } )
        aadd( aOpc, { ' 1/8" ', 4, '8', 13, 29, "Configurar o espaçamento entre linha. (Espaçamento Menor)" } )

        nEspa := HCHOICE( aOpc, 2, nEspa )

        setcolor( CorJanel )
        @ 13,54 get nQtLinha                  pict '9999'
        read
        
        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        select NoPrARQ
        set order to 1
        dbgobottom ()

        nCod := Codigo + 1
        
        if AdiReg()
          if RegLock()
            replace Desc            with cDesc
            replace Colu            with nColu
            replace Comp            with nComp
            replace Espa            with nEspa
            replace QtLinha         with nQtLinha
            replace Codigo          with nCod
            dbunlock ()
          endif
        endif
        
        CaseLayout ()     
        NotaProm ()  

        restscreen( 00, 00, 23, 79, tFiscal )

        oNota:refreshAll()
      case cTecla == K_BS
        cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
      
        setcolor ( CorCampo )
        @ 16,26 say space(32)
        @ 16,26 say cLetra
      case cTecla >= 32 .and. cTecla <= 128
        cLetra += chr( cTecla )    
        
        if len( cLetra ) > 32
          cLetra := '' 
        endif
       
        setcolor ( CorCampo )
        @ 16,26 say space(32)
        @ 16,26 say cLetra

        dbseek( cLetra, .t. )
        oNota:refreshAll()
      case cTecla == K_DEL
        if ConfAlte ()
          ferase( cCaminho + HB_OSpathseparator() + "LAYOUT" + HB_OSpathseparator() + "NP-" + strzero( Codigo, 4 ) + ".TXT" )

          if RegLock()
            dbdelete ()  
            dbunlock ()
          endif  
        endif  
        
        oNota:refreshAll()
      case cTecla == K_ENTER
        CaseLayout ()     
        NotaProm ()
    endcase
  enddo  
  
  select NoPrARQ
  close
  select CampARQ
  close
  
  restscreen( 00, 00, 23, 79, tModi )
return NIL  

//
// Layout da Nota Promissória
//
function NotaProm()
  local tFisc := savescreen( 00, 00, 23, 79 )

  Janela( 01, 01, 21, 78, mensagem( 'Janela', 'NotaProm', .f. ), .F. )
  Mensagem( "ItMe", "NotaProm" )
                     
  cTxt    := memoread( cCaminho + HB_OSpathseparator() + 'LAYOUT' + HB_OSpathseparator() + 'NP-' + strzero( Codigo, 4 ) + '.TXT' )
  cLayout := memoedit( cTxt, 02, 03, 20, 77, .t., "OutMemo", Tama + 1, , , 1, 0 )
  
  select NoPrARQ
  
  if lastkey() == K_CTRL_W   
    nHandle := fcreate( cCaminho + HB_OSpathseparator() + "LAYOUT" + HB_OSpathseparator() + "NP-" + strzero( Codigo, 4 ) + ".TXT", 0 )
 
    fwrite( nHandle, cLayout + chr(13) + chr(10) )       

    fclose( nHandle )
  endif  

  restscreen( 00, 00, 23, 79, tFisc )
return NIL

//
// Criar Carnˆ
//  
function CriaCa ()
  local tModi := savescreen( 00, 00, 23, 79 ) 

  if NetUse( "CampARQ", .t. )
    VerifIND( "CampARQ" )

    #ifdef DBF_NTX
      set index to CampIND1, CampIND2
    #endif  
  endif

  if NetUse( "CarnARQ", .t. )
    VerifIND( "CarnARQ" )

    #ifdef DBF_NTX
      set index to CarnIND1
    #endif  
  endif
  
  select CarnARQ
  set order to 1
  Janela( 05, 10, 17, 63, mensagem( 'Janela', 'CriaCa', .f. ), .f. )  

  setcolor( CorJanel + ',' + CorCampo )
  oCarne           := TBrowseDB( 07, 11, 15, 62 )
  oCarne:headsep   := chr(194)+chr(196)
  oCarne:colsep    := chr(179)
  oCarne:footsep   := chr(193)+chr(196)
  oCarne:colorSpec := CorJanel
 
  oCarne:addColumn( TBColumnNew( 'Descrição.', {|| left( Desc, 20 ) } ) )
  oCarne:addColumn( TBColumnNew( 'Col.',       {|| iif( Colu == 1, ' 80', '132' ) } ) )
  oCarne:addColumn( TBColumnNew( 'Com.',       {|| iif( Comp == 1, 'Sim', 'Não' ) } ) )
  oCarne:addColumn( TBColumnNew( 'Esp.',       {|| iif( Espa == 1, '1/6' + chr(34), '1/8' + chr(34) ) } ) )
  oCarne:addColumn( TBColumnNew( 'Linha',      {|| QtLinha } ) )
  
  oCarne:goTop ()

  lExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ''
  cAjuda         := 'Carn' 
  lAjud          := .f.
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 08, 15, 63, nTotal )

  setcolor ( CorCampo )
  @ 16,26 say space(32)

  setcolor( CorJanel + ',' + CorCampo )
  @ 08,10 say chr(195)
  @ 15,10 say chr(195)
  @ 16,17 say 'Consulta'
    
  do while !lExitRequested
    Mensagem( 'ItMe', 'CriaCa' )

    oCarne:forcestable() 
    
    iif( BarraSeta, BarraSeta( nLinBarra, 08, 15, 63, nTotal ), NIL )
       
    if oCarne:stable
      if oCarne:hitTop .or. oCarne:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oCarne:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oCarne:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
      
    do case
      case cTecla == K_DOWN;       oCarne:down()
      case cTecla == K_UP;         oCarne:up()
      case cTecla == K_PGDN;       oCarne:pageDown()
      case cTecla == K_PGUP;       oCarne:pageUp()
      case cTecla == K_CTRL_PGUP;  oCarne:goTop()
      case cTecla == K_CTRL_PGDN;  oCarne:goBottom()
      case cTecla == K_F1;         Ajuda()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_INS
        tFiscal := savescreen( 00, 00, 23, 79 )
        
        Janela( 08, 07, 14, 67, mensagem( 'Janela', 'CriaCa1', .f. ), .f. )
        Mensagem( 'ItMe', 'CriaCa1' )

        setcolor( CorJanel + ',' + CorCampo )
        @ 10,09 say '   Descrição'
        @ 12,09 say '  Impressora                       Compactar'
        @ 13,09 say ' Espaçamento                    Qtde. Linhas'
        
        setcolor( CorCampo )
        @ 10,22 say space(30)
        @ 12,22 say ' 80 Col '
        @ 12,31 say ' 132 Col '
        @ 12,54 say ' Sim '
        @ 12,60 say ' Não '
        @ 13,22 say ' 1/6" '
        @ 13,29 say ' 1/8" '
        @ 13,54 say '    '

        setcolor( CorAltKC )
        @ 12,23 say '8'
        @ 12,32 say '1'
        @ 12,55 say 'S'
        @ 12,61 say 'N'
        @ 13,23 say '1'
        @ 13,32 say '8'

        cDesc    := space(30)
        nColu    := 1
        nComp    := 1
        nEspa    := 1
        nQtLinha := 0

        setcolor( CorJanel )
        @ 10,22 get cDesc               pict '@!'
        read

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        aOpc := {}

        aadd( aOpc, { ' 80 Col ', 2,  '8', 12, 22, "Impressora 80 coluna." } )
        aadd( aOpc, { ' 132 Col ', 2, '1', 12, 31, "Impressora 132 colunas." } )

        nColu := HCHOICE( aOpc, 2, nColu )

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        aOpc := {}

        aadd( aOpc, { ' Sim ', 2, 'S', 12, 54, "Compactar a letra. (Letra Menor)" } )
        aadd( aOpc, { ' Não ', 2, 'N', 12, 60, "Não Compactar a letra. (Letra Normal)" } )

        nComp := HCHOICE( aOpc, 2, nComp )

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        aOpc  := {}

        aadd( aOpc, { ' 1/6" ', 2, '1', 13, 22, "Configurar o espaçamento entre linha. (Espaçamento Maior)" } )
        aadd( aOpc, { ' 1/8" ', 4, '8', 13, 29, "Configurar o espaçamento entre linha. (Espaçamento Menor)" } )

        nEspa := HCHOICE( aOpc, 2, nEspa )

        setcolor( CorJanel )
        @ 13,54 get nQtLinha                  pict '9999'
        read
        
        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        select CarnARQ
        set order to 1
        dbgobottom ()

        nCod := Codigo + 1
        
        if AdiReg()
          if RegLock()
            replace Desc            with cDesc
            replace Colu            with nColu
            replace Comp            with nComp
            replace Espa            with nEspa
            replace QtLinha         with nQtLinha
            replace Codigo          with nCod
            dbunlock ()
          endif
        endif
        
        CaseLayout ()     
        Carne ()  

        restscreen( 00, 00, 23, 79, tFiscal )

        oCarne:refreshAll()
      case cTecla == K_BS
        cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
      
        setcolor ( CorCampo )
        @ 16,26 say space(32)
        @ 16,26 say cLetra
      case cTecla >= 32 .and. cTecla <= 128
        cLetra += chr( cTecla )    
        
        if len( cLetra ) > 32
          cLetra := '' 
        endif
       
        setcolor ( CorCampo )
        @ 16,26 say space(32)
        @ 16,26 say cLetra

        dbseek( cLetra, .t. )
        oCarne:refreshAll()
      case cTecla == K_DEL
        if ConfAlte ()
          ferase( cCaminho + HB_OSpathseparator() + "LAYOUT" + HB_OSpathseparator() + "CA-" + strzero( Codigo, 4 ) + ".TXT" )
  
          if RegLock()
            dbdelete ()  
            dbunlock ()
          endif  
        endif
               
        oCarne:refreshAll()
      case cTecla == K_ENTER
        CaseLayout ()     
        Carne ()  
    endcase
  enddo  
  
  select CarnARQ
  close
  select CampARQ
  close
  
  restscreen( 00, 00, 23, 79, tModi )
return NIL  

//
// Layout do Carne
//
function Carne()
  local tCarn := savescreen( 00, 00, 23, 79 )

  Janela( 01, 01, 21, 78, mensagem( 'Janela', 'Carne', .f. ), .F. )
  Mensagem( "ItME", "Carne" )
                     
  cTxt    := memoread( cCaminho + HB_OSpathseparator() + 'LAYOUT' + HB_OSpathseparator() + 'CA-' + strzero( Codigo, 4 ) + '.TXT' )
  cLayout := memoedit( cTxt, 02, 03, 20, 77, .t., "OutMemo", Tama + 1, , , 1, 0 )
  
  select CarnARQ
  
  if lastkey() == K_CTRL_W   
    nHandle := fcreate( cCaminho + HB_OSpathseparator() + "LAYOUT" + HB_OSpathseparator() + "CA-" + strzero( Codigo, 4 ) + ".TXT", 0 )
 
    fwrite( nHandle, cLayout + chr(13) + chr(10) )       

    fclose( nHandle )
  endif  

  restscreen( 00, 00, 23, 79, tCarn )
return NIL

//
// Entra intens da nota
//
function ItenMenu( lAdiciona, oCol, nLin )
  tItMe1 := savescreen( 00, 00, 23, 79 )

  select( cItMeTMP )

  Janela( 06, 11, 16, 68, mensagem( 'Janela', 'ItemMenu', .f. ), .f. )
  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,12 say '       Item                        Módulo '
  @ 09,12 say '  Descrição'
  @ 10,12 say 'Tecla Opção'
  @ 11,12 say '      Linha'
  @ 12,12 say '     Coluna'
  @ 13,12 say '   Mensagem'
  @ 14,12 say 'Exec. Prog.'
  @ 15,12 say '       ação'

  if lAdiciona 
    Mensagem( 'ItMe', 'ItemIncl' )
  else
    Mensagem( 'ItMe', 'ItemAlte' )
  endif

  if ! lAdiciona
    nItem    := val( Item )
    cModulo  := Modulo
    cDesc    := Desc
    nTama    := Tama
    nTecl    := Tecl
    nLinh    := Linh
    nColu    := Colu
    cMens    := Mens
    lExPr    := Expr
    cAcao    := Acao
  else
    nItem    := 1
    nLinh    := 0
    nColu    := 0
    cDesc    := space(25)
    cModulo  := space(10)
    nTama    := 25
    nTecl    := 0
    cMens    := space(79)
    lExPr    := .f.
    cAcao    := space(25)
    
    dbgobottom ()
    if ! eof()
      nLinh   := Linh
      nColu   := Colu
      cModulo := Modulo
      nItem   := ( val( Item ) + 1 )
    endif

  endif
  
  set key K_ALT_P  to PrinSeta ()
                       
  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,24 get nItem        pict '99' when !lAdiciona valid nItem >= 0
  @ 08,54 get cModulo      pict '@X' valid !empty( cModulo )
  @ 09,24 get cDesc        pict '@X' valid !empty( cDesc )
  @ 09,50 get nTama        pict '99' valid nTama >= 0
  @ 10,24 get nTecl        pict '99' valid nTecl >= 0
  @ 11,24 get nLinh        pict '99' valid nLinh >= 0
  @ 12,24 get nColu        pict '99' valid nColu >= 0
  @ 13,24 get cMens        pict '@S42'
  @ 14,24 get lExPr        pict 'L'
  @ 15,24 get cAcao        pict '@X'
  read

  set key K_ALT_P  to
  
  xTecla := lastkey()
  
  if xTecla == K_ESC
    restscreen( 00, 00, 23, 79, tItMe1 )
    oCol:refreshCurrent()
    return NIL
  endif
  
  if xTecla == K_UP .or. xTecla == K_ESC
    restscreen( 00, 00, 23, 79, tItMe1 )
    oCol:refreshCurrent()
    return NIL
  endif
  
  if lAdiciona
    if AdiReg(0)
      replace Modu   with cModu
      replace Menu   with cMenu
      replace Novo   with .t.
      dbunlock ()
    endif  
  endif
  
  if RegLock(0)
    replace Item     with strzero( nItem, 2, 0 )
    replace Modulo   with cModulo
    replace Desc     with cDesc
    replace Tama     with nTama
    replace Tecl     with nTecl
    replace Linh     with nLinh
    replace Colu     with nColu
    replace Mens     with cMens
    replace Expr     with lExpr
    replace Acao     with cAcao
    dbunlock ()
  endif  

  restscreen( 00,00,23,79, tItMe1 )
  oCol:refreshAll()
return NIL     

function PrinSeta ()
  cDesc := substr( cDesc, 1, 24 )
  cDesc += chr(16)
return(.t.)