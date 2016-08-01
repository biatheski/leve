//  Leve, Mala direta
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

function Agen( xAlte )

if SemAcesso( 'Agen' )
  return NIL
endif  

if NetUse( "AgenARQ", .t. )
  VerifIND( "AgenARQ" )
  
  lOpenAgen := .t.
  
  #ifdef DBF_NTX  
    set index to AgenIND1, AgenIND2, AgenIND3, AgenIND4, AgenIND5, AgenIND6
  #endif  
else  
  lOpenAgen := .f. 
endif

// Variaveis de Entrada
cAgen  := space(4)
nAgen  := nCep   := 0
dNasc  := dData  := ctod('  /  /  ')
cNome  := cEmail := cURL := space(30)
cEnde  := space(34)
cBair  := space(15)
cCida  := space(20)
cUF    := space(2)
cFone  := cfax   := space(14)
cObse  := space(132)

Janela( 05, 08, 21, 70, mensagem( 'Janela', 'Agenda', .f. ), .t. )
setcolor( CorJanel + ',' + CorCampo ) 
@ 07,10 say '    Código'
@ 07,43 say ' Data' 
@ 09,10 say '      Nome'
@ 10,10 say 'Data Nasc.'
@ 10,43 say 'Idade' 
@ 12,10 say '  Endereço'
@ 13,10 say '    Bairro'
@ 13,45 say 'CEP'
@ 14,10 say '    Cidade'
@ 14,46 say 'UF'
@ 15,10 say '      Fone'
@ 15,45 say 'Fax'
@ 16,10 say '     Email'
@ 16,45 say 'URL'
@ 18,10 say 'Observação'

MostOpcao( 20, 10, 22, 46, 59 )
tAgen  := savescreen( 00, 00, 23, 79 )

select AgenARQ
set order to 1
if lOpenAgen
  dbgobottom ()
endif
do while .t.
  Mensagem( 'Agen', 'Janela' )

  select AgenARQ
  set order to 1

  restscreen( 00, 00, 23, 79, tAgen )
  cStat := space(04)
  MostAgen ()
  
  if Demo ()
    exit
  endif  

  setcolor( CorJanel + ',' + CorCampo)
  MostTudo := 'MostAgen'
  cAjuda   := 'Agen'
  cStat    := space(04)
  lAjud    := .T.

  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  if lastkey() == K_ALT_A 
    nAgen := val( Agen )
  else  
    if xAlte
      @ 07,21 get nAgen                    pict '999999'
      read
    else
      dbgobottom ()
    
      nAgen := val( Agen ) + 1
    endif  
  endif    

  set key K_PGUP      to
  set key K_PGDN      to
  set key K_CTRL_PGUP to
  set key K_CTRL_PGDN to
  set key K_UP        to

  if lastkey() == K_ESC .or. nAgen == 0
    exit
  endif

  cAgen := strzero( nAgen, 6 )

  setcolor( CorCampo )
  @ 07,21 say cAgen

  // Verifica se Existe o código cadastrado
  select AgenARQ
  set order to 1
  dbseek( cAgen, .f. )
  if eof() 
    cStat  := 'incl'
  else
    cStat  := 'alte'
  endif

  Mensagem('Agen', cStat)

  MostAgen()
  EntrAgen()
   
  Confirmar( 20, 10, 22, 46, 59, 3 )

  if cStat == 'prin'
    PrinAgen(.f.)
  endif

  if cStat == 'excl'
    ExclRegi ()
  endif
  
  if cStat == 'incl'
    if AdiReg()
      replace Agen    with cAgen
      dbunlock ()
    endif
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Data      with dData
      replace Nome      with cNome
      replace Nasc      with dNasc
      replace Ende      with cEnde
      replace Bair      with cBair
      replace Cida      with cCida
      replace Cep       with nCep
      replace UF        with cUF
      replace Fone      with cFone
      replace Fax       with cFax
      replace Obse      with cObse
      replace Email     with cEmail
      replace URL       with cURL
      dbunlock ()
    endif
  endif
enddo

if lOpenAgen
  select AgenARQ
  close
endif 
return NIL

//
// Entra com os dados da Agenda
//
function EntrAgen ()
  if empty( dData )
    dData := date()
  endif  

  setcolor( CorJanel + ',' + CorCampo )
  @ 07,49 get dData          pict '99/99/9999'  
  @ 09,21 get cNome          pict '@!'
  @ 10,21 get dNasc          pict '99/99/9999'  valid MostIdad()
  @ 12,21 get cEnde          pict '@S40'
  @ 13,21 get cBair          pict '@S15'
  @ 13,49 get nCEP           pict '99999-999'
  @ 14,21 get cCida          pict '@S20'
  @ 14,49 get cUF            pict '@!' valid validUF(14, 49, 'AgenARQ')
  @ 15,21 get cFone          
  @ 15,49 get cFax           
  @ 16,21 get cEmail         pict '@S20'
  @ 16,49 get cURL           pict '@S20'
  @ 18,21 get cObse          pict '@S45'
  read
return NIL

function MostIdad()
  nIdad := iif( empty( dNasc ), 0, int( ( date() - dNasc ) / 365 ) )  
  
  setcolor( CorCampo )
  @ 10,49 say nIdad            pict '99'

  setcolor( CorJanel + ',' + CorCampo )
return(.t.)

//
// Mostra os dados da Agenda
//
function MostAgen ()
  setcolor( CorCampo )
  if cStat != 'incl'
    cAgen := Agen
    nAgen := val( Agen )
    
    @ 07, 21 say nAgen          pict '999999'
  endif
  
  dData  := Data
  cNome  := Nome
  cEnde  := Ende
  cBair  := Bair
  cCida  := Cida
  nCep   := Cep
  cUF    := UF
  cFone  := Fone
  cFax   := Fax
  dNasc  := Nasc
  cObse  := Obse
  cEmail := Email
  cURL   := URL
  nIdad  := iif( empty( dNasc ), 0, int( ( date() - dNasc ) / 365 ) ) 

  @ 07,49 say dData             pict '99/99/9999'  
  @ 09,21 say cNome             pict '@!'
  @ 10,21 say dNasc             pict '99/99/9999'
  @ 10,49 say nIdad             pict '99'
  @ 12,21 say cEnde             pict '@S40'
  @ 13,21 say cBair             pict '@S15'
  @ 13,49 say nCep              pict '99999-999'
  @ 14,21 say cCida             pict '@S20'
  @ 14,49 say cUF               pict '@!'
  @ 15,21 say cFone             
  @ 15,49 say cFax              
  @ 16,21 say cEmail            pict '@S20'
  @ 16,49 say cURL              pict '@S20'
  @ 18,21 say cObse             pict '@S45'
  
  PosiDBF( 05, 70 )
return NIL

//
// Imprimir dados da agenda
//
function PrinAgen()

  local cArqu2 := CriaTemp(5)
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( 'AgenARQ', .t. )
    VerifIND( 'AgenARQ' )
    
    pOpenAgen := .t.

    #ifdef DBF_NTX  
      set index to AgenIND1, AgenIND2, AgenIND3, AgenIND4, AgenIND5, AgenIND6
    #endif  
  else  
    pOpenAgen := .f.
  endif
  
  tPrt := savescreen( 00, 00, 23, 79 )

  Janela ( 08, 02, 16, 76, mensagem( 'Janela', 'PrinAgen', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,04 say '      Cliente Inicial                     Cliente Final'
  @ 11,04 say 'Data Cadastro Inicial               Data Cadastro Final'
  @ 13,04 say '       Cidade Inicial                      Cidade Final'
  @ 15,04 say '                Ordem'

  setcolor ( 'n/w+' )
  @ 15,37 say chr(25)
  
  setcolor( CorCampo )
  @ 15,26 say ' Nome     '

  select AgenARQ
  set order to 1
  dbgotop ()
  nAgenIni := val( Agen )
  dbgobottom ()
  nAgenFin := val( Agen )
  dDataIni  := ctod ('01/01/90')
  dDataFin  := date ()
  cCidaIni  := 'A' + space(14)
  cCidaFin  := 'ZZ' + space(13)

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,26 get nAgenIni  pict '999999'     valid ValidARQ( 99, 99, "AgenARQ", "Código" , "Agen", "Descrição", "Nome", "Agen", "nAgenIni", .t., 6, "Consulta da Agenda", "AgenARQ", 40 ) 
  @ 10,60 get nAgenFin  pict '999999'     valid ValidARQ( 99, 99, "AgenARQ", "Código" , "Agen", "Descrição", "Nome", "Agen", "nAgenFin", .t., 6, "Consulta da Agenda", "AgenARQ", 40 ) .and. nAgenFin >= nAgenIni
  @ 11,26 get dDataIni  pict '99/99/9999'
  @ 11,60 get dDataFin  pict '99/99/9999' valid dDataFin >= dDataIni
  @ 13,26 get cCidaIni               
  @ 13,60 get cCidaFin                  valid cCidaFin >= cCidaIni
  read

  if lastkey () == K_ESC
    if pOpenAgen
     select AgenARQ
     close
    endif  
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  tLinha  := savescreen( 24, 01, 24, 79 )
  aOpcao  := {}

  aadd( aOpcao, { ' Codigo   ', 2, 'C', 15, 26, "Relatório em ordem num‚rica de Codigo." } )
  aadd( aOpcao, { ' Nome     ', 2, 'N', 15, 26, "Relatório em ordem alfab‚tica por Nome." } )
  aadd( aOpcao, { ' Endereço ', 2, 'E', 15, 26, "Relatório em ordem alfab‚tica por Endereço." } )
  aadd( aOpcao, { ' Cidade   ', 3, 'I', 15, 26, "Relatório em ordem alfab‚tica por Cidade." } )
  aadd( aOpcao, { ' Bairro   ', 2, 'B', 15, 26, "Relatório em ordem alfab‚tica por Bairro." } )
  aadd( aOpcao, { ' Obse.    ', 2, 'O', 15, 26, "Relatório em ordem alfab‚tica por Observação." } )

  nOrdem  := HCHOICE( aOpcao, 6, 2 )
    
  restscreen( 24, 01, 24, 79, tLinha )

  if lastkey () == K_ESC
    if pOpenAgen
     select AgenARQ
     close
    endif  
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  Aguarde ()

  nPag     := 1
  nLin     := 0
  cArqu2   := cArqu2 + '.' + strzero( nPag, 3 )
  lInicio  := .f.
  cAgenIni := strzero( nAgenIni, 6 )
  cAgenFin := strzero( nAgenFin, 6 )
  nCidaIni := len( alltrim( cCidaIni ) )
  nCidaFin := len( alltrim( cCidaFin ) )
  
  select AgenARQ
  set order to nOrdem
  dbgotop()
  do while !eof()
    if Agen >= cAgenIni .and. Agen <= cAgenFin .and. Data >= dDataIni .and. Data <= dDataFin .and.;
      left( Cida, nCidaIni ) >= alltrim( cCidaIni ) .and. left( Cida, nCidaFin ) <= alltrim( cCidaFin )
    
      if !lInicio
        set printer to &cArqu2
        set printer on
        set device  to print
        
        lInicio := .t.
      endif   
    
      if nLin == 0
        Cabecalho( 'Agenda', 132, 6 )
        CabAgen ()
      endif

      @ nLin,001 say Agen 
      @ nLin,006 say Nome       pict '@S30' 
      @ nLin,037 say Ende       pict '@S30' 
      if Cep > 0
      @ nLin,068 say Cep        pict '99999-999'
      endif
      @ nLin,078 say Bair       pict '@S10' 
      @ nLin,089 say Cida       pict '@S10' 
      @ nLin,100 say UF
      @ nLin,103 say Fone       
      @ nLin,118 say Obse       pict '@S14'
      nLin ++

      if nLin >= pLimite
        Rodape(132)

        set printer to
        set printer off

        cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
        cArqu2 := cArqu2 + '.' + strzero( nPag, 3 )

        set printer to &cArqu2
        set printer on
      endif  
    endif

    dbskip ()
  enddo
  
  if lInicio  
    Rodape(132)
  endif  

  set printer to
  set printer off
  set device to screen
  
  if Imprimir ( cArqu3, 132 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with 'Relatório do Cadastro da Agenda'
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 132
      replace Empr       with cEmpresa
      dbunlock ()
    endif
  endif  

  select AgenARQ
  set order to 1 
  if pOpenAgen 
    close
  else  
    dbgobottom ()
  endif  
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabAgen ()
  @ 02,01 say 'Cod   Nome                         Endereço                       CEP       Bairro     Cidade     UF Fone           Observação' 
    
  nLin := 4
return NIL

//
// Imprimir Aniversariantes da Agenda
//
function PrinAniv ()

  local cArqu2 := CriaTemp(5)
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( 'AgenARQ', .t. )
    VerifIND( 'AgenARQ' )
   
    #ifdef DBF_NTX  
      set index to AgenIND1
    #endif  
  endif

  tPrt := savescreen( 00, 00, 23, 79 )

  Janela( 06, 27, 10, 53, mensagem( 'Janela', 'PrinAniv', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )
  @ 08, 29 say ' Mês Inicial'
  @ 09, 29 say '   Mês Final'

  select AgenARQ
  dNascIni := 1
  dNascFin := 12

  @ 08, 42 get dNascIni                 pict '99'
  @ 09, 42 get dNascFin                 pict '99' valid dNascFin >= dNascIni
  read

  if lastkey() == K_ESC
    select AgenARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  Aguarde ()
   
  nPag    := 1
  nLin    := 0
  cArqu2  := cArqu2 + '.' + strzero( nPag, 3 )
  lInicio := .t.

  select AgenARQ
  set order  to 1
  dbgotop ()
  do while ! eof()
    if month( Nasc ) >= dNascIni .and. month( Nasc ) <= dNascFin
      if lInicio
        set printer to &cArqu2
        set printer on
        set device  to print
        
        lInicio := .f.
      endif
      
      if nLin == 0
        Cabecalho( 'Aniversariantes', 80, 1 )   
        CabAgenA ()
      endif

      @ nLin,04 say Agen
      @ nLin,14 say Nome
      @ nLin,56 say Nasc
      nLin ++

      if nLin >= pLimite
        Rodape(80)

        set printer to
        set printer off
 
        cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
        cArqu2 := cArqu2 + '.' + strzero( nPag, 3 )
 
        set printer to &cArqu2
        set printer on
      endif
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
      replace rela       with cArqu3
      replace Titu       with 'Relatório de Aniversariantes da Agenda'
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
  endif  

  select AgenARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabAgenA ()
  @ 03,01 say '   Agenda  Nome                                        Nascimento'

  nLin := 5
return NIL  

//
// Imprimir Etiqueta da Mala Direta
//
function PrinEtiq ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "AgenARQ", .t. )
    VerifIND( "AgenARQ" )
 
    #ifdef DBF_NTX  
      set index to AgenIND1, AgenIND2
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
  Janela ( 07, 12, 11, 61, mensagem( 'Janela', 'PrinAgen', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 09,14 say ' Codigo Inicial              Codigo Final'
  @ 10,14 say 'Qtde. de Cópias'

  select AgenARQ
  set order  to 1
  dbgotop ()
  nAgenIni := val( Agen )
  dbgobottom ()
  nAgenFin := val( Agen )
  nQtdeCop := 1
 
  @ 09,30 get nAgenIni         pict '999999'     valid ValidARQ( 99, 99, "AgenARQ", "Código" , "Agen", "Descrição", "Nome", "Agen", "nAgenIni", .t., 6, "Agenda", "AgenARQ", 40 )  
  @ 09,56 get nAgenFin         pict '999999'     valid ValidARQ( 99, 99, "AgenARQ", "Código" , "Agen", "Descrição", "Nome", "Agen", "nAgenFin", .t., 6, "Agenda", "AgenARQ", 40 ) .and. nAgenFin >= nAgenIni
  @ 10,30 get nQtdeCop         pict '9999'     valid nQtdeCop > 0
  read

  if lastkey () == K_ESC
    select AgenARQ
    close
    select CampARQ
    close
    select EtiqARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  Aguarde ()

  cAgenIni := strzero( nAgenIni, 6 )
  cAgenFin := strzero( nAgenFin, 6 )

  select EtiqARQ
  set order to 1
  dbseek( EmprARQ->EtiqAgen, .f. )

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

    select AgenARQ
    close
    select CampARQ
    close
    select EtiqARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  cTexto     := Layout
  nLin       := 1
  nEspa      := Espa
  nComp      := Comp
  nLargura   := Tama
  nColunas   := Colunas
  nDistancia := Distancia
  nSalto     := Salto
  aLayout    := {}
  cQtLin     := mlcount( cTexto, nLargura )

  for nK := 1 to cQtLin
    cLinha := memoline( cTexto, nLargura, nK )

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
 
  if !TestPrint( 1 )
    select AgenARQ
    close
    select CampARQ
    close
    select EtiqARQ
    close
    set device to screen
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

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

  nLinIni := aLayout[ 1, 1 ]
  nLinFin := aLayout[ len( aLayout ), 1 ]
  xLin    := 0
  nCopia  := 0
  
  select AgenARQ
  set order to 1
  dbseek( cAgenIni, .t. )
  do while Agen >= cAgenIni .and. Agen <= cAgenFin
    for nH := 1 to nColunas
      s       := strzero( nH, 2 )
      aEtiq&s := {}
    next
    
    if nCopia == 0   
      nCopia := nQtdeCop
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
        dbskip()  
        
        nCopia := nQtdeCop
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
            nCol += ( nLargura + nDistancia ) * ( nA - 1 )
          endif

          if nLin == nLinha 
            @ xLin, nCol say alltrim( cCampo )
          endif
        next   
      next  
  
      xLin ++
    next

    xLin += ( nSalto - 1 )

    @ xLin,00 say chr(13)
  enddo

  @ nLin,00 say chr(27) + '@'
  
  set printer to
  set printer off
  set device  to screen
  
  select AgenARQ
  close
  select CampARQ
  close
  select EtiqARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL