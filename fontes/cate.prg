//  Leve, Cartão tempo
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

function CaTe ()

if NetUse( "ReprARQ", .t. )
  VerifIND( "ReprARQ" )
  
  lOpenRepr := .t.
 
  #ifdef DBF_NTX  
    set index to ReprIND1, ReprIND2
  #endif  
else 
  lOpenRepr := .f.  
endif

if NetUse( "AbOSARQ", .t. )
  VerifIND( "AbOSARQ" )

  lOpenAbOS := .t.  

  #ifdef DBF_NTX  
    set index to AbOSIND1, AbOSIND2 
  #endif  
else 
  lOpenAbOS := .f.  
endif

if NetUse( "CaTeARQ", .t. )
  VerifIND( "CaTeARQ" )

  lOpenCaTe := .t.  

  #ifdef DBF_NTX  
    set index to CaTeIND1, CaTeIND2
  #endif  
else 
  lOpenCaTe := .f.  
endif

if NetUse( "PaMaARQ", .t. )
  VerifIND( "PaMaARQ" )
  
  lOpenPaMa := .t.

  #ifdef DBF_NTX  
    set index to PaMaIND1, PaMaIND2
  #endif  
else
  lOpenPaMa := .f.
endif

//  Variaveis de Entrada 
nOrdS     := 0
cOrdS     := space(06)
dData     := ctod('  /   /   ')
cHoraIni  := cHoraFin := space(05)
cFnci     := space(07)
cPaMa     := space(04)

aOpcoes   := {}
aArqui    := {}
cCaTeARQ  := CriaTemp(0)
cCaTeIND1 := CriaTemp(1)
cChave    := "Sequ"

aadd( aArqui, { "Sequ",      "C", 004, 0 } )
aadd( aArqui, { "Data",      "D", 008, 0 } )
aadd( aArqui, { "HoraIni",   "C", 005, 0 } )
aadd( aArqui, { "HoraFin",   "C", 005, 0 } )
aadd( aArqui, { "Repr",      "C", 006, 0 } )
aadd( aArqui, { "Pama",      "C", 006, 0 } )
aadd( aArqui, { "Regi",      "N", 008, 0 } )
aadd( aArqui, { "Novo",      "L", 001, 0 } )
aadd( aArqui, { "Lixo",      "L", 001, 0 } )

dbcreate( cCaTeARQ, aArqui )
   
if NetUse( cCaTeARQ, .f., 30 )
  cCaTeTMP := alias ()
    
  #ifdef DBF_CDX
    index on &cChave tag &cCaTeIND1
  #endif

  #ifdef DBF_NTX  
    index on &cChave to &cCaTeIND1
    
    set index to &cCaTeIND1
  #endif
endif

//  Tela Cart„o
Janela( 05, 03, 20, 73, mensagem( 'Janela', 'CaTe', .f. ), .f. )

setcolor ( CorJanel )
@ 07,06 say 'N. Ordem Serviço            Emissão              Hora'
@ 09,06 say 'Data       Inicio Fim   Código Funcionário   Código Parada'

@ 10,03 say chr(195) + replicate( chr(196), 69 ) + chr(180) 

@ 10,16 say chr(194)
@ 10,23 say chr(194)
@ 10,29 say chr(194)
@ 10,36 say chr(194)
@ 10,50 say chr(194)
@ 10,57 say chr(194)

for nU := 11 to 17
  @ nU,16 say chr(179)
  @ nU,23 say chr(179)
  @ nU,29 say chr(179)
  @ nU,36 say chr(179)
  @ nU,50 say chr(179)
  @ nU,57 say chr(179)
next  

@ 18,03 say chr(195) + replicate( chr(196), 69 ) + chr(180)
@ 18,16 say chr(193)
@ 18,23 say chr(193)
@ 18,29 say chr(193)
@ 18,36 say chr(193)
@ 18,50 say chr(193)
@ 18,57 say chr(193)

MostOpcao( 19, 05, 17, 49, 62 )
tNotas := savescreen( 00, 00, 23, 79 )

do while .t.
  Mensagem( 'CaTe', 'Janela' )

  cStat := space(04)
  restscreen( 00, 00, 23, 79, tNotas )
  
  select( cCateTMP )
  set order to 1
  zap
  
  select ReprARQ
  set order to 1
  
  select PaMaARQ
  set order to 1
  
  select CaTeARQ
  set order    to 1 
  set relation to Repr into ReprARQ, to PaMa into PaMaARQ

  MostCaTe ()

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )
  
  MostTudo := 'MostCaTe'
  cAjuda   := 'CaTe'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()

  @ 07,23 get nOrdS            pict '999999'
  read

  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC  
    exit
  end

  cOrdS := strzero( nOrdS, 6 )
  lEnce := .f.
  
  select AbOSARQ
  set order to 1
  dbseek( cOrdS, .f. )
  if eof()
    Alerta( mensagem(  'Alerta', 'CaTeAbOS', .f. ) )
    loop
  endif
    
  if !empty( Term )
    Alerta( mensagem( 'Alerta', 'CaTeEnOS', .f. ) )

    lEnce := .t.
  endif

  setcolor( CorCampo )
  @ 07,42 say Emis         pict '99/99/99' 
  @ 07,60 say HoraEmis     pict '99:99' 

  //  Verificar existencia das Dados para Incluir ou Alterar
  select CaTeARQ
  set order to 1
  dbseek( cOrdS, .t. )
  
  if OrdS == cOrds
    cStat := 'alte'
  else  
    cStat := 'incl'
  endif  
  
  do while !eof() .and. OrdS == cOrdS
    nRegi := recno()

    select( cCaTeTMP )
    if AdiReg()
      if Reglock()
        replace Sequ     with CaTeARQ->Sequ
        replace Data     with CaTeARQ->Data
        replace HoraIni  with CaTeARQ->HoraIni
        replace HoraFin  with CaTeARQ->HoraFin
        replace Repr     with CaTeARQ->Repr
        replace PaMa     with CaTeARQ->PaMa
        replace Regi     with nRegi
        replace Novo     with .f.
        replace Lixo     with .f.
        dbunlock ()
      endif  
    endif  

    select CaTeARQ
    dbskip ()
  enddo
  
  EntrICaT()

  select CaTeARQ

  Confirmar( 19, 05, 17, 49, 62, 3 )
  
  if lastkey() == K_ESC
    loop
  endif  
  
  if cStat == 'excl'
    EstoCaTe ()
  endif  
    
  GravCate ()
enddo

if lOpenCaTe 
  select CateARQ
  close 
endif  

if lOpenAbOS
  select AbosARQ
  close
endif  

if lOpenRepr
  select ReprARQ
  close
endif

if lOpenPaMa
  select PaMaARQ
  close
endif  

select( cCaTeTMP )
close
ferase( cCaTeARQ )
ferase( cCaTeIND1 )
return NIL


//
// Mostra os Dados do Cartao Tempo
//
function MostCaTe ()
  
  nLin  := 11
  nOrdS := val( OrdS )
  cOrdS := OrdS
  
  select AbOSARQ 
  set order to 1
  dbseek( cOrds, .f. )
  
  setcolor( CorCampo )
  @ 07,42 say Emis           pict '99/99/99'
  @ 07,60 say HoraEmis       pict '99:99'

  setcolor( CorJanel )

  select CaTeARQ
  set order to 1
  dbseek( cOrdS, .t. )
  do while !eof() .and. OrdS == cOrdS
    @ nLin, 06 say Data                       pict '99/99/99'
    @ nLin, 17 say left( HoraIni, 2 ) + ':' + right( HoraIni, 2 )
    @ nLin, 24 say left( HoraFin, 2 ) + ':' + right( HoraFin, 2 )
    @ nLin, 30 say Repr                       pict '999999'
    @ nLin, 37 say ReprARQ->Nome              pict '@S13'
    @ nLin, 51 say PaMa                       pict '999999'
    @ nLin, 58 say PaMaARQ->Nome              pict '@S13'
    nLin ++
    dbskip ()
    
    if nLin > 17
      exit
    endif  
  enddo
  
  PosiDBF( 05, 73 )
return NIL

// 
// Entra com dados do Cartao Tempo
//
function EntrICaT ()
  if lastkey() == K_ESC .or. lastkey() == K_PGDN
    return NIL
  endif 

  select( cCaTeTMP )
  set order    to 1
  set relation to Repr into ReprARQ, PaMa into PaMaARQ
  dbgotop ()

  setcolor ( CorJanel + ',' + CorCampo )
  cCor            := setcolor()
  oCartao         := TBrowseDb( 09, 05, 18, 72 )
  oCartao:headsep := chr(194)+chr(196)
  oCartao:colsep  := chr(179)
  oCartao:footsep := chr(193)+chr(196)

  oCartao:addColumn( TBColumnNew("Data",        {|| Data } ) )
  oCartao:addColumn( TBColumnNew("Inicio",      {|| transform( HoraIni, '99:99' ) } ) )
  oCartao:addColumn( TBColumnNew("Fim",         {|| transform( HoraFin, '99:99' ) } ) )
  oCartao:addColumn( TBColumnNew("Código",      {|| Repr } ) )
  oCartao:addColumn( TBColumnNew("Funcionário", {|| left( ReprARQ->Nome, 13 ) } ) )
  oCartao:addColumn( TBColumnNew("Código",      {|| PaMa } ) )
  oCartao:addColumn( TBColumnNew("Parada",      {|| left( PaMaARQ->Nome, 13 ) } ) )
            
  oCartao:goTop()

  lExitRequested := .f.
  lAlterou       := .f.

  do while !lExitRequested
    Mensagem ( 'CaTe', 'Browse' )

    oCartao:forcestable()

//    if ( !lAlterou .and. cStat == 'incl' .and. !lEnce )
//      wTecla := K_INS
//    else  
      wTecla := Teclar(0)
//    endif  

    if oCartao:hitTop .or. oCartao:hitBottom
      tone( 125, 0 )
    endif

    do case
      case wTecla == K_DOWN;        oCartao:down()
      case wTecla == K_UP;          oCartao:up()
      case wTecla == K_PGUP;        oCartao:pageUp()
      case wTecla == K_CTRL_PGUP;   oCartao:goTop()
      case wTecla == K_RIGHT;       oCartao:right()
      case wTecla == K_LEFT;        oCartao:left()
      case wTecla == K_HOME;        oCartao:home()
      case wTecla == K_END;         oCartao:end()
      case wTecla == K_CTRL_LEFT;   oCartao:panLeft()
      case wTecla == K_CTRL_RIGHT;  oCartao:panRight()
      case wTecla == K_CTRL_HOME;   oCartao:panHome()
      case wTecla == K_CTRL_END;    oCartao:panEnd()
      case wTecla == K_ESC
        if Saindo (lAlterou)
          lExitRequested := .t.
        else  
          lExitRequested := .f.
        endif  
      case wTecla == 46;            lExitRequested := .t.
      case wTecla == K_ENTER
        if !lEnce
          ItenICaT( .f. )
        endif
      case wTecla == K_INS
        if !lEnce
          do while lastkey() != K_ESC
            ItenICaT( .t. )
          enddo
        endif
      case wTecla == K_DEL
        if !lEnce
          if RegLock()
            replace Lixo      with .t.  

            dbdelete()
            dbunlock()
          endif
        endif
    endcase
  enddo
return NIL  

//
// Entra intens do Cartao
//
function ItenICaT( lAdiciona )
  if lAdiciona 
    if AdiReg()
      if RegLock()
        replace Sequ            with strzero( recno(), 4 )
        replace Novo            with .t.
        replace Lixo            with .f.
        dbunlock ()
      endif
    endif    

    oCartao:goBottom() 
    oCartao:down()
    oCartao:refreshAll()  

    oCartao:forcestable()

    Mensagem( 'CaTe', 'InclCaTe' ) 
  else
    Mensagem( 'CaTe', 'AlteCaTe' )
  endif  

  dData    := Data
  cHoraIni := HoraIni
  cHoraFin := HoraFin
  cRepr    := Repr
  nRepr    := val( Repr )
  cPaMa    := PaMa
  nPaMa    := val( PaMa )
  nLin     := 10 + oCartao:rowPos
  
  setcolor( CorCampo )
  @ nLin, 37 say ReprARQ->Nome  pict '@S13'  
  @ nLin, 58 say PaMaARQ->Nome  pict '@S13'

  setcolor ( CorJanel + ',' + CorCampo )
  @ nLin, 06 get dData          pict '99/99/9999' valid !empty( dData )                      .and. dData >= AbOsARQ->Emis
  @ nLin, 17 get cHoraIni       pict '99:99'      valid ValidHora( cHoraIni, "cHoraIni" )
  @ nLin, 24 get cHoraFin       pict '99:99'      valid ValidHora( cHoraFin, "cHoraFin" )    .and. cHoraFin > cHoraIni
  @ nLin, 30 get nRepr          pict '999999'     valid ValidARQ( nLin, 30, cCaTeTMP, "Código" , "Repr", "Descrição", "Nome", "Repr", "nRepr", .t., 6, "Consulta de Funcionários", "ReprARQ", 13 )
  @ nLin, 51 get nPaMa          pict '999999'     valid nPama == 0 .or. ValidARQ( nLin, 51, cCaTeTMP, "Código" , "PaMa", "Descrição", "Nome", "PaMa", "nPaMa", .t., 6, "Consulta de Paradas", "PaMaARQ", 13 )
  read
  
  if lastkey() == K_ESC
    if lAdiciona
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif  
    endif  

    oCartao:refreshCurrent()
    oCartao:gobottom()
    return NIL
  endif

  cRepr  := strzero( nRepr, 6 )
  cPaMa  := strzero( nPaMa, 6 )
  
  if RegLock()
    replace Data     with dData
    replace HoraIni  with cHoraIni
    replace HoraFin  with cHoraFin
    replace Repr     with cRepr
    replace PaMa     with cPaMa
    dbunlock ()
  endif

  lAlterou := .t.
  
  oCartao:refreshCurrent()
return NIL

//
// Grava Cartao Tempo
//
function GravCaTe()
  
  set deleted off   
    
  select( cCaTeTMP )
  set order to 1 
  dbgotop ()
  do while !eof ()
    if empty( Repr )
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
    
      select CaTeARQ
      if AdiReg()
        if RegLock()
          replace OrdS       with cOrdS
          replace Sequ       with &cCaTeTMP->Sequ
          replace Data       with &cCaTeTMP->Data
          replace HoraIni    with &cCaTeTMP->HoraIni
          replace HoraFin    with &cCaTeTMP->HoraFin
          replace Repr       with &cCaTeTMP->Repr
          replace PaMa       with &cCaTeTMP->PaMa
          dbunlock ()
        endif
      endif   
    else 
      select CaTeARQ
      go nRegi
      
      if RegLock()
        replace Data       with &cCaTeTMP->Data
        replace HoraIni    with &cCaTeTMP->HoraIni
        replace HoraFin    with &cCaTeTMP->HoraFin
        replace Repr       with &cCaTeTMP->Repr
        replace PaMa       with &cCaTeTMP->PaMa
        dbunlock ()
      endif  
          
      if lLixo
        if RegLock()
          dbdelete ()
          dbunlock ()
        endif
      endif
    endif 
      
    select( cCaTeTMP )
    dbskip ()
  enddo  
   
  set deleted on
  
  select CaTeARQ
return NIL

//
// Excluir Cartao Tempo
//
function EstoCaTe ()
  cStat := 'loop' 
  
  if ExclRegi ()
    select CateARQ
    set order to 1
    dbseek( cOrdS, .t. )
    do while OrdS == cOrdS .and. !eof ()
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif

      dbskip ()
    enddo    
  endif
return NIL

