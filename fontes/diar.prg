//  Leve, Diario de Vendas
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

//
// Protocolo Diario de Vendas
//
function PrinDiar ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "PediARQ", .t. )
    VerifIND( "PediARQ" )
  
    #ifdef DBF_NTX
      set index to PediIND1, PediIND2, PediIND3, PediIND4, PediIND5
    #endif  
  endif

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )
  
    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
    #endif  
  endif

  if NetUse( "FornARQ", .t. )
    VerifIND( "FornARQ" )
  
    #ifdef DBF_NTX
      set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
    #endif  
  endif

  if NetUse( "ReprARQ", .t. )
    VerifIND( "ReprARQ" )

    #ifdef DBF_NTX
      set index to ReprIND1, ReprIND2
    #endif  
  endif

  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )
  
    #ifdef DBF_NTX
      set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
    #endif  
  endif

  if NetUse( "IPedARQ", .t. )
    VerifIND( "IPedARQ" )
  
    #ifdef DBF_NTX
      set index to IPedIND1
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

  if NetUse( "EnOSARQ", .t. )
    VerifIND( "EnOSARQ" )

    #ifdef DBF_NTX
      set index to EnOSIND1, EnOSIND2, EnOSIND3
    #endif  
  endif

  if NetUse( "IEnOARQ", .t. )
    VerifIND( "IEnOARQ" )
  
    #ifdef DBF_NTX
      set index to IEnOIND1
    #endif  
  endif

  if NetUse( "GrupARQ", .t. )
    VerifIND( "GrupARQ" )

    #ifdef DBF_NTX
      set index to GrupIND1, GrupIND2
    #endif  
  endif

  if NetUse( "SubGARQ", .t. )
    VerifIND( "SubGARQ" )
  
    #ifdef DBF_NTX
      set index to SubGIND1, SubGIND2, SubGIND3
    #endif  
  endif

  if NetUse( "CondARQ", .t. )
    VerifIND( "CondARQ" )
  
    #ifdef DBF_NTX
      set index to CondIND1, CondIND2
    #endif  
  endif

  tPrt  := savescreen( 00, 00, 23, 79 )

  Janela ( 04, 12, 18, 70, mensagem( 'Janela', 'PrinDiar', .f. ), .f.)
  Mensagem( 'Diar', 'PrinDiar' ) 

  setcolor ( CorJanel + ',' + CorCampo )
  @ 06,14 say '   Emissão Inicial             Emissão Final'
  @ 07,14 say '      Hora Inicial                Hora Final'
  @ 08,14 say '   Cliente Inicial             Cliente Final'
  @ 09,14 say '  Vendedor Inicial            Vendedor Final'
  @ 10,14 say '   Produto Inicial             Produto Final'
  @ 11,14 say 'Fornecedor Inicial          Fornecedor Final'
  @ 12,14 say '     Grupo Inicial               Grupo Final'
  @ 13,14 say '  SubGrupo Inicial            SubGrupo Final'
  @ 15,14 say '            Vendas' 
  @ 16,14 say '              Tipo'
  @ 17,14 say '             Ordem'
 
  setcolor( CorCampo )
  @ 15,33 say ' Ambas  '
  @ 16,33 say ' Discriminado '
  @ 16,48 say ' Demonstrativo '
  @ 17,33 say ' Alfab‚tica '
  
  setcolor ( 'n/w+' )
  @ 15,42 say chr(25)
  @ 17,46 say chr(25)

  setcolor( 'gr+/w' )
  @ 15,34 say 'A'
  @ 16,34 say 'D'
  @ 16,50 say 'e'
  @ 17,34 say 'A'
  
  select ReprARQ
  set order to 1
  dbgotop()
  nReprIni := val( Repr )
  dbgobottom()
  nReprFin := val( Repr )

  select ClieARQ
  set order to 1
  dbgotop()
  nClieIni := val( Clie )
  nClieFin := 999999

  select FornARQ
  set order to 1
  dbgotop()
  nFornIni := val( Forn )
  dbgobottom()
  nFornFin := val( Forn )

  select GrupARQ
  set order to 1
  dbgotop()
  nGrupIni := val( Grup )
  dbgobottom()
  nGrupFin := val( Grup )

  select ProdARQ
  set order to 1
  dbgotop()
  nProdIni := val( Prod )
  nProdFin := 999999

  dDataIni := date()
  dDataFin := date() 
  cHoraIni := '00:00'
  cHoraFin := '23:59'
  nSubGIni := 0
  nSubGFin := 999999
  nDemo    := 2
  nOrdem   := 1
  aOpc     := {}
  aOpcao   := {}
  aOrdem   := {}
  cProd    := space(04)

  setcolor ( CorJanel + ',' + CorCampo )
  @ 06,33 get dDataIni           pict '99/99/9999'
  @ 06,59 get dDataFin           pict '99/99/9999'   valid dDataFin >= dDataIni
  @ 07,33 get cHoraIni           pict '99:99'      valid ValidHora( cHoraIni, "cHoraIni" )
  @ 07,59 get cHoraFin           pict '99:99'      valid ValidHora( cHoraFin, "cHoraFin" ) .and. cHoraFin > cHoraIni
  @ 08,33 get nClieIni           pict '999999'     valid ValidClie( 99, 99, "ClieARQ", "nClieIni", 30 )
  @ 08,59 get nClieFin           pict '999999'     valid ValidClie( 99, 99, "ClieARQ", "nClieFin", 30 ) .and. nClieFin >= nClieIni 
  @ 09,33 get nReprIni           pict '999999'     valid ValidARQ( 99, 99, "ReprARQ", "Código", "Repr", "Descrição", "Nome", "Repr", "nReprIni", .t., 6, "Consulta de Vendedores", "ReprARQ", 40 )  
  @ 09,59 get nReprFin           pict '999999'     valid ValidARQ( 99, 99, "ReprARQ", "Código", "Repr", "Descrição", "Nome", "Repr", "nReprFin", .t., 6, "Consulta de Vendedores", "ReprARQ", 40 ) .and. nReprFin >= nReprIni 
  @ 10,33 get nProdIni           pict '999999'     valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdIni" ) 
  @ 10,59 get nProdFin           pict '999999'     valid ValidProd( 99, 99, "ProdARQ", 'prin', 0, 0, 0, "nProdFin" ) .and. nProdFin >= nProdIni 
  @ 11,33 get nFornIni           pict '999999'     valid ValidForn( 99, 99, "ProdARQ", "nFornIni" )       
  @ 11,59 get nFornFin           pict '999999'     valid ValidForn( 99, 99, "ProdARQ", "nFornFin" ) .and. nFornFin >= nFornIni
  @ 12,33 get nGrupIni           pict '999999'      valid ValidARQ( 99, 99, "ProdARQ", "Código", "Grup", "Descrição", "Nome", "Grup", "nGrupIni", .t., 6, "Grupos", "GrupARQ", 30 ) 
  @ 12,59 get nGrupFin           pict '999999'      valid ValidARQ( 99, 99, "ProdARQ", "Código", "Grup", "Descrição", "Nome", "Grup", "nGrupFin", .t., 6, "Grupos", "GrupARQ", 30 ) .and. nGrupFin >= nGrupIni
  @ 13,33 get nSubGIni           pict '999999'     
  @ 13,59 get nSubGFin           pict '999999'      valid nSubGFin >= nSubGIni 
  read

  if lastkey() == K_ESC
    select ProdARQ
    close
    select GrupARQ
    close
    select SubGARQ
    close
    select ClieARQ
    close
    select PediARQ
    close
    select IPedARQ
    close
    select NSaiARQ
    close
    select INSaARQ
    close
    select EnOsARQ
    close
    select IENOARQ
    close
    select CondARQ
    close
    select FornARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  aadd( aOpcao, { ' Discriminado ',  2, 'D', 16, 33, mensagem( 'Diar', 'PrinDiar1', .f. ) } )
  aadd( aOpcao, { ' Demonstrativo ', 3, 'E', 16, 48, mensagem( 'Diar', 'PrinDiar2', .f. ) } )


  aadd( aOrdem, { ' Alfabetica ', 2, 'A', 17, 33, mensagem( 'Diar', 'PrinDiar3', .f. ) } )
  aadd( aOrdem, { ' Codigo     ', 2, 'C', 17, 33, mensagem( 'Diar', 'PrinDiar4', .f. ) } )
  aadd( aOrdem, { ' Venda      ', 2, 'V', 17, 33, mensagem( 'Diar', 'PrinDiar5', .f. ) } )

  aadd( aOpc, { ' Pedido ', 2, 'P', 15, 33, mensagem( 'Diar', 'PrinDiar6', .f. ) } )
  aadd( aOpc, { ' Nota   ', 2, 'N', 15, 33, mensagem( 'Diar', 'PrinDiar7', .f. ) } )
  aadd( aOpc, { ' OS     ', 2, 'O', 15, 33, mensagem( 'Diar', 'PrinDiar8', .f. ) } )
  aadd( aOpc, { ' Ambas  ', 2, 'A', 15, 33, mensagem( 'Diar', 'PrinDiar9', .f. ) } )

   
  nVendas := HCHOICE( aOpc, 4, 4 )

  if lastkey() == K_ESC
    select ProdARQ
    close
    select GrupARQ
    close
    select SubGARQ
    close
    select ClieARQ
    close
    select PediARQ
    close
    select IPedARQ
    close
    select NSaiARQ
    close
    select INSaARQ
    close
    select CondARQ
    close
    select FornARQ
    close
    select EnOsARQ
    close
    select IENOARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  nDemo   := HCHOICE( aOpcao, 2, 1 )

  if lastkey() == K_ESC
    select ProdARQ
    close
    select GrupARQ
    close
    select SubGARQ
    close
    select ClieARQ
    close
    select PediARQ
    close
    select IPedARQ
    close
    select NSaiARQ
    close
    select INSaARQ
    close
    select CondARQ
    close
    select FornARQ
    close
    select EnOsARQ
    close
    select IENOARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  nOrdem   := HCHOICE( aOrdem, 3, 1 )

  if lastkey() == K_ESC
    select ProdARQ
    close
    select GrupARQ
    close
    select SubGARQ
    close
    select ClieARQ
    close
    select PediARQ
    close
    select IPedARQ
    close
    select NSaiARQ
    close
    select INSaARQ
    close
    select CondARQ
    close
    select FornARQ
    close
    select EnOsARQ
    close
    select IENOARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  cClieIni    := strzero( nClieIni, 6 )
  cClieFin    := strzero( nClieFin, 6 )
  cReprIni    := strzero( nReprIni, 6 )
  cReprFin    := strzero( nReprFin, 6 )
  cProdIni    := strzero( nProdIni, 6 )
  cProdFin    := strzero( nProdFin, 6 )
  cFornIni    := strzero( nFornIni, 6 )
  cFornFin    := strzero( nFornFin, 6 )
  cGrupIni    := strzero( nGrupIni, 6 )
  cGrupFin    := strzero( nGrupFin, 6 )
  cSubGIni    := strzero( nSubGIni, 6 )
  cSubGFin    := strzero( nSubGFin, 6 )

  nTotalGeral := nTotalPago  := nTotalCond  := nTotalVista := 0
  nVistaDesc  := nTotalPrazo := nPrazoSubT  := nPrazoDesc  := 0
  nTotalDesc  := nVistaSubT  := nTotalCusto := nTotalVenda := 0
  nPercVista  := nPercPrazo  := nPgto       := nTotalNota  := 0  
  aCond       := {}
  aProd       := {}
  cClieAnt    := space(06)
  lInicio     := .t.
  
  Aguarde ()

  nPag   := 1
  nLin   := 0
  cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

  if nVendas == 3 .or. nVendas == 4
    select EnOSARQ
    set order    to 2
    set relation to Clie into ClieARQ, to Repr into ReprARQ, to Cond into CondARQ
    dbgotop ()
    do while Clie >= cClieIni .and. Clie <= cClieFin .and. !eof()
      if Term        >= dDataIni .and. Term        <= dDataFin .and.;
         val( Repr ) >= nReprIni .and. val( Repr ) <= nReprFin .and.;
         Receber
         
        if nDemo == 1
          if lInicio       
            set printer to ( cArqu2 )
            set device  to printer
            set printer on
          
            lInicio := .f.
          endif  

          if nLin == 0
            do case
              case nVendas == 3
                Cabecalho ( 'Diario de Vendas - OS', 132, 3 )
              case nVendas == 4
                Cabecalho ( 'Diario de Vendas - Ambas', 132, 3 )
            endcase
            CabDiar ()
          endif

          if cClieAnt != Clie
            cClieAnt := Clie

            @ nLin,01 say Clie           pict '999999'

            if Clie == '999999'
              @ nLin,08 say Cliente
            else  
              @ nLin,08 say ClieARQ->Nome
            endif  
            nLin ++
          endif
        endif

        cOrdS      := OrdS
        lVez       := .t.
        nTotalNota := 0
        nDesconto  := Desconto

        select IEnOARQ
        set order    to 1
        set relation to Prod into ProdARQ
        dbseek( cOrdS, .t. )
        do while OrdS == cOrdS .and. !eof()
          if Prod == '999999'
            ProdARQ->(dbgotop())
          endif  
        
          if Prod         >= cProdIni .and. Prod          <= cProdFin .and.;
            ProdARQ->Forn >= cFornIni .and. ProdARQ->Forn <= cFornFin .and.;
            ProdARQ->Grup >= cGrupIni .and. ProdARQ->Grup <= cGrupFin .and.;
            ProdARQ->SubG >= cSubgIni .and. ProdARQ->SubG <= cSubGFin
            
            nElem := ascan( aProd, { |nElem| nElem[1] == Prod } )

            if nElem > 0
              aProd[ nElem, 4 ] += Qtde
            else
              if Prod == '999999'
                aadd( aProd,{ Prod, Produto, ProdARQ->Unid, Qtde, PrecoVenda, 0 } )
              else  
                aadd( aProd,{ Prod, ProdARQ->Nome, ProdARQ->Unid, Qtde, PrecoVenda, ProdARQ->PrecoCusto } )
              endif  
            endif
           
            if nDemo == 1
              if lVez
                lVez   := .f.

                select ENOSARQ
                @ nLin,06 say OrdS
                @ nLin,14 say Term             pict '99/99/9999'
                @ nLin,26 say Repr             pict '999999'
                @ nLin,33 say ReprARQ->Nome    pict '@S16'
                select IENOARQ
              endif
            endif

            nValorTotal := ( PrecoVenda * Qtde )
            nTotalNota  += nValorTotal 
            nTotalVenda += ( Qtde * PrecoVenda )
            nTotalCusto += ( Qtde * ProdARQ->PrecoCusto )
 
            if nDemo == 1
              @ nLin,050 say Sequ                   pict '9999'
              @ nLin,055 say Prod                   pict '999999'
              if Prod == '999999'
                @ nLin,062 say Produto              pict '@S27'
              else  
                @ nLin,062 say ProdARQ->Nome        pict '@S27'
              endif  
              @ nLin,090 say ProdARQ->Unid
              if EmprARQ->Inteira == "X"
                @ nLin,094 say Qtde                 pict '@E 9999999999'
              else      
                @ nLin,094 say Qtde                 pict '@E 999999.999'
              endif     
              @ nLin,106 say PrecoVenda             pict PictPreco(10)
              @ nLin,119 say nValorTotal            pict '@E 999,999.99'
              nLin ++
            endif

            dbskip ()
 
            if nLin >= pLimite .and. !eof ()
              Rodape(132)

              cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
              cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

              set printer to ( cArqu2 )
              set printer on

              Cabecalho ( 'Diario de Vendas', 132,  3 )
              CabDiar ()

              select EnOSARQ
  
              cClieAnt := Clie
    
              @ nLin,01 say Clie             pict '999999'
              if Clie == '999999'
                @ nLin,08 say Cliente
              else  
                @ nLin,08 say ClieARQ->Nome
              endif  
              nLin ++
              @ nLin,06 say OrdS
              @ nLin,14 say Term             pict '99/99/9999'
              @ nLin,26 say Repr             pict '999999'
              @ nLin,33 say ReprARQ->Nome    pict '@S16'

              select IENOARQ
            endif
            dbskip(-1)
          endif
          
          dbskip ()
        enddo
        
        nElemCond   := ascan( aCond, { |nElem| nElem[1] == PediARQ->Cond } )

        if nElemCond > 0
          aCond[ nElemCond, 2 ] += nTotalNota
          aCond[ nElemCond, 3 ] += nDesconto
          aCond[ nElemCond, 4 ] += ( nTotalNota - nDesconto )
        else  
          aadd( aCond, { ENOSARQ->Cond, nTotalNota, nDesconto,( nTotalNota - nDesconto ) } )
        endif

        nTotalNota  -= nDesconto
        nTotalGeral += nTotalNota

        if nDemo == 1 .and. nTotalNota > 0
          @ nLin,111 say 'Total'
          @ nLin,119 say nTotalNota            pict '@E 999,999.99'
          nLin += 2
        endif

        select EnOSARQ

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
  endif

  cClieAnt := space(06)

  if nVendas == 2 .or. nVendas == 4
    select PediARQ
    set order    to 2
    set relation to Clie into ClieARQ, to Repr into ReprARQ, to Cond into CondARQ
    dbgotop ()
    do while Clie >= cClieIni .and. Clie <= cClieFin .and. !eof()
      if Emis        >= dDataIni .and. Emis        <= dDataFin .and.;
         val( Repr ) >= nReprIni .and. val( Repr ) <= nReprFin .and.;
         Hora        >= cHoraIni .and. Hora        <= cHoraFin
         
        if nDemo == 1
          if lInicio       
            set printer to ( cArqu2 )
            set device  to printer
            set printer on
          
            lInicio := .f.
          endif  

          if nLin == 0
            do case
              case nVendas == 2
                Cabecalho ( 'Diario de Vendas - Notas', 132, 3 )
              case nVendas == 4
                Cabecalho ( 'Diario de Vendas - Ambas', 132, 3 )
            endcase
            CabDiar ()
          endif

          if cClieAnt != Clie
            cClieAnt := Clie

            @ nLin,01 say Clie           pict '999999'

            if Clie == '999999'
              @ nLin,08 say Cliente
            else  
              @ nLin,08 say ClieARQ->Nome
            endif  
            nLin ++
          endif
        endif

        cNota      := Nota
        lVez       := .t.
        nTotalNota := 0
        nDesconto  := Desconto

        select IPedARQ
        set order    to 1
        set relation to Prod into ProdARQ
        dbseek( cNota, .t. )
        do while Nota == cNota .and. !eof()
          if Prod == '999999'
            ProdARQ->(dbgotop())
          endif  
        
          if Prod         >= cProdIni .and. Prod          <= cProdFin .and.;
            ProdARQ->Forn >= cFornIni .and. ProdARQ->Forn <= cFornFin .and.;
            ProdARQ->Grup >= cGrupIni .and. ProdARQ->Grup <= cGrupFin .and.;
            ProdARQ->SubG >= cSubgIni .and. ProdARQ->SubG <= cSubGFin
            
            nElem := ascan( aProd, { |nElem| nElem[1] == Prod } )

            if nElem > 0
              aProd[ nElem, 4 ] += Qtde
            else
              if Prod == '999999'
                aadd( aProd,{ Prod, Produto, ProdARQ->Unid, Qtde, PrecoVenda, 0 } )
              else  
                aadd( aProd,{ Prod, ProdARQ->Nome, ProdARQ->Unid, Qtde, PrecoVenda, ProdARQ->PrecoCusto } )
              endif  
            endif
           
            if nDemo == 1
              if lVez
                lVez   := .f.

                select PediARQ
                @ nLin,06 say Nota
                @ nLin,14 say Emis             pict '99/99/9999'
                @ nLin,26 say Repr             pict '999999'
                @ nLin,33 say ReprARQ->Nome    pict '@S16'
                select IPedARQ
              endif
            endif

            nValorTotal := ( PrecoVenda * Qtde )
            nTotalNota  += nValorTotal 
            nTotalVenda += ( Qtde * PrecoVenda )
            nTotalCusto += ( Qtde * ProdARQ->PrecoCusto )
 
            if nDemo == 1
              @ nLin,050 say Sequ                   pict '9999'
              @ nLin,055 say Prod                   pict '9999'
              if Prod == '9999'
                @ nLin,062 say Produto              pict '@S27'
              else  
                @ nLin,062 say ProdARQ->Nome        pict '@S27'
              endif  
              @ nLin,090 say ProdARQ->Unid
              if EmprARQ->Inteira == "X"
                @ nLin,094 say Qtde                 pict '@E 9999999999'
              else      
                @ nLin,094 say Qtde                 pict '@E 999999.999'
              endif     
              @ nLin,106 say PrecoVenda             pict PictPreco(10)
              @ nLin,119 say nValorTotal            pict '@E 999,999.99'
              nLin ++
            endif

            dbskip ()
 
            if nLin >= pLimite .and. !eof ()
              Rodape(132)

              cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
              cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

              set printer to ( cArqu2 )
              set printer on

              Cabecalho ( 'Diario de Vendas', 132,  3 )
              CabDiar ()

              select PediARQ
  
              cClieAnt := Clie
    
              @ nLin,01 say Clie             pict '999999'
              if Clie == '999999'
                @ nLin,08 say Cliente
              else  
                @ nLin,08 say ClieARQ->Nome
              endif  
              nLin ++
              @ nLin,06 say Nota
              @ nLin,14 say Emis             pict '99/99/9999'
              @ nLin,26 say Repr             pict '9999'
              @ nLin,31 say ReprARQ->Nome    pict '@S18'
              select IPedARQ
            endif
            dbskip(-1)
          endif
          dbskip ()
        enddo
        
        nElemCond   := ascan( aCond, { |nElem| nElem[1] == PediARQ->Cond } )

        if nElemCond > 0
          aCond[ nElemCond, 2 ] += nTotalNota
          aCond[ nElemCond, 3 ] += nDesconto
          aCond[ nElemCond, 4 ] += ( nTotalNota - nDesconto )
        else  
          aadd( aCond, { PediARQ->Cond, nTotalNota, nDesconto,( nTotalNota - nDesconto ) } )
        endif

        nTotalNota  -= nDesconto
        nTotalGeral += nTotalNota

        if nDemo == 1 .and. nTotalNota > 0
          @ nLin,111 say 'Total'
          @ nLin,119 say nTotalNota            pict '@E 999,999.99'
          nLin += 2
        endif

        select PediARQ

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
  endif
 
  select PediARQ
  set relation to

  cClieAnt := space(06)
 
  if nVendas == 1 .or. nVendas == 4
    select NSaiARQ
    set order    to 4
    set relation to Clie into ClieARQ, to Repr into ReprARQ, to Cond into CondARQ
    dbseek( dtos( dDataIni ), .t. )
    do while Emis >= dDataIni .and. Emis <= dDataFin .and. !eof ()
      if Clie        >= cClieIni .and. Clie        <= cClieFin .and.;
         val( Repr ) >= nReprIni .and. val( Repr ) <= nReprFin .and.;
         Hora        >= cHoraIni .and. Hora        <= cHoraFin

        if nLin >= pLimite
          Rodape(132)

          cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
          cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

          set printer to ( cArqu2 )
          set printer on
        endif

        if nDemo == 1
          if lInicio       
            set printer to ( cArqu2 )
            set device  to printer
            set printer on
          
            lInicio := .f.
          endif  
      
          if nLin == 0
            do case
              case nVendas == 1
                Cabecalho ( 'Diario de Vendas - Pedidos', 132, 3 )
              case nVendas == 4
                Cabecalho ( 'Diario de Vendas - Ambas', 132, 3 )
            endcase
            CabDiar ()
          endif

          if cClieAnt != Clie
            cClieAnt := Clie
          
            @ nLin,01 say Clie             pict '999999'

            if Clie == '999999'
              @ nLin,08 say Cliente
            else  
              @ nLin,08 say ClieARQ->Nome
            endif  

            nLin ++
          endif  
        endif

        cNota      := Nota
        lVez       := .t.
        nSubTotal  := 0
        nDesconto  := Desconto
        cCond      := Cond
        nElemCond  := ascan( aCond, { |nElem| nElem[1] == cCond } )
 
        select INSaARQ
        set order    to 1
        set relation to Prod into ProdARQ
        dbseek( cNota, .t. )
        do while Nota == cNota .and. !eof()
          if Prod == '999999'
            ProdARQ->(dbgotop())

            nElem := ascan( aProd, { |nElem| nElem[2] == Produto } )
          else  
            nElem := ascan( aProd, { |nElem| nElem[2] == ProdARQ->Nome } )
          endif  

          if Prod         >= cProdIni .and. Prod          <= cProdFin .and.;
            ProdARQ->Forn >= cFornIni .and. ProdARQ->Forn <= cFornFin .and.;
            ProdARQ->Grup >= cGrupIni .and. ProdARQ->Grup <= cGrupFin .and.;
            ProdARQ->SubG >= cSubgIni .and. ProdARQ->SubG <= cSubGFin
    
            if nElem > 0
              aProd[ nElem, 4 ] += Qtde
            else
              if Prod == '999999'
                aadd( aProd,{ Prod, Produto, ProdARQ->Unid, Qtde, PrecoVenda, 0 } )
              else  
                aadd( aProd,{ Prod, ProdARQ->Nome, ProdARQ->Unid, Qtde, PrecoVenda, ProdARQ->PrecoCusto } )
              endif  
            endif

            if nDemo == 1
              if lVez
                lVez   := .f.
   
                select NSaiARQ
            
                @ nLin,06 say Nota
                @ nLin,14 say Emis             pict '99/99/9999'
                @ nLin,26 say Repr             pict '999999'
                @ nLin,33 say ReprARQ->Nome    pict '@S16'
            
                select INSaARQ
              endif
            endif
              
            nValorTotal := ( Qtde * PrecoVenda )
            nSubTotal   += ( Qtde * PrecoVenda )
            nTotalVenda += ( Qtde * PrecoVenda )
            nTotalCusto += ( Qtde * ProdARQ->PrecoCusto )
           
            if nDemo == 1
              @ nLin,050 say Sequ                   pict '9999'
              @ nLin,055 say Prod                   pict '999999'
              if Prod == '999999'
                @ nLin,062 say Produto              pict '@S27'
              else  
                @ nLin,062 say ProdARQ->Nome        pict '@S27'
              endif  
              @ nLin,090 say ProdARQ->Unid
              if EmprARQ->Inteira == "X"
                @ nLin,094 say Qtde                 pict '@E 9999999999'
              else              
                @ nLin,094 say Qtde                 pict '@E 999999.999'
              endif             
              @ nLin,106 say PrecoVenda             pict PictPreco(10)
              @ nLin,119 say nValorTotal            pict '@E 999,999.99'
              nLin ++
            endif
 
            dbskip ()
    
            if nLin >= pLimite .and. !eof()
              Rodape(132)
  
              cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
              cArqu2 := cArqu2 + "." + strzero( nPag, 3 )
  
              set printer to ( cArqu2 )
              set printer on
  
              Cabecalho ( 'Diario de Vendas', 132,  3 )
              CabDiar ()
 
              select NSaiARQ
              
              cClieAnt := Clie

              @ nLin,01 say Clie             pict '999999'
              if Clie == '999999'
                @ nLin,08 say Cliente
              else  
                @ nLin,08 say ClieARQ->Nome
              endif  
              nLin ++
              @ nLin,06 say Nota
              @ nLin,14 say Emis             pict '99/99/9999'
              @ nLin,26 say Repr             pict '999999'
              @ nLin,33 say ReprARQ->Nome    pict '@S16'
  
              select INSaARQ
            endif
            dbskip(-1)
          endif  
          dbskip ()
        enddo
        
        nJuros      := ( CondARQ->Acrs * nSubTotal ) / 100
        nSubTotal   -= nDesconto
        nTotalNota  := nSubTotal + nJuros  
        nTotalGeral += nTotalNota

        select NSaiARQ
     
        if nDemo == 1 .and. nTotalNota > 0
          @ nLin,111 say 'Total'
          @ nLin,119 say nTotalNota            pict '@E 999,999.99'
          nLin += 2
        endif

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
  endif

  if nDemo == 1 .and. !lInicio .and. nTotalGeral > 0
    @ nLin,105 say 'Total Geral'
    @ nLin,119 say nTotalGeral            pict '@E 999,999.99'

    Rodape(132)
  endif  

  if len( aProd ) > 0
    cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
    cArqu2 := cArqu2 + "." + strzero( nPag, 3 )
   
    set device  to printer
    set printer to ( cArqu2 )
    set printer on

    Cabecalho ( 'Diario de Vendas - Demonstrativo', 132, 3 )
  
    select ProdARQ
    set order to 1
    nLin += 2

    if cClieIni == cClieFin 
      @ nLin,01 say 'Cliente ' + ClieARQ->Nome + ' ' + cClieIni
      @ nLin,01 say 'Periodo ' + dtoc( dDataIni ) + ' a ' + dtoc( dDataFin )
      nLin += 2 
    endif  

    @ nLin,01 say '                                     Demonstrativo por Produtos'
    nLin += 2
    @ nLin,01 say 'Cod Descrição                           UN.      Qtde.   P. Custo   P. Venda   P. Medio   C. Total   V. Total      Saldo      %'
    nLin ++
    @ nLin,01 say '--------------------------------------------------------------------------------------------------------------------------------'
    nLin ++
    
    do case
      case nOrdem == 1
        asort( aProd,,, { | Nome01, Nome02 | Nome01[2] < Nome02[2] } )
      case nOrdem == 2
        asort( aProd,,, { | Nome01, Nome02 | Nome01[1] < Nome02[1] } )
      case nOrdem == 3
        asort( aProd,,, { | Nome01, Nome02 | Nome01[4] > Nome02[4] } )
    endcase     
    
    nTotal := 0

    for nI := 1 to len( aProd )
      nTotal += aProd[ nI, 4 ]
    next
    
    nTotaCust := 0
    nTotaVend := 0
    nTotaQtde := 0
        
    for nI := 1 to len( aProd )
      cProd  := aProd[ nI, 1 ]
      cNome  := aProd[ nI, 2 ]
      cUnid  := aProd[ nI, 3 ]
      nQtde  := aProd[ nI, 4 ]
      nPreco := aProd[ nI, 5 ]
      nCusto := aProd[ nI, 6 ]
      nMedio := 0

      if nQtde == 0
        loop
      endif
      
      if cProd != '9999'
        dbseek( cProd, .f. )
        
        nMedio := ( ( ProdARQ->Qtde * ProdARQ->PrecoCusto ) + ( nQtde * nPreco ) ) / ( ProdARQ->Qtde + nQtde )
      endif
      
      nPerc := ( nQtde * 100 ) / nTotal

      @ nLin,001 say cProd
      @ nLin,008 say cNome               pict '@S33'
      @ nLin,042 say cUnid
      if EmprARQ->Inteira == "X"
        @ nLin,046 say nQtde             pict '@E 9999999999' 
      else      
        @ nLin,046 say nQtde             pict '@E 999999.999' 
      endif     
      @ nLin,057 say nCusto              pict PictPreco(10)
      @ nLin,068 say nPreco              pict PictPreco(10)
      @ nLin,079 say nMedio              pict PictPreco(10)
      @ nLin,090 say nCusto * nQtde      pict '@E 999,999.99'
      @ nLin,101 say nPreco * nQtde      pict '@E 999,999.99'
      @ nLin,112 say ( nPreco * nQtde ) - ( nCusto * nQtde )  pict '@E 999,999.99'
      @ nLin,123 say nPerc               pict '@E 999.99'
      nLin      ++
      nTotaCust += (nCusto * nQtde)
      nTotaVend += (nPreco * nQtde)
      nTotaQtde += nQtde

      if nLin >= pLimite
        Rodape(132)

        cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
        cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

        set printer to ( cArqu2 )
        set printer on

        Cabecalho ( 'Diario de Vendas - Demonstrativo', 132, 3 )
        nLin += 2
        @ nLin,01 say '           Demonstrativo por Produtos'
        nLin += 2
        @ nLin,01 say 'Cod Descrição                           UN.      Qtde.   P. Custo   P. Venda   P. Medio   C. Total   V. Total      Saldo      %'
        nLin ++
        @ nLin,01 say '--------------------------------------------------------------------------------------------------------------------------------'
        nLin ++
      endif
    next

    @ nLin,01 say '--------------------------------------------------------------------------------------------------------------------------------'

    if ( nLin + 4 ) >= pLimite
      Rodape(132)

      cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
      cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

      set printer to ( cArqu2 )
      set printer on

      Cabecalho ( 'Diario de Vendas - Demonstrativo', 132, 3 )
      nLin += 2
      @ nLin,01 say 'Cod Descrição                          UN.      Qtde.   P. Custo   P. Venda   P. Medio   C. Total   V. Total      Saldo      %'
      nLin ++
    endif

    @ nLin,030 say 'Total Geral'
    if EmprARQ->Inteira == "X"
      @ nLin,046 say nTotaQtde            pict '@E 9999999999' 
    else        
      @ nLin,046 say nTotaQtde            pict '@E 999999.999' 
    endif       
    @ nLin,090 say nTotaCust              pict '@E 999,999.99'
    @ nLin,101 say nTotaVend              pict '@E 999,999.99'
    @ nLin,112 say nTotaVend - nTotaCust  pict '@E 999,999.99'

    Rodape(132)
  endif
 
  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 132 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      do case
        case nVendas == 1
          replace Titu   with 'Relatório do Di rio de Vendas - Pedidos'
        case nVendas == 2
          replace Titu   with 'Relatório do Di rio de Vendas - Notas'
        case nVendas == 3
          replace Titu   with 'Relatório do Di rio de Vendas - OS'
        case nVendas == 4
          replace Titu   with 'Relatório do Di rio de Vendas - Ambas'
      endcase    
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 132
      replace Empr       with cEmpresa
      dbunlock ()
    endif
  endif  
  
  select ProdARQ
  close
  select GrupARQ
  close
  select SubGARQ
  close
  select ClieARQ
  close
  select PediARQ
  close
  select IPedARQ
  close
  select NSaiARQ
  close
  select INSaARQ
  close
  select CondARQ
  close
  select FornARQ
  close
  select EnOsARQ
  close
  select IENOARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabDiar ()
  @ 02,01 say 'Cliente'
  @ 03,01 say '     Nota    Emissão     Vendedor              Seq. Prod. Descrição                      Un.      Qtde. Preço Venda  Valor Total'

  nLin     := 05
  cClieAnt := space(06)
