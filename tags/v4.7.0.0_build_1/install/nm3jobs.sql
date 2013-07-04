--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm3jobs.sql-arc   3.2   Jul 04 2013 14:09:18   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3jobs.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:09:18  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:39:52  $
--       PVCS Version     : $Revision:   3.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
DECLARE
  ex_no_exists       EXCEPTION;
  PRAGMA             EXCEPTION_INIT (ex_no_exists,-27475);
BEGIN
--
  BEGIN
    nm3jobs.drop_job ( pi_job_name => 'CLEAROUT_GDO_DATA'
                     , pi_force    => TRUE );
  EXCEPTION
    WHEN ex_no_exists THEN NULL;
  END;
--
  BEGIN
    nm3jobs.drop_job ( pi_job_name => 'CLEAROUT_NGQI_DATA'
                     , pi_force    => TRUE );
  EXCEPTION
    WHEN ex_no_exists THEN NULL;
  END;
--
  BEGIN
    nm3jobs.drop_job ( pi_job_name => 'CLEAROUT_ND_DATA'
                     , pi_force    => TRUE );
  EXCEPTION
    WHEN ex_no_exists THEN NULL;
  END;
--
  nm3jobs.create_job
              ( pi_job_name   => 'CLEAROUT_GDO_DATA'
              , pi_job_action => 'BEGIN nm3data.cleardown_gdo; END;'
              , pi_comments   => 'Created by nm3jobs at '||SYSDATE );
--
  nm3jobs.create_job
              ( pi_job_name   => 'CLEAROUT_NGQI_DATA'
              , pi_job_action => 'BEGIN nm3data.cleardown_ngqi; END;'
              , pi_comments   => 'Created by nm3jobs at '||SYSDATE );
--
  nm3jobs.create_job
              ( pi_job_name   => 'CLEAROUT_ND_DATA'
              , pi_job_action => 'BEGIN nm3data.cleardown_nd; END;'
              , pi_comments   => 'Created by nm3jobs at '||SYSDATE );
END;
/

