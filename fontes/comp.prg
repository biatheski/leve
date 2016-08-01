//  Leve, Ordem de Produtos
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

function Comp ()

if NetUse( "FornARQ", .t. )
  VerifIND( "FornARQ" )
  
  #ifdef DBF_NTX
    set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
  #endif
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

if NetUse( "CompARQ", .t. )
  VerifIND( "CompARQ" )
  
  sOpenComp := .t.
  
  #ifdef DBF_NTX
    set index to CompIND1
  #endif
else
  sOpenComp := .f.  
endif

if NetUse( "IComARQ", .t. )
  VerifIND( "IComARQ" )
  
  sOpenICom := .t.
  
  #ifdef DBF_NTX
    set index to IComIND1
  #endif
else
  sOpenICom := .f.  
endif

//  Variaveis para Saida de dados
nNota        := nQtde       := 0
cNota        := cNotaNew    := space(06)
dEmis        := date()
nTotalNota   := nPrecoTotal := nSequ   := 0
nPrecoCusto  := nSequPrx    := nCond   := nForn := 0
cSequ        := cCond       := space(02)
cProd        := cForn       := space(04)
cObse        := cPraz       := cValid  := space(50)
cProduto     := space(40)
aOpcoes      := aArqui      := {}
cCompARQ     := CriaTemp(0)
cCompIND1    := CriaTemp(1)
cChave       := "Sequ"

aadd( aArqui, { "Sequ",       "C", 002, 0 } )
aadd( aArqui, { "Prod",       "C", 006, 0 } )
aadd( aArqui, { "Produto",    "C", 040, 0 } )
aadd( aArqui, { "Qtde",       "N", 012, 3 } )
aadd( aArqui, { "PrecoCusto", "N", 015, 6 } )
aadd( aArqui, { "Unidade", "C", 003, 0 } )
aadd( aArqui, { "Regi",       "N", 008, 0 } )
aadd( aArqui, { "Novo",       "L", 001, 0 } )
aadd( aArqui, { "Lixo",       "L", 001, 0 } )

dbcreate( cCompARQ , aArqui )
   
if NetUse( cCompARQ, .f. )
  cCompTMP := alias ()
    
  index on &cChave to &cCompIND1

  #ifdef DBF_NTX
    set index to &cCompIND1
  #endif
endif
 
Janela ( 01, 02, 21, 76, mensagem( 'Janela', 'OrdP', .f. ), .t. )
setcolor ( CorJanel + ',' + CorCampo )

@ 03,03 say '      Ordem                                           Emissão' 
@ 05,03 say ' Fornecedor'
@ 06,03 say 'Cond. Pgto.'
@ 07,03 say 'Prazo Entr.'
@ 08,03 say '   Validade'
@ 09,03 say ' Observação'

@ 11,03 say 'Codigo Descricao              Referência     Qtde.   P. Custo   V. Total'
@ 12,02 say chr(195) + replicate( chr(196), 73 ) + chr(180)
@ 12,09 say chr(194)
@ 12,33 say chr(194)
@ 12,44 say chr(194)
@ 12,54 say chr(194)
@ 12,65 say chr(194)

for nY := 13 to 16
  @ nY,09 say chr(179)
  @ nY,33 say chr(179)
  @ nY,44 say chr(179)
  @ nY,54 say chr(179)
  @ nY,65 say chr(179)
next  
  
@ 17,02 say chr(195) + replicate( chr(196), 73 ) + chr(180)
@ 17,09 say chr(193)
@ 17,33 say chr(193)
@ 17,44 say chr(193)
@ 17,54 say chr(193)
@ 17,65 say chr(193)
   
@ 18,49 say 'Total Ordem'

MostGeral( 20, 04, 16, 34, 52, 65, ' FAX ', 'F', 2 ) 

tSnot := savescreen( 00, 00, 24, 79 )
  
select CompARQ
set order    to 1
set relation to Forn into FornARQ
if sOpenComp
  dbgobottom ()
endif  

