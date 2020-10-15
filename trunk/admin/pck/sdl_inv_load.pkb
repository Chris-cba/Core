CREATE OR REPLACE PACKAGE BODY sdl_inv_load
AS
    --
    -----------------------------------------------------------------------------
    --
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sdl_inv_load.pkb-arc   1.1   Oct 15 2020 13:47:10   Rob.Coupe  $
    --       Module Name      : $Workfile:   sdl_inv_load.pkb  $
    --       Date into PVCS   : $Date:   Oct 15 2020 13:47:10  $
    --       Date fetched Out : $Modtime:   Oct 15 2020 13:46:16  $
    --       PVCS Version     : $Revision:   1.1  $
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
   g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   1.1  $';
    
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

            EXECUTE IMMEDIATE l_sql
                USING p_sfs_id, p_sfs_id;
        END IF;

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
                        sam_view_column_name     view_column,
                        sam_ne_column_name       destination_column
                   FROM attribs)
        --
        SELECT LISTAGG (view_column, ',') WITHIN GROUP (ORDER BY sam_col_id),
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

        declare
           invalid_metadata exception;
           pragma exception_init(invalid_metadata, -904 ); --invalid identifier/column issue
        begin        
        
        EXECUTE IMMEDIATE l_sql
            USING p_sfs_id, p_sp_id, p_sfs_id;
            
        exception
           when invalid_metadata then
              raise_application_error( -20001, 'Error in the metadata results in erroneous insert so the load fails');
        end;
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

        p_rows_processed := SQL%ROWCOUNT;
    END;
END;
/