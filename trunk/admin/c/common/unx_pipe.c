#include <stdio.h>
#include <stdlib.h>
#include <sys/ipc.h>

/* Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved. */

/* SCCS ID keywords, do not remove */
/* static char *sccsid = "@(#)unx_pipe.c	1.1 09/08/03"; */

/*PVCS keyword, do not remove */
static char *sccsid = "$Workfile:   unx_pipe.c  $ $Revision:   2.1  $ $Modtime:   Jul 05 2013 10:27:58  $";

#define TRUE 1
#define FALSE 0


struct msgs
  {
    long type;
    char text[200];
  } msg;

int mkey;

extern unsigned long EXJobId;
extern char full_pipe_name[254];
extern short EXDebug;

write_pipe(fp,msg_line)
FILE *fp;
char *msg_line;
{
   int status, tries;
   char EXJobNo[10];
   FILE *pipe_file;
   char tmp_pipe[254];
   static int pipe_set=FALSE;

   msg.type=1;
   /* mkey = msgget(ftok(full_pipe_name,1),01666); */

   if (! pipe_set)
   {
      strcpy(tmp_pipe,"/tmp/EXOR_");
      strcat(tmp_pipe,full_pipe_name);
      strcpy(full_pipe_name,tmp_pipe);
      pipe_set = TRUE;
   }

   pipe_file=fopen(full_pipe_name,"r");
   if (pipe_file == NULL)
   {
      printf ("exorlsnr: ERROR - Unable to open pipe file %s\n",full_pipe_name);
      exit(1);
   }
   fclose(pipe_file);

   if (EXDebug)
      printf ("exorlsnr: INFO - Pipe File is %s\n",full_pipe_name);

   mkey = msgget(ftok(full_pipe_name,1),01666);

   i_toa(EXJobId,EXJobNo);
   strcpy(msg.text,EXJobNo);
   strcat(msg.text,",");
   strcat(msg.text,msg_line);

   status=1;
   tries=0;

   while (status != 0)
   {
      if (tries > 0)
      {
         printf ("INFO: Try Number %d\n",tries);
         fprintf(fp,"INFO: Try Number %d\n",tries);
      }

      status = msgsnd(mkey,&msg,strlen(msg.text),IPC_NOWAIT);

      if (status != 0)
      {
         printf ("INFO: Status of message send to pipe = %d\n",status);
         fprintf (fp,"INFO: Status of message send to pipe = %d\n",status);
         tries++;
         sleep(1);
      }
      else
         tries=0;

      if (tries > 20)
      {
         puts("ERROR: Exceeded max tries on Pipe");
         fprintf(fp,"ERROR: Exceeded max tries on Pipe\n");
         exit(4);
      }
   }
}
