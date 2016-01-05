----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4500_fix48.sql-arc   1.0   Jan 05 2016 06:35:58   Upendra.Hukeri  $
--       Module Name      : $Workfile:   log_nm_4500_fix48.sql  $ 
--       Date into PVCS   : $Date:   Jan 05 2016 06:35:58  $
--       Date fetched Out : $Modtime:   Jan 05 2016 05:23:38  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4500_fix48.sql'
				,p_remarks        => 'NET 4500 FIX 48 (Build 1)'
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
