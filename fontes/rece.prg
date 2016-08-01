//  Leve, Contas a Receber
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

function Rece ()

if NetUse( "PortARQ", .t. )
  VerifIND( "PortARQ" )
  
  rOpenPort := .t.

  #ifdef DBF_NTX
    set index to PortIND1, PortIND2
  #endif
else
  rOpenPort := .f.
endif

if NetUse( "CobrARQ", .t. )
  VerifIND( "CobrARQ" )
  
  rOpenCobr := .t.

  #ifdef DBF_NTX
    set index to CobrIND1, CobrIND2
  #endif
else
  rOpenCobr := .f.
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
  rOpenRepr := .f.
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

//  Variaveis de Entrada para Item
nNota     := nClie   := nRepr   := 0
cNota     := space(07)
cClie     := cPort   := cRepr   := cCobr   := space(04)
dEmis     := ctod('  /  /  ')
dVcto     := ctod('  /  /  ')
dPgto     := ctod('  /  /  ')
nValor    := nAcre   := nDesc   := nJuro   := nPago := 0
nMesAtu   := nMesAnt := nMesPri := nPort   := 0
nReprComi := nCobr   := nDias   := nTipo   := 0
cCliente  := space(40)
cTipoVcto := space(15)
cDest     := space(15)
cTipo     := space(01)
lCalcJuro := .t.
aOpc      := {}

aadd( aOpc, { ' Nota    ', 2, 'N', 04, 55, "Contas a Receber gerada por uma Nota Fiscal." } )
aadd( aOpc, { ' Pedido  ', 2, 'P', 04, 55, "Contas a Receber gerada por um Pedido." } )
aadd( aOpc, { ' O.S.    ', 2, 'O', 04, 55, "Contas a Receber gerada por uma Ordem de Serviço." } )

