//  Leve, Reindexacao
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

function Reindall ()
  
  local nRegGrav := 0
  
  select LogoARQ
  
  if ArqLock(30)
    dbgotop ()
    do while !eof()
              
      if !empty( Usua ) .and. !empty( Hora ) .and. !empty( Data )
        nRegGrav ++
      endif
      dbskip ()
    enddo
  endif

  dbunlock ()  
  
  if nRegGrav > 1
    if TelaReor()
      return NIL
    else  
      select LogoARQ
      set order to 1
      dbgotop()
      do while !eof()
        if RegLock()
          replace Usua     with space(03)
          replace Data     with ctod('  /  /  ')
          replace Hora     with space(08)
          dbunlock ()
        endif  
        dbskip ()
      enddo
    endif  
  else
    dbgotop ()
    if cUsuario != Usua
      if TelaReor()
        return NIL
      else  
        select LogoARQ
        set order to 1
        dbgotop()
        do while !eof()
          if RegLock()
            replace Usua     with space(03)
            replace Data     with ctod('  /  /  ')
            replace Hora     with space(08)
            dbunlock ()
          endif  
          dbskip ()
        enddo
      endif  
    endif
  endif

  tRein := savescreen( 00, 00, 23, 79 )
  Janela ( 07, 09, 14, 66, mensagem( 'Janela', 'Orga', .f. ), .f. )
  setcolor ( CorJanel )
  @ 09,11 say 'Quando um registro é excluído, este permanece no banco'
  @ 10,11 say 'de dados até que os arquivos sejam compactados.       '
  @ 11,09 say chr(195) + replicate( chr(196), 56 ) + chr(180)
  @ 12,11 say '                        Compactar Arquivos            '
  @ 13,11 say '                                  Confirma            '

  setcolor( CorCampo + "," + CorOpcao )
  @ 12,54 say " Sim "
  @ 12,60 say " Não "
  @ 13,54 say " Sim "
  @ 13,60 say " Não "

  setcolor( CorAltKc )
  @ 12,55 say "S"
  @ 12,61 say "N"
  @ 13,55 say "S"
  @ 13,61 say "N"

  lReindexa := .f.
  lCompacta := .f.

  if ConfLine( 12, 54, 2 ) 
    lCompacta := .t.
  endif
  
  if lastkey () == K_ESC
    return NIL
  endif  

  if ConfLine( 13, 54, 1 ) 
    lReindexa := .t.
  endif

  if lReindexa
    Janela ( 09, 17, 15, 65, mensagem( 'Janela', 'Orga', .f. ), .f. )
    setcolor ( CorJanel )
    @ 11,19 say "Arquivo de dados"
    @ 12,19 say " Chave de acesso"
    @ 13,19 say "   Indice criado"
    @ 14,19 say "       Diretório"

    dbcloseall()
    
    do while .t.
      use IndeARQ exclusive new
  
      if !neterr ()
        #ifdef DBF_NTX 
          cInde1 := cCaminho + HB_OSpathseparator() + "IndeIND1.NTX" 

          ferase( cInde1 )
 
          index on Arqu to &cInde1

          set index to IndeIND1
        #endif  
        
        #ifdef DBF_CDX 
          cInde1 := cCaminho + HB_OSpathseparator() + "IndeARQ.CDX" 

          ferase( cInde1 )
 
          index on Arqu tag &cInde1
        #endif
        exit
      endif
      inkey(1)
    enddo

  do while .t.
    use EstrARQ shared new

    if !neterr ()
      #ifdef DBF_NTX     
        cInde1 := cCaminho + HB_OSpathseparator() + "EstrIND1.NTX"

        if !file( cInde1 )
          index on Arqu + Sequ to &cInde1
        endif
      
        set index to EstrIND1
      #endif

      #ifdef DBF_CDX
        if !file( 'EstrARQ.CDX' )
          index on Arqu + Sequ tag Arqu
        endif
      #endif

      exit
    endif
    inkey(1)
  enddo

    do while .t.
      use MensARQ shared new

      if !neterr ()
        #ifdef DBF_NTX
          cInde1 := cCaminho + HB_OSpathseparator() + "MensIND1.NTX"
          cInde2 := cCaminho + HB_OSpathseparator() + "MensIND2.NTX"

          ferase( cInde1 )
          ferase( cInde2 )

          index on Idio + Prog + Loca to &cInde1
          index on Mens to &cInde2

          set index to IndeIND1, IndeIND2
       #endif

        #ifdef DBF_CDX
          cInde1 := cCaminho + HB_OSpathseparator() + "MensARQ.CDX"
          
          ferase( cInde1 )

          if !file( cInde1 )
            index on Idio + Prog + Loca tag Idio
            index on Mens tag Mens
          endif
        #endif

        exit
      endif
      inkey(1)
    enddo
    
    do while .t.
      use EmprARQ exclusive new
  
      if !neterr ()
        if lCompacta
          pack
        endif  
        
        #ifdef DBF_NTX 
          cInde1 := cCaminho + "EmprIND1.NTX" 
          cInde2 := cCaminho + "EmprIND2.NTX"

          ferase( cInde1 )
          ferase( cInde2 )
      
          index on upper( Empr ) to &cInde1
          index on upper( Nome ) to &cInde2

          set index to EmprIND1, EmprIND2
        #endif  

        #ifdef DBF_CDX
          cInde := cCaminho + "EMPRARQ.cdx" 

          ferase( cInde )
      
          index on upper( Empr ) tag Empr
          index on upper( Nome ) tag Nome
        #endif  
        exit
      endif
      inkey(1)
    enddo
 
    select EmprARQ
    set order to 1
    dbseek( cEmpresa, .f. )
    
    setcolor ( CorCampo )
    aArqs := directory( ( cCaminho + HB_OSpathseparator() +  "TEMP" + HB_OSpathseparator() + "*.*" ), "D" )
      
    for nD := 1 to len( aArqs )
      @ 11,36 say space(12)
      @ 12,36 say space(25)
      @ 13,36 say space(12)
      @ 14,36 say space(28)
      
      @ 11,36 say aArqs[ nD, 1 ]
      @ 12,36 say 'Arquivos Tempor rios'
      @ 14,36 say cCaminho + HB_OSpathseparator() + "TEMP" + HB_OSpathseparator()

      ferase( cCaminho + HB_OSpathseparator() + "TEMP" + HB_OSpathseparator() + aArqs[ nD, 1 ] )
    next  
    
    select IndeARQ
    set order to 1  
    dbgotop ()
    do while ! eof()
      if alltrim( upper( Arqu ) ) == 'EMPRARQ'
        dbskip ()
        loop
      endif  
    
      @ 11,36 say space(12)
      @ 12,36 say space(25)
      @ 13,36 say space(12)
      @ 14,36 say space(28)
      
      if Para
        cDir := cCaminho
      else
        cDir := dirname()
      endif 

      cArqu := alltrim( Arqu )
      cChav := alltrim( Chav ) 

      @ 11,36 say alltrim( Arqu ) + ".DBF"
      @ 12,36 say left( Chav, 25 )
      @ 14,36 say left( cDir, 28 ) 

      if !file( cArqu + '.DBF' )
        CriaARQ( cArqu, .t. )
      endif  
      
      select IndeARQ
      
      #ifdef DBF_NTX
        cInde := cDir + HB_OSpathseparator() + alltrim( Inde ) + ".NTX"
      
        @ 13,36 say left( alltrim( Inde ) + ".NTX", 28 )

        ferase( cInde )   

        if NetUse( cArqu, .f. )
          if lCompacta
            if select( cArqu ) > 0
              pack 
            endif  
          endif
       
          index on &cChav to &cInde
          
          close
        endif  
      #endif
      
      #ifdef DBF_CDX
        cInde := cDir + HB_OSpathseparator() + alltrim( Inde ) + ".CDX"

        do while left( Arqu, len( cArqu ) ) == upper( cArqu ) .and. !eof()
          cIndeARQ := alltrim( Inde )
          cChav    := alltrim( Chav )
  
          @ 13,36 say cIndeARQ
      
          if NetUse( cArqu, .f. )
            if lCompacta
              if select( cArqu ) > 0
                pack 
              endif  
            endif

            index on &cChav tag &cIndeARQ

            close
          endif  

          select IndeARQ
          dbskip()
        enddo
      #endif

      select IndeARQ
      dbskip ()
    enddo

    dbcloseall ()
    
    do while .t.
      use IndeARQ exclusive new
  
      if !neterr ()
        #ifdef DBF_NTX 
          cInde1 := cCaminho + HB_OSpathseparator() + "IndeIND1.NTX" 

          ferase( cInde1 )
 
          index on Arqu to &cInde1

          set index to IndeIND1
        #endif  
        
        #ifdef DBF_CDX 
          cInde1 := cCaminho + HB_OSpathseparator() + "IndeARQ.CDX" 

          ferase( cInde1 )
 
          index on Arqu tag &cInde1
        #endif
        exit
      endif
      inkey(1)
    enddo

  do while .t.
    use EstrARQ shared new

    if !neterr ()
      #ifdef DBF_NTX     
        cInde1 := cCaminho + HB_OSpathseparator() + "EstrIND1.NTX"

        if !file( cInde1 )
          index on Arqu + Sequ to &cInde1
        endif
      
        set index to EstrIND1
      #endif

      #ifdef DBF_CDX
        if !file( 'EstrARQ.CDX' )
          index on Arqu + Sequ tag Arqu
        endif
      #endif

      exit
    endif
    inkey(1)
  enddo

    do while .t.
      use MensARQ shared new

      if !neterr ()
        #ifdef DBF_NTX
          cInde1 := cCaminho + HB_OSpathseparator() + "MensIND1.NTX"

          if !file( cInde1 )
            index on Idio + Prog + Loca to &cInde1
          endif

          set index to IndeIND1
       #endif

        #ifdef DBF_CDX
          cInde1 := cCaminho + HB_OSpathseparator() + "MensARQ.CDX"

          if !file( cInde1 )
            index on Idio + Prog + Loca tag Idio
            index on Mens tag Mens
          endif
        #endif

        exit
      endif
      inkey(1)
    enddo

    if NetUse( "EmprARQ", .t. )
      VerifIND( "EmprARQ" )

      #ifdef DBF_NTX
         set index to EmprIND1, EmprIND2
      #endif  
    endif

    if NetUse( "AjudARQ", .t. )
      VerifIND( "AjudARQ" )
   
      #ifdef DBF_NTX
        set index to AjudIND1, AjudIND2
      #endif  
    endif

    if NetUse( "MenuARQ", .t. )
      VerifIND( "MenuARQ" )

      #ifdef DBF_NTX
        set index to MenuIND1
      #endif  
    endif

    if NetUse( "UsMeARQ", .t. )
      VerifIND( "UsMeARQ" )

      #ifdef DBF_NTX
        set index to UsMeIND1
      #endif  
    endif

    if NetUse( "UsuaARQ", .t. )
      VerifIND( "UsuaARQ" )

      #ifdef DBF_NTX
        set index to UsuaIND1, UsuaIND2, UsuaIND3
      #endif  
    endif

    if NetUse( "LogoARQ", .t. )
      VerifIND( "LogoARQ" )
 
      #ifdef DBF_NTX
        set index to LogoIND1
      #endif  
    endif

    if NetUse( "ParaARQ", .t. )
      VerifIND( "ParaARQ" )

      #ifdef DBF_NTX
        set index to ParaIND1 
      #endif  
    endif
      
    select EmprARQ
    set order to 1
    dbseek( cEmpresa, .f. )
  endif

  restscreen( 00, 00, 23, 79, tRein )
