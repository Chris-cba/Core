CREATE OR REPLACE PACKAGE BODY hig_svr_util
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/hig_svr_util.pkb-arc   2.6   Jul 04 2013 14:57:08   James.Wadsworth  $
--       Module Name      : $Workfile:   hig_svr_util.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:57:08  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:55:24  $
--       Version          : $Revision:   2.6  $
--       Based on SCCS version : 
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT VARCHAR2(2000) := '$Revision:   2.6  $';
  g_package_name CONSTANT VARCHAR2(30)   := 'hig_svr_util';
  g_dos                   BOOLEAN;
  g_slash                 VARCHAR2(1);
  g_command_to_unzip      VARCHAR2(2000);
  g_command_to_gunzip     VARCHAR2(2000);  
  g_command_to_tar        VARCHAR2(2000);
  g_command_shell         VARCHAR2(2000);
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
PROCEDURE ensure_trailing_slash(pi_string IN OUT VARCHAR2) IS

BEGIN

    IF SUBSTR(pi_string,-1) NOT IN ('\','/') THEN
        pi_string := pi_string||g_slash;
    END IF;

END ensure_trailing_slash;   
--
-----------------------------------------------------------------------------
--
PROCEDURE windows_unzip( pi_filename      IN VARCHAR2
                       , pi_dest_location IN VARCHAR2 
                       , pi_logfile       IN VARCHAR2 
                       ) IS
                       
 l_tab NM3TYPE.TAB_VARCHAR32767;                       
                       
BEGIN

      nm_debug.proc_start(g_package_name,'windows_unzip');

     IF g_command_to_unzip = Null THEN
      hig.raise_ner(pi_appl               => 'HIG'
                   ,pi_id                 => 163
                   ,pi_supplementary_info => 'Set a value for ''UNZIPCMD'' then re-start the application'); 
     END IF;
   
   
     IF g_command_shell = Null THEN
      hig.raise_ner(pi_appl               => 'HIG'
                   ,pi_id                 => 163
                   ,pi_supplementary_info => 'Set a value for ''CMDSHELL'' then re-start the application');   
     END IF;

      nm3jobs.instantiate_args;
      nm3jobs.add_arg('/C');
      nm3jobs.add_arg(g_command_to_unzip);
      nm3jobs.add_arg(pi_filename);
      nm3jobs.add_arg('-d');
      nm3jobs.add_arg(pi_dest_location);
 
      IF pi_logfile IS NOT NULL THEN
         nm3jobs.add_arg('>');
         nm3jobs.add_arg(pi_logfile);
      END IF;   

      nm3jobs.create_job
              ( pi_job_name        => dbms_scheduler.generate_job_name
              , pi_job_action      => g_command_shell
              , pi_job_type        => 'EXECUTABLE'
              , pi_repeat_interval => NULL
              , pi_run_synchro     => TRUE);

    nm_debug.proc_end(g_package_name,'windows_unzip');

END windows_unzip;                       
--
-----------------------------------------------------------------------------
--
PROCEDURE unix_gunzip( pi_filename      IN VARCHAR2
                     , pi_dest_location IN VARCHAR2 
                     , pi_logfile       IN VARCHAR2 
                     ) IS

BEGIN

      nm_debug.proc_start(g_package_name,'unix_gunzip');
 
--   nm_debug.debug_on;
--   nm_debug.debug('pi_filename='||pi_filename);
--   nm_debug.debug('pi_dest_location='||pi_dest_location);
--   nm_debug.debug('pi_logfile='||pi_logfile);   
     
     IF g_command_to_gunzip = Null THEN
      hig.raise_ner(pi_appl               => 'HIG'
                   ,pi_id                 => 163
                   ,pi_supplementary_info => 'Set a value for ''GUNZIPCMD'' then re-start the application'); 
     END IF;
   
     IF g_command_to_tar = Null THEN
      hig.raise_ner(pi_appl               => 'HIG'
                   ,pi_id                 => 163
                   ,pi_supplementary_info => 'Set a value for ''TARCMD'' then re-start the application'); 
     END IF;

      -----------------------------
      -- Create destination folder
      -----------------------------
      nm3jobs.instantiate_args;
      nm3jobs.add_arg(pi_dest_location);

      BEGIN
        nm3jobs.create_job
          ( pi_job_name        => dbms_scheduler.generate_job_name
          , pi_job_action      => '/bin/mkdir'
          , pi_job_type        => 'EXECUTABLE'
          , pi_repeat_interval => NULL
          , pi_run_synchro     => TRUE);
      EXCEPTION
      -- Dir already exists
        WHEN OTHERS THEN NULL;
      END;

      -----------------
      -- GUnzip GZ file
      -----------------
      nm3jobs.instantiate_args;
      nm3jobs.add_arg(pi_filename);
    
      nm3jobs.create_job( pi_job_name        => dbms_scheduler.generate_job_name
                        , pi_job_action      => g_command_to_gunzip
                        , pi_job_type        => 'EXECUTABLE'
                        , pi_repeat_interval => NULL
                        , pi_run_synchro     => TRUE);

      ---------
      -- Un-Tar
      ---------
      nm3jobs.instantiate_args;
      nm3jobs.add_arg('-xvf');
      nm3jobs.add_arg(substr(pi_filename,1,(length(pi_filename)-3)));
      nm3jobs.add_arg('-C');
      nm3jobs.add_arg(pi_dest_location);
          
      nm3jobs.create_job( pi_job_name        => dbms_scheduler.generate_job_name
                        , pi_job_action      => g_command_to_tar
                        , pi_job_type        => 'EXECUTABLE'
                        , pi_repeat_interval => NULL
                        , pi_run_synchro     => TRUE);

    nm_debug.proc_end(g_package_name,'unix_gunzip');

END unix_gunzip;
--
-----------------------------------------------------------------------------
--
PROCEDURE unix_unzip( pi_filename      IN VARCHAR2
                    , pi_dest_location IN VARCHAR2 
                    , pi_logfile       IN VARCHAR2 
                    ) IS

BEGIN

      nm_debug.proc_start(g_package_name,'unix_unzip');
--   nm_debug.debug_on;
--   nm_debug.debug('pi_filename='||pi_filename);
--   nm_debug.debug('pi_dest_location='||pi_dest_location);
--   nm_debug.debug('pi_logfile='||pi_logfile);

     IF g_command_to_unzip = Null THEN
      hig.raise_ner(pi_appl               => 'HIG'
                   ,pi_id                 => 163
                   ,pi_supplementary_info => 'Set a value for ''UNZIPCMD'' then re-start the application');
     END IF;

   
      -----------------------------
      -- Create destination folder
      -----------------------------
      nm3jobs.instantiate_args;
      nm3jobs.add_arg(pi_dest_location);

      BEGIN
        nm3jobs.create_job
          ( pi_job_name        => dbms_scheduler.generate_job_name
          , pi_job_action      => '/bin/mkdir'
          , pi_job_type        => 'EXECUTABLE'
          , pi_repeat_interval => NULL
          , pi_run_synchro     => TRUE);
      EXCEPTION
      -- Dir already exists
        WHEN OTHERS THEN NULL;
      END;

    
      -----------------
      -- Unzip ZIP file
      -----------------
      nm3jobs.instantiate_args;
      nm3jobs.add_arg(pi_filename);
      nm3jobs.add_arg('-d');
      nm3jobs.add_arg(pi_dest_location);

--      IF pi_logfile IS NOT NULL THEN
--         nm3jobs.add_arg('>');
--         nm3jobs.add_arg(pi_logfile);
--      END IF;  

      
      nm3jobs.create_job( pi_job_name        => dbms_scheduler.generate_job_name
                        , pi_job_action      => g_command_to_unzip
                        , pi_job_type        => 'EXECUTABLE'
                        , pi_repeat_interval => NULL
                        , pi_run_synchro     => TRUE);

    nm_debug.proc_end(g_package_name,'unix_unzip');


END unix_unzip;
--
-----------------------------------------------------------------------------
--
PROCEDURE unzip_file ( pi_location      IN VARCHAR2
                     , pi_filename      IN VARCHAR2
                     , pi_dest_location IN VARCHAR2 DEFAULT NULL
                     , pi_logfile       IN VARCHAR2 DEFAULT NULL
                       
                       )
IS

    l_location       VARCHAR2(500)  := pi_location;
    l_dest_location  VARCHAR2(500)  := pi_dest_location;
    l_zipfile        VARCHAR2(500);
    l_filetype       VARCHAR2(50)   := UPPER(substr(pi_filename,instr(pi_filename,'.',-1)+1,length(pi_filename)));
    l_log_file       VARCHAR2(500);

BEGIN

    ensure_trailing_slash(pi_string => l_location);

    /* Ensure dest location ends with trailing slash */
    IF l_dest_location IS NULL THEN
       l_dest_location := l_location;
    ELSE
       ensure_trailing_slash(pi_string => l_dest_location);
    END IF;

    l_zipfile       := l_location||pi_filename;

    IF pi_logfile IS NOT NULL THEN
      l_log_file := l_location||pi_logfile;
    END IF; 

    nm_debug.proc_start(g_package_name,'unzip_file');
    


    IF g_dos THEN
        
          windows_unzip( pi_filename      => l_zipfile
                       , pi_dest_location => l_dest_location
                       , pi_logfile       => l_log_file 
                       );   

    ELSE

        IF l_filetype = 'GZ' THEN
        
          unix_gunzip( pi_filename      => l_zipfile
                     , pi_dest_location => l_dest_location 
                     , pi_logfile       => l_log_file 
                     );   

        ELSE -- assume it's a ZIP

          unix_unzip( pi_filename      => l_zipfile
                    , pi_dest_location => l_dest_location 
                    , pi_logfile       => l_log_file 
                    );   

        END IF;
        
    END IF;  

    nm_debug.proc_end(g_package_name,'unzip_file');

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
    l_logfile  nm3type.max_varchar2 := NVL(pi_logfile,SUBSTR(pi_filename,1,instr(pi_filename,'.',-1))||'log');
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
    BEGIN
      nm3file.get_file
                ( location     => pi_location
                , filename     => l_logfile
                , all_lines    => retval
                , add_cr       => TRUE
                );
    EXCEPTION
      WHEN OTHERS THEN NULL;
    END;
  --
    nm_debug.proc_end(g_package_name,'unzip_file');
  --
    RETURN retval;
  --
  END unzip_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE del_server_dir(pi_directory IN varchar2)
AS 
l_command varchar2(1000):= 'RMDIR ' ||pi_directory;
shell varchar2(100);
BEGIN
  IF hig_directories_api.hdir_exists(pi_directory) THEN
    IF g_dos THEN
      nm3jobs.instantiate_args;
      nm3jobs.add_arg('/C');
      nm3jobs.add_arg(l_command);
      --
      nm3jobs.create_job( pi_job_name        => dbms_scheduler.generate_job_name 
                        , pi_job_action      => 'C:\WINDOWS\system32\cmd.exe'
                        , pi_job_type        => 'EXECUTABLE'
                        , pi_repeat_interval => NULL
                        , pi_run_synchro     => TRUE);
    ELSE
      nm3jobs.instantiate_args;
      shell         := '/bin/rmdir';
    --  nm3jobs.add_arg('-rf');
      nm3jobs.add_arg(pi_directory);
    --
      nm3jobs.create_job
        ( pi_job_name        => dbms_scheduler.generate_job_name
        , pi_job_action      => shell
        , pi_job_type        => 'EXECUTABLE'
        , pi_repeat_interval => NULL
        , pi_run_synchro     => TRUE);
    END IF;
  ELSE
    HIG.RAISE_NER( pi_appl => 'HIG' 
                 , pi_id => 536
                 , pi_supplementary_info => 'You must add this folder to the DIRECTORIES form to carry out this action.');
  END IF;
END;

PROCEDURE del_server_files( pi_directory IN varchar2
                          , pi_wildcard  IN varchar2
                          )
AS 
  l_command varchar2(1000):= 'DEL ' || pi_directory|| pi_wildcard;
  shell varchar2(100);
BEGIN
--
  IF hig_directories_api.hdir_exists(pi_directory) THEN
  --
    IF g_dos THEN
    --
      nm3jobs.instantiate_args;
      nm3jobs.add_arg('/C');
      nm3jobs.add_arg(l_command);
      nm3jobs.add_arg('EXIT');
      --
      nm3jobs.create_job
          ( pi_job_name        => dbms_scheduler.generate_job_name 
          , pi_job_action      => 'C:\WINDOWS\system32\cmd.exe'
          , pi_job_type        => 'EXECUTABLE'
          , pi_repeat_interval => NULL
          , pi_run_synchro     => TRUE);
    ELSE
          nm3jobs.instantiate_args;
          shell         := '/bin/rm';
          nm3jobs.add_arg('-f');
          IF substr(pi_directory, length(pi_directory), 1) = '/' THEN
            nm3jobs.add_arg(pi_directory || pi_wildcard);
          ELSE
            nm3jobs.add_arg(pi_directory|| '/' ||pi_wildcard);
          END IF;
          --
     
          nm3jobs.create_job
            ( pi_job_name        => dbms_scheduler.generate_job_name
            , pi_job_action      => shell
            , pi_job_type        => 'EXECUTABLE'
            , pi_repeat_interval => NULL
            , pi_run_synchro     => TRUE);
    END IF;
  --
  ELSE
    HIG.RAISE_NER( pi_appl => 'HIG' 
                 , pi_id => 536
                 , pi_supplementary_info => 'You must add this folder to the DIRECTORIES form to carry out this action.');
  END IF;
--
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_globals IS

BEGIN

   g_dos := nm3file.dos_or_unix_plaform = 'DOS';
   
   IF g_dos THEN 
         g_slash  := '\'; 
   ELSE  
         g_slash := '/';
   END IF;

   g_command_to_unzip  := hig.get_user_or_sys_opt('UNZIPCMD');
   g_command_to_gunzip := hig.get_user_or_sys_opt('GUNZIPCMD');
   g_command_to_tar    := hig.get_user_or_sys_opt('TARCMD');
   g_command_shell     := hig.get_user_or_sys_opt('CMDSHELL');

END set_globals;
--
-----------------------------------------------------------------------------
--
BEGIN
 
 set_globals;

END hig_svr_util;
/
