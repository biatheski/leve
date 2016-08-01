//  Leve, Produtos
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

function Prod( xAlte )
  local GetList := {}
  
if SemAcesso( 'Prod' )
  return NIL
endif  

if NetUse( "GrupARQ", .t. )
  VerifIND( "GrupARQ" )

  pOpenGrup := .t.

  #ifdef DBF_NTX
    set index to GrupIND1, GrupIND2
  #endif
else  
  pOpenGrup := .f.
endif

if NetUse( "SubGARQ", .t. )
  VerifIND( "SubGARQ" )

  pOpenSubG := .t.
  
  #ifdef DBF_NTX
    set index to SubGIND1, SubGIND2, SubGIND3
  #endif
else  
  pOpenSubG := .f.
endif

if NetUse( "FornARQ", .t. )
  VerifIND( "FornARQ" )

  pOpenForn := .t.
  
  #ifdef DBF_NTX
    set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
  #endif
else  
  pOpenForn := .f.
endif

if NetUse( "ProdARQ", .t. )
  VerifIND( "ProdARQ" )

  pOpenProd := .t.
  
  #ifdef DBF_NTX
    set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
  #endif
else  
  pOpenProd := .f.
endif

if NetUse( "IProARQ", .t. )
  VerifIND( "IProARQ" )
  
  pOpenIPro := .t.

  #ifdef DBF_NTX
    set index to IProIND1
  #endif
else  
  pOpenIPro := .f.
endif

//  Variaveis de Entrada para Item
nProd       := nGrup       := nSubG       := nPesoLiqd  := nCaixa    := 0
pPrecoVenda := pPrecoCusto := pQtde       := nEstqMini  := nEstqPedi := 0
cGrup       := cSubG       := cUnid       := space(03)
cProd       := cForn       := space(04)
pNome       := space(45)
dUltE       := ctod('  /  /  ')
dUltS       := ctod('  /  /  ')
nPerC       := nPerIPI     := nCodTri     := nForn      := nLucro    := 0
cCodFisc    := cComposicao := space(02)
cCodIPI     := cCodFab     := cRefe       := space(15)
cHist       := ''
nPrecoMini  := 0
cIProTMP    := cIProARQ    := cIProIND1   := 0
lItenProd   := .f.

//  Tela Item

