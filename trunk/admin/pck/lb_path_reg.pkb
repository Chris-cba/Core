CREATE OR REPLACE PACKAGE BODY lb_path_reg
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_path_reg.pkb-arc   1.6   Jun 23 2017 16:46:06   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_path_reg.pkb  $
   --       Date into PVCS   : $Date:   Jun 23 2017 16:46:06  $
   --       Date fetched Out : $Modtime:   Jun 23 2017 16:46:30  $
   --       PVCS Version     : $Revision:   1.6  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge package for registration of route/pathing metadada
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.6  $';

   g_package_name   CONSTANT VARCHAR2 (30) := 'lb_path_reg';

   PROCEDURE drop_network_objects (pi_network_name IN VARCHAR2);

   PROCEDURE generate_nw_view (pi_network_name IN VARCHAR2);

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
   PROCEDURE register_nw_types (pi_network_name   IN VARCHAR2,
                                pi_node_type      IN VARCHAR2)
   AS
      CURSOR c_nlt (
         c_node_type   IN VARCHAR2)
      IS
         SELECT ptr_vc (nlt_id, nlt_nt_type)
           FROM nm_linear_types, nm_types
          WHERE     nlt_g_i_d = 'D'
                AND nlt_nt_type = nt_type
                AND nt_node_type = c_node_type;

      --
      l_nw_types   ptr_vc_array;
      --
      l_nt_list    VARCHAR2 (2000);
      --
      l_user       VARCHAR2 (100);

      FUNCTION get_nt_list (pi_nt IN ptr_vc_array_type)
         RETURN VARCHAR2
      IS
         retval   VARCHAR2 (2000);
      BEGIN
         SELECT LISTAGG ('''' || pa.ptr_value || '''', ',')
                   WITHIN GROUP (ORDER BY pa.ptr_id)
           INTO retval
           FROM TABLE (pi_nt) pa;

         RETURN retval;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20002,
                                     'Network types are not available');
      END;
   --
   BEGIN
      OPEN c_nlt (pi_node_type);

      FETCH c_nlt BULK COLLECT INTO l_nw_types.pa;

      CLOSE c_nlt;

      --
      DBMS_OUTPUT.put_line ('Count = ' || l_nw_types.pa.COUNT);

      IF l_nw_types.pa.COUNT <= 0
      THEN
         raise_application_error (-20001, 'No suitable networks to register');
      ELSE
         l_nt_list := get_nt_list (l_nw_types.pa);
      END IF;

      --
      DBMS_OUTPUT.put_line (l_nt_list);

      BEGIN
         SDO_NET.DROP_NETWORK (pi_network_name);
      --      EXCEPTION
      --         WHEN OTHERS
      --         THEN
      --            raise_application_error (
      --               -20003,
      --               'failure to drop existing network definition');
      END;

      --
--      nm_debug.delete_debug (TRUE);
--      nm_debug.debug_on;

      SELECT USER INTO l_user FROM DUAL;

--      nm_debug.debug ('current schema = ' || l_user);

      EXECUTE IMMEDIATE 'ALTER SESSION SET CURRENT_SCHEMA = '||SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER');

