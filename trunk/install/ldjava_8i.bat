@echo off
rem --   SCCS Identifiers :-
rem --
rem --       sccsid           : @(#)ldjava_8i.bat	1.2 11/04/03
rem --       Module Name      : ldjava_8i.bat
rem --       Date into SCCS   : 03/11/04 10:02:07
rem --       Date fetched Out : 07/06/13 13:57:13
rem --       SCCS Version     : 1.2
rem --
rem --
rem --   Author : I Turnbull
rem --
rem -- Used to Load Util.jar into Oracle 8i
rem --
rem -----------------------------------------------------------------------------
rem --	Copyright (c) exor corporation ltd, 2003
rem ------------------------------------------------------------------------------

if (%1) == () goto usage

dropjava -user %1 Util
loadjava -user %1 -r -v -f Util.jar

goto end

:usage
echo.
echo Usage: ldjava_8i.bat user/pass@connect 
echo.

:end