//  Tela Item
Janela ( 02, 05, 21, 72, mensagem( 'Janela', 'Rece', .f. ), .t. )

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
tRece := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Item
select ReceARQ
set order to 1
if rOpenRece             
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

  Mensagem('Rece','Janela')

  cStat := space(04)

  restscreen( 00, 00, 23, 79, tRece )

  MostRece()
  
  if Demo ()
    exit
  endif  
  
  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostRece'
  cAjuda   := 'Rece'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()

  @ 04,23 get nNota             pict '999999-99'
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

  //  Verificar existencia do Produto para Incluir ou Alterar
  select ReceARQ
  set order to 1
  dbseek( cNota + cTipo, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif
  
  nRegg := recno ()
  
  Mensagem ('Rece',cStat)

  MostRece ()
  
  if nPago != 0
    Alerta( Mensagem( 'Alerta', 'Rece', .f. ) )
  endif
    
  EntrRece ()

  select ReceARQ
  set order to 1
  go nRegg
 
  Confirmar( 20, 07, 19, 48, 61, 3 )
    
  if cStat == 'excl'
    ExclRegi ()
  endif
  
  if lastkey() == K_ESC .or. cStat == 'loop'
    loop
  endif  

  if cStat == 'prin'
    PrinRece (.f.)
  endif

  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Nota        with cNota
        replace Tipo        with cTipo
        dbunlock ()
      endif
    endif  
  endif

  if cStat == 'alte' .or. cStat == 'incl'
    if RegLock()
      replace Clie        with cClie
      replace Cliente     with cCliente
      replace Emis        with dEmis
      replace Vcto        with dVcto
      replace Valor       with nValor
      replace Acre        with nAcre
      replace Desc        with nDesc
      replace Port        with cPort
      replace Repr        with cRepr
      replace Cobr        with cCobr
      replace Dest        with cDest
      replace TipoVcto    with cTipoVcto
      replace ReprComi    with nReprComi
      dbunlock ()
    endif
  endif
enddo

if rOpenClie
  select ClieARQ
  close
endif  

if rOpenRece
  select ReceARQ
  close
endif  

if rOpenPort
  select PortARQ
  close
endif  

if rOpenCobr
  select CobrARQ
  close
endif  

if rOpenRepr
  select ReprARQ
  close
endif  

return NIL

//
// Entra Dados do Item
//
function EntrRece ()
  do while .t.
    lAlterou := .f.

    setcolor ( CorJanel + ',' + CorCampo )
    @ 05,23 get nClie     pict '999999'        valid ValidClie( 05, 23, "ReceARQ" )
    @ 07,23 get dEmis     pict '99/99/9999'
    @ 08,23 get dVcto     pict '99/99/9999'
    @ 08,55 get cTipoVcto       
    @ 09,55 get cDest
    @ 11,23 get nValor    pict '@E 999,999,999.99'
    @ 12,23 get nAcre     pict '@E 999.99'
    @ 14,23 get nDesc     pict '@E 999,999,999.99'
    @ 15,55 get nReprComi pict '@E 999,999,999.99'
    @ 16,23 get nPort     pict '999999'        valid ValidARQ( 16, 23, "ReceARQ", "Código" , "Port", "Descrição", "Nome", "Port", "nPort", .t., 6, "Consulta de Portadores", "PortARQ", 40 )
    @ 17,23 get nRepr     pict '999999'        valid ValidARQ( 17, 23, "ReceARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nRepr", .t., 6, "Consulta de Vendedores", "ReprARQ", 40 )
    @ 18,23 get nCobr     pict '999999'        valid ValidARQ( 18, 23, "ReceARQ", "Código" , "Cobr", "Descrição", "Nome", "Cobr", "nCobr", .t., 6, "Consulta de Cobradores", "CobrARQ", 40 )
    read

    if nClie         != val( Clie ); lAlterou := .t.
    elseif dEmis     != Emis;        lAlterou := .t.
    elseif dVcto     != Vcto;        lAlterou := .t.
    elseif cTipoVcto != TipoVcto;    lAlterou := .t.
    elseif cDest     != Dest;        lAlterou := .t.
    elseif nValor    != Valor;       lAlterou := .t.
    elseif nAcre     != Acre;        lAlterou := .t.
    elseif nDesc     != Desc;        lAlterou := .t.
    elseif nReprComi != ReprComi;    lAlterou := .t.
    elseif nPort     != val( Port ); lAlterou := .t.
    elseif nRepr     != val( Repr ); lAlterou := .t.
    elseif nCobr     != val( Cobr ); lAlterou := .t.
    endif
    
    if !Saindo(lAlterou)
      loop
    endif
    exit  
  enddo  
  
  cPort := strzero( nPort, 6 )
  cRepr := strzero( nRepr, 6 )
  cClie := strzero( nClie, 6 )
  cCobr := strzero( nCobr, 6 )
return NIL

//
// Mostra Dados do Item
//
function MostRece ()
  if cStat != 'incl'
    nNota := val( Nota )
    cTipo := Tipo
    do case 
      case cTipo == 'N';        nTipo := 1
      case cTipo == 'P';        nTipo := 2
      case cTipo == 'O';        nTipo := 3
      otherwise;                nTipo := 1  
    endcase    
  endif  
  
  cClie     := Clie
  nClie     := val( Clie )
  cCliente  := Cliente
  dEmis     := Emis
  dVcto     := Vcto
  dPgto     := Pgto
  nValor    := Valor
  nAcre     := Acre
  nDesc     := Desc
  nPago     := Pago
  nPort     := val( Port )
  cPort     := Port  
  nCobr     := val( Cobr )
  cCobr     := Cobr  
  cRepr     := Repr
  nRepr     := val( Repr )
  cTipoVcto := TipoVcto
  cDest     := Dest
  nReprComi := ReprComi
  nJuro     := VerJuro ()
  
  setcolor( CorCampo )
  @ 04,55 say '         '
  do case 
    case cTipo == 'N'
      @ 04,55 say ' Nota    '
      
      setcolor( CorAltKC )
      @ 04,56 say 'N'
    case cTipo == 'P'
      @ 04,55 say ' Pedido  '
      
      setcolor( CorAltKC )
      @ 04,56 say 'P'
    case cTipo == 'O'
      @ 04,55 say ' O.S.    '
      
      setcolor( CorAltKC )
      @ 04,56 say 'O'
  endcase    
  
  MostMora ()
    
  setcolor ( CorCampo )
  @ 05,23 say cClie
  if cClie == '999999'
    @ 05,30 say Cliente            pict '@S40'
  else  
    @ 05,30 say ClieARQ->Nome      pict '@S40'
  endif  

  @ 07,23 say dEmis              pict '99/99/9999' 
  @ 08,23 say dVcto              pict '99/99/9999' 
  @ 08,55 say cTipoVcto       
  @ 09,23 say dPgto              pict '99/99/9999' 
  @ 09,55 say cDest

  @ 11,23 say nValor             pict '@E 999,999,999.99'
  @ 12,23 say nAcre              pict '@E 999.99'

  @ 14,23 say nDesc              pict '@E 999,999,999.99'
  @ 14,55 say nJuro              pict '@E 999,999,999.99'
  @ 15,23 say nPago              pict '@E 999,999,999.99'
  @ 15,55 say nReprComi          pict '@E 999,999,999.99'
  @ 16,23 say nPort              pict '999999'
  @ 16,30 say PortARQ->Nome      pict '@S40'
  @ 17,23 say nRepr              pict '999999'
  @ 17,30 say ReprARQ->Nome      pict '@S40'
  @ 18,23 say nCobr              pict '999999'
  @ 18,30 say CobrARQ->Nome      pict '@S40'
  
  PosiDBF( 02, 72 )
return NIL

//
// Mostra a mora di ria
//
function MostMora ()
  nMora := ( ( ( ( nValor - nDesc ) * nAcre ) / 100 ) / 30 )
  
  setcolor( CorCampo )
  @ 12,55 say nMora              pict '@E 999,999,999.99'
return NIL  

//
// Imprimi as Contas a Receber 
//
function PrinRece ( lAbrir )

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

    if NetUse( "CobrARQ", .t. )
      VerifIND( "CobrARQ" )
  
      #ifdef DBF_NTX
        set index to CobrIND1, CobrIND2
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
  endif  


  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 04, 05, 20, 74, mensagem( 'Janela', 'PrinRece', .f. ), .f. )
  Mensagem('Rece','PrinRece')

  setcolor ( CorJanel + ',' + CorCampo )
  @ 06,07 say '      Nota Inicial                      Nota Final'
  @ 07,07 say '   Cliente Inicial                   Cliente Final'
  @ 08,07 say '  Vendedor Inicial                  Vendedor Final'
  @ 09,07 say '  Portador Inicial                  Portador Final'
  @ 10,07 say '  Cobrador Inicial                  Cobrador Final'
  @ 12,07 say 'Data Emis. Inicial                Data Emis. Final'
  @ 13,07 say 'Data Vcto. Inicial                Data Vcto. Final'
  @ 14,07 say 'Data Pgto. Inicial                Data Pgto. Final'
  @ 16,07 say '      Valor Minimo                    Valor Máximo'
  @ 18,07 say '       Notas Pagas                            Tipo'
  @ 19,07 say '             Ordem'

  setcolor ( 'n/w+' )
  @ 18,68 say chr(25)
  @ 19,47 say chr(25)

  setcolor( CorCampo )
  @ 18,26 say ' Sim '
  @ 18,32 say ' Não '
  @ 18,38 say ' Ambas '
  @ 18,58 say ' Ambas   '
  @ 19,26 say ' Vcto + Nota + Clie '

  setcolor( 'gr+/w' )
  @ 18,27 say 'S'
  @ 18,33 say 'N'
  @ 18,39 say 'A'

  setcolor ( CorJanel + ',' + CorCampo )

  select ClieARQ
  set order to 1
  dbgotop ()
  nClieIni := val( Clie )
  nClieFin := 999999

  select ReprARQ
  set order to 1
  dbgobottom ()
  nReprIni := 0
  nReprFin := val( Repr )

  select PortARQ
  set order to 1
  dbgobottom ()
  nPortIni := 0
  nPortFin := val( Port )

  select CobrARQ
  set order to 1
  dbgobottom ()
  nCobrIni := 0
  nCobrFin := val( Cobr )

  select ReceARQ
  set order to 1
  dbgotop ()
  nNotaIni := 01
  nNotaFin := 99999999

  dVctoIni := ctod('01/01/1990')
  dVctoFin := ctod('31/12/2015')
  dEmisIni := ctod('01/01/1990')
  dEmisFin := ctod('31/12/2015')
  dPgtoIni := ctod('  /  /  ')
  dPgtoFin := ctod('  /  /  ')
  nValMini := 0
  nValMaxi := 999999999.99
  aOpcoes  := {}

  @ 06,26 get nNotaIni  pict '999999-99' 
  @ 06,58 get nNotaFin  pict '999999-99'         valid nNotaFin >= nNotaIni
  @ 07,26 get nClieIni  pict '999999'              valid ValidClie( 99, 99, "ReceARQ", "nClieIni" )
  @ 07,58 get nClieFin  pict '999999'              valid ValidClie( 99, 99, "ReceARQ", "nClieFin" ) .and. nClieFin >= nClieIni
  @ 08,26 get nReprIni  pict '999999'              valid nReprini == 0 .or. ValidARQ( 99, 99, "ReceARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprIni", .t., 6, "Consulta de Vendedores", "ReprARQ", 40 )
  @ 08,58 get nReprFin  pict '999999'              valid nReprFin == 0 .or. ValidARQ( 99, 99, "ReceARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprFin", .t., 6, "Consulta de Vendedores", "ReprARQ", 40 ) .and. nReprFin >= nReprIni
  @ 09,26 get nPortIni  pict '999999'              valid nPortIni == 0 .or. ValidARQ( 99, 99, "ReceARQ", "Código" , "Port", "Descrição", "Nome", "Port", "nPortIni", .t., 6, "Consulta de Portadores", "PortARQ", 40 )
  @ 09,58 get nPortFin  pict '999999'              valid nPortFin == 0 .or. ValidARQ( 99, 99, "ReceARQ", "Código" , "Port", "Descrição", "Nome", "Port", "nPortFin", .t., 6, "Consulta de Portadores", "PortARQ", 40 ) .and. nPortFin >= nPortIni
  @ 10,26 get nCobrIni  pict '999999'              valid nCobrIni == 0 .or. ValidARQ( 99, 99, "ReceARQ", "Código" , "Cobr", "Descrição", "Nome", "Cobr", "nCobrIni", .t., 6, "Consulta de Cobradores", "CobrARQ", 40 )
  @ 10,58 get nCobrFin  pict '999999'              valid nCobrFin == 0 .or. ValidARQ( 99, 99, "ReceARQ", "Código" , "Cobr", "Descrição", "Nome", "Cobr", "nCobrFin", .t., 6, "Consulta de Cobradores", "CobrARQ", 40 ) .and. nCobrFin >= nCobrIni
  @ 12,26 get dEmisIni  pict '99/99/9999'
  @ 12,58 get dEmisFin  pict '99/99/9999'          valid dEmisFin >= dEmisIni
  @ 13,26 get dVctoIni  pict '99/99/9999'
  @ 13,58 get dVctoFin  pict '99/99/9999'          valid dVctoFin >= dVctoIni
  @ 14,26 get dPgtoIni  pict '99/99/9999'
  @ 14,58 get dPgtoFin  pict '99/99/9999'          valid dPgtoFin >= dPgtoIni
  @ 16,26 get nValMini  pict '@E 999,999,999.99'
  @ 16,58 get nValMaxi  pict '@E 999,999,999.99' valid nValMaxi >= nValMini
  read

  if lastkey() == K_ESC
    if lAbrir
      select ReprARQ
      close
      select PortARQ
      close
      select CobrARQ
      close
      select ClieARQ
      close
      select ReceARQ
      close
    else
      select ReceARQ
      set order to 1
      dbgobottom ()
    endif
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  aOpc := {}

  aadd( aOpc, { ' Sim ',   2, 'S', 18, 26, "Relatório das nota pagas." } )
  aadd( aOpc, { ' Não ',   2, 'N', 18, 32, "Relatório das nota a vencer." } )
  aadd( aOpc, { ' Ambas ', 2, 'A', 18, 38, "Relatório de todas as nota." } )
  
  if empty( dPgtoIni )   
    nNotPaga := HCHOICE( aOpc, 3, 2 )
  else  
    nNotPaga := HCHOICE( aOpc, 3, 1 )
  endif  

  if lastkey() == K_ESC
    if lAbrir
      select ReprARQ
      close
      select PortARQ
      close
      select CobrARQ
      close
      select ClieARQ
      close
      select ReceARQ
      close
    else         
      select ReceARQ
      set order to 1
      dbgobottom ()
    endif
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
 
  aOpc := {}

  aadd( aOpc, { ' Nota    ', 2, 'N', 18, 58, "Contas a Receber gerada por uma Nota Fiscal." } )
  aadd( aOpc, { ' Pedido  ', 2, 'P', 18, 58, "Contas a Receber gerada por um Pedido." } )
  aadd( aOpc, { ' O.S.    ', 2, 'O', 18, 58, "Contas a Receber gerada por uma Ordem de Serviço." } )
  aadd( aOpc, { ' Ambas   ', 2, 'A', 18, 58, "Todas as Contas a Receber." } )
   
  nTipo := HCHOICE( aOpc, 4, 4 )

  if lastkey() == K_ESC
    if lAbrir
      select ReprARQ
      close
      select PortARQ
      close
      select CobrARQ
      close
      select ClieARQ
      close
      select ReceARQ
      close
    else
      select ReceARQ
      set order to 1
      dbgobottom ()
    endif
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  aOpc := {}
  
  aadd( aOpc, { ' Nota + Tipo        ', 2, 'N', 19, 26, "Relatório em ordem de Nota e Tipo." } )
  aadd( aOpc, { ' Vcto + Nota + Clie ', 2, 'V', 19, 26, "Relatório em ordem de data de Vcto. e Nota e Cliente." } )
  aadd( aOpc, { ' Pgto + Nota + Clie ', 2, 'P', 19, 26, "Relatório em ordem de data de Pgto. e Nota e Cliente." } )
  aadd( aOpc, { ' Clie + Vcto + Nota ', 2, 'C', 19, 26, "Relatório em ordem de Cliente e data de Vcto. e Nota." } )
  aadd( aOpc, { ' Clie + Pgto + Vcto ', 3, 'L', 19, 26, "Relatório em ordem de Cliente e data de Pgto. e data de Vcto." } )
  aadd( aOpc, { ' Repr + Nota        ', 2, 'R', 19, 26, "Relatório em ordem de Vendedor e Nota." } )
  aadd( aOpc, { ' Emis + Pgto        ', 2, 'E', 19, 26, "Relatório em ordem de data de Emissao e data de Pagamento" } )
  aadd( aOpc, { ' Alfabética         ', 2, 'A', 19, 26, "Relatório em ordem Alfabetica de Cliente" } )

  nOrdem := HCHOICE( aOpc, 8, 2 )

  if lastkey() == K_ESC
    if lAbrir
      select ReprARQ
      close
      select PortARQ
      close
      select CobrARQ
      close
      select ClieARQ
      close
      select ReceARQ
      close
    else 
      select ReceARQ
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

  cNotaIni  := strzero( nNotaIni, 8 )
  cNotaFin  := strzero( nNotaFin, 8 )
  cClieIni  := strzero( nClieIni, 6 )
  cClieFin  := strzero( nClieFin, 6 )
  cPortIni  := strzero( nPortIni, 6 )
  cPortFin  := strzero( nPortFin, 6 )
  cCobrIni  := strzero( nCobrIni, 6 )
  cCobrFin  := strzero( nCobrFin, 6 )
  cReprIni  := strzero( nReprIni, 6 )
  cReprFin  := strzero( nReprFin, 6 )

  nValorAcum := nGeraValor := nGeraAVenc := nGeraVenci := 0
  nTotalJuro := nTotalDesc := nTotalNota := nTotalPago := 0
  cClieAnt   := cReprAnt   := space(06)
  cTipoAnt   := space(01)
  cNotaAnt   := space(08)
  dVctoAnt   := dPgtoAnt   := dEmisAnt   := ctod( '  /  /  ')
  nQtdeNot   := 0
  lInicio    := .t.
  
  if nOrdem == 8
    aNome := {}
  endif

  select ReceARQ
  if nOrdem == 8
    set order to 2
  else
    set order to nOrdem
  endif
  set relation to Clie into ClieARQ, to Port into PortARQ, to Cobr into CobrARQ
    
  if nOrdem == 8
    dbgotop ()
    do while !eof ()
      if Nota        >= cNotaIni .and. Nota        <= cNotaFin .and.;
        val( Repr )  >= nReprIni .and. val( Repr ) <= nReprFin .and.;
        Clie         >= cClieIni .and. Clie        <= cClieFin .and.;
        val( Port )  >= nPortIni .and. val( Port ) <= nPortFin .and.;
        val( Cobr )  >= nCobrIni .and. val( Cobr ) <= nCobrFin .and.;
        Emis         >= dEmisIni .and. Emis        <= dEmisFin .and.;
        Vcto         >= dVctoIni .and. Vcto        <= dVctoFin .and.;
        Valor        >= nValMini .and. Valor       <= nValMaxi
        
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
            if Tipo != 'O'
              dbskip ()
              loop
            endif
        endcase
        
        aadd( aNome, { Nota, Tipo, Clie, iif( Clie == '9999', Cliente, ClieARQ->Nome ), Emis, Vcto, Pgto,;
                       TipoVcto, Dest, Desc, Pago, Valor, Acre, Juro } )
                     
        if len( aNome ) > 4095
          exit                          
        endif 
      endif     
      dbskip ()
    enddo
    
    asort( aNome,,, { | Nome01, Nome02 | Nome01[4] < Nome02[4] } )
    
    nLen := len( aNome )

    for nJ := 1 to nLen 
      cNota     := aNome[ nJ, 01 ] 
      cTipo     := aNome[ nJ, 02 ] 
      cClie     := aNome[ nJ, 03 ] 
      cNome     := aNome[ nJ, 04 ] 
      dEmis     := aNome[ nJ, 05 ] 
      dVcto     := aNome[ nJ, 06 ] 
      dPgto     := aNome[ nJ, 07 ] 
      cTipoVcto := aNome[ nJ, 08 ] 
      cDest     := aNome[ nJ, 09 ] 
      nDesc     := aNome[ nJ, 10 ] 
      nPago     := aNome[ nJ, 11 ] 
      nValor    := aNome[ nJ, 12 ] 
      nAcre     := aNome[ nJ, 13 ] 
      nJuro     := aNome[ nJ, 14 ] 
      
      if lInicio 
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
        
        lInicio := .f.
      endif     

      if nLin == 0
        do case
          case nNotPaga == 1
            Cabecalho( 'Contas a Receber - Pagas', 132, 3 )
          case nNotPaga == 2
            Cabecalho( 'Contas a Receber', 132, 3 )
          case nNotPaga == 3
            Cabecalho( 'Contas a Receber - Ambas', 132, 3 )
        endcase
        CabRece()
      endif

      if dVcto < date() .and. nJuro == 0 .and. empty( dPgto )
        nDias := dVcto - date ()

        if nDias < 31
          nJuro := ( date() - dVcto ) * ( ( nValor - nDesc ) * ( nAcre / 30 ) / 100 )
        else
          nMes   := int( nDias / 30 ) + 1
          nTotal := ( nValor - nDesc )

          for nU := 1 to nMes
            nJurinho := ( nTotal * nAcre ) / 100
            nTotal   += nJurinho
          next

          nJuro := nTotal - ( nValor - nDesc )

          if nJuro < 0
            nJuro := 0
          endif
        endif
      endif
               
      if cClie != cClieAnt
        nValorAcum := 0
        cClieAnt   := cClie
      endif

      nNotaPrn   := val ( cNota )
      nTotalNota += nValor
      nValorAcum += ( nValor + nJuro ) - nDesc
      nGeraValor += ( nValor + nJuro ) - nDesc
      nTotalDesc += nDesc
      nTotalJuro += nJuro
      nQtdeNot   ++

      @ nLin,001 say cClie
      @ nLin,008 say cNome                pict '@S19'
      @ nLin,028 say nNotaPrn             pict '999999-99'
      do case 
        case cTipo == 'N';          @ nLin,038 say 'Nota' 
        case cTipo == 'P';          @ nLin,038 say 'Pedido'
        case cTipo == 'O';          @ nLin,038 say 'O.S.' 
      endcase
      @ nLin,045 say dEmis                pict '99/99/9999'
      if empty( cTipoVcto )
        @ nLin,056 say dVcto              pict '99/99/9999'
      else
        @ nLin,056 say cTipoVcto          pict '@S8'
      endif
      if !empty( dPgto )
        @ nLin,067 say dPgto              pict '99/99/9999'
        @ nLin,078 say dVcto - dPgto      pict '9999'
      else
        if empty( cDest )
          @ nLin,067 say '__/__/____'
        else
          @ nLin,067 say cDest            pict '@S8'
        endif
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

      @ nLin,123 say nValorAcum           pict '@E 99,999.99'

      if dVcto >= date()
        nGeraAVenc += nValor
      else
        nGeraVenci += ( nValor + nJuro )
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
    dbgotop ()
    do while !eof()
      if Nota        >= cNotaIni .and. Nota        <= cNotaFin .and.;
        val( Repr )  >= nReprIni .and. val( Repr ) <= nReprFin .and.;
        Clie         >= cClieIni .and. Clie        <= cClieFin .and.;
        val( Port )  >= nPortIni .and. val( Port ) <= nPortFin .and.;
        val( Cobr )  >= nCobrIni .and. val( Cobr ) <= nCobrFin .and.;
        Emis         >= dEmisIni .and. Emis        <= dEmisFin .and.;
        Vcto         >= dVctoIni .and. Vcto        <= dVctoFin .and.;
        Valor        >= nValMini .and. Valor       <= nValMaxi
        
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
            if Tipo != 'O'
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
              Cabecalho( 'Contas a Receber - Pagas', 132, 3 )
            case nNotPaga == 2
              Cabecalho( 'Contas a Receber', 132, 3 )
            case nNotPaga == 3
              Cabecalho( 'Contas a Receber - Ambas', 132, 3 )
          endcase
          CabRece()
        endif
        
        if Vcto < date() .and. Juro == 0 .and. empty( Pgto )
          nDias := Vcto - date ()

          if nDias < 31
            nJuro := ( date() - Vcto ) * ( ( Valor - Desc ) * ( Acre / 30 ) / 100 )
          else
            nMes   := int( nDias / 30 ) + 1
            nTotal := ( Valor - Desc )

            for nU := 1 to nMes
              nJurinho := ( nTotal * Acre ) / 100
              nTotal   += nJurinho
            next

            nJuro := nTotal - ( Valor - Desc )

            if nJuro < 0
              nJuro := 0
            endif
          endif
        else
          nJuro := Juro
        endif
      
        do case
          case nOrdem == 1 
            if Nota != cNotaAnt .and. Tipo != cTipoAnt
              nValorAcum := 0
              cNotaAnt   := Nota
              cTipoAnt   := Tipo
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
            if Clie != cClieAnt
              nValorAcum := 0
              cClieAnt   := Clie
            endif
          case nOrdem == 6 
            if Repr != cReprAnt
              nValorAcum := 0
              cReprAnt   := Repr
           endif
          case nOrdem == 7 
            if Emis != dEmisAnt
              nValorAcum := 0
              dEmisAnt   := Emis
            endif
        endcase
      
        nNotaPrn   := val ( Nota )
        nTotalNota += Valor
        nValorAcum += ( Valor + nJuro ) - Desc
        nGeraValor += ( Valor + nJuro ) - Desc
        nTotalDesc += Desc
        nTotalJuro += nJuro
        nTotalPago += Pago
        nQtdeNot   ++

        @ nLin,001 say Clie
        if Clie == '999999'
          @ nLin,008 say Cliente           pict '@S19'
        else  
          @ nLin,008 say ClieARQ->Nome     pict '@S19'
        endif  
        @ nLin,028 say nNotaPrn            pict '999999-99'
        do case 
          case Tipo == 'N';            @ nLin,038 say 'Nota' 
          case Tipo == 'P';            @ nLin,038 say 'Pedido'
          case Tipo == 'O';            @ nLin,038 say 'O.S.' 
        endcase
        @ nLin,045 say Emis                pict '99/99/9999'
        if empty( TipoVcto )
          @ nLin,056 say Vcto              pict '99/99/9999'
        else
          @ nLin,056 say TipoVcto          pict '@S8'
        endif

        if !empty( Pgto )
          @ nLin,067 say Pgto              pict '99/99/9999'
          @ nLin,078 say Vcto - Pgto       pict '9999'
        else
          if empty( Dest )
            @ nLin,067 say '__/__/____'
          else
            @ nLin,067 say Dest            pict '@S8'
          endif
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
          nGeraAVenc += Valor
        else
          nGeraVenci += ( Valor + nJuro )
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
    @ nLin,113 say nTotalPago    pict '@E 99,999.99'
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
          replace Titu   with "Relatório de Contas a Receber - Pagas"
        case nNotPaga == 2
          replace Titu   with "Relatório de Contas a Receber"
        case nNotPaga == 3
          replace Titu   with "Relatório de Contas a Receber - Ambas"
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
    select ReprARQ
    close
    select PortARQ
    close
    select CobrARQ
    close
    select ClieARQ
    close
    select ReceARQ
    close
  else
    select ReceARQ
    set order  to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabRece()
  @ 02,001 say 'Emis. ' + dtoc( dEmisIni ) + ' a ' + dtoc( dEmisFin )
  @ 02,032 say 'Vcto. ' + dtoc( dVctoIni ) + ' a ' + dtoc( dVctoFin )
  if !empty( dPgtoIni )
    @ 02,063 say 'Pgto. ' + dtoc( dPgtoIni ) + ' a ' + dtoc( dPgtoFin )
  endif  

  if cPortIni == cPortFin
    @ 02,090 say 'Portador ' + left( PortARQ->Nome, 10 )
  endif  
    
  if nCobrIni > 0
    @ nLin,115 say 'Cobrador ' + left( CobrARQ->Nome, 9 )
  endif  
  
  @ 03,001 say 'Cliente                         Nota Tipo   Emissão    Vcto.      Pgto.      Dias     Valor     Juros  Desconto      Pago Acumulado'

  nLin     := 5
  dVctoAnt := ctod('  /  /  ')
