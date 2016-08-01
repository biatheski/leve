//  Leve, Operacao de Estoque
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

function Estq( xAlte )
  local GetList := {}
  
if SemAcesso( 'Estq' )
  return NIL
endif  

if NetUse( "EstqARQ", .t. )
  VerifIND( "EstqARQ" )
  
  lOpenEstq := .t.

  #ifdef DBF_NTX
    set index to EstqIND1, EstqIND2
  #endif  
else
  lOpenEstq := .f.
endif

//  Variaveis de Entrada
cCoAt := space(04)
nEstq := 0
cNoAt := space(30)
nEstq := 0
cTipo := cDisp := cFisi := cRese := space(01)
cEstq := space(06)

//  Tela Estq
Janela ( 06, 05, 17, 62, mensagem( 'Janela', 'Estq', .f. ), .t. )

setcolor ( CorJanel + ',' + CorCampo )
@ 08,07 say '    Codigo'
@ 10,07 say ' Descrição'
@ 11,07 say '      Tipo'
@ 12,07 say 'Disponível'
@ 13,07 say '    Físico'
@ 14,07 say '   Reserva'

MostOpcao( 16, 07, 19, 38, 51 ) 
tEstq := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Estqbuto
select EstqARQ
set order to 1
if lOpenEstq
  dbgobottom ()
endif  
do while .t.
  select EstqARQ
  set order to 1

  Mensagem('Estq','Janela')

  restscreen( 00, 00, 23, 79, tEstq )
  cStat := space(4)
  MostEstq()
  
  if Demo ()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostEstq'
  cAjuda   := 'Estq'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  if lastkey() == K_ALT_A
    nEstq := val( Estq )
  else    
    if xAlte 
      @ 08,18 get nEstq              pict '999999'
      read
    else
      dbgobottom ()
     
      nEstq := val( Estq ) + 1
    endif  
  endif  
       
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. nEstq == 0
    exit
  endif
  
  setcolor ( CorCampo )
  cCoAt := strzero( nEstq, 6 )
  @ 08,18 say cCoAt
  
  //  Verificar existencia do Lancamento para Incluir ou Alterar
  select EstqARQ
  set order to 1
  dbseek( cCoAt, .f. )
  if eof()
    cStat :=  'incl'
  else
    cStat :=  'alte'
  endif

  Mensagem ('Estq',cStat )
  
  MostEstq ()
  EntrEstq ()

  Confirmar( 16, 07, 19, 38, 51, 3 )

  if cStat == 'excl'
    ExclRegi ()
  endif

  if cStat == 'prin'
    PrinEstq(.f.)
  endif  
    
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Estq         with cCoAt
        dbunlock ()
      endif
    endif
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Nome         with cNoAt
      replace Tipo         with cTipo 
      replace Disp         with cDisp
      replace Fisi         with cFisi
      replace Rese         with cRese
      dbunlock ()
    endif
  endif
enddo

if lOpenEstq
  select EstqARQ
  close 
endif

return NIL

//
// Entra Dados do Estqbuto
//
function EntrEstq ()
  local GetList := {}

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,18 get cNoAt                valid !empty( cNoAt )
  @ 11,18 get cTipo         pict '@!'  valid EstqTipo()
  @ 12,18 get cDisp         pict '@!'  valid EstqDisp()
  @ 13,18 get cFisi         pict '@!'  valid EstqFisi()
  @ 14,18 get cRese         pict '@!'  valid EstqRese()
  read
return NIL

function EstqTipo()
  lOka := .f.
  
  setcolor( CorCampo )
   
  do case
    case cTipo == 'E'
      lOka := .t.  
      @ 11,20 say 'ENTRADA    '
    case cTipo == 'S'
      lOka := .t.  
      @ 11,20 say 'SAIDA      '
    case cTipo == 'I'
      lOka := .t.  
      @ 11,20 say 'INVENTARIO '
    case cTipo == ' '
      lOka := .t.  
      @ 11,20 say '           '
    otherwise
      Alerta( '<E>ntrada, <S>aida, <I>nventario                                                    Tecle algo para continuar...' )
      
  endcase    
  
  setcolor( CorJanel )
return lOka

function EstqFisi()
  lOka := .f.
  
  setcolor( CorCampo )
  
  do case
    case cFisi == 'S'
      lOka := .t.  
      @ 13,20 say 'SOMAR     '
    case cFisi == 'D'
      lOka := .t.  
      @ 13,20 say 'DIMINUIR  '
    case cFisi == 'I'
      lOka := .t.  
      @ 13,20 say 'IGUALAR   '
    case cFisi == 'N'
      lOka := .t.  
      @ 13,20 say 'INALTERAR ' 
    case cFisi == ' '
      lOka := .t.  
      @ 13,20 say '          '
    otherwise
      Alerta( '<S>omar, <D>iminuir, <I>gualar,      I<n>alterar                                    Tecle algo para continuar...' )     

  endcase    

  setcolor( CorJanel )
