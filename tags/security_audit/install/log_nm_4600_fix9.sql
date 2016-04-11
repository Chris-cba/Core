----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4600_fix9.sql-arc   1.0   Apr 11 2016 13:04:58   Upendra.Hukeri  $
--       Module Name      : $Workfile:   log_nm_4600_fix9.sql  $ 
--       Date into PVCS   : $Date:   Apr 11 2016 13:04:58  $
--       Date fetched Out : $Modtime:   Apr 11 2016 11:18:26  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4600_fix9.sql'
				,p_remarks        => 'NET 4600 FIX 9 (Build 1)'
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
