//	Leve, Abertura de Ordem de Serviço
//	Copyright (C) 1992-2015 Fabiano Biatheski - biatheski@gmail.com

//	See the file LICENSE.txt, included in this distribution,
//	for details about the copyright.

//	This software is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

//	History
//	  10/09/2015 20:38 - Binho
//		Initial commit github

#include "inkey.ch"

#ifdef RDD_ADS
  #include "ads.ch" 
#endif

function AbOS ()
	if NetUse( "ReprARQ", .t. )
	  VerifIND( "ReprARQ" )
	  
	  aOpenRepr := .t.

	  #ifdef DBF_NTX
		set index to ReprIND1, ReprIND2
	  #endif  
	else
	  aOpenRepr := .f.
	endif

	if NetUse( "AbOSARQ", .t. )
	  VerifIND( "AbOSARQ" )
	  
	  aOpenAbOS := .t.

	  #ifdef DBF_NTX
		set index to AbOSIND1, AbOSIND2, AbOSIND3
	  #endif
	else
	  aOpenAbOS := .f.
	endif

	if NetUse( "ItOSARQ", .t. )
	  VerifIND( "ItOSARQ" )
	  
	  aOpenItOS := .t.

	  #ifdef DBF_NTX
		set index to ItOSIND1
	  #endif
	else
	  aOpenItOS := .f.
	endif

	if NetUse( "ClieARQ", .t. )
	  VerifIND( "ClieARQ" )
	  
	  aOpenClie := .t.
	  
	  #ifdef DBF_NTX
		set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
	  #endif
	else  
	  aOpenClie := .f.
	endif

	if NetUse( "ProdARQ", .t. )
	  VerifIND( "ProdARQ" )
	  
	  aOpenProd := .t.
	  
	  #ifdef DBF_NTX
		set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
	  #endif
	else
	  aOpenProd := .f.	
	endif

	if NetUse( "IProARQ", .t. ) 
	  VerifIND( "IProARQ" )
	  
	  aOpenIPro := .t.

	  #ifdef DBF_NTX
		set index to IProIND1
	  #endif
	else
	  aOpenIPro := .f.	
	endif

	//	Variaveis de Entrada
	cOrdS	  := cOrdSNew	 := space(06)
	nOrdS	  := nClie		 := nPrio		:= nRepr	  := 0
	nProd	  := nPrecoVenda := nValorTotal := nTotalNota := 0
	cHoraEmis := cHoraEntr	 := cHoraTerm	:= space(05)
	dEmis	  := dEntr		 := dTerm		:= ctod('  /  /	 ')
	cClie	  := cRepr		 := cProd		:= cPlacaUF	  := space(04)
	cPlaca	  := space(10)
	cVeic	  := space(20)
	nKM		  := nPrecoCusto := 0
	cModelo	  := cNSerie	 := space(40)
	cObse	  := space(60)
	cPrio	  := cUnidade	 := space(01)
	cProduto  := cCliente	 := space(40)	  
	cApa1	  := cApa2		 := space(60)
	aOpc	  := {}
	aOpcoes	  := {}
	aArqui	  := {}
	cItOSARQ  := CriaTemp(0)
	cItOSIND1 := CriaTemp(1)
	cChave	  := "Sequ"

	aadd( aArqui, { "Sequ",		  "C", 004, 0 } )
	aadd( aArqui, { "Prod",		  "C", 006, 0 } )
	aadd( aArqui, { "Produto",	  "M", 010, 0 } )
	aadd( aArqui, { "Unidade",	  "C", 003, 0 } )
	aadd( aArqui, { "Comp",		  "N", 007, 2 } )
	aadd( aArqui, { "Altu",		  "N", 007, 2 } )
	aadd( aArqui, { "Qtde",		  "N", 012, 3 } )
	aadd( aArqui, { "PrecoVenda", "N", 015, 6 } )
	aadd( aArqui, { "PrecoCusto", "N", 015, 6 } )
	aadd( aArqui, { "Regi",		  "N", 008, 0 } )
	aadd( aArqui, { "Novo",		  "L", 001, 0 } )
	aadd( aArqui, { "Lixo",		  "L", 001, 0 } )

	dbcreate( cItOSARQ, aArqui )
	   
	if NetUse( cItOSARQ, .f., 30 )
	  cItOSTMP := alias ()
	  
	  #ifdef DBF_CDX   
		index on &cChave tag &cItOSIND1
	  #endif

	  #ifdef DBF_NTX
		index on &cChave to &cItOSIND1
		
		set index to &cItOSIND1
	  #endif
	endif

	aadd( aOpc, { ' Normal	   ', 2, 'N', 03, 50, mensagem( "AbOS", "Normal", .f. ) } )
	aadd( aOpc, { ' Eventual   ', 2, 'E', 03, 50, mensagem( "AbOS", "Eventual", .f. ) } )
	aadd( aOpc, { ' Preventiva ', 2, 'P', 03, 50, mensagem( "AbOS", "Preventiva", .f. ) } )
	aadd( aOpc, { ' Urgente	   ', 2, 'U', 03, 50, mensagem( "AbOS", "Urgente", .f. ) } )
	aadd( aOpc, { ' Garantia   ', 2, 'G', 03, 50, mensagem( "AbOS", "Garantia", .f. ) } )

	//	Tela Abertura da OS
	Janela ( 01, 05, 21, 71, mensagem( 'Janela', 'AbOS', .f. ), .t. )
	setcolor ( CorJanel + ',' + CorCampo )
	@ 03,07 say '		O.S.					 Prioridade'
	@ 04,07 say '	 Emissão							  Hora'
	@ 05,07 say '	 Cliente'
	do case
	  case EmprARQ->TipoOS == 1
		@ 06,07 say 'Equipamento'
		@ 07,07 say '	  Modelo					   N. Série'				  
	  case EmprARQ->TipoOS == 2
		@ 06,07 say '	 Veículo						  Placa'			   
		@ 07,07 say '		  KM'
	  case EmprARQ->TipoOS == 3 .or. EmprARQ->TipoOS == 4
		@ 06,07 say '  Descrição'
	endcase	 
	@ 08,07 say '	 Entrega				  Hr.	Término					Hr.'
	@ 09,07 say ' Observação'
	@ 12,05 say chr(195) + replicate( chr(196), 65 ) + chr(180)
	@ 17,05 say chr(195) + replicate( chr(196), 65 ) + chr(180)

	if EmprARQ->TipoOS == 3
	  @ 11,07 say 'Código Descrição					Qtde.	  P. Venda	  Total'
				  
	  @ 12,13 say chr(194)
	  @ 12,42 say chr(194)
	  @ 12,52 say chr(194)
	  @ 12,61 say chr(194)

	  for nY := 13 to 16
		@ nY,13 say chr(179)
		@ nY,42 say chr(179)
		@ nY,52 say chr(179)
		@ nY,61 say chr(179)
	  next	

	  @ 17,13 say chr(193)
	  @ 17,42 say chr(193) 
	  @ 17,52 say chr(193) 
	  @ 17,61 say chr(193) 
	else
	  @ 11,07 say 'Código Descrição					Qtde.	  P. Venda	  Total'
				  
	  @ 12,13 say chr(194)
	  @ 12,42 say chr(194)
	  @ 12,52 say chr(194)
	  @ 12,61 say chr(194)

	  for nY := 13 to 16
		@ nY,13 say chr(179)
		@ nY,42 say chr(179)
		@ nY,52 say chr(179)
		@ nY,61 say chr(179)
	  next	

	  @ 17,13 say chr(193)
	  @ 17,42 say chr(193) 
	  @ 17,52 say chr(193) 
	  @ 17,61 say chr(193) 
	endif

	@ 18,07 say 'Emitente'
	@ 18,53 say 'Total OS'

	setcolor ( 'n/w+' )
	@ 03,63 say chr(25)

	MostOpcao( 20, 08, 20, 46, 59 ) 
	tAbOS := savescreen( 00, 00, 23, 79 )

	//	Manutencao Cadastro de Abertura de OS
	select AbOSARQ
	set order to 1
	if aOpenAbOS
	  dbgobottom ()
	endif  
	do while .t.
	  Mensagem('AbOS', 'Janela' )
	  cStat := cStatAnt := space(4)
	  
	  select( cItOSTMP )
	  set order to 1
	  zap
	  
	  select ClieARQ
	  set order to 1
	  
	  select ReprARQ
	  set order to 1

	  select ProdARQ
	  set order to 1
	  
	  select ItOSARQ
	  set order	   to 1
	  set relation to Prod into ProdARQ
	  
	  select AbOSARQ
	  set order	   to 1
	  set relation to Clie into ClieARQ, to Repr into ReprARQ

	  restscreen( 00, 00, 23, 79, tAbOS )

	  MostAbOS()
	  
	  if Demo ()
		exit
	  endif	 

	  MostTudo := 'MostAbOS'
	  cAjuda   := 'AbOS'
	  lAjud	   := .t.
	  set key K_PGUP	  to MostrARQ()
	  set key K_PGDN	  to MostrARQ()
	  set key K_CTRL_PGUP to MostrARQ()
	  set key K_CTRL_PGDN to MostrARQ()
	  set key K_UP		  to MostrARQ()
	  
	  setcolor ( CorJanel + ',' + CorCampo )
	  @ 03,19 get nOrdS				 pict '999999' 
	  read
		   
	  set key K_PGUP	  to 
	  set key K_PGDN	  to 
	  set key K_CTRL_PGUP to 
	  set key K_CTRL_PGDN to 
	  set key K_UP		  to 

	  if lastkey() == K_ESC
		exit
	  endif
	  
	  cOrdS := strzero( nOrdS, 6 )
	  
	  //  Verificar existencia da OS para Incluir ou Alterar
	  select AbOSARQ
	  set order to 1
	  dbseek( cOrdS, .f. )
	  if eof()
		cStat :=  'incl'
	  else
		if !empty( HoraTerm ) .and. !empty( Term )
		  MostAbOS()
		  Alerta( mensagem( 'Alerta', 'AbOS', .f. ) )
		  loop
		endif
	  
		cStat :=  'alte'
	  endif

	  Mensagem ('AbOS',cStat)
	  
	  select ItOSARQ
	  set order to 1
	  dbseek( cOrdS, .t. )
	  do while OrdS == cOrdS .and. !eof ()
		nRegi := recno ()
		
		select( cItOSTMP )
		if AdiReg()
		  if RegLock()
			replace Sequ	     with ItOSARQ->Sequ
			replace Prod	     with ItOSARQ->Prod
			replace Produto    with ItOSARQ->Produto
			replace Unidade    with ItOSARQ->Unidade
			replace Qtde	     with ItOSARQ->Qtde
			replace Comp	     with ItOSARQ->Comp
			replace Altu  	   with ItOSARQ->Altu
			replace PrecoVenda with ItOSARQ->PrecoVenda
			replace PrecoCusto with ItOSARQ->PrecoCusto
			replace Regi	     with nRegi
			replace Novo	     with .f.
			replace Lixo	     with .f.
			dbunlock ()
		  endif
		endif
		
		select ItOSARQ
		dbskip ()
	  enddo
	  
	  select AbOSARQ
	  
	  oStatAux := cStat
	  
	  MostAbOS ()
	  EntrAbOS ()
	  EntrOrdS ()

	  Confirmar( 20, 08, 20, 46, 59, 1 ) 

	  if cStat == 'excl'
		EstoAbOS ()
	  endif
	  
	  if lastkey() == K_ESC .or. cStat == 'loop'
		loop
	  endif	 
	  
	  if oStatAux == 'incl'
		if nOrdS == 0
		  select EmprARQ
		  set order to 1
		  dbseek( cEmpresa, .f. )
		  
		  nOrdSNew := OrdS + 1
		  
		  do while .t.
			cOrdS := strzero( nOrdSNew, 6 )
			 
			AbOSARQ->( dbseek( cOrdS, .f. ) )
			
			if AbOSARQ->( found() ) 
			  nOrdSNew ++
			  loop
			else   
			  select EmprARQ
			  if RegLock()
				replace OrdS	   with nOrdSNew
				dbunlock ()
			  endif	 
			  exit
			endif  
		  enddo
		endif  

		select AbOSARQ
		if AdiReg()
		  if RegLock()
			replace OrdS		 with cOrdS
			dbunlock ()
		  endif
		endif
	  endif

	  if oStatAux == 'incl' .or. oStatAux == 'alte'
		if RegLock()
		  replace Prio		   with cPrio
		  replace Emis		   with dEmis
		  replace HoraEmis	 with cHoraEmis
		  replace Clie		   with cClie
		  replace Cliente	   with cCliente
		  do case 
			case EmprARQ->TipoOS == 1 .or. EmprARQ->TipoOS == 3 .or. EmprARQ->TipoOS == 4
			  replace Apa1	   with cApa1
			  replace Apa2	   with cApa2
			  replace Modelo   with cModelo
			  replace NSerie   with cNSerie
			case EmprARQ->TipoOS == 2
			  replace Placa	   with cPlaca
			  replace PlacaUF  with cPlacaUF
			  replace Veic	   with cVeic	
			  replace KM	     with nKM	   
		  endcase	 
		  replace Entr		   with dEntr
		  replace HoraEntr	 with cHoraEntr
		  replace Obse		   with cObse
		  replace Repr		   with cRepr
		  replace TotalNota	 with nTotalNota
		  dbunlock ()
		endif

		GravAbOS ()
	  endif

	  if cStat == 'prin'
		ImprAbOS (.f.)
	  endif

	  if nOrdS == 0
		Alerta( mensagem( 'Alerta', 'CodOS', .f. ) + ' ' + cOrdS )
	  endif	 
	enddo

	if aOpenAbOS
	  select AbOSARQ
	  close 
	endif

	if aOpenItOS
	  select ItOSARQ
	  close 
	endif

	if aOpenProd
	  select ProdARQ
	  close 
	endif

	if aOpenClie
	  select ClieARQ
	  close 
	endif

	if aOpenRepr
	  select ReprARQ
	  close 
	endif

	if aOpenIPro
	  select IProARQ
	  close 
	endif

	select( cItOSTMP )
	ferase( cItOSARQ )
	ferase( cItOSIND1 )
	#ifdef DBF_CDX
	  ferase( left( cItOSARQ, len( cItOSARQ ) - 3 ) + 'DBT' )
	#endif
	#ifdef DBF_NTX
	  ferase( left( cItOSARQ, len( cItOSARQ ) - 3 ) + 'FPT' )
	#endif
