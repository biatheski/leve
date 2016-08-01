//  Leve, Saida Alternativa
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

function SPro ()

if NetUse( "EstqARQ", .t. )
  VerifIND( "EstqARQ" )
  
  sOpenEstq := .t.

  #ifdef DBF_NTX
    set index to EstqIND1, EstqIND2
  #endif
else
  sOpenEstq := .f.
endif

if NetUse( "ProdARQ", .t. )
  VerifIND( "ProdARQ" )
  
  sOpenProd := .t.
  
  #ifdef DBF_NTX
    set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
  #endif
else
  sOpenProd := .f.  
endif

if NetUse( "SProARQ", .t. )
  VerifIND( "SProARQ" )
  
  sOpenSPro := .t.
  
  #ifdef DBF_NTX
    set index to SProIND1
  #endif
else
  sOpenSPro := .f.  
endif

if NetUse( "ISPrARQ", .t. )
  VerifIND( "ISPrARQ" )
  
  sOpenISPr := .t.
  
  #ifdef DBF_NTX
    set index to ISPrIND1
  #endif
else
  sOpenISPr := .f.  
endif

if NetUse( "IProARQ", .t. )
  VerifIND( "IProARQ" )
  
  sOpenIPro := .t.
  
  #ifdef DBF_NTX
    set index to IProIND1
  #endif
else
  sOpenIPro := .f.  
endif

//  Variaveis para Saida de dados
nNota        := nQtde       := 0
cNota        := cNotaNew    := space(06)
dEmis        := date()
nEstq        := 0
nTotalNota   := nPrecoTotal := 0
nPrecoVenda  := nSequPrx    := nPrecoCusto := 0
cEstq        := cUnidade    := space(02)
cProd        := sObse       := cProduto    := space(04)
 
aOpcoes      := {}
aArqui       := {}
cSProARQ     := CriaTemp(0)
cSProIND1    := CriaTemp(1)
cChave       := "Sequ"

aadd( aArqui, { "Sequ",       "C", 004, 0 } )
aadd( aArqui, { "Prod",       "C", 006, 0 } )
aadd( aArqui, { "Produto",    "M", 010, 0 } )
aadd( aArqui, { "Qtde",       "N", 012, 3 } )
aadd( aArqui, { "PrecoVenda", "N", 015, 6 } )
aadd( aArqui, { "PrecoCusto", "N", 015, 6 } )
aadd( aArqui, { "Unidade",    "C", 003, 0 } )
aadd( aArqui, { "Regi",       "N", 008, 0 } )
aadd( aArqui, { "Novo",       "L", 001, 0 } )
aadd( aArqui, { "Lixo",       "L", 001, 0 } )

dbcreate( cSProARQ , aArqui )
   
if NetUse( cSProARQ, .f. )
  cSProTMP := alias ()
    
  #ifdef DBF_CDX
    index on &cChave tag &cSProIND1
  #endif

  #ifdef DBF_NTX
    index on &cChave to &cSProIND1

    set index to &cSProIND1
  #endif
endif
 
Janela ( 01, 02, 21, 76, mensagem( 'Janela', 'SPro', .f. ), .t. )
setcolor ( CorJanel + ',' + CorCampo )

@ 03,04 say '     Saída                                 Emissão'
@ 05,04 say '  Operação' 
@ 06,04 say 'Observação'

@ 08,05 say 'Código Nome                         Qtde.     Preço Venda Preço Total'
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
   
@ 18,49 say 'Total Saída'

MostOpcao( 20, 04, 16, 52, 65 ) 
tSnot := savescreen( 00, 00, 24, 79 )

select SProARQ
set order to 1
dbgobottom ()

