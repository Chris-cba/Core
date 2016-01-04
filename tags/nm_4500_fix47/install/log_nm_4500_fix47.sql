--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4500_fix47.sql-arc   1.0   Jan 04 2016 09:04:54   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   log_nm_4500_fix47.sql  $
--       Date into PVCS   : $Date:   Jan 04 2016 09:04:54  $
--       Date fetched Out : $Modtime:   Jan 04 2016 08:42:24  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4500_fix47.sql'
              ,p_remarks        => 'NET 4500 FIX 47 (Build 1)'
              ,p_to_version     => NULL);
--
  COMMIT;
--
EXCEPTION
  WHEN OTHERS THEN 
	NULL;
END;
/
