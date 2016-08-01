//  Leve, Consulta Geral
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
#include "common.ch"

#ifdef RDD_ADS
  #include "ads.ch" 
#endif
                                                              // Consulta Geral
function ConsGeral()
  tCons     := savescreen( 00, 00, 23, 79 )
  aPullCons := {} 
  xAlias    := alias ()
  xOrdem    := dbrselect () 
  xCor      := setcolor ()
  
  sombra( 07, 26, 15, 53 )
  
  setcolor ( CorMenus )
  @ 06, 26 clear to 15, 53
  @ 06, 26 to 15, 53 
  
  setcolor ( CorCabec )
  @ 06,26 say space(28)
  @ 06,35 say 'Consultas'
    
  //  Carrega Matriz aPullCons - Item, AltKey, Linha, Coluna
  aadd  ( aPullCons, { " Produtos                 ",  2, 'P', 08, 27, mensagem( "Cons", "ConsGeral1" ) } ) 
  aadd  ( aPullCons, { " Clientes                 ",  2, 'C', 09, 27, mensagem( "Cons", "ConsGeral2" ) } ) 
  aadd  ( aPullCons, { " Fornecedores             ",  2, 'F', 10, 27, mensagem( "Cons", "ConsGeral3" ) } ) 
  aadd  ( aPullCons, { " Transportadora           ",  2, 'T', 11, 27, mensagem( "Cons", "ConsGeral4" ) } ) 
  aadd  ( aPullCons, { " Contas a Receber         ", 11, 'R', 12, 27, mensagem( "Cons", "ConsGeral5" ) } ) 
  aadd  ( aPullCons, { " Contas a Pagar           ", 13, 'G', 13, 27, mensagem( "Cons", "ConsGeral6" ) } ) 
  aadd  ( aPullCons, { " Agenda                   ",  4, 'E', 14, 27, mensagem( "Cons", "ConsGeral7" ) } ) 

  nPullCons := 1
 
  set key K_F2  to

  do while .t.
    nPullCons := VCHOICE( aPullCons, 7, nPullCons )
    tConsulta := savescreen( 00, 00, 23, 79 )

    do case
      case nPullCons == 1
        do case
          case EmprARQ->ConsProd == 1 .or. EmprARQ->ConsProd == 3 .or. EmprARQ->ConsProd == 4
            ConsProd (,.f.)
          case EmprARQ->ConsProd == 2 .or. EmprARQ->ConsProd == 5 .or. EmprARQ->ConsProd == 6
            ConsTabp (,.f.)
        endcase    
      case nPullCons == 2
        ConsClie (.f.)   
      case nPullCons == 3
        ConsForn (.f.)   
      case nPullCons == 4
        ConsTran (.f.)   
      case nPullCons == 5
        ConsReceber ()
      case nPullCons == 6 
        ConsPagar ()   
      case nPullCons == 7
        ConsAgen ()   
      otherwise
        exit  
     endcase
     
     restscreen( 00, 00, 23, 79, tConsulta )
   enddo  
   
  restscreen( 00, 00, 23, 79, tCons )

  set key K_F2     to ConsGeral ()

  select( xAlias )
  set order to xOrdem
  
  setcolor( xCor )
return NIL

//
// Imprimir Historico
// 
function PassHist( )
  do case 
    case lastkey() == K_CTRL_RET; keyboard(chr(K_CTRL_W))
    case lastkey() == K_ALT_P
      if !TestPrint(1)
        return NIL
      endif
  
      setprc( 0, 0 )
  
      nLin  := 0
      cData := alltrim( EmprARQ->Cida ) + '(' + EmprARQ->UF + '), ' + strzero( day( date() ), 2 ) +;
               ' de ' + alltrim( aMesExt[ month( date() ) ] ) + ' de' + str( year( date() ) )

      @ nLin,00 say chr(27) + "@"
      @ nLin,00 say chr(18)
      @ nLin,00 say chr(27) + chr(67) + chr(33)
      @ nLin,01 say '+-----------------------------------------------------------------------------+'
      nLin ++
      @ nLin,01 say '|' 
      @ nLin,03 say EmprARQ->Razao
      @ nLin,59 say 'Fone ' + EmprARQ->Fone + ' |'
      nLin ++
      @ nLin,01 say '|' 
      @ nLin,03 say EmprARQ->Ende
      @ nLin,60 say 'Fax ' + EmprARQ->Fax + ' |'
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
      @ nLin,01 say '|    Produto ' + Nome
      @ nLin,79 say '|'
      nLin ++
      @ nLin,01 say '|  Descrição '
         
      cQtLin := mlcount( Hist, 50 )
      nItens := 0
      lVez   := .t.

      for nK := 1 to cQtLin
        cLinha := memoline( Hist, 50, nK )
        if lVez 
          lVez := .f.     
        else
          @ nLin,01 say '|'
        endif  
        @ nLin,14 say cLinha
        @ nLin,79 say '|'   
        nLin   ++  
        nItens ++
      next   
      
      if nItens < 10
        for nY := 1 to ( 10 - nItens )
          @ nLin,01 say '|'     
          @ nLin,79 say '|'     
          nLin ++
        next  
      endif
      
      @ nLin,01 say '+-----------------------------------------------------------------------------+'
      nLin ++
      @ nLin,01 say '| Observação _________________________________________________________________|'
      nLin ++
      @ nLin,01 say '|            _________________________________________________________________|'
      nLin ++
      @ nLin,01 say '|            _________________________________________________________________|'
      nLin ++
      @ nLin,01 say '|            _________________________________________________________________|'
      nLin ++
      @ nLin,01 say '|            _________________________________________________________________|'
      nLin ++
      @ nLin,01 say '|                                                                             |'
      nLin ++
      @ nLin,01 say '|                                                                             |'
      nLin ++
      @ nLin,01 say '|                                             _____________________________   |'
      nLin ++
      @ nLin,01 say '| ' + cData
      @ nLin,47 say EmprARQ->Razao       pict '@S30'
      @ nLin,79 say '|'
      nLin ++  
      @ nLin,01 say '+-----------------------------------------------------------------------------+'
      nLin += 6
      @ nLin,00 say chr(27) + "@"

      set device to screen
  endcase 
return(.t.)  

//
// Mostra os Produtos
//
function ConsProd( pTipo, xlPara )
  local GetList   := {}
  local cCorAtual := setcolor()
  local tConsProd := savescreen( 00, 00, 24, 79 )
  local lOpenProd := .t.

  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )

    #ifdef DBF_NTX
      set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
    #endif  
  else  
    lOpenProd := .f.
    nRecnProd := recno()
    nOrdeProd := dbsetorder()
//    nRelaProd := dbsetrelation()
  endif
  
  select ProdARQ
  set order to 2
  dbgotop ()

  Janela ( 03, 01, 21, 77, mensagem( 'Janela', 'ConsProd', .f. ), .f. )

  oProduto           := TBrowseDb( 5, 2, 19, 76 )
  oProduto:headsep   := chr(194)+chr(196)
  oProduto:colsep    := chr(179)
  oProduto:footsep   := chr(193)+chr(196)
  oProduto:colorSpec := CorJanel + ',' + CorCampo

  do case
    case EmprARQ->ConsProd == 1
      oProduto:addColumn( TBColumnNew("Código", {|| Prod } ) )
      oProduto:addColumn( TBColumnNew("Nome", {|| left( Nome, 38 ) } ) )
    case EmprARQ->ConsProd == 3
      oProduto:addColumn( TBColumnNew("Referência", {|| left( Refe, 12 ) } ) )
      oProduto:addColumn( TBColumnNew("Nome", {|| left( Nome, 32 ) } ) )
    case EmprARQ->ConsProd == 4
      oProduto:addColumn( TBColumnNew("CodBarra", {|| left( CodFab, 12 ) } ) )
      oProduto:addColumn( TBColumnNew("Nome", {|| left( Nome, 32 ) } ) )
  endcase
  
  if pTipo == 'enot' .or. pTipo == 'epro' .or. pTipo == 'tbpr'
    if EmprARQ->Moeda == "X"
      oProduto:addColumn( TBColumnNew( 'Preço Custo', {|| transform( PrecoCusto * nMoedaDia, PictPreco(14) ) } ) )
    else
      oProduto:addColumn( TBColumnNew( 'Preço Custo', {|| transform( PrecoCusto, PictPreco(14) ) } ) )
    endif
  else  
    if EmprARQ->Moeda == "X"
      oProduto:addColumn( TBColumnNew( 'Preço Venda', {|| transform( PrecoVenda * nMoedaDia, PictPreco(14) ) } ) )
    else
      oProduto:addColumn( TBColumnNew( 'Preço Venda', {|| transform( PrecoVenda, PictPreco(14) ) } ) )
    endif
  endif  

  oProduto:addColumn( TBColumnNew("Un.",          {|| Unid } ) )
  if EmprARQ->Inteira == "X"
    oProduto:addColumn( TBColumnNew("Qtde.",      {|| transform( Qtde, '@E 9999999999' ) } ) )
  else  
    oProduto:addColumn( TBColumnNew("Qtde.",      {|| transform( Qtde, '@E 999999.999' ) } ) )
  endif  

  if EmprARQ->PrecoProd == "X"
    if !empty( EmprARQ->Preco1 )
      cCalc := alltrim( EmprARQ->Preco1 )
    
      if EmprARQ->Moeda == "X"
        oProduto:addColumn( TBColumnNew( EmprARQ->Cabec1, {|| transform( (&cCalc) * nMoedaDia, PictPreco(14) ) } ) )
      else      
        oProduto:addColumn( TBColumnNew( EmprARQ->Cabec1, {|| transform( (&cCalc), PictPreco(14) ) } ) )
      endif     
    endif  
    if !empty( EmprARQ->Preco2 )
      cCalc := alltrim( EmprARQ->Preco2 )
    
      if EmprARQ->Moeda == "X"
        oProduto:addColumn( TBColumnNew( EmprARQ->Cabec2, {|| transform( (&cCalc) * nMoedaDia, PictPreco(14) ) } ) )
      else      
        oProduto:addColumn( TBColumnNew( EmprARQ->Cabec2, {|| transform( (&cCalc), PictPreco(14) ) } ) )
      endif     
    endif  
    if !empty( EmprARQ->Preco3 )
      cCalc := alltrim( EmprARQ->Preco3 )
    
      if EmprARQ->Moeda == "X"
        oProduto:addColumn( TBColumnNew( EmprARQ->Cabec3, {|| transform( (&cCalc) * nMoedaDia, PictPreco(14) ) } ) )
      else      
        oProduto:addColumn( TBColumnNew( EmprARQ->Cabec3, {|| transform( (&cCalc), PictPreco(14) ) } ) )
      endif     
    endif  
    if !empty( EmprARQ->Preco4 )
      cCalc := alltrim( EmprARQ->Preco4 )
    
      if EmprARQ->Moeda == "X"
        oProduto:addColumn( TBColumnNew( EmprARQ->Cabec4, {|| transform( (&cCalc) * nMoedaDia, PictPreco(14) ) } ) )
      else      
        oProduto:addColumn( TBColumnNew( EmprARQ->Cabec4, {|| transform( (&cCalc), PictPreco(14) ) } ) )
      endif     
    endif  
    if !empty( EmprARQ->Preco5 )
      cCalc := alltrim( EmprARQ->Preco5 )
    
      if EmprARQ->Moeda == "X"
        oProduto:addColumn( TBColumnNew( EmprARQ->Cabec5, {|| transform( (&cCalc) * nMoedaDia, PictPreco(14) ) } ) )
      else
        oProduto:addColumn( TBColumnNew( EmprARQ->Cabec5, {|| transform( (&cCalc), PictPreco(14) ) } ) )
      endif     
    endif  
  endif  

  if EmprARQ->ConsMedia == "X"
    nMes := month( date() ) - 1
  
    do case
      case nMes == 0
        dMes01Ini := ctod( '01' + '/' + '10' + '/' + substr( strzero( year( date() ) - 1, 4 ), 3, 2 ) )
        dMes01Fin := eom( dMes01Ini )
        dMes02Ini := ctod( '01' + '/' + '11' + '/' + substr( strzero( year( date() ) - 1, 4 ), 3, 2 ) )
        dMes02Fin := eom( dMes02Ini )
        dMes03Ini := ctod( '01' + '/' + '12' + '/' + substr( strzero( year( date() ) - 1, 4 ), 3, 2 ) )
        dMes03Fin := eom( dMes03Ini )
      case nMes == 1
        dMes01Ini := ctod( '01' + '/' + '11' + '/' + substr( strzero( year( date() ) - 1, 4 ), 3, 2 ) )
        dMes01Fin := eom( dMes01Ini )
        dMes02Ini := ctod( '01' + '/' + '12' + '/' + substr( strzero( year( date() ) - 1, 4 ), 3, 2 ) )
        dMes02Fin := eom( dMes02Ini )
        dMes03Ini := ctod( '01' + '/' + '01' + '/' + substr( strzero( year( date() ), 4 ), 3, 2 ) )
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
      oProduto:addColumn( TBColumnNew( strzero( month( dMes01Ini ), 2 ) + "/" + alltrim(str(year(dMes01Ini))), {|| transform( Vend01, '@E 9999999999' ) } ) )
      oProduto:addColumn( TBColumnNew( strzero( month( dMes02Ini ), 2 ) + "/" + alltrim(str(year(dMes02Ini))), {|| transform( Vend02, '@E 9999999999' ) } ) )
      oProduto:addColumn( TBColumnNew( strzero( month( dMes03Ini ), 2 ) + "/" + alltrim(str(year(dMes03Ini))), {|| transform( Vend03, '@E 9999999999' ) } ) )
      oProduto:addColumn( TBColumnNew( "Media", {|| transform( ( Vend01 + Vend02 + Vend03 ) / 3, '@E 9999999999' ) } ) )
    else  
      oProduto:addColumn( TBColumnNew( strzero( month( dMes01Ini ), 2 ) + "/" + alltrim(str(year(dMes01Ini))), {|| transform( Vend01, '@E 9,999.9999' ) } ) )
      oProduto:addColumn( TBColumnNew( strzero( month( dMes02Ini ), 2 ) + "/" + alltrim(str(year(dMes02Ini))), {|| transform( Vend02, '@E 9,999.9999' ) } ) )
      oProduto:addColumn( TBColumnNew( strzero( month( dMes03Ini ), 2 ) + "/" + alltrim(str(year(dMes03Ini))), {|| transform( Vend03, '@E 9,999.9999' ) } ) )
      oProduto:addColumn( TBColumnNew( "Media", {|| transform( (Vend01+Vend02+Vend03)/3, '@E 9,999.9999' ) } ) )
    endif  
  
    select ProdARQ         
    set order to 2
    dbgotop()
  endif
          
  do case
    case EmprARQ->ConsProd == 1
      oProduto:colPos := 2
    case EmprARQ->ConsProd == 3
      oProduto:colPos := 1
    case EmprARQ->ConsProd == 4
      oProduto:colPos := 1
  endcase

  lAdiciona      := .f.
  lExitRequested := .f.
  nLinBarra      := 1
  nTotal         := lastrec()
  cLetra         := ''
  nAnter         := recno()
  BarraSeta      := BarraSeta( nLinBarra, 6, 19, 77, nTotal )

  setcolor ( CorCampo )
  @ 20,14 say space(40)
    
  setcolor( CorJanel + ',' + CorCampo )
  @ 06,01 say chr(195)
  @ 19,01 say chr(195)
  @ 20,05 say 'Consulta'

  do while !lExitRequested
    Mensagem( 'Cons', 'ConsProd' )
        
    oProduto:forcestable() 
    
    iif( BarraSeta, BarraSeta( nLinBarra, 6, 19, 77, nTotal ), NIL )
    
    PosiDBF( 03, 77 )
        
    if oProduto:stable
      if oProduto:hitTop .or. oProduto:hitBottom
        tone( 125, 0 )        
      endif  
      
      cTecla := Teclar(0)
    endif
    
    do case
      case cTecla == K_DOWN 
        if !oProduto:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oProduto:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;        oProduto:down()
      case cTecla == K_UP;          oProduto:up()
      case cTecla == K_PGDN;        oProduto:pageDown()
      case cTecla == K_PGUP;        oProduto:pageUp()
      case cTecla == K_CTRL_PGUP;   oProduto:goTop()
      case cTecla == K_CTRL_PGDN;   oProduto:goBottom()
      case cTecla == K_RIGHT;       oProduto:right()
      case cTecla == K_LEFT;        oProduto:left()
      case cTecla == K_HOME;        oProduto:home()
      case cTecla == K_END;         oProduto:end()
      case cTecla == K_CTRL_LEFT;   oProduto:panLeft()
      case cTecla == K_CTRL_RIGHT;  oProduto:panRight()
      case cTecla == K_CTRL_HOME;   oProduto:panHome()
      case cTecla == K_CTRL_END;    oProduto:panEnd()
      case cTecla == K_ENTER
        do case
          case oProduto:colpos == 3 .and. !SemAcesso( 'Prod' )
            select ProdARQ

            aPrecoVenda := PrecoVenda

            @ 6 + oProduto:rowpos,48 get aPrecoVenda  pict PictPreco(14)
            read
          
            if lastkey() != K_ESC
              if RegLock()
                replace PrecoVenda     with aPrecoVenda
                
                if PrecoCusto > 0
                  replace Lucro        with ( ( ( aPrecoVenda / PrecoCusto ) - 1 ) * 100 )
                endif
                dbunlock()
              endif
            endif
            
            oProduto:refreshall()
          case oProduto:colpos == 5 .and. !SemAcesso( 'Prod' )
            select ProdARQ
             
            aQtde := Qtde
            
            if EmprARQ->Inteira == 'X'
              @ 6 + oProduto:rowpos,67 get aQtde     pict '@E 9999999999'
            else  
              @ 6 + oProduto:rowpos,67 get aQtde     pict '@E 999999.999'
            endif  
            read

            if lastkey() != K_ESC
              if RegLock()
                replace Qtde     with aQtde
                dbunlock()
              endif
            endif
                        
            oProduto:refreshall()
          otherwise    
            if xlPara == NIL
              lExitRequested := .t.
            else  
            endif  
        endcase
      case cTecla == K_ESC;         lExitRequested := .t.
      case cTecla == K_ALT_U;       ExibForn()
      case cTecla == K_ALT_O;       ExibCota()
      case cTecla == K_ALT_P;       ExibCond()
      case cTecla == K_ALT_R;       Reajuste()
      case cTecla == K_F1
        tAjuda := savescreen( 00, 00, 23, 79 )
        
        Janela( 06, 18, 16, 59, mensagem( 'Janela', 'ConsProd2', .f. ), .f. )
        setcolor( CorJanel )
        @ 08,20 say ' Alt+U Ultimos Fornecedores'
        @ 09,20 say ' Alt+O Cotação de Preços'
        @ 10,20 say ' Alt+P Condições de Pagamento'
        @ 11,20 say ' Alt+R Reajuste de Preços'
        @ 12,20 say ' Alt+H Histórico'
        @ 13,20 say ' Alt+M Recalcula a Média' 
        @ 14,20 say 'Insert Incluir com código automático'
        @ 15,20 say ' Alt+A Alterar Produto'
        Teclar(0)
        restscreen( 00, 00, 23, 79, tAjuda )
      case cTecla == K_ALT_M
        nRegiAtua := recno()
        tMedia    := savescreen( 00, 00, 23, 79 )
      
        Janela( 11, 23, 14, 56, mensagem( "Janela", "Atencao", .f. ), .f. )
        setcolor ( CorJanel + "," + CorCampo )

        @ 13,25 say "Aguarde! Gerando a Media... "
      
        if NetUse( "NSaiARQ", .t. )
          VerifIND( "NSaiARQ" )
      
          bOpenNSai := .t.
  
          #ifdef DBF_NTX
            set index to NSaiIND1, NSaiIND2, NSaiIND3, NSaiIND4
          #endif  
        else
          bOpenNSai := .f.  
        endif

        if NetUse( "INSaARQ", .t. )
          VerifIND( "INSaARQ" )
      
          bOpenINSa := .t.
  
          #ifdef DBF_NTX
            set index to INSaIND1
          #endif  
        else
          bOpenINSa := .f.  
        endif

        if NetUse( "SProARQ", .t. )
          VerifIND( "SProARQ" )
      
          bOpenSPro := .t.
      
          #ifdef DBF_NTX
            set index to SProIND1
          #endif  
        else
          bOpenSPro := .f.  
        endif

        if NetUse( "ISPrARQ", .t. )
          VerifIND( "ISPrARQ" )
      
          bOpenISPr := .t.
     
          #ifdef DBF_NTX
            set index to ISPrIND1
          #endif  
        else  
          bOpenISPr := .f.
        endif

        select ProdARQ
        set order to 1
        dbgotop()
        do while !eof()    
          nMes01 := nMes02 := nMes03 := 0
 
          select NSaiARQ
          set order to 4
          dbseek( dMes01Ini, .t. )
          do while !eof ()
            if Emis >= dMes01Ini .and. Emis <= dMes03Fin
              select INSaARQ
              set order to 1
              dbseek( NSaiARQ->Nota, .t. )
              do while Nota == NSaiARQ->Nota .and. !eof()
                if Prod == ProdARQ->Prod
                  if NSAiARQ->Emis >= dMes01Ini .and. NSaiARQ->Emis <= dMes01Fin
                    nMes01 += Qtde
                  endif
                  if NSAiARQ->Emis >= dMes02Ini .and. NSaiARQ->Emis <= dMes02Fin
                    nMes02 += Qtde
                  endif
                  if NSAiARQ->Emis >= dMes03Ini .and. NSaiARQ->Emis <= dMes03Fin
                    nMes03 += Qtde
                  endif
                endif
                dbskip()
              enddo
      
              select NSaiARQ
            endif
            dbskip()
          enddo
      
          select SProARQ
          set order to 4
          dbseek( dMes01Ini, .t. )
          do while !eof ()
            if Emis >= dMes01Ini .and. Emis <= dMes03Fin
              select ISPrARQ
              set order    to 1
              dbseek( SProARQ->Nota, .t. )
              do while Nota == SProARQ->Nota .and. !eof()
                if Prod == ProdARQ->Prod
                  if SProARQ->Emis >= dMes01Ini .and. SProARQ->Emis <= dMes01Fin
                    nMes01 += Qtde
                  endif
                  if SProARQ->Emis >= dMes02Ini .and. SProARQ->Emis <= dMes02Fin
                    nMes02 += Qtde
                  endif
                  if SProARQ->Emis >= dMes03Ini .and. SProARQ->Emis <= dMes03Fin
                    nMes03 += Qtde
                  endif
                endif
                dbskip()
              enddo
      
              select SProARQ
            endif
            dbskip()
          enddo
  
          select ProdARQ
          if RegLock()
            replace Vend01   with nMes01
            replace Vend02   with nMes02
            replace Vend03   with nMes03
            dbunlock()
          endif
        
          dbskip()
        enddo
        
        restscreen( 00, 00, 23, 79, tMedia )
        
        if bOpenNSai
          select NSaiARQ
          close
        endif
        if bOpenINSa  
          select INSaARQ
          close
        endif
        if bOpenSPro  
          select SProARQ
          close
        endif
        if bOpenISpr  
          select ISPrARQ
          close
        endif  
         
        select ProdARQ
        set order to 2
        go nRegiAtua 
      case cTecla == K_ALT_A;       keyboard( K_ENTER )
        Prod (.t.)
        
        setcolor ( CorCampo )
        @ 20,14 say space(40)
        
        select ProdARQ
        set order to 2
        dbseek( ProdARQ->Nome, .f. )

        oProduto:refreshAll()

        lExitRequested := .f.
        cLetra         := '' 
      case cTecla == K_INS;         Prod (.f.)
        setcolor ( CorCampo )
        @ 20,14 say space(40)
        
        select ProdARQ
        set order to 2
        dbseek( ProdARQ->Nome, .f. )
        
        oProduto:refreshAll()

        lExitRequested := .f.
        cLetra         := '' 
      case cTecla == K_ALT_H  
        tEntrHist := savescreen( 00, 00, 23, 79 )

        Janela( 03, 13, 13, 67, mensagem( 'Janela', 'Historico', .f. ), .f. )
        Mensagem( 'Cons', 'ConsProd1' )
         
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
        lLetra := .f.
      
        do case
          case EmprARQ->ConsProd == 1
            do case
              case oProduto:ColPos == 1;      lLetra := .t.   
                set order to 1
              case oProduto:ColPos == 2;      lLetra := .t.     
                set order to 2
              case oProduto:ColPos == 6;      lLetra := .t.     
                set order to 6
            endcase
          case EmprARQ->ConsProd == 3
            do case
              case oProduto:ColPos == 1;      lLetra := .t.   
                set order to 6
              case oProduto:ColPos == 2;      lLetra := .t.     
                set order to 2
              case oProduto:ColPos == 6;      lLetra := .t.     
                set order to 6
            endcase
          case EmprARQ->ConsProd == 4
            do case
              case oProduto:ColPos == 1;      lLetra := .t.   
                set order to 5
              case oProduto:ColPos == 2;      lLetra := .t.     
                set order to 2
              case oProduto:ColPos == 6;      lLetra := .t.     
                set order to 6
            endcase
        endcase
        if lLetra        
          cLetra += chr( cTecla )    
        endif  
        
        if len( cLetra ) > 40
          cLetra := ''
        endif  
     
        setcolor ( CorCampo )
        @ 20,14 say space(40)
        @ 20,14 say cLetra

        dbseek( cLetra, .t. )       

        oProduto:refreshAll()
    endcase
    
    select ProdARQ
  enddo  
  
  if lOpenProd
    select ProdARQ
    close
  else
    select ProdARQ
//    go nRecnProd
//    set order to nOrdeProd
//    set relation to ( nRelaProd )
  endif  

  setcolor( cCorAtual )

  restscreen( 00, 00, 24, 79, tConsProd )
return(oProduto:colPos)

//
// Exibe os fornecedores cadastrados
//
function ExibForn()

  cProd     := ProdARQ->Prod
  pNome     := ProdARQ->Nome
  tExib     := savescreen ( 00, 00, 23, 79 )

  Janela( 11, 23, 14, 56, "LEVE " + cVersao, .f. )
  setcolor ( CorJanel + "," + CorCampo )

  @ 13,25 say "Aguarde! Gerando Consulta... "

  aArqui    := {}
  cArquForn := CriaTemp(0)
  cFornIND1 := CriaTemp(1)
  cChave    := "Forn"

  aadd( aArqui, { "Nota",       "C", 010, 0 } )
  aadd( aArqui, { "Forn",       "C", 006, 0 } )
  aadd( aArqui, { "FornNome",   "C", 028, 0 } )
  aadd( aArqui, { "Fone",       "C", 016, 0 } )
  aadd( aArqui, { "Emis",       "D", 008, 0 } )
  aadd( aArqui, { "Cond",       "C", 010, 0 } )
  aadd( aArqui, { "Qtde",       "N", 012, 3 } )
  aadd( aArqui, { "PrecoCusto", "N", 015, 6 } )
  aadd( aArqui, { "Frete",      "C", 005, 0 } )

  dbcreate( cArquForn, aArqui )
   
  if NetUse( "FornARQ", .t. )
    VerifIND( "FornARQ" )

    tOpenForn := .t.
   
    #ifdef DBF_NTX
      set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
    #endif  
  else
    nRecnForn := recno()
//    nRelaForn := dbsetrelation()
    nOrdeForn := dbsetorder()
    tOpenForn := .f.  
  endif

  if NetUse( "CondARQ", .t. )
    VerifIND( "CondARQ" )

    tOpenCond := .t.
  
    #ifdef DBF_NTX
      set index to CondIND1, CondIND2
    #endif  
  else
    nRecnCond := recno()
//    nRelaCond := dbsetrelation()
    nOrdeCond := dbsetorder()
    tOpenCond := .f.  
  endif
  
  if NetUse( "NEntARQ", .t. )
    VerifIND( "NEntARQ" )
  
    tOpenNEnt := .t.
    
    #ifdef DBF_NTX
      set index to NEntIND1
    #endif  
  else
    nRecnNEnt := recno()
//    nRelaNEnt := dbsetrelation()
    nOrdeNEnt := dbsetorder()
    tOpenNEnt := .f.  
  endif

  if NetUse( "INEnARQ", .t. )
    VerifIND( "INEnARQ" )
  
    tOpenINEn := .t.
  
    #ifdef DBF_NTX
      set index to INEnIND1
    #endif  
  else
    nRecnINEn := recno()
//    nRelaINEn := dbsetrelation()
    nOrdeINEn := dbsetorder()
    tOpenINEn := .f.  
  endif
   
  if NetUse( cArquForn, .f. )
    cTempForn := alias ()
    
    #ifdef DBF_CDX  
      index on &cChave tag &cFornIND1
    #endif

    #ifdef DBF_NTX
     index on &cChave to &cFornIND1

     set index to &cFornIND1
    #endif  
  endif

  select NEntARQ 
  set order    to 1
  set relation to Forn into FornARQ, to Cond into CondARQ
  dbgobottom ()
  do while !bof()
    cNota := Nota
    cForn := Forn
    lFim  := .f.
  
    do case 
      case Conta == 'C'
        cFrete := 'CIF'
      case Conta == 'F'
        cFrete := 'FOB'
      otherwise  
        cFrete := ''
    endcase    
    
    select INenARQ
    set order to 1
    dbseek( cForn + cNota, .t. )

    do while Nota == cNota .and. Forn == cForn .and. !eof ()
      if Prod == cProd
        nQtde       := Qtde
        nPrecoCusto := PrecoCusto
        
        select( cTempForn )
        if AdiReg()
          if RegLock()
            replace Nota         with cNota
            replace Forn         with cForn
            replace FornNome     with FornARQ->Nome
            replace Fone         with FornARQ->Fone
            replace Emis         with NEntARQ->Emis
            replace Cond         with CondARQ->Nome
            replace Qtde         with nQtde 
            replace PrecoCusto   with nPrecoCusto 
            replace Frete        with cFrete
            dbunlock ()
          endif
        endif
        
        select INenARQ
      endif  
      
      dbskip ()
    enddo

    select NEntARQ
    dbskip(-1)
  enddo
  
  select NEntARQ
  if tOpenNEnt
    close
  else 
    go nRecnNEnt 
//    set relation to ( nRelaNEnt )
    set order to nOrdeNEnt  
  endif
  
  if tOpenINEn
    select INEnARQ
    close
  endif
  
  if tOpenForn
    select FornARQ
    close
  endif
  
  if tOpenCond
    select CondARQ
    close
  endif

  Janela( 05, 06, 16, 69, mensagem( 'Janela', 'ExibForn', .f. ), .f. )
  
  select( cTempForn )
  set order to 1

  oFornece           := TBrowseDB( 07, 07, 16, 68 )
  oFornece:headsep   := chr(194)+chr(196)
  oFornece:footsep   := chr(193)+chr(196)
  oFornece:colsep    := chr(179)
  oFornece:colorSpec := CorJanel

  oFornece:addColumn( TBColumnNew("Codigo",     {|| Forn } ) )
  oFornece:addColumn( TBColumnNew("Fornecedor", {|| FornNome } ) )
  oFornece:addColumn( TBColumnNew("Fone",       {|| Fone } ) )
  oFornece:addColumn( TBColumnNew("Nota",       {|| Nota } ) )
  oFornece:addColumn( TBColumnNew("Emissão",    {|| Emis } ) )
  oFornece:addColumn( TBColumnNew("Condições",  {|| Cond } ) )
  if EmprARQ->Inteira == "X"
    oFornece:addColumn( TBColumnNew("Qtde.",    {|| transform( Qtde, '@E 99999999' ) } ) )
  else   
    oFornece:addColumn( TBColumnNew("Qtde.",    {|| transform( Qtde, '@E 99,999.9' ) } ) )
  endif  
  oFornece:addColumn( TBColumnNew("P. Custo",   {|| transform( PrecoCusto, PictPreco(10) ) } ) )
  oFornece:addColumn( TBColumnNew("Frete",      {|| Frete } ) )
  
  lAdiciona      := .f.
  lMais          := .t.
  lExitRequested := .f.
  nLinBarra      := 1
  nTotal         := lastrec()
  cLetra         := ''
  BarraSeta      := BarraSeta( nLinBarra, 8, 16, 69, nTotal )

  oFornece:refreshAll()
  
  setcolor( CorJanel )
  @ 08,06 say chr(195)

  do while !lExitRequested
    Mensagem( 'Cons', 'ExibForn' )
    
    oFornece:forcestable() 
    
    PosiDBF( 05, 69 )

    iif( BarraSeta, BarraSeta( nLinBarra, 8, 16, 69, nTotal ), NIL )

    if oFornece:stable
      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oFornece:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oFornece:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oFornece:down()
      case cTecla == K_UP;         oFornece:up()
      case cTecla == K_PGDN;       oFornece:pageDown()
      case cTecla == K_PGUP;       oFornece:pageUp()
      case cTecla == K_RIGHT;      oFornece:right()
      case cTecla == K_LEFT;       oFornece:left()
      case cTecla == K_HOME;       oFornece:home()
      case cTecla == K_END;        oFornece:end()
      case cTecla == K_CTRL_LEFT;  oFornece:panLeft()
      case cTecla == K_CTRL_RIGHT; oFornece:panRight()
      case cTecla == K_CTRL_HOME;  oFornece:panHome()
      case cTecla == K_CTRL_PGUP;  oFornece:goTop()
      case cTecla == K_CTRL_PGDN;  oFornece:gobottom()
      case cTecla == K_CTRL_END;   oFornece:panEnd()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_ENTER;      lExitRequested := .t.
    endcase
  enddo  
  
  lExitRequested := .f.  
        
  select( cTempForn )
  close
  ferase( cArquForn )
  ferase( cFornIND1 )

  select ProdARQ
  set order to 2
  dbseek( pNome, .f. )
  
  restscreen( 00, 00, 23, 79, tExib )
return NIL

//
// Cotacao de Precos
//
function ExibCota ()

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

  aCotacao := {}
  cProd    := ProdARQ->Prod
  pNome    := ProdARQ->Nome

  select TbPrARQ
  set order    to 1
  set relation to Forn into FornARQ
  dbgotop ()
  do while !eof ()
    cForn := Forn
    cNome := FornARQ->Nome
    dData := Data
    cPgto := Pgto
    
    select ITbPARQ
    set order to 1
    dbseek( cForn + dtos( dData ),  .t. )
    do while Forn == cForn .and. Data == dData .and. !eof ()
      nPrecoCusto := PrecoCusto
      
      if Prod == cProd
        aadd( aCotacao, { cProd, ProdARQ->Nome, cForn, cNome, nPrecoCusto, cPgto } )
      endif  
      dbskip ()
    enddo
    
    select TbPrARQ
    dbskip ()
  enddo  
    
  asort( aCotacao,,, { |Forn01, Forn02| Forn01[5] < Forn02[5] } )
  
  if len( aCotacao ) > 0
    tTelas := savescreen( 00, 00, 23, 79 )

    Janela( 06, 11, 16, 66, mensagem( "Janela", "ExibCota", .f. ), .f. )
    setcolor( CorJanel )
  
    nLin := 8
  
    @ nLin,13 say 'Fornecedor                 Cond.Pgto.    Preço'

    nLin += 2 
  
    for nL := 1 to len( aCotacao )
      @ nLin,13 say aCotacao[ nL, 3 ]  
      @ nLin,18 say aCotacao[ nL, 4 ]       pict '@S20'
      @ nLin,40 say aCotacao[ nL, 6 ]       pict '@S08'
      @ nLin,49 say aCotacao[ nL, 5 ]       pict '@E 999,999.99'
      nLin ++    
    next
          
    Teclar(0)

    restscreen( 00, 00, 23, 79, tTelas )
  else
    Alerta( mensagem( "Alerta", "ExibCota", .f. ) ) 
  endif

  if sOpenTbPr
    select TbPrARQ
    close
  endif

  if sOpenForn
    select FornARQ
    close
  endif

  if sOpenITbP
    select ITbPARQ
    close
  endif
  
  select ProdARQ
  set order to 2
  dbseek( pNome, .f. )
return NIL

//
// Condicao de Pagamentos
//
function ExibCond ()
  local aCond := {}

  if NetUse( "CondARQ", .t. )
    VerifIND( "CondARQ" )
  
    sOpenCond := .t.
  
    #ifdef DBF_NTX
      set index to CondIND1
    #endif  
  else 
    sOpenCond := .f.  
  endif
  
  aadd( aCond, "Descrição                Preco Venda  Acre." )
  aadd( aCond, "  " )

  select CondARQ
  set order to 1
  dbgotop ()
  do while !eof ()
    nPreco := ( ( ProdARQ->PrecoVenda * Acrs ) / 100 ) + ProdARQ->PrecoVenda

    aadd( aCond, left( Nome, 25 ) + " " + transform( nPreco, PictPreco(10) ) + ;
                 " " + transform( Acrs, '@E 999.99' ) )

    dbskip ()
  enddo

  if len( aCond ) > 0
    tTelas := savescreen( 00, 00, 23, 79 )
  
    Janela( 06, 11, 17, 56, mensagem( "Janela", "ExibCond", .f. ), .f. )
    setcolor( CorJanel + ',' + CorCampo )
    
    achoice( 08, 12, 16, 55, aCond )
    
    restscreen( 00, 00, 23, 79, tTelas )
  else
    Alerta( mensagem( "Alerta", "ExibCond", .f. ) )
  endif

  if sOpenCond
    select CondARQ
    close
  endif
return NIL

