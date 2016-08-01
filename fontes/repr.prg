//  Leve, Vendedor - Funcionário
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

function Repr( xAlte )
  local GetList := {}
  
if SemAcesso( 'Repr' )
  return NIL
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

//  Variaveis de Entrada para Vendedor
nFnci      := vCEP       := nHabi := nSeca := nSalaBase  := nDiasMes  := 0
nDpSF      := nDpIR      := nPIS  := nZona := nCPro      := nCoRe     := 0
dPAdm      := dAdmi      := dDesd := vNasc := dOpcaFGTS  := dRetrFGTS := ctod('  /  /  ')
vCarg      := vBair      := vCida := space (20)
cFnci      := cStat      := space(04)
vNaci      := vNatu      := space(18)
cUF        := space(02)
cRG        := cCracha    := space(15)
cHabi      := space(10)
vNome      := cConj      := space(40)
vEnde      := space(45)
cFili      := space(53)
vFone      := cCPF       := cTitE      := space (14)
nMaxDesc   := 0

nCTPSNum   := nCTPSSer   := nGrauInst  := 0
vEstaCivi  := space(10)
cCodiFGTS  := space(09)
cDigiFGTS  := space(02)
cOptaFGTS  := space(01)
cAgenFGTS  := cAgenPIS   := space(06)
cBancFGTS  := cBancPIS   := space(20)
cCateHabi  := space(04)
dValiHabi  := ctod(' /  /  ')

cDomIniTur := cDomIniAlm := cDomTerAlm := cDomTerTur := cSegIniTur := space(05)
cSegIniAlm := cSegTerAlm := cSegTerTur := cTerIniTur := cTerIniAlm := space(05)
cTerTerAlm := cTerTerTur := cQuaIniTur := cQuaIniAlm := cQuaTerAlm := space(05)
cQuaTerTur := cQuiIniTur := cQuiIniAlm := cQuiTerAlm := cQuiTerTur := space(05)
cSexIniTur := cSexIniAlm := cSexTerAlm := cSexTerTur := cSabIniTur := space(05)
cSabIniAlm := cSabTerAlm := cSabTerTur := space(05)

//  Tela Vendedor
Janela ( 02, 02, 21, 76, mensagem( 'Janela', 'Repr', .f. ), .t. )

setcolor ( CorJanel )
@ 04,05 say ' Funcionário'
@ 04,25 say "Desc       %" 
@ 04,39 say 'Comissão       % '
@ 04,57 say 'Admissão'
@ 06,05 say '        Nome'
@ 06,59 say 'Cracha'
@ 07,05 say ' Cargo Atual'
@ 07,60 say 'Desde'
@ 08,05 say '     Salário'
@ 08,50 say 'N. Dias por Mês'
@ 10,05 say '    Endereço'
@ 10,62 say 'CEP'
@ 11,05 say '      Bairro'
@ 11,39 say 'Cidade'
@ 11,63 say 'UF'
@ 12,05 say '    Telefone'
@ 14,05 say '    Filiação'
@ 15,03 say ' Nacionalidade'
@ 15,38 say 'Natural'
@ 16,05 say 'Estado Civil'
@ 16,57 say 'Dt.Nasc.'
@ 17,05 say '     Conjuge'
@ 18,05 say '    N.Dep.SF'
@ 18,57 say 'N.Dep.IR'

MostXX()

tRepr := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Vendedor
select ReprARQ
set order to 1
if lOpenRepr
  dbgobottom ()