if EmprARQ->ProdSimp == "X"
  Janela ( 04, 01, 20, 76, mensagem( 'Janela', 'Prod', .f. ), .t. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 06,03 say '     Código'
  @ 06,47 say 'Cód. Barras'
  @ 08,03 say '  Descrição'
  @ 09,03 say ' Referˆncia'
  @ 11,03 say ' Fornecedor'
  @ 12,03 say '      Grupo'

  @ 14,03 say 'Preço Custo'
  @ 14,27 say '   L.Bruto        %'
  @ 14,48 say 'Preço Venda'
  @ 15,03 say ' Quantidade'
  @ 15,47 say ' Preço Medio'
  @ 16,03 say '    Unidade'
  @ 16,47 say 'Estq. Minimo'
  @ 17,03 say 'Custo Estq.'
  @ 17,46 say 'Valor Estoque'

  MostGeral( 19, 03, 15, 32, 52, 65, ' Composição ', 'C', 2 )
else
  Janela ( 01, 01, 21, 76, mensagem( 'Janela', 'Prod', .f. ), .t. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 03,03 say '     Código'
  @ 03,47 say 'Cód. Barras'
  @ 04,03 say '  Descrição'
  @ 05,03 say ' Referˆncia'
  @ 07,03 say ' Fornecedor'
  @ 08,03 say '      Grupo'
  @ 09,03 say '   Subgrupo'
  @ 11,03 say ' CodTribu.'
  @ 11,27 say 'Cl. Fiscal'
  @ 11,47 say 'Peso Líquido'
  @ 12,03 say 'Cód. do IPI'
  @ 12,28 say '      IPI      %'
  @ 12,48 say '   Comissão       %'

  @ 14,03 say 'Preço Custo'
  @ 14,27 say '   L.Bruto        %'
  @ 14,48 say 'Preço Venda'
  @ 15,03 say ' Quantidade'
  @ 15,47 say ' Preço M‚dio'
  @ 16,03 say '    Unidade'
  @ 16,47 say 'Estq. Mínimo'
  @ 17,03 say 'Custo Estq.'
  @ 17,46 say 'Valor Estoque'
  @ 18,03 say 'Dt.Ult.Ent.'
  @ 18,47 say 'Dt.Ult.Saída'

  MostGeral( 20, 03, 15, 32, 52, 65, ' Composição ', 'C', 2 )
endif  

//  Manutencao Cadastro de Item
select ProdARQ
set order    to 1
set relation to Grup into GrupARQ, Grup + SubG into SubGARQ,;
                Forn into FornARQ    
if pOpenProd
  dbgobottom ()
endif
do while .t.
  cStat := space(4)

  Mensagem( 'Prod', 'Janela' )
  
  select FornARQ
  set order to 1
  
  select GrupARQ
  set order to 1
  
  select SubgARQ
  set order    to 1 
  set relation to Grup into GrupARQ
  
  select ProdARQ
  set order    to 1
  if EmprARQ->ProdSimp == "X"
    set relation to Grup into GrupARQ, Forn into FornARQ    
  else                    
    set relation to Grup into GrupARQ, Grup + SubG into SubGARQ,;
                    Forn into FornARQ    
  endif  

  MostProd()
  
  if Demo ()  
    exit
  endif  
  
  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostProd'
  cAjuda   := 'Prod'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
   
  if lastkey() == K_ALT_A
    nProd := val( Prod )
  else  
    if xAlte 
      if EmprARQ->ProdSimp == "X"
        @ 06,15 get nProd                     pict '999999'
      else  
        @ 03,15 get nProd                     pict '999999'
      endif  
      read
    else
      nProd := 0
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
  cProd := strzero( nProd, 6 )
  if EmprARQ->ProdSimp == "X"
    @ 06,15 say cProd
  else  
    @ 03,15 say cProd
  endif  
  
  if cProd == '999999'
    Alerta( 'Alerta', 'Prod9999' )
    loop
  endif  
    
  //  Verificar existencia do Produto para Incluir ou Alterar
  select ProdARQ
  set order to 1
  dbseek( cProd, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif
  
  Mensagem( 'Prod', cStat )
  
  rStatAnt := cStat
  
  MostProd ()
  EntrProd ()
  
  cStat := rStatAnt

  do while .t.
    if EmprARQ->ProdSimp == 'X'
      MostGeral( 19, 03, 15, 32, 52, 65, ' Composição ', 'C', 2 )
      ConfGeral( 19, 03, 15, 32, 52, 65, ' Composição ', 'C', 2, 4 )
    else                                     
      MostGeral( 20, 03, 15, 32, 52, 65, ' Composição ', 'C', 2 )
      ConfGeral( 20, 03, 15, 32, 52, 65, ' Composição ', 'C', 2, 4 )
    endif  
    if cStat == 'gene'
      select ProdARQ
      nProdRegi := recno()
      cProdAnte := cProd
    
      EntrIPro()
      
      select ProdARQ
      go nProdRegi
      cProd := cProdAnte
      cStat := rStatAnt
    else
      exit
    endif
  enddo

  if cStat == 'prin'
    PrinProd (.f.)
  endif
  
  if cStat == 'excl'
    lFound := .f.
  
    if NetUse( "INSaARQ", .t. )
      VerifIND( "INSaARQ" )
  
      #ifdef DBF_NTX
        set index to INSaIND1
      #endif
    endif
    
    select INSaARQ
    set order to 1
    dbgotop()
    do while !eof()
      if Prod == cProd
        lFound := .t.
        exit
      endif           
      dbskip()
    enddo
    
    close

    if NetUse( "IPedARQ", .t. )
      VerifIND( "IPedARQ" )
  
      #ifdef DBF_NTX
        set index to IPedIND1
      #endif
    endif
    
    select IPedARQ
    set order to 1
    dbgotop()
    do while !eof()
      if Prod == cProd
        lFound := .t.
        exit
      endif           
      dbskip()
    enddo
    
    close

    if NetUse( "INEnARQ", .t. )
      VerifIND( "INEnARQ" )
  
      #ifdef DBF_NTX
        set index to INEnIND1
      #endif
    endif
    
    select INEnARQ
    set order to 1
    dbgotop()
    do while !eof()
      if Prod == cProd
        lFound := .t.
        exit
      endif           
      dbskip()
    enddo
    
    close

    if NetUse( "IEPrARQ", .t. )
      VerifIND( "IEPrARQ" )
  
      #ifdef DBF_NTX
        set index to IEPrIND1
      #endif
    endif
    
    select IEPrARQ
    set order to 1
    dbgotop()
    do while !eof()
      if Prod == cProd
        lFound := .t.
        exit
      endif           
      dbskip()
    enddo
    
    close

    if NetUse( "ISPrARQ", .t. )
      VerifIND( "ISPrARQ" )
  
      #ifdef DBF_NTX
        set index to ISPrIND1
      #endif
    endif
    
    select ISPrARQ
    set order to 1
    dbgotop()
    do while !eof()
      if Prod == cProd
        lFound := .t.
        exit
      endif           
      dbskip()
    enddo
    
    close

    if NetUse( "ItOSARQ", .t. )
      VerifIND( "ItOSARQ" )
  
      #ifdef DBF_NTX
        set index to ItOSIND1
      #endif
    endif
    
    select ItOSARQ
    set order to 1
    dbgotop()
    do while !eof()
      if Prod == cProd
        lFound := .t.
        exit
      endif           
      dbskip()
    enddo
    
    close
    
    if lFound
      Janela( 09, 20, 14, 60, mensagem( 'LEVE', 'Atencao', .f. ), .t. )
      setcolor( CorJanel )
     
      @ 11,22 say 'Existe movimentação deste produto !!!' 
      @ 13,22 say '             Continuar...' 
      
      if !ConfLine( 13, 48, 2 )
        loop
      endif  
    endif
    
    select ProdARQ

    if ExclRegi ()
      select IProARQ
      set order to 1
      dbseek( cProd, .t. )
      do while Prod == cProd .and. !eof()
        if RegLock()
          dbdelete ()
          dbunlock ()
        endif
  
        dbskip ()
      enddo    
      select ProdARQ
    endif
  endif
  
  if cStat == 'incl'
    if cProd == "000000"
      cProd := "000001"
    endif
      
    set order to 1  
    do while .t.
      dbseek( cProd, .f. )
      if found()
        nProd := val( cProd ) + 1               
        cProd := strzero( nProd, 6 )
      else 
        exit    
      endif
    enddo

    if AdiReg()
      if RegLock()
        replace Prod       with cProd 
        replace UltA       with date()
        unlock
      endif
    endif  
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace CodFab     with cCodFab
      replace Refe       with cRefe
      replace Nome       with pNome
      replace Forn       with cForn
      replace Grup       with cGrup
      replace SubG       with cSubg
      replace Unid       with cUnid
      replace PerC       with nPerC
      replace PerIPI     with nPerIPI
      replace CodFisc    with cCodFisc
      replace CodTri     with nCodTri
      replace CodIPI     with cCodIPI
      replace PesoLiqd   with nPesoLiqd
      replace PrecoCusto with pPrecoCusto
      replace Composicao with cComposicao
      replace Lucro      with nLucro
      replace PrecoVenda with pPrecoVenda
      replace PrecoMini  with nPrecoMini
      replace Qtde       with pQtde
      replace Caixa      with nCaixa
      replace EstqMini   with nEstqMini
      replace UltE       with dUltE
      replace UltS       with dUltS
      replace Hist       with cHist

      if PrecoVenda != pPrecoVenda
        replace UltA     with date()
      endif
      dbunlock ()
    endif

    if lItenProd
      set deleted off   
    
      select( cIProTMP )
      set order to 1 
      dbgotop ()
      do while !eof ()
        if empty( Prod )
          dbskip ()
          loop
        endif  
      
        nRegi := Regi
        lLixo := Lixo
      
        if Novo
          if Lixo
            dbskip ()
            loop
          endif  
    
          select IProARQ
          set order to 1
          dbseek( cProd + &cIProTMP->Sequ, .f. )
          
          if found()
            if RegLock()
              dbdelete ()
              dbunlock ()
            endif  
          endif     
       
          if AdiReg()
            if RegLock()
              replace Prod       with cProd
              replace Sequ       with &cIProTMP->Sequ
              replace CodP       with &cIProTMP->Prod
              replace Produto    with &cIProTMP->Produto
              replace Qtde       with &cIProTMP->Qtde
              replace PrecoVenda with &cIProTMP->PrecoVenda
              replace NSerie     with &cIProTMP->NSerie
              replace CodFab     with &cIProTMP->CodFab
              dbunlock ()
            endif
          endif   
        else 
          select IProARQ
          go nRegi
      
          if lLixo
            if RegLock()
              dbdelete ()
              dbunlock ()
            endif
          else  
            if RegLock()
              replace CodP       with &cIProTMP->Prod
              replace Produto    with &cIProTMP->Produto
              replace Qtde       with &cIProTMP->Qtde
              replace PrecoVenda with &cIProTMP->PrecoVenda
              replace NSerie     with &cIProTMP->NSerie
              replace CodFab     with &cIProTMP->CodFab
              dbunlock ()
            endif  
          endif
        endif 
      
        select( cIProTMP )
        dbskip ()
      enddo  
   
      set deleted on
    endif

    if !xAlte 
      xAlte := .t.
      keyboard(chr(27))
    endif       
  endif  
enddo

if pOpenProd
  select ProdARQ
  close
endif  
if pOpenGrup
  select GrupARQ
  close
endif  
if pOpenSubG
  select SubGARQ
  close
endif  
if pOpenForn
  select FornARQ
  close
endif  
if pOpenIPro
  select IProARQ
  close
endif  

if select( cIProTMP ) > 0
  select( cIProTMP )
  close
  ferase( cIProARQ )
  ferase( cIProIND1 )
//  ferase( left( cIProARQ, len( cIProARQ ) - 3 ) + 'DBF' )
endif  
return NIL

//
// Entra com os itens 
//
function EntrIPro()
  local GetList := {}
  local nRecno  := recno()
  
  if lastkey() == K_ESC .or. lastkey() == K_PGDN
    return NIL
  endif 
  
  aOpcoes      := {}
  aArqui       := {}
  cIProARQ     := CriaTemp(0)
  cIProIND1    := CriaTemp(1)
  cChave       := "Sequ"

  aadd( aArqui, { "Sequ",       "C", 004, 0 } )
  aadd( aArqui, { "Prod",       "C", 006, 0 } )
  aadd( aArqui, { "Produto",    "M", 010, 0 } )
  aadd( aArqui, { "Qtde",       "N", 012, 3 } )
  aadd( aArqui, { "NSerie",     "C", 015, 0 } )
  aadd( aArqui, { "CodFab",     "C", 015, 0 } )
  aadd( aArqui, { "PrecoVenda", "N", 015, 6 } )
  aadd( aArqui, { "Regi",       "N", 008, 0 } )
  aadd( aArqui, { "Novo",       "L", 001, 0 } )
  aadd( aArqui, { "Lixo",       "L", 001, 0 } )

  dbcreate( cIProARQ, aArqui )
     
  if NetUse( cIProARQ, .f. )
    cIProTMP  := alias ()
    oOpenIPro := .t.
   
    #ifdef DBF_CDX 
      index on &cChave tag &cIProIND1
    #endif 

    #ifdef DBF_NTX
      index on &cChave to &cIProIND1  
    
      set index to &cIProIND1
    #endif
  endif
  
  select IProARQ
  set order to 1
  dbseek( cProd, .t. )
  do while Prod == cProd .and. !eof()
    nRegi := recno ()
    
    select( cIProTMP )
    if AdiReg()
      if RegLock()
        replace Sequ       with IProARQ->Sequ
        replace Prod       with IProARQ->CodP
        replace Produto    with IProARQ->Produto
        replace NSerie     with IProARQ->NSerie
        replace CodFab     with IProARQ->CodFab
        replace Qtde       with IProARQ->Qtde
        replace PrecoVenda with IProARQ->PrecoVenda
        replace Regi       with nRegi
        replace Novo       with .f.
        replace Lixo       with .f.
        dbunlock ()
      endif
    endif
    
    select IProARQ
    dbskip ()
  enddo

  select( cIProTMP )
  set order    to 1
  set relation to Prod into ProdARQ

  Janela( 05, 01, 19, 76, mensagem( 'Janela', 'EntrIPro', .f. ), .t. )
  setcolor( CorJanel + ',' + CorCampo )     

  bFirst := {|| dbseek( '0001', .t. ) }
  bLast  := {|| dbseek( '9999', .t. ), dbskip(-1) }
  bFor   := {|| .t. }
  bWhile := {|| .t. }

  oColuna         := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oColuna:nTop    := 7
  oColuna:nLeft   := 02
  oColuna:nBottom := 17
  oColuna:nRight  := 75
  oColuna:headsep := chr(194)+chr(196)
  oColuna:colsep  := chr(179)
  oColuna:footsep := chr(193)+chr(196)

  oColuna:addColumn( TBColumnNew("Código",      {|| Prod } ) )
  oColuna:addColumn( TBColumnNew("Nome",        {|| iif( Prod == '999999', memoline( Produto, 20, 1 ), left( ProdARQ->Nome, 20 ) ) } ) ) 
  oColuna:addColumn( TBColumnNew("N. Serie",    {|| left( NSerie, 10 ) } ) )
  oColuna:addColumn( TBColumnNew("Cod. Barras", {|| left( CodFab, 13 ) } ) )
  if EmprARQ->Inteira == 'X' 
    oColuna:addColumn( TBColumnNew("Qtde.",     {|| transform( Qtde, '@E 999999999' ) } ) )
  else  
    oColuna:addColumn( TBColumnNew("Qtde.",     {|| transform( Qtde, '@E 99999.999' ) } ) )
  endif  
  oColuna:addColumn( TBColumnNew("P. Venda",    {|| transform( PrecoVenda, PictPreco(11) ) } ) )
            
  lExitRequested := .f.
  lAlterou       := .f.
  
  @ 08,01 say chr(195) 
  @ 08,76 say chr(180)


  setcolor( CorJanel + ',' + CorCampo )     
  @ 18,03 say '[ ] Composicao de Produtos'

  setcolor( CorCampo )     
  @ 18,04 say cComposicao 

  setcolor( CorJanel + ',' + CorCampo )     
 
  oColuna:goBottom()

  do while !lExitRequested
    Mensagem ( 'LEVE', 'Browse' )
 
    oColuna:forcestable()

    if !lAlterou .and. cStat == 'incl'
      cTecla := K_INS
    else  
      cTecla := Teclar(0)
    endif  

    if oColuna:hitTop .or. oColuna:hitBottom
      tone( 125, 0 )
    endif

    do case
      case cTecla == K_DOWN;        oColuna:down()
      case cTecla == K_UP;          oColuna:up()
      case cTecla == K_PGUP;        oColuna:pageUp()
      case cTecla == K_CTRL_PGUP;   oColuna:goTop()
      case cTecla == K_PGDN;        oColuna:pageDown()
      case cTecla == K_CTRL_PGDN;   oColuna:goBottom()
      case cTecla == 46;            lExitRequested := .t.
        @ 18,04 get cComposicao     pict '@!'
        read
      case cTecla == K_ESC
        if Saindo (lAlterou)
          lExitRequested := .t.
        else  
          lExitRequested := .f.
        endif  
      case cTecla == K_ENTER;       EntrItIPro(.f.)
      case cTecla == K_INS
        do while lastkey() != K_ESC    
          EntrItIPro( .t. )
        enddo  
      case cTecla == K_DEL
        if RegLock()
          replace Lixo      with .t.  
            
          dbdelete ()
          dbunlock ()
    
          oColuna:refreshAll()  
          oColuna:gotop ()
        endif  
    endcase
  enddo
  
  set relation to
  
  select ProdARQ
  go nRecno

return NIL  

//
// Entra intens da Composicao
//
function EntrItIPro( lAdiciona )
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

    Mensagem( 'Prod', 'IProIncl' )
  else
    Mensagem( 'Prod', 'IProAlte' )
  endif  

  cSequ       := Sequ
  nSequ       := val( Sequ )
  cProd       := Prod
  iProduto    := Produto
  iProd       := val( cProd )
  iNSerie     := NSerie
  iCodFab     := CodFab
  iQtde       := Qtde
  iPrecoVenda := PrecoVenda
  nLin        := 08 + oColuna:rowPos
    
  setcolor( CorCampo )
  if cProd == '999999'
    @ nLin, 09 say memoline( iProduto, 20, 1 )
  else  
    @ nLin, 09 say ProdARQ->Nome       pict '@S20'
  endif  
  
  set key K_UP to UpNota ()
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ nLin, 02 get cProd                 pict '@K'            valid ValidProd( nLin, 02, cIProTMP, 'ipro', 0, 0 )
  @ nLin, 30 get iNSerie               pict '@S10'
  @ nLin, 41 get iCodFab               pict '@S13'
  if EmprARQ->Inteira == 'X'  
    @ nLin, 55 get iQtde               pict '@E 999999999'  valid VoltaUp () 
  else  
    @ nLin, 55 get iQtde               pict '@E 99999.999'  valid VoltaUp () 
  endif  
  @ nLin,65 get iPrecoVenda            pict PictPreco(11)
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
    replace Produto         with iProduto
    replace Qtde            with iQtde
    replace PrecoVenda      with iPrecoVenda
    replace CodFab          with iCodFab
    replace NSerie          with iNSerie
    replace Lixo            with .f.
    dbunlock ()
  endif
  
  oColuna:refreshCurrent()  
  
  lAlterou  := .t.
  lItenProd := .t.
return NIL     
 
//
// Entra com Histórico do Produto
//
function EntrHist()
  local GetList   := {}
  
  Janela( 03, 13, 13, 67, mensagem( 'Janela', 'EntrHist', .f. ), .f. )
  Mensagem( 'Prod', 'EntrHist' )
         
  setcolor( CorCampo )     
  cHist := memoedit( cHist, 05, 15, 12, 65, .t., "OutProd" )
    
  setcolor ( CorJanel + ',' + CorCampo )
return NIL

function FindProd(pTipo,pCamp)
 if EmprARQ->FindIncl == "X" .and. !empty(pCamp)
   wRegi := recno() 
   
   do case
     case pTipo == 1
       set order to 5
     case pTipo == 2
       set order to 2
     case pTipo == 3
       set order to 6
   endcase      

   dbseek( pCamp, .f. )
   
   if found() .and. recno() != wRegi
     Alerta( mensagem( 'Alerta', 'FindProd', .f. ) )
   endif
   
   set order to 1   
   go wRegi 
 endif
return(.t.)

//
// Entra Dados do Item
//
function EntrProd ()
  local GetList := {}
     
  do while .t.
    lAlterou := .f.

    setcolor ( CorJanel + ',' + CorCampo )
    if EmprARQ->ProdSimp == "X"
      @ 06,60 get cCodFab        pict '@S14' valid FindProd(1,cCodFab)
      @ 08,15 get pNome                      valid FindProd(2,pNome)
      @ 09,15 get cRefe                      valid FindProd(3,cRefe)
      @ 11,15 get nForn          pict '999999' valid ValidForn( 11, 15, "ProdARQ" )
      @ 12,15 get nGrup          pict '999999'  valid ValidARQ( 12, 15, "ProdARQ", "Código", "Grup", "Descrição", "Nome", "Grup", "nGrup", .t., 6, "Consulta de Grupos", "GrupARQ", 40 )

      @ 14,15 get pPrecoCusto    pict PictPreco(14) 
      @ 14,38 get nLucro         pict '@E 999.99'           valid CalcLucro( 1 )
      @ 14,60 get pPrecoVenda    pict PictPreco(14)   valid CalcLucro( 2 )
      if EmprARQ->Inteira == 'X'
        @ 15,15 get pQtde        pict '@E 9999999999'
//      @ 15,60 get nCaixa       pict '@E 9999999999'
        @ 15,60 get nPrecoMini   pict PictPreco(14) 
      else
        @ 15,15 get pQtde        pict '@E 999999.999'
//      @ 15,60 get nCaixa       pict '@E 999999.999'
        @ 15,60 get nPrecoMini   pict PictPreco(14) 
      endif
      @ 16,15 get cUnid          pict '@!'
      if EmprARQ->Inteira == 'X'
        @ 16,60 get nEstqMini    pict '@E 999999999'
      else
        @ 16,60 get nEstqMini    pict '@E 99999.999'
      endif
      read

      setcolor ( CorCampo )
      @ 17,15 say pQtde * pPrecoCusto  pict '@E 999,999,999.99'
      @ 17,60 say pQtde * pPrecoVenda  pict '@E 999,999,999.99'
    else
      @ 03,60 get cCodFab        pict '@S14'
      @ 04,15 get pNome
      @ 05,15 get cRefe
      @ 07,15 get nForn          pict '999999'  valid ValidForn( 07, 15, "ProdARQ" )
      @ 08,15 get nGrup          pict '999999'  valid ValidARQ( 08, 15, "ProdARQ", "Código", "Grup", "Descrição", "Nome", "Grup", "nGrup", .t., 6, "Consulta de Grupos", "GrupARQ", 40 )
      @ 09,15 get nSubG          pict '999999'  valid ValidSubG( 09, 15, "ProdARQ", nGrup )
      @ 11,15 get nCodTri        pict '99'
      @ 11,38 get cCodFisc       pict '@K'
      @ 11,60 get nPesoLiqd      pict '@E 999.9'
      @ 12,15 get cCodIPI        pict '@!'
      @ 12,38 get nPerIPI        pict '@E 99.9'
      @ 12,60 get nPerC          pict '@E 999.9'

      @ 14,15 get pPrecoCusto    pict PictPreco(14) 
      @ 14,38 get nLucro         pict '@E 999.99'            valid CalcLucro( 1 )
      @ 14,60 get pPrecoVenda    pict PictPreco(14)          valid CalcLucro( 2 )
      if EmprARQ->Inteira == 'X'
        @ 15,15 get pQtde        pict '@E 9999999999'
//      @ 15,60 get nCaixa       pict '@E 9999999999'
        @ 15,60 get nPrecoMini   pict PictPreco(14) 
      else
        @ 15,15 get pQtde        pict '@E 999999.999'
//      @ 15,60 get nCaixa       pict '@E 999999.999'
        @ 15,60 get nPrecoMini   pict PictPreco(14) 
      endif
      @ 16,15 get cUnid          pict '@!'
      if EmprARQ->Inteira == 'X'
        @ 16,60 get nEstqMini    pict '@E 999999999'
      else
        @ 16,60 get nEstqMini    pict '@E 99999.999'
      endif
      @ 18,15 get dUltE          pict '99/99/9999'
      @ 18,60 get dUltS          pict '99/99/9999'
      read

      setcolor ( CorCampo )
      @ 17,15 say pQtde * pPrecoCusto  pict '@E 999,999,999.99'
      @ 17,60 say pQtde * pPrecoVenda  pict '@E 999,999,999.99'
    endif

    if pQtde           != Qtde;         lAlterou := .t.
    elseif pPrecoCusto != PrecoCusto;   lAlterou := .t.
    elseif pPrecoVenda != PrecoVenda;   lAlterou := .t.
    elseif pPrecoCusto != PrecoCusto;   lAlterou := .t.
    elseif dUltE       != UltE;         lAlterou := .t.
    elseif dUltS       != UltS;         lAlterou := .t.
    elseif cCodFab     != CodFab;       lAlterou := .t.
    elseif pNome       != Nome;         lAlterou := .t.
    elseif cRefe       != Refe;         lAlterou := .t.
    elseif nForn       != val( Forn );  lAlterou := .t.
    elseif nGrup       != val( Grup );  lAlterou := .t.
    elseif nSubG       != val( SubG );  lAlterou := .t.
    elseif cUnid       != Unid;         lAlterou := .t.
    elseif nEstqMini   != EstqMini;     lAlterou := .t.
    endif

    if !Saindo(lAlterou)
      loop
    endif
 
    exit
  enddo
  
  cForn := strzero( nForn, 6 )
  cGrup := strzero( nGrup, 6 )
  cSubG := strzero( nSubG, 6 )
return NIL

function PictPreco(nTama)
  local cPicture := left( EmprARQ->PictPreco, at( " ", EmprARQ->PictPreco ) ) +;
                    right( EmprARQ->PictPreco, nTama ) 
  if left( right( EmprARQ->PictPreco, nTama ) , 1 ) == ','
    cPicture := left( EmprARQ->PictPreco, at( " ", EmprARQ->PictPreco ) ) +;
                "9" + substr( right( EmprARQ->PictPreco, nTama ), 2 )         
  endif       
return(cPicture)

//
// Mostra Dados do Produto
//
function MostProd ()
  setcolor ( CorCampo )
  if cStat != 'incl' 
    nProd  := val( Prod )
    cProd  := Prod  
  endif
  
  cCodFab     := CodFab    
  cRefe       := Refe
  pNome       := Nome
  nForn       := val( Forn )
  cForn       := Forn
  nGrup       := val( Grup )
  cGrup       := Grup
  nSubG       := val( SubG )
  cSubG       := SubG
  cUnid       := Unid
  nPerC       := PerC
  cHist       := Hist
  cCodIPI     := CodIPI
  nCodTri     := CodTri
  cCodFisc    := CodFisc
  nPerIPI     := PerIPI
  nPesoLiqd   := PesoLiqd
  pPrecoCusto := PrecoCusto
  pPrecoVenda := PrecoVenda
  nPrecoMini  := PrecoMini
  cComposicao := Composicao
  nLucro      := Lucro
  nCaixa      := Caixa
  pQtde       := Qtde 
  nEstqMini   := EstqMini
  dUltE       := UltE
  dUltS       := UltS
  
  if pPrecoCusto == 0 .and. nLucro > 0 .and. pPrecoVenda > 0
    if nLucro > 100 
      pPrecoCusto := pPrecoVenda - ( ( pPrecoVenda * nLucro ) / 100 )
    endif  
  endif
  
  if nLucro < 0 .or. nLucro > 1000
    nLucro := 0
  endif  

  setcolor ( CorCampo )
  if EmprARQ->ProdSimp == "X"
    @ 06,60 say cCodFab              pict '@S14'
    @ 08,15 say pNome
    @ 09,15 say cRefe            
    @ 11,15 say cForn
    @ 11,22 say FornARQ->Nome
    @ 12,15 say cGrup
    @ 12,22 say GrupARQ->Nome
    @ 14,15 say pPrecoCusto          pict PictPreco(14) 
    @ 14,38 say nLucro               pict '@E 999.99'
    @ 14,60 say pPrecoVenda          pict PictPreco(14) 
    if EmprARQ->Inteira == 'X'
      @ 15,15 say pQtde              pict '@E 9999999999'
//    @ 15,60 say nCaixa             pict '@E 9999999999'
      @ 15,60 say nPrecoMini         pict PictPreco(14) 
    else  
      @ 15,15 say pQtde              pict '@E 999999.999'
//    @ 15,60 say nCaixa             pict '@E 999999.999'
      @ 15,60 say nPrecoMini         pict PictPreco(14) 
    endif  
    @ 16,15 say cUnid
    if EmprARQ->Inteira == 'X'
      @ 16,60 say nEstqMini          pict '@E 999999999'
    else  
      @ 16,60 say nEstqMini          pict '@E 99999.999'
    endif  
    @ 17,15 say pQtde * pPrecoCusto  pict '@E 999,999,999.99'
    @ 17,60 say pQtde * pPrecoVenda  pict '@E 999,999,999.99'
  
    PosiDBF( 04, 76 )
  else
    @ 03,60 say cCodFab              pict '@S14'
    @ 04,15 say pNome
    @ 05,15 say cRefe            
    @ 07,15 say cForn
    @ 07,22 say FornARQ->Nome
    @ 08,15 say cGrup
    @ 08,22 say GrupARQ->Nome
    @ 09,15 say cSubG
    @ 09,22 say SubGARQ->Nome
    @ 11,15 say nCodTri              pict '99'
    @ 11,38 say cCodFisc             pict '@K'
    @ 11,60 say nPesoLiqd            pict '@E 999.9'
    @ 12,15 say cCodIPI              pict '@!'
    @ 12,38 say nPerIPI              pict '@E 99.9'
    @ 12,60 say nPerC                pict '@E 999.9'
    @ 14,15 say pPrecoCusto          pict PictPreco(14) 
    @ 14,38 say nLucro               pict '@E 999.99'
    @ 14,60 say pPrecoVenda          pict PictPreco(14) 
    if EmprARQ->Inteira == 'X'
      @ 15,15 say pQtde              pict '@E 9999999999'
//    @ 15,60 say nCaixa             pict '@E 9999999999'
      @ 15,60 say nPrecoMini         pict PictPreco(14) 
    else  
      @ 15,15 say pQtde              pict '@E 999999.999'
//    @ 15,60 say nCaixa             pict '@E 999999.999'
      @ 15,60 say nPrecoMini         pict PictPreco(14) 
    endif  
    @ 16,15 say cUnid
    if EmprARQ->Inteira == 'X'
      @ 16,60 say nEstqMini          pict '@E 999999999'
    else  
      @ 16,60 say nEstqMini          pict '@E 99999.999'
    endif  
    @ 17,15 say pQtde * pPrecoCusto  pict '@E 999,999,999.99'
    @ 17,60 say pQtde * pPrecoVenda  pict '@E 999,999,999.99'
    @ 18,15 say dUltE                pict '99/99/9999'
    @ 18,60 say dUltS                pict '99/99/9999'
  
    PosiDBF( 01, 76 )
  endif
return NIL

//
// Calcula Preco de Venda
//
function CalcLucro( nTipo )
  if nTipo == 1
    if nLucro > 0
      pPrecoVenda := ( pPrecoCusto * nLucro ) / 100 + pPrecoCusto
    endif  
  else  
    if pPrecoCusto > 0
      nLucro := ( ( pPrecoVenda / pPrecoCusto ) - 1 ) * 100

      setcolor( CorCampo )
      @ 14,38 say nLucro               pict '@E 999.99'
      
      setcolor( CorJanel + ',' + CorCampo )
    endif
  endif       
  
  if nLucro < 0 .or. nLucro > 1000
    nLucro := 0
  endif  
return(.t.)

//
// Imprime Dados dos Produtos
//
function PrinProd ( lAbrir, xTipo )

  local cArqu2  := CriaTemp( 5 )
  local cArqu3  := right ( cArqu2, 8 )

  local cRData  := date()
  local cRHora  := time()
  
  local GetList := {}

  if lAbrir
    if NetUse( "ProdARQ", .t. )
      VerifIND( "ProdARQ" )

      #ifdef DBF_NTX
        set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
      #endif
    endif

    if NetUse( "FornARQ", .t. )
      VerifIND( "FornARQ" )

      #ifdef DBF_NTX
        set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
      #endif
    endif

    if NetUse( "GrupARQ", .t. )
      VerifIND( "GrupARQ" )

      #ifdef DBF_NTX
        set index to GrupIND1, GrupIND2
      #endif
    endif

    if NetUse( "SubGARQ", .t. )
      VerifIND( "SubGARQ" )

      #ifdef DBF_NTX
        set index to SubGIND1, SubGIND2, SubGIND3
      #endif
    endif
  endif  

  //  Define Intervalo
  Janela ( 05, 04, 14, 70, mensagem( 'Janela', 'PrinProd', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 07,06 say '   Produto Inicial                  Produto Final'
  @ 08,06 say 'Referência Inicial               Referência Final'
  @ 09,06 say 'Fornecedor Inicial               Fornecedor Final'
  @ 10,06 say '     Grupo Inicial                    Grupo Final'
  @ 11,06 say '  Subgrupo Inicial                 Subgrupo Final'
  @ 13,06 say '        Quantidade'
  
  setcolor( CorCampo )
  @ 13,25 say ' Todas   '
  @ 13,35 say ' Falta   '
  @ 13,45 say ' Estoque '
  
  setcolor( CorAltKC )
  @ 13,26 say 'T'
  @ 13,36 say 'F'
  @ 13,46 say 'E'
  
  select GrupARQ
  set order to 1
  dbgotop () 
  nGrupIni := val( Grup )
  dbgobottom ()
  nGrupFin := val( Grup )

  select FornARQ
  set order to 1
  dbgotop () 
  nFornIni := val( Forn )
  dbgobottom ()
  nFornFin := val( Forn )

  select ProdARQ
  set order to 1
  dbgotop ()
  nProdIni := val( Prod )
  dbgobottom ()
  nProdFin := val( Prod )
  nSubgIni := 000
  nSubgFin := 999999
  cRefeIni := space(15)
  cRefeFin := 'z' + space(14)
  cProd    := space(04)
  nQtdade  := 0

  @ 07,25 get nProdIni  pict '999999'          valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdIni" ) 
  @ 07,56 get nProdFin  pict '999999'          valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdFin" ) .and. nProdFin >= nProdIni
  @ 08,25 get cRefeIni  pict '@S10'
  @ 08,56 get cRefeFin  pict '@S10'            valid cRefeFin >= cRefeIni
  @ 09,25 get nFornIni  pict '999999'          valid ValidForn( 99, 99, "ProdARQ", "nFornIni" )       
  @ 09,56 get nFornFin  pict '999999'          valid ValidForn( 99, 99, "ProdARQ", "nFornFin" ) .and. nFornFin >= nFornIni
  @ 10,25 get nGrupIni  pict '999999'          valid ValidARQ( 99, 99, "ProdARQ", "Código", "Grup", "Descrição", "Nome", "Grup", "nGrupIni", .t., 6, "Consulta de Grupos", "GrupARQ", 30 )
  @ 10,56 get nGrupFin  pict '999999'          valid ValidARQ( 99, 99, "ProdARQ", "Código", "Grup", "Descrição", "Nome", "Grup", "nGrupFin", .t., 6, "Consulta de Grupos", "GrupARQ", 30 ) .and. nGrupFin >= nGrupIni
  @ 11,25 get nSubgIni  pict '999999' 
  @ 11,56 get nSubgFin  pict '999999'          valid nSubgFin >= nSubgIni
  read

  if lastkey() == K_ESC
    if lAbrir
      select ProdARQ
      close
      select GrupARQ
      close
      select SubGARQ
      close
      select FornARQ
      close
    else
      select ProdARQ
      dbgobottom ()
    endif
    return NIL
  endif

  aOpc := {}

  aadd( aOpc, { ' Todas   ', 2, 'T', 13, 25, "Seleção de todos as Quantidades." } )
  aadd( aOpc, { ' Falta   ', 2, 'F', 13, 35, "Seleção de Produtos em Falta." } )
  aadd( aOpc, { ' Estoque ', 2, 'E', 13, 45, "Seleção de Produtos em Estoque." } )

  nOpca := HCHOICE( aOpc, 3, 3 )

  if lastkey() == K_ESC
    if lAbrir
      select ProdARQ
      close
      select GrupARQ
      close
      select SubGARQ
      close
      select FornARQ
      close
    else 
      select ProdARQ
      dbgobottom ()
    endif
    return NIL
  endif

  Aguarde ()
  
  nPag   := 1
  nLin   := 0
  cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

  cGrupIni := strzero( nGrupIni, 6 )
  cGrupFin := strzero( nGrupFin, 6 )
  cSubgIni := strzero( nSubGIni, 6 )
  cSubgFin := strzero( nSubGFin, 6 )
  cProdIni := strzero( nProdIni, 6 )
  cProdFin := strzero( nProdFin, 6 )
  cFornIni := strzero( nFornIni, 6 )
  cFornFin := strzero( nFornFin, 6 )
  lInicio  := .t.

  cGrupAnt    := cSubGAnt    := space (6)
  nTotaCusto  := nTotaVenda  := 0

  select ProdARQ
  do case 
    case xTipo == 'A'
      set order to 2  
    case xTipo == 'R'
      set order to 6 
    otherwise
      set order to 1  
  endcase    
  set relation to Grup into GrupARQ, to Grup+SubG into SubGARQ
  dbgotop ()
  do while !eof ()
    if Prod >= cProdIni .and. Prod <= cProdFin .and.;
      val( Forn )  >= nFornIni .and. val( Forn ) <= nFornFin .and.;
      val( SubG )  >= nSubgIni .and. val( SubG ) <= nSubgFin .and.;
      val( Grup )  >= nGrupIni .and. val( Grup ) <= nGrupFin .and.;
      Refe  >= cRefeIni .and. Refe <= cRefeFin
      
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
        do case
          case xTipo == 'A'
            Cabecalho ( 'Produtos - Alfabetico', 132, 2 )
          case xTipo == 'R'
            Cabecalho ( 'Produtos - Referência', 132, 2 )
          otherwise
            Cabecalho ( 'Produtos - Codigo', 132, 2 )
        endcase    
        
        CabProd ()
      endif

      @ nLin,001 say Nome        pict '@S48' 
      @ nLin,050 say Prod        pict '999999'
      @ nLin,057 say Refe        pict '@S15'
      @ nLin,073 say Unid         
      if EmprARQ->Inteira == 'X'
        @ nLin,077 say Qtde      pict '@E 9999999999'
      else      
        @ nLin,077 say Qtde      pict '@E 999999.999'
      endif
      @ nLin,090 say PrecoCusto  pict PictPreco(10)
      @ nLin,102 say Lucro       pict '@E 9999.99'
      if EmprARQ->Moeda == "X"
        @ nLin,112 say PrecoVenda * nMoedaDia pict pictPreco(10)
      else
        @ nLin,112 say PrecoVenda  pict PictPreco(10)
      endif
      nLin ++
      
      if EmprARQ->Moeda == "X"
        nTotaCusto += ( Qtde * ( PrecoCusto * nMoedaDia ) )
        nTotaVenda += ( Qtde * ( PrecoVenda * nMoedaDia ) )
      else
        nTotaCusto += ( Qtde * PrecoCusto )
        nTotaVenda += ( Qtde * PrecoVenda )
      endif
             
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
    nLin ++
    @ nLin,077 say 'Total Geral'
    @ nLin,090 say nTotaCusto  pict '@E 999,999.99'
    @ nLin,112 say nTotaVenda  pict '@E 999,999.99'
    Rodape(132)
  endif
 
  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 132 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      do case 
        case xTipo == 'A'
          do case
            case nOpca == 1
              replace Titu       with "Relatório de Produtos - Alfabetico - Todas"
            case nOpca == 2
              replace Titu       with "Relatório de Produtos - Alfabetico - Falta"
            case nOpca == 3
              replace Titu       with "Relatório de Produtos - Alfabetico - Estoque"
          endcase    
        case xTipo == 'R'
          do case
            case nOpca == 1
              replace Titu       with "Relatório de Produtos - Referência - Todas"
            case nOpca == 2
              replace Titu       with "Relatório de Produtos - Referência - Falta"
            case nOpca == 3
              replace Titu       with "Relatório de Produtos - Referência - Estoque"
          endcase    
        otherwise
          do case
            case nOpca == 1
              replace Titu       with "Relatório de Produtos - Codigo - Todas"
            case nOpca == 2
              replace Titu       with "Relatório de Produtos - Codigo - Falta"
            case nOpca == 3
              replace Titu       with "Relatório de Produtos - Codigo - Estoque"
          endcase    
      endcase    
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
    select GrupARQ
    close
    select SubGARQ
    close
    select FornARQ
    close
  else 
    select ProdARQ
    set order  to 1
    dbgobottom ()
  endif
return NIL

function CabProd()
  @ 02,01 say 'Produto/Serviço                                    Cod Referˆncia      Un.      Qtde.  Preço Custo    Lucro  Preço Venda'

  nLin := 04
return NIL

//
// Imprimir Posicao do Estoque
//
function PrinPosi ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )

    #ifdef DBF_NTX
      set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6 
    #endif
  endif

  if NetUse( "FornARQ", .t. )
    VerifIND( "FornARQ" )

    #ifdef DBF_NTX
      set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
    #endif
  endif

  if NetUse( "GrupARQ", .t. )
    VerifIND( "GrupARQ" )

    #ifdef DBF_NTX
      set index to GrupIND1, GrupIND2
    #endif
  endif

  if NetUse( "SubGARQ", .t. )
    VerifIND( "SubGARQ" )

    #ifdef DBF_NTX
      set index to SubGIND1, SubGIND2, SubGIND3
    #endif
  endif

  //  Define Intervalo
  Janela ( 06, 15, 12, 69, mensagem( 'Janela', 'PrinProd', .f. ), .f. )
  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,17 say '      Produto Inicial           Produto Final'
  @ 09,17 say '   Fornecedor Inicial        Fornecedor Final'
  @ 10,17 say '        Grupo Inicial             Grupo Final'
  @ 11,17 say '     Subgrupo Inicial          Subgrupo Final'
  
  select GrupARQ
  set order to 1
  dbgotop () 
  nGrupIni := val( Grup )
  dbgobottom ()
  nGrupFin := val( Grup )

  select FornARQ
  set order to 1
  dbgotop () 
  nFornIni := val( Forn )
  dbgobottom ()
  nFornFin := val( Forn )

  select ProdARQ
  set order to 1
  dbgotop () 
  nProdIni := val( Prod )
  dbgobottom ()
  nProdFin := val( Prod )

  nSubgIni := 000
  nSubgFin := 999999
  cProd    := space(06)

  @ 08,39 get nProdIni  pict '999999'         valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdIni" ) 
  @ 08,63 get nProdFin  pict '999999'         valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdFin" ) .and. nProdFin >= nProdIni
  @ 09,39 get nFornIni  pict '999999'         valid ValidForn( 99, 99, "ProdARQ", "nFornIni" )       
  @ 09,63 get nFornFin  pict '999999'         valid ValidForn( 99, 99, "ProdARQ", "nFornFin" ) .and. nFornFin >= nFornIni
  @ 10,39 get nGrupIni  pict '999999'          valid ValidARQ( 99, 99, "ProdARQ", "Código", "Grup", "Descrição", "Nome", "Grup", "nGrupIni", .t., 6, "Consulta de Grupos", "GrupARQ", 30 )
  @ 10,63 get nGrupFin  pict '999999'          valid ValidARQ( 99, 99, "ProdARQ", "Código", "Grup", "Descrição", "Nome", "Grup", "nGrupFin", .t., 6, "Consulta de Grupos", "GrupARQ", 30 ) .and. nGrupFin >= nGrupIni
  @ 11,39 get nSubgIni  pict '999999'  
  @ 11,63 get nSubgFin  pict '999999'          valid nSubgFin >= nSubgIni
  read

  if lastkey() == K_ESC
    select ProdARQ
    close
    select GrupARQ
    close
    select SubGARQ
    close
    select FornARQ
    close
    return NIL
  endif
  
  Aguarde ()

  nPag     := 1
  nLin     := 0
  cArqu2   := cArqu2 + "." + strzero( nPag, 3 )
  lInicio  := .t.

  cGrupIni := strzero( nGrupIni, 6 )
  cGrupFin := strzero( nGrupFin, 6 )
  cSubgIni := strzero( nSubGIni, 6 )
  cSubgFin := strzero( nSubGFin, 6 )
  cProdIni := strzero( nProdIni, 6 )
  cProdFin := strzero( nProdFin, 6 )
  cFornIni := strzero( nFornIni, 6 )
  cFornFin := strzero( nFornFin, 6 )

  select ProdARQ
  set order to 2
  set relation to Grup into GrupARQ, to Grup+SubG into SubGARQ
  dbgotop ()
  do while !eof()
    if Prod >= cProdIni .and. Prod <= cProdFin .and.;
      Forn  >= cFornIni .and. Forn <= cFornFin .and.;
      SubG  >= cSubgIni .and. SubG <= cSubgFin .and.;
      Grup  >= cGrupIni .and. Grup <= cGrupFin
      
      if lInicio
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
        
        lInicio := .f.
      endif     

      if nLin == 0
        Cabecalho ( 'Posição do Estoque', 80, 2 )
        CabPosi ()
      endif
       
      nRepor := EstqMini - Qtde

      if nRepor < 0 
        dbskip ()
        loop
      endif  

      @ nLin, 00 say Prod
      @ nLin, 07 say Nome                    pict '@S40' 
      if EmprARQ->Inteira == 'X'
        @ nLin, 50 say Qtde                  pict '@E 99999999999'
      else      
        @ nLin, 50 say Qtde                  pict '@E 9999999.999'
      endif     
      @ nLin, 63 say EstqMini                pict '9999999'
      @ nLin, 72 say nRepor                  pict '9999999'
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
      replace Titu       with "Relatório da Posição do Estoque"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
    close
  endif

  select ProdARQ
  close
  select GrupARQ
  close
  select SubGARQ
  close
  select FornARQ
  close
return NIL

function CabPosi()
  @ 02,01 say 'Prod.   Descrição                                    Estoque  Est.Min    Repor'

  nLin := 04
return NIL

//
// Relatório das Entradas e Saídas
//
function PrinEnSa ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "NEntARQ", .t. )
    VerifIND( "NEntARQ" )

    #ifdef DBF_NTX
      set index to NEntIND1
    #endif
  endif

  if NetUse( "INEnARQ", .t. )
    VerifIND( "INEnARQ" )

    #ifdef DBF_NTX
      set index to INEnIND1
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

  if NetUse( "EProARQ", .t. )
    VerifIND( "EProARQ" )

    #ifdef DBF_NTX
      set index to EProIND1
    #endif
  endif

  if NetUse( "IEPrARQ", .t. )
    VerifIND( "IEPrARQ" )

    #ifdef DBF_NTX
      set index to IEPrIND1
    #endif
  endif

  if NetUse( "SProARQ", .t. )
    VerifIND( "SProARQ" )

    #ifdef DBF_NTX
      set index to SProIND1
    #endif
  endif

  if NetUse( "ISPrARQ", .t. )
    VerifIND( "ISPrARQ" )

    #ifdef DBF_NTX
      set index to ISPrIND1
    #endif
  endif

  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )
  
    #ifdef DBF_NTX
      set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
    #endif
  endif

  if NetUse( "FornARQ", .t. )
    VerifIND( "FornARQ" )

    #ifdef DBF_NTX
      set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
    #endif
  endif

  if NetUse( "GrupARQ", .t. )
    VerifIND( "GrupARQ" )

    #ifdef DBF_NTX
      set index to GrupIND1, GrupIND2
    #endif
  endif

  if NetUse( "SubGARQ", .t. )
    VerifIND( "SubGARQ" )

    #ifdef DBF_NTX
      set index to SubGIND1, SubGIND2, SubGIND3
    #endif
  endif

  clear gets

  //  Define Intervalo
  Janela ( 08, 12, 15, 70, mensagem( 'Janela', 'PrinEnSa', .f. ), .f.)
  Mensagem( 'Prod', 'PrinEnSa' )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,14 say '      Data Inicial                Data Final'
  @ 11,14 say '   Produto Inicial             Produto Final'
  @ 12,14 say 'Fornecedor Inicial          Fornecedor Final'
  @ 13,14 say '     Grupo Inicial               Grupo Final'
  @ 14,14 say '  Subgrupo Inicial            Subgrupo Final'
  
  select GrupARQ
  set order to 1
  dbgotop () 
  nGrupIni := val( Grup )
  dbgobottom ()
  nGrupFin := val( Grup )

  select FornARQ
  set order to 1
  dbgotop () 
  nFornIni := val( Forn )
  dbgobottom ()
  nFornFin := val( Forn )

  select ProdARQ
  set order to 1
  dbgotop ()
  nProdIni := val( Prod )
  dbgobottom ()
  nProdFin := val( Prod )

  dDataIni := ctod('01/01/1900')
  dDataFin := ctod('31/12/2015')
  nSubgIni := 000
  nSubgFin := 999999
  cProd    := space(064)
  
  @ 10,33 get dDataIni           pict '99/99/9999'
  @ 10,59 get dDataFin           pict '99/99/9999' valid dDataFin >= dDataIni
  @ 11,33 get nProdIni           pict '999999'     valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdIni" ) 
  @ 11,59 get nProdFin           pict '999999'     valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdFin" ) .and. nProdFin >= nProdIni
  @ 12,33 get nFornIni           pict '999999'     valid ValidForn( 99, 99, "ProdARQ", "nFornIni" )       
  @ 12,59 get nFornFin           pict '999999'     valid ValidForn( 99, 99, "ProdARQ", "nFornFin" ) .and. nFornFin >= nFornIni
  @ 13,33 get nGrupIni           pict '999999'      valid ValidARQ( 99, 99, "ProdARQ", "Código", "Grup", "Descrição", "Nome", "Grup", "nGrupIni", .t., 6, "Consulta de Grupos", "GrupARQ", 30 )
  @ 13,59 get nGrupFin           pict '999999'      valid ValidARQ( 99, 99, "ProdARQ", "Código", "Grup", "Descrição", "Nome", "Grup", "nGrupFin", .t., 6, "Consulta de Grupos", "GrupARQ", 30 ) .and. nGrupFin >= nGrupIni
  @ 14,33 get nSubgIni           pict '999999'  
  @ 14,59 get nSubgFin           pict '999999'      valid nSubgFin >= nSubgIni
  read

  if lastkey() == K_ESC
    select ProdARQ
    close
    select GrupARQ
    close
    select SubGARQ
    close
    select EProARQ
    close
    select IEPrARQ
    close
    select SProARQ
    close
    select ISPrARQ
    close
    select NEntARQ
    close
    select INEnARQ
    close
    select NSaiARQ
    close
    select INSaARQ
    close
    select FornARQ
    close
    return NIL
  endif
  
  Aguarde ()
  
  nPag   := 1
  nLin   := 0
  cArqu2 := cArqu2 + "." + strzero( nPag, 3 )
   
  aProdutos   := {}
  nTotalSaid  := 0
  nTotalEntr  := 0
  nTotalCusto := 0
  lInicio     := .t.
  
  cGrupIni := strzero( nGrupIni, 6 )
  cGrupFin := strzero( nGrupFin, 6 )
  cSubgIni := strzero( nSubGIni, 6 )
  cSubgFin := strzero( nSubGFin, 6 )
  cProdIni := strzero( nProdIni, 6 )
  cProdFin := strzero( nProdFin, 6 )
  cFornIni := strzero( nFornIni, 6 )
  cFornFin := strzero( nFornFin, 6 )
  
  select ProdARQ  
  set order to 1
  dbseek( cProdIni, .t. )

  do while Prod >= cProdIni .and. Prod <= cProdFin .and. !eof()
    if Forn >= cFornIni .and. Forn <= cFornFin .and.;
       Grup >= cGrupIni .and. Grup <= cGrupFin .and.;
       SubG >= cSubGIni .and. SubG <= cSubGFin
   
      aadd( aProdutos, { Prod, 0, 0 } )
    endif                                 
    dbskip ()
  enddo

  select EProARQ
  set order to 1
  dbgotop ()
  do while !eof()
    if Emis >= dDataIni .and. Emis <= dDataFin
      cNota := Nota
    
      select IEPrARQ
      set order    to 1
      set relation to Prod into ProdARQ
      dbseek( cNota, .t. )
      do while Nota == cNota
        cProd     := Prod
        pQtde     := Qtde
        nProdElem := ascan( aProdutos, { |nElem| nElem[1] == cProd } )
      
        if nProdElem > 0
          aProdutos[ nProdElem, 2 ] += pQtde
        endif  
        
        dbskip ()
      enddo

      select EProARQ
    endif  
    dbskip ()
  enddo

  select SProARQ
  set order to 1
  dbgotop ()
  do while !eof()
    if Emis >= dDataIni .and. Emis <= dDataFin
      cNota := Nota
    
      select ISPrARQ
      set order    to 1
      set relation to Prod into ProdARQ
      dbseek( cNota + '01', .t. )
      do while Nota == cNota
        cProd     := Prod
        pQtde     := Qtde
        nProdElem := ascan( aProdutos, { |nElem| nElem[1] == cProd } )
      
        if nProdElem > 0
          aProdutos[ nProdElem, 3 ] += pQtde
        endif  
        
        dbskip ()
      enddo
      select SProARQ
    endif  

    dbskip ()
  enddo

//
// Soma as Saidas - Notas Fiscais
//   
  
  select NSaiARQ 
  set order to 1
  dbgotop ()
  do while !eof()
    if Emis >= dDataIni .and. Emis <= dDataFin
      cNota := Nota

      select INSaARQ
      set order    to  1
      set relation to Prod into ProdARQ
      dbseek( cNota, .t. )
      do while Nota == cNota
        cProd    := Prod
        pQtde    := Qtde

        nProdElem := ascan( aProdutos, { |nElem| nElem[1] == cProd } )
        if nProdElem > 0
          aProdutos[ nProdElem, 3 ] += pQtde
        endif  
        dbskip ()
      enddo

      select NSaiARQ
    endif  
    dbskip ()
  enddo

  //
  // Soma as Entradas - Nota de Entradas
  //
  select NEntARQ 
  set order to 1
  dbgotop ()
  do while !eof()
    if Emis >= dDataIni .and. Emis <= dDataFin
      cNota := Nota
      cForn := Forn

      select INenARQ
      set order    to 1
      set relation to Prod into ProdARQ
      dbseek( cForn + cNota, .t. )
      do while Nota == cNota .and. Forn == cForn .and. !eof()
        cProd    := Prod
        pQtde    := Qtde

        nProdElem := ascan( aProdutos, { |nElem| nElem[1] == cProd } )
        if nProdElem > 0
          aProdutos[ nProdElem, 2 ] += pQtde
        endif  
        dbskip ()
      enddo
      select NEntARQ
    endif
      
    dbskip ()
  enddo
  
  asort( aProdutos,,, { | Prod01, Prod02 | Prod01[3] > Prod02[3] } )

  select ProdARQ
  set order to 1

  //
  //  Imprimir - Entrada e Saidas
  //
  for nIni := 1 to len( aProdutos )       
    cProd  := aProdutos[ nIni, 1 ]
    nEntr  := aProdutos[ nIni, 2 ]
    nSaid  := aProdutos[ nIni, 3 ]
       
    if nEntr == 0 .and. nSaid == 0
      loop
    endif
    
    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
      
      lInicio := .f.
    endif  
       
    if nLin == 0
      Cabecalho ( 'Entradas e Saidas', 132, 2 )
      CabEnSa ()
    endif
       
    dbseek( cProd, .f. )
       
    nCustoBruto := PrecoCusto * Qtde  
    nTotalCusto += nCustoBruto
       
    @ nLin,001 say cProd
    @ nLin,009 say ProdARQ->Nome       pict '@S38'
    @ nLin,068 say nEntr               pict '@E 999999.999'
    @ nLin,079 say nSaid               pict '@E 999999.999'
    if EmprARQ->Inteira == 'X'
      @ nLin,091 say Qtde              pict '@E 9999999999'
    else  
      @ nLin,091 say Qtde              pict '@E 999999.999'
    endif  
    @ nLin,102 say PrecoCusto          pict PictPreco(14)
    @ nLin,118 say nCustoBruto         pict PictPreco(14)
       
    nTotalEntr += nEntr
    nTotalSaid += nSaid
    nLin       ++
    
    if nLin >= pLimite
      Rodape(132) 

      cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
      cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

      set printer to ( cArqu2 )
      set printer on
    endif
  next
    
  if !lInicio
    nLin ++
    @ nLin,051 say 'Total Geral'
    @ nLin,068 say nTotalEntr              pict '9999999999'
    @ nLin,079 say nTotalSaid              pict '9999999999'
    @ nLin,118 say nTotalCusto             pict '@E 999,999,999.99'
     
    Rodape(132)
  endif  
 
  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 132 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Relatório de Entradas e Saídas"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 132
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
    close
  endif

  select ProdARQ
  close
  select GrupARQ
  close
  select SubGARQ
  close
  select EProARQ
  close
  select IEPrARQ
  close
  select SProARQ
  close
  select ISPrARQ
  close
  select NEntARQ
  close
  select INEnARQ
  close
  select NSaiARQ
  close
  select INSaARQ
  close
  select FornARQ
  close
return NIL

function CabEnSa ()
  @ 02,001 say 'Periodo ' + dtoc( dDataIni ) + ' a ' + dtoc( dDataFin )
  @ 03,01 say 'Cod   Descrição                                                      Entrada      Saída     Estoque    Preço Custo     Custo Bruto'

  nLin := 05
return NIL

//
// Relatório do Estoque Minimo Discriminado
//
function PrinEMDe ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "NEntARQ", .t. )
    VerifIND( "NEntARQ" )

    #ifdef DBF_NTX
      set index to NEntIND1
    #endif
  endif

  if NetUse( "INEnARQ", .t. )
    VerifIND( "INEnARQ" )

    #ifdef DBF_NTX
      set index to INEnIND1
    #endif
  endif

  if NetUse( "FornARQ", .t. )
    VerifIND( "FornARQ" )

    #ifdef DBF_NTX
      set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
    #endif
  endif

  if NetUse( "CondARQ", .t. )
    VerifIND( "CondARQ" )

    #ifdef DBF_NTX
      set index to CondIND1
    #endif
  endif

  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )

    pOpenProd := .t.

    #ifdef DBF_NTX
      set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
    #endif
  else
    pOpenProd := .f.
  endif

  if NetUse( "GrupARQ", .t. )
    VerifIND( "GrupARQ" )

    pOpenGrup := .t.

    #ifdef DBF_NTX
      set index to GrupIND1, GrupIND2
    #endif
  else
    pOpenGrup := .f.
  endif

  if NetUse( "SubGARQ", .t. )
    VerifIND( "SubGARQ" )

    pOpenSubG := .t.

    #ifdef DBF_NTX
      set index to SubGIND1, SubGIND2, SubGIND3
    #endif
  else
    pOpenSubG := .f.
  endif

  //  Define Intervalo
  Janela ( 08, 12, 15, 70, mensagem( 'Janela', 'PrinEMDe', .f. ), .f.)
  Mensagem( 'Prod', 'PrinEMDe' )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,13 say '     Produto Inicial             Produto Final'
  @ 12,13 say '  Fornecedor Inicial          Fornecedor Final'
  @ 13,13 say '       Grupo Inicial               Grupo Final'
  @ 14,13 say '    Subgrupo Inicial            Subgrupo Final'
  
  select GrupARQ
  set order to 1
  dbgotop () 
  nGrupIni := val( Grup )
  dbgobottom ()
  nGrupFin := val( Grup )

  select FornARQ
  set order to 1
  dbgotop () 
  nFornIni := val( Forn )
  dbgobottom ()
  nFornFin := val( Forn )

  select ProdARQ
  set order to 1
  dbgotop()
  nProdIni := val( Prod )
  dbgobottom()
  nProdFin := val( Prod )

  nSubgIni := 000
  nSubgFin := 999999
  cProd    := space(06)

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,34 get nProdIni           pict '999999'     valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdIni" ) 
  @ 10,60 get nProdFin           pict '999999'     valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdFin" ) .and. nProdFin >= nProdIni
  @ 12,34 get nFornIni           pict '999999'     valid ValidForn( 99, 99, "ProdARQ", "nFornIni" )       
  @ 12,60 get nFornFin           pict '999999'     valid ValidForn( 99, 99, "ProdARQ", "nFornFin" ) .and. nFornFin >= nFornIni
  @ 13,34 get nGrupIni           pict '999999'      valid ValidARQ( 99, 99, "ProdARQ", "Código", "Grup", "Descrição", "Nome", "Grup", "nGrupIni", .t., 6, "Consulta de Grupos", "GrupARQ", 30 )
  @ 13,60 get nGrupFin           pict '999999'      valid ValidARQ( 99, 99, "ProdARQ", "Código", "Grup", "Descrição", "Nome", "Grup", "nGrupFin", .t., 6, "Consulta de Grupos", "GrupARQ", 30 ) .and. nGrupFin >= nGrupIni
  @ 14,34 get nSubgIni           pict '999999'  
  @ 14,60 get nSubgFin           pict '999999'      valid nSubgFin >= nSubgIni
  read

  if lastkey() == K_ESC
    select ProdARQ
    close
    select GrupARQ
    close
    select SubGARQ
    close
    select FornARQ
    close
    select NEntARQ
    close
    select INEnARQ
    close
    select CondARQ
    close
    return NIL
  endif
  
  Aguarde ()

  nPag   := 1
  nLin   := 0
  cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

  aProdutos   := {}
  lInicio     := .t.
  cGrupIni := strzero( nGrupIni, 6 )
  cGrupFin := strzero( nGrupFin, 6 )
  cSubgIni := strzero( nSubGIni, 6 )
  cSubgFin := strzero( nSubGFin, 6 )
  cProdIni := strzero( nProdIni, 6 )
  cProdFin := strzero( nProdFin, 6 )
  cFornIni := strzero( nFornIni, 6 )
  cFornFin := strzero( nFornFin, 6 )
  
  select ProdARQ  
  set order  to 1
  dbseek( cProdIni, .t. )

  do while Prod >= cProdIni .and. Prod <= cProdFin .and. !eof()
    if Forn >= cFornIni .and. Forn <= cFornFin .and.;
       Grup >= cGrupIni .and. Grup <= cGrupFin .and.;
       SubG >= cSubGIni .and. SubG <= cSubGFin
    
      if ( EstqMini - Qtde ) <= 0
        dbskip ()
        loop
      endif  
    
      aadd( aProdutos, { Prod, space(06), space(08), 0, space(06),;
                               space(06), space(08), 0, space(06),;
                               space(06), space(08), 0, space(06) } )
    endif                                 
    dbskip ()
  enddo

  //
  // Soma as Entradas - Nota de Entradas
  //
  select NEntARQ 
  dbgobottom ()
  do while !bof()
    cNota := Nota
    cForn := Forn
    dEmis := Emis
    cCond := Cond
    lFim  := .f.
    
    select INenARQ
    set order to 1
    dbseek( cForn + cNota, .t. )
    do while Nota == cNota .and. !eof()
      cProd       := Prod
      pQtde       := Qtde
      pPrecoCusto := PrecoCusto
      nProdElem   := ascan( aProdutos, { |nElem| nElem[1] == cProd } )
     
      if nProdElem > 0
        do case
          case aProdutos[ nProdElem, 02 ] == space(06)
            aProdutos[ nProdElem, 02 ] := cForn
            aProdutos[ nProdElem, 03 ] := dEmis
            aProdutos[ nProdElem, 04 ] := pPrecoCusto
            aProdutos[ nProdElem, 05 ] := cCond
          case aProdutos[ nProdElem, 06 ] == space(06)
            aProdutos[ nProdElem, 06 ] := cForn
            aProdutos[ nProdElem, 07 ] := dEmis
            aProdutos[ nProdElem, 08 ] := pPrecoCusto
            aProdutos[ nProdElem, 09 ] := cCond
          case aProdutos[ nProdElem, 10 ] == space(06)
            aProdutos[ nProdElem, 10 ] := cForn
            aProdutos[ nProdElem, 11 ] := dEmis
            aProdutos[ nProdElem, 12 ] := pPrecoCusto
            aProdutos[ nProdElem, 13 ] := cCond

            lFim := .t.
        endcase
      endif  

      if lFim 
        exit
      endif  
      
      dbskip ()
    enddo

    select NEntARQ
    dbskip(-1)
  enddo

  select ProdARQ
  set order to 1

  //
  //  Imprimir - Produtos em Estoque Mínimo
  //
  for nIni := 1 to len( aProdutos )       
    cProd   := aProdutos[ nIni, 01 ]
    cForn01 := aProdutos[ nIni, 02 ]
    dEmis01 := aProdutos[ nIni, 03 ]
    nUnit01 := aProdutos[ nIni, 04 ]
    cCond01 := aProdutos[ nIni, 05 ]

    cForn02 := aProdutos[ nIni, 06 ]
    dEmis02 := aProdutos[ nIni, 07 ]
    nUnit02 := aProdutos[ nIni, 08 ]
    cCond02 := aProdutos[ nIni, 09 ]

    cForn03 := aProdutos[ nIni, 10 ]
    dEmis03 := aProdutos[ nIni, 11 ]
    nUnit03 := aProdutos[ nIni, 12 ]
    cCond03 := aProdutos[ nIni, 13 ]
 
    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
      
      lInicio := .f.
    endif  
       
    if nLin == 0
      Cabecalho ( 'Estoque Minimo com Fornecedores', 132, 2 )
      CabEMDe ()
    endif
        
    dbseek( cProd, .f. )
      
    pQtde     := Qtde
    nEstqMini := EstqMini 
       
    @ nLin,001 say cProd
    @ nLin,009 say ProdARQ->Nome        pict '@S28'
    if EmprARQ->Inteira == 'X'
      @ nLin,040 say pQtde              pict '@E 99999999999'
    else  
      @ nLin,040 say pQtde              pict '@E 9999999.999'
    endif  
    @ nLin,052 say nEstqMini            pict '@E 99999.9'

    if !empty( cForn01 )
      select FornARQ
      dbseek( cForn01, .f. )

      select CondARQ
      dbseek( cCond01, .f. )
       
      @ nLin,062 say cForn01           
      @ nLin,069 say FornARQ->Nome      pict '@S18'
      @ nLin,091 say dEmis01            pict '99/99/9999'
      @ nLin,101 say nUnit01            pict '@E 9,999.9999'
      @ nLin,114 say val( cCond01 )     pict '999999'
      @ nLin,121 say CondARQ->Nome      pict '@S15'     
    endif  
      
    if !empty( cForn02 )
      select FornARQ
      dbseek( cForn02, .f. )

      select CondARQ
      dbseek( cCond02, .f. )
       
      nLin ++       
      @ nLin,062 say cForn02           
      @ nLin,069 say FornARQ->Nome      pict '@S18'
      @ nLin,091 say dEmis02            pict '99/99/9999'
      @ nLin,101 say nUnit02            pict '@E 9,999.9999'
      @ nLin,114 say cCond02            pict '999999'
      @ nLin,121 say CondARQ->Nome      pict '@S11'     
    endif  
      
    if !empty( cForn03 )
      select FornARQ
      dbseek( cForn03, .f. )

      select CondARQ
      dbseek( cCond03, .f. )
       
      nLin ++       
      @ nLin,062 say cForn03           
      @ nLin,069 say FornARQ->Nome      pict '@S18'
      @ nLin,091 say dEmis03            pict '99/99/9999'
      @ nLin,101 say nUnit03            pict '@E 9,999.9999'
      @ nLin,114 say cCond03            pict '9999'
      @ nLin,117 say CondARQ->Nome      pict '@S15'     
    endif  

    nLin ++

    select ProdARQ
    
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
      replace Titu       with 'Relatório de Estoque Mínimo com Fornecedores'
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 132
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
    close
  endif

  select ProdARQ
  close
  select GrupARQ
  close
  select SubGARQ
  close
  select FornARQ
  close
  select NEntARQ
  close
  select INEnARQ
  close
  select CondARQ
  close
