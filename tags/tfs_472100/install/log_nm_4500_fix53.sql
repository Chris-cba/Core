----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4500_fix53.sql-arc   1.0   Dec 14 2017 08:55:12   Upendra.Hukeri  $
--       Module Name      : $Workfile:   log_nm_4500_fix53.sql  $ 
--       Date into PVCS   : $Date:   Dec 14 2017 08:55:12  $
--       Date fetched Out : $Modtime:   Dec 14 2017 08:50:38  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2017 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4500_fix53.sql'
				,p_remarks        => 'NET 4500 FIX 53 (Build 1)'
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
