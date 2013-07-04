CREATE OR REPLACE FORCE VIEW V_NM_MSV_THEMES
(VNMT_THEME_NAME, VNMT_BASE_TABLE, VNMT_GEOMETRY_COLUMN)
AS 
SELECT 
----------------------------------------------------------------------------- 
-- 
--   SCCS Identifiers :- 
-- 
--       sccsid           : @(#)v_nm_msv_themes.vw	1.2 02/06/06 
--       Module Name      : v_nm_msv_themes.vw 
--       Date into SCCS   : 06/02/06 10:24:29 
--       Date fetched Out : 07/06/13 17:08:37 
--       SCCS Version     : 1.2 
-- 
----------------------------------------------------------------------------- 
-- Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------- 
       name 
     , base_table 
     , geometry_column 
 FROM user_sdo_themes
/

