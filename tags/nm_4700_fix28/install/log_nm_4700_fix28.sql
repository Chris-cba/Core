--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix28.sql-arc   1.0   Aug 25 2015 12:40:10   Upendra.Hukeri  $
--       Module Name      : $Workfile:   log_nm_4700_fix28.sql  $
--       Date into PVCS   : $Date:   Aug 25 2015 12:40:10  $
--       Date fetched Out : $Modtime:   Aug 25 2015 11:16:26  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix28.sql'
              ,p_remarks        => 'NET 4700 FIX 28'
              ,p_to_version     => NULL);
--
  COMMIT;
--
EXCEPTION
  WHEN OTHERS THEN 
	NULL;
END;
/