//
// Reajuste individual de produtos
//
function Reajuste()

  tReajuste := savescreen( 00, 00, 23, 79 )
  nProd     := val( Prod )
  nRegi     := recno()

  Janela( 07, 15, 14, 61, mensagem( 'Janela', 'Reajuste', .f. ), .f. ) 

  setcolor ( CorJanel + ',' + CorCampo )
  @ 09,17 say '   Preço Custo                 Perc '
  @ 10,17 say 'Preço Reajuste '
  
  @ 12,17 say '   Preço Venda                 Perc '
  @ 13,17 say 'Preço Reajuste '
  
  nPrecoCusto := PrecoCusto
  nPrecoVenda := PrecoVenda
  nReajCusto  := 0
  nReajVenda  := 0
  nCustoNovo  := 0
  nVendaNovo  := 0
  
  setcolor( CorCampo )
  @ 09,32 say nPrecoCusto        pict PictPreco(14)
  @ 09,53 say nReajCusto         pict '@E 999.99'
  @ 10,32 say nCustoNovo         pict PictPreco(14)
  @ 12,32 say nPrecoVenda        pict PictPreco(14)
  @ 12,53 say nReajVenda         pict '@E 999.99'
  @ 13,32 say nVendaNovo         pict PictPreco(14)

  setcolor ( CorJanel + ',' + CorCampo )
  @ 09,32 get nPrecoCusto        pict PictPreco(14)
  @ 09,53 get nReajCusto         pict '@E 999.99'
  read
  
  if lastkey () == K_ESC
    restscreen( 00, 00, 23, 79, tReajuste ) 
    return NIL
  endif  
  
  nCustoNovo  := ( ( nPrecoCusto * nReajCusto ) / 100 ) + nPrecoCusto

  @ 10,32 get nCustoNovo         pict PictPreco(14)
  @ 12,32 get nPrecoVenda        pict PictPreco(14)
  @ 12,53 get nReajVenda         pict '@E 999.99'
  read

  if lastkey () == K_ESC
    restscreen( 00, 00, 23, 79, tReajuste ) 
    return NIL
  endif  
  
  nVendaNovo  := ( ( nPrecoVenda * nReajVenda ) / 100 ) + nPrecoVenda

  @ 13,32 get nVendaNovo         pict PictPreco(14)
  read

  if ConfAlte()
    if RegLock()
      replace PrecoCusto  with nCustoNovo
      replace PrecoVenda  with nVendaNovo
      replace UltA        with date()
      dbunlock ()
    endif
  endif
  
  restscreen( 00, 00, 23, 79, tReajuste ) 
  
  oProduto:forcestable()
  oProduto:refreshAll()
return NIL

//
// Mostra os Clientes
//
function ConsClie(xlPara)

  local cArquivo  := alias()  
  local tMostra   := savescreen( 00, 00, 24, 79 )

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )
  
    lAbriClie := .t.

    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
    #endif  
  else
    lAbriClie := .f.  
  endif

  select ClieARQ
  set order to 2
  dbgotop ()

  Janela( 03, 02, 20, 76, mensagem( "Janela", "ConsClie", .f. ), .f. ) 
  setcolor ( CorJanel + ',' + CorCampo )

  oCliente         := TBrowseDb( 05, 03, 18, 75 )
  oCliente:headsep := chr(194)+chr(196)
  oCliente:footsep := chr(193)+chr(196)
  oCliente:colsep  := chr(179)

  oCliente:addColumn( TBColumnNew("Codigo",   {|| Clie } ) )
  oCliente:addColumn( TBColumnNew("Nome",     {|| left( Nome, 29 ) } ) )
  oCliente:addColumn( TBColumnNew("Telefone", {|| left( Fone, 14 ) } ) )
  oCliente:addColumn( TBColumnNew("Endereço", {|| left( Ende, 19 ) } ) )
  oCliente:addColumn( TBColumnNew(" ",        {|| Marc } ) )
  oCliente:addColumn( TBColumnNew("Bairro",   {|| left( Bair, 15 ) } ) )
  oCliente:addColumn( TBColumnNew("Cidade",   {|| left( Cida, 15 ) } ) )
  oCliente:addColumn( TBColumnNew("CNPJ/CPF", {|| iif( Tipo == 'F', transform( CPF, '@E 999,999,999-99' ), transform( CGC, '@R 99.999.999/9999-99' ) ) } ) )
  oCliente:addColumn( TBColumnNew("RG",       {|| RG } ) )
  oCliente:addColumn( TBColumnNew("Conjuge",  {|| Conjuge } ) )
  oCliente:addColumn( TBColumnNew("Ficha",    {|| Ficha } ) )
            
  lExitRequested := .f.
  lEtiqMarc      := .f.
  nLinBarra      := 1
  cLetra         := ''
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 06, 18, 76, nTotal )
    
  oCliente:freeze := 1
  oCliente:colPos := 2
   
  setcolor ( CorCampo )
  @ 19,13 say space(50)
    
  setcolor( CorJanel + ',' + CorCampo )
  @ 19,04 say 'Consulta'
  @ 06,02 say chr(195)
  @ 18,02 say chr(195)
 
  do while !lExitRequested
    Mensagem( 'Cons', 'ConsClie' ) 

    oCliente:forceStable()
    
    PosiDBF( 03, 76 )
        
    iif( BarraSeta, BarraSeta( nLinBarra, 06, 18, 76, nTotal ), NIL )

    if oCliente:stable
      if oCliente:hitTop .or. oCliente:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
    
    do case
      case cTecla == K_DOWN;        oCliente:down()
      case cTecla == K_UP;          oCliente:up()
      case cTecla == K_PGDN;        oCliente:pageDown()
      case cTecla == K_PGUP;        oCliente:pageUp()
      case cTecla == K_CTRL_PGUP;   oCliente:goTop()
      case cTecla == K_CTRL_PGDN;   oCliente:goBottom()
      case cTecla == K_RIGHT;       oCliente:right()
      case cTecla == K_LEFT;        oCliente:left()
      case cTecla == K_HOME;        oCliente:home()
      case cTecla == K_END;         oCliente:end()
      case cTecla == K_CTRL_LEFT;   oCliente:panLeft()
      case cTecla == K_CTRL_RIGHT;  oCliente:panRight()
      case cTecla == K_CTRL_HOME;   oCliente:panHome()
      case cTecla == K_CTRL_END;    oCliente:panEnd()
      case cTecla == K_ALT_B
        tPesquisa := savescreen( 00, 00, 23, 79 )
        Janela( 08, 13, 15, 69, mensagem( 'Janela', 'ConsClie1', .f. ),  .f. )
        Mensagem( 'Cons', 'ConsClie1' )
       
        setcolor ( 'n/w+' )
        @ 14,40 say chr(25)

        setcolor( CorCampo )
        @ 12,24 say space(44)
        @ 14,24 say ' Telefone      '

        setcolor( CorJanel )
        @ 10,15 say 'Pesquisa'
        @ 12,15 say '   Texto'
        @ 14,15 say '   Campo'                  

        aOpc   := {}
        cTexto := space(44)
        
        aadd( aOpc, { ' Começa com... ',  2, 'C', 10, 24, "Pesquisa Começa com o texto especificado." } )
        aadd( aOpc, { ' Possui... ',      2, 'P', 10, 40, "Pesquisa Possui o texto especificado." } )
        aadd( aOpc, { ' Termina com... ', 2, 'T', 10, 52, "Pesquisa Termina com o texto especificado." } )


        nTipo := HCHOICE( aOpc, 3, 2 )
        
        if lastkey() != K_ESC
          setcolor( CorJanel )
          @ 12,24 get cTexto             
          read
          
          if lastkey() != K_ESC
            aTemp  := CriaARQ( "CLIEARQ", .f. )
            aField := {}
            nItens := 0

            for nK := 1 to len( aTemp )
              if empty( aTemp[nK,5] )
                loop
              endif  
              
              nItens ++
              
              aadd( aField, { ' '+aTemp[nK,5]+space(14-len(aTemp[nK,5])), 2, left(aTemp[nK,1],1), 14, 24, " " })
            next
            
            nCampo := HCHOICE( aField, nItens, 1 )
          endif
          
//        PesqAgen( nTipo, cTexto )                       
        endif  

        lExitRequested := .f.   
        cLetra         := ''
        
        restscreen( 00, 00, 23, 79, tPesquisa )
      case cTecla == K_F1
        tAjuda := savescreen( 00, 00, 23, 79 )
        
        Janela( 03, 18, 19, 59, mensagem( 'Janela', 'ConsClie2', .f. ), .f. )
        setcolor( CorJanel )
        @ 05,20 say 'Alt + B  Pesquisar Campo'
        @ 06,20 say 'Alt + G  Evento'
        @ 07,20 say 'Alt + F  Ficha de Cobrança'
        @ 08,20 say 'Alt + E  Contas a Receber'
        @ 09,20 say 'Alt + P  Contas Pagas'
        @ 10,20 say 'Alt + H  Cheques'
        @ 11,20 say 'Alt + N  Pedidos e Notas Fiscais'
        @ 12,20 say 'Alt + O  Ordem de Serviços'
        @ 13,20 say 'Alt + V  Visitas'
        @ 14,20 say 'Alt + M  Marca/Desmarca Etiqueta'
        @ 15,20 say 'Alt + I  Imprimir Etiqueta'
        @ 17,20 say 'Alt + A  Alterar'
        @ 18,20 say 'Insert   Incluir com Codigo Autom tico'
        Teclar(0)
        restscreen( 00, 00, 23, 79, tAjuda )
      case cTecla == K_ENTER
        if xlPara == NIL
          lOk            := .t.
          lExitRequested := .t.
        else
        endif  
      case cTecla == K_ESC;         lExitRequested := .t.
      case cTecla == K_ALT_A;       tAlte          := savescreen( 00, 00, 23, 79 )
        do case 
          case ClieARQ->Tipo == 'F'
            Fisi (.t.)
          case ClieARQ->Tipo == 'J'
            Clie (.t.)
          case ClieARQ->Tipo == 'S'
            Clin (.t.)
        endcase    
        
        select ClieARQ
        set order to 2
        dbseek(ClieARQ->Nome,.f.)

        oCliente:refreshAll()

        restscreen( 00, 00, 23, 79, tAlte )

        lExitRequested := .f.        
        cLetra         := ''
      case cTecla == K_INS
        tAlte := savescreen( 00, 00, 23, 79 )
        
        do case
          case EmprARQ->InclClie == 'J'
            Clie (.f.)
          case EmprARQ->InclClie == 'F'
            Fisi (.f.)
          case EmprARQ->InclClie == 'S'
            Clin (.f.)
          otherwise
            aClies := {}
        
            Janela( 07, 24, 12, 43, mensagem( 'Janela', 'ConsClie3', .f. ), .f. )
            setcolor( CorCampo )        
            @ 09,26 say ' Pessoa Física   '
            @ 10,26 say ' Pessoa Jurídica '
            @ 11,26 say ' Simples         '

            setcolor( CorAltKC )
            @ 09,35 say 'F'
            @ 10,35 say 'J'
            @ 11,28 say 'S'
        
            aadd( aClies, { " Pessoa Física   ", 9, 'F', 09, 26, "Incluir Cliente Física." } )
            aadd( aClies, { " Pessoa Jurídica ", 9, 'J', 10, 26, "Incluir Cliente Jurídica." } )
            aadd( aClies, { " Simples         ", 2, 'S', 11, 26, "Incluir Cliente Simples." } )

            nPull := HCHOICE( aClies, 3, 1 )       
            
            if lastkey() != K_ESC
              do case
                case nPull == 1
                  Fisi (.f.)
                case nPull == 2
                  Clie (.f.)
                case nPull == 3
                  Clin (.f.)
              endcase  
            endif  
        endcase
        
        select ClieARQ
        set order to 2
        dbseek(ClieARQ->Nome,.f.)

        oCliente:refreshAll()

        restscreen( 00, 00, 23, 79, tAlte )

        lExitRequested := .f.        
        cLetra         := ''
      case cTecla == K_ALT_M
        if RegLock()
          if ClieARQ->Marc == ' '
            replace Marc      with "X"
          else
            replace Marc      with ' '
          endif    
          dbunlock ()
        endif  
        
        lEtiqMarc := .t.
        
        oCliente:refreshAll()
      case cTecla == K_ALT_I
        EmprARQ->( dbseek( cEmpresa, .f. ) )
  
        nEtiqClie := EmprARQ->EtiqClie

        if NetUse( "EtiqARQ", .t. )
          VerifIND( "EtiqARQ" )
   
          #ifdef DBF_NTX
            set index to EtiqIND1
          #endif  
        endif
  
        select EtiqARQ
        set order to 1
        dbseek( nEtiqClie, .f. )

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
          Alerta( 'Alerta', 'PrinEtiq' )

          select CampARQ
          close
          select EtiqARQ
          close
          restscreen( 00, 00, 23, 79, tPrt )
          return NIL
        endif
  
        cTexto     := Layout
        nLin       := 1
        nEspa      := Espa
        nComp      := Comp
        nLargura   := Tama
        nColunas   := Colunas
        nDistancia := Distancia
        nSalto     := Salto
        aLayout    := {}
  
        cQtLin     := mlcount( cTexto, nLargura + 1 )
        nTotLin    := 0

        for nK := 1 to cQtLin
          cLinha  := memoline( cTexto, nLargura + 1, nK )
          nTotLin ++

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

        if !TestPrint( EmprARQ->Cliente )
          select CampARQ
          close
          select EtiqARQ
          close
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

        @ 00,00 say chr(27) + chr(67) + chr( cQtLin )

        nLinIni  := aLayout[ 1, 1 ]
        nLinFin  := aLayout[ len( aLayout ), 1 ]
        nQtdeCop := 1
        xLin     := 0
        nCopia   := 0
  
        select ClieARQ
        set order  to 1
        set filter to Marc == "X"
        dbgotop ()
        do while !eof ()
          for nH := 1 to nColunas
            s       := strzero( nH, 2 )
            aEtiq&s := {}
          next
    
          if nCopia == 0   
            nCopia := nQtdeCop
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
              dbskip()  
        
              nCopia := nQtdeCop
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
                  nCol += ( nLargura + nDistancia ) * ( nA - 1 )
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
  
        @ nTotLin,00 say chr(27) + '@'

        set printer to
        set printer off
        set device  to screen

        select ClieARQ
        set filter  to
  
        select CampARQ
        close
        select EtiqARQ
        close
        restscreen( 00, 00, 23, 79, tPrt )
      case cTecla == K_ALT_V;        ConsVisi()
        oCliente:refreshAll()
        lExitRequested := .f.        
      case cTecla == K_ALT_F;        CobrFich()
        oCliente:refreshAll()
        lExitRequested := .f.        
      case cTecla == K_ALT_E;        ConsRece()
        oCliente:refreshAll()
        lExitRequested := .f.        
      case cTecla == K_ALT_O;        ConsOrdS()
        oCliente:refreshAll()
        lExitRequested := .f.        
      case cTecla == K_ALT_N;        ConsPedi()
        oCliente:refreshAll()
        lExitRequested := .f.        
      case cTecla == K_ALT_H;        ConsChPr ()
        oCliente:refreshAll()
        lExitRequested := .f.        
      case cTecla == K_ALT_P;        ConsRcbo()
        oCliente:refreshAll()
        lExitRequested := .f.        
      case cTecla == K_ALT_G  
        tEntrEven := savescreen( 00, 00, 23, 79 )

        Janela( 04, 13, 14, 67, mensagem( 'Janela', 'ConsClie4', .f. ), .f. )
        Mensagem( 'Cons', 'ConsClie3' )
         
        setcolor( CorCampo )     
        cEvento := memoedit( Evento, 06, 15, 13, 65, .t., "OutProd" )
        
        if lastkey() == K_CTRL_W
          if RegLock()
            replace Evento   with cEvento
            dbunlock ()
          endif
        endif
    
        restscreen( 00, 00, 23, 79, tEntrEven )
      case cTecla == K_BS
        cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
      
        setcolor ( CorCampo )
        @ 19,13 say space(50)
        @ 19,13 say cLetra
      case cTecla >= 32 .and. cTecla <= 128
        lLetra := .f.
      
        do case
          case oCliente:ColPos == 1;       lLetra := .t.   
            set order to 1
          case oCliente:ColPos == 2;       lLetra := .t.     
            set order to 2
          case oCliente:ColPos == 4;       lLetra := .t.     
            set order to 3
          case oCliente:ColPos == 6;       lLetra := .t.      
            set order to 5
          case oCliente:ColPos == 7;       lLetra := .t.      
            set order to 4
          case oCliente:ColPos == 10;      lLetra := .t.      
            set order to 6
        endcase
        
        if lLetra     
          cLetra += chr( cTecla )    
        endif  

        if len( cLetra ) > 50
          cLetra := ''
        endif  
     
        setcolor ( CorCampo )
        @ 19,13 say space(50)
        @ 19,13 say cLetra

        dbseek( cLetra, .t. )
        oCliente:refreshAll()
    endcase
    
    select ClieARQ
  enddo

  if lAbriClie 
    select ClieARQ
    if lEtiqMarc
      set order to 8
      do while .t.
        dbseek( "X", .f. )
        if found()
          replace Marc      with " "
          dbunlock()
        else
          exit  
        endif  
      enddo
    endif    
    close
  endif  

  restscreen( 00, 00, 24, 79, tMostra )
return NIL

