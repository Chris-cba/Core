CREATE OR REPLACE VIEW v_network_elements
(
   lb_object_type,              -- External ID of linearly locatable asset type
   nlt_id,                      -- Network type ID (essentially, the network element type ID)
   ne_id,                       -- ID of a network element
   ne_unique,                   -- Name of the network element
   ne_descr,                    -- Description of the network element
   nt_type,                     -- Unique code of the network element type
   nt_descr,                    -- Network element type description
   length_unit_id,              -- Default length units of the network element type
   min_m,                       -- Minimum measure along network element in default length units
   max_m                        -- Maximum measure along network element in default length units
)
AS
   -------------------------------------------------------------------------
   --   PVCS Identifiers :-
   --       PVCS id          : $Header:   //new_vm_latest/archives/lb/admin/eB_interface/v_network_elements.sql-arc   1.0   Oct 19 2015 11:42:18   Rob.Coupe  $
   --       Module Name      : $Workfile:   v_network_elements.sql  $
   --       Date into PVCS   : $Date:   Oct 19 2015 11:42:18  $
   --       Date fetched Out : $Modtime:   Oct 19 2015 11:40:50  $
   --       Version          : $Revision:   1.0  $
   ------------------------------------------------------------------
   --   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   -----------------------------------------------------------------
   --
   SELECT lb_object_type,
          nlt_id,
          ne_id,
          ne_unique,
          ne_descr,
          b.nt_type,
          b.nt_descr,
          b.external_unit_id,
          CASE ne_type
             WHEN 'S'
             THEN
                0
             WHEN 'G'
             THEN
                (SELECT MIN (nm_slk)
                   FROM nm_members
                  WHERE nm_ne_id_in = ne_id)
          END,
          CASE ne_type
             WHEN 'S'
             THEN
                ne_length
             WHEN 'G'
             THEN
                (SELECT MAX (nm_end_slk)
                   FROM nm_members
                  WHERE nm_ne_id_in = ne_id)
          END
     FROM nm_elements a,
          (WITH inv_nw
                AS (SELECT *
                      FROM nm_inv_nw
                           INNER JOIN lb_types
                              ON lb_exor_inv_type = nin_nit_inv_code
                           INNER JOIN v_nm_nlt_data ON nin_nw_type = nt_type)
           SELECT lb_object_type,
                  nlt_id,
                  nt_type,
                  gty_type,
                  nt_unique,
                  nt_descr,
                  external_unit_id
             FROM inv_nw INNER JOIN lb_units ON exor_unit_id = nlt_units
           UNION
           SELECT lb_object_type,
                  g.nlt_id,
                  g.nt_type,
                  g.gty_type,
                  g.nt_unique,
                  g.nt_descr,
                  external_unit_id
             FROM inv_nw i
                  INNER JOIN lb_units ON exor_unit_id = i.nlt_units
                  INNER JOIN nm_nt_groupings ON nng_nt_type = nin_nw_type
                  INNER JOIN v_nm_nlt_data g ON g.gty_type = nng_group_type
                  INNER JOIN nm_group_types
                     ON ngt_group_type = nng_group_type) b
    WHERE     ne_nt_type = b.nt_type
          AND NVL (ne_gty_group_type, '£$%^') = NVL (gty_type, '£$%^')
/
