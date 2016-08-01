//  Leve, Composição de Produtos
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

function CoPr ()

if NetUse( "ProdARQ", .t. )
  VerifIND( "ProdARQ" )
  
  eOpenProd := .t.
  
  #ifdef DBF_NTX
    set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
  #endif  
else
  eOpenProd := .f.  
endif

if NetUse( "CoPrARQ", .t. )
  VerifIND( "CoPrARQ" )
  
  eOpenCoPr := .t.
  
  #ifdef DBF_NTX
    set index to CoPrIND1, CoPrIND2
  #endif  
else
  eOpenOPro := .f.  
endif

if NetUse( "CustARQ", .t. )
  VerifIND( "CustARQ" )
  
  eOpenCust := .t.
  
  #ifdef DBF_NTX
    set index to CustIND1, CustIND2
  #endif  
else
  eOpenOPro := .f.  
endif

if NetUse( "ICoPARQ", .t. )
  VerifIND( "ICoPARQ" )
  
  eOpenICoP := .t.
  
  #ifdef DBF_NTX
    set index to ICoPIND1
  #endif  
else
  eOpenIOPr := .f.  
endif

if NetUse( "CuPrARQ", .t. )
  VerifIND( "CuPrARQ" )
  
  eOpenCuPr := .t.
  
  #ifdef DBF_NTX
    set index to CuPrIND1
  #endif  
else
  eOpenIOPr := .f.  
endif

if NetUse( "ICusARQ", .t. )
  VerifIND( "ICusARQ" )
  
  eOpenICus := .t.
  
  #ifdef DBF_NTX
    set index to ICusIND1
  #endif  
else
  eOpenICus := .f.  
endif

//  Variaveis para Entrada de dados
nNota        := nQtde       := 0
cNota        := cNotaNew    := space(06)
dEmis        := date()
nSequ        := nProd       := nPedido    := 0
nTotalNota   := nPrecoTotal := nPerC      := 0
nPrecoVenda  := nSequPrx    := nQtdeAnt   := 0
cSequ        := space(02)
cProd        := cHist       := dProd      := space(04)

aOpcoes      := {}
aArqui       := {}
cCoPrARQ     := CriaTemp(0)
cCoPrIND1    := CriaTemp(1)
cChave       := "Sequ"

aadd( aArqui, { "Sequ",       "C", 004, 0 } )
aadd( aArqui, { "Prod",       "C", 006, 0 } )
aadd( aArqui, { "PerC",       "N", 012, 3 } )
aadd( aArqui, { "Qtde",       "N", 012, 3 } )
aadd( aArqui, { "Regi",       "N", 008, 0 } )
aadd( aArqui, { "Novo",       "L", 001, 0 } )
aadd( aArqui, { "Lixo",       "L", 001, 0 } )

dbcreate( cCoPrARQ, aArqui )
   
if NetUse( cCoPrARQ, .f. )
  cCoPrTMP := alias ()
    
  index on &cChave to &cCoPrIND1

  #ifdef DBF_NTX
  set index to &cCoPrIND1
  #endif  
endif

aOpcoes      := {}
aArqui       := {}
cCustARQ     := CriaTemp(0)
cCustIND1    := CriaTemp(1)
cChave       := "Sequ"

aadd( aArqui, { "Sequ",       "C", 004, 0 } )
aadd( aArqui, { "Cust",       "C", 006, 0 } )
aadd( aArqui, { "PrecoCusto", "N", 015, 6 } )
aadd( aArqui, { "PrecoVenda", "N", 015, 6 } )
aadd( aArqui, { "PerC",       "N", 012, 3 } )
aadd( aArqui, { "Regi",       "N", 008, 0 } )
aadd( aArqui, { "Novo",       "L", 001, 0 } )
aadd( aArqui, { "Lixo",       "L", 001, 0 } )

dbcreate( cCustARQ, aArqui )
   
if NetUse( cCustARQ, .f. )
  cCustTMP := alias ()
    
  index on &cChave to &cCustIND1

  #ifdef DBF_NTX
  set index to &cCustIND1
  #endif  
endif
 
Janela ( 02, 07, 21, 71, mensagem( 'Janela', 'CoPr', .f. ), .t. )
setcolor ( CorJanel + ',' + CorCampo )

@ 04,09 say 'Composição                             Data'
@ 06,09 say '   Produto' 

