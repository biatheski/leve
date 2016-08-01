//  Leve, Cliente Simplificado
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

function Clin( xAlte )
  local GetList := {}
  
if SemAcesso( 'Clin' )
  return NIL
endif  

if NetUse( "CEPeARQ", .t. )
  VerifIND( "CEPeARQ" )

  eOpenCEPe := .t.

  #ifdef DBF_NTX
    set index to CEPeIND1, CEPeIND2, CEPeIND3, CEPeIND4
  #endif  
else
  eOpenCEPe := .f.  
endif

if NetUse( "ClieARQ", .t. )
  VerifIND( "ClieARQ" )
  
  lOpenClin := .t.
  
  #ifdef DBF_NTX
    set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
  #endif  
else 
  lOpenClin := .f.  
endif

if NetUse( "ReprARQ", .t. )
  VerifIND( "ReprARQ" )
  
  lOpenRepr := .t.
  
  #ifdef DBF_NTX
    set index to ReprIND1, ReprIND2
  #endif
else 
  lOpenRepr := .f.  
endif

//  Variaveis de entrada para Clientees
nClie     := nCEP     := cPerC := nRepr := 0
cRepr     := strzero( 0, 4 )
cClie     := cRepr    := space(4)
cFone     := cFax     := cCelu := space(14)
cBair     := cViaTra  := space(14)
cNoCr     := space(45)
cEnde     := space(34)
cCida     := space(30)
cEmail    := cUrl     := cObse := space(50)
cUF       := space(2)

//  Tela Clieesentante
Janela ( 04, 06, 21, 75, mensagem( 'Janela', 'Clin', .f. ), .t. )

setcolor ( CorJanel )
@ 06,08 say '      Codigo'
@ 08,08 say '        Nome'

@ 10,08 say '         CEP'
@ 10,32 say 'Endereço'
@ 11,08 say '      Bairro'                    
@ 11,39 say 'Cidade'
@ 11,68 say 'UF'

@ 13,08 say '     Celular'
@ 13,36 say 'Fone'
@ 13,56 say 'Fax'
@ 14,08 say '      E-mail'
@ 14,41 say ' Url'
@ 16,08 say '  Observação'
@ 18,08 say '    Vendedor'

MostOpcao( 20, 08, 20, 51, 64 ) 
tClie := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Cliente
select ClieARQ
set order to 1
if lOpenClin
  dbgobottom ()
endif  
do while .t.
  Mensagem ( 'Clin', 'Janela' )

  select ClieARQ
  set order    to 1
  set relation to Repr into ReprARQ

  cStat := space(04)
  restscreen( 00, 00, 23, 79, tClie )
  MostClin()
  
  if Demo ()
    exit
  endif  
  
  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostClin'
  cAjuda   := 'Clin'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
   
  if lastkey() == K_ALT_A
    nClie := val( Clie )
  else   
    if xAlte 
      @ 06,21 get nClie pict '999999'
      read
    else
      nClie := 0
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
  cClie := strzero( nClie, 6 )
  @ 06,21 say cClie

  //  Verificar existencia do Cliente para Incluir ou Alterar
  select ClieARQ
  set order to 1
  dbseek( cClie, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte' 

    if Tipo == 'J'
      Alerta ( mensagem( 'Alerta', 'Juridica', .f. ) )
      loop
    endif
    if Tipo == 'F'
      Alerta ( mensagem( 'Alerta', 'Fisica', .f. ) )
      loop
    endif
  endif

  Mensagem( 'Clin', cStat )
  
  MostClin()
  EntrClin()

  Confirmar ( 20, 08, 20, 51, 64, 3 )

  if cStat == 'prin'
    PrinClin (.f.)
  endif
    
  if cStat == 'excl'
    lFound := .f.
  
    if NetUse( "NSaiARQ", .t. )
      VerifIND( "NSaiARQ" )
  
      #ifdef DBF_NTX
        set index to NSaiIND1, NSaiIND2, NSaiIND3, NSaiIND4
      #endif    
    endif
    
    select NSaiARQ
    set order to 2
    dbseek( cClie, .f. )
    
    if found()
      lFound := .t.
    endif  
    
    close

    if NetUse( "PediARQ", .t. )
      VerifIND( "PediARQ" )
  
      #ifdef DBF_NTX
        set index to PediIND1, PediIND2, PediIND3, PediIND4, PediIND5
      #endif    
    endif
    
    select PediARQ
    set order to 2
    dbseek( cClie, .f. )
    
    if found()
      lFound := .t.
    endif  
    
    close

    if NetUse( "ReceARQ", .t. )
      VerifIND( "ReceARQ" )
  
      #ifdef DBF_NTX
        set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
      #endif    
    endif
    
    select ReceARQ
    set order to 2
    dbseek( cClie, .f. )
    
    if found()
      lFound := .t.
    endif  
    
    close

    if NetUse( "AbOSARQ", .t. )
      VerifIND( "AbOSARQ" )
  
      #ifdef DBF_NTX
        set index to AbOSIND1, AbOSIND2, AbOSIND3
      #endif    
    endif
    
    select AbOsARQ
    set order to 2
    dbseek( cClie, .t. )
    
    if Clie == cClie
      lFound := .t.
    endif  
    
    close
    
    if lFound
      Janela( 09, 20, 14, 60, mensagem( 'Janela', 'Atencao', .f. ), .t. )
      setcolor( CorJanel )
     
      @ 11,22 say 'Existe movimentação deste cliente !!!' 
      @ 13,22 say '             Continuar...' 
      
      if !ConfLine( 13, 48, 2 )
        loop
      endif  
    endif
    
    select ClieARQ

    ExclRegi ()
  endif
  
  if cStat == 'incl'
    if cClie == "000000"
      cClie := "000001"
    endif    

    set order to 1  
    do while .t.
      dbseek( cClie, .f. )
      if found()
        nClie := val( cClie ) + 1               
        cClie := strzero( nClie, 6 )
      else 
        exit   
      endif
    enddo

    if AdiReg()
      if RegLock()
        replace Clie     with cClie
        replace Tipo     with 'S'
        replace Data     with date()
        dbunlock ()
      endif
    endif 
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Nome       with cNoCr
      replace Ende       with cEnde
      replace Cida       with cCida
      replace CEP        with nCEP
      replace UF         with cUF
      replace Bair       with cBair
      replace Fone       with cFone
      replace Fax        with cFax
      replace Celu       with cCelu
      replace Email      with cEmail
      replace Url        with cUrl 
      replace Repr       with cRepr
      replace Obse       with cObse
      dbunlock ()
    endif

    if !xAlte
      xAlte := .t.
      keyboard(chr(27))
    endif  
  endif
enddo

if lOpenClin
  select ClieARQ
  close
endif  

if eOpenCEPe
  select CEPeARQ
  close 
endif

return NIL

//
// Entra dados do Cliente
//
function EntrClin()
  local GetList := {}
  
  do while .t.
    lAlterou := .f.
  
    setcolor ( CorJanel + ',' + CorCampo )
    @ 08,21 get cNoCr
    @ 10,21 get nCEP        pict '99999-999' valid ValidCEP( 10, 21, "ClieARQ", 41, 21, 46, 71 )
    @ 10,41 get cEnde       pict '@S33'
    @ 11,21 get cBair       pict '@S15'  
    @ 11,46 get cCida       pict '@S18'
    @ 11,71 get cUF         pict '@!'       valid ValidUF( 11, 71, "ClieARQ" )
    @ 13,21 get cCelu       pict '@S14'       
    @ 13,41 get cFone       pict '@S14'              
    @ 13,60 get cFax        pict '@S14'              
    @ 14,21 get cEmail      pict '@S19'       
    @ 14,46 get cUrl        pict '@S19'              
    @ 16,21 get cObse       pict '@S40'
    @ 18,21 get nRepr       pict '999999'  valid ValidARQ( 18, 21, "ClieARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nRepr", .t., 6, "Consulta de Vendedores", "ReprARQ", 40 )
    read

    cRepr := strzero( nRepr, 6 )

    if cNoCr      != Nome;  lAlterou := .t.
    elseif nCEP   != CEP;   lAlterou := .t.
    elseif cEnde  != Ende;  lAlterou := .t.
    elseif cBair  != Bair;  lAlterou := .t.
    elseif cCida  != Cida;  lAlterou := .t.
    elseif cUF    != UF;    lAlterou := .t.
    elseif cCelu  != Celu;  lAlterou := .t.
    elseif cFone  != Fone;  lAlterou := .t.
    elseif cFax   != Fax;   lAlterou := .t.
    elseif cEmail != Email; lAlterou := .t.
    elseif cUrl   != Url;   lAlterou := .t.
    elseif cObse  != Obse;  lAlterou := .t.
    elseif cRepr  != Repr;  lAlterou := .t.
    endif
     
    if !Saindo(lAlterou)
      loop
    endif    
    exit
  enddo  
return NIL

//
// Mostra dados do Cliente
//
function MostClin()
  
  setcolor ( CorCampo )
  if cStat != 'incl'
    nClie   := val( Clie )
    cClie   := Clie

    @ 06,21 say cClie
  endif
     
  cNoCr     := Nome
  cCelu     := Celu
  cEnde     := Ende
  cCida     := Cida  
  nCEP      := CEP
  cBair     := Bair  
  cUF       := UF
  cCelu     := Celu
  cFone     := Fone
  cFax      := Fax
  cEmail    := Email
  cUrl      := Url
  cObse     := Obse
  cRepr     := Repr
  nRepr     := val( Repr )

  setcolor ( CorCampo )
  @ 08,21 say cNoCr
  @ 10,21 say nCEP           pict '99999-999'
  @ 10,41 say cEnde          pict '@S33' 
  @ 11,21 say cBair          pict '@S15'
  @ 11,46 say cCida          pict '@S18'
  @ 11,71 say cUF            pict '@!'
  @ 13,21 say cCelu          pict '@S14'         
  @ 13,41 say cFone          pict '@S14'                
  @ 13,60 say cFax           pict '@S14'                 
  @ 14,21 say cEmail         pict '@S19'         
  @ 14,46 say cUrl           pict '@S19'                
  @ 16,21 say cObse          pict '@S40'
  @ 18,21 say nRepr          pict '999999'
  @ 18,28 say ReprARQ->Nome  pict '@S40'
  PosiDBF( 04, 75 )
return NIL

//
// Imprime dados do Cliente
//
function PrinClin ( lAbrir )

  local cArqu2  := CriaTemp( 5 )
  local cArqu3  := right ( cArqu2, 8 )

  local cRData  := date()
  local cRHora  := time()

  local GetList := {}

  if lAbrir
    if NetUse( "ClieARQ", .t. )
      VerifIND( "ClieARQ" )

      #ifdef DBF_NTX
        set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
      #endif    
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 06, 25, 10, 55, mensagem( 'Janela', 'PrinClin', .f. ), .f. )

  setcolor ( Corjanel + ',' + CorCampo )
  @ 08,27 say 'Cliente Inicial'
  @ 09,27 say '  Cliente Final'

  select ClieARQ
  set order  to 1
  dbgotop ()
  nClieIni := val( Clie )
  dbgobottom ()
  nClieFin := val( Clie )

  @ 08,44 get nClieIni        pict '999999' valid ValidARQ( 99, 99, "ClieARQ", "Código" , "Clie", "Descrição", "Nome", "Clie", "nClieIni", .t., 6, "Consulta de Cliente", "ClieARQ", 40 )
  @ 09,44 get nClieFin        pict '999999' valid ValidARQ( 99, 99, "ClieARQ", "Código" , "Clie", "Descrição", "Nome", "Clie", "nClieFin", .t., 6, "Consulta de Cliente", "ClieARQ", 40 ) .and. nClieFin >= nClieIni
  read

  if lastkey() == K_ESC
    select ClieARQ
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
  lInicio  := .t.

  cClieIni := strzero( nClieIni, 4 )
  cClieFin := strzero( nClieFin, 4 )
  
  select ClieARQ
  set order to 1
  dbseek( cClieIni, .t. )
  do while Clie >= cClieIni .and. Clie <= cClieFin .and. !eof()
    if lInicio 
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
    
      lInicio := .f.
    endif  

    if nLin == 0
      Cabecalho( 'Clientes', 80, 3 )
      CabClin()
    endif

    @ nLin, 00 say Clie     pict '999999'
    @ nLin, 08 say Nome
    if !empty( Fone )
      @ nLin, 50 say Fone   
    endif
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
      replace Titu       with "Relatório de Clientes"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
    close
  endif  
 
  select ClieARQ
  if lAbrir
    close
  else  
    set order  to 1 
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabClin ()
  @ 02, 00 say 'Cod'
  @ 02, 08 say 'Nome'
  @ 02, 50 say 'Telefone'

  nLin := 04
return NIL