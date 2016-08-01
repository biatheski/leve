//  Leve, Cartao Ponto
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

function Pont( xAlte )
  tPont  := savescreen( 00, 00, 24, 79 )
  cTecla := 0
  nLimpa := 0
  cRepr  := space(6)

  if NetUse( "ReprARQ", .t. )
    VerifIND( "ReprARQ" )
   
    lOpenRepr := .t.
  
    #ifdef DBF_NTX
      set index to ReprIND1, ReprIND2
    #endif
  else 
    lOpenRepr := .f.  
  endif

  if NetUse( "PontARQ", .t. )
    VerifIND( "PontARQ" )
   
    lOpenPont := .t.
  
    #ifdef DBF_NTX
      set index to PontIND1, PontIND2
    #endif
  else 
    lOpenPont := .f.  
  endif
  
  setcolor ( CorFundo )
  @ 00,00 clear to 24,79
 
  Janela( 01, 01, 22, 76, mensagem( 'Janela', 'Pont', .f. ), .f., .t. )
  
  setcolor( CorJanel )  
  @ 03,04 say EmprARQ->Razao

  do while cTecla != K_ESC
      
    ShowHora()
    ShowData()
    
    if cTecla >= 48 .and. cTecla <= 57
      @ 14,15 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?'
      @ 15,15 say '?                                              ?'
      @ 16,15 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?'
      @ 17,15 say '?   1?Turno        2?Turno        3?Turno   ?'
      @ 18,15 say 'ÃÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄ?'
      @ 19,15 say '?      ?      ?      ?      ?      ?      ?'
      @ 20,15 say 'ÀÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄ?'
      
      nRepr  := 0
      nLimpa := 10
      
      @ 15,17 get nRepr      pict '999999'
      read

      if lastkey() == K_ESC
        exit
      endif  
      
      cRepr := strzero( nRepr, 6 )
     
      select ReprARQ
      set order to 1
      dbseek( cRepr, .f. )
  
      if eof()
        Alerta( 'Funcion rio n„o est  cadastrado !!!', 5 ) 
        exit
      else 
        cNome := Nome
        dData := date()
        cHora := time()
        
        @ 15,17 say cRepr       
        @ 15,24 say cNome      pict '@S35'
    
        do case 
          case dow( dData ) == 1                        // Domingo
            cIniTur := DomIniTur
            cIniAlm := DomIniAlm
            cTerAlm := DomTerAlm
            cTerTur := DomTerTur
          case dow( dData ) == 2                        // Segunda
            cIniTur := SegIniTur
            cIniAlm := SegIniAlm
            cTerAlm := SegTerAlm
            cTerTur := SegTerTur
          case dow( dData ) == 3                        // Ter‡a  
            cIniTur := TerIniTur
            cIniAlm := TerIniAlm
            cTerAlm := TerTerAlm
            cTerTur := TerTerTur
          case dow( dData ) == 4                        // Quarta 
            cIniTur := QuaIniTur
            cIniAlm := QuaIniAlm
            cTerAlm := QuaTerAlm
            cTerTur := QuaTerTur
          case dow( dData ) == 5                        // Quinta 
            cIniTur := QuiIniTur
            cIniAlm := QuiIniAlm
            cTerAlm := QuiTerAlm
            cTerTur := QuiTerTur
          case dow( dData ) == 6                        // Sexta
            cIniTur := SexIniTur
            cIniAlm := SexIniAlm
            cTerAlm := SexTerAlm
            cTerTur := SexTerTur
          case dow( dData ) == 7                        // Sabado
            cIniTur := SabIniTur
            cIniAlm := SabIniAlm
            cTerAlm := SabTerAlm
            cTerTur := SabTerTur
        endcase
      endif  
  
      if cIniTur == '00:00' .and. cIniAlm == '00:00'
        nVezes := 1
      else  
        nVezes := 3
      endif  
   
      cHorIniTur := space(05)  
      cHorIniAlm := space(05)  
      cHorTerAlm := space(05)  
      cHorTerTur := space(05)  
      nQtde      := 0
      nSequ      := 0
      nCol       := 17
    
      select PontARQ
      set order to 1
      dbseek( cRepr + dtos( dData ), .f. )
      if found ()
        do while Repr == cRepr .and. Data == dData .and. !eof()
          @ 19,nCol say Hora               pict '99:99'

          nCol  += 8
          nSequ := val( Sequ )
          nQtde ++
      
          if nQtde > nVezes
            Alerta( 'A qtde. de  Saidas/Entradas  e  maiorque o registrado no quadro de horariodo funcionario !', 3 )

            restscreen( 00, 00, 24, 79, tPont )

            if lOpenRepr
              select ReprARQ
              close
            endif  
            if lOpenPont
              select PontARQ
              close
            endif  
            return NIL
          endif     
      
          dbskip ()
        enddo

        nQtde ++
        @ 19,nCol say cHora              pict '99:99'
      else
        @ 19,nCol say cHora              pict '99:99'

        nQtde ++
      endif

      nSequ ++
      cSequ := strzero( nSequ, 2 ) 
  
      select PontARQ
      set order to 1     
      if AdiReg()
        if RegLock()
          replace Sequ            with cSequ
          replace Repr            with cRepr
          replace Data            with dData
          replace Hora            with cHora
          dbunlock ()
        endif  
      endif
    endif
    
    if nLimpa > 0
      if nLimpa == 1
        @ 14,15 say space(50)
        @ 15,15 say space(50)
        @ 16,15 say space(50)
        @ 17,15 say space(50)
        @ 18,15 say space(50)
        @ 19,15 say space(50)
        @ 20,15 say space(50)
        nLimpa := 0
      else
        nLimpa --       
      endif     
    endif
    
    cTecla := inkey(1)
  enddo

  restscreen( 00, 00, 24, 79, tPont )

  if lOpenRepr
    select ReprARQ
    close
  endif  

  if lOpenPont
    select PontARQ
    close
  endif  
