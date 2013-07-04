--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/nm3/install/hag_fk2_hau_ind_fix.sql-arc   2.1   Jul 04 2013 13:45:30   James.Wadsworth  $
--       Module Name      : $Workfile:   hag_fk2_hau_ind_fix.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:45:30  $
--       Date fetched Out : $Modtime:   Jul 04 2013 12:00:40  $
--       PVCS Version     : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
DECLARE
 do_nothing EXCEPTION;
 pragma exception_init(do_nothing,-955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX hag_fk2_hau_ind ON NM_ADMIN_GROUPS(nag_child_admin_unit)';
EXCEPTION
  WHEN do_nothing THEN
   Null;
END;
/



