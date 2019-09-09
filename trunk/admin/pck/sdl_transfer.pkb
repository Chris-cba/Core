CREATE OR REPLACE PACKAGE BODY sdl_transfer
AS
    --

    PROCEDURE transfer_datums (p_batch_id IN NUMBER)
    IS
        np_no_ids        ptr_num_array_type;
        ne_ids           ptr_num_array_type;
        l_ins_str        VARCHAR2 (4000);
        l_sel_str        VARCHAR2 (4000);
        l_datum_geom     geom_id_tab;
        l_view_name   VARCHAR2 (30);
        l_node_type   varchar2(4);
    BEGIN
        BEGIN
            SELECT  'V_SDL_WIP_' || sp_name || '_DATUMS', node_type
              INTO l_view_name, l_node_type
              FROM v_sdl_profile_nw_types, sdl_file_submissions
             WHERE     sfs_id = p_batch_id
                   AND sp_id = sfs_sp_id
                   AND EXISTS
                           (SELECT 1
                              FROM all_views
                             WHERE     view_name =
                                       'V_SDL_WIP_' || sp_name || '_DATUMS'
                                   AND owner =
                                       SYS_CONTEXT ('NM3CORE',
                                                    'APPLICATION_OWNER'));
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                raise_application_error (
                    -20001,
                    'There is a problem with the profile name and/or the profile datum view ');
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
            FOR nodes IN (    SELECT ROWID
                                FROM sdl_wip_nodes
                               WHERE batch_id = 4 AND existing_node_id IS NULL
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

        SELECT ptr_num (swd_id, ne_id_seq.NEXTVAL)
          BULK COLLECT INTO ne_ids
          FROM v_sdl_profile1_transfer;

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
               || ' from v_sdl_profile1_transfer, table(:ne_ids) t where batch_id = 4 and t.ptr_id = swd_id'
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
            USING ne_ids;

        COMMIT;

        INSERT INTO xctdot_segm_sdo_table (ne_id, geom)
            SELECT t.ptr_value, geom
              FROM v_sdl_profile1_transfer, TABLE (ne_ids) t
             WHERE t.ptr_id = swd_id;
    END;
END;
/