----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix34.sql-arc   1.2   Sep 16 2016 07:35:20   Upendra.Hukeri  $
--       Module Name      : $Workfile:   log_nm_4700_fix34.sql  $ 
--       Date into PVCS   : $Date:   Sep 16 2016 07:35:20  $
--       Date fetched Out : $Modtime:   Sep 16 2016 07:02:44  $
--       Version     	  : $Revision:   1.2  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4700_fix34.sql'
				,p_remarks        => 'NET 4700 FIX 34 (Build 3)'
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
