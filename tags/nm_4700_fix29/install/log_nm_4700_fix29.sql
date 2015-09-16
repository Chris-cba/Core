----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix29.sql-arc   1.0   Sep 16 2015 10:12:12   Upendra.Hukeri  $
--       Module Name      : $Workfile:   log_nm_4700_fix29.sql  $ 
--       Date into PVCS   : $Date:   Sep 16 2015 10:12:12  $
--       Date fetched Out : $Modtime:   Sep 16 2015 05:46:24  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4700_fix29.sql'
				,p_remarks        => 'NET 4700 FIX 29'
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
