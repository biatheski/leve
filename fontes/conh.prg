//  Leve, Conhecimentos
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

function Conh( xAlterar )

if NetUse( "TranARQ", .t. )
  VerifIND( "TranARQ" )
  
  cOpenTran := .t.

  #ifdef DBF_NTX
    set index to TranIND1, TranIND2
  #endif  
else
  cOpenTran := .f.
endif

if NetUse( "FornARQ", .t. )
  VerifIND( "FornARQ" )
  
  cOpenForn := .t.

  #ifdef DBF_NTX
    set index to FornIND1, FornIND2
  #endif  
else
  cOpenForn := .f.
endif

if NetUse( "ConhARQ", .t. )
  VerifIND( "ConhARQ" )
  
  cOpenConh := .t.

  #ifdef DBF_NTX
    set index to ConhIND1, ConhIND2, ConhIND3, ConhIND4
  #endif  
else
  cOpenConh := .f.
endif

//  Variaveis de Entrada para Item
nConh     := nTran   := nForn   := 0
cConh     := space(07)
cTran     := cForn   := space(04)
cEmis     := ctod('  /  /  ')
cVcto     := ctod('  /  /  ')
cPgto     := ctod('  /  /  ')
nValor    := nPago := nDesconto := 0
cNotaFisc := space(15)
nQtde     := nPeso := nTabela   := 0
cEspecie  := space(10)
cObse     := space(50)

//  Tela Item
if xAlterar
  Janela ( 04, 05, 18, 72, mensagem( 'Janela', 'Conh', .f. ), .t. )
  
  setcolor ( CorJanel + ',' + CorCampo )
else  
  Janela ( 03, 05, 18, 72, mensagem( 'Janela', 'Conh', .f. ), .t. )
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ 05,07 say '     Fornecedor'
endif  

@ 06,07 say ' Transportadora'
@ 07,07 say '   Conhecimento                   Nota Fiscal'

@ 09,07 say '   Data Emissão                         Qtde.'
@ 10,07 say 'Data Vencimento                       Espécie'
@ 11,07 say ' Data Pagamento                       Peso KG'

@ 13,07 say '  Valor Conhec.                  Valor Tabela'
@ 14,07 say '       Desconto                    Valor Pago'
@ 15,07 say '     Observação'
 
MostOpcao( 17, 07, 19, 48, 61 ) 
tConh := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Item
select ConhARQ
set order    to 1
set relation to Tran into TranARQ
if cOpenConh             
  dbgobottom ()
