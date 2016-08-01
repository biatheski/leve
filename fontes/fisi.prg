//  Leve, Cadastro de Cliente pessoa Física
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

function Fisi( fAlte )
  local GetList := {}
  
if SemAcesso( 'Fisi' )
  return NIL
endif  

if NetUse( "ClieARQ", .t. )
  VerifIND( "ClieARQ" )
  
  fOpenFisi := .t.
  
  #ifdef DBF_NTX
    set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
  #endif
else  
  fOpenFisi := .f.
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

  fOpenCEPe := .t.

  #ifdef DBF_NTX
    set index to CEPeIND1, CEPeIND2, CEPeIND3, CEPeIND4
  #endif
else
  fOpenCEPe := .f.  
endif

if NetUse( "FilhARQ", .t. )
  VerifIND( "FilhARQ" )

  eOpenFilh := .t.

  #ifdef DBF_NTX
    set index to FilhIND1
  #endif
else
  eOpenFilh := .f.  
endif

//  Variaveis de Entrada para Cliente
cUF        := space(2)
cFone      := cFoneEmp    := cCjFoneE    := cFax    := cCelu := space(14)
cClie      := cRamaEmp    := cCjRamaEmp  := cVend   := space(4)
cEstaCivil := cCasa       := cFicha      := space(10)
cProx      := cSobreNome  := space(15)
cNatural   := cCjCargo    := cBair       := cCida   := cCarg := cCjRG := cRG := space(20)
cCjEmprego := cConjuge    := cEmprego    := cNome   := space(40)
cEnde      := cUrl        := cEmail      := space(45)
cFiliacao  := cFontRefe   := cObsSPC     := cAval   := cObse := space(60)

nClie      := nDependent  := nCjCPF      := nCPF    := nCEP  := 0
nOrdenado  := nCjOrdenado := nCjOutros   := nOutros := nVend := 0

dDesd      := dNasc       := dAdmi := dCjNasc := dCjAdmi := ctod('  /  /  ')
dData      := date()
aOpcao     := {}
cClieTMP   := cClieARQ    := cClieIND1 := space(08)

aadd( aOpcao, { ' Imprimir ',     2, 'I', 20, 03, "Relatório do arquivo" } )
aadd( aOpcao, { ' Excluir ' ,     6, 'U', 20, 15, "Excluir registro" } )
aadd( aOpcao, { ' Complementos ', 7, 'E', 20, 26, "Complemento do cadastro de Cliente Física" } )
aadd( aOpcao, { ' Depen. ',       2, 'D', 20, 42, "Incluir/Alterar Dependentes do Cliente" } )
aadd( aOpcao, { ' Confirmar ',    2, 'C', 20, 52, "Confirmar inclusão ou alteração" } )
aadd( aOpcao, { ' Cancelar ',     3, 'A', 20, 65, "Cancelar alteraç”es" } )

//  Tela Cliente
Janela ( 01, 01, 21, 76, mensagem( 'Janela', 'Fisi', .f. ), .t. )

setcolor ( CorJanel )
@ 03,05 say 'Codigo'
@ 03,55 say '    Ficha'
@ 04,03 say '    Nome'
@ 04,55 say 'SobreNome'
@ 05,03 say '     CEP'
@ 05,24 say 'Endereço'
@ 06,05 say 'Bairro'
@ 06,34 say 'Cidade'
@ 06,62 say 'UF'
@ 07,04 say 'Próximo'
@ 07,36 say 'Fone'
@ 07,57 say 'Celular'
@ 08,09 say 'RG'
@ 08,37 say 'CPF'
@ 08,60 say 'Casa'
@ 10,03 say 'Filiação'
@ 11,04 say 'Natural'
@ 11,35 say 'Nasc.'
@ 11,52 say 'Estado Civil'
@ 12,03 say 'Avalista'
@ 14,02 say 'Fonte Ref'
@ 15,03 say 'Obs. SPC'
@ 17,03 say '   Email'
@ 17,37 say 'URL'
@ 18,03 say 'Vendedor'
setcolor( CorCampo )
@ 20,03 say ' Imprimir '
@ 20,15 say ' Excluir '
@ 20,26 say ' Complementos '
@ 20,42 say ' Depen. '
@ 20,52 say ' Confirmar '
@ 20,65 say ' Cancelar '

setcolor( CorAltKC )
@ 20,04 say 'I'
@ 20,20 say 'u'
@ 20,32 say 'e'
@ 20,43 say 'D'
@ 20,53 say 'C'
@ 20,67 say 'a'

tFisi := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Cliente
select ClieARQ
set order    to 1
if fOpenFisi
  dbgobottom ()
endif

do while .t.
  restscreen( 00, 00, 23, 79, tFisi )
  cStat := space(04)

  Mensagem ('Fisi', 'Janela' )

  select ClieARQ
  set order    to 1
  set relation to Repr into ReprARQ 

  MostFisi()
  
  if Demo()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostFisi'
  cAjuda   := 'Fisi'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
   
  if lastkey() == K_ALT_A
    nClie := val( Clie )
  else    
    if fAlte
      @ 03,12 get nClie             pict '999999'
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
  
  cClie := strzero ( nClie, 6 )
  
  setcolor( CorCampo ) 
  @ 03,12 say cClie             pict '999999'

  if cClie == '999999'
    Alerta( mensagem( 'Alerta', 'Clie9999', .f. ) )
    loop
  endif  

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
    if Tipo == 'S'
      Alerta ( mensagem( 'Alerta', 'Simples', .f. ) )
      loop
    endif
  endif
  
  Mensagem( 'Fisi', cStat )

  MostFisi()
  EntrFisi()
  EntrCompl()

  fStatAux := cStat
  
  if lastkey() == K_ESC
    cStat := space(04)
  endif
  
  do while lastkey() != K_ESC
    nOpConf := HCHOICE( aOpcao, 6, 5, .t. )
    
    do case
      case nOpConf == 0 .or. nOpConf == 6
        cStat := 'loop'
      case nOpConf == 1
        cStat := 'prin'
      case nOpConf == 2
        cStat := 'excl'
      case nOpConf == 3
        cStat := 'gene'
      case nOpConf == 4
        cStat := 'depe'
            endcase
    
    do case
      case cStat == 'gene'
        EntrCompl()

        cStat := fStatAux
      case cStat == 'depe'  
        EntrFilh()
       
        cStat := fStatAux
      otherwise
        exit
    endcase
  enddo

  if cStat == 'prin'
    Ficha ()
    
    cStat := fStatAux
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
    
    if ExclRegi()
      select FilhARQ
      set order to 1
      dbseek( cClie, .t. )
      do while Clie == cClie .and. !eof()
        if RegLock()
          dbdelete ()
          dbunlock ()
        endif
        dbskip ()
      enddo    
      
      select ClieARQ
    endif  
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
        replace Clie         with cClie
        replace Data         with date()
        replace Tipo         with 'F'
        replace Dias40       with .t.
        replace Dias60       with .t.
        dbunlock ()
      endif 
    endif  
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Ficha        with cFicha
      replace Nome         with cNome
      replace SobreNome    with cSobreNome
      replace Ende         with cEnde
      replace CEP          with nCEP
      replace Bair         with cBair
      replace Cida         with cCida
      replace UF           with cUF
      replace Fone         with cFone
      replace Celu         with cCelu
      replace Prox         with cProx
      replace Desd         with dDesd
      replace RG           with cRG
      replace CPF          with nCPF
      replace Casa         with cCasa
      replace Filiacao     with cFiliacao
      replace Natural      with cNatural
      replace Nasc         with dNasc
      replace EstaCivil    with cEstaCivil
      replace Aval         with cAval
      replace FontRefe     with cFontRefe
      replace ObsSPC       with cObsSPC
      replace Obse         with cObse
      replace Url          with cUrl
      replace Email        with cEmail
      replace Repr         with cVend

      replace Emprego      with cEmprego
      replace Admi         with dAdmi
      replace Carg         with cCarg
      replace FoneEmp      with cFoneEmp
      replace RamaEmp      with cRamaEmp
      replace Ordenado     with nOrdenado
      replace Outros       with nOutros
      replace Dependent    with nDependent
      replace Conjuge      with cConjuge
      replace CjNasc       with dCjNasc
      replace CjRG         with cCjRG
      replace CjCPF        with nCjCPF
      replace CjEmprego    with cCjEmprego
      replace CjAdmi       with dCjAdmi
      replace CjCargo      with cCjCargo
      replace CjFoneE      with cCjFoneE
      replace CjRamaEmp    with cCjRamaEmp
      replace CjOrdenado   with nCjOrdenado
      replace CjOutros     with nCjOutros
      dbunlock ()
    endif

    nRegiClie := recno()

    set deleted off
    
    if select( cClieTMP ) > 0 .and. lastkey() != K_ESC
      select( cClieTMP )
      set order to 1
      dbgotop()
      do while !eof()
        if empty( Nome )
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
      
          select FilhARQ
          set order to 1
          dbseek( cClie + &cClieTMP->Sequ, .f. )
      
          if found() 
            if RegLock()
              dbdelete ()
              dbunlock ()
            endif  
          endif     
        
          if AdiReg()
            if RegLock()
              replace Clie       with cClie     
              replace Sequ       with &cClieTMP->Sequ
              replace Nome       with &cClieTMP->Nome
              replace Nasc       with &cClieTMP->Nasc
              dbunlock ()
            endif
          endif   
        else 
          select FilhARQ
          go nRegi
      
          if RegLock()
            replace Nome         with &cClieTMP->Nome
            replace Nasc         with &cClieTMP->Nasc
            dbunlock ()
          endif  
        endif    

        select FilhARQ
 
        if lLixo
          if RegLock()
            dbdelete ()
            dbunlock ()
          endif
        endif
  
        select( cClieTMP )
        dbskip ()
      enddo  
    endif  
   
    set deleted on
    
    if !fAlte 
      fAlte := .t.
      keyboard(chr(27))
    endif  
    
    select ClieARQ
    go nRegiClie
    
  endif
