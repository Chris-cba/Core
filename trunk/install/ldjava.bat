@echo off
rem --   SCCS Identifiers :-
rem --
rem --       sccsid           : @(#)ldjava.bat	1.2 05/21/02
rem --       Module Name      : ldjava.bat
rem --       Date into SCCS   : 02/05/21 09:37:58
rem --       Date fetched Out : 07/06/13 13:57:12
rem --       SCCS Version     : 1.2
rem --
rem --
rem --   Author : I Turnbull
rem --
rem --
rem -----------------------------------------------------------------------------
rem --	Copyright (c) exor corporation ltd, 2002
rem ------------------------------------------------------------------------------

if (%1) == () goto usage

loadjava -user %1 -r -v -f Util.class

goto end

:usage
echo.
echo Usage: ldjava.bat user/pass@connect 
echo.

:end