return NIL


//
// Visualiza o Valor Grande
//
function ShowNumber( nNumero )
  if nNumero < 0
    return(.t.)
  endif  
 
  aMatriz := array(3,13)
  aNumero := array(9)

//  aMatriz := {{"Ûß?, "  ?, "ßß?, "ßß?, "??, "Ûß?, "Ûß?, "ßß?, "Ûß?, "Ûß?, " ", " ", "   ", "   ", " ?" },;
//              {"??, "  ?, "Ûß?, "ßß?, "ßß?, "ßß?, "Ûß?, "  ?, "Ûß?, "ßß?, " ", " ", "   ", "ßß?, "   " },;
//              {"ßß?, "  ?, "ßß?, "ßß?, "  ?, "ßß?, "ßß?, "  ?, "ßß?, "ßß?, "?, "?, "   ", "   ", " ?" }}

  cNum    := transform( nNumero, '@E 99,999.99' )
  nLen    := len( cNum )
  nLinha  := 8
  
  for nA := 1 to nLen
    do case
      case asc( substr( cNum, nA, 1 ) ) == 32
        nNum := 13
      case asc( substr( cNum, nA, 1 ) ) == 46
        nNum := 12
      case asc( substr( cNum, nA, 1 ) ) == 44
        nNum := 11
      otherwise
        nNum := asc( substr( cNum, nA, 1 ) ) - 47  
    endcase       
  
    aNumero[nA] := nNum
  next  
  
  setcolor( CorJanel )

  for nB := 1 to 3
    for nC := 1 to 9
      ero      := strzero(nC,2)
      cNum&ero := aMatriz[nB,aNumero[nC]]
    next 
    
    if nNumero < 1000
      @ nLinha,007 say cNum01 + ' ' + cNum02 + ' ' + cNum03 + ' ' + cNum04 + ' ' +;
                       cNum05 + ' ' + cNum06 + ' ' + cNum07 + ' ' + cNum08 + ' ' +;
                       cNum09
    else                   
      @ nLinha,009 say cNum01 + ' ' + cNum02 + ' ' + cNum03 + ' ' + cNum04 + ' ' +;
                       cNum05 + ' ' + cNum06 + ' ' + cNum07 + ' ' + cNum08 + ' ' +;
                       cNum09
    endif                   
    nLinha ++        
  next
