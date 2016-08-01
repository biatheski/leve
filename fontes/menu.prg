﻿//  Leve, Menu pull-down
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
#include "hbextern.ch"

#ifdef RDD_ADS
  #include "ads.ch"

  REQUEST _ADS 
#endif

#ifdef DBF_CDX
  REQUEST DBFCDX
  REQUEST DBFFPT
#endif

REQUEST HB_LANG_PT
REQUEST HB_CODEPAGE_PT850

//REQUEST HB_LANG_PT
//REQUEST HB_CODEPAGE_UTF8EX
 
function main ()
  
  public CorFundo  := "n/w"
  public CorCabec  := "gr+/r"
  public CorMenus  := "w+/b"
  public CorOpcao  := "w+/n"
  public CorBorda  := "g/r"
  public CorJanel  := "w+/bg"
  public CorCampo  := "n/w"
  public CorBorJa  := "w+/bg"
  public CorAltKo  := "gr+/n"
  public CorAltKm  := "gr+/b"
  public CorAltKc  := "gr+/w"
  public CorAcess  := "r/b"

  public lRecado   := .f.
  public lConsulta := .t.

  public EmprClip  := space(40)
  public EmprNume  := space(10)
  public dLogData  := ctod('  /  /  ')
  public cLogHora  := space(08)
  public cStat     := space(04)
  public cEmpresa  := "000001"
  public cAjuda    := space(04)
  public cUsuario  := '000001'
  public cCaminho  := alltrim(dirname())
  public nEstacao  := 0
  public cSavers   := 0
  public pLimite   := 0
  public nMoedaDia := 0
  public cVersao   := '0.990'
  public cIdioma   := '01'

  set path to ( cCaminho )

  set(105,1)  // _SET_FILECASE
  set(106,1)  // _SET_DIRCASE
  
  set(29,1)   // Insert
  
  HB_LANGSELECT( 'PT' )
 	hb_cdpSelect( "UTF8EX" )
  
//  hb_cdpSelect( "PT850" )
  
//  HB_LANGSELECT( 'PT' )
//  HB_CDPSELECT( "UTF8EX" )  
  
//  Set(_SET_CODEPAGE, "PTISO")
//  Hb_GtInfo( HB_GTI_COMPATBUFFER, .F. )
  
//  HB_NOMOUSE()
//  HB_SETCODEPAGE( "PTISO" )
//  HB_SETTERMCP([linux],[acsc])
//  wvt_setcodepage(255)
 
  #ifdef RDD_ADS

    rddRegister( "ADS", 1 )
    rddsetdefaut ( "ADS" )

    set server local
    set filetype to cdx
  #endif

  #ifdef DBF_CDX
    rddsetdefault( "DBFCDX" )
    rddregister( "DBFCDX", 1 )  
  #endif

  InicSoft ()

  do while .t.
    use IndeARQ shared new

    if !neterr ()
      #ifdef DBF_NTX     
        cInde1 := cCaminho + HB_OSpathseparator() + "IndeIND1.NTX"

        if !file( cInde1 )
          index on Arqu to &cInde1
        endif
      
        set index to IndeIND1
      #endif

      #ifdef DBF_CDX
        cInde1 := cCaminho + HB_OSpathseparator() + "IndeIND1.CDX"

        if !file( cInde1 )
          index on Arqu tag &cInde1
        endif
      #endif

      exit
    endif
    inkey(1)
  enddo

  do while .t.
    use MensARQ shared new

    if !neterr ()
      #ifdef DBF_NTX     
        cInde1 := cCaminho + HB_OSpathseparator() + "MensIND1.NTX"
        cInde2 := cCaminho + HB_OSpathseparator() + "MensIND2.NTX"

        if !file( cInde1 )
          index on Idio + Prog + Loca to &cInde1
        endif
        if !file( cInde2 )
          index on Mens to &cInde2
        endif
      
        set index to IndeIND1, IndeIND2
      #endif

      #ifdef DBF_CDX
        if !file( 'MensARQ.CDX' )
          index on Idio + Prog + Loca tag Idio
          index on Mens tag Mens
        endif
      #endif

      exit
    endif
    inkey(1)
  enddo

  do while .t.
    use EstrARQ shared new

    if !neterr ()
      #ifdef DBF_NTX     
        cInde1 := cCaminho + HB_OSpathseparator() + "EstrIND1.NTX"

        if !file( cInde1 )
          index on Arqu + Sequ to &cInde1
        endif
      
        set index to EstrIND1
      #endif

      #ifdef DBF_CDX
        if !file( 'EstrARQ.CDX' )
          index on Arqu + Sequ tag Arqu
        endif
      #endif

      exit
    endif
    inkey(1)
  enddo

  if NetUse( "EmprARQ", .t. )
    VerifIND( "EmprARQ" )

    #ifdef DBF_NTX
      set index to EmprIND1, EmprIND2
    #endif
  endif

  if NetUse( "ParaARQ", .t. )
    VerifIND( "ParaARQ" )

    #ifdef DBF_NTX
      set index to ParaIND1
    #endif
  endif

  select ParaARQ
  set order to 1
  dbgotop()
  if val( Usua ) == 0
    cScreen := "Utilize este espaço para colocar o Nome de sua Empresa !" +;
               "Para editar tecle Ctrl+E e para salvar Ctrl+W" +;
               "Para visualizar a tabela ASCII no sistema tecla Alt+T" +;
               "F2 = 219  F3 = 221  F4 = 223"
 

    if AdiReg()
      if RegLock()
        replace Usua         with "000001"
        replace RCabec       with "gr+/r"
        replace RFundo       with "n/w"
        replace RMenus       with "w+/b"
        replace ROpcao       with "w+/n"
        replace RBorda       with "g/r"
        replace RJanel       with "w+/bg"
        replace RCampo       with "n/w" 
        replace RAltKO       with "gr+/n"
        replace RAltKC       with "gr+/w"
        replace RBorja       with "w+/bg"
        replace RAltKM       with "gr+/b"
        replace RAcess       with "n+/b"
        replace Versao       with encode( "YES" )
        replace Linha        with 5
        replace Coluna       with 17
        replace Roda         with encode( "Sim" )
        replace Screen       with cScreen
        replace TxtOS        with ""
