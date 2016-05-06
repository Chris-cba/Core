CREATE OR REPLACE VIEW v_lb_type_nw_flags
AS
   SELECT                                             --   PVCS Identifiers :-
                                                                            --
 --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/eB_interface/v_lb_type_nw_flags.vw-arc   1.0   May 06 2016 15:05:08   Rob.Coupe  $
                        --       Module Name      : $Workfile:   v_lb_type_nw_flags.vw  $
                  --       Date into PVCS   : $Date:   May 06 2016 15:05:08  $
               --       Date fetched Out : $Modtime:   May 06 2016 15:05:04  $
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
   FROM nm_inv_types
        INNER JOIN lb_types ON lb_exor_inv_type = nit_inv_type
        LEFT OUTER JOIN NM_INV_NW ON nin_nit_inv_code = lb_exor_inv_type
        LEFT OUTER JOIN NM_LINEAR_TYPES ON NLT_NT_TYPE = nin_nw_type