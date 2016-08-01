//  Leve, Cobrador
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

function CObr( xAlte )
  local GetList := {}
  
if SemAcesso( 'Cobr' )
  return NIL
endif  

if NetUse( "CobrARQ", .t. )
  VerifIND( "CobrARQ" )
  
  lOpenCobr := .t.
  
  #ifdef DBF_NTX
    set index to CobrIND1, CobrIND2
  #endif    
else 
  lOpenCobr := .f.  
endif

//  Variaveis de entrada para Cobradores
nCobr     := pCEP     := pPerC := 0
cCobr     := space(4)
pFone     := pFax     := space(14)
pBair     := pViaTra  := space(14)
pNoCr     := space(45)
pEnde     := space(34)
pCida     := space(30)
cUF       := space(2)

//  Tela Cobresentante
Janela ( 04, 06, 15, 75, mensagem( 'Janela', 'Cobr', .f. ), .t. )

setcolor ( CorJanel )
@ 06,08 say '      Codigo'
@ 06,51 say 'Comissão'
@ 08,08 say '        Nome'

@ 10,08 say '    Endereço'
@ 10,56 say 'CEP'
@ 11,08 say '      Cidade'
@ 11,57 say 'UF'
@ 12,08 say '      Bairro'
@ 12,36 say 'Fone'
@ 12,56 say 'Fax'

MostOpcao( 14, 08, 20, 51, 64 ) 
tCobr := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Cobrador
select CobrARQ
set order to 1
if lOpenCobr
  dbgobottom ()
endif  
do while .t.
  Mensagem ( 'Cobr', 'Janela' )

  select CobrARQ
  set order to 1

  cStat := space(04)
  restscreen( 00, 00, 23, 79, tCobr )
  MostCobr()
  
  if Demo ()
    exit
  endif  
  
  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostCobr'
  cAjuda   := 'Cobr'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
   
  if lastkey() == K_ALT_A
    nCobr := val( Cobr )
  else   
    if xAlte 
      @ 06,21 get nCobr pict '999999'
      read
    else
      nCobr := 0
    endif    
  endif  
  
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC
    exit
  endif
  
  setcolor ( CorCampo )
  cCobr := strzero( nCobr, 6 )
  @ 06,21 say cCobr

  //  Verificar existencia do Cobrador para Incluir ou Alterar
  select CobrARQ
  set order to 1
  dbseek( cCobr, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif

  Mensagem ('Cobr', cStat )
  
  MostCobr()
  EntrCobr()

  Confirmar ( 14, 08, 20, 51, 64, 3 )

  if cStat == 'prin'
    PrinCobr (.f.)
  endif
    
  if cStat == 'excl'
    ExclRegi ()
  endif
  
  if cStat == 'incl'
    if cCobr == '000000'
      cCobr := '000001'
    endif    

    set order to 1  
    do while .t.
      dbseek( cCobr, .f. )
      if found()
        nCobr := val( cCobr ) + 1               
        cCobr := strzero( nCobr, 6 )
      else 
        exit   
      endif
    enddo

    if AdiReg()
      if RegLock()
        replace Cobr     with cCobr
        dbunlock ()
      endif
    endif 
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace PerC       with pPerC 
      replace Nome       with pNoCr
      replace Ende       with pEnde
      replace Cida       with pCida
      replace CEP        with pCEP
      replace UF         with cUF
      replace Bair       with pBair
      replace Fone       with pFone
      replace Fax        with pFax
      dbunlock ()
    endif
    
    if !xAlte
      xAlte := .t.
      keyboard(chr(27))
    endif  
  endif
enddo

if lOpenCobr
  select CobrARQ
  close
endif  

return NIL

//
// Entra dados do Cobrador
//
function EntrCobr()
  local GetList := {}

  do while .t.
    lAlterou := .f.
    
    setcolor ( CorJanel + ',' + CorCampo )
    @ 06,60 get pPerC       pict '@E 999.99'
    @ 08,21 get pNoCr
    @ 10,21 get pEnde       pict '@S34'  
    @ 10,60 get pCEP        pict '99999-999'
    @ 11,21 get pCida       pict '@S25'    
    @ 11,60 get cUF         pict '@!' valid ValidUf ( 11, 60, "CobrARQ" )
    @ 12,21 get pBair       pict '@S14'  
    @ 12,41 get pFone       
    @ 12,60 get pFax        
    read
    
    if     pPerC  != PerC; lAlterou := .t.   
    elseif pNoCr  != Nome; lAlterou := .t.   
    elseif pEnde  != Ende; lAlterou := .t.   
    elseif pCEP   != CEP;  lAlterou := .t.   
    elseif pCida  != Cida; lAlterou := .t.   
    elseif cUF    != UF;   lAlterou := .t.   
    elseif pBair  != Bair; lAlterou := .t.   
    elseif pFone  != Fone; lAlterou := .t.   
    elseif pFax   != Fax;  lAlterou := .t.  
    endif
    
    if !Saindo(lAlterou)
      loop
    endif
    exit
  enddo  
return NIL

//
// Mostra dados do Cobrador
//
function MostCobr()
  setcolor ( CorCampo )
  if cStat != 'incl'
    nCobr   := val( Cobr )
    cCobr   := Cobr

    @ 06,21 say cCobr
  endif
     
  pNoCr     := Nome
  pEnde     := Ende
  pCida     := Cida  
  pCEP      := CEP
  pBair     := Bair  
  cUF       := UF
  pFone     := Fone
  pFax      := Fax
  pPerC     := PerC

  setcolor ( CorCampo )
  @ 06,60 say pPerC       pict '@E 999.99'
  @ 08,21 say pNoCr
  @ 10,21 say pEnde       pict '@S34'    
  @ 10,60 say pCEP        pict '99999-999'
  @ 11,21 say pCida       pict '@S25'     
  @ 11,60 say cUF         pict '@!'
  @ 12,21 say pBair       pict '@S14'    
  @ 12,41 say pFone       
  @ 12,60 say pFax        
  
  PosiDBF( 04, 75 )
return NIL

//
// Imprime dados do Cobrador
//
function PrinCobr ( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "CobrARQ", .t. )
      VerifIND( "CobrARQ" )

      #ifdef DBF_NTX
        set index to CobrIND1, CobrIND2
      #endif    
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 06, 25, 10, 55, mensagem( 'Janela', 'PrinCobr', .f. ), .f. )

  setcolor ( Corjanel + ',' + CorCampo )
  @ 08,27 say 'Cobrador Inicial'
  @ 09,27 say '  Cobrador Final'

  select CobrARQ
  set order  to 1
  dbgotop ()
  nCobrIni := val( Cobr )
  dbgobottom ()
  nCobrFin := val( Cobr )

  @ 08,44 get nCobrIni        pict '999999' valid ValidARQ( 99, 99, "CobrARQ", "Código" , "Cobr", "Descrição", "Nome", "Cobr", "nCobrIni", .t., 6, "Consulta de Cobrador", "CobrARQ", 40 )
  @ 09,44 get nCobrFin        pict '999999' valid ValidARQ( 99, 99, "CobrARQ", "Código" , "Cobr", "Descrição", "Nome", "Cobr", "nCobrFin", .t., 6, "Consulta de Cobrador", "CobrARQ", 40 ) .and. nCobrFin >= nCobrIni
  read

  if lastkey() == K_ESC
    select CobrARQ
    if lAbrir
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

  cCobrIni := strzero( nCobrIni, 6 )
  cCobrFin := strzero( nCobrFin, 6 )
  
  select CobrARQ
  set order to 1
  dbseek( cCobrIni, .t. )
  do while Cobr >= cCobrIni .and. Cobr <= cCobrFin .and. !eof()
    if lInicio 
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
    
      lInicio := .f.
    endif  

    if nLin == 0
      Cabecalho( 'Cobradores', 80, 3 )
      CabCobr()
    endif

    @ nLin, 00 say Cobr     pict '9999'
    @ nLin, 08 say Nome
    if !empty( Fone )
      @ nLin, 50 say Fone   
    endif
    nLin ++

    if nLin >= pLimite
      Rodape(80) 

      cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
      cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

      set printer to ( cArqu2 )
      set printer on
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
      replace Titu       with "Relatório de Cobradores"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
    close
  endif  
 
  select CobrARQ
  if lAbrir
    close
  else  
    set order  to 1 
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabCobr ()
  @ 02, 00 say 'Cod'
  @ 02, 08 say 'Nome'
  @ 02, 50 say 'Telefone'

  nLin := 04
return NIL

//
// Criar Layout da Nota fiscal
//
function CriaNF ()
  local tModi := savescreen( 00, 00, 23, 79 ) 

  if NetUse( "CampARQ", .t. )
    VerifIND( "CampARQ" )

    #ifdef DBF_NTX
      set index to CampIND1, CampIND2
    #endif
  endif

  if NetUse( "NFisARQ", .t. )
    VerifIND( "NFisARQ" )

    #ifdef DBF_NTX
      set index to NFisIND1
    #endif
  endif
  
  select NFisARQ
  set order to 2
  Janela( 05, 10, 17, 63, mensagem( 'Janela', 'CriaNF', .f. ), .f. )  
  Mensagem( 'Cobr', 'CriaNF' ) 

  setcolor( CorJanel + ',' + CorCampo )
  oFiscal           := TBrowseDB( 07, 11, 15, 61 )
  oFiscal:headsep   := chr(194)+chr(196)
  oFiscal:colsep    := chr(179)
  oFiscal:footsep   := chr(193)+chr(196)
  oFiscal:colorSpec := CorJanel + ',' + CorCampo
 
  oFiscal:addColumn( TBColumnNew( 'Descrição', {|| left( Desc, 20 ) } ) )
  oFiscal:addColumn( TBColumnNew( 'Col.',       {|| iif( Colu == 1, ' 80', '132' ) } ) )
  oFiscal:addColumn( TBColumnNew( 'Com.',       {|| iif( Comp == 1, 'Sim', 'Não' ) } ) )
  oFiscal:addColumn( TBColumnNew( 'Esp.',       {|| iif( Espa == 1, '1/6' + chr(34), '1/8' + chr(34) ) } ) )
  oFiscal:addColumn( TBColumnNew( 'Linha',      {|| QtLinha } ) )
  oFiscal:addColumn( TBColumnNew( 'Itens',      {|| Itens } ) )
  
  oFiscal:goTop ()

  lExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ''
  cAjuda         := 'NFis'
  lAjud          := .t.
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 08, 15, 63, nTotal )

  setcolor ( CorCampo )
  @ 16,26 say space(32)

  setcolor( CorJanel + ',' + CorCampo )
  @ 08,10 say chr(195)
  @ 15,10 say chr(195)
  @ 16,17 say 'Consulta'
    
  do while !lExitRequested
    Mensagem( 'LEVE', 'Browse' )

    oFiscal:forcestable() 
    
    iif( BarraSeta, BarraSeta( nLinBarra, 08, 15, 63, nTotal ), NIL )
       
    if oFiscal:stable
      if oFiscal:hitTop .or. oFiscal:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oFiscal:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oFiscal:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
      
    do case
      case cTecla == K_DOWN;       oFiscal:down()
      case cTecla == K_UP;         oFiscal:up()
      case cTecla == K_PGDN;       oFiscal:pageDown()
      case cTecla == K_PGUP;       oFiscal:pageUp()
      case cTecla == K_CTRL_PGUP;  oFiscal:goTop()
      case cTecla == K_CTRL_PGDN;  oFiscal:goBottom()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_F1;         Ajuda ()
      case cTecla == K_INS
        toFiscal := savescreen( 00, 00, 23, 79 )
        
        Janela( 08, 07, 15, 67, mensagem( 'Janela', 'CriaNF1', .f. ), .f. )
        Mensagem( 'Cobr', 'CriaNF1' )

        setcolor( CorJanel + ',' + CorCampo )
        @ 10,09 say '   Descrição'
        @ 12,09 say '  Impressora                       Compactar'
        @ 13,09 say ' Espaçamento                    Qtde. Linhas'
        @ 14,09 say ' Qtde. Itens'
        
        setcolor( CorCampo )
        @ 10,22 say space(30)
        @ 12,22 say ' 80 Col '
        @ 12,31 say ' 132 Col '
        @ 12,54 say ' Sim '
        @ 12,60 say ' Não '
        @ 13,22 say ' 1/6" '
        @ 13,29 say ' 1/8" '
        @ 13,54 say '    '
        @ 14,22 say '   '

        setcolor( CorAltKC )
        @ 12,23 say '8'
        @ 12,32 say '1'
        @ 12,55 say 'S'
        @ 12,61 say 'N'
        @ 13,23 say '1'
        @ 13,32 say '8'

        cDesc    := space(30)
        nColu    := 1
        nComp    := 1
        nEspa    := 1
        nQtLinha := 0
        nItens   := 0

        setcolor( CorJanel )
        @ 10,22 get cDesc
        read

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, toFiscal )
          loop
        endif

        aOpc := {}

        aadd( aOpc, { ' 80 Col ', 2,  '8', 12, 22, "Impressora 80 coluna." } )
        aadd( aOpc, { ' 132 Col ', 2, '1', 12, 31, "Impressora 132 colunas." } )

        nColu := HCHOICE( aOpc, 2, nColu )

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, toFiscal )
          loop
        endif

        aOpc := {}

        aadd( aOpc, { ' Sim ', 2, 'S', 12, 54, "Compactar a letra. (Letra Menor)" } )
        aadd( aOpc, { ' Não ', 2, 'N', 12, 60, "Não Compactar a letra. (Letra Normal)" } )

        nComp := HCHOICE( aOpc, 2, nComp )

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, toFiscal )
          loop
        endif

        aOpc  := {}

        aadd( aOpc, { ' 1/6" ', 2, '1', 13, 22, "Configurar o espaçamento entre linha. (Espaçamento Maior)" } )
        aadd( aOpc, { ' 1/8" ', 4, '8', 13, 29, "Configurar o espaçamento entre linha. (Espaçamento Menor)" } )

        nEspa := HCHOICE( aOpc, 2, nEspa )

        setcolor( CorJanel )
        @ 13,54 get nQtLinha                  pict '9999'
        @ 14,22 get nItens                    pict '999'
        read
        
        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, toFiscal )
          loop
        endif

        select NFisARQ
        set order to 1
        dbgobottom ()

        nCod := Codigo + 1
        
        if AdiReg()
          if RegLock()
            replace Desc            with cDesc
            replace Colu            with nColu
            replace Comp            with nComp
            replace Espa            with nEspa
            replace QtLinha         with nQtLinha
            replace Itens           with nItens
            replace Codigo          with nCod
            dbunlock ()
          endif
        endif
        
        CaseLayout ()     
        NotaFiscal ()  

        restscreen( 00, 00, 23, 79, toFiscal )

        oFiscal:refreshAll()
      case cTecla == K_BS
        cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
      
        setcolor ( CorCampo )
        @ 16,26 say space(32)
        @ 16,26 say cLetra
      case cTecla >= 32 .and. cTecla <= 128
        cLetra += chr( cTecla )    
        
        if len( cLetra ) > 32
          cLetra := '' 
        endif
       
        setcolor ( CorCampo )
        @ 16,26 say space(32)
        @ 16,26 say cLetra

        dbseek( cLetra, .t. )
        oFiscal:refreshAll()
      case cTecla == K_DEL
        if ConfAlte ()
          ferase( cCaminho + HB_OSpathseparator() + "LAYOUT" + HB_OSpathseparator() + "NF-" + strzero( Codigo, 4 ) + ".TXT" )
        
          if RegLock()
            dbdelete ()  
            dbunlock ()
          endif  
        endif
              
        oFiscal:refreshAll()
      case cTecla == K_ENTER
        CaseLayout ()     
        NotaFiscal ()  
    endcase
  enddo  
  
  select NFisARQ
  close
  select CampARQ
  close
  
  restscreen( 00, 00, 23, 79, tModi )