//      replace Dica         with "X"
        replace Tela         with encode( "001" ) 
        dbunlock()
      endif 
    endif
  endif 

  select EmprARQ
  set order to 1
  dbgotop()
  if val( Empr ) == 0
    Janela( 04, 07, 17, 68, mensagem( 'Janela', 'Licenca', .f. ), .t., .f. )
    setcolor( CorJanel )
    @ 06,09 say 'Este programa é gratuito, Fabiano Biatheski não poderá ser'
    @ 07,09 say 'responsabilizado por qualquer tipo de dano causado por seu'
    @ 08,09 say 'uso. Concorda ainda que não existe nenhuma garantia de que'
    @ 09,09 say 'ele realmente irá funcionar no seu computador e que o fato' 
    @ 10,09 say 'de utilizá-lo não lhe dá  direito a nenhum tipo de suporte'
    @ 11,09 say 'técnico, embora você seja bem vindo para postar suas dúvi-'
    @ 12,09 say 'das no forum do produto ou mesmo solicitar  contratação do'
    @ 13,09 say 'suporte técnico pago.'
    
    @ 14,09 say 'Para aceitar pressione a tecla X e ESC para cancelar.'

    @ 16,52 say '[ ]'
    @ 16,56 say 'Eu concordo'
    
    cEu := space(1)
    
    @ 16,53 get cEu   pict "@!" valid cEu == "X" .or. empty( cEu )
    read
    
    if lastkey() == K_ESC
      setcolor ( '+w/n' )
      clear screen
      @ 00, 00 say 'LEVE ' + cVersao 
      @ 02, 00
    
      dbcommitall ()
      dbcloseall ()
   
      set color to
    quit
    
    endif
    Janela( 03, 06, 16, 76, mensagem( "Janela", "Registro", .f. ) + ' ' + cVersao, .f., .f. )
    setcolor( CorJanel )
 
    @ 05,08 say ' Empresa' 
    @ 07,08 say 'Endereço                                  Bairro'
    @ 08,08 say '     CEP              Cidade                  UF'
    @ 09,08 say '    Fone                                     Fax'
    @ 10,08 say '    CNPJ'
    @ 10,42 say 'Insc. Estadual'

    @ 11,06 say chr(195) + replicate( chr(196), 69 ) + chr(180)
    @ 12,08 say 'Fabiano Biatheski                       e-mail: biatheski@gmail.com'
    @ 13,08 say 'Rua João Pessoa, 710 - 107                          skype: fuabiano'
    @ 14,08 say '88801-530 - Criciúma - S.C.                           icq: 56108750'
    @ 15,08 say '48 9904 5857                                   whatsapp: 4899045857'
    
    cNome     := EmprARQ->Nome
    cEmprNome := EmprARQ->Razao
    cEnde     := EmprARQ->Ende
    cBair     := EmprARQ->Bairro 
    cCida     := EmprARQ->Cida
    cFone     := EmprARQ->Fone
    cFax      := EmprARQ->Fax
    nCEP      := EmprARQ->CEP
    cUF       := EmprARQ->UF
    cCGC      := EmprARQ->CGC
    cInscEstd := EmprARQ->InscEstd
   
    setcolor( CorJanel )
    @ 05,17 get cEmprNome            pict '@!'                     valid !empty( cEmprNome )
    @ 07,17 get cEnde                pict '@S30'
    @ 07,57 get cBair                pict '@S15'        
    @ 08,17 get nCEP                 pict '99999-999'
    @ 08,37 get cCida                pict '@S13'
    @ 08,57 get cUF                  pict '@!'    //                 valid ValidUf ( 08, 57, "EmprARQ" ) 
    @ 09,17 get cFone                pict '@S15'
    @ 09,57 get cFax                 pict '@S15'       
    @ 10,17 get cCGC                 pict '@R 99.999.999/9999-99'  valid ValidCGC( cCGC )
    @ 10,57 get cInscEstd            pict '@S15'                      
    read
   
    if lastkey() == K_ESC
      setcolor ( '+w/n' )
      clear screen
      @ 00, 00 say 'LEVE ' + cVersao 
      @ 02, 00
    
      dbcommitall ()
      dbcloseall ()
    
      set color to
      quit
    endif

    cDireto := ''

    for nJ := 1 to len( cEmprNome )
      if nJ > 8 .or. substr( cEmprNome, nJ, 1 ) == ' '
        exit
      endif  

      cDireto += substr( cEmprNome, nJ, 1 )
    next  

    if AdiReg()
      if RegLock()
        replace Empr       with '000001'
        replace Direto     with cDireto
        replace SPOOL      with cCaminho + HB_OSpathseparator() + "SPOOL"
        replace Mensagem   with 'A sua Preferência é a razão de nossa existência'
        replace ReciTxt1   with 'Referente a COMPRA em [Emis] com vencimento para [Vcto] que dou(damos)'
        replace ReciTxt2   with 'plena e geral quitação'
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
        replace Idio       with "01"
        replace Inteira    with "X"
        replace Horario    with "X"
        replace Juro       with "X"
        replace EmprPedi   with "X"
        replace CodBarra   with "X"
        replace Dica       with "X"
        replace CapsLock   with "X"
        replace ReciboTxt  with "X"
        replace Impr       with "X"
        replace ProdSimp   with "X"
        replace InclClie   with 'J'
        replace Recibo     with 1
        replace Pedido     with 1
        replace Relatorio  with 1
        replace NotaFiscal with 1
        replace Duplicata  with 1
        replace Cheque     with 1
        replace Bloqueto   with 1
        replace Produto    with 1
        replace Cliente    with 1
        replace TipoPedi   with 1
        replace TipoReci   with 1
        replace TipoOPro   with 1
        replace Limite     with 64
        replace Idio       with '01'
        replace FontNome   with 'Lucida Console'
        replace FontTama   with 24
        replace FontHeig   with 12
        replace FontWidh   with 0

        replace Nome       with cNome
        replace Razao      with cEmprNome
        replace Ende       with cEnde
        replace Cida       with cCida
        replace Bairro     with cBair
        replace CEP        with nCEP
        replace UF         with cUF
        replace Fone       with cFone
        replace Fax        with cFax
        replace CGC        with cCGC
        replace InscEstd   with cInscEstd
        dbunlock ()
      endif
    endif

    DirMake( cCaminho + HB_OSpathseparator() + "spool" )
    DirMake( cCaminho + HB_OSpathseparator() + "temp" )
    DirMake( cCaminho + HB_OSpathseparator() + "layout" )
  endif
