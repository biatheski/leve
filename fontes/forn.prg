//  Leve, Cadastro de Fornecedores
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

function Forn( xAlte )
  local GetList := {}
  
if SemAcesso( 'Forn' )
  return NIL
endif  

if NetUse( "FornARQ", .t. )
  VerifIND( "FornARQ" )
  
  fOpenForn := .t.
  
  #ifdef DBF_NTX
    set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
  #endif
else
  fOpenForn := .f.  
endif

//  Variaveis de Entrada para Fornecedor
nForn     := nCEP      := 0
cUF       := space(2)
cForn     := space(4)
cFone     := cFax      := cCGC      := space(14)
cFoneR    := cFaxR     := cCelu     := space(14)
cRamal    := space(04)
cBairro   := space(20)
cCC       := cBanco    := cAgencia  := space(15)
cRazao    := space(40)
cCida     := cContato  := cRepres   := space(30)
cEmail    := cUrl      := space(50)
cNoFo     := space(45)
cEnde     := space(45)
cInscEstd := space(20)

//  Tela Fornecedor
Janela ( 02, 03, 21, 76, mensagem( 'Janela', 'Forn', .f. ), .t. )

setcolor ( CorJanel )
@ 04,05 say '      Codigo'
@ 06,05 say 'Razão Social'
@ 07,05 say '        Nome'

@ 09,05 say '    Endereço'
@ 09,56 say 'CEP'
@ 10,05 say '      Cidade'
@ 10,57 say 'UF'
@ 11,05 say '      Bairro'
@ 11,36 say 'Fone'
@ 11,56 say 'Fax'

@ 13,05 say '     Contato'
@ 13,54 say 'Ramal'
@ 14,04 say 'Representante'
@ 14,55 say 'Fone'
@ 15,05 say '         Fax'
@ 15,52 say 'Celular'
@ 16,05 say '       Email'
@ 16,45 say 'Url'

@ 17,05 say '         C/C'
@ 17,35 say 'Banco'
@ 17,56 say 'Ag.' 
@ 18,05 say '  Insc. CNPJ'
@ 18,47 say 'Insc. Estad.'

MostOpcao( 20, 05, 17, 52, 65 ) 
tForn := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Fornecedor
select FornARQ
set order to 1
if fOpenForn
  dbgobottom ()