endif  
do while .t.
  select ReprARQ
  set order to 1

  cStat := space(04)

  Mensagem ( 'Repr', 'Janela' )

  restscreen( 00, 00, 23, 79, tRepr )
  MostRepr()
  
  if Demo ()
    exit
  endif  
  
  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostRepr'
  cAjuda   := 'Repr'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  if lastkey() == K_ALT_A
    nFnci := val( Repr )
  else    
    if xAlte
      @ 04,18 get nFnci pict '999999'
      read
    else
      nFnci := 0
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
  cFnci := strzero( nFnci, 6 )
  @ 04,18 say cFnci

  //  Verificar existencia do Vendedor para Incluir ou Alterar
  select ReprARQ
  set order to 1
  dbseek( cFnci, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif
  
  Mensagem( 'Repr', cStat )
  
  MostRepr ()
  EntrRepr ()
  EntrDcto ()
  EntrHH   ()

  cStatAux := cStat
  aOpcoes  := {}
  tLinha   := savescreen( 24, 01, 24, 79 )
  
  aadd( aOpcoes, { ' Imprimir ',  2, 'I', 20, 04, "Imprimir relatório de funcionários." } )
  aadd( aOpcoes, { ' Excluir ',   6, 'U', 20, 16, "Excluir funcionário." } )
  aadd( aOpcoes, { ' Horário ',   2, 'H', 20, 29, "Configurar Horário de funcionário." } )
  aadd( aOpcoes, { ' Dcto. ',     2, 'D', 20, 40, "Cadastrar documentos de funcionários." } )
  aadd( aOpcoes, { ' Confirmar ', 2, 'C', 20, 52, "Confirmar inclusão ou alteração" } )
  aadd( aOpcoes, { ' Cancelar ',  3, 'A', 20, 65, "Cancelar alteraç”es" } )
  
  do while lastkey() != K_ESC
    MostXX ()
    
    nOpConf := HCHOICE( aOpcoes, 6, 5 )
    
    do case
      case nOpConf == 0 .or. nOpConf == 6
        cStat := 'loop'

        exit
      case nOpConf == 1
        cStat := 'prin'

        exit
      case nOpConf == 2
        cStat := 'excl'

        exit
      case nOpConf == 3
        EntrHH ()
    
        cStat := cStatAux
      case nOpConf == 4
        EntrDcto ()
    
        cStat := cStatAux
      case nOpConf == 5
        exit      
    endcase
  enddo  
        
  restscreen( 24, 01, 24, 79, tLinha )
  
  if cStat == 'loop' .or. lastkey () == K_ESC
    loop
  endif  

  if cStat == 'prin'
    PrinRepr (.f.)
  endif
    
  if cStat == 'excl'
    ExclRegi ()
  endif
   
  if cStat == 'incl'
    if cFnci == '000000'
      cFnci := '000001'
    endif    

    set order to 1  
    do while .t.
      dbseek( cFnci, .f. )
      if found()
        nRepr := val( cFnci ) + 1               
        cFnci := strzero( nRepr, 6 )
      else 
        exit   
      endif
    enddo

    if AdiReg()
      if RegLock()
        replace Repr     with cFnci
        dbunlock ()
      endif
    endif 
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace PerC        with nCoRe 
      replace Nome        with vNome
      replace PAdm        with dPAdm
      replace Admi        with dAdmi
      replace Carg        with vCarg
      replace Desd        with dDesd
      replace SalaBase    with nSalaBase
      replace DiasMes     with nDiasMes
      replace Naci        with vNaci
      replace Natu        with vNatu
      replace EstaCivi    with vEstaCivi
      replace CTPSNum     with nCTPSNum
      replace CTPSSer     with nCTPSSer
      replace RG          with cRG
      replace CPF         with cCPF
      replace PIS         with nPIS
      replace BancPIS     with cBancPIS
      replace AgenPIS     with cAgenPIS
      replace Nasc        with vNasc
      replace Fili        with cFili
      replace Conj        with cConj
      replace DpSF        with nDpSF
      replace DpIR        with nDpIR
      replace Ende        with vEnde
      replace Bair        with vBair
      replace Cracha      with cCracha
      replace Cida        with vCida
      replace UF          with cUF
      replace CEP         with vCEP
      replace Fone        with vFone
      replace TitE        with cTitE
      replace Zona        with nZona
      replace Seca        with nSeca
      replace OptaFGTS    with cOptaFGTS
      replace OpcaFGTS    with dOpcaFGTS
      replace RetrFGTS    with dRetrFGTS
      replace BancFGTS    with cBancFGTS
      replace AgenFGTS    with cAgenFGTS
      replace GrauInst    with nGrauInst
      replace CPro        with nCPro
      replace CodiFGTS    with cCodiFGTS
      replace DigiFGTS    with cDigiFGTS
      replace Habi        with nHabi
      replace CateHabi    with cCateHabi
      replace ValiHabi    with dValiHabi
      replace DomIniTur   with cDomIniTur
      replace DomIniAlm   with cDomIniAlm
      replace DomTerAlm   with cDomTerAlm
      replace DomTerTur   with cDomTerTur
      replace SegIniTur   with cSegIniTur
      replace SegIniAlm   with cSegIniAlm
      replace SegTerAlm   with cSegTerAlm
      replace SegTerTur   with cSegTerTur
      replace TerIniTur   with cTerIniTur
      replace TerIniAlm   with cTerIniAlm
      replace TerTerAlm   with cTerTerAlm
      replace TerTerTur   with cTerTerTur
      replace QuaIniTur   with cQuaIniTur
      replace QuaIniAlm   with cQuaIniAlm
      replace QuaTerAlm   with cQuaTerAlm
      replace QuaTerTur   with cQuaTerTur
      replace QuiIniTur   with cQuiIniTur
      replace QuiIniAlm   with cQuiIniAlm
      replace QuiTerAlm   with cQuiTerAlm
      replace QuiTerTur   with cQuiTerTur
      replace SexIniTur   with cSexIniTur
      replace SexIniAlm   with cSexIniAlm
      replace SexTerAlm   with cSexTerAlm
      replace SexTerTur   with cSexTerTur
      replace SabIniTur   with cSabIniTur
      replace SabIniAlm   with cSabIniAlm
      replace SabTerAlm   with cSabTerAlm
      replace SabTerTur   with cSabTerTur
      dbunlock ()
    endif
    
    if !xAlte
      xAlte := .t.
      keyboard(chr(27))
    endif  
  endif
enddo

if lOpenRepr
  select ReprARQ
  close
endif  
return NIL

function MostXX ()
  setcolor( CorCampo )
  @ 20,04 say ' Imprimir '
  @ 20,16 say ' Excluir '
  @ 20,29 say ' Hor rio '
  @ 20,40 say ' Dcto. '
  @ 20,52 say ' Confirmar '
  @ 20,65 say ' Cancelar '

  setcolor( CorAltKC )
  @ 20,05 say 'I'
  @ 20,21 say 'u'
  @ 20,30 say 'H'
  @ 20,41 say 'D'
  @ 20,53 say 'C'
  @ 20,67 say 'a'
return NIL

//
// Entra Dados do Vendedor
//
function EntrRepr()
  local GetList := {}
  
  do while .t.
    lAlterou := .f.
    
    setcolor ( CorJanel + ',' + CorCampo )
    @ 04,48 get nCoRe          pict '@E 99.99'
    @ 04,66 get dAdmi          pict '99/99/9999'
    @ 06,18 get vNome          pict '@S40'
    @ 06,66 get cCracha        pict '@S10'
    @ 07,18 get vCarg
    @ 07,66 get dDesd          pict '99/99/9999'
    @ 08,18 get nSalaBase      pict '@E 999,999,999.99'
    @ 08,66 get nDiasMes       pict '99'
    @ 10,18 get vEnde          pict '@S40'
    @ 10,66 get vCEP           pict '99999-999'
    @ 11,18 get vBair          pict '@S15'
    @ 11,46 get vCida          pict '@S15' 
    @ 11,66 get cUF            pict '@!' valid ValidUF( 11, 66, "ReprARQ" )
    @ 12,18 get vFone          
    @ 14,18 get cFili          pict '@S50' 
    @ 15,18 get vNaci
    @ 15,46 get vNatu
    @ 16,18 get vEstaCivi
    @ 16,66 get vNasc          pict '99/99/9999'
    @ 17,18 get cConj          pict '@S50'
    @ 18,18 get nDpSF
    @ 18,66 get nDpIR
    read
    
    if nCoRe          != PerC;      lAlterou := .t.
    elseif dAdmi      != Admi;      lAlterou := .t.
    elseif vNome      != Nome;      lAlterou := .t.
    elseif cCracha    != Cracha;    lAlterou := .t.
    elseif vCarg      != Carg;      lAlterou := .t.
    elseif dDesd      != Desd;      lAlterou := .t.
    elseif nSalaBase  != SalaBase;  lAlterou := .t.
    elseif nDiasMes   != DiasMes;   lAlterou := .t.
    elseif vEnde      != Ende;      lAlterou := .t.
    elseif vCEP       != CEP;       lAlterou := .t.
    elseif vBair      != Bair;      lAlterou := .t.
    elseif vCida      != Cida;      lAlterou := .t.
    elseif cUF        != UF;        lAlterou := .t.
    elseif vFone      != Fone;      lAlterou := .t.
    elseif cFili      != Fili;      lAlterou := .t.
    elseif vNaci      != Naci;      lAlterou := .t.
    elseif vNatu      != Natu;      lAlterou := .t.
    elseif vEstaCivi  != EstaCivi;  lAlterou := .t.
    elseif vNasc      != Nasc;      lAlterou := .t.
    elseif cConj      != Conj;      lAlterou := .t.
    elseif nDpSF      != DpSF;      lAlterou := .t.
    elseif nDpIR      != DpIR;      lAlterou := .t.
    endif

    if !Saindo(lAlterou)
      loop
    endif

    exit 
  enddo  
return NIL

//
// Mostra Dados do Vendedor
//
function MostRepr()
  setcolor ( CorCampo )
  if cStat != 'incl'
    nFnci   := val( Repr )
    cFnci   := Repr

    @ 04,18 say cFnci
  endif
     
  nCoRe       := PerC
  vNome       := Nome
  dPAdm       := PAdm
  dAdmi       := Admi 
  vCarg       := Carg
  dDesd       := Desd
  cRG         := RG
  cCPF        := CPF
  nPIS        := PIS
  vEnde       := Ende
  vBair       := Bair
  vCida       := Cida
  cCracha     := Cracha
  cUF         := UF  
  vCEP        := CEP
  vNasc       := Nasc
  nCPro       := CPro
  nTitE       := TitE
  nZona       := Zona
  nSeca       := Seca
  cFili       := Fili
  cConj       := Conj
  nDpIR       := DpIR
  nDpSF       := DpSF
  vNaci       := Naci
  vNatu       := Natu

  nSalaBase   := SalaBase
  nDiasMes    := DiasMes
  cBancPIS    := BancPIS
  cAgenPIS    := AgenPIS
  vFone       := Fone
  cOptaFGTS   := OptaFGTS
  dOpcaFGTS   := OpcaFGTS
  dRetrFGTS   := RetrFGTS
  cBancFGTS   := BancFGTS
  cAgenFGTS   := AgenFGTS
  nGrauInst   := GrauInst
  cCodiFGTS   := CodiFGTS
  cDigiFGTS   := DigiFGTS
  vEstaCivi   := EstaCivi
  nCTPSNum    := CTPSNum
  nCTPSSer    := CTPSSer
  nHabi       := Habi
  cCateHabi   := CateHabi
  dValiHabi   := ValiHabi

  cDomIniTur  := DomIniTur
  cDomIniAlm  := DomIniAlm
  cDomTerAlm  := DomTerAlm
  cDomTerTur  := DomTerTur
  cSegIniTur  := SegIniTur
  cSegIniAlm  := SegIniAlm
  cSegTerAlm  := SegTerAlm
  cSegTerTur  := SegTerTur
  cTerIniTur  := TerIniTur
  cTerIniAlm  := TerIniAlm
  cTerTerAlm  := TerTerAlm
  cTerTerTur  := TerTerTur
  cQuaIniTur  := QuaIniTur
  cQuaIniAlm  := QuaIniAlm
  cQuaTerAlm  := QuaTerAlm
  cQuaTerTur  := QuaTerTur
  cQuiIniTur  := QuiIniTur
  cQuiIniAlm  := QuiIniAlm
  cQuiTerAlm  := QuiTerAlm
  cQuiTerTur  := QuiTerTur
  cSexIniTur  := SexIniTur
  cSexIniAlm  := SexIniAlm
  cSexTerAlm  := SexTerAlm
  cSexTerTur  := SexTerTur
  cSabIniTur  := SabIniTur
  cSabIniAlm  := SabIniAlm
  cSabTerAlm  := SabTerAlm
  cSabTerTur  := SabTerTur

  setcolor ( CorCampo )
  @ 04,30 say nMaxDesc       pict '@E 99.99'
  @ 04,48 say nCoRe          pict '@E 99.99'
  @ 04,66 say dAdmi          pict '99/99/9999'
  @ 06,18 say vNome          pict '@S40' 
  @ 06,66 say cCracha        pict '@S10'
  @ 07,18 say vCarg
  @ 07,66 say dDesd          pict '99/99/9999'
  @ 08,18 say nSalaBase      pict '@E 999,999,999.99'
  @ 08,66 say nDiasMes       pict '99'
  @ 10,18 say vEnde          pict '@S40'
  @ 10,66 say vCEP           pict '99999-999'
  @ 11,18 say vBair          pict '@S15'
  @ 11,46 say vCida          pict '@S15' 
  @ 11,66 say cUF            pict '@!'
  @ 12,18 say vFone          
  @ 14,18 say cFili          pict '@S50' 
  @ 15,18 say vNaci
  @ 15,46 say vNatu
  @ 16,18 say vEstaCivi
  @ 16,66 say vNasc          pict '99/99/9999'
  @ 17,18 say cConj          pict '@S50'
  @ 18,18 say nDpSF
  @ 18,66 say nDpIR
  
  PosiDBF( 02, 76 )
return NIL

//
// Cadastro os Documentos
//
function EntrDcto ()
  local GetList := {}

  if lastkey() == K_PGDN .or. lastkey() == K_ESC
    return NIL
  endif  

  tDcto := savescreen( 00, 00, 23, 79 )

  Janela ( 06, 03, 18, 73 , mensagem( 'Janela', 'EntrDcto', .f. ), .f. )
  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,05 say '          RG'
  @ 08,39 say 'CPF'
  @ 09,05 say 'Tít. Eleitor'
  @ 09,38 say 'Zona'
  @ 09,56 say 'Seção'
  @ 10,05 say '     N. CTPS'
  @ 10,32 say 'S‚rie CTPS'
  @ 10,52 say 'Gr.Instr.'
  @ 11,05 say ' Habilitação'
  @ 11,32 say ' Categoria'
  @ 11,52 say ' Validade'
  @ 13,05 say '         PIS'
  @ 14,05 say '   Banco PIS'
  @ 14,50 say 'Agˆncia PIS'
  @ 15,05 say '  Opção FGTS'
  @ 15,33 say 'Dt. Opção'
  @ 15,54 say 'Dt.Ret.'
  @ 16,05 say '        FGTS'
  @ 16,27 say '-'
  @ 17,05 say '  Banco FGTS'
  @ 17,49 say 'Agˆncia FGTS'
  

  @ 08,18 get cRG            pict '@!'
  @ 08,43 get cCPF           pict '999.999.999-99'
  @ 08,62 get dPAdm          pict '99/99/9999'
  @ 09,18 get cTitE          pict '999999999-99'
  @ 09,43 get nZona
  @ 09,62 get nSeca
  @ 10,18 get nCTPSNum
  @ 10,43 get nCTPSSer
  @ 10,62 get nGrauInst      pict '9'
  @ 11,18 get nHabi          pict '99999999-9'
  @ 11,43 get cCateHabi      pict '@!'
  @ 11,62 get dValiHabi      pict '99/99/9999'
  @ 13,18 get nPIS
  @ 14,18 get cBancPIS
  @ 14,62 get cAgenPIS
  @ 15,18 get cOptaFGTS
  @ 15,43 get dOpcaFGTS      pict '99/99/9999'
  @ 15,62 get dRetrFGTS      pict '99/99/9999'
  @ 16,18 get cCodiFGTS
  @ 16,28 get cDigiFGTS
  @ 17,18 get cBancFGTS
  @ 17,62 get cAgenFGTS
  read
  restscreen( 00, 00, 23, 79, tDcto )
return NIL

//
// Copia Horario para todos os Dias
//
function CopiaHr ()
  local tCopia  := savescreen( 00, 00, 23, 79 )
  local GetList := {}
  
  Janela( 07, 23, 13, 47, mensagem( 'Janela', 'CopiaHr', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )
  @ 09,25 say '  Inicio Turno '
  @ 10,25 say ' Inicio Almoço '
  @ 11,25 say 'Término Almoço '
  @ 12,25 say ' Término Turno '
   
  cIniTur := cIniAlm := cTerAlm := cTerTur := space(05)
  
  @ 09,40 get cIniTur         pict '99:99' valid ValidHora( cIniTur, "cIniTur" ) 
  @ 10,40 get cIniAlm         pict '99:99' valid ValidHora( cIniAlm, "cIniAlm" ) 
  @ 11,40 get cTerAlm         pict '99:99' valid ValidHora( cTerAlm, "cTerAlm" ) 
  @ 12,40 get cTerTur         pict '99:99' valid ValidHora( cTerTur, "cTerTur" ) 
  read
  
  if lastkey() != K_ESC
    cDomIniTur := '00:00'
    cDomIniAlm := '00:00'
    cDomTerAlm := '00:00'
    cDomTerTur := '00:00'
    cSegIniTur := cIniTur
    cSegIniAlm := cIniAlm
    cSegTerAlm := cTerAlm
    cSegTerTur := cTerTur
    cTerIniTur := cIniTur
    cTerIniAlm := cIniAlm
    cTerTerAlm := cTerAlm
    cTerTerTur := cTerTur
    cQuaIniTur := cIniTur
    cQuaIniAlm := cIniAlm
    cQuaTerAlm := cTerAlm
    cQuaTerTur := cTerTur
    cQuiIniTur := cIniTur
    cQuiIniAlm := cIniAlm
    cQuiTerAlm := cTerAlm
    cQuiTerTur := cTerTur
    cSexIniTur := cIniTur
    cSexIniAlm := cIniAlm
    cSexTerAlm := cTerAlm
    cSexTerTur := cTerTur
    cSabIniTur := '00:00'
    cSabIniAlm := '00:00'
    cSabTerAlm := '00:00'
    cSabTerTur := '00:00'
  endif
  
  restscreen( 00, 00, 23, 79, tCopia )

  if lastkey() != K_ESC
    setcolor( CorCampo )
    @ 11,29 say cDomIniTur            pict '99:99'
    @ 11,37 say cDomIniAlm            pict '99:99'
    @ 11,46 say cDomTerAlm            pict '99:99'
    @ 11,55 say cDomTerTur            pict '99:99'
    @ 12,29 say cSegIniTur            pict '99:99'
    @ 12,37 say cSegIniAlm            pict '99:99'
    @ 12,46 say cSegTerAlm            pict '99:99'
    @ 12,55 say cSegTerTur            pict '99:99'
    @ 13,29 say cTerIniTur            pict '99:99'
    @ 13,37 say cTerIniAlm            pict '99:99'
    @ 13,46 say cTerTerAlm            pict '99:99'
    @ 13,55 say cTerTerTur            pict '99:99'
    @ 14,29 say cQuaIniTur            pict '99:99'
    @ 14,37 say cQuaIniAlm            pict '99:99'
    @ 14,46 say cQuaTerAlm            pict '99:99'
    @ 14,55 say cQuaTerTur            pict '99:99'
    @ 15,29 say cQuiIniTur            pict '99:99'
    @ 15,37 say cQuiIniAlm            pict '99:99'
    @ 15,46 say cQuiTerAlm            pict '99:99'
    @ 15,55 say cQuiTerTur            pict '99:99'
    @ 16,29 say cSexIniTur            pict '99:99'
    @ 16,37 say cSexIniAlm            pict '99:99'
    @ 16,46 say cSexTerAlm            pict '99:99'
    @ 16,55 say cSexTerTur            pict '99:99'
    @ 17,29 say cSabIniTur            pict '99:99'
    @ 17,37 say cSabIniAlm            pict '99:99'
    @ 17,46 say cSabTerAlm            pict '99:99'
    @ 17,55 say cSabTerTur            pict '99:99'
    setcolor( CorJanel + ',' + CorCampo )
  endif  
return NIL

//
// Entra com Hor rio do Vendedor
//
function EntrHH ()
  if lastkey() == K_PGDN .or. lastkey() == K_ESC
    return NIL
  endif  

  tHH := savescreen( 00, 00, 23, 79 )

  Janela ( 06, 18, 18, 61, mensagem( 'Janela', 'EntrHH', .f. ), .f. )
  Mensagem( 'Repr', 'EntrHH' )

  setcolor( CorJanel + ',' + CorCampo )
  @ 08,21 say '       Inicio  Inicio  Término  Término'
  @ 09,21 say '        Turno  Almoço   Almoço    Turno'

  @ 11,21 say 'Domingo '
  @ 12,21 say 'Segunda '
  @ 13,21 say '  Terça '
  @ 14,21 say ' Quarta '
  @ 15,21 say ' Quinta '
  @ 16,21 say '  Sexta '
  @ 17,21 say ' S bado '
  
  set key K_ALT_H  to CopiaHR ()

  setcolor ( CorJanel + ',' + CorCampo )
  @ 11,29 get cDomIniTur            pict '99:99'     valid ValidHora( cDomIniTur, "cDomIniTur" )
  @ 11,37 get cDomIniAlm            pict '99:99'     valid ValidHora( cDomIniAlm, "cDomIniAlm" )
  @ 11,46 get cDomTerAlm            pict '99:99'     valid ValidHora( cDomTerAlm, "cDomTerAlm" )
  @ 11,55 get cDomTerTur            pict '99:99'     valid ValidHora( cDomTerTur, "cDomTerTur" )
  @ 12,29 get cSegIniTur            pict '99:99'     valid ValidHora( cSegIniTur, "cSegIniTur" )
  @ 12,37 get cSegIniAlm            pict '99:99'     valid ValidHora( cSegIniAlm, "cSegIniAlm" )
  @ 12,46 get cSegTerAlm            pict '99:99'     valid ValidHora( cSegTerAlm, "cSegTerAlm" )
  @ 12,55 get cSegTerTur            pict '99:99'     valid ValidHora( cSegTerTur, "cSegTerTur" )
  @ 13,29 get cTerIniTur            pict '99:99'     valid ValidHora( cTerIniTur, "cTerIniTur" )
  @ 13,37 get cTerIniAlm            pict '99:99'     valid ValidHora( cTerIniAlm, "cTerIniAlm" )
  @ 13,46 get cTerTerAlm            pict '99:99'     valid ValidHora( cTerTerAlm, "cTerTerAlm" )
  @ 13,55 get cTerTerTur            pict '99:99'     valid ValidHora( cTerTerTur, "cTerTerTur" )
  @ 14,29 get cQuaIniTur            pict '99:99'     valid ValidHora( cQuaIniTur, "cQuaIniTur" )
  @ 14,37 get cQuaIniAlm            pict '99:99'     valid ValidHora( cQuaIniAlm, "cQuaIniAlm" )
  @ 14,46 get cQuaTerAlm            pict '99:99'     valid ValidHora( cQuaTerAlm, "cQuaTerAlm" )
  @ 14,55 get cQuaTerTur            pict '99:99'     valid ValidHora( cQuaTerTur, "cQuaTerTur" )
  @ 15,29 get cQuiIniTur            pict '99:99'     valid ValidHora( cQuiIniTur, "cQuiIniTur" )
  @ 15,37 get cQuiIniAlm            pict '99:99'     valid ValidHora( cQuiIniAlm, "cQuiIniAlm" )
  @ 15,46 get cQuiTerAlm            pict '99:99'     valid ValidHora( cQuiTerAlm, "cQuiTerAlm" )
  @ 15,55 get cQuiTerTur            pict '99:99'     valid ValidHora( cQuiTerTur, "cQuiTerTur" )
  @ 16,29 get cSexIniTur            pict '99:99'     valid ValidHora( cSexIniTur, "cSexIniTur" )
  @ 16,37 get cSexIniAlm            pict '99:99'     valid ValidHora( cSexIniAlm, "cSexIniAlm" )
  @ 16,46 get cSexTerAlm            pict '99:99'     valid ValidHora( cSexTerAlm, "cSexTerAlm" )
  @ 16,55 get cSexTerTur            pict '99:99'     valid ValidHora( cSexTerTur, "cSexTerTur" )
  @ 17,29 get cSabIniTur            pict '99:99'     valid ValidHora( cSabIniTur, "cSabIniTur" )
  @ 17,37 get cSabIniAlm            pict '99:99'     valid ValidHora( cSabIniAlm, "cSabIniAlm" )
  @ 17,46 get cSabTerAlm            pict '99:99'     valid ValidHora( cSabTerAlm, "cSabTerAlm" )
  @ 17,55 get cSabTerTur            pict '99:99'     valid ValidHora( cSabTerTur, "cSabTerTur" )
  read     
  
  set key K_ALT_H to
  
  restscreen( 00, 00, 23, 79, tHH )
return NIL

//
// Imprime Dados do Vendedor
//
function PrinRepr ( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "ReprARQ", .t. )
      VerifIND( "ReprARQ" )

      #ifdef DBF_NTX
        set index to ReprIND1, ReprIND2
      #endif
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 06, 25, 10, 51, mensagem( 'Janela', 'PrinRepr', .f. ), .f. )

  setcolor ( Corjanel + ',' + CorCampo )
  @ 08,27 say 'Vendedor Inicial'
  @ 09,27 say '  Vendedor Final'

  select ReprARQ
  set order  to 1
  dbgotop ()
  nReprIni := val( Repr )
  dbgobottom ()
  nReprFin := val( Repr )

  @ 08,44 get nReprIni        pict '999999'       valid ValidARQ( 99, 99, "ReprARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprIni", .t., 6, "Consulta de Vendedores", "ReprARQ", 40 )  
  @ 09,44 get nReprFin        pict '999999'       valid ValidARQ( 99, 99, "ReprARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprFin", .t., 6, "Consulta de Vendedores", "ReprARQ", 40 ) .and. nReprFin >= nReprIni 
  read

  if lastkey() == K_ESC

    select ReprARQ
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
  
  nPag   := 1
  nLin   := 0
  cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

  cReprIni := strzero( nReprIni, 6 )
  cReprFin := strzero( nReprFin, 6 )
  lInicio  := .t.
  
  select ReprARQ
  set order to 1
  dbseek( cReprIni, .t. )
  do while Repr >= cReprIni .and. Repr <= cReprFin .and. !eof()
    if lInicio 
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
      
      lInicio := .f.
    endif  
      
    if nLin == 0
      Cabecalho( 'Vendedores', 80, 3 )
      CabRepr()
    endif
      
    @ nLin, 00 say Repr     pict '999999'
    @ nLin, 08 say Nome
    @ nLin, 50 say Fone     
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
      replace Titu       with "Relatório de Vendedores"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif  
    close
  endif
 

  select ReprARQ
  if lAbrir
    close
  else  
    set order  to 1 
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabRepr ()
  @ 02, 00 say 'Cod'
  @ 02, 08 say 'Nome'
  @ 02, 50 say 'Telefone'
  nLin := 04
return NIL

//
// Comissão dos Vendedores
//
function PrinComi()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "NSaiARQ", .t. )
    VerifIND( "NSaiARQ" )

    #ifdef DBF_NTX
      set index to NSaiIND1, NSaiIND2, NSaiIND3, NSaiIND4
    #endif
  endif

  if NetUse( "INSaARQ", .t. )
    VerifIND( "INSaARQ" )

    #ifdef DBF_NTX
      set index to INSaIND1
    #endif
  endif

  if NetUse( "PediARQ", .t. )
    VerifIND( "PediARQ" )

    #ifdef DBF_NTX
      set index to PediIND1, PediIND2, PediIND3
    #endif
  endif

  if NetUse( "IPedARQ", .t. )
    VerifIND( "IPedARQ" )

    #ifdef DBF_NTX
      set index to IPedIND1
    #endif
  endif

  if NetUse( "ValeARQ", .t. )
    VerifIND( "ValeARQ" )

    #ifdef DBF_NTX
      set index to ValeIND1, ValeIND2
    #endif
  endif

  if NetUse( "ReprARQ", .t. )
    VerifIND( "ReprARQ" )

    #ifdef DBF_NTX
      set index to ReprIND1, ReprIND2
    #endif
  endif

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )

    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2
    #endif
  endif

  if NetUse( "CondARQ", .t. )
    VerifIND( "CondARQ" )

    #ifdef DBF_NTX
      set index to CondIND1, CondIND2
    #endif
  endif

  if NetUse( "ReceARQ", .t. )
    VerifIND( "ReceARQ" )
  
    #ifdef DBF_NTX
      set index to ReceIND1, ReceIND2, ReceIND3, ReceIND4, ReceIND5, ReceIND6, ReceIND7, ReceIND8
    #endif
  endif

  tPrt := savescreen( 00, 00, 23, 79 )
  
  if EmprARQ->Comissao == 2
    Janela ( 05, 13, 13, 71, mensagem( 'Janela', 'PrinComi', .f. ), .f.)

    setcolor ( CorJanel + ',' + CorCampo )
    @ 07,15 say ' Emissão Inicial            Emissão Final'
    @ 08,15 say '   Vcto. Inicial              Vcto. Final'
    @ 09,15 say '   Pgto. Inicial              Pgto. Final'
    @ 10,15 say 'Vendedor Inicial           Vendedor Final'
    @ 12,15 say '       Comissões  Liberadas   Pedentes   Ambas '
  
    setcolor( CorCampo )
    @ 12,32 say ' Liberadas '
    @ 12,44 say ' Pedentes '
    @ 12,55 say ' Ambas '
  
    setcolor( CorAltKC )
    @ 12,33 say 'L'
    @ 12,45 say 'P'
    @ 12,56 say 'A'
  else  
    Janela ( 07, 13, 13, 68, mensagem( 'Janela', 'PrinComi', .f. ), .f.)

    setcolor ( CorJanel + ',' + CorCampo )
    @ 09,15 say ' Emissão Inicial            Emissão Final'
    @ 10,15 say 'Vendedor Inicial           Vendedor Final'
    @ 12,15 say '        Comissão'
  
    setcolor( CorCampo )
    @ 12,32 say ' Pedido '
    @ 12,41 say ' Nota '
    @ 12,48 say ' Ambos '
  
    setcolor( CorAltKC )
    @ 12,33 say 'P'
    @ 12,42 say 'N'
    @ 12,49 say 'A'
  endif  

  select ReprARQ
  set order to 1
  dbgotop ()
  nReprIni := val( Repr )
  dbgobottom ()
  nReprFin := val( Repr )

  select ReceARQ
  set order to 1
  dbgotop ()
  dDataIni := ctod('01/01/1990')
  dDataFin := ctod('31/12/2015')
  dVctoIni := ctod('01/01/1990')
  dVctoFin := ctod('31/12/2015')
  dPgtoIni := ctod('  /  /    ')
  dPgtoFin := ctod('  /  /    ')
  nTipo    := 3
  aOpcoes  := {}
 
  if EmprARQ->Comissao == 1
    @ 09,32 get dDataIni   pict '99/99/9999'
    @ 09,57 get dDataFin   pict '99/99/9999'   valid dDataFin >= dDataIni
    @ 10,32 get nReprIni   pict '999999'       valid ValidARQ( 99, 99, "ReprARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprIni", .t., 6, "Consulta de Vendedores", "ReprARQ", 40 )  
    @ 10,57 get nReprFin   pict '999999'       valid ValidARQ( 99, 99, "ReprARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprFin", .t., 6, "Consulta de Vendedores", "ReprARQ", 40 ) .and. nReprFin >= nReprIni 
  else
    @ 07,32 get dDataIni   pict '99/99/9999'
    @ 07,57 get dDataFin   pict '99/99/9999'   valid dDataFin >= dDataIni
    @ 08,32 get dVctoIni   pict '99/99/9999'
    @ 08,57 get dVctoFin   pict '99/99/9999'   valid dVctoFin >= dVctoIni
    @ 09,32 get dPgtoIni   pict '99/99/9999'
    @ 09,57 get dPgtoFin   pict '99/99/9999'   valid dPgtoFin >= dPgtoIni
    @ 10,32 get nReprIni   pict '999999'       valid ValidARQ( 99, 99, "ReprARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprIni", .t., 6, "Consulta de Vendedores", "ReprARQ", 40 )  
    @ 10,57 get nReprFin   pict '999999'       valid ValidARQ( 99, 99, "ReprARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprFin", .t., 6, "Consulta de Vendedores", "ReprARQ", 40 ) .and. nReprFin >= nReprIni 
  endif  
  read

  if lastkey() == K_ESC
    select NSaiARQ
    close
    select INSaARQ
    close
    select PediARQ
    close
    select IPedARQ
    close
    select ReprARQ
    close
    select ClieARQ
    close
    select CondARQ
    close
    select ReceARQ
    close
    select ValeARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  if EmprARQ->Comissao == 2
    aadd( aOpcoes, { ' Liberadas ', 2, 'S', 12, 32, "Relatório das Comissões Liberadas" } )
    aadd( aOpcoes, { ' Pedentes ',  2, 'N', 12, 44, "Relatório das Comissões Pedentes" } )
    aadd( aOpcoes, { ' Ambas ',     2, 'A', 12, 55, "Relatório das Comissões" } )
    
    if !empty( dPgtoIni )
      nTipo := 1
    endif
     
    nTipo := HCHOICE( aOpcoes, 3, nTipo )
  else
    aadd( aOpcoes, { ' Pedido ', 2, 'P', 12, 32, "Relatório das Comissões geradas por Pedidos" } )
    aadd( aOpcoes, { ' Nota ', 2, 'N', 12, 41, "Relatório das Comissões geradas por Notas" } )
    aadd( aOpcoes, { ' Ambos ', 2, 'A', 12, 48, "Relatório das Comissões" } )
   
    nTipo := HCHOICE( aOpcoes, 3, nTipo )
  endif  

  if lastkey() == K_ESC
    select NSaiARQ
    close
    select INSaARQ
    close
    select PediARQ
    close
    select IPedARQ
    close
    select ReprARQ
    close
    select ClieARQ
    close
    select CondARQ
    close
    select ReceARQ
    close
    select ValeARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  Aguarde ()
  
  nPag        := 1
  nLin        := 0
  cArqu2      := cArqu2 + "." + strzero( nPag, 3 )

  cReprIni    := strzero( nReprIni, 6 )
  cReprFin    := strzero( nReprFin, 6 )

  cReprAnt    := space(06)
  nTotalGeral := nTotalComi := 0
  nComiPeden  := nComiLiber := 0
  lInicio     := .t.

  select CondARQ
  set order to 1
  
  select ClieARQ
  set order to 1
  
  select ReprARQ
  set order to 1
    
  if EmprARQ->Comissao == 1
    if nTipo == 3
      aComissao := {}
         
      select PediARQ
      set order    to 3
      set relation to Clie into ClieARQ, to Repr into ReprARQ, to Cond into CondARQ
      dbseek( cReprIni, .t. )
      do while Repr >= cReprIni .and. Repr <= cReprFin .and. !eof ()
        if Emis >= dDataIni .and. Emis <= dDataFin
          aadd( aComissao, { Nota, Pedido, ClieARQ->Nome, Emis, CondARQ->Nome,;
                             TotalNota, Desconto, ( ( TotalNota - Desconto ) * ReprARQ->Perc ) / 100, Repr, ReprARQ->Nome } ) 
        endif                        
        dbskip ()
      enddo                     

      select NSaiARQ
      set order    to 3
      set relation to Clie into ClieARQ, to Repr into ReprARQ, to Cond into CondARQ
      dbseek( cReprIni, .t. )
      do while Repr >= cReprIni .and. Repr <= cReprFin .and. !eof ()
        if Emis >= dDataIni .and. Emis <= dDataFin 
          oJuros     := ( CondARQ->Acrs * ( SubTotal - Desconto ) ) / 100
          oTotalNota := ( SubTotal - Desconto ) + oJuros  
          
          if ReprARQ->PerC > 0
            nComissao := ( ( SubTotal - Desconto ) * ReprARQ->PerC ) / 100
          else
            nComissao := 0
            
            select INSaARQ
            set order to 1
            dbseek( NSaiARQ->Nota, .t. )
            do while Nota == NSaiARQ->Nota .and. !eof()
              nComissao += ( ( ( PrecoVenda * Qtde ) * Comi ) / 100 )
              
              dbskip()
            enddo
            
            select NSaiARQ
          endif
          
          aadd( aComissao, { 0, Nota, iif( Clie == '999999', Cliente, ClieARQ->Nome ), Emis, CondARQ->Nome,;
                             oTotalNota, Desconto, nComissao, Repr, ReprARQ->Nome } ) 
        endif                   
        dbskip ()
      enddo                     
      asort( aComissao,,, { | Repr01, Repr02 | Repr01[8] < Repr02[8] } )
    endif  
    
    do case
      case nTipo == 1  
        select NSaiARQ
        set order    to 3
        set relation to Clie into ClieARQ, to Repr into ReprARQ, to Cond into CondARQ
        dbseek( cReprIni, .t. )
        do while Repr >= cReprIni .and. Repr <= cReprFin .and. !eof ()
          if Emis >= dDataIni .and. Emis <= dDataFin 
            if lInicio 
              set printer to ( cArqu2 )
              set device  to printer
              set printer on
    
              lInicio := .f.
            endif  

            if nLin == 0
              Cabecalho ( 'Comissoes - Pedidos', 132, 3 )
              CabComi()
            endif
 
            if Repr != cReprAnt
              if cReprAnt != space(06)
                nLin ++
                @ nLin,072 say 'Total Geral:'
                @ nLin,099 say nTotalGeral      pict '@E 999,999.99'
                @ nLin,110 say nComiLiber       pict '@E 999,999.99'
                nLin ++
 
                nTotalGeral := 0
                nComiLiber  := 0
              endif

              cReprAnt := Repr
   
              @ nLin,01 say Repr          pict '999999'
              @ nLin,08 say ReprARQ->Nome
              nLin ++
            endif

            nTotalNota := SubTotal - Desconto
            nComissao  := ( nTotalNota * ReprARQ->PerC ) / 100 
          
            if ReprARQ->PerC > 0
              nComissao := ( ( SubTotal - Desconto ) * ReprARQ->PerC ) / 100
            else
              nComissao := 0
            
              select INSaARQ
              set order to 1
              dbseek( NSaiARQ->Nota, .t. )
              do while Nota == NSaiARQ->Nota .and. !eof()
                nComissao += ( ( ( PrecoVenda * Qtde ) * Comi ) / 100 )
              
                dbskip()
              enddo
            
              select NSaiARQ
            endif

            @ nLin,006 say '     0'
            @ nLin,013 say Nota             pict '999999'
            if Clie == '999999'
              @ nLin,022 say Cliente        pict '@S28'
            else  
              @ nLin,022 say ClieARQ->Nome  pict '@S28'
            endif  
            @ nLin,051 say Emis             pict '99/99/9999'
            @ nLin,062 say CondARQ->Nome    pict '@S8'
            @ nLin,077 say SubTotal         pict '@E 999,999.99'
            @ nLin,088 say Desconto         pict '@E 999,999.99'
            @ nLin,099 say nTotalNota       pict '@E 999,999.99'
            @ nLin,110 say nComissao        pict '@E 999,999.99'
 
            nComiLiber  += nComissao
            nTotalGeral += nTotalNota
 
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
      case nTipo == 2  
        select PediARQ
        set order    to 3
        set relation to Clie into ClieARQ, to Repr into ReprARQ, to Cond into CondARQ
        dbseek( cReprIni, .t. )
        do while Repr >= cReprIni .and. Repr <= cReprFin .and. !eof ()
          if Emis >= dDataIni .and. Emis <= dDataFin
            if lInicio 
              set printer to ( cArqu2 )
              set device  to printer
              set printer on
    
              lInicio := .f.
            endif  
            
            if nLin == 0
              Cabecalho ( 'Comissoes - Notas', 132, 3 )
              CabComi()
            endif

            if Repr != cReprAnt
              if cReprAnt != space(06)
                nLin ++
                @ nLin,072 say 'Total Geral:'
                @ nLin,099 say nTotalGeral      pict '@E 999,999.99'
                @ nLin,110 say nComiLiber       pict '@E 999,999.99'
                nLin ++

                nTotalGeral := 0
                nComiLiber  := 0
              endif
  
              cReprAnt := Repr

              @ nLin,01 say Repr          pict '999999'
              @ nLin,08 say ReprARQ->Nome
              nLin ++
            endif
            
            nComissao := ( ( TotalNota - Desconto ) * ReprARQ->PerC ) / 100

            @ nLin,006 say Nota           pict '999999'
            @ nLin,013 say Pedido         pict '999999'
            if Clie == '999999'
              @ nLin,020 say Cliente      pict '@S29'
            else  
              @ nLin,020 say ClieARQ->Nome  pict '@S29'
            endif  
            @ nLin,051 say Emis           pict '99/99/9999'
            @ nLin,062 say CondARQ->Nome  pict '@S8'

            @ nLin,077 say TotalNota        pict '@E 999,999.99'
            @ nLin,088 say Desconto         pict '@E 999,999.99'
            @ nLin,099 say TotalNota - Desconto       pict '@E 999,999.99'
            @ nLin,110 say nComissao        pict '@E 999,999.99'

            nComiLiber  += nComissao
            nTotalGeral += ( TotalNota - Desconto )

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
      case nTipo == 3
        for nJ := 1 to len( aComissao )
          cNota      := aComissao[ nJ, 1 ] 
          cPedido    := aComissao[ nJ, 2 ] 
          cNomeClie  := aComissao[ nJ, 3 ] 
          dEmis      := aComissao[ nJ, 4 ] 
          cNomeCond  := aComissao[ nJ, 5 ] 
          nTotalNota := aComissao[ nJ, 6 ] 
          nDesconto  := aComissao[ nJ, 7 ] 
          nComissao  := aComissao[ nJ, 8 ] 
          cRepr      := aComissao[ nJ, 9 ] 
          cNomeRepr  := aComissao[ nJ, 10 ] 
        
          if lInicio 
            set printer to ( cArqu2 )
            set device  to printer
            set printer on
    
            lInicio := .f.
          endif  

          if nLin == 0
            Cabecalho ( 'Comissoes - Pedidos/Notas', 132, 3 )
            CabComi()
          endif

          if cRepr != cReprAnt
            if cReprAnt != space(06)
              nLin ++
              @ nLin,052 say 'Total Geral:'
              @ nLin,072 say nTotalGeral      pict '@E 999,999,999.99'
              @ nLin,093 say nComiLiber       pict '@E 999,999,999.99'
              nLin ++
 
              nTotalGeral := 0
              nComiLiber  := 0
            endif

            cReprAnt := cRepr

            @ nLin,01 say cRepr          pict '999999'
            @ nLin,08 say cNomeRepr
            nLin ++
          endif

          @ nLin,006 say cNota           pict '999999'  
          @ nLin,013 say cPedido         pict '999999'
          @ nLin,020 say cNomeClie       pict '@S29'
          @ nLin,051 say dEmis           pict '99/99/9999'
          @ nLin,062 say cNomeCond       pict '@S8'

          @ nLin,077 say nTotalNota + nDesconto       pict '@E 999,999.99'
          @ nLin,088 say nDesconto                    pict '@E 999,999.99'
          @ nLin,099 say nTotalNota - nDesconto       pict '@E 999,999.99'
          @ nLin,110 say nComissao                    pict '@E 999,999.99'

          nComiLiber  += nComissao
          nTotalGeral += nTotalNota

          nLin ++

          if nLin >= pLimite
            Rodape(132)

            cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
            cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

            set printer to ( cArqu2 )
            set printer on
          endif
        next  
    endcase      

    if ( nLin + 4 ) >= pLimite
      Rodape(132)

      cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
      cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

      set printer to ( cArqu2 )
      set printer on

      do case
        case nTipo == 1
          Cabecalho ( 'Comissoes - Pedidos', 132, 3 )
        case nTipo == 2
          Cabecalho ( 'Comissoes - Notas', 132, 3 )
        case nTipo == 3
          Cabecalho ( 'Comissoes - Pedidos/Notas', 132, 3 )
      endcase
      CabComi ()
    endif
    
    if !lInicio 
      nTotalVale := 0
      
      select ValeARQ
      set order to 2
      dbseek( cReprAnt, .t. )
      do while Repr == cReprAnt .and. !eof()
        if Data >= dDataIni .and. Data <= dDataFin
          nTotalVale += Valor  
        endif 
        dbskip()
      enddo  
      
      if nTotalVale > 0
        nLin ++
        @ nLin,072 say 'Total Vales:'
        @ nLin,099 say nTotalVale       pict '@E 999,999.99'
      endif
      nLin ++
      @ nLin,072 say 'Total Geral:'
      @ nLin,099 say nTotalGeral      pict '@E 999,999.99'
      @ nLin,110 say nComiLiber       pict '@E 999,999.99'
      Rodape (132)
    endif  
  else
    select ReceARQ
    set order    to 6
    set relation to Clie into ClieARQ, to Repr into ReprARQ
    dbseek( cReprIni, .t. )
    do while Repr >= cReprIni .and. Repr <= cReprFin .and. !eof ()
      do case
        case nTipo == 1
         if Emis >= dDataIni .and. Emis <= dDataFin .and.;
            Vcto >= dVctoIni .and. Vcto <= dVctoFin .and.;
            Pgto >= dPgtoIni .and. Pgto <= dPgtoFin
          else  
            dbskip()
            loop
          endif
        case nTipo == 2
          if Emis >= dDataIni .and. Emis <= dDataFin .and.;
             Vcto >= dVctoIni .and. Vcto <= dVctoFin .and.;
             empty( Pgto )
          else  
            dbskip()
            loop
          endif  
        case nTipo == 3
          if Emis >= dDataIni .and. Emis <= dDataFin .and.;
             Vcto >= dVctoIni .and. Vcto <= dVctoFin
          else
            dbskip()
            loop
          endif  
      endcase
      
      if !empty( MarcRepr )
        dbskip()
        loop
      endif  
      
      if lInicio 
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
    
        lInicio := .f.
      endif  
  
      if nLin == 0
        Cabecalho ( 'Comissoes - Contas a Receber', 132, 3 )
        CabComi ()
      endif

      if Repr != cReprAnt
        if cReprAnt != space(04)
          if ( nLin + 5 ) >= pLimite
            Rodape(132)

            cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
            cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

            set printer to ( cArqu2 )
            set printer on

            Cabecalho ( 'Comissoes - Contas a Receber', 132, 3 )
            CabComi ()

            @ nLin,01 say cReprAnt          pict '999999'
            @ nLin,07 say cNomeAnt
          endif  
        
          nLin ++
          @ nLin,082 say 'Total Geral Notas'
          @ nLin,109 say nTotalGeral      pict '@E 999,999,999.99'
          nLin += 2
          if nComiLiber > 0
            @ nLin,075 say 'Total Comissoes Liberada'
            @ nLin,109 say nComiLiber       pict '@E 999,999,999.99'
          endif  
          nLin ++
          if nComiPeden > 0
            @ nLin,076 say 'Total Comissoes Pedente'
            @ nLin,109 say nComiPeden       pict '@E 999,999,999.99'
          endif  
          nLin ++
          nComiPeden := nComiLeber := nTotalGeral := 0
        endif

        cReprAnt := Repr
        cNomeAnt := ReprARQ->Nome

        @ nLin,01 say Repr          pict '999999'
        @ nLin,08 say ReprARQ->Nome
        nLin ++
      endif  
    
      @ nLin,006 say val( Nota )    pict '999999-99' 
      @ nLin,016 say iif( Tipo == 'P', 'Pedido', 'Nota' )
      if Clie == '999999'
        @ nLin,023 say Cliente           pict '@S28'
      else  
        @ nLin,023 say ClieARQ->Nome     pict '@S28'
      endif  
      @ nLin,052 say Clie 
      @ nLin,059 say Emis           pict '99/99/9999'
      @ nLin,070 say Vcto           pict '99/99/9999'

      if !empty( Pgto )
        @ nLin,081 say Pgto         pict '99/99/9999'
 
        @ nLin,092 say 'Liberada'

        nComiLiber += ReprComi
      else
        @ nLin,081 say '__/__/____'

        @ nLin,092 say 'Pedente'

        nComiPeden += ReprComi
      endif

      @ nLin,101 say Valor          pict '@E 999,999.99'
      @ nLin,112 say ReprComi       pict '@E 999,999.99' 
   
      nTotalGeral += Valor

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

    if ( nLin + 4 ) >= pLimite
      Rodape(132)

      cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
      cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

      set printer to ( cArqu2 )
      set printer on

      Cabecalho ( 'Comissoes - Contas a Receber', 132, 3 )
      CabComi ()

      @ nLin,01 say cReprAnt          pict '9999'
      @ nLin,06 say cNomeAnt
    endif  
    
    if !lInicio       
      nLin ++
      @ nLin,082 say 'Total Geral Notas'
      @ nLin,109 say nTotalGeral      pict '@E 999,999,999.99'
      nLin += 2
      if nComiLiber > 0
        @ nLin,075 say 'Total Comissoes Liberada'
        @ nLin,109 say nComiLiber       pict '@E 999,999,999.99'
      endif  
      nLin ++
      if nComiPeden > 0
        @ nLin,076 say 'Total Comissoes Pedente' 
        @ nLin,109 say nComiPeden       pict '@E 999,999,999.99'
      endif  
    
      Rodape(132)
    endif  
  endif  
  
  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 132 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      if EmprARQ->Comissao == 1
        replace Titu     with "Relatório de Comissão dos Repr. - Nota/Pedido"
      else  
        replace Titu     with "Relatório de Comissão dos Repr. - Receber"
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

  select ReprARQ
  close
  select ClieARQ
  close
  select CondARQ
  close
  select ReceARQ
  close
  select PediARQ
  close
  select IPedARQ
  close
  select NSaiARQ
  close
  select INSaARQ
  close
  select ValeARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabComi ()
  @ 02,001 say 'Periodo ' + dtoc( dDataIni )  + ' a ' + dtoc( dDataFin )
  @ 03,001 say 'Vendedor'
  if EmprARQ->Comissao == 1
    @ 04,08 say 'Nota Pedido Cliente                         Emissão   Cond. Pgto       SubTotal   Desconto  TotalNota   Comissão'
  else  
    @ 04,06 say 'Nota      Tipo   Cliente                             Emissão         Vcto.      Pgto. Situação      Valor   Comissão'      
  endif
  nLin     := 06
  cReprAnt := space(06)
