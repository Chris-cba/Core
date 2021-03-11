CREATE OR REPLACE PACKAGE BODY sdl_ddl
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sdl_ddl.pkb-arc   1.37   Mar 11 2021 19:24:28   Vikas.Mhetre  $
    --       Module Name      : $Workfile:   sdl_ddl.pkb  $
    --       Date into PVCS   : $Date:   Mar 11 2021 19:24:28  $
    --       Date fetched Out : $Modtime:   Mar 11 2021 19:08:44  $
    --       PVCS Version     : $Revision:   1.37  $
    --
    --   Author : R.A. Coupe
    --
    --   Package for handling the generation of views and triggers to support the SDL
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    --
    -- The main purpose of this package is to provide DDL execution for creation of views and triggers
    -- to support the SDL.

    g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.37  $';

    g_package_name   CONSTANT VARCHAR2 (30) := 'SDL_DDL';

    g_diminfo                 sdo_dim_array := nm3sdo.coalesce_nw_diminfo;
    g_2d_diminfo              sdo_dim_array
        := SDO_LRS.convert_to_std_dim_array (g_diminfo);

    g_default_role            VARCHAR2 (30)
        := NVL (hig.get_sysopt ('SDL_ROLE'), 'SDL_USER');

    FUNCTION get_srid
        RETURN NUMBER;

    g_srid                    NUMBER := get_srid;

    qq                        VARCHAR2 (1) := CHR (39);

    --
    ----------------------------------------------------------------------------
    --
    FUNCTION get_version
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN g_sccsid;
    END get_version;

    --
    ----------------------------------------------------------------------------
    --
    FUNCTION get_body_version
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN g_body_sccsid;
    END get_body_version;

    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE gen_profile_ld_view (p_profile_id   IN     NUMBER,
                                   p_view_sql        OUT VARCHAR2);

    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE gen_profile_ne_view (p_profile_id   IN     NUMBER,
                                   p_view_sql        OUT VARCHAR2);

    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE gen_profile_ld_stats_view (p_profile_id   IN     NUMBER,
                                         p_view_sql        OUT VARCHAR2);

    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE gen_profile_ne_stats_view (p_profile_id   IN     NUMBER,
                                         p_view_sql        OUT VARCHAR2);

    --
    ----------------------------------------------------------------------------
    --
    FUNCTION get_unique (p_nt_type IN VARCHAR2)
        RETURN VARCHAR2;

    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE insert_theme (
        p_theme_name          IN VARCHAR2,
        p_object_name         IN VARCHAR2,
        p_base_theme_table    IN VARCHAR2,
        p_base_theme_column   IN VARCHAR2,
        p_key_name            IN VARCHAR2,
        p_geom_column_name    IN VARCHAR2,
        p_role                IN VARCHAR2 DEFAULT g_default_role,
        p_dim                 IN NUMBER,
        p_gtype               IN NUMBER);

    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE insert_sdo_metadata (p_table_name    IN VARCHAR2,
                                   p_column_name   IN VARCHAR2,
                                   p_diminfo          sdo_dim_array,
                                   p_srid             NUMBER);

    --
    ----------------------------------------------------------------------------
    --
    FUNCTION get_srid
        RETURN NUMBER
    IS
    BEGIN
        BEGIN
            --
            SELECT sdo_srid
              INTO g_srid
              FROM mdsys.sdo_geom_metadata_table, nm_themes_all, nm_nw_themes
             WHERE     sdo_owner =
                       SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
                   AND sdo_table_name = nth_feature_table
                   AND sdo_column_name = nth_feature_shape_column
                   AND nth_theme_id = nnth_nth_theme_id
                   AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;

        RETURN g_srid;
    END get_srid;

    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE gen_sdl_profile_views (p_profile_id IN NUMBER)
    IS
        l_view_sql   VARCHAR2 (4000);
    BEGIN
        gen_profile_ld_view (p_profile_id, l_view_sql);

        gen_profile_ne_view (p_profile_id, l_view_sql);

        gen_profile_ld_stats_view (p_profile_id, l_view_sql);

        gen_profile_ne_stats_view (p_profile_id, l_view_sql);

        gen_datum_view (p_profile_id);
    END gen_sdl_profile_views;

    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE gen_profile_ld_view (p_profile_id   IN     NUMBER,
                                   p_view_sql        OUT VARCHAR2)
    IS
    BEGIN
          SELECT    'create or replace view V_SDL_'
                 || REPLACE (sp_name, ' ', '_')
                 || '_LD'
                 || ' ( batch_id, record_id, sld_key, '
                 || LISTAGG (sam_view_column_name, ',')
                        WITHIN GROUP (ORDER BY sam_id)
                 || ', sld_status, geom '
                 || ' ) as select sld_sfs_id, sld_id, sld_key, '
                 || LISTAGG ('sld_col_' || sam_col_id, ',')
                        WITHIN GROUP (ORDER BY sam_id)
                 || ', sld_status, sld_load_geometry '
                 || ' FROM sdl_load_data '
                 || ' WHERE sld_sfs_id IN (SELECT sfs_id
                            FROM sdl_file_submissions
                           WHERE sfs_sp_id = '
                 || p_profile_id
                 || ') '
                 || 'and sld_sfs_id = nvl(to_number(sys_context('
                 || qq
                 || 'NM3SQL'
                 || qq
                 || ', '
                 || qq
                 || 'SDLCTX_SFS_ID'
                 || qq
                 || ')),sld_sfs_id) '
            INTO p_view_sql
            FROM SDL_ATTRIBUTE_MAPPING, sdl_profiles
           WHERE sam_sp_id = sp_id AND sp_id = p_profile_id
        GROUP BY sp_name;

        --
        --        nm_debug.debug_on;
        --        nm_debug.debug (p_view_sql);

        EXECUTE IMMEDIATE p_view_sql;
    --
    END gen_profile_ld_view;

    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE gen_profile_ne_view (p_profile_id   IN     NUMBER,
                                   p_view_sql        OUT VARCHAR2)
    IS
    BEGIN
    
          begin
             sdl_validate.validate_profile(p_profile_id);
          end;
          
          SELECT    'create or replace view V_SDL_'
                 || REPLACE (sp_name, ' ', '_')
                 || '_NE'
                 || ' ( batch_id, record_id, sld_key, '
                 || LISTAGG (sam_ne_column_name, ',')
                        WITHIN GROUP (ORDER BY sam_id)
                 || ', status '
                 || ', geom '
                 || ' ) as select batch_id, record_id, sld_key, '
                 || LISTAGG (
                        CASE field_type
                            WHEN 'VARCHAR2'
                            THEN
                                CASE attrib_used_flag
                                    WHEN '1' THEN selected_value
                                    ELSE 'NULL'
                                END
                            WHEN 'DATE'
                            THEN
                                CASE attrib_used_flag
                                    WHEN '1'
                                    THEN
                                        CASE
                                            WHEN spfc_date_format IS NULL
                                            THEN
                                                selected_value
                                            ELSE
                                                   'to_date('
                                                || selected_value
                                                || ','
                                                || ''''
                                                || spfc_date_format
                                                || ''''
                                                || ')'
                                        END
                                    ELSE
                                        'NULL'
                                END
                            WHEN 'NUMBER'
                            THEN
                                CASE attrib_used_flag
                                    WHEN '1'
                                    THEN
                                           'cast ('
                                        || selected_value
                                        || ' as number )'
                                    ELSE
                                        'NULL'
                                END
                        END,
                        ',')
                    WITHIN GROUP (ORDER BY sam_id)
                 || ', sld_status '
                 || ', geom '
                 || ' FROM v_sdl_'||REPLACE (sp_name, ' ', '_')||'_LD'
                 || ' WHERE batch_id IN (SELECT sfs_id
                            FROM sdl_file_submissions
                           WHERE sfs_sp_id = '
                 || p_profile_id
                 || ') '
                 || 'and batch_id = nvl(to_number(sys_context('
                 || ''''
                 || 'NM3SQL'
                 || ''''
                 || ', '
                 || ''''
                 || 'SDLCTX_SFS_ID'
                 || ''''
                 || ')),batch_id) '
            INTO p_view_sql
            FROM (SELECT sam_id,
                         sam_col_id,
                         sam_sp_id,
                         '1'     attrib_used_flag,
                         sam_ne_column_name,
                         sam_sdh_id,
                         spfc_date_format,
                         selected_value
                    FROM (SELECT sam_id,
                                 sam_sp_id,
                                 sam_sdh_id,
                                 sam_col_id,
                                 sam_file_attribute_name,
                                 sam_view_column_name,
                                 sam_ne_column_name,
                                 CASE
                                             WHEN sam_default_value IS NULL
                                             THEN
                                                 sam_view_column_name
                                             ELSE
                                                 sam_default_value
                                 END    selected_value
                            FROM (SELECT sam_id,
                                         sam_sp_id,
                                         sam_sdh_id,
                                         sam_col_id,
                                         sam_file_attribute_name,
                                         sam_view_column_name,
                                         sam_ne_column_name,
                                         sam_default_value
                                    FROM sdl_attribute_mapping
                                   WHERE sam_sp_id = p_profile_id)),
                         sdl_destination_header,
                         sdl_profile_file_columns
                   WHERE     sam_sp_id = sdh_sp_id
                         AND sam_sdh_id = sdh_id
                         AND sdh_destination_location = 'N'
                         AND sam_sp_id = p_profile_id
                         AND spfc_sp_id(+) = sdh_sp_id
                         AND spfc_col_name(+) = sam_file_attribute_name
                  UNION ALL
                  SELECT ROW_NUMBER () OVER (ORDER BY column_name) * -1,
                         ROW_NUMBER () OVER (ORDER BY column_name) * -1,
                         p_profile_id,
                         '0',
                         column_name,
                         -1,
                         NULL,
                         NULL
                    FROM dba_tab_columns
                   WHERE     owner =
                             SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
                         AND table_name = 'NM_ELEMENTS_ALL'
                         AND column_name IN ('NE_UNIQUE',
                                             'NE_DESCR',
                                             'NE_START_DATE',
                                             'NE_END_DATE')
                         AND NOT EXISTS
                                 (SELECT 1
                                    FROM sdl_attribute_mapping,
                                         sdl_destination_header
                                   WHERE     sam_sp_id = sdh_sp_id
                                         AND sam_sdh_id = sdh_id
                                         AND sdh_destination_location = 'N'
                                         AND sam_sp_id = p_profile_id
                                         AND sam_ne_column_name = column_name)),
                 sdl_profiles,
                 sdl_destination_header,
                 v_nm_nw_columns,
                 nm_linear_types
           WHERE     sam_sp_id = sp_id
                 AND sam_sp_id = sdh_sp_id
                 AND (sam_sdh_id = sdh_id OR sam_sdh_id = -1)
                 AND sdh_destination_location = 'N'
                 AND sp_id = p_profile_id
                 AND column_name = sam_ne_column_name
                 AND nlt_id = sdh_nlt_id
                 AND NVL (nlt_gty_type, '$%^&') = NVL (group_type, '$%^&')
                 AND nlt_nt_type = network_type
        GROUP BY sp_name;


        --        nm_debug.debug_on;
        nm_debug.debug (p_view_sql);

        EXECUTE IMMEDIATE p_view_sql;
    END gen_profile_ne_view;

    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE gen_profile_ld_stats_view (p_profile_id   IN     NUMBER,
                                         p_view_sql        OUT VARCHAR2)
    IS
    BEGIN
          SELECT    'create or replace view V_SDL_'
                 || REPLACE (sp_name, ' ', '_')
                 || '_LD_STATS'
                 || ' ( batch_id, record_id, sld_key, '
                 || LISTAGG (sam_view_column_name, ',')
                        WITHIN GROUP (ORDER BY sam_id)
                 || ',buffer_size, '
                 || 'pct_inside, '
                 || 'min_offset, '
                 || 'max_offset, '
                 || 'pct_std_dev, '
                 || 'pct_average, '
                 || 'pct_median, '
                 || ' geom '
                 || ' ) as select sld_sfs_id, sld_id, l.sld_key, '
                 || LISTAGG ('sld_col_' || sam_col_id, ',')
                        WITHIN GROUP (ORDER BY sam_id)
                 || ' , buffer_size, '
                 || 'nvl(pct_inside,-1), '
                 || 'min_offset, '
                 || 'max_offset, '
                 || 'pct_std_dev, '
                 || 'nvl(pct_average, -1), '
                 || 'pct_median, '
                 || 'l.sld_working_geometry '
                 || ' from sdl_load_data l, v_sdl_batch_accuracy a '
                 || ' where sld_sfs_id = batch_id '
                 || ' and sld_id = record_id '
                 || ' and sld_sfs_id IN (SELECT sfs_id FROM sdl_file_submissions '
                 || ' WHERE sfs_sp_id = '
                 || TO_CHAR (p_profile_id)
                 || ') '
                 || 'and sld_sfs_id = nvl(to_number(sys_context('
                 || qq
                 || 'NM3SQL'
                 || qq
                 || ', '
                 || qq
                 || 'SDLCTX_SFS_ID'
                 || qq
                 || ')),sld_sfs_id) '
            INTO p_view_sql
            FROM sdl_attribute_mapping, sdl_profiles
           WHERE sam_sp_id = sp_id AND sp_id = p_profile_id
        GROUP BY sp_name;

        --
        --        nm_debug.debug_on;
        --        nm_debug.debug (p_view_sql);

        EXECUTE IMMEDIATE p_view_sql;
    --
    END gen_profile_ld_stats_view;

    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE gen_profile_ne_stats_view (p_profile_id   IN     NUMBER,
                                         p_view_sql        OUT VARCHAR2)
    IS
    BEGIN
          SELECT    'create or replace view V_SDL_'
                 || REPLACE (sp_name, ' ', '_')
                 || '_NE_STATS'
                 || ' ( batch_id, record_id, sld_key, '
                 || LISTAGG (sam_ne_column_name, ',')
                        WITHIN GROUP (ORDER BY sam_id)
                 || ',buffer_size, '
                 || 'pct_inside, '
                 || 'min_offset, '
                 || 'max_offset, '
                 || 'pct_std_dev, '
                 || 'pct_average, '
                 || 'pct_median, '
                 || ' geom '
                 || ' ) as select sld_sfs_id, sld_id, l.sld_key, '
                 || LISTAGG ('sld_col_' || sam_col_id, ',')
                        WITHIN GROUP (ORDER BY sam_id)
                 || ' , buffer_size, '
                 || 'nvl(pct_inside, -1), '
                 || 'min_offset, '
                 || 'max_offset, '
                 || 'pct_std_dev, '
                 || 'nvl(pct_average, -1), '
                 || 'pct_median, '
                 || 'l.sld_working_geometry '
                 || ' from sdl_load_data l, v_sdl_batch_accuracy a '
                 || ' where sld_sfs_id = batch_id '
                 || ' and sld_id = record_id '
                 || ' and sld_sfs_id IN (SELECT sfs_id FROM sdl_file_submissions '
                 || ' WHERE sfs_sp_id = '
                 || TO_CHAR (p_profile_id)
                 || ') '
                 || 'and sld_sfs_id = nvl(to_number(sys_context('
                 || qq
                 || 'NM3SQL'
                 || qq
                 || ', '
                 || qq
                 || 'SDLCTX_SFS_ID'
                 || qq
                 || ')),sld_sfs_id) '
            INTO p_view_sql
            FROM sdl_attribute_mapping, sdl_profiles
           WHERE sam_sp_id = sp_id AND sp_id = p_profile_id
        GROUP BY sp_name;

        --
        --        nm_debug.debug_on;
        --        nm_debug.debug (p_view_sql);

        EXECUTE IMMEDIATE p_view_sql;
    END gen_profile_ne_stats_view;

    --
    ----------------------------------------------------------------------------
    --
    FUNCTION get_hash_code (p_profile_id   IN NUMBER,
                            p_alias        IN VARCHAR2 DEFAULT NULL)
        RETURN VARCHAR2
    IS
        retval    VARCHAR2 (4000);
        l_alias   VARCHAR2 (10);
    BEGIN
        IF p_alias IS NOT NULL
        THEN
            l_alias := p_alias || '.';
        ELSE
            l_alias := NULL;
        END IF;

        SELECT 'ora_hash(' || l_alias || col_list || ')'
          INTO retval
          FROM (SELECT LISTAGG (sam_ne_column_name, '||' || l_alias)
                           WITHIN GROUP (ORDER BY sam_col_id)    col_list
                  FROM sdl_attribute_mapping
                 WHERE     sam_sp_id = p_profile_id
                       AND sam_ne_column_name IS NOT NULL);

        RETURN retval;
    END get_hash_code;

    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE gen_profile_match_view (p_profile_id   IN     NUMBER,
                                      p_view_sql        OUT VARCHAR2)
    IS
        l_profile_name        VARCHAR2 (30);
        l_nt_type             VARCHAR2 (4);
        l_load_hash_code      VARCHAR2 (4000) := get_hash_code (p_profile_id);
        l_element_hash_code   VARCHAR2 (4000)
                                  := get_hash_code (p_profile_id, 'e');
    BEGIN
        SELECT REPLACE (sp_name, ' ', '_'), nlt_nt_type
          INTO l_profile_name, l_nt_type
          FROM sdl_profiles, sdl_destination_header, nm_linear_types
         WHERE     sp_id = sdh_sp_id
               AND sdh_destination_location = 'N'
               AND sp_id = p_profile_id
               AND sdh_nlt_id = nlt_id;

        --

        p_view_sql :=
               'create or replace view V_SDL_'
            || l_profile_name
            || '_MATCHES'
            || ' ( batch_id, record_id, sld_key, ne_id, element_unique, load_unique ) '
            || ' as '
            || ' select batch_id, record_id, sld_key, e.ne_id, e.ne_unique element_unique, l.ne_unique load_unique from ( '
            || ' select '
            || l_load_hash_code
            || ' hash_code, batch_id, record_id, sld_key, ne_unique '
            || ' from V_SDL_'
            || l_profile_name
            || '_NE l '
            || ' ) l, nm_elements e '
            || ' where ne_nt_type = '
            || ''''
            || l_nt_type
            || ''''
            || ' and hash_code in ( '
            || l_element_hash_code
            || ' ) ';

        nm_debug.debug (p_view_sql);

        EXECUTE IMMEDIATE p_view_sql;
    END gen_profile_match_view;

    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE gen_profile_no_match_view (p_profile_id   IN     NUMBER,
                                         p_view_sql        OUT VARCHAR2)
    IS
        l_profile_name        VARCHAR2 (30);
        l_nt_type             VARCHAR2 (4);
        l_load_hash_code      VARCHAR2 (4000)
                                  := get_hash_code (p_profile_id, 'r');
        l_element_hash_code   VARCHAR2 (4000)
                                  := get_hash_code (p_profile_id, 'e');
    BEGIN
        SELECT REPLACE (sp_name, ' ', '_'), nlt_nt_type
          INTO l_profile_name, l_nt_type
          FROM sdl_profiles, sdl_destination_header, nm_linear_types
         WHERE     sp_id = sdh_sp_id
               AND sdh_destination_location = 'N'
               AND sp_id = p_profile_id
               AND sdh_nlt_id = nlt_id;

        p_view_sql :=
               'create or replace view v_sdl_'
            || l_profile_name
            || '_no_matches (batch_id, record_id, load_unique ) as '
            || ' select batch_id, record_id, ne_unique from V_SDL_'
            || l_profile_name
            || '_NE r '
            || ' where not exists ( select 1 from nm_elements e '
            || ' where '
            || l_element_hash_code
            || ' = '
            || l_load_hash_code
            || ')';

        nm_debug.debug (p_view_sql);

        EXECUTE IMMEDIATE p_view_sql;
    END gen_profile_no_match_view;

    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE gen_datum_view (p_profile IN NUMBER)
    IS
        sql_str              VARCHAR (32767);
        l_col_list           VARCHAR2 (4000);
        l_def_list           VARCHAR2 (4000);
        l_is_group_type      VARCHAR2 (1);
        l_nt_type            VARCHAR2 (4);
        l_gty_type           VARCHAR2 (4);
        l_profile_view       VARCHAR2 (30);
        l_profile_name       VARCHAR2 (30);
        l_dummy              NUMBER;
        l_datum_nt           VARCHAR2 (4);
        l_ne_length_exists   NUMBER (38) := 0;
        l_nt_type_exists     NUMBER (38) := 0;
        l_length_str         VARCHAR2 (1000)
            := 'sdo_lrs.geom_segment_end_measure(d.geom) - sdo_lrs.geom_segment_start_measure(d.geom)';
        qq                   CHAR (1) := CHR (39);
    BEGIN
        BEGIN
            SELECT UPPER ('V_SDL_' || REPLACE (sp_name, ' ', '_') || '_NE'),
                   sp_name,
                   CASE WHEN nlt_gty_type IS NULL THEN 'N' ELSE 'Y' END,
                   nlt_nt_type,
                   nlt_gty_type
              INTO l_profile_view,
                   l_profile_name,
                   l_is_group_type,
                   l_nt_type,
                   l_gty_type
              FROM sdl_profiles, sdl_destination_header, nm_linear_types
             WHERE     sp_id = sdh_sp_id
                   AND sdh_destination_location = 'N'
                   AND sp_id = p_profile
                   AND sdh_nlt_id = nlt_id;

            SELECT 1
              INTO l_dummy
              FROM dba_views
             WHERE     view_name = l_profile_view
                   AND owner = SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER');
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                raise_application_error (-20001, 'Profile not found');
        END;

        IF l_is_group_type = 'Y'
        THEN
            BEGIN
                SELECT nng_nt_type
                  INTO l_datum_nt
                  FROM nm_nt_groupings
                 WHERE nng_group_type = l_gty_type;
            EXCEPTION
                WHEN TOO_MANY_ROWS
                THEN
                    raise_application_error (
                        -20001,
                        'The SDL cannot manage group types composed of multiple datum types at present');
                WHEN NO_DATA_FOUND
                THEN
                    raise_application_error (
                        -20001,
                        'The datum type for this file-type cannot be found');
            END;

            SELECT LISTAGG (sdam_column_name, ',')
                       WITHIN GROUP (ORDER BY sdam_seq_no)
                       col_list,
                   LISTAGG (
                       CASE
                           WHEN sdam_default_value IS NULL THEN sdam_formula
                        --   ELSE '''' || sdam_default_value || ''''
                           ELSE sdam_default_value
                       END,
                       ',')
                   WITHIN GROUP (ORDER BY sdam_seq_no)
                       def_list,
                   MAX (
                       CASE sdam_column_name
                           WHEN 'NE_LENGTH' THEN 1
                           ELSE 0
                       END)
              INTO l_col_list, l_def_list, l_ne_length_exists
              FROM sdl_datum_attribute_mapping
             WHERE sdam_profile_id = p_profile;
        ELSE
            --datum type - use the natural view without need for the datum attribute mapping

            SELECT LISTAGG (sam_ne_column_name, ',')
                       WITHIN GROUP (ORDER BY sam_col_id)
                       col_list,
                   LISTAGG (sam_ne_column_name, ',')
                       WITHIN GROUP (ORDER BY sam_col_id)
                       def_list,
                   MAX (
                       CASE sam_ne_column_name
                           WHEN 'NE_LENGTH' THEN 1
                           ELSE 0
                       END),
                   MAX (
                       CASE sam_ne_column_name
                           WHEN 'NE_NT_TYPE' THEN 1
                           ELSE 0
                       END)
              INTO l_col_list,
                   l_def_list,
                   l_ne_length_exists,
                   l_nt_type_exists
              FROM sdl_attribute_mapping
             WHERE sam_sp_id = p_profile;
        END IF;

        sql_str :=
               'create or replace view v_sdl_wip_'
            || REPLACE (l_profile_name, ' ', '_')
            || '_datums '
            || ' ( batch_id, swd_id, SLD_KEY, DATUM_ID, pct_match, status, manual_override, GEOM, ';

        IF l_ne_length_exists = 0
        THEN
            sql_str := sql_str || 'ne_length, ';
        END IF;

        IF l_nt_type_exists = 0
        THEN
            sql_str := sql_str || 'ne_nt_type, ';
        END IF;

        sql_str :=
               sql_str
            || ' ne_no_start, ne_no_end, ne_type '
            || CASE
                   WHEN l_col_list IS NOT NULL THEN ', ' || l_col_list
                   ELSE NULL
               END
            || ' ) as '
            || ' select d.batch_id, d.swd_id, d.SLD_KEY, d.DATUM_ID, d.pct_match, d.status, d.manual_override,  d.GEOM, ';

        IF l_ne_length_exists = 0
        THEN
            sql_str := sql_str || l_length_str || ',';
        END IF;

        IF l_nt_type_exists = 0
        THEN
            sql_str := sql_str || '''' || l_datum_nt || ''',';
        END IF;

        sql_str :=
               sql_str
            || 'NULL, NULL, '
            || qq
            || 'S'
            || qq
            || CASE
                   WHEN l_def_list IS NOT NULL THEN ', ' || l_def_list
                   ELSE NULL
               END
            || ' from sdl_wip_datums d, '
            || l_profile_view
            || ' l where d.sld_key = l.sld_key ';

        nm_debug.debug_on;
        nm_debug.debug (sql_str);

        EXECUTE IMMEDIATE sql_str;
    END gen_datum_view;

    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE refresh_base_sdl_themes
    IS
    -- procedure to refresh base table metadat and thems relating to SDL geometry tables
    BEGIN
        IF g_srid IS NULL OR g_diminfo IS NULL
        THEN
            raise_application_error (
                -20001,
                'The network spatial metadata has not been configured please re-run this script when the configuration is complete so spatial indexes can be created');
        END IF;

        --first the base table of the load data

        insert_theme (p_theme_name          => 'BASE SDL LOAD DATA',
                      p_object_name         => 'SDL_LOAD_DATA',
                      p_base_theme_table    => NULL,
                      p_base_theme_column   => NULL,
                      p_key_name            => 'SLD_KEY',
                      p_geom_column_name    => 'SLD_WORKING_GEOMETRY',
                      p_role                => NULL,
                      p_dim                 => 3,
                      p_gtype               => 3002);

        insert_theme (p_theme_name          => 'ORIGINAL SDL SUBMISSION',
                      p_object_name         => 'V_SDL_LOAD_DATA',
                      p_base_theme_table    => 'SDL_LOAD_DATA',
                      p_base_theme_column   => 'SLD_WORKING_GEOMETRY',
                      p_key_name            => 'SLD_KEY',
                      p_geom_column_name    => 'SLD_WORKING_GEOMETRY',
                      p_role                => g_default_role,
                      p_dim                 => 3,
                      p_gtype               => 3002);
        --

        insert_theme (p_theme_name          => 'SDL DATUMS',
                      p_object_name         => 'SDL_WIP_DATUMS',
                      p_base_theme_table    => NULL,
                      p_base_theme_column   => NULL,
                      p_key_name            => 'SWD_ID',
                      p_geom_column_name    => 'GEOM',
                      p_role                => NULL,
                      p_dim                 => 3,
                      p_gtype               => 3002);

        insert_theme (p_theme_name          => 'SDL DATUMS AND STATS',
                      p_object_name         => 'V_SDL_DATUM_ACCURACY',
                      p_base_theme_table    => 'SDL_WIP_DATUMS',
                      p_base_theme_column   => 'GEOM',
                      p_key_name            => 'SWD_ID',
                      p_geom_column_name    => 'GEOM',
                      p_role                => g_default_role,
                      p_dim                 => 3,
                      p_gtype               => 3302);

        insert_theme (p_theme_name          => 'SDL TRANSFERRED DATUMS',
                      p_object_name         => 'V_SDL_TRANSFERRED_DATUMS',
                      p_base_theme_table    => '',
                      p_base_theme_column   => '',
                      p_key_name            => 'SWD_ID',
                      p_geom_column_name    => 'GEOM',
                      p_role                => g_default_role,
                      p_dim                 => 3,
                      p_gtype               => 3002);

        --now the base table of the wip nodes

        insert_theme (p_theme_name          => 'SDL NODE DATA',
                      p_object_name         => 'SDL_WIP_NODES',
                      p_base_theme_table    => NULL,
                      p_base_theme_column   => NULL,
                      p_key_name            => 'NODE_ID',
                      p_geom_column_name    => 'NODE_GEOM',
                      p_role                => NULL,
                      p_dim                 => 2,
                      p_gtype               => 2001);


        -- now the datums, queryable by batch

        --        insert_theme (p_theme_name          => 'SDL BATCH DATUM DATA',
        --                      p_object_name         => 'V_SDL_WIP_DATUMS',
        --                      p_base_theme_table    => 'V_SDL_WIP_DATUMS',
        --                      p_base_theme_column   => 'GEOM',
        --                      p_key_name            => 'SWD_ID',
        --                      p_geom_column_name    => 'GEOM',
        --                      p_role                => g_default_role,
        --                      p_dim                 => 3,
        --                      p_gtype               => 3302);



        --Now the nodes, queryable by batch
        insert_theme (p_theme_name          => 'SDL BATCH NODE DATA',
                      p_object_name         => 'V_SDL_WIP_NODES',
                      p_base_theme_table    => 'SDL_WIP_NODES',
                      p_base_theme_column   => 'NODE_GEOM',
                      p_key_name            => 'NODE_ID',
                      p_geom_column_name    => 'NODE_GEOM',
                      p_role                => g_default_role,
                      p_dim                 => 2,
                      p_gtype               => 2001);


        insert_theme (p_theme_name          => 'SDL MATCH DETAIL',
                      p_object_name         => 'V_SDL_PLINE_STATS',
                      p_base_theme_table    => NULL,
                      p_base_theme_column   => NULL,
                      p_key_name            => 'SLPS_PLINE_ID',
                      p_geom_column_name    => 'GEOM',
                      p_role                => g_default_role,
                      p_dim                 => 2,
                      p_gtype               => 2002);
    END refresh_base_sdl_themes;

    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE create_profile_themes (p_profile_id   IN INTEGER,
                                     p_role         IN VARCHAR2)
    IS
        l_sp_name   VARCHAR2 (50);
    BEGIN
        SELECT UPPER (REPLACE (sp_name, ' ', '_'))
          INTO l_sp_name
          FROM sdl_profiles
         WHERE sp_id = p_profile_id;

        insert_theme (
            p_theme_name          =>
                'SDL ' || UPPER (l_sp_name) || ' Load Statistics',
            p_object_name         => 'V_SDL_' || UPPER (l_sp_name) || '_LD_STATS',
            p_base_theme_table    => 'SLD_LOAD_DATA',
            p_base_theme_column   => 'SLD_WORKING_GEOMETRY',
            p_key_name            => 'SLD_KEY',
            p_geom_column_name    => 'GEOM',
            p_role                => p_role,
            p_dim                 => 3,
            p_gtype               => 3302);


        insert_theme (
            p_theme_name          => 'SDL ' || UPPER (l_sp_name) || ' NE Statistics',
            p_object_name         => 'V_SDL_' || UPPER (l_sp_name) || '_NE_STATS',
            p_base_theme_table    => 'SDL_LOAD_DATA',
            p_base_theme_column   => 'SLD_WORKING_GEOMETRY',
            p_key_name            => 'SLD_KEY',
            p_geom_column_name    => 'GEOM',
            p_role                => p_role,
            p_dim                 => 3,
            p_gtype               => 3002);


        insert_theme (
            p_theme_name          =>
                'SDL ' || UPPER (l_sp_name) || ' Datum Statistics',
            p_object_name         => 'V_SDL_WIP_' || UPPER (l_sp_name) || '_DATUMS',
            p_base_theme_table    => 'SDL_WIP_DATUMS',
            p_base_theme_column   => 'GEOM',
            p_key_name            => 'SWD_ID',
            p_geom_column_name    => 'GEOM',
            p_role                => p_role,
            p_dim                 => 3,
            p_gtype               => 3302);
    --
    END create_profile_themes;

    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE insert_sdo_metadata (p_table_name    IN VARCHAR2,
                                   p_column_name   IN VARCHAR2,
                                   p_diminfo          sdo_dim_array,
                                   p_srid             NUMBER)
    IS
    BEGIN
        INSERT INTO mdsys.sdo_geom_metadata_table (sdo_owner,
                                                   sdo_table_name,
                                                   sdo_column_name,
                                                   sdo_diminfo,
                                                   sdo_srid)
             VALUES (SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER'),
                     p_table_name,
                     p_column_name,
                     p_diminfo,
                     p_srid);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN
            NULL;
    END insert_sdo_metadata;

    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE drop_sdl_themes
    IS
    BEGIN
        --theme-roles, theme-gtypes are cascaded

        DELETE FROM nm_themes_all
              WHERE nth_feature_table IN ('V_SDL_WIP_DATUMS',
                                          'V_SDL_WIP_NODES',
                                          'V_SDL_PLINE_STATS',
                                          'V_SDL_BATCH_ACCURACY',
                                          'V_SDL_DATUM_ACCURACY');

        DELETE FROM mdsys.sdo_geom_metadata_table
              WHERE sdo_table_name IN
                        ('V_SDL_WIP_DATUMS',
                         'V_SDL_WIP_NODES',
                         'V_SDL_PLINE_STATS');

        DELETE FROM nm_themes_all
              WHERE nth_feature_table IN
                        (SELECT view_name
                           FROM all_views, sdl_profiles
                          WHERE     owner =
                                    SYS_CONTEXT ('NM3CORE',
                                                 'APPLICATION_OWNER')
                                AND view_name LIKE
                                           'V_SDL_%'
                                        || UPPER (
                                               REPLACE (sp_name, ' ', '_'))
                                        || '%');

        DELETE FROM mdsys.sdo_geom_metadata_table
              WHERE sdo_table_name IN
                        (SELECT view_name
                           FROM all_views, sdl_profiles
                          WHERE     owner =
                                    SYS_CONTEXT ('NM3CORE',
                                                 'APPLICATION_OWNER')
                                AND view_name LIKE
                                           'V_SDL_%'
                                        || UPPER (
                                               REPLACE (sp_name, ' ', '_'))
                                        || '%');

        DELETE FROM nm_themes_all
              WHERE nth_feature_table IN
                        ('SDL_LOAD_DATA', 'SDL_WIP_DATUMS', 'SDL_WIP_NODES');

        DELETE FROM mdsys.sdo_geom_metadata_table
              WHERE sdo_table_name IN
                        ('SDL_LOAD_DATA', 'SDL_WIP_DATUMS', 'SDL_WIP_NODES');
    END drop_sdl_themes;

    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE insert_theme (p_theme_name          IN VARCHAR2,
                            p_object_name         IN VARCHAR2,
                            p_base_theme_table    IN VARCHAR2,
                            p_base_theme_column   IN VARCHAR2,
                            p_key_name            IN VARCHAR2,
                            p_geom_column_name    IN VARCHAR2,
                            p_role                IN VARCHAR2,
                            p_dim                 IN NUMBER,
                            p_gtype               IN NUMBER)
    AS
    BEGIN
        BEGIN
            IF p_base_theme_table IS NOT NULL
            THEN
                INSERT INTO NM_THEMES_ALL (NTH_THEME_ID,
                                           NTH_THEME_NAME,
                                           NTH_TABLE_NAME,
                                           NTH_PK_COLUMN,
                                           NTH_LABEL_COLUMN,
                                           NTH_FEATURE_TABLE,
                                           NTH_FEATURE_PK_COLUMN,
                                           NTH_FEATURE_FK_COLUMN,
                                           NTH_FEATURE_SHAPE_COLUMN,
                                           NTH_HPR_PRODUCT,
                                           NTH_LOCATION_UPDATABLE,
                                           NTH_THEME_TYPE,
                                           NTH_DEPENDENCY,
                                           NTH_STORAGE,
                                           NTH_UPDATE_ON_EDIT,
                                           NTH_USE_HISTORY,
                                           NTH_BASE_TABLE_THEME,
                                           NTH_SEQUENCE_NAME,
                                           NTH_SNAP_TO_THEME,
                                           NTH_LREF_MANDATORY,
                                           NTH_TOLERANCE,
                                           NTH_TOL_UNITS,
                                           NTH_DYNAMIC_THEME)
                    SELECT nth_theme_id_seq.NEXTVAL,
                           p_theme_name,
                           p_object_name,
                           p_key_name,
                           p_key_name,
                           p_object_name,
                           p_key_name,
                           NULL,
                           p_geom_column_name,
                           'NET',
                           'N',
                           'SDO',
                           'I',
                           'S',
                           'N',
                           'N',
                           nth_theme_id,
                           NULL,
                           'N',
                           'N',
                           10,
                           1,
                           'N'
                      FROM nm_themes_all
                     WHERE     nth_feature_table = p_base_theme_table
                           AND EXISTS
                                   (SELECT 1
                                      FROM dba_objects
                                     WHERE     object_name = p_object_name
                                           AND owner =
                                               SYS_CONTEXT (
                                                   'NM3CORE',
                                                   'APPLICATION_OWNER'));
            ELSE
                INSERT INTO NM_THEMES_ALL (NTH_THEME_ID,
                                           NTH_THEME_NAME,
                                           NTH_TABLE_NAME,
                                           NTH_PK_COLUMN,
                                           NTH_LABEL_COLUMN,
                                           NTH_FEATURE_TABLE,
                                           NTH_FEATURE_PK_COLUMN,
                                           NTH_FEATURE_FK_COLUMN,
                                           NTH_FEATURE_SHAPE_COLUMN,
                                           NTH_HPR_PRODUCT,
                                           NTH_LOCATION_UPDATABLE,
                                           NTH_THEME_TYPE,
                                           NTH_DEPENDENCY,
                                           NTH_STORAGE,
                                           NTH_UPDATE_ON_EDIT,
                                           NTH_USE_HISTORY,
                                           NTH_BASE_TABLE_THEME,
                                           NTH_SEQUENCE_NAME,
                                           NTH_SNAP_TO_THEME,
                                           NTH_LREF_MANDATORY,
                                           NTH_TOLERANCE,
                                           NTH_TOL_UNITS,
                                           NTH_DYNAMIC_THEME)
                    SELECT nth_theme_id_seq.NEXTVAL,
                           p_theme_name,
                           p_object_name,
                           p_key_name,
                           p_key_name,
                           p_object_name,
                           p_key_name,
                           NULL,
                           p_geom_column_name,
                           'NET',
                           'N',
                           'SDO',
                           'I',
                           'S',
                           'N',
                           'N',
                           NULL,
                           NULL,
                           'N',
                           'N',
                           10,
                           1,
                           'N'
                      FROM DUAL
                     WHERE NOT EXISTS
                               (SELECT 1
                                  FROM nm_themes_all
                                 WHERE nth_feature_table = p_object_name);
            END IF;
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
                NULL;
            WHEN NO_DATA_FOUND
            THEN
                raise_application_error (
                    -20001,
                    'The base theme or profile view does not exist');
        END;

        BEGIN
            IF p_base_theme_table IS NOT NULL
            THEN
                INSERT INTO mdsys.sdo_geom_metadata_table (sdo_owner,
                                                           sdo_table_name,
                                                           sdo_column_name,
                                                           sdo_diminfo,
                                                           sdo_srid)
                    SELECT SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER'),
                           p_object_name,
                           p_geom_column_name,
                           sdo_diminfo,
                           sdo_srid
                      FROM mdsys.sdo_geom_metadata_table
                     WHERE     sdo_owner =
                               SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
                           AND sdo_table_name = p_base_theme_table
                           AND sdo_column_name = p_base_theme_column;
            ELSE
                INSERT INTO mdsys.sdo_geom_metadata_table (sdo_owner,
                                                           sdo_table_name,
                                                           sdo_column_name,
                                                           sdo_diminfo,
                                                           sdo_srid)
                    SELECT SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER'),
                           p_object_name,
                           p_geom_column_name,
                           CASE p_dim
                               WHEN 3 THEN g_diminfo
                               WHEN 2 THEN g_2d_diminfo
                           END,
                           g_srid
                      FROM DUAL;
            END IF;
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
                NULL;
        END;

        IF p_role IS NOT NULL
        THEN
            BEGIN
                INSERT INTO nm_theme_roles (nthr_theme_id,
                                            nthr_role,
                                            nthr_mode)
                    SELECT nth_theme_id, p_role, 'NORMAL'
                      FROM nm_themes_all
                     WHERE     nth_feature_table = p_object_name
                           AND NOT EXISTS
                                   (SELECT 1
                                      FROM nm_theme_roles, nm_themes_all
                                     WHERE     nth_feature_table =
                                               p_object_name
                                           AND nth_feature_shape_column =
                                               p_geom_column_name
                                           AND nthr_theme_id = nth_theme_id
                                           AND nthr_role = nthr_role
                                           AND nthr_mode = 'NORMAL');
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX
                THEN
                    NULL;
            END;
        END IF;


        INSERT INTO nm_theme_gtypes (ntg_theme_id,
                                     ntg_gtype,
                                     ntg_seq_no,
                                     ntg_xml_url)
            SELECT nth_theme_id,
                   p_gtype,
                   1,
                   NULL
              FROM nm_themes_all
             WHERE     nth_feature_table = p_object_name
                   AND NOT EXISTS
                           (SELECT 1
                              FROM nm_theme_gtypes
                             WHERE     ntg_theme_id = nth_theme_id
                                   AND ntg_gtype = p_gtype);
    END insert_theme;

    --
    ----------------------------------------------------------------------------
    --
    FUNCTION get_unique (p_nt_type IN VARCHAR2)
        RETURN VARCHAR2
    IS
        l_pop_unique   VARCHAR2 (1);
        retval         VARCHAR2 (2000);
    BEGIN
        SELECT nt_pop_unique
          INTO l_pop_unique
          FROM nm_types
         WHERE nt_type = p_nt_type;

        IF l_pop_unique = 'N'
        THEN
            retval := 'NE_UNIQUE';
        ELSE
            SELECT LISTAGG (ntc_column_name || ntc_separator, '||')
                       WITHIN GROUP (ORDER BY ntc_unique_seq)
              INTO retval
              FROM nm_type_columns
             WHERE ntc_nt_type = p_nt_type AND ntc_unique_seq IS NOT NULL;
        --
        END IF;

        RETURN retval;
    END;
END sdl_ddl;
/