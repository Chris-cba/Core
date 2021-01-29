CREATE OR REPLACE PACKAGE BODY sdl_inv_ddl
AS
    --
    -----------------------------------------------------------------------------
    --
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sdl_inv_ddl.pkb-arc   1.4   Jan 29 2021 17:15:48   Vikas.Mhetre  $
    --       Module Name      : $Workfile:   sdl_inv_ddl.pkb  $
    --       Date into PVCS   : $Date:   Jan 29 2021 17:15:48  $
    --       Date fetched Out : $Modtime:   Jan 28 2021 17:59:46  $
    --       PVCS Version     : $Revision:   1.4  $
    --
    --   Author : Rob Coupe
    --
    --   The package forms part of the spatial/transporattion data loader and is responsible
    --   for object creations such as container-based tables and destination views
    --
    -----------------------------------------------------------------------------
    --   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
    -----------------------------------------------------------------------------
    --
    g_body_sccsid   CONSTANT VARCHAR2 (2000) := '$Revision:   1.4  $';

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

    PROCEDURE create_tdl_profile_tables (p_sp_id IN NUMBER)
    IS
    BEGIN
        FOR irec IN (  SELECT sp_id,
                              sp_name,
                              spfc_container,
                              COUNT (*) OVER (PARTITION BY sp_id)     rc
                         FROM sdl_profile_file_columns, sdl_profiles
                        WHERE sp_id = spfc_sp_id AND sp_id = p_sp_id
                     GROUP BY sp_id, sp_name, spfc_container)
        LOOP
            BEGIN
                create_tdl_container_table (irec.sp_name,
                                            irec.spfc_container,
                                            irec.rc);
            END;
        END LOOP;
    END;


    PROCEDURE create_tdl_container_table (p_sp_name     IN VARCHAR2,
                                          p_container   IN VARCHAR2,
                                          p_rowcount    IN NUMBER)
    IS
        l_sql            VARCHAR2 (32767);
        l_owner          VARCHAR2 (30)
                             := SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER');
        l_table_name     VARCHAR2 (60)
            :=    'TDL_'
               || replace(p_sp_name, ' ', '_')
               || CASE p_rowcount
                      WHEN 1 THEN NULL
                      ELSE '_' || p_container
                  END
               || '_LD';
        l_pk_name        VARCHAR2 (30)
            := 'TDL_' || replace(p_sp_name, ' ','_') || '_' || p_container || '_LD_PK';
        l_uk_name        VARCHAR2 (30)
            := 'TDL_' || replace(p_sp_name, ' ','_') || '_' || p_container || '_LD_UK';

        already_exists   EXCEPTION;
        PRAGMA EXCEPTION_INIT (already_exists, -955); -- name is already used by an existing objec
    --
    BEGIN
          --
          drop_tdl_table(l_table_name);
          --
          SELECT    'create table '
                 || l_owner
                 || '.'
                 || l_table_name
                 || ' ( '
                 || ' tld_sfs_id number(38) not null, tld_id number(38) not null, '
                 || LISTAGG (
                           spfc_col_name
                        || ' '
                        || spfc_col_datatype
                        || CASE
                               WHEN spfc_col_size IS NOT NULL
                               THEN
                                   '(' || spfc_col_size || ')'
                               ELSE
                                   NULL
                           END,
                        ',')
                    WITHIN GROUP (ORDER BY spfc_col_id)
                 || ')'
            INTO l_sql
            FROM sdl_profile_file_columns, sdl_profiles
           WHERE     spfc_sp_id = sp_id
                 AND sp_name = p_sp_name
                 AND spfc_container = p_container
        GROUP BY sp_name, spfc_container;

        --
        --nm_debug.debug(l_sql);
        BEGIN
            EXECUTE IMMEDIATE l_sql;
        EXCEPTION
            WHEN already_exists
            THEN
                NULL;
        END;

        --
        l_sql :=
               'ALTER TABLE '
            || l_owner
            || '.'
            || l_table_name
            || ' ADD '
            || ' CONSTRAINT '
            || l_pk_name
            || ' PRIMARY KEY (TLD_ID) '
            || ' ENABLE ';

nm_debug.debug(l_sql);

        EXECUTE IMMEDIATE l_sql;

        l_sql :=
               'ALTER TABLE '
            || l_owner
            || '.'
            || l_table_name
            || ' ADD '
            || ' CONSTRAINT '
            || l_uk_name
            || ' UNIQUE (TLD_SFS_ID, TLD_ID) '
            || ' ENABLE ';

        EXECUTE IMMEDIATE l_sql;

        l_sql :=
               'CREATE SEQUENCE '
            || l_owner
            || '.'
            || l_table_name
            || '_SEQ start with 1';

        EXECUTE IMMEDIATE l_sql;
    --
    END;


    PROCEDURE create_tdl_profile_views (p_sp_id IN NUMBER)
    IS
    BEGIN
        FOR irec IN (  SELECT sp_id,
                              sp_name,
                              sdh_id,
                              sdh_destination_type
                         FROM V_TDL_DESTINATION_ORDER, sdl_profiles
                        WHERE sp_id = sdh_sp_id AND sp_id = p_sp_id
                     ORDER BY sdh_seq_no)
        LOOP
            BEGIN
                create_tdl_destination_view (irec.sp_id, irec.sdh_id);
            END;
        END LOOP;
    END;


    PROCEDURE create_tdl_destination_view (p_sp_id    IN NUMBER,
                                           p_sdh_id   IN NUMBER)
    IS
        l_sp_row          sdl_profiles%ROWTYPE;
        l_sdh_row         sdl_destination_header%ROWTYPE;
        --
        l_view_name       VARCHAR2 (200);

        l_source_table    VARCHAR2 (200);
        l_source_alias    VARCHAR2 (30);

        l_column_list     VARCHAR2 (32767);
        l_source_list     VARCHAR2 (32767);

        l_relation_id     NUMBER (38);
        l_sequence_name   VARCHAR2 (30);

        l_sql             VARCHAR2 (32767);

        container_count   NUMBER (38);
    BEGIN
        SELECT *
          INTO l_sp_row
          FROM sdl_profiles
         WHERE sp_id = p_sp_id;

        SELECT *
          INTO l_sdh_row
          FROM sdl_destination_header
         WHERE sdh_id = p_sdh_id;

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

        l_view_name :=
               'V_TDL_'
            || p_sp_id
            || '_'
            || p_sdh_id
            || '_'
            || l_sdh_row.sdh_destination_type
            || '_LD';

        BEGIN
              SELECT COUNT (*) OVER (PARTITION BY sp_id)
                INTO container_count
                FROM sdl_profile_file_columns, sdl_profiles
               WHERE sp_id = spfc_sp_id AND sp_id = p_sp_id
            GROUP BY sp_id, sp_name, spfc_container;
        END;

        l_source_table :=
               'TDL_'
            || replace(l_sp_row.sp_name, ' ', '_')
            || CASE container_count
                   WHEN 1 THEN NULL
                   ELSE '_' || l_sdh_row.sdh_source_container
               END
            || '_LD';

        l_source_alias := l_source_table; --l_sdh_row.sdh_source_container;

        -- grab destination columns, formula, swap sequences for the sequence values in the link data - note that the link data will be populated with the parent SAM ID of the attribute

        WITH
            attribs
            AS
                (SELECT sam_id,
                        sam_col_id,
                        sam_file_attribute_name,
                        sam_view_column_name,
                        sam_ne_column_name,
                        sam_attribute_formula,
                        sam_default_value,
                        (SELECT parent_sam_id
                           FROM v_tdl_destination_relations
                          WHERE     sp_id = p_sp_id
                                AND parent_sdh_id = p_sdh_id
                                AND parent_sam_id = sam_id
                         UNION ALL
                         SELECT parent_sam_id
                           FROM v_tdl_destination_relations
                          WHERE     sp_id = p_sp_id
                                AND child_sdh_id = p_sdh_id
                                AND child_sam_id = sam_id)    p_sam_id
                   FROM sdl_attribute_mapping
                  WHERE sam_sdh_id = p_sdh_id AND sam_sp_id = p_sp_id),
            column_lists
            AS
                (SELECT sam_col_id,
                        sam_view_column_name    dest_column,
                        CASE
                            WHEN p_sam_id IS NOT NULL
                            THEN
                                'L.SDL_LINK_VALUE'
                            ELSE
                                CASE
                                    WHEN sam_attribute_formula IS NOT NULL
                                    THEN
                                        sam_attribute_formula
                                    ELSE
                                        CASE
                                            WHEN sam_default_value
                                                     IS NOT NULL
                                            THEN
                                                CASE
                                                    WHEN sam_file_attribute_name
                                                             IS NOT NULL
                                                    THEN
                                                           'NVL('
                                                        || sam_file_attribute_name
                                                        || ', '
                                                        || sam_default_value
                                                        || ')'
                                                    ELSE
                                                        sam_default_value
                                                END
                                            ELSE
                                                sam_file_attribute_name
                                        END
                                END
                        END                     source_column
                   FROM attribs)
        --
        SELECT LISTAGG (dest_column, ',') WITHIN GROUP (ORDER BY sam_col_id),
               LISTAGG (source_column, ',')
                   WITHIN GROUP (ORDER BY sam_col_id)
          INTO l_column_list, l_source_list
          FROM column_lists;

        l_sql :=
               'create or replace view '
            || l_view_name
            || ' ( tld_sfs_id, tld_id, '
            || l_column_list
            || ' ) '
            || ' as '
            || ' select tld_sfs_id, tld_id, '
            || l_source_list
            || ' from '
            || l_source_table
            || ' '
            || l_source_alias
            || ','
            || ' sdl_destination_links L '
            || ' where '
            || l_source_alias
            || '.tld_sfs_id = L.sdl_sfs_id (+) '
            || ' and '
            || l_source_alias
            || '.tld_id = L.sdl_tld_id (+) '
            || ' and L.sdl_sdr_id (+) = '
            || l_relation_id;

        BEGIN
            nm_debug.debug (l_sql);
        END;

        EXECUTE IMMEDIATE l_sql;
    END;
    
    PROCEDURE drop_tdl_table(p_table_name     IN VARCHAR2) IS
        l_sql            VARCHAR2 (32767);
        l_owner          VARCHAR2 (30)
                             := SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER');
                             
        already_exists   EXCEPTION;
        PRAGMA EXCEPTION_INIT (already_exists, -942); -- name is already used by an existing objec               
        seq_already_exists   EXCEPTION;
        PRAGMA EXCEPTION_INIT (seq_already_exists, -2289);                    
    BEGIN

        l_sql :=
               'DROP TABLE '
            || l_owner
            || '.'
            || p_table_name;

        BEGIN
            EXECUTE IMMEDIATE l_sql;
        EXCEPTION
            WHEN already_exists
            THEN
                NULL;
        END;
        
        l_sql :=
               'DROP SEQUENCE '
            || l_owner
            || '.'
            || p_table_name
            || '_SEQ';

        BEGIN
            EXECUTE IMMEDIATE l_sql;
        EXCEPTION
            WHEN seq_already_exists
            THEN
                NULL;
        END;
    END;
END;
/