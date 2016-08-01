//  Leve, Empresas
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

function Empr( xAlte )
  local GetList := {}
if SemAcesso( 'Empr' )
  return NIL
endif  

//  Variaveis de Entrada para Empresa
nEmpr     := nCEP      := 0
cUF       := space(02)
cEmpr     := space(04)
cDireto   := space(08)
cBairro   := cFone     := cFax      := space(14)
cCida     := space(30)
cRazao    := space(45) 
cNome     := space(25)
cEnde     := space(34)
cCGC      := space(18)
cInscEstd := space(20)

//  Tela Empresa
Janela ( 04, 06, 18, 76, mensagem( 'Janela', 'Empr', .f. ), .t. )

setcolor ( CorJanel )
@ 06,08 say '      Codigo'
@ 06,50 say 'Diretório'
@ 08,08 say '        Nome'
@ 09,08 say 'Razão Social'

@ 11,08 say '    Endereço'
@ 11,56 say 'CEP'
@ 12,08 say '      Cidade'
@ 12,57 say 'UF'
@ 13,08 say '      Bairro'
@ 13,36 say 'Fone'
@ 13,56 say 'Fax'

@ 15,08 say '  Insc. CNPJ'
@ 15,41 say 'Insc. Estad.'

MostOpcao( 17, 08, 20, 52, 65 ) 
tEmpr := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Empresa
select EmprARQ
set order to 1
if !xAlte
  dbgobottom ()
endif  
do while .t.
  Mensagem ( 'Empr', 'Janela' )

  select EmprARQ
  set order to 1

  restscreen( 00, 00, 23, 79, tEmpr )
  cStat := space(04)

  MostEmpr()
    
  if Demo()
    exit
  endif  

if rlock()
  replace comissao with 2
  dbunlock()
endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostEmpr'
  cAjuda   := 'Empr'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  if xAlte
    @ 06,21 get nEmpr                  pict '999999'
    read
  else
    dbgobottom ()
  
    nEmpr := val( Empr ) + 1
  endif  
    
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. nEmpr == 0
    exit
  endif

  cEmpr := strzero( nEmpr, 6 )
  
  setcolor ( CorCampo )
  @ 06,21 say cEmpr

  //  Verificar existencia do Empresa para Incluir ou Alterar
  select EmprARQ
  set order to 1
  dbseek( cEmpr, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif

  Mensagem ('Empr', cStat )
  
  MostEmpr()
  EntrEmpr()

  Confirmar ( 17, 08, 20, 52, 65, 3 )

  if cStat == 'excl'
    cDir := alltrim( Direto )
  
    if ExclRegi ()
      aARQ := directory( cCaminho + HB_OSpathseparator() + cDir + HB_OSpathseparator() + "*.*" ) 

      Janela( 09, 28, 12, 51, mensagem( 'Janela', 'ExclEmpr', .f. ), .f. )
      setcolor( CorJanel )
      @ 11,30 say 'Arquivo'
      setcolor( CorCampo )
      
      for nH := 1 to len( aARQ )
        ferase( aARQ[ nH, 1 ] )
        @ 11,38 say space(12) 
        @ 11,38 say aARQ[ nH, 1 ]              
      next  
      
      dirremove( cCaminho + HB_OSpathseparator() + cDir )
    endif  
  endif
 
  if cStat == 'incl'
    select EmprARQ
    set order to 1
    if AdiReg()
      if RegLock()
        replace Empr       with cEmpr
        replace Direto     with cDireto
        replace Saver      with 4
        replace Dupl       with 1
        replace Comissao   with 1
        replace NoPr       with 1
        replace NFis       with 1
        replace Carne      with 1
        replace TipoOS     with 1
        replace EtiqAgen   with 1
        replace EtiqClie   with 1
        replace EtiqProd   with 1
        replace CopiaReci  with 1 
        replace CopiaNota  with 1 
        replace CopiaOS    with 1 
        replace CopiaOpro  with 1
        replace ConsProd   with 1
        replace PictPreco  with "@E 999,999,999.99" 
        replace Horario    with "X"
        replace CodBarra   with "X"
        replace Juro       with "X"
        replace EmprPedi   with "X"
        replace Dica       with "X"
        replace ReciboTxt  with "X"
        replace InclClie   with 'J'
        replace Mensagem   with 'A sua preferência é a razão de nossa existência'
        replace ReciTxt1   with 'Referente a COMPRA em [Emis] com vencimento para [Vcto] que dou(damos)'
        replace ReciTxt2   with 'plena e geral quitação'

        replace Recibo     with 1
        replace Pedido     with 1
        replace Relatorio  with 1
        replace NotaFiscal with 1
        replace Duplicata  with 1
        replace Cheque     with 1
        replace Bloqueto   with 1
        replace Produto    with 1
        replace Cliente    with 1
        replace Impr       with 'X'
        replace Idio       with '01'
        dbunlock ()
      endif
    endif
    
    aAcesso := {}

    select UsMeARQ
    set order to 1
    dbseek( cUsuario, .f. )
    do while Usua == cUsuario .and. !eof()
      aadd( aAcesso, { Usua, cEmpr, Menu, Item } )
      if len( aAcesso ) >= 4095
        exit
      endif   
      dbskip () 
    enddo  
  
    for nK := 1 to len( aAcesso )
      if AdiReg()
        if RegLock()
          replace Usua         with cUsuario
          replace Modu         with aAcesso[ nK, 2 ]
          replace Menu         with aAcesso[ nK, 3 ]
          replace Item         with aAcesso[ nK, 4 ]
          dbunlock ()
        endif
      endif
    next

    aAcesso := {}
 
    select MenuARQ
    set order to 1
    dbgotop()
    do while !eof()
      if Modu == cEmpresa .and. Idio == cIdioma
        aadd( aAcesso, { Menu, Item, Modulo, Desc, Tama, Tecl, Linh, Colu, Mens, Expr, Acao } )

        if len( aAcesso ) >= 4095
          exit
        endif  
      endif 
      dbskip () 
    enddo  
  
    for nK := 1 to len( aAcesso )
      if AdiReg()
        if RegLock()
          replace Modu         with cEmpr
          replace Idio         with cIdioma
          replace Menu         with aAcesso[ nK, 01 ]
          replace Item         with aAcesso[ nK, 02 ]
          replace Modulo       with aAcesso[ nK, 03 ]
          replace Desc         with aAcesso[ nK, 04 ]
          replace Tama         with aAcesso[ nK, 05 ]
          replace Tecl         with aAcesso[ nK, 06 ]
          replace Linh         with aAcesso[ nK, 07 ]
          replace Colu         with aAcesso[ nK, 08 ]
          replace Mens         with aAcesso[ nK, 09 ]
          replace Expr         with aAcesso[ nK, 10 ]
          replace Acao         with aAcesso[ nK, 11 ]
          dbunlock ()
        endif
      endif
    next
  endif
  
  select EmprARQ
  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Direto     with cDireto
      replace Razao      with cRazao
      replace Nome       with cNome
      replace Ende       with cEnde
      replace Cida       with cCida
      replace CEP        with nCEP
      replace UF         with cUF
      replace Bairro     with cBairro
      replace CGC        with cCGC
      replace InscEstd   with cInscEstd
      replace Fone       with cFone
      replace Fax        with cFax
      dbunlock ()
    endif
  endif
  
  if cStat == 'prin'
    Alerta ( 'Alerta', 'PrinEmpr' ) 
  endif  
enddo

return NIL

//
// Entra Dados do Empresa
//
function EntrEmpr()
  local GetList := {}

  setcolor ( CorJanel + ',' + CorCampo )
  @ 06,60 get cDireto     pict '@!'                     valid !empty( cDireto )
  @ 08,21 get cNome       pict '@!' 
  @ 09,21 get cRazao      pict '@!' 
  @ 11,21 get cEnde       pict '@!' 
  @ 11,60 get nCEP        pict '99999-999' 
  @ 12,21 get cCida       pict '@!'  
  @ 12,60 get cUF         pict '@!' valid ValidUf ( 12, 60, "EmprARQ" ) 
  @ 13,21 get cBairro     pict '@!'  
  @ 13,41 get cFone       pict '@S14'         
  @ 13,60 get cFax        pict '@S14'         
  @ 15,21 get cCGC        pict '@R 99.999.999/9999-99'  valid ValidCGC( cCGC )
  @ 15,54 get cInscEstd                                
  read
return NIL

//
// Mostra Dados do Empresa
//
function MostEmpr()
  if cStat != 'incl'
    cEmpr   := Empr
    nEmpr   := val( Empr )
  endif
    
  cDireto   := Direto  
  cRazao    := Razao
  cNome     := Nome
  cEnde     := Ende
  cCida     := Cida
  nCEP      := CEP
  cBairro   := Bairro
  cUF       := UF
  cCGC      := CGC
  cInscEstd := InscEstd
  cFone     := Fone
  cFax      := Fax

  setcolor ( CorCampo )
  @ 06,60 say cDireto     pict '@!'
  @ 08,21 say cNome
  @ 09,21 say cRazao
  @ 11,21 say cEnde
  @ 11,60 say nCEP        pict '99999-999'
  @ 12,21 say cCida
  @ 12,60 say cUF         pict '@!'
  @ 13,21 say cBairro
  @ 13,41 say cFone       pict '@S14'                
  @ 13,60 say cFax        pict '@S14'              
  @ 15,21 say cCGC        pict '@R 99.999.999/9999-99' 
  @ 15,54 say cInscEstd
  
  PosiDBF( 04, 76 )
return NIL


//
// Apaga os Arquivos
//
function ApagaARQ()

  cArquivo  := alias()  
  tMostra   := savescreen( 00, 00, 24, 79 )

  select IndeARQ
  set filter to !empty( Desc )
  set order  to 3
  dbgotop()

  Janela( 03, 22, 20, 56, mensagem( 'Janela', 'ApagaARQ', .f. ), .f. ) 
  setcolor ( CorJanel + ',' + CorCampo )

  oFile         := TBrowseDb( 05, 23, 18, 55 )
  oFile:headsep := chr(194)+chr(196)
  oFile:footsep := chr(193)+chr(196)
  oFile:colsep  := chr(179)

  oFile:addColumn( TBColumnNew(" ",            {|| Marc } ) )
  oFile:addColumn( TBColumnNew("Arquivo",      {|| left( Desc, 30 ) } ) )
            
  lExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ''
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 16, 18, 56, nTotal )
    
  oFile:freeze := 1
  oFile:colPos := 2
   
  setcolor ( CorCampo )
  @ 19,33 say space(20)
    
  setcolor( CorJanel + ',' + CorCampo )
  @ 06,22 say chr(195)
  @ 18,22 say chr(195)
  @ 19,24 say 'Consulta'

  do while !lExitRequested
    Mensagem( 'Empr', 'Browse' )

    oFile:forcestable()

    PosiDBF( 03, 56 )
    
    iif( BarraSeta, BarraSeta( nLinBarra, 06, 18, 56, nTotal ), NIL )

    if oFile:stable
      if oFile:hitTop .or. oFile:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
 
    do case
      case cTecla == K_DOWN;        oFile:down()
      case cTecla == K_UP;          oFile:up()
      case cTecla == K_PGDN;        oFile:pageDown()
      case cTecla == K_PGUP;        oFile:pageUp()
      case cTecla == K_CTRL_PGUP;   oFile:goTop()
      case cTecla == K_CTRL_PGDN;   oFile:goBottom()
      case cTecla == K_RIGHT;       oFile:right()
      case cTecla == K_LEFT;        oFile:left()
      case cTecla == K_HOME;        oFile:home()
      case cTecla == K_END;         oFile:end()
      case cTecla == K_CTRL_LEFT;   oFile:panLeft()
      case cTecla == K_CTRL_RIGHT;  oFile:panRight()
      case cTecla == K_CTRL_HOME;   oFile:panHome()
      case cTecla == K_CTRL_END;    oFile:panEnd()
      case cTecla == K_ESC;         lExitRequested := .t.
      case cTecla == K_ENTER;       lExitRequested := .t.
      case cTecla == K_SPACE
        if RegLock()
          if IndeARQ->Marc == ' '
            replace Marc      with "X"
          else
            replace Marc      with ' '
          endif    
          dbunlock ()
        endif  
        
        oFile:refreshAll()
      case cTecla == K_ALT_Z
        if ConfAlte()
          dbgotop()
          do while !eof()
            if !empty( Marc )
              cArqu := alltrim( Arqu ) + '.DBF'

              ferase( cArqu )
              
              if RegLock() 
                replace Marc  with space(1)
                dbunlock()
              endif             
            endif
            dbskip()
          enddo  

          dbgotop()
          oFile:refreshAll()
        endif

        lExitRequested := .f.
      case cTecla == K_BS
        cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
      
        setcolor ( CorCampo )
        @ 19,33 say space(20)
        @ 19,33 say cLetra
      case cTecla >= 32 .and. cTecla <= 128
        cLetra += chr( cTecla )    

        if len( cLetra ) > 20
          cLetra := ''
        endif  
     
        setcolor ( CorCampo )
        @ 19,33 say space(20)
        @ 19,33 say cLetra

        dbseek( cLetra, .t. )
        oFile:refreshAll()
    endcase
  enddo
  
  select IndeARQ
  set filter to 
  dbgotop()
  do while !eof()
    if RegLock()
      replace Marc     with space(1)      
      dbunlock()    
    endif
    dbskip()
  enddo

  restscreen( 00, 00, 24, 79, tMostra )
