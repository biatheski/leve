//  Leve, Bibliotecas de funcoes
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

function topajud()
return(.t.)

function ksetcaps()
return(.t.)

// 
// Inicializa o Sistema
// 
function InicSoft ()
 
  set scoreboard   off
  set cursor       off
  set wrap         on
  set delete       on
  set stat         on
  set message      to 24
  set date         to brit
  set century      on
  set epoch        to 1950 
  
  set key K_F1     to Ajuda     ()
  set key K_F2     to ConsGeral ()
  set key K_F3     to Recado    ()
  set key K_F5     to MoviTela  ()
  set key K_F6     to Calendar  ()
  set key K_F9     to Calcular  ()

  public aMesExt [ 12 ]
  aMesExt [ 01 ] := 'JANEIRO  '
  aMesExt [ 02 ] := 'FEVEREIRO'
  aMesExt [ 03 ] := 'MARCO    '
  aMesExt [ 04 ] := 'ABRIL    '
  aMesExt [ 05 ] := 'MAIO     '
  aMesExt [ 06 ] := 'JUNHO    '
  aMesExt [ 07 ] := 'JULHO    '
  aMesExt [ 08 ] := 'AGOSTO   '
  aMesExt [ 09 ] := 'SETEMBRO '
  aMesExt [ 10 ] := 'OUTUBRO  '
  aMesExt [ 11 ] := 'NOVEMBRO '
  aMesExt [ 12 ] := 'DEZEMBRO '
  
  public aDiaExt [ 31 ]
  aDiaExt [ 01 ] := 'PRIMEIRO '
  aDiaExt [ 02 ] := 'DOIS'
  aDiaExt [ 03 ] := 'TRES'
  aDiaExt [ 04 ] := 'QUATRO'
  aDiaExt [ 05 ] := 'CINCO'
  aDiaExt [ 06 ] := 'SEIS'
  aDiaExt [ 07 ] := 'SETE'
  aDiaExt [ 08 ] := 'OITO'
  aDiaExt [ 09 ] := 'NOVE'
  aDiaExt [ 10 ] := 'DEZ'
  aDiaExt [ 11 ] := 'ONZE'
  aDiaExt [ 12 ] := 'DOZE'
  aDiaExt [ 13 ] := 'TREZE'
  aDiaExt [ 14 ] := 'QUATORZE'
  aDiaExt [ 15 ] := 'QUINZE'
  aDiaExt [ 16 ] := 'DEZESSEIS '
  aDiaExt [ 17 ] := 'DEZESSETE'
  aDiaExt [ 18 ] := 'DEZOITO'
  aDiaExt [ 19 ] := 'DEZENOVE'
  aDiaExt [ 20 ] := 'VINTE'
  aDiaExt [ 21 ] := 'VINTE E UM'
  aDiaExt [ 22 ] := 'VINTE E DOIS'
  aDiaExt [ 23 ] := 'VINTE E TRES'
  aDiaExt [ 24 ] := 'VINTE E QUATRO'
  aDiaExt [ 25 ] := 'VINTE E CINCO'
  aDiaExt [ 26 ] := 'VINTE E SEIS'
  aDiaExt [ 27 ] := 'VINTE E SETE'
  aDiaExt [ 28 ] := 'VINTE E OITO'
  aDiaExt [ 29 ] := 'VINTE E NOVE'
  aDiaExt [ 30 ] := 'TRINTA'
  aDiaExt [ 31 ] := 'TRINTA E UM'

  public aAnoDez [ 09 ]
  aAnoDez [ 2 ] := 'VINTE'
  aAnoDez [ 3 ] := 'TRINTA'
  aAnoDez [ 4 ] := 'QUARENTA'
  aAnoDez [ 5 ] := 'CINQUENTA'
  aAnoDez [ 6 ] := 'SESSENTA'
  aAnoDez [ 7 ] := 'SETENTA'
  aAnoDez [ 8 ] := 'OITENTA'
  aAnoDez [ 9 ] := 'NOVENTA'
 
  public aAnoUni [ 09 ]
  aAnoUni [ 01 ] := 'UM'
  aAnoUni [ 02 ] := 'DOIS'
  aAnoUni [ 03 ] := 'TRES'
  aAnoUni [ 04 ] := 'QUATRO'
  aAnoUni [ 05 ] := 'CINCO'
  aAnoUni [ 06 ] := 'SEIS'
  aAnoUni [ 07 ] := 'SETE'
  aAnoUni [ 08 ] := 'OITO'
  aAnoUni [ 09 ] := 'NOVE'
return NIL

// 
// Mostra Tela de Entrada
// 
function TelaSoft ( lEntr )

  local tTela     := savescreen ( 00, 00, 24, 79 )
  local nLin      := iif( lEntr, 03, 05 )
  local nLia      := iif( lEntr, 05, 07 )
  local nLinIni   := iif( lEntr, 04, 06 )
  local nLinha    := iif( lEntr, 04, 06 )
  local lCapsLock := ksetcaps ()

  if EmprARQ->CapsLock == "X"
    ksetcaps(.t.)
  endif  

  for i := 1 to len( CorMenus ) 
    if substr( CorMenus, i, 1 ) == '/'
      cMenuFundo := 'n' + substr( CorMenus, i )
      exit
    endif
  next               

  for i := 1 to len( CorFundo ) 
    if substr( CorFundo, i, 1 ) == '/'  
      cCorFundo := alltrim( substr ( CorFundo, i + 1  ) )
      exit
    endif
  next   
  
  setcolor( CorFundo )
  clear screen
  
  setcolor ( CorCabec )
  @ 00,00 say space(80)
  @ 00,01 say mensagem( 'Janela', 'IniSoft', .f. )
  
  setcolor ( CorMenus )
  @ nLin,04 say chr(218) + replicate(chr(196), 69) + chr(191); nLin ++
  @ nLin,04 say chr(179) + '          ÚÄ¿          ÚÄÄÄÄÄÄÄÄ¿   ÚÄ¿    ÚÄ¿   ÚÄÄÄÄÄÄÄÄ¿          ' + chr(179); nLin ++
  @ nLin,04 say chr(179) + '          ³ ³          ³ ÚÄÄÄÄÄÄÙ   ³ ³    ³ ³   ³ ÚÄÄÄÄÄÄÙ          ' + chr(179); nLin ++
  @ nLin,04 say chr(179) + '          ³ ³          ³ ³          ³ ³    ³ ³   ³ ³                 ' + chr(179); nLin ++
  @ nLin,04 say chr(179) + '          ³ ³          ³ ÀÄÄÄ¿      ³ À¿  ÚÙ ³   ³ ÀÄÄÄ¿             ' + chr(179); nLin ++
  @ nLin,04 say chr(179) + '          ³ ³          ³ ÚÄÄÄÙ      À¿ ³  ³ ÚÙ   ³ ÚÄÄÄÙ             ' + chr(179); nLin ++
  @ nLin,04 say chr(179) + '          ³ ³          ³ ³           ³ À¿ÚÙ ³    ³ ³                 ' + chr(179); nLin ++
  @ nLin,04 say chr(179) + '          ³ ÀÄÄÄÄÄÄ¿   ³ ÀÄÄÄÄÄÄ¿    À¿ ÀÙ ÚÙ    ³ ÀÄÄÄÄÄÄ¿          ' + chr(179); nLin ++
  @ nLin,04 say chr(179) + '          ÀÄÄÄÄÄÄÄÄÙ   ÀÄÄÄÄÄÄÄÄÙ     ÀÄÄÄÄÙ     ÀÄÄÄÄÄÄÄÄÙ          ' + chr(179); nLin ++
  @ nLin,04 say chr(179) + '                                                                     ' + chr(179); nLin ++
  @ nLin,04 say chr(179) + '        Copyright (C) Sistema integrado LEVE ' + cVersao + '  1992-2015        ' + chr(179); nLin ++
  @ nLin,04 say chr(179) + '                    Todos os direitos reservados                     ' + chr(179); nLin ++
  @ nLin,04 say chr(192) + replicate(chr(196), 69) + chr(217); nLin ++

  
  setcolor ( 'u/u' )
  scroll ( nLin, 06, nLin, 76, 0 )
  scroll ( nLinIni, 75, nLin, 76, 0 )
      
  if lEntr  
    Janela( 18, 20, 22, 55, mensagem( 'Janela', 'TelaSoft', .f. ), .f., .t. )
    for nO := 1 to 3 
      cPass := space(12)
      cIden := space(15)
      lOkey := .f.

      setcolor( CorCampo )
      @ 20,37 say cIden
      @ 21,37 say cPass

      setcolor( CorJanel )
      @ 20,22 say ' Identificação'
      @ 21,22 say '         Senha'
    
      @ 20,37 get cIden          
      read 

      if lastkey() == K_ESC
        if lCapsLock
          ksetcaps(.f.)
        endif  
        Finalizar(.t.)
      endif  
             
      cPass := PASSWORD( 21, 37, 12, chr(254) )
      
      select UsuaARQ
      set order to 3
      dbseek( cIden + encode( cPass ), .f. )
    
      if found()
        cUsuario := Usua
        lOkey    := .t.
          
        select LogoARQ
        if ArqLock()
          dbgotop ()
          do while !eof ()
            if Data < date ()
              if RegLock()
                replace Usua     with space(03)
                replace Data     with ctod('  /  /  ')       
                replace Hora     with space(08)
                dbunlock ()
              endif  
            endif    
            dbskip ()            
          enddo
                    
          dbgotop ()
          do while !eof()
            if empty( Usua ) .and. empty( Hora ) .and. empty( Data )
              nEstacao := Esta
              dLogData := date()
              cLogHora := time()
              
              if RegLock() 
                replace Usua     with cUsuario
                replace Data     with date()
                replace Hora     with time()
                dbunlock ()
              endif
              exit
            endif
            dbskip ()
          enddo
          
          if eof()
            Alerta( Mensagem( 'Alerta', 'LimiteUser', .f. ) )
          endif
          
          dbunlock ()
        endif  
        exit
      else
        tone( 700, 4 )
      endif
    next 
    if !lOkey
      Finalizar(.t.)
    endif
  else 
    inkey(0)
  endif     
  
  restscreen ( 00, 00, 24, 79, tTela )
return NIL

//
// Senha
// 
function PASSWORD( nLin, nCol, nTamanho, cChr )
 
  local cWord  := space( nTamanho ) 
  local nConta := 0 
  local cLetra := 0
 
  nCol --

  setcolor( CorCampo )
  @ nLin, nCol + 1 say space( nTamanho )
  
  setpos( nLin, nCol + 1 )

  do while nConta < nTamanho
    cLetra := 0
    do while cLetra == 0
      cLetra := inkey()
    enddo  
    do case
      case cLetra == K_CTRL_S
        select UsuaARQ
        set order to 3
        dbseek( cIden, .t. )
        
        if cIden == Iden
          cWord := decode( Senha )
        
          if len( alltrim( cWord ) ) < nTamanho
            nEspaco := nTamanho - len( alltrim( cWord ) ) 
            cSenhas := alltrim( cWord ) + space( nEspaco )
            
            @ nLin,nCol+1 say cSenhas
            inkey(0)
            
            return ( cSenhas )
          endif
        endif  
      case cLetra == K_ESC
        if len( alltrim( cWord ) ) < nTamanho
          nEspaco := nTamanho - len( alltrim( cWord ) ) 
          cSenhas := alltrim( cWord ) + space( nEspaco )
        endif
        return ( cSenhas )
      case cLetra == K_ENTER
        if len( alltrim( cWord ) ) < nTamanho
          nEspaco := nTamanho - len( alltrim( cWord ) ) 
          cSenhas := alltrim( cWord ) + space( nEspaco )
        endif

        return ( cSenhas )
      case cLetra == K_BS .and. empty( cLetra )
        loop
      case cLetra == K_BS 
        if nConta + nCol == nCol
          loop
        endif
        cWord := left( cWord, len( cWord ) - 1 )
        @ nLin, nCol + nConta say ' '
        nConta --
        loop
    endcase     
          
    nConta  ++
    cWord += chr( cLetra ) 
    @ nLin, nCol + nConta say cChr
  enddo
  
  cSenhas := cWord 

  if len( alltrim( cWord ) ) < nTamanho
    nEspaco := nTamanho - len( alltrim( cWord ) ) 
    cSenhas := alltrim( cWord ) + space( nEspaco )
  endif

return ( cSenhas )

//
// Verifica se a copia eh demonstrativa 
//
function Demo()
return(.f.)

//
// Mostra tela de Ajuda do Sistema
//
function Ajuda ()

  local tAjuda   := savescreen ( 00, 00, 23, 79 )
  local CorAtual := setcolor ()
  local cArqu    := alias ()

  Janela( 03, 08, 19, 71, 'Ajuda', .f. )

  set key K_F1        to
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  setcolor ( CorJanel )

  select AjudARQ
  set order to 1
  dbseek( cAjuda, .f. )
  
  cTexto := memoread( cCaminho + HB_OSpathseparator() + "ajuda" + HB_OSpathseparator() + alltrim( rotina ) + ".hlp" )
  cEdit  := memoedit( cTexto, 05, 09, 18, 70, .t., "OutProd" )

  if lastkey() == K_CTRL_W
    if eof()
      if AdiReg(0)
        dbunlock()
      endif
    endif
    if RegLock()
      replace Rotina       with cAjuda
      replace Texto        with cEdit
      dbunlock ()
    endif  
  endif   
     
  select( cArqu )
  setcolor( CorAtual )

  set key K_F1 to Ajuda     ()
  
  restscreen ( 00, 00, 23, 79, tAjuda )
return NIL

//
// Constroi uma caixa com beep
//
function Alerta ( cTitu, cTempo )
  local tAlerta   := savescreen ( 00, 00, 23, 79 )
  local cCorAtual := setcolor()

  tone( 700, 4 )
  
  Sombra( 09, 20, 13, 60 )

  setcolor ( CorCabec )
  @ 09, 20 clear to 13, 60

  @ 09, 20 to 13, 60
  
  cLinha1 := substr( cTitu, 01, 37 ) 
  cLinha2 := substr( cTitu, 38, 37 ) 
  cLinha3 := substr( cTitu, 76, 37 ) 
  
  if len( alltrim( cTitu ) ) > 37
    @ 10, 22 say cLinha1
    @ 11, 22 say cLinha2
    @ 12, 22 say cLinha3
  else
    @ 11, 22 say padc( cLinha1, 37 )
  endif
  
  if empty( cTempo ) 
    Teclar(0)
  else
    inkey( cTempo )
  endif    
  
  restscreen ( 00, 00, 23, 79, tAlerta )
  setcolor( cCorAtual )
return(.f.)

// 
// Barra da seta - Vertical
// 
function BARRASETA( nLinBarra, nLinIni, nLinFin, nColFin, nElem, cPreench, cAltSay )

  local nLine, nPercent, cCor := SETCOLOR(), nDifLine, nLinha := row(), nColuna := col()

  nDifLine := ( nLinFin - nLinIni ) - 1

  if !nDifLine > 4
    return(.f.)
  endif                               

  cPreench := iif( cPreench == NIL, '±', cPreench )
  cAltSay  := iif( cAltSay  == NIL, ' ', cAltSay )

  setcolor ( 'n/w+' )
  @ nLinIni, nColFin say chr(24)
  @ nLinFin, nColFin say chr(25)
 
  setcolor( 'n/w+' )
  for ii := ( nLinIni + 1 ) to ( nLinFin - 1 )
    @ ii, nColFin say cPreench
  next

  if nElem > 0
    nPercent := ( nLinBarra * 100 ) / nElem
  else
    nPercent := 1  
  endif  

  nLine := int( ( nPercent * nDifLine ) / 100 )

  if nLinBarra == 1 .or. nLine < 1
    nLine := 1
  elseif nLinBarra == nElem .or. nLine > nDifLine
    nLine := nDifLine
  endif

  setcolor( 'w+/n' )   
  @ ( nLine + nLinIni ), nColFin say cAltSay

  setpos( nLinha, nColuna )
  setcolor(cCor)
return(.t.)

// 
// Sair do Sistema
// 
function Finalizar( lSaida )

  local tSair := savescreen( 00, 00, 22, 79 )
  local lSair := iif( valtype( lSaida ) != 'L', .t., lSaida )
  
  ksetcaps(.f.)
  
  if lSair
    dirchange( cCaminho )
    
    if NetUse( "LogoARQ", .t. )
      VerifIND( "LogoARQ" )
 
      #ifdef DBF_NTX 
        set index to LogoIND1
      #endif  
    endif  

    select LogoARQ
    set order to 1
    dbseek( nEstacao, .f. )

    if RegLock()
      replace Usua     with space(063)
      replace Data     with ctod('  /  /  ')       
      replace Hora     with space(08)
      dbunlock ()
    endif   

    for i := 1 to len( CorFundo ) 
      if substr( CorFundo, i, 1 ) == '/'  
        cCorFundo := alltrim( substr ( CorFundo, i + 1  ) )
        exit
      endif
    next   
                
    setcolor ( '+w/n' )
    clear screen
    @ 00, 00 say 'LEVE ' + cVersao 
    @ 02, 00
    
    dbcommitall ()
    dbcloseall ()
   
    set color to
    quit
  else 
    Janela ( 06, 31, 10, 49, mensagem( 'Janela', 'Finalizar', .f. ), .f. )
    Mensagem( 'LEVE', 'Sair' ) 
    setcolor ( CorCampo + ',' + CorOpcao )

    if ConfLinha( 8, 34, 1 )

      dirchange( cCaminho )
    
      if NetUse( "LogoARQ", .t. )
        VerifIND( "LogoARQ" )
 
        #ifdef DBF_NTX 
          set index to LogoIND1
        #endif
      endif  

      select LogoARQ
      dbseek( nEstacao, .f. )
      if RegLock()
        replace Usua     with space(03)
        replace Data     with ctod('  /  /  ')       
        replace Hora     with space(08)
        dbunlock ()
      endif  

      Janela( 06, 17, 14, 59, mensagem( 'Janela', 'Finalizar2', .f. ), .f., .t. )
  
      setcolor( CorJanel )
      @ 08,20 say 'Usuário'
      @ 09,20 say '    Dia' 
      @ 10,20 say '   Hora' 
      @ 11,20 say '  Tempo'
    
      @ 13,30 say 'Deslogando da estação n'+ chr(167)

      setcolor( CorCampo )
   
      select UsuaARQ
      set order to 1
      dbseek( cUsuario, .f. )
      
      nTempo := sectotime( timetosec( time() ) - timetosec( cLogHora ) )
   
      @ 08,28 say Nome           pict '@S30' 
      @ 09,28 say dLogData       pict '99/99/9999'
      @ 10,28 say cLogHora      
      @ 11,28 say nTempo
       
      @ 13,55 say nEstacao       pict '999'

      inkey(.5)

      for i := 1 to len( CorFundo ) 
        if substr( CorFundo, i, 1 ) == '/'  
          cCorFundo := alltrim( substr ( CorFundo, i + 1  ) )
          exit
        endif
      next   
    
      dbcommitall ()
      dbcloseall ()
                
      setcolor ( '+w/n' )
      clear screen
      @ 00, 00 say 'LEVE ' + cVersao 
      @ 02, 00
    
      set color to
      quit
    endif
  endif  
  
  restscreen( 00, 00, 22, 79, tSair )
