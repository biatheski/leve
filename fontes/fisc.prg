//  Leve, Cupom Fiscal
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

function Fisc( xAlte )

  Alerta( space(39) + "Não foi definido o modelo do ECF !")
  return NIL
  

Janela( 11, 23, 14, 56, "LEVE " + cVersao, .f. )
setcolor ( CorJanel + "," + CorCampo )

@ 13,25 say "Um momento, conectando..."

numero_abertura_porta := fopen("COM2", FO_READWRITE + FO_COMPAT)
tamanho_de_retorno    := 0
vc_buffer             := inicio_protocolo := chr(27) + chr(251)
fim_protocolo_driver  := "|"+ chr(27) 

if ferror () != 0
   Alerta( "Problemas de comunicação. Pressione qualquer tecla.")
   return NIL
endif

Janela( 06, 19, 11, 53, 'Caixa...', .t. )
setcolor ( CorJanel + ',' + CorCampo )
@ 08,21 say '  Fundo de Troco'
  
setcolor( CorCampo )  
@ 10,28 say ' Confirmar '
@ 10,41 say ' Cancelar  '
  
setcolor( CorAltKC )
@ 10,29 say 'C'
@ 10,43 say 'a'
  
nFundo := 0
  
@ 08,38 get nFundo   pict "9999999,99"
read
  
if lastkey() == K_ESC
  fclose(numero_abertura_porta)
  return NIL
endi  

if nFundo > 0
  aOpc   := {}
  aadd( aOpc, { ' Confirmar ',  2, 'C', 10, 28, "Confirmar suprimento do caixa." } )
  aadd( aOpc, { ' Cancelar  ',  3, 'A', 10, 41, "Cancelar suprimento do caixa." } )
      
  nOpc := HCHOICE( aOpc, 2, 1 )

  if nOpc == 1
    prepara_string := inicio_protocolo + "25|SU|"+strzero(nFundo,14,0) + fim_protocolo_driver
    comunica_com_impressora(prepara_string,tamanho_de_retorno)
  endif
endif  

if NetUse( "ProdARQ", .t. )
  VerifIND( "ProdARQ" )
  
  vOpenProd := .t.

  #ifdef DBF_NTX
    set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
  #endif
else
  vOpenProd := .f.
endif

if NetUse( "ClieARQ", .t. )
  VerifIND( "ClieARQ" )

  vOpenClie := .t.
  
  #ifdef DBF_NTX
    set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
  #endif
else
  vOpenClie := .f.  
endif

if NetUse( "CondARQ", .t. )
  VerifIND( "CondARQ" )
  
  vOpenCond := .t.
  
  #ifdef DBF_NTX
    set index to CondIND1, CondIND2
  #endif
else
  vOpenCond := .f.  
endif

if NetUse( "PortARQ", .t. )
  VerifIND( "PortARQ" )
  
  vOpenPort := .t.
  
  #ifdef DBF_NTX
    set index to PortIND1, PortIND2
  #endif
else
  vOpenPort := .f.  
endif

if NetUse( "ReceARQ", .t. )
  VerifIND( "ReceARQ" )
  
  vOpenRece := .t.
  
  #ifdef DBF_NTX
    set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
  #endif
else
  vOpenRece := .f.  
endif

if NetUse( "ReprARQ", .t. )
  VerifIND( "ReprARQ" )
  
  vOpenRepr := .t.
  
  #ifdef DBF_NTX
    set index to ReprIND1, ReprIND2
  #endif
else
  vOpenRepr := .f.  
endif

if NetUse( "CupoARQ", .t. )                   
  VerifIND( "CupoARQ" )

  vOpenCupo := .t.
  
  #ifdef DBF_NTX
    set index to CupoIND1, CupoIND2, CupoIND3, CupoIND4
  #endif
else
  vOpenCupo := .f.  
endif

if NetUse( "ICupARQ", .t. )
  VerifIND( "ICupARQ" )
  
  vOpenICup := .t.
  
  #ifdef DBF_NTX
    set index to ICupIND1
  #endif
else
  vOpenICup := .f.  
endif

// Variaveis de Entrada
cAjuda      := 'Cupo'
lAjud       := .t.
tCupom      := savescreen( 00, 00, 23, 79 )
aOp         := {}
aArqui      := {}
cVendARQ    := CriaTemp(0)
cVendIND1   := CriaTemp(1)
cChave      := "Sequ"
nNota       := nQtde      := 0
cNota       := cNotaNew   := space(06)
dEmis       := date()
cCliente    := space(40)
nCond       := nClie      := 0
nSequPrx    := nJuro      := 0
cSequ       := cCond      := space(02)
cNatu       := cHora      := space(04)
cProd       := cClie      := cRepr   := cTran   := cPort   := space(04)
dSaid       := ctod('  /  /  ')
dVcto1      := dVcto2     := dVcto3  := dVcto4  := dVcto5  := ctod ('  /  /  ')
dVcto6      := dVcto7     := dVcto8  := dVcto9  := ctod ('  /  /  ')
nValor1     := nValor2    := nValor3 := nValor4 := nValor5 := 0
nValor6     := nValor7    := nValor8 := nValor9 := 0
nComis1     := nComis2    := nComis3 := nComis4 := nComis5 := 0
nComis6     := nComis7    := nComis8 := nComis9 := 0
lCondFixa   := EmprARQ->CondFixa

aadd( aArqui, { "Sequ",       "N", 002, 0 } )
aadd( aArqui, { "Prod",       "C", 004, 0 } )
aadd( aArqui, { "Produto",    "C", 040, 0 } )
aadd( aArqui, { "Qtde",       "N", 012, 0 } )
aadd( aArqui, { "Comi",       "N", 009, 3 } )
aadd( aArqui, { "Desc",       "N", 009, 3 } )
aadd( aArqui, { "PrecoVenda", "N", 012, 2 } )

dbcreate( cVendARQ , aArqui )
   
if NetUse( cVendARQ, .f., 30 )
  cVendTMP := alias ()
    
  index on &cChave to &cVendIND1

  #ifdef DBF_NTX
    set index to &cVendIND1
  #endif
endif

setcolor( CorFundo )
@ 00,00 clear to 22, 79 

setcolor( CorJanel )
@ 01, 01 clear to 04, 78
@ 01, 01 to 04, 78

setcolor( CorCabec )
@ 01,01 say space(78)
@ 01,03 say 'Produto         Descrição                      Qtde.   P. Venda   V. Total'      

setcolor( CorJanel )
@ 06, 43 clear to 21, 78
@ 06, 43 to 21, 78

setcolor( CorCabec )
@ 06,43 say space(36)
@ 06,43 say ' Itens do Cupom Fiscal              '

setcolor( CorJanel )
@ 06, 01 clear to 11, 41
@ 06, 01 to 11, 41

setcolor( CorCabec ) 
@ 06,01 say '                               SubTotal  '

setcolor( CorJanel )
@ 14, 01 clear to 21, 41
@ 14, 01 to 21, 41

