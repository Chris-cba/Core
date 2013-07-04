CREATE OR REPLACE FORCE VIEW MDSYS.ALL_SDO_GEOM_METADATA
(
   OWNER,
   TABLE_NAME,
   COLUMN_NAME,
   DIMINFO,
   SRID
)
AS
   SELECT
   --
   --------------------------------------------------------------------------------
   --   PVCS Identifiers :-
   --
   --       sccsid           : $Header:   //vm_latest/archives/nm3/admin/utl/create_asgm_view.sql-arc   3.1   Jul 04 2013 10:29:56   James.Wadsworth  $
   --       Module Name      : $Workfile:   create_asgm_view.sql  $
   --       Date into PVCS   : $Date:   Jul 04 2013 10:29:56  $
   --       Date fetched Out : $Modtime:   Jul 04 2013 10:20:46  $
   --       PVCS Version     : $Revision:   3.1  $
   --
   -----------------------------------------------------------------------------
   --    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
   -----------------------------------------------------------------------------
   --   
   -- This is an altered version of the standard Oracle MDSYS ALL_SDO_GEOM_METADATA view
   -- that should help improve performance of the startup of Locator and Mapbuilder.
   -- You will be unable to access any feature objects if they are based on 
   -- Object Table or Synonyms. If this is the case, then please contact exor Support.
   --
   --------------------------------------------------------------------------------
   --
            SDO_OWNER OWNER,
            SDO_TABLE_NAME TABLE_NAME,
            SDO_COLUMN_NAME COLUMN_NAME,
            SDO_DIMINFO DIMINFO,
            SDO_SRID SRID
     FROM   mdsys.SDO_GEOM_METADATA_TABLE, all_tables a
    WHERE   a.table_name = sdo_table_name AND a.owner = sdo_owner
   UNION ALL
   SELECT   SDO_OWNER OWNER,
            SDO_TABLE_NAME TABLE_NAME,
            SDO_COLUMN_NAME COLUMN_NAME,
            SDO_DIMINFO DIMINFO,
            SDO_SRID SRID
     FROM   mdsys.SDO_GEOM_METADATA_TABLE, all_views a
    WHERE   a.view_name = sdo_table_name AND a.owner = sdo_owner
/
