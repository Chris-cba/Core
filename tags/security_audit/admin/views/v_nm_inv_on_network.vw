CREATE OR REPLACE FORCE VIEW V_NM_INV_ON_NETWORK
(
   NIT_INV_TYPE,
   NIT_TABLE_NAME,
   NIT_FOREIGN_PK_COLUMN,
   NIT_LR_NE_COLUMN_NAME,
   NIT_LR_ST_CHAIN,
   NIT_LR_END_CHAIN,
   NLT_ID,
   NLT_GTY_TYPE,
   NLT_NT_TYPE,
   NLT_G_I_D,
   NLT_UNITS,
   RPT_STRING
)
AS
   SELECT 
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_inv_on_network.vw-arc   1.2   Jan 02 2019 14:17:58   Chris.Baugh  $
--       Module Name      : $Workfile:   v_nm_inv_on_network.vw  $
--       Date into PVCS   : $Date:   Jan 02 2019 14:17:58  $
--       Date fetched Out : $Modtime:   Dec 07 2018 10:18:26  $
--       Version          : $Revision:   1.2  $
--------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
--------------------------------------------------------------------------
----
          nit_inv_type,
          nit_table_name,
          nit_foreign_pk_column,
          nit_lr_ne_column_name,
          nit_lr_st_chain,
          nit_lr_end_chain,
          nlt_id,
          nlt_gty_type,
          nlt_nt_type,
          nlt_g_i_d,
          nlt_units,
             'with nit as (select nit_inv_type, nit_table_name, nit_foreign_pk_column, nit_lr_ne_column_name, nit_lr_st_chain, nit_lr_end_chain, 
nlt_id, nlt_gty_type, nlt_nt_type, nlt_g_i_d, nlt_units
from nm_inv_types, nm_inv_nw, nm_linear_types where nit_table_name is not null
and nit_inv_type = nin_nit_inv_code
and nit_inv_type = '
          || ''''
          || nit_inv_type
          || ''''
          || ' and nlt_nt_type = nin_nw_type ) '
          || ' SELECT CAST (COLLECT (lb_rpt ('
          || nit_lr_ne_column_name
          || ', '
          || ' nlt_id, '
          || ' nit_inv_type, '
          || nit_foreign_pk_column
          || ', '
          || '1,'
          || '1,'
          || '1,'
          || nit_lr_st_chain
          || ', '
          || nit_lr_end_chain
          || ', nlt_units)) AS lb_rpt_tab) '
          || ' from nit, '
          || nit_table_name
             Rpt_string
     FROM nm_inv_types, nm_inv_nw, nm_linear_types
    WHERE                                         --nit_table_name is not null
          --and
          nit_inv_type = nin_nit_inv_code           --and nit_inv_type = 'DEF'
                                         AND nlt_nt_type = nin_nw_type
/
