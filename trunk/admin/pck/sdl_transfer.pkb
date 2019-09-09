/* Formatted on 09/09/2019 15:39:56 (QP5 v5.336) */
CREATE OR REPLACE PACKAGE BODY sdl_transfer
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sdl_transfer.pkb-arc   1.2   Sep 09 2019 15:42:16   Rob.Coupe  $
    --       Module Name      : $Workfile:   sdl_transfer.pkb  $
    --       Date into PVCS   : $Date:   Sep 09 2019 15:42:16  $
    --       Date fetched Out : $Modtime:   Sep 09 2019 15:40:30  $
    --       PVCS Version     : $Revision:   1.2  $
    --
    --   Author : R.A. Coupe
    --
    --   Package for handling the transfer of data from the SDL repository into the main database
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    --
    -- The main purpose of this package is to handle the transfer of data from the SDL repository
    -- into the main database

    g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.2  $';

    g_package_name   CONSTANT VARCHAR2 (30) := 'SDL_DDL';

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


    PROCEDURE transfer_datums (p_batch_id IN NUMBER)
    IS
        np_no_ids       ptr_num_array_type;
        ne_ids          ptr_num_array_type;
        l_ins_str       VARCHAR2 (4000);
        l_sel_str       VARCHAR2 (4000);
        l_datum_geom    geom_id_tab;
        l_view_name     VARCHAR2 (30);
        l_node_type     VARCHAR2 (4);
        l_table_name    VARCHAR2 (30);
        l_pk_column     VARCHAR2 (30);
        l_column_name   VARCHAR2 (30);
    BEGIN
        BEGIN
            SELECT 'V_SDL_WIP_' || sp_name || '_DATUMS',
                   node_type,
                   spatial_table,
                   spatial_pk_column,
                   geometry_column
              INTO l_view_name,
                   l_node_type,
                   l_table_name,
                   l_pk_column,
                   l_column_name
              FROM v_sdl_profile_nw_types, sdl_file_submissions
             WHERE     sfs_id = p_batch_id
                   AND sp_id = sfs_sp_id
                   AND EXISTS
                           (SELECT 1
                              FROM all_views
                             WHERE     view_name =
                                          'V_SDL_WIP_'
                                       || UPPER (sp_name)
                                       || '_DATUMS'
                                   AND owner =
                                       SYS_CONTEXT ('NM3CORE',
                                                    'APPLICATION_OWNER'));
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                raise_application_error (
                    -20001,
                    'There is a problem with the profile name and/or the profile datum view or the theme metadata ');
        END;

        SELECT ptr_num (np_id_seq.NEXTVAL, no_node_id_seq.NEXTVAL)
          BULK COLLECT INTO np_no_ids
          FROM sdl_wip_nodes
         WHERE batch_id = 4 AND existing_node_id IS NULL;

        DECLARE
            x          NUMBER;
            y          NUMBER;
            no_count   INTEGER := 0;
        BEGIN
            FOR nodes
                IN (    SELECT ROWID
                          FROM sdl_wip_nodes
                         WHERE batch_id = p_batch_id AND existing_node_id IS NULL
                    FOR UPDATE OF existing_node_id)
            LOOP
                no_count := no_count + 1;

                   UPDATE sdl_wip_nodes n
                      SET n.existing_node_id = np_no_ids (no_count).ptr_value
                    WHERE ROWID = nodes.ROWID
                RETURNING n.node_geom.sdo_point.x, n.node_geom.sdo_point.y
                     INTO x, y;

                NM3NET.CREATE_POINT (np_no_ids (no_count).ptr_id,
                                     x,
                                     y,
                                     'SDL Batch ' || p_batch_id);

                NM3NET.CREATE_NODE (np_no_ids (no_count).ptr_value,
                                    np_no_ids (no_count).ptr_id,
                                    TO_DATE ('01-JAN-1900', 'DD-MON-YYYY'),
                                    'SDL Batch ' || p_batch_id,
                                    l_node_type,
                                    TO_CHAR (np_no_ids (no_count).ptr_value),
                                    'SDL Transfer');
            END LOOP;
        END;

        COMMIT;

        --we now have all the nodes we need

        SELECT ptr_num (d.swd_id, ne_id_seq.NEXTVAL)
          BULK COLLECT INTO ne_ids
          FROM sdl_wip_datums     d,
               sdl_wip_nodes      s,
               sdl_wip_nodes      e,
               V_SDL_NODE_USAGES  n
         WHERE     d.swd_id = n.swd_id
               AND d.batch_id = p_batch_id
               AND n.start_node = s.hashcode
               AND n.end_node = e.hashcode
               AND EXISTS
                       (SELECT 1
                          FROM sdl_geom_accuracy
                         WHERE     slga_sld_key = sld_key
                               AND slga_datum_id = datum_id
                               AND slga_pct_inside = 0);

        SELECT    'insert into nm_elements ( ne_id, ne_type, ne_nt_type, ne_no_start, ne_no_end, ne_length, '
               || LISTAGG (sdam_column_name, ',')
                      WITHIN GROUP (ORDER BY sdam_seq_no)
               || ')'
          INTO l_ins_str
          FROM sdl_datum_attribute_mapping
         WHERE sdam_profile_id = 1;

        SELECT    'select t.ptr_value, ne_type, ne_nt_type, start_node, end_node, ne_length, '
               || LISTAGG (sdam_column_name, ',')
                      WITHIN GROUP (ORDER BY sdam_seq_no)
               || ' from (select d.*, s.existing_node_id start_node, e.existing_node_id end_node '
               || 'from '
               || l_view_name
               || ' d, V_SDL_NODE_USAGES n, sdl_wip_nodes s, sdl_wip_nodes e '
               || 'where d.swd_id = n.swd_id '
               || 'and d.batch_id = :batch_id '
               || 'and n.start_node = s.hashcode '
               || 'and n.end_node = e.hashcode '
               || 'and exists ( select 1 from sdl_geom_accuracy where slga_sld_key = sld_key '
               || 'and slga_datum_id = datum_id '
               || 'and slga_pct_inside = 0 )), '
               || 'table(:ne_ids) t where batch_id = :batch_id and t.ptr_id = swd_id'
          INTO l_sel_str
          FROM sdl_datum_attribute_mapping
         WHERE sdam_profile_id = 1;

        INSERT INTO ne_id_sav
            SELECT t.ptr_value, t.ptr_id
              FROM TABLE (ne_ids) t;

        COMMIT;

        nm_debug.debug_on;
        nm_debug.debug (l_ins_str || ' ' || l_sel_str);

        EXECUTE IMMEDIATE l_ins_str || ' ' || l_sel_str
            USING p_batch_id, ne_ids, p_batch_id;

        COMMIT;

        EXECUTE IMMEDIATE   'INSERT INTO '
                         || l_table_name
                         || ' ( '
                         || l_pk_column
                         || ', '
                         || l_column_name
                         || ' ) '
                         || ' SELECT t.ptr_value, geom '
                         || '  FROM (FROM sdl_wip_datums     d, '
                         || 'sdl_wip_nodes      s, '
                         || 'sdl_wip_nodes      e, '
                         || 'V_SDL_NODE_USAGES  n '
                         || 'WHERE     d.swd_id = n.swd_id '
                         || 'AND d.batch_id = p_batch_id '
                         || 'AND n.start_node = s.hashcode '
                         || 'AND n.end_node = e.hashcode '
                         || 'AND EXISTS '
                         || '    (SELECT 1 '
                         || '       FROM sdl_geom_accuracy '
                         || '      WHERE     slga_sld_key = sld_key '
                         || '           AND slga_datum_id = datum_id '
                         || '            AND slga_pct_inside = 0)), TABLE (:ne_ids) t '
                         || ' WHERE t.ptr_id = swd_id '
            USING ne_ids;
    END;
END;
/