return NIL


//
// Protocolo Ultimas Vendas
//
function PrinUltV ()

  local cArqu2 := CriaTemp( 5 )
  local cArqu3 := right ( cArqu2, 8 )

  local cRData := date()
  local cRHora := time()

  if NetUse( "PediARQ", .t. )
    VerifIND( "PediARQ" )
  
    #ifdef DBF_NTX
      set index to PediIND1, PediIND2, PediIND3, PediIND4, PediIND5
    #endif  
  endif

  if NetUse( "ClieARQ", .t. )
    VerifIND( "ClieARQ" )
  
    #ifdef DBF_NTX
      set index to ClieIND1, ClieIND2, ClieIND3, ClieIND4, ClieIND5, ClieIND6
    #endif  
  endif

  if NetUse( "FornARQ", .t. )
    VerifIND( "FornARQ" )
  
    #ifdef DBF_NTX
      set index to FornIND1, FornIND2, FornIND3, FornIND4, FornIND5, FornIND6
    #endif  
  endif

  if NetUse( "ReprARQ", .t. )
    VerifIND( "ReprARQ" )
  
    #ifdef DBF_NTX
      set index to ReprIND1, ReprIND2
    #endif  
  endif

  if NetUse( "ProdARQ", .t. )
    VerifIND( "ProdARQ" )
  
    #ifdef DBF_NTX
      set index to ProdIND1, ProdIND2, ProdIND3, ProdIND4, ProdIND5, ProdIND6
    #endif  
  endif

  if NetUse( "IPedARQ", .t. )
    VerifIND( "IPedARQ" )
  
    #ifdef DBF_NTX
      set index to IPedIND1
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

  if NetUse( "EnOSARQ", .t. )
    VerifIND( "EnOSARQ" )
  
    #ifdef DBF_NTX
      set index to EnOSIND1, EnOSIND2, EnOSIND3
    #endif  
  endif

  if NetUse( "IEnOARQ", .t. )
    VerifIND( "IEnOARQ" )
  
    #ifdef DBF_NTX
      set index to IEnOIND1
    #endif  
  endif

  if NetUse( "GrupARQ", .t. )
    VerifIND( "GrupARQ" )

    #ifdef DBF_NTX
      set index to GrupIND1, GrupIND2
    #endif  
  endif

  if NetUse( "SubGARQ", .t. )
    VerifIND( "SubGARQ" )

    #ifdef DBF_NTX
      set index to SubGIND1, SubGIND2, SubGIND3
    #endif  
  endif

  if NetUse( "CondARQ", .t. )
    VerifIND( "CondARQ" )

    #ifdef DBF_NTX
      set index to CondIND1, CondIND2
    #endif  
  endif

 
  tPrt  := savescreen( 00, 00, 23, 79 )

  Janela ( 06, 12, 13, 70, mensagem( 'Janela', 'PrinUltV', .f. ), .f.)
  Mensagem( 'Diar', 'PrinUltV' )

  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,14 say '   Cliente Inicial             Cliente Final'
  @ 09,14 say '  Vendedor Inicial            Vendedor Final'
  @ 11,14 say '    Ultimas Vendas     Dia(s)'
  @ 12,14 say '            Vendas' 
 
  setcolor( CorCampo )
  @ 12,33 say ' Ambas  '

  setcolor ( 'n/w+' )
  @ 12,42 say chr(25)

  setcolor( 'gr+/w' )
  @ 12,34 say 'A'
  
  select ReprARQ
  set order to 1
  dbgotop()
  nReprIni := val( Repr )
  dbgobottom()
  nReprFin := val( Repr )

  select ClieARQ
  set order to 1
  dbgotop()
  nClieIni := val( Clie )
  nClieFin := 999999

  aOpc     := {}
  nDias    := 30
  nDemo    := 1
  
  setcolor ( CorJanel + ',' + CorCampo )
  @ 08,33 get nClieIni           pict '999999'     valid ValidClie( 99, 99, "ClieARQ", "nClieIni", 30 )
  @ 08,59 get nClieFin           pict '999999'     valid ValidClie( 99, 99, "ClieARQ", "nClieFin", 30 ) .and. nClieFin >= nClieIni 
  @ 09,33 get nReprIni           pict '999999'     valid ValidARQ( 99, 99, "ReprARQ", "Código", "Repr", "Descrição", "Nome", "Repr", "nReprIni", .t., 6, "Consulta de Vendedores", "ReprARQ", 40 )  
  @ 09,59 get nReprFin           pict '999999'     valid ValidARQ( 99, 99, "ReprARQ", "Código", "Repr", "Descrição", "Nome", "Repr", "nReprFin", .t., 6, "Consulta de Vendedores", "ReprARQ", 40 ) .and. nReprFin >= nReprIni 
  @ 11,33 get nDias              pict '999'      valid nDias > 0
  read

  if lastkey() == K_ESC
    select ClieARQ
    close
    select PediARQ
    close
    select IPedARQ
    close
    select NSaiARQ
    close
    select INSaARQ
    close
    select EnOsARQ
    close
    select IENOARQ
    close
    select CondARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif

  aadd( aOpc, { ' Pedido ', 2, 'P', 15, 33, mensagem( 'Diar', 'PrinDiar6', .f. ) } )
  aadd( aOpc, { ' Nota   ', 2, 'N', 15, 33, mensagem( 'Diar', 'PrinDiar7', .f. ) } )
  aadd( aOpc, { ' OS     ', 2, 'O', 15, 33, mensagem( 'Diar', 'PrinDiar8', .f. ) } )
  aadd( aOpc, { ' Ambas  ', 2, 'A', 15, 33, mensagem( 'Diar', 'PrinDiar9', .f. ) } )

  nVendas := HCHOICE( aOpc, 4, 4 )

  if lastkey() == K_ESC
    select ClieARQ
    close
    select PediARQ
    close
    select IPedARQ
    close
    select NSaiARQ
    close
    select INSaARQ
    close
    select CondARQ
    close
    select FornARQ
    close
    select EnOsARQ
    close
    select IENOARQ
    close
    restscreen( 00, 00, 23, 79, tPrt )
    return NIL
  endif


  cClieIni    := strzero( nClieIni, 6 )
  cClieFin    := strzero( nClieFin, 6 )
  cReprIni    := strzero( nReprIni, 6 )
  cReprFin    := strzero( nReprFin, 6 )

  nTotalGeral := nTotalPago  := nTotalCond  := nTotalVista := 0
  nVistaDesc  := nTotalPrazo := nPrazoSubT  := nPrazoDesc  := 0
  nTotalDesc  := nVistaSubT  := nTotalCusto := nTotalVenda := 0
  nPercVista  := nPercPrazo  := nPgto       := nTotalNota  := 0  
  aCond       := {}
  aProd       := {}
  cClieAnt    := space(06)
  lInicio     := .t.

  dDataIni    := date() - 30
  dDataFin    := date() + 30
  
  Aguarde ()

  nPag   := 1
  nLin   := 0
  cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

  if nVendas == 3 .or. nVendas == 4
    select EnOSARQ
    set order    to 2
    set relation to Clie into ClieARQ, to Repr into ReprARQ, to Cond into CondARQ
    dbgotop ()
    do while Clie >= cClieIni .and. Clie <= cClieFin .and. !eof()
      if Term        >= dDataIni .and. Term        <= dDataFin .and.;
         val( Repr ) >= nReprIni .and. val( Repr ) <= nReprFin .and.;
         Receber
         
        if nDemo == 1
          if lInicio       
            set printer to ( cArqu2 )
            set device  to printer
            set printer on
          
            lInicio := .f.
          endif  

          if nLin == 0
            do case
              case nVendas == 3
                Cabecalho ( 'Diario de Vendas - OS', 132, 3 )
              case nVendas == 4
                Cabecalho ( 'Diario de Vendas - Ambas', 132, 3 )
            endcase
            CabDiar ()
          endif

          if cClieAnt != Clie
            cClieAnt := Clie

            @ nLin,01 say Clie           pict '999999'

            if Clie == '999999'
              @ nLin,06 say Cliente
            else  
              @ nLin,06 say ClieARQ->Nome
            endif  
            nLin ++
          endif
        endif

        cOrdS      := OrdS
        lVez       := .t.
        nTotalNota := 0
        nDesconto  := Desconto

        select IEnOARQ
        set order    to 1
        set relation to Prod into ProdARQ
        dbseek( cOrdS, .t. )
        do while OrdS == cOrdS .and. !eof()
          if Prod == '999999'
            ProdARQ->(dbgotop())
          endif  
        
          if Prod         >= cProdIni .and. Prod          <= cProdFin .and.;
            ProdARQ->Forn >= cFornIni .and. ProdARQ->Forn <= cFornFin .and.;
            ProdARQ->Grup >= cGrupIni .and. ProdARQ->Grup <= cGrupFin .and.;
            ProdARQ->SubG >= cSubgIni .and. ProdARQ->SubG <= cSubGFin
            
            nElem := ascan( aProd, { |nElem| nElem[1] == Prod } )

            if nElem > 0
              aProd[ nElem, 4 ] += Qtde
            else
              if Prod == '999999'
                aadd( aProd,{ Prod, Produto, ProdARQ->Unid, Qtde, PrecoVenda, 0 } )
              else  
                aadd( aProd,{ Prod, ProdARQ->Nome, ProdARQ->Unid, Qtde, PrecoVenda, ProdARQ->PrecoCusto } )
              endif  
            endif
           
            if nDemo == 1
              if lVez
                lVez   := .f.

                select ENOSARQ
                @ nLin,06 say OrdS
                @ nLin,14 say Term             pict '99/99/9999'
                @ nLin,26 say Repr             pict '999999'
                @ nLin,33 say ReprARQ->Nome    pict '@S16'
                select IENOARQ
              endif
            endif

            nValorTotal := ( PrecoVenda * Qtde )
            nTotalNota  += nValorTotal 
            nTotalVenda += ( Qtde * PrecoVenda )
            nTotalCusto += ( Qtde * ProdARQ->PrecoCusto )
 
            if nDemo == 1
              @ nLin,050 say Sequ                   pict '9999'
              @ nLin,055 say Prod                   pict '999999'
              if Prod == '999999'
                @ nLin,062 say Produto              pict '@S27'
              else  
                @ nLin,062 say ProdARQ->Nome        pict '@S27'
              endif  
              @ nLin,090 say ProdARQ->Unid
              if EmprARQ->Inteira == "X"
                @ nLin,094 say Qtde                 pict '@E 9999999999'
              else      
                @ nLin,094 say Qtde                 pict '@E 999999.999'
              endif     
              @ nLin,106 say PrecoVenda             pict PictPreco(10)
              @ nLin,119 say nValorTotal            pict '@E 999,999.99'
              nLin ++
            endif

            dbskip ()
 
            if nLin >= pLimite .and. !eof ()
              Rodape(132)

              cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
              cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

              set printer to ( cArqu2 )
              set printer on

              Cabecalho ( 'Diario de Vendas', 132,  3 )
              CabDiar ()

              select EnOSARQ
  
              cClieAnt := Clie
    
              @ nLin,01 say Clie             pict '999999'
              if Clie == '999999'
                @ nLin,08 say Cliente
              else  
                @ nLin,08 say ClieARQ->Nome
              endif  
              nLin ++
              @ nLin,06 say OrdS
              @ nLin,14 say Term             pict '99/99/9999'
              @ nLin,26 say Repr             pict '999999'
              @ nLin,33 say ReprARQ->Nome    pict '@S16'

              select IENOARQ
            endif
            dbskip(-1)
          endif
          
          dbskip ()
        enddo
        
        nElemCond   := ascan( aCond, { |nElem| nElem[1] == PediARQ->Cond } )

        if nElemCond > 0
          aCond[ nElemCond, 2 ] += nTotalNota
          aCond[ nElemCond, 3 ] += nDesconto
          aCond[ nElemCond, 4 ] += ( nTotalNota - nDesconto )
        else  
          aadd( aCond, { ENOSARQ->Cond, nTotalNota, nDesconto,( nTotalNota - nDesconto ) } )
        endif

        nTotalNota  -= nDesconto
        nTotalGeral += nTotalNota

        if nDemo == 1 .and. nTotalNota > 0
          @ nLin,111 say 'Total'
          @ nLin,119 say nTotalNota            pict '@E 999,999.99'
          nLin += 2
        endif

        select EnOSARQ

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
  endif

  cClieAnt := space(06)

  if nVendas == 2 .or. nVendas == 4
    select PediARQ
    set order    to 2
    set relation to Clie into ClieARQ, to Repr into ReprARQ, to Cond into CondARQ
    dbgotop ()
    do while Clie >= cClieIni .and. Clie <= cClieFin .and. !eof()
      if Emis        >= dDataIni .and. Emis        <= dDataFin .and.;
         val( Repr ) >= nReprIni .and. val( Repr ) <= nReprFin .and.;
         Hora        >= cHoraIni .and. Hora        <= cHoraFin
         
        if nDemo == 1
          if lInicio       
            set printer to ( cArqu2 )
            set device  to printer
            set printer on
          
            lInicio := .f.
          endif  

          if nLin == 0
            do case
              case nVendas == 2
                Cabecalho ( 'Diario de Vendas - Notas', 132, 3 )
              case nVendas == 4
                Cabecalho ( 'Diario de Vendas - Ambas', 132, 3 )
            endcase
            CabDiar ()
          endif

          if cClieAnt != Clie
            cClieAnt := Clie

            @ nLin,01 say Clie           pict '999999'

            if Clie == '999999'
              @ nLin,08 say Cliente
            else  
              @ nLin,08 say ClieARQ->Nome
            endif  
            nLin ++
          endif
        endif

        cNota      := Nota
        lVez       := .t.
        nTotalNota := 0
        nDesconto  := Desconto

        select IPedARQ
        set order    to 1
        set relation to Prod into ProdARQ
        dbseek( cNota, .t. )
        do while Nota == cNota .and. !eof()
          if Prod == '999999'
            ProdARQ->(dbgotop())
          endif  
        
          if Prod         >= cProdIni .and. Prod          <= cProdFin .and.;
            ProdARQ->Forn >= cFornIni .and. ProdARQ->Forn <= cFornFin .and.;
            ProdARQ->Grup >= cGrupIni .and. ProdARQ->Grup <= cGrupFin .and.;
            ProdARQ->SubG >= cSubgIni .and. ProdARQ->SubG <= cSubGFin
            
            nElem := ascan( aProd, { |nElem| nElem[1] == Prod } )

            if nElem > 0
              aProd[ nElem, 4 ] += Qtde
            else
              if Prod == '999999'
                aadd( aProd,{ Prod, Produto, ProdARQ->Unid, Qtde, PrecoVenda, 0 } )
              else  
                aadd( aProd,{ Prod, ProdARQ->Nome, ProdARQ->Unid, Qtde, PrecoVenda, ProdARQ->PrecoCusto } )
              endif  
            endif
           
            if nDemo == 1
              if lVez
                lVez   := .f.

                select PediARQ
                @ nLin,06 say Nota
                @ nLin,14 say Emis             pict '99/99/9999'
                @ nLin,26 say Repr             pict '999999'
                @ nLin,33 say ReprARQ->Nome    pict '@S16'
                select IPedARQ
              endif
            endif

            nValorTotal := ( PrecoVenda * Qtde )
            nTotalNota  += nValorTotal 
            nTotalVenda += ( Qtde * PrecoVenda )
            nTotalCusto += ( Qtde * ProdARQ->PrecoCusto )
 
            if nDemo == 1
              @ nLin,050 say Sequ                   pict '9999'
              @ nLin,055 say Prod                   pict '999999'
              if Prod == '999999'
                @ nLin,062 say Produto              pict '@S27'
              else  
                @ nLin,062 say ProdARQ->Nome        pict '@S27'
              endif  
              @ nLin,090 say ProdARQ->Unid
              if EmprARQ->Inteira == "X"
                @ nLin,094 say Qtde                 pict '@E 9999999999'
              else      
                @ nLin,094 say Qtde                 pict '@E 999999.999'
              endif     
              @ nLin,106 say PrecoVenda             pict PictPreco(10)
              @ nLin,119 say nValorTotal            pict '@E 999,999.99'
              nLin ++
            endif

            dbskip ()
 
            if nLin >= pLimite .and. !eof ()
              Rodape(132)

              cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
              cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

              set printer to ( cArqu2 )
              set printer on

              Cabecalho ( 'Diario de Vendas', 132,  3 )
              CabDiar ()

              select PediARQ
  
              cClieAnt := Clie
    
              @ nLin,01 say Clie             pict '999999'
              if Clie == '999999'
                @ nLin,08 say Cliente
              else  
                @ nLin,08 say ClieARQ->Nome
              endif  
              nLin ++
              @ nLin,06 say Nota
              @ nLin,14 say Emis             pict '99/99/9999'
              @ nLin,26 say Repr             pict '999999'
              @ nLin,33 say ReprARQ->Nome    pict '@S16'
              select IPedARQ
            endif
            dbskip(-1)
          endif
          dbskip ()
        enddo
        
        nElemCond   := ascan( aCond, { |nElem| nElem[1] == PediARQ->Cond } )

        if nElemCond > 0
          aCond[ nElemCond, 2 ] += nTotalNota
          aCond[ nElemCond, 3 ] += nDesconto
          aCond[ nElemCond, 4 ] += ( nTotalNota - nDesconto )
        else  
          aadd( aCond, { PediARQ->Cond, nTotalNota, nDesconto,( nTotalNota - nDesconto ) } )
        endif

        nTotalNota  -= nDesconto
        nTotalGeral += nTotalNota

        if nDemo == 1 .and. nTotalNota > 0
          @ nLin,111 say 'Total'
          @ nLin,119 say nTotalNota            pict '@E 999,999.99'
          nLin += 2
        endif

        select PediARQ

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
  endif
 
  select PediARQ
  set relation to

  cClieAnt := space(06)
 
  if nVendas == 1 .or. nVendas == 4
    select NSaiARQ
    set order    to 4
    set relation to Clie into ClieARQ, to Repr into ReprARQ, to Cond into CondARQ
    dbgotop()
    do while !eof ()
      if Clie        >= cClieIni .and. Clie        <= cClieFin .and.;
         val( Repr ) >= nReprIni .and. val( Repr ) <= nReprFin
         
