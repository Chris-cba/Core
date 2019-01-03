CREATE OR REPLACE FUNCTION null_conversion
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/pck/null_conversion.fnc-arc   1.0   Jan 03 2019 08:53:38   Chris.Baugh  $
--       Module Name      : $Workfile:   null_conversion.fnc  $
--       Date into PVCS   : $Date:   Jan 03 2019 08:53:38  $
--       Date fetched Out : $Modtime:   Dec 18 2018 08:16:36  $
--       Version          : $Revision:   1.0  $
--
------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--  
   (UNITSIN IN NUMBER)
	 RETURN NUMBER IS
--
  RETVAL NUMBER;
--
BEGIN
--  
  RETVAL := UNITSIN;   
  
  RETURN RETVAL;
--
END null_conversion;
/