/*
  #ifdef __WVT__
    select EmprARQ
    set order to 1
    dbgotop()

    wvt_setfont( alltrim( FontNome ), FontTama, FontHeig, FontWidh )
  #endif
*/  

  if NetUse( "AjudARQ", .t. )
    VerifIND( "AjudARQ" )

    #ifdef DBF_NTX
      set index to AjudIND1, AjudIND2
    #endif
  endif

  if NetUse( "MenuARQ", .t. )
    VerifIND( "MenuARQ" )

    #ifdef DBF_NTX
      set index to MenuIND1
    #endif
  endif

  if NetUse( "UsuaARQ", .t. )
    VerifIND( "UsuaARQ" )

    #ifdef DBF_NTX
      set index to UsuaIND1, UsuaIND2, UsuaIND3
    #endif
  endif

  select UsuaARQ
  set order to 1
  dbgotop()
  if val( Usua ) == 0
    if AdiReg()
      if RegLock()
        replace Usua             with "000001"
        replace Nome             with "SISTEMA INTEGRADO LEVE " + cVersao
        replace Senha            with Encode(space(12))
        dbunlock ()
      endif
    endif
  endif

  if NetUse( "UsMeARQ", .t. )
    VerifIND( "UsMeARQ" )

    #ifdef DBF_NTX
      set index to UsMeIND1
    #endif
  endif

  select UsMeARQ
  set order to 1
  dbgotop()
  if val( Usua ) == 0
    select MenuARQ
    set order to 1
    dbgotop()
    do while !eof()
      if Idio == "01" .and. Modu == "000001"
        select UsMeARQ
        if AdiReg()
          if RegLock()
            replace Usua    with "000001"
            replace Modu    with MenuARQ->Modu
            replace Menu    with MenuARQ->Menu
            replace Item    with MenuARQ->Item
            dbunlock()
          endif
        endif
        select MenuARQ
      endif
      dbskip()
    enddo
  endif

  if NetUse( "LogoARQ", .t. )
    VerifIND( "LogoARQ" )

    #ifdef DBF_NTX
      set index to LogoIND1
    #endif
  endif

  select LogoARQ
  set order to 1
  dbgotop()
  if Esta == 0
    for nE := 1 to 25
      if AdiReg()
        if RegLock()
          replace Esta    with nE
          dbunlock()
        endif
      endif
    next
  endif

  TelaSoft(.t.)

  select ParaARQ
  set order to 1
  dbseek( cUsuario, .f. )
  if eof()
    dbgotop ()
  endif

  CorFundo := rFundo
  CorCabec := rCabec
  CorMenus := rMenus
  CorOpcao := rOpcao
  CorBorda := rBorda
  CorJanel := rJanel
  CorCampo := rCampo
  CorBorJa := rBorJa
  CorAltKo := rAltKo
  CorAltKm := rAltKm
  CorAltKc := rAltKc

  for i := 1 to len( CorMenus )
    cFundo := substr( CorMenus, i, 1 )
    if cFundo == '/'
      CorAcess := 'n+' + substr ( CorMenus, i  )
      exit
    endif
  next

  setcolor ( CorFundo )
  @ 01,00 clear to 24,79

  setcolor ( CorMenus )
  @ 00,00 say space(80)
  @ 23,00 say space(80)
  @ 23,01 say EmprARQ->Razao
  @ 23,41 say chr(179) + time () + chr(179) + dtoc( date() ) + chr(179) + " LEVE " + cVersao

  setcolor( 'w+/n' )
  @ 00,00 say chr(240)

  mCodMenu := '00.00.00'
  mMenAnt1 := space(08)
  mMenAnt2 := space(08)
  mMenAnt3 := space(08)
  mIteAnt1 := 0
  mIteAnt2 := 0
  mIteAnt3 := 0
  mTamItem := 0
  mCodItem := 0
  mNivel   := 1
  mOpcoes  := {}

  CarMenu  ()
  DispMenu ()
  Logado   ()

  setcolor ( CorFundo )
  @ 01,00 clear to 22,79

  select ParaARQ
  set order to 1
  dbseek( cUsuario, .f. )

  if !empty( ParaARQ->Dica )
    DicaDia ()
  endif

  if empty( ParaARQ->Empresa )
    keyboard(chr(13))
  endif

  VerEmpr(.t.)

  if NetUse( "RecaARQ", .t. )
    VerifIND( "RecaARQ" )

    #ifdef DBF_NTX
      set index to RecaIND1
    #endif
  endif
  
  select RecaARQ
  set order to 1
  dbgotop()
  if !eof()
    lRecado := .t.
  endif  

  if !empty( EmprARQ->Moeda )
    VerMoeda()
  endif

  mPrimeiro := 1
  lTemAcess := .f.
  mCodItem  := AcessMenu()

  if lTemAcess
    LumiMenu()
  endif

  do while .t.
    if mPrimeiro <= 2                             // <POG> Movimentacao do Menu ?! >:-) </POG>
      if mPrimeiro == 1
        mTecla := K_RIGHT
      else
        mTecla := K_ENTER
      endif

      mPrimeiro ++
    else
      mTecla := Teclar(0)
    endif

    if mTecla == K_TAB                           // Troca de Empresa
      VerEmpr(.f.)
    endif

    if mTecla == K_F10 .or. mTecla == K_ALT_F4   // Sair
      Finalizar(.t.)
    endif

    if mTecla == K_F1                      // Ajuda
      cAjuda   := 'Menu'
      lAjuda   := .f.

      Ajuda ()
    endif

    if mTecla == K_F6                      // Calendario
      Calendar()
    endif

    if mTecla == K_F5                      // Protecao tela
      MoviTela()
    endif

    if mTecla == K_F2                      // Consulta
      ConsGeral()
    endif

    if mTecla == K_F3                      // Recados
      Recado()
    endif

    if mTecla == K_F8                      // Database utility
      DBU()
    endif

    if mTecla == K_F9                      // Calculadora
      Calcular()
    endif

    if mTecla == K_ALT_Y                   // Configuracao do menu
      Itme ()
    endif

    if mTecla == K_ALT_M                   // Configuracao de mensagens
      ConsMens ()
    endif

    if mTecla == K_ALT_T                   // Tabela ASCII do sistema
      TabASCII ()
    endif

    if mTecla == K_CTRL_U                  // Consulta usuario
      ConsUsua ()
    endif

    if mTecla == K_ALT_A                   // Menu Arquivo
      if mNivel == 1
        if lTemAcess
          mIteAnt3 := mCodItem

          NormMenu ()

          mCodItem := 2

          if mOpcoes[ mCodItem, 8 ]
            EscuMenu()
            mNivel ++

            mMenAnt1 := mCodMenu
            mIteAnt1 := mCodItem
            mCodMenu := mOpcoes[ mCodItem, 7 ]
            mOpcoes  := {}

            CarMenu ()
            DispMenu ()

            lTemAcess := .f.
            mCodItem  := AcessMenu()

            if lTemAcess
              LumiMenu()
            endif
          else
            mCodItem := mIteAnt3

            LumiMenu ()
          endif
        endif
      endif
    endif

    if mTecla == K_ALT_R                   // Menu Relatorio
      if mNivel == 1
        if lTemAcess
          mIteAnt3 := mCodItem
          NormMenu ()
          mCodItem := 3

          if mOpcoes[ mCodItem, 8 ]
            EscuMenu ()
            mNivel ++

            mMenAnt1 := mCodMenu
            mIteAnt1 := mCodItem
            mCodMenu := mOpcoes[ mCodItem, 7 ]
            mOpcoes  := {}

            CarMenu()
            DispMenu()

            lTemAcess := .f.
            mCodItem  := AcessMenu()

            if lTemAcess
              LumiMenu ()
            endif
          else
            mCodItem := mIteAnt3
            LumiMenu ()
          endif
        endif
      endif
    endif

    if mTecla == K_ALT_P                   // Menu Processos
      if mNivel == 1
        if lTemAcess
          mIteAnt3 := mCodItem
          NormMenu ()
          mCodItem := 4

          if mOpcoes[ mCodItem, 8 ]
            EscuMenu ()
            mNivel ++
            mMenAnt1 := mCodMenu
            mIteAnt1 := mCodItem
            mCodMenu := mOpcoes[ mCodItem, 7 ]
            mOpcoes  := {}

            CarMenu ()
            DispMenu ()

            lTemAcess := .f.
            mCodItem  := AcessMenu()

            if lTemAcess
              LumiMenu()
            endif
          else
            mCodItem := mIteAnt3
            LumiMenu()
          endif
        endif
      endif
    endif

    if mTecla == K_ALT_U                 // Menu Utilitarios
      if mNivel == 1
        if lTemAcess
          mIteAnt3 := mCodItem

          NormMenu()

          mCodItem := 5

          if mOpcoes[ mCodItem, 8 ]
            EscuMenu()
            mNivel ++
            mMenAnt1 := mCodMenu
            mIteAnt1 := mCodItem
            mCodMenu := mOpcoes[ mCodItem, 7 ]
            mOpcoes  := {}

            CarMenu()
            DispMenu()

            lTemAcess := .f.
            mCodItem  := AcessMenu()

            if lTemAcess
              LumiMenu ()
            endif
          else
            mCodItem := mIteAnt3
            LumiMenu ()
          endif
        endif
      endif
    endif

    if mTecla == K_ESC                       // Sair/Retornar
      if mNivel == 1
        Finalizar(.f.)
      else
        setcolor( CorFundo )
        @ 01,00 clear to 22,79

        if mNivel == 4
          mNivel := 3
          mCodMenu := mMenAnt2
          mCodItem := mIteAnt2
          mOpcoes  := {}

          CarMenu()
          DispMenu()
          EscuMenu()

          mNivel := 4
          mCodMenu := mMenAnt3
          mCodItem := mIteAnt3
        endif

        if mNivel == 3
          mCodMenu := mMenAnt2
          mCodItem := mIteAnt2
        endif

        if mNivel == 2
          mCodMenu := mMenAnt1
          mCodItem := mIteAnt1
        endif

        mNivel --
        mOpcoes  := {}

        CarMenu ()
        DispMenu ()

        lTemAcess := .t.
        if lTemAcess
          LumiMenu()
        endif
      endif
    endif

    if mTecla == K_LEFT                          // Seta Esquerda
      if mNivel == 1
        if lTemAcess
          NormMenu()
          mCodItem --
          if mCodItem < 1
            mCodItem := len( mOpcoes )
          endif
          LumiMenu ()
        endif
      else
        if mNivel == 2
          setcolor( CorFundo )
          @ 01,00 clear to 22,79

          mCodMenu  := mMenAnt1
          mCodItem  := mIteAnt1
          lTemAcess := .t.
          mOpcoes   := {}
          mNivel    := 1

          CarMenu  ()
          DispMenu ()

          do while .t.
            mCodItem --
            if mCodItem < 1
              mCodItem := len( mOpcoes )
            endif

            if mOpcoes[ mCodItem, 8 ]
              if alltrim( mOpcoes[ mCodItem, 1 ] ) != "-"
               exit
              endif
            endif
          enddo

          EscuMenu()

          mNivel   := 2
          mMenAnt1 := mCodMenu
          mIteAnt1 := mCodItem
          mCodMenu := mOpcoes[ mCodItem, 7 ]
          mOpcoes  := {}

          CarMenu()
          DispMenu()

          lTemAcess := .f.
          mCodItem  := AcessMenu()

          if lTemAcess
            LumiMenu()
          endif
        else
          setcolor( CorFundo )
          @ 01,00 clear to 22,79

          if mNivel == 4
             mNivel := 3
             mCodMenu := mMenAnt2
             mCodItem := mIteAnt2
             mOpcoes  := {}

             CarMenu()
             DispMenu()
             EscuMenu()

             mNivel := 4
             mCodMenu := mMenAnt3
             mCodItem := mIteAnt3
          endif

          if mNivel == 3
             mCodMenu := mMenAnt2
             mCodItem := mIteAnt2
          endif

          mNivel  --
          mOpcoes := {}

          CarMenu ()
          DispMenu ()

          lTemAcess := .t.
          if lTemAcess
             LumiMenu()
          endif
        endif
      endif
    endif

    if mTecla == K_RIGHT                           // Seta Direita
      if mNivel == 1
        if lTemAcess
          NormMenu()
          mCodItem ++
          if mCodItem > len( mOpcoes )
            mCodItem := 1
          endif

          LumiMenu ()
        endif
      else
        if mNivel == 2
          setcolor( CorFundo )
          @ 01,00 clear to 22,79
          mCodMenu  := mMenAnt1
          mCodItem  := mIteAnt1
          lTemAcess := .t.
          mOpcoes   := {}
          mNivel    := 1

          CarMenu()
          DispMenu()

          do while .t.
            mCodItem ++
            if mCodItem > len( mOpcoes )
              mCodItem := 1
            endif
            if mOpcoes[ mCodItem, 8 ]
              if alltrim( mOpcoes[ mCodItem, 1 ] ) != "-"
                exit
              endif
            endif
          enddo

          EscuMenu ()

          mNivel   := 2
          mMenAnt1 := mCodMenu
          mIteAnt1 := mCodItem
          mCodMenu := mOpcoes[ mCodItem, 7 ]
          mOpcoes  := {}

          CarMenu()
          DispMenu()

          lTemAcess := .f.
          mCodItem  := AcessMenu()
          if lTemAcess
            LumiMenu()
          endif
        else
          setcolor( CorFundo )
          @ 01,00 clear to 22,79

          if mNivel == 4
             mNivel := 3
             mCodMenu := mMenAnt2
             mCodItem := mIteAnt2
             mOpcoes  := {}

             CarMenu()
             DispMenu()
             EscuMenu()

             mNivel := 4
             mCodMenu := mMenAnt3
             mCodItem := mIteAnt3
          endif

          if mNivel == 3
             mCodMenu := mMenAnt2
             mCodItem := mIteAnt2
          endif


          mNivel --
          mOpcoes  := {}

          CarMenu ()
          DispMenu ()

          lTemAcess := .t.
          if lTemAcess
             LumiMenu()
          endif
        endif
      endif
    endif

    if mTecla == K_DOWN                           // Seta Baixo
      if mNivel == 1
        if lTemAcess
          EscuMenu()
          mNivel ++

          mMenAnt1 := mCodMenu
          mIteAnt1 := mCodItem
          mCodMenu := mOpcoes[ mCodItem, 7 ]
          mOpcoes  := {}

          CarMenu()
          DispMenu()

          lTemAcess := .f.
          mCodItem  := AcessMenu()

          if lTemAcess
            LumiMenu()
          endif
        endif
      else
        if lTemAcess
          NormMenu()
          do while .t.
            mCodItem++
            if mCodItem > len( mOpcoes )
              mCodItem := 1
            endif

            if mOpcoes[ mCodItem, 8 ]
              if alltrim( mOpcoes[ mCodItem, 1 ] ) != "-"
                exit
              endif
            endif
          enddo
          LumiMenu()
        endif
      endif
    endif

    if mTecla == K_UP                      // Seta Acima
      if mNivel == 1
        Finalizar(.f.)
      else
        if lTemAcess
          NormMenu()
          do while .t.
            mCodItem --
            if mCodItem < 1
              mCodItem := len( mOpcoes )
            endif

            if mOpcoes[ mCodItem, 8 ]
              if alltrim( mOpcoes[ mCodItem, 1 ] ) != "-"
                exit
              endif
            endif
          enddo
          LumiMenu()
        endif
      endif
    endif

    if mTecla >= 32 .and. mTecla <= 128
      if lTemAcess
        if mNivel == 1
          if mTecla == 97  .or. mTecla == 65
            mTecla := 134
          endif

          if mTecla == 112 .or. mTecla == 80
            mTecla := 149
          endif

          if mTecla == 114 .or. mTecla == 82
            mTecla := 151
          endif

          if mTecla == 117 .or. mTecla == 85
            mTecla := 154
          endif
        endif

        mLetra := upper( chr( mTecla ) )

        NormMenu()

        mIteAux  := mCodItem
        lTemLet  := .f.
        do while .t.
          mCodItem ++
          if mCodItem > len( mOpcoes )
            exit
          else
            if mOpcoes[ mCodItem, 8 ]
              if alltrim( mOpcoes[ mCodItem, 1 ] ) != "-"
                if upper( subst( mOpcoes[ mCodItem, 1 ],  mOpcoes[ mCodItem, 2 ] , 1 ) ) == mLetra
                  mIteAux := mCodItem
                  lTemLet := .t.
                  mTecla  := K_ENTER
                  exit
                endif
              endif
            endif
          endif
        enddo

        if ! lTemLet
          mCodItem := 0
          do while .t.
            mCodItem ++
            if mCodItem > mIteAux
              exit
            else
              if mOpcoes[ mCodItem, 8 ]
                if alltrim( mOpcoes[ mCodItem, 1 ] ) != "-"
                  if upper( subst( mOpcoes[ mCodItem, 1 ],  mOpcoes[ mCodItem, 2 ] , 1 )  ) == mLetra
                    mIteAux := mCodItem
                    lTemLet := .t.
                    mTecla  := K_ENTER
                    exit
                  endif
                endif
              endif
            endif
          enddo
        endif

        mCodItem := mIteAux
        LumiMenu()
      endif
    endif

    if mTecla == K_ENTER .or. mTecla == K_SPACE
      if lTemAcess
        if mNivel == 1
          if mOpcoes[ mCodItem, 8 ]
            mNivel ++
            mMenAnt1 := mCodMenu
            mIteAnt1 := mCodItem
            mCodMenu := mOpcoes[ mCodItem, 7 ]
            mOpcoes  := {}

            CarMenu ()
            DispMenu ()

            lTemAcess := .f.
            mCodItem  := AcessMenu()

            if lTemAcess
              LumiMenu()
            endif
          endif
        else
          if mOpcoes[ mCodItem, 8 ]
            if mOpcoes[ mCodItem, 6 ]
              if ! empty( mOpcoes[ mCodItem, 7 ] )
                cAjuda    := 'Menu'
                lAjuda    := .f.
                mPrograma := mOpcoes[ mCodItem, 7 ]
                tSalvTela := savescreen( 00, 00, 24, 79 )
                mCor      := setcolor()

                nLenPrg   := len( alltrim( mPrograma ) )
                pPara01   := pPara02 := pPara03 := pPara04 := pPara05 := ''

                for nW := 1 to nLenPrg
                  xLetra := substr( mPrograma, nW, 1 )
                  if xLetra == '('
                    exit
                  endif
                next

                xParam  := alltrim( substr( mPrograma, nW ) )
                mPrg    := alltrim( substr( mPrograma, 1, nW - 1 ) )
                nLenPrg := len( xParam ) - 1
                nPosIni := 2
                xVaria  := 1

                for nS := 2 to nLenPrg
                  xLetra := substr( xParam, nS, 1 )

                  if xLetra == ','
                    cVaria := strzero( xVaria, 2 )
                    do case
                      case alltrim( substr( xParam, nPosIni, nS - 2 ) ) == '.t.'
                        pPara&cVaria := .t.
                      case alltrim( substr( xParam, nPosIni, nS - 2 ) ) == '.f.'
                        pPara&cVaria := .f.
                      otherwise
                        pPara&cVaria := alltrim( substr( xParam, nPosIni, nS - 2 ) )
                    endcase

                    nPosIni := nS + 1
                    xVaria  ++
                  endif
                next

                cVaria  := strzero( xVaria, 2 )
                nPosFin := ( nLenPrg - nPosIni ) + 1

                do case
                  case alltrim( substr( xParam, nPosIni, nPosFin ) ) == '.t.'
                    pPara&cVaria := .t.
                  case alltrim( substr( xParam, nPosIni, nPosFin ) ) == '.f.'
                    pPara&cVaria := .f.
                  otherwise
                    pPara&cVaria := alltrim( substr( xParam, nPosIni, nPosFin ) )
                endcase

                &mPrg( pPara01, pPara02, pPara03, pPara04, pPara05 )

                mOpcoes := {}

                CarMenu()
                DispMenu()
                LumiMenu()

                restscreen( 00, 00, 24, 79, tSalvTela )
                setcolor( mCor )
              else
                setcolor( CorFundo )
                @ 01,00 clear to 22,79

                mNivel   := 1
                mCodMenu := '00.00.00'

                mOpcoes  := {}

                CarMenu()
                DispMenu()

                lTemAcess := .f.
                mCodItem  := AcessMenu()

                if lTemAcess
                  LumiMenu()
                endif

                @ 23,41 say chr(179) + time () + chr(179) + dtoc( date() ) + chr(179) + " LEVE " + cVersao
              endif
            else
              if ! empty( mOpcoes[ mCodItem, 7 ] )
                EscuMenu()

                if mNivel == 2
                  mMenAnt2 := mCodMenu
                  mIteAnt2 := mCodItem
                endif
                if mNivel == 3
                  mMenAnt3 := mCodMenu
                  mIteAnt3 := mCodItem
                endif
                mNivel ++

                mCodMenu := mOpcoes[ mCodItem, 7 ]
                mOpcoes  := {}

                CarMenu()
                DispMenu()

                lTemAcess := .f.
                mCodItem  := AcessMenu()

                if lTemAcess
                  LumiMenu()
                endif
              else
                setcolor( CorFundo )
                @ 01,00 clear to 22,79

                mNivel   := 1
                mCodMenu := '00.00.00'

                mOpcoes  := {}

                CarMenu()
                DispMenu()

                lTemAcess := .f.
                mCodItem  := AcessMenu()

                if lTemAcess
                  LumiMenu()
                endif

                @ 23,41 say chr(179) + time () + chr(179) + dtoc( date() ) + chr(179) + " LEVE " + cVersao
              endif
            endif
          endif
        endif
      endif
    endif