return NIL


//
// Parametros do Sistema
//
function Parametros()

  tPara := savescreen( 00, 00, 23, 79 )
      
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 
    
  Janela( 03, 02, 20, 75, mensagem( 'Janela', 'Parametro', .f. ), .t. )
  Mensagem( 'Empr', 'Parametro' )
  
  setcolor( CorJanel )
  @ 05,04 say '[ ] Empresa na Inicialização            [ ] Produto Simplificado'
  @ 06,04 say '[ ] Formato/Mascara da Qtde Inteira     [ ] Pesquisar na Inclusão'
  @ 07,04 say '[ ] Consultar Contas a Receber          [ ] Capslock Ativo'
  @ 08,04 say '[ ] Juros na impressão do Pedido        [ ] Venda com Valor Total'
  @ 09,04 say '[ ] Seleção no Contas a Receber/Pagar   [ ] Consulta M‚dia Produtos'
  @ 10,04 say '[ ] Integrar movimento ao Caixa         [ ] Outros Preços em Produtos'
  @ 11,04 say '[ ] Nome da Empresa no Pedido           [ ] Definir Moeda Corrente'
  @ 12,04 say '[ ] Grade de hor rio na Abertura OS     [ ] Exibir Saldo Recibo'
  @ 13,04 say '[ ] Exibir dica do dia                  [ ] Numero de Serie'  
  @ 14,04 say '[ ] Operação Manual no Balcão           [ ] Editor descrição Produto'
  @ 15,04 say '[ ] Desconto Discriminado' 
  @ 16,04 say '[ ] Condições Fixas no Balcão'
  @ 17,04 say '[ ] Configuração/Impressão Pedido'
 
  select ParaARQ
  set order to 1
  dbseek( cUsuario, .f. )

  cIniEmpr := ParaARQ->Empresa
  cDicaDia := ParaARQ->Dica

  select EmprARQ
  set order to 1
  dbseek( cEmpresa, .f. )

  do while .t.
    cMemoProd   := MemoProd
    cNSerie     := NSerie
    cFolha      := Folha
    cEmprPedi   := EmprPedi
    cHorario    := Horario
    cComissao   := Comissao
    cPeriodo    := Periodo
    cCodBarra   := CodBarra
    cCondFixa   := CondFixa
    cConsClie   := ConsClie
    cDesconto   := Desconto
    cValorAll   := ValorAll
    cCaixa      := Caixa
    cJuro       := Juro
    cMoeda      := Moeda
    cVisuPedf   := VisuPedf
    cInteira    := Inteira
    cProdSimp   := ProdSimp
    cFindIncl   := FindIncl
    cCapsLock   := CapsLock
    cConsMedia  := ConsMedia
    cPrecoProd  := PrecoProd
    cCabec1     := Cabec1 
    cPreco1     := Preco1
    cCabec2     := Cabec2 
    cPreco2     := Preco2
    cCabec3     := Cabec3
    cPreco3     := Preco3
    cCabec4     := Cabec4 
    cPreco4     := Preco4
    cCabec5     := Cabec5 
    cPreco5     := Preco5
    cReciboTxt  := ReciboTxt 
  
    nClieCupom  := ClieCupom
    nCondCupom  := CondCupom
    nReprCupom  := ReprCupom
    nPortCupom  := PortCupom
    
    nAltera     := 0
    
    setcolor( CorCampo )
    @ 19,49 say ' Confirmar '
    @ 19,62 say ' Cancelar '
     
    setcolor( CorAltKC )
    @ 19,50 say 'C'
    @ 19,64 say 'a'
    
    setcolor ( CorJanel + ',' + CorCampo )
    @ 05,05 get cIniEmpr       pict '@!' valid cIniEmpr  == "X" .or. empty( cIniEmpr )
    @ 06,05 get cInteira       pict '@!' valid cInteira  == "X" .or. empty( cInteira )
    @ 07,05 get cConsClie      pict '@!' valid cConsClie == "X" .or. empty( cConsClie )
    @ 08,05 get cJuro          pict '@!' valid cJuro     == "X" .or. empty( cJuro )
    @ 09,05 get cPeriodo       pict '@!' valid cPeriodo  == "X" .or. empty( cPeriodo )
    @ 10,05 get cCaixa         pict '@!' valid cCaixa    == "X" .or. empty( cCaixa )
    @ 11,05 get cEmprPedi      pict '@!' valid cEmprPedi == "X" .or. empty( cEmprPedi )
    @ 12,05 get cHorario       pict '@!' valid cHorario  == "X" .or. empty( cHorario )
    @ 13,05 get cDicaDia       pict '@!' valid cDicaDia  == "X" .or. empty( cDicaDia )
    @ 14,05 get cCodBarra      pict '@!' valid cCodBarra == "X" .or. empty( cCodBarra )
    @ 15,05 get cDesconto      pict '@!' valid cDesconto == "X" .or. empty( cDesconto )
    @ 16,05 get cCondFixa      pict '@!' valid cCondFixa == "X" .or. empty( cCondFixa )
    @ 17,05 get cVisuPedf      pict '@!' valid cVisuPedf == "X" .or. empty( cVisuPedf )

    @ 05,45 get cProdSimp      pict '@!' valid cProdSimp == "X" .or. empty( cProdSimp )
    @ 06,45 get cFindIncl      pict '@!' valid cFindIncl == "X" .or. empty( cFindIncl )
    @ 07,45 get cCapsLock      pict '@!' valid cCapsLock == "X" .or. empty( cCapsLock )
    @ 08,45 get cValorAll      pict '@!' valid cValorAll == "X" .or. empty( cDesconto )
    @ 09,45 get cConsMedia     pict '@!' valid cConsMedia == "X" .or. empty( cConsMedia )
    @ 10,45 get cPrecoProd     pict '@!' valid cPrecoProd == "X" .or. empty( cPrecoProd )
    @ 11,45 get cMoeda         pict '@!' valid cMoeda == "X" .or. empty( cMoeda )
    @ 12,45 get cReciboTXT     pict '@!' valid cReciboTxt == "X" .or. empty( cReciboTxt )
    @ 13,45 get cNSerie        pict '@!' valid cNSerie == "X" .or. empty( cNSerie )
    @ 14,45 get cMemoProd      pict '@!' valid cMemoProd == "X" .or. empty( cMemoProd )
    read
    
    if lastkey() == K_ESC 
      exit
    endif

    if cPrecoProd == "X" .and. lastkey() != K_PGDN
      tPreco := savescreen( 00, 00, 23, 79 )
    
      Janela( 05, 16, 13, 68, mensagem( 'Janela', 'Parametro2', .f. ), .f. )
      setcolor( CorJanel + ',' + CorCampo )
      @ 07,18 say '  Cabeçalho   C lculo'
      @ 08,18 say '1'              
      @ 09,18 say '2'
      @ 10,18 say '3'
      @ 11,18 say '4'
      @ 12,18 say '5'
     
      @ 08,20 get cCabec1   pict '@S10'
      @ 08,32 get cPreco1   pict '@S35'
      @ 09,20 get cCabec2   pict '@S10'
      @ 09,32 get cPreco2   pict '@S35'
      @ 10,20 get cCabec3   pict '@S10'
      @ 10,32 get cPreco3   pict '@S35'
      @ 11,20 get cCabec4   pict '@S10'
      @ 11,32 get cPreco4   pict '@S35'
      @ 12,20 get cCabec5   pict '@S10'
      @ 12,32 get cPreco5   pict '@S35'
      read

      restscreen( 00, 00, 23, 79, tPreco )
    endif

    if cCondFixa == "X"
      tCondFixa := savescreen( 00, 00, 23, 79 )
 
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

      if NetUse( "ReprARQ", .t. )
        VerifIND( "ReprARQ" )
  
        vOpenRepr := .t.
  
        #ifdef DBF_NTX
          set index to ReprIND1, ReprIND2
        #endif
      else
        vOpenRepr := .f.  
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

      Janela( 06, 16, 12, 63, mensagem( 'Janela', 'Parametro3', .f. ), .f. )
      setcolor( CorJanel + ',' + CorCampo )
      @ 08,18 say '   Pgto.'
      @ 09,18 say ' Cliente'
      @ 10,18 say 'Vendedor' 
      @ 11,18 say 'Portador'
     
      select ClieARQ
      set order to 1
      dbseek( strzero( nClieCupom, 6 ), .f. )

      select PortARQ
      set order to 1
      dbseek( strzero( nPortCupom, 6 ), .f. )

      select ReprARQ
      set order to 1
      dbseek( strzero( nReprCupom, 6 ), .f. )

      select CondARQ
      set order to 1
      dbseek( strzero( nCondCupom, 6 ), .f. )
                
      nClie := nClieCupom
      
      setcolor( CorCampo )
      @ 08,34 say CondARQ->Nome pict '@S30'
      @ 09,34 say ClieARQ->Nome pict '@S30'
      @ 10,34 say ReprARQ->Nome pict '@S30'
      @ 11,34 say PortARQ->Nome pict '@S30'

      @ 08,27 get nCondCupom    pict '999999'  valid ValidARQ( 08, 29, "EmprARQ", "Codigo", "Cond", "Descrição", "Nome", "Cond", "nCondCupom", .t., 6, "Consulta de Condições Pagamento", "CondARQ", 30 )
      @ 09,27 get nClie         pict '999999'  valid ValidClie( 09, 27, "EmprARQ", 30 )
      @ 10,27 get nReprCupom    pict '999999'  valid ValidARQ( 10, 27, "EmprARQ", "Codigo", "Repr", "Descrição", "Nome", "Repr", "nReprCupom", .t., 6, "Consulta de Vendedores", "ReprARQ", 30 )
      @ 11,27 get nPortCupom    pict '999999'  valid ValidARQ( 11, 27, "EmprARQ", "Codigo", "Port", "Descrição", "Nome", "Port", "nPortCupom", .t., 6, "Consulta de Portadores", "PortARQ", 30 )
      read
            
      nClieCupom := nClie
      
      if vOpenClie 
        select ClieARQ
        close
      endif
      
      if vOpenCond 
        select CondARQ
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
      
      restscreen( 00, 00, 23, 79, tCondFixa )
    endif
    
    aOpcoes := {}
 
    aadd( aOpcoes, { ' Confirmar ',  2, 'C', 19, 49, "Tecle <ENTER> para Confirmar alterações dos Parametros do Sistema." } )
    aadd( aOpcoes, { ' Cancelar ',   3, 'A', 19, 62, "Tecle <ENTER> para Cancelar alterações dos Parametros do Sistema." } )

    nAltera := HCHOICE( aOpcoes, 2, 1 )
    
    select EmprARQ

    if nAltera == 1
      if RegLock()
        replace MemoProd   with cMemoProd
        replace Folha      with cFolha
        replace Inteira    with cInteira
        replace Caixa      with cCaixa 
        replace Juro       with cJuro 
        replace ConsMedia  with cConsMedia
        replace PrecoProd  with cPrecoProd
        replace Periodo    with cPeriodo
        replace Desconto   with cDesconto
        replace ConsClie   with cConsClie
        replace EmprPedi   with cEmprPedi
        replace Horario    with cHorario
        replace CondFixa   with cCondFixa
        replace CodBarra   with cCodBarra
        replace VisuPedf   with cVisuPedf
        replace CondCupom  with nCondCupom
        replace ClieCupom  with nClieCupom
        replace PortCupom  with nPortCupom
        replace ReprCupom  with nReprCupom
        replace ProdSimp   with cProdSimp
        replace FindIncl   with cFindIncl
        replace ValorAll   with cValorAll
        replace ReciboTxt  with cReciboTxt
        replace CapsLock   with cCapsLock
        replace NSerie     with cNSerie
        replace Moeda      with cMoeda
        replace Cabec1     with cCabec1
        replace Preco1     with cPreco1
        replace Cabec2     with cCabec2
        replace Preco2     with cPreco2        
        replace Cabec3     with cCabec3
        replace Preco3     with cPreco3
        replace Cabec4     with cCabec4
        replace Preco4     with cPreco4
        replace Cabec5     with cCabec5
        replace Preco5     with cPreco5
        dbunlock ()
      endif
    endif

    select ParaARQ
    set order to 1
    if RegLock()
      replace Dica       with cDicaDia 
      replace Empresa    with cIniEmpr
      dbunlock()
    endif  

    select EmprARQ
  enddo
 
  restscreen( 00, 00, 23, 79, tPara )
