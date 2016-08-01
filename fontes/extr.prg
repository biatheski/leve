//  Leve, Lançamentos
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

function Extr()

if NetUse( "LctoARQ", .t. )
  VerifIND( "LctoARQ" )
  
  eOpenLcto := .t.

  #ifdef DBF_NTX
    set index to LctoIND1, LctoIND2
  #endif
else
  eOpenLcto := .f.
endif

if NetUse( "CaixARQ", .t. )
  VerifIND( "CaixARQ" )
  
  eOpenCaix := .t.

  #ifdef DBF_NTX
    set index to CaixIND1, CaixIND2
  #endif
else
  eOpenCaix := .f.
endif

if NetUse( "ExtrARQ", .t. )
  VerifIND( "ExtrARQ" )
  
  eOpenExtr := .t.

  #ifdef DBF_NTX
    set index to ExtrIND1, ExtrIND2, ExtrIND3
  #endif
else
  eOpenExtr := .f.
endif

//  Variaveis de Entrada para Extr
cCaix := cCod := cDcto := cDocu := space (15)
nLcto := nValM := 0
cLcto := space(4)
dMovi := ctod ('99/99/9999')
cHist := space(60)

//  Tela Extr
Janela ( 05, 12, 17, 74, mensagem( 'Janela', 'Extr', .f. ), .t. )

setcolor ( CorJanel )
@ 07,14 say '       Conta'
@ 08,14 say '  Lançamento'
@ 09,14 say 'N. Documento'

@ 11,14 say '        Tipo  Crédito   Débito'
@ 12,14 say '        Data'
@ 13,14 say '       Valor'
@ 14,14 say '   Histórico'

MostOpcao ( 16, 14, 26, 50, 63 )
tExtr := savescreen( 00, 00, 23, 79 )