enddo

return NIL

//
// Consulta Usuario Corrente
//
function ConsUsua ()
  tUsua := savescreen( 00, 00, 23, 79 )
  
  Janela( 08, 17, 16, 59, mensagem( 'Janela', 'ConsUsua', .f. ), .f. )
  Mensagem( "Consulta de Usuário." )
  
  setcolor( CorJanel )
  @ 10,20 say "Usuário"
  @ 11,20 say "    Dia" 
  @ 12,20 say "   Hora" 
  @ 13,20 say "  Tempo"
  @ 15,34 say "Logado na estação n. "

  nTempo := sectotime( timetosec( time() ) - timetosec( cLogHora ) )
  
  setcolor( CorCampo )
  @ 10,28 say UsuaARQ->Nome  pict "@S30" 
  @ 11,28 say dLogData       pict "99/99/99"
  @ 12,28 say cLogHora     
  @ 13,28 say nTempo
  @ 15,55 say nEstacao       pict "999"

  Teclar(0)
  
  restscreen( 00, 00, 23, 79, tUsua )
return NIL

//
//
//
function CarMenu()
  mTamItem := 0

  select MenuARQ
  set order to 1
  dbseek( cIdioma + cEmpresa + mCodMenu, .t. )

  if ( Modu != cEmpresa .and. Menu != mCodMenu .and. Idio != cIdioma )
    Alerta( mensagem( "Alerta", "CarMenu", .f. ) )
  endif

  do while Modu == cEmpresa .and. Menu == mCodMenu .and. Idio == cIdioma
    select UsMeARQ
    set order to 1
    dbseek( cUsuario + cEmpresa + mCodMenu + MenuARQ->Item, .f. )
    if !found()
      select MenuARQ
      
      nAltKey := iif( at( "&", Desc ) == 0, 0, at( "&", Desc ) + 1 )
      
      if mNivel != 1
        aadd( mOpcoes, { " " + strtran( left( Desc, Tama + 1 ), "&", "" ), nAltKey, Linh, Colu, Mens, ExPr, alltrim( Acao ), .f. } )
      else
        aadd( mOpcoes, { " " + strtran( left( Desc, Tama + 1 ), "&", "" ) + " ", nAltKey, Linh, Colu, Mens, ExPr, alltrim( Acao ), .f. } )
      endif
    else
      select MenuARQ

      nAltKey := iif( at( "&", Desc ) == 0, 0, at( "&", Desc ) + 1 )

      if mNivel != 1
        aadd( mOpcoes, { " " + strtran( left( Desc, Tama + 1 ), "&", "" ), nAltKey, Linh, Colu, Mens, ExPr, alltrim( Acao ), .t. } )
      else
        aadd( mOpcoes, { " " + strtran( left( Desc, Tama + 1 ), "&", "" ) + " ", nAltKey, Linh, Colu, Mens, ExPr, alltrim( Acao ), .t. } )
      endif
    endif

    if mNivel != 1
      if len( " " + strtran( left( Desc, Tama ), "&", "" ) ) > mTamItem
        mTamItem := len( " " + strtran( left( Desc, Tama ), "&", "" ) )
      endif
    else
      if len( " " + strtran( left( Desc, Tama ), "&", "" ) + " " ) > mTamItem
        mTamItem := len( " " + strtran( left( Desc, Tama ), "&", "" ) + " " )
      endif
    endif

    dbskip ()
  enddo