setcolor( CorCabec )
@ 14,01 say '                  Desconto   Total Nota  '

setcolor( CorJanel )
@ 18,03 say '   Pgto.'
@ 19,03 say ' Cliente'
@ 20,03 say 'Vendedor'

select( cVendTMP )
set order to 1
set relation to Prod into ProdARQ
zap
  
bFirst := {|| dbseek( 01, .t. ) }
bLast  := {|| dbseek( 99, .t. ), dbskip (-1) }
bFor   := {|| .t. }
bWhile := {|| .t. }

oCupom           := TBrowseFW( bWhile, bFor, bFirst, bLast )
oCupom:nTop      := 08
oCupom:nLeft     := 44
oCupom:nBottom   := 21
oCupom:nRight    := 77
oCupom:headsep   := chr(194)+chr(196)
oCupom:colsep    := chr(179)
oCupom:footsep   := chr(193)+chr(196)
oCupom:colorSpec := CorJanel + ',' + CorJanel

oCupom:addColumn( TBColumnNew("Descrição",{|| iif( Prod == '9999', left( Produto, 19 ), left( ProdARQ->Nome, 19 ) ) } ) )
oCupom:addColumn( TBColumnNew("Qtde.",    {|| transform( Qtde, '99999' ) } ) )
oCupom:addColumn( TBColumnNew("Unitário", {|| transform( PrecoVenda, '@E 9,999.99' ) } ) )
oCupom:addColumn( TBColumnNew("P. Total", {|| transform( ( PrecoVenda * Qtde ), '@E 9,999.99' ) } ) )
oCupom:addColumn( TBColumnNew("Cód.",     {|| Prod } ) )
oCupom:addColumn( TBColumnNew("Seq.",     {|| transform( Sequ, '999' ) } ) )

iExitRequested := .f.
lAdiciona      := .f.
lAlterou       := .f.
  
setcolor( CorJanel )  
@ 09,43 say chr(195)
@ 09,78 say chr(180)
 
do while .t.
  lAbreCupom  := .t.
  nSequCupom  := nValorTotal := 0
  nSubTotal   := nSequ       := 0
  nDesconto   := nTotalNota  := 0
  nPrecoTotal := nComissao   := 0
  nPrecoVenda := nQtde       := 0
  nTotalOld   := 0
    
  if lCondFixa == "X"
    cCond := strzero( EmprARQ->CondCupom, 2 )
    nCond := EmprARQ->CondCupom
    cClie := strzero( EmprARQ->ClieCupom, 4 )
    nClie := EmprARQ->ClieCupom
    cRepr := strzero( EmprARQ->ReprCupom, 4 )
    nRepr := EmprARQ->ReprCupom
    cPort := strzero( EmprARQ->PortCupom, 4 )
    nPort := EmprARQ->PortCupom
  else
    cCond := space(04)
    nCond := 0
    cClie := space(04)
    nClie := 0
    cRepr := space(04)
    nRepr := 0 
    cPort := space(04)
    nPort := 0 
  endif
  
  Mensagem( '<.> Finalizar, <TAB> Itens, F1 Ajuda' )

  oCupom:gotop()
  oCupom:forcestable()

  select ProdARQ
  set order to 1
  
  select CondARQ
  set order to 1
  dbseek( cCond, .f. )

  select ClieARQ
  set order to 1
  dbseek( cClie, .f. )

  select ReprARQ
  set order to 1
  dbseek( cRepr, .f. )

  select PortARQ
  set order to 1
  dbseek( cPort, .f. )
 
  setcolor( CorCampo )
  @ 03,03 say space(15)
  @ 03,19 say space(25)
  @ 03,45 say nQtde           pict '@E 9999999999'
  @ 03,56 say nPrecoVenda     pict '@E 999,999.99'
  @ 03,67 say nValorTotal     pict '@E 999,999.99'
  @ 16,17 say nDesconto       pict '@E 999,999.99'
  @ 16,30 say nValorTotal     pict '@E 999,999.99'

  @ 18,12 say nCond           pict '9999'
  @ 18,17 say CondARQ->Nome   pict '@S23'
  @ 19,12 say nClie           pict '9999'
  @ 19,17 say ClieARQ->Nome   pict '@S23'
  @ 20,12 say nRepr           pict '9999'
  @ 20,17 say ReprARQ->Nome   pict '@S23'

  BigNumber (0)
  EntrCupom ()
   
  if lastkey() == K_ESC
    exit
  endif  
  
  Mensagem( chr(24) + ' Retornar Itens, <ESC> Cancela.' )
  
  @ 16,17 get nDesconto    pict '@E 999,999.99'  valid FiscTota()
  @ 16,30 get nTotalNota   pict '@E 999,999.99'  valid FiscTroc()
  @ 18,12 get nCond        pict '9999'           valid ValidARQ( 18, 14, cVendTMP, "Codigo", "Cond", "Descrição", "Nome", "Cond", "nCond", .t., 2, "Consulta de Condiç”es Pagamento", "CondARQ", 23 ) .and. FiscVcto () 
  @ 19,12 get nClie        pict '9999'           valid ValidClie( 19, 12, "ProdARQ", ,23 )
  @ 20,12 get nRepr        pict '9999'           valid ValidARQ( 20, 12, cVendTMP, "Codigo", "Repr", "Descrição", "Nome", "Repr", "nRepr", .t., 4, "Consulta de Vendedores", "ReprARQ", 23 )
  read

  if lastkey () == K_ESC 
    exit
  endif

  dEmis := date()
  cCond := strzero( nCond, 2 )
  cRepr := strzero( nRepr, 4 )
  cClie := strzero( nClie, 4 )
  cPort := strzero( nPort, 4 )

  select CondARQ
  set order to 1
  dbseek( cCond, .f. )
  
//  tSalvei := savescreen( 00, 00, 24, 79 )
  
  if nTotalOld > 0
    cTotalNota := strtran( transform( nTotalOld, '999999999999.99' ), '.', '' )    
  else  
    cTotalNota := strtran( transform( nTotalNota, '999999999999.99' ), '.', '' )    
  endif
  cTotalNota   := strtran( cTotalNota, ' ', '0' )  

//  dispbegin()

  prepara_string := inicio_protocolo + "32|A|0000" +  fim_protocolo_driver
  comunica_com_impressora(prepara_string,tamanho_de_retorno)

  prepara_string := inicio_protocolo + "33|" + left( CondARQ->Nome, 22 ) + "|" + cTotalNota + fim_protocolo_driver
  comunica_com_impressora(prepara_string,tamanho_de_retorno)

  prepara_string := inicio_protocolo + "34|" + alltrim( EmprARQ->Mensagem ) + chr(13) + chr(10) + fim_protocolo_driver
  comunica_com_impressora(prepara_string,tamanho_de_retorno)

//  prepara_string := inicio_protocolo + "10|0000|"+ cTotalNota + "|A|" + alltrim( EmprARQ->Mensagem ) + chr(10) +  fim_protocolo_driver

