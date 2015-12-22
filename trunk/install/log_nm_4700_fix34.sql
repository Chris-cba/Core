----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix34.sql-arc   1.0   Dec 22 2015 08:54:00   Upendra.Hukeri  $
--       Module Name      : $Workfile:   log_nm_4700_fix34.sql  $ 
--       Date into PVCS   : $Date:   Dec 22 2015 08:54:00  $
--       Date fetched Out : $Modtime:   Dec 21 2015 10:04:08  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4700_fix34.sql'
				,p_remarks        => 'NET 4700 FIX 34 (Build 1)'
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
