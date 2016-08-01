//  Leve, Entrada de Notas
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

function ENot ()

if NetUse( "PortARQ", .t. )
  VerifIND( "PortARQ" )
  
  eOpenPort := .t.
  
  #ifdef DBF_NTX
    set index to PortIND1, PortIND2
  #endif  
else
  eOpenPort := .f.  
endif

if NetUse( "FornARQ", .t. )
  VerifIND( "FornARQ" )
  
  eOpenForn := .t.
  
  #ifdef DBF_NTX
    set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
  #endif  
else
  eOpenForn := .f.  
endif

if NetUse( "ConhARQ", .t. )
  VerifIND( "ConhARQ" )
  
  eOpenConh := .t.
  
  #ifdef DBF_NTX
    set index to ConhIND1, ConhIND2, ConhIND3, ConhIND4
  #endif  
else
  eOpenConh := .f.  
endif

if NetUse( "ProdARQ", .t. )
  VerifIND( "ProdARQ" )
  
  eOpenProd := .t.
  
  #ifdef DBF_NTX
    set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5
  #endif  
else
  eOpenProd := .f.  
endif

if NetUse( "NEntARQ", .t. )
  VerifIND( "NEntARQ" )
  
  eOpenNEnt := .t.
  
  #ifdef DBF_NTX
    set index to NEntIND1
  #endif  
else
  eOpenNEnt := .f.  
endif

if NetUse( "INEnARQ", .t. )
  VerifIND( "INEnARQ" )
  
  eOpenINEn := .t.
  
  #ifdef DBF_NTX
    set index to INEnIND1
  #endif  
else
  eOpenINEn := .f.  
endif

if NetUse( "CondARQ", .t. )
  VerifIND( "CondARQ" )

  eOpenCond := .t.
  
  #ifdef DBF_NTX
    set index to CondIND1, CondIND2
  #endif  
else
  eOpenCond := .f.  
endif

if NetUse( "PagaARQ", .t. )
  VerifIND( "PagaARQ" )
  
  eOpenPaga := .t.
  
  #ifdef DBF_NTX
    set index to PagaIND1, PagaIND2, PagaIND3, PagaIND4, PagaIND5, PagaIND6
  #endif  
else
  eOpenPaga := .f.  
endif

aOpcoes  := {}
aArqui   := {}
ENotARQ  := CriaTemp(0)
ENotIND1 := CriaTemp(1)
cChave   := "Sequ"

aadd( aArqui, { "Sequ",       "C", 004, 0 } )
aadd( aArqui, { "Prod",       "C", 006, 0 } )
aadd( aArqui, { "Produto",    "M", 010, 0 } )
aadd( aArqui, { "Qtde",       "N", 012, 3 } )
aadd( aArqui, { "Desc",       "N", 007, 2 } )
aadd( aArqui, { "ICMS",       "N", 007, 2 } )
aadd( aArqui, { "IPI",        "N", 007, 2 } )
aadd( aArqui, { "PrecoCusto", "N", 015, 6 } )
aadd( aArqui, { "Regi",       "N", 008, 0 } )
aadd( aArqui, { "Novo",       "L", 001, 0 } )
aadd( aArqui, { "Lixo",       "L", 001, 0 } )

dbcreate( ENotARQ , aArqui )
   
if NetUse( ENotARQ, .f., 30 )
  cENotTMP := alias ()
    
  #ifdef DBF_CDX
    index on &cChave tag &ENotIND1
  #endif

  #ifdef DBF_NTX
    index on &cChave to &ENotIND1
  
    set index to &ENotIND1
  #endif  
endif

//  Variaveis para Entrada de dados
nNota        := nQtde       := nValorTotal  := 0
cNota        := space(10)
dEmis        := dEntr       := ctod('  /  /  ')
nSequ        := nFrete      := nTotalNota   := nPrecoTotal := 0
nDesconto    := nICMS       := nSequPrx     := nForn       := 0
nOutraDesp   := nBaICMSub   := nVaICMSub    := nSeguro     := 0
nCond        := nIPI        := nTotalIPI    := nProd       := 0
nPrecoCusto  := nTotalQtde  := nBaseICMS    := nPort       := 0
cConta       := space(01)
cProd        := cForn       := cPort        := space(04)
cObse        := cProduto    := space(60)
cCond        := space(02)
dVcto01      := dVcto02     := dVcto03      := dVcto04     := dVcto05  := ctod ('  /  /  ')
dVcto06      := dVcto07     := dVcto08      := dVcto09     := ctod ('  /  /  ')
nValor01     := nValor02    := nValor03     := nValor04    := nValor05 := 0
nValor06     := nValor07    := nValor08     := nValor09    := 0
nIPIAnt      := nDescAnt    := 0
cFaturas     := "X"
 
Janela ( 01, 01, 21, 76, mensagem( 'Janela', 'ENot', .f. ), .t. )
setcolor ( CorJanel + ',' + CorCampo )

@ 03,04 say '      Nota'
@ 04,04 say 'Fornecedor' 
@ 06,04 say '   Emissão                               Entrada'  
@ 07,04 say 'Observação'

@ 09,02 say 'Codigo Nome          Qtde.     P. Custo  Desc P. Total  ICMS  IPI V. IPI'
@ 10,01 say chr(195) + replicate( chr(196), 74 ) + chr(180)

@ 10,08 say chr(194) 
@ 10,22 say chr(194) 
@ 10,32 say chr(194) 
@ 10,42 say chr(194) 
@ 10,47 say chr(194) 
@ 10,57 say chr(194) 
@ 10,63 say chr(194)
@ 10,67 say chr(194)

for nY := 11 to 16
  @ nY,08 say chr(179)
  @ nY,22 say chr(179)
  @ nY,32 say chr(179)
  @ nY,42 say chr(179)
  @ nY,47 say chr(179)
  @ nY,57 say chr(179)
  @ nY,63 say chr(179)
  @ nY,67 say chr(179)
next  
  
@ 17,01 say chr(195) + replicate( chr(196), 74 ) + chr(180)
@ 17,08 say chr(193)
@ 17,22 say chr(193)
@ 17,32 say chr(193)
@ 17,42 say chr(193)
@ 17,47 say chr(193)
@ 17,57 say chr(193)
@ 17,63 say chr(193)
@ 17,67 say chr(193)

@ 18,04 say 'Desconto'
@ 18,43 say 'Valor Total Nota'

MostOpcao( 20, 04, 16, 52, 65 ) 
tEnot := savescreen( 00, 00, 24, 79 )
  
select NEntARQ
set order to 1 
dbgobottom ()

do while .t.
  Mensagem( 'ENot', 'Janela' )

  cStat := cStatAux := space(04)
  restscreen( 00, 00, 23, 79, tEnot )
  
  select( cENotTMP )
  zap
  
  select CondARQ
  set order to 1 
  
  select FornARQ
  set order to 1
    
  select ProdARQ
  set order to 1

  select INEnARQ
  set relation to Prod into ProdARQ
  set order    to 1

  select NEntARQ
  set order    to 1  
  set relation to Cond into CondARQ, to Forn into FornARQ, to Port into PortARQ
  
  MostEnot ()
  
  if Demo ()
    exit
  endif  
  
  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostEnot'
  cAjuda   := 'Enot'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()

  @ 03,15 get nNota          pict '9999999999'
  @ 04,15 get nForn          pict '999999' valid ValidForn( 04, 15, "NEntARQ" )
  read
  
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC
    exit
  endif

  cNota     := strzero( nNota, 10 )
  cForn     := strzero( nForn, 6 )
  cFornEnot := cForn
  
  setcolor( CorCampo )
  @ 03,15 say cNota            pict '9999999999'
  @ 04,15 say cForn
  @ 04,22 say FornARQ->Nome

  //  Verificar existencia das Notas para Incluir ou Alterar
  select NEntARQ
  set order to 1
  dbseek( cForn + cNota, .f. ) 
  if eof()
    cStat    := 'incl'
    cFaturas := "X"
  else
    cStat    := 'alte'
    cFaturas := " "
  endif

  Mensagem( 'ENot', cStat )
  
  select INEnARQ
  set order to 1
  dbseek( cForn + cNota, .t. )
  do while Forn == cForn .and. Nota == cNota
    nRegi := recno ()

    select( cENotTMP )
    if AdiReg()
      if RegLock()
        replace Sequ       with INEnARQ->Sequ
        replace Prod       with INEnARQ->Prod
        replace Produto    with INEnARQ->Produto
        replace Qtde       with INEnARQ->Qtde
        replace Desc       with INEnARQ->Desc
        replace ICMS       with INEnARQ->ICMS
        replace IPI        with INEnARQ->IPI
        replace PrecoCusto with INEnARQ->PrecoCusto
        replace Regi       with nRegi
        replace Novo       with .f.
        replace Lixo       with .f.
        dbunlock ()
      endif
    endif
    
    select INEnARQ
    dbskip ()
  enddo
  
  select NEntARQ
  
  eStatAnt := cStat

  MostEnot ()
  EntrEnot ()  
  EntrNotE ()
  EntrAdiE ()
  EntrVctE ()
  
  cForn := cFornEnot 

  Confirmar( 20, 04, 16, 52, 65, 3 ) 
    
  if cStat == 'excl'
    EstoEnot ()
  endif

  if lastkey() == K_ESC .or. cStat == 'loop'
    loop
  endif  

  select NEntARQ
  set order to 1
  
  if eStatAnt == 'incl'
    if AdiReg()
      if RegLock()
        replace Nota     with cNota
        replace Forn     with cForn
        dbunlock ()
      endif
    endif
  endif  

  if eStatAnt == 'incl' .or. eStatAnt == 'alte'
    if RegLock()
      replace Emis       with dEmis
      replace Entr       with dEntr
      replace Obse       with cObse
      replace Port       with cPort
      replace Desconto   with nDesconto
      replace Frete      with nFrete
      replace Seguro     with nSeguro
      replace Conta      with cConta
      replace TotalNota  with nTotalNota
      replace BaICMSub   with nBaICMSub
      replace VaICMSub   with nVaICMSub  
      replace OutraDesp  with nOutraDesp
      dbunlock ()
    endif

    GravEnot ()
    
    if cConta == 'F'
      Conh(.t.)
    endif  
  endif
  
  if cStat == 'prin'
    PrinEnot (.f.)
  endif
