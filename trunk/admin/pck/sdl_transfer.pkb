CREATE OR REPLACE PACKAGE BODY sdl_transfer
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sdl_transfer.pkb-arc   1.10   May 29 2020 16:12:14   Rob.Coupe  $
    --       Module Name      : $Workfile:   sdl_transfer.pkb  $
    --       Date into PVCS   : $Date:   May 29 2020 16:12:14  $
    --       Date fetched Out : $Modtime:   May 29 2020 16:10:18  $
    --       PVCS Version     : $Revision:   1.10  $
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

    g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.10  $';

    g_package_name   CONSTANT VARCHAR2 (30) := 'SDL_DDL';

    qq                        CHAR (1) := CHR (39);

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
    FUNCTION get_ne_data (p_batch_id IN NUMBER, p_view_name IN VARCHAR2)
        RETURN sdl_ne_tab;

    --
    ----------------------------------------------------------------------------
    --
    PROCEDURE transfer_datums (p_batch_id IN NUMBER)
    IS
        np_no_ids         ptr_num_array_type;
        ne_ids            ptr_num_array_type;
        l_ins_str         VARCHAR2 (4000);
        l_sel_str         VARCHAR2 (4000);
        l_datum_geom      geom_id_tab;
        l_sp_id           NUMBER (38);
        l_datum_view      VARCHAR2 (30);
        l_profile_view    VARCHAR2 (30);
        l_group_nt_type   VARCHAR2 (4);
        l_group_type      VARCHAR2 (4);
        l_group_unit_id   NUMBER;
        l_datum_nt_type   VARCHAR2 (4);
        l_datum_unit_id   NUMBER;
        l_node_type       VARCHAR2 (4);
        l_table_name      VARCHAR2 (30);
        l_pk_column       VARCHAR2 (30);
        l_column_name     VARCHAR2 (30);

        l_conv_factor     NUMBER := 1;

        l_ptr             ptr_array_type;

        l_sql             VARCHAR2 (4000);

        l_sdl_ne_tab      sdl_ne_tab;
        l_attrib_list     ptr_vc_array_type;
    BEGIN
        BEGIN
            SELECT sp_id,
                   'V_SDL_' || UPPER (sp_name) || '_NE',
                   'V_SDL_WIP_' || UPPER (sp_name) || '_DATUMS',
                   profile_nt_type,
                   profile_group_type,
                   profile_group_unit_id,
                   datum_nt_type,
                   datum_unit_id,
                   node_type,
                   spatial_table,
                   spatial_pk_column,
                   geometry_column
              INTO l_sp_id,
                   l_profile_view,
                   l_datum_view,
                   l_group_nt_type,
                   l_group_type,
                   l_group_unit_id,
                   l_datum_nt_type,
                   l_datum_unit_id,
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

        --nm_debug.debug_on;
        --nm_debug.delete_debug;
        --delete from ne_id_sav;

        --First, grab the datum IDs that pass the test on whether they should be loaded. This comes from the review levels
        --or from the manual over-ride after a review.

        SELECT ptr_num (d.swd_id, ne_id_seq.NEXTVAL)
          BULK COLLECT INTO ne_ids
          FROM sdl_wip_datums     d,
               sdl_wip_nodes      s,
               sdl_wip_nodes      e,
               V_SDL_NODE_USAGES  n,
               sdl_profiles,
               sdl_file_submissions
         WHERE     d.swd_id = n.swd_id
               AND d.batch_id = p_batch_id
               AND n.start_node = s.hashcode
               AND n.end_node = e.hashcode
               AND d.status = 'LOAD'
               AND sfs_id = d.batch_id
               AND sp_id = sfs_sp_id
               AND (   EXISTS
                           (SELECT 1
                              FROM SDL_SPATIAL_REVIEW_LEVELS
                             WHERE     ssrl_sp_id = sfs_sp_id
                                   AND d.PCT_MATCH BETWEEN ssrl_percent_from
                                                       AND ssrl_percent_to
                                   AND ssrl_default_action = 'LOAD')
                    OR d.manual_override = 'Y');

        --nm_debug.debug('Have IDs - count = '||ne_ids.count);

        -- Grab the attributes we need:

        WITH
            attrib_names
            AS
                (SELECT sam_ne_column_name
                   FROM sdl_attribute_mapping
                  WHERE sam_sp_id = l_sp_id
                 UNION
                 SELECT 'NE_START_DATE' FROM DUAL
                 UNION
                 SELECT 'NE_END_DATE' FROM DUAL)  --select * from attrib_names
                                                ,
            attribs
            AS
                (SELECT NVL (s1.sam_id, ROWNUM * (-1))     sam_id,
                        a.sam_ne_column_name
                   FROM attrib_names a, sdl_attribute_mapping s1
                  WHERE     s1.sam_sp_id(+) = l_sp_id
                        AND s1.sam_ne_column_name(+) = a.sam_ne_column_name)
        SELECT CAST (
                   COLLECT (ptr_vc (sam_id, sam_ne_column_name))
                       AS ptr_vc_array_type)
          INTO l_attrib_list
          FROM attribs;


        --Now, for load files which relate directly to linear routes, grab the conversion
        -- factor so units relating to the route/load data can be converted to the units of the datum.

        IF l_group_type IS NOT NULL
        THEN
            SELECT uc_conversion_factor
              INTO l_conv_factor
              FROM nm_unit_conversions
             WHERE     uc_unit_id_in = l_group_unit_id
                   AND uc_unit_id_out = l_datum_unit_id;

            --Create the new routes from the load data where status allows and there are datums to be created but
            --where the route does not exist.
            --It needs dynamic SQL for the view name which derives the unique key of the load file data.
            --It only inserts the rows with valid, transferrable datums

            SELECT ins_str
              INTO l_ins_str
              FROM (WITH
                        attribs
                        AS
                            (SELECT ptr_id        sam_id,
                                    ptr_value     sam_ne_column_name
                               FROM TABLE (l_attrib_list))
                    SELECT    'insert into nm_elements ( ne_id, ne_type, ne_nt_type, ne_gty_group_type, ne_admin_unit, '
                           || LISTAGG (sam_ne_column_name, ',')
                                  WITHIN GROUP (ORDER BY sam_id)
                           || ')'    ins_str
                      FROM attribs);

            SELECT sel_str
              INTO l_sel_str
              FROM (WITH
                        attribs
                        AS
                            (SELECT ptr_id        sam_id,
                                    ptr_value     sam_ne_column_name
                               FROM TABLE (l_attrib_list))
                    SELECT    ' select ne_id_seq.nextval, '
                           || ''''
                           || 'G'
                           || ''''
                           || ', :l_group_nt_type, :l_group_type, 1,  '
                           || LISTAGG (
                                  CASE
                                      WHEN sam_id < 0 THEN 'NULL'
                                      ELSE sam_ne_column_name
                                  END,
                                  ',')
                              WITHIN GROUP (ORDER BY sam_id)
                           || ' from '
                           || l_profile_view
                           || ' ln '
                           || ' where batch_id = :p_batch_id '
                           || ' and status = '
                           || ''''
                           || 'LOAD'
                           || ''''
                           || ' and exists ( select 1 from sdl_wip_datums d, table(:ne_ids) t where t.ptr_id = swd_id and status = '
                           || ''''
                           || 'LOAD'
                           || ''''
                           || '  and d.sld_key = ln.sld_key )'
                           || ' and not exists ( select 1 from  nm_elements e where ln.ne_unique = e.ne_unique and e.NE_NT_TYPE = :l_group_nt_type ) '    sel_str
                      FROM attribs);

            nm_debug.debug (l_ins_str);

            nm_debug.debug (l_sel_str);

            --raise_application_error(-20001, 'Stop');

            EXECUTE IMMEDIATE l_ins_str || ' ' || l_sel_str
                USING l_group_nt_type,
                      l_group_type,
                      p_batch_id,
                      ne_ids,
                      l_group_nt_type;
        END IF;

        --consider re-setting the matching node-ids

        --nm_debug.debug('Now for the nodes');

        SELECT ptr_num (np_id_seq.NEXTVAL, no_node_id_seq.NEXTVAL)
          BULK COLLECT INTO np_no_ids
          FROM sdl_wip_nodes
         WHERE batch_id = p_batch_id AND existing_node_id IS NULL;

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

        IF l_group_type IS NOT NULL
        THEN
            SELECT    'insert into nm_elements ( ne_id, ne_type, ne_nt_type, ne_no_start, ne_no_end, ne_length, '
                   || LISTAGG (sdam_column_name, ',')
                          WITHIN GROUP (ORDER BY sdam_seq_no)
                   || ')'
              INTO l_ins_str
              FROM sdl_datum_attribute_mapping
             WHERE sdam_profile_id = l_sp_id;

            SELECT    'select t.ptr_value, ne_type, ne_nt_type, start_node, end_node, ne_length, '
                   || LISTAGG (
                          CASE sdam_column_name
                              WHEN 'NE_START_DATE'
                              THEN
                                  ' greatest(ne_start_date, nvl(last_date, ne_start_date)) '
                              ELSE
                                  sdam_column_name
                          END,
                          ',')
                      WITHIN GROUP (ORDER BY sdam_seq_no)
                   || ' from (select d.*, s.existing_node_id start_node, e.existing_node_id end_node, '
                   || ' ( select last_date from (select max(no_start_date) over (partition by dn.swd_id order by node_type rows between unbounded preceding and unbounded following) last_date '
                   || ' from sdl_wip_nodes n, sdl_wip_datum_nodes dn, nm_nodes nn '
                   || ' where n.hashcode=dn.hashcode and n.existing_node_id = nn.no_node_id and dn.SWD_ID = d.swd_id ) where rownum = 1 ) last_date '
                   || 'from '
                   || l_datum_view
                   || ' d, V_SDL_NODE_USAGES n, sdl_wip_nodes s, sdl_wip_nodes e '
                   || 'where d.swd_id = n.swd_id '
                   || 'and d.batch_id = :batch_id '
                   || 'and n.start_node = s.hashcode '
                   || 'and n.end_node = e.hashcode '
                   || ') , '
                   || 'table(:ne_ids) t where batch_id = :batch_id and t.ptr_id = swd_id'
              INTO l_sel_str
              FROM sdl_datum_attribute_mapping
             WHERE sdam_profile_id = l_sp_id;

            /*INSERT INTO ne_id_sav
                SELECT t.ptr_value, t.ptr_id
                  FROM TABLE (ne_ids) t;*/


            EXECUTE IMMEDIATE l_ins_str || ' ' || l_sel_str
                USING p_batch_id, ne_ids, p_batch_id;
        ELSE
            SELECT ins_str
              INTO l_ins_str
              FROM (WITH
                        attribs
                        AS
                            (SELECT ptr_id        sam_id,
                                    ptr_value     sam_ne_column_name
                               FROM TABLE (l_attrib_list))
                    SELECT    'insert into nm_elements ( ne_id, ne_type, ne_nt_type, ne_admin_unit, '
                           || LISTAGG (sam_ne_column_name, ',')
                                  WITHIN GROUP (ORDER BY sam_id)
                           || ')'    ins_str
                      FROM attribs);

            SELECT sel_str
              INTO l_sel_str
              FROM (WITH
                        attribs
                        AS
                            (SELECT ptr_id        sam_id,
                                    ptr_value     sam_ne_column_name
                               FROM TABLE (l_attrib_list))
                    SELECT    ' select ne_id_seq.nextval, '
                           || ''''
                           || 'G'
                           || ''''
                           || ', :l_datum_nt_type, 1,  '
                           || LISTAGG (
                                  CASE
                                      WHEN sam_id < 0 THEN 'NULL'
                                      ELSE sam_ne_column_name
                                  END,
                                  ',')
                              WITHIN GROUP (ORDER BY sam_id)
                           || ' from '
                           || l_profile_view
                           || ' ln '
                           || ' where batch_id = :p_batch_id '
                           || ' and status = '
                           || ''''
                           || 'LOAD'
                           || ''''
                           || ' and exists ( select 1 from sdl_wip_datums d, table(:ne_ids) t where t.ptr_id = swd_id and status = '
                           || ''''
                           || 'LOAD'
                           || ''''
                           || '  and d.sld_key = ln.sld_key )'    sel_str
                      FROM attribs);

            nm_debug.debug (l_ins_str);

            nm_debug.debug (l_sel_str);

            --raise_application_error(-20001, 'Stop');

            EXECUTE IMMEDIATE l_ins_str || ' ' || l_sel_str
                USING l_datum_nt_type, p_batch_id, ne_ids;
        END IF;

        --        nm_debug.debug_on;
        --        nm_debug.debug ('RC> INS' || l_ins_str || ' ' || l_sel_str);

        COMMIT;

        l_ins_str :=
               'INSERT INTO '
            || l_table_name
            || ' ( '
            || l_pk_column
            || ', '
            || l_column_name
            || ' ) '
            || ' SELECT t.ptr_value, geom '
            || '  FROM (select d.swd_id, d.geom from  sdl_wip_datums     d, '
            || 'sdl_wip_nodes      s, '
            || 'sdl_wip_nodes      e, '
            || 'V_SDL_NODE_USAGES  n '
            || 'WHERE     d.swd_id = n.swd_id '
            || 'AND d.batch_id = :batch_id '
            || 'AND n.start_node = s.hashcode '
            || 'AND n.end_node = e.hashcode '
            || ' ), TABLE (:ne_ids) t '
            || ' WHERE t.ptr_id = swd_id ';

        --        nm_debug.debug_on;
        --        nm_debug.debug (l_ins_str);
        --
        --nm_debug.debug('Just nserted the spatial data');

        l_sdl_ne_tab := get_ne_data (p_batch_id, l_profile_view);

        --nm_debug.debug('retrieved route data details, count = '||l_sdl_ne_tab.count );

        EXECUTE IMMEDIATE l_ins_str
            USING p_batch_id, ne_ids;



        IF l_group_type IS NOT NULL
        THEN
            --         we need to add the datums to their parent route

            INSERT INTO nm_members (nm_ne_id_in,
                                    nm_ne_id_of,
                                    nm_type,
                                    nm_obj_type,
                                    nm_start_date,
                                    nm_end_date,
                                    nm_begin_mp,
                                    nm_end_mp,
                                    nm_slk,
                                    nm_end_slk,
                                    nm_cardinality,
                                    nm_admin_unit,
                                    nm_seg_no,
                                    nm_seq_no,
                                    nm_true,
                                    nm_end_true)
                SELECT ne_id,
                       new_ne_id,
                       'G',
                       l_group_type,
                       ne_start_date,
                       ne_end_date,
                       0,
                       (end_slk - start_slk) * l_conv_factor,
                       start_slk,
                       end_slk,
                       1,
                       1,
                       1,
                       datum_id,
                       start_slk,
                       end_slk
                  FROM (SELECT t.ptr_value
                                   new_ne_id,
                               ne_id,
                               datum_id,
                               TRUNC (
                                   GREATEST (l.NE_START_DATE,
                                             (SELECT ne_start_date
                                                FROM nm_elements de
                                               WHERE de.ne_id = t.ptr_value)))
                                   ne_start_date,
                               TRUNC (l.NE_END_DATE)
                                   ne_end_date,
                               SDO_LRS.GEOM_SEGMENT_START_MEASURE (d.geom)
                                   start_slk,
                               SDO_LRS.GEOM_SEGMENT_END_MEASURE (d.geom)
                                   end_slk
                          FROM sdl_wip_datums        d,
                               TABLE (l_sdl_ne_tab)  l,
                               nm_elements           g,
                               TABLE (ne_ids)        t
                         WHERE     d.batch_id = p_batch_id
                               AND l.ne_unique = g.ne_unique
                               AND d.sld_key = l.sld_key
                               AND t.ptr_id = d.swd_id
                               AND l.status = 'LOAD');

            --                               AND EXISTS
            --                                       (SELECT 1
            --                                          FROM sdl_load_data l2
            --                                         WHERE     l2.sld_key = d.sld_key
            --                                               AND l2.sld_status = 'VALID'));

            FOR irec
                IN (SELECT sld_key,
                           l.ne_unique,
                           l.ne_descr,
                           l.ne_start_date
                               load_start_date,
                           e.ne_id,
                           e.ne_start_date
                               existing_start_date,
                           GREATEST (e.ne_start_date, l.ne_start_date)
                               last_date,
                           CASE
                               WHEN e.ne_start_date >= l.ne_start_date
                               THEN
                                   'N'
                               ELSE
                                   'Y'
                           END
                               rescale_history
                      FROM TABLE (l_sdl_ne_tab) l, nm_elements e
                     WHERE     e.ne_unique = l.ne_unique
                           AND status = 'LOAD'
                           AND EXISTS
                                   (SELECT 1
                                      FROM nm_members, TABLE (ne_ids)
                                     WHERE     ptr_value = nm_ne_id_of
                                           AND nm_ne_id_in = e.ne_id))
            LOOP
                BEGIN
                    nm3rsc.rescale_route (irec.ne_id,
                                          TRUNC (SYSDATE),   --irec.last_date,
                                          0,
                                          NULL,
                                          irec.rescale_history,
                                          NULL);

                    COMMIT;
                --if we trap the problem of circular routes will need to find starting element and re-submit
                --if we trap the problem of an attempt to rescale with history which is not allowed due to member dates
                --then resubmit without history

                END;
            END LOOP;
        END IF;

        --nm_debug.debug('Setting ne-id and status');

        UPDATE sdl_wip_datums d
           SET status = 'TRANSFERRED',
               new_ne_id =
                   (SELECT t.ptr_value
                      FROM TABLE (ne_ids) t
                     WHERE ptr_id = swd_id)
         WHERE     batch_id = p_batch_id
               AND swd_id IN (SELECT t.ptr_id
                                FROM TABLE (ne_ids) t)
               AND EXISTS
                       (SELECT 1
                          FROM nm_elements, TABLE (ne_ids)
                         WHERE ne_id = ptr_value);

        -- If all the datums of an associated load record are transferred
        -- then only update status of the associated load record to TRANSFERRED
        UPDATE sdl_load_data sld
           SET sld.sld_status = 'TRANSFERRED'
         WHERE     sld.sld_sfs_id = p_batch_id
               AND EXISTS
                       (SELECT 1
                          FROM sdl_wip_datums swd
                         WHERE     swd.batch_id = sld.sld_sfs_id
                               AND swd.status = 'TRANSFERRED'
                               AND swd.sld_key = sld.sld_key
                               AND 1 =
                                   (SELECT APPROX_COUNT_DISTINCT (s.status)
                                      FROM sdl_wip_datums s
                                     WHERE     s.batch_id = swd.batch_id
                                           AND s.sld_key = swd.sld_key));
    END transfer_datums;

    --
    ----------------------------------------------------------------------------
    --
    FUNCTION get_ne_data (p_batch_id IN NUMBER, p_view_name IN VARCHAR2)
        RETURN sdl_ne_tab
    AS
        retval   sdl_ne_tab;
    BEGIN
        EXECUTE IMMEDIATE   'select cast (collect( sdl_ne_data( sld_key, ne_unique, ne_descr, ne_start_date, ne_end_date, status)) as sdl_ne_tab)  from '
                         || p_view_name
                         || ' where batch_id = :p_batch_id'
            INTO retval
            USING p_batch_id;

        RETURN retval;
    END get_ne_data;
--
----------------------------------------------------------------------------
--
END;
/