//
// Cartao Tempo - Conta as Horas
//
function VerCate()

  nHoraNor := 0
  nHora050 := 0
  nHora100 := 0
  
  do case
    case cHoraIni >= cHorTerTur
      nHora100 := nTempo

      return ( .t. )
    case cHoraIni < cHorIniTur .and. cHoraFin < cHorIniTur
      cAuxi := sectotime( timetosec( cHoraFin ) - timetosec( cHoraIni ) )
      nAuxi := ValidMin( cAuxi )
           
      nHora100 := nAuxi
      return ( .t. )
    case cHorIniTur == '00:00' .or. cHorIniAlm == '00:00' .or. cHorTerAlm == '00:00' 
      nHora100 := nTempo
       
      return ( .t. )
    case cHoraIni >= cHorIniTur .and. cHoraFin <= cHorIniAlm
      nHoraNor := nTempo
             
      return ( .t. )
    case cHoraIni >= cHorTerAlm .and. cHoraFin <= cHorTerTur
      if cHorTerAlm == '00:00'           
        nHora100 := nTempo
      else  
        nHoraNor := nTempo
      endif  
      return ( .t. )
    case cHoraIni >= cHorIniAlm .and. cHoraFin <= cHorTerAlm
      nHora050 := nTempo
      
      return ( .t. )
    case cHoraIni < cHorIniTur .and. cHoraFin <= cHorIniAlm
      cAuxi := sectotime( timetosec( cHorIniTur ) - timetosec( cHoraIni ) )
      nAuxi := ValidMin( cAuxi )
           
      if cAuxi > '02:00'           
        nHora050 := 2.00
        nHora100 := ValidMin( nAuxi - 2.00 )
      else  
        nHora050 := nAuxi
      endif  
            
      cAuxi    := sectotime( timetosec( cHorIniAlm ) - timetosec( cHorIniTur ) )
      nAuxi    := ValidMin( cAuxi )
      nHoraNor := nAuxi
       
      return ( .t. )
    case cHoraIni >= cHorTerAlm .and. cHoraFin > cHorTerTur .and. cHoraIni < cHorTerTur
      cAuxi := sectotime( timetosec( cHoraFin ) - timetosec( cHorTerTur ) )
      nAuxi := ValidMin( cAuxi )
            
      if cAuxi > '02:00'           
        nHora050 := 2.00
        nHora100 := ValidMin( nAuxi - 2.00 )
      else  
        nHora050 := nAuxi
      endif  
            
      cAuxi    := sectotime( timetosec( cHorTerTur ) - timetosec( cHoraIni ) )
      nAuxi    := ValidMin( cAuxi )
      nHoraNor := nAuxi
       
      return ( .t. )
    case cHoraIni < cHorIniTur .and. cHoraFin > cHorIniAlm .and. cHoraFin <= cHorTerAlm
      cAuxi1 := sectotime( timetosec( cHorIniTur ) - timetosec( cHoraIni ) )
      nAuxi1 := ValidMin( cAuxi1 )
      cAuxi2 := sectotime( timetosec( cHoraFin ) - timetosec( cHorIniAlm ) )
      nAuxi2 := ValidMin( cAuxi2 )
           
      if cAuxi1 > '02:00'           
        nHora050 := 2.00
        nHora100 := ValidMin( nAuxi1 - 2.00 )
      else  
        nHora050 := nAuxi1 
      endif       
            
      nHora050 := ValidMin( nHora050 + nAuxi2 )
            
      cAuxi    := sectotime( timetosec( cHorIniAlm ) - timetosec( cHorIniTur ) )
      nAuxi    := ValidMin( cAuxi )
           
      nHoraNor := nAuxi
      return ( .t. )
    case cHoraIni < cHorIniTur .and. cHoraFin > cHorIniAlm .and. cHoraFin > cHorTerAlm .and. cHoraFin <= cHorTerTur
      cAuxi := sectotime( timetosec( cHorIniTur ) - timetosec( cHoraIni ) )
      nAuxi := ValidMin( cAuxi )
            
      if cAuxi > '02:00'           
        nHora050 := 2.00
        nHora100 := ValidMin( nAuxi - 2.00 )
      else  
        nHora050 := nAuxi
      endif  
            
      nHora050 := ValidMin( nHora050 + 1.00 )

      cAuxi    := sectotime( timetosec( cHorIniAlm ) - timetosec( cHorIniTur ) )
      nAuxi    := ValidMin( cAuxi )
  
      nHoraNor := nAuxi 

      cAuxi    := sectotime( timetosec( cHoraFin ) - timetosec( cHorTerAlm ) )
      nAuxi    := ValidMin( cAuxi )
  
      nHoraNor := ValidMin( nHoraNor + nAuxi )
       
      return ( .t. )
    case cHoraIni < cHorIniTur .and. cHoraFin > cHorIniAlm .and. cHoraFin > cHorTerAlm .and. cHoraFin > cHorTerTur
      cAuxi1 := sectotime( timetosec( cHorIniTur ) - timetosec( cHoraIni ) )
      nAuxi1 := ValidMin( cAuxi1 )

      cAuxi2 := sectotime( timetosec( cHoraFin ) - timetosec( cHorTerTur ) )
      nAuxi2 := ValidMin( cAuxi2 )
            
      if cAuxi1 > '02:00'           
        nHora050 := 2.00
        nHora100 := ValidMin( nAuxi1 - 2.00 )
      else  
        nHora050 := nAuxi1
      endif  

      if cAuxi2 > '02:00'           
        nHora050 := 2.00
        nHora100 := ValidMin( nAuxi2 - 2.00 )
      else  
        nHora050 := nAuxi2 
      endif  
            
      nHora050 := ValidMin( nHora050 + 1.00 )
                
      cAuxi    := sectotime( timetosec( cHorIniAlm ) - timetosec( cHorIniTur ) )
      nAuxi    := ValidMin( cAuxi )
  
      nHoraNor := nAuxi
      
      cAuxi    := sectotime( timetosec( cHorTerTur ) - timetosec( cHorTerAlm ) )
      nAuxi    := ValidMin( cAuxi )
  
      nHoraNor := ValidMin( nHoraNor + nAuxi )
       
      return ( .t. )
    case cHoraIni >= cHorIniAlm .and. cHoraFin <= cHorTerTur
      cAuxi    := sectotime( timetosec( cHorTerAlm ) - timetosec( cHoraIni ) )
      nAuxi    := ValidMin( cAuxi )

      nHora050 := nAuxi 

      cAuxi    := sectotime( timetosec( cHoraFin ) - timetosec( cHorTerAlm ) )
      nAuxi    := ValidMin( cAuxi )
  
      nHoraNor := nAuxi
      return ( .t. )
    case cHoraIni >= cHorIniTur .and. cHoraFin > cHorIniAlm .and. cHoraFin > cHorTerAlm .and. cHoraFin > cHorTerTur .and. cHoraIni < cHorTerTur
      cAuxi    := sectotime( timetosec( cHoraFin ) - timetosec( cHorTerTur ) )
      nAuxi    := ValidMin( cAuxi )

      nHora050 := 1.00
           
      if cAuxi > '02:00'           
        nHora050 := 2.00 
        nHora100 := ValidMin( nAuxi - 2.00 )
      else  
        nHora050 := nAuxi
      endif  

      cAuxi    := sectotime( timetosec( cHorIniAlm ) - timetosec( cHoraIni ) )
      nAuxi    := ValidMin( cAuxi )
 
      nHoraNor := nAuxi 
      
      cAuxi    := sectotime( timetosec( cHorTerTur ) - timetosec( cHorTerAlm ) )
      nAuxi    := ValidMin( cAuxi )
  
      nHoraNor := ValidMin( nHoraNor + nAuxi )
       
      return ( .t. )
    case cHoraIni >= cHorIniAlm .and. cHoraFin > cHorTerTur .and. cHoraIni < cHorTerTur
      cAuxi1   := sectotime( timetosec( cHorTerAlm ) - timetosec( cHoraIni ) )
      nAuxi1   := ValidMin( cAuxi1 )
      cAuxi2   := sectotime( timetosec( cHoraFin ) - timetosec( cHorTerTur ) )
      nAuxi2   := ValidMin( cAuxi2 )

      nHora050 := nAuxi1 
           
      if cAuxi2 > '02:00'           
        nHora050 := ValidMin( nHora050 + 2.00 )
        nHora100 := ValidMin( nAuxi2 - 2.00 )  
      else  
        nHora050 := ValidMin( nHora050 + nAuxi2 )
      endif  

      cAuxi    := sectotime( timetosec( cHorTerTur ) - timetosec( cHorTerAlm ) )
      nAuxi    := ValidMin( cAuxi )
      nHoraNor := nAuxi 
      return ( .t. )
    case cHoraIni >= cHorIniTur .and. cHoraFin > cHorIniAlm .and. cHoraFin <= cHorTerAlm
      cAuxi    := sectotime( timetosec( cHoraFin ) - timetosec( cHorIniAlm ) )
      nAuxi    := ValidMin( cAuxi )
                  
      nHoraNor := nAuxi 
            
      cAuxi    := sectotime( timetosec( cHorIniAlm ) - timetosec( cHoraIni ) )
      nAuxi    := ValidMin( cAuxi )

      nHoraNor := ValidMin( nHoraNor + nAuxi )
       
      return ( .t. )
    case cHoraIni >= cHorIniTur .and. cHoraFin > cHorIniAlm .and. cHoraFin > cHorTerAlm .and. cHoraFin <= cHorTerTur
      cAuxi    := sectotime( timetosec( cHorIniAlm ) - timetosec( cHoraIni ) )
      nAuxi    := ValidMin( cAuxi )

      nHoraNor := nAuxi
      nHora050 := 1.00 
       
      cAuxi    := sectotime( timetosec( cHoraFin ) - timetosec( cHorTerAlm ) )
      nAuxi    := ValidMin( cAuxi )
  
      nHoraNor := ValidMin( nHoraNor + nAuxi )
      return ( .t. )
  endcase    
return(.t.)

//
//  Horas Trabalhadas
//
function PrinHrTr ()
  
  local cHrTrARQ  := CriaTemp( 0 )
  local cHrTrIND1 := CriaTemp( 1 )

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

  if NetUse( "AbOSARQ", .t. )
    VerifIND( "AbOSARQ" )
     
    #ifdef DBF_NTX 
      set index to AbOSIND1, AbOSIND2
    #endif  
  endif

  if NetUse( "TbFnARQ", .t. )
    VerifIND( "TbFnARQ" )

    #ifdef DBF_NTX 
      set index to TbFnIND1
    #endif  
  endif

  if NetUse( "CaTeARQ", .t. )
    VerifIND( "CaTeARQ" )

    #ifdef DBF_NTX 
      set index to CaTeIND1, CaTeIND2
    #endif  
  endif
 
  tPrt  := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela( 06, 08, 13, 73, mensagem( 'Janela', 'PrinHrTr', .f. ), .f. )

  setcolor( CorJanel + ',' + CorCampo )
  @ 08,10 say 'Ordem Serviço Inicial            Ordem Serviço Final'           
  @ 09,10 say '         Data Inicial                     Data Final'
  @ 10,10 say '  Funcionário Inicial              Funcionário Final'
  @ 12,10 say '                 Tipo'
  
  do while .t.
    setcolor( CorCampo )
    @ 12,32 say ' Quantitativo '
    @ 12,47 say ' Descriminado '
    
    setcolor( CorAltKC )
    @ 12,33 say 'Q'
    @ 12,48 say 'D'
  
    select ReprARQ
    set order to 1
    dbgotop ()
    nReprIni := val( Repr )
    dbgobottom ()
    nReprFin := val( Repr )
    
    select AbOSARQ
    set order to 1
    dbgotop ()
    nOrdSIni := val( OrdS )
    dEmisIni := ctod('01/01/1990')
    dbgobottom ()
    nOrdSFin := val( OrdS )
    dEmisFin := ctod('31/12/2015')
    nTipo    := 1
    aTipo    := {}
    aArqui   := {}

    aadd( aTipo, { ' Quantitativo ', 2, 'Q', 12, 32, "Relatório Quantitativo." } )
    aadd( aTipo, { ' Descriminado ', 2, 'D', 12, 47, "Relatório Descriminado." } )

    setcolor( CorJanel + ',' + CorCampo )
    @ 08,32 get nOrdSIni      pict '999999'
    @ 08,63 get nOrdSFin      pict '999999'      valid nOrdSFin >= nOrdSIni
    @ 09,32 get dEmisIni      pict '99/99/99'
    @ 09,63 get dEmisFin      pict '99/99/99'    valid dEmisFin >= dEmisIni
    @ 10,32 get nReprIni      pict '999999'        valid ValidARQ( 99, 99, "AbOSARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprIni", .t., 6, "Consulta de Funcionários", "ReprARQ", 30 ) 
    @ 10,63 get nReprFin      pict '999999'        valid ValidARQ( 99, 99, "AbOSARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprFin", .t., 6, "Consulta de Funcionários", "ReprARQ", 30 ) .and. nReprFin >= nReprIni
    read

    if lastkey() == K_ESC
      exit
    endif
    
    nTipo := HCHOICE( aTipo, 2, nTipo )

    if lastkey() == K_ESC .or. empty( dEmisIni )
      exit
    endif
    
    Aguarde ()

    if nTipo == 1
      aadd( aArqui, { "Nome",      "C", 040, 0 } )
      aadd( aArqui, { "Repr",      "C", 006, 0 } )
      aadd( aArqui, { "Data",      "D", 008, 0 } )
      aadd( aArqui, { "Hor_Nor",   "N", 012, 2 } )
      aadd( aArqui, { "Hor_50",    "N", 012, 2 } )
      aadd( aArqui, { "Hor_100",   "N", 012, 2 } )

      cChave := "Nome + Repr"
    else
      aadd( aArqui, { "Nome",      "C", 040, 0 } )
      aadd( aArqui, { "Repr",      "C", 006, 0 } )
      aadd( aArqui, { "Data",      "D", 008, 0 } )
      aadd( aArqui, { "OrdS",      "C", 006, 0 } )
      aadd( aArqui, { "Inicio",    "C", 005, 0 } )
      aadd( aArqui, { "Final",     "C", 005, 0 } )
      aadd( aArqui, { "Hor_Nor",   "N", 012, 2 } )
      aadd( aArqui, { "Hor_50",    "N", 012, 2 } )
      aadd( aArqui, { "Hor_100",   "N", 012, 2 } )
 
      cChave := "Nome + Repr + dtos( Data ) + OrdS + Inicio + Final"
    endif
 
    dbcreate( cHrTrARQ, aArqui )
   
    if NetUse( cHrTrARQ, .f., 30 )
      cHrTrTMP := alias ()
    
      index on &cChave to &cHrTrIND1

      set index to &cHrTrIND1
    endif
    
    cReprIni := strzero( nReprIni, 6 )
    cReprFin := strzero( nReprFin, 6 )

    select CaTeARQ
    set order    to 2
    set relation to Repr into ReprARQ, OrdS into AbosARQ
    dbseek( cReprIni, .t. )
    do while Repr >= cReprIni .and. Repr <= cReprFin .and. !eof()
      if Data >= dEmisIni .and. Data <= dEmisFin .and. val( PaMa ) == 0
        dData    := Data
        cHoraIni := HoraIni
        cHoraFin := HoraFin

        cTempo   := sectotime( timetosec( cHoraFin ) - timetosec( cHoraIni ) )
        nDia     := dow( dData )

        do case
          case nDia == 1;            cMes := 'Dom'
          case nDia == 2;            cMes := 'Seg'
          case nDia == 3;            cMes := 'Ter'
          case nDia == 4;            cMes := 'Qua'
          case nDia == 5;            cMes := 'Qui'
          case nDia == 6;            cMes := 'Sex'
          case nDia == 7;            cMes := 'Sab'
        endcase

        select ReprARQ

        cHorIniTur := &( cMes+'IniTur' )
        cHorTerTur := &( cMes+'TerTur' )
        cHorIniAlm := &( cMes+'IniAlm' )
        cHorTerAlm := &( cMes+'TerAlm' )

        nHoraNor   := nHora050 := nHora100 := 0

        nTempo     := val( substr( cTempo, 1, 2 ) + '.' + substr( cTempo, 4, 2 ) )
        cHoraAntes := sectotime( timetosec( cHorIniTur ) - timetosec( '02:00' ) )
        cHoraDepoi := sectotime( timetosec( cHorTerTur ) + timetosec( '02:00' ) )

        VerCate()

        nHoraNor := ValidMin( nHoraNor )
        nHora050 := ValidMin( nHora050 )
        nHora100 := ValidMin( nHora100 )

        if nTipo == 1
          select( cHrTrTMP )
          set order to 1
          dbseek( ReprARQ->Nome + CaTeARQ->Repr, .f. )
          if eof()
            if AdiReg()
              replace Repr        with CaTeARQ->Repr
              replace Nome        with ReprARQ->Nome
              replace Data        with CaTeARQ->Data
              replace Hor_nor     with nHoraNor
              replace Hor_50      with nHora050
              replace Hor_100     with nHora100
              dbunlock ()
            endif
          else
            if RegLock()
              replace Hor_nor     with ( Hor_Nor + nHoraNor )
              replace Hor_50      with ( Hor_50 + nHora050 )
              replace Hor_100     with ( Hor_100 + nHora100 )
              dbunlock ()
            endif
          endif
        else
          select( cHrTrTMP )
          if AdiReg()
            replace Repr        with CaTeARQ->Repr
            replace Nome        with ReprARQ->Nome
            replace Data        with CaTeARQ->Data
            replace OrdS        with CaTeARQ->OrdS
            replace Inicio      with CaTeARQ->HoraIni
            replace Final       with CaTeARQ->HoraFin
            replace Hor_nor     with nHoraNor
            replace Hor_50      with nHora050
            replace Hor_100     with nHora100
            dbunlock ()
          endif
        endif
        select CaTeARQ
      endif
                
      dbskip ()
    enddo

    nGerNor := nGer050 := nGer100 := nGerTot := 0
    nValNor := nVal050 := nVal100 := nValTot := 0

    select( cHrTrTMP )
    if nTipo == 2
      set relation to OrdS into AbosARQ
    endif
    dbgotop ()
    
    if !eof()
      nPag    := 1
      nLin    := 0
      cRepr   := space(04)
      cArqu2  := cArqu2 + "." + strzero( nPag, 3 )
  
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
    endif  

    do while ! eof()
      if nLin == 0
        Cabecalho( 'Horas Trabalhada', 132, 3 )
        CabHrTr (nTipo)
      endif

      nTotal := ( Hor_Nor + Hor_50 + Hor_100 )

      if nTipo == 1
        @ nLin,001 say Repr
        @ nLin,008 say Nome
        @ nLin,055 say Hor_Nor     pict '9999.99'
        @ nLin,066 say Hor_50      pict '9999.99'
        @ nLin,078 say Hor_100     pict '9999.99'
        @ nLin,089 say nTotal      pict '9999.99'
      else
        if cRepr != Repr
          if nGerTot != 0
            nLin ++
            @ nLin,075 say 'Total em Horas'
            @ nLin,092 say nGerNor       pict '9999.99'
            @ nLin,103 say nGer050       pict '9999.99'
            @ nLin,114 say nGer100       pict '9999.99'
            @ nLin,125 say nGerTot       pict '9999.99'
            nLin ++
            @ nLin,073 say 'Total em Valores'
            @ nLin,089 say nValNor                       pict '999,999.99'
            @ nLin,100 say nVal050                       pict '999,999.99'
            @ nLin,111 say nVal100                       pict '999,999.99'
            @ nLin,122 say nValNor + nVal050 + nVal100   pict '999,999.99'
            
            Rodape(132) 

            cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
            cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

            set printer to ( cArqu2 )
            set printer on
            
            Cabecalho( 'Horas Trabalhada', 132, 3 )
            CabHrTr (nTipo)
            
            nGerNor := nGer050 := nGer100 := nGerTot := 0
            nValNor := nVal050 := nVal100 := 0
          endif

          cRepr := Repr

          @ nLin,01 say Repr
          @ nLin,06 say Nome
          nlin ++
        endif

        select AbOSARQ
        set order to 1
        dbseek( &cHrTrTMP->OrdS, .f. )

        select( cHrTrTMP )
     
        @ nLin,006 say OrdS          pict '999999'
        @ nLin,013 say AbOSARQ->Emis pict '99/99/99'
        @ nLin,024 say AbOSARQ->Apa1 pict '@S36'
        @ nLin,062 say Data          pict '99/99/99'
        @ nLin,073 say Inicio        pict '99:99'
        @ nLin,081 say Final         pict '99:99'
        @ nLin,092 say Hor_Nor       pict '9999.99'
        @ nLin,103 say Hor_50        pict '9999.99'
        @ nLin,114 say Hor_100       pict '9999.99'
        @ nLin,125 say nTotal        pict '9999.99'
      endif

      nGerNor += Hor_Nor 
      nGer050 += Hor_50
      nGer100 += Hor_100
      nGerTot += ( Hor_Nor + Hor_50 + Hor_100 ) 
      nLin    ++
      
      BuscaHrVa( Data, cRepr )
      
      select( cHrTrTMP )

      nValNor += ( Hor_Nor * TbFnARQ->HHNor )
      nVal050 += ( Hor_50 * TbFnARQ->HH50 )
      nVal100 += ( Hor_100 * TbFnARQ->HH100 )

      if nLin >= pLimite
        Rodape(132) 

        cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
        cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

        set printer to ( cArqu2 )
        set printer on
      endif

      select( cHrTrTMP )
      dbskip ()
    enddo
    
    dbgotop()

    if !eof()
      if nTipo == 1
        if nGerTot > 0
          nLin ++
          @ nLin,037 say 'Total em Horas'
          @ nLin,055 say nGerNor       pict '9999.99'
          @ nLin,066 say nGer050       pict '9999.99'
          @ nLin,078 say nGer100       pict '9999.99'
          @ nLin,089 say nGerTot       pict '9999.99'
          nLin ++
          @ nLin,035 say 'Total em Valores'
          @ nLin,052 say nValNor                       pict '999,999.99'
          @ nLin,063 say nVal050                       pict '999,999.99'
          @ nLin,075 say nVal100                       pict '999,999.99'
          @ nLin,086 say nValNor + nVal050 + nVal100   pict '999,999.99'
        endif  
      else
        if nGerTot > 0
          nLin ++
          @ nLin,075 say 'Total em Horas'
          @ nLin,092 say nGerNor       pict '9999.99'
          @ nLin,103 say nGer050       pict '9999.99'
          @ nLin,114 say nGer100       pict '9999.99'
          @ nLin,125 say nGerTot       pict '9999.99'
          nLin ++
          @ nLin,073 say 'Total em Valores'
          @ nLin,089 say nValNor                       pict '999,999.99'
          @ nLin,100 say nVal050                       pict '999,999.99'
          @ nLin,111 say nVal100                       pict '999,999.99'
          @ nLin,122 say nValNor + nVal050 + nVal100   pict '999,999.99'
        endif  
      endif
    
      Rodape(132)
    endif

    if nTipo == 2
      set relation to
    endif

    close

    ferase( cHrTrARQ )
    ferase( cHrTrIND1 )

    set printer to
    set printer off

    set device to screen
    
    if Imprimir( cArqu3, 132 ) 
      select SpooARQ
      if AdiReg()
        replace Rela       with cArqu3
        replace Titu       with "Horas Trabalhada " + dtoc( dEmisIni ) + " - " + dtoc( dEmisFin )
        replace Data       with cRData
        replace Hora       with cRHora
        replace Usua       with cUsuario
        replace Tama       with 132
        replace Empr       with cEmpresa
        dbunlock ()
      endif  
      close
    endif
    exit
  enddo
    
  select AbosARQ
  close
  select CaTeARQ
  close
  select ReprARQ
  close
  select TbFnARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL
       
