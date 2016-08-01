//  Leve, Recebimento de Contas a Receber
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

function Rcto ()

if NetUse( "PortARQ", .t. )
  VerifIND( "PortARQ" )
  
  vOpenPort := .t.

  #ifdef DBF_NTX
    set index to PortIND1, PortIND2
  #endif
else
  vOpenPort := .f.
endif

if NetUse( "CobrARQ", .t. )
  VerifIND( "CobrARQ" )
  
  vOpenCobr := .t.

  #ifdef DBF_NTX
    set index to CobrIND1, CobrIND2
  #endif
else
  vOpenCobr := .f.
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

if NetUse( "ReprARQ", .t. )
  VerifIND( "ReprARQ" )
  
  vOpenRepr := .t.

  #ifdef DBF_NTX
    set index to ReprIND1, ReprIND2
  #endif
else
  vOpenRepr := .f.
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

//  Variaveis de Entrada para Item
nNota     := nClie   := nRepr   := 0
cNota     := space(07)
cClie     := cPort   := cRepr   := cCobr   := space(04)
dEmis     := ctod('  /  /  ')
dVcto     := ctod('  /  /  ')
dPgto     := ctod('  /  /  ')
nValor    := nAcre   := nDesc   := nJuro   := nPago := 0
nMesAtu   := nMesAnt := nMesPri := nPort   := nCobr := 0
nReprComi := nTipo   := 0
cTipoVcto := space(15)
cDest     := space(15)
cTipo     := space(01)
aOpc      := {}
cCliente  := space(40)
lCalcJuro := .t.

aadd( aOpc, { ' Nota    ', 2, 'N', 04, 55, "Contas a Receber gerada por uma Nota Fiscal" } )
aadd( aOpc, { ' Pedido  ', 2, 'P', 04, 55, "Contas a Receber gerada por um Pedido" } )
aadd( aOpc, { ' O.S.    ', 2, 'O', 04, 55, "Contas a Receber gerada por uma Ordem de Serviço" } )

//  Tela Item
Janela ( 02, 05, 21, 72, mensagem( 'Janela', 'Rcto', .f. ), .t. )

setcolor ( CorJanel + ',' + CorCampo )
@ 04,18 say 'Nota'
@ 04,44 say '      Tipo'
@ 05,15 say 'Cliente'

@ 07,10 say 'Data Emissão'
@ 08,07 say 'Data Vencimento'
@ 08,44 say 'Tipo Vcto.'
@ 09,08 say 'Data Pagamento'
@ 09,44 say '   Destino'

@ 11,12 say 'Valor Nota'
@ 12,11 say 'Juro Mensal'
@ 12,43 say 'Mora Diária'

@ 14,13 say 'Descontos'
@ 14,44 say '     Juros'
@ 15,12 say 'Valor Pago'
@ 15,44 say '  Comissão'
@ 16,12 say '  Portador'
@ 17,09 say '     Vendedor'
@ 18,09 say '     Cobrador'

setcolor ( 'n/w+' )
@ 04,65 say chr(25)

MostOpcao( 20, 07, 19, 48, 61 ) 
tRcto := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Item
select ReceARQ
set order    to 1
set relation to Clie into ClieARQ, to Port into PortARQ,;
             to Repr into ReprARQ, to Cobr into CobrARQ
if vOpenRece
  dbgobottom ()
endif  
do while  .t.
  select ClieARQ
  set order to 1
  
  select PortARQ
  set order to 1
  
  select ReprARQ
  set order to 1
  
  select CobrARQ
  set order to 1
  
  select ReceARQ
  set order    to 1
  set relation to Clie into ClieARQ, to Port into PortARQ,;
               to Repr into ReprARQ, to Cobr into CobrARQ

  Mensagem('Rcto','Janela')

  cStat    := space(04)
  cStatAnt := space(04)
  
  restscreen( 00, 00, 23, 79, tRcto )
  
  MostRece()
  
  if Demo ()
    exit
  endif  
  
  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostRece'
  cAjuda   := 'Rcto'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()

  @ 04,23 get nNota   pict '999999-99'
  read
    
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC
    exit
  endif

  nTipo := HCHOICE( aOpc, 3, nTipo )

  if lastkey() == K_ESC
    exit
  endif
  
  cNota := strzero( nNota, 8 )

  do case 
    case nTipo == 1;      cTipo := 'N' 
    case nTipo == 2;      cTipo := 'P' 
    case nTipo == 3;      cTipo := 'O' 
  endcase    

  //  Verificar existencia para Incluir ou Alterar
  select ReceARQ
  set order to 1
  dbseek( cNota + cTipo, .f. )
  if eof()
    Alerta ( mensagem( 'Alerta', 'RctoEof', .f. ) )
    loop
  else
    Mensagem ('Rcto','alte')
    cStat := 'alte'
  endif
  
  cStatAnt := cStat

  MostRece ()

  if dPgto != ctod ('  /  /  ')
    Alerta( mensagem( 'Alerta', 'RctoFound', .f. ) )
  endif  

  EntrRcto ()

  Confirmar ( 20, 07, 19, 48, 61, 3 )
  
  if lastkey () == K_ESC .or. cStat == 'loop'
    loop
  endif  

  if cStat == 'prin'
    PrinRece(.f.)
  endif

  if cStat == 'excl'
    ExclRegi ()
  endif
  
  if cStat == 'alte' .or. cStat == 'incl'
    if RegLock()
      replace Pgto        with dPgto
      replace Desc        with nDesc
      replace Juro        with nJuro
      replace Pago        with nPago
      replace Dest        with cDest
      replace Cobr        with cCobr
      replace Port        with cPort
      replace Repr        with cRepr
      dbunlock()
    endif
    
    if nPago < ( ( nValor + nJuro ) - nDesc ) .and. nPago > 0
      tOutra := savescreen( 00, 00, 23, 79 )

      Janela( 09, 22, 14, 49, mensagem( 'Janela', 'Parcela', .f. ), .f. )
      setcolor( CorJanel + ',' + CorCampo )
      @ 11,24 say '   Emissão'
      @ 12,24 say 'Vencimento'
      @ 13,24 say '     Valor'
      
      yEmis  := Emis
      yVcto  := Vcto
      yValor := ( ( nValor + nJuro ) - nDesc ) - nPago
      
      @ 11,35 get yEmis        pict '99/99/9999' 
      @ 12,35 get yVcto        pict '99/99/9999' 
      @ 13,35 get yValor       pict '@E 999,999.99'
      read
      
      restscreen( 00, 00, 23, 79, tOutra )
      
      if lastkey() != K_ESC
        yComissao := ( yValor * ReprARQ->PerC ) / 100
        yParc     := val( right( cNota, 1 ) ) + 1 

        for nH := yParc to 9
          yNota   := left( Nota, 6 ) + strzero( nH, 2 )

          set order to 1 
          dbseek( yNota + cTipo, .f. )
          
          if found ()
            loop
          else
            exit
          endif
        next      
                    
        if AdiReg()
          if RegLock()
            replace Nota        with left( cNota, 6 ) + strzero( nH, 2 ) 
            replace Tipo        with cTipo
            replace Clie        with cClie
            replace Cliente     with cCliente
            replace Emis        with yEmis
            replace Vcto        with yVcto
            replace Valor       with yValor
            replace Acre        with nAcre
            replace Desc        with 0
            replace Port        with cPort
            replace Repr        with cRepr
            replace Cobr        with cCobr
            replace ReprComi    with yComissao 
            dbunlock ()
          endif  
        endif
      endif
    endif

    if EmprARQ->Caixa == "X" 
      cHist := iif( cClie == '999999', ReceARQ->Cliente, ClieARQ->Nome )
      
      DestLcto ()
    endif
  endif  
enddo

if vOpenClie
  select ClieARQ
  close
