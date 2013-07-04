CREATE OR REPLACE FORCE VIEW GIS_THEMES_ALL
(GT_THEME_ID, GT_THEME_NAME, GT_TABLE_NAME, GT_WHERE, GT_PK_COLUMN, 
 GT_LABEL_COLUMN, GT_RSE_TABLE_NAME, GT_RSE_FK_COLUMN, GT_ST_CHAIN_COLUMN, GT_END_CHAIN_COLUMN, 
 GT_X_COLUMN, GT_Y_COLUMN, GT_OFFSET_FIELD, GT_FEATURE_TABLE, GT_FEATURE_PK_COLUMN, 
 GT_FEATURE_FK_COLUMN, GT_ROUTE_THEME, GT_XSP_COLUMN, GT_FEATURE_SHAPE_COLUMN, GT_HPR_PRODUCT, 
 GT_LOCATION_UPDATABLE)
AS 
select 
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)gis_themes_all.vw	1.1 10/28/03
--       Module Name      : gis_themes_all.vw
--       Date into SCCS   : 03/10/28 15:11:48
--       Date fetched Out : 07/06/13 17:08:00
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
NTH_THEME_ID, 
NTH_THEME_NAME, 
NTH_TABLE_NAME, 
NTH_WHERE, 
NTH_PK_COLUMN, 
NTH_LABEL_COLUMN, 
NTH_RSE_TABLE_NAME, 
NTH_RSE_FK_COLUMN, 
NTH_ST_CHAIN_COLUMN, 
NTH_END_CHAIN_COLUMN, 
NTH_X_COLUMN, 
NTH_Y_COLUMN, 
NTH_OFFSET_FIELD, 
NTH_FEATURE_TABLE, 
NTH_FEATURE_PK_COLUMN, 
NTH_FEATURE_FK_COLUMN, 
decode( nlt_g_i_d, 'D', 'Y', 'N')  NTH_ROUTE_THEME, 
NTH_XSP_COLUMN, 
NTH_FEATURE_SHAPE_COLUMN, 
NTH_HPR_PRODUCT, 
NTH_LOCATION_UPDATABLE 
from nm_themes_all, 
     nm_linear_types, 
     nm_nw_themes 
where nth_theme_id = NNTH_NTH_THEME_ID (+) 
and   NLT_ID (+) = NNTH_NLT_ID;
