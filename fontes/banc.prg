//  Leve, Bancos
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

function Banc( xAlte )

if SemAcesso( 'Banc' )
  return NIL
endif  

if NetUse( "BancARQ", .t. )
  VerifIND( "BancARQ" )
  
  nOpenBanc := .t.
  
  #ifdef DBF_NTX
    set index to BancIND1, BancIND2
  #endif  
else
  nOpenBanc := .f.
endif

if NetUse( "CampARQ", .t. )
  VerifIND( "CampARQ" )
  
  nOpenCamp := .t.

  #ifdef DBF_NTX
    set index to CampIND1, CampIND2
  #endif  
else
  nOpenCamp := .f.
endif

//  Variaveis de Entrada para Banco
cBanc     := space(04)
cNoBa     := space(30)
nTamaBloq := nColuBloq := nCompBloq := nEspaBloq := 0
nTamaCheq := nColuCheq := nCompCheq := nEspaCheq := 0
nQtdeBloq := nQtdeCheq := nBanc    := 0
cBloqueto := cCheque   := ''

//  Tela Banca
Janela ( 04, 07, 11, 69, mensagem( 'Janela', 'Banc', .f. ), .t. )

setcolor ( CorJanel + ',' + CorCampo )
@ 06,10 say '   Codigo'
@ 08,10 say 'Descrição'

MostOut ()
tBanc := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Banco
select BancARQ
set order to 1
if nOpenBanc
  dbgobottom ()
endif  
do while  .t.
  Mensagem('Banc', 'Janela' )

  select BancARQ
  set order to 1
  
  restscreen( 00, 00, 23, 79, tBanc )
  cStat := cStatAux := space(4)
  MostBanc()
  
  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostBanc'
  cAjuda   := 'Banc'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  if lastkey() == K_ALT_A
    nBanc := val( Banc )
  else  
    if xAlte
      @ 06,20 get nBanc              pict '9999'
      read
    else
      dbgobottom ()
  
      nBanc := val( Banc ) + 1
      xAlte := .t.
    endif  
  endif
  
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. nBanc == 0
    exit
  endif
  
  setcolor ( CorCampo )
  cBanc := strzero( nBanc, 4 ) 
  @ 06,20 say cBanc
  
  //  Verificar existencia do Banco para Incluir ou Alterar
  select BancARQ
  set order to 1
  dbseek( cBanc, .f. )
  if eof()
    cStat :=  'incl'
  else
    cStat :=  'alte'
  endif

  Mensagem ('Banc', cStat )

  cStatAux := cStat
  
  MostBanc ()
  EntrBanc ()

  aOpcoes := {}
  tLinha  := savescreen( 24, 01, 24, 79 )
  
  aadd( aOpcoes, { ' Excluir ',   6, 'U', 10, 09, "Excluir banco." } )
  aadd( aOpcoes, { ' Cheques ',   4, 'E', 10, 20, "Configurar layout dos cheques." } )
  aadd( aOpcoes, { ' Bloqueto ' , 2, 'B', 10, 33, "Configurar layout dos bloquetos." } )
  aadd( aOpcoes, { ' Confirmar ', 2, 'C', 10, 45, "Confirmar inclusão ou alteração" } )
  aadd( aOpcoes, { ' Cancelar ',  3, 'A', 10, 58, "Cancelar alterações" } )
  
  do while .t.
    Mostout ()
    
    nOpConf := HCHOICE( aOpcoes, 5, 4 )
    
    do case
      case nOpConf == 0 .or. nOpConf == 5
        cStat := 'loop'

        exit
      case nOpConf == 1
        cStat := 'excl'

        exit
      case nOpConf == 2
        EntrCheu ()
    
        cStat := cStatAux
      case nOpConf == 3
        EntrBqto ()
    
        cStat := cStatAux
      case nOpConf == 4
        exit      
    endcase
  enddo  
        
  restscreen( 24, 01, 24, 79, tLinha )
  
  if cStat == 'loop' .or. lastkey () == K_ESC
    loop
  endif  

  if cStat == 'excl'
    ExclRegi ()
  endif
  
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Banc         with cBanc
        dbunlock ()
      endif
    endif  
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Nome        with cNoBa
      replace TamaBloq    with nTamaBloq
      replace ColuBloq    with nColuBloq
      replace CompBloq    with nCompBloq
      replace EspaBloq    with nEspaBloq
      replace QtdeBloq    with nQtdeBloq
      replace Bloqueto    with cBloqueto
      replace TamaCheq    with nTamaCheq
      replace ColuCheq    with nColuCheq
      replace CompCheq    with nCompCheq
      replace EspaCheq    with nEspaCheq
      replace QtdeCheq    with nQtdeCheq
      replace Cheque      with cCheque
      dbunlock ()
    endif
  endif
enddo

if nOpenBanc
  select BancARQ
  close
endif  

if nOpenCamp
  select CampARQ
  close
endif  

return NIL

function MostOut ()    
  setcolor( CorCampo )
  @ 10, 09 say ' Excluir '
  @ 10, 20 say ' Cheques '
  @ 10, 33 say ' Bloqueto '
  @ 10, 45 say ' Confirmar '
  @ 10, 58 say ' Cancelar '
  
  setcolor( CorAltKC )
  @ 10,14 say 'u'
  @ 10,23 say 'e'
  @ 10,34 say 'B'
  @ 10,46 say 'C'
  @ 10,60 say 'a'
return NIL  

//
// Entra Dados do Banco
//
function EntrBanc ()
  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,20 get cNoBa             
  read
return NIL

//
// Mostra Dados do Banco
//
function MostBanc ()
  if cStat != 'incl' 
    cBanc := Banc
    nBanc := val( Banc )
  endif
  
  cNoBa     := Nome

  nTamaBloq := TamaBloq
  nColuBloq := ColuBloq
  nCompBloq := CompBloq
  nEspaBloq := EspaBloq
  nQtdeBloq := QtdeBloq
  cBloqueto := Bloqueto

  nTamaCheq := TamaCheq
  nColuCheq := ColuCheq
  nCompCheq := CompCheq
  nEspaCheq := EspaCheq
  nQtdeCheq := QtdeCheq
  cCheque   := Cheque   
    
  setcolor ( CorCampo )
  @ 08,20 say cNoBa    
  
  PosiDBF( 04, 69 )         
return NIL

//
// Configura Layout do Bloqueto
//
function EntrBqto ()
  tComp := savescreen( 00, 00, 23, 79 )
  
  if empty( Bloqueto )
    Janela( 10, 07, 14, 67, mensagem( 'Janela', 'EntrBqto', .f. ), .f. )
    Mensagem( 'Banc', 'EntrBqto' )

    setcolor( CorJanel + ',' + CorCampo )
    @ 12,09 say '  Impressora                       Compactar'
    @ 13,09 say ' Espaçamento                    Qtde. Linhas'
        
    setcolor( CorCampo )
    @ 12,22 say ' 80 Col '
    @ 12,31 say ' 132 Col '
    @ 12,54 say ' Sim '
    @ 12,60 say ' Não '
    @ 13,22 say ' 1/6" '
    @ 13,29 say ' 1/8" '
    @ 13,54 say '   '

    setcolor( CorAltKC )
    @ 12,23 say '8'
    @ 12,32 say '1'
    @ 12,55 say 'S'
    @ 12,61 say 'N'
    @ 13,23 say '1'
    @ 13,32 say '8'

    nTamaBloq := 2
    nColuBloq := 2
    nCompBloq := 2
    nEspaBloq := 2

    setcolor( CorOpcao )
    if nColuBloq == 1
      @ 12,22 say ' 80 Col '
    else
      @ 12,31 say ' 132 Col '
    endif

    if nCompBloq == 1
      @ 12,54 say ' Sim '
    else
      @ 12,60 say ' Não '
    endif

    if nEspaBloq == 1
      @ 13,22 say ' 1/6" '
    else
      @ 13,29 say ' 1/8" '
    endif

    setcolor( CorCampo )
    @ 13,54 say nQtdeBloq             pict '999'

    aOpc := {}

    aadd( aOpc, { ' 80 Col ', 2,  '8', 12, 22, "Impressora 80 coluna." } )
    aadd( aOpc, { ' 132 Col ', 2, '1', 12, 31, "Impressora 132 colunas." } )

    nColuBloq := HCHOICE( aOpc, 2, nColuBloq )

    if lastkey() == K_ESC
      restscreen( 00, 00, 23, 79, tComp )
      return NIL
    endif

    aOpc := {}

    aadd( aOpc, { ' Sim ', 2, 'S', 12, 54, "Compactar a letra. (Letra Menor)" } )
    aadd( aOpc, { ' Não ', 2, 'N', 12, 60, "Não Compactar a letra. (Letra Normal)" } )

    nCompBloq := HCHOICE( aOpc, 2, nCompBloq )

    if lastkey() == K_ESC
      restscreen( 00, 00, 23, 79, tComp )
      return NIL
    endif

    aOpc  := {}

    aadd( aOpc, { ' 1/6" ', 2, '1', 13, 22, "Configurar o espaçamento entre linha. (Espaçamento Maior)" } )
    aadd( aOpc, { ' 1/8" ', 4, '8', 13, 29, "Configurar o espaçamento entre linha. (Espaçamento Menor)" } )

    nEspaBloq := HCHOICE( aOpc, 2, nEspaBloq )

    setcolor( CorJanel )
    @ 13,54 get nQtdeBloq                  pict '999'
    read

    if lastkey() == K_ESC
      restscreen( 00, 00, 23, 79, tComp )
      return NIL
    endif

    if empty( Bloqueto )
      if nCompBloq == 1
        if nColuBloq == 1
          nTamaBloq := 132
        else
          nTamaBloq := 232
        endif
      else
        if nColuBloq == 1
          nTamaBloq := 80
        else
          nTamaBloq := 132
        endif
      endif

      cBloqueto := ''

      for nL := 1 to nQtdeBloq
        cBloqueto += space( nTamaBloq )
      next
    endif
  endif

  Janela( 01, 01, 21, 78, mensagem( 'Janela', 'EntrBqto1', .f. ), .F. )
  Mensagem( "Banc", "EntrBqto1" )
  
  setcolor( CorJanel + ',' + CorCampo )
  cBloqueto := memoedit( cBloqueto, 02, 03, 20, 77, .t., "OutMemo", nTamaBloq + 1, , , 1, 0 )
  
  select BancARQ

  restscreen( 00, 00, 23, 79, tComp )