return NIL

//
// Visualiza o Hora Grande
//
function ShowHora()
  aMatriz := array(3,15)
  aNumero := array(9)
//  aMatriz := {{"Ûß?, "  ?, "ßß?, "ßß?, "??, "Ûß?, "Ûß?, "ßß?, "Ûß?, "Ûß?, " ", " ", "   ", "   ", " ?" },;
//              {"??, "  ?, "Ûß?, "ßß?, "ßß?, "ßß?, "Ûß?, "  ?, "Ûß?, "ßß?, " ", " ", "   ", "ßß?, "   " },;
//              {"ßß?, "  ?, "ßß?, "ßß?, "  ?, "ßß?, "ßß?, "  ?, "ßß?, "ßß?, "?, "?, "   ", "   ", " ?" }}

  cNum    := time()
  nLen    := len( cNum )
  nLinha  := 7
  
  for nA := 1 to nLen
    do case
      case asc( substr( cNum, nA, 1 ) ) == 58
        nNum := 15
      case asc( substr( cNum, nA, 1 ) ) == 32
        nNum := 13
      case asc( substr( cNum, nA, 1 ) ) == 46
        nNum := 12
      case asc( substr( cNum, nA, 1 ) ) == 44
        nNum := 11
      otherwise
        nNum := asc( substr( cNum, nA, 1 ) ) - 47  
    endcase       
  
    aNumero[nA] := nNum
  next  
  
  setcolor( CorJanel )

  for nB := 1 to 3
    for nC := 1 to 8
      ero      := strzero(nC,2)
      cNum&ero := aMatriz[nB,aNumero[nC]]
    next 
    
    @ nLinha,043 say cNum01 + ' ' + cNum02 + ' ' + cNum03 + ' ' + cNum04 + ' ' +;
                     cNum05 + ' ' + cNum06 + ' ' + cNum07 + ' ' + cNum08 
    nLinha ++        
  next
return NIL

//
// Visualiza o Data Grande
//
function ShowData()
  aMatriz := array(3,15)
  aNumero := array(9)
//  aMatriz := {{"Ûß?, "  ?, "ßß?, "ßß?, "??, "Ûß?, "Ûß?, "ßß?, "Ûß?, "Ûß?, " ", " ", "   ", "   ", " ?" },;
//              {"??, "  ?, "Ûß?, "ßß?, "ßß?, "ßß?, "Ûß?, "  ?, "Ûß?, "ßß?, " ", " ", "   ", "ßß?, "   " },;
//              {"ßß?, "  ?, "ßß?, "ßß?, "  ?, "ßß?, "ßß?, "  ?, "ßß?, "ßß?, "?, "?, "   ", "   ", " ?" }}

  cNum    := left(dtoc(date()),5)
  nLen    := len( cNum )
  nLinha  := 3
  
  for nA := 1 to nLen
    do case
      case asc( substr( cNum, nA, 1 ) ) == 47
        nNum := 14
      case asc( substr( cNum, nA, 1 ) ) == 32
        nNum := 13
      case asc( substr( cNum, nA, 1 ) ) == 46
        nNum := 12
      case asc( substr( cNum, nA, 1 ) ) == 44
        nNum := 11
      otherwise
        nNum := asc( substr( cNum, nA, 1 ) ) - 47  
    endcase       
  
    aNumero[nA] := nNum
  next  
  
  setcolor( CorJanel )

  for nB := 1 to 3
    for nC := 1 to 5
      ero      := strzero(nC,2)
      cNum&ero := aMatriz[nB,aNumero[nC]]
    next 
    
    @ nLinha,055 say cNum01 + ' ' + cNum02 + ' ' + cNum03 + ' ' + cNum04 + ' ' +;
                     cNum05 
    nLinha ++        
  next
