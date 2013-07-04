--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/log_nm_4400_fix31.sql-arc   1.1   Jul 04 2013 13:46:18   James.Wadsworth  $
--       Module Name      : $Workfile:   log_nm_4400_fix31.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:46:18  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:24:46  $
--       Version          : $Revision:   1.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4400_fix31.sql'
              ,p_remarks        => 'NET 4400 FIX 31'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
