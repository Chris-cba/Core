--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/install/lb_41_42_upg.sql-arc   1.0   Dec 02 2015 15:43:26   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_41_42_upg.sql  $
--       Date into PVCS   : $Date:   Dec 02 2015 15:43:26  $
--       Date fetched Out : $Modtime:   Dec 02 2015 15:43:14  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : R.A. Coupe
--
--   Location Bridge 4.1 to 4.2 Upgrade script
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--

alter table nm_asset_geometry_all
drop constraint nag_uk;

drop index NAG_ASSET_IDX;

CREATE UNIQUE INDEX NAG_ASSET_IDX ON NM_ASSET_GEOMETRY_ALL
(NAG_ASSET_ID, NAG_OBJ_TYPE, NAG_START_DATE, NAG_LOCATION_TYPE, NAG_END_DATE);


alter table nm_asset_geometry_all
add  CONSTRAINT NAG_UK
  UNIQUE (NAG_ASSET_ID, NAG_OBJ_TYPE, NAG_START_DATE, NAG_LOCATION_TYPE, NAG_END_DATE)
  USING INDEX NAG_ASSET_IDX;
  
