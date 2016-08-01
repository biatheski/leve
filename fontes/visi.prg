//  Leve, Controle de Visitas
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

function Visi( xAlte )

if NetUse( "ClieARQ", .t. )
  VerifIND( "ClieARQ" )
  
  lOpenClie := .t.
 
  #ifdef DBF_NTX
    set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
  #endif  
else
  lOpenClie := .f.
endif

if NetUse( "VisiARQ", .t. )
  VerifIND( "VisiARQ" )
  
  lOpenVisi := .t.
 
  #ifdef DBF_NTX
    set index to VisiIND1, VisiIND2
  #endif  
else
  lOpenVisi := .f.
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

//  Variaveis de Entrada para Visita
nClie := nRepr     := 0
cClie := cRepr     := cHora  := space(04)
dData := date()
cObs1 := cObs2     := cObs3  := space(60)
cCliente := space(40)

//  Tela Clieesa
Janela ( 06, 11, 17, 65, mensagem( 'Janela', 'Visi', .f. ), .t. )

setcolor ( CorJanel )
@ 08,13 say '      Data                          Hora '
@ 09,13 say '  Vendedor'
@ 10,13 say '   Cliente'

@ 12,13 say 'Observação'

MostOpcao( 16, 13, 25, 41, 54 ) 
tVisi := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Visitas
select VisiARQ
set order to 1
if !xAlte
  dbgobottom ()
