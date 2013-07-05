/* SCCS ID keywords, do not remove */
/* "@(#)sqlext.h	1.1 09/08/03"                       */

/* Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved. */

/*PVCS keyword, do not remove         */
/* $Workfile:   sqlext.h  $ $Revision:   2.1  $ $Modtime:   Jul 05 2013 10:27:52  $ */

/*
** External declarations for standard sql modules
*/

#define MAXPARAMS 20  /* Define the maximum no. GRI params to be retrieved */

EXEC SQL BEGIN DECLARE SECTION;
VARCHAR				EXRepDir[255];
VARCHAR				EXSpoolFileName[15];
VARCHAR				EXParam[MAXPARAMS][255];
short         		EXParami[MAXPARAMS];
unsigned long 		EXJobId;
short      			EXParamCount;
EXEC SQL END DECLARE SECTION;

EXEC SQL INCLUDE sqlca;
EXEC SQL INCLUDE oraca;

EXEC ORACLE OPTION (HOLD_CURSOR=YES);

void jobmain();

#define ORANOREC  (sqlca.sqlcode == 1403)