do while .t.
  cStat := cStatAux := space(04)
  restscreen( 00, 00, 23, 79, tSnot )

  Mensagem( 'Comp','Janela')
  
  select( cCompTMP )
  set order    to 1
  set relation to Prod into ProdARQ
  zap
  
  select FornARQ
  set order to 1
  
  select ProdARQ
  set order to 1

  select IComARQ
  set relation to Prod into ProdARQ
  set order    to 1

  select CompARQ
  set order    to 1
  set relation to Forn into FornARQ

  MostComp ()
  
  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostComp'
  cAjuda   := 'Comp'
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

  //  Verificar existencia das Notas para Incluir ou Alterar
  select CompARQ
  set order to 1
  dbseek( cNota, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif

  Mensagem ('Comp',cStat)
  
  select IComARQ
  set order to 1
  dbseek( cNota, .t. )
  do while Nota == cNota .and. !eof()
    nRegi := recno ()
    
    select( cCompTMP )
    if AdiReg()
      if RegLock()
        replace Sequ       with IComARQ->Sequ
        replace Prod       with IComARQ->Prod
        replace Produto    with IComARQ->Produto
        replace Qtde       with IComARQ->Qtde
        replace PrecoCusto with IComARQ->PrecoCusto
        replace Regi       with nRegi
        replace Novo       with .f.
        replace Lixo       with .f.
        dbunlock ()
      endif
    endif
    
    select IComARQ
    dbskip ()
  enddo
  
  cStatAnt := cStat
  
  select CompARQ

  MostComp ()
  EntrComp ()  
  EntrItOD ()
  
  ConfGeral( 20, 04, 16, 34, 52, 65, ' FAX ', 'F', 2, 1 )
  
  if lastkey() == K_ESC .or. cStat == 'loop'
    loop
  endif  
      
  if cStat == 'excl'
    EstoComp ()
  endif
  
  if cStatAnt == 'incl'
    if nNota == 0
      select EmprARQ
      set order to 1
      dbseek( cEmpresa, .f. )

      nNotaNew := OrdC + 1
      
      do while .t.
        cNotaNew := strzero( nNotaNew, 6 )
        
        CompARQ->( dbseek( cNotaNew, .f. ) )
        
        if CompARQ->( found() )
          nNotaNew ++
          loop
        else
          select EmprARQ
          if RegLock()
            replace OrdC       with nNotaNew
            dbunlock ()
          endif  
          exit
        endif  
      enddo     
    endif  

    select CompARQ 
    set order to 1
    if AdiReg()
      if RegLock()
        replace Nota       with cNotaNew
        dbunlock ()
      endif
    endif
  endif  
  
  select CompARQ
  
  if cStatAnt == 'incl' .or. cStatAnt == 'alte'
    if RegLock()
      replace Emis       with dEmis
      replace Obse       with cObse
      replace Cond       with cCond
      replace Forn       with cForn
      replace Praz       with cPraz
      replace Valid      with cValid
      replace TotalNota  with nTotalNota
      dbunlock ()
    endif
  endif

  GravComp ()

  if cStat == 'prin'
    ImprOrdC (.t.)
  endif
  
  if cStat == 'gene'
    PrinFAX ()
  endif

  if nNota == 0
    Alerta( mensagem( 'Alerta', 'OrdP', .f. ) + ' ' + cNotaNew )
  endif  
enddo

if sOpenProd
  select ProdARQ
  close
endif

if sOpenComp
  select CompARQ
  close
endif

if sOpenICom
  select IComARQ
  close
endif

select( cCompTMP )
close
ferase( cCompARQ )
ferase( cCompIND1 )

return NIL

//
// Mostra os dados
//
function MostComp()
  if cStat != 'incl'  
    cNota := Nota    
    nNota := val( Nota )
    
    setcolor( CorCampo )
    @ 03,15 say cNota            pict '999999'
  endif  
 
  cNotaNew   := cNota   
  dEmis      := Emis  
  cObse      := Obse
  cPraz      := Praz
  cValid     := Valid
  cCond      := Cond
  cForn      := Forn
  nForn      := val( Forn )
  nLin       := 13
  nTotalNota := TotalNota
  
  setcolor( CorCampo )
  @ 03,65 say dEmis              pict '99/99/9999'
  @ 05,15 say cForn              pict '999999'
  @ 05,22 say FornARQ->Nome      pict '@S40'
  @ 06,15 say cCond
  @ 07,15 say cPraz
  @ 08,15 say cValid
  @ 09,15 say cObse

  if cStat == 'alte' .or. cStat == space(04)
    setcolor( CorJanel )
    for nG := 1 to 4 
      @ nLin, 03 say '      '    
      @ nLin, 10 say space(23)
      @ nLin, 34 say space(10)
      @ nLin, 45 say '         '
      @ nLin, 55 say '          '
      @ nLin, 66 say '          '
      nLin ++
    next
    nLin := 13

    setcolor( CorJanel )
    select IComARQ
    set order    to 1
    set relation to Prod into ProdARQ
    dbseek( cNota, .t. )
    do while Nota == cNota .and. !eof()
      @ nLin, 03 say Prod                  pict '999999'    
      if Prod == '999999' 
        @ nLin, 10 say Produto             pict '@S23'
      else
        @ nLin, 10 say ProdARQ->Nome       pict '@S23'
      endif     
      @ nLin, 34 say ProdARQ->Refe         pict '@S10'
      if EmprARQ->Inteira == "X"
        @ nLin, 45 say Qtde                  pict '@E 999999999'
      else      
        @ nLin, 45 say Qtde                  pict '@E 99999.999'
      endif     
      @ nLin, 55 say PrecoCusto            pict PictPreco(10)
      @ nLin, 66 say Qtde * PrecoCusto     pict '@E 999,999.99'

      nLin ++
      dbskip ()
      if nLin >= 17
        exit
      endif   
    enddo
  else
    setcolor( CorJanel )
    for nG := 1 to 4 
      @ nLin, 03 say '      '    
      @ nLin, 10 say space(23)
      @ nLin, 34 say space(10)
      @ nLin, 45 say '         '
      @ nLin, 55 say '          '
      @ nLin, 66 say '          '
      nLin ++
    next
  endif  
  
  setcolor( CorCampo )
  @ 18,61 say nTotalNota             pict '@E 999,999,999.99'

  select CompARQ
  
  PosiDBF( 01, 76 )
return NIL

//
// Entra os dados
//
function EntrComp ()
  local GetList := {}

  if empty( dEmis )
    dEmis := date()
  endif  
  
  do while .t.
    lAlterou := .f.
      
    setcolor ( CorJanel + ',' + CorCampo )
    @ 03,65 get dEmis        pict '99/99/9999'
    @ 05,15 get nForn        pict '999999'  valid ValidForn ( 05, 15, "CompARQ" )
    @ 06,15 get cCond
    @ 07,15 get cPraz           
    @ 08,15 get cValid           
    @ 09,15 get cObse           
    read

    if dEmis      != Emis;        lAlterou := .t.
    elseif nForn  != val( Forn ); lAlterou := .t.
    elseif cCond  != Cond;        lAlterou := .t.
    elseif cPraz  != Praz;        lAlterou := .t.
    elseif cValid != Valid;       lAlterou := .t.       
    elseif cObse  != Obse;        lAlterou := .t.  
    endif
    
    if !Saindo(lAlterou)
      loop
    endif  
    exit
  enddo  
  
  cForn := strzero( nForn, 6 )
return NIL    

//
// Entra com os itens 
//
function EntrItOD()
  local GetList := {}

  if lastkey () == K_ESC .or. lastkey () == K_PGDN
    return NIL
  endif  

  setcolor ( CorJanel + ',' + CorCampo )

  select( cCompTMP )
  set order    to 1
  set relation to Prod into ProdARQ

  bFirst := {|| dbseek( '0001', .t. ) }
  bLast  := {|| dbseek( '9999', .t. ), dbskip(-1) }
  bFor   := {|| .t. }
  bWhile := {|| .t. }

  oColuna         := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oColuna:nTop    := 11
  oColuna:nLeft   := 3
  oColuna:nBottom := 17
  oColuna:nRight  := 75
  oColuna:headsep := chr(194)+chr(196)
  oColuna:colsep  := chr(179)
  oColuna:footsep := chr(193)+chr(196)

  oColuna:addColumn( TBColumnNew("Código", {|| Prod } ) )
  oColuna:addColumn( TBColumnNew("Descricao", {|| iif( Prod == '999999', left( Produto, 23 ),  left( ProdARQ->Nome, 23 ) ) } ) )
  oColuna:addColumn( TBColumnNew("Referˆncia", {|| left( ProdARQ->Refe, 10 ) } ) )
  if EmprARQ->Inteira == "X"
    oColuna:addColumn( TBColumnNew("    Qtde.", {|| transform( Qtde, '@E 999999999' ) } ) )
  else  
    oColuna:addColumn( TBColumnNew("    Qtde.", {|| transform( Qtde, '@E 99999.999' ) } ) )
  endif  
  oColuna:addColumn( TBColumnNew("  P. Custo", {|| transform( PrecoCusto, PictPreco(10) ) } ) )
  oColuna:addColumn( TBColumnNew("  V. Total", {|| transform( PrecoCusto * Qtde, '@E 999,999.99' ) } ) )
            
  lExitRequested := .f.
  lAlterou       := .f.

  oColuna:goBottom()

  do while !lExitRequested
    Mensagem ( 'LEVE','Browse' )
 
    oColuna:forcestable()

    if oColuna:hitTop .and. !empty( Prod )
      oColuna:refreshAll ()
      
      EntrComp ()
    
      select( cCompTMP )
      loop
    endif
    
    if !lAlterou .and. cStat == 'incl' .or. ( oColuna:hitTop .and. !empty( Prod ) )
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
        if Saindo(lAlterou)
          lExitRequested := .t.
        else  
          lExitRequested := .f.
        endif  
      case cTecla == 46;            lExitRequested := .t.
      case cTecla == K_ENTER;       EntrItComp(.f.)
      case cTecla == K_INS
        do while lastkey() != K_ESC    
          EntrItComp(.t.)
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
function EntrItComp( lAdiciona )
  local GetList := {}

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
      
    Mensagem( 'OrdP', 'ItCompIncl' )
  else
    Mensagem( 'OrdP', 'ItCompAlte' )
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
  nLin        := 12 + oColuna:rowPos
  lAlterou    := .t.
    
  setcolor( CorCampo )
  @ nLin, 10 say ProdARQ->Nome         pict '@S23'
  @ nLin, 34 say ProdARQ->Refe         pict '@S10'
  @ nLin, 66 say nQtde * PrecoCusto    pict '@E 999,999.99'
  
  set key K_UP to UpNota ()
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ nLin, 03 get cProd         pict '@K'            valid ValidProd( nLin, 03, cCompTMP, 'comp', nPrecoCusto, 0 )
  if EmprARQ->Inteira == "X"
    @ nLin, 45 get nQtde       pict '@E 999999999'  valid VoltaUp()
  else  
    @ nLin, 45 get nQtde       pict '@E 99999.999'  valid VoltaUp()
  endif  
  @ nLin, 55 get nPrecoCusto   pict PictPreco(10)
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
  
    oColuna:goBottom() 
  endif
 
  setcolor( CorCampo )
  @ 18,61 say nTotalNota       pict '@E 999,999,999.99'
return NIL     

//
// Excluir nota
//
function EstoComp ()
  cStat  := 'loop' 
  
  select CompARQ

  if ExclRegi ()
    select IComARQ
    set order to 1
    dbseek( cNota, .t. )
    do while Nota == cNota
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif
        
      dbskip ()
    enddo    
    
    select CompARQ
  endif
return NIL

//
// Entra o estoque
//
function GravComp()
  
  set deleted off

  select( cCompTMP )
  set order to 1
  dbgotop ()
  do while !eof ()
    if empty( Prod )
      dbskip ()
      loop
    endif

    cProd       := Prod
    nQtde       := Qtde
    nPrecoCusto := PrecoCusto
    nRegi       := Regi
    lLixo       := Lixo

    if Novo
      if Lixo
        dbskip ()
        loop
      endif

      select IComARQ
      set order to 1
      dbseek( cNotaNew + &cCompTMP->Sequ, .f. )
      
      if found ()
        if RegLock(0)
          dbdelete ()
          dbunlock ()
        endif  
      endif     
      
      if AdiReg()
        if RegLock()
          replace Nota       with cNotaNew
          replace Sequ       with &cCompTMP->Sequ
          replace Prod       with &cCompTMP->Prod
          replace Produto    with &cCompTMP->Produto
          replace Qtde       with &cCompTMP->Qtde
          replace PrecoCusto with &cCompTMP->PrecoCusto
          dbunlock ()
        endif
      endif
    else
      select IComARQ
      go nRegi

      if RegLock()
        replace Prod            with &cCompTMP->Prod
        replace Produto         with &cCompTMP->Produto
        replace Qtde            with &cCompTMP->Qtde
        replace PrecoCusto      with &cCompTMP->PrecoCusto
        dbunlock ()
      endif

      if lLixo
        if RegLock()
          dbdelete ()
          dbunlock ()
       endif
      endif
    endif

    select( cCompTMP )
    dbskip ()
  enddo

  set deleted on
  
  select CompARQ
return NIL

//
// Imprimir Ordem de Compra
//
function PrinOrdC ( lTipo )

return(.t.)

//
// Imprimir Ordem de Compra
//
function ImprOrdC ( lTipo )

  if !TestPrint(1)
    return NIL
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )
  
  @ 00, 00 say ' '
  @ 00, 00 say chr(27) + "@"
  @ 00, 00 say chr(15)

  nLin  := 0
  
  select CompARQ
  
  @ nLin,001 say '+---------------------------------------------------------------------------------------------------------------------------------+'    
  nLin ++ 
  @ nLin,001 say '| ' + EmprARQ->Razao
  @ nLin,131 say '|'
  nLin ++ 
  @ nLin,001 say '| ' + EmprARQ->Ende
  @ nLin,101 say 'Ordem de Compra N.'
  @ nLin,120 say Nota                            pict '999999'
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '| ' + transform( EmprARQ->CEP, '99999-999' ) + '   ' + left( EmprARQ->Bairro, 15 ) + '   ' + alltrim( EmprARQ->Cida ) + '/' + EmprARQ->UF
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '| ' + EmprARQ->Fone + '     ' + EmprARQ->Fax                     
  @ nLin,112 say 'Emissão ' + dtoc( dEmis )
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '| '
  @ nLin,003 say EmprARQ->CGC                     pict '@R 99.999.999/9999-99'
  @ nLin,026 say EmprARQ->InscEstd                
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '+---------------------------------------------------------------------------------------------------------------------------------+'    
  nLin ++
  @ nLin,001 say '| Fornecedor ' + left( FornARQ->Nome, 40 )
  @ nLin,055 say 'Código ' + cForn
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '|   Endereço ' + left( FornARQ->Ende, 40 )
  @ nLin,055 say 'CEP ' + transform( FornARQ->CEP, '99999-999' )
  @ nLin,075 say 'Bairro ' + left( FornARQ->Bairro, 15 )
  @ nLin,100 say 'Cidade ' + left( FornARQ->Cida, 15 )
  @ nLin,125 say 'UF ' + FornARQ->UF + ' |'
  nLin ++
  @ nLin,001 say '|       Fone ' + FornARQ->Fone                                                                                                                         
  @ nLin,034 say 'Fax ' + FornARQ->Fax 
  @ nLin,057 say 'CNPJ ' 
  @ nLin,062 say FornARQ->CGC        pict '@R 99.999.999/9999-99'
  @ nLin,092 say 'Insc. Estadual ' + FornARQ->InscEstd
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '|    Contato ' + alltrim( FornARQ->Contato )                                                                                                                      
  @ nLin,056 say 'Ramal ' + FornARQ->Ramal
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '+---------------------------------------------------------------------------------------------------------------------------------+'
 nLin ++
  @ nLin,001 say '| Conforme a descrição e condições de compra abaixo solicitamos a remessa dos seguintes produtos:                                 |'
  nLin ++
  @ nLin,001 say '|                                                                                                                                 |'
  nLin ++
  @ nLin,001 say '+--------+--------------------------------------------------------+--------------------+----------------+------------+------------+'
  nLin ++
  @ nLin,001 say '| Codigo | Descrição dos Produtos                               | Referencia           |     Quantidade |   P. Custo |   V. Total |'
  nLin ++
  @ nLin,001 say '+--------+------------------------------------------------------+----------------------+----------------+------------+------------+'
  nLin  ++
  nSequ := 0

  select( cCompTMP )
  set order    to 1
  set relation to Prod into ProdARQ
  dbgotop()
  do while !eof()
    @ nLin,001 say '|'
    @ nLin,003 say Prod           pict '9999' 
    @ nLin,008 say '|'
    if Prod == '999999' 
      @ nLin,012 say left( Produto, 50 )
    else      
      @ nLin,012 say left( ProdARQ->Nome, 50 ) 
    endif     
    @ nLin,065 say '|'
    @ nLin,067 say left( ProdARQ->Refe, 20 ) 
    @ nLin,088 say '|'
    if EmprARQ->Inteira == "X"
      @ nLin,090 say Qtde                   pict '@E 99999999999999'
    else  
      @ nLin,090 say Qtde                   pict '@E 99,999,999.999'
    endif  
    @ nLin,105 say '|'
    @ nLin,107 say PrecoCusto             pict PictPreco(10)
    @ nLin,118 say '|'
    @ nLin,120 say ( Qtde * PrecoCusto )  pict '@E 999,999.99'
    @ nLin,131 say '|'

    nSequ ++
    nLin  ++
      
    dbskip ()
  enddo  
    
  select CompARQ

  for nK := 1 to ( 31 - nSequ )
    @ nLin,001 say '|        |                                                      |                      |                |            |            |'
    nLin ++
  next  
  @ nLin,001 say '+--------+------------------------------------------------------+----------------------+----------------+------------+------------+'
  nLin ++
  @ nLin,001 say '| Cond. Pagamento ' + alltrim( Cond )
  @ nLin,109 say 'Sub-Total'
  @ nLin,120 say nTotalNota          pict '@E 999,999.99'
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '|   Prazo Entrega ' + alltrim( Praz )
  @ nLin,110 say 'Desconto  __________ |'
  nLin ++
  @ nLin,001 say '|        Validade ' + alltrim( Valid )
  @ nLin,109 say 'Valor IPI  __________ |'
  nLin ++
  @ nLin,001 say '|  Transportadora ________________________________________                                                Valor Total  __________ |'
  nLin ++
  @ nLin,001 say '+---------------------------------------------------------------------------------------------------------------------------------+'
  nLin ++
  @ nLin,001 say '|      Observação ' + Obse
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '|                 _______________________________________________________________________________________________________________ |'
  nLin ++
  @ nLin,001 say '|                 _______________________________________________________________________________________________________________ |'
  nLin ++
  @ nLin,001 say '|                 _______________________________________________________________________________________________________________ |' 
  nLin ++
  @ nLin,001 say '+---------------------------------------------------------------------------------------------------------------------------------+'

  nLin += 2
  @ nLin, 00 say space(01)
  @ nLin, 00 say ' '
  @ nLin, 00 say chr(27) + "@"

  set device to screen

