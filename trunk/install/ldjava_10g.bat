@echo off
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/nm3/install/ldjava_10g.bat-arc   2.0   Dec 10 2007 09:34:32   jwadsworth  $
--       Module Name      : $Workfile:   ldjava_10g.bat  $
--       Date into PVCS   : $Date:   Dec 10 2007 09:34:32  $
--       Date fetched Out : $Modtime:   Dec 10 2007 09:33:44  $
--       PVCS Version     : $Revision:   2.0  $
--       Based on SCCS version : 
rem --
rem --   Author : I Turnbull
rem --
rem -- Used to Load Util.class into Oracle 10g
rem -- to compile the sqlj use the script doUtil.cmd
rem --
rem -----------------------------------------------------------------------------
rem --	Copyright (c) exor corporation ltd, 2002
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
echo Usage: ldjava_10g.bat user/pass@connect
echo.

:end

