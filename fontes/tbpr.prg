//  Leve, Tabela de Preço Produtos
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

function TbPr ()

if NetUse( "ProdARQ", .t. )
  VerifIND( "ProdARQ" )
  
  sOpenProd := .t.
  
  #ifdef DBF_NTX
    set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
  #endif 
else
  sOpenProd := .f.  
endif

if NetUse( "TbPrARQ", .t. )
  VerifIND( "TbPrARQ" )
  
  sOpenTbPr := .t.
  
  #ifdef DBF_NTX
    set index to TbPrIND1
  #endif 
else
  sOpenTbPr := .f.  
endif

if NetUse( "ITbPARQ", .t. )
  VerifIND( "ITbPARQ" )
  
  sOpenITbP := .t.
  
  #ifdef DBF_NTX
    set index to ITbPIND1
  #endif 
else
  sOpenITbP := .f.  
endif

if NetUse( "FornARQ", .t. )
  VerifIND( "FornARQ" )
  
  sOpenForn := .t.

  #ifdef DBF_NTX
    set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
  #endif 
else
  sOpenForn := .f.  
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
nForn        := nSequ       := 0
cForn        := space(04)
dData        := date()
nPrecoCusto  := nSequPrx    := 0
cSequ        := space(02)
cGrup        := cSubG       := space(03)
cProd        := cForn       := space(04)
cPgto        := space(50)
cProduto     := space(40)
aOpcoes      := {}
aArqui       := {}
cTbPrARQ     := CriaTemp(0)
cTbPrIND1    := CriaTemp(1)
cChave       := "Sequ"

aadd( aArqui, { "Sequ",       "C", 004, 0 } )
aadd( aArqui, { "Prod",       "C", 006, 0 } )
aadd( aArqui, { "Produto",    "M", 010, 0 } )
aadd( aArqui, { "PrecoCusto", "N", 015, 6 } )
aadd( aArqui, { "Regi",       "N", 008, 0 } )
aadd( aArqui, { "Novo",       "L", 001, 0 } )
aadd( aArqui, { "Lixo",       "L", 001, 0 } )

dbcreate( cTbPrARQ , aArqui )
   
if NetUse( cTbPrARQ, .f. )
  cTbPrTMP := alias ()
    
  index on &cChave to &cTbPrIND1

  #ifdef DBF_NTX
    set index to &cTbPrIND1
  #endif 
endif
 
Janela ( 01, 02, 21, 76, mensagem( 'Janela', 'TbPr', .f. ), .f. )
setcolor ( CorJanel + ',' + CorCampo )

@ 03,03 say 'Fornecedor' 
@ 04,03 say '  Validade'
@ 06,03 say 'Cond.Pgto.'

@ 08,08 say 'Codigo Nome                                        Preço Custo'
@ 09,02 say chr(195) + replicate( chr(196), 73 ) + chr(180)
@ 09,14 say chr(194)
@ 09,58 say chr(194)

for nY := 10 to 18
  @ nY,14 say chr(179)
  @ nY,58 say chr(179)
next  
  
@ 19,02 say chr(195) + replicate( chr(196), 73 ) + chr(180)
@ 19,14 say chr(193)
@ 19,58 say chr(193)

MostOpcao( 20, 04, 16, 52, 65 ) 
tSnot := savescreen( 00, 00, 24, 79 )
  
select ProdARQ
set relation to Grup into GrupARQ, to Grup + SubG into SubGARQ
set order    to 1

select TbPrARQ
set order to 1
dbgobottom ()