return NIL

//
// Entra com os dados da OS
//
function EntrAbOS ()
  local GetList := {}
  
  if cStat == 'incl'
	dEmis	  := date()
	cHoraEmis := time()
  endif
  
  nPrio := HCHOICE( aOpc, 5, nPrio )
  
  if lastkey() == K_ESC
	return NIL
  endif	 

  setcolor ( CorCampo )
  do case
	case nPrio == 1;	  @ 03,50 say ' Normal	   '
	case nPrio == 2;	  @ 03,50 say ' Eventual   '
	case nPrio == 3;	  @ 03,50 say ' Preventiva '
	case nPrio == 4;	  @ 03,50 say ' Urgente	   '
	case nPrio == 5;	  @ 03,50 say ' Garantia   '
	otherwise;			  @ 03,50 say '			   '
  endcase
  
  setcolor( CorAltKC )
  do case
	case nPrio == 1;	  @ 03,51 say 'N'
	case nPrio == 2;	  @ 03,51 say 'E'
	case nPrio == 3;	  @ 03,51 say 'P'
	case nPrio == 4;	  @ 03,51 say 'U'
	case nPrio == 5;	  @ 03,51 say 'G'
  endcase
  
  do while .t.
	lAlterou := .f.
	
	setcolor ( CorJanel + ',' + CorCampo )
	@ 04,19 get dEmis				pict '99/99/9999'
	@ 04,50 get cHoraEmis	  pict '99:99'valid ValidHora( cHoraEmis, "cHoraEmis" )
	@ 05,19 get nClie				pict '999999' valid ValidClie( 05, 19, "AbOSARQ", , , .t. )
	do case
	  case EmprARQ->TipoOS == 1
		@ 06,19 get cApa1			pict '@S45'
		@ 07,19 get cModelo		pict '@S20'	   
		@ 07,50 get cNSerie		pict '@S20'
	  case EmprARQ->TipoOS == 2
		@ 06,19 get cVeic			pict '@S18'	   
		@ 06,50 get cPlaca			
		@ 06,63 get cPlacaUF		
		@ 07,19 get nKM				pict '@E 99999,999.9'
	  case EmprARQ->TipoOS == 3 .or. EmprARQ->TipoOS == 4
		@ 06,19 get cApa1			pict '@S45'
		@ 07,19 get cApa2			pict '@S45'
	endcase	   
	@ 08,19 get dEntr				pict '99/99/9999'
	@ 08,30 get cHoraEntr		pict '99:99' valid ValidHora( cHoraEntr, "cHoraEntr" ) 
	@ 09,19 get cObse				pict '@S45'
	read
	
	if dEmis	   	 != Emis;		 lAlterou := .t.
	elseif cHoraEmis != HoraEmis;	 lAlterou := .t.
	elseif nClie	 != val( Clie ); lAlterou := .t.
	elseif cApa1	 != Apa1;		 lAlterou := .t.
	elseif cApa2	 != Apa2;		 lAlterou := .t.
	elseif cModelo	 != Modelo;		 lAlterou := .t.
	elseif cNSerie	 != NSerie;		 lAlterou := .t.
	elseif cVeic	 != Veic;		 lAlterou := .t.
	elseif cPlaca	 != Placa;		 lAlterou := .t.
	elseif cPlacaUF	 != PlacaUF;	 lAlterou := .t.
	elseif nKM		 != KM;			 lAlterou := .t.
	elseif dEntr	 != Entr;		 lAlterou := .t.
	elseif cHoraEntr != HoraEntr;	 lAlterou := .t.
	elseif cObse	 != Obse;		 lAlterou := .t.
	endif
 
	if !Saindo(lAlterou)
	  loop
	endif

	exit  
  enddo 
   
  do case
	case nPrio == 1;	  cPrio := 'N'
	case nPrio == 2;	  cPrio := 'E'
	case nPrio == 3;	  cPrio := 'P'
	case nPrio == 4;	  cPrio := 'U'
	case nPrio == 5;	  cPrio := 'G'
  endcase
  
  cClie := strzero( nClie, 6 )
return NIL

//
// Mostra dados do OS 
//
function MostAbOS ()
  if cStat != 'incl' 
	cOrdS := OrdS
	nOrdS := val( Ords )
  endif
  
  dEmis		:= Emis
  cHoraEmis := HoraEmis
  cClie		:= Clie
  nClie		:= val( Clie )
  cCliente	:= Cliente
  do case
	case EmprARQ->TipoOS == 1
	  cApa1	  := Apa1
	  cApa2	  := Apa2
	  cModelo := Modelo
	  cNSerie := NSerie
	case EmprARQ->TipoOS == 2
	  cPlaca   := Placa
	  cPlacaUF := PlacaUF
	  cVeic	   := Veic
	  nKM	   := KM
	case EmprARQ->TipoOS == 3 .or. EmprARQ->TipoOS == 4
	  cApa1	  := Apa1
	  cApa2	  := Apa2
  endcase	   

  dEntr		 := Entr
  cHoraEntr	 := HoraEntr
  cObse		 := Obse
  cRepr		 := Repr
  nRepr		 := val( Repr )
  dTerm		 := Term
  cHoraTerm	 := HoraTerm
  cPrio		 := Prio
  nTotalNota := TotalNota
  nLin		 := 13
	  
  setcolor ( CorCampo )
  do case
	case cPrio == 'N'
	  nPrio := 1

	  @ 03,50 say ' Normal	   '
	case cPrio == 'E'
	  nPrio := 2 

	  @ 03,50 say ' Eventual   '
	case cPrio == 'P'
	  nPrio := 3

	  @ 03,50 say ' Preventiva '
	case cPrio == 'U'
	  nPrio := 4

	  @ 03,50 say ' Urgente	   '
	case cPrio == 'G'
	  nPrio := 5

	  @ 03,50 say ' Garantia   '
	otherwise
	  nPrio := 1

	  @ 03,50 say '			   '
  endcase
  
  setcolor( CorAltKC )
  do case
	case cPrio == 'N';		@ 03,51 say 'N'
	case cPrio == 'E';		@ 03,51 say 'E'
	case cPrio == 'P';		@ 03,51 say 'P'
	case cPrio == 'U';		@ 03,51 say 'U'
	case cPrio == 'G';		@ 03,51 say 'G'
  endcase
  
  setcolor ( CorCampo )
  @ 04,19 say dEmis				  pict '99/99/9999'
  @ 04,50 say cHoraEmis			  pict '99:99'
  @ 05,19 say cClie				  pict '999999'
  if cClie == '999999'
	@ 05,26 say Cliente			  pict '@S38'
  else	
	@ 05,26 say ClieARQ->Nome	  pict '@S38'
  endif	 
  do case
	case EmprARQ->TipoOS == 1
	  @ 06,19 say cApa1			  pict '@S45'
	  @ 07,19 say cModelo		  pict '@S20'					
	  @ 07,50 say cNSerie		  pict '@S20'					
	case EmprARQ->TipoOS == 2
	  @ 06,19 say cVeic			  pict '@S18'					
	  @ 06,50 say cPlaca
	  @ 06,63 say cPlacaUF 
	  @ 07,19 say nKM			  pict '@E 99999,999.9'
	case EmprARQ->TipoOS == 3 .or. EmprARQ->TipoOS == 4
	  @ 06,19 say cApa1			  pict '@S45'
	  @ 07,19 say cApa2			  pict '@S45'
  endcase
  @ 08,19 say dEntr				  pict '99/99/9999'
  @ 08,30 say cHoraEntr			  pict '99:99'
  @ 08,50 say dTerm				  pict '99/99/9999'
  @ 08,61 say cHoraTerm			  pict '99:99'
  @ 09,19 say cObse				  pict '@S45'
  @ 18,16 say cRepr				  pict '999999'
  @ 18,23 say ReprARQ->Nome		  pict '@S25'
  
  setcolor( CorJanel )
  if cStat == 'alte' .or. cStat == space(04)
	for nG := 1 to 4 
	  @ nLin,07 say space(06)
	  @ nLin,14 say space(28)
	  @ nLin,43 say space(09)
	  @ nLin,53 say space(08)
	  @ nLin,62 say space(08)
	  nLin ++
	next

	nLin := 13

	select ItOSARQ
	set order	 to 1
	set relation to Prod into ProdARQ
	dbseek( cOrdS, .t. )
	do while OrdS == cOrdS .and. !eof()
	  @ nLin,07 say Prod				  pict '999999'	   

	  if EmprARQ->TipoOS == 3 
		if Prod == '999999'
		  @ nLin,14 say memoline( Produto, 16, 1 )
		else  
		  @ nLin,14 say ProdARQ->Nome		pict '@S16'
		endif  
		if EmprARQ->Inteira == "X"
		  @ nLin,43 say Qtde				pict '@E 999999999'
		else
		  @ nLin,43 say Qtde				pict '@E 99999.999'
		endif	  
		
		@ nLin,53 say PrecoVenda			pict PictPreco(8)
		@ nLin,62 say Qtde * PrecoVenda		pict '@E 9,999.99'
	  else
		if Prod == '999999'
		  @ nLin,14 say memoline( Produto, 28, 1 )
		else  
		  @ nLin,14 say ProdARQ->Nome		pict '@S28'
		endif  
		if EmprARQ->Inteira == "X"
		  @ nLin,43 say Qtde				pict '@E 999999999'
		else
		  @ nLin,43 say Qtde				pict '@E 99999.999'
		endif	  
		
		@ nLin,53 say PrecoVenda			pict PictPreco(8)
		@ nLin,62 say Qtde * PrecoVenda		pict '@E 9,999.99'
 
	  endif 

	  nLin ++
	  dbskip ()
	  if nLin >= 17
		exit
	  endif	  
	enddo
	setcolor( CorCampo )
  else
	for nG := 1 to 4  
	  @ nLin,07 say space(06)
	  @ nLin,14 say space(28)
	  @ nLin,43 say space(09)
	  @ nLin,53 say space(08)
	  @ nLin,62 say space(08)
	  nLin ++
	next
  endif	 

  setcolor( CorCampo )
  @ 18,62 say nTotalNota			 pict '@E 9,999.99'

  select AbOSARQ
  PosiDBF( 01, 71 )
