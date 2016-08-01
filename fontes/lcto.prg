//  Leve, Lançamentos
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

function Lcto( xAlte )
  local GetList := {}
  
if SemAcesso( 'Lcto' ) 
  return NIL
endif  

if NetUse( "LctoARQ", .t. )
  VerifIND( "LctoARQ" )
  
  lOpenLcto := .t.

  #ifdef DBF_NTX
    set index to LctoIND1, LctoIND2
  #endif
else
  lOpenLcto := .f.
endif

//  Variaveis de Entrada para Lctoa
cLcto := space(04)
nLcto := nTipo := 0
cNome := space(30)
cTipo := space(01)

//  Tela Lcto
Janela ( 04, 05, 12, 62, mensagem( 'Janela', 'Lcto', .f. ), .t. )

setcolor ( CorJanel + ',' + CorCampo )
@ 06,10 say '   Codigo'
@ 08,10 say 'Descrição'
@ 09,10 say '     Tipo  '

MostOpcao( 11, 07, 19, 38, 51 ) 
tLcto := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Lcto
select LctoARQ
set order to 1
if lOpenLcto
  dbgobottom ()
endif  
do while .t.
  select LctoARQ
  set order to 1

  Mensagem('Lcto', 'Janela' )
 
  restscreen( 00, 00, 23, 79, tLcto )
  cStat := space(4)
  MostLcto()
  
  if Demo ()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostLcto'
  cAjuda   := 'Lanc'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  if lastkey() == K_ALT_A
    nLcto := val( Lcto )
  else    
    if xAlte
      @ 06,20 get nLcto              pict '999999'
      read
    else
      nLcto := 0
    endif  
  endif    
  
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC
    exit
  endif
  
  setcolor ( CorCampo )
  cLcto := strzero( nLcto, 6 ) 
  @ 06,20 say cLcto
  
  //  Verificar existencia do Lancamento para Incluir ou Alterar
  select LctoARQ
  set order to 1
  dbseek( cLcto, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif

  Mensagem ('Lcto', cStat )
  
  MostLcto ()
  EntrLcto ()

  Confirmar( 11, 07, 19, 38, 51, 3 )

  if cStat == 'prin'
    PrinLcto (.f.)
  endif
    
  if cStat == 'excl'
    ExclRegi ()
  endif
    
  if cStat == 'incl'
    if cLcto == "000000" 
      cLcto := "000001"

      set order to 1
      do while .t.
        dbseek( cLcto, .f. )
        if found()
          cLcto := strzero( val( cLcto ) + 1, 6 )
        else 
          exit   
        endif
      enddo
    endif       

    if AdiReg()
      if RegLock()
        replace Lcto         with cLcto
        dbunlock ()
      endif
    endif  
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Nome         with cNome
      replace Tipo         with cTipo
      dbunlock ()
    endif
    
    if !xAlte 
      xAlte := .t.
      keyboard(chr(27))
    endif  
  endif
enddo

if lOpenLcto
  select LctoARQ
  close
endif  

return NIL

//
// Entra Dados do Lançamento
//
function EntrLcto ()
  local GetList := {}
  local aOpc    := {}

  aadd( aOpc, { ' Crédito ' ,  2, 'C', 09, 20, "Tipo do Lançamento - Crédito" } )
  aadd( aOpc, { ' Débito ',    2, 'D', 09, 30, "Tipo do Lançamento - Débito" } )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,20 get cNome
  read
  
  if lastkey() != K_ESC .and. lastkey() != K_PGDN
    nTipo := HCHOICE( aOpc, 2, nTipo )
    cTipo := iif( nTipo == 1, 'C', 'D' )
  endif  
return NIL

//
// Mostra Dados do Lcto 
//
function MostLcto ()
  if cStat != 'incl' 
    cLcto := Lcto
    nLcto := val( Lcto )
  endif
  
  cNome := Nome
  cTipo := Tipo
  nTipo := iif( cTipo == 'C', 1, 2 )  
      
  setcolor ( CorCampo )
  @ 08,20 say cNome

  @ 09,20 say ' Crédito '
  @ 09,30 say ' Débito '
  
  setcolor( CorAltKC )
  @ 09,21 say 'C'
  @ 09,31 say 'D'
    
  setcolor( CorOpcao )
  if nTipo == 1
    @ 09,20 say ' Crédito '

    setcolor( CorAltKO )
    @ 09,21 say 'C'
  else  
    @ 09,30 say ' Débito '

    setcolor( CorAltKO )
    @ 09,31 say 'D'
  endif  
  
  PosiDBF( 04, 62 )
return NIL

//
// Imprime Dados 
//
function PrinLcto ( lAbrir )

  local cArqu2  := CriaTemp( 5 )
  local cArqu3  := right ( cArqu2, 8 )

  local cRData  := date()
  local cRHora  := time()
  
  local GetList := {}

  if lAbrir
    if NetUse( "LctoARQ", .t. )
      VerifIND( "LctoARQ" )

      #ifdef DBF_NTX
        set index to LctoIND1, LctoIND2
      #endif
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 06, 23, 10, 52, mensagem( 'Janela', 'PrinLcto', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,25 say 'Lançamento Inicial'
  @ 09,25 say '  Lançamento Final'
  
  select LctoARQ
  dbgotop ()
  nLctoIni := val( Lcto )
  dbgobottom ()
  nLctoFin := val( Lcto )

  @ 08,44 get nLctoIni   pict '999999'     valid ValidARQ( 99, 99, "LctoARQ", "Código" , "Lcto", "Descrição", "Nome", "Lcto", "nLctoIni", .t., 06, "Consulta de Lançamentos", "LctoARQ", 40 )
  @ 09,44 get nLctoFin   pict '999999'     valid ValidARQ( 99, 99, "LctoARQ", "Código" , "Lcto", "Descrição", "Nome", "Lcto", "nLctoFin", .t., 06, "Consulta de Lançamentos", "LctoARQ", 40 ) .and. nLctoFin >= nLctoIni
  read

  if lastkey() == K_ESC
    select LctoARQ
    if lAbrir
      close
    else
      set order to 1
      dbgobottom ()
    endif
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  Aguarde ()
  
  nPag     := 1
  nLin     := 0
  cArqu2   := cArqu2 + "." + strzero( nPag, 3 )

  cLctoIni := strzero( nLctoIni, 6 )
  cLctoFin := strzero( nLctoFin, 6 )
  lInicio  := .t.

  select LctoARQ
  set order to 1
  dbseek( cLctoIni, .t. )
  do while Lcto >= cLctoIni .and. Lcto <= cLctoFin .and. !eof ()
    if lInicio 
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
      
      lInicio := .f.
    endif  
    
    if nLin == 0
      Cabecalho( 'Lançamento', 80, 4 )
      CabLcto()
    endif
      
    @ nLin,00 say Lcto
    @ nLin,15 say alltrim( Nome )
    @ nLin,50 say iif( Tipo == 'C', 'Cr‚dito', 'Débito' )
    nLin ++
      
    if nLin >= pLimite
      Rodape(80) 

      cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
      cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

      set printer to ( cArqu2 )
      set printer on
    endif

    dbskip ()
  enddo
  
  if !lInicio
    Rodape(80)
  endif  
 
  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 80 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Relatório de Lançamentos"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
    close
  endif

  select LctoARQ
  if lAbrir
    close
  else
    set order  to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabLcto()
  @ 02,00 say 'Codigo'
  @ 02,15 say 'Descrição'
  @ 02,50 say 'Tipo'

  nLin := 4
return NIL

//
// Imprimir recibo avulso
//
function PrinRecibo ( lTipo, cCampo )

  if NetUse( "RcboARQ", .t. )
    VerifIND( "RcboARQ" )
  
    lOpenRcbo := .t.

    #ifdef DBF_NTX
      set index to RcboIND1
    #endif
  else
    lOpenRcbo := .f.
  endif

  Janela( 07, 11, 17, 67, mensagem( 'Janela', 'PrinRecibo', .f. ), .f. )
  Mensagem( 'Lcto', 'PrinRecibo' )
  setcolor( CorJanel + ',' + CorCampo )
  
  @ 09,13 say '    Valor                          Data '
  @ 11,13 say '   Recebi'
  @ 13,13 say 'Referente'
  @ 16,13 say '     Nome'
  
  if lTipo 
    nValor := 0
    dData  := date () 
    cReceb := space(40)
    cNome  := left( EmprARQ->Razao, 40 )
    cRef01 := space(60) 
    cRef02 := space(60) 
  else
    do case 
      case cCampo == 'comi'
        nValor := rTotalPaga
        dData  := date()
        cReceb := left( EmprARQ->Razao, 40 )
        cNome  := cRepre
        cRef01 := space(60) 
        cRef02 := space(60) 
      case cCampo == 'pedi'
        nValor := PediARQ->TotalNota
        dData  := PediARQ->Emis
        cReceb := ClieARQ->Nome
        cNome  := left( EmprARQ->Razao, 40 )
        cRef01 := space(60) 
        cRef02 := space(60) 
      case cCampo == 'nota'
        nValor := nTotalNota
        dData  := NSaiARQ->Emis
        cReceb := ClieARQ->Nome
        cNome  := left( EmprARQ->Razao, 40 )
        cRef01 := space(60) 
        cRef02 := space(60) 
      case cCampo == 'vend'
        nValor := nTotalNota
        dData  := NSaiARQ->Emis
        cReceb := ClieARQ->Nome
        cNome  := left( EmprARQ->Razao, 40 )
        cRef01 := space(60) 
        cRef02 := space(60) 
    endcase    
  endif   
   
  @ 09,23 get nValor                   pict '@E 999,999.99' 
  @ 09,53 get dData                    pict '99/99/9999'
  @ 11,23 get cReceb                   
  @ 13,23 get cRef01                   pict '@S40' 
  @ 14,23 get cRef02                   pict '@S40' 
  @ 16,23 get cNome                    pict '@K'
  read

  if lastkey () == K_ESC
    if lOpenRcbo
      select RcboARQ
      close
    endif  
    return NIL
  endif  

  Janela( 11, 22, 14, 57, mensagem( ' Janela', 'PrinRecibo', .f. ), .f. )
  Mensagem( 'Lcto', 'PrinRecibo' )
  setcolor( CorJanel )
  @ 13,23 say '  Imprimir'
    
  aOpc := {}
  nPrn := 0

  aadd( aOpc, { ' Sim ',     2, 'S', 13, 34, "Imprimir Recibo." } )
  aadd( aOpc, { ' Não ',     2, 'N', 13, 40, "Não imprimir Recibo." } )
  aadd( aOpc, { ' Arquivo ', 2, 'A', 13, 46, "Gerar arquivo texto da impressão do Recibo." } )
    
  nTipoReci := HCHOICE( aOpc, 3, 2 )

  if nTipoReci == 3
      Janela( 05, 21, 08, 56, mensagem( 'Janela', 'Salvar', .f. ), .f. )
      Mensagem( 'LEVE', 'Salvar' )

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
  
  if nTipoReci == 1
    if EmprARQ->Impr == "X"
      if !TestPrint( EmprARQ->Recibo )
        if lOpenRcbo
          select RcboARQ
          close
        endif  
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
  
        nTipoReci := 3

    endif  
  endif 
    
  nReci  := EmprARQ->Reci + 1

  for nJ := 1 to EmprARQ->CopiaReci
    setprc( 0, 0 )
    
    if nTipoReci == 1
      @ 00, 00 say chr(27) + "@"
      @ 00, 00 say chr(18)
      @ 00, 00 say chr(27) + chr(67) + chr(33)
    endif
    
    nLin := 0
    
    if nTipoReci != 2
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
    @ nLin,65 say nValor                       pict '@E 999,999,999.99'
    nLin += 2
    @ nLin,04 say 'Recebi(emos) de '
    @ nLin,20 say cReceb
    @ nLin,64 say 'a importancia'
    nLin ++
    @ nLin,01 say 'de R$'
    @ nLin,07 say nValor                       pict '@E 999,999,999.99'
    @ nLin,22 say '('
 
    Extenso( nValor, 55, 55 ) 

    @ nLin,24 say cValorExt1
    nLin ++
    @ nLin,01 say cValorExt2
    @ nLin,57 say ').'
    nLin += 2
    @ nLin,01 say cRef01
    nLin ++
    @ nLin,01 say cRef02
    nLin += 7

    cData := alltrim( EmprARQ->Cida ) + '(' + EmprARQ->UF + '), ' + strzero( day( dData ), 2 ) + ' de ' + alltrim( aMesExt[ month( dData ) ] ) + ' de' + str( year( dData ) )
     
    @ nLin,( 79 - len( cData ) ) say cData

    nLin += 3
    @ nLin,38 say '____________________________________'
    nLin ++
    @ nLin,38 say alltrim( cNome )
  
    nLin  += 5
    endif
    
    if nTipoReci == 1
      @ nLin,00 say chr(27) + "@"
    endif  
    
    select EmprARQ
    if RegLock()
      replace Reci            with nReci
      dbunlock ()
    endif
    
    select RcboARQ
    set order to 1
    if AdiReg()
      if RegLock()
        replace Rcbo         with nReci
        replace Valo         with nValor
        replace Data         with dData
        replace Receb        with cReceb
        replace Ref1         with cRef01
        replace Ref2         with cRef02
        replace Nome         with cNome
        dbunlock ()
      endif
    endif

    nReci ++
  next  
  
  set printer to
  set printer off
  set device  to screen

  if EmprARQ->Caixa == "X" 
    cNota := strzero( nReci, 6 )
    dPgto := dData
    nPago := nValor
    cHist := alltrim( cReceb ) + " " + alltrim( cRef01 )
      
    DestLcto ()
  endif
  
  if lOpenRcbo
    select RcboARQ
    close
  endif  
  
  if !empty( GetDefaultPrinter() ) .and. nPrn > 0
    PrnTest(aPrn[nPrn], memoread( cArqTxt ), .f. )
  endif
return NIL   

//
//  Imprimir Recibos Emitidos
//
function PrinRcEm()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "RcboARQ", .t. )
    VerifIND( "RcboARQ" )

    #ifdef DBF_NTX
      set index to RcboIND1
    #endif
  endif

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 05, 12, 09, 65, mensagem( 'Janela', 'PrinRcEm', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 07,14 say 'Recibo Inicial             Recibo Final '
  @ 08,14 say '  Data Inicial               Data Final '

  select RcboARQ
  set order to 1
  dbgotop ()
  nReciIni := Rcbo 
  dbgobottom ()
  nReciFin := Rcbo 
  dDataIni := ctod('01/01/96') 
  dDataFin := date()

  @ 07,29 get nReciIni    pict '999999' 
  @ 07,54 get nReciFin    pict '999999'   valid nReciFin >= nReciIni
  @ 08,29 get dDataIni    pict '99/99/9999' 
  @ 08,54 get dDataFin    pict '99/99/9999' valid dDataFin >= dDataIni
  read 
  
  if lastkey () == K_ESC
    select RcboARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif  
  
  Aguarde ()

  nPag    := 1
  nLin    := 0
  cArqu2  := cArqu2 + "." + strzero( nPag, 3 )
  lInicio := .t.
  nTotal  := 0
  nRecibo := 0

  select RcboARQ
  set order to 1
  dbseek( nReciIni, .t. )
  do while Rcbo >= nReciIni .and. Rcbo <= nReciFin .and. !eof()
    if Data >= dDataIni .and. Data <= dDataFin
      if lInicio
        set printer to ( cArqu2 )
        set device  to printer
        set printer on

        lInicio := .f.
      endif  
    
      if nLin == 0
        Cabecalho( 'Recibos Emitidos', 132, 3 )
        CabRcbo()
      endif
   
      @ nLin,001 say Rcbo                                     pict '999999'
      @ nLin,008 say Data                                     pict '99/99/9999'
      @ nLin,019 say Valo                                     pict '@E 999,999.99'
      @ nLin,030 say Receb                                    pict '@S30'
      @ nLin,061 say alltrim( Ref1 ) + ' ' + alltrim( Ref2 )  pict '@S45'
      @ nLin,107 say Nome                                     pict '@S20'
      nLin ++
      
      nRecibo ++
      nTotal  += Valo

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
    @ nLin,005 say 'Total Geral' 
    @ nLin,019 say nTotal                        pict '@E 999,999.99'
    @ nLin,030 say 'Qtde: ' + str( nRecibo, 4 )
    Rodape(132)
  endif  
 
  set printer to
  set printer off
  set device  to screen

  if Imprimir( cArqu3, 132 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Relatório de Recibos Emitidos"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 132
      replace Empr       with cEmpresa
      dbunlock ()
    endif
    close
  endif  

  select RcboARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabRcbo ()
  @ 02,01 say 'Recibo Data            Valor Recebi                         Referente                                     Nome'

  nLin := 4
return NIL