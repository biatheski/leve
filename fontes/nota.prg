//  Leve, Pedido
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

function Nota ()
  local GetList := {}
  
if NetUse( "ClieARQ", .t. )
  VerifIND( "ClieARQ" )
  
  gOpenClie := .t.

  #ifdef DBF_NTX
    set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
  #endif
else
  gOpenClie := .f.
endif

if NetUse( "ProdARQ", .t. )
  VerifIND( "ProdARQ" )
  
  gOpenProd := .t.
  
  #ifdef DBF_NTX
    set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
  #endif
else
  gOpenProd := .f.  
endif

if NetUse( "NSaiARQ", .t. )
  VerifIND( "NSaiARQ" )
  
  gOpenNSai := .t.
  
  #ifdef DBF_NTX
    set index to NSaiIND1, NSaiIND2, NSaiIND3, NSaiIND4
  #endif
else
  gOpenNSai := .f.  
endif

if NetUse( "INSaARQ", .t. )
  VerifIND( "INSaARQ" )
  
  gOpenINSa := .t.
  
  #ifdef DBF_NTX
    set index to INSaIND1
  #endif
else
  gOpenINSa := .f.  
endif

if NetUse( "IProARQ", .t. )
  VerifIND( "IProARQ" )
  
  gOpenIPro := .t.
  
  #ifdef DBF_NTX
    set index to IProIND1
  #endif
else
  gOpenIPro := .f.  
endif

if NetUse( "CondARQ", .t. )
  VerifIND( "CondARQ" )
  
  gOpenCond := .t.
  
  #ifdef DBF_NTX
    set index to CondIND1, CondIND2
  #endif
else
  gOpenCond := .f.  
endif

if NetUse( "ReceARQ", .t. )
  VerifIND( "ReceARQ" )

  gOpenRece := .t.
  
  #ifdef DBF_NTX
    set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
  #endif
else
  gOpenRece := .f.  
endif

if NetUse( "ReprARQ", .t. )
  VerifIND( "ReprARQ" )
  
  gOpenRepr := .t.
  
  #ifdef DBF_NTX
    set index to ReprIND1, ReprIND2
  #endif
else
  gOpenRepr := .f.  
endif

if NetUse( "PortARQ", .t. )
  VerifIND( "PortARQ" )
  
  gOpenPort := .t.
  
  #ifdef DBF_NTX
    set index to PortIND1, PortIND2
  #endif
else
  gOpenPort := .f.  
endif

if NetUse( "OProARQ", .t. )
  VerifIND( "OProARQ" )
  
  gOpenOPro := .t.
  
  #ifdef DBF_NTX
    set index to OProIND1
  #endif
else
  gOpenOPro := .f.  
endif

if NetUse( "IOPrARQ", .t. )
  VerifIND( "IOPrARQ" )
  
  gOpenIOPr := .t.
  
  #ifdef DBF_NTX
    set index to IOPrIND1
  #endif
else
  gOpenIOPr := .f.  
endif

aOpcoes   := {}
aArqui    := {}
cNConARQ  := CriaTemp(0)
cNConIND1 := CriaTemp(1)
cChave    := "Sequ"

aadd( aArqui, { "Sequ",       "C", 004, 0 } )
aadd( aArqui, { "Prod",       "C", 006, 0 } )
aadd( aArqui, { "Produto",    "M", 010, 0 } )
aadd( aArqui, { "Qtde",       "N", 012, 3 } )
aadd( aArqui, { "Comi",       "N", 009, 3 } )
aadd( aArqui, { "Desc",       "N", 009, 3 } )
aadd( aArqui, { "PrecoVenda", "N", 012, 6 } )
aadd( aArqui, { "PrecoCusto", "N", 012, 6 } )
aadd( aArqui, { "Unidade",    "C", 003, 0 } )
aadd( aArqui, { "NSerie",     "C", 030, 0 } )
aadd( aArqui, { "Valida",     "C", 030, 0 } )
aadd( aArqui, { "Regi",       "N", 008, 0 } )
aadd( aArqui, { "Novo",       "L", 001, 0 } )
aadd( aArqui, { "Lixo",       "L", 001, 0 } )

dbcreate( cNConARQ, aArqui )
   
if NetUse( cNConARQ, .f. )
  cNConTMP := alias ()
  
  #ifdef DBF_CDX  
    index on &cChave tag &cNConIND1
  #endif

  #ifdef DBF_NTX
    index on &cChave to &cNConIND1

    set index to &cNConIND1
 #endif
endif

if empty( EmprARQ->Desconto )
  lDescVenda := .f.
else  
  lDescVenda := .t.
endif  

//  Variaveis para Entrada de dados
nNota        := nQtde       := 0
cNota        := cNotaNew    := cOPro  := space(06)
dEmis        := date()
nCond        := nClie       := nObse  := 0
nSubTotal    := nOPro       := 0
nDesconto    := nTotalNota  := nRepr  := 0
nPrecoTotal  := nComissao   := nPort  := 0
nJuro        := nPrecoCusto := 0
nPrecoVenda  := nComi       := 0
nTotalComi   := nDesc       := 0
cSequ        := cHora       := cUnidade := space(04)
cProd        := cClie       := cCond    := cRepr   := cPort   := space(04)
cObse        := space(60)
dVcto1       := dVcto2     := dVcto3  := dVcto4  := dVcto5  := ctod ('  /  /  ')
dVcto6       := dVcto7     := dVcto8  := dVcto9  := ctod ('  /  /  ')
nValor1      := nValor2    := nValor3 := nValor4 := nValor5 := 0
nValor6      := nValor7    := nValor8 := nValor9 := 0
nComis1      := nComis2    := nComis3 := nComis4 := nComis5 := 0
nComis6      := nComis7    := nComis8 := nComis9 := 0
nAnter1      := nAnter2    := nAnter3 := nAnter4 := nAnter5 := 0
nAnter6      := nAnter7    := nAnter8 := nAnter9 := 0
nTotalICMS   := nProd      := 0
cCliente     := cNSerie    := cValida := space(40)
cFaturas     := "X"
cObse        := ''

Janela ( 01, 02, 21, 76, mensagem( 'Janela', 'Nota', .f. ), .t. )
setcolor ( CorJanel + ',' + CorCampo )

@ 03,03 say '   Pedido             Orçamento                Emissão' 

@ 05,03 say 'Código Descrição                   Qtde. Comi. Desc. P. Venda    V. Total'
              
@ 06,02 say chr(195) + replicate( chr(196), 73 ) + chr(180)
@ 06,09 say chr(194)
@ 06,33 say chr(194)
@ 06,43 say chr(194)
@ 06,49 say chr(194)
@ 06,55 say chr(194)
@ 06,66 say chr(194)

for nY := 07 to 14
  @ nY,09 say chr(179)
  @ nY,33 say chr(179)
  @ nY,43 say chr(179)
  @ nY,49 say chr(179)
  @ nY,55 say chr(179)
  @ nY,66 say chr(179)
next  
  
@ 15,02 say chr(195) + replicate( chr(196), 73 ) + chr(180)
@ 15,09 say chr(193)
@ 15,33 say chr(193)
@ 15,43 say chr(193)
@ 15,49 say chr(193)
@ 15,55 say chr(193)
@ 15,66 say chr(193)
   
@ 16,03 say '  Cliente' 
@ 17,03 say 'Pagamento'
@ 18,03 say ' Vendedor'

@ 16,49 say 'Sub - Total'
@ 17,49 say '   Desconto'
@ 18,49 say 'Total Geral'

MostGeral( 20, 04, 16, 34, 52, 65, ' Ficha ', 'F', 2 ) 
tSnot := savescreen( 00, 00, 24, 79 )
  
select NSaiARQ
set order to 1
dbGoBottom()

do while .t.
  cStat := nStatAnt := space(04)
  restscreen( 00, 00, 23, 79, tSnot )

  Mensagem( 'Nota', 'Janela' )
  
  select( cNConTMP )
  zap
  
  select ProdARQ
  set order to 1
  
  select CondARQ
  set order to 1

  select ClieARQ
  set order to 1

  select ReprARQ
  set order to 1

  select PortARQ
  set order to 1

  select INSaARQ
  set order    to 1
  set relation to Prod into ProdARQ

  select NSaiARQ
  set order    to 1
  set relation to Cond into CondARQ, to Clie into ClieARQ,;
               to Repr into ReprARQ, to Port into PortARQ

  MostNSai ()
  
  if Demo ()
    exit
  endif  
 
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostNSai'
  cAjuda   := 'NSai'
  lAjud    := .t.
  
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()

  @ 03,13 get nNota            pict '999999'
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
  @ 03,13 say cNota            pict '999999'

  //  Verificar existencia das Notas para Incluir ou Alterar
  select NSaiARQ
  set order to 1
  dbseek( cNota, .f. )
  if eof()
    cStat    := 'incl'
    lFaturas := 'X'
  else
    cStat    := 'alte'
    lFaturas := 'X'

    if CondARQ->Vct1 == 0 .and. CondARQ->Vct2 == 0
      lFaturas := 'X'
    endif
  endif

  Mensagem( 'Nota', cStat )
  
  select INSaARQ
  set order to 1
  dbseek( cNota, .t. )
  do while Nota == cNota
    nRegi := recno ()
    
    select( cNConTMP )
    if AdiReg()
      if RegLock()
        replace Sequ       with INSaARQ->Sequ
        replace Prod       with INSaARQ->Prod
        replace Produto    with INSaARQ->Produto
        replace Qtde       with INSaARQ->Qtde
        replace PrecoVenda with INSaARQ->PrecoVenda
        replace PrecoCusto with INSaARQ->PrecoCusto
        replace Unidade    with INSaARQ->Unidade
        replace NSerie     with INSaARQ->NSerie
        replace Valida     with INSaARQ->Valida
        replace Comi       with INSaARQ->Comi
        replace Desc       with INSaARQ->Desc
        replace Regi       with nRegi
        replace Novo       with .f.
        replace Lixo       with .f.
        dbunlock ()
      endif
    endif
    
    select INSaARQ
    dbskip ()
  enddo
 
  nStatAnt := cStat

  select NSaiARQ

  MostNSai ()
  EntrNSai ()  
  EntrNota ()
  EntrVcto ()

  select NSaiARQ

  ConfGeral( 20, 04, 16, 34, 52, 65, ' Ficha ', 'F', 2, 1 )
    
  if cStat == 'excl'
    EstoNsai ()
  endif
  
  if cStat == 'loop' .or. lastkey() == K_ESC
    loop
  endif  
  
  if nStatAnt == 'incl'
    if nNota == 0
      select EmprARQ
      set order to 1
      dbseek( cEmpresa, .f. )

      nNotaNew := Nota + 1
       
      do while .t.       
        cNotaNew := strzero( nNotaNew, 6 )
        
        NSaiARQ->( dbseek( cNotaNew, .f. ) )
        
        if NSaiARQ->(found()) 
          nNotaNew ++
          loop
        else
          select EmprARQ
          if RegLock()
            replace Nota       with nNotaNew
            dbunlock ()
          endif
          exit
        endif    
      enddo
    endif  
    
    select NSaiARQ
    
    if AdiReg()
      if RegLock()
        replace Nota     with cNotaNew
        dbunlock ()
      endif
    endif
  endif

  if nStatAnt == 'incl' .or. nStatAnt == 'alte'
    if RegLock()
      replace Emis       with dEmis
      replace OPro       with cOPro
      replace Hora       with cHora
      replace Clie       with cClie
      replace Cliente    with cCliente
      replace Cond       with cCond
      replace Repr       with cRepr
      replace Port       with cPort
      replace SubTotal   with nSubTotal
      replace Desconto   with nDesconto
      replace Comissao   with nComissao
      replace Vcto1      with dVcto1
      replace Valor1     with nValor1
      replace Comis1     with nComis1
      replace Vcto2      with dVcto2
      replace Valor2     with nValor2
      replace Comis2     with nComis2
      replace Vcto3      with dVcto3
      replace Valor3     with nValor3
      replace Comis3     with nComis3
      replace Vcto4      with dVcto4
      replace Valor4     with nValor4
      replace Comis4     with nComis4
      replace Vcto5      with dVcto5
      replace Valor5     with nValor5
      replace Comis5     with nComis5
      replace Vcto6      with dVcto6
      replace Valor6     with nValor6
      replace Comis6     with nComis6
      replace Vcto7      with dVcto7
      replace Valor7     with nValor7
      replace Comis7     with nComis7
      replace Vcto8      with dVcto8
      replace Valor8     with nValor8
      replace Comis8     with nComis8
      replace Vcto9      with dVcto9
      replace Valor9     with nValor9
      replace Comis9     with nComis9
      replace Obse       with cObse
      dbunlock ()
    endif  
      
    GravNota ()
  endif
  
  if cStat == 'gene'
    ImprNota (.t.)
  endif
  
  if cStat == 'prin'
    ImprNota (.f.)  
  endif
    
  if nNota == 0
    Alerta( mensagem( 'Alerta', 'Nota', .f. ) + ' ' + cNotaNew )
  endif  
enddo

if gOpenOPro
  select OProARQ
  close
endif

if gOpenIOPr
  select IOPrARQ
  close
endif

if gOpenClie
  select ClieARQ
  close
endif

if gOpenProd
  select ProdARQ
  close
endif

if gOpenNSai
  select NSaiARQ
  close
endif

if gOpenINSa
  select INSaARQ
  close
endif

if gOpenIPro
  select IProARQ
  close
endif

if gOpenCond
  select CondARQ
  close
endif  

if gOpenRece
  select ReceARQ
  close
endif

if gOpenRepr
  select ReprARQ
  close
endif  

if gOpenPort
  select PortARQ
  close
endif  

select( cNConTMP )
ferase( cNConARQ )
ferase( cNConIND1 )
#ifdef DBF_CDX
  ferase( left( cNConARQ, len( cNConARQ ) - 3 ) + 'FPT' )
#endif  
#ifdef DBF_NTX
  ferase( left( cNConARQ, len( cNConARQ ) - 3 ) + 'DBT' )
#endif  

return NIL

//
// Mostra os dados
//
function MostNSai()
  
  setcolor( CorCampo )
  if cStat != 'incl'  
    cNota := Nota    
    nNota := val( Nota )
  
    @ 03,13 say nNota            pict '999999'
  endif  
  
  cNotaNew   := cNota
  cOPro      := OPro
  nOPro      := val( OPro )
  dEmis      := Emis  
  cHora      := Hora
  cClie      := Clie
  nClie      := val( Clie )
  cCliente   := Cliente 
  cCond      := Cond
  nCond      := val( Cond )
  cRepr      := Repr
  nRepr      := val( Repr )
  cPort      := Port
  nPort      := val( Port )
  nSubTotal  := SubTotal
  nDesconto  := Desconto
  nJuros     := ( CondARQ->Acrs * ( nSubTotal - nDesconto ) ) / 100
  nTotalNota := ( nSubTotal - nDesconto ) + nJuros  
  nComissao  := Comissao
  cObse      := Obse
  nLin       := 7
  
  dVcto1     := Vcto1
  nValor1    := Valor1
  nComis1    := Comis1
  dVcto2     := Vcto2
  nValor2    := Valor2
  nComis2    := Comis2
  dVcto3     := Vcto3
  nValor3    := Valor3
  nComis3    := Comis3
  dVcto4     := Vcto4
  nValor4    := Valor4
  nComis4    := Comis4
  dVcto5     := Vcto5
  nValor5    := Valor5
  nComis5    := Comis5
  dVcto6     := Vcto6
  nValor6    := Valor6
  nComis6    := Comis6
  dVcto7     := Vcto7
  nValor7    := Valor7
  nComis7    := Comis7
  dVcto8     := Vcto8
  nValor8    := Valor8
  nComis8    := Comis8
  dVcto9     := Vcto9
  nValor9    := Valor9
  nComis9    := Comis9
  
  @ 03,35 say nOpro              pict '999999'
  @ 03,58 say dEmis              pict '99/99/9999'
  @ 03,69 say cHora              pict '99:99'
  @ 18,13 say nRepr              pict '999999'
  @ 18,20 say ReprARQ->Nome      pict '@S28'  
  @ 16,13 say nClie              pict '999999'
  if cClie == '999999'
    @ 16,20 say cCliente         pict '@S28' 
  else  
    @ 16,20 say ClieARQ->Nome    pict '@S28' 
  endif  
  @ 17,13 say nCond              pict '999999'
  @ 17,20 say CondARQ->Nome      pict '@S28'
  
  if cStat == 'alte' .or. cStat == space(04)
    setcolor( CorJanel )
    for nG := 1 to 8  
      @ nLin, 03 say '      '    
      @ nLin, 10 say space(23)
      @ nLin, 34 say '         '
      @ nLin, 44 say '     '
      @ nLin, 50 say '     '
      @ nLin, 56 say '          '
      @ nLin, 67 say '         '
      nLin ++
    next

    nLin := 7 
    select INSaARQ
    set order to 1
    dbseek( cNota, .t. )
    do while Nota == cNota
      @ nLin, 03 say Prod                  pict '999999'    
      if Prod == '999999'
        @ nLin, 10 say memoline( Produto, 23, 1 )
      else  
        @ nLin, 10 say ProdARQ->Nome       pict '@S23'
      endif  
      if EmprARQ->Inteira == "X"
        @ nLin, 34 say Qtde                pict '@E 999999999'
      else      
        @ nLin, 34 say Qtde                pict '@E 99999.999'
      endif     
      @ nLin, 44 say Comi                  pict '@E 99.99'
      @ nLin, 50 say Desc                  pict '@E 99.99'
      @ nLin, 56 say PrecoVenda            pict PictPreco(10)
      @ nLin, 67 say Qtde * PrecoVenda     pict '@E 99,999.99'

      nLin ++
      dbskip ()
      if nLin >= 15
        exit
      endif   
    enddo
    setcolor( CorCampo )
  else
    setcolor( CorJanel )
    for nG := 1 to 8  
      @ nLin, 03 say '      '    
      @ nLin, 10 say space(23)
      @ nLin, 34 say '         '
      @ nLin, 44 say '     '
      @ nLin, 50 say '     '
      @ nLin, 56 say '          '
      @ nLin, 67 say '         '
      nLin ++
    next
    setcolor( CorCampo )
  endif  

  select NSaiARQ

  @ 16,61 say nSubTotal              pict '@E 999,999,999.99'
  @ 17,61 say nDesconto              pict '@E 999,999,999.99'
  @ 18,61 say nTotalNota             pict '@E 999,999,999.99'
  
  PosiDBF( 01, 76 )
return NIL

//
// Importar itens do Orçamento.
//
function BuscaOPro ()
  if nOpro > 0 .and. cStat == 'incl'
    select OProARQ
    set order    to 1
    set relation to Clie into ClieARQ, to Cond into CondARQ
    dbseek( strzero( nOPro, 6 ), .f. )

    if !found()
      dbgotop()
      
      tVerOpro := savescreen( 00, 00, 24, 79 )

      Janela( 03, 01, 16, 76, mensagem( 'Janela', 'BuscaOPro', .f. ), .f. )  
      setcolor( CorJanel + "," + CorCampo )
      oOrca           := TBrowseDB( 05, 02, 16, 75 )
      oOrca:headsep   := chr(194)+chr(196)
      oOrca:colsep    := chr(179)
      oOrca:footsep   := chr(193)+chr(196)
      oOrca:colorSpec := CorJanel + ',' + CorCampo
 
      oOrca:addColumn( TBColumnNew( "Nota",      {|| Nota } ) )
      oOrca:addColumn( TBColumnNew( "Emissao",   {|| Emis } ) )
      oOrca:addColumn( TBColumnNew( "Cliente",   {|| left( ClieARQ->Nome, 12 ) } ) )
      oOrca:addColumn( TBColumnNew( "Condicoes", {|| left( CondARQ->Nome, 10 ) } ) )
      oOrca:addColumn( TBColumnNew( "Prazo",     {|| left( Praz, 10 ) } ) )
      oOrca:addColumn( TBColumnNew( "Observacao",{|| left( Obse, 11 ) } ) )
      oOrca:addColumn( TBColumnNew( "Total",     {|| transform( TotalNota - Desconto, "@E 99,999.99" ) } ) )

      oOrca:refreshall()

      lExitRequested := .f.
      nLinBarra      := 1
      cLetra         := ""
      nTotal         := lastrec()
      BarraSeta      := BarraSeta( nLinBarra, 05, 16, 76, nTotal )
  
      @ 06,01 say chr(195)

      do while !lExitRequested
        Mensagem( 'MoCa', 'ConsMoCa' ) 

        oOrca:forcestable()
    
        PosiDBF( 03, 76 )
    
        cTecla := Teclar(0)

        iif( BarraSeta, BarraSeta( nLinBarra, 05, 16, 76, nTotal ), NIL )
       
        do case
          case cTecla == K_DOWN .or. cTecla == K_PGDN .or. cTecla == K_CTRL_PGDN
            if !oOrca:hitBottom
              nLinBarra ++
              if nLinBarra >= nTotal
                nLinBarra := nTotal 
              endif
            endif
          case cTecla == K_UP .or. cTecla == K_PGUP .or. cTecla == K_CTRL_PGUP
            if !oOrca:hitTop
              nLinBarra --
              if nLinBarra < 1
                nLinBarra := 1
              endif
            endif
        endcase
      
        do case
          case cTecla == K_LEFT;       oOrca:left()
          case cTecla == K_RIGHT;      oOrca:right()
          case cTecla == K_DOWN;       oOrca:down()
          case cTecla == K_UP;         oOrca:up()
          case cTecla == K_PGDN;       oOrca:pageDown()
          case cTecla == K_PGUP;       oOrca:pageUp()
          case cTecla == K_CTRL_PGUP;  oOrca:goTop()
          case cTecla == K_CTRL_PGDN;  oOrca:goBottom()
          case cTecla == K_ENTER      
            nOpro          := val( Nota )
            lExitRequested := .t.
          case cTecla == K_ESC;        lExitRequested := .t.
        endcase
      enddo
  
      restscreen( 00, 00, 24, 79, tVerOPro )
      
      if cTecla == K_ESC
        select NSaiARQ
        
        return(.t.)
      endif  
    endif 

    setcolor( CorJanel + ',' + CorCampo )
      
    nLin := 07 

    select IOPrARQ
    set order    to 1
    set relation to Prod into ProdARQ
    dbseek(strzero(nOPro,6), .f. )
    do while Nota == strzero( nOPro, 6 ) .and. !eof()
      if nLin <= 15
        @ nLin, 03 say Prod                  pict '999999'    
        if Prod == '999999'
          @ nLin, 10 say memoline( Produto, 23, 1 )
        else  
          @ nLin, 10 say ProdARQ->Nome       pict '@S23'
        endif  
        if EmprARQ->Inteira == "X"
          @ nLin, 34 say Qtde                pict '@E 999999999'
        else      
          @ nLin, 34 say Qtde                pict '@E 99999.999'
        endif     
        @ nLin, 44 say 0                     pict '@E 99.99'
        @ nLin, 50 say Desc                  pict '@E 99.99'
        @ nLin, 56 say PrecoVenda            pict PictPreco(10)
        @ nLin, 67 say Qtde * PrecoVenda     pict '@E 99,999.99'
        nLin ++  
      endif

      select( cNConTMP )
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
          replace Novo       with .t.
          dbunlock ()
        endif
      endif
        
      nSubTotal += ( IOPrARQ->PrecoVenda * IOPrARQ->Qtde )
        
      select IOPrARQ
        
      dbskip()   
    enddo
 
  
    setcolor( CorCampo )
    @ 16,61 say nSubTotal              pict '@E 999,999,999.99'
    setcolor( CorJanel + ',' + CorCampo )

    select NSaiARQ
  endif
return(.t.)


//
// Entra os dados
//
function EntrNSai ()
  local GetList := {}

  if empty( dEmis )
    dEmis := date()
  endif  
  if empty( cHora )
    cHora := time()
  endif  
 
  setcolor ( CorJanel + ',' + CorCampo )
  @ 03,35 get nOPro           pict '999999'  valid BuscaOpro()
  @ 03,58 get dEmis           pict '99/99/9999'
  @ 03,69 get cHora           pict '99:99'
  read
  
  cOPro := strzero( nOPro, 6 )
return NIL    

//
// Entra com os itens 
//
function EntrNota()

  if lastkey () == K_ESC .or. lastkey () == K_PGDN
    return NIL
  endif
    
  setcolor ( CorJanel + ',' + CorCampo )
  
  select( cNConTMP )
  set order    to 1
  set relation to Prod into ProdARQ

  oPedido           := TBrowseDB( 05, 03, 15, 75 )
  oPedido:headsep   := chr(194)+chr(196)
  oPedido:colsep    := chr(179)
  oPedido:footsep   := chr(193)+chr(196)

  oPedido:addColumn( TBColumnNew("Código",       {|| Prod } ) )
  oPedido:addColumn( TBColumnNew("Descrição",    {|| iif( Prod == '999999', memoline( Produto, 23, 1 ), left( ProdARQ->Nome, 23 ) ) } ) )
  if EmprARQ->Inteira == "X"
    oPedido:addColumn( TBColumnNew("    Qtde.",  {|| transform( Qtde, '@E 999999999' ) } ) )
  else  
    oPedido:addColumn( TBColumnNew("    Qtde.",  {|| transform( Qtde, '@E 99999.999' ) } ) )
  endif  
  oPedido:addColumn( TBColumnNew("Comi.",        {|| transform( Comi, '@E 99.99' ) } ) )
  oPedido:addColumn( TBColumnNew("Desc.",        {|| transform( Desc, '@E 99.99' ) } ) )
  oPedido:addColumn( TBColumnNew("P. Venda",     {|| transform( PrecoVenda, PictPreco(10) ) } ) )
  oPedido:addColumn( TBColumnNew(" V. Total",    {|| transform( ( PrecoVenda * Qtde ), '@E 99,999.99' ) } ) )

  oPedido:goBottom()

  lExitRequested := .f.
  lAlterou       := .f.

  do while !lExitRequested
    Mensagem ( 'LEVE', 'Browse' )
    
    oPedido:forcestable()

    if oPedido:hitTop .and. !empty( Prod )
      oPedido:refreshAll ()
      
      EntrNSai ()
      
      select( cNConTMP )

      oPedido:down()
      oPedido:forcestable()
      oPedido:refreshAll ()
      
      loop       
    endif
    
    if ( !lAlterou .and. cStat == 'incl' ) .or. ( oPedido:hitBottom .and. lastkey() != K_ESC )
      cTecla := K_INS
    else
      cTecla := Teclar (0)
    endif  

    do case
      case cTecla == K_UP;          oPedido:up()
      case cTecla == K_DOWN;        oPedido:down()
      case cTecla == K_PGUP;        oPedido:pageUp()
      case cTecla == K_PGDN;        oPedido:pageDown()
      case cTecla == K_CTRL_PGUP;   oPedido:goTop()
      case cTecla == K_CTRL_PGDN;   oPedido:goBottom()
      case cTecla == K_ALT_O        
        tEntrObse := savescreen( 00, 00, 23, 79 )

        Janela( 03, 17, 09, 60, mensagem( 'LEVE', 'Obse', .f. ), .f. )
        Mensagem( 'PedF', 'Obse' )
         
        setcolor( CorCampo )     
        cObse := memoedit( cObse, 05, 19, 08, 58, .t., "OutProd" )
    
        restscreen( 00, 00, 23, 79, tEntrObse )
      case cTecla == K_ESC
        if Saindo (lAlterou)
          lExitRequested := .t.
        else  
          lExitRequested := .f.
        endif  
      case cTecla == 46
        oPedido:forcestable()
        lExitRequested := .t.
      case cTecla == K_ENTER;       EntrItens(.f.)
      case cTecla == K_INS
        do while lastkey() != K_ESC    
          EntrItens( .t. )
        enddo  
        
        cTecla := ""
        
        oPedido:refreshAll ()  
      case cTecla == K_DEL
        if RegLock()
          nSubTotal -= ( Qtde * PrecoVenda )
          if !lDescVenda
            nDesconto  -= ( ( ( Qtde * PrecoVenda ) * Desc ) / 100 )
          endif  

          setcolor( CorCampo )
          @ 16,61 say nSubTotal    pict '@E 999,999,999.99'
          @ 17,61 say nDesconto    pict '@E 999,999,999.99'

          replace Lixo           with .t.

          dbdelete ()
          dbunlock ()
          
          oPedido:refreshCurrent()  
          oPedido:goBottom() 
        endif  
    endcase
  enddo
return NIL  

//
// Entra intens da nota
//
function EntrItens( lAdiciona )
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
    
    oPedido:goBottom() 
    oPedido:down()
    oPedido:refreshAll()  

    oPedido:forcestable()  

    Mensagem( 'PedF', 'InclIten' )
  else
    Mensagem( 'PedF', 'AlteIten' )
  endif  

  cProd       := Prod
  cProduto    := Produto
  nProd       := val( cProd )
  nComi       := Comi
  nDesc       := Desc
  nQtde       := Qtde
  nPrecoVenda := PrecoVenda
  nPrecoCusto := PrecoCusto
  cNSerie     := NSerie
  cValida     := Valida
  cUnidade    := Unidade
  nLin        := 6 + oPedido:rowPos
  lIPro       := .f.

  nPrecoAnt   := PrecoVenda
  nQtdeAnt    := Qtde
  nDescAnt    := Desc
  lAlterou    := .t.
    
  setcolor( CorCampo )
  if cProd == '999999'
    @ nLin, 10 say memoline( Produto, 23, 1 )
  else  
    @ nLin, 10 say ProdARQ->Nome       pict '@S23'
  endif  
  @ nLin, 67 say nQtde * nPrecoVenda   pict '@E 99,999.99'
  
  set key K_UP to UpNota ()
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ nLin, 03 get cProd         pict '@K'             valid ValidProd( nLin, 03, cNConTMP, 'nota', 0, 0, nPrecoVenda )
  if EmprARQ->Inteira == "X"
    @ nLin, 34 get nQtde       pict '@E 999999999'   valid ValidQtde( nQtde ) .and. ValidNota ()
  else  
    @ nLin, 34 get nQtde       pict '@E 99999.999'   valid ValidQtde( nQtde ) .and. ValidNota ()
  endif  
  @ nLin, 44 get nComi         pict '@E 99.99'
  @ nLin, 50 get nDesc         pict '@E 99.99'       valid DescDisc(lAdiciona)  
  @ nLin, 56 get nPrecoVenda   pict PictPreco(10)
  read
  
  set key K_UP to
     
  if lastkey() == K_ESC
    if lAdiciona
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif  
    endif  
    
    oPedido:forcestable()
    oPedido:refreshAll()  
    return NIL
  endif  
  
  if lIPro 
    select( cNConTMP )   
    if RegLock()
      replace Sequ       with strzero( nSequ, 4 )
      replace Prod       with "999999"
      replace Produto    with ProdARQ->Nome
      replace PrecoVenda with nPrecoVenda
      replace Desc       with 0
      replace Qtde       with nQtde
      dbunlock ()
    endif  

    nSubTotal += ( nQtde * nPrecoVenda )

    select IProARQ
    do while Prod == cProd .and. !eof()
      select( cNConTMP )   
      
      nSequ      ++
      nSubTotal  += ( ( IProARQ->Qtde * nQtde ) * IProARQ->PrecoVenda )

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
  else  
    if RegLock()
      replace Prod            with cProd
      replace Produto         with cProduto
      replace Qtde            with nQtde
      replace Comi            with nComi
      replace Desc            with nDesc
      replace PrecoVenda      with nPrecoVenda
      replace PrecoCusto      with nPrecoCusto
      replace Unidade         with cUnidade
      replace NSerie          with cNSerie
      replace Valida          with cValida
      dbunlock ()
    endif  

    if !lAdiciona
      nSubTotal -= ( nQtdeAnt * nPrecoAnt )
      if !lDescVenda
        nDesconto -= ( ( ( nQtdeAnt * nPrecoAnt ) * nDescAnt ) / 100 )
      endif  
      nSubTotal += ( nQtde * nPrecoVenda )
      if !lDescVenda
        nDesconto += ( ( ( nQtde * nPrecoVenda ) * nDesc ) / 100 )
      endif  
    else
      nSubTotal += ( nQtde * nPrecoVenda )
      if !lDescVenda
        nDesconto += ( ( ( nQtde * nPrecoVenda ) * nDesc ) / 100 )
      endif  
    endif
  endif
  
  select( cNConTMP )   
  
  oPedido:refreshCurrent()  

  setcolor( CorCampo )
  @ 16,61 say nSubTotal       pict '@E 999,999,999.99'
  @ 17,61 say nDesconto       pict '@E 999,999,999.99'
