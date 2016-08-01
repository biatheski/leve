//  Leve, Encerramento da Ordem de Servicos
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

function EnOS( pAlte, pOrde )

if NetUse( "ProdARQ", .t. )
  VerifIND( "ProdARQ" )
  
  aOpenProd := .t.
  
  #ifdef DBF_NTX
    set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
  #endif
else
  aOpenProd := .f.  
endif

if NetUse( "ClieARQ", .t. )
  VerifIND( "ClieARQ" )
  
  aOpenClie := .t.

  #ifdef DBF_NTX
    set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
  #endif
else
  aOpenClie := .f.
endif

if NetUse( "CondARQ", .t. )
  VerifIND( "CondARQ" )
  
  aOpenCond := .t.

  #ifdef DBF_NTX
    set index to CondIND1, CondIND2
  #endif
else
  aOpenCond := .f.
endif

if NetUse( "ReprARQ", .t. )
  VerifIND( "ReprARQ" )
  
  aOpenRepr := .t.

  #ifdef DBF_NTX
    set index to ReprIND1, ReprIND2
  #endif
else
  aOpenRepr := .f.
endif

if NetUse( "PortARQ", .t. )
  VerifIND( "PortARQ" )
  
  aOpenPort := .t.

  #ifdef DBF_NTX
    set index to PortIND1, PortIND2
  #endif
else
  aOpenPort := .f.
endif

if NetUse( "EnOSARQ", .t. )
  VerifIND( "EnOSARQ" )
  
  aOpenEnOS := .t.
  
  #ifdef DBF_NTX
    set index to EnOSIND1, EnOSIND2, EnOSIND3
  #endif
else
  aOpenEnOS := .f.  
endif

if NetUse( "IProARQ", .t. )
  VerifIND( "IProARQ" )
  
  aOpenIPro := .t.
  
  #ifdef DBF_NTX
    set index to IProIND1
  #endif
else
  aOpenIPro := .f.  
endif

if NetUse( "IEnOARQ", .t. )
  VerifIND( "IEnOARQ" )
  
  aOpenIEnO := .t.
  
  #ifdef DBF_NTX
    set index to IEnOIND1
  #endif
else
  aOpenIEnO := .f.  
endif

if NetUse( "ReceARQ", .t. )
  VerifIND( "ReceARQ" )
  
  aOpenRece := .t.

  #ifdef DBF_NTX
    set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
  #endif
else
  aOpenRece := .f.
endif

if NetUse( "AbOSARQ", .t. )
  VerifIND( "AbOSARQ" )
  
  aOpenAbOS := .t.
  
  #ifdef DBF_NTX
    set index to AbOSIND1, AbOSIND2, AbOSIND3
  #endif
else
  aOpenAbOS := .f.  
endif

if NetUse( "ItOSARQ", .t. )
  VerifIND( "ItOSARQ" )
  
  aOpenItOS := .t.
  
  #ifdef DBF_NTX
    set index to ItOSIND1
  #endif
else
  aOpenItOS := .f.  
endif
 
//  Variaveis para Entrada de dados
nOrdS        := nQtde       := nProd    := 0
cOrdS        := space(06)
dEmis        := dTerm       := date()
cHoraEmis    := cHoraTerm   := space(04)
nComissao    := nDesconto   := nPrecoCusto := 0
nSequ        := nClie       := nPort    := 0
nTotalNota   := nPrecoTotal := nRepr    := 0
nPrecoVenda  := nSequPrx    := nCond    := 0
cSequ        := cCond       := space(02)
cClie        := cUnidade    := space(04)
cApar        := cObse       := space(60)
cProd        := cRepr       := cHora    := cPort   := space(04)
dVcto1       := dVcto2      := dVcto3   := dVcto4  := dVcto5  := ctod ('  /  /  ')
dVcto6       := dVcto7      := dVcto8   := dVcto9  := ctod('  /  /  ')
nValor1      := nValor2     := nValor3  := nValor4 := nValor5 := 0
nValor6      := nValor7     := nValor8  := nValor9 := 0
nComis1      := nComis2     := nComis3  := nComis4 := nComis5 := 0
nComis6      := nComis7     := nComis8  := nComis9 := 0
cProduto     := cCliente    := space(40)
aOpcoes      := {}
aArqui       := {}
cEnOSARQ     := CriaTemp(0)
cEnOSIND1    := CriaTemp(1)
cChave       := "Sequ"

aadd( aArqui, { "Sequ",       "C", 004, 0 } )
aadd( aArqui, { "Prod",       "C", 006, 0 } )
aadd( aArqui, { "Produto",    "M", 010, 0 } )
aadd( aArqui, { "Unidade",    "C", 003, 0 } )
aadd( aArqui, { "Qtde",       "N", 012, 3 } )
aadd( aArqui, { "PrecoVenda", "N", 015, 6 } )
aadd( aArqui, { "PrecoCusto", "N", 015, 6 } )
aadd( aArqui, { "Regi",       "N", 008, 0 } )
aadd( aArqui, { "Novo",       "L", 001, 0 } )
aadd( aArqui, { "Lixo",       "L", 001, 0 } )

dbcreate( cEnOSARQ , aArqui )
   
if NetUse( cEnOSARQ, .f. )
  cEnOSTMP := alias ()
    
  #ifdef DBF_CDX  
    index on &cChave tag &cEnOSIND1
  #endif

  #ifdef DBF_NTX
    index on &cChave to &cEnOSIND1
    
    set index to &cEnOSIND1
  #endif
endif
 
Janela ( 01, 02, 21, 76, mensagem( 'Janela', 'EnOS', .f. ), .t. )
setcolor ( CorJanel + ',' + CorCampo )

@ 03,03 say '   N. O.S.            Emissão                Hora'
@ 05,03 say '   Cliente' 
do case
  case EmprARQ->TipoOS == 1
    @ 06,03 say '    Equip.'
    @ 07,03 say '    Modelo                               N. Série'
  case EmprARQ->TipoOS == 2 
    @ 06,03 say '   Veículo                                  Placa'
    @ 07,03 say '        KM'
  case EmprARQ->TipoOS == 3
    @ 06,03 say ' Descrição'
endcase    
@ 08,03 say '   Término                                   Hora'
@ 09,03 say 'Observação'

@ 11,04 say 'Código Descrição                         Qtde.     P. Venda Total'
@ 12,02 say chr(195) + replicate( chr(196), 73 ) + chr(180)
@ 12,10 say chr(194)
@ 12,44 say chr(194)
@ 12,54 say chr(194)
@ 12,63 say chr(194)

for nY := 13 to 16
  @ nY,10 say chr(179)
  @ nY,44 say chr(179)
  @ nY,54 say chr(179)
  @ nY,63 say chr(179)
next  
  
@ 17,02 say chr(195) + replicate( chr(196), 73 ) + chr(180)
@ 17,10 say chr(193)
@ 17,44 say chr(193)
@ 17,54 say chr(193)
@ 17,63 say chr(193)

@ 18,06 say 'Desconto'   
@ 18,41 say 'Valor Total da O.S.'

MostOpcao( 20, 04, 16, 52, 65 ) 

tSnot := savescreen( 00, 00, 24, 79 )
  
select EnOSARQ
set order to 1
if !pAlte
  dbgobottom ()
endif  

