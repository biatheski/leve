//  Leve, Condições de pagamento
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

function Cond( xAlte )
  local GetList := {}
  
if SemAcesso( 'Cond' )
  return NIL
endif  

if NetUse( "CondARQ", .t. )
  VerifIND( "CondARQ" )
  
  dOpenCond := .t.
  
  #ifdef DBF_NTX
    set index to CondIND1, CondIND2
  #endif  
else
  dOpenCond := .f.
endif

//  Variaveis de Entrada para Condicoes de Pagamento
nCond := 0
cNome := space(30)
nVct1 := nVct2 := nVct3 := nVct4 := nVct5 := 0
nVct6 := nVct7 := nVct8 := nVct9 := 0
nAcrs := nPcla := nIndi := 0
lVctFixo := lCheque := .t.
cVctFixo := cCheque := ' '

//  Tela Condicoes de Pagamento
Janela ( 06, 12, 17, 70, mensagem( 'Janela', 'Cond', .f. ), .t. )

setcolor ( CorJanel )
@ 08,14 say '     Codigo'
@ 09,14 say '  Descrição'

@ 11,14 say 'Vencimentos'
@ 12,14 say '   Parcelas                       Vcto. Fixo'
@ 14,14 say '  Acréscimo         Ind.              Cheque'

MostOpcao( 16, 14, 26, 46, 59 ) 
tCond := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Condicoes de Pagamento
select CondARQ
set order to 1
if dOpenCond
  dbgobottom ()
