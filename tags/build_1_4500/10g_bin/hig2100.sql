REM
rem   SCCS Identifiers :-
rem
rem       sccsid           : @(#)hig2100.sql	1.1 06/26/03
rem       Module Name      : hig2100.sql
rem       Date into SCCS   : 03/06/26 10:51:12
rem       Date fetched Out : 07/06/13 17:02:05
rem       SCCS Version     : 1.1
rem
rem  Date   : June 2003
rem  Author : G Johnson
rem  Descr  : SQL Script called from GRI that invokes hig_health.main
rem           That in turn produces an output file used as the basis of a database health check
rem
set serveroutput on
set ver off
set feed off

prompt

exec higgrirp.write_gri_spool(&1,'Highways by Exor');
exec higgrirp.write_gri_spool(&1,'================');
exec higgrirp.write_gri_spool(&1,'');
exec higgrirp.write_gri_spool(&1,'HIG2100: Produce Database Healthcheck File');
exec higgrirp.write_gri_spool(&1,'');

prompt Highways by Exor
prompt ================
prompt HIG2100: Produce Database Health Check File
prompt
prompt Working...

begin
  dbms_output.enable(1000000);
  hig_health.main(&1);
end;
/


set define on
set term off
set head off

exit;

