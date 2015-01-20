--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/install/lb_views.sql-arc   1.2   Jan 20 2015 15:19:48   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_views.sql  $
--       Date into PVCS   : $Date:   Jan 20 2015 15:19:48  $
--       Date fetched Out : $Modtime:   Jan 20 2015 15:19:08  $
--       PVCS Version     : $Revision:   1.2  $
--
--   Author : R.A. Coupe
--
--   View definition script for interim install of Location Bridge
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--

CREATE OR REPLACE VIEW v_nm_nlt_data
AS
   WITH nlt
        AS (SELECT d.*,
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
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/install/lb_views.sql-arc   1.2   Jan 20 2015 15:19:48   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_views.sql  $
--       Date into PVCS   : $Date:   Jan 20 2015 15:19:48  $
--       Date fetched Out : $Modtime:   Jan 20 2015 15:19:08  $
--       PVCS Version     : $Revision:   1.2  $
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
               WHERE NVL (SYS_CONTEXT ('NM3SQL', 'NLT_DATA_INV_TYPE'),
                          nin_nit_inv_code) = nin_nit_inv_code)
/

CREATE OR REPLACE VIEW v_lb_networkTypes
AS
   WITH nlt
        AS (SELECT d.*,
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
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/install/lb_views.sql-arc   1.2   Jan 20 2015 15:19:48   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_views.sql  $
--       Date into PVCS   : $Date:   Jan 20 2015 15:19:48  $
--       Date fetched Out : $Modtime:   Jan 20 2015 15:19:08  $
--       PVCS Version     : $Revision:   1.2  $
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
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/install/lb_views.sql-arc   1.2   Jan 20 2015 15:19:48   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_views.sql  $
--       Date into PVCS   : $Date:   Jan 20 2015 15:19:48  $
--       Date fetched Out : $Modtime:   Jan 20 2015 15:19:08  $
--       PVCS Version     : $Revision:   1.2  $
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



create or replace view v_nm_nlt_refnts as
select 
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/install/lb_views.sql-arc   1.2   Jan 20 2015 15:19:48   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_views.sql  $
--       Date into PVCS   : $Date:   Jan 20 2015 15:19:48  $
--       Date fetched Out : $Modtime:   Jan 20 2015 15:19:08  $
--       PVCS Version     : $Revision:   1.2  $
--
--   Author : R.A. Coupe
--
--   View definition script for interim install of Location Bridge
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--
ne_id, ne_unique, ne_descr, 
t.* from nm_elements, v_nm_nlt_data t
where nlt_g_i_d in ('G', 'D')
and ne_nt_type = nt_type
and nvl(gty_type, '^%&$') = nvl( ne_gty_group_type, '^%&$')
and nvl(sys_context('NM3SQL','NLT_DATA_NLT_ID'), nlt_id ) = nlt_id 
and ne_unique like nvl(sys_context('NM3SQL','NLT_DATA_UNIQUE'), '%')
union all
select iit_ne_id, iit_primary_key, iit_descr, 
t.* from nm_inv_items, v_nm_nlt_data t
where nlt_g_i_d = 'I'
and iit_inv_type = nt_type
and gty_type is null
and nvl(sys_context('NM3SQL','NLT_DATA_NLT_ID'), nlt_id ) = nlt_id
and iit_primary_key like nvl(sys_context('NM3SQL','NLT_DATA_UNIQUE'), '%' ) 
/


create or replace view v_lb_nlt_refnts as
select 
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/install/lb_views.sql-arc   1.2   Jan 20 2015 15:19:48   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_views.sql  $
--       Date into PVCS   : $Date:   Jan 20 2015 15:19:48  $
--       Date fetched Out : $Modtime:   Jan 20 2015 15:19:08  $
--       PVCS Version     : $Revision:   1.2  $
--
--   Author : R.A. Coupe
--
--   View definition script for interim install of Location Bridge
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--
nlt_id, ne_id, ne_unique, ne_descr, nt_type, nt_descr,un_unit_name 
from v_lb_networkTypes t, nm_elements
where nlt_g_i_d in ('G', 'D')
and ne_nt_type = nt_type
and nvl(gty_type, '^%&$') = nvl( ne_gty_group_type, '^%&$')
and nvl(sys_context('NM3SQL','NLT_DATA_NLT_ID'), nlt_id ) = nlt_id 
and ne_unique like nvl(sys_context('NM3SQL','NLT_DATA_UNIQUE'), '%')
union all
select nlt_id, iit_ne_id, iit_primary_key, iit_descr, nt_type, nt_descr,un_unit_name 
from v_lb_networkTypes t, nm_inv_items
where nlt_g_i_d = 'I'
and iit_inv_type = nt_type
and gty_type is null
and nvl(sys_context('NM3SQL','NLT_DATA_NLT_ID'), nlt_id ) = nlt_id
and iit_primary_key like nvl(sys_context('NM3SQL','NLT_DATA_UNIQUE'), '%' ) 
/


CREATE OR REPLACE FORCE VIEW V_NM_NLT_MEASURES
(
   NE_ID,
   NE_UNIQUE,
   NE_DESCR,
   START_MEASURE,
   END_MEASURE,
   UNIT_NAME
)
AS
   SELECT 
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/install/lb_views.sql-arc   1.2   Jan 20 2015 15:19:48   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_views.sql  $
--       Date into PVCS   : $Date:   Jan 20 2015 15:19:48  $
--       Date fetched Out : $Modtime:   Jan 20 2015 15:19:08  $
--       PVCS Version     : $Revision:   1.2  $
--
--   Author : R.A. Coupe
--
--   View definition script for interim install of Location Bridge
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--
          ne_id,
          ne_unique,
          ne_descr,
          CASE NVL (ne_length, -999)
             WHEN -999
             THEN
                (SELECT MIN (nm_slk)
                   FROM nm_members
                  WHERE nm_ne_id_in = ne_id)
             ELSE
                0
          END
             start_measure,
          CASE NVL (ne_length, -999)
             WHEN -999
             THEN
                (SELECT MAX (nm_end_slk)
                   FROM nm_members
                  WHERE nm_ne_id_in = ne_id)
             ELSE
                ne_length
          END
             end_measure,
          un_unit_name
     FROM nm_elements, v_lb_networktypes
    WHERE     ne_id = TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'NLT_NE_ID'))
          AND ne_nt_type = nt_type
          AND NVL (ne_gty_group_type, '£$%^') = NVL (gty_type, '£$%^')
          AND nlt_g_i_d != 'I'
   UNION ALL
   SELECT iit_ne_id,
          iit_primary_key,
          iit_descr,
          (SELECT MIN (nm_slk)
             FROM nm_members
            WHERE nm_ne_id_in = iit_ne_id),
          (SELECT MAX (nm_end_slk)
             FROM nm_members
            WHERE nm_ne_id_in = iit_ne_id),
          un_unit_name
     FROM nm_inv_items, v_lb_networktypes
    WHERE     iit_ne_id = TO_NUMBER (SYS_CONTEXT ('NM3SQL', 'NLT_NE_ID'))
          AND nt_type = iit_inv_type
          AND gty_type IS NULL
          AND nlt_g_i_d = 'I'
/          

DROP VIEW NM_ASSET_LOCATIONS;

/* Formatted on 26/08/2014 22:32:49 (QP5 v5.252.13127.32867) */
CREATE OR REPLACE FORCE VIEW NM_ASSET_LOCATIONS
(
   NAL_ID,
   NAL_NIT_TYPE,
   NAL_ASSET_ID,
   NAL_DESCR,
   NAL_JXP,
   NAL_PRIMARY,
   NAL_START_DATE,
   NAL_END_DATE,
   NAL_SECURITY_KEY,
   NAL_DATE_CREATED,
   NAL_DATE_MODIFIED,
   NAL_CREATED_BY,
   NAL_MODIFIED_BY
)
AS
   SELECT 
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/install/lb_views.sql-arc   1.2   Jan 20 2015 15:19:48   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_views.sql  $
--       Date into PVCS   : $Date:   Jan 20 2015 15:19:48  $
--       Date fetched Out : $Modtime:   Jan 20 2015 15:19:08  $
--       PVCS Version     : $Revision:   1.2  $
--
--   Author : R.A. Coupe
--
--   View definition script for interim install of Location Bridge
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--
          "NAL_ID",
          "NAL_NIT_TYPE",
          "NAL_ASSET_ID",
          "NAL_DESCR",
          "NAL_JXP",
          "NAL_PRIMARY",
          "NAL_START_DATE",
          "NAL_END_DATE",
          "NAL_SECURITY_KEY",
          "NAL_DATE_CREATED",
          "NAL_DATE_MODIFIED",
          "NAL_CREATED_BY",
          "NAL_MODIFIED_BY"
     FROM nm_asset_locations_all
    WHERE     nal_start_date <=
                 TO_DATE (SYS_CONTEXT ('NM3CORE', 'EFFECTIVE_DATE'),
                          'DD-MON-YYYY')
          AND NVL (nal_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >
                 TO_DATE (SYS_CONTEXT ('NM3CORE', 'EFFECTIVE_DATE'),
                          'DD-MON-YYYY')
/



DROP VIEW NM_LOCATIONS
/

/* Formatted on 26/08/2014 22:35:50 (QP5 v5.252.13127.32867) */
CREATE OR REPLACE FORCE VIEW NM_LOCATIONS
(
   NM_NE_ID_OF,
   NM_LOC_ID,
   NM_OBJ_TYPE,
   NM_NE_ID_IN,
   NM_BEGIN_MP,
   NM_START_DATE,
   NM_END_DATE,
   NM_END_MP,
   NM_TYPE,
   NM_SLK,
   NM_DIR_FLAG,
   NM_SECURITY_ID,
   NM_SEQ_NO,
   NM_SEG_NO,
   NM_TRUE,
   NM_END_SLK,
   NM_END_TRUE,
   NM_X_SECT_ST,
   NM_OFFSET_ST,
   NM_UNIQUE_PRIMARY,
   NM_PRIMARY,
   NM_STATUS,
   TRANSACTION_ID,
   NM_DATE_CREATED,
   NM_DATE_MODIFIED,
   NM_MODIFIED_BY,
   NM_CREATED_BY,
   NM_X_SECT_END,
   NM_OFFSET_END,
   NM_FACTOR
)
AS
   SELECT 
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/install/lb_views.sql-arc   1.2   Jan 20 2015 15:19:48   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_views.sql  $
--       Date into PVCS   : $Date:   Jan 20 2015 15:19:48  $
--       Date fetched Out : $Modtime:   Jan 20 2015 15:19:08  $
--       PVCS Version     : $Revision:   1.2  $
--
--   Author : R.A. Coupe
--
--   View definition script for interim install of Location Bridge
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--
          "NM_NE_ID_OF",
          "NM_LOC_ID",
          "NM_OBJ_TYPE",
          "NM_NE_ID_IN",
          "NM_BEGIN_MP",
          "NM_START_DATE",
          "NM_END_DATE",
          "NM_END_MP",
          "NM_TYPE",
          "NM_SLK",
          "NM_DIR_FLAG",
          "NM_SECURITY_ID",
          "NM_SEQ_NO",
          "NM_SEG_NO",
          "NM_TRUE",
          "NM_END_SLK",
          "NM_END_TRUE",
          "NM_X_SECT_ST",
          "NM_OFFSET_ST",
          "NM_UNIQUE_PRIMARY",
          "NM_PRIMARY",
          "NM_STATUS",
          "TRANSACTION_ID",
          "NM_DATE_CREATED",
          "NM_DATE_MODIFIED",
          "NM_MODIFIED_BY",
          "NM_CREATED_BY",
          "NM_X_SECT_END",
          "NM_OFFSET_END",
          "NM_FACTOR"
     FROM nm_locations_all
    WHERE     nm_start_date <=
                 TO_DATE (SYS_CONTEXT ('NM3CORE', 'EFFECTIVE_DATE'),
                          'DD-MON-YYYY')
          AND NVL (nm_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >
                 TO_DATE (SYS_CONTEXT ('NM3CORE', 'EFFECTIVE_DATE'),
                          'DD-MON-YYYY')
/                          

CREATE OR REPLACE VIEW v_lb_inv_nlt_data
(
   AssetType,
   NetworkTypeId,
   NetworkTypeName,
   NetworkTypeDescr,
   UnitName
)
AS
 WITH inv_nw
        AS (SELECT *
              FROM nm_inv_nw, lb_types, V_NM_NLT_DATA
             WHERE     lb_exor_inv_type = nin_nit_inv_code
                   AND nin_nw_type = nt_type)
   SELECT 
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/install/lb_views.sql-arc   1.2   Jan 20 2015 15:19:48   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_views.sql  $
--       Date into PVCS   : $Date:   Jan 20 2015 15:19:48  $
--       Date fetched Out : $Modtime:   Jan 20 2015 15:19:08  $
--       PVCS Version     : $Revision:   1.2  $
--
--   Author : R.A. Coupe
--
--   View definition script for interim install of Location Bridge
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--  
          lb_object_type, nlt_id, 
          nt_unique, nt_descr,
   --       nt_type,
                                  --       nin_nit_inv_code,
                                  --       nin_loc_mandatory,
                                  --       nlt_units,
                                  un_unit_name --     un_format_mask
   FROM inv_nw
   UNION
   SELECT lb_object_type, g.nlt_id, 
          g.nt_unique, g.nt_descr,
   --       g.nt_type,
                                    --       nin_nit_inv_code,
                                    --       nin_loc_mandatory,
                                    --       g.nlt_units,
                                    g.un_unit_name
     --     g.un_format_mask
     FROM inv_nw i,
          nm_nt_groupings,
          V_NM_NLT_DATA g,
          nm_group_types
    WHERE     nng_nt_type = nin_nw_type
          AND ngt_group_type = nng_group_type
          AND nng_group_type = g.gty_type
/

create or replace view v_lb_xsp_list (XSP, XSP_DESCR) as
           SELECT                   /* +INDEX( e NE_PK) +CARDINALITY(t 10) */
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/install/lb_views.sql-arc   1.2   Jan 20 2015 15:19:48   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_views.sql  $
--       Date into PVCS   : $Date:   Jan 20 2015 15:19:48  $
--       Date fetched Out : $Modtime:   Jan 20 2015 15:19:08  $
--       PVCS Version     : $Revision:   1.2  $
--
--   Author : R.A. Coupe
--
--   View definition script for interim install of Location Bridge
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--
		   DISTINCT xsr_x_sect_value XSP, xsr_descr XSP_DESCR
              FROM nm_elements e,
                   nm_xsp_restraints,
                   TABLE (
                      get_lb_rpt_d_tab (LB_RPT_TAB (LB_RPt (to_number(sys_context('NM3SQL', 'NLT_NE_ID')), --NetworkElementID,
                                                            to_number(sys_context('NM3SQL', 'NLT_DATA_NLT_ID' )), --NetworkTypeId,
                                                            NULL,
                                                            NULL,
                                                            NULL,
                                                            NULL,
                                                            1,
                                                            to_number(sys_context('NMSQL', 'START_MEASURE' )), --l_startM,
                                                            to_number(sys_context('NMSQL', 'END_MEASURE' )),  --l_endM,
                                                            NULL)))) t
             WHERE     ne_sub_class = xsr_scl_class
                   AND xsr_ity_inv_code = sys_context( 'NM3SQL', 'NLT_DATA_INV_TYPE')
                   AND xsr_nw_type = ne_nt_type
                   AND ne_id = t.refnt
            UNION
            SELECT /*+ INDEX(m NM_OBJ_TYPE_NE_ID_OF_IND) CARDINALITY(t 10)  */
                   DISTINCT xsr_x_sect_value, xsr_descr
              FROM nm_elements e,
                   nm_members m,
                   nm_xsp_restraints,
                   TABLE (
                     get_lb_rpt_d_tab (LB_RPT_TAB (LB_RPt (to_number(sys_context('NM3SQL', 'NLT_NE_ID')), --NetworkElementID,
                                                            to_number(sys_context('NM3SQL', 'NLT_DATA_NLT_ID' )), --NetworkTypeId,
                                                            NULL,
                                                            NULL,
                                                            NULL,
                                                            NULL,
                                                            1,
                                                            to_number(sys_context('NMSQL', 'START_MEASURE' )), --l_startM,
                                                            to_number(sys_context('NMSQL', 'END_MEASURE' )),  --l_endM,
                                                            NULL)))) t
             WHERE     nm_ne_id_of = refnt
                   AND nm_ne_id_in = ne_id
                   AND ne_sub_class = xsr_scl_class
                   AND xsr_ity_inv_code = sys_context( 'NM3SQL', 'NLT_DATA_INV_TYPE')
                   AND xsr_nw_type = ne_nt_type
            UNION
            SELECT                   /* +INDEX( e NE_PK) +CARDINALITY(t 10) */
                   DISTINCT xsr_x_sect_value XSP, xsr_descr XSP_DESCR
              FROM nm_elements e, nm_xsp_restraints
             WHERE     ne_sub_class = xsr_scl_class
                   AND xsr_ity_inv_code = sys_context( 'NM3SQL', 'NLT_DATA_INV_TYPE')
                   AND xsr_nw_type = ne_nt_type
                   AND ne_id = to_number(sys_context('NM3SQL', 'NLT_NE_ID'))
            UNION ALL
            SELECT /*+ INDEX(m NM_OBJ_TYPE_NE_ID_OF_IND) CARDINALITY(t 10)  */
                   DISTINCT xsr_x_sect_value, xsr_descr
              FROM nm_elements e,
                   nm_members m,
                   nm_xsp_restraints
             WHERE     nm_ne_id_of = to_number(sys_context('NM3SQL', 'NLT_NE_ID'))
                   AND nm_ne_id_in = ne_id
                   AND ne_sub_class = xsr_scl_class
                   AND xsr_ity_inv_code = sys_context( 'NM3SQL', 'NLT_DATA_INV_TYPE')
                   AND xsr_nw_type = ne_nt_type
/                   
 


DECLARE
   TYPE object_name_type IS TABLE OF VARCHAR2 (123) INDEX BY binary_integer;
--
   TYPE object_type_type IS TABLE OF VARCHAR2 (23) INDEX BY binary_integer;
--
   l_object_name   object_name_type;
   l_object_type   object_type_type;
--
   PROCEDURE add_object (p_object_name VARCHAR2, p_object_type VARCHAR2)
   IS
      i   CONSTANT PLS_INTEGER := l_object_name.COUNT + 1;
   BEGIN
      l_object_name (i) := p_object_name;
      l_object_type (i) := p_object_type;
   END add_object;
BEGIN
   add_object ('V_NM_NLT_DATA', 'VIEW');
   add_object ('V_LB_NETWORKTYPES', 'VIEW');
   add_object ('V_NM_NLT_UNIT_CONVERSIONS', 'VIEW');
   add_object ('V_NM_NLT_REFNTS', 'VIEW');
   add_object ('V_LB_NLT_REFNTS', 'VIEW');
   add_object ('V_NM_NLT_MEASURES', 'VIEW');
   add_object ('NM_ASSET_LOCATIONS', 'VIEW');
   add_object ('NM_LOCATIONS', 'VIEW');
   add_object ('V_LB_INV_NLT_DATA', 'VIEW');
   add_object ('V_LB_XSP_LIST', 'VIEW');
--     
   FOR i IN 1 .. l_object_name.COUNT
   LOOP
      INSERT INTO lb_objects (object_name, object_type)
           VALUES (l_object_name (i), l_object_type (i));
   END LOOP;
END;
/


                      