return NIL

function CabEMDe ()
  @ 02,01 say 'Prod.   Descrição                          Estq.  Estq.Min.  Fornecedor                   Emissão   Preço Unit.  Condições'
  nLin := 04
return NIL

//
// Relatório do Estoque com os ultimos fornecedores
//
function PrinUltF ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "NEntARQ", .t. )
    VerifIND( "NEntARQ" )

    #ifdef DBF_NTX
      set index to NEntIND1
    #endif
  endif

  if NetUse( "INEnARQ", .t. )
    VerifIND( "INEnARQ" )

    #ifdef DBF_NTX
      set index to INEnIND1
    #endif
  endif

  if NetUse( "FornARQ", .t. )
    VerifIND( "FornARQ" )

    #ifdef DBF_NTX
      set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
    #endif
  endif

  if NetUse( "CondARQ", .t. )
    VerifIND( "CondARQ" )

    #ifdef DBF_NTX
      set index to CondIND1
    #endif
  endif

  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )

    #ifdef DBF_NTX
      set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
    #endif
  endif

  if NetUse( "GrupARQ", .t. )
    VerifIND( "GrupARQ" )

    #ifdef DBF_NTX
      set index to GrupIND1, GrupIND2
    #endif
  endif

  if NetUse( "SubGARQ", .t. )
    VerifIND( "SubGARQ" )

    #ifdef DBF_NTX
      set index to SubGIND1, SubGIND2, SubGIND3
    #endif
  endif

  //  Define Intervalo
  Janela ( 08, 12, 15, 70, mensagem( 'Janela', 'PrinUltF', .f. ), .f.)
  Mensagem( 'Prod', 'PrinUltF' )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,13 say '     Emissão Inicial             Emissão Final'
  @ 11,13 say '     Produto Inicial             Produto Final'
  @ 12,13 say '  Fornecedor Inicial          Fornecedor Final'
  @ 13,13 say '       Grupo Inicial               Grupo Final'
  @ 14,13 say '    Subgrupo Inicial            Subgrupo Final'
  
  select GrupARQ
  set order to 1
  dbgotop () 
  nGrupIni := val( Grup )
  dbgobottom ()
  nGrupFin := val( Grup )

  select FornARQ
  set order to 1
  dbgotop () 
  nFornIni := val( Forn )
  dbgobottom ()
  nFornFin := val( Forn )

  select ProdARQ
  set order to 1
  dbgotop ()
  nProdIni := val( Prod )
  dbgobottom ()
  nProdFin := val( Prod )

  dEmisIni := ctod( '01/01/1900')
  dEmisFin := ctod( '31/12/2015')
  nSubGIni := 000
  nSubGFin := 999999
  cProd    := space(06)

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,34 get dEmisIni           pict '99/99/9999'
  @ 10,60 get dEmisFin           pict '99/99/999'     valid dEmisFin >= dEmisIni
  @ 11,34 get nProdIni           pict '999999'     valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdIni" )  
  @ 11,60 get nProdFin           pict '999999'     valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdFin" ) .and. nProdFin >= nProdIni     
  @ 12,34 get nFornIni           pict '999999'     valid ValidForn( 99, 99, "ProdARQ", "nFornIni" )       
  @ 12,60 get nFornFin           pict '999999'     valid ValidForn( 99, 99, "ProdARQ", "nFornFin" ) .and. nFornFin >= nFornIni
  @ 13,34 get nGrupIni           pict '999999'      valid ValidARQ( 99, 99, "ProdARQ", "Código", "Grup", "Descrição", "Nome", "Grup", "nGrupIni", .t., 6, "Consulta de Grupos", "GrupARQ", 30 )
  @ 13,60 get nGrupFin           pict '999999'      valid ValidARQ( 99, 99, "ProdARQ", "Código", "Grup", "Descrição", "Nome", "Grup", "nGrupFin", .t., 6, "Consulta de Grupos", "GrupARQ", 30 ) .and. nGrupFin >= nGrupIni
  @ 14,34 get nSubgIni           pict '999999'  
  @ 14,60 get nSubgFin           pict '999999'      valid nSubgFin >= nSubgIni
  read

  if lastkey() == K_ESC
    select ProdARQ
    close
    select FornARQ
    close
    select NEntARQ
    close
    select INEnARQ
    close
    select CondARQ
    close
    select GrupARQ
    close
    select SubGARQ
    close
    return NIL
  endif
  
  Aguarde ()

  nPag     := 1
  nLin     := 0
  cArqu2   := cArqu2 + "." + strzero( nPag, 3 )

  cGrupIni := strzero( nGrupIni, 6 )
  cGrupFin := strzero( nGrupFin, 6 )
  cSubgIni := strzero( nSubGIni, 6 )
  cSubgFin := strzero( nSubGFin, 6 )
  cProdIni := strzero( nProdIni, 6 )
  cProdFin := strzero( nProdFin, 6 )
  cFornIni := strzero( nFornIni, 6 )
  cFornFin := strzero( nFornFin, 6 )
  lInicio  := .t.

  select NEntARQ 
  set order    to 1
  set filter   to Emis >= dEmisIni .and. Emis <= dEmisFin
  set relation to Forn into FornARQ, to Cond into CondARQ
  
  select ProdARQ  
  set order  to 1
  dbseek( cProdIni, .t. )
  do while Prod >= cProdIni .and. Prod <= cProdFin .and. !eof ()
    if Forn >= cFornIni .and. Forn <= cFornFin .and.;
       Grup >= cGrupIni .and. Grup <= cGrupFin .and.;
       SubG >= cSubGIni .and. SubG <= cSubGFin
      
      cProd := Prod
      aForn := {}
    
      select NEntARQ 
      dbgobottom ()
      do while !bof()
        cNota := Nota
        cForn := Forn
        dEmis := Emis
        cCond := Cond
      
        do case 
          case Conta == 'C'
            cFrete := 'CIF'
          case Conta == 'F'
            cFrete := 'FOB'
          otherwise  
            cFrete := ''
        endcase    
      
        select INEnARQ
        set order to 1
        dbseek( cForn + cNota, .t. )
        do while Nota == cNota .and. Forn == cForn .and. !eof ()
          if Prod == cProd
            aadd( aForn, { cForn, FornARQ->Nome, FornARQ->Fone, NEntARQ->Emis,;
                           CondARQ->Nome, Qtde, PrecoCusto, cFrete } )
          endif  
      
          dbskip ()
        enddo
      
        select NEntARQ
        dbskip(-1)
      enddo
    
      select ProdARQ

      for nU := 1 to len( aForn )
        cForn       := aForn[ nU, 1 ]
        cNomeForn   := aForn[ nU, 2 ]
        cFone       := aForn[ nU, 3 ]
        dEmis       := aForn[ nU, 4 ]
        cNomeCond   := aForn[ nU, 5 ]
        nQtde       := aForn[ nU, 6 ]
        nPrecoCusto := aForn[ nU, 7 ]
        cFrete      := aForn[ nU, 8 ]
      
        if lInicio
          set printer to ( cArqu2 )
          set device  to printer
          set printer on
        
          lInicio := .f.
        endif
        
        if nLin == 0
          Cabecalho ( 'Estoque com Fornecedores', 132, 2 )
          CabUltF ()
        endif
      
        if nU == 1 .or. nLin == 4  
          @ nLin,001 say cProd
          @ nLin,008 say Nome                 pict '@S28'
          if EmprARQ->Inteira == 'X'
            @ nLin,037 say Qtde               pict '@E 9999999999'
          else  
            @ nLin,037 say Qtde               pict '@E 999999.999'
          endif  
          @ nLin,049 say EstqMini             pict '@E 99999.9'
        endif  

        @ nLin,058 say cForn              pict '999999'
        @ nLin,065 say cNomeForn          pict '@S13'
        @ nLin,084 say dEmis              pict '99/99/9999'
        @ nLin,095 say cNomeCond          pict '@S13'     
        @ nLin,109 say cFrete        
        if EmprARQ->Inteira == 'X'
          @ nLin,115 say nQtde            pict '@E 99999999'
        else  
          @ nLin,115 say nQtde            pict '@E 99,999.9'
        endif  
        @ nLin,124 say nPrecoCusto        pict PictPreco(8)
        nLin ++
    
        if nLin >= pLimite
          Rodape(132) 

          cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
          cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

          set printer to ( cArqu2 )
          set printer on
        endif
      next
    
      if len( aForn ) > 0   
        nLin ++
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
      replace Titu       with 'Relatório de Estoque com Fornecedores'
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 132
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
    close
  endif

  select ProdARQ
  close
  select FornARQ
  close
  select NEntARQ
  close
  select INEnARQ
  close
  select CondARQ
  close
  select GrupARQ
  close
  select SubGARQ
  close
