//  Leve, Pedido Fiscal
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

function PedF( xAlte )

if NetUse( "ProdARQ", .t. )
  VerifIND( "ProdARQ" )
  
  vOpenProd := .t.

  #ifdef DBF_NTX
    set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
  #endif  
else
  vOpenProd := .f.
endif

if NetUse( "IProARQ", .t. )
  VerifIND( "IProARQ" )
  
  vOpenIPro := .t.

  #ifdef DBF_NTX
    set index to IProIND1
  #endif
else  
  vOpenIPro := .f.
endif

if NetUse( "ClieARQ", .t. )
  VerifIND( "ClieARQ" )
  
  vOpenClie := .t.
  
  #ifdef DBF_NTX
    set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
  #endif  
else
  vOpenClie := .f.  
endif

if NetUse( "CondARQ", .t. )
  VerifIND( "CondARQ" )
  
  vOpenCond := .t.
  
  #ifdef DBF_NTX
    set index to CondIND1, CondIND2
  #endif  
else
  vOpenCond := .f.  
endif

if NetUse( "PortARQ", .t. )
  VerifIND( "PortARQ" )
  
  vOpenPort := .t.
  
  #ifdef DBF_NTX
    set index to PortIND1, PortIND2
  #endif  
else
  vOpenPort := .f.  
endif

if NetUse( "ReceARQ", .t. )
  VerifIND( "ReceARQ" )
  
  vOpenRece := .t.
  
  #ifdef DBF_NTX
    set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
  #endif  
else
  vOpenRece := .f.  
endif

if NetUse( "ReprARQ", .t. )
  VerifIND( "ReprARQ" )
  
  vOpenRepr := .t.
  
  #ifdef DBF_NTX
    set index to ReprIND1, ReprIND2
  #endif  
else
  vOpenRepr := .f.  
endif

if NetUse( "NSaiARQ", .t. )                   
  VerifIND( "NSaiARQ" )
  
  vOpenNSai := .t.
  
  #ifdef DBF_NTX
    set index to NSaiIND1, NSaiIND2, NSaiIND3, NSaiIND4
  #endif  
else
  vOpenNSai := .f.  
endif

if NetUse( "INSaARQ", .t. )
  VerifIND( "INSaARQ" )
  
  vOpenINSa := .t.
  
  #ifdef DBF_NTX
    set index to INSaIND1
  #endif  
else
  vOpenINSa := .f.  
endif

// Variaveis de Entrada
cAjuda      := 'PedF'
lAjud       := .t.
tCupom      := savescreen( 00, 00, 23, 79 )
aOp         := {}
aArqui      := {}
cVendARQ    := CriaTemp(0)
cVendIND1   := CriaTemp(1)
cChave      := "Sequ"
cTecla      := inkey()
nNota       := nQtde      := 0
cNota       := cNotaNew   := space(06)
dEmis       := date()
cCliente    := cProduto   := space(40)
nCond       := nClie      := nComis   := 0
nSequPrx    := nJuro      := nDesc    := 0
nPrecoCusto := 0
cSequ       := cCond      := cUnidade := space(02)
cNatu       := cHora      := space(04)
cProd       := cClie      := cRepr    := cTran   := cPort   := space(04)
dSaid       := ctod('  /  /  ')
dVcto01     := dVcto02    := dVcto03  := dVcto04  := dVcto05  := ctod ('  /  /  ')
dVcto06     := dVcto07    := dVcto08  := dVcto09  := ctod ('  /  /  ')
nValor01    := nValor02   := nValor03 := nValor04 := nValor05 := 0
nValor06    := nValor07   := nValor08 := nValor09 := 0
nAnter01    := nAnter02   := nAnter03 := nAnter04 := nAnter05 := 0
nAnter06    := nAnter07   := nAnter08 := nAnter09 := 0
nComis01    := nComis02   := nComis03 := nComis04 := nComis05 := 0
nComis06    := nComis07   := nComis08 := nComis09 := 0
cObse       := ''

select EmprARQ
set order to 1
dbseek( cEmpresa, .f. )

if !empty( EmprARQ->CodBarra )
  lAutomatico := .f.
else  
  lAutomatico := .t.
endif  

if empty( EmprARQ->Desconto )
  lDescVenda := .f.
else  
  lDescVenda := .t.
endif  

cVctoTMP    := cVctoARQ   := cVctoIND1 := space(08)

aadd( aArqui, { "Sequ",       "N", 004, 0 } )
aadd( aArqui, { "Prod",       "C", 006, 0 } )
aadd( aArqui, { "Produto",    "M", 010, 0 } )
aadd( aArqui, { "Cliente",    "C", 040, 0 } )
aadd( aArqui, { "Qtde",       "N", 012, 3 } )
aadd( aArqui, { "Comi",       "N", 009, 3 } )
aadd( aArqui, { "Desc",       "N", 009, 3 } )
aadd( aArqui, { "PrecoVenda", "N", 015, 6 } )
aadd( aArqui, { "PrecoCusto", "N", 015, 6 } )
aadd( aArqui, { "Unidade",    "C", 003, 0 } )

dbcreate( cVendARQ, aArqui )
   
if NetUse( cVendARQ, .f. )
  cVendTMP := alias ()
  
  #ifdef DBF_CDX    
    index on &cChave tag &cVendIND1
  #endif

  #ifdef DBF_NTX
   index on &cChave to &cVendIND1

   set index to &cVendIND1
  #endif  
endif

setcolor( CorFundo )
@ 00,00 clear to 22, 79 

setcolor( CorJanel )
@ 01, 01 clear to 04, 78
@ 01, 01 to 04, 78

setcolor( CorCabec )
@ 01,01 say space(78)
if EmprARQ->ValorAll == "X"
  @ 01,03 say 'Produto        Descrição                 V. Total Desc.     Qtde. P. Venda'
else
  @ 01,03 say 'Produto        Descrição                    Qtde. Desc.  P. Venda V. Total'
endif  

setcolor( CorJanel )
@ 06, 43 clear to 21, 78
@ 06, 43 to 21, 78

setcolor( CorCabec )
@ 06,43 say space(36)
@ 06,43 say ' Itens do Pedido                    '

setcolor( CorJanel )
@ 06, 01 clear to 11, 41
@ 06, 01 to 11, 41

setcolor( CorCabec ) 
@ 06,01 say '                               SubTotal  '

setcolor( CorJanel )
@ 14, 01 clear to 21, 41
@ 14, 01 to 21, 41

setcolor( CorCabec )
@ 14,01 say '                  Desconto   Total Nota  '

setcolor( CorJanel )
@ 18,03 say '   Pgto.'
@ 19,03 say ' Cliente'
@ 20,03 say 'Vendedor'

select( cVendTMP )
set order  to 1
set relation to Prod into ProdARQ
  
bFirst := {|| dbseek( 0001, .t. ) }
bLast  := {|| dbseek( 9999, .t. ), dbskip (-1) }
bFor   := {|| .t. }
bWhile := {|| .t. }

oCupom           := TBrowseFW( bWhile, bFor, bFirst, bLast )
oCupom:nTop      := 08
oCupom:nLeft     := 44
oCupom:nBottom   := 21
oCupom:nRight    := 77
oCupom:headsep   := chr(194)+chr(196)
oCupom:colsep    := chr(179)
oCupom:footsep   := chr(193)+chr(196)
oCupom:colorSpec := CorJanel + ',' + CorJanel

oCupom:addColumn( TBColumnNew("Descrição",{|| iif( Prod == '999999', left( Produto, 14 ), left( ProdARQ->Nome, 14 ) ) } ) )
if EmprARQ->Inteira == "X"
  oCupom:addColumn( TBColumnNew("Qtde.",    {|| transform( Qtde, '@E 9999999' ) } ) )
else  
  oCupom:addColumn( TBColumnNew("Qtde.",    {|| transform( Qtde, '@E 99999.9' ) } ) )
endif  
oCupom:addColumn( TBColumnNew("Preço",    {|| transform( PrecoVenda, PictPreco(9) ) } ) )
oCupom:addColumn( TBColumnNew("V Total",  {|| transform( ( PrecoVenda * Qtde ), '@E 999,999.99' ) } ) )
oCupom:addColumn( TBColumnNew("Desc.",    {|| transform( Desc, '@E 999.99' ) } ) )
oCupom:addColumn( TBColumnNew("Código",   {|| Prod } ) )
oCupom:addColumn( TBColumnNew("Seq.",     {|| transform( Sequ, '9999' ) } ) )

oCupom:colPos  := 2

iExitRequested := .f.
lAdiciona      := .f.
  
setcolor( CorJanel )  
@ 09,43 say chr(195)
@ 09,78 say chr(180)

