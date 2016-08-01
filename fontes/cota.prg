//  Leve, Cotacao de Preços de Produtos
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

function Cota ()

if NetUse( "ProdARQ", .t. )
  VerifIND( "ProdARQ" )
  
  sOpenProd := .t.
  
  #ifdef DBF_NTX
    set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
  #endif
else
  sOpenProd := .f.  
endif

if NetUse( "CotaARQ", .t. )
  VerifIND( "CotaARQ" )
  
  sOpenCota := .t.
  
  #ifdef DBF_NTX
    set index to CotaIND1
  #endif
else
  sOpenCota := .f.  
endif

if NetUse( "ICotARQ", .t. )
  VerifIND( "ICotARQ" )
  
  sOpenICot := .t.
  
  #ifdef DBF_NTX
    set index to ICotIND1
  #endif
else
  sOpenICot := .f.  
endif

if NetUse( "GrupARQ", .t. )
  VerifIND( "GrupARQ" )
  
  sOpenGrup := .t.

  #ifdef DBF_NTX
    set index to GrupIND1, GrupIND2
  #endif
else
  sOpenGrup := .f.  
endif

if NetUse( "SubGARQ", .t. )
  VerifIND( "SubGARQ" )
  
  sOpenSubG := .t.
  
  #ifdef DBF_NTX
    set index to SubGIND1, SubGIND2, SubGIND3
  #endif
else
  sOpenSubG := .f.  
endif

//  Variaveis para Saida de dados
nNota     := nSequ       := 0
nQtde     := nSequPrx    := 0
cSequ     := space(04)
cGrup     := cSubG       := space(03)
cProd     := space(04)
cNota     := space(06)
cProduto  := space(45)
aOpcoes   := {}
aArqui    := {}
cCotaARQ  := CriaTemp(0)
cCotaIND1 := CriaTemp(1)
cChave    := "Sequ"

aadd( aArqui, { "Sequ",       "C", 004, 0 } )
aadd( aArqui, { "Prod",       "C", 006, 0 } )
aadd( aArqui, { "Qtde",       "N", 012, 3 } )
aadd( aArqui, { "Produto",    "M", 010, 0 } )
aadd( aArqui, { "Regi",       "N", 008, 0 } )
aadd( aArqui, { "Novo",       "L", 001, 0 } )
aadd( aArqui, { "Lixo",       "L", 001, 0 } )

dbcreate( cCotaARQ , aArqui )
   
if NetUse( cCotaARQ, .f. )
  cCotaTMP := alias ()
    
  index on &cChave to &cCotaIND1

  #ifdef DBF_NTX
  set index to &cCotaIND1
  #endif
endif
 
Janela ( 04, 02, 21, 76, mensagem( 'Janela', 'Cota', .f. ), .f. )
setcolor ( CorJanel + ',' + CorCampo )

@ 06,03 say '   Cotação'

@ 08,09 say 'Código Nome                                        Qtde.'
@ 09,02 say chr(195) + replicate( chr(196), 73 ) + chr(180)
@ 09,15 say chr(194)
@ 09,59 say chr(194)

for nY := 10 to 18
  @ nY,15 say chr(179)
  @ nY,59 say chr(179)
next  
  
@ 19,02 say chr(195) + replicate( chr(196), 73 ) + chr(180)
@ 19,15 say chr(193)
@ 19,59 say chr(193)

MostOpcao( 20, 04, 16, 52, 65 ) 
tSnot := savescreen( 00, 00, 24, 79 )
  
select ProdARQ
set relation to Grup into GrupARQ, to Grup + SubG into SubGARQ
set order    to 1
dbgotop ()

select CotaARQ
set order to 1
dbgobottom ()

select ICotARQ
set relation to Prod into ProdARQ
set order    to 1