@ 08,11 say 'Código Descrição                         Perc.  Qtde.'
@ 09,07 say chr(195) + replicate( chr(196), 63 ) + chr(180)
@ 09,17 say chr(194)
@ 09,51 say chr(194)
@ 09,58 say chr(194)

for nY := 10 to 18
  @ nY,17 say chr(179)
  @ nY,51 say chr(179)
  @ nY,58 say chr(179)
next  
  
@ 19,17 say chr(193)
@ 19,51 say chr(193)
@ 19,58 say chr(193)
   
MostGeral( 20, 09, 21, 34, 47, 60, ' Custos ', 'u', 3 ) 
tSnot := savescreen( 00, 00, 24, 79 )

select CoPrARQ
set order to 1
dbgobottom ()

do while .t.
  Mensagem( 'CoPr','Janela')
 
  cStat := cStatAux := space(04)
  restscreen( 00, 00, 23, 79, tSnot )
  
  select( cCoPrTMP )
  set order to 1
  zap
  
  select( cCustTMP )
  set order to 1
  zap
  
  select ProdARQ
  set order to 1
  
  select ICoPARQ
  set relation to Prod into ProdARQ
  set order    to 1

  select CoPrARQ
  set order    to 1

  MostCoPr ()
  
  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostCoPr'
  cAjuda   := 'CoPr'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()

  @ 04,20 get nNota            pict '999999'
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
  setcolor( CorCampo )
  @ 04,20 say cNota            pict '999999'

  //  Verificar existencia das Notas para Incluir ou Alterar
  select CoPrARQ
  set order to 1
  dbseek( cNota, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif

  Mensagem ('CoPr',cStat)
  
  select ICoPARQ
  set order to 1
  dbseek( cNota, .t. )
  do while Nota == cNota
    nRegi := recno ()
    
    select( cCoPrTMP )
    if AdiReg()
      if RegLock()
        replace Sequ       with ICoPARQ->Sequ
        replace Prod       with ICoPARQ->Prod
        replace PerC       with ICoPARQ->PerC
        replace Qtde       with ICoPARQ->Qtde
        replace Regi       with nRegi
        replace Novo       with .f.
        replace Lixo       with .f.
        dbunlock ()
      endif
    endif
    
    select ICoPARQ
    dbskip ()
  enddo
  
  select ICusARQ
  set order to 1
  dbseek( cNota, .t. )
  do while Nota == cNota .and. !eof()
    nRegi := recno ()
    
    select( cCustTMP )
    if AdiReg()
      if RegLock()
        replace Sequ       with ICusARQ->Sequ
        replace Cust       with ICusARQ->Cust
        replace PerC       with ICusARQ->PerC 
        replace PrecoCusto with ICusARQ->PrecoCusto
        replace PrecoVenda with ICusARQ->PrecoVenda
        replace Regi       with nRegi
        replace Novo       with .f.
        replace Lixo       with .f.
        dbunlock ()
      endif
    endif
    
    select ICusARQ
    dbskip ()
  enddo
  
  cStatAnt := cStat
  
  select CoPrARQ

  MostCoPr ()
  EntrCoPr ()  
  EntrItCP ()
  
  ConfGeral( 20, 09, 21, 34, 47, 60, ' Custos ', 'u', 3, 4 )
  
  if cStat == 'gene'
    EntrCuCP ()
    
    if lastkey() != K_ESC
      ConfGeral( 20, 09, 21, 34, 47, 60, ' Custos ', 'u', 3, 4 )
    endif  
  endif  
    
  if cStat == 'loop' .or. lastkey() == K_ESC
    loop
  endif  

  if cStat == 'prin'
  //  PrinCoPr ()
  endif
    
  if cStat == 'excl'
    EstoCoPr ()
  endif
  
  if cStatAnt == 'incl'
    if nNota == 0
      select EmprARQ
     
      nNotaNew := CoPr + 1
      cNotaNew := strzero( nNotaNew, 6 )
     
      if RegLock()
        replace CoPr       with nNotaNew
        dbunlock ()
      endif  
    endif  
  endif  

  select CoPrARQ 

  if cStatAnt == 'incl'
    if AdiReg()
      if RegLock()
        replace Nota       with cNotaNew
        dbunlock ()
      endif
    endif
  endif  

  select ProdARQ
  set order to 1
  dbseek( dProd, .f. )
  
  select CoPrARQ
  
  if cStatAnt == 'alte' .or. cStatAnt == 'incl'
    if RegLock()
      replace Prod       with dProd
      replace Desc       with ProdARQ->Nome
      replace Emis       with dEmis
      replace Hist       with cHist
      dbunlock ()
    endif
  endif

  GravCoPr ()

  if nNota == 0
    Alerta( mensagem( 'Alerta', 'CoPr', .f. ) + ' ' + cNotaNew )
  endif  
enddo

if eOpenICus
  select ICusARQ
  close
endif

if eOpenProd
  select ProdARQ
  close
endif

if eOpenCust
  select CustARQ
  close
endif

if eOpenCoPr
  select CoPrARQ
  close
endif

if eOpenICoP
  select ICoPARQ
  close
endif

if eOpenCuPr
  select CuPrARQ
  close
endif

select( cCoPrTMP )
close
ferase( cCoPrARQ )
ferase( cCoPrIND1 )

return NIL

//
// Mostra os dados
//
function MostCoPr()

  select CoPrARQ

  if cStat != 'incl'  
    cNota := Nota    
    nNota := val( Nota )
  endif  
 
  cNotaNew := cNota   
  dEmis    := Emis  
  cHist    := Hist
  cProd    := Prod
  dProd    := Prod
  nProd    := val( Prod )
  nLin     := 10
  
  select ProdARQ
  set order to 1
  dbseek( dProd, .f. )
  
  select CoPrARQ
  
  setcolor( CorCampo )
  @ 04,53 say dEmis              pict '99/99/9999'
  @ 06,20 say dProd              pict '999999'
  @ 06,27 say ProdARQ->Nome      pict '@S40'
  
  if cStat == 'alte' .or. cStat == space(04)
    setcolor( CorJanel )
    for nG := 1 to 9  
      @ nLin, 11 say '      '    
      @ nLin, 18 say space(33)
      @ nLin, 52 say space(05)
      @ nLin, 59 say space(09)
      nLin ++
    next

    nLin := 10

    setcolor( CorJanel )
    select ICoPARQ
    set order to 1
    dbseek( cNota, .t. )
    do while Nota == cNota
      @ nLin, 11 say Prod                  pict '999999'    
      @ nLin, 18 say ProdARQ->Nome         pict '@S33'
      @ nLin, 52 say PerC                  pict '@E 999.99'
      if EmprARQ->Inteira == "X"
        @ nLin, 59 say Qtde                pict '@E 999999999'
      else          
        @ nLin, 59 say Qtde                pict '@E 9,999.999'
      endif  

      nLin ++
      dbskip ()
      if nLin >= 19
        exit
      endif   
    enddo
  else
    nLin := 10

    setcolor( CorJanel )
    for nG := 1 to 9  
      @ nLin, 11 say '      '    
      @ nLin, 18 say space(33)
      @ nLin, 52 say space(05)
      @ nLin, 59 say space(09)
      nLin ++
    next
  endif 
  
  select CoPrARQ 
  
  PosiDBF( 02, 71 )
return NIL

//
// Entra os dados
//
function EntrCoPr ()
  if cStat == 'incl'
    dEmis := date()
  endif  
   
  setcolor ( CorJanel + ',' + CorCampo )
  @ 04,53 get dEmis           pict '99/99/9999'
  @ 06,20 get nProd           pict '999999' valid ValidProd( 06, 20, "CoPrARQ", 'copr', 0, 0 )
  read
  
  dProd := strzero( nProd, 6 )
return NIL    

//
// Entra com os itens 
//
function EntrItCP()
  if lastkey() == K_ESC .or. lastkey() == K_PGDN
    return NIL
  endif 

  select( cCoPrTMP )
  set order    to 1
  set relation to Prod into ProdARQ

  bFirst := {|| dbseek( '0001', .t. ) }
  bLast  := {|| dbseek( '9999', .t. ), dbskip(-1) }
  bFor   := {|| .t. }
  bWhile := {|| .t. }

  oCompos         := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oCompos:nTop    := 8
  oCompos:nLeft   := 9
  oCompos:nBottom := 19
  oCompos:nRight  := 70
  oCompos:headsep := chr(194)+chr(196)
  oCompos:colsep  := chr(179)
  oCompos:footsep := chr(193)+chr(196)

  oCompos:addColumn( TBColumnNew("Código" ,     {|| Prod } ) )
  oCompos:addColumn( TBColumnNew("Descrição",   {|| left( ProdARQ->Nome, 33 ) } ) )
  oCompos:addColumn( TBColumnNew("Perc.",       {|| transform( PerC, '@E 999.99' ) } ) )
  if EmprARQ->Inteira == "X"
    oCompos:addColumn( TBColumnNew("Qtde.",       {|| transform( Qtde, '@E 999999999' ) } ) )
  else          
    oCompos:addColumn( TBColumnNew("Qtde.",       {|| transform( Qtde, '@E 9,999.999' ) } ) )
  endif  
  lExitRequested := .f.
  lAdiciona      := .f.
  lAltera        := .f.
  cSequ          := space(04)
  nSequ          := 0
  nLin           := 9

  oCompos:goBottom()

  do while !lExitRequested
    Mensagem ( 'LEVE','CoPr')
 
    oCompos:forcestable()
   
    if cSequ == space(04) .and. cStat == 'incl'
      cTecla := K_INS
    else  
      cTecla := Teclar(0)
    endif  

    if oCompos:hitTop
      oCompos:refreshAll ()
      
      EntrCoPr ()      

      select( cCoPrTMP )
      loop
    endif

    if oCompos:hitTop .or. oCompos:hitBottom
      tone( 125, 0 )
    endif

    do case
      case cTecla == K_DOWN;        oCompos:down()
      case cTecla == K_UP;          oCompos:up()
      case cTecla == K_PGUP;        oCompos:pageUp()
      case cTecla == K_CTRL_PGUP;   oCompos:goTop()
      case cTecla == K_PGDN;        oCompos:pageDown()
      case cTecla == K_CTRL_PGDN;   oCompos:goBottom()
      case cTecla == K_ESC;         lExitRequested := .t.
      case cTecla == 46;            lExitRequested := .t.
        if lastkey() != K_ESC .or. lastkey() != K_PGDN
          Janela( 05, 12, 14, 65, mensagem( 'Janela', 'CoPr1', .f. ), .f. )
          Mensagem( 'CoPr', 'EntrItCP' ) 
          
          setcolor( CorCampo )     
          cHist := memoedit( cHist, 07, 14, 13, 63, .t., "OutProd" )
        endif  
      case cTecla == K_ENTER
        if !empty( Sequ )
          lAdiciona := .f.
        
          EntrItCoPr( lAdiciona, oCompos, nLin )
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
          
          EntrItCoPr( lAdiciona, oCompos, nLin )
          
          if lExitRequested
            Janela( 05, 12, 14, 65, mensagem( 'Janela', 'CoPr1', .f. ), .f. )
            Mensagem( 'CoPr', 'EntrItCP' ) 
          
            setcolor( CorCampo )     
  
            cHist := memoedit( cHist, 07, 14, 13, 63, .t., "OutProd" )
    
            exit
          endif  
        enddo  
      case cTecla == K_DEL
        if RegLock()
          replace Lixo      with .t.  
            
          dbdelete ()
          dbunlock ()
    
          oCompos:refreshAll()  
          oCompos:gotop ()
        endif  
    endcase
  enddo
return NIL  

//
// Entra intens da nota
//
function EntrItCoPr( lAdiciona, oCompos, nLin )
  if lAdiciona 
    cSequ := strzero( nSequ + 1, 4 )
    xPerc := 0
      
    if AdiReg()
      if RegLock()
        replace Sequ            with cSequ
        replace Novo            with .t.
        replace Lixo            with .f.
        dbunlock ()
      endif
    endif    
    dbgotop ()
    do while !eof ()
      xPerc += Perc
      dbskip ()
    enddo  
    
    if xPerc >= 100
      lExitRequested := .t.

      return NIL
    endif  
    
    dbgobottom ()

    oCompos:goBottom() 
    oCompos:refreshAll()  

    oCompos:forcestable()

    Mensagem( 'PedF','InclIten')
  else
    Mensagem( 'PedF','AlteIten')
  endif  

  cSequ   := Sequ
  nSequ   := val( Sequ )
  cProd   := Prod
  nProd   := val( cProd )
  nQtde   := Qtde
  if nQtdeAnt == 0
    nPerc := iif( lAdiciona, 100 - xPerc, Perc )
  endif  
  nPerc   := iif( nPerc < 0 .or. nPerc == 100, 0, nPerc )
  
  nLin    := 09 + oCompos:rowPos
    
  setcolor( CorCampo )
  @ nLin, 18 say ProdARQ->Nome         pict '@S33'
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ nLin, 11 get cProd         pict '@K'            valid ValidProd( nLin, 11, cCoPrTMP, 'copr', 0, 0 )
  @ nLin, 52 get nPerC         pict '@E 999.99'
  if EmprARQ->Inteira == "X"
    @ nLin, 59 get nQtde       pict '@E 999999999'
  else          
    @ nLin, 59 get nQtde       pict '@E 9,999.999'
  endif  
  read
  
  if lastkey () == K_ESC
    if lAdiciona
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif  
    endif  

    oCompos:refreshCurrent()  
    oCompos:goBottom()
    return NIL
  endif  
  
  if RegLock()
    replace Prod            with cProd
    replace PerC            with nPerC
    replace Qtde            with nQtde
    replace Lixo            with .f.
    dbunlock ()
  endif
  
  nQtdeAnt := nQtde
  
  oCompos:refreshCurrent()  
return NIL     

//
// Funcao Entra com os custos dos Composicao
// 
function EntrCuCP( pTipo )

  tVerCust := savescreen( 00, 00, 24, 79 )
  lOk      := .f.
  lMuda    := .f.
  cFile    := alias()
 
  setcolor ( CorCampo )
  
  Janela( 05, 12, 17, 66, mensagem( 'Janela', 'EntrCuCP', .f. ), .f. )  
  setcolor( CorJanel + ',' + CorCampo )

  select( cCustTMP )
  set order    to 1
  set relation to Cust into CustARQ

  bFirst := {|| dbseek( '0001', .t. ) }
  bLast  := {|| dbseek( '9999', .t. ), dbskip(-1) }
  bWhile := {|| .t. }
  bFor   := {|| .t. }

  oCustos          := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oCustos:nTop     := 7
  oCustos:nLeft    := 13
  oCustos:nBottom  := 17
  oCustos:nRight   := 65
  oCustos:headsep  := chr(194)+chr(196)
  oCustos:colsep   := chr(179)
  oCustos:footsep  := chr(193)+chr(196)
 
  oCustos:addColumn( TBColumnNew( 'Código',{|| Cust } ) )
  oCustos:addColumn( TBColumnNew( 'Nome',  {|| left( CustARQ->Nome, 28 ) } ) )
  oCustos:addColumn( TBColumnNew( 'Perc.', {|| transform( PerC, '@E 999.99' ) } ) )
  oCustos:addColumn( TBColumnNew( 'Valor', {|| transform( PrecoVenda, PictPreco(10) ) } ) )
  
  oCustos:goTop ()

  oCustos:colpos := 1
  lExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ''
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 08, 17, 66, nTotal )

  setcolor( CorJanel + ',' + CorCampo )
  @ 08,12 say chr(195)
   
  do while !lExitRequested
    Mensagem( 'LEVE','Browse')

    oCustos:forcestable()

    iif( BarraSeta, BarraSeta( nLinBarra, 08, 17, 66, nTotal ), NIL )
    
    PosiDBF( 05, 66 )

    if oCustos:stable
      if oCustos:hitTop .or. oCustos:hitBottom
        tone( 125, 0 )        
      endif  
      
      cTecla := Teclar(0)
    endif
       
    do case
      case cTecla == K_DOWN .or. cTecla == K_PGDN .or. cTecla == K_CTRL_PGDN
        if !oCustos:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif
        endif
      case cTecla == K_UP .or. cTecla == K_PGUP .or. cTecla == K_CTRL_PGUP
        if !oCustos:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif
        endif
    endcase
      
    do case
      case cTecla == K_DOWN;       oCustos:down()
      case cTecla == K_UP;         oCustos:up()
      case cTecla == K_PGDN;       oCustos:pageDown()
      case cTecla == K_PGUP;       oCustos:pageUp()
      case cTecla == K_CTRL_PGUP;  oCustos:goTop()
      case cTecla == K_CTRL_PGDN;  oCustos:goBottom()
      case cTecla == K_ESC;        lExitRequested := .t. 
      case cTecla == 46;           lExitRequested := .t. 
      case cTecla == K_ENTER
        if !empty( Sequ )
          lAdiciona := .f.
        
          EntrItCust( lAdiciona, oCustos )
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
          
          EntrItCust( lAdiciona, oCustos )
        enddo  
      case cTecla == K_DEL
        if RegLock()
          replace Lixo      with .t.  
            
          dbdelete ()
          dbunlock ()
    
          oCustos:refreshAll()  
          oCustos:gotop ()
        endif  

    endcase
  enddo
  
  restscreen( 00, 00, 24, 79, tVerCust )
  
  setcolor ( CorJanel + ',' + CorCampo )
return(.t.)

//
// Entra intens da nota
//
function EntrItCust( lAdiciona, oCustos )
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

    oCustos:goBottom() 
    oCustos:refreshAll()  

    oCustos:forcestable()

    Mensagem( 'CoPr', 'ItCustIncl' )
  else
    Mensagem( 'CoPr', 'ItCustAlte' )
  endif  

  cSequ       := Sequ
  nSequ       := val( Sequ )
  cCust       := Cust
  nCust       := val( cCust )
  nPrecoVenda := PrecoVenda
  nPrecoCusto := PrecoCusto
  nPerC       := PerC
  
  nLin  := 08 + oCustos:rowPos
    
  setcolor( CorCampo )
  @ nLin, 18 say CustARQ->Nome         pict '@S30'
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ nLin, 13 get nCust         pict '999999'          valid ValidARQ( nLin, 13, cCustTMP, "Código" , "Cust", "Descrição", "Nome", "Cust", "nCust", .t., 6, "Consulta de Custos", "CustARQ" )
  @ nLin, 49 get nPerC         pict '@E 999.99'
  @ nLin, 56 get nPrecoVenda   pict PictPreco(10)
  read
  
  select( cCustTMP )

  if lastkey () == K_ESC
    if lAdiciona
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif  
    endif  

    oCustos:refreshCurrent()  
    oCustos:goBottom()
    return NIL
  endif  
  
  if RegLock()
    replace Cust            with strzero( nCust, 6 )
    replace PrecoVenda      with nPrecoVenda
    replace PerC            with nPerC
    replace Lixo            with .f.
    dbunlock ()
  endif
  
  oCustos:refreshCurrent()  
return NIL     

//
// Excluir nota
//
function EstoCoPr ()
  cStat  := 'loop' 
  lEstq  := .f.
  
  select CoPrARQ

  if ExclRegi ()
    select ICoPARQ
    set order to 1
    dbseek( cNota, .t. )
    do while Nota == cNota .and. !eof()
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif
      dbskip ()
    enddo    

    select ICusARQ
    set order to 1
    dbseek( cNota, .t. )
    do while Nota == cNota .and. !eof()
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif
      dbskip ()
    enddo    
    
    select CoPrARQ
  endif
return NIL

//
// Entra o estoque
//
function GravCoPr()
  
  set deleted off   
    
  select( cCoPrTMP )
  set order to 1 
  dbgotop ()
  do while !eof ()
    if empty( Prod )
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
    
      select ICoPARQ
      if AdiReg()
        if RegLock()
          replace Nota       with cNotaNew
          replace Sequ       with &cCoPrTMP->Sequ
          replace Prod       with &cCoPrTMP->Prod
          replace PerC       with &cCoPrTMP->PerC
          replace Qtde       with &cCoPrTMP->Qtde
          dbunlock ()
        endif
      endif   
    else 
      select ICoPARQ
      go nRegi
          
      if RegLock()
        replace Prod       with &cCoPrTMP->Prod
        replace PerC       with &cCoPrTMP->PerC
        replace Qtde       with &cCoPrTMP->Qtde
        dbunlock ()
      endif  

      if lLixo
        if RegLock()
          dbdelete ()
          dbunlock ()
        endif
      endif
    endif 
      
    select( cCoPrTMP )
    dbskip ()
  enddo  

  select( cCustTMP )
  set order to 1 
  dbgotop ()
  do while !eof ()
    if empty( Cust )
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
    
      select ICusARQ
      if AdiReg()
        if RegLock()
          replace Nota       with cNotaNew
          replace Sequ       with &cCustTMP->Sequ
          replace Cust       with &cCustTMP->Cust
          replace PerC       with &cCustTMP->PerC
          replace PrecoVenda with &cCustTMP->PrecoVenda
          replace PrecoCusto with &cCustTMP->PrecoCusto
          dbunlock ()
        endif
      endif   
    else 
      select ICusARQ
      go nRegi
          
      if RegLock()
        replace Cust       with &cCustTMP->Cust
        replace PerC       with &cCustTMP->PerC
        replace PrecoVenda with &cCustTMP->PrecoVenda
        replace PrecoCusto with &cCustTMP->PrecoCusto
        dbunlock ()
      endif  

      if lLixo
        if RegLock()
          dbdelete ()
          dbunlock ()
        endif
      endif
    endif 
      
    select( cCustTMP )
    dbskip ()
  enddo  
   
  set deleted on
  
  select CoPrARQ
return NIL