endif  
do while  .t.
  Mensagem('Cond', 'Janela' )

  select CondARQ
  set order to 1
 
  cStat := space(04)
  restscreen( 00, 00, 23, 79, tCond )
  MostCond()
  
  if Demo()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostCond'
  cAjuda   := 'Cond'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  if lastkey() == K_ALT_A
    nCond := val( Cond )
  else  
    if xAlte 
      @ 08,26 get nCond                      pict '999999'
      read
    else
      nCond := 0
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
  cCond := strzero( nCond, 6 )
  @ 08,26 say cCond

  //  Verificar existencia do Condicoes de Pagamento para Incluir, Alterar ou Excluir
  select CondARQ
  set order to 1
  dbseek( cCond, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif

  Mensagem( 'Cond', cStat )

  MostCond()
  EntrCond()

  Confirmar ( 16, 14, 26, 46, 59, 3 )

  if cStat ==  'prin'
    PrinCond(.f.)  
  endif
    
  if cStat == 'excl'
    ExclRegi ()
  endif
  
  if cStat == 'incl'
    if cCond == '000000'
      cCond := '000001'
    endif    

    set order to 1  
    do while .t.
      dbseek( cCond, .f. )
      if found()
        nCond := val( cCond ) + 1               
        cCond := strzero( nCond, 6 )
      else 
        exit   
      endif
    enddo

    if AdiReg()
      if RegLock()
        replace Cond           with cCond
        dbunlock ()
      endif  
    endif  
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Nome          with cNome
      replace Vct1          with nVct1
      replace Vct2          with nVct2
      replace Vct3          with nVct3
      replace Vct4          with nVct4
      replace Vct5          with nVct5
      replace Vct6          with nVct6
      replace Vct7          with nVct7
      replace Vct8          with nVct8
      replace Vct9          with nVct9
      replace Acrs          with nAcrs
      replace Indi          with nIndi
      replace Pcla          with nPcla
      replace VctFixo       with lVctFixo
      replace Cheque        with lCheque
      dbunlock ()
    endif
    
    if !xAlte
      xAlte := .t.
      keyboard(chr(27))
    endif
  endif
enddo

if dOpenCond
  select CondARQ
  close 
endif

return NIL
//
// Entra Dados do Condioces de Pagamento
//
function EntrCond()
  local GetList := {}
  
  do while .t.
    lAlterou := .f.
    
    setcolor ( CorJanel + ',' + CorCampo )  
    @ 09,26 get cNome 
    @ 11,26 get nVct1       pict '999'
    @ 11,30 get nVct2       pict '999'
    @ 11,34 get nVct3       pict '999'
    @ 11,38 get nVct4       pict '999'
    @ 11,42 get nVct5       pict '999'
    @ 11,46 get nVct6       pict '999'
    @ 11,50 get nVct7       pict '999'
    @ 11,54 get nVct8       pict '999'
    @ 11,58 get nVct9       pict '999'
    @ 12,26 get nPcla       pict '99'
    @ 12,60 get cVctFixo    pict '@!' valid upper( cVctFixo ) == 'X' .or. empty( cVctFixo )
    @ 14,26 get nAcrs       pict '@E 999.9'
    @ 14,39 get nIndi       pict '@E 999.99999' 
    @ 14,60 get cCheque     pict '@!' valid upper( cCheque ) == 'X' .or. empty( cCheque )
    read

    if cNome         != Nome; lAlterou := .t.
    elseif nVct1     != Vct1; lAlterou := .t.
    elseif nVct2     != Vct2; lAlterou := .t.
    elseif nVct3     != Vct3; lAlterou := .t.
    elseif nVct4     != Vct4; lAlterou := .t.
    elseif nVct5     != Vct5; lAlterou := .t.
    elseif nVct6     != Vct6; lAlterou := .t.
    elseif nVct7     != Vct7; lAlterou := .t.
    elseif nVct8     != Vct8; lAlterou := .t.
    elseif nVct9     != Vct9; lAlterou := .t.
    elseif nPcla     != Pcla; lAlterou := .t.
    elseif nAcrs     != Acrs; lAlterou := .t.
    elseif nIndi     != Indi; lAlterou := .t.
    endif
    
    if !Saindo(lAlterou)
      loop
    endif  
    
    exit
  enddo
  
   
  if nVct2 > 0 .or. nPcla == 1
    nPcla := 0
  endif  
  
  if empty( cVctFixo )
    lVctFixo := .f.
  else
    lVctFixo := .t.
  endif
  
  if empty( cCheque )
    lCheque := .f.
  else
    lCheque := .t.
  endif
return NIL

//
// Mostra Dados do Condicoes de Pagamento
//
function MostCond()
  if cStat != 'incl'
    nCond := val( Cond )
    cCond := Cond
  endif
    
  cNome    := Nome
  nVct1    := Vct1
  nVct2    := Vct2
  nVct3    := Vct3
  nVct4    := Vct4
  nVct5    := Vct5
  nVct6    := Vct6
  nVct7    := Vct7
  nVct8    := Vct8
  nVct9    := Vct9
  nIndi    := Indi
  nAcrs    := Acrs
  nPcla    := Pcla
  lVctFixo := VctFixo
  lCheque  := Cheque
    
  setcolor( CorJanel )
  if lVctFixo
    cVctFixo := 'X'
    @ 12,59 say '[X]'
  else
    cVctFixo := ' '
    @ 12,59 say '[ ]'
  endif
  if lCheque
    cCheque  := 'X'
    @ 14,59 say '[X]'
  else
    cCheque  := ' '
    @ 14,59 say '[ ]'
  endif
  
  setcolor ( CorCampo )
  @ 09,26 say cNome
  @ 11,26 say nVct1         pict '999'
  @ 11,30 say nVct2         pict '999'
  @ 11,34 say nVct3         pict '999'
  @ 11,38 say nVct4         pict '999'
  @ 11,42 say nVct5         pict '999'
  @ 11,46 say nVct6         pict '999'
  @ 11,50 say nVct7         pict '999'
  @ 11,54 say nVct8         pict '999'
  @ 11,58 say nVct9         pict '999'
  @ 12,26 say nPcla         pict '99'
  @ 14,26 say nAcrs         pict '@E 999.9'
  @ 14,39 say nIndi         pict '@E 999.99999'
  
  PosiDBF( 06, 70 )
return NIL

//
// Imprime Dados da Condicoes
//
function PrinCond ( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right( cArqu2, 8 )
  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "CondARQ", .t. )
      VerifIND( "CondARQ" )

      #ifdef DBF_NTX
        set index to CondIND1, CondIND2
      #endif    
    endif
  endif

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 08, 21, 12, 59, mensagem( 'Janela', 'PrinCond', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,23 say 'Cond. de Pagamento Inicial'
  @ 11,23 say '  Cond. de Pagamento Final'

  select CondARQ
  set order to 1
  dbgotop ()
  nCondIni := val( Cond )
  dbgobottom ()
  nCondFin := val( Cond )

  @ 10,50 get nCondIni       pict '999999'    valid ValidARQ( 99, 99, "CondARQ", "Código" , "Cond", "Descrição", "Nome", "Cond", "nCondIni", .t., 6, "Consulta de Condições Pagamento", "CondARQ", 40 )
  @ 11,50 get nCondFin       pict '999999'    valid ValidARQ( 99, 99, "CondARQ", "Código" , "Cond", "Descrição", "Nome", "Cond", "nCondFin", .t., 6, "Consulta de Condições Pagamento", "CondARQ", 40 ) .and. nCondFin >= nCondIni
  read

  if lastkey () == K_ESC
    select CondARQ
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
  cCondIni := strzero( nCondIni, 6 )
  cCondFin := strzero( nCondFin, 6 )

  select CondARQ
  set order to 1
  dbseek( cCondIni, .t. )
  do while Cond >= cCondIni .and. Cond <= cCondFin .and. !eof()
    if lInicio
      set printer to ( cArqu2 )
      set printer on
      set device  to print
      
      lInicio := .f.
    endif  
 
    if nLin == 0
      Cabecalho( 'Condicoes de Pagamento', 123, 3 )
      CabCond ()
    endif
      
    @ nLin,01 say Cond
    @ nLin,10 say Nome
    @ nLin,42 say Vct1        pict '9999'
    @ nLin,47 say Vct2        pict '9999'
    @ nLin,52 say Vct3        pict '9999'
    @ nLin,57 say Vct4        pict '9999'
    @ nLin,62 say Vct5        pict '9999'
    @ nLin,67 say Vct6        pict '9999'
    @ nLin,72 say Vct7        pict '9999'
    @ nLin,77 say Vct8        pict '9999'
    @ nLin,82 say Vct9        pict '9999'
    @ nLin,87 say Acrs        pict '@E 999.9'
    nLin ++

    if nLin >= pLimite
      Rodape(123) 

      cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
      cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

      set printer to &cArqu2
      set printer on
    endif

    dbskip ()
  enddo

  if !lInicio
    Rodape(123)
  endif  

  set printer to
  set printer off
  set device  to screen
    
  if Imprimir( cArqu3, 123 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Relatório das Condicoes de Pagamento"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 132
      replace Empr       with cEmpresa
      dbunlock ()
    endif
    close
  endif  

  select CondARQ
  if lAbrir
    close
  else
    set order  to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabCond ()
  @ 02, 01 say 'Cd.Pgto.'
  @ 02, 10 say 'Descrição'
  @ 02, 42 say 'Vc.1'
  @ 02, 47 say 'Vc.2'
  @ 02, 52 say 'Vc.3'
  @ 02, 57 say 'Vc.4'
  @ 02, 62 say 'Vc.5'
  @ 02, 67 say 'Vc.6'
  @ 02, 72 say 'Vc.7'
  @ 02, 77 say 'Vc.8'
  @ 02, 82 say 'Vc.9'
  @ 02, 87 say 'Acrescimo' 

  nLin := 04
return NIL

//
// Imprime Carne dos Clientes
//
function PrinCarn ()

  if NetUse( "PortARQ", .t. )
    VerifIND( "PortARQ" )
  
    #ifdef DBF_NTX
      set index to PortIND1, PortIND2
    #endif 
  endif

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )
  
    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2
    #endif  
  endif

  if NetUse( "ReprARQ", .t. )
    VerifIND( "ReprARQ" )

    #ifdef DBF_NTX
      set index to ReprIND1, ReprIND2
    #endif  
  endif

  if NetUse( "ReceARQ", .t. )
    VerifIND( "ReceARQ" )
  
    #ifdef DBF_NTX
      set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
    #endif  
  endif

  if NetUse( "CampARQ", .t. )
    VerifIND( "CampARQ" )
  
    #ifdef DBF_NTX
      set index to CampIND1, CampIND2
    #endif  
  endif

  if NetUse( "CarnARQ", .t. )
    VerifIND( "CarnARQ" )
  
    #ifdef DBF_NTX
      set index to CarnIND1
    #endif  
  endif

  tPrt := savescreen( 00, 00, 23, 79 ) 

  Janela ( 05, 03, 20, 72, mensagem( 'Janela', 'PrinCarn', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )
  
  select ReceARQ
  set order    to 7
  set relation to Clie into ClieARQ
  
  oCarne         := TBrowseDB( 07, 04, 18, 71 )
  oCarne:headsep := chr(194)+chr(196)
  oCarne:colsep  := chr(179)
  oCarne:footsep := chr(193)+chr(196)

  oCarne:addColumn( TBColumnNew(" ",          {|| Marc } ) )
  oCarne:addColumn( TBColumnNew("Nota",       {|| left( Nota, 6 ) + '-' + right( Nota, 2 ) } ) )
  oCarne:addColumn( TBColumnNew("Tipo",       {|| iif( Tipo == 'P', 'Pedido', iif( Tipo == 'N', 'Nota  ', 'O.S.  ' ) ) } ) )
  oCarne:addColumn( TBColumnNew("Cliente",    {|| iif( Clie == '999999', left( Cliente, 10 ), left( ClieARQ->Nome, 10 ) ) } ) )
  oCarne:addColumn( TBColumnNew("Código" ,       {|| Clie } ) )
  oCarne:addColumn( TBColumnNew("Emissão",    {|| Emis } ) )
  oCarne:addColumn( TBColumnNew("Vcto.",      {|| Vcto } ) )
  oCarne:addColumn( TBColumnNew("V. Nota",    {|| transform( Valor, '@E 99,999.99' ) } ) )
  oCarne:addColumn( TBColumnNew("Pgto.",      {|| Pgto } ) )
  oCarne:addColumn( TBColumnNew("Repr.",      {|| Repr } ) )
              
  oCarne:gobottom()
  
  lExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ''
  nTotal         := lastrec()
  nTotalNota     := 0
  nOrdem         := 7
  BarraSeta      := BarraSeta( nLinBarra, 8, 18, 72, nTotal )
  
  setcolor( CorJanel + ',' + CorCampo )
  @ 08,03 say chr(195) 
  @ 18,03 say chr(195) 
  @ 19,05 say 'Consulta'
  @ 19,47 say 'Total Nota'
  
  setcolor( CorCampo )
  @ 19,14 say space(30)
  @ 19,58 say nTotalNota           pict '@E 999,999.99'

  do while !lExitRequested
    Mensagem( 'Cond', 'PrinCarn' )
    
    oCarne:forcestable() 

    iif( BarraSeta, BarraSeta( nLinBarra, 8, 18, 72, nTotal ), NIL )
    
    if oCarne:stable
      if oCarne:hitTop .or. oCarne:hitBottom
        tone( 125, 0 )        
      endif  
            
      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oCarne:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oCarne:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oCarne:down()
      case cTecla == K_UP;         oCarne:up()
      case cTecla == K_PGDN;       oCarne:pageDown()
      case cTecla == K_PGUP;       oCarne:pageUp()
      case cTecla == K_RIGHT;      oCarne:right()
      case cTecla == K_LEFT;       oCarne:left()
      case cTecla == K_CTRL_PGDN;  oCarne:gobottom()
      case cTecla == K_CTRL_PGUP;  oCarne:goTop()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_SPACE
        if empty( Marc )
          if RegLock()
            replace Marc       with "X"
            dbunlock ()
          endif
          
          nTotalNota += Valor
        else   
          if RegLock()
            replace Marc       with ' '
            dbunlock ()
          endif
  
          nTotalNota -= Valor
        endif  
        
        if nTotalNota < 0
          nTotalNota := 0
        endif  
       
        setcolor( CorCampo ) 
        @ 19,58 say nTotalNota           pict '@E 999,999.99'
 
        oCarne:refreshall()
      case cTecla == K_ENTER
        if empty( Marc )
          nTotalNota += Valor
        endif 
       
        setcolor( CorCampo ) 
        @ 19,58 say nTotalNota           pict '@E 999,999.99'
      
        if RegLock()
          replace Marc       with "X"
          dbunlock ()
        endif

        oCarne:refreshall()
  
        lExitRequested := .t.  
      case cTecla == K_TAB
        nOrdem ++

        if nOrdem > 7
          nOrdem := 1
        endif  
        
        set order to nOrdem
        
        do case
          case nOrdem == 1
            cTitu := 'Seleção de Carnˆ por Nota'
          case nOrdem == 2
            cTitu := 'Seleção de Carnˆ por Vencimento'
          case nOrdem == 3
            cTitu := 'Seleção de Carnˆ por Pagamento'
          case nOrdem == 4
            cTitu := 'Seleção de Carnˆ por Cliente e Vcto.'
          case nOrdem == 5
            cTitu := 'Seleção de Carnˆ por Cliente e Pgto.'
          case nOrdem == 6
            cTitu := 'Seleção de Carnˆ por Vendedor'
          case nOrdem == 7
            cTitu := 'Seleção de Carnˆ por Emissão'
        endcase    

        setcolor( CorCabec )
        @ 05, 05 say space(68)
        @ 05, 05 + ( ( 66 - len ( cTitu ) ) / 2 ) say cTitu

        oCarne:refreshAll()
      case cTecla == K_BS
        cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
      
        setcolor ( CorCampo )
        @ 19,14 say space(32)
        @ 19,14 say cLetra
      case cTecla >= 32 .and. cTecla <= 128
        cLetra += chr( cTecla )    

        if len( cLetra ) > 32
          cLetra := ''
        endif  
     
        setcolor ( CorCampo )
        @ 19,14 say space(32)
        @ 19,14 say cLetra
        
        if nOrdem == 2 .or. nOrdem == 3 .or. nOrdem == 7        
          dbseek( dtos( ctod( cLetra ) ), .t. )
        else
          dbseek( cLetra, .t. )
        endif  
        oCarne:refreshAll()
    endcase
  enddo  
  
  if lastkey() == K_ESC
    select ReprARQ
    close
    select PortARQ
    close
    select ClieARQ
    close
    select ReceARQ
    close
    select CarnARQ
    close
    select CampARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  select CarnARQ
  set order to 1
  dbseek( EmprARQ->Carne, .f. )

  if found()
    cTexto := memoread( cCaminho + HB_OSpathseparator() + 'LAYOUT' + HB_OSpathseparator() + 'CA-' + strzero( Codigo, 4 ) + '.TXT' )

    if empty( cTexto )
      lAchou := .f.
    else  
      lAchou := .t.
    endif  
  else
    lAchou := .f.
  endif
  
  if !lAchou
    Alerta( mensagem( 'Alerta', 'PrinCarn', .f. ) )
   
    select ReprARQ
    close
    select PortARQ
    close
    select ClieARQ
    close
    select ReceARQ
    close
    select CampARQ
    close
    select CarnARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  nLin      := 1
  nTama     := Tama
  nEspa     := Espa
  nComp     := Comp

  cQtLin    := mlcount( cTexto, nTama )
  aLayout   := {}
  nLin      := 1
  
  Aguarde ()

  if !TestPrint(1)
    select ReprARQ
    close
    select PortARQ
    close
    select ClieARQ
    close
    select ReceARQ
    close
    select CampARQ
    close
    select CarnARQ
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
                  
  for nK := 1 to cQtLin
    cLinha := memoline( cTexto, nTama, nK )
      
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
          cArqu := Arquivo 
          cCamp := Campo
          cDesc := Desc
          cPict := Mascara
          xTipo := Tipo
          xTama := Tamanho
         
          aadd( aLayout, { nLin, nCol, Tipo, Arquivo, Campo, Tamanho, Mascara } )
        endif  
        cPalavra := ''
        nCol     := 0
      endif 
    next 
    nLin ++
  next  
  
  nLen := len( aLayout )
  
  select ReceARQ
  set order to 8
  set relation to Clie into ClieARQ, Repr into ReprARQ,;
               to Port into PortARQ
  
  dbseek( "X", .f. )
  do while Marc == "X"
    cObseNota := 'o ' + aDias[ day( Vcto ) ] + 'DIA DO MES ' + alltrim( aMesExt[ month( Vcto ) ] ) + ' DE' + str( year( Vcto ) ) 
  
    for nJ := 1 to nLen
      nLin  := aLayout[ nJ, 1 ]
      nCol  := aLayout[ nJ, 2 ]
      xTipo := aLayout[ nJ, 3 ]
      cArqu := aLayout[ nJ, 4 ]
      cCamp := aLayout[ nJ, 5 ]
      xTama := aLayout[ nJ, 6 ]
      cPict := aLayout[ nJ, 7 ]

      if empty( cArqu )
        @ nLin, nCol say cCamp
      else  
        select( cArqu )
                            
        do case 
          case xTipo == 'N'
            if !empty( &cCamp )
              @ nLin,nCol say transform( &cCamp, cPict )
            endif  
          case xTipo == 'C'  
            @ nLin,nCol say left( &cCamp, xTama )
          case xTipo == 'D' .or. xTipo == 'V'  
            @ nLin,nCol say &cCamp
        endcase  
      endif  
    next  
    
    select ReceARQ

    dbskip ()
  enddo

  @ nLin,00 say chr(27) + '@'
  
  select ReceARQ
  set order to 8
  dbgotop ()
  do while !eof ()
    dbseek( "X", .f. )
    
    if eof ()
      exit
    else  
      if RegLock()
        replace Marc       with space(01)
        dbunlock ()
      endif
    endif
  enddo      
  
  set printer to
  set printer off
  set device  to screen

  select ReceARQ
  close
  select CampARQ
  close
  select ReprARQ
  close
  select PortARQ
  close
  select ClieARQ
  close
  select CarnARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL