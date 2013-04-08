CREATE OR REPLACE PACKAGE BODY nm3merge IS
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3merge.pkb-arc   2.9.1.1   Apr 08 2013 12:10:12   Rob.Coupe  $
--       Module Name      : $Workfile:   nm3merge.pkb  $
--       Date into PVCS   : $Date:   Apr 08 2013 12:10:12  $
--       Date fetched Out : $Modtime:   Apr 08 2013 12:07:58  $
--       PVCS Version     : $Revision:   2.9.1.1  $
--
--   Author : ITurnbull
--
--     nm3merge package. Used for merging 2 elements
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2000
-----------------------------------------------------------------------------
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.9.1.1  $"';
--  g_body_sccsid is the SCCS ID for the package body
   g_package_name    CONSTANT  varchar2(30)   := 'nm3merge';
--
   g_new_element_length    nm_elements.ne_length%TYPE;
   g_starting_ne_id        nm_elements.ne_id%type;
--
   g_rec_nit               nm_inv_types%ROWTYPE;
   g_nw_operation_in_progress boolean := FALSE;
--
   g_ausec_status varchar2(3);
--
--
------------------------------------------------------------------------------------------------
--
PROCEDURE merge_members (p_ne_id_1        nm_elements.ne_id%TYPE
                        ,p_ne_id_2        nm_elements.ne_id%TYPE
                        ,p_ne_id_new      nm_elements.ne_id%TYPE
                        ,p_starting_ne_id nm_elements.ne_id%TYPE
                        ,p_effective_date date
                        ,p_merge_at_node  nm_elements.ne_no_start%TYPE
                        );
--
------------------------------------------------------------------------------------------------
--
PROCEDURE merge_members_by_in (p_ne_id_of_1       nm_elements.ne_id%TYPE
                              ,p_ne_id_of_2       nm_elements.ne_id%TYPE
                              ,p_ne_id_of_new     nm_elements.ne_id%TYPE
                              ,p_ne_id_to_flip    nm_elements.ne_id%TYPE
                              ,p_starting_ne_id   nm_elements.ne_id%TYPE
                              ,p_effective_date   date
                              ,p_ne_id_in         nm_elements.ne_id%TYPE
                              ,p_datum_length_1   nm_elements.ne_length%TYPE
                              ,p_datum_length_2   nm_elements.ne_length%TYPE
                              );
                              
procedure merge_other_product_stp(p_ne_id_1        nm_elements.ne_id%TYPE
                                 ,p_ne_id_2        nm_elements.ne_id%TYPE
                                 ,p_ne_id_new      nm_elements.ne_id%TYPE
                                 ,p_ne_length_1           in number
                                 ,p_ne_length_2           in number
                                 ,p_flip_cardinality_of_2   VARCHAR2
                                 ,p_effective_date date DEFAULT TRUNC(SYSDATE)
                                 );
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
------------------------------------------------------------------------------------------------
--
--
------------------------------------------------------------------------------------------------
--
PROCEDURE set_for_merge IS

BEGIN
   g_ausec_status := nm3ausec.get_status;
   nm3ausec.set_status(nm3type.c_off);
   nm3merge.set_nw_operation_in_progress;
   nm3merge.clear_nmh_variables;   
END set_for_merge;   
--
------------------------------------------------------------------------------------------------
--
PROCEDURE set_for_return IS

BEGIN
      nm3ausec.set_status(g_ausec_status);
      nm3merge.set_nw_operation_in_progress(FALSE);
END set_for_return;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE check_for_lost_connectivity (p_ne_id_1 IN number
                                      ,p_ne_id_2 IN number
                                      ) IS
   CURSOR c_check_usage (c_ne_id_1  number
                        ,c_ne_id_2  number
                        ,c_node number
                        ) IS
   SELECT 1
    FROM  nm_node_usages
   WHERE  nnu_no_node_id = c_node
    AND   nnu_ne_id NOT IN (c_ne_id_1, c_ne_id_2);
--
   CURSOR c_get_node (c_ne_id_1  number
                     ,c_ne_id_2  number
                     ) IS
   SELECT nnu1.nnu_no_node_id
    FROM  nm_node_usages nnu1
         ,nm_node_usages nnu2
   WHERE  nnu1.nnu_ne_id      = c_ne_id_1
    AND   nnu2.nnu_ne_id      = c_ne_id_2
    AND   nnu1.nnu_no_node_id = nnu2.nnu_no_node_id;
--
   l_dummy    pls_integer;
   l_node     nm_node_usages.nnu_no_node_id%TYPE;
   l_culdesac boolean;
--
BEGIN
--
   nm_debug.proc_start(g_package_name , 'check_for_lost_connectivity');
--
   -- Checks for other elements at a node
   -- were the two passed ne_ids are being merged at the node
--
   OPEN  c_get_node (p_ne_id_1, p_ne_id_2);
   FETCH c_get_node INTO l_node;
   CLOSE c_get_node;
--
   OPEN  c_check_usage (p_ne_id_1, p_ne_id_2, l_node);
   FETCH c_check_usage INTO l_dummy;
   l_culdesac := c_check_usage%FOUND;
   CLOSE c_check_usage;
   IF l_culdesac
    THEN
      RAISE_APPLICATION_ERROR ( -20150 ,'Merge will result in a loss of connectivity');
   END IF;
--
   nm_debug.proc_end(g_package_name , 'check_for_lost_connectivity');
--
END check_for_lost_connectivity;
--
------------------------------------------------------------------------------------------------
--
   -- sort out the start and end nodes of the new element
PROCEDURE organise_nodes (p_ne1        IN     nm_elements.ne_id%TYPE
                         ,p_ne2        IN     nm_elements.ne_id%TYPE
                         ,p_no_id      IN     nm_elements.ne_no_start%TYPE
                         ,p_start_node    OUT nm_elements.ne_no_start%TYPE
                         ,p_end_node      OUT nm_elements.ne_no_end%TYPE
                         ) IS
--
   CURSOR cs_nodes IS
   SELECT nnu_ne_id
         ,nnu_node_type
         ,nnu_no_node_id
    FROM  nm_node_usages_all
   WHERE  nnu_ne_id IN ( p_ne1, p_ne2 )
   ORDER BY DECODE(nnu_ne_id
                  ,p_ne1,1
                  ,2
                  )
           ,DECODE(nnu_no_node_id
                  ,p_no_id,2
                  ,1
                  );
--
   n1_type varchar2(1);
   n2_type varchar2(2);
   new_start nm_nodes.no_node_id%TYPE;
   new_end   nm_nodes.no_node_id%TYPE;
--
BEGIN
   nm_debug.proc_start(g_package_name , 'organise_nodes');
   FOR irec IN cs_nodes
    LOOP
      --dbms_output.put_line( TO_CHAR(cs_nodes%ROWCOUNT) );
      IF    cs_nodes%rowcount = 1
       THEN
         --dbms_output.put_line('First element, uncommon node is '||irec.nnu_node_type );
         n1_type := irec.nnu_node_type;
         IF n1_type = 'S'
          THEN
            new_start := irec.nnu_no_node_id;
         ELSE
            new_end := irec.nnu_no_node_id;
         END IF;
      ELSIF cs_nodes%rowcount = 3
       THEN
         --dbms_output.put_line('Second element, uncommon node is '||irec.nnu_node_type );
         n2_type := irec.nnu_node_type;
         IF new_start IS NULL
          THEN
            new_start := irec.nnu_no_node_id;
          ELSE
            new_end   := irec.nnu_no_node_id;
          END IF;
      END IF;
   END LOOP;
--
   p_start_node := new_start;
   p_end_node   := new_end;
--
   --dbms_output.put_line ( 'New sections starts at '||TO_CHAR(p_start_node)||', ends at '||TO_CHAR(p_end_node));
--
   nm_debug.proc_end(g_package_name , 'ORGANISE_NODES');
--
END organise_nodes;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE set_leg_numbers (p_ne_id_1 nm_elements.ne_id%TYPE
                          ,p_ne_id_2 nm_elements.ne_id%TYPE
                          ,p_ne_id_new nm_elements.ne_id%TYPE
                          ) IS
--
   v_leg_no     nm_node_usages.nnu_leg_no%TYPE := 9; -- default value of 9
--
BEGIN
--
   nm_debug.proc_start(g_package_name , 'SET_LEG_NUMBERS');
   -- update the leg details
   -- start node of the new element takes the leg no of the 1st element
--
   v_leg_no := nm3net.get_leg_number (p_ne_id_1, nm3net.get_start_node(p_ne_id_1));
--
   UPDATE nm_node_usages
    SET   nnu_leg_no     = v_leg_no
   WHERE  nnu_ne_id      = p_ne_id_new
    AND   nnu_no_node_id = nm3net.get_start_node(p_ne_id_new);
--
   -- end node of the new element takes the leg no of the 1st element
   v_leg_no := nm3net.get_leg_number (p_ne_id_2, nm3net.get_end_node(p_ne_id_2));
--
   UPDATE nm_node_usages
    SET   nnu_leg_no     = v_leg_no
   WHERE  nnu_ne_id      = p_ne_id_new
    AND   nnu_no_node_id = nm3net.get_end_node(p_ne_id_new);
--
   nm_debug.proc_end(g_package_name , 'SET_LEG_NUMBERS');
--
END set_leg_numbers;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE audit_element_history(pi_ne_id_new      IN nm_elements.ne_id%type
                               ,pi_ne_id_1        IN nm_elements.ne_id%type
                               ,pi_length_1       IN nm_elements.ne_length%type
                               ,pi_ne_id_2        IN nm_elements.ne_id%type
                               ,pi_length_2       IN nm_elements.ne_length%type
                               ,pi_effective_date IN date
                               ,pi_neh_descr      IN nm_element_history.neh_descr%TYPE  DEFAULT NULL --CWS 0108990 12/03/2010
                               ) IS

  l_rec_neh nm_element_history%ROWTYPE;
      
  l_ne_id_1  nm_elements.ne_id%TYPE;
  l_length_1 nm_elements.ne_length%TYPE;
      
  l_ne_id_2  nm_elements.ne_id%TYPE;
  l_length_2 nm_elements.ne_length%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'audit_element_history');

 --ensure we audit the old elements in the correct order
  IF g_starting_ne_id = pi_ne_id_1
  THEN
    l_ne_id_1  := pi_ne_id_1;
    l_length_1 := pi_length_1;
       
    l_ne_id_2  := pi_ne_id_2;
    l_length_2 := pi_length_2;
  else
    l_ne_id_1  := pi_ne_id_2;
    l_length_1 := pi_length_2;
       
    l_ne_id_2  := pi_ne_id_1;
    l_length_2 := pi_length_1;
  end if;
   
  l_rec_neh.neh_id             := nm3seq.next_neh_id_seq;
  l_rec_neh.neh_ne_id_old      := l_ne_id_1;
  l_rec_neh.neh_ne_id_new      := pi_ne_id_new;
  l_rec_neh.neh_operation      := 'M';
  l_rec_neh.neh_effective_date := pi_effective_date;
  l_rec_neh.neh_old_ne_length  := l_length_1;
  l_rec_neh.neh_new_ne_length  := l_length_1 + l_length_2;
  --note this is the first merged element
  l_rec_neh.neh_param_1        := 1;
  l_rec_neh.neh_param_2        := NULL;
  l_rec_neh.neh_descr          := pi_neh_descr; --CWS 0108990 12/03/2010
      
  nm3nw_edit.ins_neh(l_rec_neh); --CWS 0108990 12/03/2010
      
  l_rec_neh.neh_id             := nm3seq.next_neh_id_seq;
  l_rec_neh.neh_ne_id_old      := l_ne_id_2;
  l_rec_neh.neh_old_ne_length  := l_length_2;
  --note this is the second merged element
  l_rec_neh.neh_param_1        := 2;

  nm3nw_edit.ins_neh(l_rec_neh); --CWS 0108990 12/03/2010

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'audit_element_history');

END audit_element_history;
--
------------------------------------------------------------------------------------------------
--   -- merge the elements
PROCEDURE merge_elements (p_ne_id_1               IN     nm_elements.ne_id%TYPE
                         ,p_ne_id_2               IN     nm_elements.ne_id%TYPE
                         ,p_ne_id_new             IN OUT nm_elements.ne_id%TYPE
                         ,p_effective_date        IN     date                               DEFAULT nm3user.get_effective_date
                         ,p_merge_at_node         IN     nm_elements.ne_no_start%TYPE       DEFAULT NULL
                         ,p_ne_unique_new         IN     nm_elements.ne_unique%TYPE         DEFAULT NULL
                         ,p_ne_type_new           IN     nm_elements.ne_type%TYPE           DEFAULT NULL
                         ,p_ne_nt_type_new        IN     nm_elements.ne_nt_type%TYPE        DEFAULT NULL
                         ,p_ne_descr_new          IN     nm_elements.ne_descr%TYPE          DEFAULT NULL
                         ,p_ne_length_new         IN     nm_elements.ne_length%TYPE         DEFAULT NULL
                         ,p_ne_admin_unit_new     IN     nm_elements.ne_admin_unit%TYPE     DEFAULT NULL
                         ,p_ne_gty_group_type_new IN     nm_elements.ne_gty_group_type%TYPE DEFAULT NULL
                         ,p_ne_owner_new          IN     nm_elements.ne_owner%TYPE          DEFAULT NULL
                         ,p_ne_name_1_new         IN     nm_elements.ne_name_1%TYPE         DEFAULT NULL
                         ,p_ne_name_2_new         IN     nm_elements.ne_name_2%TYPE         DEFAULT NULL
                         ,p_ne_prefix_new         IN     nm_elements.ne_prefix%TYPE         DEFAULT NULL
                         ,p_ne_number_new         IN     nm_elements.ne_number%TYPE         DEFAULT NULL
                         ,p_ne_sub_type_new       IN     nm_elements.ne_sub_type%TYPE       DEFAULT NULL
                         ,p_ne_group_new          IN     nm_elements.ne_group%TYPE          DEFAULT NULL
                         ,p_ne_no_start_new       IN     nm_elements.ne_no_start%TYPE       DEFAULT NULL
                         ,p_ne_no_end_new         IN     nm_elements.ne_no_end%TYPE         DEFAULT NULL
                         ,p_ne_sub_class_new      IN     nm_elements.ne_sub_class%TYPE       DEFAULT NULL
                         ,p_ne_nsg_ref_new        IN     nm_elements.ne_nsg_ref%TYPE        DEFAULT NULL
                         ,p_ne_version_no_new     IN     nm_elements.ne_version_no%TYPE     DEFAULT NULL
                         ,p_test_poe_at_node      IN     varchar2                           DEFAULT 'N'
                         ,p_neh_descr             IN     nm_element_history.neh_descr%TYPE  DEFAULT NULL --CWS 0108990 12/03/2010
                         ) IS
--
   -- flexible attributes (columns) to inherit
   CURSOR cs_inherited_columns (c_nt_type nm_type_columns.ntc_nt_type%TYPE) IS
   SELECT ntc_column_name
   FROM nm_type_columns a
   WHERE ntc_nt_type = c_nt_type
     AND ntc_inherit = 'Y';
   --
   CURSOR cs_type_inclusion (c_nt_type nm_type_inclusion.nti_nw_child_type%TYPE)IS
   SELECT *
    FROM  nm_type_inclusion
   WHERE  nti_nw_child_type = c_nt_type;
   --
   v_ne_length_2   nm_elements.ne_length%TYPE   := p_ne_length_new;
   v_merge_at_node nm_elements.ne_no_start%TYPE := p_merge_at_node;
--
BEGIN
--
   nm_debug.proc_start(g_package_name , 'merge_elements');
--
   g_rec_ne2 := g_empty_rec_ne;
--
   g_rec_ne2.ne_unique         := p_ne_unique_new;
   g_rec_ne2.ne_type           := p_ne_type_new;
   g_rec_ne2.ne_nt_type        := p_ne_nt_type_new;
   g_rec_ne2.ne_descr          := p_ne_descr_new;
   g_rec_ne2.ne_length         := p_ne_length_new;
   g_rec_ne2.ne_admin_unit     := p_ne_admin_unit_new;
   g_rec_ne2.ne_gty_group_type := p_ne_gty_group_type_new;
   g_rec_ne2.ne_owner          := p_ne_owner_new;
   g_rec_ne2.ne_name_1         := p_ne_name_1_new;
   g_rec_ne2.ne_name_2         := p_ne_name_2_new;
   g_rec_ne2.ne_prefix         := p_ne_prefix_new;
   g_rec_ne2.ne_number         := p_ne_number_new;
   g_rec_ne2.ne_sub_type       := p_ne_sub_type_new;
   g_rec_ne2.ne_group          := p_ne_group_new;
   g_rec_ne2.ne_no_start       := p_ne_no_start_new;
   g_rec_ne2.ne_no_end         := p_ne_no_end_new;
   g_rec_ne2.ne_sub_class      := p_ne_sub_class_new;
   g_rec_ne2.ne_nsg_ref        := p_ne_nsg_ref_new;
   g_rec_ne2.ne_version_no     := p_ne_version_no_new;
--
   -- if p_merge_at_node is null then work out what the connecting node is
--RC> Task 0111189  - allowing a choice of the node on which to merge can be at odds with the choice of direction derived from the order of the merge elements.
--    Ignore the merge node.


   v_merge_at_node := nm3net.get_element_shared_node (p_ne_id_1,p_ne_id_2);
--   IF v_merge_at_node IS NULL
--    THEN
--      v_merge_at_node := nm3net.get_element_shared_node (p_ne_id_1,p_ne_id_2);
--   END IF;
--RC> End of task 0111189
--
   -- get the start and end nodes
   -- organise_nodes(p_ne_id_1, p_ne_id_2, v_merge_at_node, g_rec_ne2.ne_no_start, g_rec_ne2.ne_no_end);
--
   g_rec_ne1 := nm3net.get_ne (p_ne_id_1);
--
   -- check for POE at node to merge at
   IF p_test_poe_at_node = 'Y'
    THEN
--
      DECLARE
         l_been_in_loop boolean := FALSE;
         l_cursor_name  varchar2(30);
         l_tab_vc       nm3type.tab_varchar32767;
      BEGIN
         g_node_id := v_merge_at_node;
         nm3ddl.append_tab_varchar(l_tab_vc,'DECLARE',FALSE);
         nm3ddl.append_tab_varchar(l_tab_vc,'   l_parent_ne_id     nm_elements.ne_id%TYPE;');
         nm3ddl.append_tab_varchar(l_tab_vc,'   l_parent_not_found EXCEPTION;');
         nm3ddl.append_tab_varchar(l_tab_vc,'   l_node_is_poe      EXCEPTION;');
         nm3ddl.append_tab_varchar(l_tab_vc,'   l_found            BOOLEAN;');
         nm3ddl.append_tab_varchar(l_tab_vc,'BEGIN');
--
         FOR cs_rec IN cs_type_inclusion (g_rec_ne1.ne_nt_type)
          LOOP
            l_been_in_loop := TRUE;
            l_cursor_name  := SUBSTR(LOWER('cs_'||cs_rec.nti_parent_column),1,30);
            nm3ddl.append_tab_varchar(l_tab_vc,'   DECLARE');
            nm3ddl.append_tab_varchar(l_tab_vc,'      CURSOR '||l_cursor_name||' (c1 VARCHAR2) IS');
            nm3ddl.append_tab_varchar(l_tab_vc,'      SELECT ne_id');
            nm3ddl.append_tab_varchar(l_tab_vc,'       FROM  nm_elements');
            nm3ddl.append_tab_varchar(l_tab_vc,'      WHERE  '||cs_rec.nti_parent_column||' = c1;');
            nm3ddl.append_tab_varchar(l_tab_vc,'   BEGIN');
            nm3ddl.append_tab_varchar(l_tab_vc,'      OPEN  '||l_cursor_name||' ('||g_package_name||'.g_rec_ne1.'||cs_rec.nti_child_column||');');
            nm3ddl.append_tab_varchar(l_tab_vc,'      FETCH '||l_cursor_name||' INTO l_parent_ne_id;');
            nm3ddl.append_tab_varchar(l_tab_vc,'      l_found := '||l_cursor_name||'%FOUND;');
            nm3ddl.append_tab_varchar(l_tab_vc,'      CLOSE '||l_cursor_name||';');
            nm3ddl.append_tab_varchar(l_tab_vc,'      IF NOT l_found');
            nm3ddl.append_tab_varchar(l_tab_vc,'       THEN');
            nm3ddl.append_tab_varchar(l_tab_vc,'         RAISE l_parent_not_found;');
            nm3ddl.append_tab_varchar(l_tab_vc,'      END IF;');
            nm3ddl.append_tab_varchar(l_tab_vc,'      IF nm3net.is_node_poe (pi_route_id => l_parent_ne_id');
            nm3ddl.append_tab_varchar(l_tab_vc,'                            ,pi_node_id  => '||g_package_name||'.g_node_id');
            nm3ddl.append_tab_varchar(l_tab_vc,'                            )');
            nm3ddl.append_tab_varchar(l_tab_vc,'       THEN');
            nm3ddl.append_tab_varchar(l_tab_vc,'         RAISE l_node_is_poe;');
            nm3ddl.append_tab_varchar(l_tab_vc,'      END IF;');
            nm3ddl.append_tab_varchar(l_tab_vc,'   END;');
         END LOOP;
--
         nm3ddl.append_tab_varchar(l_tab_vc,'EXCEPTION');
         nm3ddl.append_tab_varchar(l_tab_vc,'   WHEN l_parent_not_found');
         nm3ddl.append_tab_varchar(l_tab_vc,'    THEN');
         nm3ddl.append_tab_varchar(l_tab_vc,'      nm3type.g_exception_code := -20501;');
         nm3ddl.append_tab_varchar(l_tab_vc,'      nm3type.g_exception_msg  := '||nm3flx.string('Auto Inclusion parent not found')||';');
         nm3ddl.append_tab_varchar(l_tab_vc,'      RAISE_APPLICATION_ERROR(nm3type.g_exception_code,nm3type.g_exception_msg);');
         nm3ddl.append_tab_varchar(l_tab_vc,'   WHEN l_node_is_poe');
         nm3ddl.append_tab_varchar(l_tab_vc,'    THEN');
         nm3ddl.append_tab_varchar(l_tab_vc,'      nm3type.g_exception_code := -20002;');
         nm3ddl.append_tab_varchar(l_tab_vc,'      nm3type.g_exception_msg  := '||nm3flx.string('There is a POE at the node')||';');
         nm3ddl.append_tab_varchar(l_tab_vc,'      RAISE_APPLICATION_ERROR(nm3type.g_exception_code,nm3type.g_exception_msg);');
         nm3ddl.append_tab_varchar(l_tab_vc,'END;');
--
         IF l_been_in_loop
          THEN
            nm3ddl.execute_tab_varchar(l_tab_vc);
         END IF;
      END;
--
   END IF;
--
   IF p_ne_id_new IS NULL
    THEN
      p_ne_id_new := nm3net.get_next_ne_id;
   END IF;
--
   -- get the details required from the second element
   DECLARE
      l_rec_ne nm_elements%ROWTYPE;
   BEGIN
      l_rec_ne      := nm3net.get_ne(p_ne_id_2);
      v_ne_length_2 := l_rec_ne.ne_length;
   END;
--
   DECLARE
      l_been_in_loop boolean := FALSE;
      l_tab_vc       nm3type.tab_varchar32767;
   BEGIN
      nm3ddl.append_tab_varchar(l_tab_vc,'BEGIN',FALSE);
      FOR c2rec IN cs_inherited_columns (g_rec_ne1.ne_nt_type)
       LOOP
         l_been_in_loop := TRUE;
         nm3ddl.append_tab_varchar(l_tab_vc,'   '||g_package_name||'.g_rec_ne2.'||c2rec.ntc_column_name||' := '||g_package_name||'.g_rec_ne1.'||c2rec.ntc_column_name||';');
      END LOOP;
      nm3ddl.append_tab_varchar(l_tab_vc,'END;');
      IF l_been_in_loop
       THEN
         nm3ddl.execute_tab_varchar(l_tab_vc);
      END IF;
   END;
--
   g_rec_ne2.ne_type           := NVL(g_rec_ne2.ne_type,g_rec_ne1.ne_type);
   g_rec_ne2.ne_nt_type        := NVL(g_rec_ne2.ne_nt_type,g_rec_ne1.ne_nt_type);
   g_rec_ne2.ne_descr          := NVL(g_rec_ne2.ne_descr,g_rec_ne1.ne_descr);
   g_rec_ne2.ne_admin_unit     := NVL(g_rec_ne2.ne_admin_unit,g_rec_ne1.ne_admin_unit);
   g_rec_ne2.ne_gty_group_type := NVL(g_rec_ne2.ne_gty_group_type,g_rec_ne1.ne_gty_group_type);
--
   g_new_element_length        := g_rec_ne1.ne_length + v_ne_length_2;
--
--nm_debug.debug('calling insert element');
--nm_debug.debug('g_rec_ne2.ne_no_start='||NVL(g_rec_ne2.ne_no_start,p_ne_no_start_new));
--nm_debug.debug('g_rec_ne2.ne_no_end='||NVL(g_rec_ne2.ne_no_end,p_ne_no_end_new));

   nm3net.insert_element (p_ne_id             => p_ne_id_new
                         ,p_ne_unique         => g_rec_ne2.ne_unique
                         ,p_ne_length         => g_new_element_length
                         ,p_ne_start_date     => p_effective_date
                         ,p_ne_no_start       => NVL(g_rec_ne2.ne_no_start,p_ne_no_start_new)
                         ,p_ne_no_end         => NVL(g_rec_ne2.ne_no_end,p_ne_no_end_new)
                         ,p_ne_type           => g_rec_ne2.ne_type
                         ,p_ne_nt_type        => g_rec_ne2.ne_nt_type
                         ,p_ne_descr          => g_rec_ne2.ne_descr
                         ,p_ne_admin_unit     => g_rec_ne2.ne_admin_unit
                         ,p_ne_gty_group_type => g_rec_ne2.ne_gty_group_type
                         ,p_ne_owner          => g_rec_ne2.ne_owner
                         ,p_ne_name_1         => g_rec_ne2.ne_name_1
                         ,p_ne_name_2         => g_rec_ne2.ne_name_2
                         ,p_ne_prefix         => g_rec_ne2.ne_prefix
                         ,p_ne_number         => g_rec_ne2.ne_number
                         ,p_ne_sub_type       => g_rec_ne2.ne_sub_type
                         ,p_ne_group          => g_rec_ne2.ne_group
                         ,p_ne_sub_class      => g_rec_ne2.ne_sub_class
                         ,p_ne_nsg_ref        => g_rec_ne2.ne_nsg_ref
                         ,p_ne_version_no     => g_rec_ne2.ne_version_no
                         ,p_auto_include      => 'N'
                         );
nm_debug.debug('done calling insert element');
--
   set_leg_numbers( p_ne_id_1, p_ne_id_2, p_ne_id_new );
--
  audit_element_history(pi_ne_id_new      => p_ne_id_new
                       ,pi_ne_id_1        => p_ne_id_1
                       ,pi_length_1       => g_ne_1_datum_length
                       ,pi_ne_id_2        => p_ne_id_2
                       ,pi_length_2       => g_ne_2_datum_length
                       ,pi_effective_date => p_effective_date
                       ,pi_neh_descr      => p_neh_descr --CWS 0108990 12/03/2010
                       );

   nm_debug.proc_end(g_package_name , 'merge_elements');
--
END merge_elements;
--
------------------------------------------------------------------------------------------------
--
   -- end date all members
PROCEDURE end_date_members_internal (p_ne_id_1        nm_elements.ne_id%TYPE
                                    ,p_ne_id_2        nm_elements.ne_id%TYPE
                                    ,p_new_ne_id      nm_elements.ne_id%TYPE
                                    ,p_effective_date date DEFAULT SYSDATE
                                    ) IS
   l_ne_id nm_elements.ne_id%TYPE := p_ne_id_1;
BEGIN
--
   nm_debug.proc_start(g_package_name,'end_date_members_internal');
--
   -- Do this in a simple loop so we don't duplicate the call to end_date_members
   FOR i IN 1..2
    LOOP
      end_date_members (p_nm_ne_id_of_old => l_ne_id
                       ,p_nm_ne_id_of_new => p_new_ne_id
                       ,p_effective_date  => p_effective_date
                       );
      l_ne_id := p_ne_id_2;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'end_date_members_internal');
--
END end_date_members_internal;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_new_chainage(pi_rse_length_1          IN nm_elements.ne_length%TYPE
                         ,pi_rse_length_2          IN nm_elements.ne_length%TYPE
                         ,pi_rse_sys_flag          IN VARCHAR2
                         ,pi_chainage_section      IN NUMBER DEFAULT 1  -- either 1 or 2
                         ,pi_new_starting_section  IN NUMBER DEFAULT 1   -- following a merge which section is the section from which the start should be measured
                         ,pi_original_chainage     IN NUMBER
                         ,pi_cardinality_flipped   IN VARCHAR2 DEFAULT 'N') RETURN NUMBER IS

    l_retval    NUMBER;
    l_length_1           NUMBER := NVL(pi_rse_length_1,0);
    l_length_2           NUMBER := NVL(pi_rse_length_2,0);
    l_original_chainage  NUMBER := NVL(pi_original_chainage,0);

BEGIN
  

    IF pi_chainage_section = 1 THEN 

      IF pi_new_starting_section = 1 THEN
        RETURN(l_original_chainage);
      ELSE
        RETURN(l_length_2 + l_original_chainage);
       END IF;
  
    ELSIF pi_chainage_section = 2 THEN

       IF pi_new_starting_section = 2 THEN 
          IF pi_cardinality_flipped = 'N' THEN
             RETURN( l_original_chainage );
           ELSE
             RETURN( l_length_2 - l_original_chainage );
          END IF;
       ELSE
         IF pi_cardinality_flipped = 'N' THEN	   
           RETURN(l_length_1 + l_original_chainage);
         ELSE
           RETURN( (l_length_1 + l_length_2) - l_original_chainage );
         END IF;
       END IF;

    ELSE
      RETURN(0);
    END IF;
  
  
END get_new_chainage;
--
------------------------------------------------------------------------------------------------
--
procedure merge_other_product_stp(p_ne_id_1        nm_elements.ne_id%TYPE
                                 ,p_ne_id_2        nm_elements.ne_id%TYPE
                                 ,p_ne_id_new      nm_elements.ne_id%TYPE
                                 ,p_ne_length_1           in number
                                 ,p_ne_length_2           in number
                                 ,p_flip_cardinality_of_2   VARCHAR2
                                 ,p_effective_date date                         DEFAULT TRUNC(SYSDATE)
                                 )
is
  l_block   varchar2(32767);
  
begin
--  stp_dbg.putln(g_package_name||'.merge_other_product_stp('
--    ||'p_ne_id_1='||p_ne_id_1
--    ||', p_ne_id_2='||p_ne_id_2
--    ||', p_ne_id_new='||p_ne_id_new
--    ||', p_flip_cardinality_of_2='||p_flip_cardinality_of_2
--    ||', p_effective_date='||p_effective_date
--    ||')');
    
   -- Check if schemes is installed and do merge
   IF hig.is_product_licensed( nm3type.c_stp )
    THEN
  
       l_block :=            'BEGIN'
                  ||CHR(10)||'   stp_network_ops.do_merge(pi_ne_id_new             => :p_ne_id_new'
                  ||CHR(10)||'                           ,pi_ne_id1                => :p_ne_id_1'
                  ||CHR(10)||'                           ,pi_ne_id2                => :p_ne_id_2'
                  ||CHR(10)||'                           ,pi_ne_length_1           => :p_ne_length_1'
                  ||CHR(10)||'                           ,pi_ne_length_2           => :p_ne_length_2'
                  ||CHR(10)||'                           ,pi_effective_date        => :p_effective_date'
                  ||CHR(10)||'                           ,pi_flip_cardinality_of_2 => :p_flip_cardinality_of_2);'
                  ||CHR(10)||'END;';

       EXECUTE IMMEDIATE l_block
        USING IN p_ne_id_new
                ,p_ne_id_1
                ,p_ne_id_2
                ,p_ne_length_1
                ,p_ne_length_2
                ,p_effective_date
                ,p_flip_cardinality_of_2;
   END IF;
end;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE merge_other_products (p_ne_id_1        nm_elements.ne_id%TYPE
                               ,p_ne_id_2        nm_elements.ne_id%TYPE
                               ,p_ne_id_new      nm_elements.ne_id%TYPE
                               ,p_new_starting_ne_id   nm_elements.ne_id%TYPE
                               ,p_flip_cardinality_of_2   VARCHAR2
                               ,p_effective_date date                         DEFAULT TRUNC(SYSDATE)
                               ,p_node_id        nm_elements.ne_no_start%TYPE DEFAULT NULL
                               ) IS
   l_node_id nm_elements.ne_no_start%TYPE := p_node_id;
   l_block   varchar2(32767);
   l_new_starting_section NUMBER;
BEGIN
--
   nm_debug.proc_start(g_package_name,'merge_other_products');
--

  IF p_ne_id_1 = p_new_starting_ne_id THEN
    l_new_starting_section := 1;
  ELSE
    l_new_starting_section := 2;
  END IF;
  
  	
   -- if p_merge_at_node is null then work out what the connecting node is
   IF l_node_id IS NULL
    THEN
      l_node_id := nm3net.get_element_shared_node (p_ne_id_1,p_ne_id_2);
   END IF;
    -- Check if accidents is installed and do merge accidents
	-- GJ 05/NOV/04
	-- only call if connecting node identified - it is null on a group merge
	-- so would cause a problem
   IF hig.is_product_licensed( nm3type.c_acc ) AND l_node_id IS NOT NULL 
    THEN
      l_block :=            'BEGIN'
                 ||CHR(10)||'   accmerge.do_merge'
                 ||CHR(10)||'      (pi_ne_id_new      => :p_ne_id_new'
                 ||CHR(10)||'      ,pi_effective_date => :p_effective_date'
                 ||CHR(10)||'      ,pi_ne_id_1        => :p_ne_id_1'
                 ||CHR(10)||'      ,pi_ne_id_2        => :p_ne_id_2'
                 ||CHR(10)||'      ,pi_node_id        => :p_node_id'
                 ||CHR(10)||'      );'
                 ||CHR(10)||'END;';
      EXECUTE IMMEDIATE l_block
       USING IN p_ne_id_new
               ,p_effective_date
               ,p_ne_id_1
               ,p_ne_id_2
               ,l_node_id;
   END IF;
   -- Check if structures is installed and do merge structures
   IF hig.is_product_licensed( nm3type.c_str )
    THEN
      -- do str merge
       l_block :=            'BEGIN'
                  ||CHR(10)||'   strmerge.merge_data'
                  ||CHR(10)||'      (p_id_new         => :p_ne_id_new'
                  ||CHR(10)||'      ,p_effective_date => :p_effective_date'
                  ||CHR(10)||'      ,p_id1            => :p_ne_id_1'
                  ||CHR(10)||'      ,p_id2            => :p_ne_id_2'
                  ||CHR(10)||'      );'
                  ||CHR(10)||'END;';
       EXECUTE IMMEDIATE l_block
        USING IN p_ne_id_new
                ,p_effective_date
                ,p_ne_id_1
                ,p_ne_id_2;
   END IF;
   -- Check if MM is installed and do merge
   IF hig.is_product_licensed( nm3type.c_mai )
    THEN
      -- do mai split
  
       l_block :=            'BEGIN'
                  ||CHR(10)||'   maimerge.merge_data'
                  ||CHR(10)||'      (p_rse_he_id_new  => :p_ne_id_new'
                  ||CHR(10)||'      ,p_rse_he_id_1    => :p_ne_id_1'
                  ||CHR(10)||'      ,p_rse_he_id_2    => :p_ne_id_2'
                  ||CHR(10)||'      ,p_new_starting_section  => :p_new_starting_section'
                  ||CHR(10)||'      ,p_flip_cardinality_of_2    => :p_flip_cardinality_of_2'
                  ||CHR(10)||'      ,p_effective_date => :p_effective_date'
                  ||CHR(10)||'      );'
                  ||CHR(10)||'END;';


       EXECUTE IMMEDIATE l_block
        USING IN p_ne_id_new
                ,p_ne_id_1
                ,p_ne_id_2
                ,l_new_starting_section
                ,p_flip_cardinality_of_2
                ,p_effective_date;
   END IF;
   -- Check if PROW is installed and do merge
   IF hig.is_product_licensed( nm3type.c_prow )
    THEN
      -- do merge
       l_block :=            'BEGIN'
                  ||CHR(10)||'   prowmerge.merge_data( p_new_id     => :p_ne_id_new'
                  ||CHR(10)||'                        ,p_old_id1    => :p_ne_id_1'
                  ||CHR(10)||'                        ,p_old_id2    => :p_ne_id_2'
                  ||CHR(10)||'                        ,p_effective  => :p_effective_date'
                  ||CHR(10)||'                        );'
                  ||CHR(10)||'END;';
       EXECUTE IMMEDIATE l_block
        USING IN p_ne_id_new
                ,p_ne_id_1
                ,p_ne_id_2
                ,p_effective_date;
   END IF;
   -- Check if UKPMS is installed and do merge
   IF hig.is_product_licensed( nm3type.c_ukp )
    THEN   
      -- do merge
       l_block :=            'BEGIN'
                  ||CHR(10)||'   ukpmerge.merge( p_rse            => :p_ne_id_new'
                  ||CHR(10)||'                  ,p_rse_1          => :p_ne_id_1'
                  ||CHR(10)||'                  ,p_rse_2          => :p_ne_id_2'
                  ||CHR(10)||'                 );'
                  ||CHR(10)||'END;';
       EXECUTE IMMEDIATE l_block
        USING IN p_ne_id_new
                ,p_ne_id_1
                ,p_ne_id_2;
   END IF;
--
   nm_debug.proc_end(g_package_name,'merge_other_products');
--
END merge_other_products;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE check_other_products
                    (p_ne_id1            IN nm_elements.ne_id%TYPE
                    ,p_ne_id2            IN nm_elements.ne_id%TYPE
                    ,p_sectno            IN VARCHAR2 DEFAULT NULL
                    ,p_effective_date    IN DATE
                    ,p_errors           OUT NUMBER
                    ,p_err_text         OUT VARCHAR2
                    ) IS

   l_block    VARCHAR2(32767);
BEGIN
--
   nm_debug.proc_start(g_package_name,'check_other_products');
--
  -- Check if MM is installed and check for data
   IF hig.is_product_licensed(nm3type.c_mai)
    THEN
--
      nm_debug.debug('Check MAI before merge');
--
      l_block :=            'BEGIN'
                 ||CHR(10)||'    maimerge.check_data'
                 ||CHR(10)||'              (p_rse_he_id_1    => :p_ne_id1'
                 ||CHR(10)||'              ,p_rse_he_id_2    => :p_ne_id2'
                 ||CHR(10)||'              ,p_sect_no        => :p_sectno'
                 ||CHR(10)||'              ,p_effective_date => :p_effective_date'
                 ||CHR(10)||'              ,p_errors         => :p_errors'
                 ||CHR(10)||'              ,p_error_string   => :p_err_text'
                 ||CHR(10)||'              );'
                 ||CHR(10)||'END;';
      EXECUTE IMMEDIATE l_block
       USING IN p_ne_id1
               ,p_ne_id2
               ,p_sectno
               ,p_effective_date
        ,IN OUT p_errors
        ,IN OUT p_err_text;
--
	  nm_debug.debug('Check MAI finished');
--
  END IF;
--
   nm_debug.proc_end(g_package_name,'check_other_products');
   nm_debug.debug_off;
--
END check_other_products;
--
------------------------------------------------------------------------------------------------
--
   -- Do the merge
PROCEDURE do_merge (p_ne_id_1           IN     nm_elements.ne_id%TYPE
                   ,p_ne_id_2           IN     nm_elements.ne_id%TYPE
                   ,p_ne_id_new         IN OUT nm_elements.ne_id%TYPE
                   ,p_effective_date    IN     date                                DEFAULT nm3user.get_effective_date
                   ,p_merge_at_node     IN     nm_elements.ne_no_start%TYPE
                   ,p_ne_unique         IN     nm_elements.ne_unique%TYPE          DEFAULT NULL
                   ,p_ne_type           IN     nm_elements.ne_type%TYPE            DEFAULT NULL
                   ,p_ne_nt_type        IN     nm_elements.ne_nt_type%TYPE         DEFAULT NULL
                   ,p_ne_descr          IN     nm_elements.ne_descr%TYPE           DEFAULT NULL
                   ,p_ne_length         IN     nm_elements.ne_length%TYPE          DEFAULT NULL
                   ,p_ne_admin_unit     IN     nm_elements.ne_admin_unit%TYPE      DEFAULT NULL
                   ,p_ne_gty_group_type IN     nm_elements.ne_gty_group_type%TYPE  DEFAULT NULL
                   ,p_ne_owner          IN     nm_elements.ne_owner%TYPE           DEFAULT NULL
                   ,p_ne_name_1         IN     nm_elements.ne_name_1%TYPE          DEFAULT NULL
                   ,p_ne_name_2         IN     nm_elements.ne_name_2%TYPE          DEFAULT NULL
                   ,p_ne_prefix         IN     nm_elements.ne_prefix%TYPE          DEFAULT NULL
                   ,p_ne_number         IN     nm_elements.ne_number%TYPE          DEFAULT NULL
                   ,p_ne_sub_type       IN     nm_elements.ne_sub_type%TYPE        DEFAULT NULL
                   ,p_ne_group          IN     nm_elements.ne_group%TYPE           DEFAULT NULL
                   ,p_ne_no_start       IN     nm_elements.ne_no_start%TYPE        DEFAULT NULL
                   ,p_ne_no_end         IN     nm_elements.ne_no_end%TYPE          DEFAULT NULL
                   ,p_ne_sub_class      IN     nm_elements.ne_sub_class%TYPE       DEFAULT NULL
                   ,p_ne_nsg_ref        IN     nm_elements.ne_nsg_ref%TYPE         DEFAULT NULL
                   ,p_ne_version_no     IN     nm_elements.ne_version_no%TYPE      DEFAULT NULL
                   ,p_test_poe_at_node  IN     varchar2                            DEFAULT 'N'
                   ,p_neh_descr         IN     nm_element_history.neh_descr%TYPE   DEFAULT NULL --CWS 0108990 12/03/2010
                   ) IS
--
   l_connectivity          pls_integer;
   l_flip_cardinality_of_2 VARCHAR2(1) := 'N';
--
  l_ne_rec_1 nm_elements%ROWTYPE := nm3net.get_ne(p_ne_id_1);
  l_ne_rec_2 nm_elements%ROWTYPE := nm3net.get_ne(p_ne_id_2);
  l_ne_no_start           nm_nodes.no_node_id%TYPE;
  l_ne_no_end             nm_nodes.no_node_id%TYPE;  
  l_starting_ne_id        nm_elements.ne_id%TYPE;     

FUNCTION defrag_connectivity
           (pi_ne_id1 IN nm_node_usages.nnu_ne_id%TYPE
           ,pi_ne_id2 IN nm_node_usages.nnu_ne_id%TYPE
           ) RETURN INTEGER IS
--
--
   CURSOR c_connectivity( c_ne_1 nm_elements.ne_id%TYPE,
                          c_ne_2 nm_elements.ne_id%TYPE ) IS
     SELECT a2.nnu_node_type, Nm3net.get_type_sign( a1.nnu_node_type ),
                              Nm3net.get_type_sign( a2.nnu_node_type ), sum(1) over (order by 1)
     FROM nm_node_usages a1, nm_node_usages a2
     WHERE a1.nnu_ne_id = c_ne_1
     AND   a2.nnu_ne_id = c_ne_2
     AND   a1.nnu_no_node_id = a2.nnu_no_node_id order by 2;

   l_type1 nm_node_usages.nnu_node_type%TYPE;

   l1 INTEGER;
   l2 INTEGER;

   retval  INTEGER;
   lc      INTEGER;

BEGIN
--
   OPEN c_connectivity( pi_ne_id1, pi_ne_id2 );
   FETCH c_connectivity INTO l_type1, l1, l2, lc;
   IF c_connectivity%NOTFOUND THEN
     retval := 0;
   ELSE
     IF lc > 1 then
       retval := -99;
     ELSIF l1 = l2 THEN
       retval := 2*l2;
     ELSE
       retval := 1*l2;
     END IF;
   END IF;
   CLOSE c_connectivity;
   RETURN retval;

END defrag_connectivity;
BEGIN
--
   nm_debug.proc_start(g_package_name , 'do_merge');
   
--
  l_connectivity := nm3pla.defrag_connectivity (pi_ne_id1 => p_ne_id_1
                                               ,pi_ne_id2 => p_ne_id_2
                                               );


 IF l_connectivity = 0
    THEN
      hig.raise_ner(nm3type.c_net,168);
 ELSIF l_connectivity = +1 THEN

     --                DATUM 1                   DATUM 2 
     --        *---------------------*--------------------------*
     --        S                    E S                         E                    
     --
     l_ne_no_start            := l_ne_rec_1.ne_no_start;   
     l_ne_no_end              := l_ne_rec_2.ne_no_end;
     l_flip_cardinality_of_2  := 'N';
     l_starting_ne_id := p_ne_id_1;  -- used by merge members to determine how to determine the new overall measures
 
 ELSIF l_connectivity = -1 THEN

     --                DATUM 1                   DATUM 2 
     --        *---------------------*--------------------------*
     --        E                    S E                         S                    
     -- 
     l_ne_no_start := l_ne_rec_2.ne_no_start;   
     l_ne_no_end   := l_ne_rec_1.ne_no_end;
     l_flip_cardinality_of_2  := 'N';
     l_starting_ne_id := p_ne_id_2; -- used by merge members to determine how to determine the new overall measures          
     

 ELSIF l_connectivity = -2 THEN
 
 
     --                DATUM 1                   DATUM 2 
     --        *---------------------*--------------------------*
     --        S                    E E                         S                    
     -- 
     l_ne_no_start := l_ne_rec_1.ne_no_start;   
     l_ne_no_end   := l_ne_rec_2.ne_no_start;
     l_flip_cardinality_of_2  := 'Y';
     g_ne_id_to_flip := p_ne_id_2;
     l_starting_ne_id := p_ne_id_1; -- used by merge members to determine how to determine the new overall measures	 	      

 
 ELSIF l_connectivity = +2 THEN
 
     --                DATUM 1                   DATUM 2 
     --        *---------------------*--------------------------*
     --        E                    S S                         E                    
     l_ne_no_start := l_ne_rec_2.ne_no_end;   
     l_ne_no_end   := l_ne_rec_1.ne_no_end;
     l_flip_cardinality_of_2  := 'Y';
     g_ne_id_to_flip := p_ne_id_2;
     l_starting_ne_id := p_ne_id_2; -- used by merge members to determine how to determine the new overall measures	 	 

 END IF;
--
   g_ne_1_datum_length := nm3net.get_datum_element_length(p_ne_id_1);
   g_ne_2_datum_length := nm3net.get_datum_element_length(p_ne_id_2);
--
   g_starting_ne_id := l_starting_ne_id;
--
   merge_elements (p_ne_id_1               => p_ne_id_1
                  ,p_ne_id_2               => p_ne_id_2
                  ,p_ne_id_new             => p_ne_id_new
                  ,p_effective_date        => p_effective_date
                  ,p_merge_at_node         => p_merge_at_node
                  ,p_ne_unique_new         => p_ne_unique
                  ,p_ne_type_new           => p_ne_type
                  ,p_ne_nt_type_new        => p_ne_nt_type
                  ,p_ne_descr_new          => p_ne_descr
                  ,p_ne_length_new         => p_ne_length
                  ,p_ne_admin_unit_new     => p_ne_admin_unit
                  ,p_ne_gty_group_type_new => p_ne_gty_group_type
                  ,p_ne_owner_new          => p_ne_owner
                  ,p_ne_name_1_new         => p_ne_name_1
                  ,p_ne_name_2_new         => p_ne_name_2
                  ,p_ne_prefix_new         => p_ne_prefix
                  ,p_ne_number_new         => p_ne_number
                  ,p_ne_sub_type_new       => p_ne_sub_type
                  ,p_ne_group_new          => p_ne_group
                  ,p_ne_no_start_new       => l_ne_no_start
                  ,p_ne_no_end_new         => l_ne_no_end
                  ,p_ne_sub_class_new      => p_ne_sub_class
                  ,p_ne_nsg_ref_new        => p_ne_nsg_ref
                  ,p_ne_version_no_new     => p_ne_version_no
                  ,p_test_poe_at_node      => p_test_poe_at_node
                  ,p_neh_descr             => p_neh_descr --CWS 0108990 12/03/2010
                  );
 --
 -- RAC Merge the element shapes:
 -- Change made by AE
    nm3sdm.merge_element_shapes(p_ne_id=> p_ne_id_new, 
                               p_ne_id_1=> p_ne_id_1, 
                               p_ne_id_2=> p_ne_id_2,
                               p_ne_id_to_flip => g_ne_id_to_flip);
                                                 
 --
   merge_members (p_ne_id_1        => p_ne_id_1
                 ,p_ne_id_2        => p_ne_id_2
                 ,p_starting_ne_id => l_starting_ne_id 
                 ,p_ne_id_new      => p_ne_id_new
                 ,p_effective_date => p_effective_date
                 ,p_merge_at_node  => p_merge_at_node
                 );
 --
   end_date_members_internal (p_ne_id_1, p_ne_id_2, p_ne_id_new, p_effective_date);

 --
   merge_other_products (p_ne_id_1        => p_ne_id_1
                        ,p_ne_id_2        => p_ne_id_2
                        ,p_ne_id_new      => p_ne_id_new
                        ,p_flip_cardinality_of_2   => l_flip_cardinality_of_2
                        ,p_new_starting_ne_id      => l_starting_ne_id
                        ,p_effective_date => p_effective_date
                        ,p_node_id        => p_merge_at_node
                        );
                        
                        
  merge_other_product_stp(p_ne_id_1        => p_ne_id_1
                         ,p_ne_id_2        => p_ne_id_2
                         ,p_ne_id_new      => p_ne_id_new
                         ,p_ne_length_1    => g_ne_1_datum_length
                         ,p_ne_length_2    => g_ne_2_datum_length
                         ,p_flip_cardinality_of_2   => l_flip_cardinality_of_2
                         ,p_effective_date => p_effective_date
                         );
 -- 

   IF nm3nwad.ad_data_exist(p_ne_id_1) THEN
   
      nm3nwad.do_ad_merge( pi_new_ne_id      => p_ne_id_new
                         , pi_old_ne_id1     => p_ne_id_1
                         , pi_old_ne_id2     => p_ne_id_2
                         , pi_effective_date => p_effective_date);
                         
   END IF;                         


   --
   -- end date the original elements
 -- this has do be done here so that other
 -- merge procedures can see the elements in the date based views.
 --
   UPDATE nm_elements
    SET   ne_end_date = p_effective_date
   WHERE  ne_id IN ( p_ne_id_1, p_ne_id_2);
 --
   -- Insert the stored NM_MEMBER_HISTORY records
   ins_nmh;
 --
   nm_debug.proc_end(g_package_name , 'do_merge');
--
EXCEPTION
   WHEN nm3type.g_exception
    THEN
      set_for_return;
      RAISE_APPLICATION_ERROR(nm3type.g_exception_code,nm3type.g_exception_msg);
--   WHEN OTHERS
--    THEN
--      set_for_return;
--      RAISE;
END do_merge;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE do_geo_merge (p_ne_id_1           IN nm_elements.ne_id%TYPE
                       ,p_ne_id_2           IN nm_elements.ne_id%TYPE
                       ,p_ne_id_new         IN nm_elements.ne_id%TYPE
                       ,p_effective_date    IN date                               DEFAULT nm3user.get_effective_date
                       ,p_merge_at_node     IN nm_elements.ne_no_start%TYPE
                       ,p_ne_unique         IN nm_elements.ne_unique%TYPE         DEFAULT NULL
                       ,p_ne_type           IN nm_elements.ne_type%TYPE           DEFAULT NULL
                       ,p_ne_nt_type        IN nm_elements.ne_nt_type%TYPE        DEFAULT NULL
                       ,p_ne_descr          IN nm_elements.ne_descr%TYPE          DEFAULT NULL
                       ,p_ne_length         IN nm_elements.ne_length%TYPE         DEFAULT NULL
                       ,p_ne_admin_unit     IN nm_elements.ne_admin_unit%TYPE     DEFAULT NULL
                       ,p_ne_gty_group_type IN nm_elements.ne_gty_group_type%TYPE DEFAULT NULL
                       ,p_ne_owner          IN nm_elements.ne_owner%TYPE          DEFAULT NULL
                       ,p_ne_name_1         IN nm_elements.ne_name_1%TYPE         DEFAULT NULL
                       ,p_ne_name_2         IN nm_elements.ne_name_2%TYPE         DEFAULT NULL
                       ,p_ne_prefix         IN nm_elements.ne_prefix%TYPE         DEFAULT NULL
                       ,p_ne_number         IN nm_elements.ne_number%TYPE         DEFAULT NULL
                       ,p_ne_sub_type       IN nm_elements.ne_sub_type%TYPE       DEFAULT NULL
                       ,p_ne_group          IN  nm_elements.ne_group%TYPE         DEFAULT NULL
                       ,p_ne_no_start       IN nm_elements.ne_no_start%TYPE       DEFAULT NULL
                       ,p_ne_no_end         IN nm_elements.ne_no_end%TYPE         DEFAULT NULL
                       ,p_ne_sub_class      IN nm_elements.ne_sub_class%TYPE       DEFAULT NULL
                       ,p_ne_nsg_ref        IN nm_elements.ne_nsg_ref%TYPE        DEFAULT NULL
                       ,p_ne_version_no     IN nm_elements.ne_version_no%TYPE     DEFAULT NULL
                       ,p_test_poe_at_node  IN varchar2                           DEFAULT 'N'
                       ,p_test_sub_class    IN varchar2                           DEFAULT 'N'
                       ) IS
   v_ne_id_new nm_elements.ne_id%TYPE := p_ne_id_new;
BEGIN
   nm_debug.proc_start(g_package_name , 'do_geo_merge');

--
   check_elements_can_be_merged (pi_ne_id_1 => p_ne_id_1
                                ,pi_ne_id_2 => p_ne_id_2
                                ,pi_effective_date => p_effective_date);
   
--
   nm3lock.lock_element_and_members (p_ne_id_1);
   nm3lock.lock_element_and_members (p_ne_id_2);
--
   set_for_merge;

   do_merge (p_ne_id_1           => p_ne_id_1
            ,p_ne_id_2           => p_ne_id_2
            ,p_ne_id_new         => v_ne_id_new
            ,p_effective_date    => p_effective_date
            ,p_merge_at_node     => p_merge_at_node
            ,p_ne_unique         => p_ne_unique
            ,p_ne_type           => p_ne_type
            ,p_ne_nt_type        => p_ne_nt_type
            ,p_ne_descr          => p_ne_descr
            ,p_ne_length         => p_ne_length
            ,p_ne_admin_unit     => p_ne_admin_unit
            ,p_ne_gty_group_type => p_ne_gty_group_type
            ,p_ne_owner          => p_ne_owner
            ,p_ne_name_1         => p_ne_name_1
            ,p_ne_name_2         => p_ne_name_2
            ,p_ne_prefix         => p_ne_prefix
            ,p_ne_number         => p_ne_number
            ,p_ne_sub_type       => p_ne_sub_type
            ,p_ne_group          => p_ne_group
            ,p_ne_no_start       => p_ne_no_start
            ,p_ne_no_end         => p_ne_no_end
            ,p_ne_sub_class      => p_ne_sub_class
            ,p_ne_nsg_ref        => p_ne_nsg_ref
            ,p_ne_version_no     => p_ne_version_no
            ,p_test_poe_at_node  => p_test_poe_at_node
            );
			
   set_for_return;
   			
   nm_debug.proc_end(g_package_name , 'do_geo_merge');
END do_geo_merge;
--
------------------------------------------------------------------------------------------------
--
FUNCTION elements_on_same_route (pi_ne_id_1 number,pi_ne_id_2 number) RETURN varchar2 IS
--
   CURSOR cs_elements_in_same_route ( c_ne_id_1 number,c_ne_id_2 number)IS
   SELECT 1
    FROM  nm_members a
         ,nm_members b
   WHERE  a.nm_ne_id_of = c_ne_id_1
     AND  b.nm_ne_id_of = c_ne_id_2
     AND  a.nm_ne_id_in = b.nm_ne_id_in
     AND  a.nm_type     = 'G'
     AND  b.nm_type     = 'G';
--
   CURSOR element_in_route ( c_ne_id number ) IS
   SELECT 1
    FROM  nm_members
   WHERE  nm_ne_id_of = c_ne_id
    AND   nm_type     = 'G';
--
   l_retval boolean;
--
   l_tab_ne_id     nm3type.tab_number;
   l_tab_in_route  nm3type.tab_boolean;
   l_dummy         pls_integer;
--
BEGIN
--
   -- check that both elements are in groups
   l_tab_ne_id(1) := pi_ne_id_1;
   l_tab_ne_id(2) := pi_ne_id_2;
   --
   FOR i IN 1..l_tab_ne_id.COUNT
    LOOP
      OPEN  element_in_route (l_tab_ne_id(i));
      FETCH element_in_route INTO l_dummy;
      l_tab_in_route(i) := element_in_route%FOUND;
      CLOSE element_in_route;
   END LOOP;
--
   IF   l_tab_in_route(1)
    AND l_tab_in_route(2)
    THEN
      OPEN  cs_elements_in_same_route( pi_ne_id_1 ,pi_ne_id_2 );
      FETCH cs_elements_in_same_route INTO l_dummy;
      l_retval := cs_elements_in_same_route%FOUND;
      CLOSE cs_elements_in_same_route;
   ELSE
      -- both elements are not in routes
      -- so don't prompt for the message about elements in different routes
      l_retval := TRUE;
   END IF;
--
   RETURN SUBSTR(nm3flx.boolean_to_char(l_retval),1,1);
--
END elements_on_same_route;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE ins_neh (p_rec_neh IN OUT nm_element_history%ROWTYPE) IS
BEGIN
   IF p_rec_neh.neh_id is null
   then
     p_rec_neh.neh_id := nm3seq.next_neh_id_seq; 
   end if;
   
   INSERT INTO nm_element_history
          (neh_id
          ,neh_ne_id_old
          ,neh_ne_id_new
          ,neh_operation
          ,neh_effective_date
          ,neh_actioned_date
          ,neh_actioned_by
          ,neh_old_ne_length
          ,neh_new_ne_length
          ,neh_param_1
          ,neh_param_2
          )
   VALUES (p_rec_neh.neh_id
          ,p_rec_neh.neh_ne_id_old
          ,p_rec_neh.neh_ne_id_new
          ,p_rec_neh.neh_operation
          ,p_rec_neh.neh_effective_date
          ,NVL(p_rec_neh.neh_actioned_date,TRUNC(SYSDATE))
          ,NVL(p_rec_neh.neh_actioned_by,USER)
          ,p_rec_neh.neh_old_ne_length
          ,p_rec_neh.neh_new_ne_length
          ,p_rec_neh.neh_param_1
          ,p_rec_neh.neh_param_2
          )
   RETURNING neh_actioned_date,neh_actioned_by
   INTO      p_rec_neh.neh_actioned_date, p_rec_neh.neh_actioned_by;
END ins_neh;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_nmh_variables IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'clear_nmh_variables');
--
   g_tab_nmh_nm_ne_id_in.DELETE;
   g_tab_nmh_nm_ne_id_of_old.DELETE;
   g_tab_nmh_nm_ne_id_of_new.DELETE;
   g_tab_nmh_nm_begin_mp.DELETE;
   g_tab_nmh_nm_start_date.DELETE;
   g_tab_nmh_nm_type.DELETE;
   g_tab_nmh_nm_obj_type.DELETE;
   g_tab_nmh_nm_end_date.DELETE;
--
   nm_debug.proc_end(g_package_name,'clear_nmh_variables');
--
END clear_nmh_variables;
--
-----------------------------------------------------------------------------
--
PROCEDURE end_date_members (p_nm_ne_id_of_old        nm_members.nm_ne_id_of%TYPE
                           ,p_nm_ne_id_of_new        nm_members.nm_ne_id_of%TYPE
                           ,p_effective_date         nm_members.nm_end_date%TYPE
                           ,p_nm_type                nm_members.nm_type%TYPE     DEFAULT nm3type.c_nvl
                           ) IS
--
   l_tab_nmh_nm_ne_id_in        nm3type.tab_number;
   l_tab_nmh_nm_begin_mp        nm3type.tab_number;
   l_tab_nmh_nm_start_date      nm3type.tab_date;
   l_tab_nmh_nm_type            nm3type.tab_varchar4;
   l_tab_nmh_nm_obj_type        nm3type.tab_varchar4;
   l_tab_nmh_nm_end_date        nm3type.tab_date;
   l_tab_nm_end_mp              nm3type.tab_number;
--
   l_tab_nm_rowid               nm3type.tab_rowid;
--
   CURSOR cs_nm (c_nm_ne_id_of_old nm_members.nm_ne_id_of%TYPE
                ,c_nm_type         nm_members.nm_type%TYPE
                ) IS
   SELECT nm_ne_id_in
         ,nm_begin_mp
         ,nm_start_date
         ,nm_type
         ,nm_obj_type
         ,nm_end_date
         ,ROWID
         ,nm_end_mp
    FROM  nm_members
   WHERE  nm_ne_id_of = c_nm_ne_id_of_old
    AND   nm_type     = NVL(c_nm_type,nm_type)
   FOR UPDATE NOWAIT;
--
   l_nm_type nm_members.nm_type%TYPE := NULL;
--
   l_count   pls_integer;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'end_date_members');
--
   IF p_nm_type != nm3type.c_nvl
    THEN
      l_nm_type := p_nm_type;
   END IF;
--
   OPEN  cs_nm (p_nm_ne_id_of_old
               ,l_nm_type
               );
   FETCH cs_nm
    BULK COLLECT
    INTO l_tab_nmh_nm_ne_id_in
        ,l_tab_nmh_nm_begin_mp
        ,l_tab_nmh_nm_start_date
        ,l_tab_nmh_nm_type
        ,l_tab_nmh_nm_obj_type
        ,l_tab_nmh_nm_end_date
        ,l_tab_nm_rowid
        ,l_tab_nm_end_mp;
   CLOSE cs_nm;
--
   FORALL i IN 1..l_tab_nm_rowid.COUNT
      UPDATE nm_members
       SET   nm_end_date = p_effective_date
      WHERE  ROWID       = l_tab_nm_rowid(i);
--
   -- Move the data from the local variables into the globals
   --  so we can insert it later
   FOR i IN 1..l_tab_nmh_nm_ne_id_in.COUNT
    LOOP
      l_count                            := g_tab_nmh_nm_ne_id_in.COUNT+1;
      g_tab_nmh_nm_ne_id_in(l_count)     := l_tab_nmh_nm_ne_id_in(i);
      g_tab_nmh_nm_ne_id_of_old(l_count) := p_nm_ne_id_of_old;
      g_tab_nmh_nm_ne_id_of_new(l_count) := p_nm_ne_id_of_new;
      g_tab_nmh_nm_begin_mp(l_count)     := l_tab_nmh_nm_begin_mp(i);
      g_tab_nmh_nm_start_date(l_count)   := l_tab_nmh_nm_start_date(i);
      g_tab_nmh_nm_type(l_count)         := l_tab_nmh_nm_type(i);
      g_tab_nmh_nm_obj_type(l_count)     := l_tab_nmh_nm_obj_type(i);
      g_tab_nmh_nm_end_date(l_count)     := l_tab_nmh_nm_end_date(i);
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'end_date_members');
--
END end_date_members;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_nmh_to_variables (p_rec_nmh nm_member_history%ROWTYPE) IS
--
   c_count CONSTANT pls_integer := g_tab_nmh_nm_ne_id_in.COUNT+1;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'append_nmh_to_variables');
--
   g_tab_nmh_nm_ne_id_in(c_count)        := p_rec_nmh.nmh_nm_ne_id_in;
   g_tab_nmh_nm_ne_id_of_old(c_count)    := p_rec_nmh.nmh_nm_ne_id_of_old;
   g_tab_nmh_nm_ne_id_of_new(c_count)    := p_rec_nmh.nmh_nm_ne_id_of_new;
   g_tab_nmh_nm_begin_mp(c_count)        := p_rec_nmh.nmh_nm_begin_mp;
   g_tab_nmh_nm_start_date(c_count)      := p_rec_nmh.nmh_nm_start_date;
   g_tab_nmh_nm_type(c_count)            := p_rec_nmh.nmh_nm_type;
   g_tab_nmh_nm_obj_type(c_count)        := p_rec_nmh.nmh_nm_obj_type;
   g_tab_nmh_nm_end_date(c_count)        := p_rec_nmh.nmh_nm_end_date;
--
   nm_debug.proc_end(g_package_name,'append_nmh_to_variables');
--
END append_nmh_to_variables;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmh IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_nmh');
--
   FORALL i IN 1..g_tab_nmh_nm_ne_id_in.COUNT
      INSERT INTO nm_member_history
             (nmh_nm_ne_id_in
             ,nmh_nm_ne_id_of_old
             ,nmh_nm_ne_id_of_new
             ,nmh_nm_begin_mp
             ,nmh_nm_start_date
             ,nmh_nm_type
             ,nmh_nm_obj_type
             ,nmh_nm_end_date
             )
      VALUES (g_tab_nmh_nm_ne_id_in(i)
             ,g_tab_nmh_nm_ne_id_of_old(i)
             ,g_tab_nmh_nm_ne_id_of_new(i)
             ,g_tab_nmh_nm_begin_mp(i)
             ,g_tab_nmh_nm_start_date(i)
             ,g_tab_nmh_nm_type(i)
             ,g_tab_nmh_nm_obj_type(i)
             ,g_tab_nmh_nm_end_date(i)
             );
--
   clear_nmh_variables;
--
   nm_debug.proc_end(g_package_name,'ins_nmh');
--
END ins_nmh;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE merge_members (p_ne_id_1        nm_elements.ne_id%TYPE
                        ,p_ne_id_2        nm_elements.ne_id%TYPE
                        ,p_ne_id_new      nm_elements.ne_id%TYPE
                        ,p_starting_ne_id nm_elements.ne_id%TYPE						
                        ,p_effective_date date
                        ,p_merge_at_node  nm_elements.ne_no_start%TYPE
                        ) IS
--
   CURSOR cs_affected_in (c_ne_id_of_1 nm_members.nm_ne_id_of%TYPE
                         ,c_ne_id_of_2 nm_members.nm_ne_id_of%TYPE
                         ) IS
   SELECT nm_ne_id_in
    FROM  nm_members
   WHERE  nm_ne_id_of IN (c_ne_id_of_1,c_ne_id_of_2)
   AND NOT (    nm_type = 'G' 
            AND nm_ne_id_of = c_ne_id_of_2 
            AND nm3net.is_gty_partial(nm_obj_type) = 'N'
           )  -- KA/GJ 694396 filter out non-partial group memberships of the second original datum which we are effectively ignoring. 
   GROUP BY nm_ne_id_in;
--
   l_tab_affected      nm3type.tab_number;
--
   l_merge_at_node     nm_elements.ne_no_start%TYPE := p_merge_at_node;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'merge_members');
--
   IF l_merge_at_node IS NULL
    THEN
      l_merge_at_node := nm3net.get_element_shared_node (p_ne_id_1,p_ne_id_2);
   END IF;
--
   OPEN  cs_affected_in (p_ne_id_1, p_ne_id_2);
   FETCH cs_affected_in BULK COLLECT INTO l_tab_affected;
   CLOSE cs_affected_in;
--
   FOR i IN 1..l_tab_affected.COUNT
    LOOP
      merge_members_by_in (p_ne_id_of_1       => p_ne_id_1
                          ,p_ne_id_of_2       => p_ne_id_2
                          ,p_ne_id_of_new     => p_ne_id_new
                          ,p_ne_id_to_flip    => g_ne_id_to_flip  -- if we are flipping will only ever be p_ne_id_2
                          ,p_starting_ne_id   => p_starting_ne_id
                          ,p_effective_date   => p_effective_date
                          ,p_ne_id_in         => l_tab_affected(i)
                          ,p_datum_length_1   => g_ne_1_datum_length
                          ,p_datum_length_2   => g_ne_2_datum_length
                          );
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'merge_members');
--
END merge_members;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE merge_members_by_in (p_ne_id_of_1       nm_elements.ne_id%TYPE
                              ,p_ne_id_of_2       nm_elements.ne_id%TYPE
                              ,p_ne_id_of_new     nm_elements.ne_id%TYPE
                              ,p_ne_id_to_flip    nm_elements.ne_id%TYPE
                              ,p_starting_ne_id   nm_elements.ne_id%TYPE
                              ,p_effective_date   date
                              ,p_ne_id_in         nm_elements.ne_id%TYPE
                              ,p_datum_length_1   nm_elements.ne_length%TYPE
                              ,p_datum_length_2   nm_elements.ne_length%TYPE
                              ) IS
--
   l_cardinality nm_members.nm_cardinality%TYPE;
--
   l_rec_nm            nm_members%ROWTYPE;
   l_tab_rec_nm        nm3type.tab_rec_nm;
   l_tab_rec_nm_final  nm3type.tab_rec_nm;
   l_tab_orig_ne_id_of nm3type.tab_number;
--
   l_mem_count         pls_integer := 0;
--
   l_is_group          boolean     := FALSE;
   l_gty_is_partial    boolean     := FALSE;
--
   l_is_inv            boolean     := FALSE;
   l_inv_is_excl_point boolean     := FALSE;
--
   l_rec_excl_check    nm3invval.rec_excl_check;
--
   PROCEDURE populate_data_local (p_ne_id_of   nm_members.nm_ne_id_of%TYPE
                                 ,p_ne_length  nm_elements.ne_length%TYPE
                                 ,p_len_to_add nm_elements.ne_length%TYPE
                                 ) IS
--
      l_ignore_member boolean := FALSE;
      
      CURSOR cs_members (c_ne_id_of nm_members.nm_ne_id_of%TYPE) IS
      SELECT *
       FROM  nm_merge_members
      WHERE  nm_ne_id_of = c_ne_id_of
      ORDER BY nm_begin_mp, nm_end_mp; -- nm_seq_no;
--
   BEGIN
      FOR cs_rec IN cs_members (p_ne_id_of)
       LOOP
         --
         l_rec_nm                         := cs_rec;
--
         IF l_mem_count = 0
          THEN
            --
            -- On the first time through this loop collect some information
            --  which will be consistent for all members for this NM_NE_ID_IN
            --
            l_is_group := (cs_rec.nm_type = 'G');
            l_is_inv   := (cs_rec.nm_type = 'I');
            --
            IF l_is_inv
             THEN
               -- Inventory is ALWAYS positive Cardinality
               l_cardinality                 := 1;
            ELSE
               -- Get the cardinality of the first one
               l_cardinality                 := cs_rec.nm_cardinality;
            END IF;
            --

         IF l_is_group
             THEN
               l_gty_is_partial := nm3net.gty_is_partial (cs_rec.nm_obj_type);
            ELSIF l_is_inv
             THEN
               IF cs_rec.nm_obj_type != NVL(g_rec_nit.nit_inv_type, nm3type.c_nvl)
                THEN
                  g_rec_nit := nm3inv.get_inv_type (cs_rec.nm_obj_type);
               END IF;
               l_inv_is_excl_point := (   g_rec_nit.nit_exclusive   = 'Y' -- If this inv type is exclusive
                                      AND g_rec_nit.nit_pnt_or_cont = 'P' -- and it is Point
                                      );
            END IF;
            --
         END IF;
--
         l_rec_nm.nm_ne_id_of             := p_ne_id_of_new;
         l_rec_nm.nm_start_date           := p_effective_date;
         l_rec_nm.nm_cardinality          := l_cardinality;

         IF l_is_group
           AND NOT l_gty_is_partial
         THEN
           IF cs_rec.nm_ne_id_of = p_ne_id_of_2
           THEN
             --ignore non-partial memberships of the second element being merged
             --as they will be covered by the first elements new members
             l_ignore_member := TRUE;
           ELSE
             -- KA/GJ 694396
             -- This change assumes that only non-partial memberships being processed here 
             -- for the first original element. 
             -- The new code extends the membership to cover the entirity of the group.
             l_rec_nm.nm_begin_mp := 0;
             l_rec_nm.nm_end_mp   := p_datum_length_1 + p_datum_length_2;
           END IF;
         ELSE
           l_rec_nm.nm_begin_mp             := l_rec_nm.nm_begin_mp + p_len_to_add;
           l_rec_nm.nm_end_mp               := l_rec_nm.nm_end_mp   + p_len_to_add;
         END IF;	
         --
         IF NOT l_ignore_member
         THEN
           l_mem_count                      := l_mem_count + 1;
           l_tab_orig_ne_id_of(l_mem_count) := cs_rec.nm_ne_id_of;
           l_tab_rec_nm(l_mem_count)        := l_rec_nm;
         END IF;
      END LOOP;
   END populate_data_local;
--
   PROCEDURE duplicate_members_local (l_ne_id_of  nm_members.nm_ne_id_of%TYPE
                                     ,l_ne_length nm_elements.ne_length%TYPE
                                     ) IS
   BEGIN
      --
      -- This procedure creates a copy of the nm_members records
      --  for a specific NM_NE_ID_IN on a specific NM_NE_ID_OF
      --  getting the length complement of the NM_BEGIN_MP and NM_END_MP
      --  where necessary.
      --
      INSERT INTO nm_merge_members
      SELECT *
       FROM  nm_members
      WHERE  nm_ne_id_in = p_ne_id_in
       AND   nm_ne_id_of = l_ne_id_of;
      --
      IF l_ne_id_of = p_ne_id_to_flip
       THEN
         UPDATE nm_merge_members
          SET   nm_begin_mp    = (l_ne_length - nm_end_mp)   -- NM_END_MP is already set to ele length if null
               ,nm_end_mp      = (l_ne_length - nm_begin_mp)
               ,nm_cardinality = nm_cardinality * -1
         WHERE  nm_ne_id_of    = l_ne_id_of;
      END IF;
      --
   END duplicate_members_local;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'merge_members_by_in');
--
   DELETE FROM nm_merge_members;
   duplicate_members_local (p_ne_id_of_1, p_datum_length_1);
   duplicate_members_local (p_ne_id_of_2, p_datum_length_2);
--
   IF p_starting_ne_id = p_ne_id_of_1 
   THEN
   --
     populate_data_local (p_ne_id_of_1, p_datum_length_1, 0);
     populate_data_local (p_ne_id_of_2, p_datum_length_2, p_datum_length_1);
   --
   ELSE
   --
     populate_data_local (p_ne_id_of_1, p_datum_length_1, p_datum_length_2);
     populate_data_local (p_ne_id_of_2, p_datum_length_2, 0);
   --
   END IF;
--
   IF l_tab_rec_nm.EXISTS(1)
    THEN
      --
      -- Loop through all the "new" rec_nm records, merging them together where necessary
      --
      l_tab_rec_nm_final(1) := l_tab_rec_nm(1);
      FOR i IN 2..l_tab_rec_nm.COUNT
       LOOP
       --
--         nm_debug.debug('### l_tab_rec_nm(i-1).nm_begin_mp = '||l_tab_rec_nm(i-1).nm_begin_mp);
--         nm_debug.debug('### l_tab_rec_nm(i-1).nm_end_mp   = '||l_tab_rec_nm(i-1).nm_end_mp);
--         nm_debug.debug('### l_tab_rec_nm(i-1).nm_cardinality   = '||l_tab_rec_nm(i-1).nm_cardinality);
--         nm_debug.debug('### l_tab_rec_nm(i).nm_begin_mp = '||l_tab_rec_nm(i).nm_begin_mp);
--         nm_debug.debug('### l_tab_rec_nm(i).nm_end_mp   = '||l_tab_rec_nm(i).nm_end_mp);
--         nm_debug.debug('### l_tab_rec_nm(i).nm_cardinality   = '||l_tab_rec_nm(i).nm_cardinality);
       --
         IF l_tab_rec_nm(i).nm_begin_mp = l_tab_rec_nm(i-1).nm_end_mp
          THEN
          -- Tweak this record to extend the nm_end_mp
          --
            l_tab_rec_nm_final(l_tab_rec_nm_final.COUNT).nm_end_mp  := l_tab_rec_nm(i).nm_end_mp;
          --
            IF l_tab_rec_nm_final(l_tab_rec_nm_final.COUNT).nm_cardinality = -1
             THEN
               l_tab_rec_nm_final(l_tab_rec_nm_final.COUNT).nm_slk  := l_tab_rec_nm(i).nm_slk;
               l_tab_rec_nm_final(l_tab_rec_nm_final.COUNT).nm_true := l_tab_rec_nm(i).nm_true;
            END IF;
         --
         -- Task 0108613
         -- Deal merging of partial members with differing cardinalities
         --
         ELSIF l_tab_rec_nm(i).nm_end_mp = l_tab_rec_nm(i-1).nm_begin_mp
         THEN
         --
           l_tab_rec_nm_final(l_tab_rec_nm_final.COUNT).nm_begin_mp  := l_tab_rec_nm(i).nm_begin_mp;
           l_tab_rec_nm_final(l_tab_rec_nm_final.COUNT).nm_end_mp    := l_tab_rec_nm(i-1).nm_end_mp;
         --
           IF l_tab_rec_nm_final(l_tab_rec_nm_final.COUNT).nm_cardinality = 1
           THEN
              l_tab_rec_nm_final(l_tab_rec_nm_final.COUNT).nm_slk       := l_tab_rec_nm(i).nm_slk;
              l_tab_rec_nm_final(l_tab_rec_nm_final.COUNT).nm_true      := l_tab_rec_nm(i).nm_true;
           END IF;
         --
         -- Task 0108613 Complete
         --
         ELSE
            -- there's a gap, so add a new one
            l_tab_rec_nm_final(l_tab_rec_nm_final.COUNT+1)          := l_tab_rec_nm(i);
         END IF;
      END LOOP;
   END IF;
--
   FOR i IN 1..l_tab_rec_nm_final.COUNT
    LOOP
      --
      -- Insert all the nm_members records
      --
      l_rec_nm := l_tab_rec_nm_final(i);
      --
      nm3net.ins_nm (l_rec_nm);
      --
      l_tab_rec_nm_final(i) := l_rec_nm;
      --
   END LOOP;
--
   --
   -- Check exclusive point inventory to make sure that there is no
   --  exclusive point inventory which was previously located either side
   --  of the node which would now not be exclusive
   -- We don't need to bother with continuous, as it does not have any
   --  problems of this type caused by merging 2 elements
   --
   IF    l_is_inv
    AND  l_inv_is_excl_point
    THEN
      l_rec_excl_check.iit_ne_id             := p_ne_id_in;
      l_rec_excl_check.iit_inv_type          := g_rec_nit.nit_inv_type;
      l_rec_excl_check.nit_pnt_or_cont       := g_rec_nit.nit_pnt_or_cont;
      l_rec_excl_check.nit_x_sect_allow_flag := g_rec_nit.nit_x_sect_allow_flag;
      nm3invval.process_rec_excl_check (l_rec_excl_check);
   END IF;
--
   nm_debug.proc_end(g_package_name,'merge_members_by_in');
--
END merge_members_by_in;
--
-----------------------------------------------------------------------------
--
FUNCTION is_nw_operation_in_progress RETURN boolean IS
BEGIN
   RETURN g_nw_operation_in_progress;
END is_nw_operation_in_progress;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_nw_operation_in_progress (p_in_progress boolean DEFAULT TRUE) IS
BEGIN
   g_nw_operation_in_progress := p_in_progress;
END set_nw_operation_in_progress;
--
------------------------------------------------------------------------------------------------
--
FUNCTION route_has_valid_SE_nodes(pi_route_ne_id  IN nm_elements.ne_id%TYPE) RETURN BOOLEAN IS

  -- LOG 709697 CWS As groups do not have end nodes defined in 
  -- nm_elements the cursor now checks if it is a group.
  CURSOR c1 IS
  SELECT 'X'
  FROM   nm_elements 
  WHERE  ne_id = pi_route_ne_id
  AND    ((ne_no_end = nm3net.get_end_node(ne_id)
  AND    ne_no_start = nm3net.get_start_node(ne_id))
   OR    ne_type = 'G');
  
  v_dummy VARCHAR2(1) := Null;

BEGIN

 OPEN c1;
 FETCH c1 INTO v_dummy;
 CLOSE c1;
 
 IF v_dummy IS NOT NULL THEN
   RETURN(TRUE);
 ELSE
   RETURN(FALSE);
 END IF;

END route_has_valid_SE_nodes;
--
------------------------------------------------------------------------------------------------
--
FUNCTION can_elements_be_merged (pi_ne_id_1        IN nm_elements.ne_id%TYPE
                                ,pi_ne_id_2        IN nm_elements.ne_id%TYPE
                                ,pi_effective_date IN DATE DEFAULT NULL) RETURN BOOLEAN IS


 l_ne_rec_1 nm_elements%ROWTYPE := nm3net.get_ne(pi_ne_id_1);
 l_ne_rec_2 nm_elements%ROWTYPE := nm3net.get_ne(pi_ne_id_2);
 
 l_errors   NUMBER;
 l_err_text VARCHAR2(10000);
 l_suppl    nm_errors.ner_descr%TYPE;

 PROCEDURE set_output_params(p_ner_appl           IN nm_errors.ner_appl%TYPE
                            ,p_ner_id             IN nm_errors.ner_id%TYPE
                            ,p_supplimentary_info IN VARCHAR2) IS

 BEGIN
    g_ner_appl := p_ner_appl;
    g_ner_id := p_ner_id;
    g_supplimentary_info := p_supplimentary_info;
 END;
 


BEGIN

  nm_debug.proc_start(g_package_name,'can_elements_be_merged');
  
  check_other_products ( p_ne_id1         => pi_ne_id_1
                        ,p_ne_id2         => pi_ne_id_2
                        ,p_sectno         => null -- used for inv_loader, will need to be re-introduced
                        ,p_effective_date => pi_effective_date
                        ,p_errors         => l_errors
                        ,p_err_text       => l_err_text
                        );

  IF l_err_text IS NOT NULL  THEN
           set_output_params(p_ner_appl           => nm3type.c_net
                            ,p_ner_id             => 363  -- elements cannot be merged
                            ,p_supplimentary_info => l_err_text
                             );
      RETURN(FALSE);
  ELSIF NVL(pi_effective_date,TRUNC(SYSDATE)) > TRUNC(SYSDATE) THEN
    set_output_params(nm3type.c_net 
                      ,165  
                      ,null);  
     RETURN(FALSE); 

  ELSIF NOT nm3inv_security.can_usr_see_all_inv_on_element(pi_ne_id_1) THEN
     set_output_params(nm3type.c_net 
                      ,172  -- User does not have access to all inventory on element
                      ,nm3net.get_ne_unique(pi_ne_id_1));  
     RETURN(FALSE);

  ELSIF NOT nm3inv_security.can_usr_see_all_inv_on_element(pi_ne_id_2) THEN
    set_output_params(nm3type.c_net 
                     ,172  -- User does not have access to all inventory on element
                     ,nm3net.get_ne_unique(pi_ne_id_2));  
     RETURN(FALSE);


  ELSIF l_ne_rec_1.ne_id = l_ne_rec_2.ne_id THEN
           set_output_params(p_ner_appl           => nm3type.c_net
                            ,p_ner_id             => 132  -- elements are identical
                            ,p_supplimentary_info => Null);
      RETURN(FALSE);
  
  ELSIF l_ne_rec_1.ne_nt_type != l_ne_rec_2.ne_nt_type THEN  
           set_output_params(p_ner_appl           => nm3type.c_net
                            ,p_ner_id             => 363  -- elements cannot be merged
                            ,p_supplimentary_info => 'Network Type of both elements must match');
     RETURN(FALSE);

  ELSIF NVL(l_ne_rec_1.ne_gty_group_type,-1) != NVL(l_ne_rec_2.ne_gty_group_type,-1) THEN  
           set_output_params(p_ner_appl           => nm3type.c_net
                            ,p_ner_id             => 363  -- elements cannot be merged
                            ,p_supplimentary_info => 'Group Type of both elements must match');
     RETURN(FALSE);


  ELSIF l_ne_rec_1.ne_admin_unit != l_ne_rec_2.ne_admin_unit THEN  
           set_output_params(p_ner_appl           => nm3type.c_net
                            ,p_ner_id             => 363  -- elements cannot be merged
                            ,p_supplimentary_info => 'Admin Unit of both elements must match');
     RETURN(FALSE);
 
 
  ELSIF NVL(l_ne_rec_1.ne_sub_class,-1) != NVL(l_ne_rec_2.ne_sub_class,-1) AND nm3net.subclass_is_used(pi_ne_id_1) THEN
  
           set_output_params(p_ner_appl           => nm3type.c_net
                            ,p_ner_id             => 363  -- elements cannot be merged
                            ,p_supplimentary_info => 'Subclass of both elements must match');

     RETURN(FALSE);

  ELSIF nm3net.is_nt_inclusion(l_ne_rec_1.ne_nt_type) THEN
            set_output_params(nm3type.c_net 
                             ,363  -- cannot merge group
                             ,CHR(10)||'Auto-Inclusion detected between Network Type '||l_ne_rec_1.ne_nt_type||' and datum network.');
            RETURN(FALSE);

  ELSIF nm3net.element_is_a_datum(pi_ne_type  =>  l_ne_rec_1.ne_type) AND nm3net.element_is_a_datum(pi_ne_type  =>  l_ne_rec_2.ne_type) THEN	  


      IF elements_on_same_route(pi_ne_id_1,pi_ne_id_2) = 'N' THEN
  
            l_suppl := hig.get_ner(nm3type.c_net,189).ner_descr;
            set_output_params(nm3type.c_net 
                             ,363  -- cannot merge group
                             ,CHR(10)||l_suppl);-- elements are not in same group
            RETURN(FALSE);
      ELSE
 
            RETURN(TRUE);

      END IF;

  ELSIF nm3net.element_is_a_group(pi_ne_type  =>  l_ne_rec_1.ne_type) AND nm3net.element_is_a_group(pi_ne_type  =>  l_ne_rec_2.ne_type) THEN
  
     IF NOT route_has_valid_SE_nodes(pi_ne_id_1) OR NOT route_has_valid_SE_nodes(pi_ne_id_2)  THEN

            l_suppl := hig.get_ner(nm3type.c_net,366).ner_descr;
            set_output_params(nm3type.c_net 
                             ,363  -- cannot merge group
                             ,CHR(10)||l_suppl);-- elements are not in same group
            RETURN(FALSE);
     ELSE

            RETURN(TRUE);
     END IF;

  ELSE

     set_output_params(p_ner_appl           => nm3type.c_net
                      ,p_ner_id             => 363  -- elements cannot be merged
                      ,p_supplimentary_info => 'Select two Datum elements or two Group elements');	 
     RETURN(FALSE);

  END IF;
  
  nm_debug.proc_end(g_package_name,'can_elements_be_merged');
  
  
END can_elements_be_merged;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE check_elements_can_be_merged (pi_ne_id_1 IN nm_elements.ne_id%TYPE
                                       ,pi_ne_id_2 IN nm_elements.ne_id%TYPE
                                       ,pi_effective_date IN DATE DEFAULT NULL) IS


BEGIN

  nm_debug.proc_start(g_package_name,'check_elements_can_be_merged');
  IF NOT can_elements_be_merged(pi_ne_id_1        => pi_ne_id_1
                               ,pi_ne_id_2        => pi_ne_id_2
                               ,pi_effective_date => pi_effective_date) THEN
          hig.raise_ner (pi_appl               => g_ner_appl
                        ,pi_id                 => g_ner_id
                        ,pi_supplementary_info => g_supplimentary_info);
  END IF;

  nm_debug.proc_end(g_package_name,'check_elements_can_be_merged');
	
END check_elements_can_be_merged;
--
------------------------------------------------------------------------------------------------
--
--709697 CWS CHANGES MADE TO THIS FUNCTION
/*FUNCTION get_route_common_node(pi_route_ne_id_1          IN nm_elements.ne_id%TYPE
                              ,pi_route_ne_id_2          IN nm_elements.ne_id%TYPE
                               ) RETURN tab_rec_common_nodes IS


 CURSOR c1 IS
 SELECT ne1.ne_no_end
       ,'E'
       ,'S' 
 FROM   nm_elements ne1
       ,nm_elements ne2
 WHERE  ne1.ne_id = pi_route_ne_id_1
 AND    ne2.ne_id = pi_route_ne_id_2
 AND    ne1.ne_no_end = ne2.ne_no_start
 UNION
 SELECT ne1.ne_no_start
       ,'S'
       ,'E' 
 FROM   nm_elements ne1
       ,nm_elements ne2
 WHERE  ne1.ne_id = pi_route_ne_id_1
 AND    ne2.ne_id = pi_route_ne_id_2
 AND    ne1.ne_no_start = ne2.ne_no_end
 UNION
 SELECT ne1.ne_no_end
       ,'E'
       ,'E' 
 FROM   nm_elements ne1
       ,nm_elements ne2
 WHERE  ne1.ne_id = pi_route_ne_id_1
 AND    ne2.ne_id = pi_route_ne_id_2
 AND    ne1.ne_no_end = ne2.ne_no_end
 UNION
 SELECT ne1.ne_no_start
       ,'S'
       ,'S' 
 FROM   nm_elements ne1
       ,nm_elements ne2
 WHERE  ne1.ne_id = pi_route_ne_id_1
 AND    ne2.ne_id = pi_route_ne_id_2
 AND    ne1.ne_no_start = ne2.ne_no_start;  
 

 l_tab_rec_common_nodes tab_rec_common_nodes;

BEGIN

 OPEN c1;
 FETCH c1 BULK COLLECT INTO l_tab_rec_common_nodes;
 CLOSE c1;
 
 RETURN(l_tab_rec_common_nodes);

END get_route_common_node;*/

FUNCTION get_route_common_node(pi_route_ne_id_1          IN nm_elements.ne_id%TYPE
                              ,pi_route_ne_id_2          IN nm_elements.ne_id%TYPE) 
  RETURN tab_rec_common_nodes IS
 
  CURSOR c_node ( c_route_ne_id_1 IN nm_elements.ne_id%TYPE ) 
  IS
    SELECT nt_node_type  
      FROM nm_types, nm_elements
     WHERE ne_nt_type = nt_type
       AND ne_id =  c_route_ne_id_1;
 
  CURSOR c1 IS
    SELECT ne1.ne_no_end
          ,'E'
          ,'S'
      FROM nm_elements ne1
          ,nm_elements ne2
     WHERE ne1.ne_id = pi_route_ne_id_1
       AND ne2.ne_id = pi_route_ne_id_2
       AND ne1.ne_no_end = ne2.ne_no_start
     UNION
    SELECT ne1.ne_no_start
         ,'S'
         ,'E'
      FROM nm_elements ne1
          ,nm_elements ne2
     WHERE ne1.ne_id = pi_route_ne_id_1
       AND ne2.ne_id = pi_route_ne_id_2
       AND ne1.ne_no_start = ne2.ne_no_end
     UNION
    SELECT ne1.ne_no_end
          ,'E'
          ,'E'
      FROM nm_elements ne1
          ,nm_elements ne2
     WHERE ne1.ne_id = pi_route_ne_id_1
       AND ne2.ne_id = pi_route_ne_id_2
       AND ne1.ne_no_end = ne2.ne_no_end
     UNION
    SELECT ne1.ne_no_start
          ,'S'
          ,'S'
      FROM nm_elements ne1
          ,nm_elements ne2
     WHERE ne1.ne_id = pi_route_ne_id_1
       AND ne2.ne_id = pi_route_ne_id_2
       AND ne1.ne_no_start = ne2.ne_no_start;
 
  CURSOR c2 IS
    SELECT nnu1.nnu_no_node_id, nnu1.nnu_node_type, nnu2.nnu_node_type
  --  nnu1.nnu_ne_id, nnu2.nnu_node_type, nnu2.nnu_ne_id,
  --       nm3net.route_direction( nnu1.nnu_node_type, m1.nm_cardinality ), nm3net.route_direction( nnu2.nnu_node_type, m2.nm_cardinality )
      FROM nm_members m1, nm_node_usages nnu1,
           nm_members m2, nm_node_usages nnu2
     WHERE nnu1.nnu_ne_id = m1.nm_ne_id_of
       AND m1.nm_ne_id_in = pi_route_ne_id_1
       AND nnu2.nnu_ne_id = m2.nm_ne_id_of
       AND m2.nm_ne_id_in = pi_route_ne_id_2
       AND nnu1.nnu_no_node_id = nnu2.nnu_no_node_id;
 
  l_node_type nm_node_types.nnt_type%TYPE;
  l_tab_rec_common_nodes tab_rec_common_nodes;
--
BEGIN
--
  OPEN c_node(pi_route_ne_id_1);
  FETCH c_node INTO l_node_type;
  IF c_node%NOTFOUND THEN
    l_node_type := NULL;
  END IF;
  CLOSE c_node;
--
--assume node type is the same for both;
--
  IF l_node_type IS NOT NULL THEN
    OPEN c1;
    FETCH c1 BULK COLLECT INTO l_tab_rec_common_nodes;
    CLOSE c1;
  ELSE
    OPEN c2;
    FETCH c2 BULK COLLECT INTO l_tab_rec_common_nodes;
    CLOSE c2;
  END IF;
--
  RETURN(l_tab_rec_common_nodes);
--
END get_route_common_node;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE get_nodes_and_cardinality
           (pi_route_ne_rec_1        IN OUT  nm_elements%ROWTYPE
           ,pi_route_ne_rec_2        IN OUT  nm_elements%ROWTYPE
           ,po_ne_no_start           IN OUT  nm_nodes.no_node_id%TYPE
           ,po_ne_no_end             IN OUT  nm_nodes.no_node_id%TYPE
           ,po_common_node           IN OUT  nm_nodes.no_node_id%TYPE
           ,po_flip_cardinality_of_2 IN OUT  VARCHAR2
           ,po_new_starting_ne_id    IN OUT  NUMBER
           ) IS

 l_tab_rec_common_nodes  nm3merge.tab_rec_common_nodes;
 l_suppl                 nm_errors.ner_descr%TYPE;
     

BEGIN

 -----------------------------------
 -- Find common nodes on both routes
 -----------------------------------
 l_tab_rec_common_nodes :=  nm3merge.get_route_common_node(pi_route_ne_id_1  => pi_route_ne_rec_1.ne_id
                                                          ,pi_route_ne_id_2  => pi_route_ne_rec_2.ne_id
                                                          );

                                                          
 ---------------------------------------------------------
 -- If no common node is found then stop - we cannot merge
 ---------------------------------------------------------                                                           
 IF l_tab_rec_common_nodes.COUNT =0 THEN
            l_suppl := hig.get_ner(nm3type.c_net,168).ner_descr; 
            hig.raise_ner(pi_appl    => nm3type.c_net 
                         ,pi_id      => 363
                         ,pi_supplementary_info =>	chr(10)||l_suppl);

 END IF;
 

 --------------------------------------------------------------------
 -- If more than one common node is found then stop - we cannot merge
 --------------------------------------------------------------------                                                           
 IF l_tab_rec_common_nodes.COUNT >1 THEN
            l_suppl := hig.get_ner(nm3type.c_net,364).ner_descr; 
            hig.raise_ner(pi_appl    => nm3type.c_net 
                         ,pi_id      => 363
                         ,pi_supplementary_info =>	chr(10)||l_suppl); 

 END IF;
                                                          

 po_common_node := l_tab_rec_common_nodes(1).no_node_id;

 IF l_tab_rec_common_nodes(1).on_ne_id_1 = 'E' AND l_tab_rec_common_nodes(1).on_ne_id_2 = 'S' THEN

     --                ROUTE 1                   ROUTE 2 
     --        *---------------------*--------------------------*
     --        S                    E S                         E                    
     --
     po_ne_no_start            := pi_route_ne_rec_1.ne_no_start;   
     po_ne_no_end              := pi_route_ne_rec_2.ne_no_end;
     po_flip_cardinality_of_2  := 'N';          
     po_new_starting_ne_id     := pi_route_ne_rec_1.ne_id; 
 
 ELSIF l_tab_rec_common_nodes(1).on_ne_id_1 = 'S' AND l_tab_rec_common_nodes(1).on_ne_id_2 = 'E' THEN

     --                ROUTE 1                   ROUTE 2 
     --        *---------------------*--------------------------*
     --        E                    S E                         S                    
     -- 
     po_ne_no_start := pi_route_ne_rec_2.ne_no_start;   
     po_ne_no_end   := pi_route_ne_rec_1.ne_no_end;
     po_flip_cardinality_of_2  := 'N';          
     po_new_starting_ne_id     := pi_route_ne_rec_2.ne_id;     

 ELSIF l_tab_rec_common_nodes(1).on_ne_id_1 = 'E' AND l_tab_rec_common_nodes(1).on_ne_id_2 = 'E' THEN
 
 
     --                ROUTE 1                   ROUTE 2 
     --        *---------------------*--------------------------*
     --        S                    E E                         S                    
     -- 
     po_ne_no_start := pi_route_ne_rec_1.ne_no_start;   
     po_ne_no_end   := pi_route_ne_rec_2.ne_no_start;
     po_flip_cardinality_of_2  := 'Y';     
     po_new_starting_ne_id     := pi_route_ne_rec_1.ne_id;
 
 ELSIF l_tab_rec_common_nodes(1).on_ne_id_1 = 'S' AND l_tab_rec_common_nodes(1).on_ne_id_2 = 'S' THEN
 
     --                ROUTE 1                   ROUTE 2 
     --        *---------------------*--------------------------*
     --        E                    S S                         E                    
     po_ne_no_start := pi_route_ne_rec_2.ne_no_end;   
     po_ne_no_end   := pi_route_ne_rec_1.ne_no_end;
     po_flip_cardinality_of_2  := 'Y';
     po_new_starting_ne_id     := pi_route_ne_rec_2.ne_id;
	      
 END IF;

 
 IF po_flip_cardinality_of_2 ='Y' AND nm3net.get_gty(pi_route_ne_rec_2.ne_gty_group_type).ngt_reverse_allowed='N' THEN
 
           l_suppl := hig.get_ner(nm3type.c_net,365).ner_descr;
           hig.raise_ner (pi_appl    => nm3type.c_net
                         ,pi_id      => 363
                         ,pi_supplementary_info => chr(10)||l_suppl);

                         
                        
 END IF;                         
    

 
END get_nodes_and_cardinality;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE merge_group_elements (pi_route_ne_rec_1        IN     nm_elements%ROWTYPE
                               ,pi_route_ne_rec_2        IN     nm_elements%ROWTYPE
                               ,po_route_ne_id_new       IN OUT nm_elements.ne_id%TYPE
                               ,pi_length_1              in     nm_elements.ne_length%type
                               ,pi_length_2              in     nm_elements.ne_length%type
                               ,pi_effective_date        IN     DATE                               DEFAULT nm3user.get_effective_date
                               ,pi_ne_unique_new         IN     nm_elements.ne_unique%TYPE         DEFAULT NULL
                               ,pi_ne_owner_new          IN     nm_elements.ne_owner%TYPE          DEFAULT NULL
                               ,pi_ne_name_1_new         IN     nm_elements.ne_name_1%TYPE         DEFAULT NULL
                               ,pi_ne_name_2_new         IN     nm_elements.ne_name_2%TYPE         DEFAULT NULL
                               ,pi_ne_prefix_new         IN     nm_elements.ne_prefix%TYPE         DEFAULT NULL
                               ,pi_ne_number_new         IN     nm_elements.ne_number%TYPE         DEFAULT NULL
                               ,pi_ne_sub_type_new       IN     nm_elements.ne_sub_type%TYPE       DEFAULT NULL
                               ,pi_ne_group_new          IN     nm_elements.ne_group%TYPE          DEFAULT NULL
                               ,pi_ne_sub_class_new      IN     nm_elements.ne_sub_class%TYPE      DEFAULT NULL
                               ,pi_ne_nsg_ref_new        IN     nm_elements.ne_nsg_ref%TYPE        DEFAULT NULL
                               ,pi_ne_version_no_new     IN     nm_elements.ne_version_no%TYPE     DEFAULT NULL
                               ,pi_ne_no_start           IN     nm_elements.ne_no_start%TYPE       DEFAULT NULL
                               ,pi_ne_no_end             IN     nm_elements.ne_no_start%TYPE       DEFAULT NULL
                               ,pi_neh_descr             IN     nm_element_history.neh_descr%TYPE  DEFAULT NULL --CWS 0108990 12/03/2010
                               ) IS


   BEGIN

      g_rec_ne2 := g_empty_rec_ne;

      IF po_route_ne_id_new IS NULL
       THEN
         po_route_ne_id_new := nm3net.get_next_ne_id;
      END IF;

      g_rec_ne2.ne_id             := po_route_ne_id_new;
      g_rec_ne2.ne_unique         := pi_ne_unique_new;
      g_rec_ne2.ne_type           := pi_route_ne_rec_1.ne_type;
      g_rec_ne2.ne_nt_type        := pi_route_ne_rec_1.ne_nt_type;
      g_rec_ne2.ne_descr          := pi_route_ne_rec_1.ne_descr;
      g_rec_ne2.ne_length         := pi_route_ne_rec_1.ne_length+pi_route_ne_rec_2.ne_length;
      g_rec_ne2.ne_admin_unit     := pi_route_ne_rec_1.ne_admin_unit;
      g_rec_ne2.ne_gty_group_type := pi_route_ne_rec_1.ne_gty_group_type;
      g_rec_ne2.ne_owner          := NVL(pi_ne_owner_new,pi_route_ne_rec_1.ne_owner);
      g_rec_ne2.ne_name_1         := NVL(pi_ne_name_1_new,pi_route_ne_rec_1.ne_name_1);
      g_rec_ne2.ne_name_2         := NVL(pi_ne_name_2_new,pi_route_ne_rec_1.ne_name_2);
      g_rec_ne2.ne_prefix         := NVL(pi_ne_prefix_new,pi_route_ne_rec_1.ne_prefix);
      g_rec_ne2.ne_number         := NVL(pi_ne_number_new,pi_route_ne_rec_1.ne_number);
      g_rec_ne2.ne_sub_type       := NVL(pi_ne_sub_type_new,pi_route_ne_rec_1.ne_sub_type);
      g_rec_ne2.ne_group          := NVL(pi_ne_group_new,pi_route_ne_rec_1.ne_group);
      g_rec_ne2.ne_no_start       := pi_ne_no_start;
      g_rec_ne2.ne_no_end         := pi_ne_no_end;
      g_rec_ne2.ne_sub_class      := NVL(pi_ne_sub_class_new,pi_route_ne_rec_1.ne_sub_class);
      g_rec_ne2.ne_nsg_ref        := NVL(pi_ne_nsg_ref_new,pi_route_ne_rec_1.ne_nsg_ref);
      g_rec_ne2.ne_version_no     := NVL(pi_ne_version_no_new,pi_route_ne_rec_1.ne_version_no);
  

      nm3net.insert_element (p_ne_id             => g_rec_ne2.ne_id
                            ,p_ne_unique         => g_rec_ne2.ne_unique
                            ,p_ne_length         => g_new_element_length
                            ,p_ne_start_date     => pi_effective_date
                            ,p_ne_no_start       => g_rec_ne2.ne_no_start
                            ,p_ne_no_end         => g_rec_ne2.ne_no_end
                            ,p_ne_type           => g_rec_ne2.ne_type
                            ,p_ne_nt_type        => g_rec_ne2.ne_nt_type
                            ,p_ne_descr          => g_rec_ne2.ne_descr
                            ,p_ne_admin_unit     => g_rec_ne2.ne_admin_unit
                            ,p_ne_gty_group_type => g_rec_ne2.ne_gty_group_type
                            ,p_ne_owner          => g_rec_ne2.ne_owner
                            ,p_ne_name_1         => g_rec_ne2.ne_name_1
                            ,p_ne_name_2         => g_rec_ne2.ne_name_2
                            ,p_ne_prefix         => g_rec_ne2.ne_prefix
                            ,p_ne_number         => g_rec_ne2.ne_number
                            ,p_ne_sub_type       => g_rec_ne2.ne_sub_type
                            ,p_ne_group          => g_rec_ne2.ne_group
                            ,p_ne_sub_class      => g_rec_ne2.ne_sub_class
                            ,p_ne_nsg_ref        => g_rec_ne2.ne_nsg_ref
                            ,p_ne_version_no     => g_rec_ne2.ne_version_no
                            ,p_auto_include      => 'N'
                            );

   audit_element_history(pi_ne_id_new      => po_route_ne_id_new
                        ,pi_ne_id_1        => pi_route_ne_rec_1.ne_id
                        ,pi_length_1       => pi_length_1
                        ,pi_ne_id_2        => pi_route_ne_rec_2.ne_id
                        ,pi_length_2       => pi_length_2
                        ,pi_effective_date => pi_effective_date
                        ,pi_neh_descr      => pi_neh_descr --CWS 0108990 12/03/2010
                        );

END merge_group_elements;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE merge_group_memberships(pi_route_ne_id_1           IN  nm_elements.ne_id%TYPE 
                                 ,pi_route_ne_id_2           IN  nm_elements.ne_id%TYPE 
                                 ,pi_route_new_ne_id         IN  nm_elements.ne_id%TYPE
                                 ,pi_flip_cardinality_of_2   IN  VARCHAR2                                   								 
                                 ,pi_effective_date          IN     DATE) IS
                                 
     CURSOR c_in_memb IS
     SELECT 1
           ,nm_ne_id_in
           ,nm_ne_id_of
           ,nm_type
           ,nm_obj_type
           ,nm_begin_mp
           ,nm_start_date
           ,nm_end_date
           ,nm_end_mp
           ,nm_slk
           ,nm_cardinality
           ,nm_admin_unit
     FROM   nm_members 
     WHERE  nm_ne_id_in =  pi_route_ne_id_1
     UNION
     SELECT 2
           ,nm_ne_id_in
           ,nm_ne_id_of
           ,nm_type
           ,nm_obj_type
           ,nm_begin_mp
           ,nm_start_date
           ,nm_end_date
           ,nm_end_mp
           ,nm_slk
           ,DECODE(pi_flip_cardinality_of_2,'Y',nm_cardinality*-1,nm_cardinality) nm_cardinality
           ,nm_admin_unit
     FROM   nm_members 
     WHERE  nm_ne_id_in =  pi_route_ne_id_2;
     
  
     -- need to make sure this is ordered by pi_ne_id_1 members first  
     CURSOR c_of_memb IS
     SELECT 1
           ,nm_ne_id_in
           ,nm_ne_id_of
           ,nm_type
           ,nm_obj_type
           ,nm_begin_mp
           ,nm_start_date
           ,nm_end_date
           ,nm_end_mp
           ,nm_slk
           ,nm_cardinality
           ,nm_admin_unit
     FROM   nm_members nm 
     WHERE  nm_ne_id_of = pi_route_ne_id_1
     UNION
     SELECT 2
           ,nm_ne_id_in
           ,nm_ne_id_of
           ,nm_type
           ,nm_obj_type
           ,nm_begin_mp
           ,nm_start_date
           ,nm_end_date
           ,nm_end_mp
           ,nm_slk
           ,nm_cardinality
           ,nm_admin_unit
     FROM   nm_members nm 
     WHERE  nm_ne_id_of = pi_route_ne_id_2
     ORDER BY 1 ASC;
     

    TYPE memb_rec IS RECORD (nm_route_1_or_2       VARCHAR2(1) 
                            ,nm_ne_id_in           nm_members.nm_ne_id_in%TYPE
                            ,nm_ne_id_of           nm_members.nm_ne_id_of%TYPE
                            ,nm_type               nm_members.nm_type%TYPE
                            ,nm_obj_type           nm_members.nm_obj_type%TYPE  
                            ,nm_begin_mp           nm_members.nm_begin_mp%TYPE 
                            ,nm_start_date         nm_members.nm_start_date%TYPE
                            ,nm_end_date           nm_members.nm_end_date%TYPE
                            ,nm_end_mp             nm_members.nm_end_mp%TYPE              
                            ,nm_slk                nm_members.nm_slk%TYPE
                            ,nm_cardinality        nm_members.nm_cardinality%TYPE
                            ,nm_admin_unit         nm_members.nm_admin_unit%TYPE);
                            
   TYPE tab_memb_rec IS TABLE OF memb_rec INDEX BY BINARY_INTEGER;
   
   l_tab_in_memb_rec tab_memb_rec;                                                    
   l_tab_of_memb_rec tab_memb_rec;


     PROCEDURE end_date_existing_IN_members IS
     
     BEGIN
       UPDATE nm_members
       SET    nm_end_date = pi_effective_date
       WHERE  nm_ne_id_in IN (pi_route_ne_id_1,pi_route_ne_id_2);
     END end_date_existing_IN_members;

     PROCEDURE end_date_existing_OF_members IS

     BEGIN
       UPDATE nm_members
       SET    nm_end_date = pi_effective_date
       WHERE  nm_ne_id_of IN (pi_route_ne_id_1,pi_route_ne_id_2);
     END end_date_existing_OF_members; 
  
   BEGIN

    ----------------------------------------------
    -- get memberships where old routes are parent
    ----------------------------------------------
    OPEN c_in_memb;
    FETCH c_in_memb BULK COLLECT INTO l_tab_in_memb_rec;
    CLOSE c_in_memb;

    ------------------------------------------------
    -- get memberships where old routes are children
    -----------------------------------------------    
    OPEN c_of_memb;
    FETCH c_of_memb BULK COLLECT INTO l_tab_of_memb_rec;
    CLOSE c_of_memb;
    
    end_date_existing_IN_members;
    end_date_existing_OF_members;
    

    FOR i IN 1..l_tab_in_memb_rec.COUNT LOOP

        INSERT INTO nm_members(nm_ne_id_in
                              ,nm_ne_id_of
                              ,nm_type
                              ,nm_obj_type
                              ,nm_begin_mp
                              ,nm_start_date
                              ,nm_end_date
                              ,nm_end_mp
                              ,nm_cardinality
                              ,nm_admin_unit)
         VALUES(pi_route_new_ne_id
               ,l_tab_in_memb_rec(i).nm_ne_id_of
               ,l_tab_in_memb_rec(i).nm_type
               ,l_tab_in_memb_rec(i).nm_obj_type
               ,l_tab_in_memb_rec(i).nm_begin_mp
               ,pi_effective_date
               ,l_tab_in_memb_rec(i).nm_end_date
               ,l_tab_in_memb_rec(i).nm_end_mp
               ,l_tab_in_memb_rec(i).nm_cardinality
               ,l_tab_in_memb_rec(i).nm_admin_unit);
 
 
    END LOOP; 


 
 
     FOR i IN 1..l_tab_of_memb_rec.COUNT LOOP

          INSERT INTO nm_members(nm_ne_id_in
                                ,nm_ne_id_of
                                ,nm_type
                                ,nm_obj_type
                                ,nm_begin_mp
                                ,nm_start_date
                                ,nm_end_date
                                ,nm_end_mp
                                ,nm_cardinality
                                ,nm_admin_unit)
         select l_tab_of_memb_rec(i).nm_ne_id_in
               ,pi_route_new_ne_id
               ,l_tab_of_memb_rec(i).nm_type
               ,l_tab_of_memb_rec(i).nm_obj_type
               ,l_tab_of_memb_rec(i).nm_begin_mp
               ,pi_effective_date
               ,l_tab_of_memb_rec(i).nm_end_date
               ,l_tab_of_memb_rec(i).nm_end_mp
               ,l_tab_of_memb_rec(i).nm_cardinality
               ,l_tab_of_memb_rec(i).nm_admin_unit
         from   dual
         where  (
                 nm3net.get_group_exclusive_flag(l_tab_of_memb_rec(i).nm_ne_id_in) = 'Y' 
                 AND NOT EXISTS (select 'x'
                                 from   nm_members
                                 where  nm_obj_type = l_tab_of_memb_rec(i).nm_obj_type
                                 and    nm_ne_id_of = pi_route_new_ne_id)
                )
         or
                (
                 nm3net.get_group_exclusive_flag(l_tab_of_memb_rec(i).nm_ne_id_in) = 'N' 
                 AND NOT EXISTS (select 'x'
                                 from   nm_members
                                 where  nm_ne_id_in = l_tab_of_memb_rec(i).nm_ne_id_in
                                 and    nm_ne_id_of = pi_route_new_ne_id)
                );
 
      END LOOP; 


