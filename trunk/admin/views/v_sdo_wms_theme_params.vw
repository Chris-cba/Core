CREATE OR REPLACE FORCE VIEW v_sdo_wms_theme_params AS
SELECT
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_sdo_wms_theme_params.vw-arc   3.1   Sep 19 2014 15:40:36   Mike.Huitson  $
--       Module Name      : $Workfile:   v_sdo_wms_theme_params.vw  $
--       Date into PVCS   : $Date:   Sep 19 2014 15:40:36  $
--       Date fetched Out : $Modtime:   Sep 19 2014 15:36:08  $
--       Version          : $Revision:   3.1  $
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       themes.name  theme_name
      ,LTRIM(RTRIM(EXTRACTVALUE(params.column_value,'/vsp/name')))  param_name
      ,LTRIM(RTRIM(EXTRACTVALUE(params.column_value,'/vsp/value'))) param_value
  FROM mdsys.sdo_themes_table themes
      ,XMLTABLE('/styling_rules/vendor_specific_parameters/vsp' PASSING XMLTYPE(themes.styling_rules)) params
 WHERE themes.sdo_owner = SYS_CONTEXT('NM3CORE','APPLICATION_OWNER')
   AND themes.base_table = 'WMS'
/