--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/nm3/install/hag_fk2_hau_ind_fix.sql-arc   2.0   Dec 11 2007 13:21:52   jwadsworth  $
--       Module Name      : $Workfile:   hag_fk2_hau_ind_fix.sql  $
--       Date into PVCS   : $Date:   Dec 11 2007 13:21:52  $
--       Date fetched Out : $Modtime:   Dec 11 2007 13:19:04  $
--       PVCS Version     : $Revision:   2.0  $
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



