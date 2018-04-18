@echo off
REM
REM   PVCS Identifiers :-
REM
REM      PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/import_nm_upload_files.bat-arc   2.4   Apr 18 2018 16:09:14   Gaurav.Gaurkar  $
REM      Module Name      : $Workfile:   import_nm_upload_files.bat  $
REM      Date into PVCS   : $Date:   Apr 18 2018 16:09:14  $
REM      Date fetched Out : $Modtime:   Apr 18 2018 16:02:12  $
REM      Version          : $Revision:   2.4  $
REM
rem -------------------------------------------------------------------------
rem 	Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved  
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