return NIL

//
// Corrige as Comissoes 
//
function ValidComi()
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
  
  if ConfAlte()
    select ReceARQ
    set order    to 1
    set relation to Repr into ReprARQ
    dbgotop()
    do while !eof()
      if ReprComi == 0
        nReprComi := ( Valor * ReprARQ->PerC ) / 100 
        
        if RegLock()
          replace ReprComi       with nReprComi
          dbunlock()
        endif  
      endif
        
      dbskip()
    enddo
  endif
  
  select ReceARQ
  close
  select ReprARQ
  close
return NIL

//
//  Consulta de Comissao Contas a Receber 
//
function ConsComi ()

  local cCorAtual := setcolor()
  local aArqui    := {}
  
  cReceARQ  := CriaTemp(0)
  cReceIND1 := CriaTemp(1)

      aadd( aArqui, { "Nota",     "C", 08, 0 } )
      aadd( aArqui, { "Tipo",     "C", 01, 0 } )
      aadd( aArqui, { "Clie",     "C", 06, 0 } )
      aadd( aArqui, { "Cliente",  "C", 40, 0 } )
      aadd( aArqui, { "Emis",     "D", 08, 0 } )
      aadd( aArqui, { "Vcto",     "D", 08, 0 } )
      aadd( aArqui, { "Pgto",     "D", 08, 0 } )
      aadd( aArqui, { "Dest",     "C", 15, 0 } )
      aadd( aArqui, { "TipoVcto", "C", 15, 0 } )
      aadd( aArqui, { "Valor",    "N", 12, 2 } )
      aadd( aArqui, { "Acre",     "N", 06, 2 } )
      aadd( aArqui, { "Desc",     "N", 12, 2 } )
      aadd( aArqui, { "Juro",     "N", 12, 2 } )
      aadd( aArqui, { "Pago",     "N", 12, 2 } )
      aadd( aArqui, { "Port",     "C", 06, 0 } )
      aadd( aArqui, { "Repr",     "C", 06, 0 } )
      aadd( aArqui, { "Cobr",     "C", 04, 0 } )
      aadd( aArqui, { "ReprPaga", "C", 01, 0 } )
      aadd( aArqui, { "MarcRepr", "C", 01, 0 } )
      aadd( aArqui, { "ReprComi", "N", 12, 2 } )
      aadd( aArqui, { "Marc",     "C", 01, 0 } )

  dbcreate( cReceARQ, aArqui )
   
