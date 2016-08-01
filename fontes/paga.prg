//  Leve, Contas a Pagar
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

function Paga()

if NetUse( "FornARQ", .t. )
  VerifIND( "FornARQ" )
  
  lOpenForn := .t.
  
  #ifdef DBF_NTX
    set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
  #endif
else
  lOpenForn := .f.  
endif

if NetUse( "PortARQ", .t. )
  VerifIND( "PortARQ" )
  
  lOpenPort := .t.
  
  #ifdef DBF_NTX
    set index to PortIND1, PortIND2
  #endif
else
  lOpenPort := .f.  
endif

if NetUse( "PagaARQ", .t. )
  VerifIND( "PagaARQ" )
  
  lOpenPaga := .t.
  
  #ifdef DBF_NTX
    set index to PagaIND1, PagaIND2, PagaIND3, PagaIND4, PagaIND5, PagaIND6
  #endif
else
  lOpenPaga := .f.  
endif

//  Variaveis de Entrada para Item
nNota  := nForn := nPort := nMora := 0
cNota  := space(12)
cDcto  := space(20)
cObse  := space(45)
cForn  := cPort := space(04)
dEmis  := dVcto := dPgto := ctod('  /  /  ')
nValor := nAcre := nDesc := nJuro := nPago := 0

//  Tela Item
Janela( 03, 05, 21, 72, mensagem( 'Janela', 'Paga', .f. ), .t. )

setcolor ( CorJanel + ',' + CorCampo )
@ 05,18 say 'Nota'
@ 06,12 say 'Fornecedor'

@ 08,40 say 'Dcto. Origem' 
@ 08,10 say 'Data Emissão'
@ 09,07 say 'Data Vencimento'
@ 10,08 say 'Data Pagamento'

@ 12,12 say 'Valor Nota'
@ 13,11 say 'Juro Mensal'
@ 13,41 say 'Mora Diária'

@ 15,13 say 'Descontos'
@ 15,47 say 'Juros'
@ 16,12 say 'Valor Pago'
@ 17,12 say 'Observação'
@ 18,12 say '  Portador'

MostOpcao( 20, 07, 19, 48, 61 ) 
tPaga := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Item
select PagaARQ
set order    to 1
set relation to Forn into FornARQ, to Port into PortARQ
if lOpenPaga 
  dbgobottom ()
endif  
do while  .t.
  select FornARQ
  set order to 1
  
  select PortARQ
  set order to 1
  
  select PagaARQ
  set order    to 1
  set relation to Forn into FornARQ, to Port into PortARQ

  Mensagem('Paga', 'Janela' )

  cStat := space (4)
  restscreen( 00, 00, 23, 79, tPaga )
  MostPaga()
  
  if Demo ()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostPaga'
  cAjuda   := 'Paga'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()

  @ 05,23 get nNota   pict '9999999999-99'
  @ 06,23 get nForn   pict '999999'     valid ValidForn ( 06, 23, "PagaARQ" )
  read

  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. nNota == 0 .or. nForn == 0
    exit
  endif
  
  cNota := strzero( nNota, 12 )
  cForn := strzero( nForn, 06 )

  //  Verificar existencia do Produto para Incluir ou Alterar
  select PagaARQ
  set order to 1
  dbseek( cNota + cForn, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif

  Mensagem ('Paga', cStat )

  MostPaga ()

  if dPgto != ctod ('  /  /  ')
    Alerta( mensagem( 'Alerta', 'Paga', .f. ) )
  endif  

  EntrPaga ()

  Confirmar ( 20, 07, 19, 48, 61, 3 )

  if cStat == 'prin'
    PrinPaga (.f.)
  endif
    
  if cStat == 'excl'
    ExclRegi ()
  endif
  
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Nota  with cNota
        replace Forn  with cForn
        dbunlock ()
      endif 
    endif   
  endif

  if cStat == 'alte' .or. cStat == 'incl'
    if RegLock()
      replace Dcto      with cDcto
      replace Emis      with dEmis
      replace Vcto      with dVcto
      replace Valor     with nValor
      replace Acre      with nAcre
      replace Mora      with nMora
      replace Desc      with nDesc
      replace Port      with cPort
      replace Obse      with cObse
      dbunlock ()
    endif
  endif
enddo

if lOpenPaga
  select PagaARQ
  close
endif  

if lOpenForn
  select FornARQ
  close
endif  

if lOpenPort
  select PortARQ
  close
endif  

return NIL

// Calcula o valor mora
function CalcMora()
  if nMora == 0
    nMora := ( ( nValor * nAcre ) / 100 ) / 30
  endif  
return(.t.)

//
// Entra Dados do Item
//
function EntrPaga ()
  do while .t.
    lAlterou := .f.

    setcolor ( CorJanel + ',' + CorCampo )
    @ 08,23 get dEmis   pict '99/99/9999'
    @ 08,53 get cDcto   pict '@S15'
    @ 09,23 get dVcto   pict '99/99/9999'
    @ 12,23 get nValor  pict '@E 999,999,999.99'
    @ 13,23 get nAcre   pict '@E 999.99'   valid CalcMora()
    @ 13,53 get nMora   pict '@E 999.99'
    @ 15,23 get nDesc   pict '@E 999,999,999.99'
    @ 17,23 get cObse   pict '@S40'
    @ 18,23 get nPort   pict '999999'  valid ValidARQ( 18, 23, "PagaARQ", "Código" , "Port", "Descrição", "Nome", "Port", "nPort", .t., 6, "Consulta de Portadores", "PortARQ", 40 )
    read
    
    if dEmis      != Emis;        lAlterou := .t.
    elseif cDcto  != Dcto;        lAlterou := .t.
    elseif dVcto  != Vcto;        lAlterou := .t.
    elseif nValor != Valor;       lAlterou := .t.
    elseif nAcre  != Acre;        lAlterou := .t.
    elseif nMora  != Mora;        lAlterou := .t.
    elseif nDesc  != Desc;        lAlterou := .t.
    elseif cObse  != Obse;        lAlterou := .t.
    elseif nPort  != val( Port ); lAlterou := .t.
    endif
    
    if !Saindo(lAlterou)
      loop
    endif
    exit  
  enddo
  cPort := strzero( nPort, 6 )
return NIL

//
// Mostra Dados do Item
//
function MostPaga ()
  setcolor ( CorCampo )
  if cStat != 'incl'
    nNota := val( Nota )
    nForn := val( Forn )
    cForn := Forn
    
    @ 05,23 say nNota                   pict '9999999999-99'
    @ 06,23 say nForn                   pict '999999'
    @ 06,30 say FornARQ->Nome           pict '@S40'
  endif
  
  cDcto  := Dcto
  cObse  := Obse
  dEmis  := Emis
  dVcto  := Vcto
  dPgto  := Pgto
  nValor := Valor
  nAcre  := Acre
  nDesc  := Desc
  nPago  := Pago
  nMora  := Mora
  cPort  := Port
  nPort  := val( cPort )

  if dVcto < date() .and. Juro == 0
    if nAcre > 0
      nJuro := ( date() - dVcto ) * (  ( nValor - nDesc ) * (nAcre / 30) / 100 )
    else
      nJuro := ( ( date() - dVcto ) * ( ( ( nValor - nDesc ) * nMora ) / 100 ) ) 
    endif  
  else
    nJuro := Juro
  endif

  @ 08,23 say dEmis   pict '99/99/9999'
  @ 08,53 say cDcto   pict '@S15'
  @ 09,23 say dVcto   pict '99/99/9999'
  @ 10,23 say dPgto   pict '99/99/9999'

  @ 12,23 say nValor  pict '@E 999,999,999.99'
  @ 13,23 say nAcre   pict '@E 999.99'
  @ 13,53 say nMora   pict '@E 999.99'
  @ 15,23 say nDesc   pict '@E 999,999,999.99'
  @ 15,53 say nJuro   pict '@E 999,999,999.99'
  @ 16,23 say nPago   pict '@E 999,999,999.99'
  @ 17,23 say cObse   pict '@S40'
  @ 18,23 say cPort   pict '999999'
  @ 18,30 say PortARQ->Nome
  
  PosiDBF( 03, 72 )
return NIL

//
// Imprime Dados dos Contas a Pagar
//
function PrinPaga ( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "PortARQ", .t. )
      VerifIND( "PortARQ" )
  
      #ifdef DBF_NTX
        set index to PortIND1, PortIND2
      #endif
    endif

    if NetUse( "FornARQ", .t. )
      VerifIND( "FornARQ" )
  
      #ifdef DBF_NTX
        set index to FornIND1, FornIND2
      #endif
    endif

    if NetUse( "PagaARQ", .t. )
      VerifIND( "PagaARQ" )

      #ifdef DBF_NTX
        set index to PagaIND1, PagaIND2, PagaIND3, PagaIND4, PagaIND5, PagaIND6
      #endif
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 06, 09, 20, 77, mensagem( 'Janela', 'PrinPaga', .f. ), .f. )
  Mensagem('Paga','PrinPaga' )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,11 say '      Nota Inicial                    Nota Final'
  @ 09,11 say 'Fornecedor Inicial              Fornecedor Final'
  @ 10,11 say '  Portador Inicial                Portador Final'
  @ 12,11 say 'Data Emis. Inicial              Data Emis. Final'
  @ 13,11 say 'Data Vcto. Inicial              Data Vcto. Final'
  @ 14,11 say 'Data Pgto. Inicial              Data Pgto. Final'
  @ 16,11 say '      Valor Minimo                  Valor Máximo'
  @ 18,11 say '       Notas Pagas'
  @ 19,11 say '             Ordem'

  setcolor ( 'n/w+' )
  @ 19,51 say chr(25)

  setcolor( CorCampo )
  @ 18,30 say ' Sim '
  @ 18,36 say ' Não '
  @ 18,42 say ' Ambas '
  @ 19,30 say ' Vcto + Nota + Clie '

  setcolor( CorAltKC )
  @ 18,31 say 'S'
  @ 18,37 say 'N'
  @ 18,43 say 'A'

  select PortARQ
  set order to 1
  dbgobottom ()
  nPortIni := 0
  nPortFin := val( Port )

  select FornARQ
  set order to 1
  dbgotop ()
  nFornIni := val( Forn )
  dbgobottom ()
  nFornFin := val( Forn )
  
  select PagaARQ
  set order to 1
  dbgotop ()
  nNotaIni := val ( Nota )
  dbgobottom ()
  nNotaFin := val ( Nota )

  dEmisIni := ctod('01/01/1990')
  dEmisFin := ctod('31/12/2015')
  dVctoIni := ctod('01/01/1990')
  dVctoFin := ctod('31/12/2015')
  dPgtoIni := ctod('  /  /  ')
  dPgtoFin := ctod('  /  /  ')
  nValMini := 0
  nValMaxi := 9999999.99
  
  @ 08,30 get nNotaIni  pict '9999999999-99' 
  @ 08,60 get nNotaFin  pict '9999999999-99'       valid nNotaFin >= nNotaIni
  @ 09,30 get nFornIni  pict '999999'              valid ValidForn( 99, 99, "PagaARQ", "nFornIni" )       
  @ 09,60 get nFornFin  pict '999999'              valid ValidForn( 99, 99, "PagaARQ", "nFornFin" ) .and. nFornFin >= nFornIni
  @ 10,30 get nPortIni  pict '999999'              valid nPortIni == 0 .or. ValidARQ( 99, 99, "PagaARQ", "Código" , "Port", "Descrição", "Nome", "Port", "nPortIni", .t., 6, "Consulta de Portadores", "PortARQ", 40 )
  @ 10,60 get nPortFin  pict '999999'              valid nPortFin == 0 .or. ValidARQ( 99, 99, "PagaARQ", "Código" , "Port", "Descrição", "Nome", "Port", "nPortFin", .t., 6, "Consulta de Portadores", "PortARQ", 40 ) .and. nPortFin >= nPortIni
  @ 12,30 get dEmisIni  pict '99/99/9999'
  @ 12,60 get dEmisFin  pict '99/99/9999'          valid dEmisFin >= dEmisIni
  @ 13,30 get dVctoIni  pict '99/99/9999'
  @ 13,60 get dVctoFin  pict '99/99/9999'          valid dVctoFin >= dVctoIni
  @ 14,30 get dPgtoIni  pict '99/99/9999'
  @ 14,60 get dPgtoFin  pict '99/99/9999'          valid dPgtoFin >= dPgtoIni
  @ 16,30 get nValMini  pict '@E 9,999,999.99'
  @ 16,60 get nValMaxi  pict '@E 9,999,999.99'   valid nValMaxi >= nValMini
  read

  if lastkey() == K_ESC
    if lAbrir
      select PagaARQ
      close
      select FornARQ
      close
      select PortARQ
      close
    else
      select PagaARQ
      set order to 1
      dbgobottom ()
    endif
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  aOpc   := {}
  aOpcao := {}
  
  aadd( aOpcao, { ' Nota + Forn        ', 2, 'N', 19, 30, "Relatório em ordem de Nota e Fornecedor" } )
  aadd( aOpcao, { ' Vcto + Forn + Nota ', 2, 'V', 19, 30, "Relatório em ordem de data de Vcto. e Fornecedor e Nota." } )
  aadd( aOpcao, { ' Pgto + Forn + Nota ', 2, 'P', 19, 30, "Relatório em ordem de data de Pgto. e Fornecedor e Nota." } )
  aadd( aOpcao, { ' Forn + Vcto        ', 2, 'F', 19, 30, "Relatório em ordem de Fornecedor e data de Vcto." } )
  aadd( aOpcao, { ' Forn + Pgto        ', 3, 'O', 19, 30, "Relatório em ordem de Fornecedor e data de Pgto." } )
  aadd( aOpcao, { ' Alfabética         ', 3, 'A', 19, 30, "Relatório em ordem Alfabética por nome de fornecedor." } )

  aadd( aOpc, { ' Sim ',   2, 'S', 18, 30, "Relatório das nota pagas." } )
  aadd( aOpc, { ' Não ',   2, 'N', 18, 36, "Relatório das nota a vencer." } )
  aadd( aOpc, { ' Ambas ', 2, 'A', 18, 42, "Relatório de todas as nota." } )
   
  nNotPaga := HCHOICE( aOpc, 3, 2 )
  nOrdem   := HCHOICE( aOpcao, 6, 2 )

  if lastkey() == K_ESC
    if lAbrir
      select FornARQ
      close
      select PortARQ
      close
      select PagaARQ
      close
    else 
      select PagaARQ
      set order to 1
      dbgobottom ()
    endif
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  Aguarde ()
  
  nPag       := 1
  nLin       := 0
  cArqu2     := cArqu2 + "." + strzero( nPag, 3 )

  cNotaIni   := strzero ( nNotaIni, 12 )
  cNotaFin   := strzero ( nNotaFin, 12 )
  cFornIni   := strzero ( nFornIni, 6 )
  cFornFin   := strzero ( nFornFin, 6 )
  cPortIni   := strzero ( nPortIni, 6 )
  cPortFin   := strzero ( nPortFin, 6 )

  nValorAcum := nGeraValor := nGeraAVenc := nGeraVenci := 0
  nTotalJuro := nTotalDesc := nTotalNota := 0
  dPgtoAnt   := dVctoAnt   := ctod('  /  /  ')
  cFornAnt   := space(06)
  cNotaAnt   := space(06)
  nQtdeNot   := 0
  lInicio    := .t.
  
  if nOrdem == 6
    aNome := {}
  endif  

  select PagaARQ
  if nOrdem == 6
    set order to 2
  else  
    set order to nOrdem
  endif  
  set relation to Forn into FornARQ, to Port into PortARQ
  
  if nOrdem == 6
    dbgotop()
    do while !eof ()
      if Nota        >= cNotaIni .and. Nota        <= cNotaFin .and.; 
        Forn         >= cFornIni .and. Forn        <= cFornFin .and.;
        val( Port )  >= nPortIni .and. val( Port ) <= nPortFin .and.;
        Emis         >= dEmisIni .and. Emis        <= dEmisFin .and.;
        Vcto         >= dVctoIni .and. Vcto        <= dVctoFin .and.;
        Valor        >= nValMini .and. Valor       <= nValMaxi
        
        do case 
          case nNotPaga == 1
            if Pgto >= dPgtoIni .and. Pgto <= dPgtoFin
            else
              dbskip ()
              loop
            endif  
          case nNotPaga == 2
            if !empty( Pgto )
              dbskip ()
              loop
            endif
        endcase     
          
        aadd( aNome, { Nota, Forn, FornARQ->Nome, Emis, Vcto, Pgto,;
                       Desc, Pago, Valor, Acre, Juro, Mora } )
                       
        if len( aNome ) > 4095
          exit                          
        endif 
      endif     
      dbskip ()
    enddo
    
    asort( aNome,,, { | Nome01, Nome02 | Nome01[3] < Nome02[3] } )
    
    nLen := len( aNome )

    for nJ := 1 to nLen 
      cNota     := aNome[ nJ, 01 ] 
      cForn     := aNome[ nJ, 02 ] 
      cNome     := aNome[ nJ, 03 ] 
      dEmis     := aNome[ nJ, 04 ] 
      dVcto     := aNome[ nJ, 05 ] 
      dPgto     := aNome[ nJ, 06 ] 
      nDesc     := aNome[ nJ, 07 ] 
      nPago     := aNome[ nJ, 08 ] 
      nValor    := aNome[ nJ, 09 ] 
      nAcre     := aNome[ nJ, 10 ] 
      nJuro     := aNome[ nJ, 11 ] 
      nMora     := aNome[ nJ, 12 ] 
      
      if lInicio
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
        
        lInicio := .f.
      endif     

      if nLin == 0
        do case 
          case nNotPaga == 1
            Cabecalho( 'Contas a Pagar - Pagas', 132, 1 )
          case nNotPaga == 2
            Cabecalho( 'Contas a Pagar', 132, 1 )
          case nNotPaga == 3
            Cabecalho( 'Contas a Pagar - Ambas', 132, 1 )
        endcase    
        CabPaga()
      endif

      if dVcto < date() .and. nJuro == 0
        if Acre > 0
          nJuro := ( date() - dVcto ) * ( ( nValor - nDesc ) * ( nAcre / 30 ) / 100 )
        else
          nJuro := ( ( date() - dVcto ) * ( ( ( nValor - nDesc ) * nMora ) / 100 ) )
        endif
      endif
      
      do case
        case nOrdem == 1 
          if Nota != cNotaAnt
            nValorAcum := 0
            cNotaAnt   := Nota
          endif
        case nOrdem == 2 
          if Vcto != dVctoAnt
            nValorAcum := 0
            dVctoAnt   := Vcto
          endif
        case nOrdem == 3 
          if Pgto != dPgtoAnt
            nValorAcum := 0
            dPgtoAnt   := Pgto
          endif
        case nOrdem == 4 .or. nOrdem == 5
          if Forn != cFornAnt
            nValorAcum := 0
            cClieAnt   := Forn
          endif
      endcase

      nNotaPrn   := val ( cNota )
      nTotalNota += nValor
      nValorAcum += ( nValor + nJuro ) - nDesc
      nGeraValor += ( nValor + nJuro ) - nDesc
      nTotalDesc += nDesc
      nTotalJuro += nJuro
      nQtdeNot   ++

      @ nLin,001 say cForn
      @ nLin,008 say cNome                pict '@S23'
      @ nLin,031 say nNotaPrn             pict '9999999999-99'
      @ nLin,045 say dEmis                pict '99/99/9999'
      @ nLin,056 say dVcto                pict '99/99/9999'
      if !empty( dPgto )
        @ nLin,067 say dPgto              pict '99/99/9999'
        @ nLin,078 say dVcto - dPgto      pict '9999'
      else
        @ nLin,067 say '__/__/____'
        @ nLin,078 say dVcto - date()     pict '9999'
      endif

      @ nLin,083 say nValor               pict '@E 99,999.99'
      @ nLin,093 say nJuro                pict '@E 99,999.99'
      @ nLin,103 say nDesc                pict '@E 99,999.99'

      if !empty( dPgto )
        @ nLin,113 say nPago              pict '@E 99,999.99'
      else
        @ nLin,113 say '_________'
      endif

      @ nLin,123 say nValorAcum          pict '@E 99,999.99'

      if dVcto >= date()
        nGeraAVenc += ( nValor + nJuro ) - nDesc
      else
        nGeraVenci += ( nValor + nJuro ) - nDesc
      endif
      nLin ++

      if nLin >= pLimite
        Rodape(132)

        cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
        cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

        set printer to ( cArqu2 )
        set printer on
      endif
    next  
    
    aNome := {}
  else  
    dbgotop()
    do while !eof ()
      if Nota        >= cNotaIni .and. Nota        <= cNotaFin .and.;
        Forn         >= cFornIni .and. Forn        <= cFornFin .and.;
        val( Port )  >= nPortIni .and. val( Port ) <= nPortFin .and.;
        Emis         >= dEmisIni .and. Emis        <= dEmisFin .and.;
        Vcto         >= dVctoIni .and. Vcto        <= dVctoFin .and.;
        Valor        >= nValMini .and. Valor       <= nValMaxi
        
        do case 
          case nNotPaga == 1
            if Pgto >= dPgtoIni .and. Pgto <= dPgtoFin 
            else
              dbskip ()
              loop
            endif  
          case nNotPaga == 2
            if !empty( Pgto )
              dbskip ()
              loop
            endif
        endcase     

        if lInicio 
          set printer to ( cArqu2 )
          set device  to printer
          set printer on
    
          lInicio := .f.
        endif  

        if nLin == 0
          do case
            case nNotPaga == 1
              Cabecalho( 'Contas a Pagar - Pagas', 132, 1 )
            case nNotPaga == 2
              Cabecalho( 'Contas a Pagar', 132, 1 )
            case nNotPaga == 3
              Cabecalho( 'Contas a Pagar - Ambas', 132, 1 )
          endcase
          CabPaga()
        endif

        if Vcto < date() .and. Juro == 0
          if Acre > 0
            nJuro := ( date() - Vcto ) * ( ( Valor - Desc ) * ( Acre / 30 ) / 100 )
          else
            nJuro := ( ( date() - Vcto ) * ( ( ( Valor - Desc ) * Mora ) / 100 ) )
          endif
        else
          nJuro := Juro
        endif

        if Forn != cFornAnt
          nValorAcum := 0
          cFornAnt   := Forn
        endif

        nNotaPrn   := val ( Nota )
        nTotalNota += Valor
        nValorAcum += ( Valor + nJuro ) - Desc
        nGeraValor += ( Valor + nJuro ) - Desc
        nTotalDesc += Desc
        nTotalJuro += nJuro
        nQtdeNot   ++

        @ nLin,001 say Forn
        @ nLin,008 say FornARQ->Nome       pict '@S23'
        @ nLin,031 say nNotaPrn            pict '9999999999-99'
        @ nLin,045 say Emis                pict '99/99/9999'
        @ nLin,056 say Vcto                pict '99/99/9999'
        if !empty( Pgto )
          @ nLin,067 say Pgto              pict '99/99/9999'
          @ nLin,078 say Vcto - Pgto       pict '9999'
        else
          @ nLin,067 say '__/__/____'
          @ nLin,078 say Vcto - date()     pict '9999'
        endif
 
        @ nLin,083 say Valor               pict '@E 99,999.99'
        @ nLin,093 say nJuro               pict '@E 99,999.99'
        @ nLin,103 say Desc                pict '@E 99,999.99'

        if !empty( Pgto )
          @ nLin,113 say Pago              pict '@E 99,999.99'
        else
          @ nLin,113 say '_________'
        endif

        @ nLin,123 say nValorAcum          pict '@E 99,999.99'

        if Vcto >= date()
          nGeraAVenc += ( Valor + nJuro ) - Desc
        else
          nGeraVenci += ( Valor + nJuro ) - Desc
        endif
        nLin ++

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
  endif  
  
  if !lInicio 
    nLin ++
    @ nLin,001 say 'Total Geral:'
    @ nLin,016 say 'Qtde. Notas'
    @ nLin,028 say nQtdeNot      pict '9999'
    @ nLin,034 say 'A Vencer.'
    @ nLin,043 say nGeraAVenc    pict '@E 999,999.99'
    @ nLin,055 say 'Vencidas'
    @ nLin,064 say nGeraVenci    pict '@E 999,999.99'
    @ nLin,083 say nTotalNota    pict '@E 99,999.99'
    @ nLin,093 say nTotalJuro    pict '@E 99,999.99'
    @ nLin,103 say nTotalDesc    pict '@E 99,999.99'
    @ nLin,123 say nGeraValor    pict '@E 99,999.99'

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
        case nNotPaga == 1
          replace Titu   with "Relatório de Contas a Pagar - Notas Pagas"
        case nNotPaga == 2
          replace Titu   with "Relatório de Contas a Pagar"
        case nNotPaga == 3
          replace Titu   with "Relatório de Contas a Pagar - Ambas"
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

  if lAbrir
    select FornARQ
    close
    select PortARQ
    close
    select PagaARQ
    close
  else
    select PagaARQ
    set order  to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabPaga()
  @ 02,001 say 'Emis. ' + dtoc( dEmisIni ) + ' a ' + dtoc( dEmisFin )
  @ 02,032 say 'Vcto. ' + dtoc( dVctoIni ) + ' a ' + dtoc( dVctoFin )
  @ 02,063 say 'Pgto. ' + dtoc( dPgtoIni ) + ' a ' + dtoc( dPgtoFin )

  @ 02,090 say 'Portador'

  if cPortFin > cPortIni
    @ 02,099 say 'GERAL'
  else  
    @ 02,099 say PortARQ->Nome
  endif  
  
  @ 03,001 say 'Fornecedor                           Nota   Emissão    Vcto.      Pgto.      Dias     Valor     Juros  Desconto      Pago Acumulado'

  nLin := 5
return NIL

//
// Gerar Parcelas Autom tico - Contas a Pagar
//
function GeraPaga ()
  if NetUse( "FornARQ", .t. )
    VerifIND( "FornARQ" )
  
    #ifdef DBF_NTX
      set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
    #endif
  endif

  if NetUse( "PortARQ", .t. )
    VerifIND( "PortARQ" )
  
    #ifdef DBF_NTX
      set index to PortIND1, PortIND2
    #endif
  endif

  if NetUse( "PagaARQ", .t. )
    VerifIND( "PagaARQ" )
  
    #ifdef DBF_NTX
      set index to PagaIND1, PagaIND2, PagaIND3, PagaIND4, PagaIND5, PagaIND6
    #endif
  endif
  
  tGera := savescreen( 00, 00, 23, 79 )

  Janela( 06, 13, 18, 65, mensagem( 'Janela', 'GeraPaga', .f. ), .t. )
  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,15 say '   Fornecedor'
  @ 09,15 say '     Portador'
  @ 10,15 say '         Nota'                   
  @ 12,15 say 'Valor Parcela                            Qtde.'
  @ 13,15 say '  Valor Total                        Dia Vcto.'
  @ 14,15 say ' Data Emissão'
  @ 15,15 say '   Observação'

  setcolor( CorCampo )
  @ 08,36 say space(25)
  @ 09,36 say space(25)
  @ 17,41 say ' Confirmar '
  @ 17,54 say ' Cancelar '
  
  setcolor( CorAltKC )
  @ 17,42 say 'C'
  @ 17,56 say 'a'
  
  nForn  := nPort := nValor := nQtde := nValorTotal := nNota := 0
  nDia   := day( date() )
  dEmis  := date()
  cObse  := space(60)
  cAjuda := 'Gera'
  lAjud  := .t.
  aOpc   := {}
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,29 get nForn           pict '999999'           valid ValidForn( 08, 29, "PagaARQ", 25 )
  @ 09,29 get nPort           pict '999999'           valid ValidARQ( 09, 29, "PagaARQ", "Código" , "Port", "Descrição", "Nome", "Port", "nPort", .t., 6, "Consulta de Portadores", "PortARQ", 25 )
  @ 10,29 get nNota           pict '9999999999'  
  @ 12,29 get nValor          pict '@E 999,999.99'  
  @ 12,62 get nQtde           pict '99'             valid nQtde > 0 .and. CalcGT()
  @ 13,29 get nValorTotal     pict '@E 999,999.99'  valid CalcGV ()    
  @ 13,62 get nDia            pict '99'             valid nDia > 0 .and. nDia < 32
  @ 14,29 get dEmis           pict '99/99/9999'  
  @ 15,29 get cObse           pict '@S35'  
  read
  
  if lastkey() == K_ESC
    select PagaARQ
    close
    select FornARQ
    close
    select PortARQ
    close
    restscreen( 00, 00, 23, 79, tGera )
    return NIL
  endif  
  
  aadd( aOpc, { ' Confirmar ',  2, 'C', 17, 41, "Confirmar geração de Parcelas." } )
  aadd( aOpc, { ' Cancelar ',   3, 'A', 17, 54, "Cancelar geração de Parcelas." } )
      
  nOpc := HCHOICE( aOpc, 2, 1 )
  
  if lastkey() == K_ESC .or. nOpc == 2
    select PagaARQ
    close
    select FornARQ
    close
    select PortARQ
    close
    restscreen( 00, 00, 23, 79, tGera )
    return NIL
  endif  
    
  cNota := strzero( nNota, 10 )
  cForn := strzero( nForn, 6 )
  cPort := strzero( nPort, 6 )
  nMes  := month( dEmis )
  nAno  := year( date() ) 

  Janela( 11, 23, 14, 56, mensagem( 'Janela', 'Paga', .f. ), .f. )
  setcolor ( CorJanel + "," + CorCampo )

  @ 13,25 say "Aguarde! Gerando Parcelas... "
    
  select PagaARQ
  set order to 1
  for nL := 1 to nQtde
    cParc   := strzero( nL, 2 )
    cNotaPg := cNota + cParc
    
    cDia    := strzero( nDia, 2 )  
    cMes    := strzero( nMes, 2 )  
    cAno    := strzero( nAno, 4 )  
    dVcto   := ctod( cDia + '/' + cMes + '/' + cAno )
  
    dbseek( cNotaPg + cForn, .f. )

    if !eof()    
      if RegLock()
        dbdelete()
        dbunlock()
      endif  
    endif
    
    if AdiReg()
      if RegLock()
        replace Nota     with cNotaPg
        replace Forn     with cForn
        replace Emis     with dEmis
        replace Vcto     with dVcto
        replace Valor    with nValor
        replace Pgto     with ctod('  /  /  ')  
        replace Pago     with 0
        replace Juro     with 0
        replace Port     with cPort
        replace Obse     with cObse
        dbunlock()
      endif
    endif
    
    nMes ++
    
    if nMes > 12
      nMes := 1
      nAno ++
    endif
  next  

  select PagaARQ
  close
  select FornARQ
  close
  select PortARQ
  close
  restscreen( 00, 00, 23, 79, tGera )
