CREATE OR REPLACE FUNCTION get_theme_srid (p_nth_theme_id IN NUMBER ) 
RETURN NUMBER 
IS
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/get_theme_srid.prc-arc   3.0   Sep 23 2009 16:05:56   aedwards  $
--       Module Name      : $Workfile:   get_theme_srid.prc  $
--       Date into PVCS   : $Date:   Sep 23 2009 16:05:56  $
--       Date fetched Out : $Modtime:   Sep 23 2009 16:04:34  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--
BEGIN
  RETURN nm3sdo.get_theme_metadata(p_nth_theme_id).srid;
END;
/
