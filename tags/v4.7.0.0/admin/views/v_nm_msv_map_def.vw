CREATE OR REPLACE VIEW V_NM_MSV_MAP_DEF
(VNMD_NAME, VNMD_DESCRIPTION, VNMD_THEME_NAME, VNMD_THEME_MIN_SCALE, VNMD_THEME_MAX_SCALE)
AS 
SELECT
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)v_nm_msv_map_def.vw	1.4 06/27/06
--       Module Name      : v_nm_msv_map_def.vw
--       Date into SCCS   : 06/06/27 10:04:55
--       Date fetched Out : 07/06/13 17:08:35
--       SCCS Version     : 1.4
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
         name
       , description
       , xmltype.getstringval(EXTRACT(VALUE(d),'//@name'))      AS theme_name
       , xmltype.getstringval(EXTRACT(VALUE(d),'//@min_scale')) AS theme_min_scale
       , xmltype.getstringval(EXTRACT(VALUE(d),'//@max_scale')) AS theme_max_scale
 FROM user_sdo_maps m,
      TABLE(xmlsequence(EXTRACT(XMLTYPE(m.definition),'/map_definition/theme'))) d
/