return NIL

//
// Entra com os itens da OS 
//
function EntrOrdS()
  local GetList := {}

  if lastkey () == K_ESC .or. lastkey () == K_PGDN
	return NIL
  endif
	
  setcolor ( CorJanel + ',' + CorCampo )
  
  select( cItOSTMP )
  set order	   to 1
  set relation to Prod into ProdARQ

  oAbertura			:= TBrowseDB( 11, 07, 17, 69 )
  oAbertura:headsep := chr(194)+chr(196)
  oAbertura:colsep	:= chr(179)
  oAbertura:footsep := chr(193)+chr(196)

  oAbertura:addColumn( TBColumnNew("Código",	   {|| Prod } ) )

  if EmprARQ->TipoOS == 3 
	oAbertura:addColumn( TBColumnNew("Descrição", {|| iif( Prod == '999999', memoline( Produto, 15, 1 ), left( ProdARQ->Nome, 15 ) ) } ) )
	oAbertura:addColumn( TBColumnNew("Comp.",	{|| transform( Qtde, '@E 999.99' ) } ) )
	oAbertura:addColumn( TBColumnNew("Larg.",	{|| transform( Qtde, '@E 999.99' ) } ) )
  else
	oAbertura:addColumn( TBColumnNew("Descrição", {|| iif( Prod == '999999', memoline( Produto, 28, 1 ), left( ProdARQ->Nome, 28 ) ) } ) )
  endif

  if EmprARQ->Inteira == "X"
	oAbertura:addColumn( TBColumnNew("Qtde.",	{|| transform( Qtde, '@E 999999999' ) } ) )
  else	
	oAbertura:addColumn( TBColumnNew("Qtde.",	{|| transform( Qtde, '@E 99999.999' ) } ) )
  endif	 
  oAbertura:addColumn( TBColumnNew("P. Venda",	{|| transform( PrecoVenda, PictPreco(8) ) } ) )
  oAbertura:addColumn( TBColumnNew("   Total",	{|| transform( ( PrecoVenda * Qtde ), '@E 9,999.99' ) } ) )
			
  oAbertura:goBottom()

  lExitRequested := .f.
  lAlterou		 := .f.

  do while !lExitRequested 
	Mensagem ( 'LEVE','Browse')

	oAbertura:forcestable()

	if oAbertura:hitTop .and. !empty( Prod )
	  oAbertura:refreshAll ()

	  select AbOSARQ
	  
	  EntrAbOS ()
	  
	  select( cItOSTMP )
	  
	  oAbertura:down()
	  oAbertura:forcestable()
	  oAbertura:refreshall()
	  
	  loop		 
	endif
	
	if ( !lAlterou .and. cStat == 'incl' ) .or. ( oAbertura:hitbottom .and. lastkey() != K_ESC )
	  cTecla := K_INS
	else  
	  cTecla := Teclar (0)
	endif  
	
	do case
	  case cTecla == K_UP;			oAbertura:up()
	  case cTecla == K_DOWN;		oAbertura:down()
	  case cTecla == K_PGUP;		oAbertura:pageUp()
	  case cTecla == K_PGDN;		oAbertura:pageDown()
	  case cTecla == K_CTRL_PGUP;	oAbertura:goTop()
	  case cTecla == K_CTRL_PGDN;	oAbertura:goBottom()
	  case cTecla == K_ESC
		if Saindo (lAlterou)
		  lExitRequested := .t.
		else  
		  lExitRequested := .f.
		endif 
	  case cTecla == 46
		oAbertura:forcestable()
//		  oAbertura:refreshall()

		@ 18,16 get nRepr				pict '999999'  valid ValidARQ( 18, 16, "AbOSARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nRepr", .t., 6, "Consulta dos Funcionários", "ReprARQ", 25 )
		read

		cRepr		   := strzero( nRepr, 6 )
		lExitRequested := .t.
	  case cTecla == K_ENTER;			EntrItAb(.f.)
	  case cTecla == K_INS
		do while lastkey() != K_ESC	   
		  EntrItAb(.t.)
		enddo  
		
		cTecla := ""
	  case cTecla == K_DEL
		if RegLock()
		  nTotalNota -= ( Qtde * PrecoVenda )

		  setcolor( CorCampo )
		  @ 18,62 say nTotalNota	pict '@E 9,999.99'

		  replace Lixo			 with .t.

		  dbdelete ()
		  dbunlock ()
		  
		  oAbertura:refreshCurrent()  
		  oAbertura:goBottom() 
		endif  
	endcase
  enddo
return NIL	

//
// Entra intens da OS
//
function EntrItAb( lAdiciona )
  local GetList := {}
  
  if lAdiciona 
	if AdiReg()
	  if RegLock()
		replace Sequ			with strzero( recno(), 4 )
		replace Novo			with .t.
		replace Lixo			with .f.
		dbunlock ()
	  endif
	endif	 
	
	dbgobottom ()

	oAbertura:goBottom() 
	oAbertura:down()
	oAbertura:refreshAll()	

	oAbertura:forcestable()
	  
	Mensagem( 'PedF','InclIten')
  else
	Mensagem( 'PedF','AlteIten')
  endif	 

  cProd		  := Prod
  nProd		  := val( cProd )
  cProduto	  := Produto
  nQtde		  := Qtde
  nAltu		  := Altu
  nComp		  := Comp
  nPrecoVenda := PrecoVenda
  nPrecoCusto := PrecoCusto
  cUnidade	  := Unidade
  nLin		  := 12 + oAbertura:rowPos
  lIPro		  := .f.
  lAlterou	  := .t.
  
  nPrecoAnt	  := PrecoVenda
  nQtdeAnt	  := Qtde
	
  setcolor( CorCampo )
  
  if EmprARQ->TipoOS == 3  
	if Prod == '999999'
	  @ nLin,14 say memoline( Produto, 16, 1 )
	else  
	  @ nLin,14 say ProdARQ->Nome		pict '@S16'
	endif  
	@ nLin,62 say nQtde * nPrecoVenda	pict "@E 9,999.99"
  
	set key K_UP to UpNota ()
  
	setcolor ( CorJanel + ',' + CorCampo )
	@ nLin,07 get cProd			pict '@K'			 valid ValidProd( nLin, 07, cItOSTMP, 'abos', 0, 0, nPrecoVenda )
	@ nLin,25 get nComp			pict '@E 999.99'   
	@ nLin,32 get nAltu			pict '@E 999.99'  
	if EmprARQ->Inteira == "X"
	  @ nLin,43 get nQtde		pict '@E 999999999'	 valid ValidQtde( nQtde ) .and. ValidAbOS()
	else  
	  @ nLin,43 get nQtde		pict '@E 99999.999'	 valid ValidQtde( nQtde ) .and. ValidAbOS()
	endif
	@ nLin,53 get nPrecoVenda	pict PictPreco(8)
	read
  else
	if Prod == '999999'
	  @ nLin,14 say memoline( Produto, 28, 1 )
	else  
	  @ nLin,14 say ProdARQ->Nome		pict '@S28'
	endif  
	@ nLin,62 say nQtde * nPrecoVenda	pict "@E 9,999.99"
  
	set key K_UP to UpNota ()
  
	setcolor ( CorJanel + ',' + CorCampo )
	@ nLin,07 get cProd			pict '@K'			 valid ValidProd( nLin, 07, cItOSTMP, 'abos', 0, 0, nPrecoVenda )
	if EmprARQ->Inteira == "X"
	  @ nLin,43 get nQtde		pict '@E 999999999'	 valid ValidQtde( nQtde ) .and. ValidAbOS()
	else  
	  @ nLin,43 get nQtde		pict '@E 99999.999'	 valid ValidQtde( nQtde ) .and. ValidAbOS()
	endif
	@ nLin,53 get nPrecoVenda	pict PictPreco(8)
	read
  endif

  set key K_UP to
	 
  if lastkey() == K_ESC
	if lAdiciona
	  if RegLock()
		dbdelete ()
		dbunlock ()
	  endif	 
	endif  

	oAbertura:refreshCurrent()	
	return NIL
  endif	 
  
  if lIPro 
	select IProARQ
	do while Prod == cProd .and. !eof()
	  select( cItOSTMP )   

	  if RegLock()
		replace Prod			with IProARQ->CodP
		replace Produto			with IProARQ->Produto
		replace Qtde			with IProARQ->Qtde * nQtde
		replace PrecoVenda		with IProARQ->PrecoVenda
		dbunlock ()
	  endif

	  nTotalNota += ( ( nQtde * IProARQ->Qtde ) * IProARQ->PrecoVenda )
	  
	  select IProARQ
	  dbskip()
	  if Prod == cProd .and. !eof()
		select( cItOSTMP )
		if AdiReg()
		  if RegLock()
			replace Sequ		with strzero( recno(), 4 )
			replace Novo		with .t.
			replace Lixo		with .f.
			dbunlock ()
		  endif
		endif	 
		select IProARQ
	  endif
	enddo

	select( cItOSTMP )	 

	oAbertura:refreshCurrent()	
	lAlterou := .t.
  else
	if RegLock()
	  replace Prod			  with cProd
	  replace Qtde			  with nQtde
	  replace Produto		  with cProduto
	  replace PrecoVenda	  with nPrecoVenda
	  replace PrecoCusto	  with nPrecoCusto
	  replace Unidade		  with cUnidade	  
	  replace Comp			  with nComp
	  replace Altu			  with nAltu 
	  dbunlock ()
	endif
  
	oAbertura:refreshCurrent()	
  
	if !lAdiciona
	  nTotalNota -= ( nQtdeAnt * nPrecoAnt )
	  nTotalNota += ( nQtde * nPrecoVenda )
	else
	  nTotalNota += ( nQtde * nPrecoVenda )
	endif
  endif

  setcolor( CorCampo )
  @ 18,62 say nTotalNota	   pict '@E 9,999.99'
