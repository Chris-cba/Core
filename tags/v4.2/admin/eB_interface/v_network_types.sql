CREATE OR REPLACE VIEW v_network_types
AS
     SELECT -------------------------------------------------------------------------
            --   PVCS Identifiers :-
            --       PVCS id          : $Header:   //new_vm_latest/archives/lb/admin/eB_interface/v_network_types.sql-arc   1.2   Sep 06 2016 15:21:44   Rob.Coupe  $
            --       Module Name      : $Workfile:   v_network_types.sql  $
            --       Date into PVCS   : $Date:   Sep 06 2016 15:21:44  $
            --       Date fetched Out : $Modtime:   Sep 06 2016 15:21:50  $
            --       Version          : $Revision:   1.2  $
            ------------------------------------------------------------------
            --   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
            -----------------------------------------------------------------
            --
            nlt_id,            -- Network type ID (essentially, the network element type ID)
            nt_type,           -- Unique code of the network element type
            nt_descr,          -- Network element type description
            external_unit_name -- Default length units of the network element type
     FROM 
        (
        SELECT 
           nt_type,
           nt_descr,
           NULL gty_type
        FROM 
           nm_types
        WHERE 
           nt_datum = 'Y'
        UNION ALL
        SELECT 
           ngt_nt_type,
           ngt_descr,
           nng_group_type
        FROM 
           nm_nt_groupings
           INNER JOIN nm_group_types ON ngt_group_type = nng_group_type
        UNION ALL
        SELECT 
           nit_inv_type,
           nit_descr,
           NULL
        FROM 
           nm_inv_types
           INNER JOIN nm_inv_nw ON nit_inv_type = nin_nit_inv_code
        WHERE 
           nit_linear = 'Y'
        )
        INNER JOIN nm_linear_types ON nlt_nt_type = nt_type AND NVL (nlt_gty_type, '^%&*') = NVL (gty_type, '^%&*')
        INNER JOIN lb_units ON exor_unit_id = nlt_units
     ORDER BY 
        nlt_seq_no
/
