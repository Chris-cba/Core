----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4500_fix50.sql-arc   1.0   Apr 18 2016 12:26:06   Upendra.Hukeri  $
--       Module Name      : $Workfile:   log_nm_4500_fix50.sql  $ 
--       Date into PVCS   : $Date:   Apr 18 2016 12:26:06  $
--       Date fetched Out : $Modtime:   Apr 18 2016 10:42:38  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4500_fix50.sql'
				,p_remarks        => 'NET 4500 FIX 50 (Build 1)'
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