return NIL

//
// Tela de atencao da reorganizacao
//
function TelaReor()
  tTela := savescreen( 00, 00, 23, 79) 

  tone ( 700, 4 )

  Janela( 06, 15, 14, 65, mensagem( 'Janela', 'Atencao', .f. ), .f. )
  setcolor( CorJanel )
 
  @ 08,17 say 'Não foi possivel  reorganizar  os  arquivos  do'
  @ 09,17 say 'sistema porque existe outros usuários usando os'
  @ 10,17 say 'mesmos. Certifique-se de  que todos os usuários'
  @ 11,17 say 'estão desconectados do sistema  para  fazer uma'  
  @ 12,17 say 'nova reorganização.'
  @ 13,17 say '                          Continuar '

  if ConfLine( 13, 53, 2 )
    lOka := .f.
  else
    lOka := .t.
  endif    

  restscreen( 00, 00, 23, 79, tTela ) 
return(lOka) 

//
// Controle do SPOOL de Impressão
//
function SpoolARQ()

  local aArqui := {}
  local cArqu  := CriaTemp(0)
  local cArqu1 := CriaTemp(1)

  aadd( aArqui, { "Rela",      "C", 008, 0 } )
  aadd( aArqui, { "Titu",      "C", 048, 0 } )
  aadd( aArqui, { "Data",      "D", 008, 0 } )
  aadd( aArqui, { "Hora",      "C", 008, 0 } )
  aadd( aArqui, { "Tama",      "N", 003, 0 } )
  aadd( aArqui, { "Regi",      "N", 008, 0 } )

  cChave := "dtos( Data ) + Hora"

  dbcreate( cArqu , aArqui )
  select 99
  use &cArqu exclusive new

  #ifdef DBF_NTX
    index on &cChave to &cArqu1
  #endif
  #ifdef DBF_CDX
    index on &cChave tag &cArqu1
  #endif

  if NetUse( "SpooARQ", .t. )
    VerifIND( "SpooARQ" )

    #ifdef DBF_NTX
      set index to SpooIND1
    #endif  
  endif

  //  Tela
  Janela( 02, 05, 21, 75, mensagem( 'Janela', 'SpoolARQ', .f. ), .f. )
  Mensagem( 'Orga', 'SpoolARQ' )

  setcolor ( CorJanel )
  @ 04,07 say '   Usuário'
  @ 04,60 say 'Qtde.'
  @ 07,05 say chr(195) + replicate( chr(196), 69 ) + chr(180)

  @ 07,16 say chr(194)
  @ 07,25 say chr(194)
  @ 06,06 say "Data"
  @ 06,17 say "Hora"
  @ 06,26 say "Relatório"

  for nU := 08 to 20
    @ nU,16 say chr(179)
    @ nU,25 say chr(179)
  next

  @ 21,16 say chr(193)
  @ 21,25 say chr(193)

  setcolor( CorCampo )
  @ 04,18 say space(06)
  @ 04,25 say space(30)
  @ 04,66 say space(04)
 
  tSpool := savescreen( 00, 00, 23, 79 )
  do while .t.
    select 99