return NIL	   

//
// Verifica Composicao
//
function ValidAbOS ()
  select IProARQ
  set order to 1 
  dbseek( cProd, .t. )
  if Prod == cProd
	lIPro := .t.
	
	keyboard(chr(13))
  else	
	lIPro := .f.
  endif
  select( cItOSTMP )   
return(.t.)

//
// Excluir OS
//
function EstoAbOS ()
  cStat := 'loop' 
  lEstq := .f.

  select AbOSARQ

  if ExclRegi ()
	select ItOSARQ
	set order to 1
	dbseek( cOrdS, .t. )
	do while OrdS == cOrdS .and. !eof()
	  if RegLock()
		dbdelete ()
		dbunlock ()
	  endif
	  dbskip()
	enddo	 

	select AbOSARQ
  endif
return NIL

//
//	Grava OS
//
function GravAbOS()

  set deleted off  
  
  select( cItOSTMP )
  set order to 1 
  dbgotop ()
  do while !eof ()
	if empty( Prod )
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
	  
	  select ItOSARQ
	  if AdiReg()
		if RegLock()
		  replace OrdS		 with cOrdS
		  replace Sequ		 with &cItOSTMP->Sequ
		  replace Prod		 with &cItOSTMP->Prod
		  replace Produto	 with &cItOSTMP->Produto
		  replace Unidade	 with &cItOSTMP->Unidade
		  replace Qtde		 with &cItOSTMP->Qtde
		  replace Comp		 with &cItOSTMP->Comp
		  replace Altu		 with &cItOSTMP->Altu
		  replace PrecoVenda with &cItOSTMP->PrecoVenda
		  replace PrecoCusto with &cItOSTMP->PrecoCusto
		  dbunlock ()
		endif
	  endif	  
	else 
	  select ItOSARQ
	  go nRegi
	  if RegLock()
		replace Prod	   with &cItOSTMP->Prod
		replace Produto	   with &cItOSTMP->Produto
		replace Unidade	   with &cItOSTMP->Unidade
		replace Qtde	   with &cItOSTMP->Qtde
		replace Comp	   with &cItOSTMP->Comp
		replace Altu	   with &cItOSTMP->Altu
		replace PrecoVenda with &cItOSTMP->PrecoVenda
		replace PrecoCusto with &cItOSTMP->PrecoCusto
		dbunlock ()
	  endif	 

	  select ItOSARQ

	  if lLixo
		if RegLock()
		  dbdelete ()
		  dbunlock ()
		endif
	  endif
	endif 
	  
	select( cItOSTMP )
	dbskip ()
  enddo	 
   
  set deleted on
return NIL