return NIL

//
// Paramentros Processos
//
function ParaProc ()
  tPara := savescreen( 00, 00, 23, 79 )
  
  if NetUse( "NFisARQ", .t. )
    VerifIND( "NFisARQ" )

    #ifdef DBF_NTX
      set index to NFisIND1
    #endif  
  endif
  
  if NetUse( "EtiqARQ", .t. )
    VerifIND( "EtiqARQ" )

    #ifdef DBF_NTX
      set index to EtiqIND1
    #endif  
  endif
  
  if NetUse( "CarnARQ", .t. )
    VerifIND( "CarnARQ" )

    #ifdef DBF_NTX
      set index to CarnIND1
    #endif  
  endif
  
  if NetUse( "DuplARQ", .t. )
    VerifIND( "DuplARQ" )

    #ifdef DBF_NTX
      set index to DuplIND1
    #endif  
  endif
  
  if NetUse( "IdioARQ", .t. )
    VerifIND( "IdioARQ" )

    #ifdef DBF_NTX
      set index to IdioIND1, IdioIND2
    #endif  
  endif
  
  if NetUse( "NoPrARQ", .t. )
    VerifIND( "NoPrARQ" )

    #ifdef DBF_NTX
      set index to NoPrIND1
    #endif  
  endif

  if NetUse( "BarrARQ", .t. )
    VerifIND( "BarrARQ" )

    #ifdef DBF_NTX
      set index to BarrIND1
    #endif  
  endif
      
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 
  
  Janela ( 02, 02, 18, 74, mensagem( 'Janela', 'ParaProc', .f. ), .t. )
  Mensagem('Empr', 'ParaProc' )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 04,04 say '       Idioma'
          
  @ 06,04 say 'Proteção Tela                        Comissão'
  @ 07,04 say '  Nota Fiscal                       Duplicata'
  @ 08,04 say '  Promissória                           Carnˆ'
  @ 09,04 say 'Ordem Serviço                      Cons.Prod.'

  @ 11,04 say ' Etiq.Cliente                      Etiq.Prod.'
  @ 12,04 say ' Etiq. Agenda                     Cod Barras'

  @ 14,04 say ' Incl.Cliente                    Impr. Pedido'
  @ 15,04 say '    Orçamento                          Recibo'
  
  setcolor ( 'n/w+' )
  @ 06,34 say chr(25)
  @ 06,66 say chr(25)
  @ 07,34 say chr(25)
  @ 07,66 say chr(25)
  @ 08,34 say chr(25)
  @ 08,66 say chr(25)
  @ 09,34 say chr(25)
  @ 09,66 say chr(25)
  @ 11,34 say chr(25)
  @ 11,66 say chr(25)
  @ 12,34 say chr(25)
  @ 12,66 say chr(25)
  @ 14,34 say chr(25)
  @ 14,66 say chr(25)
  @ 15,34 say chr(25)
  @ 15,66 say chr(25)

  select IdioARQ 
  set order to 1
  dbgotop()
  if val( Idio ) == 0
    if AdiReg()
      replace Idio          with '01'
      replace Nome          with 'Portuguˆs'
      dbunlock() 
    endif
  endif
 
  select ParaARQ
  set order to 1
  dbseek( cUsuario, .f. )
  
  select EmprARQ
  set order to 1
  dbseek( cEmpresa, .f. )

  do while .t.
    cIdio       := Idio
    nIdio       := val( Idio )
    nTipoOS     := TipoOS
    nBarrProd   := BarrProd
    nComissao   := Comissao
    nConsProd   := ConsProd
    nEtiqClie   := EtiqClie
    nEtiqProd   := EtiqProd
    nEtiqAgen   := EtiqAgen
    nECF        := ECF
    nCarne      := Carne
    nNFis       := NFis
    nDupl       := Dupl
    nNoPr       := NoPr
    nTipo       := iif( Saver == 0, 1, Saver )
    cTexto      := Texto
    cInclClie   := InclClie
    nTipoPedi   := TipoPedi
    nTipoOPro   := TipoOPro
    nTipoReci   := TipoReci
    
    pRecibo     := iif( Recibo == 0, 1, Recibo )
    pPedido     := iif( Pedido == 0, 1, Pedido )
    pRelatorio  := iif( Relatorio == 0, 1, Relatorio )
    pNotaFiscal := iif( NotaFiscal == 0, 1, NotaFiscal )
    pDuplicata  := iif( Duplicata == 0, 1, Duplicata )
    pCheque     := iif( Cheque == 0, 1, Cheque )
    pBloqueto   := iif( Bloqueto == 0, 1, Bloqueto )
    pProduto    := iif( Produto == 0, 1, Produto )
    pCliente    := iif( Cliente == 0, 1, Cliente )
    pTipoOS     := iif( TipoOS == 0, 1, TipoOS )
 
    aOpcoes     := {}
    
    NFisARQ->(dbsetorder(1))
    NFisARQ->(dbseek(nNFis,.f.))
    DuplARQ->(dbsetorder(1))
    DuplARQ->(dbseek(nDupl,.f.))
    NoPrARQ->(dbsetorder(1))
    NoPrARQ->(dbseek(nNoPr,.f.))
    CarnARQ->(dbsetorder(1))
    CarnARQ->(dbseek(nCarne,.f.))
    BarrARQ->(dbsetorder(1))
    BarrARQ->(dbseek(nBarrProd,.f.))
    IdioaRQ->(dbsetorder(1))
    IdioARQ->(dbseek(strzero(nIdio,2),.f.))

    setcolor ( CorCampo )
    @ 04,18 say nIdio          pict '99'
    @ 04,21 say IdioARQ->Nome  pict '@S10'
    @ 17,49 say ' Confirmar '
    @ 17,62 say ' Cancelar '

    do case
      case nTipo == 1
        @ 06,18 say ' Quebra-Cabeça '
      case nTipo == 2
        @ 06,18 say ' Movimento     '
      case nTipo == 3
        @ 06,18 say ' Xadrez        '
      case nTipo == 4
        @ 06,18 say ' Aleatório     '
      case nTipo == 5
        @ 06,18 say ' Nenhuma       '
      otherwise
        nTipo := 6
        @ 06,18 say space(15)
    endcase

    do case
      case nComissao == 1
        @ 06,50 say ' Pedido/Nota   '
      case nComissao == 2
        @ 06,50 say ' Conta Receber '
      otherwise
        @ 06,50 say '               '
        
        nComissao := 1
    endcase

    do case
      case nTipoOS == 1
        @ 09,18 say ' Ass. Técnica  '
      case nTipoOS == 2
        @ 09,18 say ' Veículos      '
      case nTipoOS == 3
        @ 09,18 say ' Gráfica       '
      case nTipoOS == 4
        @ 09,18 say ' Genêrica      '
      otherwise
        @ 09,18 say '               '
        
        nTipoOS := 1
    endcase

    do case
      case nConsProd == 1
        @ 09,50 say ' Codigo/Nome   '
      case nConsProd == 2
        @ 09,50 say ' Grup/SubG/Nom '
      case nConsProd == 3
        @ 09,50 say ' Refe/Nome     '
      case nConsProd == 4
        @ 09,50 say ' CodBarra/Nome '
      case nConsProd == 5
        @ 09,50 say ' Grup/SubG/Ref '
      case nConsProd == 6
        @ 09,50 say ' Grup/SubG/Cod'
     otherwise
        @ 09,50 say '               '
        
        nConsProd := 1
    endcase
    
    if NFisARQ->(found())
      lFisc := .t.

      @ 07,18 say ' ' + left( NFisARQ->Desc, 14 )
    else
      lFisc := .f.

      @ 07,18 say space(15)
    endif

    if DuplARQ->(found())
      lDupl := .t.

      @ 07,50 say ' ' + left( DuplARQ->Desc, 14 )
    else
      lDupl := .f.

      @ 07,50 say space(15)
    endif

    if NoPrARQ->(found())
      lNoPr := .t.

      @ 08,18 say ' ' + left( NoPrARQ->Desc, 14 )
    else
      lNoPr := .f.

      @ 08,18 say space(15)
    endif

    select EtiqARQ
    set order to 1
    dbseek( nEtiqClie, .f. )

    if found()
      lEtiqClie := .t.
    
      @ 11,18 say ' ' + left( Desc, 14 )
    else
      lEtiqClie := .f.
  
      @ 11,18 say space(15)
    endif

    dbseek( nEtiqProd, .f. )

    if found()
      lEtiqProd := .t.
    
      @ 11,50 say ' ' + left( Desc, 14 )
    else
      lEtiqProd := .f.
  
      @ 11,50 say space(15)
    endif

    dbseek( nEtiqAgen, .f. )

    if found()
      lEtiqAgen := .t.
    
      @ 12,18 say ' ' + left( Desc, 14 )
    else
      lEtiqAgen := .f.
  
      @ 12,18 say space(15)
    endif
    
    if BarrARQ->(found())
      lBarrProd := .t.
    
      @ 12,50 say ' ' + left( BarrARQ->Desc, 14 )
    else
      lBarrProd := .f.
  
      @ 12,50 say space(15)
    endif

    if CarnARQ->(found())
      lCarn := .t.

      @ 08,50 say ' ' + left( CarnARQ->Desc, 14 )
    else
      lCarn := .f.

      @ 08,50 say space(15)
    endif

    do case 
      case cInclClie == 'F'
        @ 14,18 say ' Física        '
      case cInclClie == 'J'
        @ 14,18 say ' Jurídica      '
      case cInclClie == 'S'
        @ 14,18 say ' Simples       '
      case cInclClie == 'A'
        @ 14,18 say ' Ambos         '
      otherwise
        @ 14,18 say '               '
    endcase    
        
    setcolor( CorAltKC )
    do case
      case cInclClie == 'F';     nInclClie := 1
        @ 14,19 say 'F'
      case cInclClie == 'J';     nInclClie := 2
        @ 14,19 say 'J'
      case cInclClie == 'S';     nInclClie := 3
        @ 14,19 say 'S'
      case cInclClie == 'A';     nInclClie := 4
        @ 14,19 say 'A'
      otherwise;                 nInclClie := 1
    endcase
    
    setcolor( CorCampo )
  
    do case 
      case nTipoPedi == 1
        @ 14,50 say ' Metade Folha  '
      case nTipoPedi == 2  
        @ 14,50 say ' Folha Inteira '
      case nTipoPedi == 3  
        @ 14,50 say ' 1/4 Folha     '
      case nTipoPedi == 4   
        @ 14,50 say ' 40 Colunas    '
      otherwise
        @ 14,50 say '               '
    endcase    
        
    setcolor( CorAltKC )
    do case
      case nTipoPedi == 1
        @ 14,51 say 'M'
      case nTipoPedi == 2
        @ 14,51 say 'F'
      case nTipoPedi == 3
        @ 14,51 say '1'
      case nTipoPedi == 4
        @ 14,51 say '4'
      otherwise
        nTipoPedi := 1
    endcase
   

    setcolor( CorCampo )
  
    do case 
      case nTipoOPro == 1
        @ 15,18 say ' Metade Folha  '
      case nTipoOPro == 2  
        @ 15,18 say ' Folha Inteira '
      case nTipoOPro == 3  
        @ 15,18 say ' 1/4 Folha     '
      case nTipoOPro == 4   
        @ 15,18 say ' 40 Colunas    '
      otherwise
        @ 15,18 say '               '
    endcase    
        
    setcolor( CorAltKC )
    do case
      case nTipoOPro == 1
        @ 15,19 say 'M'
      case nTipoOPro == 2
        @ 15,19 say 'F'
      case nTipoOPro == 3
        @ 15,19 say '1'
      case nTipoOPro == 4
        @ 15,19 say '4'
      otherwise
        nTipoOPro := 1
    endcase
    
    setcolor( CorCampo )
     
    do case 
      case nTipoReci == 1
        @ 15,50 say ' Metade Folha  '
      case nTipoReci == 2  
        @ 15,50 say ' Folha Inteira '
      case nTipoReci == 3  
        @ 15,50 say ' 1/4 Folha     '
      case nTipoReci == 4   
        @ 15,50 say ' 40 Colunas    '
      otherwise
        @ 15,50 say '               '
    endcase    
        
    setcolor( CorAltKC )
    do case
      case nTipoReci == 1
        @ 15,51 say 'M'
      case nTipoReci == 2
        @ 15,51 say 'F'
      case nTipoReci == 3
        @ 15,51 say '1'
      case nTipoReci == 4
        @ 15,51 say '4'
      otherwise
        nTipoReci := 1
    endcase
   
    setcolor( CorAltKC )
    @ 17,50 say 'C'
    @ 17,64 say 'a'
    
    aadd( aOpcoes, { ' Quebra-Cabeça ',  2, 'Q', 06, 18, "Proteção de tela estilo quebra-cabeça, Utilize as setas para escolher." } )
    aadd( aOpcoes, { ' Movimento     ',  2, 'M', 06, 18, "Proteção de tela com o nome da empresa em movimento, Utilize as setas para escolher." } )
    aadd( aOpcoes, { ' Xadrez        ',  2, 'X', 06, 18, "Proteção de tela com o efeito de xadrez, Utilize as setas para escolher." } )
    aadd( aOpcoes, { ' Aleatório     ',  4, 'A', 06, 18, "Proteção de tela Aleatório, Utilize as setas para escolher." } )
    aadd( aOpcoes, { ' Nenhuma       ',  5, 'H', 06, 18, "Nenhuma Proteção de tela, Utilize as setas para escolher." } )
   
    setcolor( CorJanel )
      
    @ 04,18 get nIdio             pict '99'  valid ValidARQ( 04, 18, "EmprARQ", "Código" , "Idio", "Descrição", "Nome", "Idio", "nIdio", .t., 2, "Consulta de Idiomas", "IdioARQ", 10 )
    read
      
    if lastkey() == K_ESC
      exit
    endif
    
    nTipo   := HCHOICE( aOpcoes, 5, nTipo )
    aOpcoes := {}
  
    if lastkey() == K_ESC
      exit
    endif
    
    if nTipo == 5
      tMsg := savescreen( 00, 00, 23, 79 )

      Janela( 10, 14, 13, 63, mensagem( 'Janela', 'ParaProc2', .f. ), .f. )
      Mensagem( 'Empr', 'ParaProc2' )
      setcolor( CorJanel )
      @ 12,16 say 'Texto'
      
      if empty( cTexto )
        cTexto := 'Digite seu texto aqui !                                     '         
      endif     
      
      @ 12,22 get cTexto          pict '@S40'
      read
        
      restscreen( 00, 00, 23, 79, tMsg )
    endif
      
    aadd( aOpcoes, { ' Pedido/Nota   ',  2, 'P', 06, 50, "Configuração relatório de comissões a partir dos Pedidos e NF, Utilize as setas para escolher." } )
    aadd( aOpcoes, { ' Conta Receber ',  2, 'C', 06, 50, "Configuração relatório de comissões a partir das Contas a Receber, Utilize as setas para escolher." } )
   
    nComissao := HCHOICE( aOpcoes, 2, nComissao )
    aOpcoes   := {}
  
    if lastkey() == K_ESC
      exit
    endif
    
    select NFisARQ
    dbgotop ()
    if eof()
      aadd( aOpcoes, { ' Nenhum        ',  2, 'N', 07, 18, "Nenhum Layout foi definido." } )
    endif

    do while !eof ()
      aadd( aOpcoes, { ' ' + left( Desc, 14 ),  2, 'B', 07, 18, "Configura o modelo da Nota Fiscal, Utilize as setas para escolher." } )
      dbskip ()
    enddo  
    
    if lFisc 
      nNFis := HCHOICE( aOpcoes, len( aOpcoes ), nNFis )
    else  
      nLen  := iif( len( aOpcoes ) == 0, 1, len( aOpcoes ) )
      nNFis := HCHOICE( aOpcoes, nLen, 1 )
    endif

    aOpcoes := {}
  
    if lastkey() == K_ESC
      exit
    endif
   
    select DuplARQ
    dbgotop ()
    if eof()
      aadd( aOpcoes, { ' Nenhum        ',  2, 'N', 07, 50, "Nenhum Layout foi definido." } )
    endif
    do while !eof()
      aadd( aOpcoes, { ' ' + left( Desc, 14 ),  2, 'B', 07, 50, "Configura o modelo da duplicata, Utilize as setas para escolher." } )
      dbskip ()
    enddo  
    
    if lDupl 
      nDupl := HCHOICE( aOpcoes, len( aOpcoes ), nDupl )
    else  
      nLen  := iif( len( aOpcoes ) == 0, 1, len( aOpcoes ) )
      nDupl := HCHOICE( aOpcoes, nLen, 1 )
    endif
    
    aOpcoes := {}
   
    select NoPrARQ
    dbgotop ()
    if eof()
      aadd( aOpcoes, { ' Nenhum        ',  2, 'N', 08, 18, "Nenhum Layout foi definido." } )
    endif
    do while !eof ()
      aadd( aOpcoes, { ' ' + left( Desc, 14 ),  2, 'B', 08, 18, "Configura o modelo da Nota Promissória, Utilize as setas para escolher." } )
      dbskip ()
    enddo  
    
    if lNoPr 
      nNoPr := HCHOICE( aOpcoes, len( aOpcoes ), nNoPr )
    else  
      nLen  := iif( len( aOpcoes ) == 0, 1, len( aOpcoes ) )
      nNoPr := HCHOICE( aOpcoes, nLen, 1 )
    endif
    
    aOpcoes := {}
  
    if lastkey() == K_ESC
      exit
    endif

    select CarnARQ
    dbgotop ()
    if eof()
      aadd( aOpcoes, { ' Nenhum        ',  2, 'N', 08, 50, "Nenhum Layout foi definido." } )
    endif
    do while !eof ()
      aadd( aOpcoes, { ' ' + left( Desc, 14 ),  2, 'B', 08, 50, "Configura o modelo do carnˆ, Utilize as setas para escolher." } )
      dbskip ()
    enddo  
    
    if lCarn 
      nCarne := HCHOICE( aOpcoes, len( aOpcoes ), nCarne )
    else  
      nLen   := iif( len( aOpcoes ) == 0, 1, len( aOpcoes ) )
      nCarne := HCHOICE( aOpcoes, nLen, 1 )
    endif
  
    if lastkey() == K_ESC
      exit
    endif
      
    aOpcoes := {}

    aadd( aOpcoes, { ' Ass. T‚cnica  ',  2, 'A', 09, 18, "Configura o modelo da Ordem Serviço para Assistência Técnica, Utilize as setas para escolher." } )
    aadd( aOpcoes, { ' Veículo       ',  2, 'M', 09, 18, "Configura o modelo da Ordem Serviço para Oficina Mecanica, Utilize as setas para escolher." } )
    aadd( aOpcoes, { ' Gr fica       ',  3, 'r', 09, 18, "Configura o modelo da Ordem Serviço para Gráfica, Utilize as setas para escolher." } )
    aadd( aOpcoes, { ' Gen‚rica      ',  2, 'G', 09, 18, "Configura o modelo da Ordem Serviço para Oficina Generica, Utilize as setas para escolher." } )
    nTipoOS := HCHOICE( aOpcoes, 4, nTipoOS )
  
    if lastkey() == K_ESC
      exit
    endif
    
    if nTipoOS == 4
      tOS  := savescreen( 00, 00, 23, 79 )
      cTxt := EmprARQ->TxtOS

      Janela( 05, 01, 19, 78, mensagem( 'Janela', 'ParaProc3', .f. ), .F. )
      Mensagem( "Empr", "ParaProc3" )
      
      setcolor( CorJanel + ',' + CorCampo )
      cLayout := memoedit( cTxt, 06, 03, 18, 77, .t., "OutProd", 80, , , 1, 0 )
      
      if lastkey() == K_CTRL_W
        select EmprARQ
        if RegLock()
          replace TxtOS       with cLayout
          dbunlock()
        endif
        select ParaARQ
      endif
      restscreen( 00, 00, 23, 79, tOS )
    endif
      
    aOpcoes := {}

    aadd( aOpcoes, { ' Codigo/Nome   ',  2, 'C', 09, 50, "Consulta de produtos por nome." } )
    aadd( aOpcoes, { ' Grup/SubG/Nom ',  2, 'G', 09, 50, "Consulta de produtos por Grupo, SubGrupo, Nome." } )
    aadd( aOpcoes, { ' Refe/Nome     ',  2, 'R', 09, 50, "Consulta de produtos por referencia." } )
    aadd( aOpcoes, { ' CodBarra/Nome ',  3, 'O', 09, 50, "Consulta de produtos por codigo barra." } )
    aadd( aOpcoes, { ' Grup/SubG/Ref ',  2, 'G', 09, 50, "Consulta de produtos por Grupo, SubGrupo, Nome." } )
    aadd( aOpcoes, { ' Grup/SubG/Bar ',  2, 'G', 09, 50, "Consulta de produtos por Grupo, SubGrupo, Nome." } )
   
    nConsProd := HCHOICE( aOpcoes, 6, nConsProd )
    aOpcoes   := {}
  
    if lastkey() == K_ESC
      exit
    endif

    select EtiqARQ
    dbgotop ()
    if eof()
      aadd( aOpcoes, { ' Nenhum        ',  2, 'N', 11, 18, "Nenhum Layout foi definido." } )
    endif
    do while !eof ()
      aadd( aOpcoes, { ' ' + left( Desc, 14 ),  2, 'B', 11, 18, "Configura o modelo da etiqueta de cliente, Utilize as setas para escolher." } )
      dbskip ()
    enddo  
    
    if lEtiqClie 
      nEtiqClie := HCHOICE( aOpcoes, len( aOpcoes ), nEtiqClie )
    else  
      nLen      := iif( len( aOpcoes ) == 0, 1, len( aOpcoes ) )
      nEtiqClie := HCHOICE( aOpcoes, nLen, 1 )
    endif
      
    aOpcoes   := {}
    
    select EtiqARQ
    dbgotop ()
    if eof()
      aadd( aOpcoes, { ' Nenhum        ',  2, 'N', 11, 50, "Nenhum Layout foi definido." } )
    endif
    do while !eof ()
      aadd( aOpcoes, { ' ' + left( Desc, 14 ),  2, 'B', 11, 50, "Configura o modelo da etiqueta de produto, Utilize as setas para escolher." } )
      dbskip ()
    enddo  
    
    if lEtiqProd
      nEtiqProd := HCHOICE( aOpcoes, len( aOpcoes ), nEtiqProd )
    else  
      nLen      := iif( len( aOpcoes ) == 0, 1, len( aOpcoes ) )
      nEtiqProd := HCHOICE( aOpcoes, nLen, 1 )
    endif
      
    if lastkey() == K_ESC
      exit
    endif
  
    aOpcoes := {}
    
    select EtiqARQ
    dbgotop ()
    if eof()
      aadd( aOpcoes, { ' Nenhum        ',  2, 'N', 12, 18, "Nenhum Layout foi definido." } )
    endif
    do while !eof ()
      aadd( aOpcoes, { ' ' + left( Desc, 14 ),  2, 'B', 12, 18, "Configura o modelo da etiqueta da agenda, Utilize as setas para escolher." } )
      dbskip ()
    enddo  
    
    if lEtiqAgen 
      nEtiqAgen := HCHOICE( aOpcoes, len( aOpcoes ), nEtiqAgen )
    else  
      nLen      := iif( len( aOpcoes ) == 0, 1, len( aOpcoes ) )
      nEtiqAgen := HCHOICE( aOpcoes, nLen, 1 )
    endif
      
    if lastkey() == K_ESC
      exit
    endif
    
    aOpcoes := {}
    
    select BarrARQ
    dbgotop ()
    if eof()
      aadd( aOpcoes, { ' Nenhum        ',  2, 'N', 12, 50, "Nenhum Layout foi definido." } )
    endif
    do while !eof ()
      aadd( aOpcoes, { ' ' + left( Desc, 14 ),  2, 'B', 12, 50, "Configura o modelo da etiqueta da cod barras, Utilize as setas para escolher." } )
      dbskip ()
    enddo  
    
    if lBarrProd 
      nBarrProd := HCHOICE( aOpcoes, len( aOpcoes ), nBarrProd )
    else  
      nLen      := iif( len( aOpcoes ) == 0, 1, len( aOpcoes ) )
      nBarrProd := HCHOICE( aOpcoes, nLen, 1 )
    endif
      
    if lastkey() == K_ESC
      exit
    endif

    aOpcoes := {}
       
    aadd( aOpcoes, { ' Física        ', 2, 'F', 14, 18, "Configura a inclusão de Cliente Física na Consulta, Utilize as setas para escolher." } )
    aadd( aOpcoes, { ' Jurídica      ', 2, 'J', 14, 18, "Configura a consulta de Cliente Jurídica na Consulta, Utilize as setas para escolher." } )
    aadd( aOpcoes, { ' Simples       ', 2, 'S', 14, 18, "Configura a consulta de Cliente Jurídica na Consulta, Utilize as setas para escolher." } )
    aadd( aOpcoes, { ' Ambos         ', 2, 'A', 14, 18, "Configura a inclusão de Clientes, Utilize as setas para escolher." } )
   
    nInclClie := HCHOICE( aOpcoes, 4, nInclClie )
    aOpcoes   := {}
    
    do case 
      case nInclClie == 1;        cInclClie := 'F'
      case nInclClie == 2;        cInclClie := 'J'
      case nInclClie == 3;        cInclClie := 'S'
      case nInclClie == 4;        cInclClie := 'A'
    endcase
    
    aOpcoes := {}
      
    if lastkey() == K_ESC
      exit
    endif
   
    aadd( aOpcoes, { ' Metade Folha  ', 2, 'M', 14, 50, "Impressão do Pedido em metada da folha, Utilize as setas para escolher." } )
    aadd( aOpcoes, { ' Folha Inteira ', 2, 'F', 14, 50, "Impressão do Pedido em folha inteira, Utilize as setas para escolher." } )
    aadd( aOpcoes, { ' 1/4 Folha     ', 2, '1', 14, 50, "Impressão do Pedido em 1/4 folha, Utilize as setas para escolher." } )
    aadd( aOpcoes, { ' 40 Colunas    ', 2, '4', 14, 50, "Impressão do Pedido em 40 colunas, Utilize as setas para escolher." } )
   
    nTipoPedi := HCHOICE( aOpcoes, 4, nTipoPedi )
    aOpcoes := {}
      
    if lastkey() == K_ESC
      exit
    endif
   
    aadd( aOpcoes, { ' Metade Folha  ', 2, 'M', 15, 18, "Impressão do Orçamento em metada da folha, Utilize as setas para escolher." } )
    aadd( aOpcoes, { ' Folha Inteira ', 2, 'F', 15, 18, "Impressão do Orçamento em folha inteira, Utilize as setas para escolher." } )
    aadd( aOpcoes, { ' 1/4 Folha     ', 2, '1', 15, 18, "Impressão do Orçamento em 1/4 folha, Utilize as setas para escolher." } )
    aadd( aOpcoes, { ' 40 Colunas    ', 2, '4', 15, 18, "Impressão do Orçamento em 40 colunas, Utilize as setas para escolher." } )
   
    nTipoOPro := HCHOICE( aOpcoes, 4, nTipoOpro )
    aOpcoes := {}
      
    if lastkey() == K_ESC
      exit
    endif
   
    aadd( aOpcoes, { ' Metade Folha  ', 2, 'M', 15, 50, "Impressão do Recibo em metada da folha, Utilize as setas para escolher." } )
    aadd( aOpcoes, { ' Folha Inteira ', 2, 'F', 15, 50, "Impressão do Recibo em folha inteira, Utilize as setas para escolher." } )
    aadd( aOpcoes, { ' 1/4 Folha     ', 2, '1', 15, 50, "Impressão do Recibo em 1/4 folha, Utilize as setas para escolher." } )
    aadd( aOpcoes, { ' 40 Colunas    ', 2, '4', 15, 50, "Impressão do Recibo em 40 colunas, Utilize as setas para escolher." } )
   
    nTipoReci := HCHOICE( aOpcoes, 4, nTipoReci )
    aOpcoes := {}
      
    aadd( aOpcoes, { ' Confirmar ',  2, 'C', 17, 49, "Tecle <ENTER> para Confirmar alteraç”es dos Paramˆtros do Sistema." } )
    aadd( aOpcoes, { ' Cancelar ',   3, 'A', 17, 62, "Tecle <ENTER> para Cancelar alteraç”es dos Paramˆtros do Sistema." } )

    nAltera := HCHOICE( aOpcoes, 2, 1 )
    
    select EmprARQ

    if nAltera == 1
      if RegLock()
        replace InclClie   with cInclClie
        replace EtiqAgen   with nEtiqAgen
        replace EtiqClie   with nEtiqClie
        replace EtiqProd   with nEtiqProd
        replace NFis       with nNFis
        replace TipoOS     with nTipoOS
        replace ConsProd   with nConsProd
        replace Idio       with strzero( nIdio, 2 )
        replace Dupl       with nDupl
        replace NoPr       with nNoPr
        replace Saver      with nTipo
        replace Carne      with nCarne
        replace Texto      with cTexto
        replace Comissao   with nComissao
        replace TipoPedi   with nTipoPedi
        replace TipoOpro   with nTipoOPro
        replace TipoReci   with nTipoReci
        replace BarrProd   with nBarrProd
        dbunlock ()
      endif
      
      cIdioma := strzero( nIdio, 2 )
    endif  
  enddo  
    
  select CarnARQ
  close
  select NFisARQ
  close
  select DuplARQ
  close
  select NoPrARQ
  close
  select EtiqARQ
  close
  select BarrARQ
  close
  restscreen( 00, 00, 23, 79, tPara )
