//  Leve, Meta da Empresa
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

function MeEm( xAlte )

if SemAcesso( 'MeEm' )
  return NIL
endif  

if NetUse( "MeEmARQ", .t. )
  VerifIND( "MeEmARQ" )
  
  lOpenMeEm := .t.

  #ifdef DBF_NTX
    set index to MeEmIND1, MeEmIND2
  #endif
else
  lOpenMeEm := .f.
endif

//  Variaveis de Entrada
cMes  := space(02)
nMes  := nValo := 0

//  Tela MeEm
Janela ( 06, 05, 13, 62, mensagem( 'Janela', 'MeEm', .f. ), .t. )

setcolor ( CorJanel + ',' + CorCampo )
@ 08,10 say '      Mês'
@ 10,10 say '    Valor'

MostOpcao( 12, 07, 19, 38, 51 ) 
tMeEm := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de MeEm
select MeEmARQ
set order to 1
if lOpenMeEm
  dbgobottom ()
endif  
do while .t.
  select MeEmARQ
  set order to 1

  Mensagem('MeEm','Janela')

  restscreen( 00, 00, 23, 79, tMeEm )
  cStat := space(4)
  MostMeEm()
  
  if Demo ()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostMeEm'
  cAjuda   := 'MeEm'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  if lastkey() == K_ALT_A
    nMes := val( Mes )
  else    
    if xAlte 
      @ 08,20 get nMes              pict '99' valid ValidMes( 08, 20, nMes )
      read
    else
      dbgobottom ()
     
      nMes := val( Mes ) + 1
    endif  
  endif  
       
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. nMes == 0
    exit
  endif
  
  setcolor ( CorCampo )
  cMes := strzero( nMes, 2 )
  @ 08,20 say cMes
  
  //  Verificar existencia do Lancamento para Incluir ou Alterar
  select MeEmARQ
  set order to 1
  dbseek( cMes, .f. )
  if eof()
    cStat :=  'incl'
  else
    cStat :=  'alte'
  endif

  Mensagem ('MeEm',cStat)
  
  MostMeEm ()
  EntrMeEm ()

  Confirmar( 12, 07, 19, 38, 51, 3 )

  if cStat == 'excl'
    ExclRegi ()
  endif

  if cStat == 'prin'
    PrinMeEm(.f.)
  endif  
    
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Mes         with cMes
        replace Ano         with year(date())
        dbunlock ()
      endif
    endif
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Valo         with nValo
      dbunlock ()
    endif
  endif
enddo

if lOpenMeEm
  select MeEmARQ
  close 
endif

return NIL

//
// Entra Dados do MeEmador
//
function EntrMeEm ()
  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,20 get nValo          pict '@E 999,999,999.99' 
  read
return NIL

//
// Mostra Dados do MeEmador
//
function MostMeEm ()
  setcolor ( CorCampo )

  if cStat != 'incl' 
    cMes := Mes 
    nMes := val( Mes )
    
    @ 08,20 say cMes
    if nMes > 0
      @ 08,23 say aMesExt[ nMes ]
    else  
      @ 08,23 say space(9)
    endif  
  endif
  
  nValo := Valo
      
  @ 10,20 say nValo         pict '@E 999,999,999.99' 
  
  PosiDBF( 06, 62 )
return NIL

//
// Imprime dados do MeEmador
//
function PrinMeEm( lAbrir )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if lAbrir
    if NetUse( "MeEmARQ", .t. )
      VerifIND( "MeEmARQ" )

      #ifdef DBF_NTX
        set index to MeEmIND1, MeEmIND2
      #endif    
    endif
  endif  

  if NetUse( "MeReARQ", .t. )
    VerifIND( "MeReARQ" )

    #ifdef DBF_NTX
      set index to MeReIND1, MeReIND2
    #endif
  endif

  if NetUse( "ReprARQ", .t. )
    VerifIND( "ReprARQ" )
  
    #ifdef DBF_NTX
      set index to ReprIND1, ReprIND2
    #endif  
  endif

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

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 06, 24, 10, 56, mensagem( 'Janela', 'PrinMeEm', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,27 say 'Emissão Inicial ' 
  @ 09,27 say '  Emissão Final ' 

  select MeEmARQ
  set order to 1
  dbgotop ()
  
  dEmisIni := bom( date() )
  dEmisFin := eom( date() )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,43 get dEmisIni    pict '99/99/9999'
  @ 09,43 get dEmisFin    pict '99/99/9999' valid dEmisFin >= dEmisIni
  read
       
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 
  
  if lastkey () == K_ESC
    select ReprARQ
    close
    select NSaiARQ
    close
    select INSAARQ
    close
    select MeReARQ
    close
    select MeEmARQ
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
  
  aDias    := {}
  aRepr    := {}
  lInicio  := .t.
  
  nAcumDia := nAcumMedia := 0
  nMes     := month( dEmisIni )
    
  select MeEmARQ
  set order to 1
  dbseek( strzero( nMes, 2 ), .f. )

  select NSaiARQ
  set order    to 4
  set relation to Repr into ReprARQ
  dbgotop()
  do while !eof ()
    if Emis >= dEmisIni .and. Emis <= dEmisFin
      nSubTotal  := SubTotal
      nDesconto  := Desconto
      nTotalNota := nSubTotal - nDesconto

      if nSubTotal > 0  
        nElem := ascan( aDias, { |nElem| nElem[1] == strzero( day( Emis ), 2 ) } ) 
        nRepr := ascan( aRepr, { |nElem| nElem[1] == Repr } ) 
          
        if nRepr > 0
          aRepr[ nRepr, 3 ] += nTotalNota
        else
          aadd( aRepr, { Repr, ReprARQ->Nome, nTotalNota } )    
        endif     
          
        if nElem > 0
          aDias[ nElem, 3 ] += nTotalNota
        else
          aadd( aDias, { strzero( day( Emis ), 2 ), Emis, nTotalNota } )    
        endif     
      endif
    endif
    dbskip()
  enddo  
  
  asort( aDias,,, { | Dia01, Dia02 | Dia01[1] < Dia02[1] } )
  
  if len( aDias ) > 0  
    nMediaDia := MeEmARQ->Valo / len( aDias )
  endif  
      
  for nEl := 1 to len( aDias )
    if lInicio
      set printer to ( cArqu2 )
      set device  to printer
      set printer on

      lInicio := .f.
    endif  
    
    if nLin == 0
      Cabecalho( 'Metas de Vendas', 80, 3 )
      CabMeEm()
    endif
    
    nAcumDia   += aDias[ nEl, 3 ]
    nAcumMedia += nMediaDia
     
    @ nLin, 01 say aDias[ nEl, 1 ]      pict '99'
    do case
      case left( cdow( aDias[ nEl, 2 ] ), 3 ) == 'Sun'
        @ nLin, 04 say 'Dom'
      case left( cdow( aDias[ nEl, 2 ] ), 3 ) == 'Mon'
        @ nLin, 04 say 'Seg'
      case left( cdow( aDias[ nEl, 2 ] ), 3 ) == 'Tue'
        @ nLin, 04 say 'Ter'
      case left( cdow( aDias[ nEl, 2 ] ), 3 ) == 'Wed'
        @ nLin, 04 say 'Qua'
      case left( cdow( aDias[ nEl, 2 ] ), 3 ) == 'Thu'
        @ nLin, 04 say 'Qui'
      case left( cdow( aDias[ nEl, 2 ] ), 3 ) == 'Fri'
        @ nLin, 04 say 'Sex'
      case left( cdow( aDias[ nEl, 2 ] ), 3 ) == 'Sat'
        @ nLin, 04 say 'Sab'
    endcase
    @ nLin, 12 say nAcumMedia          pict '@E 999,999.99'
    @ nLin, 24 say aDias[ nEl, 3 ]      pict '@E 999,999.99'
    @ nLin, 35 say nAcumDia            pict '@E 999,999.99'
    nLin ++

    if nLin >= pLimite
      Rodape(80) 

      cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
      cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

      set printer to ( cArqu2 )
      set printer on
    endif
  next
  
  nLin ++
  @ nLin,01 say 'Vendedor                                  Meta      Valor'
  nLin += 2

  select MeReARQ
  set order to 1

  for nL := 1 to len( aRepr )
    dbseek( strzero( nMes, 2 ) + aRepr[ nL, 1 ], .f. )
    
    @ nLin,001 say aRepr[ nL, 1 ]
    @ nLin,008 say aRepr[ nL, 2 ]     pict '@S28'
    @ nLin,037 say MeReARQ->Valo      pict '@E 999,999.99'
    @ nLin,048 say aRepr[ nL, 3 ]     pict '@E 999,999.99'
    nLin ++
  next
  
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
      replace Titu       with "Relatório de Metas de Vendas"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      replace Empr       with cEmpresa
      dbunlock ()
    endif
  endif  

  select ReprARQ
  close
  select MeReARQ
  close
  select MeEmARQ
  if lAbrir
    close
  else
    set order to 1
    dbgobottom ()
  endif
  restscreen( 00, 00, 23, 79, tPrt )
  return NIL
return NIL

function CabMeEm ()
  @ 02,01 say 'Mês ' + aMesExt[ nMes ]
  @ 02,20 say 'Meta/Mês' + transform( MeEmARQ->Valo, '@E 999,999.99' )
  @ 02,40 say 'Meta/Dia' + transform( MeEmARQ->Valo / len( aDias ), '@E 999,999.99' )
  @ 03,01 say 'Dia              Meta        Real  Acumulado'
                 
  nLin := 5
retur NIL