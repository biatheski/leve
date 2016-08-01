//  Leve, Acessos dos Usuários
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

function UsMe ()

local aArqui := {}
local cArqu  := CriaTemp(0)
local cArqu1 := CriaTemp(1)

aadd( aArqui, { "Idio",      "C", 002, 0 } )
aadd( aArqui, { "Usua",      "C", 006, 0 } )
aadd( aArqui, { "Modu",      "C", 006, 0 } )
aadd( aArqui, { "Menu",      "C", 008, 0 } )
aadd( aArqui, { "Desc",      "C", 025, 0 } )
aadd( aArqui, { "Item",      "C", 002, 0 } )
aadd( aArqui, { "Marc",      "C", 001, 0 } )

cChave := "Usua+Modu+Menu+Item"

dbcreate( cArqu, aArqui )

use &cArqu exclusive new

cUsMeTMP := alias()

index on &cChave tag &cArqu1

Janela( 03, 15, 19, 65, mensagem( 'Janela', 'UsMe', .f. ), .f. )
setColor(CorJanel)
@ 05,18 say "Usuário"
@ 06,18 say "Empresa                        Menu "

@ 08,22 say "Item Descrição do Item         Acesso"
@ 09,15 say chr(195) + replicate( chr(196), 49 ) + chr(180)
      
@ 09,26 say chr(194)
@ 09,52 say chr(194)

for nU := 10 to 18
  @ nU,26 say chr(179)
  @ nU,52 say chr(179)
next  

@ 19,26 say chr(193)
@ 19,52 say chr(193)

setcolor( corcampo )
@ 05,26 say space(06)
@ 05,33 say space(30)
@ 06,26 say space(02)
@ 06,54 say space(08)

tUsMe:= SaveScreen(0, 0, 23, 79)
select UsuaARQ
set order to 1

do while .t.
  select( cUsMeTMP )
  zap

//  set relation to ( Idio + Modu + Menu + Item ) into MenuARQ

  restscreen( 00, 00, 23, 79, tUsMe )

  Mensagem("UsMe", "Janela" )
 
  setcursor(1)
  setcolor( CorJanel + "," + CorCampo )
  cAjuda := "UsMe"
  lAjud  := .f.
  nModu  := 0
  nUsua  := 0
  cModu  := space(02)
  cMenu  := space(08)
  cUsua  := space(06)
  cStat  := space(04)

  @ 05,26 get nUsua       pict "999999"     valid ValidARQ( 05, 26, "UsMeARQ","Código" ,"Usua","Nome","Nome","Usua","nUsua",.t.,6,"Usu rio do Sistema","UsuaARQ", 30 )
  @ 06,26 get nModu       pict "999999"     valid ValidARQ( 99, 99, "UsMeARQ", "Código" , "Empr", "Descrição", "Razao", "Empr", "nModu", .t., 6, "Consulta de Empresas", "EmprARQ", 40 )
  @ 06,54 get cMenu       pict "99.99.99"   valid at( " ", cMenu ) = 0
  read

  if lastkey() == K_ESC
    setcursor(0)
    exit
  endif

  cModu := strzero( nModu, 6 )
  cUsua := strzero( nUsua, 6 )

  select MenuARQ
  set order to 1
  dbseek( cIdioma + cModu + cMenu, .t. )
  //  Verificar existencia de Dados para Incluir ou Alterar
  do while ! eof() .and. Modu == cModu .and. Menu == cMenu .and. Idio == cIdioma
    nRegi := recno()

    select( cUsMeTMP )
    if AdiReg()
      replace Idio     with MenuARQ->Idio
      replace Modu     with MenuARQ->Modu
      replace Menu     with MenuARQ->Menu
      replace Item     with MenuARQ->Item
      replace Desc     with MenuARQ->Desc
      dbunlock()
    endif  

    select UsMeARQ
    dbseek( cUsua+MenuARQ->Modu+MenuARQ->Menu+MenuARQ->Item, .f. )

    select( cUsMeTMP )
    if !UsMeARQ->(eof())
      replace Marc  with "X"
    endif

    select MenuARQ
    dbskip ()
  enddo
  
  set cursor off
  EntrUsMe()
enddo

select( cUsMeTMP )
close
ferase( cArqu )
ferase( cArqu1 )

select MenuARQ

return NIL

// 
// Entra com dados
//
function EntrUsMe ()
  select( cUsMeTMP )
  dbgotop()

  setcolor ( CorJanel + ',' + CorCampo )
  cCor           := setcolor()
  oCol           := TBrowseDb( 08, 20, 19, 61 )
  oCol:headsep   := chr(194)+chr(196)
  oCol:colsep    := chr(179)
  oCol:footsep   := chr(193)+chr(196)
  oCol:colorSpec := CorJanel

  oCol:addColumn( TBColumnNew("Item",   {||  Item } ) )
  oCol:addColumn( TBColumnNew("Descrição do Item", {|| Desc } ) )
  oCol:addColumn( TBColumnNew("Acesso", {|| ' '+ Marc+ ' ' } ) )
            
  lExitRequested := .f.
  lAdiciona      := .t.

  do while !lExitRequested
    Mensagem( 'UsMe', 'EntrUsMe' )

    oCol:forcestable()
  
    wTecla := Teclar(0)
    nLin   := row()
  
    if oCol:hitTop .or. oCol:hitBottom
      tone( 125, 0 )
    endif

    do case
      case wTecla == K_DOWN;        oCol:down()
      case wTecla == K_UP;          oCol:up()
      case wTecla == K_PGUP;        oCol:pageUp()
      case wTecla == K_CTRL_PGUP;   oCol:goTop()
      case wTecla == K_SPACE
        select UsMeARQ
        set order to 1
        dbseek( cUsua + &cUsMeTMP->Modu + &cUsMeTMP->Menu + &cUsMeTMP->Item, .f. )
 
        if empty( &cUsMeTMP->Marc )
          if eof()  
            if AdiReg()
              replace Usua       with cUsua
              replace Modu       with &cUsMeTMP->Modu
              replace Menu       with &cUsMeTMP->Menu
              replace Item       with &cUsMeTMP->Item
              dbunlock ()

              select( cUsMeTMP )
              replace Marc     with 'X'

              oCol:refreshCurrent()
            endif
          endif
        else
          if RegLock()
            dbdelete ()
            dbunlock ()

            select( cUsMeTMP )
            replace Marc     with ' '

            oCol:refreshCurrent()
          endif
        endif

      case wTecla == K_RIGHT;       oCol:right()
      case wTecla == K_LEFT;        oCol:left()
      case wTecla == K_HOME;        oCol:home()
      case wTecla == K_END;         oCol:end()
      case wTecla == K_CTRL_LEFT;   oCol:panLeft()
      case wTecla == K_CTRL_RIGHT;  oCol:panRight()
      case wTecla == K_CTRL_HOME;   oCol:panHome()
      case wTecla == K_CTRL_END;    oCol:panEnd()
      case wTecla == K_ESC;         lExitRequested := .t.
    endcase
  enddo
return NIL