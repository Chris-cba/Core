/* SCCS ID keywords, do not remove */
/* "@(#)rmms.h	1.2 05/20/04"                       */

/* Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved. */

/*PVCS keyword, do not remove         */
/* $Workfile:   rmms.h  $ $Revision:   2.1  $ $Modtime:   Jul 05 2013 10:27:34  $ */

#define MAXLINE 600 /* Maximum length of input records           */

#define slen_varchar(varstg) varstg.len=strlen(varstg.arr);
#define term_varchar(varstg) varstg.arr[varstg.len]='\0';

#define ROWS 100    /* This constant defines the size of the C   */
                    /* host variable arrays used for database    */
                    /* fetches. It should be put in the header   */
                    /* file RMMS.H                               */


#define EOFTCH 1403 /* This constant defines the number used to  */
                    /* indicate that a SQL fetch is complete.    */
                    /* It should be put in the header file       */
                    /* RMMS.H                                    */

#define DBUG    0 
#define SILMAX  100
#define TRUE    1
#define MAXCODES 2000 /* Maximum number of code values in aray   */
#define SUCCESS 1
#define PREP    0     /* Used to display Code Array preparation  */
#define CODES   0     /* Used to display Code Values in R4Util   */
#define G_REC   0     /* Used to display 'G' record details only */
#define H_REC   0     /* Used to display 'H' record details only */
#define I_REC   0     /* Used to display 'I' record details only */
#define J_REC   0     /* Used to display 'J' record details only */
#define K_REC   0     /* Used to display 'K' record details only */
#define L_REC   0     /* Used to display 'L' record details only */
#define M_REC   0     /* Used to display 'M' record details only */
#define N_REC   0     /* Used to display 'N' record details only */
#define P_REC   0     /* Used to display 'P' record details only */
#define Q_REC   0     /* Used to display 'Q' record details only */
#define R_REC   0     /* Used to display 'R' record details only */
#define S_REC   0     /* Used to display 'S' record details only */

#define FALSE   0
#define FAIL    0
#define IOERROR -1
#define SEPERATOR ','
#define POSDATE 3
#define POSINITS 2

#define BOOLEAN int
/* Maxlline is used in bpr2200c and should be 1001 in value */
#define MAXLLINE  1001 
#define TMAXLLINE 85

/* Porting Considerations */

#ifdef VMS
#define exit SYS$EXIT
#endif

#ifdef ibm
#define EX_SUCC 0 /* success exit status */
#define EX_FAIL 8 /* failure exit status */
#else
#define EX_SUCC 0 /* success exit status */
#define EX_FAIL 1 /* failure exit status */
#endif

/* Define error codes */

#define BPR8000 "ERROR: error in outputing previous error condition BPR-8000"
#define BPR8001 "ERROR: error in opening file for error output BPR-8001"
#define BPR8002 "ERROR: error in opening file for load input BPR-8002"
#define BPR8003 "ERROR: X record encountered before end of file BPR-8003"
#define BPR8004 "ERROR: non x record encountered at end of file BPR-8004"
#define BPR8005 "ERROR: load terminated before end of load file BPR-8005"
#define BPR8006 "ERROR: error in closing input load file BPR-8006"
#define BPR8007 "ERROR: error in closing error output file BPR-8007"
#define BPR8008 "ERROR: unknown husky hunter record type BPR-8008"
#define BPR8009 "ERROR: file header record is not a known header type BPR-8009"
#define BPR8010 "ERROR: unexpected format in terminator record BPR-8010"
#define BPR8011 "ERROR: record counts do not match terminator record BPR-8011"
#define BPR8012 "ERROR: invalid number of arguments in first G rec BPR-8012"
#define BPR8200 "ERROR: must enter 2 parameters :- Oracle usn/pwd BPR-8200"
#define BPR0383 "ERROR: usage usn/pwd -[parameters] Arg[1..N] BPR-0383"
#define BPR8300 "ERROR : Invalid date format in header record."
#define BPR8301 "ERROR : Invalid time format in header record."
