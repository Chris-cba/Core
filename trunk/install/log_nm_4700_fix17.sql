--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix17.sql-arc   1.0   Apr 27 2015 09:17:04   Upendra.Hukeri  $
--       Module Name      : $Workfile:   log_nm_4700_fix17.sql  $
--       Date into PVCS   : $Date:   Apr 27 2015 09:17:04  $
--       Date fetched Out : $Modtime:   Apr 24 2015 08:10:40  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix17.sql'
              ,p_remarks        => 'NET 4700 FIX 17'
              ,p_to_version     => NULL);
--
  COMMIT;
--
EXCEPTION
  WHEN OTHERS THEN 
	NULL;
END;
/