//    zap

    restscreen( 00, 00, 23, 79, tSpool )

    Mensagem( "Orga", "Browse" ) 

    //  Variaveis de Entrada
    cUsua := space(03)
    nUsua := 0

    setcolor ( CorJanel + ',' + CorCampo )

    cAjuda   := 'Spoo'
    lAjud    := .t.
    set key K_PGUP      to
    set key K_PGDN      to
    set key K_CTRL_PGUP to
    set key K_CTRL_PGDN to
    set key K_UP        to

    @ 04,18 get nUsua            pict '999999' valid ValidARQ( 04, 18, "99","Código" ,"Usua","Descrição","Nome","Usua","nUsua",.t.,6,"Usu rios","UsuaARQ", 30 )
    read

    if lastkey() == K_ESC
      exit
    endif

    nQtde := 0
    cUsua := strzero( nUsua, 6 )

    select SpooARQ
    set order to 1
    dbseek( cEmpresa + cUsua, .t. )
    do while !eof() .and. Empr == cEmpresa .and. Usua == cUsuario
      nRegi := recno()
      nQtde ++
        
      select 99
      if AdiReg()
        replace Rela        with SpooARQ->Rela
        replace Titu        with SpooARQ->Titu
        replace Data        with SpooARQ->Data
        replace Hora        with SpooARQ->Hora
        replace Tama        with SpooARQ->Tama
        replace Regi        with nRegi
        dbunlock ()

        select SpooARQ
        dbskip ()
      endif  
    enddo
    
    setcolor( CorCampo )
    @ 04,66 say nQtde                   pict '9999'

    select 99
    dbgotop ()
    setcolor ( CorJanel + ',' + CorCampo )
    cCor            := setcolor()
    oColuna         := TBrowseDb( 06, 06, 21, 74 )
    oColuna:headsep := chr(194)+chr(196)
    oColuna:colsep  := chr(179)
    oColuna:footsep := chr(193)+chr(196)

    oColuna:addColumn( TBColumnNew("Data",      {|| Data } ) )
    oColuna:addColumn( TBColumnNew("Hora",      {|| Hora } ) )
    oColuna:addColumn( TBColumnNew("Relatório", {|| Titu } ) )
    oColuna:goTop()

    lExitRequested := .f.
    oColuna:freeze := 1
    nLinBarra      := 1
    nTotal         := lastrec()
    BarraSeta      := BarraSeta( nLinBarra, 07, 21, 75, nTotal )

    do while !lExitRequested
      oColuna:forcestable()

      cTecla := 0
      nLin   := row()
      cTecla := Teclar(0)

      iif( BarraSeta, BarraSeta( nLinBarra, 07, 21, 75, nTotal ), NIL )

      if oColuna:hitTop .or. oColuna:hitBottom
        tone( 125, 0 )
      endif

      do case
        case cTecla == K_DOWN .or. cTecla == K_PGDN .or. cTecla == K_CTRL_PGDN
          if !oColuna:hitBottom
             nLinBarra ++
             if nLinBarra >= nTotal
               nLinBarra := nTotal
             endif
          endif
          if cTecla == K_DOWN
             oColuna:Down()
          endif
          if cTecla == K_PGDN
             oColuna:PageDown()
          endif
          if cTecla == K_CTRL_PGDN
             oColuna:goBottom()
          endif
        case cTecla == K_UP .or. cTecla == K_PGUP .or. cTecla == K_CTRL_PGUP
          if !oColuna:hitTop
             nLinBarra --
             if nLinBarra < 1
               nLinBarra := 1
             endif
          endif
          if cTecla == K_UP
            oColuna:Up()
          endif
          if cTecla == K_PGUP
            oColuna:PageUp()
          endif
          if cTecla == K_CTRL_PGUP
            oColuna:goTop()
          endif
        case cTecla == K_ENTER
          if !empty( Data )
            tTela    := savescreen( 00, 00, 23, 79 )
            mArqu    := directory( cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() + alltrim( Rela ) + ".*" )
            nPagiIni := 1
            nPagiFin := len( mArqu )

            Janela( 07, 15, 14, 64, mensagem( "Janela", "Orga2", .f. ), .f. )
            do while .t.
              setcolor( Corjanel )
              @ 09,17 say "     Relatório em ..."
              @ 10,17 say "     Página inicial ?"
              @ 11,17 say "       Página final ?"
              @ 12,17 say "   Número de cópias ?"
              @ 13,17 say "           Confirma ?"

              setcolor( CorCampo + "," + CorOpcao )
              @ 09,39 say " Video "
              @ 09,47 say " Impressora "
              @ 10,39 say nPagiIni                pict '999'
              @ 11,39 say nPagiFin                pict '999'
              @ 12,39 say "0001"
              @ 13,39 say " Sim "
              @ 13,45 say " Não "

              setcolor( CorAltKc )
              @ 13,40 say "S"
              @ 13,46 say "N"

              aOpcoes := {}
              nCopia  := 1
              nOpprt  := 1

              aadd( aOpcoes, {" Video ",      2, "V", 9, 39, "Configura Relatório para video"})
              aadd( aOpcoes, {" Impressora ", 2, "I", 9, 47, "Configura Relatório para impressora"})

              nOpprt :=  HChoice( aOpcoes, 2, nOpprt)
              do case
                case nOpprt == 0
                  exit
                case nOpprt == 2
                  if !TestPrint( EmprARQ->Relatorio )
                    loop
                  endif
              endcase
              
              setcolor( CorJanel + ',' + CorCampo )
              @ 10,39 get nPagiIni   pict '999'   valid nPagiIni > 0   
              @ 11,39 get nPagiFin   pict '999'   valid nPagiFin >= nPagiIni 
              
              if nOpPrt == 2
                @ 12,39 get nCopia   pict "9999"  valid nCopia > 0
              endif  
              read

              if ConfLine( 13, 39, 1 ) 
                if nOpprt == 1
                  for x := nPagiIni to nPagiFin
                    cFile := cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() + alltrim( mArqu[ x, 1 ] )
                    cTit  := mensagem( 'Janela', 'Orga3', .f. ) + " " + strzero( x, 3 ) + " de " + strzero( nPagiFin, 3 )

                    Janela( 01, 01, 21, 78, cTit, .F.)
                    cCor := setcolor()

                    Mensagem( "Orga", "SpoolARQ2" )
                    
                    cFile := memoedit( memoread( cFile ), 02, 03, 20, 77, .f., "SpoolMemo", Tama, , , 1, 0 )

                    setcolor( cCor )
                    
                    if lastkey () == K_CTRL_R
                      loop
                    endif  
                    
                    if lastkey() == K_ESC
                      exit
                    endif
                  next
                  if lastkey() == K_ESC
                    exit
                  endif
                else
                  Janela( 08, 30, 12, 55, "Imprimindo...", .f. )
                  setcolor( CorJanel )
                  @ 10,32 say " Cópia      de "
                  @ 11,32 say "Pagina      de "
                     
                  set device to print
                  for y := 1 to nCopia
                    set device to screen
                    @ 10,39 say strzero( y, 4 )
                    @ 10,47 say strzero( nCopia, 4 )
                    set device to print

                    for x := nPagiIni to nPagiFin
                      set device to screen
                      @ 11,39 say strzero( x, 3 )
                      @ 11,47 say strzero( nPagiFin, 3 )

                      cFile := cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() + alltrim( mArqu[ x, 1 ] )
                      cFile := memoread( cFile )

                      set device to print
                      
                      setprc( 0, 0 )

                      @ 00,00 say cfile
                      
                      eject

                      if inkey() == K_ESC
                        y := 10000
                        x := 10000
                      endif
                    next
                    if lastkey() == K_ESC
                      y := 10000
                      x := 10000
                    endif
                  next
                  set device to screen
                  exit
                endif
              endif
              exit
            enddo
            restscreen( 00, 00, 23, 79, tTela )
          endif
      case cTecla == K_RIGHT;       oColuna:right()
      case cTecla == K_LEFT;        oColuna:left()
      case cTecla == K_HOME;        oColuna:home()
      case cTecla == K_END;         oColuna:end()
      case cTecla == K_CTRL_LEFT;   oColuna:panLeft()
      case cTecla == K_CTRL_RIGHT;  oColuna:panRight()
      case cTecla == K_CTRL_HOME;   oColuna:panHome()
      case cTecla == K_CTRL_END;    oColuna:panEnd()
      case cTecla == K_ESC;         lExitRequested := .t.
      case cTecla == K_DEL
        if ! empty( Data )
          mArqu := directory( cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() + alltrim( Rela ) + ".*" )
          nPag  := len ( mArqu )
          nRegi := Regi
          nQtde := 0

          select SpooARQ
          go nRegi
          if RegLock()
            dbdelete ()
            dbunlock ()

            for x := 1 to nPag
              cFile := cCaminho + HB_OSpathseparator() + "spool" + HB_OSpathseparator() + alltrim( mArqu[ x, 1 ] )
              ferase( cFile )
            next

            select 99

            dbdelete ()
            
            dbgotop ()
            do while !eof ()
              nQtde ++
              dbskip ()
            enddo  

            setcolor( CorCampo )
            @ 04,66 say nQtde                   pict '9999'

            oColuna:refreshCurrent()
            oColuna:gotop()
          endif

          select 99
        endif
      endcase
    enddo
  enddo
  
  select SpooARQ
  close
  select 99
  close
  ferase( cArqu )
  ferase( cArqu1 )