do while .t.
  cStat := cStatAux := space(04)
  restscreen( 00, 00, 23, 79, tSnot )

  Mensagem( 'TbPr','Janela' )
  
  select( cTbPrTMP )
  set order to 1
  zap
  
  select ProdARQ
  set order to 1

  select GrupARQ
  set order to 1

  select FornARQ
  set order to 1
  
  select SubGARQ
  set order to 1

  select ITbPARQ
  set relation to Prod into ProdARQ
  set order    to 1

  select TbPrARQ
  set order    to 1
  set relation to Forn into FornARQ

  MostTbPr ()
  
  if Demo ()
    exit
  endif
  
  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostTbPr'
  cAjuda   := 'TbPr'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()

  @ 03,14 get nForn            pict '999999' valid ValidARQ( 03, 14, "TbPrARQ", "Codigo", "Forn", "Descrição", "Nome", "Forn", "nForn", .t., 6, "Fornecedores", "FornARQ", 40 )
  @ 04,14 get dData            pict '99/99/9999'
  read
  
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC
    exit
  endif

  cForn    := strzero( nForn, 6 )
  cFornAnt := cForn

  //  Verificar existencia das Notas para Incluir ou Alterar
  select TbPrARQ
  set order to 1
  dbseek( cForn + dtos( dData ), .f. )
  if eof()
    cStat    := 'incl'
  else
    cStat := 'alte'
  endif
  
  Mensagem ('TbPr','Janela')
  
  select ITbPARQ
  set order to 1
  dbseek( cForn + dtos( Data ), .t. )
  do while Forn == cForn .and. Data == dData
    nRegi := recno ()
    
    select( cTbPrTMP )
    if AdiReg()
      if RegLock()
        replace Sequ       with ITbPARQ->Sequ
        replace Prod       with ITbPARQ->Prod
        replace Produto    with ITbPARQ->Produto
        replace PrecoCusto with ITbPARQ->PrecoCusto
        replace Regi       with nRegi
        replace Novo       with .f.
        replace Lixo       with .f.
        dbunlock ()
      endif
    endif
    
    select ITbPARQ
    dbskip ()
  enddo
  
  iStatAnt := cStat
  
  select TbPrARQ

  MostTbPr ()
  EntrTbPr ()  
  EntrItTB ()
  
  Confirmar( 20, 04, 16, 52, 65, 3 ) 
    
  if cStat == 'excl'
    EstoTbPr ()
  endif

  if cStat == 'prin'
    ImprTbPr ()
  endif
  
  if cStat == 'loop' .or. lastkey() == K_ESC
    loop
  endif  
  
  cStat := iStatAnt
  
  if cStat == 'incl'
    select TbPrARQ 
    set order to 1
    if AdiReg()
      if RegLock()
        replace Forn      with cFornAnt
        replace Data      with dData
        dbunlock ()
      endif
    endif
  endif  
  
  select TbPrARQ
  
  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Pgto       with cPgto
      dbunlock ()
    endif
  endif

  GravTbPr ()
enddo

if sOpenProd
  select ProdARQ
  close
endif

if sOpenTbPr
  select TbPrARQ
  close
endif

if sOpenForn
  select FornARQ
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

if sOpenITbP
  select ITbPARQ
  close
endif

select( cTbPrTMP )
close
ferase( cTbPrARQ )
ferase( cTbPrIND1 )
#ifdef DBF_CDX
  ferase( left( cTbPrARQ, len( cTbPrARQ ) - 3 ) + 'FPT' )
#endif  
#ifdef DBF_NTX
  ferase( left( cTbPrARQ, len( cTbPrARQ ) - 3 ) + 'DBT' )
#endif  

return NIL

//
// Mostra os dados
//
function MostTbPr()
  setcolor( CorCampo )
  if cStat != 'incl'  
    cForn := Forn    
    nForn := val( Forn )
    dData := Data
  
    @ 03,14 say cForn            pict '999999'
    @ 03,21 say FornARQ->Nome
    @ 04,14 say dData
 endif  
  
  cPgto := Pgto
  nLin  := 10

  @ 06,14 say cPgto
  
  if cStat == 'alte' .or. cStat == space(04)
    setcolor( CorJanel )
    for nG := 1 to 9
      @ nLin, 08 say '      '    
      @ nLin, 15 say space(43)
      @ nLin, 59 say '          '
      nLin ++
    next

    nLin := 10
    
    setcolor( CorJanel )
    select ITbPARQ
    set order to 1
    dbseek( cForn + dtos( dData ), .t. )
    do while Forn == cForn .and. Data == dData
      @ nLin, 08 say Prod                  pict '999999'    
      if Prod == '999999'
        @ nLin, 15 say memoline( Produto, 43, 1 )
      else      
        @ nLin, 15 say ProdARQ->Nome       pict '@S43'
      endif     
      @ nLin, 59 say PrecoCusto            pict PictPreco(10)

      nLin ++
      dbskip ()
      if nLin >= 19
        exit
      endif   
    enddo
    select TbPrARQ
    setcolor( CorCampo )
  else
    setcolor( CorJanel )
    for nG := 1 to 9 
      @ nLin, 08 say '      '    
      @ nLin, 15 say space(43)
      @ nLin, 59 say '          '
      nLin ++
    next
    setcolor( CorCampo )
  endif  
  
  PosiDBF( 01, 76 )