enddo

if eOpenPort
  select PortARQ
  close
endif  

if eOpenForn
  select FornARQ
  close
endif  

if eOpenConh
  select ConhARQ
  close
endif  

if eOpenProd
  select ProdARQ
  close
endif  
  
if eOpenNEnt
  select NEntARQ
  close
endif  

if eOpenINEn
  select INEnARQ
  close
endif

if eOpenCond
  select CondARQ
  close
endif

if eOpenPaga
  select PagaARQ
  close
endif

select( cENotTMP )
close
ferase( ENotARQ )
ferase( ENotIND1 )

//
// Mostra os dados Nota de Entrada
//
function MostEnot()
  
  setcolor( CorCampo )
  if cStat != 'incl'  
    cNota := Nota    
    nNota := val( Nota )
    cForn := Forn 
    nForn := val( Forn )
    
    @ 04,15 say cForn
    @ 04,22 say FornARQ->Nome
    @ 03,15 say nNota            pict '9999999999'
  endif  
   
  dEmis      := Emis  
  dEntr      := Entr
  cObse      := Obse
  cPort      := Port
  nPort      := val( Port )
  cCond      := Cond
  nCond      := val( Cond )
  cPort      := Port
  nPort      := val( Port )
  nLin       := 11
  nTotalNota := TotalNota
  nDesconto  := Desconto
  nDescAnt   := Desconto
  nIPIAnt    := 0

  dVcto01    := Vcto1
  dVcto02    := Vcto2
  dVcto03    := Vcto3
  dVcto04    := Vcto4
  dVcto05    := Vcto5
  dVcto06    := Vcto6
  dVcto07    := Vcto7
  dVcto08    := Vcto8
  dVcto09    := Vcto9
  nValor01   := Valor1
  nValor02   := Valor2
  nValor03   := Valor3
  nValor04   := Valor4
  nValor05   := Valor5
  nValor06   := Valor6
  nValor07   := Valor7
  nValor08   := Valor8
  nValor09   := Valor9
  
  @ 06,15 say dEmis               pict '99/99/9999'
  @ 06,53 say dEntr               pict '99/99/9999'
  @ 07,15 say cObse               pict '@S50'

  if cStat == 'alte' .or. cStat == space(04)
    setcolor( CorJanel )
    for nG := 1 to 6  
      @ nLin, 02 say '      '    
      @ nLin, 09 say space(13)
      @ nLin, 23 say '         '
      @ nLin, 33 say '         '
      @ nLin, 43 say '    '
      @ nLin, 48 say '         '
      @ nLin, 58 say '     '
      @ nLin, 64 say '  '
      @ nLin, 68 say '        '
      nLin ++
    next

    nLin := 11

    setcolor( CorJanel )
    select INEnARQ
    set order to 1
    dbseek( cForn + cNota, .t. )
    do while Nota == cNota .and. Forn == cForn .and. !eof()
      if nLin < 17
        @ nLin, 02 say Prod                  pict '999999'    
        if Prod == '999999'
          @ nLin, 09 say Produto             pict '@S13'
        else  
          @ nLin, 09 say ProdARQ->Nome       pict '@S13'
        endif  
        if EmprARQ->Inteira == "X"
          @ nLin, 23 say Qtde                pict '@E 999999999'
        else  
          @ nLin, 23 say Qtde                pict '@E 99999.999'
        endif  
        @ nLin, 33 say PrecoCusto            pict PictPreco(9)
        @ nLin, 43 say Desc                  pict '@E 99.9'
        @ nLin, 48 say Qtde * PrecoCusto     pict '@E 99,999.99'
        @ nLin, 58 say ICMS                  pict '@E 99.99'
        @ nLin, 64 say IPI                   pict '99'
        @ nLin, 68 say ( ( Qtde * PrecoCusto ) *;
                        IPI ) / 100          pict '@E 9,999.99'
      endif   
                     
      nIPIAnt += ( ( ( PrecoCusto * Qtde ) * IPI ) / 100 ) 
      nLin    ++
      
      dbskip ()
    enddo
    
    select NEntARQ
    setcolor( CorCampo )
  else
    setcolor( CorJanel )
    for nG := 1 to 6  
      @ nLin, 02 say '      '    
      @ nLin, 09 say space(13)
      @ nLin, 23 say '         '
      @ nLin, 33 say '         '
      @ nLin, 43 say '    '
      @ nLin, 48 say '         '
      @ nLin, 58 say '     '
      @ nLin, 64 say '  '
      @ nLin, 68 say '        '
    nLin ++
    next
    setcolor( CorCampo )
  endif  
  
  @ 18,13 say nDesconto              pict '@E 999,999,999.99'
  @ 18,61 say nTotalNota             pict '@E 999,999,999.99'
  
  PosiDBF( 01, 76 )
return NIL

//
// Entra os dados da Nota de Entrada
//
function EntrEnot ()
  local GetList := {}

  if empty( dEntr )
    dEntr := date()
  endif  
  
  do while .t.
    lAlterou := .f.
  
    setcolor ( CorJanel + ',' + CorCampo )
    @ 06,15 get dEmis           pict '99/99/9999' valid !empty( dEmis )
    @ 06,53 get dEntr           pict '99/99/9999'
    @ 07,15 get cObse           pict '@S50'
    read

    if dEmis != Emis;       lAlterou := .t.
    elseif dEntr != Entr;   lAlterou := .t.
    elseif cObse != Obse;   lAlterou := .t.
    endif
    
    if !Saindo(lAlterou)
      loop
    endif
    exit
  enddo    
return NIL    

//
// Entra com itens Adicionais
//
function EntrAdiE ()
  
  if lastkey() == K_ESC .or. lastkey() == K_PGDN
    return NIL
  endif

  tAdic := savescreen( 00, 00, 23, 79 )
  Janela( 08, 06, 15, 68, mensagem( 'Janela', 'EntrAdiE', .f. ), .f. )
  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,09 say '        Base ICMS                    Valor ICMS '
  @ 11,09 say '  Base ICMS subs.              Valor ICMS subs. '
  @ 12,09 say '      Valor Frete '
  @ 13,09 say '     Valor Seguro             Outras Desp. Asc.'
  @ 14,09 say '        Valor IPI '

  select NEntARQ

  nBaseICMS  := nValorICMS := nBaICMSub  := nVaICMSub := 0
  nValorIPI  := 0
  
  select( cENotTMP )
  set order to 1
  dbgotop ()
  do while !eof ()
    nBaseICMS  += ( PrecoCusto * Qtde )
    nValorICMS += ( ( PrecoCusto * Qtde ) * ICMS ) / 100
    nValorIPI  += ( ( PrecoCusto * Qtde ) * IPI ) / 100 

    dbskip ()
  enddo
  
  select NEntARQ
  nBaseICMS  -= nDesconto
  nFrete     := Frete
  nSeguro    := Seguro
  cConta     := Conta
  nOutraDesp := OutraDesp
  nBaICMSub  := BaICMSub
  nVaICMSub  := VaICMSub
  
  setcolor( CorCampo )
  @ 10,27 say nBaseICMS             pict '@E 999,999.99'
  @ 10,57 say nValorICMS            pict '@E 999,999.99'
  @ 14,27 say nValorIPI             pict '@E 999,999.99'
  @ 13,27 say nSeguro               pict '@E 999,999.99'
  @ 13,57 say nOutraDesp            pict '@E 999,999.99'

  nTotalNota -= nSeguro 
  nTotalNota -= nFrete 
  nTotalNota -= nOutraDesp 
  nTotalNota -= nVaICMSub 
   
  do while .t.
    lAlterou := .f.
 
    setcolor ( CorJanel + ',' + CorCampo )
    @ 11,27 get nBaICMSub         pict '@E 999,999.99'
    @ 11,57 get nVaICMSub         pict '@E 999,999.99'
    @ 12,27 get nFrete            pict '@E 999,999.99'
    @ 12,38 get cConta            pict '@S1' valid iif( cConta == 'C' .or. cConta == 'F' .or. !empty( cConta ), .t., alerta( mensagem( 'Alerta', 'EntrAdiE', .f. ) ) )   
    @ 13,27 get nSeguro           pict '@E 999,999.99'
    @ 13,57 get nOutraDesp        pict '@E 999,999.99'
    read

    if nBaICMSub      != BaICMSub;  lAlterou := .t.
    elseif nVaICMSub  != VaICMSub;  lAlterou := .t.
    elseif nFrete     != Frete;     lAlterou := .t.
    elseif cConta     != Conta;     lAlterou := .t.
    elseif nSeguro    != Seguro;    lAlterou := .t.
    elseif nOutraDesp != OutraDesp; lAlterou := .t.
    endif
    
    if !Saindo (lAlterou)
      loop
    endif  
    exit
  enddo  
  
  if lastkey () == K_ESC
    return NIL
  endif
  
  nTotalNota += nSeguro 
  nTotalNota += nFrete 
  nTotalNota += nOutraDesp 
  nTotalNota += nVaICMSub 
  
  restscreen( 00, 00, 23, 79, tAdic )

  setcolor( CorCampo )
  @ 18,61 say nTotalNota             pict '@E 999,999,999.99'
return NIL

//
// Calcula Vencimentos da Nota de Entrada
//
function VctoEnot()
  if lastkey() == K_ESC .or. lastkey() == K_PGDN
    return(.t.)
  endif

  if val( Cond ) != nCond .or. nTotalNota != NEntARQ->TotalNota
    dVcto01  := dVcto02  := dVcto03  := dVcto04  := dVcto05  := ctod ('  /  /  ')
    dVcto06  := dVcto07  := dVcto08  := dVcto09  := ctod ('  /  /  ')
    nValor01 := nValor02 := nValor03 := nValor04 := nValor05 := 0
    nValor06 := nValor07 := nValor08 := nValor09 := 0
 
    dVcto01  := dEmis + CondARQ->Vct1
    nValor01 := nTotalPagar
    nParcAll := 1

    if CondARQ->Vct2 != 0
      dVcto02  := dEmis + CondARQ->Vct2
      nValor01 := nValor02 := nTotalPagar / 2
      nParcAll ++
    endif

    if CondARQ->Vct3 != 0
      dVcto03  := dEmis + CondARQ->Vct3
      nValor01 := nValor02 := nValor03 := nTotalPagar / 3
      nParcAll ++
    endif

    if CondARQ->Vct4 != 0
      dVcto04  := dEmis + CondARQ->Vct4
      nValor01 := nValor02 := nValor03 := nValor04 := nTotalPagar / 4
      nParcAll ++
    endif

    if CondARQ->Vct5 != 0
      dVcto05  := dEmis + CondARQ->Vct5
      nValor01 := nValor02 := nValor03 := nValor04 := nValor05 := nTotalPagar / 5
      nParcAll ++
    endif

    if CondARQ->Vct6 != 0
      dVcto06  := dEmis + CondARQ->Vct6
      nValor01 := nValor02 := nValor03 := nValor04 := nValor05 := nValor06 := nTotalPagar / 6
      nParcAll ++
    endif

    if CondARQ->Vct7 != 0
      dVcto07  := dEmis + CondARQ->Vct7
      nValor01 := nValor02 := nValor03 := nValor04 := nValor05 := nValor06 := nValor07 := nTotalPagar / 7
      nParcAll ++
    endif

    if CondARQ->Vct8 != 0
      dVcto08  := dEmis + CondARQ->Vct8
      nValor01 := nValor02 := nValor03 := nValor04 := nValor05 := nValor06 := nValor07 := nValor08 := nTotalPagar / 8
      nParcAll ++
    endif

    if CondARQ->Vct9 != 0
      dVcto09  := dEmis + CondARQ->Vct9
      nValor01 := nValor02 := nValor03 := nValor04 := nValor05 := nValor06 := nValor07 := nValor08 := nValor09 := nTotalPagar / 9
      nParcAll ++
    endif
  endif  
  
  setcolor ( CorJanel )
  if nParcAll >= 2
    @ 08,11 say '       Vencimento 2              Valor 2 '
  endif  
  if nParcAll >= 3
    @ 09,11 say '       Vencimento 3              Valor 3 '
  endif  
  if nParcAll >= 4
    @ 10,11 say '       Vencimento 4              Valor 4 '
  endif  
  if nParcAll >= 5
    @ 11,11 say '       Vencimento 5              Valor 5 '
  endif  
  if nParcAll >= 6
    @ 12,11 say '       Vencimento 6              Valor 6 '
  endif  
  if nParcAll >= 7
    @ 13,11 say '       Vencimento 7              Valor 7 '
  endif  
  if nParcAll >= 8
    @ 14,11 say '       Vencimento 8              Valor 8 '
  endif  
  if nParcAll >= 9
    @ 15,11 say '       Vencimento 9              Valor 9 '
  endif  
  @ 08 + nParcAll,11 say '           Portador'
  @ 10 + nParcAll,50 say '[ ] Faturar'

  setcolor( CorCampo )
  @ 07,31 say dVcto01      pict '99/99/9999'
  @ 07,52 say nValor01     pict '@E 999,999,999.99'
  if nParcAll >= 2
    @ 08,31 say dVcto02    pict '99/99/9999'
    @ 08,52 say nValor02   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 3
    @ 09,31 say dVcto03    pict '99/99/9999'
    @ 09,52 say nValor03   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 4
    @ 10,31 say dVcto04    pict '99/99/9999'
    @ 10,52 say nValor04   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 5
    @ 11,31 say dVcto05    pict '99/99/9999'
    @ 11,52 say nValor05   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 6
    @ 12,31 say dVcto06    pict '99/99/9999'
    @ 12,52 say nValor06   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 7
    @ 13,31 say dVcto07    pict '99/99/9999'
    @ 13,52 say nValor07   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 8
    @ 14,31 say dVcto08    pict '99/99/9999'
    @ 14,52 say nValor08   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 9
    @ 15,31 say dVcto09    pict '99/99/9999'
    @ 15,52 say nValor09   pict '@E 999,999,999.99'
  endif  
return(.t.)

//
// Entra com os vencimentos
//
function EntrVctE ()
  local GetList := {}

  if lastkey () == K_ESC .or. lastkey() == K_PGDN
    return NIL
  endif  

  select NEntARQ
  set order to 1
  
  nValorPagar := nTotalNota - ( nFrete + nOutraDesp + nVaICMSub )   
  nTotalPagar := nValorPagar + ( nValorPagar * CondARQ->Acrs / 100 )
  dData       := Emis
  tVctE       := savescreen( 00, 00, 23, 79 )
  nParcAll    := 1

  MConEnot()
  
  do while .t.
    CondEnot()
    
    setcolor ( CorJanel + ',' + CorCampo )
    @ 07,31 get dVcto01    pict '99/99/9999'
    @ 07,52 get nValor01   pict '@E 999,999,999.99'

    if nParcAll >= 2
      @ 08,31 get dVcto02    pict '99/99/9999'
      @ 08,52 get nValor02   pict '@E 999,999,999.99'
    endif 
    if nParcAll >= 3
      @ 09,31 get dVcto03    pict '99/99/9999'
      @ 09,52 get nValor03   pict '@E 999,999,999.99'
    endif  
    if nParcAll >= 4
      @ 10,31 get dVcto04    pict '99/99/9999'
      @ 10,52 get nValor04   pict '@E 999,999,999.99'
    endif  
    if nParcAll >= 5
      @ 11,31 get dVcto05    pict '99/99/9999'
      @ 11,52 get nValor05   pict '@E 999,999,999.99'
    endif  
    if nParcAll >= 6
      @ 12,31 get dVcto06    pict '99/99/9999'
      @ 12,52 get nValor06   pict '@E 999,999,999.99'
    endif  
    if nParcAll >= 7
      @ 13,31 get dVcto07    pict '99/99/9999'
      @ 13,52 get nValor07   pict '@E 999,999,999.99'
    endif  
    if nParcAll >= 8
      @ 14,31 get dVcto08    pict '99/99/9999'
      @ 14,52 get nValor08   pict '@E 999,999,999.99'
    endif  
    if nParcAll >= 9
      @ 15,31 get dVcto09    pict '99/99/9999'
      @ 15,52 get nValor09   pict '@E 999,999,999.99'
    endif  
    @ 08 + nParcAll,31 get nPort      pict '999999'     valid ValidARQ( 08 + nParcAll, 31, "NEntARQ", "Código" , "Port", "Descrição", "Nome", "Port", "nPort", .t., 6, "Consulta de Portadores", "PortARQ", 30 )
    @ 10 + nParcAll,51 get cFaturas   pict '@!' valid empty( cFaturas ) .or. cFaturas == "X" 
    read
  
    cPort := strzero( nPort, 6 )
    cCond := strzero( nCond, 6 )
    restscreen( 00, 00, 23, 79, tVctE )
    return NIL
  enddo  
return NIL

function CondEnot ()
  local GetList := {}

  setcolor ( CorJanel + ',' + CorCampo )
  @ 05,31 get nCond      pict '999999'     valid ValidARQ( 05, 31, "NEntARQ", "Código" , "Cond", "Descrição", "Nome", "Cond", "nCond", .t., 6, "Consulta Condiç”es de Pagamento", "CondARQ", 40 ) .and. VctoEnot ()
  read

  MConEnot()
return NIL

//
// 
//
function MConEnot()
  Janela ( 03, 09, 11 + nParcAll, 68, mensagem( 'Janela', 'MConEnot', .f. ), .t. )
  if eStatAnt == 'incl'
    Mensagem ( 'PedF', 'Vcto' )
  else  
    Mensagem ( 'PedF', 'Vcto' )
  endif  

  setcolor ( CorJanel )
  @ 05,11 say 'Condiç”es Pagamento'
  @ 07,11 say '       Vencimento 1              Valor 1'
  if nParcAll >= 2
    @ 08,11 say '       Vencimento 2              Valor 2'
  endif  
  if nParcAll >= 3
    @ 09,11 say '       Vencimento 3              Valor 3'
  endif  
  if nParcAll >= 4
    @ 10,11 say '       Vencimento 4              Valor 4'
  endif  
  if nParcAll >= 5
    @ 11,11 say '       Vencimento 5              Valor 5'
  endif  
  if nParcAll >= 6
    @ 12,11 say '       Vencimento 6              Valor 6'
  endif  
  if nParcAll >= 7
    @ 13,11 say '       Vencimento 7              Valor 7'
  endif  
  if nParcAll >= 8
    @ 14,11 say '       Vencimento 8              Valor 8'
  endif  
  if nParcAll >= 9
    @ 15,11 say '       Vencimento 9              Valor 9'
  endif  
  @ 08 + nParcAll,11 say '           Portador'
  @ 10 + nParcAll,50 say '[ ] Faturar'
  
  setcolor( CorCampo )
  @ 05,31 say nCond      pict '999999'
  @ 05,38 say CondARQ->Nome
  @ 07,31 say dVcto01    pict '99/99/9999'
  @ 07,52 say nValor01   pict '@E 999,999,999.99'
  @ 08 + nParcAll,31 say cPort     pict '9999'
  @ 08 + nParcAll,38 say PortARQ->Nome
return NIL