END merge_group_memberships;   
--
------------------------------------------------------------------------------------------------
--   
PROCEDURE do_merge_group (pi_route_ne_id_1     IN     nm_elements.ne_id%TYPE
                         ,pi_route_ne_id_2     IN     nm_elements.ne_id%TYPE
                         ,po_route_ne_id_new   IN OUT nm_elements.ne_id%TYPE
                         ,pi_effective_date    IN     DATE                               DEFAULT nm3user.get_effective_date
                         ,pi_ne_unique         IN     nm_elements.ne_unique%TYPE         DEFAULT NULL
                         ,pi_ne_owner          IN     nm_elements.ne_owner%TYPE          DEFAULT NULL
                         ,pi_ne_name_1         IN     nm_elements.ne_name_1%TYPE         DEFAULT NULL
                         ,pi_ne_name_2         IN     nm_elements.ne_name_2%TYPE         DEFAULT NULL
                         ,pi_ne_prefix         IN     nm_elements.ne_prefix%TYPE         DEFAULT NULL
                         ,pi_ne_number         IN     nm_elements.ne_number%TYPE         DEFAULT NULL
                         ,pi_ne_sub_type       IN     nm_elements.ne_sub_type%TYPE       DEFAULT NULL
                         ,pi_ne_group          IN     nm_elements.ne_group%TYPE          DEFAULT NULL
                         ,pi_ne_sub_class      IN     nm_elements.ne_sub_class%TYPE       DEFAULT NULL
                         ,pi_ne_nsg_ref        IN     nm_elements.ne_nsg_ref%TYPE        DEFAULT NULL
                         ,pi_ne_version_no     IN     nm_elements.ne_version_no%TYPE     DEFAULT NULL
                         ,pi_neh_descr         IN     nm_element_history.neh_descr%TYPE  DEFAULT NULL --CWS 0108990 12/03/2010
                   ) IS

   v_errors                NUMBER;
   v_err_text              VARCHAR2(10000);
   
   l_ne_rec_1 nm_elements%ROWTYPE := nm3net.get_ne(pi_ne_id => pi_route_ne_id_1);
   l_ne_rec_2 nm_elements%ROWTYPE := nm3net.get_ne(pi_ne_id => pi_route_ne_id_2);

   l_ne_no_start            nm_nodes.no_node_id%TYPE;
   l_ne_no_end              nm_nodes.no_node_id%TYPE; 
   l_common_node            nm_nodes.no_node_id%TYPE;
   l_flip_cardinality_of_2  VARCHAR2(1);
   l_new_starting_ne_id         nm_elements.ne_id%TYPE;
   l_length_1               number;
   l_length_2               number;
   
BEGIN


   nm_debug.proc_start(g_package_name , 'do_merge_group');
   
   -- PT: old element lengths cached for use with stp schemes
   l_length_1 := nm3net.get_ne_length(pi_route_ne_id_1);
   l_length_2 := nm3net.get_ne_length(pi_route_ne_id_2);

 
   get_nodes_and_cardinality
                            (pi_route_ne_rec_1        => l_ne_rec_1
                            ,pi_route_ne_rec_2        => l_ne_rec_2
                            ,po_ne_no_start           => l_ne_no_start
                            ,po_ne_no_end             => l_ne_no_end
                            ,po_common_node           => l_common_node
                            ,po_flip_cardinality_of_2 => l_flip_cardinality_of_2
                            ,po_new_starting_ne_id    => l_new_starting_ne_id);


   merge_group_elements (pi_route_ne_rec_1        => l_ne_rec_1
                        ,pi_route_ne_rec_2        => l_ne_rec_2
                        ,po_route_ne_id_new       => po_route_ne_id_new
                        ,pi_length_1              => l_length_1
                        ,pi_length_2              => l_length_2
                        ,pi_effective_date        => pi_effective_date
                        ,pi_ne_unique_new         => pi_ne_unique
                        ,pi_ne_owner_new          => pi_ne_owner
                        ,pi_ne_name_1_new         => pi_ne_name_1
                        ,pi_ne_name_2_new         => pi_ne_name_2
                        ,pi_ne_prefix_new         => pi_ne_prefix
                        ,pi_ne_number_new         => pi_ne_number
                        ,pi_ne_sub_type_new       => pi_ne_sub_type
                        ,pi_ne_group_new          => pi_ne_group
                        ,pi_ne_sub_class_new      => pi_ne_sub_class
                        ,pi_ne_nsg_ref_new        => pi_ne_nsg_ref
                        ,pi_ne_version_no_new     => pi_ne_version_no
                        ,pi_ne_no_start           => l_ne_no_start
                        ,pi_ne_no_end             => l_ne_no_end
                        ,pi_neh_descr             => pi_neh_descr --CWS 0108990 12/03/2010
                        );
                                                
  -----------------------------------------------------------------------------------
  -- deal with accidents, defects and structures etc etc
  -- need to do this before killing memberships of route 1 and 2
  -- i.e. if you kill off memberships then no lengths for the sections can be derived
  -- and these are vital in re-positioning defects etc etc
  -----------------------------------------------------------------------------------
   merge_other_products (p_ne_id_1                 => pi_route_ne_id_1
                        ,p_ne_id_2                 => pi_route_ne_id_2
                        ,p_ne_id_new               => po_route_ne_id_new
                        ,p_new_starting_ne_id      => l_new_starting_ne_id
                        ,p_flip_cardinality_of_2   => l_flip_cardinality_of_2
                        ,p_effective_date          => pi_effective_date
                        ,p_node_id                 => l_common_node
                        );

  merge_group_memberships(pi_route_ne_id_1           => pi_route_ne_id_1 
                         ,pi_route_ne_id_2           => pi_route_ne_id_2
                         ,pi_route_new_ne_id         => po_route_ne_id_new
                         ,pi_flip_cardinality_of_2   => l_flip_cardinality_of_2                          								 
                         ,pi_effective_date          => pi_effective_date);

  --------------------------------------------------------
  -- end date shape of element 1
  --------------------------------------------------------
  nm3sdm.reshape_route(pi_ne_id          => pi_route_ne_id_1
                      ,pi_effective_date => pi_effective_date
                      ,pi_use_history    => 'Y');



  --------------------------------------------------------
  -- end date shape of element 2
  --------------------------------------------------------
   nm3sdm.reshape_route(pi_ne_id          => pi_route_ne_id_2
                       ,pi_effective_date => pi_effective_date
                       ,pi_use_history    => 'Y');


   IF nm3nwad.ad_data_exist(pi_route_ne_id_1) THEN

      nm3nwad.do_ad_merge( pi_new_ne_id      => po_route_ne_id_new
                         , pi_old_ne_id1     => pi_route_ne_id_1
                         , pi_old_ne_id2     => pi_route_ne_id_2
                         , pi_effective_date => pi_effective_date);
                         
   END IF;                         

   -- end date the original elements
   UPDATE nm_elements
    SET   ne_end_date = pi_effective_date
   WHERE  ne_id IN ( pi_route_ne_id_1, pi_route_ne_id_2);


   
   
 -- recale it the network type of group is linear
 -- otherwise
  nm3rsc.rescale_route(pi_ne_id          => po_route_ne_id_new
                      ,pi_effective_date => pi_effective_date
                      ,pi_offset_st      => 0
                      ,pi_st_element_id  => NULL
                      ,pi_use_history    => 'N'
                      ,pi_ne_start       => NULL);
                      
  -- PT 11.01.07: schemes synch needs to be called after members are inserted
  merge_other_product_stp(p_ne_id_1                 => pi_route_ne_id_1
                         ,p_ne_id_2                 => pi_route_ne_id_2
                         ,p_ne_id_new               => po_route_ne_id_new
                         ,p_ne_length_1             => l_length_1
                         ,p_ne_length_2             => l_length_2
                         ,p_flip_cardinality_of_2   => l_flip_cardinality_of_2
                         ,p_effective_date          => pi_effective_date
                         );
                         

   nm_debug.proc_end(g_package_name , 'do_merge_group');
   

END do_merge_group;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE do_merge_datum_or_group (pi_ne_id_1           IN     nm_elements.ne_id%TYPE
                                  ,pi_ne_id_2           IN     nm_elements.ne_id%TYPE
                                  ,pi_effective_date    IN     date                               DEFAULT nm3user.get_effective_date
                                  ,pi_merge_at_node     IN     nm_elements.ne_no_start%TYPE
                                  ,pi_ne_unique         IN     nm_elements.ne_unique%TYPE         DEFAULT NULL
                                  ,pi_ne_type           IN     nm_elements.ne_type%TYPE           DEFAULT NULL
                                  ,pi_ne_nt_type        IN     nm_elements.ne_nt_type%TYPE        DEFAULT NULL
                                  ,pi_ne_descr          IN     nm_elements.ne_descr%TYPE          DEFAULT NULL
                                  ,pi_ne_length         IN     nm_elements.ne_length%TYPE         DEFAULT NULL
                                  ,pi_ne_admin_unit     IN     nm_elements.ne_admin_unit%TYPE     DEFAULT NULL
                                  ,pi_ne_gty_group_type IN     nm_elements.ne_gty_group_type%TYPE DEFAULT NULL
                                  ,pi_ne_owner          IN     nm_elements.ne_owner%TYPE          DEFAULT NULL
                                  ,pi_ne_name_1         IN     nm_elements.ne_name_1%TYPE         DEFAULT NULL
                                  ,pi_ne_name_2         IN     nm_elements.ne_name_2%TYPE         DEFAULT NULL
                                  ,pi_ne_prefix         IN     nm_elements.ne_prefix%TYPE         DEFAULT NULL
                                  ,pi_ne_number         IN     nm_elements.ne_number%TYPE         DEFAULT NULL
                                  ,pi_ne_sub_type       IN     nm_elements.ne_sub_type%TYPE       DEFAULT NULL
                                  ,pi_ne_group          IN     nm_elements.ne_group%TYPE          DEFAULT NULL
                                  ,pi_ne_no_start       IN     nm_elements.ne_no_start%TYPE       DEFAULT NULL
                                  ,pi_ne_no_end         IN     nm_elements.ne_no_end%TYPE         DEFAULT NULL
                                  ,pi_ne_sub_class      IN     nm_elements.ne_sub_class%TYPE       DEFAULT NULL
                                  ,pi_ne_nsg_ref        IN     nm_elements.ne_nsg_ref%TYPE        DEFAULT NULL
                                  ,pi_ne_version_no     IN     nm_elements.ne_version_no%TYPE     DEFAULT NULL
                                  ,pi_test_poe_at_node  IN     varchar2                           DEFAULT 'N'
                                  ,po_ne_id_new         IN OUT nm_elements.ne_id%TYPE
                                  ,pi_neh_descr         IN     nm_element_history.neh_descr%TYPE  DEFAULT NULL) --CWS 0108990 12/03/2010
                                  IS
	
  l_ne_rec_1 nm_elements%ROWTYPE := nm3net.get_ne(pi_ne_id_1);

BEGIN

--
   nm_debug.proc_start(g_package_name , 'do_merge_datum_or_group');
   
--
   check_elements_can_be_merged (pi_ne_id_1 => pi_ne_id_1
                                ,pi_ne_id_2 => pi_ne_id_2
                                ,pi_effective_date => pi_effective_date);
   
--
   nm3lock.lock_element_and_members (pi_ne_id_1);
   nm3lock.lock_element_and_members (pi_ne_id_2);
--
   set_for_merge;
--
  IF nm3net.element_is_a_datum(pi_ne_type  =>  l_ne_rec_1.ne_type) THEN
  
  
     do_merge (p_ne_id_1           => pi_ne_id_1
              ,p_ne_id_2           => pi_ne_id_2
              ,p_ne_id_new         => po_ne_id_new
              ,p_effective_date    => pi_effective_date
              ,p_merge_at_node     => pi_merge_at_node
              ,p_ne_unique         => pi_ne_unique
              ,p_ne_type           => pi_ne_type
              ,p_ne_nt_type        => pi_ne_nt_type
              ,p_ne_descr          => pi_ne_descr
              ,p_ne_length         => pi_ne_length
              ,p_ne_admin_unit     => pi_ne_admin_unit
              ,p_ne_gty_group_type => pi_ne_gty_group_type
              ,p_ne_owner          => pi_ne_owner
              ,p_ne_name_1         => pi_ne_name_1
              ,p_ne_name_2         => pi_ne_name_2
              ,p_ne_prefix         => pi_ne_prefix
              ,p_ne_number         => pi_ne_number
              ,p_ne_sub_type       => pi_ne_sub_type
              ,p_ne_group          => pi_ne_group
              ,p_ne_no_start       => pi_ne_no_start
              ,p_ne_no_end         => pi_ne_no_end
              ,p_ne_sub_class      => pi_ne_sub_class
              ,p_ne_nsg_ref        => pi_ne_nsg_ref
              ,p_ne_version_no     => pi_ne_version_no
              ,p_test_poe_at_node  => pi_test_poe_at_node
              ,p_neh_descr         => pi_neh_descr --CWS 0108990 12/03/2010
              );

  ELSE

          do_merge_group (pi_route_ne_id_1     => pi_ne_id_1
                         ,pi_route_ne_id_2     => pi_ne_id_2
                         ,po_route_ne_id_new   => po_ne_id_new
                         ,pi_effective_date    => pi_effective_date
                         ,pi_ne_unique         => pi_ne_unique
                         ,pi_ne_owner          => pi_ne_owner
                         ,pi_ne_name_1         => pi_ne_name_1
                         ,pi_ne_name_2         => pi_ne_name_2
                         ,pi_ne_prefix         => pi_ne_prefix
                         ,pi_ne_number         => pi_ne_number
                         ,pi_ne_sub_type       => pi_ne_sub_type
                         ,pi_ne_group          => pi_ne_group
                         ,pi_ne_sub_class      => pi_ne_sub_class
                         ,pi_ne_nsg_ref        => pi_ne_nsg_ref
                         ,pi_ne_version_no     => pi_ne_version_no
                         ,pi_neh_descr         => pi_neh_descr --CWS 0108990 12/03/2010
                         );
  
  END IF; 

 --
   set_for_return;
 --
  
EXCEPTION
   WHEN nm3type.g_exception
    THEN
      set_for_return;
      RAISE_APPLICATION_ERROR(nm3type.g_exception_code,nm3type.g_exception_msg);

END do_merge_datum_or_group;
--
-----------------------------------------------------------------------------
--
END nm3merge;
/