return NIL

//
//
//
function DispMenu()
  if mTamItem == 25
    mTamItem ++
  endif  
 
  if mNivel > 1
    setcolor( CorMenus )
    @ ( mOpcoes[ 1, 3 ] - 1), ( mOpcoes[ 1, 4 ] - 1 ) say chr(218) + replicate( chr(196), mTamItem ) + chr(191)
  endif

  nTama := len( mOpcoes )

  if mNivel > 1
    Sombra( ( mOpcoes[ 1, 3 ] - 1 ),( mOpcoes[ 1, 4 ] - 1 ), ( mOpcoes[ nTama, 3 ] + 1), ( mOpcoes[ nTama, 4 ] + mTamItem ) )
  endif

  if mNivel > 1
    setcolor( CorMenus )
    @ ( mOpcoes[ nTama, 3 ] + 1 ), ( mOpcoes[ nTama, 4 ] - 1 ) say chr(192) + replicate( chr(196), mTamItem ) + chr(217)
  endif
  
  for x := 1 to nTama
    if mNivel > 1
      if len( mOpcoes[ x, 1 ] ) < mTamItem
        mOpcoes[ x, 1] := mOpcoes[ x, 1 ] + space( mTamItem - len( mOpcoes[ x, 1 ] ) )
      endif
    endif

    if mOpcoes[ x, 8 ]
      setcolor( CorMenus )
      if alltrim( mOpcoes[ x, 1 ] ) == "-"
        @ mOpcoes[ x, 3 ], ( mOpcoes[ x, 4 ] - 1 ) say chr(195) + replicate(chr(196),mTamItem ) + chr(180)
      else
        if mNivel = 1
          @ mOpcoes[ x, 3 ], mOpcoes[ x, 4 ] say left(mOpcoes[ x, 1 ],mTamItem)
        else
          @ mOpcoes[ x, 3 ], ( mOpcoes[ x, 4 ] - 1 ) say chr(179) + left(mOpcoes[ x, 1 ],mTamItem) + chr(179)
        endif
      endif
      if mOpcoes[ x, 2 ] != 0
        setcolor( CorAltKm )
        @ mOpcoes[ x, 3 ], ( ( mOpcoes[ x, 4 ] + mOpcoes[ x, 2 ] ) - 1 ) say subst( mOpcoes[ x, 1 ],  mOpcoes[ x, 2 ] , 1 )
      endif
    else
      if alltrim( mOpcoes[ x, 1 ] ) == "-"
        setcolor( CorMenus)
        @ mOpcoes[ x, 3 ], ( mOpcoes[ x, 4 ] - 1 ) say chr(195) + replicate( chr(196), mTamItem ) + chr(180)
      else
        setcolor( CorMenus )
        @ mOpcoes[ x, 3 ], ( mOpcoes[ x, 4 ] - 1 ) say chr(179) + space( mTamItem ) + chr(179)
        setcolor( CorAcess )
        @ mOpcoes[ x, 3 ], mOpcoes[ x, 4 ] say mOpcoes[ x, 1 ]
      endif
    endif
 next
return NIL