//
// Entra com os itens 
//
function EntrNotE()
  local GetList := {}

  if lastkey () == K_ESC .or. lastkey() == K_PGDN
    return NIL
  endif  
  
  setcolor( CorJanel + ',' + CorCampo )
   
  select( cENotTMP )
  set order    to 1
  set relation to Prod into ProdARQ

  bFirst := {|| dbseek( '0001', .t. ) }
  bLast  := {|| dbseek( '9999', .t. ), dbskip(-1) }
  bFor   := {|| .t. }
  bWhile := {|| .t. }

  oEntrad           := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oEntrad:nTop      := 09
  oEntrad:nLeft     := 02
  oEntrad:nBottom   := 17
  oEntrad:nRight    := 75
  oEntrad:headsep   := chr(194)+chr(196)
  oEntrad:colsep    := chr(179)
  oEntrad:footsep   := chr(193)+chr(196)

  oEntrad:addColumn( TBColumnNew("Código" ,     {|| Prod } ) )
  oEntrad:addColumn( TBColumnNew("Nome",     {|| iif( Prod == '999999', left( Produto, 13 ), left( ProdARQ->Nome, 13 ) ) } ) ) 
  if EmprARQ->Inteira == "X"
    oEntrad:addColumn( TBColumnNew("Qtde.",  {|| transform( Qtde, '@E 999999999' ) } ) )
  else  
    oEntrad:addColumn( TBColumnNew("Qtde.",  {|| transform( Qtde, '@E 99999.999' ) } ) )
  endif  
  oEntrad:addColumn( TBColumnNew("P. Custo", {|| transform( PrecoCusto, PictPreco(9) ) } ) )
  oEntrad:addColumn( TBColumnNew("Desc",     {|| transform( Desc, '@E 99.9' ) } ) )
  oEntrad:addColumn( TBColumnNew("P. Total", {|| transform( PrecoCusto * Qtde, '@E 99,999.99' ) } ) )
  oEntrad:addColumn( TBColumnNew("ICMS",     {|| transform( ICMS, '@E 99.99' ) } ) )
  oEntrad:addColumn( TBColumnNew("IPI",      {|| transform( IPI, '99' ) } ) )
  oEntrad:addColumn( TBColumnNew("V. IPI",   {|| transform( ( ( PrecoCusto * Qtde ) * IPI ) / 100, '@E 9,999.99' ) } ) )

  oEntrad:goBottom()

  lExitRequested := .f.
  lAlterou       := .f.

  do while !lExitRequested
    Mensagem ( 'LEVE', 'Browse' )
 
    oEntrad:forcestable()

    if oEntrad:hitTop .and. !empty( Prod ) 
      oEntrad:refreshAll ()
      
      keyboard(chr(13)+chr(13))
      
      select NENTARQ
      
      EntrEnot ()
      
      select( cENotTMP )
//      loop  
    endif
    
    if ( !lAlterou ) .and. cStat == 'incl' .or. ( oEntrad:hitBottom .and. lastkey() != K_ESC ) 
      cTecla := K_INS
    else 
      cTecla := Teclar(0)
    endif  

    do case
      case cTecla == K_DOWN;       oEntrad:down()
      case cTecla == K_UP;         oEntrad:up()
      case cTecla == K_PGUP;       oEntrad:pageUp()
      case cTecla == K_PGDN;       oEntrad:pageDown()
      case cTecla == K_CTRL_PGDN;  oEntrad:goBottom()
      case cTecla == K_CTRL_PGUP;  oEntrad:goTop()
      case cTecla == K_ENTER;      EntrItEnot(.f.)
      case cTecla == K_INS
        do while lastkey() != K_ESC    
          EntrItENot(.t.)
        enddo  
        
        cTecla := " "

        oEntrad:refreshAll ()  
      case cTecla == K_DEL
        if RegLock()
          nTotalNota  -= ( Qtde * PrecoCusto )
          nDesconto  -= ( ( ( Qtde * PrecoCusto ) * Desc ) / 100 )

          setcolor( CorCampo )
          @ 18,13 say nDesconto        pict '@E 999,999,999.99'
          @ 18,61 say nTotalNota       pict '@E 999,999,999.99'
          
          replace Lixo           with .t.

          dbdelete ()
          dbunlock ()
        
          oEntrad:refreshCurrent()  
          oEntrad:goBottom() 
        endif  
      case cTecla == K_ESC
        if Saindo (lAlterou)
          lExitRequested := .t.
        else  
          lExitRequested := .f.
        endif  
      case cTecla == 46 
        nTotalIPI := nTotalQtde := 0
      
        select( cENotTMP )
        dbgotop ()
        do while !eof ()
          nTotalIPI  += ( ( ( PrecoCusto * Qtde ) * IPI ) / 100 )
          nTotalQtde += Qtde
          dbskip ()
        enddo
        
        @ 18,13 get nDesconto        pict '@E 999,999,999.99'
        read
         
        if cStat == 'incl'
          nTotalNota += nTotalIPI
          nTotalNota -= nDesconto
        else
          nTotalNota -= nIPIAnt  
          nTotalNota += nDescAnt  
          nTotalNota += nTotalIPI
          nTotalNota -= nDesconto
        endif
        
        setcolor( CorCampo )
        @ 18,61 say nTotalNota       pict '@E 999,999,999.99'
      
        lExitRequested := .t.
    endcase
  enddo
return NIL  

//
// Entra intens da nota
//
function EntrItEnot( lAdiciona )
  local GetList := {}
  local nSequ   := 0

  if lAdiciona 
    dbgobottom()
    nSequ := val( Sequ ) + 1
  
    if AdiReg()
      if RegLock()
        replace Sequ            with strzero( nSequ, 4 )
        replace Novo            with .t.
        replace Lixo            with .f.
        dbunlock ()
      endif
    endif    
    
    dbgobottom ()

    oEntrad:goBottom() 
    oEntrad:down()
    oEntrad:refreshAll()  

    oEntrad:forcestable()
      
    Mensagem( 'PedF', 'InclIten' )
  else
    Mensagem( 'PedF', 'AlteIten' )
  endif  

  set key K_F8 to Caixa

  nSequ       := val( Sequ )
  cSequ       := Sequ
  cProd       := Prod
  cProduto    := Produto
  nProd       := val( cProd )
  nQtde       := Qtde
  nDesc       := Desc
  nIPI        := IPI
  nICMS       := ICMS
  nPrecoCusto := PrecoCusto
  
  nDescAnt    := nDesc 
  nPrecoAnt   := nPrecoCusto 
  nQtdeAnt    := nQtde
  nValorIPI   := ( ( nPrecoCusto * nQtde ) * nIPI ) / 100
  nLin        := 10 + oEntrad:rowPos
  lAlterou    := .t.

  setcolor( CorCampo )
  @ nLin, 09 say ProdARQ->Nome         pict '@S13'
  if EmprARQ->Inteira == "X"
    @ nLin, 23 say nQtde               pict '@E 999999999'
  else  
    @ nLin, 23 say nQtde               pict '@E 99999.999'
  endif  
  @ nLin, 33 say nPrecoCusto           pict PictPreco(9)
  @ nLin, 43 say nDesc                 pict '@E 99.9' 
  @ nLin, 48 say nQtde * nPrecoCusto   pict '@E 99,999.99'
  @ nLin, 58 say nICMS                 pict '@E 99.99' 
  @ nLin, 64 say nIPI                  pict '99'
  @ nLin, 68 say nValorIPI             pict '@E 9,999.99'
  
  set key K_UP to UpNota()
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ nLin, 02 get cProd           pict '@K'            valid ValidProd( nLin, 02, cENotTMP, 'enot', 0, nPrecoCusto, 0 )
  if EmprARQ->Inteira == "X"
    @ nLin, 23 get nQtde         pict '@E 999999999'  valid VoltaUP () 
  else
    @ nLin, 23 get nQtde         pict '@E 99999.999'  valid VoltaUP ()
  endif  
  @ nLin, 33 get nPrecoCusto     pict PictPreco(9)    valid CalcTotal( nQtde, nPrecoCusto )
  @ nLin, 43 get nDesc           pict '@E 99.9'
  @ nLin, 58 get nICMS           pict '@E 99.99'
  @ nLin, 64 get nIPI            pict '99'
  read

  set key K_UP to
  set key K_F8 to 
  
  select( cENotTMP )

  if lastkey() == K_ESC
    if lAdiciona
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif  
    endif  

    oEntrad:refreshCurrent()  
    return NIL
  endif  
  
  if RegLock()
    replace Prod            with cProd
    replace Produto         with cProduto
    replace Qtde            with nQtde
    replace IPI             with nIPI
    replace ICMS            with nICMS
    replace Desc            with nDesc
    replace PrecoCusto      with nPrecoCusto
    replace Lixo            with .f.
    dbunlock ()
  endif
  
  oEntrad:refreshCurrent ()  
  
  lAlterou := .t.

  if !lAdiciona
    nTotalNota -= ( nQtdeAnt * nPrecoAnt )
    nDesconto  -= ( ( ( nQtdeAnt * nPrecoAnt ) * nDescAnt ) / 100 )

    nTotalNota += ( nQtde * nPrecoCusto )
    nDesconto  += ( ( ( nQtde * nPrecoCusto ) * nDesc ) / 100 )
  else   
    nTotalNota += ( nQtde * nPrecoCusto )
    nDesconto  += ( ( ( nQtde * nPrecoCusto ) * nDesc ) / 100 )
  endif
  
  setcolor( CorCampo )
  @ 18,13 say nDesconto        pict '@E 999,999,999.99'
  @ 18,61 say nTotalNota       pict '@E 999,999,999.99'
return NIL     

function VoltaUP()
  if lastkey() == K_UP
    set key K_UP to UpNota()
  else  
    set key K_UP to 
  endif  
return(.t.)

//
// Ver Caixa 
//
function Caixa()
  local GetList := {}
  local tCaixa  := savescreen( 00, 00, 23, 79 )
  local nQtCa   := 0
  local nUnCa   := 0
  local nPrCa   := 0

  //  Define Intervalo
  Janela ( 10, 22, 15, 56, mensagem( 'Janela', 'Caixa', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 12,24 say '     Qtde. Caixa'
  @ 13,24 say 'Unid. cada Caixa'
  @ 14,24 say 'Preço cada Caixa'
  
  @ 12,41 get nQtCa          pict '@E 999,999.999'
  @ 13,41 get nUnCa          pict '@E 999,999.999'
  @ 14,41 get nPrCa          pict '@E 9,999,999.9999'
  read 
  
  if lastkey() == K_ESC
    return NIL
  endif

  nQtde       := nQtCa * nUnCa
  nPrecoCusto := nPrCa / nUnCa

  restscreen( 00, 00, 23, 79, tCaixa )
  
  setcolor( CorCampo )
  @ nLin, 33 say nPrecoCusto            pict PictPreco(9)
  setcolor ( CorJanel + ',' + CorCampo )
return NIL
  
//
// Calcula o Preco Total
//  
function CalcTotal ( nQtde, nPrecoCusto )
  local GetList := {}
  
  if nPrecoCusto == 0
    nValorTotal := 0

    setcolor ( CorJanel + ',' + CorCampo )
    @ nLin, 48 get nValorTotal   pict '@E 99,999.99'  
    read
    
    setcolor( CorCampo )
    if nQtde > 0       
      nPrecoCusto := nValorTotal / nQtde
    else 
      nPrecoCusto := 0  
    endif  
  
    @ nLin, 33 say nPrecoCusto            pict PictPreco(9)
  endif  

  setcolor( CorCampo )
  @ nLin, 48 say nQtde * nPrecoCusto    pict '@E 99,999.99'
return(.t.)

//
// Excluir nota
//
function EstoEnot ()
  cStat  := 'loop'
  lEstq  := .f.
  
  select NEntARQ

  if ExclEstq ()
    select INEnARQ
    set order to 1
    dbseek( cForn + cNota, .t. )

    do while Forn == cForn .and. Nota == cNota .and. !eof()
      cProd := Prod
      nQtde := Qtde

      if lEstq
        select ProdARQ
        dbseek( cProd, .f. )
        if RegLock()
          replace Qtde      with Qtde - nQtde
          dbunlock ()
        endif
      endif
      
      select INEnARQ  
     
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif
      dbskip ()
    enddo    
    
    select PagaARQ
    set order to 1
    for nL := 1 to 9
      dbseek( cNota + strzero( nL, 2 ) + cForn, .f. )
      
      if found()
        if RegLock(0)
          dbdelete ()
          dbunlock ()
        endif  
      endif
    next
    select NEntARQ
  endif
return NIL

//
// Entra o estoque
//
function GravEnot()

  select NEntARQ
  if RegLock()
    replace Cond       with cCond
    replace Vcto1      with dVcto01
    replace Valor1     with nValor01
    replace Vcto2      with dVcto02
    replace Valor2     with nValor02
    replace Vcto3      with dVcto03
    replace Valor3     with nValor03
    replace Vcto4      with dVcto04
    replace Valor4     with nValor04
    replace Vcto5      with dVcto05
    replace Valor5     with nValor05
    replace Vcto6      with dVcto06
    replace Valor6     with nValor06
    replace Vcto7      with dVcto07
    replace Valor7     with nValor07
    replace Vcto8      with dVcto08
    replace Valor8     with nValor08
    replace Vcto9      with dVcto09
    replace Valor9     with nValor09
    dbunlock ()
  endif  
  
  Janela( 08, 22, 14, 61, mensagem( 'ENot', 'Altera', .f. ), .f. )
  setcolor( CorJanel )
  @ 10,24 say '    Alterar Preço Custo'
  @ 11,24 say '    Alterar Preço Venda'
  @ 12,24 say '   Calcular Preço Médio'
  @ 13,24 say ' Percentual Preço Custo       %'

  nPerCusto := 0

  setcolor( CorCampo )
  @ 10,48 say ' Sim '
  @ 10,54 say ' Não '
  @ 11,48 say ' Sim '
  @ 11,54 say ' Não '
  @ 12,48 say ' Sim '
  @ 12,54 say ' Não '
  @ 13,48 say nPerCusto        pict '@E 999.99'
  
  setcolor( CorAltKC )
  @ 10,49 say 'S'
  @ 10,55 say 'N'
  @ 11,49 say 'S'
  @ 11,55 say 'N'
  @ 12,49 say 'S'
  @ 12,55 say 'N'
 
  lAlte     := ConfLine( 10, 48, 1 )
  lVenda    := ConfLine( 11, 48, 1 )
  lMedio    := ConfLine( 12, 48, 2 )
    
  if lAlte 
    @ 13,48 get nPerCusto      pict '@E 999.99'
    read
  endif
    
  nFreteConh := 0
  
  select ConhARQ
  set order to 2
  dbseek( nNota, .f. )

  nFreteConh := Valor
  nTotalQtde := 0
   
  set deleted off   
  
  select( cENotTMP )
  set order to 1 
  dbgotop ()
  do while !eof ()
    nTotalQtde += Qtde
    dbskip ()
  enddo   
  
  dbgotop ()
  do while !eof ()
    if empty( Prod )
      dbskip ()
      loop
    endif  
      
    cProd       := Prod
    cProduto    := Produto
    nQtde       := Qtde
    nPrecoCusto := ( PrecoCusto - ( ( PrecoCusto * Desc ) / 100 ) ) 
    nDesc       := Desc
    nICMS       := ICMS
    nIPI        := IPI
    nValorIPI   := ( nPrecoCusto * nIPI ) / 100
    nICM        := ( nPrecoCusto * nICMS ) / 100
    
    if nTotalQtde == 0 .or. nFreteConh == 0
      nPrecoNovo := nPrecoCusto + nValorIPI
    else  
      nPrecoNovo := nPrecoCusto + ( nFreteConh / nTotalQtde ) + nValorIPI
    endif  

    nRegi       := Regi
    lLixo       := Lixo
      
    if Novo
      if Lixo
        dbskip ()
        loop
      endif  
    
      select INEnARQ
      if AdiReg()
        if RegLock()
          replace Nota       with cNota     
          replace Forn       with cForn
          replace Sequ       with &cENotTMP->Sequ
          replace Prod       with &cENotTMP->Prod
          replace Produto    with &cENotTMP->Produto
          replace Qtde       with &cENotTMP->Qtde
          replace Desc       with &cENotTMP->Desc
          replace IPI        with &cENotTMP->IPI 
          replace ICMS       with &cENotTMP->ICMS 
          replace PrecoCusto with &cENotTMP->PrecoCusto
          dbunlock ()
        endif
      endif   
  
      select ProdARQ
      set order to 1
      dbseek( cProd, .f. )
      if found ()
        if lMedio
          if ( Qtde + nQtde ) > 0 .and. ( ( Qtde * PrecoCusto ) + ( nQtde * nPrecoNovo ) ) > 0
            nPrecoMedio := ( ( Qtde * PrecoCusto ) + ( nQtde * nPrecoNovo ) ) / ( Qtde + nQtde )
          else
            nPrecoMedio := 0  
          endif    
          if nPerCusto > 0
            nPrecoMedio += ( ( nPrecoMedio * nPerCusto ) / 100 ) 
          endif  
        else  
          nPrecoMedio := nPrecoNovo + ( ( nPrecoNovo * nPerCusto ) / 100 )
        endif  

        if RegLock()
          replace Forn             with cForn
          if lAlte
            replace PrecoCusto     with nPrecoMedio
            if Lucro > 0
              if lVenda
                replace PrecoVenda   with ( ( ( nPrecoMedio * Lucro ) / 100 ) + nPrecoMedio )
              else
                replace Lucro        with ( ( PrecoVenda / PrecoCusto ) - 1 ) * 100             
              endif             
            endif  
          endif  
          replace Qtde             with Qtde + nQtde
          replace UltE             with dEmis
          dbunlock ()
        endif
      endif    
    else 
      select INEnARQ
      go nRegi
      
      cPrAnt := Prod
      nQtAnt := Qtde
          
      if RegLock()
        replace Prod          with cProd
        replace Produto       with cProduto
        replace Desc          with nDesc
        replace ICMS          with nICMS
        replace IPI           with nIPI
        replace PrecoCusto    with nPrecoNovo
        replace Qtde          with nQtde
        dbunlock ()
      endif  
          
      select ProdARQ
      set order to 1
      dbseek( cPrAnt, .f. )
      if found ()
        if RegLock()
          replace Qtde         with Qtde - nQtAnt
          replace UltE         with dEmis
          dbunlock ()
        endif
      endif    

      if !lLixo
        dbseek( cProd, .f. )
        if found ()
          if lMedio
            if ( Qtde + nQtde ) > 0 .and. ( ( Qtde * PrecoCusto ) + ( nQtde * nPrecoNovo ) ) > 0
              nPrecoMedio := ( ( Qtde * PrecoCusto ) + ( nQtde * nPrecoNovo ) ) / ( Qtde + nQtde )
            else
              nPrecoMedio := 0  
            endif
            if nPerCusto > 0
              nPrecoMedio += ( ( nPrecoMedio * nPerCusto ) / 100 )     
            endif
          else  
            nPrecoMedio := nPrecoNovo + ( ( nPrecoNovo * nPerCusto ) / 100 ) 
          endif  

          if RegLock()
            replace Forn             with cForn
            replace Qtde             with Qtde + nQtde
            if lAlte
              replace PrecoCusto     with nPrecoMedio
              if Lucro > 0
                if lVenda 
                  replace PrecoVenda   with ( ( ( nPrecoMedio * Lucro ) / 100 ) + nPrecoMedio )
                else
                  replace Lucro        with ( ( PrecoVenda / PrecoCusto ) - 1 ) * 100           
                endif
              endif             
            endif  
            replace UltE             with dEmis
            dbunlock ()
          endif
        endif    
      endif  

      select INEnARQ

      if lLixo
        if RegLock()
          dbdelete ()
          dbunlock ()
        endif
      endif
    endif 
      
    select( cENotTMP )
    dbskip ()
  enddo  
   
  set deleted on
  
  if cFaturas == "X"
    select PagaARQ
    set order to 1
    for nU := 1 to 9
      cParc   := strzero( nU, 2 )
      cNotaPg := cNota + cParc
      dbseek( cNotaPg + cForn, .f. )
     
      if nValor&cParc == 0
        if !eof ()    
          if RegLock()
            dbdelete ()
            dbunlock ()
          endif  
        endif
      else
        if eof () 
          if AdiReg()
            if RegLock()
              replace Nota  with cNotaPg
              replace Forn  with cForn
              dbunlock ()
            endif
          endif  
        endif
        if RegLock()
          replace Emis     with dEmis
          replace Vcto     with dVcto&cParc
          replace Valor    with nValor&cParc
          if dVcto&cParc == dEmis
            replace Pgto   with dVcto&cParc
            replace Pago   with nValor&cParc
          else
            replace Pgto   with ctod('  /  /  ')  
            replace Pago   with 0
            replace Juro   with 0
          endif  
          replace Port     with cPort
          replace Obse     with cObse
          dbunlock ()
        endif
      endif
    next  
  endif
return NIL

//
// Consulta os Notas de Entrada Cadastrados
//
function ConsEnot()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  tPrt := savescreen( 00, 00, 23, 79 )

  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )
     
    pOpenProd := .t. 
   
    #ifdef DBF_NTX
      set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5
    #endif  
  else  
    pOpenProd := .f.
  endif

  if NetUse( "CondARQ", .t. )
    VerifIND( "CondARQ" )
     
    pOpenCond := .t. 
   
    #ifdef DBF_NTX
      set index to CondIND1, CondIND2
    #endif  
  else  
    pOpenCond := .f.
  endif

  if NetUse( "NEntARQ", .t. )
    VerifIND( "NEntARQ" )

    pOpenNEnt := .t.  

    #ifdef DBF_NTX
      set index to NEntIND1
    #endif  
  else
    pOpenNEnt := .f.  
  endif

  if NetUse( "INEnARQ", .t. )
    VerifIND( "INEnARQ" )
    
    pOpenINEn := .t.

    #ifdef DBF_NTX
      set index to INEnIND1
    #endif  
  else
    pOpenINEn := .f. 
  endif
 
  nPag       := 1
  nLin       := 0
  cArqu2     := cArqu2 + "." + strzero( nPag, 3 )
  pForn      := FornARQ->Forn
  pNome      := FornARQ->Nome
  aProdutos  := {}
  pTotalPedi := 0
  tPeriodo   := savescreen( 00, 00, 23, 79 )
  dEmisIni   := ctod( '01/01/1900' )
  dEmisFin   := ctod( '31/12/2015' )
  
  Janela( 09, 24, 13, 51, mensagem( 'LEVE', 'Periodo', .f. ), .f. )
  Mensagem( 'ENot', 'ConsEnot' )

  setcolor( CorJanel )
  @ 11,26 say 'Emis. Inicial'
  @ 12,26 say '  Emis. Final'
  
  @ 11,40 get dEmisIni      pict '99/99/9999'
  @ 12,40 get dEmisFin      pict '99/99/9999' valid dEmisFin >= dEmisIni
  read
  
  restscreen( 00, 00, 23, 79, tPeriodo )
  
  set printer to ( cArqu2 )
  set device  to printer
  set printer on
  
  setprc( 0, 0 )
  
  @ nLin,pcol()+1 say 'Nota       Emissão    Produto                   Qtde.  P.Custo Cond. Pgto.                    Acrs.'
  nLin += 2
  
  select NEntARQ
  set order    to 1
  set relation to Cond into CondARQ
  dbseek( pForn, .t. )
  do while Forn == pForn
    if Emis >= dEmisIni .and. Emis <= dEmisFin

    pNota       := Nota
    nValorPagar := ( TotalNota - ( Frete + OutraDesp + VaICMSub ) )  
    nJuros      := ( nValorPagar * CondARQ->Acrs / 100 )
    pTotalPedi  := TotalNota
    lVez        := .t.
 
    @ nLin,001 say Nota              pict '9999999999' 
    @ nLin,012 say Emis              pict '99/99/9999' 

    select INEnARQ
    set order    to 1
    set relation to Prod into ProdARQ
    dbseek( pForn + pNota, .t. )
    do while Forn == pForn .and. Nota == pNota
      nProdElem := ascan( aProdutos, { |nElem| nElem[1] == Prod } )
      
      if nProdElem > 0
        aProdutos[ nProdElem, 4 ] += Qtde 
      else
        aadd( aProdutos, { Prod, ProdARQ->Nome, ProdARQ->Unid, Qtde } )         
      endif  
    
      @ nLin,023 say Prod              pict '999999'
      if Prod == '999999'
        @ nLin,030 say Produto         pict '@S16'
      else  
        @ nLin,030 say ProdARQ->Nome   pict '@S16'
      endif  
      if EmprARQ->Inteira == "X"
        @ nLin,047 say Qtde            pict '@E 9999999'
      else      
        @ nLin,047 say Qtde            pict '@E 99999.9'
      endif     
      @ nLin,055 say PrecoCusto        pict PictPreco(8)
      
      if lVez 
        @ nLin,064 say CondARQ->Nome         pict '@S28'
        @ nLin,094 say CondARQ->Acrs         pict '@E 999.99'
               
        lVez := .f.
      endif        
               
      nLin ++

      dbskip ()
    enddo
    
    if NEntARQ->Desconto > 0
      @ nLin,026 say 'Desconto'
      @ nLin,053 say NEntARQ->Desconto         pict '@E 999,999.99'
      nLin ++
    endif  
    
    if nJuros != 0
      @ nLin,026 say 'Juros'
      @ nLin,053 say nJuros          pict '@E 999,999.99'
      nLin ++
    endif  
    
      @ nLin,026 say 'Total Nota'
      @ nLin,037 say pTotalPedi        pict '@E 999,999.99'  
      nLin += 2
    
      select NEntARQ
    endif
    
    dbskip ()  
  enddo
  
  if pTotalPedi > 0
    nLin += 2
    @ nLin,01 say '-------------------------------------------------------------------'
    nLin ++
    @ nLin,01 say '                      Acumulado de Produtos'
    nLin ++
    @ nLin,01 say '-------------------------------------------------------------------'
    nLin ++
    @ nLin,01 say 'Codigo Descrição                                  Unid.       Qtde.'
    nLin      ++
    nQtdeProd := 0
    for nH := 1 to len( aProdutos )
      @ nLin,001 say aProdutos[ nH, 1 ]
      @ nLin,008 say aProdutos[ nH, 2 ]           pict '@S38'
      @ nLin,051 say aProdutos[ nH, 3 ]
      @ nLin,058 say aProdutos[ nH, 4 ]           pict '999999999'  

      nLin      ++
      nQtdeProd += aProdutos[ nH, 4 ]
    next
    @ nLin,01 say '-------------------------------------------------------------------'
    nLin ++
    @ nLin,035 say 'Total Geral de Produtos'
    @ nLin,058 say nQtdeProd                      pict '@E 9999999.9'  
 endif    
 
  set printer to
  set printer off
  set device  to screen
  
  if pTotalPedi > 0
    Janela( 06, 05, 19, 73, mensagem( 'Janela', 'ConsEnot', .f. ), .f. )
    setcolor( CorJanel + ',' + CorCampo )

    aD := directory( cArqu2, "D" )    
  
    if ad[1,2] > 64000
      Alerta( mensagem( 'Alerta', 'ConsEnot1', .f. ) )
    else
      cArqu := memoedit( memoread( cArqu2 ), 08, 06, 18, 72, .f., '', 100, , , 1, 0 )
    endif  
  else
    Alerta( mensagem( 'Alerta', 'ConsEnot', .f. ) )
  endif  
  
  ferase( cArqu2 )
  
  if pOpenNEnt
    select NEntARQ
    close
  endif
  if pOpenINEn  
    select INEnARQ
    close
  endif
  if pOpenCond  
    select CondARQ
    close
  endif  
  if pOpenProd  
    select ProdARQ
    close
  endif  
  
  select FornARQ
  set order to 2
  dbseek( pNome, .f. )
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

//
// Relatório das Notas de Entrada
//
function PrinENot ( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "FornARQ", .t. )
      VerifIND( "FornARQ" )
  
      #ifdef DBF_NTX
        set index to FornIND1, FornIND2
      #endif  
    endif

    if NetUse( "ProdARQ", .t. )
      VerifIND( "ProdARQ" )
    
      #ifdef DBF_NTX
        set index to ProdIND1, ProdIND2
      #endif  
    endif

    if NetUse( "NEntARQ", .t. )
      VerifIND( "NEntARQ" )
  
      #ifdef DBF_NTX
        set index to NEntIND1
      #endif  
    endif

    if NetUse( "INEnARQ", .t. )
      VerifIND( "INEnARQ" )
 
      #ifdef DBF_NTX
        set index to INEnIND1
      #endif  
    endif
  endif  
  
  if NetUse( "GrupARQ", .t. )
    VerifIND( "GrupARQ" )
  
    #ifdef DBF_NTX
      set index to GrupIND1, GrupIND2
    #endif  
  endif

  if NetUse( "CondARQ", .t. )
    VerifIND( "CondARQ" )
  
    #ifdef DBF_NTX
      set index to CondIND1, CondIND2
    #endif  
  endif

  if NetUse( "SubGARQ", .t. )
    VerifIND( "SubGARQ" )
  
    #ifdef DBF_NTX
      set index to SubGIND1, SubGIND2
    #endif  
  endif

  if NetUse( "CampARQ", .t. )
    VerifIND( "CampARQ" )
  
    #ifdef DBF_NTX
      set index to CampIND1, CampIND2
    #endif  
  endif

  if NetUse( "EtiqARQ", .t. )
    VerifIND( "EtiqARQ" )
  
    #ifdef DBF_NTX
      set index to EtiqIND1
    #endif  
  endif

  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 06, 08, 17, 74, mensagem( 'Janela', 'PrinEnot', .f. ), .f. )
 
  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,10 say '      Nota Inicial                Nota Final'         
  @ 09,10 say 'Fornecedor Inicial          Fornecedor Final'         
  @ 10,10 say '   Produto Inicial             Produto Final'         
  @ 11,10 say '     Grupo Inicial               Grupo Final'         
  @ 12,10 say '  SubGrupo Inicial            SubGrupo Final'         
  @ 13,10 say '   Emissão Inicial             Emissão Final'
  @ 15,10 say '      Discriminado'
  @ 16,10 say '         Etiquetas'

  setcolor( CorCampo )
  @ 15,29 say ' Sim '
  @ 15,35 say ' Não '
  @ 16,29 say ' Sim '
  @ 16,35 say ' Não '
  
  setcolor( CorAltKC )
  @ 15,30 say 'S'
  @ 15,36 say 'N'
  @ 16,30 say 'S'
  @ 16,36 say 'N'
  
  select GrupARQ
  set order to 1
  dbgotop ()
  nGrupIni := val( Grup )
  dbgobottom ()
  nGrupFin := val( Grup )

  select ProdARQ
  set order to 1
  dbgotop ()
  nProdIni := val( Prod )
  dbgobottom ()
  nProdFin := val( Prod )

  select FornARQ
  set order to 1
  dbgotop ()
  nFornIni := val( Forn )
  dbgobottom ()
  nFornFin := val( Forn )

  select NEntARQ
  set order to 1
  dbgotop ()
  nNotaIni := 1
  nNotaFin := 9999999999
  nSubGIni := 1
  nSubGFin := 999999
  cProd    := space(04) 
  dEmisIni := ctod ('01/01/90')
  dEmisFin := date ()

  @ 08,29 get nNotaIni  pict '9999999999' 
  @ 08,55 get nNotaFin  pict '9999999999'        valid nNotaFin >= nNotaIni
  @ 09,29 get nFornIni  pict '999999'            valid ValidForn( 99, 99, "NEntARQ", "nFornIni" )       
  @ 09,55 get nFornFin  pict '999999'            valid ValidForn( 99, 99, "NEntARQ", "nFornFin" ) .and. nFornFin >= nFornIni
  @ 10,29 get nProdIni  pict '999999'            valid ValidProd( 99, 99, "NEntARQ", 'prin', 0, 0, 0, "nProdIni" ) 
  @ 10,55 get nProdFin  pict '999999'            valid ValidProd( 99, 99, "NEntARQ", 'prin', 0, 0, 0, "nProdFin" ) .and. nProdFin >= nProdIni
  @ 11,29 get nGrupIni  pict '999999'            valid ValidARQ( 99, 99, "NEntARQ", "Código" , "Grup", "Descrição", "Nome", "Grup", "nGrupIni", .t., 6, "Consulta de Grupos", "GrupARQ", 30 )
  @ 11,55 get nGrupFin  pict '999999'            valid ValidARQ( 99, 99, "NEntARQ", "Código" , "Grup", "Descrição", "Nome", "Grup", "nGrupFin", .t., 6, "Consulta de Grupos", "GrupARQ", 30 ) .and. nGrupFin >= nGrupIni
  @ 12,29 get nSubgIni  pict '999999' 
  @ 12,55 get nSubgFin  pict '999999'            valid nSubgFin >= nSubgIni
  @ 13,29 get dEmisIni  pict '99/99/9999' 
  @ 13,55 get dEmisFin  pict '99/99/9999'          valid dEmisFin >= dEmisIni
  read

  if lastkey() == K_ESC
    select CampARQ
    close
    select EtiqARQ
    close
    select GrupARQ
    close
    select SubGARQ
    close
    select CondARQ
    close
    select NEntARQ
    if lAbrir
      close
      select INEnARQ
      close
      select FornARQ
      close
      select ProdARQ
      close
    else
      set order to 1 
      dbgobottom ()
    endif
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  lDesc := ConfLine( 15, 29, 2 )

  if lastkey() == K_ESC
    select CampARQ
    close
    select EtiqARQ
    close
    select GrupARQ
    close
    select SubGARQ
    close
    select CondARQ
    close
    select NEntARQ
    if lAbrir
      close
      select INEnARQ
      close
      select FornARQ
      close
      select ProdARQ
      close
    else
      set order to 1 
      dbgobottom ()
    endif
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  lEtiq := ConfLine( 16, 29, 2 )

  if lastkey() == K_ESC
    select CampARQ
    close
    select EtiqARQ
    close
    select GrupARQ
    close
    select SubGARQ
    close
    select CondARQ
    close
    select NEntARQ
    if lAbrir
      close
      select INEnARQ
      close
      select FornARQ
      close
      select ProdARQ
      close
    else
      set order to 1 
      dbgobottom ()
    endif
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
 
  Aguarde()

  nPag   := 1
  nLin   := 0
  cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

  cNotaIni    := strzero( nNotaIni, 10 )
  cNotaFin    := strzero( nNotaFin, 10 )
  cFornIni    := strzero( nFornIni, 6 )
  cFornFin    := strzero( nFornFin, 6 )
  cProdIni    := strzero( nProdIni, 6 )
  cProdFin    := strzero( nProdFin, 6 )
  cGrupIni    := strzero( nGrupIni, 6 )
  cGrupFin    := strzero( nGrupFin, 6 )
  cSubGIni    := strzero( nSubGIni, 6 )
  cSubGFin    := strzero( nSubGFin, 6 )
  cFornAnt    := space(06)
  nTotalGeral := nTotalNota  := 0
  nTotalIPI   := nTotalICMS  := 0
  lInicio     := .t.
  
  if lEtiq 
    select EtiqARQ
    set order to 1
    dbseek( EmprARQ->EtiqProd, .f. )

    if found()
      if empty( Layout )
        lAchou := .f.
      else  
        lAchou := .t.
      endif  
    else
      lAchou := .f.
    endif
  
    if !lAchou
      Alerta( mensagem( 'Alerta', 'PrinEtiq', .f. ) )
      select CampARQ
      close
      select EtiqARQ
      close
      select GrupARQ
      close
      select SubGARQ
      close
      select NEntARQ
      if lAbrir
        close
        select INEnARQ
        close
        select FornARQ
        close
        select ProdARQ
        close
      else
        set order to 1 
        dbgobottom ()
      endif
      restscreen( 00, 00, 23, 79, tPrt )
      return NIL
    endif
  
    cTexto     := Layout
    nLin       := 1
    nLargura   := Tama
    nEspa      := Espa
    nComp      := Comp
    cQtLin     := QtLinha
    nColunas   := Colunas
    nDistancia := Distancia
    nSalto     := Salto
    aLayout    := {}
    aProdutos  := {}
    cQtLin     := mlcount( cTexto, nLargura + 1 )
 
    for nK := 1 to cQtLin
      cLinha := memoline( cTexto, nLargura + 1, nK )

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
            aadd( aLayout, { nLin, nCol, Tipo, alltrim( Campo ), Mascara, Tamanho, Arquivo  } ) 
          endif

          cPalavra := ''
          nCol     := 0
        endif  
      next
      nLin ++
    next

    select NEntARQ
    set order to 1
    dbgotop()
    do while !eof()                 
      if Nota >= cNotaIni .and. Nota <= cNotaFin .and.;
         Forn >= cFornIni .and. Forn <= cFornFin .and.;
         Emis >= dEmisIni .and. Emis <= dEmisFin
         
        select INEnARQ
        set order    to 1
        set relation to Prod into ProdARQ
        dbseek( NEntARQ->Forn + NEntARQ->Nota, .t. )
        do while Forn == NEntARQ->Forn .and. Nota == NEntARQ->Nota .and. !eof()
          if Prod          >= cProdIni .and. Prod          <= cProdFin .and.;
             ProdARQ->Grup >= cGrupIni .and. ProdARQ->Grup <= cGrupFin .and.;
             ProdARQ->SubG >= cSubGIni .and. ProdARQ->SubG <= cSubGFin
             
            nElem := ascan( aProdutos, { |nElem| nElem[1] == Prod } )
            
            if nElem > 0
              aProdutos[ nElem, 2 ] += Qtde
            else
              aadd( aProdutos, { Prod, Qtde } ) 
            endif  
          endif  
          dbskip ()
        enddo
        select NEntARQ
      endif  
      dbskip ()
    enddo
    
    if !TestPrint( EmprARQ->Produto )
      select CampARQ
      close
      select EtiqARQ
      close
      select GrupARQ
      close
      select SubGARQ
      close
      select NEntARQ
      if lAbrir
        close
        select INEnARQ
        close
        select FornARQ
        close
        select ProdARQ
        close
      else
        set order to 1 
        dbgobottom ()
      endif
      restscreen( 00, 00, 23, 79, tPrt )
      return NIL
    endif
  
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
  
    nLinIni  := aLayout[ 1, 1 ]
    nLinFin  := aLayout[ len( aLayout ), 1 ]
    xLin     := 0
    nCopia   := 0
    nTotProd := len( aProdutos )
    nF       := 1
    
    select ProdARQ
    set order to 1
    
    do while nF <= nTotProd
      dbseek( aProdutos[ nF, 1 ], .f. )
      
      for nH := 1 to nColunas
        s       := strzero( nH, 2 )
        aEtiq&s := {}
      next
    
      if nCopia == 0   
        nCopia := aProdutos[ nF, 2 ]
      endif  
            
      for nJ := 1 to nColunas
        ueta := strzero( nJ, 2 )

        for nL := 1 to len( aLayout )
          nLin   := aLayout[ nL, 1 ] 
          nCol   := aLayout[ nL, 2 ] 
          cTipo  := aLayout[ nL, 3 ] 
          cCamp  := aLayout[ nL, 4 ] 
          cPict  := aLayout[ nL, 5 ] 
          nTama  := aLayout[ nL, 6 ] 
          cArqu  := aLayout[ nL, 7 ] 
        
          if empty( cArqu )
            cCampo := cCamp
          else  
            select( cArqu )
                          
            do case 
              case cTipo == 'N'
                if !empty( &cCamp )
                  cCampo := transform( &cCamp, cPict )
                else
                  cCampo := '' 
                endif  
              case cTipo == 'C'  
                cCampo := left( &cCamp, nTama )
              case cTipo == 'D' .or. cTipo == 'V'  
                cCampo := &cCamp
            endcase  
          endif  
           
          aadd( aEtiq&ueta, { nLin, nCol, cCampo } )
        next

        if nCopia == 1  
          nF ++
          if nF > nTotProd
            dbseek( -123, .f. )
          else  
            dbseek( aProdutos[ nF, 1 ], .f. )
            
            nCopia := aProdutos[ nF, 2 ]
          endif  
        else  
          nCopia --
        endif 
        
        if eof()
          for nY := ( nJ + 1 ) to nColunas
            u       := strzero( nY, 2 )
            aEtiq&u := {}
          next  
          exit
        endif  
      next

      setprc( 0, 0 )
    
      xLin := ( nLinIni - 1 )
 
      for nLinha := nLinIni to nLinFin
        for nA := 1 to nColunas
          uetas := strzero( nA, 2 )
          for nB := 1 to len( aEtiq&uetas )
            nLin   := aEtiq&uetas[ nB, 1 ]
            nCol   := aEtiq&uetas[ nB, 2 ]
            cCampo := aEtiq&uetas[ nB, 3 ]
            
            if nA > 1
              nCol += ( ( ( nLargura + nDistancia ) * ( nA - 1 ) ) + 1 )
              
              if nA > 4
                nCol ++
              endif  
            endif

            if nLin == nLinha 
              @ xLin, nCol say alltrim( cCampo )
            endif
          next   
        next  
        xLin ++
      next

      xLin += nSalto

      @ xLin,00 say chr(13)
    enddo

    @ nLin,00 say chr(27) + '@'
  else
    aCond := {}
  
    select NEntARQ
    set order    to 1
    set relation to Forn into FornARQ, to Cond into CondARQ
    dbgotop()
    do while !eof()                 
      if Nota >= cNotaIni .and. Nota <= cNotaFin .and.;
         Forn >= cFornIni .and. Forn <= cFornFin .and.;
         Emis >= dEmisIni .and. Emis <= dEmisFin
       
        if lInicio
          set printer to ( cArqu2 )
          set device  to printer
          set printer on
        
          lInicio := .f.
        endif  
      
        if nLin == 0
          Cabecalho ( 'Notas de Entrada', 132, 1 )
          CabNEnt ()
        endif
     
        if Forn != cFornAnt
          if !lDesc
            nLin ++
          endif  
          if cFornAnt != space(06)
            if !lDesc
              @ nLin,099 say 'Total Geral' 
              @ nLin,111 say nTotalGeral             pict '@E 999,999.99'
              nTotalGeral := 0
            else  
              @ nLin,079 say 'Total Geral'
              @ nLin,091 say nTotalGeral             pict '@E 999,999.99'
              nTotalGeral := 0
            endif
            nLin += 2 
          endif

          @ nLin,000 say Forn                        pict '999999' 
          @ nLin,007 say FornARQ->Nome
          cFornAnt := Forn
          nLin ++
        endif  
    
        if lDesc
          @ nLin,005 say Nota                         
          @ nLin,016 say Entr                          pict '99/99/9999'
        endif  

        nValorTotal := nTotalNota := 0
        cNota       := Nota
        cForn       := Forn
 
        select INEnARQ
        set order    to 1
        set relation to Prod into ProdARQ
        dbseek( cForn + cNota, .t. )
        do while Forn == cForn .and. Nota == cNota
          nValorTotal := Qtde * PrecoCusto
          nTotalNota  += nValorTotal
          nTotalGeral += nValorTotal
          nValorIPI   := ( nValorTotal * IPI ) / 100
          nValorICMS  := ( nValorTotal * ICMS ) / 100
      
          nTotalIPI   += nValorIPI
          nTotalICMS  += nValorICMS
         
          if lDesc
            @ nLin,027 say val( Sequ )             pict '99'
            if Prod == '999999'
              @ nLin,030 say Produto               pict '@S26'
            else  
              @ nLin,030 say ProdARQ->Nome         pict '@S26'
            endif  
            @ nLin,057 say Prod
            if EmprARQ->Inteira == "X" 
              @ nLin,064 say Qtde                    pict '@E 999999999' 
            else
              @ nLin,064 say Qtde                    pict '@E 9999999.9' 
            endif
            @ nLin,074 say ProdARQ->Unid
            @ nLin,079 say PrecoCusto              pict PictPreco(10)
            @ nLin,091 say nValorTotal             pict '@E 999,999.99'
            @ nLin,102 say IPI                     pict '@E 99.9'      
            @ nLin,108 say nValorIPI               pict '@E 9,999.99'
            @ nLin,117 say ICMS                    pict '@E 99.9'      
            @ nLin,124 say nValorICMS              pict '@E 9,999.99'
            nLin ++
          endif  

          if nLin >= pLimite
            Rodape(132) 

            cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
            cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

            set printer to ( cArqu2 )
            set printer on
         
            select NEntARQ
            
            Cabecalho ( 'Notas de Entrada', 132, 1 )
            CabNEnt   ()
            
            @ nLin,000 say Forn                        pict '999999' 
            @ nLin,007 say FornARQ->Nome
            nLin ++
            @ nLin,005 say Nota
            @ nLin,016 say Entr                        pict '99/99/9999'
            select INEnARQ
          endif
      
          dbskip ()
        enddo  
      
        select NEntARQ
      
        if lDesc  
          @ nLin,080 say 'Total Nota'
          @ nLin,091 say nTotalNota              pict '@E 999,999.99'
          @ nLin,108 say nTotalIPI               pict '@E 9,999.99'
          @ nLin,124 say nTotalICMS              pict '@E 9,999.99'
          nLin += 2
        else  
          @ nLin,005 say Nota
          @ nLin,018 say Emis                    pict '99/99/9999'
          @ nLin,029 say Entr                    pict '99/99/9999'
          @ nLin,040 say Obse                    pict '@S30'
          @ nLin,071 say Desconto                pict '@E 999,999.99'
          @ nLin,081 say nTotalICMS              pict '@E 99,999.99'
          @ nLin,091 say Frete                   pict '@E 99,999.99'
          @ nLin,101 say nTotalIPI               pict '@E 99,999.99'
          @ nLin,111 say TotalNota               pict '@E 999,999.99'
          nLin ++
        endif  
        
        nElem := ascan( aCond, { |nElem| nElem[1] == NENtARQ->Cond } )
      
        if nElem > 0
          aCond[ nElem, 4 ] += nTotalNota
        else
          aadd( aCond, { Cond, CondARQ->Nome, CondARQ->Vct1 +;
                                              CondARQ->Vct2 +;
                                              CondARQ->Vct3 +;
                                              CondARQ->Vct4, nTotalNota } )  
        endif  
 
        nTotalNota := 0
        nTotalIPI  := nTotalICMS := 0
    
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
  
  if nTotalGeral > 0
    nLin ++
    if !lDesc
      @ nLin,099 say 'Total Geral' 
      @ nLin,111 say nTotalGeral             pict '@E 999,999.99'
      nTotalGeral := 0
    else  
      @ nLin,079 say 'Total Geral'
      @ nLin,091 say nTotalGeral             pict '@E 999,999.99'
      nTotalGeral := 0
    endif
  endif
  
  if !lInicio
    Rodape(132)

    cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
    cArqu2 := cArqu2 + "." + strzero( nPag, 3 )
    
    set printer to ( cArqu2 )
    set device  to printer
    set printer on
  
    Cabecalho( 'Notas de Entrada - Demonstrativo', 132, 1 )
    
    nTotalCond  := nTotalVista  := nPercVista  := 0
    nTotalPrazo := nPercPrazo   := 0
  
    select CondARQ    
    set order to 1
    nLin += 3
    @ nLin,01 say '        Demonstrativo por Modalidade de Pagamento'
    nLin ++
    @ nLin,01 say '-------------------------------------------------------'
    nLin ++
     
    for nI := 1 to len( aCond )
      nTotalCond += aCond[ nI, 4 ]
    next
      
    for nI := 1 to len( aCond )
      cCond  := aCond[ nI, 1 ]
      cNome  := aCond[ nI, 2 ]
      nVcts  := aCond[ nI, 3 ]
      nTotal := aCond[ nI, 4 ]
      
      if nTotal == 0
        loop
      endif 
      
      if nTotalCond == 0
        nPerc := 0 
      else
        nPerc := ( nTotal * 100 ) / nTotalCond
      endif   
      
      if nVcts == 0
        nTotalVista += nTotal
        nPercVista  += nPerc
      else
        nTotalPrazo += nTotal
        nPercPrazo  += nPerc
      endif  
        
      @ nLin,01 say cCond              pict '999999'
      @ nLin,08 say cNome              pict '@S20'
      @ nLin,37 say nTotal             pict '@E 999,999.99'
      @ nLin,48 say nPerc              pict '@E 999.99'
      @ nLin,55 say '%'
      nLin ++
    next  
   
    @ nLin,01 say '-------------------------------------------------------'
    nLin ++
    @ nLin,11 say 'Total a Vista'
    @ nLin,37 say nTotalVista        pict '@E 999,999.99'
    @ nLin,48 say nPercVista         pict '@E 999.99'
    @ nLin,55 say '%'
    nLin ++
    @ nLin,11 say 'Total a Prazo'
    @ nLin,37 say nTotalPrazo        pict '@E 999,999.99'
    @ nLin,48 say nPercPrazo         pict '@E 999.99'
    @ nLin,55 say '%'
    Rodape(132)
  endif  
  
  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 132 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Relatório de Notas de Entrada"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 132
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
    close
  endif

  select CampARQ
  close
  select EtiqARQ
  close
  select GrupARQ
  close
  select SubGARQ
  close
  select CondARQ
  close
  select NEntARQ
  if lAbrir
    close
    select INEnARQ
    close
    select FornARQ
    close
    select ProdARQ
    close
  else
    set order  to 1 
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabNEnt ()
  @ 02,01 say 'Fornecedor'
  if lDesc
    @ 03,01 say '    Nota       Entrada   Seq.Prod                                  Qtde. Un. Preco Custo Valor Total  IPI Valor IPI ICMS Valor ICMS'  
    nLin := 5  
  else  
    @ 03,01 say '    Nota         Emissão    Entrada    Observação                      Desconto      ICMS     Frete       IPI Total Nota'
    nLin := 4  
  endif
  
  cFornAnt := space(06)
return NIL