do while .t.
  cStat := cStatAux := space(04)
  restscreen( 00, 00, 23, 79, tSnot )

  Mensagem( 'Cota', 'Janela' )
  
  select( cCotaTMP )
  set order to 1
  zap
  
  select ProdARQ
  set order to 1

  select GrupARQ
  set order to 1

  select SubGARQ
  set order to 1

  select ICotARQ
  set relation to Prod into ProdARQ
  set order    to 1

  select CotaARQ
  set order    to 1

  MostCota ()
  
  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostCota'
  cAjuda   := 'Cota'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()

  @ 06,14 get nNota            pict '999999'
  read
  
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. nNota == 0
    exit
  endif

  cNota := strzero( nNota, 6 )

  //  Verificar existencia das Notas para Incluir ou Alterar
  select CotaARQ
  set order to 1
  dbseek( cNota, .f. )
  if eof()
    cStat    := 'incl'
  else
    cStat := 'alte'
  endif

  Mensagem ('Cota', cStat )
  
  select ICotARQ
  set order to 1
  dbseek( cNota, .t. )
  do while Nota == cNota
    nRegi := recno ()
    
    select( cCotaTMP )
    if AdiReg()
      if RegLock()
        replace Sequ       with ICotARQ->Sequ
        replace Prod       with ICotARQ->Prod
        replace Produto    with ICotARQ->Produto
        replace Qtde       with ICotARQ->Qtde
        replace Regi       with nRegi
        replace Novo       with .f.
        replace Lixo       with .f.
        dbunlock ()
      endif
    endif
    
    select ICotARQ
    dbskip ()
  enddo
  
  gStatAnt := cStat
  
  select CotaARQ

  MostCota ()
  EntrCota ()  
  EntrItCo ()
  
  Confirmar( 20, 04, 16, 52, 65, 3 ) 
    
  if cStat == 'excl'
    EstoCota ()
  endif
  
  if cStat == 'prin'
    ImprCota()
  endif
 
  if cStat == 'loop' .or. lastkey() == K_ESC
    loop
  endif  
  
  cStat := gStatAnt 
  
  if cStat == 'incl'
    select CotaARQ 
    set order to 1
    if AdiReg()
      if RegLock()
        replace Nota      with cNota
        dbunlock ()
      endif
    endif
  endif  
  
  select CotaARQ
  
  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      dbunlock ()
    endif
  endif

  GravCota ()
enddo

if sOpenProd
  select ProdARQ
  close
endif

if sOpenCota
  select CotaARQ
  close
endif

if sOpenGrup
  select GrupARQ
  close
endif

if sOpenSubG
  select SubGARQ
  close
endif

if sOpenICot
  select ICotARQ
  close
endif

select( cCotaTMP )
close
ferase( cCotaARQ )
ferase( cCotaIND1 )
#ifdef DBF_CDX
  ferase( left( cCotaARQ, len( cCotaARQ ) - 3 ) + 'FPT' )
#endif  
#ifdef DBF_NTX
  ferase( left( cCotaARQ, len( cCotaARQ ) - 3 ) + 'DBT' )
#endif  

return NIL
//
// Mostra os dados
//
function MostCota()
  setcolor( CorCampo )
  if cStat != 'incl'  
    nNota := val( Nota )
    cNota := Nota
  
    @ 06,14 say cNota            pict '999999'
  endif  
  
  nLin  := 10

  if cStat == 'alte' .or. cStat == space(04)
    setcolor( CorJanel )
    for nG := 1 to 9
      @ nLin, 09 say '      '    
      @ nLin, 16 say space(43)
      @ nLin, 60 say '         '
      nLin ++
    next

    nLin := 10
    
    setcolor( CorJanel )
    select ICotARQ
    set order to 1
    dbseek( cNota + '01', .t. )
    do while Nota == cNota
      @ nLin, 09 say Prod                  pict '999999'    
      if Prod == '999999'
        @ nLin, 16 say memoline( Produto, 43, 1 )
      else  
        @ nLin, 16 say ProdARQ->Nome       pict '@S43'
      endif  
      if EmprARQ->Inteira == "X"
        @ nLin, 60 say Qtde                  pict '@E 999999999'
      else      
        @ nLin, 60 say Qtde                  pict '@E 99999.999'
      endif 
      nLin ++
      dbskip ()
      if nLin >= 19
        exit
      endif   
    enddo
    select CotaARQ
    setcolor( CorCampo )
  else
   setcolor( CorJanel )
    for nG := 1 to 9 
      @ nLin, 09 say '      '    
      @ nLin, 16 say space(43)
      @ nLin, 60 say '         '
      nLin ++
    next
    setcolor( CorCampo )
  endif  
  
  PosiDBF( 04, 76 )
return NIL

//
// entra os dados
//
function EntrCota ()
  setcolor( CorJanel + ',' + CorCampo )
return NIL    