function CabHrTr (nTipo)        
  @ 02,01 say 'Data '+ dtoc( dEmisIni ) + ' a ' + dtoc( dEmisFin )
  if nTipo == 1
    @ 03,01 say 'Cod   Funcionario                               Hrs. Normais  Hrs. 50 %  Hrs. 100 %      Total'
    
    nLin := 5
  else
    @ 03,01 say 'Cod   Funcionario'
    @ 04,01 say '     O.S.   Emissão    Equipamento                           Data     Hr.Ini. Hr.Fin. Hrs. Normais   Hrs. 50%  Hrs. 100%      Total'
    
    nLin := 6
  endif
return NIL

//
//  Horas Parada
//
function PrinHrPa ()
  
  local cHrPaARQ  := CriaTemp( 0 )
  local cHrPaIND1 := CriaTemp( 1 )

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

  if NetUse( "PaMaARQ", .t. )
    VerifIND( "PaMaARQ" )

    #ifdef DBF_NTX 
      set index to PaMaIND1, PaMaIND2
    #endif  
  endif

  if NetUse( "AbOSARQ", .t. )
    VerifIND( "AbOSARQ" )

    #ifdef DBF_NTX 
      set index to AbOSIND1, AbOSIND2
    #endif  
  endif

  if NetUse( "TbFnARQ", .t. )
    VerifIND( "TbFnARQ" )

    #ifdef DBF_NTX 
      set index to TbFnIND1
    #endif  
  endif

  if NetUse( "CaTeARQ", .t. )
    VerifIND( "CaTeARQ" )

    #ifdef DBF_NTX 
      set index to CaTeIND1, CaTeIND2
    #endif  
  endif
 
  tPrt  := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela( 06, 08, 14, 73, mensagem( 'Janela', 'PrinHrPa', .f. ), .f. )

  setcolor( CorJanel + ',' + CorCampo )
  @ 08,10 say 'Ordem Serviço Inicial            Ordem Serviço Final'           
  @ 09,10 say '         Data Inicial                     Data Final'
  @ 10,10 say '  Funcionário Inicial              Funcionário Final'
  @ 11,10 say '       Parada Inicial                   Parada Final'
  @ 13,10 say '                 Tipo'
  
  do while .t.
    setcolor( CorCampo )
    @ 13,32 say ' Quantitativo '
    @ 13,47 say ' Descriminado '
    
    setcolor( CorAltKC )
    @ 13,33 say 'Q'
    @ 13,48 say 'D'
  
    select PaMaARQ
    set order to 1
    dbgotop ()
    nPaMaIni := val( PaMa )
    dbgobottom ()
    nPaMaFin := val( PaMa )
  
    select ReprARQ
    set order to 1
    dbgotop ()
    nReprIni := val( Repr )
    dbgobottom ()
    nReprFin := val( Repr )
    
    select AbOSARQ
    set order to 1
    dbgotop ()
    nOrdSIni := val( OrdS )
    dEmisIni := ctod('01/01/1990')
    dbgobottom ()
    nOrdSFin := val( OrdS )
    dEmisFin := ctod('31/12/2015')
    nTipo    := 1
    aTipo    := {}
    aArqui   := {}

    aadd( aTipo, { ' Quantitativo ', 2, 'Q', 13, 32, "Relatório Quantitativo." } )
    aadd( aTipo, { ' Descriminado ', 2, 'D', 13, 47, "Relatório Descriminado." } )

    setcolor( CorJanel + ',' + CorCampo )
    @ 08,32 get nOrdSIni      pict '999999'
    @ 08,63 get nOrdSFin      pict '999999'      valid nOrdSFin >= nOrdSIni
    @ 09,32 get dEmisIni      pict '99/99/99'
    @ 09,63 get dEmisFin      pict '99/99/99'    valid dEmisFin >= dEmisIni
    @ 10,32 get nReprIni      pict '999999'        valid ValidARQ( 99, 99, "AbOSARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprIni", .t., 6, "Consulta de Funcionários", "ReprARQ", 30 ) 
    @ 10,63 get nReprFin      pict '999999'        valid ValidARQ( 99, 99, "AbOSARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprFin", .t., 6, "Consulta de Funcionários", "ReprARQ", 30 ) .and. nReprFin >= nReprIni
    @ 11,32 get nPaMaIni      pict '9999'        valid nPamaIni == 0 .or. ValidARQ( 99, 99, "AbOSARQ", "Código" , "PaMa", "Descrição", "Nome", "PaMa", "nPaMaIni", .t., 4, "Consulta de Paradas", "PaMaARQ", 30 )
    @ 11,63 get nPaMaFin      pict '9999'        valid nPamaFin == 0 .or. ValidARQ( 99, 99, "AbOSARQ", "Código" , "PaMa", "Descrição", "Nome", "PaMa", "nPaMaFin", .t., 4, "Consulta de Paradas", "PaMaARQ", 30 ) .and. nPaMaFin >= nPaMaIni
    read

    if lastkey() == K_ESC
      exit
    endif
    
    nTipo := HCHOICE( aTipo, 2, nTipo )

    if lastkey() == K_ESC .or. empty( dEmisIni )
      exit
    endif
    
    Aguarde ()

    if nTipo == 1
      aadd( aArqui, { "NomeRepr",  "C", 040, 0 } )
      aadd( aArqui, { "Repr",      "C", 006, 0 } )
      aadd( aArqui, { "NomePaMa",  "C", 040, 0 } )
      aadd( aArqui, { "PaMa",      "C", 004, 0 } )
      aadd( aArqui, { "Data",      "D", 008, 0 } )
      aadd( aArqui, { "Hor_Nor",   "N", 012, 2 } )
      aadd( aArqui, { "Hor_50",    "N", 012, 2 } )
      aadd( aArqui, { "Hor_100",   "N", 012, 2 } )

      cChave := "NomeRepr + Repr"
    else
      aadd( aArqui, { "NomeRepr",  "C", 040, 0 } )
      aadd( aArqui, { "Repr",      "C", 006, 0 } )
      aadd( aArqui, { "NomePaMa",  "C", 040, 0 } )
      aadd( aArqui, { "PaMa",      "C", 006, 0 } )
      aadd( aArqui, { "Data",      "D", 008, 0 } )
      aadd( aArqui, { "OrdS",      "C", 006, 0 } )
      aadd( aArqui, { "Inicio",    "C", 005, 0 } )
      aadd( aArqui, { "Final",     "C", 005, 0 } )
      aadd( aArqui, { "Hor_Nor",   "N", 012, 2 } )
      aadd( aArqui, { "Hor_50",    "N", 012, 2 } )
      aadd( aArqui, { "Hor_100",   "N", 012, 2 } )
 
      cChave := "NomeRepr + Repr + dtos( Data ) + OrdS + Inicio + Final"
    endif
 
    dbcreate( cHrPaARQ, aArqui )
   
    if NetUse( cHrPaARQ, .f., 30 )
      cHrPaTMP := alias ()
    
      index on &cChave to &cHrPaIND1

      set index to &cHrPaIND1
    endif
    
    cPaMaIni := strzero( nPaMaIni, 6 )
    cPaMaFin := strzero( nPaMaFin, 6 )
    cReprIni := strzero( nReprIni, 6 )
    cReprFin := strzero( nReprFin, 6 )

    select CaTeARQ
    set order    to 2
    set relation to Repr into ReprARQ, OrdS into AbosARQ, PaMa into PaMaARQ
    dbseek( cReprIni, .t. )
    do while Repr >= cReprIni .and. Repr <= cReprFin .and. !eof()
      if Data >= dEmisIni .and. Data <= dEmisFin .and.;   
        PaMa >= cPaMaIni .and. PaMa <= cPaMaFin 
    
        dData    := Data
        cHoraIni := HoraIni
        cHoraFin := HoraFin

        cTempo   := sectotime( timetosec( cHoraFin ) - timetosec( cHoraIni ) )
        nDia     := dow( dData )

        do case
          case nDia == 1;          cMes := 'Dom'
          case nDia == 2;          cMes := 'Seg'
          case nDia == 3;          cMes := 'Ter'
          case nDia == 4;          cMes := 'Qua'
          case nDia == 5;          cMes := 'Qui'
          case nDia == 6;          cMes := 'Sex'
          case nDia == 7;          cMes := 'Sab'
        endcase

        select ReprARQ

        cHorIniTur := &( cMes+'IniTur' )
        cHorTerTur := &( cMes+'TerTur' )
        cHorIniAlm := &( cMes+'IniAlm' )
        cHorTerAlm := &( cMes+'TerAlm' )

        nHoraNor   := nHora050 := nHora100 := 0

        nTempo     := val( substr( cTempo, 1, 2 ) + '.' + substr( cTempo, 4, 2 ) )
        cHoraAntes := sectotime( timetosec( cHorIniTur ) - timetosec( '02:00' ) )
        cHoraDepoi := sectotime( timetosec( cHorTerTur ) + timetosec( '02:00' ) )

        VerCate()
  
        nHoraNor := ValidMin( nHoraNor )
        nHora050 := ValidMin( nHora050 )
        nHora100 := ValidMin( nHora100 )

        if nTipo == 1
          select( cHrPaTMP )
          set order to 1
          dbseek( ReprARQ->Nome + CaTeARQ->Repr, .f. )
          if eof()
            if AdiReg()
              replace Repr        with CaTeARQ->Repr
              replace NomeRepr    with ReprARQ->Nome
              replace PaMa        with CaTeARQ->PaMa
              replace NomePaMa    with PaMaARQ->Nome
              replace Data        with CaTeARQ->Data
              replace Hor_nor     with nHoraNor
              replace Hor_50      with nHora050
              replace Hor_100     with nHora100
             dbunlock ()
            endif
          else
            if RegLock()
              replace Hor_nor     with ( Hor_Nor + nHoraNor )
              replace Hor_50      with ( Hor_50 + nHora050 )
              replace Hor_100     with ( Hor_100 + nHora100 )
              dbunlock ()
            endif
          endif
        else
          select( cHrPaTMP )
          if AdiReg()
            replace Repr        with CaTeARQ->Repr
            replace NomeRepr    with ReprARQ->Nome
            replace PaMa        with CaTeARQ->PaMa
            replace NomePaMa    with PaMaARQ->Nome
            replace Data        with CaTeARQ->Data
            replace OrdS        with CaTeARQ->OrdS
            replace Inicio      with CaTeARQ->HoraIni
            replace Final       with CaTeARQ->HoraFin
            replace Hor_nor     with nHoraNor
            replace Hor_50      with nHora050
            replace Hor_100     with nHora100
            dbunlock ()
          endif
        endif
        select CaTeARQ
      endif     
      
      dbskip ()
    enddo

    nGerNor := nGer050 := nGer100 := nGerTot := 0
    nValNor := nVal050 := nVal100 := nValTot := 0

    select( cHrPaTMP )
    if nTipo == 2
      set relation to OrdS into AbosARQ
    endif
    dbgotop ()
     
    if !eof()
      nPag    := 1
      nLin    := 0
      cRepr   := space(04)
      cArqu2  := cArqu2 + "." + strzero( nPag, 3 )
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
    endif  
    
    do while ! eof()
      if nLin == 0
        Cabecalho( 'Horas Parada', 132, 3 )
        CabHrPa (nTipo)
      endif

      nTotal := ( Hor_Nor + Hor_50 + Hor_100 )

      if nTipo == 1
        @ nLin,001 say Repr
        @ nLin,008 say NomeRepr    pict '@S28' 
        @ nLin,037 say NomePaMa    pict '@S30' 
        @ nLin,068 say PaMa
        @ nLin,092 say Hor_Nor     pict '9999.99'
        @ nLin,103 say Hor_50      pict '9999.99'
        @ nLin,114 say Hor_100     pict '9999.99'
        @ nLin,125 say nTotal      pict '9999.99'
      else
        if cRepr != Repr
          if nGerTot != 0
            nLin ++
            @ nLin,075 say 'Total em Horas'
            @ nLin,092 say nGerNor       pict '9999.99'
            @ nLin,103 say nGer050       pict '9999.99'
            @ nLin,114 say nGer100       pict '9999.99'
            @ nLin,125 say nGerTot       pict '9999.99'
            nLin ++
            @ nLin,073 say 'Total em Valores'
            @ nLin,089 say nValNor                       pict '999,999.99'
            @ nLin,100 say nVal050                       pict '999,999.99'
            @ nLin,111 say nVal100                       pict '999,999.99'
            @ nLin,122 say nValNor + nVal050 + nVal100   pict '999,999.99'
            
            Rodape(132) 

            cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
            cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

            set printer to ( cArqu2 )
            set printer on
            
            Cabecalho( 'Horas Parada', 132, 3 )
            CabHrPa (nTipo)
            
            nGerNor := nGer050 := nGer100 := nGerTot := 0
            nValNor := nVal050 := nVal100 := 0
          endif

          cRepr := Repr

          @ nLin,01 say Repr
          @ nLin,08 say NomeRepr
          nlin ++
        endif

        select AbOSARQ
        set order to 1
        dbseek( &cHrPaTMP->OrdS, .f. )

        select( cHrPaTMP )

        @ nLin,006 say OrdS          pict '999999'
        @ nLin,013 say AbOSARQ->Emis pict '99/99/99'
        @ nLin,024 say AbOSARQ->Apa1 pict '@S18'
        @ nLin,048 say Data          pict '99/99/99'
        @ nLin,059 say NomePaMa      pict '@S10'
        @ nLin,070 say PaMa          pict '9999'
        @ nLin,076 say Inicio        pict '99:99'
        @ nLin,084 say Final         pict '99:99'
        @ nLin,092 say Hor_Nor       pict '9999.99'
        @ nLin,103 say Hor_50        pict '9999.99'
        @ nLin,114 say Hor_100       pict '9999.99'
        @ nLin,125 say nTotal        pict '9999.99'
      endif

      nGerNor += Hor_Nor 
      nGer050 += Hor_50
      nGer100 += Hor_100
      nGerTot += ( Hor_Nor + Hor_50 + Hor_100 ) 
      nLin    ++
      
      BuscaHrVa( Data, cRepr )
      
      select( cHrPaTMP )

      nValNor += ( Hor_Nor * TbFnARQ->HHNor )
      nVal050 += ( Hor_50 * TbFnARQ->HH50 )
      nVal100 += ( Hor_100 * TbFnARQ->HH100 )

      if nLin >= pLimite
        Rodape(132) 

        cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
        cArqu2 := cArqu2 + "." + strzero( nPag, 3 )
 
        set printer to ( cArqu2 )
        set printer on
      endif

      select( cHrPaTMP )
      dbskip ()
    enddo
    
    dbgotop()

    if !eof ()
      if nGerTot > 0
        nLin ++
        @ nLin,075 say 'Total em Horas'
        @ nLin,092 say nGerNor       pict '9999.99'
        @ nLin,103 say nGer050       pict '9999.99'
        @ nLin,114 say nGer100       pict '9999.99'
        @ nLin,125 say nGerTot       pict '9999.99'
        nLin ++
        @ nLin,073 say 'Total em Valores'
        @ nLin,089 say nValNor                       pict '999,999.99'
        @ nLin,100 say nVal050                       pict '999,999.99'
        @ nLin,111 say nVal100                       pict '999,999.99'
        @ nLin,122 say nValNor + nVal050 + nVal100   pict '999,999.99'
      endif  

      Rodape(132)
    endif  

    if nTipo == 2
      set relation to
    endif

    close

    ferase( cHrPaARQ )
    ferase( cHrPaIND1 )

    set printer to
    set printer off

    set device to screen
    
    if Imprimir( cArqu3, 132 ) 
      select SpooARQ
      if AdiReg()
        replace Rela       with cArqu3
        replace Titu       with "Horas Parada " + dtoc( dEmisIni ) + " - " + dtoc( dEmisFin )
        replace Data       with cRData
        replace Hora       with cRHora
        replace Usua       with cUsuario
        replace Tama       with 132
        replace Empr       with cEmpresa
        dbunlock ()
      endif  
      close
    endif
    exit
  enddo
  
  select PaMaARQ
  close
  select AbosARQ
  close
  select CaTeARQ
  close
  select ReprARQ
  close
  select TbFnARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL
       
