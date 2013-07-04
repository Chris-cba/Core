CREATE OR REPLACE FORCE VIEW v_nm_net_themes_all
( vnnt_nth_theme_id
, vnnt_nth_theme_name
, vnnt_nth_base_table_theme
, vnnt_type
, vnnt_nt_type
, vnnt_gty_type
, vnnt_lr_type )
AS
SELECT 
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)v_nm_net_themes_all.vw	1.2 03/07/06
--       Module Name      : v_nm_net_themes_all.vw
--       Date into SCCS   : 06/03/07 17:19:49
--       Date fetched Out : 07/06/13 17:08:38
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2006
-----------------------------------------------------------------------------
       nth_theme_id, nth_theme_name, nth_base_table_theme, 'L', nlt_nt_type,
       nlt_gty_type, nlt_g_i_d
  FROM nm_themes_all, nm_nw_themes, nm_linear_types
 WHERE nnth_nth_theme_id = nth_theme_id AND nnth_nlt_id = nlt_id
UNION
SELECT nth_theme_id, nth_theme_name, nth_base_table_theme, 'A', nat_nt_type,
       nat_gty_group_type, 'A'
  FROM nm_themes_all, nm_area_themes, nm_area_types
 WHERE nath_nth_theme_id = nth_theme_id AND nath_nat_id = nat_id
/

