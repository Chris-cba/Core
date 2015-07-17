----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix25.sql-arc   1.0   Jul 17 2015 16:18:00   Upendra.Hukeri  $
--       Module Name      : $Workfile:   log_nm_4700_fix25.sql  $ 
--       Date into PVCS   : $Date:   Jul 17 2015 16:18:00  $
--       Date fetched Out : $Modtime:   Jul 17 2015 13:44:00  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4700_fix25.sql'
				,p_remarks        => 'NET 4700 FIX 25'
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