//
// Consulta de Contas a Receber - Clientes
//
function ConsRece ()
  local cCorAtual := setcolor()
  
  if NetUse( "ReprARQ", .t. )
    VerifIND( "ReprARQ" )
  
    tOpenRepr := .t.

    #ifdef DBF_NTX
      set index to ReprIND1, ReprIND2
    #endif  
  else
    tOpenRepr := .f.
  endif

  if NetUse( "PortARQ", .t. )
    VerifIND( "PortARQ" )
  
    tOpenPort := .t.

    #ifdef DBF_NTX
      set index to PortIND1, PortIND2
    #endif  
  else
    tOpenPort := .f.
  endif
  
  if NetUse( "CobrARQ", .t. )
    VerifIND( "CobrARQ" )
  
    tOpenCobr := .t.

    #ifdef DBF_NTX
      set index to CobrIND1, CobrIND2
    #endif  
  else
    tOpenCobr := .f.
  endif
  
  if NetUse( "ReceARQ", .t. )
    VerifIND( "ReceARQ" )
   
    tOpenRece := .t.

    #ifdef DBF_NTX
      set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
    #endif  
  else
    tOpenRece := .f.
  endif
  
  rClie       := ClieARQ->Clie
  rNome       := ClieARQ->Nome
  rTotalGeral := rSubTotal   := 0
  rTotalJuro  := rTotalLiqu  := 0
  dVctoIni    := ctod( '01/01/1900' )
  dVctoFin    := ctod( '31/12/2015' )
  dData       := dtos( ctod('  /  /  ' ) ) 
  tTelaRcto   := savescreen( 00, 00, 23, 79 )
  lCalcJuro   := .t.
  aPortador   := {}
  aCobrador   := {}
  
  if EmprARQ->Periodo == "X"
    Janela( 09, 24, 13, 50, mensagem( 'Janela', 'Periodo', .f. ), .f. )
    Mensagem( 'LEVE', 'Periodo' )

    setcolor( CorJanel )
    @ 11,26 say 'Vcto. Inicial'
    @ 12,26 say '  Vcto. Final'
  
    @ 11,40 get dVctoIni      pict '99/99/9999'
    @ 12,40 get dVctoFin      pict '99/99/9999' valid dVctoFin >= dVctoIni
    read
    
    if lastkey() == K_ESC
      if tOpenPort 
        select PortARQ
        close
      endif  
  
      if tOpenCobr 
        select CobrARQ
        close
      endif  
  
      if tOpenRece 
        select ReceARQ
        close
      endif  
  
      if tOpenRepr 
        select ReprARQ
        close
      endif  
    
      select ClieARQ
      set order to 2
      dbseek( rNome, .f. )
    
      restscreen( 00, 00, 23, 79, tTelaRcto )
      return NIL
    endif  
  endif  
  
  select PortARQ
  set order to 1
  
  select CobrARQ
  set order to 1
  
  select ReprARQ
  set order to 1 
  
  select ReceARQ
  set order to 5
  set relation to Port into PortARQ, to Cobr into CobrARQ,;
               to Clie into ClieARQ, to Repr into ReprARQ
  dbseek( rClie + dData, .t. )
  do while Clie == rClie .and. Pgto == ctod('  /  /  ') .and. !eof ()
    if Vcto >= dVctoIni .and. Vcto <= dVctoFin
      rTotalGeral += ( ( Valor - Desc ) + VerJuro() )
      rTotalLiqu  += ( Valor - Desc ) 
      rTotalJuro  += ( VerJuro () )
    endif  

    nPortElem := ascan( aPortador, { |nElem| nElem[1] == Port } )
      
    if nPortElem > 0
      aPortador[ nPortElem, 3 ] += 1
    else
      aadd( aPortador, { Port, PortARQ->Nome, 1 } ) 
    endif  

    nCobrElem := ascan( aCobrador, { |nElem| nElem[1] == Cobr } )
      
    if nCobrElem > 0
      aCobrador[ nCobrElem, 3 ] += 1
    else
      aadd( aCobrador, { Cobr, CobrARQ->Nome, 1 } ) 
    endif  
 
    dbskip ()
  enddo      
  
  if rTotalGeral == 0
    Alerta( mensagem( 'Alerta', 'ConsRece', .f. ) ) 
  
    if tOpenPort 
      select PortARQ
      close
    endif  

    if tOpenCobr 
      select CobrARQ
      close
    endif  
  
    if tOpenRece 
      select ReceARQ
      close
    endif  
  
    if tOpenRepr 
      select ReprARQ
      close
    endif  
    
    restscreen( 00, 00, 23, 79, tTelaRcto )

    select ClieARQ
    set order to 2
    dbseek( rNome, .f. )
    
    return NIL
  endif  
    
  Janela ( 03, 01, 20, 76, mensagem( 'Janela', 'ConsRece', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )

  select ReceARQ
  set order to 5

  bFirst := {|| dbseek( rClie, .t. ) }
  bLast  := {|| dbseek( rClie, .t. ), dbskip(-1) }
  bWhile := {|| Clie == rClie .and. empty( Pgto ) }
  bFor   := {|| Clie == rClie .and. empty( Pgto ) .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin }
  
  oReceber          := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oReceber:nTop     := 7
  oReceber:nLeft    := 2
  oReceber:nBottom  := 18
  oReceber:nRight   := 75
  oReceber:headsep  := chr(194)+chr(196)
  oReceber:colsep   := chr(179)
  oReceber:footsep  := chr(193)+chr(196)

  oReceber:addColumn( TBColumnNew(" ",     {|| Marc } ) )
  oReceber:addColumn( TBColumnNew("Nota",  {|| transform( val( Nota ), '999999-99' ) } ) )
  oReceber:addColumn( TBColumnNew("Tipo",  {|| iif( Tipo == 'P', 'Pedido', iif( Tipo == 'N', 'Nota  ','O.S.  ' ) ) } ) )
  oReceber:addColumn( TBColumnNew("Emis.", {|| Emis } ) )
  oReceber:addColumn( TBColumnNew("Vcto.", {|| Vcto } ) )
  oReceber:addColumn( TBColumnNew("Valor", {|| transform( Valor, '@E 999,999.99' ) } ) )
  oReceber:addColumn( TBColumnNew("Juros", {|| transform( VerJuro(), '@E 999,999.99' ) } ) )
  oReceber:addColumn( TBColumnNew("Total", {|| transform( VerTotal(), '@E 999,999.99' ) } ) )
  oReceber:addColumn( TBColumnNew("Desconto", {|| transform( Desc, '@E 999,999.99' ) } ) )
  oReceber:addColumn( TBColumnNew("Portador", {|| left( PortARQ->Nome, 15 ) + ' ' + Port } ) )
  oReceber:addColumn( TBColumnNew("Cobrador", {|| left( CobrARQ->Nome, 15 ) + ' ' + Cobr } ) )
              
  lAdiciona      := .f.
  lMais          := .t.
  lExitRequested := .f.
  nLinBarra      := 1
  cSequ          := space(2)
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 8, 18, 76, nTotal )
  
  setcolor( CorJanel + ',' + CorCampo )
  @ 08,01 say chr(195)
  @ 18,01 say chr(195)
  @ 05,05 say 'Cliente'
  @ 19,05 say 'Sub-Total'
  @ 19,31 say 'Total Geral'
  
  setcolor( CorCampo )
  @ 05,13 say rClie
  if rClie == '999999'
    @ 05,20 say Cliente
  else  
    @ 05,20 say rNome
  endif  
  @ 19,15 say rSubTotal                  pict '@E 999,999.99'
  @ 19,43 say rTotalLiqu                 pict '@E 999,999.99'
  @ 19,54 say rTotalJuro                 pict '@E 999,999.99'
  @ 19,65 say rTotalGeral                pict '@E 999,999.99'
  
/*  
  if EmprARQ->ConsClie == "X"
    if len( aCobrador ) > 0 .or. len( aPortador ) > 0
      tTelas := savescreen( 00, 00, 23, 79 )

      oReceber:refreshAll()
      oReceber:forcestable() 
    
      Janela( 04, 08, 14, 64, 'Resumo...', .f. )
      Mensagem( 'Consulta do resumo de contas a receber, tecle <ENTER> para continuar...')
      setcolor( CorJanel + ',' + CorCampo )
      @ 06,10 say 'Portador            Qtde.   Cobrador            Qtde.'
    
      nLinn := 7
      nTota := 0
    
      for nL := 1  to len( aPortador )
        @ nLinn,10 say aPortador[ nL, 1 ] + " " + left( aPortador[ nL, 2 ], 15 ) 
        @ nLinn,31 say aPortador[ nL, 3 ]                         pict '9999'
        nLinn ++
        nTota += aPortador[ nL, 3 ]
      next
   
      if nTota > 0
        @ nLinn,25 say 'Total'
        @ nLinn,31 say nTota       pict '9999'
      endif 

      nLinn := 7
      nTota := 0
    
      for nL := 1  to len( aCobrador )
        @ nLinn,38 say aCobrador[ nL, 1 ] + " " + left( aCobrador[ nL, 2 ], 20 )
        @ nLinn,59 say aCobrador[ nL, 3 ]                         pict '9999'
        nLinn ++
        nTota += aCobrador[ nL, 3 ]
      next
   
      if nTota > 0
        @ nLinn,53 say 'Total'
        @ nLinn,59 say nTota       pict '9999'
      endif 
    
      Teclar(0)
        
      restscreen( 00, 00, 23, 79, tTelas )
    endif  
  endif
*/
  oReceber:refreshAll()

  do while !lExitRequested
    Mensagem( 'Cons', 'ConsRece' )
    
    oReceber:forcestable() 
    
    PosiDBF( 03, 76 )

    iif( BarraSeta, BarraSeta( nLinBarra, 8, 18, 76, nTotal ), NIL )
    
    if oReceber:stable
      if oReceber:hitTop .or. oReceber:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oReceber:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oReceber:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oReceber:down()
      case cTecla == K_UP;         oReceber:up()
      case cTecla == K_PGDN;       oReceber:pageDown()
      case cTecla == K_PGUP;       oReceber:pageUp()
      case cTecla == K_LEFT;       oReceber:left()
      case cTecla == K_RIGHT;      oReceber:right()
      case cTecla == K_CTRL_PGUP;  oReceber:goTop()
      case cTecla == K_CTRL_PGDN;  oReceber:gobottom()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_ALT_S       
       tReajuste := savescreen( 00, 00, 23, 79 )

        Janela( 08, 28, 14, 54, mensagem( 'Janela', 'DescRece', .f. ), .t. )

        setcolor ( CorJanel + ',' + CorCampo )
        @ 10,31 say 'Desconto        %'
        @ 11,31 say '   Valor' 
        @ 13,30 say 'Confirmar '

        setcolor( CorCampo )
        @ 13,40 say ' Sim '
        @ 13,46 say ' Não '

        setcolor( CorAltKC )
        @ 13,41 say 'S'
        @ 13,47 say 'N'

        nPerC     := 0
        nDesconto := 0

        setcolor ( CorJanel + ',' + CorCampo )
        @ 10,40 get nPerC        pict '@E 999.99'        valid DescConsRece()
        @ 11,40 get nDesconto    pict '@E 999,999.99'  
        read
                  
        if lastkey () == K_ESC .or. nDesconto == 0
          restscreen( 00, 00, 23, 79, tReajuste )
          loop
        endif

        lOkay := ConfLine( 13, 40, 1 )

        restscreen( 00, 00, 23, 79, tReajuste )
        
        if lOkay
          if RegLock()
            replace Desc       with nDesconto
            dbunlock()
          endif

          nRegistro   := recno ()  
          rTotalGeral := 0
          rTotalLiqui := 0
          rTotalJuro  := 0
        
          dbseek( rClie + dData, .t. )
          do while Clie == rClie .and. Pgto == ctod('  /  /  ') .and. !eof ()
            if Vcto >= dVctoIni .and. Vcto <= dVctoFin
              rTotalGeral += ( ( Valor - Desc ) + VerJuro() )
              rTotalLiqu  += ( Valor - Desc ) 
              rTotalJuro  += ( VerJuro () )
            endif
            dbskip()
          enddo

          go nRegistro
          setcolor( CorCampo )
          @ 19,15 say rSubTotal                  pict '@E 999,999.99'
          @ 19,43 say rTotalLiqu                 pict '@E 999,999.99'
          @ 19,54 say rTotalJuro                 pict '@E 999,999.99'
          @ 19,65 say rTotalGeral                pict '@E 999,999.99'
        endif  
        
        oReceber:goTop()
        oReceber:refreshAll()
      case cTecla == K_ENTER
        if oReceber:ColPos == 7
          if Juro == 0
            nJuro := VerJuro ()
          else
            nJuro := Juro  
          endif  
          
          @ ( 8 + oReceber:rowPos ),54 get nJuro                 pict '@E 999,999.99'
          read
          
          if lastkey() != K_ESC
            if RegLock(0)
              if nJuro == 0
                replace Acre         with 0
                replace Juro         with nJuro
              else
                replace Juro         with nJuro
              endif  
              dbunlock ()
            endif 
          
            rTotalJuro  := 0
            rTotalGeral := 0
            nRegi       := recno ()
           
            dbseek( rClie + dData, .t. )
            do while Clie == rClie .and. Pgto == ctod('  /  /  ') .and. !eof ()
              if Vcto >= dVctoIni .and. Vcto <= dVctoFin
                rTotalJuro  += ( VerJuro () )
                rTotalGeral += ( ( Valor - Desc ) + VerJuro() )
              endif  
 
              dbskip ()
            enddo      

            setcolor( CorCampo )
            @ 19,54 say rTotalJuro                 pict '@E 999,999.99'
            @ 19,65 say rTotalGeral                pict '@E 999,999.99'
          
            go nRegi
            oReceber:refreshAll()
          endif  
        endif
      case cTecla == K_ALT_J
        rTotalGeral := rSubTotal   := 0
        rTotalJuro  := rTotalLiqu  := 0
        
        if lCalcJuro 
          lCalcJuro := .f.
        else
          lCalcJuro := .t.
        endif    
                
        select ReceARQ
        set order to 5
        dbseek( rClie, .t. )
        do while Clie == rClie .and. !eof()
          if empty( Pgto )
            rTotalLiqu  += ( Valor - Desc )
            rTotalJuro  += ( VerJuro() )
            rTotalGeral += ( ( Valor - Desc ) + VerJuro() )
          
            if Marc == "X"
              rSubTotal += ( ( Valor - Desc ) + VerJuro() )
            endif
          endif  
          dbskip ()
        enddo      

        setcolor( CorCampo )
        @ 19,15 say rSubTotal                  pict '@E 999,999.99'
        @ 19,43 say rTotalLiqu                 pict '@E 999,999.99'
        @ 19,54 say rTotalJuro                 pict '@E 999,999.99'
        @ 19,65 say rTotalGeral                pict '@E 999,999.99'
        
        oReceber:goTop ()
        oReceber:refreshAll()
      case cTecla == K_ALT_V;      EntrValo ()
        rTotalGeral := rSubTotal   := 0
        rTotalJuro  := rTotalLiqu  := 0
        
        select ReceARQ
        set order to 5
        dbseek( rClie, .t. )
        do while Clie == rClie .and. !eof()
          if empty( Pgto )
            rTotalLiqu  += ( Valor - Desc )
            rTotalJuro  += ( VerJuro() )
            rTotalGeral += ( ( Valor - Desc ) + VerJuro() )
          
            if Marc == "X"
              rSubTotal += ( ( Valor - Desc ) + VerJuro() )
            endif
          endif  
          dbskip ()
        enddo      

        setcolor( CorCampo )
        @ 19,15 say rSubTotal                  pict '@E 999,999.99'
        @ 19,43 say rTotalLiqu                 pict '@E 999,999.99'
        @ 19,54 say rTotalJuro                 pict '@E 999,999.99'
        @ 19,65 say rTotalGeral                pict '@E 999,999.99'
        
        oReceber:goTop ()
        oReceber:refreshAll()
      case cTecla == K_ALT_A;   tReceTela   := savescreen( 00, 00, 22, 79 )
        keyboard( chr(13) )
        keyboard( chr(13) )
        keyboard( chr(13) )
      
        Rcto(.t.)

        rTotalGeral := rSubTotal   := 0
        rTotalJuro  := rTotalLiqu  := 0
        lCalcJuro   := .t.

        restscreen( 00, 00, 22, 79, tReceTela )

        select ReceARQ
        set order to 5
        dbseek( rClie, .t. )
    
        do while Clie == rClie .and. !eof()
          if empty( Pgto )
            rTotalLiqu  += ( Valor - Desc )
            rTotalJuro  += ( VerJuro() )
            rTotalGeral += ( ( Valor - Desc ) + VerJuro() )
          
            if Marc == "X"
              rSubTotal += ( ( Valor - Desc ) + VerJuro() )
            endif
          endif
            
          dbskip ()
        enddo      

        setcolor( CorCampo )
        @ 19,15 say rSubTotal                  pict '@E 999,999.99'
        @ 19,43 say rTotalLiqu                 pict '@E 999,999.99'
        @ 19,54 say rTotalJuro                 pict '@E 999,999.99'
        @ 19,65 say rTotalGeral                pict '@E 999,999.99'
        
        oReceber:gotop()           
        oReceber:refreshAll()

        lExitRequested := .f.
      case cTecla == K_ALT_R
        if RegLock()
          replace Marc        with "X"
          dbunlock()
        endif  
      
        PrinRcbo (.f.)
        
        rTotalGeral := rSubTotal   := 0
        rTotalJuro  := rTotalLiqu  := 0
        lCalcJuro   := .t.
        
        select ReceARQ
        set order to 5
        dbseek( rClie, .t. )
        do while Clie == rClie .and. !eof()
          if empty( Pgto )
            rTotalLiqu  += ( Valor - Desc )
            rTotalJuro  += ( VerJuro() )
            rTotalGeral += ( ( Valor - Desc ) + VerJuro() )
           
            if Marc == "X"
              rSubTotal += ( ( Valor - Desc ) + VerJuro() )
            endif
          endif  
      
          dbskip ()
        enddo      

        setcolor( CorCampo )
        @ 19,15 say rSubTotal                  pict '@E 999,999.99'
        @ 19,43 say rTotalLiqu                 pict '@E 999,999.99'
        @ 19,54 say rTotalJuro                 pict '@E 999,999.99'
        @ 19,65 say rTotalGeral                pict '@E 999,999.99'

        select ReceARQ
        set order to 5
        dbseek( rClie, .t. )
        
        oReceber:gotop()           
        oReceber:refreshAll()

        lExitRequested := .f.
      case cTecla == K_SPACE
        if ReceARQ->Marc == ' '
          rSubTotal += ( ( Valor - Desc ) + VerJuro() )
        else  
          rSubTotal -= ( ( Valor - Desc ) + VerJuro() )

          if rSubTotal < 0
            rSubTotal := 0
          endif  
        endif  

        if RegLock()
          if ReceARQ->Marc == ' '
            replace Marc      with "X"
          else
            replace Marc      with ' '
          endif    
          dbunlock ()
        endif  
        
        setcolor( CorCampo )
        @ 19,15 say rSubTotal                  pict '@E 999,999.99'
        
        oReceber:refreshAll()
    endcase
  enddo  
  
  select ReceARQ
  set order to 8
  dbgotop()
  do while .t.
    dbseek( rClie + "X", .f. )
    
    if found () 
      if RegLock()
        replace Marc         with space(01)
        dbunlock ()
      endif
    else
      exit
    endif    
  enddo      
  
  if tOpenRece 
    select ReceARQ
    close
  endif  
  
  if tOpenPort 
    select PortARQ
    close
  endif  
  
  if tOpenCobr 
    select CobrARQ
    close
  endif  
  
  if tOpenRepr 
    select ReprARQ
    close
  endif  
    
  select ClieARQ
  set order to 2
  dbseek( rNome, .f. )
  
  setcolor( cCorAtual )
  restscreen( 00, 00, 23, 79, tTelaRcto )
return NIL

function DescConsRece()
  iif( nPerC > 0, ( nDesconto := Valor * nPerC / 100 ), nDesconto := 0 )
return(.t.)