enddo

if fOpenCEPe
  select CEPeARQ
  close
endif  

if eOpenRepr
  select ReprARQ
  close
endif  

if fOpenFisi
  select ClieARQ
  close
endif  

if !empty( cClieTMP )
  select( cClieTMP )
  close
  ferase( cClieARQ )
  ferase( cClieIND1 )
endif  

return NIL

//
// Retira o sobrenome do nome
//
function CalcNome( xNome )
  if empty( cSobreNome )
    nPega := 0
    xNome := alltrim( xNome )
    nLen  := len( xNome ) 
  
    for nH := nLen to 1 step -1
      cLetra := substr( xNome, nH, 1 )
      
      if cLetra == ' '
        exit
      endif
      
      nPega  ++
    next         
    
    cSobreNome := right( xNome, nPega )
  endif
return(.t.)

//
// Entra Dados do Cliente
//
function EntrFisi ()
  local GetList := {}
  
  if lastkey() == K_ESC .or. lastkey() == K_PGDN
    return NIL
  endif  
  
  do while .t.
    lAlterou := .f.
  
    setcolor ( CorJanel + ',' + CorCampo )
    @ 03,65 get cFicha
    @ 04,12 get cNome       pict '@K'        valid CalcNome( cNome ) 
    @ 04,65 get cSobreNome  pict '@S10'      
    @ 05,12 get nCEP        pict '99999-999' valid ValidCEP( 05, 12, "ClieARQ", 33, 12, 41, 65 )
    @ 05,33 get cEnde       pict '@S42'
    @ 06,12 get cBair       pict '@S20'
    @ 06,41 get cCida       pict '@S20'
    @ 06,65 get cUF         pict '@!'        valid ValidUF( 06, 65, "ClieARQ" )
    @ 07,12 get cProx       pict '@S20'
    @ 07,41 get cFone       pict '@S14'
    @ 07,65 get cCelu       pict '@S10'
    @ 08,12 get cRG      
    @ 08,41 get nCPF        pict '@E 999,999,999-99'
    @ 08,65 get cCasa 
    @ 10,12 get cFiliacao 
    @ 11,12 get cNatural  
    @ 11,41 get dNasc         pict '99/99/9999'
    @ 11,65 get cEstaCivil
    @ 12,12 get cAval 
    @ 14,12 get cFontRefe
    @ 15,12 get cObsSPC 
    @ 16,12 get cObse 
    @ 17,12 get cEmail        pict '@S23'
    @ 17,41 get cUrl          pict '@S31'
    @ 18,12 get nVend         pict '999999'  valid ValidARQ( 18, 12, "ClieARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nVend", .t., 6, "Consulta de Vendedores", "ReprARQ", 40 )
    read

    cVend := strzero( nVend, 6 )
  
    if cFicha          != Ficha;       lAlterou := .t.
    elseif cNome       != Nome;        lAlterou := .t.
    elseif cSobreNome  != SobreNome;   lAlterou := .t.
    elseif nCEP        != CEP;         lAlterou := .t.
    elseif cEnde       != Ende;        lAlterou := .t.
    elseif cBair       != Bair;        lAlterou := .t.
    elseif cCida       != Cida;        lAlterou := .t.
    elseif cUF         != UF;          lAlterou := .t.
    elseif cFone       != Fone;        lAlterou := .t.
    elseif cCelu       != Celu;        lAlterou := .t.
    elseif cProx       != Prox;        lAlterou := .t.
//    elseif dDesd       != Desd;        lAlterou := .t.
    elseif cRG         != RG;          lAlterou := .t.
    elseif nCPF        != CPF;         lAlterou := .t.
    elseif cCasa       != Casa;        lAlterou := .t.
    elseif cFiliacao   != Filiacao;    lAlterou := .t.
    elseif cNatural    != Natural;     lAlterou := .t.
    elseif dNasc       != Nasc;        lAlterou := .t.
    elseif cEstaCivil  != EstaCivil;   lAlterou := .t.
    elseif cAval       != Aval;        lAlterou := .t.
    elseif cFontRefe   != FontRefe;    lAlterou := .t.
    elseif cObsSPC     != ObsSPC;      lAlterou := .t.
    elseif cObse       != Obse;        lAlterou := .t.
    elseif cEmail      != Email;       lAlterou := .t.
    elseif cVend       != Repr;        lAlterou := .t.
    elseif cUrl        != Url;         lAlterou := .t.
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
function MostFisi ()
  setcolor ( CorCampo )
  if cStat != 'incl'
    nClie := val( Clie ) 
    cClie := Clie
  endif
    
  cNome       := Nome
  cFicha      := Ficha
  cSobreNome  := SobreNome    
  cEnde       := Ende
  nCEP        := CEP
  cBair       := Bair
  cCida       := Cida
  cUF         := UF
  cFone       := Fone
  cCelu       := Celu
  cProx       := Prox
  dDesd       := Desd
  cRG         := RG
  nCPF        := CPF
  cCasa       := Casa
  cFiliacao   := Filiacao
  cNatural    := Natural
  dNasc       := Nasc
  cEstaCivil  := EstaCivil
  cAval       := Aval
  dData       := Data
  cFontRefe   := FontRefe
  cObsSPC     := ObsSPC
  cObse       := Obse
  cUrl        := Url
  cEmail      := Email
  cVend       := Repr
  nVend       := val( Repr )

  cEmprego    := Emprego
  dAdmi       := Admi
  cCarg       := Carg
  cFoneEmp    := FoneEmp
  cRamaEmp    := RamaEmp
  nOrdenado   := Ordenado
  nOutros     := Outros
  nDependent  := Dependent

  cConjuge    := Conjuge
  dCjNasc     := CjNasc
  cCjRG       := CjRG
  nCjCPF      := CjCPF
  cCjEmprego  := CjEmprego
  dCjAdmi     := CjAdmi
  cCjCargo    := CjCargo
  cCjFoneE    := CjFoneE
  cCjRamaEmp  := CjRamaEmp
  nCjOrdenado := CjOrdenado
  nCjOutros   := CjOutros

  @ 03,65 say cFicha
  @ 04,12 say cNome
  @ 04,65 say cSobreNome  pict '@S10'
  @ 05,12 say nCEP        pict '99999-999'
  @ 05,33 say cEnde       pict '@S42' 
  @ 06,12 say cBair       pict '@S20'  
  @ 06,41 say cCida       pict '@S20'  
  @ 06,65 say cUF         pict '@!'
  @ 07,12 say cProx       pict '@S20' 
  @ 07,41 say cFone       pict '@S14'        
  @ 07,65 say cCelu       pict '@S10'        
  @ 08,12 say cRG
  @ 08,41 say nCPF        pict '@E 999,999,999-99'
  @ 08,65 say cCasa
  @ 10,12 say cFiliacao
  @ 11,12 say cNatural
  @ 11,41 say dNasc       pict '99/99/9999'
  @ 11,65 say cEstaCivil
  @ 12,12 say cAval
  @ 14,12 say cFontRefe
  @ 15,12 say cObsSPC
  @ 16,12 say cObse       
  @ 17,12 say cEmail        pict '@S23'
  @ 17,41 say cURL          pict '@S31'
  @ 18,12 say nVend         pict '999999'
  @ 18,19 say ReprARQ->Nome pict '@S40'

  PosiDBF( 01, 76 )
return NIL

//
// Complemento do Cadastro de Cliente Pessoa Fisica
//
function EntrCompl ()
  local GetList := {}

  if lastkey() == K_ESC .or. lastkey() == K_PGDN .or. nextkey() == K_ESC
    return NIL
  endif  
  
  tCompl := savescreen( 00, 00, 23, 79 )

  Janela ( 06, 02, 17, 75, mensagem( 'Janela', 'EntrCompl', .f. ), .f. )

  setcolor ( CorJanel )
  @ 08,05 say 'Emprego'
  @ 08,55 say 'Admissão'
  @ 09,07 say 'Cargo'
  @ 09,36 say 'Fone'
  @ 09,58 say 'Ramal'
  @ 10,04 say 'Ordenado'
  @ 10,34 say 'Outros'
  @ 10,57 say 'N.Dep.'
  @ 12,05 say 'Conjuge'
  @ 12,58 say 'Nasc.'
  @ 13,10 say 'RG'
  @ 13,37 say 'CPF'
  @ 14,05 say 'Emprego'
  @ 14,55 say 'Admissão'
  @ 15,07 say 'Cargo'
  @ 15,36 say 'Fone'
  @ 15,58 say 'Ramal'
  @ 16,04 say 'Ordenado'
  @ 16,34 say 'Outros'

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,13 get cEmprego
  @ 08,64 get dAdmi          pict '99/99/9999'
  @ 09,13 get cCarg
  @ 09,41 get cFoneEmp      
  @ 09,64 get cRamaEmp
  @ 10,13 get nOrdenado      pict '@E 999,999,999.99'
  @ 10,41 get nOutros        pict '@E 999,999,999.99'
  @ 10,64 get nDependent
  @ 12,13 get cConjuge
  @ 12,64 get dCjNasc        pict '99/99/9999'
  @ 13,13 get cCjRG
  @ 13,41 get nCjCPF         pict '@E 999,999,999-99'
  @ 14,13 get cCjEmprego
  @ 14,64 get dCjAdmi        pict '99/99/9999'
  @ 15,13 get cCjCargo
  @ 15,41 get cCjFoneE      
  @ 15,64 get cCjRamaEmp
  @ 16,13 get nCjOrdenado    pict '@E 999,999,999.99'
  @ 16,41 get nCjOutros      pict '@E 999,999,999.99'
  read
  
  restscreen( 00, 00, 23, 79, tCompl )
