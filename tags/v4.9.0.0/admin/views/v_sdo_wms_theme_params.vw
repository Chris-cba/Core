CREATE OR REPLACE FORCE VIEW v_sdo_wms_theme_params AS
SELECT
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdo_wms_theme_params.vw-arc   3.2   Apr 13 2018 11:47:26   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   v_sdo_wms_theme_params.vw  $
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
       themes.name  theme_name
      ,LTRIM(RTRIM(EXTRACTVALUE(params.column_value,'/vsp/name')))  param_name
      ,LTRIM(RTRIM(EXTRACTVALUE(params.column_value,'/vsp/value'))) param_value
  FROM mdsys.sdo_themes_table themes
      ,XMLTABLE('/styling_rules/vendor_specific_parameters/vsp' PASSING XMLTYPE(themes.styling_rules)) params
 WHERE themes.sdo_owner = SYS_CONTEXT('NM3CORE','APPLICATION_OWNER')
   AND themes.base_table = 'WMS'
/