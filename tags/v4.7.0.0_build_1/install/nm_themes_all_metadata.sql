--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_themes_all_metadata.sql	1.3 02/01/06
--       Module Name      : nm_themes_all_metadata.sql
--       Date into SCCS   : 06/02/01 15:22:41
--       Date fetched Out : 07/06/13 13:57:16
--       SCCS Version     : 1.3
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
--
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
--
--
-- MERGE_RESULTS
--
   INSERT INTO nm_themes_all
            (nth_theme_id
            ,nth_theme_name
            ,nth_table_name
            ,nth_where
            ,nth_pk_column
            ,nth_label_column
            ,nth_rse_table_name
            ,nth_rse_fk_column
            ,nth_st_chain_column
            ,nth_end_chain_column
            ,nth_x_column
            ,nth_y_column
            ,nth_offset_field
            ,nth_feature_table
            ,nth_feature_pk_column
            ,nth_feature_fk_column
            ,nth_xsp_column
            ,nth_feature_shape_column
            ,nth_hpr_product
            ,nth_location_updatable
            ,nth_theme_type
            ,nth_dependency
            ,nth_storage
            ,nth_update_on_edit
            ,nth_use_history
            ,nth_start_date_column
            ,nth_end_date_column
            ,nth_base_table_theme
            ,nth_sequence_name
            ,nth_snap_to_theme
            ,nth_lref_mandatory
            ,nth_tolerance
            ,nth_tol_units
            ,nth_dynamic_theme
            )
     SELECT nth_theme_id_seq.NEXTVAL
            , 'MERGE_RESULTS'
            , 'NM_MRG_QUERY_RESULTS'
            , NULL
            , 'NQR_MRG_JOB_ID'
            , 'NQR_SOURCE'
            , 'NM_ELEMENTS'
            , NULL
            , NULL
            , NULL
            , NULL
            , NULL
            , NULL
            , 'NM_MRG_GEOMETRY'
            , 'NMG_ID'
            , 'NMG_ID'
            , NULL
            , 'NMG_GEOMETRY'
            , 'NET'
            , 'N'
            , 'SDO'
            , 'D'
            , 'S'
            , 'N'
            , 'N'
            , NULL
            , NULL
            , NULL
            , NULL
            , 'N'
            , 'N'
            , 10
            , 1
            , 'Y'
   FROM DUAL
   WHERE NOT EXISTS (SELECT 1
                     FROM   nm_themes_all
                     WHERE  nth_theme_name	='MERGE_RESULTS');
--
--
--

-- new themes above here

COMMIT
/