//  Lancamento do Movimento
select ExtrARQ
set order    to 1
set relation to Caix into CaixARQ, to Lcto into LctoARQ
dbgobottom ()
do while .t.
  select CaixARQ
  set order    to 1
  
  select LctoARQ
  set order    to 1 

  select ExtrARQ
  set order    to 1
  set relation to Caix into CaixARQ, to Lcto into LctoARQ

  Mensagem('Extr',cStat)

  cStat := space(4)
  restscreen( 00, 00, 23, 79, tExtr )
  MostExtr()
  
  if Demo ()
    exit
  endif  

  //  Verificar Departamento
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostExtr'
  cAjuda   := 'Extr'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()

  @ 07,27 get cCod    pict '@K'         valid ValidARQ( 07, 27, "ExtrARQ", "Conta", "Caix", "Descrição", "Nome", "Caix", "cCod", .f., 15, "Consulta de Conta Corrente", "CaixARQ", 40 )
  @ 08,27 get nLcto   pict '999999'       valid ValidARQ( 08, 27, "ExtrARQ", "Código" , "Lcto", "Descrição", "Nome", "Lcto", "nLcto", .t., 06, "Consulta de Lançamentos", "LctoARQ", 40 ) .and. UltExtr( cCod, nLcto )
  @ 09,27 get cDocu   pict '@K!'
  read
    
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. cCod == space(15)
    exit
  endif

  setcolor ( CorCampo )
  cCaix := cCod
  cDcto := cDocu
  cLcto := strzero( nLcto, 6 )

  @ 07,27 say cCaix
  @ 08,27 say cLcto
  @ 09,27 say cDcto
  
  //  Verificar existencia do Extr para Incluir, Alterar ou Excluir
  select ExtrARQ
  set order to 1
  dbseek( cCaix + cLcto + cDcto, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif

  Mensagem ('Extr',cStat)

  MostExtr()
  EntrExtr()

  Confirmar ( 16, 14, 26, 50, 63, 3 )

  if cStat == 'prin'
    PrinExtr (.f.)
  endif
    
  if cStat == 'excl'
    ExclRegi ()
  endif
    
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Caix    with cCaix
        replace Lcto    with cLcto
        replace Dcto    with cDcto
        dbunlock ()
      endif
    endif  
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Movi       with dMovi
      replace ValM       with nValM
      replace Hist       with cHist
      dbunlock ()
    endif
  endif
enddo

if eOpenLcto
  select LctoARQ
  close
endif  

if eOpenCaix
  select CaixARQ
  close
endif 

if eOpenExtr
  select ExtrARQ
  close
endif  
return NIL 

//
// Verifica o Ultimo Documento Cadastrado 
//
function UltExtr( pCod, pLcto )
  local lAchou := .f.
  local nRegi  := recno ()

  select ExtrARQ
  set order to 1
  dbseek( pCod + strzero( pLcto, 6 ), .t. )
  do while Caix == pCod .and. Lcto == strzero( pLcto, 6 )
    lAchou := .t.

    dbskip ()
  enddo  
    
  if lAchou 
    dbskip(-1)

    MostExtr()
  else
    go nRegi  
  endif  
return(.t.)

//
// Entra Dados do Lancamento de Movimento
//
function EntrExtr()
  if empty( dMovi ) 
    dMovi := date()
  endif  
 
  setcolor ( CorJanel + ',' + CorCampo )
  @ 12,27 get dMovi       pict '99/99/9999'
  @ 13,27 get nValM       pict '@E 999,999,999,999.99'
  @ 14,27 get cHist       pict '@S40'
  read
return NIL

//
// Mostra Dados do Lancamento do movimento
//
function MostExtr()
  setcolor ( CorCampo )
  if cStat != 'incl'
    cCod := Caix
    cCaix := Caix
    cLcto := Lcto
    nlcto := val ( Lcto )
    cDcto := Dcto
    cDocu := Dcto

    @ 07,27 say cCaix
    @ 07,43 say CaixARQ->Nome
    @ 08,27 say nLcto         pict '999999'
    @ 08,34 say LctoARQ->Nome
    @ 09,27 say cDcto
  endif

  dMovi := Movi
  nValM := ValM
  cHist := Hist

  setcolor ( CorCampo )
  @ 12,27 say dMovi       pict '99/99/9999'
  @ 13,27 say nValM       pict '@E 999,999,999,999.99'
  @ 14,27 say cHist       pict '@S40'
  
  @ 11,27 say ' Cr‚dito '
  @ 11,37 say ' Debito '
  
  setcolor( CorAltKC )
  @ 11,28 say 'C'
  @ 11,38 say 'D'
  
  select LctoARQ
  set order to 1
  dbseek( cLcto, .f. )
  
  select ExtrARQ
     
  do case
    case LctoARQ->Tipo == 'C'
      setcolor( CorOpcao );   @ 11,27 say ' Cr‚dito '
      setcolor( CorAltKO );   @ 11,28 say 'C'
    case LctoARQ->Tipo == 'D'
      setcolor( CorOpcao );   @ 11,37 say ' D‚bito '
      setcolor( CorAltKO );   @ 11,38 say 'D'
  endcase   
  
  PosiDBF( 05, 74 )
return NIL

//
// Imprime Dados dos Extratos
//
function PrinExtr( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "SaldARQ", .t. )
      VerifIND( "SaldARQ" )

      #ifdef DBF_NTX
        set index to SaldIND1
      #endif
    endif

    if NetUse( "LctoARQ", .t. )
      VerifIND( "LctoARQ" )

      #ifdef DBF_NTX
        set index to LctoIND1, LctoIND2
      #endif
    endif

    if NetUse( "CaixARQ", .t. )
      VerifIND( "CaixARQ" )

      #ifdef DBF_NTX
        set index to CaixIND1, CaixIND2
      #endif
    endif

    if NetUse( "ExtrARQ", .t. )
      VerifIND( "ExtrARQ" )

      #ifdef DBF_NTX
        set index to ExtrIND1, ExtrIND2, ExtrIND3
      #endif
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 08, 06, 12, 72, mensagem( 'Janela', 'PrinExtr', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,08 say ' Conta Caixa ' 
  @ 11,08 say 'Data Inicial                 Data Final'       
    
  select CaixARQ
  dbgotop ()
  cCaix    := space(15)
  dDataIni := date()
  dDataFin := date()

  setcolor( CorCampo )
  @ 10,37 say space(30)       

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,21 get cCaix           pict '@K'  valid ValidARQ( 10, 21, "CaixARQ", "Conta", "Caix", "Descrição", "Nome", "Caix", "cCaix", .f., 15, "Conta Corrente", "CaixARQ", 40 )
  @ 11,21 get dDataIni        pict '99/99/9999'
  @ 11,48 get dDataFin        pict '99/99/9999' valid dDataFin >= dDataIni
  read

  if lastkey() == K_ESC
    select ExtrARQ
    if lAbrir
      close
      select LctoARQ
      close
      select CaixARQ
      close
      select SaldARQ
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

  nTotalD  := nSaldAnt  := 0
  nTotalC  := nSaldMovi := 0
  cCaixIni := cCaix
  aSaldo   := {}
  lInicio  := .t.
  cDataIni := dtos( dDataIni )
  cDataFin := dtos( dDataFin )
    
  select SaldARQ
  set order to 1
  dbseek( cCaixIni, .t. )
  do while Caix == cCaixIni .and. !eof()
    if Data >= dDataIni
      exit
    endif 
    
    nSaldAnt := Sald
    dbskip ()
  enddo   
  
  select ExtrARQ
  set order    to 2
  set relation to Lcto into LctoARQ
  dbseek( cCaixIni + cDataIni, .t. )
  do while Movi >= dDataIni .and. Movi <= dDataFin .and. Caix == cCaixIni .and. !eof ()
    if lInicio 
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
      
      lInicio := .f.
    endif
      
    if nLin == 0
      Cabecalho ( 'Extrato', 132, 4 )
      CabExtr ()
    endif

    dData := Movi 
      
    @ nLin, 01 say Movi           pict '99/99/9999'
    @ nLin, 12 say Lcto           pict '999999'
    @ nLin, 19 say LctoARQ->Nome  pict '@S23'
    @ nLin, 46 say Dcto           pict '9999999999'
    @ nLin, 60 say Hist           pict '@S30'

    if LctoARQ->Tipo == 'C'        
      @ nLin, 92 say ValM         pict '@E 999,999,999.99'
    else  
      @ nLin,108 say ValM         pict '@E 999,999,999.99'
    endif  
    nLin ++

    if LctoARQ->Tipo == 'D'
      nSaldMovi -= Valm
      nTotalD   += ValM
    else
      nSaldMovi += Valm
      nTotalC   += ValM
    endif
      
    select SaldARQ
    set order to 1 
    dbseek( cCaixIni + dtos( dData ), .f. )
      
    if eof()
      if AdiReg()
        if RegLock()
          replace Caix   with cCaixIni
          replace Data   with dData
          replace Sald   with ( nSaldMovi + nSaldAnt )
          dbunlock ()
        endif
      endif  
    else  
      if RegLock()
        replace Sald   with ( nSaldMovi + nSaldAnt )
        dbunlock ()
      endif
    endif  

    select ExtrARQ
      
    if nLin >= pLimite
      Rodape(132) 

      cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
      cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

      set printer to ( cArqu2 )
      set printer on
    endif

    dbskip ()
  enddo
  
  if !lInicio
    nLin ++
    @ nLin,075 say '  Total do Dia'
    @ nLin,092 say nTotalC           pict '@E 999,999,999.99'
    @ nLin,108 say nTotalD           pict '@E 999,999,999.99'
      
    nLin += 2
    @ nLin,075 say 'Parcial do Dia'
    if nSaldMovi > 0
      @ nLin,092 say nSaldMovi       pict '@E 999,999,999.99'
    else  
      @ nLin,108 say nSaldMovi       pict '@E 999,999,999.99'
    endif  
    nLin ++

    @ nLin,075 say 'Saldo Anterior'
    if nSaldAnt > 0
      @ nLin,092 say nSaldAnt        pict '@E 999,999,999.99'
    else
      @ nLin,108 say nSaldAnt        pict '@E 999,999,999.99'
    endif
    nLin ++

    @ nLin,075 say '  Saldo do Dia'

    nSaldDia := nSaldAnt + nSaldMovi

    if nSaldDia > 0
      @ nLin,092 say nSaldDia      pict '@E 999,999,999.99'
    else
      @ nLin,108 say nSaldDia      pict '@E 999,999,999.99'
    endif
        
    Rodape(132)
  endif  
 
  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 132 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Extrato da Conta Corrente " + cCaixIni
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 132
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
  endif

  select ExtrARQ
  if lAbrir
    close
    select LctoARQ
    close
    select CaixARQ
    close
    select SaldARQ
    close
  else
    set order  to 1 
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabExtr ()
  @ 02, 00 say 'Caixa'
  @ 02, 06 say cCaixIni
  @ 02, 23 say CaixARQ->Nome
  @ 02, 54 say CaixARQ->Banc
  @ 02, 70 say CaixARQ->Agen
  @ 02, 95 say 'Periodo ' + dtoc( dDataIni ) + ' a ' + dtoc( dDataFin )
  @ 04, 01 say 'Data'
  @ 04, 12 say 'Lançamento'
  @ 04, 46 say 'N. Docto.'
  @ 04, 60 say 'Histórico'
  @ 04, 99 say 'Crédito          Débito'

  nLin := 06
return NIL