do while .t.
  cStat := cStatAux := space(04)
  restscreen( 00, 00, 23, 79, tSnot )

  Mensagem( 'SPro','Janela')
  
  select( cSProTMP )
  set order to 1
  zap
  
  select EstqARQ
  set order to 1
  
  select ProdARQ
  set order to 1

  select ISPrARQ
  set relation to Prod into ProdARQ
  set order    to 1

  select SProARQ
  set order    to 1
  set relation to Estq into EstqARQ

  MostSPro ()
  
  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )
  MostTudo := 'MostSPro'
  cAjuda   := 'SPro'
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
  select SProARQ
  set order to 1
  dbseek( cNota, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif

  Mensagem ('SPro',cStat)
  
  select ISPrARQ
  set order to 1
  dbseek( cNota, .t. )
  do while Nota == cNota
    nRegi := recno ()
    
    select( cSProTMP )
    if AdiReg()
      if RegLock()
        replace Sequ       with ISPrARQ->Sequ
        replace Prod       with ISPrARQ->Prod
        replace Produto    with ISPrARQ->Produto
        replace Qtde       with ISPrARQ->Qtde
        replace PrecoVenda with ISPrARQ->PrecoVenda
        replace PrecoCusto with ISPrARQ->PrecoCusto
        replace Unidade    with ISPrARQ->Unidade   
        replace Regi       with nRegi
        replace Novo       with .f.
        replace Lixo       with .f.
        dbunlock ()
      endif
    endif
    
    select ISPrARQ
    dbskip ()
  enddo
  
  cStatAnt := cStat
  
  select SProARQ

  MostSPro ()
  EntrSPro ()  
  EntrItSP ()
  
  Confirmar( 20, 04, 16, 52, 65, 3 ) 
  
  if cStat == 'loop' .or. lastkey() == K_ESC
    loop
  endif  

  if cStat == 'prin'
    PrinSpro (.f.)
  endif
    
  if cStat == 'excl'
    EstoSPro ()
  endif
  
  if cStat == 'loop' .or. lastkey() == K_ESC
    loop
  endif  
  
  if cStatAnt == 'incl'
    if nNota == 0
      select EmprARQ
      set order to 1
      dbseek( cEmpresa, .f. )

      nNotaNew := SPro + 1
      
      do while .t.
        cNotaNew := strzero( nNotaNew, 6 )
        
        SproARQ->( dbseek( cNotaNew, .f. ) )
        
        if SproARQ->( found() ) 
          nNotaNew ++
        else     
          if RegLock()
            replace SPro       with nNotaNew
            dbunlock ()
          endif
          exit
        endif 
      enddo
    endif  
  endif  

  select SProARQ 

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
      replace Obse       with sObse
      replace Estq       with cEstq
      replace TotalNota  with nTotalNota
      dbunlock ()
    endif
  endif

  GravSPro ()

  if nNota == 0
    Alerta( mensagem( 'Alerta', 'SPro', .f. ) + cNotaNew )
  endif  
enddo

if sOpenEstq
  select EstqARQ
  close
endif

if sOpenProd
  select ProdARQ
  close
endif

if sOpenSPro
  select SProARQ
  close
endif

if sOpenISPr
  select ISPrARQ
  close
endif

if sOpenIPro
  select IProARQ
  close
endif

select( cSProTMP )
close
ferase( cSProARQ )
ferase( cSProIND1 )
#ifdef DBF_NTX
  ferase( left( cSProARQ, len( cSProARQ ) - 3 ) + 'FPT' )
#endif  
#ifdef DBF_CDX
  ferase( left( cSProARQ, len( cSProARQ ) - 3 ) + 'DBT' )
#endif  

return NIL

//
// Mostra os dados
//
function MostSPro()
  select SProARQ

  if cStat != 'incl'  
    cNota := Nota    
    nNota := val( Nota )
  endif  
 
  cNotaNew   := cNota   
  dEmis      := Emis  
  cEstq      := Estq
  nEstq      := val( Estq )
  sObse      := Obse
  nLin       := 10
  nTotalNota := TotalNota
  
  setcolor( CorCampo )
  @ 03,55 say dEmis              pict '99/99/9999'
  @ 05,15 say cEstq           
  @ 05,22 say EstqARQ->Nome
  @ 06,15 say sObse              pict '@S40' 
  
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
    select ISPrARQ
    set order to 1
    dbseek( cNota, .t. )
    do while Nota == cNota
      cProd       := Prod
      nQtde       := Qtde
      nPrecoVenda := PrecoVenda
            
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
      @ nLin, 51 say PrecoVenda            pict PictPreco(10)
      @ nLin, 63 say Qtde * PrecoVenda     pict '@E 999,999.99'

      nLin ++
      dbskip ()
      if nLin >= 17
        exit
      endif   
    enddo
    select SProARQ
    setcolor( CorCampo )
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
    setcolor( CorCampo )
  endif  
  
  @ 18,61 say nTotalNota             pict '@E 999,999,999.99'

  select SProARQ
  
  PosiDBF( 01, 76 )
return NIL

//
// Entra os dados
//
function EntrSPro ()
  local GetList := {}
  
  if empty( dEmis )
    dEmis := date()
  endif  

  setcolor ( CorJanel + ',' + CorCampo )
  @ 03,55 get dEmis     pict '99/99/9999'
  @ 05,15 get nEstq     pict '999999' valid ValidARQ( 05, 15, "SProARQ", "Código" , "Estq", "Descrição", "Nome", "Estq", "nEstq", .t., 6, "Consulta de Estoque", "EstqARQ", 40 )
  @ 06,15 get sObse     pict '@S40'
  read
  
  cEstq := strzero( nEstq, 6 )
return NIL    

//
// Entra com os itens 
//
function EntrItSP()
  if lastkey() == K_ESC .or. lastkey() == K_PGDN
    return NIL
  endif

  select( cSProTMP )
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

  oColuna:addColumn( TBColumnNew("Código",      {|| Prod } ) )
  oColuna:addColumn( TBColumnNew("Nome",        {|| iif( Prod == '999999', memoline( Produto, 28, 1 ), left( ProdARQ->Nome, 28 ) ) } ) ) 
  if EmprARQ->Inteira == "X"
    oColuna:addColumn( TBColumnNew("Qtde.",       {|| transform( Qtde, '@E 999999999' ) } ) )
  else
    oColuna:addColumn( TBColumnNew("Qtde.",       {|| transform( Qtde, '@E 99999.999' ) } ) )
  endif
  oColuna:addColumn( TBColumnNew("Preço Venda", {|| transform( PrecoVenda, PictPreco(10) ) } ) )
  oColuna:addColumn( TBColumnNew("Preço Total", {|| transform( PrecoVenda * Qtde, '@E 999,999.99' ) } ) )
            
  lExitRequested := .f.
  lAlterou       := .f.

  oColuna:goBottom()

  do while !lExitRequested
    Mensagem ( 'LEVE','Browse')
 
    oColuna:forcestable()

    if oColuna:hitTop .and. !empty( Prod )
      oColuna:refreshAll ()
      
      select SProARQ
      
      EntrSpro ()
      
      select( cSProTMP )
      
      oColuna:down()
      oColuna:forcestable()
      oColuna:refreshall()
      
      loop
    endif
    
    if ( !lAlterou .and. cStat == 'incl' ) .or. ( oColuna:HitBottom .and. lastkey() != K_ESC )
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
      case cTecla == K_ENTER;       EntrItSPro(.f.)
      case cTecla == K_INS
        do while lastkey() != K_ESC    
          EntrItSPro(.t.)
        enddo  
        cTecla := ""
      case cTecla == K_DEL
        if RegLock()
          setcolor( CorCampo )
          cProd       := Prod
          nQtde       := Qtde
          nPrecoVenda := PrecoVenda
          nTotalNota  -= ( nQtde * nPrecoVenda )

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
function EntrItSPro( lAdiciona )
  local GetList := {}
  local nSequ   := 0
  
  if lAdiciona 
    dbgobottom()
    nSequ  := val( Sequ ) + 1

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

  cProd       := Prod
  cProduto    := Produto
  nProd       := val( cProd )
  nQtde       := Qtde
  nPrecoVenda := PrecoVenda
  nPrecoCusto := PrecoCusto
  cUnidade    := Unidade
  
  nQtdeAnt    := nQtde
  nPrecoAnt   := nPrecoVenda
  nLin        := 09 + oColuna:rowPos
  lIPro       := .f.
  lAlterou    := .t.
    
  setcolor( CorCampo )
  @ nLin, 12 say ProdARQ->Nome         pict '@S28'
  @ nLin, 51 say PrecoVenda            pict PictPreco(10)
  @ nLin, 63 say nQtde * PrecoVenda    pict '@E 999,999.99'
  
  set key K_UP to UpNota()
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ nLin, 05 get cProd         pict '@K'            valid ValidProd( nLin, 05, cSProTMP, 'spro', 0, 0, nPrecoVenda )
  if EmprARQ->Inteira == "X"
    @ nLin, 41 get nQtde       pict '@E 999999999'  valid ValidQtde( nQtde ) .and. ValidSPro()
  else  
    @ nLin, 41 get nQtde       pict '@E 99999.999'  valid ValidQtde( nQtde ) .and. ValidSPro()
  endif  
  @ nLin, 51 get nPrecoVenda   pict PictPreco(10)
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
  
  if lIPro 
    select IProARQ
    do while Prod == cProd .and. !eof()
      select( cSProTMP )   

      if RegLock()
        replace Prod            with IProARQ->CodP
        replace Produto         with IProARQ->Produto
        replace Qtde            with IProARQ->Qtde * nQtde
        replace PrecoVenda      with IProARQ->PrecoVenda
        dbunlock ()
      endif

      nTotalNota += ( ( nQtde * IProARQ->Qtde ) * IProARQ->PrecoVenda )
      
      select IProARQ
      dbskip()
      
      if Prod == cProd .and. !eof()
        select( cSProTMP )
        if AdiReg()
          if RegLock()
            replace Sequ            with strzero( recno(), 4 )
            replace Novo            with .t.
            replace Lixo            with .f.
            dbunlock ()
          endif
        endif    
        select IProARQ
      endif
    enddo

    select( cSProTMP )   
  else
    if RegLock()
      replace Prod            with cProd
      replace Produto         with cProduto
      replace Qtde            with nQtde
      replace PrecoVenda      with nPrecoVenda
      replace PrecoCusto      with nPrecoCusto
      replace Unidade         with cUnidade     
      replace Lixo            with .f.
      dbunlock ()
    endif
  
    if !lAdiciona
      nTotalNota -= ( nQtdeAnt * nPrecoAnt )
      nTotalNota += ( nQtde * nPrecoVenda )
    else
      nTotalNota += ( nQtde * nPrecoVenda )
    endif
  endif  
  
  oColuna:refreshCurrent()  

  setcolor( CorCampo )
  @ 18,61 say nTotalNota       pict '@E 999,999,999.99'
return NIL     

//
// Verifica Composicao
//
function ValidSPro ()
  select IProARQ
  set order to 1 
  dbseek( cProd, .t. )
  if Prod == cProd
    lIPro := .t.
    
    keyboard(chr(13))
  else  
    lIPro := .f.
  endif
  select( cSProTMP )   
return(.t.)

//
// Excluir nota
//
function EstoSPro ()
  cStat  := 'loop' 
  lEstq  := .f.
  
  select SProARQ

  if ExclEstq ()
    select ISPrARQ
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
          replace Qtde         with Qtde + nQtde
          replace UltE         with date()
          dbunlock ()
        endif  
      
        select ISPrARQ
      endif     

      dbskip ()
    enddo    
    
    select SProARQ
  endif
return NIL

//
// Entra o estoque
//
function GravSPro()
  
  set deleted off

  select( cSProTMP )
  set order to 1
  dbgotop ()
  do while !eof ()
    if empty( Prod )
      dbskip ()
      loop
    endif

    cProd := Prod
    nQtde := Qtde
    nRegi := Regi
    lLixo := Lixo

    if Novo
      if Lixo
        dbskip ()
        loop
      endif

      select ISPrARQ
      set order to 1
      dbseek( cNotaNew + &cSProTMP->Sequ, .f. )
      
      if found ()
        if RegLock()
          dbdelete ()
          dbunlock ()
        endif  
      endif     
      
      if AdiReg()
        if RegLock()
          replace Nota       with cNotaNew
          replace Sequ       with &cSProTMP->Sequ
          replace Prod       with &cSProTMP->Prod
          replace Produto    with &cSProTMP->Produto
          replace Qtde       with &cSProTMP->Qtde
          replace PrecoVenda with &cSProTMP->PrecoVenda
          replace PrecoCusto with &cSProTMP->PrecoCusto
          replace Unidade    with &cSProTMP->Unidade    
          dbunlock ()
        endif
      endif

      select ProdARQ
      set order to 1
      dbseek( cProd, .f. )
      if found ()
        if RegLock()
          replace Qtde         with Qtde - nQtde
          replace UltE         with dEmis
          dbunlock ()
        endif
      endif
    else
      select ISPrARQ
      go nRegi

      cPrAnt := Prod
      nQtAnt := Qtde

      if RegLock()
        replace Prod       with &cSProTMP->Prod
        replace Produto    with &cSProTMP->Produto
        replace Qtde       with &cSProTMP->Qtde
        replace PrecoVenda with &cSProTMP->PrecoVenda
        replace PrecoCusto with &cSProTMP->PrecoCusto
        replace Unidade    with &cSProTMP->Unidade    
        dbunlock ()
      endif

      select ProdARQ
      set order to 1
      dbseek( cPrAnt, .f. )
      if found ()
        if RegLock()
          replace Qtde         with Qtde + nQtAnt
          replace UltA         with dEmis
          replace UltE         with dEmis
          dbunlock ()
        endif
      endif

      if !lLixo
        dbseek( cProd, .f. )
        if found ()
          if RegLock()
            replace Qtde         with Qtde - nQtde
            replace UltA         with dEmis
            replace UltE         with dEmis
            dbunlock ()
          endif
        endif
      endif

      select ISPrARQ

      if lLixo
        if RegLock()
          dbdelete ()
          dbunlock ()
       endif
      endif
    endif

    select( cSProTMP )
    dbskip ()
  enddo

  set deleted on
  
  select SProARQ
return NIL

//
// Imprime Dados da Entrada
//
function PrinSPro ( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "ProdARQ", .t. )
      VerifIND( "ProdARQ" )
  
      eOpenProd := .t.
       
      #ifdef DBF_NTX
        set index to ProdIND1, ProdIND2
      #endif
    else
      eOpenProd := .f.  
    endif

    if NetUse( "SProARQ", .t. )
      VerifIND( "SProARQ" )
  
      eOpenSPro := .t.
  
      #ifdef DBF_NTX
        set index to SProIND1
      #endif
    else
      eOpenSPro := .f.  
    endif

    if NetUse( "ISPrARQ", .t. )
      VerifIND( "ISPrARQ" )
  
      eOpenISPr := .t.
  
      #ifdef DBF_NTX
        set index to ISPrIND1
      #endif
    else
      eOpenISPr := .f.  
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 08, 08, 12, 70, mensagem( 'Janela', 'PrinSPro', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,10 say '    Saida Inicial                 Saida Final'
  @ 11,10 say '     Data Inicial                  Data Final'

  select SProARQ
  set order to 1   
  dbgotop ()
  nNotaIni := val ( Nota )
  dbgobottom ()
  nNotaFin := val ( Nota )

  dDataIni := ctod ('01/01/90')
  dDataFin := date ()

  @ 10,28 get nNotaIni          pict '999999' 
  @ 10,56 get nNotaFin          pict '999999'     valid nNotaFin >= nNotaIni
  @ 11,28 get dDataIni          pict '99/99/9999' 
  @ 11,56 get dDataFin          pict '99/99/9999'   valid dDataFin >= dDataIni
  read

  if lastkey() == K_ESC
    select SProARQ
    if lAbrir
      close
      select ProdARQ
      close
      select ISPrARQ
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

  cNotaIni := strzero( nNotaIni, 6 )
  cNotaFin := strzero( nNotaFin, 6 )
  cDataIni := dtos( dDataIni )
  cDataFin := dtos( dDataFin )
  lInicio  := .t.

  select SProARQ
  set order to 1
  dbseek( cNotaIni, .t. )
  do while Nota >= cNotaIni .and. Nota <= cNotaFin .and. !eof ()              
    if Emis >= dDataIni .and. Emis <= dDataFin
      if lInicio
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
        
        lInicio := .f.
      endif
        
      if nLin == 0
        Cabecalho ( 'Saidas Alternativas', 80, 2 )
        CabSPro ()
      endif
    
      @ nLin,01 say Nota
      @ nLin,08 say Emis                 pict '99/99/9999'
      @ nLin,18 say Obse                 pict '@S50' 
      nLin ++
  
      nValorTotal := nTotalNota := 0
      cNota       := Nota
 
      select ISPrARQ
      set order    to 1
      set relation to Prod into ProdARQ
      dbseek( cNota, .t. )
      do while Nota == cNota .and. !eof ()
        nValorTotal := Qtde * PrecoVenda
        nTotalNota  += nValorTotal
 
        @ nLin, 08 say Sequ
        @ nLin, 11 say Prod
        if Prod == '999999'
          @ nLin, 16 say memoline( Produto, 28, 1 )
        else  
          @ nLin, 16 say ProdARQ->Nome     pict '@S28'
        endif  
        if EmprARQ->Inteira == "X"
          @ nLin, 47 say Qtde              pict '@E 999999999'
        else  
          @ nLin, 47 say Qtde              pict '@E 99999.999'
        endif  
        @ nLin, 57 say PrecoVenda          pict PictPreco(10)
        @ nLin, 69 say nValorTotal         pict '@E 999,999.99'
        nLin ++

        if nLin >= pLimite
          Rodape(80) 

          cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
          cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

          set printer to ( cArqu2 )
          set printer on
        
          select SProARQ
        
          Cabecalho ( 'Saidas Alternativas', 80, 2 )
          CabSPro   ()
       
          @ nLin,01 say Nota
          @ nLin,08 say Emis                 pict '99/99/9999'
          @ nLin,17 say Obse                 pict '@S50' 
          nLin ++ 
          select ISPrARQ
        endif
      
        dbskip ()
      enddo
    
      select SProARQ

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
 
  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 80 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Relatório de Saidas Alternativas"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
    close
  endif  

  select SProARQ
  if lAbrir
    close
    select ProdARQ
    close
    select ISPrARQ
    close
  else
    set order  to 1 
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabSPro ()
  @ 02,01 say 'Nota   Data     Observação'
  @ 03,01 say '     Seq. Prod Descrição                          Qtde.   P. Unit. Valor Total'

  nLin := 5  
return NIL


//
// Imprime Media dos Produtos
//
function PrinMedia ( lAbrir, xTipo )

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

    if NetUse( "NSaiARQ", .t. )
      VerifIND( "NSaiARQ" )

      #ifdef DBF_NTX
        set index to NSaiIND1, NSaiIND2, NSaiIND3, NSaiIND4
      #endif
    endif

    if NetUse( "INSaARQ", .t. )
      VerifIND( "INSaARQ" )
  
      #ifdef DBF_NTX
        set index to INSaIND1
      #endif
    endif

    if NetUse( "SProARQ", .t. )
      VerifIND( "SProARQ" )
  
      #ifdef DBF_NTX
        set index to SProIND1, SProIND2
      #endif
    endif

    if NetUse( "ISPrARQ", .t. )
      VerifIND( "ISPrARQ" )
  
      #ifdef DBF_NTX
        set index to ISPrIND1
      #endif
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 06, 23, 09, 53, mensagem( 'Janela', 'PrinMedia', .f. ), .f. )

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
      select NSaiARQ
      close
      select INSaARQ
      close
      select SProARQ
      close
      select ISPrARQ
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

  select ProdARQ
  set order to 1

  select INSaARQ
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

  select NSaiARQ
  set order to 4
  dbseek( dMes01Ini, .t. )
  do while !eof ()
    if Emis >= dMes01Ini .and. Emis <= dMes03Fin
      select INSaARQ
      set order    to 1
      set relation to Prod into ProdARQ
      dbseek( NSaiARQ->Nota, .t. )
      do while Nota == NSaiARQ->Nota .and. !eof()
        if Prod != '9999'
          nElem := ascan( aProdutos, { |nElem| nElem[1] == Prod } )
        
          if nElem > 0    
            if NSAiARQ->Emis >= dMes01Ini .and. NSaiARQ->Emis <= dMes01Fin
              aProdutos[ nElem, 4 ] += Qtde
            endif  
            if NSAiARQ->Emis >= dMes02Ini .and. NSaiARQ->Emis <= dMes02Fin
              aProdutos[ nElem, 5 ] += Qtde
            endif  
            if NSAiARQ->Emis >= dMes03Ini .and. NSaiARQ->Emis <= dMes03Fin
              aProdutos[ nElem, 6 ] += Qtde
            endif  
          else
            if NSAiARQ->Emis >= dMes01Ini .and. NSaiARQ->Emis <= dMes01Fin
              aadd( aProdutos, { Prod, ProdARQ->Nome, ProdARQ->Unid, Qtde, 0, 0, ProdARQ->Qtde, ProdARQ->EstqMini } )
            endif
            if NSAiARQ->Emis >= dMes02Ini .and. NSaiARQ->Emis <= dMes02Fin
              aadd( aProdutos, { Prod, ProdARQ->Nome, ProdARQ->Unid, 0, Qtde, 0, ProdARQ->Qtde, ProdARQ->EstqMini } )
            endif
            if NSAiARQ->Emis >= dMes03Ini .and. NSaiARQ->Emis <= dMes03Fin
              aadd( aProdutos, { Prod, ProdARQ->Nome, ProdARQ->Unid, 0, 0, Qtde, ProdARQ->Qtde, ProdARQ->EstqMini } )
            endif
          endif
        endif
        dbskip()
      enddo
      
      select NSaiARQ
    endif
    dbskip()
  enddo

  select SProARQ
  set order to 2
  dbseek( dMes01Ini, .t. )
  do while !eof ()
    if Emis >= dMes01Ini .and. Emis <= dMes03Fin
      select ISPrARQ
      set order    to 1
      set relation to Prod into ProdARQ
      dbseek( SProARQ->Nota, .t. )
      do while Nota == SProARQ->Nota .and. !eof()
        if Prod != '9999'
          nElem := ascan( aProdutos, { |nElem| nElem[1] == Prod } )
        
          if nElem > 0    
            if SProARQ->Emis >= dMes01Ini .and. SProARQ->Emis <= dMes01Fin
              aProdutos[ nElem, 4 ] += Qtde
            endif  
            if SProARQ->Emis >= dMes02Ini .and. SProARQ->Emis <= dMes02Fin
              aProdutos[ nElem, 5 ] += Qtde
            endif  
            if SProARQ->Emis >= dMes03Ini .and. SProARQ->Emis <= dMes03Fin
              aProdutos[ nElem, 6 ] += Qtde
            endif  
          else
            if SProARQ->Emis >= dMes01Ini .and. SProARQ->Emis <= dMes01Fin
              aadd( aProdutos, { Prod, ProdARQ->Nome, ProdARQ->Unid, Qtde, 0, 0, ProdARQ->Qtde, ProdARQ->EstqMini } )
            endif
            if SProARQ->Emis >= dMes02Ini .and. SProARQ->Emis <= dMes02Fin
              aadd( aProdutos, { Prod, ProdARQ->Nome, ProdARQ->Unid, 0, Qtde, 0, ProdARQ->Qtde, ProdARQ->EstqMini } )
            endif
            if SProARQ->Emis >= dMes03Ini .and. SProARQ->Emis <= dMes03Fin
              aadd( aProdutos, { Prod, ProdARQ->Nome, ProdARQ->Unid, 0, 0, Qtde, ProdARQ->Qtde, ProdARQ->EstqMini } )
            endif
          endif
        endif
        dbskip()
      enddo
      
      select SProARQ
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
        Cabecalho ( 'Produtos - Media Venda', 132, 2 )
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
      if EmprARQ->Inteira == " "  
        @ nLin,051 say aProdutos[ nI, 4 ]   pict '@E 999999.999'
        @ nLin,062 say aProdutos[ nI, 5 ]   pict '@E 999999.999'
        @ nLin,073 say aProdutos[ nI, 6 ]   pict '@E 999999.999'
        @ nLin,084 say nMedia               pict '@E 999999.999'
        @ nLin,095 say aProdutos[ nI, 7 ]   pict '@E 999999.999'
        @ nLin,106 say aProdutos[ nI, 8 ]   pict '@E 999999.999'
      else  
        @ nLin,051 say aProdutos[ nI, 4 ]   pict '@E 9999999999'
        @ nLin,062 say aProdutos[ nI, 5 ]   pict '@E 9999999999'
        @ nLin,073 say aProdutos[ nI, 6 ]   pict '@E 9999999999'
        @ nLin,084 say nMedia               pict '@E 9999999999'
        @ nLin,095 say aProdutos[ nI, 7 ]   pict '@E 9999999999'
        @ nLin,106 say aProdutos[ nI, 8 ]   pict '@E 9999999999'
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
      replace Titu       with "Relatório de Produtos - Media Venda"
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
    select NSaiARQ
    close
    select INSaARQ
    close
    select SProARQ
    close
    select ISPrARQ
    close
  else 
    select ProdARQ
    set order  to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabMedia()
  @ 02,01 say 'Cod   Descricao                              Uni'
  @ 02,54 say strzero( month( dMes01Ini ), 2 ) + "/" + alltrim(str(year(dMes01Ini)))
  @ 02,65 say strzero( month( dMes02Ini ), 2 ) + "/" + alltrim(str(year(dMes02Ini)))
  @ 02,76 say strzero( month( dMes03Ini ), 2 ) + "/" + alltrim(str(year(dMes03Ini)))
  @ 02,89 say 'Media    Estoque     Minimo'

  nLin := 04
return NIL