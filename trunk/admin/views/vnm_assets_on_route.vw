CREATE OR replace force view vnm_assets_on_route AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : "'@(#)vnm_assets_on_route.vw	1.2 10/26/01'"
--       Module Name      : "'vnm_assets_on_route.vw'"
--       Date into SCCS   : "'01/10/26 12:01:25'"
--       Date fetched Out : "'07/06/13 17:08:40'"
--       SCCS Version     : "'1.2'"
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
 nar_route_ne_id,
 nar_route_seq_no,
 nar_route_seg_no,
 nar_element_ne_id,
 nar_element_descr,
 nar_element_unique,
 nar_asset_ne_id,
 nar_asset_begin_mp,
 nar_asset_end_mp,
 nar_route_slk,
 nar_route_true,
 nar_asset_type,
 nar_asset_measure,
 nar_asset_type_descr,
 nar_asset_pk,
 nar_located_by,
 nar_located_pk,
 nar_located_type,
 nar_loc_type_descr,
 nar_type,
 nar_ref_post,
 nar_ref_pk,
 nar_ref_measure,
 nm3unit.convert_unit( NVL(nm3asset.get_nar_datum_unit,1), Sys_Context('NM3CORE','USER_LENGTH_UNITS'), nar_ref_measure ) nar_ref_measure_units
FROM nm_assets_on_route
/