return NIL     

//
// Verifica Composicao
//
function ValidNota ()
  select IProARQ
  set order to 1 
  dbseek( cProd, .t. )
  if Prod == cProd .and. ProdARQ->Composicao == "X"
    lIPro := .t.
    
    keyboard(chr(13)+chr(13)+chr(13))
  else  
    lIPro := .f.
  endif
  
  if EmprARQ->NSerie == "X"
    tSerie := savescreen( 00, 00, 23, 79 )

    Janela( 08, 19, 12, 61, mensagem( 'Janela', 'NSerie', .f. ), .f. )
    setcolor( CorJanel + ',' + CorCampo )
    @ 10,21 say 'N. Série'
    @ 11,21 say 'Validade'
    
    @ 10,30 get cNSerie      pict '@S30'
    @ 11,30 get cValida      pict '@S30'
    read
    
    restscreen( 00, 00, 23, 79, tSerie )
  endif
  
  select( cNConTMP )   
return(.t.)

function UpNota ()
  keyboard(chr(27))
return(.t.)

//
// Excluir nota
//
function EstoNSai ()
  cStat := 'loop' 
  lEstq := .f.

  select NSaiARQ

  if ExclEstq ()
    select INSaARQ
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
          replace Qtde      with Qtde + nQtde
          replace UltE      with date ()
          dbunlock ()
        endif
  
        select INSaARQ
      endif  

      dbskip ()
    enddo    

    select ReceARQ
    set order to 1
    for nL := 1 to 9
      cParc := strzero( nL, 2 )

      dbseek( cNota + cParc + 'P', .f. )

      if found () 
        if RegLock()
          dbdelete ()
          dbunlock ()
        endif
      endif    
    next 

    select NSaiARQ
  endif
return NIL

//
//  Grava Nota Fiscal
//
function GravNota()

  set deleted off  
  
  select( cNConTMP )
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
      
      select INSaARQ
      set order to 1
      dbseek( cNotaNew + &cNConTMP->Sequ, .f. )
      
      if found()
        if RegLock()
          dbdelete ()
          dbunlock ()
        endif  
      endif     
      
      if AdiReg()
        if RegLock()
          replace Nota       with cNotaNew     
          replace Sequ       with &cNConTMP->Sequ
          replace Prod       with &cNConTMP->Prod
          replace Produto    with &cNConTMP->Produto
          replace Qtde       with &cNConTMP->Qtde
          replace Comi       with &cNConTMP->Comi
          replace Desc       with &cNConTMP->Desc
          replace PrecoVenda with &cNConTMP->PrecoVenda
          replace PrecoCusto with &cNConTMP->PrecoCusto
          replace Unidade    with &cNConTMP->Unidade    
          replace NSerie     with &cNConTMP->NSerie     
          replace Valida     with &cNConTMP->Valida     
          dbunlock ()
        endif
      endif   
  
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
    else 
      select INSaARQ
      go nRegi
      
      cPrAnt := Prod
      nQtAnt := Qtde
          
      if RegLock()
        replace Prod       with &cNConTMP->Prod
        replace Produto    with &cNConTMP->Produto
        replace Qtde       with &cNConTMP->Qtde
        replace Comi       with &cNConTMP->Comi
        replace Desc       with &cNConTMP->Desc
        replace PrecoVenda with &cNConTMP->PrecoVenda
        replace PrecoCusto with &cNConTMP->PrecoCusto
        replace Unidade    with &cNConTMP->Unidade    
        replace NSerie     with &cNConTMP->NSerie     
        replace Valida     with &cNConTMP->Valida     
        dbunlock ()
      endif  

      select ProdARQ
      set order to 1
      dbseek( cPrAnt, .f. )
      if found ()
        if RegLock()
          replace Qtde           with Qtde + nQtAnt
          replace UltS           with dEmis
          dbunlock ()
        endif
      endif    

      if !lLixo
        dbseek( cProd, .f. )
        if found ()
          if RegLock()
            replace Qtde         with Qtde - nQtde
            replace UltS         with dEmis
            dbunlock ()
          endif
        endif    
      endif  

      select INSaARQ

      if lLixo
        if RegLock()
          dbdelete ()
          dbunlock ()
        endif
      endif
    endif 
      
    select( cNConTMP )
    dbskip ()
  enddo  
   
  set deleted on
  
  if CondARQ->Cheque
    ChPr (.t.)
  else
    if cFaturas == "X"
      select ReceARQ
      set order to 1
      for nL := 1 to 9
        cParc   := str( nL, 1 )
        cParce  := strzero( nL, 2 )
        cNotaPg := cNotaNew + cParce
        nPago   := nValor&cParc
 
        dbseek( cNotaPg + 'P', .f. )
        if nValor&cParc == 0
          if ! eof ()    
            if RegLock()
              dbdelete ()
              dbunlock ()
            endif  
          endif
        else
          if eof () 
            if AdiReg()
              if RegLock()
                replace Nota  with cNotaPg
                replace Tipo  with 'P'
                dbunlock ()
              endif
            endif  
          endif
          if RegLock()
            replace Clie     with cCLie
            replace Cliente  with cCliente
            replace Emis     with dEmis
            replace Vcto     with dVcto&cParc
            replace Valor    with nValor&cParc
            replace Acre     with EmprARQ->Taxa 
            if dVcto&cParc == dEmis
              replace Pgto   with dVcto&cParc
              replace Pago   with nValor&cParc
            else
              replace Pgto   with ctod('  /  /  ')  
              replace Pago   with 0
              replace Juro   with 0
            endif  
            replace Repr     with cRepr
            replace Port     with cPort
            replace ReprComi with nComis&cParc
            dbunlock ()
          endif
        endif
        
        if dEmis == dVcto&cParc .and. EmprARQ->Caixa == "X"
          dPgto := date()
          cNota := cNotaNew
          nPago := nValor&cParc
          cHist := iif( cClie == '999999', cCliente, ClieARQ->Nome )
      
          DestLcto ()
        endif
      next  
    else
    endif  
  endif
return NIL

//
// Verifica a Qtde
//
function ValidQtde( qQtde )
  if cProd != '999999'
    if lastkey() == K_UP
      set key K_UP to UpNota ()
    else
      set key K_UP to
    endif  
 
    if qQtde > 99999 
      return(.f.)
    endif
  
    if qQtde > ProdARQ->Qtde
      if EmprARQ->Inteira == "X"
        Alerta ( mensagem( 'Alerta', 'ValidQtde1', .f. ) + ' ' + transform( ProdARQ->Qtde, '@E 999999999' ) )
      else      
        Alerta ( mensagem( 'Alerta', 'ValidQtde2', .f. ) + ' ' + transform( ProdARQ->Qtde, '@E 99999.999' ) )
      endif     
      return(.t.)
    endif 
    if qQtde > ( ProdARQ->Qtde - ProdARQ->EstqMini ) .and. ( ProdARQ->EstqMini > 0 )
      if EmprARQ->Inteira == "X"
        Alerta ( mensagem( 'Alerta', 'ValidQtde3', .f. ) + ' ' + transform( ProdARQ->EstqMini, '@E 999999999' ) + '    Estoque ' + transform( ProdARQ->Qtde, '@E 999999999' ) )
      else      
        Alerta ( mensagem( 'Alerta', 'ValidQtde4', .f. ) + ' ' + transform( ProdARQ->EstqMini, '@E 99999.999' ) + '    Estoque ' + transform( ProdARQ->Qtde, '@E 99999.999' ) )
      endif     
      return(.t.)
    endif
    
    if qQtde > 0 .and. ProdARQ->Caixa > 0
      if ( ( ( qQtde / ProdARQ->Caixa ) ) - int( qQtde / ProdARQ->Caixa ) ) > 0  
        if EmprARQ->Inteira == "X"
          Alerta( mensagem( 'Alerta', 'ValidQtde5', .f. ) + ' ' + transform( ProdARQ->Caixa, '@E 99999999' ) + '      Estoque ' + transform( ProdARQ->Qtde, '@E 999999999' ) )
        else  
          Alerta( mensagem( 'Alerta', 'ValidQtde6', .f. ) + ' ' + transform( ProdARQ->Caixa, '@E 9999.999' ) + '      Estoque ' + transform( ProdARQ->Qtde, '@E 99999.999' ) )
        endif  
        return(.t.)
      endif  
    endif  
  endif  
return(.t.)

//
// Permiti que se volte ao dar o desconto.
//  
function CalcDesc ()  
  nTotalNota := nSubTotal - nDesconto
  nValorPago := nSubTotal - nDesconto
  nTotalComi := 0
  
  if lastkey () == K_UP
    EntrNota ()
 
    if cStat == 'incl'
      Mensagem( 'Nota', 'Incl' ) 
    else
      Mensagem( 'Nota', 'Alte' )
    endif
  
  endif
return(.t.)  

