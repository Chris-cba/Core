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
   --       sccsid           : $Header:   //vm_latest/archives/nm3/admin/utl/create_asgm_view.sql-arc   3.0   Dec 01 2008 11:53:42   aedwards  $
   --       Module Name      : $Workfile:   create_asgm_view.sql  $
   --       Date into PVCS   : $Date:   Dec 01 2008 11:53:42  $
   --       Date fetched Out : $Modtime:   Dec 01 2008 11:51:56  $
   --       PVCS Version     : $Revision:   3.0  $
   --
   --------------------------------------------------------------------------------
   --
   --  
   --  Exor Corporation 2008
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
