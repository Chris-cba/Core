CREATE OR REPLACE FORCE VIEW NM_THEME_DETAILS_V
(
  NTDV_NTH_THEME_ID
, NTDV_NTH_THEME_NAME
, NTDV_NTH_TABLE_NAME
, NTDV_NTH_PK_COLUMN
, NTDV_NTH_FEATURE_TABLE
, NTDV_NTH_FEATURE_PK_COLUMN
, NTDV_NTH_FEATURE_SHAPE_COLUMN
, NTDV_NTH_HPR_PRODUCT
, NTDV_THEME_TYPE
, NTDV_GATEWAY_TABLE
, NTDV_GATEWAY_PK
) AS
  SELECT 
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/views/nm_theme_details_v.vw-arc   3.1   Jul 04 2013 11:35:12   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_theme_details_v.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:35:12  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:28:46  $
--       PVCS Version     : $Revision:   3.1  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
         "NTDV_NTH_THEME_ID"
       , "NTDV_NTH_THEME_NAME"
       , "NTDV_NTH_TABLE_NAME"
       , "NTDV_NTH_PK_COLUMN"
       , "NTDV_NTH_FEATURE_TABLE"
       , "NTDV_NTH_FEATURE_PK_COLUMN"
       , "NTDV_NTH_FEATURE_SHAPE_COLUMN"
       , "NTDV_NTH_HPR_PRODUCT"
       , "NTDV_THEME_TYPE"
       , "NTDV_GATEWAY_TABLE"
       , "NTDV_GATEWAY_PK"
    FROM (WITH all_data AS
                 (SELECT nth_theme_id
                       , nth_theme_name
                       , nth_table_name
                       , nth_pk_column
                       , nth_feature_table
                       , nth_feature_pk_column
                       , nth_feature_shape_column
                       , nth_hpr_product
                       , CASE
                           WHEN nith_nit_id IS NOT NULL
                           THEN
                             'Asset Theme'
                           WHEN nnth_nlt_id IS NOT NULL
                           THEN
                             'Linear Network Theme'
                           WHEN nath_nat_id IS NOT NULL
                           THEN
                             'Area Network Theme'
                           ELSE
                             hpr_product_name ||
                             ' theme'
                         END
                           theme_type
                       , nit_table_name
                       , nit_foreign_pk_column
                    FROM nm_themes_all
                       , nm_inv_themes
                       , nm_nw_themes
                       , nm_area_themes
                       , hig_products
                       , nm_inv_types
                   WHERE nith_nth_theme_id(+) = nth_theme_id
                     AND nnth_nth_theme_id(+) = nth_theme_id
                     AND nath_nth_theme_id(+) = nth_theme_id
                     AND nith_nit_id = nit_inv_type(+)
                     AND nth_hpr_product = hpr_product 
                                                      )
          SELECT UNIQUE nth_theme_id ntdv_nth_theme_id
                      , nth_theme_name ntdv_nth_theme_name
                      , nth_table_name ntdv_nth_table_name
                      , nth_pk_column ntdv_nth_pk_column
                      , nth_feature_table ntdv_nth_feature_table
                      , nth_feature_pk_column ntdv_nth_feature_pk_column
                      , nth_feature_shape_column ntdv_nth_feature_shape_column
                      , nth_hpr_product ntdv_nth_hpr_product
                      , theme_type ntdv_theme_type
                      --
                      , CASE
                          WHEN theme_type = 'Asset Theme'
                          THEN
                            DECODE ( nit_table_name, NULL, 'NM_INV_ITEMS', nit_table_name )
                          WHEN ( theme_type = 'Linear Network Theme'
                             OR  theme_type = 'Area Network Theme' )
                          THEN
                            'NM_ELEMENTS'
                          ELSE
                            nth_table_name
                        END
                          ntdv_gateway_table
                      --
                      , CASE
                          WHEN theme_type = 'Asset Theme'
                          THEN
                            DECODE ( nit_foreign_pk_column, NULL, 'IIT_NE_ID', nit_foreign_pk_column )
                          WHEN ( theme_type = 'Linear Network Theme'
                             OR  theme_type = 'Area Network Theme' )
                          THEN
                            'NE_ID'
                          ELSE
                            nth_pk_column
                        END
                          ntdv_gateway_pk
            --
            FROM all_data);
/
