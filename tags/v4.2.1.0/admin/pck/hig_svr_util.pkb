CREATE OR REPLACE PACKAGE BODY hig_svr_util
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/hig_svr_util.pkb-arc   2.0   Apr 12 2010 10:14:08   aedwards  $
--       Module Name      : $Workfile:   hig_svr_util.pkb  $
--       Date into PVCS   : $Date:   Apr 12 2010 10:14:08  $
--       Date fetched Out : $Modtime:   Apr 09 2010 09:26:56  $
--       Version          : $Revision:   2.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT VARCHAR2(2000) := '$Revision:   2.0  $';
  g_package_name CONSTANT VARCHAR2(30)   := 'hig_svr_util';
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
-----------------------------------------------------------------------------
--
  PROCEDURE unzip_file ( pi_location      IN VARCHAR2
                       , pi_filename      IN VARCHAR2
                       , pi_dest_location IN VARCHAR2 DEFAULT NULL
                       , pi_logfile       IN VARCHAR2 DEFAULT NULL
                       )
  IS
  --
    job_name      VARCHAR2(500)   := dbms_scheduler.generate_job_name;
    shell         VARCHAR2(500)   := 'C:\WINDOWS\system32\cmd.exe';
    unzip_command VARCHAR2(50)    := 'unzip';
    zipfile       VARCHAR2(500)   := pi_location||'\'||pi_filename;
    output_dir    VARCHAR2(500)   := NVL(pi_dest_location,pi_location);
    log_file      VARCHAR2(500)   := pi_location||'\'||NVL(pi_logfile,job_name||'.log');
  --
  BEGIN
  --
    nm3jobs.instantiate_args;
  --
    nm3jobs.add_arg('/C');
    nm3jobs.add_arg(unzip_command);
    nm3jobs.add_arg(zipfile);
    nm3jobs.add_arg('-d');
    nm3jobs.add_arg(output_dir);
  --
    IF pi_logfile IS NOT NULL
    THEN
      nm3jobs.add_arg('>');
      nm3jobs.add_arg(log_file);
    END IF;
  --
    nm3jobs.create_job
      ( pi_job_name        => job_name
      , pi_job_action      => shell
      , pi_job_type        => 'EXECUTABLE'
      , pi_repeat_interval => NULL
      , pi_run_synchro     => TRUE);
  --
  END unzip_file;
--
-----------------------------------------------------------------------------
--
  FUNCTION unzip_file ( pi_location      IN VARCHAR2
                      , pi_filename      IN VARCHAR2
                      , pi_dest_location IN VARCHAR2 DEFAULT NULL
                      , pi_logfile       IN VARCHAR2 DEFAULT NULL
                      )
   RETURN nm3type.tab_varchar32767
  IS
    retval     nm3type.tab_varchar32767;
    l_logfile  nm3type.max_varchar2 := NVL(pi_logfile,REPLACE(pi_filename,'.zip','')||'.log');
  BEGIN
  --
    unzip_file ( pi_location      => pi_location
               , pi_filename      => pi_filename
               , pi_dest_location => pi_dest_location
               , pi_logfile       => l_logfile
               );
  --
    nm3file.get_file
                ( location     => pi_location
                , filename     => l_logfile
                , all_lines    => retval
                , add_cr       => TRUE
                );
  --
    RETURN retval;
  --
  END unzip_file;
--
-----------------------------------------------------------------------------
--
END hig_svr_util;
/