endif  
do while  .t.
  Mensagem('Conh', 'Janela' )

  cStat := space(04)
  
  select FornARQ
  set order to 1
  
  select TranARQ
  set order to 1
  
  select ConhARQ
  set order    to 1
  set relation to Tran into TranARQ, Forn into FornARQ

  restscreen( 00, 00, 23, 79, tConh )
  MostConh(xAlterar)
  
  if Demo ()
    exit
  endif  
  
  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostConh'
  cAjuda   := 'Conh'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
 
  if !xAlterar 
    @ 05,23 get nForn      pict '999999' valid ValidForn ( 05, 23, "ConhARQ" )
  endif  
  @ 06,23 get nTran        pict '999999' valid ValidARQ ( 06, 23, "ConhARQ", "Código" , "Tran", "Descrição", "Nome", "Trns", "nTran", .t., 6, "Consulta de Transportadora", "TranARQ", 40 )  
  @ 07,23 get nConh        pict '9999999'
  read
    
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. nConh == 0
    exit
  endif
  
  cConh   := strzero( nConh, 7 )

  if xAlterar
    cForn := NEntARQ->Forn
  else  
    cForn := strzero( nForn, 6 )
  endif  

  cTran   := strzero( nTran, 6 )

  //  Verificar existencia do Produto para Incluir ou Alterar
  select ConhARQ
  set order to 1
  dbseek( cForn + cTran + cConh, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif
  
  Mensagem( 'Conh', cStat )

  MostConh (xAlterar)
  
  if nPago != 0
    Alerta( mensagem( 'Alerta', 'Conh', .f. ) )
  endif
    
  EntrConh (xAlterar)
 
  Confirmar( 17, 07, 19, 48, 61, 3 )

  if cStat == 'prin'
    PrinConh (.f.)
  endif
    
  if cStat == 'excl'
    ExclRegi ()
  endif
  
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Nota        with cConh
        replace Tran        with cTran
        replace Forn        with cForn
        dbunlock ()
      endif
    endif  
  endif

  if cStat == 'alte' .or. cStat == 'incl'
    if RegLock()
      replace Emis        with cEmis
      replace NotaFisc    with cNotaFisc
      replace Qtde        with nQtde
      replace Especie     with cEspecie
      replace Peso        with nPeso
      replace Vcto        with cVcto
      replace Valor       with nValor
      replace Desconto    with nDesconto
      replace Obse        with cObse
      replace Tabela      with nTabela
      dbunlock ()
    endif
  endif
enddo

if cOpenForn
  select FornARQ
  close
endif  

if cOpenTran
  select TranARQ
  close
endif  

if cOpenConh
  select ConhARQ
  close
endif  

return NIL

//
// Entra Dados do Conhecimento
//
function EntrConh (xAlterar)
  if xAlterar
    cNotaFisc := alltrim( str( val( NEntARQ->Nota ) ) )
  endif  
  
  do while .t.
    lAlterou := .f.
    
    setcolor ( CorJanel + ',' + CorCampo )
    @ 07,53 get cNotaFisc 
    @ 09,23 get cEmis     pict '99/99/9999'
    @ 09,53 get nQtde     pict '999'
    @ 10,23 get cVcto     pict '99/99/9999'
    @ 10,53 get cEspecie  pict '@S10'
    @ 11,53 get nPeso     pict '@E 999,999.9'
    @ 13,23 get nValor    pict '@E 999,999,999.99'
    @ 13,53 get nTabela   pict '@E 999,999,999.99'
    @ 14,23 get nDesconto pict '@E 999,999,999.99'
    @ 15,23 get cObse     pict '@S40'
    read

    if cNotaFisc     != NotaFisc;  lAlterou := .t.
    elseif cEmis     != Emis;      lAlterou := .t.
    elseif nQtde     != Qtde;      lAlterou := .t.
    elseif cVcto     != Vcto;      lAlterou := .t.
    elseif cEspecie  != Especie;   lAlterou := .t.
    elseif nPeso     != Peso;      lAlterou := .t.
    elseif nValor    != Valor;     lAlterou := .t.
    elseif nTabela   != Tabela;    lAlterou := .t.
    elseif nDesconto != Desconto;  lAlterou := .t.
    elseif cObse     != Obse;      lAlterou := .t.
    endif
         
    if !Saindo (lAlterou)
      loop
    endif  
    exit
  enddo  
return NIL

//
// Mostra Dados do Conhecimento
//
function MostConh (xAlterar)
  setcolor ( CorCampo )
  if cStat != 'incl'
    nConh := val( Nota )
    cConh := Nota
    cForn := Forn
    nForn := val( Forn )
    cTran := Tran
    nTran := val( Tran )

    if !xAlterar
      @ 05,23 say cForn         pict '9999'
      @ 05,30 say FornARQ->Nome pict '@S40'
    endif  
    
    @ 06,23 say cTran           pict '9999'
    @ 06,30 say TranARQ->Nome   pict '@S40'
    @ 07,23 say nConh           pict '9999999'
  endif  
  
  cEmis     := Emis
  cNotaFisc := NotaFisc
  nQtde     := Qtde
  cObse     := Obse
  nDesconto := Desconto
  cEspecie  := Especie
  nPeso     := Peso
  cVcto     := Vcto
  cPgto     := Pgto
  nValor    := Valor
  nPago     := Pago
  nTabela   := Tabela
  
  @ 07,53 say cNotaFisc 
  @ 09,23 say cEmis     pict '99/99/9999'
  @ 09,53 say nQtde     pict '999'
  @ 10,23 say cVcto     pict '99/99/9999'
  @ 10,53 say cEspecie  pict '@S10'
  @ 11,23 say cPgto     pict '99/99/9999'
  @ 11,53 say nPeso     pict '@E 999,999.9'
  @ 13,23 say nValor    pict '@E 999,999,999.99'
  @ 13,53 say nTabela   pict '@E 999,999,999.99'
  @ 14,23 say nDesconto pict '@E 999,999,999.99'
  @ 14,53 say nPago     pict '@E 999,999,999.99'
  @ 15,23 say cObse     pict '@S40'
  
  if xAlterar
    PosiDBF( 04, 72 )
  else  
    PosiDBF( 03, 72 )
  endif    
return NIL

//
// Imprimir os Conhecimentos
//
function PrinConh ( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "TranARQ", .t. )
      VerifIND( "TranARQ" )
  
      #ifdef DBF_NTX
        set index to TranIND1, TranIND2
      #endif    
    endif

    if NetUse( "FornARQ", .t. )
      VerifIND( "FornARQ" )
  
      #ifdef DBF_NTX
        set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
      #endif    
    endif

    if NetUse( "ConhARQ", .t. )
      VerifIND( "ConhARQ" )
  
      #ifdef DBF_NTX
        set index to ConhIND1, ConhIND2, ConhIND3, ConhIND4
      #endif  
    endif
  endif  


  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 05, 05, 15, 74, mensagem( 'Janela', 'PrinConh', .f. ), .f. )
  Mensagem('Conh','PrinConh')

  setcolor ( CorJanel + ',' + CorCampo )
  @ 07,07 say 'Transportadora Inicial            Transportadora Final'
  @ 08,07 say '    Fornecedor Inicial                Fornecedor Final'
  @ 10,07 say '  Data Emissão Inicial              Data Emissão Final'
  @ 11,07 say '    Data Vcto. Inicial                Data Vcto. Final'
  @ 12,07 say '    Data Pgto. Inicial                Data Pgto. Final'
  @ 14,07 say '    Conhecimento Pagos'

  setcolor( CorCampo )
  @ 14,30 say ' Sim '
  @ 14,36 say ' Não '
  @ 14,42 say ' Ambos '

  setcolor( 'gr+/w' )
  @ 14,31 say 'S'
  @ 14,37 say 'N'
  @ 14,43 say 'A'

  setcolor ( CorJanel + ',' + CorCampo )

  select TranARQ
  set order to 1
  dbgotop ()
  nTranIni := val( Tran )
  dbgobottom ()
  nTranFin := val( Tran )

  select FornARQ
  set order to 1
  dbgotop ()
  nFornIni := val( Forn )
  dbgobottom ()
  nFornFin := val( Forn )

  select ConhARQ
  set order to 1
  dbgotop ()

  dVctoIni := ctod('01/01/1990')
  dVctoFin := ctod('31/12/2015')
  dEmisIni := ctod('01/01/1990')
  dEmisFin := ctod('31/12/2015')
  dPgtoIni := ctod('  /  /  ')
  dPgtoFin := ctod('  /  /  ')
  aOpcoes  := {}
  nNotPaga := 2

  @ 07,30 get nTranIni  pict '999999'              valid ValidARQ( 99, 99, "ConhARQ", "Código" , "Tran", "Descrição", "Nome", "Tran", "nTranIni", .t., 6, "Consulta de Transportadora", "TranARQ", 30 )
  @ 07,62 get nTranFin  pict '999999'              valid ValidARQ( 99, 99, "ConhARQ", "Código" , "Tran", "Descrição", "Nome", "Tran", "nTranFin", .t., 6, "Consulta de Transportadora", "TranARQ", 30 ) .and. nTranFin >= nTranIni
  @ 08,30 get nFornIni  pict '999999'              valid ValidForn( 99, 99, "ConhARQ", "nFornIni" )
  @ 08,62 get nFornFin  pict '999999'              valid ValidForn( 99, 99, "ConhARQ", "nFornFin" ) .and. nFornFin >= nFornIni
  @ 10,30 get dEmisIni  pict '99/99/9999'
  @ 10,62 get dEmisFin  pict '99/99/9999'          valid dEmisFin >= dEmisIni
  @ 11,30 get dVctoIni  pict '99/99/9999'
  @ 11,62 get dVctoFin  pict '99/99/9999'          valid dVctoFin >= dVctoIni
  @ 12,30 get dPgtoIni  pict '99/99/9999'
  @ 12,62 get dPgtoFin  pict '99/99/9999'          valid dPgtoFin >= dPgtoIni
  read

  if lastkey() == K_ESC
    select ConhARQ
    if lAbrir
      close
      select TranARQ
      close
    else  
      set order to 1
      dbgobottom ()
    endif
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  aadd( aOpcoes, { ' Sim ' ,   2, 'S', 14, 30, "Relatório dos Conhecimentos Pagos." } )
  aadd( aOpcoes, { ' Não ',    2, 'N', 14, 36, "Relatório dos Conhecimentos a Pagar." } )
  aadd( aOpcoes, { ' Ambos ',  2, 'A', 14, 42, "Relatório de todos os conhecimentos." } )
   
  nNotPaga := HCHOICE( aOpcoes, 3, nNotPaga )

  if lastkey() == K_ESC
    select ConhARQ
    if lAbrir
      close
      select TranARQ
      close
      select FornARQ
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
  cTranIni  := strzero( nTranIni, 4 )
  cTranFin  := strzero( nTranFin, 4 )
  cFornIni  := strzero( nFornIni, 4 )
  cFornFin  := strzero( nFornFin, 4 )

  nTotaConh := nTotaTabe := 0
  cTranAnt  := space(06)
  lInicio   := .t.
 
  select ConhARQ
  set order    to 3
  set relation to Tran into TranARQ, Forn into FornARQ
  dbseek( cTranIni, .t. )
  do while Tran >= cTranIni .and. Tran <= cTranFin .and. !eof()  
    if Forn >= cFornIni .and. Forn <= cFornFin .and.;   
       Emis >= dEmisIni .and. Emis <= dEmisFin .and.; 
       Vcto >= dVctoIni .and. Vcto <= dVctoFin

      do case 
        case nNotPaga == 1
          if Pgto >= dPgtoIni .and. Pgto <= dPgtoFin .and. !empty( Pgto )
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
        if nNotPaga == 1
          Cabecalho( 'Conhecimento Pagos', 132, 3 )
        else  
          Cabecalho( 'Conhecimento a Pagar', 132, 3 )
        endif  
        CabConh()
      endif
    
      if Tran != cTranAnt
        if cTranAnt != space(06)
          nLin ++
          @ nLin,070 say 'Total'
          @ nLin,082 say nTotaConh              pict '@E 999,999.99'
          @ nLin,093 say nTotaTabe              pict '@E 999,999.99'

          nLin      ++
          nTotaConh := nTotaTabe := 0
        endif
      
        cTranAnt := Tran 
       
        @ nLin,001 say Tran                     pict '999999'
        @ nLin,008 say TranARQ->Nome
        nLin ++
      endif    
      @ nLin,006 say Nota
      @ nLin,014 say NotaFisc                   pict '@S8'
      @ nLin,023 say Emis                       pict '99/99/9999'
      @ nLin,034 say Vcto                       pict '99/99/9999'  

      if !empty( Pgto )
        @ nLin,045 say Pgto                     pict '99/99/9999'
      else 
        @ nLin,045 say '__________'
      endif
       
      @ nLin,056 say Qtde                       pict '99999'
      @ nLin,062 say Especie                    pict '@S09'  
      @ nLin,072 say Peso                       pict '@E 99,999.9'
      @ nLin,082 say Valor                      pict '@E 999,999.99'
      @ nLin,093 say Tabela                     pict '@E 999,999.99'
      @ nLin,104 say Forn                       pict '9999'
      @ nLin,109 say FornARQ->Nome              pict '@S23'  
     
      nTotaConh += Valor
      nTotaTabe += Tabela
      nLin      ++

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
    @ nLin,070 say 'Total'
    @ nLin,082 say nTotaConh              pict '@E 999,999.99'
    @ nLin,093 say nTotaTabe              pict '@E 999,999.99'
    Rodape(132)
  endif
 
  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 132 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      if nNotPaga == 1
        replace Titu     with "Relatório de Conhecimento Pagos"
      else  
        replace Titu     with "Relatório de Conhecimento a Pagar"
      endif  
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
    select TranARQ
    close
    select FornARQ
    close
    select ConhARQ
    close
  else
    select ConhARQ
    set order to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabConh()
  @ 02,001 say 'Emis. ' + dtoc( dEmisIni ) + ' a ' + dtoc( dEmisFin )
  if !empty( dVctoIni )
    @ 02,032 say 'Vcto. ' + dtoc( dVctoIni ) + ' a ' + dtoc( dVctoFin )
  endif  
  if !empty( dPgtoIni )
    @ 02,063 say 'Pgto. ' + dtoc( dPgtoIni ) + ' a ' + dtoc( dPgtoFin )
  endif  
  @ 03,001 say 'Transportadora'
  @ 04,006 say 'Conh.  N. Fiscal Emissão    Vcto.      Pgto.      Qtde  Espˆcie    Peso KG.      Valor     Tabela Fornecedor' 

  nLin     := 6
  cTranAnt := space(06)
return NIL