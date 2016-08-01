//  Leve, Ordem de Produção
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

function OrdP()

if NetUse( "OrdPARQ", .t. )
  VerifIND( "OrdPARQ" )
  
  hOpenOrdP := .t.

  #ifdef DBF_NTX
    set index to OrdPIND1
  #endif 
else
  hOpenOrdP := .f.
endif

if NetUse( "CoPrARQ", .t. )
  VerifIND( "CoPrARQ" )
  
  hOpenComp := .t.

  #ifdef DBF_NTX
    set index to CoPrIND1
  #endif 
else
  hOpenComp := .f.
endif

if NetUse( "ICoPARQ", .t. )
  VerifIND( "ICoPARQ" )
  
  hOpenICom := .t.
  
  #ifdef DBF_NTX
    set index to ICoPIND1
  #endif 
else
  hOpenIOPr := .f.  
endif

if NetUse( "ProdARQ", .t. )
  VerifIND( "ProdARQ" )

  hOpenProd := .t.
  
  #ifdef DBF_NTX
    set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
  #endif 
else  
  hOpenProd := .f.
endif

//  Variaveis de Entrada
cOrdP := cComp := space(06)
nOrdP := nComp := 0
nQtde := nProd := 0
cLote := space(10)
cProd := space(04)
dFabr := dSaid := dEntr := dData := date ()
cObse := space(60)

//  Tela OrdP
Janela ( 04, 14, 18, 65, mensagem( 'Janela', 'OrdP', .f. ), .t. )

setcolor ( CorJanel + ',' + CorCampo )
@ 06,16 say '  Ordem N.                     Data '
                 
@ 08,16 say '   Produto'                                      
@ 09,16 say 'Composição               Quantidade'                
@ 10,16 say '      Lote'
               
@ 12,16 say 'Fabricação                    Saída '
@ 13,16 say '   Entrada '
                  
@ 15,16 say 'Observação '

MostOpcao( 17, 16, 28, 41, 54 ) 
tOrdP := savescreen( 00, 00, 23, 79 )

select OrdPARQ
set order to 1
if hOpenOrdP
  dbgobottom ()
endif  
do while .t.
  Mensagem('OrdP','Janela')
  
  restscreen( 00, 00, 23, 79, tOrdP )
  cStat := space(4)

  select OrdPARQ
  set order to 1

  MostOrdP()
  
  if Demo ()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostOrdP'
  cAjuda   := 'OrdP'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()

  @ 06,27 get nOrdP              pict '999999'
  read
  
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. nOrdP == 0
    exit
  endif
  
  setcolor ( CorCampo )
  cOrdP := strzero( nOrdP, 6 )

  @ 06,27 say cOrdP
  
  //  Verificar existencia do Lancamento para Incluir ou Alterar
  select OrdPARQ
  set order to 1
  dbseek( cOrdP, .f. )
  if eof()
    Alerta( mensagem( 'Alerta', 'OrdPEof', .f. ) )
    loop
  else
    if empty( Entr )
      Mensagem ('OrdP','incl')
      cStat := 'incl'
    else
      Alerta( mensagem( 'Alerta', 'OrdPOff', .f. ) )
      cStat := 'alte'
    endif  
  endif
  
  MostOrdP ()
  EntrOrdP ()

  Confirmar( 17, 16, 28, 41, 54, 3 ) 

  if cStat == 'excl'
    EstoOrdP ()
  endif

  if cStat == 'prin'

  endif  
    
  if cStat == 'incl'
    if RegLock(0)
      replace Entr         with dEntr
      replace Obse         with cObse
      dbunlock ()
    endif

    select CoPrARQ
    set order to 1
    dbseek( cComp, .f. )
    
    if found ()
      cProd := CoPrARQ->Prod
    else
      loop
    endif    
    
    select ProdARQ 
    set order to 1
    dbseek( cProd, .f. )
    if found ()
      if RegLock ()
        replace Qtde        with Qtde + nQtde
        replace UltE        with date()
        dbunlock ()
      endif
    endif    
    
    select ICoPARQ
    set order    to 1
    set relation to Prod into ProdARQ
    dbseek( cComp, .t. )
    do while Nota == cComp
      cProd := Prod

      if Qtde == 0
        nQtde := ( ( OrdPARQ->Qtde * Perc ) / 100 )
      else
        nQtde := ( OrdPARQ->Qtde * Qtde )
      endif      

      select ProdARQ 
      set order to 1
      dbseek( cProd, .f. )
      if found ()
        nNovo := Qtde - nQtde 
        
        if RegLock ()
          replace Qtde        with Qtde - nQtde
          replace UltS        with date()
          dbunlock ()
        endif
      endif    
       
      select ICoPARQ
      dbskip ()
    enddo  
  endif  
