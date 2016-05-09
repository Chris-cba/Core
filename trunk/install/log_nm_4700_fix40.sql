----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix40.sql-arc   1.0   May 09 2016 07:23:56   Upendra.Hukeri  $
--       Module Name      : $Workfile:   log_nm_4700_fix40.sql  $ 
--       Date into PVCS   : $Date:   May 09 2016 07:23:56  $
--       Date fetched Out : $Modtime:   May 09 2016 07:09:32  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4700_fix40.sql'
				,p_remarks        => 'NET 4700 FIX 40 (Build 1)'
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
