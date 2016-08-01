//  Leve, Alteracao de Preco
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

function AltP ()

if NetUse( "GrupARQ", .t. )
  VerifIND( "GrupARQ" )
  
  kOpenGrup := .t.
 
  #ifdef DBF_NTX
    set index to GrupIND1, GrupIND2
  #endif  
else  
  kOpenGrup := .f.
endif

if NetUse( "SubGARQ", .t. )
  VerifIND( "SubGARQ" ) 

  kOpenSubG := .t.
  
  #ifdef DBF_NTX
    set index to SubGIND1, SubGIND2, SubGIND3
  #endif  
else  
  kOpenSubG := .f.
endif

if NetUse( "ProdARQ", .t. )
  VerifIND( "ProdARQ" )

  kOpenProd := .t.
  
  #ifdef DBF_NTX
    set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
  #endif  
else  
  kOpenProd := .f.
endif

if NetUse( "FornARQ", .t. )
  VerifIND( "FornARQ" )

  kOpenForn := .t.
  
  #ifdef DBF_NTX
    set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
  #endif
else  
  kOpenForn := .f.
endif

//  Define Intervalo
Janela ( 06, 08, 15, 70, mensagem( 'Janela', 'AltP', .f. ), .f. )
Mensagem ( 'AltP','Janela')

setcolor ( CorJanel + ',' + CorCampo )
@ 08,10 say '               Produto Inicial           Produto Final'
@ 09,10 say '            Fornecedor Inicial        Fornecedor Final'
@ 10,10 say '                 Grupo Inicial             Grupo Final'
@ 11,10 say '              Subgrupo Inicial          Subgrupo Final'

@ 13,10 say 'Percentual para Preço de Custo        %  Tipo'
@ 14,10 say 'Percentual para Preço de Venda        %  Tipo'

setcolor ( 'n/w+' )
@ 13,68 say chr(25)
@ 14,68 say chr(25)

tAltP := savescreen( 00, 00, 23, 79 )

do while .t.
  setcolor ( CorJanel + ',' + CorCampo )
  restscreen( 00, 00, 23, 79, tAltP )

  select FornARQ
  set order to 1
  dbgotop ()
  nFornIni := val( Forn )
  dbgobottom ()
  nFornFin := val( Forn )

  select GrupARQ
  set order to 1
  dbgotop ()
  nGrupIni := val( Grup )
  dbgobottom ()
  nGrupFin := val( Grup )

  select ProdARQ
  set order to 1
  dbgotop ()
  nProdIni := val( Prod )
  dbgobottom ()
  nProdFin := val( Prod )
  
  cProd     := space(06)  
  nSubgIni  := 001
  nSubgFin  := 999
  nPercCust := 0
  nPercVend := 0
  cAjuda    := 'Altp'
  aCusto    := {}
  aVenda    := {}
  nTipoVend := 1
  nTipoCust := 1

  aadd( aCusto, { ' Acréscimo ', 2, 'A', 13, 56, "Define o percentual de acréscimo em cima do preço de custo." } )
  aadd( aCusto, { ' Desconto  ', 2, 'D', 13, 56, "Define o percentual de desconto em cima do preço de custo." } )
  aadd( aVenda, { ' Acréscimo ', 2, 'A', 14, 56, "Define o percentual de acréscimo em cima do preço de venda." } )
  aadd( aVenda, { ' Desconto  ', 2, 'D', 14, 56, "Define o percentual de desconto em cima do preço de venda." } )
    
  setcolor( CorCampo )
  @ 13,56 say ' Acr‚scimo '  
  @ 14,56 say ' Acr‚scimo '  
  @ 14,41 say nPercVend      pict '@E 999.99'
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,41 get nProdIni       pict '999999'       valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdIni" ) 
  @ 08,65 get nProdFin       pict '999999'       valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdFin" ) .and. nProdFin >= nProdIni
  @ 09,41 get nFornIni       pict '999999'       valid ValidForn( 99, 99, "ProdARQ", "nFornIni" )       
  @ 09,65 get nFornFin       pict '999999'       valid ValidForn( 99, 99, "ProdARQ", "nFornFin" ) .and. nFornFin >= nFornIni
  @ 10,41 get nGrupIni       pict '999999'       valid ValidARQ( 99, 99, "ProdARQ", "Código" , "Grup", "Descrição", "Nome", "Grup", "nGrupIni", .t., 6, "Consulta de Grupos", "GrupARQ", 30 )
  @ 10,65 get nGrupFin       pict '999999'       valid ValidARQ( 99, 99, "ProdARQ", "Código" , "Grup", "Descrição", "Nome", "Grup", "nGrupFin", .t., 6, "Consulta de Grupos", "GrupARQ", 30 ) .and. nGrupFin >= nGrupIni
  @ 11,41 get nSubgIni       pict '999999'
  @ 11,65 get nSubgFin       pict '999999'       valid nSubgFin >= nSubgIni
  @ 13,41 get nPercCust      pict '@E 999.99'
  read

  if lastkey() == K_ESC
    exit
  endif

  nTipoCust := HCHOICE( aCusto, 2, 1 )
    
  @ 14,41 get nPercVend      pict '@E 999.99'
  read

  if lastkey() == K_ESC
    exit
  endif

  nTipoVend := HCHOICE( aVenda, 2, 1 )

  if lastkey() == K_ESC
    exit
  endif

  if !ConfAlte()
    loop
  endif
  
  cProdIni := strzero( nProdIni, 6 )
  cProdFin := strzero( nProdFin, 6 )
  cFornIni := strzero( nFornIni, 6 )
  cFornFin := strzero( nFornFin, 6 )
  cGrupIni := strzero( nGrupIni, 6 )
  cGrupFin := strzero( nGrupFin, 6 )
  cSubGIni := strzero( nSubGIni, 6 )
  cSubGFin := strzero( nSubGFin, 6 )
  tPreco   := savescreen( 00, 00, 23, 79 )  

  Janela( 09, 15, 14, 65, mensagem( 'Janela', 'AltP1', .f. ), .f. )
  Mensagem ('AltP', 'Altera' )
  setcolor( CorJanel + ',' + CorCampo )
  @ 11,17 say '   Produtos'
  @ 13,17 say 'Preço Custo              Preço Venda '
  setcolor( CorCampo )

  select ProdARQ
  set order to 1 
  dbseek( cProdIni, .t. )
  do while Prod >= cProdIni .and. Prod <= cProdFin .and. !eof()
    if Forn >= cFornIni .and. Forn <= cFornFin .and.;
      SubG >= cSubgIni .and. SubG <= cSubgFin .and.;
      Grup >= cGrupIni .and. Grup <= cGrupFin 
  
      if nTipoCust == 1
        cPrecoCusto := PrecoCusto + ( PrecoCusto * nPercCust / 100 )
      else  
        cPrecoCusto := PrecoCusto - ( PrecoCusto * nPercCust / 100 )
      endif  

      if nTipoVend == 1
        cPrecoVenda := PrecoVenda + ( PrecoVenda * nPercVend / 100 )
      else  
        cPrecoVenda := PrecoVenda - ( PrecoVenda * nPercVend / 100 )
      endif  
      
      if cPrecoCusto > 0
        nLucro := ( ( cPrecoVenda / cPrecoCusto ) - 1 ) * 100
      endif  
    
      @ 11,29 say Prod              pict '999999'
      @ 11,36 say Nome              pict '@S30'
      @ 13,29 say cPrecoCusto       pict PictPreco(10)
      @ 13,54 say cPrecoVenda       pict PictPreco(10)
    
      if RegLock()
        replace PrecoCusto  with cPrecoCusto
        replace PrecoVenda  with cPrecoVenda
        replace UltA        with date()
        dbunlock ()
      endif
    endif  
    dbskip ()
  enddo
  
  restscreen( 00, 00, 23, 79, tPreco )
enddo

if kOpenForn
  select FornARQ
  close
endif  
if kOpenProd
  select ProdARQ
  close
endif  
if kOpenGrup
  select GrupARQ
  close
endif  
if kOpenSubG
  select SubGARQ
  close
endif  

return NIL