enddo

if hOpenOrdP
  select OrdPARQ
  close 
endif

if hOpenComp
  select CoPrARQ
  close 
endif

if hOpenICom
  select ICoPARQ
  close
endif

if hOpenProd
  select ProdARQ
  close 
endif
return NIL

//  Funcao Entra Dados do Lançamento
function EntrOrdP ()
  setcolor ( CorJanel + ',' + CorCampo )
  @ 13,27 get dEntr                 pict '99/99/9999' valid dEntr >= dSaid
  @ 15,27 get cObse                 pict '@S30'
  read
return NIL

//  Funcao Mostra Dados do OrdP 
function MostOrdP ()

  if cStat != 'incl'
    cOrdP := OrdP
    nOrdP := val( Ordp )
  endif  

  dData := Data
  cComp := Comp
  nQtde := Qtde
  cLote := Lote
  dFabr := Fabr
  dSaid := Said
  dEntr := Entr
  cObse := Obse
  
  select CoPrARQ
  set order to 1
  dbseek( cComp, .f. )
  
  select OrdPARQ
      
  setcolor ( CorCampo )
  @ 06,52 say dData                 pict '99/99/9999'
  @ 08,27 say CoPrARQ->Prod
  @ 08,32 say CoPrARQ->Desc         pict '@S30'
  @ 09,27 say cComp                 pict '999999'
  if EmprARQ->Inteira == 'X'
    @ 09,52 say nQtde               pict '@E 99999999999'
  else  
    @ 09,52 say nQtde               pict '@E 999,999.999'
  endif  
  @ 10,27 say cLote                  
  @ 12,27 say dFabr                 pict '99/99/9999'
  @ 12,52 say dSaid                 pict '99/99/9999'
  @ 13,27 say dEntr                 pict '99/99/9999'
  @ 15,27 say cObse                 pict '@S30'
return NIL

//
// Excluir Ordem de Produção
//
function EstoOrdP ()
  cStat := 'loop' 
  tQtde := OrdPARQ->Qtde
  
  if ExclRegi ()
    select CoPrARQ
    set order to 1
    dbseek( cComp, .f. )
    
    if found ()
      cProd := CoPrARQ->Prod
    else
      return(.t.)
    endif    

    select ProdARQ 
    set order to 1
    dbseek( cProd, .f. )
    if found ()
      if RegLock ()
        replace Qtde        with Qtde - tQtde
        replace UltS        with date()
        dbunlock ()
      endif
    endif    
    
    select ICoPARQ
    set order    to 1
    set relation to Prod into ProdARQ
    dbseek( cComp, .t. )
    do while Nota == cComp .and. !eof()
      cProd := Prod
      if Qtde == 0
        nQtde := ( ( OrdPARQ->Qtde * Perc ) / 100 )
      else  
        nQtde := ( OrdPARQ->Qtde * Qtde )
      endif       
      select ProdARQ 
      set order to 1
      dbseek( cProd, .f. )
      if found ()
        if RegLock ()
          replace Qtde        with Qtde + nQtde
          replace UltE        with date()
          dbunlock ()
        endif
      endif    
       
      select ICoPARQ
      dbskip ()
    enddo  

  endif
return NIL

