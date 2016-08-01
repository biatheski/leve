//  Leve, Caixa - Conta Corrente
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

function Caix()
  local GetList := {}
  
if SemAcesso( 'Caix' )
  return NIL
endif  

if NetUse( "CaixARQ", .t. )
  VerifIND( "CaixARQ" )
  
  cOpenCaix := .t.
  
  #ifdef DBF_NTX
    set index to CaixIND1, CaixIND2
  #endif  
else
  cOpenCaix := .f.
endif

//  Variaveis de Entrada para Caixa
cCaix := cBanc := cAgen := cCod := space(15)
cNome := space(30)

//  Tela Caixa
Janela ( 04, 05, 13, 62, mensagem( 'Janela', 'Caix', .f. ), .t. )

setcolor ( CorJanel + ',' + CorCampo )
@ 06,10 say '    Conta'
@ 08,10 say 'Descrição'
@ 09,10 say '    Banco'
@ 10,10 say '  Agencia'

MostOpcao( 12, 07, 19, 38, 51 ) 
tCaix := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Caixa
select CaixARQ
set order to 1
if cOpenCaix
  dbgobottom ()
endif  
do while .t.
  Mensagem('Caix', 'Janela' )

  select CaixARQ
  set order to 1

  restscreen( 00, 00, 23, 79, tCaix )
  cStat := space(4)
  MostCaix()
  
  if Demo ()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostCaix'
  cAjuda   := 'Caix'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()

  @ 06,20 get cCaix   pict '@K' valid !empty( cCaix )
  read
  
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 
 
  if lastkey() == K_ESC .or. cCaix == space (10)
    exit
  endif

  //  Verificar existencia do Caixa para Incluir ou Alterar
  select CaixARQ
  set order to 1
  dbseek( cCaix, .f. )
  if eof()
    cStat :=  'incl'
  else
    cStat :=  'alte'
  endif

  Mensagem ('Caix', cStat )

  MostCaix ()
  EntrCaix ()

  Confirmar( 12, 07, 19, 38, 51, 3 )

  if cStat == 'prin'
    PrinCaix ()
  endif
    
  if cStat == 'excl'
    ExclRegi ()
  endif
  
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Caix     with cCaix
        dbunlock ()
      endif
    endif   
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Nome     with cNome
      replace Banc     with cBanc
      replace Agen     with cAgen
      dbunlock ()
    endif
  endif
enddo

if cOpenCaix
  select CaixARQ
  close
endif  

return NIL

//
// Entra Dados do Caixa
//
function EntrCaix ()
  local GetList := {}

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,20 get cNome
  @ 09,20 get cBanc
  @ 10,20 get cAgen
  read
return NIL

//
// Mostra Dados do Caixa
//
function MostCaix ()
  if cStat != 'incl' 
    cCaix := Caix
  endif
  
  cNome := Nome
  cAgen := Agen
  cBanc := Banc
  
  setcolor ( CorCampo )
  @ 08,20 say cNome
  @ 09,20 say cBanc
  @ 10,20 say cAgen
  
  PosiDBF( 04, 62 )
return NIL

//
// Imprime Dados do Caixa
//
function PrinCaix ()

  local cArqu2  := CriaTemp( 5 )
  local cArqu3  := right ( cArqu2, 8 )

  local cRData  := date()
  local cRHora  := time()
  
  local GetList := {}

  if NetUse( "CaixARQ", .t. )
    VerifIND( "CaixARQ" )
    
    lOpenCaix := .t.
    
    #ifdef DBF_NTX 
      set index to CaixIND1, CaixIND2
    #endif  
  else
    lOpenCaix := .f.
  endif

  tPrt := savescreen( 00, 00, 23, 79 )

  //  Define Intervalo
  Janela ( 06, 23, 10, 55, mensagem( 'Janela', 'PrinCaix', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,25 say 'Caixa Inicial'
  @ 09,25 say '  Caixa Final'
  
  select CaixARQ
  set order to 1
  dbgotop ()
  cCaixIni := Caix
  dbgobottom ()
  cCaixFin := Caix
 
  @ 08,39 get cCaixIni   pict '@K'     valid ValidARQ( 99, 99, "CaixARQ", "Conta", "Caix", "Descrição", "Nome", "Caix", "cCaixIni", .f., 15, "Consulta de Conta Corrente", "CaixARQ", 40 ) 
  @ 09,39 get cCaixFin   pict '@K'     valid ValidARQ( 99, 99, "CaixARQ", "Conta", "Caix", "Descrição", "Nome", "Caix", "cCaixFin", .f., 15, "Consulta de Conta Corrente", "CaixARQ", 40 ) .and. cCaixFin >= cCaixIni
  read

  if lastkey() == K_ESC
    select CaixARQ
    if lOpenCaix
      close
    else
      dbgobottom ()  
    endif
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  Aguarde ()

  nPag    := 1
  nLin    := 0
  cArqu2  := cArqu2 + "." + strzero( nPag, 3 )
  lInicio := .t.

  select CaixARQ
  set order to 1
  dbseek( cCaixIni, .t. )
  do while Caix >= cCaixini .and. Caix <= cCaixfin .and. !eof()
    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
    
      lInicio := .f.
    endif
    
    if nLin == 0
      Cabecalho( 'Conta Corrente', 80, 4 )
      CabCaix ()
    endif
    
    @ nLin,00 say Caix
    @ nLin,16 say Nome        pict '@S20'
    @ nLin,40 say Banc        pict '@S15'        
    @ nLin,57 say Agen        pict '@S10' 
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
  
  if Imprimir ( cArqu3, 80 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Relatório de Conta Corrente"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
    close
  endif  

  select CaixARQ
  if lOpenCaix
    close
  else 
    dbgobottom ()  
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabCaix()
  @ 02,00 say 'Caixa'
  @ 02,16 say 'Descrição'
  @ 02,40 say 'Banco'
  @ 02,57 say 'Agencia'

  nLin := 4
return NIL

//
// Configurar Tipo de Pagamento
//
function DestLcto ()
  local GetList := {}
  local aArqOld := alias()
  local tDest   := savescreen( 00, 00, 23, 79 )

  if NetUse( "ContARQ", .t. )
    VerifIND( "ContARQ" )
  
    qOpenCont := .t.

    #ifdef DBF_NTX
     set index to ContIND1, ContIND2
    #endif
  else
    qOpenCont := .f.  
  endif

  if NetUse( "MoCaARQ", .t. )
    VerifIND( "MoCaARQ" )

    qOpenMoCa := .t.

    #ifdef DBF_NTX
      set index to MoCaIND1, MoCaIND2, MoCaIND3
    #endif
  else
    qOpenMoCa := .f.
  endif

  Janela( 08, 08, 18, 66, mensagem( 'Janela', 'DestLcto', .f. ), .t. )
  
  setcolor( CorJanel + ',' + CorCampo )

  @ 10,10 say '     Conta'
  @ 11,08 say chr(195)+replicate(chr(196),57)+chr(180)
  @ 12,10 say '      Nota                       Emissão'
  if select( "ClieARQ" ) > 0    
    @ 13,10 say '   Cliente'
  endif   
  @ 14,10 say '     Valor'
  @ 15,10 say ' Histórico'  
          
  setcolor( CorCampo )
  @ 10,37 say space(25)

  @ 12,21 say cNota
  @ 12,51 say dPgto                  pict '99/99/9999'
  if select( "ClieARQ" ) > 0
    @ 13,21 say ClieARQ->Clie        pict '999999'
    @ 13,28 say ClieARQ->Nome        pict '@S33'
  endif  
  @ 14,21 say nPago                  pict '@E 999,999.99'
  @ 15,21 say cHist                  pict '@S40'

  setcolor( CorJanel + ',' + CorCampo )
  @ 17,46 say '[ ] Lançar no Caixa'
  
  cCaix := cCont := space(15)
  cOK   := 'X'
  
  do while .t.   
    setcolor( CorJanel + ',' + CorCampo )
    @ 10,21 get cCont   pict '@!'         valid ValidARQ( 10, 21, "MoCaARQ", "Codigo", "Cont", "Descrição", "Nome", "Cont", "cCont", .f., 20, "Contas", "ContARQ", 20,,1 )
    @ 17,47 get cOk     pict '@!'
    read
    
    if lastkey() == K_PGDN
      loop
    else
      exit
    endif  
  enddo  

  if cOK == "X"
    select MoCaARQ
    set order to 1
    dbseek( cCont + cNota, .f. )
    if eof ()
      if AdiReg()
        if RegLock()
          replace Cont    with cCont
          replace Dcto    with cNota
          replace Movi    with dPgto
          replace ValM    with nPago
          replace Hist    with cHist
          dbunlock ()
        endif
      endif
    else
      if RegLock()
        replace Movi    with dPgto
        replace ValM    with nPago
        replace Hist    with cHist
        dbunlock ()
      endif
    endif
  endif
      
  if qOpenCont
    select ContARQ
    close
  endif
  if qOpenMoCa
    select MoCaARQ
    close
  endif
      
  restscreen( 00, 00, 23, 79, tDest )
  
  select( aArqOld )
return NIL