//
// Gera prestacoes do Pedido
//
function PediPres ()
  local GetList := {}

  select( cNConTMP )
  set order to 1
  dbgotop ()
  do while !eof ()
    if Comi == 0
      nTotalComi += ( ( ( PrecoVenda * Qtde ) * ReprARQ->PerC ) / 100 )
    else
      nTotalComi += ( ( ( PrecoVenda * Qtde ) * Comi ) / 100 )
    endif  
    dbskip ()
  enddo  
  
  select NSaiARQ
  
  nTotalNota  := nSubTotal - nDesconto
  nTotalNota  := nTotalNota + ( nTotalNota * CondARQ->Acrs / 100 )
  cCond       := strzero( nCond, 6 )
  cRepr       := strzero( nRepr, 6 )
  cClie       := strzero( nClie, 6 )
  nParcAll    := 1
  
  if nTotalNota != ( SubTotal - Desconto ) .or. cCond != NSaiARQ->Cond
    dVcto1      := dVcto2  := dVcto3  := dVcto4  := dVcto5  := ctod ('  /  /  ')
    dVcto6      := dVcto7  := dVcto8  := dVcto9  := ctod ('  /  /  ')
    nValor1     := nValor2 := nValor3 := nValor4 := nValor5 := 0
    nValor6     := nValor7 := nValor8 := nValor9 := 0
    nComis1     := nComis2 := nComis3 := nComis4 := nComis5 := 0
    nComis6     := nComis7 := nComis8 := nComis9 := 0
    nAnter1     := nAnter2 := nAnter3 := nAnter4 := nAnter5 := 0
    nAnter6     := nAnter7 := nAnter8 := nAnter9 := 0
 
    dVcto1    := dEmis + CondARQ->Vct1
    nValor1   := nTotalNota
    nComis1   := nTotalComi
    nAnter1   := nTotalComi
    nComissao := nTotalComi
    
    if CondARQ->Vct2 != 0
      dVcto2  := dEmis + CondARQ->Vct2
      nComis1 := nComis2 := nTotalComi / 2
      
      if CondARQ->Indi > 0 
        nValor1 := nValor2 := nTotalNota * CondARQ->Indi
        nAnter1 := nAnter2 := nTotalNota * CondARQ->Indi
      else  
        nValor1 := nValor2 := nTotalNota / 2
        nAnter1 := nAnter2 := nTotalNota / 2
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct3 != 0
      dVcto3  := dEmis + CondARQ->Vct3
      nComis1 := nComis2 := nComis3 := nTotalComi / 3

      if CondARQ->Indi > 0 
        nValor1 := nValor2 := nValor3 := nTotalNota * CondARQ->Indi
        nAnter1 := nAnter2 := nAnter3 := nTotalNota * CondARQ->Indi
      else  
        nValor1 := nValor2 := nValor3 := nTotalNota / 3
        nAnter1 := nAnter2 := nAnter3 := nTotalNota / 3
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct4 != 0
      dVcto4  := dEmis + CondARQ->Vct4
      nComis1 := nComis2 := nComis3 := nComis4 := nTotalComi / 4

      if CondARQ->Indi > 0 
        nValor1 := nValor2 := nValor3 := nValor4 := nTotalNota * CondARQ->Indi
        nAnter1 := nAnter2 := nAnter3 := nAnter4 := nTotalNota * CondARQ->Indi
      else  
        nValor1 := nValor2 := nValor3 := nValor4 := nTotalNota / 4
        nAnter1 := nAnter2 := nAnter3 := nAnter4 := nTotalNota / 4
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct5 != 0
      dVcto5  := dEmis + CondARQ->Vct5
      nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := nTotalComi / 5

      if CondARQ->Indi > 0 
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nTotalNota * CondARQ->Indi
        nAnter1 := nAnter2 := nAnter3 := nAnter4 := nAnter5 := nTotalNota * CondARQ->Indi
      else  
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nTotalNota / 5
        nAnter1 := nAnter2 := nAnter3 := nAnter4 := nAnter5 := nTotalNota / 5
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct6 != 0
      dVcto6  := dEmis + CondARQ->Vct6
      nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := nComis6 := nTotalComi / 6

      if CondARQ->Indi > 0 
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nTotalNota * CondARQ->Indi
        nAnter1 := nAnter2 := nAnter3 := nAnter4 := nAnter5 := nAnter6 := nTotalNota * CondARQ->Indi
      else  
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nTotalNota / 6
        nAnter1 := nAnter2 := nAnter3 := nAnter4 := nAnter5 := nAnter6 := nTotalNota / 6
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct7 != 0
      dVcto7  := dEmis + CondARQ->Vct7
      nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := nComis6 := nComis7 := nTotalComi / 7

      if CondARQ->Indi > 0 
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nTotalNota * CondARQ->Indi
        nAnter1 := nAnter2 := nAnter3 := nAnter4 := nAnter5 := nAnter6 := nAnter7 := nTotalNota * CondARQ->Indi
      else  
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nTotalNota / 7
        nAnter1 := nAnter2 := nAnter3 := nAnter4 := nAnter5 := nAnter6 := nAnter7 := nTotalNota / 7
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct8 != 0
      dVcto8  := dEmis + CondARQ->Vct8
      nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := nComis6 := nComis7 := nComis8 := nTotalComi / 8

      if CondARQ->Indi > 0 
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nValor8 := nTotalNota * CondARQ->Indi
        nAnter1 := nAnter2 := nAnter3 := nAnter4 := nAnter5 := nAnter6 := nAnter7 := nAnter8 := nTotalNota * CondARQ->Indi
      else  
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nValor8 := nTotalNota / 8
        nAnter1 := nAnter2 := nAnter3 := nAnter4 := nAnter5 := nAnter6 := nAnter7 := nAnter8 := nTotalNota / 8
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct9 != 0
      dVcto9  := dEmis + CondARQ->Vct9
      nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := nComis6 := nComis7 := nComis8 := nComis9 := nTotalComi / 9

      if CondARQ->Indi > 0 
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nValor8 := nValor9 := nTotalNota * CondARQ->Indi
        nAnter1 := nAnter2 := nAnter3 := nAnter4 := nAnter5 := nAnter6 := nAnter7 := nAnter8 := nAnter9 := nTotalNota * CondARQ->Indi
      else  
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nValor8 := nValor9 := nTotalNota / 9
        nAnter1 := nAnter2 := nAnter3 := nAnter4 := nAnter5 := nAnter6 := nAnter7 := nAnter8 := nAnter9 := nTotalNota / 9
      endif  
      nParcAll ++
    endif
  endif  

  if CondARQ->Vct1 == 0 .and. CondARQ->Vct2 == 0 .and. CondARQ->Vct3 == 0 .and.;
     CondARQ->Vct4 == 0 .and. CondARQ->Vct5 == 0 .and. CondARQ->Vct6 == 0 .and.;
     CondARQ->Vct7 == 0 .and. CondARQ->Vct8 == 0 .and. CondARQ->Vct9 == 0 .or. nCond == 0
  else    
    tVcto := savescreen( 00, 00, 23, 79 )  

    Janela ( 04, 09, 10 + nParcAll, 63, mensagem( 'Janela', 'PediPres', .f. ), .t. )
    Mensagem ( 'Pedf', 'Vcto' )

    setcolor ( CorJanel )
    @ 06,11 say '  Vencimento 1              Valor 1'
    if nParcAll >= 2
      @ 07,11 say '  Vencimento 2              Valor 2'
    endif
    if nParcAll >= 3
      @ 08,11 say '  Vencimento 3              Valor 3'
    endif
    if nParcAll >= 4
      @ 09,11 say '  Vencimento 4              Valor 4'
    endif
    if nParcAll >= 5
      @ 10,11 say '  Vencimento 5              Valor 5'
    endif
    if nParcAll >= 6
      @ 11,11 say '  Vencimento 6              Valor 6'
    endif
    if nParcAll >= 7
      @ 12,11 say '  Vencimento 7              Valor 7'
    endif
    if nParcAll >= 8
      @ 13,11 say '  Vencimento 8              Valor 8'
    endif
    if nParcAll >= 9
      @ 14,11 say '  Vencimento 9              Valor 9'
    endif
    
    @ 07 + nParcAll,11 say '      Portador'
    @ 09 + nParcAll,50 say '[ ] Faturar'
   
    setcolor( CorCampo )
    @ 07 + nParcAll,33 say PortARQ->Nome
  
    setcolor ( CorJanel + ',' + CorCampo )
    @ 06,26 get dVcto1      pict '99/99/9999'
    @ 06,47 get nValor1     pict '@E 999,999,999.99' valid CalcEntN() 
    if nParcAll >= 2
      @ 07,26 get dVcto2    pict '99/99/9999'
      @ 07,47 get nValor2   pict '@E 999,999,999.99' valid CalcEntN()
    endif  
    if nParcAll >= 3
      @ 08,26 get dVcto3    pict '99/99/9999'  
      @ 08,47 get nValor3   pict '@E 999,999,999.99' valid CalcEntN()
    endif  
    if nParcAll >= 4
      @ 09,26 get dVcto4    pict '99/99/9999'
      @ 09,47 get nValor4   pict '@E 999,999,999.99' valid CalcEntN()
    endif  
    if nParcAll >= 5
      @ 10,26 get dVcto5    pict '99/99/9999'
      @ 10,47 get nValor5   pict '@E 999,999,999.99' valid CalcEntN()
    endif  
    if nParcAll >= 6
      @ 11,26 get dVcto6    pict '99/99/9999'
      @ 11,47 get nValor6   pict '@E 999,999,999.99' valid CalcEntN()
    endif  
    if nParcAll >= 7
      @ 12,26 get dVcto7    pict '99/99/9999'
      @ 12,47 get nValor7   pict '@E 999,999,999.99' valid CalcEntN()
    endif  
    if nParcAll >= 8
      @ 13,26 get dVcto8    pict '99/99/9999'
      @ 13,47 get nValor8   pict '@E 999,999,999.99' valid CalcEntN()
    endif  
    if nParcAll >= 9
      @ 14,26 get dVcto9    pict '99/99/9999'
      @ 14,47 get nValor9   pict '@E 999,999,999.99' valid CalcEntN()
    endif  

    @ 07 + nParcAll,26 get nPort     pict '999999'     valid ValidARQ( 07 + nParcAll, 26, "NSaiARQ", "Código" , "Port", "Descrição", "Nome", "Port", "nPort", .t., 6, "Consulta de Portadores", "PortARQ", 30 )
    @ 09 + nParcAll,51 get cFaturas  pict '@!'       valid cFaturas == "X" .or. cFaturas == " "
    read
    
    cPort := strzero( nPort, 6 )

    restscreen( 00, 00, 23, 79, tVcto )  
  endif
return(.t.)

//
// Calcula a Entrada do Pedido 
//
function CalcEntN()
  nTotaEntr := 0
  aSim      := {}
  aNao      := {}
  
  for nK := 1 to 9
    cN := str( nK, 1 )
    
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
      cA := str( val( aNao[ nH ] ), 1 )

      nValor&cA := ( nTotalNota - nTotaEntr ) / len( aNao )
      nAnter&cA := ( nTotalNota - nTotaEntr ) / len( aNao )
    next
  endif    

  setcolor( CorCampo )
  @ 06,26 say dVcto1      pict '99/99/9999'          
  @ 06,47 say nValor1     pict '@E 999,999,999.99'
  if nParcAll >= 2
    @ 07,26 say dVcto2    pict '99/99/9999'
    @ 07,47 say nValor2   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 3
    @ 08,26 say dVcto3    pict '99/99/9999'
    @ 08,47 say nValor3   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 4
    @ 09,26 say dVcto4    pict '99/99/9999'
    @ 09,47 say nValor4   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 5
    @ 10,26 say dVcto5    pict '99/99/9999'
    @ 10,47 say nValor5   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 6
    @ 11,26 say dVcto6    pict '99/99/9999'
    @ 11,47 say nValor6   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 7
    @ 12,26 say dVcto7    pict '99/99/9999'
    @ 12,47 say nValor7   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 8
    @ 13,26 say dVcto8    pict '99/99/9999'
    @ 13,47 say nValor8   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 9
    @ 14,26 say dVcto9    pict '99/99/9999'
    @ 14,47 say nValor9   pict '@E 999,999,999.99'
  endif  
  setcolor( CorJanel + ',' + CorCampo )
