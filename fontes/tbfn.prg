//  Leve, Tabela de Valores das Horas
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

function TbFn ()

if NetUse( "ReprARQ", .t. )
  VerifIND( "ReprARQ" )
  
  lOpenRepr := .t.
  
  #ifdef DBF_NTX
    set index to ReprIND1, ReprIND2
  #endif
else
  lOpenRepr := .f.  
endif

if NetUse( "TbFnARQ", .t. )
  VerifIND( "TbFnARQ" )
  
  lOpenTbFn := .t.

  #ifdef DBF_NTX
    set index to TbFnIND1
  #endif
else
  lOpenTbFn := .f.  
endif

//  Variaveis de Entrada 
cRepr     := cData     := space(06)
nRepr     := 0
nData     := nHHNormal := 0
nHH50     := nHH100    := 0

aOpcoes   := {}
aArqui    := {}
cTbFnARQ  := CriaTemp(0)
cTbFnIND1 := CriaTemp(1)
cChave    := "Sequ"

aadd( aArqui, { "Sequ",      "C", 006, 0 } )
aadd( aArqui, { "Data",      "C", 004, 0 } )
aadd( aArqui, { "HHNor",     "N", 012, 2 } )
aadd( aArqui, { "HH50",      "N", 012, 2 } )
aadd( aArqui, { "HH100",     "N", 012, 2 } )
aadd( aArqui, { "Regi",      "N", 008, 0 } )
aadd( aArqui, { "Novo",      "L", 001, 0 } )
aadd( aArqui, { "Lixo",      "L", 001, 0 } )

dbcreate( cTbFnARQ, aArqui )
   
if NetUse( cTbFnARQ, .f., 30 )
  cTbFnTMP := alias ()
    
  index on &cChave to &cTbFnIND1

  set index to &cTbFnIND1
endif

//  Tela Aluno
Janela( 04, 15, 20, 65, mensagem( 'Janela', 'TbHr', .f. ), .f. )

setcolor ( CorJanel )
@ 06,17 say 'Vendedor'
@ 08,20 say 'Mês/Ano Hora-Normal Hora-50 %  Hora-100 %'

@ 09,15 say chr(195) + replicate( chr(196), 49 ) + chr(180) 
@ 18,15 say chr(195) + replicate( chr(196), 49 ) + chr(180)
      
@ 09,27 say chr(194)
@ 09,39 say chr(194)
@ 09,50 say chr(194)

for nU := 10 to 17
  @ nU,27 say chr(179)
  @ nU,39 say chr(179)
  @ nU,50 say chr(179)
next  

@ 18,27 say chr(193)
@ 18,39 say chr(193)
@ 18,50 say chr(193)
 
MostOpcao( 19, 17, 29, 41, 54 )
tNotas := savescreen( 00, 00, 23, 79 )

select TbFnARQ
set order to 1
dbgobottom ()
do while .t.
  select( cTbFnTMP )
  set order to 1
  zap
  
  select TbFnARQ
  set order    to 1
  set relation to Repr into ReprARQ

  restscreen( 00, 00, 23, 79, tNotas )
  cStat := space(04)
  
  if Demo ()
    exit
  endif  

  Mensagem( 'TbFn','Janela')
  
  MostTbFn ()

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostTbFn'
  cAjuda   := 'TbFn'
  lAjud    := .f.

  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  @ 06,26 get nRepr         pict '999999'  valid ValidARQ( 06, 26, "TbFnARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nRepr", .t., 6, "Vendedores", "ReprARQ", 30 )
  read

  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC  
    exit
  endif
  
  cRepr := strzero( nRepr, 6 )
  
  //  Verificar existencia das Dados para Incluir ou Alterar
  select TbFnARQ
  set order to 1
  dbseek( cRepr, .f. )

  if Repr == cRepr
    cStat := 'alte'
  else  
    cStat := 'incl'
  endif  
  
  do while !eof() .and. Repr == cRepr
    nRegi := recno()

    select( cTbFnTMP )
    if AdiReg()
      if Reglock(30)
        replace Sequ     with TbFnARQ->Sequ
        replace Data     with TbFnARQ->Data
        replace HHNor    with TbFnARQ->HHNor  
        replace HH50     with TbFnARQ->HH50   
        replace HH100    with TbFnARQ->HH100
        replace Regi     with nRegi
        replace Novo     with .f.
        replace Lixo     with .f.
        dbunlock ()
      endif  
    endif  

    select TbFnARQ
    dbskip ()
  enddo
  
  EntrTbFn ()
  
  Confirmar( 19, 17, 29, 41, 54, 3 )
  
  if cStat == 'loop' .or. lastkey() == K_ESC
    loop
  endif  
  
  if cStat == 'prin'
    Alerta( mensagem( 'Alerta', 'PrinTbHr', .f. ) ) 
  endif
    
  if cStat == 'excl'
    if ExclRegi()
      select TbFnARQ
      set order to 1
      dbseek( cRepr, .t. )
      do while Repr == cRepr .and. !eof ()
        if RegLock()
          dbdelete ()
          dbunlock ()
        endif
        dbskip ()
      enddo
    endif 
  endif
  
  GravTbFn ()
    
  select TbFnARQ