return NIL  

//
// Calcula o Valor total
//
function CalcGT ()
  if nValorTotal == 0
    nValorTotal := nValor * nQtde
  endif
return(.t.)

//
// Calcula o Valor 
//
function CalcGV ()
  if nValor == 0
    nValor := nValorTotal / nQtde
    
    setcolor( CorCampo )
    @ 12,29 say nValor          pict '@E 999,999.99'  
  endif
return(.t.)

//
// Gerar Parcelas Autom tico - Contas a Receber
//
function GeraRece ()
 if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )
  
    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
    #endif
  endif

  if NetUse( "PortARQ", .t. )
    VerifIND( "PortARQ" )
  
    #ifdef DBF_NTX
      set index to PortIND1, PortIND2
    #endif
  endif

  if NetUse( "ReceARQ", .t. )
    VerifIND( "ReceARQ" )
  
    #ifdef DBF_NTX
      set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
    #endif
  endif
  
  tGera := savescreen( 00, 00, 23, 79 )

  Janela( 06, 13, 18, 65, mensagem( 'Janela', 'GeraRece', .f. ), .t. )
  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,15 say '      Cliente'
  @ 09,15 say '     Portador'
  @ 10,15 say '         Nota                             Tipo'                   
  @ 12,15 say 'Valor Parcela                            Qtde.'
  @ 13,15 say '  Valor Total                        Dia Vcto.'
  @ 14,15 say ' Data Emissão'
  @ 15,15 say '   Observação'

  setcolor( CorCampo )
  @ 08,36 say space(25)
  @ 09,36 say space(25)
  @ 17,41 say ' Confirmar '
  @ 17,54 say ' Cancelar '
  
  setcolor( CorAltKC )
  @ 17,42 say 'C'
  @ 17,56 say 'a'
  
  nClie  := nPort := nValor := nQtde := nValorTotal := nNota := 0
  nDia   := day( date() )
  dEmis  := date()
  cTipo  := "P"
  cObse  := space(60)
  cAjuda := 'Gera'
  lAjud  := .t.
  aOpc   := {}
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,29 get nClie           pict '999999'           valid ValidClie( 08, 29, "ReceARQ", , 25 )
  @ 09,29 get nPort           pict '999999'           valid ValidARQ( 09, 29, "ReceARQ", "Código" , "Port", "Descrição", "Nome", "Port", "nPort", .t., 6, "Consulta de Portadores", "PortARQ", 25 )
  @ 10,29 get nNota           pict '999999'  
  @ 10,62 get cTipo           pict '@!'               valid cTipo == 'N' .or. cTipo == 'P' .or. cTipo == 'O'
  @ 12,29 get nValor          pict '@E 999,999.99'  
  @ 12,62 get nQtde           pict '99'             valid nQtde > 0 .and. CalcGT()
  @ 13,29 get nValorTotal     pict '@E 999,999.99'  valid CalcGV ()    
  @ 13,62 get nDia            pict '99'             valid nDia > 0 .and. nDia < 32
  @ 14,29 get dEmis           pict '99/99/9999'  
  @ 15,29 get cObse           pict '@S35'  
  read
  
  if lastkey() == K_ESC
    select ReceARQ
    close
    select ClieARQ
    close
    select PortARQ
    close
    restscreen( 00, 00, 23, 79, tGera )
    return NIL
  endif  
  
  aadd( aOpc, { ' Confirmar ',  2, 'C', 17, 41, "Confirmar geração de Parcelas." } )
  aadd( aOpc, { ' Cancelar ',   3, 'A', 17, 54, "Cancelar geração de Parcelas." } )
      
  nOpc := HCHOICE( aOpc, 2, 1 )
  
  if lastkey() == K_ESC .or. nOpc == 2
    select PagaARQ
    close
    select FornARQ
    close
    select PortARQ
    close
    restscreen( 00, 00, 23, 79, tGera )
    return NIL
  endif  
    
  cNota := strzero( nNota, 6 )
  cClie := strzero( nClie, 6 )
  cPort := strzero( nPort, 6 )
  nMes  := month( dEmis )
  nAno  := year( date() ) 

  Janela( 11, 23, 14, 56, mensagem( 'Janela', 'Paga', .f. ), .f. )
  setcolor ( CorJanel + "," + CorCampo )

  @ 13,25 say "Aguarde! Gerando Parcelas... "
    
  select ReceARQ
  set order to 1
  for nL := 1 to nQtde
    cParc   := strzero( nL, 2 )
    cNotaPg := cNota + cParc
    
    cDia    := strzero( nDia, 2 )  
    cMes    := strzero( nMes, 2 )  
    cAno    := strzero( nAno, 4 )  
    dVcto   := ctod( cDia + '/' + cMes + '/' + cAno )
  
    dbseek( cNotaPg + cTipo, .f. )

    if !eof()    
      if RegLock()
        dbdelete()
        dbunlock()
      endif  
    endif
    
    if AdiReg()
      if RegLock()
        replace Nota     with cNotaPg
        replace Tipo     with cTipo
        replace Clie     with cClie
        replace Emis     with dEmis
        replace Vcto     with dVcto
        replace Valor    with nValor
        replace Pgto     with ctod('  /  /  ')  
        replace Pago     with 0
        replace Juro     with 0
        replace Port     with cPort
//      replace Obse     with cObse
        dbunlock()
      endif
    endif
    
    nMes ++
    
    if nMes > 12
      nMes := 1
      nAno ++
    endif
  next  

  select ReceARQ
  close
  select ClieARQ
  close
  select PortARQ
  close
  restscreen( 00, 00, 23, 79, tGera )
return NIL