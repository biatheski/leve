//  Leve, Funções do sistemas
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

#translate :while      => :cargo\[1\]
#translate :for        => :cargo\[2\]
#translate :goFirst    => :cargo\[3\]
#translate :goLast     => :cargo\[4\]
#translate :appendMode => :cargo\[5\]

#define   DB_NUM_IVARS 5

//
// Cria os arquivos do LEVE
//
function CriaARQ( xDBF, lCreate ) 
  local aArqui := {}
  local lOk    := .f.
  local cDBF   := upper( xDBF ) 
  local lLocal := .f.
  
  select EstrARQ
  set order to 1
  dbseek( cDBF, .t. )
  if alltrim(Arqu) == cDBF
    lLocal := Loca 
 
    do while alltrim(Arqu) == cDBF .and. !eof()
      aadd( aArqui, { Camp, Tipo, Tama, Deci, Desc } )
      dbskip()
    enddo  

    if lCreate  
      if lLocal
        dbCreate( (cCaminho + HB_OSpathseparator() + alltrim( EmprARQ->Direto ) + HB_OSpathseparator() + cDBF + ".DBF" ), aArqui )
      else  
        dbCreate( cCaminho + HB_OSpathseparator() + cDBF + ".DBF", aArqui )
      endif
      
      lOk := .t.  
    else  
      lOk := aArqui  
    endif

  else
    Alerta( mensagem( "Alerta", "CriaARQ", .f. ) + " " + cDBF )  
  endif  
return(lOk)

//
// Entra no sistema
// 
function Logado()
  
  Janela( 08, 17, 15, 59, mensagem( "Janela", "Logado", .f. ), .f. )
  
  setcolor( CorJanel )
  @ 10,20 say "Usuário"
  @ 11,20 say "    Dia" 
  @ 12,20 say "   Hora" 
  @ 14,34 say "Logado na estação N."

  select UsuaARQ
  
  setcolor( CorCampo )
  @ 10,28 say Nome           pict "@S30" 
  @ 11,28 say dLogData       pict "99/99/99"
  @ 12,28 say cLogHora      
  @ 14,55 say nEstacao       pict "999"

  inkey(.5)
return NIL

//
// Acesso ao diretorio
//
function Acesso()
  
  cDBF := alias()
  
  select EmprARQ
  
  cDireto := cCaminho + HB_OSpathseparator() + alltrim( Direto )
  lExiste := iif( dirchange( cDireto ) == 0, .f., .t. )

  if lExiste
    dirmake( cDireto )
    dirchange( cDireto )
  endif
  
  #ifdef __PLATFORM__Windows
    cDireto += ";" + cCaminho
  #else
    cDireto += ":" + cCaminho 
  #endif
  
  set path to
  set path to ( cDireto ) 
 
  if !empty( cDBF )
    select ( cDBF )
  endif
return NIL

//
// verifica a senha
// 
function Senha( cPass )

  tSenha := savescreen( 00, 00, 23, 79 )
  lOkey  := .f.

  for nL := 1 to 3
    cSenha := space(10)
    Janela ( 08, 20, 11, 50, mensagem( "Janela", "Senha", .f. ), .f. )
    setcolor( CorJanel + "," + CorCampo )
    @ 10,26 say "Senha"
  
    setcolor( CorCampo )
    cSenhaNew := PASSWORD( 10, 32, 12, chr(254) )
  
    if lastkey() == K_ESC
      lOkey := .f.
      exit
    endif
    
    if alltrim( cSenhaNew ) == alltrim( cPass )
      lOkey := .t.
      exit
    else  
      Alerta( mensagem( "Alerta", "Senha", .f. ) ) 
    endif
  next    
  restscreen( 00, 00, 23, 79, tSenha )
return( lOkey )

//
// Cria uma nova classe de Browse com filtro
//
function TBrowseFW( bWhile, bFor, bFirst, bLast )

  local oTbr         := TBrowseNew()

  oTbr:cargo         := Array( DB_NUM_IVARS )
  oTbr:while         := bWhile
  oTbr:for           := bFor
  oTbr:goFirst       := bFirst
  oTbr:goLast        := bLast
  oTbr:appendMode    := .f.
  oTbr:goTopBlock    := {|| TBFirst( oTbr ) }
  oTbr:goBottomBlock := {|| TBLast( oTbr )  }
  oTbr:skipBlock     := {|n| DbSkipBlock( n, oTbr ) }

  oTbr:goTop()

return oTbr

//
// Posiciona a nova classe de Browse no primeiro registro
//
static function TBFirst( oTbr )
    
  Eval( oTbr:goFirst )

  do while !eof() .and. Eval( oTbr:while ) .and. !Eval( oTbr:for )
    dbskip ()
  enddo

  if eof() .or. !Eval( oTbr:while )
    goto 0
  endif
    
return NIL

//
// Posiciona a nova classe de Browse no ultimo registro
//
static function TBLast( oTbr )
    
  if oTbr:appendMode
    goto 0
  else
    Eval( oTbr:goLast )

    do while !bof() .and. Eval( oTbr:while ) .and. !Eval( oTbr:for )
      dbskip(-1)
    enddo
    
    if bof() .or. !Eval( oTbr:while )
      goto 0
    endif
  endif
return NIL

//
// Posiciona uma nova classe de Browse no registro
//
static function TBNext( oTbr )

  local nSaveRecNum := recno()
  local lMoved      := .T.

  if eof()
    lMoved := .F.
  else
    dbskip ()
    do while !Eval( oTbr:for ) .and. Eval( oTbr:while ) .and. !eof()
      dbskip ()
    enddo

    if eof() .and. oTbr:appendMode
      // fine ...
    elseif !Eval( oTbr:while ) .or. eof()
      if !Eval( oTbr:while ) .and. oTbr:appendMode
        goto 0
      else
        lMoved := .F.
        goto nSaveRecNum
      endif
    endif
  endif

return lMoved

//
// Posiciona uma nova classe de Browse no registro
//
static function TBPrev( oTbr )

  local nSaveRecNum := Recno()
  local lMoved      := .T.

  if eof()
    Eval( oTbr:goLast )
  else
    dbskip(-1)
  endif

  do while !Eval( oTbr:for ) .and. Eval( oTbr:while ) .and. !bof()
    skip -1
  enddo

  if !Eval( oTbr:while ) .or. bof()
    goto nSaveRecNum

    lMoved := .f.
  endif

return lMoved

//
// Movimenta o registro
//
static function DbSkipBlock( n, oTbr )

  local nSkipped := 0

  if n == 0
    dbskip(0)
  elseif n > 0
    do while nSkipped != n .and. TBNext( oTbr )
      nSkipped ++
    enddo
  else
    do while nSkipped != n .and. TBPrev( oTbr )
      nSkipped --
    enddo
  endif

return nSkipped

//
// Cria arquivo Tempor rio
//
function CriaTemp( cDire )
  
  do case 
    case cDire == 0 
      cArqTemp := cCaminho + HB_OSpathseparator() + "temp" + HB_OSpathseparator() + "tm" + left( time(), 2 ) + ;
                  subst( time(), 4, 2 ) + right( time(), 2 ) + "." + right( cUsuario, 3 )
                  
      if file( cArqTemp )
        do while .t.
          ferase( cArqTemp )
      
          cArqTemp := cCaminho + HB_OSpathseparator() + "temp" + HB_OSpathseparator() + "tm" + left( time(), 2 ) + ;
                      subst( time(), 4, 2 ) + strzero( int( hb_random(99+1) ), 2 ) + "." + right( cUsuario, 3 )

          if file( cArqTemp )
            loop
          else
            exit
          endif    
        enddo              
      endif            
    case cDire == 1 
      #ifdef DBF_CDX
        cExt := ".cdx"
      #endif

      #ifdef DBF_NTX
        cExt := ".ntx"
      #endif  

      cArqTemp := cCaminho + HB_OSpathseparator() + "temp" + HB_OSpathseparator() + "tm" + left( time(), 2 ) + ;
                  subst( time(), 4, 2 ) + right( time(), 2 ) + cExt

      if file( cArqTemp )
        do while .t.
          ferase( cArqTemp )
      
          cArqTemp := cCaminho + HB_OSpathseparator() + "temp" + HB_OSpathseparator() + "tm" + left( time(), 2 ) + ;
                      subst( time(), 4, 2 ) + strzero( int( hb_random(99+1) ), 2 ) + cExt

          if file( cArqTemp )
            loop
          else
            exit
          endif    
        enddo              
      endif            
    case cDire == 2
      cArqTemp := left( time(), 2 ) + subst( time(), 4, 2 ) + right( time(), 2 ) 
    case cDire == 5
      cArqTemp := cCaminho + HB_OSpathseparator() + "SPOOL" + HB_OSpathseparator() + left( dtoc( date() ), 2 ) +;
                  left( time(), 2 ) + subst( time(), 4, 2 ) + right( time(), 2 )
  endcase
return( cArqTemp )

//
// Converte CHR
//
function ValidCHR(cString)
  nIni := 1
  cOut := ''
  
  for nL := 1 to len( cString )
    if substr( cString, nL, 1 ) == " " 
      cOut += "chr(" + substr( cString, nIni, nL - nIni ) + ") + "
      nIni := nL + 1
    endif  
  next
    
  if nL >= 2  
    cOut += "chr(" + substr( cString, nIni, nL - nIni ) + ")"
  endif  
