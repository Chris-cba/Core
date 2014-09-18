CREATE OR REPLACE FORCE VIEW v_sdo_wms_theme_styles AS
SELECT
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_sdo_wms_theme_styles.vw-arc   3.0   Sep 18 2014 13:55:16   Mike.Huitson  $
--       Module Name      : $Workfile:   v_sdo_wms_theme_styles.vw  $
--       Date into PVCS   : $Date:   Sep 18 2014 13:55:16  $
--       Date fetched Out : $Modtime:   Sep 18 2014 13:41:14  $
--       Version          : $Revision:   3.0  $
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       name         theme_name
      ,column_value style_name
  FROM user_sdo_themes
      ,TABLE(CAST(nm3sdo_wms.tokenise_clob(EXTRACT(XMLTYPE(styling_rules),'/styling_rules/styles/text()').getclobval()) AS nm_max_varchar_tbl)) styles
 WHERE base_table = 'WMS'
/
