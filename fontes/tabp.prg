//  Leve, Tabela de Preço
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

function TabP( xTipo )

local cArqu2 := CriaTemp( 5 )
local cArqu3 := right ( cArqu2, 8 )

local cRData := date()
local cRHora := time()

if NetUse( "GrupARQ", .t. )
  VerifIND( "GrupARQ" )

  lOpenGrup := .t.

  #ifdef DBF_NTX
    set index to GrupIND1, GrupIND2
  #endif
else  
  lOpenGrup := .f.
endif

if NetUse( "CondARQ", .t. )
  VerifIND( "CondARQ" )
  
  lOpenCond := .t.

  #ifdef DBF_NTX
    set index to CondIND1, CondIND2
  #endif
else  
  lOpenCond := .f.
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

if NetUse( "FornARQ", .t. )
  VerifIND( "FornARQ" )
  
  lOpenForn := .t.
  
  #ifdef DBF_NTX
    set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
  #endif
else
  lOpenForn := .f.  
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

//  Variaveis de Entrada para Prod

tPrt := savescreen( 00, 00, 23, 79 )

//  Define Intervalo
Janela ( 05, 04, 18, 71, mensagem( 'Janela', 'TabP', .f. ), .f. )

setcolor ( CorJanel + ',' + CorCampo )
@ 07,06 say '   Produto Inicial                  Produto Final'
@ 08,06 say 'Referência Inicial               Referência Final'
@ 09,06 say 'Fornecedor Inicial               Fornecedor Final'
@ 10,06 say '     Grupo Inicial                    Grupo Final'
@ 11,06 say '  Subgrupo Inicial                 Subgrupo Final'

@ 13,06 say '  Adic. Financeiro'
@ 14,06 say '            Tabela                    Espaçamento  0 Linha(s)'
@ 15,06 say '          Validade'

@ 17,06 say '        Quantidade'

setcolor( CorCampo )
@ 17,25 say ' Todas   '
@ 17,35 say ' Falta   '
@ 17,45 say ' Estoque '
  
setcolor( CorAltKC )
@ 17,26 say 'T'
@ 17,36 say 'F'
@ 17,46 say 'E'

select FornARQ
set order  to 1
dbgobottom ()
nFornFin := val ( Forn )

select GrupARQ
set order  to 1
dbgobottom ()
nGrupFin := val ( Grup )

nFornIni := 000
nGrupIni := 000
nSubgIni := 000
nSubgFin := 999999
nSalto   := 0

select ProdARQ
set order    to 1
set relation to Grup into GrupARQ, to Grup+SubG into SubGARQ
dbgotop ()
cProdIni := Prod
nProdIni := val( Prod )
dbgobottom ()
cProdFin := Prod
nProdFin := val( Prod )

cRefeIni := space(15)
cRefeFin := 'z' + space(14)
cProd    := space(04)
nAdic    := 0
nTabe    := 1
dVali    := date() + 30

@ 07,25 get nProdIni  pict '999999'         valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdIni" ) 
@ 07,56 get nProdFin  pict '999999'         valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdFin" ) .and. nProdFin >= nProdIni
@ 08,25 get cRefeIni  pict '@S10'
@ 08,56 get cRefeFin  pict '@S10'           valid cRefeFin >= cRefeIni
@ 09,25 get nFornIni  pict '999999'         valid nFornIni == 0 .or. ValidForn( 99, 99, "ProdARQ", "nFornIni" )       
@ 09,56 get nFornFin  pict '999999'         valid ValidForn( 99, 99, "ProdARQ", "nFornFin" ) .and. nFornFin >= nFornIni
@ 10,25 get nGrupIni  pict '999999'         valid nGrupIni == 0 .or. ValidARQ( 99, 99, "ProdARQ", "Código" , "Grup", "Descrição", "Nome", "Grup", "nGrupIni", .t., 6, "Consulta de Grupos", "GrupARQ", 30 )
@ 10,56 get nGrupFin  pict '999999'         valid ValidARQ( 99, 99, "ProdARQ", "Código" , "Grup", "Descrição", "Nome", "Grup", "nGrupFin", .t., 6, "Consulta de Grupos", "GrupARQ", 30 ) .and. nGrupFin >= nGrupIni
@ 11,25 get nSubgIni  pict '999999' 
@ 11,56 get nSubgFin  pict '999999'         valid nSubgFin >= nSubgIni
@ 13,25 get nAdic     pict '999999'
@ 14,25 get nTabe
@ 14,56 get nSalto    pict '99' 
@ 15,25 get dVali     pict '99/99/9999'
read

if lastkey() == K_ESC
  select ProdARQ
  close
  select GrupARQ
  close
  select CondARQ
  close
  select SubGARQ
  close
  select FornARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
  return NIL
endif

aOpc := {}

aadd( aOpc, { ' Todas   ', 2, 'T', 17, 25, "Seleção de todos as Quantidades." } )
aadd( aOpc, { ' Falta   ', 2, 'F', 17, 35, "Seleção de Produtos em Falta." } )
aadd( aOpc, { ' Estoque ', 2, 'E', 17, 45, "Seleção de Produtos em Estoque." } )

nOpca := HCHOICE( aOpc, 3, 3 )

if lastkey() == K_ESC
  select ProdARQ
  close
  select GrupARQ
  close
  select CondARQ
  close
  select SubGARQ
  close
  select SpooARQ
  close
  select FornARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
  return NIL
endif

Aguarde ()

nPag     := 1
nLin     := 0
cArqu2   := cArqu2 + "." + strzero( nPag, 3 )

cGrupIni := strzero( nGrupIni, 6 )
cGrupFin := strzero( nGrupFin, 6 )
cSubgIni := strzero( nSubgIni, 6 )
cSubgFin := strzero( nSubgFin, 6 )
cProdIni := strzero( nProdIni, 6 )
cProdFin := strzero( nProdFin, 6 )
cFornIni := strzero( nFornIni, 6 )
cFornFin := strzero( nFornFin, 6 )
cAdic    := strzero( nAdic, 2 )
cTabe    := strzero( nTabe, 4 )
cGrupAnt := space(06)
cSubGAnt := space(06)
lInicio  := .t.

select ProdARQ
do case   
  case EmprARQ->ConsProd == 4
    set order to 5
  case EmprARQ->ConsProd == 1 .or. EmprARQ->ConsProd == 3
    if xTipo == 'A'
      set order to 2
    elseif xTipo == 'R'
      set order to 6
    else
      set order to 1
    endif  
  case EmprARQ->ConsProd == 2
    if xTipo == 'A'
      set order to 3
    else  
      set order to 4
    endif  
endcase    
set relation to Grup into GrupARQ, to Grup+SubG into SubGARQ
dbgotop ()
do while !eof ()
  if Prod >= cProdIni .and. Prod <= cProdFin .and. val( SubG ) >= nSubgIni .and. val( SubG ) <= nSubgFin .and. val( Grup ) >= nGrupIni .and. val( Grup ) <= nGrupFin
    if val( Forn ) >= nFornIni .and. val( Forn ) <= nFornFin .and. Refe >= cRefeIni .and. Refe <= cRefeFin
      do case
        case nOpca == 2
          if Qtde > 0 
            dbskip ()
            loop
          endif
        case nOpca == 3
          if Qtde <= 0
            dbskip ()
            loop
          endif
      endcase      

      if lInicio
        set printer to ( cArqu2 )
        set device  to printer
        set printer on

        lInicio := .f.
      endif

      if nLin == 0
        Cabecalho ( 'Tabela de Precos', 132, 2 )
        CabTabP (xTipo)
      endif
      
do case
        case EmprARQ->ConsProd == 1 .or. EmprARQ->ConsProd == 3 .or. EmprARQ->ConsProd == 4
          @ nLin, 01 say Prod
          @ nLin, 08 say Unid
          @ nLin, 11 say Nome                 pict '@S38'
          if xTipo == 'B'
            @ nLin, 50 say CodFab             pict '@S13'
          else  
            @ nLin, 50 say Refe               pict '@S13'
          endif  
          if nAdic > 0
            nPrecoVenda := ( ( PrecoVenda * CondARQ->Acrs ) / 100 ) + PrecoVenda
          else
            nPrecoVenda := PrecoVenda
          endif    
            
          if EmprARQ->Moeda == "X"
            nPrecoVenda *= nMoedaDia
          endif
              
          @ nLin, 64 say nPrecoVenda        pict PictPreco(10)
        
          if !empty( EmprARQ->Preco1 )
            cCalc := alltrim( EmprARQ->Preco1 )

            @ nLin, 75 say &cCalc        pict PictPreco(10)
          endif  
          if !empty( EmprARQ->Preco2 )
            cCalc := alltrim( EmprARQ->Preco2 )

            @ nLin, 86 say &cCalc        pict PictPreco(10)
          endif  
          if !empty( EmprARQ->Preco3 )
            cCalc := alltrim( EmprARQ->Preco3 )

            @ nLin, 097 say &cCalc        pict PictPreco(10)
          endif  
          if !empty( EmprARQ->Preco4 )
            cCalc := alltrim( EmprARQ->Preco4 )
            @ nLin, 108 say &cCalc        pict PictPreco(10)
          endif  
        case EmprARQ->ConsProd == 2
          if cGrupAnt != Grup
            @ nLin,00 say GrupARQ->Nome + ' - ' + Grup
            cGrupAnt := Grup
            nLin ++
          endif

          if cSubGAnt != SubG
            @ nLin,02 say SubGARQ->Nome + ' - ' + SubG
            cSubGAnt := SubG
            nLin ++
          endif

          @ nLin, 04 say Prod
          @ nLin, 11 say Unid
          @ nLin, 15 say Nome                 pict '@S43'
          @ nLin, 59 say Refe                 pict '@S13'
          if nAdic > 0
            nPrecoVenda := ( ( PrecoVenda * CondARQ->Acrs ) / 100 ) + PrecoVenda
            
            if EmprARQ->Moeda == "X"
              nPrecoVenda *= nMoedaDia
            endif

            @ nLin, 70 say nPrecoVenda        pict '@E 9,999.9999'
          else
            if EmprARQ->Moeda == "X"
              @ nLin, 70 say PrecoVenda * nMoedaDia        pict '@E 9,999.9999'
            else
              @ nLin, 70 say PrecoVenda         pict '@E 9,999.9999'
            endif 
          endif
      endcase
      
      nLin ++
      nLin += nSalto

      if nLin >= pLimite
        Rodape(132)

       cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
        cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

        set printer to ( cArqu2 )
        set printer on
      endif
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

