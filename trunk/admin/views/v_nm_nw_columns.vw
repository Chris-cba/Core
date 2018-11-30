CREATE OR REPLACE FORCE VIEW V_NM_NW_COLUMNS
(
   RN,
   NETWORK_TYPE,
   GROUP_TYPE,
   COLUMN_NAME,
   ATTRIB_SOURCE,
   SEQ_NO,
   COLUMN_PROMPT,
   FIELD_TYPE,
   FIELD_LENGTH,
   DEC_PLACES,
   FORMAT_MASK,
   LOV_QUERY
)
AS
   SELECT 
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/views/v_nm_nw_columns.vw-arc   1.1   Nov 30 2018 12:18:30   Rob.Coupe  $
--       Module Name      : $Workfile:   v_nm_nw_columns.vw  $
--       Date into PVCS   : $Date:   Nov 30 2018 12:18:30  $
--       Date fetched Out : $Modtime:   Nov 30 2018 12:18:10  $
--       PVCS Version     : $Revision:   1.1  $
--
--   Author : R.A. Coupe
--
--          View definition to cater for query tool operating on the attributes of network elements be they the
--          fixed column attributes of the NM_ELEMENTS table, the flexible attributes mapped through the NM_TYPE_COLUMNS
--          or through the additional data types (NM_NW_AD_TYPES)
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--   
         ROW_NUMBER ()
          OVER (
             ORDER BY
                CASE attrib_source
                   WHEN 'HC' THEN 'A'
                   WHEN 'TC' THEN 'B'
                   ELSE 'C' || attrib_source
                END,
                seq_no)
             rn,
          nt_type,
          ngt_group_type,
          column_name,
          attrib_source,
          seq_no,
          ntc_prompt,
          data_type,
          field_length,
          dec_places,
          format_mask,
          col_query
     FROM (SELECT nt_type,
                  ngt_group_type,
                  column_name,
                  'HC' attrib_source,
                  column_id seq_no,
                  CASE column_name
                     WHEN 'NE_NT_TYPE'
                     THEN
                        'SELECT NT_TYPE, NT_UNIQUE, NT_DESCR from NM_TYPES'
                     WHEN 'NE_ADMIN_UNIT'
                     THEN
                        'SELECT NAU_ADMIN_UNIT, NAU_UNIT_CODE, NAU_NAME from nm_admin_units'
                     WHEN 'NE_GTY_GROUP_TYPE'
                     THEN
                        'SELECT NGT_GROUP_TYPE, NGT_GROUP_TYPE, NGT_DESCR from nm_group_types'
                  END
                     col_query,
                  CASE column_name
                     WHEN 'NE_ID' THEN 'Element ID'
                     WHEN 'NE_UNIQUE' THEN 'Element Name'
                     WHEN 'NE_NT_TYPE' THEN 'Network Type'
                     WHEN 'NE_DESCR' THEN 'Element Description'
                     WHEN 'NE_LENGTH' THEN 'Element Length'
                     WHEN 'NE_ADMIN_UNIT' THEN 'Admin Unit'
                     WHEN 'NE_START_DATE' THEN 'Start Date'
                     WHEN 'NE_END_DATE' THEN 'End Date'
                     WHEN 'NE_GTY_GROUP_TYPE' THEN 'Group Type'
                     WHEN 'NE_SUB_CLASS' THEN 'Section/Sub-Class'
                     WHEN 'NE_NO_START' THEN 'Start Node'
                     WHEN 'NE_NO_END' THEN 'End Node'
                  END
                     ntc_prompt,
                  data_type,
                  field_length,
                  CASE data_type WHEN 'NUMBER' THEN 0 END dec_places,
                  CASE data_type WHEN 'DATE' THEN 'DD-MON-YYYY' END
                     format_mask
             FROM (SELECT nt_type,
                          ngt_group_type,
                          column_name,
                          column_id,
                          data_type,
                          CASE data_type
                             WHEN 'VARCHAR2' THEN data_length
                             WHEN 'NUMBER' THEN data_precision
                             WHEN 'DATE' THEN 11
                          END
                             field_length
                     FROM nm_types, nm_group_types, all_tab_columns
                    WHERE     owner =
                                 SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
                          AND table_name = 'NM_ELEMENTS_ALL'
                          AND nt_type = ngt_nt_type(+)
                          AND column_name IN ('NE_ID',
                                              'NE_UNIQUE',
                                              'NE_NT_TYPE',
                                              'NE_DESCR',
                                              'NE_LENGTH',
                                              'NE_ADMIN_UNIT',
                                              'NE_START_DATE',
                                              'NE_END_DATE',
                                              'NE_GTY_GROUP_TYPE',
                                              --                                              'NE_SUB_CLASS',
                                              'NE_NO_START',
                                              'NE_NO_END'))
           UNION ALL
           SELECT ntc_nt_type,
                  ngt_group_type,
                  ntc_column_name,
                  'TC' attrib_source,
                  ntc_seq_no,
                  CASE
                     WHEN ntc_domain IS NOT NULL
                     THEN
                           'select hco_code, hco_meaning, hco_meaning from hig_codes where hco_domain = '
                        || ''''
                        || ntc_domain
                        || ''''
                        || ' order by hco_seq'
                     ELSE
                        CASE
                           WHEN ntc_query IS NULL
                           THEN
                              CASE
                                 WHEN ntc_column_name = 'NE_SUB_CLASS'
                                 THEN
                                    'select 1, 2, 3 from dual'
                                 ELSE
                                    ntc_query
                              END
                        END
                  END
                     ntc_query,
                  ntc_prompt,
                  ntc_column_type,
                  ntc_str_length field_length,
                  CASE ntc_column_type WHEN 'NUMBER' THEN 0 ELSE NULL END
                     dec_places,
                  NULL format_mask
             FROM nm_type_columns, nm_group_types
            WHERE ntc_nt_type = ngt_nt_type(+) 
           UNION ALL
           SELECT nad_nt_type,
                  nad_gty_type,
                  ita_view_col_name,
                  ita_inv_type,
                  ita_disp_seq_no,
                  CASE
                     WHEN ita_id_domain IS NOT NULL
                     THEN
                           'select ial_value, ial_meaning, ial_seq from nm_inv_attri_lookup where ial_domain = '
                        || ''''
                        || ita_id_domain
                        || ''''
                        || ' order by ial_seq '
                     ELSE
                        ita_query
                  END
                     domain_query,
                  ita_scrn_text,
                  ita_format,
                  ita_fld_length,
                  ita_dec_places,
                  ita_format_mask
             FROM nm_inv_type_attribs,
                  nm_nw_ad_types,
                  nm_group_types,
                  nm_types
            WHERE     nad_nt_type = nt_type
                  AND nad_gty_type = ngt_group_type
                  AND ita_inv_type = nad_inv_type
                  AND nt_type = ngt_nt_type(+))
