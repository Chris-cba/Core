#include <stdio.h>
#include <windows.h>

/* SCCS ID keywords, do not remove */
/* static char *sccsid = "@(#)pc_pipe.c	1.1 09/08/03"; */

/* Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved. */

/*PVCS keyword, do not remove */
static char *sccsid = "$Workfile:   pc_pipe.c  $ $Revision:   2.1  $ $Modtime:   Jul 05 2013 10:27:20  $";

#define TRUE 1
#define FALSE 0

extern unsigned long EXJobId;
extern char full_pipe_name[254];
extern int EXDebug;

write_pipe(FILE *fp, char *message)
{
	char lpszMessage[1000];
	BOOL fResult;
	HANDLE hFile; 
	DWORD cbWritten; 
	DWORD err_res;
        char EXJobNo[10];
        char tmp_pipe[254];
        static int pipe_set=FALSE;
        LPSTR lpszSlotName[254];

        if (! pipe_set)
        {
           if (EXDebug)
              printf ("exorlsnr: INFO - Pipe File is exor_%s\n",full_pipe_name);
	   strcpy(tmp_pipe,"\\\\.\\mailslot\\exor_");
           strcat(tmp_pipe,full_pipe_name);
           strcpy(full_pipe_name,tmp_pipe);
           pipe_set = TRUE;
        }

        i_toa(EXJobId,EXJobNo);
        strcpy(lpszMessage,EXJobNo);
        strcat(lpszMessage,",");
	strcat(lpszMessage,message);

   /*
	hFile = CreateFile("\\\\.\\mailslot\\exor_STAFFS", 
		GENERIC_WRITE, 
		FILE_SHARE_READ,
		(LPSECURITY_ATTRIBUTES) NULL, 
		OPEN_EXISTING, 
		FILE_ATTRIBUTE_NORMAL, 
		(HANDLE) NULL); 
  */
	hFile = CreateFile(full_pipe_name,
		GENERIC_WRITE, 
		FILE_SHARE_READ,
		(LPSECURITY_ATTRIBUTES) NULL, 
		OPEN_EXISTING, 
		FILE_ATTRIBUTE_NORMAL, 
		(HANDLE) NULL); 

	if (hFile == INVALID_HANDLE_VALUE) 
	{
	   printf ("exorlsnr: ERROR - Unable to create pipe file %s\n",full_pipe_name);
	   return FALSE; 
	} 

	fResult = WriteFile(hFile, 
		lpszMessage, 
		(DWORD) lstrlen(lpszMessage) + 1,
		&cbWritten, 
		(LPOVERLAPPED) NULL); 

	if (!fResult) 
	{
	   printf ("exorlsnr: ERROR - Unabel to write to pipe file %s",full_pipe_name); 
	   return FALSE; 
	} 

	fResult = CloseHandle(hFile); 

	if (!fResult) 
	{
		printf ("exorlsnr: ERROR - Unable to close pipe file %s\n",full_pipe_name); 
		return FALSE; 
	} 

	return TRUE;
}