return NIL

// 
// Mensagem
// 
function Mensagem( aProg, aLoca, aView )

  local cCorsss := setcolor()
  local cArquii := alias()

  if aLoca == NIL
    aLoca := ' ' 
  endif  
  
  if aView == NIL
    aView := .t.
  endif  
  
  if aView
    setcolor ( CorFundo )
    @ 24, 00 say space(80)
  endif

  select MensARQ
  set order to 1
  dbseek( cIdioma + aProg + space( 10 - len( alltrim( aProg ) ) ) + aLoca + space( 15 - len( alltrim( aLoca ) ) ), .f. )
  
  if aView
    if found()
      @ 24, 01 say Mens 
    else
      @ 24, 01 say aProg + " " + aLoca 
    endif  
  
    setcolor ( CorMenus )
    @ 23, 42 say time ()
    @ 23, 51 say date ()
  endif
 
  if select( cArquii ) > 0
    select( cArquii )
  endif
  
  setcolor( cCorsss ) 
  if !aView
    return(alltrim(MensARQ->Mens))
  endif  
return NIL

// 
// Mostra sombra e nao apaga o que esta embaixo
// 
function Sombra ( ls, cs, li, ci )
  local tCol := savescreen ( ls+1, ci+1, li+1, ci+2 )
  local tLin := savescreen ( li+1, cs+2, li+1, ci+2 )

  for i := 2 to len(tCol)  step 2
    tCol := stuff ( tCol, i, 1, chr(1) )
  next

  for i := 2 to len(tLin) step 2
    tLin := stuff ( tLin, i, 1, chr(1) )
  next

  restscreen ( ls+1, ci+1, li+1, ci+2, tCol )
  restscreen ( li+1, cs+2, li+1, ci+2, tLin )
return NIL

// 
// Calendario Permanente
// 
function Calendar()
  local cDBF     := alias()
  local cCores   := setcolor()
  local tCale    := savescreen( 00, 00, 23, 79 )
  
  nLinIni  := 6 
  nColIni  := 25
  nLinFin  := nLinIni + 11
  nColFin  := nColIni + 31
  nDataIni := date()
  nDiaIni  := day( nDataIni )
  lFlag    := .t.

  Janela ( nLinIni, nColIni, nLinFin, nColFin, mensagem( 'Janela', 'Calendar', .f. ), .f. )

  Mensagem( 'Libi', 'Calendar' ) 
  setcolor( CorJanel )
  @ nLinIni + 3, nColIni say chr(195) + replicate( chr(196), 30 ) + chr(180)
 
  do while lFlag
    ExibeCale ()

    nMes      := month( nDataIni )
    nAno      := year( nDataIni )  
    nLinhaIni := nLinIni
    nColunIni := nColIni
    cTecla    := Teclar(0)
    
    do case
      case cTecla == K_RIGHT
        nMes := nMes + iif( nMes < 12, 1, -11 )
      case cTecla == K_LEFT
        nMes := nMes - iif( nMes > 1, 1, -11 )
      case cTecla == K_UP
        nAno ++
      case cTecla == K_DOWN
        nAno --
      case cTecla == K_ESC
        restscreen( 00, 00, 23, 79, tCale )
        exit
    endcase     
    
    nDataIni := ctod( '01/' + strzero( nMes, 2 ) + '/' + strzero( nAno, 4 ) )
    cTecla   := 0
  enddo
  
  select ( cDBF )
  setcolor( cCores )
return NIL
  
function ExibeCale()
  nAno  := year( nDataIni )
  nMes  := month( nDataIni )    
  nDias := CalcDia( nMes, nAno )
  nLi   := 1
  nCi   := dow( ctod( '01/' + strzero( nMes, 2 ) + '/' + strzero( nAno, 4 ) ) )    
  nMese := val( strzero( nMes, 2 ) )
  
  setcolor( CorCampo ) 
  @ nLinIni + 2, nColIni + 06 say aMesExt[ nMese ] 
  @ nLinIni + 2, nColIni + 22 say strzero( nAno, 4 )  

  setcolor( CorJanel )
  @ nLinIni + 2, nColIni + 02 say 'Mˆs '
  @ nLinIni + 2, nColIni + 18 say 'Ano '
  @ nLinIni + 4, nColIni + 2 say 'Dom Seg Ter Qua Qui Sex Sab '
  @ nLinIni + 5, nColIni + 2 clear to nLinFin - 1, nColFin - 2
  
  for nLaco := 1 to nDias
    if nLaco == nDiaIni
      setcolor( CorCampo ) 
    endif
    
    @ nLi + nLinIni + 4, nColIni + nCi * 4 - 1 say strzero( nLaco, 2 )

    setcolor( CorJanel )  
    nCi ++
    if nCi > 7
      nCi := 1
      nLi ++
    endif
  next
return    

function CalcDia( nMes, nAno )

return( 30 + ( nMes + iif( nMes > 7, 1, 0 ) ) % 2 - ;
        iif( nMes == 2, 1, 0 ) * ( 2 - ( iif( ( nAno - 92 ) % 4 == 0 , 1, 0 ) ) ) )

//
// Constroi uma Janela em 3D com sombras, Titulo e Confirmacao
//
function Janela ( wLinIni, wColIni, wLinFin, wColFin, wTitu, wDrop, wErro, wCenter )

  Sombra( wLinIni, wColIni, wLinFin, wColFin )

  setcolor( CorJanel )
  @ wLinIni, wColIni clear to wLinFin, wColFin

  setcolor( CorBorJa )
  @ wLinIni, wColIni to wLinFin, wColFin 
  if wDrop
    @ wLinFin - 2, wColIni say chr(195) + replicate(chr(196),wColFin-wColIni-1) + chr(180)
  endif

  setcolor( CorCabec )
  @ wLinIni, wColIni say space ( wColFin - wColIni + 1 )
  if wCenter != NIL
    @ wLinIni, wColIni + ( ( wColFin - wColIni + 1 - len (wTitu) ) / 2 ) say wTitu
  else 
    @ wLinIni, wColIni + 1 say wTitu
  endif
 
  if wErro == NIL
    setcolor ( CorMenus )
    @ 23, 42 say time ()
    @ 23, 51 say date ()
 endif   
return NIL

//
// Constroi uma janela com Confirmacao Completa
//
function Confirmar ( nLinha, cOImpr, cOExcl, cOConf, cOCanc, cOpcao )
  local nOpConf := cOpcao
  local tLinha  := savescreen( 24, 01, 24, 79 )
  local aOpcoes := {}
  
  if lastkey() == K_ESC
    cStat := 'loop'
    return NIL
  endif  
  
  aadd( aOpcoes, { ' Imprimir ',  2, 'I', nLinha, cOImpr, Mensagem( "LEVE","Imprimir", .f. ) } )
  aadd( aOpcoes, { ' Excluir ' ,  6, 'U', nLinha, cOExcl, Mensagem( "LEVE","Excluir", .f. ) } )
  aadd( aOpcoes, { ' Confirmar ', 2, 'C', nLinha, cOConf, Mensagem( "LEVE","Confirmar", .f. ) } )
  aadd( aOpcoes, { ' Cancelar ',  3, 'A', nLinha, cOCanc, Mensagem( "LEVE","Cancelar", .f. ) } )
    
  nOpConf := HCHOICE( aOpcoes, 4, nOpConf, .t. )
    
  do case
    case nOpConf == 0 .or. nOpConf == 4
      cStat := 'loop'
    case nOpConf == 1
      cStat := 'prin'
    case nOpConf == 2
      cStat := 'excl'
  endcase
  restscreen( 24, 01, 24, 79, tLinha )
return NIL

// 
// Teclar similiar ao inkey
// 
function Teclar( pTime )
  local nAperto := 0
  local cCor    := setcolor()
  
  if EmprARQ->CapsLock == "X"
    ksetcaps(.t.)
  endif  
  
  setcolor( CorMenus )

  if pTime == NIL
    @ 23,42 say time()
    @ 23,51 say date()
  else  
    nAperto := 0  
    cTempo  := sectotime( timetosec( time() ) + timetosec( '00:02' ) ) 
    
    do while nAperto == 0
      nAperto := inkey()

      @ 23,42 say time()
      @ 23,51 say date()

      if lRecado
        cArqu := alias()
        
        select RecaARQ
        set order to 1
        dbgotop()
        do while !eof()
          
          dbskip()
        enddo
        
        select( cArqu )    
      endif
      
      if time() >= cTempo .and. time() <= '23:57'
        MoviTela()
        
        exit
      endif  
    enddo  
  endif  
  
  setcolor( cCor )
return( nAperto )

// 
// Escolhe Opcoes - Horizontal
// 
function HCHOICE ( aOpcoes, nItem, nAtual, lKey )
  local nInd, nLin, nCol, cItem, cAltKey
  local aAltKeyO  := {}
  local lAltKeyO  := .t.
  local lHotKeyO  := .t. 
  local cCorFundo := '' 

  for n := 1 to len( CorAltKM )
    if substr( CorAltKM, n, 1 ) == '/'
      cCorFundo := left( CorAltKM, n )
    endif
  next

  for n := 1 to len( CorAltKO )
    if substr( CorAltKO, n, 1 ) == '/'
      cCorFundo := cCorFundo + substr( CorAltKO, n + 1 )
    endif
  next
/*  
  if ( lastkey() == K_PGDN .or. nAtual == 0 ) .and. lKey == NIL
    return( nAtual )
  endif  
*/  
  if nAtual == 0 
    return ( nAtual )
  endif

  for nInd := 1 to nItem 
    cItem    := aOpcoes [ nInd, 1 ]
    nAltK    := aOpcoes [ nInd, 2 ]
    nLin     := aOpcoes [ nInd, 4 ]
    nCol     := aOpcoes [ nInd, 5 ]

    cAltKey  := substr( cItem, nAltK, 1 )
    nLinAltK := nLin
    nColAltK := nCol + nAltK - 1 

    aadd ( aAltKeyO, { cAltKey, nLinAltK, nColAltK } )
    
    setcolor( CorCampo )
    @ nLin, nCol say cItem
    
    setcolor( CorAltKC )
    @ nLin, nColAltK say cAltKey
  next

  do while .t.
    if lAltKeyO
      for nInd := 1 to nItem
        cAltKey  :=  aAltKeyO [ nInd, 1 ]
        nLinAltK :=  aAltKeyO [ nInd, 2 ]
        nColAltK :=  aAltKeyO [ nInd, 3 ]

        if nInd != nAtual
          setcolor ( CorAltKc )
          @ nLinAltK, nColAltK say cAltKey
        endif
      next
    else
      if !lHotKeyO
        lHotKeyO := .t.
      endif
    endif

    cItem := aOpcoes [ nAtual, 1 ]
    nLin  := aOpcoes [ nAtual, 4 ]
    nCol  := aOpcoes [ nAtual, 5 ]
 
    setcolor ( CorOpcao )
    @ nLin, nCol say cItem

    if lAltKeyO
      cAltKey  := aAltKeyO [ nAtual, 1 ]
      nLinAltK := aAltKeyO [ nAtual, 2 ]
      nColAltK := aAltKeyO [ nAtual, 3 ]

      setcolor ( cCorFundo )
      @ nLinAltK, nColAltK say cAltKey
    endif
    
    if !empty( aOpcoes [nAtual, 6] )  
      setcolor( CorFundo )
      @ 24,00 say space(80)
      @ 24,01 say aOpcoes[nAtual, 6] 
    endif
    
    cTecla := Teclar(0)
    
    do case
      case cTecla == K_ENTER
        exit
      case cTecla == K_ESC
        nAtual := 0
        exit
      case cTecla == K_RIGHT .or. cTecla == K_DOWN
        cItem   := aOpcoes [ nAtual, 1 ]
        nLin    := aOpcoes [ nAtual, 4 ]
        nCol    := aOpcoes [ nAtual, 5 ]
        setcolor ( CorCampo )
        @ nLin, nCol say cItem

        nAtual++
        if nAtual > nItem
          nAtual := 1
        endif
      case cTecla == K_LEFT .or. cTecla == K_UP
        cItem   :=  aOpcoes [ nAtual, 1 ]
        nLin    :=  aOpcoes [ nAtual, 4 ]
        nCol    :=  aOpcoes [ nAtual, 5 ]
        setcolor ( CorCampo )
        @ nLin, nCol say cItem
 
        nAtual--
        if nAtual == 0
          nAtual := nItem
        endif
      case cTecla == 32
        cItem   :=  aOpcoes [ nAtual, 1 ]
        nLin    :=  aOpcoes [ nAtual, 4 ]
        nCol    :=  aOpcoes [ nAtual, 5 ]
        setcolor ( CorCampo )
        @ nLin, nCol say cItem
        nAtual := 1
        keyboard chr(K_ENTER)
      case ( cTecla >=  65 .and. cTecla <=  90 ) .or.;
           ( cTecla >=  97 .and. cTecla <= 128 ) .or.;
           ( cTecla >= 272 .and. cTecla <= 306 ) 
        do case
          case cTecla >= 97  .and. cTecla <= 128 
            cTecla -= 32
        endcase

        for nInd := 1 to len ( aAltKeyO )
          if upper ( aOpcoes [ nInd, 3 ] ) == chr(cTecla)
            cItem   := aOpcoes [ nAtual, 1 ]
            nLin    := aOpcoes [ nAtual, 4 ]
            nCol    := aOpcoes [ nAtual, 5 ]

            setcolor ( CorCampo )
            @ nLin, nCol say cItem
            nAtual := nInd
            keyboard chr(K_ENTER)
            exit
          endif
        next
      case cTecla == K_F10
        Finalizar(.t.)  
      otherwise
        keyboard ""
    endcase
  enddo
return ( nAtual )

// 
// Escolhe Opcoes - Vertical
// 
function VCHOICE ( aOpcoes, nItem, nAtual )
  local nInd, nLin, nCol, cItem, cAltKey
  local aAltKeyO := {}
  local lAltKeyO := .t.
  local lHotKeyO := .t. 

  if nAtual == 0
    return ( nAtual )
  endif

  for nInd := 1 to nItem 
    cItem    := aOpcoes [ nInd, 1 ]
    nAltK    := aOpcoes [ nInd, 2 ]
    nLin     := aOpcoes [ nInd, 4 ]
    nCol     := aOpcoes [ nInd, 5 ]

    cAltKey  := substr( cItem, nAltK, 1 )
    nLinAltK := nLin
    nColAltK := nCol + nAltK - 1 

    aadd ( aAltKeyO, { cAltKey, nLinAltK, nColAltK } )
    
    setcolor( CorMenus )
    @ nLin, nCol say cItem
  next

  do while .t.
    if lAltKeyO
      for nInd := 1 to nItem
        cAltKey  := aAltKeyO [ nInd, 1 ]
        nLinAltK := aAltKeyO [ nInd, 2 ]
        nColAltK := aAltKeyO [ nInd, 3 ]

        if nInd != nAtual
          setcolor ( CorAltKm )
          @ nLinAltK, nColAltK say cAltKey
        endif
      next
    else
      if !lHotKeyO
        lHotKeyO := .t.
      endif
    endif

    cItem    := aOpcoes[ nAtual, 1 ]
    nLin     := aOpcoes[ nAtual, 4 ]
    nCol     := aOpcoes[ nAtual, 5 ]
    cAltKey  := aAltKeyO[ nAtual, 1 ]
    nLinAltK := aAltKeyO[ nAtual, 2 ]
    nColAltK := aAltKeyO[ nAtual, 3 ]
 
    setcolor ( CorOpcao )
    @ nLin, nCol say cItem

    if lAltKeyO
      cAltKey  := aAltKeyO [ nAtual, 1 ]
      nLinAltK := aAltKeyO [ nAtual, 2 ]
      nColAltK := aAltKeyO [ nAtual, 3 ]

      setcolor ( CorOpcao )
      @ nLinAltK, nColAltK say cAltKey
    endif
    
    setcolor ( CorAltKO )
    @ nLinAltK, nColAltK say cAltKey

    cTecla := Teclar(0)
    
    if !empty( aOpcoes [nAtual, 6] )  
      setcolor( CorFundo )
      @ 24,00 say space(80)
      @ 24,01 say aOpcoes[nAtual, 6] 
    endif

    do case
      case cTecla == K_ENTER
        exit
      case cTecla == K_ESC
        nAtual := 0
        exit
      case cTecla == K_RIGHT .or. cTecla == K_DOWN
        cItem   := aOpcoes [ nAtual, 1 ]
        nLin    := aOpcoes [ nAtual, 4 ]
        nCol    := aOpcoes [ nAtual, 5 ]
        setcolor ( CorMenus )
        @ nLin, nCol say cItem

        nAtual++
        if nAtual > nItem
          nAtual := 1
        endif
      case cTecla == K_LEFT .or. cTecla == K_UP
        cItem   :=  aOpcoes [ nAtual, 1 ]
        nLin    :=  aOpcoes [ nAtual, 4 ]
        nCol    :=  aOpcoes [ nAtual, 5 ]
        setcolor ( CorMenus )
        @ nLin, nCol say cItem
 
        nAtual--
        if nAtual == 0
          nAtual := nItem
        endif
      case cTecla == 32
        cItem   :=  aOpcoes [ nAtual, 1 ]
        nLin    :=  aOpcoes [ nAtual, 4 ]
        nCol    :=  aOpcoes [ nAtual, 5 ]
        setcolor ( CorMenus )
        @ nLin, nCol say cItem
        nAtual := 1
        keyboard chr(K_ENTER)
      case ( cTecla >=  65 .and. cTecla <=  90 ) .or.;
        ( cTecla >=  97 .and. cTecla <= 128 ) .or.;
        ( cTecla >= 272 .and. cTecla <= 306 ) 
       
        if cTecla >= 97 .and. cTecla <= 128 
           cTecla -= 32
        endif

        for nInd := 1 to len ( aAltKeyO )
          if upper ( aOpcoes [ nInd, 3 ] ) == chr(cTecla)
            cItem   := aOpcoes [ nAtual, 1 ]
            nLin    := aOpcoes [ nAtual, 4 ]
            nCol    := aOpcoes [ nAtual, 5 ]

            setcolor ( CorMenus )
            @ nLin, nCol say cItem
            nAtual := nInd
            keyboard chr(K_ENTER)
            exit
          endif
        next
      case cTecla == K_F10
        Finalizar(.t.)  
      otherwise
        keyboard ""
    endcase
  enddo
