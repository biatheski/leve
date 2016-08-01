//  Leve, Controle de Vales
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

function Vale( xAlte )

if NetUse( "ValeARQ", .t. )
  VerifIND( "ValeARQ" )
  
  lOpenVale := .t.
  
  #ifdef DBF_NTX 
    set index to ValeIND1, ValeIND2
  #endif  
else
  lOpenVale := .f.
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

//  Variaveis de Entrada para Valeta
nValor   := nRepr     := 0
cClie    := cRepr     := cHora  := space(04)
dData    := date()
cObs1    := cObs2     := cObs3  := space(60)
cCliente := space(40)

//  Tela Clieesa
Janela( 06, 11, 16, 65, mensagem( 'Janela', 'Vale', .f. ), .t. )
setcolor( CorJanel )
@ 08,13 say '      Data'
@ 09,13 say '  Vendedor'

@ 11,13 say '     Valor'
@ 12,13 say 'Observação'

MostOpcao( 15, 13, 25, 41, 54 ) 
tVale := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Vales
select ValeARQ
set order to 1
if !xAlte
  dbgobottom ()
endif  
do while .t.
  Mensagem ( 'Vale','Janela')

  select ReprARQ
  set order    to 1

  select ValeARQ
  set order    to 1
  set relation to Repr into ReprARQ

  restscreen( 00, 00, 23, 79, tVale )
  cStat := space(04)

  MostVale()
    
  if Demo()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostVale'
  cAjuda   := 'Vale'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
   
  @ 08,24 get dData       pict '99/99/9999'
  @ 09,24 get nRepr       pict '999999'     valid ValidARQ( 09, 24, "ValeARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nRepr", .t., 6, "Consulta de Vendedores", "ReprARQ", 30 )
  read
    
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. nRepr == 0
    exit
  endif
  
  cRepr := strzero( nRepr, 6 )

  //  Verificar existencia da Valeta para Incluir ou Alterar
  select ValeARQ
  set order to 1
  dbseek( dtos( dData ) + cRepr, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif

  Mensagem ('Vale',cStat)
  
  vStatAnt := cStat
  
  MostVale()
  EntrVale()

  Confirmar( 15, 13, 25, 41, 54, 3 ) 
  
  if cStat == 'excl'
    ExclRegi ()
  endif
  
  if cStat == 'prin'

  endif

  cStat := vStatAnt
  
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Repr       with cRepr
        replace Data       with dData
        dbunlock ()
      endif
    endif
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Obs1       with cObs1
      replace Obs2       with cObs2 
      replace Valor      with nValor
      dbunlock ()
    endif
  endif
  
  if EmprARQ->Caixa == "X"
    cHist := cObs1 + " " + cObs2
    dEmis := dData
    dPgto := dData
    nPago := nValor
    cNota := cRepr + left( strtran( dtos( dEmis ), "/", "" ), 4 )
    
    DestLcto ()
  endif
    
  if cStat == 'prin'
    PrinVale (.f.)
  endif  
enddo

if lOpenRepr 
  select ReprARQ
  close
endif

if lOpenVale 
  select ValeARQ
  close
endif

return NIL

//
// Entra Dados da Valeta 
//
function EntrVale()
  setcolor ( CorJanel + ',' + CorCampo )
  @ 11,24 get nValor      pict '@E 999,999.99'
  @ 12,24 get cObs1       pict '@S40'
  @ 13,24 get cObs2       pict '@S40'
  read
return NIL

//
// Mostra Dados do Cliente
//
function MostVale()
  setcolor ( CorCampo )
  if cStat != 'incl'
    dData := Data
    cRepr := Repr
    nRepr := val( Repr )
    
    @ 08,24 say dData           pict '99/99/9999'
    @ 09,24 say cRepr           pict '999999'
    @ 09,31 say ReprARQ->Nome   pict '@S30'
  endif
  
  cObs1  := Obs1    
  cObs2  := Obs2 
  nValor := Valor
  
  @ 11,24 say nValor      pict '@E 999,999.99'
  @ 12,24 say cObs1       pict '@S40'
  @ 13,24 say cObs2       pict '@S40'
  
  PosiDBF( 06, 65 )
return NIL

//
// Imprimir Vales 
//
function PrinVale ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "ValeARQ", .t. )
    VerifIND( "ValeARQ" )
    
    #ifdef DBF_NTX 
      set index to ValeIND1, ValeIND2
    #endif  
  endif

  if NetUse( "ReprARQ", .t. )
    VerifIND( "ReprARQ" )

    #ifdef DBF_NTX 
      set index to ReprIND1, ReprIND2
    #endif
  endif

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 07, 08, 11, 65, mensagem( 'Janela', 'PrinVale', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 09,10 say 'Vendedor Inicial             Vendedor Final'
  @ 10,10 say '    Data Inicial                 Data Final'

  select ReprARQ
  set order  to 1
  dbgotop ()
  nReprIni  := val( Repr )
  dbgobottom ()
  nReprFin  := val( Repr )

  dDataIni  := ctod ('01/01/1990')
  dDataFin  := ctod ('31/12/2010')

  setcolor ( CorJanel + ',' + CorCampo )
  @ 09,27 get nReprIni  pict '999999'       valid ValidARQ( 99, 99, "ValeARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprIni", .t., 6, "Consulta de Vendedores", "ReprARQ", 40 )
  @ 09,54 get nReprFin  pict '999999'       valid ValidARQ( 99, 99, "ValeARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprFin", .t., 6, "Consulta de Vendedores", "ReprARQ", 40 ) .and. nReprFin >= nReprIni
  @ 10,27 get dDataIni  pict '99/99/9999'
  @ 10,54 get dDataFin  pict '99/99/9999' valid dDataFin >= dDataIni
  read

  if lastkey() == K_ESC
    select ValeARQ
    close
    select ReprARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
   
  Aguarde ()

  nPag     := 1
  nLin     := 0
  cArqu2   := cArqu2 + "." + strzero( nPag, 3 )
  lInicio  := .t.
  cReprAnt := space(06)

  cReprIni := strzero( nReprIni, 6 )
  cReprFin := strzero( nReprFin, 6 )
  
  select ValeARQ  
  set order    to 2
  set relation to Repr into ReprARQ
  dbseek( cReprIni, .t. )
  do while Repr >= cReprIni .and. Repr <= cReprFin .and. !eof()
    if Data >= dDataIni .and. Data <= dDataFin
      if lInicio
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
        
        lInicio := .f.
      endif
         
      if nLin == 0
        Cabecalho( 'Vales', 80, 1 )
        CabVale()
      endif
      
      if cReprAnt != Repr
        nLin ++
        @ nLin,01 say Repr
        @ nLin,08 say ReprARQ->Nome

        nLin ++
        cReprAnt := Repr
      endif  
      
      cObse := alltrim( Obs1 ) + ' ' + alltrim( Obs2 )
 
      @ nLin,006 say Data          pict '99/99/9999'
      @ nLin,017 say Valor         pict '@E 999,999.99'
      @ nLin,028 say cObse         pict '@S60'
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
      replace Titu       with "Relatório de Vales"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      dbunlock ()
    endif
    close
  endif  

  select ReprARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabVale ()
  @ 02,01 say 'Vendedor'
  @ 03,01 say '     Data            Valor  Observação'

  nLin     := 4
  cReprAnt := space(06)
return NIL