return(.t.)

function CalcTroc ()
  if nTotalNota > ( nSubTotal - nDesconto )
    tTroco     := savescreen( 00, 00, 23, 79 )
    nTotalOld  := nTotalNota
    nTroco     := nTotalNota - ( nSubTotal - nDesconto )
    nTotalNota := ( nSubTotal - nDesconto )

    setcolor( CorJanel )
    @ 06, 01 clear to 11, 41
    @ 06, 01 to 11, 41
 
    setcolor( CorCabec ) 
    @ 06,01 say '                                  Troco  '

    BigNumber( nTroco )

    Teclar(0)

    restscreen( 00, 00, 23, 79, tTroco ) 
  endif
return(.t.)

//
// Entra com os vencimentos do Pedido
//
function EntrVcto()

  if lastkey () == K_ESC .or. lastkey () == K_PGDN
    return NIL
  endif

  if cStat == 'incl'
    Mensagem( 'Nota', 'Incl' )
  else
    Mensagem( 'Nota', 'Alte' )
  endif
  
  do while .t.
    lAlterou := .t.

    setcolor ( CorJanel + ',' + CorCampo )
    @ 17,61 get nDesconto    pict '@E 999,999,999.99' valid CalcDesc ()
    @ 18,61 get nTotalNota   pict '@E 999,999,999.99' valid CalcTroc ()
    @ 16,13 get nClie        pict '999999'  valid ValidClie( 16, 13, "NSaiARQ", , 28, .t. )
    @ 17,13 get nCond        pict '999999'  valid ValidARQ( 17, 13, "NSaiARQ", "Código" , "Cond", "Descrição", "Nome", "Cond", "nCond", .t., 6, "Consulta de Condições Pagamento", "CondARQ", 28 ) .and. PediPres() 
    @ 18,13 get nRepr        pict '999999'  valid ValidARQ( 18, 13, "NSaiARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nRepr", .t., 6, "Consulta de Vendedores", "ReprARQ", 28 )
    read
    
    if lastkey() == K_ESC
      if Saindo(lAlterou)
        exit
      else
        loop
      endif  
    else
      exit
    endif   
  enddo
    
  cRepr := strzero( nRepr, 6 )
  cClie := strzero( nClie, 6 )
  cCond := strzero( nCond, 6 )
return NIL  