//  dispend ()

//  restscreen( 00, 00, 24, 79, tSalvei )

    select EmprARQ
    set order to 1
    dbseek( cEmpresa, .f. )
    
    nNotaNew := Nota + 1
    
    do while .t.
      cNotaNew := strzero( nNotaNew, 6 )
    
      CupoARQ->( dbseek( cNotaNew, .f. ) )

      if CupoARQ->(found())
        nNotaNew ++
        loop
      else      
        if RegLock()
          replace Nota       with nNotaNew
          dbunlock ()
        endif  
        exit    
      endif
    enddo  
  
    select CupoARQ    
    set order to 1
    if AdiReg()
      if RegLock()
        replace Nota       with cNotaNew
        replace Emis       with date ()
        replace Hora       with time ()
        replace Clie       with cClie
        replace Cliente    with cCliente
        replace Cond       with cCond
        replace Repr       with cRepr
        replace Port       with cPort
        replace SubTotal   with nSubTotal
        replace Desconto   with nDesconto
        replace Comissao   with nComissao
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
  
    select( cVendTMP )
    set order to 1
    dbgotop ()
    do while !eof ()
      cProd       := Prod
      cProduto    := Produto
      cSequ       := strzero( Sequ, 2 )
      nQtde       := Qtde
      nPrecoVenda := PrecoVenda
    
      select ICupARQ
      set order to 1
      dbseek( cNotaNew + cSequ, .f. )
      
      if found ()
        if RegLock()
          dbdelete ()
          dbunlock ()
        endif  
      endif  
      
      if AdiReg()
        if RegLock()
          replace Nota       with cNotaNew
          replace Sequ       with cSequ
          replace Prod       with cProd
          replace Produto    with cProduto
          replace Qtde       with nQtde
          replace PrecoVenda with nPrecoVenda
          dbunlock ()
        endif
      endif
    
    select( cVendTMP )    
    dbskip ()
  enddo

  select( cVendTMP )
  set order to 1 
  dbgotop ()
  do while !eof ()
    if empty( Prod )
      dbskip ()
      loop
    endif  
      
    cProd := Prod
    nQtde := Qtde
      
    select ProdARQ
    set order to 1
    dbseek( cProd, .f. )
    if found ()
      if RegLock()
        replace Qtde         with Qtde - nQtde
        replace UltS         with dEmis
        dbunlock ()
      endif
    endif    

    select( cVendTMP )
    dbskip ()
  enddo  
   
  nJuro := EmprARQ->Taxa
  uTipo := 'C'
  
  select ReceARQ
  set order  to 1
  
  for nJ := 1 to 9
    cParc   := str( nJ, 1 )
    cNotaPg := cNotaNew + cParc

    dbseek( cNotaPg + uTipo, .f. )
    
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
            replace Nota     with cNotaPg
            replace Clie     with cClie
            replace Cliente  with cCliente
            replace Tipo     with uTipo
            dbunlock ()
          endif
        endif  
      endif
    
      if RegLock()
        replace Emis     with dEmis
        replace Vcto     with dVcto&cParc
        replace Valor    with nValor&cParc
        replace Acre     with nJuro
        if dVcto&cParc == dEmis
          replace Pgto   with dVcto&cParc
          replace Pago   with nValor&cParc
        endif  
        replace Repr     with cRepr
        replace Port     with cPort
        replace ReprComi with nComis&cParc
        dbunlock ()
      endif
    endif
  next  

  select( cVendTMP )
  set order to 1
  set relation to Prod into ProdARQ
  zap
enddo
  
restscreen( 00, 00, 23, 79, tCupom )

if vOpenClie
  select ClieARQ
  close
endif

if vOpenProd
  select ProdARQ
  close
endif

if vOpenCond
  select CondARQ
  close
endif  

if vOpenRece
  select ReceARQ
  close
endif

if vOpenRepr
  select ReprARQ
  close
endif  

if vOpenPort
  select PortARQ
  close
endif  

select( cVendTMP )
ferase( cVendARQ )
ferase( cVendIND1 )

fclose(numero_abertura_porta)

return NIL

