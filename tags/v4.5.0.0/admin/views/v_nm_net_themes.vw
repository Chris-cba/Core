CREATE OR REPLACE FORCE VIEW V_NM_NET_THEMES
 ( vnnt_nth_theme_id
 , vnnt_nth_theme_name
 , vnnt_nth_base_table_theme
 , vnnt_type
 , vnnt_nt_type
 , vnnt_gty_type
 , vnnt_lr_type )
AS 
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)v_nm_net_themes.vw	1.2 03/07/06
--       Module Name      : v_nm_net_themes.vw
--       Date into SCCS   : 06/03/07 17:19:36
--       Date fetched Out : 07/06/13 17:08:37
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2006
-----------------------------------------------------------------------------
SELECT "VNNT_NTH_THEME_ID", "VNNT_NTH_THEME_NAME",
       "VNNT_NTH_BASE_TABLE_THEME", "VNNT_TYPE", "VNNT_NT_TYPE",
       "VNNT_GTY_TYPE", "VNNT_LR_TYPE"
  FROM v_nm_net_themes_all
 WHERE EXISTS (
          SELECT 1
            FROM nm_theme_roles, hig_user_roles
           WHERE nthr_role = hur_role
             AND nthr_theme_id = vnnt_nth_theme_id
             AND hur_username = Sys_Context('NM3_SECURITY_CTX','USERNAME'))
/