//
// Entra com os itens 
//
function EntrItCo()

  select( cCotaTMP )
  set order    to 1
  set relation to Prod into ProdARQ

  bFirst := {|| dbseek( '0001', .t. ) }
  bLast  := {|| dbseek( '9999', .t. ), dbskip(-1) }
  bFor   := {|| .t. }
  bWhile := {|| .t. }

  oColuna         := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oColuna:nTop    := 8
  oColuna:nLeft   := 4
  oColuna:nBottom := 19
  oColuna:nRight  := 73
  oColuna:headsep := chr(194)+chr(196)
  oColuna:colsep  := chr(179)
  oColuna:footsep := chr(193)+chr(196)

  oColuna:addColumn( TBColumnNew("Código" ,  {|| Prod } ) )
  oColuna:addColumn( TBColumnNew("Nome",  {|| iif( Prod == '999999', memoline( Produto, 43, 1 ), left( ProdARQ->Nome, 43 ) ) } ) )
  if EmprARQ->Inteira == "X"
    oColuna:addColumn( TBColumnNew("Qtde.", {|| transform( Qtde, '@E 999999999' ) } ) )
  else  
    oColuna:addColumn( TBColumnNew("Qtde.", {|| transform( Qtde, '@E 99999.999' ) } ) )
  endif  
            
  lExitRequested := .f.
  lAdiciona      := .f.
  lAlterou       := .f.
  cSequ          := space(04)
  nSequ          := 0
  cTecla         := 0
  nLin           := 9

  oColuna:goBottom()

  do while !lExitRequested
    Mensagem ( 'LEVE', 'Browse' )
 
    oColuna:forcestable()
    
    if cStat == 'incl' .and. cSequ == space(04)   
      cTecla := K_INS
    else
      cTecla := Teclar(0)
    endif  

    if oColuna:hitTop .or. oColuna:hitBottom
      tone( 125, 0 )
    endif

    do case
      case cTecla == K_DOWN;        oColuna:down()
      case cTecla == K_UP;          oColuna:up()
      case cTecla == K_PGUP;        oColuna:pageUp()
      case cTecla == K_CTRL_PGUP;   oColuna:goTop()
      case cTecla == K_PGDN;        oColuna:pageDown()
      case cTecla == K_CTRL_PGDN;   oColuna:goBottom()
      case cTecla == 46;            lExitRequested := .t.
      case cTecla == K_ESC
        if Saindo (lAlterou)
          lExitRequested := .t.
        else  
          lExitRequested := .f.
        endif  
      case cTecla == K_ENTER
        if !empty( Sequ )
          lAdiciona := .f.
        
          EntrItCota( lAdiciona, oColuna, nLin )
        endif  
      case cTecla == K_INS
        nRegi := recno ()

        dbgotop ()
        do while !eof ()
          cSequ := Sequ
          nSequ := val( Sequ )
          
          dbskip ()
        enddo   
          
        go nRegi
        do while lastkey() != K_ESC    
          lAdiciona := .t.
          
          EntrItCota( lAdiciona, oColuna, nLin )
        enddo  
      case cTecla == K_DEL
        if RegLock()
          replace Lixo      with .t.  
            
          dbdelete ()
          dbunlock ()
    
          oColuna:refreshAll()  
        endif  
    endcase
  enddo
return NIL  

//
// Entra intens da nota
//
function EntrItCota( lAdiciona, oColuna, nLin )
  if lAdiciona 
    cSequ := strzero( nSequ + 1, 4 )
      
    if AdiReg()
      if RegLock()
        replace Sequ            with cSequ
        replace Novo            with .t.
        replace Lixo            with .f.
        dbunlock ()
      endif
    endif    
    
    dbgobottom ()

    oColuna:goBottom() 
    oColuna:refreshAll()  

    oColuna:forcestable()

    Mensagem( 'Cota', 'ItCotaIncl' )
  else
    Mensagem( 'Cota', 'ItCotaAlte' )
  endif  

  cSequ    := Sequ
  nSequ    := val( Sequ )
  cProd    := Prod
  cProduto := Produto
  nProd    := val( cProd )
  nQtde    := Qtde
  nLin     := 09 + oColuna:rowPos
    
  setcolor( CorCampo )
  if cProd == '999999'
    @ nLin, 16 say memoline( Produto, 43, 1 )
  else  
    @ nLin, 16 say ProdARQ->Nome         pict '@S43'
  endif  
  
  set key K_UP to UpNota
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ nLin, 09 get cProd         pict '@!'            valid ValidProd( nLin, 09, cCotaTMP, 'cota', 0, 0 )
  if EmprARQ->Inteira == "X"
    @ nLin, 60 get nQtde       pict '@E 999999999'  valid VoltaUp ()
  else  
    @ nLin, 60 get nQtde       pict '@E 99999.999'  valid VoltaUP ()
  endif  
  read
  
  set key K_UP to 
  
  cProd := strzero( nProd, 6 )
       
  if lastkey () == K_ESC
    if lAdiciona
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif  
    endif  

    oColuna:refreshCurrent()  
    oColuna:goBottom()
    return NIL
  endif  
  
  if RegLock()
    replace Prod            with cProd
    replace Produto         with cProduto
    replace Qtde            with nQtde
    replace Lixo            with .f.
    dbunlock ()
  endif
  
  oColuna:refreshCurrent()  

  lAlterou := .t.