return NIL   


//
// Imprimir Ordem de Compra - FAX
//
function PrinFax ()
  local GetList := {}

  Janela( 06, 22, 11, 55, mensagem( 'Janela', 'PrinFax', .f. ), .f. )
  Mensagem( 'OrdP', 'PrinFax' )
  setcolor( CorJanel )
  @ 08,24 say 'Telefone'
  @ 10,24 say '   Porta    COM    Discagem'
  
  cFax  := FornARQ->Fax
  nPort := 4
  cDisc := 'T'
  
  setcolor( CorCampo )
  @ 08,33 get cFax                pict '@S20'
  @ 10,33 get nPort               pict '99'
  @ 10,52 get cDisc               pict '@!' valid cDisc == 'T' .or. cDisc == 'P'
  read
  
  if lastkey() == K_ESC
    return NIL
  endif
  
  if confalte()

  cArqu2 := cCaminho + HB_OSpathseparator() + "fax" + HB_OSpathseparator() + nota + ".txt"  

  set printer to ( cArqu2 )
  set device  to printer
  set printer on

  nLin  := 0
  
  select CompARQ
  
  @ nLin,001 say '+---------------------------------------------------------------------------------------------------------------------------------+'    
  nLin ++ 
  @ nLin,001 say '| ' + EmprARQ->Razao
  @ nLin,131 say '|'
  nLin ++ 
  @ nLin,001 say '| ' + EmprARQ->Ende
  @ nLin,101 say 'Ordem de Compra N.'
  @ nLin,120 say Nota                            pict '999999'
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '| ' + transform( EmprARQ->CEP, '99999-999' ) + '   ' + left( EmprARQ->Bairro, 15 ) + '   ' + alltrim( EmprARQ->Cida ) + '/' + EmprARQ->UF
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '| ' + EmprARQ->Fone + '     ' + EmprARQ->Fax                     
  @ nLin,112 say 'Emissão ' + dtoc( dEmis )
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '| '
  @ nLin,003 say EmprARQ->CGC                     pict '@R 99.999.999/9999-99'
  @ nLin,026 say EmprARQ->InscEstd                
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '+---------------------------------------------------------------------------------------------------------------------------------+'    
  nLin ++
  @ nLin,001 say '| Fornecedor ' + left( FornARQ->Nome, 40 )
  @ nLin,055 say 'Codigo ' + cForn
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '|   Endereço ' + left( FornARQ->Ende, 40 )
  @ nLin,055 say 'CEP ' + transform( FornARQ->CEP, '99999-999' )
  @ nLin,075 say 'Bairro ' + left( FornARQ->Bairro, 15 )
  @ nLin,100 say 'Cidade ' + left( FornARQ->Cida, 15 )
  @ nLin,125 say 'UF ' + FornARQ->UF + ' |'
  nLin ++
  @ nLin,001 say '|       Fone ' + FornARQ->Fone                                                                                                                         
  @ nLin,034 say 'Fax ' + FornARQ->Fax 
  @ nLin,057 say 'CNPJ ' 
  @ nLin,062 say FornARQ->CGC        pict '@R 99.999.999/9999-99'
  @ nLin,092 say 'Insc. Estadual ' + FornARQ->InscEstd
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '|    Contato ' + alltrim( FornARQ->Contato )                                                                                                                      
  @ nLin,056 say 'Ramal ' + FornARQ->Ramal
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '+---------------------------------------------------------------------------------------------------------------------------------+'
  nLin ++
  @ nLin,001 say '| Conforme a descrição e condições de compra abaixo solicitamos a remessa dos seguintes produtos:                                 |'
  nLin ++
  @ nLin,001 say '|                                                                                                                                 |'
  nLin ++
  @ nLin,001 say '+--------+------------------------------------------------------+----------------------+----------------+------------+------------+'
  nLin ++
  @ nLin,001 say '| Codigo | Descrição dos Produtos                               | Referencia           |     Quantidade |   P. Custo |   V. Total |'
  nLin ++
  @ nLin,001 say '+--------+------------------------------------------------------+----------------------+----------------+------------+------------+'
  nLin  ++
  nSequ := 0

  select( cCompTMP )
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
    @ nLin,067 say left( ProdARQ->Refe, 20 ) 
    @ nLin,088 say '|'
    if EmprARQ->Inteira == "X"
      @ nLin,090 say Qtde                   pict '@E 99999999999999'
    else  
      @ nLin,090 say Qtde                   pict '@E 99,999,999.999'
    endif  
    @ nLin,105 say '|'
    @ nLin,107 say PrecoCusto             pict PictPreco(10)
    @ nLin,118 say '|'
    @ nLin,120 say ( Qtde * PrecoCusto )  pict '@E 999,999.99'
    @ nLin,131 say '|'

    nSequ ++
    nLin  ++
      
    dbskip ()
  enddo  
    
  select CompARQ

  for nK := 1 to ( 31 - nSequ )
    @ nLin,001 say '|        |                                                      |                      |                |            |            |'
    nLin ++
  next  
  @ nLin,001 say '+--------+------------------------------------------------------+----------------------+----------------+------------+------------+'
  nLin ++
  @ nLin,001 say '| Cond. Pagamento ' + alltrim( Cond )
  @ nLin,109 say 'Sub-Total'
  @ nLin,120 say nTotalNota          pict '@E 999,999.99'
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '|   Prazo Entrega ' + alltrim( Praz )
  @ nLin,110 say 'Desconto  __________ |'
  nLin ++
  @ nLin,001 say '|        Validade ' + alltrim( Valid )
  @ nLin,109 say 'Valor IPI  __________ |'
  nLin ++
  @ nLin,001 say '|  Transportadora ________________________________________                                                Valor Total  __________ |'
  nLin ++
  @ nLin,001 say '+---------------------------------------------------------------------------------------------------------------------------------+'
  nLin ++
  @ nLin,001 say '|      Observação ' + Obse
  @ nLin,131 say '|'
  nLin ++
  @ nLin,001 say '|                 _______________________________________________________________________________________________________________ |'
  nLin ++
  @ nLin,001 say '|                 _______________________________________________________________________________________________________________ |'
  nLin ++
  @ nLin,001 say '|                 _______________________________________________________________________________________________________________ |' 
  nLin ++
  @ nLin,001 say '+---------------------------------------------------------------------------------------------------------------------------------+'

  set printer off
  set device to screen
  
  nHandle := fcreate( cCaminho + HB_OSpathseparator() + "FAX" + HB_OSpathseparator() + "SENDFAX.BAT", 0 )
 
  fwrite( nHandle, "@echo off" + chr(13) + chr(10) )       
  fwrite( nHandle, cCaminho + HB_OSpathseparator() + "FAX" + HB_OSpathseparator() + "SSFAXER.EXE " + alltrim( str( nPort ) ) + " " + cDisc + alltrim( cFax ) + " " + cCaminho + HB_OSpathseparator() + "FAX" + HB_OSpathseparator() + Nota + ".TXT" + chr(13) + chr(10) )

  fclose( nHandle )
  
  endif
  
return NIL