function CabHrPa (nTipo)        
  @ 02,01 say 'Data '+ dtoc( dEmisIni ) + ' a ' + dtoc( dEmisFin )
  if nTipo == 1
    @ 03,01 say 'Cod   Funcionário                  Parada                                            Hrs. Normais   Hrs. 50%  Hrs. 100%      Total'
    
    nLin := 5
  else
    @ 03,01 say 'Cod   Funcionário'
    @ 04,01 say '     O.S.   Emissão    Equipamento             Data       Parada         Hr.Ini. Hr.Fin. Hrs. Nor.   Hrs. 50%  Hrs. 100%      Total'

    nLin := 6
  endif
return NIL

//
//  Consulta de OS Encerradas e nao Faturadas
//
function ConsOSFat ()

  local cCorAtual := setcolor()
  local GetList   := {}

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )
  
    tOpenClie := .t.

    #ifdef DBF_NTX 
      set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
    #endif  
  else
    tOpenClie := .f.  
  endif

  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )

    tOpenProd := .t.
  
    #ifdef DBF_NTX 
      set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
    #endif  
  else  
    tOpenProd := .f.
  endif
  
  if NetUse( "EnOSARQ", .t. )
    VerifIND( "EnOSARQ" )
   
    tOpenEnOS := .t.

    #ifdef DBF_NTX 
      set index to EnOSIND1, EnOSIND2, EnOSIND3
    #endif  
  else
    tOpenEnOS := .f.
  endif
  
  if NetUse( "AbOSARQ", .t. )
    VerifIND( "AbOSARQ" )
   
    tOpenAbOS := .t.

    #ifdef DBF_NTX 
      set index to AbOSIND1, AbOSIND2, AbOSIND3
    #endif  
  else
    tOpenAbOS := .f.
  endif

  if NetUse( "ItOSARQ", .t. )
    VerifIND( "ItOSARQ" )
  
    tOpenItOS := .t.
  
    #ifdef DBF_NTX 
      set index to ItOSIND1
    #endif  
  else 
    tOpenItOS := .f.  
  endif

  if NetUse( "ReprARQ", .t. )
    VerifIND( "ReprARQ" )
  
    tOpenRepr := .t.

    #ifdef DBF_NTX 
      set index to ReprIND1, ReprIND2
    #endif  
  else
    tOpenRepr := .f.
  endif
 
  tTelaOS := savescreen( 00, 00, 23, 79 )

  nAberta := 0
  lOkey   := .f.
  
  select AbOSARQ
  set order    to 1
  
  select EnOSARQ
  set order    to 3
  set relation to Repr into ReprARQ, to Clie into ClieARQ
  dbgotop()
  do while !eof()
    if !Receber     
      nAberta ++
    endif  
    dbskip ()
  enddo
  
  if nAberta == 0
    Alerta( mensagem(  'Alerta', 'ConsEnOS', .f. ) )
    
    lOkey := .t.
  endif 
  
  if lOkey
    restscreen( 00, 00, 23, 79, tTelaOS ) 
    if tOpenProd
      select ProdARQ
      close
    endif  
    if tOpenAbOS 
      select AbOSARQ
      close
    endif  
    if tOpenEnOS 
      select EnOSARQ
      close
    endif  
    if tOpenRepr 
      select ReprARQ
      close
    endif  
    if tOpenClie 
      select ClieARQ
      close
    endif  
    return NIL
  endif

  Janela ( 03, 01, 20, 76, mensagem( 'Janela', 'ConsOSFat', .f. ), .f. )

  bFirst := {|| dbseek( .f., .t. ) }
  bLast  := {|| dbseek( .f., .t. ), dbskip(-1) }
  bFor   := {|| Receber == .f. }
  bWhile := {|| Receber == .f. }
  
  oOrdem           := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oOrdem:nTop      := 5
  oOrdem:nLeft     := 2
  oOrdem:nBottom   := 20
  oOrdem:nRight    := 75
  oOrdem:headsep   := chr(194)+chr(196)
  oOrdem:colsep    := chr(179)
  oOrdem:footsep   := chr(193)+chr(196)
  oOrdem:colorSpec := CorJanel

  oOrdem:addColumn( TBColumnNew("N. OS",      {|| VerEnOS() } ) )
  oOrdem:addColumn( TBColumnNew("Emissão",    {|| AbOSARQ->Emis } ) )
  oOrdem:addColumn( TBColumnNew("Cliente",    {|| left( ClieARQ->Nome, 14 ) } ) )

  do case
    case EmprARQ->TipoOS == 1
      oOrdem:addColumn( TBColumnNew("Equipamento",{|| left( AbOSARQ->Apa1, 15 ) } ) )
    case EmprARQ->TipoOS == 2
      oOrdem:addColumn( TBColumnNew("Veículo",    {|| left( AbOSARQ->Veic, 15 ) } ) )
    case EmprARQ->TipoOS == 3
      oOrdem:addColumn( TBColumnNew("Descrição",  {|| left( AbOSARQ->Apa1, 15 ) } ) )
  endcase    

  oOrdem:addColumn( TBColumnNew("Término",    {|| Term } ) )
  oOrdem:addColumn( TBColumnNew("Hora",       {|| HoraTerm } ) )

  if EmprARQ->TipoOS == 2
    oOrdem:addColumn( TBColumnNew("Placa",      {|| AbOSARQ->Placa } ) )
    oOrdem:addColumn( TBColumnNew("KM",         {|| transform( AbOSARQ->KM, '@E 99999,999.9' ) } ) )
  endif  

  oOrdem:addColumn( TBColumnNew("Valor",      {|| transform( TotalNota, "@E 9,999.99" ) } ) )
  oOrdem:addColumn( TBColumnNew("Observação", {|| left( Obse, 20 ) } ) )
  oOrdem:addColumn( TBColumnNew("Emitente",   {|| left( ReprARQ->Nome, 20 ) + ' ' + Repr } ) )
              
  lAdiciona      := .f.
  lVez           := .t.
  lExitRequested := .f.
  nLinBarra      := 1
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 6, 20, 76, nTotal )
  
  oOrdem:refreshAll()
  
  setcolor( CorJanel )
  @ 06,01 say chr(195)
  @ 06,76 say chr(180)

  do while !lExitRequested
    Mensagem( '<ALT+F> Faturar, <ESC> Retornar' )
    
    oOrdem:forcestable() 

    iif( BarraSeta, BarraSeta( nLinBarra, 6, 20, 76, nTotal ), NIL )
    
    if oOrdem:stable
      if oOrdem:hitTop .or. oOrdem:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    else
      loop  
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oOrdem:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oOrdem:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oOrdem:down()
      case cTecla == K_UP;         oOrdem:up()
      case cTecla == K_PGDN;       oOrdem:pageDown()
      case cTecla == K_PGUP;       oOrdem:pageUp()
      case cTecla == K_CTRL_PGUP;  oOrdem:goTop()
      case cTecla == K_CTRL_PGDN;  oOrdem:gobottom()
      case cTecla == K_LEFT;       oOrdem:left()
      case cTecla == K_RIGHT;      oOrdem:right()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_ENTER;      lExitRequested := .t.
      case cTecla == K_ALT_F
        tAlteOS := savescreen( 00, 00, 23, 79 )
        
        Janela( 09, 22, 12, 50, mensagem( 'Janela', 'ConsOSFat1', .f. ), .f. )
        setcolor( CorJanel )
        @ 11,24 say 'Imprimir'
        lPrinFatu := ConfLine( 11, 33, 1 )
        
        if lPrinFatu
          ImprEnOs ()
        endif  
          
        if lPrinFatu .and. lastkey() != K_ESC
          select ReceARQ
          set order to 1
          for nL := 1 to 9
            cParc   := str( nL, 1 )
            cParce  := strzero( nL, 2 )
            cOrdSPg := cOrdS + cParce

            dbseek( cOrdSPg + 'O', .f. )
            if nValor&cParc == 0
              if ! eof ()    
                if RegLock()
                  dbdelete ()
                  dbunlock ()
                endif  
              endif
            else
              if eof () 
                if AdiReg()
                  if RegLock()
                    replace Nota  with cOrdSPg
                    replace Tipo  with 'O'
                    dbunlock ()
                  endif
                endif  
              endif
 
              if RegLock()
                replace Clie     with cClie
                replace Cliente  with AbOSARQ->Cliente
                replace Emis     with dTerm
                replace Vcto     with dVcto&cParc
                replace Valor    with nValor&cParc
                replace Acre     with EmprARQ->Taxa 
                if dVcto&cParc == dTerm
                  replace Pgto   with dVcto&cParc
                  replace Pago   with nValor&cParc
                else
                  replace Pgto   with ctod('  /  /  ')  
                  replace Pago   with 0
                  replace Juro   with 0
                endif  
                replace Repr     with cRepr
                replace Port     with cPort
                replace ReprComi with nComis&cParc
                dbunlock ()
              endif
            endif
          next  
        endif  
        
        if lastkey() != K_ESC
          select EnOSARQ
          if RegLock()
            replace Receber      with .t.
            dbunlock()
          endif  
        endif    
      
        restscreen( 00, 00, 23, 79, tAlteOS )
        
        select EnOsARQ
        set order to 3

        dbseek( .f., .t. )     
        oOrdem:refreshAll()
        oOrdem:forcestable() 
    endcase
  enddo  
  
  if tOpenEnOS 
    select EnOSARQ
    close
  endif  
  if tOpenAbOS 
    select AbOSARQ
    close
  endif  
  if tOpenProd
    select ProdARQ
    close
  endif  
  if tOpenRepr 
    select ReprARQ
    close
  endif  
  if tOpenClie
    select ClieARQ
    close
  endif  
  
  setcolor( cCorAtual )
  restscreen( 00, 00, 23, 79, tTelaOS )
return NIL

function VerEnOS()
 AbOSARQ->(dbseek(EnOSARQ->OrdS,.f.))
return( OrdS )