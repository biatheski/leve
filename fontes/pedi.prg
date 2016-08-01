//  Leve, Nota Fiscal
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

function Pedi ()

if NetUse( "ClieARQ", .t. )
  VerifIND( "ClieARQ" )

  rOpenClie := .t.

  #ifdef DBF_NTX
    set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
  #endif
else
  rOpenClie := .f.
endif

if NetUse( "NatuARQ", .t. )
  VerifIND( "NatuARQ" )

  rOpenNatu := .t.
  
  #ifdef DBF_NTX
    set index to NatuIND1, NatuIND2
  #endif
else
  rOpenNatu := .f.  
endif

if NetUse( "PortARQ", .t. )
  VerifIND( "PortARQ" )
    
  rOpenPort := .t.
  
  #ifdef DBF_NTX
    set index to PortIND1, PortIND2
  #endif
else
  rOpenPort := .f.  
endif

if NetUse( "TranARQ", .t. )
  VerifIND( "TranARQ" )
  
  rOpenTran := .t.
  
  #ifdef DBF_NTX
    set index to TranIND1, TranIND2
  #endif
else
  rOpenTran := .f.  
endif

if NetUse( "ProdARQ", .t. )
  VerifIND( "ProdARQ" )
  
  rOpenProd := .t.
  
  #ifdef DBF_NTX
    set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
  #endif
else
  rOpenProd := .f.  
endif

if NetUse( "PediARQ", .t. )
  VerifIND( "PediARQ" )
  
  rOpenPedi := .t.
  
  #ifdef DBF_NTX
    set index to PediIND1, PediIND2, PediIND3, PediIND4, PediIND5
  #endif
else
  rOpenPedi := .f.  
endif

if NetUse( "IPedARQ", .t. )
  VerifIND( "IPedARQ" )
  
  rOpenIPed := .t.
  
  #ifdef DBF_NTX
    set index to IPedIND1
  #endif
else
  rOpenIPed := .f.  
endif

if NetUse( "IProARQ", .t. )
  VerifIND( "IProARQ" )
  
  rOpenIPro := .t.
  
  #ifdef DBF_NTX
    set index to IProIND1
  #endif
else
  rOpenIPro := .f.  
endif

if NetUse( "CondARQ", .t. )
  VerifIND( "CondARQ" )
  
  rOpenCond := .t.
  
  #ifdef DBF_NTX
    set index to CondIND1, CondIND2
  #endif
else
  rOpenCond := .f.  
endif

if NetUse( "ReceARQ", .t. )
  VerifIND( "ReceARQ" )
  
  rOpenRece := .t.
  
  #ifdef DBF_NTX
    set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
  #endif
else
  rOpenRece := .f.  
endif

if NetUse( "ReprARQ", .t. )
  VerifIND( "ReprARQ" )
  
  rOpenRepr := .t.
  
  #ifdef DBF_NTX
    set index to ReprIND1, ReprIND2
  #endif
else
  rOpenRepr := .f.  
endif

if NetUse( "NFisARQ", .t. )
  VerifIND( "NFisARQ" )
  
  rOpenNFis := .t.
  
  #ifdef DBF_NTX
    set index to NFisIND1
  #endif
else
  rOpenNFis := .f.  
endif

if NetUse( "NSaiARQ", .t. )
  VerifIND( "NSaiARQ" )
  
  rOpenNSai := .t.
  
  #ifdef DBF_NTX
    set index to NSaiIND1, NSaiIND2, NSaiIND3, NSaiIND4
  #endif
else
  rOpenNSai := .f.  
endif

if NetUse( "INSaARQ", .t. )
  VerifIND( "INSaARQ" )
  
  rOpenINSa := .t.
  
  #ifdef DBF_NTX
    set index to INSaIND1
  #endif
else
  rOpenINSa := .f.  
endif

if NetUse( "EstaARQ", .t. )
  VerifIND( "EstaARQ" )
  
  rOpenEsta := .t.
  
  #ifdef DBF_NTX
    set index to EstaIND1
  #endif
else
  rOpenEsta := .f.  
endif

aOpcoes  := {}
aArqui   := {}
cPediARQ := CriaTemp(0)
PediIND1 := CriaTemp(1)
cChave   := "Sequ"

aadd( aArqui, { "Sequ",       "C", 004, 0 } )
aadd( aArqui, { "Prod",       "C", 006, 0 } )
aadd( aArqui, { "Produto",    "M", 010, 0 } )
aadd( aArqui, { "Qtde",       "N", 012, 3 } )
aadd( aArqui, { "Comi",       "N", 007, 2 } )
aadd( aArqui, { "Desc",       "N", 007, 2 } )
aadd( aArqui, { "PrecoVenda", "N", 015, 6 } )
aadd( aArqui, { "PrecoCusto", "N", 015, 6 } )
aadd( aArqui, { "Unidade",    "C", 003, 0 } )
aadd( aArqui, { "NSerie",     "C", 030, 0 } )
aadd( aArqui, { "Valida",     "C", 030, 0 } )
aadd( aArqui, { "Regi",       "N", 008, 0 } )
aadd( aArqui, { "Estq",       "L", 001, 0 } )
aadd( aArqui, { "Novo",       "L", 001, 0 } )
aadd( aArqui, { "Lixo",       "L", 001, 0 } )

dbcreate( cPediARQ, aArqui )
   
if NetUse( cPediARQ, .f. )
  cPediTMP := alias ()
  
  #ifdef DBF_CDX  
    index on &cChave tag &PediIND1
  #endif

  #ifdef DBF_NTX
    index on &cChave to &PediIND1
    
    set index to &PediIND1
  #endif
endif

if empty( EmprARQ->Desconto )
  lDescVenda := .f.
else  
  lDescVenda := .t.
endif  

//  Variaveis para Entrada de dados
nClie      := nTran       := nNota      := 0
nCond      := nProd       := nQtde      := nValorIPI  := 0
nPort      := nBaseICMS   := nValorICMS := nDesc      := 0
cCond      := cPlacaUF    := space(02)
cClie      := cTran       := cNatu      := cProd      := space(4)
cStat      := cRepr       := cUnidade   := space(4)
cEspecie   := cMarca      := cNumero    := cPlaca     := space(10)
cNota      := cHora       := space(6)
dEmis      := dSaid       := date()
nRepr      := nOutraDesp  := nBaICMSub   := nVaICMSub   := 0
nAliq      := nFrete      := nPrecoCusto := nPrecoVenda := 0
nParcAll   := 1
nTotalNota := nPrecoTotal := nSeguro     := nDesconto   := 0
nQtdade    := nComi       := 0
cStatAux   := cPort       := space(4)
cConta     := cSituacao   := space(1)
cObse      := ''
cCliente   := cProduto    := cValida     := cNSerie     := space(40)
cFaturas   := "X"

dVcto1     := dVcto2  := dVcto3    := dVcto4     := dVcto5  := ctod ('  /  /  ')
dVcto6     := dVcto7  := dVcto8    := dVcto9     := ctod ('  /  /  ')
nValor1    := nValor2 := nValor3   := nValor4    := nValor5 := 0
nValor6    := nValor7 := nValor8   := nValor9    := 0
nComis1    := nComis2 := nComis3   := nComis4    := nComis5 := 0
nComis6    := nComis7 := nComis8   := nComis9    := 0
nPesoBruto := nComissao := nValorMerc := 0
cPedido    := space(30)
 
Janela ( 01, 02, 21, 76, mensagem( 'Janela', 'Pedi', .f. ), .t. )
setcolor ( CorJanel + ',' + CorCampo )

@ 03,06 say ' Nota Fiscal'
@ 03,31 say 'Pedido'
@ 03,49 say '   Situação' 

@ 05,11 say 'Cliente'
@ 06,06 say 'Data Emissão'           
@ 06,50 say 'Data Saída'

@ 08,05 say '  Cond. Pgto.' 
@ 09,05 say '     Vendedor'
@ 09,50 say '  Comissão'

@ 11,03 say 'Código Descrição              Qtde.     Desc. Comis. P. Venda   P. Total'
@ 12,02 say chr(195) + replicate( chr(196), 73 ) + chr(180)
@ 12,09 say chr(194)
@ 12,32 say chr(194)
@ 12,42 say chr(194)
@ 12,48 say chr(194)
@ 12,55 say chr(194)
@ 12,66 say chr(194)

for nY := 13 to 16
  @ nY,09 say chr(179)
  @ nY,32 say chr(179)
  @ nY,42 say chr(179)
  @ nY,48 say chr(179)
  @ nY,55 say chr(179)
  @ nY,66 say chr(179)
next  
  
@ 17,02 say chr(195) + replicate( chr(196), 73 ) + chr(180)
@ 17,09 say chr(193)
@ 17,32 say chr(193)
@ 17,42 say chr(193)
@ 17,48 say chr(193)
@ 17,55 say chr(193)
@ 17,66 say chr(193)
@ 18,04 say 'Desconto'
@ 18,26 say 'Valor Merc.'
@ 18,50 say 'Total Nota'

// Variaveis
setcolor( CorCampo )
@ 18,13 say nDesconto              pict '@E 999,999.99'
@ 18,38 say nValorMerc             pict '@E 999,999.99'
@ 18,61 say nTotalNota             pict '@E 999,999,999.99'

MostOpcao( 20, 04, 16, 52, 65 ) 
tSnot := savescreen( 00, 00, 24, 79 )

select NFisARQ
set order to 1
dbseek( EmprARQ->NFis, .f. )
  
select PediARQ
set order to 1
dbgobottom ()

do while .t.
  select( cPediTMP )
  zap

  select ClieARQ
  set order to 1
  
  select NatuARQ
  set order to 1
  
  select CondARQ
  set order to 1
  
  select TranARQ
  set order to 1
  
  select PortARQ
  set order to 1
  
  select ReprARQ
  set order to 1
  
  select ProdARQ
  set order    to 1
  
  select IPedARQ
  set order    to 1
  set relation to Prod into ProdARQ

  select PediARQ
  set order    to 1
  set relation to Clie into ClieARQ, to Natu into NatuARQ,;
               to Cond into CondARQ, to Tran into TranARQ,;
               to Repr into ReprARQ, to Port into PortARQ

  cStat := cStatAux := space(04)

  restscreen( 00, 00, 23, 79, tSnot )

  Mensagem( 'Pedi','Janela')
  
  MostPedi ()
  
  if Demo ()
    exit
  endif  
  
  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostPedi'
  cAjuda   := 'Pedi'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()

  @ 03,19 get nNota            pict '999999'
  read
  
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. nNota == 0
    exit
  endif

  cNota := strzero( nNota, 6 )

  //  Verificar existencia das Pedidos para Incluir ou Alterar
  select PediARQ
  set order to 1
  dbseek( cNota, .f. )
  if eof()
    cStat    := 'incl'
    cFaturas := "X"
  else
    cStat    := 'alte'
    cFaturas := "X"
  endif

  Mensagem( 'Pedi',cStat )
 
  select IPedARQ
  set order to 1
  dbseek( cNota, .t. )
  do while Nota == cNota
    nRegi := recno ()
    
    select( cPediTMP )
    if AdiReg()
      if RegLock()
        replace Sequ       with IPedARQ->Sequ
        replace Prod       with IPedARQ->Prod
        replace Produto    with IPedARQ->Produto
        replace Qtde       with IPedARQ->Qtde
        replace PrecoVenda with IPedARQ->PrecoVenda
        replace PrecoCusto with IPedARQ->PrecoCusto
        replace Unidade    with IPedARQ->Unidade     
        replace Comi       with IPedARQ->Comi
        replace Desc       with IPedARQ->Desc
        replace NSerie     with IPedARQ->NSerie
        replace Valida     with IPedARQ->Valida
        replace Regi       with nRegi
        replace Novo       with .f.
        replace Lixo       with .f.
        dbunlock ()
      endif
    endif
    
    select IPedARQ
    dbskip ()
  enddo
  
  select PediARQ
  
  cStatAux := cStat

  MostPedi ()
  EntrPedi ()  
  
  tVolta := savescreen( 00, 00, 15, 79 )
  
  EntrItNo ()
  EntrAdic ()
  EntrVctS ()
  
  Confirmar( 20, 04, 16, 52, 65, 3 ) 
  
  select PediARQ
  set order to 1
  
  if cStat == 'excl'
    EstoPedi()
  endif
  
  if cStat == 'loop' .or. lastkey() == K_ESC
    loop
  endif
  
  if cStatAux == 'incl'
    if AdiReg()
      if RegLock()
        replace Nota      with cNota
        dbunlock ()
      endif
    endif
  endif  

  if cStatAux == 'incl' .or. cStatAux == 'alte'
    if RegLock()
      replace Clie        with cClie
      replace Hora        with cHora
      replace Cliente     with cCliente
      replace Tran        with cTran
      replace Port        with cPort
      replace Placa       with cPlaca
      replace PlacaUF     with cPlacaUF
      replace Repr        with cRepr
      replace Said        with dSaid
      replace Emis        with dEmis
      replace Natu        with cNatu
      replace Obse        with cObse
      replace Pedido      with cPedido
      replace Situacao    with cSituacao
      replace BaseICMS    with nBaseICMS
      replace ValorICMS   with nValorICMS
      replace ValorIPI    with nValorIPI
      replace BaICMSub    with nBaICMSub
      replace VaICMSub    with nVaICMSub  
      replace OutraDesp   with nOutraDesp
      replace Frete       with nFrete
      replace Seguro      with nSeguro
      replace Qtdade      with nQtdade
      replace Especie     with cEspecie
      replace Marca       with cMarca
      replace Numero      with cNumero
      replace Conta       with cConta
      replace Desconto    with nDesconto
      replace ValorMerc   with nValorMerc
      replace TotalNota   with nTotalNota
      replace PesoBruto   with nPesoBruto
      replace Aliq        with nAliq
      replace Cond        with cCond
      replace Vcto1       with dVcto1
      replace Valor1      with nValor1
      replace Comis1      with nComis1
      replace Vcto2       with dVcto2
      replace Valor2      with nValor2
      replace Comis2      with nComis2
      replace Vcto3       with dVcto3
      replace Valor3      with nValor3
      replace Comis3      with nComis3
      replace Vcto4       with dVcto4
      replace Valor4      with nValor4
      replace Comis4      with nComis4
      replace Vcto5       with dVcto5
      replace Valor5      with nValor5
      replace Comis5      with nComis5
      replace Vcto6       with dVcto6
      replace Valor6      with nValor6
      replace Comis6      with nComis6
      replace Vcto7       with dVcto7
      replace Valor7      with nValor7
      replace Comis7      with nComis7
      replace Vcto8       with dVcto8
      replace Valor8      with nValor8
      replace Comis8      with nComis8
      replace Vcto9       with dVcto9
      replace Valor9      with nValor9
      replace Comis9      with nComis9
      dbunlock ()
    endif
    
    GravPedi ()
    
    select PediARQ
    if RegLock()
      replace Comissao    with nComissao
      dbunlock()    
    endif

    if cStat == 'prin' 
      ImprFisc (.t.)
    endif  
  endif

enddo

if rOpenClie
  select ClieARQ
  close
endif

if rOpenProd
  select ProdARQ
  close
endif

if rOpenPedi
  select PediARQ
  close
endif

if rOpenIPro
  select IProARQ
  close
endif

if rOpenIPed
  select IPedARQ
  close
endif

if rOpenCond
  select CondARQ
  close
endif  

if rOpenRece
  select ReceARQ
  close
endif

if rOpenRepr
  select ReprARQ
  close
endif  

if rOpenNatu
  select NatuARQ
  close
endif  

if rOpenPort
  select PortARQ
  close
endif  

if rOpenNFis
  select NFisARQ
  close
endif

if rOpenNSai
  select NSaiARQ
  close
endif

