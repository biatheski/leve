//  Leve, Tipo de Endereços
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

function TpEn( xAlte )

if NetUse( "TpEnARQ", .t. )
  VerifIND( "TpEnARQ" )
  
  lOpenTpEn := .t.

  #ifdef DBF_NTX
    set index to TpEnIND1, TpEnIND2
  #endif
else
  lOpenTpEn := .f.
endif

//  Variaveis de Entrada
cCoPo := space(04)
nTpEn := 0
cNoPo := space(30)

//  Tela TpEn
Janela ( 06, 05, 13, 62, mensagem( 'Janela', 'TpEn', .f. ), .t. )

setcolor ( CorJanel + ',' + CorCampo )
@ 08,10 say '   Codigo'
@ 10,10 say 'Descrição'

MostOpcao( 12, 07, 19, 38, 51 ) 
tTpEn := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de TpEn
select TpEnARQ
set order to 1
if lOpenTpEn
  dbgobottom ()
endif  
do while .t.
  select TpEnARQ
  set order to 1

  Mensagem('TpEn','Janela')

  restscreen( 00, 00, 23, 79, tTpEn )
  cStat := space(4)
  MostTpEn()
  
  if Demo ()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostTpEn'
  cAjuda   := 'TpEn'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  if lastkey() == K_ALT_A
    nTpEn := val( TpEn )
  else    
    if xAlte 
      @ 08,20 get nTpEn              pict '999999'
      read
    else
      dbgobottom ()
     
      nTpEn := val( TpEn ) + 1
    endif  
  endif  
       
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. nTpEn == 0
    exit
  endif
  
  setcolor ( CorCampo )
  cCoPo := strzero( nTpEn, 6 )
  @ 08,20 say cCoPo
  
  //  Verificar existencia do Lancamento para Incluir ou Alterar
  select TpEnARQ
  set order to 1
  dbseek( cCoPo, .f. )
  if eof()
    cStat :=  'incl'
  else
    cStat :=  'alte'
  endif

  Mensagem ('TpEn',cStat )
  
  MostTpEn ()
  EntrTpEn ()

  Confirmar( 12, 07, 19, 38, 51, 3 )

  if cStat == 'excl'
    ExclRegi ()
  endif

  if cStat == 'prin'
    PrinTpEn(.f.)
  endif  
    
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace TpEn         with cCoPo
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

if lOpenTpEn
  select TpEnARQ
  close
endif

return NIL

//  Funcao Entra Dados do Lançamento
function EntrTpEn ()
  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,20 get cNoPo                valid !empty( cNoPo )
  read
return NIL

//  Funcao Mostra Dados do TpEn 
function MostTpEn ()

  if cStat != 'incl' 
    cCoPo := TpEn
    nTpEn := val( TpEn )
  endif
  
  cNoPo := Nome
      
  setcolor ( CorCampo )
  @ 10,20 say cNoPo
  
  PosiDBF( 06, 62 )
return NIL

//
//  Funcao Imprime dados do TpEno
//
function PrinTpEn( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "TpEnARQ", .t. )
      VerifIND( "TpEnARQ" )

      #ifdef DBF_NTX
        set index to TpEnIND1, TpEnIND2
      #endif
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 06, 27, 10, 56, mensagem( 'Janela', 'PrinTpEn', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,30 say 'Endereço Inicial'
  @ 09,30 say '  Endereço Final'

  select TpEnARQ
  set order to 1
  dbgotop ()
  nTpEnIni := val( TpEn )
  dbgobottom ()
  nTpEnFin := val( TpEn )

  @ 08,47 get nTpEnIni    pict '999999'        valid ValidARQ( 99, 99, "TpEnARQ", "Código" , "TpEn", "Descrição", "Nome", "TpEn", "nTpEnIni", .t., 6, "TpEnadores", "TpEnARQ", 40 )
  @ 09,47 get nTpEnFin    pict '999999'        valid ValidARQ( 99, 99, "TpEnARQ", "Código" , "TpEn", "Descrição", "Nome", "TpEn", "nTpEnFin", .t., 6, "TpEnadores", "TpEnARQ", 40 ) .and. nTpEnFin >= nTpEnIni  
  read
  
  if lastkey () == K_ESC
    select TpEnARQ
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

  cTpEnIni := strzero( nTpEnIni, 6 )
  cTpEnFin := strzero( nTpEnFin, 6 )
  lInicio  := .t.

  select TpEnARQ
  set order to 1
  dbseek( cTpEnIni, .t. )
  do while TpEn >= cTpEnIni .and. TpEn <= cTpEnFin .and. !eof()
    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on

      lInicio := .f.
    endif  
    
    if nLin == 0
      Cabecalho( 'Endereço', 80, 3 )
      CabTpEn()
    endif
      
    @ nLin, 07 say TpEn                 pict '999999'
    @ nLin, 16 say Nome
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
      replace Titu       with "Relatório de Endereço"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
  endif  

  select TpEnARQ
  if lAbrir
    close 
  else
    set order to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
  return NIL
return NIL

function CabTpEn ()
  @ 02,01 say 'Endereço Descrição'

  nLin := 4
retur NIL