//  Leve, Cotacoes de Moeda
//  Copyright (C) 1992-2015 Fabiano Biatheski - biatheski@gmail.com

//  See the file LICENSE.txt, included in this distribution,
//  for details about the copyright.

//  This software is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

//  History
//    10/09/2015 20:38 - Binho
//      Initial commit github

#include 'inkey.ch'

#ifdef RDD_ADS
  #include "ads.ch" 
#endif

function CoMo ()
  local GetList := {}

if NetUse( 'CoMoARQ', .t. )
  VerifIND( 'CoMoARQ' )
  
  #ifdef DBF_NTX
    set index to CoMoIND1
  #endif  
endif

if NetUse( 'MoedARQ', .t. )
  VerifIND( 'MoedARQ' )
  
  #ifdef DBF_NTX
    set index to MoedIND1, MoedIND2
  #endif  
endif

//  Variaveis de Entrada para Moeda
cMoed := space(02)
nMoed := nValo := 0
dData := ctod('  /  /  ')

//  Tela CoMo
Janela ( 04, 12, 20, 66, mensagem( 'Janela', 'CoMo', .f. ), .f. )

setcolor ( CorJanel + ',' + CorCampo )
@ 06,18 say 'Moeda'
@ 07,18 say ' Data'
@ 08,18 say 'Valor'
@ 10,18 say ' Data          Valor       Data          Valor'
@ 11,12 say chr(195) + replicate( chr(196), 53 ) + chr(180) 
@ 11,39 say chr(194)
for nU := 12 to 17
  @ nU,39 say chr(179)
next  
@ 18,12 say chr(195) + replicate( chr(196), 53 ) + chr(180)
@ 18,39 say chr(193)

MostOpcao( 19, 14, 26, 42, 55 )

setcolor( CorCampo )
@ 06,24 say space(06)
@ 06,31 say space(30)
@ 07,24 say '  /  /  '
@ 08,24 say trans( 0.00, '@E 999,999.999' )

