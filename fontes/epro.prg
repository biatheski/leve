//  Leve, Entrada Alternativa
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

function EPro ()

if NetUse( "EstqARQ", .t. )
  VerifIND( "EstqARQ" )
  
  eOpenEstq := .t.

  #ifdef DBF_NTX
    set index to EstqIND1, EstqIND2
  #endif  
else
  eOpenEstq := .f.
endif

if NetUse( "ProdARQ", .t. )
  VerifIND( "ProdARQ" )
  
  eOpenProd := .t.
  
  #ifdef DBF_NTX
    set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
  #endif  
else
  eOpenProd := .f.  
endif

if NetUse( "EProARQ", .t. )
  VerifIND( "EProARQ" )
  
  eOpenEPro := .t.
  
  #ifdef DBF_NTX
    set index to EProIND1
  #endif  
else
  eOpenOPro := .f.  
endif

if NetUse( "IEPrARQ", .t. )
  VerifIND( "IEPrARQ" )
  
  eOpenIEPr := .t.
  
  #ifdef DBF_NTX
  set index to IEPrIND1
    #endif  
else
  eOpenIOPr := .f.  
endif

//  Variaveis para Entrada de dados
nNota        := nQtde       := 0
cNota        := cNotaNew    := space(06)
dEmis        := date()
nSequ        := nEstq       := 0
nTotalNota   := nPrecoTotal := 0
nPrecoCusto  := nSequPrx    := 0
cSequ        := cEstq       := space(02)
cProd        := eObse       := cProduto := space(04)

aOpcoes      := {}
aArqui       := {}
cEProARQ     := CriaTemp(0)
cEProIND1    := CriaTemp(1)
cChave       := "Sequ"

aadd( aArqui, { "Sequ",       "C", 004, 0 } )
aadd( aArqui, { "Prod",       "C", 006, 0 } )
aadd( aArqui, { "Produto",    "M", 010, 0 } )
aadd( aArqui, { "Qtde",       "N", 012, 3 } )
aadd( aArqui, { "PrecoCusto", "N", 015, 6 } )
aadd( aArqui, { "Regi",       "N", 008, 0 } )
aadd( aArqui, { "Novo",       "L", 001, 0 } )
aadd( aArqui, { "Lixo",       "L", 001, 0 } )

dbcreate( cEProARQ, aArqui )
   
if NetUse( cEProARQ, .f. )
  cEProTMP := alias ()
    
  #ifdef DBF_CDX  
    index on &cChave tag &cEProIND1
  #endif

  #ifdef DBF_NTX
    index on &cChave to &cEProIND1
  
    set index to &cEProIND1
  #endif  
endif
 
Janela ( 01, 02, 21, 76, mensagem( 'Janela', 'EPro', .f. ), .t. )
setcolor ( CorJanel + ',' + CorCampo )

@ 03,03 say '    Entrada                                 Emissão'
@ 05,03 say '   Operação'
@ 06,03 say ' Observação'

@ 08,05 say 'Codigo Nome                         Qtde.     Preço Custo Preco Total'
@ 09,02 say chr(195) + replicate( chr(196), 73 ) + chr(180)
@ 09,11 say chr(194)
@ 09,40 say chr(194)
@ 09,50 say chr(194)
@ 09,62 say chr(194)

for nY := 10 to 16
  @ nY,11 say chr(179)
  @ nY,40 say chr(179)
  @ nY,50 say chr(179)
  @ nY,62 say chr(179)
next  
  
@ 17,02 say chr(195) + replicate( chr(196), 73 ) + chr(180)
@ 17,11 say chr(193)
@ 17,40 say chr(193)
@ 17,50 say chr(193)
@ 17,62 say chr(193)
   
@ 18,47 say 'Total Entrada'

MostOpcao( 20, 04, 16, 52, 65 ) 
tSnot := savescreen( 00, 00, 24, 79 )

select EProARQ
set order to 1
dbgobottom ()