return NIL     

//
// Excluir nota
//
function EstoCota ()
  cStat  := 'loop' 
  
  select CotaARQ

  if ExclRegi ()
    select ICotARQ
    set order to 1
    dbseek( cNota, .t. )
    do while Nota == cNota
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif
        
      dbskip ()
    enddo    
    
    select CotaARQ
  endif
return NIL

//
// Entra o estoque
//
function GravCota()
  
  set deleted off

  select( cCotaTMP )
  set order to 1
  dbgotop ()
  do while !eof ()
    if empty( Prod )
      dbskip ()
      loop
    endif

    cProd    := Prod
    cProduto := Produto
    nQtde    := Qtde
    nRegi    := Regi
    lLixo    := Lixo

    if Novo
      if Lixo
        dbskip ()
        loop
      endif

      select ICotARQ
      if AdiReg()
        if RegLock()
          replace Nota       with cNota
          replace Sequ       with &cCotaTMP->Sequ
          replace Prod       with &cCotaTMP->Prod
          replace Produto    with &cCotaTMP->Produto
          replace Qtde       with &cCotaTMP->Qtde
          dbunlock ()
        endif
      endif
    else
      select ICotARQ
      go nRegi

      if RegLock()
        replace Prod          with cProd
        replace Produto       with cProduto
        replace Qtde          with nQtde
        dbunlock ()
      endif

      if lLixo
        if RegLock()
          dbdelete ()
          dbunlock ()
       endif
      endif
    endif

    select( cCotaTMP )
    dbskip ()
  enddo

  set deleted on
  
  select CotaARQ
return NIL

