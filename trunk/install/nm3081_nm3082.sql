define sccsid = '@(#)nm3081_nm3082.sql	1.1 10/31/03'
undefine exor_base
undefine run_file
undefine terminator
COL exor_base new_value exor_base noprint
COL run_file new_value run_file noprint
COL terminator new_value terminator noprint

SET verify OFF head OFF term ON

-- cl scr removed causes problems on dos sqlplus
prompt
prompt
prompt Please enter the value FOR exor base. This IS the directory UNDER which
prompt the exor software resides (eg c:\exor\ ON a client PC). IF the value
prompt entered IS NOT correct, the process will NOT proceed.
prompt There IS no DEFAULT value FOR this value.
prompt
prompt IMPORTANT: Please ensure that the exor base value IS terminated WITH
prompt the directory seperator FOR your operating SYSTEM
prompt (eg \ IN Windows OR / IN UNIX).
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

prompt
prompt About TO upgrade Network Manager 3 BY exor USING exor base : &exor_base
prompt
ACCEPT ok_res prompt "OK to Continue with this setting ? (Y/N) "

SELECT DECODE(UPPER('&ok_res'),'Y','&exor_base'||'nm3'||'&terminator'||
        'install'||'&terminator'||'nm3081_nm3082_upg','exit') run_file
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
