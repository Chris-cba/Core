CREATE OR REPLACE FUNCTION get_theme_srid (p_nth_theme_id IN NUMBER ) 
RETURN NUMBER 
IS
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/get_theme_srid.prc-arc   3.2   Apr 16 2018 09:21:50   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   get_theme_srid.prc  $
--       Date into PVCS   : $Date:   Apr 16 2018 09:21:50  $
--       Date fetched Out : $Modtime:   Apr 16 2018 09:19:36  $
--       PVCS Version     : $Revision:   3.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
BEGIN
  RETURN nm3sdo.get_theme_metadata(p_nth_theme_id).srid;
END;
/