//
//
//
function AcessMenu()
  mCodItem := 1
  nTama    := len( mOpcoes )
 
  for x := 1 to nTama
    if mOpcoes[ x, 8 ]
      lTemAcess := .t.
      mCodItem  := x
      exit
    endif
  next
return mCodItem

//
//
//
function LumiMenu()
  if mOpcoes[ mCodItem, 8 ]
    setcolor( CorOpcao )
    @ mOpcoes[ mCodItem, 3 ], mOpcoes[ mCodItem, 4 ] say mOpcoes[ mCodItem, 1 ]

    if mOpcoes[ mCodItem, 2 ] != 0
      setcolor( CorAltko )
      @ mOpcoes[ mCodItem, 3 ], ( ( mOpcoes[ mCodItem, 4 ] + mOpcoes[ mCodItem, 2 ] ) - 1 ) say subst( mOpcoes[ mCodItem, 1 ],  mOpcoes[ mCodItem, 2 ] , 1 )
    endif
    
    Mensagem( mOpcoes[ mCodItem, 5 ] )
  endif
return NIL

//
//
//
function NormMenu()
  if mOpcoes[ mCodItem, 8 ]
    setcolor( CorMenus )
    @ mOpcoes[ mCodItem, 3 ], mOpcoes[ mCodItem, 4 ] say mOpcoes[ mCodItem, 1 ]

    if mOpcoes[ mCodItem, 2 ] != 0
      setcolor( CorAltkm )
      @ mOpcoes[ mCodItem, 3 ], ( ( mOpcoes[ mCodItem, 4 ] + mOpcoes[ mCodItem, 2 ] ) - 1 ) say subst( mOpcoes[ mCodItem, 1 ],  mOpcoes[ mCodItem, 2 ] , 1 )
    endif
  endif
return NIL

function EscuMenu()
  setcolor( CorMenus )
  nTama := len( mOpcoes )
  for x := 1 to nTama
    if mOpcoes[ x, 8 ]
      if alltrim( mOpcoes[ x, 1 ] ) != "-"
        @ mOpcoes[ x, 3 ], mOpcoes[ x, 4 ] say mOpcoes[ x, 1 ]
      endif
    endif
  next
  
  setcolor( CorOpcao )
  @ mOpcoes[ mCodItem, 3 ], mOpcoes[ mCodItem, 4 ] say mOpcoes[ mCodItem, 1 ]
return NIL

