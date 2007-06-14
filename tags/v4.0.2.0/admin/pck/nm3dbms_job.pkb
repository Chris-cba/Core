CREATE OR REPLACE PACKAGE BODY nm3dbms_job AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3dbms_job.pkb	1.2 08/30/02
--       Module Name      : nm3dbms_job.pkb
--       Date into SCCS   : 02/08/30 10:50:42
--       Date fetched Out : 07/06/13 14:11:14
--       SCCS Version     : 1.2
--
--
--   Author : K Angus
--
--   Procs/functions for manipulating DBMS jobs.
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)nm3dbms_job.pkb	1.2 08/30/02"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3dbms_job';
--
   c_job_processes_param CONSTANT v$parameter.name%TYPE := 'job_queue_processes';
   c_job_interval_param  CONSTANT v$parameter.name%TYPE := 'job_queue_interval';
--
   c_app_owner           CONSTANT VARCHAR2(30)          := hig.get_application_owner;
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
FUNCTION processes_available RETURN boolean IS

  CURSOR cs_param(p_name v$parameter.name%TYPE
                 )  IS
    SELECT
      value
    FROM
      v$parameter
    WHERE
      name = p_name;

  l_num_processes pls_integer;

  l_retval boolean;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'processes_available');

  OPEN cs_param(p_name => c_job_processes_param);
    FETCH cs_param INTO l_num_processes;
    IF cs_param%NOTFOUND
    THEN
      CLOSE cs_param;
      --record not found
      hig.raise_ner(pi_appl               => nm3type.c_hig
                   ,pi_id                 => 67
                   ,pi_sqlcode            => -20035
                   ,pi_supplementary_info => 'V$PARAMETER.name = '|| c_job_processes_param);
    END IF;
  CLOSE cs_param;

  l_retval := l_num_processes > 0;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'processes_available');

  RETURN l_retval;

END processes_available;
--
-----------------------------------------------------------------------------
--
PROCEDURE make_sure_processes_available IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'make_sure_processes_available');
--
   IF NOT nm3dbms_job.processes_available
    THEN
      hig.raise_ner (pi_appl => nm3type.c_hig
                    ,pi_id   => 136
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'make_sure_processes_available');
--
END make_sure_processes_available;
--
-----------------------------------------------------------------------------
--
FUNCTION does_job_exist_by_what (pi_what all_jobs.what%TYPE) RETURN BOOLEAN IS
--
   CURSOR cs_job (c_schema_user all_jobs.schema_user%TYPE
                 ,c_what        all_jobs.what%TYPE
                 ) IS
   SELECT *
    FROM  all_jobs
   WHERE  schema_user = c_schema_user
    AND   UPPER(what) = c_what;
--
   l_rec_aj all_jobs%ROWTYPE;
   l_retval BOOLEAN;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'does_job_exist_by_what');
--
   OPEN  cs_job (c_app_owner, UPPER(pi_what));
   FETCH cs_job INTO l_rec_aj;
   l_retval := cs_job%FOUND;
   CLOSE cs_job;
--
   nm_debug.proc_end(g_package_name,'does_job_exist_by_what');
--
   RETURN l_retval;
--
END does_job_exist_by_what;
--
-----------------------------------------------------------------------------
--
END nm3dbms_job;
/
