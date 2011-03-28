--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_inst.sql-arc   2.2   Mar 28 2011 12:25:16   Mike.Alexander  $
--       Module Name      : $Workfile:   nm_inst.sql  $
--       Date into PVCS   : $Date:   Mar 28 2011 12:25:16  $
--       Date fetched Out : $Modtime:   Mar 28 2011 12:24:28  $
--       PVCS Version     : $Revision:   2.2  $
--
--------------------------------------------------------------------------------
--
-- Check that the user isn't sys or system
WHENEVER SQLERROR EXIT
BEGIN
   --
      IF USER IN ('SYS','SYSTEM')
       THEN
         RAISE_APPLICATION_ERROR(-20000,'You cannot install Highways by exor as ' || USER);
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
prompt Please enter the value for exor base. This is the directory under which
prompt the exor software resides (eg c:\exor\ on a client PC). If the value
prompt entered is not correct, the process will not proceed.
prompt There is no default value for this value.
prompt
prompt IMPORTANT: Please ensure that the exor base value is terminated with
prompt the directory seperator for your operating system
prompt (eg \ in Windows or / in UNIX).
prompt

accept exor_base prompt "Enter exor base directory now : "

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
prompt About to install Network Manager3 using exor base : &exor_base
prompt
accept ok_res prompt "OK to Continue with this setting ? (Y/N) "

select decode(upper('&ok_res'),'Y','&exor_base'||'nm3'||'&terminator'||
        'install'||'&terminator'||'nm3_install','exit') run_file
from dual
/

start '&run_file'

prompt
prompt The Highways install scripts could not be found in the directory
prompt specified for exor base (&exor_base).
prompt
prompt Please re-run the installation script and enter the correct directory name.
prompt
accept leave_it prompt "Press RETURN to exit from SQL*PLUS"
exit;