//
// Criar Etiqueta
//  
function CriaEtq ()
  local tModi := savescreen( 00, 00, 23, 79 ) 

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
  
  select EtiqARQ
  set order to 2
  Janela( 05, 15, 17, 63, mensagem( 'Janela', 'CriaEtiq', .f. ), .f. )  
  Mensagem(  'Menu', 'CriaEtiq' )

  setcolor( CorJanel + ',' + CorCampo )
  oEtiqueta           := TBrowseDB( 07, 16, 15, 62 )
  oEtiqueta:headsep   := chr(194)+chr(196)
  oEtiqueta:colsep    := chr(179)
  oEtiqueta:footsep   := chr(193)+chr(196)
  oEtiqueta:colorSpec := CorJanel
 
  oEtiqueta:addColumn( TBColumnNew( 'Descrição', {|| left( Desc, 25 ) } ) )
  oEtiqueta:addColumn( TBColumnNew( 'Col.',       {|| iif( Colu == 1, ' 80', '132' ) } ) )
  oEtiqueta:addColumn( TBColumnNew( 'Com.',       {|| iif( Comp == 1, 'Sim', 'Não' ) } ) )
  oEtiqueta:addColumn( TBColumnNew( 'Esp.',       {|| iif( Espa == 1, '1/6' + chr(34), '1/8' + chr(34) ) } ) )
  oEtiqueta:addColumn( TBColumnNew( 'Tama.',      {|| Tama } ) )
  oEtiqueta:addColumn( TBColumnNew( 'Altura',     {|| QtLinha } ) )
  oEtiqueta:addColumn( TBColumnNew( 'Colunas',    {|| Colunas } ) )
  oEtiqueta:addColumn( TBColumnNew( 'Distancia',  {|| Distancia } ) )
  oEtiqueta:addColumn( TBColumnNew( 'Salto',      {|| Salto } ) )

  oEtiqueta:goTop ()

  lExitRequested := .f.
  nLinBarra      := 1
  cAjuda         := 'Etiq'
  lAjud          := .f.
  cLetra         := ''
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 08, 15, 63, nTotal )

  setcolor ( CorCampo )
  @ 16,26 say space(32)

  setcolor( CorJanel + ',' + CorCampo )
  @ 08,15 say chr(195)
  @ 15,15 say chr(195)
  @ 16,17 say 'Consulta'
    
  do while !lExitRequested
    Mensagem( 'Menu', 'CriaEtiq2' )

    oEtiqueta:forcestable() 
    
    iif( BarraSeta, BarraSeta( nLinBarra, 08, 15, 63, nTotal ), NIL )
       
    if oEtiqueta:stable
      if oEtiqueta:hitTop .or. oEtiqueta:hitBottom
        tone( 125, 0 )        
      endif  
      
      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oEtiqueta:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oEtiqueta:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
      
    do case
      case cTecla == K_DOWN;       oEtiqueta:down()
      case cTecla == K_UP;         oEtiqueta:up()
      case cTecla == K_PGDN;       oEtiqueta:pageDown()
      case cTecla == K_PGUP;       oEtiqueta:pageUp()
      case cTecla == K_LEFT;       oEtiqueta:left()
      case cTecla == K_RIGHT;      oEtiqueta:right()
      case cTecla == K_CTRL_PGUP;  oEtiqueta:goTop()
      case cTecla == K_CTRL_PGDN;  oEtiqueta:goBottom()
      case cTecla == K_F1;         Ajuda ()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_ALT_A
        tFiscal := savescreen( 00, 00, 23, 79 )
        
        Janela( 06, 07, 15, 67, mensagem( 'Janela', 'CriaEtiq2', .f. ), .f. ) 
        Mensagem( 'Menu', 'CriaEtiq3' )

        setcolor( CorJanel + ',' + CorCampo )
        @ 08,09 say '   Descrição'
        @ 09,09 say '  Impressora                       Compactar'
        @ 10,09 say ' Espaçamento'
        @ 12,09 say 'Largura Etq.     Letras               Altura     Linhas'
        @ 13,09 say 'Qtd. Colunas                       Distancia     Letras'
        @ 14,09 say '       Salto     Linhas'

        cDesc      := Desc
        nColu      := Colu
        nComp      := Comp
        nEspa      := Espa
        nTama      := Tama
        nQtLinha   := QtLinha
        nColunas   := Colunas
        nDistancia := Distancia
        nSalto     := Salto
        
        setcolor( CorCampo )
        @ 08,22 say space(30)
        @ 09,22 say ' 80 Col '
        @ 09,31 say ' 132 Col '
        @ 09,54 say ' Sim '
        @ 09,60 say ' Não '
        @ 10,22 say ' 1/6" '
        @ 10,29 say ' 1/8" '

        setcolor( CorAltKC )
        @ 09,23 say '8'
        @ 09,32 say '1'
        @ 09,55 say 'S'
        @ 09,61 say 'N'
        @ 10,23 say '1'
        @ 10,32 say '8'
        
        setcolor( CorOpcao )
        if nColu == 1
          @ 09,22 say ' 80 Col '
        else  
          @ 09,31 say ' 132 Col '
        endif
        if nComp == 1  
          @ 09,54 say ' Sim '
        else  
          @ 09,60 say ' Não '
        endif
        if nEspa == 1  
          @ 10,22 say ' 1/6" '
        else  
          @ 10,29 say ' 1/8" '
        endif  

        setcolor( CorAltKO )
        if nColu == 1
          @ 09,23 say '8'
        else  
          @ 09,32 say '1'
        endif
        if nComp == 1  
          @ 09,55 say 'S'
        else  
          @ 09,61 say 'N'
        endif  
        if nEspa == 1
          @ 10,23 say '1'
        else  
          @ 10,32 say '8'
        endif  

        setcolor( CorCampo )
        @ 12,22 say nTama                     pict '999'
        @ 12,54 say nQtLinha                  pict '999'
        @ 13,22 say nColunas                  pict '999'
        @ 13,54 say nDistancia                pict '999'
        @ 14,22 say nSalto                    pict '999'

        setcolor( CorJanel )
        @ 08,22 get cDesc                     pict '@!'
        read

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        aOpc := {}

        aadd( aOpc, { ' 80 Col ', 2,  '8', 09, 22, "Impressora 80 coluna." } )
        aadd( aOpc, { ' 132 Col ', 2, '1', 09, 31, "Impressora 132 colunas." } )

        nColu := HCHOICE( aOpc, 2, nColu )

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        aOpc := {}

        aadd( aOpc, { ' Sim ', 2, 'S', 09, 54, "Compactar a letra. (Letra Menor)" } )
        aadd( aOpc, { ' Não ', 2, 'N', 09, 60, "Não Compactar a letra. (Letra Normal)" } )

        nComp := HCHOICE( aOpc, 2, nComp )

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        aOpc  := {}

        aadd( aOpc, { ' 1/6" ', 2, '1', 10, 22, "Configurar o espaçamento entre linha. (Espaçamento Maior)" } )
        aadd( aOpc, { ' 1/8" ', 4, '8', 10, 29, "Configurar o espaçamento entre linha. (Espaçamento Menor)" } )

        nEspa := HCHOICE( aOpc, 2, nEspa )

        setcolor( CorJanel )
        @ 12,22 get nTama                     pict '999'
        @ 12,54 get nQtLinha                  pict '999'
        @ 13,22 get nColunas                  pict '999'
        @ 13,54 get nDistancia                pict '999'
        @ 14,22 get nSalto                    pict '999'
        read
        
        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        select EtiqARQ
        set order to 1
 
        if RegLock()
          replace Desc            with cDesc
          replace Colu            with nColu
          replace Comp            with nComp
          replace Espa            with nEspa
          replace Tama            with nTama   
          replace QtLinha         with nQtLinha   
          replace Colunas         with nColunas   
          replace Distancia       with nDistancia 
          replace Salto           with nSalto     
          dbunlock ()
        endif
         
        Etiqueta ()  

        restscreen( 00, 00, 23, 79, tFiscal )

        oEtiqueta:refreshAll()
      case cTecla == K_INS
        tFiscal := savescreen( 00, 00, 23, 79 )
        
        Janela( 06, 07, 15, 67, mensagem( 'Janela', 'CriaEtiq2', .f. ), .f. )
        Mensagem( 'Menu', 'CriaEtiq3' )

        setcolor( CorJanel + ',' + CorCampo )
        @ 08,09 say '   Descrição'
        @ 09,09 say '  Impressora                       Compactar'
        @ 10,09 say ' Espaçamento'
        @ 12,09 say 'Largura Etq.     Letras               Altura     Linhas'
        @ 13,09 say 'Qtd. Colunas                       Distancia     Letras'
        @ 14,09 say '       Salto     Linhas'
        
        setcolor( CorCampo )
        @ 08,22 say space(30)
        @ 09,22 say ' 80 Col '
        @ 09,31 say ' 132 Col '
        @ 09,54 say ' Sim '
        @ 09,60 say ' Não '
        @ 10,22 say ' 1/6" '
        @ 10,29 say ' 1/8" '

        setcolor( CorAltKC )
        @ 09,23 say '8'
        @ 09,32 say '1'
        @ 09,55 say 'S'
        @ 09,61 say 'N'
        @ 10,23 say '1'
        @ 10,32 say '8'

        cDesc      := space(30)
        nColu      := 1
        nComp      := 1
        nEspa      := 1
        nTama      := 0
        nQtLinha   := 0
        nColunas   := 0
        nDistancia := 0
        nSalto     := 0

        setcolor( CorCampo )
        @ 12,22 say nTama                     pict '999'
        @ 12,54 say nQtLinha                  pict '999'
        @ 13,22 say nColunas                  pict '999'
        @ 13,54 say nDistancia                pict '999'
        @ 14,22 say nSalto                    pict '999'

        setcolor( CorJanel )
        @ 08,22 get cDesc                     pict '@!'
        read

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        aOpc := {}

        aadd( aOpc, { ' 80 Col ', 2,  '8', 09, 22, "Impressora 80 coluna." } )
        aadd( aOpc, { ' 132 Col ', 2, '1', 09, 31, "Impressora 132 colunas." } )

        nColu := HCHOICE( aOpc, 2, nColu )

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        aOpc := {}

        aadd( aOpc, { ' Sim ', 2, 'S', 09, 54, "Compactar a letra. (Letra Menor)" } )
        aadd( aOpc, { ' Não ', 2, 'N', 09, 60, "Não Compactar a letra. (Letra Normal)" } )

        nComp := HCHOICE( aOpc, 2, nComp )

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        aOpc  := {}

        aadd( aOpc, { ' 1/6" ', 2, '1', 10, 22, "Configurar o espaçamento entre linha. (Espaçamento Maior)" } )
        aadd( aOpc, { ' 1/8" ', 4, '8', 10, 29, "Configurar o espaçamento entre linha. (Espaçamento Menor)" } )

        nEspa := HCHOICE( aOpc, 2, nEspa )

        setcolor( CorJanel )
        @ 12,22 get nTama                     pict '999'
        @ 12,54 get nQtLinha                  pict '999'
        @ 13,22 get nColunas                  pict '999'
        @ 13,54 get nDistancia                pict '999'
        @ 14,22 get nSalto                    pict '999'
        read
        
        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        select EtiqARQ
        set order to 1
        dbgobottom ()

        nCod := Codigo + 1
        
        if AdiReg()
          if RegLock()
            replace Desc            with cDesc
            replace Colu            with nColu
            replace Comp            with nComp
            replace Espa            with nEspa
            replace Codigo          with nCod
            replace Tama            with nTama   
            replace QtLinha         with nQtLinha   
            replace Colunas         with nColunas   
            replace Distancia       with nDistancia 
            replace Salto           with nSalto     
            dbunlock ()
          endif
        endif
        
        cTexto := ''

        for nL := 1 to QtLinha
          cTexto += space( nTama )
        next

        if RegLock()
          replace Layout         with cTexto
          dbunlock ()
        endif

        Etiqueta ()  

        restscreen( 00, 00, 23, 79, tFiscal )

        oEtiqueta:refreshAll()
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
        oEtiqueta:refreshAll()
      case cTecla == K_DEL
        if RegLock()
          dbdelete ()  
          dbunlock ()
        endif  
        
        oEtiqueta:refreshAll()
      case cTecla == K_ENTER
        Etiqueta ()  
    endcase
  enddo  
  
  select EtiqARQ
  close
  select CampARQ
  close
  
  restscreen( 00, 00, 23, 79, tModi )
return NIL  

//
// Layout da Etiqueta
//
function Etiqueta ()
  local tFisc := savescreen( 00, 00, 23, 79 )

  Janela( 01, 01, 21, 78, mensagem( 'Janela', 'Etiqueta', .f. ), .F. )
  Mensagem( "Menu", "Etiqueta" )
                     
  cLayout := Layout
  cLayout := memoedit( cLayout, 02, 03, 20, 77, .t., "OutMemos", Tama + 1, , , 1, 0 )
  
  select EtiqARQ
  
  if lastkey() == K_CTRL_W   
    if RegLock()
      replace Layout         with cLayout
      dbunlock ()
    endif
  endif  

  restscreen( 00, 00, 23, 79, tFisc )
return NIL

function OutMemos( wModo, wlin , wCol )
  setcolor( CorCabec )
  @ 01,60 say "Lin: " + str( wLin, 2 ) + " Col: " + str( wCol, 3 )

  setcolor( CorJanel )
  nKey      := lastkey()
  cRetVal   := 0

  do case 
    case nKey == K_CTRL_RET;      cRetVal := K_ESC
    case nKey == K_ALT_F
      Aguarde ()
      
      if !TestPrint(1)
        set device to screen
        return NIL
      endif     

      setprc( 0, 0 )

      if Comp == 1
        @ 00,00 say chr(15)
      else  
        @ 00,00 say chr(18)
      endif  
      
      if Espa == 1
        @ 00,00 say chr(27) + '@'
      else
        @ 00,00 say chr(27) + chr(48)
      endif  
      
      if Tama == 132
        cLinha := '123456789d123456789v123456789t123456789q123456789c123456789s123456789s123456789o123456789n123456789c123456789d123456789v123456789 '
      else
        cLinha := '123456789d123456789v123456789t123456789q123456789c123456789s123456789s12345678 '
      endif  
      
      nLin := 0
        
      for nLinhas := 1 to QtLinha
        @ nLin,00 say cLinha + strzero( nLinhas, 2 )
        nLin ++
      next

      set device to screen
    case nKey == K_F4
      CadeCampo ()
  endcase

  Mensagem( "Menu", "Etiqueta" )
  
  setcolor( CorJanel )
