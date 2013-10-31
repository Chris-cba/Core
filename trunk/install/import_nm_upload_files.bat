@echo off
REM
REM   PVCS Identifiers :-
REM
REM      PVCS id          : $Header:   //vm_latest/archives/nm3/install/import_nm_upload_files.bat-arc   2.2   Oct 31 2013 11:28:50   Rob.Coupe  $
REM      Module Name      : $Workfile:   import_nm_upload_files.bat  $
REM      Date into PVCS   : $Date:   Oct 31 2013 11:28:50  $
REM      Date fetched Out : $Modtime:   Oct 31 2013 11:28:10  $
REM      Version          : $Revision:   2.2  $
REM
ECHO .
ECHO *********************************************************
ECHO Enter USERNAME/PASSWORD@ALIAS when prompted for username.
ECHO *********************************************************
ECHO .
ECHO Any "ORA-00001: unique constraint (NM31.NUF_PK) violated"
ECHO  exceptions which arise from this import may be safely ignored
ECHO .
imp parfile=nm_upload_files.par
