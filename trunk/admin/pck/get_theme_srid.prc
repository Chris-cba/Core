CREATE OR REPLACE FUNCTION get_theme_srid (p_nth_theme_id IN NUMBER ) 
RETURN NUMBER 
IS
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/get_theme_srid.prc-arc   3.1   Jul 04 2013 14:36:18   James.Wadsworth  $
--       Module Name      : $Workfile:   get_theme_srid.prc  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:36:18  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:35:50  $
--       PVCS Version     : $Revision:   3.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
BEGIN
  RETURN nm3sdo.get_theme_metadata(p_nth_theme_id).srid;
END;
/
