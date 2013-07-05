#include <windows.h>
#include <stdio.h>
#include <process.h>
#ifndef F_OK
#define F_OK 00
#endif

/* Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved. */

/* SCCS ID keywords, do not remove */
static char *sccsid = "@(#)pclsnr.c	1.1 09/08/03";

extern int EXDebug;

#define BACKGROUND_WHITE  (WORD) 0x00f0
#define BACKGROUND_CYAN   (WORD) 0x0030
#define FOREGROUND_YELLOW (WORD) 0x0006
#define FOREGROUND_CYAN   (WORD) 0x0003
#define FOREGROUND_WHITE  (WORD) 0x0007


HANDLE hChildStdinRd, hChildStdinWr, hChildStdinWrDup, 
       hChildStdoutRd, hChildStdoutWr, hInputFile, hSaveStdin, hSaveStdout; 
BOOL   CreateChildProcess(char *params); 

BOOL CreateChildProcess(params) 
char *params;
{ 
    char command_line[1000];
    char *prod_home;

    PROCESS_INFORMATION piProcInfo; 
    STARTUPINFO siStartInfo; 
	DWORD INIT_STATE;

    prod_home = getenv("PROD_HOME");
    if (! prod_home)
    {
       printf ("exorlsnr: ERROR: PROD_HOME Environment variable not set. Exit\n");
       return(0);
    }

    strcpy(command_line,prod_home);
    if (access(strcat(command_line,"\\gri0205.exe"),F_OK) != 0)
    {
       printf ("exorlsnr: ERROR: gri0205 Not Found in %s. Exit\n",prod_home);
       return(0);
    }

    strcpy(command_line,prod_home);
    if (access(strcat(command_line,"\\gri0206.exe"),F_OK) != 0)
    {
       printf ("exorlsnr: ERROR: gri0206 Not Found in %s. Exit\n",prod_home);
       return(0);
    }

    strcpy(command_line,prod_home);
    if (access(strcat(command_line,"\\gri0207.exe"),F_OK) != 0)
    {
       printf ("exorlsnr: ERROR: gri0207 Not Found in %s. Exit\n",prod_home);
       return(0);
    }

	
    strcpy(command_line,prod_home);
    strcat(command_line,"\\gri0205.exe ");
    strcat(command_line,params);
    /* Set up members of STARTUPINFO structure. */ 

    siStartInfo.cb = sizeof(STARTUPINFO); 
    siStartInfo.lpReserved = NULL; 
    siStartInfo.lpTitle = NULL;
    if (EXDebug)
    {
	siStartInfo.dwXCountChars = 120;
	siStartInfo.dwYCountChars = 500;
	siStartInfo.dwFillAttribute = 
		BACKGROUND_BLUE | FOREGROUND_YELLOW |
		FOREGROUND_INTENSITY;
    }
    siStartInfo.lpReserved2 = NULL; 
    siStartInfo.cbReserved2 = 0; 
    siStartInfo.lpDesktop = NULL; 
    if (EXDebug)
    {
       siStartInfo.dwFlags = 
		STARTF_USECOUNTCHARS | STARTF_USEFILLATTRIBUTE;
    }
    else
    {
       siStartInfo.dwFlags = 0;
    }
 
    /* Create the child process. */ 
 
      if (EXDebug)
   	   printf ("exorlsnr: Calling %s with EXDebug = %d\n",command_line,EXDebug);

	if (EXDebug)
	{
		INIT_STATE = CREATE_NEW_CONSOLE|CREATE_NEW_PROCESS_GROUP;
	}
	else
	{
		INIT_STATE = DETACHED_PROCESS;
	}

    CreateProcess(NULL, 
	command_line,  /* command line                       */ 
	NULL,          /* process security attributes        */ 
	NULL,          /* primary thread security attributes */ 
	TRUE,          /* handles are inherited              */ 
	INIT_STATE,
	NULL,          /* use parent's environment           */ 
	NULL,          /* use parent's current directory     */ 
	&siStartInfo,  /* STARTUPINFO pointer                */ 
	&piProcInfo);  /* receives PROCESS_INFORMATION       */ 

    strcpy(command_line,prod_home);
    strcat(command_line,"\\gri0206.exe ");
    strcat(command_line,params);
      if (EXDebug)
   	   printf ("exorlsnr: Calling %s with EXDebug = %d\n",command_line,EXDebug);

    CreateProcess(NULL, 
	command_line,  /* command line                       */ 
	NULL,          /* process security attributes        */ 
	NULL,          /* primary thread security attributes */ 
	TRUE,          /* handles are inherited              */ 
	INIT_STATE,
	NULL,          /* use parent's environment           */ 
	NULL,          /* use parent's current directory     */ 
	&siStartInfo,  /* STARTUPINFO pointer                */ 
	&piProcInfo);  /* receives PROCESS_INFORMATION       */ 

    strcpy(command_line,prod_home);
    strcat(command_line,"\\gri0207.exe ");
    strcat(command_line,params);
      if (EXDebug)
   	   printf ("exorlsnr: Calling %s with EXDebug = %d\n",command_line,EXDebug);
    return CreateProcess(NULL, 
	command_line,  /* command line                       */ 
	NULL,          /* process security attributes        */ 
	NULL,          /* primary thread security attributes */ 
	TRUE,          /* handles are inherited              */ 
	INIT_STATE,
	NULL,          /* use parent's environment           */ 
	NULL,          /* use parent's current directory     */ 
	&siStartInfo,  /* STARTUPINFO pointer                */ 
	&piProcInfo);  /* receives PROCESS_INFORMATION       */ 
}  