tCoMo := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro 
select CoMoARQ
set order    to 1  
set filter   to 
set relation to Moed into MoedARQ
dbgobottom ()
do while .t.
  Mensagem('CoMo', 'Janela' )
  
  restscreen( 00, 00, 23, 79, tCoMo )
  cStat := space(4)

  if Demo ()
    exit
  endif  
  
  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  cAjuda   := 'CoMo'
  lAjud    := .f.
  nValo    := 0.000000
  dData    := ctod( space(08) )
  nMoed    := 0

  @ 06,24 get nMoed          pict '999999'       valid ValidARQ( 06, 24, 'CoMoARQ', 'Codigo', 'Moed', 'Descrição', 'Nome', 'Moed', 'nMoed', .t., 6, 'Tipos de Moedas', 'MoedARQ', 30 ) .and. UltiCota()
  @ 07,24 get dData          pict '99/99/9999' valid !empty( dData )
  read
  
  if lastkey() == K_ESC .or. dData == ctod('  /  /  ')
    exit
  endif
  
  setcolor ( CorCampo )
  cMoed := strzero( nMoed, 6 )

  @ 06,24 say cMoed
  @ 07,24 say dData
  
  //  Verificar existencia do Lancamento para Incluir ou Alterar
  select CoMoARQ
  set order to 1
  dbseek( cMoed + dtos( dData ), .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
    nValo := Valo
  endif

  Mensagem ('CoMo', cStat )
  
  EntrCoMo ()

  Confirmar( 19, 14, 26, 42, 55, 3 )
    
  if cStat == 'excl'
    select CoMoARQ
    set order to 1
    if ExclRegi(.f.)
      dData := ctod( space(08) )
      dbseek( cMoed, .t. )
      do while Moed == cMoed .and. !eof() 
        dData := Data

        if RegLock()
          dbdelete ()
          dbunlock ()
        endif
        dbskip()
      enddo  

      select MoedARQ
      set order to 1
      dbseek( cMoed, .f. )
      if RegLock()
        replace Ulti      with dData
        dbunlock()
      endif
    endif
  endif
    
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Moed         with cMoed
        replace Data         with dData
        dbunlock ()
      endif
    endif
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Valo         with nValo
      dbunlock ()

      select MoedARQ
      set order to 1
      dbseek( cMoed, .f. )
      if dData > Ulti
        if RegLock()
          replace Ulti         with dData
          dbunlock()
        endif
      endif
    endif
  endif
enddo

select MoedARQ 
close
select CoMoARQ
close

return NIL

//
// Entra Dados da Cotacao
//
function EntrCoMo ()
  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,24 get nValo              pict '@E 999,999.999' valid !empty( nValo )
  read
return NIL

//
// Checa as ultimas cotacoes
//
function UltiCota()

  nLado := 1
  nLin  := 11
  
  setcolor( CorJanel )
  select CoMoARQ
  set order to 1
  dbseek( strzero( nMoed, 6 ) + dtos( MoedARQ->Ulti ), .f. )
  do while Moed == strzero( nMoed, 6 ) .and. !bof()
    nLin ++
    if nLin > 17
      nLin  := 12
      nLado ++

      if nLado > 2
        exit
      endif
    endif

    if nLado == 1
      @ nLin,15 say Data          pict '99/99/9999'
      @ nLin,27 say Valo          pict '@E 999,999.999' 
    else
      @ nLin,41 say Data          pict '99/99/9999'
      @ nLin,53 say Valo          pict '@E 999,999.999' 
    endif
    
    dbskip(-1)
  enddo
return(.t.)

//
// Cotacao de Moeda
//
function VerMoeda()
  tMoeda := savescreen( 00, 00, 23, 79 )
    
  if NetUse( "MoedARQ", .t. )
    VerifIND( "MoedARQ" )
  
    lOpenMoed := .t.
 
    #ifdef DBF_NTX
      set index to MoedIND1, MoedIND2
    #endif  
  else
   lOpenMoed := .f.  
  endif

  if NetUse( 'CoMoARQ', .t. )
    VerifIND( 'CoMoARQ' )

    lOpenCoMo := .t.

    #ifdef DBF_NTX
      set index to CoMoIND1
    #endif  
  else
    lOpenCoMo := .f.
  endif

  Janela( 08, 12, 13, 70, mensagem( 'Janela', 'VerMoeda', .f. ), .f. )
  Mensagem( 'CoMo', 'VerMoeda' )
  setcolor( CorJanel + ',' + CorCampo )
  @ 10,14 say '  Tipo Moeda'
  @ 12,14 say 'Data Cotação              Valor Cotação'

  setcolor( CorCampo )
  @ 10,27 say space(06)
  @ 10,34 say space(30)
  @ 12,27 say '  /  /  '
  @ 12,54 say transform( 0,'@E 999,999.999' )

  nIndice := 0

  @ 10,27 get nIndice        pict '999999'  valid ValidARQ( 10, 27, 'CoMoARQ','Codigo','Moed','Descricao','Nome','Moed','nIndice',.t.,6,'Consulta Tipos de Moedas','MoedARQ', 30 )
  read

  if lastkey() == K_ESC
    restscreen( 00, 00, 23, 79, tMoeda ) 
    return(.f.)
  endif

  select MoedARQ
  set order to 1
  dbseek( strzero( nIndice, 6 ), .f. )

  dData    := Ulti
  dValor   := 0.000000
  lTemCota := .f.

  select CoMoARQ
  set order to 1
  dbseek( strzero( nIndice, 6 ) + dtos( dData ), .t. )
  if eof()
    dbseek( strzero( nIndice, 6 ), .t. )
    do while ! eof() .and. Moed == strzero( nIndice, 6 )
      dData     := Data
      dValor    := Valo
      lTempCota := .t.

      dbskip()
    enddo
  else
    if Moed == strzero( nIndice, 6 )
      lTemCota  := .t.
      dData     := Data
      dValor    := Valo
    endif
  endif
  
  if ! lTemCota
    Alerta( mensagem( 'Alerta', 'CoMo', .f. ) )
  else
    setcolor( corcampo )
    @ 12,27 say dData  pict   '99/99/9999'
    @ 12,54 say trans( dValor,'@E 999,999.999' )
  
    dbseek( strzero( nIndice, 6 ) + dtos( dData ), .f. )
    
    nMoedaDia := dValor
        
    Teclar(0)
  endif
   
  if lOpenMoed
    select MoedARQ
    close
  endif
  
  if lOpenCoMo
    select CoMoARQ
    close
  endif   
  
  restscreen( 00, 00, 23, 79, tMoeda ) 
return lTemCota