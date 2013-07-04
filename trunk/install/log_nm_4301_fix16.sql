--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/log_nm_4301_fix16.sql-arc   1.1   Jul 04 2013 13:46:12   James.Wadsworth  $
--       Module Name      : $Workfile:   log_nm_4301_fix16.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:46:12  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:22:44  $
--       Version          : $Revision:   1.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4301_fix16.sql'
              ,p_remarks        => 'NET 4301 FIX 16'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
