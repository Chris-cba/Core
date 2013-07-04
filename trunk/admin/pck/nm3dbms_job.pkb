CREATE OR REPLACE PACKAGE BODY nm3dbms_job AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3dbms_job.pkb-arc   2.3   Jul 04 2013 15:23:06   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3dbms_job.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:23:06  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:10  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version : 1.2
--
--   Author : K Angus
--
--   Procs/functions for manipulating DBMS jobs.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.3  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3dbms_job';
--
   c_job_processes_param CONSTANT v$parameter.name%TYPE := 'job_queue_processes';
   c_job_interval_param  CONSTANT v$parameter.name%TYPE := 'job_queue_interval';
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
   CURSOR cs_job (c_what        all_jobs.what%TYPE
                 ) IS
   SELECT *
    FROM  all_jobs
   WHERE  schema_user = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   UPPER(what) = c_what;
--
   l_rec_aj all_jobs%ROWTYPE;
   l_retval BOOLEAN;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'does_job_exist_by_what');
--
   OPEN  cs_job (UPPER(pi_what));
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
