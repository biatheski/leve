/*
//
// Retorna o numero de serie da HD
//
function HD_Serie(cDrive)

  Local n       := HDGETSERIAL( cDrive )
  Local cHex    := HB_NUMTOHEX(n)
  Local cResult := ''

  cResult := SubStr(cHex,1,4)+'-'+SubStr(cHex,5,4)
return(cResult)

#pragma begindump
#include "windows.h"
#include "hbapi.h"

unsigned long Get_SerialNumber(char* RootPathName)
{
   unsigned long SerialNumber;

   GetVolumeInformation(RootPathName, NULL, 0, &SerialNumber,
                        NULL, NULL, NULL, 0);
   return SerialNumber;
}

HB_FUNC( HDGETSERIAL)

{
   hb_retnl( Get_SerialNumber(hb_parc(1)) );
}

#pragma enddump