return(cOut)

//
// Cabecalho do Relatorio
//
function Cabecalho( xTitu, xTama, xModu )

  setprc( 0, 0 )

  nColIni := 0
  nColMei := int( xTama / 2 ) - 4
  nColFin := xTama - len( xTitu )
  
  if EmprARQ->Impr == "X"
    if xTama == 80
      @ 00,00 say chr(18)
    else
      @ 00,00 say chr(15)
    endif  
  endif
  
  EmprARQ->(dbsetorder(1))
  EmprARQ->(dbseek(cEmpresa,.f.))
    
  @ 00, nColIni say EmprARQ->Razao          pict "@S30"

  do case
    case xModu == 1
      @ 00, nColMei say " Compras "
    case xModu == 2
      @ 00, nColMei say " Estoque "
    case xModu == 3
      @ 00, nColMei say "  Vendas "
    case xModu == 4
      @ 00, nColMei say "  Caixa  "
    case xModu == 5
      @ 00, nColMei say "  Ponto  "
  endcase    
  @ 00, nColFin say xTitu
  @ 01, nColIni say replicate( "-", xTama )
return NIL

// 
// Imprimi o Rodape
//
function Rodape ( nTama )
  nColIni := 0
  nColMei := int( nTama / 2 ) - int( len( "Pagina " + str( nPag, 4 ) ) / 2 )
  
  if EmprARQ->Impr == "X"
    if nTama == 80
      @ pLimite,00 say chr(18)
    else
      @ pLimite,00 say chr(15)
    endif  
  endif

  @ pLimite,nColIni say replicate( "-", nTama )
  @ (pLimite+1),nColIni say "LEVE " + cVersao
  @ (pLimite+1),nColMei say "Página " + str( nPag, 4 )

  @ (pLimite+1),(nTama-19) say date()           pict "99/99/9999"
  @ (pLimite+1),(nTama-08) say time()
  
  nLin := 0
  nPag ++
  
  set printer to
  set printer off
return NIL

//
// Verifica as empresas cadastradas
// 
function VerEmpr( lSair )

  local tVerEmpr := savescreen( 00, 00, 24, 79 )
  local lOk      := .f.
  local lMuda    := .f.
  local cFile    := alias()
  local GetList  := {}

  select EmprARQ
  set order to 2

  Janela( 05, 15, 17, 63, mensagem( "Janela", "VerEmpr", .f. ), .f. )  

  setcolor( CorJanel + "," + CorCampo )
  oBrowse           := TBrowseDB( 07, 16, 15, 62 )
  oBrowse:headsep   := chr(194)+chr(196)
  oBrowse:colsep    := chr(179)
  oBrowse:footsep   := chr(193)+chr(196)
  oBrowse:colorSpec := CorJanel + ',' + CorCampo
 
  oBrowse:addColumn( TBColumnNew( "Código", {|| Empr } ) )
  oBrowse:addColumn( TBColumnNew( "Nome", {|| left( Razao, 40 ) } ) )
  oBrowse:goTop ()

  oBrowse:colpos := 2
  lExitRequested := .f.
  nLinBarra      := 1
  cLetter         := ""
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 08, 15, 63, nTotal )

  setcolor ( CorCampo )
  @ 16,26 say space(32)

  setcolor( CorJanel + "," + CorCampo )
  @ 08,15 say chr(195)
  @ 15,15 say chr(195)
  @ 16,17 say "Consulta"
   
  do while !lExitRequested
    Mensagem( "Func", "VerEmpr" )

    oBrowse:forcestable()
    
    PosiDBF( 05, 63 )
    
    cTecla := Teclar(0)
 
    iif( BarraSeta, BarraSeta( nLinBarra, 08, 15, 63, nTotal ), NIL )
       
    do case
      case cTecla == K_DOWN .or. cTecla == K_PGDN .or. cTecla == K_CTRL_PGDN
        if !oBrowse:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif
        endif
      case cTecla == K_UP .or. cTecla == K_PGUP .or. cTecla == K_CTRL_PGUP
        if !oBrowse:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif
        endif
    endcase
      
    do case
      case cTecla == K_DOWN;       oBrowse:down()
      case cTecla == K_UP;         oBrowse:up()
      case cTecla == K_PGDN;       oBrowse:pageDown()
      case cTecla == K_PGUP;       oBrowse:pageUp()
      case cTecla == K_CTRL_PGUP;  oBrowse:goTop()
      case cTecla == K_CTRL_PGDN;  oBrowse:goBottom()
      case cTecla == K_ENTER;      lExitRequested := .t.; lMuda := .t.
      case cTecla == K_ESC;        iif( lSair, Finalizar(), lExitRequested := .t. )
      case cTecla == K_BS
        cLetter := substr( cLetra, 1, len( cLetra ) - 1 )
    
        setcolor ( CorCampo )
        @ 16,26 say space(32)
        @ 16,26 say cLetter
      case cTecla >= 32 .and. cTecla <= 128
        cLetter += chr( cTecla )    
  
        if len( cLetter ) > 32
          cLetter := ""
        endif  
     
        setcolor ( CorCampo )
        @ 16,26 say space(32)
        @ 16,26 say cLetter
 
        dbseek( cLetter, .t. )       

        oBrowse:refreshAll()
      case cTecla == K_ALT_A
        tAltera   := savescreen( 00, 00, 22, 79 )

        Empr (.t.)

        cLetter := ""

        restscreen( 00, 00, 22, 79, tAltera )
        
        select EmprARQ
        set order to 2
        dbseek( EmprARQ->Nome, .f. )

        setcolor ( CorCampo )
        @ 16,26 say space(32)
        @ 16,26 say cLetter
        
        oBrowse:refreshAll()  
        case cTecla == K_INS
        tAltera   := savescreen( 00, 00, 22, 79 )

        Empr (.f.)

        cLetter := ""

        restscreen( 00, 00, 22, 79, tAltera )
        
        setcolor ( CorCampo )
        @ 16,26 say space(32)
        @ 16,26 say cLetter

        select EmprARQ
        set order to 2
        dbseek( EmprARQ->Nome, .f. )
        
        oBrowse:refreshAll()  
    endcase
      
    select EmprARQ
    set order to 2
  enddo
  
  restscreen( 00, 00, 24, 79, tVerEmpr )

  if lMuda
    cEmpresa  := Empr
    EmprNome  := Razao
    mCodModu  := Empr 
    cIdioma   := Idio
    pLimite   := Limite 

    setcolor ( CorMenus )
    @ 23,01 say space(40)
    @ 23,01 say Razao
    @ 23,41 say chr(179) + time () + chr(179) + dtoc( date() ) + chr(179)
    
    cPath := cCaminho + ";" + ( cCaminho + HB_OSpathseparator() + alltrim( Direto ) )
    
    set path to ( cPath )

    Acesso()
    
  endif
  

  if ! empty( cFile )
    select ( cFile )
  endif
  setcolor ( CorJanel + "," + CorCampo )
return( lMuda )