return NIL  

//
// Layout da Nota Fiscal
//
function NotaFiscal ()
  local tFisc := savescreen( 00, 00, 23, 79 )

  Janela( 01, 01, 21, 78, mensagem( 'Janela', 'NotaFiscal', .f. ), .F. )
  Mensagem( 'Cobr', 'NotaFiscal' )
  setcolor( CorJanel + ',' + CorCampo )
                     
  cTxt    := memoread( cCaminho + HB_OSpathseparator() + 'LAYOUT' + HB_OSpathseparator() + 'NF-' + strzero( Codigo, 4 ) + '.TXT' )
  cLayout := memoedit( cTxt, 02, 03, 20, 77, .t., "OutMemo", Tama + 1, , , 1, 0 )
  
  select NFisARQ
  
  if lastkey() == K_CTRL_W   
    nHandle := fcreate( cCaminho + HB_OSpathseparator() + "LAYOUT" + HB_OSpathseparator() + "NF-" + strzero( Codigo, 4 ) + ".TXT", 0 )
 
    fwrite( nHandle, cLayout + ( chr(13) + chr(10) ) )       

    fclose( nHandle )
  endif  

  restscreen( 00, 00, 23, 79, tFisc )
return NIL

//
// Comissão dos Cobradores
//
function PrinCoCb()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "CobrARQ", .t. )
    VerifIND( "CobrARQ" )

    #ifdef DBF_NTX
      set index to CobrIND1, CobrIND2
    #endif
  endif  

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )

    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2
    #endif
  endif
  
  if NetUse( "ReceARQ", .t. )
    VerifIND( "ReceARQ" )
    
    #ifdef DBF_NTX
      set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
    #endif  
  endif

  tPrt := savescreen( 00, 00, 23, 79 )
  
  Janela ( 07, 13, 12, 67, mensagem( 'Janela', 'PrinCoCb', .f. ), .f.)

  setcolor ( CorJanel + ',' + CorCampo )
  @ 09,15 say '    Data Inicial               Data Final'
  @ 10,15 say 'Cobrador Inicial           Cobrador Final'
  @ 11,15 say '       Comiss”es  Liberadas   Pedentes   Ambas '
  
  setcolor( CorCampo )
  @ 11,32 say ' Liberadas '
  @ 11,44 say ' Pedentes '
  @ 11,55 say ' Ambas '
  
  setcolor( CorAltKC )
  @ 11,33 say 'L'
  @ 11,45 say 'P'
  @ 11,56 say 'A'

  select CobrARQ
  set order to 1
  dbgotop ()
  nCobrIni := val( Cobr )
  dbgobottom ()
  nCobrFin := val( Cobr )

  select ReceARQ
  set order to 1
  dbgotop ()
  dDataIni := date() - 30
  dDataFin := date()
  nTipo    := 3
  aOpcoes  := {}
  
  @ 09,32 get dDataIni   pict '99/99/9999'
  @ 09,57 get dDataFin   pict '99/99/9999'  valid dDataFin >= dDataIni
  @ 10,32 get nCobrIni   pict '999999'      valid ValidARQ( 99, 99, "CobrARQ", "Código" , "Cobr", "Descrição", "Nome", "Cobr", "nCobrIni", .t., 6, "Consulta de Cobrador", "CobrARQ", 40 )
  @ 10,57 get nCobrFin   pict '999999'      valid ValidARQ( 99, 99, "CobrARQ", "Código" , "Cobr", "Descrição", "Nome", "Cobr", "nCobrFin", .t., 6, "Consulta de Cobrador", "CobrARQ", 40 ) .and. nCobrFin >= nCobrIni
  read

  if lastkey() == K_ESC
    select CobrARQ
    close
    select ClieARQ
    close
    select ReceARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  aadd( aOpcoes, { ' Liberadas ', 2, 'S', 11, 32, "Relatório das Comissões Liberadas." } )
  aadd( aOpcoes, { ' Pedentes ',  2, 'N', 11, 44, "Relatório das Comissões Pedentes." } )
  aadd( aOpcoes, { ' Ambas ',     2, 'A', 11, 55, "Relatório das Comissões." } )
   
  nTipo := HCHOICE( aOpcoes, 3, nTipo )

  if lastkey() == K_ESC
    select CobrARQ
    close
    select ClieARQ
    close
    select ReceARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  Aguarde ()
  
  nPag        := 1
  nLin        := 0
  cArqu2      := cArqu2 + "." + strzero( nPag, 3 )
  lInicio     := .t.

  cCobrAnt    := space(04)
  cCobrIni    := strzero( nCobrIni, 6 )
  cCobrFin    := strzero( nCobrFin, 6 )
  nTotalGeral := nTotalComi := 0
  nComiPeden  := nComiLiber := 0
  
  select ReceARQ
  set relation to Clie into ClieARQ, to Cobr into CobrARQ
  if nTipo == 1
    set order to 3
    cCampo := 'Pgto'  
  else
    set order to 2
    cCampo := 'Vcto'  
  endif  
  
  dbseek( dtos( dDataIni ), .t. )
  do while &cCampo >= dDataIni .and. &cCampo <= dDataFin .and. !eof()
    if Cobr >= cCobrIni .and. Cobr <= cCobrFin
      if nTipo == 2
        if !empty( Pgto )
          dbskip ()
          loop
        endif  
      endif     

      if empty( Pgto )
        nCobrComi := ( ( ( Valor - Desc ) + VerJuro () ) * CobrARQ->PerC ) / 100
      else
        nCobrComi := ( Pago * CobrARQ->PerC ) / 100  
      endif  
    
      if nCobrComi == 0
        dbskip ()
        loop
      endif
  
      if lInicio  
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
        
        lInicio := .f.
      endif    
      
      if nLin == 0
        Cabecalho ( 'Comissoes - Contas a Receber', 132, 3 )
        CabCoCb ()
      endif

      if Cobr != cCobrAnt
        if cCobrAnt != space(04)
          if ( nLin + 5 ) > pLimite
            Rodape(132)

            cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
            cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

            set printer to ( cArqu2 )
            set printer on
  
            Cabecalho ( 'Comissoes - Contas a Receber', 132, 3 )
            CabCoCb ()

            @ nLin,01 say cCobrAnt          pict '9999'
            @ nLin,06 say cNomeAnt
          endif  
        
          nLin ++
          @ nLin,082 say 'Total Geral Notas'
          @ nLin,109 say nTotalGeral      pict '@E 999,999,999.99'
          nLin += 2
          if nComiLiber > 0
            @ nLin,075 say 'Total Comissoes Liberada'
            @ nLin,109 say nComiLiber       pict '@E 999,999,999.99'
          endif  
          nLin ++
          if nComiPeden > 0
            @ nLin,076 say 'Total Comissoes Pedente'
            @ nLin,109 say nComiPeden       pict '@E 999,999,999.99'
          endif  
          nLin ++
          nComiPeden := nComiLeber := nTotalGeral := 0
        endif

        cCobrAnt := Cobr
        cNomeAnt := CobrARQ->Nome

        @ nLin,01 say Cobr          pict '999999'
        @ nLin,08 say CobrARQ->Nome
        nLin ++
      endif  
    
      @ nLin,005 say val( Nota )    pict '999999-99' 
      @ nLin,015 say iif( Tipo == 'P', 'Pedido', 'Nota' )
      if Clie == '999999'
        @ nLin,024 say Cliente
      else  
        @ nLin,024 say ClieARQ->Nome
      endif  
      if !empty( Pgto )
        @ nLin,068 say Pgto         pict '99/99/9999'
 
        @ nLin,079 say 'Liberada'
 
        nComiLiber += nCobrComi
      else
        @ nLin,068 say Vcto         pict '99/99/9999'

        @ nLin,079 say 'Pedente'
  
        nComiPeden += nCobrComi
      endif

      @ nLin,090 say Valor          pict '@E 999,999,999.99'
      @ nLin,109 say nCobrComi      pict '@E 999,999,999.99' 
    
      nTotalGeral += Valor

      nLin ++

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
    if ( nLin + 4 ) >= pLimite
      Rodape(132)

      cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
      cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

      set printer to ( cArqu2 )
      set printer on

      Cabecalho ( 'Comissoes - Contas a Receber', 132, 3 )
      CabCoCb ()

      @ nLin,01 say cCobrAnt          pict '999999'
      @ nLin,08 say cNomeAnt
    endif  
        
    nLin ++
    @ nLin,082 say 'Total Geral Notas'
    @ nLin,109 say nTotalGeral      pict '@E 999,999,999.99'
    nLin += 2
    if nComiLiber > 0
      @ nLin,075 say 'Total Comissoes Liberada'
      @ nLin,109 say nComiLiber       pict '@E 999,999,999.99'
    endif  
    nLin ++
    if nComiPeden > 0
      @ nLin,076 say 'Total Comissoes Pedente' 
      @ nLin,109 say nComiPeden       pict '@E 999,999,999.99'
    endif  
    Rodape(132)
  endif  
  
  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 132 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Relatório de Comissão dos Cobradores"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 132
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
    close
  endif

  select CobrARQ
  close
  select ClieARQ
  close
  select ReceARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabCoCb ()
  @ 02,001 say 'Periodo ' + ctod( dDataIni )  + ' a ' + ctod( dDataFin )
  @ 03,01 say 'Cobrador'
  @ 04,06 say 'Nota     Tipo   Cliente                                       Data       Situação            Valor           Comissão'      

  nLin     := 06
  cCobrAnt := space(04)
return NIL