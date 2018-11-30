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
   SELECT /*
          View definition to cater for query tool operating on the attributes of network elements be they the
          fixed column attributes of the NM_ELEMENTS table, the flexible attributes mapped through the NM_TYPE_COLUMNS
          or through the additional data types (NM_NW_AD_TYPES)
          */
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
