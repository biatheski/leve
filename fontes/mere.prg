//  Leve, Meta da Vendas Representante
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

function MeRe( xAlte )

if SemAcesso( 'MeRe' )
  return NIL
endif  

if NetUse( "ReprARQ", .t. )
  VerifIND( "ReprARQ" )

  lOpenRepr := .t.
  
  #ifdef DBF_NTX
    set index to ReprIND1, ReprIND2
  #endif 
else 
  lOpenRepr := .f.  
endif

if NetUse( "MeReARQ", .t. )
  VerifIND( "MeReARQ" )
  
  lOpenMeRe := .t.

  #ifdef DBF_NTX
    set index to MeReIND1, MeReIND2
  #endif 
else
  lOpenMeRe := .f.
endif

//  Variaveis de Entrada
cMes  := space(02)
cRepr := space(04)
nMes  := nValo := 0
nRepr := 0

//  Tela MeRe
Janela ( 06, 05, 14, 62, mensagem( 'Janela', 'MeRe', .f. ), .t. )

setcolor ( CorJanel + ',' + CorCampo )
@ 08,10 say '      Mês'
@ 09,10 say ' Vendedor'
@ 11,10 say '    Valor'

MostOpcao( 13, 07, 19, 38, 51 ) 
tMeRe := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de MeRe
select MeReARQ
set order to 1
if lOpenMeRe
  dbgobottom ()
endif  
do while .t.
  select ReprARQ
  set order    to 1

  select MeReARQ
  set order    to 1
  set relation to Repr into ReprARQ

  Mensagem('MeRe','Janela')

  restscreen( 00, 00, 23, 79, tMeRe )
  cStat := space(4)
  MostMeRe()
  
  if Demo ()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostMeRe'
  cAjuda   := 'MeRe'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  if lastkey() == K_ALT_A
    nMes := val( Mes )
  else    
    if xAlte 
      @ 08,20 get nMes              pict '99'    valid ValidMes( 08, 20, nMes )
      @ 09,20 get nRepr             pict '999999'  valid ValidARQ( 09, 20, "MeReARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nRepr", .t., 6, "Consulta de Vendedores", "ReprARQ", 30 )  
      read
    else
      dbgobottom ()
     
      nMes := val( Mes ) + 1
    endif  
  endif  
       
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. nMes == 0
    exit
  endif
  
  setcolor ( CorCampo )
  cMes  := strzero( nMes, 2 )
  cRepr := strzero( nRepr, 6 )
  
  //  Verificar existencia do Lancamento para Incluir ou Alterar
  select MeReARQ
  set order to 1
  dbseek( cMes + cRepr, .f. )
  if eof()
    cStat :=  'incl'
  else
    cStat :=  'alte'
  endif

  Mensagem ('MeRe',cStat)
  
  MostMeRe ()
  EntrMeRe ()

  Confirmar( 13, 07, 19, 38, 51, 3 )

  if cStat == 'excl'
    ExclRegi ()
  endif

  if cStat == 'prin'
    PrinMeRe(.f.)
  endif  
    
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Mes         with cMes
        replace Repr        with cRepr
        replace Ano         with year(date())
        dbunlock ()
      endif
    endif
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Valo         with nValo
      dbunlock ()
    endif
  endif
enddo

if lOpenMeRe
  select MeReARQ
  close 
endif

if lOpenRepr
  select ReprARQ
  close 
endif

return NIL

//
// Entra Dados do MeReador
//
function EntrMeRe ()
  setcolor ( CorJanel + ',' + CorCampo )
  @ 11,20 get nValo          pict '@E 999,999,999.99' 
  read
return NIL

//
// Mostra Dados do MeReador
//
function MostMeRe ()

  setcolor ( CorCampo )

  if cStat != 'incl' 
    cMes  := Mes 
    nMes  := val( Mes )
    cRepr := Repr
    nRepr := val( Repr )
    
    @ 08,20 say nMes            pict '99'
    if nMes > 0
      @ 08,23 say aMesExt[ nMes ]
    else
      @ 08,23 say space(9)
    endif  
    @ 09,20 say nRepr           pict '999999'       
    @ 09,27 say ReprARQ->Nome   pict '@S30' 
  endif
  
  nValo := Valo
      
  setcolor ( CorCampo )
  @ 11,20 say nValo         pict '@E 999,999,999.99' 
  
  PosiDBF( 06, 62 )
return NIL

//
// Imprime dados do MeReador
//
function PrinMeRe( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "MeReARQ", .t. )
      VerifIND( "MeReARQ" )

      #ifdef DBF_NTX
        set index to MeReIND1, MeReIND2
      #endif 
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 06, 27, 10, 56, mensagem( 'Janela', 'PrinMeRe', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,30 say 'Mes Inicial'
  @ 09,30 say '  Mes Final'

  select MeReARQ
  set order to 1
  dbgotop ()
  nMeReIni := 1
  nMeReFin := 12
  nMes     := 0

  @ 08,42 get nMeReIni    pict '99'        valid ValidMes( 08, 42, nMeReIni )
  @ 09,42 get nMeReFin    pict '99'        valid ValidMes( 09, 42, nMeReFin )
  read
  
  if lastkey () == K_ESC
    select MeReARQ
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

  cMeReIni := strzero( nMeReIni, 2 )
  cMeReFin := strzero( nMeReFin, 2 )
  lInicio  := .t.

  select MeReARQ
  set order to 1
  dbseek( cMeReIni, .t. )
  do while Mes >= cMeReIni .and. Mes <= cMeReFin .and. !eof()
    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on

      lInicio := .f.
    endif  
    
    if nLin == 0
      Cabecalho( 'Meta Vendas', 80, 3 )
      CabMeRe()
    endif
      
    @ nLin, 07 say Mes                 pict '99'
    @ nLin, 12 say Valo                pict '@E 999,999.99'
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
      replace Titu       with "Relatório de Meta Vendas"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
    close
  endif  

  select MeReARQ
  if lAbrir
    close
  else
    set order to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
  return NIL
return NIL

function CabMeRe ()
  @ 02,01 say 'Mes      Valor'

  nLin := 4
retur NIL