return NIL

//
// Alterar Cartao Ponto
//
function AltePont ()
  if NetUse( "ReprARQ", .t. )
    VerifIND( "ReprARQ" )
  
    lOpenRepr := .t.

    #ifdef DBF_NTX
      set index to ReprIND1, ReprIND2
    #endif  
  else
    lOpenRepr := .f.  
  endif

  if NetUse( "PontARQ", .t. )
    VerifIND( "PontARQ" )
  
    lOpenPont := .t.

    #ifdef DBF_NTX
      set index to PontIND1, PontIND2
    #endif  
  else
    lOpenPont := .f.
  endif

  tAltera := savescreen( 00, 00, 23, 79 )

  Janela ( 06, 16, 16, 57, mensagem( 'Janela', 'Pont', .f. ), .f. )

  setcolor( CorCampo )
  @ 08,37 say space(18)
    
  setcolor( CorJanel + ',' + CorCampo )
  @ 08,18 say 'Funcionario'
  @ 10,18 say '       Data       Hora'
  @ 11,16 say chr(195) + replicate( chr(196), 40 ) + chr(180)
  @ 11,35 say chr(194)
  for nJ := 12 to 15
    @ nJ,35 say chr(179)
  next
  @ 16,35 say chr(193)
 
  nRepr  := 0
  cRepr  := space(06)
  cAjuda := 'Copi'
  lAjud  := .t.
  
  @ 08,30 get nRepr        pict '999999' valid ValidARQ( 08, 30, "PontARQ", "Codigo", "Repr", "Descricao", "Nome", "Repr", "nRepr", .t., 6, "Consulta Funcionarios", "ReprARQ", 18 )
  read
  
  if lastkey() == K_ESC
    if lOpenPont
      select PontARQ
      close
    endif
    if lOpenRepr 
      select ReprARQ
      close
    endif    
    restscreen( 00, 00, 23, 79, tAltera )
    return NIL
  endif 
  
  cRepr := strzero( nRepr, 6 )
      
  select PontARQ 
  set order to 1
  bFirst := {|| dbseek( cRepr, .t. ) }
  bLast  := {|| dbseek( cRepr, .t. ), dbskip(-1) }
  bFor   := {|| Repr == cRepr }
  bWhile := {|| Repr == cRepr }
 
  oCartao         := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oCartao:nTop    := 10
  oCartao:nLeft   := 18
  oCartao:nBottom := 15
  oCartao:nRight  := 50
  oCartao:headsep := chr(194)+chr(196)
  oCartao:colsep  := chr(179)

  oCartao:addColumn( TBColumnNew("Data",  {|| Data } ) )
  oCartao:addColumn( TBColumnNew("Hora",  {|| Hora } ) )
            
  lExitRequested := .f.
  lAdiciona      := .f.
  lAltera        := .f.
  cSequ          := space(02)
  nSequ          := 0
  
  setcolor( CorJanel )
  @ 11,16 say chr(195)
  @ 11,57 say chr(180)
  