//
// Entra com o PRODUTO
//
function EntrCupom ()
  do while .t.
    lQtde    := .f.
    cWord    := space(15) 
    nTamanho := 15
    nConta   := cLetra     := 0
    nLin     := 3
    nCol     := 3

    setcolor( CorCampo )
    @ 03, 03 say space(15)
  
    setpos( nLin, nCol )

    do while nConta < nTamanho
      cLetra := inkey(0)
  
      do case
        case cLetra == K_ESC
          exit
        case cLetra == K_ENTER
          if len( alltrim( cWord ) ) < nTamanho
            nEspaco    := nTamanho - len( alltrim( cWord ) ) 
            cProdBarra := alltrim( cWord ) + space(nEspaco)
          endif

          exit
        case cLetra == K_BS .and. empty( cLetra )
          loop
        case cLetra == 42  
          setcolor( CorCampo )
          @ 03,19 say space(25)
          @ 03,56 say 0               pict '@E 999,999.99'
          @ 03,67 say 0               pict '@E 999,999.99'

          nQtde  := 0
          lQtde  := .t.
          cWord  := space(15)
          nConta := cLetra     := 0
          nLin   := 3
          nCol   := 3
   
          setcolor( CorJanel )
          @ 03,45 get nQtde                 pict '@E 9999999999'
          read
          
          setcolor( CorCampo )
          setpos( nLin, nCol )
          loop
        case cLetra == K_F1;         Ajuda()
        case cLetra == K_BS 
          if nConta + nCol == nCol
            loop
          endif
          
          cWord := left( cWord, len( cWord ) - 1 )
          
          nConta --

          @ nLin, nCol + nConta say ' '
          setpos( nLin, nCol + ( nConta - 1 ) )
          loop
        case cLetra == 46
          exit  
        case cLetra == K_TAB
          EntrItCu ()
         
          Mensagem( '<.> Finalizar, <TAB> Itens, ð Ajuda' )
          
          if lastkey() == K_INS
            lQtde    := .f.
            cWord    := space(15) 
            nTamanho := 15
            nConta   := cLetra     := 0
            nLin     := 3
            nCol     := 3
        
            setcolor( CorCampo )            
            setpos( nLin, nCol )
            loop
          endif
          if lastkey() == 46
            exit
          endif
        case cLetra >= 32 .and. cLetra <= 128  
          @ nLin, nCol + nConta say chr( cLetra )
           
          nConta ++
          cWord  += chr( cLetra ) 
        case cLetra == K_CTRL_Z
          tSalvei := savescreen( 00, 00, 23, 79 )
          prepara_string := inicio_protocolo + "13" + fim_protocolo_driver
          comunica_com_impressora(prepara_string,tamanho_de_retorno)
           
          select( cVendTMP ) 
           
          nSubTotal -= ( Qtde * PrecoVenda )

          restscreen( 00, 00, 23, 79, tSalvei )
          
          BigNumber( nSubTotal )

          dbdelete ()
          dbunlock ()

          oCupom:goBottom () 
          oCupom:refreshAll()
        case cLetra == K_CTRL_X
          tAltD := savescreen( 00, 00, 23, 79 )

          Janela( 04, 19, 07, 48, 'LEVE ' + cVersao , .f. )
          setcolor( CorCampo )
          @ 07,36 say ' Sim '
          @ 07,42 say ' Não '
          
          setcolor( CorAltKC )
          @ 07,37 say 'S'
          @ 07,43 say 'N'
          
          setcolor ( CorJanel + ',' + CorCampo )
          @ 06,21 say 'Cancelar Cupom'
          @ 07,21 say '        Vendas'
          
          if ConfLine( 06, 36, 2 )
            if !ConfLine( 07, 36, 2 )
              prepara_string := inicio_protocolo + "10|0000|00000000000000|A" + fim_protocolo_driver
              comunica_com_impressora(prepara_string,tamanho_de_retorno)
            else
              prepara_string := inicio_protocolo + "10|0000|00000000000000|A" + fim_protocolo_driver
              comunica_com_impressora(prepara_string,tamanho_de_retorno)
              prepara_string := inicio_protocolo + "14" + fim_protocolo_driver
              comunica_com_impressora(prepara_string,tamanho_de_retorno)
            endif  
          endif
                    
          restscreen( 00, 00, 23, 79, tAltD )  
      endcase     
    enddo

    if len( alltrim( cWord ) ) < nTamanho
      nEspaco    := nTamanho - len( alltrim( cWord ) ) 
      cProdBarra := alltrim( cWord ) + space( nEspaco )
    endif
    
    if lastkey () == K_ESC .or. lastkey() == 46
      return NIL
    endif  

    lAchou := .f.

    select ProdARQ
    if !lAchou
      set order to 1
      dbseek( strzero( val( cProdBarra ), 4 ), .f. ) 
    
      if found()
        lAchou := .t.
      endif  
    endif

    if !lAchou
      set order to 5
      dbseek( cProdBarra, .f. ) 

      if found()
        lAchou := .t.
      endif  
    endif

    if !lAchou
      set order to 6
      dbseek( cProdBarra, .f. ) 

      if found()
        lAchou := .t.
      endif  
    endif
  
    if !lAchou 
      ConsProd ()
    endif
  
    if lastkey() == K_ESC .or. empty( cProdBarra )
      loop
    endif
  
    if lQtde
      lQtde := .f.
    else
      nQtde := 1
    endif
  
    cProd       := ProdARQ->Prod
    nProd       := val( cProd )
    nPrecoVenda := ProdARQ->PrecoVenda
    nSequCupom  ++
   
    select( cVendTMP )
    if AdiReg()
      if RegLock()
        replace Sequ       with nSequCupom
        replace Prod       with cProd
        replace PrecoVenda with nPrecoVenda
        replace Qtde       with nQtde
        dbunlock ()
      endif  
    endif

    setcolor( CorCampo )
    @ 03,19 say ProdARQ->Nome         pict '@S25'
    @ 03,45 say nQtde                 pict '@E 9999999999'
    @ 03,56 say nPrecoVenda           pict '@E 999,999.99'
    @ 03,67 say nPrecoVenda * nQtde   pict '@E 999,999.99'

    oCupom:gobottom ()
    oCupom:forcestable()

    nSubTotal += ( nPrecoVenda * nQtde )

    BigNumber( nSubTotal )

    cSequ  := '09'
    cIten  := strzero( nProd, 13 )
    cPreco := strtran( transform( nPrecoVenda, '999999.99' ), '.', '' )    
    cPreco := strtran( cPreco, ' ', '0' )    
    cNome  := left( ProdARQ->Nome, 29 )
    cFisc  := ProdARQ->Codisc
    cQtde  := strzero( nQtde, 4 )
  
    tSalvei := savescreen( 00, 00, 24, 79 )
    dispbegin ()
 
    if lAbreCupom
      prepara_string := inicio_protocolo + "00" + fim_protocolo_driver
      comunica_com_impressora(prepara_string,tamanho_de_retorno)
    
      lAbreCupom := .f.

//      tamanho_de_retorno := 6
//      prepara_string     := inicio_protocolo + "32|A|0000" +  fim_protocolo_driver
//      cNotaNew           := comunica_com_impressora(prepara_string,tamanho_de_retorno)
    endif
  
    prepara_string := inicio_protocolo + cSequ + '|' + cIten + '|' + cNome + '|' + cFisc + '|' + cQtde + '|' + cPreco + '|0000' + fim_protocolo_driver
  
    comunica_com_impressora(prepara_string,tamanho_de_retorno)
   
    dispend ()
    restscreen( 00, 00, 24, 79, tSalvei )
  enddo  
return NIL

//
// Alterar itens dos produtos
//
function EntrItCu ()
  select( cVendTMP )
  set order to 1

  oCupom:colorSpec := CorJanel + ',' + CorCampo
  iExitRequested   := .f.

  do while !iExitRequested
    Mensagem ( '<INSERT> Incluir, <DELETE> Apagar, <.> Finalizar.')

    oCupom:forcestable()
    
    cTecla := Teclar(0)
     
    do case
      case cTecla == K_DOWN;       oCupom:down()
      case cTecla == K_UP;         oCupom:up()
      case cTecla == K_PGUP;       oCupom:pageUp()
      case cTecla == K_CTRL_PGUP;  oCupom:goTop()
      case cTecla == K_PGDN;       oCupom:pageDown()
      case cTecla == K_CTRL_PGDN;  oCupom:goBottom()
      case cTecla == K_RIGHT;      oCupom:right()
      case cTecla == K_LEFT;       oCupom:left()
      case cTecla == K_HOME;       oCupom:home()
      case cTecla == K_END;        oCupom:end()
      case cTecla == K_CTRL_LEFT;  oCupom:panLeft()
      case cTecla == K_CTRL_RIGHT; oCupom:panRight()
      case cTecla == K_CTRL_HOME;  oCupom:panHome()
      case cTecla == K_CTRL_END;   oCupom:panEnd()
      case cTecla == K_F1;         Ajuda()
      case cTecla == K_INS;        iExitRequested := .t.
      case cTecla == K_DEL
        setcolor( CorCampo )
        if RegLock()
          nSubTotal -= ( Qtde * PrecoVenda )
          nItem     := strzero( Sequ, 4 )
          tSalvei   := savescreen( 00, 00, 23, 79 )
          
          BigNumber( nSubTotal )

          dbdelete ()
          dbunlock ()

          oCupom:goBottom () 
          oCupom:refreshAll()

          prepara_string := inicio_protocolo + "31|"+ nItem + fim_protocolo_driver
          comunica_com_impressora(prepara_string,tamanho_de_retorno)
          
          restscreen( 00, 00, 23, 79, tSalvei )
        endif
      case cTecla == K_ESC         
        if Saindo ()
          iExitRequested := .t.
        else
          iExitRequested := .f.
        endif       
      case cTecla == 46;        oCupom:refreshAll()
        iExitRequested := .t.
    endcase
  enddo
  
  oCupom:colorSpec := CorJanel + ',' + CorJanel
