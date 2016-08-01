//  Leve, Custos
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

function Cust( xAlte )

if SemAcesso( 'Cust' )
  return NIL
endif  

if NetUse( "CustARQ", .t. )
  VerifIND( "CustARQ" )
  
  lOpenCust := .t.

  #ifdef DBF_NTX
    set index to CustIND1, CustIND2
  #endif  
else
  lOpenCust := .f.
endif

//  Variaveis de Entrada
cCoPo := space(04)
nCust := 0
cNoPo := space(30)

//  Tela Cust
Janela ( 06, 05, 13, 62, mensagem( 'Janela', 'Cust', .f. ), .t. )

setcolor ( CorJanel + ',' + CorCampo )
@ 08,10 say '   Codigo'
@ 10,10 say 'Descrição'

MostOpcao( 12, 07, 19, 38, 51 ) 
tCust := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Cust
select CustARQ
set order to 1
if lOpenCust
  dbgobottom ()
endif  
do while .t.
  select CustARQ
  set order to 1

  Mensagem('Cust','Janela')

  restscreen( 00, 00, 23, 79, tCust )
  cStat := space(4)
  MostCust()
  
  if Demo ()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostCust'
  cAjuda   := 'Cust'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  if lastkey() == K_ALT_A
    nCust := val( Cust )
  else    
    if xAlte 
      @ 08,20 get nCust              pict '999999'
      read
    else
      dbgobottom ()
     
      nCust := val( Cust ) + 1
    endif  
  endif  
       
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. nCust == 0
    exit
  endif
  
  setcolor ( CorCampo )
  cCoPo := strzero( nCust, 6 )
  @ 08,20 say cCoPo
  
  //  Verificar existencia do Lancamento para Incluir ou Alterar
  select CustARQ
  set order to 1
  dbseek( cCoPo, .f. )
  if eof()
    cStat :=  'incl'
  else
    cStat :=  'alte'
  endif

  Mensagem ('Cust',cStat)
  
  MostCust ()
  EntrCust ()

  Confirmar( 12, 07, 19, 38, 51, 3 )

  if cStat == 'excl'
    ExclRegi ()
  endif

  if cStat == 'prin'
    PrinCust(.f.)
  endif  
    
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Cust         with cCoPo
        dbunlock ()
      endif
    endif
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Nome         with cNoPo
      dbunlock ()
    endif
  endif
enddo

if lOpenCust
  select CustARQ
  close 
endif

return NIL

//
// Entra Dados do Custador
//
function EntrCust ()
  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,20 get cNoPo                valid !empty( cNoPo )
  read
return NIL

//
// Mostra Dados do Custos
//
function MostCust ()

  if cStat != 'incl' 
    cCoPo := Cust
    nCust := val( Cust )
  endif
  
  cNoPo := Nome
      
  setcolor ( CorCampo )
  @ 10,20 say cNoPo
  
  PosiDBF( 06, 62 )
return NIL

//
// Imprime dados do Custador
//
function PrinCust( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "CustARQ", .t. )
      VerifIND( "CustARQ" )

      #ifdef DBF_NTX
        set index to CustIND1, CustIND2
      #endif	
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 06, 27, 10, 56, mensagem( 'Janela', 'PrinCust', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,30 say ' Custo Inicial'
  @ 09,30 say '   Custo Final'

  select CustARQ
  set order to 1
  dbgotop ()
  nCustIni := val( Cust )
  dbgobottom ()
  nCustFin := val( Cust )

  @ 08,45 get nCustIni    pict '999999'        valid ValidARQ( 99, 99, "CustARQ", "Código" , "Cust", "Descrição", "Nome", "Cust", "nCustIni", .t., 6, "Consulta de Custos", "CustARQ", 40 )
  @ 09,45 get nCustFin    pict '999999'        valid ValidARQ( 99, 99, "CustARQ", "Código" , "Cust", "Descrição", "Nome", "Cust", "nCustFin", .t., 6, "Consulta de Custos", "CustARQ", 40 ) .and. nCustFin >= nCustIni  
  read
  
  if lastkey () == K_ESC
    select CustARQ
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

  cCustIni := strzero( nCustIni, 6 )
  cCustFin := strzero( nCustFin, 6 )
  lInicio  := .t.

  select CustARQ
  set order to 1
  dbseek( cCustIni, .t. )
  do while Cust >= cCustIni .and. Cust <= cCustFin .and. !eof()
    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on

      lInicio := .f.
    endif  
    
    if nLin == 0
      Cabecalho( 'Custos', 80, 3 )
      CabCust()
    endif
      
    @ nLin, 05 say Cust                 pict '999999'
    @ nLin, 12 say Nome
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
      replace Titu       with "Relatório de Custos"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
  endif  

  select CustARQ
  if lAbrir
    close
  else
    set order to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
  return NIL
return NIL

function CabCust ()
  @ 02,01 say 'Custos   Descrição'

  nLin := 4
retur NIL