if rOpenINSa
  select INSaARQ
  close
endif

if rOpenEsta
  select EstaARQ
  close
endif

select( cPediTMP )
close
ferase( cPediARQ )
ferase( PediIND1 )
#ifdef DBF_CDX
  ferase( left( cPediARQ, len( cPediARQ ) - 3 ) + 'FPT' )
#endif  
#ifdef DBF_NTX
  ferase( left( cPediARQ, len( cPediARQ ) - 3 ) + 'DBT' )
#endif  

//
// Mostra os dados
//
function MostPedi()

  setcolor ( CorCampo )
  if cStat != 'incl'
    nNota := val ( Nota )
    cNota := Nota

    @ 03,19 say cNota
  endif 
  
  cClie      := Clie
  nClie      := val( Clie )
  cCliente   := Cliente
  cTran      := Tran
  nTran      := val( Tran )
  cHora      := Hora
  cPort      := Port
  nPort      := val( Port )
  cPlaca     := Placa
  cPlacaUF   := PlacaUF
  cRepr      := Repr
  nRepr      := val( Repr )
  dSaid      := Said
  dEmis      := Emis
  cNatu      := Natu
  cObse      := Obse
  cPedido    := Pedido
  cSituacao  := Situacao
  nBaseICMS  := BaseICMS
  nValorICMS := ValorICMS
  nValorIPI  := ValorIPI
  nBaICMSub  := BaICMSub
  nVaICMSub  := VaICMSub
  nOutraDesp := OutraDesp
  nFrete     := Frete
  nSeguro    := Seguro
  nQtdade    := Qtdade
  cEspecie   := Especie
  cMarca     := Marca
  cNumero    := Numero
  cConta     := Conta
  nComissao  := Comissao
  nDesconto  := Desconto
  nValorMerc := ValorMerc
  nTotalNota := TotalNota
  nPesoBruto := PesoBruto
  nAliq      := Aliq
  cCond      := Cond
  nCond      := val( Cond )
  dVcto1     := Vcto1
  nValor1    := Valor1
  nComis1    := Comis1
  dVcto2     := Vcto2
  nValor2    := Valor2
  nComis2    := Comis2
  dVcto3     := Vcto3
  nValor3    := Valor3
  nComis3    := Comis3
  dVcto4     := Vcto4
  nValor4    := Valor4
  nComis4    := Comis4
  dVcto5     := Vcto5
  nValor5    := Valor5
  nComis5    := Comis5
  dVcto6     := Vcto6
  nValor6    := Valor6
  nComis6    := Comis6
  dVcto7     := Vcto7
  nValor7    := Valor7
  nComis7    := Comis7
  dVcto8     := Vcto8
  nValor8    := Valor8
  nComis8    := Comis8
  dVcto9     := Vcto9 
  nValor9    := Valor9
  nComis9    := Comis9
  nLin       := 13
  
  do case
    case cSituacao == 'C'
      @ 03,61 say 'Cancelada'
    case cSituacao == 'N'
      @ 03,61 say 'Normal   '
    otherwise
      @ 03,61 say '         '

      if cStat == 'incl'
        cSituacao := 'N'
   
        @ 03,61 say 'Normal   '
      endif  
  endcase
    
  @ 03,38 say cPedido             pict '@S10'
  @ 05,19 say cClie
  if cClie == '999999'
    @ 05,26 say Cliente           pict '@S40'
  else  
    @ 05,26 say ClieARQ->Nome     pict '@S40'
  endif  
  @ 06,19 say dEmis               pict '99/99/9999'
  @ 06,30 say cHora               pict '99:99'
  @ 06,61 say dSaid               pict '99/99/9999'

  @ 08,19 say nCond               pict '999999'
  @ 08,26 say CondARQ->Nome       pict '@S30'
  @ 09,19 say nRepr               pict '999999'
  @ 09,26 say ReprARQ->Nome       pict '@S25'
  @ 09,61 say nComissao           pict '@E 999,999.99'

  if cStat == 'alte' .or. cStat == space(04)
    setcolor( CorJanel )
    for nG := 1 to 4  
      @ nLin, 03 say space(06)
      @ nLin, 10 say space(22)
      @ nLin, 33 say space(09)
      @ nLin, 43 say space(05)
      @ nLin, 49 say space(05)
      @ nLin, 56 say space(10)
      @ nLin, 67 say space(09)
      nLin ++
    next

    nLin := 13

    setcolor( CorJanel )
    select IPedARQ
    set order    to 1
    set relation to Prod into ProdARQ
    dbseek( cNota, .t. )
    do while Nota == cNota .and. !eof()
      @ nLin, 03 say Prod                  pict '999999'    
      if Prod == '999999'
        @ nLin, 10 say memoline( Produto, 22, 1 )
      else  
        @ nLin, 10 say ProdARQ->Nome       pict '@S22'
      endif  
      if EmprARQ->Inteira == "X"
        @ nLin, 33 say Qtde                pict '@E 999999999'
      else      
        @ nLin, 33 say Qtde                pict '@E 99999.999'
      endif
      @ nLin, 43 say Desc                  pict '@E 99.99'
      @ nLin, 49 say Comi                  pict '@E 99.99'
      @ nLin, 56 say PrecoVenda            pict PictPreco(10)
      @ nLin, 67 say Qtde * PrecoVenda     pict '@E 99,999.99'
      
      nLin ++

      if nLin >= 17
        exit
      endif   

      dbskip ()
    enddo
    select PediARQ
    setcolor( CorCampo )
  else
    setcolor( CorJanel )
    for nG := 1 to 4  
      @ nLin, 03 say space(06)
      @ nLin, 10 say space(22)
      @ nLin, 33 say space(09)
      @ nLin, 43 say space(05)
      @ nLin, 49 say space(05)
      @ nLin, 56 say space(10)
      @ nLin, 67 say space(09)
      nLin ++
    next  
    setcolor( CorCampo )
  endif  
  
  @ 18,13 say nDesconto              pict '@E 999,999.99'  
  @ 18,38 say nValorMerc             pict '@E 999,999.99'  
  @ 18,61 say nTotalNota             pict '@E 999,999,999.99'
  
  PosiDBF( 01, 76 )
return NIL

function VerSitu( pSituacao )
  setcolor( CorCampo )
  do case 
    case pSituacao == 'C' .or. pSituacao == 'c'
      lOk       := .t.
      cSituacao := 'C'
      
      @ 03,61 say 'Cancelada'
    case pSituacao == 'N' .or. pSituacao == 'n'
      lOk       := .t.
      cSituacao := 'N'
      
      @ 03,61 say 'Normal   '
    otherwise
      lOk       := .f.
      cSituacao := ' '
      
      @ 03,61 say '         '
      
      Alerta( mensagem( 'Alerta', 'VerSitu', .f. ) )
  endcase
  setcolor ( CorJanel + ',' + CorCampo )
return(lOk)

//
// Entra os dados
//
function EntrPedi ()
  local GetList := {}

  if cStat == 'incl'
    dSaid := date()
    dEmis := date()
    cHora := time()
  endif
  
  do while .t.
    lAlterou := .f.
  
    setcolor ( CorJanel + ',' + CorCampo )
    @ 03,38 get cPedido   pict '@S10'
    if cStat == 'alte'
      @ 03,61 get cSituacao pict '@!'     valid VerSitu( cSituacao )
    endif  
    @ 05,19 get nClie     pict '999999'   valid ValidClie( 05, 19, "PediARQ", , ,.t. )
    @ 06,19 get dEmis     pict '99/99/9999'
    @ 06,30 get cHora     pict '99:99'    valid ValidHora( cHora, "cHora" )
    @ 06,61 get dSaid     pict '99/99/9999'
    @ 08,19 get nCond     pict '999999'   valid ValidARQ( 08, 19, "PediARQ", "Código" , "Cond", "Descrição", "Nome", "Cond", "nCond", .t., 6, "Consulta de Condiç”es Pagamento", "CondARQ", 30 ) 
    @ 09,19 get nRepr     pict '999999'   valid ValidARQ( 09, 19, "PediARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nRepr", .t., 6, "Consulta de Vendedores", "ReprARQ", 25 )
    read

    if cPedido   != Pedido;      lAlterou := .t.
    elseif nClie != val( Clie ); lAlterou := .t.
    elseif dEmis != Emis;        lAlterou := .t.
    elseif cHora != Hora;        lAlterou := .t.
    elseif dSaid != Said;        lAlterou := .t.
    elseif nCond != val( Cond ); lAlterou := .t.
    elseif nRepr != val( Repr ); lAlterou := .t.
    endif
    
    if !Saindo(lAlterou)
      loop
    endif
    exit  
  enddo  
  
  cTran := strzero( nTran, 6 )
  cRepr := strzero( nRepr, 6 )
  cCond := strzero( nCond, 6 )
return NIL    


function PediICMS()
  if nAliq > 0 
    setcolor( CorCampo )
    nValorICMS := ( nBaseICMS * nAliq ) / 100 
  
    @ 07,57 say nValorICMS            pict '@E 999,999.99'
    setcolor ( CorJanel + ',' + CorCampo )
  endif
return(.t.)

