----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix30.sql-arc   1.1   Jan 15 2016 07:15:36   Vikas.Mhetre  $
--       Module Name      : $Workfile:   log_nm_4700_fix30.sql  $ 
--       Date into PVCS   : $Date:   Jan 15 2016 07:15:36  $
--       Date fetched Out : $Modtime:   Jan 15 2016 06:24:42  $
--       Version          : $Revision:   1.1  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix30.sql'
              ,p_remarks        => 'NET 4700 FIX 30'
              ,p_to_version     => NULL
              );
--
COMMIT;
--
EXCEPTION 
  WHEN OTHERS THEN
--
  NULL;
--
END;
/