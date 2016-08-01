//  Leve, SubGrupos
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

function SubG( xAlte, xGrup )
  local GetList := {}
  
if SemAcesso( 'SubG' )
  return NIL
endif  

if NetUse( "GrupARQ", .t. )
  VerifIND( "GrupARQ" )
  
  sOpenGrup := .t.

  #ifdef DBF_NTX
    set index to GrupIND1, GrupIND2
  #endif
else
  sOpenGrup := .f.  
endif

if NetUse( "SubGARQ", .t. )
  VerifIND( "SubGARQ" )
  
  sOpenSubG := .t.
  
  #ifdef DBF_NTX
    set index to SubGIND1, SubGIND2
  #endif
else
  sOpenSubG := .f.  
endif

//  Variaveis de Entrada para SubG
nSubG := nGrup := 0
cSubG := cGrup := space(3)
cNome := space(30)

//  Tela SubG
Janela ( 07, 12, 14, 70, mensagem( 'Janela', 'SubG', .f. ), .t. )

setcolor ( CorJanel )
@ 09,14 say '   Grupo'
@ 10,14 say 'SubGrupo'
@ 11,14 say '    Nome'

MostOpcao( 13, 14, 26, 46, 59 ) 
tSubG := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Subgrupo
select SubGARQ
set order    to 1
set relation to Grup into GrupARQ
if sOpenSubG
  dbgobottom ()