return NIL

//
// Calcula do Troco do Cupom Fiscal
//
function FiscTroc ()
  Mensagem( chr(24) + ' Retornar Itens, ESC Cancelar.' )

  if nTotalNota > ( nSubTotal - nDesconto )
    tTroco     := savescreen( 00, 00, 23, 79 )
    nTotalOld  := nTotalNota
    nTroco     := nTotalNota - ( nSubTotal - nDesconto )
    nTotalNota := ( nSubTotal - nDesconto )
 
    setcolor( CorCabec ) 
    @ 06,01 say '                                  Troco  '

    BigNumber( nTroco )

    Teclar(0)

    restscreen( 00, 00, 23, 79, tTroco ) 
  endif
return(.t.)

//
// Calcula o Total do Cupom Fiscal 
//
function FiscTota()
  nTotalNota := nSubTotal - nDesconto
  nValorPago := nSubTotal - nDesconto
 
  Mensagem( 'Informe o Valor Pago no campo do Total que o sistema calcular  o Troco.' )

  if lCondFixa == "X"
    FiscVcto ()
  endif
  
  if lastkey () == K_UP
    EntrCupom ()
 
  endif  
return(.t.)

//
// Calcula os Vencimentos do Cupom
//
function FiscVcto ()
  dVcto1  := dVcto2  := dVcto3  := dVcto4  := dVcto5  := ctod ('  /  /  ')
  dVcto6  := dVcto7  := dVcto8  := dVcto9  := ctod ('  /  /  ')
  nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := 0
  nValor6 := nValor7 := nValor8 := nValor9 := 0
  nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := 0
  nComis6 := nComis7 := nComis8 := nComis9 := 0

  select( cVendTMP )
  set order to 1 
  dbgotop ()
  do while !eof ()
    if ProdARQ->PerC == 0
      nComissao += ( ( PrecoVenda * Qtde ) * ReprARQ->PerC ) / 100
    else  
      nComissao += ( ( PrecoVenda * Qtde ) * ProdARQ->PerC ) / 100
    endif  

    dbskip ()
  enddo
  
  select CondARQ
  set order to 1
  dbseek( strzero( nCond, 2 ), .f. )
  
  if found()
    dVcto1     := dEmis + CondARQ->Vct1
    nTotalNota := nTotalNota + ( nTotalNota * CondARQ->Acrs / 100 )
    nValor1    := nTotalNota
    nComis1    := nComissao
    nComissao  := nComissao
 
    if CondARQ->Vct2 != 0
      dVcto2  := dEmis + CondARQ->Vct2
      nValor1 := nValor2 := nTotalNota / 2
      nComis1 := nComis2 := nComissao / 2
    endif

    if CondARQ->Vct3 != 0
      dVcto3  := dEmis + CondARQ->Vct3
      nValor1 := nValor2 := nValor3 := nTotalNota / 3
      nComis1 := nComis2 := nComis3 := nComissao / 3
    endif

    if CondARQ->Vct4 != 0
      dVcto4  := dEmis + CondARQ->Vct4
      nValor1 := nValor2 := nValor3 := nValor4 := nTotalNota / 4
      nComis1 := nComis2 := nComis3 := nComis4 := nComissao / 4
    endif

    if CondARQ->Vct5 != 0
      dVcto5  := dEmis + CondARQ->Vct5
      nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nTotalNota / 5
      nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := nComissao / 5
    endif

    if CondARQ->Vct6 != 0
      dVcto6  := dEmis + CondARQ->Vct6
      nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nTotalNota / 6
      nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := nComis6 := nComissao / 6
    endif

    if CondARQ->Vct7 != 0
      dVcto7  := dEmis + CondARQ->Vct7
      nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nTotalNota / 7
      nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := nComis6 := nComis7 := nComissao / 7
    endif

    if CondARQ->Vct8 != 0
      dVcto8  := dEmis + CondARQ->Vct8
      nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nValor8 := nTotalNota / 8
      nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := nComis6 := nComis7 := nComis8 := nComissao / 8
    endif

    if CondARQ->Vct9 != 0
      dVcto9  := dEmis + CondARQ->Vct9
      nValor1 := nValor2 := nValor3 := nValor4 := nValor5 := nValor6 := nValor7 := nValor8 := nValor9 := nTotalNota / 9
      nComis1 := nComis2 := nComis3 := nComis4 := nComis5 := nComis6 := nComis7 := nComis8 := nComis9 := nComissao / 9
    endif
  endif
  
  if CondARQ->Vct1 == 0 .and. CondARQ->Vct2 == 0 .and. CondARQ->Vct3 == 0 .and.;
     CondARQ->Vct4 == 0 .and. CondARQ->Vct5 == 0 .and. CondARQ->Vct6 == 0 .and.;
     CondARQ->Vct7 == 0 .and. CondARQ->Vct8 == 0 .and. CondARQ->Vct9 == 0 .or.;
     nCond         == 0 .or. lCondFixa == "X"
  else    
    tVcto := savescreen( 00, 00, 23, 79 )  
    Janela ( 05, 09, 18, 63, 'Vencimentos do Atendimento no Balc„o', .f. )
    Mensagem ( 'Entrada dos vencimentos do Atendimento no Balc„o, Tecle <ESC> para retornar.')

    setcolor ( CorJanel )
    @ 07,11 say '  Vencimento 1              Valor 1'
    @ 08,11 say '  Vencimento 2              Valor 2'
    @ 09,11 say '  Vencimento 3              Valor 3'
    @ 10,11 say '  Vencimento 4              Valor 4'
    @ 11,11 say '  Vencimento 5              Valor 5'
    @ 12,11 say '  Vencimento 6              Valor 6'
    @ 13,11 say '  Vencimento 7              Valor 7'
    @ 14,11 say '  Vencimento 8              Valor 8'
    @ 15,11 say '  Vencimento 9              Valor 9'
    @ 17,11 say '      Portador'
   
    setcolor( CorCampo )
    @ 17,31 say space(30)
    
    setcolor ( CorJanel + ',' + CorCampo )
    @ 07,26 get dVcto1    pict '99/99/9999'            
    @ 07,47 get nValor1   pict '@E 999,999,999.99'   
    @ 08,26 get dVcto2    pict '99/99/9999'
    @ 08,47 get nValor2   pict '@E 999,999,999.99'
    @ 09,26 get dVcto3    pict '99/99/9999'
    @ 09,47 get nValor3   pict '@E 999,999,999.99'
    @ 10,26 get dVcto4    pict '99/99/9999'
    @ 10,47 get nValor4   pict '@E 999,999,999.99'
    @ 11,26 get dVcto5    pict '99/99/9999'
    @ 11,47 get nValor5   pict '@E 999,999,999.99'
    @ 12,26 get dVcto6    pict '99/99/9999'
    @ 12,47 get nValor6   pict '@E 999,999,999.99'
    @ 13,26 get dVcto7    pict '99/99/9999'
    @ 13,47 get nValor7   pict '@E 999,999,999.99'
    @ 14,26 get dVcto8    pict '99/99/9999'
    @ 14,47 get nValor8   pict '@E 999,999,999.99'
    @ 15,26 get dVcto9    pict '99/99/9999'
    @ 15,47 get nValor9   pict '@E 999,999,999.99'
    @ 17,26 get nPort     pict '9999'     valid ValidARQ( 17, 26, "CupoARQ", "Código" , "Port", "Descrição", "Nome", "Port", "nPort", .t., 4, "Consulta de Portadores", "PortARQ", 30 )
    read
    
    cPort := strzero( nPort, 4 )

    restscreen( 00, 00, 23, 79, tVcto )  
  endif  
return(.t.)

//
// Comunicao com a Impressora ???
//
static function comunica_com_impressora(buffer_a_ser_enviado,tam_a_ser_ret)

 fwrite(numero_abertura_porta, @buffer_a_ser_enviado, len(buffer_a_ser_enviado))

 retorno_impressora := ack := nak := st1 := st2 := space(1)

 for contador1 := 1 to 3
     fread(numero_abertura_porta,@retorno_impressora,1)
     do case
        case contador1 = 1
             do case
                case asc(retorno_impressora) = 21
                  ? "Atenção... a impressora retornou 21d=15h=NAK" 
                case asc(retorno_impressora) = 06
                  ack := transform(asc(retorno_impressora),"99")
                otherwise
                  ? "Atenção... provavelmente o driver Nãofoi carregado !" 
                  fclose(numero_abertura_porta)
                  return NIL
             endcase
        case contador1 = 2
             st1 := transform(asc(retorno_impressora),"999")
        case contador1 = 3
             st2 := transform(asc(retorno_impressora),"999")
     endcase

 next contador1

 sequencia_retorno := ""
 for contador2 := 1 to tam_a_ser_ret
    fread(numero_abertura_porta, @retorno_impressora, 1)
    sequencia_retorno += retorno_impressora
 next contador2
 clear
 
 Decodifica_Retorno(ack,st1,st2)
return sequencia_retorno

static function Decodifica_Retorno(ACK,ST1,ST2)

   Bit_st1:=Bit_st2:=Bit_ack:=0
   Bit_ack=Val(ACK)
   Bit_st1=Val(ST1)
   Bit_st2=Val(ST2)

//Tratamento do Ack ou NAk
  if Bit_ack # 6
    ? "Problemas ao Enviar o Comando a Impressora Devolveu 21" 
  endif
  
//Aqui ‚ Feito o Tratamento do St1 subtraindo  o Byte anterior pelo Seguinte
  if Bit_st1 >= 128;? ST1_BIT_7;Bit_st1=Bit_st1-128 ;end if
  if Bit_st1 >= 64 ;? ST1_BIT_6;Bit_st1=Bit_st1-64  ;end if
  if Bit_st1 >= 32 ;? ST1_BIT_5;Bit_st1=Bit_st1-32  ;end if
  if Bit_st1 >= 16 ;? ST1_BIT_4;Bit_st1=Bit_st1-16  ;end if
  if Bit_st1 >= 8  ;? ST1_BIT_3;Bit_st1=Bit_st1-8   ;end if
  if Bit_st1 >= 4  ;? ST1_BIT_2;Bit_st1=Bit_st1-4   ;end if
  if Bit_st1 >= 2  ;? ST1_BIT_1;Bit_st1=Bit_st1-2   ;end if
  if Bit_st1 >= 1  ;? ST1_BIT_0                     ;end if

//Aqui ‚ Feito o Tratamento do St2 subtraindo  o Byte anterior pelo Seguinte
  if Bit_st2 >= 128;? ST2_BIT_7 ;Bit_st2=Bit_st2-128 ;end if
  if Bit_st2 >= 64 ;? ST2_BIT_6 ;Bit_st2=Bit_st2-64  ;end if
  if Bit_st2 >= 32 ;? ST2_BIT_5 ;Bit_st2=Bit_st2-32  ;end if
  if Bit_st2 >= 16 ;? ST2_BIT_4 ;Bit_st2=Bit_st2-16  ;end if
  if Bit_st2 >= 8  ;? ST2_BIT_3 ;Bit_st2=Bit_st2-8   ;end if
  if Bit_st2 >= 4  ;? ST2_BIT_2 ;Bit_st2=Bit_st2-4   ;end if
  if Bit_st2 >= 2  ;? ST2_BIT_1 ;Bit_st2=Bit_st2-2   ;end if
  if Bit_st2 >= 1  ;? ST1_BIT_0                      ;end if

return NIL

//
// Sangria do Caixa
//
function Sangria ()

  Alerta( space(39) + "Não foi definido o modelo do ECF !")
  return NIL


  tSangria := savescreen( 00, 00, 23, 79 )
  nTotal   := 0
  aOpc     := {}
  nValor   := 0

  Janela( 06, 19, 12, 53, 'Sangria...', .t. )
  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,21 say 'Valor da Sangria'
  @ 09,21 say '     Total Caixa'
  
  setcolor( CorCampo )
  @ 11,28 say ' Confirmar '
  @ 11,40 say ' Cancelar '
  @ 09,38 say nTotal   pict "9999999,99"
  
  setcolor( CorAltKC )
  @ 11,29 say 'C'
  @ 11,42 say 'a'
    
  @ 08,38 get nValor   pict "9999999,99"
  read

  aadd( aOpc, { ' Confirmar ',  2, 'C', 11, 28, "Confirmar sangria do caixa." } )
  aadd( aOpc, { ' Cancelar ',   3, 'A', 11, 40, "Cancelar sangria do caixa." } )
      
  nOpc := HCHOICE( aOpc, 2, 1 )

  if nOpc == 1 .and. nValor > 0
    Janela( 11, 23, 14, 56, "LEVE " + cVersao, .f. )
    setcolor ( CorJanel + "," + CorCampo )

    @ 13,25 say "Um momento, abrindo porta serial (COM2)..."

    numero_abertura_porta := fopen("COM2", FO_READWRITE + FO_COMPAT)
    tamanho_de_retorno    := 0
    vc_buffer             := inicio_protocolo := chr(27) + chr(251)
    fim_protocolo_driver  := "|"+ chr(27) 

    if ferror () != 0
      Alerta( "Problemas de comunicação. Pressione qualquer tecla.")
      return NIL
    endif

    prepara_string := inicio_protocolo + "25|SA|"+strzero(nValor,14,0) + fim_protocolo_driver
    comunica_com_impressora(prepara_string,tamanho_de_retorno)
  endif
  
  restscreen( 00, 00, 23, 79, tSangria )
return NIL

//
// Suprimento
//
function Reforco ()
  Alerta( space(39) + "Não foi definido o modelo do ECF !")
  return NIL

  tReforco := savescreen( 00, 00, 23, 79 )

  Janela( 06, 19, 11, 53, 'Reforço Caixa...', .t. )
  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,21 say '   Reforço Caixa'
  
  setcolor( CorCampo )  
  @ 10,28 say ' Confirmar '
  @ 10,41 say ' Cancelar  '
  
  setcolor( CorAltKC )
  @ 10,29 say 'C'
  @ 10,43 say 'a'
  
  nReforco := 0
  aOpc     := {}
  
  
  @ 08,38 get nReforco   pict "9999999,99"
  read
  
  if lastkey() == K_ESC
    restscreen( 00, 00, 23, 79, tReforco )
    return NIL
  endi  

  aadd( aOpc, { ' Confirmar ',  2, 'C', 10, 28, "Confirmar suprimento do caixa." } )
  aadd( aOpc, { ' Cancelar  ',  3, 'A', 10, 41, "Cancelar suprimento do caixa." } )
      
  nOpc := HCHOICE( aOpc, 2, 1 )

  if nOpc == 1 .and. nReforco > 0
    Janela( 11, 23, 14, 56, "LEVE " + cVersao, .f. )
    setcolor ( CorJanel + "," + CorCampo )

    @ 13,25 say "Um momento, conectando..."

    numero_abertura_porta := fopen("COM2", FO_READWRITE + FO_COMPAT)
    tamanho_de_retorno    := 0
    vc_buffer             := inicio_protocolo := chr(27) + chr(251)
    fim_protocolo_driver  := "|"+ chr(27) 

    if ferror () != 0
      Alerta( "Problemas de comunicação. Pressione qualquer tecla.")
      return NIL
    endif

    prepara_string := inicio_protocolo + "25|SU|"+strzero(nReforco,14,0) + fim_protocolo_driver
    comunica_com_impressora(prepara_string,tamanho_de_retorno)
  endif
  
  restscreen( 00, 00, 23, 79, tReforco )
return NIL

//
// Leitura X
//
function LeituraX ()

  Alerta( space(39) + "Não foi definido o modelo do ECF !")
  return NIL

  Janela( 08, 23, 11, 56, "LEVE " + cVersao, .f. )
  setcolor ( CorJanel + "," + CorCampo )

  @ 10,25 say "Um momento, conectando..."

  numero_abertura_porta := fopen("COM2", FO_READWRITE + FO_COMPAT)
  tamanho_de_retorno    := 0
  vc_buffer             := inicio_protocolo := chr(27) + chr(251)
  fim_protocolo_driver  := "|"+ chr(27) 

  if ferror () != 0
     Alerta( "Problemas de comunicação. Pressione qualquer tecla.")
     return NIL
  endif
  
  if ConfAlte ()
    prepara_string := inicio_protocolo + "06" + fim_protocolo_driver
    comunica_com_impressora(prepara_string,tamanho_de_retorno)
  endif  
  
  fclose(numero_abertura_porta)
return NIL

//
// Redução Z
//
function ReducaoZ ()

  Alerta( space(39) + "Não foi definido o modelo do ECF !")
  return NIL

  Janela( 08, 23, 11, 56, "LEVE " + cVersao, .f. )
  setcolor ( CorJanel + "," + CorCampo )

  @ 10,25 say "Um momento, conectando..."

  numero_abertura_porta := fopen("COM2", FO_READWRITE + FO_COMPAT)
  tamanho_de_retorno    := 0
  vc_buffer             := inicio_protocolo := chr(27) + chr(251)
  fim_protocolo_driver  := "|"+ chr(27) 

  if ferror () != 0
     Alerta( "Problemas de comunicação. Pressione qualquer tecla.")
     return NIL
  endif
  
  if ConfAlte ()
    prepara_string := inicio_protocolo + "05" + fim_protocolo_driver
    comunica_com_impressora(prepara_string,tamanho_de_retorno)
  endif  
  
  fclose(numero_abertura_porta)
return NIL  

//
// Cancela Cupom
//
function CancCupom ()

  Alerta( space(39) + "Não foi definido o modelo do ECF !")
  return NIL

  Janela( 08, 23, 11, 56, "LEVE " + cVersao, .f. )
  setcolor ( CorJanel + "," + CorCampo )

  @ 10,25 say "Um momento, conectando..."

  numero_abertura_porta := fopen("COM2", FO_READWRITE + FO_COMPAT)
  tamanho_de_retorno    := 0
  vc_buffer             := inicio_protocolo := chr(27) + chr(251)
  fim_protocolo_driver  := "|"+ chr(27) 

  if ferror () != 0
     Alerta( "Problemas de comunicação. Pressione qualquer tecla.")
     return NIL
  endif
  
  if ConfAlte ()
    prepara_string := inicio_protocolo + "05" + fim_protocolo_driver
    comunica_com_impressora(prepara_string,tamanho_de_retorno)
  endif  
  
  fclose(numero_abertura_porta)
return NIL  

//
// Memória Fiscal - Data
//
function MFiscData ()

  Alerta( space(39) + "Não foi definido o modelo do ECF !")
  return NIL

  tMemoria := savescreen( 00, 00, 23, 79 )

  Janela( 06, 14, 11, 63, 'Memória Fiscal...', .t. )
  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,16 say 'Data Inicial             Data Final'

  setcolor( CorCampo )  
  @ 10,38 say ' Confirmar '
  @ 10,51 say ' Cancelar  '
  
  setcolor( CorAltKC )
  @ 10,39 say 'C'
  @ 10,53 say 'a'
  
  aOpc     := {}
  dDataIni := date() - 30
  dDataFin := date()
  
  @ 08,29 get dDataIni   pict "99/99/99"
  @ 08,52 get dDataFin   pict "99/99/99" valid dDataFin >= dDataIni
  read
  
  if lastkey() == K_ESC
    restscreen( 00, 00, 23, 79, tMemoria )
    return NIL
  endi  

  aadd( aOpc, { ' Confirmar ',  2, 'C', 10, 38, "Confirmar emissão de memória fiscal por data." } )
  aadd( aOpc, { ' Cancelar  ',  3, 'A', 10, 51, "Cancelar emissão de memória fiscal por data." } )
      
  nOpc := HCHOICE( aOpc, 2, 1 )

  if nOpc == 1
    Janela( 11, 23, 14, 56, "LEVE " + cVersao, .f. )
    setcolor ( CorJanel + "," + CorCampo )

    @ 13,25 say "Um momento, conectando..."

    numero_abertura_porta := fopen("COM2", FO_READWRITE + FO_COMPAT)
    tamanho_de_retorno    := 0
    vc_buffer             := inicio_protocolo := chr(27) + chr(251)
    fim_protocolo_driver  := "|"+ chr(27) 

    if ferror () != 0
      Alerta( "Problemas de comunicação. Pressione qualquer tecla.")
      return NIL
    endif

    cDataIni := strtran( dtoc( dDataIni ), "/" )
    cDataFin := strtran( dtoc( dDataFin ), "/" )

    prepara_string := inicio_protocolo + "08|"+cDataIni+"|"+cDataFin+"|I|"+fim_protocolo_driver
    comunica_com_impressora(prepara_string,tamanho_de_retorno)

    fclose(numero_abertura_porta)
  endif
 
  restscreen( 00, 00, 23, 79, tMemoria )
