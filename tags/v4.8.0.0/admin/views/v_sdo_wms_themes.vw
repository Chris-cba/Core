CREATE OR REPLACE FORCE VIEW v_sdo_wms_themes AS
SELECT
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdo_wms_themes.vw-arc   3.2   Apr 13 2018 11:47:26   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   v_sdo_wms_themes.vw  $
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
       name  theme_name
      ,description
      ,LTRIM(RTRIM(EXTRACTVALUE(XMLTYPE(styling_rules),'/styling_rules/service_url')))  service_url
      ,LTRIM(RTRIM(EXTRACTVALUE(XMLTYPE(styling_rules),'/styling_rules/user')))  auth_user
      ,LTRIM(RTRIM(EXTRACTVALUE(XMLTYPE(styling_rules),'/styling_rules/password')))  auth_password
      ,LTRIM(RTRIM(EXTRACT(XMLTYPE(styling_rules),'/styling_rules/layers/text()').getclobval()))  layers
      ,LTRIM(RTRIM(EXTRACTVALUE(XMLTYPE(styling_rules),'/styling_rules/version')))  version
      ,LTRIM(RTRIM(EXTRACTVALUE(XMLTYPE(styling_rules),'/styling_rules/srs')))  srs
      ,LTRIM(RTRIM(EXTRACTVALUE(XMLTYPE(styling_rules),'/styling_rules/format')))  format
      ,LTRIM(RTRIM(EXTRACTVALUE(XMLTYPE(styling_rules),'/styling_rules/bgcolor')))  bgcolor
      ,LTRIM(RTRIM(EXTRACTVALUE(XMLTYPE(styling_rules),'/styling_rules/transparent')))  transparent
      ,LTRIM(RTRIM(EXTRACT(XMLTYPE(styling_rules),'/styling_rules/styles/text()').getclobval()))  styles
      ,LTRIM(RTRIM(EXTRACTVALUE(XMLTYPE(styling_rules),'/styling_rules/exceptions')))  exceptions
      ,LTRIM(RTRIM(EXTRACTVALUE(XMLTYPE(styling_rules),'/styling_rules/capabilities_url')))  capabilities_url
  FROM mdsys.sdo_themes_table themes
 WHERE sdo_owner = SYS_CONTEXT('NM3CORE','APPLICATION_OWNER')
   AND base_table = 'WMS'
/