//  oCartao:gobottom()
  oCartao:refreshAll()

  do while !lExitRequested
    Mensagem( 'DELETE Apagar, ESC retorna' ) 
 
    oCartao:forcestable()
    
    cTecla := Teclar(0)

    if oCartao:hitTop .or. oCartao:hitBottom
      tone( 125, 0 )
    endif

    do case
      case cTecla == K_DOWN;        oCartao:down()
      case cTecla == K_UP;          oCartao:up()
      case cTecla == K_PGUP;        oCartao:pageUp()
      case cTecla == K_CTRL_PGUP;   oCartao:goTop()
      case cTecla == K_PGDN;        oCartao:pageDown()
      case cTecla == K_CTRL_PGDN;   oCartao:goBottom()
      case cTecla == K_RIGHT;       oCartao:right()
      case cTecla == K_LEFT;        oCartao:left()
      case cTecla == K_HOME;        oCartao:home()
      case cTecla == K_END;         oCartao:end()
      case cTecla == K_CTRL_LEFT;   oCartao:panLeft()
      case cTecla == K_CTRL_RIGHT;  oCartao:panRight()
      case cTecla == K_CTRL_HOME;   oCartao:panHome()
      case cTecla == K_CTRL_END;    oCartao:panEnd()
      case cTecla == K_ESC;         lExitRequested := .t.
      case cTecla == 46;            lExitRequested := .t.
      case cTecla == K_DEL
        if RegLock()
          dbdelete ()
          dbunlock ()
        endif  

        oCartao:refreshAll()  
    endcase
  enddo
  
  if lOpenPont
    select PontARQ
    close
  endif
  if lOpenRepr
    select ReprARQ
    close
  endif    
  restscreen( 00, 00, 23, 79, tAltera )
return NIL