--order by case attrib_source when 'HC' then 'A' when 'TC' then 'B' else 'C'||attrib_source end, seq_no
/



comment on table v_nm_nw_columns is 'A view to provide all possible attributes of a network type and group type combination. Attributes are included from fixed and flexible column attributes,as well as primary AD data';

comment on  column v_nm_nw_columns.rn is 'An indicative order derived by the source of the attribute and the order of the attribute within that source';

comment on  column v_nm_nw_columns.network_type is 'The network type to which the list of attributes relate';

comment on  column v_nm_nw_columns.group_type is 'The network group type to which the list of attributes relate';

comment on  column v_nm_nw_columns.column_name is 'The column name of the attribute - this can be an NM_ELEMENTS column or an AD type';

comment on  column v_nm_nw_columns.attrib_source is 'An indicator of the source of the attribute  - HC is a hard-coded attribute from the NM_ELEMENTS table, TC is a flexible attribute configured as a type-column. If the attribute is from an AD type, the attrib_source points to the NM_NW_AD_TYPES.NAD_INV_TYPE';

comment on  column v_nm_nw_columns.seq_no is 'The sequence of the attribute within a source type - for example the sequence from NM_TYPE_COLUMNS or the column_id or the attribute sequence from NM_INV_TYPE_ATTRIBS';

comment on  column v_nm_nw_columns.column_prompt is 'The prompt for the column'; 

comment on  column v_nm_nw_columns.field_type is 'The type of the column - either NUMBER, VARCHAR2 or DATE';

comment on  column v_nm_nw_columns.field_length is 'The length of the attribute';

comment on  column v_nm_nw_columns.dec_places is 'The number of decimal places used in the attribute value - NULL for non numeric columns'; 

comment on  column v_nm_nw_columns.format_mask is 'The format mask of the attributefor date attributes';

comment on  column v_nm_nw_columns.lov_query is 'The list of available values for the attribute';