do while .t.
  lAbreCupom  := .t.
  nSequCupom  := nValorTotal := 0
  nSubTotal   := nSequ       := 0
  nDesconto   := nTotalNota  := 0
  nPrecoTotal := nComissao   := 0
  nPrecoVenda := nQtde       := 0
  nTotalOld   := nDesc       := 0
  lAlterou    := .f.
    
  if EmprARQ->CondFixa == "X"
    cCond := strzero( EmprARQ->CondCupom, 6 )
    nCond := EmprARQ->CondCupom
    cClie := strzero( EmprARQ->ClieCupom, 6 )
    nClie := EmprARQ->ClieCupom
    cRepr := strzero( EmprARQ->ReprCupom, 6 )
    nRepr := EmprARQ->ReprCupom
    cPort := strzero( EmprARQ->PortCupom, 6 )
    nPort := EmprARQ->PortCupom
  else
    cCond := space(06)
    nCond := 0
    cClie := space(06)
    nClie := 0
    cRepr := space(06)
    nRepr := 0 
    cPort := space(06)
    nPort := 0 
  endif
  
  if lAutomatico  
    Mensagem( 'PedF', 'Auto' )
  else
    Mensagem( 'PedF', 'Manual' )
  endif  
  
  select CondARQ
  set order to 1
  dbseek( cCond, .f. )

  select ClieARQ
  set order to 1
  dbseek( cClie, .f. )

  select ReprARQ
  set order to 1
  dbseek( cRepr, .f. )

  select PortARQ
  set order to 1
  dbseek( cPort, .f. )
  
  select NSaiARQ
  set order to 1

  select ProdARQ
  set order to 1

  select( cVendTMP )
  set order to 1
  set relation to Prod into ProdARQ

  oCupom:gotop()
  oCupom:forcestable()
  
  setcolor( CorCampo )
  @ 03,03 say space(14)
  @ 03,18 say space(24)
  
  if EmprARQ->ValorALL == "X"
    @ 03,43 say nValorTotal     pict '@E 99,999.99'
    @ 03,53 say nDesc           pict '@E 99.99'
    if EmprARQ->Inteira == "X"
      @ 03,59 say nQtde         pict '@E 999999999'
    else  
      @ 03,59 say nQtde         pict '@E 99999.999'
    endif
    @ 03,69 say nPrecoVenda     pict PictPreco(8)
  else
    if EmprARQ->Inteira == "X"
      @ 03,43 say nQtde         pict '@E 999999999'
    else  
      @ 03,43 say nQtde         pict '@E 99999.999'
    endif
    @ 03,53 say nDesc           pict '@E 99.99'
    @ 03,59 say nPrecoVenda     pict PictPreco(9)
    @ 03,69 say nValorTotal     pict '@E 99999.99'
  endif  
  
  @ 16,17 say nDesconto         pict '@E 999,999.99'
  @ 16,30 say nValorTotal       pict '@E 999,999.99'
 
  if EmprARQ->CondFixa == "X"
    @ 18,12 say nCond           pict '999999'
    @ 18,19 say CondARQ->Nome   pict '@S21'
    @ 19,12 say nClie           pict '999999'
    @ 19,19 say ClieARQ->Nome   pict '@S21'
    @ 20,12 say nRepr           pict '999999'
    @ 20,19 say ReprARQ->Nome   pict '@S21'
  else  
    @ 18,12 say nCond           pict '999999'
    @ 18,19 say space(21)
    @ 19,12 say nClie           pict '999999'
    @ 19,19 say space(21)
    @ 20,12 say nRepr           pict '999999'
    @ 20,19 say space(21)
  endif  

  BigNumber (0)
  EntrPedido ()
  
  if lastkey () == K_ESC .or. nextkey() == K_ESC .or. inkey() == K_ESC .or. cTecla == K_ESC
    exit
  endif  
  
  Mensagem( 'PedF', 'Acima' ) 
  
  do while .t.  
    setcolor( CorJanel )
    lAlterou := .t.
     
    set key K_ALT_S to DescPedf () 
         
    @ 16,17 get nDesconto    pict '@E 999,999.99'    valid FiscPedi()
    @ 16,30 get nTotalNota   pict '@E 999,999.99'    valid PediTroc()
    @ 18,12 get nCond        pict '999999'           valid ValidARQ( 18, 12, cVendTMP, "Codigo", "Cond", "Descrição", "Nome", "Cond", "nCond", .t., 6, "Consulta de Condiç”es Pagamento", "CondARQ", 21 ) .and. PPedVcto () 
    @ 19,12 get nClie        pict '999999'           valid ValidClie( 19, 12, cVendTMP, ,21, .t. )
    @ 20,12 get nRepr        pict '999999'           valid ValidARQ( 20, 12, cVendTMP, "Codigo", "Repr", "Descrição", "Nome", "Repr", "nRepr", .t., 6, "Consulta de Vendedores", "ReprARQ", 21 ) .and. ComiPedf ()
    read
    
    set key K_ALT_S to 
    
    if lastkey() == K_ESC 
      if Saindo(lAlterou)
        cTecla := K_ESC
        exit
      else
        cTecla := 0
        loop
      endif    
    else
      exit  
    endif
  enddo  
  
  if lastkey () == K_ESC .or. nextkey() == K_ESC .or. inkey() == K_ESC .or. cTecla == K_ESC
    exit
  endif

  dEmis := date()
  cCond := strzero( nCond, 6 )
  cRepr := strzero( nRepr, 6 )
  cClie := strzero( nClie, 6 )
  cPort := strzero( nPort, 6 )

  select CondARQ
  set order to 1
  dbseek( cCond, .f. )
  
  select EmprARQ
  set order to 1
  dbseek( cEmpresa, .f. )
    
  nNotaNew := Nota + 1
  dEmis    := date()
  cHora    := time()
    
  do while .t.
    cNotaNew := strzero( nNotaNew, 6 )
    
    NSaiARQ->( dbseek( cNotaNew, .f. ) )

    if NSaiARQ->(found())
      nNotaNew ++
      loop
    else      
      if RegLock()
        replace Nota       with nNotaNew
        dbunlock ()
      endif  
      exit    
    endif
  enddo  
  
  if empty( EmprARQ->VisuPedf )
    cNotaNew := strzero( nNotaNew, 6 )            
    tPrinter := savescreen( 00, 00, 23, 79 )

    Janela( 11, 22, 14, 57, mensagem( 'Janela', 'Imprimir', .f. ), .f. )
    setcolor( CorJanel )
    @ 13,23 say '  Imprimir'
    
    setcolor( CorCampo )
    @ 13,34 say ' Sim ' 
    @ 13,40 say ' Não ' 
    @ 13,46 say ' Arquivo ' 

    setcolor( CorAltKC )
    @ 13,35 say 'S' 
    @ 13,41 say 'N' 
    @ 13,47 say 'A' 
    
    aOpc := {}

    aadd( aOpc, { ' Sim ',     2, 'S', 13, 34, "Imprimir Pedido." } )
    aadd( aOpc, { ' Não ',     2, 'N', 13, 40, "Não imprimir Pedido." } )
    aadd( aOpc, { ' Arquivo ', 2, 'A', 13, 46, "Gerar arquivo texto da impressão do pedido." } )
    
    nTipoPedf := HCHOICE( aOpc, 3, 1 )
    
    do case
      case nTipoPedf == 1
        PPPedido (.t.) 
      case nTipoPedf == 3
        PPPedido (.f.) 
    endcase  
  
    restscreen( 00, 00, 23, 79, tPrinter )
  else 
    tPrinter := savescreen( 00, 00, 23, 79 )

    Janela( 08, 20, 14, 57, mensagem( 'Janela', 'Imprimir', .f. ), .f. )
      
    setcolor ( CorJanel + ',' + CorCampo )
    @ 10,23 say '    Pedido' 
    @ 11,23 say '   Emissão'
 
    @ 13,23 say '  Imprimir'
    
    setcolor( CorCampo )
    @ 13,34 say ' Sim ' 
    @ 13,40 say ' Não ' 
    @ 13,46 say ' Arquivo ' 

    setcolor( CorAltKC )
    @ 13,35 say 'S' 
    @ 13,41 say 'N' 
    @ 13,47 say 'A' 
    
    @ 10,34 get nNotaNew           pict '999999'
    @ 11,34 get dEmis              pict '99/99/9999'
    @ 11,45 get cHora              pict '99:99'
    read
    
    if lastkey() == K_ESC
      restscreen( 00, 00, 23, 79, tPrinter )
      loop
    endif
    
    if RegLock()
      replace Nota       with nNotaNew
      dbunlock ()
    endif  
    
    cNotaNew := strzero( nNotaNew, 6 )            
  
    aOpc := {}

    aadd( aOpc, { ' Sim ',     2, 'S', 13, 34, "Imprimir Pedido" } )
    aadd( aOpc, { ' Não ',     2, 'N', 13, 40, "Não imprimir Pedido" } )
    aadd( aOpc, { ' Arquivo ', 2, 'A', 13, 46, "Gerar arquivo texto da impressão do pedido" } )
    
    nTipoPedf := HCHOICE( aOpc, 3, 1 )
    
    do case
      case nTipoPedf == 1
        PPPedido (.t.) 
      case nTipoPedf == 3
        PPPedido (.f.) 
    endcase  

    restscreen( 00, 00, 23, 79, tPrinter )
  endif  
  
  select NSaiARQ    
  set order to 1
  if AdiReg()
    if RegLock()
      replace Nota       with cNotaNew
      replace Emis       with dEmis
      replace Hora       with cHora
      replace Clie       with cClie
      replace Cliente    with cCliente
      replace Cond       with cCond
      replace Repr       with cRepr
      replace Port       with cPort
      replace SubTotal   with nSubTotal
      replace Desconto   with nDesconto
      replace Comissao   with nComissao
      replace Vcto1      with dVcto01
      replace Valor1     with nValor01
      replace Comis1     with nComis01
      replace Vcto2      with dVcto02
      replace Valor2     with nValor02
      replace Comis2     with nComis02
      replace Vcto3      with dVcto03
      replace Valor3     with nValor03
      replace Comis3     with nComis03
      replace Vcto4      with dVcto04
      replace Valor4     with nValor04
      replace Comis4     with nComis04
      replace Vcto5      with dVcto05
      replace Valor5     with nValor05
      replace Comis5     with nComis05
      replace Vcto6      with dVcto06
      replace Valor6     with nValor06
      replace Comis6     with nComis06
      replace Vcto7      with dVcto07
      replace Valor7     with nValor07
      replace Comis7     with nComis07
      replace Vcto8      with dVcto08
      replace Valor8     with nValor08
      replace Comis8     with nComis08
      replace Vcto9      with dVcto09
      replace Valor9     with nValor09
      replace Comis9     with nComis09
      replace Obse       with cObse
      dbunlock ()
    endif
  endif
  
  select( cVendTMP )
  set order to 1
  dbgotop ()
  do while !eof ()
    cProd       := Prod
    cProduto    := Produto
    cSequ       := strzero( Sequ, 4 )
    nQtde       := Qtde
    nPrecoVenda := PrecoVenda
    nPrecoCusto := PrecoCusto
    cUnidade    := Unidade   
 
    select INSaARQ
    set order to 1
    dbseek( cNotaNew + cSequ, .f. )
      
    if found ()
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif  
    endif  
      
    if AdiReg()
      if RegLock()
        replace Nota       with cNotaNew
        replace Sequ       with cSequ
        replace Prod       with cProd
        replace Produto    with cProduto
        replace Qtde       with nQtde
        replace PrecoVenda with nPrecoVenda
        replace PrecoCusto with nPrecoCusto
        replace Unidade    with cUnidade
        dbunlock ()
      endif
    endif
    
    select( cVendTMP )    
    dbskip ()
  enddo

  select( cVendTMP )
  set order to 1 
  dbgotop ()
  do while !eof ()
    if empty( Prod )
      dbskip ()
      loop
    endif  
      
    cProd := Prod
    nQtde := Qtde
      
    select ProdARQ
    set order to 1
    dbseek( cProd, .f. )
    if found ()
      if RegLock()
        replace Qtde         with Qtde - nQtde
        replace UltS         with dEmis
        dbunlock ()
      endif
    endif    

    select( cVendTMP )
    dbskip ()
  enddo  
   
  nJuro := EmprARQ->Taxa
  uTipo := 'P'
  

    if CondARQ->Cheque
      tPedfChpr := savescreen( 00, 00, 23, 79 )

      ChPr (.t.)

      restscreen( 00, 00, 23, 79, tPedfChPr )
    else

    if CondARQ->Pcla > 0
      nComis := nComissao / CondARQ->Pcla

      select( cVctoTMP )
      dbgotop()
      do while !eof()
        nSequ   := Sequ
        dData   := Data
        nValo   := Valo
        cParc   := strzero( nSequ, 4 )
        cNotaPg := cNotaNew + cParc

        select ReceARQ
        set order to 1
        dbseek( cNotaPg + uTipo, .f. )

        if nValo == 0
          if found()
            if RegLock()
              dbdelete ()
              dbunlock ()
            endif
          endif
        else
          if eof()
            if AdiReg()
              if RegLock()
                replace Nota     with cNotaPg
                replace Tipo     with uTipo
                replace Clie     with cClie
                replace Cliente  with cCliente
                replace Emis     with dEmis
                replace Vcto     with dData
                replace Valor    with nValo
                replace Acre     with nJuro
                if dData == dEmis
                  replace Pgto   with dData
                  replace Pago   with nValo
                endif
                replace Repr     with cRepr
                replace Port     with cPort
                replace ReprComi with nComis
                dbunlock ()
              endif
            endif
          endif
        endif

        select( cVctoTMP )
        dbskip ()
      enddo
    else
      select ReceARQ
      set order to 1
      for nJ := 1 to 9
        cParc   := strzero( nJ, 2 )
        cNotaPg := cNotaNew + cParc
        nPago   := nValor&cParc

        dbseek( cNotaPg + uTipo, .f. )

        if nValor&cParc == 0
          if !eof ()
            if RegLock()
              dbdelete ()
              dbunlock ()
            endif
          endif
        else
          if eof()
            if AdiReg()
              if RegLock()
                replace Nota     with cNotaPg
                replace Clie     with cClie
                replace Cliente  with cCliente
                replace Tipo     with uTipo
                dbunlock ()
              endif
            endif
          endif

          if RegLock()
            replace Emis     with dEmis
            replace Vcto     with dVcto&cParc
            replace Valor    with nValor&cParc
            replace Acre     with nJuro
            if dVcto&cParc == dEmis
              replace Pgto   with dVcto&cParc
              replace Pago   with nValor&cParc
            endif
            replace Repr     with cRepr
            replace Port     with cPort
            replace ReprComi with nComis&cParc
            dbunlock ()
          endif

          if EmprARQ->Caixa == "X" .and. dEmis == dVcto&cParc
            dPgto := date()
            cNota := cNotaNew
            cHist := iif( cClie == '999999', ReceARQ->Cliente, ClieARQ->Nome )

            DestLcto ()
          endif
        endif
      next
    endif
    
    if select( cVctoTMP ) > 0
      select( cVctoTMP )
      set order to 1
      zap
    endif  

    select( cVendTMP )
    set order to 1
    zap
    
  endif
enddo
  
restscreen( 00, 00, 23, 79, tCupom )

if vOpenIPro
  select IProARQ
  close
endif

if vOpenNSai
  select NSaiARQ
  close
endif

if vOpenINSa
  select INSaARQ
  close
endif

if vOpenClie
  select ClieARQ
  close
endif

if vOpenProd
  select ProdARQ
  close
endif

if vOpenCond
  select CondARQ
  close
endif  

if vOpenRece
  select ReceARQ
  close
endif

if vOpenRepr
  select ReprARQ
  close
endif  

if vOpenPort
  select PortARQ
  close
endif  

select( cVendTMP )
ferase( cVendARQ )
ferase( cVendIND1 )

if select( cVctoTMP ) > 0
  select( cVctoTMP )
  ferase( cVctoARQ )
  ferase( cVctoIND1 )
endif  

keyboard( "" )
return NIL

