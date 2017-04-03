----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix57.sql-arc   1.0   Apr 03 2017 10:18:38   Upendra.Hukeri  $   
--       Module Name      : $Workfile:   log_nm_4700_fix57.sql  $ 
--       Date into PVCS   : $Date:   Apr 03 2017 10:18:38  $
--       Date fetched Out : $Modtime:   Apr 03 2017 10:14:34  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2017 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--


BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4700_fix57.sql'
				,p_remarks        => 'NET 4700 FIX 57 (Build 1)'
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