return NIL

//
// Entra os dados
//
function EntrTbPr ()
  setcolor ( CorJanel + ',' + CorCampo )
  @ 06,14 get cPgto           
  read
return NIL    

//
// Entra com os itens 
//
function EntrItTB()
  if lastkey () == K_ESC .or. lastkey () == K_PGDN
    return NIL
  endif

  select( cTbPrTMP )
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

  oColuna:addColumn( TBColumnNew("Código" ,        {|| Prod } ) )
  oColuna:addColumn( TBColumnNew("Nome",        {|| iif( Prod == '999999', memoline( Produto, 43, 1 ), left( ProdARQ->Nome, 43 ) ) } ) )
  oColuna:addColumn( TBColumnNew("Preço Custo", {|| transform( PrecoCusto, PictPreco(10) ) } ) )
            
  lExitRequested := .f.
  lAlterou       := .f.

  oColuna:goBottom()

  do while !lExitRequested
    Mensagem ( 'LEVE','Browse')

    oColuna:forcestable()

    if oColuna:hitTop .and. !empty( Prod )
      oColuna:refreshAll ()
        
      EntrTbPr ()
      
      select( cTbPrTMP )
      loop       
    endif
    
    if (!lAlterou .and. cStat == 'incl' ).or. ( oColuna:hitBottom .and. !empty( Prod ) )
      cTecla := K_INS
    else 
      cTecla := Teclar(0)  
    endif  
    
    do case
      case cTecla == K_DOWN;        oColuna:down()
      case cTecla == K_UP;          oColuna:up()
      case cTecla == K_PGUP;        oColuna:pageUp()
      case cTecla == K_CTRL_PGUP;   oColuna:goTop()
      case cTecla == K_PGDN;        oColuna:pageDown()
      case cTecla == K_CTRL_PGDN;   oColuna:goBottom()
      case cTecla == K_ESC
        if Saindo (lAlterou)
          lExitRequested := .t.
        else  
          lExitRequested := .f.
        endif  
      case cTecla == 46;            lExitRequested := .t.
      case cTecla == K_ENTER;       EntrItTbPr(.f.)
      case cTecla == K_INS
        do while lastkey() != K_ESC    
          EntrItTbPr(.t.)
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
function EntrItTbPr( lAdiciona )
  if lAdiciona 
    if AdiReg()
      if RegLock()
        replace Sequ            with strzero( recno(), 4 )
        replace Novo            with .t.
        replace Lixo            with .f.
        dbunlock ()
      endif
    endif    
    
    dbgobottom ()

    oColuna:goBottom() 
    oColuna:down()
    oColuna:refreshAll()  

    oColuna:forcestable()
      
    Mensagem( 'PedF', 'InclIten' )
  else
    Mensagem( 'PedF','AlteIten' )
  endif  

  cProd       := Prod
  nProd       := val( cProd )
  cProduto    := Produto
  nPrecoCusto := PrecoCusto
  nLin        := 09 + oColuna:rowPos
    
  setcolor( CorCampo )
  if cProd == '999999'
    @ nLin, 15 say memoline( cProduto, 43, 1 )
  else  
    @ nLin, 15 say ProdARQ->Nome         pict '@S43'
  endif  
  
  set key K_UP to UpNota ()
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ nLin, 08 get cProd         pict '@K'            valid ValidProd( nLin, 08, cTbPrTMP, 'tbpr', 0, nPrecoCusto )
  @ nLin, 59 get nPrecoCusto   pict PictPreco(10)   valid VoltaUp ()
  read
     
  set key K_UP to   
     
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
    replace PrecoCusto      with nPrecoCusto
    replace Produto         with cProduto
    dbunlock ()
  endif
  
  lAlterou := .t.
  
  oColuna:refreshCurrent()  