//
// Abre uma janela com os Produtos cadastrados
//
function ValidProd ( nLinha, nColuna, pFile, pTipo, pAcrs, pCusto, pVenda, pProd )
  local GetList := {}
  
  if lastkey() == K_UP .or. lastkey() == K_DOWN
    return(.t.)
  endif  
   
  lOk       := .f.
  pStatAnt  := cStat
  
  if alltrim( cProd ) == "."
    keyboard( chr(27)+chr(46) )
    return(.f.)
  else 
    if nLinha == 99
      cProd := strzero( &pProd, 6 )
    else
      cProd := strzero( val( cProd ), 6 )  
    endif  
  endif  
  
  if pVenda == NIL 
    pVenda := 0 
  endif  

  if pCusto == NIL
    pCusto := 0 
  endif  
 
  setcolor ( CorCampo )
  select ProdARQ
  set order to 1
  dbseek( cProd, .f. )
  if cProd == "999999" .or. alltrim( cProd ) == "*"
    if cProd == "*"
      cProd := "999999"
    endif
    lOk := .t.
  else
    if eof()
      do case 
        case EmprARQ->ConsProd == 1 .or. EmprARQ->ConsProd == 3 .or. EmprARQ->ConsProd == 4
          nColCons := ConsProd( pTipo )
        case EmprARQ->ConsProd == 2 .or. EmprARQ->ConsProd == 5 .or. EmprARQ->ConsProd == 6
          nColCons := ConsTabp( pTipo )
      endcase      
      lOk := .t.
    else
      nColCons := 1
      lOk      := .t.
    endif   
  endif
  
  if lastkey() == K_ESC
    nProd := 0
    cProd := space(06)
    lOk   := .f.
  endif  
   
  if lOk
    setcolor( CorCampo) 
    if cProd == "999999"
      cProd    := "999999"
      nProd    := 999999
      nColCons := 2
    else
      if nLinha == 99
        &pProd := val( Prod )
      else  
        cProd := Prod
        nProd := val( cProd )
      endif  
    endif  
    
    if nLinha != 99

    if pCusto == 0 .or. cProd != &pFile->Prod  
      nPrecoCusto := PrecoCusto
    endif  

    if pVenda == 0 .or. cProd != &pFile->Prod  
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
            nPrecoVenda := PrecoVenda * nMoedaDia
          else
            nPrecoVenda := PrecoVenda
          endif  
      endcase
    endif
    
    lOk := .t.

    do case
      case pTipo == "ipro"
        nNome := 20 
      case pTipo == "comp" .or. pTipo == "nota"
        nNome := 23 
      case pTipo == "pedi" 
        nNome := 22
      case pTipo == "enot"
        nNome := 13
      case pTipo == "tbpr" .or. pTipo == "cota" 
        nNome := 38
      case pTipo == "epro"
        nNome := 25
      case pTipo == "spro" .or. pTipo == "abos"
        nNome := 28
      case pTipo == "enos".or. pTipo == "copr"
        nNome := 33
      case pTipo == "opro"
        nNome := 25
        if pVenda == 0
          nPrecoVenda := ( ( PrecoVenda * CondARQ->Acrs ) / 100 ) + PrecoVenda

          if EmprARQ->Moeda == "X"
            nPrecoVenda := PrecoVenda * nMoedaDia
          endif  
        else
          if cProd != &pFile->Prod  
            nPrecoVenda := ( ( PrecoVenda * CondARQ->Acrs ) / 100 ) + PrecoVenda

            if EmprARQ->Moeda == "X"
              nPrecoVenda := PrecoVenda * nMoedaDia
            endif  
          endif  
        endif
      otherwise
        nNome := 0    
    endcase    

    @ nLinha, nColuna say cProd

    if cProd == "999999" 
      if EmprARQ->MemoProd == "X"
        cProduto    := &pFile->Produto
        cUnidade    := &pFile->Unidade
        nPrecoCusto := &pFile->PrecoCusto
        tEntrProd := savescreen( 00, 00, 24, 79 )

        Janela( 03, 12, 10, 69, mensagem( 'Janela', 'ValidProd', .f. ), .f. )
        Mensagem( 'Func', 'ValidProd' ) 
      
        setcolor( CorJanel )      
        @ 09,14 say 'Unidade                         Preço Custo'
   
        setcolor( CorCampo )     
        @ 09,22 say cUnidade    
        @ 09,58 say nPrecoCusto     pict PictPreco(10)       
          
        cProduto := memoedit( cProduto, 05, 14, 08, 67, .t., "OutProd" )
      
        if lastkey() != K_ESC
          @ 09,22 get cUnidade    
          @ 09,58 get nPrecoCusto     pict PictPreco(10)       
          read
        endif
      
        restscreen( 00, 00, 24, 79, tEntrProd )
  
        setcolor( CorCampo )       
        @ nLinha, nColuna+7 say memoline( cProduto, nNome, 1 )
      else
        cProduto    := memoline( &pFile->Produto, 50, 1 )
        cUnidade    := &pFile->Unidade
        nPrecoCusto := &pFile->PrecoCusto
     
        @ nLinha, nColuna+7 get cProduto  pict '@S20'
	      read	
      endif  
    else  
      @ nLinha, nColuna+7 say left( Nome, nNome )
    endif

    do case
      case pTipo == "comp"
        @ nLinha, 34 say ProdARQ->Refe         pict '@S10' 
        @ nLinha, 55 say nPrecoCusto           pict PictPreco(10)
      case pTipo == "pedi"
        if nComi == 0
          nComi := PerC
        else
          if cProd != &pFile->Prod  
            nComi := PerC
          endif  
        endif  

        @ nLinha, 49 say nComi                 pict "@E 99.99"
        @ nLinha, 56 say nPrecoVenda           pict PictPreco(10)
      case pTipo == "nota"
        if nComi == 0
          nComi := PerC
        else
          if cProd != &pFile->Prod  
            nComi := PerC
          endif  
        endif  

        @ nLinha, 44 say nComi                 pict "@E 99.99"
        @ nLinha, 56 say nPrecoVenda           pict PictPreco(10)
      case pTipo == "enot"
        @ nLinha, 33 say nPrecoCusto           pict PictPreco(9)
      case pTipo == "tbpr"
        @ nLinha, 59 say nPrecoCusto           pict PictPreco(10)
      case pTipo == "opro"
        @ nLinha, 52 say nPrecoVenda           pict PictPreco(10)
      case pTipo == "epro"
        @ nLinha, 51 say nPrecoCusto           pict PictPreco(10)
      case pTipo == "spro"
        @ nLinha, 51 say nPrecoVenda           pict PictPreco(10)
      case pTipo == "abos"
        @ nLinha, 53 say nPrecoVenda           pict PictPreco(8)
      case pTipo == "enos"
        @ nLinha, 55 say nPrecoVenda           pict PictPreco(8)
    endcase   
  endif   
  
  endif

  cStat          := pStatAnt
  lExitRequested := .f.

  set order  to 1
  select &pFile 
  setcolor ( CorJanel + "," + CorCampo )
return(lOk)

function OutProd( wModo, wlin , wCol )
  cRetVal := 0
  nKey    := lastkey()
  
//  do case 
//    case nKey == K_CTRL_RET
//      cRetVal := K_CTRL_W
//      keyboard(chr(K_CTRL_W))
//  endcase
return( cRetVal )

//
// Abre uma janela com os subgrupos cadastrados
//
function ValidSubG ( nLinha, nColuna, cFile, xGrup )
  local GetList := {}
  
  if lastkey() == K_UP .or. lastkey() == K_DOWN
    return(.t.)
  endif  

  tValSubG   := savescreen( 00, 00, 24, 79 )
  lOk        := .t.
  
  setcolor ( CorCampo )
  select SubGARQ
  set order    to 1
  set relation to Grup into GrupARQ
  set filter   to Grup == strzero( nGrup, 6 )
  cSubG := strzero( nSubG, 6 )
  dbseek( strzero( nGrup, 6 ) + cSubG, .f. )
  if eof()
    set order to 2
    Janela( 05, 15, 17, 63, mensagem( "Janela", "ValidSubG", .f. ), .f. )  

    oSubGru           := TBrowseDB( 07, 16, 15, 62 )
    oSubGru:headsep   := chr(194)+chr(196)
    oSubGru:colsep    := chr(179)
    oSubGru:footsep   := chr(193)+chr(196)
    oSubGru:colorSpec := CorJanel + ',' + CorCampo

    oSubGru:addColumn( TBColumnNew( "Código", {|| SubG } ) )
    oSubGru:addColumn( TBColumnNew( "Nome", {|| Nome } ) )

    oSubGru:goTop ()

    oSubGru:colpos := 2
    lExitRequested := .f.
    nLinBarra      := 1
    cLetter         := ""
    nTotal         := lastrec()
    BarraSeta      := BarraSeta( nLinBarra, 08, 15, 63, nTotal )

    setcolor ( CorCampo )
    @ 16,26 say space(30)

    setcolor( CorJanel + "," + CorCampo )
    @ 08,15 say chr(195)
    @ 15,15 say chr(195)
    @ 16,17 say "Consulta"
    
    do while !lExitRequested
      Mensagem( "Func", "ValidProd" )

      oSubGru:forcestable() 

      PosiDBF( 05, 63 )

      iif( BarraSeta, BarraSeta( nLinBarra, 08, 15, 63, nTotal ), NIL )
        
      if oSubGru:stable
        if oSubGru:hitTop .or. oSubGru:hitBottom
          tone( 125, 0 )        
        endif  
        
        cTecla := Teclar(0)
      endif
        
      do case
        case cTecla == K_DOWN 
          if !oSubGru:hitBottom
            nLinBarra ++
            if nLinBarra >= nTotal
              nLinBarra := nTotal 
            endif  
          endif  
        case cTecla == K_UP 
          if !oSubGru:hitTop
            nLinBarra --
            if nLinBarra < 1
              nLinBarra := 1
            endif  
          endif
      endcase
        
      do case
        case cTecla == K_DOWN;       oSubGru:down()
        case cTecla == K_UP;         oSubGru:up()
        case cTecla == K_PGDN;       oSubGru:pageDown()
        case cTecla == K_PGUP;       oSubGru:pageUp()
        case cTecla == K_CTRL_PGUP;  oSubGru:goTop()
        case cTecla == K_CTRL_PGDN;  oSubGru:goBottom()
        case cTecla == K_ESC;        lExitRequested := .t.
        case cTecla == K_ENTER
          lOk            := .t.
          lExitRequested := .t.
        case cTecla == K_BS
          cLetter := substr( cLetra, 1, len( cLetra ) - 1 )
      
          setcolor ( CorCampo )
          @ 16,26 say space(30)
          @ 16,26 say cLetter
        case cTecla >= 32 .and. cTecla <= 128
          cLetter += chr( cTecla )    
          
          if len( cLetter ) > 30
            cLetter := "" 
          endif  
       
          setcolor ( CorCampo )
          @ 16,26 say space(30)
          @ 16,26 say cLetter

          dbseek( cLetter, .t. )

          oSubGru:refreshAll()
        case cTecla == K_INS;      tSubGTela := savescreen( 00, 00, 24, 79 )
          SubG( .f., xGrup )

          cLetter := ""

          restscreen( 00, 00, 24, 79, tSubGTela )

          nGrup := val( SubGARQ->Grup )
          
          select SubGARQ
          set order    to 2
          set relation to Grup into GrupARQ
          set filter   to Grup == strzero( nGrup, 6 )
          
          oSubGru:refreshAll()  
          
          setcolor ( CorCampo )
          @ 16,26 say space(30)
        case cTecla == K_ALT_A;    tSubGTela := savescreen( 00, 00, 24, 79 )
          SubG (.t., xGrup )

          cLetter := ""

          restscreen( 00, 00, 24, 79, tSubGTela )

          nGrup := val( SubGARQ->Grup )
          
          select SubGARQ
          set order    to 2
          set relation to Grup into GrupARQ
          set filter   to Grup == strzero( nGrup, 6 )
    
          oSubGru:refreshAll()  
          
          setcolor ( CorCampo )
          @ 16,26 say space(30)
      endcase
    enddo  
  else
    lOk := .t.
  endif   
  
  restscreen( 00, 00, 24, 79, tValSubG )
  if lOK
    setcolor( CorCampo )   
    cSubG := SubG
    nSubG := val( cSubG )
    lOk   := .t.

    @ nLinha, nColuna   say SubG
    @ nLinha, nColuna+7 say Nome
  endif   

  set filter to
  set order  to 1
  select &cFile 
  setcolor ( CorJanel + "," + CorCampo )
