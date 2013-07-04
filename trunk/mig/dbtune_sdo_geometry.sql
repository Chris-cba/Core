--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/mig/dbtune_sdo_geometry.sql-arc   2.1   Jul 04 2013 16:49:08   James.Wadsworth  $
--       Module Name      : $Workfile:   dbtune_sdo_geometry.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:49:08  $
--       Date fetched Out : $Modtime:   Jul 04 2013 16:47:14  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
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
