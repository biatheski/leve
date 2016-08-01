//  Leve, Cadastro de Moedas
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

function Moed( lAlte )
  local GetList := {}
 
if NetUse( "MoedARQ", .t. )
  VerifIND( "MoedARQ" )
  
  lOpenMoed := .t.
 
  #ifdef DBF_NTX
    set index to MoedIND1, MoedIND2
  #endif
else
  lOpenMoed := .f.  
endif

//  Variaveis de Entrada para Moeda
cCoMo := space(06)
nMoed := nVari := 0
cNoMo := space(30)
cVari := space(01)

//  Tela Moed
Janela ( 06, 05, 14, 62, mensagem( 'Janela', 'Moed', .f. ), .t. )

setcolor ( CorJanel + ',' + CorCampo )
@ 08,10 say '    Moeda'
@ 10,10 say 'Descrição'
@ 11,10 say ' Variação  Semanal   Mensal   Quinzenal   Diária'

MostOpcao( 13, 07, 19, 38, 51 ) 
tMoed := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Moed
select MoedARQ
set order to 1
if lAlte
  dbgobottom ()
endif
do while .t.
  Mensagem('Moed', 'Janela' )
 
  restscreen( 00, 00, 23, 79, tMoed )
  cStat := space(4)
  MostMoed()
  
  if Demo ()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostMoed'
  cAjuda   := 'Moed'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()

  @ 08,20 get nMoed              pict '999999'
  read
  
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. nMoed == 0
    exit
  endif
  
  setcolor ( CorCampo )
  cCoMo := strzero( nMoed, 6 )
  @ 08,20 say cCoMo
  
  //  Verificar existencia do Lancamento para Incluir ou Alterar
  select MoedARQ
  set order to 1
  dbseek( cCoMo, .f. )
  if eof()
    cStat :=  'incl'
  else
    cStat :=  'alte'
  endif

  Mensagem ('Moed',cStat )
  
  MostMoed ()
  EntrMoed ()

  Confirmar( 13, 07, 19, 38, 51, 3 )

  if cStat == 'prin'
    PrinMoed (.f.)
  endif
    
  if cStat == 'excl'
    ExclRegi(.t.)
  endif
    
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Moed         with cCoMo
        dbunlock ()
      endif
    endif
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Nome         with cNoMo
      replace Vari         with cVari
      dbunlock ()
    endif
  endif
enddo

if lOpenMoed
  select MoedARQ
  close
endif

return NIL

//
// Entra Dados do Lancamento
//
function EntrMoed ()
  local GetList := {}
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,20 get cNoMo                valid !empty( cNoMo )
  read
  
  if lastkey() == K_ESC
    return NIL
  endif
  
  aOpc := {}

  aadd( aOpc, { ' Semanal ' ,  2, 'S', 11, 20, "Cotação da Moeda - Semanal" } )
  aadd( aOpc, { ' Mensal ',    2, 'M', 11, 30, "Cotação da Moeda - Mensal" } ) 
  aadd( aOpc, { ' Quinzenal ', 2, 'Q', 11, 39, "Cotação da Moeda - Quinzenal" } )
  aadd( aOpc, { ' Diária ',    2, 'D', 11, 51, "Cotação da Moeda - Diária" } )
       
  nVari := HCHOICE( aOpc, 4, nVari, .t. )
  
  do case
    case nVari == 1;      cVari := 'S'  
    case nVari == 2;      cVari := 'M'  
    case nVari == 3;      cVari := 'Q'  
    case nVari == 4;      cVari := 'D'  
  endcase    
return NIL

//
// Mostra Dados do Moeda
//
function MostMoed ()
  if cStat != 'incl' 
    cCoMo := Moed
    nMoed := val( Moed )
  end
  
  cNoMo := Nome
  cVari := Vari

  do case
    case cVari == 'S';      nVari := 1  
    case cVari == 'M';      nVari := 2  
    case cVari == 'Q';      nVari := 3  
    case cVari == 'D';      nVari := 4  
    otherwise;              nVari := 1  
endcase    
    
  setcolor ( CorCampo )
  @ 10,20 say cNoMo
  @ 11,20 say ' Semanal '
  @ 11,30 say ' Mensal '
  @ 11,39 say ' Quinzenal '
  @ 11,51 say ' Diária '

  setcolor( CorAltKC )
  @ 11,21 say 'S'
  @ 11,31 say 'M'
  @ 11,40 say 'Q'
  @ 11,52 say 'D'
  
  setcolor( CorOpcao )
  do case
    case cVari == 'S'
      @ 11,20 say ' Semanal '
      setcolor ( CorAltKO )
      @ 11,21 say 'S'
    case cVari == 'M'
      @ 11,30 say ' Mensal '
      setcolor ( CorAltKO )
      @ 11,31 say 'M'
    case cVari == 'Q'
      @ 11,39 say ' Quinzenal '
      setcolor ( CorAltKO )
      @ 11,40 say 'Q'
    case cVari == 'D'
      @ 11,51 say ' Diária '
      setcolor ( CorAltKO )
      @ 11,52 say 'D'
  endcase   
return NIL

//
// Imprime Dados 
//
function PrinMoed(lAbrir) 

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

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
  Janela ( 06, 23, 10, 50, mensagem( 'Janela', 'PrinMoed', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,30 say 'Moeda Inicial'
  @ 09,30 say '  Moeda Final'
  
  select MoedARQ
  set order to 1
  dbgotop ()
  nMoedIni := val( Moed )
  dbgobottom ()
  nMoedFin := val( Moed )

  @ 08,44 get nMoedIni    pict '999999'   
  @ 09,44 get nMoedFin    pict '999999'       valid nMoedFin >= nMoedIni
  read

  if lastkey() == K_ESC .or. nMoedini == 0
    select MoedARQ
    if lAbrir
      close
    else
      dbgobottom()
    endif    
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  Aguarde ()

  cCoMoIni := strzero( nMoedIni, 6 )
  cCoMoFin := strzero( nMoedFin, 6 )
  nPag     := 1
  nLin     := 0
  cArqu2   := cArqu2 + "." + strzero( nPag, 3 )
  lInicio  := .t.
  
  // Posiciona Primeiro Moedas
  select MoedARQ
  set order to 2
  dbgotop ()
  do while Moed >= cCoMoIni .and. Moed <= cCoMoFin .and. !eof()
    if lInicio 
      set printer to ( cArqu2 )
      set device  to printer
      set printer on
      
      lInicio := .f.
    endif  

    if nLin == 0
      Cabecalho( 'Tipos de Moedas', 80, 5 )
      CabMoed()
    endif

    @ nLin,04 say Moed
    @ nLin,16 say Nome
    
    do case
      case Vari == 'S';        @ nLin,50 say 'Semanal'
      case Vari == 'M';        @ nLin,50 say 'Mensal'
      case Vari == 'Q';        @ nLin,50 say 'Quinzenal'
      case Vari == 'D';        @ nLin,50 say 'Di rio'
    endcase
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
  set device to screen

  if Imprimir( cArqu3, 80 )
    select SpooARQ
    if AdiReg()
      replace rela       with cNarq3
      replace Titu       with "Relação de Tipos de Moedas"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
  endif  
  
  select MoedARQ
  if lAbrir
    close
  else  
    dbgobottom ()
  endif  
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabMoed ()
  @ 02,01 say '   Codigo  Descrição                             Variação'
  nLin := 4
return NIL