endif  
do while  .t.
  select FornARQ
  set order to 1

  Mensagem ( 'Forn', 'Janela' )

  restscreen( 00, 00, 23, 79, tForn )
  cStat := space(04)

  MostForn()
  
  if Demo ()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostForn'
  cAjuda   := 'Forn'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  if lastkey() == K_ALT_A
    nForn := val( Forn )
  else   
    if xAlte
      @ 04,18 get nForn                  pict '999999'
      read
    else 
      nForn := 0
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
  
  cForn := strzero( nForn, 6 )
  
  setcolor( CorCampo )
  @ 04,18 say cForn

  //  Verificar existencia do Fornecedor para Incluir ou Alterar
  select FornARQ
  set order to 1
  dbseek( cForn, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif
  
  Mensagem ('Forn', cStat )

  MostForn()
  EntrForn()

  Confirmar ( 20, 05, 17, 52, 65, 3 )

  if cStat == 'prin'
    PrinForn ( 'A', .f. )
  endif
    
  if cStat == 'excl'
    ExclRegi ()
  endif
  
  if cStat == 'incl'
    if cForn == '000000'
      cForn := '000001'
    endif    

    set order to 1  
    do while .t.
      dbseek( cForn, .f. )
      if found()
        nForn := val( cForn ) + 1               
        cForn := strzero( nForn, 6 )
      else 
        exit   
      endif
    enddo

    if AdiReg()
      if RegLock()
        replace Forn       with cForn
        dbunlock ()
      endif
    endif  
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Razao      with cRazao
      replace Nome       with cNoFo
      replace Ende       with cEnde
      replace Cida       with cCida
      replace CEP        with nCEP
      replace UF         with cUF
      replace Bairro     with cBairro
      replace CGC        with cCGC
      replace InscEstd   with cInscEstd
      replace Fone       with cFone
      replace FoneR      with cFoneR
      replace Ramal      with cRamal
      replace Contato    with cContato
      replace Fax        with cFax
      replace FaxR       with cFaxR
      replace Celu       with cCelu
      replace Repres     with cRepres
      replace CC         with cCC
      replace Banco      with cBanco
      replace Agencia    with cAgencia
      replace Email      with cEmail
      replace Url        with cUrl
      dbunlock ()
    endif

    if !xAlte 
      xAlte := .t.

      keyboard(chr(27))
    endif  
  endif
enddo

if fOpenForn
  select FornARQ
  close
endif  

return NIL

//
// Copia a razao para o nome
//
function CopiaForn()
  if empty( cNoFo )
    cNoFo := cRazao 
  endif 
return(.t.)

//
// Entra Dados do Fornecedor
//
function EntrForn()
  local GetList := {}
  
  do while .t.
    lAlterou := .f.

    setcolor ( CorJanel + ',' + CorCampo )
    @ 06,18 get cRazao      valid CopiaForn ()
    @ 07,18 get cNoFo
    @ 09,18 get cEnde       pict '@S34'
    @ 09,60 get nCEP        pict '99999-999'
    @ 10,18 get cCida
    @ 10,60 get cUF         pict '@!' valid ValidUf ( 10, 60, "FornARQ" )
    @ 11,18 get cBairro     pict '@S14'
    @ 11,41 get cFone       
    @ 11,60 get cFax        
    @ 13,18 get cContato
    @ 13,60 get cRamal
    @ 14,18 get cRepres
    @ 14,60 get cFoneR      
    @ 15,18 get cFaxR       
    @ 15,60 get cCelu   
    @ 16,18 get cEmail      pict '@S25'
    @ 16,49 get cUrl        pict '@S25'    
    @ 17,18 get cCC
    @ 17,41 get cBanco      pict '@S14'
    @ 17,60 get cAgencia
    @ 18,18 get cCGC        pict '@R 99.999.999/9999-99' valid ValidCGC( cCGC )
    @ 18,60 get cInscEstd   pict '@S15'
    read

    if cRazao        != Razao;    lAlterou := .t.
    elseif cNoFo     != Nome;     lAlterou := .t.
    elseif cEnde     != Ende;     lAlterou := .t.
    elseif nCEP      != CEP;      lAlterou := .t.
    elseif cCida     != Cida;     lAlterou := .t.
    elseif cUF       != UF;       lAlterou := .t.
    elseif cBairro   != Bairro;   lAlterou := .t.
    elseif cFone     != Fone;     lAlterou := .t.
    elseif cFax      != Fax;      lAlterou := .t.
    elseif cContato  != Contato;  lAlterou := .t.
    elseif cRamal    != Ramal;    lAlterou := .t.
    elseif cRepres   != Repres;   lAlterou := .t.
    elseif cFoneR    != FoneR;    lAlterou := .t.
    elseif cFaxR     != FaxR;     lAlterou := .t.
    elseif cCelu     != Celu;     lAlterou := .t.
    elseif cEmail    != Email;    lAlterou := .t.
    elseif cUrl      != Url;      lAlterou := .t.
    elseif cCC       != CC;       lAlterou := .t.
    elseif cBanco    != Banco;    lAlterou := .t.
    elseif cAgencia  != Agencia;  lAlterou := .t.
    elseif cCGC      != CGC;      lAlterou := .t.
    elseif cInscEstd != InscEstd; lAlterou := .t.
    endif
    
    if !Saindo(lAlterou)
      loop
    endif
    exit  
  enddo
return NIL

//
// Mostra Dados do Fornecedor
//
function MostForn()
  setcolor( CorCampo )
  if cStat != 'incl'
    nForn := val( Forn )
    cForn := Forn
    
    @ 04,18 say cForn
  endif  
  
  cRazao    := Razao
  cNoFo     := Nome 
  cEnde     := Ende
  cCida     := Cida
  nCEP      := CEP
  cBairro   := Bairro
  cUF       := UF
  cCGC      := CGC
  cInscEstd := InscEstd
  cFone     := Fone
  cFoneR    := FoneR
  cRamal    := Ramal   
  cContato  := Contato  
  cCelu     := Celu
  cFax      := Fax
  cFaxR     := FaxR
  cRepres   := Repres
  cCC       := CC
  cBanco    := Banco
  cAgencia  := Agencia
  cEmail    := Email
  cUrl      := Url

  @ 06,18 say cRazao
  @ 07,18 say cNoFo
  @ 09,18 say cEnde       pict '@S34'
  @ 09,60 say nCEP        pict '99999-999'
  @ 10,18 say cCida
  @ 10,60 say cUF         pict '@!'
  @ 11,18 say cBairro     pict '@S14'
  @ 11,41 say cFone       
  @ 11,60 say cFax        
  @ 13,18 say cContato
  @ 13,60 say cRamal
  @ 14,18 say cRepres
  @ 14,60 say cFoneR      
  @ 15,18 say cFaxR       
  @ 15,60 say cCelu       
  @ 16,18 say cEmail      pict '@S25'
  @ 16,49 say cUrl        pict '@S25'    
  @ 17,18 say cCC
  @ 17,41 say cBanco      pict '@S14'
  @ 17,60 say cAgencia
  @ 18,18 say cCGC        pict '@R 99.999.999/9999-99'
  @ 18,60 say cInscEstd   pict '@S15'
  
  PosiDBF( 02, 76 )
return NIL

//
// Imprime Dados do Fornecedor
//
function PrinForn ( pTipo, lAbrir )
  local cArqu2  := CriaTemp( 5 )
  local cArqu3  := right ( cArqu2, 8 )
  local cRData  := date()
  local cRHora  := time()
  local GetList := {}

  if lAbrir
    if NetUse( "FornARQ", .t. )
      VerifIND( "FornARQ" )

      #ifdef DBF_NTX
        set index to FornIND1, FornIND2
      #endif
    endif
  endif  


  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 06, 28, 10, 56, mensagem( 'Janela', 'PrinForn', .f. ), .f. )

  setcolor ( Corjanel + ',' + CorCampo )
  @ 08,31 say 'Fornecedor Inicial'
  @ 09,31 say '  Fornecedor Final'

  select FornARQ
  set order to 1
  dbgotop ()
  nFornIni := val( Forn )
  dbgobottom ()
  nFornFin := val( Forn )

  @ 08,50 get nFornIni    pict '999999'        valid ValidForn( 99, 99, "FornARQ", "nFornIni" )       
  @ 09,50 get nFornFin    pict '999999'        valid ValidForn( 99, 99, "FornARQ", "nFornFin" ) .and. nFornFin >= nFornIni
  read

  if lastkey() == K_ESC
    select FornARQ
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

  cFornIni := strzero( nFornIni, 6 )
  cFornFin := strzero( nFornFin, 6 )
  lInicio  := .t.

  // Posiciona Primeiro Fornecedor
  select FornARQ
  if pTipo == 'C'
    set order to 1
  else  
    set order to 2
  endif  
  set filter to Forn >= cFornIni .and. Forn <= cFornFin
  dbgotop ()
  do while !eof()
    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
      
      lInicio := .f.
    endif  
  
    if nLin == 0 
      if pTipo == 'C'
        Cabecalho ( 'Fornecedor - Codigo', 132, 1 )
      else  
        Cabecalho ( 'Fornecedor - Alfabetico', 132, 1 )
      endif  
      CabForn ()
    endif

    @ nLin,001 say Forn              pict '999999'
    @ nLin,008 say Nome              pict '@S28'
    @ nLin,037 say Ende              pict '@S30' 
    if CEP != 0
      @ nLin,068 say CEP             pict '99999-999'
    endif
    @ nLin,078 say Bairro            pict '@S15' 
    @ nLin,094 say Cida              pict '@S10' 
    @ nLin,105 say UF
    @ nLin,110 say Fone              
    nLin ++

    if nLin >= pLimite
      Rodape(132)

      cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
      cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

      set printer to ( cArqu2 )
      set printer on
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
      if pTipo == 'C'
        replace Titu       with "Relatório de Fornecedores - Codigo"
      else  
        replace Titu       with "Relatório de Fornecedores - Alfabético"
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

  select FornARQ
  if lAbrir
    close
  else
    set filter to
    set order  to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabForn ()
  @ 02, 01 say 'Cod Razao Social                   Endereco                       CEP       Bairro          Cidade     UF           Fone'
  
  nLin := 04
return NIL