//
// Relatório das Ordem de Serviço Abertas
//
function PrinAbOS ( lTipo )

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()
  
  tPrt := savescreen( 00, 00, 23, 79 )

  if NetUse( "ProdARQ", .t. )
	VerifIND( "ProdARQ" )
  
	rOpenProd := .t.
  
	#ifdef DBF_NTX
	  set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
	#endif	
  else
	rOpenProd := .f.  
  endif

  if NetUse( "ClieARQ", .t. )
	VerifIND( "ClieARQ" )
   
	rOpenClie := .t.
   
	#ifdef DBF_NTX
	  set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
	#endif	
  else
	rOpenClie := .f.  
  endif

  if NetUse( "ReprARQ", .t. )
	VerifIND( "ReprARQ" )
   
	rOpenRepr := .t.
   
	#ifdef DBF_NTX
	  set index to ReprIND1, ReprIND2
	#endif	
  else
	rOpenClie := .f.  
  endif

  if NetUse( "EnOSARQ", .t. )
	VerifIND( "EnOSARQ" )
  
	rOpenEnOS := .t.
  
	#ifdef DBF_NTX
	  set index to EnOSIND1
	#endif	
  else
	rOpenEnOS := .f.  
  endif

  if NetUse( "AbOSARQ", .t. )
	VerifIND( "AbOSARQ" )
  
	rOpenAbOS := .t.
  
	#ifdef DBF_NTX
	  set index to AbOSIND1
	#endif	
  else
	rOpenAbOS := .f.  
  endif

  if NetUse( "ItOSARQ", .t. )
	VerifIND( "ItOSARQ" )
  
	rOpenItOS := .t.
  
	#ifdef DBF_NTX
	  set index to ItOSIND1
	#endif	
  else
	rOpenItOS := .f.  
  endif

  if NetUse( "IEnOARQ", .t. )
	VerifIND( "IEnOARQ" )
  
	rOpenIEnO := .t.
   
	#ifdef DBF_NTX
	  set index to IEnOIND1
	#endif	
  else
	rOpenIEnO := .f.  
  endif

  Janela( 07, 12, 17, 67, mensagem( 'Janela', 'PrinAbOS', .f. ), .f. ) 

  setcolor( CorJanel + ',' + CorCampo )
  @ 09,14 say '	   O.S. Inicial				    O.S. Final'
  @ 10,14 say ' Cliente Inicial			   Cliente Final'		   
  @ 11,14 say ' Emissão Inicial  	     Emissão Final'  
  @ 12,14 say ' Entrega Inicial			   Entrega Final'  
  @ 13,14 say 'Emitente Inicial			  Emitente Final'		   
  
  @ 15,14 say '		 Prioridade '
  @ 16,14 say '		  Relatório '
 
  setcolor( 'n/w+' )
  @ 15,44 say chr(25)

  setcolor( CorCampo )
  @ 15,31 say ' Todas	   '
  @ 16,31 say ' Quantitativo '
  @ 16,46 say ' Discriminado '
  
  setcolor( CorAltKC )
  @ 15,32 say 'T'
  @ 16,32 say 'Q'
  @ 16,47 say 'D'
  
  select ReprARQ
  set order to 1
  dbgotop ()
  nReprIni := val( Repr )
  dbgobottom()
  nReprFin := val( Repr )

  select ClieARQ
  set order to 1
  dbgotop ()
  nClieIni := val( Clie )
  dbgobottom()
  nClieFin := val( Clie )
  
  select AbOSARQ
  set order to 1
  dbgotop ()
  nOrdSIni := val( OrdS )  
  dEmisIni := ctod('01/01/1990')
  dEntrIni := ctod('01/01/1990')
  dbgobottom ()
  nOrdSFin := val( OrdS )  
  dEmisFin := ctod('31/12/2015')
  dEntrFin := ctod('31/12/2015')
  
  nPrio	   := 6
  nTipo	   := 1
  aOpc	   := {}
  aTip	   := {}

  aadd( aOpc, { ' Normal	 ', 2, 'N', 15, 31, mensagem( "AbOS", "Normal", .f. ) } )
  aadd( aOpc, { ' Eventual	 ', 2, 'E', 15, 31, mensagem( "AbOS", "Eventual", .f. ) } )
  aadd( aOpc, { ' Preventiva ', 2, 'P', 15, 31, mensagem( "AbOS", "Preventiva", .f. ) } )
  aadd( aOpc, { ' Urgente	 ', 2, 'U', 15, 31, mensagem( "AbOS", "Urgente", .f. ) } )
  aadd( aOpc, { ' Garantia	 ', 2, 'G', 15, 31, mensagem( "AbOS", "Garantia", .f. ) } )
  aadd( aOpc, { ' Todas		 ', 2, 'T', 15, 31, mensagem( "AbOS", "Todas", .f. ) } )

  aadd( aTip, { ' Quantitativo ', 2, 'Q', 16, 31, mensagem( "AbOS", "PrinAbOS1", .f. ) } )
  aadd( aTip, { ' Discriminado ', 2, 'D', 16, 46, mensagem( "AbOS", "PrinAbOS2", .f. ) } )
	
  @ 09,31 get nOrdSIni			   pict '999999'
  @ 09,56 get nOrdSFin			   pict '999999'   valid nOrdSFin >= nOrdSIni
  @ 10,31 get nClieIni			   pict '999999'   valid ValidClie( 99, 99, "AbOSARQ", "nClieIni" )
  @ 10,56 get nClieFin			   pict '999999'   valid ValidClie( 99, 99, "AbOSARQ", "nClieFin" ) .and. nClieFin >= nClieIni
  @ 11,31 get dEmisIni			   pict '99/99/9999'
  @ 11,56 get dEmisFin			   pict '99/99/9999' valid dEmisFin >= dEmisIni
  @ 12,31 get dEntrIni			   pict '99/99/9999'
  @ 12,56 get dEntrFin			   pict '99/99/9999' valid dEntrFin >= dEntrIni
  @ 13,31 get nReprIni			   pict '999999'   valid ValidARQ( 99, 99, "AbOSARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprIni", .t., 6, "Consulta dos Vendedores", "ReprARQ", 40 )
  @ 13,56 get nReprFin			   pict '999999'   valid ValidARQ( 99, 99, "AbOSARQ", "Código" , "Repr", "Descrição", "Nome", "Repr", "nReprFin", .t., 6, "Consulta dos Vendedores", "ReprARQ", 40 ) .and. nReprFin >= nReprIni
  read
  
  if lastkey () == K_ESC
	select EnOSARQ
	close
	select ItOSARQ
	close
	select ReprARQ
	close
	select ClieARQ
	close
	select IEnOARQ
	close
	select AbOSARQ
	close
	select ProdARQ
	close
	restscreen( 00, 00, 23, 79, tPrt )
	return NIL
  endif	 
  
  nPrio := HCHOICE( aOpc, 6, nPrio )
  
  if lastkey () == K_ESC
	select EnOSARQ
	close
	select ItOSARQ
	close
	select ReprARQ
	close
	select ClieARQ
	close
	select IEnOARQ
	close
	select AbOSARQ
	close
	select ProdARQ
	close
	restscreen( 00, 00, 23, 79, tPrt )
	return NIL
  endif	 

  nTipo := HCHOICE( aTip, 2, nTipo )
  
  if lastkey () == K_ESC
	select EnOSARQ
	close
	select ItOSARQ
	close
	select ReprARQ
	close
	select ClieARQ
	close
	select IEnOARQ
	close
	select AbOSARQ
	close
	select ProdARQ
	close
	restscreen( 00, 00, 23, 79, tPrt )
	return NIL
  endif	 

  Aguarde ()  

  nPag	   := 1
  nLin	   := 0
  cArqu2   := cArqu2 + "." + strzero( nPag, 3 )
  lInicio  := .t.

  cOrdSIni := strzero( nOrdSIni, 6 )
  cOrdSFin := strzero( nOrdSFin, 6 )
  cReprIni := strzero( nReprIni, 6 )
  cReprFin := strzero( nReprFin, 6 )
  cClieIni := strzero( nClieIni, 6 )
  cClieFin := strzero( nClieFin, 6 )
  cReprAnt := space(06)
  nNormal  := nEventual := nPreventiva := nUrgente := nGarantia := 0

  do case 
	case nPrio == 1;	  cPrio := 'N'
	case nPrio == 2;	  cPrio := 'E'
	case nPrio == 3;	  cPrio := 'P'
	case nPrio == 4;	  cPrio := 'U'
	case nPrio == 5;	  cPrio := 'G'
	case nPrio == 6;	  cPrio := 'T'
  endcase					
  
  if nTipo == 2
	select AbOSARQ
	set order	 to 1
	set relation to Repr into ReprARQ, to Clie into ClieARQ
	dbseek( cOrdSIni, .t. )
	do while OrdS >= cOrdSIni .and. OrdS <= cOrdSFin
	  if Clie >= cClieIni .and. Clie <= cClieFin .and.;
		Repr >= cReprIni .and. Repr <= cReprFin .and.;
		Emis >= dEmisIni .and. Emis <= dEmisFin .and.;
		Entr >= dEntrIni .and. Entr <= dEntrFin .and.;
		empty( Term )
		 
		if cPrio != 'T'
		  if cPrio != Prio
			dbskip()
			loop
		  endif
		endif
	   
		if lInicio 
		  set printer to ( cArqu2 )
		  set device  to printer
		  set printer on
	
		  lInicio := .f.
		endif  
	 
		if nLin == 0
		  Cabecalho( 'Ordem de Serviço - Aberta', 132, 3 )
		  CabAbOS(nTipo)
		endif
	  
		if cReprAnt != Repr
		  if cReprAnt != space(06)
		   nLin ++
		   @ nLin,006 say 'Total OS'
		   @ nLin,015 say strzero( nNormal + nEventual + nPreventiva + nUrgente, 3 )  
		   @ nLin,023 say strzero( nNormal, 3 ) + ' Normal '
		   @ nLin,035 say strzero( nEventual, 3 ) + ' Eventual '
		   @ nLin,049 say strzero( nPreventiva, 3 ) + ' Preventiva '
		   @ nLin,066 say strzero( nUrgente, 3 ) + ' Urgente '
		   @ nLin,079 say strzero( nGarantia, 3 ) + ' Garantia '		
		  
		   nNormal	:= nEventual := nPreventiva := nUrgente := nGarantia := 0
		   nLin		+= 2 

		   if nLin >= pLimite
			 Rodape(132) 
 
			 cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
			 cArqu2 := cArqu2 + "." + strzero( nPag, 3 )
  
			 set printer to ( cArqu2 )
			 set printer on

			 Cabecalho( 'Ordem de Servico - Aberta', 132, 3 )
			 CabAbOS(nTipo)
		   endif
		 endif
		
		 cReprAnt := Repr
		  
		 @ nLin,001 say Repr		   pict '999999'
		 @ nLin,008 say ReprARQ->Nome
		 nLin ++
	   endif  
	  
	   @ nLin,006 say OrdS				   pict '999999'
	   do case
		 case Prio == 'N'
		   @ nLin,013 say 'Normal'
		 
		   nNormal ++
		 case Prio == 'E'
		   @ nLin,013 say 'Eventual'
		  
		   nEventual ++
		 case Prio == 'P'
		   @ nLin,013 say 'Preventiva'
		  
		   nPreventiva ++
		 case Prio == 'U'
		   @ nLin,013 say 'Urgente'
		  
		   nUrgente ++
		 case Prio == 'G'
		   @ nLin,013 say 'Garantia'
		   
		   nGarantia ++
	   endcase	  

	   @ nLin,024 say Emis				   pict '99/99/9999' 
	   @ nLin,035 say HoraEmis			   pict '99:99'
	   if Clie == '999999'
		 @ nLin,041 say Cliente			   pict '@S16'
	   else	 
		 @ nLin,041 say ClieARQ->Nome	   pict '@S16'
	   endif  
	   @ nLin,058 say Clie				   pict '999999'
	   do case
		 case EmprARQ->TipoOS == 1 .or. EmprARQ->TipoOS == 3
		   @ nLin,067 say Apa1										pict '@S25' 
		 case EmprARQ->TipoOS == 2
		   @ nLin,067 say alltrim( Veic ) + ' ' + alltrim( Placa )	pict '@S25'
	   endcase	   
	  
	   lVez := .t.
			
	   select ItOSARQ
	   set order to 1
	   set relation to Prod into ProdARQ
	   dbseek( AbOSARQ->Ords, .t. )
	   do while OrdS == AbOSARQ->Ords
		 if Prod == '999999'
		   @ nLin,093 say memoline( Produto, 15, 1 ) + ' ' + Prod
		 else  
		   @ nLin,093 say left( ProdARQ->Nome, 15 ) + ' ' + Prod
		 endif	
		
		 if lVez
		   @ nLin,116 say AbOSARQ->Entr					pict '99/99/9999' 
		   @ nLin,127 say AbOSARQ->HoraEmis				pict '99:99'
			
		   lVez := .f.
		 endif

		 nLin ++
		  
		 if nLin >= pLimite
		   Rodape(132) 
  
		   cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
		   cArqu2 := cArqu2 + "." + strzero( nPag, 3 )
 
		   set printer to ( cArqu2 )
		   set printer on
	
		   Cabecalho( 'Ordem de Serviço - Aberta', 132, 3 )
		   CabAbOS(nTipo)
		  
		   select AbOSARQ

		   cReprAnt := Repr
		
		   @ nLin,001 say Repr			 pict '999999'
		   @ nLin,008 say ReprARQ->Nome
		   nLin ++
		   @ nLin,006 say OrdS				   pict '999999'
		   do case
			 case Prio == 'N';			@ nLin,013 say 'Normal'
			 case Prio == 'E';			@ nLin,013 say 'Eventual'
			 case Prio == 'P';			@ nLin,013 say 'Preventiva'
			 case Prio == 'U';			@ nLin,013 say 'Urgente'
			 case Prio == 'G';			@ nLin,013 say 'Garantia'
		   endcase	  
	 
		   @ nLin,024 say Emis				   pict '99/99/9999' 
		   @ nLin,033 say HoraEmis			   pict '99:99'
		   if Clie == '999999'
			 @ nLin,039 say Cliente			   pict '@S16'
		   else	 
			 @ nLin,039 say ClieARQ->Nome	   pict '@S16'
		   endif  
		   @ nLin,056 say Clie				   pict '999999'
		   do case
			 case EmprARQ->TipoOS == 1 .or. EmprARQ->TipoOS == 3
			   @ nLin,067 say Apa1										pict '@S24' 
			 case EmprARQ->TipoOS == 2
			   @ nLin,067 say alltrim( Veic ) + ' ' + alltrim( Placa )	pict '@S24' 
		   endcase	   
			
		   lVez := .t.
		 endif
		
		 select ItOSARQ	 
		 dbskip ()
	   enddo
	  
	   nLin ++
	  
	   select AbOSARQ
	  
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
	  @ nLin,006 say 'Total OS'
	  @ nLin,015 say strzero( nNormal + nEventual + nPreventiva + nUrgente + nGarantia, 3 )	 
	  @ nLin,023 say strzero( nNormal, 3 ) + ' Normal '
	  @ nLin,035 say strzero( nEventual, 3 ) + ' Eventual '
	  @ nLin,049 say strzero( nPreventiva, 3 ) + ' Preventiva '
	  @ nLin,066 say strzero( nUrgente, 3 ) + ' Urgente '
	  @ nLin,079 say strzero( nGarantia, 3 ) + ' Garantia '		   

	  Rodape(132)
	endif  
  else
	aVendedor	:= {}
	nNormal		:= 0
	nEventual	:= 0
	nPreventiva := 0
	nUrgente	:= 0
	nGarantia	:= 0
  
	select ReprARQ
	set order to 1
	dbseek( cReprIni, .t. )
	do while Repr >= cReprIni .and. Repr <= cReprFin .and. !eof ()
	  aadd( aVendedor, { Repr, Nome, 0, 0, 0, 0, 0 } )
	  dbskip ()
	enddo
	
	select AbOSARQ
	set order	 to 1
	set relation to Repr into ReprARQ, to Clie into ClieARQ
	dbseek( cOrdSIni, .t. )
	do while OrdS >= cOrdSIni .and. OrdS <= cOrdSFin
	  if Clie >= cClieIni .and. Clie <= cClieFin .and.;
		Repr  >= cReprIni .and. Repr <= cReprFin .and.;
		Emis  >= dEmisIni .and. Emis <= dEmisFin .and.;
		Entr  >= dEntrIni .and. Entr <= dEntrFin .and.;
		empty( Term )
		 
		if cPrio != 'T'
		  if cPrio != Prio
			dbskip()
			loop
		  endif
		endif
   
		nAchou := ascan( aVendedor, { |nElem| nElem[1] == Repr } )
	  
		if nAchou > 0
		  do case
			case Prio == 'N';			   aVendedor[ nAchou, 3 ] ++
			case Prio == 'E';			   aVendedor[ nAchou, 4 ] ++
			case Prio == 'P';			   aVendedor[ nAchou, 5 ] ++
			case Prio == 'U';			   aVendedor[ nAchou, 6 ] ++
			case Prio == 'G';			   aVendedor[ nAchou, 7 ] ++
		  endcase	 
		endif  
	  endif 
	  dbskip ()
	enddo
	
	for nH := 1 to len( aVendedor )
	  if ( aVendedor[ nH, 3 ] + aVendedor[ nH, 4 ] + aVendedor[ nH, 5 ] +;
		 aVendedor[ nH, 6 ] + aVendedor[ nH, 7 ] ) == 0
		loop
	  endif
	   
	  if lInicio 
		set printer to ( cArqu2 )
		set device	to printer
		set printer on
	
		lInicio := .f.
	  endif	 
		
	  if nLin == 0
		Cabecalho( 'Ordem de Servico - Aberta', 132, 3 )
		CabAbOS(nTipo)
	  endif

	  @ nLin,001 say aVendedor[ nH, 1 ]			   pict '999999'
	  @ nLin,008 say aVendedor[ nH, 2 ]			   
	  @ nLin,051 say aVendedor[ nH, 3 ]			   pict '999'
	  @ nLin,061 say aVendedor[ nH, 4 ]			   pict '999'
	  @ nLin,073 say aVendedor[ nH, 5 ]			   pict '999'
	  @ nLin,082 say aVendedor[ nH, 6 ]			   pict '999'
	  @ nLin,092 say aVendedor[ nH, 7 ]			   pict '999'
	  @ nLin,098 say aVendedor[ nH, 3 ] + ;
					 aVendedor[ nH, 4 ] + ;
					 aVendedor[ nH, 5 ] + ;
					 aVendedor[ nH, 6 ] + ;
					 aVendedor[ nH, 7 ]			   pict '9999'

	  nLin		  ++
	  nNormal	  += aVendedor[ nH, 3 ]				  
	  nEventual	  += aVendedor[ nH, 4 ]				  
	  nPreventiva += aVendedor[ nH, 5 ]				  
	  nUrgente	  += aVendedor[ nH, 6 ]				  
	  nGarantia	  += aVendedor[ nH, 7 ]				  
					 
	  if nLin >= pLimite
		Rodape(132) 

		cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
		cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

		set printer to ( cArqu2 )
		set printer on
	  endif
	next

	if !lInicio
	  nLin ++
	  @ nLin,006 say 'Total OS'
	  @ nLin,015 say strzero( nNormal + nEventual + nPreventiva + nUrgente + nGarantia, 3 )	 
	  @ nLin,023 say strzero( nNormal, 3 ) + ' Normal '
	  @ nLin,035 say strzero( nEventual, 3 ) + ' Eventual '
	  @ nLin,049 say strzero( nPreventiva, 3 ) + ' Preventiva '
	  @ nLin,066 say strzero( nUrgente, 3 ) + ' Urgente '		 
	  @ nLin,079 say strzero( nGarantia, 3 ) + ' Garantia '		   

	  Rodape(132)
	endif  
  endif	 
 
  set printer to
  set printer off
  set device  to screen

  if Imprimir( cArqu3, 132 )
	select SpooARQ
	if AdiReg()
	  replace Rela		 with cArqu3
	  if nTipo == 1
		replace Titu	 with "Relatório de Ordem Serviço Abertas - Quantitativo"
	  else	
		replace Titu	 with "Relatório de Ordem Serviço Abertas - Discriminado"
	  endif	 
	  replace Data		 with cRData
	  replace Hora		 with cRHora
	  replace Usua		 with cUsuario
	  replace Tama		 with 132
	  replace Empr		 with cEmpresa
	  dbunlock ()
	endif  
	close
  endif

  select EnOSARQ
  close
  select ItOSARQ
  close
  select ClieARQ
  close
  select IEnOARQ
  close
  select ReprARQ
  close
  select AbOSARQ
  close
  select ProdARQ
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabAbOS (nTipo)
  @ 02,01 say 'Emissao ' + dtoc( dEmisIni ) + ' a ' + dtoc( dEmisFin )
  @ 02,41 say 'Entrega ' + dtoc( dEntrIni ) + ' a ' + dtoc( dEntrFin )
  if nTipo == 2
	@ 03,01 say 'Emitente'
	do case
	  case EmprARQ->TipoOS == 1
		@ 04,01 say '	  O.S.	 Prioridade Emissão	  Hora	Cliente					  Equipamento				Descrição			  Entrega	 Hora  '
	  case EmprARQ->TipoOS == 2
		@ 04,01 say '	  O.S.	 Prioridade Emissão	  Hora	Cliente					  Veiculo - Placa			Descrição			  Entrega	 Hora  '
	  case EmprARQ->TipoOS == 3
		@ 04,01 say '	  O.S.	 Prioridade Emissão	  Hora	Cliente					  Descricao					Descrição			  Entrega	 Hora  '
	endcase	   
	nLin	 := 6
	cReprAnt := space(04)
  else
	@ 03,01 say 'Cod Nome									   Normal  Eventual	 Preventiva	 Urgente  Garantia	Total'	
	
	nLin := 5
  endif	 