//
//  Consulta de Contas a Pagar - Fornecedores
//
function ConsPaga ()

  if NetUse( "PagaARQ", .t. )
    VerifIND( "PagaARQ" )
  
    pAbriPaga := .t.
  
    #ifdef DBF_NTX
      set index to PagaIND1, PagaIND2, PagaIND3, PagaIND4, PagaIND5, PagaIND6
    #endif  
  else
    pAbriPaga := .f.  
  endif
  
  cCorAtual   := setcolor()
  dData       := dtos( ctod('  /  /   ') )
  iForn       := FornARQ->Forn
  iNome       := FornARQ->Nome
  nTotalGeral := 0
  dVctoIni    := ctod( '01/01/1990' )
  dVctoFin    := ctod( '31/12/2015' )
  tTelaRcto   := savescreen( 00, 00, 23, 79 )
  
  if EmprARQ->Periodo == "X"
    Janela( 09, 24, 13, 50, mensagem( 'Janela', 'Periodo', .f. ), .f. )
    Mensagem( 'LEVE', 'Periodo' )

    setcolor( CorJanel )
    @ 11,26 say 'Vcto. Inicial'
    @ 12,26 say '  Vcto. Final'
  
    @ 11,40 get dVctoIni      pict '99/99/9999'
    @ 12,40 get dVctoFin      pict '99/99/9999' valid dVctoFin >= dVctoIni
    read
   
    if lastkey() == K_ESC
      if pAbriPaga
        select PagaARQ
        close
      endif  

      select FornARQ
      set order to 2
      dbseek( iNome, .f. )
  
      restscreen( 00, 00, 23, 79, tTelaRcto )
      return NIL
    endif  
  endif  
  
  select PagaARQ
  set order  to 4
  dbseek( iForn + dtos( dVctoIni ), .t. )
  do while Forn == iForn .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin .and. !eof ()
    if empty( Pgto )
      if Vcto < date() .and. Juro == 0
        nJuro := ( date() - Vcto ) * ( ( Valor - Desc ) * ( Acre / 30 ) / 100 )
      else
        nJuro := Juro
      endif

      nTotalGeral += ( ( Valor - Desc ) + nJuro )
    endif  

    dbskip ()
  enddo      
  
  if nTotalGeral == 0
    Alerta( mensagem( 'Alerta', 'ConsPaga', .f. ) )  

    if pAbriPaga
      select PagaARQ
      close
    endif  

    select FornARQ
    set order to 2
    dbseek( iNome, .f. )
    
    restscreen( 00, 00, 23, 79, tTelaRcto )
    return NIL
  endif  

  Janela ( 03, 02, 20, 73, mensagem( 'Janela', 'ConsPaga', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )

  select PagaARQ
  set order to 4
  bFirst := {|| dbseek( iForn + dtos( dVctoIni ), .t. ) }
  bLast  := {|| dbseek( iForn + dtos( dVctoFin ), .t. ), dbskip(-1) }
  bFor   := {|| Forn == iForn .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin .and. Pgto == ctod('  /  /  ') } 
  bWhile := {|| Forn == iForn }
  
  oPagar           := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oPagar:nTop      := 7
  oPagar:nLeft     := 3
  oPagar:nBottom   := 18
  oPagar:nRight    := 72
  oPagar:headsep   := chr(194)+chr(196)
  oPagar:colsep    := chr(179)
  oPagar:footsep   := chr(193)+chr(196)
  oPagar:colorSpec := CorJanel

  oPagar:addColumn( TBColumnNew(" ",     {|| Marc } ) )
  oPagar:addColumn( TBColumnNew("Nota",  {|| transform( val( Nota ), '9999999999-99' ) } ) )
  oPagar:addColumn( TBColumnNew("Emis.", {|| Emis } ) )
  oPagar:addColumn( TBColumnNew("Vcto.", {|| Vcto } ) )
  oPagar:addColumn( TBColumnNew("Valor", {|| transform( Valor, '@E 999,999.99' ) } ) )
  oPagar:addColumn( TBColumnNew("Juros", {|| transform( iif( Vcto < date() .and. Juro == 0, ( date() - Vcto ) * (  ( Valor - Desc ) * ( Acre / 30 ) / 100 ), Juro ), '@E 9,999.99' ) } ) )
  oPagar:addColumn( TBColumnNew("Total", {|| transform( Valor + iif( Vcto < date() .and. Juro == 0, ( date() - Vcto ) * (  ( Valor - Desc ) * ( Acre / 30 ) / 100 ), Juro ), '@E 999,999.99' ) } ) )

  oPagar:refreshAll ()
  
  lAdiciona      := .f.
  lMais          := .t.
  lExitRequested := .f.
  nLinBarra      := 1
  nSubTotal      := 0
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 8, 18, 73, nTotal )
  
  setcolor( CorJanel + ',' + CorCampo )
  @ 08,02 say chr(195)
  @ 18,02 say chr(195)
  @ 05,10 say 'Fornec.'
  @ 19,10 say 'Sub-Total'
  @ 19,44 say 'Total Geral'
  
  setcolor( CorCampo )
  @ 05,18 say iForn
  @ 05,25 say FornARQ->Nome
  @ 19,20 say nSubTotal                  pict '@E 999,999.99'
  @ 19,56 say nTotalGeral                pict '@E 999,999.99'

  do while !lExitRequested
    Mensagem( 'Cons', 'ConsPaga' )
    
    oPagar:forcestable() 

    PosiDBF( 03, 73 )

    iif( BarraSeta, BarraSeta( nLinBarra, 8, 18, 73, nTotal ), NIL )
    
    if oPagar:stable
      if oPagar:hitTop .or. oPagar:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oPagar:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oPagar:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oPagar:down()
      case cTecla == K_UP;         oPagar:up()
      case cTecla == K_PGDN;       oPagar:pageDown()
      case cTecla == K_PGUP;       oPagar:pageUp()
      case cTecla == K_LEFT;       oPagar:left()
      case cTecla == K_RIGHT;      oPagar:right()
      case cTecla == K_CTRL_PGUP;  oPagar:goTop()
      case cTecla == K_CTRL_PGDN;  oPagar:gobottom()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_ALT_P
        nTotalGeral := 0
        nSubTotal   := 0
       
        select PagaARQ
        set order to 4
        dbseek( iForn + dtos( dVctoIni ), .t. )
        do while Forn == iForn .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin .and. !eof ()
          if Marc == space(01)
            dbskip ()
            loop
          endif  
          
          if Pgto == ctod('  /  /  ')
            if RegLock()
              replace Pgto       with date()
              replace Pago       with ( Valor - Desc ) + Juro 
              dbunlock ()
            endif
          endif  
       
          dbskip ()
        enddo
        
        nSubTotal   := 0
        nTotalGeral := 0
   
        dbseek( iForn + dtos( dVctoIni ), .t. )
        do while Forn == iForn .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin .and. !eof ()
          if Pgto == ctod('  /  /  ')
            if Vcto < date() .and. Juro == 0
              nJuro := ( date() - Vcto ) * ( ( Valor - Desc ) * ( Acre / 30 ) / 100 )
            else
              nJuro := Juro
            endif
          
            nTotalGeral += ( Valor - Desc ) + nJuro 
          endif  

          dbskip ()
        enddo      

        setcolor( CorCampo )
        @ 19,20 say nSubTotal                  pict '@E 999,999.99'
        @ 19,56 say nTotalGeral                pict '@E 999,999.99'
        
        oPagar:refreshAll()
      case cTecla == K_ENTER .or. cTecla == K_ALT_A 
        tPagaTela := savescreen( 00, 00, 22, 79 )

        Pgto(.t.)

        restscreen( 00, 00, 22, 79, tPagaTela )
        
        nSubTotal   := 0
        nTotalGeral := 0

        select PagaARQ
        set order to 4
        dbseek( iForn + dtos( dVctoIni ), .t. )
        do while Forn == iForn .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin .and. !eof ()
          if Pgto == ctod('  /  /  ')
            if Vcto < date() .and. Juro == 0
              nJuro := ( date() - Vcto ) * ( ( Valor - Desc ) * ( Acre / 30 ) / 100 )
            else
              nJuro := Juro
            endif
          
            if !empty( Marc )
              nSubTotal += ( Valor - Desc ) + nJuro 
            endif  
          
            nTotalGeral += ( Valor - Desc ) + nJuro 
          endif  

          dbskip ()
        enddo      

        setcolor( CorCampo )
        @ 19,20 say nSubTotal                  pict '@E 999,999.99'
        @ 19,56 say nTotalGeral                pict '@E 999,999.99'

        oPagar:gotop()
        oPagar:refreshAll()

        lExitRequested := .f.
      case cTecla == K_SPACE
        if RegLock()
          if PagaARQ->Marc == ' '
            replace Marc      with "X"
     
            if Vcto < date() .and. Juro == 0
               nJuro := ( date() - Vcto ) * ( ( Valor - Desc ) * ( Acre / 30 ) / 100 )
             else
               nJuro := Juro
             endif
          
             nSubTotal += ( Valor - Desc ) + nJuro 
          else
            replace Marc      with ' '
     
            if Vcto < date() .and. Juro == 0
               nJuro := ( date() - Vcto ) * ( ( Valor - Desc ) * ( Acre / 30 ) / 100 )
             else
               nJuro := Juro
             endif
          
             nSubTotal -= ( Valor - Desc ) + nJuro 
          endif    
          dbunlock ()
        endif  
        
        setcolor( CorCampo ) 
        @ 19,20 say nSubTotal                  pict '@E 999,999.99'
        
        oPagar:refreshAll()
    endcase
  enddo  
  
  select PagaARQ
  set order to 6
  dbgotop()
  do while .t.
    dbseek( "X", .f. )
    
    if found () 
      if RegLock()
        replace Marc         with space(01)
        dbunlock ()
      endif
    else
      exit
    endif    
  enddo      
  
  if pAbriPaga
    select PagaARQ
    close
  endif  
  
  select FornARQ
  set order to 2
  dbseek( iNome, .f. ) 
  
  setcolor( cCorAtual )
  restscreen( 00, 00, 23, 79, tTelaRcto )
return NIL

//
//  Consulta de Contas a Receber Pagas - Clientes
//
function ConsRcbo ()

  cCorAtual   := setcolor()

  if NetUse( "ReceARQ", .t. )
    VerifIND( "ReceARQ" )
   
    tOpenRece := .t.

    #ifdef DBF_NTX
      set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
    #endif  
  else
    tOpenRece := .f.
  endif
  
  dPgtoIni    := ctod('01/01/1990') 
  dPgtoFin    := ctod('31/12/2015') 
  uClie       := ClieARQ->Clie
  uNome       := ClieARQ->Nome
  nTotalJuro  := nTotalValor := 0
  nTotalGeral := nSubTotal   := 0
  dPgtoIni    := ctod( '01/01/1990' )
  dPgtoFin    := ctod( '31/12/2015' )
  tTelaRcto   := savescreen( 00, 00, 23, 79 )

  if EmprARQ->Periodo == "X"
    Janela( 09, 24, 13, 50, mensagem( 'Janela', 'Periodo', .f. ), .f. )
    Mensagem( 'LEVE', 'Periodo' )
  
    setcolor( CorJanel )
    @ 11,26 say 'Pgto. Inicial'
    @ 12,26 say '  Pgto. Final'
  
    @ 11,40 get dPgtoIni      pict '99/99/9999'
    @ 12,40 get dPgtoFin      pict '99/99/9999' valid dPgtoFin >= dPgtoIni
    read
  
    if lastkey() == K_ESC
      restscreen( 00, 00, 23, 79, tTelaRcto ) 
      if tOpenRece 
        select ReceARQ
        close
      endif  
  
      select ClieARQ
      set order to 2
      dbseek( uNome, .f. )

      return NIL
    endif  
  endif  
  
  select ClieARQ
  set order to 1
  dbseek( uClie, .f. )
    
  select ReceARQ
  set order to 5
  dbseek( uClie + dtos( dPgtoIni ), .t. )
  
  do while Clie == uClie .and. !eof ()
    if Pgto >= dPgtoIni .and. Pgto <= dPgtoFin
      nTotalValor += Valor
      nTotalJuro  += Juro
      nTotalGeral += Pago
    endif  

    dbskip ()
  enddo      
  
  if nTotalGeral == 0
    Alerta( mensagem( 'Alerta', 'ConsRcbo', .f. ) )
  
    if tOpenRece 
      select ReceARQ
      close
    endif  
  
    select ClieARQ
    set order to 2
    dbseek( uNome, .f. )

    return NIL
  endif  

  Janela ( 03, 01, 20, 78, mensagem( 'Janela', 'ConsRcbo', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )

  select ReceARQ
  set order to 5
  bFirst := {|| dbseek( uClie + dtos( dPgtoIni ), .t. ) }
  bLast  := {|| dbseek( uClie + dtos( dPgtoFin ), .t. ), dbskip(-1) }
  bFor   := {|| Clie == uClie .and. Pgto >= dPgtoIni .and. Pgto <= dPgtoFin }
  bWhile := {|| Clie == uClie .and. Pgto >= dPgtoIni .and. Pgto <= dPgtoFin }
  
  oColun          := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oColun:nTop     := 7
  oColun:nLeft    := 2
  oColun:nBottom  := 18
  oColun:nRight   := 77
  oColun:headsep  := chr(194)+chr(196)
  oColun:colsep   := chr(179)
  oColun:footsep  := chr(193)+chr(196)

  oColun:addColumn( TBColumnNew("Nota",  {|| transform( val( Nota ), '999999-99' ) } ) )
  oColun:addColumn( TBColumnNew("Tipo",  {|| iif( Tipo == 'P', 'Pedido', iif( Tipo == 'N', 'Nota  ','O.S.  ' ) ) } ) )
  oColun:addColumn( TBColumnNew("Emis.", {|| Emis } ) )
  oColun:addColumn( TBColumnNew("Vcto.", {|| Vcto } ) ) 
  oColun:addColumn( TBColumnNew("Pgto.", {|| Pgto } ) )
  oColun:addColumn( TBColumnNew("Valor", {|| transform( Valor, '@E 9,999.99' ) } ) )
  oColun:addColumn( TBColumnNew("Juros", {|| transform( Juro, '@E 9,999.99' ) } ) )
  oColun:addColumn( TBColumnNew("Pago",  {|| transform( Pago, '@E 9,999.99' ) } ) )
              
  lAdiciona      := .f.
  lMais          := .t.
  lExitRequested := .f.
  nLinBarra      := 1
  cSequ          := space(2)
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 8, 18, 78, nTotal )
  
  setcolor( CorJanel + ',' + CorCampo )
  @ 05,10 say 'Cliente'
  @ 08,01 say chr(195)
  @ 18,01 say chr(195)
  @ 19,33 say 'Total Geral'
  
  setcolor( CorCampo )
  @ 05,18 say uClie
  if uClie == '999999'
    @ 05,25 say Cliente
  else  
    @ 05,25 say ClieARQ->Nome
  endif  
  @ 19,45 say nTotalValor                pict '@E 999,999.99'
  @ 19,56 say nTotalJuro                 pict '@E 999,999.99'
  @ 19,67 say nTotalGeral                pict '@E 999,999.99'

  oColun:refreshAll()

  do while !lExitRequested
    Mensagem( '<ALT+A> Alterar, <ESC> Retornar.' )
  
    oColun:forcestable() 

    PosiDBF( 03, 78 )

    iif( BarraSeta, BarraSeta( nLinBarra, 8, 18, 78, nTotal ), NIL )
    
    if oColun:stable
      if oColun:hitTop .or. oColun:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oColun:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oColun:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oColun:down()
      case cTecla == K_UP;         oColun:up()
      case cTecla == K_PGDN;       oColun:pageDown()
      case cTecla == K_PGUP;       oColun:pageUp()
      case cTecla == K_CTRL_PGUP;  oColun:goTop()
      case cTecla == K_CTRL_PGDN;  oColun:gobottom()
      case cTecla == K_LEFT;       oColun:left()
      case cTecla == K_RIGHT;      oColun:right()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_ENTER;      lExitRequested := .t.
      case cTecla == K_ALT_A;      tAlterar := savescreen( 00, 00, 23, 79 )
        Rcto(.f.)
  
        nTotalValor := nTotalJuro  := 0
        nTotalGeral := 0
        
        select ReceARQ
        set order to 5
        dbseek( uClie + dtos( dPgtoIni ), .t. )
        do while Clie == uClie .and. !eof ()
          if Pgto >= dPgtoIni .and. Pgto <= dPgtoFin
            nTotalValor += Valor
            nTotalJuro  += Juro
            nTotalGeral += Pago
          endif  

          dbskip ()
        enddo      
        
        restscreen( 00, 00, 23, 79, tAlterar )
  
        setcolor( CorCampo )
        @ 19,45 say nTotalValor                pict '@E 999,999.99'
        @ 19,56 say nTotalJuro                 pict '@E 999,999.99'
        @ 19,67 say nTotalGeral                pict '@E 999,999.99'
        
        oColun:gotop()
        oColun:refreshAll()     
     endcase
  enddo  
  
  if tOpenRece 
    select ReceARQ
    close
  endif  
  
  select ClieARQ
  set order to 2
  dbseek( uNome, .f. )
  
  setcolor( cCorAtual )
  restscreen( 00, 00, 23, 79, tTelaRcto )
return NIL