return(lOk)

//
// Abre uma janela com os Clientes cadastrados
//
function ValidClie ( nLinha, nColuna, cFile, pClie, xTama, pTodas )
  local GetList := {}
  
  if lastkey() == K_UP .or. lastkey() == K_DOWN
    return(.t.)
  endif  

  tValClie  := savescreen( 00, 00, 24, 79 )
  lOk       := .f.
  iStatAnt  := cStat
  
  if nLinha == 99
    cClie := strzero( &pClie, 6 )
  else
    cClie := strzero( nClie, 6 )
  endif    
    
  select ClieARQ
  set order to 1
  dbseek( cClie, .f. )
  if cClie == "999999" 
    lOk := .t.
  else
    if eof()
      ConsClie ()
    else
     lOk := .t.
    endif   
  endif  
  
  if pTodas != NIL  
    if EmprARQ->ConsClie == "X" .and. cClie != "999999" 
      ConsTodas ()
    endif  
  endif  

  restscreen( 00, 00, 24, 79, tValClie )

  select ClieARQ
  set order to 1
  if cClie != "999999"
    if !empty( Evento )
      tMostEven := savescreen( 00, 00, 23, 79 )

      Janela( 03, 13, 13, 66, mensagem( 'Janela', 'Evento', .f. ), .f. )
      Mensagem( 'Func', 'Evento', .f. )
         
      setcolor( CorCampo )     
           
      nQtLin := mlcount( Evento, 50 )
      nLin   := 05

      for nK := 1 to nQtLin
        @ nLin,15 say memoline( Evento, 50, nK )
        nLin ++  
        if nLin > 12
          exit
        endif  
      next   
      
      if nLin < 13
        for nJ := nLin to 12
          @ nJ,15 say space(50)
        next
      endif  
      
      do while lastkey() != K_SPACE
        inkey()
      enddo  
        
      restscreen( 00, 00, 23, 79, tMostEven )
    endif
  endif

  if lOk
    setcolor( CorCampo) 
    if cClie != "999999"
      cClie := Clie
      nClie := val( cClie )
    endif
    
    if nLinha == 99
      if cClie == "999999"    
        &pClie := 999999
      else
        &pClie := val( Clie )
      endif  
    else
      @ nLinha, nColuna say cClie
 
      if cClie == "999999"
        cCliente := &cFile->Cliente
      
        if xTama == NIL
          @ nLinha, nColuna+7 get cCliente          pict "@S28"
        else
          @ nLinha, nColuna+7 get cCliente          pict "@S" + str( xTama, 2 )
        endif  
        read
      else  
        if xTama == NIL
          @ nLinha, nColuna+7 say Nome              pict "@S28"
        else  
          @ nLinha, nColuna+7 say left( Nome, xTama )              
        endif  
      endif  
    endif  
  endif   
  
  cStat          := iStatAnt
  lExitRequested := .f.

  select &cFile 
  setcolor ( CorJanel + "," + CorCampo )
return(lOk)

//
// Abre uma janela com os Fornecedores cadastrados
//
function ValidForn ( nLinha, nColuna, cFile, pForn, xTama )
  local GetList := {}
  
  if lastkey() == K_UP .or. lastkey() == K_DOWN
    return(.t.)
  endif  

  tValForn  := savescreen( 00, 00, 24, 79 )
  lOk       := .f.
  iStatAnt  := cStat

  if nLinha == 99
    cForn   := strzero( &pForn, 6 )
  else
    cForn   := strzero( nForn, 6 )
  endif  
    
  select FornARQ
  set order to 1
  dbseek( cForn, .f. )
  
  if eof()
    ConsForn ()
  else
    lOk := .t.
  endif   
  
  restscreen( 00, 00, 24, 79, tValForn )

  select FornARQ
  set order to 1

  if lOk
    setcolor( CorCampo) 
    cForn := Forn
    nForn := val( cForn )
    lOk   := .t.
    
    if nLinha == 99
      &pForn := nForn
    else
      @ nLinha, nColuna   say Forn
      if xTama == NIL
        @ nLinha, nColuna+7 say Nome                pict "@S28"
      else
        @ nLinha, nColuna+7 say left( Nome, xTama )
      endif
    endif  
  endif   
  
  cStat          := iStatAnt
  lExitRequested := .f.

  select &cFile 
  setcolor ( CorJanel + "," + CorCampo )
return(lOk)

//
// Selecionar os Campos
//
function SeleGera ( cDBF )

  aCampo    := {}
  cCampARQ  := CriaTemp(0)
  tSeleGera := savescreen( 00, 00, 23, 79 )
    
  Janela( 04, 24, 18, 50, mensagem( 'Janela', 'SeleGera', .f. ), .f. )
  setcolor( CorJanel + "," + CorCampo )
   
  aadd( aCampo, { "Marc",       "C", 04, 0 } )
  aadd( aCampo, { "Vari",       "C", 20, 0 } )
  aadd( aCampo, { "Desc",       "C", 20, 0 } )

  dbcreate( cCampARQ , aCampo )

  if NetUse( cCampARQ, .f., 30 )
    cCampARQ := alias ()
  endif  
  
  select( cCampARQ )
      
  aStruct := CriaARQ( cDBF, .f. )
      
  for nK := 1 to len( aStruct )
    
    cMarc := '[X] '
    cVari := aStruct[ nK, 1 ]
    cDesc := substr( ( aStruct[ nK, 5 ] + space(15) ), 1, 16 )
    
    select( cCampARQ )
    if AdiReg()  
      if RegLock()
        replace Marc           with cMarc
        replace Vari           with cVari
        replace Desc           with cDesc
        dbunlock ()
      endif
    endif    
  next
 
  setcolor( CorJanel + "," + CorCampo )
  oCampo           := TBrowseDB( 06, 25, 17, 49 )
  oCampo:headsep   := chr(196) 
  oCampo:colsep    := chr(255)
  oCampo:colorSpec := CorJanel
   
  oCampo:addColumn( TBColumnNew( ,      {|| Marc } ) )
  oCampo:addColumn( TBColumnNew( "Nome",{|| Desc } ) )
  
  oCampo:goTop ()

  oCampo:colPos  := 2
  oCampo:freeze  := 2
  lExitRequested := .f.
  
  @ 07,24 say chr(195)
  @ 07,50 say chr(180)

  do while !lExitRequested
    Mensagem( "Utilize as setas para movimentar, <ESPACO> para Marcar/Desmarcar, <*> Todos" )

    oCampo:forcestable()

    cTecla := Teclar(0)

    do case
      case cTecla == K_DOWN;       oCampo:down()
      case cTecla == K_UP;         oCampo:up()
      case cTecla == K_PGDN;       oCampo:pageDown()
      case cTecla == K_PGUP;       oCampo:pageUp()
      case cTecla == K_CTRL_PGUP;  oCampo:goTop()
      case cTecla == K_CTRL_PGDN;  oCampo:goBottom()
      case cTecla == K_ENTER;      lExitRequested := .t.
      case cTecla == K_ESC;        lExitRequested := .t. 
      case cTecla == K_SPACE
        if RegLock()
          if &cCampARQ->Marc == '[X] ' 
            replace Marc        with '[ ] '
          else 
            replace Marc        with '[X] ' 
          endif
          dbunlock ()
        endif    
      
        oCampo:refreshAll()  
      case cTecla == 42
        dbgotop ()
        do while !eof()
          if RegLock()
            replace Marc        with '[X] '
            dbunlock ()
          endif    
          dbskip ()
        enddo  
        
        oCampo:goTop()
        oCampo:refreshAll()  
    endcase
  enddo
   
  restscreen( 00, 00, 23, 79, tSeleGera )  
return NIL

