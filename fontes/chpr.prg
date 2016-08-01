//  Leve, Cheques Recebidos  
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

function ChPr ()
  local GetList := {}
  
if NetUse( "ChPrARQ", .t. )
  VerifIND( "ChPrARQ" )
  
  hOpenChPr := .t.

  #ifdef DBF_NTX
    set index to ChPrIND1, ChPrIND2, ChPrIND3, ChPrIND4, ChPrIND5
  #endif  
else
  hOpenChPr := .f.
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

if NetUse( "CaixARQ", .t. )
  VerifIND( "CaixARQ" )
  
  hOpenCaix := .t.

  #ifdef DBF_NTX
    set index to CaixIND1, CaixIND2
  #endif  
else
  hOpenCaix := .f.
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

if NetUse( "ClieARQ", .t. )
  VerifIND( "ClieARQ" )
  
  hOpenClie := .t.

  #ifdef DBF_NTX
    set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
  #endif  
else
  hOpenClie := .f.
endif

//  Variaveis de Entrada para Cheques pre-datados
nCheq    := nBanc := nAgci := 0
nValo    := nClie := 0
cCont    := space(15)
cCheq    := space(07)
dData    := dVcto := dDepo := ctod('  /  /  ')
cHist    := cDest := space(60)
cClie    := space(04)
cBanc    := cAgci := cClie := space(04)
cCliente := space(40)

//  Tela Cheques pre-datados
Janela ( 05, 12, 19, 67, mensagem( 'Janela', 'ChPr', .f. ), .t. )

setcolor ( CorJanel )
@ 07,14 say ' N. Cheque                      Conta'
@ 09,14 say '     Banco'
@ 10,14 say '   Agência'
@ 11,14 say '   Cliente'
@ 13,14 say '     Vcto.                   Depósito'
@ 14,14 say '     Valor'
@ 16,14 say ' Histórico'

MostOpcao( 18, 14, 26, 43, 56 )
                   
tChPr := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Cheques
select ChPrARQ
set order    to 1
set relation to Banc into BancARQ, to Banc + Agci into AgciARQ,;
             to Clie into ClieARQ
if hOpenChPr
  dbgobottom ()
endif  
do while  .t.
  Mensagem('ChPr','Janela')

  select BancARQ
  set order to 1
  
  select AgciARQ 
  set order to 1
  
  select ClieARQ
  set order to 1

  select ChPrARQ
  set order    to 1
  set relation to Banc into BancARQ, to Banc + Agci into AgciARQ,;
               to Clie into ClieARQ

  cStat := space(04)
  restscreen( 00, 00, 23, 79, tChPr )
  MostChPr()
  
  if Demo ()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostChPr'
  cAjuda   := 'ChPr'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()

  @ 07,25 get nCheq        pict '9999999'
  @ 07,52 get cCont        pict '@S13'
  read
  
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC
    exit
  endif
  
  setcolor ( CorCampo )
  cCheq := strzero( nCheq, 7 )

  //  Verificar existencia do Cheques para Incluir, Alterar ou Excluir
  select ChPrARQ
  set order to 1
  dbseek( cCheq + cCont, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif
  
  Mensagem ('ChPr',cStat)

  oStatAnt := cStat

  MostChPr()
  EntrChPr()
  
  cStat := oStatAnt

  Confirmar( 18, 14, 26, 43, 56, 3 )
  
  if lastkey() == K_ESC .or. cStat == 'loop'
    loop
  endif  

  if cStat == 'prin'
    PrinChPr ( .f. )
  endif
    
  if cStat == 'excl'
    ExclRegi ()
  endif
  
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Cheq          with cCheq
        replace Cont          with cCont
        replace Data          with date()
        dbunlock ()
      endif  
    endif  
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Banc          with cBanc
      replace Agci          with cAgci
      replace Vcto          with dVcto
      replace Depo          with dDepo
      replace Valo          with nValo
      replace Hist          with cHist
      replace Dest          with cDest
      replace Clie          with cClie
      replace Cliente       with cCliente  
      dbunlock ()
    endif
  endif
  
  if EmprARQ->Caixa == "X"
    nPago := nValo
    dPgto := dDepo
    cNota := cCheq
  
    DestLcto ()
  endif  
enddo

if hOpenChPr
  select ChPrARQ
  close
endif  

if hOpenBanc
  select BancARQ
  close
endif  
  
if hOpenAgci
  select AgciARQ
  close
endif  
  
if hOpenClie
  select ClieARQ
  close
endif  
return NIL

//
// Entra com destinatario  
//
function EntrDest( xDepo )
  local GetList := {}
  
  if !empty( xDepo )
    tTela := savescreen( 00, 00, 23, 79 )

    Janela( 08, 18, 11, 59, mensagem( 'Janela', 'EntrDest', .f. ), .f. )
    setcolor( CorJanel + ',' + CorCampo )
    @ 10,20 say 'Destino'
    
    @ 10,28 get cDest               pict '@S30'
    read
    
    restscreen( 00, 00, 23, 79, tTela )
  endif  
return(.t.)  

//
// Entra Dados do Cheques pre-datados
//
function EntrChPr()
  local GetList := {}

  if empty( dVcto )
    dVcto := date()
  endif
  
  do while .t.
    lAlterou := .f.
 
    setcolor ( CorJanel + ',' + CorCampo )
    @ 09,25 get nBanc         pict '9999'     valid ValidARQ( 09, 25, "ChPrARQ", "Código" , "Banc", "Descrição", "Nome", "Banc", "nBanc", .t., 4, "Consulta de Bancos", "BancARQ", 30 )
    @ 10,25 get nAgci         pict '9999'     valid ValidAgci( 10, 25, "ChPrARQ" , nBanc ) 
    @ 11,25 get nClie         pict '999999'   valid ValidClie( 11, 25, "ChPrARQ" )
    @ 13,25 get dVcto         pict '99/99/9999'
    @ 13,52 get dDepo         pict '99/99/9999' valid EntrDest( dDepo )
    @ 14,25 get nValo         pict '@E 999,999,999.99'
    @ 16,25 get cHist         pict '@S40'           
    read

    if nBanc      != val( Banc );  lAlterou := .t.
    elseif nAgci  != val( Agci );  lAlterou := .t.
    elseif nClie  != val( Clie );  lAlterou := .t.
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
  cClie := strzero( nClie, 6 )
return NIL

//
// Mostra Dados do Cheques pre-datados
//
function MostChPr()
  setcolor ( CorCampo )
  if cStat != 'incl'
    cCheq := Cheq
    nCheq := val( cCheq )
    dData := Data
    cCont := Cont
    
    @ 07,25 say cCheq
    @ 07,52 say cCont        pict '@S13'
  endif  
  
  nBanc    := val( Banc )
  cBanc    := Banc
  cAgci    := Agci
  nAgci    := val( Agci )
  dVcto    := Vcto
  dDepo    := Depo
  nValo    := Valo
  cHist    := Hist
  cDest    := Dest
  cClie    := Clie
  nClie    := val( Clie )
  cCliente := Cliente
  
  @ 09,25 say cBanc             pict '9999'
  @ 09,30 say BancARQ->Nome     pict '@S30'   
  @ 10,25 say cAgci             pict '9999'
  @ 10,30 say AgciARQ->Nome     pict '@S30'   
  @ 11,25 say cClie             pict '999999'
  if cClie == '999999'
    @ 11,32 say cCliente        pict '@S35'
  else  
    @ 11,32 say ClieARQ->Nome   pict '@S35'
  endif 
  @ 13,25 say dVcto           pict '99/99/9999'
  @ 13,52 say dDepo           pict '99/99/9999'
  @ 14,25 say nValo           pict '@E 999,999,999.99'
  @ 16,25 say cHist           pict '@S40'
  
  PosiDBF( 05, 67 )
return NIL

//
// Imprimir cheques 
//
function PrinCheq ()

  if NetUse( "BancARQ", .t. )
    VerifIND( "BancARQ" )

    #ifdef DBF_NTX
      set index to BancIND1, BancIND2
    #endif  
  endif

  if NetUse( "CampARQ", .t. )
    VerifIND( "CampARQ" )

    #ifdef DBF_NTX
      set index to CampIND1, CampIND2
    #endif  
  endif
  
  EmprARQ->(dbsetorder(1))
  EmprARQ->(dbseek(cEmpresa,.f.))

  nValor  := opConf := nBanc := 0
  cNome   := space (45)
  dEmis   := date()
  cCida   := space(25)
  cCida   := alltrim( EmprARQ->Cida ) + '(' + EmprARQ->UF + ')' + space( len(alltrim( EmprARQ->Cida ) + '(' + EmprARQ->UF + ')') )
  tPrt    := savescreen( 00, 00, 23, 79 )

  //  Tela Cheques
  Janela ( 07, 12, 15, 70, mensagem( "Janela", "PrinCheq", .f. ), .f. )
  Mensagem('ChPr', 'PrinCheq' )
 
  setcolor ( CorJanel )
  @ 09,14 say '    Valor'
  @ 10,14 say 'Nominal a'
  @ 11,14 say '   Cidade'
  @ 12,14 say '     Data'
  @ 14,14 say '    Banco'

  
  setcolor( CorCampo )
  @ 14,29 say space(30)

  setcolor ( CorJanel + ',' + CorCampo )
  @ 09,24 get nValor     pict '@E 999,999.99'
  @ 10,24 get cNome      pict '@!K'
  @ 11,24 get cCida      pict '@!'
  @ 12,24 get dEmis      pict '99/99/9999'
  @ 14,24 get nBanc      pict '9999' valid ValidARQ( 14, 24, "BancARQ", "Código" , "Banc", "Descrição", "Nome", "Banc", "nBanc", .t., 4, "Consulta de Bancos", "BancARQ", 30 )
  read

  if lastkey() == K_ESC .or. nValor == 0
    select BancARQ
    close
    select CampARQ
    close
    return NIL
  endif

  if !TestPrint( EmprARQ->Cheque )
    select BancARQ
    close
    select CampARQ
    close
    return NIL
  endif
  
  cBanc := strzero( nBanc, 4 )

  select BancARQ
  set order to 1
  dbseek( cBanc, .f. )

  if found()
    if empty( Cheque )
      lAchou := .f.
    else  
      lAchou := .t.
    endif  
  else
    lAchou := .f.
  endif
  
  if !lAchou
    Alerta( mensagem( "Alerta", "PrinCheq", .f. ) ) 
   
    select BancARQ
    close
    select CampARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  cTexto := Cheque
  nTama  := TamaCheq
  nEspa  := EspaCheq
  nComp  := CompCheq

  cQtLin := mlcount( cTexto, nTama )
  
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

  select CampARQ
  close
  select BancARQ
  close
  
  set printer to
  set printer off
  set device  to screen

  restscreen( 00, 00, 23, 79, tPrt )
return NIL  

//
// Imprime Dados dos Cheques pre-datados
//
function PrinChPr( lAbrir )

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

    if NetUse( "ClieARQ", .t. )
      VerifIND( "ClieARQ" )

      #ifdef DBF_NTX
        set index to ClieIND1, ClieIND2
      #endif    
    endif
  
    if NetUse( "ChPrARQ", .t. )
      VerifIND( "ChPrARQ" )

      #ifdef DBF_NTX
        set index to ChPrIND1, ChPrIND2, ChPrIND3, ChPrIND4, ChPrIND5
      #endif    
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 06, 09, 17, 65, mensagem( 'Janela', 'PrinChPr', .f. ), .f. )
  Mensagem( 'ChPr','PrinChPr')

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,11 say ' Cheque Inicial               Cheque Final'
  @ 09,11 say '  Banco Inicial                Banco Final'
  @ 10,11 say 'Agência Inicial              Agência Final'
  @ 11,11 say '   Data Inicial                 Data Final'
  @ 12,11 say '  Vcto. Inicial                Vcto. Final'
  @ 13,11 say 'Deposi. Inicial              Deposi. Final'
  @ 14,11 say 'Cliente Inicial              Cliente Final'
  
  @ 16,11 say '          Ordem'
 
  setcolor ( 'n/w+' )
  @ 16,55 say chr(25)

  setcolor( CorCampo )
  @ 16,27 say ' Vcto. + Banco + Agˆncia   '
  
  select ClieARQ
  set order to 1

  select BancARQ
  set order to 1
  dbgotop()
  nBancIni := val( Banc )
  dbgobottom()
  nBancFin := val( Banc )

  select ChPrARQ
  set order  to 1
  dbgobottom ()
  
  nClieIni := 1
  nClieFin := 999999
  nAgciIni := 1
  nAgciFin := 9999
  nCheqIni := 1
  nCheqFin := 9999999
  
  dVctoIni := ctod( '01/01/1900' )
  dVctoFin := ctod( '31/12/2015' )
  dDepoIni := ctod( '  /  /  ' )
  dDepoFin := ctod( '  /  /  ' )
  dDataIni := ctod( '01/01/1900' )
  dDataFin := ctod( '31/12/2015' )

  @ 08,27 get nCheqIni           pict '9999999'
  @ 08,54 get nCheqFin           pict '9999999'   valid nCheqFin >= nCheqIni
  @ 09,27 get nBancIni           pict '9999'      valid ValidARQ( 99, 99, "ChPrARQ", "Código" , "Banc", "Descrição", "Nome", "Banc", "nBancIni", .t., 4, "Consulta de Bancos", "BancARQ", 30 ) 
  @ 09,54 get nBancFin           pict '9999'      valid ValidARQ( 99, 99, "ChPrARQ", "Código" , "Banc", "Descrição", "Nome", "Banc", "nBancFin", .t., 4, "Consulta de Bancos", "BancARQ", 30 ) .and. nBancFin >= nBancIni
  @ 10,27 get nAgciIni           pict '9999'
  @ 10,54 get nAgciFin           pict '9999'      valid nAgciFin >= nAgciIni
  @ 11,27 get dDataIni           pict '99/99/9999'
  @ 11,54 get dDataFin           pict '99/99/9999'  valid dDataFin >= dDataIni
  @ 12,27 get dVctoIni           pict '99/99/9999'
  @ 12,54 get dVctoFin           pict '99/99/9999'  valid dVctoFin >= dVctoIni
  @ 13,27 get dDepoIni           pict '99/99/9999'
  @ 13,54 get dDepoFin           pict '99/99/9999'  valid dDepoFin >= dDepoIni
  @ 14,27 get nClieIni           pict '999999'      valid ValidClie( 99, 99, "ChPrARQ", "nClieIni" )
  @ 14,54 get nClieFin           pict '999999'      valid ValidClie( 99, 99, "ChPrARQ", "nClieFin" ) .and. nClieFin >= nClieIni
  read

  if lastkey () == K_ESC
    select ChPrARQ
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
  
  aadd( aOpcao, { ' Cheque + Banco + Agˆncia  ', 2, 'C', 16, 27, "Relatório em ordem de cheque e banco e agência." } )
  aadd( aOpcao, { ' Data + Banco + Agˆncia    ', 2, 'D', 16, 27, "Relatório em ordem de data de Entrada e banco e agência e cheque." } )
  aadd( aOpcao, { ' Vcto. + Banco + Agˆncia   ', 2, 'V', 16, 27, "Relatório em ordem de data de Vencimento e banco e agência e cheque." } )
  aadd( aOpcao, { ' Deposito + Banco + Agˆn.  ', 3, 'E', 16, 27, "Relatório em ordem de data de Deposito e banco e agência e cheque." } )

  nOrdem   := HCHOICE( aOpcao, 4, 3 )
  
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
  cClieIni := strzero( nClieIni, 6 )
  cClieFin := strzero( nClieFin, 6 )
  cCheqIni := strzero( nCheqIni, 7 )
  cCheqFin := strzero( nCheqFin, 7 )
                                                          //  Imprimir
  select ChPrARQ
  set order  to nOrdem
  set relation to Banc into BancARQ, to Banc + Agci into AgciARQ,;
               to Clie into ClieARQ
  dbgotop ()
  do while !eof()
    if Banc >= cBancIni .and. Banc <= cBancFin .and.;
       Agci >= cAgciIni .and. Agci <= cAgciFin .and.;
       Cheq >= cCheqIni .and. Cheq <= cCheqFin .and.;
       Clie >= cClieIni .and. Clie <= cClieFin .and.;
       Data >= dDataIni .and. Data <= dDataFin .and.;
       Vcto >= dVctoIni .and. Vcto <= dVctoFin .and.;
       Depo >= dDepoIni .and. Depo <= dDepoFin

      if lInicio
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
        
        lInicio := .f.
      endif

      if nLin == 0
        do case
          case nOrdem == 1
            Cabecalho ( 'Cheques Recebidos', 132, 4 )
          case nOrdem == 2
            Cabecalho ( 'Cheques Recebidos - Data', 132, 4 )
          case nOrdem == 3
            Cabecalho ( 'Cheques Recebidos - Vcto.', 132, 4 )
          case nOrdem == 4
            Cabecalho ( 'Cheques Recebidos - Deposito', 132, 4 )
        endcase  
        CabChPr ()
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
        @ nLin,078 say Depo          pict '99/99/9999'
      endif
      @ nLin,089 say Valo             pict '@E 999,999.99'
      @ nLin,100 say Hist             pict '@S15'
      @ nLin,116 say Clie             pict '999999'
      if Clie == '999999'
        @ nLin,123 say Cliente        pict '@S08'
      else  
        @ nLin,123 say ClieARQ->Nome  pict '@S08'
      endif  

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
    @ nLin,065 say 'Total Geral'
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
          replace Titu   with "Relatório de Cheques Recebidos"
        case nOrdem == 2
          replace Titu   with "Relatório de Cheques Recebidos - Data"
        case nOrdem == 3
          replace Titu   with "Relatório de Cheques Recebidos - Vcto."
        case nOrdem == 4
          replace Titu   with "Relatório de Cheques Recebidos - Depósito"
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

  select ChPrARQ
  if lAbrir
    close
    select ClieARQ
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

function CabChPr ()
  @ 02,01 say 'Emissão ' + dtoc( dDataIni ) + ' a ' + dtoc( dDataFin ) 
  @ 02,35 say 'Vencimento ' + dtoc( dVctoIni ) + ' a ' + dtoc( dVctoFin ) 
  if !empty( dDepoIni )
    @ 02,73 say 'Depósito ' + dtoc( dDepoIni ) + ' a ' + dtoc( dDepoFin ) 
  endif  
  @ 03,01 say 'Banco                     Agˆncia               Cheque Emissão    Vcto.      Depósito        Valor Histórico       Cliente'    
  
  nLin := 05
return NIL