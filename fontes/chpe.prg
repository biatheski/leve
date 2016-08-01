//  Leve, Cheques Emitidos  
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

function ChPE ()

if NetUse( "ChPEARQ", .t. )
  VerifIND( "ChPEARQ" )
  
  hOpenChPE := .t.
  
  #ifdef DBF_NTX
    set index to ChPEIND1, ChPEIND2, ChPEIND3, ChPEIND4
  #endif  
else
  hOpenChPE := .f.
endif

if NetUse( "BancARQ", .t. )
  VerifIND( "BancARQ" )
  
  hOpenBanc := .t.

  #ifdef DBF_NTX
    set index to BancIND1, BancIND2
  #endif  
else
  hOpenBanc := .f.
endif
 
if NetUse( "AgciARQ", .t. )
  VerifIND( "AgciARQ" )
  
  hOpenAgci := .t.

  #ifdef DBF_NTX
    set index to AgciIND1, AgciIND2
  #endif  
else
  hOpenAgci := .f.
endif

//  Variaveis de Entrada para Cheques pre-datados
nCheq := nBanc := nAgci := nValo := 0
cCheq := space(07)
dData := dVcto := dDepo := ctod('  /  /  ')
cHist := space(60)
cBanc := cAgci := space(04)
cCnta := space(15)

//  Tela Cheques pre-datados
Janela ( 05, 12, 18, 67, mensagem( 'Janela', 'ChPE', .f. ), .t. )

setcolor ( CorJanel )
@ 07,14 say ' N. Cheque                      Conta'
@ 09,14 say '     Banco'
@ 10,14 say '   Agência'
@ 12,14 say '     Vcto.                   Depósito'
@ 13,14 say '     Valor'
@ 15,14 say ' Histórico'

MostOpcao( 17, 14, 26, 43, 56 )
                   
tChPE := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Cheques
select ChPEARQ
set order    to 1
set relation to Banc into BancARQ, to Banc + Agci into AgciARQ
if hOpenChPE
  dbgobottom ()
endif  
do while  .t.
  Mensagem('ChPE','Janela')

  select BancARQ
  set order to 1
  
  select AgciARQ 
  set order to 1
  
  select ChPEARQ
  set order    to 1
  set relation to Banc into BancARQ, to Banc + Agci into AgciARQ

  cStat := space(04)
  restscreen( 00, 00, 23, 79, tChPE )
  MostChPE()
  
  if Demo ()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostChPE'
  cAjuda   := 'ChPE'
  lAjud    := .t.
    cCnta := Cont
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()

  @ 07,25 get nCheq        pict '9999999'
  @ 07,52 get cCnta        pict '@S13' 
  read
  
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC
    exit
  endif
  
  cCheq := strzero( nCheq, 7 )

  //  Verificar existencia do Cheques para Incluir, Alterar ou Excluir
  select ChPEARQ
  set order to 1
  dbseek( cCheq + cCnta )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif

  Mensagem ('ChPE',cStat )
  
  oStatAnt := cStat

  MostChPE()
  EntrChPE()
  
  cStat := oStatAnt
  
//if empty( dDepo )
//  Confirmar( 17, 14, 26, 43, 56, 1 )
//else  
    Confirmar( 17, 14, 26, 43, 56, 3 )
//endif  
  
  if cStat == 'excl'
    ExclRegi ()
  endif
  
  if lastkey() == K_ESC .or. cStat == 'loop'
    loop
  endif  
  
  if oStatAnt == 'incl'
    if AdiReg()
      if RegLock()
        replace Cheq          with cCheq
        replace Cont          with cCnta
        replace Data          with date()
        dbunlock ()
      endif  
    endif  
  endif

  if oStatAnt == 'incl' .or. oStatAnt == 'alte'
    if RegLock()
      replace Banc          with cBanc
      replace Agci          with cAgci
      replace Vcto          with dVcto
      replace Depo          with dDepo
      replace Valo          with nValo
      replace Hist          with cHist
      dbunlock ()
    endif
  endif
  
  if cStat == 'prin'
    ImprChPE ( .f. )
  endif
  
  if EmprARQ->Caixa == "X"
    dPgto := dDepo
    cNota := cCheq
    nPago := nValo
  
    DestLcto ()
  endif  
enddo

if hOpenChPE
  select ChPEARQ
  close
endif  

if hOpenAgci
  select AgciARQ
  close
endif  

if hOpenBanc
  select BancARQ
  close
endif  

return NIL

//
//  Dados do Cheques pre-datados
//
function EntrChPE()
  if empty( dVcto )
    dVcto := date()
  endif
  
  do while .t.
    lAlterou := .f.
  
    setcolor ( CorJanel + ',' + CorCampo )
    @ 09,25 get nBanc         pict '9999' valid ValidARQ( 09, 25, "ChPEARQ", "Código" , "Banc", "Descrição", "Nome", "Banc", "nBanc", .t., 4, "Consulta de Bancos", "BancARQ", 30 )
    @ 10,25 get nAgci         pict '9999' valid ValidAgci( 10, 25, "ChPEARQ", nBanc ) 
    @ 12,25 get dVcto         pict '99/99/9999'
    @ 12,52 get dDepo         pict '99/99/9999'
    @ 13,25 get nValo         pict '@E 999,999,999.99'
    @ 15,25 get cHist         pict '@S40'           
    read
    
    if nBanc      != val( Banc );  lAlterou := .t.
    elseif nAgci  != val( Agci );  lAlterou := .t.
    elseif dVcto  != Vcto;         lAlterou := .t.
    elseif dDepo  != Depo;         lAlterou := .t.
    elseif nValo  != Valo;         lAlterou := .t.
    elseif cHist  != Hist;         lAlterou := .t.
    endif
    
    if !Saindo (lAlterou)
      loop
    endif  
    exit
  enddo  

  cBanc := strzero( nBanc, 4 )
  cAgci := strzero( nAgci, 4 )
return NIL

//
// Mostra Dados do Cheques pre-datados
//
function MostChPE()
  setcolor ( CorCampo )
  if cStat != 'incl'
    cCheq := Cheq
    nCheq := val( cCheq )
    dData := Data
    cCnta := Cont
    
    @ 07,25 say cCheq
    @ 07,52 say cCnta        pict '@S13' 
  endif  
  
  nBanc := val( Banc )
  cBanc := Banc
  cAgci := Agci
  nAgci := val( Agci )
  dVcto := Vcto
  dDepo := Depo
  nValo := Valo
  cHist := Hist
  
  @ 09,25 say nBanc             pict '9999'
  @ 09,30 say BancARQ->Nome     pict '@S30'
  @ 10,25 say nAgci             pict '9999'
  @ 10,30 say AgciARQ->Nome     pict '@S30'
  @ 12,25 say dVcto           pict '99/99/9999'
  @ 12,52 say dDepo           pict '99/99/9999'
  @ 13,25 say nValo           pict '@E 999,999,999.99'
  @ 15,25 say cHist           pict '@S40'
  
  PosiDBF( 05, 67 )
return NIL

//
// Imprime Dados dos Cheques pre-datados
//
function PrinChPe( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "BancARQ", .t. )
      VerifIND( "BancARQ" )

      #ifdef DBF_NTX
        set index to BancIND1, BancIND2
      #endif    
    endif

    if NetUse( "AgciARQ", .t. )
      VerifIND( "AgciARQ" )

      #ifdef DBF_NTX
        set index to AgciIND1, AgciIND2
      #endif    
    endif

    if NetUse( "ChPeARQ", .t. )
      VerifIND( "ChPeARQ" )

      #ifdef DBF_NTX
        set index to ChPeIND1, ChPeIND2, ChPeIND3, ChPeIND4
      #endif    
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 05, 11, 16, 65, mensagem( 'Janela', 'PrinChPE', .f. ), .f. )
  setcolor ( CorJanel + ',' + CorCampo )
  @ 07,13 say '  Conta Inicial              Conta Final'
  @ 08,13 say ' Cheque Inicial             Cheque Final'
  @ 09,13 say '  Banco Inicial              Banco Final'
  @ 10,13 say 'Agência Inicial            Agência Final'
  @ 11,13 say '  Emis. Inicial              Emis. Final'
  @ 12,13 say '  Vcto. Inicial              Vcto. Final'
  @ 13,13 say 'Deposi. Inicial            Deposi. Final'
  
  @ 15,13 say '          Ordem'
 
  setcolor ( 'n/w+' )
  @ 15,57 say chr(25)

  setcolor( CorCampo )
  @ 15,29 say ' Vcto. + Banco + Agˆncia   '

  cCaixIni := '1' + space(14)
  cCaixFin := '9' + space(14)

  select BancARQ
  set order to 1
  dbgotop()
  nBancIni := val( Banc )
  dbgobottom()
  nBancFin := val( Banc )

  select ChPeARQ
  set order  to 1
  dbgobottom ()
  
  nAgciIni := 1
  nAgciFin := 9999
  nCheqIni := 1
  nCheqFin := 9999999
  
  dVctoIni := ctod( '01/01/1990' )
  dVctoFin := ctod( '31/12/2015' )
  dDepoIni := ctod( '  /  /  ' )
  dDepoFin := ctod( '  /  /  ' )
  dDataIni := ctod( '01/01/1990' )
  dDataFin := ctod( '31/12/2015' )
  
  @ 07,29 get cCaixIni           pict '@S10' 
  @ 07,54 get cCaixFin           pict '@S10'      valid cCaixFin >= cCaixIni
  @ 08,29 get nCheqIni           pict '9999999'
  @ 08,54 get nCheqFin           pict '9999999'   valid nCheqFin >= nCheqIni
  @ 09,29 get nBancIni           pict '9999'      valid ValidARQ( 99, 99, "ChPeARQ", "Código" , "Banc", "Descrição", "Nome", "Banc", "nBancIni", .t., 4, "Consulta de Bancos", "BancARQ", 30 ) 
  @ 09,54 get nBancFin           pict '9999'      valid ValidARQ( 99, 99, "ChPeARQ", "Código" , "Banc", "Descrição", "Nome", "Banc", "nBancFin", .t., 4, "Consulta de Bancos", "BancARQ", 30 ) .and. nBancFin >= nBancIni
  @ 10,29 get nAgciIni           pict '9999'
  @ 10,54 get nAgciFin           pict '9999'      valid nAgciFin >= nAgciIni
  @ 11,29 get dDataIni           pict '99/99/9999'
  @ 11,54 get dDataFin           pict '99/99/9999'  valid dDataFin >= dDataIni
  @ 12,29 get dVctoIni           pict '99/99/9999'
  @ 12,54 get dVctoFin           pict '99/99/9999'  valid dVctoFin >= dVctoIni
  @ 13,29 get dDepoIni           pict '99/99/9999'
  @ 13,54 get dDepoFin           pict '99/99/9999'  valid dDepoFin >= dDepoIni
  read

  if lastkey () == K_ESC
    select ChPeARQ
    if lAbrir
      close
      select BancARQ
      close
    else
      set order to 1 
      dbgobottom ()
    endif
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  aOpcao := {}
  
  aadd( aOpcao, { ' Cheque + Banco + Agˆncia  ', 2, 'C', 15, 29, "Relatório em ordem de cheque e banco e agência." } )
  aadd( aOpcao, { ' Emissão + Banco + Agˆncia ', 2, 'D', 15, 29, "Relatório em ordem de data de Entrada e banco e agência e cheque." } )
  aadd( aOpcao, { ' Vcto. + Banco + Agˆncia   ', 2, 'V', 15, 29, "Relatório em ordem de data de Vencimento e banco e agência e cheque." } )
  aadd( aOpcao, { ' Depósito + Banco + Agˆn.  ', 3, 'E', 15, 29, "Relatório em ordem de data de Deposito e banco e agência e cheque." } )

  nOrdem := HCHOICE( aOpcao, 4, 3 )
  
  Aguarde ()

  nPag     := 1
  nLin     := 0
  cArqu2   := cArqu2 + "." + strzero( nPag, 3 )
  lInicio  := .t.

  nQtde    := nTotaValo   := 0
  cBancIni := strzero( nBancIni, 4 )
  cBancFin := strzero( nBancFin, 4 )
  cAgciIni := strzero( nAgciIni, 4 )
  cAgciFin := strzero( nAgciFin, 4 )
  cCheqIni := strzero( nCheqIni, 7 )
  cCheqFin := strzero( nCheqFin, 7 )
                                                          //  Imprimir
  select ChPeARQ
  set order    to nOrdem
  set relation to Banc into BancARQ, to Banc + Agci into AgciARQ
  dbgotop ()
  do while !eof()
    if Banc >= cBancIni .and. Banc <= cBancFin .and.;
       Agci >= cAgciIni .and. Agci <= cAgciFin .and.;
       Cheq >= cCheqIni .and. Cheq <= cCheqFin .and.;
       Data >= dDataIni .and. Data <= dDataFin .and.;
       Vcto >= dVctoIni .and. Vcto <= dVctoFin .and.;
       Depo >= dDepoIni .and. Depo <= dDepoFin .and.;
       Cont >= cCaixIni .and. Cont <= cCaixFin
  
      if lInicio 
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
    
        lInicio := .f.
      endif
      
      if nLin == 0
        do case
          case nOrdem == 1
            Cabecalho ( 'Cheques Emitidos', 132, 4 )
          case nOrdem == 2
            Cabecalho ( 'Cheques Emitidos - Emissão', 132, 4 )
          case nOrdem == 3
            Cabecalho ( 'Cheques Emitidos - Vencimento', 132, 4 )
          case nOrdem == 4
            Cabecalho ( 'Cheques Emitidos - Depósito', 132, 4 )
        endcase  
        CabChPe ()
      endif

      @ nLin,001 say Banc           pict '9999'
      @ nLin,006 say BancARQ->Nome  pict '@S20'
      @ nLin,027 say Agci           pict '9999'
      @ nLin,032 say AgciARQ->Nome  pict '@S15'
      @ nLin,048 say Cheq           
      @ nLin,056 say Data           pict '99/99/9999'
      @ nLin,067 say Vcto           pict '99/99/9999'
      if empty( Depo )
        @ nLin,078 say '__/__/____'
      else  
        @ nLin,078 say Depo         pict '99/99/9999'
      endif
      @ nLin,089 say Valo           pict '@E 999,999.99'
      @ nLin,100 say Hist           pict '@S20'

      nLin      ++
      nQtde     ++
      nTotaValo += Valo

      if nLin >= pLimite
        Rodape(132) 

        cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
        cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

        set printer to ( cArqu2 )
        set printer on
      endif
    endif
    
    dbskip ()
  enddo
  
  if !lInicio
    nLin ++
    @ nLin,030 say 'Qtde. Cheques ' + strzero( nQtde, 4 )
    @ nLin,060 say 'Total Geral'
    @ nLin,089 say nTotaValo           pict '@E 999,999.99'       
    Rodape(132)
  endif  
 
  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 132 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      do case
        case nOrdem == 1
          replace Titu   with "Relatório de Cheques Emitidos"
        case nOrdem == 2
          replace Titu   with "Relatório de Cheques Emitidos - Emissão"
        case nOrdem == 3
          replace Titu   with "Relatório de Cheques Emitidos - Vencimento"
        case nOrdem == 4
          replace Titu   with "Relatório de Cheques Emitidos - Depósito"
      endcase    
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 132
      replace Empr       with cEmpresa
      dbunlock ()
    endif
    close
  endif  

  select ChPeARQ
  if lAbrir
    close
    select AgciARQ
    close
    select BancARQ
    close
  else
    set order  to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabChPe ()
  @ 02,01 say 'Emissão ' + dtoc( dDataIni ) + ' a ' + dtoc( dDataFin ) 
  @ 02,35 say 'Vencimento ' + dtoc( dVctoIni ) + ' a ' + dtoc( dVctoFin ) 
  @ 02,73 say 'Depósito ' + dtoc( dDepoIni ) + ' a ' + dtoc( dDepoFin ) 
  @ 03,01 say 'Banco                     Agˆncia               Cheque Data       Vcto.      Depósito        Valor Histórico'
  
  nLin := 05
return NIL

//
// Relatorio Cheques Emitidos
//
function PrinChEm()

  if NetUse( "BancARQ", .t. )
    VerifIND( "BancARQ" )

    #ifdef DBF_NTX
      set index to BancIND1, BancIND2
    #endif  
  endif

  if NetUse( "AgciARQ", .t. )
    VerifIND( "AgciARQ" )

    #ifdef DBF_NTX
      set index to AgciIND1, AgciIND2
    #endif  
  endif

  if NetUse( "ChPeARQ", .t. )
    VerifIND( "ChPeARQ" )

    #ifdef DBF_NTX
      set index to ChPeIND1, ChPeIND2, ChPeIND3, ChPeIND4
    #endif  
  endif

  if NetUse( "CampARQ", .t. )
    VerifIND( "CampARQ" )
  
    #ifdef DBF_NTX
      set index to CampIND1, CampIND2
    #endif  
  endif

  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 06, 11, 16, 65, mensagem( 'Janela', 'PrinChEm', .f. ), .f. )
  Mensagem( 'ChPE','PrinChPE')

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,13 say ' Cheque Inicial             Cheque Final'
  @ 09,13 say '  Banco Inicial              Banco Final'
  @ 10,13 say 'Agência Inicial            Agência Final'
  @ 11,13 say '  Emis. Inicial              Emis. Final'
  @ 12,13 say '  Vcto. Inicial              Vcto. Final'
  @ 13,13 say 'Deposi. Inicial            Deposi. Final'
  
  @ 15,13 say '          Ordem'
 
  setcolor ( 'n/w+' )
  @ 15,57 say chr(25)

  setcolor( CorCampo )
  @ 15,29 say ' Vcto. + Banco + Agˆncia   '

  select BancARQ
  set order to 1
  dbgotop()
  nBancIni := val( Banc )
  dbgobottom()
  nBancFin := val( Banc )

  select ChPeARQ
  set order  to 1
  dbgobottom ()
  
  nAgciIni := 1
  nAgciFin := 9999
  nCheqIni := 1
  nCheqFin := 9999999
  
  dVctoIni := ctod( '01/01/1900' )
  dVctoFin := ctod( '31/12/2015' )
  dDepoIni := ctod( '  /  /  ' )
  dDepoFin := ctod( '  /  /  ' )
  dDataIni := ctod( '01/01/1990' )
  dDataFin := ctod( '31/12/2015' )

  @ 08,29 get nCheqIni           pict '9999999'
  @ 08,54 get nCheqFin           pict '9999999'   valid nCheqFin >= nCheqIni
  @ 09,29 get nBancIni           pict '9999'      valid ValidARQ( 99, 99, "ChPeARQ", "Código" , "Banc", "Descrição", "Nome", "Banc", "nBancIni", .t., 4, "Consulta de Bancos", "BancARQ", 30 ) 
  @ 09,54 get nBancFin           pict '9999'      valid ValidARQ( 99, 99, "ChPeARQ", "Código" , "Banc", "Descrição", "Nome", "Banc", "nBancFin", .t., 4, "Consulta de Bancos", "BancARQ", 30 ) .and. nBancFin >= nBancIni
  @ 10,29 get nAgciIni           pict '9999'
  @ 10,54 get nAgciFin           pict '9999'      valid nAgciFin >= nAgciIni
  @ 11,29 get dDataIni           pict '99/99/9999'
  @ 11,54 get dDataFin           pict '99/99/9999'  valid dDataFin >= dDataIni
  @ 12,29 get dVctoIni           pict '99/99/9999'
  @ 12,54 get dVctoFin           pict '99/99/9999'  valid dVctoFin >= dVctoIni
  @ 13,29 get dDepoIni           pict '99/99/9999'
  @ 13,54 get dDepoFin           pict '99/99/9999'  valid dDepoFin >= dDepoIni
  read

  if lastkey () == K_ESC
    select ChPeARQ
    close
    select BancARQ
    close
    select CampARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  aOpcao := {}
  
  aadd( aOpcao, { ' Cheque + Banco + Agˆncia  ', 2, 'C', 15, 29, "Relatório em ordem de cheque e banco e agência." } )
  aadd( aOpcao, { ' Emissão + Banco + Agˆncia ', 2, 'D', 15, 29, "Relatório em ordem de data de Entrada e banco e agência e cheque." } )
  aadd( aOpcao, { ' Vcto. + Banco + Agˆncia   ', 2, 'V', 15, 29, "Relatório em ordem de data de Vencimento e banco e agência e cheque." } )
  aadd( aOpcao, { ' Depósito + Banco + Agˆn.  ', 3, 'E', 15, 29, "Relatório em ordem de data de Deposito e banco e agência e cheque." } )

  nOrdem := HCHOICE( aOpcao, 4, 3 )
  
  Aguarde ()

  if !TestPrint( EmprARQ->Cheque )
    select BancARQ
    close
    select CampARQ
    close
    return NIL
  endif

  nLin     := 0
  nQtde    := nTotaValo   := 0
  cBancIni := strzero( nBancIni, 4 )
  cBancFin := strzero( nBancFin, 4 )
  cAgciIni := strzero( nAgciIni, 4 )
  cAgciFin := strzero( nAgciFin, 4 )
  cCheqIni := strzero( nCheqIni, 7 )
  cCheqFin := strzero( nCheqFin, 7 )
  cCida    := alltrim( EmprARQ->Cida ) + '(' + EmprARQ->UF + ')'

                                                          //  Imprimir
  select ChPeARQ
  set order    to nOrdem
  set relation to Banc into BancARQ, to Banc + Agci into AgciARQ
  dbgotop ()
  do while !eof()
    if Banc >= cBancIni .and. Banc <= cBancFin .and.;
       Agci >= cAgciIni .and. Agci <= cAgciFin .and.;
       Cheq >= cCheqIni .and. Cheq <= cCheqFin .and.;
       Data >= dDataIni .and. Data <= dDataFin .and.;
       Vcto >= dVctoIni .and. Vcto <= dVctoFin .and.;
       Depo >= dDepoIni .and. Depo <= dDepoFin
       
       cTexto := BancARQ->Cheque
       nTama  := BancARQ->TamaCheq
       nEspa  := BancARQ->EspaCheq
       nComp  := BancARQ->CompCheq
       cQtLin := mlcount( cTexto, nTama )
       
       nValor := Valo
       cNome  := Hist
       dEmis  := Data

       setprc( 0, 0 )
   
       if nComp == 1
         @ 00,00 say chr(15)
       else  
         @ 00,00 say chr(18)
       endif  
      
       if nEspa == 1
         @ 00,00 say chr(27) + '@'
       else
         @ 00,00 say chr(27) + chr(48)
       endif  

       nLin := 0   
      
       for nK := 1 to cQtLin
         cLinha := memoline( cTexto, nTama, nK )
        
         if empty( cLinha )
           nLin ++
           loop
         endif  
        
         nTamLin  := len( cLinha )
         cPalavra := ''
         nCol     := 0
       
         for nH := 1 to nTamLin
           cKey := substr( cLinha, nH, 1 )
        
           if cKey != ' '
             if nCol == 0
               nCol := nH
             endif  

             cPalavra += cKey
           endif    

           if cKey == ' '
             if empty( cPalavra )
               loop
             endif

             select CampARQ
             set order to 2
             dbseek( cPalavra, .f. )
      
             if found ()
               cArqu := Arquivo 
               cCamp := Campo
               cDesc := Desc
               cPict := Mascara
               xTipo := Tipo
               xTama := Tamanho
                            
               if alltrim( cCamp ) == 'cValorExt1'   
                 nTam01 := val( left( cPict, 2 ) )
                 nTam02 := val( substr( cPict, 4, 2 ) )
                             
                 Extenso( nValor, nTam01, nTam02 )
               endif  
          
               if !empty( cArqu )
                 select( cArqu )
               endif  

               do case 
                 case xTipo == 'N'
                   if !empty( &cCamp )
                     @ nLin,nCol say transform( &cCamp, cPict )
                   endif  
                 case xTipo == 'C'  
                   @ nLin,nCol say left( &cCamp, xTama )
                 case xTipo == 'D'  
                   @ nLin,nCol say &cCamp
                 case xTipo == 'O'  
                   @ nLin,nCol say left( cCamp, xTama )
               endcase  
             endif 
            
             cPalavra := ''
             nCol     := 0
           endif  
         next 
        
         nLin ++
         @ nLin,nCol say space(1)
       next     
  
       nLin ++
       @ nLin,000 say chr(27) + '@'
       
       select ChPeARQ
     endif  
     dbskip ()
   enddo
 
  set printer to
  set printer off
  set device  to screen
  
  select ChPeARQ
  close
  select AgciARQ
  close
  select BancARQ
  close
  select CampARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL       