return NIL

//
// Mostra a idade dos Dependentes
//
function VerIdade( cNasc )
return(iif( empty( cNasc ), '  ', strzero( int( ( date() - cNasc ) / 365 ), 2 )))

//
// Nome dos Dependentes
//
function EntrFilh()
  local GetList := {}
    
  if lastkey () == K_ESC .or. lastkey() == K_PGDN 
    return(.t.)
  endif  

  aOpcoes   := {}
  aArqui    := {}
  cClieARQ  := CriaTemp(0)
  cClieIND1 := CriaTemp(1)
  cChave    := "Sequ"

  aadd( aArqui, { "Sequ",       "C", 002, 0 } )
  aadd( aArqui, { "Nome",       "C", 030, 0 } )
  aadd( aArqui, { "Nasc",       "D", 008, 0 } )
  aadd( aArqui, { "Regi",       "N", 008, 0 } )
  aadd( aArqui, { "Novo",       "L", 001, 0 } )
  aadd( aArqui, { "Lixo",       "L", 001, 0 } )

  dbcreate( cClieARQ , aArqui )
   
  if NetUse( cClieARQ, .f. )
    cClieTMP := alias ()
    
    index on &cChave to &cClieIND1

    #ifdef DBF_NTX
      set index to &cClieIND1
    #endif
  endif
  
  select FilhARQ
  set order to 1
  dbseek( cClie + '01', .t. )
  do while Clie == cClie
    nRegi := recno ()
    
    select( cClieTMP )
    if AdiReg()
      if RegLock()
        replace Sequ       with FilhARQ->Sequ
        replace Nome       with FilhARQ->Nome
        replace Nasc       with FilhARQ->Nasc
        replace Regi       with nRegi
        replace Novo       with .f.
        replace Lixo       with .f.
        dbunlock ()
      endif
    endif
    
    select FilhARQ
    dbskip ()
  enddo
  
  tEntr    := savescreen( 00, 00, 23, 79 )  

  Janela( 08, 15, 17, 63, mensagem( 'Janela', 'EntrFilh', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )
    
  select( cClieTMP )
  set order to 1

  bFirst := {|| dbseek( '01', .t. ) }
  bLast  := {|| dbseek( '99', .t. ), dbskip(-1) }
  bFor   := {|| .t. }
  bWhile := {|| .t. }
 
  oFilhos         := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oFilhos:nTop    := 10
  oFilhos:nLeft   := 16
  oFilhos:nBottom := 17
  oFilhos:nRight  := 62
  oFilhos:headsep := chr(194)+chr(196)
  oFilhos:colsep  := chr(179)
  oFilhos:footsep := chr(193)+chr(196)

  oFilhos:addColumn( TBColumnNew("Nome",  {|| Nome } ) )
  oFilhos:addColumn( TBColumnNew("Nasc.", {|| Nasc } ) )
  oFilhos:addColumn( TBColumnNew("Idade", {|| VerIdade( Nasc ) } ) )
            
  lExitRequested := .f.
  lAdiciona      := .f.
  lAlterou       := .f.
  cSequ          := space(02)
  nSequ          := 0
  
  setcolor( CorJanel )
  @ 11,15 say chr(195)
  @ 11,63 say chr(180)

  oFilhos:goBottom()

  do while !lExitRequested
    Mensagem( 'LEVE', 'Browse' )
 
    oFilhos:forcestable()
    
    PosiDBF( 08, 63 )
    
    if fStatAux == 'incl' .and. !lAlterou  
      cTecla := K_INS
    else
      cTecla := Teclar(0)
    endif    

    if oFilhos:hitTop .or. oFilhos:hitBottom
      tone( 125, 0 )
    endif

    do case
      case cTecla == K_DOWN;        oFilhos:down()
      case cTecla == K_UP;          oFilhos:up()
      case cTecla == K_PGUP;        oFilhos:pageUp()
      case cTecla == K_CTRL_PGUP;   oFilhos:goTop()
      case cTecla == K_PGDN;        oFilhos:pageDown()
      case cTecla == K_CTRL_PGDN;   oFilhos:goBottom()
      case cTecla == K_RIGHT;       oFilhos:right()
      case cTecla == K_LEFT;        oFilhos:left()
      case cTecla == K_HOME;        oFilhos:home()
      case cTecla == K_END;         oFilhos:end()
      case cTecla == K_CTRL_LEFT;   oFilhos:panLeft()
      case cTecla == K_CTRL_RIGHT;  oFilhos:panRight()
      case cTecla == K_CTRL_HOME;   oFilhos:panHome()
      case cTecla == K_CTRL_END;    oFilhos:panEnd()
      case cTecla == K_ESC
        if Saindo (lAlterou)
          lExitRequested := .t.
        else
          lExitRequested := .f.
        endif
      case cTecla == 46;            lExitRequested := .t.
      case cTecla == K_ENTER
        if !empty( Sequ )
          lAdiciona := .f.
          lAlterou  := .t.
  
          EntrItFilh( lAdiciona, oFilhos )
        endif  
      case cTecla == K_INS
        nRegi := recno ()

        dbgotop ()
        do while !eof ()
          cSequ := Sequ
          nSequ := val( Sequ )
          
          dbskip ()
        enddo   
          
        go nRegi

        do while lastkey () != K_ESC 
          lAdiciona := .t.
          lAlterou  := .t.
          
          EntrItFilh( lAdiciona, oFilhos )
        enddo           
      case cTecla == K_DEL
        if RegLock()
          replace Lixo     with .t.
         
          dbdelete ()
          dbunlock ()
        endif  

        oFilhos:refreshCurrent()  
        oFilhos:goBottom() 
    endcase
  enddo
  
  select ClieARQ

  restscreen( 00, 00, 23, 79, tEntr )
return(.t.)

//
// 
// 
function VerNome( iNome )
 if alltrim( iNome ) == '.'
   keyboard( chr(27)+chr(46) )
 endif
return(.t.)   
 
//
// Entra intens da nota
//
function EntrItFilh( lAdiciona, oFilhos )
  local GetList := {}
  
  if lAdiciona 
    cSequ := strzero( nSequ + 1, 2 )
    
    if AdiReg()
      if RegLock()
        replace Sequ            with cSequ
        replace Novo            with .t.
        dbunlock ()
      endif
    endif    
    
    dbgobottom ()

    oFilhos:goBottom() 
    oFilhos:refreshAll()  

    oFilhos:forcestable()

    Mensagem( 'Fisi', 'FilhIncl' )
  else
    Mensagem( 'Fisi', 'FilhAlte' )
  endif  

  nSequ  := val( Sequ )
  cSequ  := Sequ
  oNasc  := Nasc
  oNome  := Nome
  nLin   := 11 + oFilhos:rowPos
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ nLin, 16 get oNome              valid VerNome( oNome )
  @ nLin, 47 get oNasc              pict '99/99/9999'
  read
  
  cTecla := lastkey()

  if cTecla == K_ESC
    if lAdiciona
      if RegLock()
        dbdelete ()
        dbunlock ()
      endif  
    endif  
    
    oFilhos:refreshCurrent()  
    return NIL
  endif  
  
  if cTecla == K_UP .or. cTecla == K_DOWN .or. cTecla == K_PGUP .or. cTecla == K_PGDN
    keyboard( chr( cTecla ) )
  endif
  
  if RegLock()
    replace Sequ            with cSequ
    replace Nome            with oNome
    replace Nasc            with oNasc
    dbunlock ()
  endif
  
  lAlterou := .t.
  
  oFilhos:refreshCurrent()  
return(.t.)

//
// Imprime Dados do Cliente
//
function PrinFisi ( lAbrir )

  local cArqu2  := CriaTemp( 5 )
  local cArqu3  := right ( cArqu2, 8 )

  local cRData  := date()
  local cRHora  := time()
  
  local GetList := {}

  if lAbrir
    if NetUse( "ClieARQ", .t. )
      VerifIND( "ClieARQ" )

      #ifdef DBF_NTX
        set index to ClieIND1, ClieIND2
      #endif
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 06, 02, 11, 76, mensagem( 'Janela', 'PrinVisi', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,04 say '      Cliente Inicial                     Cliente Final'
  @ 09,04 say '         Nome Inicial                        Nome Final'
  @ 10,04 say 'Data Cadastro Inicial               Data Cadastro Final'

  select ClieARQ
  set order to 1
  dbgotop ()
  nClieIni := val( Clie )
  dbgobottom ()
  nClieFin := val( Clie )

  cNomeIni := 'A'  + space(14)
  cNomeFin := 'ZZ' + space(13)
  
  dDataIni := ctod ('01/01/90')
  dDataFin := date ()
  
  @ 08,26 get nClieIni          pict '999999'     valid ValidClie( 99, 99, "ClieARQ", "nClieIni" )
  @ 08,60 get nClieFin          pict '999999'     valid ValidClie( 99, 99, "ClieARQ", "nClieFin" ) .and. nClieFin >= nClieIni
  @ 09,26 get cNomeIni
  @ 09,60 get cNomeFin                          valid cNomeFin >= cNomeIni
  @ 10,26 get dDataIni          pict '99/99/9999'
  @ 10,60 get dDataFin          pict '99/99/9999' valid dDataFin >= dDataIni
  read

  if lastkey () == K_ESC
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

  cClieIni := strzero( nClieIni, 6 )
  cClieFin := strzero( nClieFin, 6 )
  nNomeIni := len( alltrim( cNomeIni ) )
  nNomeFin := len( alltrim( cNomeFin ) )
  lInicio  := .t.

  select ClieARQ
  set order to 1
  dbseek( cClieIni, .t. )
  do while Clie >= cClieIni .and. Clie <= cClieFin .and. !eof()
    if left( Nome, nNomeIni ) >= alltrim( cNomeIni ) .and. left( Nome, nNomeFin ) <= alltrim( cNomeFin ) .and.;
      Data  >= dDataIni .and. Data <= dDataFin .and. Tipo  == 'F'

      if lInicio
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
        
        lInicio := .f.
      endif 

      if nLin == 0
        Cabecalho( 'Clientes - Pessoa Fisica', 132, 3 )
        CabFisi()
      endif
    
      @ nLin,001 say Clie
      @ nLin,008 say Nome          pict '@S28'
      @ nLin,037 say Conjuge       pict '@S30'
      @ nLin,068 say Ende          pict '@S30'
      @ nLin,099 say RG            pict '@S15'
      @ nLin,115 say CPF           pict '@E 999,999,999-99'
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
      replace Titu       with "Relatório de Clientes - Pessoa Física"
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
  if lAbrir
    close
  else
    set order to 1 
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabFisi ()
  @ 02,01 say 'Codigo Cliente                      Conjuge                        Endereço                       RG              CPF'   
  nLin := 4
return NIL

//
// Imprime Cartas para Cliente
//
function PrinCart ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "ReceARQ", .t. )
    VerifIND( "ReceARQ" )

    #ifdef DBF_NTX
      set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
    #endif
  endif

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )

    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2
    #endif
  endif

  tPrt := savescreen( 00, 00, 23, 79 )
  
  Janela( 09, 09, 14, 67, mensagem( 'Janela', 'PrinCart', .f. ), .f. )
  Mensagem( 'Fisi', 'PrinCart' )
  
  setcolor( CorJanel + ',' + CorCampo )
  @ 11,11 say 'Cliente Inicial                Cliente Final'
  @ 13,11 say 'Cartas Emitidas'
  
  setcolor( CorCampo )
  @ 13,27 say ' Sim '
  @ 13,33 say ' Não '
  
  setcolor( CorAltKC )
  @ 13,28 say "S"
  @ 13,34 say "N"

  select ClieARQ
  set order to 1
  dbgotop ()
  nClieIni := val( Clie )
  dbgobottom ()
  nClieFin := val( Clie )
    
  setcolor( CorJanel + ',' + CorCampo )
  @ 11,27 get nClieIni       pict '999999'  valid ValidClie( 99, 99, "ClieARQ", "nClieIni" )
  @ 11,56 get nClieFin       pict '999999'  valid ValidClie( 99, 99, "ClieARQ", "nClieFin" ) .and. nClieFin >= nClieIni
  read

  if lastkey() == K_ESC
    select ClieARQ
    close
    select ReceARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif  

  lFirst := ConfLine( 13, 27, 2 )
 
  if lastkey() == K_ESC
    select ClieARQ
    close
    select ReceARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif  

  Aguarde ()
  
  nPag      := 1
  nLin      := 1
  cArqu2    := cArqu2 + "." + strzero( nPag, 3 )
  aClie     := {}
  cClieIni  := strzero( nClieIni, 6 )
  cClieFin  := strzero( nClieFin, 6 )
  lPrimeira := .t.
  lSegunda  := .f.

  select ReceARQ
  set order    to 5
  set relation to Clie into ClieARQ
  dbseek( cClieIni, .t. )
  do while Clie >= cClieIni .and. Clie <= cClieFin .and. !eof ()
    rClie  := Clie
    nSaldo := 0
    nPres  := 0
    dVcto  := Vcto 
    
    do while Clie == rClie 
      if empty( Pgto ) .and. Valor > 0
        if ( date() - Vcto ) >= 45
          nSaldo += Valor 
          nPres  ++
        endif  
      endif     
      
      dbskip ()
    enddo   

    if nSaldo <= 0
      loop
    endif  
    
    dbskip(-1)
    
    if lFirst       
      select ClieARQ
      
      if RegLock()
        replace Dias40       with .f.
        replace Dias60       with .f.
        dbunlock ()
      endif 
      
      select ReceARQ
      lPrimeira := .t.  
      lSegunda  := .f.  
    else
      if ClieARQ->Dias40 .and. ClieARQ->Dias60
        lPrimeira := .f.  
        lSegunda  := .f.  
      endif
      
      if ClieARQ->Dias40 .and. !ClieARQ->Dias60
        lPrimeira := .f.
        lSegunda  := .t.
      endif  
        
      if ClieARQ->Dias60 .and. !ClieARQ->Dias40
        lPrimeira := .t.
        lSegunda  := .f.
      endif  
    endif  
  
    if lPrimeira
      set printer to ( cArqu2 )
      set device  to printer
      set printer on

      setprc( 0, 0 )

      @ nLin,01 say ClieARQ->Nome
      nLin ++
      @ nLin,01 say alltrim( ClieARQ->Ende ) + ' - ' + alltrim( ClieARQ->Bair )
      nLin ++
      @ nLin,01 say transform( ClieARQ->CEP, '99999-999' ) + ' - ' + alltrim( ClieARQ->Cida ) + '/' + ClieARQ->UF

      nLin := 12
      @ nLin,01 say replicate( chr(196), 79 )
      nLin ++
      @ nLin,01 say EmprARQ->Razao
      nLin ++
      @ nLin,01 say EmprARQ->Ende
      nLin ++
      @ nLin,01 say transform( EmprARQ->CEP, '99999-999' ) + ' - ' + alltrim( EmprARQ->Cida ) + '/' + EmprARQ->UF
      nLin ++
      @ nLin,01 say EmprARQ->CGC                pict '@R 99.999.999/9999-99'
      @ nLin,21 say EmprARQ->InscEstd
      @ nLin,61 say 'Fone'
      @ nLin,66 say EmprARQ->Fone               
      nLin ++
      @ nLin,01 say replicate( chr(196), 79 )
      nLin += 2

      cData := alltrim( EmprARQ->Cida ) + '(' + EmprARQ->UF + '),' + strzero( day( date() ), 2 ) + ' de ' + alltrim( aMesExt[ month( date() ) ] ) + ' de' + str( year( date () ) )

      @ nLin,( 80 - len( cData ) ) say cData

      nLin += 4
      @ nLin,09 say 'V.Sa.'
      @ nLin,15 say ClieARQ->Nome

      nLin += 5
      @ nLin,13 say 'Nossos registros est„o acusando que V.Sa. esta em debito conosco'
      nLin ++
      @ nLin,05 say 'desde o dia'
      @ nLin,17 say dVcto           pict '99/99/9999'
      @ nLin,27 say ', no valor de: '
      @ nLin,42 say nSaldo          pict '@E 999,999.99'
      nLin ++
      
      Extenso( nSaldo, 71, 66 )

      @ nLin,05 say '(' + cValorExt1
      nLin ++
      @ nLin,05 say cValorExt2 + ').'

      nLin += 2
      @ nLin,13 say 'Temos  otimas  referencias  suas  junto ao SPC, porisso julgamos'
      nLin ++
      @ nLin,05 say 'tratar-se de mero esquecimento. Aguardamos uma posicao sua a respeito.'
      nLin += 2
      @ nLin,13 say 'Sem mais para o momento, subscrevemo-nos.'
      nLin += 3
      @ nLin,47 say 'Atenciosamente...'

      nLin := 58
      @ nLin,13 say 'OBS: Na hipotese de V.Sa. ja ter efetuado o pagamento  antes  do'
      nLin ++
      @ nLin,05 say 'do recebimento deste lembrete, queira considera-lo sem efeito.'

      nPag   ++
      nLin   := 1
      cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
      cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

      select ClieARQ
      if RegLock()
        replace Dias40            with .t.
        dbunlock ()
      endif
    endif

    if lSegunda
      set printer to ( cArqu2 )
      set device  to printer
      set printer on

      setprc( 0, 0 )

      @ nLin,01 say ClieARQ->Nome
      nLin ++
      @ nLin,01 say alltrim( ClieARQ->Ende ) + ' - ' + alltrim( ClieARQ->Bair )
      nLin ++
      @ nLin,01 say transform( ClieARQ->CEP, '99999-999' ) + ' - ' + alltrim( ClieARQ->Cida ) + '/' + ClieARQ->UF

      nLin := 12
      @ nLin,01 say replicate( chr(196), 79 )
      nLin ++
      @ nLin,01 say EmprARQ->Razao
      nLin ++
      @ nLin,01 say EmprARQ->Ende
      nLin ++
      @ nLin,01 say transform( EmprARQ->CEP, '99999-999' ) + ' - ' + alltrim( EmprARQ->Cida ) + '/' + EmprARQ->UF
      nLin ++
      @ nLin,01 say EmprARQ->CGC                pict '@R 99.999.999/9999-99'
      @ nLin,21 say EmprARQ->InscEstd
      @ nLin,61 say 'Fone'
      @ nLin,66 say EmprARQ->Fone               
      nLin ++
      @ nLin,01 say replicate( chr(196), 79 )
      nLin += 2

      cData := alltrim( EmprARQ->Cida ) + '(' + EmprARQ->UF + '),' + strzero( day( date() ), 2 ) + ' de ' + alltrim( aMesExt[ month( date() ) ] ) + ' de' + str( year( date () ) )

      @ nLin,( 80 - len( cData ) ) say cData

      nLin += 4
      @ nLin,09 say 'V.Sa.'
      @ nLin,15 say ClieARQ->Nome
      nLin += 3
      @ nLin,13 say 'Solicitamos por  duas  vezes, que  V.Sa.  comparecesse  em  nosso'
      nLin ++

      Extenso( nSaldo, 40, 66 )

      if nPres == 1
        @ nLin,06 say 'estabelecimento  para liquidar ' + strzero( nPres, 2 ) + ' prestação,   vencida  desde '
      else
        @ nLin,06 say 'estabelecimento para liquidar ' + strzero( nPres, 2 ) + ' prestaçoes,  vencidas  desde '
      endif
      @ nLin,68 say dVcto                 pict '99/99/9999'
      nLin ++
      @ nLin,06 say 'no valor total de: '
      @ nLin,25 say nSaldo                pict '@E 999,999.99'
      @ nLin,36 say '( ' + cValorExt1
      nLin ++
      @ nLin,06 say cValorExt2 + '), mas'
      nLin ++
      @ nLin,06 say 'infelizmente nao obtivemos resposta.'
      nLin += 2
      @ nLin,13 say 'Em vista disso,  lhe  concederemos ate o dia ' + transform( date() + 15, '99/99/9999' ) + ', para que '
      nLin ++
      @ nLin,06 say 'venhas  liquidar  seu  debito. Apos esta data  automaticamente  seu nome'
      nLin ++
      @ nLin,06 say 'sera denunciado ao SPC e seu credito cortado em todo o comercio.'
      nLin ++
      @ nLin,13 say 'Alem de que, seu debito sera entregue a um advogado para  que  se'
      nLin ++
      @ nLin,06 say 'proceda a cobrança judicial, lhe acarretando ainda mais aborrecimentos e'
      nLin ++
      @ nLin,06 say 'despesas.'
      nLin += 2
      @ nLin,13 say 'Esperamos que V.Sa. compreenda nossa posiçao, subscrevemo-nos.'
      nLin += 4
      @ nLin,42 say 'Atenciosamente...'

      nLin := 58
      @ nLin,13 say 'OBS: Na hipotese de V.Sa. ja ter efetuado o pagamento  antes  do'
      nLin ++
      @ nLin,05 say 'do recebimento deste lembrete, queira considera-lo sem efeito.'

      nPag   ++
      nLin   := 1
      cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
      cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

      select ClieARQ
      if RegLock()
        replace Dias60            with .t.
        dbunlock ()
      endif
    endif

    select ReceARQ
    dbskip ()
  enddo
  
  set printer to
  set printer off
  set device  to screen
   
  if Imprimir( cArqu3, 132 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      if lFirst
        replace Titu     with "Emissão de Cartas para Clientes - Primeira Carta"
      else
        replace Titu     with "Emissão de Cartas para Clientes - Segunda Carta"
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

  select ClieARQ
  close
  select ReceARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

//
// Imprimir Ficha de Cadastro do Cliente
//
function Ficha()

  Janela( 11, 22, 14, 49, mensagem( 'Janela', 'Imprimir', .f. ), .f. )
  Mensagem( 'LEVE', 'Print' )
  setcolor( CorJanel )
    
  aOpc := {}
  nPrn := 0

  aadd( aOpc, { ' Impressora ', 2, 'I', 13, 25, "Imprimir Pedido para impressora." } )
  aadd( aOpc, { ' Arquivo ',    2, 'A', 13, 38, "Gerar arquivo texto da impressão do pedido." } )
    
  nTipoNota := HCHOICE( aOpc, 2, 1 )
    
  if nTipoNota == 2
      Janela( 05, 16, 10, 54, mensagem( 'Janela', 'Salvar', .f. ), .f. )
      Mensagem( 'LEVE', 'Salvar' ) 

      cArqu2  := CriaTemp( 5 )
      xArqu3  := right ( cArqu2, 8 )

      cTXT    := 'X'
      cHTM    := ' '
      cXML    := ' '
      cPDF    := ' '
  
      cArqTxt := cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() + alltrim( xArqu3 ) + ".txt" + space(40)
        
      keyboard( chr( K_END ) )

      setcolor ( CorJanel + ',' + CorCampo )
      @ 07,18 say '[ ] TXT  [ ] HTML  [ ] XML  [ ] PDF'

      @ 07,19 get cTXT              pict '@!'  valid TipoTxt()
      @ 07,28 get cHTM              pict '@!'  valid TipoTxt()
      @ 07,38 get cXML              pict '@!'  valid TipoTxt()
      @ 07,47 get cPDF              pict '@!'  valid TipoTxt()
      @ 09,18 get cArqTxt           pict '@S35'
      read
    
      if lastkey() == K_ESC
        return NIL
      endif  
  
      set printer to ( cArqTxt )
      set device  to printer
      set printer on
  else    
    if EmprARQ->Impr == "X"
      if !TestPrint( EmprARQ->Pedido )
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
  
      nTipoNota := 2
    endif  
  endif    

  select ClieARQ
  
  tPrt := savescreen( 00, 00, 23, 79 )
  
  setprc( 0, 0 )
  
  nLin  := 0
  cData := alltrim( EmprARQ->Cida ) + '(' + EmprARQ->UF + '), ' + strzero( day( date() ), 2 ) +;
           ' de ' + alltrim( aMesExt[ month( date() ) ] ) + ' de' + str( year( date() ) )
 
  if EmprARQ->Impr == "X"
    @ nLin,00 say chr(27) + "@"
    @ nLin,00 say chr(18)
    @ nLin,00 say chr(27) + chr(67) + chr(33)
  endif  
  
  @ nLin,01 say '+-----------------------------------------------------------------------------+'
  nLin ++
  @ nLin,01 say '|' 
  @ nLin,03 say EmprARQ->Razao
  @ nLin,59 say 'Fone ' + left( EmprARQ->Fone, 14 ) + ' |'
  nLin ++
  @ nLin,01 say '|' 
  @ nLin,03 say EmprARQ->Ende
  @ nLin,60 say 'Fax ' + left( EmprARQ->Fax, 14 ) + ' |'
  nLin ++
  @ nLin,01 say '|'
  @ nLin,03 say transform( EmprARQ->CEP, '99999-999' ) + ' - ' + alltrim( EmprARQ->Bairro ) +;
                ' - ' + alltrim( EmprARQ->Cida ) + ' - ' + EmprARQ->UF
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '|' 
  @ nLin,03 say EmprARQ->CGC                    pict '@R 99.999.999/9999-99'
  @ nLin,25 say EmprARQ->InscEstd 
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '+-----------------------------------------------------------------------------+'
  nLin ++
  @ nLin,01 say '|    Cliente '
  @ nLin,14 say Nome
  @ nLin,59 say 'Codigo ' + Clie + '       |'
  nLin ++
  @ nLin,01 say '|   Endereço '
  @ nLin,14 say left( Ende, 30 )
  @ nLin,62 say 'CEP ' + transform( CEP, '99999-999' ) + '    |'
  nLin ++
  @ nLin,01 say '|     Bairro' 
  @ nLin,14 say Bair                        pict '@S20'
  @ nLin,36 say 'Cidade ' + left( Cida,  18 )
  @ nLin,63 say 'UF ' + UF + '           |'
  nLin ++
  @ nLin,01 say '|    Próximo '
  @ nLin,14 say Prox
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '|       Fone '
  @ nLin,14 say Fone         
  @ nLin,39 say 'CPF ' + transform( CPF, '@E 999,999,999-99' )
  @ nLin,63 say 'RG ' + left( RG, 12 ) + ' |'
  nLin ++
  @ nLin,01 say '|    Emprego '
  @ nLin,14 say left( Emprego, 20 )
  @ nLin,38 say 'Fone ' + left( Fone, 14 )
  @ nLin,60 say 'Cargo ' + left( Carg, 12 ) + ' |'
  nLin ++
  @ nLin,01 say '|                                                                             |'
  nLin ++
  @ nLin,01 say '|   Filiação '
  @ nLin,14 say Filiacao
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '|    Natural '
  @ nLin,14 say Natural
  @ nLin,35 say 'Nasc. ' + dtoc( Nasc ) + '  Estado Civil ' + EstaCivil + '   |'
  nLin ++
  @ nLin,01 say '|                                                                             |'
  nLin ++
  @ nLin,01 say '|    Conjuge '
  @ nLin,14 say Conjuge
  @ nLin,60 say 'Nasc. ' + dtoc( CJNasc ) + '   |'
  nLin ++
  @ nLin,01 say '|        CPF '
  @ nLin,14 say CJCPF                 pict '@E 999,999,999-99'
  @ nLin,40 say 'RG ' + CJRG
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '|    Emprego ' + CJEmprego
  @ nLin,60 say 'Cargo ' + left( CJCargo, 12 ) + ' |'
  nLin ++
  @ nLin,01 say '|                                                                             |'
  nLin ++
  @ nLin,01 say '|   Avalista ' + Aval
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '| Referencia ' + FontRefe
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '|        SPC ' + ObsSPC 
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '| Observação ' + Obse 
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '|                                                                             |'
  nLin ++
  @ nLin,01 say '|                                             _____________________________   |'
  nLin ++
  @ nLin,01 say '| ' + cData
  @ nLin,47 say Nome                 pict '@S30'
  @ nLin,79 say '|'
  nLin ++  
  @ nLin,01 say '+-----------------------------------------------------------------------------+'
  nLin += 6
  if EmprARQ->Impr == "X"
    @ nLin,00 say chr(27) + "@"
  endif  

  set printer to
  set printer off
  set device  to screen
  
  if !empty( GetDefaultPrinter() )
    PrnTest(aPrn[nPrn], memoread( cArqTxt ), .f. )
  endif
return NIL

//
// Imprime Ficha de Cobraça
//
function FichCobr ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

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

  if NetUse( "ReceARQ", .t. )
    VerifIND( "ReceARQ" )

    #ifdef DBF_NTX
      set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
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


  tPrt := savescreen( 00, 00, 23, 79 )
  
  Janela( 09, 09, 16, 67, mensagem( 'Janela', 'FichCobr', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )
  @ 11,11 say ' Cliente Inicial               Cliente Final'
  @ 12,11 say ' Emissão Inicial               Emissão Final'
  @ 13,11 say '   Vcto. Inicial                 Vcto. Final'
  @ 14,11 say 'Portador Inicial              Portador Final'
  @ 15,11 say 'Cobrador Inicial              Cobrador Final'

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
  
  select ClieARQ
  set order to 1
  dbgotop ()
  nClieIni := val( Clie )
  dbgobottom ()
  nClieFin := val( Clie )
  dEmisIni := ctod( '01/01/90' )
  dEmisFin := date() 
  dVctoIni := ctod( '01/01/90' )
  dVctoFin := date() 
    
  setcolor( CorJanel + ',' + CorCampo )
  @ 11,28 get nClieIni       pict '999999'      valid ValidClie( 99, 99, "ClieARQ", "nClieIni" ) 
  @ 11,56 get nClieFin       pict '999999'      valid ValidClie( 99, 99, "ClieARQ", "nClieFin" ) .and. nClieFin >= nClieIni
  @ 12,28 get dEmisIni       pict '99/99/9999'
  @ 12,56 get dEmisFin       pict '99/99/9999'  valid dEmisFin >= dEmisIni
  @ 13,28 get dVctoIni       pict '99/99/9999'
  @ 13,56 get dVctoFin       pict '99/99/9999'  valid dVctoFin >= dVctoIni
  @ 14,28 get nPortIni       pict '999999'      valid nPortIni == 0 .or. ValidARQ( 99, 99, "ReceARQ", "Código" , "Port", "Descrição", "Nome", "Port", "nPortIni", .t., 6, "Consulta de Portadores", "PortARQ", 40 )
  @ 14,56 get nPortFin       pict '999999'      valid nPortFin == 0 .or. ValidARQ( 99, 99, "ReceARQ", "Código" , "Port", "Descrição", "Nome", "Port", "nPortFin", .t., 6, "Consulta de Portadores", "PortARQ", 40 ) .and. nPortFin >= nPortIni
  @ 15,28 get nCobrIni       pict '999999'      valid nCobrIni == 0 .or. ValidARQ( 99, 99, "ReceARQ", "Código" , "Cobr", "Descrição", "Nome", "Cobr", "nCobrIni", .t., 6, "Consulta de Cobradores", "CobrARQ", 40 )
  @ 15,56 get nCobrFin       pict '999999'      valid nCobrFin == 0 .or. ValidARQ( 99, 99, "ReceARQ", "Código" , "Cobr", "Descrição", "Nome", "Cobr", "nCobrFin", .t., 6, "Consulta de Cobradores", "CobrARQ", 40 ) .and. nCobrFin >= nCobrIni
  read

  if lastkey () == K_ESC
    select ClieARQ
    close
    select ReceARQ
    close
    select ReprARQ
    close
    select PortARQ
    close
    select CobrARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  Aguarde ()

  nPag     := 1
  nLin     := 0
  cArqu2   := cArqu2 + "." + strzero( nPag, 3 )
  
  cClieIni := strzero( nClieIni, 6 )
  cClieFin := strzero( nClieFin, 6 )
  cPortIni := strzero( nPortIni, 6 )
  cPortFin := strzero( nPortFin, 6 )
  cCobrIni := strzero( nCobrIni, 6 )
  cCobrFin := strzero( nCobrFin, 6 )
  
  if !TestPrint(1)
    select ClieARQ
    close
    select ReceARQ
    close
    select ReprARQ
    close
    select PortARQ
    close
    select CobrARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif  

  setprc( 0, 0 )
  
  @ prow(), 00 say chr(27) + "@"
  @ prow(), 00 say chr(27) + chr(67) + chr(33)
  @ prow(), 00 say chr(18)

  nLin := prow()
  
  select ReceARQ
  set order to 4
  dbseek( cClieIni, .t. )
  set relation to Clie into ClieARQ, Repr into ReprARQ
  do while Clie >= cClieIni .and. Clie <= cClieFin .and. !eof()
    cClie := Clie
    nLin  := 0
    
    if Clie        >= cClieIni .and. Clie        <= cClieFin .and.;
       Emis        >= dEmisIni .and. Emis        <= dEmisFin .and.;
       Vcto        >= dVctoIni .and. Vcto        <= dVctoFin .and.;
       val( Port ) >= nPortIni .and. val( Port ) <= nPortFin .and.;
       val( Cobr ) >= nCobrIni .and. val( Cobr ) <= nCobrFin .and.;
       empty( Pgto )
    
      @ nLin,01 say '+-----------------------------------------------------------------------------+'
      nLin ++
      @ nLin,01 say '|  Cliente '
      @ nLin,12 say ClieARQ->Nome             pict '@S40'
      @ nLin,58 say 'Codigo ' + cClie + '        |'
      nLin ++
      @ nLin,01 say '| Endereço '
      @ nLin,12 say ClieARQ->Ende             pict '@S40'
      @ nLin,61 say 'CEP ' + transform( ClieARQ->CEP, '99999-999' ) + '     |'
      nLin ++
      @ nLin,01 say '|   Bairro '
      @ nLin,12 say ClieARQ->Bair           pict '@S20'
      @ nLin,34 say 'Cidade '
      @ nLin,41 say ClieARQ->Cida           pict '@S20'
      @ nLin,62 say 'UF ' + ClieARQ->UF + '            |'
      nLin ++
      @ nLin,01 say '|  Próximo '
      @ nLin,12 say ClieARQ->Prox
      @ nLin,79 say '|'
      nLin ++
      @ nLin,01 say '|     Fone '
      @ nLin,12 say ClieARQ->Fone           
      @ nLin,37 say 'CPF'
      @ nLin,41 say ClieARQ->CPF               pict '@E 999,999,999-99'
      @ nLin,62 say 'RG ' + left( ClieARQ->RG, 13 ) + ' |'
      nLin ++
      @ nLin,01 say '|  Emprego '
      @ nLin,12 say ClieARQ->Emprego
      @ nLin,59 say 'Cargo ' + left( ClieARQ->Carg, 13 ) + ' |'
      nLin ++
      @ nLin,01 say '|                                                                             |'
      nLin ++
      @ nLin,01 say '| Filiação '
      @ nLin,12 say ClieARQ->Filiacao
      @ nLin,79 say '|'
      nLin ++
      @ nLin,01 say '|  Natural '
      @ nLin,12 say ClieARQ->Natural
      @ nLin,35 say 'Nasc. ' + dtoc( ClieARQ->Nasc )
      @ nLin,52 say 'Estado Civil ' + ClieARQ->EstaCivil + '    |'
      nLin ++
      @ nLin,01 say '|                                                                             |'
      nLin ++
      @ nLin,01 say '|  Conjuge '
      @ nLin,12 say ClieARQ->Conjuge
      @ nLin,59 say 'Nasc. ' + dtoc( ClieARQ->CjNasc ) + '    |'
      nLin ++
      @ nLin,01 say '|  Emprego '
      @ nLin,12 say ClieARQ->CjEmprego
      @ nLin,59 say 'Cargo ' + left( ClieARQ->CjCargo, 13 ) + ' |'
      nLin ++
      @ nLin,01 say '+-----------------------------------------------------------------------------+'
      nLin ++
      @ nLin,01 say '|     Nota Tipo   Emissão         Vcto.     Valor     Juros    Total Vendedor |'
      
      nLin ++

      nPres       := 0
      nTotalValor := nTotalJuro := nTotalGeral := 0
      lCalcJuro   := .t.

      do while Clie == cClie
        if Emis        >= dEmisIni .and. Emis        <= dEmisFin .and.;
           Vcto        >= dVctoIni .and. Vcto        <= dVctoFin .and.;
           val( Port ) >= nPortIni .and. val( Port ) <= nPortFin .and.;
           val( Cobr ) >= nCobrIni .and. val( Cobr ) <= nCobrFin .and.;
           empty( Pgto )

          nJuro       := VerJuro ()
          nValorTotal := Valor + nJuro
          nTotalValor += Valor
          nTotalJuro  += nJuro
          nTotalGeral += nValorTotal

          @ nLin,01 say '|'
          @ nLin,02 say val( Nota )                 pict '999999-99'
          do case
            case Tipo == 'P'
              @ nLin,12 say 'Pedido'
            case Tipo == 'N'
              @ nLin,12 say 'Nota'
            case Tipo == 'O'
              @ nLin,12 say 'O.S.'
          endcase
          @ nLin,19 say Emis                        pict '99/99/9999'
          @ nLin,30 say Vcto                        pict '99/99/9999'
          @ nLin,41 say Valor                       pict '@E 99,999.99'
          @ nLin,51 say nJuro                       pict '@E 99,999.99'
          @ nLin,61 say nValorTotal                 pict '@E 99,999.99'
          @ nLin,70 say ReprARQ->Nome               pict '@S8'
          @ nLin,79 say '|'

          nLin  ++
          nPres ++
        endif  
        
        if nPres > 10
          @ nLin,01 say '+-----------------------------------------------------------------------------+'
          nLin ++
          @ nLin,01 say '|                     A TRANSPORTAR'
          @ nLin,41 say nTotalValor                 pict '@E 99,999.99'
          @ nLin,51 say nTotalJuro                  pict '@E 99,999.99'
          @ nLin,61 say nTotalGeral                 pict '@E 99,999.99'
          @ nLin,79 say '|'
          nLin ++
          @ nLin,01 say '+-----------------------------------------------------------------------------+'

          nLin   := 0
          nPag   ++
          cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
          cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

          set printer to &cArqu2
          set printer on
          
          @ nLin,01 say '+-----------------------------------------------------------------------------+'
          nLin ++
          @ nLin,01 say '|  Cliente '
          @ nLin,12 say ClieARQ->Nome             pict '@S40'
          @ nLin,58 say 'Codigo ' + cClie + '        |'
          nLin ++
          @ nLin,01 say '| Endereço '
          @ nLin,12 say ClieARQ->Ende             pict '@S40'
          @ nLin,61 say 'CEP ' + transform( ClieARQ->CEP, '99999-999' ) + '     |'
          nLin ++
          @ nLin,01 say '|   Bairro '
          @ nLin,12 say ClieARQ->Bair           pict '@S20'
          @ nLin,34 say 'Cidade '
          @ nLin,41 say ClieARQ->Cida           pict '@S20'
          @ nLin,62 say 'UF ' + ClieARQ->UF + '            |'
          nLin ++
          @ nLin,01 say '|  Próximo '
          @ nLin,12 say ClieARQ->Prox
          @ nLin,79 say '|'
          nLin ++
          @ nLin,01 say '|     Fone '
          @ nLin,12 say ClieARQ->Fone         
          @ nLin,37 say 'CPF'
          @ nLin,41 say ClieARQ->CPF               pict '@E 999,999,999-99'
          @ nLin,62 say 'RG ' + left( ClieARQ->RG, 13 ) + ' |'
          nLin ++
          @ nLin,01 say '|  Emprego '
          @ nLin,12 say ClieARQ->Emprego
          @ nLin,59 say 'Cargo ' + left( ClieARQ->Carg, 13 ) + ' |'
          nLin ++
          @ nLin,01 say '|                                                                             |'
          nLin ++
          @ nLin,01 say '| Filiação'
          @ nLin,12 say ClieARQ->Filiacao
          @ nLin,79 say '|'
          nLin ++
          @ nLin,01 say '|  Natural '
          @ nLin,12 say ClieARQ->Natural
          @ nLin,35 say 'Nasc. ' + dtoc( ClieARQ->Nasc )
          @ nLin,52 say 'Estado Civil ' + ClieARQ->EstaCivil + '    |'
          nLin ++
          @ nLin,01 say '|                                                                             |'
          nLin ++
          @ nLin,01 say '|  Conjuge '
          @ nLin,12 say ClieARQ->Conjuge
          @ nLin,59 say 'Nasc. ' + dtoc( ClieARQ->CjNasc ) + '    |'
          nLin ++
          @ nLin,01 say '|  Emprego '
          @ nLin,12 say ClieARQ->CjEmprego
          @ nLin,59 say 'Cargo ' + left( ClieARQ->CjCargo, 13 ) + ' |'
          nLin ++
          @ nLin,01 say '+-----------------------------------------------------------------------------+'
          nLin ++
          @ nLin,01 say '|     Nota Tipo   Emissão         Vcto.     Valor     Juros    Total Vendedor |'

          nLin  ++
          nPres := 0
        endif

        dbskip ()
      enddo

      if nPres < 10
        for nU := 1 to ( 10 - nPres )
          @ nLin,01 say '|'
          @ nLin,79 say '|'
          nLin ++
        next
      endif
      @ nLin,01 say '+-----------------------------------------------------------------------------+'
      nLin ++
      @ nLin,01 say '|                       TOTAL GERAL'
      @ nLin,41 say nTotalValor                 pict '@E 99,999.99'
      @ nLin,51 say nTotalJuro                  pict '@E 99,999.99'
      @ nLin,61 say nTotalGeral                 pict '@E 99,999.99'
      @ nLin,79 say '|'
      nLin ++
      @ nLin,01 say '+-----------------------------------------------------------------------------+'
      nLin += 5

      @ nLin, 00 say space(01)

      nLin := 0

      dbskip(-1)
    endif
   
    dbskip ()
  enddo
  
  set printer to
  set printer off
  set device  to screen
   
  select ClieARQ
  close
  select ReceARQ
  close
  select ReprARQ
  close
  select PortARQ
  close
  select CobrARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

//
// Alt+F - Ficha de Cobrança no Consulta de Clientes
//
function CobrFich ()
  local tPrn := savescreen( 00, 00, 23, 79 )
  
  if NetUse( "ReprARQ", .t. )
    VerifIND( "ReprARQ" )
  
    tOpenRepr := .t.

    #ifdef DBF_NTX
      set index to ReprIND1, ReprIND2
    #endif
  else
    tOpenRepr := .f.
  endif
  
  if NetUse( "ReceARQ", .t. )
    VerifIND( "ReceARQ" )
   
    tOpenRece := .t.

    #ifdef DBF_NTX
      set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
    #endif
  else
    tOpenRece := .f.
  endif
  
  Janela( 11, 22, 14, 49, mensagem( 'Janela', 'Imprimir', .f. ), .f. )
  Mensagem( 'LEVE', 'Print' )
  setcolor( CorJanel )
    
  aOpc := {}

  aadd( aOpc, { ' Impressora ', 2, 'I', 13, 25, "Imprimir Ficha do Cliente para impressora." } )
  aadd( aOpc, { ' Arquivo ',    2, 'A', 13, 38, "Gerar arquivo texto da impressão do pedido." } )
    
  nTipoNota := HCHOICE( aOpc, 2, 1 )
    
  if nTipoNota == 2
      Janela( 05, 16, 10, 54, mensagem( 'Janela', 'Salvar', .f. ), .f. )
      Mensagem( 'LEVE', 'Salvar' ) 

      cArqu2  := CriaTemp( 5 )
      xArqu3  := right ( cArqu2, 8 )

      cTXT    := 'X'
      cHTM    := ' '
      cXML    := ' '
      cPDF    := ' '
  
      cArqTxt := cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() + alltrim( xArqu3 ) + ".txt" + space(40)
        
      keyboard( chr( K_END ) )

      @ 07,18 say '[ ] TXT  [ ] HTML  [ ] XML  [ ] PDF'

      @ 07,19 get cTXT              pict '@!'  valid TipoTxt()
      @ 07,28 get cHTM              pict '@!'  valid TipoTxt()
      @ 07,38 get cXML              pict '@!'  valid TipoTxt()
      @ 07,47 get cPDF              pict '@!'  valid TipoTxt()
      @ 09,18 get cArqTxt           pict '@S35'
      read
    
      if lastkey() == K_ESC
        restscreen( 00, 00, 23, 79, tPrn )
        return NIL
      endif  
  
      set printer to ( cArqTxt )
      set device  to printer
      set printer on
  else    
    if EmprARQ->Impr == "X"
      if !TestPrint( EmprARQ->Pedido )
        restscreen( 00, 00, 23, 79, tPrn )
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
        restscreen( 00, 00, 23, 79, tPrn )
        return NIL
      endif  

      cArqu2  := CriaTemp( 5 )
      xArqu3  := right( cArqu2, 8 )
      cArqTxt := cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() + alltrim( xArqu3 ) + ".txt" + space(40)
  
      set printer to ( cArqTxt )
      set device  to printer
      set printer on
  
      nTipoNota := 2
    endif  
  endif    

  iClie := ClieARQ->Clie
  
  setprc( 0, 0 )

  if nTipoNota == 1 .and. EmprARQ->Impr == "X"   
    @ 00, 00 say chr(27) + "@"
    @ 00, 00 say chr(27) + chr(67) + chr(33)
    @ 00, 00 say chr(18)
  endif
  
  nLin := 0
  
  select ReprARQ
  set order to 1
  
  select ClieARQ
  set order to 1
  dbseek( iClie, .f. )
  
  select ReceARQ
  set order to 4
  dbseek( iClie, .t. )
  set relation to Clie into ClieARQ, Repr into ReprARQ

  do while Clie == iClie .and. !eof()
    if empty( Pgto )
      @ nLin,02 say '+-----------------------------------------------------------------------------+'
      nLin ++
      @ nLin,01 say '|  Cliente '
      @ nLin,12 say ClieARQ->Nome             pict '@S40'
      @ nLin,58 say 'Codigo ' + iClie + '        |'
      nLin ++
      @ nLin,01 say '| Endereço '
      @ nLin,12 say ClieARQ->Ende             pict '@S40'
      @ nLin,61 say 'CEP ' + transform( ClieARQ->CEP, '99999-999' ) + '     |'
      nLin ++
      @ nLin,01 say '|   Bairro '
      @ nLin,12 say ClieARQ->Bair           pict '@S20'
      @ nLin,34 say 'Cidade '
      @ nLin,41 say ClieARQ->Cida           pict '@S20'
      @ nLin,62 say 'UF ' + ClieARQ->UF + '            |'
      nLin ++
      @ nLin,01 say '|  Próximo '
      @ nLin,12 say ClieARQ->Prox
      @ nLin,79 say '|'
      nLin ++
      @ nLin,01 say '|     Fone '
      @ nLin,12 say ClieARQ->Fone         
      @ nLin,37 say 'CPF'
      @ nLin,41 say ClieARQ->CPF               pict '@E 999,999,999-99'
      @ nLin,62 say 'RG ' + left( ClieARQ->RG, 13 ) + ' |'
      nLin ++
      @ nLin,01 say '|  Emprego '
      @ nLin,12 say ClieARQ->Emprego
      @ nLin,59 say 'Cargo ' + left( ClieARQ->Carg, 13 ) + ' |'
      nLin ++
      @ nLin,01 say '|                                                                             |'
      nLin ++
      @ nLin,01 say '| Filiação '
      @ nLin,12 say ClieARQ->Filiacao
      @ nLin,79 say '|'
      nLin ++
      @ nLin,01 say '|  Natural '
      @ nLin,12 say ClieARQ->Natural
      @ nLin,35 say 'Nasc. ' + dtoc( ClieARQ->Nasc )
      @ nLin,52 say 'Estado Civil ' + ClieARQ->EstaCivil + '    |'
      nLin ++
      @ nLin,01 say '|                                                                             |'
      nLin ++
      @ nLin,01 say '|  Conjuge '
      @ nLin,12 say ClieARQ->Conjuge
      @ nLin,59 say 'Nasc. ' + dtoc( ClieARQ->CjNasc ) + '    |'
      nLin ++
      @ nLin,01 say '|  Emprego '
      @ nLin,12 say ClieARQ->CjEmprego
      @ nLin,59 say 'Cargo ' + left( ClieARQ->CjCargo, 13 ) + ' |'
      nLin ++
      @ nLin,01 say '+-----------------------------------------------------------------------------+'
      nLin ++
      @ nLin,01 say '|     Nota Tipo   Emissão         Vcto.     Valor     Juros    Total Vendedor |'
      nLin ++

      nPres       := 0
      nTotalValor := nTotalJuro := nTotalGeral := 0
      lCalcJuro   := .t.

      do while Clie == iClie
        nJuro       := VerJuro ()
        nValorTotal := Valor + nJuro
        nTotalValor += Valor
        nTotalJuro  += nJuro
        nTotalGeral += nValorTotal

        @ nLin,01 say '|'
        @ nLin,02 say val( Nota )                 pict '999999-99'
        do case
          case Tipo == 'P'
            @ nLin,12 say 'Pedido'
          case Tipo == 'N'
            @ nLin,12 say 'Nota'
          case Tipo == 'O'
            @ nLin,12 say 'O.S.'
        endcase
        @ nLin,19 say Emis                        pict '99/99/9999'
        @ nLin,30 say Vcto                        pict '99/99/9999'
        @ nLin,41 say Valor                       pict '@E 99,999.99'
        @ nLin,51 say nJuro                       pict '@E 99,999.99'
        @ nLin,61 say nValorTotal                 pict '@E 99,999.99'
        @ nLin,70 say ReprARQ->Nome               pict '@S8'
        @ nLin,79 say '|'

        nLin  ++
        nPres ++
        
        if nPres > 10
          @ nLin,01 say '+-----------------------------------------------------------------------------+'
          nLin ++
          @ nLin,01 say '|                     A TRANSPORTAR'
          @ nLin,41 say nTotalValor                 pict '@E 999,999.99'
          @ nLin,51 say nTotalJuro                  pict '@E 99,999.99'
          @ nLin,61 say nTotalGeral                 pict '@E 999,999.99'
          @ nLin,79 say '|'
          nLin ++
          @ nLin,01 say '+-----------------------------------------------------------------------------+'
          nLin += 5
          @ nLin,01 say space(1)

          nLin := 0
          
          @ nLin,01 say '+-----------------------------------------------------------------------------+'
          nLin ++
          @ nLin,01 say '|  Cliente '
          @ nLin,12 say ClieARQ->Nome             pict '@S40'
          @ nLin,58 say 'Codigo ' + iClie + '        |'
          nLin ++
          @ nLin,01 say '| Endereço '
          @ nLin,12 say ClieARQ->Ende             pict '@S40'
          @ nLin,61 say 'CEP ' + transform( ClieARQ->CEP, '99999-999' ) + '     |'
          nLin ++
          @ nLin,01 say '|   Bairro '
          @ nLin,12 say ClieARQ->Bair           pict '@S20'
          @ nLin,34 say 'Cidade '
          @ nLin,41 say ClieARQ->Cida           pict '@S20'
          @ nLin,62 say 'UF ' + ClieARQ->UF + '            |'
          nLin ++
          @ nLin,01 say '|  Próximo '
          @ nLin,12 say ClieARQ->Prox
          @ nLin,79 say '|'
          nLin ++
          @ nLin,01 say '|     Fone '
          @ nLin,12 say ClieARQ->Fone       
          @ nLin,37 say 'CPF'
          @ nLin,41 say ClieARQ->CPF               pict '@E 999,999,999-99'
          @ nLin,62 say 'RG ' + left( ClieARQ->RG, 13 ) + ' |'
          nLin ++
          @ nLin,01 say '|  Emprego '
          @ nLin,12 say ClieARQ->Emprego
          @ nLin,59 say 'Cargo ' + left( ClieARQ->Carg, 13 ) + ' |'
          nLin ++
          @ nLin,01 say '|                                                                             |'
          nLin ++
          @ nLin,01 say '| Filiação '
          @ nLin,12 say ClieARQ->Filiacao
          @ nLin,79 say '|'
          nLin ++
          @ nLin,01 say '|  Natural '
          @ nLin,12 say ClieARQ->Natural
          @ nLin,35 say 'Nasc. ' + dtoc( ClieARQ->Nasc )
          @ nLin,52 say 'Estado Civil ' + ClieARQ->EstaCivil + '    |'
          nLin ++
          @ nLin,01 say '|                                                                             |'
          nLin ++
          @ nLin,01 say '|  Conjuge '
          @ nLin,12 say ClieARQ->Conjuge
          @ nLin,59 say 'Nasc. ' + dtoc( ClieARQ->CjNasc ) + '      |'
          nLin ++
          @ nLin,01 say '|  Emprego '
          @ nLin,12 say ClieARQ->CjEmprego
          @ nLin,59 say 'Cargo ' + left( ClieARQ->CjCargo, 13 ) + ' |'
          nLin ++
          @ nLin,01 say '+-----------------------------------------------------------------------------+'
          nLin ++
          @ nLin,01 say '|     Nota Tipo   Emissão         Vcto.     Valor     Juros    Total Vendedor |'

          nLin  ++
          nPres := 0
        endif

        dbskip ()
      enddo

      if nPres < 10
        for nU := 1 to ( 10 - nPres )
          @ nLin,01 say '|'
          @ nLin,79 say '|'
          nLin ++
        next
      endif
      @ nLin,01 say '+-----------------------------------------------------------------------------+'
      nLin ++
      @ nLin,01 say '|                       TOTAL GERAL'
      @ nLin,41 say nTotalValor                 pict '@E 999,999.99'
      @ nLin,51 say nTotalJuro                  pict '@E 99,999.99'
      @ nLin,61 say nTotalGeral                 pict '@E 999,999.99'
      @ nLin,79 say '|'
      nLin ++
      @ nLin,01 say '+-----------------------------------------------------------------------------+'
      nLin += 5

      @ nLin, 00 say space(01)

      nLin   := 0
      
      dbskip(-1)
    endif
   
    dbskip ()
  enddo
  
  set printer to
  set printer off
  set device  to screen
  
  if !empty( GetDefaultPrinter() ) .and. nPrn > 0
    PrnTest(aPrn[nPrn], memoread( cArqTxt ), .f. )
  endif
  
  if tOpenRece 
    select ReceARQ
    close
  endif
  
  if tOpenRepr
    select ReprARQ
    close
  endif
  
  select ClieARQ
  
  restscreen( 00, 00, 23, 79, tPrn )
return NIL