//
// Imprimir Composição
//
function PrinOrdP( lAbrir )

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
  else
    eOpenProd := .f.  
  endif
 
  if NetUse( "CoPrARQ", .t. )
    VerifIND( "CoPrARQ" )
    
    eOpenComp := .t.
   
    #ifdef DBF_NTX
      set index to CoPrIND1, CoPrIND2
    #endif 
  else
    eOpenOPro := .f.  
  endif
 
  if NetUse( "ICoPARQ", .t. )
    VerifIND( "ICoPARQ" )
  
    eOpenICom := .t.
  
    #ifdef DBF_NTX
      set index to ICoPIND1
    #endif 
  else
    eOpenIOPr := .f.  
  endif

  if NetUse( "OrdPARQ", .t. )
    VerifIND( "OrdPARQ" )
  
    hOpenOrdP := .t.

    #ifdef DBF_NTX
      set index to OrdPIND1
    #endif 
  else
    hOpenOrdP := .f.
  endif

  if NetUse( "LoteARQ", .t. )
    VerifIND( "LoteARQ" )
  
    hOpenLote := .t.

    #ifdef DBF_NTX
      set index to LoteIND1
    #endif 
  else
    hOpenLote := .f.
  endif


  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 08, 12, 14, 66, mensagem( 'Janela', 'PrinOrdP', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,14 say '     Composição             Quantidade '
  @ 11,14 say '           Lote                  Ordem'
                  
  @ 13,14 say 'Data Fabricação             Data Saída '
  
  select EmprARQ
  set order to 1
  dbseek( cEmpresa, .f. )
  nOrdem    := OrdP + 1

  select CoPrARQ
  set order to 1
  dbgobottom ()
  nCompIni  := val( Nota )
  nProducao := 0
  cLote     := space(10)
  dFabr     := date () 
  dSaid     := date ()

  @ 10,30 get nCompIni    pict '999999'         valid ValidComp ( nCompIni ) .and. CalcLote ( nCompIni )
  if EmprARQ->Inteira == "X"
    @ 10,53 get nProducao   pict '@E 99999999999' 
  else  
    @ 10,53 get nProducao   pict '@E 999,999.999' 
  endif  
  @ 11,30 get cLote                             valid !empty( cLote )
  @ 11,53 get nOrdem      pict '999999' 
  @ 13,30 get dFabr       pict '99/99/9999'
  @ 13,53 get dSaid       pict '99/99/9999'
  read

  if lastkey() == K_ESC 
    select ProdARQ
    close
    select CoPrARQ
    close
    select ICoPARQ
    close
    select OrdPARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  Aguarde ()

  nPag   := 1
  nLin   := 0
  cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

  cCompIni := strzero( nCompIni, 6 )
  aEstoque := {}

  select CoPrARQ
  set order  to 1
  dbseek( cCompIni, .f. )
  
  if eof ()
    select ProdARQ
    close
    select CoPrARQ
    close
    select ICoPARQ
    close
    select OrdPARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  aadd( aEstoque, 'Cod Descrição                     Estq. Disponivel  Estq. Requerido' )
  aadd( aEstoque, "   " )
  
  lBaixo := .f.

  select ICoPARQ
  set order    to 1
  set relation to Prod into ProdARQ
  dbseek( cCompIni + '01', .t. )
  
  do while Nota == cCompIni
    if Qtde == 0
      nQtde := ( ( nProducao * Perc ) / 100 )
    else  
      nQtde := ( nProducao * Qtde )
    endif
        
    if nQtde > ProdARQ->Qtde
      lBaixo := .t.
    endif  
    
    aadd( aEstoque, Prod + ' ' + left( ProdARQ->Nome, 30 ) +;
                    space(5) + iif( EmprARQ->Inteira == "X", transform( ProdARQ->Qtde, '@E 99999999999' ), transform( ProdARQ->Qtde, '@E 999,999.999' ) ) +;
                    space(6) + iif( EmprARQ->Inteira == "X", transform( nQtde, '@E 99999999999' ), transform( nQtde, '@E 999,999.999' ) ) )
    dbskip ()
  enddo 
  
  if lBaixo
    Janela( 06, 05, 15, 75, mensagem( 'Janela', 'OrdPEof', .f. ), .f. )
  else
    Janela( 06, 05, 15, 75, mensagem( 'Janela', 'PrinOrdP', .f. ), .f. )
  endif  
    
  setcolor( CorJanel + ',' + CorCampo )
    
  Choice := achoice( 08, 06, 14, 74, aEstoque )
    
  if lBaixo 
    select ProdARQ
    close
    select CoPrARQ
    close
    select ICoPARQ
    close
    select OrdPARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
   
  set printer to ( cArqu2 )
  set device  to printer
  set printer on
    
  Cabecalho( 'Ordem de Produção', 80, 2 )
  
  select CoPrARQ
  
  nLin  := 3
  cDesc := Desc
  
  @ nLin,001 say padc( 'Ordem de Produção N. ' + strzero( nOrdem, 6 ), 79 )
  nLin += 2
  @ nLin,003 say 'Produto ' + left( Desc, 30 )
  @ nLin,050 say 'Quantidade'
  if EmprARQ->Inteira == "X"
    @ nLin,061 say nProducao                pict '@E 99999999999'
  else  
    @ nLin,061 say nProducao                pict '@E 999,999.999'
  endif  
  nLin += 2
  @ nLin,003 say '   Lote ' + cLote
  nLin += 2
  @ nLin,003 say 'Mat‚ria Prima                              Qtde.            Estoque'
  nLin += 2 
  
  cNota := Nota
  
  select ICoPARQ
  set order    to 1
  set relation to Prod into ProdARQ
  dbseek( cNota, .t. )
  
  do while Nota == cNota
    nQtde := ( ( nProducao * Perc ) / 100 )
    cNome := ProdARQ->Nome
    cInic := ''
    
    for nK := 1 to len( cNome )
      cLetra := substr( cNome, nK, 1 )
      
      if nK == 1
        cInic += cLetra
      endif     
              
      if cLetra == ' '
        if substr( cNome, nK + 1, 1 ) != '('
          cInic += substr( cNome, nK + 1, 1 )
        endif  
        nK ++
      endif
    next        
  
    @ nLin,003 say alltrim( cInic ) + '-' + Prod
    if EmprARQ->Inteira == "X"
      @ nLin,043 say nQtde               pict '@E 999999999'
      @ nLin,060 say ProdARQ->Qtde       pict '@E 99999999999'
    else  
      @ nLin,043 say nQtde               pict '@E 9,999.999'
      @ nLin,060 say ProdARQ->Qtde       pict '@E 999,999.999'
    endif  
    nLin ++
    
    dbskip ()
  enddo  
    
  select CoPrARQ
  
  nLin ++
  @ nLin,003 say 'Procedimento'
  
  nLin  += 2
  nTama := mlcount( Hist, 50 )
  
  for nH := 1 to nTama
    @ nLin,003 say memoline( Hist, 50, nH )
    nLin ++
  next  
  nLin += 5
  @ nLin,003 say 'Data Saída ' + dtoc( dSaid )
  @ nLin,043 say 'Data Entrada ____/____/____'
  nLin += 4
  @ nLin,003 say '_______________________________'
  @ nLin,043 say '_______________________________'
  nLin ++
  @ nLin,003 say '          Responsavel          '
  @ nLin,043 say '            Produção           '

  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 80 )
    select SpooARQ
    set order to 1
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Relatório da Ordem Produção - " + cCompIni
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
  endif  
  
  select OrdPARQ
  set order to 1
  dbseek( strzero( nOrdem, 6 ), .f. )
  if found ()
    if RegLock(0)
      dbdelete ()
      dbunlock ()
    endif
  endif    
  
  if AdiReg()
    replace OrdP       with strzero( nOrdem, 6 )
    replace Data       with date ()
    replace Comp       with cNota
    replace Qtde       with nProducao
    replace Lote       with cLote
    replace Fabr       with dFabr
    replace Said       with dSaid
    dbunlock ()
  endif
  
  select EmprARQ
  if RegLock()
    replace OrdP           with nOrdem
    dbunlock ()
  endif    
  
  select CoPrARQ
  set order to 1
  dbseek( cNota, .f. )
  
  if found ()
    if RegLock()
      replace Lote        with cLote
      dbunlock ()
    endif
  endif
  
  select LoteARQ
  set order to 1
  if AdiReg()
    if RegLock()
      replace Comp      with cNota
      replace OrdP      with strzero( nOrdem, 6 )
      replace Lote      with cLote
      replace Desc      with cDesc
      replace Data      with date()
      replace Qtde      with nProducao
      dbunlock ()
    endif  
  endif

  select CoPrARQ
  close  
  select ProdARQ
  close
  select ICoPARQ
  close
  select OrdPARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

//
// Imprimir Custo do Produto
//
function PrinCusto( lAbrir )

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
  else
    eOpenProd := .f.  
  endif
 
  if NetUse( "CoPrARQ", .t. )
    VerifIND( "CoPrARQ" )
    
    eOpenComp := .t.
   
    #ifdef DBF_NTX
      set index to CoPrIND1, CoPrIND2
    #endif 
  else
    eOpenComp := .f.  
  endif
 
  if NetUse( "ICoPARQ", .t. )
    VerifIND( "ICoPARQ" )
  
    eOpenICom := .t.
  
    #ifdef DBF_NTX
      set index to ICoPIND1
    #endif 
  else
    eOpenICom := .f.  
  endif
 
  if NetUse( "ICusARQ", .t. )
    VerifIND( "ICusARQ" )
  
    eOpenICus := .t.
  
    #ifdef DBF_NTX
      set index to ICusIND1
    #endif 
  else
    eOpenICus := .f.  
  endif

  if NetUse( "OrdPARQ", .t. )
    VerifIND( "OrdPARQ" )
  
    hOpenOrdP := .t.

    #ifdef DBF_NTX
      set index to OrdPIND1
    #endif 
  else
    hOpenOrdP := .f.
  endif

  if NetUse( "CustARQ", .t. )
    VerifIND( "CustARQ" )

    #ifdef DBF_NTX
      set index to CustIND1, CustIND2
    #endif 
  endif


  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 08, 12, 11, 50, 'Custo Produto', .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,14 say '     Composição'

  select CoPrARQ
  set order to 1
  dbgobottom ()
  nCompIni  := val( Nota )

  @ 10,30 get nCompIni    pict '999999'         valid ValidComp ( nCompIni )
  read

  if lastkey() == K_ESC 
    select ProdARQ
    close
    select CoPrARQ
    close
    select ICoPARQ
    close
    select ICusARQ
    close
    select CustARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  Aguarde ()

  nPag   := 1
  nLin   := 0
  cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

  cCompIni := strzero( nCompIni, 6 )

  // Posiciona Primeiro Funcionario
  select CoPrARQ
  set order  to 1
  dbseek( cCompIni, .f. )
  
  cNota := Nota
  cProd := Prod
  
  if eof ()
    select SpooARQ
    close
    select ProdARQ
    close
    select CoPrARQ
    close
    select ICoPARQ
    close
    select ICusARQ
    close
    select CustARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  nLin        := 0
  cNota       := Nota
  nTotalCusto := nTotalVenda := 0
  
  lInicio     := .t.
  
  select ICoPARQ
  set order    to 1
  set relation to Prod into ProdARQ
  dbseek( cNota, .t. )
  do while Nota == cNota .and. !eof()
    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on

      lInicio := .f.
    endif  
  
    if nLin == 0
      Cabecalho( 'Custo do Produto', 132, 2 )
      CabCusto()
    endif  
    
    nPrecoCusto := ( ProdARQ->PrecoCusto * PerC ) / 100
    nPrecoVenda := ( ProdARQ->PrecoVenda * PerC ) / 100
    nTotalCusto += nPrecoCusto
    nTotalVenda += nPrecoVenda
    
    @ nLin,001 say Prod            pict '999999'
    @ nLin,008 say ProdARQ->Nome   pict '@S38'
    @ nLin,047 say PerC            pict '@E 999.99'
    @ nLin,056 say nPrecoCusto     pict PictPreco(14)
    @ nLin,075 say nPrecoVenda     pict PictPreco(14)
    nLin ++
    dbskip ()
  enddo
  
  lInicio := .t.

  select ICusARQ
  set order    to 1
  set relation to Cust into CustARQ
  dbseek( cNota, .t. )
  do while Nota == cNota .and. !eof()
    if lInicio
      nLin ++
      @ nLin,01 say 'Custos                                          Perc.     Preço Custo        Preço Venda'

      nLin    += 2
      lInicio := .f.
    endif  
  
    nPrecoCusto := ( PrecoCusto * PerC ) / 100
    nPrecoVenda := ( PrecoVenda * PerC ) / 100
    nTotalCusto += nPrecoCusto
    nTotalVenda += nPrecoVenda
    
    @ nLin,001 say Cust            pict '999999'
    @ nLin,008 say CustARQ->Nome   pict '@S38'
    @ nLin,047 say PerC            pict '@E 999.99'
    @ nLin,056 say nPrecoCusto     pict PictPreco(14)
    @ nLin,075 say nPrecoVenda     pict PictPreco(14)
    nLin ++
    dbskip ()
  enddo
  
  nLin ++
  @ nLin,039 say 'Total Produto'
  @ nLin,056 say nTotalCusto     pict '@E 999,999.999999'
  @ nLin,075 say nTotalVenda     pict '@E 999,999.999999'
  
  dbgotop ()
  
  if !eof()
    Rodape(132)
  endif  
  
  if !eof ()
    select ProdARQ
    set order to 1
    dbseek( cProd, .f. )
    if found ()
      if RegLock(0)
        replace PrecoCusto          with nTotalCusto
        replace PrecoVenda          with nTotalVenda
        dbunlock ()
      endif
    endif
  endif      
 
  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 132 )
    select SpooARQ
    set order to 1
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Relatório do Custo Produto"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 132
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
  endif
  
  select ProdARQ
  close
  select CoPrARQ
  close
  select ICoPARQ
  close
  select ICusARQ
  close
  select CustARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabCusto ()
  @ 02,01 say 'Composição ' + CoPrARQ->Nota + ' ' + CoPrARQ->Desc
  @ 03,01 say 'Materia Prima                                   Perc.     Preço Custo        Preço Venda'

  nLin := 5