return NIL 

//
// Configura Layout do Cheque
//
function EntrCheu ()
  tComp := savescreen( 00, 00, 23, 79 )
  
  if empty( Cheque )
    Janela( 10, 07, 14, 67, mensagem( 'Janela', 'EntrCheu', .f. ), .f. )
    Mensagem( 'Banc', 'EntrCheu' )

    setcolor( CorJanel + ',' + CorCampo )
    @ 12,09 say '  Impressora                       Compactar'
    @ 13,09 say ' Espaçamento                    Qtde. Linhas'
        
    setcolor( CorCampo )
    @ 12,22 say ' 80 Col '
    @ 12,31 say ' 132 Col '
    @ 12,54 say ' Sim '
    @ 12,60 say ' Não '
    @ 13,22 say ' 1/6" '
    @ 13,29 say ' 1/8" '
    @ 13,54 say '   '

    setcolor( CorAltKC )
    @ 12,23 say '8'
    @ 12,32 say '1'
    @ 12,55 say 'S'
    @ 12,61 say 'N'
    @ 13,23 say '1'
    @ 13,32 say '8'

    nTamaCheq := 2
    nColuCheq := 2
    nCompCheq := 2
    nEspaCheq := 2

    setcolor( CorOpcao )
    if nColuCheq == 1
      @ 12,22 say ' 80 Col '
    else
      @ 12,31 say ' 132 Col '
    endif

    if nCompCheq == 1
      @ 12,54 say ' Sim '
    else
      @ 12,60 say ' Não '
    endif

    if nEspaCheq == 1
      @ 13,22 say ' 1/6" '
    else
      @ 13,29 say ' 1/8" '
    endif

    setcolor( CorCampo )
    @ 13,54 say nQtdeCheq             pict '999'

    aOpc := {}

    aadd( aOpc, { ' 80 Col ', 2,  '8', 12, 22, "Impressora 80 coluna." } )
    aadd( aOpc, { ' 132 Col ', 2, '1', 12, 31, "Impressora 132 colunas." } )

    nColuCheq := HCHOICE( aOpc, 2, nColuCheq )

    if lastkey() == K_ESC
      restscreen( 00, 00, 23, 79, tComp )
      return NIL
    endif

    aOpc := {}

    aadd( aOpc, { ' Sim ', 2, 'S', 12, 54, "Compactar a letra. (Letra Menor)" } )
    aadd( aOpc, { ' Não ', 2, 'N', 12, 60, "Não Compactar a letra. (Letra Normal)" } )

    nCompCheq := HCHOICE( aOpc, 2, nCompCheq )

    if lastkey() == K_ESC
      restscreen( 00, 00, 23, 79, tComp )
      return NIL
    endif

    aOpc  := {}

    aadd( aOpc, { ' 1/6" ', 2, '1', 13, 22, "Configurar o espaçamento entre linha. (Espaçamento Maior)" } )
    aadd( aOpc, { ' 1/8" ', 4, '8', 13, 29, "Configurar o espaçamento entre linha. (Espaçamento Menor)" } )

    nEspaCheq := HCHOICE( aOpc, 2, nEspaCheq )

    setcolor( CorJanel )
    @ 13,54 get nQtdeCheq                  pict '999'
    read

    if lastkey() == K_ESC
      restscreen( 00, 00, 23, 79, tComp )
      return NIL
    endif

    if empty( Cheque )
      if nCompCheq == 1
        if nColuCheq == 1
          nTamaCheq := 132
        else
          nTamaCheq := 232
        endif
      else
        if nColuCheq == 1
          nTamaCheq := 80
        else
          nTamaCheq := 132
        endif
      endif

      cCheque := ''

      for nL := 1 to nQtdeCheq
        cCheque += space( nTamaCheq )
      next
    endif
  endif

  Janela( 01, 01, 21, 78, mensagem( 'Janela', 'EntrCheu1', .f. ), .F. )
  Mensagem( 'Banc', 'EntrCheu1' ) 
                     
  cCheque := memoedit( cCheque, 02, 03, 20, 77, .t., "OutMemo", nTamaCheq + 1, , , 1, 0 )
  
  select BancARQ

  restscreen( 00, 00, 23, 79, tComp )
return NIL 

//
// Relatório de Bancos
//
function PrinBanc ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "BancARQ", .t. )
    VerifIND( "BancARQ" )
    
    lOpenBanc := .t.

    #ifdef DBF_NTX
      set index to BancIND1, BancIND2
    #endif  
  else
    lOpenBanc := .f.  
  endif
  
  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 06, 23, 10, 50, mensagem( 'Janela', 'PrinBanc', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,25 say 'Banco Inicial'
  @ 09,25 say '  Banco Final'

  select BancARQ
  set order to 1
  dbgotop ()
  nBancIni := val( Banc )
  dbgobottom ()
  nBancFin := val( Banc )

  @ 08,39 get nBancIni   pict '9999'    valid ValidARQ( 99, 99, "BancARQ", "Código" , "Banc", "Descrição", "Nome", "Banc", "nBancIni", .t., 4, "Consulta de Bancos", "BancARQ", 30 )
  @ 09,39 get nBancFin   pict '9999'    valid ValidARQ( 99, 99, "BancARQ", "Código" , "Banc", "Descrição", "Nome", "Banc", "nBancFin", .t., 4, "Consulta de Bancos", "BancARQ", 30 ) .and. nBancFin >= nBancIni
  read

  if lastkey() == K_ESC
    select BancARQ
    set order to 1
    if lOpenBanc
      close
    else
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

  cBancIni := strzero( nBancIni, 4 )
  cBancFin := strzero( nBancFin, 4 )

  select BancARQ
  set order to 1
  dbseek( cBancIni, .t. )
  do while Banc >= cBancini .and. Banc <= cBancfin .and. !eof()
    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
      
      lInicio := .f.
    endif
    
    if nLin == 0
      Cabecalho( 'Bancos', 80, 4 )
      CabBanc()
    endif
       
    @ nLin,00 say Banc
    @ nLin,15 say alltrim( Nome ) 
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
      replace Titu       with "Relatório de Bancos"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
    close
  endif  

  select BancARQ
  set order to 1
  if lOpenBanc
    close
  else
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabBanc()
  @ 02,00 say 'Codigo'
  @ 02,15 say 'Descrição'

  nLin := 4
return NIL