do while .t.
  Mensagem( 'EnOS','Janela')
 
  cStat := cStatAux := space(04)
  restscreen( 00, 00, 23, 79, tSnot )
  
  select( cEnOSTMP )
  set order    to 1
  set relation to Prod into ProdARQ
  zap
  
  select CondARQ
  set order to 1

  select ReprARQ
  set order to 1

  select PortARQ
  set order to 1
  
  select ClieARQ
  set order to 1
  
  select ProdARQ
  set order to 1
  
  select AbOSARQ
  set order    to 1
  set relation to Clie into ClieARQ
  
  select IEnOARQ
  set order    to 1
  set relation to Prod into ProdARQ

  select EnOSARQ
  set order    to 1
  set relation to Clie into ClieARQ, to Cond into CondARQ,;
               to Repr into ReprARQ, to Port into PortARQ

  MostEnOS ()
  
  if Demo ()
    exit
  endif  

  setcolor ( CorJanel + ',' + CorCampo )
  MostTudo := 'MostEnOS'
  cAjuda   := 'EnOS'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  if pAlte
    @ 03,14 get nOrdS            pict '999999'
    read
  else
    nOrdS := val( pOrde )
  endif
  
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC
    exit
  endif

  cOrdS := strzero( nOrdS, 6 )

  setcolor( CorCampo )
  @ 03,14 say cOrdS            pict '999999'

  //  Verificar existencia das OrdSs para Incluir ou Alterar
  select EnOSARQ
  set order to 1
  dbseek( cOrds, .f. )
    
  select AbOsARQ
  set order to 1
  dbseek( cOrdS, .f. )
  if eof()
    Alerta ( mensagem( 'Alerta', 'EnOS', .f. ) )
    loop
  else
    if empty( Term ) .and. empty( HoraTerm )  
      cStat := 'incl'
    else
      cStat := 'alte'

      MostEnOS ()
      
      Alerta( mensagem( 'Alerta', 'EnOS1', .f. ) )
    endif
  endif
  
  if cStat == 'incl'
    select IEnOARQ
    set order to 1
    dbseek( cOrdS, .t. )
    if eof() .or. OrdS != cOrdS
      select ItOSARQ
      set order to 1
      dbseek( cOrdS, .t. )
      do while OrdS == cOrdS
        nRegi := recno ()
        
        select( cEnOSTMP )
        if AdiReg()
          if RegLock()
            replace Sequ       with ItOSARQ->Sequ
            replace Prod       with ItOSARQ->Prod
            replace Produto    with ItOSARQ->Produto
            replace Unidade    with ItOSARQ->Unidade
            replace Qtde       with ItOSARQ->Qtde
            replace PrecoVenda with ItOSARQ->PrecoVenda
            replace PrecoCusto with ItOSARQ->PrecoCusto
            replace Regi       with nRegi
            replace Novo       with .t.
            replace Lixo       with .f.
            dbunlock ()
          endif
        endif
        
        select ItOSARQ
        dbskip ()
      enddo
    endif
    
    select IEnOARQ

    do while OrdS == cOrdS
      nRegi := recno ()
      
      select( cEnOSTMP )
      if AdiReg()
        if RegLock()
          replace Sequ       with IEnOARQ->Sequ
          replace Prod       with IEnOARQ->Prod
          replace Produto    with IEnOARQ->Produto
          replace Unidade    with IEnOARQ->Unidade
          replace Qtde       with IEnOARQ->Qtde
          replace PrecoVenda with IEnOARQ->PrecoVenda
          replace PrecoCusto with IEnOARQ->PrecoCusto
          replace Regi       with nRegi
          replace Novo       with .f.
          replace Lixo       with .f.
          dbunlock ()
        endif
      endif
    
      select IEnOARQ
      dbskip ()
    enddo
  endif
  
  xStatAnt := cStat
  
  if cStat == 'incl'
    MostEnOS ()
    EntrEnOS ()  
    EntrItOr ()
  endif  
  
  Confirmar( 20, 04, 16, 52, 65, 1 ) 
    
  if cStat == 'excl'
    EstoEnOS ()
  endif
  
  if lastkey() == K_ESC .or. cStat == 'loop'
    loop
  endif 
  
  select EnOSARQ
  
  if xStatAnt == 'incl'
    if AdiReg()
      if RegLock()
        replace OrdS       with cOrdS
        replace Clie       with cClie
        replace Obse       with cObse
        replace Term       with dTerm
        replace HoraTerm   with cHoraTerm
        replace Desconto   with nDesconto
        replace TotalNota  with nTotalNota
        replace Comissao   with nComissao
        replace Repr       with cRepr
        replace Port       with cPort
        replace Cond       with cCond
        replace Vcto1      with dVcto1
        replace Valor1     with nValor1
        replace Comis1     with nComis1
        replace Vcto2      with dVcto2
        replace Valor2     with nValor2
        replace Comis2     with nComis2
        replace Vcto3      with dVcto3
        replace Valor3     with nValor3
        replace Comis3     with nComis3
        replace Vcto4      with dVcto4
        replace Valor4     with nValor4
        replace Comis4     with nComis4
        replace Vcto5      with dVcto5
        replace Valor5     with nValor5
        replace Comis5     with nComis5
        replace Vcto6      with dVcto6
        replace Valor6     with nValor6
        replace Comis6     with nComis6
        replace Vcto7      with dVcto7
        replace Valor7     with nValor7
        replace Comis7     with nComis7
        replace Vcto8      with dVcto8
        replace Valor8     with nValor8
        replace Comis8     with nComis8
        replace Vcto9      with dVcto9
        replace Valor9     with nValor9
        replace Comis9     with nComis9
        dbunlock ()
      endif  
    endif
  endif

  GravEnOS ()
  
  select AbOSARQ
  set order to 1
  if RegLock()
    replace Term              with dTerm
    replace HoraTerm          with cHoraTerm
    dbunlock ()
  endif  

  if cStat == 'prin'
    ImprEnOS (.f.)
  endif
enddo

if aOpenCond
  select CondARQ
  close
endif

if aOpenIPro
  select IProARQ
  close
endif

if aOpenRepr
  select ReprARQ
  close
endif

if aOpenPort
  select PortARQ
  close
endif

if aOpenEnOS
  select EnOSARQ
  close
endif

if aOpenClie
  select ClieARQ
  close
endif

if aOpenRece
  select ReceARQ
  close
endif

if aOpenProd
  select ProdARQ
  close
endif  

if aOpenIEnO
  select IEnOARQ
  close
endif

if aOpenAbOS
  select AbOSARQ
  close
endif

if aOpenItOS
  select ItOSARQ
  close
endif

select( cEnOSTMP )
close
ferase( cEnOSARQ )
ferase( cEnOSIND1 )
#ifdef DBF_CDX
  ferase( left( cEnOSARQ, len( cEnOSARQ ) - 3 ) + 'FPT' )
#endif
#ifdef DBF_NTX
  ferase( left( cEnOSARQ, len( cEnOSARQ ) - 3 ) + 'DBT' )
#endif  
return NIL

//
// Mostra os dados
//
function MostEnOS()
  if cStat == space(04)
    cOrdS := EnOSARQ->OrdS
    nOrdS := val( cOrdS ) 
  endif
  
  select AbOSARQ
  set order to 1
  dbseek( cOrdS, .f. )

  select EnOSARQ
 
  dTerm      := AbOSARQ->Term  
  cHoraTerm  := AbOSARQ->HoraTerm
  dEmis      := AbOSARQ->Emis
  cHoraEmis  := AbOSARQ->HoraEmis
  cClie      := AbOSARQ->Clie 
  cCliente   := AbOSARQ->Cliente
  cRepr      := Repr
  nRepr      := val( Repr )
  cCond      := Cond
  nCond      := val( Cond )
  cPort      := Port
  nPort      := val( Port )
  cObse      := Obse
  nLin       := 13

  dVcto1     := Vcto1
  nValor1    := Valor1
  dVcto2     := Vcto2
  nValor2    := Valor2
  dVcto3     := Vcto3
  nValor3    := Valor3
  dVcto4     := Vcto4
  nValor4    := Valor4
  dVcto5     := Vcto5
  nValor5    := Valor5
  dVcto6     := Vcto6
  nValor6    := Valor6
  dVcto7     := Vcto7
  nValor7    := Valor7
  dVcto8     := Vcto8
  nValor8    := Valor8
  dVcto9     := Vcto9
  nValor9    := Valor9

  nComissao  := Comissao
  nDesconto  := Desconto
  nTotalNota := TotalNota - Desconto
  
  setcolor( CorCampo )
  @ 03,33 say dEmis           pict '99/99/9999'
  @ 03,53 say cHoraEmis       pict '99:99'
  @ 05,14 say cClie           pict '999999'
  if cClie == '999999'
    @ 05,21 say cCliente
  else  
    @ 05,21 say ClieARQ->Nome
  endif  
  do case
    case EmprARQ->TipoOS == 1
      @ 06,14 say AbOSARQ->Apa1        pict '@S50'
      @ 07,14 say AbOSARQ->Modelo      pict '@S20'                   
      @ 07,53 say AbOSARQ->NSerie      pict '@S20'                   
    case EmprARQ->TipoOS == 2
      @ 06,14 say AbOSARQ->Veic        pict '@S20'
      @ 06,53 say AbOSARQ->Placa       
      @ 07,14 say AbOSARQ->KM          pict '@E 99999,999.9'
    case EmprARQ->TipoOS == 3
      @ 06,14 say AbOSARQ->Apa1        pict '@S50'
      @ 07,14 say AbOSARQ->Apa2        pict '@S50'
  endcase    
  @ 08,14 say dTerm           pict '99/99/9999'
  @ 08,53 say cHoraTerm       pict '99:99'
  @ 09,14 say cObse           pict '@S50'
  
  if cStat == 'alte' .or. cStat == space(04)
    setcolor( CorJanel )
    for nG := 1 to 4 
      @ nLin, 04 say '      '    
      @ nLin, 11 say space(33)
      @ nLin, 45 say '         '
      @ nLin, 55 say '        '
      @ nLin, 64 say '          '
      nLin ++
    next

    nLin := 13

    setcolor( CorJanel )
    select IEnOARQ
    set order to 1
    dbseek( cOrdS, .t. )
    do while OrdS == cOrdS .and. !eof()
      if nLin < 17
        @ nLin, 04 say Prod                  pict '999999'
        if Prod == '999999'
          @ nLin, 11 say memoline( Produto, 33, 1 )
        else  
          @ nLin, 11 say ProdARQ->Nome       pict '@S33'
        endif  
        if EmprARQ->Inteira == "X"
          @ nLin, 45 say Qtde                pict '@E 999999999'
        else  
          @ nLin, 45 say Qtde                pict '@E 99999.999'
        endif  
        @ nLin, 55 say PrecoVenda            pict PictPreco(8)
        @ nLin, 64 say Qtde * PrecoVenda     pict '@E 999,999.99'
      endif     
      nLin ++
      dbskip ()
    enddo
  else
    setcolor( CorJanel )
    for nG := 1 to 4  
      @ nLin, 04 say '      '    
      @ nLin, 11 say space(33)
      @ nLin, 45 say '         '
      @ nLin, 55 say '        '
      @ nLin, 64 say '          '
      nLin ++
    next

    nLin       := 13
    nTotalNota := 0

    setcolor( CorJanel )
    select( cEnOSTMP )
    set order to 1
    dbgotop ()
    do while !eof()
      nTotalNota += ( Qtde * PrecoVenda )
      if nLin < 17      
        @ nLin, 04 say Prod                  pict '999999'
        if Prod == '999999'
          @ nLin, 11 say memoline( Produto, 33, 1 )
        else  
          @ nLin, 11 say ProdARQ->Nome       pict '@S33'
        endif  
        if EmprARQ->Inteira == "X"
          @ nLin, 45 say Qtde                pict '@E 999999999'
        else  
          @ nLin, 45 say Qtde                pict '@E 99999.999'
        endif  
        @ nLin, 55 say PrecoVenda            pict PictPreco(8)
        @ nLin, 64 say Qtde * PrecoVenda     pict '@E 999,999.99'
      endif
      nLin ++
      dbskip ()
    enddo
  endif  
  
  select EnOSARQ

  setcolor( CorCampo )
  @ 18,15 say nDesconto              pict '@E 999,999,999.99'
  @ 18,61 say nTotalNota             pict '@E 999,999,999.99'
  
  PosiDBF( 01, 76 )