//
// Abre uma janela com os Contas cadastrados
//
function ValidCont ( nLinha, nColuna, cFile, xCont )
  local GetList := {}
  
  if lastkey() == K_UP .or. lastkey() == K_DOWN
    return(.t.)
  endif  

  tValCont   := savescreen( 05, 15, 19, 65 )
  lOk        := .t.
    
  if nLinha == 99
    nCont := iif( empty( xCont ), 0, val( xCont ) )
  endif  

  setcolor ( CorCampo )
  select ContARQ
  set order to 1
  dbseek( strzero( nCont, 6 ), .f. )
  if eof() .or. nLinha == 99
    set order to 2
    Janela( 05, 15, 17, 63, mensagem( "Janela", "ValidCont", .f. ), .f. )  

    setcolor( CorJanel + "," + CorCampo )

    oContas           := TBrowseDB( 07, 16, 15, 62 )
    oContas:headsep   := chr(194)+chr(196)
    oContas:colsep    := chr(179)
    oContas:footsep   := chr(193)+chr(196)
    oContas:colorSpec := CorJanel
 
    oContas:addColumn( TBColumnNew( "Código", {|| Cont } ) )
    oContas:addColumn( TBColumnNew( "Nome", {|| Nome } ) )
    oContas:addColumn( TBColumnNew( "Tipo", {|| iif( Tipo == "R", "Receita", "Despesa" ) } ) )
  
    oContas:goTop ()

    oContas:freeze := 1
    lExitRequested := .f.
    nLinBarra      := 1
    cLetter         := ""
    nTotal         := lastrec()
    BarraSeta      := BarraSeta( nLinBarra, 08, 15, 63, nTotal )

    setcolor ( CorCampo )
    @ 16,26 say space(32)

    setcolor( CorJanel + "," + CorCampo )
    @ 08,15 say chr(195)
    @ 15,15 say chr(195)
    @ 16,17 say "Consulta"
    
    do while !lExitRequested
      Mensagem( "Func", "ValidProd" )

      oContas:forcestable() 

      PosiDBF( 05, 63 )

      iif( BarraSeta, BarraSeta( nLinBarra, 08, 15, 63, nTotal ), NIL )
        
      if oContas:stable
        if oContas:hitTop .or. oContas:hitBottom
          tone( 125, 0 )        
        endif  
        cTecla := Teclar(0)
      endif
        
      do case
        case cTecla == K_DOWN 
          if !oContas:hitBottom
            nLinBarra ++
            if nLinBarra >= nTotal
              nLinBarra := nTotal 
            endif  
          endif  
        case cTecla == K_UP 
          if !oContas:hitTop
            nLinBarra --
            if nLinBarra < 1
              nLinBarra := 1
            endif  
          endif
      endcase
        
      do case
        case cTecla == K_DOWN;       oContas:down()
        case cTecla == K_UP;         oContas:up()
        case cTecla == K_PGDN;       oContas:pageDown()
        case cTecla == K_PGUP;       oContas:pageUp()
        case cTecla == K_CTRL_PGUP;  oContas:goTop()
        case cTecla == K_CTRL_PGDN;  oContas:goBottom()
        case cTecla == K_ESC;        lExitRequested := .t.
        case cTecla == K_ENTER
          lOk            := .t.
          lExitRequested := .t.
        case cTecla == K_BS
          cLetter := substr( cLetra, 1, len( cLetra ) - 1 )
      
          setcolor ( CorCampo )
          @ 16,26 say space(32)
          @ 16,26 say cLetter
        case cTecla >= 32 .and. cTecla <= 128
          cLetter += chr( cTecla )    
          
          if len( cLetter ) > 32
            cLetter := ""
          endif  
       
          setcolor ( CorCampo )
          @ 16,26 say space(32)
          @ 16,26 say cLetter

          dbseek( cLetter, .t. )
          oContas:refreshAll()
        case cTecla == K_ALT_A
          tContTela := savescreen( 00, 00, 24, 79 )
          cLetter    := ""

          Cont (.t.)

          restscreen( 00, 00, 24, 79, tContTela )

          select ContARQ
          set order to 2
          dbseek( ContARQ->Nome, .f. )
          
          oContas:refreshAll()  
          
          setcolor ( CorCampo )
          @ 16,26 say space(32)
        case cTecla == K_INS
          tAltera   := savescreen( 00, 00, 22, 79 )

          Cont (.f.)

          cLetter := ""
  
          restscreen( 00, 00, 22, 79, tAltera )
        
          setcolor ( CorCampo )
          @ 16,26 say space(32)
          @ 16,26 say cLetter
        
          select ContARQ
          set order to 2
          dbseek( ContARQ->Nome, .f. )

          oContas:refreshAll()  
      endcase
    enddo  
  else
    lOk := .t.
  endif   
  
  restscreen( 05, 15, 19, 65, tValCont )
  if lOK 
    cCont := Cont
    nCont := val( cCont )
    lOk   := .t.
    
    if nLinha != 99
      setcolor( CorCampo )   
      @ nLinha, nColuna   say Cont
      @ nLinha, nColuna+3 say Nome

      @ 12,27 say " Receita "
      @ 12,37 say " Despesa "
  
      setcolor( CorAltKC )
      @ 12,28 say "R"
      @ 12,38 say "D"
      
      if ContARQ->Tipo == "R"
        setcolor ( CorOpcao )
        @ 12,27 say " Receita "

        setcolor ( CorAltKO )
        @ 12,28 say "R"
      else
        setcolor ( CorOpcao )
        @ 12,37 say " Despesa "
    
        setcolor ( CorAltKO )
        @ 12,38 say "D"    
      endif
    endif  
  endif   

  set filter to
  set order  to 1
  select &cFile 
  setcolor ( CorJanel + "," + CorCampo )
return(lOk)

//
// Abre uma janela com os Lctoas cadastrados
//
function ValidLcto ( nLinha, nColuna, cFile, xLcto )
  local GetList := {}
  
  if lastkey() == K_UP .or. lastkey() == K_DOWN
    return(.t.)
  endif  

  tValLcto   := savescreen( 05, 15, 19, 65 )
  lOk        := .t.
  
  if nLinha == 99
    nLcto := xLcto
  endif  

  setcolor ( CorCampo )
  select LctoARQ
  set order to 1
  dbseek( strzero( nLcto, 6 ), .f. )
  if eof() .or. nLinha == 99
    set order to 2
    Janela( 05, 15, 17, 63, mensagem( "Janela", "ValidLcto", .f. ), .f. )  

    setcolor( CorJanel + "," + CorCampo )
    oLctos           := TBrowseDB( 07, 16, 15, 62 )
    oLctos:headsep   := chr(194)+chr(196)
    oLctos:colsep    := chr(179)
    oLctos:footsep   := chr(193)+chr(196)
    oLctos:colorSpec := CorJanel
 
    oLctos:addColumn( TBColumnNew( "Código", {|| Lcto } ) )
    oLctos:addColumn( TBColumnNew( "Nome", {|| Nome } ) )
    oLctos:addColumn( TBColumnNew( "Tipo", {|| iif( Tipo == "C", "Cr‚dito", "Débito " ) } ) )

    oLctos:goTop ()

    oLctos:ColPos  := 2
    lExitRequested := .f.
    nLinBarra      := 1
    cLetter         := ""
    nTotal         := lastrec()
    BarraSeta      := BarraSeta( nLinBarra, 08, 15, 63, nTotal )

    setcolor ( CorCampo )
    @ 16,26 say space(32)

    setcolor( CorJanel + "," + CorCampo )
    @ 08,15 say chr(195)
    @ 15,15 say chr(195)
    @ 16,17 say "Consulta"
    
    do while !lExitRequested
      Mensagem( "Func", "ValidProd" )

      oLctos:forcestable() 

      PosiDBF( 05, 63 )

      iif( BarraSeta, BarraSeta( nLinBarra, 08, 15, 63, nTotal ), NIL )
        
      if oLctos:stable
        if oLctos:hitTop .or. oLctos:hitBottom
          tone( 125, 0 )        
        endif  
        cTecla := Teclar(0)
      endif
        
      do case
        case cTecla == K_DOWN 
          if !oLctos:hitBottom
            nLinBarra ++
            if nLinBarra >= nTotal
              nLinBarra := nTotal 
            endif  
          endif  
        case cTecla == K_UP 
          if !oLctos:hitTop
            nLinBarra --
            if nLinBarra < 1
              nLinBarra := 1
            endif  
          endif
      endcase
        
      do case
        case cTecla == K_DOWN;       oLctos:down()
        case cTecla == K_UP;         oLctos:up()
        case cTecla == K_PGDN;       oLctos:pageDown()
        case cTecla == K_PGUP;       oLctos:pageUp()
        case cTecla == K_CTRL_PGUP;  oLctos:goTop()
        case cTecla == K_CTRL_PGDN;  oLctos:goBottom()
        case cTecla == K_ESC;        lExitRequested := .t.
        case cTecla == K_ENTER
          lOk            := .t.
          lExitRequested := .t.
        case cTecla == K_BS
          cLetter := substr( cLetra, 1, len( cLetra ) - 1 )
      
          setcolor ( CorCampo )
          @ 16,26 say space(32)
          @ 16,26 say cLetter
        case cTecla >= 32 .and. cTecla <= 128
          cLetter += chr( cTecla )    
          
          if cLetter >= 32
            cLetter := ""
          endif  
                  
          setcolor ( CorCampo )
          @ 16,26 say space(32)
          @ 16,26 say cLetter

          dbseek( cLetter, .t. )
          oLctos:refreshAll()
        case cTecla == K_ALT_A
          tLctoTela := savescreen( 00, 00, 24, 79 )
          cLetter    := ""

          Lcto (.t.)

          restscreen( 00, 00, 24, 79, tLctoTela )

          select LctoARQ
          set order to 2
          dbseek( LctoARQ->Nome, .f. )
          
          oLctos:refreshAll()  
          
          setcolor ( CorCampo )
          @ 16,26 say space(32)
        case cTecla == K_INS
          tAltera  := savescreen( 00, 00, 22, 79 )
          cLetter   := ""

          Lcto (.f.)

          restscreen( 00, 00, 22, 79, tAltera )
         
          setcolor ( CorCampo )
          @ 16,26 say space(32)
          @ 16,26 say cLetter
        
          select LctoARQ
          set order to 2
          dbseek( LctoARQ->Nome, .f. )

          oLctos:refreshAll()  
      endcase
    enddo  
  else
    lOk := .t.
  endif   
  
  restscreen( 05, 15, 19, 65, tValLcto )
  if lOK
    cLcto := Lcto
    nLcto := val( cLcto )
    lOk   := .t.
    
    if nLinha != 99
      setcolor( CorCampo )   
      @ nLinha, nColuna   say Lcto
      @ nLinha, nColuna+7 say Nome

      @ 12,27 say " Receita "
      @ 12,37 say " Despesa "
  
      setcolor( CorAltKC )
      @ 12,28 say "R"
      @ 12,38 say "D"
      
      setcolor ( CorOpcao )
      if LctoARQ->Tipo == "R"
        @ 12,27 say " Receita "
      
        setcolor ( CorAltKO )
        @ 12,28 say "R"
      else
        @ 12,37 say " Despesa "
  
        setcolor ( CorAltKO )
        @ 12,38 say "D"    
      endif
    endif  
  endif   

  set filter to
  set order  to 1
  select &cFile 
  setcolor ( CorJanel + "," + CorCampo )