if NetUse( cReceARQ, .f., 30 )
  cReceTMP := alias ()
  cChave   := "dtos( Vcto )"
    
  index on &cChave to &cReceIND1

  #ifdef DBF_NTX
    set index to &cReceIND1
  #endif
endif

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )
  
    tOpenClie := .t.
  
    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
    #endif
  else  
    tOpenClie := .f.
  endif
  
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
  
  nRepr       := 0
  cRepr       := space(04)  
  rTotalGeral := 0
  rTotalComis := rTotalPaga  := 0
  dVctoIni    := ctod( '01/01/1990' )
  dVctoFin    := ctod( '31/12/2010' )
  dData       := dtos( ctod('  /  /  ' ) ) 
  tTelaRcto   := savescreen( 00, 00, 23, 79 )
  lCalcJuro   := .t.
  
  if EmprARQ->Periodo == "X"                  
    Janela( 09, 24, 13, 50, mensagem( 'Janela', 'Periodo', .f. ), .f. )
    Mensagem( 'LEVE', 'Periodo' )

    setcolor( CorJanel )
    @ 11,26 say 'Vcto. Inicial'
    @ 12,26 say '  Vcto. Final'
  
    @ 11,40 get dVctoIni      pict '99/99/9999'
    @ 12,40 get dVctoFin      pict '99/99/9999' valid dVctoFin >= dVctoIni
    read
    
    if lastkey() == K_ESC
      if tOpenRece 
        select ReceARQ
        close
      endif  
  
      if tOpenRepr 
        select ReprARQ
        close
      endif  
  
      if tOpenClie 
        select ClieARQ
        close
      endif  
    
      restscreen( 00, 00, 23, 79, tTelaRcto )
      return NIL
    endif  
  endif  

  Janela ( 03, 01, 20, 76, mensagem( 'Janela', 'ConsComi', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )
  @ 07,004 say 'Nota     Tipo   Emis.      Vcto.      Pgto.      Total      Comissão'
  @ 08,001 say chr(195) + replicate( chr(196), 74 ) + chr(180)
  @ 08,003 say chr(194)
  @ 08,012 say chr(194)
  @ 08,019 say chr(194)
  @ 08,030 say chr(194)
  @ 08,041 say chr(194)
  @ 08,052 say chr(194)
  @ 08,063 say chr(194)
  for nLin := 9 to 17
    @ nLin,003 say chr(179)
    @ nLin,012 say chr(179)
    @ nLin,019 say chr(179)
    @ nLin,030 say chr(179)
    @ nLin,041 say chr(179)
    @ nLin,052 say chr(179)
    @ nLin,063 say chr(179)
  next
  @ 18,001 say chr(195) + replicate( chr(196), 74 ) + chr(180)
  @ 18,003 say chr(193)
  @ 18,012 say chr(193)
  @ 18,019 say chr(193)
  @ 18,030 say chr(193)
  @ 18,041 say chr(193)
  @ 18,052 say chr(193)
  @ 18,063 say chr(193)
  @ 05,009 say 'Vendedor'
  @ 19,005 say 'Comissão Paga'
  @ 19,040 say 'Total Geral'
   
  setcolor( CorCampo )
  @ 05,25 say space(40)
  @ 19,19 say rTotalPaga                 pict '@E 999,999.99'
  @ 19,54 say rTotalGeral                pict '@E 999,999.99'
  @ 19,65 say rTotalComis                pict '@E 999,999.99'
  
  setcolor( CorJanel + ',' + CorCampo )
  @ 05,18 get nRepr     pict '999999'    valid ValidARQ( 05, 18, "ReceARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nRepr", .t., 6, "Vendedores", "ReprARQ", 40 )
  read
  
  cRepr := strzero( nRepr, 6 )
  
  if lastkey() == K_ESC
    if tOpenRece 
      select ReceARQ
      close
    endif  
  
    if tOpenRepr 
      select ReprARQ
      close
    endif  
  
    if tOpenClie
      select ClieARQ
      close
    endif  
    
    restscreen( 00, 00, 23, 79, tTelaRcto )
    return NIL
  endif  
  
  select( cReceTMP )
  set order    to 1
  set relation to Clie into ClieARQ

  select ReceARQ
  set order to 6
  dbseek( cRepr, .t. )
  do while Repr == cRepr .and. !eof ()
    if Vcto >= dVctoIni .and. Vcto <= dVctoFin .and. empty( MarcRepr )
      select( cReceTMP )
      if AdiReg()
        if RegLock()
          replace Nota        with ReceARQ->Nota
          replace Tipo        with ReceARQ->Tipo
          replace Clie        with ReceARQ->Clie
          replace Cliente     with ReceARQ->Cliente
          replace Emis        with ReceARQ->Emis
          replace Vcto        with ReceARQ->Vcto
          replace Valor       with ReceARQ->Valor
          replace Acre        with ReceARQ->Acre
          replace Desc        with ReceARQ->Desc
          replace Port        with ReceARQ->Port
          replace Repr        with ReceARQ->Repr
          replace Cobr        with ReceARQ->Cobr
          replace Dest        with ReceARQ->Dest
          replace TipoVcto    with ReceARQ->TipoVcto
          replace ReprComi    with ReceARQ->ReprComi
          dbunlock ()
        endif
      endif

      rTotalGeral += ( ( Valor - Desc ) + VerJuro() )
      rTotalComis += ( ReprComi ) 

      select ReceARQ
    endif  
    dbskip()
  enddo     
  
  select( cReceTMP )
  set order to 1
  set relation to Repr into ReprARQ, to Clie into ClieARQ
  bFirst := {|| .t. }
  bLast  := {|| .t. }
  bWhile := {|| .t. }
  bFor   := {|| .t. }
  
  oReceber          := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oReceber:nTop     := 7
  oReceber:nLeft    := 2
  oReceber:nBottom  := 18
  oReceber:nRight   := 75
  oReceber:headsep  := chr(194)+chr(196)
  oReceber:colsep   := chr(179)
  oReceber:footsep  := chr(193)+chr(196)

  oReceber:addColumn( TBColumnNew(" ",        {|| MarcRepr } ) )
  oReceber:addColumn( TBColumnNew("Nota",     {|| transform( val( Nota ), '999999-99' ) } ) )
  oReceber:addColumn( TBColumnNew("Tipo",     {|| iif( Tipo == 'P', 'Pedido  ', iif( Tipo == 'N', 'Nota   ','O.S.   ' ) ) } ) )
  oReceber:addColumn( TBColumnNew("Emis.",    {|| Emis } ) )
  oReceber:addColumn( TBColumnNew("Vcto.",    {|| Vcto } ) )
  oReceber:addColumn( TBColumnNew("Pgto.",    {|| Pgto } ) )
  oReceber:addColumn( TBColumnNew("Total",    {|| transform( VerTotal(), '@E 999,999.99' ) } ) )
  oReceber:addColumn( TBColumnNew("Comissão", {|| transform( ReprComi, '@E 99,999.99' ) } ) )
              
  lAdiciona      := .f.
  lMais          := .t.
  lExitRequested := .f.
  nLinBarra      := 1
  cSequ          := space(2)
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 8, 18, 76, nTotal )
  
  setcolor( CorCampo )
  @ 19,19 say rTotalPaga                 pict '@E 999,999.99'
  @ 19,54 say rTotalGeral                pict '@E 999,999.99'
  @ 19,65 say rTotalComis                pict '@E 999,999.99'

  dbgotop()
    
  oReceber:gotop()
  oReceber:refreshAll()

  do while !lExitRequested
    Mensagem( 'Repr', 'ConsComi' )
    
    oReceber:forcestable() 
    
    PosiDBF( 03, 76 )

    iif( BarraSeta, BarraSeta( nLinBarra, 8, 18, 76, nTotal ), NIL )
    
    if oReceber:stable
      if lMais
        do while .t.
          oReceber:down()
          oReceber:forcestable() 
          
          if oReceber:hitBottom
            lMais := .f.
            exit
          endif
        enddo    
      endif
      if oReceber:hitTop .or. oReceber:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oReceber:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oReceber:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oReceber:down()
      case cTecla == K_UP;         oReceber:up()
      case cTecla == K_PGDN;       oReceber:pageDown()
      case cTecla == K_PGUP;       oReceber:pageUp()
      case cTecla == K_LEFT;       oReceber:left()
      case cTecla == K_RIGHT;      oReceber:right()
      case cTecla == K_CTRL_PGUP;  oReceber:goTop()
      case cTecla == K_CTRL_PGDN;  oReceber:gobottom()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_ALT_P
        tAlte := savescreen( 00, 00, 24, 79 )         
        Janela( 06, 20, 12, 55, mensagem( 'Janela', 'Atencao', .f. ), .t. )          
        setcolor( CorJanel )
        @ 08,22 say 'Vocˆ tem certeza que gostaria de'
        @ 09,22 say 'fazer o Pagamento Comissão ?'
           
        lVe := .t.   
           
        if ConfLine( 11, 43, 1 )
          select( cReceTMP )
          set order to 1
          dbgotop()
          do while !eof ()
              if !empty( MarcRepr )
              if lVe
                cRepre := ReprARQ->nome
                lve := .f.
              endif         
            
              select ReceARQ
              set order to 1
              dbseek( &cReceTMP->Nota + &cReceTMP->Tipo, .f. )
              if found()
                if RegLock()
                  replace MarcRepr        with "X"
                endif
                dbunlock()
              endif  

              select( cReceTMP )
              if RegLock()
                dbdelete()
                dbunlock()
              endif             
            endif
            dbskip()
          enddo    

          PrinRecibo( .f., 'comi' )
          
          rTotalGeral := 0
          rTotalComis := 0
          rTotalPaga  := 0

          select( cReceTMP )
          set order to 1
          dbgotop()
          do while !eof ()
            if Vcto >= dVctoIni .and. Vcto <= dVctoFin
              rTotalGeral += ( ( Valor - Desc ) + VerJuro() )
              rTotalComis += ( ReprComi ) 
   
              if !empty( MarcRepr )
                rTotalPaga  += ( ReprComi ) 
              endif  
            endif  
            dbskip()
          enddo

          restscreen( 00, 00, 24, 79, tAlte )
          
          dbgotop()          
          select( cReceTMP )
          oReceber:gotop()
          oReceber:refreshAll()
  
          setcolor( CorCampo )
          @ 19,19 say rTotalPaga                 pict '@E 999,999.99'
          @ 19,54 say rTotalGeral                pict '@E 999,999.99'
          @ 19,65 say rTotalComis                pict '@E 999,999.99'
        endif

      case cTecla == K_ALT_A;      tReceTela := savescreen( 00, 00, 22, 79 )
        Rece(.t.)

        rTotalGeral := rTotalPaga  := 0
        rTotalComis := 0

        restscreen( 00, 00, 22, 79, tReceTela )

        select ReceARQ
        set order to 6
        dbseek( cRepr, .t. )
    
        do while Repr == cRepr .and. !eof()
          rTotalComis += ( ReprComi )
          rTotalGeral += ( ( Valor - Desc ) + VerJuro() )
          
          if Marc == "X"
            rTotalPaga += ( ( ReprComi ) )
          endif
            
          dbskip ()
        enddo      

        setcolor( CorCampo )
        @ 19,19 say rTotalPaga                 pict '@E 999,999.99'
        @ 19,53 say rTotalGeral                pict '@E 999,999.99'
        @ 19,64 say rTotalComis                pict '@E 999,999.99'
        
        oReceber:gotop()           
        oReceber:refreshAll()

        lExitRequested := .f.
      case cTecla == K_SPACE
        if ReceARQ->MarcRepr == ' '
          rTotalPaga += ReprComi
        else  
          rTotalPaga -= ReprComi

          if rTotalPaga < 0
            rTotalPaga := 0
          endif  
        endif  

        if ReceARQ->MarcRepr == ' '
          if RegLock()
            replace MarcRepr      with "X"
          endif
        else    
          if RegLock()
            replace MarcRepr      with ' '
          endif    
        endif  
        dbunlock ()
        
        setcolor( CorCampo )
        @ 19,19 say rTotalPaga                  pict '@E 999,999.99'
        
        oReceber:refreshAll()
      case cTecla == K_ALT_F
        tSele := savescreen( 00, 00, 23, 79 )
        Janela( 09, 24, 13, 50, mensagem( 'Janela', 'Periodo', .f. ), .f. )
        Mensagem( 'LEVE', 'Periodo' )

        setcolor( CorJanel )
        @ 11,26 say 'Vcto. Inicial'
        @ 12,26 say '  Vcto. Final'
  
        @ 11,40 get dVctoIni      pict '99/99/9999'
        @ 12,40 get dVctoFin      pict '99/99/9999' valid dVctoFin >= dVctoIni
        read

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tSele )
          loop
        endif
        
        oReceber:gotop()
        oReceber:refreshAll()
        restscreen( 00, 00, 23, 79, tSele ) 
    endcase
    select( cReceTMP )
  enddo  
  
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
  
  if tOpenRece 
    select ReceARQ
    close
  endif  

  if tOpenRepr 
    select ReprARQ
    close
  endif  
    
  if tOpenClie
    select ClieARQ
    close
  endif  

  select( cReceTMP )
  ferase( cReceARQ )
  ferase( cReceIND1 )
  #ifdef DBF_CDX
    ferase( left( cReceARQ, len( cReceARQ ) - 3 ) + 'FPT' )
  #endif  
  #ifdef DBF_NTX
    ferase( left( cReceARQ, len( cReceARQ ) - 3 ) + 'DBT' )
  #endif  
    
  setcolor( cCorAtual )
  restscreen( 00, 00, 23, 79, tTelaRcto )
return NIL


//
//  Consulta de Comissao Contas a Receber 
//
function ConsCoPg ()

  local cCorAtual := setcolor()
  local aArqui    := {}
  
  cReceARQ  := CriaTemp(0)
  cReceIND1 := CriaTemp(1)

      aadd( aArqui, { "Nota",     "C", 08, 0 } )
      aadd( aArqui, { "Tipo",     "C", 01, 0 } )
      aadd( aArqui, { "Clie",     "C", 06, 0 } )
      aadd( aArqui, { "Cliente",  "C", 40, 0 } )
      aadd( aArqui, { "Emis",     "D", 08, 0 } )
      aadd( aArqui, { "Vcto",     "D", 08, 0 } )
      aadd( aArqui, { "Pgto",     "D", 08, 0 } )
      aadd( aArqui, { "Dest",     "C", 15, 0 } )
      aadd( aArqui, { "TipoVcto", "C", 15, 0 } )
      aadd( aArqui, { "Valor",    "N", 12, 2 } )
      aadd( aArqui, { "Acre",     "N", 06, 2 } )
      aadd( aArqui, { "Desc",     "N", 12, 2 } )
      aadd( aArqui, { "Juro",     "N", 12, 2 } )
      aadd( aArqui, { "Pago",     "N", 12, 2 } )
      aadd( aArqui, { "Port",     "C", 04, 0 } )
      aadd( aArqui, { "Repr",     "C", 06, 0 } )
      aadd( aArqui, { "Cobr",     "C", 06, 0 } )
      aadd( aArqui, { "ReprPaga", "C", 01, 0 } )
      aadd( aArqui, { "MarcRepr", "C", 01, 0 } )
      aadd( aArqui, { "ReprComi", "N", 12, 2 } )
      aadd( aArqui, { "Marc",     "C", 01, 0 } )

  dbcreate( cReceARQ, aArqui )
   
if NetUse( cReceARQ, .f. )
  cReceTMP := alias ()
  cChave   := "dtos( Vcto )"
    
  index on &cChave to &cReceIND1

  #ifdef DBF_NTX
    set index to &cReceIND1
  #endif
endif

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )

    tOpenClie := .t.
  
    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
    #endif
  else  
    tOpenClie := .f.
  endif
  
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
  
  nRepr       := 0
  cRepr       := space(04)  
  rTotalGeral := 0
  rTotalComis := rTotalPaga  := 0
  dVctoIni    := ctod( '01/01/1990' )
  dVctoFin    := ctod( '31/12/2010' )
  dData       := dtos( ctod('  /  /  ' ) ) 
  tTelaRcto   := savescreen( 00, 00, 23, 79 )
  lCalcJuro   := .t.
  
  if EmprARQ->Periodo == "X" 
    Janela( 09, 24, 13, 50, mensagem( 'Janela', 'Periodo', .f. ), .f. )
    Mensagem( 'LEVE', 'Periodo' )

    setcolor( CorJanel )
    @ 11,26 say 'Vcto. Inicial'
    @ 12,26 say '  Vcto. Final'
  
    @ 11,40 get dVctoIni      pict '99/99/9999'
    @ 12,40 get dVctoFin      pict '99/99/9999' valid dVctoFin >= dVctoIni
    read
    
    if lastkey() == K_ESC
      if tOpenRece 
        select ReceARQ
        close
      endif  
  
      if tOpenRepr 
        select ReprARQ
        close
      endif  
  
      if tOpenClie 
        select ClieARQ
        close
      endif  
    
      restscreen( 00, 00, 23, 79, tTelaRcto )
      return NIL
    endif  
  endif  

  Janela ( 03, 01, 20, 76, mensagem( 'Janela', 'ConsCoPg', .f. ), .f. )
  setcolor( CorJanel + ',' + CorCampo )
  @ 07,004 say 'Nota     Tipo   Emis.      Vcto.      Pgto.      Total      Comissão'
  @ 08,001 say chr(195) + replicate( chr(196), 74 ) + chr(180)
  @ 08,003 say chr(194)
  @ 08,012 say chr(194)
  @ 08,019 say chr(194)
  @ 08,030 say chr(194)
  @ 08,041 say chr(194)
  @ 08,052 say chr(194)
  @ 08,063 say chr(194)
  for nLin := 9 to 17
    @ nLin,003 say chr(179)
    @ nLin,012 say chr(179)
    @ nLin,019 say chr(179)
    @ nLin,030 say chr(179)
    @ nLin,041 say chr(179)
    @ nLin,052 say chr(179)
    @ nLin,063 say chr(179)
  next
  @ 18,001 say chr(195) + replicate( chr(196), 74 ) + chr(180)
  @ 18,003 say chr(193)
  @ 18,012 say chr(193)
  @ 18,019 say chr(193)
  @ 18,030 say chr(193)
  @ 18,041 say chr(193)
  @ 18,052 say chr(193)
  @ 18,063 say chr(193)
  @ 05,009 say 'Vendedor'
  @ 19,005 say 'Comissão Paga'
  @ 19,040 say 'Total Geral'
   
  setcolor( CorCampo )
  @ 05,23 say space(40)
  @ 19,19 say rTotalPaga                 pict '@E 999,999.99'
  @ 19,54 say rTotalGeral                pict '@E 999,999.99'
  @ 19,65 say rTotalComis                pict '@E 999,999.99'
  
  setcolor( CorJanel + ',' + CorCampo )
  @ 05,18 get nRepr     pict '999999'    valid ValidARQ( 05, 18, "ReceARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nRepr", .t., 6, "Vendedores", "ReprARQ", 40 )
  read
  
  cRepr := strzero( nRepr, 6 )
  
  if lastkey() == K_ESC
    if tOpenRece 
      select ReceARQ
      close
    endif  
  
    if tOpenRepr 
      select ReprARQ
      close
    endif  
  
    if tOpenClie
      select ClieARQ
      close
    endif  
    
    restscreen( 00, 00, 23, 79, tTelaRcto )
    return NIL
  endif  
  
  
  select( cReceTMP )
  set order    to 1
  set relation to Clie into ClieARQ

  select ReceARQ
  set order to 6
  dbseek( cRepr, .t. )
  do while Repr == cRepr .and. !eof ()
    if Vcto >= dVctoIni .and. Vcto <= dVctoFin .and. !empty( MarcRepr )
      select( cReceTMP )
      if AdiReg()
        if RegLock()
          replace Nota        with ReceARQ->Nota
          replace Tipo        with ReceARQ->Tipo
          replace Clie        with ReceARQ->Clie
          replace Cliente     with ReceARQ->Cliente
          replace Emis        with ReceARQ->Emis
          replace Vcto        with ReceARQ->Vcto
          replace Valor       with ReceARQ->Valor
          replace Acre        with ReceARQ->Acre
          replace Desc        with ReceARQ->Desc
          replace Port        with ReceARQ->Port
          replace Repr        with ReceARQ->Repr
          replace Cobr        with ReceARQ->Cobr
          replace Dest        with ReceARQ->Dest
          replace TipoVcto    with ReceARQ->TipoVcto
          replace ReprComi    with ReceARQ->ReprComi
          dbunlock ()
        endif
      endif

      rTotalGeral += ( ( Valor - Desc ) + VerJuro() )
      rTotalComis += ( ReprComi ) 

      select ReceARQ
    endif  
    dbskip()
  enddo     
  
  select( cReceTMP )
  bFirst := {|| .t. }
  bLast  := {|| .t. }
  bWhile := {|| .t. }
  bFor   := {|| .t. }
  
  oReceber          := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oReceber:nTop     := 7
  oReceber:nLeft    := 2
  oReceber:nBottom  := 18
  oReceber:nRight   := 75
  oReceber:headsep  := chr(194)+chr(196)
  oReceber:colsep   := chr(179)
  oReceber:footsep  := chr(193)+chr(196)

  oReceber:addColumn( TBColumnNew(" ",        {|| MarcRepr } ) )
  oReceber:addColumn( TBColumnNew("Nota",     {|| transform( val( Nota ), '999999-99' ) } ) )
  oReceber:addColumn( TBColumnNew("Tipo",     {|| iif( Tipo == 'P', 'Pedido  ', iif( Tipo == 'N', 'Nota   ','O.S.   ' ) ) } ) )
  oReceber:addColumn( TBColumnNew("Emis.",    {|| Emis } ) )
  oReceber:addColumn( TBColumnNew("Vcto.",    {|| Vcto } ) )
  oReceber:addColumn( TBColumnNew("Pgto.",    {|| Pgto } ) )
  oReceber:addColumn( TBColumnNew("Total",    {|| transform( VerTotal(), '@E 999,999.99' ) } ) )
  oReceber:addColumn( TBColumnNew("Comissão", {|| transform( ReprComi, '@E 99,999.99' ) } ) )
              
  lAdiciona      := .f.
  lMais          := .t.
  lExitRequested := .f.
  nLinBarra      := 1
  cSequ          := space(2)
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 8, 18, 76, nTotal )
  
  setcolor( CorCampo )
  @ 19,19 say rTotalPaga                 pict '@E 999,999.99'
  @ 19,54 say rTotalGeral                pict '@E 999,999.99'
  @ 19,65 say rTotalComis                pict '@E 999,999.99'

  dbgotop()
    
  oReceber:gotop()
  oReceber:refreshAll()

  do while !lExitRequested
    Mensagem( 'Repr', 'ConsComi' )
    
    oReceber:forcestable() 
    
    PosiDBF( 03, 76 )

    iif( BarraSeta, BarraSeta( nLinBarra, 8, 18, 76, nTotal ), NIL )
    
    if oReceber:stable
      if lMais
        do while .t.
          oReceber:down()
          oReceber:forcestable() 
          
          if oReceber:hitBottom
            lMais := .f.
            exit
          endif
        enddo    
      endif
      if oReceber:hitTop .or. oReceber:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
        
    do case
      case cTecla == K_DOWN 
        if !oReceber:hitBottom
          nLinBarra ++
          if nLinBarra >= nTotal
            nLinBarra := nTotal 
          endif  
        endif  
      case cTecla == K_UP 
        if !oReceber:hitTop
          nLinBarra --
          if nLinBarra < 1
            nLinBarra := 1
          endif  
        endif
    endcase
        
    do case
      case cTecla == K_DOWN;       oReceber:down()
      case cTecla == K_UP;         oReceber:up()
      case cTecla == K_PGDN;       oReceber:pageDown()
      case cTecla == K_PGUP;       oReceber:pageUp()
      case cTecla == K_LEFT;       oReceber:left()
      case cTecla == K_RIGHT;      oReceber:right()
      case cTecla == K_CTRL_PGUP;  oReceber:goTop()
      case cTecla == K_CTRL_PGDN;  oReceber:gobottom()
      case cTecla == K_ESC;        lExitRequested := .t.
      case cTecla == K_ALT_P
        tAlte := savescreen( 00, 00, 24, 79 )         
        Janela( 06, 20, 12, 55, mensagem( 'Janela', 'Atencao', .f. ), .t. )          
        setcolor( CorJanel )
        @ 08,22 say 'Vocˆ tem certeza que gostaria de'
        @ 09,22 say 'fazer o Pagaento Comissão ?'

        if ConfLine( 11, 43, 1 )
          nTotalGeral := 0
          nSubTotal   := 0
          aNotas      := {}
       
          select( cReceTMP )
          set order to 1
          dbgotop()
          do while !eof ()
            if !empty( MarcRepr )
              select ReceARQ
              set order to 1
              dbseek( &cReceTMP->Nota + &cReceTMP->Tipo, .f. )
              if found()
                if RegLock()
                  replace MarcRepr        with "X"
                endif
                dbunlock()
              endif  

              select( cReceTMP )
              if RegLock()
                dbdelete()
                dbunlock()
              endif             
            endif
            dbskip()
          enddo    
          
          PrinRecibo( .t., 'comi' )
          
          rTotalGeral := 0
          rTotalComis := 0
          rTotalPaga  := 0

          select( cReceTMP )
          set order to 1
          dbgotop()
          do while !eof ()
            if Vcto >= dVctoIni .and. Vcto <= dVctoFin
              rTotalGeral += ( ( Valor - Desc ) + VerJuro() )
              rTotalComis += ( ReprComi ) 
   
              if !empty( MarcRepr )
                rTotalPaga  += ( ReprComi ) 
              endif  
            endif  
            dbskip()
          enddo

          restscreen( 00, 00, 24, 79, tAlte )
          
          dbgotop()          
          select( cReceTMP )
          oReceber:gotop()
          oReceber:refreshAll()
  
          setcolor( CorCampo )
          @ 19,19 say rTotalPaga                 pict '@E 999,999.99'
          @ 19,54 say rTotalGeral                pict '@E 999,999.99'
          @ 19,65 say rTotalComis                pict '@E 999,999.99'
        endif

      case cTecla == K_ALT_A;      tReceTela := savescreen( 00, 00, 22, 79 )
        Rece(.t.)

        rTotalGeral := rTotalPaga  := 0
        rTotalComis := 0

        restscreen( 00, 00, 22, 79, tReceTela )

        select ReceARQ
        set order to 6
        dbseek( cRepr, .t. )
    
        do while Repr == cRepr .and. !eof()
          rTotalComis += ( ReprComi )
          rTotalGeral += ( ( Valor - Desc ) + VerJuro() )
          
          if Marc == "X"
            rTotalPaga += ( ( ReprComi ) )
          endif
            
          dbskip ()
        enddo      

        setcolor( CorCampo )
        @ 19,19 say rTotalPaga                 pict '@E 999,999.99'
        @ 19,53 say rTotalGeral                pict '@E 999,999.99'
        @ 19,64 say rTotalComis                pict '@E 999,999.99'
        
        oReceber:gotop()           
        oReceber:refreshAll()

        lExitRequested := .f.
      case cTecla == K_SPACE
        if ReceARQ->MarcRepr == ' '
          rTotalPaga += ReprComi
        else  
          rTotalPaga -= ReprComi

          if rTotalPaga < 0
            rTotalPaga := 0
          endif  
        endif  

        if RegLock()
          if ReceARQ->MarcRepr == ' '
            replace MarcRepr      with "X"
          else
            replace MarcRepr      with ' '
          endif    
          dbunlock ()
        endif  
        
        setcolor( CorCampo )
        @ 19,19 say rTotalPaga                  pict '@E 999,999.99'
        
        oReceber:refreshAll()
      case cTecla == K_ALT_F
        tSele := savescreen( 00, 00, 23, 79 )
        Janela( 09, 24, 13, 50, mensagem( 'Janela', 'Atencao', .f. ), .f. )
        Mensagem( 'LEVE', 'Periodo' )

        setcolor( CorJanel )
        @ 11,26 say 'Vcto. Inicial'
        @ 12,26 say '  Vcto. Final'
  
        @ 11,40 get dVctoIni      pict '99/99/9999'
        @ 12,40 get dVctoFin      pict '99/99/9999' valid dVctoFin >= dVctoIni
        read

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tSele )
          loop
        endif
        
        oReceber:gotop()
        oReceber:refreshAll()
        restscreen( 00, 00, 23, 79, tSele ) 
    endcase
    select( cReceTMP )
  enddo  
  
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
  
  if tOpenRece 
    select ReceARQ
    close
  endif  

  if tOpenRepr 
    select ReprARQ
    close
  endif  
    
  if tOpenClie
    select ClieARQ
    close
  endif  

  select( cReceTMP )
  ferase( cReceARQ )
  ferase( cReceIND1 )
  #ifdef DBF_CDX
    ferase( left( cReceARQ, len( cReceARQ ) - 3 ) + 'FPT' )
  #endif  
  #ifdef DBF_NTX
    ferase( left( cReceARQ, len( cReceARQ ) - 3 ) + 'DBT' )
  #endif  
    
  setcolor( cCorAtual )
  restscreen( 00, 00, 23, 79, tTelaRcto )
return NIL