return NIL

//
//	Consulta de OS Abertas e Encerradas
//
function ConsOrdS ()

  local cCorAtual := setcolor()

  if NetUse( "ProdARQ", .t. )
	VerifIND( "ProdARQ" )

	tOpenProd := .t.
	
	#ifdef DBF_NTX 
	  set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
	#endif	
  else	
	tOpenProd := .f.
  endif
  
  if NetUse( "AbOSARQ", .t. )
	VerifIND( "AbOSARQ" )
   
	tOpenAbOS := .t.

	#ifdef DBF_NTX 
	  set index to AbOSIND1, AbOSIND2, AbOSIND3
	#endif
  else
	tOpenAbOS := .f.
  endif

  if NetUse( "ItOSARQ", .t. )
	VerifIND( "ItOSARQ" )
  
	tOpenItOS := .t.
  
	#ifdef DBF_NTX 
	  set index to ItOSIND1
	#endif
  else 
	tOpenItOS := .f.  
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
 
  cClie	  := ClieARQ->Clie
  pNome	  := ClieARQ->Nome
  tTelaOS := savescreen( 00, 00, 23, 79 )
  aOpOS	  := {}

  Janela( 09, 30, 14, 48, mensagem( 'Janela', 'ConsOrdS', .f. ), .f. )
  Mensagem( 'AbOS','ConsAbOS')

  aadd( aOpOS, { ' Aberta		 ', 2, 'A', 11, 32, "Consulta somente as ordem de serviços abertas." } )
  aadd( aOpOS, { ' Encerrada	 ', 2, 'E', 12, 32, "Consulta somente as ordem de serviços encerradas." } )
  aadd( aOpOS, { ' Procurar...	 ', 2, 'E', 13, 32, "Consultar Ordem de Servico." } )

  nTipo := HCHOICE( aOpOS, 3, 1 )
  
  if lastkey() == K_ESC .or. nTipo == 0
	restscreen( 00, 00, 23, 79, tTelaOS ) 
	if tOpenProd
	  select ProdARQ
	  close
	endif  
	if tOpenAbOS 
	  select AbOSARQ
	  close
	endif  
	if tOpenRepr 
	  select ReprARQ
	  close
	endif  
	
	select ClieARQ
	set order to 2
	dbseek( pNome, .f. )

	return NIL
  endif	 
  
  do case
	case nTipo == 1
	  dTermIni := dtos( ctod('	/  /  ') )
	  dTermFin := dtos( ctod('	/  /  ') )
	case nTipo == 2	  
	  dTermIni := dtos( ctod('01/01/1990') )
	  dTermFin := dtos( ctod('31/12/2015') )
	case nTipo == 3
	  Janela( 13, 20, 17, 70, mensagem( 'Janela', 'ConsOrdS', .f. ), .f. )
	  do case
		case EmprARQ->TipoOS == 1 
		  setcolor( CorJanel )
		  @ 15,22 say 'Equipamento'
		  @ 16,22 say '	  	Modelo				N. Série'
	  
		  cEquip  := space(40)
		  cModelo := space(30)
		  cNSerie := space(30)
	  
		  @ 15,34 get cEquip		pict '@S35'
		  @ 16,34 get cModelo		pict '@S11'
		  @ 16,56 get cNSerie		pict '@S13'
		  read

		  if lastkey() != K_ESC
			lFound := .f.
 
			select AbOSARQ
			set order to 1
			dbgotop()
			do while !eof()
			  if at( alltrim( cEquip ), Apa1 ) > 0			   
				lFound := .t.
			  endif
			  if at( alltrim( cModelo ), Modelo ) > 0
				lFound := .t.
			  endif
			  if at( alltrim( cNSerie ), NSerie ) > 0
				lFound := .t.
			  endif 
			  
			  if lFound 
				exit
			  endif 

			  dbskip()
			enddo
		  endif 
		case EmprARQ->TipoOS == 2
		  setcolor( CorJanel )
		  @ 15,22 say '	   Veículo				   Placa'
		  @ 16,22 say '			KM'

		  cVeic	   := space(40)
		  cPlaca   := space(10)	 
		  cPlacaUF := space(3)
		  nKm	   := 0

		  @ 15,34 get cVeic			  pict '@S10'
		  @ 15,56 get cPlaca		  pict '@S9'
		  @ 15,66 get cPlacaUF
		  @ 16,38 get nKM			  pict '@E 99999,999.9'
		  read
 
		  if lastkey() != K_ESC
			lFound := .f.
 
			select AbOSARQ
			set order to 1
			dbgotop()
			do while !eof()
			  if at( alltrim( cVeic ), Veic ) > 0			  
				lFound := .t.
			  endif
			  if at( alltrim( cPlaca ), Placa ) > 0
				lFound := .t.
			  endif
			  if at( alltrim( cPlacaUF ), PlacaUF ) > 0
				lFound := .t.
			  endif 
			  if Km == nKM
				lFound := .t.
			  endif 

			  if lFound 
				exit
			  endif 


			  dbskip()
			enddo
		  endif 
		case EmprARQ->TipoOS == 3
		  setcolor( CorJanel )
		  @ 15,22 say '	 Descrição'
		  @ 16,22 say '			  '

		  cApar1   := space(40)
		  cApar1   := space(40)	 

		  @ 15,38 get cApar1		  pict '@S30'
		  @ 16,38 get cApar1		  pict '@S30'
		  read

		  if lastkey() != K_ESC
			lFound := .f.
 
			select AbOSARQ
			set order to 1
			dbgotop()
			do while !eof()
			  if at( alltrim( cApar1 ), Apa1 ) > 0			   
				lFound := .t.
			  endif
			  if at( alltrim( cApar2 ), Apa2 ) > 0
				lFound := .t.
			  endif

			  if lFound 
				exit
			  endif 

			  dbskip()
			enddo
		  endif 
	  endcase
	  
	  if lFound 
		cClie := Clie
	  endif		
 
	  dTermIni := dtos( ctod('01/01/1990') )
	  dTermFin := dtos( ctod('31/12/2015') )
  endcase  
  
  nAberta := nFechar := 0
  lOkey	  := .f.
  
  select AbOSARQ
  set order	   to 3
  set relation to Repr into ReprARQ
  dbseek( cClie, .t. )
  do while Clie == cClie .and. !eof()
	if empty( Term )
	  nAberta ++
	else  
	  nFechar ++
	endif  
	dbskip ()
  enddo
  
  if nTipo == 1 .and. nAberta == 0
	Alerta( mensagem( 'Alerta', 'ConsAbOS', .f. ) )
	
	lOkey := .t.
  endif 
	  
  if nTipo == 2 .and. nFechar == 0
	Alerta( mensagem( 'Alerta', 'ConsEnOS', .f. ) )

	lOkey := .t.
  endif	 
  
  if lOkey
	restscreen( 00, 00, 23, 79, tTelaOS ) 
	if tOpenProd
	  select ProdARQ
	  close
	endif  
	if tOpenAbOS 
	  select AbOSARQ
	  close
	endif  
	if tOpenRepr 
	  select ReprARQ
	  close
	endif  
	
	select ClieARQ
	set order to 2
	dbseek( pNome, .f. )

	return NIL
  endif
  
  do case
	case nTipo == 1
	  Janela ( 03, 01, 20, 74, mensagem( 'Janela', 'ConsAbOS', .f. ), .f. )

	  bFirst := {|| dbseek( cClie + dTermIni, .t. ) }
	  bLast	 := {|| dbseek( cClie + dTermFin, .t. ), dbskip(-1) }
	  bFor	 := {|| Clie == cClie .and. empty( Term ) }
	  bWhile := {|| Clie == cClie .and. empty( Term ) }
	case nTipo == 2
	  Janela ( 03, 01, 20, 74, mensagem( 'Janela', 'ConsEnOS', .f. ), .f. )

	  bFirst := {|| dbseek( cClie + dTermIni, .t. ) }
	  bLast	 := {|| dbseek( cClie + dTermFin, .t. ), dbskip(-1) }
	  bFor	 := {|| Clie == cClie .and. !empty( Term ) }
	  bWhile := {|| Clie == cClie .and. !empty( Term ) }
	case nTipo == 3
	  Janela ( 03, 01, 20, 74, mensagem( 'Janela', 'ConsEnOST', .f. ), .f. )

	  bFirst := {|| dbseek( cClie + dTermIni, .t. ) }
	  bLast	 := {|| dbseek( cClie + dTermFin, .t. ), dbskip(-1) }
	  bFor	 := {|| Clie == cClie }
	  bWhile := {|| Clie == cClie }
  endcase
  
  oOrdem		   := TBrowseFW( bWhile, bFor, bFirst, bLast )
  oOrdem:nTop	   := 7
  oOrdem:nLeft	   := 2
  oOrdem:nBottom   := 20
  oOrdem:nRight	   := 72
  oOrdem:headsep   := chr(194)+chr(196)
  oOrdem:colsep	   := chr(179)
  oOrdem:footsep   := chr(193)+chr(196)
  oOrdem:colorSpec := CorJanel

  oOrdem:addColumn( TBColumnNew("N. OS",	  {|| OrdS } ) )
  oOrdem:addColumn( TBColumnNew("Prioridade", {|| iif( Prio == 'P', 'Preventiva', +;
										 iif( Prio == 'N', 'Normal	  ', +;
										 iif( Prio == 'E', 'Eventual  ', +;
										 iif( Prio == 'U', 'Urgente	  ', +;
										 iif( Prio == 'G', 'Garantia  ', +;
										 '			' ) ) ) ) ) } ) )
  oOrdem:addColumn( TBColumnNew("Emissão",	 {|| Emis } ) )
  oOrdem:addColumn( TBColumnNew("Hora",		  {|| HoraEmis } ) )

  do case
	case EmprARQ->TipoOS == 1
	  oOrdem:addColumn( TBColumnNew("Equipamento",{|| left( Apa1, 25 ) } ) )
	case EmprARQ->TipoOS == 2
	  oOrdem:addColumn( TBColumnNew("Veiculo",	  {|| left( Veic, 25 ) } ) )
	case EmprARQ->TipoOS == 3
	  oOrdem:addColumn( TBColumnNew("Descrição",	{|| left( Apa1, 25 ) } ) )
  endcase	 

  if nTipo == 2 
	oOrdem:addColumn( TBColumnNew("Término",	   {|| Term } ) )
	oOrdem:addColumn( TBColumnNew("Hora",		{|| HoraTerm } ) )
  endif	 

  if EmprARQ->TipoOS == 2
	oOrdem:addColumn( TBColumnNew("Placa",		{|| Placa } ) )
	oOrdem:addColumn( TBColumnNew("KM",			{|| transform( KM, '@E 99999,999.9' ) } ) )
  endif	 

  oOrdem:addColumn( TBColumnNew("Entrega",	  {|| Entr } ) )
  oOrdem:addColumn( TBColumnNew("Hora",		  {|| HoraEntr } ) )
  oOrdem:addColumn( TBColumnNew("Observação", {|| left( Obse, 20 ) } ) )
  oOrdem:addColumn( TBColumnNew("Emitente",	  {|| left( ReprARQ->Nome, 20 ) + ' ' + Repr } ) )
			  
  lAdiciona		 := .f.
  lVez			 := .t.
  lExitRequested := .f.
  nLinBarra		 := 1
  nTotal		 := lastrec()
  BarraSeta		 := BarraSeta( nLinBarra, 8, 20, 74, nTotal )
  
  setcolor( CorJanel + ',' + CorCampo )
  @ 05,05 say 'Cliente'
  @ 08,01 say chr(195)
  
  setcolor( CorCampo )
  @ 05,13 say cClie		 pict '999999'
  @ 05,21 say ClieARQ->Nome

  oOrdem:refreshAll()

  do while !lExitRequested
	Mensagem( 'AbOS', 'ConsAbOS' )
	
	oOrdem:forcestable() 

	iif( BarraSeta, BarraSeta( nLinBarra, 8, 20, 74, nTotal ), NIL )
	
	if oOrdem:stable
	  if oOrdem:hitTop .or. oOrdem:hitBottom
		tone( 125, 0 )		  
	  endif	 

	  cTecla := Teclar(0)
	else
	  loop	
	endif
		
	do case
	  case cTecla == K_DOWN 
		if !oOrdem:hitBottom
		  nLinBarra ++
		  if nLinBarra >= nTotal
			nLinBarra := nTotal 
		  endif	 
		endif  
	  case cTecla == K_UP 
		if !oOrdem:hitTop
		  nLinBarra --
		  if nLinBarra < 1
			nLinBarra := 1
		  endif	 
		endif
	endcase
		
	do case
	  case cTecla == K_DOWN;	   oOrdem:down()
	  case cTecla == K_UP;		   oOrdem:up()
	  case cTecla == K_PGDN;	   oOrdem:pageDown()
	  case cTecla == K_PGUP;	   oOrdem:pageUp()
	  case cTecla == K_CTRL_PGUP;  oOrdem:goTop()
	  case cTecla == K_CTRL_PGDN;  oOrdem:gobottom()
	  case cTecla == K_LEFT;	   oOrdem:left()
	  case cTecla == K_RIGHT;	   oOrdem:right()
	  case cTecla == K_ESC;		   lExitRequested := .t.
	  case cTecla == K_ENTER;	   lExitRequested := .t.
	  case cTecla == K_ALT_A
		tAlteOS := savescreen( 00, 00, 23, 79 )
	  
		AbOS(.f.)
		
		restscreen( 00, 00, 23, 79, tAlteOS )
		
		select AbOSARQ
		set order to 3
		dbseek( cClie + dTermIni, .t. )
	 
		oOrdem:refreshAll()
	  case cTecla == K_ALT_E
		tAlteOS := savescreen( 00, 00, 23, 79 )
	  
		EnOS(.f., OrdS)
		
		restscreen( 00, 00, 23, 79, tAlteOS )
		
		select AbOSARQ
		set order to 3
		dbseek( cClie + dTermIni, .t. )
		
		oOrdem:refreshAll()
	  case cTecla == K_ALT_F
		tAlteOS	 := savescreen( 00, 00, 23, 79 )
		aDefeito := {}
		cOrdS	 := OrdS
		nItens	 := 0
			 
		aadd( aDefeito, "Produto/Serviço							  Qtde." )	   
		aadd( aDefeito, "  " )

		select ItOSARQ
		set order	 to 1
		set relation to Prod into ProdARQ
		dbseek( cOrdS, .t. )
		do while OrdS == cOrdS .and. !eof ()
		   aadd( aDefeito, iif( Prod == '999999', memoline( Produto, 33, 1 ), left( ProdARQ->Nome, 33 ) ) + "  " + transform( Qtde, '@E 9999999.99' ) )
		   nItens ++
		   dbskip ()
		 enddo

		if nItens > 0
		  tTelas := savescreen( 00, 00, 23, 79 )
  
		  Janela( 06, 15, 17, 65, mensagem( 'Janela', 'ConsOrdS2', .f. ), .f. )
		  setcolor( CorJanel + ',' + CorCampo )
	   
		   achoice( 08, 17, 16, 63, aDefeito )
	  
		   restscreen( 00, 00, 23, 79, tTelas )
		else
		  Alerta( mensagem( 'Alerta', 'ConsAbOS2', .f. ) )
		endif
		
		restscreen( 00, 00, 23, 79, tAlteOS )
		 
		select AbOSARQ
		set order to 3
		
		oOrdem:refreshAll()
	endcase
  enddo	 
  
  if tOpenAbOS 
	select AbOSARQ
	close
  endif	 

  if tOpenProd
	select ProdARQ
	close
  endif	 
  if tOpenRepr 
	select ReprARQ
	close
  endif	 
 
  select ClieARQ
  set order to 2
  dbseek( pNome, .f. )
  
  setcolor( cCorAtual )
  restscreen( 00, 00, 23, 79, tTelaOS )
