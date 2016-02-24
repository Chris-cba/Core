----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix38.sql-arc   1.0   Feb 24 2016 09:32:42   Upendra.Hukeri  $
--       Module Name      : $Workfile:   log_nm_4700_fix38.sql  $ 
--       Date into PVCS   : $Date:   Feb 24 2016 09:32:42  $
--       Date fetched Out : $Modtime:   Feb 24 2016 09:22:38  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4700_fix38.sql'
				,p_remarks        => 'NET 4700 FIX 38 (Build 1)'
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
