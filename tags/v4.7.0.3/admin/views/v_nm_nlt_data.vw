CREATE OR REPLACE VIEW v_nm_nlt_data
AS
   WITH nlt
        AS (SELECT 
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/views/v_nm_nlt_data.vw-arc   1.0   Aug 11 2017 14:56:02   Rob.Coupe  $
--       Module Name      : $Workfile:   v_nm_nlt_data.vw  $
--       Date into PVCS   : $Date:   Aug 11 2017 14:56:02  $
--       Date fetched Out : $Modtime:   Aug 11 2017 14:55:28  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : Rob Coupe
--
--   Location Bridge data script.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--		
		           d.*,
                   nlt_id,
                   nlt_seq_no,
                   nlt_units,
                   un_unit_name,
                   un_format_mask
              FROM (SELECT 'D' nlt_g_i_d,
                           nt_type nt_type,
                           nt_unique,
                           nt_descr,
                           NULL gty_type,
                           nt_type datum_type
                      FROM nm_types
                     WHERE nt_datum = 'Y'
                    UNION ALL
                    SELECT 'G',
                           ngt_nt_type,
                           nt_unique,
                           ngt_descr,
                           nng_group_type,
                           nng_nt_type
                      FROM nm_nt_groupings, nm_group_types, nm_types
                     WHERE ngt_group_type = nng_group_type
                     and ngt_nt_type = nt_type
                    UNION ALL
                    SELECT 'I',
                           nit_inv_type,
                           nvl(nit_short_descr, nit_inv_type),
                           nit_descr,
                           NULL,
                           nin_nw_type
                      FROM nm_inv_types, nm_inv_nw
                     WHERE     nit_linear = 'Y'
                           AND nit_inv_type = nin_nit_inv_code) d,
                   nm_linear_types,
                   nm_units
             WHERE     nlt_nt_type = nt_type
                   AND NVL (nlt_gty_type, '^%&*') = NVL (gty_type, '^%&*')
                   AND nlt_units = un_unit_id)
   SELECT 
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/views/v_nm_nlt_data.vw-arc   1.0   Aug 11 2017 14:56:02   Rob.Coupe  $
--       Module Name      : $Workfile:   v_nm_nlt_data.vw  $
--       Date into PVCS   : $Date:   Aug 11 2017 14:56:02  $
--       Date fetched Out : $Modtime:   Aug 11 2017 14:55:28  $
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
          "NLT_G_I_D",
          "NT_TYPE",
          "NT_UNIQUE",
          "NT_DESCR",
          "GTY_TYPE",
          "DATUM_TYPE",
          "NLT_ID",
          "NLT_SEQ_NO",
          "NLT_UNITS",
          "UN_UNIT_NAME",
          "UN_FORMAT_MASK"
     FROM nlt
    WHERE EXISTS
             (SELECT 1
                FROM nm_inv_nw
               WHERE     NVL (SYS_CONTEXT ('NM3SQL', 'NLT_DATA_INV_TYPE'),
                              nin_nit_inv_code) = nin_nit_inv_code
                     AND nin_nw_type = datum_type)
/