return NIL

//
// Imprimir Abertura da Ordem de Serviço
//
function ImprAbOS ()

  Janela( 11, 22, 14, 49, mensagem( 'Janela', 'ImprAbOS', .f. ), .f. )
  Mensagem( 'AbOS','ImprAbOS')
  setcolor( CorJanel )
	
  aOpcs := {}
  nVias := 3
  nPrn	:= 0

  aadd( aOpcs, { ' Impressora ', 2, 'I', 13, 25, mensagem( "AbOS", "ImprAbOS1", .f. ) } )
  aadd( aOpcs, { ' Arquivo ',	 2, 'A', 13, 38, mensagem( "AbOS", "ImprAbOS2", .f. ) } )
	
  nTipoAbOS := HCHOICE( aOpcs, 2, 1 )

  if nTipoAbOS == 2
	  Janela( 05, 21, 08, 56, mensagem( 'Janela', 'ImprAbOS2', .f. ), .f. )
	  Mensagem( 'LEVE','Salvar')

	  cArqu2  := CriaTemp( 5 )
	  xArqu3  := right ( cArqu2, 8 )
  
	  cArqTxt := cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() + alltrim( xArqu3 ) + space(40)
		
	  keyboard( chr( K_END ) )

	  setcolor ( CorJanel + ',' + CorCampo )
   
	  @ 07,23 get cArqTxt			pict '@S32' 
	  read
	
	  if lastkey() == K_ESC
		return NIL
	  endif	 
  
	  set printer to ( cArqTxt )
	  set device  to printer
	  set printer on
  endif	   
	
  if nTipoAbOS == 1
	  Janela( 11, 22, 14, 52, mensagem( 'Janela', 'ImprAbOS1', .f. ), .f. )
	  setcolor( CorJanel )
	
	  aOpcs := {}

	  aadd( aOpcs, { ' 1o Via ', 2, '1', 13, 25, mensagem( "AbOS", "ImprAbOS1", .f. ) } )
	  aadd( aOpcs, { ' 2o Via ', 2, '2', 13, 34, mensagem( "AbOS", "ImprAbOS1", .f. ) } )
	  aadd( aOpcs, { ' Ambas ',	 2, 'A', 13, 43, mensagem( "AbOS", "ImprAbOS1", .f. ) } )
	
	  nVias := HCHOICE( aOpcs, 3, 3 )
	  
	  if EmprARQ->Impr == "X" 
		if !TestPrint(1)
		  return NIL
		endif  
	  else	 
		#ifdef __PLATFORM__Windows
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
		#endif
	  
	  cArqu2  := CriaTemp( 5 )
	  xArqu3  := right( cArqu2, 8 )
	  cArqTxt := cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() + alltrim( xArqu3 ) + ".txt" + space(40)
  
	  set printer to ( cArqTxt )
	  set device  to printer
	  set printer on
  
	  nTipoAbOS := 2

	  endif
	endif  

