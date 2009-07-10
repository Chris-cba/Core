CREATE OR REPLACE PACKAGE BODY nm3jobs AS
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3jobs.pkb-arc   3.0   Jul 10 2009 11:02:48   aedwards  $
--       Module Name      : $Workfile:   nm3jobs.pkb  $
--       Date into PVCS   : $Date:   Jul 10 2009 11:02:48  $
--       Date fetched Out : $Modtime:   Jul 10 2009 10:58:04  $
--       PVCS Version     : $Revision:   3.0  $
--
--   NM3 DBMS_SCHEDULER wrapper
--
--   Author : Adrian Edwards
--
--
--------------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid          CONSTANT VARCHAR2(2000) :='"$Revision:   3.0  $"';
  g_package_name         CONSTANT VARCHAR2(30)   := 'nm3jobs';
  ex_resource_busy                EXCEPTION;
  g_default_comment               VARCHAR2(500)  := 'Created by nm3job ';
--  ORA-00054: resource busy and acquire with NOWAIT specified
  PRAGMA                          EXCEPTION_INIT(ex_resource_busy,-54);
--
-----------------------------------------------------------------------------
--
  FUNCTION get_version RETURN VARCHAR2 IS
  BEGIN
     RETURN g_sccsid;
  END get_version;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_body_version RETURN VARCHAR2 IS
  BEGIN
     RETURN g_body_sccsid;
  END get_body_version;
--
--------------------------------------------------------------------------------
--
  PROCEDURE create_job
              ( pi_job_name        IN VARCHAR2
              , pi_job_action      IN VARCHAR2
              , pi_repeat_interval IN VARCHAR2  DEFAULT g_midnight
              , pi_comments        IN VARCHAR2  DEFAULT NULL
              , pi_job_type        IN VARCHAR2  DEFAULT 'PLSQL_BLOCK'
              , pi_start_date      IN TIMESTAMP DEFAULT SYSTIMESTAMP
              , pi_end_date        IN TIMESTAMP DEFAULT NULL
              , pi_enabled         IN BOOLEAN   DEFAULT TRUE )
  IS
    --'BEGIN my_job_proc(''CREATE_PROGRAM (BLOCK)''); END;'
  BEGIN
  --
    dbms_scheduler.create_job 
       ( 
         job_name        => pi_job_name
       , job_type        => pi_job_type
       , job_action      => pi_job_action
       , start_date      => pi_start_date
       , repeat_interval => pi_repeat_interval
       , end_date        => pi_end_date
       , enabled         => pi_enabled
       , comments        => NVL(pi_comments,g_default_comment
                                         ||' at '||SYSDATE
                                         ||' for '||USER )
        );
  --
  END create_job;
--
-----------------------------------------------------------------------------
--
-- Run a job immediately
--
  PROCEDURE run_job ( pi_job_name            IN VARCHAR2
                    , pi_use_current_session IN BOOLEAN DEFAULT TRUE )
  IS 
  BEGIN
    dbms_scheduler.run_job
        ( job_name            => pi_job_name
        , use_current_session => pi_use_current_session);
  END run_job;
--
-----------------------------------------------------------------------------
--
-- Run a job immediately
--
  PROCEDURE stop_job ( pi_job_name IN VARCHAR2
                     , pi_force    IN BOOLEAN DEFAULT FALSE)
  IS
  BEGIN
    dbms_scheduler.stop_job
        ( job_name => pi_job_name 
        , force    => pi_force );
  END stop_job;
--
-----------------------------------------------------------------------------
--
-- Drop a job
--
  PROCEDURE drop_job ( pi_job_name IN VARCHAR2
                     , pi_force    IN BOOLEAN DEFAULT FALSE)
  IS
  BEGIN
    dbms_scheduler.drop_job
        ( job_name => pi_job_name
        , force    => pi_force );
  END drop_job;
--
-----------------------------------------------------------------------------
--
END nm3jobs;
/