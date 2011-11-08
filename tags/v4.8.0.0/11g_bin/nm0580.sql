-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm0580.sql	1.3 11/25/03
--       Module Name      : nm0580.sql
--       Date into SCCS   : 03/11/25 17:21:06
--       Date fetched Out : 07/06/13 17:02:06
--       SCCS Version     : 1.3
--
--
--   Author : Darren Cope
--
--   MapCapture Edif file generation
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2003
-----------------------------------------------------------------------------

col spool new_value spool noprint;

select higgrirp.get_module_spoolpath(&&1,Sys_Context('NM3_SECURITY_CTX','USERNAME'))||hig.get_sysopt('DIRSEPSTRN')||higgrirp.get_module_spoolfile(&&1) spool 
from dual;


set serverout on
set verify off
set feedback off

spool &spool

exec higgrirp.write_gri_spool(&1,'Highways by Exor');
prompt Highways by Exor
exec higgrirp.write_gri_spool(&1,'================');
prompt ================
exec higgrirp.write_gri_spool(&1,'');
prompt
exec higgrirp.write_gri_spool(&1,'NM0580: Create MapCapture Metadata File');
prompt NM0580: Create MapCapture Metadata File
exec higgrirp.write_gri_spool(&1,'');
prompt 
exec higgrirp.write_gri_spool(&1,'Run on '||to_char(sysdate,'DD MON YYYY HH24:MI'));
exec dbms_output.put_line('Run on '||to_char(sysdate,'DD MON YYYY HH24:MI'));
exec higgrirp.write_gri_spool(&1,'');
prompt 
exec higgrirp.write_gri_spool(&1,'Working ....');
prompt Working ....
exec higgrirp.write_gri_spool(&1,'');
prompt 

declare
begin
  nm3Pedif.main;
  
  update gri_report_runs 
  set grr_end_date = sysdate,
  grr_error_no = 0,
  grr_error_descr = 'Normal Successful Completion'
  where grr_job_id = &&1; 

  commit;
end;

/

prompt
prompt MapCapture Metadata file created, look on database server for surveyp.ped
exec higgrirp.write_gri_spool(&1,'MapCapture Metadata file created, look on database server for surveyp.ped');

spool off

exit;