return ( nAtual )

// 
// Bloqueia um registro em rede
// 
function RegLock()
  local nSempre

  if rlock()
    return( .t. )
  endif
  
  nTentativas := 30
  nSempre     := ( nTentativas = 0 ) 

  do while ( nSempre .or. nTentativas > 0 )
    if rlock()
      return( .t. )
    endif
 
    inkey(1)
    nTentativas --
  enddo
  
  if nTentativas == 0
    Alerta( Mensagem( "Alerta", "RegLock", .f. ) + alias() ) 
  endif
return( .f. )

// 
// Adiciona um Registro em Rede
// 
function AdiReg()

  local nSempre

  dbappend ()

  if !neterr()
    return(.t.)
  endif
  
  nTentativas := 30
  nSempre     := ( nTentativas = 0 )

  do while( nSempre .or. nTentativas > 0 )
    dbappend ()
    
    if !neterr()
      return(.t.)
    endif
    
    inkey(1)
    
    nTentativas--
  enddo
  
  if nTentativas == 0
    Alerta( Mensagem( "Alerta", "RegLock", .f. ) + alias() ) 
  endif
return(.f.)

// 
// Screen-Saver
// 
function MoviTela ()
  if EmprARQ->Saver == 4
    do while .t. 
      nRnd := int( HB_random(5) )   
      if nRnd == cSavers
        loop
      else      
        cSavers := nRnd
        
        exit
      endif     
    enddo       
  else
    cSavers := EmprARQ->Saver
  endif

  do case 
    case cSavers == 1
      tDesc   := savescreen( 00, 00, 24, 79 )
      cCoor   := "08C07D12C11D06B01B02E07C08E09E14C13D08B03B04E09C10E05B04D09C14C15E10B09D04B03D"
      lVar    := .t.
      cCor    := setcolor()
  
      setcolor( CorFundo )
      @ 24,01 say space(70)
      @ 24,01 say mensagem( 'Libi', 'MoviTela' )
      
      do while lVar 
        for t := 1 to 79 step 3
          nQuadro  := val( substr( cCoor, t, 2 ) )
          cDirecao := substr( cCoor, t + 2, 1 )
          lVar     := move( cDirecao, nQuadro )
 
          if !lVar 
            exit
          endif
        next
      enddo
  
      setcolor( cCor)
      restscreen( 00, 00, 24, 79, tDesc )
    case cSavers == 2
      tSaver  := savescreen ( 00, 00, 24, 79 )
      nCol    := nLin := 04
      lLinSub := .t.
      lLinAdd := .f.
      cArqu   := alias()

      do while .t.
        setcolor ( CorMenus )
        @ nLin,nCol say chr(218) + replicate(chr(196),69) + chr(191)

        for nL := 1 to 8
          @ nLin + nL,nCol say chr(179) + left( memoline( EmprARQ->Screen, 69, nL ) + space(69), 69 ) + chr(179)
        next  

        @ nLin + 9,nCol say chr(192) + replicate(chr(196),69) + chr(217)
        
        cTecla := inkey(.1)
        
        if cTecla == K_CTRL_E 
          setcolor( CorCampo )
          cTexto := Memoedit( EmprARQ->Screen, nLin + 1, nCol + 1, nLin + 8, nCol + 69, .t., "MoviEdit", 69, , , 1, 0 ) 
          cTecla := 0
   
          if lastkey() == K_CTRL_W
            select EmprARQ
            if RegLock()
              replace Screen   with cTexto 
              dbunlock ()
            endif
          endif  

        endif   
         
        if cTecla != 0
          exit
        endif

        if lLinSub
          nLin --
          if nLin < 0
            nLin := 0
            nCol --
      
            setcolor ( CorFundo ) 
            @ nLin+00,nCol+71 say space(2)
            @ nLin+01,nCol+71 say space(2)
            @ nLin+02,nCol+71 say space(2)
            @ nLin+03,nCol+71 say space(2)
            @ nLin+04,nCol+71 say space(2)
            @ nLin+05,nCol+71 say space(2)
            @ nLin+06,nCol+71 say space(2)
            @ nLin+07,nCol+71 say space(2)
            @ nLin+08,nCol+71 say space(2)
            @ nLin+09,nCol+71 say space(2)
            if nCol <= 0
              lLinSub := .f.
              lLinAdd := .t.
              loop
            endif
          else
            setcolor ( CorFundo ) 
            @ nLin+10,nCol say space(71)
          endif
        endif
        if lLinAdd
          nLin ++
          if nLin == 16
            nLin := 15
            nCol ++
            setcolor ( CorFundo ) 
            @ nLin+00,nCol-2 say space(2)
            @ nLin+01,nCol-2 say space(2)
            @ nLin+02,nCol-2 say space(2)
            @ nLin+03,nCol-2 say space(2)
            @ nLin+04,nCol-2 say space(2)
            @ nLin+05,nCol-2 say space(2)
            @ nLin+06,nCol-2 say space(2)
            @ nLin+07,nCol-2 say space(2)
            @ nLin+08,nCol-2 say space(2)
            @ nLin+09,nCol-2 say space(2)
            if nCol == 09
              lLinSub := .t.
              lLinAdd := .f.
            endif
          else
            setcolor ( CorFundo ) 
            @ nLin-01,nCol say space(71)
          endif
        endif
      enddo
      if select( cArqu ) > 0
        select( cArqu )
      endif     
      restscreen ( 00, 00, 24, 79, tSaver )
    case cSavers == 3
      tSaver := savescreen( 00, 00, 24, 79 )
      cCor   := setcolor()
      
      aColun := {}
      aLinha := {}
      aCoord := {}

      Mensagem( 'LEVE', 'Pause' )

      aadd( aLinha, 00 );aadd( aLinha, 02 );aadd( aLinha, 04 )
      aadd( aLinha, 06 );aadd( aLinha, 08 );aadd( aLinha, 10 )
      aadd( aLinha, 12 );aadd( aLinha, 14 );aadd( aLinha, 16 )
      aadd( aLinha, 18 );aadd( aLinha, 20 );aadd( aLinha, 22 )
      
      aadd( aColun, 00 );aadd( aColun, 04 );aadd( aColun, 08 )
      aadd( aColun, 12 );aadd( aColun, 16 );aadd( aColun, 20 )
      aadd( aColun, 24 );aadd( aColun, 28 );aadd( aColun, 32 )
      aadd( aColun, 36 );aadd( aColun, 40 );aadd( aColun, 44 )
      aadd( aColun, 48 );aadd( aColun, 52 );aadd( aColun, 56 )
      aadd( aColun, 60 );aadd( aColun, 64 );aadd( aColun, 68 )
      aadd( aColun, 72 );aadd( aColun, 76 );aadd( aColun, 78 )
   
      for nO := 1 to len( aLinha )
        for nJ := 1 to len( aColun )
          aadd( aCoord, { aLinha[ nO ], aColun[ nJ ], .f. } )
        next    
      next 

      setcolor( 'w+/n' )
       
      cKey   := 0
      nItens := 0
      
      do while cKey == 0
        do while cKey == 0
          nNum := int( hb_random(len(aCoord)))

          if inkey(.3) != 0
            cKey := lastkey()
          endif  

          if nNum == 0
            loop
          endif

          if nItens >= len( aCoord )
            for nJ := 1 to len( aCoord )
              aCoord[ nJ, 3 ] := .f.
            next
            nItens := 0
            exit
          endif  
                                
          if aCoord[ nNum, 3 ]
            loop
          else
            aCoord[ nNum, 3 ] := .t.
            nItens            ++
          endif    

          @ aCoord[ nNum, 1 ],   aCoord[ nNum, 2 ] say '    ' 
          @ aCoord[ nNum, 1 ]+1, aCoord[ nNum, 2 ] say '    ' 
          enddo  
        
        if cKey == 0
          clear
          inkey(5)
        endif  
        restscreen( 00, 00, 24, 79, tSaver )
      enddo
       
      setcolor( cCor )
  endcase 
return NIL

function MoviEdit ( wModo, wLin, wCol )
  do case
    case lastkey() == K_ALT_T;    TabASCII()
    case lastkey() == K_F2;       keyboard(chr(219))
    case lastkey() == K_F3;       keyboard(chr(220))
    case lastkey() == K_F4;       keyboard(chr(223))
    case lastkey() == K_CTRL_RET; keyboard(chr(K_CTRL_W))
  endcase   
return(.t.)

static function Move( cDire, nQuadro )

  local nPo01, nPo02, nPosi, cQuadro
  local nLinIni, nColIni, nLinFin, nColFin, nC

  nPo01   := "000000000000715001607310032074700480763006407790800151508161531"
  nPo02   := "0832154708481563086415791600231516162331163223471648236316642379"
  nPosi   := nPo01 + nPo02
  cQuadro := substr( nPosi, nQuadro * 8, 8 )

  nLinIni := val( substr( cQuadro, 1, 2 ) )
  nColIni := val( substr( cQuadro, 3, 2 ) )
  nLinFin := val( substr( cQuadro, 5, 2 ) )
  nColFin := val( substr( cQuadro, 7, 2 ) )

  tQuad   := savescreen( nLinIni, nColIni, nLinFin, nColFin )

  nC      := nE     := nD    := 0
  nJ      := nB     := 0

  do case
    case cDire == "L"
      setcolor( "W/N" )
      @ nLinIni, nColIni clear to nLinFin, nColFin
    case cDire == "C"
      for nC := 0 to 7 step 2
        restscreen( nLinIni - nC, nColIni, nLinFin - nC, nColFin, tQuad )
        
        if inkey(0.1) != 0 
          return(.f.)
        endif
        
        setcolor( "W/N" )
        @ nLinIni - nC, nColIni clear to nLinFin - nC, nColFin
      next
      restscreen( nLinIni - nC, nColIni, nLinFin - nC, nColFin, tQuad )
    case cDire == "B"
      for nB := 0 to 7 step 2
        restscreen( nLinIni + nB, nColIni, nLinFin + nB, nColFin, tQuad )
        
        if inkey(0.1) != 0 
          return(.f.)
        endif
        
        setcolor( "W/N" )
        @ nLinIni + nB, nColIni clear to nLinFin + nB, nColFin
      next
      restscreen( nLinIni + nB, nColIni, nLinFin + nB, nColFin, tQuad )
    case cDire == "E"
      for nE := 0 to 15 step 2
        restscreen( nLinIni, nColIni - nE, nLinFin, nColFin - nE, tQuad )
        
        if inkey(0.1) != 0 
          return(.f.)
        endif
        
        setcolor( "W/N" )
        @ nLinIni, nColIni - nE clear to nLinFin, nColFin - nE
      next
      restscreen( nLinIni, nColIni - nE, nLinFin, nColFin - nE, tQuad )
    case cDire == "D"
      for nD := 0 to 15 step 2
        restscreen( nLinIni, nColIni + nD, nLinFin, nColFin + nD, tQuad )
        
        if inkey(0.1) != 0 
          return(.f.)
        endif
        
        setcolor( "W/N" )
        @ nLinIni, nColIni + nD clear to nLinFin, nColFin + nD
      next
      restscreen( nLinIni, nColIni + nD, nLinFin, nColFin + nD, tQuad )
  endcase
return(.t.)

//
// Codfica uma cadeia de caracteres
//
function Encode( cInString )

  local nCounter := nInLen := 0, cNextChar := cOutString := '', nAdjval := 30

  nInLen := len( cInString )

  for nCounter := nInlen to 1 step -1
    cNextChar  := substr( cInString, nCounter, 1 )
    cOutString += chr( ( asc( cNextChar ) + nAdjval ) * 2 )
  next
return( cOutString )

//
// Decodifica uma cadeia de caracteres codificada pelo ENCODE ()
//
function Decode( cInString )

  local nCounter := nInlen := 0, cOutString := '', nAdjval := 30

  nInlen := len( cInString )

  for nCounter := nInlen to 1 step -1
    cOutString += chr( ( asc( substr( cInString, nCounter, 1 ) ) / 2 ) - nAdjval )
  next
  
return( cOutString )

//
// Abre um arquivo em rede no modo compartilhado ou nao
//
function NetUse( pDBF, lModo )
  if right( pDBF, 3 ) == 'ARQ'
    if !file( pDBF + '.DBF' )
      CriaARQ( pDBF, .t. )
    endif  
  endif  
  
  if select ( pDBF ) > 0
    return(.f.)
  endif  
  
  nTentativas := 30

  do while ( nTentativas > 0 )
    if lModo 
      use ( pDBF ) shared    new
    else
      use ( pDBF ) exclusive new 
    endif
  
    if !neterr()
      return(.t.)
    endif
  
    inkey(1)                 
    nTentativas --
  enddo
  
  if nTentativas == 0
    Alerta( Mensagem( "Alerta", "NetUse", .f. ) + " " +  pDBF )
  endif
return( .f. )

//
// Bloqueia um arquivo em rede
//
function ArqLock()

  if flock()
    return( .t. )
  endif
  
  nTentativas := 30

  do while ( nTentativas > 0 )
    if flock()
      return( .t. )
    endif
    
    inkey(1)

    nTentativas --
  enddo
return( .f. )

// 
// Tabela onde serao escolhidas as cores
// 
function Core ()
  local tSemCor := savescreen( 00, 00, 24, 79 )

  declare aVet [16]
  declare aCor [128]

  aVet [1] := 'w'
  aVet [2] := 'b'
  aVet [3] := 'g'
  aVet [4] := 'bg'
  aVet [5] := 'r'
  aVet [6] := 'rb'
  aVet [7] := 'gr'
  aVet [8] := 'n'
  aVet [9] := 'n+'
  aVet [10] := 'b+'
  aVet [11] := 'g+'
  aVet [12] := 'bg+'
  aVet [13] := 'r+'
  aVet [14] := 'rb+'
  aVet [15] := 'gr+'
  aVet [16] := 'w+'
  
  select ParaARQ
  
  do case 
    case mOpcoes[ mCodItem, 3 ] == 08
      CorAntiga := Corfundo
    case mOpcoes[ mCodItem, 3 ] == 09
      CorAntiga := CorCabec
    case mOpcoes[ mCodItem, 3 ] == 10
      CorAntiga := CorMenus
    case mOpcoes[ mCodItem, 3 ] == 11
      CorAntiga := CorAltKm
    case mOpcoes[ mCodItem, 3 ] == 12
      CorAntiga := CorOpcao
    case mOpcoes[ mCodItem, 3 ] == 13
      CorAntiga := CorAltKo
    case mOpcoes[ mCodItem, 3 ] == 14
      CorAntiga := CorJanel
    case mOpcoes[ mCodItem, 3 ] == 15
      CorAntiga := CorCampo
    case mOpcoes[ mCodItem, 3 ] == 16
      CorAntiga := CorBorja
  endcase
  
  for o := 1 to len( CorAntiga )
    cL := substr( CorAntiga, o, 1 )
    
    if cL == '/'  
      cLetra := left( CorAntiga, o - 1 )
      cFundo := alltrim( substr ( CorAntiga, o + 1  ) )
      exit
    endif
  next               
  
  for j := 1 to 8
    for i := 1 to 16
      nIndice := i + ( j*16-16 )
      aCor [nIndice] := aVet [i] + '/' + aVet [j]
    next
  next

  Janela ( 08, 31, 20, 57, mensagem( 'Janela', 'Cores', .f. ), .f. )
  Mensagem( ' <ESC>,  <ENTER>, ' + chr(26) + '  ' + chr(24) + '  ' + chr(25) + '  ' + chr(27) )

  setcolor ( CorJanel )
  @ 10,37 say 'L'
  @ 11,35 say 'F'

  for j := 1 to 8
    cCors := 'n/'+aVet [j]
    
    if aVet [j] == cFundo
      nFundo := j
    endif     

    setcolor ( cCors )
    @ 11+j,35 say space(1)
  next

  nFlag     := 0
  cCorJanTr := space(0)

  for i := 1 to len( CorJanel )
    cSemCor := substr( CorJanel, i, 1 )
    if cSemCor == '/'
      nFlag := 1
    endif
    if nFlag == 1 .and. cSemCor # '/'
      cCorJanTr := cCorJanTr + cSemCor
    endif
  next

  setcolor ( CorJanel )
  for i := 1 to 16
    cCors := aVet [i] + '/' + cCorJanTr

    if aVet [i] == cLetra
      nLetra := i
    endif     

    setcolor ( cCors )
    @ 10,37+i say chr(219)
  next

  cCorJanTr   := cCorJanTr + '/' + cCorJanTr

  nCh := nAch := 37 + nLetra 
  nLv := nAlv := 11 + nFundo
  
  do while .t.
    nOpCorH := nCh-37
    nOpCorV := nLv-11

    setcolor ( CorJanel )
    @  11,nCh say chr(24)
    @  nLv,36 say chr(27)
    
    Tlaux()

    cTecla := Teclar(0)

    do case
      case cTecla == K_UP
        nLv --
        if nLv == 11
          nLv := 19
        endif
      case cTecla == K_DOWN
        nLv ++
        if nLv == 20
          nLv := 12
        endif
      case cTecla == K_RIGHT
        nCh ++
        if nCh == 54
          nCh := 38
        endif
      case cTecla == K_LEFT
        nCh --
        if nCh == 37
          nCh := 53
        endif
      case cTecla == K_ESC
        NovaCor := corantiga
        exit
      case cTecla == K_ENTER
        NovaCor := cCors
        exit
      case cTecla == K_F1
        Ajuda ()
    endcase

    setcolor ( cCorJanTr )
    @ 11,nAch say chr(24)
    @ nAlv,36 say chr(27)

    nAch := nCh
    nAlv := nLv
  enddo
  
  do case 
    case mOpcoes[ mCodItem, 3 ] == 08
      CorFundo := NovaCor
    case mOpcoes[ mCodItem, 3 ] == 09
      CorCabec := NovaCor 
    case mOpcoes[ mCodItem, 3 ] == 10
      CorMenus := NovaCor
    case mOpcoes[ mCodItem, 3 ] == 11
      CorAltKm := NovaCor  
    case mOpcoes[ mCodItem, 3 ] == 12
      CorOpcao := NovaCor
    case mOpcoes[ mCodItem, 3 ] == 13
      CorAltKo := NovaCor
    case mOpcoes[ mCodItem, 3 ] == 14
      CorJanel := NovaCor
    case mOpcoes[ mCodItem, 3 ] == 15
      CorCampo := NovaCor
    case mOpcoes[ mCodItem, 3 ] == 16
      CorBorja := NovaCor
  endcase

  select ParaARQ
  set order to 1
  dbseek( cUsuario, .f. )
  if eof() 
    dbgotop()

    cVersao := Versao
    cScreen := Screen
    nLinha  := Linha
    nColuna := Coluna
      
    if AdiReg ()
      if RegLock()
        replace Usua       with cUsuario
        replace Versao     with cVersao
        replace Screen     with cScreen
        replace Linha      with nLinha
        replace Coluna     with nColuna
        dbunlock ()
      endif  
    endif
  endif
  
  if RegLock()
    replace rFundo  with CorFundo
    replace rCabec  with CorCabec
    replace rMenus  with CorMenus
    replace rOpcao  with CorOpcao
    replace rJanel  with CorJanel
    replace rCampo  with CorCampo
    replace rBorja  with CorBorja
    replace rAltKo  with CorAltKo
    replace rAltKm  with CorAltKm
    replace rAcess  with CorAcess

    for n := 1 to len( CorAltKm )
      if substr( CorAltKm, n, 1 ) == '/'
        cCorIni := substr( CorAltKm, 1, n - 1 )
        for i := len( CorCampo ) to 1 step - 1
          if substr( CorCampo, i, 1 ) == '/'
            cCorFin  := substr( CorCampo, i )
            CorAltKc := cCorIni + cCorFin
          endif
        next  
      endif  
    next    

    replace rAltKc  with  CorAltkc
    dbunlock ()
  endif
              
  select MenuARQ

  aOpcoes := {}

  CarMenu ()
  DispMenu()
  LumiMenu()
 
  restscreen( 00, 00, 24, 79, tSemCor )
