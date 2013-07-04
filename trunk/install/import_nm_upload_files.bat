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
rem 	Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved  
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
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/import_nm_upload_files.bat-arc   2.1   Jul 04 2013 13:45:32   James.Wadsworth  $
--       Module Name      : $Workfile:   import_nm_upload_files.bat  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:45:32  $
--       Date fetched Out : $Modtime:   Jul 04 2013 12:03:30  $
--       Version          : $Revision:   2.1  $
--
--
