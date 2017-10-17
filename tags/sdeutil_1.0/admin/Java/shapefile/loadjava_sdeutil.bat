@ECHO OFF
REM --
REM ---------------------------------------------------------------------------------------------------
REM --
REM --   PVCS Identifiers :-
REM --
REM --       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/Java/shapefile/loadjava_sdeutil.bat-arc   1.0   Oct 17 2017 14:45:56   Upendra.Hukeri  $
REM --       Module Name      : $Workfile:   loadjava_sdeutil.bat  $
REM --       Date into PVCS   : $Date:   Oct 17 2017 14:45:56  $
REM --       Date fetched Out : $Modtime:   Oct 17 2017 14:43:58  $
REM --       PVCS Version     : $Revision:   1.0  $
REM --
REM --   Author : Upendra Hukeri
REM --
REM ---------------------------------------------------------------------------------------------------
REM Copyright (c) 2017 Bentley Systems Incorporated. All rights reserved.
REM ---------------------------------------------------------------------------------------------------
REM --
ECHO OFF
CLS
ECHO.
IF "%1"=="" GOTO BLANK
IF "%2"=="" GOTO BLANK
ECHO ON
loadjava -user %1 -synonym -verbose -grant %2 -force sdeutil.jar
ECHO OFF
:BLANK
ECHO USAGE: loadjava_sdeutil.bat db_user/db_password@tns_name db_role