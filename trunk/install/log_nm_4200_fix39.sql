--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/log_nm_4200_fix39.sql-arc   3.1   Jul 04 2013 13:46:06   James.Wadsworth  $
--       Module Name      : $Workfile:   log_nm_4200_fix39.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:46:06  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:19:16  $
--       Version          : $Revision:   3.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4200_fix39.sql'
              ,p_remarks        => 'NET 4200 FIX 39'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
