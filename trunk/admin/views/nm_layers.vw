CREATE OR REPLACE FORCE VIEW NM_LAYERS
(NL_LAYER_NAME, NL_LAYER_DESCR, NL_LAYER_ID, NL_TABLE_NAME, NL_COLUMN_NAME, 
 NL_GTYPE, NL_SRS_TYPE)
AS 
select
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_layers.vw	1.1 10/28/03
--       Module Name      : nm_layers.vw
--       Date into SCCS   : 03/10/28 15:12:27
--       Date fetched Out : 07/06/13 17:08:11
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
  nth_theme_name,
  nth_theme_name,
  nth_theme_id,
  nth_feature_table,
  nth_feature_pk_column,
  '3002',
  srid
from user_sdo_geom_metadata, nm_themes_all, nm_nw_themes
where table_name = nth_feature_table
and nth_theme_id = nnth_nth_theme_id
/