retur NIL

//
// Calcula o ultimo lote
//
function CalcLote ( nComp )

  select LoteARQ
  set order to 1
  dbseek( strzero( nComp, 6 ), .f. )
  do while Comp == strzero( nComp, 6 )
    cLote := Lote
    
    dbskip ()
  enddo
  
  setcolor( CorCampo )
  @ 11,30 say cLote
  
  setcolor( CorJanel + ',' + CorCampo )
    
  select CoPrARQ
return(.t.)    

//
//  Funcao Imprime dados do Loteso
//
function PrinLote( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "LoteARQ", .t. )
    VerifIND( "LoteARQ" )

    #ifdef DBF_NTX
      set index to LoteIND1
    #endif 
  endif

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 06, 14, 10, 66, mensagem( 'Janela', 'PrinLote', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,16 say 'Comp. Inicial            Comp. Final'
  @ 09,16 say 'Data  Inicial             Data Final'

  select LoteARQ
  set order to 1
  dbgotop ()
  nLoteIni := 1
  nLoteFin := 999999
  dDataIni := date () - 30
  dDataFin := date ()

  @ 08,30 get nLoteIni    pict '999999'
  @ 08,53 get nLoteFin    pict '999999'        valid nLoteFin >= nLoteIni
  @ 09,30 get dDataIni    pict '99/99/9999'
  @ 09,53 get dDataFin    pict '99/99/9999'      valid dDataFin >= dDataIni
  read

  if lastkey() == K_ESC .or. nLoteIni == 0
    select LoteARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  Aguarde ()

  nPag     := 1
  nLin     := 0
  cArqu2   := cArqu2 + "." + strzero( nPag, 3 )
  lInicio  := .t.

  cLoteIni := strzero( nLoteIni, 6 )
  cLoteFin := strzero( nLoteFin, 6 )
  nTotal   := 0

  select LoteARQ
  set order  to 1
  dbgotop ()

  do while !eof()
    if Comp >= cLoteIni .and. Comp <= cLoteFin .and. Data >= dDataIni .and. Data <= dDataFin
      if lInicio   
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
        
        lInicio := .f.
      endif  

      if nLin == 0
        Cabecalho( 'Lote dos Produtos', 80, 3 )
        CabLote()
      endif

      @ nLin, 01 say Lote               
      @ nLin, 12 say OrdP
      @ nLin, 19 say Comp
      @ nLin, 27 say Desc                   
      @ nLin, 58 say Data                   pict '99/99/9999'
      @ nLin, 70 say Qtde                   pict '@E 999,999.9' 
      nLin ++

      nTotal += Qtde

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
    nLin ++
    @ nLin,058 say 'Total'
    @ nLin,070 say nTotal                pict '@E 999,999.9' 
    Rodape(80)
  endif  
 
  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 80 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Relatório de Lotes"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
  endif  

  select LoteARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabLote ()
  @ 02,01 say 'Lote       Ordem  Compo.  Produto                        Data          Qtde.'

  nLin := 4
retur NIL