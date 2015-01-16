CREATE OR REPLACE FORCE VIEW v_nm_msv_styles AS
SELECT
--
--------------------------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_msv_styles.vw-arc   3.0   Jan 16 2015 11:33:24   Mike.Huitson  $
--       Module Name      : $Workfile:   v_nm_msv_styles.vw  $
--       Date into PVCS   : $Date:   Jan 16 2015 11:33:24  $
--       Date fetched Out : $Modtime:   Jan 15 2015 08:54:38  $
--       PVCS Version     : $Revision:   3.0  $
--
--   Product upgrade script
--
--------------------------------------------------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
--------------------------------------------------------------------------------------------------------------------
--
    theme.name theme_name,
    style_from_xml(theme.styling_rules) style_name,
    style.type style_type,
    style.description style_descr,
    nm3_msv_util.get_style_size(style.name) style_size
FROM (SELECT * FROM MDSYS.sdo_themes_table WHERE sdo_owner = SYS_CONTEXT('NM3CORE','APPLICATION_OWNER')) theme 
LEFT OUTER JOIN 
     (SELECT * FROM MDSYS.sdo_styles_table WHERE sdo_owner = SYS_CONTEXT('NM3CORE','APPLICATION_OWNER')) style
ON style_from_xml(theme.styling_rules) = style.name
/
