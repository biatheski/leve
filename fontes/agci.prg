//	Leve, Cadastro de Agencias
//	Copyright (C) 1992-2015 Fabiano Biatheski - biatheski@gmail.com

//	See the file LICENSE.txt, included in this distribution,
//	for details about the copyright.

//	This software is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

//	History
//	  10/09/2015 20:38 - Binho
//		  Initial commit github

#include "inkey.ch"

#ifdef RDD_ADS
  #include "ads.ch" 
#endif

function Agci( xAlte, xBanc )

if NetUse( "BancARQ", .t. )
  VerifIND( "BancARQ" )
  
  bOpenBanc := .t.

  #ifdef DBF_NTX
    set index to BancIND1, BancIND2
  #endif  
else
  bOpenBanc := .f.
endif

if NetUse( "AgciARQ", .t. )
  VerifIND( "AgciIND1" )
  
  bOpenAgci := .t.

  #ifdef DBF_NTX
    set index to AgciIND1, AgciIND2
  #endif  
else
  bOpenAgci := .f.
endif

// Variaveis de entrada para Agencia
cBanc := cAgci := space(02)
nBanc := nAgci := 0
cNoBa := space(30)

// Tela de Cadastro
Janela ( 04, 05, 12, 62, mensagem( 'Janela', 'Agci', .f. ), .t. )
setcolor ( CorJanel + ',' + CorCampo )
@ 06,09 say '     Banco'
@ 07,09 say '   Agência'
@ 09,09 say '    Cidade'

MostOpcao( 11, 07, 19, 38, 51 ) 
tAgci := savescreen( 00, 00, 23, 79 )

//  Manutencao cadastro de Agencia
select AgciARQ
set order    to 1
set relation to Banc into BancARQ
if bOpenAgci
  dbgobottom ()
endif  
do while  .t.
  Mensagem ( 'Agci', 'Janela' )

  select BancARQ
  set order    to 1

  select AgciARQ
  set order    to 1
  set relation to Banc into BancARQ

  restscreen( 00, 00, 23, 79, tAgci )
  cStat := space(4)
  MostAgci()
  
  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostAgci'
  cAjuda   := 'Agci'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to 
  
  if lastkey() == K_ALT_A
    nBanc := val( Banc )
  else  
    if xAlte
      @ 06,20 get nBanc         pict '9999' valid ValidARQ( 06, 20, "AgciARQ", "Código" , "Banc", "Descrição", "Nome", "Banc", "nBanc", .t., 4, "Bancos", "BancARQ", 30 )
    else  
      nBanc := xBanc
      xAlte := .t.

      select BancARQ
      set order to 1
      dbseek( strzero( nBanc, 4 ), .f. )
     
      setcolor( CorCampo )
      @ 06,20 say nBanc         pict '9999'
      @ 06,25 say BancARQ->Nome pict '@S30' 
    endif
  endif  
  
  if lastkey() == K_ALT_A
    nAgci := val( Agci )
  else  
    setcolor ( CorJanel + ',' + CorCampo )
    @ 07,20 get nAgci         pict '9999'
    read
  endif
  
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. nAgci == 0 .or. nBanc == 0
    exit
  endif

  cBanc := strzero ( nBanc, 4 ) 
  cAgci := strzero ( nAgci, 4 ) 

  setcolor ( CorCampo )
  @ 06,20 say cBanc
  @ 07,20 say cAgci
  
  //  Verificar existencia da Agencia para Incluir ou Alterar
  select AgciARQ
  set order to 1
  dbseek( cBanc + cAgci, .f. )
  if eof ()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif
  
  Mensagem ('Agci', cStat )

  MostAgci ()
  EntrAgci ()

  Confirmar( 11, 07, 19, 38, 51, 3 )

  if cStat == 'prin'
    PrinAgci (.f.)
  endif
    
  if cStat == 'excl'
    ExclRegi ()
  endif
  
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Banc         with cBanc
        replace Agci         with cAgci
        dbunlock ()
      endif
    endif  
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Nome        with cNoBa
      dbunlock ()
    endif  
  endif
enddo

if bOpenBanc
  select BancARQ
  close
endif  

if bOpenAgci
  select AgciARQ
  close
endif  

return NIL
//
// Entra com dados do Agencia
//
function EntrAgci ()
  setcolor ( CorJanel + ',' + CorCampo )
  @ 09,20 get cNoBa
  read
return NIL

//
// Mostra dados do Agencia 
//
function MostAgci ()
  setcolor ( CorCampo )
  if cStat != 'incl' 
    cAgci := Agci
    cBanc := Banc
    nAgci := val ( Agci )
    nBanc := val ( Banc )

    @ 06, 20 say cBanc
    @ 06, 25 say BancARQ->Nome        pict '@S30' 
    @ 07, 20 say cAgci
  endif

  cNoBa := Nome

  @ 09,20 say cNoBa
  
  PosiDBF( 04, 62 )
return NIL

//
// Imprime dados agencia
//
function PrinAgci ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "BancARQ", .t. )
    VerifIND( "BancARQ" )
    
    lOpenBanc := .t. 

    #ifdef DBF_NTX
      set index to BancIND1, BancIND2
    #endif  
  else
    lOpenBanc := .f.  
  endif

  if NetUse( "AgciARQ", .t. )
    VerifIND( "AgciARQ" )
    
    lOpenAgci := .t.
  
    #ifdef DBF_NTX
      set index to AgciIND1, AgciIND2
    #endif  
  else 
    lOpenAgci := .f.  
  endif

  tPrt := savescreen( 00, 00, 23, 79 )

  Janela ( 06, 13, 10, 63, mensagem( 'Janela', 'PrinAgci', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,15 say '     Banco Inicial             Banco Final'
  @ 09,15 say '   Agência Inicial           Agência Final'

  select BancARQ
  set order to 1
  dbgotop ()
  nBancIni := val ( Banc )
  dbgobottom ()
  nBancFin := val ( Banc )

  select AgciARQ
  set order to 1
  dbgotop ()
  nAgciIni := 0001
  nAgciFin := 9999

  @ 08,34 get nBancIni   pict '9999'    valid ValidARQ( 99, 99, "BancARQ", "Código" , "Banc", "Descrição", "Nome", "Banc", "nBancIni", .t., 4, "Consulta Bancos", "BancARQ", 40 ) 
  @ 08,58 get nBancFin   pict '9999'    valid ValidARQ( 99, 99, "BancARQ", "Código" , "Banc", "Descrição", "Nome", "Banc", "nBancFin", .t., 4, "Consulta Bancos", "BancARQ", 40 ) .and. nBancFin >= nBancIni
  @ 09,34 get nAgciIni   pict '9999'    
  @ 09,58 get nAgciFin   pict '9999'    valid nAgciFin >= nAgciIni
  read

  if lastkey () == K_ESC
    if lOpenAgci
      select AgciARQ
      close
    endif
  
    if lOpenBanc  
      select BancARQ
      close
    endif  
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
  
  Aguarde ()

  nPag     := 1
  nLin     := 0
  cArqu2   := cArqu2 + "." + strzero( nPag, 3 )
  lInicio  := .t.

  cAgciIni := strzero( nAgciIni, 4 )
  cAgciFin := strzero( nAgciFin, 4 )
  cBancIni := strzero( nBancIni, 4 ) 
  cBancFin := strzero( nBancFin, 4 )
  cBancAnt := space(04)

  select AgciARQ
  set order    to 1
  set relation to Banc into BancARQ
  dbseek( cAgciIni, .t. )
  do while Agci >= cAgciIni .and. Agci <= cAgciFin .and. !eof()
    if Banc >= cBancIni .and. Banc <= cBancFin 
      if lInicio
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
        
        lInicio := .f.
      endif  
      
      if nLin == 0
        Cabecalho( 'Agencias', 80, 4 )
        CabAgci()
      endif
    
      if cBancAnt != Banc 
        if cBancAnt != space(04)
          nLin ++
        endif  
        @ nLin,01 say Banc                pict '9999'
        @ nLin,06 say BancARQ->Nome       pict '@S30'
 
        nLin ++
        cBancAnt := Banc
      endif
 
      @ nLin,06 say Agci              pict '9999'
      @ nLin,11 say Nome
      nLin ++

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
  set cursor  on
  
  if Imprimir( cArqu3, 80 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Relatório de Agências"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
    close
  endif  

  if lOpenBanc  
    select BancARQ
    close
  endif  

  if lOpenAgci
    select AgciARQ
    close
  else  
    select AgciARQ
    set order  to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabAgci()
  @ 02,01 say 'Banco'
  @ 03,06 say 'Agência'

  nLin     := 5
  cBancAnt := space(04)
return NIL