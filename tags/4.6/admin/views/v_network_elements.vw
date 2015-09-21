CREATE OR REPLACE VIEW v_network_elements
( 
   lb_object_type, -- External ID of linearly locatable asset type
   nlt_id,         -- Network type ID (essentially, the network element type ID)
   ne_id,          -- ID of a network element
   ne_unique,      -- Name of the network element
   ne_descr,       -- Description of the network element
   nt_type,        -- Unique code of the network element type
   nt_descr,       -- Network element type description
   un_unit_name,   -- Default length units of the network element type
   min_m,          -- Minimum measure along network element in default length units
   max_m           -- Maximum measure along network element in default length units
)
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--       PVCS id          : $Header:   //new_vm_latest/archives/lb/admin/views/v_network_elements.vw-arc   1.0   Sep 21 2015 11:18:32   Rob.Coupe  $
--       Module Name      : $Workfile:   v_network_elements.vw  $
--       Date into PVCS   : $Date:   Sep 21 2015 11:18:32  $
--       Date fetched Out : $Modtime:   Sep 21 2015 11:17:52  $
--       Version          : $Revision:   1.0  $
------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------
--

SELECT lb_object_type, nlt_id, ne_id, ne_unique, ne_descr, b.nt_type, b.nt_descr, b.un_unit_name,
CASE ne_type
  WHEN 'S' THEN 0
  WHEN 'G' THEN (SELECT MIN(nm_slk) FROM nm_members WHERE nm_ne_id_in = ne_id )
end,
case ne_type
  WHEN 'S' THEN ne_length
  WHEN 'G' THEN (SELECT MAX(nm_end_slk) FROM nm_members WHERE nm_ne_id_in = ne_id )
END
FROM    
nm_elements a, (
WITH inv_nw
        AS (SELECT *
              FROM nm_inv_nw, lb_types, v_nm_nlt_data
             WHERE     lb_exor_inv_type = nin_nit_inv_code
                   AND nin_nw_type = nt_type)
   SELECT lb_object_type,
          nlt_id,
          nt_type,
          gty_type,
          nt_unique,
          nt_descr,
          --       nt_type,
          --       nin_nit_inv_code,
          --       nin_loc_mandatory,
          --       nlt_units,
          un_unit_name                                   
          --       un_format_mask
     FROM inv_nw
   UNION
   SELECT lb_object_type,
          g.nlt_id,
          g.nt_type,
          g.gty_type,
          g.nt_unique,
          g.nt_descr,
          --       g.nt_type,
          --       nin_nit_inv_code,
          --       nin_loc_mandatory,
          --       g.nlt_units,
          g.un_unit_name
          --       g.un_format_mask
     FROM inv_nw i,
          nm_nt_groupings,
          v_nm_nlt_data g,
          nm_group_types
    WHERE     nng_nt_type = nin_nw_type
          AND ngt_group_type = nng_group_type
          AND nng_group_type = g.gty_type ) b
WHERE ne_nt_type = b.nt_type
AND NVL(ne_gty_group_type, '£$%^') = NVL(gty_type, '£$%^')           
/

comment on table V_NETWORK_ELEMENTS is 'A view to return linear element information and length for use in LRS';
   

comment on column V_NETWORK_ELEMENTS.lb_object_type is 'External ID of linearly locatable asset type';
comment on column V_NETWORK_ELEMENTS.nlt_id is 'Network type ID (essentially, the network element type ID)';
comment on column V_NETWORK_ELEMENTS.ne_id is 'ID of a network element';
comment on column V_NETWORK_ELEMENTS.ne_unique is 'Name of the network element';
comment on column V_NETWORK_ELEMENTS.ne_descr is 'Description of the network element';
comment on column V_NETWORK_ELEMENTS.nt_type is 'Unique code of the network element type';
comment on column V_NETWORK_ELEMENTS.nt_descr is 'Network element type description';
comment on column V_NETWORK_ELEMENTS.un_unit_name is 'Default length units of the network element type';
comment on column V_NETWORK_ELEMENTS.min_m is 'Minimum measure along network element in default length units';
comment on column V_NETWORK_ELEMENTS.max_m  is 'Maximum measure along network element in default length units';