return NIL

//
// Imprime Duplicata dos Clientes
//
function PrinDupl ()

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

  if NetUse( "DuplARQ", .t. )
    VerifIND( "DuplARQ" )
  
    #ifdef DBF_NTX
      set index to DuplIND1
    #endif
  endif

  tPrt := savescreen( 00, 00, 23, 79 ) 

  Janela ( 05, 01, 20, 76, mensagem( 'Janela', 'PrinDupl', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )
 
  select ReceARQ
  set order    to 7
  set relation to Clie into ClieARQ
  
  oDupli         := TBrowseDB( 07, 02, 18, 75 )
  oDupli:headsep := chr(194)+chr(196)
  oDupli:colsep  := chr(179)
  oDupli:footsep := chr(193)+chr(196)

  oDupli:addColumn( TBColumnNew(" ",          {|| Marc } ) )
  oDupli:addColumn( TBColumnNew("Nota",       {|| left( Nota, 6 ) + '-' + right( Nota, 2 ) } ) )
  oDupli:addColumn( TBColumnNew("Tipo",       {|| iif( Tipo == 'P', 'Pedido', iif( Tipo == 'N', 'Nota  ', iif( Tipo == 'O', 'O.S.   ', '      ' ) ) ) } ) )
  oDupli:addColumn( TBColumnNew("Cliente",    {|| iif( Clie == '999999', left( Cliente, 14 ), left( ClieARQ->Nome, 14 ) ) } ) )
  oDupli:addColumn( TBColumnNew("Codigo",     {|| Clie } ) )
  oDupli:addColumn( TBColumnNew("Emissão",    {|| Emis } ) )
  oDupli:addColumn( TBColumnNew("Vcto.",      {|| Vcto } ) )
  oDupli:addColumn( TBColumnNew("Valor Nota", {|| transform( Valor, '@E 99,999.99' ) } ) )
  oDupli:addColumn( TBColumnNew("Pgto.",      {|| Pgto } ) )
  oDupli:addColumn( TBColumnNew("Repr.",      {|| Repr } ) )
              
  lExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ''
  nTotal         := lastrec()
  nTotalNota     := 0
  nOrdem         := 7
  BarraSeta      := BarraSeta( nLinBarra, 8, 18, 76, nTotal )
  
  oDupli:gobottom()
  
  setcolor( CorJanel + ',' + CorCampo )
  @ 08,01 say chr(195) 
  @ 18,01 say chr(195) 
  @ 19,05 say 'Consulta'
  @ 19,47 say 'Total Nota'
  
  setcolor( CorCampo )
  @ 19,14 say space(30)
  @ 19,58 say nTotalNota           pict '@E 999,999.99'

  do while !lExitRequested
    Mensagem( 'Rece', 'PrinDupl' )

    oDupli:forcestable() 

    iif( BarraSeta, BarraSeta( nLinBarra, 8, 18, 76, nTotal ), NIL )
    
    if oDupli:stable
      if oDupli:hitTop .or. oDupli:hitBottom
        tone( 125, 0 )        
      endif  
            
      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oDupli:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oDupli:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oDupli:down()
      case cTecla == K_UP;         oDupli:up()
      case cTecla == K_PGDN;       oDupli:pageDown()
      case cTecla == K_PGUP;       oDupli:pageUp()
      case cTecla == K_RIGHT;      oDupli:right()
      case cTecla == K_LEFT;       oDupli:left()
      case cTecla == K_CTRL_PGDN;  oDupli:gobottom()
      case cTecla == K_CTRL_PGUP;  oDupli:goTop()
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
 
        oDupli:refreshall()
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

        oDupli:refreshall()
  
        lExitRequested := .t.  
      case cTecla == K_TAB
        nOrdem ++

        if nOrdem > 7
          nOrdem := 1
        endif  
        
        set order to nOrdem
        
        do case
          case nOrdem == 1
            cTitu := 'Seleção de Duplicatas por Nota'
          case nOrdem == 2
            cTitu := 'Seleção de Duplicatas por Vencimento'
          case nOrdem == 3
            cTitu := 'Seleção de Duplicatas por Pagamento'
          case nOrdem == 4
            cTitu := 'Seleção de Duplicatas por Cliente e Vcto.'
          case nOrdem == 5
            cTitu := 'Seleção de Duplicatas por Cliente e Pgto.'
          case nOrdem == 6
            cTitu := 'Seleção de Duplicatas por Vendedor'
          case nOrdem == 7
            cTitu := 'Seleção de Duplicatas por Emissão'
        endcase    

        setcolor( CorCabec )
        @ 05, 05 say space(68)
        @ 05, 05 + ( ( 66 - len ( cTitu ) ) / 2 ) say cTitu

        oDupli:refreshAll()
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
        oDupli:refreshAll()
    endcase
  enddo  
  
  if lastkey() == K_ESC
    select ReceARQ
    set order to 8
    dbgotop ()
    do while !eof ()
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
    
    select ReprARQ
    close
    select PortARQ
    close
    select ClieARQ
    close
    select ReceARQ
    close
    select DuplARQ
    close
    select CampARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  select DuplARQ
  set order to 1
  dbseek( EmprARQ->Dupl, .f. )

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
    Alerta( mensagem( 'Alerta', 'PrinDupl', .f. ) )
  
    select ReceARQ
    set order to 8
    dbgotop ()
    do while !eof ()
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
    select DuplARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  cTexto  := Layout
  nLin    := 1
  nTama   := Tama
  nEspa   := Espa
  nComp   := Comp
  nTam01  := 0
  nTam02  := 0

  cQtLin  := mlcount( cTexto, nTama + 1 )
  aLayout := {}
  nLin    := 0
  nTotLin := 0
                  
  for nK := 1 to cQtLin
    cLinha  := memoline( cTexto, nTama + 1, nK )
    nTotLin ++
      
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
          endif  
        endif  
        cPalavra := ''
        nCol     := 0
      endif 
    next 
    nLin ++
  next  
  
  if !TestPrint( EmprARQ->Duplicata )
    select ReceARQ
    set order to 8
    dbgotop ()
    do while !eof ()
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
    select DuplARQ
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
 
  nLen := len( aLayout )
  
  select ReceARQ
  set order to 8
  set relation to Clie into ClieARQ, Repr into ReprARQ,;
               to Port into PortARQ
  
  dbseek( "X", .f. )
  do while Marc == "X"
    Extenso( Valor, nTam01, nTam02 )

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

  @ nTotLin,00 say chr(27) + '@'
  
  select ReceARQ
  set order to 8
  dbgotop()
  do while !eof ()
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
  select DuplARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

//
// Imprime Bloqueto dos Clientes
//
function PrinBqto ()

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

  tPrt := savescreen( 00, 00, 23, 79 ) 

  Janela ( 03, 01, 21, 76, mensagem( 'Janela', 'PrinBqto', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )
  
  select ReceARQ
  set order    to 7
  set relation to Clie into ClieARQ
  
  oBloqueto         := TBrowseDB( 05, 02, 16, 75 )
  oBloqueto:headsep := chr(194)+chr(196)
  oBloqueto:colsep  := chr(179)
  oBloqueto:footsep := chr(193)+chr(196)

  oBloqueto:addColumn( TBColumnNew(" ",          {|| Marc } ) )
  oBloqueto:addColumn( TBColumnNew("Nota",       {|| left( Nota, 6 ) + '-' + right( Nota, 2 ) } ) )
  oBloqueto:addColumn( TBColumnNew("Tipo",       {|| iif( Tipo == 'P', 'Pedido', iif( Tipo == 'N', 'Nota  ', iif( Tipo == 'O', 'O.S.   ', '      ' ) ) ) } ) )
  oBloqueto:addColumn( TBColumnNew("Cliente",    {|| iif( Clie == '999999', left( Cliente, 14 ), left( ClieARQ->Nome, 14 ) ) } ) )
  oBloqueto:addColumn( TBColumnNew("Codigo",     {|| Clie } ) )
  oBloqueto:addColumn( TBColumnNew("Emissão",    {|| Emis } ) )
  oBloqueto:addColumn( TBColumnNew("Vcto.",      {|| Vcto } ) )
  oBloqueto:addColumn( TBColumnNew("Valor Nota", {|| transform( Valor, '@E 99,999.99' ) } ) )
  oBloqueto:addColumn( TBColumnNew("Pgto.",      {|| Pgto } ) )
  oBloqueto:addColumn( TBColumnNew("Repr.",      {|| Repr } ) )
              
  lExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ''
  nTotal         := lastrec()
  nTotalNota     := 0
  nBanc          := 0
  nAgci          := 0
  nOrdem         := 7
  BarraSeta      := BarraSeta( nLinBarra, 6, 16, 76, nTotal )

  setcolor( CorJanel + ',' + CorCampo )
  @ 06,01 say chr(195) 
  @ 16,01 say chr(195) 
  @ 17,05 say 'Consulta'
  @ 17,47 say 'Total Nota'
  @ 19,05 say '   Banco'
  @ 20,05 say ' Agˆncia'
  
  setcolor( CorCampo )
  @ 17,14 say space(30)
  @ 17,58 say nTotalNota           pict '@E 999,999.99'
  @ 19,14 say nBanc                pict '9999'
  @ 19,19 say space(30)
  @ 20,14 say nAgci                pict '9999'
  @ 20,19 say space(30)

  do while !lExitRequested
    Mensagem( 'Rece', 'PrinBqto' )
    
    oBloqueto:forcestable() 

    iif( BarraSeta, BarraSeta( nLinBarra, 6, 16, 76, nTotal ), NIL )
    
    if oBloqueto:stable
      if oBloqueto:hitTop .or. oBloqueto:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oBloqueto:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oBloqueto:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oBloqueto:down()
      case cTecla == K_UP;         oBloqueto:up()
      case cTecla == K_PGDN;       oBloqueto:pageDown()
      case cTecla == K_PGUP;       oBloqueto:pageUp()
      case cTecla == K_RIGHT;      oBloqueto:right()
      case cTecla == K_LEFT;       oBloqueto:left()
      case cTecla == K_CTRL_PGDN;  oBloqueto:gobottom()
      case cTecla == K_CTRL_PGUP;  oBloqueto:goTop()
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
        @ 17,58 say nTotalNota           pict '@E 999,999.99'
 
        oBloqueto:refreshall()
      case cTecla == K_ENTER
        if empty( Marc )
          nTotalNota += Valor
        endif 
       
        setcolor( CorCampo ) 
        @ 17,58 say nTotalNota           pict '@E 999,999.99'
      
        if RegLock()
          replace Marc       with "X"
          dbunlock ()
        endif

        @ 19,14 get nBanc        pict '9999' valid ValidARQ( 19, 14, "ReceARQ", "Código" , "Banc", "Descrição", "Nome", "Banc", "nBanc", .t., 4, "Consulta de Bancos", "BancARQ", 30 )
        @ 20,14 get nAgci        pict '9999' valid ValidAgci( 20, 14, "ReceARQ" , nBanc ) 
        read
        
        cBanc := strzero( nBanc, 4 )
        cAgci := strzero( nAgci, 4 )

        oBloqueto:refreshall()
  
        lExitRequested := .t.  
      case cTecla == K_TAB
        nOrdem ++

        if nOrdem > 7
          nOrdem := 1
        endif  
        
        set order to nOrdem
        
        do case
          case nOrdem == 1
            cTitu := 'Seleção de Bloquetos por Nota'
          case nOrdem == 2
            cTitu := 'Seleção de Bloquetos por Vencimento'
          case nOrdem == 3
            cTitu := 'Seleção de Bloquetos por Pagamento'
          case nOrdem == 4
            cTitu := 'Seleção de Bloquetos por Cliente e Vcto.'
          case nOrdem == 5
            cTitu := 'Seleção de Bloquetos por Cliente e Pgto.'
          case nOrdem == 6
            cTitu := 'Seleção de Bloquetos por Vendedor'
          case nOrdem == 7
            cTitu := 'Seleção de Bloquetos por Emissão'
        endcase     

        setcolor( CorCabec )
        @ 03, 05 say space(68)
        @ 03, 05 + ( ( 66 - len ( cTitu ) ) / 2 ) say cTitu

        oBloqueto:refreshAll()
      case cTecla == K_BS
        cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
      
        setcolor ( CorCampo )
        @ 17,14 say space(32)
        @ 17,14 say cLetra
      case cTecla >= 32 .and. cTecla <= 128
        cLetra += chr( cTecla )    

        if len( cLetra ) > 32
          cLetra := ''
        endif  
     
        setcolor ( CorCampo )
        @ 17,14 say space(32)
        @ 17,14 say cLetra
        
        if nOrdem == 2 .or. nOrdem == 3 .or. nOrdem == 7        
          dbseek( dtos( ctod( cLetra ) ), .t. )
        else
          dbseek( cLetra, .t. )
        endif  
        oBloqueto:refreshAll()
    endcase
  enddo  
  
  if lastkey() == K_ESC
    select ReceARQ
    set order to 8
    dbgotop ()
    do while !eof ()
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
    select ReprARQ
    close
    select PortARQ
    close
    select ClieARQ
    close
    select ReceARQ
    close
    select BancARQ
    close
    select AgciARQ
    close
    select CampARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  select AgciARQ
  set order to 1
  dbseek( cBanc + cAgci, .f. )
  
  select BancARQ
  set order to 1
  dbseek( cBanc, .f. )

  if found()
    if empty( Bloqueto )
      lAchou := .f.
    else  
      lAchou := .t.
    endif  
  else
    lAchou := .f.
  endif
  
  if !lAchou
    Alerta( mensagem( 'Alerta', 'PrinBqto', .f. ) )
  
    select ReceARQ
    set order to 8
    dbgotop ()
    do while !eof ()
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
    select BancARQ
    close
    select AgciARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  cTexto := Bloqueto
  nTama  := TamaBloq
  nEspa  := EspaBloq
  nComp  := CompBloq

  cQtLin  := mlcount( cTexto, nTama + 1 )
  aLayout := {}
  nLin    := 0
  nTotLin := 0
                  
  for nK := 1 to cQtLin
    cLinha  := memoline( cTexto, nTama + 1, nK )
    nTotLin ++
      
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
 
  if !TestPrint( EmprARQ->Bloqueto )
    select ReceARQ
    set order to 8
    dbgotop ()
    do while !eof ()
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
    select BancARQ
    close
    select AgciARQ
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

  select ClieARQ
  set order to 1
  
  select ReprARQ
  set order to 1
  
  select PortARQ
  set order to 1
  
  select ReceARQ
  set order to 8
  set relation to Clie into ClieARQ, Repr into ReprARQ,;
               to Port into PortARQ
  
  dbseek( "X", .f. )
  do while Marc == "X"
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
  
  @ nTotLin,00 say chr(27) + '@'
  
  select ReceARQ
  set order to 8
  dbgotop ()
  do while !eof ()
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
  select BancARQ
  close
  select AgciARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL