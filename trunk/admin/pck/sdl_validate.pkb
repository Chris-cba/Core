CREATE OR REPLACE PACKAGE BODY sdl_validate
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sdl_validate.pkb-arc   1.24   Jan 19 2021 13:59:30   Vikas.Mhetre  $
    --       Module Name      : $Workfile:   sdl_validate.pkb  $
    --       Date into PVCS   : $Date:   Jan 19 2021 13:59:30  $
    --       Date fetched Out : $Modtime:   Jan 19 2021 13:30:46  $
    --       PVCS Version     : $Revision:   1.24  $
    --
    --   Author : R.A. Coupe
    --
    --   Package for handling validation of attributes in a load batch
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    -- The main purpose of this package is to handle the validation of all the defined attributes in a batch:
    -- Domain based checks
    -- FK based checks
    -- format checks

    g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.24  $';

    g_package_name   CONSTANT VARCHAR2 (30) := 'SDL_VALIDATE';

    -----------------------------------------------------------------------------
    --
    FUNCTION get_version
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN g_sccsid;
    END get_version;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION get_body_version
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN g_body_sccsid;
    END get_body_version;

    --
    -----------------------------------------------------------------------------
    --
    -- This procedure generates and executes a SQL insert string to log all load records in a batch which have domain-based columns with illegal values.
    --
    PROCEDURE validate_domain_columns (p_batch_id IN NUMBER);

    --
    --
    -----------------------------------------------------------------------------
    --
    -- This procedure generates and executes a SQL insert string to log all load records in a batch which have mandatory columns without a value
    --
    PROCEDURE validate_mandatory_columns (p_batch_id IN NUMBER);

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE validate_datum_domain_columns (p_batch_id       IN NUMBER,
                                             p_profile_id     IN NUMBER,
                                             p_profile_view   IN VARCHAR2);

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE validate_dtm_mand_columns (p_batch_id       IN NUMBER,
                                         p_profile_id     IN NUMBER,
                                         p_profile_view   IN VARCHAR2);

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE validate_dtm_column_len (p_batch_id       IN NUMBER,
                                       p_profile_id     IN NUMBER,
                                       p_profile_view   IN VARCHAR2);

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE update_batch_for_adjustment (p_batch_id IN INTEGER)
    IS
        CURSOR c_update IS
              SELECT 'SLD_COL_' || sam.sam_col_id     load_column_name,
                     sam.sam_id,
                     saar.saar_source_value,
                     saar.saar_adjust_to_value
                FROM sdl_attribute_mapping         sam,
                     sdl_attribute_adjustment_rules saar,
                     sdl_file_submissions          sfs
               WHERE     sam.sam_view_column_name =
                         saar.saar_target_attribute_name
                     AND sam.sam_sp_id = saar.saar_sp_id
                     AND sam.sam_sp_id = sfs.sfs_sp_id
                     AND sfs.sfs_sdh_id = saar.saar_sdh_id
                     AND sam.sam_sdh_id = saar.saar_sdh_id
                     AND (saar.saar_user_id = SYS_CONTEXT('NM3CORE', 'USER_ID')
                            OR saar.saar_user_id = -1)
                     AND EXISTS
                             (SELECT 1
                                FROM sdl_attribute_adjustment_audit saaa
                               WHERE saaa.saaa_sam_id = sam.sam_id
                                 AND saaa.saaa_saar_id = saar.saar_id
                                 AND saaa.saaa_sfs_id = sfs.sfs_id)
                     AND sfs.sfs_id = p_batch_id
            ORDER BY saar.saar_id;

        sql_str   VARCHAR2 (4000);
    BEGIN
        FOR r_update IN c_update
        LOOP
            sql_str :=
                   'UPDATE sdl_load_data '
                || 'SET '
                || r_update.load_column_name
                || ' = '
                || ''''
                || r_update.saar_adjust_to_value
                || ''''
                || ','
                || 'sld_adjustment_rule_applied = '
                || '''Y'''
                || ' WHERE sld_key IN (SELECT saaa.saaa_sld_key FROM sdl_attribute_adjustment_audit saaa WHERE saaa.saaa_sfs_id = '
                || p_batch_id
                || ' AND '
                || r_update.load_column_name
                || CASE
                      WHEN r_update.saar_source_value IS NULL THEN ' IS NULL '
                      ELSE ' = ''' || r_update.saar_source_value || ''''
                   END
                || ' AND saaa.saaa_sam_id = '
                || r_update.sam_id
                || ')'
                || ' AND sld_sfs_id = '
                || p_batch_id;

            EXECUTE IMMEDIATE sql_str;
        END LOOP;
    END update_batch_for_adjustment;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE validate_batch (p_batch_id IN NUMBER)
    IS
        meta_row        V_SDL_PROFILE_NW_TYPES%ROWTYPE;
        l_unit_factor   NUMBER;
        l_round         NUMBER;
        l_tol           NUMBER;
    BEGIN
        SELECT m.*
          INTO meta_row
          FROM V_SDL_PROFILE_NW_TYPES m, sdl_file_submissions
         WHERE sfs_id = p_batch_id AND sp_id = sfs_sp_id;

        nm_debug.delete_debug (TRUE);
        nm_debug.debug_on;
        nm_debug.debug (
               'Group unit = '
            || meta_row.PROFILE_GROUP_UNIT_ID
            || ' and datum unit = '
            || meta_row.DATUM_UNIT_ID);
        --
        l_tol :=
            nm3unit.get_tol_from_unit_mask (
                NVL (meta_row.PROFILE_GROUP_UNIT_ID, meta_row.DATUM_UNIT_ID));

        l_round := NM3UNIT.GET_ROUNDING (l_tol);

        SELECT conversion_factor
          INTO l_unit_factor
          FROM mdsys.sdo_dist_units
         WHERE sdo_unit = meta_row.datum_unit_name;

        --delete any existing data, this will include any datum validations

        DELETE FROM sdl_validation_results
              WHERE svr_sfs_id = p_batch_id;

        validate_domain_columns (p_batch_id);

        validate_mandatory_columns (p_batch_id);

        --The following procedure will try and make sense of the gtype of the geometry, set the type to a 3302/3306 and
        --will register any spatial related problems in the geometry such as measures not being incremental and having
        --duplicate vertices.

        set_working_geometry (p_batch_id, l_unit_factor, l_round);

        UPDATE sdl_load_data
           SET sld_status =
                   (SELECT CASE row_count
                               WHEN 0 THEN 'VALID'
                               ELSE 'INVALID'
                           END
                      FROM (SELECT COUNT (*)     row_count
                              FROM sdl_validation_results
                             WHERE     svr_sfs_id = p_batch_id
                                   AND svr_sld_key = sld_key))
         WHERE sld_sfs_id = p_batch_id;
    END validate_batch;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE validate_domain_columns (p_batch_id IN NUMBER)
    IS
        sql_str   VARCHAR2 (4000);
        max_id    NUMBER;
    BEGIN
        WITH
            domain_columns
            AS
                (SELECT sam_id,
                        sam_col_id,
                        'sld_col_' || sam_col_id     load_column_name,
                        sam_view_column_name,
                        domain
                   FROM (SELECT *
                           FROM v_nm_nw_columns,
                                sdl_attribute_mapping,
                                sdl_profiles,
                                sdl_file_submissions,
                                nm_linear_types,
                                sdl_destination_header
                          WHERE     sfs_id = p_batch_id
                                AND sfs_sp_id = sp_id
                                AND sdh_sp_id = sp_id
                                AND sam_sdh_id = sdh_id
                                AND sdh_id = sfs_sdh_id
                                AND nlt_id = sdh_nlt_id
                                AND sdh_destination_location = 'N'
                                AND sam_sp_id = sp_id
                                AND sam_ne_column_name = column_name
                                AND network_type = nlt_nt_type
                                AND nvl(group_type, '$%&*') = nvl(nlt_gty_type,  '$%&*')
                                AND domain IS NOT NULL))
        SELECT MAX (sam_id),
                  'insert into sdl_validation_results (svr_sfs_id, svr_sld_key, svr_validation_type, svr_sam_id, svr_column_name, svr_current_value, svr_status_code, svr_message) '
               || LISTAGG (
                         'select '
                      || p_batch_id
                      || ','
                      || 'sld_key'
                      || ','
                      || ''''
                      || 'D'
                      || ''''
                      || ','
                      || TO_CHAR (sam_id)
                      || ', '
                      || ''''
                      || sam_view_column_name
                      || ''''
                      || ','
                      || load_column_name
                      || ','
                      || ' -999, '
                      || ''''
                      || 'Domain '
                      || domain
                      || ' value '
                      || sam_view_column_name
                      || ' is invalid'
                      || ''''
                      || ' from sdl_load_data where sld_sfs_id = '
                      || TO_CHAR (p_batch_id)
                      || ' and not exists ( select 1 from hig_codes where hco_domain = '
                      || ''''
                      || domain
                      || ''''
                      || ' and hco_code = '
                      || load_column_name
                      || ')',
                      ' union all ')
                  WITHIN GROUP (ORDER BY sam_id)
          INTO max_id, sql_str
          FROM domain_columns;

        nm_debug.debug_on;
        nm_debug.debug (sql_str);

        IF max_id IS NOT NULL
        THEN
            EXECUTE IMMEDIATE sql_str;
        END IF;
    END validate_domain_columns;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE validate_mandatory_columns (p_batch_id IN NUMBER)
    IS
        sql_str   VARCHAR2 (4000);
        max_id    NUMBER;
    BEGIN
        WITH
            mandatory_columns
            AS
                (SELECT sam_id,
                        sam_col_id,
                        'sld_col_' || sam_col_id     load_column_name,
                        sam_view_column_name,
                        domain
                   FROM (SELECT *
                           FROM v_nm_nw_columns,
                                sdl_attribute_mapping,
                                sdl_profiles,
                                sdl_file_submissions,
                                nm_linear_types,
                                sdl_destination_header
                          WHERE     sfs_id = p_batch_id
                                AND sfs_sp_id = sp_id
                                AND sdh_sp_id = sp_id
                                AND sam_sdh_id = sdh_id
                                AND sdh_id = sfs_sdh_id
                                AND nlt_id = sdh_nlt_id
                                AND sdh_destination_location = 'N'
                                AND sam_sp_id = sp_id
                                AND sam_ne_column_name = column_name
                                AND network_type = nlt_nt_type
                                AND nvl(group_type, '$%&*') = nvl(nlt_gty_type,  '$%&*')
                                AND mandatory = 'Y'))
        SELECT MAX (sam_id),
                  'insert into sdl_validation_results (svr_sfs_id, svr_sld_key, svr_validation_type, svr_sam_id, svr_column_name, svr_current_value, svr_status_code, svr_message) '
               || LISTAGG (
                         'select '
                      || p_batch_id
                      || ','
                      || 'sld_key'
                      || ','
                      || ''''
                      || 'M'
                      || ''''
                      || ','
                      || TO_CHAR (sam_id)
                      || ', '
                      || ''''
                      || sam_view_column_name
                      || ''''
                      || ','
                      || load_column_name
                      || ','
                      || ' -999, '
                      || ''''
                      || 'Column is marked as mandatory but has no value '
                      || ''''
                      || ' from sdl_load_data where sld_sfs_id = '
                      || TO_CHAR (p_batch_id)
                      || ' and '
                      || load_column_name
                      || ' is null ',
                      ' union all ')
                  WITHIN GROUP (ORDER BY sam_id)
          INTO max_id, sql_str
          FROM mandatory_columns;

        nm_debug.debug_on;
        nm_debug.debug (sql_str);

        IF max_id IS NOT NULL
        THEN
            EXECUTE IMMEDIATE sql_str;
        END IF;
    END validate_mandatory_columns;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE validate_adjustment_rules (p_batch_id IN NUMBER)
    IS
        sql_str   VARCHAR2 (4000);
        max_id    NUMBER;
    BEGIN
        --   DELETE FROM sdl_attribute_adjustment_audit
        --        WHERE saaa_sfs_id = p_batch_id;

        WITH
            adjustment_rules
            AS
                (SELECT sam_id,
                        sam_col_id,
                        'sld_col_' || sam_col_id     load_column_name,
                        sam_view_column_name,
                        saar_id,
                        saar_source_value,
                        saar_adjust_to_value
                   FROM (  SELECT sam.sam_id,
                                  sam.sam_col_id,
                                  sam.sam_view_column_name,
                                  saar.saar_id,
                                  saar.saar_source_value,
                                  saar.saar_adjust_to_value
                             FROM sdl_attribute_mapping         sam,
                                  sdl_file_submissions          sfs,
                                  sdl_attribute_adjustment_rules saar
                            WHERE     sfs.sfs_id = p_batch_id
                                  AND sam.sam_sp_id = sfs.sfs_sp_id
                                  AND sam.sam_sp_id = saar.saar_sp_id
                                  AND sfs.sfs_sdh_id = saar.saar_sdh_id
                                  AND sam.sam_sdh_id = saar.saar_sdh_id
                                  AND sam.sam_view_column_name =
                                      saar.saar_target_attribute_name
                                  AND (saar.saar_user_id = SYS_CONTEXT('NM3CORE', 'USER_ID')
                                      OR saar.saar_user_id = -1)
                         ORDER BY saar.saar_id))
        SELECT MAX (sam_id),
                  'INSERT INTO sdl_attribute_adjustment_audit ( saaa_sld_key, saaa_sfs_id, saaa_saar_id, saaa_sam_id, saaa_original_value, saaa_adjusted_value) '
               || LISTAGG (
                         'SELECT '
                      || 'sld_key'
                      || ','
                      || p_batch_id
                      || ','
                      || saar_id
                      || ','
                      || sam_id
                      || ','
                      || ''''
                      || saar_source_value
                      || ''''
                      || ','
                      || ''''
                      || saar_adjust_to_value
                      || ''''
                      || ' FROM sdl_load_data WHERE sld_sfs_id = '
                      || TO_CHAR (p_batch_id)
                      || ' AND sld_key IN ( SELECT sld_key FROM sdl_load_data WHERE '
                      || load_column_name
                      || CASE
                             WHEN saar_source_value IS NULL THEN ' IS NULL '
                             ELSE ' = ''' || saar_source_value || ''''
                         END
                      || ')',
                      ' UNION ALL ')
                  WITHIN GROUP (ORDER BY sam_id)
          INTO max_id, sql_str
          FROM adjustment_rules;

        IF max_id IS NULL
        THEN
            nm_debug.debug ('No adjustment rules');
        ELSE
            nm_debug.debug_on;
            nm_debug.debug (sql_str);

            EXECUTE IMMEDIATE sql_str;

            update_batch_for_adjustment (p_batch_id);
        END IF;
    END validate_adjustment_rules;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE validate_profile (p_profile_id IN NUMBER)
    IS
        l_dummy      NUMBER := 0;
        l_nt_type    nm_types.nt_type%TYPE;
        l_meta_row   V_SDL_PROFILE_NW_TYPES%ROWTYPE;
    BEGIN
        BEGIN
            SELECT m.*
              INTO l_meta_row
              FROM V_SDL_PROFILE_NW_TYPES m, sdl_profiles p
             WHERE p.sp_id = p_profile_id AND p.sp_id = m.sp_id;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                raise_application_error (-20003,
                                         'No profile metadata exists');
        END;

        --first check the mandatory columns on the loaded data

        l_nt_type := l_meta_row.profile_nt_type;

        BEGIN
            SELECT 1
              INTO l_dummy
              FROM dba_tab_columns
             WHERE     owner = SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
                   AND table_name = 'NM_ELEMENTS_ALL'
                   AND nullable = 'N'
                   AND NOT EXISTS
                           (SELECT 1
                              FROM sdl_attribute_mapping
                             WHERE     sam_sp_id = p_profile_id
                                   AND column_name = sam_ne_column_name)
                   AND (   column_name NOT IN ('NE_ID', -- assigned in upload to main DB
                                               'NE_NT_TYPE', --defined by the template itself
                                               'NE_TYPE', -- we are only going to load datums (i.e. NE_TYPE = 'S', hard-coded inside the API
                                               'NE_DATE_CREATED',
                                               'NE_DATE_MODIFIED',
                                               'NE_MODIFIED_BY',
                                               'NE_CREATED_BY' -- handled by the trigger
                                                              )
                        OR     column_name = 'NE_UNIQUE'
                           AND EXISTS
                                   (SELECT 1
                                      FROM nm_types
                                     WHERE     nt_type = l_nt_type
                                           AND nt_pop_unique = 'N'))
                   AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;


        IF l_dummy != 0
        THEN
            raise_application_error (
                -20001,
                'Mandatory columns are not catered for in the load file profile');
        ELSE
            l_dummy := 0;

            -- now check to ensure that all the columns that make up the unique key when the

            BEGIN
                SELECT 1
                  INTO l_dummy
                  FROM dba_tab_columns, nm_type_columns
                 WHERE     owner =
                           SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
                       AND table_name = 'NM_ELEMENTS_ALL'
                       AND ntc_nt_type = l_nt_type
                       AND ntc_column_name = column_name
                       AND ntc_unique_seq IS NOT NULL
                       AND (    NOT EXISTS
                                    (SELECT 1
                                       FROM sdl_attribute_mapping
                                      WHERE     sam_sp_id = p_profile_id
                                            AND column_name =
                                                sam_ne_column_name)
                            AND (    ntc_default IS NOT NULL
                                 AND ntc_seq_name IS NOT NULL))
                       AND ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    NULL;
            END;
        END IF;

        --
        IF l_dummy != 0
        THEN
            raise_application_error (
                -20002,
                'Columns that are used to construct the unique key are not present in the profile attribute list');
        END IF;

        -- now check if the load data is a route and validate the columns on the datum if needed.

        IF l_meta_row.nlt_g_i_d = 'G'
        THEN
            l_nt_type := l_meta_row.datum_nt_type;

            BEGIN
                SELECT 1
                  INTO l_dummy
                  FROM dba_tab_columns
                 WHERE     owner =
                           SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
                       AND table_name = 'NM_ELEMENTS_ALL'
                       AND nullable = 'N'
                       AND NOT EXISTS
                               (SELECT 1
                                  FROM sdl_datum_attribute_mapping,
                                       nm_type_columns
                                 WHERE     sdam_profile_id = p_profile_id
                                       AND sdam_nw_type = ntc_nt_type
                                       AND ntc_nt_type = l_nt_type
                                       AND column_name = sdam_column_name)
                       AND column_name NOT IN ('NE_ID', -- assigned in upload to main DB
                                               'NE_NT_TYPE', --defined by the template itself
                                               --                                           'NE_ADMIN_UNIT', --we need to do something with this
                                               'NE_TYPE', -- we are only going to load datums (i.e. NE_TYPE = 'S', hard-coded inside the API
                                               'NE_DATE_CREATED',
                                               'NE_DATE_MODIFIED',
                                               'NE_MODIFIED_BY',
                                               'NE_CREATED_BY' -- handled by the trigger
                                                              )
                       AND CASE column_name
                               WHEN 'NE_UNIQUE' THEN 'FALSE'
                               ELSE '1'
                           END =
                           CASE column_name
                               WHEN 'NE_UNIQUE'
                               THEN
                                   user_defined_ne_unique (l_nt_type)
                               ELSE
                                   '1'
                           END;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    NULL;
            END;


            IF l_dummy != 0
            THEN
                raise_application_error (
                    -20003,
                    'Mandatory columns are not catered for in the datum attributes of the load file profile');
            ELSE
                l_dummy := 0;

                -- now check to ensure that all the columns that make up the unique key when the

                BEGIN
                    SELECT 1
                      INTO l_dummy
                      FROM dba_tab_columns, nm_type_columns
                     WHERE     owner =
                               SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
                           AND table_name = 'NM_ELEMENTS_ALL'
                           AND ntc_nt_type = l_nt_type
                           AND ntc_column_name = column_name
                           AND ntc_unique_seq IS NOT NULL
                           AND (    NOT EXISTS
                                        (SELECT 1
                                           FROM sdl_datum_attribute_mapping
                                          WHERE     sdam_profile_id =
                                                    p_profile_id
                                                AND column_name =
                                                    sdam_column_name)
                                AND (    ntc_default IS NOT NULL
                                     AND ntc_seq_name IS NOT NULL))
                           AND ROWNUM = 1;
                EXCEPTION
                    WHEN NO_DATA_FOUND
                    THEN
                        NULL;
                END;
            END IF;

            --
            IF l_dummy != 0
            THEN
                raise_application_error (
                    -20004,
                    'Columns that are used to construct the unique key of the datums are not present in the profile datum attribute list');
            END IF;
        END IF;
    END validate_profile;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE set_working_geometry (p_batch_id      IN NUMBER,
                                    p_unit_factor   IN NUMBER,
                                    p_round         IN NUMBER)
    IS
        l_diminfo         sdo_dim_array;
        l_srid            NUMBER;
        l_gtype           NUMBER;
        l_unit_str        VARCHAR2 (30);
        meta_row          V_SDL_PROFILE_NW_TYPES%ROWTYPE;
        l_sdo_tol         NUMBER;
        l_length_column   VARCHAR2 (30);
        l_lengths         ptr_num_array_type;

        FUNCTION get_length_column (p_batch_id IN NUMBER)
            RETURN VARCHAR2
        IS
            retval   VARCHAR2 (30);
        BEGIN
            nm_debug.debug ('get length column');

            BEGIN
                SELECT column_name
                  INTO retval
                  FROM sdl_attribute_mapping,
                       sdl_file_submissions,
                       dba_tab_columns
                 WHERE     sam_sp_id = sfs_sp_id
                       AND sfs_id = p_batch_id
                       AND owner =
                           SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
                       AND table_name = 'SDL_LOAD_DATA'
                       AND column_name = 'SLD_COL_' || sam_col_id
                       AND sam_ne_column_name = 'NE_LENGTH';
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    retval := NULL;
            END;

            nm_debug.debug ('get length column = ' || NVL (retval, 'NULL'));

            RETURN retval;
        END;
    -----------------------------

    BEGIN
        SELECT m.*
          INTO meta_row
          FROM V_SDL_PROFILE_NW_TYPES m, sdl_file_submissions
         WHERE sfs_id = p_batch_id AND sp_id = sfs_sp_id;

        --

        DELETE FROM sdl_validation_results
              WHERE svr_validation_type = 'S' AND svr_sfs_id = p_batch_id;

        SELECT diminfo, srid
          INTO l_diminfo, l_srid
          FROM user_sdo_geom_metadata
         WHERE     table_name = 'SDL_LOAD_DATA'
               AND column_name = 'SLD_WORKING_GEOMETRY';

        l_sdo_tol := l_diminfo (1).sdo_tolerance;

        --
        l_gtype := guess_dim_and_gtype (p_batch_id);

        l_length_column := get_length_column (p_batch_id);

        --      l_length_column := '5';  -- Test the measure using a constant, a quick test to ensure successful SQL execution

        IF l_length_column IS NULL
        THEN
            l_length_column := 'NULL';
        END IF;

        nm_debug.debug ('Update working geometry');

        DECLARE
            l_sql   VARCHAR2 (4000);
        BEGIN
            l_sql :=                                       --execute immediate
                   'UPDATE sdl_load_data a '
                || '   SET a.sld_working_geometry = '
                || '           sdl_validate.configure_sdl_geometry ( '
                || '               sld_load_geometry, '
                || '               :l_gtype, '
                || '               '
                || l_length_column
                || ', '
                || '               :p_unit_factor, '
                || '               :p_round, '
                || '               :l_sdo_tol, '
                || '               :l_srid) '
                || ' WHERE sld_sfs_id = :p_batch_id ';

            nm_debug.debug (l_sql);

            nm_debug.debug (
                   'Using '
                || l_gtype
                || ', '
                || p_unit_factor
                || ', '
                || p_round
                || ', '
                || l_sdo_tol
                || ', '
                || l_srid
                || ', '
                || p_batch_id);


            EXECUTE IMMEDIATE l_sql
                USING l_gtype,
                      p_unit_factor,
                      p_round,
                      l_sdo_tol,
                      l_srid,
                      p_batch_id;
        END;

        nm_debug.debug ('Update working geometry complete');


        INSERT INTO sdl_validation_results (svr_sfs_id,
                                            svr_validation_type,
                                            svr_sld_key,
                                            svr_column_name,
                                            svr_status_code,
                                            svr_message)
            SELECT p_batch_id,
                   'S',
                   sld_key,
                   'SLD_LOAD_GEOMETRY',
                   error_code,
                   error_msg
              FROM (  SELECT sld_key,
                             CASE WHEN error_code IS NOT NULL
                                  THEN error_code
                                  WHEN LENGTH(TRIM(TRANSLATE(error_msg, '0123456789', ' '))) IS NULL
                                  THEN TO_NUMBER(error_msg)
                                  ELSE -99
                             END error_code,
                             CASE WHEN error_code IS NOT NULL
                                  THEN get_rdbms_error_message(error_code) || ' - ' || error_msg
                                  WHEN LENGTH(TRIM(TRANSLATE(error_msg, '0123456789', ' '))) IS NULL
                                  THEN get_rdbms_error_message(TO_NUMBER(error_msg)) || ' - ' || error_msg
                                  ELSE error_msg
                             END error_msg
                        FROM (SELECT sld_key,
                                     FIRST_VALUE (error_code)
                                         OVER (PARTITION BY sld_key
                                               ORDER BY sld_key)    error_code,
                                     FIRST_VALUE (error_msg)
                                         OVER (PARTITION BY sld_key
                                               ORDER BY sld_key)    error_msg
                                FROM (SELECT sld_key,
                                             TO_NUMBER (
                                                 SUBSTR (
                                                     status,
                                                     1,
                                                     INSTR (status, ' ', 1)))
                                                 error_code,
                                             status
                                                 error_msg
                                        FROM (SELECT sld_key,
                                                       SDO_GEOM.validate_geometry_with_context (
                                                         sld_working_geometry,
                                                         l_diminfo)    status
                                                FROM sdl_load_data
                                               WHERE     sld_sfs_id = p_batch_id
                                                     AND SDO_GEOM.validate_geometry_with_context (
                                                             sld_working_geometry,
                                                             l_diminfo) !=
                                                         'TRUE')))
                    GROUP BY sld_key,
                             error_code,
                             error_msg);

        INSERT INTO sdl_validation_results (svr_sfs_id,
                                            svr_validation_type,
                                            svr_sld_key,
                                            svr_column_name,
                                            svr_status_code,
                                            svr_message)
            SELECT p_batch_id,
                   'S',
                   sld_key,
                   'SLD_LOAD_GEOMETRY',
                   -97,
                   'Measures must be increasing'
              FROM sdl_load_data
             WHERE     sld_sfs_id = p_batch_id
                   AND SDO_LRS.IS_MEASURE_INCREASING (sld_working_geometry) !=
                       'TRUE';


        --
        UPDATE sdl_load_data a
           SET a.sld_working_geometry = NULL
         WHERE     sld_sfs_id = p_batch_id
               AND EXISTS
                       (SELECT 1
                          FROM sdl_validation_results
                         WHERE     svr_sfs_id = p_batch_id
                               AND svr_sld_key = sld_key);

        UPDATE sdl_file_submissions
           SET sfs_mbr_geometry =
                   (SELECT sdo_aggr_mbr (sld_working_geometry)
                      FROM sdl_load_data
                     WHERE sld_sfs_id = p_batch_id)
         WHERE sfs_id = p_batch_id;
    --
    END set_working_geometry;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION guess_dim_and_gtype (p_batch_id IN NUMBER)
        RETURN NUMBER
    IS
        retval   NUMBER;
        l_mod2   NUMBER;
        l_mod3   NUMBER;
    BEGIN
        SELECT SUM (mod2), SUM (mod3)
          INTO l_mod2, l_mod3
          FROM (SELECT CASE mod2 WHEN 0 THEN 0 ELSE 1 END     mod2,
                       CASE mod3 WHEN 0 THEN 0 ELSE 1 END     mod3
                  FROM (SELECT MOD (ord_count, 2)     mod2,
                               MOD (ord_count, 3)     mod3
                          FROM (  SELECT sld_key, COUNT (*) ord_count
                                    FROM sdl_load_data a,
                                         TABLE (
                                             a.sld_load_geometry.sdo_ordinates)
                                         t
                                   WHERE sld_sfs_id = p_batch_id
                                GROUP BY sld_key)));

        IF l_mod2 = 0 AND l_mod3 = 0
        THEN
            --difficult to know!
            retval := NULL;
        ELSIF l_mod2 = 0 AND l_mod3 > 0
        THEN
            -- Its not 3D so guess we should translate to LRS
            retval := 2002;
        ELSIF l_mod2 > 0 AND l_mod3 > 0
        THEN
            retval := NULL;
        ELSE                                      -- l_mod2 > 0 and l_mod3 = 0
            retval := 3302;
        END IF;

        RETURN retval;
    END guess_dim_and_gtype;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION CONFIGURE_SDL_GEOMETRY (p_geom          IN SDO_GEOMETRY,
                                     p_gtype         IN NUMBER,
                                     p_length        IN NUMBER,
                                     p_unit_factor   IN NUMBER,
                                     p_round         IN NUMBER,
                                     p_sdo_tol       IN NUMBER,
                                     p_srid          IN NUMBER)
        RETURN SDO_GEOMETRY
    IS
        retval    SDO_GEOMETRY := p_geom;
        l_parts   NUMBER;
        qq        CHAR (1) := CHR (39);
    BEGIN
        l_parts := retval.sdo_elem_info.COUNT / 3;

        --        SELECT COUNT (*) / 3 INTO l_parts FROM TABLE (retval.sdo_elem_info);

        IF retval.sdo_gtype IN (3002, 3006)
        THEN
            IF p_gtype IN (3302, 3306)
            THEN
                retval.sdo_gtype :=
                    CASE WHEN l_parts = 1 THEN 3302 ELSE 3306 END;

                IF p_length IS NOT NULL
                THEN
                    retval :=
                        SDO_LRS.scale_geom_segment (retval,
                                                    0,
                                                    p_length,
                                                    0,
                                                    p_sdo_tol);
                END IF;
            ELSIF p_gtype IN (2002, 2206)
            THEN
                retval.sdo_gtype :=
                    CASE WHEN l_parts = 1 THEN 2002 ELSE 2006 END;
                retval :=
                    SDO_LRS.convert_to_lrs_geom (
                        retval,
                        0,
                        ROUND (
                            NVL (
                                p_length,
                                  SDO_GEOM.sdo_length (retval,
                                                       p_sdo_tol,
                                                       'unit=METER')
                                / p_unit_factor),
                            p_round));
            END IF;
        END IF;

        IF retval.sdo_srid IS NULL
        THEN
            retval.sdo_srid := 2234;
        END IF;

        --
        RETURN retval;
    END configure_sdl_geometry;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE validate_datum_geometry (p_batch_id IN INTEGER)
    IS
        l_diminfo   sdo_dim_array;
        l_gtype     NUMBER;
    BEGIN
        --
        SELECT diminfo
          INTO l_diminfo
          FROM user_sdo_geom_metadata
         WHERE table_name = 'SDL_WIP_DATUMS' AND column_name = 'GEOM';

        --
        --Try and extract the first error for each geometry, there may be more than one, this could be an enhancement - or perhaps the client
        --can display all error messages relating to the specific geometry from a simple cursor?
        --
        INSERT INTO sdl_validation_results (svr_sfs_id,
                                            svr_validation_type,
                                            svr_sld_key,
                                            svr_swd_id,
                                            svr_column_name,
                                            svr_status_code,
                                            svr_message)
            SELECT p_batch_id,
                   'S',
                   sld_key,
                   swd_id,
                   'GEOM',
                   ERROR_CODE,
                   get_rdbms_error_message(ERROR_CODE) || ' - ' || error_msg
              FROM (  SELECT sld_key,
                             swd_id,
                             ERROR_CODE,
                             error_msg
                        FROM (SELECT sld_key,
                                     swd_id,
                                     FIRST_VALUE (ERROR_CODE)
                                         OVER (PARTITION BY swd_id
                                               ORDER BY swd_id)    ERROR_CODE,
                                     FIRST_VALUE (error_msg)
                                         OVER (PARTITION BY swd_id
                                               ORDER BY swd_id)    error_msg
                                FROM (SELECT sld_key,
                                             swd_id,
                                             TO_NUMBER (
                                                 SUBSTR (
                                                     status,
                                                     1,
                                                     INSTR (status, ' ', 1)))
                                                 ERROR_CODE,
                                             status
                                                 error_msg
                                        FROM (SELECT sld_key,
                                                     swd_id,
                                                     SDO_GEOM.validate_geometry_with_context (
                                                         geom,
                                                         l_diminfo)    status
                                                FROM sdl_wip_datums
                                               WHERE     batch_id = p_batch_id
                                                     AND geom IS NOT NULL
                                                     AND SDO_GEOM.validate_geometry_with_context (
                                                             geom,
                                                             l_diminfo) !=
                                                         'TRUE')))
                    GROUP BY sld_key,
                             swd_id,
                             ERROR_CODE,
                             error_msg)
            UNION ALL
            SELECT p_batch_id,
                   'S',
                   sld_key,
                   swd_id,
                   'GEOM',
                   -999,
                   'Geometry is NULL'
              FROM sdl_wip_datums
             WHERE geom IS NULL;
    --
    --        check_self_intersections (p_batch_id);

    END validate_datum_geometry;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE check_self_intersections (p_batch_id IN INTEGER)
    IS
        g_intersection_mask   VARCHAR2 (100) := 'OVERLAPBDYDISJOINT';
        l_datum_ids           geom_id_tab;
    BEGIN
        SELECT CAST (COLLECT (geom_id (swd_id, geom)) AS geom_id_tab)
          INTO l_datum_ids
          FROM sdl_wip_datums
         WHERE batch_id = p_batch_id;

        --
        FOR i IN 1 .. l_datum_ids.COUNT
        LOOP
            --
            INSERT INTO sdl_validation_results (svr_sfs_id,
                                                svr_validation_type,
                                                svr_column_name,
                                                svr_status_code,
                                                svr_message,
                                                svr_swd_id)
                WITH
                    plines
                    AS
                        (SELECT t.id, t.geom
                           FROM TABLE (
                                    SDL_STATS.GEOM_AS_PLINE_TAB (
                                        l_datum_ids (i).geom)) t)
                SELECT p_batch_id,
                       'I',
                       'GEOM',
                       -98,
                       'Geometry is self-intersecting',
                       l_datum_ids (i).id
                  FROM plines p1, plines p2
                 WHERE     sdo_relate (p1.geom,
                                       p2.geom,
                                       'mask=' || g_intersection_mask) =
                           'TRUE'
                       AND p1.id != p2.id
                       AND p1.id < p2.id - 1;
        END LOOP;
    END check_self_intersections;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE set_datum_status (p_batch_id IN NUMBER)
    IS
    BEGIN
        UPDATE sdl_wip_datums
           SET status = 'VALID'
         WHERE     NOT EXISTS
                       (SELECT 1
                          FROM sdl_validation_results
                         WHERE svr_swd_id = swd_id)
               AND batch_id = p_batch_id
               AND status IN ('NEW', 'VALID', 'INVALID');

        UPDATE sdl_wip_datums
           SET status = 'INVALID'
         WHERE     EXISTS
                       (SELECT 1
                          FROM sdl_validation_results
                         WHERE svr_swd_id = swd_id)
               AND batch_id = p_batch_id
               AND status IN ('NEW', 'VALID', 'INVALID');
    END set_datum_status;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE validate_datums_in_batch (p_batch_id IN NUMBER)
    IS
        meta_row      V_SDL_PROFILE_NW_TYPES%ROWTYPE;
        l_view_name   VARCHAR2 (30);
    BEGIN
        DELETE FROM sdl_validation_results
              WHERE svr_sfs_id = p_batch_id AND svr_swd_id IS NOT NULL;

        SELECT m.*
          INTO meta_row
          FROM V_SDL_PROFILE_NW_TYPES m, sdl_file_submissions
         WHERE sfs_id = p_batch_id AND sp_id = sfs_sp_id;

        l_view_name := 'V_SDL_WIP_' || meta_row.sp_name || '_DATUMS';

        validate_datum_geometry (p_batch_id => p_batch_id);

        validate_datum_domain_columns (p_batch_id       => p_batch_id,
                                       p_profile_id     => meta_row.sp_id,
                                       p_profile_view   => l_view_name);

        validate_dtm_mand_columns (p_batch_id       => p_batch_id,
                                   p_profile_id     => meta_row.sp_id,
                                   p_profile_view   => l_view_name);

        validate_dtm_column_len (p_batch_id       => p_batch_id,
                                 p_profile_id     => meta_row.sp_id,
                                 p_profile_view   => l_view_name);

        set_datum_status (p_batch_id);
    END validate_datums_in_batch;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE validate_datum_domain_columns (p_batch_id       IN NUMBER,
                                             p_profile_id     IN NUMBER,
                                             p_profile_view   IN VARCHAR2)
    IS
        sql_str   VARCHAR2 (4000);
        max_id    NUMBER;
    BEGIN
        SELECT MAX (sdam_profile_id),
                  'insert into sdl_validation_results (svr_sfs_id, svr_sld_key, svr_swd_id, svr_validation_type, svr_column_name, svr_current_value, svr_status_code, svr_message) '
               || LISTAGG (
                         'select '
                      || p_batch_id
                      || ','
                      || 'sld_key'
                      || ','
                      || 'swd_id'
                      || ','
                      || ''''
                      || 'D'
                      || ''''
                      || ','
                      || ''''
                      || column_name
                      || ''''
                      || ','
                      || column_name
                      || ','
                      || ' -999, '
                      || ''''
                      || 'Domain '
                      || domain
                      || ' value '
                      || column_name
                      || ' is invalid'
                      || ''''
                      || ' from '
                      || p_profile_view
                      || ' where batch_id = '
                      || TO_CHAR (p_batch_id)
                      || ' and not exists ( select 1 from hig_codes where hco_domain = '
                      || ''''
                      || domain
                      || ''''
                      || ' and hco_code = '
                      || column_name
                      || ')',
                      ' union all ')
                  WITHIN GROUP (ORDER BY sdam_seq_no)
          INTO max_id, sql_str
          FROM sdl_datum_attribute_mapping a, v_nm_nw_columns n
         WHERE     sdam_profile_id = p_profile_id
               AND n.network_type = sdam_nw_type
               AND sdam_column_name = n.column_name
               AND domain IS NOT NULL;

        nm_debug.debug_on;
        nm_debug.debug (sql_str);

        IF max_id IS NOT NULL
        THEN
            EXECUTE IMMEDIATE sql_str;
        END IF;
    END validate_datum_domain_columns;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE validate_dtm_mand_columns (p_batch_id       IN NUMBER,
                                         p_profile_id     IN NUMBER,
                                         p_profile_view   IN VARCHAR2)
    IS
        sql_str   VARCHAR2 (4000);
        max_id    NUMBER;
    BEGIN
        SELECT MAX (sdam_profile_id),
                  'insert into sdl_validation_results (svr_sfs_id, svr_sld_key, svr_swd_id, svr_validation_type, svr_column_name, svr_current_value, svr_status_code, svr_message) '
               || LISTAGG (
                         'select '
                      || p_batch_id
                      || ','
                      || 'sld_key'
                      || ','
                      || 'swd_id'
                      || ','
                      || ''''
                      || 'M'
                      || ''''
                      || ','
                      || ''''
                      || column_name
                      || ''''
                      || ','
                      || column_name
                      || ','
                      || ' -999, '
                      || ''''
                      || 'Column is marked as mandatory but has no value '
                      || ''''
                      || ' from '
                      || p_profile_view
                      || ' where batch_id = '
                      || TO_CHAR (p_batch_id)
                      || ' and '
                      || column_name
                      || ' is NULL ',
                      ' union all ')
                  WITHIN GROUP (ORDER BY sdam_seq_no)
          INTO max_id, sql_str
          FROM sdl_datum_attribute_mapping a, v_nm_nw_columns n
         WHERE     sdam_profile_id = p_profile_id
               AND n.network_type = sdam_nw_type
               AND sdam_column_name = n.column_name
               AND mandatory = 'Y';

        nm_debug.debug_on;
        nm_debug.debug (sql_str);

        IF max_id IS NOT NULL
        THEN
            EXECUTE IMMEDIATE sql_str;
        END IF;
    END validate_dtm_mand_columns;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE validate_dtm_column_len (p_batch_id       IN NUMBER,
                                       p_profile_id     IN NUMBER,
                                       p_profile_view   IN VARCHAR2)
    IS
        sql_str   VARCHAR2 (4000);
        max_id    NUMBER;
    BEGIN
        SELECT MAX (sdam_profile_id),
                  'insert into sdl_validation_results (svr_sfs_id, svr_sld_key, svr_swd_id, svr_validation_type, svr_column_name, svr_current_value, svr_status_code, svr_message) '
               || LISTAGG (
                         'select '
                      || p_batch_id
                      || ','
                      || 'sld_key'
                      || ','
                      || 'swd_id'
                      || ','
                      || ''''
                      || 'L'
                      || ''''
                      || ','
                      || ''''
                      || column_name
                      || ''''
                      || ','
                      || column_name
                      || ','
                      || ' -999, '
                      || ''''
                      || 'Length of '
                      || column_name
                      || ' is invalid'
                      || ''''
                      || ' from '
                      || p_profile_view
                      || ' where batch_id = '
                      || TO_CHAR (p_batch_id)
                      || ' and '
                      || 'length('
                      || column_name
                      || ') '
                      || ' > '
                      || TO_CHAR (field_length),
                      ' union all ')
                  WITHIN GROUP (ORDER BY sdam_seq_no)
          INTO max_id, sql_str
          FROM sdl_datum_attribute_mapping a, v_nm_nw_columns n
         WHERE     sdam_profile_id = p_profile_id
               AND n.network_type = sdam_nw_type
               AND sdam_column_name = n.column_name
               AND mandatory = 'Y';

        nm_debug.debug_on;
        nm_debug.debug (sql_str);

        IF max_id IS NOT NULL
        THEN
            EXECUTE IMMEDIATE sql_str;
        END IF;
    END validate_dtm_column_len;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE reset_load_status (p_batch_id IN NUMBER)
    IS
    BEGIN
        -- reset status of load table to VALID in case when re-executing spatial analysis.
        -- it won't update status of any load records when it's a fresh run
        UPDATE sdl_load_data
           SET sld_status = 'VALID'
         WHERE     sld_sfs_id = p_batch_id
               AND sld_status IN ('LOAD', 'SKIP', 'REVIEW');
    END reset_load_status;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE update_load_datum_status (p_batch_id IN NUMBER)
    IS
    BEGIN
        -- update status of load table VALID records based on profile review levels
        UPDATE sdl_load_data sld
           SET sld_status =
                   NVL (
                       (SELECT ssrl.ssrl_default_action
                          FROM sdl_spatial_review_levels  ssrl,
                               sdl_file_submissions       sfs,
                               sdl_geom_accuracy          sga
                         WHERE     ssrl.ssrl_sp_id = sfs.sfs_sp_id
                               AND sfs.sfs_id = sld.sld_sfs_id
                               AND sga.slga_sld_key = sld.sld_key
                               AND NVL (sga.slga_pct_inside, -1) BETWEEN ssrl.ssrl_percent_from
                                                                     AND ssrl.ssrl_percent_to),
                       'REVIEW')
         WHERE sld.sld_sfs_id = p_batch_id AND sld.sld_status = 'VALID';

        -- update status of datum table VALID records based on profile review levels
        UPDATE sdl_wip_datums swd
           SET swd.status =
                   NVL (
                       (SELECT ssrl.ssrl_default_action
                          FROM sdl_spatial_review_levels  ssrl,
                               sdl_file_submissions       sfs
                         WHERE     ssrl.ssrl_sp_id = sfs.sfs_sp_id
                               AND sfs.sfs_id = swd.batch_id
                               AND swd.pct_match BETWEEN ssrl.ssrl_percent_from
                                                     AND ssrl.ssrl_percent_to),
                       'REVIEW')
         WHERE swd.batch_id = p_batch_id AND swd.status = 'VALID';
    END update_load_datum_status;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION user_defined_ne_unique (p_nt_type IN VARCHAR2)
        RETURN VARCHAR2
    IS
        retval   VARCHAR2 (10) := 'FALSE';
    BEGIN
        BEGIN
            SELECT 'TRUE'
              INTO retval
              FROM nm_types
             WHERE nt_type = p_nt_type AND nt_pop_unique = 'Y';
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                BEGIN
                    SELECT 'TRUE'
                      INTO retval
                      FROM nm_type_columns
                     WHERE     ntc_nt_type = p_nt_type
                           AND (   ntc_seq_name IS NOT NULL
                                OR ntc_default IS NOT NULL);
                EXCEPTION
                    WHEN NO_DATA_FOUND
                    THEN
                        retval := 'FALSE';
                END;
        END;

        RETURN retval;
    END;
END sdl_validate;
/