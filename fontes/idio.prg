//  Leve, Cadastro de Idiomas
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

function Idio( xAlte )

if SemAcesso( 'Idio' )
  return NIL
endif  

if NetUse( "IdioARQ", .t. )
  VerifIND( "IdioARQ" )
  
  dOpenIdio := .t.
  
  #ifdef DBF_NTX
    set index to IdioIND1, IdioIND2
  #endif  
else
  dOpenIdio := .f.
endif

//  Variaveis de Entrada para Idioiç”es de Pagamento
nIdio := 0
cNome := space(30)

//  Tela Idioma
Janela ( 06, 12, 12, 70, mensagem( 'Janela', 'Idio', .f. ), .t. )

setcolor ( CorJanel )
@ 08,14 say '     Codigo'
@ 09,14 say '  Descrição'

MostOpcao( 11, 14, 26, 46, 59 ) 
tIdio := savescreen( 00, 00, 23, 79 )

//  Manutencao Cadastro de Idiomas
select IdioARQ
set order to 1
if dOpenIdio
  dbgobottom ()
endif  
do while  .t.
  Mensagem('Idio', 'Janela' )

  select IdioARQ
  set order to 1
 
  cStat := space(04)
  restscreen( 00, 00, 23, 79, tIdio )
  MostIdio()
  
  if Demo()
    exit
  endif  

  //  Entrar com Novo Codigo
  setcolor ( CorJanel + ',' + CorCampo )

  MostTudo := 'MostIdio'
  cAjuda   := 'Idio'
  lAjud    := .t.
  set key K_PGUP      to MostrARQ()
  set key K_PGDN      to MostrARQ()
  set key K_CTRL_PGUP to MostrARQ()
  set key K_CTRL_PGDN to MostrARQ()
  set key K_UP        to MostrARQ()
  
  if lastkey() == K_ALT_A
    nIdio := val( Idio )
  else  
    if xAlte 
      @ 08,26 get nIdio                      pict '99'
      read
    else
      dbgobottom ()
  
      nIdio := val( Idio ) + 1 
    endif  
  endif  
   
  set key K_PGUP      to 
  set key K_PGDN      to 
  set key K_CTRL_PGUP to 
  set key K_CTRL_PGDN to 
  set key K_UP        to 

  if lastkey() == K_ESC .or. nIdio == 0
    exit
  endif
  
  setcolor ( CorCampo )
  cIdio := strzero( nIdio, 2 )
  @ 08,26 say cIdio

  //  Verificar existencia do Idioma para Incluir, Alterar ou Excluir
  select IdioARQ
  set order to 1
  dbseek( cIdio, .f. )
  if eof()
    cStat := 'incl'
  else
    cStat := 'alte'
  endif

  Mensagem ('Idio', cStat )

  MostIdio()
  EntrIdio()

  Confirmar ( 11, 14, 26, 46, 59, 3 )

  if cStat ==  'prin'
  endif
    
  if cStat == 'excl'
    ExclRegi ()
  endif
  
  if cStat == 'incl'
    if AdiReg()
      if RegLock()
        replace Idio           with cIdio
        dbunlock ()
      endif  
    endif  
    
    aIdioma := {}
    
    select MenuARQ
    set order to 1
    dbseek( '01', .t. )
    
    do while Idio == '01' .and. !eof()
      aadd( aIdioma, { Modu, Menu, Item, Modulo, Desc, Tama, Tecl, Linh, Colu, Mens, Expr, Acao } )
      
      dbskip()
    enddo
    
    for nL := 1 to len( aIdioma )
      if AdiReg()
        if RegLock()
          replace Idio     with cIdio
          replace Modu     with aIdioma[ nL, 1 ]
          replace Menu     with aIdioma[ nL, 2 ]
          replace Item     with aIdioma[ nL, 3 ]
          replace Modulo   with aIdioma[ nL, 4 ]
          replace Desc     with aIdioma[ nL, 5 ]
          replace Tama     with aIdioma[ nL, 6 ]
          replace Tecl     with aIdioma[ nL, 7 ]
          replace Linh     with aIdioma[ nL, 8 ]
          replace Colu     with aIdioma[ nL, 9 ]
          replace Mens     with aIdioma[ nL,10 ]
          replace ExPr     with aIdioma[ nL,11 ]
          replace Acao     with aIdioma[ nL,12 ]
          dbunlock()
        endif
      endif
    next
    
    select IdioARQ
  endif

  if cStat == 'incl' .or. cStat == 'alte'
    if RegLock()
      replace Nome          with cNome
      dbunlock ()
    endif
  endif
enddo

if dOpenIdio
  select IdioARQ
  close 
endif

return NIL


//
// Entra Dados do Idioma
//
function EntrIdio()
  do while .t.
    lAlterou := .f.

    setcolor ( CorJanel + ',' + CorCampo )  
    @ 09,26 get cNome 
    read

    if cNome         != Nome; lAlterou := .t.
    endif
    
    if !Saindo(lAlterou)
      loop
    endif  
    
    exit
  enddo
return NIL

//
// Mostra Dados do Idioma Escolhido
//
function MostIdio()
  if cStat != 'incl'
    nIdio := val( Idio )
    cIdio := Idio
  endif
    
  cNome    := Nome
    
  setcolor ( CorCampo )
  @ 09,26 say cNome
  
  PosiDBF( 06, 70 )
return NIL