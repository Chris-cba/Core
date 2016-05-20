CREATE OR REPLACE FORCE VIEW V_LB_TYPE_NW_FLAGS
(LB_OBJECT_TYPE, LB_ASSET_GROUP, LB_EXOR_INV_TYPE, NIN_NW_TYPE, NLT_ID,
 NIN_LOC_MANDATORY, NIT_PNT_OR_CONT, NIT_X_SECT_ALLOW_FLAG, NIT_EXCLUSIVE)
AS
SELECT --   PVCS Identifiers :-
       --
       --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/views/v_lb_type_nw_flags.vw-arc   1.0   May 20 2016 11:10:30   Rob.Coupe  $
       --       Module Name      : $Workfile:   v_lb_type_nw_flags.vw  $
       --       Date into PVCS   : $Date:   May 20 2016 11:10:30  $
       --       Date fetched Out : $Modtime:   May 20 2016 11:09:46  $
       --       PVCS Version     : $Revision:   1.0  $
       --
       --   Author : R.A. Coupe
       --
       --   Location Bridge view describing various network flags for an asset type
       --
       -----------------------------------------------------------------------------
       -- Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
       ----------------------------------------------------------------------------
       --
       lb_object_type,
       lb_asset_group,
       lb_exor_inv_type,
       nin_nw_type,
       nlt_id,
       nin_loc_mandatory,
       nit_pnt_or_cont,
       nit_x_sect_allow_flag,
       nit_exclusive
  FROM nm_inv_types,
       nm_inv_nw,
       lb_types,
       nm_linear_types
 WHERE     nit_inv_type = nin_nit_inv_code(+)
       AND lb_exor_inv_type = nit_inv_type
       AND nlt_nt_type(+) = nin_nw_type;
