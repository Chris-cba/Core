CREATE OR REPLACE FORCE VIEW v_nm_wms_themes AS
SELECT
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_wms_themes.vw-arc   3.0   Sep 18 2014 13:55:18   Mike.Huitson  $
--       Module Name      : $Workfile:   v_nm_wms_themes.vw  $
--       Date into PVCS   : $Date:   Sep 18 2014 13:55:18  $
--       Date fetched Out : $Modtime:   Sep 18 2014 13:41:22  $
--       Version          : $Revision:   3.0  $
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       nwt.nwt_id
      ,nwt.nwt_name
      ,nwt.nwt_is_background
      ,nwt.nwt_transparency
      ,nwt.nwt_visible_on_startup
      ,swt.description
      ,swt.service_url
      ,swt.auth_user
      ,swt.auth_password
      ,swt.layers
      ,swt.version
      ,swt.srs
      ,swt.format
      ,swt.bgcolor
      ,swt.transparent
      ,swt.styles
      ,swt.exceptions
      ,swt.capabilities_url
  FROM nm_wms_themes nwt
      ,v_sdo_wms_themes swt
 WHERE nwt.nwt_name = swt.theme_name
   AND EXISTS(SELECT 1
                FROM hig_user_roles
                    ,nm_wms_theme_roles
               WHERE nwtr_nwt_id = nwt_id
                 AND nwtr_role = hur_role
                 AND hur_username = SYS_CONTEXT ('NM3_SECURITY_CTX', 'USERNAME'))
/
