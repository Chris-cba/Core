--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm3jobs.sql-arc   3.0   Jul 14 2009 09:22:36   aedwards  $
--       Module Name      : $Workfile:   nm3jobs.sql  $
--       Date into PVCS   : $Date:   Jul 14 2009 09:22:36  $
--       Date fetched Out : $Modtime:   Jul 14 2009 09:20:48  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--
BEGIN
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

