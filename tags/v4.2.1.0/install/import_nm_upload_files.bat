@echo off
rem -------------------------------------------------------------------------
rem  SCCS Identifiers :-
rem 
rem        sccsid           : '"@(#)import_nm_upload_files.bat	1.1 04/16/04"'
rem        Module Name      : '"import_nm_upload_files.bat"'
rem        Date into SCCS   : '"04/04/16 14:14:51"'
rem        Date fetched Out : '"07/06/13 13:57:11"'
rem        SCCS Version     : '"1.1"'
rem 
rem -------------------------------------------------------------------------
rem 	Copyright (c) exor corporation ltd, 2004  
rem -------------------------------------------------------------------------
ECHO .
ECHO *********************************************************
ECHO Enter USERNAME/PASSWORD@ALIAS when prompted for username.
ECHO *********************************************************
ECHO .
ECHO Any "ORA-00001: unique constraint (NM31.NUF_PK) violated"
ECHO  exceptions which arise from this import may be safely ignored
ECHO .
imp parfile=nm_upload_files.par
