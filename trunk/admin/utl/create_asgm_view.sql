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
   --       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/utl/create_asgm_view.sql-arc   3.2   Apr 13 2018 12:53:22   Gaurav.Gaurkar  $
   --       Module Name      : $Workfile:   create_asgm_view.sql  $
   --       Date into PVCS   : $Date:   Apr 13 2018 12:53:22  $
   --       Date fetched Out : $Modtime:   Apr 13 2018 12:49:46  $
   --       PVCS Version     : $Revision:   3.2  $
   --
   -----------------------------------------------------------------------------
   --    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
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