return NIL


//
//
//
function ParaSist ()
  tPara := savescreen( 00, 00, 23, 79 )
      
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 
  
  Janela ( 04, 02, 20, 73, mensagem( 'Janela', 'ParaSist', .f. ), .t. )
  Mensagem( 'Empr', 'ParaSist' )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 06,04 say '       Pedido             Orçamento             Nota Fiscal '
  @ 07,04 say 'Ordem Serviço                Recibo              Saída Alt. '
  @ 08,04 say ' Entrada Alt.                 Multa        %     Taxa Juros        %'
  @ 09,04 say 'Máscara Preço                                    Tolerancia     Dias'    
  @ 11,04 say '       Pedido'
  @ 12,04 say '       Recibo'
  @ 15,04 say '       Limite    Linhas            [ ] Imprimir Diretamente' 
  @ 16,04 say '      Comando'
  @ 17,04 say '  Local SPOOL'

  select EmprARQ
  dbsetorder(1)
  dbseek(cEmpresa,.f.)
  
  do while .t.  

    setcolor ( CorCampo )
    @ 19,49 say ' Confirmar '
    @ 19,62 say ' Cancelar '

    setcolor( CorAltKC )
    @ 19,50 say 'C'
    @ 19,64 say 'a'
  
  nReci       := Reci
  nCopiaOS    := CopiaOS
  nCopiaReci  := CopiaReci
  nCopiaNota  := CopiaNota
  nCopiaOPro  := CopiaOpro
  nCopiaFolh  := CopiaFolh
  nConsProd   := ConsProd
  cMensagem   := Mensagem
  cReciTXT1   := ReciTXT1
  cReciTXT2   := ReciTXT2 
  cSPOOL      := SPOOL
  nNota       := Nota
  nPedi       := Pedi
  nEPro       := EPro
  nSPro       := SPro
  nOPro       := OPro
  nOrdS       := OrdS
  nTaxa       := Taxa
  nDias       := Dias
  cImpr       := Impr
  nMulta      := Multa
  nLimite     := Limite
  cComando    := Comando
  cPictPreco  := PictPreco
 
  setcolor ( CorJanel + ',' + CorCampo )
  @ 06,18 get nNota          pict '999999'
  @ 06,25 get nCopiaNota     pict '99'
  @ 06,40 get nOPro          pict '999999'
  @ 06,47 get nCopiaOpro     pict '99'
  @ 06,64 get nPedi          pict '999999'
  @ 07,18 get nOrdS          pict '999999'
  @ 07,25 get nCopiaOS       pict '99'
  @ 07,40 get nReci          pict '999999'
  @ 07,47 get nCopiaReci     pict '99'
  @ 07,64 get nSPro          pict '999999'
  @ 08,18 get nEPro          pict '999999'
  @ 08,40 get nMulta         pict '@E 999.99'
  @ 08,64 get nTaxa          pict '@E 999.99'
  @ 09,18 get cPictPreco     pict '@!' 
  @ 09,64 get nDias          pict '999'
  @ 11,18 get cMensagem      pict '@S52'
  @ 12,18 get cReciTXT1      pict '@S52'
  @ 13,18 get cReciTXT2      pict '@S52'
  @ 15,18 get nLimite        pict '99'
  @ 15,40 get cImpr          pict '@!'
  @ 16,18 get cComando       pict '@S52'
  @ 17,18 get cSPOOL         pict '@S52'
  read

  if lastkey() == K_ESC
    restscreen( 00, 00, 23, 79, tPara )
    return NIL
  endif
  
  aOpcoes := {}

  aadd( aOpcoes, { ' Confirmar ',  2, 'C', 19, 49, "Tecle <ENTER> para Confirmar alterações dos Parametros do Sistema." } )
  aadd( aOpcoes, { ' Cancelar ',   3, 'A', 19, 62, "Tecle <ENTER> para Cancelar alterações dos Parametros do Sistema." } )

  nAltera := HCHOICE( aOpcoes, 2, 1 )
    
  select EmprARQ

  if nAltera == 1
    if RegLock()
      replace Nota       with nNota
      replace Pedi       with nPedi
      replace EPro       with nEPro
      replace SPro       with nSPro
      replace Reci       with nReci
      replace Impr       with cImpr
      replace CopiaReci  with nCopiaReci
      replace CopiaNota  with nCopiaNota
      replace CopiaOS    with nCopiaOS
      replace CopiaOpro  with nCopiaOPro
      replace CopiaFolh  with nCopiaFolh
      replace ReciTXT1   with cReciTXT1
      replace ReciTXT2   with cReciTXT2
      replace OPro       with nOPro
      replace OrdS       with nOrdS
      replace Taxa       with nTaxa
      replace Dias       with nDias
      replace Multa      with nMulta
      replace PictPreco  with cPictPreco
      replace Mensagem   with cMensagem
      replace SPOOL      with cSPOOL
      replace Comando    with cComando
      replace Limite     with nLimite
      dbunlock ()
    endif
    
    if nTaxa > 0
      if NetUse( "ReceARQ", .t. )
        VerifIND( "ReceARQ" )

        pOpenRece := .t.

        #ifdef DBF_NTX
         set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
        #endif  
      else
        pOpenRece := .f.
      endif
       
      select ReceARQ
      set order to 1 
      dbgotop()
      do while !eof()
        if RegLock()
          replace Acre            with nTaxa
          dbunlock()
       endif  
        dbskip()
      enddo
        
      if pOpenRece
        close
      endif  
    endif
  endif
  
    select EmprARQ 
  enddo
  restscreen( 00, 00, 23, 79, tPara )
return NIL