// Emis >= dDataIni .and. Emis <= dDataFin

        if nLin >= pLimite
          Rodape(132)

          cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
          cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

          set printer to ( cArqu2 )
          set printer on
        endif

        if nDemo == 1
          if lInicio       
            set printer to ( cArqu2 )
            set device  to printer
            set printer on
          
            lInicio := .f.
          endif  
      
          if nLin == 0
            do case
              case nVendas == 1
                Cabecalho ( 'Diario de Vendas - Pedidos', 132, 3 )
              case nVendas == 4
                Cabecalho ( 'Diario de Vendas - Ambas', 132, 3 )
            endcase
            CabDiar ()
          endif

          if cClieAnt != Clie
            cClieAnt := Clie
          
            @ nLin,01 say Clie             pict '999999'

            if Clie == '999999'
              @ nLin,08 say Cliente
            else  
              @ nLin,08 say ClieARQ->Nome
            endif  

            nLin ++
          endif  
        endif

        cNota      := Nota
        lVez       := .t.
        nSubTotal  := 0
        nDesconto  := Desconto
        cCond      := Cond
        nElemCond  := ascan( aCond, { |nElem| nElem[1] == cCond } )
 
        select INSaARQ
        set order    to 1
        set relation to Prod into ProdARQ
        dbseek( cNota, .t. )
        do while Nota == cNota .and. !eof()
          if Prod == '999999'
            ProdARQ->(dbgotop())

            nElem := ascan( aProd, { |nElem| nElem[2] == Produto } )
          else  
            nElem := ascan( aProd, { |nElem| nElem[2] == ProdARQ->Nome } )
          endif  

    
            if nElem > 0
              aProd[ nElem, 4 ] += Qtde
            else
              if Prod == '999999'
                aadd( aProd,{ Prod, Produto, ProdARQ->Unid, Qtde, PrecoVenda, 0 } )
              else  
                aadd( aProd,{ Prod, ProdARQ->Nome, ProdARQ->Unid, Qtde, PrecoVenda, ProdARQ->PrecoCusto } )
              endif  
            endif

            if nDemo == 1
              if lVez
                lVez   := .f.
   
                select NSaiARQ
            
                @ nLin,06 say Nota
                @ nLin,14 say Emis             pict '99/99/9999'
                @ nLin,26 say Repr             pict '999999'
                @ nLin,33 say ReprARQ->Nome    pict '@S16'
            
                select INSaARQ
              endif
              
            nValorTotal := ( Qtde * PrecoVenda )
            nSubTotal   += ( Qtde * PrecoVenda )
            nTotalVenda += ( Qtde * PrecoVenda )
            nTotalCusto += ( Qtde * ProdARQ->PrecoCusto )
           
            if nDemo == 1
              @ nLin,050 say Sequ                   pict '9999'
              @ nLin,055 say Prod                   pict '999999'
              if Prod == '9999'
                @ nLin,062 say Produto              pict '@S27'
              else  
                @ nLin,062 say ProdARQ->Nome        pict '@S27'
              endif  
              @ nLin,090 say ProdARQ->Unid
              if EmprARQ->Inteira == "X"
                @ nLin,094 say Qtde                 pict '@E 9999999999'
              else              
                @ nLin,094 say Qtde                 pict '@E 999999.999'
              endif             
              @ nLin,106 say PrecoVenda             pict PictPreco(10)
              @ nLin,119 say nValorTotal            pict '@E 999,999.99'
              nLin ++
            endif
 
            dbskip ()
    
            if nLin >= pLimite .and. !eof()
              Rodape(132)
  
              cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
              cArqu2 := cArqu2 + "." + strzero( nPag, 3 )
  
              set printer to ( cArqu2 )
              set printer on
  
              Cabecalho ( 'Diario de Vendas', 132,  3 )
              CabDiar ()
 
              select NSaiARQ
              
              cClieAnt := Clie

              @ nLin,01 say Clie             pict '999999'
              if Clie == '9999'
                @ nLin,08 say Cliente
              else  
                @ nLin,08 say ClieARQ->Nome
              endif  
              nLin ++
              @ nLin,06 say Nota
              @ nLin,14 say Emis             pict '99/99/9999'
              @ nLin,26 say Repr             pict '999999'
              @ nLin,33 say ReprARQ->Nome    pict '@S16'
  
              select INSaARQ
            endif
            dbskip(-1)
          endif  
          dbskip ()
        enddo
        
        nJuros      := ( CondARQ->Acrs * nSubTotal ) / 100
        nSubTotal   -= nDesconto
        nTotalNota  := nSubTotal + nJuros  
        nTotalGeral += nTotalNota

        select NSaiARQ
     
        if nDemo == 1 .and. nTotalNota > 0
          @ nLin,111 say 'Total'
          @ nLin,119 say nTotalNota            pict '@E 999,999.99'
          nLin += 2
        endif

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
  endif

  if !lInicio .and. nTotalGeral > 0
    @ nLin,105 say 'Total Geral'
    @ nLin,119 say nTotalGeral            pict '@E 999,999.99'

    Rodape(132)
  endif  

  if len( aProd ) > 0
    cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
    cArqu2 := cArqu2 + "." + strzero( nPag, 3 )
   
    set device  to printer
    set printer to ( cArqu2 )
    set printer on

    Cabecalho ( 'Diario de Vendas - Demonstrativo', 132, 3 )
  
    select ProdARQ
    set order to 1
    nLin += 2

    if cClieIni == cClieFin 
      @ nLin,01 say 'Cliente ' + ClieARQ->Nome + ' ' + cClieIni
      @ nLin,01 say 'Periodo ' + dtoc( dDataIni ) + ' a ' + dtoc( dDataFin )
      nLin += 2 
    endif  

    @ nLin,01 say '                                     Demonstrativo por Produtos'
    nLin += 2
    @ nLin,01 say 'Cod Descrição                                UN.      Qtde.    P. Custo    P. Venda      %  Custo Estq.  Venda Estq.       Saldo'
    nLin ++
    @ nLin,01 say '---------------------------------------------------------------------------------------------------------------------------------'
    nLin ++
    
    nOrdem := 1
      
    do case
      case nOrdem == 1
        asort( aProd,,, { | Nome01, Nome02 | Nome01[2] < Nome02[2] } )
      case nOrdem == 2
        asort( aProd,,, { | Nome01, Nome02 | Nome01[1] < Nome02[1] } )
      case nOrdem == 3
        asort( aProd,,, { | Nome01, Nome02 | Nome01[4] > Nome02[4] } )
    endcase     
    
    nTotal := 0

    for nI := 1 to len( aProd )
      nTotal += aProd[ nI, 4 ]
    next
    
    nTotaCust := 0
    nTotaVend := 0
    nTotaQtde := 0
        
    for nI := 1 to len( aProd )
      cProd  := aProd[ nI, 1 ]
      cNome  := aProd[ nI, 2 ]
      cUnid  := aProd[ nI, 3 ]
      nQtde  := aProd[ nI, 4 ]
      nPreco := aProd[ nI, 5 ]
      nCusto := aProd[ nI, 6 ]

      if nQtde == 0
        loop
      endif
      
      nPerc := ( nQtde * 100 ) / nTotal

      @ nLin,001 say cProd
      @ nLin,008 say cNome               pict '@S38'
      @ nLin,047 say cUnid
      if EmprARQ->Inteira == "X"
        @ nLin,051 say nQtde             pict '@E 9999999999' 
      else      
        @ nLin,051 say nQtde             pict '@E 999999.999' 
      endif     
      @ nLin,063 say nCusto              pict PictPreco(10)
      @ nLin,075 say nPreco              pict PictPreco(10)
      @ nLin,086 say nPerc               pict '@E 999.99'
      @ nLin,095 say nCusto * nQtde      pict '@E 999,999.99'
      @ nLin,108 say nPreco * nQtde      pict '@E 999,999.99'
      @ nLin,120 say ( nPreco * nQtde ) - ( nCusto * nQtde )  pict '@E 999,999.99'
      nLin      ++
      nTotaCust += (nCusto * nQtde)
      nTotaVend += (nPreco * nQtde)
      nTotaQtde += nQtde

      if nLin >= pLimite
        Rodape(132)

        cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
        cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

        set printer to ( cArqu2 )
        set printer on

        Cabecalho ( 'Diario de Vendas - Demonstrativo', 132, 3 )
        nLin += 2
        @ nLin,01 say '           Demonstrativo por Produtos'
        nLin += 2
        @ nLin,01 say 'Cod Descrição                                UN.      Qtde.    P. Custo    P. Venda      %  Valor Estq.  Custo Estq.       Saldo'
        nLin ++
        @ nLin,01 say '---------------------------------------------------------------------------------------------------------------------------------'
        nLin ++
      endif
    next

    @ nLin,01 say '---------------------------------------------------------------------------------------------------------------------------------'

    if ( nLin + 4 ) >= pLimite
      Rodape(132)

      cArqu2 := left( cArqu2, ( len( cArqu2 ) - 4 ) )
      cArqu2 := cArqu2 + "." + strzero( nPag, 3 )

      set printer to ( cArqu2 )
      set printer on

      Cabecalho ( 'Diario de Vendas - Demonstrativo', 132, 3 )
      nLin += 2
      @ nLin,01 say 'Cod Descrição                                UN.  Preco Venda  Preco Custo      Qtde.      %  Valor Estq.  Custo Estq.       Saldo'
      nLin ++
      @ nLin,01 say '-----------------------------------------------------------------------------------------------------------------------------------'
      nLin ++
    endif

    @ nLin,039 say 'Total Geral'
    if EmprARQ->Inteira == "X"
      @ nLin,051 say nTotaQtde            pict '@E 9999999999' 
    else        
      @ nLin,051 say nTotaQtde            pict '@E 999999.999' 
    endif       
    @ nLin,097 say nTotaCust              pict '@E 999,999.99'
    @ nLin,110 say nTotaVend              pict '@E 999,999.99'
    @ nLin,122 say nTotaVend - nTotaCust  pict '@E 999,999.99'

    Rodape(132)
  endif
 
  set printer to
  set printer off
  set device  to screen
  
  if Imprimir( cArqu3, 132 )
    select SpooARQ
    if AdiReg()
      replace Rela       with cArqu3
      do case
        case nVendas == 1
          replace Titu   with 'Relatório do Di rio de Vendas - Pedidos'
        case nVendas == 2
          replace Titu   with 'Relatório do Di rio de Vendas - Notas'
        case nVendas == 3
          replace Titu   with 'Relatório do Di rio de Vendas - OS'
        case nVendas == 4
          replace Titu   with 'Relatório do Di rio de Vendas - Ambas'
      endcase    
      replace Data       with cRData
      replace Hora       with cRHora
      replace Usua       with cUsuario
      replace Tama       with 132
      replace Empr       with cEmpresa
      dbunlock ()
    endif
  endif  
  
  select ClieARQ
  close
  select PediARQ
  close
  select IPedARQ
  close
  select NSaiARQ
  close
  select INSaARQ
  close
  select CondARQ
  close
  select EnOsARQ
  close
  select IENOARQ
  close
  restscreen( 00, 00, 23, 79, tPrt )
return NIL

function CabUltV ()
  @ 02,01 say 'Cliente'
  @ 03,01 say '     Nota    Emissão     Vendedor              Seq. Prod. Descrição                      Un.      Qtde. Preço Venda  Valor Total'

  nLin     := 05
  cClieAnt := space(06)
return NIL