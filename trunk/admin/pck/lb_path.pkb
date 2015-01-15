CREATE OR REPLACE PACKAGE BODY lb_path
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_path.pkb-arc   1.0   Jan 15 2015 15:15:50   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_path.pkb  $
   --       Date into PVCS   : $Date:   Jan 15 2015 15:15:50  $
   --       Date fetched Out : $Modtime:   Jan 15 2015 15:15:22  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge package for handling path data
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.0  $';

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
   FUNCTION get_path_from_gdo (pi_gdo_session_id in integer )
      RETURN SYS_REFCURSOR
   IS
   BEGIN
      RETURN NULL;
   END;

   --
   FUNCTION get_tsp_path_from_gdo  (pi_gdo_session_id in integer )
      RETURN SYS_REFCURSOR
   IS
   BEGIN
      RETURN NULL;
   END;

   --
   FUNCTION get_path_geometry (pi_path in sdo_number_array )
      RETURN SYS_REFCURSOR
   IS
   BEGIN
      RETURN NULL;
   END;

   --
   FUNCTION get_sdo_path_geometry (pi_path in sdo_number_array )
      RETURN mdsys.sdo_geometry
   IS
   retval mdsys.sdo_geometry;
   l_v sdo_number_array;
   l_geom  mdsys.SDO_GEOMETRY_ARRAY;
   BEGIN
     select geoloc
     bulk collect into l_geom
     from V_LB_NLT_GEOMETRY, table( pi_path ) t
     where  t.column_value = ne_id;
--
     for i in 1..pi_path.count loop
       if i = 1 then
         retval := l_geom(i);
       else
         retval :=  SDO_LRS.CONCATENATE_GEOM_SEGMENTS(retval, l_geom(i), 0.05 );
       end if;
     end loop;  

     retval := sdo_lrs.convert_to_std_geom(retval);
--     
     return retval;
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
   BEGIN
      res_string := SDO_NET_MEM.NETWORK_MANAGER.LIST_NETWORKS;

      IF res_string = net_mem
      THEN
         NULL;
      ELSE
         nm_debug.debug( 'net-mem = '||net_mem );
         SDO_NET_MEM.NETWORK_MANAGER.READ_NETWORK (net_mem, 'TRUE');
      END IF;

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

   FUNCTION get_tsp_sdo_path (p_nodes IN sdo_number_array)
      RETURN sdo_number_array IS
      l_v      sdo_number_array;
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
   PROCEDURE set_network (pi_network IN VARCHAR2)
   IS
   BEGIN
      g_network := pi_network;
   END;
--
   FUNCTION node_state(p_node_id in integer) return varchar2 is
   begin
     return sdo_net_mem.node.get_state(g_network, p_node_id );
   exception
     when others then return null;   
   end;
--
   FUNCTION get_path_as_lb_rpt_tab (p_no_1 INTEGER, p_no_2 INTEGER)
      RETURN lb_rpt_tab as
   retval lb_rpt_tab;
   begin
   
     nm3ctx.set_context('START_NODE', to_char(p_no_1));
     nm3ctx.set_context('END_NODE', to_char(p_no_2));
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
  FROM (SELECT 1 ne_id,
                       nlt_id,
                       'PATH' obj_type,
                       1 obj_id,
                       1 seg_id,
                       path_seq,
                       dir_flag,
                       0 start_m,
                       p.ne_length end_m,
                       nlt_units
                  FROM nm_linear_types, nm_elements e, v_lb_path_links p
                 WHERE     e.ne_id = p.ne_id
                       AND e.ne_nt_type = nlt_nt_type
                       AND nlt_gty_type IS NULL
                       AND nlt_g_i_d = 'D');
   return retval;
end;                       
 
begin
  set_network('XHA_ESU_NETWORK');
END lb_path;
/