return NIL

//
// Memória Fiscal - Redução
//
function MFiscRedu ()

  Alerta( space(39) + "Não foi definido o modelo do ECF !")
  return NIL

  tMemoria := savescreen( 00, 00, 23, 79 )

  Janela( 06, 14, 11, 63, 'Memória Fiscal...', .t. )
  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,16 say 'Redução Inicial          Redução Final'

  setcolor( CorCampo )  
  @ 10,38 say ' Confirmar '
  @ 10,51 say ' Cancelar  '
  
  setcolor( CorAltKC )
  @ 10,39 say 'C'
  @ 10,53 say 'a'
  
  aOpc     := {}
  nReduIni := 1
  nReduFin := 9999
  
  @ 08,33 get nReduIni   pict "9999"
  @ 08,56 get nReduFin   pict "9999" valid nReduFin >= nReduIni
  read
  
  if lastkey() == K_ESC
    restscreen( 00, 00, 23, 79, tMemoria )
    return NIL
  endi  

  aadd( aOpc, { ' Confirmar ',  2, 'C', 10, 38, "Confirmar emissão de memória fiscal por redução." } )
  aadd( aOpc, { ' Cancelar  ',  3, 'A', 10, 51, "Cancelar emissão de memória fiscal por redução." } )
      
  nOpc := HCHOICE( aOpc, 2, 1 )

  if nOpc == 1
    Janela( 11, 23, 14, 56, "LEVE " + cVersao, .f. )
    setcolor ( CorJanel + "," + CorCampo )

    @ 13,25 say "Um momento, conectando..."

    numero_abertura_porta := fopen("COM2", FO_READWRITE + FO_COMPAT)
    tamanho_de_retorno    := 0
    vc_buffer             := inicio_protocolo := chr(27) + chr(251)
    fim_protocolo_driver  := "|"+ chr(27) 

    if ferror () != 0
      Alerta( "Problemas de comunicação. Pressione qualquer tecla.")
      return NIL
    endif

    prepara_string := inicio_protocolo + "08|00|"+;
                      strzero( nReduIni,4,0)+"|00|"+;
                      strzero( nReduFin,4,0)+"|I|"+fim_protocolo_driver

    comunica_com_impressora(prepara_string,tamanho_de_retorno)

    fclose(numero_abertura_porta)
  endif
 
  restscreen( 00, 00, 23, 79, tMemoria )
return NIL

//
// Visualiza o Valor Grande
//
function BigNumber( nNumero )
  if nNumero < 0
    return(.t.)
  endif  
 
  aMatriz := array(3,13)
  aNumero := array(9)
  aMatriz := {{"ÛßÛ", "  Û", "ßßÛ", "ßßÛ", "Û Û", "Ûßß", "Ûßß", "ßßÛ", "ÛßÛ", "ÛßÛ", " ", " ", "   " },;
              {"Û Û", "  Û", "Ûßß", "ßßÛ", "ßßÛ", "ßßÛ", "ÛßÛ", "  Û", "ÛßÛ", "ßßÛ", " ", " ", "   " },;
              {"ßßß", "  ß", "ßßß", "ßßß", "  ß", "ßßß", "ßßß", "  ß", "ßßß", "ßßß", "Û", "ß", "   " }}

//  aMatriz := {{"ÚÄ¿", "  ¿", "ÄÄ¿", "ÄÄ¿", "Â Â", "ÚÄÄ", "ÚÄÄ", "ÄÄ¿", "ÚÄ¿", "ÚÄ¿", " ", " ", "   " },;
//              {"³ ³", "  ³", "ÚÄÙ", "ÄÄ´", "ÀÄ´", "ÀÄ¿", "ÃÄ¿", "  ³", "ÃÄ´", "ÀÄ´", " ", " ", "   " },;
//              {"ÀÄÙ", "  Á", "ÀÄÄ", "ÄÄÙ", "  Á", "ÄÄÙ", "ÀÄÙ", "  Á", "ÀÄÙ", "ÄÄÙ", "³", "Ä", "   " }}

  cNum    := transform( nNumero, '@E 99,999.99' )
  nLen    := len( cNum )
  nLinha  := 8
  
  for nA := 1 to nLen
    do case
      case asc( substr( cNum, nA, 1 ) ) == 32
        nNum := 13
      case asc( substr( cNum, nA, 1 ) ) == 46
        nNum := 12
      case asc( substr( cNum, nA, 1 ) ) == 44
        nNum := 11
      otherwise
        nNum := asc( substr( cNum, nA, 1 ) ) - 47  
    endcase       
  
    aNumero[nA] := nNum
  next  
  
  setcolor( CorJanel )

  for nB := 1 to 3
    for nC := 1 to 9
      ero      := strzero(nC,2)
      cNum&ero := aMatriz[nB,aNumero[nC]]
    next 
    
    if nNumero < 1000
      @ nLinha,007 say cNum01 + ' ' + cNum02 + ' ' + cNum03 + ' ' + cNum04 + ' ' +;
                       cNum05 + ' ' + cNum06 + ' ' + cNum07 + ' ' + cNum08 + ' ' +;
                       cNum09
    else                   
      @ nLinha,009 say cNum01 + ' ' + cNum02 + ' ' + cNum03 + ' ' + cNum04 + ' ' +;
                       cNum05 + ' ' + cNum06 + ' ' + cNum07 + ' ' + cNum08 + ' ' +;
                       cNum09
    endif                   
    nLinha ++        
  next
return NIL

//
// Function Gerar arquivo magnetico
//
function GeraArqu ()
  tMemoria := savescreen( 00, 00, 23, 79 )

  Janela( 06, 14, 11, 63, 'Arquivo Magnetico...', .t. )
  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,16 say 'Data Inicial             Data Final'

  setcolor( CorCampo )  
  @ 10,38 say ' Confirmar '
  @ 10,51 say ' Cancelar  '
  
  setcolor( CorAltKC )
  @ 10,39 say 'C'
  @ 10,53 say 'a'
  
  aOpc     := {}
  dDataIni := date() - 30
  dDataFin := date()
  
  @ 08,29 get dDataIni   pict "99/99/99"
  @ 08,52 get dDataFin   pict "99/99/99" valid dDataFin >= dDataIni
  read
  
  if lastkey() == K_ESC
    restscreen( 00, 00, 23, 79, tMemoria )
    return NIL
  endif
  
  restscreen( 00, 00, 23, 79, tMemoria )
return NIL