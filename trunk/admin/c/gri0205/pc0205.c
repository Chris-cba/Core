#include <windows.h>
#include <stdio.h>
#include <process.h>

/* Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved. */

/* SCCS ID keywords, do not remove */
static char *sccsid = "@(#)pc0205.c	1.1 09/08/03";

extern int EXDebug;

HANDLE hChildStdinRd, hChildStdinWr, hChildStdinWrDup, 
       hChildStdoutRd, hChildStdoutWr, hInputFile, hSaveStdin, hSaveStdout; 
BOOL   CreateChildProcess(char *params); 


BOOL CreateChildProcess(params) 
char *params;
{ 
    PROCESS_INFORMATION piProcInfo; 
    STARTUPINFO siStartInfo; 
	DWORD INIT_STATE;
 
    siStartInfo.cb = sizeof(STARTUPINFO); 
    siStartInfo.lpReserved = NULL; 
    siStartInfo.lpReserved2 = NULL; 
    siStartInfo.cbReserved2 = 0; 
    siStartInfo.lpDesktop = NULL; 
    siStartInfo.dwFlags = 0; 
 
    if (EXDebug)
       printf ("gri9998: Calling %s with EXDebug = %d\n",params,EXDebug);

    if (EXDebug)
    {
	INIT_STATE = CREATE_NEW_CONSOLE|CREATE_NEW_PROCESS_GROUP;
    }
    else
    {
	INIT_STATE = DETACHED_PROCESS;
    }

    return CreateProcess(NULL, 
	params,        /* command line                       */ 
	NULL,          /* process security attributes        */ 
	NULL,          /* primary thread security attributes */ 
	TRUE,          /* handles are inherited              */ 
	INIT_STATE,
	NULL,          /* use parent's environment           */ 
	NULL,          /* use parent's current directory     */ 
	&siStartInfo,  /* STARTUPINFO pointer                */ 
	&piProcInfo);  /* receives PROCESS_INFORMATION       */ 
}  

BOOL SetHandlers()
{
   BOOL fSuccess;
   BOOL CtrlHandler(DWORD fdwCtrlType);

   if (EXDebug)
   {
      fSuccess = SetConsoleCtrlHandler(
              (PHANDLER_ROUTINE) CtrlHandler, TRUE);
   }
   return(fSuccess);
}

BOOL CtrlHandler(DWORD fdwCtrlType)
{
   if (EXDebug)
   {
      switch (fdwCtrlType)
      {
         case CTRL_C_EVENT:
            Beep(1000,1000);
            return TRUE;
         case CTRL_CLOSE_EVENT:
            return TRUE;
         case CTRL_BREAK_EVENT:
         case CTRL_LOGOFF_EVENT:
         case CTRL_SHUTDOWN_EVENT:
         default:
            return FALSE;
      }
   }
}
