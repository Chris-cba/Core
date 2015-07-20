----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix27.sql-arc   1.0   Jul 20 2015 13:57:26   Upendra.Hukeri  $
--       Module Name      : $Workfile:   log_nm_4700_fix27.sql  $ 
--       Date into PVCS   : $Date:   Jul 20 2015 13:57:26  $
--       Date fetched Out : $Modtime:   Jul 20 2015 10:03:30  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'WMP'
				,p_upgrade_script => 'log_nm_4700_fix27.sql'
				,p_remarks        => 'WMP 4700 FIX 27'
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