//
// Entra com o PRODUTO
//
function EntrPedido ()
  local GetList := {}

  do while .t.
    select( cVendTMP )

    lQtde     := .f.
    cWord     := space(14) 
    nTamanho  := 14
    nConta    := cLetra     := 0
    nLin      := 3
    nCol      := 3
    cCodBarra := ''
    cProduto  := Produto
    nColCons  := 1

    nPrecoCusto := 0
    cUnidade    := space(3)

    setcolor( CorCampo )
    @ 03, 03 say space(14)
  
    setpos( nLin, nCol )

    do while nConta < nTamanho
      cLetra  := 0  
      cTempo  := sectotime( timetosec( time() ) + timetosec( '00:02' ) ) 
    
      setcolor( CorMenus )
    
      do while cLetra == 0
        cLetra := inkey()
        
        @ 23,42 say time()

        setpos( nLin, nCol + nConta )
      
        if time() >= cTempo
          MoviTela()
        
          cLetra := 0
          cTempo := sectotime( timetosec( time() ) + timetosec( '00:02' ) ) 
        endif  
      enddo  
      
      setcolor( CorCampo )

      do case
        case cLetra == K_ALT_M .or. cLetra == K_INS
          if lAutomatico 
            lAutomatico := .f.
          else   
            lAutomatico := .t.
          endif  
  
          if lAutomatico  
            Mensagem( 'Pedf', 'Auto' )
          else
            Mensagem( 'Pedf', 'Manual' )
          endif  

          setpos( nLin, nCol )
          
          setcolor( CorCampo )
        case cLetra == K_ESC
          if Saindo (lAlterou)
            cLetra := K_ESC
            exit
          else  
            cTecla := 0
          endif  
        case cLetra == K_ENTER;       exit
        case cLetra == K_BS .and. empty( cLetra )
          loop
        case cLetra == K_CTRL_Z
          setcolor( CorCampo )
          @ 03,03 say space(14)
          @ 03,18 say space(24)
          @ 03,43 say 0               pict '@E 99999.999'
          @ 03,53 say 0               pict '@E 99.99'
          @ 03,59 say 0               pict '@E 99,999.99'
          @ 03,69 say 0               pict '@E 99999.99'

          nQtde  := 0
          lQtde  := .t.
          cWord  := space(14)
          nConta := cLetra     := 0
          nLin   := 3
          nCol   := 3

          select( cVendTMP )
          
          if RegLock()
            nSubTotal -= ( Qtde * PrecoVenda )
                    
            BigNumber( nSubTotal )

            dbdelete ()
            dbunlock ()

            oCupom:goBottom () 
            oCupom:refreshAll()
            oCupom:forcestable()
          endif  
   
          setcolor( CorCampo )
          setpos( nLin, nCol )
          loop
        case cLetra == 42  
          setcolor( CorCampo )

          @ 03,18 say space(24)
          @ 03,53 say 0               pict '@E 99.99'
          @ 03,59 say 0               pict '@E 99,999.99'
          @ 03,69 say 0               pict '@E 99999.99'

          nQtde  := 0
          lQtde  := .t.
          cWord  := space(14)
          nConta := cLetra     := 0
          nLin   := 3
          nCol   := 3
   
          setcolor( CorJanel )
          if EmprARQ->Inteira == "X"
            @ 03,43 get nQtde                 pict '@E 999999999'
          else  
            @ 03,43 get nQtde                 pict '@E 99999.999'
          endif  
          read
          
          setcolor( CorCampo )
          setpos( nLin, nCol )
          loop
        case cLetra == K_F1
          cAjuda := 'PedF'
          lAjud  := .t.
        
          Ajuda()
        case cLetra == K_BS 
          if nConta + nCol == nCol
            loop
          endif
          
          cWord := left( cWord, len( cWord ) - 1 )
          
          nConta --

          @ nLin, nCol + nConta say ' '
          setpos( nLin, nCol + ( nConta - 1 ) )
          loop
        case cLetra == 46;           keyboard(chr(46))
          exit  
        case cLetra == K_TAB
          EntrItPP ()
 
          if lAutomatico  
            Mensagem( 'PedF', 'Auto' )
          else
            Mensagem( 'PedF', 'Manual' )
          endif  
          
          if lastkey() == K_INS
            lQtde    := .f.
            cWord    := space(14) 
            nTamanho := 14
            nConta   := cLetra     := 0
            nLin     := 3
            nCol     := 3
        
            setcolor( CorCampo )            
            setpos( nLin, nCol )
            loop
          endif
          if lastkey() == 46
            exit
          endif
        case cLetra >= 32 .and. cLetra <= 128  
          @ nLin, nCol + nConta say chr( cLetra )
           
          nConta ++
          cWord  += chr( cLetra ) 
      endcase     
    enddo
    
    if len( alltrim( cWord ) ) < nTamanho
      nEspaco    := nTamanho - len( alltrim( cWord ) ) 
      cProdBarra := alltrim( cWord ) + space( nEspaco + 1 )
      
      if empty( cProdBarra )
        cProdBarra := 'ENTER'
      endif
    endif
    
    if lastkey () == K_ESC .or. lastkey() == 46 .or. cLetra == K_ESC
      if cLetra == K_ESC
        keyboard(chr(27))
      endif
      return NIL
    endif  

    lAchou := .f.
    lIProd := .f.

    select ProdARQ
    
    if alltrim( cProdBarra ) == 'OBS'
      tEntrObse := savescreen( 00, 00, 23, 79 )

      Janela( 03, 17, 09, 60, mensagem( 'Janela', 'Obse', .f. ), .f. )
      Mensagem( 'PedF', 'Obse' )
         
      setcolor( CorCampo )     
      cObse  := memoedit( cObse, 05, 19, 08, 58, .t., "OutProd" )
      lAchou := .t.
    
      restscreen( 00, 00, 23, 79, tEntrObse )

      loop
    endif        
    
    if !lAchou
      set order to 1
      if strzero( val( cProdBarra ), 6 ) != '999999'
        dbseek( strzero( val( cProdBarra ), 6 ), .f. ) 
    
        if found()
          lAchou := .t.
        endif  
      else
        if EmprARQ->MemoProd == "X"
          tEntrProd := savescreen( 00, 00, 24, 79 )

          Janela( 03, 12, 10, 69, mensagem( 'Janela', 'ValidProd', .f. ), .f. )
          Mensagem( 'Func', 'ValidProd' )
      
          setcolor( CorJanel )      
          @ 09,14 say 'Unidade                         Preço Custo'
         
          setcolor( CorCampo )     
          @ 09,22 say cUnidade    
          @ 09,58 say nPrecoCusto     pict PictPreco(10)       
          
          cProduto := memoedit( cProduto, 05, 14, 07, 67, .t., "OutProd" )
      
          if lastkey() != K_ESC
            @ 09,22 get cUnidade    
            @ 09,58 get nPrecoCusto     pict PictPreco(10)       
            read
          endif
    
          restscreen( 00, 00, 24, 79, tEntrProd )
  
          setcolor( CorCampo )       
          @ 03, 18 say memoline( cProduto, 24, 1 )
	else   
          setcolor( CorJanel + ',' + CorCampo )      
	
          cProduto := space(60)
		
  	  @ 03, 18 get cProduto   pict '@S24' 
	  read
	
          lAchou := .t.
	endif  
      endif  
    endif

    if !lAchou
      set order to 5
      dbseek( cProdBarra, .f. ) 

      if found()
        lAchou := .t.
      endif  
    endif

    if !lAchou
      set order to 6
      dbseek( cProdBarra, .f. ) 

      if found()
        lAchou := .t.
      endif  
    endif
    
    if !lAchou
      select IProARQ
      set order to 2
      dbseek( cProdBarra, .f. )
      
      if found()
        lAchou := .t.
      endif  

      set order to 3
      dbseek( cProdBarra, .f. )
      
      if found()
        lAchou := .t.
      endif  
      
      select ProdARQ
      
      if lAchou
        set order to 1
        dbseek( IProARQ->Prod, .f. )
      endif
    endif
    
    if !lAchou
      tMens := savescreen( 24, 00, 24, 79 ) 
      do case
        case EmprARQ->ConsProd == 1 .or. EmprARQ->ConsProd == 3 .or. EmprARQ->ConsProd == 4
          nColCons := ConsProd ()
        case EmprARQ->ConsProd == 2
          nColCons := ConsTabp ()
      endcase    

      restscreen( 24, 00, 24, 79, tMens )
    endif
    
    select ProdARQ
  
    if lastkey() == K_ESC .or. empty( cProdBarra )
      cTecla := 0
      loop
    endif
  
    if lQtde
      lQtde := .f.
    else
      nQtde := 1
    endif

    
    if strzero( val( cProdBarra ), 6 ) == '999999'
      cProd       := '999999'
      nProd       := 999999
      nPrecoVenda := 0
      nDesc       := 0
    else  
      cProd       := ProdARQ->Prod
      nProd       := val( cProd )

      do case
        case nColCons == 6
          if !empty( alltrim( EmprARQ->Preco1 ) )
            cCalc       := alltrim( EmprARQ->Preco1 ) 
            if EmprARQ->Moeda == "X"
              nPrecoVenda := (&cCalc) * nMoedaDia
            else  
              nPrecoVenda := (&cCalc)
            endif  
          else  
            if EmprARQ->Moeda == "X"
              nPrecoVenda := PrecoVenda * nMoedaDia
            else
              nPrecoVenda := PrecoVenda
            endif
          endif  
        case nColCons == 7
          if !empty( alltrim( EmprARQ->Preco2 ) )
            cCalc       := alltrim( EmprARQ->Preco2 ) 
            if EmprARQ->Moeda == "X"
              nPrecoVenda := (&cCalc) * nMoedaDia
            else  
              nPrecoVenda := (&cCalc)
            endif  
          else  
            if EmprARQ->Moeda == "X"
              nPrecoVenda := PrecoVenda * nMoedaDia
            else
              nPrecoVenda := PrecoVenda
            endif  
          endif  
        case nColCons == 8
          if !empty( alltrim( EmprARQ->Preco3 ) )
            cCalc       := alltrim( EmprARQ->Preco3 ) 
            if EmprARQ->Moeda == "X"
              nPrecoVenda := (&cCalc) * nMoedaDia
            else  
              nPrecoVenda := (&cCalc)
            endif  
          else  
            if EmprARQ->Moeda == "X"
              nPrecoVenda := PrecoVenda * nMoedaDia
            else
              nPrecoVenda := PrecoVenda
            endif  
          endif  
        case nColCons == 9
          if !empty( alltrim( EmprARQ->Preco4 ) )
            cCalc       := alltrim( EmprARQ->Preco4 ) 
            if EmprARQ->Moeda == "X"
              nPrecoVenda := (&cCalc) * nMoedaDia
            else  
              nPrecoVenda := (&cCalc)
            endif  
          else  
            if EmprARQ->Moeda == "X"
              nPrecoVenda := PrecoVenda * nMoedaDia
            else
              nPrecoVenda := PrecoVenda
            endif  
          endif  
        case nColCons == 10
          if !empty( alltrim( EmprARQ->Preco5 ) )
            cCalc       := alltrim( EmprARQ->Preco5 ) 
            if EmprARQ->Moeda == "X"
              nPrecoVenda := (&cCalc) * nMoedaDia
            else  
              nPrecoVenda := (&cCalc)
            endif  
          else  
            if EmprARQ->Moeda == "X"
              nPrecoVenda := PrecoVenda * nMoedaDia
            else
              nPrecoVenda := PrecoVenda
            endif  
          endif  
        otherwise
          if EmprARQ->Moeda == "X"
            nPrecoVenda := ProdARQ->PrecoVenda * nMoedaDia
          else
            nPrecoVenda := ProdARQ->PrecoVenda
          endif  
      endcase
    endif  

    nSequCupom  ++

    setcolor( CorCampo )
    @ 03,03 say cProd
    if cProd != '999999'
      @ 03,18 say ProdARQ->Nome                pict '@S24'
    endif  

      if lAutomatico
        if cProd == '999999'
          nQtde := 1
          
          setcolor( CorJanel + ',' + CorCampo )
          
          if EmprARQ->ValorAll == "X"
             @ 03,43 get nValorTotal           pict '@E 99,999.99' valid CalcVT ()
             @ 03,53 get nDesc                 pict '@E 99.99'    
             if EmprARQ->Inteira == "X"
               @ 03,59 get nQtde               pict '@E 999999999' valid ValidQtde( nQtde ) .and. ValidIPro ()
             else  
               @ 03,59 get nQtde               pict '@E 99999.999' valid ValidQtde( nQtde ) .and. ValidIPro ()
             endif   
             @ 03,69 get nPrecoVenda           pict PictPreco(9)
          else
            if EmprARQ->Inteira == "X"
              @ 03,43 get nQtde                pict '@E 999999999' valid ValidQtde( nQtde ) .and. ValidIPro ()
            else  
              @ 03,43 get nQtde                pict '@E 99999.999' valid ValidQtde( nQtde ) .and. ValidIPro ()
            endif   
            @ 03,53 get nDesc                  pict '@E 99.99'     valid DescDisc()
            @ 03,59 get nPrecoVenda            pict PictPreco(9)
          endif  
          read
        else  
      
//          @ 03,43 get nValorTotal           pict '@E 99,999.99' valid CalcVT ()
//          read
          
          @ 03,53 say nDesc                    pict '@E 99.99'

          if EmprARQ->Inteira == "X"
            @ 03,43 say nQtde                  pict '@E 999999999'
          else  
            @ 03,43 say nQtde                  pict '@E 99999.999'
          endif  
          @ 03,59 say nPrecoVenda              pict PictPreco(8)

          ValidIPro ()
        endif  
      else
        nQtde       := 1
        nDesc       := 0

        if EmprARQ->ValorAll == "X"
           @ 03,43 get nValorTotal             pict '@E 99,999.99' valid CalcVT ()
           @ 03,53 get nDesc                   pict '@E 99.99'    
           if EmprARQ->Inteira == "X"
             @ 03,59 get nQtde                 pict '@E 999999999' valid ValidQtde( nQtde ) .and. ValidIPro ()
           else  
             @ 03,59 get nQtde                 pict '@E 99999.999' valid ValidQtde( nQtde ) .and. ValidIPro ()
           endif   
           @ 03,69 get nPrecoVenda             pict PictPreco(8)
        else
          if EmprARQ->Inteira == "X"
            @ 03,43 get nQtde                  pict '@E 999999999' valid ValidQtde( nQtde ) .and. ValidIPro()
          else    
            @ 03,43 get nQtde                  pict '@E 99999.999' valid ValidQtde( nQtde ) .and. ValidIPro() 
          endif  
          @ 03,53 get nDesc                   pict '@E 99.99'     valid DescDisc()
          @ 03,59 get nPrecoVenda             pict PictPreco(9)
        endif    
        read
      endif  

      setcolor( CorCampo )
      
      if lIProd
        select( cVendTMP )
        if AdiReg()
          if RegLock()
            replace Sequ       with nSequCupom
            replace Prod       with "999999"
	    replace Produto    with ProdARQ->Nome
            replace PrecoVenda with nPrecoVenda
            replace Desc       with 0
            replace Qtde       with nQtde
            dbunlock ()
          endif  
        endif
	
	nSubTotal  += ( nQtde * nPrecoVenda )
	nSequCupom ++
          
        select IProARQ
        do while Prod == cProd .and. !eof()
          select( cVendTMP )
   
          if AdiReg()
            if RegLock()
              replace Sequ       with nSequCupom
              replace Prod       with IProARQ->CodP
              replace Produto    with IProARQ->Produto
              replace PrecoVenda with IProARQ->PrecoVenda
              replace Desc       with 0
              replace Qtde       with IProARQ->Qtde * nQtde
              dbunlock ()
            endif  
          endif
          
          nSubTotal  += ( ( IProARQ->Qtde * nQtde ) * IProARQ->PrecoVenda )
          nSequCupom ++

          select IProARQ
          dbskip()
        enddo
      else
        if lastkey() != K_ESC
          if !lDescVenda
            nDesconto += ( ( ( nPrecoVenda * nQtde ) * nDesc ) / 100 )
          endif
          nSubTotal += ( nPrecoVenda * nQtde ) 
          lAlterou  := .t.
    
          @ 03,69 say nPrecoVenda * nQtde   pict '@E 99999.99'
          @ 16,17 say nDesconto             pict '@E 999,999.99'
        
          select( cVendTMP )
          if AdiReg()
            if RegLock()
              replace Sequ       with nSequCupom
              replace Prod       with cProd
              replace Produto    with cProduto
              replace PrecoVenda with nPrecoVenda
              replace PrecoCusto with nPrecoCusto
              replace Unidade    with cUnidade
              replace Desc       with nDesc
              replace Qtde       with nQtde
              dbunlock ()
            endif  
          endif
        else  
          @ 03,69 say 0                     pict '@E 99999.99'
          @ 16,17 say 0                     pict '@E 999,999.99'
        endif  
      endif
    
      select ProdARQ   
      set order to 1
      dbseek( cProd, .f. ) 

    select( cVendTMP )

    oCupom:gobottom ()
    oCupom:forcestable()

    BigNumber( nSubTotal )

    setcolor( CorCabec )
    @ 06,74 say space(05)
    @ 06,74 say alltrim( str( recno() ) ) + '/' + alltrim( str( lastrec() ) )
  enddo  
return NIL

//
// Calcula Valor Total
//
function CalcVT ()
  if nValorTotal > 0
    nQtde := ( nValorTotal / ProdARQ->PrecoVenda )  
  endif
return(.t.)

//
// Calcula o Desconto Discriminado
//          
function DescDisc(lStat)
   if lDescVenda
     if lStat == NIL  
       nPrecoVenda := nPrecoVenda - ( ( nPrecoVenda * nDesc ) / 100 ) 
     else 
       if lStat 
         nPrecoVenda := nPrecoVenda - ( ( nPrecoVenda * nDesc ) / 100 ) 
       endif  
     endif  
   endif  
return(.t.)

//
// Verifica se existe Itens de Produtos
//
function ValidIPro ()
  select IProARQ
  set order to 1
  dbseek( cProd, .t. )
  if Prod == cProd 
    lIProd := .t.
    
    keyboard(chr(K_PGDN))
  else  
    lIProd := .f.
  endif  
  
  select( cVendTMP )
return(.t.)

//
// Alt_S - Desconto
//
function DescPedf ()
  local tReajuste := savescreen( 00, 00, 23, 79 )
  local GetList   := {}
  
  Janela( 09, 48, 14, 74, mensagem( 'Janela', 'DescPedF', .f. ), .t. ) 

  setcolor ( CorJanel + ',' + CorCampo )
  @ 11,51 say 'Desconto        %'
  @ 13,50 say 'Confirmar '
        
  setcolor( CorCampo )
  @ 13,60 say ' Sim '
  @ 13,66 say ' Não '
        
  setcolor( CorAltKC )
  @ 13,61 say 'S'
  @ 13,67 say 'N'
  
  nPerC := 0

  setcolor ( CorJanel + ',' + CorCampo )
  @ 11,60 get nPerC        pict '@E 999.99'
  read
  
  if lastkey () == K_ESC .or. nPerc == 0
    restscreen( 00, 00, 23, 79, tReajuste ) 
    return(.t.)
  endif
        
  lSim := ConfLine( 13, 60, 1 )
       
  restscreen( 00, 00, 23, 79, tReajuste ) 
      
  if lSim          
    setcolor( CorCampo )  
     
    nDesconto := 0
      
    select( cVendTMP )
    set order to 1
    dbgotop()
    do while !eof()
      nDesconto += ( ( ( PrecoVenda * Qtde ) * nPerC ) / 100 )
          
      @ 16,17 say nDesconto       pict '@E 999,999.99'
             
      if RegLock(0)       
        replace Desc       with nPerC
        dbunlock()
      endif  

      dbskip()
    enddo    

    nTotalNota := nSubTotal - nDesconto
    nValorPago := nSubTotal - nDesconto

    @ 16,30 say nTotalNota   pict '@E 999,999.99'
  
    BigNumber( nTotalNota )
  endif  

  oCupom:goTop()
  oCupom:refreshAll()  