return NIL

//
function SpoolMemo( wModo, wlin , wCol )
  setcolor( CorCabec )
  @ 01,60 say "Lin: " + str( wLin, 2 ) + " Col: " + str( wCol, 3 )

  setcolor( CorJanel )
  nKey    := lastkey()
  cRetVal := 0

  if nKey == K_CTRL_RET // .and. wModo == 0
    keyboard(chr(K_ESC)+chr(K_ENTER))
  
//    cRetVal := K_ESC
  endif
  
//  if nKey == K_CTRL_R
//    cRetVal := K_ESC
//    x --
//    
//    if x <= 0
//      x := 1
//    endif  
//  endif
return( cRetVal )

//
// Editor de Relatorios 
//
function EditPrint()
  tMostra   := savescreen( 00, 00, 24, 79 )
  
  if NetUse( "PrinARQ", .t. )
    VerifIND( "PrinARQ" )
  
    lOpenPrin := .t.

    #ifdef DBF_NTX
      set index to PrinIND1, PrinIND2
    #endif  
  else
    lOpenPrin := .f.
  endif

  select PrinARQ
  set order  to 2
  dbgotop()

  Janela( 03, 02, 20, 76, mensagem( 'Janela', 'EditPrint', .f. ), .f. ) 
  setcolor ( CorJanel + ',' + CorCampo )

  oFile         := TBrowseDb( 05, 03, 18, 75 )
  oFile:headsep := chr(194)+chr(196)
  oFile:footsep := chr(193)+chr(196)
  oFile:colsep  := chr(179)

  oFile:addColumn( TBColumnNew("Descrição",   {|| left( Desc, 15 ) } ) )
  oFile:addColumn( TBColumnNew("Titulo",      {|| left( Titulo, 20 ) } ) )
  oFile:addColumn( TBColumnNew("LI",          {|| LinIni } ) )
  oFile:addColumn( TBColumnNew("CI",          {|| ColIni } ) )
  oFile:addColumn( TBColumnNew("LF",          {|| LinFin } ) )
  oFile:addColumn( TBColumnNew("CF",          {|| ColFin } ) )
  oFile:addColumn( TBColumnNew("TXT",         {|| '...' } ) )
  oFile:addColumn( TBColumnNew("Mensagem",    {|| left( Mensagem, 17 ) } ) )
          
  lExitRequested := .f.
  nLinBarra      := 1
  cLetra         := ''
  nTotal         := lastrec()
  BarraSeta      := BarraSeta( nLinBarra, 16, 18, 76, nTotal )
    
  oFile:freeze := 1
  oFile:colPos := 1
   
  setcolor ( CorCampo )
  @ 19,13 say space(30)
    
  setcolor( CorJanel + ',' + CorCampo )
  @ 06,02 say chr(195)
  @ 06,76 say chr(180)
  @ 18,02 say chr(195)
  @ 18,76 say chr(180)
  @ 19,04 say 'Consulta'

  do while !lExitRequested
    Mensagem( 'Orga', 'EditPrint' ) 

    oFile:forcestable()

    PosiDBF( 03, 76 )
    
    iif( BarraSeta, BarraSeta( nLinBarra, 06, 18, 76, nTotal ), NIL )

    if oFile:stable
      if oFile:hitTop .or. oFile:hitBottom
        tone( 125, 0 )        
      endif  

      cTecla := Teclar(0)
    endif
 
    do case
      case cTecla == K_DOWN;        oFile:down()
      case cTecla == K_UP;          oFile:up()
      case cTecla == K_PGDN;        oFile:pageDown()
      case cTecla == K_PGUP;        oFile:pageUp()
      case cTecla == K_CTRL_PGUP;   oFile:goTop()
      case cTecla == K_CTRL_PGDN;   oFile:goBottom()
      case cTecla == K_RIGHT;       oFile:right()
      case cTecla == K_LEFT;        oFile:left()
      case cTecla == K_HOME;        oFile:home()
      case cTecla == K_END;         oFile:end()
      case cTecla == K_CTRL_LEFT;   oFile:panLeft()
      case cTecla == K_CTRL_RIGHT;  oFile:panRight()
      case cTecla == K_CTRL_HOME;   oFile:panHome()
      case cTecla == K_CTRL_END;    oFile:panEnd()
      case cTecla == K_INS .or. cTecla == K_ALT_A
       
        if cTecla == K_INS        
          cDesc     := cTitulo  := cMensagem := space(80)
          nLinIni   := nColIni  := nLinFin   := nColFin  := 0
          lDivisao  := .t.
          cConteudo := ''
        else
          cDesc     := Desc
          cTitulo   := Titulo
          cMensagem := Mensagem
          nLinIni   := LinIni
          nLinFin   := LinFin
          nColIni   := ColIni
          nColFin   := ColFin  
          lDivisao  := Divisao
          cConteudo := Conteudo
        endif
        
        cTexto   := '...'
        
        
        do case
          case oFile:ColPos >= 3 .and. oFile:ColPos >= 5
            MemoJane()  
            loop
        endcase  

        tFiscal := savescreen( 00, 00, 23, 79 )
        
        Janela( 08, 07, 15, 67, mensagem( 'Orga', 'EditPrint2', .f. ), .f. )
        Mensagem( 'Orga', 'EditPrint3' )

        setcolor( CorJanel + ',' + CorCampo )
        @ 10,09 say 'Descrição'
        @ 12,09 say '   Titulo'
        @ 13,09 say '  Posição                 Divisão       Conteudo'
        @ 14,09 say ' Mensagem'

        setcolor( CorJanel )
        @ 10,19 get cDesc           pict '@S45'
        @ 12,19 get cTitulo         pict '@S45'
        @ 13,19 get nLinIni         pict '99'
        @ 13,22 get nColIni         pict '99'
        @ 13,25 get nLinFin         pict '99' valid nLinFin >= nLinIni
        @ 13,28 get nColFin         pict '99' valid nColFin >= nColIni
        @ 13,43 get lDivisao  
        @ 13,58 get cTexto          valid MemoJane ()
        @ 14,19 get cMensagem       pict '@S45'
        read

        if lastkey() == K_ESC
          restscreen( 00, 00, 23, 79, tFiscal )
          loop
        endif

        select PrinARQ
        set order to 1
        
        if cTecla == K_INS
          dbgobottom ()

          nCod := Codigo + 1
        
          if AdiReg()
            if RegLock()
              replace Codigo        with nCod
              dbunlock()
            endif
          endif
        endif      
        
        if RegLock()    
          replace Desc            with cDesc
          replace LinIni          with nLinIni
          replace ColIni          with nColIni
          replace LinFin          with nLinFin
          replace ColFin          with nColFin 
          replace Titulo          with cTitulo
          replace Divisao         with lDivisao
          replace Mensagem        with cMensagem
          dbunlock ()
        endif
        
        restscreen( 00, 00, 23, 79, tFiscal )

        oFile:refreshAll()
      case cTecla == K_ESC .or. cTecla == K_ENTER;  lExitRequested := .t.
      case cTecla == K_BS
        cLetra := substr( cLetra, 1, len( cLetra ) - 1 )
      
        setcolor ( CorCampo )
        @ 19,13 say space(30)
        @ 19,13 say cLetra
      case cTecla >= 32 .and. cTecla <= 128
        cLetra += chr( cTecla )    

        if len( cLetra ) > 30
          cLetra := ''
        endif  
     
        setcolor ( CorCampo )
        @ 19,13 say space(30)
        @ 19,13 say cLetra

        dbseek( cLetra, .t. )
        oFile:refreshAll()
    endcase
  enddo
  
  select PrinARQ
  
  if lOpenPrin
    close
  endif
  restscreen( 00, 00, 24, 79, tMostra )