enddo

if lOpenTbFn
  select TbFnARQ
  close
endif

if lOpenRepr  
  select ReprARQ
  close
endif  

return NIL

// 
// Entra com as dados
//
function EntrTbFn()

  select( cTbFnTMP )
  set order to 1 
  
  oColuna         := TBrowseDB( 08, 20, 18, 60 )
  oColuna:colsep  := chr(179)
  oColuna:headsep := chr(194)+chr(196)
  oColuna:footsep := chr(193)+chr(196)

  oColuna:addColumn( TBColumnNew("Mês/Ano",     {|| substr( Data, 1, 2 ) + '/' + substr( Data, 3, 2 ) } ) )
  oColuna:addColumn( TBColumnNew("Hora-Normal", {|| transform( HHNor, '@E 999,999.99' ) } ) )
  oColuna:addColumn( TBColumnNew("Hora-50 %",   {|| transform( HH50,  '@E 999,999.99' ) } ) )
  oColuna:addColumn( TBColumnNew("Hora-100 %",  {|| transform( HH100, '@E 999,999.99' ) } ) )

  lExitRequested := .f.
  lAlterou       := .f.
  lAdiciona      := .f.
  cSequ          := space(04)
  nSequ          := 0

  oColuna:goBottom()

  do while !lExitRequested
    Mensagem( 'LEVE','Browse')

    oColuna:forcestable()
    
    if cStat == 'incl' .and. cSequ == space(04)
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
      case cTecla == K_ENTER
        if !empty( Sequ )
          lAdiciona := .f.

          ItenTbFn( lAdiciona, oColuna )
        endif  
      case cTecla == K_INS
        nRegi := recno ()

        dbgotop ()
        do while !eof ()
          cSequ := Sequ
          nSequ := val( Sequ )
        
          dbskip ()
        enddo   
          
        go nRegi
        
        do while lastkey() != K_ESC        
          lAdiciona := .t.
      
          ItenTbFn( lAdiciona, oColuna )
        enddo  
      case cTecla == K_PGDN;        oColuna:pageDown()
      case cTecla == K_CTRL_PGDN;   oColuna:goBottom()
      case cTecla == K_RIGHT;       oColuna:right()
      case cTecla == K_LEFT;        oColuna:left()
      case cTecla == K_HOME;        oColuna:home()
      case cTecla == K_END;         oColuna:end()
      case cTecla == K_CTRL_LEFT;   oColuna:panLeft()
      case cTecla == K_CTRL_RIGHT;  oColuna:panRight()
      case cTecla == K_CTRL_HOME;   oColuna:panHome()
      case cTecla == K_CTRL_END;    oColuna:panEnd()
      case cTecla == K_ESC
        if Saindo (lAlterou)
          lExitRequested := .t.
        else  
          lExitRequested := .f.
        endif  
      case cTecla == 46;            lExitRequested := .t.
      case cTecla == K_DEL
        if !empty( Data )
          if RegLock ()
            dbdelete ()
            dbunlock ()

            oColuna:refreshAll()
            oColuna:gobottom()
          endif
        endif
    endcase
  enddo
return NIL  