if Imprimir( cArqu3, 132 )
  select SpooARQ
  if AdiReg()
    replace Rela       with cArqu3
    if xTipo == 'A'
      replace Titu     with "Tabela de Preço - Alfab‚tica"
    elseif xTipo == 'B' 
      replace Titu     with "Tabela de Preço - Cod Barras"
    else
      replace Titu     with "Tabela de Preço - Codigo"
    endif  
    replace Data       with cRData
    replace Hora       with cRHora
    replace Usua       with cUsuario
    replace Tama       with 132
    replace Empr       with cEmpresa
    dbunlock ()
  endif  
endif

select ProdARQ
close
select GrupARQ
close
select CondARQ
close
select SubGARQ
close
select FornARQ
close
restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabTabP(xTipo)
  select CondARQ
  set order to 1
  dbseek( cAdic, .f. )
  
  if found()
    @ 02, 01 say 'Adic. Financeiro : ' + left( Nome, 15 ) + transform( Acrs, '999.9' )
  endif

  select ProdARQ

  @ 02, 46 say 'Tabela ' + cTabe
  @ 02, 61 say 'Validade ' + dtoc( dVali )
  
  do case 
    case EmprARQ->ConsProd == 4 .or. EmprARQ->ConsProd == 1 .or. EmprARQ->ConsProd == 3
      if xTipo == 'B'
        @ 03, 01 say 'Cod Un Descrição                                Cod F brica  P. Venda'
      else      
        @ 03, 01 say 'Cod Un Descrição                                Referencia    P. Venda'
      endif     
      
      if !empty( EmprARQ->Cabec1 )
        @ 03, 75 say EmprARQ->Cabec1      pict '@S10'
      endif  
      if !empty( EmprARQ->Cabec2 )
        @ 03, 86 say EmprARQ->Cabec2      pict '@S10'
      endif
      if !empty( EmprARQ->Cabec3 )
        @ 03, 097 say EmprARQ->Cabec3      pict '@S10'
      endif  
      if !empty( EmprARQ->Cabec4 )
        @ 03, 108 say EmprARQ->Cabec4     pict '@S10'
      endif  
      
      nLin := 5
    case EmprARQ->ConsProd == 2
      @ 03, 00 say 'Grupo'
      @ 04, 02 say 'SubGrupo'
      @ 05, 04 say 'Cod Un. Descrição                                     Referˆncia   P. Venda'
    
      nLin    := 7
      cGrupAnt := cSubGAnt := space(03)
  endcase    
return NIL

//
// Tabela de Precos por Grupo SubGrupo
//

function TabPGrup ( xTipo )

local cArqu2 := CriaTemp( 5 )
local cArqu3 := right ( cArqu2, 8 )

local cRData := date()
local cRHora := time()

if NetUse( "GrupARQ", .t. )
  VerifIND( "GrupARQ" )
  
  lOpenGrup := .t.

  #ifdef DBF_NTX
    set index to GrupIND1, GrupIND2
  #endif
else  
  lOpenGrup := .f.
endif

if NetUse( "CondARQ", .t. )
  VerifIND( "CondARQ" )
  
  lOpenCond := .t.

  #ifdef DBF_NTX
    set index to CondIND1, CondIND2
  #endif
else  
  lOpenCond := .f.
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

if NetUse( "FornARQ", .t. )
  VerifIND( "FornARQ" )
  
  lOpenForn := .t.
  
  #ifdef DBF_NTX
    set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
  #endif
else
  lOpenForn := .f.  
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

//  Variaveis de Entrada para Prod

tPrt := savescreen( 00, 00, 23, 79 )

//  Define Intervalo
Janela ( 05, 04, 18, 71, mensagem( 'Janela', 'TabPGrup', .f. ), .f. )

setcolor ( CorJanel + ',' + CorCampo )
@ 07,06 say '   Produto Inicial                  Produto Final'
@ 08,06 say 'Referência Inicial               Referência Final'
@ 09,06 say 'Fornecedor Inicial               Fornecedor Final'
@ 10,06 say '     Grupo Inicial                    Grupo Final'
@ 11,06 say '  Subgrupo Inicial                 Subgrupo Final'

@ 13,06 say '  Adic. Financeiro'
@ 14,06 say '            Tabela'
@ 15,06 say '          Validade'

@ 17,06 say '        Quantidade'

setcolor( CorCampo )
@ 17,25 say ' Todas   '
@ 17,35 say ' Falta   '
@ 17,45 say ' Estoque '
  
setcolor( CorAltKC )
@ 17,26 say 'T'
@ 17,36 say 'F'
@ 17,46 say 'E'

select FornARQ
set order  to 1
dbgobottom ()
nFornFin := val ( Forn )

select GrupARQ
set order  to 1
dbgobottom ()
nGrupFin := val ( Grup )

nFornIni := 000
nGrupIni := 000
nSubgIni := 000
nSubgFin := 999999

select ProdARQ
set order    to 1
set relation to Grup into GrupARQ, to Grup+SubG into SubGARQ
dbgotop ()
cProdIni := Prod
nProdIni := val( Prod )
dbgobottom ()
cProdFin := Prod
nProdFin := val( Prod )

cRefeIni := space(15)
cRefeFin := 'z' + space(14)
cProd    := space(04)
nAdic    := 0
nTabe    := 1
dVali    := date() + 30

@ 07,25 get nProdIni  pict '999999'         valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdIni" ) 
@ 07,56 get nProdFin  pict '999999'         valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdFin" ) .and. nProdFin >= nProdIni
@ 08,25 get cRefeIni  pict '@S10'
@ 08,56 get cRefeFin  pict '@S10'           valid cRefeFin >= cRefeIni
@ 09,25 get nFornIni  pict '999999'         valid nFornIni == 0 .or. ValidForn( 99, 99, "ProdARQ", "nFornIni" )       
@ 09,56 get nFornFin  pict '999999'         valid ValidForn( 99, 99, "ProdARQ", "nFornFin" ) .and. nFornFin >= nFornIni
@ 10,25 get nGrupIni  pict '999999'         valid nGrupIni == 0 .or. ValidARQ( 99, 99, "ProdARQ", "Código" , "Grup", "Descrição", "Nome", "Grup", "nGrupIni", .t., 6, "Consulta de Grupos", "GrupARQ", 30 )
@ 10,56 get nGrupFin  pict '999999'         valid ValidARQ( 99, 99, "ProdARQ", "Código" , "Grup", "Descrição", "Nome", "Grup", "nGrupFin", .t., 6, "Consulta de Grupos", "GrupARQ", 30 ) .and. nGrupFin >= nGrupIni
@ 11,25 get nSubgIni  pict '999999' 
@ 11,56 get nSubgFin  pict '999999'         valid nSubgFin >= nSubgIni
@ 13,25 get nAdic     pict '999999'
@ 14,25 get nTabe
@ 15,25 get dVali     pict '99/99/9999'
read

if lastkey() == K_ESC
  select ProdARQ
  close
  select GrupARQ
  close
  select CondARQ
  close
  select SubGARQ
  close
  select FornARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
  return NIL
endif

aOpc := {}

aadd( aOpc, { ' Todas   ', 2, 'T', 17, 25, "Seleção de todos as Quantidades." } )
aadd( aOpc, { ' Falta   ', 2, 'F', 17, 35, "Seleção de Produtos em Falta." } )
aadd( aOpc, { ' Estoque ', 2, 'E', 17, 45, "Seleção de Produtos em Estoque." } )

nOpca := HCHOICE( aOpc, 3, 3 )

if lastkey() == K_ESC
  select ProdARQ
  close
  select GrupARQ
  close
  select CondARQ
  close
  select SubGARQ
  close
  select FornARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
  return NIL
endif

Aguarde ()

nPag     := 1
nLin     := 0
cArqu2   := cArqu2 + "." + strzero( nPag, 3 )

cGrupIni := strzero( nGrupIni, 6 )
cGrupFin := strzero( nGrupFin, 6 )
cSubgIni := strzero( nSubgIni, 6 )
cSubgFin := strzero( nSubgFin, 6 )
cProdIni := strzero( nProdIni, 6 )
cProdFin := strzero( nProdFin, 6 )
cFornIni := strzero( nFornIni, 6 )
cFornFin := strzero( nFornFin, 6 )
cAdic    := strzero( nAdic, 2 )
cTabe    := strzero( nTabe, 4 )
cGrupAnt := space(06) 
cSubGAnt := space(06)
lInicio  := .t.

select ProdARQ
if xTipo == 'A'
  set order to 3
else  
  set order to 4
endif  
set relation to Grup into GrupARQ, to Grup+SubG into SubGARQ
dbgotop ()
do while !eof ()
  if Prod >= cProdIni .and. Prod <= cProdFin .and. val( SubG ) >= nSubgIni .and. val( SubG ) <= nSubgFin .and. val( Grup ) >= nGrupIni .and. val( Grup ) <= nGrupFin
    if val( Forn ) >= nFornIni .and. val( Forn ) <= nFornFin .and. Refe >= cRefeIni .and. Refe <= cRefeFin
      do case
        case nOpca == 2
          if Qtde > 0 
            dbskip ()
            loop
          endif
        case nOpca == 3
          if Qtde <= 0
            dbskip ()
            loop
          endif
      endcase      

      if lInicio
        set printer to ( cArqu2 )
        set device  to printer
        set printer on

        lInicio := .f.
      endif

      if nLin == 0
        Cabecalho ( 'Tabela de Precos', 80, 2 )
        CabTabG ()
      endif

          if cGrupAnt != Grup
            @ nLin,00 say GrupARQ->Nome + ' - ' + Grup
            cGrupAnt := Grup
            nLin ++
          endif

          if cSubGAnt != SubG
            @ nLin,02 say SubGARQ->Nome + ' - ' + SubG
            cSubGAnt := SubG
            nLin ++
          endif

          @ nLin, 04 say Prod
          @ nLin, 11 say Unid
          @ nLin, 15 say Nome                 pict '@S43'
          @ nLin, 59 say Refe                 pict '@S10'
          if nAdic > 0
            nPrecoVenda := ( ( PrecoVenda * CondARQ->Acrs ) / 100 ) + PrecoVenda

            @ nLin, 70 say nPrecoVenda        pict '@E 9,999.9999'
          else
            @ nLin, 70 say PrecoVenda         pict '@E 9,999.9999'
          endif
      nLin ++

      if nLin >= pLimite
        Rodape(80)

       cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
        cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

        set printer to ( cArqu2 )
        set printer on
      endif
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
    if xTipo == 'A'
      replace Titu     with "Tabela de Preço - Alfabética"
    else
      replace Titu     with "Tabela de Preço - Codigo" 
    endif  
    replace Data       with cRData
    replace Hora       with cRHora
    replace Usua       with cUsuario
    replace Tama       with 80
    replace Empr       with cEmpresa
    dbunlock ()
  endif  
endif