do while .t.
  Mensagem( 'EPro','Janela')
 
  cStat := cStatAux := space(04)
  restscreen( 00, 00, 23, 79, tSnot )
  
  select( cEProTMP )
  set order to 1
  zap
  
  select EstqARQ
  set order to 1
  
  select ProdARQ
  set order to 1

  select IEPrARQ
  set relation to Prod into ProdARQ
  set order    to 1

  select EProARQ
  set order    to 1
  set relation to Estq into EstqARQ

  MostEPro ()
  
  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostEPro'
  cAjuda   := 'EPro'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()

  @ 03,15 get nNota            pict '999999'
  read
  
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC
    exit
  endif

  cNota := strzero( nNota, 6 )
  setcolor( CorCampo )
  @ 03,15 say cNota            pict '999999'

  //  Verificar existencia das Notas para Incluir ou Alterar
  select EProARQ
  set order to 1
  dbseek( cNota, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif

  Mensagem ('EPro',cStat )
  
  select IEPrARQ
  set order to 1
  dbseek( cNota, .t. )
  do while Nota == cNota
    nRegi := recno ()
    
    select( cEProTMP )
    if AdiReg()
      if RegLock()
        replace Sequ       with IEPrARQ->Sequ
        replace Prod       with IEPrARQ->Prod
        replace Produto    with IEPrARQ->Produto
        replace Qtde       with IEPrARQ->Qtde
        replace PrecoCusto with IEPrARQ->PrecoCusto
        replace Regi       with nRegi
        replace Novo       with .f.
        replace Lixo       with .f.
        dbunlock ()
      endif
    endif
    
    select IEPrARQ
    dbskip ()
  enddo
  
  cStatAnt := cStat
  
  select EProARQ

  MostEPro ()
  EntrEPro ()  
  EntrItEP ()
  
  Confirmar( 20, 04, 16, 52, 65, 3 ) 
  
  if cStat == 'loop'
    loop
  endif  

  if cStat == 'prin'
    PrinEPro (.f.)
  endif
    
  if cStat == 'excl'
    EstoEPro ()
  endif
  
  if cStat == 'loop'
    loop
  endif  
  
  if cStatAnt == 'incl'
    if nNota == 0
      select EmprARQ
      set order to 1
      dbseek( cEmpresa, .f. )
     
      nNotaNew := EPro + 1
      
      do while .t.
        cNotaNew := strzero( nNotaNew, 6 )
        
        EproARQ->( dbseek( cNotaNew, .f. ) )
        
        if EproARQ->( found () )
          nNotaNew ++
          loop
        else    
          select EmprARQ
          if RegLock()
            replace EPro       with nNotaNew
            dbunlock ()
          endif
          exit
        endif    
      enddo  
    endif  
  endif  

  select EProARQ 

  if cStatAnt == 'incl'
    if AdiReg()
      if RegLock()
        replace Nota       with cNotaNew
        dbunlock ()
      endif
    endif
  endif  
  
  if cStatAnt == 'alte' .or. cStatAnt == 'incl'
    if RegLock()
      replace Emis       with dEmis
      replace Estq       with cEstq
      replace Obse       with eObse
      replace TotalNota  with nTotalNota
      dbunlock ()
    endif
  endif

  GravEPro ()

  if nNota == 0
    Alerta( mensagem( 'Alerta', 'EPro', .f. ) + ' ' + cNotaNew )
  endif  
enddo

if eOpenEstq
  select EstqARQ
  close
endif

if eOpenProd
  select ProdARQ
  close
endif

if eOpenEPro
  select EProARQ
  close
endif

if eOpenIEPr
  select IEPrARQ
  close
endif

select( cEProTMP )
close
ferase( cEProARQ )
ferase( cEProIND1 )
#ifdef DBF_CDX
  ferase( left( cEProARQ, len( cEProARQ ) - 3 ) + 'FPT' )
#endif  
#ifdef DBF_NTX
  ferase( left( cEProARQ, len( cEProARQ ) - 3 ) + 'DBT' )
#endif  

return NIL

//
// Mostra os dados da Entrada 
//
function MostEPro()
  
  select EProARQ

  if cStat != 'incl'  
    cNota := Nota    
    nNota := val( Nota )
  endif  
 
  cNotaNew   := cNota   
  dEmis      := Emis  
  cEstq      := Estq
  nEstq      := val( Estq )
  eObse      := Obse
  nLin       := 10
  nTotalNota := TotalNota
  
  setcolor( CorCampo )
  @ 03,55 say dEmis              pict '99/99/9999'
  @ 05,15 say cEstq              pict '999999'
  @ 05,22 say EstqARQ->Nome
  @ 06,15 say eObse              pict '@S40' 
  
  if cStat == 'alte' .or. cStat == space(04)
    setcolor( CorJanel )
    for nG := 1 to 7  
      @ nLin, 05 say '      '    
      @ nLin, 12 say space(28)
      @ nLin, 41 say '         '
      @ nLin, 51 say '          '
      @ nLin, 63 say '          '
      nLin ++
    next

    nLin := 10

    setcolor( CorJanel )
    select IEPrARQ
    set order to 1
    dbseek( cNota, .t. )
    do while Nota == cNota
      cSequ       := Sequ
      cProd       := Prod
      cProduto    := Produto
      nQtde       := Qtde
      nPrecoCusto := PrecoCusto
            
      @ nLin, 05 say Prod                  pict '999999'    
      if Prod == '999999'
        @ nLin, 12 say memoline( Produto, 28, 1 )
      else  
        @ nLin, 12 say ProdARQ->Nome       pict '@S28'
      endif
      if EmprARQ->Inteira == "X"  
        @ nLin, 41 say Qtde                pict '@E 999999999'
      else      
        @ nLin, 41 say Qtde                pict '@E 99999.999'
      endif     
      @ nLin, 51 say PrecoCusto            pict PictPreco(10)
      @ nLin, 63 say Qtde * PrecoCusto     pict '@E 999,999.99'

      nLin ++
      dbskip ()
      if nLin >= 17
        exit
      endif   
    enddo
  else
    setcolor( CorJanel )
    for nG := 1 to 7  
      @ nLin, 05 say '      '    
      @ nLin, 12 say space(28)
      @ nLin, 41 say '         '
      @ nLin, 51 say '          '
      @ nLin, 63 say '          '
      nLin ++
    next
  endif  

  setcolor( CorCampo )
  @ 18,61 say nTotalNota             pict '@E 999,999,999.99'
  
  select EproARQ
  
  PosiDBF( 01, 76 )
return NIL

//
// Entra os dados
//
function EntrEPro ()
  local GetList := {}

  if cStat == 'incl'
    dEmis := date()
  endif  

  setcolor ( CorJanel + ',' + CorCampo )
  @ 03,55 get dEmis     pict '99/99/9999'
  @ 05,15 get nEstq     pict '999999' valid ValidARQ( 05, 15, "EProARQ", "Código" , "Estq", "Descrição", "Nome", "Estq", "nEstq", .t., 6, "Consulta de Estoque", "EstqARQ", 40 )
  @ 06,15 get eObse     pict '@S40'
  read
  
  cEstq := strzero( nEstq, 6 )
return NIL    

//
// Entra com os itens 
//
function EntrItEP()
  if lastkey() == K_ESC .or. lastkey() == K_PGDN
    return NIL
  endif 

  select( cEProTMP )
  set order    to 1
  set relation to Prod into ProdARQ

  bFirst := {|| dbseek( '0001', .t. ) }
  bLast  := {|| dbseek( '9999', .t. ), dbskip(-1) }
  bFor   := {|| .t. }
  bWhile := {|| .t. }

  oColuna         := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oColuna:nTop    := 8
  oColuna:nLeft   := 4
  oColuna:nBottom := 17
  oColuna:nRight  := 75
  oColuna:headsep := chr(194)+chr(196)
  oColuna:colsep  := chr(179)
  oColuna:footsep := chr(193)+chr(196)

  oColuna:addColumn( TBColumnNew("Codigo",      {|| Prod } ) )
  oColuna:addColumn( TBColumnNew("Nome",        {|| iif( Prod == '999999', memoline( Produto, 28, 1 ), left( ProdARQ->Nome, 28 ) ) } ) ) 
  if EmprARQ->Inteira == "X"  
    oColuna:addColumn( TBColumnNew("Qtde.",     {|| transform( Qtde, '@E 999999999' ) } ) )
  else  
    oColuna:addColumn( TBColumnNew("Qtde.",     {|| transform( Qtde, '@E 99999.999' ) } ) )
  endif  
  oColuna:addColumn( TBColumnNew("Preço Custo", {|| transform( PrecoCusto, PictPreco(10) ) } ) )
  oColuna:addColumn( TBColumnNew("Preço Total", {|| transform( PrecoCusto * Qtde, '@E 999,999.99' ) } ) )
            
  lExitRequested := .f.
  lAlterou       := .f.

  oColuna:goBottom()

  do while !lExitRequested
    Mensagem ( 'LEVE','Browse')
 
    oColuna:forcestable()

    if oColuna:hitTop .and. !empty( Prod )
      oColuna:refreshAll ()
      
      EntrEpro ()      

      select( cEProTMP )
      
      oColuna:down()
      oColuna:forcestable()
      oColuna:refreshAll ()

      loop
    endif

    if !lAlterou .and. cStat == 'incl' .or. (oColuna:hitbottom .and. lastkey() != K_ESC) 
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
      case cTecla == 46;            lExitRequested := .t.
      case cTecla == K_ESC
        if Saindo (lAlterou)
          lExitRequested := .t.
        else  
          lExitRequested := .f.
        endif  
      case cTecla == K_ENTER;        EntrItEPro(.f.)
      case cTecla == K_INS
        do while lastkey() != K_ESC    
          EntrItEPro(.t.)
        enddo  
        
        cTecla := ""
      case cTecla == K_DEL
        if RegLock()
          setcolor( CorCampo )
          cProd       := Prod
          nQtde       := Qtde
          nPrecoCusto := PrecoCusto
          nTotalNota  -= ( nQtde * nPrecoCusto )

          @ 18,61 say nTotalNota       pict '@E 999,999,999.99'

          replace Lixo      with .t.  
            
          dbdelete ()
          dbunlock ()
    
          oColuna:refreshAll()  
          oColuna:gotop ()
        endif  
    endcase
  enddo
return NIL  

//
// Entra intens da nota
//
function EntrItEPro( lAdiciona )
  local GetList := {}
  local nSequ   := 0
  
  if lAdiciona 
    dbgobottom()
    nSequ := val( Sequ ) + 1
    
    if AdiReg()
      if RegLock()
        replace Sequ            with strzero( nSequ, 4 )
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

    Mensagem( 'PedF','InclIten')
  else
    Mensagem( 'PedF','AlteIten')
  endif  

  cSequ       := Sequ
  nSequ       := val( Sequ )
  cProd       := Prod
  cProduto    := Produto
  nProd       := val( cProd )
  nQtde       := Qtde
  nPrecoCusto := PrecoCusto
  
  nQtdeAnt    := nQtde
  nPrecoAnt   := nPrecoCusto
  nLin        := 09 + oColuna:rowPos
  lAlterou    := .t.
    
  setcolor( CorCampo )
  if cProd == '999999'
    @ nLin, 12 say memoline( cProduto, 28, 1 )
  else  
    @ nLin, 12 say ProdARQ->Nome       pict '@S28'
  endif  
  @ nLin, 51 say PrecoCusto            pict PictPreco(10)
  @ nLin, 63 say nQtde * PrecoCusto    pict '@E 999,999.99'

  set key K_UP to UpNota ()
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ nLin, 05 get cProd         pict '@K'            valid ValidProd( nLin, 05, cEProTMP, 'epro', nPrecoCusto, 0 )
  if EmprARQ->Inteira == "X"  
    @ nLin, 41 get nQtde       pict '@E 999999999'  valid VoltaUp () 
  else  
    @ nLin, 41 get nQtde       pict '@E 99999.999'  valid VoltaUp () 
  endif  
  @ nLin, 51 get nPrecoCusto   pict PictPreco(10)
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
    replace Produto         with cProduto
    replace Qtde            with nQtde
    replace PrecoCusto      with nPrecoCusto
    replace Lixo            with .f.
    dbunlock ()
  endif
  
  oColuna:refreshCurrent()  
  
  if !lAdiciona
    nTotalNota -= ( nQtdeAnt * nPrecoAnt )
    nTotalNota += ( nQtde * nPrecoCusto )
  else
    nTotalNota += ( nQtde * nPrecoCusto )
  endif

  setcolor( CorCampo )
  @ 18,61 say nTotalNota       pict '@E 999,999,999.99'
return NIL     

//
// Excluir nota
//
function EstoEPro ()
  cStat  := 'loop' 
  lEstq  := .f.
  
  select EProARQ

  if ExclEstq ()
    select IEPrARQ
    set order to 1
    dbseek( cNota, .t. )
    do while Nota == cNota
      cProd := Prod
      nQtde := Qtde
    
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif
     
      if lEstq
        select ProdARQ
        set order to 1
        dbseek( cProd, .f. )
        if RegLock() 
          replace Qtde         with Qtde - nQtde
          replace UltE         with date()
          dbunlock ()
        endif  
      
        select IEPrARQ
      endif

      dbskip ()
    enddo    
    
    select EProARQ
  endif
return NIL

//
// Entra o estoque
//
function GravEPro()
  
  set deleted off   
    
  select( cEProTMP )
  set order to 1 
  dbgotop ()
  do while !eof ()
    if empty( Prod )
      dbskip ()
      loop
    endif  
      
    cProd       := Prod
    cProduto    := Produto
    nQtde       := Qtde
    nPrecoCusto := PrecoCusto
    nRegi       := Regi
    lLixo       := Lixo
      
    if Novo
      if Lixo
        dbskip ()
        loop
      endif  
    
      select IEPrARQ
      set order to 1
      dbseek( cNotaNew + &cEProTMP->Sequ, .f. )
      
      if found()
        if RegLock()
          dbdelete ()
          dbunlock ()
        endif  
      endif     
      
      if AdiReg()
        if RegLock()
          replace Nota       with cNotaNew
          replace Sequ       with &cEProTMP->Sequ
          replace Prod       with &cEProTMP->Prod
          replace Produto    with &cEProTMP->Produto
          replace Qtde       with &cEProTMP->Qtde
          replace PrecoCusto with &cEProTMP->PrecoCusto
          dbunlock ()
        endif
      endif   
  
      select ProdARQ
      set order to 1
      dbseek( cProd, .f. )
      if found ()
        if RegLock()
          replace Qtde         with Qtde + nQtde
          replace UltE         with dEmis
          dbunlock ()
        endif
      endif    
    else 
      select IEPrARQ
      go nRegi
      
      cPrAnt := Prod
      nQtAnt := Qtde
          
      if RegLock()
        replace Prod          with cProd
        replace Produto       with cProduto
        replace PrecoCusto    with nPrecoCusto
        replace Qtde          with nQtde
        dbunlock ()
      endif  
          
      select ProdARQ
      set order to 1
      dbseek( cPrAnt, .f. )
      if found ()
        if RegLock()
          replace Qtde         with Qtde - nQtAnt
          replace UltE         with dEmis
          dbunlock ()
        endif
      endif    

      if !lLixo
        dbseek( cProd, .f. )
        if found ()
          if RegLock()
            replace Qtde         with Qtde + nQtde
            replace UltE         with dEmis
            dbunlock ()
          endif
        endif    
      endif  

      select IEPrARQ

      if lLixo
        if RegLock()
          dbdelete ()
          dbunlock ()
        endif
      endif
    endif 
      
    select( cEProTMP )
    dbskip ()
  enddo  
   
  set deleted on
  
  select EProARQ
return NIL

//
// Imprime Dados
//
function PrinEPro ( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "ProdARQ", .t. )
      VerifIND( "ProdARQ" )
  
      sOpenProd := .t.
       
      #ifdef DBF_NTX
        set index to ProdIND1, ProdIND2
      #endif  
    else
      sOpenProd := .f.  
    endif

    if NetUse( "EstqARQ", .t. )
      VerifIND( "EstqARQ" )
  
      sOpenEstq := .t.
       
      #ifdef DBF_NTX
        set index to EstqIND1, EstqIND2
      #endif  
    else
      sOpenEstq := .f.  
    endif

    if NetUse( "EProARQ", .t. )
      VerifIND( "EProARQ" )
  
      sOpenEPro := .t.
  
      #ifdef DBF_NTX
        set index to EProIND1
      #endif  
    else
      sOpenEPro := .f.  
    endif

    if NetUse( "IEPrARQ", .t. )
      VerifIND( "IEPrARQ" )
  
      sOpenIEPr := .t.
  
      #ifdef DBF_NTX
        set index to IEPrIND1
      #endif  
    else
      sOpenIEPr := .f.  
    endif
  endif  

  if NetUse( "CampARQ", .t. )
    VerifIND( "CampARQ" )
  
    #ifdef DBF_NTX
      set index to CampIND1, CampIND2
    #endif  
  endif

  if NetUse( "EtiqARQ", .t. )
    VerifIND( "EtiqARQ" )
  
    #ifdef DBF_NTX
      set index to EtiqIND1
    #endif  
  endif

  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 07, 08, 13, 70, mensagem( 'Janela', 'PrinEPro', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 09,10 say '  Entrada Inicial               Entrada Final'
  @ 10,10 say '     Data Inicial                  Data Final'
  @ 11,10 say ' Operação Inicial              Operação Final'
  @ 12,10 say '        Etiquetas'

  setcolor( CorCampo )
  @ 12,28 say ' Sim '
  @ 12,34 say ' Não '

  setcolor( CorAltKC )
  @ 12,29 say 'S'
  @ 12,35 say 'N'

  select EstqARQ
  set order to 1   
  dbgotop ()
  nEstqIni := val( Estq )
  dbgobottom ()
  nEstqFin := val( Estq )

  select EProARQ
  set order to 1   
  dbgotop ()
  nNotaIni := val ( Nota )
  dbgobottom ()
  nNotaFin := val ( Nota )

  dDataIni := ctod ('01/01/90')
  dDataFin := date ()

  @ 09,28 get nNotaIni          pict '999999' 
  @ 09,56 get nNotaFin          pict '999999'     valid nNotaFin >= nNotaIni
  @ 10,28 get dDataIni          pict '99/99/9999' 
  @ 10,56 get dDataFin          pict '99/99/9999'   valid dDataFin >= dDataIni
  @ 11,28 get nEstqIni          pict '999999'       valid nEstqIni == 0 .or. ValidARQ( 99, 99, "EProARQ", "Código" , "Estq", "Descrição", "Nome", "Estq", "nEstqIni", .t., 6, "Consulta de Operação", "EstqARQ", 40 )  
  @ 11,56 get nEstqFin          pict '999999'       valid nEstqFin == 0 .or. ValidARQ( 99, 99, "EproARQ", "Código" , "Estq", "Descrição", "Nome", "Estq", "nEstqFin", .t., 6, "Consulta de Operação", "EstqARQ", 40 ) .and. nEstqFin >= nEstqIni 
  read

  if lastkey() == K_ESC
    select CampARQ
    close
    select EtiqARQ
    close
    select EProARQ
    if lAbrir
      close
      select ProdARQ
      close
      select EstqARQ
      close
      select IEPrARQ
      close
    else
      set order to 1 
      dbgobottom ()
    endif
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  lEtiq := ConfLine( 12, 28, 2 )

  if lastkey() == K_ESC
    select CampARQ
    close
    select EtiqARQ
    close
    select EProARQ
    if lAbrir
      close
      select ProdARQ
      close
      select EstqARQ
      close
      select IEPrARQ
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

  cNotaIni := strzero( nNotaIni, 6 )
  cNotaFin := strzero( nNotaFin, 6 )
  cDataIni := dtos( dDataIni )
  cDataFin := dtos( dDataFin )

  if lEtiq 
    select EtiqARQ
    set order to 1
    dbseek( EmprARQ->EtiqProd, .f. )

    if found()
      if empty( Layout )
        lAchou := .f.
      else  
        lAchou := .t.
      endif  
    else
      lAchou := .f.
    endif
  
    if !lAchou
      Alerta( mensagem( 'Alerta', 'PrinEtiq', .f. ) )
      select CampARQ
      close
      select EtiqARQ
      close
      select EProARQ
      if lAbrir
        close
        select ProdARQ
        close
        select EstqARQ
        close
        select IEPrARQ
        close
      else
        set order to 1 
        dbgobottom ()
      endif
      restscreen( 00, 00, 23, 79, tPrt )
      return NIL
    endif
  
    cTexto     := Layout
    nLin       := 1
    nLargura   := Tama
    nEspa      := Espa
    nComp      := Comp
    cQtLin     := QtLinha
    nColunas   := Colunas
    nDistancia := Distancia
    nSalto     := Salto
    aLayout    := {}
    aProdutos  := {}
    cQtLin     := mlcount( cTexto, nLargura + 1 )
 
    for nK := 1 to cQtLin
      cLinha := memoline( cTexto, nLargura + 1, nK )

      if empty( cLinha )
        nLin ++
        loop
      endif

      nTamLin  := len( cLinha )
      cPalavra := ''
      nCol     := 0

      for nH := 1 to nTamLin
        cKey := substr( cLinha, nH, 1 )

        if cKey != ' '
          if nCol == 0
            nCol := nH
          endif

          cPalavra += cKey
        endif

        if cKey == ' '
          if empty( cPalavra )
            loop
          endif

          select CampARQ
          set order to 2
          dbseek( cPalavra, .f. )
          if found ()
            aadd( aLayout, { nLin, nCol, Tipo, alltrim( Campo ), Mascara, Tamanho, Arquivo  } ) 
          endif

          cPalavra := ''
          nCol     := 0
        endif  
      next
      nLin ++
    next
 
    select EProARQ
    set order to 1
    dbseek( cNotaIni, .t. )
    do while Nota >= cNotaIni .and. Nota <= cNotaFin .and. !eof ()              
      if Emis >= dDataIni .and. Emis <= dDataFin .and.;
        val( Estq ) >= nEstqIni .and. val( Estq ) <= nEstqFin
        
        select IEPrARQ
        set order    to 1
        set relation to Prod into ProdARQ
        dbseek( EProARQ->Nota, .t. )
        do while Nota == EProARQ->Nota .and. !eof()
          nElem := ascan( aProdutos, { |nElem| nElem[1] == Prod } )
         
          if nElem > 0
            aProdutos[ nElem, 2 ] += Qtde
          else
            aadd( aProdutos, { Prod, Qtde } ) 
          endif  
          dbskip ()
        enddo
        select EProARQ
      endif  
      dbskip ()
    enddo
    
    if !TestPrint( EmprARQ->Produto )
      select CampARQ
      close
      select EtiqARQ
      close
      select EProARQ
      if lAbrir
        close
        select ProdARQ
        close
        select EstqARQ
        close
        select IEPrARQ
        close
      else
        set order to 1 
        dbgobottom ()
      endif
      restscreen( 00, 00, 23, 79, tPrt )
      return NIL
    endif
  
    setprc( 0, 0 )

    if nComp == 1
      @ 00,00 say chr(15)
    else  
      @ 00,00 say chr(18)
    endif  
      
    if nEspa == 1
      @ 00,00 say chr(27) + '@'
    else
      @ 00,00 say chr(27) + chr(48)
    endif  
  
    nLinIni  := aLayout[ 1, 1 ]
    nLinFin  := aLayout[ len( aLayout ), 1 ]
    xLin     := 0
    nCopia   := 0
    nTotProd := len( aProdutos )
    nF       := 1
    
    select ProdARQ
    set order to 1
    
    do while nF <= nTotProd
      dbseek( aProdutos[ nF, 1 ], .f. )
      
      for nH := 1 to nColunas
        s       := strzero( nH, 2 )
        aEtiq&s := {}
      next
    
      if nCopia == 0   
        nCopia := aProdutos[ nF, 2 ]
      endif  
            
      for nJ := 1 to nColunas
        ueta := strzero( nJ, 2 )

        for nL := 1 to len( aLayout )
          nLin   := aLayout[ nL, 1 ] 
          nCol   := aLayout[ nL, 2 ] 
          cTipo  := aLayout[ nL, 3 ] 
          cCamp  := aLayout[ nL, 4 ] 
          cPict  := aLayout[ nL, 5 ] 
          nTama  := aLayout[ nL, 6 ] 
          cArqu  := aLayout[ nL, 7 ] 
        
          if empty( cArqu )
            cCampo := cCamp
          else  
            select( cArqu )
                          
            do case 
              case cTipo == 'N'
                if !empty( &cCamp )
                  cCampo := transform( &cCamp, cPict )
                else
                  cCampo := '' 
                endif  
              case cTipo == 'C'  
                cCampo := left( &cCamp, nTama )
              case cTipo == 'D' .or. cTipo == 'V'  
                cCampo := &cCamp
            endcase  
          endif  
           
          aadd( aEtiq&ueta, { nLin, nCol, cCampo } )
        next

        if nCopia == 1  
          nF ++
          if nF > nTotProd
            dbseek( -123, .f. )
          else  
            dbseek( aProdutos[ nF, 1 ], .f. )
            
            nCopia := aProdutos[ nF, 2 ]
          endif  
        else  
          nCopia --
        endif 
        
        if eof()
          for nY := ( nJ + 1 ) to nColunas
            u       := strzero( nY, 2 )
            aEtiq&u := {}
          next  
          exit
        endif  
      next

      setprc( 0, 0 )
    
      xLin := ( nLinIni - 1 )
 
      for nLinha := nLinIni to nLinFin
        for nA := 1 to nColunas
          uetas := strzero( nA, 2 )
          for nB := 1 to len( aEtiq&uetas )
            nLin   := aEtiq&uetas[ nB, 1 ]
            nCol   := aEtiq&uetas[ nB, 2 ]
            cCampo := aEtiq&uetas[ nB, 3 ]
            
            if nA > 1
              nCol += ( ( ( nLargura + nDistancia ) * ( nA - 1 ) ) + 1 )
              
              if nA > 4
                nCol ++
              endif  
            endif

            if nLin == nLinha 
              @ xLin, nCol say alltrim( cCampo )
            endif
          next   
        next  
        xLin ++
      next

      xLin += nSalto

      @ xLin,00 say chr(13)
    enddo

    @ nLin,00 say chr(27) + '@'
  else
  
  select EProARQ
  set order to 1
  dbseek( cNotaIni, .t. )
  do while Nota >= cNotaIni .and. Nota <= cNotaFin .and. !eof ()              
    if Emis >= dDataIni .and. Emis <= dDataFin .and.;
      val( Estq ) >= nEstqIni .and. val( Estq ) <= nEstqFin
      if lInicio
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
      
        lInicio := .f.
      endif
      
      if nLin == 0
        Cabecalho ( 'Entradas Alternativas', 80, 2 )
        CabEPro   ()
      endif
    
      @ nLin,01 say Nota
      @ nLin,08 say Emis                 pict '99/99/9999'
      @ nLin,17 say Obse                 pict '@S50' 
      nLin ++
  
      nValorTotal := nTotalNota := 0
      cNota       := Nota
 
      select IEPrARQ
      set order    to 1
      set relation to Prod into ProdARQ
      dbseek( cNota + '01', .t. )
      do while Nota == cNota
        nValorTotal := Qtde * PrecoCusto
        nTotalNota  += nValorTotal
 
        @ nLin, 08 say val( Sequ )         pict '99'
        @ nLin, 11 say Prod
        if Prod == '999999'
          @ nLin, 18 say memoline( Produto, 28, 1 )
        else  
          @ nLin, 18 say ProdARQ->Nome     pict '@S28'
        endif  
        if EmprARQ->Inteira == "X"
          @ nLin, 47 say Qtde              pict '@E 999999999'
        else  
          @ nLin, 47 say Qtde              pict '@E 99999.999'
        endif  
        @ nLin, 57 say PrecoCusto          pict PictPreco(10)
        @ nLin, 69 say nValorTotal         pict '@E 999,999.99'
        nLin ++

        if nLin >= pLimite
          Rodape(80) 

          cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
          cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

          set printer to ( cArqu2 )
          set printer on
        
          select EProARQ
        
          Cabecalho ( 'Entradas Alternativas', 80, 2 )
          CabEPro   ()
       
          @ nLin,01 say Nota
          @ nLin,08 say Emis                 pict '99/99/9999'
          @ nLin,17 say Obse                 pict '@S50' 
          nLin ++ 
          select IEPrARQ
        endif
      
        dbskip ()
      enddo
    
      select EProARQ

      @ nLin, 50 say 'Total da Nota'
      @ nLin, 69 say nTotalNota         pict '@E 999,999.99'
      nLin ++
  
      if nLin >= pLimite
        Rodape(80) 

        cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
        cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

        set printer to ( cArqu2 )
        set printer on
      endif
    endif
    dbskip ()
  enddo
  
    if !lInicio
      Rodape(80)
    endif  
  endif
 
  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 80 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Relatório de Entradas Alternativas"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
    close
  endif

  select CampARQ
  close
  select EtiqARQ
  close
  select EProARQ
  if lAbrir
    close
    select ProdARQ
    close
    select EstqARQ
    close
    select IEPrARQ
    close
  else
    set order  to 1 
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabEPro ()
  @ 02,01 say 'Nota   Data     Observação'
  @ 03,01 say '     Seq. Prod Descrição                          Qtde.   P. Unit. Valor Total'

  nLin := 5  
return NIL

//
// Imprime Media dos Produtos
//
function PrinCompra ( lAbrir, xTipo )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "ProdARQ", .t. )
      VerifIND( "ProdARQ" )

      #ifdef DBF_NTX
        set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
      #endif  
    endif

    if NetUse( "NEntARQ", .t. )
      VerifIND( "NEntARQ" )
  
      #ifdef DBF_NTX
        set index to NEntIND1
      #endif  
    endif

    if NetUse( "INenARQ", .t. )
      VerifIND( "INEnARQ" )
  
      #ifdef DBF_NTX
        set index to INEnIND1
      #endif  
    endif

    if NetUse( "EProARQ", .t. )
      VerifIND( "EProARQ" )
  
      #ifdef DBF_NTX
        set index to EProIND1
      #endif  
    endif

    if NetUse( "IEPrARQ", .t. )
      VerifIND( "IEPrARQ" )
  
      #ifdef DBF_NTX
        set index to IEPrIND1
      #endif  
    endif
  endif  


  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 06, 23, 09, 53, mensagem( 'Janela', 'PrinCompra', .f. ), .f. )

  setcolor( CorCampo )
  @ 08,32 say aMesExt[ month( date() ) ]

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,25 say 'Mˆs'

  nMes := month( date() )
  
  @ 08,29 get nMes       pict '99'   valid ValidMes( 08, 29, nMes )
  read

  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC
    if lAbrir
      select ProdARQ
      close
      select NEntARQ
      close
      select INenARQ
      close
      select EProARQ
      close
      select IEPrARQ
      close
    else
      select ProdARQ
      dbgobottom ()
    endif
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  Aguarde ()
  
  nPag   := 1
  nLin   := 0
  cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

  lInicio  := .t.

  select INenARQ
  set order    to 1
  set relation to Prod into ProdARQ
  
  do case
    case nMes == 1
      dMes01Ini := ctod( '01' + '/' + '11' + '/' + substr( strzero( year( date() ) - 1, 4 ), 3, 2 ) )
      dMes01Fin := eom( dMes01Ini )
      dMes02Ini := ctod( '01' + '/' + '12' + '/' + substr( strzero( year( date() ) - 1, 4 ), 3, 2 ) )
      dMes02Fin := eom( dMes02Ini )
      dMes03Ini := ctod( '01' + '/' + strzero( nMes, 2 ) + '/' + substr( strzero( year( date() ), 4 ), 3, 2 ) )
      dMes03Fin := eom( dMes03Ini )
    case nMes == 2
      dMes01Ini := ctod( '01' + '/' + '12' + '/' + substr( strzero( year( date() ) - 1, 4 ), 3, 2 ) )
      dMes01Fin := eom( dMes01Ini )
      dMes02Ini := ctod( '01' + '/' + '01' + '/' + substr( strzero( year( date() ), 4 ), 3, 2 ) )
      dMes02Fin := eom( dMes02Ini )
      dMes03Ini := ctod( '01' + '/' + strzero( nMes, 2 ) + '/' + substr( strzero( year( date() ), 4 ), 3, 2 ) )
      dMes03Fin := eom( dMes03Ini )
    otherwise
      dMes01Ini := ctod( '01' + '/' + strzero( nMes - 2, 2 ) + '/' + substr( strzero( year( date() ), 4 ), 3, 2 ) )
      dMes01Fin := eom( dMes01Ini )
      dMes02Ini := ctod( '01' + '/' + strzero( nMes - 1, 2 ) + '/' + substr( strzero( year( date() ), 4 ), 3, 2 ) )
      dMes02Fin := eom( dMes02Ini )
      dMes03Ini := ctod( '01' + '/' + strzero( nMes, 2 ) + '/' + substr( strzero( year( date() ), 4 ), 3, 2 ) )
      dMes03Fin := eom( dMes03Ini )
  endcase
  
  aProdutos := {}

  select NEntARQ
  set order to 1
  dbgotop()
  do while !eof ()
    if Emis >= dMes01Ini .and. Emis <= dMes03Fin
      select INenARQ
      set order    to 1
      set relation to Prod into ProdARQ
      dbseek( NEntARQ->Forn + NEntARQ->Nota, .t. )
      do while Forn == NEntARQ->Forn .and. Nota == NEntARQ->Nota .and. !eof()
        if Prod != '9999'
          nElem := ascan( aProdutos, { |nElem| nElem[1] == Prod } )
        
          if nElem > 0    
            if NEntARQ->Emis >= dMes01Ini .and. NEntARQ->Emis <= dMes01Fin
              aProdutos[ nElem, 4 ] += Qtde
            endif  
            if NEntARQ->Emis >= dMes02Ini .and. NEntARQ->Emis <= dMes02Fin
              aProdutos[ nElem, 5 ] += Qtde
            endif  
            if NEntARQ->Emis >= dMes03Ini .and. NEntARQ->Emis <= dMes03Fin
              aProdutos[ nElem, 6 ] += Qtde
            endif  
          else
            if NEntARQ->Emis >= dMes01Ini .and. NEntARQ->Emis <= dMes01Fin
              aadd( aProdutos, { Prod, ProdARQ->Nome, ProdARQ->Unid, Qtde, 0, 0, ProdARQ->Qtde, ProdARQ->EstqMini } )
            endif
            if NEntARQ->Emis >= dMes02Ini .and. NEntARQ->Emis <= dMes02Fin
              aadd( aProdutos, { Prod, ProdARQ->Nome, ProdARQ->Unid, 0, Qtde, 0, ProdARQ->Qtde, ProdARQ->EstqMini } )
            endif
            if NEntARQ->Emis >= dMes03Ini .and. NEntARQ->Emis <= dMes03Fin
              aadd( aProdutos, { Prod, ProdARQ->Nome, ProdARQ->Unid, 0, 0, Qtde, ProdARQ->Qtde, ProdARQ->EstqMini } )
            endif
          endif
        endif
        dbskip()
      enddo
      
      select NEntARQ
    endif
    dbskip()
  enddo

  select EProARQ
  set order to 4
  dbseek( dMes01Ini, .t. )
  do while !eof ()
    if Emis >= dMes01Ini .and. Emis <= dMes03Fin
      select IEPrARQ
      set order    to 1
      set relation to Prod into ProdARQ
      dbseek( EProARQ->Nota, .t. )
      do while Nota == EProARQ->Nota .and. !eof()
        if Prod != '9999'
          nElem := ascan( aProdutos, { |nElem| nElem[1] == Prod } )
        
          if nElem > 0    
            if EProARQ->Emis >= dMes01Ini .and. EProARQ->Emis <= dMes01Fin
              aProdutos[ nElem, 4 ] += Qtde
            endif  
            if EProARQ->Emis >= dMes02Ini .and. EProARQ->Emis <= dMes02Fin
              aProdutos[ nElem, 5 ] += Qtde
            endif  
            if EProARQ->Emis >= dMes03Ini .and. EProARQ->Emis <= dMes03Fin
              aProdutos[ nElem, 6 ] += Qtde
            endif  
          else
            if EProARQ->Emis >= dMes01Ini .and. EProARQ->Emis <= dMes01Fin
              aadd( aProdutos, { Prod, ProdARQ->Nome, ProdARQ->Unid, Qtde, 0, 0, ProdARQ->Qtde, ProdARQ->EstqMini } )
            endif
            if EProARQ->Emis >= dMes02Ini .and. EProARQ->Emis <= dMes02Fin
              aadd( aProdutos, { Prod, ProdARQ->Nome, ProdARQ->Unid, 0, Qtde, 0, ProdARQ->Qtde, ProdARQ->EstqMini } )
            endif
            if EProARQ->Emis >= dMes03Ini .and. EProARQ->Emis <= dMes03Fin
              aadd( aProdutos, { Prod, ProdARQ->Nome, ProdARQ->Unid, 0, 0, Qtde, ProdARQ->Qtde, ProdARQ->EstqMini } )
            endif
          endif
        endif
        dbskip()
      enddo
      
      select EProARQ
    endif
    dbskip()
  enddo
 
  asort( aProdutos,,, { | Prod01, Prod02 | Prod01[2] < Prod02[2] } )
  
  for nI := 1 to len( aProdutos )
      if lInicio
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
        
        lInicio := .f.
      endif     
      
      if nLin == 0
        Cabecalho ( 'Produtos - Media Compra', 132, 2 )
        CabMedia ()
      endif
      
      nMedia := ( aProdutos[ nI, 4 ] + aProdutos[ nI, 5 ] + aProdutos[ nI, 6 ] ) / 3