endif  

if vOpenRece
  select ReceARQ
  close
endif  

if vOpenPort
  select PortARQ
  close
endif  

if vOpenCobr
  select CobrARQ
  close
endif  

if vOpenRepr
  select ReprARQ
  close
endif  

return NIL

function CalcPago ()
  if Pago == 0
    nPago := nValor - nDesc + nJuro
  endif  
return(.t.)

//
// Entra Dados do Item
//
function EntrRcto ()
  if empty( dPgto )
    dPgto := date()
  endif  
  
  do while .t.
    lAlterou := .f.
    
    setcolor ( CorJanel + ',' + CorCampo )
    @ 09,23 get dPgto     pict '99/99/9999'           valid CalcJuro( 'R' ) 
    @ 09,55 get cDest
    @ 14,23 get nDesc     pict '@E 999,999,999.99'
    @ 14,55 get nJuro     pict '@E 999,999,999.99'  valid CalcPago ( )
  
    @ 15,23 get nPago     pict '@E 999,999,999.99'
    @ 16,23 get nPort     pict '999999'        valid ValidARQ( 16, 23, "ReceARQ", "Código" , "Port", "Descrição", "Nome", "Port", "nPort", .t., 6, "Consulta dos Portadores", "PortARQ", 40 )
    @ 17,23 get nRepr     pict '999999'        valid ValidARQ( 17, 23, "ReceARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nRepr", .t., 6, "Consulta dos Vendedores", "ReprARQ", 40 )
    @ 18,23 get nCobr     pict '999999'        valid ValidARQ( 18, 23, "ReceARQ", "Código" , "Cobr", "Descrição", "Nome", "Cobr", "nCobr", .t., 6, "Consulta dos Cobradores", "CobrARQ", 40 )
    read

    if dPgto     != Pgto;        lAlterou := .t.
    elseif cDest != Dest;        lAlterou := .t.
    elseif nDesc != Desc;        lAlterou := .t.
    elseif nJuro != Juro;        lAlterou := .t.
    elseif nPago != Pago;        lAlterou := .t.
    elseif nPort != val( Port ); lAlterou := .t.
    elseif nRepr != val( Repr ); lAlterou := .t.
    elseif nCobr != val( Cobr ); lAlterou := .t.
    endif
    
    if !Saindo (lAlterou)
      loop
    endif
    exit  
  enddo  

  cPort := strzero( nPort, 6 )
  cCobr := strzero( nCobr, 6 )
  cRepr := strzero( nRepr, 6 )
return NIL

//
// Imprimir Recibo
//
function PrinRcbo ()
  tPrt := savescreen( 00, 00, 23, 79 )
  
  if RegLock(0)
    replace Marc             with "X"
    dbunlock ()
  endif  
  
  Janela( 11, 22, 14, 57, mensagem( 'Janela', 'PrinRecibo', .f. ), .f. )
  Mensagem( 'Rcto','PrinRcbo')
  setcolor( CorJanel )
  @ 13,23 say '  Imprimir'
    
  aOpc := {}
  nPrn := 0

  aadd( aOpc, { ' Sim ',     2, 'S', 13, 34, "Imprimir Recibo." } )
  aadd( aOpc, { ' Não ',     2, 'N', 13, 40, "Não imprimir Recibo." } )
  aadd( aOpc, { ' Arquivo ', 2, 'A', 13, 46, "Gerar arquivo texto da impressão do Recibo." } )
    
  nTipoPedf := HCHOICE( aOpc, 3, 1 )
    
  do case
    case nTipoPedf == 1;      lReci := .t.
    case nTipoPedf == 2;      lReci := .f.
    case nTipoPedf == 3;      lReci := .t.
      Janela( 05, 21, 08, 56, mensagem( 'Janela', 'Salvar', .f. ), .f. )
      Mensagem( 'LEVE','Salvar')

      cArqu2  := CriaTemp( 5 )
      xArqu3  := right ( cArqu2, 8 )
  
      cArqTxt := cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() + alltrim( xArqu3 ) + ".txt" + space(40)
        
      keyboard( chr( K_END ) )

      setcolor ( CorJanel + ',' + CorCampo )
   
      @ 07,23 get cArqTxt           pict '@S32' 
      read
    
      if lastkey() == K_ESC
        return NIL
      endif  
  
      set printer to ( alltrim( cArqTxt ) )
      set device  to printer
      set printer on
  endcase     
  
  if lastkey() == K_ESC
    restscreen( 00, 00, 23, 79 )
    return NIL
  endif

  nReci  := EmprARQ->Reci + 1
  nCopia := EmprARQ->CopiaReci
  cData  := alltrim( EmprARQ->Cida ) + '(' + EmprARQ->UF + '), ' + strzero( day( date() ), 2 ) + ' de ' + alltrim( aMesExt[ month( date() ) ] ) + ' de' + str( year( date () ) )
  cNota  := Nota
  rClie  := Clie
  dPgto  := date()
     
  if lReci
    if nTipoPedF == 1
      if EmprARQ->Impr == "X"
        if !TestPrint( EmprARQ->Recibo )
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
  
        nTipoPedF := 3
      endif  
    endif    
      
    cNota := ''
   
    select ReceARQ
    set order to 8
    dbseek( rClie + "X", .f. )
    do while Marc == "X" .and. Clie == rClie
      for nH := 1 to nCopia
        setprc( 0, 0 )
         
        if nTipoPedF == 1
          @ 00, 00 say chr(27) + "@"
          @ 00, 00 say chr(18)
          @ 00, 00 say chr(27) + chr(67) + chr(33)
        endif  
 
        nLin  := 0
        if lCalcJuro
          nPago := ( Valor - Desc ) + VerJuro() 
        else  
          nPago := ( Valor - Desc )
        endif  

        cNota += Nota
  
        @ nLin,01 say EmprARQ->Razao
        if !empty( EmprARQ->CGC )
          @ nLin,50 say 'CNPJ'
          @ nLin,55 say EmprARQ->CGC             pict '@R 99.999.999/9999-99'
        endif 
        nLin ++
        @ nLin,01 say alltrim( EmprARQ->Ende ) + ' - ' + alltrim( EmprARQ->Bairro )
        if !empty( EmprARQ->InscEstd )
          @ nLin,51 say 'Insc. Estad. ' + alltrim( EmprARQ->InscEstd )
        endif  
        nLin ++
        @ nLin,01 say EmprARQ->Fone            
        nLin ++
        @ nLin,51 say alltrim( EmprARQ->Cida ) + ' - ' + EmprARQ->UF
        nLin ++
        @ nLin,01 say replicate( '-', 78 )
        nLin += 3
        @ nLin,35 say 'R E C I B O'
        @ nLin,70 say 'N. '
        @ nLin,73 say strzero( nReci, 6 )          pict '999999'
        nLin ++
        @ nLin,68 say 'Nota'
        @ nLin,73 say Nota                         pict '999999'
        nLin += 2
        @ nLin,62 say 'R$'
        @ nLin,65 say nPago                        pict '@E 999,999,999.99'
        nLin += 2
        @ nLin,04 say 'Recebi(emos) de '
        if rClie == '999999'
          @ nLin,20 say alltrim( Cliente ) + ' ' + rClie
        else  
          @ nLin,20 say alltrim( rNome ) + ' ' + rClie
        endif  
        @ nLin,64 say 'a importancia'
        nLin ++
        @ nLin,01 say 'de R$'
        @ nLin,07 say nPago                        pict '@E 999,999,999.99'
        @ nLin,22 say '('
  
        Extenso( nPago, 55, 55 ) 
    
        @ nLin,24 say cValorExt1
        nLin ++
        @ nLin,01 say cValorExt2
        @ nLin,57 say ').'
        nLin += 2

        cLinha1   := alltrim( EmprARQ->ReciTXT1 ) 
        nLen1     := len( cLinha1 )
        cLinha2   := alltrim( EmprARQ->ReciTXT2 ) 
        nLen2     := len( cLinha2 )        

        cNew1     := ''
        cNew2     := ''
        
        for nU := 1 to nLen1
          if substr( cLinha1, nU, 1 ) == "["
            cVariavel := substr( cLinha1, nU + 1, ( at( "]", substr( cLinha1, nU + 2 ) ) ) )
            cConteudo := (&cVariavel)
            do case
              case valtype( cConteudo ) == "D"
                cNew1 += dtoc( cConteudo )
              case valtype( cConteudo ) == "N"
                cNew1 += alltrim( str( cConteudo ) )
              otherwise
                cNew1 += ( cConteudo )
            endcase
            nU        += ( at( "]", substr( cLinha1, nU + 3 ) ) ) 
          else
            cNew1     += substr( cLinha1, nU, 1 )
          endif
        next
 
        for nU := 1 to nLen2
          if substr( cLinha2, nU, 1 ) == "["
            cVariavel := substr( cLinha2, nU + 1, ( at( "]", substr( cLinha2, nU + 2 ) ) ) )
            cConteudo := (&cVariavel)
            do case
              case valtype( cConteudo ) == "D"
                cNew2 += dtoc( cConteudo )
              case valtype( cConteudo ) == "N"
                cNew2 += alltrim( str( cConteudo ) )
              otherwise
                cNew2 += ( cConteudo )
            endcase
            nU        += ( at( "]", substr( cLinha2, nU + 3 ) ) ) 
          else
            cNew2     += substr( cLinha2, nU, 1 )
          endif
        next

        if empty( cNew1 )
          cNew1 := cLinha1
        endif
        if empty( cNew2 )
          cNew2 := cLinha2
        endif

        @ nLin,01 say cNew1
        nLin ++
        @ nLin,01 say cNew2
        
        nDife := rTotalGeral - nPago

        if nDife < 0
          nDife := 0
        endif

        nLin += 2
        
        if EmprARQ->ReciboTXT == "X"
          @ nLin,01 say 'Total da Nota '
          @ nLin,15 say rTotalGeral                  pict '999,999.99'
          nLin ++
          @ nLin,01 say '   Valor Pago '
          @ nLin,15 say nPago                        pict '999,999.99'
          nLin += 2
          @ nLin,01 say 'Saldo Devedor'
          @ nLin,15 say nDife                        pict '999,999.99'
          nLin += 2
        else
          nLin += 5 
        endif
     
        @ nLin,( 79 - len( cData ) ) say cData
        
        nLin += 3
        if !empty( ClieARQ->Ficha )
          @ nLin,01 say 'Ficha ' + alltrim( ClieARQ->Ficha )
        endif  
        @ nLin,38 say '____________________________________'
        nLin ++
        @ nLin,38 say alltrim( EmprARQ->Razao )
  
        nLin += 5

        if nTipoPedF == 1
          @ nLin, 00 say chr(27) + "@"
        endif  
    
        select EmprARQ
        if RegLock()
          replace Reci            with nReci
          dbunlock ()
        endif

        nReci ++
    
        select ReceARQ
      next
    
      dbskip ()
    enddo  
  endif

  set printer to
  set printer off
  set device  to screen
  
  select ReceARQ
  set order to 8
  dbseek( rClie + "X", .f. )
  do while Marc == "X" .and. Clie == rClie
    if lCalcJuro
      nJuro := VerJuro()
    else  
      nJuro := 0
    endif  

    nPago := ( Valor - Desc ) + nJuro
    
    if nPago > 0
      if RegLock()
        replace Pgto        with date ()
        replace Juro        with nJuro
        replace Pago        with nPago
        dbunlock()
      endif  
    endif
    dbskip ()
  enddo   
  
  do while .t.
    dbseek( "X", .f. )
    
    if found () 
      if RegLock()
        replace Marc         with space(01)
        dbunlock ()
      endif
    else
      exit
    endif    
  enddo      
  
  if EmprARQ->Caixa == "X" 
    cHist := iif( rClie == '999999', ReceARQ->Cliente, rNome )
            
    DestLcto ()
  endif

  if lReci
    if !empty( GetDefaultPrinter() ) .and. nPrn > 0
      PrnTest(aPrn[nPrn], memoread( cArqTxt ), .t. )
    endif  
  endif

  select ReceARQ
  set order to 1
   
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

