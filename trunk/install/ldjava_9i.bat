@echo off
rem --   SCCS Identifiers :-
rem --
rem --       sccsid           : @(#)ldjava_9i.bat	1.4 01/31/07
rem --       Module Name      : ldjava_9i.bat
rem --       Date into SCCS   : 07/01/31 14:29:45
rem --       Date fetched Out : 07/06/13 13:57:13
rem --       SCCS Version     : 1.4
rem --
rem --
rem --   Author : I Turnbull
rem --
rem -- Used to Load Util.class into Oracle 9i
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
echo Usage: ldjava_9i.bat user/pass@connect
echo.

:end

