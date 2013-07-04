--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/log_nm_4054_fix71.sql-arc   3.1   Jul 04 2013 13:46:04   James.Wadsworth  $
--       Module Name      : $Workfile:   log_nm_4054_fix71.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:46:04  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:17:58  $
--       Version          : $Revision:   3.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4054_fix71.sql'
              ,p_remarks        => 'NET 4054 FIX 71'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
