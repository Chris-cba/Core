--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/mig/dbtune_sdo_geometry.sql-arc   2.2   Apr 13 2018 07:38:08   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   dbtune_sdo_geometry.sql  $
--       Date into PVCS   : $Date:   Apr 13 2018 07:38:08  $
--       Date fetched Out : $Modtime:   Apr 13 2018 07:24:50  $
--       Version          : $Revision:   2.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
REM sccsid = '"@(#)dbtune_sdo_geometry.sql	1.2 02/09/05"'
BEGIN
Insert into DBTUNE
   (KEYWORD, PARAMETER_NAME, CONFIG_STRING)
 Values
   ('SDO_GEOMETRY', 'ATTRIBUTE_BINARY', 'LONGRAW');
Insert into DBTUNE
   (KEYWORD, PARAMETER_NAME, CONFIG_STRING)
 Values
   ('SDO_GEOMETRY', 'COMMENT', 'Any general comment for SDO_GEOMETRY keyword');
Insert into DBTUNE
   (KEYWORD, PARAMETER_NAME, CONFIG_STRING)
 Values
   ('SDO_GEOMETRY', 'GEOMETRY_STORAGE', 'SDO_GEOMETRY');
Insert into DBTUNE
   (KEYWORD, PARAMETER_NAME, CONFIG_STRING)
 Values
   ('SDO_GEOMETRY', 'UI_NETWORK_TEXT', 'User Interface network text description for SDO_GEOMETRY keyword');
Insert into DBTUNE
   (KEYWORD, PARAMETER_NAME, CONFIG_STRING)
 Values
   ('SDO_GEOMETRY', 'UI_TEXT', 'User Interface text description for SDO_GEOMETRY keyword');

COMMIT;
   EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      -- good sign the metadata has already been run in
      NULL;
END;
/
