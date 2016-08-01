//  Leve, Movimento do Caixa
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

function MoCa ()

if NetUse( "ContARQ", .t. )
  VerifIND( "ContARQ" )
  
  lOpenCont := .t.

  #ifdef DBF_NTX
    set index to ContIND1, ContIND2
  #endif
else
  lOpenCont := .f.
endif

if NetUse( "MoCaARQ", .t. )
  VerifIND( "MoCaARQ" )
  
  lOpenMoCa := .t.

  #ifdef DBF_NTX
    set index to MoCaIND1, MoCaIND2, MoCaIND3
  #endif
else
  lOpenMoCa := .f.
endif

//  Variaveis de Entrada para MoCa
cDcto := space (10)
nCont := 0
cCont := space (2)
cCalc := cTipo := space (1)
dMovi := date()
nValM := nSald := mSaldAnt := 0
cHist := space (30)

// Tela MoCa
Janela ( 07, 12, 18, 71, mensagem( 'Janela', 'MoCa', .f. ), .t. )

setcolor ( CorJanel )
@ 09,14 say '       Conta'
@ 10,14 say 'N. Documento'

@ 12,14 say '        Tipo  Crédito   Débito'
@ 13,14 say '        Data'
@ 14,14 say '       Valor'
@ 15,14 say '   Histórico'

MostOpcao ( 17, 14, 26, 47, 60 )
tMoca := savescreen( 00, 00, 23, 79 )

//  Lançamento do Movimento
select MoCaARQ
set order    to 1
set relation to Cont into ContARQ
dbgobottom ()

do while  .t.
  select ContARQ
  set order to 1
  
  select MoCaARQ
  set order    to 1
  set relation to Cont into ContARQ

  Mensagem ('MoCa','Janela')

  cStat := space(4)
  restscreen( 00, 00, 23, 79, tMoCa )
  MostMoCa()
  
  if Demo ()
    exit
  endif  

  //  Verificar Departamento
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostMoca'
  cAjuda   := 'MoCa'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to ConsMoCa()

  @ 09,27 get cCont   pict '@K!'            valid ValidARQ( 09, 27, "MoCaARQ", "Codigo", "Cont", "Descrição", "Nome", "Cont", "cCont", .f., 17, "Contas", "ContARQ", 25,,1 )
  @ 10,27 get cDcto   pict '@K!' 
  read
    
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 
  lAjud := .f.

  if lastkey() == K_ESC .or. cDcto == space(10)
    exit
  endif

  //  Verificar existencia do MoCa para Incluir, Alterar ou Excluir
  select MoCaARQ
  set order to 1
  dbseek( cCont + cDcto, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif

  Mensagem ('MoCa',cStat)
  
  MostMoCa()
  EntrMoCa()

  Confirmar ( 17, 14, 26, 47, 60 , 3 )

  if cStat == 'prin'
    PrinMoCa (.f.)
  endif
    
  if cStat == 'excl'
    ExclRegi ()
  endif
    
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Cont    with cCont
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

if lOpenCont
  select ContARQ
  close
endif  

if lOpenMoCa
  select MoCaARQ
  close
endif  

return NIL

//
// Verifica o Ultimo Documento Cadastrado 
//
function UltDcto ( pCont )
  local lAchou := .f.
  local nRegi  := recno ()

  select MoCaARQ
  set order to 1
  dbseek( pCont, .t. )
  do while Cont == pCont
    lAchou := .t.

    dbskip ()
  enddo  
    
  if lAchou 
    dbskip(-1)

    MostMoCa()
  else
    go nRegi  
  endif  
return(.t.)

//
// Entra Dados do Lancamento de movimento
//
function EntrMoCa()
  local GetList := {}
  
  if cStat == 'incl'
    dMovi := date()
  endif  
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ 13,27 get dMovi       pict '99/99/9999'
  @ 14,27 get nValM       pict '@E 999,999,999.99'
  @ 15,27 get cHist       pict '@S40'
  read
return NIL

//
// Mostra Dados do Lancamento do movimento
//
function MostMoCa()
  setcolor( CorCampo )
  if cStat != 'incl'
    cCont := Cont
    cDcto := Dcto
    cTipo := ContARQ->Tipo
    
    @ 09,27 say cCont
    @ 09,45 say ContARQ->Nome     pict '@S25'
    @ 10,27 say cDcto

    @ 12,27 say ' Cr‚dito '
    @ 12,37 say ' D‚bito '
  
    do case 
      case cTipo == 'C'
        setcolor ( CorOpcao )
        @ 12,27 say ' Cr‚dito '

        setcolor ( CorAltKO )
        @ 12,28 say 'C'
      case cTipo == 'D'
        setcolor ( CorOpcao )
        @ 12,37 say ' D‚bito '

        setcolor ( CorAltKO )
        @ 12,38 say 'D'
    endcase
   endif

  dMovi    := Movi
  nValM    := ValM
  cHist    := Hist

  setcolor ( CorCampo )
  @ 13,27 say dMovi       pict '99/99/9999'
  @ 14,27 say nValM       pict '@E 999,999,999.99'
  @ 15,27 say cHist       pict '@S40'
  
  PosiDBF( 07, 71 )
return NIL

//
// Imprime dados do Movimento de Caixa
//
function PrinMoCa( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "ContARQ", .t. )
      VerifIND( "ContARQ" )

      #ifdef DBF_NTX
        set index to ContIND1, ContIND2
      #endif
    endif


    if NetUse( "MoCaARQ", .t. )
      VerifIND( "MoCaARQ" )

      #ifdef DBF_NTX
        set index to MoCaIND1, MoCaIND2, MoCaIND3
      #endif
    endif
  endif  

  if NetUse( "SaldARQ", .t. )
    VerifIND( "SaldARQ" )

    #ifdef DBF_NTX
      set index to SaldIND1
    #endif
  endif

  tPrt := savescreen( 00, 00, 23, 79 )
  
  //  Define Intervalo
  Janela ( 09, 33, 12, 52, mensagem( 'Janela', 'PrinMoCa', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 11,36 say 'Data'
  
  select MoCaARQ
  set order to 1
  dbgotop ()

  dDataIni := date()

  @ 11,41 get dDataIni  pict '99/99/9999'
  read

  if lastkey() == K_ESC
    select MoCaARQ
    if lAbrir
      close
      select ContARQ
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

  nPag      := 1
  nLin      := 0
  cArqu2    := cArqu2 + "." + strzero( nPag, 3 )
  lInicio   := .t.

  cContAnt  := space(06)
  nSaldAnt  := nTotaRece := nTotaDesp := 0
  nSaldAtua := 0
  nTotal    := 0

  select SaldARQ
  set order to 1
  dbgotop()
  do while !eof ()
    if Data >= dDataIni .and. alltrim( Caix ) == 'CAIXA'
      exit
    endif  

    nSaldAnt := Sald 

    dbskip ()
  enddo

  select ContARQ
  set order    to 1
  
  select MoCaARQ   
  set order    to 2
  set relation to Cont into ContARQ
  dbseek( dtos( dDataIni ), .f. )
  do while Movi == dDataIni .and. !eof()
    if ContARQ->Tipo == 'R'
      nTotal += ValM
    endif  
    dbskip ()
  enddo     

  dbseek( dtos( dDataIni ), .f. )
  do while Movi == dDataIni .and. !eof()
    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
      
      lInicio := .f.
    endif  
 
    if nLin == 0
      Cabecalho ( 'Movimento de Caixa - ' + dtoc( dDataIni ), 132, 4 )
      CabMoCa ()
    endif

    dData := Movi

    if Cont != cContAnt
      @ nLin, 01 say Cont
      @ nLin, 19 say ContARQ->Nome pict '@S20'       

      cContAnt := Cont
    endif

    @ nLin, 46 say Hist             pict '@S30'
    @ nLin, 78 say Dcto             pict '@S12'

    if ContARQ->Tipo == 'C'
      @ nLin,092 say ValM           pict '@E 999,999,999.99'

      nSaldAtua += ValM
      nTotaRece += ValM
    else 
      if nTotal == 0
        nPerc   := 0
      else  
        nPerc   := ( ValM * 100 ) / nTotal
      endif  
      nSaldAtua -= ValM
      nTotaDesp += ValM

      @ nLin,108 say ValM         pict '@E 999,999,999.99'
      @ nLin,124 say nPerc        pict '@E 999.99'
    endif  
    nLin ++
                          
    select SaldARQ
    set order to 1
    dbseek( 'CAIXA' + dtos( dData ), .f. )
    if eof()
      if AdiReg()
        if RegLock()
          replace Caix   with 'CAIXA'
          replace Data   with dData
          replace Sald   with ( nSaldAtua + nSaldAnt )
          dbunlock () 
        endif
      endif  
    else  
      if RegLock()
        replace Sald   with ( nSaldAtua + nSaldAnt )
        dbunlock ()
      endif
    endif  

    select MoCaARQ           

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
    nLin  += 2
    if nTotal == 0
      nPerc := 0
    else  
      nPerc := ( nTotaDesp * 100 ) / nTotal
    endif  

    @ nLin,075 say '  Total do Dia'
    @ nLin,092 say nTotaRece       pict '@E 999,999,999.99'
    @ nLin,108 say nTotaDesp       pict '@E 999,999,999.99'
    @ nLin,124 say nPerc           pict '@E 999.99'
    nLin ++

    @ nLin,075 say 'Saldo Anterior'
    if nSaldAnt > 0
      @ nLin,092 say nSaldAnt      pict '@E 999,999,999.99'
    else
      @ nLin,108 say nSaldAnt      pict '@E 999,999,999.99'
    endif
    nLin ++

    @ nLin,075 say '  Saldo do Dia'

    nSaldDia := nSaldAnt + nSaldAtua
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
      replace Titu       with "Relatório do Movimento do Caixa - " + dtoc( dDataIni )
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 132
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
  endif

  select SaldARQ
  close
  
  select MoCaARQ
  if lAbrir
    close
    select ContARQ
    close
  else
    set order  to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabMoCa ()
  @ 02,001 say 'Conta                                         Histórico                      N. Docto.           Cr‚dito         D‚bito    Perc.'

  nLin     := 05
  cContAnt := space(06)
return NIL

//
// Relatorio de Saldo de Contas
//
function PrinSald()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "ContARQ", .t. )
    VerifIND( "ContARQ" )

    #ifdef DBF_NTX
      set index to ContIND1, ContIND2
    #endif
  endif

  if NetUse( "MoCaARQ", .t. )
    VerifIND( "MoCaARQ" )

    #ifdef DBF_NTX
      set index to MoCaIND1, MoCaIND2, MoCaIND3
    #endif
  endif

  tPrt := savescreen( 00, 00, 23, 79 )
  
  //  Define Intervalo
  Janela ( 07, 11, 12, 75, mensagem( 'Janela', 'PrinSald', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 09,13 say ' Data Inicial                    Data Final'       
  @ 10,13 say 'Conta Inicial                   Conta Final'
  @ 11,13 say '    Histórico  Sim   Não'

  setcolor( CorCampo )
  @ 11,27 say ' Sim '
  @ 11,33 say ' Não '

  setcolor( 'gr+/w' )
  @ 11,28 say 'S'
  @ 11,34 say 'N'
  
  select ContARQ
  set order to 1
  dbgotop()
  cContIni := Cont 
  dbgobottom()
  cContFin := Cont 
 
  select MoCaARQ
  set order to 1
  dbgotop ()
  
  dDataIni := ctod( '01/01/1900')
  dDataFin := ctod( '31/12/2015')
  nHist    := 1
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ 09,27 get dDataIni      pict '99/99/9999'
  @ 09,57 get dDataFin      pict '99/99/9999'
  @ 10,27 get cContIni      pict '@!'  valid ValidARQ( 99, 99, "MoCaARQ", "Codigo", "Cont", "Descrição", "Nome", "Cont", "cContIni", .f., 17, "Consulta de Contas", "ContARQ", 40 )
  @ 10,57 get cContFin      pict '@!'  valid ValidARQ( 99, 99, "MoCaARQ", "Codigo", "Cont", "Descrição", "Nome", "Cont", "cContFin", .f., 17, "Consulta de Contas", "ContARQ", 40 ) .and. cContFin >= cContIni
  read

  if lastkey() == K_ESC
    select MoCaARQ
    close
    select ContARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  nHist := iif( ConfLine( 11, 27, 2 ), 1, 2 )

  if lastkey() == K_ESC
    select MoCaARQ
    close
    select ContARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  Aguarde ()

  nPag   := 1
  nLin   := 0
  cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

  nTotaCont := 0
  cCont     := space(06)
  cContAnt  := space(06)
  
  lVez      := .f.
  lInicio   := .t.

  aCont     := {}
  nTotaGera := 0

  select ContARQ
  set order to 1
  
  select MoCaARQ   
  set order    to 3 
  set relation to Cont into ContARQ
  dbseek( cContIni, .t. )  
  do while !eof ()
    if Cont >= cContIni .and. Cont <= cContFin .and.;
       Movi >= dDataIni .and. Movi <= dDataFin
     
       nElemCont := ascan( aCont, { |nElem| nElem[1] == Cont } )
       
       if nElemCont > 0
         aCont[ nElemCont, 3 ] += ValM         
         nTotaGera             += ValM                     
       else
         nTotaGera += ValM                     

         aadd( aCont,{ Cont, ContARQ->Tipo, ValM } )
       endif 
    endif
    dbskip ()
  enddo

  select MoCaARQ   
  set order    to 3 
  set relation to Cont into ContARQ
  dbseek( cContIni, .t. )  
  do while !eof ()
    if Cont >= cContIni .and. Cont <= cContFin .and.;
       Movi >= dDataIni .and. Movi <= dDataFin
       
      if lInicio
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
        
        lInicio := .f.
      endif     
    
      if nLin == 0
        Cabecalho ( 'Saldo do Caixa', 132, 4 )
        CabSald( nHist )
      endif
    
      if cContAnt != Cont
        if cContAnt != space(06)
          @ nLin,055 say '    Total por Conta' 
          if cTipoAnt == 'R'
            @ nLin,075 say nTotaCont     pict '@E 999,999,999.99'
          else  
            @ nLin,090 say nTotaCont     pict '@E 999,999,999.99'
          endif  

          nPerc     := ( nTotaCont * 100 ) / nTotaGera 
          nTotaCont := 0
                 
          @ nLin,105 say nPerc           pict '@E 999.99'
          nLin ++
        endif
    
        cContAnt := Cont
        cTipoAnt := ContARQ->Tipo
        nLin ++
        @ nLin, 01 say Cont
        @ nLin, 20 say ContARQ->Nome
        nLin ++
      endif  
      
      if nHist == 1
        nLin ++
        @ nLin, 07 say Movi          pict '99/99/9999'
        @ nLin, 18 say Dcto          
        @ nLin, 34 say Hist          pict '@S40' 
        if cTipoAnt == 'R'
          @ nLin,075 say ValM        pict '@E 999,999,999.99'
        else  
          @ nLin,090 say ValM        pict '@E 999,999,999.99'
        endif  

        nPerc := ( ValM * 100 ) / aCont[ ascan( aCont, { |nElem| nElem[1] == cContAnt } ), 3 ]

        @ nLin,105 say nPerc           pict '@E 999.99'
      endif
      
      nTotaCont += ValM
      cCont     := Cont
      nVez      := .t.
    endif
    
    dbskip ()
  enddo
  
  if !lInicio
    if nHist == 1
      nLin ++
    endif  
        
    @ nLin,055 say '    Total por Conta' 
    if cTipoAnt == 'R'
      @ nLin,075 say nTotaCont     pict '@E 999,999,999.99'
    else  
      @ nLin,090 say nTotaCont     pict '@E 999,999,999.99'
    endif  
    nPerc := ( nTotaCont * 100 ) / nTotaGera
    @ nLin,105 say nPerc           pict '@E 999.99'

    Rodape(132)
  endif  
 
  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 132 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Relatório do Saldo do Caixa " + dtoc( dDataIni ) + " - " + dtoc( dDataFin )
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 132
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
  endif

  select MoCaARQ
  close
  select ContARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabSald ( nHist )
  @ 02,01 say 'Periodo ' + dtoc( dDataIni ) + ' a ' + dtoc( dDataFin )
  if nHist == 2
    @ 03,01 say 'Conta                                                                           Cr‚dito        D‚bito    Perc.'

    nLin := 05
  else   
    @ 03,01 say 'Conta'
    @ 04,01 say '       Data      Documento       Historico                                      Cr‚dito        D‚bito    Perc.'

    nLin := 05
  endif  

  cContAnt := space(06)
return NIL

//
//  Relatorio Comparativo
//
function PrinComp ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "ContARQ", .t. )
    VerifIND( "ContARQ" )

    #ifdef DBF_NTX
      set index to ContIND1, ContIND2
    #endif
  endif

  if NetUse( "MoCaARQ", .t. )
    VerifIND( "MoCaARQ" )

    #ifdef DBF_NTX
      set index to MoCaIND1, MoCaIND2, MoCaIND3
    #endif
  endif

  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 06, 23, 09, 53, mensagem( 'Janela', 'PrinComp', .f. ), .f. )

  setcolor( CorCampo )
  @ 08,32 say aMesExt[ month( date() ) ]

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,25 say 'Mˆs'

  select MocaARQ
  dbgotop ()
  nMes := month( date() )
  
  @ 08,29 get nMes       pict '99'   valid ValidMes( 08, 29, nMes )
  read

  if lastkey() == K_ESC
    select MoCaARQ
    close
    select ContARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  Aguarde ()
  if nMes == 1
    dMesAntIni := ctod( '01' + '/' + '12' + '/' + substr( strzero( year( date() ) - 1, 4 ), 3, 2 ) )
    dMesAntFin := eom( dMesAntIni )

    dMesIni := ctod( '01' + '/' + strzero( nMes, 2 ) + '/' + substr( strzero( year( date() ), 4 ), 3, 2 ) )
    dMesFin := eom( dMesIni )
  else  
    dMesAntIni := ctod( '01' + '/' + strzero( nMes - 1, 2 ) + '/' + substr( strzero( year( date() ), 4 ), 3, 2 ) )
    dMesAntFin := eom( dMesAntIni )

    dMesIni := ctod( '01' + '/' + strzero( nMes, 2 ) + '/' + substr( strzero( year( date() ), 4 ), 3, 2 ) )
    dMesFin := eom( dMesIni )
  endif

  nPag   := 1
  nLin   := 0
  cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

  nTotAntDesp := nTotARece := 0
  nTotalDesp  := nTotalRece  := 0
  nMesAnt     := nMesAtu     := 0
  nTotChqAnt  := nTotChqAtu  := 0
  nTotDepAnt  := nTotDepAtu  := 0
  aContas     := {}
  lInicio     := .t.
  
  select ContARQ
  set order to 1
  dbgotop ()
  do while !eof()  
    aadd( aContas, { Cont, Nome, Tipo, 0, 0 } )
    dbskip ()
  enddo
  
  // Posiciona Mes Anterior

  select MoCaARQ 
  set order    to 2
  set relation to Cont into ContARQ
  dbseek( dtos( dMesAntIni ), .t. )
  do while Movi >= dMesAntIni .and. Movi <= dMesAntFin .and. !eof()
    cCont     := Cont
    nElemCont := ascan( aContas, { |nElem| nElem[1] == cCont } )

    if ContARQ->Tipo == 'D'
      nTotAntDesp += ValM
    else
      nTotARece += ValM
    endif
       
    if nElemCont > 0
      aContas[ nElemCont, 4 ] += ValM
    endif
       
    dbskip ()     
  enddo  
    
  // Posiciona Mes Corrente
  
  dbseek( dtos( dMesIni ), .t. )
  do while Movi >= dMesIni .and. Movi <= dMesFin .and. !eof()
    cCont     := Cont
    nElemCont := ascan( aContas, { |nElem| nElem[1] == cCont } )
       
    if nElemCont > 0
      aContas[ nElemCont, 5 ] += ValM
    endif
       
    if ContARQ->Tipo == 'D'
      nTotalDesp += ValM
    else
      nTotalRece += ValM
    endif

    dbskip ()    
  enddo  
  
  if ( ( nTotalRece + nTotalDesp ) + ( nTotARece + nTotAntDesp ) ) > 0
    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
    
      lInicio := .f.
    endif  
  
    Cabecalho ( 'Comparativo do Caixa', 132, 4 )
    CabComp()
      
    nMaior := iif( nTotARece > nTotalRece, nTotARece, nTotalRece )
    nMenor := iif( nTotARece < nTotalRece, nTotARece, nTotalRece )

    if nMenor == 0
      nPerc := 0
    else  
      nPerc := nMaior / nMenor
    endif  
  
    @ nLin,01 say 'Receitas'
    @ nLin,35 say nTotARece        pict '@E 999,999,999.99'
    @ nLin,58 say nTotalRece         pict '@E 999,999,999.99'
    @ nLin,87 say nPerc              pict '@E 999.99'
    @ nLin,94 say '%'

    nLin += 2
    for nI := 1 to len( aContas  )
      cCont   := aContas[ nI, 1 ]
      cNome   := aContas[ nI, 2 ]
      cTipo   := aContas[ nI, 3 ]
      nMesAnt := aContas[ nI, 4 ]
      nMesAtu := aContas[ nI, 5 ]
    
      if ( nMesAnt + nMesAtu ) == 0
        loop
      endif  

      nMaior := iif( nMesAnt > nMesAtu, nMesAnt, nMesAtu )
      nMenor := iif( nMesAnt < nMesAtu, nMesAnt, nMesAtu )

      if nTotARece > 0
        nPercAnt := ( nMesAnt * 100 ) / nTotARece
      else 
        nPercAnt := 0     
      endif
         
      if nTotalRece > 0   
        nPercMes := ( nMesAtu * 100 ) / nTotalRece
      else 
        nPercMes := 0     
      endif       

      if nMenor == 0
        nPerc := 0
      else  
        nPerc := nMaior / nMenor
      endif  
      
      if cTipo == 'R'
        @ nLin,01 say cCont
        @ nLin,08 say cNome          pict '@S16'
        @ nLin,35 say nMesAnt        pict '@E 999,999,999.99'
        @ nLin,50 say nPercAnt       pict '@E 999.99'
        @ nLin,57 say '%'
        @ nLin,58 say nMesAtu        pict '@E 999,999,999.99'
        @ nLin,73 say nPercMes       pict '@E 999.99'  
        @ nLin,80 say '%'
        @ nLin,87 say nPerC          pict '@E 999.99'
        @ nLin,94 say '%'
 
        nLin ++
      endif  
    next
   
    nMaior := iif( nTotAntDesp > nTotalDesp, nTotAntDesp, nTotalDesp )
    nMenor := iif( nTotAntDesp < nTotalDesp, nTotAntDesp, nTotalDesp )

    if nMenor == 0
      nPerc := 0
    else  
      nPerc := nMaior / nMenor
    endif  
  
    @ nLin,01 say 'Despesas'
    @ nLin,35 say nTotAntDesp        pict '@E 999,999,999.99'
    @ nLin,58 say nTotalDesp         pict '@E 999,999,999.99'
    @ nLin,87 say nPerc              pict '@E 999.99'
    @ nLin,94 say '%'

    nLin += 2
    for nI := 1 to len( aContas  )
      cCont   := aContas[ nI, 1 ]
      cNome   := aContas[ nI, 2 ]
      cTipo   := aContas[ nI, 3 ]
      nMesAnt := aContas[ nI, 4 ]
      nMesAtu := aContas[ nI, 5 ]

      nMaior   := iif( nMesAnt > nMesAtu, nMesAnt, nMesAtu )
      nMenor   := iif( nMesAnt < nMesAtu, nMesAnt, nMesAtu )

      if nTotAntDesp > 0
        nPercAnt := ( nMesAnt * 100 ) / nTotAntDesp 
      else 
        nPercAnt := 0     
      endif
   
      if nTotalDesp > 0   
        nPercMes := ( nMesAtu * 100 ) / nTotalDesp
      else 
        nPercMes := 0     
      endif       

      if nMenor == 0
        nPerc := 0
      else  
        nPerc := nMaior / nMenor
      endif  
    
      if ( nMesAnt + nMesAtu ) == 0
        loop
      endif  
     
      if cTipo == 'D'
        @ nLin,01 say cCont
        @ nLin,08 say cNome          pict '@S18'
        @ nLin,35 say nMesAnt        pict '@E 999,999,999.99'
        @ nLin,50 say nPercAnt       pict '@E 999.99'
        @ nLin,57 say '%'
        @ nLin,58 say nMesAtu        pict '@E 999,999,999.99'
        @ nLin,73 say nPercMes       pict '@E 999.99'  
        @ nLin,80 say '%'
        @ nLin,87 say nPerC          pict '@E 999.99'
        @ nLin,94 say '%'

        nLin ++
      endif
    next
    
    Rodape (132 )
  endif  
 
  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 132 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Relatório do Comparativo do Caixa"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 132
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
  endif

  select MoCaARQ
  close
  select ContARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabComp()
  nLin := 2
      
  if nMes == 1
    @ nLin,35 say alltrim( aMesExt[ 12 ] )   + '/' + substr( strzero( year( date() ) -1, 4 ), 3, 2 ) 
    @ nLin,58 say alltrim( aMesExt[ nMes ] ) + '/' + substr( strzero( year( date() ),    4 ), 3, 2 ) 
  else  
    @ nLin,35 say alltrim( aMesExt[ nMes - 1 ] ) + '/' + substr( strzero( year( date() ), 4 ), 3, 2 ) 
    @ nLin,58 say alltrim( aMesExt[ nMes ] ) + '/' + substr( strzero( year( date() ), 4 ), 3, 2 ) 
  endif  
  @ nLin,87 say 'Perc.'
  nLin ++
  @ nLin, 01 say 'Lucro' 
  @ nLin, 35 say nTotAntRec - nTotAntDesp        pict '@E 999,999,999.99'
  @ nLin, 58 say nTotalRece - nTotalDesp         pict '@E 999,999,999.99'
  
  nTotAnt  := nTotAntRec - nTotAntDesp 
  nTotAtu  := nTotalRece - nTotalDesp 
  nMaior   := iif( nTotAnt > nTotAtu, nTotAnt, nTotAtu )
  nMenor   := iif( nTotAnt < nTotAtu, nTotAnt, nTotAtu )

  if nMaior == 0
    nPerc  := 0
  else 
    nPerc  := nMenor / nMaior
  endif  
  
  @ nLin,87 say nPerc                           pict '@E 999.99'
    
  nLin += 2
return NIL

//
// Consulta com os Lançamento cadastrados
//
function ConsMoca ()

  tVerMoCa := savescreen( 00, 00, 24, 79 )
  lOk      := .f.
  lMuda    := .f.
  cFile    := alias()

  select MoCaARQ

  Janela( 03, 01, 16, 76, mensagem( 'Janela', 'ConsMoCa', .f. ), .f. )  
  setcolor( CorJanel + "," + CorCampo )
  oMoCa           := TBrowseDB( 05, 02, 16, 75 )
  oMoCa:headsep   := chr(194)+chr(196)
  oMoCa:colsep    := chr(179)
  oMoCa:footsep   := chr(193)+chr(196)
  oMoCa:colorSpec := CorJanel
 
  oMoCa:addColumn( TBColumnNew( "Conta",     {|| left( ContARQ->Nome, 10 ) + " " + Cont } ) )
  oMoCa:addColumn( TBColumnNew( "N. Dcto.",  {|| left( Dcto, 10 ) } ) )
  oMoCa:addColumn( TBColumnNew( "Data",      {|| Movi } ) )
  oMoCa:addColumn( TBColumnNew( "Valor",     {|| transform( ValM, "@E 99,999.99" ) } ) )
  oMoCa:addColumn( TBColumnNew( " ",         {|| ContARQ->Tipo } ) )
  oMoCa:addColumn( TBColumnNew( "Histórico", {|| left( Hist, 15 ) } ) )
  oMoCa:gobottom()

  lExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ""
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 04, 16, 76, nTotal )
  
  @ 06,01 say chr(195)

  do while !lExitRequested
    Mensagem( 'MoCa', 'ConsMoCa' ) 

    oMoCa:forcestable()
    
    PosiDBF( 03, 76 )
    
    cTecla := Teclar(0)

    iif( BarraSeta, BarraSeta( nLinBarra, 04, 16, 76, nTotal ), NIL )
       
    do case
      case cTecla == K_DOWN .or. cTecla == K_PGDN .or. cTecla == K_CTRL_PGDN
        if !oMoCa:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif
        endif
      case cTecla == K_UP .or. cTecla == K_PGUP .or. cTecla == K_CTRL_PGUP
        if !oMoCa:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif
        endif
    endcase
      
    do case
      case cTecla == K_LEFT;       oMoCa:left()
      case cTecla == K_RIGHT;      oMoCa:right()
      case cTecla == K_DOWN;       oMoCa:down()
      case cTecla == K_UP;         oMoCa:up()
      case cTecla == K_PGDN;       oMoCa:pageDown()
      case cTecla == K_PGUP;       oMoCa:pageUp()
      case cTecla == K_CTRL_PGUP;  oMoCa:goTop()
      case cTecla == K_CTRL_PGDN;  oMoCa:goBottom()
      case cTecla == K_ENTER;      lExitRequested := .t.
      case cTecla == K_ESC;        lExitRequested := .t.
    endcase
    
    select MoCaARQ
    set order to 1
  enddo
  
  restscreen( 00, 00, 24, 79, tVerMoCa )
  if ! empty( cFile )
    select ( cFile )
  endif
  setcolor ( CorJanel + "," + CorCampo )
  
  if cTecla == K_ENTER
    MostMoCa ()
  endif  
return NIL