/*    
Cod Descricao                                Uni    99/2003    99/1001    99/9999      Media    Estoque     Minimo
9999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXX 999999.999 999999.999 999999.999 999999.999 999999.999 999999.999
*/
      @ nLin,001 say aProdutos[ nI, 1 ]   pict '999999'
      @ nLin,008 say aProdutos[ nI, 2 ]   pict '@S38' 
      @ nLin,047 say aProdutos[ nI, 3 ]   pict '@S3' 

      if EmprARQ->Inteira == "X"  
        @ nLin,051 say aProdutos[ nI, 4 ]   pict '@E 9999999999'
        @ nLin,062 say aProdutos[ nI, 5 ]   pict '@E 9999999999'
        @ nLin,073 say aProdutos[ nI, 6 ]   pict '@E 9999999999'
        @ nLin,084 say nMedia               pict '@E 9999999999'
        @ nLin,095 say aProdutos[ nI, 7 ]   pict '@E 9999999999'
        @ nLin,106 say aProdutos[ nI, 8 ]   pict '@E 9999999999'
      else  
        @ nLin,051 say aProdutos[ nI, 4 ]   pict '@E 999999.999'
        @ nLin,062 say aProdutos[ nI, 5 ]   pict '@E 999999.999'
        @ nLin,073 say aProdutos[ nI, 6 ]   pict '@E 999999.999'
        @ nLin,084 say nMedia               pict '@E 999999.999'
        @ nLin,095 say aProdutos[ nI, 7 ]   pict '@E 999999.999'
        @ nLin,106 say aProdutos[ nI, 8 ]   pict '@E 999999.999'
      endif  
      nLin ++
    
      if nLin >= pLimite
        Rodape(132) 

        cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
        cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

        set printer to ( cArqu2 )
        set printer on
      endif

  next
  
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
      replace Titu       with "Relatório de Produtos - Media Compra"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 132
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
    close
  endif

  if lAbrir
    select ProdARQ
    close
    select NEntARQ
    close
    select INenARQ
    close
    select EProARQ
    close
    select IEPrARQ
    close
  else  
    select ProdARQ
    set order  to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL