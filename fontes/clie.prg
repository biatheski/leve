//  Leve, Cadastro de Cliente
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

function Clie( xAlte )
  local GetList := {}
  
  if SemAcesso( 'Clie' )
    return NIL
  endif  

if NetUse( "ClieARQ", .t. )
  VerifIND( "ClieARQ" )
  
  eOpenClie := .t.
  
  #ifdef DBF_NTX
    set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
  #endif  
else  
  eOpenClie := .f.
endif

if NetUse( "ReprARQ", .t. )
  VerifIND( "ReprARQ" )

  eOpenRepr := .t.

  #ifdef DBF_NTX
    set index to ReprIND1, ReprIND2
  #endif  
else
  eOpenRepr := .f.  
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

if NetUse( "TpEnARQ", .t. )
  VerifIND( "TpEnARQ" )
  
  eOpenTpEn := .t.

  #ifdef DBF_NTX
    set index to TpEnIND1, TpEnIND2
  #endif  
else
  eOpenTpEn := .f.  
endif

if NetUse( "ICliARQ", .t. )
  VerifIND( "ICliARQ" )
  
  eOpenICli := .t.

  #ifdef DBF_NTX
    set index to ICliIND1
  #endif  
else
  eOpenICli := .f.  
endif

//  Variaveis de Entrada para Cliente
nClie     := nCEP      := 0
nVend     := 0
cUF       := space(02)
cClie     := space(4)
cCGC      := space(14)
cBair     := cInscEstd := space(20)
cRamal    := cVend     := space(04)
cFone     := cFax      := cCelu  := space(14)
cContato  := cCida     := space(30)
cNoCl     := cEnde     := space(45)
cRazao    := space(30)
cEmail    := cUrl      := cObse    := space(50)

//  Tela Cliente
Janela ( 02, 06, 21, 76, mensagem( 'Janela', 'Clie', .f. ), .t. )

setcolor ( CorJanel )
@ 04,08 say '      Código'

@ 06,08 say 'Razão Social'
@ 07,08 say '        Nome' 
@ 09,08 say '         CEP'
@ 09,32 say 'Endereço'
@ 10,08 say '      Bairro'                    
@ 10,39 say 'Cidade'
@ 10,68 say 'UF'
@ 12,08 say '        Fone'
@ 12,36 say 'Fax'
@ 12,56 say 'Cel'
@ 13,08 say '     Contato'
@ 13,54 say 'Ramal'
@ 14,08 say '       Email'
@ 14,50 say 'Url'
@ 16,08 say '  Insc. CNPJ'
@ 16,41 say 'Insc. Estad.'
@ 17,08 say '  Observação'
@ 18,08 say '    Vendedor'

MostGeral( 20, 08, 20, 34, 51, 64, ' Endereço ', 'E', 2 ) 
tClie := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Cliente
select ClieARQ
set order  to 1
set filter to
if eOpenClie
  dbgobottom ()
endif  
do while  .t.
  Mensagem ( 'Clie', 'Janela' )

  select ClieARQ
  set order    to 1
  set relation to Repr into ReprARQ 

  restscreen( 00, 00, 23, 79, tClie )
  cStat := space(04)

  MostClie()
  
  if Demo()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostClie'
  cAjuda   := 'Clie'
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
      @ 04,21 get nClie         pict '999999'
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
  
  cClie := strzero( nClie, 6 )
  
  if cClie == '999999'
    Alerta( mensagem( 'Alerta', 'Clie9999', .f. ) )
    loop
  endif  
  
  setcolor( CorCampo )
  @ 04,21 say cClie         pict '999999'

  // Verificar existencia do Cliente para Incluir ou Alterar
  select ClieARQ
  set order to 1
  dbseek( cClie, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'

    if Tipo == 'F'
      Alerta ( mensagem( 'Alerta', 'Fisica', .f. ) )
      loop
    endif
    if Tipo == 'S'
      Alerta ( mensagem( 'Alerta', 'Simples', .f. ) )
      loop
    endif
  endif
  
   Mensagem( 'Clie', cStat )

  fStatAux := cStat
  
  MostClie()
  EntrClie()
  
  ConfGeral( 20, 08, 20, 34, 51, 64, ' Endereço ', 'E', 2, 4 )
    
  if cStat == 'gene'
    EntrICli ()
    
    select ClieARQ
  
    cStat := fStatAux
  endif
  
  if cStat == 'prin'
    PrinClie (.f.)
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
        replace Clie       with cClie
        replace Data       with date()
        replace Tipo       with 'J'
        replace Dias40     with .t.
        replace Dias60     with .t.
        dbunlock ()
      endif
    endif  
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Razao      with cRazao
      replace Nome       with cNoCl
      replace Ende       with cEnde
      replace Cida       with cCida  
      replace CEP        with nCEP
      replace UF         with cUF
      replace Bair       with cBair  
      replace CGC        with cCGC
      replace InscEstd   with cInscEstd
      replace Fone       with cFone
      replace Ramal      with cRamal   
      replace Contato    with cContato 
      replace Email      with cEmail
      replace URL        with cURL
      replace Fax        with cFax
      replace Celu       with cCelu
      replace Repr       with cVend
      replace Obse       with cObse
      dbunlock ()
    endif
    
    if !xAlte 
      xAlte := .t.
      keyboard(chr(27))
    endif 
  endif
enddo

if eOpenClie
  select ClieARQ
  close 
endif

if eOpenRepr
  select ReprARQ
  close 
endif

if eOpenCEPe
  select CEPeARQ
  close 
endif

if eOpenTpEn
  select TpEnARQ
  close 
endif

if eOpenICli
  select ICliARQ
  close 
endif

return NIL

//  Entra Dados do Endereco do Cliente
function EntrICli ()
  local GetList := {}
  local tIAnt   := savescreen( 00, 00, 23, 79 )

  Janela ( 05, 03, 18, 76, mensagem( 'Janela', 'EntrICli', .f. ), .f. )
  setcolor ( CorJanel )
  @ 07,05 say '    Endereço'
  @ 09,05 say '        Nome'
  @ 10,05 say 'Raz„o Social'
  @ 12,05 say '         CEP'
  @ 12,29 say 'End.' 
  @ 13,05 say '      Cidade'
  @ 13,35 say 'UF'
  @ 13,43 say 'Bairro'
  @ 14,05 say ' Proximidade'
  @ 15,05 say '        Fone'
  @ 15,33 say 'Fax'
  @ 15,53 say 'Resid.'
  @ 17,05 say '  Observação'

  setcolor( CorCampo )
  @ 07,23 say space(35)
  @ 09,18 say space(40)
  @ 10,18 say space(40)
  @ 12,18 say 0             pict '99999-999'
  @ 12,34 say space(25)
  @ 12,61 say space(05)  
  @ 12,68 say space(05)
  @ 13,18 say space(15)
  @ 13,38 say space(2)
  @ 13,50 say space(15)
  @ 14,18 say space(40)
  @ 15,18 say space(14)
  @ 15,37 say space(14)
  @ 15,60 say space(14)
  @ 17,18 say space(40)
  
  nTpEn := 0
     
  @ 07,18 get nTpEn       pict '999999' valid ValidARQ( 07, 18, "ICliARQ", "Codigo", "TpEn", "Descrição", "Nome", "TpEn", "nTpEn", .t., 6, "Endereço", "TpEnARQ", 35 )
  read
  
  if lastkey() == K_ESC
    restscreen( 00, 00, 23, 79, tIAnt )
    return NIL
  endif
  
  cTpEn := strzero( nTpEn, 6 )

  iCEP   := nCep
  iEnde  := cEnde
  iCida  := cCida
  iUF    := cUF
  iBair  := cBair

  nCep   := 0
  cEnde  := space(40)
  iProx  := space(40)
  iNume  := space(5)
  iApto  := space(5)
  iNome  := space(40)
  iRazao := space(40)
  iObse  := space(40)
  iTele  := space(14)
  iFone  := space(14)
  iFax   := space(14)
  
  cCida  := space(20)
  cUF    := space(2)
  cBair  := space(20)

  select ICliARQ
  set order to 1
  dbseek( cClie + cTpEn, .f. )
  if found()
    nCep   := CEp
    cEnde  := Ende
    iNume  := Nume
    iNome  := Nome
    iApto  := Apto
    iRazao := Razao
    iProx  := Prox
    iFone  := Fone
    iFax   := Fax
    iTele  := Tele
    cCida  := Cida
    cUF    := UF
    cBair  := Bair
    iObse  := Obse
    lAchou := .t.
  
    setcolor( CorCampo )
    @ 09,18 say Nome          pict '@S40'
    @ 10,18 say Razao         pict '@S40'
    @ 12,18 say CEP           pict '99999-999'
    @ 12,34 say Ende          pict '@S25' 
    @ 12,61 say Nume       
    @ 12,68 say Apto       
    @ 13,18 say Cida          pict '@S15'
    @ 13,38 say UF            pict '@!'
    @ 13,50 say Bair          pict '@S15'
    @ 14,18 say Prox          pict '@S40'
    @ 15,18 say Fone          pict '@S14'  
    @ 15,37 say Fax           pict '@S14'  
    @ 15,60 say Tele          pict '@S14'  
    @ 17,18 say Obse          pict '@S40'
  else
    lAchou := .f.  
  endif  
 
    setcolor ( CorJanel + ',' + CorCampo )
    @ 09,18 get iNome       pict '@S40'
    @ 10,18 get iRazao      pict '@S40'
    @ 12,18 get nCEP        pict '99999-999' valid ValidCEP( 12, 18, "ICliARQ", 41, 21, 46, 71, .t. )
    @ 12,34 get cEnde       pict '@S25'
    @ 12,61 get iNume       
    @ 12,68 get iApto       
    @ 13,18 get cCida       pict '@S15'
    @ 13,38 get cUF         pict '@!' valid ValidUF ( 13, 38, "ICliARQ" )
    @ 13,50 get cBair       pict '@S15'  
    @ 14,18 get iProx       pict '@S40'
    @ 15,18 get iFone       pict '@S14'  
    @ 15,37 get iFax        pict '@S14'  
    @ 15,60 get iTele       pict '@S14'  
    @ 17,18 get iObse       pict '@S40'
    read
   
    select ICliARQ
    
  if ConfAlte()
    if !lAchou
      if AdiReg()
        replace Clie       with cClie
        replace TpEn       with cTpEn
        dbunlock()
      endif
    endif
    
    if RegLock()
      replace Razao      with iRazao
      replace Nome       with iNome
      replace Nume       with iNume
      replace Apto       with iApto
      replace Ende       with cEnde
      replace Cida       with cCida  
      replace Prox       with iProx
      replace CEP        with nCEP
      replace UF         with cUF
      replace Bair       with cBair  
      replace Fone       with iFone
      replace Fax        with iFax
      replace Tele       with iTele
      replace Obse       with iObse
      dbunlock()
    endif  
  endif  

  nCEP   := iCep
  cEnde  := iEnde
  cCida  := iCida
  cUF    := iUF
  cBair  := iBair

  restscreen( 00, 00, 23, 79, tIAnt )

  select ClieARQ
return NIL

//
// Copia a razao para o nome
//
function CopiaClie()
  if empty( cNoCl )
    cNoCl := cRazao 
  endif 
return(.t.)

//
// Entra Dados do Cliente
//
function EntrClie ()
  local GetList := {}
  
  do while .t.
    lAlterou := .f.
    
    setcolor ( CorJanel + ',' + CorCampo )
    @ 06,21 get cRazao      valid CopiaClie()
    @ 07,21 get cNoCl       pict '@K' 
    @ 09,21 get nCEP        pict '99999-999' valid ValidCEP( 09, 21, "ClieARQ", 41, 21, 46, 71 )
    @ 09,41 get cEnde       pict '@S34'
    @ 10,21 get cBair       pict '@S15'  
    @ 10,46 get cCida       pict '@S18'
    @ 10,71 get cUF         pict '@!'       valid ValidUF( 10, 71, "ClieARQ" )
    @ 12,21 get cFone       pict '@s14'               
    @ 12,40 get cFax        pict '@s14'        
    @ 12,60 get cCelu       pict '@s14'        
    @ 13,21 get cContato  
    @ 13,60 get cRamal   
    @ 14,21 get cEmail      pict '@S25'
    @ 14,54 get cUrl        pict '@S21'
    @ 16,21 get cCGC        pict '@R 99.999.999/9999-99' valid ValidCGC( cCGC )
    @ 16,54 get cInscEstd
    @ 17,21 get cObse       pict '@S40' 
    @ 18,21 get nVend       pict '999999'  valid ValidARQ( 18, 21, "ClieARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nVend", .t., 6, "Consulta de Vendedores", "ReprARQ", 40 )
    read

    cVend := strzero( nVend, 6 )

    if     cRazao     != Razao;    lAlterou := .t.
    elseif cNoCl      != Nome;     lAlterou := .t.
    elseif nCEP       != Cep;      lAlterou := .t.
    elseif cEnde      != Ende;     lAlterou := .t.
    elseif cBair      != Bair;     lAlterou := .t.
    elseif cCida      != Cida;     lAlterou := .t.
    elseif cUF        != UF;       lAlterou := .t.
    elseif cFone      != Fone;     lAlterou := .t.
    elseif cFax       != Fax;      lAlterou := .t.
    elseif cCelu      != Celu;     lAlterou := .t.
    elseif cContato   != Contato;  lAlterou := .t.
    elseif cRamal     != Ramal;    lAlterou := .t.
    elseif cEmail     != Email;    lAlterou := .t.
    elseif cUrl       != Url;      lAlterou := .t.
    elseif cCGC       != CGC;      lAlterou := .t.
    elseif cInscEstd  != InscEstd; lAlterou := .t.
    elseif cObse      != Obse;     lAlterou := .t.
    elseif cVend      != Repr;     lAlterou := .t.
    endif
    
    if !Saindo(lAlterou)  
      loop
    endif 
    exit 
  enddo  
return NIL

//
// Mostra Dados do Cliente
//
function MostClie ()

  setcolor ( CorCampo )
  if cStat != 'incl'
    nClie := val( Clie )
    cClie := Clie
    
    @ 04,21 say nClie          pict '999999'
  endif  
  
  cRazao    := Razao
  cNoCl     := Nome
  cEnde     := Ende
  cCida     := Cida  
  nCEP      := CEP
  cBair     := Bair  
  cUF       := UF
  cCGC      := CGC
  cInscEstd := InscEstd
  cFone     := Fone
  cRamal    := Ramal   
  cContato  := Contato 
  cFax      := Fax
  cCelu     := Celu
  cEmail    := Email
  cUrl      := Url
  cObse     := Obse
  cVend     := Repr
  nVend     := val( Repr )
  
  @ 06,21 say cRazao
  @ 07,21 say cNoCl
  @ 09,21 say nCEP        pict '99999-999'
  @ 09,41 say cEnde       pict '@S34' 
  @ 10,21 say cBair       pict '@S15'
  @ 10,46 say cCida       pict '@S18'
  @ 10,71 say cUF         pict '@!'
  @ 12,21 say cFone       pict '@s14'        
  @ 12,40 say cFax        pict '@s14'              
  @ 12,60 say cCelu       pict '@s14'              
  @ 13,21 say cContato  
  @ 13,60 say cRamal     
  @ 14,21 say cEmail      pict '@S25'
  @ 14,54 say cUrl        pict '@S21'
  @ 16,21 say cCGC        pict '@R 99.999.999/9999-99' 
  @ 16,54 say cInscEstd
  @ 17,21 say cObse          pict '@S40'
  @ 18,21 say nVend          pict '999999'
  @ 18,28 say ReprARQ->Nome  pict '@S40'
  
  PosiDBF( 02, 76 )
return NIL

//
// Imprime Dados do Cliente
//
function PrinClie ( lAbrir )

  local cArqu2  := CriaTemp( 5 )
  local cArqu3  := right ( cArqu2, 8 )

  local cRData  := date()
  local cRHora  := time()
  
  local GetList := {}
 
  if lAbrir
    if NetUse( "ClieARQ", .t., 30 )
      VerifIND( "ClieARQ" )

      #ifdef DBF_NTX
        set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
      #endif    
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )
  
  //  Define Intervalo
  Janela ( 06, 29, 10, 55, mensagem( 'Janela', 'PrinClie', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,31 say 'Cliente Inicial'
  @ 09,31 say '  Cliente Final'

  select ClieARQ
  set order to 1
  dbgotop ()
  nClieIni := val( Clie )
  dbgobottom ()
  nClieFin := val( Clie )


  @ 08,47 get nClieIni        pict '999999' valid ValidClie( 99, 99, "ClieARQ", "nClieIni" )
  @ 09,47 get nClieFin        pict '999999' valid ValidClie( 99, 99, "ClieARQ", "nClieFin" ) .and. nClieFin >= nClieIni
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

  cClieIni := strzero( nClieIni, 6 )
  cClieFin := strzero( nClieFin, 6 )
  
  select ClieARQ
  set order to 1
  dbseek( cClieIni, .t. )
  do while Clie >= cClieIni .and. Clie <= cClieFin .and. !eof()
    if Tipo == 'J'
      if lInicio
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
    
        lInicio := .f. 
      endif

      if ( nLin + 3 ) >= pLimite
        Rodape(80) 

        cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
        cArqu2 := cArqu2 + "." + strzero( nPag, 3 )
 
        set printer to ( cArqu2 )
        set printer on
      endif

      if nLin == 0
        Cabecalho( 'Clientes - Pessoa Juridica', 80, 3 )
        CabClie()
      endif

      @ nLin,01 say Clie 
      @ nLin,08 say Nome        pict '@S28'
      @ nLin,37 say Fone        pict '@s14'                
      @ nLin,52 say Ende        pict '@S25'
      nLin ++
      @ nLin,01 say CEP         pict '99999-999'
      @ nLin,11 say Bair        pict '@S15'
      @ nLin,27 say Cida        pict '@S15' 
      @ nLin,43 say UF
      @ nLin,46 say CGC         pict '@R 99.999.999/9999-99' 
      @ nLin,65 say InscEstd    pict '@S15' 
      nLin += 2
 
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
    Rodape(80)
  endif  
 
  set printer to
  set printer off
  set device  to screen
   
  if Imprimir( cArqu3, 80 ) 
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Relatorio de Clientes"
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

function CabClie ()
  @ 02,01 say 'Cod Raz„o Social                   Telefone       Endereço'
  @ 03,01 say 'CEP       Bairro          Cidade          UF CGC                Insc. Estd.'
  nLin := 05
return NIL

//
// Imprime Dados do Cliente
//
function PrinFiCl ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )

    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
    #endif  
  endif

  if NetUse( "ReprARQ", .t. )
    VerifIND( "ReprARQ" )

    #ifdef DBF_NTX
      set index to ReprIND1, ReprIND2
    #endif  
  endif

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 07, 02, 17, 76, mensagem( 'Janela', 'PrinFiCl', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 09,04 say '      Cliente Inicial                     Cliente Final'
  @ 10,04 say '     Vendedor Inicial                    Vendedor Final'
  @ 11,04 say 'Data Cadastro Inicial               Data Cadastro Final'
  @ 13,04 say '       Cidade Inicial                      Cidade Final'
  @ 15,04 say '       Cliente Pessoa  Física   Jurídica   Simples   Ambos '
  @ 16,04 say '                Ordem'

  setcolor ( 'n/w+' )
  @ 16,37 say chr(25)
  
  setcolor ( CorCampo + ',' + CorOpcao )
  @ 15,26 say ' Física '
  @ 15,35 say ' Jurídica ' 
  @ 15,46 say ' Simples ' 
  @ 15,56 say ' Ambos '
  @ 16,26 say ' Nome     '

  setcolor ( CorAltKc )
  @ 15,27 say 'F'
  @ 15,36 say 'J'
  @ 15,47 say 'S'
  @ 15,57 say 'A'
  @ 16,27 say 'N'
  
  select ReprARQ
  set order to 1
  nReprIni := 0
  dbgobottom ()
  nReprFin := val( Repr )

  select ClieARQ
  set order  to 1
  dbgotop ()
  nClieIni  := val( Clie )
  dbgobottom ()
  nClieFin  := val( Clie )
  dDataIni  := ctod ('01/01/96')
  dDataFin  := date ()
  
  cCidaIni  := 'A' + space(14)
  cCidaFin  := 'ZZ' + space(13)

  setcolor ( CorJanel + ',' + CorCampo )
  @ 09,26 get nClieIni  pict '999999'     valid ValidClie( 99, 99, "ClieARQ", "nClieIni" )
  @ 09,60 get nClieFin  pict '999999'     valid ValidClie( 99, 99, "ClieARQ", "nClieFin" ) .and. nClieFin >= nClieIni
  @ 10,26 get nReprIni  pict '999999'     valid nReprIni == 0 .or. ValidARQ( 99, 99, "ClieARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprIni", .t., 6, "Consulta de Vendedores", "ReprARQ", 30 )
  @ 10,60 get nReprFin  pict '999999'     valid nReprFin == 0 .or. ValidARQ( 99, 99, "ClieARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprFin", .t., 6, "Consulta de Vendedores", "ReprARQ", 30 ) .and. nReprFin >= nReprIni
  @ 11,26 get dDataIni  pict '99/99/9999'
  @ 11,60 get dDataFin  pict '99/99/9999' valid dDataFin >= dDataIni
  @ 13,26 get cCidaIni               
  @ 13,60 get cCidaFin                  valid cCidaFin >= cCidaIni
  read

  if lastkey() == K_ESC
    select ClieARQ
    close
    select ReprARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
   
  tLinha  := savescreen( 24, 01, 24, 79 )
  aOpcoes := {}
  aOpcao  := {}
  nPessoa := 4

  aadd( aOpcoes, { ' Física ',   2, 'F', 15, 26, "Relatório de Clientes - Pessoa Física" } )
  aadd( aOpcoes, { ' Jurídica ', 2, 'J', 15, 35, "Relatório de Clientes - Pessoa Jurídica" } )
  aadd( aOpcoes, { ' Simples ',  2, 'S', 15, 46, "Relatório de Clientes - Pessoa Simples" } )
  aadd( aOpcoes, { ' Ambos ',    2, 'A', 15, 56, "Relatório de Clientes" } )

  aadd( aOpcao, { ' Codigo   ', 2, 'C', 16, 26, "Relatório em ordem num‚rica de código." } )
  aadd( aOpcao, { ' Nome     ', 2, 'N', 16, 26, "Relatório em ordem alfab‚tica por nome." } )
  aadd( aOpcao, { ' Endereço ', 2, 'E', 16, 26, "Relatório em ordem alfab‚tica por endereço." } )
  aadd( aOpcao, { ' Cidade   ', 3, 'I', 16, 26, "Relatório em ordem alfab‚tica por cidade." } )
  aadd( aOpcao, { ' Bairro   ', 2, 'B', 16, 26, "Relatório em ordem alfab‚tica por bairro." } )
  aadd( aOpcao, { ' Conjuge  ', 3, 'O', 16, 26, "Relatório em ordem alfab‚tica por conjuge." } )

  nPessoa := HCHOICE( aOpcoes, 4, nPessoa )
  nOrdem  := HCHOICE( aOpcao, 6, 2 )
    
  restscreen( 24, 01, 24, 79, tLinha )

  if lastkey() == K_ESC
    select ClieARQ
    close
    select ReprARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  Aguarde ()

  nPag     := 1
  nLin     := 0
  cArqu2   := cArqu2 + "." + strzero( nPag, 3 )
  lInicio  := .t.

  cClieIni := strzero( nClieIni, 6 )
  cClieFin := strzero( nClieFin, 6 )
  nCidaIni := len( alltrim( cCidaIni ) )
  nCidaFin := len( alltrim( cCidaFin ) )

  do case
    case nPessoa == 1;        cTipo := 'F'
    case nPessoa == 2;        cTipo := 'J'
    case nPessoa == 3;        cTipo := 'S'
    case nPessoa == 4;        cTipo := 'T'
  endcase                  
  
  select ClieARQ  
  set order    to nOrdem
  set relation to Repr into ReprARQ
  dbgotop ()
  do while !eof()
    if Clie                  >= cClieIni .and. Clie        <= cClieFin .and.;
      val( Repr )            >= nReprIni .and. val( Repr ) <= nReprFin .and.;
      Data                   >= dDataIni .and. Data        <= dDataFin .and.;
      left( Cida, nCidaIni ) >= alltrim( cCidaIni )                    .and.;
      left( Cida, nCidaFin ) <= alltrim( cCidaFin )
      
      if cTipo != 'T'
        if cTipo != Tipo 
          dbskip ()
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
        do case
          case nPessoa == 1
            Cabecalho( 'Clientes - Pessoa Fisica', 132, 3 )
          case nPessoa == 2
            Cabecalho( 'Clientes - Pessoa Juridica', 132, 3 )
          case nPessoa == 3
            Cabecalho( 'Clientes - Simples', 132, 3 )
          case nPessoa == 4
           Cabecalho( 'Clientes', 132, 3 )
        endcase
        CabFiCl()
      endif
 
      @ nLin,001 say Clie
      @ nLin,008 say Nome          pict '@S28'
      @ nLin,037 say Ende          pict '@S30' 
      @ nLin,068 say Cida          pict '@S15'  
      if Tipo == 'F'
        if !empty( CPF )
          @ nLin,084 say CPF       pict '@E 999,999,999-99' 
        endif  
      else  
        if !empty( CGC )
          @ nLin,084 say CGC       pict '@R 99.999.999/9999-99'
        endif  
      endif   
      @ nLin,103 say InscEstd      pict '@S14'
      @ nLin,118 say Fone          pict '@s14'         
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
        case nPessoa == 1
          replace Titu   with "Relatório de Clientes - Pessoa Física"
        case nPessoa == 2
          replace Titu   with "Relatório de Clientes - Pessoa Jurídica"
        case nPessoa == 3
          replace Titu   with "Relatório de Clientes - Pessoa Simples"
        case nPessoa == 4
          replace Titu   with "Relatório de Clientes em ordem Alfab‚tica"
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

  select ClieARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabFiCl ()
  @ 02,01 say 'Vendedor'
  if nReprFin > nReprIni
    @ 02,10 say 'Todos'
  else
    @ 02,10 say ReprARQ->Nome
  endif  
  
  @ 02,60 say 'Cidade'
  if cCidaFin > cCidaIni
    @ 02,67 say 'Todas'
  else  
    @ 02,67 say cCidaIni
  endif  
  
  @ 03,01 say 'Cod Cliente                        Endereco                       Cidade          CPF/CNPJ           Insc. Estd.    Telefone'
  nLin := 5
return NIL

//
// Imprime Dados do Cliente
//
function PrinAnCl ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )

    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2
    #endif  
  endif

  if NetUse( "FilhARQ", .t. )
    VerifIND( "FilhARQ" )

    #ifdef DBF_NTX
      set index to FilhIND1
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
  Janela ( 07, 12, 12, 72, mensagem( 'Janela', 'PrinAnCl', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 09,14 say 'Cliente Inicial             Cliente Final'
  @ 10,14 say '    Mˆs Inicial                 Mês Final'
  @ 11,14 say ' Imprimir Etiq.                      Tipo'

  setcolor( CorCampo )
  @ 11,30 say ' Sim '
  @ 11,36 say ' Não '
  @ 11,56 say ' Ambos      '

  setcolor ( 'n/w+' )
  @ 11,69 say chr(25)

  setcolor( CorAltKC )
  @ 11,31 say 'S'
  @ 11,37 say 'N'
  @ 11,57 say 'A'

  select ClieARQ
  set order  to 1
  dbgotop ()
  nClieIni := val( Clie )
  go bottom
  nClieFin := val( Clie )

  nMesIni := 1
  nMesFin := 12
  nEtiq   := 2
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ 09,30 get nClieIni         pict '999999'     valid ValidClie( 99, 99, "ClieARQ", "nClieIni" )
  @ 09,56 get nClieFin         pict '999999'     valid ValidClie( 99, 99, "ClieARQ", "nClieFin" ) .and. nClieFin >= nClieIni
  @ 10,30 get nMesIni          pict '99'
  @ 10,56 get nMesFin          pict '99'       valid nMesFin >= nMesIni
  read

  if lastkey() == K_ESC
    select ClieARQ
    close
    select CampARQ
    close
    select EtiqARQ
    close
    select FilhARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  nEtiq := iif( ConfLine( 11, 30, nEtiq ), 1, 2 )

  if lastkey() == K_ESC
    select ClieARQ
    close
    select CampARQ
    close
    select EtiqARQ
    close
    select FilhARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  aOpc := {}

  aadd( aOpc, { ' Cliente    ', 2, 'C', 11, 56, "Clientes Aniversariantes." } )
  aadd( aOpc, { ' Dependente ', 2, 'D', 11, 56, "Dependendes Aniversariantes." } )
  aadd( aOpc, { ' Ambos      ', 2, 'A', 11, 56, "Ambos Aniversariantes." } )

  nAniv := HCHOICE( aOpc, 3, 3 )

  if lastkey() == K_ESC
    select ClieARQ
    close
    select CampARQ
    close
    select EtiqARQ
    close
    select FilhARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  nPag      := 1
  nLin      := 0
  cArqu2    := cArqu2 + "." + strzero( nPag, 3 )
  lInicio   := .t.
  aClientes := {}
  cClieIni  := strzero( nClieIni, 6 )
  cClieFin  := strzero( nClieFin, 6 )

  if nEtiq == 1
    nEtiqClie := EmprARQ->EtiqClie
  
    select EtiqARQ
    set order to 1
    dbseek( nEtiqClie, .f. )

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
      
      select ClieARQ
      close
      select CampARQ
      close
      select EtiqARQ
      close
      select FilhARQ
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
    nTotLin    := 0
  
    cQtLin     := mlcount( cTexto, nLargura + 1 )
 
    for nK := 1 to cQtLin
      cLinha  := memoline( cTexto, nLargura + 1, nK )
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
            aadd( aLayout, { nLin, nCol, Tipo, alltrim( Campo ), Mascara, Tamanho, Arquivo  } ) 
          endif
  
          cPalavra := ''
          nCol     := 0
        endif  
      next
      nLin ++
    next

    if !TestPrint( EmprARQ->Cliente )
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
  endif  

  select ClieARQ
  set order to 2
  dbgotop ()
  if nEtiq == 2
    if nAniv == 1 .or. nAniv == 3
      do while !eof ()
        if Clie           >= cClieIni .and. Clie            <= cClieFin .and.;
          Tipo == 'F'
        
          if month( CjNasc ) >= nMesIni .and. month( CjNasc ) <= nMesFin 
            aadd( aClientes, { Clie, Conjuge, CjNasc } ) 
          endif
          if month( Nasc )   >= nMesIni  .and. month( Nasc )   <= nMesFin
            aadd( aClientes, { Clie, Nome, Nasc } ) 
          endif
        endif  
        dbskip ()
      enddo  
    endif       
                
    if nAniv == 2 .or. nAniv == 3
      select FilhARQ
      set order to 1
      dbgotop()
      do while !eof()
        if Clie >= cClieIni .and. Clie <= cClieFin .and. month( Nasc ) >= nMesIni  .and. month( Nasc ) <= nMesFin
          aadd( aClientes, { Clie, Nome, Nasc } ) 
        endif
        dbskip()
      enddo
    endif  
      
    asort( aClientes,,, { | Clie01, Clie02 | left( dtoc( Clie01[3] ), 5 ) < left( dtoc( Clie02[3] ), 5 ) } )
       
    for nG := 1 to len( aClientes )  
      if lInicio
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
  
        lInicio := .f.
      endif  
    
      if nLin == 0
        Cabecalho ( 'Cliente Aniversariantes', 80, 3 )
        CabAnivCl ()
      endif
 
      @ nLin,002 say aClientes[ nG, 1 ]   pict '9999'
      @ nLin,010 say aClientes[ nG, 2 ]   
      @ nLin,070 say aClientes[ nG, 3 ]   pict '99/99/9999'
      nLin ++
 
      if nLin >= pLimite
        Rodape(80) 

        cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
        cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

        set printer to ( cArqu2 )
        set printer on
      endif  
    next    
    
    if !lInicio
      Rodape(80)
    endif  
  else  
    nLinIni  := aLayout[ 1, 1 ]
    nLinFin  := aLayout[ len( aLayout ), 1 ]
    xLin     := nLin := 0
    nCopia   := 0
    nQtdeCop := 1
   
    if nAniv == 1 .or. nAniv == 3
      do while !eof ()
        if Clie          >= cClieIni .and. Clie <= cClieFin .and.;
          month( Nasc ) >= nMesIni                          .and.;
          month( Nasc ) <= nMesFin                          .and.;
          Tipo == 'F'
  
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

          xLin += nSalto 

          @ xLin,00 say chr(13)
        endif     
        
        select ClieARQ
        dbskip()
      enddo
    endif
  
    if nAniv == 2 .or. nAniv == 3
      select ClieARQ 
      set order to 1
      
      select FilhARQ
      set order to 1
      dbgotop()
      do while !eof ()
        if Clie         >= cClieIni .and. Clie          <= cClieFin .and.;
          month( Nasc ) >= nMesIni  .and. month( Nasc ) <= nMesFin  
          
          for nH := 1 to nColunas
            s       := strzero( nH, 2 )
            aEtiq&s := {}
          next
     
          if nCopia == 0   
            nCopia := nQtdeCop
          endif  

          ClieARQ->(dbseek(FilhARQ->Clie,.f.))
            
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
                    if cCamp == 'Nome'
                      select FilhARQ
                    endif
                    
                    cCampo := left( &cCamp, nTama )
                  case cTipo == 'D' .or. cTipo == 'V'  
                    cCampo := &cCamp
                endcase  
              endif  
           
              aadd( aEtiq&ueta, { nLin, nCol, cCampo } )
            next

            if nCopia == 1  
              select FilhARQ
  
              do while !eof ()
                dbskip()  
                if Clie         >= cClieIni .and. Clie          <= cClieFin .and.;
                  month( Nasc ) >= nMesIni  .and. month( Nasc ) <= nMesFin  
                  exit
                endif
              enddo               
              
              ClieARQ->(dbseek(FilhARQ->Clie,.f.))
        
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

          xLin += nSalto 

          @ xLin,00 say chr(13)

          dbskip(-1)
        endif     

        select FilhARQ
        dbskip()
      enddo

      @ nTotLin,00 say chr(27) + '@'
    endif  
  endif  
  
  set printer to
  set printer off
  set device  to screen
  
  if nEtiq == 2 .and. Imprimir( cArqu3, 80 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Relatório dos clientes Aniversariantes "
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
  close
  select CampARQ
  close
  select EtiqARQ
  close
  select FilhARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabAnivCl ()
  @ 02, 01 say 'Codigo'
  @ 02, 10 say 'Nome do Cliente/Conjuge/Filho'
  @ 02, 70 say 'Nasc.'
  nLin := 4
return NIL

//
// Imprime Etiqueta do Cliente
//
function PrinEtqC ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )

    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2
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
  Janela ( 07, 12, 11, 61, mensagem( 'Janela', 'PrinClie', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 09,14 say 'Cliente Inicial           Cliente Final'
  @ 10,14 say 'Qtde. de Cópias'

  select ClieARQ
  set order  to 1
  dbgotop ()
  nClieIni := val( Clie )
  dbgobottom ()
  nClieFin := val( Clie )
  nQtdeCop := 1
 
  @ 09,30 get nClieIni         pict '999999'     valid ValidClie( 99, 99, "ClieARQ", "nClieIni" )
  @ 09,54 get nClieFin         pict '999999'     valid ValidClie( 99, 99, "ClieARQ", "nClieFin" ) .and. nClieFin >= nClieIni
  @ 10,30 get nQtdeCop         pict '9999'     valid nQtdeCop > 0
  read

  if lastkey () == K_ESC
    select ClieARQ
    close
    select CampARQ
    close
    select EtiqARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  EmprARQ->( dbseek( cEmpresa, .f. ) )
  
  cClieIni  := strzero( nClieIni, 6 )
  cClieFin  := strzero( nClieFin, 6 )
  nEtiqClie := EmprARQ->EtiqClie
  
  select EtiqARQ
  set order to 1
  dbseek( nEtiqClie, .f. )

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
    select ClieARQ
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
  
  cQtLin     := mlcount( cTexto, nLargura + 1 )
  nTotLin    := 0

  for nK := 1 to cQtLin
    cLinha  := memoline( cTexto, nLargura + 1, nK )
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
          aadd( aLayout, { nLin, nCol, Tipo, alltrim( Campo ), Mascara, Tamanho, Arquivo  } ) 
        endif

        cPalavra := ''
        nCol     := 0
      endif  
    next
    nLin ++
  next

  if !TestPrint( EmprARQ->Cliente )
    select ClieARQ
    close
    select CampARQ
    close
    select EtiqARQ
    close
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

  nLinIni := aLayout[ 1, 1 ]
  nLinFin := aLayout[ len( aLayout ), 1 ]
  xLin    := 0
  nCopia  := 0
  
  select ClieARQ
  set order  to 1
  set filter to Clie >= cClieIni .and. Clie <= cClieFin
  dbgotop ()
  do while !eof ()
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
        
    xLin += nSalto
    
    @ xLin,00 say chr(13)
  enddo
  
  @ nTotLin,00 say chr(27) + '@'

  set printer to
  set printer off
  set device  to screen
  
  select ClieARQ
  close
  select CampARQ
  close
  select EtiqARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

//
//  Consulta de Visitas
//
function ConsVisi ()

  if NetUse( "VisiARQ", .t. )
    VerifIND( "VisiARQ" )
  
    pAbriVisi := .t.
  
    #ifdef DBF_NTX
      set index to VisiIND1, VisiIND2
    #endif  
  else
    pAbriVisi := .f.  
  endif
  
  cCorAtual   := setcolor()
  dData       := dtos( ctod('01/01/90') )
  iClie       := ClieARQ->Clie
  iNome       := ClieARQ->Nome
  uTotalVisi  := 0
  dVctoIni    := ctod( '01/01/1900' )
  dVctoFin    := ctod( '31/12/2015' )
  tTelaVisi   := savescreen( 00, 00, 23, 79 )
  
  Janela( 09, 24, 13, 50, mensagem( 'Janela', 'Periodo', .f. ), .f. )
  Mensagem( 'LEVE', 'Periodo' )

  setcolor( CorJanel )
  @ 11,26 say 'Data Inicial'
  @ 12,26 say '  Data Final'
  
  @ 11,39 get dVctoIni      pict '99/99/9999'
  @ 12,39 get dVctoFin      pict '99/99/9999' valid dVctoFin >= dVctoIni
  read
   
  if lastkey() == K_ESC
    if pAbriVisi
      select VisiARQ
      close
    endif  

    select ClieARQ
    set order to 2
    dbseek( iNome, .f. )
  
    restscreen( 00, 00, 23, 79, tTelaVisi )
    return NIL
  endif  
  
  select VisiARQ
  set order to 2
  dbseek( iClie, .t. )
  do while Clie == iClie
    if Data >= dVctoIni .and. Data <= dVctoFin 
      uTotalVisi ++
    endif  

    dbskip ()
  enddo      

  Janela ( 05, 11, 18, 66, mensagem( 'Janela', 'ConsVisi', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )

  select VisiARQ
  set order to 2
  bFirst := {|| dbseek( iClie, .t. ) }
  bLast  := {|| dbseek( iClie, .t. ), dbskip(-1) }
  bFor   := {|| Data >= dVctoIni .and. Data <= dVctoFin .and. Clie == iClie } 
  bWhile := {|| Data >= dVctoIni .and. Data <= dVctoFin .and. Clie == iClie } 
  
  oVisita           := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oVisita:nTop      := 07
  oVisita:nLeft     := 12
  oVisita:nBottom   := 16
  oVisita:nRight    := 65
  oVisita:headsep   := chr(194)+chr(196)
  oVisita:colsep    := chr(179)
  oVisita:footsep   := chr(193)+chr(196)
  oVisita:colorSpec := CorJanel

  oVisita:addColumn( TBColumnNew(" ",          {|| Marc } ) )
  oVisita:addColumn( TBColumnNew("Data",       {|| Data } ) )
  oVisita:addColumn( TBColumnNew("Observação", {|| left( Obs1, 43 ) } ) )
  oVisita:addColumn( TBColumnNew("Observação", {|| left( Obs2, 43 ) } ) )
  oVisita:addColumn( TBColumnNew("Observação", {|| left( Obs3, 43 ) } ) )
              
  oVisita:refreshAll ()
  oVisita:freeze := 2
  
  lAdiciona      := .f.
  lMais          := .t.
  lExitRequested := .f.
  nLinBarra      := 1
  uSubTotal      := 0
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 8, 16, 66, nTotal )
  
  setcolor( CorJanel + ',' + CorCampo )
  @ 08,11 say chr(195)
  @ 16,11 say chr(195)
  @ 17,47 say 'Total Visitas'
  
  setcolor( CorCampo )
  @ 17,61 say uTotalVisi                pict '9999'

  do while !lExitRequested
    Mensagem( 'Clie', 'ConsVisi' )
    
    oVisita:forcestable() 

    PosiDBF( 05, 66 )

    iif( BarraSeta, BarraSeta( nLinBarra, 8, 16, 66, nTotal ), NIL )
    
    if oVisita:stable
      if oVisita:hitTop .or. oVisita:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oVisita:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oVisita:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oVisita:down()
      case cTecla == K_UP;         oVisita:up()
      case cTecla == K_PGDN;       oVisita:pageDown()
      case cTecla == K_PGUP;       oVisita:pageUp()
      case cTecla == K_LEFT;       oVisita:left()
      case cTecla == K_RIGHT;      oVisita:right()
      case cTecla == K_CTRL_PGUP;  oVisita:goTop()
      case cTecla == K_CTRL_PGDN;  oVisita:gobottom()
      case cTecla == K_ESC
        select VisiARQ
        set order to 2
        dbseek( iClie, .t. )
        do while Clie == iClie .and. !eof ()
          if Data >= dVctoIni .and. Data <= dVctoFin
            if RegLock()
              replace Marc      with space(01)
              dbunlock ()
            endif  
          endif  
          dbskip ()
        enddo
      
        oVisita:refreshAll()

        lExitRequested := .t.
      case cTecla == K_ALT_A   
        tVisiTela := savescreen( 00, 00, 22, 79 )

        Visi(.f.)

        restscreen( 00, 00, 22, 79, tVisiTela )
        
        uTotalVisi := 0

        select VisiARQ
        set order to 2
        dbseek( iClie, .t. )
        do while Clie == iClie .and. !eof ()
          if Data >= dVctoIni .and. Data <= dVctoFin 
            uTotalVisi ++
          endif
          dbskip ()
        enddo      

        setcolor( CorCampo )
        @ 17,61 say uTotalVisi                pict '9999'

        oVisita:gotop()
        oVisita:refreshAll()

        lExitRequested := .f.
      case cTecla == K_SPACE
        if RegLock()
          if VisiARQ->Marc == ' '
            replace Marc      with "X"
          else
            replace Marc      with ' '
          endif    
          dbunlock ()
        endif  

        oVisita:refreshAll()
    endcase
  enddo  
  
  if pAbriVisi
    select VisiARQ
    close
  endif  
  
  select ClieARQ
  set order to 2
  dbseek( iNome, .f. ) 
  
  setcolor( cCorAtual )
  restscreen( 00, 00, 23, 79, tTelaVisi )
return NIL