//
// Entra com itens Adicionais
//
function EntrAdic ()
  local GetList := {}
  
  if lastkey() == K_ESC .or. lastkey() == K_PGDN
    return NIL
  endif

  if cStat == 'incl'
    Mensagem( 'Pedi',cStat )
  else
    Mensagem( 'Pedi',cStat )
  endif

  tAdic := savescreen( 00, 00, 23, 79 )
  Janela( 04, 06, 18, 68, mensagem( 'Janela', 'EntrAdic', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 06,09 say '    Aliquota ICMS'
  @ 07,09 say '        Base ICMS                    Valor ICMS '
  @ 08,09 say '  Base ICMS subs.              Valor ICMS subs. '
  @ 09,09 say '      Valor Frete                  Valor Seguro '
  @ 10,09 say 'Outras Desp. Asc.                     Valor IPI '
  
  @ 12,09 say '    Nat. Operação'
  @ 13,09 say '   Transportadora'
  @ 13,48 say 'Placa'
         
  @ 15,09 say '       Quantidade                       Especie '
  @ 16,09 say '            Marca                        Numero '
  @ 17,09 say '       Peso Bruto                  Peso Líquido '

  select PediARQ

  cUF := ClieARQ->UF
    
  select EstaARQ
  set order to 1
  dbseek( cUF, .f. )
  
  if cStat == 'incl'  
    nAliq := ICMS
  endif  
  
  nValorIPI  := nPesoLiqui := 0
  nTotalComi := nTotalPerc := 0
  
  select( cPediTMP )
  set order to 1
  dbgotop ()
  do while !eof ()
    nPesoLiqui += Qtde
    nTotalPerc += Comi
    nPrecoDesc := ( PrecoVenda * Qtde ) - ( ( PrecoVenda * Qtde ) * Desc ) / 100
    
    if Comi > 0
      nTotalComi += ( nPrecoDesc * Comi ) / 100
    endif  

    if !empty( ProdARQ->CodIPI )
      nValorIPI += ( ( PrecoVenda * Qtde ) * ProdARQ->PerIPI ) / 100
    endif  

    dbskip ()
  enddo
  
  nBaseICMS  := ( nValorMerc - nDesconto )
  nValorICMS := ( nBaseICMS * nAliq ) / 100 
  
  if nTotalPerc == 0
    nTotalComi := ( nBaseICMS * ReprARQ->PerC ) / 100
  endif    
  
  nComissao := nTotalComi
    
  select PediARQ
  
  setcolor( CorCampo )
  @ 07,27 say nBaseICMS             pict '@E 999,999.99'
  @ 07,57 say nValorICMS            pict '@E 999,999.99'
  @ 10,57 say nValorIPI             pict '@E 999,999.99'
  @ 12,27 say cNatu
  @ 12,35 say NatuARQ->Nome         pict '@S32'
  @ 13,27 say cTran
  @ 13,34 say TranARQ->Nome         pict '@S13'
  @ 13,54 say cPlaca 
  @ 13,65 say cPlacaUF
  @ 17,27 say nPesoBruto            pict '@E 9,999.9'
  @ 17,57 say nPesoLiqui            pict '@E 9,999.9'
  
  nFrete     := Frete
  nSeguro    := Seguro
  nQtdade    := Qtdade
  cEspecie   := Especie
  cMarca     := Marca
  cNumero    := Numero
  cConta     := Conta
  nOutraDesp := OutraDesp
  nBaICMSub  := BaICMSub
  nVaICMSub  := VaICMSub
  
  if cStat == 'alte'
    nTotalNota -= nFrete
    nTotalNota -= nValorIPI
    nTotalNota -= nVaICMSub
    nTotalNota -= nSeguro
    nTotalNota -= nOutraDesp
  endif
  
  do while .t.
    lAlterou := .f.
  
    setcolor ( CorJanel + ',' + CorCampo )
    @ 06,27 get nAliq             pict '@E 999.99'      valid PediICMS()
    @ 08,27 get nBaICMSub         pict '@E 999,999.99'
    @ 08,57 get nVaICMSub         pict '@E 999,999.99'
    @ 09,27 get nFrete            pict '@E 999,999.99'
    @ 09,38 get cConta            pict '@!'
    @ 09,57 get nSeguro           pict '@E 999,999.99'
    @ 10,27 get nOutraDesp        pict '@E 999,999.99'
    @ 10,57 get nValorIPI         pict '@E 999,999.99'
    @ 12,27 get cNatu                             valid ValidARQ( 12, 27, "PediARQ", "Código" , "Natu", "Descrição", "Nome", "Natu", "cNatu", .f., 7, "Consulta de Natureza de Operação", "NatuARQ", 32 )
    @ 13,27 get nTran             pict '999999'     valid ValidARQ( 13, 27, "PediARQ", "Código" , "Tran", "Descrição", "Nome", "Trns", "nTran", .t., 6, "Consulta de Transportadora", "TranARQ", 13 )
    @ 13,54 get cPlaca            pict '@!'                                             
    @ 13,65 get cPlacaUF
    @ 15,27 get nQtdade           pict '9999'
    @ 15,57 get cEspecie                      
    @ 16,27 get cMarca
    @ 16,57 get cNumero
    @ 17,27 get nPesoBruto        pict '@E 9,999.9'
    read

    if nBaICMSub      != BaICMSub;    lAlterou := .t.
    elseif nVaICMSub  != VaICMSub;    lAlterou := .t.
    elseif nFrete     != Frete;       lAlterou := .t.
    elseif cConta     != Conta;       lAlterou := .t.
    elseif nSeguro    != Seguro;      lAlterou := .t.
    elseif nOutraDesp != OutraDesp;   lAlterou := .t.
    elseif nValorIPI  != ValorIPI;    lAlterou := .t.
    elseif cNatu      != Natu;        lAlterou := .t.
    elseif nTran      != val( Tran ); lAlterou := .t.
    elseif cPlaca     != Placa;       lAlterou := .t.
    elseif cPlacaUF   != PlacaUF;     lAlterou := .t.
    elseif nQtdade    != Qtdade;      lAlterou := .t.
    elseif cEspecie   != Especie;     lAlterou := .t.
    elseif cMarca     != Marca;       lAlterou := .t.
    elseif cNumero    != Numero;      lAlterou := .t.
    elseif nPesoBruto != PesoBruto;   lAlterou := .t.
    endif
    
    if !Saindo(lAlterou)
      loop
    endif  
    exit
  enddo  
  
  nTotalNota += nFrete   
  nTotalNota += nValorIPI
  nTotalNota += nVaICMSub
  nTotalNota += nSeguro
  nTotalNota += nOutraDesp
  
  restscreen( 00, 00, 23, 79, tAdic )
return NIL

//
// Entra com os vencimentos
//
function EntrVctS ()
  local GetList := {}

  if lastkey() == K_ESC .or. lastkey() == K_PGDN
    return NIL
  endif

  tVctS    := savescreen( 00, 00, 23, 79 )

  if ( nTotalNota + ( nTotalNota * CondARQ->Acrs / 100 ) ) != PediARQ->TotalNota .or. val( PediARQ->Cond ) != nCond
    dVcto1  := dVcto2  := dVcto3  := dVcto4  := dVcto5  := ctod ('  /  /  ')
    dVcto6  := dVcto7  := dVcto8  := dVcto9  := ctod ('  /  /  ')
    nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := 0
    nValor6 := nValor7 := nValor8 := nValor9 := 0
    nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := 0
    nComis6 := nComis7 := nComis8 := nComis9 := 0
  
    nTotalPagar := nTotalNota + ( nTotalNota * CondARQ->Acrs / 100 ) 
    dData       := Emis
    dVcto1      := dEmis + CondARQ->Vct1
    nValor1     := nTotalPagar
    nComis1     := nComissao
    nParcAll    := 1

    if CondARQ->Vct2 != 0
      dVcto2  := dEmis + CondARQ->Vct2
      nValor1 := nValor2 := nTotalPagar / 2

      if CondARQ->Indi > 0
        nComis1 := nComis2 := nComissao * CondARQ->Indi
      else  
        nComis1 := nComis2 := nComissao / 2
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct3 != 0
      dVcto3  := dEmis + CondARQ->Vct3
      nComis1 := nComis2 := nComis3 := nComissao / 3

      if CondARQ->Indi > 0
        nValor1 := nValor2 := nValor3 := nTotalPagar * CondARQ->Indi
      else  
        nValor1 := nValor2 := nValor3 := nTotalPagar / 3
      endif      
      nParcAll ++
    endif

    if CondARQ->Vct4 != 0
      dVcto4  := dEmis + CondARQ->Vct4
      nComis1 := nComis2 := nComis3 := nComis4 := nComissao / 4

      if CondARQ->Indi > 0
        nValor1 := nValor2 := nValor3 := nValor4 := nTotalPagar * CondARQ->Indi
      else  
        nValor1 := nValor2 := nValor3 := nValor4 := nTotalPagar / 4
       endif  
      nParcAll ++
     endif

    if CondARQ->Vct5 != 0
      dVcto5  := dEmis + CondARQ->Vct5
      nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := nComissao / 5

      if CondARQ->Indi > 0
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nTotalPagar * CondARQ->Indi
      else  
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nTotalPagar / 5
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct6 != 0
      dVcto6  := dEmis + CondARQ->Vct6
      nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := nComis6 := nComissao / 6

      if CondARQ->Indi > 0
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nTotalPagar * CondARQ->Indi
      else  
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nTotalPagar / 6
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct7 != 0
      dVcto7  := dEmis + CondARQ->Vct7
      nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := nComis6 := nComis7 := nComissao / 7

      if CondARQ->Indi > 0
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nTotalPagar * CondARQ->Indi
      else  
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nTotalPagar / 7
      endif
      nParcAll ++
    endif

    if CondARQ->Vct8 != 0
      dVcto8  := dEmis + CondARQ->Vct8
      nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := nComis6 := nComis7 := nComis8 := nComissao / 8

      if CondARQ->Indi > 0
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nValor8 := nTotalPagar * CondARQ->Indi
      else  
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nValor8 := nTotalPagar / 8
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct9 != 0
      dVcto9  := dEmis + CondARQ->Vct9
      nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := nComis6 := nComis7 := nComis8 := nComis9 := nComissao / 9
      
      if CondARQ->Indi > 0
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nValor8 := nValor9 := nTotalPagar * CondARQ->Indi
      else  
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nValor8 := nValor9 := nTotalPagar / 9
      endif  
      nParcAll ++
    endif
  endif
  
  Janela ( 05, 09, 11 + nParcAll, 68, mensagem( 'Janela', 'EntrVctS', .f. ), .t. )
  if cStatAux == 'incl'
    Mensagem ( 'Pedi','InclVcto' )
  else  
    Mensagem ( 'Pedi', 'AlteVcto' )
  endif 

  setcolor ( CorJanel )
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
  @ 10 + nParcAll,55 say '[ ] Faturar'
  
  setcolor( CorCampo )
  @ 07,31 say dVcto1          pict '99/99/9999'
  @ 07,52 say nValor1         pict '@E 999,999,999.99'
  if nParcAll >= 2
    @ 08,31 say dVcto2          pict '99/99/9999'
    @ 08,52 say nValor2         pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 3
    @ 09,31 say dVcto3          pict '99/99/9999'
    @ 09,52 say nValor3         pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 4
    @ 10,31 say dVcto4          pict '99/99/9999'
    @ 10,52 say nValor4         pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 5
    @ 11,31 say dVcto5          pict '99/99/9999'
    @ 11,52 say nValor5         pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 6
    @ 12,31 say dVcto6          pict '99/99/9999'
    @ 12,52 say nValor6         pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 7
    @ 13,31 say dVcto7          pict '99/99/9999'
    @ 13,52 say nValor7         pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 8
    @ 14,31 say dVcto8          pict '99/99/9999'
    @ 14,52 say nValor8         pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 9
    @ 15,31 say dVcto9          pict '99/99/9999'
    @ 15,52 say nValor9         pict '@E 999,999,999.99'
  endif  
  @ 08 + nParcAll,31 say cPort           pict '999999'
  @ 08 + nParcAll,38 say PortARQ->Nome   pict '@S30'

  setcolor ( CorJanel + ',' + CorCampo )
  @ 07,31 get dVcto1      pict '99/99/9999'
  @ 07,52 get nValor1     pict '@E 999,999,999.99'  
  if nParcAll >= 2
    @ 08,31 get dVcto2    pict '99/99/9999'
    @ 08,52 get nValor2   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 3
    @ 09,31 get dVcto3    pict '99/99/9999'
    @ 09,52 get nValor3   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 4
    @ 10,31 get dVcto4    pict '99/99/9999'
    @ 10,52 get nValor4   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 5
    @ 11,31 get dVcto5    pict '99/99/9999'
    @ 11,52 get nValor5   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 6
    @ 12,31 get dVcto6    pict '99/99/9999'
    @ 12,52 get nValor6   pict '@E 999,999,999.99'  
  endif  
  if nParcAll >= 7
    @ 13,31 get dVcto7    pict '99/99/9999'
    @ 13,52 get nValor7   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 8
    @ 14,31 get dVcto8    pict '99/99/9999'
    @ 14,52 get nValor8   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 9
    @ 15,31 get dVcto9    pict '99/99/9999'
    @ 15,52 get nValor9   pict '@E 999,999,999.99'
  endif  

  @ 08+nParcAll,31 get nPort     pict '999999'     valid ValidARQ( 08+nParcAll, 31, "PediARQ", "Código" , "Port", "Descrição", "Nome", "Port", "nPort", .t., 6, "Portadores", "PortARQ", 30 )
  @ 10 + nParcAll,56 get cFaturas pict '@!'      valid cFaturas == "X" .or. empty( cFaturas )
  read
    
  cPort := strzero( nPort, 6 )

  restscreen( 00, 00, 23, 79, tVctS )
return NIL

//
// Entra com os itens 
//
function EntrItNo()
  if lastkey() == K_ESC .or. lastkey() == K_PGDN
    return NIL
  endif
  
  if !empty( cPedido ) .and. cStat == 'incl' 
    aPedidos := {}
    nNext    := 1
    
    for nL := 1 to len( cPedido )
      cKey := substr( cPedido, nL, 1 )

      if cKey == "/" .or. cKey == "-" .or. cKey == ","
        if nNext == 1
          cNots := substr( cPedido, 1, nL - nNext )
        else  
          cNots := substr( cPedido, nL + 1, nL - nNext )
        endif  
        nNext := nL + 1

        aadd( aPedidos, { cNots } )
      endif  
    next
    
    cNots := substr( cPedido, nNext )

    aadd( aPedidos, { cNots } )
    
    for n := 1 to len( aPedidos )
      @ n,10 say aPedidos[ n, 1 ]
      inkey(0)
    next
    
    nPedido := 1
  
    select NSaiARQ
    set order to 1
    dbseek( strzero( nPedido, 6 ), .f. )
    if found()
      nDesconto  := Desconto
      nValorMerc := SubTotal
      nComissao  := Comissao
      nTotalNota := SubTotal - Desconto
  
      select INSAARQ
      set order to 1
      dbseek( strzero( nPedido, 6 ), .t. )
      do while Nota == strzero( nPedido, 6 ) .and. !eof()
        select( cPediTMP )
        if AdiReg()
           if RegLock()
            replace Sequ       with INSaARQ->Sequ
            replace Prod       with INSaARQ->Prod
            replace Produto    with INSaARQ->Produto
            replace Qtde       with INSaARQ->Qtde
            replace PrecoVenda with INSaARQ->PrecoVenda
            replace PrecoCusto with INSaARQ->PrecoCusto
            replace Unidade    with INSaARQ->Unidade   
            replace Comi       with INSaARQ->Comi
            replace Desc       with INSaARQ->Desc
            replace Novo       with .t.
            replace Estq       with .t.
            replace Lixo       with .f.
            dbunlock ()
          endif  
        endif
      
        select INSAARQ
        dbskip()
      enddo
      
      setcolor( CorCampo )
      @ 18,13 say nDesconto        pict '@E 999,999.99'  
      @ 09,61 say nComissao        pict '@E 999,999.99'
      @ 18,38 say nValorMerc       pict '@E 999,999.99'
      @ 18,61 say nTotalNota       pict '@E 999,999,999.99'
    endif  
  endif

  setcolor ( CorJanel + ',' + CorCampo )
  
  select( cPediTMP )
  set order    to 1
  set relation to Prod into ProdARQ

  bFirst := {|| dbseek( '0001', .t. ) }
  bLast  := {|| dbseek( '9999', .t. ), dbskip(-1) }
  bFor   := {|| .t. }
  bWhile := {|| .t. }

  oPedido         := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oPedido:nTop    := 11
  oPedido:nLeft   := 3
  oPedido:nBottom := 17
  oPedido:nRight  := 75
  oPedido:headsep := chr(194)+chr(196)
  oPedido:colsep  := chr(179)
  oPedido:footsep := chr(193)+chr(196)

  oPedido:addColumn( TBColumnNew("Código",           {|| Prod } ) )
  oPedido:addColumn( TBColumnNew("Descrição", {|| iif( Prod == '999999', memoline( Produto, 22, 1 ), left( ProdARQ->Nome, 22 ) ) } ) )
  if EmprARQ->Inteira == "X"
    oPedido:addColumn( TBColumnNew("Qtde.",           {|| transform( Qtde, '@E 999999999' ) } ) )
  else  
    oPedido:addColumn( TBColumnNew("Qtde.",           {|| transform( Qtde, '@E 99999.999' ) } ) )
  endif  
  oPedido:addColumn( TBColumnNew("Desc.",           {|| transform( Desc, '@E 99.99' ) } ) )
  oPedido:addColumn( TBColumnNew("Comis.",          {|| transform( Comi, '@E 99.99' ) } ) )
  oPedido:addColumn( TBColumnNew("P. Venda",        {|| transform( PrecoVenda, PictPreco(10) ) } ) )
  oPedido:addColumn( TBColumnNew("P. Total",        {|| transform( ( PrecoVenda * Qtde ), '@E 99,999.99' ) } ) )
            
  oPedido:goBottom ()

  lExitRequested := .f.
  lAlterou       := .f.

  do while !lExitRequested
    Mensagem ( 'LEVE','Browse')
 
    oPedido:forcestable()
  
    if oPedido:hitTop .and. !empty( Prod ) 
      oPedido:refreshAll ()  
     
      select PediARQ
      
      EntrPedi ()  
    
      select( cPediTMP )
      
      oPedido:down()
      oPedido:forcestable()
      oPedido:refreshall()
      
      loop
    endif

    if ( !lAlterou .and. cStat == 'incl' ) .or. ( oPedido:hitBottom .and. lastkey() != K_ESC ) 
      cTecla := K_INS
    else
      cTecla := Teclar(0)  
    endif

    do case
      case cTecla == K_DOWN;        oPedido:down()
      case cTecla == K_UP;          oPedido:up()
      case cTecla == K_PGUP;        oPedido:pageUp()
      case cTecla == K_CTRL_PGUP;   oPedido:goTop()
      case cTecla == K_PGDN;        oPedido:pageDown()
      case cTecla == K_CTRL_PGDN;   oPedido:goBottom()
      case cTecla == K_ESC
        if Saindo (lAlterou)
          lExitRequested := .t.
        else  
          lExitRequested := .f.
        endif  
      case cTecla == K_ENTER;       EntrItPedi(.f.)
      case cTecla == K_INS
        do while lastkey() != K_ESC    
          EntrItPedi(.t.)
          
//          if nSequ > NFisARQ->Itens
//            lExitRequested := .t.
//            exit
//          endif  
        enddo  
        
        cTecla := ""
        
        oPedido:refreshAll ()  
      case cTecla == K_DEL
        setcolor( CorCampo )
        if RegLock()
          cProd       := Prod
          nQtde       := Qtde
          nPrecoVenda := PrecoVenda

          nTotalNota -= ( Qtde * PrecoVenda )
          nValorMerc -= ( Qtde * PrecoVenda )
          nComissao  -= ( ( ( Qtde * PrecoVenda ) * Comi ) / 100 )
          if !lDescVenda
            nDesconto  -= ( ( ( Qtde * PrecoVenda ) * Desc ) / 100 )
          endif  

          @ 18,13 say nDesconto      pict '@E 999,999.99'  
          @ 09,61 say nComissao      pict '@E 999,999.99'
          @ 18,38 say nValorMerc     pict '@E 999,999.99'
          @ 18,61 say nTotalNota     pict '@E 999,999,999.99'
          
          replace Lixo           with .t.

          dbdelete ()
          dbunlock ()
          
          oPedido:refreshCurrent()  
        endif  
      case cTecla == 46
        if cStat == 'incl'
          Mensagem( 'Pedi', cStat )
        else
          Mensagem( 'Pedi', cStat )
        endif

        if cStat == 'alte'
          if !lDescVenda
            nTotalNota += nDesconto
          endif  
        endif  
        
        @ 18,13 get nDesconto              pict '@E 999,999.99'  
        read
        
        if !lDescVenda
          nTotalNota -= nDesconto
        endif  

        lExitRequested := .t.
      case cTecla == K_ALT_O        
        tEntrObse := savescreen( 00, 00, 23, 79 )

        Janela( 03, 17, 09, 60, mensagem( 'Janela', 'Obse', .f. ), .f. )
        Mensagem( 'PedF','Obse')
         
        setcolor( CorCampo )     
        cObse := memoedit( cObse, 05, 19, 08, 58, .t., "OutProd" )
    
        restscreen( 00, 00, 23, 79, tEntrObse )
  
        setcolor ( CorJanel + ',' + CorCampo )
    endcase
  enddo
return NIL  

//
// Entra itens da Pedi
//
function EntrItPedi( lAdiciona )
  local GetList := {}

  if lAdiciona 
    dbgobottom()
    nSequ := val( Sequ )
  
    if AdiReg()
      if RegLock()
        replace Sequ            with strzero( nSequ, 4 )
        replace Novo            with .t.
        replace Lixo            with .f.
        dbunlock ()
      endif
    endif    
    
    dbgobottom ()

    oPedido:goBottom() 
    oPedido:down()
    oPedido:refreshAll()  

    oPedido:forcestable()
      
    Mensagem( 'PedF', 'InclIten' )
  else
    Mensagem( 'PedF', 'AlteIten' )
  endif  

  cProd       := Prod
  nProd       := val( cProd )
  cProduto    := Produto
  cUnidade    := Unidade
  cNSerie     := NSerie
  cValida     := Valida
  nQtde       := Qtde
  nComi       := Comi
  nDesc       := Desc
  nPrecoVenda := PrecoVenda
  nDescAnt    := Desc
  nComiAnt    := Comi
  nQtdeAnt    := Qtde
  nPrecoAnt   := PrecoVenda
  nLin        := 12 + oPedido:rowPos
  lAlterou    := .t.
  lIPro       := .f.
    
  setcolor( CorCampo )
  if cProd == '999999' 
    @ nLin, 10 say memoline( Produto, 22, 1 )
  else  
    @ nLin, 10 say ProdARQ->Nome       pict '@S22'
  endif  
  @ nLin, 67 say nQtde * PrecoVenda    pict '@E 99,999.99'

  set key K_UP to UpNota ()

  setcolor ( CorJanel + ',' + CorCampo )
  @ nLin, 03 get cProd            pict '@K'            valid ValidProd( nLin, 03, cPediTMP, 'pedi', 0, 0, nPrecoVenda )
  if EmprARQ->Inteira == "X" 
    @ nLin, 33 get nQtde          pict '@E 999999999'  valid ValidQtde( nQtde ) .and. ValidPedi()
  else  
    @ nLin, 33 get nQtde          pict '@E 99999.999'  valid ValidQtde( nQtde ) .and. ValidPedi()
  endif  
  @ nLin, 43 get nDesc            pict '@E 99.99'      valid DescDisc()
  @ nLin, 49 get nComi            pict '@E 99.99'
  @ nLin, 56 get nPrecoVenda      pict PictPreco(10)
  read

  set key K_UP to
  
  select( cPediTMP )

  if lastkey() == K_ESC
    if lAdiciona
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif  
    endif  
    
    oPedido:forcestable()
    oPedido:refreshall()  
    return NIL
  endif  
  
  if lIPro 
    select IProARQ
    set order to 1
    do while Prod == cProd .and. !eof()
      select( cPediTMP )
      if RegLock()
        replace Prod            with IProARQ->CodP
        replace Produto         with IProARQ->Produto
        replace Qtde            with IProARQ->Qtde * nQtde
        replace PrecoVenda      with IProARQ->PrecoVenda
        dbunlock ()
      endif

      nTotalNota += ( ( nQtde * IProARQ->Qtde ) * IProARQ->PrecoVenda )
      nValorMerc += ( ( nQtde * IProARQ->Qtde ) * IProARQ->PrecoVenda )
      
      select IProARQ
      dbskip()
      if Prod == cProd .and. !eof()
        select( cPediTMP )
        if AdiReg()
          if RegLock()
            replace Sequ            with strzero( recno(), 4 )
            replace Novo            with .t.
            replace Lixo            with .f.
            dbunlock ()
          endif
        endif    
        select IProARQ
      endif
    enddo
    select( cPediTMP )
  else
    if RegLock()
      replace Prod            with cProd
      replace Produto         with cProduto
      replace Qtde            with nQtde
      replace Desc            with nDesc
      replace Comi            with nComi
      replace PrecoVenda      with nPrecoVenda
      replace NSerie          with cNSerie
      replace Valida          with cValida
      dbunlock ()
    endif
  
    if !lAdiciona
      nTotalNota -= ( nQtdeAnt * nPrecoAnt )
      nValorMerc -= ( nQtdeAnt * nPrecoAnt )
      if lDescVenda
        nDesconto  -= ( ( ( nQtdeAnt * nPrecoAnt ) * nDescAnt ) / 100 )
      endif  

      if nComiAnt == 0
        nComissao -= ( ( ( nQtdeAnt * nPrecoAnt ) * ReprARQ->PerC ) / 100 )
      else
        nComissao -= ( ( ( nQtdeAnt * nPrecoAnt ) * nComiAnt ) / 100 )
      endif  

      nTotalNota += ( nQtde * nPrecoVenda )
      nValorMerc += ( nQtde * nPrecoVenda )
      if lDescVenda
        nDesconto  += ( ( ( nQtde * nPrecoVenda ) * nDesc ) / 100 )
      endif  

      if nComi == 0
        nComissao += ( ( ( nQtde * nPrecoVenda ) * ReprARQ->PerC ) / 100 )
      else  
        nComissao += ( ( ( nQtde * nPrecoVenda ) * nComi ) / 100 )
      endif  
    else 
      if nComi == 0
        nComissao += ( ( ( nQtde * nPrecoVenda ) * ReprARQ->PerC ) / 100 )
      else  
        nComissao += ( ( ( nQtde * nPrecoVenda ) * nComi ) / 100 )
      endif  
       
      if lDescVenda
        nDesconto  += ( ( ( nQtde * nPrecoVenda ) * nDesc ) / 100 )
      endif  
      nTotalNota += ( nQtde * nPrecoVenda )
      nValorMerc += ( nQtde * nPrecoVenda )
    endif
  endif  
  
  oPedido:refreshCurrent()  
  

  setcolor( CorCampo )
  @ 18,13 say nDesconto        pict '@E 999,999.99'  
  @ 09,61 say nComissao        pict '@E 999,999.99'
  @ 18,38 say nValorMerc       pict '@E 999,999.99'
  @ 18,61 say nTotalNota       pict '@E 999,999,999.99'
return NIL     


//
// Verifica Composicao
//
function ValidPedi ()
  local GetList := {}

  select IProARQ
  set order to 1 
  dbseek( cProd, .t. )
  if Prod == cProd .and. ProdARQ->Composicao == "X"
    lIPro := .t.
    
    keyboard(chr(13)+chr(13)+chr(13))
  else  
    lIPro := .f.
  endif
   
  if EmprARQ->NSerie == "X" 
    tSerie := savescreen( 00, 00, 23, 79 )

    Janela( 08, 19, 12, 61, mensagem( 'Janela', 'NSerie', .f. ), .f. )
    setcolor( CorJanel + ',' + CorCampo )
    @ 10,21 say 'N. Série'
    @ 11,21 say 'Validade'
    
    @ 10,30 get cNSerie      pict '@S30'
    @ 11,30 get cValida      pict '@S30'
    read
    
    restscreen( 00, 00, 23, 79, tSerie )
  endif
  
  select( cPediTMP )
return(.t.)

//
// Excluir Pedi
//
function EstoPedi ()
  cStat := 'loop' 
  lEstq := .f.

  select PediARQ

  if ExclEstq ()
    select IPedARQ
    dbseek( cNota + '01', .t. )
    do while Nota == cNota
      cProd := Prod
      nQtde := Qtde
      
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif
      
      if lEstq  
        select ProdARQ
        set order to 1
        dbseek( cProd, .f. )
        if RegLock() 
          replace Qtde        with Qtde + nQtde
          replace UltE        with date()
          dbunlock ()
        endif  
       
        select IPedARQ
      endif
        
      dbskip ()
    enddo    

    select ReceARQ
    set order to 1
    for nL := 1 to 9
      cParc  := str( nL, 1 )
      cParce := strzero( nL, 2 )
      
      dbseek( cNota + cParce + 'N', .f. )

      if found () 
        if RegLock()
          dbdelete ()
          dbunlock ()
        endif
      endif    
    next 

    select PediARQ
  endif
return NIL

//
// Saida do estoque
//
function GravPedi()

  set deleted off   
  
  nComissao := 0
    
  select( cPediTMP )
  set order to 1 
  dbgotop ()
  do while !eof ()
    if empty( Prod )
      dbskip ()
      loop
    endif  
     
    cProd    := Prod       
    cProduto := Produto
    nRegi    := Regi
    lLixo    := Lixo
      
    if Novo
      if Lixo
        dbskip ()
        loop
      endif  
    
      select IPedARQ
      if AdiReg()
        if RegLock()
          replace Nota       with cNota     
          replace Sequ       with &cPediTMP->Sequ
          replace Prod       with &cPediTMP->Prod
          replace Produto    with &cPediTMP->Produto
          replace Qtde       with &cPediTMP->Qtde
          replace Comi       with &cPediTMP->Comi
          replace Desc       with &cPediTMP->Desc
          replace PrecoVenda with &cPediTMP->PrecoVenda
          replace NSerie     with &cPediTMP->NSerie
          replace Valida     with &cPediTMP->Valida
          replace Unidade    with &cPediTMP->Unidade
          dbunlock ()
        endif

        nComissao  += ( ( ( Qtde * PrecoVenda ) * Comi ) / 100 )
      endif   
      
      if !&cPediTMP->Estq
        select ProdARQ
        set order to 1
        dbseek( cProd, .f. )
        if found ()
          if RegLock()
            replace Qtde         with Qtde - &cPediTMP->Qtde
            replace UltS         with dEmis
            dbunlock ()
          endif
        endif    
      endif
    else 
      select IPedARQ
      go nRegi
      
      cPrAnt := Prod
      nQtAnt := Qtde
          
      if RegLock()
        replace Prod          with cProd
        replace Produto       with &cPediTMP->Produto
        replace Unidade       with &cPediTMP->Unidade
        replace NSerie        with &cPediTMP->NSerie
        replace Valida        with &cPediTMP->Valida
        replace PrecoVenda    with &cPediTMP->PrecoVenda
        replace Qtde          with &cPediTMP->Qtde
        replace Comi          with &cPediTMP->Comi
        replace Desc          with &cPediTMP->Desc
        dbunlock ()
      endif  

      nComissao  += ( ( ( Qtde * PrecoVenda ) * Comi ) / 100 )
          
      if !&cPediTMP->Estq
        select ProdARQ
        set order to 1
        dbseek( cPrAnt, .f. )
        if found ()
          if RegLock()
            replace Qtde         with Qtde + nQtAnt
            replace UltE         with dEmis
            dbunlock ()
          endif
        endif  

        if !lLixo
          dbseek( cProd, .f. )
          if found ()
            if RegLock()
              replace Qtde         with Qtde - &cPediTMP->Qtde
              replace UltS         with dEmis
              dbunlock ()
            endif
          endif    
        endif  
      endif    

      select IPedARQ

      if lLixo
        nComissao  -= ( ( ( Qtde * PrecoVenda ) * Comi ) / 100 )
   
        if RegLock()
          dbdelete ()
          dbunlock ()
        endif
      endif
      
    endif 
      
    select( cPediTMP )
    dbskip ()
  enddo  
   
  set deleted on
  
  if cFaturas == "X"
    select ReceARQ
    set order to 1
    for nL := 1 to 9
      cParc   := str( nL, 1 )
      cParce  := strzero( nL, 2 )
      cNotaPg := cNota + cParce
    
      dbseek( cNotaPg + 'N', .f. )
      if nValor&cParc == 0
        if ! eof ()    
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
              replace Tipo  with 'N'
              dbunlock ()
            endif
          endif  
        endif
        if RegLock()
          replace Clie      with cCLie
          replace Emis      with dEmis
          replace Vcto      with dVcto&cParc
          replace Valor     with nValor&cParc
          replace Acre      with EmprARQ->Taxa
          if dVcto&cParc == dEmis
            replace Pgto    with dVcto&cParc
            replace Pago    with nValor&cParc
          else
            replace Pgto    with ctod('  /  /  ')  
            replace Pago    with 0
            replace Juro    with 0
          endif  
          replace ReprComi  with nComis&cParc
          replace Repr      with cRepr
          replace Port      with cPort
          dbunlock ()
        endif
      endif

      if dEmis == dVcto&cParc .and. EmprARQ->Caixa == "X"
        dPgto := date()
        nPago := nValor&cParc
        cNota := cNotaPg
        cHist := iif( cClie == '9999', cCliente, ClieARQ->Nome )
      
        DestLcto ()
      endif
    next  
  endif  
return NIL

//
// Imprimir Pedidos
//
function ImprPedi ()
  
  if NetUse( "NatuARQ", .t. )
    VerifIND( "NatuARQ" )
  
    fOpenNatu := .t.
   
    #ifdef DBF_NTX
      set index to NatuIND1, NatuIND2
    #endif
  else
    fOpenNatu := .f.  
  endif

  if NetUse( "TranARQ", .t. )
    VerifIND( "TranARQ" )
  
    fOpenTran := .t.
  
    #ifdef DBF_NTX
      set index to TranIND1, TranIND2
    #endif
  else
    fOpenTran := .f.  
  endif

  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )
  
    fOpenProd := .t.
  
    #ifdef DBF_NTX
      set index to ProdIND1, ProdIND2
    #endif
  else
    fOpenProd := .f.  
  endif

  if NetUse( "IPedARQ", .t. )
    VerifIND( "IPedARQ" )
  
    fOpenIPed := .t.
  
    #ifdef DBF_NTX
      set index to IPedIND1
    #endif
  else
    fOpenIPed := .f.  
  endif

  if NetUse( "CondARQ", .t. )
    VerifIND( "CondARQ" )
  
    fOpenCond := .t.
  
    #ifdef DBF_NTX
      set index to CondIND1, CondIND2
    #endif
  else
    fOpenCond := .f.  
  endif

  if NetUse( "ReprARQ", .t. )
    VerifIND( "ReprARQ" )
  
    fOpenRepr := .t.
  
    #ifdef DBF_NTX
      set index to ReprIND1, ReprIND2
    #endif
  else
    fOpenRepr := .f.  
  endif

  Aguarde ()
  
  if !TestPrint( EmprARQ->Pedido )
    if fOpenNatu
      select NatuARQ
      close
    endif  
    if fOpenTran
      select TranARQ
      close
    endif  
    if fOpenProd
      select ProdARQ
      close
    endif  
    if fOpenIPed
      select IPedARQ
      close
    endif  
    if fOpenCond
      select CondARQ
      close
    endif  
    if fOpenRepr
      select ReprARQ
      close
    endif  
    return NIL
  endif  

  select PediARQ
  set order    to 1
  set relation to Repr into ReprARQ, to Clie into ClieARQ,;
               to Natu into NatuARQ, to Cond into CondARQ,;
               to Tran into TranARQ
    
  select PediARQ
  set order to 4
  dbseek( "X", .f. )
  do while Marc == "X"
      cNota    := Nota
      cClie    := Clie
      cTran    := Tran
      cPlaca   := Placa
      cPlacaUF := PlacaUF
      cRepr    := Repr
      dSaid    := Said
      dEmis    := Emis
      cNatu    := Natu
      cCond    := Cond
      cObse    := Obse
      cPedido  := Pedido

      dVcto1   := Vcto1
      dVcto2   := Vcto2
      dVcto3   := Vcto3
      dVcto4   := Vcto4
      dVcto5   := Vcto5
      nValor1  := Valor1
      nValor2  := Valor2
      nValor3  := Valor3
      nValor4  := Valor4
      nValor5  := Valor5
      nComis1  := Comis1
      nComis2  := Comis2
      nComis3  := Comis3
      nComis4  := Comis4
      nComis5  := Comis5

      setprc( 0, 0 )

      @ nLin,00 say chr(18)
      @ nLin,01 say EmprARQ->Nome
      @ nLin,68 say 'N.'
      @ nLin,71 say Nota
      nLin ++
      @ nLin,01 say EmprARQ->Ende
      @ nLin,64 say 'Pedido'
      @ nLin,71 say Pedido                  pict '999999'
      nLin ++
      @ nLin,01 say EmprARQ->Bairro
      @ nLin,20 say alltrim( EmprARQ->Cida ) + ' - ' + EmprARQ->UF
      @ nLin,63 say 'Emissão'
      @ nLin,71 say Emis                    pict '99/99/9999'
      nLin ++
      @ nLin,01 say EmprARQ->Fone            
      @ nLin,20 say EmprARQ->Fax             
      nLin += 2

      @ nLin,01 say '  Cliente'
      if Clie == '999999'
        @ nLin,11 say Cliente
      else  
        @ nLin,11 say ClieARQ->Nome
      endif  
      @ nLin,66 say 'Cod ' + Clie
      nLin ++
      @ nLin,01 say ' Endereço'
      @ nLin,67 say 'CEP'
      @ nLin,71 say ClieARQ->CEP            pict '99999-999'
      nLin ++
      @ nLin,01 say '   Bairro'
      @ nLin,11 say ClieARQ->Bair
      @ nLin,38 say 'Cidade'
      @ nLin,45 say ClieARQ->Cida           pict '@S20'
      @ nLin,68 say 'UF ' + ClieARQ->UF
      nLin ++
      @ nLin,01 say '     Fone'
      @ nLin,11 say ClieARQ->Fone          
      nLin += 2

      @ nLin,07 say 'CGC'
      @ nLin,11 say ClieARQ->CGC            pict '@R 99.999.9999/9999-99'
      @ nLin,34 say 'Insc.Estd.'
      @ nLin,45 say ClieARQ->InscEstd
      nLin += 2

      @ nLin,02 say 'Vendedor'
      @ nLin,11 say ReprARQ->Nome + Repr

      nLin += 2
      @ nLin,03 say 'Parcela    Vcto.      Valor       Parcela    Vcto.      Valor'
      nLin += 2

      if !empty( Vcto1 )
        @ nLin,08 say '01'
        @ nLin,11 say Vcto1         pict '99/99/9999'
        @ nLin,20 say Valor1        pict '@E 999,999.99'
      endif

      if !empty( Vcto2 )
        @ nLin,42 say '02'
        @ nLin,45 say Vcto2         pict '99/99/9999'
        @ nLin,54 say Valor2        pict '@E 999,999.99'
      endif

      if !empty( Vcto3 )
        nLin ++
        @ nLin,08 say '03'
        @ nLin,11 say Vcto3         pict '99/99/9999'
        @ nLin,20 say Valor3        pict '@E 999,999.99'
      endif

      if !empty( Vcto4 )
        @ nLin,42 say '04'
        @ nLin,45 say Vcto4         pict '99/99/9999'
        @ nLin,54 say Valor4        pict '@E 999,999.99'
      endif

      if !empty( Vcto5 )
        nLin ++
        @ nLin,08 say '05'
        @ nLin,11 say Vcto5         pict '99/99/9999'
        @ nLin,20 say Valor5        pict '@E 999,999.99'
      endif

      nLin += 2

      @ nLin,06 say 'Codigo Produto/Serviço              Un. Qtde.    P. Unit.  Valor Total'
      nLin += 2

      select IPedARQ
      set order    to 1
      set relation to Prod into ProdARQ
      dbseek( cNota + '01', .t. )

      do while Nota == cNota
        nValorTotal := Qtde * PrecoVenda

        @ nLin,06 say Prod           pict '999999'
        @ nLin,13 say ProdARQ->Nome  pict '@S28'
        @ nLin,42 say ProdARQ->Unid
        if EmprARQ->Inteira == "X"
          @ nLin,47 say Qtde         pict '@E 9999999'
        else  
          @ nLin,47 say Qtde         pict '@E 99999.9'
        endif           
        @ nLin,55 say PrecoVenda     pict PictPreco(10)
        @ nLin,68 say nValorTotal    pict '@E 9,999.99'

        nLin  ++

        dbskip ()
      enddo

      select PediARQ
      nLin ++

      @ nLin,01 say '  Especie'
      @ nLin,11 say Especie
      @ nLin,30 say 'Qtde.'
      @ nLin,36 say Qtdade
      @ nLin,60 say 'Total'
      @ nLin,66 say TotalNota    pict '@E 999,999.99'

      nLin := 60

      @ nLin,01 say '_____________________________________'
      nLin ++
      @ nLin,01 say '             ASSINATURA'

      eject

      @ prow(), 00 say chr(27) + "@"
      @ prow(), 00 say chr(13)

    dbskip ()
  enddo
  
  select PediARQ
  set order to 4
  do while .t.
    dbseek( "X", .f. ) 
    
    if found()
      if Reglock(30)
        replace Marc        with space(01)
        dbunlock ()
      endif  
    else
      exit
    endif    
  enddo

  set device to screen

  if fOpenNatu
    select NatuARQ
    close
  endif  
  if fOpenTran
    select TranARQ
    close
  endif  
  if fOpenProd
    select ProdARQ
    close
  endif  
  if fOpenIPed
    select IPedARQ
    close
  endif  
  if fOpenCond
    select CondARQ
    close
  endif  
  if fOpenRepr
    select ReprARQ
    close
  endif  
return NIL

//
//  Relatorio das Notas Fiscais emitidas
//
function PrinNoEM ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )
  
    eOpenProd := .t.
      
    #ifdef DBF_NTX
      set index to ProdIND1, ProdIND2
    #endif
  endif  

  if NetUse( "PediARQ", .t. )
    VerifIND( "PediARQ" )
 
    #ifdef DBF_NTX
      set index to PediIND1, PediIND2, PediIND3, PediIND4, PediIND5
    #endif
  endif

  if NetUse( "IPedARQ", .t. )
    VerifIND( "IPedARQ" )
  
    #ifdef DBF_NTX
      set index to IPedIND1
    #endif
  endif

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )
  
    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2
    #endif
  endif

  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 08, 08, 14, 70, mensagem( 'Janela', 'PrinNoEM', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,10 say '     Nota Inicial                  Nota Final'
  @ 11,10 say '  Emissão Inicial               Emissão Final'
  @ 12,10 say '  Cliente Inicial               Cliente Final'
  @ 13,10 say '     Discriminado'
  
  setcolor( CorCampo )
  @ 13,28 say ' Sim '
  @ 13,34 say ' Não '
  
  setcolor( CorAltKC )
  @ 13,29 say 'S'
  @ 13,35 say 'N'
  
  select ClieARQ
  set order to 1
  dbgotop ()
  nClieIni := val( Clie )
  dbgobottom ()
  nClieFin := val( Clie )

  select PediARQ
  set order to 1   
  dbgotop ()
  nNotaIni := val ( Nota )
  dbgobottom ()
  nNotaFin := val ( Nota )

  dDataIni := ctod ('01/01/96')
  dDataFin := date ()

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,28 get nNotaIni          pict '999999' 
  @ 10,56 get nNotaFin          pict '999999'       valid nNotaFin >= nNotaIni
  @ 11,28 get dDataIni          pict '99/99/9999' 
  @ 11,56 get dDataFin          pict '99/99/9999'     valid dDataFin >= dDataIni
  @ 12,28 get nClieIni          pict '999999'       valid ValidClie( 99, 99, "ClieARQ", "nClieIni" )
  @ 12,56 get nClieFin          pict '999999'       valid ValidClie( 99, 99, "ClieARQ", "nClieFin" ) .and. nClieFin >= nClieIni 
  read

  if lastkey() == K_ESC
    select PediARQ
    close
    select ProdARQ
    close
    select ClieARQ
    close
    select IPedARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  lDesc := ConfLine( 13, 28, 2 )

  if lastkey() == K_ESC
    select PediARQ
    close
    select ProdARQ
    close
    select ClieARQ
    close
    select IPedARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  Aguarde ()

  nPag   := 1
  nLin   := 0
  cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

  set printer to ( cArqu2 )
  set device  to printer
  set printer on

  cClieIni := strzero( nClieIni, 6 )
  cClieFin := strzero( nClieFin, 6 )
  cNotaIni := strzero( nNotaIni, 6 )
  cNotaFin := strzero( nNotaFin, 6)
  cDataIni := dtos( dDataIni )
  cDataFin := dtos( dDataFin )
  
  nTotalICMS := nTotalIPI := nTotaGeral := 0
  nQtdeNota  := 0
  lInicio    := .t.

  select PediARQ
  set order    to 1
  set relation to Clie into ClieARQ              
  dbseek( cNotaIni, .t. )
  do while Nota >= cNotaIni .and. Nota <= cNotaFin .and. !eof ()              
    if Clie >= cClieIni .and. Clie <= cClieFin .and.;
      Emis  >= dDataIni .and. Emis <= dDataFin
      if nLin == 0
        if lDesc
          Cabecalho ( 'Notas Fiscais - Discriminadas', 132, 3 )
        else  
          Cabecalho ( 'Notas Fiscais', 132, 3 )
        endif  
        CabNota ()
      endif
    
      select PediARQ
    
      @ nLin,001 say Nota                 pict '999999' 
      @ nLin,008 say Pedido               pict '999999' 
      @ nLin,015 say Emis                 pict '99/99/9999'
      if Clie == '999999'
        @ nLin,026 say left( Cliente, 26 ) + ' ' + Clie
      else  
        @ nLin,026 say left( ClieARQ->Nome, 26 ) + ' ' + Clie
      endif  
      @ nLin,063 say Aliq                 pict '@E 99.9'
    
      nBaseICMS := nValorICMS := 0
      nValorIPI := 0
      nAliq     := Aliq
      cNota     := Nota
      lInicio   := .f.

      select IPedARQ
      set order    to 1
      set relation to Prod into ProdARQ
      dbseek( cNota, .t. )
      do while Nota == cNota
        nBaseICMS  += ( PrecoVenda * Qtde )
        nValorICMS += ( ( PrecoVenda * Qtde ) * nAliq ) / 100

        if !empty( ProdARQ->CodIPI )
          nValorIPI += ( ( PrecoVenda * Qtde ) * ProdARQ->PerIPI ) / 100
        endif    

        dbskip ()
      enddo
    
      select PediARQ
    
      @ nLin,068 say nValorICMS            pict '@E 9,999.99'
      @ nLin,077 say nValorIPI             pict '@E 9,999.99'
      @ nLin,086 say TotalNota             pict '@E 999,999.99'
    
      nTotalICMS += nValorICMS
      nTotalIPI  += nValorIPI
      nTotaGeral += TotalNota
      nQtdeNota  ++
            
      if lDesc
        select IPedARQ
        set order    to 1
        set relation to Prod into ProdARQ
        dbseek( cNota, .t. )
        do while Nota == cNota
          @ nLin,099 say val( Sequ )         pict '99'
          @ nLin,102 say val( Prod )         pict '9999'
          if Prod == '999999'
            @ nLin,107 say memoline( Produto, 10, 1 )
          else 
            @ nLin,107 say ProdARQ->Nome     pict '@S10'
          endif  
          @ nLin,118 say Qtde                pict '@E 9999'
          @ nLin,123 say PrecoVenda          pict '@E 9,999.99'
    
          nLin ++
 
          if nLin >= pLimite
            Rodape(132) 

            cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
            cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

            set printer to ( cArqu2 )
            set printer on
        
            select PediARQ
  
            if lDesc
              Cabecalho ( 'Notas Fiscais - Discriminadas', 132, 3 )
            else  
              Cabecalho ( 'Notas Fiscais', 132, 3 )
            endif  
  
            CabNota ()
          
            @ nLin,001 say Nota                 pict '999999' 
            @ nLin,008 say Pedido               pict '999999' 
            @ nLin,015 say Ordem                pict '999999' 
            @ nLin,022 say Emis                 pict '99/99/9999'
            @ nLin,033 say Clie                 pict '999999'
            @ nLin,040 say ClieARQ->Nome        pict '@S21'
            @ nLin,063 say nAliq                pict '@E 99.9'
    
            @ nLin,068 say nValorICMS          pict '@E 9,999.99'
            @ nLin,077 say nValorIPI           pict '@E 9,999.99'
            @ nLin,086 say TotalNota           pict '@E 999,999.99'
            nLin ++

            select IPedARQ
          endif
         
          dbskip ()
        enddo
      endif  
    
      select PediARQ
    
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
  
  if !lInicio
    if !lDesc
      nLin ++
    endif  
  
    @ nLin,001 say 'Total Geral:    Qtde.'
    @ nLin,022 say nQtdeNota                        pict '@E 9999'
    @ nLin,068 say nTotalICMS                       pict '@E 9,999.99'
    @ nLin,077 say nTotalIPI                        pict '@E 9,999.99'
    @ nLin,086 say nTotaGeral                       pict '@E 999,999.99'
  
    Rodape(132)
  endif  
 
  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 132 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      if lDesc
        replace Titu     with "Relatório das Notas Fiscais Emitidas Discriminadas"
      else  
        replace Titu     with "Relatório das Notas Fiscais Emitidas"
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

  select PediARQ
  close
  select ProdARQ
  close
  select ClieARQ
  close
  select IPedARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabNota ()
  @ 02,01 say 'Periodo ' + dtoc( dDataIni ) + ' a ' + dtoc( dDataFin )
  if lDesc
    @ 03,01 say 'Nota   Pedido Emissão    Cliente                             Aliq.     ICMS      IPI Total Nota  Sq. Produto        Qtde. P. Venda'
  else  
    @ 03,01 say 'Nota   Pedido Emissão    Cliente                             Aliq.     ICMS      IPI Total Nota'
  endif  

  nLin := 5  
return NIL

//
// Consulta os Pedidos e Notas Cadastrados
//
function ConsPedi()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  tPrt := savescreen( 00, 00, 23, 79 )

  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )
     
    pOpenProd := .t. 
   
    #ifdef DBF_NTX
      set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
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

  if NetUse( "NSaiARQ", .t. )
    VerifIND( "NSaiARQ" )

    pOpenNSai := .t.  

    #ifdef DBF_NTX
      set index to NSaiIND1, NSaiIND2, NSaiIND3, NSaiIND4
    #endif
  else
    pOpenNSai := .f.  
  endif

  if NetUse( "INSaARQ", .t. )
    VerifIND( "INSaARQ" )
    
    pOpenINSa := .t.

    #ifdef DBF_NTX
      set index to INSaIND1
    #endif
  else
    pOpenINSa := .f. 
  endif

  if NetUse( "PediARQ", .t. )
    VerifIND( "PediARQ" )

    pOpenPedi := .t.  

    #ifdef DBF_NTX
      set index to PediIND1, PediIND2, PediIND3, PediIND4, PediIND5
    #endif
  else
    pOpenPedi := .f.  
  endif

  if NetUse( "IPedARQ", .t. )
    VerifIND( "IPedARQ" )
    
    pOpenIPed := .t.

    #ifdef DBF_NTX
      set index to IPedIND1
    #endif
  else
    pOpenIPed := .f. 
  endif
  
  Mensagem( 'LEVE', 'Setas' )
 
  nPag       := 1
  nLin       := 0
  cArqu2     := cArqu2 + "." + strzero( nPag, 3 )
  pClie      := ClieARQ->Clie
  pNome      := ClieARQ->Nome
  aNotas     := {}
  aProdutos  := {}
  pTotalPedi := 0
  pTotalNota := 0
  pTotalGera := 0
  
  dEmisIni   := ctod( '01/01/1900' )
  dEmisFin   := ctod( '31/12/2015' )
  
  if EmprARQ->Periodo == "X"
    tPeriodo   := savescreen( 00, 00, 23, 79 )
    Janela( 09, 24, 13, 51, mensagem( 'LEVE', 'Periodo', .f. ), .f. )
    Mensagem( 'LEVE','Periodo')

    setcolor( CorJanel )
    @ 11,26 say 'Emis. Inicial'
    @ 12,26 say '  Emis. Final'
  
    @ 11,40 get dEmisIni      pict '99/99/9999'
    @ 12,40 get dEmisFin      pict '99/99/9999' valid dEmisFin >= dEmisIni
    read
  
    restscreen( 00, 00, 23, 79, tPeriodo )
  endif  
  
  select CondARQ
  set order to 1

  select ProdARQ
  set order to 1
 
  select NSaiARQ
  set order to 2
  dbseek( pClie, .t. )
  do while Clie == pClie .and. !eof()
    if Emis >= dEmisIni .and. Emis <= dEmisFin
      aadd( aNotas, { Nota, Emis } )
    endif  
    dbskip ()
  enddo
  
  set printer to ( cArqu2 )
  set device  to printer
  set printer on
  
  setprc( 0, 0 )
  
  @ nLin,pcol() + 1 say 'Nota   Emissão    Produto                            Qtde.  P.Venda Cond. Pgto.   Acrs.'
  nLin += 2

  select ProdARQ
  set order to 1
  
  select NSaiARQ
  set order    to 2
  set relation to Cond into CondARQ
  dbseek( pClie, .t. )
  do while Clie == pClie
    if Emis >= dEmisIni .and. Emis <= dEmisFin

    pNota      := Nota
    nJuros     := ( CondARQ->Acrs * ( SubTotal - Desconto ) ) / 100
    pTotalPedi := ( SubTotal - Desconto ) + nJuros  
    lVez       := .t.
 
    @ nLin,001 say Nota              pict '999999' 
    @ nLin,008 say Emis              pict '99/99/9999' 

    select INSaARQ
    set order    to 1
    set relation to Prod into ProdARQ
    dbseek( pNota, .t. )
    do while Nota == pNota
      @ nLin,019 say Prod              pict '999999'
      if Prod == '999999'
        nTota := mlcount( Produto, 50 )
        for nL := 1 to nTota
          if nL == nTota
            @ nLin,026 say memoline( Produto, 23, nL )
          else
            @ nLin,026 say memoline( Produto, 48, nL )
          endif
          nLin ++
        next
        nLin --  
      else  
        @ nLin,026 say ProdARQ->Nome   pict '@S23'
      endif  
      if EmprARQ->Inteira == "X"
        @ nLin,050 say Qtde            pict '@E 999999999'
      else
        @ nLin,050 say Qtde            pict '@E 99999.999'
      endif     
      @ nLin,060 say PrecoVenda        pict PictPreco(8)
      
      nProdElem := ascan( aProdutos, { |nElem| nElem[1] == Prod } )
      
      if nProdElem > 0
        aProdutos[ nProdElem, 4 ] += Qtde
      else
        aadd( aProdutos, { Prod, iif( Prod == '999999', memoline( Produto, 40, 1 ), ProdARQ->Nome ), ProdARQ->Unid, Qtde }  )  
      endif  
            
      if lVez 
        @ nLin,069 say CondARQ->Nome         pict '@S10'  
        @ nLin,082 say CondARQ->Acrs         pict '@E 999.99'
               
        lVez := .f.
      endif        
               
      nLin ++

      dbskip ()
    enddo
    
    if NSaiARQ->Desconto > 0
      @ nLin,029 say 'Desconto'
      @ nLin,058 say NSaiARQ->Desconto         pict '@E 999,999.99'
      nLin ++
    endif  
    
    if nJuros != 0
      @ nLin,029 say 'Juros'
      @ nLin,058 say nJuros          pict '@E 999,999.99'
      nLin ++
    endif  
    
    @ nLin,029 say 'Total Pedido'
    @ nLin,058 say pTotalPedi        pict '@E 999,999.99'  

    nLin       += 2
    pTotalGera += pTotalPedi
    
    select NSaiARQ
    endif
    
    dbskip ()  
  enddo
  
  select PediARQ
  set order    to 2
  set relation to Cond into CondARQ
  dbseek( pClie, .t. )
  do while Clie == pClie
    if Emis >= dEmisIni .and. Emis <= dEmisFin

    pNota      := Nota
    nJuros     := ( CondARQ->Acrs * ( TotalNota ) ) / 100
    pTotalNota := TotalNota
    lVez       := .t.
 
    @ nLin,001 say Nota              pict '999999' 
    @ nLin,008 say Emis              pict '99/99/9999' 

    select IPedARQ
    set order    to 1
    set relation to Prod into ProdARQ
    dbseek( pNota, .t. )
    do while Nota == pNota
      @ nLin,019 say Prod              pict '999999'
      if Prod == '999999'
        nTota := mlcount( Produto, 23 )
        
        for nL := 1 to nTota
          @ nLin,024 say memoline( Produto, 23, nL )
          nLin ++
        next
        nLin --  
      else  
        @ nLin,024 say ProdARQ->Nome   pict '@S23'
      endif  
      if EmprARQ->Inteira == "X"
        @ nLin,050 say Qtde              pict '@E 999999999'
      else      
        @ nLin,050 say Qtde              pict '@E 99999.999'
      endif     
      @ nLin,060 say PrecoVenda        pict PictPreco(8)
      
      nProdElem := ascan( aProdutos, { |nElem| nElem[1] == Prod } )
      
      if nProdElem > 0
        aProdutos[ nProdElem, 4 ] += Qtde
      else
        aadd( aProdutos, { Prod, iif( Prod == '999999', memoline( Produto, 40, 1 ), ProdARQ->Nome ), ProdARQ->Unid, Qtde }  )  
      endif  
      
      if lVez 
        @ nLin,069 say CondARQ->Nome         pict '@S10'  
        @ nLin,082 say CondARQ->Acrs         pict '@E 999.99'
               
        lVez := .f.
      endif        
               
      nLin ++

      dbskip ()
    enddo
    
    if PediARQ->Desconto > 0
      @ nLin,029 say 'Desconto'
      @ nLin,058 say PediARQ->Desconto         pict '@E 999,999.99'
      nLin ++
    endif  
    
    if nJuros != 0
      @ nLin,029 say 'Juros'
      @ nLin,058 say nJuros          pict '@E 999,999.99'
      nLin ++
    endif  
    
    @ nLin,029 say 'Total Nota'
    @ nLin,058 say pTotalNota        pict '@E 999,999.99'  

    nLin       += 2
    pTotalGera += pTotalNota
         
    select PediARQ
    endif
    
    dbskip ()  
  enddo
  
  if pTotalGera > 0  
    @ nLin,029 say 'Total Geral'
    @ nLin,058 say pTotalGera          pict '@E 999,999.99'  
  endif  
  
  if len( aProdutos ) > 0
    nLin += 2
    @ nLin,01 say '-------------------------------------------------------------------'
    nLin ++
    @ nLin,01 say '                      Acumulado de Produtos'
    nLin ++
    @ nLin,01 say '-------------------------------------------------------------------'
    nLin ++
    @ nLin,01 say 'Codigo Produto/Serviço                            Unid.       Qtde.'
    nLin      ++
    nQtdeProd := 0
    for nH := 1 to len( aProdutos )
      @ nLin,001 say aProdutos[ nH, 1 ]
      @ nLin,008 say aProdutos[ nH, 2 ]           pict '@S40'
      @ nLin,051 say aProdutos[ nH, 3 ]
      if EmprARQ->Inteira == "X"
        @ nLin,059 say aProdutos[ nH, 4 ]           pict '@E 99999.999'  
      else      
        @ nLin,059 say aProdutos[ nH, 4 ]           pict '999999999'  
      endif     

      nLin      ++
      nQtdeProd += aProdutos[ nH, 4 ]
    next
    @ nLin,01 say '-------------------------------------------------------------------'
    nLin ++
    @ nLin,035 say 'Total Geral de Produtos'
    if EmprARQ->Inteira == "X"
      @ nLin,059 say nQtdeProd                      pict '@E 999999999'  
    else  
      @ nLin,059 say nQtdeProd                      pict '@E 99999.999'  
    endif  
  endif
 
  set printer to
  set printer off
  set device  to screen
  
  if ( pTotalPedi + pTotalNota ) > 0
    Janela( 06, 05, 19, 75, mensagem( 'Janela', 'ConsPedi', .f. ), .f. )
    setcolor( CorJanel + ',' + CorCampo )
     
    aD := directory( cArqu2, "D" )    

    if ad[1,2] > 64000
      Alerta( mensagem( 'Alerta', 'ConsPedi1', .f. ) )
    else
      cArqu := memoedit( memoread( cArqu2 ), 08, 06, 18, 74, .f., '', 100, , , 1, 0 )
    endif  
  else
    Alerta( mensagem( 'Alerta', 'ConsPedi', .f. ) ) 
  endif  
  
  ferase( cArqu2 )
  
  if pOpenNSai
    select NSaiARQ
    close
  endif
  if pOpenINSa  
    select INSaARQ
    close
  endif
  if pOpenPedi
    select PediARQ
    close
  endif
  if pOpenIPed  
    select IPedARQ
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
  
  select ClieARQ
  set order to 2
  dbseek( pNome, .f. )
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

//
// Imprimir Bloqueto
//
function ImprBloq ()
  if NetUse( "CampARQ", .t. )
    VerifIND( "CampARQ" )
  
    #ifdef DBF_NTX
      set index to CampIND1, CampIND2
    #endif
  endif
  
  if NetUse( "BancARQ", .t. )
    VerifIND( "BancARQ" )

    #ifdef DBF_NTX
      set index to BancIND1, BancIND2
    #endif
  endif

  tPrt := savescreen( 00, 00, 23, 79 ) 
  
  nPag       := 1
  nLin       := nTotalNota := 0
  nValorMerc := nPesoLiqu  := 0
  
  Janela( 08, 16, 11, 60, mensagem( 'Janela', 'ImprBloq', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )
  @ 10,18 say 'Banco '
  
  nBanc := 0

  @ 10,24 get nBanc        pict '9999' valid ValidARQ( 10, 24, ReceARQ, "Código" , "Banc", "Descrição", "Nome", "Banc", "nBanc", .t., 4, "Consulta de Bancos", "BancARQ", 30 )
  read
  
  if !TestPrint( EmprARQ->Bloqueto )
    select CampARQ
    close
    select BancARQ
    close
    set device to screen
    return NIL
  endif  
  
  cBanc := strzero( nBanc, 4 )

  select BancARQ
  set order to 1
  dbseek( cBanc, .f. )

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
    Alerta( mensagem( 'Alerta', 'ImprBloq', .f. ) )
    restscreen( 00, 00, 23, 79, tPrt )
    select CampARQ
    close
    select BancARQ
    close
    return NIL
  endif
  
  cTexto := Layout
  nTama  := Tama
  nEspa  := Espa
  nComp  := Comp

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

  nLin := 1    

  select ReceARQ
  set order    to 1
  set relation to Clie into ClieARQ
   
  for nL := 1 to 5
    cParc := str( nL, 1 )   

    dbseek( cNota + cParc + 'N', .f. )
      
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
             
            if empty( cArqu )
              @ nLin, nCol say cCamp
            else  
              select( cArqu )
              do case 
                case xTipo == 'N'
                  if !empty( &cCamp )
                    @ nLin,nCol say transform( &cCamp, cPict )
                  endif  
                case xTipo == 'C'  
                  @ nLin,nCol say left( &cCamp, xTama )
                case xTipo == 'D'  
                  @ nLin,nCol say &cCamp
              endcase  
            endif  
          endif 
           
          cPalavra := ''
          nCol     := 0
        endif  
      next 
       
      nLin ++
      @ nLin,nCol say space(1)
    next     
  next  

  @ nLin,00 say chr(27) + '@'
 
  set printer to
  set printer off
  set device  to screen

  select CampARQ
  close
  select BancARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

//
// Imprimir Pedido
//
function PrinPedi ()
  
  Aguarde ()
    
  nLin       := nTotalNota := 0
  nValorMerc := nPesoLiqu  := 0
 
  if !TestPrint( EmprARQ->Pedido )
    return NIL
  endif  
  
  select PediARQ
  set order    to 1
  set relation to Repr into ReprARQ, to Clie into ClieARQ,;
               to Natu into NatuARQ, to Cond into CondARQ,;
               to Tran into TranARQ

  @ nLin,00 say chr(18)
  @ nLin,01 say EmprARQ->Nome
  @ nLin,68 say 'N.'
  @ nLin,71 say Nota
  nLin ++
  @ nLin,01 say EmprARQ->Ende
  @ nLin,64 say 'Pedido'
  @ nLin,71 say Pedido                  pict '999999'
  nLin ++
  @ nLin,01 say EmprARQ->Bairro
  @ nLin,20 say alltrim( EmprARQ->Cida ) + ' - ' + EmprARQ->UF
  @ nLin,63 say 'Emissão'
  @ nLin,71 say Emis                    pict '99/99/9999'
  nLin ++
  @ nLin,01 say EmprARQ->Fone           
  @ nLin,20 say EmprARQ->Fax            
  nLin += 2

  @ nLin,01 say '  Cliente'
  if Clie == '999999'
    @ nLin,11 say Cliente
  else   
    @ nLin,11 say ClieARQ->Nome
  endif
  @ nLin,66 say 'Cod ' + Clie
  nLin ++
  @ nLin,01 say ' Endereço'
  @ nLin,67 say 'CEP'
  @ nLin,71 say ClieARQ->CEP            pict '99999-999'
  nLin ++
  @ nLin,01 say '   Bairro'
  @ nLin,11 say ClieARQ->Bair
  @ nLin,38 say 'Cidade'
  @ nLin,45 say ClieARQ->Cida           pict '@S20'
  @ nLin,68 say 'UF ' + ClieARQ->UF
  nLin ++
  @ nLin,01 say '     Fone'
  @ nLin,11 say ClieARQ->Fone           
  nLin += 2

  @ nLin,07 say 'CGC'
  @ nLin,11 say ClieARQ->CGC            pict '@R 99.999.9999/9999-99'
  @ nLin,34 say 'Insc.Estd.'
  @ nLin,45 say ClieARQ->InscEstd
  nLin += 2

  @ nLin,02 say 'Vendedor'
  @ nLin,11 say ReprARQ->Nome + Repr

  nLin += 2
  @ nLin,03 say 'Parcela    Vcto.      Valor       Parcela    Vcto.      Valor'
  nLin += 2

  if !empty( Vcto1 )
    @ nLin,08 say '01'
    @ nLin,11 say Vcto1         pict '99/99/9999'
    @ nLin,20 say Valor1        pict '@E 999,999.99'
  endif

  if !empty( Vcto2 )
    @ nLin,42 say '02'
    @ nLin,45 say Vcto2         pict '99/99/9999'
    @ nLin,54 say Valor2        pict '@E 999,999.99'
  endif

  if !empty( Vcto3 )
    nLin ++
    @ nLin,08 say '03'
    @ nLin,11 say Vcto3         pict '99/99/9999'
    @ nLin,20 say Valor3        pict '@E 999,999.99'
  endif

  if !empty( Vcto4 )
    @ nLin,42 say '04'
    @ nLin,45 say Vcto4         pict '99/99/9999'
    @ nLin,54 say Valor4        pict '@E 999,999.99'
  endif

  if !empty( Vcto5 )
    nLin ++
    @ nLin,08 say '05'
    @ nLin,11 say Vcto5         pict '99/99/9999'
    @ nLin,20 say Valor5        pict '@E 999,999.99'
  endif

  nLin += 2

  @ nLin,06 say 'Codigo Produto/Serviço              Un. Qtde.    P. Unit.  Valor Total'
  nLin += 2

  select IPedARQ
  set order    to 1
  set relation to Prod into ProdARQ
  dbseek( cNota, .t. )

  do while Nota == cNota
    nValorTotal := Qtde * PrecoVenda

    @ nLin,06 say Prod             pict '999999'
    if Prod == '999999'
      @ nLin,13 say memoline( Produto, 28, 1 )
    else  
      @ nLin,13 say ProdARQ->Nome  pict '@S28'
    endif  
    @ nLin,42 say ProdARQ->Unid
    @ nLin,47 say Qtde             pict '@E 9999'
    @ nLin,53 say PrecoVenda       pict PictPreco(10)
    @ nLin,66 say nValorTotal      pict '@E 999,999.99'
    nLin  ++

    dbskip ()
  enddo

  select PediARQ
  nLin ++

  @ nLin,01 say '  Especie'
  @ nLin,11 say Especie
  @ nLin,30 say 'Qtde.'
  @ nLin,36 say Qtdade
  @ nLin,60 say 'Total'
  @ nLin,66 say TotalNota    pict '@E 999,999.99'

  nLin += 5

  @ nLin,01 say '_____________________________________'
  nLin ++
  @ nLin,01 say '             ASSINATURA'

  eject
        
  @ prow(), 00 say chr(27) + "@"
  @ prow(), 00 say chr(13)
  
  set device to screen
return NIL
  
//
// Retira os espaços entre as palavras e os caracteres . , / - ( )
//
function Retira( pTexto )
  local pNovo := '' 
  
  for nFF := 1 to len( pTexto )
    if substr( pTexto, nFF, 1 ) == '.' .or.;
       substr( pTexto, nFF, 1 ) == ',' .or.;
       substr( pTexto, nFF, 1 ) == '/' .or.;
       substr( pTexto, nFF, 1 ) == '(' .or.;
       substr( pTexto, nFF, 1 ) == ')' .or.;
       substr( pTexto, nFF, 1 ) == '-' .or.;
       substr( pTexto, nFF, 1 ) == ' '
      loop
    else
      pNovo += substr( pTexto, nFF, 1 )
    endif
  next
return( pNovo )  

//
//  Gera Relatorio das Notas Fiscais emitidas em disquete para Receita
//
function GeraNota ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "CondARQ", .t. )
    VerifIND( "CondARQ" )
  
    eOpenCond := .t.
      
    #ifdef DBF_NTX
      set index to CondIND1, CondIND2
    #endif
  endif  

  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )
  
    eOpenProd := .t.
      
    #ifdef DBF_NTX
      set index to ProdIND1, ProdIND2
    #endif
  endif  

  if NetUse( "ReprARQ", .t. )
    VerifIND( "ReprARQ" )
  
    eOpenRepr := .t.
      
    #ifdef DBF_NTX
      set index to ReprIND1, ReprIND2
    #endif
  endif  

  if NetUse( "PediARQ", .t. )
    VerifIND( "PediARQ" )

    #ifdef DBF_NTX
      set index to PediIND1, PediIND2, PediIND3, PediIND4, PediIND5
    #endif
  endif

  if NetUse( "IPedARQ", .t. )
    VerifIND( "IPedARQ" )
  
    #ifdef DBF_NTX
      set index to IPedIND1
    #endif
  endif

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )
  
    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2
    #endif
  endif

  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 08, 08, 15, 70, mensagem( 'Janela', 'GeraNota', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,10 say '     Nota Inicial                  Nota Final'
  @ 11,10 say '  Emissão Inicial               Emissão Final'
  @ 12,10 say '  Cliente Inicial               Cliente Final'
  
  @ 14,10 say '  Nome do Arquivo'  
  
  select ClieARQ
  set order to 1
  dbgotop ()
  nClieIni := val( Clie )
  dbgobottom ()
  nClieFin := val( Clie )
  
  select PediARQ
  set order to 1   
  dbgotop ()
  nNotaIni := val ( Nota )
  dbgobottom ()
  nNotaFin := val ( Nota )

  dDataIni := ctod ('01/01/96')
  dDataFin := date ()
  cArqu    := cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() + alltrim( EmprARQ->Direto ) +;
              '.TXT' + space( 8 - len( alltrim( EmprARQ->Direto ) ) ) 

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,28 get nNotaIni          pict '999999' 
  @ 10,56 get nNotaFin          pict '999999'     valid nNotaFin >= nNotaIni
  @ 11,28 get dDataIni          pict '99/99/9999' 
  @ 11,56 get dDataFin          pict '99/99/9999'   valid dDataFin >= dDataIni
  @ 12,28 get nClieIni          pict '9999'   
  @ 12,56 get nClieFin          pict '9999'       valid nClieFin >= nClieIni
  @ 14,28 get cArqu             pict '@!'
  read

  if lastkey() == K_ESC
    select PediARQ
    close
    select ProdARQ
    close
    select CondARQ
    close
    select ClieARQ
    close
    select ReprARQ
    close
    select IPedARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  /*
  Janela( 05, 18, 11, 54, 'Gerar Notas em Disco', .f. )
  setcolor( CorJanel + ',' + CorCampo )
  
  @ 07,20 say 'Coloque um disquete limpo no dri- ' 
  @ 08,20 say 've ' + left( cArqu, 1 ) + ': e  pressione <ENTER> quando' 
  @ 09,20 say 'pronto...'
  
  setcolor( CorCampo )
  @ 10,45 say '   OK   '
  
  setcolor( CorAltKC )
  @ 10,48 say 'O'
  
  Teclar(0)
  
  if !diskready( left( cArqu, 1 ) ) .or. lastkey() == K_ESC
    if lastkey() != K_ESC
      Alerta( space(42) + 'Disquete inv lido !!!' )
    endif  
  
    select PediARQ
    close
    select ProdARQ
    close
    select CondARQ
    close
    select ClieARQ
    close
    select ReprARQ
    close
    select IPedARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif 
*/  
  nPag     := 1
  nLin     := 0
  
  cClieIni := strzero( nClieIni, 4 )
  cClieFin := strzero( nClieFin, 4 )
  cNotaIni := strzero( nNotaIni, 6 )
  cNotaFin := strzero( nNotaFin, 6 )
  nQtde50  := 0

  select PediARQ
  set order    to 1
  set filter   to Nota >= cNotaIni .and. Nota <= cNotaFin .and.;
                  Clie >= cClieIni .and. Clie <= cClieFin .and.;
                  Emis >= dDataIni .and. Emis <= dDataFin
  set relation to Clie into ClieARQ                
  dbgotop ()
  
  if !eof()
    set date    to ansi
    set printer to ( cArqu )
    set device  to printer
    set printer on 

    cTemp     := Retira( ClieARQ->InscEstd )
    cInscEstd := cTemp + space( 14 - len( cTemp ) )
    cFax      := Retira( EmprARQ->Fax )
    cDataIni  := Retira( dtos( dDataIni ) )
    cDataFin  := Retira( dtos( dDataFin ) )
  
    @ nLin,000 say '10'
    @ nLin,002 say EmprARQ->CGC
    @ nLin,016 say cInscEstd
    @ nLin,030 say left( EmprARQ->Razao, 35 )
    @ nLin,065 say EmprARQ->Cida
    @ nLin,095 say EmprARQ->UF
    @ nLin,097 say cFax
    @ nLin,107 say cDataIni
    @ nLin,115 say cDataFin
    @ nLin,123 say space(3)
    nLin ++
  endif

  do while !eof ()              
    cNota       := Nota
    cTipo       := '50'
    cCGC        := ClieARQ->CGC 
    cInsc       := Retira( ClieARQ->InscEstd )
    cEmis       := Retira( dtos( Emis ) )
    cUF         := ClieARQ->UF
    cModelo     := ' 1'
    cSerie      := '4  '
    cSubSe      := '  '
    cNatu       := Retira( Natu )
    nValorTotal := Retira( strzero( TotalNota, 14, 2 ) )
    nBaseICMS   := Retira( strzero( BaseICMS,  14, 2 ) )
    nValorICMS  := Retira( strzero( ValorICMS, 14, 2 ) )
    nIsenta     := strzero( 0, 13 )
    nOutras     := strzero( 0, 13 )
    cAliq       := Retira( strzero( Aliq, 5, 2 )  )
    cSituacao   := iif( Situacao == 'C', 'S', 'N' )

    @ nLin,000 say cTipo
    @ nLin,002 say cCGC
    @ nLin,016 say cInsc
    @ nLin,030 say cEmis
    @ nLin,038 say cUF
    @ nLin,040 say cModelo
    @ nLin,042 say cSerie
    @ nLin,045 say cSubSe
    @ nLin,047 say cNota
    @ nLin,053 say cNatu
    @ nLin,056 say nValorTotal
    @ nLin,069 say nBaseICMS
    @ nLin,082 say nValorICMS
    @ nLin,095 say nIsenta
    @ nLin,108 say nOutras
    @ nLin,121 say cAliq
    @ nLin,125 say cSituacao
    nLin    ++
    nQtde50 ++
   
    dbskip ()
  enddo
  
  dbgotop ()
  if !eof ()
    cTemp     := Retira( ClieARQ->InscEstd )
    cInscEstd := cTemp + space( 14 - len( cTemp ) )
    cFax      := Retira( EmprARQ->Fax )
    cQtde50   := strzero( nQtde50, 8 )
    cQtde51   := strzero( 0, 8 )
    cQtde53   := strzero( 0, 8 )
    cQtde54   := strzero( 0, 8 )
    cQtde55   := strzero( 0, 8 )
    cQtde60   := strzero( 0, 8 )
    cQtde61   := strzero( 0, 8 )
    cQtde70   := strzero( 0, 8 )
    cQtde71   := strzero( 0, 8 )
    cQtde75   := strzero( 0, 8 )
    cGeral    := strzero( nQtde50 + 2, 8 )
  
    @ nLin,000 say '90'
    @ nLin,002 say EmprARQ->CGC
    @ nLin,016 say cInscEstd
    @ nLin,030 say cQtde50
    @ nLin,038 say cQtde51
    @ nLin,046 say cQtde53
    @ nLin,054 say cQtde54
    @ nLin,062 say cQtde55
    @ nLin,070 say cQtde60
    @ nLin,078 say cQtde61
    @ nLin,086 say cQtde70
    @ nLin,094 say cQtde71
    @ nLin,102 say cQtde75
    @ nLin,110 say cGeral
    @ nLin,118 say space(08)
    nLin ++
  endif

  set date    to british
  set century off
  set printer to
  set printer off

  set device  to screen

  select PediARQ
  close
  select CondARQ
  close
  select ProdARQ
  close
  select ClieARQ
  close
  select ReprARQ
  close
  select IPedARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

//
// Imprimir Nota Fiscal
//
function ImprFisa()
  nPrn := 0
   
  if EmprARQ->NSerie == "X" 
    Janela( 11, 22, 14, 40, mensagem( 'Janela', 'ImprFisc', .f. ), .f. )
    Mensagem( 'LEVE', 'Print' )
    setcolor( CorJanel )
      
    aOpc := {}

    aadd( aOpc, { ' NF ',    2, 'N', 13, 25, "Imprimir Nota Fiscal." } )
    aadd( aOpc, { ' Serie ', 2, 'S', 13, 30, "Imprimir Numero de Serie." } )
    
    nTipoNF := HCHOICE( aOpc, 2, 1 )
  else
    nTipoNF := 1
  endif  

  if EmprARQ->Impr == "X"
    if !TestPrint( EmprARQ->NotaFiscal )
      return NIL
    endif  
  else        
    aPrn := GetPrinters()
    nPrn := 1
            
    for j := 1 to len( aPrn )
      if alltrim( aPrn[j] ) == GetDefaultPrinter()
        nPrn := j
        exit
      endif                   
    next

    tPrn := savescreen( 00, 00, 23, 79 )
            
    Janela( 06, 22, 12, 62, mensagem( 'Janela', 'VerPrinter', .f. ), .f. )
    setcolor( CorJanel + ',' + CorCampo )
          
    nPrn := achoice( 08, 23, 11, 61, aPrn, .t.,,nPrn )
     
    restscreen( 00, 00, 23, 79, tPrn )
       
    if lastkey () == K_ESC
      return NIL
    endif  

    cArqu2  := CriaTemp( 5 )
    xArqu3  := right( cArqu2, 8 )
    cArqTxt := cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() + alltrim( xArqu3 ) + ".txt" + space(40)
  
    set printer to ( cArqTxt )
    set device  to printer
    set printer on
  endif  

  tPrt := savescreen( 00, 00, 23, 79 ) 
  
  if NetUse( "CampARQ", .t. )
    VerifIND( "CampARQ" )
  
    #ifdef DBF_NTX
      set index to CampIND1, CampIND2
    #endif
  endif
  
  if NetUse( "BancARQ", .t. )
    VerifIND( "BancARQ" )

    #ifdef DBF_NTX
      set index to BancIND1, BancIND2
    #endif
  endif

  if NetUse( "NatuARQ", .t. )
    VerifIND( "NatuARQ" )
  
    fOpenNatu := .t.
  
    #ifdef DBF_NTX
      set index to NatuIND1, NatuIND2
    #endif
  else
    fOpenNatu := .f.  
  endif
  
  if NetUse( "PortARQ", .t. )
    VerifIND( "PortARQ" )
  
    fOpenPort := .t.
  
    #ifdef DBF_NTX
      set index to PortIND1, PortIND2
    #endif
  else
    fOpenPort := .f.  
  endif

  if NetUse( "TranARQ", .t. )
    VerifIND( "TranARQ" )
  
    fOpenTran := .t.
  
    #ifdef DBF_NTX
      set index to TranIND1, TranIND2
    #endif
  else
    fOpenTran := .f.  
  endif

  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )
  
    fOpenProd := .t.
  
    #ifdef DBF_NTX
      set index to ProdIND1, ProdIND2
    #endif
  else
    fOpenProd := .f.  
  endif

  if NetUse( "CondARQ", .t. )
    VerifIND( "CondARQ" )
  
    fOpenCond := .t.
  
    #ifdef DBF_NTX
      set index to CondIND1, CondIND2
    #endif
  else
    fOpenCond := .f.  
  endif

  if NetUse( "ReprARQ", .t. )
    VerifIND( "ReprARQ" )
  
    fOpenRepr := .t.
  
    #ifdef DBF_NTX
      set index to ReprIND1, ReprIND2
    #endif
  else
    fOpenRepr := .f.  
  endif

  nNFis := EmprARQ->NFis
  
  select NFisARQ
  set order to 1
  dbseek( nNFis, .f. )

  if found()
    if !file( cCaminho + HB_OSpathseparator() + "LAYOUT" + HB_OSpathseparator() + "NF-" + strzero( Codigo, 4 ) + ".TXT" )
      lAchou := .f.
    else  
      lAchou := .t.
    endif  
  else
    lAchou := .f.
  endif
  
  if !lAchou
    set printer to
    set printer off
    set device  to screen
  
    Alerta( mensagem( 'Alerta', 'ImprFisc', .f. ) )

    if fOpenNatu
      select NatuARQ
      close
    endif  
    if fOpenPort
      select PortARQ
      close
    endif  
    if fOpenTran
      select TranARQ
      close
    endif  
    if fOpenProd
      select ProdARQ
      close
    endif  
    if fOpenCond
      select CondARQ
      close
    endif  
    if fOpenRepr
      select ReprARQ
      close
    endif  
    select CampARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  cTexto  := memoread( cCaminho + HB_OSpathseparator() + "LAYOUT" + HB_OSpathseparator() + "NF-" + strzero( NFisARQ->Codigo, 4 ) + ".TXT" )
  nTama   := Tama
  nEspa   := Espa
  nComp   := Comp

  cQtLin  := mlcount( cTexto, nTama )
  aLayout := {}
  nLin    := 0
  
  setprc( 0, 0 )

  if EmprARQ->Impr == "X"
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
  
    @ 00,00 say chr(27) + chr(67) + chr( cQtLin )
  endif   
  
  select ProdARQ
  set order    to 1

  select IPedARQ
  set relation to Prod into ProdARQ
  set order    to 1

  select PediARQ
  set relation to Clie into ClieARQ, to Natu into NatuARQ,;
               to Cond into CondARQ, to Tran into TranARQ,;
               to Repr into ReprARQ, to Port into PortARQ
                  
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
         
          aadd( aLayout, { nLin, nCol, Tipo, Arquivo, Campo, Tamanho, Mascara } )
  
          if alltrim( Campo ) == 'cValorExt1'   
            nTam01 := val( left( cPict, 2 ) )
            nTam02 := val( substr( cPict, 4, 2 ) )
            
            select( cArqu ) 
          
            Extenso( TotalNota, nTam01, nTam02 )
          endif  
        endif  
        cPalavra := ''
        nCol     := 0
      endif 
    next 
    nLin ++
  next  
  
  nLen   := len( aLayout )
  lItens := .f.
  aItem  := {}
  
  select PediARQ
  set order to 5
  dbseek( "X", .f. )
  do while Marc == "X"
    cNota := Nota
  
    for nJ := 1 to nLen
      nLin  := aLayout[ nJ, 1 ]
      nCol  := aLayout[ nJ, 2 ]
      xTipo := aLayout[ nJ, 3 ]
      cArqu := aLayout[ nJ, 4 ]
      cCamp := aLayout[ nJ, 5 ]
      xTama := aLayout[ nJ, 6 ]
      cPict := aLayout[ nJ, 7 ]

      if lItens
        if nLinha == nLin
          aadd( aItem, { nLin, nCol, xTipo, cArqu, cCamp, xTama, cPict } )
        else
          nLin := nLinha

          select IPedARQ
          set order to 1
          dbseek( cNota, .t. )
          do while Nota == cNota .and. !eof ()
            for nK := 1 to len( aItem )
              nCol  := aItem[ nK, 2 ]
              xTipo := aItem[ nK, 3 ]
              cArqu := aItem[ nK, 4 ]
              cCamp := aItem[ nK, 5 ]
              xTama := aItem[ nK, 6 ]
              cPict := aItem[ nK, 7 ]

              if empty( cArqu )
                @ nLin, nCol say cCamp
              else
                select( cArqu )
                do case
                  case xTipo == 'N'
                    if !empty( &cCamp )
                      @ nLin,nCol say transform( &cCamp, cPict )
                    endif
                  case xTipo == 'C'
                    @ nLin,nCol say left( &cCamp, xTama )
                  case xTipo == 'D' .or. xTipo == 'V'
                    @ nLin,nCol say &cCamp
                endcase
              endif
            next

            nLin ++
            dbskip ()
         enddo

         lItens := .f.
         nJ --
         loop
        endif
      else
        if empty( cArqu )
          @ nLin, nCol say cCamp
        else
          select( cArqu )
          do case
            case xTipo == 'N'
              if !empty( &cCamp )
                @ nLin,nCol say transform( &cCamp, cPict )
              endif
            case xTipo == 'C'
              @ nLin,nCol say left( &cCamp, xTama )
            case xTipo == 'D' .or. xTipo == 'V'
              if !empty( &cCamp )
                @ nLin,nCol say &cCamp
              endif
            case xTipo == 'I'
              lItens  := .t.
              nLinha  := nLin
            case xTipo == 'M'
              gLen := mlcount( &cCamp, xTama )

              for nT := 1 to gLen
                @ nLin,nCol say memoline( &cCamp, xTama, nT )
                nLin ++
              next
          endcase
        endif
      endif
    next
  
    select PediARQ
    dbskip ()
  enddo  
  
  if EmprARQ->Impr == "X"
    @ nLin,00 say chr(27) + '@'
  else  
    set printer to
    set printer off
    set device  to screen

    if !empty( GetDefaultPrinter() ) .and. nPrn > 0
      PrnTest(aPrn[nPrn], memoread( cArqTxt ), .f. )
    endif
  endif

  if fOpenNatu
    select NatuARQ
    close
  endif  
  if fOpenPort
    select PortARQ
    close
  endif  
  if fOpenTran
    select TranARQ
    close
  endif  
  if fOpenProd
    select ProdARQ
    close
  endif  
  if fOpenCond
    select CondARQ
    close
  endif  
  if fOpenRepr
    select ReprARQ
    close
  endif  

  set printer to
  set printer off
  set device  to screen

  select CampARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL



//
// Imprimir Nota Fiscal
//
function ImprFisc (xTipo)
  
  xTipo := 'C'
  
  set cursor off
  nPag       := 1
  nLin       := nTotalNota := 0
  nValorMerc := nPesoLiqu  := 0
  nTotItens  := 0
 
/*  
  do while lastkey() != K_ESC
    lPrint := isprinter ()
    
    if lPrint 
      set device to printer
      exit
    else
      Alerta( space(42) + 'Impressora Não est  OK !!!' )  
    endif
  enddo    
  */
  if lastkey () == K_ESC
    set device to screen
    return NIL
  endif  
  
  select IPedARQ
  set order to 1
  dbseek( cNota + '01', .t. )
  do while Nota == cNota
    nTotItens ++
    dbskip ()
  enddo  

  setprc( 0, 0 )

//  @ prow(), pcol() say chr(27) + chr(48)
//  @ prow(), pcol() say chr(27) + chr(67) + chr(88)
  @ prow(), pcol() say chr(15)

  nLin := 02

  select PediARQ
  @ nLin,093 say 'X'
  @ nLin,127 say Nota
  
  nLin := 07
  @ nLin,002 say NatuARQ->Nome
  @ nLin,047 say Natu

  nLin := 09
  
  if xTipo == 'D'
    @ nLin,002 say FornARQ->Razao
    @ nLin,093 say FornARQ->CGC               pict '@R 99.999.999/9999-99'
  else  
    @ nLin,002 say ClieARQ->Razao
    @ nLin,093 say ClieARQ->CGC               pict '@R 99.999.999/9999-99'
  endif  
  
  @ nLin,127 say Emis                       pict '99/99/99'

  nLin := 10
  if xTipo == 'D'
    @ nLin,002 say FornARQ->Ende
    @ nLin,070 say FornARQ->Bairro
    @ nLin,106 say FornARQ->CEP               pict '99999-999'
  else  
    @ nLin,002 say ClieARQ->Ende
    @ nLin,070 say ClieARQ->Bair
    @ nLin,106 say ClieARQ->CEP               pict '99999-999'
  endif  
  
//  @ nLin,127 say Said                       pict '99/99/99'

  nLin := 12
  if xTipo == 'D'
    @ nLin,002 say FOrnARQ->Cidade
    @ nLin,063 say FornARQ->Fone              pict '@S14'
    @ nLin,080 say FornARQ->UF
    @ nLin,094 say FornARQ->InscEstd
  else  
    @ nLin,002 say ClieARQ->Cida
    @ nLin,063 say ClieARQ->Fone              pict '@S14'
    @ nLin,080 say ClieARQ->UF
    @ nLin,094 say ClieARQ->InscEstd
  endif  
//  @ nLin,127 say time()

  nLin   := 14
  nGeral := nTotItens
  
  if nTotItens <= 26
  if PediARQ->Valor1 > 0
    @ nLin,003 say substr( cNota, 3 ) + '-01'
    @ nLin,019 say Vcto1                    pict '99/99/99'
    @ nLin,045 say Valor1                   pict '@E 999,999.99'
  endif
  if PediARQ->Valor2 > 0
    @ nLin,075 say substr( cNota, 3 ) + '-02'
    @ nLin,089 say Vcto2                    pict '99/99/99'
    @ nLin,113 say Valor2                   pict '@E 999,999.99'
  endif
  nLin ++
  if PediARQ->Valor3 > 0
    @ nLin,003 say substr( cNota, 3 ) + '-03'
    @ nLin,019 say Vcto3                    pict '99/99/99'
    @ nLin,045 say Valor3                   pict '@E 999,999.99'
  endif
  if PediARQ->Valor4 > 0
    @ nLin,075 say substr( cNota, 3 ) + '-04'
    @ nLin,089 say Vcto4                    pict '99/99/99'
    @ nLin,113 say Valor4                   pict '@E 999,999.99'
  endif
  if PediARQ->Valor5 > 0
    @ nLin,051 say substr( cNota, 3 ) + '-05'
    @ nLin,064 say Vcto5                    pict '99/99/99'
    @ nLin,083 say Valor5                   pict '@E 999,999.99'
  endif
  if PediARQ->Valor6 > 0
    @ nLin,097 say substr( cNota, 3 ) + '-06'
    @ nLin,108 say Vcto6                    pict '99/99/99'
    @ nLin,127 say Valor6                   pict '@E 999,999.99'
  endif
  else
    @ nLin,005 say '**'
    @ nLin,010 say '********'
    @ nLin,030 say '**********'
    @ nLin,047 say '**'
    @ nLin,055 say '********'
    @ nLin,076 say '**********'
    @ nLin,094 say '**'
    @ nLin,103 say '********'
    @ nLin,120 say '**********'
    nLin ++
    @ nLin,005 say '**'
    @ nLin,010 say '********'
    @ nLin,030 say '**********'
    @ nLin,047 say '**'
    @ nLin,055 say '********'
    @ nLin,076 say '**********'
  endif

  nLin   := 18
  nItens := 0

  select IPedARQ
  set order to 1
  dbseek( cNota + '01', .t. )
  do while Nota == cNota .and. !eof()
    nPrecoTotal := Qtde * PrecoVenda
    nTotalNota  += nPrecoTotal
    nValorMerc  += nPrecoTotal
    nPeso       := Qtde * ProdARQ->PesoLiqd
    nPesoLiqu   += nPeso
    nItens      ++

    @ nLin,003 say Prod                 pict '9999'
    if Prod == '999999'
      nLinha := mlcount( Produto, 55 )
      for nJ := 1 to nLinha
        @ nLin,011 say memoline( Produto, 55, nJ )
        nLin ++
      next
      nLin --
    else
      @ nLin,011 say ProdARQ->Nome
    endif  
//  @ nLin,080 say ProdARQ->CodTri
    if empty( ProdARQ->Unid )
      @ nLin,092 say "UN"
    else  
      @ nLin,092 say ProdARQ->Unid
    endif  
    @ nLin,098 say Qtde                 pict '@E 99999.9'
    @ nLin,106 say PrecoVenda           pict '@E 9,999.9999'
    @ nLin,120 say nPrecoTotal          pict '@E 999,999.99'
    if nAliq > 0
      @ nLin,133 say nAliq                pict '@E 99' 
    endif  
    nLin ++
    
    if nItens > 26
      nItens := 0
      nGeral -= 25

      select PediARQ
      nLin := 61
      @ nLin,008 say '**********'
      @ nLin,034 say '**********'
      @ nLin,115 say '**********'

      nLin := 63
      @ nLin,008 say '**********'
      @ nLin,034 say '**********'
      @ nLin,115 say '**********'

      nLin := 73
      @ nLin,023 say '***** VIDE NOTA FISCAL SEGUINTE *****'

      nLin := 3

      select PediARQ
      @ nLin,088 say 'X'

      nLin := 10
      @ nLin,000 say NatuARQ->Nome
      @ nLin,043 say Natu

      nLin := 13
      @ nLin,000 say ClieARQ->Nome
      @ nLin,090 say ClieARQ->CGC               pict '@R 99.999.999/9999-99'
      @ nLin,122 say Emis                       pict '99/99/99'

      nLin := 15
      @ nLin,000 say ClieARQ->Ende
      @ nLin,073 say ClieARQ->Bair
      @ nLin,100 say ClieARQ->CEP               pict '99999-999'

      nLin := 17
      @ nLin,000 say ClieARQ->Cida
      @ nLin,052 say ClieARQ->Fone              pict '(999) 999-9999'
      @ nLin,078 say ClieARQ->UF
      @ nLin,090 say ClieARQ->InscEstd

      nLin := 21
  
      if nGeral >= 26
      if PediARQ->Valor1 > 0
        @ nLin,000 say '01'
        @ nLin,010 say Vcto1                    pict '99/99/99'
        @ nLin,030 say Valor1                   pict '@E 999,999.99'
      endif
      if PediARQ->Valor2 > 0
        @ nLin,047 say '02'
        @ nLin,055 say Vcto2                    pict '99/99/99'
        @ nLin,076 say Valor2                   pict '@E 999,999.99'
      endif
      if PediARQ->Valor3 > 0
        @ nLin,094 say '03'
        @ nLin,103 say Vcto3                    pict '99/99/99'
        @ nLin,120 say Valor3                   pict '@E 999,999.99'
      endif
      nLin ++
      if PediARQ->Valor4 > 0
        @ nLin,000 say '04'
        @ nLin,010 say Vcto4                    pict '99/99/99'
        @ nLin,030 say Valor4                   pict '@E 999,999.99'
      endif
      if PediARQ->Valor5 > 0
        @ nLin,047 say '05'
        @ nLin,055 say Vcto5                    pict '99/99/99'
        @ nLin,076 say Valor5                   pict '@E 999,999.99'
      endif
      if PediARQ->Valor6 > 0
        @ nLin,094 say '06'
        @ nLin,103 say Vcto6                    pict '99/99/99'
        @ nLin,120 say Valor6                   pict '@E 999,999.99'
      endif
    else
      @ nLin,000 say '**'
      @ nLin,010 say '********'
      @ nLin,030 say '**********'
      @ nLin,047 say '**'
      @ nLin,055 say '********'
      @ nLin,076 say '**********'
      @ nLin,094 say '**'
      @ nLin,103 say '********'
      @ nLin,120 say '**********'
      nLin ++
      @ nLin,000 say '**'
      @ nLin,010 say '********'
      @ nLin,030 say '**********'
      @ nLin,047 say '**'
      @ nLin,055 say '********'
      @ nLin,076 say '**********'
    endif  
      select IPedARQ
      nLin := 27
    endif
   
    dbskip ()
  enddo

  select PediARQ
  if !empty( Pedido )
    nLin += 2
    @ nLin,014 say 'Pedido ' + Pedido
  endif  
  if Desconto > 0 
    nLin += 2
    @ nLin,014 say 'DESCONTO'
    @ nLin,105 say Desconto                 pict '@E 999,999.99'
  endif  
    
  nLin := 45
  if nAliq > 0
    nValorICMS := ( nValorMerc * nAliq ) / 100
    @ nLin,015 say nValorMerc               pict '@E 999,999.99'


//  if empty( PediARQ->Obse )
      @ nLin,041 say nValorICMS               pict '@E 999,999.99'
//  else  
//    @ nLin,041 say 0               pict '@E 999,999.99'
//  endif  
  endif
  @ nLin,120 say nValorMerc                 pict '@E 999,999.99'

  nLin := 47
  @ nLin,013 say Frete                      pict '@E 999,999.99'
  @ nLin,041 say Seguro                     pict '@E 999,999.99'
  @ nLin,120 say ( nTotalNota + Frete ) - Desconto    pict '@E 999,999.99'

  nLin := 51
  @ nLin,004 say TranARQ->Nome
  @ nLin,078 say Conta
  @ nLin,085 say Placa 
  @ nLin,098 say PlacaUF
  if !empty( TranARQ->CGC )
    @ nLin,115 say TranARQ->CGC             pict '@R 99.999.999/9999-99'
  endif

  nLin := 53
  @ nLin,004 say TranARQ->Ende
  @ nLin,070 say TranARQ->Cidade
  @ nLin,098 say TranARQ->UF
  @ nLin,111 say TranARQ->InscEstd

  nLin := 55
  @ nLin,010 say Qtdade                     pict '9,999.99'
  @ nLin,027 say Especie
  @ nLin,051 say Marca
  @ nLin,070 say Numero
  @ nLin,100 say PesoBruto                  pict '@E 9,999.99'
  @ nLin,125 say PesoLiqui                  pict '@E 9,999.99'

  nLin   := 57

  cObse  := Obse
  cQtLin := mlcount( cObse, 45 )
        
  for nK := 1 to cQtLin
    cLinha := memoline( cObse, 45, nK )
        
    @ nLin,002 say cLinha

    nLin ++
  next           
  
  nLin := 75
/*
  @ nLin,002 say ''
  nLin ++
  @ nLin,002 say ''
  nLin ++
  @ nLin,002 say ''
 */ 
  nLin   := 83
  @ nLin,127 say Nota

  nLin += 5
  @ nLin, 00 say chr(27) + "@"
  @ nLin, 00 say chr(18)

//  eject

  set device to screen
return NIL