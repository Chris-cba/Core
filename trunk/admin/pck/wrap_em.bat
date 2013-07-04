REM Wrap pkb files to pkw files
REM "'@(#)wrap_em.bat	1.2 02/16/06'"
for %%i in (*.pkb) do wrap iname=%%i oname=%%~ni.pkw edebug=wrap_new_sql
rem Wrap all functions *.fnc to *.fnw
for %%i in (*.fnc) do wrap iname=%%i oname=%%~ni.fnw edebug=wrap_new_sql
rem Wrap all functions *.prc to *.prw
for %%i in (*.prc) do wrap iname=%%i oname=%%~ni.prw edebug=wrap_new_sql
rem Wrap all types typ to tyw
for %%i in (*.tyb) do wrap iname=%%i oname=%%~ni.tyw edebug=wrap_new_sql
