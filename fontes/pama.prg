//  Leve, Paradas
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

function PaMa( xAlte )

if SemAcesso( 'PaMa' )
  return NIL
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
cCoPo := space(04)
nPaMa := 0
cNoPo := space(30)

//  Tela PaMa
Janela ( 06, 05, 13, 62, mensagem( 'Janela', 'PaMa', .f. ), .t. )

setcolor ( CorJanel + ',' + CorCampo )
@ 08,10 say '   Codigo'
@ 10,10 say 'Descrição'

MostOpcao( 12, 07, 19, 38, 51 ) 
tPaMa := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de PaMa
select PaMaARQ
set order to 1
if lOpenPaMa
  dbgobottom ()
endif  
do while .t.
  select PaMaARQ
  set order to 1

  Mensagem('PaMa','Janela')

  restscreen( 00, 00, 23, 79, tPaMa )
  cStat := space(4)
  MostPaMa()
  
  if Demo ()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostPaMa'
  cAjuda   := 'PaMa'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  if lastkey() == K_ALT_A
    nPaMa := val( PaMa )
  else    
    if xAlte 
      @ 08,20 get nPaMa              pict '999999'
      read
    else
      dbgobottom ()
    
      nPaMa := val( PaMa ) + 1
      xAlte := .t.
    endif  
  endif  
       
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. nPaMa == 0
    exit
  endif
  
  setcolor ( CorCampo )
  cCoPo := strzero( nPaMa, 6 )
  @ 08,20 say cCoPo
  
  //  Verificar existencia do Lancamento para Incluir ou Alterar
  select PaMaARQ
  set order to 1
  dbseek( cCoPo, .f. )
  if eof()
    cStat :=  'incl'
  else
    cStat :=  'alte'
  endif

  Mensagem ('PaMa',cStat)
  
  MostPaMa ()
  EntrPaMa ()

  Confirmar( 12, 07, 19, 38, 51, 3 )

  if cStat == 'excl'
    ExclRegi ()
  endif

  if cStat == 'prin'
    PrinPaMa(.f.)
  endif  
    
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace PaMa         with cCoPo
        dbunlock ()
      endif
    endif
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Nome         with cNoPo
      dbunlock ()
    endif
  endif
enddo

if lOpenPaMa
  select PaMaARQ
  close 
endif

return NIL
//
// Entra Dados do Parada
//
function EntrPaMa ()
  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,20 get cNoPo                valid !empty( cNoPo )
  read
return NIL

//
// Mostra Dados do Parada 
//
function MostPaMa ()

  if cStat != 'incl' 
    cCoPo := PaMa
    nPaMa := val( PaMa )
  endif
  
  cNoPo := Nome
      
  setcolor ( CorCampo )
  @ 10,20 say cNoPo
  
  PosiDBF( 06, 62 )
return NIL

//
// Imprime dados do PaMao
//
function PrinPaMa( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "PaMaARQ", .t. )
      VerifIND( "PaMaARQ" )

      #ifdef DBF_NTX
        set index to PaMaIND1, PaMaIND2
      #endif
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 06, 27, 10, 56, mensagem( 'Janela', 'PrinPaMa', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,30 say 'Parada Inicial'
  @ 09,30 say '  Parada Final'

  select PaMaARQ
  set order to 1
  dbgotop ()
  nPaMaIni := val( PaMa )
  dbgobottom ()
  nPaMaFin := val( PaMa )

  @ 08,45 get nPaMaIni    pict '999999'    valid nPamaIni == 0 .or. ValidARQ( 99, 99, "PaMaARQ", "Código" , "PaMa", "Descrição", "Nome", "PaMa", "nPaMaIni", .t., 6, "Consulta de Paradas", "PaMaARQ", 30 )
  @ 09,45 get nPaMaFin    pict '999999'    valid nPamaFin == 0 .or. ValidARQ( 99, 99, "PaMaARQ", "Código" , "PaMa", "Descrição", "Nome", "PaMa", "nPaMaFin", .t., 6, "Consulta de Paradas", "PaMaARQ", 30 ) .and. nPaMaFin >= nPaMaIni
  read
  
  if lastkey () == K_ESC
    select PaMaARQ
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

  nPag   := 1
  nLin   := 0
  cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

  cPaMaIni := strzero( nPaMaIni, 6 )
  cPaMaFin := strzero( nPaMaFin, 6 )
  lInicio  := .t.
  
  select PaMaARQ
  set order to 1
  dbseek( cPaMaIni, .t. )
  do while PaMa >= cPaMaIni .and. PaMa <= cPaMaFin .and. !eof()
    if lInicio 
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
      
      lInicio := .f.
    endif  
  
    if nLin == 0
      Cabecalho( 'Paradas', 80, 3 )
      CabPaMa()
    endif
      
    @ nLin, 01 say PaMa                 pict '999999'
    @ nLin, 12 say Nome
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
      replace Titu       with "Relatório de Paradas"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
  endif  

  select PaMaARQ
  if lAbrir
    close
  else
    set order to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
  return NIL
return NIL

function CabPaMa ()
  @ 02,01 say 'Parada Descrição'

  nLin := 4
return NIL