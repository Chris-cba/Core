CREATE OR REPLACE PACKAGE BODY hig_svr_util
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/hig_svr_util.pkb-arc   2.1   Jul 05 2010 11:53:18   aedwards  $
--       Module Name      : $Workfile:   hig_svr_util.pkb  $
--       Date into PVCS   : $Date:   Jul 05 2010 11:53:18  $
--       Date fetched Out : $Modtime:   Jul 05 2010 11:52:54  $
--       Version          : $Revision:   2.1  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT VARCHAR2(2000) := '$Revision:   2.1  $';
  g_package_name CONSTANT VARCHAR2(30)   := 'hig_svr_util';
  g_dos                   BOOLEAN        := nm3file.dos_or_unix_plaform = 'DOS';
  g_slash                 VARCHAR2(1)    := CASE WHEN g_dos THEN '\' ELSE '/' END;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_version RETURN VARCHAR2 IS
  BEGIN
    nm_debug.proc_start(g_package_name,'get_version');
    nm_debug.proc_end(g_package_name,'get_version');
    RETURN g_sccsid;
  END get_version;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_body_version RETURN VARCHAR2 IS
  BEGIN
    nm_debug.proc_start(g_package_name,'get_body_version');
    nm_debug.proc_end(g_package_name,'get_body_version');
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
    shell         VARCHAR2(500);
    unzip_command VARCHAR2(50);
    zipfile       VARCHAR2(500)   := pi_location||g_slash||pi_filename;
    output_dir    VARCHAR2(500)   := NVL(pi_dest_location,pi_location);
    log_file      VARCHAR2(500)   := pi_location||g_slash||NVL(pi_logfile,job_name||'.log');
  --
  BEGIN
  --
    nm_debug.proc_start(g_package_name,'unzip_file');
  --
    nm3jobs.instantiate_args;
  --
    IF g_dos
    THEN
    --
    ------------------
    -- Windows Server
    ------------------
    --
      shell         := 'C:\WINDOWS\system32\cmd.exe';
      unzip_command := 'unzip';
    --
      nm3jobs.add_arg('/C');
      nm3jobs.add_arg(unzip_command);
      nm3jobs.add_arg(zipfile);
      nm3jobs.add_arg('-d');
      nm3jobs.add_arg(output_dir);
    --
    ELSE
    --
    ----------------------
    -- Unix/Linux Server
    ----------------------
    --
      IF output_dir IS NOT NULL
      THEN
      --
      -----------------------------
      -- Create destination folder
      -----------------------------
      --
        nm3jobs.instantiate_args;
        shell         := '/bin/mkdir';
        nm3jobs.add_arg(output_dir);
      --
        nm3jobs.create_job
          ( pi_job_name        => dbms_scheduler.generate_job_name
          , pi_job_action      => shell
          , pi_job_type        => 'EXECUTABLE'
          , pi_repeat_interval => NULL
          , pi_run_synchro     => TRUE);
      --
      ---------------------------------------
      -- Move zip file to destination folder
      ---------------------------------------
      --
        nm3jobs.instantiate_args;
        shell         := '/bin/mv';
        nm3jobs.add_arg(zipfile);
        nm3jobs.add_arg(pi_dest_location||g_slash||pi_filename);
      --
        nm3jobs.create_job
          ( pi_job_name        => dbms_scheduler.generate_job_name
          , pi_job_action      => shell
          , pi_job_type        => 'EXECUTABLE'
          , pi_repeat_interval => NULL
          , pi_run_synchro     => TRUE);
      --
        zipfile := pi_dest_location||g_slash||pi_filename;
      --
      END IF;
    --
      shell         := '/usr/bin/gunzip';
    --
      nm3jobs.add_arg(zipfile);
    --
    END IF;
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
    nm_debug.proc_end(g_package_name,'unzip_file');
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
    l_logfile  nm3type.max_varchar2 := NVL(pi_logfile,REPLACE(UPPER(pi_filename),'.ZIP','')||'.log');
  BEGIN
  --
    nm_debug.proc_start(g_package_name,'unzip_file');
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
    nm_debug.proc_end(g_package_name,'unzip_file');
  --
    RETURN retval;
  --
  END unzip_file;
--
-----------------------------------------------------------------------------
--
END hig_svr_util;
/
