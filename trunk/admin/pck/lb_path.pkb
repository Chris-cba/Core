CREATE OR REPLACE PACKAGE BODY lb_path
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_path.pkb-arc   1.10   Oct 04 2017 15:02:02   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_path.pkb  $
   --       Date into PVCS   : $Date:   Oct 04 2017 15:02:02  $
   --       Date fetched Out : $Modtime:   Oct 04 2017 14:58:08  $
   --       PVCS Version     : $Revision:   1.10  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge package for handling path data
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.10  $';

   g_package_name   CONSTANT VARCHAR2 (30) := 'lb_path';

   --
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

   FUNCTION get_g_nw_types
      RETURN ptr_vc_array_type
   IS
   BEGIN
      RETURN g_nw_types;
   END;

   --
   -----------------------------------------------------------------------------
   --

   FUNCTION get_path (pi_node1 IN INTEGER, pi_node2 IN INTEGER)
      RETURN SYS_REFCURSOR
   IS
      l_path   MDSYS.sdo_number_array;
      retval   SYS_REFCURSOR;
   BEGIN
      l_path := get_sdo_path (pi_node1, pi_node2);
      RETURN NULL;
   END;

   --
   FUNCTION get_tsp_path_v (p_nodes IN sdo_number_array)
      RETURN sdo_number_array
   IS
      net_mem        VARCHAR2 (30) := g_network;
      res_string     VARCHAR2 (1000);
      cost           NUMBER;
      res_numeric    NUMBER;
      res_array      SDO_NUMBER_ARRAY;
      indx           NUMBER;
      indx1          NUMBER;
      var1_numeric   NUMBER;
      var1_array     SDO_NUMBER_ARRAY;
   --
   BEGIN
      res_string := SDO_NET_MEM.NETWORK_MANAGER.LIST_NETWORKS;

      IF res_string = net_mem
      THEN
         NULL;
      ELSE
         SDO_NET_MEM.NETWORK_MANAGER.READ_NETWORK (net_mem, 'TRUE');
      END IF;

      --
      res_numeric :=
         SDO_NET_MEM.NETWORK_MANAGER.TSP_PATH (net_mem,
                                               p_nodes,
                                               'FALSE',
                                               'TRUE');
      --DBMS_OUTPUT.PUT_LINE('Open TSP path ID for N2, N4, N6: ' || res_numeric);
      --DBMS_OUTPUT.PUT_LINE('which contains these links: ');
      var1_array := SDO_NET_MEM.PATH.GET_LINK_IDS (net_mem, res_numeric);
      --FOR indx1 IN var1_array.FIRST..var1_array.LAST
      --LOOP
      --var1_numeric := var1_array(indx1);
      --DBMS_OUTPUT.PUT(var1_numeric || ' ');
      --END LOOP;
      --DBMS_OUTPUT.PUT_LINE(' ');
      RETURN var1_array;                                          --res_array;
   END;

   --
   FUNCTION get_tsp_path (p_nodes IN sdo_number_array)
      RETURN SYS_REFCURSOR
   IS
      retval   SYS_REFCURSOR;
      l_v      sdo_number_array;
   BEGIN
      l_v := lb_path.get_tsp_path_v (p_nodes);

      OPEN retval FOR
         SELECT ROWNUM id,
                ne_id,
                ne_unique,
                ne_length,
                ne_no_start,
                ne_no_end
           FROM nm_elements, TABLE (l_v) t
          WHERE t.COLUMN_VALUE = ne_id;

      RETURN retval;
   END;

   --
   FUNCTION get_path_from_gdo (pi_gdo_session_id IN INTEGER)
      RETURN SYS_REFCURSOR
   IS
   BEGIN
      RETURN NULL;
   END;

   --
   FUNCTION get_tsp_path_from_gdo (pi_gdo_session_id IN INTEGER)
      RETURN SYS_REFCURSOR
   IS
   BEGIN
      RETURN NULL;
   END;

   --
   FUNCTION get_path_geometry (pi_path IN sdo_number_array)
      RETURN SYS_REFCURSOR
   IS
   BEGIN
      RETURN NULL;
   END;

   --
   FUNCTION get_sdo_path_geometry (pi_path IN sdo_number_array)
      RETURN MDSYS.sdo_geometry
   IS
      retval   MDSYS.sdo_geometry;
      l_v      sdo_number_array;
      l_geom   MDSYS.SDO_GEOMETRY_ARRAY;
   BEGIN
      --     select geoloc
      --     bulk collect into l_geom
      --     from V_LB_NLT_GEOMETRY, table( pi_path ) t
      --     where  t.column_value = ne_id;
      ----
      --     for i in 1..pi_path.count loop
      --       if i = 1 then
      --         retval := l_geom(i);
      --       else
      --         retval :=  SDO_LRS.CONCATENATE_GEOM_SEGMENTS(retval, l_geom(i), 0.05 );
      --       end if;
      --     end loop;

      SELECT SDO_AGGR_UNION (
                sdoaggrtype (SDO_LRS.convert_to_std_geom (geoloc), 0.05))
        INTO retval
        FROM V_LB_NLT_GEOMETRY, TABLE (pi_path) t
       WHERE t.COLUMN_VALUE = ne_id;

      --     retval := sdo_lrs.convert_to_std_geom(retval);
      --
      RETURN retval;
   END;

   --
   FUNCTION get_sdo_path (p_no_1 INTEGER, p_no_2 INTEGER)
      RETURN sdo_number_array
   IS
      net_mem        VARCHAR2 (100) := g_network;
      res_string     VARCHAR2 (1000);
      cost           NUMBER;
      res_numeric    NUMBER;
      res_array      SDO_NUMBER_ARRAY;
      indx           NUMBER;
      indx1          NUMBER;
      var1_numeric   NUMBER;
      var1_array     SDO_NUMBER_ARRAY;
      nw_exists      EXCEPTION;
      PRAGMA EXCEPTION_INIT (nw_exists, -29532);
   BEGIN
      res_string := SDO_NET_MEM.NETWORK_MANAGER.LIST_NETWORKS;

      nm_debug.debug (
            'get_sdo_path from nodes - net_mem = '
         || net_mem
         || ', res_string = ');
      --      IF res_string = net_mem
      --      THEN
      --         NULL;
      --      ELSE
      --         nm_debug.debug ('net-mem = ' || net_mem);
      --         begin
      --            SDO_NET_MEM.NETWORK_MANAGER.READ_NETWORK (net_mem, 'TRUE');
      --         exception
      --            when nw_exists then SDO_NET_MEM.NETWORK_MANAGER.DROP_NETWORK(net_mem);
      --            SDO_NET_MEM.NETWORK_MANAGER.READ_NETWORK (net_mem, 'TRUE');
      --         end;
      --
      --      END IF;

      --
      res_string :=
         SDO_NET_MEM.NETWORK_MANAGER.IS_REACHABLE (net_mem, p_no_1, p_no_2);
      DBMS_OUTPUT.PUT_LINE (
            'Can node '
         || p_no_1
         || ' reach node '
         || p_no_2
         || ' - '
         || res_string);

      IF res_string != 'TRUE'
      THEN
         raise_application_error (-20001, 'No connectivity');
      END IF;

      res_numeric :=
         SDO_NET_MEM.NETWORK_MANAGER.SHORTEST_PATH (net_mem, p_no_1, p_no_2);
      DBMS_OUTPUT.PUT_LINE (
            'The shortest path from node '
         || p_no_1
         || ' reach node '
         || p_no_2
         || ' is path ID: '
         || res_numeric);
      DBMS_OUTPUT.PUT_LINE (
         'The following are characteristics of this shortest path: ');

      IF res_numeric IS NOT NULL
      THEN
         cost := SDO_NET_MEM.PATH.GET_COST (net_mem, res_numeric);
         DBMS_OUTPUT.PUT_LINE (
            'Path ' || res_numeric || ' has cost: ' || cost);
         res_string := SDO_NET_MEM.PATH.IS_CLOSED (net_mem, res_numeric);
         DBMS_OUTPUT.PUT_LINE (
            'Is path ' || res_numeric || ' closed? ' || res_string);
         res_array := SDO_NET_MEM.PATH.GET_LINK_IDS (net_mem, res_numeric);
         DBMS_OUTPUT.PUT (
            'Path ' || res_numeric || ' has links - being returned: ');
      END IF;

      --
      RETURN res_array;
   END;

   FUNCTION get_sdo_path (l1 IN nm_lref, l2 IN nm_lref)
      RETURN lb_rpt_tab
   IS
      retval   lb_rpt_tab;
   --
   BEGIN
      IF l1.lr_ne_id = l2.lr_ne_id
      THEN
         WITH nlt
              AS (SELECT ne_id,
                         ne_length,
                         ne_no_start,
                         ne_no_end,
                         nlt_id,
                         nlt_units
                    FROM nm_linear_types, nm_elements
                   WHERE ne_id = l1.lr_ne_id AND nlt_nt_type = ne_nt_type),
              t1
              AS (SELECT ne_id,
                         nlt_id,
                         ne_length,
                         CASE SIGN (l1.lr_offset - l2.lr_offset)
                            WHEN 1 THEN -1
                            ELSE 1
                         END
                            dir_flag,
                         LEAST (l1.lr_offset, l2.lr_offset) start_m,
                         GREATEST (l1.lr_offset, l2.lr_offset) end_m,
                         nlt_units,
                         circular_or_linear
                    FROM (SELECT ne_id,
                                 nlt_id,
                                 ne_length,
                                 ne_no_start,
                                 ne_no_end,
                                 nlt_units,
                                 CASE
                                    WHEN ne_no_start = ne_no_end
                                    THEN
                                       'CIRCULAR'
                                    ELSE
                                       'LINEAR'
                                 END
                                    circular_or_linear
                            FROM nlt))
         SELECT lb_tab
           INTO retval
           FROM (SELECT t1.*,
                        CASE circular_or_linear
                           WHEN 'CIRCULAR'
                           THEN
                              CASE
                                 WHEN ABS (end_m - start_m) > ne_length / 2
                                 THEN
                                    (SELECT CAST (
                                               COLLECT (lb_tab) AS lb_rpt_tab)
                                       FROM (SELECT lb_rpt (l1.lr_ne_id,
                                                            nlt_id,
                                                            'PATH',
                                                            1,
                                                            1,
                                                            1,
                                                            dir_flag * -1,
                                                            end_m,
                                                            ne_length,
                                                            nlt_units)
                                                       lb_tab
                                               FROM t1
                                             UNION ALL
                                             SELECT lb_rpt (l1.lr_ne_id,
                                                            nlt_id,
                                                            'PATH',
                                                            1,
                                                            1,
                                                            1,
                                                            dir_flag,
                                                            0,
                                                            t1.start_m,
                                                            nlt_units)
                                               FROM t1))
                                 ELSE
                                    (SELECT lb_rpt_tab (lb_rpt (l1.lr_ne_id,
                                                                nlt_id,
                                                                'PATH',
                                                                1,
                                                                1,
                                                                1,
                                                                dir_flag,
                                                                t1.start_m,
                                                                t1.end_m,
                                                                nlt_units))
                                       FROM t1)
                              END
                           ELSE
                              (SELECT lb_rpt_tab (lb_rpt (l1.lr_ne_id,
                                                          nlt_id,
                                                          'PATH',
                                                          1,
                                                          1,
                                                          1,
                                                          dir_flag,
                                                          t1.start_m,
                                                          t1.end_m,
                                                          nlt_units))
                                 FROM t1)
                        END
                           lb_tab
                   FROM t1);
      ELSE
         nm3ctx.set_context ('L1_NE_ID', TO_CHAR (l1.lr_ne_id));
         nm3ctx.set_context ('L1_OFFSET', TO_CHAR (l1.lr_offset));
         nm3ctx.set_context ('L2_NE_ID', TO_CHAR (l2.lr_ne_id));
         nm3ctx.set_context ('L2_OFFSET', TO_CHAR (l2.lr_offset));


         --
         SELECT * INTO retval FROM v_lb_path_between_points;
      END IF;

      RETURN retval;
   END;



   FUNCTION get_tsp_sdo_path (p_nodes IN sdo_number_array)
      RETURN sdo_number_array
   IS
      l_v   sdo_number_array;
   BEGIN
      l_v := lb_path.get_tsp_path_v (p_nodes);
      RETURN l_v;
   END;

   --   FUNCTION get_sdo_path (p_no_1 VARCHAR2, p_no_2 VARCHAR2)
   --      RETURN sdo_number_array
   --   IS
   --   BEGIN
   --      RETURN get_sdo_path (CAST (p_no_1 AS INTEGER),
   --                           CAST (p_no_2 AS INTEGER));
   --   END;

   --
   PROCEDURE set_network (pi_network_name   IN VARCHAR2,
                          pi_node_type      IN VARCHAR2 DEFAULT NULL,
                          pi_asset_type     IN VARCHAR2 DEFAULT NULL,
                          pi_xmin           IN NUMBER DEFAULT NULL,
                          pi_ymin           IN NUMBER DEFAULT NULL,
                          pi_xmax           IN NUMBER DEFAULT NULL,
                          pi_ymax           IN NUMBER DEFAULT NULL)
   IS
      res_string           VARCHAR2 (1000);
      net_mem              VARCHAR2 (100);
      nw_exists            EXCEPTION;
      PRAGMA EXCEPTION_INIT (nw_exists, -29532);
      use_spatial_filter   BOOLEAN := FALSE;
   --      cost           NUMBER;
   --      res_numeric    NUMBER;
   --      res_array      SDO_NUMBER_ARRAY;
   --      indx           NUMBER;
   --      indx1          NUMBER;
   --      var1_numeric   NUMBER;
   --      var1_array     SDO_NUMBER_ARRAY;

   BEGIN
      IF pi_network_name IS NULL
      THEN
         raise_application_error (-20002, 'You must specify a network name');
      ELSIF pi_node_type IS NULL AND pi_asset_type IS NULL
      THEN
         raise_application_error (
            -20005,
            'You must specify a node type or an asset type to define the network elements to be configured');
      ELSE
         IF pi_xmin IS NULL
         THEN
            use_spatial_filter := FALSE;
         ELSE
            use_spatial_filter := TRUE;
         END IF;

         nm3ctx.set_context ('LB_SPATIAL_FILTER_XMIN', TO_CHAR (pi_xmin));
         nm3ctx.set_context ('LB_SPATIAL_FILTER_YMIN', TO_CHAR (pi_ymin));
         nm3ctx.set_context ('LB_SPATIAL_FILTER_XMAX', TO_CHAR (pi_xmax));
         nm3ctx.set_context ('LB_SPATIAL_FILTER_YMAX', TO_CHAR (pi_ymax));

         BEGIN
            SELECT network
              INTO g_network
              FROM all_sdo_network_metadata
             WHERE     owner = SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
                   AND network = pi_network_name;
         EXCEPTION
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error (
                  -20003,
                  'There is more than one network registered, please specifiy a network name');
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (
                  -20004,
                     'You do not have access to a network of name '
                  || pi_network_name);
         END;
      END IF;

      net_mem := g_network;

      IF pi_asset_type IS NULL AND pi_node_type IS NOT NULL
      THEN
         SELECT ptr_vc (ROWNUM, nt_type)
           BULK COLLECT INTO g_nw_types
           FROM nm_types
          WHERE nt_node_type = pi_node_type;
      ELSE
         SELECT ptr_vc (ROWNUM, nin_nw_type)
           BULK COLLECT INTO g_nw_types
           FROM nm_inv_nw
          WHERE nin_nit_inv_code = pi_asset_type;
      END IF;

      res_string := SDO_NET_MEM.NETWORK_MANAGER.LIST_NETWORKS;

      IF res_string = net_mem
      THEN
         SDO_NET_MEM.NETWORK_MANAGER.DROP_NETWORK (net_mem);
      END IF;

      nm_debug.debug ('net-mem = ' || net_mem);

      --         if NOT use_spatial_filter then
      BEGIN
         SDO_NET_MEM.NETWORK_MANAGER.READ_NETWORK (net_mem, 'TRUE');
      EXCEPTION
         WHEN nw_exists
         THEN
            BEGIN
               SDO_NET_MEM.NETWORK_MANAGER.DROP_NETWORK (net_mem);
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;

            SDO_NET_MEM.NETWORK_MANAGER.READ_NETWORK (net_mem, 'TRUE');
      END;
   --         end if;
   --      END IF;
   END;

   --
   FUNCTION node_state (p_node_id IN INTEGER)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN SDO_NET_MEM.node.get_state (g_network, p_node_id);
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   --
   FUNCTION get_path_as_lb_rpt_tab (p_no_1 INTEGER, p_no_2 INTEGER)
      RETURN lb_rpt_tab
   AS
      retval   lb_rpt_tab;
   BEGIN
      nm3ctx.set_context ('START_NODE', TO_CHAR (p_no_1));
      nm3ctx.set_context ('END_NODE', TO_CHAR (p_no_2));

      --
      SELECT CAST (COLLECT (lb_rpt (ne_id,
                                    nlt_id,
                                    obj_type,
                                    obj_id,
                                    seg_id,
                                    path_seq,
                                    dir_flag,
                                    start_m,
                                    end_m,
                                    nlt_units)) AS lb_rpt_tab)
        INTO retval
        FROM (SELECT e.ne_id,
                     nlt_id,
                     'PATH' obj_type,
                     1 obj_id,
                     1 seg_id,
                     path_seq,
                     dir_flag,
                     0 start_m,
                     p.ne_length end_m,
                     nlt_units
                FROM nm_linear_types,
                     nm_elements e,
                     v_lb_directed_path_links p
               WHERE     e.ne_id = p.ne_id
                     AND e.ne_nt_type = nlt_nt_type
                     AND nlt_gty_type IS NULL
                     AND nlt_g_i_d = 'D');

      RETURN retval;
   END;

   FUNCTION get_path_as_lb_rpt_tab (pi_path IN sdo_number_array)
      RETURN lb_rpt_tab
   IS
      retval   lb_RPt_tab;
   BEGIN
      SELECT CAST (COLLECT (lb_rpt (ne_id,
                                    nlt_id,
                                    obj_type,
                                    obj_id,
                                    seg_id,
                                    path_seq,
                                    dir_flag,
                                    start_m,
                                    end_m,
                                    nlt_units)) AS lb_rpt_tab)
        INTO retval
        FROM (SELECT e.ne_id,
                     nlt_id,
                     'PATH' obj_type,
                     1 obj_id,
                     1 seg_id,
                     path_seq,
                     dir_flag,
                     0 start_m,
                     p.ne_length end_m,
                     nlt_units
                FROM nm_linear_types,
                     nm_elements e,
                     (WITH path_links
                           AS (SELECT path_seq,
                                      ne_id,
                                      ne_no_start,
                                      ne_no_end,
                                      ne_length,
                                      cum_length,
                                      dir_flag
                                 FROM (SELECT path_seq,
                                              ne_id,
                                              ne_no_start,
                                              ne_no_end,
                                              ne_length,
                                              SUM (ne_length)
                                                 OVER (ORDER BY path_seq)
                                                 cum_length,
                                              CASE path_seq
                                                 WHEN 1
                                                 THEN
                                                    CASE ne_no_start
                                                       WHEN p_s
                                                       THEN
                                                          -1
                                                       WHEN p_e
                                                       THEN
                                                          -1
                                                       ELSE
                                                          CASE ne_no_end
                                                             WHEN p_s THEN 1
                                                             WHEN p_e THEN 1
                                                             ELSE 0
                                                          END
                                                    END
                                              END
                                                 dir_flag
                                         FROM (  SELECT t.path_seq,
                                                        ne_id,
                                                        ne_no_start,
                                                        ne_no_end,
                                                        ne_length,
                                                        LEAD (
                                                           ne_no_start,
                                                           1)
                                                        OVER (
                                                           ORDER BY path_seq)
                                                           p_s,
                                                        LEAD (
                                                           ne_no_end,
                                                           1)
                                                        OVER (
                                                           ORDER BY path_seq)
                                                           p_e
                                                   FROM (SELECT ROWNUM path_seq,
                                                                COLUMN_VALUE
                                                                   path_ne_id
                                                           FROM TABLE (
                                                                   lb_path.get_sdo_path (
                                                                      1076647,
                                                                      1076648)))
                                                        t,
                                                        nm_elements
                                                  WHERE path_ne_id = ne_id
                                               ORDER BY path_seq) t2)),
                           recursive_path (path_seq,
                                           ne_id,
                                           ne_no_start,
                                           ne_no_end,
                                           ne_length,
                                           cum_length,
                                           dir_flag)
                           AS (SELECT p.path_seq,
                                      p.ne_id,
                                      p.ne_no_start,
                                      p.ne_no_end,
                                      p.ne_length,
                                      p.cum_length,
                                      p.dir_flag
                                 FROM path_links p
                                WHERE path_seq = 1
                               UNION ALL
                               SELECT c.path_seq,
                                      c.ne_id,
                                      c.ne_no_start,
                                      c.ne_no_end,
                                      c.ne_length,
                                      c.cum_length,
                                      CASE p.dir_flag
                                         WHEN 1
                                         THEN
                                            CASE
                                               WHEN p.ne_no_end =
                                                       c.ne_no_start
                                               THEN
                                                  1
                                               WHEN p.ne_no_end = c.ne_no_end
                                               THEN
                                                  -1
                                               ELSE
                                                  0
                                            END
                                         WHEN -1
                                         THEN
                                            CASE
                                               WHEN p.ne_no_start =
                                                       c.ne_no_start
                                               THEN
                                                  1
                                               WHEN p.ne_no_start =
                                                       c.ne_no_end
                                               THEN
                                                  -1
                                               ELSE
                                                  0
                                            END
                                         ELSE
                                            0
                                      END
                                         dir_flag
                                 FROM recursive_path p, path_links c
                                WHERE c.path_seq = p.path_seq + 1)
                      SELECT "PATH_SEQ",
                             "NE_ID",
                             "NE_NO_START",
                             "NE_NO_END",
                             "NE_LENGTH",
                             "CUM_LENGTH",
                             "DIR_FLAG"
                        FROM recursive_path) p
               WHERE     e.ne_id = p.ne_id
                     AND e.ne_nt_type = nlt_nt_type
                     AND nlt_gty_type IS NULL
                     AND nlt_g_i_d = 'D');

      RETURN retval;
   END;

   --
   FUNCTION get_lb_rpt_tab_from_lref_array (
      pi_lref_array   IN nm_lref_array_type)
      RETURN lb_rpt_tab
   IS
      retval   lb_rpt_tab;
   BEGIN
      SELECT p1
        INTO retval
        FROM (SELECT *
                FROM (SELECT rn, MAX (rn) OVER (PARTITION BY 1) max_rn, p1
                        FROM (WITH lr_data (rn,
                                            lr_ne_id,
                                            lr_offset,
                                            next_rn,
                                            next_lr_ne_id,
                                            next_lr_offset)
                                   AS (SELECT *
                                         FROM (SELECT rn,
                                                      lr_ne_id,
                                                      lr_offset,
                                                      LEAD (rn, 1)
                                                         OVER (ORDER BY rn)
                                                         next_rn,
                                                      LEAD (lr_ne_id, 1)
                                                         OVER (ORDER BY rn)
                                                         next_lr_ne_id,
                                                      LEAD (lr_offset, 1)
                                                         OVER (ORDER BY rn)
                                                         next_lr_offset
                                                 FROM (SELECT ROWNUM rn,
                                                              t.lr_ne_id,
                                                              t.lr_offset
                                                         FROM TABLE (
                                                                 pi_lref_array) t)))
                              SELECT rn,
                                     --rn, lr_ne_id, lr_offset, next_lr_ne_id, next_lr_offset
                                     LB_PATH.get_sdo_path (
                                        nm_lref (lr_ne_id, lr_offset),
                                        nm_lref (next_lr_ne_id,
                                                 next_lr_offset))
                                        p1
                                FROM lr_data l1
                               WHERE rn = 1
                              UNION ALL
                              SELECT l3.rn,
                                     LB_OPS.RPT_UNION (
                                        LB_PATH.get_sdo_path (
                                           nm_lref (l2.lr_ne_id,
                                                    l2.lr_offset),
                                           nm_lref (l2.next_lr_ne_id,
                                                    l2.next_lr_offset)),
                                        LB_PATH.get_sdo_path (
                                           nm_lref (l3.lr_ne_id,
                                                    l3.lr_offset),
                                           nm_lref (l3.next_lr_ne_id,
                                                    l3.next_lr_offset)),
                                        100)
                                --LB_PATH.get_sdo_path(nm_lref(l3.lr_ne_id, l3.lr_offset), nm_lref(l3.next_lr_ne_id, l3.next_lr_offset))
                                --l3.rn, l3.lr_ne_id, l3.lr_offset, l3.next_lr_ne_id, l3.next_lr_offset
                                FROM lr_data l2,
                                     (SELECT rn,
                                             lr_ne_id,
                                             lr_offset,
                                             LEAD (rn, 1) OVER (ORDER BY rn)
                                                next_rn,
                                             LEAD (lr_ne_id, 1)
                                                OVER (ORDER BY rn)
                                                next_lr_ne_id,
                                             LEAD (lr_offset, 1)
                                                OVER (ORDER BY rn)
                                                next_lr_offset
                                        FROM (SELECT ROWNUM rn,
                                                     t.lr_ne_id,
                                                     t.lr_offset
                                                FROM TABLE (pi_lref_array) t))
                                     l3
                               WHERE     l3.rn = l2.next_rn --order by seg_id, seq_id
                                     AND l3.next_rn IS NOT NULL))
               WHERE rn = max_rn);

      --
      RETURN retval;
   END;
--
--BEGIN
--   set_network; --('XHA_ESU_NETWORK');
--
--   DECLARE
--      net_mem      VARCHAR2 (100) := g_network;
--      res_string   VARCHAR2 (1000);
--   BEGIN
--      res_string := SDO_NET_MEM.NETWORK_MANAGER.LIST_NETWORKS;
--
--      IF res_string = net_mem
--      THEN
--         NULL;
--      ELSE
--         nm_debug.debug ('net-mem = ' || net_mem);
--         SDO_NET_MEM.NETWORK_MANAGER.READ_NETWORK (net_mem, 'TRUE');
--      END IF;
--   END;
END lb_path;
/