//
// Mostra os Fornecedores
//
function ConsForn(xlPara)

  cArquivo  := alias()  
  tMostra   := savescreen( 00, 00, 24, 79 )

  if NetUse( "FornARQ", .t. )
    VerifIND( "FornARQ" )

    lAbriForn := .t.

    #ifdef DBF_NTX
      set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
    #endif  
  else
    lAbriForn := .f.  
  endif

  select FornARQ
  set order to 2
  dbgotop()

  Janela( 03, 02, 20, 76, mensagem( 'Janela', 'ConsForn', .f. ), .f. ) 
  setcolor ( CorJanel + ',' + CorCampo )

  oFornec         := TBrowseDb( 05, 03, 18, 75 )
  oFornec:headsep := chr(194)+chr(196)
  oFornec:footsep := chr(193)+chr(196)
  oFornec:colsep  := chr(179)

  oFornec:addColumn( TBColumnNew("Codigo",       {|| Forn } ) )
  oFornec:addColumn( TBColumnNew("Nome",         {|| left( Nome, 28 ) } ) )
  oFornec:addColumn( TBColumnNew("Telefone",     {|| left( Fone, 14 ) } ) ) 
  oFornec:addColumn( TBColumnNew("Endereço",     {|| left( Ende, 21 ) } ) )
  oFornec:addColumn( TBColumnNew("Bairro",       {|| left( Bairro, 15 ) } ) )
  oFornec:addColumn( TBColumnNew("Cidade",       {|| left( Cida, 15 ) } ) )
  oFornec:addColumn( TBColumnNew("CNPJ",         {|| transform( CGC, '@R 99.999.999/9999-99' ) } ) )
            
  lExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ''
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 06, 18, 76, nTotal )
    
  oFornec:freeze := 1
  oFornec:colPos := 2
   
  setcolor ( CorCampo )
  @ 19,16 say space(40)
    
  setcolor( CorJanel + ',' + CorCampo )
  @ 06,02 say chr(195)
  @ 18,02 say chr(195)
  @ 19,07 say 'Consulta'

  do while !lExitRequested
    Mensagem( 'Cons', 'ConsForn' )

    oFornec:forcestable()

    PosiDBF( 03, 76 )
    
    iif( BarraSeta, BarraSeta( nLinBarra, 06, 18, 76, nTotal ), NIL )

    if oFornec:stable
      if oFornec:hitTop .or. oFornec:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
 
    do case
      case cTecla == K_DOWN;        oFornec:down()
      case cTecla == K_UP;          oFornec:up()
      case cTecla == K_PGDN;        oFornec:pageDown()
      case cTecla == K_PGUP;        oFornec:pageUp()
      case cTecla == K_CTRL_PGUP;   oFornec:goTop()
      case cTecla == K_CTRL_PGDN;   oFornec:goBottom()
      case cTecla == K_RIGHT;       oFornec:right()
      case cTecla == K_LEFT;        oFornec:left()
      case cTecla == K_HOME;        oFornec:home()
      case cTecla == K_END;         oFornec:end()
      case cTecla == K_CTRL_LEFT;   oFornec:panLeft()
      case cTecla == K_CTRL_RIGHT;  oFornec:panRight()
      case cTecla == K_CTRL_HOME;   oFornec:panHome()
      case cTecla == K_CTRL_END;    oFornec:panEnd()
      case cTecla == K_ESC;         lExitRequested := .t.
      case cTecla == K_ENTER
        if xlPara == NIL
          lOK            := .t.
          lExitRequested := .t.
        else
        endif  
      case cTecla == K_ALT_A;       tAlte := savescreen( 00, 00, 23, 79 )
        Forn (.t.)

        restscreen( 00, 00, 23, 79, tAlte )

        setcolor ( CorCampo )
        @ 19,16 say space(40)
        
        select FornARQ
        set order to 2
        dbseek( FornARQ->Nome, .f. )
        
        lExitRequested := .f.
        cLetra         := ''

        oFornec:refreshAll()
      case cTecla == K_INS;        tAlte := savescreen( 00, 00, 23, 79 )
        Forn (.f.)

        restscreen( 00, 00, 23, 79, tAlte )

        setcolor ( CorCampo )
        @ 19,16 say space(40)
        
        select FornARQ
        set order to 2
        dbseek( FornARQ->Nome, .f. )

        lExitRequested := .f.
        cLetra         := ''

        oFornec:refreshAll()
      case cTecla == K_ALT_P;        ConsPaga()
        oFornec:refreshAll()

        lExitRequested := .f.
      case cTecla == K_ALT_G;        ConsPgto()
        oFornec:refreshAll()

        lExitRequested := .f.
      case cTecla == K_ALT_N;        ConsEnot ()
        oFornec:refreshAll()

        lExitRequested := .f.
      case cTecla == K_BS
        cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
      
        setcolor ( CorCampo )
        @ 19,16 say space(40)
        @ 19,16 say cLetra
      case cTecla >= 32 .and. cTecla <= 128
        lLetra := .f.
      
        do case
          case oFornec:ColPos == 1;      lLetra := .t.   
            set order to 1
          case oFornec:ColPos == 2;      lLetra := .t.     
            set order to 2
          case oFornec:ColPos == 4;      lLetra := .t.     
            set order to 3
          case oFornec:ColPos == 5;      lLetra := .t.      
            set order to 5
          case oFornec:ColPos == 6;      lLetra := .t.      
            set order to 4
          case oFornec:ColPos == 7;      lLetra := .t.      
            set order to 6
        endcase
        
        if lLetra 
          cLetra += chr( cTecla )    
        endif  

        if len( cLetra ) > 40
          cLetra := ''
        endif  
     
        setcolor ( CorCampo )
        @ 19,16 say space(40)
        @ 19,16 say cLetra

        dbseek( cLetra, .t. )
        oFornec:refreshAll()
    endcase

    select FornARQ
  enddo

  if lAbriForn 
    select FornARQ
    close
  endif  

  restscreen( 00, 00, 24, 79, tMostra )
return NIL

//
//  Consulta de Contas a Pagas - Fornecedores
//
function ConsPgto ()

  if NetUse( "PagaARQ", .t. )
    VerifIND( "PagaARQ" )
  
    pAbriPaga := .t.
  
    #ifdef DBF_NTX
      set index to PagaIND1, PagaIND2, PagaIND3, PagaIND4, PagaIND5, PagaIND6
    #endif  
  else
    pAbriPaga := .f.  
  endif
  
  cCorAtual   := setcolor()
  gForn       := FornARQ->Forn
  gNome       := FornARQ->Nome
  nTotalGeral := 0
  dVctoIni    := ctod( '01/01/1990' )
  dVctoFin    := ctod( '31/12/2015' )
  tTelaRcto   := savescreen( 00, 00, 23, 79 )
  
  if EmprARQ->Periodo == "X"
    Janela( 09, 24, 13, 50, mensagem( 'Janela', 'Periodo', .f. ), .f. )
    Mensagem( 'LEVE', 'Periodo' )
  
    setcolor( CorJanel )
    @ 11,26 say 'Pgto. Inicial'
    @ 12,26 say '  Pgto. Final'
  
    @ 11,40 get dVctoIni      pict '99/99/9999'
    @ 12,40 get dVctoFin      pict '99/99/9999' valid dVctoFin >= dVctoIni
    read
   
    if lastkey() == K_ESC
      if pAbriPaga
        select PagaARQ
        close
      endif  

      select FornARQ
      set order to 2
      dbseek( gNome, .f. )

      restscreen( 00, 00, 23, 79, tTelaRcto )
      return NIL
    endif  
  endif  

  select PagaARQ
  set order to 5
  dbseek( gForn + dtos( dVctoIni ), .t. )
  do while Forn == gForn .and. Pgto >= dVctoIni .and. Pgto <= dVctoFin .and. !empty( Pgto ) .and. !eof ()
    nTotalGeral += Pago

    dbskip ()
  enddo      
  
  if nTotalGeral == 0
    Alerta( mensagem( 'Alerta', 'ConsPgto', .f. ) )

    if pAbriPaga
      select PagaARQ
      close
    endif  

    select FornARQ
    set order to 2
    dbseek( gNome, .f. )
   
    restscreen( 00, 00, 23, 79, tTelaRcto )
    return NIL
  endif  
               
  tTelaRcto := savescreen( 00, 00, 23, 79 )

  Janela ( 03, 01, 20, 77, mensagem( 'Janela', 'ConsPgto', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )

  select PagaARQ
  set order to 5
  bFirst := {|| dbseek( gForn + dtos( dVctoIni ), .t. ) }
  bLast  := {|| dbseek( gForn + dtos( dVctoFin ), .t. ), dbskip(-1) }
  bFor   := {|| Forn == gForn .and. Pgto >= dVctoIni .and. Pgto <= dVctoFin .and. Pgto != ctod('  /  /  ') } 
  bWhile := {|| Forn == gForn .and. Pgto != ctod('  /  /  ') }
  
  oPagar           := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oPagar:nTop      := 7
  oPagar:nLeft     := 2
  oPagar:nBottom   := 18
  oPagar:nRight    := 76
  oPagar:headsep   := chr(194)+chr(196)
  oPagar:colsep    := chr(179)
  oPagar:footsep   := chr(193)+chr(196)
  oPagar:colorSpec := CorJanel

  oPagar:addColumn( TBColumnNew("Nota",  {|| transform( val( Nota ), '9999999999-99' ) } ) )
  oPagar:addColumn( TBColumnNew("Emis.", {|| Emis } ) )
  oPagar:addColumn( TBColumnNew("Vcto.", {|| Vcto } ) )
  oPagar:addColumn( TBColumnNew("Pgto.", {|| Pgto } ) )
  oPagar:addColumn( TBColumnNew("Valor", {|| transform( Valor, '@E 9,999.99' ) } ) )
  oPagar:addColumn( TBColumnNew("Juros", {|| transform( Juro, '@E 9,999.99' ) } ) )
  oPagar:addColumn( TBColumnNew("Pago",  {|| transform( Pago, '@E 9,999.99' ) } ) )
              
  oPagar:refreshAll ()
  
  lAdiciona      := .f.
  lMais          := .t.
  lExitRequested := .f.
  nLinBarra      := 1
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 8, 18, 77, nTotal )
  
  setcolor( CorJanel + ',' + CorCampo )
  @ 08,01 say chr(195)
  @ 18,01 say chr(195)
  @ 05,10 say 'Fornec.'
  @ 19,44 say 'Total Geral'
  
  setcolor( CorCampo )
  @ 05,18 say gForn
  @ 05,25 say FornARQ->Nome
  @ 19,56 say nTotalGeral                pict '@E 999,999.99'

  do while !lExitRequested
    Mensagem( 'Cons', 'ConsPgto' )
    
    oPagar:forcestable() 

    PosiDBF( 03, 77 )

    iif( BarraSeta, BarraSeta( nLinBarra, 8, 18, 77, nTotal ), NIL )
    
    if oPagar:stable
      if oPagar:hitTop .or. oPagar:hitBottom
        tone( 125, 0 )        
      endif  
      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oPagar:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oPagar:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oPagar:down()
      case cTecla == K_UP;         oPagar:up()
      case cTecla == K_PGDN;       oPagar:pageDown()
      case cTecla == K_PGUP;       oPagar:pageUp()
      case cTecla == K_CTRL_PGUP;  oPagar:goTop()
      case cTecla == K_CTRL_PGDN;  oPagar:gobottom()
      case cTecla == K_LEFT;       oPagar:left()
      case cTecla == K_RIGHT;      oPagar:right()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_ENTER;      tPagaTela := savescreen( 00, 00, 22, 79 )
        Pgto(.t.)

        restscreen( 00, 00, 22, 79, tPagaTela )
        
        nTotalGeral := 0

        select PagaARQ
        set order to 5
        dbseek( gForn + dtos( dVctoIni ), .t. )
        do while Forn == gForn .and. Pgto >= dVctoIni .and. Pgto <= dVctoFin .and. !empty( Pgto ) .and. !eof ()
          nTotalGeral += ( Valor + Juro )

          dbskip ()
        enddo      

        setcolor( CorCampo )
        @ 19,56 say nTotalGeral                pict '@E 999,999.99'

        lExitRequested := .f.
    endcase
  enddo  
  
  if pAbriPaga
    select PagaARQ
    close
  endif  
  
  select FornARQ
  set order to 2
  dbseek( gNome, .f. )
  
  setcolor( cCorAtual )
  restscreen( 00, 00, 23, 79, tTelaRcto )
return NIL

//
// Mostra os Agenda
//
function ConsAgen()

  cArquivo  := alias()  
  tMostra   := savescreen( 00, 00, 24, 79 )

  if NetUse( "AgenARQ", .t. )
    VerifIND( "AgenARQ" )
  
    lAbriAgen := .t.

    #ifdef DBF_NTX
      set index to AgenIND1, AgenIND2, AgenIND3, AgenIND4, AgenIND5, AgenIND6
    #endif  
  else
    lAbriAgen := .f.  
  endif

  select AgenARQ
  set order to 2
  dbgotop ()

  Janela( 03, 02, 20, 76, mensagem( 'Janela', 'ConsAgen', .f. ), .f. ) 
  setcolor ( CorJanel + ',' + CorCampo )

  oAgenda         := TBrowseDb( 05, 03, 18, 75 )
  oAgenda:headsep := chr(194)+chr(196)
  oAgenda:footsep := chr(193)+chr(196)
  oAgenda:colsep  := chr(179)

  oAgenda:addColumn( TBColumnNew("Codigo",   {|| Agen } ) )
  oAgenda:addColumn( TBColumnNew("Nome",     {|| left( Nome, 31 ) } ) )
  oAgenda:addColumn( TBColumnNew("Telefone", {|| left( Fone, 14 ) } ) )
  oAgenda:addColumn( TBColumnNew("Obse",     {|| left( Obse, 18 ) } ) )
  oAgenda:addColumn( TBColumnNew("Endereço", {|| left( Ende, 35 ) } ) )
  oAgenda:addColumn( TBColumnNew("Bairro",   {|| left( Bair, 15 ) } ) )
  oAgenda:addColumn( TBColumnNew("Cidade",   {|| left( Cida, 15 ) } ) )
            
  lExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ''
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 06, 18, 76, nTotal )
    
  oAgenda:freeze := 1
  oAgenda:colPos := 2
   
  setcolor ( CorCampo )
  @ 19,16 say space(40)
    
  setcolor( CorJanel + ',' + CorCampo )
  @ 06,02 say chr(195)
  @ 18,02 say chr(195)
  @ 19,07 say 'Consulta'

  do while !lExitRequested
    Mensagem( 'Cons', 'ConsAgen' )

    oAgenda:forcestable()

    PosiDBF( 03, 76 )
    
    iif( BarraSeta, BarraSeta( nLinBarra, 06, 18, 76, nTotal ), NIL )

    if oAgenda:stable
      if oAgenda:hitTop .or. oAgenda:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
 
    do case
      case cTecla == K_DOWN;        oAgenda:down()
      case cTecla == K_UP;          oAgenda:up()
      case cTecla == K_PGDN;        oAgenda:pageDown()
      case cTecla == K_PGUP;        oAgenda:pageUp()
      case cTecla == K_CTRL_PGUP;   oAgenda:goTop()
      case cTecla == K_CTRL_PGDN;   oAgenda:goBottom()
      case cTecla == K_RIGHT;       oAgenda:right()
      case cTecla == K_LEFT;        oAgenda:left()
      case cTecla == K_HOME;        oAgenda:home()
      case cTecla == K_END;         oAgenda:end()
      case cTecla == K_CTRL_LEFT;   oAgenda:panLeft()
      case cTecla == K_CTRL_RIGHT;  oAgenda:panRight()
      case cTecla == K_CTRL_HOME;   oAgenda:panHome()
      case cTecla == K_CTRL_END;    oAgenda:panEnd()
      case cTecla == K_ESC;         lExitRequested := .T.
      case cTecla == K_ALT_A
        tAlte     := savescreen( 00, 00, 23, 79 )
        
        Agen (.t.)

        restscreen( 00, 00, 23, 79, tAlte )
        
        cLetra         := ''
        lExitRequested := .f.

        setcolor ( CorCampo )
        @ 19,16 say space(40)

        select AgenARQ
        set order to 2
        dbseek( AgenARQ->Nome, .f. )
        
        oAgenda:refreshAll()
      case cTecla == K_INS
        tAlte     := savescreen( 00, 00, 23, 79 )
        
        Agen (.f.)

        restscreen( 00, 00, 23, 79, tAlte )
        
        cLetra         := ''
        lExitRequested := .f.

        setcolor ( CorCampo )
        @ 19,16 say space(40)

        select AgenARQ
        set order to 2
        dbseek( AgenARQ->Nome, .f. )
        
        oAgenda:refreshAll()
      case cTecla == K_BS
        cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
      
        setcolor ( CorCampo )
        @ 19,16 say space(40)
        @ 19,16 say cLetra
      case cTecla >= 32 .and. cTecla <= 128
        lLetra := .f.         
        
        do case
          case oAgenda:ColPos == 1;      lLetra := .t.   
            set order to 1
          case oAgenda:ColPos == 2;      lLetra := .t.     
            set order to 2
          case oAgenda:ColPos == 3;      lLetra := .t.     
            set order to 6
          case oAgenda:ColPos == 4;      lLetra := .t.    
            set order to 4
          case oAgenda:ColPos == 5;      lLetra := .t.      
            set order to 3
          case oAgenda:ColPos == 6;      lLetra := .t.      
            set order to 5
        endcase
        
        if lLetra
          cLetra += chr( cTecla )    
        endif  

        if len( cLetra ) > 40
          cLetra := ''
        endif  
     
        setcolor ( CorCampo )
        @ 19,16 say space(40)
        @ 19,16 say cLetra

        dbseek( cLetra, .t. )
        oAgenda:refreshAll()
      case cTecla == K_ALT_F
        tPesquisa := savescreen( 00, 00, 23, 79 )
        Janela( 08, 13, 12, 69, mensagem( 'Janela', 'ConsAgen1', .f. ), .f. )
        Mensagem( 'Cons', 'ConsAgen2' )
        
        setcolor( CorCampo )
        @ 11,24 say space(30)

        setcolor( CorJanel )
        @ 10,15 say 'Pesquisa'
        @ 11,15 say '   Texto'
                
        aOpc   := {}
        cTexto := space(30)
        
        aadd( aOpc, { ' Começa com... ',  2, 'C', 10, 24, "Pesquisa Começa com o texto especificado." } )
        aadd( aOpc, { ' Possui... ',      2, 'P', 10, 40, "Pesquisa Possui o texto especificado." } )
        aadd( aOpc, { ' Termina com... ', 2, 'T', 10, 52, "Pesquisa Termina com o texto especificado." } )

        nTipo := HCHOICE( aOpc, 3, 2 )
        
        if lastkey() != K_ESC
          setcolor( CorJanel )
          @ 11,24 get cTexto             
          read
          
          PesqAgen( nTipo, cTexto )                       
        endif  

        lExitRequested := .f.   
        cLetra         := ''
        
        restscreen( 00, 00, 23, 79, tPesquisa )
    endcase
  enddo

  if lAbriAgen 
    select AgenARQ
    close
  endif  

  restscreen( 00, 00, 24, 79, tMostra )
return NIL