select ProdARQ
close
select GrupARQ
close
select CondARQ
close
select SubGARQ
close
select FornARQ
close
restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabTabG()
  select CondARQ
  set order to 1
  dbseek( cAdic, .f. )
  
  if found()
    @ 02, 01 say 'Adic. Financeiro : ' + left( Nome, 15 ) + transform( Acrs, '999.9' )
  endif

  select ProdARQ

  @ 02, 46 say 'Tabela ' + cTabe
  @ 02, 61 say 'Validade ' + dtoc( dVali )
  
  @ 03, 00 say 'Grupo'
  @ 04, 02 say 'SubGrupo'
  @ 05, 04 say 'Cod Un. Descrição                                     Referˆncia   P. Venda'
   
  nLin    := 7
  cGrupAnt := cSubGAnt := space(03)
return NIL


//
// Consulta da Tabela de Preco
//
function ConsTabP( pTipo )
  local tValGrup := savescreen( 00, 00, 24, 79 )
  local lOk      := .f.
  local GetList  := {}

  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )

    xOpenProd := .t.
  
    #ifdef DBF_NTX
      set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
    #endif
  else  
    xOpenProd := .f.
  endif

  if NetUse( "GrupARQ", .t. )
    VerifIND( "GrupARQ" )
  
    xOpenGrup := .t.

    #ifdef DBF_NTX
      set index to GrupIND1, GrupIND2
    #endif
  else  
    xOpenGrup := .f.
  endif

  if NetUse( "SubGARQ", .t. )
    VerifIND( "SubGARQ" )

    xOpenSubG := .t.
  
    #ifdef DBF_NTX
      set index to SubGIND1, SubGIND2, SubGIND3
    #endif
  else  
    xOpenSubG := .f.
  endif

  select SubgARQ
  set order    to 3 
  set relation to Grup into GrupARQ
  
  select ProdARQ
  set order    to 1
  set relation to Grup into GrupARQ, Grup + SubG into SubGARQ

  select GrupARQ
  set order to 2
  dbgotop()
  
  Janela( 05, 15, 17, 53, mensagem( 'Janela', 'ConsTabP', .f. ), .f. )  

  oGrupo           := TBrowseDB( 07, 16, 15, 52 )
  oGrupo:headsep   := chr(194)+chr(196)
  oGrupo:colsep    := chr(179)
  oGrupo:footsep   := chr(193)+chr(196)
  oGrupo:colorSpec := CorJanel
 
  oGrupo:addColumn( TBColumnNew( 'Cod', {|| Grup } ) )
  oGrupo:addColumn( TBColumnNew( 'Nome', {|| Nome } ) )
  
  oGrupo:colPos  := 2
  lExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ''
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 08, 15, 53, nTotal )

  setcolor ( CorCampo )
  @ 16,26 say space(20)

  setcolor( CorJanel + ',' + CorCampo )
  @ 08,15 say chr(195)
  @ 15,15 say chr(195)
  @ 16,17 say 'Consulta'
    
  do while !lExitRequested
    Mensagem( 'TabP', 'ConsTabP' )

    oGrupo:forcestable() 

    iif( BarraSeta, BarraSeta( nLinBarra, 08, 15, 53, nTotal ), NIL )
       
    if oGrupo:stable
      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oGrupo:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oGrupo:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oGrupo:down()
      case cTecla == K_UP;         oGrupo:up()
      case cTecla == K_PGDN;       oGrupo:pageDown()
      case cTecla == K_PGUP;       oGrupo:pageUp()
      case cTecla == K_CTRL_PGUP;  oGrupo:goTop()
      case cTecla == K_CTRL_PGDN;  oGrupo:goBottom()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_ALT_A;      tAltera := savescreen( 00, 00, 23, 79 )
        Grup (.t.)
        
        cLetra := '' 
        
        restscreen( 00, 00, 23, 79, tAltera )
    
        setcolor ( CorCampo )
        @ 16,26 say space(20)

        select GrupARQ
        set order to 2
        
        oGrupo:refreshAll()
        
      case cTecla == K_INS;        tAltera := savescreen( 00, 00, 23, 79 )
        Grup (.f.)
        
        cLetra := ''

        restscreen( 00, 00, 23, 79, tAltera )
    
        setcolor ( CorCampo )
        @ 16,26 say space(20)
        
        select GrupARQ
        set order to 2

        oGrupo:refreshAll()
      case cTecla == K_ENTER
        gNome := Nome
      
        if EmprARQ->ProdSimp == " "
          if ConsSubG(pTipo)
            lOk            := .t.    
            lExitRequested := .t.
          else  
            lExitRequested := .f.
          endif
        else  
          if ConsProduto( pTipo )
            lOk            := .t.
            lExitRequested := .t.
           else 
            lExitRequested := .f.
          endif  
        endif  

        cLetra := ''
    
        setcolor ( CorCampo )
        @ 16,26 say space(20)
        
        select GrupARQ
        set order to 2
        dbseek( gNome, .f. )
        
        oGrupo:refreshAll()
      case cTecla == K_BS
        cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
    
        setcolor ( CorCampo )
        @ 16,26 say space(20)
        @ 16,26 say cLetra
      case cTecla >= 32 .and. cTecla <= 128
        cLetra += chr( cTecla )    
        
        if len( cLetra ) >= 20
          cLetra := ''
        endif  
     
        setcolor ( CorCampo )
        @ 16,26 say space(20)
        @ 16,26 say cLetra

        dbseek( cLetra, .t. )
        oGrupo:refreshAll()
    endcase
  enddo  

  restscreen( 00, 00, 24, 79, tValGrup )

  lExitRequested := .f.
  
  if xOpenGrup
    select GrupARQ
    close
  endif
  
  if xOpenSubG
    select SubGARQ
    close
  endif  
  
  if xOpenProd
    select ProdARQ
    close
  else 
    select ProdARQ
    set order to 1  
  endif  
