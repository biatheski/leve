//  Leve, Orçamento de Produtos
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

function Opro ()

if NetUse( "ReceARQ", .t. )
  VerifIND( "ReceARQ" )

  sOpenRece := .t.
  
  #ifdef DBF_NTX
    set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
  #endif
else
  sOpenRece := .f.  
endif

if NetUse( "ClieARQ", .t. )
  VerifIND( "ClieARQ" )
  
  sOpenClie := .t.
  
  #ifdef DBF_NTX
    set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
  #endif
else  
  sOpenClie := .f.
endif

if NetUse( "ReprARQ", .t. )
  VerifIND( "ReprARQ" )

  sOpenRepr := .t.

  #ifdef DBF_NTX
    set index to ReprIND1, ReprIND2
  #endif
else
  sOpenRepr := .f.  
endif

if NetUse( "CondARQ", .t. )
  VerifIND( "CondARQ" )
  
  sOpenCond := .t.
  
  #ifdef DBF_NTX
    set index to CondIND1, CondIND2
  #endif
else
  sOpenCond := .f.  
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

if NetUse( "OProARQ", .t. )
  VerifIND( "OProARQ" )
  
  sOpenOPro := .t.
  
  #ifdef DBF_NTX
    set index to OProIND1
  #endif
else
  sOpenOPro := .f.  
endif

if NetUse( "IOPrARQ", .t. )
  VerifIND( "IOPrARQ" )
  
  sOpenIOPr := .t.
  
  #ifdef DBF_NTX
    set index to IOPrIND1
  #endif
else
  sOpenIOPr := .f.  
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
nNota        := nQtde       := nClie   := 0
cNota        := cNotaNew    := cOPro   := space(06)
dEmis        := date()
nTotalNota   := nPrecoTotal := 0
nParcela     := 1
nPrecoVenda  := nCond       := nRepr     := 0
dVcto1       := dVcto2      := dVcto3  := dVcto4    := dVcto5  := ctod ('  /  /  ')
dVcto6       := dVcto7      := dVcto8  := dVcto9    := ctod ('  /  /  ')
nValor1      := nValor2     := nValor3 := nValor4   := nValor5 := 0
nValor6      := nValor7     := nValor8 := nValor9   := 0
cCond        := space(02)
cProd        := cClie       := cRepr       := space(04)
cObse        := cPraz       := cValid      := space(50)
cProduto     := space(40)
aOpcoes      := aArqui      := {}
cOProARQ     := CriaTemp(0)
cOProIND1    := CriaTemp(1)
cCliente     := space(40)
cChave       := "Sequ"

aadd( aArqui, { "Sequ",       "C", 004, 0 } )
aadd( aArqui, { "Prod",       "C", 006, 0 } )
aadd( aArqui, { "Produto",    "C", 040, 0 } )
aadd( aArqui, { "Desc",       "N", 012, 3 } )
aadd( aArqui, { "Qtde",       "N", 012, 3 } )
aadd( aArqui, { "PrecoVenda", "N", 015, 6 } )
aadd( aArqui, { "PrecoCusto", "N", 015, 6 } )
aadd( aArqui, { "Unidade",    "C", 003, 0 } )
aadd( aArqui, { "Regi",       "N", 008, 0 } )
aadd( aArqui, { "Novo",       "L", 001, 0 } )
aadd( aArqui, { "Lixo",       "L", 001, 0 } )

dbcreate( cOProARQ , aArqui )
   
if NetUse( cOProARQ, .f. )
  cOProTMP := alias ()
  
  #ifdef DBF_CDX    
    index on &cChave tag &cOProIND1
  #endif

  #ifdef DBF_NTX
    index on &cChave to &cOProIND1

    set index to &cOProIND1
  #endif
endif
 
Janela ( 01, 02, 21, 76, mensagem( 'Janela', 'OPro', .f. ), .t. )
setcolor ( CorJanel + ',' + CorCampo )
@ 03,03 say '  Orçamento                                       Emissão' 
@ 05,03 say '    Cliente'
@ 06,03 say 'Cond. Pgto.                                     Acréscimo'
@ 07,03 say 'Prazo Entr.                                      Validade'
@ 08,03 say ' Observação'
 
@ 10,03 say 'Código Descricao                 Qtde.     Desc. Preço Venda Preço Total'
@ 11,02 say chr(195) + replicate( chr(196), 73 ) + chr(180)
@ 11,09 say chr(194)
@ 11,35 say chr(194)
@ 11,45 say chr(194)
@ 11,51 say chr(194)
@ 11,63 say chr(194)

for nY := 12 to 16
  @ nY,09 say chr(179)
  @ nY,35 say chr(179)
  @ nY,45 say chr(179)
  @ nY,51 say chr(179)
  @ nY,63 say chr(179)
next  
  
@ 17,02 say chr(195) + replicate( chr(196), 73 ) + chr(180)
@ 17,09 say chr(193)
@ 17,35 say chr(193)
@ 17,45 say chr(193)
@ 17,51 say chr(193)
@ 17,63 say chr(193)

@ 18,04 say 'Vendedor'   
@ 18,45 say 'Total Orçamento'

MostOpcao( 20, 04, 16, 52, 65 ) 
tSnot := savescreen( 00, 00, 24, 79 )
  
select OProARQ
set order to 1
if sOpenOPro
  dbgobottom ()
endif  
do while .t.
  cStat := cStatAux := space(04)
  restscreen( 00, 00, 23, 79, tSnot )

  Mensagem( 'OPro', 'Janela' )
  
  select( cOProTMP )
  set order    to 1
  set relation to Prod into ProdARQ
  zap
  
  select ReprARQ
  set order to 1
  
  select CondARQ
  set order to 1
  
  select ProdARQ
  set order to 1
  
  select ClieARQ
  set order to 1

  select IOPrARQ
  set relation to Prod into ProdARQ
  set order    to 1

  select OProARQ
  set order to 1
  set relation to Clie into ClieARQ, to Cond into CondARQ, to Repr into ReprARQ

  MostOPro ()
  
  if Demo ()
    exit
  endif  
  
  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostOPro'
  cAjuda   := 'OPro'
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
  select OProARQ
  set order to 1
  dbseek( cNota, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif
  
  Mensagem ('OPro', cStat )

  select IOPrARQ
  set order to 1
  dbseek( cNota, .t. )
  do while Nota == cNota
    nRegi := recno ()
    
    select( cOProTMP )
    if AdiReg()
      if RegLock()
        replace Sequ       with IOPrARQ->Sequ
        replace Prod       with IOPrARQ->Prod
        replace Produto    with IOPrARQ->Produto
        replace Qtde       with IOPrARQ->Qtde
        replace Desc       with IOPrARQ->Desc
        replace PrecoVenda with IOPrARQ->PrecoVenda
        replace PrecoCusto with IOPrARQ->PrecoCusto 
        replace Unidade    with IOPrARQ->Unidade
        replace Regi       with nRegi
        replace Novo       with .f.
        replace Lixo       with .f.
        dbunlock ()
      endif
    endif
    
    select IOPrARQ
    dbskip ()
  enddo
  
  xStatAnt := cStat
  
  select OProARQ

  MostOPro ()
  EntrOPro ()  
  EntrItOP ()
  
  Confirmar( 20, 04, 16, 52, 65, 1 ) 
      
  if cStat == 'excl'
    EstoOPro ()
  endif
  
  if lastkey() == K_ESC .or. cStat == 'loop'
    loop
  endif  
  
  if xStatAnt == 'incl'
    if nNota == 0
      select EmprARQ
      set order to 1
      dbseek( cEmpresa, .f. )

      nNotaNew := OPro + 1
      
      do while .t.
        cNotaNew := strzero( nNotaNew, 6 )
        
        OProARQ->( dbseek( cNotaNew, .f. ) )
        
        if OProARQ->( found() )
          nNotaNew ++
          loop
        else
          select EmprARQ
          if RegLock()
            replace OPro       with nNotaNew
            dbunlock ()
          endif  
          exit
        endif  
      enddo     
    endif  

    select OProARQ 
    set order to 1
    if AdiReg()
      if RegLock()
        replace Nota       with cNotaNew
        dbunlock ()
      endif
    endif
  endif  
  
  select OProARQ
  
  if xStatAnt == 'incl' .or. xStatAnt == 'alte'
    if RegLock()
      replace Emis       with dEmis
      replace Obse       with cObse
      replace Clie       with cClie
      replace CLiente    with cCliente
      replace Cond       with cCond
      replace Repr       with cRepr
      replace Praz       with cPraz
      replace Valid      with cValid
      replace Vcto1      with dVcto1
      replace Valor1     with nValor1
      replace Vcto2      with dVcto2
      replace Valor2     with nValor2
      replace Vcto3      with dVcto3
      replace Valor3     with nValor3
      replace Vcto4      with dVcto4
      replace Valor4     with nValor4
      replace Vcto5      with dVcto5
      replace Valor5     with nValor5
      replace Vcto6      with dVcto6
      replace Valor6     with nValor6
      replace Vcto7      with dVcto7
      replace Valor7     with nValor7
      replace Vcto8      with dVcto8
      replace Valor8     with nValor8
      replace Vcto9      with dVcto9
      replace Valor9     with nValor9
      replace TotalNota  with nTotalNota
      dbunlock ()
    endif
  endif

  GravOPro ()

  if cStat == 'prin'
    PrinOrca (.t.)
  endif

  if nNota == 0
    Alerta( mensagem( 'Alerta', 'OPro', .f. ) + " " + cNotaNew )
  endif  
enddo

if sOpenRece
  select ReceARQ
  close
endif

if sOpenRepr
  select ReprARQ
  close
endif

if sOpenProd
  select ProdARQ
  close
endif

if sOpenCond
  select CondARQ
  close
endif

if sOpenOPro
  select OProARQ
  close
endif

if sOpenIOPr
  select IOPrARQ
  close
endif

if sOpenIPro
  select IProARQ
  close
endif

if sOpenClie
  select ClieARQ
  close
endif

select( cOProTMP )
close
ferase( cOProARQ )
ferase( cOProIND1 )

return NIL

//
// Mostra os dados
//
function MostOPro()
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
  cClie      := Clie
  nClie      := val( Clie ) 
  cRepr      := Repr
  nRepr      := val( Repr )
  cCond      := Cond
  nCond      := val( Cond ) 
  nLin       := 12
  nDesconto  := Desconto
  nTotalNota := TotalNota
  
  dVcto1     := Vcto1
  nValor1    := Valor1
  dVcto2     := Vcto2
  nValor2    := Valor2
  dVcto3     := Vcto3
  nValor3    := Valor3
  dVcto4     := Vcto4
  nValor4    := Valor4
  dVcto5     := Vcto5
  nValor5    := Valor5
  dVcto6     := Vcto6
  nValor6    := Valor6
  dVcto7     := Vcto7
  nValor7    := Valor7
  dVcto8     := Vcto8
  nValor8    := Valor8
  dVcto9     := Vcto9
  nValor9    := Valor9
  
  setcolor( CorCampo )
  @ 03,61 say dEmis              pict '99/99/9999'
  @ 05,15 say cClie              pict '999999'
  @ 05,22 say ClieARQ->Nome      pict '@S40'
  @ 06,15 say cCond              pict '999999'
  @ 06,22 say CondARQ->Nome      pict '@S25'
  @ 06,61 say CondARQ->Acrs      pict '@E 999.99'
  @ 07,15 say cPraz              pict '@S33' 
  @ 07,61 say cValid             pict '@S14'
  @ 08,15 say cObse
  
  if cStat == 'alte' .or. cStat == space(04)
    setcolor( CorJanel )
    for nG := 1 to 5 
      @ nLin, 03 say '      '    
      @ nLin, 10 say space(25)
      @ nLin, 36 say '         '
      @ nLin, 46 say '     '
      @ nLin, 52 say '          '
      @ nLin, 64 say '          '
      nLin ++
    next

    nLin := 12

    setcolor( CorJanel )
    select IOPrARQ
    set order    to 1
    set relation to Prod into ProdARQ
    dbseek( cNota, .t. )
    do while Nota == cNota
      @ nLin, 03 say Prod                  pict '999999'    
      if Prod == '999999' 
        @ nLin, 10 say Produto             pict '@S25'
      else
        @ nLin, 10 say ProdARQ->Nome       pict '@S25'
      endif     
      if EmprARQ->Inteira == "X"
        @ nLin, 36 say Qtde                pict '@E 999999999'
      else
        @ nLin, 36 say Qtde                pict '@E 99999.999'
      endif
      @ nLin, 46 say Desc                  pict '@E 99.99'
      @ nLin, 52 say PrecoVenda            pict PictPreco(10)
      @ nLin, 64 say Qtde * PrecoVenda     pict '@E 999,999.99'

      nLin ++
      dbskip ()
      if nLin >= 17
        exit
      endif   
    enddo
  else
    setcolor( CorJanel )
    for nG := 1 to 5 
      @ nLin, 03 say '      '    
      @ nLin, 10 say space(25)
      @ nLin, 36 say '         '
      @ nLin, 46 say '     '
      @ nLin, 52 say '          '
      @ nLin, 64 say '          '
      nLin ++
    next
  endif  
  
  setcolor( CorCampo )
  @ 18,13 say nRepr                  pict '999999' 
  @ 18,20 say ReprARQ->Nome          pict '@S18'
  @ 18,61 say nTotalNota             pict '@E 999,999,999.99'

  select OProARQ
  
  PosiDBF( 01, 76 )
return NIL

//
// 
//
function MostOpCo ()
  setcolor( CorCampo )
  @ 06,61 say CondARQ->Acrs      pict '@E 999.99'
  setcolor( CorJanel )
return(.t.)

//
// Entra os dados
//
function EntrOPro ()
  local GetList := {}
  
  if empty( dEmis )
    dEmis := date()
  endif  
  
  do while .t.
    lAlterou := .f.
      
    setcolor ( CorJanel + ',' + CorCampo )
    @ 03,61 get dEmis        pict '99/99/9999'
    @ 05,15 get nClie        pict '999999'  valid ValidClie( 05, 15, "OProARQ", , , .t. )
    @ 06,15 get nCond        pict '999999'  valid ValidARQ( 06, 15, "OProARQ", "Código" , "Cond", "Descrição", "Nome", "Cond", "nCond", .t., 6, "Consulta Condições Pagamento", "CondARQ", 25 ) .and. MostOpCo()
    @ 07,15 get cPraz        pict '@S33'
    @ 07,61 get cValid       pict '@S14'
    @ 08,15 get cObse           
    read

    if dEmis      != Emis;        lAlterou := .t. 
    elseif nClie  != val( Clie ); lAlterou := .t. 
    elseif nCond  != val( Cond ); lAlterou := .t. 
    elseif cPraz  != Praz;        lAlterou := .t. 
    elseif cValid != Valid;       lAlterou := .t. 
    elseif cObse  != Obse;        lAlterou := .t.  
    endif
    
    if !Saindo(lAlterou)
      loop
    endif  
    exit
  enddo  
  
  cCond := strzero( nCond, 6 )
  cClie := strzero( nClie, 6 )
return NIL    

//
// Entra com os itens 
//
function EntrItOP()
  if lastkey () == K_ESC .or. lastkey () == K_PGDN
    return NIL
  endif  

  select( cOProTMP )
  set order    to 1
  set relation to Prod into ProdARQ

  bFirst := {|| dbseek( '0001', .t. ) }
  bLast  := {|| dbseek( '9999', .t. ), dbskip(-1) }
  bFor   := {|| .t. }
  bWhile := {|| .t. }

  oOrcamento         := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oOrcamento:nTop    := 10
  oOrcamento:nLeft   := 3
  oOrcamento:nBottom := 17
  oOrcamento:nRight  := 74
  oOrcamento:headsep := chr(194)+chr(196)
  oOrcamento:colsep  := chr(179)
  oOrcamento:footsep := chr(193)+chr(196)
  oOrcamento:colorSpec := CorJanel + ',' + CorCampo

  oOrcamento:addColumn( TBColumnNew("Código",        {|| Prod } ) )
  oOrcamento:addColumn( TBColumnNew("Descricao", {|| iif( Prod == '999999', left( Produto, 25 ),  left( ProdARQ->Nome, 25 ) ) } ) )
  if EmprARQ->Inteira == "X"
    oOrcamento:addColumn( TBColumnNew("Qtde.",       {|| transform( Qtde, '@E 999999999' ) } ) )
  else  
    oOrcamento:addColumn( TBColumnNew("Qtde.",       {|| transform( Qtde, '@E 99999.999' ) } ) )
  endif  
  oOrcamento:addColumn( TBColumnNew("Desc.",       {|| transform( Desc, '@E 99.99' ) } ) )
  oOrcamento:addColumn( TBColumnNew("Preço Venda", {|| transform( PrecoVenda, PictPreco(10) ) } ) )
  oOrcamento:addColumn( TBColumnNew("Preço Total", {|| transform( PrecoVenda * Qtde, '@E 999,999.99' ) } ) )
            
  lExitRequested := .f.
  lAlterou       := .f.

  oOrcamento:goBottom()
  oOrcamento:configure()

  do while !lExitRequested
    Mensagem ( 'LEVE', 'Browse' )
 
    oOrcamento:forcestable()

    if oOrcamento:hitTop .and. !empty( Prod )
      oOrcamento:refreshAll ()
      
      Select OProARQ
      
      EntrOpro ()
    
      select( cOProTMP )
      
      oOrcamento:down()
      oOrcamento:forcestable()
      oOrcamento:refreshAll ()
      
      loop
    endif
    
    if ( !lAlterou .and. cStat == 'incl' ) .or. oOrcamento:hitbottom .and. lastkey() != K_ESC
      cTecla := K_INS
      
      keyboard( "" )
    else
      cTecla := Teclar(0)
    endif  
    
    do case
      case cTecla == K_DOWN;        oOrcamento:down()
      case cTecla == K_UP;          oOrcamento:up()
      case cTecla == K_PGUP;        oOrcamento:pageUp()
      case cTecla == K_CTRL_PGUP;   oOrcamento:goTop()
      case cTecla == K_PGDN;        oOrcamento:pageDown()
      case cTecla == K_CTRL_PGDN;   oOrcamento:goBottom()
      case cTecla == K_ESC
        if Saindo(lAlterou)
          lExitRequested := .t.
        else  
          lExitRequested := .f.
        endif  
      case cTecla == 46
        @ 18,13 get nRepr     pict '999999'        valid ValidARQ( 18, 13, "OProARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nRepr", .t., 6, "Consulta de Vendedores", "ReprARQ", 20 )
        read
        
        cRepr := strzero( nRepr, 6 )
        
        CondOPro ()
       
        lExitRequested := .t.
      case cTecla == K_ENTER;     EntrItOPro(.f.)
      case cTecla == K_INS
        
        do while lastkey() != K_ESC    
          EntrItOPro(.t.)
        enddo  
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
    
          oOrcamento:refreshAll()  
          oOrcamento:gotop ()
        endif  
    endcase
  enddo
return NIL  

//
// Gera prestacoes do Orcamento
//
function CondOpro ()
  local GetList := {}
  
  select OProARQ
  
    dVcto1  := dVcto2  := dVcto3  := dVcto4  := dVcto5  := ctod ('  /  /  ')
    dVcto6  := dVcto7  := dVcto8  := dVcto9  := ctod ('  /  /  ')
    nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := 0
    nValor6 := nValor7 := nValor8 := nValor9 := 0
  
    dVcto1     := dEmis + CondARQ->Vct1
    nValor1    := nTotalNota
    nTotalComi := ( ( nTotalNota * ReprARQ->PerC ) / 100 )
    nParcela   := 1
 
    if CondARQ->Vct2 != 0 .and. CondARQ->Vct3 == 0 .and. CondARQ->Vct4 == 0 .and.;
       CondARQ->Vct5 == 0 .and. CondARQ->Vct6 == 0 .and. CondARQ->Vct7 == 0 .and.;
       CondARQ->Vct8 == 0 .and. CondARQ->Vct9 == 0 
   
      dVcto2   := dEmis + CondARQ->Vct2
      nValor1  := nValor2 := nTotalNota / 2
      nParcela := 2
    endif

    if CondARQ->Vct3 != 0 .and. CondARQ->Vct4 == 0 .and. CondARQ->Vct5 == 0 .and.;
       CondARQ->Vct6 == 0 .and. CondARQ->Vct7 == 0 .and. CondARQ->Vct8 == 0 .and.;
       CondARQ->Vct9 == 0

      dVcto2   := dEmis + CondARQ->Vct2
      dVcto3   := dEmis + CondARQ->Vct3
      nValor1  := nValor2 := nValor3 := nTotalNota / 3
      nParcela := 3
    endif

    if CondARQ->Vct4 != 0 .and. CondARQ->Vct5 == 0 .and. CondARQ->Vct6 == 0 .and.;
       CondARQ->Vct7 == 0 .and. CondARQ->Vct8 == 0 .and. CondARQ->Vct5 == 9

      dVcto2   := dEmis + CondARQ->Vct2
      dVcto3   := dEmis + CondARQ->Vct3
      dVcto4   := dEmis + CondARQ->Vct4
      nValor1  := nValor2 := nValor3 := nValor4 := nTotalNota / 4
      nParcela := 4
    endif

    if CondARQ->Vct5 != 0 .and. CondARQ->Vct6 == 0 .and. CondARQ->Vct7 == 0 .and.;
       CondARQ->Vct8 == 0 .and. CondARQ->Vct9 == 0

      dVcto2   := dEmis + CondARQ->Vct2
      dVcto3   := dEmis + CondARQ->Vct3
      dVcto4   := dEmis + CondARQ->Vct4
      dVcto5   := dEmis + CondARQ->Vct5
      nValor1  := nValor2 := nValor3 := nValor4 := nValor5 := nTotalNota / 5
      nParcela := 5
    endif

    if CondARQ->Vct6 != 0 .and. CondARQ->Vct7 == 0 .and. CondARQ->Vct8 == 0 .and.;
       CondARQ->Vct9 == 0

      dVcto2   := dEmis + CondARQ->Vct2
      dVcto3   := dEmis + CondARQ->Vct3
      dVcto4   := dEmis + CondARQ->Vct4
      dVcto5   := dEmis + CondARQ->Vct5
      dVcto6   := dEmis + CondARQ->Vct6
      nValor1  := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nTotalNota / 6
      nParcela := 6 
    endif

    if CondARQ->Vct7 != 0 .and. CondARQ->Vct8 == 0 .and. CondARQ->Vct9 == 0
      dVcto2   := dEmis + CondARQ->Vct2
      dVcto3   := dEmis + CondARQ->Vct3
      dVcto4   := dEmis + CondARQ->Vct4
      dVcto5   := dEmis + CondARQ->Vct5
      dVcto6   := dEmis + CondARQ->Vct6
      dVcto7   := dEmis + CondARQ->Vct7
      nValor1  := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nTotalNota / 7
      nParcela := 7
    endif

    if CondARQ->Vct8 != 0 .and. CondARQ->Vct9 == 0
      dVcto2   := dEmis + CondARQ->Vct2
      dVcto3   := dEmis + CondARQ->Vct3
      dVcto4   := dEmis + CondARQ->Vct4
      dVcto5   := dEmis + CondARQ->Vct5
      dVcto6   := dEmis + CondARQ->Vct6
      dVcto7   := dEmis + CondARQ->Vct7
      dVcto8   := dEmis + CondARQ->Vct8
      nValor1  := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nValor8 := nTotalNota / 8
      nParcela := 8
    endif

    if CondARQ->Vct9 != 0
      dVcto2   := dEmis + CondARQ->Vct2
      dVcto3   := dEmis + CondARQ->Vct3
      dVcto4   := dEmis + CondARQ->Vct4
      dVcto5   := dEmis + CondARQ->Vct5
      dVcto6   := dEmis + CondARQ->Vct6
      dVcto7   := dEmis + CondARQ->Vct7
      dVcto8   := dEmis + CondARQ->Vct8
      dVcto9   := dEmis + CondARQ->Vct9
      nValor1  := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nValor8 := nValor9 := nTotalNota / 9
      nParcela := 9
    endif
  
  if CondARQ->Vct1 == 0 .and. CondARQ->Vct2 == 0 .and. CondARQ->Vct3 == 0 .and.;
     CondARQ->Vct4 == 0 .and. CondARQ->Vct5 == 0 .and. CondARQ->Vct6 == 0 .and.;
     CondARQ->Vct7 == 0 .and. CondARQ->Vct8 == 0 .and. CondARQ->Vct9 == 0 
    // Venda a Vista
  else    
    tVcto := savescreen( 00, 00, 23, 79 )  
    Janela ( 05, 09, 07 + nParcela, 63, mensagem( 'Janela', 'CondOPro', .f. ), .f. )
    Mensagem ( 'PedF', 'Vcto' )

    setcolor ( CorJanel )
    @ 07,11 say '  Vencimento 1              Valor 1'
    if nParcela >= 2
      @ 08,11 say '  Vencimento 2              Valor 2'
    endif
    if nParcela >= 3
      @ 09,11 say '  Vencimento 3              Valor 3'
    endif
    if nParcela >= 4
      @ 10,11 say '  Vencimento 4              Valor 4'
    endif
    if nParcela >= 5
      @ 11,11 say '  Vencimento 5              Valor 5'
    endif
    if nParcela >= 6
      @ 12,11 say '  Vencimento 6              Valor 6'
    endif
    if nParcela >= 7
      @ 13,11 say '  Vencimento 7              Valor 7'
    endif
    if nParcela >= 8
      @ 14,11 say '  Vencimento 8              Valor 8'
    endif
    if nParcela >= 9
      @ 15,11 say '  Vencimento 9              Valor 9'
    endif
    
    setcolor ( CorJanel + ',' + CorCampo )
    @ 07,26 get dVcto1      pict '99/99/9999'            
    @ 07,47 get nValor1     pict '@E 999,999,999.99'   
    if nParcela >= 2
      @ 08,26 get dVcto2    pict '99/99/9999'
      @ 08,47 get nValor2   pict '@E 999,999,999.99'
    endif  
    if nParcela >= 3
      @ 09,26 get dVcto3    pict '99/99/9999'
      @ 09,47 get nValor3   pict '@E 999,999,999.99'
    endif  
    if nParcela >= 4
      @ 10,26 get dVcto4    pict '99/99/9999'
      @ 10,47 get nValor4   pict '@E 999,999,999.99'
    endif  
    if nParcela >= 5
      @ 11,26 get dVcto5    pict '99/99/9999'
      @ 11,47 get nValor5   pict '@E 999,999,999.99'
    endif  
    if nParcela >= 6
      @ 12,26 get dVcto6    pict '99/99/9999'
      @ 12,47 get nValor6   pict '@E 999,999,999.99'
    endif  
    if nParcela >= 7
      @ 13,26 get dVcto7    pict '99/99/9999'
      @ 13,47 get nValor7   pict '@E 999,999,999.99'
    endif  
    if nParcela >= 8
      @ 14,26 get dVcto8    pict '99/99/9999'
      @ 14,47 get nValor8   pict '@E 999,999,999.99'
    endif  
    if nParcela >= 9
      @ 15,26 get dVcto9    pict '99/99/9999'
      @ 15,47 get nValor9   pict '@E 999,999,999.99'
    endif  
    read
    
    restscreen( 00, 00, 23, 79, tVcto )  
  endif  
return(.t.)

//
// Entra intens da nota
//
function EntrItOPro( lAdiciona )
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

    oOrcamento:goBottom() 
    oOrcamento:down()
    oOrcamento:refreshAll()  

    oOrcamento:forcestable()
      
    Mensagem( 'PedF', 'InclIten' )
  else
    Mensagem( 'PedF', 'InclIten' )
  endif  

  cProd       := Prod
  cProduto    := Produto
  nProd       := val( cProd )
  nQtde       := Qtde
  nPrecoVenda := PrecoVenda
  nDesc       := Desc
  
  nQtdeAnt    := Qtde
  nPrecoAnt   := PrecoVenda
  nLin        := 11 + oOrcamento:rowPos
  lIPro       := .f.
  lAlterou    := .t.
    
  setcolor( CorCampo )
  @ nLin, 10 say ProdARQ->Nome         pict '@S25'
  @ nLin, 64 say nQtde * PrecoVenda    pict '@E 999,999.99'
  
  set key K_UP to UpNota()
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ nLin, 03 get cProd           pict '@K'            valid ValidProd( nLin, 03, cOProTMP, 'opro', 0, nPrecoVenda )
  if EmprARQ->Inteira == "X"
    @ nLin, 36 get nQtde         pict '@E 999999999'  valid ValidQtde( nQtde ) .and. ValidOPro()
  else  
    @ nLin, 36 get nQtde         pict '@E 99999.999'  valid ValidQtde( nQtde ) .and. ValidOPro()
  endif  
  @ nLin, 46 get nDesc           pict '@E 99.99'      valid CalcOpro( nDesc )
  @ nLin, 52 get nPrecoVenda     pict PictPreco(10)
  read
  
  set key K_UP to 
     
  if lastkey () == K_ESC
    if lAdiciona
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif  
    endif  

    oOrcamento:refreshCurrent()  
    oOrcamento:goBottom()
    return NIL
  endif  
  
  if lIPro 
    select( cOProTMP )
    if RegLock()
      replace Prod       with "999999"
      replace Produto    with ProdARQ->Nome
      replace PrecoVenda with nPrecoVenda
      replace Desc       with 0
      replace Qtde       with nQtde
      dbunlock ()
    endif  

    nTotalNota += ( nQtde * nPrecoVenda )

    select IProARQ
    do while Prod == cProd .and. !eof()
      select( cOProTMP )   
      
      nSequ ++ 
      nTotalNota += ( ( nQtde * IProARQ->Qtde ) * IProARQ->PrecoVenda )
      
      if AdiReg() 
        if RegLock()
          replace Sequ            with strzero( nSequ, 4 )
          replace Novo            with .t.
          replace Prod            with IProARQ->CodP
          replace Produto         with IProARQ->Produto
          replace Qtde            with IProARQ->Qtde * nQtde
          replace PrecoVenda      with IProARQ->PrecoVenda
          dbunlock ()
	endif  
      endif
      
      select IProARQ
      dbskip()
    enddo

    select( cOProTMP )   

    oOrcamento:refreshCurrent()  
    lAlterou := .t.
  else
    if RegLock()
      replace Prod            with cProd
      replace Produto         with cProduto
      replace Qtde            with nQtde
      replace PrecoVenda      with nPrecoVenda
      replace Desc            with nDesc
      replace Lixo            with .f.
      dbunlock ()
    endif  
  
    if !lAdiciona
      nTotalNota -= ( nQtdeAnt * nPrecoAnt )
      nTotalNota += ( nQtde * nPrecoVenda )
    else
      nTotalNota += ( nQtde * nPrecoVenda )
  
      oOrcamento:goBottom() 
    endif
  endif
  
  oOrcamento:refreshCurrent()  
  
  setcolor( CorCampo )
  @ 18,61 say nTotalNota       pict '@E 999,999,999.99'
return NIL     

// Calcula o Desconto
function CalcOpro (nDesc)
  if nDesc > 0
    nPrecoVenda := nPrecoVenda - ( ( nPrecoVenda * nDesc ) / 100 )
  endif
return(.t.)

//
// Verifica Composicao
//
function ValidOPro ()
  select IProARQ
  set order to 1 
  dbseek( cProd, .t. )
  if Prod == cProd
    lIPro := .t.
    
    keyboard(chr(13))
  else  
    lIPro := .f.
  endif
  select( cOProTMP )   
return(.t.)

//
// Excluir nota
//
function EstoOPro ()
  cStat  := 'loop' 
  
  select OProARQ

  if ExclRegi ()
    select IOPrARQ
    set order to 1
    dbseek( cNota + '01', .t. )
    do while Nota == cNota
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif
        
      dbskip ()
    enddo    
    
    select OProARQ
  endif
return NIL

//
// Entra o estoque
//
function GravOPro()
  set deleted off

  select( cOProTMP )
  set order to 1
  dbgotop ()
  do while !eof ()
    if empty( Prod )
      dbskip ()
      loop
    endif

    cProd       := Prod
    nQtde       := Qtde
    nPrecoVenda := PrecoVenda
    nRegi       := Regi
    lLixo       := Lixo

    if Novo
      if Lixo
        dbskip ()
        loop
      endif
      
      select IOPrARQ
      set order to 1
      dbseek( cNotaNew + &cOProTMP->Sequ, .f. )
      
      if found ()
        dbdelete ()
        dbunlock ()
      endif     

      if AdiReg()
        if RegLock()
          replace Nota       with cNotaNew
          replace Sequ       with &cOProTMP->Sequ
          replace Prod       with &cOProTMP->Prod
          replace Produto    with &cOProTMP->Produto
          replace Qtde       with &cOProTMP->Qtde
          replace Desc       with &cOProTMP->Desc
          replace PrecoVenda with &cOProTMP->PrecoVenda
          replace PrecoCusto with &cOProTMP->PrecoCusto
          replace Unidade    with &cOProTMP->Unidade
          dbunlock ()
        endif
      endif
    else
      select IOPrARQ
      go nRegi

      if RegLock()
        replace Prod            with &cOProTMP->Prod
        replace Produto         with &cOProTMP->Produto
        replace Qtde            with &cOProTMP->Qtde
        replace Desc            with &cOProTMP->Desc
        replace PrecoVenda      with &cOProTMP->PrecoVenda
        replace PrecoCusto      with &cOProTMP->PrecoCusto
        replace Unidade         with &cOProTMP->Unidade
        dbunlock ()
      endif

      if lLixo
        if RegLock()
          dbdelete ()
          dbunlock ()
       endif
      endif
    endif

    select( cOProTMP )
    dbskip ()
  enddo

  set deleted on
  
  select OProARQ
return NIL

//
// Imprime Dados
//
function PrinOPro ( lAbrir )

  local cArqu2  := CriaTemp( 5 )
  local cArqu3  := right ( cArqu2, 8 )

  local cRData  := date()
  local cRHora  := time()
  
  local GetList := {}

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

    if NetUse( "OProARQ", .t. )
      VerifIND( "OProARQ" )
  
      sOpenOPro := .t.
  
      #ifdef DBF_NTX
        set index to OProIND1
      #endif
    else
      sOpenOPro := .f.  
    endif

    if NetUse( "IOPrARQ", .t. )
      VerifIND( "IOPrARQ" )
  
      sOpenIOPr := .t.
  
      #ifdef DBF_NTX
        set index to IOPrIND1
      #endif
    else
      sOpenIOPr := .f.  
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 08, 08, 12, 70, mensagem( 'Janela', 'PrinOPro', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,10 say 'Orçamento Inicial             Orçamento Final'
  @ 11,10 say '     Data Inicial                  Data Final'

  select OProARQ
  set order to 1   
  dbgotop ()
  nNotaIni := val ( Nota )
  dbgobottom ()
  nNotaFin := val ( Nota )

  dDataIni := ctod ('01/01/96')
  dDataFin := date ()

  @ 10,28 get nNotaIni          pict '999999' 
  @ 10,56 get nNotaFin          pict '999999'     valid nNotaFin >= nNotaIni
  @ 11,28 get dDataIni          pict '99/99/9999' 
  @ 11,56 get dDataFin          pict '99/99/9999'   valid dDataFin >= dDataIni
  read

  if lastkey() == K_ESC
    select OProARQ
    if lAbrir
      close
      select ProdARQ
      close
      select IOPrARQ
      close
    else
      set order to 1 
      dbgobottom ()
    endif
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  Aguarde ()

  nPag   := 1
  nLin   := 0
  cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

  cNotaIni := strzero( nNotaIni )
  cNotaFin := strzero( nNotaFin )
  cDataIni := dtos( dDataIni )
  cDataFin := dtos( dDataFin )
  lInicio  := .t.

  select OProARQ
  set order  to 1
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
        Cabecalho ( 'Orçamentos', 132, 3 )
        CabOPro   ()
      endif
        
      @ nLin,01 say Nota
      @ nLin,08 say Emis                 pict '99/99/9999'
      @ nLin,19 say Obse                 pict '@S38' 
  
      nValorTotal := nTotalNota := 0
      cNota       := Nota
  
      select IOPrARQ
      set order    to 1
      set relation to Prod into ProdARQ
      dbseek( cNota + '01', .t. )
      do while Nota == cNota
        nValorTotal := Qtde * PrecoVenda
        nTotalNota  += nValorTotal
 
        @ nLin,058 say Sequ
        @ nLin,061 say Prod
        if Prod == '9999' 
          @ nLin,066 say Produto           pict '@S30'
        else      
          @ nLin,066 say ProdARQ->Nome     pict '@S30'
        endif     
        if EmprARQ->Inteira == "X"
          @ nLin,097 say Qtde              pict '@E 999999999'
        else  
          @ nLin,097 say Qtde              pict '@E 99999.999'
        endif  
        @ nLin,107 say PrecoVenda          pict '@E 9,999.9999'
        @ nLin,118 say nValorTotal         pict '@E 999,999.99'

        nLin ++
 
        if nLin >= pLimite
          Rodape(132) 

          cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
          cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

          set printer to ( cArqu2 )
          set printer on
        
          select OProARQ
        
          Cabecalho ( 'Orçamentos', 132, 3 )
          CabOPro   ()
       
          @ nLin,01 say Nota
          @ nLin,08 say Emis                 pict '99/99/9999'
          @ nLin,19 say Obse                 pict '@S38' 

          select IOPrARQ
        endif
      
        dbskip ()
      enddo
      
      select OProARQ

      @ nLin,098 say 'Total do Orçamento'
      @ nLin,118 say nTotalNota         pict '@E 999,999.99'
      nLin += 2

      if nLin >= pLimite
        Rodape(132) 
 
        cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
        cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

        set printer to ( cArqu2 )
        set printer on           
      endif     
    endif

    dbskip ()
  enddo

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
      replace Titu       with "Relatório dos Orçamentos Emitidos"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 132
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
    close
  endif

  select OProARQ
  if lAbrir
    close
    select ProdARQ
    close
    select IOPrARQ
    close
  else
    set order  to 1 
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabOPro ()
  @ 02,01 say 'Perido ' + dtoc( dDataIni ) + ' a ' + dtoc( dDataFin )
  @ 03,01 say 'Nota   Emissão    Observação                           Seq. Produto/Serviço                         Qtde.   P. Venda   V. Total'    

  nLin := 5 
return NIL

//
// Imprimir Orçamento
//
function PrinOrca ()
    
  tPrt := savescreen( 00, 00, 23, 79 )

  Janela( 11, 22, 14, 49, mensagem( 'Janela', 'PrinOrca', .f. ), .f. )
  Mensagem( 'LEVE', 'Print' )
  setcolor( CorJanel )
    
  aOpc := {}
  nPrn := 0

  aadd( aOpc, { ' Impressora ', 2, 'I', 13, 25, "Imprimir Orçamento para impressora." } )
  aadd( aOpc, { ' Arquivo ',    2, 'A', 13, 38, "Gerar arquivo texto da impressão do orçamento." } )
    
  nTipoOpro := HCHOICE( aOpc, 2, 1 )
  
  
  if lastkey() == K_ESC
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif  

  if nTipoOpro == 2
      Janela( 05, 16, 10, 54, mensagem( 'Janela', 'Salvar', .f. ), .f. )
      Mensagem( 'LEVE', 'Salvar' ) 

      cArqu2  := CriaTemp( 5 )
      xArqu3  := right ( cArqu2, 8 )

      cTXT    := 'X'
      cHTM    := ' '
      cXML    := ' '
      cPDF    := ' '
  
      cArqTxt := cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() + alltrim( xArqu3 ) + ".txt" + space(40)
        
      keyboard( chr( K_END ) )

      setcolor ( CorJanel + ',' + CorCampo )
      @ 07,18 say '[ ] TXT  [ ] HTML  [ ] XML  [ ] PDF'

      @ 07,19 get cTXT              pict '@!'  valid TipoTxt()
      @ 07,28 get cHTM              pict '@!'  valid TipoTxt()
      @ 07,38 get cXML              pict '@!'  valid TipoTxt()
      @ 07,47 get cPDF              pict '@!'  valid TipoTxt()
      @ 09,18 get cArqTxt           pict '@S35'
      read
    
      if lastkey() == K_ESC
        return NIL
      endif  
  
      set printer to ( cArqTxt )
      set device  to printer
      set printer on
  endif   

  if nTipoOpro == 1
    Aguarde ()

    if EmprARQ->Impr == "X"
      if !TestPrint(1)   
        restscreen( 00, 00, 23, 79, tPrt )
        return NIL
      endif  
    else  
      aPrn := GetPrinters()
      nPrn := 1
            
      for j := 1 to len( aPrn )
        if alltrim( aPrn[j] ) == GetDefaultPrinter()
          nPrn := j
          exit
        endif                   
      next

      tPrn := savescreen( 00, 00, 23, 79 )
            
      Janela( 06, 22, 12, 62, mensagem( 'Janela', 'VerPrinter', .f. ), .f. )
      setcolor( CorJanel + ',' + CorCampo )
          
      nPrn := achoice( 08, 23, 11, 61, aPrn, .t.,,nPrn )
     
      restscreen( 00, 00, 23, 79, tPrn )
       
      if lastkey () == K_ESC
        return NIL
      endif  

      cArqu2  := CriaTemp( 5 )
      xArqu3  := right( cArqu2, 8 )
      cArqTxt := cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() + alltrim( xArqu3 ) + ".txt" + space(40)
  
      set printer to ( cArqTxt )
      set device  to printer
      set printer on
  
      nTipoOpro := 2
    endif  
  endif    
    
  do case
    case EmprARQ->TipoOPro == 1
  
  for nK := 1 to EmprARQ->CopiaOpro
    
    if EmprARQ->Impr == "X"
      setprc( 0, 0 )

      @ 00, 00 say chr(27) + "@"
      @ 00, 00 say chr(18)
      @ 00, 00 say chr(27) + chr(67) + chr(33)
    endif  

    select OProARQ

    cObse := Obse
    dEmis := Emis
    nLin  := 0

    @ nLin,01 say '+----------------------------------------------------------------------------+'
    nLin ++
    @ nLin,01 say '|' 
    @ nLin,03 say EmprARQ->Razao
    @ nLin,52 say 'Orçamento N.'
    @ nLin,65 say cNotaNew                            pict '999999'
    @ nLin,78 say '|' 
    nLin ++
    @ nLin,01 say '|' 
    @ nLin,03 say EmprARQ->Ende
    @ nLin,52 say '        Data'
    @ nLin,65 say dEmis                            pict '99/99/9999'
    @ nLin,78 say '|' 
    nLin ++
    @ nLin,01 say '|' 
    @ nLin,03 say EmprARQ->Bairro
    @ nLin,23 say EmprARQ->Cida
    @ nLin,52 say '        Hora'
    @ nLin,65 say time()                           pict '99:99'
    @ nLin,78 say '|' 
    nLin ++
    @ nLin,01 say '|' 
    @ nLin,03 say EmprARQ->Fone                    
    @ nLin,23 say EmprARQ->Fax                     
    @ nLin,78 say '|' 
    nLin ++
    @ nLin,01 say '+----------------------------------------------------------------------------+'
    nLin ++
    @ nLin,01 say '| Cond. Pgto. '
    @ nLin,15 say Vcto1                            pict '99/99/9999'
    @ nLin,26 say Valor1                           pict '@E 99,999.99'
    if Valor2 > 0
      @ nLin,36 say Vcto2                          pict '99/99/9999'
      @ nLin,47 say Valor2                         pict '@E 99,999.99'
    endif  
    if Valor3 > 0
      @ nLin,57 say Vcto3                          pict '99/99/9999'
      @ nLin,68 say Valor3                         pict '@E 99,999.99'
    endif  
    @ nLin,78 say '|'
    nLin ++
    @ nLin,01 say '|'
    if Valor4 > 0
      @ nLin,15 say Vcto4                          pict '99/99/9999'
      @ nLin,26 say Valor4                         pict '@E 99,999.99'
    endif  
    if Valor5 > 0
      @ nLin,36 say Vcto5                          pict '99/99/9999'
      @ nLin,47 say Valor5                         pict '@E 99,999.99'
    endif  
    if Valor6 > 0
      @ nLin,57 say Vcto6                          pict '99/99/9999'
      @ nLin,68 say Valor6                         pict '@E 99,999.99'
    endif  
    @ nLin,78 say '|'
    nLin ++
    @ nLin,01 say '|     Cliente'
    if Clie == '999999'
      @ nLin,15 say left( cCliente, 40 ) + ' ' + Clie         
    else  
      @ nLin,15 say left( ClieARQ->Nome, 40 ) + ' ' + Clie         
    endif  
    @ nLin,78 say '|'
    nLin ++
    @ nLin,01 say '|     Entrega'
    @ nLin,15 say Praz                             pict '@S40'
    @ nLin,78 say '|'
    nLin ++
    @ nLin,01 say '|    Validade'
    @ nLin,15 say Valid                            pict '@S40'
    @ nLin,78 say '|'
    nLin ++
    @ nLin,01 say '|  Observação'
    @ nLin,15 say Obse                             pict '@S40'
    @ nLin,78 say '|'
    nLin ++
    @ nLin,01 say '+---------+----+---------------------------------------+----------+----------+'
    nLin ++
    @ nLin,01 say '|   Qtde. | Un | Produto/Serviço                       | P. Unit. |    Total |'
    nLin ++
    @ nLin,01 say '+---------+----+---------------------------------------+----------+----------+'
    nLin ++

    nValorTotal := nTotalNota := 0
    nSequ       := 0
    nTotLinha   := 11

    select IOPrARQ
    set relation to Prod into ProdARQ
    dbseek( cNotaNew, .t. )
    do while Nota == cNotaNew .and. !eof()
      nPrecoVenda := PrecoVenda
      nValorTotal := Qtde * nPrecoVenda
      nTotalNota  += nValorTotal

      @ nLin,01 say '|'
      if EmprARQ->Inteira == "X"
        @ nLin,02 say Qtde           pict '@E 999999999'
      else      
        @ nLin,02 say Qtde           pict '@E 99999.999'
      endif       
      @ nLin,11 say '|'
      @ nLin,13 say ProdARQ->Unid
      @ nLin,16 say '|'
      if Prod == '999999' 
        @ nLin,17 say left( Produto, 32 ) + ' ' + Prod
      else      
        @ nLin,17 say left( ProdARQ->Nome, 32 ) + ' ' + Prod
      endif     
      @ nLin,56 say '|'
      @ nLin,57 say nPrecoVenda    pict PictPreco(10)
      @ nLin,67 say '|'
      @ nLin,68 say nValorTotal    pict '@E 999,999.99'
      @ nLin,78 say '|'

      nSequ ++
      nLin  ++

      if nSequ > nTotLinha
        @ nLin,01 say '+---------+----+---------------------------------------+----------+----------+'
        nLin ++
        @ nLin,01 say '|'
        @ nLin,48 say 'A Transportar'
        @ nLin,68 say nTotalNota     pict '@E 999,999.99'
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '+----------------------------------------------------------------------------+'

        select OProARQ
        nLin += 5
        @ nLin,01 say '+----------------------------------------------------------------------------+'
        nLin ++
        @ nLin,01 say '|' 
        @ nLin,03 say EmprARQ->Razao
        @ nLin,52 say 'Orçamento N.'
        @ nLin,65 say cNotaNew                            pict '999999'
        @ nLin,78 say '|' 
        nLin ++
        @ nLin,01 say '|' 
        @ nLin,03 say EmprARQ->Ende
        @ nLin,52 say '        Data'
        @ nLin,65 say dEmis                            pict '99/99/9999'
        @ nLin,78 say '|' 
        nLin ++
        @ nLin,01 say '|' 
        @ nLin,03 say EmprARQ->Bairro
        @ nLin,23 say EmprARQ->Cida
        @ nLin,52 say '        Hora'
        @ nLin,65 say time()                           pict '99:99'
        @ nLin,78 say '|' 
        nLin ++
        @ nLin,01 say '|' 
        @ nLin,03 say EmprARQ->Fone                    
        @ nLin,23 say EmprARQ->Fax                     
        @ nLin,78 say '|' 
        nLin ++
        @ nLin,01 say '+----------------------------------------------------------------------------+'
        nLin ++
        @ nLin,01 say '| Cond. Pgto.' 
        @ nLin,15 say Vcto1                            pict '99/99/9999'
        @ nLin,26 say Valor1                           pict '@E 99,999.99'
        if Valor2 > 0
          @ nLin,36 say Vcto2                          pict '99/99/9999'
          @ nLin,47 say Valor2                         pict '@E 99,999.99'
        endif  
        if Valor3 > 0
          @ nLin,57 say Vcto3                          pict '99/99/9999'
          @ nLin,68 say Valor3                         pict '@E 99,999.99'
        endif  
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '|'
        if Valor4 > 0
          @ nLin,15 say Vcto4                          pict '99/99/9999'
          @ nLin,26 say Valor4                         pict '@E 99,999.99'
        endif  
        if Valor5 > 0
          @ nLin,36 say Vcto5                          pict '99/99/9999'
          @ nLin,47 say Valor5                         pict '@E 99,999.99'
        endif  
        if Valor6 > 0
          @ nLin,57 say Vcto6                          pict '99/99/9999'
          @ nLin,68 say Valor6                         pict '@E 99,999.99'
        endif  
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '|'
        if Valor4 > 0
          @ nLin,15 say Vcto7                          pict '99/99/9999'
          @ nLin,26 say Valor7                         pict '@E 99,999.99'
        endif  
        if Valor5 > 0
          @ nLin,36 say Vcto8                          pict '99/99/9999'
          @ nLin,47 say Valor8                         pict '@E 99,999.99'
        endif  
        if Valor6 > 0
          @ nLin,57 say Vcto9                          pict '99/99/9999'
          @ nLin,68 say Valor9                         pict '@E 99,999.99'
        endif  
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '|     Entrega'
        @ nLin,15 say cPraz                            pict '@S40'
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '|    Validade'
        @ nLin,15 say cValid                           pict '@S40'
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '|  Observação'
        @ nLin,15 say cObse                            pict '@S40'
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '+---------+----+---------------------------------------+----------+----------+'
        nLin ++
        @ nLin,01 say '|   Qtde. | Un | Produto/Serviço                       | P. Unit. |    Total |'
        nLin ++
        @ nLin,01 say '+---------+----+---------------------------------------+----------+----------+'
        nLin ++
        @ nLin,01 say '|         |    |                                       |          |          |'
        @ nLin,12 say 'Transporte de'
        @ nLin,68 say nTotalNota          pict '@E 999,999.99'
        
        select IOPrARQ

        nLin  ++
        nSequ := 1
      endif

      dbskip ()
    enddo

    select IOPrARQ

    if nSequ < nTotLinha
      for nIni := 1 to ( ( nTotLinha + 1 ) - nSequ )
        @ nLin,01 say '|         |    |                                       |          |          |'
        nLin ++
      next
    endif

    @ nLin,01 say '+---------+----+---------------------------------------+----------+----------+'
    nLin ++
    @ nLin,01 say '| ' + alltrim( EmprARQ->Mensagem )
    @ nLin,57 say 'Total'
    @ nLin,68 say nTotalNota          pict '@E 999,999.99'
    @ nLin,78 say '|'
    nLin ++
    @ nLin,01 say '+----------------------------------------------------------------------------+'
    nLin += 4
    if EmprARQ->Impr == "X"
      @ nLin, 00 say chr(27) + "@"
    endif  
  next
  
  case EmprARQ->TipoOpro == 2
  
  for nK := 1 to EmprARQ->CopiaOpro
    if EmprARQ->Impr == "X"
      setprc( 0, 0 )

      @ 00, 00 say chr(27) + "@"
      @ 00, 00 say chr(18) 
      @ 00, 00 say chr(27) + chr(67) + chr(66)
    endif  

    select OProARQ

    cObse := Obse
    dEmis := Emis
    nLin  := 0

    @ nLin,01 say '+----------------------------------------------------------------------------+'
    nLin ++
    @ nLin,01 say '|' 
    @ nLin,03 say EmprARQ->Razao
    @ nLin,52 say 'Orçamento N.'
    @ nLin,65 say cNotaNew                            pict '999999'
    @ nLin,78 say '|' 
    nLin ++
    @ nLin,01 say '|' 
    @ nLin,03 say EmprARQ->Ende
    @ nLin,52 say '        Data'
    @ nLin,65 say dEmis                            pict '99/99/9999'
    @ nLin,78 say '|' 
    nLin ++
    @ nLin,01 say '|' 
    @ nLin,03 say EmprARQ->Bairro
    @ nLin,23 say EmprARQ->Cida
    @ nLin,52 say '        Hora'
    @ nLin,65 say time()                           pict '99:99'
    @ nLin,78 say '|' 
    nLin ++
    @ nLin,01 say '|' 
    @ nLin,03 say EmprARQ->Fone                    
    @ nLin,23 say EmprARQ->Fax                     
    @ nLin,78 say '|' 
    nLin ++
    @ nLin,01 say '+----------------------------------------------------------------------------+'
    nLin ++
    @ nLin,01 say '| Cond. Pgto. '
    @ nLin,15 say Vcto1                            pict '99/99/9999'
    @ nLin,26 say Valor1                           pict '@E 99,999.99'
    if Valor2 > 0
      @ nLin,36 say Vcto2                          pict '99/99/9999'
      @ nLin,47 say Valor2                         pict '@E 99,999.99'
    endif  
    if Valor3 > 0
      @ nLin,57 say Vcto3                          pict '99/99/9999'
      @ nLin,68 say Valor3                         pict '@E 99,999.99'
    endif  
    @ nLin,78 say '|'
    nLin ++
    @ nLin,01 say '|'
    if Valor4 > 0
      @ nLin,15 say Vcto4                          pict '99/99/9999'
      @ nLin,26 say Valor4                         pict '@E 99,999.99'
    endif  
    if Valor5 > 0
      @ nLin,36 say Vcto5                          pict '99/99/9999'
      @ nLin,47 say Valor5                         pict '@E 99,999.99'
    endif  
    if Valor6 > 0
      @ nLin,57 say Vcto6                          pict '99/99/9999'
      @ nLin,68 say Valor6                         pict '@E 99,999.99'
    endif  
    @ nLin,78 say '|'
    nLin ++
    @ nLin,01 say '|     Cliente'
    if Clie == '999999'
      @ nLin,15 say left( cCliente, 40 ) + ' ' + Clie         
    else  
      @ nLin,15 say left( ClieARQ->Nome, 40 ) + ' ' + Clie         
    endif  
    @ nLin,78 say '|'
    nLin ++
    @ nLin,01 say '|     Entrega'
    @ nLin,15 say Praz                             pict '@S40'
    @ nLin,78 say '|'
    nLin ++
    @ nLin,01 say '|    Validade'
    @ nLin,15 say Valid                            pict '@S40'
    @ nLin,78 say '|'
    nLin ++
    @ nLin,01 say '|  Observação'
    @ nLin,15 say Obse                             pict '@S40'
    @ nLin,78 say '|'
    nLin ++
    @ nLin,01 say '+---------+----+---------------------------------------+----------+----------+'
    nLin ++
    @ nLin,01 say '|   Qtde. | Un | Produto/Serviço                       | P. Unit. |    Total |'
    nLin ++
    @ nLin,01 say '+---------+----+---------------------------------------+----------+----------+'
    nLin ++

    nValorTotal := nTotalNota := 0
    nSequ       := 0
    nTotLinha   := 40

    select IOPrARQ
    set relation to Prod into ProdARQ
    dbseek( cNotaNew, .t. )
    do while Nota == cNotaNew .and. !eof()
      nPrecoVenda := PrecoVenda
      nValorTotal := Qtde * nPrecoVenda
      nTotalNota  += nValorTotal

      @ nLin,01 say '|'
      if EmprARQ->Inteira == "X"
        @ nLin,02 say Qtde           pict '@E 999999999'
      else      
        @ nLin,02 say Qtde           pict '@E 99999.999'
      endif       
      @ nLin,11 say '|'
      @ nLin,13 say ProdARQ->Unid
      @ nLin,16 say '|'
      if Prod == '999999' 
        @ nLin,17 say left( Produto, 32 ) + ' ' + Prod
      else      
        @ nLin,17 say left( ProdARQ->Nome, 32 ) + ' ' + Prod
      endif     
      @ nLin,56 say '|'
      @ nLin,57 say nPrecoVenda    pict PictPreco(10)
      @ nLin,67 say '|'
      @ nLin,68 say nValorTotal    pict '@E 999,999.99'
      @ nLin,78 say '|'

      nSequ ++
      nLin  ++

      if nSequ > nTotLinha
        @ nLin,01 say '+---------+----+---------------------------------------+----------+----------+'
        nLin ++
        @ nLin,01 say '|'
        @ nLin,48 say 'A Transportar'
        @ nLin,68 say nTotalNota     pict '@E 999,999.99'
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '+----------------------------------------------------------------------------+'

        select OProARQ
        nLin += 5
        @ nLin,01 say '+----------------------------------------------------------------------------+'
        nLin ++
        @ nLin,01 say '|' 
        @ nLin,03 say EmprARQ->Razao
        @ nLin,52 say 'Orçamento N.'
        @ nLin,65 say cNotaNew                            pict '999999'
        @ nLin,78 say '|' 
        nLin ++
        @ nLin,01 say '|' 
        @ nLin,03 say EmprARQ->Ende
        @ nLin,52 say '        Data'
        @ nLin,65 say dEmis                            pict '99/99/9999'
        @ nLin,78 say '|' 
        nLin ++
        @ nLin,01 say '|' 
        @ nLin,03 say EmprARQ->Bairro
        @ nLin,23 say EmprARQ->Cida
        @ nLin,52 say '        Hora'
        @ nLin,65 say time()                           pict '99:99'
        @ nLin,78 say '|' 
        nLin ++
        @ nLin,01 say '|' 
        @ nLin,03 say EmprARQ->Fone                    
        @ nLin,23 say EmprARQ->Fax                     
        @ nLin,78 say '|' 
        nLin ++
        @ nLin,01 say '+----------------------------------------------------------------------------+'
        nLin ++
        @ nLin,01 say '| Cond. Pgto.' 
        @ nLin,15 say Vcto1                            pict '99/99/9999'
        @ nLin,26 say Valor1                           pict '@E 99,999.99'
        if Valor2 > 0
          @ nLin,36 say Vcto2                          pict '99/99/9999'
          @ nLin,47 say Valor2                         pict '@E 99,999.99'
        endif  
        if Valor3 > 0
          @ nLin,57 say Vcto3                          pict '99/99/9999'
          @ nLin,68 say Valor3                         pict '@E 99,999.99'
        endif  
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '|'
        if Valor4 > 0
          @ nLin,15 say Vcto4                          pict '99/99/9999'
          @ nLin,26 say Valor4                         pict '@E 99,999.99'
        endif  
        if Valor5 > 0
          @ nLin,36 say Vcto5                          pict '99/99/9999'
          @ nLin,47 say Valor5                         pict '@E 99,999.99'
        endif  
        if Valor6 > 0
          @ nLin,57 say Vcto6                          pict '99/99/9999'
          @ nLin,68 say Valor6                         pict '@E 99,999.99'
        endif  
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '|'
        if Valor4 > 0
          @ nLin,15 say Vcto7                          pict '99/99/9999'
          @ nLin,26 say Valor7                         pict '@E 99,999.99'
        endif  
        if Valor5 > 0
          @ nLin,36 say Vcto8                          pict '99/99/9999'
          @ nLin,47 say Valor8                         pict '@E 99,999.99'
        endif  
        if Valor6 > 0
          @ nLin,57 say Vcto9                          pict '99/99/9999'
          @ nLin,68 say Valor9                         pict '@E 99,999.99'
        endif  
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '|     Entrega'
        @ nLin,15 say cPraz                            pict '@S40'
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '|    Validade'
        @ nLin,15 say cValid                           pict '@S40'
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '|  Observação'
        @ nLin,15 say cObse                            pict '@S40'
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '+---------+----+---------------------------------------+----------+----------+'
        nLin ++
        @ nLin,01 say '|   Qtde. | Un | Produto/Serviço                       | P. Unit. |    Total |'
        nLin ++
        @ nLin,01 say '+---------+----+---------------------------------------+----------+----------+'
        nLin ++
        @ nLin,01 say '|         |    |                                       |          |          |'
        @ nLin,12 say 'Transporte de'
        @ nLin,68 say nTotalNota          pict '@E 999,999.99'
        
        select IOPrARQ

        nLin  ++
        nSequ := 1
      endif

      dbskip ()
    enddo

    select IOPrARQ

    if nSequ < nTotLinha
      for nIni := 1 to ( ( nTotLinha + 1 ) - nSequ )
        @ nLin,01 say '|         |    |                                       |          |          |'
        nLin ++
      next
    endif

    @ nLin,01 say '+---------+----+---------------------------------------+----------+----------+'

    nLin ++
    @ nLin,01 say '| ' + alltrim( EmprARQ->Mensagem )
    @ nLin,57 say 'Total'
    @ nLin,68 say nTotalNota          pict '@E 999,999.99'
    @ nLin,78 say '|'
    nLin ++
    @ nLin,01 say '+----------------------------------------------------------------------------+'
    nLin += 4
    
    if EmprARQ->Impr == "X"
      @ nLin, 00 say chr(27) + "@"
    endif  
  next
  
  endcase
      
  set printer to
  set printer off
  set device  to screen  
  
  if !empty( GetDefaultPrinter() ) .and. nPrn > 0
    PrnTest(aPrn[nPrn], memoread( cArqTxt ), .f. )
  endif

  restscreen( 00, 00, 23, 79, tPrt )
return NIL