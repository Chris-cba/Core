CREATE OR REPLACE FORCE VIEW v_sdo_wms_theme_layers AS
SELECT
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_sdo_wms_theme_layers.vw-arc   3.1   Sep 19 2014 15:40:36   Mike.Huitson  $
--       Module Name      : $Workfile:   v_sdo_wms_theme_layers.vw  $
--       Date into PVCS   : $Date:   Sep 19 2014 15:40:36  $
--       Date fetched Out : $Modtime:   Sep 19 2014 15:34:04  $
--       Version          : $Revision:   3.1  $
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       themes.name         theme_name
      ,layers.column_value layer_name
  FROM mdsys.sdo_themes_table themes
      ,TABLE(CAST(nm3sdo_wms.tokenise_clob(EXTRACT(XMLTYPE(themes.styling_rules),'/styling_rules/layers/text()').getclobval()) AS nm_max_varchar_tbl)) layers
 WHERE themes.sdo_owner = SYS_CONTEXT('NM3CORE','APPLICATION_OWNER')
   AND themes.base_table = 'WMS'
/