//	endif
  
  select AbOSARQ
  
  cData := alltrim( EmprARQ->Cida ) + '(' + EmprARQ->UF + '), ' +;
			strzero( day( dEmis ), 2 ) + ' de ' + alltrim( aMesExt[ month( dEmis ) ] ) +;
		   ' de' + str( year( dEmis ) )	 
	
	if nTipoAbOS == 1
	  setprc( 0, 0 )
  
	  @ 00, 00 say chr(27) + "@"
	  @ 00, 00 say chr(18)
	  @ 00, 00 say chr(27) + chr(67) + chr(66)
	endif  

	nLin := 0
	
	if nVias == 1 .or. nVias == 3
		
	@ nLin,01 say '+-----------------------------------------------------------------------------+'
	nLin ++
	@ nLin,01 say '| '
	@ nLin,03 say EmprARQ->Razao
	@ nLin,60 say 'O.S. N.'
	@ nLin,68 say cOrdS							   pict '999999'
	@ nLin,79 say '|'
	nLin ++
	@ nLin,01 say '| '
	@ nLin,03 say alltrim( EmprARQ->Ende ) + ' - ' +;
				  alltrim( EmprARQ->Bairro ) + ' - ' +;
				  alltrim( EmprARQ->Cida ) + ' - ' +; 
				  EmprARQ->UF					   pict '@S58'
	@ nLin,60 say 'Emissão ' + dtoc( dEmis ) + ' |'
	nLin ++
	@ nLin,01 say '|'
	@ nLin,03 say EmprARQ->Fone					   
	@ nLin,23 say EmprARQ->Fax					   
	@ nLin,63 say 'Hora ' + HoraEmis + '	  |'
	nLin ++
	@ nLin,01 say '+-----------------------------------------------------------------------------+'
	nLin ++
	@ nLin,01 say '|  Cliente '
	if cClie == '999999'
	  @ nLin,12 say AbOSARQ->Cliente
	else  
	  @ nLin,12 say ClieARQ->Nome 
	endif  
	@ nLin,57 say 'Codigo'
	@ nLin,64 say cClie								 pict '999999'
	@ nLin,79 say '|'
	nLin ++
	@ nLin,01 say '| Endereço '
	@ nLin,12 say ClieARQ->Ende						 pict '@S45' 
	@ nLin,60 say 'CEP'
	@ nLin,64 say ClieARQ->CEP						 pict '99999-999'
	@ nLin,79 say '|'
	nLin ++
	@ nLin,01 say '|   Bairro '
	@ nLin,12 say ClieARQ->Bair						 pict '@S20'
	@ nLin,34 say 'Cidade'
	@ nLin,41 say ClieARQ->Cida						 pict '@S15'
	@ nLin,59 say 'Fone'
	@ nLin,64 say ClieARQ->Fone						 pict '@S14'
	@ nLin,79 say '|'
	nLin ++
	@ nLin,01 say '+-----------------------------------------------------------------------------+'
	nLin ++
	do case
	  case EmprARQ->TipoOS == 1
		@ nLin,01 say '| Equipamento'
		@ nLin,15 say Apa1								
		@ nLin,79 say '|'
		nLin ++
		@ nLin,01 say '|'
		@ nLin,15 say Apa2								  
		@ nLin,79 say '|'
	  case EmprARQ->TipoOS == 2
		@ nLin,01 say '|	 Veiculo '
		@ nLin,15 say Veic
		@ nLin,39 say 'Placa'
		@ nLin,45 say Placa
		@ nLin,62 say 'KM'
		@ nLin,65 say KM		   pict '@E 99999,999.9'
		@ nLin,79 say '|'
	  case EmprARQ->TipoOS == 3
		@ nLin,01 say '|   Descricao'
		@ nLin,15 say Apa1								
		@ nLin,79 say '|'
		nLin ++
		@ nLin,01 say '|'
		@ nLin,15 say Apa2								  
		@ nLin,79 say '|'
	endcase	   
	nLin ++
	@ nLin,01 say '|  Observação '
	@ nLin,15 say Obse
	@ nLin,79 say '|'
	nLin ++
	@ nLin,01 say '|	 Entrega ' + dtoc( Entr ) + ' ' + HoraEntr + ' Hrs.'
	@ nLin,52 say 'Total Parcial ' + transform( TotalNota, "@E 999,999.99" )
	@ nLin,79 say '|'
	nLin ++ 
	@ nLin,01 say '+-----------------------------------------------------------------------------+'
	nLin ++ 
	do case
	  case EmprARQ->TipoOS == 1
		@ nLin,01 say '| Fica estipulado o prazo de 90 dias para retirado do equipamento em conserto |'
	  case EmprARQ->TipoOS == 2
		@ nLin,01 say '| Fica estipulado o prazo de 90 dias para retirado  do  veículo	em	conserto |'
	  case EmprARQ->TipoOS == 3
		@ nLin,01 say '| Fica estipulado o prazo de 90 dias para retirada							 |'
	  case EmprARQ->TipoOS == 4
		@ nLin,01 say '| Fica estipulado o prazo de 90 dias para retirada							 |'
	endcase	   
	nLin ++ 
	@ nLin,01 say '| mediante o comprovante e com juros. Após o prazo estipulado o cliente perde |'
	nLin ++ 
	@ nLin,01 say '| o direito do bem e a firma pode se desfazer do produto vendendo pelo  preço |'
	nLin ++ 
	do case
	  case EmprARQ->TipoOS == 1
		@ nLin,01 say '| de conserto. Retirada do Equipamento somente com apresentação deste.		   |'
	  case EmprARQ->TipoOS == 2
		@ nLin,01 say '| de conserto. Retirada do Veículo somente com apresentação deste.			  |'
	  case EmprARQ->TipoOS == 3
		@ nLin,01 say '| de conserto. Retirada somente com apresentação deste.					   |'
	  case EmprARQ->TipoOS == 4
		@ nLin,01 say '| de conserto. Retirada somente com apresentação deste.					   |'
	endcase	   
	nLin ++ 
	@ nLin,01 say '|																			 |'
	nLin ++ 
	@ nLin,01 say '|																			 |'
	nLin ++ 
	@ nLin,01 say '| ' + cData
	@ nLin,79 say '|'
	nLin ++
	@ nLin,01 say '|																			 |'
	nLin ++ 
	@ nLin,01 say '| ' + EmprARQ->Mensagem
	@ nLin,79 say '|'
	nLin ++ 
	@ nLin,01 say '+-----------------------------------------------------------------------------+'
	nLin += 9
	
	endif

	// Oficina - Manutencao
	
	if nVias == 2 .or. nVias == 3
	
	@ nLin,01 say '+-----------------------------------------------------------------------------+'
	nLin ++
	@ nLin,01 say '|	 O.S. n.'
	@ nLin,15 say OrdS							  pict '999999'
	@ nLin,24 say 'Data ' + dtoc( Emis )
	@ nLin,40 say 'Hora ' + HoraEmis
	@ nLin,53 say 'Prioridade'
	do case
	  case Prio == 'N'
		@ nLin,64 say 'Normal'
	  case Prio == 'E'
		@ nLin,64 say 'Eventual'
	  case Prio == 'P'
		@ nLin,64 say 'Preventiva'
	  case Prio == 'U'
		@ nLin,64 say 'Urgente'
	  case Prio == 'G'
		@ nLin,64 say 'Garantia'
	endcase
	@ nLin,79 say '|'
	nLin ++
	@ nLin,01 say '|	 Cliente'
	if Clie == '999999'
	  @ nLin,15 say AbOSARQ->Cliente				pict '@S40'
	else  
	  @ nLin,15 say ClieARQ->Nome					pict '@S40'
	endif  
	@ nLin,57 say 'Codigo'
	@ nLin,64 say Clie								pict '999999'
	@ nLin,79 say '|'
	nLin ++
	@ nLin,01 say '|	Endereço'
	@ nLin,15 say alltrim( ClieARQ->Ende ) + ' ' + alltrim( ClieARQ->Bair ) + ' ' + alltrim( ClieARQ->Cida )  pict '@S40'
	@ nLin,59 say 'Fone'
	@ nLin,64 say ClieARQ->Fone						pict '@S14'
	@ nLin,79 say '|'
	nLin ++
	@ nLin,01 say '+-----------------------------------------------------------------------------+'
	nLin ++
	do case
	  case EmprARQ->TipoOS == 1
		@ nLin,01 say '| Equipamento'
		@ nLin,15 say Apa1		  pict '@S17'			
		@ nLin,39 say 'Serie'
		@ nLin,45 say NSerie	  pict '@S10'
		@ nLin,59 say 'Modelo'
		@ nLin,66 say Modelo	  pict '@S10'
		@ nLin,79 say '|'
	  case EmprARQ->TipoOS == 2
		@ nLin,01 say '|	 Veículo'
		@ nLin,15 say Veic
		@ nLin,39 say 'Placa'
		@ nLin,45 say Placa
		@ nLin,62 say 'KM'
		@ nLin,65 say KM		   pict '@E 99999,999.9'
		@ nLin,79 say '|'
	  case EmprARQ->TipoOS == 3
		@ nLin,01 say '|   Descrição' 
		@ nLin,15 say Apa1								
		@ nLin,79 say '|'
	endcase	   
	nLin ++
	@ nLin,01 say '|  Observação'
	@ nLin,15 say Obse			   pict '@S38'
	@ nLin,54 say 'Entrega ' + dtoc( Entr ) + ' ' + HoraEntr + ' |'	 
	nLin ++
	if EmprARQ->Horario == "X"
	  @ nLin,01 say '+-----------+-------+-------+------------------------+------------------------+'
	  nLin ++
	  @ nLin,01 say '|Data		 |Inicio |Final	 |Funcionario		 Cod |Parada			 Cod |'	 
	  nLin ++
	  for nL := 1 to 5
		@ nLin,01 say '|___/___/___|___:___|___:___|__________________ _____|__________________ _____|'
		nLin ++
	  next	
	endif  
	@ nLin,01 say '+------+---------------------------------------------+-----------+------------+'
	nLin ++
	@ nLin,01 say '| Qtde.|Produtos/Serviços						   Cod|	  P. Unit.| Valor Total|'
	nLin   ++
	nItens := iif( EmprARQ->Horario == "X", 11, 18 )
	
	select( cItOSTMP )
	set order	 to 1
	set relation to Prod into ProdARQ
	dbgotop()
	do while !eof ()
	  @ nLin,01 say '|'
	  if EmprARQ->Inteira == "X" 
		nMemoLin := mlcount( Produto, 40 )

		if nMemoLin > 1 
		  for nK := 1 to nMemoLin
			if nK == 1
			  @ nLin,02 say transform( Qtde, '@E 999999' ) + '|' + memoline( Produto, 38, nK ) + ' ' + Prod + '|'
			  @ nLin,66 say '|'
			  @ nLin,79 say '|' 
			else  
			  @ nLin,01 say '|'
			  @ nLin,08 say '|' + memoline( Produto, 40, nK ) + space(5) + '|'
			  if nK < nMemoLin
				@ nLin,66 say '|'
				@ nLin,79 say '|' 
			  endif	 
			endif  
			nLin ++	 
		  next
		  nLin --
		else
		  @ nLin,02 say transform( Qtde, '@E 999999' ) + '|' + iif( Prod == '999999', memoline( Produto, 38, 1 ),  left( ProdARQ->Nome, 38 ) ) + ' ' + Prod + '|'
		endif  
	  else		
		@ nLin,02 say transform( Qtde, '@E 9999.9' ) + '|' + iif( Prod == '999999', memoline( Produto, 38, 1 ),	 left( ProdARQ->Nome, 38 ) ) + ' ' + Prod + '|'
	  endif		
	  @ nLin,56 say PrecoVenda			   pict PictPreco(10)
	  @ nLin,66 say '|'
	  @ nLin,69 say PrecoVenda * Qtde	   pict '@E 999,999.99'
	  @ nLin,79 say '|' 
	  
	  nLin	 ++
	  nItens --
	  
	  if nItens == 0
		exit	   
	  endif
	  
	  dbskip ()	 
	enddo

	for nL := 1 to nItens
	  @ nLin,01 say '|______|________________________________________ ____| __________| ___________|'
	  nLin ++
	next  
	@ nLin,01 say '+------+---------------------------------------------+-----------+------------+'
	nLin ++ 
	@ nLin,01 say '|											 Valor Total da O.S	 ____________|'
	nLin ++
	@ nLin,01 say '| Assinatura _________________________________________________________________|'
	nLin ++
	@ nLin,01 say '| Observação _________________________________________________________________|'
	nLin ++
	@ nLin,01 say '+-----------------------------------------------------------------------------+'
	if EmprARQ->Horario == "X"
	  nLin += 4
	else
	  nLin += 3
	endif  
	
	if nTipoAbOS == 1
	  @ nLin,00 say chr(27) + '@' 
	endif  
	
	endif
  
  set printer to
  set printer off
  set device  to screen
  
  if !empty( GetDefaultPrinter() ) .and. nPrn > 0
	PrnTest(aPrn[nPrn], memoread( cArqTxt ), .f. )
  endif
 
return NIL