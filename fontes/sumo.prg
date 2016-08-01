//  Leve, Consumo de Veiculos
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

function Sumo( xAlte )

if NetUse( "CondARQ", .t. )
  VerifIND( "CondARQ" )
  
  lOpenCond := .t.

  #ifdef DBF_NTX
    set index to CondIND1, CondIND2
  #endif
else
  lOpenCond := .f.
endif

if NetUse( "VeicARQ", .t. )
  VerifIND( "VeicARQ" )

  lOpenVeic := .t.

  #ifdef DBF_NTX
    set index to VeicIND1, VeicIND2
  #endif
else
  lOpenVeic := .f.
endif

if NetUse( "SumoARQ", .t. )
  VerifIND( "SumoARQ" )

  lOpenSumo := .t.

  #ifdef DBF_NTX
    set index to SumoIND1, SumoIND2
  #endif
else
  lOpenSumo := .f.
endif

//  Variaveis de Entrada
cObse := space(40)
cVeic := space(04)
dData := ctod('  /  /  ')
cNota := space(06)
nKM   := nLitro := nValor := nCond := nNota := 0
nVeic := 0
cCond := space(02)

//  Tela Consumo
Janela ( 05, 14, 18, 67, mensagem( 'Janela', 'Sumo', .f. ), .t. )

setcolor ( CorJanel + ',' + CorCampo )
@ 07,17 say 'Veículo'
@ 08,17 say '   Data                         Nota'
    
@ 10,17 say '     KM                       Litros '

@ 12,17 say '  Valor'
@ 13,17 say '  Pgto.'

@ 15,17 say '   Obs.'

MostOpcao( 17, 16, 28, 43, 56 ) 
tSumo := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Consumo
select SumoARQ
set order to 1
if lOpenSumo
  dbgobottom ()
endif  
do while .t.
  select VeicARQ
  set order to 1
  
  select CondARQ 
  set order to 1

  select SumoARQ
  set order to 1
  set relation to Veic into VeicARQ, to Cond into CondARQ

  Mensagem('Sumo','Janela')
  
  restscreen( 00, 00, 23, 79, tSumo )
  cStat := space(4)
  MostSumo()
  
  if Demo ()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostSumo'
  cAjuda   := 'Sumo'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  @ 07,25 get nVeic             pict '999999'      valid ValidARQ( 07, 25, "SumoARQ", "Código" , "Veic", "Descrição", "Nome", "Veic", "nVeic", .t., 6, "Consulta de Veiculos", "VeicARQ", 40 )
  @ 08,25 get dData             pict '99/99/9999'
  @ 08,54 get nNota             pict '999999'
  read
       
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC
    exit
  endif
  
  cVeic := strzero( nVeic, 6 )
  cNota := strzero( nNota, 6 )
  
  //  Verificar existencia do Lancamento para Incluir ou Alterar
  select SumoARQ
  set order to 1
  dbseek( cVeic + dtos( dData ) + cNota, .f. )
  if eof()
    cStat :=  'incl'
  else
    cStat :=  'alte'
  endif

  Mensagem ('Sumo',cStat)
  
  MostSumo ()
  EntrSumo ()

  Confirmar( 17, 16, 28, 43, 56, 3 )

  if cStat == 'excl'
    ExclRegi ()
  endif

  if cStat == 'prin'
    PrinSumo(.f.)
  endif  
    
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Veic         with cVeic
        replace Data         with dData
        replace Nota         with cNota
        dbunlock ()
      endif
    endif
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace KM           with nKM  
      replace Litro        with nLitro
      replace Valor        with nValor
      replace Cond         with cCond
      replace Obse         with cObse
      dbunlock ()
    endif
  endif
enddo

if lOpenSumo
  select SumoARQ
  close 
endif

if lOpenCond
  select CondARQ
  close 
endif

if lOpenVeic
  select VeicARQ
  close 
endif

return NIL