endif  
do while .t.
  Mensagem ( 'Visi','Janela')
  
  select ClieARQ
  set order to 1
  
  select ReprARQ
  set order to 1
  
  select VisiARQ
  set order    to 1
  set relation to Clie into ClieARQ, to Repr into ReprARQ

  restscreen( 00, 00, 23, 79, tVisi )
  cStat := space(04)

  MostVisi()
    
  if Demo()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostVisi'
  cAjuda   := 'Visi'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
   
  @ 08,24 get dData       pict '99/99/9999'
  @ 08,54 get cHora       pict '99:99'
  @ 09,24 get nRepr       pict '999999'     valid ValidARQ( 09, 24, "VisiARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nRepr", .t., 6, "Consulta de Vendedores", "ReprARQ", 30 )
  @ 10,24 get nClie       pict '999999'     valid ValidClie( 10, 24, "VisiARQ", , , .t. )
  read
    
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. nClie == 0
    exit
  endif
  
  cClie := strzero( nClie, 6 )
  cRepr := strzero( nRepr, 6 )

  //  Verificar existencia da Visita para Incluir ou Alterar
  select VisiARQ
  set order to 1
  dbseek( dtos( dData ) + cHora + cRepr + cClie, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif

  Mensagem ('Visi',cStat)
  
  vStatAnt := cStat
  
  MostVisi()
  EntrVisi()

  Confirmar( 16, 13, 25, 41, 54, 3 ) 
  
  if cStat == 'excl'
    ExclRegi ()
  endif

  if cStat == 'prin'
    ImprVisi (.f.)
  endif

  cStat := vStatAnt
  
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Clie       with cClie
        replace Cliente    with cCliente
        replace Repr       with cRepr
        replace Data       with dData
        replace Hora       with cHora
        dbunlock ()
      endif
    endif
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Obs1       with cObs1
      replace Obs2       with cObs2 
      replace Obs3       with cObs3
      dbunlock ()
    endif
  endif
  
  if cStat == 'prin'
    PrinVisi (.f.)
  endif  
enddo

if lOpenRepr 
  select ReprARQ
  close
endif

if lOpenClie 
  select ClieARQ
  close
endif

if lOpenVisi 
  select VisiARQ
  close
endif

return NIL

//
// Entra Dados da Visita 
//
function EntrVisi()
  setcolor ( CorJanel + ',' + CorCampo )
  @ 12,24 get cObs1       pict '@S40'
  @ 13,24 get cObs2       pict '@S40'
  @ 14,24 get cObs3       pict '@S40'
  read
return NIL

//
// Mostra Dados do Cliente
//
function MostVisi()
  setcolor ( CorCampo )
  if cStat != 'incl'
    cClie := Clie
    nClie := val( Clie )
    dData := Data
    cRepr := Repr
    nRepr := val( Repr )
    cHora := Hora
    
    @ 08,24 say dData           pict '99/99/9999'
    @ 08,54 say cHora           pict '99:99'
    @ 09,24 say cRepr           pict '999999'
    @ 09,31 say ReprARQ->Nome   pict '@S33'
    @ 10,24 say cClie           pict '999999'
    if cClie == '999999'
      @ 10,31 say Cliente         pict '@S33'
    else  
      @ 10,31 say ClieARQ->Nome   pict '@S33'
    endif  
  endif
  
  cObs1 := Obs1    
  cObs2 := Obs2 
  cObs3 := Obs3
  
  @ 12,24 say cObs1       pict '@S40'
  @ 13,24 say cObs2       pict '@S40'
  @ 14,24 say cObs3       pict '@S40'
  
  PosiDBF( 06, 65 )
return NIL

//
// Imprimir Visitas 
//
function PrinVisi ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )

    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
    #endif  
  endif

  if NetUse( "VisiARQ", .t. )
    VerifIND( "VisiARQ" )

    #ifdef DBF_NTX
      set index to VisiIND1, VisiIND2
    #endif  
  endif

  if NetUse( "ReprARQ", .t. )
    VerifIND( "ReprARQ" )

    #ifdef DBF_NTX
      set index to ReprIND1, ReprIND2
    #endif  
  endif

  tPrt := savescreen( 00, 00, 23, 79 )
    
  //  Define Intervalo
  Janela ( 07, 08, 12, 65, mensagem( 'Janela','PrinVisi', .f. ), .f. )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 09,10 say 'Vendedor Inicial             Vendedor Final'
  @ 10,10 say ' Cliente Inicial              Cliente Final'
  @ 11,10 say '    Data Inicial                 Data Final'

  select ReprARQ
  set order  to 1
  dbgotop ()
  nReprIni  := val( Repr )
  dbgobottom ()
  nReprFin  := val( Repr )

  select ClieARQ
  set order  to 1
  dbgotop ()
  nClieIni  := val( Clie )
  dbgobottom ()

  nClieFin  := val( Clie )
  dDataIni  := ctod ('01/01/1990')
  dDataFin  := ctod ('31/12/2010')

  setcolor ( CorJanel + ',' + CorCampo )
  @ 09,27 get nReprIni  pict '999999'       
  @ 09,54 get nReprFin  pict '999999'       
  @ 10,27 get nClieIni  pict '999999'       valid ValidClie( 99, 99, "VisiARQ", "nClieIni" )
  @ 10,54 get nClieFin  pict '999999'       valid ValidClie( 99, 99, "VisiARQ", "nClieFin" ) .and. nClieFin >= nClieIni
  @ 11,27 get dDataIni  pict '99/99/9999'
  @ 11,54 get dDataFin  pict '99/99/9999'     valid dDataFin >= dDataIni
  read

  if lastkey() == K_ESC
    select ClieARQ
    close
    select VisiARQ
    close
    select ReprARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif
   
  Aguarde ()

  nPag     := 1
  nLin     := 0
  cArqu2   := cArqu2 + "." + strzero( nPag, 3 )
  lInicio  := .t.
  cClieAnt := space(06)

  cClieIni := strzero( nClieIni, 6 )
  cClieFin := strzero( nClieFin, 6 )
  cReprIni := strzero( nReprIni, 6 )
  cReprFin := strzero( nReprFin, 6 )
  
  select VisiARQ  
  set order    to 2
  set relation to Clie into ClieARQ
  dbseek( cClieIni, .t. )
  do while Clie >= cClieIni .and. Clie <= cClieFin .and. !eof()
    if Data >= dDataIni .and. Data <= dDataFin .and.; 
      Repr >= cReprIni .and. Repr <= cReprFin
      if lInicio
        set printer to ( cArqu2 )
        set device  to printer
        set printer on
        
        lInicio := .f.
      endif
         
      if nLin == 0
        Cabecalho( 'Visitas', 80, 1 )
        CabVisi()
      endif
      
      if cClieAnt != Clie
        nLin ++
        @ nLin,01 say Clie
        if Clie == '999999'
          @ nLin,08 say Cliente->Nome
        else  
          @ nLin,08 say ClieARQ->Nome
        endif  

        nLin     ++
        cClieAnt := Clie
      endif  
      
      cObse := alltrim( Obs1 ) + ' ' + alltrim( Obs2 ) + ' ' + alltrim( Obs3 )
 
      @ nLin,006 say Data          pict '99/99/9999'
      @ nLin,017 say cObse         pict '@S60'
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
  
  if Imprimir( cArqu3, 80 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      replace Titu       with "Relatório de Visitas"
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 80
      dbunlock ()
    endif
    close
  endif  

  select ClieARQ
  close
  select ReprARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabVisi ()
  @ 02,01 say 'Clientes'
  @ 03,01 say '     Data        Observação'

  nLin     := 4
  cClieAnt := space(04)
return NIL

//
// Imprimir Visitas
//
function ImprVisi ()
/*
  if !TestPrint(1)
    return NIL
  endif  
*/  

  if ConfAlte ()

  set printer to ( HB_OSpathseparator() + "visi.txt" )
  set device to printer
  
  select VisiARQ
  
  cData := alltrim( EmprARQ->Cida ) + '(' + EmprARQ->UF + '), ' +;
            strzero( day( dData ), 2 ) + ' de ' + alltrim( aMesExt[ month( dData ) ] ) +;
           ' de' + str( year( dData ) )  

  setprc( 0, 0 )

  @ 00, 00 say chr(27) + "@"
  @ 00, 00 say chr(18)
//  @ 00, 00 say chr(27) + chr(67) + chr(66)

  nLin := 0
    
  @ nLin,01 say '+-----------------------------------------------------------------------------+'
  nLin ++
  @ nLin,01 say '| '
  @ nLin,03 say EmprARQ->Razao
  @ nLin,60 say 'Emissão ' + dtoc( dData ) + ' |'
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '| '
  @ nLin,03 say alltrim( EmprARQ->Ende ) + ' - ' +;
                alltrim( EmprARQ->Bairro ) + ' - ' +;
                alltrim( EmprARQ->Cida ) + ' - ' +; 
                EmprARQ->UF                      pict '@S58'
  @ nLin,60 say '   Hora ' + cHora + '     |'
  nLin ++
  @ nLin,01 say '|'
  @ nLin,03 say EmprARQ->Fone                    
  @ nLin,23 say EmprARQ->Fax                     
  nLin ++
  @ nLin,01 say '+-----------------------------------------------------------------------------+'
  nLin ++
  @ nLin,01 say '|  Cliente '
  if cClie == '999999'
    @ nLin,14 say VisiARQ->Cliente
  else  
    @ nLin,14 say ClieARQ->Nome 
  endif  
  @ nLin,57 say 'Codigo'
  @ nLin,64 say cClie                              pict '9999'
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '| Endereço '
  @ nLin,12 say ClieARQ->Ende
  @ nLin,60 say 'CEP'
  @ nLin,64 say ClieARQ->CEP                       pict '99999-999'
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '|   Bairro '
  @ nLin,12 say ClieARQ->Bair
  @ nLin,34 say 'Cidade'
  @ nLin,41 say ClieARQ->Cida                     pict '@S15'
  @ nLin,59 say 'Fone'
  @ nLin,64 say ClieARQ->Fone                     
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '+-----------------------------------------------------------------------------+'
  nLin ++
  @ nLin,01 say '|  Observação'
  @ nLin,15 say Obs1             pict '@S40'
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '|'
  @ nLin,15 say Obs2             pict '@S40'
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '|'
  @ nLin,15 say Obs3             pict '@S40'
  @ nLin,79 say '|'
  nLin ++
  @ nLin,01 say '+------+---------------------------------------------+-----------+------------+'
  nLin ++
  @ nLin,01 say '| Qtde.|Produtos/Serviços                        Cod|   P. Unit.| Valor Total|'
  nLin   ++
  for nL := 1 to 10
    @ nLin,01 say '|______|________________________________________ ____| __________| ___________|'
    nLin ++
  next  
  @ nLin,01 say '+------+---------------------------------------------+-----------+------------+'
  nLin ++ 
  @ nLin,01 say '|   Vendedor ' + alltrim( ReprARQ->Nome ) 
  @ nLin,54 say 'Valor Total  ____________|'
  nLin ++
  @ nLin,01 say '| Assinatura _________________________________________________________________|'
  nLin ++
  @ nLin,01 say '| Observação _________________________________________________________________|'
  nLin ++
  @ nLin,01 say '+-----------------------------------------------------------------------------+'
  nLin += 3
  @ nLin,00 say chr(27) + '@' 
  
  set device to screen
  
  inkey(0)
  
  endif
return NIL