//
// Imprimir Cheques Emitidos - Individual
//
function ImprChPE()
  if NetUse( "CampARQ", .t. )
    VerifIND( "CampARQ" )
  
    #ifdef DBF_NTX
      set index to CampIND1, CampIND2
    #endif  
  endif

  tPrt := savescreen( 00, 00, 23, 79 )
  
  Aguarde ()

  if !TestPrint( EmprARQ->Cheque )
    select SpooARQ
    close
    select CampARQ
    close
    return NIL
  endif

  select ChPeARQ

  nLin   := 0
  nQtde  := nTotaValo   := 0
  cCida  := alltrim( EmprARQ->Cida ) + '(' + EmprARQ->UF + ')'
  cTexto := BancARQ->Cheque
  nTama  := BancARQ->TamaCheq
  nEspa  := BancARQ->EspaCheq
  nComp  := BancARQ->CompCheq
  cQtLin := mlcount( cTexto, nTama )
  nValor := Valo
  cNome  := Hist
  dEmis  := Vcto

  setprc( 0, 0 )
   
  if nComp == 1
    @ 00,00 say chr(15)
  else  
    @ 00,00 say chr(18)
  endif  
      
  if nEspa == 1
    @ 00,00 say chr(27) + '@'
  else
    @ 00,00 say chr(27) + chr(48)
  endif  

  nLin := 0   
      
  for nK := 1 to cQtLin
    cLinha := memoline( cTexto, nTama, nK )
        
    if empty( cLinha )
      nLin ++
      loop
    endif  
        
    nTamLin  := len( cLinha )
    cPalavra := ''
    nCol     := 0
       
    for nH := 1 to nTamLin
      cKey := substr( cLinha, nH, 1 )
    
      if cKey != ' '
        if nCol == 0
          nCol := nH
        endif  

        cPalavra += cKey
      endif    

      if cKey == ' '
        if empty( cPalavra )
          loop
        endif

        select CampARQ
        set order to 2
        dbseek( cPalavra, .f. )
      
        if found ()
          cArqu := Arquivo 
          cCamp := Campo
          cDesc := Desc
          cPict := Mascara
          xTipo := Tipo
          xTama := Tamanho
                            
          if alltrim( cCamp ) == 'cValorExt1'   
            nTam01 := val( left( cPict, 2 ) )
            nTam02 := val( substr( cPict, 4, 2 ) )
                             
            Extenso( nValor, nTam01, nTam02 )
          endif  
          
          if !empty( cArqu )
            select( cArqu )
          endif  

          do case 
            case xTipo == 'N'
              if !empty( &cCamp )
                @ nLin,nCol say transform( &cCamp, cPict )
              endif  
            case xTipo == 'C'  
              @ nLin,nCol say left( &cCamp, xTama )
            case xTipo == 'D'  
              @ nLin,nCol say &cCamp
            case xTipo == 'O'  
              @ nLin,nCol say left( cCamp, xTama )
          endcase  
        endif 
            
        cPalavra := ''
        nCol     := 0
      endif  
    next 
        
    nLin ++
    @ nLin,nCol say space(1)
  next     
  
  nLin ++
  @ nLin,000 say chr(27) + '@'
       
  set printer to
  set printer off
  set device  to screen
  
  select CampARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL