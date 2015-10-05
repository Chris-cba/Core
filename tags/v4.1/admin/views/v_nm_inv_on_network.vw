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
                                                      --   SCCS Identifiers :-
                                                                            --
                   --       sccsid           : @(#)nm_elements.vw 1.3 03/24/05
                                    --       Module Name      : nm_elements.vw
                                 --       Date into SCCS   : 05/03/24 16:15:06
                                 --       Date fetched Out : 07/06/13 17:08:05
                                               --       SCCS Version     : 1.3
                                                                            --
 -----------------------------------------------------------------------------
    --   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
 -----------------------------------------------------------------------------
                                                                            --   
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