return NIL

//
// Entra os dados
//
function EntrEnOS ()
  if empty( dTerm )
    dTerm := date()
  endif  
  if empty( cHoraTerm )
    cHoraTerm := time()
  endif  
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,14 get dTerm           pict '99/99/9999'
  @ 08,53 get cHoraTerm       pict '99:99' valid ValidHora( cHoraTerm, "cHoraTerm" )
  @ 09,14 get cObse           pict '@S50'
  read
return NIL    

//
// Entra com os itens 
//
function EntrItOr()
  if lastkey() == K_ESC .or. lastkey() == K_PGDN .or. lastkey() == K_PGUP
    return NIL
  endif  

  select( cEnOSTMP )
  set order    to 1
  set relation to Prod into ProdARQ

  bFirst := {|| dbseek( '0001', .t. ) }
  bLast  := {|| dbseek( '9999', .t. ), dbskip(-1) }
  bFor   := {|| .t. }
  bWhile := {|| .t. }

  oEncer         := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oEncer:nTop    := 11
  oEncer:nLeft   := 4
  oEncer:nBottom := 17
  oEncer:nRight  := 73
  oEncer:headsep := chr(194)+chr(196)
  oEncer:colsep  := chr(179)
  oEncer:footsep := chr(193)+chr(196)

  oEncer:addColumn( TBColumnNew("Código",    {|| Prod } ) )
  oEncer:addColumn( TBColumnNew("Descrição", {|| iif( Prod == '999999', memoline( Produto, 33, 1 ), left( ProdARQ->Nome, 33 ) ) } ) )
  if EmprARQ->Inteira == "X"
    oEncer:addColumn( TBColumnNew("Qtde.",   {|| transform( Qtde, '@E 999999999' ) } ) )
  else  
    oEncer:addColumn( TBColumnNew("Qtde.",   {|| transform( Qtde, '@E 99999.999' ) } ) )
  endif  
  oEncer:addColumn( TBColumnNew("P. Venda",  {|| transform( PrecoVenda, PictPreco(8) ) } ) )
  oEncer:addColumn( TBColumnNew("Total",     {|| transform( PrecoVenda * Qtde, '@E 999,999.99' ) } ) )
            
  lExitRequested := .f.
  lAlterou       := .f.

  oEncer:goBottom()

  do while !lExitRequested
    Mensagem ( 'LEVE','Browse')

    oEncer:forcestable()
     
    if oEncer:hitTop .and. !empty( Prod )
      oEncer:refreshAll()
      
      EntrEnOS ()
      
      select( cEnOSTMP ) 

      oEncer:down()
      oEncer:forcestable()
      oEncer:refreshAll()
      loop
    endif
         
    if ( !lAlterou .and. cStat == 'incl' ) .or. ( oEncer:hitbottom .and. lastkey() != K_ESC )
      cTecla := K_INS
    else  
      cTecla := Teclar(0)
    endif  

    do case
      case cTecla == K_DOWN;        oEncer:down()
      case cTecla == K_UP;          oEncer:up()
      case cTecla == K_PGUP;        oEncer:pageUp()
      case cTecla == K_CTRL_PGUP;   oEncer:goTop()
      case cTecla == K_PGDN;        oEncer:pageDown()
      case cTecla == K_CTRL_PGDN;   oEncer:goBottom()
      case cTecla == K_ESC
        if Saindo (lAlterou)
          lExitRequested := .t.
        else  
          lExitRequested := .f.
        endif  
      case cTecla == 46
        @ 18,15 get nDesconto              pict '@E 999,999,999.99'
        read  
      
        EntVctOS ()
        
        lExitRequested := .t.
      case cTecla == K_ENTER;          EntrItEnOS( .f. )
      case cTecla == K_INS
        do while lastkey() != K_ESC
          EntrItEnOS( .t. )
        enddo  
        
        cTecla := ""
      case cTecla == K_DEL
        if RegLock()
          setcolor( CorCampo )
          nPrecoVenda := PrecoVenda
          nTotalNota  -= ( nQtde * nPrecoVenda )

          @ 18,61 say nTotalNota       pict '@E 999,999,999.99'

          replace Lixo      with .t.  
            
          dbdelete ()
          dbunlock ()
    
          oEncer:refreshAll()  
          oEncer:gotop ()
        endif  
    endcase
  enddo
return NIL  

//
// Vencimento do Encerramento da OS
//
function VctoEnOS()    
  if nCond == 0   
    dVcto1    := dVcto2  := dVcto3  := dVcto4  := dVcto5  := ctod ('  /  /  ')
    dVcto6    := dVcto7  := dVcto8  := dVcto9  := ctod('  /  /  ')
    nValor1   := nValor2 := nValor3 := nValor4 := nValor5 := 0
    nValor6   := nValor7 := nValor8 := nValor9 := 0
    nComis1   := nComis2 := nComis3 := nComis4 := nComis5 := 0
    nComis6   := nComis7 := nComis8 := nComis9 := 0
  else
    nComissao := 0
   
    select( cEnOSTMP )
    dbgotop ()
    do while !eof ()
      nComissao += ( ( ( PrecoVenda * Qtde ) * ReprARQ->Perc ) / 100 )
      
      dbskip ()
    enddo  

    select EnOSARQ  
  
    nTotalPagar := nTotalNota + ( nTotalNota * CondARQ->Acrs / 100 ) - nDesconto
    dVcto1      := dVcto2  := dVcto3  := dVcto4  := dVcto5  := ctod ('  /  /  ')
    dVcto6      := dVcto7  := dVcto8  := dVcto9  := ctod('  /  /  ')
    nValor1     := nValor2 := nValor3 := nValor4 := nValor5 := 0
    nValor6     := nValor7 := nValor8 := nValor9 := 0
    nComis1     := nComis2 := nComis3 := nComis4 := nComis5 := 0
    nComis6     := nComis7 := nComis8 := nComis9 := 0
    dVcto1      := dTerm + CondARQ->Vct1
    nValor1     := nTotalPagar
    nComis1     := nComissao
    nParcAll    := 1
 
    if CondARQ->Vct2 != 0 .or. CondARQ->Vct3 != 0 .or. CondARQ->Vct4 != 0 .or.;
       CondARQ->Vct5 != 0 .or. CondARQ->Vct6 != 0 .or. CondARQ->Vct7 != 0 .or.;
       CondARQ->Vct8 != 0 .or. CondARQ->Vct9 != 0
 
      dVcto2  := dTerm + CondARQ->Vct2
      nComis1 := nComis2 := nComissao / 2

      if CondARQ->Indi > 0
        nValor1 := nValor2 := nTotalPagar * CondARQ->Indi
      else  
        nValor1 := nValor2 := nTotalPagar / 2
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct3 != 0 .or. CondARQ->Vct4 != 0 .or. CondARQ->Vct5 != 0 .or.;
       CondARQ->Vct6 != 0 .or. CondARQ->Vct7 != 0 .or. CondARQ->Vct8 != 0 .or.;
       CondARQ->Vct9 != 0
      dVcto3  := dTerm + CondARQ->Vct3
      nComis1 := nComis2 := nComis3 := nComissao / 3

      if CondARQ->Indi > 0
        nValor1 := nValor2 := nValor3 := nTotalPagar * CondARQ->Indi
      else  
        nValor1 := nValor2 := nValor3 := nTotalPagar / 3
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct4 != 0 .or. CondARQ->Vct5 != 0 .or. CondARQ->Vct6 != 0 .or.;
       CondARQ->Vct7 != 0 .or. CondARQ->Vct8 != 0 .or. CondARQ->Vct9 != 0
      dVcto4  := dTerm + CondARQ->Vct4
      nComis1 := nComis2 := nComis3 := nComis4 := nComissao / 4

      if CondARQ->Indi > 0
        nValor1 := nValor2 := nValor3 := nValor4 := nTotalPagar * CondARQ->Indi
      else  
        nValor1 := nValor2 := nValor3 := nValor4 := nTotalPagar / 4
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct5 != 0 .or. CondARQ->Vct6 != 0 .or. CondARQ->Vct7 != 0 .or.;
       CondARQ->Vct8 != 0 .or. CondARQ->Vct9 != 0
      dVcto5  := dTerm + CondARQ->Vct5
      nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := nComissao / 5

      if CondARQ->Indi > 0
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nTotalPagar * CondARQ->Indi
      else  
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nTotalPagar / 5
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct6 != 0 .or. CondARQ->Vct7 != 0 .or. CondARQ->Vct8 != 0 .or.;
       CondARQ->Vct9 != 0
      dVcto6  := dTerm + CondARQ->Vct6
      nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := nComis6 := nComissao / 6

      if CondARQ->Indi > 0
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nTotalPagar * CondARQ->Indi
      else  
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nTotalPagar / 6
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct7 != 0 .or. CondARQ->Vct8 != 0 .or. CondARQ->Vct9 != 0
      dVcto7  := dTerm + CondARQ->Vct7
      nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := nComis6 := nComis7 := nComissao / 7

      if CondARQ->Indi > 0
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nTotalPagar * CondARQ->Indi
      else  
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nTotalPagar / 7
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct8 != 0 .or. CondARQ->Vct9 != 0
      dVcto8  := dTerm + CondARQ->Vct8
      nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := nComis6 := nComis7 := nComis8 := nComissao / 8

      if CondARQ->Indi > 0
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nValor8 := nTotalPagar * CondARQ->Indi
      else  
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nValor8 := nTotalPagar / 8
      endif  
      nParcAll ++
    endif

    if CondARQ->Vct9 != 0
      dVcto9  := dTerm + CondARQ->Vct9
      nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := nComis6 := nComis7 := nComis8 := nComis9 := nComissao / 9
    
      if CondARQ->Indi > 0
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nValor8 := nValor9 := nTotalPagar * CondARQ->Indi
      else  
        nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nValor8 := nValor9 := nTotalPagar / 9
      endif  
      nParcAll ++
    endif
  endif  

  setcolor( CorCampo )
  if nCond == 0
    @ 07,34 say space(30)
  else  
    @ 07,34 say CondARQ->Nome
  endif  
  @ 09,31 say dVcto1            pict '99/99/9999'
  @ 09,52 say nValor1           pict '@E 999,999,999.99'
  if nParcAll >= 2
    @ 10,31 say dVcto2          pict '99/99/9999'
    @ 10,52 say nValor2         pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 3
    @ 11,31 say dVcto3          pict '99/99/9999'
    @ 11,52 say nValor3         pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 4
    @ 12,31 say dVcto4          pict '99/99/9999'
    @ 12,52 say nValor4         pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 5
    @ 13,31 say dVcto5          pict '99/99/9999'
    @ 13,52 say nValor5         pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 6
    @ 14,31 say dVcto6          pict '99/99/9999'
    @ 14,52 say nValor6         pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 7
    @ 15,31 say dVcto7          pict '99/99/9999'
    @ 15,52 say nValor7         pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 8
    @ 16,31 say dVcto8          pict '99/99/9999'
    @ 16,52 say nValor8         pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 9
    @ 17,31 say dVcto9          pict '99/99/9999'
    @ 17,52 say nValor9         pict '@E 999,999,999.99'
  endif  
return(.t.)

//
// Entra com os vencimentos da O.S.
//
function EntVctOS ()
  
  if lastkey() == K_ESC 
    return NIL
  endif

  tVctS    := savescreen( 00, 00, 23, 79 )
  nParcAll := 1

  EnOsMost ()
  
  do while !eof () 
    EnOsCond ()

    @ 09,31 get dVcto1    pict '99/99/9999'
    @ 09,52 get nValor1   pict '@E 999,999,999.99'  
    if nParcAll >= 2
      @ 10,31 get dVcto2    pict '99/99/9999'
      @ 10,52 get nValor2   pict '@E 999,999,999.99'
    endif  
    if nParcAll >= 3
      @ 11,31 get dVcto3    pict '99/99/9999'
      @ 11,52 get nValor3   pict '@E 999,999,999.99'
    endif  
    if nParcAll >= 4
      @ 12,31 get dVcto4    pict '99/99/9999'
      @ 12,52 get nValor4   pict '@E 999,999,999.99'
    endif  
    if nParcAll >= 5
      @ 13,31 get dVcto5    pict '99/99/9999'
      @ 13,52 get nValor5   pict '@E 999,999,999.99'
    endif  
    if nParcAll >= 6
      @ 14,31 get dVcto6    pict '99/99/9999'
      @ 14,52 get nValor6   pict '@E 999,999,999.99'  
    endif  
    if nParcAll >= 7
      @ 15,31 get dVcto7    pict '99/99/9999'
      @ 15,52 get nValor7   pict '@E 999,999,999.99'
    endif  
    if nParcAll >= 8
      @ 16,31 get dVcto8    pict '99/99/9999'
      @ 16,52 get nValor8   pict '@E 999,999,999.99'
    endif  
    if nParcAll >= 9
      @ 17,31 get dVcto9    pict '99/99/9999'
      @ 17,52 get nValor9   pict '@E 999,999,999.99'
    endif  
    read
     
    cRepr := strzero( nRepr, 4 )
    cPort := strzero( nPort, 4 )
    cCond := strzero( nCond, 2 )
 
    restscreen( 00, 00, 23, 79, tVctS )
    return NIL
  enddo  
return NIL

//
//
//
function EnOsMost()
  Janela ( 03, 09, 09 + nParcAll, 68, mensagem( 'Janela', 'EnOSMost', .f. ), .f. )
  Mensagem ( 'PedF','Vcto')

  setcolor ( CorJanel )
  @ 05,11 say '           Vendedor'
  @ 06,11 say '           Portador'
  @ 07,11 say 'Condiç”es Pagamento'
  @ 09,11 say '       Vencimento 1              Valor 1'
  if nParcAll >= 2
    @ 10,11 say '       Vencimento 2              Valor 2'
  endif  
  if nParcAll >= 3
    @ 11,11 say '       Vencimento 3              Valor 3'
  endif  
  if nParcAll >= 4
    @ 12,11 say '       Vencimento 4              Valor 4'
  endif  
  if nParcAll >= 5
    @ 13,11 say '       Vencimento 5              Valor 5'
  endif  
  if nParcAll >= 6
    @ 14,11 say '       Vencimento 6              Valor 6'
  endif  
  if nParcAll >= 7
    @ 15,11 say '       Vencimento 7              Valor 7'
  endif  
  if nParcAll >= 8
    @ 16,11 say '       Vencimento 8              Valor 8'
  endif  
  if nParcAll >= 9
    @ 17,11 say '       Vencimento 9              Valor 9'
  endif  

  setcolor( CorCampo )
  @ 05,31 say nRepr           pict '999999'
  @ 05,38 say ReprARQ->Nome   pict '@S30'
  @ 06,31 say nPort           pict '999999'
  @ 06,38 say PortARQ->Nome   pict '@S30'
  @ 07,31 say nCond           pict '999999'  
  @ 07,38 say CondARQ->Nome
  @ 09,31 say dVcto1          pict '99/99/9999'
  @ 09,52 say nValor1         pict '@E 999,999,999.99'  
  if nParcAll >= 2
    @ 10,31 say dVcto2        pict '99/99/9999'
    @ 10,52 say nValor2       pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 3
    @ 11,31 say dVcto3        pict '99/99/9999'
    @ 11,52 say nValor3       pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 4
    @ 12,31 say dVcto4    pict '99/99/9999'
    @ 12,52 say nValor4   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 5
    @ 13,31 say dVcto5    pict '99/99/9999'
    @ 13,52 say nValor5   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 6
    @ 14,31 say dVcto6    pict '99/99/9999'
    @ 14,52 say nValor6   pict '@E 999,999,999.99'  
  endif  
  if nParcAll >= 7
    @ 15,31 say dVcto7    pict '99/99/9999'
    @ 15,52 say nValor7   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 8
    @ 16,31 say dVcto8    pict '99/99/9999'
    @ 16,52 say nValor8   pict '@E 999,999,999.99'
  endif  
  if nParcAll >= 9
    @ 17,31 say dVcto9    pict '99/99/9999'
    @ 17,52 say nValor9   pict '@E 999,999,999.99'
  endif  
return NIL

//
//
//
function EnOsCond ()   
  local GetList := {}

  setcolor ( CorJanel + ',' + CorCampo )
  @ 05,31 get nRepr     pict '999999'     valid ValidARQ( 05, 31, "EnOSARQ", "Código", "Repr", "Descrição", "Nome", "Repr", "nRepr", .t., 6, "Consulta dos Vendedores", "ReprARQ", 30 )
  @ 06,31 get nPort     pict '999999'     valid ValidARQ( 06, 31, "EnOSARQ", "Código", "Port", "Descrição", "Nome", "Port", "nPort", .t., 6, "Consulta dos Portadores", "PortARQ", 30 )
  @ 07,31 get nCond     pict '999999'     valid ValidARQ( 07, 31, "EnOSARQ", "Código", "Cond", "Descrição", "Nome", "Cond", "nCond", .t., 6, "Consulta das Condições Pagamento", "CondARQ", 30 ) .and. VctoEnOs() .or. nCond == 0 .and. VctoEnOs()
  read
  
  EnOsMost ()
return NIL  

//
// Entra intens da nota
//
function EntrItEnOS( lAdiciona )
  if lAdiciona 
    if AdiReg()
      if RegLock()
        replace Sequ            with strzero( recno(), 4 )
        replace Novo            with .t.
        replace Lixo            with .f.
        dbunlock ()
      endif
    endif    
    
    dbgobottom ()

    oEncer:goBottom() 
    oEncer:down()
    oEncer:refreshAll()  

    oEncer:forcestable()
      
    Mensagem( 'PedF','InclIten')
  else
    Mensagem( 'PedF','AlteIten')
  endif  

  cProd       := Prod
  nProd       := val( cProd )
  cProduto    := Produto
  nQtde       := Qtde
  nPrecoVenda := PrecoVenda
  nPrecoCusto := PrecoCusto
  cUnidade    := Unidade
  
  nQtdeAnt    := Qtde
  nPrecoAnt   := PrecoVenda
  nLin        := 12 + oEncer:rowPos
  lIPro       := .f.
  lAlterou    := .t.
    
  setcolor( CorCampo )
  @ nLin, 04 say cProd                  pict '999999'
  if Prod == '999999'
    @ nLin, 11 say memoline( Produto, 33, 1 )
  else  
    @ nLin, 11 say ProdARQ->Nome        pict '@S33'
  endif  
  
  @ nLin, 55 say nPrecoVenda            pict PictPreco(8)
  @ nLin, 64 say nQtde * nPrecoVenda    pict '@E 999,999.99'
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ nLin, 04 get cProd         pict '@K'            valid ValidProd( nLin, 04, cEnOSTMP, 'enos', 0, 0, nPrecoVenda )
  if EmprARQ->Inteira == "X"
    @ nLin, 45 get nQtde       pict '@E 999999999'  valid ValidQtde( nQtde ) .and. ValidEnOS()
  else  
    @ nLin, 45 get nQtde       pict '@E 99999.999'  valid ValidQtde( nQtde ) .and. ValidEnOS() 
  endif  
  @ nLin, 55 get nPrecoVenda   pict PictPreco(8)
  read
     
  if lastkey () == K_ESC
    if lAdiciona
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif  
    endif  

    oEncer:refreshCurrent()  
    oEncer:goBottom()
    return NIL
  endif  
  
  if lIPro 
    select IProARQ
    do while Prod == cProd .and. !eof()
      select( cEnOSTMP )   

      if RegLock()
        replace Prod            with IProARQ->Cod
        replace Produto         with IProARQ->Produto
        replace Qtde            with IProARQ->Qtde * nQtde
        replace PrecoVenda      with IProARQ->PrecoVenda
        dbunlock ()
      endif

      nTotalNota += ( ( nQtde * IProARQ->Qtde ) * IProARQ->PrecoVenda )
      
      select IProARQ
      dbskip()
      if Prod == cProd .and. !eof()
        select( cEnOSTMP )
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

    select( cEnOSTMP )   

    oEncer:refreshCurrent()  
    lAlterou := .t.
  else
    if RegLock()
      replace Prod            with cProd
      replace Produto         with cProduto 
      replace Qtde            with nQtde
      replace PrecoVenda      with nPrecoVenda
      replace PrecoCusto      with nPrecoCusto
      replace Unidade         with cUnidade
      replace Lixo            with .f.
      dbunlock ()
    endif
  endif  
  
  oEncer:refreshCurrent()  
  
  if !lAdiciona
    nTotalNota -= ( nQtdeAnt * nPrecoAnt )
    nTotalNota += ( nQtde * nPrecoVenda )
  else
    nTotalNota += ( nQtde * nPrecoVenda )
  
    oEncer:goBottom() 
  endif
  
  setcolor( CorCampo )
  @ 18,61 say nTotalNota       pict '@E 999,999,999.99'
return NIL     

//
// Verifica Composicao
//
function ValidEnOS ()
  select IProARQ
  set order to 1 
  dbseek( cProd, .t. )
  if Prod == cProd
    lIPro := .t.
    
    keyboard(chr(13))
  else  
    lIPro := .f.
  endif
  select( cEnOSTMP )   
return(.t.)

//
// Excluir OrdS
//
function EstoEnOS ()
  cStat  := 'loop' 
  lEstq  := .f.
  
  select EnOSARQ

  if ExclEstq ()
    select AbOSARQ
    if RegLock()
      replace Term         with ctod('  /  /  ')
      replace HoraTerm     with space(05)
      dbunlock()
    endif
  
    select IEnOARQ
    set order to 1
    dbseek( cOrdS, .t. )
    do while OrdS == cOrdS
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
          replace Qtde         with Qtde + nQtde
          replace UltE         with date()
          dbunlock ()
        endif  
      endif
        
      select IEnOARQ
      dbskip ()
    enddo    
    
    select ReceARQ
    set order to 1
    for nJ := 1 to 9
      dbseek( cOrds + strzero( nJ, 2 ) + 'O', .f. )
      
      if found()
        if RegLock()
          dbdelete ()
          dbunlock ()
        endif
      endif    
    next
    select EnOSARQ
  endif
return NIL

//
// Entra o estoque
//
function GravEnOS()
  
  set deleted off   
    
  select( cEnOSTMP )
  set order to 1 
  dbgotop ()
  do while !eof ()
    if empty( Prod )
      dbskip ()
      loop
    endif  
    
    nRegi := Regi
    lLixo := Lixo
    
    if Novo
      if Lixo
        dbskip ()
        loop
      endif  
    
      select IEnOARQ
      if AdiReg()
        if RegLock()
          replace OrdS       with cOrdS
          replace Sequ       with &cEnOSTMP->Sequ
          replace Prod       with &cEnOSTMP->Prod
          replace Produto    with &cEnOSTMP->Produto
          replace Qtde       with &cEnOSTMP->Qtde
          replace PrecoVenda with &cEnOSTMP->PrecoVenda
          replace PrecoCusto with &cEnOSTMP->PrecoCusto
          replace Unidade    with &cEnOSTMP->Unidade   
          dbunlock ()
        endif
      endif   

      select ProdARQ
      set order to 1
      dbseek( &cEnOSTMP->Prod, .f. )
      if found ()
        if RegLock()
          replace Qtde         with Qtde - &cEnOSTMP->Qtde
          replace UltS         with dTerm
          dbunlock ()
        endif
      endif
    else 
      select IEnOARQ
      go nRegi

      cPrAnt := Prod
      nQtAnt := Qtde
      
      if RegLock()
        replace Prod          with &cEnOSTMP->Prod
        replace Produto       with &cEnOSTMP->Produto
        replace PrecoVenda    with &cEnOSTMP->PrecoVenda
        replace PrecoCusto    with &cEnOSTMP->PrecoCusto
        replace Unidade       with &cEnOSTMP->Unidade   
        replace Qtde          with &cEnOSTMP->Qtde
        dbunlock ()
      endif  

      select ProdARQ
      set order to 1
      dbseek( cPrAnt, .f. )
      if found ()
        if RegLock()
          replace Qtde         with Qtde + nQtAnt
          replace UltA         with dTerm
          replace UltE         with dTerm
          dbunlock ()
        endif
      endif

      if !lLixo
        dbseek( &cEnOSTMP->Prod, .f. )
        if found ()
          if RegLock()
            replace Qtde         with Qtde - &cEnOSTMP->Qtde
            replace UltA         with dTerm
            replace UltE         with dTerm
            dbunlock ()
          endif
        endif
      endif
          
      select IEnOARQ
      
      if lLixo
        if RegLock()
          dbdelete ()
          dbunlock ()
        endif
      endif
    endif 
      
    select( cEnOSTMP )
    dbskip ()
  enddo  
   
  set deleted on

    select ReceARQ
    set order to 1
    for nL := 1 to 9
      cParc   := str( nL, 1 )
      cParce  := strzero( nL, 2 )
      cOrdSPg := cOrdS + cParce

      dbseek( cOrdSPg + 'O', .f. )
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
              replace Nota  with cOrdSPg
              replace Tipo  with 'O'
              dbunlock ()
            endif
          endif  
        endif
        if RegLock()
          replace Clie     with cClie
          replace Cliente  with AbOSARQ->Cliente
          replace Emis     with dTerm
          replace Vcto     with dVcto&cParc
          replace Valor    with nValor&cParc
          replace Acre     with EmprARQ->Taxa 
          if dVcto&cParc == dTerm
            replace Pgto   with dVcto&cParc
            replace Pago   with nValor&cParc
          else
            replace Pgto   with ctod('  /  /  ')  
            replace Pago   with 0
            replace Juro   with 0
          endif  
          replace Repr     with cRepr
          replace Port     with cPort
          replace ReprComi with nComis&cParc
          dbunlock ()
        endif
      endif
        
      if dTerm == dVcto&cParc .and. EmprARQ->Caixa == "X"
        dPgto := date()
        nPago := nValor&cParc
        cHist := cObse
        cNota := cOrdS
        
        DestLcto ()           
      endif
    next  
return NIL