//
// Entra intens da nota
//
function ItenTbFn( lAdiciona, oColuna)

  if lAdiciona 
    cSequ := strzero( nSequ + 1, 4 )

    if AdiReg()
      if RegLock()
        replace Sequ            with cSequ
        replace Novo            with .t.
        replace Lixo            with .f.
        dbunlock ()
      endif
    endif    

    oColuna:goBottom() 
    oColuna:refreshAll()  

    oColuna:forcestable()

    Mensagem( 'PedF', 'InclIten')
  else
    Mensagem( 'PedF', 'AlteIten')
  endif

  cSequ     := Sequ
  nSequ     := val( Sequ )
  cData     := Data
  nData     := val( Data )
  nHHNor    := HHNor
  nHH50     := HH50
  nHH100    := HH100
  nLin      := 09 + oColuna:rowPos

  setcolor ( CorJanel + ',' + CorCampo )
  @ nLin, 20 get nData         pict '99/99'         valid ValidData( nData )
  @ nLin, 28 get nHHNor        pict '@E 999,999.99' valid !empty( nHHNor )
  @ nLin, 40 get nHH50         pict '@E 999,999.99' valid !empty( nHH50 )
  @ nLin, 51 get nHH100        pict '@E 999,999.99' valid !empty( nHH100 )
  read

  cTecla := lastkey()

  if cTecla == K_ESC
    if lAdiciona
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif  
    endif  

    oColuna:refreshAll()  
    return NIL
  endif  
  
  if cTecla == K_UP .or. cTecla == K_DOWN .or. cTecla == K_PGUP .or. cTecla == K_PGDN
    keyboard( chr(cTecla) )
  endif

  cData    := strzero( nData, 4 )
  lAlterou := .t.

  if RegLock()
    replace Data            with cData
    replace HHNor           with nHHNor 
    replace HH50            with nHH50 
    replace HH100           with nHH100 
    dbunlock ()
  endif
  
  oColuna:refreshCurrent()  
return NIL     

//
// Mostra os dados
//
function MostTbFn()
  select TbFnARQ
  set order to 1
                       
  nLin  := 10
  cRepr := Repr
  nRepr := val( Repr )
  
  setcolor( CorCampo )
  @ 06, 26 say Repr               pict '999999'
  @ 06, 32 say ReprARQ->Nome      pict '@S30'
  
  setcolor( CorJanel )
  dbseek( cRepr, .f. )
  do while Repr == cRepr .and. !eof ()
    if !empty( Data )
      @ nLin, 20 say val( Data )    pict '99/99'
      @ nLin, 28 say HHNor          pict '@E 999,999.99'
      @ nLin, 40 say HH50           pict '@E 999,999.99'
      @ nLin, 51 say HH100          pict '@E 999,999.99'
    else  
      @ nLin, 20 say '     '
      @ nLin, 28 say '          '
      @ nLin, 40 say '          '
      @ nLin, 51 say '          '
    endif  
    nLin ++
    
    if nLin > 17
      exit
    endif
    dbskip ()
  enddo
  
  PosiDBF( 04, 65 )
return NIL

//
// Grava Tabela de Valores
//
function GravTbFn()
  
  set deleted off   
    
  select( cTbFnTMP )
  set order to 1 
  dbgotop ()
  do while !eof ()
    if HHNor == 0
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
    
      select TbFnARQ
      if AdiReg()
        if RegLock()
          replace Repr       with cRepr
          replace Sequ       with &cTbFnTMP->Sequ
          replace Data       with &cTbFnTMP->Data
          replace HHNor      with &cTbFnTMP->HHNor  
          replace HH50       with &cTbFnTMP->HH50   
          replace HH100      with &cTbFnTMP->HH100
          dbunlock ()
        endif
      endif   
    else 
      select TbFnARQ
      go nRegi
      
      if RegLock()
        replace Data       with &cTbFnTMP->Data
        replace HHNor      with &cTbFnTMP->HHNor  
        replace HH50       with &cTbFnTMP->HH50   
        replace HH100      with &cTbFnTMP->HH100
        dbunlock ()
      endif  
          
      if lLixo
        if RegLock()
          dbdelete ()
          dbunlock ()
        endif
      endif
    endif 
      
    select( cTbFnTMP )
    dbskip ()
  enddo  
   
  set deleted on
  
  select TbFnARQ
return NIL

//
// Procura o Valor da Hora
//
function BuscaHrVa ( pData, pRepr )
  xData  := substr( dtos( pData ), 5, 2 ) + substr( dtos( pData ), 3, 2 ) 
  lAchou := .f.
  
  set device to screen
    
  select TbFnARQ
  set order to 1
  dbseek( pRepr, .t. ) 
  do while !eof ()
    
    if Data == xData
      lAchou := .t.

      exit
    endif
    dbskip ()  
  enddo
  
  set device to printer
  
  if !lAchou
    dbseek( pRepr, .t. )
    do while !eof ()
      if right( Data, 2 ) == right( xData, 2 )
        exit
      endif 

      dbskip ()
    enddo   
  endif  
return NIL