return NIL

function Tlaux ()
  nIndice := nOpCorH + ( nOpCorV * 16 - 16 )
  cCors  := alltrim  ( aCor [nIndice] )
  
  setcolor ( cCors )
  @ 12,38 to 19,53
  @ 13,39 say '   Este é um  '
  @ 14,39 say '  exemplo de  '
  @ 15,39 say '  Texto para  '
  @ 16,39 say '  ajudá-lo a  '
  @ 17,39 say '  definir as  '
  @ 18,39 say '  cores.      '

  do case
    case mOpcoes[ mCodItem, 3 ] == 08
      @ 01, 00 clear to 07, 35
      @ 07, 00 clear to 22, 30
      @ 22, 00 clear to 22, 80
      @ 21, 31 clear to 21, 32
      @ 21, 60 clear to 21, 80
      @ 01, 79 clear to 21, 80
      @ 01, 64 clear to 01, 80
      @ 01, 66 clear to 06, 80
      @ 02, 79 clear to 06, 80
      @ 07, 77 clear to 07, 78
      @ 24, 00 clear to 24, 80
      @ 24, 01 say 'Tecle: <ESC>,  <ENTER>  ou  ' + chr(26) + '  ' + chr(24) + '  ' + chr(25) + '  ' + chr(27) 
    case mOpcoes[ mCodItem, 3 ] == 09
      @ 08, 31 say space(27)
      @ 08, 32 say 'Cores'
    case mOpcoes[ mCodItem, 3 ] == 10
      @ 00,00 say space(80)
      
      setcolor( CorOpcao )
      @ 00,36 say ' Utilitários '

      setcolor( cCors )
      @ 00,00 say ' - ' 
      @ 00,03 say ' Arquivos '
      @ 00,13 say ' Relatórios '
      @ 00,25 say ' Processos '
      @ 00,49 say ' Ajuda '

      @ 23,00 say space(80)
      @ 23,01 say EmprClip
      @ 23,41 say chr( 179 ) + time () + chr( 179 ) + dtoc( date() ) + chr( 179 )
    case mOpcoes[ mCodItem, 3 ] == 11
      @ 00,04 say 'A'
      @ 00,14 say 'R'
      @ 00,26 say 'P'
      @ 02,38 say 'R'
      @ 03,38 say 'S'
      @ 07,38 say 'C'
    case mOpcoes[ mCodItem, 3 ] == 12
      @ 00,36 say ' Utilitários '
      @ 07,37 say ' Cores      '
      @ 12,60 say '                ' 
    case mOpcoes[ mCodItem, 3 ] == 13
      @ 00,37 say 'U'
      @ 07,38 say 'C'
    case mOpcoes[ mCodItem, 3 ] == 14
      tOpc     := savescreen( 00, 00, 23, 79 )
      cOld     := CorJanel
      CorJanel := cCors
      
      Janela( 02, 02, 06, 32, 'LEVE', .f. )
      setcolor ( CorJanel )
      @ 04,05 say 'Codigo'
      @ 05,05 say '  Nome'

      setcolor ( CorCampo )
      @ 04,12 say '001'
      @ 05,12 say 'NONO NONO NONO' 

      CorJanel := cOld
    case mOpcoes[ mCodItem, 3 ] == 15
      tOpc     := savescreen( 00, 00, 23, 79 )
      cOld     := CorCampo
      CorCampo := cCors
      
      Janela( 02, 02, 06, 32, 'LEVE', .f. )
      setcolor ( CorJanel )
      @ 04,05 say 'Codigo'
      @ 05,05 say '  Nome'

      setcolor ( CorCampo )
      @ 04,12 say '001'
      @ 05,12 say 'NONO NONO NONO' 

      CorCampo := cOld
    case mOpcoes[ mCodItem, 3 ] == 16
      tOpc     := savescreen( 00, 00, 23, 79 )
      cOld     := CorBorja
      CorBorja := cCors
      
      Janela( 02, 02, 06, 32, 'LEVE', .f. )
      setcolor ( CorJanel )
      @ 04,05 say 'Codigo'
      @ 05,05 say '  Nome'

      setcolor ( CorCampo )
      @ 04,12 say '001'
      @ 05,12 say 'NONO NONO NONO' 

      CorBorja := cOld
  endcase    
  
  setcolor ( cCorJanTr + ',' + CorJanel )
return NIL

// 
// Mostra sobre os sistemas
// 
function Sobre()
  local tSobre := savescreen ( 00, 00, 24, 79 )
  
  setcolor ( CorMenus )
  Janela ( 03, 04, 19, 74, mensagem( 'Janela', 'Sobre', .f. ), .f. ) 
  @ 03,04 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
  @ 04,04 say '³                                       Vendas - Estoque - Compras    ³'
  @ 05,04 say '³                                       Caixa - Ponto                 ³'
  @ 06,04 say '³                                       LEVE versão '  + cVersao + '             ³'
  @ 07,04 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
  @ 08,04 say '³ Este software está aberto a participação, sugestões e melhoramentos ³'
  @ 09,04 say '³ são sempre bem-vindos. É proibida  a  reprodução deste software sem ³'
  @ 10,04 say '³ autorização do autor, o infrator estará sujeito ao código penal.    ³'
  @ 11,04 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
  @ 12,04 say '³ Este produto está licenciado para:                                  ³'
  @ 13,04 say '³                                                                     ³'
  @ 13,06 say EmprARQ->Razao
  @ 14,04 say '³                                                                     ³'
  @ 14,06 say alltrim(EmprARQ->Ende)+' '+alltrim(EmprARQ->Cida)
  @ 15,04 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
  @ 16,04 say '³ Fabiano Biatheski                                      48 9904 5857 ³'
  @ 17,04 say '³ Rua João Pessoa, 710 - 107                                          ³'
  @ 18,04 say '³ 88801-530 - Criciúma - S.C.                     biatheski@gmail.com ³'
  @ 19,04 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
  
  EntrTela()
  restscreen ( 00, 00, 24, 79, tSobre )
return NIL

//
// Efeito de Tela diferente - Movimento
//
function EntrTela()

  local Sistema := {}
  local nTime, nV, nLen, nLenStr, nDir, nJ, nI, nH, nLinIni, nColIni, nLinFin, nColFin 

  aadd( Sistema, " Û    Ûßßß Û   Û Ûßßß " )
  aadd( Sistema, " Û    Ûßß   Û Û  Ûßß  " )
  aadd( Sistema, " ßßßß ßßßß   ß   ßßßß " )

  do while lastkey() <> K_ESC
    nTempo  := .1
    nV      := 1
    nLen    := len( Sistema )
    nLenStr := len( Sistema[1] )
    nDir    := .t.
    nJ      := nLenStr
    nI      := 1
    nH      := 1
    nLinIni := 3
    nColIni := 7
    nLinFin := 6
    nColFin := ( nColIni + nLenStr )
    MoviEntr( nLinIni, nColIni, nLinFin, nColFin, nJ, nH, nI, nLen, nTempo, nLenStr, Sistema )
    
    if lastkey() == K_F1
      tAjud := savescreen( 00, 00, 23, 79 )
      Janela( 03, 10, 08, 64, 'LEVE ' + cVersao, .f., .f. )
      setcolor( CorJanel )

      @ 05,12 say 'Para descobrir o autor do sistema, você deverá te-'
      @ 06,12 say 'clar CTRL+B, quando a palavra LEVE parar de se mo-'
      @ 07,12 say 'vimentar, após tecle HOME e END.' 

      Teclar(0)
      restscreen( 00, 00, 23, 79, tAjud )
    endif
    
    if lastkey() == K_CTRL_B
      cTecla := inkey(0)
      if cTecla == K_HOME
        cTecla := inkey(0)
        if cTecla == K_END  
          tBinho := savescreen( 00, 00, 23, 79 )
           
          setcolor ( CorJanel )
          @ 06,10 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
          @ 07,10 say '³                                                      ³'
          @ 08,10 say '³          Autor do Sistema Integrado LEVE ' + cVersao + '       ³'
          @ 09,10 say '³                                                      ³'
          @ 10,10 say '³ -o)              Fabiano Biatheski                   ³'
          @ 11,10 say '³  /\\                 Binho Sam                       ³'
          @ 12,10 say '³ _\_V            Linux User #152405                   ³'
          @ 13,10 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
 
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
      endif    
    endif 
  enddo  
return NIL

//
// Movimenta a tela com um Efeito diferente
//
function MoviEntr( nLinIni, nColIni, nLinFin, nColFin, nJ, nH, nI, nLen, nTime, nLenStr, Sistema ) 
  setcolor( CorMenus )
  @ nLinIni + 1, ( nColIni + 1 ) clear to nLinFin, ( nColFin + 2 )
  @ nLinIni + 1, ( nColIni - 1 ) clear to nLinFin, ( nColFin + 1 )
 
  do while nJ > 0 .and. nH <= nLenStr
    for nI := 1 to nLen step 2
      @ nLinIni + nI, nColIni say substr( Sistema[ nI ], nJ )
    next
    for nI := 2 to nLen step 2
      @ nLinIni + nI, nColFin - nH say substr( Sistema[ nI ], 1, nH )
    next
    nJ --
    nH ++
    inkey( nTime ) 
  enddo
  inkey( 2 )
return NIL

// 
// Verifica o Indice 
// 
function VerifInd( cFile )
  local cArquIND := alias()
  
  select IndeARQ
  set order to 1  
  dbseek( upper( cFile ), .f. )
    
  if left( Arqu, len( cFile ) ) == upper( cFile ) .and. !eof()
    tIndice := savescreen( 00, 00, 23, 79 )
    
    do while left( Arqu, len( cFile ) ) == upper( cFile ) .and. !eof()
      if Para
        Janela ( 09, 17, 15, 65, mensagem( 'Janela', 'VerifInd', .f. ), .f., .t. )
      else
        Janela ( 09, 17, 15, 65, mensagem( 'Janela', 'VerifInd', .f. ), .f. )
      endif
      setcolor ( CorJanel )
      @ 11,19 say "Arquivo de Dados"
      @ 12,19 say " Chave de Acesso"
      @ 13,19 say "   Indice Criado"
      @ 14,19 say "       Diretório"

      setcolor( CorCampo )
      @ 11,36 say space(12)
      @ 12,36 say space(25)
      @ 13,36 say space(12)
      @ 14,36 say space(28)
     
      if Para
        cDir := cCaminho
      else
        cDir := dirname()
      endif

      @ 11,36 say alltrim( Arqu ) + ".DBF"
      @ 12,36 say left( Chav, 25 )
      @ 14,36 say left( cDir, 28 )

      #ifdef DBF_NTX
        if Para
          cInde := cCaminho + HB_OSpathseparator() + alltrim( Inde ) + ".NTX"
        else
          cInde := dirname() + HB_OSpathseparator() + alltrim( Inde ) + ".NTX"
        endif

        @ 13,36 say cInde
      
        if !file( cInde )
          cChav := alltrim( Chav )
  
          select( cArquIND )

          index on &cChav to &cInde
        endif
      #endif

      #ifdef DBF_CDX
        if Para
          cInde := cCaminho + HB_OSpathseparator() + alltrim( Arqu ) + ".CDX"
        else
          cInde := dirname() + HB_OSpathseparator() + alltrim( Arqu ) + ".CDX"
        endif

        if !file( cInde )
          do while left( Arqu, len( cFile ) ) == upper( cFile ) .and. !eof()
            cIndeARQ := alltrim( Inde )
            cChav    := alltrim( Chav )
  
            @ 13,36 say cIndeARQ
        
            select( cArquIND )

            index on &cChav tag &cIndeARQ

            select IndeARQ
            dbskip()
          enddo
        endif
      #endif
      
      select IndeARQ
      dbskip()
    enddo  
    
    restscreen( 00, 00, 23, 79, tIndice )
  else
    Alerta( mensagem( "Alerta", "VerifInd", .f. ) + " " + cFile )  
  endif
    
  select( cArquIND )
return(.t.)

//
// Constroi uma janela com Confirmacao em local pre-definido                
//
function ConfLinha ( nLin, nCol, nOpcao )

  local fOpcao := {}

  for i := 1 to len( CorJanel ) 
    cFundo := substr( CorJanel, i, 1 )
    if cFundo == '/'  
      cJanelFundo := 'n' + substr ( CorJanel, i  )
      exit
    endif
  next           
  
  setcolor ( cJanelFundo )
  @ nLin     , 39 say 'Ü'
  @ nLin     , 46 say 'Ü'
  @ nLin + 01, 35 say 'ßßßßß'
  @ nLin + 01, 42 say 'ßßßßß'
  
  aadd( fOpcao, { ' Sim ', nLin, nCol     } )
  aadd( fOpcao, { ' Não ', nLin, nCol + 7 } )

  nMaxItem  := len( fOpcao )
  nItem     := nOpcao
  
  do while .t.
    for nWW := 1 to len( fOpcao )
      setcolor ( CorCampo )
      @ fOpcao[ nWW, 2 ], fOpcao[ nWW, 3 ] say fOpcao[ nWW, 1 ]

      setcolor ( CorAltKC )
      @ fOpcao[ nWW, 2 ], fOpcao[ nWW, 3 ] + 1 say substr( fOpcao[ nWW, 1 ], 2, 1 )
    next
    
    setcolor( CorOpcao )
    @ fOpcao[ nItem, 2 ], fOpcao[ nItem, 3 ] say fOpcao[ nItem, 1 ]
  
    setcolor( CorAltKO )
    @ fOpcao[ nItem, 2 ], fOpcao[ nItem, 3 ] + 1 say substr( fOpcao[ nItem, 1 ], 2, 1 )
        
    cTecla := Teclar(0)
    
    do case
      case cTecla == K_LEFT
        nItem --
      case cTecla == K_RIGHT
        nItem ++  
      case cTecla == K_ESC
        return(.f.)  
      case cTecla == K_ENTER 
        if nItem == 1
          setcolor( CorOpcao ) 
          @ fOpcao[ nItem, 2 ], fOpcao[ nItem, 3 ] + 1 say fOpcao[ nItem, 1 ]
  
          setcolor( CorAltKO )
          @ fOpcao[ nItem, 2 ], fOpcao[ nItem, 3 ] + 2 say substr( fOpcao[ nItem, 1 ], 2, 1 )

          setcolor ( CorJanel )
          @ nLin    , 34 say ' '
          @ nLin + 1, 35 say '     '
          inkey(.3)
          return(.t.)
        else
          setcolor( CorOpcao ) 
          @ fOpcao[ nItem, 2 ], fOpcao[ nItem, 3 ] + 1 say fOpcao[ nItem, 1 ]
  
          setcolor( CorAltKO )
          @ fOpcao[ nItem, 2 ], fOpcao[ nItem, 3 ] + 2 say substr( fOpcao[ nItem, 1 ], 2, 1 )

          setcolor ( CorJanel )
          @ nLin    , 41 say ' '
          @ nLin + 1, 42 say '     '
          inkey(.3)
          return(.f.)
        endif    
      case upper( chr( cTecla ) ) == 'S'
        setcolor( CorOpcao ) 
        @ fOpcao[ 1, 2 ], fOpcao[ 1, 3 ] + 1 say fOpcao[ 1, 1 ]
  
        setcolor( CorAltKO )
        @ fOpcao[ 1, 2 ], fOpcao[ 1, 3 ] + 2 say substr( fOpcao[ 1, 1 ], 2, 1 )

        setcolor ( CorJanel )
        @ nLin    , 34 say ' '
        @ nLin + 1, 35 say '     '
        inkey(.3)
        return(.t.)
      case upper( chr( cTecla ) ) == 'N'
        setcolor( CorOpcao ) 
        @ fOpcao[ 2, 2 ], fOpcao[ 2, 3 ] + 1 say fOpcao[ 2, 1 ]
  
        setcolor( CorAltKO )
        @ fOpcao[ 2, 2 ], fOpcao[ 2, 3 ] + 2 say substr( fOpcao[ 2, 1 ], 2, 1 )

        setcolor ( CorJanel )
        @ nLin    , 41 say ' '
        @ nLin + 1, 42 say '     '
        inkey(.3)
        return(.f.)
    endcase    
  
    nItem  := iif(nItem > nMaxItem, 1, nItem )
    nItem  := iif(nItem < 1, nMaxItem, nItem )
  
    clear typeahead
  enddo
