CREATE OR REPLACE VIEW v_lb_inv_nlt_data
(
   AssetType,
   NetworkTypeId,
   NetworkType,
   NetworkTypeName,
   NetworkFlag,
   NetworkTypeDescr,
   MandatoryLocation,
   UnitId,
   UnitName,
   UnitMask
)
AS
   WITH inv_nw
        AS (SELECT *
              FROM nm_inv_nw, lb_types, V_NM_NLT_DATA
             WHERE     lb_exor_inv_type = nin_nit_inv_code
                   AND nin_nw_type = nt_type)
   SELECT 
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/views/v_lb_inv_nlt_data.vw-arc   1.0   Aug 11 2017 15:07:30   Rob.Coupe  $
--       Module Name      : $Workfile:   v_lb_inv_nlt_data.vw  $
--       Date into PVCS   : $Date:   Aug 11 2017 15:07:30  $
--       Date fetched Out : $Modtime:   Aug 11 2017 15:06:58  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : R.A. Coupe
--
--   View definition script for interim install of Location Bridge
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--     
          lb_object_type,
          nlt_id,
          nt_type,
          nt_unique,
          nlt_g_i_d,
          nt_descr,
          nin_loc_mandatory,
          nlt_units,
          un_unit_name,
          un_format_mask
     FROM inv_nw
   UNION
   SELECT lb_object_type,
          g.nlt_id,
          g.nt_type,
          g.nt_unique,
          g.nlt_g_i_d,
          g.nt_descr,
          nin_loc_mandatory,
          g.nlt_units,
          g.un_unit_name,
          g.un_format_mask
     FROM inv_nw i,
          nm_nt_groupings,
          V_NM_NLT_DATA g,
          nm_group_types
    WHERE     nng_nt_type = nin_nw_type
          AND ngt_group_type = nng_group_type
          AND nng_group_type = g.gty_type
/