return(.t.)

//
// Alterar itens dos produtos
//
function EntrItPP ()
  local GetList := {}
  
  select( cVendTMP )
  set order to 1

  oCupom:colorSpec := CorJanel + ',' + CorCampo
  iExitRequested   := .f.

  do while !iExitRequested
    Mensagem ( 'PedF', 'Coluna' )

    oCupom:forcestable()
    
    cTecla := Teclar(0)

    do case
      case cTecla == K_ALT_S
        tReajuste := savescreen( 00, 00, 23, 79 )

        Janela( 09, 48, 14, 74, mensagem( 'Janela', 'DescPedF', .f. ), .f. )

        setcolor ( CorJanel + ',' + CorCampo )
        @ 11,51 say 'Desconto        %'
        @ 13,50 say 'Confirmar '
        
        setcolor( CorCampo )
        @ 13,60 say ' Sim '
        @ 13,66 say ' Não '
        
        setcolor( CorAltKC )
        @ 13,61 say 'S'
        @ 13,67 say 'N'
  
        nPerC := 0
          
        setcolor ( CorJanel + ',' + CorCampo )
        @ 11,60 get nPerC        pict '@E 999.99'
        read
 
        if lastkey () == K_ESC .or. nPerc == 0
          restscreen( 00, 00, 23, 79, tReajuste ) 
          loop
        endif
        
        lSim := ConfLine( 13, 60, 1 )
       
        restscreen( 00, 00, 23, 79, tReajuste ) 
      
        if lSim          
          setcolor( CorCampo )  
      
          nDesconto := 0
      
          select( cVendTMP )
          set order to 1
          dbgotop()
          do while !eof()
            nDesconto += ( ( ( PrecoVenda * Qtde ) * nPerC ) / 100 )
          
            @ 16,17 say nDesconto       pict '@E 999,999.99'
             
            if RegLock(0)       
              replace Desc       with nPerC
              dbunlock()
            endif  

            dbskip()
          enddo    
        endif  

        oCupom:goTop()
        oCupom:refreshAll()  
      case cTecla == K_DOWN;       oCupom:down()
      case cTecla == K_UP;         oCupom:up()
      case cTecla == K_PGUP;       oCupom:pageUp()
      case cTecla == K_CTRL_PGUP;  oCupom:goTop()
      case cTecla == K_PGDN;       oCupom:pageDown()
      case cTecla == K_CTRL_PGDN;  oCupom:goBottom()
      case cTecla == K_RIGHT;      oCupom:right()
      case cTecla == K_LEFT;       oCupom:left()
      case cTecla == K_HOME;       oCupom:home()
      case cTecla == K_END;        oCupom:end()
      case cTecla == K_CTRL_LEFT;  oCupom:panLeft()
      case cTecla == K_CTRL_RIGHT; oCupom:panRight()
      case cTecla == K_CTRL_HOME;  oCupom:panHome()
      case cTecla == K_CTRL_END;   oCupom:panEnd()
      case cTecla == K_F1;         Ajuda()
      case cTecla == K_INS;        iExitRequested := .t.
      case cTecla == K_ENTER
        if oCupom:colPos == 2
          nQtdeAnt := Qtde
          nQtdeNew := Qtde

          if EmprARQ->Inteira == "X"
            @ 09 + oCupom:rowPos, 63 get nQtdeNew     pict '@E 9999999'
          else  
            @ 09 + oCupom:rowPos, 63 get nQtdeNew     pict '@E 99999.9'
          endif  
          read
          
          if lastkey() != K_ESC
            if RegLock()
              replace Qtde   with nQtdeNew
              dbunlock()
            endif  
          endif
          
          nSubTotal -= ( nQtdeAnt * PrecoVenda )
          nSubTotal += ( nQtdeNew * PrecoVenda )

          BigNumber( nSubTotal )
  
          oCupom:refreshAll()
        endif

        if oCupom:colPos == 3
          nPrecoAnt := PrecoVenda
          nPrecoNew := PrecoVenda
          
          @ 09 + oCupom:rowPos, 71 get nPrecoNew     pict PictPreco(7)
          read
          
          if lastkey() != K_ESC
            if RegLock()
              replace PrecoVenda   with nPrecoNew
              dbunlock()
            endif  
          endif
          
          nSubTotal -= ( Qtde * nPrecoAnt )
          nSubTotal += ( Qtde * nPrecoNew )

          BigNumber( nSubTotal )
  
          oCupom:refreshAll()
        endif
      case cTecla == K_DEL
        setcolor( CorCampo )
        if RegLock()
          nSubTotal -= ( Qtde * PrecoVenda )
          
          BigNumber( nSubTotal )

          dbdelete ()
          dbunlock ()
        endif
        
        if nSubTotal <= 0
          select( cVendTMP )
          set order to 1
          zap
          oCupom:gotop()
          oCupom:forcestable()
        endif  
        
        oCupom:goBottom()
        oCupom:forcestable()
        oCupom:goTop()
        oCupom:forcestable()
        oCupom:refreshAll()
        
      case cTecla == K_ESC         
        if Saindo (lAlterou)
          iExitRequested := .t.
        else
          cTecla         := 0
          iExitRequested := .f.
        endif       
      case cTecla == 46;        oCupom:refreshAll()
        iExitRequested := .t.
    endcase

    setcolor( CorCabec )
    @ 06,74 say space(05)
    @ 06,74 say alltrim( str( recno() ) ) + '/' + alltrim( str( lastrec() ) )
  enddo
  
  oCupom:colorSpec := CorJanel + ',' + CorJanel
return NIL

//
// Calcula do Troco do Cupom Fiscal
//
function PediTroc ()
  Mensagem( 'PedF', 'Acima' )

  if nTotalNota > ( nSubTotal - nDesconto )
    nTotalOld  := nTotalNota
    nTroco     := nTotalNota - ( nSubTotal - nDesconto )
    nTotalNota := ( nSubTotal - nDesconto )

    BigNumber( nTotalNota )

    tTroco     := savescreen( 00, 00, 23, 79 )
 
    setcolor( CorCabec ) 
    @ 06,01 say '                                  Troco  '

    BigNumber( nTroco )

    Teclar(0)

    restscreen( 00, 00, 23, 79, tTroco ) 
  endif
return(.t.)

//
// Calcula o Total do Cupom Fiscal 
//
function FiscPedi()
  local GetList := {}
  
  nTotalNota := nSubTotal - nDesconto
  nValorPago := nSubTotal - nDesconto
  
  if nTotalNota < 0
    return(.t.)
  endif
  
  Mensagem( 'PedF', 'Troco' ) 
  
  BigNumber( nTotalNota )

  if lastkey() == K_UP
    lAlterou := .t.

    if lAutomatico  
      Mensagem( 'PedF', 'Auto' )
    else
      Mensagem( 'PedF', 'Manual' )
    endif  
  
    EntrPedido ()
 
  endif  
return(.t.)

