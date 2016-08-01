//  Leve, Cadastro de Natureza de Operação
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

function Natu( xAlte )
if SemAcesso( 'Natu' )
  return NIL
endif  

if NetUse( "NatuARQ", .t. )
  VerifIND( "NatuARQ" )
  
  lOpenNatu := .t.

  #ifdef DBF_NTX
    set index to NatuIND1, NatuIND2
  #endif
else
  lOpenNatu := .f.
endif

//  Variaveis de Entrada para Natureza de operacao
cNatu := cCod := space(7)
cNome := space(40)

//  Tela Naturvacao
Janela ( 09, 12, 15, 70, mensagem( 'Janela', 'Natu', .f. ), .t. )

setcolor ( CorJanel )
@ 11,14 say 'Código'
@ 12,14 say '  Nome'

MostOpcao( 14, 14, 26, 46, 59 ) 
tNatu := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Natureza de Operacao
select NatuARQ
set order to 1
if lOpenNatu
  dbgobottom ()
endif  
do while  .t.
  restscreen( 00, 00, 23, 79, tNatu )
  
  Mensagem( 'Natu', 'Janela' )

  select NatuARQ
  set order to 1
  cStat := space(04)
  
  MostNatu()

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostNatu'
  cAjuda   := 'Natu'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()

  @ 11,21 get cCod
  read
    
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. cCod == space (7)
    exit
  endif
  
  setcolor ( CorCampo )
  cNatu := cCod
  @ 11,21 say cNatu

  //  Verificar existencia da Natureza Operacao Incluir, Alterar ou Excluir
  select NatuARQ
  set order to 1
  dbseek( cNatu, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif

  Mensagem( 'Natu', cStat )
  
  MostNatu ()
  EntrNatu ()

  Confirmar( 14, 14, 26, 46, 59, 3 )

  if cStat == 'prin'
    PrinNatu (.f.)
  endif
    
  if cStat == 'excl'
    ExclRegi ()
  endif
    
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Natu           with cNatu
        dbunlock ()
      endif
    endif  
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Nome       with cNome
      dbunlock ()
    endif
  endif
enddo

if lOpenNatu
  select NatuARQ
  close
endif  

return NIL

//
// Entra Dados do Natureza de Operacao
//
function EntrNatu()
  setcolor ( CorJanel + ',' + CorCampo )
  @ 12,21 get cNome 
  read
return NIL

//
// Mostra Dados do Natureza de Operacao
//
function MostNatu()
  setcolor ( CorCampo )
  cCod := Natu
  cNome := Nome

  @ 12,21 say cNome
  
  PosiDBF( 09, 70 )
return NIL

//
// Imprime Dados dos Natureza de Operacao
//
function PrinNatu( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "NatuARQ", .t. )
      VerifIND( "NatuARQ" )

      #ifdef DBF_NTX
        set index to NatuIND1, NatuIND2
      #endif
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 08, 21, 12, 60, mensagem( 'Janela', 'PrinNatu', .f. ), .f.)

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,23 say 'Natureza de Operação Inicial'
  @ 11,23 say '  Natureza de Operação Final'

  select NatuARQ
  set order to 1
  dbgotop ()
  cNatuIni := Natu
  dbgobottom ()
  cNatuFin := Natu


  @ 10,52 get cNatuIni           valid ValidARQ( 99, 99, "NatuARQ", "Código" , "Natu", "Descrição", "Nome", "Natu", "cNatuIni", .f., 7, "Consulta Natureza de Operação", "NatuARQ", 40 )  
  @ 11,52 get cNatuFin           valid ValidARQ( 99, 99, "NatuARQ", "Código" , "Natu", "Descrição", "Nome", "Natu", "cNatuFin", .f., 7, "Consulta Natureza de Operação", "NatuARQ", 40 ) .and. cNatuFin >= cNatuIni
  read

  if lastkey() == K_ESC
    select NatuARQ
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

  select NatuARQ
  set order to 1
  dbseek( cNatuIni, .t. )
  do while Natu >= cNatuIni .and. Natu <= cNatuFin .and. !eof()
    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
      
      lInicio := .f.
    endif  
  
    if nLin == 0
      Cabecalho( 'Natureza de Operação', 80, 3 )
      CabNatu()
    endif
      
    @ nLin,15 say Natu
    @ nLin,25 say Nome
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
      replace Titu       with "Relatório de Natureza de Operação"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
    close
  endif

  select NatuARQ
  if lAbrir
    close
  else
    set order  to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabNatu ()
  @ 02, 02 say 'Natureza Operação'
  @ 02, 25 say 'Descrição'

  nLin := 04
return NIL