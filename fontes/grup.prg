//  Leve, Grupos
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

function Grup( xAlte )
  local GetList := {}

  if SemAcesso( 'Grup' )
    return NIL
  endif

  if NetUse( "GrupARQ", .t. )
    VerifIND( "GrupARQ" )
  
    lOpenGrup := .t.

    #ifdef DBF_NTX
      set index to GrupIND1, GrupIND2
    #endif
  else
    lOpenGrup := .f.  
  endif

  //  Variaveis de Entrada
  cCoGr := space(06)
  nGrup := nMargem := nDesc := 0
  cNoGr := space(30)

  //  Tela Grup
  Janela ( 06, 05, 14, 62, mensagem( 'Janela', 'Grupo', .f. ), .t. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,10 say '   Codigo'
  @ 10,10 say 'Descrição'
  @ 11,10 say ' Desconto        %               Margem        %' 

  MostOpcao( 13, 07, 19, 38, 51 ) 
  tGrup := savescreen( 00, 00, 23, 79 )

  //  Manutencao Cadastro de Grup
  select GrupARQ
  set order to 1
  if lOpenGrup
    dbgobottom ()
  endif  
  do while .t.
    select GrupARQ
    set order to 1

    restscreen( 00, 00, 23, 79, tGrup )

    Mensagem('Grup','Janela')

    cStat := space(4)
    MostGrup()
  
    if Demo ()
      exit
    endif  

    //  Entrar com Novo Codigo
    setcolor ( CorJanel + ',' + CorCampo )

    MostTudo := 'MostGrup'
    cAjuda   := 'Grup'
    lAjud    := .t.
    set key K_PGUP      to MostrARQ()
    set key K_PGDN      to MostrARQ()
    set key K_CTRL_PGUP to MostrARQ()
    set key K_CTRL_PGDN to MostrARQ()
    set key K_UP        to MostrARQ()
  
    if lastkey() == K_ALT_A
      nGrup := val( Grup )
    else    
      if xAlte
        @ 08,20 get nGrup              pict '999999'
        read
      else
        nGrup := 0
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
    cCoGr := strzero( nGrup, 6 )
    @ 08,20 say cCoGr
  
    //  Verificar existencia do Grupo para Incluir ou Alterar
    select GrupARQ
    set order to 1
    dbseek( cCoGr, .f. )
    if eof()
      cStat := 'incl'
    else
      cStat := 'alte'
    endif

    Mensagem( 'Grup', cStat )
  
    MostGrup ()
    EntrGrup ()

    Confirmar( 13, 07, 19, 38, 51, 3 )

    if cStat == 'excl'
      if NetUse( "SubGARQ", .t. )
        VerifIND( "SubGARQ" )
        
        xOpenSubG := .t.

        #ifdef DBF_NTX
          set index to SubGIND1, SubGIND2
        #endif
      else
        xOpenSubG := .f.
      endif
    
      select SubgARQ
      set order to 1
      dbseek( cCoGr, .t. )
      if Grup == cCoGr
        Janela( 09, 20, 14, 60, 'Atenção', .t. )
        setcolor( CorJanel )
     
        @ 11,22 say 'Existe SubGrupos Cadastrados !!!' 
        @ 13,22 say '             Continuar...' 
      
        if !ConfLine( 13, 48, 2 )
          close
          loop
        endif  
      else
        if xOpenSubG
          close        
        endif  
      endif
    
      select GrupARQ
    
      ExclRegi ()
    endif
  
    if cStat == 'prin'
      PrinGrup(.f.)
    endif  
    
    if cStat == 'incl'
      if cCoGr == "000000" 
        cCoGr := "000001"

        set order to 1
        do while .t.
          dbseek( cCoGr, .f. )
          if found()
            cCoGr := strzero( val( cCoGr ) + 1, 6 )
          else 
            exit   
          endif
        enddo
      endif     

      if AdiReg()
        if RegLock()
          replace Grup         with cCoGr
          dbunlock ()
        endif
      endif
    endif

    if cStat == 'incl' .or. cStat == 'alte'
      if RegLock()
        replace Nome         with cNoGr
	replace Margem       with nMargem
	replace Desc         with nDesc
        dbunlock ()
      endif
     
      if !xAlte 
        xAlte := .t.
        keyboard(chr(27))
      endif  
    endif
  enddo

  if lOpenGrup
    select GrupARQ
    close 
  endif
return NIL

//
// Entra Dados do Grupo
//
function EntrGrup ()
  local GetList := {}
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,20 get cNoGr                valid !empty( cNoGr )
  @ 11,20 get nDesc                pict '@E 999.99'
  @ 11,50 get nMargem              pict '@E 999.99'
  read
return NIL

//
// Mostra Dados do Grupo
// 
function MostGrup ()
  if cStat != 'incl' 
    cCoGr := Grup
    nGrup := val( Grup )
  endif
  
  cNoGr   := Nome
  nDesc   := Desc
  nMargem := Margem
      
  setcolor ( CorCampo )
  @ 10,20 say cNoGr
  @ 11,20 say nDesc                pict '@E 999.99'
  @ 11,50 say nMargem              pict '@E 999.99'
  
  PosiDBF( 06, 62 )
return NIL

//
// Imprime dados do Grupo
//
function PrinGrup( lAbrir )

  local cArqu2  := CriaTemp( 5 )
  local cArqu3  := right ( cArqu2, 8 )
  local cRData  := date()
  local cRHora  := time()
  local GetList := {}

  if lAbrir
    if NetUse( "GrupARQ", .t. )
      VerifIND( "GrupARQ" )

      #ifdef DBF_NTX
        set index to GrupIND1, GrupIND2
      #endif
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 06, 27, 10, 56, mensagem( 'Janela', 'PrinGrup', .f. ) , .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,30 say ' Grupo Inicial'
  @ 09,30 say '   Grupo Final'

  select GrupARQ
  set order to 1
  dbgotop ()
  nGrupIni := val( Grup )
  dbgobottom ()
  nGrupFin := val( Grup )

  @ 08,45 get nGrupIni    pict '999999'       valid ValidARQ( 99, 99, "GrupARQ", "Código" , "Grup", "Descrição", "Nome", "Grup", "nGrupIni", .t., 6, "Consulta de Grupos", "GrupARQ", 30 )
  @ 09,45 get nGrupFin    pict '999999'       valid ValidARQ( 99, 99, "GrupARQ", "Código" , "Grup", "Descrição", "Nome", "Grup", "nGrupFin", .t., 6, "Consulta de Grupos", "GrupARQ", 30 ) .and. nGrupFin >= nGrupIni
  read

  if lastkey() == K_ESC
    select GrupARQ
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
  cGrupIni := strzero( nGrupIni, 6 )
  cGrupFin := strzero( nGrupFin, 6 )
  lInicio  := .t.

  select GrupARQ
  set order to 1
  dbseek( cGrupIni, .t. )
  do while Grup >= cGrupIni .and. Grup <= cGrupFin .and. !eof()
    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
      
      lInicio := .f.
    endif
      
    if nLin == 0
      Cabecalho( 'Grupos', 80, 2 )
      CabGrup()
    endif
      
    @ nLin, 03 say Grup                 pict '999999'
    @ nLin, 10 say Nome                 pict '@S30'
    @ nLin, 45 say Desc                 pict '@E 999.99'
    @ nLin, 55 say Margem               pict '@E 999.99'
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
      replace Titu       with "Relatório de Grupos"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
    close
  endif

  select GrupARQ
  if lAbrir
    close
  else
    set order  to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabGrup ()
  @ 02,01 say 'Grupo    Descrição'

  nLin := 4
retur NIL

//
// Saindo sem Salvar ?!
//
function Saindo(lSaindo)
  local lOkay := .t.
  
  if lSaindo .and. lastkey() == K_ESC
    tFui := savescreen( 06, 20, 13, 57 )         

    Janela( 06, 20, 12, 55, mensagem( 'LEVE', 'Atencao', .f. ), .t. )          
    setcolor( CorJanel )
    @ 08,22 say 'Vocˆ tem certeza que gostaria de'
    @ 09,22 say 'sair sem salvar ?'

    if ConfLine( 11, 43, 1 )
      keyboard(chr(27))
    else
      lOkay := .f.
    endif  
    
    restscreen( 06, 20, 13, 57, tFui )
  endif          
return(lOkay)

//
// Criar Barra
//  
function CriaBarra ()
  local tModi := savescreen( 00, 00, 23, 79 ) 

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
  
  select BarrARQ
  set order to 1
  Janela( 05, 15, 17, 60, mensagem( 'Janela', 'CriaBarra', .f. ), .f. )  
  Mensagem( 'LEVE', 'CriaBarra' ) 

  setcolor( CorJanel + ',' + CorCampo )
  oBarra           := TBrowseDB( 07, 16, 15, 59 )
  oBarra:headsep   := chr(194)+chr(196)
  oBarra:colsep    := chr(179)
  oBarra:footsep   := chr(193)+chr(196)
  oBarra:colorSpec := CorJanel
 
  oBarra:addColumn( TBColumnNew( ' ',          {|| Marc } ) )
  oBarra:addColumn( TBColumnNew( 'Impressora', {|| left( Impr, 10 ) } ) )
  oBarra:addColumn( TBColumnNew( 'Modelo',     {|| left( Mode, 8 ) } ) )
  oBarra:addColumn( TBColumnNew( 'Descrição',  {|| left( Desc, 20 ) } ) )

  oBarra:goTop ()

  lExitRequested := .f.
  nLinBarra      := 1
  cAjuda         := 'Etiq'
  lAjud          := .f.
  cLetra         := ''
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 08, 15, 60, nTotal )

  setcolor ( CorCampo )
  @ 16,26 say space(30)

  setcolor( CorJanel + ',' + CorCampo )
  @ 08,15 say chr(195)
  @ 15,15 say chr(195)
  @ 16,17 say 'Consulta'
    
  do while !lExitRequested
    Mensagem( 'LEVE', 'PrinProd' )

    oBarra:forcestable() 
    
    iif( BarraSeta, BarraSeta( nLinBarra, 08, 15, 60, nTotal ), NIL )
       
    if oBarra:stable
      if oBarra:hitTop .or. oBarra:hitBottom
        tone( 125, 0 )        
      endif  
      
      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oBarra:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oBarra:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
      
    do case
      case cTecla == K_DOWN;       oBarra:down()
      case cTecla == K_UP;         oBarra:up()
      case cTecla == K_PGDN;       oBarra:pageDown()
      case cTecla == K_PGUP;       oBarra:pageUp()
      case cTecla == K_LEFT;       oBarra:left()
      case cTecla == K_RIGHT;      oBarra:right()
      case cTecla == K_CTRL_PGUP;  oBarra:goTop()
      case cTecla == K_CTRL_PGDN;  oBarra:goBottom()
      case cTecla == K_F1;         Ajuda ()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_ALT_A .or. cTecla == K_INS
        tFiscal := savescreen( 00, 00, 23, 79 )
        
        Janela( 10, 07, 15, 67, mensagem( 'Janela', 'AlteBarra', .f. ), .f. )
        Mensagem( 'LEVE', 'AlteBarra' )

        setcolor( CorJanel + ',' + CorCampo )
        @ 12,09 say '   Descrição'
        @ 13,09 say '  Impressora                          Modelo'
        @ 14,09 say '     Comando                           Porta'
        
        if cTecla == K_INS
          cDesc := space(30) 
          cComa := space(30)
          cImpr := space(30)
          cMode := space(30)
          cPort := space(5)
        else
          cImpr := Impr
          cMode := Mode
          cDesc := Desc
          cComa := Coma
          cPort := Port
        endif  

        setcolor( CorJanel )
        @ 12,22 get cDesc                     pict '@S42'
        @ 13,22 get cImpr                     pict '@S15'
        @ 13,54 get cMode                     pict '@S10'
        @ 14,22 get cComa                     pict '@S20'
        @ 14,54 get cPort                     pict '@S5'
        read

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        select BarrARQ
        set order to 1
        
        if cTecla == K_INS
          dbgobottom ()

          nCod := Codigo + 1
        
          if AdiReg()
            replace Codigo            with nCod
            dbunlock ()
          endif
        endif

        if RegLock()
          replace Desc            with cDesc
          replace Impr            with cImpr
          replace Mode            with cMode
          replace Coma            with cComa
          replace Port            with cPort
          dbunlock ()
        endif
         
        Barra ()  

        restscreen( 00, 00, 23, 79, tFiscal )

        oBarra:refreshAll()
      case cTecla == K_SPACE
        if RegLock()
          if empty( Marc )
            replace Marc            with "X"
          else    
            replace Marc            with space(1)
          endif  
          dbunlock ()
        endif
         
        oBarra:refreshAll()
      case cTecla == K_BS
        cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
      
        setcolor ( CorCampo )
        @ 16,26 say space(30)
        @ 16,26 say cLetra
      case cTecla >= 32 .and. cTecla <= 128
        cLetra += chr( cTecla )    
        
        if len( cLetra ) > 32
          cLetra := '' 
        endif
       
        setcolor ( CorCampo )
        @ 16,26 say space(30)
        @ 16,26 say cLetra

        dbseek( cLetra, .t. )
        oBarra:refreshAll()
      case cTecla == K_DEL
        if RegLock()
          dbdelete ()  
          dbunlock ()
        endif  
        
        oBarra:refreshAll()
      case cTecla == K_ENTER
        Barra ()  
    endcase
  enddo  
  
  select BarrARQ
  close
  select CampARQ
  close
  
  restscreen( 00, 00, 23, 79, tModi )
return NIL  

//
// Layout da Barra
//
function Barra ()
  local tFisc := savescreen( 00, 00, 23, 79 )

  Janela( 01, 01, 21, 78, mensagem( 'Janela', 'Barra', .f. ), .F. )
  Mensagem( "<F4> Campo, <CTRL+ENTER> Gravar, <ALT+F> Folha Teste, <ESC> Finalizar" )
                     
  cLayout := Layout
  cLayout := memoedit( cLayout, 02, 03, 20, 77, .t., "OutMemos", 80 + 1, , , 1, 0 )
  
  select BarrARQ
  
  if lastkey() == K_CTRL_W   
    if RegLock()
      replace Layout         with cLayout
      dbunlock ()
    endif
  endif  

  restscreen( 00, 00, 23, 79, tFisc )
return NIL