return NIL     

//
// Excluir nota
//
function EstoTbPr ()
  cStat  := 'loop' 
  
  select TbPrARQ

  if ExclRegi ()
    select ITbPARQ
    set order to 1
    dbseek( cForn + dtos( Data ), .t. )
    do while Forn == cForn .and. Data == dData
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif
        
      dbskip ()
    enddo    
    
    select TbPrARQ
  endif
return NIL

//
// Entra o estoque
//
function GravTbPr()
  
  set deleted off

  select( cTbPrTMP )
  set order to 1
  dbgotop ()
  do while !eof ()
    if empty( Prod )
      dbskip ()
      loop
    endif

    nRegi := Regi
    lLixo  := Lixo
    
    if Novo
      if Lixo
        dbskip ()
        loop
      endif

      select ITbPARQ
      if AdiReg()
        if RegLock()
          replace Forn       with cForn
          replace Data       with dData
          replace Sequ       with &cTbPrTMP->Sequ
          replace Prod       with &cTbPrTMP->Prod
          replace Produto    with &cTbPrTMP->Produto
          replace PrecoCusto with &cTbPrTMP->PrecoCusto
          dbunlock ()
        endif
      endif
    else
      select ITbPARQ
      go nRegi
      
      if RegLock()
        replace Prod          with &cTbPrTMP->Prod
        replace Produto       with &cTbPrTMP->Produto
        replace PrecoCusto    with &cTbPrTMP->PrecoCusto
        dbunlock ()
      endif

      if lLixo
        if RegLock()
          dbdelete ()
          dbunlock ()
       endif
      endif
    endif

    select( cTbPrTMP )
    dbskip ()
  enddo

  set deleted on
  
  select TbPrARQ
return NIL

//
// Imprimir Cotacao
//
function ImprTbPr ( lTipo )

  if !TestPrint(1)
    return NIL
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )
  
  setprc( 0, 0 )
  
  @ 00, 00 say ' '
  @ 00, 00 say chr(27) + "@"
  @ 00, 00 say chr(15)

  nLin  := 0
  
  @ nLin,002 say '+---------------------------------------------------------------------------------------------------------------------------------+'    
  nLin ++ 
  @ nLin,001 say '| ' + FornARQ->Nome 
  @ nLin,131 say '|'
  nLin ++ 
  @ nLin,001 say '| ' + FornARQ->Ende
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '| ' + transform( FornARQ->CEP, '99999-999' ) + '   ' + left( FornARQ->Bairro, 15 ) + '   ' + alltrim( FornARQ->Cida ) + '/' + FornARQ->UF
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '| ' + FornARQ->Fone + '     ' + FornARQ->Fax                     
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '| '
  @ nLin,003 say FornARQ->CGC                     pict '@R 99.999.999/9999-99'
  @ nLin,026 say FornARQ->InscEstd                
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '+---------------------------------------------------------------------------------------------------------------------------------+'    
  nLin ++
  @ nLin,001 say '+--------+-----------------------------------------------------------------------------------------------------------+------------+'
  nLin ++
  @ nLin,001 say '| Codigo | Descrição dos Produtos                                                                                    |   P. Custo |'
  nLin ++
  @ nLin,001 say '+--------+-----------------------------------------------------------------------------------------------------------+------------+'
  nLin  ++
  nSequ := 0

  select( cTbPrTMP )
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
    @ nLin,118 say '|'
    @ nLin,120 say PrecoCusto     pict PictPreco(10)
    @ nLin,131 say '|'

    nSequ ++
    nLin  ++
      
    dbskip ()
  enddo  
    
  select TbPrARQ

  for nK := 1 to ( 31 - nSequ )
    @ nLin,001 say '|        |                                                                                                           |            |'
    nLin ++
  next  
  @ nLin,001 say '+--------+-----------------------------------------------------------------------------------------------------------+------------+'
  nLin += 4
  @ nLin, 00 say space(01)
  @ nLin, 00 say ' '
  @ nLin, 00 say chr(27) + "@"

  set device to screen

return NIL