return(.f.)
       
       
//
// Constroi uma janela com Confirmacao em local pre-definido                
//
function ConfLine ( nLinha, nColuna, cOpcao )
  local opConf  := cOpcao
  local aOpcoes := {} 
  local tLinha  := savescreen( 24, 01, 24, 79 )
  
  aadd( aOpcoes, { ' Sim ',  2, 'S', nLinha, nColuna    , "" } )
  aadd( aOpcoes, { ' Não ',  2, 'N', nLinha, nColuna + 6, "" } )
  
  OpConf := HCHOICE( aOpcoes, 2, opConf )

  if OpConf == 0 .or. OpConf == 2
    lOk := .f.
  else
    lOk := .t.
  endif
  restscreen( 24, 01, 24, 79, tLinha )
return ( lOk )

//
// Constroi uma janela com Confirmacao em local pre-definido                
//
function ConfAlte ()

  local tLinha := savescreen( 24, 01, 24, 79 )
  local tConf  := savescreen( 00, 00, 23, 79 )

  Janela ( 06, 31, 10, 49, mensagem( 'Janela', 'ConfAlte', .f. ), .f. )

  lOk := ConfLinha( 08, 34, 1 )

  restscreen( 00, 00, 23, 79, tConf )
  restscreen( 24, 01, 24, 79, tLinha )
return ( lOk )

// 
// Linha de Confirmacao Geral                                               
// 
function ConfGeral ( nLinha, cOImpr, cOExcl, cOGera, cOConf, cOCanc, cOpcao, cAltKey, nPosKey, nOpc )
  local nOpConf := nOpc
  local aOpcoes := {}
  local tLinha  := savescreen( 24, 01, 24, 79 )
  
  if lastkey() == K_ESC
    cStat := 'loop'
    return NIL
  endif
    
  aadd( aOpcoes, { ' Imprimir ',       2,     'I', nLinha, cOImpr, "Relatório do arquivo" } )
  aadd( aOpcoes, { ' Excluir ' ,       6,     'U', nLinha, cOExcl, "Excluir registro" } )
  aadd( aOpcoes, { cOpcao,       nPosKey, cAltKey, nLinha, cOGera,  alltrim( cOpcao ) + " do arquivo" } )
  aadd( aOpcoes, { ' Confirmar ',      2,     'C', nLinha, cOConf, "Confirmar inclusão ou alteração" } )
  aadd( aOpcoes, { ' Cancelar ',       3,     'A', nLinha, cOCanc, "Cancelar alterações" } )
    
  nOpConf := HCHOICE( aOpcoes, 5, nOpConf, .t. )
    
  do case
    case nOpConf == 0 .or. nOpConf == 5
      cStat := 'loop'
    case nOpConf == 1
      cStat := 'prin'
    case nOpConf == 2
      cStat := 'excl'
    case nOpConf == 3
      cStat := 'gene'
  endcase
  restscreen( 24, 01, 24, 79, tLinha )
return NIL

// 
// Verifica se existe o registro no Arquivo                                 
// 
function ValidARQ ( nXLinha, nXColuna, cXFile, cXTit1, cXCampo1, cXTit2, cXCampo2, cXProg, cXVar, lXNume, nXNume, cXTit3, cXFile1, nXTotCar, lXLast, nXOrder )
 
  local cTecla
  local GetList := {}
  
  if lastkey() == K_UP .or. lastkey() == K_DOWN
    return(.t.)
  endif  
  
  tValARQ    := savescreen( 00, 00, 24, 79 )
  lOk        := .f.
  cStatAnt   := cStat
    
  setcolor ( CorCampo )
  select( cXFile1 )
  set order to 1
  if lXNume
    dbseek( strzero( &cXVar, nXNume ), .f. )
  else
    if alltrim( &cXVar ) == '.'
      keyboard( chr(27)+chr(46) )
 
      if !empty( cXfile )
        select( cXFile )
      endif
      return(.f.)
    endif
    
    if !empty( lXLast )
      dbseek( strzero( val( &cXVar ), nXNume ), .f. )
    else  
      dbseek( &cXVar, .f. )
    endif
  endif

  nXTama := len( &( cXCampo1 )  )
  
  if eof()
    if nXOrder == NIL
      set order to 2
    else
      set order to nXOrder
    endif    

    Janela( 05, 15, 17, 63, cXTit3, .f. )

    setcolor( CorJanel + ',' + CorCampo )
    oBrowse           := TBrowseDB( 07, 16, 15, 62 )
    oBrowse:headsep   := chr(194)+chr(196)
    oBrowse:colsep    := chr(179)
    oBrowse:footsep   := chr(193)+chr(196)
    oBrowse:colorSpec := CorJanel + ',' + CorCampo

    oBrowse:addColumn( TBColumnNew( cXTit1, {|| &cXCampo1 } ) )
    oBrowse:addColumn( TBColumnNew( cXTit2, {|| left( &( cXCampo2 ), nXTotCar ) } ) )
  
    oBrowse:goTop ()

    oBrowse:colpos := 2
    lExitRequested := .f.
    nLinBarra      := 1
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
      Mensagem( 'LEVE', 'ValidARQ' ) 

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
        case cTecla == K_ESC;        lExitRequested := .t.
        case cTecla == K_ENTER
          lOk            := .t.
          lExitRequested := .t.
        case cTecla == K_BS
          cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
      
          setcolor ( CorCampo )
          @ 16,26 say space(32)
          @ 16,26 say cLetra
        case cTecla >= 32 .and. cTecla <= 128
          cLetra += chr( cTecla )    

          if len( cLetra ) >= 32
            cLetra := ''
          endif  
       
          setcolor ( CorCampo )
          @ 16,26 say space(32)
          @ 16,26 say cLetra

          dbseek( cLetra, .t. )
          oBrowse:refreshAll()
        case cTecla == K_ALT_A
          tAltARQ   := savescreen( 00, 00, 24, 79 )
          cLetra    := ''
            
          &cXProg(.t.)

          restscreen( 00, 00, 24, 79, tAltARQ )

          select ( cXFile1 )
          set order to 2
          dbseek( &cXFile1->&cXCampo2, .f. )

          oBrowse:refreshAll()  

          setcolor ( CorCampo )
          @ 16,26 say space(32)
        case cTecla == K_INS
          tAltARQ   := savescreen( 00, 00, 24, 79 )
          cLetra    := ''
            
          &cXProg(.f.)

          restscreen( 00, 00, 24, 79, tAltARQ )

          select ( cXFile1 )
          set order to 2
          dbseek( &cXFile1->&cXCampo2, .f. )

          oBrowse:refreshAll()  

          setcolor ( CorCampo )
          @ 16,26 say space(32)
      endcase
    enddo
  else
    lOk := .t.
  endif
  
  restscreen( 00, 00, 24, 79, tValARQ )
  if lOk
    setcolor( CorCampo) 
    lExitRequested := .f.
  
    if lXNume
      &cXVar := val ( &cXCampo1 )
    else
      &cXVar := &cXCampo1
    endif
    
    if nXLinha != 99
      if !lXNume
        @ nXLinha, nXColuna say left( &cXVar, nXTotCar )  
      else
        @ nXLinha, nXColuna say &cXVar  
      endif     
    endif
    
    if nXTotCar != 0
      @ nXLinha, nXColuna+(nXTama+1) say left( &( cXCampo2 ), nXTotCar )
    endif
  endif

  cStat := cStatAnt

  select( cXFile1 )
  set order to 1

  if !empty( cXfile )
    select ( cXFile )
  endif
  setcolor ( CorJanel + ',' + CorCampo )
return(lOk)

function VoltaPrint ()
  if lastkey() == K_UP
    keyboard( chr( K_PGDN ) )
  endif
return(.t.)

//
// Seleciona um Menu de Impressão                                          
//
function Imprimir( xArqu3, xTama )

  if lastkey () == K_ESC .or. len( directory( cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() + alltrim( xArqu3 ) + ".*" ) ) == 0
    return(.f.)
  endif    

  tTela    := savescreen( 00, 00, 23, 79 )
  nPagiIni := 1
  mArqu    := directory( cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() +  alltrim( xArqu3 ) + ".*" )
  nPagiFin := len( mArqu )
  lOk      := .f.

  Janela( 07, 12, 14, 64, mensagem( "Janela", "Imprimir", .f. ), .f. )
  Mensagem( 'LEVE', 'Print' )

  setcolor( Corjanel )
  @ 09,15 say "Relatório em ..."
  @ 10,15 say "  P gina Inicial"
  @ 11,15 say "    P gina Final"
  @ 12,15 say "Número de cópias"
  @ 13,15 say "        Confirma"

  setcolor( CorCampo + "," + CorOpcao )
  @ 10,32 say nPagiIni                pict '999'
  @ 11,32 say nPagiFin                pict '999'
  @ 12,32 say "0001"
  @ 13,32 say " Sim "
  @ 13,38 say " Não "

  setcolor( CorAltKc )
  @ 13,33 say "S"
  @ 13,39 say "N"
    
  aOpcoes := {}
  tRelat  := savescreen( 00, 00, 23, 79 )

  aadd( aOpcoes, {" Video ",      2, "V", 9, 32, "Configura Relatório para Video, Tecle <ESC> para retornar."})
  aadd( aOpcoes, {" Impressora ", 2, "I", 9, 40, "Configura Relatório para Impressora, Tecle <ESC> para retornar."})
  aadd( aOpcoes, {" Arquivo ",    2, "A", 9, 53, "Configura Relatório para Arquivo, Tecle <ESC> para retornar."})
    
  do while .t.
    restscreen( 00, 00, 23, 79, tRelat )

    nCopia := 1
    nOpprt := HChoice( aOpcoes, 3, 1 )

    if lastkey() == K_ESC
      exit
    endif

    do case
      case nOpprt == 0
        exit
      case nOpprt == 3
        setcolor( CorJanel + ',' + CorCampo )
        @ 10,32 get nPagiIni   pict '999'   valid nPagiIni > 0  .and. VoltaPrint ()
        @ 11,32 get nPagiFin   pict '999'   valid nPagiFin >= nPagiIni
        read

        if lastkey() == K_ESC
          exit
        endif  

        Janela( 05, 16, 10, 54, mensagem( "Janela", "Imprimir2", .f. ), .f. )
        Mensagem( 'LEVE', 'Salvar' )

        cTXT    := 'X'
        cHTM    := ' '
        cXML    := ' '
        cPDF    := ' '

        cArqTxt := cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() +  alltrim( xArqu3 ) + ".txt" + space(40)

        keyboard( chr( K_END ) )

        setcolor ( CorJanel + ',' + CorCampo )
        @ 07,18 say '[ ] TXT  [ ] HTML  [ ] XML  [ ] PDF'

        @ 07,19 get cTXT              pict '@!'  valid TipoTxt()
        @ 07,28 get cHTM              pict '@!'  valid TipoTxt()
        @ 07,38 get cXML              pict '@!'  valid TipoTxt()
        @ 07,47 get cPDF              pict '@!'  valid TipoTxt()
        @ 09,18 get cArqTxt           pict '@S35'
        read

        if ConfLine( 13, 32, 1 ) .and. len( mArqu ) > 0
          cDestino := alltrim( cArqTxt )

          if cTXT == 'X'
            nh       := fCreate( cDestino )
            cReturn  := ''

            for x := nPagiIni to nPagiFin
              if x > len( mArqu )
                exit
              endif

              cOrigem := cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() + alltrim( mArqu[ x, 1 ] )

              if cOrigem != cDestino
                cReturn += memoread( cOrigem )
              else
                Alerta( mensagem( 'Alerta', 'Imprimir', .f. ) )
              endif
            next

            fWrite(nh,cReturn)
            fclose(cReturn)
          endif

          if cHTM == 'X'
            oHTML      := THTML():New()
            s_cNewLine := HB_OSNewLine()

            for x := nPagiIni to nPagiFin
              if x > len( mArqu )
                exit
              endif

              cOrigem := cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() + alltrim( mArqu[ x, 1 ] )

              if cOrigem != cDestino
                nL := mlcount( memoread( cOrigem ), 136 )

                oHTML:AddHead( memoline( memoread( cOrigem), 136, 1 ) )
//                oHTML:SetTitle( memoline( memoread( cOrigem), 136, 1 ) )
//                oHTML:AddHead( "Sistema Integrado LEVE "  + cVersao )

                for nh := 2 to nL
                  oHTML:AddPara( memoline( memoread( cOrigem), 136, nh ), "LEFT" )
                next

//                oHTML:AddLink( "http://www.bostoncriciuma.net", "Atual Revista Eletronica" )
                oHTML:Generate()

                oHTML:SaveToFile( cDestino )

//                oHTML:ShowResult()

              else
                Alerta( mensagem( 'Alerta', 'Imprimir', .f. ) )
              endif
            next
          endif

          lOk := .t.
        endif
      case nOpprt == 1
        setcolor( CorJanel + ',' + CorCampo )
        @ 10,32 get nPagiIni   pict '999'   valid nPagiIni > 0  .and. VoltaPrint ()
        @ 11,32 get nPagiFin   pict '999'   valid nPagiFin >= nPagiIni
        read

        if lastkey () == K_PGDN
          loop
        endif

        if ConfLine( 13, 32, 1 ) .and. len( mArqu ) > 0
          for x := nPagiIni to nPagiFin
            if x > len( mArqu )
              exit
            endif

            cFile := cCaminho + HB_OSpathseparator() +  "spool" + HB_OSpathseparator() + alltrim( mArqu[ x, 1 ] )
            cTit  := mensagem( "Janela", "Imprimir3", .f. ) + " " + strzero( x, 3 ) + " de " + strzero( nPagiFin, 3 )

            Janela( 01, 01, 21, 78, cTit, .F.)
            cCor := setcolor()

            Mensagem( 'LEVE', 'PrinVideo' )
            
            setcursor(1)
            
            setcolor( CorJanel + ',' + CorCampo )
            cFile := memoedit( memoread( cFile ), 02, 03, 20, 77, .f., "SpoolMemo", xTama, , , 0, 0 )
//            cFile := memoedit( memoread( cFile ), 02, 03, 20, 77, .f., , xTama, , , 1, 0 )

            setcursor(0)
            
            if inkey() == K_ENTER
              loop
            endif  

            setcolor( cCor )
            if lastkey() == K_ESC
              exit
            endif
          next

          lOk := .t.
        endif
      case nOpprt == 2
        if EmprARQ->Impr == " "
          aPrn := GetPrinters()
          nPrn := 1
            
          for j := 1 to len( aPrn )
            if alltrim( aPrn[j] ) == GetDefaultPrinter()
              nPrn := j
              exit
            endif                     
          next

          tPrn := savescreen( 00, 00, 23, 79 )
          
          Janela( 06, 22, 12, 62, mensagem( 'Janela', 'VerPrinter', .f. ), .f. )
          setcolor( CorJanel + ',' + CorCampo )
          
          nPrn := achoice( 08, 23, 11, 61, aPrn, .t.,,nPrn )
          
          restscreen( 00, 00, 23, 79, tPrn )
        else
          if !isprinter() 
            Alerta( mensagem( 'Alerta', 'NoPrinter', .f. ) )
            loop
          endif  
        endif  
       
        if lastkey () == K_ESC
          exit
        endif

        setcolor( CorJanel + ',' + CorCampo )
        @ 10,32 get nPagiIni   pict '999'   valid nPagiIni > 0  .and. VoltaPrint ()
        @ 11,32 get nPagiFin   pict '999'   valid nPagiFin >= nPagiIni
        @ 12,32 get nCopia     pict "9999"  valid nCopia > 0
        read

        if lastkey() == K_CTRL_PGDN
          loop
        endif

        if lastkey () == K_ESC
          exit
        endif

        if ConfLine( 13, 32, 1 )
          Janela( 08, 30, 12, 55, mensagem( "Janela", "Imprimir4", .f. ), .f. )
          Mensagem( 'LEVE', 'Imprimindo' )
          setcolor( CorJanel )
          @ 10,32 say " Cópia      de "
          @ 11,32 say "Pagina      de "
          
          if EmprARQ->Impr == "X"
            set device  to print
            set printer on
          endif  
          
          for y := 1 to nCopia
            set device to screen
            @ 10,39 say strzero( y, 4 )
            @ 10,47 say strzero( nCopia, 4 )
            
            if EmprARQ->Impr == "X"
              set device to print
            endif  

            for x := nPagiIni to nPagiFin
              @ 11,39 say strzero( x, 3 )
              @ 11,47 say strzero( nPagiFin, 3 )
              
              cFile := memoread( cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() + alltrim( mArqu[ x, 1 ] ) )
              
              #ifdef __PLATFORM__Windows
                if EmprARQ->Impr == "X"
                  setprc( 0, 0 )
      
                  @ 00,00 say cfile
           
                  eject
                else
                  PrnTest(aPrn[nPrn], cFile, .t. )
                endif
              #else
                __run( alltrim( EmprARQ->Comando ) + " " + cFile )
              #endif

              if inkey() == K_ESC
                y := 10000
                x := 10000
              endif
            next

            if lastkey() == K_ESC
              y := 10000
              x := 10000
            endif
          next
  
          set printer off
          set printer to
          set device to screen

          lOk := .t.
        else
          lOK := .f.
        endif
    endcase
  enddo
  restscreen( 00, 00, 23, 79, tTela )

  if NetUse( "SpooARQ", .t. )
    if VerifIND( "SpooARQ" )
      
      #ifdef DBF_NTX
        set index to SpoolND1
      #endif
    endif
  endif