return NIL

function CabUltF ()
  @ 02,01 say 'Produto                             Estq.Atual Estq.Min. Fornecedores              Emissão    Cond.Pgto.    Frete    Qtde.  P.Custo '

  nLin := 04
return NIL

//
// Imprime etiqueta dos produtos
//
function PrinEtProd ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "GrupARQ", .t. )
    VerifIND( "GrupARQ" )

    #ifdef DBF_NTX
      set index to GrupIND1, GrupIND2
    #endif
  endif

  if NetUse( "SubGARQ", .t. )
    VerifIND( "SubGARQ" )

    #ifdef DBF_NTX
      set index to SubGIND1, SubGIND2, SubGIND3
    #endif
  endif

  if NetUse( "FornARQ", .t. )
    VerifIND( "FornARQ" )

    #ifdef DBF_NTX
      set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
    #endif
  endif

  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )

    #ifdef DBF_NTX
      set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
    #endif
  endif

  if NetUse( "CampARQ", .t. )
    VerifIND( "CampARQ" )
  
    #ifdef DBF_NTX
      set index to CampIND1, CampIND2
    #endif
  endif

  if NetUse( "EtiqARQ", .t. )
    VerifIND( "EtiqARQ" )
  
    #ifdef DBF_NTX
      set index to EtiqIND1
    #endif
  endif

  Janela ( 05, 19, 13, 70, mensagem( 'LEVE', 'PrinProd', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 07,20 say '   Produto Inicial           Produto Final'
  @ 08,20 say 'Fornecedor Inicial        Fornecedor Final'
  @ 09,20 say '     Grupo Inicial             Grupo Final'
  @ 10,20 say '  Subgrupo Inicial          Subgrupo Final'
  @ 11,20 say ' Qtde. de Cópia(s)' 
  @ 12,20 say '     Qtde. Estoque' 
  
  setcolor( CorCampo )
  @ 12,39 say ' Sim ' 
  @ 12,45 say ' Não ' 

  setcolor( CorAltKC )
  @ 12,40 say 'S' 
  @ 12,46 say 'N' 

  select FornARQ
  set order  to 1
  dbgotop ()
  nFornIni := val( Forn )
  dbgobottom ()
  nFornFin := val( Forn )

  select GrupARQ
  set order  to 1
  dbgotop ()
  nGrupIni := val( Grup )
  dbgobottom ()
  nGrupFin := val( Grup )

  select ProdARQ
  set order  to 1
  dbgotop ()
  nProdIni := val( Prod )
  dbgobottom ()
  nProdFin := val( Prod )
  cProd    := space(06)
  nSubgIni := 000
  nSubgFin := 999999
  nQtdeCop := 1
 
  setcolor ( CorJanel + ',' + CorCampo )
  @ 07,39 get nProdIni  pict '999999'        valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdIni" )  
  @ 07,63 get nProdFin  pict '999999'        valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdFin" ) .and. nProdFin >= nProdIni
  @ 08,39 get nFornIni  pict '999999'        valid ValidForn( 99, 99, "ProdARQ", "nFornIni" )       
  @ 08,63 get nFornFin  pict '999999'        valid ValidForn( 99, 99, "ProdARQ", "nFornFin" ) .and. nFornFin >= nFornIni
  @ 09,39 get nGrupIni  pict '999999'         valid ValidARQ( 99, 99, "ProdARQ", "Código", "Grup", "Descrição", "Nome", "Grup", "nGrupIni", .t., 6, "Consulta de Grupos", "GrupARQ", 30 )  
  @ 09,63 get nGrupFin  pict '999999'         valid ValidARQ( 99, 99, "ProdARQ", "Código", "Grup", "Descrição", "Nome", "Grup", "nGrupFin", .t., 6, "Consulta de Grupos", "GrupARQ", 30 ) .and. nGrupFin >= nGrupIni 
  @ 10,39 get nSubgIni  pict '999999'  
  @ 10,63 get nSubgFin  pict '999999'         valid nSubgFin >= nSubgIni
  @ 11,39 get nQtdeCop  pict '9999'        valid nQtdeCop > 0
  read

  if lastkey () == K_ESC
    select ProdARQ
    close
    select GrupARQ
    close
    select SubGARQ
    close
    select FornARQ
    close
    select CampARQ
    close
    select EtiqARQ
    close
    return NIL
  endif
  
  lEstq := ConfLine( 12, 39, 2 )

  if lastkey () == K_ESC
    select ProdARQ
    close
    select GrupARQ
    close
    select SubGARQ
    close
    select FornARQ
    close
    select CampARQ
    close
    select EtiqARQ
    close
    return NIL
  endif
  
  cFornIni  := strzero( nFornIni, 6 )
  cFornFin  := strzero( nFornFin, 6 )
  cProdIni  := strzero( nProdIni, 6 )
  cProdFin  := strzero( nProdFin, 6 )
  cGrupIni  := strzero( nGrupIni, 6 )
  cGrupFin  := strzero( nGrupFin, 6 )
  cSubGIni  := strzero( nSubGIni, 6 )
  cSubGFin  := strzero( nSubGFin, 6 )
  nEtiqProd := EmprARQ->EtiqProd
  
  select EtiqARQ
  set order to 1
  dbseek( nEtiqProd, .f. )

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
    Alerta( mensagem( 'Alerta', 'PrinEtiq', .f. ) )
    select ProdARQ
    close
    select GrupARQ
    close
    select SubGARQ
    close
    select FornARQ
    close
    select CampARQ
    close
    select EtiqARQ
    close
    return NIL
  endif
  
  cTexto     := Layout
  nLin       := 1
  nLargura   := Tama
  nEspa      := Espa
  nComp      := Comp
  cQtLin     := QtLinha
  nColunas   := Colunas
  nDistancia := Distancia
  nSalto     := Salto
  aLayout    := {}
  
  cQtLin     := mlcount( cTexto, nLargura + 1 )

  for nK := 1 to cQtLin
    cLinha := memoline( cTexto, nLargura + 1, nK )

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

  if !TestPrint( EmprARQ->Produto )
    select ProdARQ
    close
    select GrupARQ
    close
    select SubGARQ
    close
    select FornARQ
    close
    select CampARQ
    close
    select EtiqARQ
    close
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
  
  nLinIni := aLayout[ 1, 1 ]
  nLinFin := aLayout[ len( aLayout ), 1 ]
  xLin    := 0
  nCopia  := 0
   
  select ProdARQ
  set order    to 1
  set filter   to Prod >= cProdIni .and. Prod <= cProdFin .and.;
                  Forn >= cFornIni .and. Forn <= cFornFin .and.;
                  SubG >= cSubgIni .and. SubG <= cSubgFin .and.;
                  Grup >= cGrupIni .and. Grup <= cGrupFin
  set relation to Grup into GrupARQ, SubG into SubGARQ                
  dbgotop ()
  do while !eof ()
    for nH := 1 to nColunas
      s       := strzero( nH, 2 )
      aEtiq&s := {}
    next
    
    if nCopia == 0   
      if lEstq
        if ProdARQ->Qtde <= 0
          dbskip()
          loop
        endif  
      
        nCopia := ProdARQ->Qtde
      else      
        nCopia := nQtdeCop
      endif     
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
        do while !eof()
          dbskip()  

          if lEstq  
            if ProdARQ->Qtde <= 0
              loop
            endif  
      
            nCopia := ProdARQ->Qtde
          else  
            nCopia := nQtdeCop
          endif  
          exit
        enddo
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
            nCol += ( ( ( nLargura + nDistancia ) * ( nA - 1 ) ) + 1 )
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

  @ nLin,00 say chr(27) + '@'

  set printer to
  set printer off
  set device  to screen
  
  select ProdARQ
  close
  select GrupARQ
  close
  select SubGARQ
  close
  select FornARQ
  close
  select CampARQ
  close
  select EtiqARQ
  close
return NIL

//
// Imprime Dados dos Produtos
//
function PrinTotaE ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "FornARQ", .t. )
    VerifIND( "FornARQ" )

    #ifdef DBF_NTX
      set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
    #endif
  endif

  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )
 
    #ifdef DBF_NTX
      set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
    #endif
  endif

  if NetUse( "GrupARQ", .t. )
    VerifIND( "GrupARQ" )

    #ifdef DBF_NTX
      set index to GrupIND1, GrupIND2
    #endif
  endif

  if NetUse( "SubGARQ", .t. )
    VerifIND( "SubGARQ" )

    #ifdef DBF_NTX
      set index to SubGIND1, SubGIND2, SubGIND3
    #endif
  endif

  //  Define Intervalo
  Janela ( 06, 15, 14, 70, mensagem( 'Janela','PrinProd', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,17 say '      Produto Inicial           Produto Final'
  @ 09,17 say '   Fornecedor Inicial        Fornecedor Final'
  @ 10,17 say '        Grupo Inicial             Grupo Final'
  @ 11,17 say '     Subgrupo Inicial          Subgrupo Final'
  @ 13,17 say '           Quantidade '
  
  setcolor( CorCampo )
  @ 13,39 say ' Todas   '
  @ 13,49 say ' Falta   '
  @ 13,59 say ' Estoque '
  
  setcolor( CorAltKC )
  @ 13,40 say 'T'
  @ 13,50 say 'F'
  @ 13,60 say 'E'

  select GrupARQ
  set order  to 1
  dbgotop ()
  nGrupIni := val( Grup )
  dbgobottom ()
  nGrupFin := val( Grup )

  select FornARQ
  set order to 1
  dbgotop () 
  nFornIni := val( Forn )
  dbgobottom ()
  nFornFin := val( Forn )

  select ProdARQ
  set order to 1
  dbgotop ()
  nProdIni := val( Prod )
  dbgobottom ()
  nProdFin := val( Prod )
  nSubgIni := 000
  nSubgFin := 999999
  cProd    := space(6)

  @ 08,39 get nProdIni  pict '999999'       valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdIni" )  
  @ 08,63 get nProdFin  pict '999999'       valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdFin" ) .and. nProdFin >= nProdIni
  @ 09,39 get nFornIni  pict '999999'       valid ValidForn( 99, 99, "ProdARQ", "nFornIni" )       
  @ 09,63 get nFornFin  pict '999999'       valid ValidForn( 99, 99, "ProdARQ", "nFornFin" ) .and. nFornFin >= nFornIni
  @ 10,39 get nGrupIni  pict '999999'        valid ValidARQ( 99, 99, "ProdARQ", "Código", "Grup", "Descrição", "Nome", "Grup", "nGrupIni", .t., 6, "Consulta de Grupos", "GrupARQ", 30 )  
  @ 10,63 get nGrupFin  pict '999999'        valid ValidARQ( 99, 99, "ProdARQ", "Código", "Grup", "Descrição", "Nome", "Grup", "nGrupFin", .t., 6, "Consulta de Grupos", "GrupARQ", 30 ) .and. nGrupFin >= nGrupIni 
  @ 11,39 get nSubgIni  pict '999999'  
  @ 11,63 get nSubgFin  pict '999999'        valid nSubgFin >= nSubgIni
  read

  if lastkey() == K_ESC
    select ProdARQ
    close
    select GrupARQ
    close
    select SubGARQ
    close
    select FornARQ
    close
    return NIL
  endif
  
  aOpc := {}

  aadd( aOpc, { ' Todas   ', 2, 'T', 13, 39, "Seleção de todos as Quantidades." } )
  aadd( aOpc, { ' Falta   ', 2, 'F', 13, 49, "Seleção de Produtos em Falta." } )
  aadd( aOpc, { ' Estoque ', 2, 'E', 13, 59, "Seleção de Produtos em Estoque." } )

  nOpca := HCHOICE( aOpc, 3, 3 )

  Aguarde ()
  
  nPag       := 1
  nLin       := 0
  cArqu2     := cArqu2 + "." + strzero( nPag, 3 )

  cGrupIni   := strzero( nGrupIni, 6 )
  cGrupFin   := strzero( nGrupFin, 6 )
  cSubgIni   := strzero( nSubGIni, 6 )
  cSubgFin   := strzero( nSubGFin, 6 )
  cProdIni   := strzero( nProdIni, 6 )
  cProdFin   := strzero( nProdFin, 6 )
  cFornIni   := strzero( nFornIni, 6 )
  cFornFin   := strzero( nFornFin, 6 )
  lInicio    := .t.
  
  nGrupCusto := nGrupVenda := nGrupQtde  := 0
  nSubGCusto := nSubGVenda := nSubGQtde  := 0
  nProdCusto := nProdVenda := nProdQtde  := 0
  cGrupAnt   := space(06)
  cSubGAnt   := space(06)
  
  select ProdARQ 
  do case   
    case EmprARQ->ConsProd == 1 .or. EmprARQ->ConsProd == 3 .or. EmprARQ->ConsProd == 4
      set order to 2
    case EmprARQ->ConsProd == 2
      set order to 3
  endcase    
  set relation to Grup into GrupARQ, to Grup+SubG into SubGARQ
  dbgotop ()
  do while !eof()
    if Prod >= cProdIni .and. Prod <= cProdFin .and.;
      Forn  >= cFornIni .and. Forn <= cFornFin .and.;
      val(SubG)  >= nSubgIni .and. val(SubG) <= nSubgFin .and.;
      Grup  >= cGrupIni .and. Grup <= cGrupFin

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
        Cabecalho ( 'Valor do Estoque', 132, 2 )
        CabTotal ()
      endif

      pPrecoVenda := PrecoVenda * Qtde 
      pPrecoCusto := PrecoCusto * Qtde 
    
      do case
        case EmprARQ->ConsProd == 1 .or. EmprARQ->ConsProd == 3 .or. EmprARQ->ConsProd == 4
          @ nLin, 01 say Prod
          @ nLin, 08 say Nome                    pict '@S38'
          if EmprARQ->Inteira == 'X'
            @ nLin, 47 say Qtde                  pict '@E 9999999999' 
          else  
            @ nLin, 47 say Qtde                  pict '@E 999999.999' 
          endif  
          @ nLin, 60 say PrecoCusto              pict PictPreco(10)
          @ nLin, 73 say PrecoVenda              pict PictPreco(10)
          @ nLin, 86 say pPrecoCusto             pict PictPreco(10)
          @ nLin, 99 say pPrecoVenda             pict PictPreco(10)
        case EmprARQ->ConsProd == 2 
          if cGrupAnt != Grup
            if cGrupAnt != space(06)
              if ( nLin + 4 ) >= pLimite
                Rodape(132)
 
                cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
                cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

                set printer to ( cArqu2 )
                set printer on
               
                Cabecalho ( 'Valor do Estoque', 132, 2 )
                CabTotal ()
     
                @ nLin,00 say cNoGrAnt + ' - ' + cGrupAnt
                nLin ++
                @ nLin,02 say cNoSuAnt + ' - ' + cSubGAnt
              endif

              nLin ++
              @ nLin,035 say 'Total SubGrupo'
              if EmprARQ->Inteira == 'X'
                @ nLin,050 say nSubGQtde              pict '@E 9999999999' 
              else
                @ nLin,050 say nSubGQtde              pict '@E 999999.999' 
              endif
              @ nLin,089 say nSubGCusto             pict '@E 999,999.99'
              @ nLin,102 say nSubGVenda             pict '@E 999,999.99'
              nLin ++
              @ nLin,038 say 'Total Grupo'
              if EmprARQ->Inteira == 'X'
                @ nLin,050 say nGrupQtde            pict '@E 9999999999' 
              else              
                @ nLin,050 say nGrupQtde            pict '@E 999999.999' 
              endif             
              @ nLin,089 say nGrupCusto             pict '@E 999,999.99'
              @ nLin,102 say nGrupVenda             pict '@E 999,999.99'

              nLin       += 2
              nGrupCusto := nGrupVenda := nGrupQtde  := 0
              nSubGCusto := nSubGVenda := nSubGQtde  := 0
              cSubGAnt   := space(06)
            endif  
        
            @ nLin,00 say GrupARQ->Nome + ' - ' + Grup
 
            cGrupAnt := Grup
            cNoGrAnt := GrupARQ->Nome
            nLin     ++
          endif

          if cSubGAnt != SubG
            if cSubGAnt != space(06)
              nLin ++
              @ nLin,035 say 'Total SubGrupo'
              if EmprARQ->Inteira == 'X'
                @ nLin,050 say nSubGQtde            pict '@E 9999999999' 
              else
                @ nLin,050 say nSubGQtde            pict '@E 999999.999' 
              endif
              @ nLin,089 say nSubGCusto             pict '@E 999,999.99'
              @ nLin,102 say nSubGVenda             pict '@E 999,999.99'
              nLin       += 2
              nSubGCusto := nSubGVenda := nSubGQtde  := 0

              if nLin >= pLimite
                Rodape(132)

                cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
                cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

                set printer to ( cArqu2 )
                set printer on

                cGrup := cGrupAnt
                
                Cabecalho ( 'Valor do Estoque', 132, 2 )
                CabTotal ()
               
                cGrupAnt := cGrup

                @ nLin,00 say cNoGrAnt + ' - ' + cGrupAnt
                nLin ++
              endif
            endif
          
            @ nLin,02 say SubGARQ->Nome + ' - ' + SubG
          
            cSubGAnt := SubG
            cNoSuAnt := SubGARQ->Nome
            nLin     ++
          endif

          @ nLin,004 say Prod
          @ nLin,011 say Nome                    pict '@S38'
          if EmprARQ->Inteira == 'X'
            @ nLin,050 say Qtde                  pict '@E 9999999999' 
          else  
            @ nLin,050 say Qtde                  pict '@E 999999.999' 
          endif  
          @ nLin,063 say PrecoCusto              pict PictPreco(10)
          @ nLin,076 say PrecoVenda              pict PictPreco(10)
          @ nLin,089 say pPrecoCusto             pict PictPreco(10)
          @ nLin,102 say pPrecoVenda             pict PictPreco(10)
      endcase

      nLin       ++
      nGrupVenda += pPrecoVenda
      nGrupCusto += pPrecoCusto
      nGrupQtde  += Qtde
      nSubGVenda += pPrecoVenda
      nSubGCusto += pPrecoCusto
      nSubGQtde  += Qtde
      nProdVenda += pPrecoVenda
      nProdCusto += pPrecoCusto
      nProdQtde  += Qtde

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
    nLin ++
    do case
      case EmprARQ->ConsProd == 1 .or. EmprARQ->ConsProd == 3 .or. EmprARQ->ConsProd == 4
        @ nLin, 35 say 'Total Geral'
        if EmprARQ->Inteira == 'X'
          @ nLin, 47 say nProdQtde            pict '@E 9999999999' 
        else  
          @ nLin, 47 say nProdQtde            pict '@E 999999.999' 
        endif  
        @ nLin, 86 say nProdCusto             pict '@E 999,999.99'
        @ nLin, 99 say nProdVenda             pict '@E 999,999.99'
      case EmprARQ->ConsProd == 2
        @ nLin,038 say 'Total Grupo'
        if EmprARQ->Inteira == 'X'
          @ nLin,050 say nGrupQtde            pict '@E 9999999999' 
        else
          @ nLin,050 say nGrupQtde            pict '@E 999999.999' 
        endif
        @ nLin,089 say nGrupCusto             pict '@E 999,999.99'
        @ nLin,102 say nGrupVenda             pict '@E 999,999.99'
        nLin ++
        @ nLin,035 say 'Total SubGrupo'
        if EmprARQ->Inteira == 'X'
          @ nLin,050 say nGrupQtde            pict '@E 9999999999' 
        else
          @ nLin,050 say nSubGQtde            pict '@E 999999.999' 
        endif
        @ nLin,089 say nSubGCusto             pict '@E 999,999.99'
        @ nLin,102 say nSubGVenda             pict '@E 999,999.99'
        nLin += 2    
        @ nLin,035 say '   Total Geral'
        if EmprARQ->Inteira == 'X' 
          @ nLin,050 say nProdQtde            pict '@E 9999999999' 
        else  
          @ nLin,050 say nGrupQtde            pict '@E 999999.999' 
        endif  
        @ nLin,089 say nProdCusto             pict '@E 999,999.99'
        @ nLin,102 say nProdVenda             pict '@E 999,999.99'
    endcase    
    Rodape(132)
  endif  
  
  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 132 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Relatório do Valor do Estoque"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 132
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
    close
  endif

  select ProdARQ
  close
  select GrupARQ
  close
  select SubGARQ
  close
  select FornARQ
  close
return NIL

function CabTotal()
  do case
    case EmprARQ->ConsProd == 1 .or. EmprARQ->ConsProd == 3 .or. EmprARQ->ConsProd == 4
      @ 02,01 say 'Cod Descrição                                     Qtde.  Preço Custo  Preço Venda  Total Custo  Total Venda'

      nLin := 04
    case EmprARQ->ConsProd == 2
      @ 02,00 say 'Grupo'
      @ 03,02 say 'SubGrupo'
      @ 04,04 say 'Cod Descrição                                     Qtde.  Preço Custo  Preço Venda  Total Custo  Total Venda'
      nLin := 06
  endcase    
        
  cGrupAnt := space(03)
  cSubGAnt := space(03)
return NIL

//
// Imprime Etiqueta dos Produtos
//
function PrinBarra()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "GrupARQ", .t. )
    VerifIND( "GrupARQ" )

    #ifdef DBF_NTX
      set index to GrupIND1, GrupIND2
    #endif
  endif

  if NetUse( "SubGARQ", .t. )
    VerifIND( "SubGARQ" )

    #ifdef DBF_NTX
      set index to SubGIND1, SubGIND2, SubGIND3
    #endif
  endif

  if NetUse( "FornARQ", .t. )
    VerifIND( "FornARQ" )
  
    #ifdef DBF_NTX
      set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
    #endif
  endif

  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )

    #ifdef DBF_NTX
      set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
    #endif
  endif

  if NetUse( "CampARQ", .t. )
    VerifIND( "CampARQ" )
  
    #ifdef DBF_NTX
      set index to CampIND1, CampIND2
    #endif
  endif

  if NetUse( "BarrARQ", .t. )
    VerifIND( "BarrARQ" )
  
    #ifdef DBF_NTX
      set index to BarrIND1
    #endif
  endif

  Janela ( 05, 19, 13, 70, mensagem( 'Janela', 'PrinProd', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 07,20 say '   Produto Inicial           Produto Final'
  @ 08,20 say 'Fornecedor Inicial        Fornecedor Final'
  @ 09,20 say '     Grupo Inicial             Grupo Final'
  @ 10,20 say '  Subgrupo Inicial          Subgrupo Final'
  @ 11,20 say ' Qtde. de Cópia(s)' 
  @ 12,20 say '     Qtde. Estoque' 
  
  setcolor( CorCampo )
  @ 12,39 say ' Sim ' 
  @ 12,45 say ' Não ' 

  setcolor( CorAltKC )
  @ 12,40 say 'S' 
  @ 12,46 say 'N' 

  select FornARQ
  set order  to 1
  dbgotop ()
  nFornIni := val( Forn )
  dbgobottom ()
  nFornFin := val( Forn )

  select GrupARQ
  set order  to 1
  dbgotop ()
  nGrupIni := val( Grup )
  dbgobottom ()
  nGrupFin := val( Grup )

  select ProdARQ
  set order  to 1
  dbgotop ()
  nProdIni := val( Prod )
  dbgobottom ()
  nProdFin := val( Prod )
  cProd    := space(06)
  nSubgIni := 000
  nSubgFin := 999999
  nQtdeCop := 1
 
  setcolor ( CorJanel + ',' + CorCampo )
  @ 07,39 get nProdIni  pict '999999'        valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdIni" )  
  @ 07,63 get nProdFin  pict '999999'        valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdFin" ) .and. nProdFin >= nProdIni
  @ 08,39 get nFornIni  pict '999999'        valid ValidForn( 99, 99, "ProdARQ", "nFornIni" )       
  @ 08,63 get nFornFin  pict '999999'        valid ValidForn( 99, 99, "ProdARQ", "nFornFin" ) .and. nFornFin >= nFornIni
  @ 09,39 get nGrupIni  pict '999999'        valid ValidARQ( 99, 99, "ProdARQ", "Código", "Grup", "Descrição", "Nome", "Grup", "nGrupIni", .t., 6, "Consulta de Grupos", "GrupARQ", 30 )  
  @ 09,63 get nGrupFin  pict '999999'        valid ValidARQ( 99, 99, "ProdARQ", "Código", "Grup", "Descrição", "Nome", "Grup", "nGrupFin", .t., 6, "Consulta de Grupos", "GrupARQ", 30 ) .and. nGrupFin >= nGrupIni 
  @ 10,39 get nSubgIni  pict '999999'  
  @ 10,63 get nSubgFin  pict '999999'        valid nSubgFin >= nSubgIni
  @ 11,39 get nQtdeCop  pict '999999'        valid nQtdeCop > 0
  read

  if lastkey () == K_ESC
    select ProdARQ
    close
    select GrupARQ
    close
    select SubGARQ
    close
    select FornARQ
    close
    select CampARQ
    close
    select BarrARQ
    close
    return NIL
  endif
  
  lEstq := ConfLine( 12, 39, 2 )

  if lastkey () == K_ESC
    select ProdARQ
    close
    select GrupARQ
    close
    select SubGARQ
    close
    select FornARQ
    close
    select CampARQ
    close
    select BarrARQ
    close
    return NIL
  endif
  
  cFornIni  := strzero( nFornIni, 6 )
  cFornFin  := strzero( nFornFin, 6 )
  cProdIni  := strzero( nProdIni, 6 )
  cProdFin  := strzero( nProdFin, 6 )
  cGrupIni  := strzero( nGrupIni, 6 )
  cGrupFin  := strzero( nGrupFin, 6 )
  cSubGIni  := strzero( nSubGIni, 6 )
  cSubGFin  := strzero( nSubGFin, 6 )
  nBarrProd := EmprARQ->BarrProd
  
  select BarrARQ
  set order to 1
  dbseek( nBarrProd, .f. )

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
    Alerta( 'Alerta', 'PrinEtiq', .f. )
    select ProdARQ
    close
    select GrupARQ
    close
    select SubGARQ
    close
    select FornARQ
    close
    select CampARQ
    close
    select BarrARQ
    close
    return NIL
  endif
  
  cTexto  := Layout
  nLin    := 1
  cComa   := Coma
  cPort   := Port
  aLayout := {}
  
  xLin    := 0
  nCopia  := 0
  
  set printer to cPort
  set device  to printer
  set printer on
   
  select ProdARQ
  set order    to 1
  set filter   to Prod >= cProdIni .and. Prod <= cProdFin .and.;
                  Forn >= cFornIni .and. Forn <= cFornFin .and.;
                  SubG >= cSubgIni .and. SubG <= cSubgFin .and.;
                  Grup >= cGrupIni .and. Grup <= cGrupFin
  set relation to Grup into GrupARQ, SubG into SubGARQ                
  dbgotop ()
  do while !eof ()
    @ 0,0 say cTexto
  
  
    dbskip()
  enddo

  @ nLin,00 say chr(27) + '@'

  set printer to
  set printer off
  set device  to screen
  
  select ProdARQ
  close
  select GrupARQ
  close
  select SubGARQ
  close
  select FornARQ
  close
  select CampARQ
  close
  select BarrARQ
  close
return NIL