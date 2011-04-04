@echo off
rem --   PVCS Identifiers :-
rem --
rem --       pvcsid                 : $Header:   //vm_latest/archives/nm3/install/ldjava_11g.bat-arc   3.0   Apr 04 2011 12:10:56   Mike.Alexander  $
rem --       Module Name      : $Workfile:   ldjava_11g.bat  $
rem --       Date into PVCS   : $Date:   Apr 04 2011 12:10:56  $
rem --       Date fetched Out : $Modtime:   Apr 04 2011 12:08:18  $
rem --       PVCS Version     : $Revision:   3.0  $
rem --       Based on SCCS version : 
rem --
rem --   Author : I Turnbull
rem --
rem -- Used to Load Util.class into Oracle 11g
rem -- to compile the sqlj use the script doUtil.cmd
rem --
rem -----------------------------------------------------------------------------
rem --	Copyright (c) exor corporation ltd, 2011
rem ------------------------------------------------------------------------------

if (%1) == () goto usage

echo dropping existing util.class (ignore any errors)
call dropjava -user %1 util.class


echo dropping existing util.sqlj (ignore any errors)
call dropjava -user %1 util.sqlj


echo loading util.sqlj (please report errors to support@exorcorp.com)
loadjava -user %1 -r -v -f util.sqlj
pause
goto end

:usage
echo.
echo Usage: ldjava_11g.bat user/pass@connect
echo.

:end