//
// Imprimir Recibo - Imprimir Recibos com Valores
//
function EntrValo ()
  tPrt       := savescreen( 00, 00, 23, 79 )
  nValorPago := 0
  nPrn       := 0

  select ReceARQ
  set order to 8
  dbseek( rClie + "X", .f. )
  do while Marc == "X" .and. Clie == rClie
    nValorPago += ( ( Valor - Desc ) + VerJuro() )
    dbskip ()
  enddo  

  Janela( 06, 25, 09, 50, mensagem( 'Janela', 'EntrValo', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )
  @ 08, 27 say 'Valor Pago'
    
  @ 08,38 get nValorPago                   pict '@E 999,999.99'
  read
  
  if lastkey () == K_ESC .or. nValorPago == 0
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif  
  
  nPagos := nValorPago
  
  Janela( 11, 22, 14, 57, mensagem( 'LEVE', 'Recibo', .f. ), .f. ) 
  Mensagem( 'LEVE', 'PrinRecibo' )
  setcolor( CorJanel )
  @ 13,23 say '  Imprimir'
    
  aOpc := {}

  aadd( aOpc, { ' Sim ',     2, 'S', 13, 34, "Imprimir Recibo" } )
  aadd( aOpc, { ' Não ',     2, 'N', 13, 40, "Não imprimir Recibo" } )
  aadd( aOpc, { ' Arquivo ', 2, 'A', 13, 46, "Gerar arquivo texto da impressão do Recibo" } )
    
  nTipoPedf := HCHOICE( aOpc, 3, 1 )
    
  do case
    case nTipoPedf == 1;      lReci := .t.
    case nTipoPedf == 2;      lReci := .f.
    case nTipoPedf == 3;      lReci := .t.
      Janela( 05, 21, 08, 56, mensagem( 'Janela', 'Salvar', .f. ), .f. )
      Mensagem( 'LEVE','Salvar')

      cArqu2  := CriaTemp( 5 )
      xArqu3  := right ( cArqu2, 8 )
  
      cArqTxt := cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() + alltrim( xArqu3 ) + ".txt" + space(40)
        
      keyboard( chr( K_END ) )

      setcolor ( CorJanel + ',' + CorCampo )
   
      @ 07,23 get cArqTxt           pict '@S32' 
      read
    
      if lastkey() == K_ESC
        return NIL
      endif  
  
      set printer to ( alltrim( cArqTxt ) )
      set device  to printer
      set printer on
  endcase     

  if lReci
    if nTipoPedF == 1
      if EmprARQ->Impr == "X"
        if !TestPrint( EmprARQ->Recibo )
          restscreen( 00, 00, 23, 79, tPrt )
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
  
      nTipoPedF := 2

      
      endif  
    endif
  endif  

  pTotalNota := 0
  aNotas     := {}

  select ReceARQ
  set order to 8
  dbseek( "X", .f. )
  if found ()
    lMarc := .t.
  
    do while Marc == "X"
      if empty( Pgto )
        if lCalcJuro
          nJuro    := VerJuro ()
        else 
          nJuro    := 0
        endif    
        pTotalNota += ( Valor + nJuro )
      endif     
    
      dbskip ()
    enddo  
  else
    lMarc := .f.
  
    set order to 5
    dbseek( rClie, .t. )
  
    do while Clie == rClie
      if empty( Pgto )
        if lCalcJuro
          nJuro    := VerJuro ()
        else
          nJuro    := 0 
        endif   
        pTotalNota += ( Valor + nJuro )
      endif     
    
      dbskip ()
    enddo  
  endif  
  
  if lMarc  
    dbseek( "X", .f. )
    do while Marc == "X" .and. !eof()
      if empty( Pgto )
        if lCalcJuro 
          nJuro := VerJuro ()
        else
          nJuro := 0
        endif   
      
        if nValorPago >= ( Valor + nJuro ) 
          cTipo := Tipo
          dEmis := Emis
          dVcto := Vcto
        
          aadd( aNotas, { Nota + cTipo, Valor + nJuro } )
  
          nValorPago -= ( Valor + nJuro )
        else
          nNota  := val( Nota )
          cTipo  := Tipo
          cNota  := Nota
          dEmis  := Emis
          dVcto  := Vcto
          nAcre  := Acre
          cPort  := Port
          cRepr  := Repr
          nValor := Valor
        
          if dVcto > date ()
            xVcto := dVcto
          else  
            xVcto := date ()
          endif
          
          if lCalcJuro
            nJuro   := VerJuro ()
          else
            nJuro   := 0
          endif    
          
          nReprComi := ( ( ( nValor + nJuro ) - nValorPago ) * ReprARQ->PerC ) / 100
          nResto    := ( nValor + nJuro ) - nValorPago 
         
          aadd( aNotas, { Nota + Tipo, nValorPago } )
          
          nParcela  := 1
          nValoPago := 0
            
          set order to 1
          do while .t.
            xNota := strzero( val( cNota ) + nParcela, 8 )
            
            dbseek( xNota + cTipo, .f. )
             
            if eof()
              exit
            endif
            
            nParcela ++
          enddo    
          
          if nResto > 0
            if AdiReg()
              if RegLock()
                replace Nota      with xNota
                replace Tipo      with cTipo
                replace Clie      with rClie
                replace Emis      with dEmis
                replace Vcto      with xVcto
                replace Valor     with nResto
                replace ReprComi  with nReprComi
                replace Acre      with nAcre
                replace Juro      with 0
                replace Desc      with 0
                replace Port      with cPort
                replace Repr      with cRepr
                dbunlock()
              endif
            endif
          endif  
          exit
        endif  
      endif  
  
      dbskip ()
    enddo
  else  
    dbseek( rClie, .t. )
    do while Clie == rClie
      if empty( Pgto )
        if lCalcJuro
          nJuro := VerJuro ()
        else
          nJuro := 0
        endif    
      
        if nValorPago >= ( Valor + nJuro ) 
          cTipo := Tipo
          dEmis := Emis
          dVcto := Vcto
        
          aadd( aNotas, { Nota + cTipo, Valor + nJuro } )
  
          nValorPago -= ( Valor + nJuro )
        else
          nNota  := val( Nota )
          cTipo  := Tipo
          cNota  := Nota
          dEmis  := Emis
          dVcto  := Vcto
          nAcre  := Acre
          cPort  := Port
          cRepr  := Repr
          nValor := Valor
        
          if dVcto > date ()
            xVcto := dVcto
          else  
            xVcto := date ()
          endif
          
          if lCalcJuro
            nJuro   := VerJuro ()
          else
            nJuro   := 0
          endif
              
          nReprComi := ( ( ( nValor + nJuro ) - nValorPago ) * ReprARQ->PerC ) / 100
          nResto    := ( nValor + nJuro ) - nValorPago 
         
          aadd( aNotas, { Nota + Tipo, nValorPago } )
          
          nParcela  := 1
          nValoPago := 0
            
          set order to 1
          do while .t.
            xNota := strzero( val( cNota ) + nParcela, 8 )
            
            dbseek( xNota + cTipo, .f. )
             
            if eof()
              exit
            endif
            
            nParcela ++
          enddo    
            
          if nResto > 0  
            if AdiReg()
              if RegLock()
                replace Nota      with xNota
                replace Tipo      with cTipo
                replace Clie      with rClie
                replace Emis      with dEmis
                replace Vcto      with xVcto
                replace Valor     with nResto
                replace ReprComi  with nReprComi
                replace Acre      with nAcre
                replace Juro      with 0
                replace Desc      with 0
                replace Port      with cPort
                replace Repr      with cRepr
                dbunlock()
              endif  
            endif
          endif  
          exit
        endif  
      endif  
  
      dbskip ()
    enddo
  endif  
  
  pTotalDife := pTotalNota - nPagos
  nReci      := EmprARQ->Reci + 1
  nCopia     := EmprARQ->CopiaReci
  cNota      := strzero( nReci, 6 )
  dPgto      := date()
  
  if lReci
    for nJ := 1 to nCopia
      setprc( 0, 0 )

      if nTipoPedF == 1
        @ 00, 00 say chr(27) + "@"
        @ 00, 00 say chr(18)
        @ 00, 00 say chr(27) + chr(67) + chr(33)
      endif  

      nLin := 0

      @ nLin,01 say EmprARQ->Razao
      if !empty( EmprARQ->CGC )
        @ nLin,50 say 'CNPJ'
        @ nLin,55 say EmprARQ->CGC             pict '@R 99.999.999/9999-99'
      endif  
      nLin ++
      @ nLin,01 say alltrim( EmprARQ->Ende ) + ' - ' + alltrim( EmprARQ->Bairro )
      if !empty( EmprARQ->InscEstd )
        @ nLin,51 say 'Insc. Estad. ' + alltrim( EmprARQ->InscEstd )
      endif  
      nLin ++
      @ nLin,01 say EmprARQ->Fone            
      nLin ++
      @ nLin,51 say alltrim( EmprARQ->Cida ) + ' - ' + EmprARQ->UF
      nLin ++
      @ nLin,01 say replicate( '-', 78 )
      nLin += 3
      @ nLin,35 say 'R E C I B O'
      @ nLin,70 say 'N. '
      @ nLin,73 say strzero( nReci, 6 )          pict '999999'
      nLin += 3
      @ nLin,62 say 'R$'
      @ nLin,65 say nPagos                       pict '@E 999,999,999.99'
      nLin += 2
      @ nLin,04 say 'Recebi(emos) de '
      @ nLin,20 say alltrim( rNome ) + ' ' + rClie
      @ nLin,64 say 'a importancia'
      nLin ++
      @ nLin,01 say 'de R$'
      @ nLin,07 say nPagos                       pict '@E 999,999,999.99'
      @ nLin,22 say '('
  
      Extenso( nPagos, 55, 55 )
    
      @ nLin,24 say cValorExt1
      nLin ++
      @ nLin,01 say cValorExt2
      @ nLin,57 say ').'
      nLin   += 2
      @ nLin,01 say 'Referente as notas abaixo:'
      nLin   += 3
      nCol   := 37
      nSalto := 2
      lLinha := .f.
      
      @ nLin,01 say '  Valor Total '
      @ nLin,15 say pTotalNota                   pict '999,999.99'
      @ nLin,31 say 'Notas '
      
      for nH := 1 to len( aNotas )  
        @ nLin, nCol say val( left( aNotas[ nH, 1 ], 8 ) )  pict '999999-99'  

        nCol += 10
        
        if nCol > 69
          nCol   := 37
          nLin   ++ 
          lLinha := .t.
          nSalto --
        endif
      next
      
      if !lLinha
        nLin ++
      endif  
     
      @ nLin,01 say '   Valor Pago '
      @ nLin,15 say nPagos                       pict '999,999.99'
      nLin += 2
      @ nLin,01 say 'Saldo Devedor'
      @ nLin,15 say pTotalDife                   pict '999,999.99'
      nLin ++
      
      cData := alltrim( EmprARQ->Cida ) + '(' + EmprARQ->UF + '), ' + strzero( day( date() ), 2 ) + ' de ' + alltrim( aMesExt[ month( date() ) ] ) + ' de' + str( year( date() ) )
      
      @ nLin,( 79 - len( cData ) ) say cData
     
      nLin += 3
      if !empty( ClieARQ->Ficha )
        @ nLin,01 say 'Ficha ' + alltrim( ClieARQ->Ficha )
      endif  
      @ nLin,38 say '____________________________________'
      nLin ++
      @ nLin,38 say alltrim( EmprARQ->Razao )
      nLin += 6

      if nTipoPedF == 1
        @ nLin,00 say chr(27) + '@' 
      endif  

      select EmprARQ
      if RegLock()
        replace Reci    with nReci
        dbunlock ()
      endif
    
      nReci ++
    
      select EmprARQ
    next  
  endif  
  
  set printer to
  set printer off
  set device  to screen

  for nH := 1 to len( aNotas )  
    select ReceARQ
    set order to 1
    dbseek( aNotas[ nH, 1 ], .f. )
    if found ()
      if RegLock()
        replace Marc          with space(01)
        replace Pgto          with date ()
        replace Pago          with aNotas[ nH, 2 ]
        dbunlock ()
      endif
    endif    
    
    if EmprARQ->Caixa == "X" .and. found()
      nPago := aNotas[ nH, 2 ]
      cNota := aNotas[ nH, 1 ]
      dPgto := date()
      cHist := iif( rClie == '9999', ReceARQ->Cliente, rNome )
       
      DestLcto ()    
    endif    
  next
    
  select ReceARQ
  set order to 8
  dbgotop()
  do while .t.
    dbseek( "X", .f. )
    
    if found () 
      if RegLock()
        replace Marc         with space(01)
        dbunlock ()
      endif
    else
      exit
    endif    
  enddo      
  
  if lReci   
    if !empty( GetDefaultPrinter() ) .and. nPrn > 0
      PrnTest(aPrn[nPrn], memoread( cArqTxt ), .t. )
    endif
  endif  

  
  select ReceARQ
  set order to 5
   
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

//
// Imprimir o Faturamento do Dia 
//
function PrinFatu ( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "ReceARQ", .t. )
    VerifIND( "ReceARQ" )

    #ifdef DBF_NTX
      set index to ReceIND1, ReceIND2, ReceIND3
    #endif
  endif

  if NetUse( "NSaiARQ", .t. )
    VerifIND( "NSaiARQ" )
  
    #ifdef DBF_NTX
      set index to NSaiIND1, NSaiIND2, NSaiIND3, NSaiIND4
    #endif
  endif

  if NetUse( "EnOSARQ", .t. )
    VerifIND( "EnOSARQ" )
  
    #ifdef DBF_NTX
      set index to EnOSIND1
    #endif
  endif

  if NetUse( "PediARQ", .t. )
    VerifIND( "PediARQ" )
  
    #ifdef DBF_NTX
      set index to PediIND1, PediIND2, PediIND3, PediIND4
    #endif
  endif

  if NetUse( "CondARQ", .t. )
    VerifIND( "CondARQ" )

    #ifdef DBF_NTX
      set index to CondIND1, CondIND2
    #endif
  endif

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )
  
    #ifdef DBF_NTX
      set index to ClieIND1
    #endif
  endif

  if NetUse( "ReprARQ", .t. )
    VerifIND( "ReprARQ" )
  
    #ifdef DBF_NTX
      set index to ReprIND1
    #endif
  endif

  tPrt := savescreen( 00, 00, 23, 79 )

  Janela ( 04, 12, 12, 70, mensagem( 'Janela', 'PrinFatu', .f. ), .f.)
  Mensagem( 'Rcto','PrinFatu')

  setcolor ( CorJanel + ',' + CorCampo )
  @ 06,14 say '   Emissão Inicial             Emissão Final'
  @ 07,14 say '      Hora Inicial                Hora Final'
  @ 08,14 say '   Cliente Inicial             Cliente Final'
  @ 09,14 say '  Vendedor Inicial            Vendedor Final'
  @ 11,14 say '            Vendas'
  
  setcolor( CorCampo )
  @ 11,33 say ' Ambas   '

  setcolor ( 'w+/n' )
  @ 11,43 say chr(25)
  
  select ReprARQ
  set order to 1
  dbgotop()
  nReprIni := val( Repr )
  dbgobottom()
  nReprFin := val( Repr )

  select ClieARQ
  set order to 1

  select NSaiARQ
  set order to 1
  
  dDataIni  := date()
  dDataFin  := date() 
  nClieIni  := 1
  nClieFin  := 999999
  cHoraIni  := '00:00'
  cHoraFin  := '23:59'
  cProd     := space(04)

  setcolor ( CorJanel + ',' + CorCampo )
  @ 06,33 get dDataIni           pict '99/99/9999'
  @ 06,59 get dDataFin           pict '99/99/9999' valid dDataFin >= dDataIni
  @ 07,33 get cHoraIni           pict '99:99'    valid ValidHora( cHoraIni, "cHoraIni" )
  @ 07,59 get cHoraFin           pict '99:99'    valid ValidHora( cHoraFin, "cHoraFin" ) .and. cHoraFin > cHoraIni
  @ 08,33 get nClieIni           pict '999999'     valid ValidClie( 99, 99, "ClieARQ", "nClieIni" )
  @ 08,59 get nClieFin           pict '999999'     valid ValidClie( 99, 99, "ClieARQ", "nClieFin" ) .and. nClieFin >= nClieIni 
  @ 09,33 get nReprIni           pict '999999'     valid ValidARQ( 99, 99, "ReprARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprIni", .t., 6, "Consulta dos Vendedores", "ReprARQ", 40 )  
  @ 09,59 get nReprFin           pict '999999'     valid ValidARQ( 99, 99, "ReprARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprFin", .t., 6, "Consulta dos Vendedores", "ReprARQ", 40 ) .and. nReprFin >= nReprIni 
  read
  
  if lastkey() == K_ESC
    select NSaiARQ
    close
    select EnOSARQ
    close
    select PediARQ
    close
    select CondARQ
    close
    select ReceARQ
    close
    select ClieARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  aOpc := {}

  aadd( aOpc, { ' Nota    ', 2, 'N', 11, 33, "Faturamento das Notas Fiscais." } )
  aadd( aOpc, { ' Pedido  ', 2, 'P', 11, 33, "Faturamento dos Pedidos." } )
  aadd( aOpc, { ' OS      ', 2, 'C', 11, 33, "Faturamento das Ordem de Serviços." } )
  aadd( aOpc, { ' Ambas   ', 2, 'A', 11, 33, "Faturamento Geral." } )
   
  nTipo := HCHOICE( aOpc, 4, 4 )
    
  if lastkey () == K_ESC
    select NSaiARQ
    close
    select EnOSARQ
    close
    select PediARQ
    close
    select CondARQ
    close
    select ReceARQ
    close
    select ClieARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  Aguarde ()
      
  nPag        := 1
  nLin        := 0
  cArqu2      := cArqu2 + "." + strzero( nPag, 3 )
  lCond       := .f.
  aCond       := {}

  cClieIni    := strzero( nClieIni, 6 )
  cClieFin    := strzero( nClieFin, 6 )
  cReprIni    := strzero( nReprIni, 6 )
  cReprFin    := strzero( nReprFin, 6 )

  nFundoTroco := nReceDesc   := 0
  nTotalGeral := nTotalPago  := nTotalCond  := nTotalVista := 0
  nVistaDesc  := nTotalPrazo := nPrazoSubT  := nPrazoDesc  := 0
  nTotalDesc  := nVistaSubT  := nTotalCusto := nTotalVenda := 0
  nPercVista  := nPercPrazo  := nPgto       := nTotalEntra := 0  
  nTotalJuro  := nVistaJuro  := nPrazoJuro  := 0

  if nTipo == 2 .or. nTipo == 4
    select NSaiARQ
    set order    to 4
    set relation to Cond into CondARQ
    dbseek( dtos( dDataIni ), .t. )
    do while Emis >= dDataIni .and. Emis <= dDataFin .and. !eof ()
      if Clie        >= cClieIni .and. Clie        <= cClieFin .and.;
         val( Repr ) >= nReprIni .and. val( Repr ) <= nReprFin .and.;
         Hora        >= cHoraIni .and. Hora        <= cHoraFin

        nSubTotal   := SubTotal
        nDesconto   := Desconto
        nJuros      := ( CondARQ->Acrs * ( nSubTotal - nDesconto ) ) / 100
        nTotalVenda += SubTotal
        
        if nSubTotal > 0  
          cCond     := Cond
          nCondElem := ascan( aCond, { |nElem| nElem[1] == cCond } )
          
          if CondARQ->Acrs > 0
            nSubtotal += ( ( nSubTotal * CondARQ->Acrs ) / 100 )
          endif  
      
          if nCondElem > 0
            aCond[ nCondElem, 2 ] += nSubTotal
            aCond[ nCondElem, 3 ] += nDesconto
            aCond[ nCondElem, 4 ] += ( nSubTotal - nDesconto )
            aCond[ nCondElem, 5 ] += nJuros
          else
            aadd( aCond, { cCond, nSubTotal, nDesconto, ( nSubTotal - nDesconto ), nJuros } )    
          endif    
        endif     
      endif  
    
      dbskip ()
    enddo  
  endif  
  
  if nTipo == 3 .or. nTipo == 4
    select EnOSARQ
    set order    to 1
    set relation to Cond into CondARQ
    dbgotop()
    do while !eof ()
      if Clie        >= cClieIni .and. Clie        <= cClieFin .and.;
         val( Repr ) >= nReprIni .and. val( Repr ) <= nReprFin .and.;
         Term        >= dDataIni .and. Term        <= dDataFin .and.;
         Receber
        
        nSubTotal   := nTotalNota - Desconto
        nDesconto   := Desconto
        nTotalVenda += nSubTotal
        
        if nSubTotal > 0  
          cCond     := Cond
          nCondElem := ascan( aCond, { |nElem| nElem[1] == cCond } )
          
          if CondARQ->Acrs > 0
            nSubtotal += ( ( nSubTotal * CondARQ->Acrs ) / 100 )
          endif  
      
          if nCondElem > 0
            aCond[ nCondElem, 2 ] += nSubTotal
            aCond[ nCondElem, 3 ] += nDesconto
            aCond[ nCondElem, 4 ] += ( nSubTotal - nDesconto )
          else
            aadd( aCond, { cCond, nSubTotal, nDesconto, ( nSubTotal - nDesconto ), nJuros } )    
          endif    
        endif     
      endif  
    
      dbskip ()
    enddo  
  endif  
  
  if nTipo == 1 .or. nTipo == 4
    select PediARQ
    set order    to 4
    set relation to Cond into CondARQ
    dbseek( dtos( dDataIni ), .t. )
    do while Emis >= dDataIni .and. Emis <= dDataFin .and. !eof ()
      if Clie        >= cClieIni .and. Clie        <= cClieFin .and.;
         val( Repr ) >= nReprIni .and. val( Repr ) <= nReprFin .and.;
         Hora        >= cHoraIni .and. Hora        <= cHoraFin
         
         nTotalNota  := TotalNota
         nDesconto   := Desconto
         nJuros      := 0
         nTotalVenda += ( nTotalNota - nDesconto )
        
        if nTotalNota > 0
          cCond      := Cond
          nCondElem  := ascan( aCond, { |nElem| nElem[1] == cCond } )
          
          if CondARQ->Acrs > 0
            nTotalNota += ( ( nTotalNota * CondARQ->Acrs ) / 100 )
          endif  
               
          if nCondElem > 0
            aCond[ nCondElem, 2 ] += nTotalNota
            aCond[ nCondElem, 3 ] += nDesconto
            aCond[ nCondElem, 4 ] += ( nTotalNota - nDesconto )
            aCond[ nCondElem, 5 ] += nJuros
          else
            aadd( aCond, { cCond, nTotalNota, nDesconto, ( nTotalNota - nDesconto ), nJuros } )   
          endif    
        endif  
      endif  
      dbskip ()
    enddo  
  endif  
  
  select ReceARQ
  set order to 3
  dbgotop()
  do while !eof()
    if Pgto >= dDataIni .and. Pgto <= dDataFin .and. !empty( Pgto )

    if Emis == Pgto
      nTotalEntra += Pago
      
      dbskip ()
      loop
    endif
    
    do case 
      case nTipo == 1
        if Tipo != 'N'
          dbskip ()
          loop
        endif  
      case nTipo == 2
        if Tipo != 'P'
          dbskip ()
          loop
        endif  
      case nTipo == 3
        if Tipo != 'C'
          dbskip ()
          loop
        endif  
   endcase         
      nReceDesc  += Desc   
      nTotalPago += Pago
      nTotalJuro += Juro
    endif    
    dbskip ()
  enddo 

  if len( aCond ) > 0
    set printer to ( cArqu2 )
    set device  to printer
    set printer on
  
    do case
      case nTipo == 1
        Cabecalho( 'Faturamento - Notas - ' + dtoc( dDataIni ) + ' a ' + dtoc( dDataFin ), 132, 3 )
      case nTipo == 2
        Cabecalho( 'Faturamento - Pedidos - ' + dtoc( dDataIni ) + ' a ' + dtoc( dDataFin ), 132, 3 )
      case nTipo == 3
        Cabecalho( 'Faturamento - OS - ' + dtoc( dDataIni ) + ' a ' + dtoc( dDataFin ), 132, 3 )
      case nTipo == 4
        Cabecalho( 'Faturamento - ' + dtoc( dDataIni ) + ' a ' + dtoc( dDataFin ), 132, 3 )
    endcase    
  
    select CondARQ    
    set order to 1
    nLin += 3
    @ nLin,01 say 'Condiç”es Pagamento'
    @ nLin,26 say ' Sub-Total   Desconto      Juros   V. Total'
    nLin ++
    @ nLin,01 say '-----------------------------------------------------------------------------'
    nLin ++
     
    for nI := 1 to len( aCond )
      nTotalCond += aCond[ nI, 4 ]
    next
      
    for nI := 1 to len( aCond )
      cCond  := aCond[ nI, 1 ]
        
      dbseek( cCond, .f. ) 

      nSubTotal := aCond[ nI, 2 ]
      nDesconto := aCond[ nI, 3 ]
      nTotal    := aCond[ nI, 4 ]
      nJuros    := aCond[ nI, 5 ]
      
      if nTotal == 0
        loop
      endif 
      
      if nTotalCond == 0
        nPerc := 0 
      else
        nPerc := ( nTotal * 100 ) / nTotalCond
      endif   
      
      if CondARQ->Vct1 == 0 .and. CondARQ->Vct2 == 0 .and. CondARQ->Vct3 == 0  
        nVistaSubT  += nSubTotal
        nVistaDesc  += nDesconto
        nVistaJuro  += nJuros
        nTotalVista += nTotal
        nPercVista  += nPerc
      else
        nPrazoSubT  += nSubTotal
        nPrazoDesc  += nDesconto
        nPrazoJuro  += nJuros
        nTotalPrazo += nTotal
        nPercPrazo  += nPerc
      endif  
        
      @ nLin,01 say cCond              pict '999999'
      @ nLin,08 say Nome               pict '@S16'
      @ nLin,26 say ( nSubTotal ) - ( nJuros ) - ( nDesconto )    pict '@E 999,999.99'
      @ nLin,37 say nDesconto          pict '@E 999,999.99'
      @ nLin,48 say nJuros             pict '@E 999,999.99'
      @ nLin,59 say nTotal             pict '@E 999,999.99'
      @ nLin,70 say nPerc              pict '@E 999.99'
      @ nLin,77 say '%'
      nLin ++
    next  
   
    nRecebido := nTotalPago
    nPago     := 0 
   
    @ nLin,01 say '-----------------------------------------------------------------------------'
    nLin ++
    @ nLin,11 say 'Total a Vista'
    @ nLin,26 say nVistaSubT         pict '@E 999,999.99'
    @ nLin,37 say nVistaDesc         pict '@E 999,999.99'
    @ nLin,48 say nVistaJuro         pict '@E 999,999.99'
    @ nLin,59 say nTotalVista        pict '@E 999,999.99'
    @ nLin,70 say nPercVista         pict '@E 999.99'
    nLin ++
    @ nLin,11 say 'Total a Prazo'
    @ nLin,26 say nPrazoSubT         pict '@E 999,999.99'
    @ nLin,37 say nPrazoDesc         pict '@E 999,999.99'
    @ nLin,48 say nPrazoJuro         pict '@E 999,999.99'
    @ nLin,59 say nTotalPrazo        pict '@E 999,999.99'
    @ nLin,70 say nPercPrazo         pict '@E 999.99'
    nLin += 2 
    @ nLin,11 say '  Total Geral'
    @ nLin,26 say nPrazoSubT + nVistaSubT      pict '@E 999,999.99'
    @ nLin,37 say nPrazoDesc + nVistaDesc      pict '@E 999,999.99'
    @ nLin,48 say nVistaJuro + nPrazoJuro      pict '@E 999,999.99'
    @ nLin,59 say nTotalPrazo + nTotalVista    pict '@E 999,999.99'
    @ nLin,70 say nPercPrazo + nPercVista      pict '@E 999.99'
    
    nLin ++
    @ nLin,01 say '-----------------------------------------------------------------------------'
    nLin += 2   
    @ nLin,08 say '   Total Entrada'
    @ nLin,26 say nTotalEntra - nTotalVista    pict '@E 999,999.99'
    nLin ++
    @ nLin,08 say 'Contas Recebidas'
    @ nLin,26 say nRecebido - nTotalJuro    pict '@E 999,999.99'
    @ nLin,37 say nReceDesc                 pict '@E 999,999.99'
    @ nLin,48 say nTotalJuro                pict '@E 999,999.99'
    @ nLin,59 say nRecebido                 pict '@E 999,999.99'
    nLin += 2
    @ nLin,13 say 'Total Caixa'
    @ nLin,26 say ( ( nRecebido + nTotalVista ) + ( nTotalEntra - nTotalVista ) ) pict '@E 999,999.99'

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
        case nTipo == 1
          replace Titu       with "Relatório do Faturamento - Nota"
        case nTipo == 2
          replace Titu       with "Relatório do Faturamento - Pedido"
        case nTipo == 3
          replace Titu       with "Relatório do Faturamento - O.S."
        case nTipo == 4
          replace Titu       with "Relatório do Faturamento"
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

  select NSaiARQ
  close
  select EnOSARQ
  close
  select PediARQ
  close
  select CondARQ
  close
  select ReceARQ
  close
  select ClieARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

//
// Imprime Nota Promissoria dos Clientes
//
function PrinNoPr ()

  if NetUse( "PortARQ", .t. )
    VerifIND( "PortARQ" )
  
    #ifdef DBF_NTX
      set index to PortIND1, PortIND2
    #endif
  endif

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )
  
    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2
    #endif
  endif

  if NetUse( "ReprARQ", .t. )
    VerifIND( "ReprARQ" )

    #ifdef DBF_NTX
      set index to ReprIND1, ReprIND2
    #endif
  endif

  if NetUse( "ReceARQ", .t. )
    VerifIND( "ReceARQ" )
  
    #ifdef DBF_NTX
      set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
    #endif
  endif

  if NetUse( "CampARQ", .t. )
    VerifIND( "CampARQ" )
  
    #ifdef DBF_NTX
      set index to CampIND1, CampIND2
    #endif
  endif

  if NetUse( "NoPrARQ", .t. )
    VerifIND( "NoPrARQ" )
  
    #ifdef DBF_NTX
      set index to NoPrIND1
    #endif
  endif

  tPrt := savescreen( 00, 00, 23, 79 ) 

  Janela( 05, 01, 20, 76, mensagem( 'Janela', 'PrinNoPr', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )
  
  select ReceARQ
  set order    to 7
  set relation to Clie into ClieARQ
  
  oNota         := TBrowseDB( 07, 02, 18, 75 )
  oNota:headsep := chr(194)+chr(196)
  oNota:colsep  := chr(179)
  oNota:footsep := chr(193)+chr(196)

  oNota:addColumn( TBColumnNew(" ",          {|| Marc } ) )
  oNota:addColumn( TBColumnNew("Nota",       {|| left( Nota, 6 ) + '-' + right( Nota, 2 ) } ) )
  oNota:addColumn( TBColumnNew("Tipo",       {|| iif( Tipo == 'P', 'Pedido', iif( Tipo == 'N', 'Nota  ', iif( Tipo == 'O', 'O.S.   ', '       ' ) ) ) } ) )
  oNota:addColumn( TBColumnNew("Cliente",    {|| iif( Clie == '999999', left( Cliente, 14 ), left( ClieARQ->Nome, 14 ) ) } ) )
  oNota:addColumn( TBColumnNew("Código" ,       {|| Clie } ) )
  oNota:addColumn( TBColumnNew("Emissão",    {|| Emis } ) )
  oNota:addColumn( TBColumnNew("Vcto.",      {|| Vcto } ) )
  oNota:addColumn( TBColumnNew("Valor Nota", {|| transform( Valor, '@E 99,999.99' ) } ) )
  oNota:addColumn( TBColumnNew("Pgto.",      {|| Pgto } ) )
  oNota:addColumn( TBColumnNew("Repr.",      {|| Repr } ) )
              
  oNota:gobottom()
  
  lExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ''
  nTotal         := lastrec()
  nTotalNota     := 0
  nOrdem         := 7
  BarraSeta      := BarraSeta( nLinBarra, 8, 18, 76, nTotal )
  
  setcolor( CorJanel + ',' + CorCampo )
  @ 08,01 say chr(195) 
  @ 18,01 say chr(195) 
  @ 19,05 say 'Consulta'
  @ 19,47 say 'Total Nota'
  
  setcolor( CorCampo )
  @ 19,14 say space(30)
  @ 19,58 say nTotalNota           pict '@E 999,999.99'

  do while !lExitRequested
    Mensagem( 'Rcto', 'PrinNoPr1' ) 
    
    oNota:forcestable() 

    iif( BarraSeta, BarraSeta( nLinBarra, 8, 18, 76, nTotal ), NIL )
    
    if oNota:stable
      if oNota:hitTop .or. oNota:hitBottom
        tone( 125, 0 )        
      endif  
            
      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oNota:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oNota:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oNota:down()
      case cTecla == K_UP;         oNota:up()
      case cTecla == K_PGDN;       oNota:pageDown()
      case cTecla == K_PGUP;       oNota:pageUp()
      case cTecla == K_RIGHT;      oNota:right()
      case cTecla == K_LEFT;       oNota:left()
      case cTecla == K_CTRL_PGDN;  oNota:gobottom()
      case cTecla == K_CTRL_PGUP;  oNota:goTop()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_SPACE
        if empty( Marc )
          if RegLock()
            replace Marc       with "X"
            dbunlock ()
          endif
          
          nTotalNota += Valor
        else   
          if RegLock()
            replace Marc       with ' '
            dbunlock ()
          endif
  
          nTotalNota -= Valor
        endif  
        
        if nTotalNota < 0
          nTotalNota := 0
        endif  
       
        setcolor( CorCampo ) 
        @ 19,58 say nTotalNota           pict '@E 999,999.99'
 
        oNota:refreshall()
      case cTecla == K_ENTER
        if empty( Marc )
          nTotalNota += Valor
        endif 
       
        setcolor( CorCampo ) 
        @ 19,58 say nTotalNota           pict '@E 999,999.99'
      
        if RegLock()
          replace Marc       with "X"
          dbunlock ()
        endif

        oNota:refreshall()
  
        lExitRequested := .t.  
      case cTecla == K_TAB
        nOrdem ++

        if nOrdem > 7
          nOrdem := 1
        endif  
        
        set order to nOrdem
        
        do case
          case nOrdem == 1
            cTitu := 'Seleção de Nota Promissória por Nota'
          case nOrdem == 2
            cTitu := 'Seleção de Nota Promissória por Vencimento'
          case nOrdem == 3
            cTitu := 'Seleção de Nota Promissória por Pagamento'
          case nOrdem == 4
            cTitu := 'Seleção de Nota Promissória por Cliente e Vcto.'
          case nOrdem == 5
            cTitu := 'Seleção de Nota Promissória por Cliente e Pgto.'
          case nOrdem == 6
            cTitu := 'Seleção de Nota Promissória por Vendedor'
          case nOrdem == 7
            cTitu := 'Seleção de Nota Promissória por Emissão'
        endcase    

        setcolor( CorCabec )
        @ 05, 05 say space(68)
        @ 05, 05 + ( ( 66 - len ( cTitu ) ) / 2 ) say cTitu

        oNota:refreshAll()
      case cTecla == K_BS
        cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
      
        setcolor ( CorCampo )
        @ 19,14 say space(32)
        @ 19,14 say cLetra
      case cTecla >= 32 .and. cTecla <= 128
        cLetra += chr( cTecla )    

        if len( cLetra ) > 32
          cLetra := ''
        endif  
     
        setcolor ( CorCampo )
        @ 19,14 say space(32)
        @ 19,14 say cLetra
        
        if nOrdem == 2 .or. nOrdem == 3 .or. nOrdem == 7        
          dbseek( dtos( ctod( cLetra ) ), .t. )
        else
          dbseek( cLetra, .t. )
        endif  
        oNota:refreshAll()
    endcase
  enddo  
  
  if lastkey() == K_ESC
    select ReceARQ
    set order to 8
    dbgotop ()
    do while .t.
      dbseek( "X", .f. )
    
      if eof ()
        exit
      else  
        if RegLock()
          replace Marc       with space(01)
          dbunlock ()
        endif
      endif
    enddo      
    select ReprARQ
    close
    select PortARQ
    close
    select ClieARQ
    close
    select ReceARQ
    close
    select NoPrARQ
    close
    select CampARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  select NoPrARQ
  set order to 1
  dbseek( EmprARQ->NoPr, .f. )

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
    Alerta( mensagem( 'Alerta', 'PrinNoPr', .f. ) ) 

    select ReceARQ
    set order to 8
    dbgotop ()
    do while .t.
      dbseek( "X", .f. )
    
      if eof ()
        exit
      else  
        if RegLock()
          replace Marc       with space(01)
          dbunlock ()
        endif
      endif
    enddo      
    select ReprARQ
    close
    select PortARQ
    close
    select ClieARQ
    close
    select ReceARQ
    close
    select CampARQ
    close
    select NoPrARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  private aDias[31] 
    
  aDias[01] := 'PRIMEIRO '
  aDias[02] := 'SEGUNDO '
  aDias[03] := 'TERCEIRO '
  aDias[04] := 'QUARTO '
  aDias[05] := 'QUINTO '
  aDias[06] := 'SEXTO '
  aDias[07] := 'SETIMO '
  aDias[08] := 'OITAVO '
  aDias[09] := 'NONO '
  aDias[10] := 'DECIMO '
  aDias[11] := 'DECIMO PRIMEIRO '
  aDias[12] := 'DECIMO SEGUNDO '
  aDias[13] := 'DECIMO TERCEIRO '
  aDias[14] := 'DECIMO QUARTO '
  aDias[15] := 'DECIMO QUINTO '
  aDias[16] := 'DECIMO SEXTO '
  aDias[17] := 'DECIMO SETIMO '
  aDias[18] := 'DECIMO OITAVO '
  aDias[19] := 'DECIMO NONO '
  aDias[20] := 'VIGESIMO '
  aDias[21] := 'VIGESIMO PRIMEIRO '
  aDias[22] := 'VIGESIMO SEGUNDO '
  aDias[23] := 'VIGESIMO TERCEIRO '
  aDias[24] := 'VIGESIMO QUARTO '
  aDias[25] := 'VIGESIMO QUINTO '
  aDias[26] := 'VIGESIMO SEXTO '
  aDias[27] := 'VIGESIMO SETIMO '
  aDias[28] := 'VIGESIMO OITAVO '
  aDias[29] := 'VIGESIMO NONO '
  aDias[30] := 'TRIGESIMO '
  aDias[31] := 'TRIGESIMO PRIMEIRO '
  
  cTexto    := Layout
  nLin      := 1
  nTama     := Tama
  nEspa     := Espa
  nComp     := Comp

  cQtLin    := mlcount( cTexto, nTama )
  aLayout   := {}
  nLin      := 1
  
  Aguarde ()

  if !TestPrint( 1 )
    
    select ReceARQ
    set order to 8
    dbgotop ()
    do while .t.
      dbseek( "X", .f. )
    
      if eof ()
        exit
      else  
        if RegLock()
          replace Marc       with space(01)
          dbunlock ()
        endif
      endif
    enddo      

    select ReprARQ
    close
    select PortARQ
    close
    select ClieARQ
    close
    select ReceARQ
    close
    select CampARQ
    close
    select NoPrARQ
    close

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
  
  @ 00,00 say chr(27) + chr(67) + chr( cQtLin )
                  
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
        endif  
        cPalavra := ''
        nCol     := 0
      endif 
    next 
    nLin ++
  next  
  
  nLen := len( aLayout )
  
  select ReceARQ
  set order to 8
  set relation to Clie into ClieARQ, Repr into ReprARQ,;
               to Port into PortARQ
  
  dbseek( "X", .f. )
  do while Marc == "X"
    cObseNota := 'o ' + aDias[ day( Vcto ) ] + 'DIA DO MES ' + alltrim( aMesExt[ month( Vcto ) ] ) + ' DE' + str( year( Vcto ) ) 
  
    for nJ := 1 to nLen
      nLin  := aLayout[ nJ, 1 ]
      nCol  := aLayout[ nJ, 2 ]
      xTipo := aLayout[ nJ, 3 ]
      cArqu := aLayout[ nJ, 4 ]
      cCamp := aLayout[ nJ, 5 ]
      xTama := aLayout[ nJ, 6 ]
      cPict := aLayout[ nJ, 7 ]

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
    
    select ReceARQ

    dbskip ()
  enddo

  @ nLin,00 say chr(27) + '@'
  
  select ReceARQ
  set order to 8
  dbgotop ()
  do while .t.
    dbseek( "X", .f. )
    
    if eof ()
      exit
    else  
      if RegLock()
        replace Marc       with space(01)
        dbunlock ()
      endif
    endif
  enddo      
  
  set printer to
  set printer off
  set device  to screen

  select ReceARQ
  close
  select CampARQ
  close
  select ReprARQ
  close
  select PortARQ
  close
  select ClieARQ
  close
  select NoPrARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL