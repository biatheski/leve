//  Leve, Estados
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

function Esta( eOpenEsta )

if NetUse( "EstaARQ", .t. )
  VerifIND( "EstaARQ" )
  
  rOpenEsta := .t.
  
  #ifdef DBF_NTX
    set index to EstaIND1
  #endif  
else
  rOpenEsta := .f.  
endif

if SemAcesso( 'Esta' )
  return NIL
endif  

//  Variaveis de Entrada para Estado
cEsta := space(2)
cNoEs := space(20)
nICMS := nISS := 0

//  Tela Estado
Janela ( 05, 12, 13, 69, mensagem( 'Janela', 'Esta', .f. ), .t. )

setcolor ( CorJanel + ',' + CorCampo )
@ 07,14 say '     Sigla'
@ 08,14 say '      Nome'

@ 10,14 say ' % de ICMS             % de ISS'

MostOpcao( 12, 14, 26, 45, 58 )
tEsta := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Estado
select EstaARQ
set order to 1
if eOpenEsta
  dbgobottom ()
endif  
do while  .t.
  select EstaARQ
  set order to 1

  cStat := space(04)
  Mensagem ( 'Esta', 'Janela' )

  restscreen( 00, 00, 23, 79, tEsta )

  MostEsta()

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostEsta'
  cAjuda   := 'Esta'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()

  @ 07,25 get cEsta             pict '@!'
  read
  
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. cEsta == space(2)
    exit
  endif

  //  Verificar existencia do Estado para Incluir, Alterar ou Excluir
  select EstaARQ
  set order to 1
  dbseek( cEsta, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif

  Mensagem ('Esta', cStat )
  
  MostEsta()
  EntrEsta()

  Confirmar ( 12, 14, 26, 45, 58, 3 )
  
  if cStat == 'excl'
    ExclRegi ()
  endif
  
  if cStat == 'prin'
    PrinEsta (.f.)
  endif  
    
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Esta       with cEsta
        dbunlock ()
      endif
    endif  
  endif
  
  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Nome       with cNoEs
      replace ICMS       with nICMS
      replace ISS        with nISS
      dbunlock ()
    endif
  endif
enddo

if rOpenEsta
  select EstaARQ
  close
endif

return NIL


//
// Entra Dados do Estado
//
function EntrEsta()
  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,25 get cNoEs 
  @ 10,25 get nICMS          pict '@E 999.99'
  @ 10,46 get nISS           pict '@E 999.99'
  read
return NIL

//
// Mostra Dados do Estado
//
function MostEsta()
  if cStat != 'incl'
    cEsta := Esta
  endif
    
  cNoEs := Nome
  nICMS := ICMS
  nISS  := ISS
  
  setcolor ( CorCampo )
  @ 08,25 say cNoEs
  @ 10,25 say nICMS        pict '@E 999.99'
  @ 10,46 say nISS         pict '@E 999.99'
  
  PosiDBF( 05, 69 )
return NIL

//
// Imprime dados do Estado
//
function PrinEsta( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "EstaARQ", .t. )
      VerifIND( "EstaARQ" )

      #ifdef DBF_NTX
        set index to EstaIND1, EstaIND2
      #endif  
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 06, 27, 10, 53, mensagem( 'Janela', 'PrinEsta', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,30 say 'Estado Inicial'
  @ 09,30 say '  Estado Final'

  select EstaARQ
  set order to 1
  dbgotop ()
  cEstaIni := 'AA'
  cEstaFin := 'ZZ'

  @ 08,45 get cEstaIni    pict '@!'
  @ 09,45 get cEstaFin    pict '@!'        valid cEstaFin >= cEstaIni
  read
  
  if lastkey () == K_ESC
    select EstaARQ
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

  nPag    := 1
  nLin    := 0
  cArqu2  := cArqu2 + "." + strzero( nPag, 3 )
  lInicio := .t.
  
  select EstaARQ
  set order to 2
  dbseek( cEstaIni, .t. )
  do while Esta >= cEstaIni .and. Esta <= cEstaFin .and. !eof()
    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
    
      lInicio := .f.
    endif  
  
    if nLin == 0
      Cabecalho( 'Estados', 80, 3 )
      CabEsta()
    endif
      
    @ nLin, 01 say Esta
    @ nLin, 05 say Nome
    @ nLin, 50 say ICMS           pict '@E 999.99'
    @ nLin, 60 say ISS            pict '@E 999.99'
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
      replace Titu       with "Relatório de Estados"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
    close
  endif  

  select EstaARQ
  if lAbrir
    close
  else
    set order to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
  return NIL
return NIL

function CabEsta ()
  @ 02,01 say 'UF  Descrição                                Aliq. ICMS'

  nLin := 4
retur NIL