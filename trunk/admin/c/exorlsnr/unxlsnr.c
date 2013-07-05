#include <stdio.h>

/* Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved. */

/* SCCS ID keywords, do not remove */
static char *sccsid = "@(#)unxlsnr.c	1.1 09/08/03";

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <signal.h>
#include <string.h>
#ifndef WIN32
#include <unistd.h>
#endif

#ifndef F_OK
#define F_OK 00
#endif

extern int EXDebug;

int CreateChildProcess(params) 
char *params;
{ 
    int  res;
    char command_line[1000];
    char *prod_home;

    prod_home = getenv("PROD_HOME");
    if (! prod_home)
    {
       printf ("exorlsnr: ERROR: PROD_HOME Environment variable Not Set. Exit\n");
       return(0);
    }

    strcpy(command_line,prod_home);
    if (access(strcat(command_line,"/gri0205"),F_OK) != 0)
    {
       printf ("exorlsnr: ERROR: gri0205 Not Found in %s. Exit\n",prod_home);
       return(0);
    }

    strcpy(command_line,prod_home);
    if (access(strcat(command_line,"/gri0206"),F_OK) != 0)
    {
       printf ("exorlsnr: ERROR: gri0206 Not Found in %s. Exit\n",prod_home);
       return(0);
    }

    strcpy(command_line,prod_home);
    if (access(strcat(command_line,"/gri0207"),F_OK) != 0)
    {
       printf ("exorlsnr: ERROR: gri0207 Not Found in %s. Exit\n",prod_home);
       return(0);
    }

    strcpy(command_line,prod_home);
    strcat(command_line,"/gri0205 ");
    strcat(command_line,params);
    strcat(command_line," &");
 
    if (EXDebug)
      printf ("exorlsnr: Calling %s with EXDebug = %d\n",command_line,EXDebug);

   res=system(command_line);

    strcpy(command_line,prod_home);
    strcat(command_line,"/gri0206 ");
    strcat(command_line,params);
    strcat(command_line," &");
 
    if (EXDebug)
      printf ("exorlsnr: Calling %s with EXDebug = %d\n",command_line,EXDebug);
   res=system(command_line);

    strcpy(command_line,prod_home);
    strcat(command_line,"/gri0207 ");
    strcat(command_line,params);
    strcat(command_line," &");
 
    if (EXDebug)
      printf ("exorlsnr: Calling %s with EXDebug = %d\n",command_line,EXDebug);

   res=system(command_line);
}  