return(lOk)

//
// Abre uma janela com os Agencias cadastrados
//
function ValidAgci ( nLinha, nColuna, cFile, xBanc )
  local GetList := {}
  
  if lastkey() == K_UP .or. lastkey() == K_DOWN
    return(.t.)
  endif  

  tValAgci   := savescreen( 05, 15, 19, 65 )
  lOk        := .t.
  
  setcolor ( CorCampo )
  select AgciARQ
  set order    to 1
  set relation to Banc into BancARQ
  set filter   to Banc == strzero( xBanc, 4 )

  cAgci := strzero( nAgci, 4 )
  dbseek( strzero( nBanc, 4 ) + cAgci, .f. )
  if eof()
    set order to 2
    Janela( 05, 20, 17, 63, mensagem( "Janela", "ValidAgci", .f. ) , .f. )  
   
    oAgciru           := TBrowseDB( 07, 21, 15, 62 )
    oAgciru:headsep   := chr(194)+chr(196)
    oAgciru:colsep    := chr(179)
    oAgciru:footsep   := chr(193)+chr(196)
    oAgciru:colorSpec := CorJanel
 
    oAgciru:addColumn( TBColumnNew( "Ag.",    {|| Agci } ) )
    oAgciru:addColumn( TBColumnNew( "Cidade", {|| Nome } ) )

    oAgciru:goTop ()

    oAgciru:ColPos := 2
    oAgciru:freeze := 1
    lExitRequested := .f.
    nLinBarra      := 1
    cLetter         := "" 
    nTotal         := lastrec()
    BarraSeta      := BarraSeta( nLinBarra, 08, 15, 63, nTotal )

    setcolor ( CorCampo )
    @ 16,31 say space(30)

    setcolor( CorJanel + "," + CorCampo )
    @ 08,20 say chr(195)
    @ 15,20 say chr(195)
    @ 16,22 say "Consulta"
    
    do while !lExitRequested
      Mensagem( "Func", "ValidProd" )

      oAgciru:forcestable() 

      PosiDBF( 05, 63 )

      iif( BarraSeta, BarraSeta( nLinBarra, 08, 15, 63, nTotal ), NIL )
        
      if oAgciru:stable
        if oAgciru:hitTop .or. oAgciru:hitBottom
          tone( 125, 0 )        
        endif  
        cTecla := Teclar(0)
      endif
        
      do case
        case cTecla == K_DOWN 
          if !oAgciru:hitBottom
            nLinBarra ++
            if nLinBarra >= nTotal
              nLinBarra := nTotal 
            endif  
          endif  
        case cTecla == K_UP 
          if !oAgciru:hitTop
            nLinBarra --
            if nLinBarra < 1
              nLinBarra := 1
            endif  
          endif
      endcase
        
      do case
        case cTecla == K_DOWN;       oAgciru:down()
        case cTecla == K_UP;         oAgciru:up()
        case cTecla == K_PGDN;       oAgciru:pageDown()
        case cTecla == K_PGUP;       oAgciru:pageUp()
        case cTecla == K_CTRL_PGUP;  oAgciru:goTop()
        case cTecla == K_CTRL_PGDN;  oAgciru:goBottom()
        case cTecla == K_RIGHT;      oAgciru:right()
        case cTecla == K_LEFT;       oAgciru:left()
        case cTecla == K_HOME;       oAgciru:home()
        case cTecla == K_END;        oAgciru:end()
        case cTecla == K_CTRL_LEFT;  oAgciru:panLeft()
        case cTecla == K_CTRL_RIGHT; oAgciru:panRight()
        case cTecla == K_CTRL_HOME;  oAgciru:panHome()
        case cTecla == K_CTRL_END;   oAgciru:panEnd()
        case cTecla == K_ESC;        lExitRequested := .t.
        case cTecla == K_ENTER
          lOk            := .t.
          lExitRequested := .t.
        case cTecla == K_BS
          cLetter := substr( cLetra, 1, len( cLetra ) - 1 )
      
          setcolor ( CorCampo )
          @ 16,26 say space(30)
          @ 16,26 say cLetter
        case cTecla >= 32 .and. cTecla <= 128
          cLetter += chr( cTecla )    
          
          if len( cLetter ) > 30
            cLetter := ""
          endif  
       
          setcolor ( CorCampo )
          @ 16,26 say space(30)
          @ 16,26 say cLetter

          dbseek( cLetter, .t. )
          oAgciru:refreshAll()
        case cTecla == K_ALT_A
          tAgciTela := savescreen( 00, 00, 24, 79 )

          Agci ( .t., xBanc )

          cLetter         := ""
          lExitRequested := .f.
          
          restscreen( 00, 00, 24, 79, tAgciTela )

          select AgciARQ
          set order to 2
          
          oAgciru:refreshAll()  
          
          setcolor ( CorCampo )
          @ 16,26 say space(30)
        case cTecla == K_INS
          tAgciTela := savescreen( 00, 00, 24, 79 )

          Agci ( .f., xBanc )

          cLetter         := ""
          lExitRequested := .f.

          restscreen( 00, 00, 24, 79, tAgciTela )

          select AgciARQ
          set order to 2
          
          oAgciru:refreshAll()  
          
          setcolor ( CorCampo )
          @ 16,26 say space(30)
      endcase
    enddo  
  else
    lOk := .t.
  endif   
  
  restscreen( 05, 15, 19, 65, tValAgci )
  if lOK
    setcolor( CorCampo )   
    cAgci := Agci
    nAgci := val (cAgci)
    lOk   := .t.

    @ nLinha, nColuna   say Agci
    @ nLinha, nColuna+7 say Nome       pict '@S28'
  endif   

  set filter to
  set order  to 1
  select &cFile 
  setcolor ( CorJanel + "," + CorCampo )
return(lOk)

//
// Abre uma janela com os Caixas cadastrados
//
function VerCaix ()
  local GetList   := {}
  local tValCaix  := savescreen( 00, 00, 24, 79 )
  local lOk       := .f.
  local pStatAnt  := cStat
 
  setcolor ( CorCampo )
  select CaixARQ
  set order to 2
  Janela( 05, 10, 17, 63, mensagem( "Janela", "VerCaixa", .f. ), .f. )  

  setcolor( CorJanel + "," + CorCampo )
  oBrowse           := TBrowseDB( 07, 11, 15, 62 )
  oBrowse:headsep   := chr(194)+chr(196)
  oBrowse:colsep    := chr(179)
  oBrowse:footsep   := chr(193)+chr(196)
  oBrowse:colorSpec := CorJanel
 
  oBrowse:addColumn( TBColumnNew( "Conta",      {|| Caix } ) )
  oBrowse:addColumn( TBColumnNew( "Descrição",  {|| left( Nome, 30 ) } ) )
  
  oBrowse:goTop ()

  oBrowse:freeze := 1
  lExitRequested := .f.
  nLinBarra      := 1
  cLetter         := ""
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 08, 15, 63, nTotal )

  setcolor ( CorCampo )
  @ 16,21 say space(32)

  setcolor( CorJanel + "," + CorCampo )
  @ 08,10 say chr(195)
  @ 16,12 say "Consulta"
    
  do while !lExitRequested
    Mensagem( "Func", "ValidProd" )

    oBrowse:forcestable() 

    PosiDBF( 05, 63 )

    iif( BarraSeta, BarraSeta( nLinBarra, 08, 15, 63, nTotal ), NIL )
        
    if oBrowse:stable
      if oBrowse:hitTop .or. oBrowse:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oBrowse:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oBrowse:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oBrowse:down()
      case cTecla == K_UP;         oBrowse:up()
      case cTecla == K_PGDN;       oBrowse:pageDown()
      case cTecla == K_PGUP;       oBrowse:pageUp()
      case cTecla == K_CTRL_PGUP;  oBrowse:goTop()
      case cTecla == K_CTRL_PGDN;  oBrowse:goBottom()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_ALT_A
        tAlte    := savescreen( 00, 00, 23, 79 )
        cLetter   := ""

        Caix (.t.)

        restscreen( 00, 00, 23, 79, tAlte )
        select CaixARQ
        set order to 2
        dbseek( CaixARQ->Nome, .f. )
        
        lExitRequested := .f.
                        
        setcolor ( CorCampo )
        @ 16,21 say space(32)

        oBrowse:refreshAll()
      case cTecla == K_ENTER
        lOk            := .t.
        lExitRequested := .t.
      case cTecla == K_BS
        cLetter := substr( cLetra, 1, len( cLetra ) - 1 )
    
        setcolor ( CorCampo )
        @ 16,21 say space(32)
        @ 16,21 say cLetter
      case cTecla >= 32 .and. cTecla <= 128
        cLetter += chr( cTecla )    
        
        if len( cLetter ) > 32
          cLetter := ""
        endif  
    
        setcolor ( CorCampo )
        @ 16,21 say space(32)
        @ 16,21 say cLetter

        dbseek( cLetter, .t. )       

        oBrowse:refreshAll()
    endcase
  enddo  
  
  restscreen( 00, 00, 24, 79, tValCaix )

  lExitRequested := .f.

  set order  to 1

  setcolor ( CorJanel + "," + CorCampo )
return( Caix )

//
// Aguarde Gerando Relatorio
//
function Aguarde ()
  if left( dtoc( date() ), 5 ) == '29/12' 
          tBinho := savescreen( 00, 00, 23, 79 )
           
          setcolor ( CorJanel )
          @ 06,10 say '+------------------------------------------------------+'
          @ 07,10 say '|                                                      |'
          @ 08,10 say '|          Autor do Sistema Integrado LEVE ' + cVersao + '        |'
          @ 09,10 say '|                                                      |'
          @ 10,10 say '| -o)              Fabiano Biatheski                   |'
          @ 11,10 say '|  /\\                Binho Sam                        |'
          @ 12,10 say '| _\_V                                             >:( |'
          @ 13,10 say '+------------------------------------------------------+'
 
          setcolor ( 'u/u' )
          scroll ( 14, 12, 14, 67, 0 )
          scroll ( 07, 66, 14, 67, 0 )
          
          cTone := 0
          
          do while cTone == 0
            tone(130.80,1) ; inkey(1/18) ; tone(130.80,1) ; inkey(1/18)
            tone(146.60,1) ; inkey(1/18) ; tone(130.80,1) ; inkey(1/18)
            tone(174.80,1) ; inkey(1/18) ; tone(146.80,1) ; inkey(1/13)
            tone(130.80,1) ; inkey(1/18) ; tone(130.80,1) ; inkey(1/18)
            tone(146.60,1) ; inkey(1/18) ; tone(130.80,1) ; inkey(1/18)
            tone(196.00,1) ; inkey(1/18) ; tone(174.80,1) ; inkey(1/13)
            tone(130.80,1) ; inkey(1/18) ; tone(130.80,1) ; inkey(1/18)
            tone(261.70,1) ; inkey(1/18) ; tone(220.00,1) ; inkey(1/18)
            tone(174.80,1) ; inkey(1/18) ; tone(146.80,1) ; inkey(1/18)
            tone(146.60,1) ; inkey(1/13) ; tone(261.70,1) ; inkey(1/18)
            tone(261.70,1) ; inkey(1/18) ; tone(220.00,1) ; inkey(1/18)
            tone(174.80,1) ; inkey(1/18) ; tone(196.00,1) ; inkey(1/18)
            tone(174.60,1)  
            cTone := inkey(3)
          enddo  
          restscreen( 00, 00, 23, 79, tBinho )
  endif

  Janela( 11, 23, 14, 56, Mensagem( "Janela", "Aguarde", .f. ), .f. )
  setcolor ( CorJanel + "," + CorCampo )

  @ 13,25 say "Aguarde! Gerando Relatório... "
return NIL

//
// Abre uma janela com os CEP cadastrados
//
function ValidCEP ( nLinha, nColuna, cFile, nColEnde, nColBair, nColCida, nColUF, pTipi )
  local GetList := {}
  
  if lastkey() == K_UP .or. lastkey() == K_DOWN .or. nCEP == 0
    return(.t.)
  endif  

  tValCEP   := savescreen( 00, 00, 24, 79 )
  lOk       := .f.
  iStatAnt  := cStat
  
  select CEPeARQ
  set order to 1
  dbseek( str( nCEP ), .f. )
  if eof()
    ConsCEP ()
  else
    lOk := .t.
  endif   

  restscreen( 00, 00, 24, 79, tValCEP )

  select CEPeARQ
  set order to 1
  if lOk
    setcolor( CorCampo) 
    nCEP := CEP
    
    if empty( cEnde )
      cEnde := left( Ende, 50 )
    endif  
    if empty( cBair )
      cBair := left( Bair, 30 )
    endif  
    if empty( cCida )
      cCida := left( Cida, 30 )
    endif  
    if empty( cUF )
      cUF   := UF
    endif  
    
    if pTipi == NIL
      @ nLinha, nColuna      say nCEP       pict '99999-999'
      @ nLinha, nColEnde     say cEnde      pict '@S30'
      @ nLinha + 1, nColBair say cBair      pict '@S15'
      @ nLinha + 1, nColCida say cCida      pict '@S15'
      @ nLinha + 1, nColUF   say cUF
    else  
      @ nLinha, nColuna say nCEP       pict '99999-999'
      @ 12, 34 say cEnde      pict '@S25'
      @ 13, 18 say cCida      pict '@S15'
      @ 13, 38 say cUF
      @ 13, 50 say cBair      pict '@S15'
    endif  
    if !empty( cEnde ) 
      keyboard(chr(K_END))
    endif
  endif   
  
  cStat          := iStatAnt
  lExitRequested := .f.

  select &cFile
  setcolor ( CorJanel + "," + CorCampo )
return(lOk)

//
// Verifica se a hora esta certa
//
function ValidHora( cTime, cVari )
  
  if empty( cTime )
    cTime   := "00:00"
    &cVari  := "00:00"
  endif

  nTime := val( substr( cTime, 1, 2 ) )
  nMini := val( substr( cTime, 4, 2 ) )
  lOk   := .t.
  
  if nTime > 23 .or. nTime < 0
    lOK := .f.
  endif

  if nMini > 59 .or. nMini < 0
    lOk := .f.
  endif
return(lOk)

//
// Verifica se o minuto esta correto
//
function ValidMin( nTime )

  if valtype( nTime ) != "C"   
    cTime := str( nTime, 9, 2 )
    nPosi := at( ".", cTime )
    
    cMini := substr( cTime, 1, nPosi - 1 )
    cSegu := substr( cTime, nPosi + 1, 2 )
  else
    cTime := nTime
    cMini := substr( cTime, 1, 2 )
    cSegu := substr( cTime, 4, 2 )
  endif
  
  nMini := val( cMini )
  nSegu := val( cSegu )
  
  if nSegu > 0
    nSegu := ( nSegu / 60 )
  endif
  
  nNovo := ( nMini + nSegu )
return( nNovo )

//
// Verifica se a data esta correta
//
function ValidData( nDate )
  
  cDate := strzero( nDate, 4 )
  cMes  := substr( cDate, 1, 2 )
  cAno  := substr( cDate, 3, 2 )
  lOka  := .t.
  
  if val( cMes ) <= 0 .or. val( cMes ) >= 13 .or.;
     val( cAno ) <= 0 .or. val( cMes ) >= 99
  
     Alerta( mensagem( "Alerta", "DataInvalida", .f. ) )

     lOka := .f.
  endif
return( lOka )

//
// Verifica se a impressora esta OK
//
function TestPrint( cDirecao )
  local lTst := .f.

  EmprARQ->(dbsetorder(1))
  EmprARQ->(dbseek( cEmpresa, .f. ))

  do while lastkey() != K_ESC
    if isprinter ()
      set device  to printer
      set printer on
      
      lTst := .t.
      
      exit
    else  
      Alerta ( mensagem( 'Alerta', 'TestPrint', .f. ) ) 
  
      set device to screen
    endif  
  enddo  
return(lTst)

//
// Retorna a Posicao do Registro no Banco de Dados
//
function PosiDBF( pLin, pCol )
  cRegistro := alltrim( str( recno() ) ) + '/' + alltrim( str( lastrec() ) )
  nLenRegis := len( cRegistro ) 
  cCor      := setcolor()
  
  setcolor( CorCabec )
  @ pLin,( pCol - 11 ) say space(11)
  @ pLin,( pCol - nLenRegis ) say cRegistro
  
  setcolor( cCor )
return NIL  


