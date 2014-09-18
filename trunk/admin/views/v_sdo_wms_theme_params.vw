CREATE OR REPLACE FORCE VIEW v_sdo_wms_theme_params AS
SELECT
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_sdo_wms_theme_params.vw-arc   3.0   Sep 18 2014 13:55:14   Mike.Huitson  $
--       Module Name      : $Workfile:   v_sdo_wms_theme_params.vw  $
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
       name  theme_name
      ,LTRIM(RTRIM(EXTRACTVALUE(params.column_value,'/vsp/name')))  param_name
      ,LTRIM(RTRIM(EXTRACTVALUE(params.column_value,'/vsp/value'))) param_value
  FROM user_sdo_themes
      ,XMLTABLE('/styling_rules/vendor_specific_parameters/vsp'
                PASSING XMLTYPE(styling_rules)) params
 WHERE base_table = 'WMS'
/