--      nm_debug.debug ('schema after alter session = ' || USER);

      SELECT USER INTO l_user FROM DUAL;

      nm_debug.debug ('schema after select = ' || l_user);

      BEGIN
         SDO_NET.CREATE_LOGICAL_NETWORK (pi_network_name,
                                         1,
                                         FALSE,
                                         pi_network_name || '_NO',
                                         'XNO_COST',
                                         pi_network_name || '_LINK',
                                         'XNW_COST',
                                         pi_network_name || '_PATH',
                                         pi_network_name || '_PATH_LINK',
                                         pi_network_name || '_SUB_PATH',
                                         FALSE,
                                         NULL);

         UPDATE mdsys.sdo_network_metadata_table
            SET sdo_owner = SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
          WHERE sdo_owner = l_user AND network = pi_network_name;

         EXECUTE IMMEDIATE 'ALTER SESSION SET CURRENT_SCHEMA = ' || l_user;
      EXCEPTION
         WHEN OTHERS
         THEN
            EXECUTE IMMEDIATE 'ALTER SESSION SET CURRENT_SCHEMA = ' || l_user;

            raise_application_error (-20004,
                                     'failure to register ' || SQLERRM);
      END;

      --
      lb_path.g_network := pi_network_name;

      EXECUTE IMMEDIATE
            'rename '
         || pi_network_name
         || '_LINK to '
         || pi_network_name
         || '_LINK_TABLE';

      nm3ctx.set_context ('LB_SPATIAL_FILTER_XMIN', '');
      nm3ctx.set_context ('LB_SPATIAL_FILTER_YMIN', '');
      nm3ctx.set_context ('LB_SPATIAL_FILTER_XMAX', '');
      nm3ctx.set_context ('LB_SPATIAL_FILTER_YMAX', '');

      nm3ddl.create_synonym_for_object (pi_network_name || '_LINK_TABLE');
      nm3ddl.create_synonym_for_object (pi_network_name || '_NO');

      generate_nw_view (pi_network_name);

      --
      BEGIN
         EXECUTE IMMEDIATE
               'insert into '
            || pi_network_name
            || '_LINK_TABLE'
            || ' ( link_id, link_name, start_node_id, end_node_id, link_type, active, link_level, xnw_cost ) '
            || '  select ne_id, ne_unique, ne_no_start, ne_no_end, ne_nt_type, '
            || ''''
            || 'Y'
            || ''''
            || ', 1, ne_length '
            || ' from nm_elements_all '
            || ' where ne_nt_type in ('
            || l_nt_list
            || ') and ne_type = '
            || ''''
            || 'S'
            || ''''
            || ' and ne_end_date is null ';

         COMMIT;

         --
         EXECUTE IMMEDIATE
               'insert into '
            || pi_network_name
            || '_NO '
            || ' (node_id, node_name, node_type, active, partition_id, xno_cost ) '
            || ' select no_node_id, no_node_name, no_node_type '
            || ', '
            || ''''
            || 'Y'
            || ''''
            || ', null, 0 '
            || ' from nm_nodes_all '
            || ' where no_end_date is null '
            || ' and exists ( select 1 from nm_node_usages_all where nnu_no_node_id = no_node_id '
            || '          and nnu_end_date is null ) ';


         COMMIT;
      END;
   END;

   --
   PROCEDURE drop_network (pi_network_name IN VARCHAR2)
   IS
      lnw_row      MDSYS.sdo_network_metadata_table%ROWTYPE;
      not_exists   EXCEPTION;
      PRAGMA EXCEPTION_INIT (not_exists, -942);
   BEGIN
      --
      BEGIN
         SELECT *
           INTO lnw_row
           FROM mdsys.sdo_network_metadata_table
          WHERE network = pi_network_name;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20005, 'The network does not exist');
      END;

      --
      BEGIN
         SDO_NET.DROP_NETWORK (pi_network_name);
      --  exception
      --    when others then
      --      raise_application_error(-20006, 'failure to drop existing network definition');
      END;

      --
      drop_network_objects (pi_network_name);

      DELETE FROM mdsys.sdo_network_metadata_table
            WHERE     network = pi_network_name
                  AND sdo_owner =
                         SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER');

      NM3DDL.DROP_SYNONYM_FOR_OBJECT (pi_network_name || '_LINK');
      NM3DDL.DROP_SYNONYM_FOR_OBJECT (pi_network_name || '_LINK_TABLE');
      NM3DDL.DROP_SYNONYM_FOR_OBJECT (pi_network_name || '_NO');


      COMMIT;
   END;

   PROCEDURE drop_network_objects (pi_network_name IN VARCHAR2)
   IS
      not_exists   EXCEPTION;
      PRAGMA EXCEPTION_INIT (not_exists, -942);
   BEGIN
      BEGIN
         EXECUTE IMMEDIATE 'drop table ' || pi_network_name || '_LINK_TABLE';
      EXCEPTION
         WHEN not_exists
         THEN
            NULL;
      END;

      --
      BEGIN
         EXECUTE IMMEDIATE 'drop table ' || pi_network_name || '_NO';
      EXCEPTION
         WHEN not_exists
         THEN
            NULL;
      END;

      BEGIN
         EXECUTE IMMEDIATE 'drop table ' || pi_network_name || '_PATH';
      EXCEPTION
         WHEN not_exists
         THEN
            NULL;
      END;

      BEGIN
         EXECUTE IMMEDIATE 'drop table ' || pi_network_name || '_PATH_LINK';
      EXCEPTION
         WHEN not_exists
         THEN
            NULL;
      END;

      BEGIN
         EXECUTE IMMEDIATE 'drop table ' || pi_network_name || '_SUB_PATH';
      EXCEPTION
         WHEN not_exists
         THEN
            NULL;
      END;
   END;

   PROCEDURE generate_nw_view (pi_network_name IN VARCHAR2)
   IS
      l_srid   INTEGER;
   BEGIN
      SELECT a.geoloc.sdo_srid
        INTO l_srid
        FROM v_lb_nlt_geometry2 a
       WHERE ROWNUM = 1;

      --
      EXECUTE IMMEDIATE
            'create or replace view '
         || pi_network_name
         || '_LINK '
         || ' as select * from '
         || pi_network_name
         || '_LINK_TABLE '
         || ' where link_type in ( select ptr_value from table ( lb_path.get_g_nw_types )) '
         || ' and ( ( link_id in ( select ne_id from v_lb_nlt_geometry2 where sdo_filter ( geoloc, sdo_geometry( 2003, '
         || TO_CHAR (l_srid)
         || ', NULL, sdo_elem_info_array( 1, 1003, 3), '
         || '         sdo_ordinate_array( nvl(to_number(sys_context('
         || ''''
         || 'NM3SQL'
         || ''''
         || ', '
         || ''''
         || 'LB_SPATIAL_FILTER_XMIN'
         || ''''
         || ')), -999999999 ), '
         || '                             nvl(to_number(sys_context('
         || ''''
         || 'NM3SQL'
         || ''''
         || ', '
         || ''''
         || 'LB_SPATIAL_FILTER_YMIN'
         || ''''
         || ')), -999999999 ), '
         || '                             nvl(to_number(sys_context('
         || ''''
         || 'NM3SQL'
         || ''''
         || ', '
         || ''''
         || 'LB_SPATIAL_FILTER_XMAX'
         || ''''
         || ')), 999999999 ), '
         || '                             nvl(to_number(sys_context('
         || ''''
         || 'NM3SQL'
         || ''''
         || ', '
         || ''''
         || 'LB_SPATIAL_FILTER_YMAX'
         || ''''
         || ')), 999999999 ) ))) = '
         || ''''
         || 'TRUE'
         || ''''
         || ')))';

      nm3ddl.create_synonym_for_object (pi_network_name || '_LINK');
   END;
END;
/