//
// Calcula os Vencimentos do Cupom
//
function PPedVcto ()
  local GetList := {}

  if CondARQ->Pcla > 0
    if select( cVctoTMP ) == 0
      aArqui    := {}
      cVctoARQ  := CriaTemp(0)
      cVctoIND1 := CriaTemp(1)
      cChave    := "Sequ"

      aadd( aArqui, { "Sequ", "N", 004, 0 } )
      aadd( aArqui, { "Data", "D", 008, 0 } )
      aadd( aArqui, { "Valo", "N", 012, 2 } )
      aadd( aArqui, { "Ante", "N", 012, 2 } )

      dbcreate( cVctoARQ , aArqui )
   
      if NetUse( cVctoARQ, .f. )
        cVctoTMP := alias ()
        
        #ifdef DBF_CDX 
          index on &cChave tag &cVctoIND1
        #endif

        #ifdef DBF_NTX
          index on &cChave to &cVctoIND1
          
          set index to &cVctoIND1
        #endif  
      endif
    endif
    
    select( cVctoTMP )
    set order to 1
    dbgotop()
    if eof()   
      nValorParc := nTotalNota / CondARQ->Pcla
      dDataVcto  := dEmis + CondARQ->Vct1
      cDia       := left( dtoc( dDataVcto ), 2 )
      nDia       := val( cDia )
      cMes       := substr( dtoc( dDataVcto ), 4, 2 )
      nMes       := val( cMes )
      cAno       := substr( dtoc( dDataVcto ), 7, 4 )
      nAno       := val( cAno )
      nSequ      := 1
            
      for nK := 1 to CondARQ->Pcla
        if AdiReg()
          if RegLock()
            replace Sequ       with nSequ
            replace Data       with dDataVcto 
            replace Valo       with nValorParc
            replace Ante       with nValorParc
            dbunlock ()
          endif
        endif
      
        nMes  ++
        nSequ ++
 
        if nMes > 12
          nAno ++
          nMes := 1
        endif  

        cMes := strzero( nMes, 2 )
        cAno := strzero( nAno, 4 )

        do case
          case nMes == 2
            if nDia > 28
              dDataVcto := ctod( '28' + '/' + cMes + '/' + cAno )
            else  
              dDataVcto := ctod( cDia + '/' + cMes + '/' + cAno )
            endif  
          case nMes == 4 .or. nMes == 6 .or. nMes == 9 .or. nMes == 11
            if nDia > 30
              dDataVcto := ctod( '30' + '/' + cMes + '/' + cAno )
            else  
              dDataVcto := ctod( cDia + '/' + cMes + '/' + cAno )
            endif  
          otherwise  
            dDataVcto := ctod( cDia + '/' + cMes + '/' + cAno )
        endcase    
      next
    endif  
    
    tVctPedido := savescreen( 00, 00, 24, 79 )
    nLin       := 10
        
    Janela( 04, 18, 18, 60, mensagem( 'Janela', 'PPedVcto', .f. ), .f. )

    setcolor( CorJanel )
    @ 06,20 say 'Portador'
    @ 08,20 say '       Sq. Vencimento      Valor'
    @ 09,18 say chr(195) + replicate( chr(196), 41 ) + chr(180)
                
    select( cVctoTMP )
    set order to 1
    dbgotop()
    do while !eof()
      @ nLin, 27 say Sequ
      @ nLin, 31 say Data        pict '99/99/9999'
      @ nLin, 42 say Valo        pict '@E 999,999.99'
      nLin ++

      if nLin > 17
        exit
      endif  
      dbskip ()
    enddo 
      
    bFirst := {|| dbseek( 01, .t. ) }
    bLast  := {|| dbseek( 99, .t. ), dbskip (-1) }
    bFor   := {|| .t. }
    bWhile := {|| .t. }

    oVcto           := TBrowseFW( bWhile, bFor, bFirst, bLast )
    oVcto:nTop      := 08
    oVcto:nLeft     := 19
    oVcto:nBottom   := 18
    oVcto:nRight    := 59
    oVcto:headsep   := chr(196)
    oVcto:colsep    := ' '
    oVcto:footsep   := chr(196)
    oVcto:colorSpec := CorJanel + ',' + CorCampo

    oVcto:addColumn( TBColumnNew("Sq.",        {|| str( Sequ, 2 ) } ) )
    oVcto:addColumn( TBColumnNew("Vencimento", {|| dtoc( Data ) } ) )
    oVcto:addColumn( TBColumnNew("     Valor", {|| transform( Valo, '@E 999,999.99' ) } ) )

    vExitRequested := .f.
    oVcto:colpos   := 2
    lAdiciona      := .f.
    lAlterou       := .f.
  
    setcolor( CorCampo )
    @ 06,36 say PortARQ->Nome  pict '@S25'
  
    setcolor( CorJanel )  
    @ 09,18 say chr(195)
    @ 09,60 say chr(180)
    
    @ 06,29 get nPort      pict '999999'     valid ValidARQ( 06, 29, cVctoTMP, "Código" , "Port", "Descrição", "Nome", "Port", "nPort", .t., 6, "Consulta de Portadores", "PortARQ", 25 )
    read
    
    cPort := strzero( nPort, 6 )

    do while !vExitRequested
      Mensagem ( 'PedF', 'PPedVcto' )

      oVcto:forcestable()
    
      cTecla := Teclar(0)
     
      do case
        case cTecla == K_DOWN;       oVcto:down()
        case cTecla == K_UP;         oVcto:up()
        case cTecla == K_PGUP;       oVcto:pageUp()
        case cTecla == K_CTRL_PGUP;  oVcto:goTop()
        case cTecla == K_PGDN;       oVcto:pageDown()
        case cTecla == K_CTRL_PGDN;  oVcto:goBottom()
        case cTecla == K_RIGHT;      oVcto:right()
        case cTecla == K_LEFT;       oVcto:left()
        case cTecla == K_HOME;       oVcto:home()
        case cTecla == K_END;        oVcto:end()
        case cTecla == K_ESC;        vExitRequested := .t.
        case cTecla == 46;           vExitRequested := .t.
        case cTecla == K_F1;         Ajuda()
        case cTecla == K_ENTER
          if !empty( Sequ )
            lAdiciona := .f.
            
            EntrPVct( lAdiciona, oVcto )
          endif
        case cTecla == K_DEL
          if RegLock()
            dbdelete ()
            dbunlock ()

            oVcto:refreshAll()
          endif
      endcase
    enddo
    restscreen( 00, 00, 24, 79, tVctPedido )
  else    
    dVcto01  := dVcto02  := dVcto03  := dVcto04  := dVcto05  := ctod ('  /  /  ')
    dVcto06  := dVcto07  := dVcto08  := dVcto09  := ctod ('  /  /  ')
    nValor01 := nValor02 := nValor03 := nValor04 := nValor05 := 0
    nValor06 := nValor07 := nValor08 := nValor09 := 0
    nAnter01 := nAnter02 := nAnter03 := nAnter04 := nAnter05 := 0
    nAnter06 := nAnter07 := nAnter08 := nAnter09 := 0
    nParcAll := 1

    dVcto01    := dEmis + CondARQ->Vct1
    cDia       := strzero( day( dVcto01 ), 2 )
    nDia       := val( cDia )    
    cMes       := strzero( month( dVcto01 ), 2 )
    nMes       := val( cMes )
    cAno       := strzero( year( dVcto01 ), 4 )
    nAno       := val( cAno )

    nTotalNota := nTotalNota + ( nTotalNota * CondARQ->Acrs / 100 )
    nValor01   := nTotalNota
    
    if CondARQ->Vct2 != 0
      dVcto02  := dEmis + CondARQ->Vct2
      
      if CondARQ->VctFixo
        nMes ++
        
        if nMes > 12
          nAno ++
          nMes := 1
        endif  
        
        cMes := strzero( nMes, 2 )
        cAno := strzero( nAno, 4 )
        
        do case
          case nMes == 2
            if nDia > 28
              dVcto02 := ctod( '28' + '/' + cMes + '/' + cAno )
            else  
              dVcto02 := ctod( cDia + '/' + cMes + '/' + cAno )
            endif  
          case nMes == 4 .or. nMes == 6 .or. nMes == 9 .or. nMes == 11
            if nDia > 30
              dVcto02 := ctod( '30' + '/' + cMes + '/' + cAno )
            else  
              dVcto02 := ctod( cDia + '/' + cMes + '/' + cAno )
            endif  
          otherwise  
            dVcto02 := ctod( cDia + '/' + cMes + '/' + cAno )
        endcase    
      endif
      
      if CondARQ->Indi > 0
        nValor01 := nValor02 := nTotalNota * CondARQ->Indi
        nAnter01 := nAnter02 := nTotalNota * CondARQ->Indi
      else       
        nValor01 := nValor02 := nTotalNota / 2
        nAnter01 := nAnter02 := nTotalNota / 2
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct3 != 0
      dVcto03  := dEmis + CondARQ->Vct3
      if CondARQ->VctFixo
        nMes ++
        
        if nMes > 12
          nAno ++
          nMes := 1
        endif  
        
        cMes := strzero( nMes, 2 )
        cAno := strzero( nAno, 4 )
        
        do case
          case nMes == 2
            if nDia > 28
              dVcto03 := ctod( '28' + '/' + cMes + '/' + cAno )
            else  
              dVcto03 := ctod( cDia + '/' + cMes + '/' + cAno )
            endif  
          case nMes == 4 .or. nMes == 6 .or. nMes == 9 .or. nMes == 11
            if nDia > 30
              dVcto03 := ctod( '30' + '/' + cMes + '/' + cAno )
            else  
              dVcto03 := ctod( cDia + '/' + cMes + '/' + cAno )
            endif  
          otherwise  
            dVcto03 := ctod( cDia + '/' + cMes + '/' + cAno )
        endcase    
      endif
      
      if CondARQ->Indi > 0
        nValor01 := nValor02 := nValor03 := nTotalNota * CondARQ->Indi
        nAnter01 := nAnter02 := nAnter03 := nTotalNota * CondARQ->Indi
      else
        nValor01 := nValor02 := nValor03 := nTotalNota / 3
        nAnter01 := nAnter02 := nAnter03 := nTotalNota / 3
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct4 != 0
      dVcto04  := dEmis + CondARQ->Vct4
      if CondARQ->VctFixo
        nMes ++
        
        if nMes > 12
          nAno ++
          nMes := 1
        endif  
        
        cMes := strzero( nMes, 2 )
        cAno := strzero( nAno, 4 )
        
        do case
          case nMes == 2
            if nDia > 28
              dVcto04 := ctod( '28' + '/' + cMes + '/' + cAno )
            else  
              dVcto04 := ctod( cDia + '/' + cMes + '/' + cAno )
            endif  
          case nMes == 4 .or. nMes == 6 .or. nMes == 9 .or. nMes == 11
            if nDia > 30
              dVcto04 := ctod( '30' + '/' + cMes + '/' + cAno )
            else  
              dVcto04 := ctod( cDia + '/' + cMes + '/' + cAno )
            endif  
          otherwise  
            dVcto04 := ctod( cDia + '/' + cMes + '/' + cAno )
        endcase    
      endif

      if CondARQ->Indi > 0
        nValor01 := nValor02 := nValor03 := nValor04 := nTotalNota * CondARQ->Indi
        nAnter01 := nAnter02 := nAnter03 := nAnter04 := nTotalNota * CondARQ->Indi
      else
        nValor01 := nValor02 := nValor03 := nValor04 := nTotalNota / 4
        nAnter01 := nAnter02 := nAnter03 := nAnter04 := nTotalNota / 4
      endif        
      nParcAll ++
    endif

    if CondARQ->Vct5 != 0
      dVcto05  := dEmis + CondARQ->Vct5
      if CondARQ->VctFixo
        nMes ++
        
        if nMes > 12
          nAno ++
          nMes := 1
        endif  
        
        cMes := strzero( nMes, 2 )
        cAno := strzero( nAno, 4 )
        
        do case
          case nMes == 2
            if nDia > 28
              dVcto05 := ctod( '28' + '/' + cMes + '/' + cAno )
            else  
              dVcto05 := ctod( cDia + '/' + cMes + '/' + cAno )
            endif  
          case nMes == 4 .or. nMes == 6 .or. nMes == 9 .or. nMes == 11
            if nDia > 30
              dVcto05 := ctod( '30' + '/' + cMes + '/' + cAno )
            else  
              dVcto05 := ctod( cDia + '/' + cMes + '/' + cAno )
            endif  
          otherwise  
            dVcto05 := ctod( cDia + '/' + cMes + '/' + cAno )
        endcase    
      endif
      
      if CondARQ->Indi > 0
        nValor01 := nValor02 := nValor03 := nValor04 := nValor05 := nTotalNota * CondARQ->Indi
        nAnter01 := nAnter02 := nAnter03 := nAnter04 := nAnter05 := nTotalNota * CondARQ->Indi
      else  
        nValor01 := nValor02 := nValor03 := nValor04 := nValor05 := nTotalNota / 5
        nAnter01 := nAnter02 := nAnter03 := nAnter04 := nAnter05 := nTotalNota / 5
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct6 != 0
      dVcto06  := dEmis + CondARQ->Vct6
      if CondARQ->VctFixo
        nMes ++
        
        if nMes > 12
          nAno ++
          nMes := 1
        endif  
        
        cMes := strzero( nMes, 2 )
        cAno := strzero( nAno, 4 )
        
        do case
          case nMes == 2
            if nDia > 28
              dVcto06 := ctod( '28' + '/' + cMes + '/' + cAno )
            else  
              dVcto06 := ctod( cDia + '/' + cMes + '/' + cAno )
            endif  
          case nMes == 4 .or. nMes == 6 .or. nMes == 9 .or. nMes == 11
            if nDia > 30
              dVcto06 := ctod( '30' + '/' + cMes + '/' + cAno )
            else  
              dVcto06 := ctod( cDia + '/' + cMes + '/' + cAno )
            endif  
          otherwise  
            dVcto06 := ctod( cDia + '/' + cMes + '/' + cAno )
        endcase    
      endif

      if CondARQ->Indi > 0
        nValor01 := nValor02 := nValor03 := nValor04 := nValor05 := nValor06 := nTotalNota * CondARQ->Indi
        nAnter01 := nAnter02 := nAnter03 := nAnter04 := nAnter05 := nAnter06 := nTotalNota * CondARQ->Indi
      else
        nValor01 := nValor02 := nValor03 := nValor04 := nValor05 := nValor06 := nTotalNota / 6
        nAnter01 := nAnter02 := nAnter03 := nAnter04 := nAnter05 := nAnter06 := nTotalNota / 6
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct7 != 0
      dVcto07  := dEmis + CondARQ->Vct7
      if CondARQ->VctFixo
        nMes ++
        
        if nMes > 12
          nAno ++
          nMes := 1
        endif  
        
        cMes := strzero( nMes, 2 )
        cAno := strzero( nAno, 4 )
        
        do case
          case nMes == 2
            if nDia > 28
              dVcto07 := ctod( '28' + '/' + cMes + '/' + cAno )
            else  
              dVcto07 := ctod( cDia + '/' + cMes + '/' + cAno )
            endif  
          case nMes == 4 .or. nMes == 6 .or. nMes == 9 .or. nMes == 11
            if nDia > 30
              dVcto07 := ctod( '30' + '/' + cMes + '/' + cAno )
            else  
              dVcto07 := ctod( cDia + '/' + cMes + '/' + cAno )
            endif  
          otherwise  
            dVcto07 := ctod( cDia + '/' + cMes + '/' + cAno )
        endcase    
      endif

      if CondARQ->Indi > 0
        nValor01 := nValor02 := nValor03 := nValor04 := nValor05 := nValor06 := nValor07 := nTotalNota * CondARQ->Indi
        nAnter01 := nAnter02 := nAnter03 := nAnter04 := nAnter05 := nAnter06 := nAnter07 := nTotalNota * CondARQ->Indi
      else
        nValor01 := nValor02 := nValor03 := nValor04 := nValor05 := nValor06 := nValor07 := nTotalNota / 7
        nAnter01 := nAnter02 := nAnter03 := nAnter04 := nAnter05 := nAnter06 := nAnter07 := nTotalNota / 7
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct8 != 0
      dVcto08  := dEmis + CondARQ->Vct8
      if CondARQ->VctFixo
        nMes ++
        
        if nMes > 12
          nAno ++
          nMes := 1
        endif  
        
        cMes := strzero( nMes, 2 )
        cAno := strzero( nAno, 4 )
        
        do case
          case nMes == 2
            if nDia > 28
              dVcto08 := ctod( '28' + '/' + cMes + '/' + cAno )
            else  
              dVcto08 := ctod( cDia + '/' + cMes + '/' + cAno )
            endif  
          case nMes == 4 .or. nMes == 6 .or. nMes == 9 .or. nMes == 11
            if nDia > 30
              dVcto08 := ctod( '30' + '/' + cMes + '/' + cAno )
            else  
              dVcto08 := ctod( cDia + '/' + cMes + '/' + cAno )
            endif  
          otherwise  
            dVcto08 := ctod( cDia + '/' + cMes + '/' + cAno )
        endcase    
      endif

      if CondARQ->Indi > 0
        nValor01 := nValor02 := nValor03 := nValor04 := nValor05 := nValor06 := nValor07 := nValor08 := nTotalNota * CondARQ->Indi
        nAnter01 := nAnter02 := nAnter03 := nAnter04 := nAnter05 := nAnter06 := nAnter07 := nAnter08 := nTotalNota * CondARQ->Indi
      else
        nValor01 := nValor02 := nValor03 := nValor04 := nValor05 := nValor06 := nValor07 := nValor08 := nTotalNota / 8
        nAnter01 := nAnter02 := nAnter03 := nAnter04 := nAnter05 := nAnter06 := nAnter07 := nAnter08 := nTotalNota / 8
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct9 != 0
      dVcto09  := dEmis + CondARQ->Vct9
      if CondARQ->VctFixo
        nMes ++
        
        if nMes > 12
          nAno ++
          nMes := 1
        endif  
        
        cMes := strzero( nMes, 2 )
        cAno := strzero( nAno, 4 )
        
        do case
          case nMes == 2
            if nDia > 28
              dVcto09 := ctod( '28' + '/' + cMes + '/' + cAno )
            else  
              dVcto09 := ctod( cDia + '/' + cMes + '/' + cAno )
            endif  
          case nMes == 4 .or. nMes == 6 .or. nMes == 9 .or. nMes == 11
            if nDia > 30
              dVcto09 := ctod( '30' + '/' + cMes + '/' + cAno )
            else  
              dVcto09 := ctod( cDia + '/' + cMes + '/' + cAno )
            endif  
          otherwise  
            dVcto09 := ctod( cDia + '/' + cMes + '/' + cAno )
        endcase    
      endif
      
      if CondARQ->Indi > 0
        nValor01 := nValor02 := nValor03 := nValor04 := nValor05 := nValor06 := nValor07 := nValor08 := nValor09 := nTotalNota * CondARQ->Indi
        nAnter01 := nAnter02 := nAnter03 := nAnter04 := nAnter05 := nAnter06 := nAnter07 := nAnter08 := nAnter09 := nTotalNota * CondARQ->Indi
      else 
        nValor01 := nValor02 := nValor03 := nValor04 := nValor05 := nValor06 := nValor07 := nValor08 := nValor09 := nTotalNota / 9
        nAnter01 := nAnter02 := nAnter03 := nAnter04 := nAnter05 := nAnter06 := nAnter07 := nAnter08 := nAnter09 := nTotalNota / 9
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct1 == 0 .and. CondARQ->Vct2 == 0 .and. CondARQ->Vct3 == 0 .and.;
       CondARQ->Vct4 == 0 .and. CondARQ->Vct5 == 0 .and. CondARQ->Vct6 == 0 .and.;
       CondARQ->Vct7 == 0 .and. CondARQ->Vct8 == 0 .and. CondARQ->Vct9 == 0 .or.;
       nCond         == 0
    else
      tVcto := savescreen( 00, 00, 24, 79 )
      cFatu := "X"      
  
      Janela ( 05, 09, 11 + nParcAll, 63, mensagem( 'Janela', 'PPedVcto', .f. ), .t. )
      Mensagem ( 'PedF', 'Vcto' )

      setcolor ( CorJanel )
      @ 07,11 say '  Vencimento 1              Valor 1'
      if nParcAll >= 2
        @ 08,11 say '  Vencimento 2              Valor 2'
      endif  
      if nParcAll >= 3
        @ 09,11 say '  Vencimento 3              Valor 3'
      endif  
      if nParcAll >= 4
        @ 10,11 say '  Vencimento 4              Valor 4'
      endif  
      if nParcAll >= 5
        @ 11,11 say '  Vencimento 5              Valor 5'
      endif  
      if nParcAll >= 6
        @ 12,11 say '  Vencimento 6              Valor 6'
      endif  
      if nParcAll >= 7
        @ 13,11 say '  Vencimento 7              Valor 7'
      endif  
      if nParcAll >= 8
        @ 14,11 say '  Vencimento 8              Valor 8'
      endif  
      if nParcAll >= 9
        @ 15,11 say '  Vencimento 9              Valor 9'
      endif  

      @ 08 + nParcAll,11 say '      Portador'
      @ 10 + nParcAll,50 say '[ ] Faturar'

      setcolor( CorCampo )
      if nPort == 0
        @ 08 + nParcAll,33 say space(30)
      else  
        @ 08 + nParcAll,33 say PortARQ->Nome       pict '@S30'
      endif  

      setcolor ( CorJanel + ',' + CorCampo )
      @ 07,26 get dVcto01      pict '99/99/9999'
      @ 07,47 get nValor01     pict '@E 999,999,999.99'   valid CalcEntP()
      if nParcAll >= 2
        @ 08,26 get dVcto02    pict '99/99/9999'
        @ 08,47 get nValor02   pict '@E 999,999,999.99'   valid CalcEntP()
      endif  
      if nParcAll >= 3
        @ 09,26 get dVcto03    pict '99/99/9999'
        @ 09,47 get nValor03   pict '@E 999,999,999.99'   valid CalcEntP()
      endif  
      if nParcAll >= 4
        @ 10,26 get dVcto04    pict '99/99/9999'
        @ 10,47 get nValor04   pict '@E 999,999,999.99'   valid CalcEntP()
      endif  
      if nParcAll >= 5
        @ 11,26 get dVcto05    pict '99/99/9999'
        @ 11,47 get nValor05   pict '@E 999,999,999.99'   valid CalcEntP()
      endif  
      if nParcAll >= 6
        @ 12,26 get dVcto06    pict '99/99/9999'
        @ 12,47 get nValor06   pict '@E 999,999,999.99'   valid CalcEntP()
      endif  
      if nParcAll >= 7
        @ 13,26 get dVcto07    pict '99/99/9999'
        @ 13,47 get nValor07   pict '@E 999,999,999.99'   valid CalcEntP() 
      endif  
      if nParcAll >= 8
        @ 14,26 get dVcto08    pict '99/99/9999'
        @ 14,47 get nValor08   pict '@E 999,999,999.99'   valid CalcEntP()
      endif  
      if nParcAll >= 9
        @ 15,26 get dVcto09    pict '99/99/9999'
        @ 15,47 get nValor09   pict '@E 999,999,999.99'   valid CalcEntP()
      endif  
      
      @ 08 + nParcAll,26 get nPort      pict '999999'   valid ValidARQ( 08 + nParcAll, 26, "NSaiARQ", "Código" , "Port", "Descrição", "Nome", "Port", "nPort", .t., 6, "Consulta de Portadores", "PortARQ", 30 )
      @ 10 + nParcAll,51 get cFatu      pict '@!'
      read
 
      aGetVend := ''
      cPort    := strzero( nPort, 6 )

      restscreen( 00, 00, 24, 79, tVcto )
    endif
  endif
