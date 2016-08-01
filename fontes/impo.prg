//  Leve, Importacao de Arquivos
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

// Importar Arquivos (genericos)

function ImpoArqu ()
  local tImpo := savescreen( 00, 00, 23, 79 )
  Janela( 05, 05, 12, 69, mensagem( 'Janela', 'ImpoArqu', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )
  @ 07,07 say ' Origem'
  @ 08,07 say 'Destino'
  @ 09,05 say chr(195) + replicate( chr(196), 63 ) + chr(180)

  @ 10,12 say 'Codigo'
  @ 11,12 say '  Nome'

  setcolor( CorCampo )
  @ 10,19 say '      0'
  @ 11,19 say space(40)
  
  cOrigem   := cCaminho + HB_OSpathseparator() + space(20) 
  cDestino  := cCaminho + HB_OSpathseparator() + space(20) 

//  cOrigem  := "c:\sistemas\pablo\tabela.dbf"
//  cDestino := "c:\sistemas\leve\cepearq.dbf" 
    
  setcolor( CorJanel )
  @ 07,15 get cOrigem     pict '@S40'  valid file( alltrim( cOrigem ) )
  @ 08,15 get cDestino    pict '@S40'  valid file( alltrim( cDestino ) ) .and. cDestino != cOrigem
  read
  
  if lastkey() == K_ESC
    restscreen( 00, 00, 23, 79, tImpo )
    return NIL
  endif
  
  if NetUse( alltrim( cOrigem ), .f. )
 
  endif
  
  aOrigem  := dbstruct ()
  cOrigCab := alias ()
  cOrigARQ := CriaTemp(0)
  cOrigIND := CriaTemp(1)
  cChave   := "Field_Rec"

  aCampos  := {}

  aadd( aCampos, { 'FIELD_NAME','C',40, 0 } )
  aadd( aCampos, { 'FIELD_TYPE','C', 1, 0 } )
  aadd( aCampos, { 'FIELD_Dec', 'N', 3, 0 } )
  aadd( aCampos, { 'FIELD_Len', 'N', 3, 0 } )
  aadd( aCampos, { 'FIELD_KEY', 'C', 1, 0 } )
  aadd( aCampos, { 'FIELD_REC', 'C', 3, 0 } )
      
  dbcreate( cOrigARQ, aCampos )

  if NetUse( cOrigARQ, .f. )
    cOrigTMP := alias ()
    
    for nK := 1 to len( aOrigem )
      if AdiReg()
        if RegLock()
          replace FIELD_NAME  with aOrigem[ nK, 1 ]
          replace FIELD_TYPE  with aOrigem[ nK, 2 ]
          replace FIELD_DEC   with aOrigem[ nK, 3 ]
          replace FIELD_LEN   with aOrigem[ nK, 4 ]
          replace FIELD_REC   with strzero( recno(), 3 )
          dbunlock()
        endif
      endif
    next
  
    #ifdef DBF_CDX  
      index on &cChave tag &cOrigIND
    #endif

    #ifdef DBF_NTX
      index on &cChave to &cOrigIND

      set index to &cOrigIND
    #endif
  endif  
 
  if NetUse( alltrim( cDestino ), .f. )

  endif
  
  aDestino := dbstruct ()
  cDestCab := alias ()
  cDestARQ := CriaTemp(0)
  cDestIND := CriaTemp(1)
  cChave   := "Field_Rec"

  aCampos  := {}

  aadd( aCampos, { 'FIELD_NAME','C',40, 0 } )
  aadd( aCampos, { 'FIELD_TYPE','C', 1, 0 } )
  aadd( aCampos, { 'FIELD_Dec', 'N', 3, 0 } )
  aadd( aCampos, { 'FIELD_Len', 'N', 3, 0 } )
  aadd( aCampos, { 'FIELD_KEY', 'C', 1, 0 } )
  aadd( aCampos, { 'FIELD_REC', 'C', 3, 0 } )
  aadd( aCampos, { 'EXPRESSAO', 'C', 40, 0 } )
      
  dbcreate( cDestARQ, aCampos )

  if NetUse( cDestARQ, .f. )
    cDestTMP := alias ()
    
    for nK := 1 to len( aDestino )
      if AdiReg()
        if RegLock()
          replace FIELD_NAME  with aDestino[ nK, 1 ]
          replace FIELD_TYPE  with aDestino[ nK, 2 ]
          replace FIELD_DEC   with aDestino[ nK, 3 ]
          replace FIELD_LEN   with aDestino[ nK, 4 ]
          replace FIELD_REC   with strzero( recno(), 3 )
          dbunlock()
        endif
      endif
    next
  
    #ifdef DBF_CDX  
      index on &cChave tag &cDestIND
    #endif

    #ifdef DBF_NTX
      index on &cChave to &cDestIND

      set index to &cDestIND
    #endif
  endif  
 
  select( cOrigTMP )
  set order to 1
  dbgotop()

  Janela( 02, 05, 20, 75, mensagem('Janela', 'ImpoArqu', .f. ), .t. ) 
  setcolor ( CorJanel + ',' + CorCampo )

  oOrigem           := TBrowseDb( 04, 06, 18, 33 )
  oOrigem:headsep   := chr(194)+chr(196)
  oOrigem:footsep   := chr(193)+chr(196)
  oOrigem:colsep    := chr(179)
  oOrigem:colorSpec := CorJanel + ',' + CorCampo

  oOrigem:addColumn( TBColumnNew(" ",     {|| Field_KEY } ) )
  oOrigem:addColumn( TBColumnNew(cOrigCab,{|| left( Field_Name, 15 ) } ) )
  oOrigem:addColumn( TBColumnNew(" ",     {|| Field_Type } ) )
  oOrigem:addColumn( TBColumnNew("   ",   {|| Field_Dec } ) )
  oOrigem:addColumn( TBColumnNew("   ",   {|| Field_Len } ) )

  lExitRequested := .f.

  @ 04,38 say cDestCab    
  @ 05,05 say chr(195)
  @ 05,34 say chr(191) 
  @ 05,75 say chr(180) 

  @ 05,35 say chr(218) + replicate(chr(196),39) 

  @ 05,37 say chr(194)
  @ 05,51 say chr(194)
  @ 05,53 say chr(194)
  @ 05,58 say chr(194)
  @ 05,64 say chr(194)
  
  for nh := 6 to 17
    @ nh,34 say chr(179)
    @ nh,35 say chr(179)
    @ nh,37 say chr(179)
    @ nh,51 say chr(179)
    @ nh,53 say chr(179)
    @ nh,58 say chr(179)
    @ nh,64 say chr(179)
  next
  
  @ 18,34 say chr(193)
  @ 18,35 say chr(193)
  @ 18,37 say chr(193)
  @ 18,51 say chr(193)
  @ 18,53 say chr(193)
  @ 18,58 say chr(193)
  @ 18,64 say chr(193)

  do while !lExitRequested
    Mensagem( 'Impo', 'ImpoArqu' )

    oOrigem:forcestable()

    if oOrigem:stable

      cTecla := Teclar(0)
    endif
 
    do case
      case cTecla == K_DOWN;        oOrigem:down()
      case cTecla == K_UP;          oOrigem:up()
      case cTecla == K_PGDN;        oOrigem:pageDown()
      case cTecla == K_PGUP;        oOrigem:pageUp()
      case cTecla == K_CTRL_PGUP;   oOrigem:goTop()
      case cTecla == K_CTRL_PGDN;   oOrigem:goBottom()
      case cTecla == K_ESC;         lExitRequested := .T.
      case cTecla == 42
        if RegLock()
          if empty( FIELD_KEY )
            replace FIELD_KEY       with "*" 
          else
            replace FIELD_KEY       with " " 
          endif
          dbunlock()
        endif
        
        oOrigem:refreshall()
      case cTecla == K_DEL
        if RegLock(30)
          dbdelete()
          dbunlock()
        endif  
       
        oOrigem:refreshall()
      case cTecla == K_CTRL_UP  
        cSequ := FIELD_REC
        nRecn := recno()
      
        dbskip(-1)
        if bof()

        else
          nNovo := val( FIELD_REC ) 
          
          if RegLock()
            replace FIELD_REC  with cSequ
            dbunlock()
          endif
          
          go nRecn
          
          if RegLock()
            replace FIELD_REC  with strzero( nNovo, 3 )
            dbunlock()
          endif
        endif
        
        oOrigem:refreshall()        
      case cTecla == K_CTRL_DOWN
        cSequ := FIELD_REC
        nRecn := recno()
      
        dbskip()
        if eof()

        else
          nNovo := val( FIELD_REC ) 
          
          if RegLock()
            replace FIELD_REC  with cSequ
            dbunlock()
          endif
          
          go nRecn
          
          if RegLock()
            replace FIELD_REC  with strzero( nNovo, 3 )
            dbunlock()
          endif
        endif
        
        oOrigem:refreshall()        
      case cTecla == K_TAB
        select( cDestTMP )
        set order to 1
        dbgotop()
      
        oDestino           := TBrowseDb( 04, 36, 18, 74 )
        oDestino:headsep   := chr(194)+chr(196)
        oDestino:footsep   := chr(193)+chr(196)
        oDestino:colsep    := chr(179)
        oDestino:colorSpec := CorJanel + ',' + CorCampo

        oDestino:addColumn( TBColumnNew(" ", {|| Field_KEY } ) )
        oDestino:addColumn( TBColumnNew(cDestCab,{|| left( Field_Name, 14 ) } ) )
        oDestino:addColumn( TBColumnNew(" ", {|| Field_Type } ) )
        oDestino:addColumn( TBColumnNew("   ", {|| Field_Dec } ) )
        oDestino:addColumn( TBColumnNew("   ", {|| Field_Len } ) )
        oDestino:addColumn( TBColumnNew("Expressao", {|| left( Expressao, 12 ) } ) )

        dExitRequested := .f.
    
        do while !dExitRequested
          Mensagem( 'Impo', 'ImpoArqu' )

          oDestino:forcestable()

         if oDestino:stable

           cTecla := Teclar(0)
         endif
 
         do case
           case cTecla == K_DOWN;        oDestino:down()
           case cTecla == K_UP;          oDestino:up()
           case cTecla == K_PGDN;        oDestino:pageDown()
           case cTecla == K_PGUP;        oDestino:pageUp()
           case cTecla == K_CTRL_PGUP;   oDestino:goTop()
           case cTecla == K_CTRL_PGDN;   oDestino:goBottom()
           case cTecla == K_ESC;         dExitRequested := .T.
           case cTecla == K_TAB;         dExitRequested := .T.
           case cTecla == 42
             if RegLock()
               if empty( FIELD_KEY )
                 replace FIELD_KEY       with "*" 
               else
                 replace FIELD_KEY       with " " 
               endif
               dbunlock()
             endif
         
             oDestino:refreshall()
           case cTecla == K_DEL
             if RegLock(30)
               dbdelete()
               dbunlock()
             endif  
       
             oDestino:refreshall()
           case cTecla == K_CTRL_UP  
             cSequ := FIELD_REC
             nRecn := recno()
      
             dbskip(-1)
             if bof()

             else
               nNovo := val( FIELD_REC ) 
           
               if RegLock()
                 replace FIELD_REC  with cSequ
                 dbunlock()
               endif
         
               go nRecn
          
               if RegLock()
                 replace FIELD_REC  with strzero( nNovo, 3 )
                 dbunlock()
               endif
             endif
        
             oDestino:refreshall()        
           case cTecla == K_CTRL_DOWN
             cSequ := FIELD_REC
             nRecn := recno()
      
             dbskip()
             if eof()

             else
               nNovo := val( FIELD_REC ) 
          
               if RegLock()
                 replace FIELD_REC  with cSequ
                 dbunlock()
               endif
          
               go nRecn
          
               if RegLock()
                 replace FIELD_REC  with strzero( nNovo, 3 )
                 dbunlock()
               endif
             endif
        
             oDestino:refreshall()        
          endcase
        enddo
        select( cOrigTMP )        
    endcase
  enddo
  
  select( cDestTMP )
  close  
  select( cOrigTMP )
  close  

  restscreen( 00, 00, 23, 79, tImpo )
return NIL

//
// Exporta Produtos
//
function ExpoProd ()
  tExpoProd := savescreen( 00, 00, 23, 79 )
   
  Janela( 06, 05, 17, 69, mensagem( 'Impo', 'ExpoProd', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )
  
  @ 08,07 say '        Destino'
  @ 10,07 say 'Produto Inicial                   Produto Final' 
  @ 12,07 say '      Confirmar  Sim   Não'
  @ 13,05 say chr(195) + replicate( chr(196), 63 ) + chr(180)

  @ 15,12 say 'Codigo'
  @ 16,12 say '  Nome'

  setcolor( CorCampo )
  @ 12,23 say ' Sim '
  @ 12,29 say ' Não '

  setcolor( 'gr+/w' )
  @ 12,24 say 'S'
  @ 12,30 say 'N'
  
  setcolor( CorCampo )
  @ 15,19 say '   0'
  @ 16,19 say space(40)
  
  nConf    := 2
  cDrive   := cCaminho + HB_OSpathseparator() + space(20) 
  nProdIni := 1
  nProdFin := 9999
    
  setcolor( CorJanel )
  @ 08,23 get cDrive     pict '@S30'  
  @ 10,23 get nProdIni   pict '9999'
  @ 10,55 get nProdFin   pict '9999'  valid nProdFin >= nProdIni
  read
  
  if lastkey() == K_ESC
    restscreen( 00, 00, 23, 79, tExpoProd )
    return NIL
  endif
  
  nConf := iif( ConfLine( 12, 23, 2 ), 1, 2 )

  if lastkey() == K_ESC .or. nConf == 2
    restscreen( 00, 00, 23, 79, tExpoProd )
    return NIL
  endif
  
  cProdIni := strzero( nProdIni, 4 )
  cProdFin := strzero( nProdFin, 4 )
  cEmprAnt := cEmpresa
    
  cProdARQ := CriaTemp(0)
  aCampos  := CriaARQ( "ProdARQ", .f. )
      
  dbcreate( cProdARQ , aCampos )

  if NetUse( cProdARQ, .f., 30 )
    cProdARQ := alias ()
  endif  
  
  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )

    lOpenProd := .t.
  
    #ifdef DBF_NTX
      set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
    #endif  
  else  
    lOpenProd := .f.
  endif
  
  setcolor( CorCampo )
  
  select ProdARQ
  set order  to 1
  dbseek( cProdIni, .t. )
  do while Prod >= cProdIni .and. Prod <= cProdFin .and. !eof()
    @ 15,19 say Prod             pict '9999' 
    @ 16,19 say Nome             pict '@S40'
    
    lAchou := .f.
    
    select( cProdARQ )
    if AdiReg()
      replace Prod       with ProdARQ->Prod 
      replace UltA       with date()
      replace CodFab     with ProdARQ->CodFab
      replace Refe       with ProdARQ->Refe
      replace Nome       with ProdARQ->Nome
      replace Forn       with ProdARQ->Forn
      replace Grup       with ProdARQ->Grup
      replace SubG       with ProdARQ->Subg
      replace Unid       with ProdARQ->Unid
      replace PerC       with ProdARQ->PerC
      replace PerIPI     with ProdARQ->PerIPI
      replace Codisc    with ProdARQ->Codisc
      replace Codri     with ProdARQ->Codri
      replace CodPI     with ProdARQ->CodPI
      replace PesoLiqd   with ProdARQ->PesoLiqd
      replace PrecoCusto with ProdARQ->PrecoCusto
      replace Lucro      with ProdARQ->Lucro
      replace PrecoVenda with ProdARQ->PrecoVenda
      replace Qtde       with ProdARQ->Qtde
      replace Caixa      with ProdARQ->Caixa
      replace EstqMini   with ProdARQ->EstqMini
      replace UltE       with ProdARQ->UltE
      replace UltS       with ProdARQ->UltS
      replace Hist       with ProdARQ->Hist
      dbunlock ()
    endif 
    
    select ProdARQ
    dbskip ()
  enddo  
  
  if lOpenProd 
    select ProdARQ
    close
  endif    
 
  select( cProdARQ )
  close
  
  #ifdef DBF_NTX
    copy file ( alltrim( cCaminho ) + HB_OSpathseparator() + 'TEMP' + HB_OSpathseparator() + cProdARQ + '.' + cUsuario ) to ( alltrim( cDrive ) + "PRODARQ.DBF" )
    copy file ( alltrim( cCaminho ) + HB_OSpathseparator() + 'TEMP' + HB_OSpathseparator() + cProdARQ + '.DBT' )         to ( alltrim( cDrive ) + "PRODARQ.DBT" )
    
    ferase( alltrim( cCaminho ) + HB_OSpathseparator() + 'TEMP' + HB_OSpathseparator() + cProdARQ + '.' + cUsuario )
    ferase( alltrim( cCaminho ) + HB_OSpathseparator() + 'TEMP' + HB_OSpathseparator() + cProdARQ + '.DBT' )
  #endif
  
  #ifdef DBF_CDX
    copy file ( alltrim( cCaminho ) + HB_OSpathseparator() + 'TEMP' + HB_OSpathseparator() + cProdARQ + '.' + cUsuario ) to ( alltrim( cDrive ) + "PRODARQ.DBF" )
    copy file ( alltrim( cCaminho ) + HB_OSpathseparator() + 'TEMP' + HB_OSpathseparator() + cProdARQ + '.DBT' )         to ( alltrim( cDrive ) + "PRODARQ.DBT" )
    
    ferase( alltrim( cCaminho ) + HB_OSpathseparator() + 'TEMP' + HB_OSpathseparator() + cProdARQ + '.' + cUsuario )
    ferase( alltrim( cCaminho ) + HB_OSpathseparator() + 'TEMP' + HB_OSpathseparator() + cProdARQ + '.FPT' )
  #endif
  
  restscreen( 00, 00, 23, 79, tExpoProd )
return NIL

  
//
// Importa Grupos
//
function ImpoGrup ()
  tImpoGrup := savescreen( 00, 00, 23, 79 )
   
  Janela( 05, 05, 17, 69, 'Importar Grupos...', .f. )
  setcolor( CorJanel + ',' + CorCampo )
  
  @ 07,07 say ' Empresa Destino'
  @ 08,07 say 'Empresa Destino'
  @ 10,07 say '  Grupo Inicial                     Grupo Final' 
  @ 12,07 say '      Confirmar  Sim   Não'
  @ 13,05 say chr(195) + replicate( chr(196), 63 ) + chr(180)

  @ 15,12 say 'Código'
  @ 16,12 say '  Nome'

  setcolor( CorCampo )
  @ 12,23 say ' Sim '
  @ 12,29 say ' Não '

  setcolor( 'gr+/w' )
  @ 12,24 say 'S'
  @ 12,30 say 'N'
  
  setcolor( CorCampo )
  @ 15,19 say '  0'
  @ 16,19 say space(40)
  
  select EmprARQ
  dbgotop ()
  cEmprIni := Empr
  nEmprIni := val( Empr )

  @ 07,28 say Razao      pict '@S40' 
  dbgobottom ()
  cEmprFin := Empr
  nEmprFin := val( Empr )

  @ 08,28 say Razao      pict '@S40' 
  nConf    := 2
  nGrupIni := 1
  nGrupFin := 999
    
  setcolor( CorJanel )
  @ 07,23 get nEmprIni   pict '9999'  valid ValidARQ( 07, 23, "EmprARQ", "Codigo", "Empr", "Descrição", "Razao", "Empr", "nEmprIni", .t., 4, "Empresas", "EmprARQ", 40 )
  @ 08,23 get nEmprFin   pict '9999'  valid ValidARQ( 08, 23, "EmprARQ", "Codigo", "Empr", "Descrição", "Razao", "Empr", "nEmprFin", .t., 4, "Empresas", "EmprARQ", 40 )
  @ 10,23 get nGrupIni   pict '999'
  @ 10,55 get nGrupFin   pict '999'   valid nGrupFin >= nGrupIni
  read
  
  if lastkey() == K_ESC
    restscreen( 00, 00, 23, 79, tImpoGrup )
    return NIL
  endif
  
  nConf := iif( ConfLine( 12, 23, 2 ), 1, 2 )

  if lastkey() == K_ESC .or. nConf == 2
    restscreen( 00, 00, 23, 79, tImpoGrup )
    return NIL
  endif

  cEmprIni := strzero( nEmprIni, 4 )
  cEmprFin := strzero( nEmprFin, 4 )
  cGrupIni := strzero( nGrupIni, 3 )
  cGrupFin := strzero( nGrupFin, 3 )
  cEmprAnt := cEmpresa
    
  select EmprARQ
  set order to 1  
  dbseek( cEmprIni, .f. ) 
  
  cEmpresa := Empr
  EmprNome := Razao
  cPath    := cCaminho + ';' + ( cCaminho + '\' + Direto )
  cPathAnt := alltrim( cCaminho ) + '\' + alltrim( Direto )
  cGrupARQ := CriaTemp(0)
  aCampos  := CriaARQ( "GrupARQ", .f. )
      
  set path to ( cPath )
  
  Acesso ()
       
  dbcreate( cGrupARQ, aCampos )

  if NetUse( cGrupARQ, .f., 30 )
    cGrupARQ := alias ()
  endif  
  
  if NetUse( "GrupARQ", .t. )
    VerifIND( "GrupARQ" )

    lOpenGrup := .t.
  
    #ifdef DBF_NTX
      set index to GrupIND1, GrupIND2
    #endif  
  else  
    lOpenGrup := .f.
  endif
  
  setcolor( CorCampo )
  
  select GrupARQ
  set order to 1
  dbseek( cGrupIni, .t. )
  do while Grup >= cGrupIni .and. Grup <= cGrupFin .and. !eof()
    @ 15,19 say Grup             pict '999' 
    @ 16,19 say Nome             pict '@S40'
    
    select( cGrupARQ )
    dbgobottom ()
    if AdiReg()
      if RegLock()
        replace Grup     with GrupARQ->Grup
        replace Nome     with GrupARQ->Nome
        dbunlock ()
      endif
    endif  
    
    select GrupARQ
    dbskip ()
  enddo  
  
  if lOpenGrup 
    select GrupARQ
    close
  endif    
 
  select EmprARQ
  set order to 1
  dbseek( cEmprFin, .f. ) 

  cEmpresa := Empr
  EmprNome := Razao
  cPathNew := ( alltrim( cCaminho ) + '\' + alltrim( Direto ) )
  cPath    := cCaminho + ';' + ( cCaminho + '\' + Direto )
  
  set path to ( cPath )
  
  Acesso ()
  
  if NetUse( "GrupARQ", .t. )
    VerifIND( "GrupARQ" )

    lOpenGrup := .t.
  
    #ifdef DBF_NTX
      set index to GrupIND1, GrupIND2
    #endif  
  else  
    lOpenGrup := .f.
  endif
  
  select( cGrupARQ )
  dbgotop ()
  do while !eof()
    cGrup := Grup
    cNome := Nome
    
    @ 15,19 say cGrup             pict '99' 
    @ 16,19 say cNome             pict '@S40'
    
    select GrupARQ
    set order to 1
    dbseek( cGrup, .f. )
    
    if eof ()
      if AdiReg()
      endif
    endif   
    
    if RegLock()
      replace Grup     with &cGrupARQ->Grup
      replace Nome     with &cGrupARQ->Nome
      dbunlock ()
    endif  

    select( cGrupARQ )
    dbskip ()
  enddo  
  
  if lOpenGrup
    select GrupARQ
    close
  endif
  
  select( cGrupARQ )
  close
    
  ferase( alltrim( cCaminho ) + '\TEMP\' + cGrupARQ + '.' + cUsuario )
    
  restscreen( 00, 00, 23, 79, tImpoGrup )
  
  select EmprARQ
  set order to 1  
  dbseek( cEmprAnt, .f. ) 
  
  cEmpresa := Empr
  EmprNome := Razao
  cPath    := cCaminho + ';' + ( cCaminho + '\' + Direto )
      
  set path to ( cPath )
  
  Acesso ()
       
return NIL

//
// Importa SubGrupos
//
function ImpoSubG ()
  tImpoSubG := savescreen( 00, 00, 23, 79 )
   
  Janela( 05, 05, 17, 69, 'Importar SubGrupos...', .f. )
  setcolor( CorJanel + ',' + CorCampo )
  
  @ 07,07 say ' Empresa Destino'
  @ 08,07 say 'Empresa Destino'
  @ 10,07 say '  Grupo Inicial                     Grupo Final' 
  @ 12,07 say '      Confirmar  Sim   Não'
  @ 13,05 say chr(195) + replicate( chr(196), 63 ) + chr(180)

  @ 15,12 say 'Código'
  @ 16,12 say '  Nome'

  setcolor( CorCampo )
  @ 12,23 say ' Sim '
  @ 12,29 say ' Não '

  setcolor( 'gr+/w' )
  @ 12,24 say 'S'
  @ 12,30 say 'N'
  
  setcolor( CorCampo )
  @ 15,19 say '  0'
  @ 16,19 say space(40)
  
  select EmprARQ
  dbgotop ()
  cEmprIni := Empr
  nEmprIni := val( Empr )

  @ 07,28 say Razao      pict '@S40' 
  dbgobottom ()
  cEmprFin := Empr
  nEmprFin := val( Empr )

  @ 08,28 say Razao      pict '@S40' 
  nConf    := 2
  nGrupIni := 1
  nGrupFin := 999
    
  setcolor( CorJanel )
  @ 07,23 get nEmprIni   pict '9999'  valid ValidARQ( 07, 23, "EmprARQ", "Codigo", "Empr", "Descrição", "Razao", "Empr", "nEmprIni", .t., 4, "Empresas", "EmprARQ", 40 )
  @ 08,23 get nEmprFin   pict '9999'  valid ValidARQ( 08, 23, "EmprARQ", "Codigo", "Empr", "Descrição", "Razao", "Empr", "nEmprFin", .t., 4, "Empresas", "EmprARQ", 40 )
  @ 10,23 get nGrupIni   pict '999'
  @ 10,55 get nGrupFin   pict '999'   valid nGrupFin >= nGrupIni
  read
  
  if lastkey() == K_ESC
    restscreen( 00, 00, 23, 79, tImpoSubG )
    return NIL
  endif
  
  nConf := iif( ConfLine( 12, 23, 2 ), 1, 2 )

  if lastkey() == K_ESC .or. nConf == 2
    restscreen( 00, 00, 23, 79, tImpoSubG )
    return NIL
  endif

  cEmprIni := strzero( nEmprIni, 4 )
  cEmprFin := strzero( nEmprFin, 4 )
  cGrupIni := strzero( nGrupIni, 3 )
  cGrupFin := strzero( nGrupFin, 3 )
  cEmprAnt := cEmpresa
    
  select EmprARQ
  set order to 1  
  dbseek( cEmprIni, .f. ) 
  
  cEmpresa := Empr
  EmprNome := Razao
  cPath    := cCaminho + ';' + ( cCaminho + '\' + Direto )
  cPathAnt := alltrim( cCaminho ) + '\' + alltrim( Direto )
  cSubGARQ := CriaTemp(0)
  aCampos  := CriaARQ( "SubGARQ", .f. )
      
  set path to ( cPath )
  
  Acesso ()
       
  dbcreate( cSubGARQ , aCampos )

  if NetUse( cSubGARQ, .f., 30 )
    cSubGARQ := alias ()
  endif  
  
  if NetUse( "SubGARQ", .t. )
    VerifIND( "SubGARQ" )

    lOpenSubG := .t.
  
    #ifdef DBF_NTX
      set index to SubGIND1, SubGIND2, SubGIND3
    #endif  
  else  
    lOpenSubG := .f.
  endif
  
  setcolor( CorCampo )
  
  select SubGARQ
  set order to 1
  dbseek( cGrupIni, .t. )
  do while Grup >= cGrupIni .and. Grup <= cGrupFin .and. !eof()
    @ 15,19 say SubG             pict '999' 
    @ 16,19 say Nome             pict '@S40'
    
    select( cSubGARQ )
    dbgobottom ()
    if AdiReg()
      if RegLock()
        replace Grup     with SubGARQ->Grup
        replace SubG     with SubGARQ->SubG
        replace Nome     with SubGARQ->Nome
        dbunlock ()
      endif
    endif  
    
    select SubGARQ
    dbskip ()
  enddo  
  
  if lOpenSubG 
    select SubGARQ
    close
  endif    
 
  select EmprARQ
  set order to 1
  dbseek( cEmprFin, .f. ) 

  cEmpresa := Empr
  EmprNome := Razao
  cPathNew := ( alltrim( cCaminho ) + '\' + alltrim( Direto ) )
  cPath    := cCaminho + ';' + ( cCaminho + '\' + Direto )
  
  set path to ( cPath )
  
  Acesso ()
  
  if NetUse( "SubGARQ", .t. )
    VerifIND( "SubGARQ" )

    lOpenSubG := .t.
  
    #ifdef DBF_NTX
      set index to SubGIND1, SubGIND2, SubGIND3
    #endif  
  else  
    lOpenSubG := .f.
  endif
  
  select( cSubGARQ )
  dbgotop ()
  do while !eof()
    cSubG := SubG
    cGrup := Grup
    cNome := Nome
    
    @ 15,19 say cSubG             pict '999' 
    @ 16,19 say cNome             pict '@S40'
    
    select SubGARQ
    set order to 1
    dbseek( cGrup + cSubG, .f. )
    
    if eof ()
      if AdiReg()
      endif
    endif   
    
    if RegLock()
      replace Grup     with &cSubGARQ->Grup
      replace SubG     with &cSubGARQ->SubG
      replace Nome     with &cSubGARQ->Nome
      dbunlock ()
    endif  

    select( cSubGARQ )
    dbskip ()
  enddo  
  
  if lOpenSubG
    select SubGARQ
    close
  endif
  
  select( cSubGARQ )
  close
    
  ferase( alltrim( cCaminho ) + '\TEMP\' + cSubGARQ + '.' + cUsuario )
    
  restscreen( 00, 00, 23, 79, tImpoSubG )
  
  select EmprARQ
  set order to 1  
  dbseek( cEmprAnt, .f. ) 
  
  cEmpresa := Empr
  EmprNome := Razao
  cPath    := cCaminho + ';' + ( cCaminho + '\' + Direto )
      
  set path to ( cPath )
  
  Acesso ()
       
return NIL

//
// Importa Fornecedores
//
function ImpoForn ()
  tImpoForn := savescreen( 00, 00, 23, 79 )
   
  Janela( 05, 05, 17, 69, 'Importar Fornecedores...', .f. )
  setcolor( CorJanel + ',' + CorCampo )
  
  @ 07,07 say ' Empresa Destino'
  @ 08,07 say 'Empresa Destino'
  @ 10,07 say 'Fornec. Inicial                   Fornec. Final' 
  @ 12,07 say '      Confirmar  Sim   Não'
  @ 13,05 say chr(195) + replicate( chr(196), 63 ) + chr(180)

  @ 15,12 say 'Código'
  @ 16,12 say '  Nome'

  setcolor( CorCampo )
  @ 12,23 say ' Sim '
  @ 12,29 say ' Não '

  setcolor( 'gr+/w' )
  @ 12,24 say 'S'
  @ 12,30 say 'N'
  
  setcolor( CorCampo )
  @ 15,19 say '   0'
  @ 16,19 say space(40)
  
  select EmprARQ
  dbgotop ()
  cEmprIni := Empr
  nEmprIni := val( Empr )

  @ 07,28 say Razao      pict '@S40' 
  dbgobottom ()
  cEmprFin := Empr
  nEmprFin := val( Empr )

  @ 08,28 say Razao      pict '@S40' 
  nConf    := 2
  nFornIni := 1
  nFornFin := 9999
    
  setcolor( CorJanel )
  @ 07,23 get nEmprIni   pict '9999'  valid ValidARQ( 07, 23, "EmprARQ", "Codigo", "Empr", "Descrição", "Razao", "Empr", "nEmprIni", .t., 4, "Empresas", "EmprARQ", 40 )
  @ 08,23 get nEmprFin   pict '9999'  valid ValidARQ( 08, 23, "EmprARQ", "Codigo", "Empr", "Descrição", "Razao", "Empr", "nEmprFin", .t., 4, "Empresas", "EmprARQ", 40 )
  @ 10,23 get nFornIni   pict '9999'
  @ 10,55 get nFornFin   pict '9999'  valid nFornFin >= nFornIni
  read
  
  if lastkey() == K_ESC
    restscreen( 00, 00, 23, 79, tImpoForn )
    return NIL
  endif
  
  nConf := iif( ConfLine( 12, 23, 2 ), 1, 2 )

  if lastkey() == K_ESC .or. nConf == 2
    restscreen( 00, 00, 23, 79, tImpoForn )
    return NIL
  endif

  cEmprIni := strzero( nEmprIni, 4 )
  cEmprFin := strzero( nEmprFin, 4 )
  cFornIni := strzero( nFornIni, 4 )
  cFornFin := strzero( nFornFin, 4 )
  cEmprAnt := cEmpresa
    
  select EmprARQ
  set order to 1  
  dbseek( cEmprIni, .f. ) 
  
  cEmpresa := Empr
  EmprNome := Razao
  cPath    := cCaminho + ';' + ( cCaminho + '\' + Direto )
  cPathAnt := alltrim( cCaminho ) + '\' + alltrim( Direto )
  cFornARQ := CriaTemp(0)
  aCampos  := CriaARQ( "FornARQ", .f. )
      
  set path to ( cPath )
  
  Acesso ()
       
  dbcreate( cFornARQ , aCampos )

  if NetUse( cFornARQ, .f., 30 )
    cFornARQ := alias ()
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
  
  setcolor( CorCampo )
  
  select FornARQ
  set order to 1
  dbseek( cFornIni, .t. )
  do while Forn >= cFornIni .and. Forn <= cFornFin .and. !eof()
    @ 15,19 say Forn             pict '9999' 
    @ 16,19 say Razao            pict '@S40'
    
    select( cFornARQ )
    dbgobottom ()
    if AdiReg()
      if RegLock()
        replace Forn       with FornARQ->Forn
        replace Razao      with FornARQ->Razao
        replace Nome       with FornARQ->Nome
        replace Ende       with FornARQ->Ende
        replace Cida       with FornARQ->Cida
        replace CEP        with FornARQ->CEP
        replace UF         with FornARQ->UF
        replace Bairro     with FornARQ->Bairro
        replace CGC        with FornARQ->CGC
        replace InscEstd   with FornARQ->InscEstd
        replace Fone       with FornARQ->Fone
        replace FoneR      with FornARQ->FoneR
        replace Ramal      with FornARQ->Ramal      
        replace Contato    with FornARQ->Contato   
        replace Fax        with FornARQ->Fax
        replace FaxR       with FornARQ->FaxR
        replace Repres     with FornARQ->Repres
        replace Celu       with FornARQ->Celu
        dbunlock ()
      endif
    endif  
    
    select FornARQ
    dbskip ()
  enddo  
  
  if lOpenForn 
    select FornARQ
    close
  endif    
 
  select EmprARQ
  set order to 1
  dbseek( cEmprFin, .f. ) 

  cEmpresa := Empr
  EmprNome := Razao
  cPathNew := ( alltrim( cCaminho ) + '\' + alltrim( Direto ) )
  cPath    := cCaminho + ';' + ( cCaminho + '\' + Direto )
  
  set path to ( cPath )
  
  Acesso ()
  
  if NetUse( "FornARQ", .t. )
    VerifIND( "FornARQ" )

    lOpenForn := .t.
  
    #ifdef DBF_NTX
      set index to FornIND1, FornIND2
    #endif  
  else  
    lOpenForn := .f.
  endif
  
  select( cFornARQ )
  dbgotop ()
  do while !eof()
    cForn  := Forn
    cRazao := Razao
    
    @ 15,19 say cForn             pict '9999' 
    @ 16,19 say cRazao            pict '@S40'
    
    select FornARQ
    set order to 1
    dbseek( cForn, .f. )
    
    if eof ()
      if AdiReg()
      endif
    endif   
    
    if RegLock()
      replace Forn       with &cFornARQ->Forn
      replace Razao      with &cFornARQ->Razao
      replace Nome       with &cFornARQ->Nome
      replace Ende       with &cFornARQ->Ende
      replace Cida       with &cFornARQ->Cida
      replace CEP        with &cFornARQ->CEP
      replace UF         with &cFornARQ->UF
      replace Bairro     with &cFornARQ->Bairro
      replace CGC        with &cFornARQ->CGC
      replace InscEstd   with &cFornARQ->InscEstd
      replace Fone       with &cFornARQ->Fone
      replace FoneR      with &cFornARQ->FoneR
      replace Ramal      with &cFornARQ->Ramal   
      replace Contato    with &cFornARQ->Contato 
      replace Fax        with &cFornARQ->Fax
      replace FaxR       with &cFornARQ->FaxR
      replace Repres     with &cFornARQ->Repres
      replace Celu       with &cFornARQ->Celu     
      dbunlock ()
    endif  

    select( cFornARQ )
    dbskip ()
  enddo  
  
  if lOpenForn
    select FornARQ
    close
  endif
  
  select( cFornARQ )
  close
    
  ferase( alltrim( cCaminho ) + '\TEMP\' + cFornARQ + '.' + cUsuario )
    
  restscreen( 00, 00, 23, 79, tImpoForn )
  
  select EmprARQ
  set order to 1  
  dbseek( cEmprAnt, .f. ) 
  
  cEmpresa := Empr
  EmprNome := Razao
  cPath    := cCaminho + ';' + ( cCaminho + '\' + Direto )
      
  set path to ( cPath )
  
  Acesso ()
      
return NIL

//
// Importa Contas a Receber
//
function ImpoRece ()
  tImpoRece := savescreen( 00, 00, 23, 79 )
   
  Janela( 04, 05, 17, 69, 'Importar Contas a Receber...', .f. )
  setcolor( CorJanel + ',' + CorCampo )
  
  @ 06,07 say ' Empresa Destino'
  @ 07,07 say 'Empresa Destino'
  @ 09,07 say '   Nota Inicial                      Nota Final' 
  @ 10,07 say '           Tipo'
  @ 12,07 say '      Confirmar  Sim   Não'
  @ 13,05 say chr(195) + replicate( chr(196), 63 ) + chr(180)

  @ 15,12 say '  Nota'
  @ 16,12 say 'Clien.'

  setcolor ( 'w+/n' )
  @ 10,32 say chr(215) + chr(222)

  setcolor( CorCampo )
  @ 10,23 say ' Ambos '
  @ 12,23 say ' Sim '
  @ 12,29 say ' Não '

  setcolor( 'gr+/w' )
  @ 10,24 say 'A'
  @ 12,24 say 'S'
  @ 12,30 say 'N'
  
  setcolor( CorCampo )
  @ 15,19 say '     0-0'
  @ 16,19 say '    '
  
  select EmprARQ
  dbgotop ()
  cEmprIni := Empr
  nEmprIni := val( Empr )

  @ 06,28 say Razao      pict '@S40' 
  dbgobottom ()
  cEmprFin := Empr
  nEmprFin := val( Empr )

  @ 07,28 say Razao      pict '@S40' 
  nConf    := 2
  nNotaIni := 1
  nNotaFin := 9999999
  aOpc     := {}

  aadd( aOpc, { ' Nota   ', 2, 'N', 10, 23, "Importar Contas a Receber gerada por uma Nota Fiscal." } )
  aadd( aOpc, { ' Pedido ', 2, 'P', 10, 23, "Importar Contas a Receber gerada por um Pedido." } )
  aadd( aOpc, { ' O.S.   ', 2, 'O', 10, 23, "Importar Contas a Receber gerada por Ordem de Serviço." } )
  aadd( aOpc, { ' Ambos  ', 2, 'A', 10, 23, "Importar Todas as Contas a Receber." } )
    
  setcolor( CorJanel )
  @ 06,23 get nEmprIni   pict '9999'      valid ValidARQ( 06, 23, "EmprARQ", "Codigo", "Empr", "Descrição", "Razao", "Empr", "nEmprIni", .t., 4, "Empresas", "EmprARQ", 40 )
  @ 07,23 get nEmprFin   pict '9999'      valid ValidARQ( 07, 23, "EmprARQ", "Codigo", "Empr", "Descrição", "Razao", "Empr", "nEmprFin", .t., 4, "Empresas", "EmprARQ", 40 )
  @ 09,23 get nNotaIni   pict '999999-9'
  @ 09,55 get nNotaFin   pict '999999-9'  valid nNotaFin >= nNotaIni
  read
  
  if lastkey() == K_ESC
    restscreen( 00, 00, 23, 79, tImpoRece )
    return NIL
  endif
  
  xTipo := HCHOICE( aOpc, 4, 4 )
  
  if lastkey() == K_ESC
    restscreen( 00, 00, 23, 79, tImpoRece )
    return NIL
  endif
  
  nConf := iif( ConfLine( 12, 23, 2 ), 1, 2 )

  if lastkey() == K_ESC .or. nConf == 2
    restscreen( 00, 00, 23, 79, tImpoRece )
    return NIL
  endif

  cEmprIni := strzero( nEmprIni, 4 )
  cEmprFin := strzero( nEmprFin, 4 )
  cNotaIni := strzero( nNotaIni, 7 )
  cNotaFin := strzero( nNotaFin, 7 )
  cEmprAnt := cEmpresa
    
  select EmprARQ
  set order to 1  
  dbseek( cEmprIni, .f. ) 
  
  cEmpresa := Empr
  EmprNome := Razao
  cPath    := cCaminho + ';' + ( cCaminho + '\' + Direto )
  cPathAnt := alltrim( cCaminho ) + '\' + alltrim( Direto )
  cReceARQ := CriaTemp(0)
  aCampos  := CriaARQ( "ReceARQ", .f. )
      
  set path to ( cPath )
  
  Acesso ()
       
  dbcreate( cReceARQ , aCampos )

  if NetUse( cReceARQ, .f., 30 )
    cReceARQ := alias ()
  endif  
  
  if NetUse( "ReceARQ", .t. )
    VerifIND( "ReceARQ" )

    lOpenRece := .t.
  
    #ifdef DBF_NTX
      set index to ReceIND1
    #endif  
  else  
    lOpenRece := .f.
  endif

  do case 
    case xTipo == 1;         cTipo := 'P'
    case xTipo == 2;         cTipo := 'N'
    case xTipo == 3;         cTipo := 'O'
    case xTipo == 4;         cTipo := 'T'
  endcase    
  
  setcolor( CorCampo )
  
  select ReceARQ
  set order to 1
  dbseek( cNotaIni, .t. )
  do while Nota >= cNotaIni .and. Nota <= cNotaFin .and. !eof()
    if cTipo != 'T'
      if cTipo != Tipo
        dbskip ()
        loop
      endif
    endif       
     
    @ 15,19 say val( Nota )      pict '999999-9'
    @ 16,19 say Clie             pict '9999'
    
    select( cReceARQ )
    dbgobottom ()
    if AdiReg()
      if RegLock()
        replace Nota        with ReceARQ->Nota
        replace Tipo        with ReceARQ->Tipo
        replace Clie        with ReceARQ->Clie
        replace Emis        with ReceARQ->Emis
        replace Vcto        with ReceARQ->Vcto
        replace Pgto        with ReceARQ->Pgto
        replace Juro        with ReceARQ->Juro 
        replace Valor       with ReceARQ->Valor
        replace Pago        with ReceARQ->Pago 
        replace Acre        with ReceARQ->Acre
        replace Desc        with ReceARQ->Desc
        replace Port        with ReceARQ->Port
        replace Repr        with ReceARQ->Repr
        replace Cobr        with ReceARQ->Cobr
        replace Dest        with ReceARQ->Dest
        replace TipoVcto    with ReceARQ->TipoVcto
        replace ReprComi    with ReceARQ->ReprComi
        dbunlock ()
      endif
    endif  
    
    select ReceARQ
    dbskip ()
  enddo  
  
  if lOpenRece 
    select ReceARQ
    close
  endif    
 
  select EmprARQ
  set order to 1
  dbseek( cEmprFin, .f. ) 

  cEmpresa := Empr
  EmprNome := Razao
  cPathNew := ( alltrim( cCaminho ) + '\' + alltrim( Direto ) )
  cPath    := cCaminho + ';' + ( cCaminho + '\' + Direto )
  
  set path to ( cPath )
  
  Acesso ()
  
  if NetUse( "ReceARQ", .t. )
    VerifIND( "ReceARQ" )

    lOpenRece := .t.
  
    #ifdef DBF_NTX
      set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
    #endif  
  else  
    lOpenRece := .f.
  endif
  
  select( cReceARQ )
  dbgotop ()
  do while !eof()
    cNota := Nota
    cTipo := Tipo 
    cClie := Clie 
    
    @ 15,19 say val( Nota )       pict '999999-9' 
    @ 16,19 say cClie             pict '9999'
    
    select ReceARQ
    set order to 1
    dbseek( cNota + cTipo, .f. )
    
    if eof ()
      if AdiReg()
      endif
    endif   
    
    if RegLock()
      replace Nota        with &cReceARQ->Nota
      replace Tipo        with &cReceARQ->Tipo
      replace Clie        with &cReceARQ->Clie
      replace Emis        with &cReceARQ->Emis
      replace Vcto        with &cReceARQ->Vcto
      replace Pgto        with &cReceARQ->Pgto
      replace Juro        with &cReceARQ->Juro 
      replace Valor       with &cReceARQ->Valor
      replace Pago        with &cReceARQ->Pago 
      replace Acre        with &cReceARQ->Acre
      replace Desc        with &cReceARQ->Desc
      replace Port        with &cReceARQ->Port
      replace Repr        with &cReceARQ->Repr
      replace Cobr        with &cReceARQ->Cobr
      replace Dest        with &cReceARQ->Dest
      replace TipoVcto    with &cReceARQ->TipoVcto
      replace ReprComi    with &cReceARQ->ReprComi
      dbunlock ()
    endif  

    select( cReceARQ )
    dbskip ()
  enddo  
  
  if lOpenRece
    select ReceARQ
    close
  endif
  
  select( cReceARQ )
  close
    
  ferase( alltrim( cCaminho ) + '\TEMP\' + cReceARQ + '.' + cUsuario )
    
  restscreen( 00, 00, 23, 79, tImpoRece )
  
  select EmprARQ
  set order to 1  
  dbseek( cEmprAnt, .f. ) 
  
  cEmpresa := Empr
  EmprNome := Razao
  cPath    := cCaminho + ';' + ( cCaminho + '\' + Direto )
      
  set path to ( cPath )
  
  Acesso ()
       
return NIL

//
// Importa Clientes
//
function ImpoClie ()
  tImpoClie := savescreen( 00, 00, 23, 79 )
   
  Janela( 05, 05, 17, 69, 'Importar Clientes...', .f. )
  setcolor( CorJanel + ',' + CorCampo )
  
  @ 07,07 say ' Empresa Destino'
  @ 08,07 say 'Empresa Destino'
  @ 10,07 say 'Cliente Inicial                   Cliente Final' 
  @ 12,07 say '      Confirmar  Sim   Não'
  @ 13,05 say chr(195) + replicate( chr(196), 63 ) + chr(180)

  @ 15,12 say 'Código'
  @ 16,12 say '  Nome'

  setcolor( CorCampo )
  @ 12,23 say ' Sim '
  @ 12,29 say ' Não '

  setcolor( 'gr+/w' )
  @ 12,24 say 'S'
  @ 12,30 say 'N'
  
  setcolor( CorCampo )
  @ 15,19 say '   0'
  @ 16,19 say space(40)
  
  select EmprARQ
  dbgotop ()
  cEmprIni := Empr
  nEmprIni := val( Empr )

  @ 07,28 say Razao      pict '@S40' 
  dbgobottom ()
  cEmprFin := Empr
  nEmprFin := val( Empr )

  @ 08,28 say Razao      pict '@S40' 
  nConf    := 2
  nClieIni := 1
  nClieFin := 9999
    
  setcolor( CorJanel )
  @ 07,23 get nEmprIni   pict '9999'  valid ValidARQ( 07, 23, "EmprARQ", "Codigo", "Empr", "Descrição", "Razao", "Empr", "nEmprIni", .t., 4, "Empresas", "EmprARQ", 40 )
  @ 08,23 get nEmprFin   pict '9999'  valid ValidARQ( 08, 23, "EmprARQ", "Codigo", "Empr", "Descrição", "Razao", "Empr", "nEmprFin", .t., 4, "Empresas", "EmprARQ", 40 )
  @ 10,23 get nClieIni   pict '9999'
  @ 10,55 get nClieFin   pict '9999'  valid nClieFin >= nClieIni
  read
  
  if lastkey() == K_ESC
    restscreen( 00, 00, 23, 79, tImpoClie )
    return NIL
  endif
  
  nConf := iif( ConfLine( 12, 23, 2 ), 1, 2 )

  if lastkey() == K_ESC .or. nConf == 2
    restscreen( 00, 00, 23, 79, tImpoClie )
    return NIL
  endif

  cEmprIni := strzero( nEmprIni, 4 )
  cEmprFin := strzero( nEmprFin, 4 )
  cClieIni := strzero( nClieIni, 4 )
  cClieFin := strzero( nClieFin, 4 )
  cEmprAnt := cEmpresa
    
  select EmprARQ
  set order to 1  
  dbseek( cEmprIni, .f. ) 
  
  cEmpresa := Empr
  EmprNome := Razao
  cPath    := cCaminho + ';' + ( cCaminho + '\' + Direto )
  cPathAnt := alltrim( cCaminho ) + '\' + alltrim( Direto )
  cClieARQ := CriaTemp(0)
  aCampos  := CriaARQ( "ClieARQ", .f. )
      
  set path to ( cPath )
  
  Acesso ()
       
  dbcreate( cClieARQ , aCampos )

  if NetUse( cClieARQ, .f., 30 )
    cClieARQ := alias ()
  endif  
  
  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )

    lOpenClie := .t.
  
    #ifdef DBF_NTX
      set index to ClieIND1
    #endif  
  else  
    lOpenClie := .f.
  endif
  
  setcolor( CorCampo )
  
  select ClieARQ
  set order to 1
  dbseek( cClieIni, .t. )
  do while Clie >= cClieIni .and. Clie <= cClieFin .and. !eof()
    @ 15,19 say Clie             pict '9999' 
    @ 16,19 say Nome             pict '@S40'
    
    select( cClieARQ )
    dbgobottom ()
    if AdiReg()
      if RegLock()
        replace Clie         with ClieARQ->Clie
        replace Tipo         with ClieARQ->Tipo
        replace Ficha        with ClieARQ->Ficha
        replace SobreNome    with ClieARQ->SobreNome
        replace Razao        with ClieARQ->Razao
        replace Nome         with ClieARQ->Nome
        replace Data         with ClieARQ->Data
        replace Ende         with ClieARQ->Ende
        replace CEP          with ClieARQ->CEP
        replace Bair         with ClieARQ->Bair
        replace Cida         with ClieARQ->Cida
        replace UF           with ClieARQ->UF
        replace Fone         with ClieARQ->Fone
        replace Prox         with ClieARQ->Prox
        replace Desd         with ClieARQ->Desd
        replace RG           with ClieARQ->RG
        replace CPF          with ClieARQ->CPF
        replace Casa         with ClieARQ->Casa
        replace Filiacao     with ClieARQ->Filiacao
        replace Natural      with ClieARQ->Natural
        replace Nasc         with ClieARQ->Nasc
        replace EstaCivil    with ClieARQ->EstaCivil
        replace Aval         with ClieARQ->Aval
        replace FontRefe     with ClieARQ->FontRefe
        replace ObsSPC       with ClieARQ->ObsSPC
        replace Obse         with ClieARQ->Obse
        replace Emprego      with ClieARQ->Emprego
        replace Admi         with ClieARQ->Admi
        replace Carg         with ClieARQ->Carg
        replace FoneEmp      with ClieARQ->FoneEmp
        replace RamaEmp      with ClieARQ->RamaEmp
        replace Ordenado     with ClieARQ->Ordenado
        replace Outros       with ClieARQ->Outros
        replace Dependent    with ClieARQ->Dependent
        replace Conjuge      with ClieARQ->Conjuge
        replace CjNasc       with ClieARQ->CjNasc
        replace CjRG         with ClieARQ->CjRG
        replace CjCPF        with ClieARQ->CjCPF
        replace CjEmprego    with ClieARQ->CjEmprego
        replace CjAdmi       with ClieARQ->CjAdmi
        replace CjCargo      with ClieARQ->CjCargo
        replace CjFoneE      with ClieARQ->CjFoneE
        replace CjRamaEmp    with ClieARQ->CjRamaEmp
        replace CjOrdenado   with ClieARQ->CjOrdenado
        replace CjOutros     with ClieARQ->CjOutros
        replace Repr         with ClieARQ->Repr
        replace CGC          with ClieARQ->CGC
        replace InscEstd     with ClieARQ->InscEstd
        replace Fone         with ClieARQ->Fone
        replace Ramal        with ClieARQ->Ramal     
        replace Contato      with ClieARQ->Contato   
        replace Fax          with ClieARQ->Fax
        dbunlock ()
      endif
    endif  
    
    select ClieARQ
    dbskip ()
  enddo  
  
  if lOpenClie 
    select ClieARQ
    close
  endif    
 
  select EmprARQ
  set order to 1
  dbseek( cEmprFin, .f. ) 

  cEmpresa := Empr
  EmprNome := Razao
  cPathNew := ( alltrim( cCaminho ) + '\' + alltrim( Direto ) )
  cPath    := cCaminho + ';' + ( cCaminho + '\' + Direto )
  
  set path to ( cPath )
  
  Acesso ()
  
  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )

    lOpenClie := .t.
  
    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
    #endif  
  else  
    lOpenClie := .f.
  endif
  
  select( cClieARQ )
  dbgotop ()
  do while !eof()
    cClie := Clie
    cNome := Nome
    
    @ 15,19 say cClie             pict '9999' 
    @ 16,19 say cNome             pict '@S40'
    
    select ClieARQ
    set order to 1
    dbseek( cClie, .f. )
    
    if eof ()
      if AdiReg()
      endif
    endif   
    
    if RegLock()
      replace Clie         with &cClieARQ->Clie
      replace Tipo         with &cClieARQ->Tipo
      replace Ficha        with &cClieARQ->Ficha
      replace SobreNome    with &cClieARQ->SobreNome
      replace Razao        with &cClieARQ->Razao
      replace Nome         with &cClieARQ->Nome
      replace Data         with &cClieARQ->Data
      replace Ende         with &cClieARQ->Ende
      replace CEP          with &cClieARQ->CEP
      replace Bair         with &cClieARQ->Bair
      replace Cida         with &cClieARQ->Cida
      replace UF           with &cClieARQ->UF
      replace Fone         with &cClieARQ->Fone
      replace Prox         with &cClieARQ->Prox
      replace Desd         with &cClieARQ->Desd
      replace RG           with &cClieARQ->RG
      replace CPF          with &cClieARQ->CPF
      replace Casa         with &cClieARQ->Casa
      replace Filiacao     with &cClieARQ->Filiacao
      replace Natural      with &cClieARQ->Natural
      replace Nasc         with &cClieARQ->Nasc
      replace EstaCivil    with &cClieARQ->EstaCivil
      replace Aval         with &cClieARQ->Aval
      replace FontRefe     with &cClieARQ->FontRefe
      replace ObsSPC       with &cClieARQ->ObsSPC
      replace Obse         with &cClieARQ->Obse
      replace Emprego      with &cClieARQ->Emprego
      replace Admi         with &cClieARQ->Admi
      replace Carg         with &cClieARQ->Carg
      replace FoneEmp      with &cClieARQ->FoneEmp
      replace RamaEmp      with &cClieARQ->RamaEmp
      replace Ordenado     with &cClieARQ->Ordenado
      replace Outros       with &cClieARQ->Outros
      replace Dependent    with &cClieARQ->Dependent
      replace Conjuge      with &cClieARQ->Conjuge
      replace CjNasc       with &cClieARQ->CjNasc
      replace CjRG         with &cClieARQ->CjRG
      replace CjCPF        with &cClieARQ->CjCPF
      replace CjEmprego    with &cClieARQ->CjEmprego
      replace CjAdmi       with &cClieARQ->CjAdmi
      replace CjCargo      with &cClieARQ->CjCargo
      replace CjFoneE      with &cClieARQ->CjFoneE
      replace CjRamaEmp    with &cClieARQ->CjRamaEmp
      replace CjOrdenado   with &cClieARQ->CjOrdenado
      replace CjOutros     with &cClieARQ->CjOutros
      replace Repr         with &cClieARQ->Repr
      replace CGC          with &cClieARQ->CGC
      replace InscEstd     with &cClieARQ->InscEstd
      replace Fone         with &cClieARQ->Fone
      replace Ramal        with &cClieARQ->Ramal
      replace Contato      with &cClieARQ->Contato
      replace Fax          with &cClieARQ->Fax
      dbunlock ()
    endif  

    select( cClieARQ )
    dbskip ()
  enddo  
  
  if lOpenClie
    select ClieARQ
    close
  endif
  
  select( cClieARQ )
  close
    
  ferase( alltrim( cCaminho ) + '\TEMP\' + cClieARQ + '.' + cUsuario )
    
  restscreen( 00, 00, 23, 79, tImpoClie )
  
  select EmprARQ
  set order to 1  
  dbseek( cEmprAnt, .f. ) 
  
  cEmpresa := Empr
  EmprNome := Razao
  cPath    := cCaminho + ';' + ( cCaminho + '\' + Direto )
      
  set path to ( cPath )
  
  Acesso ()
       
return NIL

//
// Importa Pedidos
//
function ImpoPedi ()
  tImpoNota := savescreen( 00, 00, 23, 79 )
   
  Janela( 05, 05, 17, 69, 'Importar Pedidos...', .f. )
  setcolor( CorJanel + ',' + CorCampo )
  
  @ 07,07 say ' Empresa Destino'
  @ 08,07 say 'Empresa Destino'
  @ 10,07 say ' Pedido Inicial                    Pedido Final' 
  @ 12,07 say '      Confirmar  Sim   Não'
  @ 13,05 say chr(195) + replicate( chr(196), 63 ) + chr(180)

  @ 15,12 say '  Nota'
  @ 16,12 say '  Data'

  setcolor( CorCampo )
  @ 12,23 say ' Sim '
  @ 12,29 say ' Não '

  setcolor( 'gr+/w' )
  @ 12,24 say 'S'
  @ 12,30 say 'N'
  
  setcolor( CorCampo )
  @ 15,19 say '     0'
  @ 16,19 say '  /  /  '
  
  select EmprARQ
  set order to 1
  dbgotop ()
  cEmprIni := Empr
  nEmprIni := val( Empr )

  @ 07,28 say Razao      pict '@S40' 
  dbgobottom ()
  cEmprFin := Empr
  nEmprFin := val( Empr )

  @ 08,28 say Razao      pict '@S40' 
  nConf    := 2
  nNotaIni := 1
  nNotaFin := 999999
    
  setcolor( CorJanel )
  @ 07,23 get nEmprIni   pict '9999'    valid ValidARQ( 07, 23, "EmprARQ", "Codigo", "Empr", "Descrição", "Razao", "Empr", "nEmprIni", .t., 4, "Empresas", "EmprARQ", 40 )
  @ 08,23 get nEmprFin   pict '9999'    valid ValidARQ( 08, 23, "EmprARQ", "Codigo", "Empr", "Descrição", "Razao", "Empr", "nEmprFin", .t., 4, "Empresas", "EmprARQ", 40 )
  @ 10,23 get nNotaIni   pict '999999'
  @ 10,55 get nNotaFin   pict '999999'  valid nNotaFin >= nNotaIni
  read
  
  if lastkey() == K_ESC
    restscreen( 00, 00, 23, 79, tImpoNota )
    return NIL
  endif
  
  nConf := iif( ConfLine( 12, 23, 2 ), 1, 2 )

  if lastkey() == K_ESC .or. nConf == 2
    restscreen( 00, 00, 23, 79, tImpoNota )
    return NIL
  endif
  
  cEmprIni := strzero( nEmprIni, 4 )
  cEmprFin := strzero( nEmprFin, 4 )
  cNotaIni := strzero( nNotaIni, 6 )
  cNotaFin := strzero( nNotaFin, 6 )
  cEmprAnt := cEmpresa
    
  select EmprARQ
  set order to 1  
  dbseek( cEmprIni, .f. ) 
  
  cEmpresa := Empr
  EmprNome := Razao
  cPath    := cCaminho + ';' + ( cCaminho + '\' + Direto )
  cPathAnt := alltrim( cCaminho ) + '\' + alltrim( Direto )
  cNSaiARQ := CriaTemp(0)
  aCamNSai := CriaARQ( "NSaiARQ", .f. )
  inkey(1)
  cINSaARQ := CriaTemp(0)
  aCamINSa := CriaARQ( "INSaARQ", .f. )
      
  set path to ( cPath )
  
  Acesso ()
       
  dbcreate( cNSaiARQ , aCamNSai )
  dbcreate( cINSaARQ , aCamINSa )

  if NetUse( cNSaiARQ, .f., 30 )
    cNSaiARQ := alias ()
  endif  

  if NetUse( cINSaARQ, .f., 30 )
    cINSaARQ := alias ()
  endif  
  
  if NetUse( "NSaiARQ", .t. )
    VerifIND( "NSaiARQ" )

    lOpenNSai := .t.
  
    #ifdef DBF_NTX
      set index to NSaiIND1
    #endif  
  else  
    lOpenNSai := .f.
  endif
  
  if NetUse( "INSaARQ", .t. )
    VerifIND( "INSaARQ" )

    lOpenINSa := .t.
  
    #ifdef DBF_NTX
      set index to INSaiND1
    #endif  
  else  
    lOpenINSa := .f.
  endif
  
  setcolor( CorCampo )
  
  select NSaiARQ
  set order to 1
  dbseek( cNotaIni, .t. )
  do while Nota >= cNotaIni .and. Nota <= cNotaFin .and. !eof()
    cNota := Nota
  
    @ 15,19 say Nota             pict '999999'
    @ 16,19 say Emis             pict '99/99/9999'
     
    select( cNSaiARQ )
    if AdiReg()
      if RegLock()
        replace Nota       with NSaiARQ->Nota
        replace Emis       with NSaiARQ->Emis
        replace Clie       with NSaiARQ->Clie
        replace Cliente    with NSaiARQ->Cliente
        replace Cond       with NSaiARQ->Cond
        replace Repr       with NSaiARQ->Repr
        replace Port       with NSaiARQ->Port
        replace SubTotal   with NSaiARQ->SubTotal
        replace Desconto   with NSaiARQ->Desconto
        replace Comissao   with NSaiARQ->Comissao
        replace Vcto1      with NSaiARQ->Vcto1
        replace Valor1     with NSaiARQ->Valor1
        replace Comis1     with NSaiARQ->Comis1
        replace Vcto2      with NSaiARQ->Vcto2
        replace Valor2     with NSaiARQ->Valor2
        replace Comis2     with NSaiARQ->Comis2
        replace Vcto3      with NSaiARQ->Vcto3
        replace Valor3     with NSaiARQ->Valor3
        replace Comis3     with NSaiARQ->Comis3
        replace Vcto4      with NSaiARQ->Vcto4
        replace Valor4     with NSaiARQ->Valor4
        replace Comis4     with NSaiARQ->Comis4
        replace Vcto5      with NSaiARQ->Vcto5
        replace Valor5     with NSaiARQ->Valor5
        replace Comis6     with NSaiARQ->Comis5
        replace Vcto6      with NSaiARQ->Vcto6
        replace Valor6     with NSaiARQ->Valor6
        replace Comis7     with NSaiARQ->Comis6
        replace Vcto7      with NSaiARQ->Vcto7
        replace Valor7     with NSaiARQ->Valor7
        replace Comis7     with NSaiARQ->Comis7
        replace Vcto8      with NSaiARQ->Vcto8
        replace Valor8     with NSaiARQ->Valor8
        replace Comis8     with NSaiARQ->Comis8
        replace Vcto9      with NSaiARQ->Vcto9
        replace Valor9     with NSaiARQ->Valor9
        replace Comis9     with NSaiARQ->Comis9
        dbunlock ()
      endif
    endif  
    
    select INSaARQ
    set order to 1
    dbseek( cNota + '01', .t. )
    do while Nota == cNota .and. !eof ()
      @ 15,26 say INSaARQ->Sequ
    
      select( cINSaARQ )
      if AdiReg()
        if RegLock()    
          replace Nota            with INSaARQ->Nota
          replace Sequ            with INSaARQ->Sequ
          replace Prod            with INSaARQ->Prod
          replace Qtde            with INSaARQ->Qtde
          replace Comi            with INSaARQ->Comi
          replace Desc            with INSaARQ->Desc
          replace PrecoVenda      with INSaARQ->PrecoVenda
          dbunlock ()
        endif
      endif    
     
      select INSaARQ
      dbskip ()
    enddo   
 
    select NSaiARQ
    dbskip ()
  enddo  
  
  if lOpenNSai 
    select NSaiARQ
    close
  endif    

  if lOpenINSa 
    select INSaARQ
    close
  endif    
 
  select EmprARQ
  set order to 1
  dbseek( cEmprFin, .f. ) 

  cEmpresa := Empr
  EmprNome := Razao
  cPathNew := ( alltrim( cCaminho ) + '\' + alltrim( Direto ) )
  cPath    := cCaminho + ';' + ( cCaminho + '\' + Direto )
  
  set path to ( cPath )
  
  Acesso ()
  
  if NetUse( "NSaiARQ", .t. )
    VerifIND( "NSaiARQ" )

    lOpenNSai := .t.
  
    #ifdef DBF_NTX
      set index to NSaiIND1
    #endif  
  else  
    lOpenNSai := .f.
  endif
  
  if NetUse( "INSaARQ", .t. )
    VerifIND( "INSaARQ" )

    lOpenINSa := .t.
  
    #ifdef DBF_NTX
      set index to INSaiND1
    #endif  
  else  
    lOpenINSa := .f.
  endif
  
  select( cNSaiARQ )
  dbgotop ()
  do while !eof()
    cNota := Nota
    dEmis := Emis
    
    @ 15,19 say cNota             pict '999999'
    @ 16,19 say dEmis             pict '99/99/9999'
    
    select NSaiARQ
    set order to 1
    dbseek( cNota, .f. )
    
    if eof ()
      if AdiReg()
      endif
    endif   
    
    if RegLock()
      replace Nota       with &cNSaiARQ->Nota
      replace Emis       with &cNSaiARQ->Emis
      replace Clie       with &cNSaiARQ->Clie
      replace Cliente    with &cNSaiARQ->Cliente
      replace Cond       with &cNSaiARQ->Cond
      replace Repr       with &cNSaiARQ->Repr
      replace Port       with &cNSaiARQ->Port
      replace SubTotal   with &cNSaiARQ->SubTotal
      replace Desconto   with &cNSaiARQ->Desconto
      replace Comissao   with &cNSaiARQ->Comissao
      replace Vcto1      with &cNSaiARQ->Vcto1
      replace Valor1     with &cNSaiARQ->Valor1
      replace Comis1     with &cNSaiARQ->Comis1
      replace Vcto2      with &cNSaiARQ->Vcto2
      replace Valor2     with &cNSaiARQ->Valor2
      replace Comis2     with &cNSaiARQ->Comis2
      replace Vcto3      with &cNSaiARQ->Vcto3
      replace Valor3     with &cNSaiARQ->Valor3
      replace Comis3     with &cNSaiARQ->Comis3
      replace Vcto4      with &cNSaiARQ->Vcto4
      replace Valor4     with &cNSaiARQ->Valor4
      replace Comis4     with &cNSaiARQ->Comis4
      replace Vcto5      with &cNSaiARQ->Vcto5
      replace Valor5     with &cNSaiARQ->Valor5
      replace Comis5     with &cNSaiARQ->Comis5
      replace Comis6     with NSaiARQ->Comis5
      replace Vcto6      with NSaiARQ->Vcto6
      replace Valor6     with NSaiARQ->Valor6
      replace Comis7     with NSaiARQ->Comis6
      replace Vcto7      with NSaiARQ->Vcto7
      replace Valor7     with NSaiARQ->Valor7
      replace Comis7     with NSaiARQ->Comis7
      replace Vcto8      with NSaiARQ->Vcto8
      replace Valor8     with NSaiARQ->Valor8
      replace Comis8     with NSaiARQ->Comis8
      replace Vcto9      with NSaiARQ->Vcto9
      replace Valor9     with NSaiARQ->Valor9
      replace Comis9     with NSaiARQ->Comis9
      dbunlock ()
    endif  

    select( cNSaiARQ )
    dbskip ()
  enddo  

  select( cINSaARQ )
  dbgotop ()
  do while !eof ()
    cNota := Nota
    cSequ := Sequ

    @ 15,19 say cNota 
    @ 15,26 say cSequ
  
    select INSaARQ
    set order to 1
    dbseek( cNota + cSequ, .f. )
    
    if eof ()
      if AdiReg()
      endif
    endif
    
    if RegLock()    
      replace Nota            with &cINSaARQ->Nota
      replace Sequ            with &cINSaARQ->Sequ
      replace Prod            with &cINSaARQ->Prod
      replace Qtde            with &cINSaARQ->Qtde
      replace Comi            with &cINSaARQ->Comi
      replace Desc            with &cINSaARQ->Desc
      replace PrecoVenda      with &cINSaARQ->PrecoVenda
      dbunlock ()
    endif
     
    select( cINSaARQ )
    dbskip ()
  enddo   
  
  if lOpenNSai
    select NSaiARQ
    close
  endif
  
  if lOpenINSa
    select INSaARQ
    close
  endif
  
  select( cNSaiARQ )
  close
  select( cINSaARQ )
  close
    
  ferase( alltrim( cCaminho ) + '\TEMP\' + cNSaiARQ + '.' + cUsuario )
  ferase( alltrim( cCaminho ) + '\TEMP\' + cINSaARQ + '.' + cUsuario )
    
  restscreen( 00, 00, 23, 79, tImpoNota )
  
  select EmprARQ
  set order to 1  
  dbseek( cEmprAnt, .f. ) 
  
  cEmpresa := Empr
  EmprNome := Razao
  cPath    := cCaminho + ';' + ( cCaminho + '\' + Direto )
      
  set path to ( cPath )
  
  Acesso ()
       
return NIL

//
// Importa Produtos
//
function ImpoProd ()
  tImpoProd := savescreen( 00, 00, 23, 79 )
   
  Janela( 08, 05, 17, 69, 'Importar Produtos...', .f. )
  setcolor( CorJanel + ',' + CorCampo )
  
  @ 10,07 say '         Destino'
  @ 12,07 say '      Confirmar  Sim   Não'
  @ 13,05 say chr(195) + replicate( chr(196), 63 ) + chr(180)

  @ 15,12 say 'Código'
  @ 16,12 say '  Nome'

  setcolor( CorCampo )
  @ 10,23 say ' Sim '
  @ 10,29 say ' Não '
  @ 12,23 say ' Sim '
  @ 12,29 say ' Não '

  setcolor( 'gr+/w' )
  @ 10,24 say 'S'
  @ 10,30 say 'N'
  @ 12,24 say 'S'
  @ 12,30 say 'N'
  
  setcolor( CorCampo )
  @ 15,19 say '   0'
  @ 16,19 say space(40)
  
  nConf    := 2
  cDrive   := "a:\ProdARQ                              "
  nProdIni := 1
  nProdFin := 9999
    
  setcolor( CorJanel )
  @ 10,23 get cDrive     pict '@S30'  
  read
  
  if lastkey() == K_ESC
    restscreen( 00, 00, 23, 79, tImpoProd )
    return NIL
  endif
  
  nConf := iif( ConfLine( 12, 23, 2 ), 1, 2 )

  if lastkey() == K_ESC .or. nConf == 2
    restscreen( 00, 00, 23, 79, tImpoProd )
    return NIL
  endif
  
  aField   := CriaARQ( "ProdARQ", .f. )
  cCampARQ := CriaTemp(0)
  
  SeleGera( "ProdARQ" )
  
  use ( alltrim( cDrive ) ) exclusive new alias ProdTMP
      
  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )

    lOpenProd := .t.
  
    #ifdef DBF_NTX
      set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
    #endif  
  else  
    lOpenProd := .f.
  endif

  setcolor( CorCampo )
  
  nIncl := 0
  nAlte := 0
  
  select ProdTMP
  set order to 1
  dbgotop()
  do while !eof()
    @ 15,19 say Prod             pict '9999' 
    @ 16,19 say Nome             pict '@S40'
    
    cProd := Prod 
    
    select ProdARQ
    set order to 1
    dbseek( cProd, .f. )
    
    if found()
      nAlte ++
    else 
      if AdiReg()
      endif
      
      nIncl ++
    endif   
    
    for nJ := 1 to len( aField )
      xCamp := upper( alltrim( aField[ nJ, 1 ] ) )
      
      select( cCampARQ )
      dbgotop ()
      do while !eof ()
        xVari  := alltrim( upper( alltrim( Vari ) ) )
        
        if xCamp == xVari .and. Marc == '[X] '
          select ProdTMP
          cCampo := &xVari
          
          select ProdARQ
          if RegLock()
            replace &xVari     with cCampo
            dbunlock ()
          endif
        endif  
          
        select( cCampARQ ) 
        dbskip ()
      enddo   
    next   
    
    select ProdTMP
    dbskip ()
  enddo  
  
  close
  
  select ProdARQ
  if lOpenProd 
    select ProdARQ
    close
  endif    
  
  Alerta( "Produtos Incluidos: " + strzero( nIncl, 4 ) + space(13) +;
          "Produtos Alterados: " + strzero( nAlte, 4 ) )
 
  restscreen( 00, 00, 23, 79, tImpoProd )
return NIL