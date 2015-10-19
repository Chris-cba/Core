CREATE OR REPLACE VIEW v_network_types
AS
     SELECT -------------------------------------------------------------------------
            --   PVCS Identifiers :-
            --       PVCS id          : $Header:   //new_vm_latest/archives/lb/admin/eB_interface/v_network_types.sql-arc   1.0   Oct 19 2015 11:48:38   Rob.Coupe  $
            --       Module Name      : $Workfile:   v_network_types.sql  $
            --       Date into PVCS   : $Date:   Oct 19 2015 11:48:38  $
            --       Date fetched Out : $Modtime:   Oct 19 2015 11:47:16  $
            --       Version          : $Revision:   1.0  $
            ------------------------------------------------------------------
            --   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
            -----------------------------------------------------------------
            --
            lb_object_type,    -- External ID of linearly locatable asset type
            nlt_id, -- Network type ID (essentially, the network element type ID)
            a.nt_type,              -- Unique code of the network element type
            a.nt_descr,                    -- Network element type description
            external_unit_id length_unit_id -- Default length units of the network element type
       FROM (SELECT nt_type nt_type,
                    nt_descr,
                    NULL gty_type,
                    nt_type datum_type
               FROM nm_types
              WHERE nt_datum = 'Y'
             UNION ALL
             SELECT ngt_nt_type,
                    ngt_descr,
                    nng_group_type,
                    nng_nt_type
               FROM nm_nt_groupings, nm_group_types
              WHERE ngt_group_type = nng_group_type
             UNION ALL
             SELECT nit_inv_type,
                    nit_descr,
                    NULL,
                    nin_nw_type
               FROM nm_inv_types, nm_inv_nw
              WHERE nit_linear = 'Y' AND nit_inv_type = nin_nit_inv_code) a
            INNER JOIN nm_linear_types
               ON     nlt_nt_type = nt_type
                  AND NVL (nlt_gty_type, '^%&*') = NVL (a.gty_type, '^%&*')
            INNER JOIN nm_units ON nlt_units = un_unit_id
            INNER JOIN nm_inv_nw ON nin_nw_type = datum_type
            INNER JOIN lb_types ON lb_exor_inv_type = nin_nit_inv_code
            INNER JOIN lb_units ON exor_unit_id = nlt_units
   ORDER BY nlt_seq_no
/