return(lOk)

function PrnTest( cPrinter, cFile, lCond ) 
  #ifdef __PLATFORM__Windows
                
  local oPrinter:= TPrint():New(cPrinter), aFonts, x, nColFixed, nColTTF, nColCharSet
  oPrinter:Landscape := .F.
  oPrinter:FormType  := 9 // FORM_A4
  oPrinter:Copies    := 1
  if !oPrinter:Create()
    Alert("Cannot Create Printer")
  else
    if !oPrinter:startDoc('Sistema Integrado LEVE ' + cVersao )
      Alert("StartDoc() failed")
    else
      if lCond
        oPrinter:SetFont('Lucida Console',12,{3,-50})  // Alternative Compressed print
      endif
      oPrinter:NewLine()
                    
      nL := mlcount( cFile, 136 )

      for nh := 1 to nL
        if empty( memoline( cFile, 136, nh ) )
          oPrinter:NewLine()
        else 
          oPrinter:TextOut( memoline( cFile, 136, nh ) )
          oPrinter:NewLine()
        endif  
      next
      oPrinter:CharSet(0)
      oPrinter:Bold(0)
      oPrinter:EndDoc()
    endif
  endif  
  oPrinter:Destroy()

  #endif
return(NIL)

function TipoTxt()

  if cPDF == 'X'
    cTXT    := ' '
    cHTM    := ' '
    cXML    := ' '
    cArqTxt := strtran( cArqTxt, '.txt', '.pdf' )
    cArqTxt := strtran( cArqTxt, '.html', '.pdf' )
    cArqTxt := strtran( cArqTxt, '.xml', '.pdf' )
  endif

  if cXML == 'X'
    cTXT    := ' '
    cHTM    := ' '
    cPDF    := ' '
    cArqTxt := strtran( cArqTxt, '.txt', '.xml' )
    cArqTxt := strtran( cArqTxt, '.html', '.xml' )
    cArqTxt := strtran( cArqTxt, '.pdf', '.xml' )
  endif

  if cHTM == 'X'
    cTXT    := ' '
    cXML    := ' '
    cPDF    := ' '
    cArqTxt := strtran( cArqTxt, '.txt', '.html' )
    cArqTxt := strtran( cArqTxt, '.xml', '.html' )
    cArqTxt := strtran( cArqTxt, '.pdf', '.html' )
  endif

  if cTXT == 'X'
    cHTM    := ' '
    cXML    := ' '
    cPDF    := ' '
    cArqTxt := strtran( cArqTxt, '.html', '.txt' )
    cArqTxt := strtran( cArqTxt, '.xml', '.txt' )
    cArqTxt := strtran( cArqTxt, '.pdf', '.txt' )
  endif

  setcolor( CorCampo )
  @ 09,18 say cArqTxt           pict '@S35'
  setcolor( CorJanel + ',' + CorCampo )
return(.t.)

FUNCTION THTML

   STATIC oClass

   IF oClass == NIL
      oClass = HBClass():New( "THTML" )

      oClass:AddData( "cTitle" )                       // Page Title
      oClass:AddData( "cBody" )                        // HTML Body Handler
      oClass:AddData( "cBGColor" )                     // Background Color
      oClass:AddData( "cLinkColor" )                   // Link Color
      oClass:AddData( "cvLinkColor" )                  // Visited Link Color
      oClass:AddData( "cContent" )                     // Page Content Handler

      oClass:AddMethod( "New",        @New() )         // New Method
      oClass:AddMethod( "SetTitle",   @SetTitle() )    // Set Page Title
      oClass:AddMethod( "AddHead",    @AddHead() )     // Add <H1> Header
      oClass:AddMethod( "AddLink",    @AddLink() )     // Add Hyperlink
      oClass:AddMethod( "AddPara",    @AddPara() )     // Add Paragraph
      oClass:AddMethod( "Generate",   @Generate() )    // Generate HTML
      oClass:AddMethod( "SaveToFile", @SaveToFile() )  // Saves Content to File
      oClass:AddMethod( "ShowResult", @ShowResult() )  // Show Result - SEE Fcn

      oClass:Create()
   ENDIF

   RETURN( oClass:Instance() )

STATIC FUNCTION New()

   LOCAL Self := QSelf()

   ::cTitle      := "Untitled"
   ::cBGColor    := "#FFFFFF"
   ::cLinkColor  := "#0000FF"
   ::cvLinkColor := "#FF0000"
   ::cContent    := ""
   ::cBody       := ""

   RETURN( Self )

STATIC FUNCTION SetTitle( cTitle )

   LOCAL Self := QSelf()

   ::cTitle := cTitle

   RETURN( Self )
STATIC FUNCTION AddLink( cLinkTo, cLinkName )

   LOCAL Self := QSelf()

   ::cBody := ::cBody + ;
      "<A HREF='" + cLinkTo + "'>" + cLinkName + "</A>"

   RETURN( Self )

STATIC FUNCTION AddHead( cDescr )

   LOCAL Self := QSelf()

   // Why this doesn't work?
   // ::cBody += ...
   // ???

   ::cBody := ::cBody + ;
      "<H1>" + cDescr + "</H1>"

   RETURN( NIL )

STATIC FUNCTION AddPara( cPara, cAlign )

   LOCAL Self := QSelf()

   //Default( cAlign, "Left" ) // removed Patrick Mast 2000-06-07
   cAlign:=If(cAlign==NIL,"Left",cAlign) //Added Patrick Mast 2000-06-17

   ::cBody := ::cBody + ;
      "<P ALIGN='" + cAlign + "'>" + s_cNewLine + ;
      cPara + s_cNewLine + ;
      "</P>"

   RETURN( Self )

STATIC FUNCTION Generate()

   LOCAL Self := QSelf()

   ::cContent :=                                                           ;
      "<HTML><HEAD>"                                           + s_cNewLine + ;
      "<TITLE>" + ::cTitle + "</TITLE>"                        + s_cNewLine + ;
      "<BODY link='" + ::cLinkColor + "' " +                               ;
      "vlink='" + ::cvLinkColor + "'>" +                       + s_cNewLine + ;
      ::cBody                                                  + s_cNewLine + ;
      "</BODY></HTML>"

   RETURN( Self )

STATIC FUNCTION ShowResult()

   LOCAL Self := QSelf()

   qqOut(                                                                  ;
      "HTTP/1.0 200 OK"                                        + s_cNewLine + ;
      "CONTENT-TYPE: TEXT/HTML"                      + s_cNewLine + s_cNewLine + ;
      ::cContent )

   RETURN( Self )

STATIC FUNCTION SaveToFile( cFile )

   LOCAL Self  := QSelf()
   LOCAL hFile := fCreate( cFile )

   fWrite( hFile, ::cContent )
   fClose( hFile )

   RETURN( Self )

//
// Mostra a linha da confirmacao geral                                       
//
function MostGeral ( nLin, nOImpr, nOExcl, nOGera, nOConf, nOCanc, cOpcao, cAltKey, nPosKey )

  setcolor ( CorCampo + ',' + CorOpcao )
  @ nLin, nOImpr say ' Imprimir '
  @ nLin, nOExcl say ' Excluir ' 
  @ nLin, nOGera say cOpcao
  @ nLin, nOConf say ' Confirmar '
  @ nLin, nOCanc say ' Cancelar ' 

  setcolor ( CorAltKc )
  @ nLin, nOImpr + 1 say 'I'
  @ nLin, nOExcl + 5 say 'u'
  @ nLin, nOGera + nPosKey - 1 say cAltKey
  @ nLin, nOConf + 1 say 'C'
  @ nLin, nOCanc + 2 say 'a'
  
  setcolor ( CorJanel + ',' + CorCampo )
return NIL

// 
// Mostra a linha da confirmacao                                            
// 
function MostOpcao ( nLin, nOImpr, nOExcl, nOConf, nOCanc )
  setcolor ( CorCampo + ',' + CorOpcao )
  @ nLin, nOImpr say ' Imprimir '
  @ nLin, nOExcl say ' Excluir ' 
  @ nLin, nOConf say ' Confirmar '
  @ nLin, nOCanc say ' Cancelar ' 

  setcolor ( CorAltKc )
  @ nLin, nOImpr + 1 say 'I'
  @ nLin, nOExcl + 5 say 'u'
  @ nLin, nOConf + 1 say 'C'
  @ nLin, nOCanc + 2 say 'a'
  
  setcolor ( CorJanel + ',' + CorCampo )
return NIL

//
// Movimento do registro do banco de dados                                  
//
function MostrARQ ()

  if lastkey() == K_UP
    keyboard chr(27)
    return NIL
  endif
   
  if lastkey() == K_PGUP
    dbskip(-1)
  endif
   
  if lastkey() == K_PGDN
    dbskip ()
    if eof()
      dbskip(-1)
    endif
  endif

  if lastkey() == K_CTRL_PGUP
    dbgotop ()
  endif
   
  if lastkey() == K_CTRL_PGDN
    dbgobottom ()
  endif
     
  &MostTudo()
return NIL

// 
// Verifica se foi digitado corretamente o CGC                              
// 
function ValidCGC( cCGC )
  
  if empty( cCGC )
    return(.t.)
  endif

  declare aDig1[ 12 ], aDig2[ 12 ]  

  for nCont := 1 to 12
    nDig           := iif( nCont < 10, '0' + str( nCont, 1 ), str( nCont, 2 ) )  
    aDig1[ nCont ] := val( substr( cCGC, nCont, 1 ) )
  next
  
  nDf1    := 5 * aDig1[ 01 ] + 4 * aDig1[ 02 ] + 3 * aDig1[ 03 ] + 2 * aDig1[ 04 ] +;
             9 * aDig1[ 05 ] + 8 * aDIg1[ 06 ] + 7 * aDig1[ 07 ] + 6 * aDig1[ 08 ] +;
             5 * aDig1[ 09 ] + 4 * aDig1[ 10 ] + 3 * aDIg1[ 11 ] + 2 * aDig1[ 12 ]

  nDf2    := nDf1 / 11
  nDf3    := int( nDf2 ) * 11
  nResto1 := nDf1 - nDf3

  if nResto1 == 0 .or. nResto1 == 1
    nPriDig := 0
  else
    nPriDig := 11 - nResto1
  endif
  
  for nCont := 1 to 12
    nDig           := iif( nCont < 10, '0' + str( nCont, 1 ), str( nCont, 2 ) )  
    aDig2[ nCont ] := val( substr( cCGC, nCont, 1 ) )
  next
  
  nDf4    := 6 * aDig2[ 01 ] + 5 * aDig2[ 02 ] + 4 * aDig2[ 03 ] + 3 * aDig2[ 04 ] +;
             2 * aDig2[ 05 ] + 9 * aDig2[ 06 ] + 8 * aDig2[ 07 ] + 7 * aDig2[ 08 ] +;
             6 * aDig2[ 09 ] + 5 * aDig2[ 10 ] + 4 * aDig2[ 11 ] + 3 * aDig2[ 12 ] +;
             2 * nPriDig

  nDf5    := nDf4 / 11
  nDf6    := int( nDf5 ) * 11
  nResto2 := nDf4 - nDf6

  if nResto2 == 0 .or. nResto2 == 1
    nSegDig := 0
  else
    nSegDig := 11 - nResto2
  endif

  if nPriDig <> val( substr( cCGC, 13, 1 ) ) .or. nSegDig <> val( substr( cCGC, 14, 1 ) )
    Alerta( mensagem( 'Alerta', 'ValidCNPJ', .f. ) ) 
    return( .f. )
  endif
return( .t. )      

//
// Verifica se existe os estados cadastrados                               
//
function ValidUF ( nLinha, nColuna, cFile )
  local cLetra 
  local GetList := {}
  local nTotal  := 0
  local tTela   := savescreen( 00, 00, 23, 79 )
  local lOk     := .f.
  local uStat   := cStat

  if NetUse( "EstaARQ", .t. )
    VerifIND( "EstaARQ" )

    vOpenEsta := .t.
    
    #ifdef DBF_NTX 
      set index to EstaIND1, EstaIND2
    #endif  
  else  
    vOpenEsta := .f.   
  endif
  
  setcolor ( CorCampo )
  select EstaARQ
  set order to 1
  dbseek( cUF, .f. )
  if eof()
    set order to 2

    Janela( 06, 20, 18, 59, mensagem( 'Janela', 'ValidUF', .f. ), .f. ) 
    setcolor ( CorJanel + ',' + CorCampo )

    oEstados         := TBrowseDb( 08, 21, 16, 58 )
    oEstados:headsep := chr(194)+chr(196)
    oEstados:colsep  := chr(179)
    oEstados:footsep := chr(193)+chr(196)

    oEstados:addColumn( TBColumnNew("UF",   {|| Esta } ) )
    oEstados:addColumn( TBColumnNew("Nome", {|| left( Nome, 25 ) } ) )
    oEstados:addColumn( TBColumnNew("ICMS", {|| transform( ICMS, '@E 99.9' ) } ) )
          
    lExitRequested  := .f.
    nLinBarra       := 1
    cLetra          := ''
    nTotal          := lastrec()
    BarraSeta       := BarraSeta( nLinBarra, 09, 16, 59, nTotal )
    oEstados:colPos := 2
    
    oEstados:goTop()  

    setcolor ( CorCampo )
    @ 17,31 say space(20)
   
    setcolor( CorJanel + ',' + CorCampo )
    @ 09,20 say chr(195)
    @ 16,20 say chr(195)
    @ 17,22 say 'Consulta'

    do while !lExitRequested
      Mensagem( 'LEVE', 'ValidUF' )
      
      oEstados:forcestable()
      
      PosiDBF( 06, 59 )
     
      iif( BarraSeta, BarraSeta( nLinBarra, 09, 16, 59, nTotal ), NIL )

      if oEstados:stable
        if oEstados:hitTop .or. oEstados:hitBottom
          tone( 125, 0 )        
        endif  

        cTecla := Teclar(0)
      endif
 
      do case
        case cTecla == K_DOWN;        oEstados:down()
        case cTecla == K_UP;          oEstados:up()
        case cTecla == K_PGDN;        oEstados:pageDown()
        case cTecla == K_PGUP;        oEstados:pageUp()
        case cTecla == K_CTRL_PGUP;   oEstados:goTop()
        case cTecla == K_CTRL_PGDN;   oEstados:goBottom()
        case cTecla == K_ESC;         lExitRequested := .t.
        case cTecla == K_ALT_A
          tAlte    := savescreen( 00, 00, 23, 79 )

          Esta (.f.)

          restscreen( 00, 00, 23, 79, tAlte )
  
          select EstaARQ
          set order to 2

          oEstados:refreshAll()  
        case cTecla == K_ENTER
          lOk            := .t.
          lExitRequested := .t.
        case cTecla == K_BS
          cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
    
          setcolor ( CorCampo )
          @ 17,31 say space(25)
          @ 17,31 say cLetra
        case cTecla >= 32 .and. cTecla <= 128 
          cLetra += chr( cTecla )    
          if len( cLetra ) > 32
            cLetra := ''
          endif  

          setcolor ( CorCampo )
          @ 17,31 say space(25)
          @ 17,31 say cLetra
          
          set order to 2 
          dbseek( cLetra, .t. )
          oEstados:refreshAll()
      endcase
    enddo
  else
    lOk := .t.
  endif   

  lExitRequested := .f.
  
  restscreen( 00, 00, 23, 79, tTela )
  if lOk
    setcolor( CorCampo )         
    cUF := Esta

    @ nLinha, nColuna say Esta
  endif
  
  cStat := uStat

  select EstaARQ
  if vOpenEsta
    close
  endif
  
  select( cFile )
  setcolor ( CorJanel + ',' + CorCampo )
return(lOk)

//
// Confirma a exclusao de um Registro                                      
//
function ExclRegi ( lModo )

  local tExcl := savescreen( 00, 00, 23, 79 )
  local lOk   := .f.

  lModo := iif( lModo == NIL, .t., .f. )

  Janela ( 06, 31, 10, 49, mensagem( "Janela", "ExclRegi", .f. ), .f. )
  setcolor ( CorCampo + ',' + CorOpcao )
  
  if ConfLinha( 8, 34, 2 )
    if lModo
      if RegLock()
        dbdelete ()
      endif
       
      dbunlock ()  
    endif   
    
    lOk := .t.
  endif  
  
  dbgobottom ()
  restscreen( 00, 00, 23, 79, tExcl )
return(lOk)

// 
// Confirma a exclusao um Registro e retorna o estoque                      
// 
function ExclEstq ()

  local tExcl := savescreen( 00, 00, 23, 79 )
  local lOk   := .f.

  Janela ( 06, 20, 10, 51, mensagem( "Janela", "ExclRegi", .f. ), .f. )
  setcolor ( CorJanel + ',' + CorCampo )
  
  @ 08,22 say 'Retornar Estq.'            
  @ 09,22 say '     Confirmar'

  setcolor ( CorCampo )
  @ 08,37 say ' Sim '
  @ 08,43 say ' Não ' 
  @ 09,37 say ' Sim '
  @ 09,43 say ' Não ' 
  
  setcolor( CorAltKC )
  @ 08,38 say 'S'
  @ 08,44 say 'N'
  @ 09,38 say 'S'
  @ 09,44 say 'N'
     
  lEstq := ConfLine( 8, 37, 1 )
  
  if ConfLine( 9, 37, 2 )
    if RegLock()
      dbdelete ()
      dbunlock ()  
    endif
       
    lOk := .t.
  endif  
  
  dbgobottom ()
  restscreen( 00, 00, 23, 79, tExcl )
