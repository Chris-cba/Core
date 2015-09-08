----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4500_fix45.sql-arc   1.0   Sep 08 2015 10:04:48   Upendra.Hukeri  $
--       Module Name      : $Workfile:   log_nm_4500_fix45.sql  $ 
--       Date into PVCS   : $Date:   Sep 08 2015 10:04:48  $
--       Date fetched Out : $Modtime:   Sep 08 2015 07:56:14  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4500_fix45.sql'
				,p_remarks        => 'NET 4500 FIX 45'
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
