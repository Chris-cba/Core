CREATE OR REPLACE FORCE VIEW V_NM_NLT_UNIT_CONVERSIONS
(
   GROUP_NLT_ID,
   GTY_TYPE,
   DATUM_TYPE,
   DATUM_NLT_ID,
   GROUP_UNIT_ID,
   GROUP_UNIT,
   GROUP_FORMAT_MASK,
   DATUM_UNIT_ID,
   DATUM_UNIT,
   DATUM_FOMAT_MASK,
   UC_FACTOR
)
AS
   SELECT 
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/views/v_nm_nlt_unit_conversions.vw-arc   1.0   Aug 11 2017 15:12:02   Rob.Coupe  $
--       Module Name      : $Workfile:   v_nm_nlt_unit_conversions.vw  $
--       Date into PVCS   : $Date:   Aug 11 2017 15:12:02  $
--       Date fetched Out : $Modtime:   Aug 07 2017 22:00:28  $
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
          lg.nlt_id group_nlt_id,
          lg.gty_type,
          lg.datum_type,
          LD.NLT_ID datum_nlt_id,
          lg.nlt_units group_unit_id,
          LG.UN_UNIT_NAME group_unit,
          LG.UN_FORMAT_MASK group_format_mask,
          ld.nlt_units datum_unit_id,
          Ld.UN_UNIT_NAME datum_unit,
          Ld.UN_FORMAT_MASK datum_fomat_mask,
          (SELECT CASE (lg.nlt_units - ld.nlt_units)
                     WHEN 0
                     THEN
                        1
                     ELSE
                        (SELECT uc_conversion_factor
                           FROM nm_unit_conversions
                          WHERE     uc_unit_id_in = lg.nlt_units
                                AND uc_unit_id_out = ld.nlt_units)
                  END
                     uc_factor
             FROM DUAL)
             uc_factor
     FROM v_nm_nlt_data lg, nm_nt_groupings g, v_nm_nlt_data ld
    WHERE g.nng_group_type = lg.gty_type AND ld.nt_type = nng_nt_type;
