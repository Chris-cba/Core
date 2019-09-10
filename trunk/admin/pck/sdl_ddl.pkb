CREATE OR REPLACE PACKAGE BODY sdl_ddl
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sdl_ddl.pkb-arc   1.6   Sep 10 2019 15:56:38   Rob.Coupe  $
    --       Module Name      : $Workfile:   sdl_ddl.pkb  $
    --       Date into PVCS   : $Date:   Sep 10 2019 15:56:38  $
    --       Date fetched Out : $Modtime:   Sep 10 2019 15:47:56  $
    --       PVCS Version     : $Revision:   1.6  $
    --
    --   Author : R.A. Coupe
    --
    --   Package for handling the generation of views and triggers to support the SDLh
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    --
    -- The main purpose of this package is to provide DDL execution for creation of views and triggers
    -- to support the SDL.

    g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.6  $';

    g_package_name   CONSTANT VARCHAR2 (30) := 'SDL_DDL';

    qq                        VARCHAR2 (1) := CHR (39);

    PROCEDURE insert_sdo_metadata (p_table_name    IN VARCHAR2,
                                   p_column_name   IN VARCHAR2,
                                   p_diminfo          sdo_dim_array,
                                   p_srid             NUMBER);

    PROCEDURE gen_profile_ld_view (p_profile_id   IN     NUMBER,
                                   p_view_sql        OUT VARCHAR2);

    PROCEDURE gen_profile_ne_view (p_profile_id   IN     NUMBER,
                                   p_view_sql        OUT VARCHAR2);

    --
    PROCEDURE gen_profile_ld_stats_view (p_profile_id   IN     NUMBER,
                                         p_view_sql        OUT VARCHAR2);

    PROCEDURE gen_profile_ne_stats_view (p_profile_id   IN     NUMBER,
                                         p_view_sql        OUT VARCHAR2);

    --

    FUNCTION get_version
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN g_sccsid;
    END get_version;

    FUNCTION get_body_version
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN g_body_sccsid;
    END get_body_version;

    PROCEDURE gen_sdl_profile_views (p_profile_id IN NUMBER)
    IS
        l_view_sql   VARCHAR2 (4000);
    BEGIN
        gen_profile_ld_view (p_profile_id, l_view_sql);

        gen_profile_ne_view (p_profile_id, l_view_sql);

        gen_profile_ld_stats_view (p_profile_id, l_view_sql);

        gen_profile_ne_stats_view (p_profile_id, l_view_sql);
    END;

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
                 || ', geom '
                 || ' ) as select sld_sfs_id, sld_id, sld_key, '
                 || LISTAGG ('sld_col_' || sam_col_id, ',')
                        WITHIN GROUP (ORDER BY sam_id)
                 || ', sld_load_geometry '
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
        nm_debug.debug_on;
        nm_debug.debug (p_view_sql);

        EXECUTE IMMEDIATE p_view_sql;
    --
    END;

    PROCEDURE gen_profile_ne_view (p_profile_id   IN     NUMBER,
                                   p_view_sql        OUT VARCHAR2)
    IS
    BEGIN
          SELECT    'create or replace view V_SDL_'
                 || REPLACE (sp_name, ' ', '_')
                 || '_NE'
                 || ' ( batch_id, record_id, sld_key, '
                 || LISTAGG (sam_ne_column_name, ',')
                        WITHIN GROUP (ORDER BY sam_id)
                 || ', geom '
                 || ' ) as select sld_sfs_id, sld_id, sld_key, '
                 || LISTAGG ('sld_col_' || sam_col_id, ',')
                        WITHIN GROUP (ORDER BY sam_id)
                 || ', sld_working_geometry '
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
        nm_debug.debug_on;
        nm_debug.debug (p_view_sql);

        EXECUTE IMMEDIATE p_view_sql;
    END;

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
                 || ' ) as select sld_sfs_id, sld_id, sld_key, '
                 || LISTAGG ('sld_col_' || sam_col_id, ',')
                        WITHIN GROUP (ORDER BY sam_id)
                 || ' , buffer_size, '
                 || 'nvl(pct_inside,-1), '
                 || 'min_offset, '
                 || 'max_offset, '
                 || 'pct_std_dev, '
                 || 'nvl(pct_average, -1), '
                 || 'pct_median, '
                 || 'sld_working_geometry '
                 || ' from sdl_load_data, v_sdl_batch_accuracy '
                 || ' where sld_sfs_id = batch_id (+) '
                 || ' and sld_id = record_id (+) '
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
        nm_debug.debug_on;
        nm_debug.debug (p_view_sql);

        EXECUTE IMMEDIATE p_view_sql;
    --
    END;


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
                 || ' ) as select sld_sfs_id, sld_id, sld_key, '
                 || LISTAGG ('sld_col_' || sam_col_id, ',')
                        WITHIN GROUP (ORDER BY sam_id)
                 || ' , buffer_size, '
                 || 'nvl(pct_inside, -1), '
                 || 'min_offset, '
                 || 'max_offset, '
                 || 'pct_std_dev, '
                 || 'nvl(pct_average, -1), '
                 || 'pct_median, '
                 || 'sld_working_geometry '
                 || ' from sdl_load_data, v_sdl_batch_accuracy '
                 || ' where sld_sfs_id = batch_id (+) '
                 || ' and sld_id = record_id (+) '
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
        nm_debug.debug_on;
        nm_debug.debug (p_view_sql);

        EXECUTE IMMEDIATE p_view_sql;
    END;

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
    END;


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
          FROM sdl_profiles, nm_linear_types
         WHERE sp_id = p_profile_id AND sp_nlt_id = nlt_id;

        --
        p_view_sql :=
               'create or replace view V_SDL_'
            || l_profile_name
            || '_MATCHES'
            || ' ( batch_id, record_id, ne_id, element_unique, load_unique ) '
            || ' as '
            || ' select batch_id, record_id, e.ne_id, e.ne_unique element_unique, l.ne_unique load_unique from ( '
            || ' select '
            || l_load_hash_code
            || ' hash_code, batch_id, record_id, ne_unique '
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
    END;

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
          FROM sdl_profiles, nm_linear_types
         WHERE sp_id = p_profile_id AND sp_nlt_id = nlt_id;

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
    END;

    PROCEDURE gen_datum_view (p_profile IN NUMBER)
    IS
        sql_str           VARCHAR (32767);
        l_col_list        VARCHAR2 (4000);
        l_def_list        VARCHAR2 (4000);
        l_is_group_type   VARCHAR2 (1);
        l_nt_type         VARCHAR2 (4);
        l_gty_type        VARCHAR2 (4);
        l_profile_view    VARCHAR2 (30);
        l_profile_name    VARCHAR2 (30);
        l_dummy           NUMBER;
        l_datum_nt        VARCHAR2 (4);
    BEGIN
        BEGIN
            SELECT UPPER ('V_SDL_' || sp_name || '_NE'),
                   sp_name,
                   CASE WHEN nlt_gty_type IS NULL THEN 'N' ELSE 'Y' END,
                   nlt_nt_type,
                   nlt_gty_type
              INTO l_profile_view,
                   l_profile_name,
                   l_is_group_type,
                   l_nt_type,
                   l_gty_type
              FROM sdl_profiles, nm_linear_types
             WHERE sp_id = p_profile AND sp_nlt_id = nlt_id;

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
                       WITHIN GROUP (ORDER BY sdam_seq_no)    col_list,
                   LISTAGG (
                       CASE
                           WHEN sdam_default_value IS NULL THEN sdam_formula
                           ELSE '''' || sdam_default_value || ''''
                       END,
                       ',')
                   WITHIN GROUP (ORDER BY sdam_seq_no)        def_list
              INTO l_col_list, l_def_list
              FROM sdl_datum_attribute_mapping
             WHERE sdam_profile_id = p_profile;
        ELSE
            --datum type - use the natural view without need for the datum attribute mapping

            SELECT LISTAGG (sam_ne_column_name, ',')
                       WITHIN GROUP (ORDER BY sam_col_id)    col_list,
                   LISTAGG (sam_ne_column_name, ',')
                       WITHIN GROUP (ORDER BY sam_col_id)    def_list
              INTO l_col_list, l_def_list
              FROM sdl_attribute_mapping
             WHERE sam_sp_id = p_profile;
        END IF;

        sql_str :=
               'create or replace view v_sdl_wip_'
            || l_profile_name
            || '_datums '
            || ' ( batch_id, swd_id, SLD_KEY, DATUM_ID, GEOM, ne_length_g, ne_no_start, ne_no_end, ne_type, ne_nt_type'
            || CASE
                   WHEN l_col_list IS NOT NULL THEN ', ' || l_col_list
                   ELSE NULL
               END
            || ' ) as '
            || ' select d.batch_id, d.swd_id, d.SLD_KEY, d.DATUM_ID, d.GEOM, sdo_lrs.geom_segment_end_measure(d.geom) - sdo_lrs.geom_segment_start_measure(d.geom), '
            || 'NULL, NULL, '
            || qq
            || 'S'
            || qq
            || ', '
            || qq
            || l_datum_nt
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
    END;

    PROCEDURE refresh_base_sdl_themes
    IS
        -- procedure to refresh base table metadat and thems relating to SDL geometry tables
        l_diminfo   sdo_dim_array;
        l_srid      NUMBER := NULL;
    BEGIN
        BEGIN
            l_diminfo := nm3sdo.coalesce_nw_diminfo;

            --
            SELECT sdo_srid
              INTO l_srid
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

        IF l_srid IS NULL OR l_diminfo IS NULL
        THEN
            raise_application_error (
                -20001,
                'The network spatial metadata has not been configured please re-run this script when the configuration is complete so spatial indexes can be created');
        END IF;

        BEGIN
            --first the base table of the load data

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
                       'BASE SDL_LOAD DATA',
                       'SDL_LOAD_DATA',
                       'SLD_KEY',
                       'SLD_KEY',
                       'SDL_LOAD_DATA',
                       'SLD_KEY',
                       NULL,
                       'SLD_WORKING_GEOMETRY',
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
                             WHERE nth_feature_table = 'SDL_LOAD_DATA');
        END;

        insert_sdo_metadata (P_TABLE_NAME    => 'SDL_LOAD_DATA',
                             P_COLUMN_NAME   => 'SLD_WORKING_GEOMETRY',
                             P_DIMINFO       => l_diminfo,
                             P_SRID          => l_srid);

        --
        --Now the base table of the WIP datums

        BEGIN
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
                       'BASE SDL DATUM DATA',
                       'SDL_WIP_DATUMS',
                       'SWD_ID',
                       'SWD_ID',
                       'SDL_WIP_DATUMS',
                       'SWD_ID',
                       NULL,
                       'GEOM',
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
                             WHERE nth_feature_table = 'SDL_WIP_DATUMS');
        END;

        --
        insert_sdo_metadata (P_TABLE_NAME    => 'SDL_WIP_DATUMS',
                             P_COLUMN_NAME   => 'GEOM',
                             P_DIMINFO       => l_diminfo,
                             P_SRID          => l_srid);

        --now the base table of the wip nodes
        BEGIN
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
                       'SDL NODE DATA',
                       'SDL_WIP_NODES',
                       'NODE_ID',
                       'NODE_ID',
                       'SDL_WIP_NODES',
                       'NODE_ID',
                       NULL,
                       'NODE_GEOM',
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
                             WHERE nth_feature_table = 'SDL_WIP_NODES');
        END;

        insert_sdo_metadata (P_TABLE_NAME    => 'SDL_WIP_NODES',
                             P_COLUMN_NAME   => 'GEOM',
                             P_DIMINFO       => l_diminfo,
                             P_SRID          => l_srid);


        -- now the datums, queryable by batch

        BEGIN
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
                       'SDL BATCH DATUM DATA',
                       'V_SDL_WIP_DATUMS',
                       'SWD_ID',
                       'SWD_ID',
                       'V_SDL_WIP_DATUMS',
                       'SWD_ID',
                       NULL,
                       'GEOM',
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
                 WHERE     nth_feature_table = 'SDL_WIP_DATUMS'
                       AND NOT EXISTS
                               (SELECT 1
                                  FROM nm_themes_all
                                 WHERE nth_feature_table = 'V_SDL_WIP_DATUMS');
        END;

        --
        insert_sdo_metadata (P_TABLE_NAME    => 'V_SDL_WIP_DATUMS',
                             P_COLUMN_NAME   => 'GEOM',
                             P_DIMINFO       => l_diminfo,
                             P_SRID          => l_srid);


        --Now the nodes, queryable by batch
        BEGIN
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
                       'SDL BATCH NODE DATA',
                       'V_SDL_WIP_NODES',
                       'NODE_ID',
                       'NODE_ID',
                       'V_SDL_WIP_NODES',
                       'NODE_ID',
                       NULL,
                       'NODE_GEOM',
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
                 WHERE     nth_feature_table = 'SDL_WIP_NODES'
                       AND NOT EXISTS
                               (SELECT 1
                                  FROM nm_themes_all
                                 WHERE nth_feature_table = 'V_SDL_WIP_NODES');
        END;

        insert_sdo_metadata (P_TABLE_NAME    => 'V_SDL_WIP_NODES',
                             P_COLUMN_NAME   => 'GEOM',
                             P_DIMINFO       => l_diminfo,
                             P_SRID          => l_srid);

        BEGIN
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
                       'SDL Match Detail',
                       'V_SDL_PLINE_STATS',
                       'SLPS_PLINE_ID',
                       'SLPS_PLINE_ID',
                       'V_SDL_PLINE_STATS',
                       'SLPS_PLINE_ID',
                       NULL,
                       'GEOM',
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
                             WHERE nth_feature_table = 'V_SDL_PLINE_STATS');
        END;

        insert_sdo_metadata (P_TABLE_NAME    => 'V_SDL_PLINE_STATS',
                             P_COLUMN_NAME   => 'GEOM',
                             P_DIMINFO       => l_diminfo,
                             P_SRID          => l_srid);
    END;

    PROCEDURE create_profile_themes (p_profile_id   IN INTEGER,
                                     p_role         IN VARCHAR2)
    IS
        l_sp_name   VARCHAR2 (30);
    BEGIN
        SELECT UPPER (sp_name)
          INTO l_sp_name
          FROM sdl_profiles
         WHERE sp_id = p_profile_id;

        BEGIN
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
                       'SDL ' || UPPER (sp_name) || ' Load Statistics',
                       'V_SDL_' || UPPER (sp_name) || '_LD_STATS',
                       'SLD_KEY',
                       'SLD_KEY',
                       'V_SDL_' || UPPER (sp_name) || '_LD_STATS',
                       'SLD_KEY',
                       NULL,
                       'GEOM',
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
                  FROM sdl_profiles
                 WHERE     sp_id = p_profile_id
                       AND EXISTS
                               (SELECT 1
                                  FROM dba_views
                                 WHERE     view_name =
                                              'V_SDL_'
                                           || UPPER (sp_name)
                                           || '_LD_STATS'
                                       AND owner =
                                           SYS_CONTEXT ('NM3CORE',
                                                        'APPLICATION_OWNER'));
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
                NULL;
            WHEN NO_DATA_FOUND
            THEN
                raise_application_error (
                    -20001,
                    'The profile or base profile view does not exist');
        END;

        BEGIN
            INSERT INTO mdsys.sdo_geom_metadata_table (sdo_owner,
                                                       sdo_table_name,
                                                       sdo_column_name,
                                                       sdo_diminfo,
                                                       sdo_srid)
                SELECT SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER'),
                       'V_SDL_' || l_sp_name || '_LD_STATS',
                       'GEOM',
                       sdo_diminfo,
                       sdo_srid
                  FROM mdsys.sdo_geom_metadata_table
                 WHERE     sdo_owner =
                           SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
                       AND sdo_table_name = 'SDL_LOAD_DATA'
                       AND sdo_column_name = 'SLD_WORKING_GEOMETRY';
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
                NULL;
        END;

        BEGIN
            INSERT INTO nm_theme_roles (nthr_theme_id, nthr_role, nthr_mode)
                SELECT nth_theme_id, p_role, 'NORMAL'
                  FROM nm_themes_all, sdl_profiles
                 WHERE     sp_id = p_profile_id
                       AND nth_feature_table =
                           'V_SDL_' || UPPER (sp_name) || '_LD_STATS'
                       AND NOT EXISTS
                               (SELECT 1
                                  FROM nm_theme_roles, nm_themes_all
                                 WHERE     nth_feature_table =
                                              'V_SDL_'
                                           || UPPER (sp_name)
                                           || '_LD_STATS'
                                       AND nth_feature_shape_column = 'GEOM'
                                       AND nthr_theme_id = nth_theme_id
                                       AND nthr_role = nthr_role
                                       AND nthr_mode = 'NORMAL');
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
                NULL;
        END;

        BEGIN
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
                       'SDL ' || UPPER (sp_name) || ' NE Statistics',
                       'V_SDL_' || UPPER (sp_name) || '_NE_STATS',
                       'SLD_KEY',
                       'SLD_KEY',
                       'V_SDL_' || UPPER (sp_name) || '_NE_STATS',
                       'SLD_KEY',
                       NULL,
                       'GEOM',
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
                  FROM sdl_profiles
                 WHERE     sp_id = p_profile_id
                       AND EXISTS
                               (SELECT 1
                                  FROM dba_views
                                 WHERE     view_name =
                                              'V_SDL_'
                                           || UPPER (sp_name)
                                           || '_NE_STATS'
                                       AND owner =
                                           SYS_CONTEXT ('NM3CORE',
                                                        'APPLICATION_OWNER'));
        --
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
                NULL;
            WHEN NO_DATA_FOUND
            THEN
                raise_application_error (
                    -20001,
                    'The profile or base profile view does not exist');
        END;

        INSERT INTO nm_theme_roles (nthr_theme_id, nthr_role, nthr_mode)
            SELECT nth_theme_id, p_role, 'NORMAL'
              FROM nm_themes_all, sdl_profiles
             WHERE     sp_id = p_profile_id
                   AND nth_feature_table =
                       'V_SDL_' || UPPER (sp_name) || '_NE_STATS'
                   AND NOT EXISTS
                           (SELECT 1
                              FROM nm_theme_roles, nm_themes_all
                             WHERE     nth_feature_table =
                                          'V_SDL_'
                                       || UPPER (sp_name)
                                       || '_NE_STATS'
                                   AND nth_feature_shape_column = 'GEOM'
                                   AND nthr_theme_id = nth_theme_id
                                   AND nthr_role = nthr_role
                                   AND nthr_mode = 'NORMAL');

        BEGIN
            INSERT INTO mdsys.sdo_geom_metadata_table (sdo_owner,
                                                       sdo_table_name,
                                                       sdo_column_name,
                                                       sdo_diminfo,
                                                       sdo_srid)
                SELECT SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER'),
                       'V_SDL_' || l_sp_name || '_NE_STATS',
                       'GEOM',
                       sdo_diminfo,
                       sdo_srid
                  FROM mdsys.sdo_geom_metadata_table
                 WHERE     sdo_owner =
                           SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
                       AND sdo_table_name = 'SDL_LOAD_DATA'
                       AND sdo_column_name = 'SLD_WORKING_GEOMETRY';
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
                NULL;
        END;
    --
    END;

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
             VALUES (SYS_CONTEXT ('Nm3CORE', 'APPLICATION_OWNER'),
                     p_table_name,
                     p_column_name,
                     p_diminfo,
                     p_srid);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN
            NULL;
    END;

    PROCEDURE drop_sdl_themes
    IS
    BEGIN
        DELETE FROM nm_themes_all
              WHERE nth_feature_table IN
                        ('V_SDL_WIP_DATUMS',
                         'V_SDL_WIP_NODES',
                         'V_SDL_PLINE_STATS');

        DELETE FROM mdsys.sdo_geom_metadata_table
              WHERE sdo_table_name IN
                        ('V_SDL_WIP_DATUMS',
                         'V_SDL_WIP_NODES',
                         'V_SDL_PLINE_STATS');

        DELETE FROM nm_themes_all
              WHERE nth_feature_table in
                        (SELECT view_name from all_views, sdl_profiles where owner = sys_context('NM3CORE', 'APPLICATION_OWNER') and view_name like 'V_SDL_%' || UPPER (sp_name) || '%' );

        DELETE FROM mdsys.sdo_geom_metadata_table
              WHERE sdo_table_name in
                        (SELECT view_name from all_views, sdl_profiles where owner = sys_context('NM3CORE', 'APPLICATION_OWNER') and view_name like 'V_SDL_%' || UPPER (sp_name) || '%' );

        DELETE FROM nm_themes_all
              WHERE nth_feature_table IN
                        ('SDL_LOAD_DATA', 'SDL_WIP_DATUMS', 'SDL_WIP_NODES');

        DELETE FROM mdsys.sdo_geom_metadata_table
              WHERE sdo_table_name IN
                        ('SDL_LOAD_DATA', 'SDL_WIP_DATUMS', 'SDL_WIP_NODES');
    END;
END sdl_ddl;
/