//
// Abre uma janela com as Composicao cadastradas
//
function ValidComp ( pComp )
  
  local GetList   := {}
  local tValComp  := savescreen( 00, 00, 24, 79 )
  local lOk       := .f.
  local pStatAnt  := cStat
  
  select CoPrARQ
  set order to 1
  dbseek( strzero( pComp, 6 ), .f. )
  if eof ()
    set order to 2
  
    Janela( 05, 18, 17, 63, mensagem( 'Janela', 'ValidCamp', .f. ), .f. )

    setcolor( CorJanel + ',' + CorCampo )

    oBrowse           := TBrowseDB( 07, 19, 15, 62 )
    oBrowse:headsep   := chr(194)+chr(196)
    oBrowse:colsep    := chr(179)
    oBrowse:footsep   := chr(193)+chr(196)
    oBrowse:colorSpec := CorJanel

    oBrowse:addColumn( TBColumnNew( 'Comp.',      {|| Nota } ) )
    oBrowse:addColumn( TBColumnNew( 'Descrição',  {|| left( Desc, 36 ) } ) )

    oBrowse:colPos := 2
    lExitRequested := .f.
    nLinBarra      := 1
    cLetter         := ''
    nTotal         := lastrec()
    BarraSeta      := BarraSeta( nLinBarra, 08, 15, 63, nTotal )

    oBrowse:goTop()

    setcolor ( CorCampo )
    @ 16,29 say space(32)

    setcolor( CorJanel + ',' + CorCampo )
    @ 08,18 say chr(195)
    @ 08,50 say chr(180)
    @ 16,20 say 'Consulta'

    do while !lExitRequested
      Mensagem( 'Func', 'ValidComp' )

      oBrowse:forcestable()
      
      PosiDBF( 05, 63 )

      iif( BarraSeta, BarraSeta( nLinBarra, 08, 15, 63, nTotal ), NIL )

      if oBrowse:stable
        if oBrowse:hitTop .or. oBrowse:hitBottom
          tone( 125, 0 )
        endif

        cTecla := Teclar(0)
      endif

      do case
        case cTecla == K_DOWN
          if !oBrowse:hitBottom
            nLinBarra ++
            if nLinBarra >= nTotal
              nLinBarra := nTotal
            endif
          endif
        case cTecla == K_UP
          if !oBrowse:hitTop
            nLinBarra --
            if nLinBarra < 1
              nLinBarra := 1
            endif
          endif
      endcase

      do case
        case cTecla == K_DOWN;       oBrowse:down()
        case cTecla == K_UP;         oBrowse:up()
        case cTecla == K_PGDN;       oBrowse:pageDown()
        case cTecla == K_PGUP;       oBrowse:pageUp()
        case cTecla == K_CTRL_PGUP;  oBrowse:goTop()
        case cTecla == K_CTRL_PGDN;  oBrowse:goBottom()
        case cTecla == K_ESC;        lExitRequested := .t.
        case cTecla == K_ALT_A
          tAlte     := savescreen( 00, 00, 23, 79 )

          Comp (.t.)

          restscreen( 00, 00, 23, 79, tAlte )
          select CoPrARQ
          set order to 2
          dbseek( CoPrARQ->Desc, .f. )

          cLetter         := ''
          lExitRequested := .f.

          setcolor ( CorCampo )
          @ 16,29 say space(32)
        case cTecla == K_ENTER
          lOk            := .t.
          lExitRequested := .t.
        case cTecla == K_BS
          cLetter := substr( cLetra, 1, len( cLetra ) - 1 )

          setcolor ( CorCampo )
          @ 16,29 say space(32)
          @ 16,29 say cLetter
        case cTecla >= 32 .and. cTecla <= 122
          cLetter += chr( cTecla )

          if len( cLetter ) > 32
            cLetter := ''
          endif

          setcolor ( CorCampo )
          @ 16,29 say space(32)
          @ 16,29 say cLetter

          dbseek( cLetter, .t. )

          oBrowse:refreshAll()
      endcase
    enddo
  else
    lOk := .t.
  endif
    
  if lOk
    nCompIni := val( Nota )
    nNota    := val( Nota )
    
    setcolor( CorCampo )
    @ 10,30 say nCompIni            pict '999999'
  endif  
  
  restscreen( 00, 00, 24, 79, tValComp )

  lExitRequested := .f.

  set order  to 1

  setcolor ( CorJanel + ',' + CorCampo )
return(.t.)

//
// Mostra as Mensagens
//
function ConsMens()
  local cArquivo := alias()  
  local tMostra  := savescreen( 00, 00, 24, 79 )
  local cTitulo  := mensagem( "Janela", "ConsMens", .f. )

  select MensARQ
  set order to 2
  dbgotop()

  Janela( 03, 02, 20, 76, cTitulo, .f. ) 
  setcolor ( CorJanel + ',' + CorCampo )

  oMens         := TBrowseDB( 05, 03, 18, 75 )
  oMens:headsep := chr(194)+chr(196)
  oMens:footsep := chr(193)+chr(196)
  oMens:colsep  := chr(179)

  oMens:addColumn( TBColumnNew("Programa",     {|| Prog } ) )
  oMens:addColumn( TBColumnNew("Local",        {|| left( Loca, 10 ) } ) )
  oMens:addColumn( TBColumnNew("Mensagem",     {|| left( Mens, 50 ) } ) )
 
  lExitRequested := .f.
  nLinBarra      := 1
  cLetter        := ''
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 06, 18, 76, nTotal )

  oMens:colPos   := 3
  
  oMens:goTop()
  
  setcolor ( CorCampo )
  @ 19,16 say space(40)
    
  setcolor( CorJanel + ',' + CorCampo )
  @ 06,02 say chr(195)
  @ 18,02 say chr(195)
  @ 19,07 say 'Consulta'

  do while !lExitRequested
//    Mensagem( 'LEVE', 'ConsMens' )

    oMens:forcestable()

    PosiDBF( 03, 76 )
    
    iif( BarraSeta, BarraSeta( nLinBarra, 06, 18, 76, nTotal ), NIL )

    if oMens:stable
      if oMens:hitTop .or. oMens:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
 
    do case
      case cTecla == K_DOWN;        oMens:down()
      case cTecla == K_UP;          oMens:up()
      case cTecla == K_PGDN;        oMens:pageDown()
      case cTecla == K_PGUP;        oMens:pageUp()
      case cTecla == K_CTRL_PGUP;   oMens:goTop()
      case cTecla == K_CTRL_PGDN;   oMens:goBottom()
      case cTecla == K_RIGHT;       oMens:right()
      case cTecla == K_LEFT;        oMens:left()
      case cTecla == K_HOME;        oMens:home()
      case cTecla == K_END;         oMens:end()
      case cTecla == K_CTRL_LEFT;   oMens:panLeft()
      case cTecla == K_CTRL_RIGHT;  oMens:panRight()
      case cTecla == K_CTRL_HOME;   oMens:panHome()
      case cTecla == K_CTRL_END;    oMens:panEnd()
      case cTecla == K_ESC;         lExitRequested := .t.
      case cTecla == K_INS
        tIns := savescreen( 00, 00, 23, 79 )
        nRec := recno()

        Janela( 04, 16, 10, 65, mensagem( 'Janela', 'ConsMens', .f. ), .f. )
        Mensagem( 'LEVE', 'ConsMens2' )
        
        setcolor( CorJanel + "," + CorCampo )
        @ 06,19 say 'Programa'
        @ 07,19 say '   Local'
        @ 09,19 say 'Mensagem'
        
        cProg := space(10)
        cLoca := space(15)
        cMens := space(80)
        
        @ 06,28 get cProg    
        @ 07,28 get cLoca        
        @ 09,28 get cMens        pict '@S35'
        read
         
        if lastkey() != K_ESC
          dbseek( cIdioma + cProg + cLoca, .f. )
          
          if eof()
            if AdiReg()
              if RegLock()
                replace Idio     with cIdioma
                replace Prog     with cProg
                replace Loca     with cLoca
                replace Mens     with cMens
                dbunlock()
              endif
            endif               
          endif
          
          go nRec
  
          oMens:refreshAll()
        endif 
        
        restscreen( 00, 00, 23, 79, tIns )
      case cTecla == K_ENTER
        do case
          case oMens:colpos == 1
            cProg := Prog
            
            @ oMens:rowpos + 6,05 get cProg     // pict '@S50'
            read
            
            if lastkey() != K_ESC
              if RegLock()
                replace Prog      with cProg
                dbunlock()
              endif
              
              oMens:refreshAll ()
            endif

          case oMens:colpos == 2
            cLoca := Loca
            
            @ oMens:rowpos + 6,15 get cLoca      pict '@S10'
            read
            
            if lastkey() != K_ESC
              if RegLock()
                replace Loca      with cLoca
                dbunlock()
              endif
              
              oMens:refreshAll ()
            endif
          case oMens:colpos == 3
            cMens := Mens
            
            @ oMens:rowpos + 6,25 get cMens      pict '@S50'
            read
            
            if lastkey() != K_ESC
              if RegLock()
                replace Mens      with cMens
                dbunlock()
              endif
              
              oMens:refreshAll()
            endif
        endcase  
      case cTecla == K_BS
        cLetter := substr( cLetter, 1, len( cLetter ) - 1 )
      
        setcolor ( CorCampo )
        @ 19,16 say space(40)
        @ 19,16 say cLetter
      case cTecla >= 32 .and. cTecla <= 128
        lLetra := .f.
      
        do case
          case oMens:ColPos == 3;      lLetra := .t.      
            set order to 2
//          case oMens:ColPos == 2;      lLetra := .t.     
//            set order to 2
        endcase
        
        if lLetra       
          cLetter += chr( cTecla )    
        endif  

        if len( cLetter ) > 40
          cLetter := ''
        endif  
     
        setcolor ( CorCampo )
        @ 19,16 say space(40)
        @ 19,16 say cLetter

        dbseek( cLetter, .t. )

        oMens:refreshAll()
    endcase

    select MensARQ
  enddo

  restscreen( 00, 00, 24, 79, tMostra )
return NIL