return(lOk)

//
// Abre uma janela com os Sub-Grupos Cadastrados
//
function ConsSubG( pTipo )
  tValSubG  := savescreen( 00, 00, 24, 79 )
  lOk       := .f.
  vGrup     := GrupARQ->Grup

  select SubgARQ
  set order to 3

  Janela( 06, 20, 18, 58, mensagem( 'Janela', 'ConsSubG', .f. ), .f. )  

  bFirst := {|| dbseek( vGrup, .t. ) }
  bLast  := {|| dbseek( vGrup, .t. ), dbskip(-1) }
  bFor   := {|| Grup == vGrup } 
  bWhile := {|| Grup == vGrup }

  oSubGo           := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oSubGo:nTop      := 08
  oSubGo:nLeft     := 21
  oSubGo:nBottom   := 16
  oSubGo:nRight    := 57
  oSubGo:headsep   := chr(194)+chr(196)
  oSubGo:colsep    := chr(179)
  oSubGo:footsep   := chr(193)+chr(196)
  oSubGo:colorSpec := CorJanel

  oSubGo:addColumn( TBColumnNew( 'Cod', {|| SubG } ) )
  oSubGo:addColumn( TBColumnNew( 'Nome', {|| Nome } ) )
  
  oSubGo:colPos  := 2 
  lExitRequested := .f.
  nLinBarra      := 1
  cLetra         := '' 
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 09, 16, 58, nTotal )

  oSubGo:goTop ()
  
  setcolor ( CorCampo )
  @ 17,31 say space(20)

  setcolor( CorJanel + ',' + CorCampo )
  @ 09,20 say chr(195)
  @ 16,20 say chr(195)
  @ 17,22 say 'Consulta'
    
  do while !lExitRequested
    Mensagem( 'TabP', 'ConsTabP' )

    oSubGo:forcestable() 

    iif( BarraSeta, BarraSeta( nLinBarra, 08, 16, 58, nTotal ), NIL )
 
    if oSubGo:stable
      cTecla := Teclar(0)
    endif
         
    do case
      case cTecla == K_DOWN 
        if !oSubGo:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oSubGo:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oSubGo:down()
      case cTecla == K_UP;         oSubGo:up()
      case cTecla == K_PGDN;       oSubGo:pageDown()
      case cTecla == K_PGUP;       oSubGo:pageUp()
      case cTecla == K_CTRL_PGUP;  oSubGo:goTop()
      case cTecla == K_CTRL_PGDN;  oSubGo:goBottom()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_ALT_A;      tAltera        := savescreen( 00, 00, 23, 79 )
        sNome := Nome
      
        SubG (.t., val( vGrup ) )
        
        restscreen( 00, 00, 23, 79, tAltera )

        cLetra         := ''
        lExitRequested := .f.
      
        setcolor ( CorCampo )
        @ 17,31 say space(20)
  
        select SubGARQ
        set order to 3
        dbseek( vGrup + sNome, .t. )
                
        oSubGo:refreshAll()
      case cTecla == K_INS;      tAltera := savescreen( 00, 00, 23, 79 )
        SubG (.f., val ( vGrup ) )
        
        restscreen( 00, 00, 23, 79, tAltera )

        cLetra         := ''
        lExitRequested := .f.
     
        setcolor ( CorCampo )
        @ 17,31 say space(20)
  
        select SubGARQ
        set order to 3
        dbseek( vGrup, .t. )

        oSubGo:refreshAll()
      case cTecla == K_ENTER
        sNome := Nome
      
        if ConsProduto( pTipo )
          lOk            := .t.
          lExitRequested := .t.
         else 
          lExitRequested := .f.
        endif  
     
        cLetra := ''

        setcolor ( CorCampo )
        @ 17,31 say space(20)
  
        select SubGARQ
        set order to 3
        dbseek( vGrup + sNome, .t. )
        
        oSubGo:refreshAll()
      case cTecla == K_BS
        cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
    
        setcolor ( CorCampo )
        @ 17,31 say space(20)
        @ 17,31 say cLetra
      case cTecla >= 32 .and. cTecla <= 128
        cLetra += chr( cTecla )    
        
        if len( cLetra ) > 20
          cLetra := ''
        endif  
     
        setcolor ( CorCampo )
        @ 17,31 say space(20)
        @ 17,31 say cLetra
        
        dbseek( vGrup + cLetra, .t. )
        oSubGo:refreshAll()
    endcase
  enddo  

  restscreen( 00, 00, 24, 79, tValSubG )

  lExitRequested := .f.
return(lOk)