//
// Mostra os Cheques Cadastrados
//
function ConsChPr()
  
  cCorAtual := setcolor()
  tChPrTela := savescreen( 00, 00, 23, 79 )

  if NetUse( "ChPrARQ", .t. )
    VerifIND( "ChPrARQ" )
  
    gOpenChPr := .t.
   
    #ifdef DBF_NTX
      set index to ChPrIND1, ChPrIND2, ChPrIND3, ChPrIND4, ChPrIND5
    #endif  
  else  
    gOpenChPr := .f.
  endif

  if NetUse( "BancARQ", .t. )
    VerifIND( "BancARQ" )
  
    gOpenBanc := .t.

    #ifdef DBF_NTX
      set index to BancIND1, BancIND2
    #endif  
  else
    gOpenBanc := .f.
  endif

  if NetUse( "AgciARQ", .t. )
    VerifIND( "AgciARQ" )
  
    gOpenAgci := .t.

    #ifdef DBF_NTX
      set index to AgciIND1, AgciIND2
    #endif  
  else
    gOpenAgci := .f.
  endif
  
  xClie := ClieARQ->Clie
  xNome := ClieARQ->Nome
    
  select ChPrARQ
  set order to 5
  set relation to Banc into BancARQ, to Banc + Agci into AgciARQ,;
                  Clie into ClieARQ
  dbseek( xClie, .t. )
  
  if eof() .or. Clie != xClie
    Alerta( mensagem( 'Alerta', 'ConsChPr', .f. ) ) 
  
    if gOpenChPr
      select ChPrARQ
      close
    endif  

    if gOpenBanc
      select BancARQ
      close
    endif  
  
    if gOpenAgci
      select AgciARQ
      close
    endif  
  
    select ClieARQ
    set order to 2
    dbseek( xNome, .f. )
    return NIL
  else
    nDeposito := 0
    nVcto     := 0
    nVencidos := 0
    
    do while Clie == xClie
      if empty( Depo )
        if date () > Vcto
          nVencidos += Valo
        else   
          nVcto     += Valo
        endif  
      else  
        nDeposito += Valo
      endif  
      dbskip ()
    enddo
  endif  
  
  Janela ( 03, 01, 18, 77, mensagem( 'Janela', 'ConsChPr', .f. ), .f. )

  bFirst := {|| dbseek( xClie, .t. ) }
  bLast  := {|| dbseek( xClie, .t. ), dbskip(-1) }
  bFor   := {|| Clie == xClie }
  bWhile := {|| Clie == xClie }

  oCheque           := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oCheque:nTop      := 05
  oCheque:nLeft     := 02
  oCheque:nBottom   := 16
  oCheque:nRight    := 76
  oCheque:headsep   := chr(194)+chr(196)
  oCheque:colsep    := chr(179)
  oCheque:footsep   := chr(193)+chr(196)
  oCheque:colorSpec := CorJanel

  oCheque:addColumn( TBColumnNew("Data",      {|| Data } ) )
  oCheque:addColumn( TBColumnNew("Vcto.",     {|| Vcto } ) )
  oCheque:addColumn( TBColumnNew("Depo.",     {|| Depo } ) )
  oCheque:addColumn( TBColumnNew("Valor",     {|| transform( Valo, '@E 999,999.99' ) } ) )
  oCheque:addColumn( TBColumnNew("Cheque",    {|| Cheq } ) )
  oCheque:addColumn( TBColumnNew("Banco",     {|| Banc + ' ' + left( BancARQ->Nome, 16 ) } ) )
  oCheque:addColumn( TBColumnNew("Agência",   {|| Agci + ' ' + left( AgciARQ->Nome, 15 ) } ) )
  oCheque:addColumn( TBColumnNew("Historico", {|| Hist } ) )
  oCheque:addColumn( TBColumnNew("Destino",   {|| Dest } ) )
            
  oCheque:refreshAll ()
  
  lAdiciona      := .f.
  lMais          := .t.
  lExitRequested := .f.
  nLinBarra      := 1
  nTotal         := lastrec()
  cLetra         := ''
  BarraSeta      := BarraSeta( nLinBarra, 6, 16, 77, nTotal )

  setcolor( CorJanel + ',' + CorCampo )
  @ 17,03 say '   Depósito               Vencidos               A Vencer '
  @ 06,01 say chr(195)
  @ 16,01 say chr(195)

  setcolor( CorCampo )
  @ 17,15 say nDeposito                 pict '@E 999,999.99' 
  @ 17,38 say nVencidos                 pict '@E 999,999.99' 
  @ 17,61 say nVcto                     pict '@E 999,999.99' 

  do while !lExitRequested
    Mensagem( 'Cons', 'ConsChPr' )
    
    oCheque:forcestable() 

    PosiDBF( 03, 77 )

    iif( BarraSeta, BarraSeta( nLinBarra, 6, 16, 77, nTotal ), NIL )

    if oCheque:stable
      if oCheque:hitTop .or. oCheque:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oCheque:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oCheque:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oCheque:down()
      case cTecla == K_UP;         oCheque:up()
      case cTecla == K_PGDN;       oCheque:pageDown()
      case cTecla == K_PGUP;       oCheque:pageUp()
      case cTecla == K_CTRL_PGUP;  oCheque:goTop()
      case cTecla == K_CTRL_PGDN;  oCheque:gobottom()
      case cTecla == K_RIGHT;      oCheque:right()
      case cTecla == K_LEFT;       oCheque:left()
      case cTecla == K_HOME;       oCheque:home()
      case cTecla == K_END;        oCheque:end()
      case cTecla == K_CTRL_LEFT;  oCheque:panLeft()
      case cTecla == K_CTRL_RIGHT; oCheque:panRight()
      case cTecla == K_CTRL_HOME;  oCheque:panHome()
      case cTecla == K_CTRL_END;   oCheque:panEnd()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_ALT_A
        tAlterar := savescreen( 00, 00, 22, 79 )

        ChPr ()

        restscreen( 00, 00, 22, 79, tAlterar )

        nDeposito      := 0
        nVcto          := 0
        nVencidos      := 0
        lExitRequested := .f.

        select ChPrARQ
        set order to 5
        dbseek( xClie, .t. )
        do while Clie == xClie .and. !eof()
          if empty( Depo )
            if date () > Vcto
              nVencidos += Valo
            else   
              nVcto     += Valo
            endif  
          else  
            nDeposito += Valo
          endif  
          dbskip ()
        enddo

        setcolor( CorCampo )
        @ 17,15 say nDeposito                 pict '@E 999,999.99' 
        @ 17,38 say nVencidos                 pict '@E 999,999.99' 
        @ 17,61 say nVcto                     pict '@E 999,999.99' 
        
        dbseek( xClie, .t. )

        oCheque:refreshAll()
    endcase
  enddo  
  
  if gOpenChPr
    select ChPrARQ
    close
  endif  

  if gOpenBanc
    select BancARQ
    close
  endif  
  
  if gOpenAgci
    select AgciARQ
    close
  endif  
  
  select ClieARQ
  set order to 2
  dbseek( xNome, .f. )
  
  setcolor( cCorAtual )
  restscreen( 00, 00, 23, 79, tChPrTela )
return NIL

//
// Calcula o Juro e retorna ao browse
// 
function VerJuro ()
  if lCalcJuro
    if ( Vcto + EmprARQ->Dias ) < date() .and. Juro == 0 .and. empty( Pgto )
      nDias  := ( Vcto - date() )
      nMulta := ( ( Valor - Desc ) * EmprARQ->Multa ) / 100
  
      if nDias < 31
        nJuro := ( date() - Vcto ) * ( ( Valor - Desc ) * ( Acre / 30 ) / 100 ) + nMulta
      else  
        nMes   := int( nDias / 30 ) + 1
        nTotal := ( Valor - Desc )
        
        for nU := 1 to nMes
          nJurinho := ( nTotal * Acre ) / 100         
          nTotal   += nJurinho
        next
          
        nJuro := nTotal - ( Valor - Desc ) + nMulta
        
        if nJuro < 0
          nJuro := 0
        endif  
      endif
    else
      nJuro := Juro
    endif
  else
    nJuro := 0
  endif    
return( nJuro )

//
// Calcula o Juro e retorna ao browse o valor total
// 
function VerTotal ()
return( Valor + iif( Juro == 0, VerJuro (), Juro ) - Desc )

//
// Consulta Agenda com o texto especificado
//
function PesqAgen( pTipo, pTexto )

  aOpcoes   := aArqui      := {}
  cAgenARQ  := CriaTemp(0)
  cAgenIND1 := CriaTemp(1)

  aadd( aArqui, { "Agen",      "C", 006, 0 } )
  aadd( aArqui, { "Nome",      "C", 040, 0 } )
  aadd( aArqui, { "Nasc",      "D", 008, 0 } )
  aadd( aArqui, { "Ende",      "C", 035, 0 } )
  aadd( aArqui, { "Bair",      "C", 015, 0 } )
  aadd( aArqui, { "Cida",      "C", 020, 0 } )
  aadd( aArqui, { "Cep",       "N", 008, 0 } )
  aadd( aArqui, { "UF",        "C", 002, 0 } )
  aadd( aArqui, { "Fone",      "C", 014, 0 } )
  aadd( aArqui, { "Fax",       "C", 014, 0 } )
  aadd( aArqui, { "Obse",      "C", 132, 0 } )

  dbcreate( cAgenARQ , aArqui )

  select AgenARQ
  do case
     case oAgenda:ColPos == 1   
       cChave := 'Agen'

       set order to 1
     case oAgenda:ColPos == 2  
       cChave := 'Nome'

       set order to 2
     case oAgenda:ColPos == 3  
       cChave := 'Fone'

       set order to 6
     case oAgenda:ColPos == 4 
       cChave := 'Cida'

       set order to 4
     case oAgenda:ColPos == 5   
       cChave := 'Ende'

       set order to 3
     case oAgenda:ColPos == 6   
       cChave := 'Bair'

       set order to 5
  endcase
   
  if NetUse( cAgenARQ, .f., 30 )
    cAgenTMP := alias ()
    
    index on &cChave to &cAgenIND1

    #ifdef DBF_NTX
    set index to &cAgenIND1
    #endif  
  endif
  
  pTexto := alltrim( pTexto )
  nLen   := len( pTexto ) 

  Janela( 08, 22, 13, 55, mensagem( 'Janela', 'PesqAgen', .f. ), .f. )
  setcolor( CorJanel )
  @ 11,22 say chr(195) + replicate( chr(196), 32 ) + chr(180)                

  setcolor( CorCampo )
  @ 10,24 say space(30)
  @ 12,24 say space(30)

  select AgenARQ
  dbgotop()
  do while !eof()
    @ 10,24 say left( &cChave, 30 )
  
    do case
      case pTipo == 1
        if left( alltrim( &cChave ), nLen ) == pTexto
          @ 12,24 say left( &cChave, 30 )
        
          select( cAgenTMP )
          if AdiReg()
            replace Agen      with AgenARQ->Agen
            replace Nome      with AgenARQ->Nome
            replace Nasc      with AgenARQ->Nasc
            replace Ende      with AgenARQ->Ende
            replace Bair      with AgenARQ->Bair
            replace Cida      with AgenARQ->Cida
            replace Cep       with AgenARQ->Cep
            replace UF        with AgenARQ->UF
            replace Fone      with AgenARQ->fone
            replace Fax       with AgenARQ->fax
            replace Obse      with AgenARQ->Obse
            dbunlock ()
          endif
        endif 
      case pTipo == 3
        if right( alltrim( &cChave ), nLen ) == pTexto
          @ 12,24 say left( &cChave, 30 )

          select( cAgenTMP )
          if AdiReg()
            replace Agen      with AgenARQ->Agen
            replace Nome      with AgenARQ->Nome
            replace Nasc      with AgenARQ->Nasc
            replace Ende      with AgenARQ->Ende
            replace Bair      with AgenARQ->Bair
            replace Cida      with AgenARQ->Cida
            replace Cep       with AgenARQ->Cep
            replace UF        with AgenARQ->UF
            replace Fone      with AgenARQ->fone
            replace Fax       with AgenARQ->fax
            replace Obse      with AgenARQ->Obse
            dbunlock ()
          endif
        endif 
      case pTipo == 2
        if at( pTexto, &cChave ) > 0
          @ 12,24 say left( &cChave, 30 )

          select( cAgenTMP )
          if AdiReg()
            replace Agen      with AgenARQ->Agen
            replace Nome      with AgenARQ->Nome
            replace Nasc      with AgenARQ->Nasc
            replace Ende      with AgenARQ->Ende
            replace Bair      with AgenARQ->Bair
            replace Cida      with AgenARQ->Cida
            replace Cep       with AgenARQ->Cep
            replace UF        with AgenARQ->UF
            replace Fone      with AgenARQ->fone
            replace Fax       with AgenARQ->fax
            replace Obse      with AgenARQ->Obse
            dbunlock ()
          endif
        endif 
    endcase
    
    select AgenARQ
    dbskip() 
  enddo
  
  select( cAgenTMP )
  set order to 1
  dbgotop()
    
  if eof()
    Alerta( mensagem( 'Alerta', 'PesqAgen', .f. ) )
  
    select( cAgenTMP )
    close
    ferase( cAgenARQ )
    ferase( cAgenIND1 )

    select AgenARQ
    dbgotop ()

    return NIL
  endif  

  Janela( 03, 02, 20, 76, mensagem('Janela', 'PesqAgen', .f. ), .f. ) 
  setcolor ( CorJanel + ',' + CorCampo )

  oPesquisa         := TBrowseDb( 05, 03, 18, 75 )
  oPesquisa:headsep := chr(194)+chr(196)
  oPesquisa:footsep := chr(193)+chr(196)
  oPesquisa:colsep  := chr(179)

  oPesquisa:addColumn( TBColumnNew("Codigo",   {|| Agen } ) )
  oPesquisa:addColumn( TBColumnNew("Nome",     {|| left( Nome, 30 ) } ) )
  oPesquisa:addColumn( TBColumnNew("Telefone", {|| Fone } ) )
  oPesquisa:addColumn( TBColumnNew("Obse",     {|| left( Obse, 20 ) } ) )
  oPesquisa:addColumn( TBColumnNew("Endereço", {|| left( Ende, 35 ) } ) )
  oPesquisa:addColumn( TBColumnNew("Bairro",   {|| left( Bair, 15 ) } ) )
  oPesquisa:addColumn( TBColumnNew("Cidade",   {|| left( Cida, 15 ) } ) )
            
  lExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ''
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 06, 18, 76, nTotal )
    
  oPesquisa:freeze := 1
  oPesquisa:colPos := oAgenda:colPos
   
  setcolor ( CorCampo )
  @ 19,16 say space(40)
    
  setcolor( CorJanel + ',' + CorCampo )
  @ 06,02 say chr(195)
  @ 18,02 say chr(195)
  @ 19,07 say 'Consulta'

  do while !lExitRequested
    Mensagem( 'Cons', 'PesqAgen' )

    oPesquisa:forcestable()

    PosiDBF( 03, 76 )
    
    iif( BarraSeta, BarraSeta( nLinBarra, 06, 18, 76, nTotal ), NIL )

    if oPesquisa:stable
      if oPesquisa:hitTop .or. oPesquisa:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
 
    do case
      case cTecla == K_DOWN;        oPesquisa:down()
      case cTecla == K_UP;          oPesquisa:up()
      case cTecla == K_PGDN;        oPesquisa:pageDown()
      case cTecla == K_PGUP;        oPesquisa:pageUp()
      case cTecla == K_CTRL_PGUP;   oPesquisa:goTop()
      case cTecla == K_CTRL_PGDN;   oPesquisa:goBottom()
      case cTecla == K_RIGHT;       oPesquisa:right()
      case cTecla == K_LEFT;        oPesquisa:left()
      case cTecla == K_HOME;        oPesquisa:home()
      case cTecla == K_END;         oPesquisa:end()
      case cTecla == K_CTRL_LEFT;   oPesquisa:panLeft()
      case cTecla == K_CTRL_RIGHT;  oPesquisa:panRight()
      case cTecla == K_CTRL_HOME;   oPesquisa:panHome()
      case cTecla == K_CTRL_END;    oPesquisa:panEnd()
      case cTecla == K_ESC;         lExitRequested := .T.
      case cTecla == K_ALT_A
        tAlte     := savescreen( 00, 00, 23, 79 )
        
        Agen (.t.)

        restscreen( 00, 00, 23, 79, tAlte )
        
        cLetra         := ''
        lExitRequested := .f.

        setcolor ( CorCampo )
        @ 19,16 say space(40)

        select( cAgenTMP )
        set order to 1
        
        oPesquisa:refreshAll()
      case cTecla == K_INS
        tAlte     := savescreen( 00, 00, 23, 79 )
        
        Agen (.f.)

        restscreen( 00, 00, 23, 79, tAlte )
        
        cLetra         := ''
        lExitRequested := .f.

        setcolor ( CorCampo )
        @ 19,16 say space(40)

        select( cAgenTMP )
        set order to 1

        oPesquisa:refreshAll()
      case cTecla == K_BS
        cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
      
        setcolor ( CorCampo )
        @ 19,16 say space(40)
        @ 19,16 say cLetra
      case cTecla >= 32 .and. cTecla <= 128
        cLetra += chr( cTecla )    

        if len( cLetra ) > 40
          cLetra := ''
        endif  
     
        setcolor ( CorCampo )
        @ 19,16 say space(40)
        @ 19,16 say cLetra

        dbseek( cLetra, .t. )
        oPesquisa:refreshAll()
    endcase
  enddo
  
  select( cAgenTMP )
  close
  ferase( cAgenARQ )
  ferase( cAgenIND1 )

  select AgenARQ
  dbgotop ()

return NIL

//
// Mostra os Transportadora
//
function ConsTran(xlPara)
  cArquivo  := alias()  
  tMostra   := savescreen( 00, 00, 24, 79 )

  if NetUse( "TranARQ", .t. )
    VerifIND( "TranARQ" )
  
    lAbriTran := .t.

    #ifdef DBF_NTX
      set index to TranIND1, TranIND2
    #endif  
  else
    lAbriTran := .f.  
  endif

  select TranARQ
  set order to 2
  dbgotop()

  Janela( 03, 02, 20, 76, mensagem( 'Janela', 'ConsTran', .f. ), .f. ) 
  setcolor ( CorJanel + ',' + CorCampo )

  oTransp         := TBrowseDb( 05, 03, 18, 75 )
  oTransp:headsep := chr(194)+chr(196)
  oTransp:footsep := chr(193)+chr(196)
  oTransp:colsep  := chr(179)

  oTransp:addColumn( TBColumnNew("Codigo",       {|| Tran } ) )
  oTransp:addColumn( TBColumnNew("Razao Social", {|| left( Nome, 30 ) } ) )
  oTransp:addColumn( TBColumnNew("Telefone",     {|| left( Fone, 14 ) } ) )
  oTransp:addColumn( TBColumnNew("Endereço",     {|| left( Ende, 20 ) } ) )
  oTransp:addColumn( TBColumnNew("Bairro",       {|| left( Bairro, 15 ) } ) )
  oTransp:addColumn( TBColumnNew("Cidade",       {|| left( Cidade, 15 ) } ) )
  oTransp:addColumn( TBColumnNew("Transporte",   {|| ViaTra } ) )
  oTransp:addColumn( TBColumnNew("CNPJ",         {|| transform( CGC, '@R 99.999.999/9999-99' ) } ) )
 
  lExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ''
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 06, 18, 76, nTotal )
    
  oTransp:freeze := 1
  oTransp:colPos := 2
   
  setcolor ( CorCampo )
  @ 19,16 say space(40)
    
  setcolor( CorJanel + ',' + CorCampo )
  @ 06,02 say chr(195)
  @ 18,02 say chr(195)
  @ 19,07 say 'Consulta'

  do while !lExitRequested
    Mensagem( 'Cons', 'ConsTran' )

    oTransp:forcestable()

    PosiDBF( 03, 76 )
    
    iif( BarraSeta, BarraSeta( nLinBarra, 06, 18, 76, nTotal ), NIL )

    if oTransp:stable
      if oTransp:hitTop .or. oTransp:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
 
    do case
      case cTecla == K_DOWN;        oTransp:down()
      case cTecla == K_UP;          oTransp:up()
      case cTecla == K_PGDN;        oTransp:pageDown()
      case cTecla == K_PGUP;        oTransp:pageUp()
      case cTecla == K_CTRL_PGUP;   oTransp:goTop()
      case cTecla == K_CTRL_PGDN;   oTransp:goBottom()
      case cTecla == K_RIGHT;       oTransp:right()
      case cTecla == K_LEFT;        oTransp:left()
      case cTecla == K_HOME;        oTransp:home()
      case cTecla == K_END;         oTransp:end()
      case cTecla == K_CTRL_LEFT;   oTransp:panLeft()
      case cTecla == K_CTRL_RIGHT;  oTransp:panRight()
      case cTecla == K_CTRL_HOME;   oTransp:panHome()
      case cTecla == K_CTRL_END;    oTransp:panEnd()
      case cTecla == K_ESC;         lExitRequested := .t.
      case cTecla == K_ENTER
        if xlPara == NIL
          lOK            := .t.
          lExitRequested := .t.
        endif  
      case cTecla == K_ALT_A;       tAlte := savescreen( 00, 00, 23, 79 )
        Trns(.t.)

        restscreen( 00, 00, 23, 79, tAlte )

        setcolor ( CorCampo )
        @ 19,16 say space(40)
        
        select TranARQ
        set order to 2
        dbseek( TranARQ->Nome, .f. )
        
        lExitRequested := .f.
        cLetra         := ''

        oTransp:refreshAll()
      case cTecla == K_INS;        tAlte := savescreen( 00, 00, 23, 79 )
        Trns (.f.)

        restscreen( 00, 00, 23, 79, tAlte )

        setcolor ( CorCampo )
        @ 19,16 say space(40)
        
        select TranARQ
        set order to 2
        dbseek( TranARQ->Nome, .f. )

        lExitRequested := .f.
        cLetra         := ''

        oTransp:refreshAll()
      case cTecla == K_ALT_P;        ConsConh()
        oTransp:refreshAll()

        lExitRequested := .f.
      case cTecla == K_ALT_G;        ConsPgCo()
        oTransp:refreshAll()

        lExitRequested := .f.
      case cTecla == K_BS
        cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
      
        setcolor ( CorCampo )
        @ 19,16 say space(40)
        @ 19,16 say cLetra
      case cTecla >= 32 .and. cTecla <= 128
        lLetra := .f.
      
        do case
          case oTransp:ColPos == 1;      lLetra := .t.      
            set order to 1
          case oTransp:ColPos == 2;      lLetra := .t.     
            set order to 2
        endcase
        
        if lLetra       
          cLetra += chr( cTecla )    
        endif  

        if len( cLetra ) > 40
          cLetra := ''
        endif  
     
        setcolor ( CorCampo )
        @ 19,16 say space(40)
        @ 19,16 say cLetra

        dbseek( cLetra, .t. )
        oTransp:refreshAll()
    endcase

    select TranARQ
  enddo

  if lAbriTran 
    select TranARQ
    close
  endif  

  restscreen( 00, 00, 24, 79, tMostra )
return NIL

//
//  Consulta de Conhecimentos a Pagar
//
function ConsConh ()

  if NetUse( "ConhARQ", .t. )
    VerifIND( "ConhARQ" )
  
    pAbriConh := .t.
  
    #ifdef DBF_NTX
      set index to ConhIND1, ConhIND2, ConhIND3, ConhIND4
    #endif  
  else
    pAbriConh := .f.  
  endif
  
  cCorAtual   := setcolor()
  dData       := dtos( ctod('  /  /   ') )
  iTran       := TranARQ->Tran
  iNome       := TranARQ->Nome
  uTotalGeral := 0
  dVctoIni    := ctod( '01/01/1990' )
  dVctoFin    := ctod( '31/12/2015' )
  tTelaRcto   := savescreen( 00, 00, 23, 79 )
  
  if EmprARQ->Periodo == "X"
    Janela( 09, 24, 13, 50, mensagem( 'Janela', 'Periodo', .f. ), .f. )
    Mensagem( 'LEVE', 'Periodo' )

    setcolor( CorJanel )
    @ 11,26 say 'Vcto. Inicial'
    @ 12,26 say '  Vcto. Final'
  
    @ 11,40 get dVctoIni      pict '99/99/9999'
    @ 12,40 get dVctoFin      pict '99/99/9999' valid dVctoFin >= dVctoIni
    read
   
    if lastkey() == K_ESC
      if pAbriConh
        select ConhARQ
        close
      endif  

      select TranARQ
      set order to 2
      dbseek( iNome, .f. )
  
      restscreen( 00, 00, 23, 79, tTelaRcto )
      return NIL
    endif  
  endif  
  
  select ConhARQ
  set order to 4
  dbseek( iTran + dData, .t. )
  do while Tran == iTran .and. empty( Pgto ) .and. !eof ()
    if Vcto >= dVctoIni .and. Vcto <= dVctoFin
      uTotalGeral += Valor
    endif  

    dbskip ()
  enddo      

  if uTotalGeral == 0
    Alerta( mensagem( 'Alerta', 'ConsConh', .f. ) ) 

    if pAbriConh
      select ConhARQ
      close
    endif  

    select TranARQ
    set order to 2
    dbseek( iNome, .f. )
    
    restscreen( 00, 00, 23, 79, tTelaRcto )
    return NIL
  endif  

  Janela ( 03, 01, 20, 76, mensagem( 'Janela', 'ConsConh', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )

  select ConhARQ
  set order to 4
  bFirst := {|| dbseek( iTran + dData, .t. ) }
  bLast  := {|| dbseek( iTran + dData, .t. ), dbskip(-1) }
  bFor   := {|| empty( Pgto ) .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin .and. Tran == iTran } 
  bWhile := {|| empty( Pgto ) .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin .and. Tran == iTran } 
  
  oConhec           := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oConhec:nTop      := 5
  oConhec:nLeft     := 2
  oConhec:nBottom   := 18
  oConhec:nRight    := 75
  oConhec:headsep   := chr(194)+chr(196)
  oConhec:colsep    := chr(179)
  oConhec:footsep   := chr(193)+chr(196)
  oConhec:colorSpec := CorJanel

  oConhec:addColumn( TBColumnNew(" ",       {|| Marc } ) )
  oConhec:addColumn( TBColumnNew("Conh.",   {|| Nota } ) )
  oConhec:addColumn( TBColumnNew("Emis.",   {|| Emis } ) )
  oConhec:addColumn( TBColumnNew("Vcto.",   {|| Vcto } ) )
  oConhec:addColumn( TBColumnNew("Valor",   {|| transform( Valor, '@E 999,999.99' ) } ) )
  oConhec:addColumn( TBColumnNew("Tabela",  {|| transform( Tabela, '@E 999,999.99' ) } ) )
  if EmprARQ->Inteira == "X"
    oConhec:addColumn( TBColumnNew("Qtde.",   {|| transform( Qtde, '@E 999999999' ) } ) )
  else  
    oConhec:addColumn( TBColumnNew("Qtde.",   {|| transform( Qtde, '@E 99999.999' ) } ) )
  endif  
  oConhec:addColumn( TBColumnNew("Espécie", {|| left( Especie, 09 ) } ) )
  oConhec:addColumn( TBColumnNew("Peso",    {|| transform( Peso, '@E 999,999.9' ) } ) )
              
  oConhec:refreshAll ()
  
  lAdiciona      := .f.
  lMais          := .t.
  lExitRequested := .f.
  nLinBarra      := 1
  uSubTotal      := 0
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 6, 18, 76, nTotal )
  
  setcolor( CorJanel + ',' + CorCampo )
  @ 06,01 say chr(195)
  @ 18,01 say chr(195)
  @ 05,10 say 'Transp.'
  @ 19,05 say 'Sub-Total'
  @ 19,49 say 'Total Geral'
  
  setcolor( CorCampo )
  @ 19,15 say uSubTotal                  pict '@E 999,999.99'
  @ 19,61 say uTotalGeral                pict '@E 999,999.99'

  do while !lExitRequested
    Mensagem( 'Cons', 'ConsConh' )
    
    oConhec:forcestable() 

    PosiDBF( 03, 76 )
    
    iif( BarraSeta, BarraSeta( nLinBarra, 6, 18, 76, nTotal ), NIL )
    
    if oConhec:stable
      if oConhec:hitTop .or. oConhec:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oConhec:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oConhec:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oConhec:down()
      case cTecla == K_UP;         oConhec:up()
      case cTecla == K_PGDN;       oConhec:pageDown()
      case cTecla == K_PGUP;       oConhec:pageUp()
      case cTecla == K_LEFT;       oConhec:left()
      case cTecla == K_RIGHT;      oConhec:right()
      case cTecla == K_CTRL_PGUP;  oConhec:goTop()
      case cTecla == K_CTRL_PGDN;  oConhec:gobottom()
      case cTecla == K_ESC
        select ConhARQ
        set order to 4
        dbseek( iTran + dData, .t. )
        do while Tran == iTran .and. empty( Pgto ) .and. !eof ()
          if Vcto >= dVctoIni .and. Vcto <= dVctoFin 
            if RegLock()
              replace Marc      with space(01)
              dbunlock ()
            endif  
          endif  
          dbskip ()
        enddo
      
        oConhec:refreshAll()

        lExitRequested := .t.
      case cTecla == K_ALT_P
        uTotalGeral := 0
        uSubTotal   := 0
        aNotas      := {}
       
        select ConhARQ
        set order to 4
        dbseek( iTran + dData, .t. )
        do while Tran == iTran .and. empty( Pgto ) .and. !eof ()
          if Vcto >= dVctoIni .and. Vcto <= dVctoFin
            if empty( Marc )
              dbskip ()
              loop
            else
              aadd( aNotas, recno () )  
            endif  
          endif  
       
          dbskip ()
        enddo
        
        for nH := 1 to len( aNotas )         
          go aNotas[ nH ]
          if RegLock()
            replace Marc       with space(01)
            replace Pgto       with date()
            replace Pago       with Valor
            dbunlock ()
          endif
        next  
   
        dbseek( iTran + dData, .t. )
        do while Tran == iTran .and. empty( Pgto ) .and. !eof ()
          if Vcto >= dVctoIni .and. Vcto <= dVctoFin 
            if !empty( Marc )
              uSubTotal += Valor
            endif  
          
            uTotalGeral += Valor
          endif  

          dbskip ()
        enddo      
        
        dbseek( iTran + dData, .t. )

        setcolor( CorCampo )
        @ 19,15 say uSubTotal                  pict '@E 999,999.99'
        @ 19,61 say uTotalGeral                pict '@E 999,999.99'
        
        oConhec:gotop()
        oConhec:refreshAll()
      case cTecla == K_ALT_A   
        tConhTela := savescreen( 00, 00, 22, 79 )

        PgCo(.f.)

        restscreen( 00, 00, 22, 79, tConhTela )

        uSubTotal   := 0
        uTotalGeral := 0

        select ConhARQ
        set order to 4
        dbseek( iTran + dData, .t. )
        do while Tran == iTran .and. empty( Pgto ) .and. !eof ()
          if Vcto >= dVctoIni .and. Vcto <= dVctoFin 
            if !empty( Marc )
              uSubTotal += Valor
            endif  
        
            uTotalGeral += Valor
          endif
          dbskip ()
        enddo      

        setcolor( CorCampo )
        @ 19,15 say uSubTotal                  pict '@E 999,999.99'
        @ 19,61 say uTotalGeral                pict '@E 999,999.99'

        oConhec:gotop()
        oConhec:refreshAll()

        lExitRequested := .f.
      case cTecla == K_SPACE
        if RegLock()
          if ConhARQ->Marc == ' '
            replace Marc      with "X"

            uSubTotal += Valor
          else
            replace Marc      with ' '
 
            uSubTotal -= Valor
          endif    
          dbunlock ()
        endif  
        
        setcolor( CorCampo ) 
        @ 19,15 say uSubTotal                  pict '@E 999,999.99'
        
        oConhec:refreshAll()
    endcase
  enddo  
  
  if pAbriConh
    select ConhARQ
    close
  endif  
  
  select TranARQ
  set order to 2
  dbseek( iNome, .f. ) 
  
  setcolor( cCorAtual )
  restscreen( 00, 00, 23, 79, tTelaRcto )
return NIL

//
//  Consulta de Conhecimentos a Pagos
//
function ConsPgCo ()

  if NetUse( "ConhARQ", .t. )
    VerifIND( "ConhARQ" )

    pAbriConh := .t.
  
    #ifdef DBF_NTX
      set index to ConhIND1, ConhIND2, ConhIND3, ConhIND4
    #endif  
  else
    pAbriConh := .f.  
  endif
  
  cCorAtual   := setcolor()
  dData       := dtos( ctod('01/01/90') )
  iTran       := TranARQ->Tran
  iNome       := TranARQ->Nome
  uTotalGeral := 0
  dVctoIni    := ctod( '01/01/1900' )
  dVctoFin    := ctod( '31/12/2015' )
  tTelaRcto   := savescreen( 00, 00, 23, 79 )
  
  if EmprARQ->Periodo == "X"
    Janela( 09, 24, 13, 50, mensagem( 'Janela', 'Periodo', .f. ), .f. )
    Mensagem( 'LEVE', 'Periodo' )

    setcolor( CorJanel )
    @ 11,26 say 'Vcto. Inicial'
    @ 12,26 say '  Vcto. Final'
  
    @ 11,40 get dVctoIni      pict '99/99/9999'
    @ 12,40 get dVctoFin      pict '99/99/9999' valid dVctoFin >= dVctoIni
    read
   
    if lastkey() == K_ESC
      if pAbriConh
        select ConhARQ
        close
      endif  

      select TranARQ
      set order to 2
      dbseek( iNome, .f. )
  
      restscreen( 00, 00, 23, 79, tTelaRcto )
      return NIL
    endif  
  endif  
  
  select ConhARQ
  set order to 4
  dbseek( iTran + dData, .t. )
  do while Tran == iTran .and. !empty( Pgto ) .and. !eof ()
    if Vcto >= dVctoIni .and. Vcto <= dVctoFin 
      uTotalGeral += Valor
    endif  

    dbskip ()
  enddo      

  if uTotalGeral == 0
    Alerta( mensagem( 'Alerta', 'ConsPgCo', .f. ) )

    if pAbriConh
      select ConhARQ
      close
    endif  

    select TranARQ
    set order to 2
    dbseek( iNome, .f. )
    
    restscreen( 00, 00, 23, 79, tTelaRcto )
    return NIL
  endif  

  Janela ( 03, 01, 20, 76, mensagem( 'Janela', 'ConsPgCo', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )

  select ConhARQ
  set order to 4
  bFirst := {|| dbseek( iTran + dData, .t. ) }
  bLast  := {|| dbseek( iTran + dData, .t. ), dbskip(-1) }
  bFor   := {|| !empty( Pgto ) .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin .and. Tran == iTran } 
  bWhile := {|| !empty( Pgto ) .and. Vcto >= dVctoIni .and. Vcto <= dVctoFin .and. Tran == iTran } 
  
  oConhec           := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oConhec:nTop      := 5
  oConhec:nLeft     := 2
  oConhec:nBottom   := 18
  oConhec:nRight    := 75
  oConhec:headsep   := chr(194)+chr(196)
  oConhec:colsep    := chr(179)
  oConhec:footsep   := chr(193)+chr(196)
  oConhec:colorSpec := CorJanel

  oConhec:addColumn( TBColumnNew(" ",       {|| Marc } ) )
  oConhec:addColumn( TBColumnNew("Conh.",   {|| Nota } ) )
  oConhec:addColumn( TBColumnNew("Emis.",   {|| Emis } ) )
  oConhec:addColumn( TBColumnNew("Vcto.",   {|| Vcto } ) )
  oConhec:addColumn( TBColumnNew("Pgto.",   {|| Pgto } ) )
  oConhec:addColumn( TBColumnNew("Valor",   {|| transform( Valor, '@E 999,999.99' ) } ) )
  oConhec:addColumn( TBColumnNew("Tabela",  {|| transform( Tabela, '@E 999,999.99' ) } ) )
  if EmprARQ->Inteira == "X"
    oConhec:addColumn( TBColumnNew("Qtde.",   {|| transform( Qtde, '@E 999999999' ) } ) )
  else  
    oConhec:addColumn( TBColumnNew("Qtde.",   {|| transform( Qtde, '@E 99999.999' ) } ) )
  endif    
  oConhec:addColumn( TBColumnNew("Espécie", {|| left( Especie, 09 ) } ) )
  oConhec:addColumn( TBColumnNew("Peso",    {|| transform( Peso, '@E 999,999.9' ) } ) )
              
  oConhec:refreshAll ()
  
  lAdiciona      := .f.
  lMais          := .t.
  lExitRequested := .f.
  nLinBarra      := 1
  uSubTotal      := 0
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 6, 18, 76, nTotal )
  
  setcolor( CorJanel + ',' + CorCampo )
  @ 06,01 say chr(195)
  @ 18,01 say chr(195)
  @ 05,10 say 'Transp.'
  @ 19,05 say 'Sub-Total'
  @ 19,49 say 'Total Geral'
  
  setcolor( CorCampo )
  @ 19,15 say uSubTotal                  pict '@E 999,999.99'
  @ 19,61 say uTotalGeral                pict '@E 999,999.99'

  do while !lExitRequested
    Mensagem( 'Cons', 'ConsPgCo', .f. )
    
    oConhec:forcestable() 

    PosiDBF( 03, 76 )

    iif( BarraSeta, BarraSeta( nLinBarra, 6, 18, 76, nTotal ), NIL )
    
    if oConhec:stable
      if oConhec:hitTop .or. oConhec:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oConhec:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oConhec:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oConhec:down()
      case cTecla == K_UP;         oConhec:up()
      case cTecla == K_PGDN;       oConhec:pageDown()
      case cTecla == K_PGUP;       oConhec:pageUp()
      case cTecla == K_LEFT;       oConhec:left()
      case cTecla == K_RIGHT;      oConhec:right()
      case cTecla == K_CTRL_PGUP;  oConhec:goTop()
      case cTecla == K_CTRL_PGDN;  oConhec:gobottom()
      case cTecla == K_ESC
        select ConhARQ
        set order to 4
        dbseek( iTran + dData, .t. )
        do while Tran == iTran .and. !empty( Pgto ) .and. !eof ()
          if Vcto >= dVctoIni .and. Vcto <= dVctoFin
            if RegLock()
              replace Marc      with space(01)
              dbunlock ()
            endif  
          endif  
          dbskip ()
        enddo
      
        oConhec:refreshAll()

        lExitRequested := .t.
      case cTecla == K_ALT_A   
        tConhTela := savescreen( 00, 00, 22, 79 )

        PgCo(.f.)

        restscreen( 00, 00, 22, 79, tConhTela )
        
        uSubTotal   := 0
        uTotalGeral := 0

        select ConhARQ
        set order to 4
        dbseek( iTran + dData, .t. )
        do while Tran == iTran .and. !empty( Pgto ) .and. !eof ()
          if Vcto >= dVctoIni .and. Vcto <= dVctoFin 
            if !empty( Marc )
              uSubTotal += Valor
            endif  
        
            uTotalGeral += Valor
          endif
          dbskip ()
        enddo      

        setcolor( CorCampo )
        @ 19,15 say uSubTotal                  pict '@E 999,999.99'
        @ 19,61 say uTotalGeral                pict '@E 999,999.99'

        oConhec:gotop()
        oConhec:refreshAll()

        lExitRequested := .f.
      case cTecla == K_SPACE
        if RegLock()
          if ConhARQ->Marc == ' '
            replace Marc      with "X"

            uSubTotal += Valor
          else
            replace Marc      with ' '
 
            uSubTotal -= Valor
          endif    
          dbunlock ()
        endif  
        
        setcolor( CorCampo ) 
        @ 19,15 say uSubTotal                  pict '@E 999,999.99'
        
        oConhec:refreshAll()
    endcase
  enddo  
  
  if pAbriConh
    select ConhARQ
    close
  endif  
  
  select TranARQ
  set order to 2
  dbseek( iNome, .f. ) 
  
  setcolor( cCorAtual )
  restscreen( 00, 00, 23, 79, tTelaRcto )
return NIL