endif  
do while .t.
  select GrupARQ
  set order    to 1

  select SubGARQ
  set order    to 1
  set relation to Grup into GrupARQ

  Mensagem('SubG', 'Janela' )
 
  cStat := space(04)
  restscreen( 00, 00, 23, 79, tSubG )
  MostSubg ()

  setcolor ( CorJanel + ',' + CorCampo )
  MostTudo := 'MostSubG'
  cAjuda   := 'SubG'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  if lastkey() == K_ALT_A
    nGrup := val( Grup )
  else   
    if xAlte   
      @ 09,23 get nGrup         pict '999999'     valid ValidARQ( 09, 23, "GrupARQ", "Código" , "Grup", "Descrição", "Nome", "Grup", "nGrup", .t., 6, "Consulta de Grupos", "GrupARQ", 30 ) .and. !empty( nGrup )
      read
    else 
      nGrup := xGrup
    
      select GrupARQ 
      set order to 1
      dbseek( strzero( nGrup, 6 ), .f. )
     
      setcolor ( CorCampo )
      @ 09,23 say nGrup         pict '999999'
      @ 09,30 say GrupARQ->Nome
    endif  
  endif  
    
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. nGrup == 0
    exit
  endif
   
  cGrup := strzero ( nGrup, 6 )
  
  select SubgARQ
  set order  to 1
  set filter to Grup == cGrup
  dbgobottom ()

  setcolor( CorCampo )
  @ 10,23 say SubG
  @ 11,23 say Nome
  
  nSubG := val( SubG )

  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostSubG'
  cAjuda   := 'SubG'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  if lastkey() == K_ALT_A
    nSubG := val( SubG )
  else    
    if xAlte
      @ 10,23 get nSubg     pict '999999'
      read
    else
      nSubG ++  
    endif  
  endif  
    
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC
    loop
  endif
  
  setcolor ( CorCampo )
  cSubG := strzero( nSubg, 6 )
  @ 10,23 say cSubG

  //  Verificar existencia do SubG para Incluir, Alterar ou Excluir
  select SubgARQ
  set order to 1
  dbseek( cGrup + cSubG, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif
  
  Mensagem( 'SubG', cStat )
  
  MostSubg ()
  EntrSubg ()

  Confirmar ( 13, 14, 26, 46, 59, 3 )

  if cStat == 'prin'
    PrinSubg (.f.)
  endif
  
  if cStat == 'excl'
    ExclRegi ()
  endif
  
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Grup      with cGrup
        replace SubG      with cSubG
        dbunlock ()
      endif
    endif 
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Nome     with cNome
      dbunlock ()
    endif
    
    if !xAlte 
      xAlte := .t.
      keyboard(chr(27))
    endif  
  endif
enddo

if sOpenSubG
  select SubGARQ
  close
else
  set filter to   
endif  

if sOpenGrup
  select GrupARQ
  close
endif  

return NIL

//
// Entra Dados do SubG
//
function EntrSubg ()
  local GetList := {}

  setcolor ( CorJanel + ',' + CorCampo )
  @ 11,23 get cNome 
  read
return NIL

//
// Mostra Dados do SubG
//
function MostSubg ()
  setcolor ( CorCampo )
  if cStat != 'incl'
    cGrup := Grup
    cSubG := SubG
    nSubg := val( Subg )
    nGrup := val( Grup )
  
    @ 09,23 say cGrup
    @ 09,30 say GrupARQ->Nome
    @ 10,23 say cSubG
  endif
  
  cNome := Nome
  
  @ 11,23 say cNome
  
  PosiDBF( 07, 70 )
return NIL

//
// Mostra Dados do Grup do SubG
//
function MostGSub ()
  setcolor ( CorCampo )
  @ 09,23 say GrupARQ->Grup
  @ 09,27 say GrupARQ->Nome
return NIL

//
// Imprime dados do grupo
//
function PrinSubG( lAbrir )

  local cArqu2  := CriaTemp( 5 )
  local cArqu3  := right ( cArqu2, 8 )
  local cRData  := date()
  local cRHora  := time()
  local GetList := {}

  if lAbrir
    if NetUse( "GrupARQ", .t. )
      VerifIND( "GrupARQ" )

      #ifdef DBF_NTX
        set index to GrupIND1, GrupIND2
      #endif
    endif

    if NetUse( "SubGARQ", .t. )
      VerifIND( "SubGARQ" )

      #ifdef DBF_NTX
        set index to SubGIND1, SubGIND2
      #endif
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 09, 16, 13, 66, mensagem( 'Janela', 'PrinSubG', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 11,18 say '   Grupo Inicial            Grupo Final'
  @ 12,18 say 'Subgrupo Inicial         Subgrupo Final'

  select GrupARQ
  dbgotop ()
  nGrupIni := val( Grup )
  dbgobottom ()
  nGrupFin := val( Grup )
  nSubgIni := 001
  nSubgFin := 999999 

  @ 11,35 get nGrupIni       pict '999999'     valid ValidARQ( 99, 99, "GrupARQ", "Código" , "Grup", "Descrição", "Nome", "Grup", "nGrupIni", .t., 6, "Consulta de Grupos", "GrupARQ", 30 )
  @ 11,58 get nGrupFin       pict '999999'     valid ValidARQ( 99, 99, "GrupARQ", "Código" , "Grup", "Descrição", "Nome", "Grup", "nGrupFin", .t., 6, "Consulta de Grupos", "GrupARQ", 30 ) .and. nGrupFin >= nGrupIni
  @ 12,35 get nSubgIni       pict '999999'
  @ 12,58 get nSubgFin       pict '999999'     valid nSubgFin >= nSubgIni
  read

  if lastkey() == K_ESC
    if lAbrir
      select GrupARQ
      close
      select SubGARQ
      close
    else 
      select SubGARQ
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

  cSubGIni := strzero( nSubGIni, 6 )
  cSubGFin := strzero( nSubGFin, 6 )
  cGrupIni := strzero( nGrupIni, 6 )
  cGrupFin := strzero( nGrupFin, 6 )
  cGrupAnt := space(2)
  lInicio  := .t.

  select SubGARQ
  set filter   to 
  set order    to 1
  set relation to Grup into GrupARQ
  dbseek( cGrupIni, .t. )
  do while Grup >= cGrupIni .and. Grup <= cGrupFin .and. !eof()
    if SubG >= cSubgIni .and. SubG <= cSubgFin
      if lInicio 
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
        
        lInicio := .f.
      endif
        
      if nLin == 0
        Cabecalho( 'SubGrupos', 80, 2 )
        CabSubGrup()
      endif
      
      if Grup != cGrupAnt
        cGrupAnt := Grup
      
        @ nLin,03 say Grup
        @ nLin,10 say GrupARQ->Nome
      endif

      @ nLin,44 say SubG
      @ nLin,52 say Nome
      nLin ++

      if nLin >= pLimite
        Rodape(80) 

        cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
        cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

        set printer to ( cArqu2 )
        set printer on
      endif     
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
      replace Titu       with "Relatório de SubGrupos"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
    close
  endif

  if lAbrir
    select GrupARQ
    close
    select SubGARQ
    close
  else  
    select SubGARQ
    set order  to 1
    dbgobottom ()
  endif
  
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabSubGrup ()
  @ 02, 05 say 'Grupos'
  @ 02, 45 say 'SubGrupos'

  nLin     := 04
  cGrupAnt := space(3)
return NIL