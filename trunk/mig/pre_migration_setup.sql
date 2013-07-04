define sccsid = '@(#)pre_migration_setup.sql	1.12 11/09/04'

-- Check that the user isn't sys or system
WHENEVER SQLERROR EXIT
BEGIN
   --
      IF USER IN ('SYS','SYSTEM')
       THEN
         RAISE_APPLICATION_ERROR(-20000,'You cannot install the pre migration checks as ' || USER);
      END IF;
END;      
/
WHENEVER SQLERROR CONTINUE

undefine exor_base
undefine run_file
undefine terminator
col exor_base new_value exor_base noprint
col run_file new_value run_file noprint
col terminator new_value terminator noprint

set verify off head off term on

prompt
prompt
prompt Please enter the directory you have copied the pre-migration files to.
prompt There is no default value for this value.
prompt
prompt INPORTANT: Please ensure that the value entered is terminated with
prompt the directory seperator for your operating system
prompt (eg \ in Windows or / in UNIX).
prompt

accept exor_base prompt "Enter directory : "

select substr('&exor_base',(length('&exor_base'))) terminator
from dual
/
select decode('&terminator',
              '/',null,
              '\',null,
              'inv_term') run_file
from dual
/

set term off
start '&run_file'
set term on

prompt
prompt About to install the pre migration checks from directory : &exor_base
prompt
accept ok_res prompt "OK to Continue with this setting ? (Y/N) "

select decode(upper('&ok_res'),'Y','&exor_base'||'pre_mig_inst','exit') run_file
from dual
/

start '&run_file'

prompt
prompt The pre migration check files could not be found in the directory
prompt specified (&exor_base).
prompt
prompt Please re-run the installation script and enter the correct directory name.
prompt
accept leave_it prompt "Press RETURN to exit from SQL*PLUS"
exit;

