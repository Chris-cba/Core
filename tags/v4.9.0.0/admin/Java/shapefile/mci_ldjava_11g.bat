@echo off
rem --   PVCS Identifiers :-
rem --
rem --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/Java/shapefile/mci_ldjava_11g.bat-arc   1.0   Apr 24 2015 06:20:58   Upendra.Hukeri  $
rem --       Module Name      : $Workfile:   mci_ldjava_11g.bat  $
rem --       Date into PVCS   : $Date:   Apr 24 2015 06:20:58  $
rem --       Date fetched Out : $Modtime:   Apr 21 2015 14:00:14  $
rem --       PVCS Version     : $Revision:   1.0  $
rem --       Based on SCCS version : 
rem --
rem --   Author : Upendra Hukeri
rem --
rem --   Used to load, compile and create public synonym 
rem --   for CMDUtilities.java into Oracle 11g database.
rem --
rem ----------------------------------------------------------------------------------------------------
rem --	 Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
rem ----------------------------------------------------------------------------------------------------
rem --
if (%1) == () goto usage

echo dropping existing CMDUtilities.class (ignore any errors)
call dropjava -user %1 -synonym -verbose CMDUtilities.class

echo.

echo dropping existing CMDUtilities.java (ignore any errors)
call dropjava -user %1 -synonym -verbose CMDUtilities.java

echo.

echo loading CMDUtilities.java (Please report errors to support@bentley.com)
loadjava -user %1 -resolve -synonym -verbose -grant public -force CMDUtilities.java
pause
goto end

:usage
echo.
echo Usage: mci_ldjava_11g.bat user/pass@connect
echo.

:end
