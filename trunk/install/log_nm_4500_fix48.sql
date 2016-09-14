----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4500_fix48.sql-arc   1.1   Sep 14 2016 08:12:56   Upendra.Hukeri  $
--       Module Name      : $Workfile:   log_nm_4500_fix48.sql  $ 
--       Date into PVCS   : $Date:   Sep 14 2016 08:12:56  $
--       Date fetched Out : $Modtime:   Sep 14 2016 08:11:10  $
--       Version     	  : $Revision:   1.1  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4500_fix48.sql'
				,p_remarks        => 'NET 4500 FIX 48 (Build 2)'
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
