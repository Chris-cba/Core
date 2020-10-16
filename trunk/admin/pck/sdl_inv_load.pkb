CREATE OR REPLACE PACKAGE BODY sdl_inv_load
AS
    --
    -----------------------------------------------------------------------------
    --
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sdl_inv_load.pkb-arc   1.2   Oct 16 2020 23:04:02   Rob.Coupe  $
    --       Module Name      : $Workfile:   sdl_inv_load.pkb  $
    --       Date into PVCS   : $Date:   Oct 16 2020 23:04:02  $
    --       Date fetched Out : $Modtime:   Oct 16 2020 23:03:26  $
    --       PVCS Version     : $Revision:   1.2  $
    --
    --   Author : Rob Coupe
    --
    --   Package of code relating to the loading of data from TDL Holding tables/views into the inventory
    --   and location database.
    --
    -----------------------------------------------------------------------------
    --   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
    -----------------------------------------------------------------------------
    --
    g_body_sccsid   CONSTANT VARCHAR2 (2000) := '$Revision:   1.2  $';

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

    PROCEDURE load_data (p_sp_id            IN     NUMBER,
                         p_sdh_id           IN     NUMBER,
                         p_sfs_id           IN     NUMBER,
                         p_rows_processed      OUT NUMBER)
    IS
        l_sp_row          sdl_profiles%ROWTYPE;
        l_sdh_row         sdl_destination_header%ROWTYPE;
        --
        l_relation_id     NUMBER (38);
        l_sequence_name   VARCHAR2 (30);

        l_view_name       VARCHAR2 (200);

        l_source_table    VARCHAR2 (200);
        l_source_alias    VARCHAR2 (30);

        l_view_list       VARCHAR2 (32767);
        l_dest_list       VARCHAR2 (32767);

        l_read_only       VARCHAR2 (1);

        l_theme_flag      VARCHAR2 (1);

        l_nth_row         nm_themes_all%ROWTYPE;

        l_base_theme      nm_themes_all%ROWTYPE;


        l_sql             VARCHAR2 (32767);

        qq                CHAR (1) := CHR (39);
    --
    BEGIN
        SELECT *
          INTO l_sp_row
          FROM sdl_profiles
         WHERE sp_id = p_sp_id;

        SELECT *
          INTO l_sdh_row
          FROM sdl_destination_header
         WHERE sdh_id = p_sdh_id;

        l_view_name :=
               'V_TDL_'
            || p_sp_id
            || '_'
            || p_sdh_id
            || '_'
            || l_sdh_row.sdh_destination_type
            || '_LD';

        BEGIN
            SELECT parent_sam_id, sequence_name
              INTO l_relation_id, l_sequence_name
              FROM V_TDL_DESTINATION_RELATIONS
             WHERE sp_id = p_sp_id;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;

        IF l_sdh_row.sdh_destination_location = 'N'
        THEN
            IF l_relation_id IS NOT NULL AND l_sequence_name IS NOT NULL
            THEN
                l_sql :=
                       'insert into sdl_destination_links (sdl_link_id, sdl_sdr_id, sdl_sfs_id, sdl_tld_id, sdl_link_value ) '
                    || 'select sdl_link_id_seq.nextval, '
                    || l_relation_id
                    || ', tld_sfs_id, tld_id, '
                    || l_sequence_name
                    || ' from '
                    || l_view_name
                    || ' v '
                    || ' where tld_sfs_id = :p_sfs_id '
                    || ' and not exists ( select 1 from sdl_destination_links l where l.sdl_sfs_id = :p_sfs_id and l.sdl_tld_id = v.tld_id ) ';

                nm_debug.debug (l_sql);

                EXECUTE IMMEDIATE l_sql USING p_sfs_id, p_sfs_id;
            END IF;

            -- Test if we are inserting into a read-only view

            BEGIN
                l_read_only := 'N';

                SELECT read_only
                  INTO l_read_only
                  FROM all_views, nm_inv_types
                 WHERE     owner =
                           SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
                       AND view_name = 'V_NM_' || nit_inv_type
                       AND nit_inv_type = l_sdh_row.sdh_destination_type;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    l_read_only := 'N';
            END;


            IF l_read_only = 'N'
            THEN
                -- grab destination columns and view columns to create the insert statement

                WITH
                    attribs
                    AS
                        (SELECT sam_id,
                                sam_col_id,
                                sam_view_column_name,
                                sam_ne_column_name
                           FROM sdl_attribute_mapping
                          WHERE sam_sdh_id = p_sdh_id AND sam_sp_id = p_sp_id),
                    column_lists
                    AS
                        (SELECT sam_col_id,
                                sam_view_column_name view_column,
                                sam_ne_column_name   destination_column
                           FROM attribs)
                --
                SELECT LISTAGG (view_column, ',')
                           WITHIN GROUP (ORDER BY sam_col_id),
                       LISTAGG (destination_column, ',')
                           WITHIN GROUP (ORDER BY sam_col_id)
                  INTO l_view_list, l_dest_list
                  FROM column_lists;

                l_sql :=
                       'insert into '
                    || l_sdh_row.sdh_table_name
                    || ' ( '
                    || l_dest_list
                    || ' ) '
                    || ' select '
                    || l_view_list
                    || ' from '
                    || l_view_name
                    || ' where tld_sfs_id = :p_sfs_id '
                    || ' and exists ( select 1 from SDL_ROW_STATUS where srs_sp_id = :p_sp_id '
                    || ' and srs_sfs_id = :p_sfs_id and srs_status = '
                    || qq
                    || 'V'
                    || qq
                    || ')';

                BEGIN
                    nm_debug.debug (l_sql);
                END;

                DECLARE
                    invalid_metadata   EXCEPTION;
                    PRAGMA EXCEPTION_INIT (invalid_metadata, -904); --invalid identifier/column issue
                BEGIN
                    EXECUTE IMMEDIATE l_sql USING p_sfs_id, p_sp_id, p_sfs_id;

                    p_rows_processed := SQL%ROWCOUNT;
                EXCEPTION
                    WHEN invalid_metadata
                    THEN
                        raise_application_error (
                            -20001,
                            'Error in the metadata results in erroneous insert so the load fails');
                END;
            ELSE
                -- handle the read-only view

                WITH
                    attribs
                    AS
                        (SELECT sam_id,
                                sam_col_id,
                                sam_view_column_name,
                                CASE
                                    WHEN ita_attrib_name IS NULL
                                    THEN
                                        sam_ne_column_name
                                    ELSE
                                        ita_attrib_name
                                END
                                    sam_ne_column_name
                           FROM sdl_attribute_mapping, nm_inv_type_attribs
                          WHERE     sam_sdh_id = p_sdh_id
                                AND sam_sp_id = p_sp_id
                                AND ita_inv_type(+) =
                                    l_sdh_row.sdh_destination_type
                                AND ita_view_attri(+) = sam_ne_column_name),
                    column_lists
                    AS
                        (SELECT sam_col_id,
                                sam_view_column_name view_column,
                                sam_ne_column_name   destination_column
                           FROM attribs)
                --
                SELECT LISTAGG (view_column, ',')
                           WITHIN GROUP (ORDER BY sam_col_id),
                       LISTAGG (destination_column, ',')
                           WITHIN GROUP (ORDER BY sam_col_id)
                  INTO l_view_list, l_dest_list
                  FROM column_lists;

                l_sql :=
                       'insert into '
                    || 'NM_INV_ITEMS_ALL'
                    || ' ( '
                    || l_dest_list
                    || ' ) '
                    || ' select '
                    || l_view_list
                    || ' from '
                    || l_view_name
                    || ' where tld_sfs_id = :p_sfs_id '
                    || ' and exists ( select 1 from SDL_ROW_STATUS where srs_sp_id = :p_sp_id '
                    || ' and srs_sfs_id = :p_sfs_id and srs_status = '
                    || qq
                    || 'V'
                    || qq
                    || ')';

                BEGIN
                    nm_debug.debug (l_sql);
                END;

                DECLARE
                    invalid_metadata   EXCEPTION;
                    PRAGMA EXCEPTION_INIT (invalid_metadata, -904); --invalid identifier/column issue
                BEGIN
                    EXECUTE IMMEDIATE l_sql USING p_sfs_id, p_sp_id, p_sfs_id;

                    p_rows_processed := SQL%ROWCOUNT;
                EXCEPTION
                    WHEN invalid_metadata
                    THEN
                        raise_application_error (
                            -20001,
                            'Error in the metadata results in erroneous insert so the load fails');
                END;
            END IF;
        ELSE
            -- we are loading the location data - first consider route and reference point

            IF l_sdh_row.sdh_table_name = 'V_LOAD_INV_MEM_ON_ELEMENT'
            THEN
                DECLARE
                    l_iit                  nm3type.tab_number;
                    l_of                   nm3type.tab_number;
                    l_start                nm3type.tab_number;
                    l_end                  nm3type.tab_number;
                    l_date                 NM3TYPE.tab_date;
                    l_dir                  nm3type.tab_number;
                    l_element_start_date   NM3TYPE.tab_date;
                BEGIN
                    l_sql :=
                           'select iit_ne_id, refnt, start_m, nm_start_date, end_m, dir_flag, datum_start_date '
                        || ' from ( select /*+MATERIALIZE*/ iit_ne_id, refnt, start_m, end_m, nm_start_date, dir_flag, d.ne_start_date datum_start_date '
                        || ' from '
                        || l_view_name
                        || ' l, nm_elements r, table(lb_get.get_lb_rpt_d_tab(lb_rpt_tab(lb_rpt(r.ne_id, 1, :p_dest_type, iit_ne_id, 1, 1, 1, begin_mp, end_mp, 4  )))) t, '
                        || ' nm_elements d '
                        || ' where tld_sfs_id = :p_sfs_id '
                        || ' and l.ne_unique = r.ne_unique '
                        || ' and r.ne_nt_type = :p_route_type '
                        || ' and d.ne_id = refnt )';

                    EXECUTE IMMEDIATE l_sql
                        BULK COLLECT INTO l_iit,
                             l_of,
                             l_start,
                             l_date,
                             l_end,
                             l_dir,
                             l_element_start_date
                        USING l_sdh_row.sdh_destination_type, p_sfs_id, 'RTE';

                    nm3ctx.set_context ('BYPASS_MEMBERS_SDO_TRG', 'Y');

                    --
                    FORALL idx IN 1 .. l_iit.COUNT
                        INSERT INTO nm_members (nm_ne_id_in,
                                                nm_ne_id_of,
                                                nm_obj_type,
                                                nm_type,
                                                nm_begin_mp,
                                                nm_end_mp,
                                                nm_start_date,
                                                nm_cardinality,
                                                nm_admin_unit)
                                 VALUES (
                                            l_iit (idx),
                                            l_of (idx),
                                            l_sdh_row.sdh_destination_type,
                                            'I',
                                            l_start (idx),
                                            l_end (idx),
                                            GREATEST (
                                                l_date (idx),
                                                l_element_start_date (idx)),
                                            l_dir (idx),
                                            1);

                    -- grab theme data for the asset-type - check if a derived (dyn-segged) asset type

                    BEGIN
                        SELECT t.*
                          INTO l_nth_row
                          FROM nm_themes_all t, nm_inv_themes
                         WHERE     nith_nit_id =
                                   l_sdh_row.sdh_destination_type
                               AND nith_nth_theme_id = nth_theme_id
                               AND nth_base_table_theme IS NULL;

                        l_theme_flag := 'Y';
                    EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                            l_theme_flag := 'N';
                    END;

                    IF l_theme_flag = 'Y'
                    THEN
                        -- work out if translation is requred from route measures to datums and translate if necessary

                        -- insert geometry into the geometry table - use a simple insert statement but it will need coding in a loop with a limit/count

                        SELECT i.*
                          INTO l_base_theme
                          FROM nm_themes_all  d,
                               nm_themes_all  i,
                               nm_base_themes
                         WHERE     d.nth_theme_id = l_nth_row.nth_theme_id
                               AND d.nth_theme_id = nbth_theme_id
                               AND nbth_base_theme = i.nth_theme_id;

                        l_sql :=
                               'insert into '
                            || l_nth_row.nth_feature_table
                            || ' ( objectid, ne_id, ne_id_of, nm_begin_mp, nm_end_mp, start_date, '
                            || l_nth_row.nth_feature_shape_column
                            || ' ) '
                            || ' select '
                            || l_nth_row.nth_sequence_name
                            || '.nextval, t.obj_id, refnt, start_m, end_m, greatest(d.ne_start_date, nm_start_date), '
                            || ' sdo_lrs.clip_geom_segment( '
                            || l_base_theme.nth_feature_shape_column
                            || ', start_m, end_m, 0.005) '
                            || ' from '
                            || l_view_name
                            || ' l, nm_elements r, table(lb_get.get_lb_rpt_d_tab(lb_rpt_tab(lb_rpt(r.ne_id, 1, :p_dest_type, iit_ne_id, 1, 1, 1, begin_mp, end_mp, 4  )))) t, '
                            || '  nm_elements d, '||l_base_theme.nth_feature_table||' s '
                            || ' where tld_sfs_id = :p_sfs_id '
                            || '  and l.ne_unique = r.ne_unique '
                            || ' and r.ne_nt_type = :p_route_type '
                            || ' and d.ne_id = refnt '||
                            ' and d.ne_id = s.'||l_base_theme.nth_feature_pk_column;
                            
                            nm_debug.debug(l_sql);
                            
                            execute immediate l_sql using l_sdh_row.sdh_destination_type, p_sfs_id, 'RTE';

                    END IF;

                    nm3ctx.set_context ('BYPASS_MEMBERS_SDO_TRG', 'N');
                END;

                p_rows_processed := SQL%ROWCOUNT;
            END IF;
        END IF;

        UPDATE sdl_row_status
           SET srs_status = 'I'
         WHERE     srs_sfs_id = p_sfs_id
               AND srs_status = 'V'
               AND EXISTS
                       (SELECT 1
                          FROM sdl_destination_links
                         WHERE     srs_sp_id = p_sp_id
                               AND srs_sfs_id = p_sfs_id
                               AND sdl_sfs_id = srs_sfs_id
                               AND sdl_tld_id = srs_tld_id
                               AND EXISTS
                                       (SELECT 1
                                          FROM nm_inv_items_all
                                         WHERE iit_ne_id = sdl_link_value));
    END;
END;
/