return( cRetVal )

//
// Retorna as cores padrao do sistema
//
function Padrao ()
  
  select ParaARQ
  set order to 1
  dbseek( cUsuario, .f. )
  if eof() 
    if AdiReg ()
      if RegLock()
        replace Usua       with cUsuario
        dbunlock ()
      endif  
    endif
  endif

  if RegLock()
    replace rFundo  with "n/w"
    replace rCabec  with "gr+/r"
    replace rMenus  with "w+/b"
    replace rOpcao  with "w+/n"
    replace rJanel  with "w+/bg"
    replace rCampo  with "n/w" 
    replace rBorja  with "w+/bg"
    replace rAltKo  with "gr+/n"
    replace rAltKm  with "gr+/b"
    replace rAcess  with "r/b"
    replace rAltKc  with "gr+/w" 
    dbunlock ()
  endif
  
  select MenuARQ

  aOpcoes := {}

  CarMenu ()
  DispMenu()
  LumiMenu()
  
  Alerta( mensagem( 'Alerta', 'Padrao', .f. ) )
 
  CorFundo := "n/w"
  CorCabec := "gr+/r"
  CorMenus := "w+/b"
  CorOpcao := "w+/n"
  CorBorda := "g/r"
  CorJanel := "w+/bg"
  CorCampo := "n/w"
  CorBorJa := "w+/bg"
  CorAltKo := "gr+/n"
  CorAltKm := "gr+/b"
  CorAltKc := "gr+/w"
  CorAcess := "w+/b"
return NIL

//
// Tabela dos caracteres ASCII 
//
function TabASCII ()
  tTab := savescreen( 00, 00, 23, 79 )
  Janela( 02, 03, 19, 75, mensagem( 'Janela', 'TabASCII', .f. ), .f. )
  setcolor( CorJanel )
    
  nChr   := 0
  aArq   := {}
  cLinha := ''
 
  for nASC := 255 to 1 step -1
    cLinha += str( nASC, 3 ) + ' ' + chr( nASC ) + '  '
    nChr   ++
    
    if nChr > 10
      aadd( aArq, cLinha )

      cLinha := ''
      nChr   := 0
      nASC   ++
    endif 
  next

  aadd( aArq, cLinha )

  Choice := achoice( 04, 05, 18, 74, aArq )
  
  restscreen( 00, 00, 23, 79, tTab )
return NIL

//
//  Exibir dica do dia
//
function DicaDia ()
  tDica   := savescreen( 00, 00, 23, 79 )
  lExibir := .f.
  
  Janela( 03, 05, 20, 71, mensagem( 'Janela', 'DicaDia', .f. ), .t. )
  Mensagem( 'Empr', 'DicaDia' )
  setcolor( CorJanel )
  @ 19,07 say '[X]'
  @ 19,11 say 'Exibir Dica do Dia'
  
  setcolor( CorCampo );      @ 19,45 say ' Próxima Dica '
  setcolor( CorOpcao );      @ 19,61 say ' Fechar '
  setcolor( CorAltKO );      @ 19,62 say 'F'
  setcolor( CorAltKC );      @ 19,46 say 'P'

  for i := 1 to len( CorAltKC ) 
    if substr( CorAltKC, i, 1 ) == '/'  
      cCorIni := left( CorAltKC, i - 1 )
      exit
    endif
  next               

  for i := 1 to len( CorJanel ) 
    if substr( CorJanel, i, 1 ) == '/'  
      cCorFin := substr( CorJanel, i )
      exit
    endif
  next               

  setcolor( cCorIni + cCorFin )
  @ 19,11 say 'E'
  
  select AjudARQ
  set order to 1

  nTotal  := lastrec()
  
  if val( decode( ParaARQ->Tela ) ) == 1
    nRnd  := 69  

    select ParaARQ
    if RegLock()
      replace Tela     with encode( "002" )
      dbunlock()
    endif

    select AjudARQ
  else    
    nRnd  := int( hb_random(nTotal) )
  endif
  lExibir := .f.

  do while lastkey() != K_ESC
    go nRnd
    
    if eof()
      dbgotop ()
    endif  
  
    cTexto := memoread( "ajuda" + HB_OSpathseparator() + alltrim( rotina ) + ".hlp" )
    cEdit  := memoedit( cTexto, 05, 07, 17, 69, .f., "DicaMemo", , , , 0, 0 )

    do case
      case lastkey() == K_ALT_P
        nRnd  := int( hb_random(nTotal) )
        loop
      case lastkey() == K_CTRL_W
        if RegLock()
          replace Texto    with cEdit
          dbunlock ()
        endif
      otherwise;                          exit
    endcase
  enddo      
 
  if lExibir   
    select ParaARQ
    set order to 1
    if Reglock()
      replace Dica       with ' '
      dbunlock()
    endif  
  endif  
  restscreen( 00, 00, 23, 79, tDica )
return NIL

function DicaMemo( wModo, wlin , wCol )

  nKey      := inkey()
  cRetVal   := 0

  setcolor( CorJanel )
  do case 
    case nKey == K_ENTER          
      keyboard( chr(27) )
      cRetVal := K_ESC
    case nKey == K_ALT_F;          cRetVal := K_ESC
    case nKey == K_ALT_P
      nRnd    := recno() + 1
      cRetVal := K_ESC
  
      setcolor( CorOpcao );      @ 19,45 say ' Próxima Dica '
      setcolor( CorCampo );      @ 19,61 say ' Fechar '
      setcolor( CorAltKC );      @ 19,62 say 'F'
      setcolor( CorAltKO );      @ 19,46 say 'P'
      inkey(.1)
      setcolor( CorCampo );      @ 19,45 say ' Próxima Dica '
      setcolor( CorOpcao );      @ 19,61 say ' Fechar '
      setcolor( CorAltKO );      @ 19,62 say 'F'
      setcolor( CorAltKC );      @ 19,46 say 'P'
      setcolor( CorJanel )
    case nKey == K_ALT_E
      if lExibir 
        @ 19,07 say '[X]'
        
        lExibir := .f.
      else      
        @ 19,07 say '[ ]'
        
        lExibir := .t.
     endif      
  endcase

return( cRetVal )

function ChoiceFont()
  local tFont   := savescreen( 00, 00, 23, 79 )
  local GetList := {}
  local lSim    := .f.
  
  Janela( 08, 38, 14, 74, mensagem( 'Janela', 'TipoFont', .f. ), .t. ) 

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,40 say '   Nome'
  @ 11,40 say 'Tamanho'
  
  @ 13,50 say 'Confirmar '
        
  setcolor( CorCampo )
  @ 13,60 say ' Sim '
  @ 13,66 say ' Não '
        
  setcolor( CorAltKC )
  @ 13,61 say 'S'
  @ 13,67 say 'N'
  
  select EmprARQ
      
  cFontNome := FontNome
  nFontTama := FontTama
  nFontHeig := FontHeig
  nFontWidh := FontWidh

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,48 get cFontNome    pict '@S20'
  @ 11,48 get nFontTama    pict '99'
  @ 11,51 get nFontHeig    pict '99'
  @ 11,54 get nFontWidh    pict '99'
  read
  
  lSim := ConfLine( 13, 60, 1 )

  restscreen( 00, 00, 23, 79, tFont )

  select EmprARQ
 
  if lSim
    if RegLock()
      replace FontNome  with cFontNome
      replace FontTama  with nFontTama
      replace FontHeig  with nFontHeig
      replace FontWidh  with nFontWidh
      dbunlock()
    endif
/*    
    #ifdef __WVT__
      wvt_setfont( alltrim( cFontNome ), nFontTama, nFontHeig, nFontWidh )
    #endif
*/    
  endif
return NIL