//
// Entra Dados do Lancamento
//
function EntrSumo ()
  do while .t.
    lAlterou := .f.
    
    setcolor ( CorJanel + ',' + CorCampo )
    @ 10,25 get nKm         pict '@E 99999,999.9'
    @ 10,54 get nLitro      pict '@E 9,999.9' 
    @ 12,25 get nValor      pict '@E 999,999.99'
    @ 13,25 get nCond       pict '999999'         valid ValidARQ( 13, 25, "SumoARQ", "Código" , "Cond", "Descrição", "Nome", "Cond", "nCond", .t., 6, "Consulta Condiç”es de Pagamento", "CondARQ", 40 )
    @ 15,25 get cObse       
    read

    if nKm        != KM;          lAlterou := .t.
    elseif nLitro != Litro;       lAlterou := .t.
    elseif nValor != Valor;       lAlterou := .t.
    elseif nCond  != val( Cond ); lAlterou := .t.
    elseif cObse  != Obse;        lAlterou := .t.
    endif
    
    if !Saindo(lAlterou)
      loop
    endif
    exit  
  enddo  
  
  cCond := strzero( nCond, 6 )
return NIL

//
// Mostra Dados do Sumo 
//
function MostSumo ()

  setcolor ( CorCampo )
  if cStat != 'incl' 
    cVeic := Veic
    nVeic := val( Veic )
    dData := Data
    nNota := val( Nota )
    cNota := Nota

    @ 07,25 say nVeic             pict '999999'
    @ 07,32 say VeicARQ->Nome
    @ 08,25 say dData             pict '99/99/9999'
    @ 08,54 say nNota             pict '999999'
  endif
  
  nKm    := Km
  nLitro := Litro
  nValor := Valor
  nCond  := val( Cond )
  cCond  := Cond
  cObse  := Obse
      
  @ 10,25 say nKm         pict '@E 99999,999.9'
  @ 10,54 say nLitro      pict '@E 9,999.9' 
  @ 12,25 say nValor      pict '@E 999,999.99'
  @ 13,25 say nCond       pict '999999' 
  @ 13,32 say CondARQ->Nome 
  @ 15,25 say cObse       
  
  PosiDBF( 05, 67 )
return NIL