//
// Relatorio das Ordem de Servico Encerradas
//
function PrinEnOS ( lTipo )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()
  
  tPrt := savescreen( 00, 00, 23, 79 )

  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )
  
    rOpenProd := .t.
  
    #ifdef DBF_NTX
      set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
    #endif
  else
    rOpenProd := .f.  
  endif

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )
   
    rOpenClie := .t.
   
    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
    #endif
  else
    rOpenClie := .f.  
  endif

  if NetUse( "ReprARQ", .t. )
    VerifIND( "ReprARQ" )
   
    rOpenRepr := .t.
   
    #ifdef DBF_NTX
      set index to ReprIND1, ReprIND2
    #endif
  else
    rOpenClie := .f.  
  endif

  if NetUse( "EnOSARQ", .t. )
    VerifIND( "EnOSARQ" )
  
    rOpenEnOS := .t.
  
    #ifdef DBF_NTX
      set index to EnOSIND1, EnOSIND2, EnOSIND3
    #endif
  else
    rOpenEnOS := .f.  
  endif

  if NetUse( "AbOSARQ", .t. )
    VerifIND( "AbOSARQ" )
  
    rOpenAbOS := .t.
  
    #ifdef DBF_NTX
      set index to AbOSIND1
    #endif
  else
    rOpenAbOS := .f.  
  endif

  if NetUse( "IEnOARQ", .t. )
    VerifIND( "IEnOARQ" )
  
    rOpenIEnO := .t.
   
    #ifdef DBF_NTX
      set index to IEnOIND1
    #endif
  else
    rOpenIEnO := .f.  
  endif

  Janela( 07, 12, 17, 67, mensagem( 'Janela', 'PrinEnOS', .f. ), .f. ) 

  setcolor( CorJanel + ',' + CorCampo )
  @ 09,14 say '    O.S. Inicial               O.S. Final'
  @ 10,14 say ' Cliente Inicial            Cliente Final'          
  @ 11,14 say ' Emissão Inicial            Emissão Final'  
  @ 12,14 say ' Término Inicial            Término Final'  
  @ 13,14 say 'Emitente Inicial           Emitente Final'          
  
  @ 15,14 say '      Prioridade '
  @ 16,14 say '       Relatório '
 
  setcolor( 'n/w+')
  @ 15,44 say chr(25)

  setcolor( CorCampo )
  @ 15,31 say ' Todas      '
  @ 16,31 say ' Quantitativo '
  @ 16,46 say ' Discriminado '
  
  setcolor( CorAltKC )
  @ 15,32 say 'T'
  @ 16,32 say 'Q'
  @ 16,47 say 'D'
  
  select ReprARQ
  set order to 1
  dbgotop ()
  nReprIni := val( Repr )
  dbgobottom()
  nReprFin := val( Repr )

  select ClieARQ
  set order to 1
  dbgotop ()
  nClieIni := val( Clie )
  dbgobottom()
  nClieFin := val( Clie )
  
  select AbOSARQ
  set order to 1
  dbgotop ()
  nOrdSIni := val( OrdS )  
  dEmisIni := ctod('01/01/1990')
  dTermIni := ctod('01/01/1990')
  dbgobottom ()
  nOrdSFin := val( OrdS )  
  dEmisFin := ctod('31/12/2015')
  dTermFin := ctod('31/12/2015')

  nPrio    := 6
  nTipo    := 1
  aOpc     := {}
  aTip     := {}

  aadd( aOpc, { ' Normal     ', 2, 'N', 15, 31, "Ordem de Serviço Normal." } )
  aadd( aOpc, { ' Eventual   ', 2, 'E', 15, 31, "Ordem de Serviço Eventual." } )
  aadd( aOpc, { ' Preventiva ', 2, 'P', 15, 31, "Ordem de Serviço Preventiva." } )
  aadd( aOpc, { ' Urgente    ', 2, 'U', 15, 31, "Ordem de Serviço Urgente." } )
  aadd( aOpc, { ' Garantia   ', 2, 'G', 15, 31, "Ordem de Serviço Garantia." } )
  aadd( aOpc, { ' Todas      ', 2, 'T', 15, 31, "Todas as Ordem de Serviço." } )

  aadd( aTip, { ' Quantitativo ', 2, 'Q', 16, 31, "Relatório Quantitativo." } )
  aadd( aTip, { ' Discriminado ', 2, 'D', 16, 46, "Relatório Discriminado." } )
    
  @ 09,31 get nOrdSIni             pict '999999'
  @ 09,56 get nOrdSFin             pict '999999'   valid nOrdSFin >= nOrdSIni
  @ 10,31 get nClieIni             pict '999999'   valid ValidClie( 99, 99, "ClieARQ", "nClieIni" )
  @ 10,56 get nClieFin             pict '999999'   valid ValidClie( 99, 99, "ClieARQ", "nClieFin" ) .and. nClieFin >= nClieIni 
  @ 11,31 get dEmisIni             pict '99/99/9999'
  @ 11,56 get dEmisFin             pict '99/99/9999' valid dEmisFin >= dEmisIni
  @ 12,31 get dTermIni             pict '99/99/9999'
  @ 12,56 get dTermFin             pict '99/99/9999' valid dTermFin >= dTermIni
  @ 13,31 get nReprIni             pict '999999'   valid ValidARQ( 99, 99, "ReprARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprIni", .t., 6, "Consulta dos Vendedores", "ReprARQ", 40 )   
  @ 13,56 get nReprFin             pict '999999'   valid ValidARQ( 99, 99, "ReprARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprFin", .t., 6, "Consulta dos Vendedores", "ReprARQ", 40 ) .and. nReprFin >= nReprIni 
  read
  
  if lastkey () == K_ESC
    select EnOSARQ
    close
    select ReprARQ
    close
    select ClieARQ
    close
    select IEnOARQ
    close
    select AbOSARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif  
  
  nPrio := HCHOICE( aOpc, 6, nPrio )
  
  if lastkey () == K_ESC
    select EnOSARQ
    close
    select ReprARQ
    close
    select ClieARQ
    close
    select IEnOARQ
    close
    select AbOSARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif  

  nTipo := HCHOICE( aTip, 2, nTipo )
  
  if lastkey () == K_ESC
    select EnOSARQ
    close
    select ReprARQ
    close
    select ClieARQ
    close
    select IEnOARQ
    close
    select AbOSARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif  

  Aguarde ()  

  nPag     := 1
  nLin     := 0
  cArqu2   := cArqu2 + "." + strzero( nPag, 3 )

  cOrdSIni := strzero( nOrdSIni, 6 )
  cOrdSFin := strzero( nOrdSFin, 6 )
  cReprIni := strzero( nReprIni, 6 )
  cReprFin := strzero( nReprFin, 6 )
  cClieIni := strzero( nClieIni, 6 )
  cClieFin := strzero( nClieFin, 6 )
  cReprAnt := space(06)
  nNormal  := nEventual := nPreventiva := nUrgente := nGarantia := 0
  lInicio  := .t.

  do case 
    case nPrio == 1;      cPrio := 'N'
    case nPrio == 2;      cPrio := 'E'
    case nPrio == 3;      cPrio := 'P'
    case nPrio == 4;      cPrio := 'U'
    case nPrio == 5;      cPrio := 'G'
    case nPrio == 6;      cPrio := 'T'
  endcase                   

  if nTipo == 2
    select AbOSARQ
    set order    to 1
    set relation to Repr into ReprARQ, to Clie into ClieARQ
    dbseek( cOrdSIni, .t. )
    do while OrdS >= cOrdSIni .and. OrdS <= cOrdSFin .and. !eof()
      if Clie       >= cClieIni .and. Clie        <= cClieFin .and.;
        val( Repr ) >= nReprIni .and. val( Repr ) <= nReprFin .and.;
        Emis        >= dEmisIni .and. Emis        <= dEmisFin .and.;
        Term        >= dTermIni .and. Term        <= dTermFin
         
        if cPrio != 'T'
          if cPrio != Prio
            dbskip()
            loop
          endif
        endif
        
        if lInicio 
          set printer to ( cArqu2 )
          set device  to printer
          set printer on
          
          lInicio := .f.
        endif
          
        if nLin == 0
          Cabecalho( 'Ordem de Servico - Encerrada', 132, 3 )
          CabEnOS(nTipo)
        endif
      
      if cReprAnt != Repr
        if cReprAnt != space(04)
          nLin ++
          @ nLin,006 say 'Total OS'
          @ nLin,015 say strzero( nNormal + nEventual + nPreventiva + nUrgente + nGarantia, 3 )  
          @ nLin,023 say strzero( nNormal, 3 ) + ' Normal '
          @ nLin,035 say strzero( nEventual, 3 ) + ' Eventual '
          @ nLin,049 say strzero( nPreventiva, 3 ) + ' Preventiva '
          @ nLin,066 say strzero( nUrgente, 3 ) + ' Urgente '
          @ nLin,079 say strzero( nGarantia, 3 ) + ' Garantia '        

          nLin     += 2
          nNormal  := nEventual := nPreventiva := nUrgente := nGarantia := 0
    
          if nLin >= pLimite
            Rodape(132) 

            cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
            cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

            set printer to ( cArqu2 )
            set printer on
         
            Cabecalho( 'Ordem de Servico - Encerrada', 132, 3 )
            CabEnOS(nTipo)
          endif  
        endif
        
        cReprAnt := Repr
        
        @ nLin,001 say Repr           pict '999999'
        @ nLin,008 say ReprARQ->Nome
        nLin ++
      endif  
      
        @ nLin,006 say OrdS                 pict '999999'
        do case
          case Prio == 'N';             nNormal ++
            @ nLin,013 say 'Normal'
          case Prio == 'E';             nEventual ++
            @ nLin,013 say 'Eventual'
          case Prio == 'P';             nPreventiva ++
            @ nLin,013 say 'Preventiva'
          case Prio == 'U';             nUrgente ++
            @ nLin,013 say 'Urgente'
          case Prio == 'G';             nGarantia ++
            @ nLin,013 say 'Garantia'
        endcase    
       
        @ nLin,024 say Emis                 pict '99/99/9999' 
        @ nLin,035 say HoraEmis             pict '99:99'
        if Clie == '999999'
          @ nLin,043 say ClieARQ            pict '@S16'
        else
          @ nLin,043 say ClieARQ->Nome      pict '@S16'
        endif  
        @ nLin,058 say Clie                 pict '999999'
        do case
          case EmprARQ->TipoOS == 1 .or. EmprARQ->TipoOS == 3
            @ nLin,065 say Apa1                                      pict '@S25' 
          case EmprARQ->TipoOS == 2
            @ nLin,065 say alltrim( Veic ) + ' ' + alltrim( Placa )  pict '@S25' 
        endcase     
        
        lVez := .t.
        
        select IEnOARQ
        set order    to 1
        set relation to Prod into ProdARQ
        dbseek( AbOSARQ->OrdS, .t. )
        do while OrdS == AbOSARQ->OrdS .and. !eof ()
          if Prod == '999999'
            @ nLin,091 say memoline( Produto, 17, 1 )
          else  
            @ nLin,091 say ProdARQ->Nome            pict '@S17'
          endif
          @ nLin,109 say Prod                       pict '999999' 
          if lVez
            @ nLin,116 say AbOSARQ->Term            pict '99/99/9999' 
            @ nLin,127 say AbOSARQ->HoraEmis        pict '99:99'

            lVez := .f.
          endif  
          nLin ++

          if nLin >= pLimite
            Rodape(132) 

            cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
            cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

            set printer to ( cArqu2 )
            set printer on

            Cabecalho( 'Ordem de Servico - Encerrada', 132, 3 )
            CabEnOS(nTipo)
            
            select AbOSARQ
        
            @ nLin,001 say Repr                 pict '999999'
            @ nLin,008 say ReprARQ->Nome
            nLin ++
            @ nLin,006 say OrdS                 pict '999999'
            do case
              case Prio == 'N';                 nNormal ++
                @ nLin,013 say 'Normal'
              case Prio == 'E';         nEventual ++
                @ nLin,013 say 'Eventual'
              case Prio == 'P';         nPreventiva ++
                @ nLin,013 say 'Preventiva'
              case Prio == 'U';         nUrgente ++
                @ nLin,013 say 'Urgente'
              case Prio == 'G';         nGarantia ++
                @ nLin,013 say 'Garantia'
            endcase    
       
            @ nLin,024 say Emis                 pict '99/99/9999' 
            @ nLin,033 say HoraEmis             pict '99:99'
            @ nLin,039 say ClieARQ->Nome        pict '@S18'
            @ nLin,058 say Clie                 pict '999999'
            do case
              case EmprARQ->TipoOS == 1 .or. EmprARQ->TipoOS == 3
                @ nLin,065 say Apa1                                      pict '@S25' 
              case EmprARQ->TipoOS == 2
                @ nLin,065 say alltrim( Veic ) + ' ' + alltrim( Placa )  pict '@S25' 
            endcase
            
            lVez := .t.
            select IEnOARQ     
          endif
          dbskip ()
        enddo  
        
        select AbOSARQ
                                  
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
  
    dbgotop ()
  
    if !lInicio
      nLin ++
      @ nLin,006 say 'Total OS'
      @ nLin,015 say strzero( nNormal + nEventual + nPreventiva + nUrgente + nGarantia, 3 )  
      @ nLin,023 say strzero( nNormal, 3 ) + ' Normal '
      @ nLin,035 say strzero( nEventual, 3 ) + ' Eventual '
      @ nLin,049 say strzero( nPreventiva, 3 ) + ' Preventiva '
      @ nLin,066 say strzero( nUrgente, 3 ) + ' Urgente '
      @ nLin,079 say strzero( nGarantia, 3 ) + ' Garantia '
 
      Rodape(132)
    endif  
  else
    aVendedor   := {}
    nNormal     := 0
    nEventual   := 0
    nPreventiva := 0
    nUrgente    := 0
    nGarantia   := 0
  
    select ReprARQ
    set order to 1
    dbseek( cReprIni, .t. )
    do while Repr >= cReprIni .and. Repr <= cReprFin .and. !eof ()
      aadd( aVendedor, { Repr, Nome, 0, 0, 0, 0, 0 } )
      dbskip ()
    enddo
    
    select AbOSARQ  
    set order to 1
    dbseek( cOrdSIni, .t. )
    do while OrdS >= cOrdSIni .and. OrdS <= cOrdSFin .and. !eof()
      if Clie       >= cClieIni .and. Clie        <= cClieFin .and.;
        val( Repr ) >= nReprIni .and. val( Repr ) <= nReprFin .and.;
        Emis        >= dEmisIni .and. Emis        <= dEmisFin .and.;
        Term        >= dTermIni .and. Term        <= dTermFin
         
        if cPrio != 'T'
          if cPrio != Prio
            dbskip()
            loop
          endif
        endif

        nAchou := ascan( aVendedor, { |nElem| nElem[1] == Repr } )
      
        if nAchou > 0
          do case
            case Prio == 'N';            aVendedor[ nAchou, 3 ] ++
            case Prio == 'E';            aVendedor[ nAchou, 4 ] ++
            case Prio == 'P';            aVendedor[ nAchou, 5 ] ++
            case Prio == 'U';            aVendedor[ nAchou, 6 ] ++
            case Prio == 'G';            aVendedor[ nAchou, 7 ] ++
          endcase    
        endif 
      endif
      dbskip ()
    enddo
    
    for nH := 1 to len( aVendedor )
      if ( aVendedor[ nH, 3 ] + aVendedor[ nH, 4 ] + aVendedor[ nH, 5 ] +;
         aVendedor[ nH, 6 ] + aVendedor[ nH, 7 ] ) == 0
        loop
      endif
        
      if lInicio 
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
          
        lInicio := .f.
      endif
        
      if nLin == 0
        Cabecalho( 'Ordem de Servico - Encerrada', 132, 3 )
        CabEnOS(nTipo)
      endif

      @ nLin,001 say aVendedor[ nH, 1 ]            pict '999999'
      @ nLin,008 say aVendedor[ nH, 2 ]            
      @ nLin,051 say aVendedor[ nH, 3 ]            pict '999'
      @ nLin,061 say aVendedor[ nH, 4 ]            pict '999'
      @ nLin,073 say aVendedor[ nH, 5 ]            pict '999'
      @ nLin,082 say aVendedor[ nH, 6 ]            pict '999'
      @ nLin,092 say aVendedor[ nH, 7 ]            pict '999'
      @ nLin,098 say aVendedor[ nH, 3 ] + ;
                     aVendedor[ nH, 4 ] + ;
                     aVendedor[ nH, 5 ] + ;
                     aVendedor[ nH, 6 ] + ;
                     aVendedor[ nH, 7 ]            pict '9999'

      nLin        ++
      nNormal     += aVendedor[ nH, 3 ]               
      nEventual   += aVendedor[ nH, 4 ]               
      nPreventiva += aVendedor[ nH, 5 ]               
      nUrgente    += aVendedor[ nH, 6 ]               
      nGarantia   += aVendedor[ nH, 7 ]               
                     
      if nLin >= pLimite
        Rodape(132) 

        cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
        cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

        set printer to ( cArqu2 )
        set printer on
      endif
    next

    if !lInicio
      nLin ++
      @ nLin,006 say 'Total OS'
      @ nLin,015 say strzero( nNormal + nEventual + nPreventiva + nUrgente + nGarantia, 3 )  
      @ nLin,023 say strzero( nNormal, 3 ) + ' Normal '
      @ nLin,035 say strzero( nEventual, 3 ) + ' Eventual '
      @ nLin,049 say strzero( nPreventiva, 3 ) + ' Preventiva '
      @ nLin,066 say strzero( nUrgente, 3 ) + ' Urgente '
      @ nLin,079 say strzero( nGarantia, 3 ) + ' Garantia '

      Rodape(132)
    endif  
  endif  
 
  set printer to
  set printer off
  set device  to screen
    
  if Imprimir( cArqu3, 132 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      if nTipo == 1
        replace Titu     with "Relatório das Ordem Serviço Encerradas - Quantitativo"
      else  
        replace Titu     with "Relatório das Ordem Serviço Encerradas - Discriminado"
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

  select EnOSARQ
  close
  select ClieARQ
  close
  select IEnOARQ
  close
  select ReprARQ
  close
  select AbOSARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabEnOS (nTipo)
  @ 02,01 say 'Emissão ' + dtoc( dEmisIni ) + ' a ' + dtoc( dEmisFin )
  @ 02,41 say 'T‚rmino ' + dtoc( dTermIni ) + ' a ' + dtoc( dTermFin )
  if nTipo == 2
    @ 03,01 say 'Emitente'
    do case
      case EmprARQ->TipoOS == 1
        @ 04,01 say '     O.S.   Prioridade Emissão    Hora  Cliente                 Equipamento               Produto                  Entrega    Hora'
      case EmprARQ->TipoOS == 2
        @ 04,01 say '     O.S.   Prioridade Emissão    Hora  Cliente                 Veiculo - Placa           Produto                  Entrega    Hora'
      case EmprARQ->TipoOS == 3
        @ 04,01 say '     O.S.   Prioridade Emissão    Hora  Cliente                 Descricao                 Produto                  Entrega    Hora'
    endcase    

    nLin     := 6
    cReprAnt := space(04)
  else
    @ 03,01 say 'Cod Nome                                      Normal  Eventual  Preventiva  Urgente  Garantia  Total'  
    
    nLin := 5
  endif  
return NIL

//
// Imprimir Encerramento da Ordem de Serviço
//
function ImprEnOS ()
  Janela( 11, 22, 14, 49, mensagem( 'Janela', 'Imprimir', .f. ), .f. )
  Mensagem( 'EnOS','ImprEnOS')
  setcolor( CorJanel )
    
  aOpc := {}
  nPrn := 0

  aadd( aOpc, { ' Impressora ', 2, 'I', 13, 25, "Imprimir Orçamento para impressora." } )
  aadd( aOpc, { ' Arquivo ',    2, 'A', 13, 38, "Gerar arquivo texto da impressão do Orçamento." } )
    
  nTipoEnOS := HCHOICE( aOpc, 2, 1 )

  if nTipoEnOS == 2
      Janela( 05, 21, 08, 56, mensagem( 'Janela', 'Salvar', .f. ), .f. )
      Mensagem( 'LEVE','Salvar')

      cArqu2  := CriaTemp( 5 )
      xArqu3  := right ( cArqu2, 8 )
  
      cArqTxt := cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() + alltrim( xArqu3 ) + space(40)
        
      keyboard( chr( K_END ) )

      setcolor ( CorJanel + ',' + CorCampo )
   
      @ 07,23 get cArqTxt           pict '@S32' 
      read
    
      if lastkey() == K_ESC
        return NIL
      endif  
  
      set printer to ( cArqTxt )
      set device  to printer
      set printer on
  endif    

    
  if nTipoEnOS == 1
    if EmprARQ->Impr == "X"
      if !TestPrint(1)
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
  
      nTipoEnOS := 2
    endif  
  endif    
  
  cData := alltrim( EmprARQ->Cida ) + '(' + EmprARQ->UF + '), ' +;
           strzero( day( date() ), 2 ) + ' de ' + alltrim( aMesExt[ month( date() ) ] ) +;
           ' de' + str( year( date() ) )  

  for nJ := 1 to EmprARQ->CopiaOS  
    select ClieARQ
    set order to 1
    dbseek( cClie, .f. )

    select EnOSARQ
    set order to 1 

    nLin  := 0
    
    
    if nTipoEnOS == 1
      setprc( 0, 0 )
      @ nLin, 00 say chr(27) + "@"
      @ nLin, 00 say chr(18)
      @ nLin, 00 say chr(27) + chr(67) + chr(33)
    endif  
    
    @ nLin,01 say '+-----------------------------------------------------------------------------+'
    nLin ++
    @ nLin,01 say '| '
    @ nLin,03 say EmprARQ->Razao
    @ nLin,60 say 'O.S. N.'
    @ nLin,68 say cOrdS                            pict '999999'
    @ nLin,79 say '|'
    nLin ++
    @ nLin,01 say '| '
    @ nLin,03 say alltrim( EmprARQ->Ende ) + ' - ' +;
                  alltrim( EmprARQ->Bairro ) + ' - ' +;
                  alltrim( EmprARQ->Cida ) + ' - ' +; 
                  EmprARQ->UF                      pict '@S58'
    @ nLin,60 say 'Emissão ' + dtoc( dEmis ) + ' |'
    nLin ++
    @ nLin,01 say '|'
    @ nLin,03 say EmprARQ->Fone                    
    @ nLin,23 say EmprARQ->Fax                     
    @ nLin,63 say 'Hora ' + cHoraEmis + '      |'
    nLin ++
    @ nLin,01 say '+-----------------------------------------------------------------------------+'
    nLin ++
    @ nLin,01 say '|  Cliente '
    if cClie == '999999'
      @ nLin,12 say cCliente
    else  
      @ nLin,12 say ClieARQ->Nome 
    endif  
    @ nLin,57 say 'Codigo'
    @ nLin,64 say cClie                              pict '999999'
    @ nLin,79 say '|'
    nLin ++
    @ nLin,01 say '| Endereço '
    @ nLin,12 say ClieARQ->Ende
    @ nLin,60 say 'CEP'
    @ nLin,64 say ClieARQ->CEP                       pict '99999-999'
    @ nLin,79 say '|'
    nLin ++
    @ nLin,01 say '|   Bairro '
    @ nLin,12 say ClieARQ->Bair                     pict '@S20' 
    @ nLin,34 say 'Cidade'
    @ nLin,41 say ClieARQ->Cida                     pict '@S15'
    @ nLin,59 say 'Fone'
    @ nLin,64 say ClieARQ->Fone                     pict '@S12'
    @ nLin,79 say '|'
    nLin ++
    @ nLin,01 say '+-----------------------------------------------------------------------------+'
    nLin ++
    do case
      case EmprARQ->TipoOS == 1
        @ nLin,01 say '| Equipamento'
        @ nLin,15 say AbOSARQ->Apa1                              
        @ nLin,79 say '|'
      case EmprARQ->TipoOS == 2
        @ nLin,01 say '|     Veiculo '
        @ nLin,15 say AbOSARQ->Veic
        @ nLin,39 say 'Placa'
        @ nLin,45 say AbOSARQ->Placa
        @ nLin,62 say 'KM'
        @ nLin,65 say AbOSARQ->KM           pict '@E 99999,999.9'
        @ nLin,79 say '|'
      case EmprARQ->TipoOS == 3
        @ nLin,01 say '|   Descrição'
        @ nLin,15 say AbOSARQ->Apa1                              
        @ nLin,79 say '|'
    endcase    
    nLin ++
    @ nLin,01 say '|  Observação'
    @ nLin,15 say cObse                              pict '@S38'
    @ nLin,54 say 'T‚rmino'
    @ nLin,62 say dTerm                              pict '99/99/9999'
    @ nLin,73 say cHoraTerm                          pict '99:99'
    @ nLin,79 say '|'
    nLin ++
    @ nLin,01 say '+------+---------------------------------------------+-----------+------------+'
    nLin ++
    @ nLin,01 say '| Qtde.|Produto/Serviço                          Cod|   P. Venda| Valor Total|'

    nLin   ++
    nItens := 0
    
    select IEnOARQ
    set order    to 1
    set relation to Prod into ProdARQ
    dbseek( cOrdS, .t. )
    do while OrdS == cOrdS .and. !eof()
      @ nLin,01 say '|'
      if EmprARQ->Inteira == "X"
        @ nLin,02 say Qtde                pict '@E 999999'
      else      
        @ nLin,02 say Qtde                pict '@E 9999.9'
      endif     
      @ nLin,08 say '|'
      if Prod == '999999'
        @ nLin,09 say memoline( Produto, 38, 1 )
      else      
        @ nLin,09 say ProdARQ->Nome     pict '@S38'
      endif     
      @ nLin,48 say Prod                pict '999999' 
      @ nLin,54 say '|'
      @ nLin,56 say PrecoVenda          pict PictPreco(10)
      @ nLin,66 say '|'
      @ nLin,69 say PrecoVenda * Qtde   pict '@E 999,999.99'
      @ nLin,79 say '|'

      nLin   ++
      nItens ++
    
      if nItens > 10
        exit
      endif
    
      dbskip ()
    enddo
    
    select EnOSARQ
    
    if Desconto > 0
      @ nLin,01 say '|' 
      @ nLin,08 say '|DESCONTO' 
      @ nLin,54 say '|' 
      @ nLin,66 say '|' 
      @ nLin,69 say Desconto            pict '@E 999,999.99'
      @ nLin,79 say '|' 
      nLin ++
      nItens ++ 
    endif 
  
    if nItens < 10
      for nH := 1 to ( 10 - nItens )
        @ nLin,01 say '|' 
        @ nLin,08 say '|' 
        @ nLin,54 say '|' 
        @ nLin,66 say '|' 
        @ nLin,79 say '|' 
        nLin ++
      next
    endif

    @ nLin,01 say '+------+---------------------------------------------+-----------+------------+'
    nLin ++ 
    @ nLin,01 say '| Assinatura:                                  Valor Total da O.S'
    @ nLin,69 say TotalNota - Desconto       pict '@E 999,999.99'
    @ nLin,79 say '|'
    nLin ++ 
    @ nLin,01 say '+-----------------------------------------------------------------------------+'
    nLin ++
    @ nLin,01 say '| Cond. Pgto.'
    if !empty( Vcto1 )
      @ nLin,15 say Vcto1                 pict '99/99/9999'
      @ nLin,24 say Valor1                pict '@E 999,999.99'
    endif  
    if !empty( Vcto2 )
      @ nLin,36 say Vcto2                 pict '99/99/9999'
      @ nLin,45 say Valor2                pict '@E 999,999.99'
    endif  
    if !empty( Vcto3 )
      @ nLin,57 say Vcto3                 pict '99/99/9999'
      @ nLin,66 say Valor3                pict '@E 999,999.99'
    endif  
    @ nLin,79 say '|'
    nLin ++ 
    @ nLin,01 say '|'
    if !empty( Vcto4 )
      @ nLin,15 say Vcto4                 pict '99/99/9999'
      @ nLin,24 say Valor4                pict '@E 999,999.99'
    endif  
    if !empty( Vcto5 )
      @ nLin,36 say Vcto5                 pict '99/99/9999'
      @ nLin,45 say Valor5                pict '@E 999,999.99'
    endif  
    if !empty( Vcto6 )
      @ nLin,57 say Vcto6                 pict '99/99/9999'
      @ nLin,66 say Valor6                pict '@E 999,999.99'
    endif  
    @ nLin,79 say '|'
    nLin ++
    @ nLin,01 say '|'
    @ nLin,79 say '|'
    nLin ++
    @ nLin,01 say '| ' + alltrim( EmprARQ->Mensagem )
    @ nLin,79 say '|'
    nLin ++ 
    @ nLin,01 say '+-----------------------------------------------------------------------------+'
    nLin += 3
    
    if nTipoEnOS == 1
      @ nLin, 00 say chr(27) + "@"
    endif  
  next  

  set printer to
  set printer off
  set device  to screen
  
  if !empty( GetDefaultPrinter() ) .and. nPrn > 0
    PrnTest(aPrn[nPrn], memoread( cArqTxt ), .f. )
  endif
 
 return NIL