return(.t.)

//
// Entra com os vctos do Pedifo
//
function EntrPVct( lAdiciona, oVcto )
  local GetList   := {}
  local nRegiPedi := recno ()

  if lAdiciona 
    dbgotop ()
    do while !eof ()
      nSequ := Sequ       

      dbskip ()
    enddo
        
    nSequ ++  
   
    if AdiReg()
      if RegLock()
        replace Sequ            with nSequ
        dbunlock ()
      endif
    endif    
    
    dbgobottom ()

    oVcto:goBottom() 
    oVcto:refreshAll()  

    oVcto:forcestable()
      
    Mensagem( 'PedF', 'PVctIncl' )
  else
    Mensagem( 'PedF', 'PVctIncl' )
  endif  

  nSequ      := Sequ 
  dData      := Data
  nValo      := Valo
  nLin       := 9 + oVcto:rowPos
  
  keyboard( "" )

  setcolor ( CorJanel + ',' + CorCampo )
  @ nLin, 31 get dData        pict '99/99/9999'
  @ nLin, 42 get nValo        pict '@E 999,999.99' valid CalcEnPV()
  read
     
  cTecla := lastkey()

  if cTecla == K_ESC
    if lAdiciona
      if RegLock()
        dbdelete () 
        dbunlock () 
      endif  
    endif  
    
    oVcto:refreshCurrent()  
    oVcto:goBottom()
    return NIL
  endif  
  
  if cTecla == K_UP .or. cTecla == K_DOWN .or. cTecla == K_PGUP .or. cTecla == K_PGDN
    keyboard( chr(cTecla) )
  endif
  
  if RegLock()
    replace Data           with dData
    replace Valo           with nValo
    dbunlock ()
  endif
  
  oVcto:refreshCurrent()  
   
  lAlterou := .t.
return NIL     

//
// Calcula Comissao dos Vendedores
// 
function ComiPedf ()
  nComissao := 0
  nComis01  := nComis02 := nComis03 := nComis04 := nComis05 := 0
  nComis06  := nComis07 := nComis08 := nComis09 := 0
  lPerC     := .f.

  select( cVendTMP )
  set order to 1
  dbgotop ()
  do while !eof ()
    if ProdARQ->PerC == 0
      nComissao += ( ( PrecoVenda * Qtde ) * ReprARQ->PerC ) / 100
    else
      nComissao += ( ( PrecoVenda * Qtde ) * ProdARQ->PerC ) / 100
      lPerC     := .t.
    endif

    dbskip ()
  enddo
  
  if !lPerC
    nComissao := ( ( nTotalNota ) * ReprARQ->PerC ) / 100
  endif

  select CondARQ
  set order to 1
  dbseek( strzero( nCond, 6 ), .f. )
  if found()
    nComis01 := nComissao

    if CondARQ->Vct2 != 0
      nComis01 := nComis02 := nComissao / 2
    endif

    if CondARQ->Vct3 != 0
      nComis01 := nComis02 := nComis03 := nComissao / 3
    endif

    if CondARQ->Vct4 != 0
      nComis01 := nComis02 := nComis03 := nComis04 := nComissao / 4
    endif

    if CondARQ->Vct5 != 0
      nComis01 := nComis02 := nComis03 := nComis04 := nComis05 := nComissao / 5
    endif

    if CondARQ->Vct6 != 0
      nComis01 := nComis02 := nComis03 := nComis04 := nComis05 := nComis06 := nComissao / 6
    endif

    if CondARQ->Vct7 != 0
      nComis01 := nComis02 := nComis03 := nComis04 := nComis05 := nComis06 := nComis07 := nComissao / 7
    endif

    if CondARQ->Vct8 != 0
      nComis01 := nComis02 := nComis03 := nComis04 := nComis05 := nComis06 := nComis07 := nComis08 := nComissao / 8
    endif

    if CondARQ->Vct9 != 0
      nComis01 := nComis02 := nComis03 := nComis04 := nComis05 := nComis06 := nComis07 := nComis08 := nComis09 := nComissao / 9
    endif
  endif
return(.t.)

//
// Calcula a Entrada  
//
function CalcEntP()
  nTotaEntr := 0
  aSim      := {}
  aNao      := {}
  
  for nK := 1 to 9
    cN := strzero( nK, 2 )
    
    if nValor&cN != nAnter&cN
      nTotaEntr += nValor&cN
      
      aadd( aSim, cN )
    else
      if nValor&cN > 0
        aadd( aNao, cN )
      endif  
    endif
  next

  if len( aSim ) > 0
    for nH := 1 to len( aNao )
      cA := strzero( val( aNao[ nH ] ), 2 )

      nValor&cA := ( nTotalNota - nTotaEntr ) / len( aNao )
      nAnter&cA := ( nTotalNota - nTotaEntr ) / len( aNao )
    next
  endif    

  setcolor( CorCampo )
  @ 07,26 say dVcto01      pict '99/99/9999'          
  @ 07,47 say nValor01     pict '@E 999,999,999.99'
  if nParcAll >= 2
    @ 08,26 say dVcto02    pict '99/99/9999'
    @ 08,47 say nValor02   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 3
    @ 09,26 say dVcto03    pict '99/99/9999'
    @ 09,47 say nValor03   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 4
    @ 10,26 say dVcto04    pict '99/99/9999'
    @ 10,47 say nValor04   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 5
    @ 11,26 say dVcto05    pict '99/99/9999'
    @ 11,47 say nValor05   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 6
    @ 12,26 say dVcto06    pict '99/99/9999'
    @ 12,47 say nValor06   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 7
    @ 13,26 say dVcto07    pict '99/99/9999'
    @ 13,47 say nValor07   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 8
    @ 14,26 say dVcto08    pict '99/99/9999'
    @ 14,47 say nValor08   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 9
    @ 15,26 say dVcto09    pict '99/99/9999'
    @ 15,47 say nValor09   pict '@E 999,999,999.99'
  endif  
  setcolor( CorJanel + ',' + CorCampo )
return(.t.)

//
// Calcula a Entrada - Quando Parcela > 0
//
function CalcEnPV()
  nTotaEntr := 0
  aNao      := {}
  nRegi     := recno ()
  
  if lastkey () == K_ENTER
    if RegLock(0)
      replace Valo       with nValo
      dbunlock ()
    endif
  endif    
  
  dbgotop()
  
  do while !eof()
    if Valo != Ante
      nTotaEntr += Valo
    else
      if Valo > 0
        aadd( aNao, recno() )
      endif  
    endif
    dbskip ()
  enddo

  if nTotaEntr > 0
    for nH := 1 to len( aNao )
      go aNao[ nH ]
      if RegLock(0)
        replace Valo        with ( ( nTotalNota - nTotaEntr ) / len( aNao ) )
        replace Ante        with ( ( nTotalNota - nTotaEntr ) / len( aNao ) )
        dbunlock()
      endif
    next
  endif    
  
  go nRegi
  
  oVcto:refreshAll()  
  oVcto:forcestable()
return(.t.)