return lOka

function EstqDisp()
  lOka := .f.
  
  setcolor( CorCampo )
  
  do case
    case cDisp == 'S'
      lOka := .t.  
      @ 12,20 say 'SOMAR     '
    case cDisp == 'D'
      lOka := .t.  
      @ 12,20 say 'DIMINUIR  '
    case cDisp == 'I'
      lOka := .t.  
      @ 12,20 say 'IGUALAR   '
    case cDisp == 'N'
      lOka := .t.  
      @ 12,20 say 'INALTERAR ' 
    case cDisp == ' '
      lOka := .t.  
      @ 12,20 say '          '
    otherwise
      Alerta( '<S>omar, <D>iminuir, <I>gualar,      I<n>alterar                                    Tecle algo para continuar...' )     

  endcase    

  setcolor( CorJanel )
return lOka

function EstqRese()
  lOka := .f.
  
  setcolor( CorCampo )
  
  do case
    case cRese == 'S'
      lOka := .t.  
      @ 14,20 say 'SOMAR     '
    case cRese == 'D'
      lOka := .t.  
      @ 14,20 say 'DIMINUIR  '
    case cRese == 'I'
      lOka := .t.  
      @ 14,20 say 'IGUALAR   '
    case cRese == 'N'
      lOka := .t.  
      @ 14,20 say 'INALTERAR ' 
    case cRese == ' '
      lOka := .t.  
      @ 14,20 say '          '
    otherwise
      Alerta( '<S>omar, <D>iminuir, <I>gualar,      I<n>alterar                                    Tecle algo para continuar...' )     

  endcase    

  setcolor( CorJanel )
return lOka

// Mostra Estoque
function MostEstq ()

  setcolor ( CorCampo )
  if cStat != 'incl' 
    nEstq := val( Estq )
    cEstq := Estq

    @ 08,18 say cEstq
  endif
  
  cNoAt := Nome
  cTipo := Tipo 
  cDisp := Disp
  cFisi := Fisi
  cRese := Rese
        
  @ 10,18 say cNoAt             pict '@S40'
  @ 11,18 say cTipo
  @ 12,18 say cDisp
  @ 13,18 say cFisi
  @ 14,18 say cRese

  EstqTipo ()
  EstqDisp ()
  EstqFisi () 
  EstqRese ()
  
  PosiDBF( 06, 62 )
return NIL

//
// Imprime dados do Estqbuto
//
function PrinEstq( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "EstqARQ", .t. )
      VerifIND( "EstqARQ" )

      #ifdef DBF_NTX
        set index to EstqIND1, EstqIND2
      #endif  
    endif
  endif  

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 06, 27, 10, 56, mensagem( 'Janela', 'PrinEstq', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,30 say 'Estoque Inicial'
  @ 09,30 say '  Estoque  Final'

  select EstqARQ
  set order to 1
  dbgotop ()
  nEstqIni := val( Estq )
  dbgobottom ()
  nEstqFin := val( Estq )

  @ 08,47 get nEstqIni    pict '999999'        valid ValidARQ( 99, 99, "EstqARQ", "Código" , "Estq", "Descrição", "Nome", "Estq", "nEstqIni", .t., 6, "Consulta de Estqbutoes", "EstqARQ", 40 )
  @ 09,47 get nEstqFin    pict '999999'        valid ValidARQ( 99, 99, "EstqARQ", "Código" , "Estq", "Descrição", "Nome", "Estq", "nEstqFin", .t., 6, "Consulta de Estqbutoes", "EstqARQ", 40 ) .and. nEstqFin >= nEstqIni  
  read
  
  if lastkey () == K_ESC
    select EstqARQ
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

  cEstqIni := strzero( nEstqIni, 6 )
  cEstqFin := strzero( nEstqFin, 6 )
  lInicio  := .t.

  select EstqARQ
  set order to 1
  dbseek( cEstqIni, .t. )
  do while Estq >= cEstqIni .and. Estq <= cEstqFin .and. !eof()
    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on

      lInicio := .f.
    endif  
    
    if nLin == 0
      Cabecalho( 'Estoque', 80, 2 )
      CabEstq()
    endif
      
    @ nLin, 01 say Estq                 pict '999999'
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
      replace Titu       with "Relatório de Estoque"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
  endif  

  select EstqARQ
  if lAbrir
    close
  else
    set order to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
  return NIL
return NIL

function CabEstq ()
  @ 02,01 say 'Estoque  Descricao'

  nLin := 4
retur NIL