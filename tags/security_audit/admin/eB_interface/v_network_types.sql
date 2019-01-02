CREATE OR REPLACE VIEW v_network_types
AS
     SELECT -------------------------------------------------------------------------
            --   PVCS Identifiers :-
            --       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/eB_interface/v_network_types.sql-arc   1.4   Jan 02 2019 11:44:16   Chris.Baugh  $
            --       Module Name      : $Workfile:   v_network_types.sql  $
            --       Date into PVCS   : $Date:   Jan 02 2019 11:44:16  $
            --       Date fetched Out : $Modtime:   Jan 02 2019 11:43:56  $
            --       Version          : $Revision:   1.4  $
            ------------------------------------------------------------------
            --   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
            -----------------------------------------------------------------
            --
            a.nlt_id,                        -- Network type ID (essentially, the network element type ID)
            a.nlt_nt_type,                   -- Unique code of the network element type
            a.nlt_descr,                     -- Network element type description
            external_unit_name length_units, -- Default length units of the network element type
			b.nlt_id datum_nlt_id            -- Underlying datum type ID
     FROM 
        (
        SELECT 
           nt_type,
           nt_descr,
           NULL gty_type,
		   NULL datum_type
        FROM 
           nm_types
        WHERE 
           nt_datum = 'Y'
        UNION ALL
        SELECT 
           ngt_nt_type,
           ngt_descr,
           nng_group_type,
		   nng_nt_type
        FROM 
           nm_nt_groupings
           INNER JOIN nm_group_types ON ngt_group_type = nng_group_type
        UNION ALL
        SELECT 
           nit_inv_type,
           nit_descr,
           NULL,
		   nin_nw_type
        FROM 
           nm_inv_types
           INNER JOIN nm_inv_nw ON nit_inv_type = nin_nit_inv_code
        WHERE 
           nit_linear = 'Y'
        )
        INNER JOIN nm_linear_types a ON a.nlt_nt_type = nt_type AND NVL (nlt_gty_type, '^%&*') = NVL (gty_type, '^%&*')
        INNER JOIN lb_units ON exor_unit_id = a.nlt_units
		LEFT OUTER JOIN nm_linear_types b ON b.nlt_nt_type = datum_type
     ORDER BY 
        a.nlt_seq_no
/
