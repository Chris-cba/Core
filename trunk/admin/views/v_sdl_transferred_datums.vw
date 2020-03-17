CREATE OR REPLACE VIEW v_sdl_transferred_datums AS
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdl_transferred_datums.vw-arc   1.0   Mar 17 2020 14:30:30   Vikas.Mhetre  $
--       Module Name      : $Workfile:   v_sdl_transferred_datums.vw  $
--       Date into PVCS   : $Date:   Mar 17 2020 14:30:30  $
--       Date fetched Out : $Modtime:   Mar 17 2020 11:09:12  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : Vikas Mhetre
--
--   A view to get loaded datums into AWLRS, can be used to show data on map layer using this view 
--
-----------------------------------------------------------------------------
-- Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
-- 
SELECT d.swd_id, d.sld_key, d.pct_match, d.batch_id, d.datum_id, d.new_ne_id, d.geom
  FROM sdl_wip_datums d
 WHERE d.status = 'TRANSFERRED'
   AND d.new_ne_id IS NOT NULL
   AND d.batch_id = NVL (TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'SDLCTX_SFS_ID')), d.batch_id)
/