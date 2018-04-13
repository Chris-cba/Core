CREATE OR REPLACE FORCE VIEW v_sdo_wms_theme_layers AS
SELECT
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdo_wms_theme_layers.vw-arc   3.2   Apr 13 2018 11:47:26   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   v_sdo_wms_theme_layers.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:26  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:44:38  $
--       Version          : $Revision:   3.2  $
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       themes.name         theme_name
      ,layers.column_value layer_name
  FROM mdsys.sdo_themes_table themes
      ,TABLE(CAST(nm3sdo_wms.tokenise_clob(EXTRACT(XMLTYPE(themes.styling_rules),'/styling_rules/layers/text()').getclobval()) AS nm_max_varchar_tbl)) layers
 WHERE themes.sdo_owner = SYS_CONTEXT('NM3CORE','APPLICATION_OWNER')
   AND themes.base_table = 'WMS'
/
