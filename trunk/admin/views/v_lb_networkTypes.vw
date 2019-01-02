CREATE OR REPLACE VIEW v_lb_networkTypes
AS
   WITH nlt
        AS (SELECT 
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_lb_networkTypes.vw-arc   1.1   Jan 02 2019 12:02:48   Chris.Baugh  $
--       Module Name      : $Workfile:   v_lb_networkTypes.vw  $
--       Date into PVCS   : $Date:   Jan 02 2019 12:02:48  $
--       Date fetched Out : $Modtime:   Jan 02 2019 12:02:28  $
--       Version          : $Revision:   1.1  $
--------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
--------------------------------------------------------------------------
----
                   d.*,
                   nlt_id,
                   nlt_seq_no,
                   nlt_units,
                   un_unit_name,
                   un_format_mask
              FROM (SELECT 'D' nlt_g_i_d,
                           nt_type nt_type,
                           nt_descr,
                           NULL gty_type,
                           nt_type datum_type
                      FROM nm_types
                     WHERE nt_datum = 'Y'
                    UNION ALL
                    SELECT 'G',
                           ngt_nt_type,
                           ngt_descr,
                           nng_group_type,
                           nng_nt_type
                      FROM nm_nt_groupings, nm_group_types
                     WHERE ngt_group_type = nng_group_type
                    UNION ALL
                    SELECT 'I',
                           nit_inv_type,
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
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_lb_networkTypes.vw-arc   1.1   Jan 02 2019 12:02:48   Chris.Baugh  $
--       Module Name      : $Workfile:   v_lb_networkTypes.vw  $
--       Date into PVCS   : $Date:   Jan 02 2019 12:02:48  $
--       Date fetched Out : $Modtime:   Jan 02 2019 12:02:28  $
--       PVCS Version     : $Revision:   1.1  $
--
--   Author : R.A. Coupe
--
--   View definition script for interim install of Location Bridge
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--
   *
     FROM nlt
    WHERE EXISTS
             (SELECT 1
                FROM nm_inv_nw, lb_types
               WHERE     lb_exor_inv_type = nin_nit_inv_code
                     AND nin_nw_type = datum_type
                     AND NVL (SYS_CONTEXT ('NM3SQL', 'LB_ASSET_TYPE'),
                              TO_CHAR (lb_object_type)) =
                            TO_CHAR (lb_object_type))
/