//
// Imprime Dados
//
function PrinCota ( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "ProdARQ", .t. )
      VerifIND( "ProdARQ" )
  
      lOpenProd := .t.
       
      #ifdef DBF_NTX
        set index to ProdIND1, ProdIND2
      #endif
    else
      lOpenProd := .f.  
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

    if NetUse( "CotaARQ", .t. )
      VerifIND( "CotaARQ" )
  
      lOpenCota := .t.
  
      #ifdef DBF_NTX
        set index to CotaIND1
      #endif
    else
      lOpenCota := .f.  
    endif

    if NetUse( "ICotARQ", .t. )
      VerifIND( "ICotARQ" )
  
      lOpenICot := .t.
  
      #ifdef DBF_NTX
        set index to ICotIND1
      #endif
    else
      lOpenICot := .f.  
    endif

    if NetUse( "TbPrARQ", .t. )
      VerifIND( "TbPrARQ" )
  
      lOpenTbPr := .t.
  
      #ifdef DBF_NTX
        set index to TbPrIND1, TbPrIND2
      #endif
    else
      lOpenTbPr := .f.  
    endif

    if NetUse( "ITbPARQ", .t. )
      VerifIND( "ITbPARQ" )
  
      lOpenITbP := .t.
  
      #ifdef DBF_NTX
        set index to ITbPIND1
      #endif
    else
      lOpenITbP := .f.  
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

    if NetUse( "SubGARQ", .t. )
      VerifIND( "SubGARQ" )
  
      lOpenSubG := .t.
  
      #ifdef DBF_NTX
        set index to SubGIND1, SubGIND2, SubGIND3
      #endif
    else
      lOpenSubG := .f.  
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 08, 08, 12, 70, mensagem( 'Janela', 'Cota', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,10 say '  Cotação Inicial               Cotação Final'
  @ 11,10 say ' Validade Inicial              Validade Final'

  select CotaARQ
  set order to 1   
  dbgotop ()
  nNotaIni := val ( Nota )
  dbgobottom ()
  nNotaFin := val ( Nota )
  
  dDataIni := ctod( '01/01/1900' )
  dDataFin := ctod( '31/12/2015' )

  @ 10,28 get nNotaIni          pict '999999' 
  @ 10,56 get nNotaFin          pict '999999'     valid nNotaFin >= nNotaIni
  @ 11,28 get dDataIni          pict '99/99/9999' 
  @ 11,56 get dDataFin          pict '99/99/9999'    valid dDataFin >= dDataIni
  read

  if lastkey() == K_ESC
    select CotaARQ
    if lAbrir
      close
      select ProdARQ
      close
      select FornARQ
      close
      select TbPrARQ
      close
      select ITbPARQ
      close
      select GrupARQ
      close
      select SubGARQ
      close
      select ICotARQ
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
  cNotaIni := strzero( nNotaIni )
  cNotaFin := strzero( nNotaFin )
  aCotacao := {}
  cFornAnt := space(06)
  lInicio  := .t.

  // Posiciona Primeiro Produtos
  
  select CotaARQ
  set order to 1
  dbseek( cNotaIni, .t. )
  do while Nota >= cNotaIni .and. Nota <= cNotaFin .and. !eof ()
    cNota := Nota
    
    select ICotARQ
    set relation to Prod into ProdARQ
    set order    to 1
    dbseek( cNota, .t. )
    do while Nota == cNota .and. !eof()
      cProd     := Prod
      nProdElem := ascan( aCotacao, { |nElem| nElem[1] == cProd } )
       
      if nProdElem == 0
        aadd( aCotacao, { cProd, ProdARQ->Nome, space(06), space(45), 0 } )
      endif  

      dbskip ()
    enddo 
    
    select CotaARQ    
    dbskip ()
  enddo
  
  select TbPrARQ
  set order    to 2
  set relation to Forn into FornARQ
  dbseek( dDataIni, .t. )
  do while Data >= dDataIni .and. Data <= dDataFin .and. !eof ()
    cForn := Forn
    cNome := FornARQ->Nome
    dData := Data
    nDesc := Desc
    
    select ITbPARQ
    set order to 1
    dbseek( cForn + dtos( dData ),  .t. )
    do while Forn == cForn .and. Data == dData .and. !eof()
      cProd       := Prod
      nPrecoCusto := PrecoCusto - ( ( PrecoCusto * nDesc ) / 100 )
      nProdElem   := ascan( aCotacao, { |nElem| nElem[1] == cProd } )
          
      if nProdElem > 0
        if aCotacao[ nProdElem, 5 ] > nPrecoCusto .or. aCotacao[ nProdElem, 5 ] == 0
          aCotacao[ nProdElem, 3 ] := cForn
          aCotacao[ nProdElem, 4 ] := cNome
          aCotacao[ nProdElem, 5 ] := nPrecoCusto
        endif  
      endif  
      dbskip ()
    enddo
    
    select TbPrARQ
    dbskip ()
  enddo  
    
  asort( aCotacao,,, { |Forn01, Forn02| Forn01[3] < Forn02[3] } )
 
  for nU := 1 to len( aCotacao )
    cProd       := aCotacao[ nU, 1 ]
    cNomeProd   := aCotacao[ nU, 2 ]
    cForn       := aCotacao[ nU, 3 ]
    cNomeForn   := aCotacao[ nU, 4 ]
    nPrecoCusto := aCotacao[ nU, 5 ]
    
    if nPrecoCusto == 0
      loop
    endif

    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
      
      lInicio := .f.
    endif  
  
    if nLin == 0
      Cabecalho ( 'Cotacao de Precos', 80, 1 )
      CabCota   ()
    endif
    
    if cForn != cFornAnt
      cFornAnt := cForn
      nLin ++
      @ nLin,01 say cForn
      @ nLin,08 say cNomeForn
      nLin ++
    endif
    
    @ nLin,008 say cProd
    @ nLin,013 say cNomeProd
    @ nLin,069 say nPrecoCusto                            pict PictPreco(10)
    nLin ++

    if nLin >= pLimite
      Rodape(80) 

      cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
      cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

      set printer to ( cArqu2 )
      set printer on
    endif
  next

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
      replace Titu       with "Relatório de Cotação de Preços"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
    close
  endif  

  select CotaARQ
  if lAbrir
    close
    select ProdARQ
    close
    select FornARQ
    close
    select TbPrARQ
    close
    select ITbPARQ
    close
    select GrupARQ
    close
    select SubGARQ
    close
    select ICotARQ
    close
  else
    set order to 1 
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabCota ()
  @ 02,01 say 'Fornecedor'
  @ 03,01 say '     Produto                                                       Preco Custo'

  nLin     := 4 
  cFornAnt := space(04)
return NIL

//
// Imprimir Cotaçao
//
function ImprCota ( lTipo )

  if !TestPrint(1)
    return NIL
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )
  
  @ 00, 00 say ' '
  @ 00, 00 say chr(27) + "@"
  @ 00, 00 say chr(15)

  nLin  := 0

  select CotaARQ 
  
  @ nLin,001 say '+---------------------------------------------------------------------------------------------------------------------------------+'    
  nLin ++ 
  @ nLin,001 say '| ' + EmprARQ->Razao
  @ nLin,131 say '|'
  nLin ++ 
  @ nLin,001 say '| ' + EmprARQ->Ende
  @ nLin,101 say '        Cotação N.'
  @ nLin,120 say Nota                            pict '999999'
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '| ' + transform( EmprARQ->CEP, '99999-999' ) + '   ' + left( EmprARQ->Bairro, 15 ) + '   ' + alltrim( EmprARQ->Cida ) + '/' + EmprARQ->UF
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '| ' + EmprARQ->Fone + '     ' + EmprARQ->Fax                     
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '| '
  @ nLin,003 say EmprARQ->CGC                     pict '@R 99.999.999/9999-99'
  @ nLin,026 say EmprARQ->InscEstd                
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '+---------------------------------------------------------------------------------------------------------------------------------+'    
  nLin ++
  @ nLin,001 say '+--------+------------------------------------------------------+-----------------+----+----------------+------------+------------+'
  nLin ++
  @ nLin,001 say '| Codigo | Descrição dos Produtos                               | Referencia      | Un.|     Quantidade |   P. Custo |   V. Total |'
  nLin ++
  @ nLin,001 say '+--------+------------------------------------------------------+-----------------+----+----------------+------------+------------+'
  nLin  ++
  nSequ := 0

  select( cCotaTMP )
  set order    to 1
  set relation to Prod into ProdARQ
  dbgotop()
  do while !eof()
    @ nLin,001 say '|'
    @ nLin,003 say Prod           pict '999999' 
    @ nLin,010 say '|'
    if Prod == '999999' 
      @ nLin,012 say left( Produto, 50 )
    else      
      @ nLin,012 say left( ProdARQ->Nome, 50 ) 
    endif     
    @ nLin,065 say '|'
    @ nLin,067 say left( ProdARQ->Refe, 15 )             
    @ nLin,083 say '|'
    if Prod == '9999'
      @ nLin,084 say Unid             
    else  
      @ nLin,084 say ProdARQ->Unid             
    endif  
    @ nLin,088 say '|'
    if EmprARQ->Inteira == "X"
      @ nLin,090 say Qtde                   pict '@E 99999999999999'
    else  
      @ nLin,090 say Qtde                   pict '@E 99,999,999.999'
    endif  
    @ nLin,105 say '|'
    @ nLin,107 say '__________'
    @ nLin,118 say '|'
    @ nLin,120 say '__________'
    @ nLin,131 say '|'

    nSequ ++
    nLin  ++
      
    dbskip ()
  enddo  
    
  select CotaARQ

  for nK := 1 to ( 31 - nSequ )
    @ nLin,001 say '|        |                                                      |                |     |                |            |            |'
    nLin ++
  next  
  @ nLin,001 say '+--------+------------------------------------------------------+-----------------+----+----------------+------------+------------+'
  nLin ++
  @ nLin,001 say '| Cond. Pagamento ______________________________________________' 
  @ nLin,109 say 'Sub-Total'
  @ nLin,120 say  '__________'
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '|   Prazo Entrega ______________________________________________' 
  @ nLin,110 say 'Desconto  __________ |'
  nLin ++
  @ nLin,001 say '|        Validade ______________________________________________'
  @ nLin,109 say 'Valor IPI  __________ |'
  nLin ++
  @ nLin,001 say '|  Transportadora ______________________________________________                                          Valor Total  __________ |'
  nLin ++
  @ nLin,001 say '|      Observação _______________________________________________________________________________________________________________ |'
  nLin ++
  @ nLin,001 say '+---------------------------------------------------------------------------------------------------------------------------------+'
  nLin += 3
  @ nLin, 00 say space(01)
  @ nLin, 00 say ' '
  @ nLin, 00 say chr(27) + "@"

  set device to screen

return NIL