//  Leve, Usuários
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

function Usua ()

//  Variaveis de Entrada para Usu rio
nUsua  := 0
cUsua  := space(03)
cNome  := space(40)
cIden  := space(15)
cSenha := cPass := space(12)

//  Tela Usu rio
Janela ( 07, 10, 16, 68, 'Cadastro de Usuários', .t. )

setcolor ( CorJanel )
@ 09,12 say '      Usuário'
@ 10,12 say '         Nome'
@ 11,12 say 'Identificação'

@ 13,12 say '        Senha'

MostOpcao( 15, 12, 24, 44, 57 ) 
tUsua := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Usua
select UsuaARQ
set order to 1
dbgobottom ()
do while  .t.
  select UsuaARQ
  set order to 1

  Mensagem('Usua', 'Janela' )

  restscreen( 00, 00, 23, 79, tUsua )
  cStat := space(04)
  
  MostUsua()
  
  if Demo ()
    exit
  endif  

  setcolor ( CorJanel + ',' + CorCampo )
  MostTudo := 'MostUsua'
  cAjuda   := 'Usua'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()

  @ 09,26 get nUsua             pict '999999'
  read
  
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. nUsua == 0
    exit
  endif

  setcolor ( CorCampo )
  cUsua := strzero( nUsua, 6 )
  @ 09,26 say cUsua

  //  Verificar existencia do Usuario para Incluir, Alterar ou Excluir
  select UsuaARQ
  set order to 1
  dbseek( cUsua, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif

  Mensagem ('Usua', cStat )

  MostUsua()
  EntrUsua()

  Confirmar( 15, 12, 24, 44, 57, 3 )
 
  if cStat == 'excl'
    if ExclRegi ()
      select UsMeARQ
      set order to 1
      dbseek( cUsua, .t. )
      do while Usua == cUsua 
        if RegLock(30)
          dbdelete ()
          dbunlock ()
        endif
        dbskip ()
      enddo    
      
      select UsuaARQ      
    endif
  endif
  
  if cStat == 'incl'
    if AdiReg(30)
      if RegLock(30)
        replace Usua             with cUsua
        dbunlock ()
      endif
    endif
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock(30)
      replace Nome             with cNome
      replace Iden             with cIden
      replace Senha            with cSenha
      dbunlock ()
    endif
  endif
  
  if cStat == 'incl'
    ConfAces ()
  endif  
enddo

return NIL

//
// Configura acesso dos Usu rios
//
function ConfAces ()

  aAcesso := {}

  select UsMeARQ
  set order to 1
  dbgotop()
  cCopyUser := Usua
  do while Usua == cCopyUser .and. !eof()
    aadd( aAcesso, { Usua, Modu, Menu, Item } )
    
    if len( aAcesso ) == 4096
      exit
    endif
      
    dbskip () 
  enddo  
  
  for nK := 1 to len( aAcesso )
    if AdiReg(30)
      if RegLock(30)
        replace Usua         with cUsua
        replace Modu         with aAcesso[ nK, 2 ]
        replace Menu         with aAcesso[ nK, 3 ]
        replace Item         with aAcesso[ nK, 4 ]
        dbunlock ()
      endif
    endif
  next
  
  select ParaARQ
  dbgotop ()

  cVersao  := Versao
  cScreen  := Screen
  nLinha   := Linha
  nColuna  := Coluna
  CorFundo := rFundo
  CorCabec := rCabec
  CorMenus := rMenus
  CorOpcao := rOpcao
  CorBorda := rBorda
  CorJanel := rJanel
  CorCampo := rCampo
  CorBorJa := rBorJa
  CorAltKo := rAltKo
  CorAltKm := rAltKm
  CorAltKc := rAltKc

  for i := 1 to len( CorMenus ) 
    cFundo := substr( CorMenus, i, 1 )
    if cFundo == '/'  
      CorAcess := 'n+' + substr ( CorMenus, i  )
      exit
    endif
  next               
  
  dbseek( cUsua, .f. )  
  if eof()
    if AdiReg ()
      if RegLock(30)
        replace Usua    with cUsua
        replace Versao  with cVersao
        replace Screen  with cScreen
        replace Linha   with nLinha
        replace Coluna  with nColuna
        replace rFundo  with CorFundo
        replace rCabec  with CorCabec
        replace rMenus  with CorMenus
        replace rOpcao  with CorOpcao
        replace rJanel  with CorJanel
        replace rCampo  with CorCampo
        replace rBorja  with CorBorja
        replace rAltKo  with CorAltKo
        replace rAltKm  with CorAltKm
        replace rAcess  with CorAcess

        for n := 1 to len( CorAltKm )
          if substr( CorAltKm, n, 1 ) == '/'
            cCorIni := substr( CorAltKm, 1, n - 1 )
            for i := len( CorCampo ) to 1 step - 1
              if substr( CorCampo, i, 1 ) == '/'
                cCorFin  := substr( CorCampo, i )
                CorAltKc := cCorIni + cCorFin
              endif
            next  
          endif  
        next    
      
        replace rAltKc  with  CorAltkc
        dbunlock ()
      endif
    endif  
  endif  
  
  select UsuaARQ
return NIL

//
// Entra Dados do Usuário
//
function EntrUsua()
  if cStat == 'alte'
    if !Senha( cPass )
      return NIL 
    endif
  endif

  setcolor ( CorJanel + ',' + CorCampo )
  @ 10,26 get cNome                valid !empty( cNome )
  @ 11,26 get cIden                
  read

  do while .t.
    cSenha1 := PASSWORD( 13, 26, 12, chr(254) )
    Alerta( 'Digite a senha novamente' + space(51) + 'Tecle qualquer tecla para digitar... ' )
    cSenha2 := PASSWORD( 13, 26, 12, chr(254) )

    if cSenha1 != cSenha2
      @ 13,26 say space(10)
      Alerta( 'Senha incorreta, digite novamente' + space(42) + 'Tecle qualquer tecla para digitar... ' )
    else
      if lastkey() == K_ESC
        cSenha := space(12)
      else  
        cSenha := Encode( cSenha1 )  
      endif
      exit
    endif
  enddo
return NIL

//
// Mostra Dados do Usu rio
//
function MostUsua()
  if cStat != 'incl'
    nUsua  := val( Usua )  
  endif
    
  cNome  := Nome
  nTaman := len( alltrim( Senha ) )
  cIden  := Iden
  cPass  := decode( Senha )
  
  setcolor ( CorCampo )
  @ 09,26 say cUsua
  @ 10,26 say cNome                 
  @ 11,26 say cIden
  
  @ 13,26 say space(12)
  @ 13,26 say replicate( chr(254), nTaman )
  
  PosiDBF( 07, 68 )
return NIL