//
// Cartao Ponto
//
function PrinPont()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "ReprARQ", .t. )
    VerifIND( "ReprARQ" )
    
    #ifdef DBF_NTX
      set index to ReprIND1, ReprIND2
    #endif  
  endif

  if NetUse( "PontARQ", .t. )
    VerifIND( "PontARQ" )

    #ifdef DBF_NTX
      set index to PontIND1, PontIND2
    #endif  
  endif

  tPrt := savescreen( 00, 00, 23, 79 )
  
  Janela ( 07, 13, 11, 69, 'Selecao de Funcionarios', .f.)

  setcolor ( CorJanel + ',' + CorCampo )
  @ 09,15 say '    Data Inicial               Data Final'
  @ 10,15 say 'Funcion. Inicial           Funcion. Final'
  
  select ReprARQ
  set order to 1
  dbgotop ()
  nReprIni := val( Repr )
  dbgobottom ()
  nReprFin := val( Repr )

  select PontARQ
  set order to 1
  dbgotop ()
  dDataIni := date() - 30
  dDataFin := date()
  
  @ 09,32 get dDataIni   pict '99/99/99'
  @ 09,57 get dDataFin   pict '99/99/99'   valid dDataFin >= dDataIni
  @ 10,32 get nReprIni   pict '999999'     valid ValidARQ( 99, 99, "ReprARQ", "Cod.", "Repr", "Descricao", "Nome", "Repr", "nReprIni", .t., 6, "Consulta de Vendedores", "ReprARQ", 40 )  
  @ 10,57 get nReprFin   pict '999999'     valid ValidARQ( 99, 99, "ReprARQ", "Cod.", "Repr", "Descricao", "Nome", "Repr", "nReprFin", .t., 6, "Consulta de Vendedores", "ReprARQ", 40 ) .and. nReprFin >= nReprIni 
  read

  if lastkey() == K_ESC
    select PontARQ
    close
    select ReprARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  Aguarde ()
  
  nPag        := 1
  nLin        := 0
  cArqu2      := cArqu2 + "." + strzero( nPag, 3 )

  cReprIni    := strzero( nReprIni, 6 )
  cReprFin    := strzero( nReprFin, 6 )
  cReprAnt    := space(06)
  lInicio     := .t.
  
  select PontARQ
  set order    to 2
  set relation to Repr into ReprARQ
  dbseek( dtos( dDataIni ), .t. )
  do while !eof ()
    if Data >= dDataIni .and. Data <= dDataFin .and. Repr >= cReprIni .and. Repr <= cReprFin 
      if lInicio
        set printer to ( cArqu2 )
        set device  to printer
        set printer on

        lInicio := .f.
      endif  
    
      if nLin == 0
        Cabecalho( 'Cart„o Ponto', 132, 5 )
        CabPont()
      endif
      
      dData   := Data
      cRepr   := Repr
      cNome   := ReprARQ->Nome
      aHoras  := {}
    
      do case 
        case dow( dData ) == 1;      cDia := 'Domingo'
          cIniTur := ReprARQ->DomIniTur
          cIniAlm := ReprARQ->DomIniAlm
          cTerAlm := ReprARQ->DomTerAlm
          cTerTur := ReprARQ->DomTerTur
        case dow( dData ) == 2;      cDia := 'Segunda'
          cIniTur := ReprARQ->SegIniTur
          cIniAlm := ReprARQ->SegIniAlm
          cTerAlm := ReprARQ->SegTerAlm
          cTerTur := ReprARQ->SegTerTur
        case dow( dData ) == 3;      cDia := 'Ter‡a' 
          cIniTur := ReprARQ->TerIniTur
          cIniAlm := ReprARQ->TerIniAlm
          cTerAlm := ReprARQ->TerTerAlm
          cTerTur := ReprARQ->TerTerTur
        case dow( dData ) == 4;      cDia := 'Quarta'
          cIniTur := ReprARQ->QuaIniTur
          cIniAlm := ReprARQ->QuaIniAlm
          cTerAlm := ReprARQ->QuaTerAlm
          cTerTur := ReprARQ->QuaTerTur
        case dow( dData ) == 5;      cDia := 'Quinta'  
          cIniTur := ReprARQ->QuiIniTur
          cIniAlm := ReprARQ->QuiIniAlm
          cTerAlm := ReprARQ->QuiTerAlm
          cTerTur := ReprARQ->QuiTerTur
        case dow( dData ) == 6;      cDia := 'Sexta'
          cIniTur := ReprARQ->SexIniTur
          cIniAlm := ReprARQ->SexIniAlm
          cTerAlm := ReprARQ->SexTerAlm
          cTerTur := ReprARQ->SexTerTur
        case dow( dData ) == 7;      cDia := 'Sabado'
          cIniTur := ReprARQ->SabIniTur
          cIniAlm := ReprARQ->SabIniAlm
          cTerAlm := ReprARQ->SabTerAlm
          cTerTur := ReprARQ->SabTerTur
      endcase

      do while Data == dData .and. Repr == cRepr .and. !eof()
        aadd( aHoras, Hora )
        dbskip ()
      enddo     
      
      @ nLin,01 say cRepr
      @ nLin,08 say cNome              pict '@S16'
      @ nLin,25 say dData              pict '99/99/99'
      @ nLin,36 say cDia         
      @ nLin,46 say cIniTur            pict '99:99'
      @ nLin,55 say cIniAlm            pict '99:99'
      @ nLin,64 say cTerAlm            pict '99:99'
      @ nLin,73 say cTerTur            pict '99:99'
      
      nCol := 83
      
      for nH := 1 to len( aHoras )
        @ nLin,nCol say aHoras[nH]     pict '99:99'
        
        nCol += 9
      next
      
      @ nLin,116 say '_______________'
      nLin ++
        
      if nLin >= pLimite
        Rodape(132) 

        cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
        cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

        set printer to ( cArqu2 )
        set printer on
      endif
    endif
    dbskip()
  enddo     
  
  if !lInicio
    Rodape(132)
  endif  
 
  set printer to
  set printer off
  set device  to screen

  if Imprimir( cArqu3, 132 )
    select SpooARQ
    if AdiReg(30)
      replace Rela       with cArqu3
      replace Titu       with "Relatorio do Cartao Ponto"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 132
      replace Empr       with cEmpresa
      dbunlock ()
    endif
  endif  
    
  select PontARQ
  close
  select ReprARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL
 
function CabPont ()
  @ 02,01 say 'Periodo ' + dtoc( dDataIni ) + ' a ' + dtoc( dDataFin )
  @ 02,53 say 'Horario de Trabalho                  Horario Trabalhado'
  @ 03,01 say 'Funcionario             Data       Dia    Ini.Tur. Ini.Alm. Ter.Alm. Ter.Tur.  Ini.Tur. Ini.Alm. Ter.Alm. Ter.Tur. Assinatura'

  nLin     := 5
  cReprAnt := space(6)
retur NIL