//
// Imprimir Pedido
//
function PPPedido (lTexto)

  nPrn   := 0
    
  if lTexto
    lTexto := .f.
    if EmprARQ->Impr == "X"
      if !TestPrint( EmprARQ->Pedido )
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
    endif  
  else   
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

  tPrt  := savescreen( 00, 00, 23, 79 )
  
  do case
    case EmprARQ->TipoPedi == 1
      for nK := 1 to EmprARQ->CopiaNota
        nLin := 0
        
        if lTexto .or. EmprARQ->Impr == "X"

          setprc( 0, 0 )

          @ 00,00 say chr(27) + "@"
          @ 00,00 say chr(18)
          @ 00,00 say chr(27) + chr(67) + chr(33)
        endif  

        @ nLin,01 say '+----------------------------------------------------------------------------+'
        nLin ++
        if EmprARQ->EmprPedi == "X"
          @ nLin,01 say '|'
          @ nLin,03 say EmprARQ->Razao       pict '@S40'
          if !empty( EmprARQ->CGC )
            @ nLin,54 say 'CNPJ'
            @ nLin,59 say EmprARQ->CGC         pict '@R 99.999.999/9999-99'
          endif  
          @ nLin,78 say '|'
          nLin ++
          @ nLin,01 say '|'
          @ nLin,03 say EmprARQ->Ende        pict '@S40'
          if !empty( EmprARQ->InscEstd )
            @ nLin,46 say 'Insc. Estad. ' + left( EmprARQ->InscEstd, 14 ) 
          endif  
          @ nLin,78 say '|'
          nLin ++
          @ nLin,01 say '|'
          @ nLin,03 say EmprARQ->Bairro      pict '@S15'
          @ nLin,24 say alltrim( EmprARQ->Cida ) + '-' + EmprARQ->UF
          if !empty( EmprARQ->Fone )
            @ nLin,54 say 'Fone'
            @ nLin,59 say alltrim( EmprARQ->Fone )
          endif  
          @ nLin,78 say '|'
          nLin ++
          @ nLin,01 say '+----------------------------------------------------------------------------+'
          nLin ++
        endif
        @ nLin,01 say '|      Pedido'
        @ nLin,15 say cNotaNew
        @ nLin,45 say 'Data'
        @ nLin,50 say dEmis
        @ nLin,62 say 'Hora'
        @ nLin,67 say time()
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '|        Nome'
        if cClie == '999999'
          @ nLin,15 say left( cCliente, 30 ) + ' ' + cClie
        else
          @ nLin,15 say left( ClieARQ->Nome, 30 ) + ' ' + cClie
        endif
        @ nLin,53 say 'Fone ' + alltrim( ClieARQ->Fone )
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '|    Endereço'
        @ nLin,15 say left( alltrim( ClieARQ->Ende ) + ' ' + alltrim( ClieARQ->Bair ) + ' ' + alltrim( ClieARQ->Cida ) + ' ' + alltrim( ClieARQ->UF ), 62)
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '|   Condições '
        @ nLin,15 say CondARQ->Nome
        @ nLin,78 say '|'
        nLin ++

        if CondARQ->Vct1 == 0 .and. CondARQ->Vct2 == 0 .and. CondARQ->Vct3 == 0 .and. CondARQ->Vct4 == 0 .and. CondARQ->Vct5 == 0
          lVista := .t.
        else
          @ nLin,01 say '| Vencimentos '
          if nValor01 > 0
            @ nLin,15 say dVcto01         pict '99/99/9999'
            @ nLin,26 say nValor01        pict '@E 99,999.99'
          endif

          if nValor02 > 0
            @ nLin,36 say dVcto02       pict '99/99/9999'
            @ nLin,47 say nValor02      pict '@E 99,999.99'
          endif

          if nValor03 > 0
            @ nLin,57 say dVcto03       pict '99/99/9999'
            @ nLin,68 say nValor03      pict '@E 99,999.99'
          endif

          @ nLin,78 say '|'
          nLin ++
          @ nLin,01 say '|'
          if nValor04 > 0
            @ nLin,15 say dVcto04       pict '99/99/9999'
            @ nLin,26 say nValor04      pict '@E 99,999.99'
          endif
          if nValor05 > 0
            @ nLin,36 say dVcto05       pict '99/99/9999'
            @ nLin,47 say nValor05      pict '@E 99,999.99'
          endif
          if nValor06 > 0
            @ nLin,57 say dVcto06       pict '99/99/9999'
            @ nLin,68 say nValor06      pict '@E 99,999.99'
          endif
          @ nLin,78 say '|'
          nLin   ++
          lVista := .f.
        endif

        @ nLin,01 say '+---------+----+---------------------------------------+----------+----------+'
        nLin ++
        @ nLin,01 say '|   Qtde. | Un | Produto/Serviço                       | P. Unit. |    Total |'
        nLin ++
        @ nLin,01 say '+---------+----+---------------------------------------+----------+----------+'
        nLin ++

        nValorTotal := nTotalNota := 0
        nSequ       := 0

        select( cVendTMP )
        set order to 1
        dbgotop ()
        do while !eof ()
          if EmprARQ->Juro == "X"
            nPrecoVenda := PrecoVenda
            nValorTotal := Qtde * nPrecoVenda
            nTotalNota  += nValorTotal
          else
            nPrecoVenda := ( ( PrecoVenda * CondARQ->Acrs ) / 100 ) + PrecoVenda
            nValorTotal := Qtde * nPrecoVenda
            nTotalNota  += nValorTotal
          endif

          @ nLin,01 say '|'
          if EmprARQ->Inteira == "X"
            @ nLin,02 say Qtde           pict '@E 999999999'
          else
            @ nLin,02 say Qtde           pict '@E 99999.999'
          endif
          @ nLin,11 say '|'
          if Prod == '999999'
            @ nLin,13 say Unidade
          else
            @ nLin,13 say ProdARQ->Unid
          endif
          @ nLin,16 say '|'
          if Prod == '999999'
            @ nLin,17 say memoline( Produto, 32, 1 ) + ' ' + Prod
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

          nItens := iif( EmprARQ->EmprPedi == "X", 14, 17 )

          if nSequ > nItens
            @ nLin,01 say '+---------+----+---------------------------------------+----------+----------+'
            nLin ++
            @ nLin,01 say '|'
            @ nLin,43 say 'A Transportar'
            @ nLin,68 say nTotalNota     pict '@E 999,999.99'
            @ nLin,78 say '|'
            nLin ++
            @ nLin,01 say '+----------------------------------------------------------------------------+'

            nLin += 5

            @ nLin,01 say '+----------------------------------------------------------------------------+'
            nLin ++
            @ nLin,01 say '|      Pedido'
            @ nLin,15 say cNotaNew
            @ nLin,62 say 'Data'
            @ nLin,67 say dEmis
            @ nLin,78 say '|'
            nLin ++
            @ nLin,01 say '|        Nome'
            if cClie == '999999'
              @ nLin,15 say left( Cliente, 40 ) + ' ' + cClie
            else
              @ nLin,15 say left( ClieARQ->Nome, 40 ) + ' ' + cClie
            endif
            @ nLin,62 say 'Hora'
            @ nLin,67 say time()
            @ nLin,78 say '|'
            nLin ++
            @ nLin,01 say '|    Endereço'
            @ nLin,15 say left( alltrim( ClieARQ->Ende ) + ' ' + alltrim( ClieARQ->Bair ) + ' ' + alltrim( ClieARQ->Cida ) + ' ' + alltrim( ClieARQ->UF ), 62)
            @ nLin,78 say '|'
            nLin ++
            @ nLin,01 say '|   Condiç”es'
            @ nLin,15 say CondARQ->Nome
            @ nLin,78 say '|'
            nLin ++
            @ nLin,01 say '+---------+----+---------------------------------------+----------+----------+'
            nLin ++
            @ nLin,01 say '|   Qtde. | Un | Produto/Serviço                       | P. Venda |    Total |'
            nLin ++
            @ nLin,01 say '+---------+----+---------------------------------------+----------+----------+'
            nLin ++
            @ nLin,01 say '|         |    |TRANSPORTE DE                          |          |'
            @ nLin,68 say nTotalNota          pict '@E 999,999.99'
            @ nLin,78 say '|'
            nLin  ++
            nSequ := 0
          endif

          dbskip ()
        enddo

        nTotalNota -= nDesconto

        if EmprARQ->Juro == "X" 
          nJuros     := ( nTotalNota * CondARQ->Acrs / 100 )
          nTotalNota += nJuros

          if nJuros > 0
            @ nLin,01 say '|         |    |JUROS                                  |          |'
            @ nLin,68 say nJuros    pict '@E 999,999.99'
            @ nLin,78 say '|'
            nLin  ++
            nSequ ++
          endif
        endif

        if nDesconto > 0
          @ nLin,01 say '|         |    |Desconto                               |          |'
          @ nLin,68 say nDesconto    pict '@E 999,999.99'
          @ nLin,78 say '|'
          nLin  ++
          nSequ ++
        endif

        nTotal := iif( EmprARQ->EmprPedi == "X", 13, 17 )

        if nSequ < nTotal
          for nIni := 1 to ( nTotal - nSequ )
            @ nLin, 01 say '|         |    |                                       |          |          |'
            nLin ++
          next
        endif

        @ nLin,01 say '|         |    |Assinatura:                            |          |          |'
        nLin ++
        @ nLin,01 say '+---------+--------------------------------------------+----------+----------+'

        nLin ++
        @ nLin,01 say '| ' + alltrim( EmprARQ->Mensagem )

        @ nLin,63 say 'Total'
        @ nLin,68 say nTotalNota     pict '@E 999,999.99'
        @ nLin,78 say '|'

        nLin ++
        @ nLin,01 say '+----------------------------------------------------------------------------+'

        if lVista
          nLin += 6
        else
          nLin += 4
        endif
        
        if lTexto .or. EmprARQ->Impr == "X"
          @ nLin,00 say chr(27) + "@"
        endif  
      next
    case EmprARQ->TipoPedi == 2
      for nK := 1 to EmprARQ->CopiaNota
        nLin := 0
        
        if lTexto .or. EmprARQ->Impr == "X"
          setprc( 0, 0 )

          @ 00,00 say chr(27) + "@"
          @ 00,00 say chr(18)
          @ 00,00 say chr(27) + chr(67) + chr(66)
        endif  

        @ nLin,01 say '+----------------------------------------------------------------------------+'
        nLin ++
        if EmprARQ->EmprPedi == "X"
          @ nLin,01 say '|'
          @ nLin,03 say EmprARQ->Razao       pict '@S40'
          if !empty( EmprARQ->CGC )
            @ nLin,54 say 'CNPJ'
            @ nLin,59 say EmprARQ->CGC         pict '@R 99.999.999/9999-99'
          endif   
          @ nLin,78 say '|'
          nLin ++
          @ nLin,01 say '|'
          @ nLin,03 say EmprARQ->Ende        pict '@S40'
          if !empty( EmprARQ->InscEstd )
            @ nLin,46 say 'Insc. Estad. ' + left( EmprARQ->InscEstd, 14 )
          endif  
          @ nLin,78 say '|'
          nLin ++
          @ nLin,01 say '|'
          @ nLin,03 say EmprARQ->Bairro      pict '@S15'
          @ nLin,24 say alltrim( EmprARQ->Cida ) + '-' + EmprARQ->UF
          if !empty( EmprARQ->Fone )
            @ nLin,54 say 'Fone'
            @ nLin,59 say alltrim( EmprARQ->Fone )
          endif  
          @ nLin,78 say '|'
          nLin ++
          @ nLin,01 say '+----------------------------------------------------------------------------+'
          nLin ++
        endif
        @ nLin,01 say '|      Pedido'
        @ nLin,15 say cNotaNew
        @ nLin,62 say 'Data'
        @ nLin,67 say dEmis
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '|        Nome'
        if cClie == '999999'
          @ nLin,15 say left( cCliente, 38 ) + ' ' + cClie
        else
          @ nLin,15 say left( ClieARQ->Nome, 38 ) + ' ' + cClie
        endif
        @ nLin,62 say 'Hora'
        @ nLin,67 say time()
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '|    Endereço'
        @ nLin,15 say left( alltrim( ClieARQ->Ende ) + ' ' + alltrim( ClieARQ->Bair ) + ' ' + alltrim( ClieARQ->Cida ) + ' ' + alltrim( ClieARQ->UF ), 62)
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '|   Condiç”es '
        @ nLin,15 say CondARQ->Nome
        @ nLin,78 say '|'
        nLin ++

        if CondARQ->Vct1 == 0 .and. CondARQ->Vct2 == 0 .and. CondARQ->Vct3 == 0 .and. CondARQ->Vct4 == 0 .and. CondARQ->Vct5 == 0
          lVista := .t.
        else
          @ nLin,01 say '| Vencimentos '
          if nValor01 > 0
            @ nLin,15 say dVcto01         pict '99/99/9999'
            @ nLin,24 say nValor01        pict '@E 999,999.99'
          endif

          if nValor02 > 0
            @ nLin,36 say dVcto02       pict '99/99/9999'
            @ nLin,47 say nValor02      pict '@E 999,999.99'
          endif

          if nValor03 > 0
            @ nLin,57 say dVcto03       pict '99/99/9999'
            @ nLin,66 say nValor03      pict '@E 999,999.99'
          endif

          @ nLin,78 say '|'
          nLin ++

          @ nLin,01 say '|'
          if nValor04 > 0
            @ nLin,15 say dVcto04       pict '99/99/9999'
            @ nLin,24 say nValor04      pict '@E 999,999.99'
          endif
          @ nLin,78 say '|'

          if nValor05 > 0
            @ nLin,37 say dVcto05       pict '99/99/9999'
            @ nLin,45 say nValor05      pict '@E 999,999.99'
          endif

          if nValor06 > 0
            @ nLin,57 say dVcto06       pict '99/99/9999'
            @ nLin,68 say nValor06      pict '@E 99,999.99'
          endif
          nLin   ++
          lVista := .f.
        endif

        @ nLin,01 say '+---------+--------------------------------------------+----------+----------+'
        nLin ++
        @ nLin,01 say '|   Qtde. | Descrição                                  | P. Venda |    Total |'
        nLin ++
        @ nLin,01 say '+---------+--------------------------------------------+----------+----------+'
        nLin ++

        nValorTotal := nTotalNota := 0
        nSequ       := 0

        select( cVendTMP )
        set order to 1
        dbgotop ()
        do while !eof ()
          if EmprARQ->Juro == "X"
            nPrecoVenda := PrecoVenda
            nValorTotal := Qtde * nPrecoVenda
            nTotalNota  += nValorTotal
          else
            nPrecoVenda := ( ( PrecoVenda * CondARQ->Acrs ) / 100 ) + PrecoVenda
            nValorTotal := Qtde * nPrecoVenda
            nTotalNota  += nValorTotal
          endif

          @ nLin,01 say '|'
          if EmprARQ->Inteira == "X"
            @ nLin,02 say Qtde           pict '@E 999999999'
          else
            @ nLin,02 say Qtde           pict '@E 99999.999'
          endif
          @ nLin,11 say '|'
          if Prod == '999999'
            @ nLin,12 say left( Produto, 37 ) + ' ' + Prod
          else
            @ nLin,12 say left( ProdARQ->Nome, 37 ) + ' ' + Prod
          endif
          @ nLin,56 say '|'
          @ nLin,57 say nPrecoVenda    pict PictPreco(10)
          @ nLin,67 say '|'
          @ nLin,68 say nValorTotal    pict '@E 999,999.99'
          @ nLin,78 say '|'

          nSequ ++
          nLin  ++

          nItens := iif( EmprARQ->EmprPedi == "X", 46, 49 )

          if nSequ > nItens
            @ nLin,01 say '+---------+--------------------------------------------+----------+----------+'
            nLin ++
            @ nLin,01 say '|'
            @ nLin,43 say 'A Transportar'
            @ nLin,68 say nTotalNota     pict '@E 999,999.99'
            @ nLin,78 say '|'
            nLin ++
            @ nLin,01 say '+----------------------------------------------------------------------------+'

            nLin += 5

            @ nLin,01 say '+----------------------------------------------------------------------------+'
            nLin ++
            @ nLin,01 say '|      Pedido'
            @ nLin,15 say cNotaNew
            @ nLin,62 say 'Data'
            @ nLin,67 say dEmis
            @ nLin,78 say '|'
            nLin ++
            @ nLin,01 say '|        Nome'
            if cClie == '999999'
              @ nLin,15 say left( Cliente, 38 ) + ' ' + cClie
            else
              @ nLin,15 say left( ClieARQ->Nome, 38 ) + ' ' + cClie
            endif
            @ nLin,62 say 'Hora'
            @ nLin,67 say time()
            @ nLin,78 say '|'
            nLin ++
            @ nLin,01 say '|    Endereço'
            @ nLin,15 say left( alltrim( ClieARQ->Ende ) + ' ' + alltrim( ClieARQ->Bair ) + ' ' + alltrim( ClieARQ->Cida ) + ' ' + alltrim( ClieARQ->UF ), 62)
            @ nLin,78 say '|'
            nLin ++
            @ nLin,01 say '|   Condiç”es'
            @ nLin,15 say CondARQ->Nome
            @ nLin,78 say '|'
            nLin ++
            @ nLin,01 say '+---------+--------------------------------------------+----------+----------+'
            nLin ++
            @ nLin,01 say '|   Qtde. | Descrição                                  | P. Venda |    Total |'
            nLin ++
            @ nLin,01 say '+---------+--------------------------------------------+----------+----------+'
            nLin ++
            @ nLin,01 say '|         |Transporde de                               |          |'
            @ nLin,68 say nTotalNota          pict '@E 999,999.99'
            @ nLin,78 say '|'
            nLin  ++
            nSequ := 0
          endif

          dbskip ()
        enddo

        nTotalNota -= nDesconto

        if EmprARQ->Juro == "X" 
          nJuros     := ( nTotalNota * CondARQ->Acrs / 100 )
          nTotalNota += nJuros

          if nJuros > 0
            @ nLin,01 say '|         |Juros                                       |          |'
            @ nLin,68 say nJuros    pict '@E 999,999.99'
            @ nLin,78 say '|'
            nLin  ++
            nSequ ++
          endif
        endif

        if nDesconto > 0
          @ nLin,01 say '|         |Desconto                                    |          |'
          @ nLin,68 say nDesconto    pict '@E 999,999.99'
          @ nLin,78 say '|'
          nLin  ++
          nSequ ++
        endif

        nTotal := iif( EmprARQ->EmprPedi == "X", 46, 49 )

        if nSequ < nTotal
          for nIni := 1 to ( nTotal - nSequ )
            @ nLin, 01 say '|         |                                            |          |          |'
            nLin ++
          next
        endif

        @ nLin,01 say '|         | Assinatura:                                |          |          |'
        nLin ++
        @ nLin,01 say '+---------+--------------------------------------------+----------+----------+'

        nLin ++
        @ nLin,01 say '| ' + alltrim( EmprARQ->Mensagem )

        @ nLin,63 say 'Total'
        @ nLin,68 say nTotalNota     pict '@E 999,999.99'
        @ nLin,78 say '|'

        nLin ++
        @ nLin,01 say '+----------------------------------------------------------------------------+'

        if lVista
          nLin += 6
        else
          nLin += 4
        endif
        
        if lTexto .or. EmprARQ->Impr == "X"
          @ nLin,00 say chr(27) + "@"
        endif  
      next
    case EmprARQ->TipoPedi == 3
      for nK := 1 to EmprARQ->CopiaNota
        nLin := 0
        
        if lTexto .or. EmprARQ->Impr == "X"
          setprc( 0, 0 )

          @ 00,00 say chr(27) + "@"
          @ 00,00 say chr(15)
          @ 00,00 say chr(27) + chr(67) + chr(33)
        endif  

        @ nLin,01 say '+----------------------------------------------------------+          +----------------------------------------------------------+'
        nLin ++
        if EmprARQ->EmprPedi == "X"
          @ nLin,001 say '|'
          @ nLin,003 say EmprARQ->Razao       pict '@S40'
          @ nLin,047 say left( EmprARQ->Fone, 12 )
          @ nLin,060 say '|'
          @ nLin,071 say '|'
          @ nLin,073 say EmprARQ->Razao       pict '@S40'
          @ nLin,117 say left( EmprARQ->Fone, 12 )
          @ nLin,130 say '|'
          nLin ++
          @ nLin,001 say '|'
          @ nLin,003 say EmprARQ->Ende        pict '@S40'
          @ nLin,047 say EmprARQ->Bairro      pict '@S15'
          @ nLin,060 say '|'
          @ nLin,071 say '|'
          @ nLin,073 say EmprARQ->Ende        pict '@S40'
          @ nLin,117 say EmprARQ->Bairro      pict '@S15'
          @ nLin,130 say '|'
          nLin ++
          @ nLin,001 say '|'
          @ nLin,003 say alltrim( EmprARQ->Cida ) + '/' + EmprARQ->UF
          @ nLin,060 say '|'
          @ nLin,071 say '|'
          @ nLin,073 say alltrim( EmprARQ->Cida ) + '/' + EmprARQ->UF
          @ nLin,130 say '|'
          nLin ++
          @ nLin,001 say '+----------------------------------------------------------+          +----------------------------------------------------------+'
          nLin ++
        endif
        @ nLin,001 say '|    Pedido'
        @ nLin,013 say cNotaNew
        @ nLin,043 say 'Data ' + dtoc( dEmis )
        @ nLin,060 say '|'
        @ nLin,071 say '|    Pedido'
        @ nLin,083 say cNotaNew
        @ nLin,113 say 'Data ' + dtoc( dEmis )
        @ nLin,130 say '|'
        nLin ++
        @ nLin,001 say '|      Nome'
        if cClie == '999999'
          @ nLin,013 say left( cCliente, 25 ) + ' ' + cClie
        else
          @ nLin,013 say left( ClieARQ->Nome, 25 ) + ' ' + cClie
        endif
        @ nLin,048 say ClieARQ->Fone     pict '@S12'
        @ nLin,060 say '|'
        @ nLin,071 say '|      Nome'
        if cClie == '999999'
          @ nLin,083 say left( cCliente, 25 ) + ' ' + cClie
        else
          @ nLin,083 say left( ClieARQ->Nome, 25 ) + ' ' + cClie
        endif
        @ nLin,113 say ClieARQ->Fone     pict '@S12'
        @ nLin,130 say '|'
        nLin ++
        @ nLin,001 say '|  Endereço'
        @ nLin,013 say alltrim( ClieARQ->Ende ) + ' ' + alltrim( ClieARQ->Bair ) + ' ' + alltrim( ClieARQ->Cida )   pict '@S45'
        @ nLin,060 say '|'
        @ nLin,071 say '|  Endereço'
        @ nLin,083 say alltrim( ClieARQ->Ende ) + ' ' + alltrim( ClieARQ->Bair ) + ' ' + alltrim( ClieARQ->Cida )   pict '@S45'  
        @ nLin,130 say '|'
        nLin ++
        @ nLin,001 say '| Condiç”es '
        @ nLin,013 say CondARQ->Nome
        @ nLin,060 say '|'
        @ nLin,071 say '| Condiç”es '
        @ nLin,083 say CondARQ->Nome
        @ nLin,130 say '|'
        nLin ++

        if CondARQ->Vct1 == 0 .and. CondARQ->Vct2 == 0 .and. CondARQ->Vct3 == 0 .and. CondARQ->Vct4 == 0 .and. CondARQ->Vct5 == 0
          lVista := .t.
        else
          lVista := .f.
          
          @ nLin,01 say '|    Vctos.'
          if nValor01 > 0
            @ nLin,013 say dVcto01         pict '99/99/9999'
            @ nLin,024 say nValor01        pict '@E 99,999.99'
          endif

          if nValor02 > 0
            @ nLin,038 say dVcto02       pict '99/99/9999'
            @ nLin,049 say nValor02      pict '@E 999,999.99'
          endif
          
          @ nLin,060 say '|'
          
          @ nLin,071 say '|    Vctos.'
          if nValor01 > 0
            @ nLin,083 say dVcto01         pict '99/99/9999'
            @ nLin,094 say nValor01        pict '@E 99,999.99'
          endif

          if nValor02 > 0
            @ nLin,108 say dVcto02       pict '99/99/9999'
            @ nLin,119 say nValor02      pict '@E 999,999.99'
          endif
          
          @ nLin,130 say '|'
          nLin ++
          @ nLin,001 say '|'
          if nValor03 > 0
            @ nLin,013 say dVcto03       pict '99/99/9999'
            @ nLin,024 say nValor03      pict '@E 999,999.99'
          endif
          if nValor04 > 0
            @ nLin,038 say dVcto04       pict '99/99/9999'
            @ nLin,049 say nValor04      pict '@E 999,999.99'
          endif
          @ nLin,060 say '|'
          @ nLin,071 say '|'
          if nValor03 > 0
            @ nLin,083 say dVcto03       pict '99/99/9999'
            @ nLin,094 say nValor03      pict '@E 999,999.99'
          endif
          if nValor04 > 0
            @ nLin,108 say dVcto04       pict '99/99/9999'
            @ nLin,119 say nValor04      pict '@E 999,999.99'
          endif
          @ nLin,130 say '|'
          nLin ++
          @ nLin,001 say '|'
          if nValor05 > 0
            @ nLin,013 say dVcto05       pict '99/99/9999'
            @ nLin,024 say nValor05      pict '@E 999,999.99'
          endif
          if nValor06 > 0
            @ nLin,038 say dVcto06       pict '99/99/9999'
            @ nLin,049 say nValor06      pict '@E 999,999.99'
          endif
          @ nLin,060 say '|'
          @ nLin,071 say '|'
          if nValor05 > 0
            @ nLin,083 say dVcto05       pict '99/99/9999'
            @ nLin,094 say nValor05      pict '@E 999,999.99'
          endif
          if nValor06 > 0
            @ nLin,108 say dVcto06       pict '99/99/9999'
            @ nLin,119 say nValor06      pict '@E 999,999.99'
          endif
          @ nLin,130 say '|'
        endif

        @ nLin,001 say '+---------+----------------------------+---------+---------+          +---------+----------------------------+---------+---------+'
        nLin ++
        @ nLin,001 say '|    Qtde.|Produto/Serviço             | P. Unit.| V. Total|          |    Qtde.|Produto/Serviço             | P. Unit.| V. Total|'
        nLin ++
        @ nLin,001 say '+---------+----------------------------+---------+---------+          +---------+----------------------------+---------+---------+'
        nLin ++

        nValorTotal := nTotalNota := 0
        nSequ       := 0

        select( cVendTMP )
        set order to 1
        dbgotop ()
        do while !eof ()
          if EmprARQ->Juro == "X"
            nPrecoVenda := PrecoVenda
            nValorTotal := Qtde * nPrecoVenda
            nTotalNota  += nValorTotal
          else
            nPrecoVenda := ( ( PrecoVenda * CondARQ->Acrs ) / 100 ) + PrecoVenda
            nValorTotal := Qtde * nPrecoVenda
            nTotalNota  += nValorTotal
          endif

          @ nLin,001 say '|'
          if EmprARQ->Inteira == "X"
            @ nLin,002 say Qtde           pict '@E 999999999'
          else
            @ nLin,002 say Qtde           pict '@E 99999.999'
          endif
          @ nLin,011 say '|'
          if Prod == '999999'
            @ nLin,012 say left( Produto, 21 ) + ' ' + Prod
          else
            @ nLin,012 say left( ProdARQ->Nome, 21 ) + ' ' + Prod
          endif
          @ nLin,040 say '|'
          @ nLin,041 say nPrecoVenda    pict PictPreco(9)
          @ nLin,050 say '|'
          @ nLin,051 say nValorTotal    pict '@E 99,999.99'
          @ nLin,060 say '|'

          @ nLin,071 say '|'
          if EmprARQ->Inteira == "X"
            @ nLin,072 say Qtde           pict '@E 999999999'
          else
            @ nLin,072 say Qtde           pict '@E 99999.999'
          endif
          @ nLin,081 say '|'
          if Prod == '999999'
            @ nLin,082 say left( Produto, 21 ) + ' ' + Prod
          else
            @ nLin,082 say left( ProdARQ->Nome, 21 ) + ' ' + Prod
          endif
          @ nLin,110 say '|'
          @ nLin,111 say nPrecoVenda    pict PictPreco(9)
          @ nLin,120 say '|'
          @ nLin,121 say nValorTotal    pict '@E 99,999.99'
          @ nLin,130 say '|'

          nSequ ++
          nLin  ++

          nItens := iif( EmprARQ->EmprPedi == "X", 14, 17 )

          if nSequ > nItens
            @ nLin,001 say '+---------+----------------------------+---------+---------+          +---------+----------------------------+---------+---------+'
            nLin ++
            @ nLin,001 say '|                                   A TRANSPORTAR'
            @ nLin,051 say nTotalNota     pict '@E 999,999.99'
            @ nLin,060 say '|'
            @ nLin,071 say '|                                   A TRANSPORTAR'
            @ nLin,121 say nTotalNota     pict '@E 999,999.99'
            @ nLin,130 say '|'
            nLin ++
            @ nLin,01 say '+----------------------------------------------------------+          +----------------------------------------------------------+'

            nLin +=  5
            
           /////////////// colocar cabecalho
            
            
            nLin  ++
            nSequ := 0
          endif

          dbskip ()
        enddo

        nTotalNota -= nDesconto

        if EmprARQ->Juro == "X"
          nJuros     := ( nTotalNota * CondARQ->Acrs / 100 )
          nTotalNota += nJuros

          if nJuros > 0
            @ nLin,001 say '|         |JUROS                       |         |         |'
            @ nLin,051 say nJuros    pict '@E 99,999.99'
            @ nLin,060 say '|'
            @ nLin,071 say '|         |JUROS                       |         |         |'
            @ nLin,121 say nJuros    pict '@E 99,999.99'
            @ nLin,130 say '|'
            nLin  ++
            nSequ ++
          endif
        endif

        if nDesconto > 0
          @ nLin,001 say '|         |DESCONTO                    |         |         |'
          @ nLin,051 say nDesconto    pict '@E 99,999.99'
          @ nLin,060 say '|'
          @ nLin,071 say '|         |DESCONTO                    |         |         |'
          @ nLin,121 say nDesconto    pict '@E 99,999.99'
          @ nLin,130 say '|'
          nLin  ++
          nSequ ++
        endif

        nTotal := iif( EmprARQ->EmprPedi == "X", 13, 17 )

        if nSequ < nTotal
          for nIni := 1 to ( nTotal - nSequ )
            @ nLin,001 say '|         |                            |         |         |          |         |                            |         |         |'
            nLin ++
          next
        endif

        @ nLin,001 say '|         |Assinatura:                 |         |         |          |         |Assinatura:                 |         |         |'
        nLin ++
        @ nLin,001 say '+---------+----------------------------+---------+---------+          +---------+----------------------------+---------+---------+'

        nLin ++
        @ nLin,001 say '| ' + left( EmprARQ->Mensagem, 41 )

        @ nLin,045 say 'TOTAL'
        @ nLin,051 say nTotalNota     pict '@E 99,999.99'
        @ nLin,060 say '|'

        @ nLin,071 say '| ' + left( EmprARQ->Mensagem, 41 )
        @ nLin,115 say 'TOTAL'
        @ nLin,121 say nTotalNota     pict '@E 99,999.99'
        @ nLin,130 say '|'

        nLin ++
        @ nLin,001 say '+----------------------------------------------------------+          +----------------------------------------------------------+'

        if lVista
          nLin += 6
        else
          nLin += 4
        endif
        
        if lTexto .or. EmprARQ->Impr == "X"
          @ nLin,00 say chr(27) + "@"
        endif  
      next
    case EmprARQ->TipoPedi == 4
      for nK := 1 to EmprARQ->CopiaNota
        nLin := 0
        
        if lTexto .or. EmprARQ->Impr == "X"
          setprc( 0, 0 )

          @ 00,00 say chr(27) + "@"
          @ 00,00 say chr(15)
        endif  

        if EmprARQ->EmprPedi == "X"
          @ nLin,01 say EmprARQ->Razao       pict '@S40'
          nLin ++ 
          @ nLin,01 say alltrim( EmprARQ->Ende ) + ' ' + alltrim( EmprARQ->Bairro ) 
          nLin ++ 
          @ nLin,01 say transform( EmprARQ->CEP, '99999-999' ) + ' ' + alltrim( EmprARQ->Cida ) + '/' + EmprARQ->UF 
          nLin ++
          @ nLin,01 say EmprARQ->Fone
          @ nLin,21 say EmprARQ->Fax
          
          nLin += 2
        endif          
        @ nLin,01 say cNotaNew
        @ nLin,15 say dEmis
        @ nLin,33 say time()
        nLin += 2
        @ nLin,01 say ClieARQ->Nome       pict '@S30'
        @ nLin,37 say cClie
        nLin ++

        if CondARQ->Vct1 == 0 .and. CondARQ->Vct2 == 0 .and. CondARQ->Vct3 == 0 .and. CondARQ->Vct4 == 0 .and. CondARQ->Vct5 == 0
        else
          if nValor01 > 0
            @ nLin,01 say dVcto01         pict '99/99/9999'
            @ nLin,12 say nValor01        pict '@E 99999.99'
          endif
          if nValor02 > 0
            @ nLin,22 say dVcto02         pict '99/99/9999'
            @ nLin,33 say nValor02        pict '@E 99999.99'
          endif
          if nValor03 > 0
            nLin ++
            @ nLin,01 say dVcto03         pict '99/99/9999'
            @ nLin,12 say nValor03        pict '@E 99999.99'
          endif
          if nValor04 > 0
            @ nLin,22 say dVcto04         pict '99/99/9999'
            @ nLin,33 say nValor04        pict '@E 99999.99'
          endif
          nLin ++
        endif

        @ nLin,01 say '----------------------------------------'
        nLin ++
        @ nLin,01 say 'Descrição' 
        nLin ++
        @ nLin,01 say '    Qtde.           V.Unitario  V. Total'
        nLin  ++
        nTotI := 0

        select( cVendTMP )
        set order to 1
        dbgotop ()
        do while !eof ()
          @ nLin,001 say Prod
          if Prod == '999999'
            @ nLin,008 say Produto              pict '@S33'
          else
            @ nLin,008 say ProdARQ->Nome        pict '@S33'
          endif  
          nLin ++
          if EmprARQ->Inteira == "X"
            @ nLin,001 say Qtde               pict '@E 999999999'
          else
            @ nLin,001 say Qtde               pict '@E 99999.999'
          endif
          @ nLin,011 say 'x'
          @ nLin,013 say PrecoVenda           pict PictPreco(10)
          @ nLin,031 say Qtde * PrecoVenda    pict '@E 999,999.99'
          nTotI += Qtde
          nLin  ++
          dbskip ()
        enddo

        @ nLin,01 say '----------------------------------------'
        nLin ++
        @ nLin,001 say nTotI           pict '9999'
        if nTotI == 1
          @ nLin,006 say 'Item' 
        else  
          @ nLin,006 say 'Itens' 
        endif  
        @ nLin,025 say 'Total'
        @ nLin,031 say nTotalNota      pict '@E 999,999.99'
        nLin += 2
        @ nLin,01 say EmprARQ->Mensagem         pict '@S40'
        nLin ++
        @ nLin,01 say '----------------------------------------'
        nLin += 8

        if lTexto .or. EmprARQ->Impr == "X"
          @ nLin,00 say chr(27) + "@"
        endif  
      next
  endcase

  set printer to
  set printer off
  set device  to screen
  
  if !empty( GetDefaultPrinter() ) .and. nPrn > 0
    PrnTest(aPrn[nPrn], memoread( cArqTxt ), .f. )
  endif
   
  select( cVendTMP )
  set order  to 1
return NIL