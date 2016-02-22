----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix34.sql-arc   1.1   Feb 22 2016 10:32:42   Upendra.Hukeri  $
--       Module Name      : $Workfile:   log_nm_4700_fix34.sql  $ 
--       Date into PVCS   : $Date:   Feb 22 2016 10:32:42  $
--       Date fetched Out : $Modtime:   Feb 22 2016 10:04:22  $
--       Version     	  : $Revision:   1.1  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4700_fix34.sql'
				,p_remarks        => 'NET 4700 FIX 34 (Build 2)'
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