//
// Fluxo de Caixa
//
function PrinFlux ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )
    
    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
    #endif  
  endif

  if NetUse( "FornARQ", .t. )
    VerifIND( "FornARQ" )
  
    #ifdef DBF_NTX
      set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
    #endif  
  endif

  if NetUse( "ReceARQ", .t. )
    VerifIND( "ReceARQ" )
  
    #ifdef DBF_NTX
      set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
    #endif  
  endif

  if NetUse( "PagaARQ", .t. )
    VerifIND( "PagaARQ" )
  
    #ifdef DBF_NTX
      set index to PagaIND1, PagaIND2, PagaIND3, PagaIND4, PagaIND5, PagaIND6
    #endif  
  endif

  if NetUse( "PortARQ", .t. )
    VerifIND( "PortARQ" )
  
    #ifdef DBF_NTX
      set index to PortIND1, PortIND2 
    #endif  
  endif

  tPrt  := savescreen( 00, 00, 23, 79 )

  Janela ( 04, 12, 11, 70, mensagem( 'Janela', 'PrinFlux', .f. ), .f.)
  Mensagem( 'AltP','PrinFlux')

  setcolor ( CorJanel + ',' + CorCampo )
  @ 06,14 say '   Emissão Inicial             Emissão Final'
  @ 07,14 say '     Vcto. Inicial               Vcto. Final'
  @ 08,14 say '   Cliente Inicial             Cliente Final'
  @ 09,14 say 'Fornecedor Inicial          Fornecedor Final'
  @ 10,14 say '  Portador Inicial            Portador Final'

  select ClieARQ
  set order to 1
  dbgotop()
  nClieIni := val( Clie )
  nClieFin := 999999

  select FornARQ
  set order to 1
  dbgotop()
  nFornIni := val( Forn )
  dbgobottom()
  nFornFin := val( Forn )

  select PortARQ
  set order to 1
  nPortIni := 0
  dbgobottom()
  nPortFin := val( Port )
 
  dVctoIni := ctod('01/01/1990')
  dVctoFin := ctod('31/12/2015')
  dEmisIni := ctod('01/01/1990')
  dEmisFin := ctod('31/12/2015')

  setcolor ( CorJanel + ',' + CorCampo )
  @ 06,33 get dEmisIni           pict '99/99/9999'
  @ 06,59 get dEmisFin           pict '99/99/9999' valid dEmisFin >= dEmisIni
  @ 07,33 get dVctoIni           pict '99/99/9999'
  @ 07,59 get dVctoFin           pict '99/99/9999' valid dVctoFin >= dVctoIni
  @ 08,33 get nClieIni           pict '999999'     valid ValidClie( 99, 99, "ReceARQ", "nClieIni" )
  @ 08,59 get nClieFin           pict '999999'     valid ValidClie( 99, 99, "ReceARQ", "nClieFin" ) .and. nClieFin >= nClieIni 
  @ 09,33 get nFornIni           pict '999999'     valid ValidForn( 99, 99, "ReceARQ", "nFornIni" )       
  @ 09,59 get nFornFin           pict '999999'     valid ValidForn( 99, 99, "ReceARQ", "nFornFin" ) .and. nFornFin >= nFornIni
  @ 10,33 get nPortIni           pict '999999'     valid nPortIni == 0 .or. ValidARQ( 99, 99, "ReceARQ", "Código" , "Port", "Descrição", "Nome", "Port", "nPortIni", .t., 6, "Consulta de Portadores", "PortARQ", 40 )
  @ 10,59 get nPortFin           pict '999999'     valid nPortFin == 0 .or. ValidARQ( 99, 99, "ReceARQ", "Código" , "Port", "Descrição", "Nome", "Port", "nPortFin", .t., 6, "Consulta de Portadores", "PortARQ", 40 ) .and. nPortFin >= nPortIni
  read

  if lastkey() == K_ESC
    select FornARQ
    close
    select ClieARQ
    close
    select PortARQ
    close
    select ReceARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  
  Aguarde ()

  nPag   := 1
  nLin   := 0
  cArqu2 := cArqu2 + "." + strzero( nPag, 3 )
  lInicio := .t.
  
  nTotalPagar := 0
  nTotalReceb := 0
  aDias       := {}
      
  select PagaARQ 
  set order to 1
  dbgotop()
  do while !eof()
    if Emis >= dEmisIni        .and. Emis        <= dEmisFin .and.;
       Vcto >= dVctoIni        .and. Vcto        <= dVctoFin .and.;
       val( Port ) >= nPortIni .and. val( Port ) <= nPortFin .and.;
       val( Forn ) >= nFornIni .and. val( Forn ) <= nFornFin
       
      nTotalPagar += ( Valor - Desc )
    
      nElem := ascan( aDias, { |nElem| nElem[1] == Vcto } )
      
      if nElem > 0
        aDias[ nElem, 3 ] += ( Valor - Desc )
      else  
        aadd( aDias, { Vcto, 0, ( Valor - Desc ) } )
      endif  
    endif 
    
    dbskip ()
  enddo
      
  select ReceARQ 
  set order to 1
  dbgotop()
  do while !eof()
    if Emis >= dEmisIni        .and. Emis        <= dEmisFin .and.;
      Vcto >= dVctoIni        .and. Vcto        <= dVctoFin .and.;
      val( Port ) >= nPortIni .and. val( Port ) <= nPortFin .and.;
      val( Clie ) >= nClieIni .and. val( Clie ) <= nClieFin

      nTotalReceb += ( Valor - Desc )
    
      nElem := ascan( aDias, { |nElem| nElem[1] == Vcto } )
       
      if nElem > 0
        aDias[ nElem, 2 ] += ( Valor - Desc )
      else  
        aadd( aDias, { Vcto, ( Valor - Desc ), 0 } )
      endif  
    endif  

    dbskip ()
  enddo
  
  asort( aDias,,, { | Dia01, Dia02 | Dia01[1] < Dia02[1] } )
 
  if len( aDias ) > 0
    nLen := len( aDias ) 

    for nI := 1 to nLen
      dVcto := aDias[ nI, 1 ]
      nRece := aDias[ nI, 2 ]
      nPaga := aDias[ nI, 3 ]
      
      if nPaga == 0
        nPercPaga := 0
      else  
        nPercPaga := ( nPaga * 100 ) / nTotalPagar
      endif  
      
      if nRece == 0
        nPercRece := 0
      else  
        nPercRece := ( nRece * 100 ) / nTotalReceb
      endif  
      
      if lInicio       
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
          
        lInicio := .f.
      endif  

      if nLin == 0
        Cabecalho ( 'Fluxo de Caixa', 80, 4 )
        CabFlux ()
      endif
      
      @ nLin,01 say dVcto            pict '99/99/9999'
      @ nLin,11 say nRece            pict '@E 999,999.99'
      @ nLin,22 say nPercRece        pict '@E 999.99'
      @ nLin,32 say nPaga            pict '@E 999,999.99'
      @ nLin,43 say nPercPaga        pict '@E 999.99'
      nLin ++
      
      if nLin >= pLimite
        Rodape(80)

        cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
        cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

        set printer to ( cArqu2 )
        set printer on
      endif
    next
  endif
  
  if !lInicio
    nLin ++
    @ nLin,04 say 'Total'
    @ nLin,11 say nTotalReceb      pict '@E 999,999.99'
    @ nLin,22 say 100              pict '@E 999.99'
    @ nLin,32 say nTotalPagar      pict '@E 999,999.99'
    @ nLin,43 say 100              pict '@E 999.99'
    nLin += 2
    @ nLin,04 say 'Saldo'
    
    nSaldo := ( nTotalReceb - nTotalPagar )
    
    if nSaldo < 0
      @ nLin,28 say nSaldo      pict '@EN(999,999.99)'
    else
      @ nLin,11 say nSaldo      pict '@E 999,999.99'
    endif
    
    Rodape(80)
  endif 
  
  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 80 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with 'Relatório do Fluxo de Caixa'
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
  endif  
  
  select ReceARQ
  close
  select PagaARQ
  close
  select FornARQ
  close
  select ClieARQ
  close
  select PortARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabFlux ()
  @ 02,01 say 'Emissão ' + dtoc( dEmisIni ) + ' a ' + dtoc( dEmisFin )
  @ 02,40 say 'Vcto. ' + dtoc( dVctoIni ) + ' a ' + dtoc( dVctoFin )
  @ 03,01 say 'Vcto.        Crédito      %        Débito      %'

  nLin := 05
return NIL