return(lOk)

//
// Calculadora - F9                                                         
//
function Calcular ()

  local cArquivo := alias() 
  local cCores   := setcolor()
  
  nLin := ParaARQ->Linha
  nCol := ParaARQ->Coluna
  
  for i = 1 to len( CorJanel ) 
    cFundo := substr( CorJanel, i, 1 )
    if cFundo == '/'  
      CorSombra := 'n' + substr ( CorJanel, i  )
      CorPisca  := substr( CorJanel, i + 1 ) + substr( CorJanel, i )
      exit
    endif
  next               
  Mensagem ( 'Libi', 'Calcular' )
  
  tCalc    := savescreen( 00, 00, 23, 79 )
  TelaCalc := savescreen( nLin, nCol-1, nLin+17, nCol+34 ) 

  AndaCalc ( nLin, nCol )

  TelaCal2 := savescreen( nLin, nCol-1, nLin+16, nCol+32 ) 
  nValCalc := nValCalc2 := nValCalc3 := nValCalc4 := 0
  nContDec := nMemCalc  := 0
  lDecOk   := .f.
  cOpera   := space(1)

  do while .t.
    nTecla := Teclar(0)

    do case
      case nTecla == K_ESC 
        exit
      case nTecla == K_UP
        if nLin >= 2
          ValoAnte := savescreen ( nLin+3, nCol+3, nLin+4, nCol+27 )
          restscreen( nLin, nCol-1, nLin+17, nCol+34, TelaCalc )
          nLin := nLin - 1  
          TelaCalc := savescreen( nLin, nCol-1, nLin+17, nCol+34 ) 
          restscreen ( nLin, nCol-1, nLin+16, nCol+32, TelaCal2 ) 
          TelaCal2 := savescreen( nLin, nCol-1, nLin+16, nCol+32 ) 
          restscreen ( nLin+3, nCol+3, nLin+4, nCol+27, ValoAnte )
          Sombra     ( nLin, nCol-1, nLin+16, nCol+32 )
        endif  
        loop
      case nTecla == K_DOWN
        if nLin + 16 <= 20
          ValoAnte := savescreen ( nLin+3, nCol+3, nLin+4, nCol+27 )
          restscreen( nLin, nCol-1, nLin+17, nCol+34, TelaCalc )
          nLin := nLin + 1   
          TelaCalc := savescreen( nLin, nCol-1, nLin+17, nCol+34 ) 
          restscreen ( nLin, nCol-1, nLin+16, nCol+32, TelaCal2 ) 
          TelaCal2 := savescreen( nLin, nCol-1, nLin+16, nCol+32 ) 
          restscreen ( nLin+3, nCol+3, nLin+4, nCol+27, ValoAnte )
          Sombra     ( nLin, nCol-1, nLin+16, nCol+32 )
        endif   
        loop
      case nTecla == K_LEFT
        if nCol-1 >= 1
          ValoAnte := savescreen ( nLin+3, nCol+3, nLin+4, nCol+27 )
          restscreen( nLin, nCol-1, nLin+17, nCol+34, TelaCalc )
          nCol := nCol - 2  
          TelaCalc := savescreen( nLin, nCol-1, nLin+17, nCol+34 ) 
          restscreen ( nLin, nCol-1, nLin+16, nCol+32, TelaCal2 ) 
          TelaCal2 := savescreen( nLin, nCol-1, nLin+16, nCol+32 ) 
          restscreen ( nLin+3, nCol+3, nLin+4, nCol+27, ValoAnte )
          Sombra     ( nLin, nCol-1, nLin+16, nCol+32 )
        endif   
        loop  
      case nTecla == K_RIGHT
        if nCol+34 <= 76
          ValoAnte := savescreen ( nLin+3, nCol+3, nLin+4, nCol+27 )
          restscreen( nLin, nCol-1, nLin+17, nCol+34, TelaCalc )
          nCol := nCol + 2  
          TelaCalc := savescreen( nLin, nCol-1, nLin+17, nCol+34 ) 
          restscreen ( nLin, nCol-1, nLin+16, nCol+32, TelaCal2 ) 
          TelaCal2 := savescreen( nLin, nCol-1, nLin+16, nCol+32 ) 
          restscreen ( nLin+3, nCol+3, nLin+4, nCol+27, ValoAnte )
          Sombra     ( nLin, nCol-1, nLin+16, nCol+32 )
        endif   
        loop    
      case nTecla == 44 .or. nTecla == 46
        setcolor ( CorPisca )
        @ nLin+15,nCol+21 say 'ßßß'
       
        setcolor( CorJanel )
        @ nLin+14,nCol+20 say ' '
        
        setcolor( CorMenus )  
        @ nLin+14,nCol+21 say ' ú '
        
        inkey ( 0.10 )              // .
      
        @ nLin+14,nCol+20 say ' ú '

        setcolor ( CorSombra )
        @ nLin+14,nCol+23 say 'Ü'
        @ nLin+15,nCol+21 say 'ßßß'

        lDecOk := .t.
      case nTecla == 13 .or. nTecla == 61 .or. nTecla == 43 .or.;
           nTecla == 45 .or. nTecla == 42 .or. nTecla == 47
        do case
          case cOpera == '+'
            nValCalc3 += nValCalc2 
          case cOpera == '-'
            nValCalc3 -= nValCalc2 
          case cOpera == '*'
            nValCalc3 *= nValCalc2
          case cOpera == '/'
            if nValCalc2 != 0
              nValCalc3 /= nValCalc2
            endif
          case cOpera == ' '
            if nTecla == 13
              nValCalc3 := 0
            else
              nValCalc3 := nValCalc2
            endif
        endcase

        nValCalc2 := nValCalc := 0
        nContDec  := 0
        lDecOk    := .f.

        setcolor ( CorMenus )
        @ nLin+03,nCol+04 say nValCalc3 pict '@E 999,999,999,999,999.9999'

        setcolor ( CorPisca )
        do case
          case nTecla == 43
            @ nLin+11,nCol+27 say 'ßßß'

            setcolor( CorJanel )
            @ nLin+08,nCol+26 say ' '
            @ nLin+09,nCol+26 say ' '
            @ nLin+10,nCol+26 say ' '

            setcolor( CorMenus )
            @ nLin+08,nCol+27 say '   '
            @ nLin+09,nCol+27 say ' + '
            @ nLin+10,nCol+27 say '   '
            
            inkey ( 0.10 )                // +  

            @ nLin+08,nCol+26 say '   '
            @ nLin+09,nCol+26 say ' + '
            @ nLin+10,nCol+26 say '   '
            
            setcolor ( CorSombra )
            @ nLin+08,nCol+29 say 'Ü'
            @ nLin+09,nCol+29 say 'Û'
            @ nLin+10,nCol+29 say 'Û'
            @ nLin+11,nCol+27 say 'ßßß'

            cOpera := '+'
          case nTecla == 45
            @ nLin+07,nCol+27 say 'ßßß'
             
            setcolor( CorJanel ) 
            @ nLin+06,nCol+26 say ' '

            setcolor( CorMenus )
            @ nLin+06,nCol+27 say ' - '
            
            inkey ( 0.10 )                // -

            @ nLin+06,nCol+26 say ' - '

            setcolor ( CorSombra )
            @ nLin+06,nCol+29 say 'Ü'
            @ nLin+07,nCol+27 say 'ßßß'

            cOpera   := '-'
          case nTecla == 42
            @ nLin+07,nCol+21 say 'ßßß'
            
            setcolor( CorJanel )
            @ nLin+06,nCol+20 say ' '
            
            setcolor( CorMenus )
            @ nLin+06,nCol+21 say ' * '
 
            inkey ( 0.10 )                            // * 

            @ nLin+06,nCol+20 say ' * '
            
            setcolor ( CorSombra )
            @ nLin+06,nCol+23 say 'Ü'
            @ nLin+07,nCol+21 say 'ßßß'

            cOpera   := '*'
          case nTecla == 47
            @ nLin+07,nCol+16 say 'ßßß'
            
            setcolor( CorJanel )
            @ nLin+06,nCol+15 say ' '
            
            setcolor( CorMenus )
            @ nLin+06,nCol+16 say ' / '
      
            inkey ( 0.10 )                 // / 

            @ nLin+06,nCol+15 say ' / '
      
            setcolor ( CorSombra )
            @ nLin+06,nCol+18 say 'Ü'
            @ nLin+07,nCol+16 say 'ßßß'
            cOpera   := '/'
          case nTecla == K_DEL .or. nTecla == K_BS
            setcolor( CorPisca )
            @ nLin+07,nCol+04 say 'ßßßß'
        
            setcolor( CorJanel )
            @ nLin+06,nCol+03 say '    '
        
            setcolor( CorMenus ) 
            @ nLin+06,nCol+04 say ' <- '
        
            inkey ( 0.10 )                    // DEL
       
            @ nLin+06,nCol+03 say ' <- '

            setcolor ( CorSombra )
            @ nLin+06,nCol+07 say 'Ü'
            @ nLin+07,nCol+04 say 'ßßßß'

            cOpera   := 'DEL'
         case nTecla == 13 .or. nTecla == 61
            @ nLin+15,nCol+27 say 'ßßß'
          
            setcolor ( CorJanel )
            @ nLin+12,nCol+26 say ' '
            @ nLin+13,nCol+26 say ' '
            @ nLin+14,nCol+26 say ' ' 
 
            setcolor ( CorMenus )
            @ nLin+12,nCol+27 say '   '
            @ nLin+13,nCol+27 say ' = '
            @ nLin+14,nCol+27 say '   '
  
            inkey ( 0.10 )                 // =

            @ nLin+12,nCol+26 say '   '
            @ nLin+13,nCol+26 say ' = '
            @ nLin+14,nCol+26 say '   '
  
            setcolor ( CorSombra )
            @ nLin+12,nCol+29 say 'Ü'
            @ nLin+13,nCol+29 say 'Û'
            @ nLin+14,nCol+29 say 'Û'
            @ nLin+15,nCol+27 say 'ßßß'
              
            nValCalc2 := nValCalc3
            nValCalc3 := 0
            cOpera    := space(1)
        endcase
      case nTecla == 67 .or. nTecla == 99
        nValCalc := nValCalc2 := nValCalc3 := 0
        cOpera   := space(1)
        nContDec := 0
        lDecOk   := .f.

        setcolor ( CorMenus )
        @ nLin+03,nCol+04 say nValCalc3 pict '@E 999,999,999,999,999.9999'
      case nTecla == 37 .or. nTecla == 80 .or. nTecla == 112
        setcolor( CorPisca )
        @ nLin+07,nCol+11 say 'ßßß'
        
        setcolor( CorJanel )
        @ nLin+06,nCol+10 say ' '
        
        setcolor( CorMenus ) 
        @ nLin+06,nCol+11 say ' % '
        
        inkey ( 0.10 )                    // %
      
        @ nLin+06,nCol+10 say ' % '

        setcolor ( CorSombra )
        @ nLin+06,nCol+13 say 'Ü'
        @ nLin+07,nCol+11 say 'ßßß'

        do case 
          case cOpera == '+'
            nValCalc3 := nValCalc3 + ( ( nValCalc3 * nValCalc2 ) / 100 )
          case cOpera == '-'
            nValCalc3 := nValCalc3 - ( ( nValCalc3 * nValCalc2 ) / 100 )
          case cOpera == '*'
            nValCalc3 := ( ( nValCalc3 * nValCalc2 ) / 100 )
        endcase    
      
        cOpera    := space(1)
        nContDec  := 0
        lDecOk    := .f.
        nValCalc2 := nValCalc3

        setcolor ( CorMenus )
        @ nLin+03,nCol+04 say nValCalc3 pict '@E 999,999,999,999,999.9999'
      case nTecla == K_ALT_P  
        cSerie    := int( ( nCodigo * 29 ) / 12 ) 
      case nTecla == K_DEL .or. nTecla == K_BS
        setcolor( CorPisca )
        @ nLin+07,nCol+04 say 'ßßßß'
        
        setcolor( CorJanel )
        @ nLin+06,nCol+03 say '    '
        
        setcolor( CorMenus ) 
        @ nLin+06,nCol+04 say ' <- '
        
        inkey ( 0.10 )                    // DEL
      
        @ nLin+06,nCol+03 say ' <- '

        setcolor ( CorSombra )
        @ nLin+06,nCol+07 say 'Ü'
        @ nLin+07,nCol+04 say 'ßßßß'

        cValCalc2  := str( nValCalc2  )
        nValCalc2  := val( substr( cValCalc2,  1, len( cValCalc2 ) - 1 ) )

        setcolor ( CorMenus )
        @ nLin+03,nCol+04 say nValCalc2    pict '@E 999,999,999,999,999.9999'
      case nTecla == 77 .or. nTecla == 109
        nTecla := Teclar(0)

        setcolor( CorPisca )
        do case
          case nTecla == 43
            @ nLin+09,nCol+04 say 'ßßßß'
 
            setcolor ( CorJanel )
            @ nLin+08,nCol+03 say ' '
          
            setcolor ( CorMenus )
            @ nLin+08,nCol+04 say ' M+ '
            
            inkey ( 0.10 )                     // M+
          
            @ nLin+08,nCol+03 say ' M+ '
          
            setcolor ( CorSombra )
            @ nLin+08,nCol+07 say 'Ü'
            @ nLin+09,nCol+04 say 'ßßßß'
            nMemCalc += nValCalc2
          case nTecla == 45
            @ nLin+11,nCol+04 say 'ßßßß'
          
            setcolor ( CorJanel )
            @ nLin+10,nCol+03 say ' '
          
            setcolor ( CorMenus )
            @ nLin+10,nCol+04 say ' M- '

            inkey ( 0.10 )                    // M-  
           
            @ nLin+10,nCol+03 say ' M- '
           
            setcolor ( CorSombra )
            @ nLin+10,nCol+07 say 'Ü'
            @ nLin+11,nCol+04 say 'ßßßß'
            nMemCalc -= nValCalc2
          case nTecla == 82 .or. nTecla ==114
            @ nLin+13,nCol+04 say 'ßßßß'
           
            setcolor ( CorJanel )
            @ nLin+12,nCol+03 say ' '

            setcolor ( CorMenus )
            @ nLin+12,nCol+04 say ' MR '
          
            inkey ( 0.10 )                   // MR
          
            @ nLin+12,nCol+03 say ' MR '
          
            setcolor ( CorSombra )
            @ nLin+12,nCol+07 say 'Ü'
            @ nLin+13,nCol+04 say 'ßßßß'
          
            nValCalc2 := nMemCalc
            nValCalc  := 0
            nContDec  := 0
            lDecOk    := .f.

            setcolor ( CorMenus )
            @ nLin+03,nCol+04 say nValCalc2 pict '@E 999,999,999,999,999.9999'
          case nTecla == 67 .or. nTecla == 99
            setcolor( CorPisca )
            @ nLin+15,nCol+04 say 'ßßßß'
            
            setcolor ( CorJanel )
            @ nLin+14,nCol+03 say ' '
            
            setcolor ( CorMenus )
            @ nLin+14,nCol+04 say ' MC '
            
            inkey ( 0.10 )                  // MC

            @ nLin+14,nCol+03 say ' MC '

            setcolor ( CorSombra )
            @ nLin+14,nCol+07 say 'Ü'
            @ nLin+15,nCol+04 say 'ßßßß'

            nMemCalc := 0
        endcase
      case nTecla >= 48 .and. nTecla <= 57
        setcolor ( CorPisca )
        nValCalc := nValCalc * 10
        do case
          case nTecla == 48
            @ nLin+15,nCol+11 say 'ßßßßßßßß'
            setcolor ( CorJanel )
            @ nLin+14,nCol+10 say ' '
           
            setcolor ( CorMenus )
            @ nLin+14,nCol+11 say ' 0      '
            
            inkey ( 0.10 )                 // 0
          
            @ nLin+14,nCol+10 say ' 0      '
          
            setcolor ( CorSombra )
            @ nLin+14,nCol+18 say 'Ü'
            @ nLin+15,nCol+11 say 'ßßßßßßßß'
          case nTecla == 49             
            @ nLin+13,nCol+11 say 'ßßß'

            setcolor ( CorJanel )
            @ nLin+12,nCol+10 say ' '
          
            setcolor ( CorMenus )
            @ nLin+12,nCol+11 say ' 1 '
          
            inkey ( 0.10 )                // 1 

            @ nLin+12,nCol+10 say ' 1 '

            setcolor ( CorSombra )
            @ nLin+12,nCol+13 say 'Ü'
            @ nLin+13,nCol+11 say 'ßßß'

            nValCalc += 1
          case nTecla == 50
            @ nLin+13,nCol+16 say 'ßßß'
          
            setcolor ( CorJanel )
            @ nLin+12,nCol+15 say ' '
          
            setcolor ( CorMenus )
            @ nLin+12,nCol+16 say ' 2 '
          
            inkey ( 0.10 )                // 2
          
            @ nLin+12,nCol+15 say ' 2 '
          
            setcolor ( CorSombra )
            @ nLin+12,nCol+18 say 'Ü'
            @ nLin+13,nCol+16 say 'ßßß'
            nValCalc += 2
          case nTecla == 51             
            @ nLin+13,nCol+21 say 'ßßß'

            setcolor ( CorJanel )
            @ nLin+12,nCol+20 say ' '

            setcolor ( CorMenus )
            @ nLin+12,nCol+21 say ' 3 '
          
            inkey ( 0.10 )               // 3
          
            @ nLin+12,nCol+20 say ' 3 '
          
            setcolor ( CorSombra )
            @ nLin+12,nCol+23 say 'Ü'
            @ nLin+13,nCol+21 say 'ßßß'
          
            nValCalc += 3
          case nTecla == 52           
            @ nLin+11,nCol+11 say 'ßßß'
          
            setcolor ( CorJanel )
            @ nLin+10,nCol+10 say ' '
          
            setcolor ( CorMenus )
            @ nLin+10,nCol+11 say ' 4 '
            
            inkey ( 0.10 )              // 4
          
            @ nLin+10,nCol+10 say ' 4 '
          
            setcolor ( CorSombra ) 
            @ nLin+10,nCol+13 say 'Ü'
            @ nLin+11,nCol+11 say 'ßßß'
          
            nValCalc += 4
          case nTecla == 53
            @ nLin+11,nCol+16 say 'ßßß'
          
            setcolor ( CorJanel )
            @ nLin+10,nCol+15 say ' '
          
            setcolor ( CorMenus )
            @ nLin+10,nCol+16 say ' 5 '
          
            inkey ( 0.10 )              // 5
          
            @ nLin+10,nCol+15 say ' 5 '
          
            setcolor ( CorSombra )
            @ nLin+10,nCol+18 say 'Ü'
            @ nLin+11,nCol+16 say 'ßßß'
            nValCalc += 5
          case nTecla == 54
            @ nLin+11,nCol+21 say 'ßßß'
          
            setcolor ( CorJanel )
            @ nLin+10,nCol+20 say ' '
            
            setcolor ( CorMenus )
            @ nLin+10,nCol+21 say ' 6 '
          
            inkey ( 0.10 )              // 6
           
            @ nLin+10,nCol+20 say ' 6 '
           
            setcolor ( CorSombra )
            @ nLin+10,nCol+23 say 'Ü'
            @ nLin+11,nCol+21 say 'ßßß'
           
            nValCalc += 6
          case nTecla == 55
            @ nLin+09,nCol+11 say 'ßßß'
           
            setcolor ( CorJanel )
            @ nLin+08,nCol+10 say ' '
           
            setcolor ( CorMenus )
            @ nLin+08,nCol+11 say ' 7 '
           
            inkey ( 0.10 )             // 7 
          
            @ nLin+08,nCol+10 say ' 7 '

            setcolor ( CorSombra ) 
            @ nLin+08,nCol+13 say 'Ü'
            @ nLin+09,nCol+11 say 'ßßß'

            nValCalc += 7
          case nTecla == 56
            @ nLin+09,nCol+16 say 'ßßß'

            setcolor ( CorJanel )
            @ nLin+08,nCol+15 say ' '
          
            setcolor ( CorMenus )
            @ nLin+08,nCol+16 say ' 8 '
          
            inkey ( 0.10 )             // 8
          
            @ nLin+08,nCol+15 say ' 8 '

            setcolor ( CorSombra )
            @ nLin+08,nCol+18 say 'Ü'
            @ nLin+09,nCol+16 say 'ßßß'
            nValCalc += 8
          case nTecla == 57
            @ nLin+09,nCol+21 say 'ßßß'
          
            setcolor ( CorJanel )
            @ nLin+08,nCol+20 say ' '
          
            setcolor ( CorMenus )
            @ nLin+08,nCol+21 say ' 9 '
           
            inkey ( 0.10 )            // 9
           
            @ nLin+08,nCol+20 say ' 9 '

            setcolor ( CorSombra )
            @ nLin+08,nCol+23 say 'Ü'
            @ nLin+09,nCol+21 say 'ßßß'
           
            nValCalc += 9
        endcase

        if nValCalc > 999999999999999 .or. lDecOk
          nContDec ++
          do case
            case nContDec == 1
              nValCalc2 := nValCalc / 10
            case nContDec == 2
              nValCalc2 := nValCalc / 100
            case nContDec == 3
              nValCalc2 := nValCalc / 1000
            case nContDec == 4
              nValCalc2 := nValCalc / 10000
          endcase
        else 
          nValCalc2 := nValCalc
        endif

        setcolor ( CorMenus )
        @ nLin+03,nCol+04 say nValCalc2 pict '@E 999,999,999,999,999.9999'
    endcase
  enddo
  restscreen( 00, 00, 23, 79, tCalc )
  
  select ParaARQ
  set order to 1
  if RegLock()
    replace Linha    with nLin
    replace Coluna   with nCol
    dbunlock ()
  endif

  if !empty( cArquivo )  
    select( cArquivo )
  endif
  setcolor( cCores )