//
// Imprime dados do Consumo
//
function PrinSumo( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "CondARQ", .t. )
      VerifIND( "CondARQ" )

      #ifdef DBF_NTX
        set index to CondIND1, CondIND2
      #endif
    endif

    if NetUse( "VeicARQ", .t. )
      VerifIND( "VeicARQ" )

      #ifdef DBF_NTX
        set index to VeicIND1, VeicIND2
      #endif
    endif

    if NetUse( "SumoARQ", .t. )
      VerifIND( "SumoARQ" )

      #ifdef DBF_NTX
        set index to SumoIND1, SumoIND2
      #endif
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 06, 12, 10, 65, mensagem( 'Janela', 'PrinSumo', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,14 say 'Veiculo Inicial            Veiculo Final'            
  @ 09,14 say '   Data Inicial               Data Final'
  
  select VeicARQ
  set order to 1
  dbgotop()
  nVeicIni := val( Veic )
  dbgobottom()
  nVeicFin := val( Veic )

  select SumoARQ
  set order to 1
  dbgotop ()
  dDataIni := ctod('01/01/1900')
  dDataFin := ctod('31/12/2015')

  @ 08,30 get nVeicIni    pict '999999'        valid ValidARQ( 99, 99, "SumoARQ", "Código" , "Veic", "Descrição", "Nome", "Veic", "nVeicIni", .t., 6, "Consulta de Veiculos", "VeicARQ", 40 )    
  @ 08,55 get nVeicFin    pict '999999'        valid ValidARQ( 99, 99, "SumoARQ", "Código" , "Veic", "Descrição", "Nome", "Veic", "nVeicFin", .t., 6, "Consulta de Veiculos", "VeicARQ", 40 ) .and. nVeicFin >= nVeicIni
  @ 09,30 get dDataIni    pict '99/99/9999'
  @ 09,55 get dDataFin    pict '99/99/9999'    valid dDataFin >= dDataIni
  read
  
  if lastkey () == K_ESC
    select SumoARQ
    if lAbrir
      close
      select VeicARQ
      close
      select CondARQ
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
  lInicio  := .t.

  cVeicIni := strzero( nVeicIni, 6 )
  cVeicFin := strzero( nVeicFin, 6 )
  cVeicAnt := space(06)

  nTotalLT := nTotal   := 0

  select SumoARQ
  set order    to 1
  set relation to Cond into CondARQ, to Veic into VeicARQ
  dbseek( cVeicIni, .t. )
  do while Veic >= cVeicIni .and. Veic <= cVeicFin .and. !eof()
    if Data >= dDataIni .and. Data <= dDataFin
      if lInicio
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
        
        lInicio := .f.
      endif
        
      if nLin == 0
        Cabecalho( 'Consumo de Veiculo', 80, 3 )
        CabSumo()
      endif
    
      if Veic != cVeicAnt
        if !empty( cVeicAnt )
          nLin     ++
          nTotalKm := nKm - nKmAnt
          nMedia   := nTotalKm / nTotalLT
                
          @ nLin,06 say 'Dias'
          @ nLin,11 say dData - dDataAnt   pict '999'
          @ nLin,16 say 'KM'
          @ nLin,19 say nTotalKm           pict '@E 999,999.9'
          @ nLin,30 say 'Litros'
          @ nLin,37 say nTotalLT           pict '@E 99,999.9'
          @ nLin,47 say 'M‚dia'
          @ nLin,53 say nMedia             pict '@E 999.9'
          @ nLin,60 say 'Total'
          @ nLin,66 say nTotal             pict '@E 999,999.99'
      
          nTotalLT := nTotal   := 0
        endif
      
        cVeicAnt := Veic
        dDataAnt := Data
        nKmAnt   := Km   
      
        @ nLin,001 say Veic           pict '999999' 
        @ nLin,008 say VeicARQ->Nome
        @ nLin,050 say VeicARQ->Placa 
        nLin ++
      endif  
    
      dData := Data
      nKm   := Km
      
      @ nLin, 06 say Nota           pict '999999'
      @ nLin, 13 say Data
      @ nLin, 24 say KM             pict '@E 99999,999.9'
      @ nLin, 36 say Litro          pict '@E 9,999.9'
      @ nLin, 44 say Valor          pict '@E 999,999.99'
      @ nLin, 55 say Cond           pict '99' 
      @ nLin, 58 say CondARQ->Nome  pict '@S20'
      nLin ++
    
      nTotalLT += Litro
      nTotal   += Valor

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
    nLin     ++
    nTotalKm := nKm - nKmAnt
    nMedia   := nTotalKm / nTotalLT
               
    @ nLin,06 say 'Dias'
    @ nLin,11 say dData - dDataAnt   pict '999'
    @ nLin,16 say 'KM'
    @ nLin,19 say nTotalKm           pict '@E 999,999.9'
    @ nLin,30 say 'Litros'
    @ nLin,37 say nTotalLT           pict '@E 99,999.9'
    @ nLin,47 say 'M‚dia'
    @ nLin,53 say nMedia             pict '@E 999.9'
    @ nLin,60 say 'Total'
    @ nLin,66 say nTotal             pict '@E 999,999.99'
    Rodape(80)
  endif  
 
  set printer to
  set printer off
  set device  to screen

  if Imprimir( cArqu3, 80 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Relatório de Consumo"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
    close
  endif  

  select SumoARQ
  if lAbrir
    close
    select CondARQ
    close
    select VeicARQ
    close
  else
    set order to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
  return NIL
return NIL

function CabSumo ()
  @ 02,01 say 'Periodo ' + dtoc( dDataIni ) + ' a ' + dtoc( dDataFin )
  @ 03,01 say 'Veiculo                                          Placa'
  @ 04,01 say '     Nota   Data              KM  Litros      Valor Cond. Pagamento'

  nLin     := 6
  cVeicAnt := space(4)
retur NIL