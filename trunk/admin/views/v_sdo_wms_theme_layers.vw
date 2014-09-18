CREATE OR REPLACE FORCE VIEW v_sdo_wms_theme_layers AS
SELECT
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_sdo_wms_theme_layers.vw-arc   3.0   Sep 18 2014 13:55:14   Mike.Huitson  $
--       Module Name      : $Workfile:   v_sdo_wms_theme_layers.vw  $
--       Date into PVCS   : $Date:   Sep 18 2014 13:55:14  $
--       Date fetched Out : $Modtime:   Sep 18 2014 13:41:22  $
--       Version          : $Revision:   3.0  $
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       name         theme_name
      ,column_value layer_name
  FROM user_sdo_themes
      ,TABLE(CAST(nm3sdo_wms.tokenise_clob(EXTRACT(XMLTYPE(styling_rules),'/styling_rules/layers/text()').getclobval()) AS nm_max_varchar_tbl)) layers
 WHERE base_table = 'WMS'
/