return NIL

function AndaCalc ( nLin, nCol )
  Janela ( nLin, nCol-1, nLin+16, nCol+32, mensagem( "Janela", "Calcular", .f. ), .f. )
 
  setcolor ( CorJanel )
  
  @ nLin+02,nCol+02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
  @ nLin+03,nCol+02 say '³'
  @ nLin+03,nCol+29 say '³'
  @ nLin+04,nCol+02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

  setcolor ( CorMenus )
  @ nLin+03,nCol+04 say '                  0,0000'
  
  @ nLin+06,nCol+03 say ' <- ' 
  @ nLin+06,nCol+10 say ' % '
  @ nLin+06,nCol+15 say ' / '
  @ nLin+06,nCol+20 say ' * '
  @ nLin+06,nCol+26 say ' - '
  
  @ nLin+08,nCol+03 say ' M+ '
  @ nLin+08,nCol+10 say ' 7 '
  @ nLin+08,nCol+15 say ' 8 '
  @ nLin+08,nCol+20 say ' 9 '
  @ nLin+08,nCol+26 say '   '

  @ nLin+08,nCol+26 say '   '
  @ nLin+09,nCol+26 say ' + '
  @ nLin+10,nCol+26 say '   '
  
  @ nLin+10,nCol+03 say ' M- '
  @ nLin+10,nCol+10 say ' 4 '
  @ nLin+10,nCol+15 say ' 5 '
  @ nLin+10,nCol+20 say ' 6 '

  @ nLin+12,nCol+03 say ' MR '
  @ nLin+12,nCol+10 say ' 1 '
  @ nLin+12,nCol+15 say ' 2 '
  @ nLin+12,nCol+20 say ' 3 '
  @ nLin+12,nCol+26 say '   '
  
  @ nLin+13,nCol+26 say ' = '
  
  @ nLin+14,nCol+03 say ' MC '
  @ nLin+14,nCol+10 say ' 0      '
  @ nLin+14,nCol+20 say ' ú '
  @ nLin+14,nCol+26 say '   '
  
  setcolor( CorSombra )
  @ nLin+14,nCol+23 say 'Ü'           // .
  @ nLin+15,nCol+21 say 'ßßß'
  @ nLin+08,nCol+29 say 'Ü'
  @ nLin+09,nCol+29 say 'Û'           // +
  @ nLin+10,nCol+29 say 'Û'
  @ nLin+11,nCol+27 say 'ßßß'
  @ nLin+06,nCol+29 say 'Ü'           // -
  @ nLin+07,nCol+27 say 'ßßß'    
  @ nLin+06,nCol+23 say 'Ü'           // * 
  @ nLin+07,nCol+21 say 'ßßß'
  @ nLin+06,nCol+18 say 'Ü'           // /
  @ nLin+07,nCol+16 say 'ßßß'
  @ nLin+12,nCol+29 say 'Ü'
  @ nLin+13,nCol+29 say 'Û'           // =
  @ nLin+14,nCol+29 say 'Û'
  @ nLin+15,nCol+27 say 'ßßß'
  @ nLin+06,nCol+13 say 'Ü'           // %
  @ nLin+07,nCol+11 say 'ßßß'
  @ nLin+06,nCol+07 say 'Ü'           // DEL
  @ nLin+07,nCol+04 say 'ßßßß'
  @ nLin+08,nCol+07 say 'Ü'           // M+
  @ nLin+09,nCol+04 say 'ßßßß'
  @ nLin+10,nCol+07 say 'Ü'           // M- 
  @ nLin+11,nCol+04 say 'ßßßß' 
  @ nLin+12,nCol+07 say 'Ü'           // MR
  @ nLin+13,nCol+04 say 'ßßßß'
  @ nLin+14,nCol+07 say 'Ü'           // MC
  @ nLin+15,nCol+04 say 'ßßßß'
  @ nLin+14,nCol+18 say 'Ü'           // 0
  @ nLin+15,nCol+11 say 'ßßßßßßßß'
  @ nLin+12,nCol+13 say 'Ü'           // 1
  @ nLin+13,nCol+11 say 'ßßß'
  @ nLin+12,nCol+18 say 'Ü'           // 2 
  @ nLin+13,nCol+16 say 'ßßß'
  @ nLin+12,nCol+23 say 'Ü'           // 3
  @ nLin+13,nCol+21 say 'ßßß'
  @ nLin+10,nCol+13 say 'Ü'           // 4
  @ nLin+11,nCol+11 say 'ßßß'
  @ nLin+10,nCol+18 say 'Ü'           // 5
  @ nLin+11,nCol+16 say 'ßßß'
  @ nLin+10,nCol+23 say 'Ü'           // 6
  @ nLin+11,nCol+21 say 'ßßß'
  @ nLin+08,nCol+13 say 'Ü'           // 7
  @ nLin+09,nCol+11 say 'ßßß'
  @ nLin+08,nCol+18 say 'Ü'           // 8
  @ nLin+09,nCol+16 say 'ßßß'
  @ nLin+08,nCol+23 say 'Ü'           // 9
  @ nLin+09,nCol+21 say 'ßßß'
return NIL  

//
// Retorna o Valor em Extenso                                               
//
function Extenso( pTotal, nTam1, nTam2 )

  declare vet1[9], vet2[9], vet3[9], vet4[9]
 
  vet1[1] := 'UM '
  vet1[2] := 'DOIS '
  vet1[3] := 'TRES '
  vet1[4] := 'QUATRO '
  vet1[5] := 'CINCO '
  vet1[6] := 'SEIS '
  vet1[7] := 'SETE '
  vet1[8] := 'OITO '
  vet1[9] := 'NOVE '

  vet2[1] := 'DEZ '
  vet2[2] := 'VINTE '
  vet2[3] := 'TRINTA '
  vet2[4] := 'QUARENTA '
  vet2[5] := 'CINQUENTA '
  vet2[6] := 'SESSENTA '
  vet2[7] := 'SETENTA '
  vet2[8] := 'OITENTA '
  vet2[9] := 'NOVENTA '

  vet3[1] := 'CENTO '
  vet3[2] := 'DUZENTOS '
  vet3[3] := 'TREZENTOS '
  vet3[4] := 'QUATROCENTOS '
  vet3[5] := 'QUINHENTOS '
  vet3[6] := 'SEISCENTOS '
  vet3[7] := 'SETECENTOS '
  vet3[8] := 'OITOCENTOS '
  vet3[9] := 'NOVECENTOS ' 

  vet4[1] := 'ONZE '
  vet4[2] := 'DOZE '
  vet4[3] := 'TREZE '
  vet4[4] := 'QUATORZE '
  vet4[5] := 'QUINZE '
  vet4[6] := 'DEZESEIS '
  vet4[7] := 'DEZESETE '
  vet4[8] := 'DEZOITO '
  vet4[9] := 'DEZENOVE '

  pTotal  := str( pTotal, 12, 2 )
  
  if pTotal == '************'
    cExtenso := 'Estourou a capacidade numerica prevista'
    return NIL
  endif   

  eTama    := len( pTotal )
  cExtenso := ''
  Macro    := '4'
  nLig     := 0
  nLig1    := 0
  nChave   := 0
  nChave1  := 1

  for i := 1 to eTama
    Nu    := substr( pTotal, i, 1 )
    Macro := strzero( val( Macro ) - 1, 1, 0 )

    if Nu # ' '.and. Nu # '.'
      if Nu # '0'
        if Macro == '2'
          if substr( pTotal, i+1, 1 ) # '0'.and. substr( pTotal, i, 1 ) == '1'
            cExtenso := cExtenso + vet4[ val( substr( pTotal, i+1, 1 ) ) ]
            pTotal   := substr( pTotal, 1, i ) + '0' + substr( pTotal, i+2, eTama-(i+1))
            nLig1    := 1
          else
            cExtenso := cExtenso + vet&Macro[ int( val( Nu ) ) ]
            if substr( pTotal, i+1, 1 ) # '0' .and. substr( pTotal, i+1, 1 ) # '.' .and. i # eTama .and. Macro # '1'
              cExtenso := cExtenso + 'E '
            endif   
            nLig1 := 1
          endif                          
        else   
          Nu1 := substr( pTotal, i+1, 1 )
          Nu2 := substr( pTotal, i+2, 1 )
          if Macro == '3'
            if Nu == '1' .and. Nu1 == '0' .and. Nu2 == '0'
              cExtenso := cExtenso + 'CEM '
            else
              cExtenso := cExtenso + vet&Macro[ int( val( Nu ) ) ]
            endif      
          else        
            cExtenso := cExtenso + vet&Macro[ int( val( Nu ) ) ]
          endif  
          if substr( pTotal, i+1, 1 ) # '0' .and. substr( pTotal, i+1, 1 ) # '.' .and. i # eTama .and. Macro # '1'
            cExtenso := cExtenso + 'E '
          endif   
          nLig1 := 1   
        endif   
      endif      
    
      if Macro == '1'
        Macro  := '4'
        nLig   := 1
        nChave += 1
      endif   
    
      if nLig == 1
        nLig := 0
        if nChave == 1
          if nLig1 # 0
            Nu_1 := substr( pTotal, i-1, 1 )
            Nu_2 := substr( pTotal, i-2, 1 )
            if Nu == '1' .and. Nu_1 == ' ' .and. Nu_2 == ' '
              cExtenso := cExtenso + 'MILHAO, '
            else
              cExtenso := cExtenso + 'MILHOES, '
            endif      
            nChave1 := 1
          endif      
        endif
    
        if nChave == 2
          if nLig1 # 0
            cExtenso := cExtenso + 'MIL, '
            nChave1  := 2
          endif  
        endif
    
        if nChave == 3
          if nLig1 # 0
            if substr( pTotal, eTama-1, 1 ) # '0' .or. substr( pTotal, eTama, 1 ) # '0'
              cExtenso := cExtenso + 'REAIS E '
            else
              cExtenso := cExtenso + 'REAIS'
            endif         
            nChave1 := 3
          endif      
        endif
    
        if nChave == 4
          if nLig1 # 0
            cExtenso := cExtenso + 'CENTAVOS'
            nChave1  := 4
          endif      
        endif   
        nLig1 := 0
      endif
    endif
    if Macro == '1'
      Macro  := '4'
      nChave += 1
    endif   
  next 
  if nChave1 == 1
    cExtenso := cExtenso + 'de REAIS' 
  endif   
  if nChave1 == 2
    cExtenso := cExtenso + 'REAIS'
  endif   

  pTotal   := val( pTotal )
  nTamanho := len( cExtenso )
  nCont    := nTam1
   
  if nTamanho > nTam1
    cLetra := substr( cExtenso, nTam1, 1 )
    do while .t.
      if cLetra == ' '
        public cValorExt1 := substr( cExtenso, 1, nCont )
        nExt1             := pTotal - len ( cValorExt1 )
        nIni              := len ( cValorExt1 )
        cValorExt         := substr( cExtenso, nIni + 1, nExt1 )
        nExt2             := nTam2 - len( cValorExt ) 
        public cValorExt2 := cValorExt + replicate( '*', nExt2 )
        return(.t.) 
      else
        nCont --
        cLetra := substr ( cExtenso, nCont, 1 )
        loop
      endif  
    enddo           
  endif  
  nTamExt1          := len( cExtenso )
  public cValorExt1 := cExtenso + replicate( '*', nTam1 - nTamExt1 )
  public cValorExt2 := replicate( '*', nTam2 )
return(.t.)  

// 
// Valida Mes                                                               
// 
function ValidMes( nLinha, nColuna, nMeses )
    
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 
  
  if nMes == 0 .or. nMes < 1 .or. nMes > 13
    tValidMes := savescreen( 00, 00, 23, 79 )
  
    Janela( 06, 29, 13, 43, mensagem( 'Janela', 'ValidMes', .f. ), .f. )
    setcolor( CorJanel )
    
    nMes := achoice( 08, 31, 12, 41, aMesExt )
  
    restscreen( 00, 00, 23, 79, tValidMes ) 
  endif  

  setcolor ( CorCampo )
  do case
    case nMes < 1
      nMes := 1
    case nMes > 13
      nMes := 13
    otherwise
      @ nLinha, nColuna   say strzero( nMes, 2 )
      @ nLinha, nColuna+3 say padr( aMesExt[nMes], 10 )
  endcase

  cMes := strzero( nMes, 2 )

  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
return(.t.)

//
// Protege o Banco de Dados
//
function Protec
  parameters yarq, yexp
  private buffer, handle, le_arq, ab, treg, zera, tant

  if type('yarq') == 'U'
     return .f.
  endif
  
  yarq   := iif ('.' $ yarq, yarq, yarq + '.dbf')
  handle := fopen ('&yarq', 2)

  if handle == -1
    fclose (handle)
    return .f.
  endif

  buffer := space(14)
  le_arq := fread(handle, @buffer, 14)
  ab     := asc (buffer)
  zera   := chr (0) + chr (0)
  treg   := substr (buffer, 11, 2)
  tant   := substr (buffer, 13, 2)

  if pcount () < 2
    fclose (handle)
    return iif ((ab == 3 .or. ab == 131) .and. tant = zera, .t., .f.)
  endif

  if yexp
    if (ab == 3 .or. ab == 131) .and. treg == zera
      buffer := stuff (buffer, 11, 2, tant)
      buffer := stuff (buffer, 13, 2, zera)
    endif

    if ab == 4 .or. ab == 132
      buffer := stuff (buffer, 1, 1, chr (ab - 1))
      buffer := stuff (buffer, 11, 2, tant)
      buffer := stuff (buffer, 13, 2, zera)
    endif
  elseif ab == 3 .or. ab == 131
    buffer := stuff (buffer, 1, 1, chr (ab + 1))

    if treg != zera
      buffer := stuff (buffer, 11, 2, zera)
      buffer := stuff (buffer, 13, 2, treg)
    endif
  endif

  fseek (handle, 0, 0)
  le_arq := fwrite (handle, buffer, 14)
  fclose (handle)
return .t.