return NIL

function MemoJane()
  tMemoJanela := savescreen( 00, 00, 23, 79 )
  cTitulo     := alltrim( cTitulo )
  
  Janela( nLinIni, nColIni, nLinFin, nColFin, cTitulo, lDivisao )
  Mensagem( cMensagem )
  setcolor( CorJanel + ',' + CorCampo )
  
  cConteudo := memoedit( cConteudo, nLinIni+1, nColIni+1, nLinFin-3, nColFin-1, .t., "OutRela", (nColFin-nColIni) )
  
  restscreen( 00, 00, 23, 79, tMemoJanela )
return(.t.)

function OutRela( wModo, wlin , wCol )
  nKey    := lastkey()
  cRetVal := 0
  lMoveu  := .f.

  do case 
    case nKey == K_CTRL_RET;      keyboard(chr(K_CTRL_W))
    case nKey == K_ALT_UP;        nLinIni --; lMoveu := .t.
    case nKey == K_ALT_DOWN;      nLinIni ++; lMoveu := .t.
    case nKey == K_ALT_LEFT;      nColIni --; lMoveu := .t.
    case nKey == K_ALT_RIGHT;     nColIni ++; lMoveu := .t.
    case nKey == K_CTRL_LEFT;     nColFin --; lMoveu := .t.
    case nKey == K_CTRL_RIGHT;    nColFin ++; lMoveu := .t.
    case nKey == K_CTRL_UP;       nLinFin --; lMoveu := .t.
    case nKey == K_CTRL_DOWN;     nLinFin ++; lMoveu := .t.
  endcase
  
  if lMoveu
    restscreen( 00, 00, 23, 79, tMemoJanela )

    Janela( nLinIni, nColIni, nLinFin, nColFin, cTitulo, lDivisao )
    Mensagem( '<CTRL+Setas> e <ALT+Setas> Dimensionar Janela' )
  endif
  
  setcolor( CorJanel + ',' + CorCampo )
return( cRetVal )