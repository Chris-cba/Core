-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3110_nm3120.sql	1.1 07/14/04
--       Module Name      : nm3110_nm3120.sql
--       Date into SCCS   : 04/07/14 15:10:35
--       Date fetched Out : 07/06/13 13:57:45
--       SCCS Version     : 1.1
--
--   Product installation script
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------

undefine exor_base
undefine run_file
undefine terminator
COL exor_base new_value exor_base noprint
COL run_file new_value run_file noprint
COL terminator new_value terminator noprint

SET verify OFF head OFF feedback off term ON

-- cl scr removed causes problems on dos sqlplus
prompt
prompt
prompt Please enter the value for exor base. This is the directory under which
prompt the exor software resides (eg c:\exor\ on a client PC). IF the value
prompt entered is not correct, the process will not proceed.
prompt There is no default value for this value.
prompt
prompt IMPORTANT: Please ensure that the exor base value is terminated with
prompt the directory seperator for your operating system
prompt (eg \ in windows or / in unix).
prompt
prompt
prompt It is VITALLY IMPORTANT that you allow this upgrade to finish on it's own
PROMPT  NEVER "kill" the session because it seems to be taking a long time to run
PROMPT
prompt

ACCEPT exor_base prompt "Enter exor base directory now : "

SELECT SUBSTR('&exor_base',(LENGTH('&exor_base'))) terminator
FROM dual
/
SELECT DECODE('&terminator',
              '/',NULL,
              '\',NULL,
              'inv_term') run_file
FROM dual
/

SET term OFF
START '&run_file'
SET term ON

REM
REM Ensure that exor_base is not greater than 30 characters in length
REM
SELECT DECODE(
              SIGN(30-LENGTH('&exor_base'))
                                          ,1,null
                                          ,'exor_base_too_long.sql') run_file
FROM dual
/

SET term OFF
START '&run_file'
SET term ON

prompt
prompt About TO upgrade Network Manager 3 BY exor USING exor base : &exor_base
prompt
ACCEPT ok_res prompt "OK to Continue with this setting ? (Y/N) "

SELECT DECODE(UPPER('&ok_res'),'Y','&exor_base'||'nm3'||'&terminator'||
        'install'||'&terminator'||'nm3110_nm3120_upg','exit') run_file
FROM dual
/

START '&run_file'

prompt
prompt The Highways upgrade scripts could NOT be FOUND IN the directory
prompt specified FOR exor base (&exor_base).
prompt
prompt Please re-RUN the upgrade script AND enter the correct directory name.
prompt
ACCEPT leave_it prompt "Press RETURN to exit from SQL*PLUS"
EXIT;