//
//  Relatório dos Pedidos
//
function PrinNotC ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )
  
    #ifdef DBF_NTX
      set index to ProdIND1, ProdIND2
    #endif
  endif

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )
  
    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2
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

  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 08, 08, 13, 70, mensagem( 'Janela', 'PrinNotC', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,10 say '   Pedido Inicial                Pedido Final'
  @ 11,10 say '  Cliente Inicial               Cliente Final'
  @ 12,10 say '  Emissão Inicial               Emissão Final'
  
  select ClieARQ
  set order to 1   
  dbgotop ()
  nClieIni := val( Clie )
  dbgobottom ()
  nClieFin := val( Clie )

  select NSaiARQ
  set order to 1   
  dbgotop ()
  nNotaIni := val( Nota )
  dbgobottom ()
  nNotaFin := val( Nota )

  dSaidIni := ctod('01/01/90')
  dSaidFin := date ()

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,28 get nNotaIni          pict '999999' 
  @ 10,56 get nNotaFin          pict '999999'     valid nNotaFin >= nNotaIni
  @ 11,28 get nClieIni          pict '999999'     valid ValidClie( 99, 99, "ClieARQ", "nClieIni" )
  @ 11,56 get nClieFin          pict '999999'     valid ValidClie( 99, 99, "ClieARQ", "nClieFin" ) .and. nClieFin >= nClieIni
  @ 12,28 get dSaidIni          pict '99/99/9999' 
  @ 12,56 get dSaidFin          pict '99/99/9999'   valid dSaidFin >= dSaidIni
  read

  if lastkey() == K_ESC
    select NSaiARQ
    close
    select ProdARQ
    close
    select ClieARQ
    close
    select INSaARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  Aguarde ()

  nPag     := 1
  nLin     := 0
  cArqu2   := cArqu2 + "." + strzero( nPag, 3 )

  cNotaIni := strzero( nNotaIni, 6 )
  cNotaFin := strzero( nNotaFin, 6 )
  cClieIni := strzero( nClieIni, 6 )
  cClieFin := strzero( nClieFin, 6 )
  cSaidIni := dtos( dSaidIni )
  cSaidFin := dtos( dSaidFin )
  lInicio  := .t.
  
  select ProdARQ
  set order to 1

  select NSaiARQ
  set order    to 1
  set relation to Clie into ClieARQ              
  dbseek( cNotaIni, .t. )
  do while Nota >= cNotaIni .and. Nota <= cNotaFin .and. !eof ()              
    if Clie >= cClieIni .and. Clie <= cClieFin .and. Emis >= dSaidIni .and. Emis <= dSaidFin
      if lInicio
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
        
        lInicio := .f.
      endif
      
      if nLin == 0
        Cabecalho ( 'Pedidos', 80, 3 )
        CabNSai ()
      endif
   
      @ nLin,01 say Nota
      @ nLin,08 say Emis                 pict '99/99/9999'
      if Clie == '999999'
        @ nLin,19 say alltrim( Cliente )  + ' - ' + Clie
      else  
        @ nLin,19 say alltrim( ClieARQ->Nome )  + ' - ' + Clie
      endif  
      nLin ++
    
      nValorTotal := nTotalNota := 0
      cNota       := Nota
 
      select INSaARQ
      set order    to 1
      set relation to Prod into ProdARQ
      dbseek( cNota, .t. )
      do while Nota == cNota
        nValorTotal := Qtde * PrecoVenda
        nTotalNota  += nValorTotal
 
        @ nLin, 08 say right( Sequ, 2 )
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
        @ nLin, 57 say PrecoVenda          pict PictPreco(10)
        @ nLin, 69 say nValorTotal         pict '@E 999,999.99'
        nLin ++

        if nLin >= pLimite
          Rodape(80) 

          cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
          cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

          set printer to ( cArqu2 )
          set printer on
      
          select NSaiARQ
        
          Cabecalho ( 'Pedidos', 80, 3 )
          CabNSai   ()
       
          @ nLin,01 say Nota
          @ nLin,08 say Emis                 pict '99/99/9999'
          @ nLin,17 say Obse                 pict '@S50' 
          nLin ++

          select INSaARQ
        endif   
      
        dbskip ()
      enddo
     
      select NSaiARQ

      @ nLin, 50 say 'Total do Pedido'
      @ nLin, 69 say nTotalNota         pict '@E 999,999.99'
      nLin += 2

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
      replace Titu       with "Relatório dos Pedidos"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
    close
  endif

  select NSaiARQ
  close
  select ProdARQ
  close
  select ClieARQ
  close
  select INSaARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabNSai ()
  @ 02,01 say 'Pedido Data       Cliente'
  @ 03,01 say '     Seq. Cod   Produto/Serviço                  Qtde.   P. Unit. Valor Total'

  nLin := 5  
return NIL

//
// Imprimir Pedido
//
function ImprNota (lFicha)
  
  Janela( 11, 22, 14, 49, mensagem( 'Janela', 'Imprimir', .f. ), .f. )
  Mensagem( 'LEVE', 'Print' )
  setcolor( CorJanel )
    
  aOpc := {}
  nPrn := 0

  aadd( aOpc, { ' Impressora ', 2, 'I', 13, 25, "Imprimir Pedido para impressora." } )
  aadd( aOpc, { ' Arquivo ',    2, 'A', 13, 38, "Gerar arquivo texto da impressão do pedido." } )
    
  nTipoNota := HCHOICE( aOpc, 2, 1 )
    
  if nTipoNota == 2
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
  else    
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
  
      nTipoNota := 2
    endif  
  endif    
  
  tPrt := savescreen( 00, 00, 23, 79 )


  if lFicha == NIL
    lFicha := .f.
  endif
  
  if lFicha 
    select ClieARQ
  
  setprc( 0, 0 )
  
  nLin  := 0
  cData := alltrim( EmprARQ->Cida ) + '(' + EmprARQ->UF + '), ' + strzero( day( date() ), 2 ) +;
           ' de ' + alltrim( aMesExt[ month( date() ) ] ) + ' de' + str( year( date() ) )
 
  if EmprARQ->Impr == "X"
    @ nLin,00 say chr(27) + "@"
    @ nLin,00 say chr(18)
    @ nLin,00 say chr(27) + chr(67) + chr(33)
  endif  
  
  @ nLin,01 say '+-----------------------------------------------------------------------------+'
  nLin ++
  @ nLin,01 say '|' 
  @ nLin,03 say EmprARQ->Razao
  @ nLin,59 say 'Fone ' + left( EmprARQ->Fone, 14 ) + ' |'
  nLin ++
  @ nLin,01 say '|' 
  @ nLin,03 say EmprARQ->Ende
  @ nLin,60 say 'Fax ' + left( EmprARQ->Fax, 14 ) + ' |'
  nLin ++
  @ nLin,01 say '|'
  @ nLin,03 say transform( EmprARQ->CEP, '99999-999' ) + ' - ' + alltrim( EmprARQ->Bairro ) +;
                ' - ' + alltrim( EmprARQ->Cida ) + ' - ' + EmprARQ->UF
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '|' 
  @ nLin,03 say EmprARQ->CGC                    pict '@R 99.999.999/9999-99'
  @ nLin,25 say EmprARQ->InscEstd 
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '+-----------------------------------------------------------------------------+'
  nLin ++
  @ nLin,01 say '|    Cliente '
  @ nLin,14 say Nome
  @ nLin,59 say 'Codigo ' + Clie + '       |'
  nLin ++
  @ nLin,01 say '|   Endereço '
  @ nLin,14 say left( Ende, 30 )
  @ nLin,62 say 'CEP ' + transform( CEP, '99999-999' ) + '    |'
  nLin ++
  @ nLin,01 say '|     Bairro' 
  @ nLin,14 say Bair                        pict '@S20'
  @ nLin,36 say 'Cidade ' + left( Cida,  18 )
  @ nLin,63 say 'UF ' + UF + '           |'
  nLin ++
  @ nLin,01 say '|    Próximo '
  @ nLin,14 say Prox
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '|       Fone '
  @ nLin,14 say Fone         
  @ nLin,39 say 'CPF ' + transform( CPF, '@E 999,999,999-99' )
  @ nLin,63 say 'RG ' + left( RG, 12 ) + ' |'
  nLin ++
  @ nLin,01 say '|    Emprego '
  @ nLin,14 say left( Emprego, 20 )
  @ nLin,38 say 'Fone ' + left( Fone, 14 )
  @ nLin,60 say 'Cargo ' + left( Carg, 12 ) + ' |'
  nLin ++
  @ nLin,01 say '|                                                                             |'
  nLin ++
  @ nLin,01 say '|   Filiação '
  @ nLin,14 say Filiacao
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '|    Natural '
  @ nLin,14 say Natural
  @ nLin,35 say 'Nasc. ' + dtoc( Nasc ) + '  Estado Civil ' + EstaCivil + '   |'
  nLin ++
  @ nLin,01 say '|                                                                             |'
  nLin ++
  @ nLin,01 say '|    Conjuge '
  @ nLin,14 say Conjuge
  @ nLin,60 say 'Nasc. ' + dtoc( CJNasc ) + '   |'
  nLin ++
  @ nLin,01 say '|        CPF '
  @ nLin,14 say CJCPF                 pict '@E 999,999,999-99'
  @ nLin,40 say 'RG ' + CJRG
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '|    Emprego ' + CJEmprego
  @ nLin,60 say 'Cargo ' + left( CJCargo, 12 ) + ' |'
  nLin ++
  @ nLin,01 say '|                                                                             |'
  nLin ++
  @ nLin,01 say '|   Avalista ' + Aval
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '| Referencia ' + FontRefe
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '|        SPC ' + ObsSPC 
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '| Observação ' + Obse 
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '|                                                                             |'
  nLin ++
  @ nLin,01 say '|                                             _____________________________   |'
  nLin ++
  @ nLin,01 say '| ' + cData
  @ nLin,47 say Nome                 pict '@S30'
  @ nLin,79 say '|'
  nLin ++  
  @ nLin,01 say '+-----------------------------------------------------------------------------+'
  nLin += 6
  if EmprARQ->Impr == "X"
    @ nLin,00 say chr(27) + "@"
  else
    @ nLin,00 say " "  
  endif  
  
   
  endif  
  

  
  for nK := 1 to EmprARQ->CopiaNota

    nLin := 0

    setprc( 0, 0 )
 
    do case
      case EmprARQ->TipoPedi == 1
        if EmprARQ->Impr == "X"
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
            @ nLin,57 say 'Fone'
            @ nLin,62 say alltrim( EmprARQ->Fone )
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
        if NSaiARQ->Clie == '999999'
          @ nLin,15 say left( NSaiARQ->Cliente, 30 ) + ' ' + NSaiARQ->Clie
        else
          @ nLin,15 say left( ClieARQ->Nome, 30 ) + ' ' + NSaiARQ->Clie
        endif
        @ nLin,53 say 'Fone ' + alltrim( ClieARQ->Fone )
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
          @ nLin,15 say NSaiARQ->Vcto1         pict '99/99/9999'
          @ nLin,26 say NSaiARQ->Valor1        pict '@E 99,999.99'
          if NSaiARQ->Valor2 > 0
            @ nLin,36 say NSaiARQ->Vcto2       pict '99/99/9999'
            @ nLin,47 say NSaiARQ->Valor2      pict '@E 99,999.99'
          endif
          if NSaiARQ->Valor3 > 0
            @ nLin,57 say NSaiARQ->Vcto3       pict '99/99/9999'
            @ nLin,68 say NSaiARQ->Valor3      pict '@E 99,999.99'
          endif
          @ nLin,78 say '|'
          nLin ++

          if NSaiARQ->Valor4 > 0
            @ nLin,01 say '|'
            if NSaiARQ->Valor4 > 0
              @ nLin,15 say NSaiARQ->Vcto4       pict '99/99/9999'
              @ nLin,26 say NSaiARQ->Valor4      pict '@E 99,999.99'
            endif
            if NSaiARQ->Valor5 > 0
              @ nLin,36 say NSaiARQ->Vcto5       pict '99/99/9999'
              @ nLin,47 say NSaiARQ->Valor5      pict '@E 99,999.99'
            endif
            if NSaiARQ->Valor6 > 0
              @ nLin,57 say NSaiARQ->Vcto6       pict '99/99/9999'
              @ nLin,68 say NSaiARQ->Valor6      pict '@E 99,999.99'
            endif
            @ nLin,78 say '|'
            nLin ++
          endif
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
        nSubTotal   := NSaiARQ->SubTotal
        nDesconto   := NSaiARQ->Desconto

        select INSaARQ
        set order    to 1
        set relation to Prod into ProdARQ
        dbseek( cNotaNew, .t. )
        do while Nota == cNotaNew .and. !eof()
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

          nSequ  ++
          nLin   ++
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
            if EmprARQ->EmprPedi == "X"
              @ nLin,01 say '|'
              @ nLin,03 say EmprARQ->Razao       pict '@S40'
              @ nLin,54 say 'CNPJ'
              @ nLin,59 say EmprARQ->CGC         pict '@R 99.999.999/9999-99'
              @ nLin,78 say '|'
              nLin ++
              @ nLin,01 say '|'
              @ nLin,03 say EmprARQ->Ende        pict '@S40'
              @ nLin,46 say 'Insc. Estad. ' + left( EmprARQ->InscEstd, 14 ) + '     |'
              nLin ++
              @ nLin,01 say '|'
              @ nLin,03 say EmprARQ->Bairro      pict '@S15'
              @ nLin,24 say alltrim( EmprARQ->Cida ) + '-' + EmprARQ->UF
              @ nLin,54 say 'Fone'
              @ nLin,59 say EmprARQ->Fone
              @ nLin,78 say '|'
              nLin ++
              @ nLin,01 say '+----------------------------------------------------------------------------+'
              nLin ++
            endif
            @ nLin,01 say '|      Pedido'
            @ nLin,15 say cNotaNew
            @ nLin,62 say 'Data'
            @ nLin,67 say NSaiARQ->Emis
            @ nLin,78 say '|'
            nLin ++
            @ nLin,01 say '|        Nome'
            if NSaiARQ->Clie == '999999'
              @ nLin,15 say left( NSaiARQ->Cliente, 40 ) + ' ' + NSaiARQ->Clie
            else
              @ nLin,15 say left( ClieARQ->Nome, 40 ) + ' ' + NSaiARQ->Clie
            endif
            @ nLin,62 say 'Hora'
            @ nLin,67 say time()
            @ nLin,78 say '|'
            nLin ++
            @ nLin,01 say '|    Endereco'
            @ nLin,15 say ClieARQ->Ende
            @ nLin,78 say '|'
            nLin ++
            @ nLin,01 say '|   Condicoes '
            @ nLin,15 say CondARQ->Nome
            @ nLin,78 say '|'
            nLin ++

            if CondARQ->Vct1 == 0 .and. CondARQ->Vct2 == 0 .and. CondARQ->Vct3 == 0 .and. CondARQ->Vct4 == 0 .and. CondARQ->Vct5 == 0
              // Venda a Vista
            else
              @ nLin,01 say '|'
              @ nLin,15 say NSaiARQ->Vcto1         pict '99/99/9999'
              @ nLin,26 say NSaiARQ->Valor1        pict '@E 99,999.99'
              if NSaiARQ->Valor2 > 0
                @ nLin,36 say NSaiARQ->Vcto2       pict '99/99/9999'
                @ nLin,47 say NSaiARQ->Valor2      pict '@E 99,999.99'
              endif
              if NSaiARQ->Valor3 > 0
                @ nLin,57 say NSaiARQ->Vcto3       pict '99/99/9999'
                @ nLin,68 say NSaiARQ->Valor3      pict '@E 99,999.99'
              endif
              @ nLin,78 say '|'
              nLin ++
              @ nLin,01 say '|'
              if NSaiARQ->Valor4 > 0
                @ nLin,15 say NSaiARQ->Vcto4       pict '99/99/9999'
                @ nLin,26 say NSaiARQ->Valor4      pict '@E 99,999.99'
              endif
              if NSaiARQ->Valor5 > 0
                @ nLin,36 say NSaiARQ->Vcto5       pict '99/99/9999'
                @ nLin,47 say NSaiARQ->Valor5      pict '@E 99,999.99'
              endif
              if NSaiARQ->Valor6 > 0
                @ nLin,57 say NSaiARQ->Vcto6       pict '99/99/9999'
                @ nLin,68 say NSaiARQ->Valor6      pict '@E 99,999.99'
              endif
              @ nLin,78 say '|'
              nLin ++
            endif

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

        nTotal := iif( EmprARQ->EmprPedi == "X", 13, 16 )

        if nSequ < nTotal
          for nIni := 1 to ( nTotal - nSequ )

            @ nLin, 01 say '|         |    |                                       |          |          |'
            nLin ++
          next
        endif

        @ nLin,01 say '|         |    |Assinatura:                            |          |          |'
        nLin ++
        @ nLin,01 say '+---------+----+---------------------------------------+----------+----------+'
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
        if EmprARQ->Impr == "X"
          @ nLin,00 say chr(27) + "@"
        endif  
      case EmprARQ->TipoPedi == 2
        if EmprARQ->Impr == "X"
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
            @ nLin,57 say 'Fone'
            @ nLin,62 say alltrim( EmprARQ->Fone )
          endif  
          @ nLin,78 say '|'
          nLin ++
          @ nLin,01 say '+----------------------------------------------------------------------------+'
          nLin ++
        endif
        @ nLin,01 say '|      Pedido'
        @ nLin,15 say cNotaNew
        @ nLin,45 say 'Data'
        @ nLin,50 say NSaiARQ->Emis
        @ nLin,62 say 'Hora'
        @ nLin,67 say time()
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '|        Nome'
        if NSaiARQ->Clie == '999999'
          @ nLin,15 say left( NSaiARQ->Cliente, 30 ) + ' ' + NSaiARQ->Clie
        else
          @ nLin,15 say left( ClieARQ->Nome, 30 ) + ' ' + NSaiARQ->Clie
        endif
        @ nLin,53 say 'Fone ' + alltrim( ClieARQ->Fone )
        @ nLin,78 say '|'
        nLin ++
        if !empty( ClieARQ->CGC )
          @ nLin,01 say '|        CNPJ'
          @ nLin,15 say ClieARQ->CGC            pict '@R 99.999.999/9999-99'
          @ nLin,40 say 'Insc. Estadual ' + alltrim( ClieARQ->InscEstd )
          @ nLin,78 say '|'
          nLin ++

          lCGC := .t.
        else
          lCGC := .f.
        endif

        @ nLin,01 say '|    Endereço'
        @ nLin,15 say alltrim( ClieARQ->Ende ) + ' ' + alltrim( ClieARQ->Bair ) + ' ' + alltrim( ClieARQ->Cida ) + ' ' + alltrim( ClieARQ->UF )
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
          @ nLin,15 say NSaiARQ->Vcto1         pict '99/99/9999'
          @ nLin,26 say NSaiARQ->Valor1        pict '@E 99,999.99'
          if NSaiARQ->Valor2 > 0
            @ nLin,36 say NSaiARQ->Vcto2       pict '99/99/9999'
            @ nLin,47 say NSaiARQ->Valor2      pict '@E 99,999.99'
          endif
          if NSaiARQ->Valor3 > 0
            @ nLin,57 say NSaiARQ->Vcto3       pict '99/99/9999'
            @ nLin,68 say NSaiARQ->Valor3      pict '@E 99,999.99'
          endif
          @ nLin,78 say '|'
          nLin ++

          if !lCGC
            @ nLin,01 say '|'
            if NSaiARQ->Valor4 > 0
              @ nLin,15 say NSaiARQ->Vcto4       pict '99/99/9999'
              @ nLin,26 say NSaiARQ->Valor4      pict '@E 99,999.99'
            endif
            if NSaiARQ->Valor5 > 0
              @ nLin,36 say NSaiARQ->Vcto5       pict '99/99/9999'
              @ nLin,47 say NSaiARQ->Valor5      pict '@E 99,999.99'
            endif
            if NSaiARQ->Valor6 > 0
              @ nLin,57 say NSaiARQ->Vcto6       pict '99/99/9999'
              @ nLin,68 say NSaiARQ->Valor6      pict '@E 99,999.99'
            endif
            @ nLin,78 say '|'
            nLin ++
          endif
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
        nSubTotal   := NSaiARQ->SubTotal
        nDesconto   := NSaiARQ->Desconto

        select INSaARQ
        set order to 1
        dbseek( cNotaNew, .t. )
        do while Nota == cNotaNew .and. !eof()
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

          nSequ  ++
          nLin   ++

          nItens := iif( EmprARQ->EmprPedi == "X", 46, 49 )

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
            if EmprARQ->EmprPedi == "X"
              @ nLin,01 say '|'
              @ nLin,03 say EmprARQ->Razao       pict '@S40'
              @ nLin,54 say 'CNPJ'
              @ nLin,59 say EmprARQ->CGC         pict '@R 99.999.999/9999-99'
              @ nLin,78 say '|'
              nLin ++
              @ nLin,01 say '|'
              @ nLin,03 say EmprARQ->Ende        pict '@S40'
              @ nLin,46 say 'Insc. Estad. ' + left( EmprARQ->InscEstd, 14 ) + '     |'
              nLin ++
              @ nLin,01 say '|'
              @ nLin,03 say EmprARQ->Bairro      pict '@S15'
              @ nLin,24 say alltrim( EmprARQ->Cida ) + '-' + EmprARQ->UF
              @ nLin,54 say 'Fone'
              @ nLin,59 say EmprARQ->Fone
              @ nLin,78 say '|'
              nLin ++
              @ nLin,01 say '+----------------------------------------------------------------------------+'
              nLin ++
            endif
            @ nLin,01 say '|      Pedido'
            @ nLin,15 say cNotaNew
            @ nLin,62 say 'Data'
            @ nLin,67 say NSaiARQ->Emis
            @ nLin,78 say '|'
            nLin ++
            @ nLin,01 say '|        Nome'
            if NSaiARQ->Clie == '999999'
              @ nLin,15 say left( NSaiARQ->Cliente, 40 ) + ' ' + NSaiARQ->Clie
            else
              @ nLin,15 say left( ClieARQ->Nome, 40 ) + ' ' + NSaiARQ->Clie
            endif
            @ nLin,62 say 'Hora'
            @ nLin,67 say time()
            @ nLin,78 say '|'
            nLin ++
            @ nLin,01 say '|    Endereco'
            @ nLin,15 say ClieARQ->Ende
            @ nLin,78 say '|'
            nLin ++
            @ nLin,01 say '|   Condicoes '
            @ nLin,15 say CondARQ->Nome
            @ nLin,78 say '|'
            nLin ++

            if CondARQ->Vct1 == 0 .and. CondARQ->Vct2 == 0 .and. CondARQ->Vct3 == 0 .and. CondARQ->Vct4 == 0 .and. CondARQ->Vct5 == 0
              // Venda a Vista
            else
              @ nLin,01 say '|'
              @ nLin,15 say NSaiARQ->Vcto1         pict '99/99/9999'
              @ nLin,26 say NSaiARQ->Valor1        pict '@E 99,999.99'
              if NSaiARQ->Valor2 > 0
                @ nLin,36 say NSaiARQ->Vcto2       pict '99/99/9999'
                @ nLin,47 say NSaiARQ->Valor2      pict '@E 99,999.99'
              endif
              if NSaiARQ->Valor3 > 0
                @ nLin,57 say NSaiARQ->Vcto3       pict '99/99/9999'
                @ nLin,68 say NSaiARQ->Valor3      pict '@E 99,999.99'
              endif
              @ nLin,78 say '|'
              nLin ++
              @ nLin,01 say '|'
              if NSaiARQ->Valor4 > 0
                @ nLin,15 say NSaiARQ->Vcto4       pict '99/99/9999'
                @ nLin,26 say NSaiARQ->Valor4      pict '@E 99,999.99'
              endif
              if NSaiARQ->Valor5 > 0
                @ nLin,36 say NSaiARQ->Vcto5       pict '99/99/9999'
                @ nLin,47 say NSaiARQ->Valor5      pict '@E 99,999.99'
              endif
              if NSaiARQ->Valor6 > 0
                @ nLin,57 say NSaiARQ->Vcto6       pict '99/99/9999'
                @ nLin,68 say NSaiARQ->Valor6      pict '@E 99,999.99'
              endif
              @ nLin,78 say '|'
              nLin ++
            endif

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

        nTotal := iif( EmprARQ->EmprPedi == "X", 46, 49 )

        if nSequ < nTotal
          for nIni := 1 to ( nTotal - nSequ )

            @ nLin, 01 say '|         |    |                                       |          |          |'
            nLin ++
          next
        endif

        @ nLin,01 say '|         |    |Assinatura:                            |          |          |'
        nLin ++
        @ nLin,01 say '+---------+----+---------------------------------------+----------+----------+'
        nLin ++
        @ nLin,01 say '| ' + alltrim( EmprARQ->Mensagem )
        @ nLin,63 say 'Total'
        @ nLin,68 say nTotalNota     pict '@E 999,999.99'
        @ nLin,78 say '|'
        nLin ++
        @ nLin,01 say '+----------------------------------------------------------------------------+'

        if lVista
          nLin += 5
        else
          nLin += 3
        endif
        if EmprARQ->Impr == "X"
          @ nLin,00 say chr(27) + "@"
        endif  
      case EmprARQ->TipoPedi == 3
        if EmprARQ->Impr == "X"
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
          if nValor1 > 0
            @ nLin,013 say dVcto1         pict '99/99/9999'
            @ nLin,024 say nValor1        pict '@E 99,999.99'
          endif

          if nValor2 > 0
            @ nLin,036 say dVcto2       pict '99/99/9999'
            @ nLin,047 say nValor2      pict '@E 999,999.99'
          endif
          
          @ nLin,060 say '|'
          
          @ nLin,071 say '|    Vctos.'
          if nValor1 > 0
            @ nLin,083 say dVcto1         pict '99/99/9999'
            @ nLin,094 say nValor1        pict '@E 99,999.99'
          endif

          if nValor2 > 0
            @ nLin,108 say dVcto2       pict '99/99/9999'
            @ nLin,119 say nValor2      pict '@E 999,999.99'
          endif
          
          @ nLin,130 say '|'
          nLin ++
          @ nLin,001 say '|'
          if nValor3 > 0
            @ nLin,013 say dVcto3       pict '99/99/9999'
            @ nLin,024 say nValor3      pict '@E 999,999.99'
          endif
          if nValor4 > 0
            @ nLin,038 say dVcto4       pict '99/99/9999'
            @ nLin,049 say nValor4      pict '@E 999,999.99'
          endif
          @ nLin,060 say '|'
          @ nLin,071 say '|'
          if nValor3 > 0
            @ nLin,083 say dVcto3       pict '99/99/9999'
            @ nLin,094 say nValor3      pict '@E 999,999.99'
          endif
          if nValor4 > 0
            @ nLin,108 say dVcto4       pict '99/99/9999'
            @ nLin,119 say nValor4      pict '@E 999,999.99'
          endif
          @ nLin,130 say '|'
          nLin ++
          @ nLin,001 say '|'
          if nValor5 > 0
            @ nLin,013 say dVcto5       pict '99/99/9999'
            @ nLin,024 say nValor5      pict '@E 999,999.99'
          endif
          if nValor6 > 0
            @ nLin,038 say dVcto6       pict '99/99/9999'
            @ nLin,049 say nValor6      pict '@E 999,999.99'
          endif
          @ nLin,060 say '|'
          @ nLin,071 say '|'
          if nValor5 > 0
            @ nLin,083 say dVcto5       pict '99/99/9999'
            @ nLin,094 say nValor5      pict '@E 999,999.99'
          endif
          if nValor6 > 0
            @ nLin,108 say dVcto6       pict '99/99/9999'
            @ nLin,119 say nValor6      pict '@E 999,999.99'
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

        select( cNConTMP )
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
        
        if EmprARQ->Impr == "X"
          @ nLin,00 say chr(27) + "@"
        endif  
      case EmprARQ->TipoPedi == 4
        if EmprARQ->Impr == "X"
          @ 00,00 say chr(27) + "@"
          @ 00,00 say chr(15)
        endif
         
        if EmprARQ->EmprPedi == "X"
          nLin ++
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
          if nValor1 > 0
            @ nLin,01 say dVcto1         pict '99/99/9999'
            @ nLin,12 say nValor1        pict '@E 99999.99'
          endif
          if nValor2 > 0
            @ nLin,22 say dVcto2         pict '99/99/9999'
            @ nLin,33 say nValor2        pict '@E 99999.99'
          endif
          if nValor3 > 0
            nLin ++
            @ nLin,01 say dVcto3         pict '99/99/9999'
            @ nLin,12 say nValor3        pict '@E 99999.99'
          endif
          if nValor4 > 0
            @ nLin,22 say dVcto4         pict '99/99/9999'
            @ nLin,33 say nValor4        pict '@E 99999.99'
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

        select( cNConTMP )
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
        
        if EmprARQ->Impr == "X"
          @ nLin,00 say chr(27) + "@"
        endif  
    endcase
  next

  set printer to
  set printer off
  set device  to screen
  
  if !empty( GetDefaultPrinter() ) .and. nPrn > 0
    PrnTest(aPrn[nPrn], memoread( cArqTxt ), .f. )
  endif
    
  select CondARQ
  set order  to 1

  select ReprARQ
  set order  to 1
     
  select NSaiARQ
  set order  to 1

return NIL