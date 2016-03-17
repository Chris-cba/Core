--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4500_fix49.sql-arc   1.0   Mar 17 2016 08:05:46   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   log_nm_4500_fix49.sql  $
--       Date into PVCS   : $Date:   Mar 17 2016 08:05:46  $
--       Date fetched Out : $Modtime:   Mar 16 2016 11:37:34  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2016 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4500_fix49.sql'
              ,p_remarks        => 'NET 4500 FIX 49 (Build 1)'
              ,p_to_version     => NULL);
--
  COMMIT;
--
EXCEPTION
  WHEN OTHERS THEN 
	NULL;
END;
/