//
// Mostra os Produtos
//
function ConsProduto( pTipo )
  local cCorAtual := setcolor()
  local GetList   := {}
  local tTela     := savescreen( 00, 00, 23, 79 )
  
  vGrup     := SubGARQ->Grup
  vSubG     := SubGARQ->SubG
  
  Janela ( 03, 02, 21, 75, mensagem( 'Janela', 'ConsProduto', .f. ), .f. )

  select ProdARQ
  set order to 3

  if EmprARQ->ProdSimp == "X"
    vGrup   := GrupARQ->Grup
    vSubG   := "000" 
  endif

  bFirst              := {|| dbseek( vGrup + vSubG, .t. ) }
  bLast               := {|| dbseek( vGrup + vSubG, .t. ), dbskip(-1) }
  bFor                := {|| Grup == vGrup .and. SubG == vSubG } 
  bWhile              := {|| Grup == vGrup .and. SubG == vSubG }
    
  oProdutos           := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oProdutos:nTop      := 05
  oProdutos:nLeft     := 03
  oProdutos:nBottom   := 19
  oProdutos:nRight    := 74
  oProdutos:headsep   := chr(194)+chr(196)
  oProdutos:colsep    := chr(179)
  oProdutos:footsep   := chr(193)+chr(196)
  oProdutos:colorSpec := CorJanel

  do case
    case EmprARQ->ConsProd == 2
      oProdutos:addColumn( TBColumnNew("Código" , {|| Prod } ) )
      oProdutos:addColumn( TBColumnNew("Nome", {|| left( Nome, 39 ) } ) )
    case EmprARQ->ConsProd == 5
      oProdutos:addColumn( TBColumnNew("Referência", {|| left( Refe, 12 ) } ) )
      oProdutos:addColumn( TBColumnNew("Nome", {|| left( Nome, 31 ) } ) )
    case EmprARQ->ConsProd == 6
      oProdutos:addColumn( TBColumnNew("CodBarra", {|| left( CodFab, 12 ) } ) )
      oProdutos:addColumn( TBColumnNew("Nome", {|| left( Nome, 31 ) } ) )
  endcase

  if pTipo == 'enot' .or. pTipo == 'epro' .or. pTipo == 'tbpr'
    oProdutos:addColumn( TBColumnNew( '  P. Custo', {|| transform( PrecoCusto, '@E 9,999.9999' ) } ) )
  else 
    oProdutos:addColumn( TBColumnNew( '  P. Venda', {|| transform( PrecoVenda, '@E 9,999.9999' ) } ) )
  endif  
  oProdutos:addColumn( TBColumnNew("Un.", {|| Unid } ) )
  if EmprARQ->Inteira == "X" 
    oProdutos:addColumn( TBColumnNew("Qtde.", {|| transform( Qtde, '@E 9999999999' ) } ) )
  else  
    oProdutos:addColumn( TBColumnNew("Qtde.", {|| transform( Qtde, '@E 9999,999.9' ) } ) )
  endif  
  if EmprARQ->PrecoProd == "X"
    if !empty( EmprARQ->Preco1 )
      cCalc := alltrim( EmprARQ->Preco1 )
    
      oProdutos:addColumn( TBColumnNew( EmprARQ->Cabec1, {|| transform( (&cCalc), '@E 9,999.9999' ) } ) )
    endif  
    if !empty( EmprARQ->Preco2 )
      cCalc := alltrim( EmprARQ->Preco2 )
    
      oProdutos:addColumn( TBColumnNew( EmprARQ->Cabec2, {|| transform( (&cCalc), '@E 9,999.9999' ) } ) )
    endif  
    if !empty( EmprARQ->Preco3 )
      cCalc := alltrim( EmprARQ->Preco3 )
    
      oProdutos:addColumn( TBColumnNew( EmprARQ->Cabec3, {|| transform( (&cCalc), '@E 9,999.9999' ) } ) )
    endif  
    if !empty( EmprARQ->Preco4 )
      cCalc := alltrim( EmprARQ->Preco4 )
    
      oProdutos:addColumn( TBColumnNew( EmprARQ->Cabec4, {|| transform( (&cCalc), '@E 9,999.9999' ) } ) )
    endif  
    if !empty( EmprARQ->Preco5 )
      cCalc := alltrim( EmprARQ->Preco5 )
    
      oProdutos:addColumn( TBColumnNew( EmprARQ->Cabec5, {|| transform( (&cCalc), '@E 9,999.9999' ) } ) )
    endif  
  endif  
  if EmprARQ->ConsMedia == "X"
    nMes := month( date() ) - 1
  
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

    if EmprARQ->Inteira == "X"
      oProdutos:addColumn( TBColumnNew( strzero( month( dMes01Ini ), 2 ) + "/" + alltrim(str(year(dMes01Ini))), {|| transform( Vend01, '@E 9999999999' ) } ) )
      oProdutos:addColumn( TBColumnNew( strzero( month( dMes02Ini ), 2 ) + "/" + alltrim(str(year(dMes02Ini))), {|| transform( Vend02, '@E 9999999999' ) } ) )
      oProdutos:addColumn( TBColumnNew( strzero( month( dMes03Ini ), 2 ) + "/" + alltrim(str(year(dMes03Ini))), {|| transform( Vend03, '@E 9999999999' ) } ) )
      oProdutos:addColumn( TBColumnNew( "Media", {|| transform( ( Vend01 + Vend02 + Vend03 ) / 3, '@E 9999999999' ) } ) )
    else  
      oProdutos:addColumn( TBColumnNew( strzero( month( dMes01Ini ), 2 ) + "/" + alltrim(str(year(dMes01Ini))), {|| transform( Vend01, '@E 9,999.9999' ) } ) )
      oProdutos:addColumn( TBColumnNew( strzero( month( dMes02Ini ), 2 ) + "/" + alltrim(str(year(dMes02Ini))), {|| transform( Vend02, '@E 9,999.9999' ) } ) )
      oProdutos:addColumn( TBColumnNew( strzero( month( dMes03Ini ), 2 ) + "/" + alltrim(str(year(dMes03Ini))), {|| transform( Vend03, '@E 9,999.9999' ) } ) )
      oProdutos:addColumn( TBColumnNew( "Media", {|| transform( (Vend01+Vend02+Vend03)/3, '@E 9,999.9999' ) } ) )
    endif  
  
    select ProdARQ         
    set order to 2
    dbgotop()
  endif

  oProdutos:addColumn( TBColumnNew("Referˆncia", {|| Refe } ) )
            
  oProdutos:goTop ()
  oProdutos:refreshAll()
             
  do case
    case EmprARQ->ConsProd == 2
      oProdutos:colPos := 2
    case EmprARQ->ConsProd == 5
      oProdutos:colPos := 1
    case EmprARQ->ConsProd == 6
      oProdutos:colPos := 1
  endcase
  
  lAdiciona      := .f.
  lMais          := .t.
  lExitRequested := .f.
  nLinBarra      := 1
  nTotal         := lastrec()
  cLetra         := ''
  BarraSeta      := BarraSeta( nLinBarra, 6, 19, 75, nTotal )
  
  setcolor ( CorCampo )
  @ 20,14 say space(40)
    
  setcolor( CorJanel + ',' + CorCampo )
  @ 06,02 say chr(195)
  @ 19,02 say chr(195)
  @ 20,05 say 'Consulta'

  do while !lExitRequested
    Mensagem( 'TabP', 'ConsProduto' )

    oProdutos:forcestable() 

    iif( BarraSeta, BarraSeta( nLinBarra, 6, 19, 75, nTotal ), NIL )

    if oProdutos:stable
      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oProdutos:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oProdutos:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oProdutos:down()
      case cTecla == K_UP;         oProdutos:up()
      case cTecla == K_PGDN;       oProdutos:pageDown()
      case cTecla == K_PGUP;       oProdutos:pageUp()
      case cTecla == K_CTRL_PGUP;  oProdutos:goTop()
      case cTecla == K_CTRL_PGDN;  oProdutos:gobottom()
      case cTecla == K_CTRL_END;   oProdutos:panEnd()
      case cTecla == K_RIGHT;      oProdutos:right()
      case cTecla == K_LEFT;       oProdutos:left()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_ENTER
        lOK            := .t.
        lExitRequested := .t.
      case cTecla == K_ALT_U;       ExibForn()
      case cTecla == K_ALT_O;       ExibCota()
      case cTecla == K_ALT_P;       ExibCond()
      case cTecla == K_ALT_R;       Reajuste()
      case cTecla == K_F1
        tAjuda := savescreen( 00, 00, 23, 79 )
        
        Janela( 06, 18, 16, 59, mensagem( 'Janela', 'ConsProduto1', .f. ) )
        setcolor( CorJanel )
        @ 08,20 say ' Alt+U Ultimos Fornecedores'
        @ 09,20 say ' Alt+O Cotação de Preços'
        @ 10,20 say ' Alt+P Condiç”es de Pagamento'
        @ 11,20 say ' Alt+R Reajuste de Preços'
        @ 12,20 say ' Alt+H Histórico'
        @ 13,20 say ' Alt+M Recalcula a Media' 
        @ 14,20 say 'Insert Incluir com Codigo Autom tico'
        @ 15,20 say ' Alt+A Alterar Produto'
        Teclar(0)
        restscreen( 00, 00, 23, 79, tAjuda )
      case cTecla == K_ALT_A;       Prod (.t.)
        cLetra         := ''  
        lExitRequested := .f.   

        setcolor ( CorCampo )
        @ 20,14 say space(40)

        select ProdARQ
        set order to 3
        if Grup != vGrup
          dbseek( vGrup, .t. )
        endif  
        
        oProdutos:refreshAll()
      case cTecla == K_INS;        Prod (.f.)
        cLetra         := ''  
        lExitRequested := .f.   

        setcolor ( CorCampo )
        @ 20,14 say space(40)

        select ProdARQ
        set order to 3
        if Grup != vGrup
          dbseek( vGrup, .t. )
        endif  

        oProdutos:refreshAll()
      case cTecla == K_ALT_H  
        tEntrHist := savescreen( 00, 00, 23, 79 )

        Janela( 03, 13, 13, 67, mensagem( 'Janela', 'ConsProduto1', .f. ), .f. )
        Mensagem( 'TabP', 'ConsProduto1' )
         
        setcolor( CorCampo )     
        cHist := memoedit( Hist, 05, 15, 12, 65, .t., 'PassHist' )
        
        if lastkey() == K_CTRL_W
          if RegLock()
            replace Hist     with cHist
            dbunlock ()
          endif
        endif
    
        restscreen( 00, 00, 23, 79, tEntrHist )
      case cTecla == K_BS
        cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
      
        setcolor ( CorCampo )
        @ 20,14 say space(40)
        @ 20,14 say cLetra
      case cTecla >= 32 .and. cTecla <= 128
        do case
          case oProdutos:ColPos == 1   
            set order to 1
          case oProdutos:ColPos == 2  
            set order to 3
          otherwise  
            set order to 3
        endcase

        cLetra += chr( cTecla )    

        if len( cLetra ) > 40
          cLetra := ''
        endif  
     
        setcolor ( CorCampo )
        @ 20,14 say space(40)
        @ 20,14 say cLetra

        dbseek( vGrup + vSubG + cLetra, .t. )       

        oProdutos:refreshAll()
    endcase
  enddo  
  
  lExitRequested := .f.  
        
  restscreen( 00, 00, 23, 79, tTela )
return(lOk)