CREATE OR REPLACE PACKAGE BODY lb_path_reg
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_path_reg.pkb-arc   1.0   Jan 15 2015 15:24:00   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_path_reg.pkb  $
   --       Date into PVCS   : $Date:   Jan 15 2015 15:24:00  $
   --       Date fetched Out : $Modtime:   Jan 15 2015 15:23:26  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge package for registration of route/pathing metadada 
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.0  $';

   g_package_name   CONSTANT VARCHAR2 (30) := 'lb_path_reg';

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
      not_exists   EXCEPTION;
      PRAGMA EXCEPTION_INIT (not_exists, -942);

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
         SDO_NET.DROP_NETWORK (pi_network_name || '_NETWORK');
      EXCEPTION
         WHEN OTHERS
         THEN
            raise_application_error (
               -20003,
               'failure to drop existing network definition');
      END;

      --

      BEGIN
         EXECUTE IMMEDIATE 'drop table ' || pi_network_name || '_LINK';
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
         SDO_NET.CREATE_LOGICAL_NETWORK (pi_network_name || '_NETWORK',
                                         1,
                                         FALSE,
                                         pi_network_name || '_NO',
                                         'XNO_COST',
                                         pi_network_name || '_LINK',
                                         'XNW_COST',
                                         'XNW_PATH',
                                         'XNW_PATH_LINK',
                                         'XNW_SUB_PATH',
                                         FALSE,
                                         NULL);
      EXCEPTION
         WHEN OTHERS
         THEN
            raise_application_error (-20003,
                                     'failure to register ' || SQLERRM);
      END;

      --
      lb_path.g_network := pi_network_name || '_NETWORK';

      --
      BEGIN
         EXECUTE IMMEDIATE
               'insert into '
            || pi_network_name
            || '_LINK'
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

         --
         EXECUTE IMMEDIATE
               'insert into '
            || pi_network_name
            || '_NO '
            || ' (node_id, node_name, node_type, active, partition_id, xno_cost ) '
            || ' select no_node_id, no_node_name, '
            || ''''
            || 'N'
            || ''''
            || ', '
            || ''''
            || 'Y'
            || ''''
            || ', null, 0 '
            || ' from nm_nodes_all '
            || ' where no_end_date is null '
            || ' and exists ( select 1 from nm_node_usages_all where nnu_no_node_id = no_node_id '
            || '          and nnu_end_date is null ) ';
      END;
   END;
--
procedure drop_network( pi_network in varchar2) is
lnw_row user_sdo_network_metadata%rowtype;
not_exists exception;
pragma exception_init( not_exists, -942 );
begin
--
  select * into lnw_row from user_sdo_network_metadata where network = pi_network;
--
begin
    SDO_NET.DROP_NETWORK(pi_network);
  exception
    when others then
      raise_application_error(-20003, 'failure to drop existing network definition');
  end;
--

  begin
    execute immediate 'drop table '||lnw_row.link_table_name;
  exception
   when not_exists then
     NULL;
  end;
--
  begin
    execute immediate 'drop table '||lnw_row.node_table_name;
  exception
   when not_exists then
     NULL;
  end;
  
end;   
END;
/