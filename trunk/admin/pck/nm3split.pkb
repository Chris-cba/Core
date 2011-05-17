CREATE OR REPLACE PACKAGE BODY Nm3split IS
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3split.pkb-arc   2.13   May 17 2011 15:12:48   Chris.Strettle  $
--       Module Name      : $Workfile:   nm3split.pkb  $
--       Date into PVCS   : $Date:   May 17 2011 15:12:48  $
--       Date fetched Out : $Modtime:   May 17 2011 15:08:16  $
--       PVCS Version     : $Revision:   2.13  $
--
--
--   Author : ITurnbull
--
--     nm3split package body.
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2000
-----------------------------------------------------------------------------

-- 03.06.08 PT added p_no_purpose parameter throughout where node is created.

--
   g_body_sccsid     CONSTANT  VARCHAR2(2000) := '"$Revision:   2.13  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  VARCHAR2(2000) := 'nm3split';
--
   g_element_unit              NM_UNITS.un_unit_id%TYPE;
--
   g_ausec_status VARCHAR2(3);
   g_prev_rec_ne_old   nm_elements%ROWTYPE;
   g_prev_rec_ne_new_1 nm_elements%ROWTYPE;
   g_prev_rec_ne_new_2 nm_elements%ROWTYPE;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE set_for_split IS

BEGIN
   -- grab current values of globals
   g_prev_rec_ne_old   := g_rec_ne_old;
   g_prev_rec_ne_new_1 := g_rec_ne_new_1;
   g_prev_rec_ne_new_2 := g_rec_ne_new_2;

   g_ausec_status := Nm3ausec.get_status;
   Nm3ausec.set_status(Nm3type.c_off);
   Nm3merge.set_nw_operation_in_progress;
END set_for_split;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE set_for_return IS
   BEGIN

   -- set globals back to what they were at start of split
      g_rec_ne_old   := g_prev_rec_ne_old;
      g_rec_ne_new_1 := g_prev_rec_ne_new_1;
      g_rec_ne_new_2 := g_prev_rec_ne_new_2;

      Nm3ausec.set_status(g_ausec_status);
      Nm3merge.clear_nmh_variables;
      Nm3merge.set_nw_operation_in_progress(FALSE);
END set_for_return;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE split_members (p_ne_id          nm_elements.ne_id%TYPE -- original element
                        ,p_ne_id_1        nm_elements.ne_id%TYPE -- 1st new element
                        ,p_ne_id_2        nm_elements.ne_id%TYPE -- 2nd new element
                        ,p_split_measure  NUMBER                 -- the length along the original element
                        ,p_effective_date DATE
                        );
--
------------------------------------------------------------------------------------------------
--
PROCEDURE split_members_by_in (p_ne_id          nm_elements.ne_id%TYPE -- original element
                              ,p_ne_id_1        nm_elements.ne_id%TYPE -- 1st new element
                              ,p_ne_id_2        nm_elements.ne_id%TYPE -- 2nd new element
                              ,p_split_measure  NUMBER                 -- the length along the original element
                              ,p_effective_date DATE
                              ,p_ne_id_in       nm_elements.ne_id%TYPE
                              );
--
------------------------------------------------------------------------------------------------
--
PROCEDURE split_individual_member (p_ne_id          nm_elements.ne_id%TYPE -- original element
                                  ,p_ne_id_1        nm_elements.ne_id%TYPE -- 1st new element
                                  ,p_ne_id_2        nm_elements.ne_id%TYPE -- 2nd new element
                                  ,p_split_measure  NUMBER                 -- the length along the original element
                                  ,p_effective_date DATE
                                  ,p_rec_nm         nm_members%ROWTYPE
                                  ,p_is_group       BOOLEAN
                                  ,p_is_gty_partial BOOLEAN
                                  ,p_to_unit        NM_UNITS.un_unit_id%TYPE
                                  );
--
------------------------------------------------------------------------------------------------
--
PROCEDURE split_element (p_ne_id               IN     nm_elements.ne_id%TYPE       -- the element to split
                        ,p_type_of_split       IN     nm_elements.ne_type%TYPE     -- type of element being split S=Datum G=Group
                        ,p_effective_date      IN     DATE                         -- the date the split is effective from
                        ,p_ne_id_1             IN OUT nm_elements.ne_id%TYPE       -- 1st new ne_id
                        ,p_ne_length_1         IN     NUMBER DEFAULT NULL          -- length of first element - only applicable for datums
                        ,p_ne_id_2             IN OUT nm_elements.ne_id%TYPE       -- 2nd new ne_id
                        ,p_ne_length_2         IN     NUMBER                       -- length of first element - only applicable for datums
                        ,p_node                IN     nm_elements.ne_no_start%TYPE -- the node at the split point
                        ,p_force_inheritance_of_attribs  IN     VARCHAR2                           DEFAULT 'N' -- force inheritance of all attributes on datums
                        ,p_ne_unique_1         IN     nm_elements.ne_unique%TYPE         DEFAULT NULL
                        ,p_ne_type_1           IN     nm_elements.ne_type%TYPE           DEFAULT NULL
                        ,p_ne_nt_type_1        IN     nm_elements.ne_nt_type%TYPE        DEFAULT NULL
                        ,p_ne_descr_1          IN     nm_elements.ne_descr%TYPE          DEFAULT NULL
                        ,p_ne_admin_unit_1     IN     nm_elements.ne_admin_unit%TYPE     DEFAULT NULL
                        ,p_ne_gty_group_type_1 IN     nm_elements.ne_gty_group_type%TYPE DEFAULT NULL
                        ,p_ne_owner_1          IN     nm_elements.ne_owner%TYPE          DEFAULT NULL
                        ,p_ne_name_1_1         IN     nm_elements.ne_name_1%TYPE         DEFAULT NULL
                        ,p_ne_name_2_1         IN     nm_elements.ne_name_2%TYPE         DEFAULT NULL
                        ,p_ne_prefix_1         IN     nm_elements.ne_prefix%TYPE         DEFAULT NULL
                        ,p_ne_number_1         IN     nm_elements.ne_number%TYPE         DEFAULT NULL
                        ,p_ne_sub_type_1       IN     nm_elements.ne_sub_type%TYPE       DEFAULT NULL
                        ,p_ne_group_1          IN     nm_elements.ne_group%TYPE          DEFAULT NULL
                        ,p_ne_no_start_1       IN     nm_elements.ne_no_start%TYPE       DEFAULT NULL
                        ,p_ne_no_end_1         IN     nm_elements.ne_no_end%TYPE         DEFAULT NULL
                        ,p_ne_sub_class_1      IN     nm_elements.ne_sub_class%TYPE      DEFAULT NULL
                        ,p_ne_nsg_ref_1        IN     nm_elements.ne_nsg_ref%TYPE        DEFAULT NULL
                        ,p_ne_version_no_1     IN     nm_elements.ne_version_no%TYPE     DEFAULT NULL
                        ,p_ne_unique_2         IN     nm_elements.ne_unique%TYPE         DEFAULT NULL
                        ,p_ne_type_2           IN     nm_elements.ne_type%TYPE           DEFAULT NULL
                        ,p_ne_nt_type_2        IN     nm_elements.ne_nt_type%TYPE        DEFAULT NULL
                        ,p_ne_descr_2          IN     nm_elements.ne_descr%TYPE          DEFAULT NULL
                        ,p_ne_admin_unit_2     IN     nm_elements.ne_admin_unit%TYPE     DEFAULT NULL
                        ,p_ne_gty_group_type_2 IN     nm_elements.ne_gty_group_type%TYPE DEFAULT NULL
                        ,p_ne_owner_2          IN     nm_elements.ne_owner%TYPE          DEFAULT NULL
                        ,p_ne_name_1_2         IN     nm_elements.ne_name_1%TYPE         DEFAULT NULL
                        ,p_ne_name_2_2         IN     nm_elements.ne_name_2%TYPE         DEFAULT NULL
                        ,p_ne_prefix_2         IN     nm_elements.ne_prefix%TYPE         DEFAULT NULL
                        ,p_ne_number_2         IN     nm_elements.ne_number%TYPE         DEFAULT NULL
                        ,p_ne_sub_type_2       IN     nm_elements.ne_sub_type%TYPE       DEFAULT NULL
                        ,p_ne_group_2          IN     nm_elements.ne_group%TYPE          DEFAULT NULL
                        ,p_ne_no_start_2       IN     nm_elements.ne_no_start%TYPE       DEFAULT NULL
                        ,p_ne_no_end_2         IN     nm_elements.ne_no_end%TYPE         DEFAULT NULL
                        ,p_ne_sub_class_2      IN     nm_elements.ne_sub_class%TYPE      DEFAULT NULL
                        ,p_ne_nsg_ref_2        IN     nm_elements.ne_nsg_ref%TYPE        DEFAULT NULL
                        ,p_ne_version_no_2     IN     nm_elements.ne_version_no%TYPE     DEFAULT NULL
                        ,p_neh_descr           IN     nm_element_history.neh_descr%TYPE   DEFAULT NULL --CWS 0108990 12/03/2010
                        );
--
------------------------------------------------------------------------------------------------
--
PROCEDURE end_date_elements (p_ne_id          IN nm_elements.ne_id%TYPE
                            ,p_effective_date IN nm_elements.ne_end_date%TYPE
                            );
--
------------------------------------------------------------------------------------------------
--
FUNCTION create_node_internal (p_no_node_id     IN nm_nodes.no_node_id%TYPE
                              ,p_no_node_name   IN nm_nodes.no_node_name%TYPE
                              ,p_no_descr       IN nm_nodes.no_descr%TYPE
                              ,p_no_node_type   IN nm_nodes.no_node_type%TYPE
                              ,p_no_np_id       IN nm_nodes.no_np_id%TYPE
                              ,p_effective_date IN nm_nodes.no_start_date%TYPE
                              ,p_np_grid_east   IN NM_POINTS.np_grid_east%TYPE  DEFAULT NULL
                              ,p_np_grid_north  IN NM_POINTS.np_grid_north%TYPE DEFAULT NULL
                              ,p_no_purpose     in nm_nodes_all.no_purpose%type default null
                              ) RETURN nm_elements.ne_no_start%TYPE;
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE end_date_elements (p_ne_id          IN nm_elements.ne_id%TYPE
                            ,p_effective_date IN nm_elements.ne_end_date%TYPE
                            ) IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'end_date_elements');
--
   -- end date the original element
   UPDATE nm_elements
    SET   ne_end_date = p_effective_date
   WHERE  ne_id = p_ne_id;
--
   Nm_Debug.proc_end(g_package_name,'end_date_elements');
--
END end_date_elements;
--
------------------------------------------------------------------------------------------------
--
FUNCTION create_node (p_no_node_name   IN nm_nodes.no_node_name%TYPE   DEFAULT NULL
                     ,p_no_descr       IN nm_nodes.no_descr%TYPE
                     ,p_no_node_type   IN nm_nodes.no_node_type%TYPE
                     ,p_effective_date IN nm_nodes.no_start_date%TYPE  DEFAULT Nm3user.get_effective_date
                     ,p_np_grid_east   IN NM_POINTS.np_grid_east%TYPE  DEFAULT NULL
                     ,p_np_grid_north  IN NM_POINTS.np_grid_north%TYPE DEFAULT NULL
                     ,p_no_purpose     in nm_nodes_all.no_purpose%type default null
                     ) RETURN nm_nodes.no_node_id%TYPE IS
--
   l_node_id  nm_nodes.no_node_id%TYPE;
   l_no_np_id nm_nodes.no_np_id%TYPE;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'create_node');
--
   IF   p_no_node_name IS NOT NULL
    AND Nm3net.get_node_name_format (p_no_node_type) IS NOT NULL
    THEN
      -- Node name cannot be specified when there is a node name format on the node type
      Hig.raise_ner (Nm3type.c_net,279);
   END IF;
--
   l_node_id := create_node_internal (p_no_node_id     => l_node_id
                                     ,p_no_node_name   => p_no_node_name
                                     ,p_no_descr       => p_no_descr
                                     ,p_no_node_type   => p_no_node_type
                                     ,p_no_np_id       => l_no_np_id
                                     ,p_effective_date => p_effective_date
                                     ,p_np_grid_east   => p_np_grid_east
                                     ,p_np_grid_north  => p_np_grid_north
                                     ,p_no_purpose     => p_no_purpose
                                     );
--
   RETURN l_node_id;
--
   Nm_Debug.proc_end(g_package_name,'create_node');
--
END create_node;
--
------------------------------------------------------------------------------------------------
--
FUNCTION create_node_internal (p_no_node_id     IN nm_nodes.no_node_id%TYPE
                              ,p_no_node_name   IN nm_nodes.no_node_name%TYPE
                              ,p_no_descr       IN nm_nodes.no_descr%TYPE
                              ,p_no_node_type   IN nm_nodes.no_node_type%TYPE
                              ,p_no_np_id       IN nm_nodes.no_np_id%TYPE
                              ,p_effective_date IN nm_nodes.no_start_date%TYPE
                              ,p_np_grid_east   IN NM_POINTS.np_grid_east%TYPE  DEFAULT NULL
                              ,p_np_grid_north  IN NM_POINTS.np_grid_north%TYPE DEFAULT NULL
                              ,p_no_purpose     in nm_nodes_all.no_purpose%type default null
                              ) RETURN nm_elements.ne_no_start%TYPE IS
--
   v_node_id  nm_nodes.no_node_id%TYPE := p_no_node_id;
   v_no_np_id nm_nodes.no_np_id%TYPE   := p_no_np_id;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'create_node_internal');
--
   IF v_node_id IS NULL
    THEN
      v_node_id := Nm3net.get_next_node_id;
   END IF;
--
   IF v_no_np_id IS NULL
    THEN
      v_no_np_id := Nm3net.create_point(p_np_grid_east, p_np_grid_north);
   END IF;
--
   Nm3net.create_node(pi_no_node_id   => v_node_id
                     ,pi_np_id        => v_no_np_id
                     ,pi_start_date   => TRUNC(p_effective_date)
                     ,pi_no_descr     => p_no_descr
                     ,pi_no_node_type => p_no_node_type
                     ,pi_no_node_name => p_no_node_name
                     ,pi_no_purpose   => p_no_purpose
                     );
--
   Nm_Debug.proc_end(g_package_name,'create_node_internal');
--
  RETURN v_node_id;
--
END create_node_internal;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE split_element (p_ne_id               IN     nm_elements.ne_id%TYPE       -- the element to split
                        ,p_type_of_split       IN     nm_elements.ne_type%TYPE     -- type of element being split S=Datum G=Group
                        ,p_effective_date      IN     DATE                         -- the date the split is effective from
                        ,p_ne_id_1             IN OUT nm_elements.ne_id%TYPE       -- 1st new ne_id
                        ,p_ne_length_1         IN     NUMBER DEFAULT NULL          -- length of first element - only applicable for datums
                        ,p_ne_id_2             IN OUT nm_elements.ne_id%TYPE       -- 2nd new ne_id
                        ,p_ne_length_2         IN     NUMBER                       -- length of first element - only applicable for datums
                        ,p_node                IN     nm_elements.ne_no_start%TYPE -- the node at the split point
                        ,p_force_inheritance_of_attribs  IN     VARCHAR2                           DEFAULT 'N' -- force inheritance of all attributes on datums
                        ,p_ne_unique_1         IN     nm_elements.ne_unique%TYPE         DEFAULT NULL
                        ,p_ne_type_1           IN     nm_elements.ne_type%TYPE           DEFAULT NULL
                        ,p_ne_nt_type_1        IN     nm_elements.ne_nt_type%TYPE        DEFAULT NULL
                        ,p_ne_descr_1          IN     nm_elements.ne_descr%TYPE          DEFAULT NULL
                        ,p_ne_admin_unit_1     IN     nm_elements.ne_admin_unit%TYPE     DEFAULT NULL
                        ,p_ne_gty_group_type_1 IN     nm_elements.ne_gty_group_type%TYPE DEFAULT NULL
                        ,p_ne_owner_1          IN     nm_elements.ne_owner%TYPE          DEFAULT NULL
                        ,p_ne_name_1_1         IN     nm_elements.ne_name_1%TYPE         DEFAULT NULL
                        ,p_ne_name_2_1         IN     nm_elements.ne_name_2%TYPE         DEFAULT NULL
                        ,p_ne_prefix_1         IN     nm_elements.ne_prefix%TYPE         DEFAULT NULL
                        ,p_ne_number_1         IN     nm_elements.ne_number%TYPE         DEFAULT NULL
                        ,p_ne_sub_type_1       IN     nm_elements.ne_sub_type%TYPE       DEFAULT NULL
                        ,p_ne_group_1          IN     nm_elements.ne_group%TYPE          DEFAULT NULL
                        ,p_ne_no_start_1       IN     nm_elements.ne_no_start%TYPE       DEFAULT NULL
                        ,p_ne_no_end_1         IN     nm_elements.ne_no_end%TYPE         DEFAULT NULL
                        ,p_ne_sub_class_1      IN     nm_elements.ne_sub_class%TYPE      DEFAULT NULL
                        ,p_ne_nsg_ref_1        IN     nm_elements.ne_nsg_ref%TYPE        DEFAULT NULL
                        ,p_ne_version_no_1     IN     nm_elements.ne_version_no%TYPE     DEFAULT NULL
                        ,p_ne_unique_2         IN     nm_elements.ne_unique%TYPE         DEFAULT NULL
                        ,p_ne_type_2           IN     nm_elements.ne_type%TYPE           DEFAULT NULL
                        ,p_ne_nt_type_2        IN     nm_elements.ne_nt_type%TYPE        DEFAULT NULL
                        ,p_ne_descr_2          IN     nm_elements.ne_descr%TYPE          DEFAULT NULL
                        ,p_ne_admin_unit_2     IN     nm_elements.ne_admin_unit%TYPE     DEFAULT NULL
                        ,p_ne_gty_group_type_2 IN     nm_elements.ne_gty_group_type%TYPE DEFAULT NULL
                        ,p_ne_owner_2          IN     nm_elements.ne_owner%TYPE          DEFAULT NULL
                        ,p_ne_name_1_2         IN     nm_elements.ne_name_1%TYPE         DEFAULT NULL
                        ,p_ne_name_2_2         IN     nm_elements.ne_name_2%TYPE         DEFAULT NULL
                        ,p_ne_prefix_2         IN     nm_elements.ne_prefix%TYPE         DEFAULT NULL
                        ,p_ne_number_2         IN     nm_elements.ne_number%TYPE         DEFAULT NULL
                        ,p_ne_sub_type_2       IN     nm_elements.ne_sub_type%TYPE       DEFAULT NULL
                        ,p_ne_group_2          IN     nm_elements.ne_group%TYPE          DEFAULT NULL
                        ,p_ne_no_start_2       IN     nm_elements.ne_no_start%TYPE       DEFAULT NULL
                        ,p_ne_no_end_2         IN     nm_elements.ne_no_end%TYPE         DEFAULT NULL
                        ,p_ne_sub_class_2      IN     nm_elements.ne_sub_class%TYPE      DEFAULT NULL
                        ,p_ne_nsg_ref_2        IN     nm_elements.ne_nsg_ref%TYPE        DEFAULT NULL
                        ,p_ne_version_no_2     IN     nm_elements.ne_version_no%TYPE     DEFAULT NULL
                        ,p_neh_descr           IN     nm_element_history.neh_descr%TYPE   DEFAULT NULL --CWS 0108990 12/03/2010
                        ) IS
   --
--
  c_orig_ne_length CONSTANT number := p_ne_length_1 + p_ne_length_2;

   PROCEDURE do_inheritance IS
      -- flexible attributes (columns) to inherit
      CURSOR cs_inherit (c_nt_type NM_TYPE_COLUMNS.ntc_nt_type%TYPE) IS
      SELECT ntc_column_name
       FROM  NM_TYPE_COLUMNS a
      WHERE  ntc_nt_type = c_nt_type
       AND   (p_force_inheritance_of_attribs = 'Y'
             OR
              (p_force_inheritance_of_attribs = 'N' AND ntc_inherit = 'Y')
              );

      l_been_in_loop BOOLEAN := FALSE;
      l_tab_vc       Nm3type.tab_varchar32767;
   BEGIN
      l_tab_vc.DELETE;
      Nm3ddl.append_tab_varchar(l_tab_vc,'BEGIN',FALSE);
      FOR cs_rec IN cs_inherit (g_rec_ne_old.ne_nt_type)
       LOOP
         l_been_in_loop := TRUE;
         FOR i IN 1..2
          LOOP
            Nm3ddl.append_tab_varchar(l_tab_vc,'   '||g_package_name||'.g_rec_ne_new_'||i||'.'||cs_rec.ntc_column_name||' := '||g_package_name||'.g_rec_ne_old.'||cs_rec.ntc_column_name||';');
         END LOOP;
      END LOOP;
      Nm3ddl.append_tab_varchar(l_tab_vc,'END;');
      IF l_been_in_loop
       THEN
         Nm3ddl.execute_tab_varchar(l_tab_vc);
      END IF;
   END do_inheritance;

   PROCEDURE create_element (p_rec_ne IN OUT nm_elements%ROWTYPE) IS
      v_leg_no  nm_node_usages.nnu_leg_no%TYPE;
   BEGIN
/*
     nm_debug.debug('ABOUT TO INSERT AN ELEMENT');
     nm_debug.debug('p_ne_id='||p_rec_ne.ne_id);
     nm_debug.debug('p_ne_unique='||p_rec_ne.ne_unique);
     nm_debug.debug('p_ne_length='||p_rec_ne.ne_length);
     nm_debug.debug('p_ne_start_date='||p_rec_ne.ne_start_date);
     nm_debug.debug('p_ne_no_start='||p_rec_ne.ne_no_start);
     nm_debug.debug('p_ne_no_end='||p_rec_ne.ne_no_end);
     nm_debug.debug('p_ne_nt_type='||p_rec_ne.ne_nt_type);
     nm_debug.debug('p_ne_descr='||p_rec_ne.ne_descr);
     nm_debug.debug('p_ne_admin_unit='||p_rec_ne.ne_admin_unit);
     nm_debug.debug('p_ne_gty_group_type='||p_rec_ne.ne_gty_group_type);
     nm_debug.debug('p_ne_owner='||p_rec_ne.ne_owner);
     nm_debug.debug('p_ne_name_1='||p_rec_ne.ne_name_1);
     nm_debug.debug('p_ne_name_2='||p_rec_ne.ne_name_2);
     nm_debug.debug('p_ne_prefix='||p_rec_ne.ne_prefix);
     nm_debug.debug('p_ne_number='||p_rec_ne.ne_number);
     nm_debug.debug('p_ne_sub_type='||p_rec_ne.ne_sub_type);
     nm_debug.debug('p_ne_group='||p_rec_ne.ne_group);
     nm_debug.debug('p_ne_sub_class='||p_rec_ne.ne_sub_class);
     nm_debug.debug('p_ne_nsg_ref='||p_rec_ne.ne_nsg_ref);
     nm_debug.debug('p_ne_version_no='||p_rec_ne.ne_version_no);
  */

      Nm3net.insert_element (p_ne_id             => p_rec_ne.ne_id
                            ,p_ne_unique         => p_rec_ne.ne_unique
                            ,p_ne_length         => p_rec_ne.ne_length
                            ,p_ne_start_date     => p_rec_ne.ne_start_date
                            ,p_ne_no_start       => p_rec_ne.ne_no_start
                            ,p_ne_no_end         => p_rec_ne.ne_no_end
                            ,p_ne_type           => p_rec_ne.ne_type
                            ,p_ne_nt_type        => p_rec_ne.ne_nt_type
                            ,p_ne_descr          => p_rec_ne.ne_descr
                            ,p_ne_admin_unit     => p_rec_ne.ne_admin_unit
                            ,p_ne_gty_group_type => p_rec_ne.ne_gty_group_type
                            ,p_ne_owner          => p_rec_ne.ne_owner
                            ,p_ne_name_1         => p_rec_ne.ne_name_1
                            ,p_ne_name_2         => p_rec_ne.ne_name_2
                            ,p_ne_prefix         => p_rec_ne.ne_prefix
                            ,p_ne_number         => p_rec_ne.ne_number
                            ,p_ne_sub_type       => p_rec_ne.ne_sub_type
                            ,p_ne_group          => p_rec_ne.ne_group
                            ,p_ne_sub_class      => p_rec_ne.ne_sub_class
                            ,p_ne_nsg_ref        => p_rec_ne.ne_nsg_ref
                            ,p_ne_version_no     => p_rec_ne.ne_version_no
                            ,p_auto_include      => 'N'
                            );

       IF p_type_of_split = 'S' THEN

         -- update the leg details
         -- start node of the new element takes the leg at the start node of the un-split element
         v_leg_no := Nm3net.get_leg_number( p_ne_id, g_rec_ne_old.ne_no_start);
         UPDATE nm_node_usages
          SET   nnu_leg_no     = v_leg_no
         WHERE  nnu_ne_id      = p_rec_ne.ne_id
          AND   nnu_no_node_id = p_rec_ne.ne_no_start;
         -- end node of new element takes the leg at the end node of the un-split element
         v_leg_no := Nm3net.get_leg_number( p_ne_id, g_rec_ne_old.ne_no_end);
         UPDATE nm_node_usages
          SET   nnu_leg_no     = v_leg_no
         WHERE  nnu_ne_id      = p_rec_ne.ne_id
          AND   nnu_no_node_id = p_node;

       END IF;

   END create_element;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'split_element');
--
   -- get the new ne_id of the 1st new element
   IF p_ne_id_1 IS NULL
    THEN
      p_ne_id_1 := Nm3net.get_next_ne_id;
   END IF;
--
   -- get the new ne_id of 2nd new element
   IF p_ne_id_2 IS NULL
    THEN
      p_ne_id_2 := Nm3net.get_next_ne_id;
   END IF;

--
   g_rec_ne_new_1.ne_id                  := p_ne_id_1;
   g_rec_ne_new_1.ne_unique              := p_ne_unique_1;
   g_rec_ne_new_1.ne_type                := NVL(p_ne_type_1,g_rec_ne_old.ne_type);
   g_rec_ne_new_1.ne_nt_type             := NVL(p_ne_nt_type_1,g_rec_ne_old.ne_nt_type);
   g_rec_ne_new_1.ne_descr               := NVL(p_ne_descr_1,g_rec_ne_old.ne_descr);
   g_rec_ne_new_1.ne_length              := p_ne_length_1;
   g_rec_ne_new_1.ne_admin_unit          := NVL(p_ne_admin_unit_1,g_rec_ne_old.ne_admin_unit);
   g_rec_ne_new_1.ne_start_date          := p_effective_date;
   g_rec_ne_new_1.ne_end_date            := g_rec_ne_old.ne_end_date;
   g_rec_ne_new_1.ne_gty_group_type      := NVL(p_ne_gty_group_type_1,g_rec_ne_old.ne_gty_group_type);
   g_rec_ne_new_1.ne_owner               := p_ne_owner_1;
   g_rec_ne_new_1.ne_name_1              := p_ne_name_1_1;
   g_rec_ne_new_1.ne_name_2              := p_ne_name_2_1;
   g_rec_ne_new_1.ne_prefix              := p_ne_prefix_1;
   g_rec_ne_new_1.ne_number              := p_ne_number_1;
   g_rec_ne_new_1.ne_sub_type            := p_ne_sub_type_1;
   g_rec_ne_new_1.ne_group               := p_ne_group_1;

   -- if the network type of the new element supports a node type
   -- then set start/end nodes
   IF Nm3net.get_nt(g_rec_ne_new_1.ne_nt_type).nt_node_type IS NOT NULL THEN
--   nm_debug.debug('p_node='||p_node);
      g_rec_ne_new_1.ne_no_start            := NVL(p_ne_no_start_1,g_rec_ne_old.ne_no_start);
      g_rec_ne_new_1.ne_no_end              := p_node;
   END IF;
   g_rec_ne_new_1.ne_sub_class           := p_ne_sub_class_1;
   g_rec_ne_new_1.ne_nsg_ref             := p_ne_nsg_ref_1;
   g_rec_ne_new_1.ne_version_no          := p_ne_version_no_1;
--
   g_rec_ne_new_2.ne_id                  := p_ne_id_2;
   g_rec_ne_new_2.ne_unique              := p_ne_unique_2;
   g_rec_ne_new_2.ne_type                := NVL(p_ne_type_2,g_rec_ne_old.ne_type);
   g_rec_ne_new_2.ne_nt_type             := NVL(p_ne_nt_type_2,g_rec_ne_old.ne_nt_type);
   g_rec_ne_new_2.ne_descr               := NVL(p_ne_descr_2,g_rec_ne_old.ne_descr);


   g_rec_ne_new_2.ne_length              := p_ne_length_2;
   g_rec_ne_new_2.ne_admin_unit          := NVL(p_ne_admin_unit_2,g_rec_ne_old.ne_admin_unit);
   g_rec_ne_new_2.ne_start_date          := p_effective_date;
   g_rec_ne_new_2.ne_end_date            := g_rec_ne_old.ne_end_date;
   g_rec_ne_new_2.ne_gty_group_type      := NVL(p_ne_gty_group_type_2,g_rec_ne_old.ne_gty_group_type);
   g_rec_ne_new_2.ne_owner               := p_ne_owner_2;
   g_rec_ne_new_2.ne_name_1              := p_ne_name_1_2;
   g_rec_ne_new_2.ne_name_2              := p_ne_name_2_2;
   g_rec_ne_new_2.ne_prefix              := p_ne_prefix_2;
   g_rec_ne_new_2.ne_number              := p_ne_number_2;
   g_rec_ne_new_2.ne_sub_type            := p_ne_sub_type_2;
   g_rec_ne_new_2.ne_group               := p_ne_group_2;

   -- if the network type of the new element supports a node type
   -- then set start/end nodes
   IF Nm3net.get_nt(g_rec_ne_new_2.ne_nt_type).nt_node_type IS NOT NULL THEN
     g_rec_ne_new_2.ne_no_start            := p_node;
     g_rec_ne_new_2.ne_no_end              := NVL(p_ne_no_end_2,g_rec_ne_old.ne_no_end);
   END IF;

   g_rec_ne_new_2.ne_sub_class           := p_ne_sub_class_2;
   g_rec_ne_new_2.ne_nsg_ref             := p_ne_nsg_ref_2;
   g_rec_ne_new_2.ne_version_no          := p_ne_version_no_2;
--
   do_inheritance;
   --
   create_element (g_rec_ne_new_1);

   create_element (g_rec_ne_new_2);
--
   g_element_unit := Nm3net.get_nt_units(g_rec_ne_new_1.ne_nt_type);
--
   -- update the element history
   DECLARE
      l_rec_neh NM_ELEMENT_HISTORY%ROWTYPE;
   BEGIN
      l_rec_neh.neh_id             := nm3seq.next_neh_id_seq;
      l_rec_neh.neh_ne_id_old      := p_ne_id;
      l_rec_neh.neh_ne_id_new      := p_ne_id_1;
      l_rec_neh.neh_operation      := 'S';
      l_rec_neh.neh_effective_date := p_effective_date;
      l_rec_neh.neh_old_ne_length  := c_orig_ne_length;
      l_rec_neh.neh_new_ne_length  := p_ne_length_1;
      l_rec_neh.neh_param_1        := 1;
      l_rec_neh.neh_param_2        := NULL;
      l_rec_neh.neh_descr          := p_neh_descr; --CWS 0108990 12/03/2010

      --insert history for first new element
      --Nm3merge.ins_neh (l_rec_neh);
      nm3nw_edit.ins_neh(l_rec_neh); --CWS 0108990 12/03/2010

      l_rec_neh.neh_id             := nm3seq.next_neh_id_seq;
      l_rec_neh.neh_ne_id_new      := p_ne_id_2;
      l_rec_neh.neh_new_ne_length  := p_ne_length_2;
      l_rec_neh.neh_param_1        := 2;

      --insert history for second new element
      --Nm3merge.ins_neh (l_rec_neh);
      nm3nw_edit.ins_neh(l_rec_neh); --CWS 0108990 12/03/2010
   END;
--
   Nm_Debug.proc_end(g_package_name,'split_element');
--
END split_element;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE split_members (p_ne_id          nm_elements.ne_id%TYPE -- original element
                        ,p_ne_id_1        nm_elements.ne_id%TYPE -- 1st new element
                        ,p_ne_id_2        nm_elements.ne_id%TYPE -- 2nd new element
                        ,p_split_measure  NUMBER                 -- the length along the original element
                        ,p_effective_date DATE
                        ) IS
--
   CURSOR cs_in (c_ne_id nm_elements.ne_id%TYPE) IS
   SELECT nm_ne_id_in
    FROM  nm_members
   WHERE  nm_ne_id_of = c_ne_id
   GROUP BY nm_ne_id_in;
--
   l_tab_in Nm3type.tab_number;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'split_members');
--
   OPEN  cs_in (p_ne_id);
   FETCH cs_in BULK COLLECT INTO l_tab_in;
   CLOSE cs_in;
--
   FOR i IN 1..l_tab_in.COUNT
    LOOP
      split_members_by_in (p_ne_id          => p_ne_id
                          ,p_ne_id_1        => p_ne_id_1
                          ,p_ne_id_2        => p_ne_id_2
                          ,p_split_measure  => p_split_measure
                          ,p_effective_date => p_effective_date
                          ,p_ne_id_in       => l_tab_in(i)
                          );
   END LOOP;
--
   Nm_Debug.proc_end(g_package_name,'split_members');
--
END split_members;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE split_members_by_in (p_ne_id          nm_elements.ne_id%TYPE -- original element
                              ,p_ne_id_1        nm_elements.ne_id%TYPE -- 1st new element
                              ,p_ne_id_2        nm_elements.ne_id%TYPE -- 2nd new element
                              ,p_split_measure  NUMBER                 -- the length along the original element
                              ,p_effective_date DATE
                              ,p_ne_id_in       nm_elements.ne_id%TYPE
                              ) IS
--
   CURSOR cs_members (c_in nm_members.nm_ne_id_in%TYPE
                     ,c_of nm_members.nm_ne_id_of%TYPE
                     ) IS
   SELECT *
    FROM  nm_members
   WHERE  nm_ne_id_in = c_in
    AND   nm_ne_id_of = c_of
   ORDER BY nm_seq_no;
--
   l_rec_nm         nm_members%ROWTYPE;
   l_tab_rec_nm     Nm3type.tab_rec_nm;
   l_nm_count       PLS_INTEGER := 0;
--
   l_to_unit        NM_UNITS.un_unit_id%TYPE;
--
   l_is_group       BOOLEAN     := FALSE;
   l_gty_is_partial BOOLEAN     := FALSE;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'split_members_by_in');
--
--   nm_debug.debug('Split by in '||p_ne_id_in);
--
-- Get all of the members records for this NM_NE_ID_IN and NM_NE_ID_OF on the old element
--
   FOR cs_rec IN cs_members (p_ne_id_in,p_ne_id)
    LOOP
      --
      l_nm_count := l_nm_count + 1;
      l_rec_nm   := cs_rec;
      --
      IF l_nm_count = 1
       THEN
         --
         l_is_group := (l_rec_nm.nm_type = 'G');
         --
         IF l_is_group
          THEN
            l_gty_is_partial := Nm3net.gty_is_partial (l_rec_nm.nm_obj_type);
            l_to_unit        := Nm3net.get_gty_units  (l_rec_nm.nm_obj_type);
         ELSE
            l_to_unit        := g_element_unit;
         END IF;
         --
      END IF;
      --
      l_tab_rec_nm(l_nm_count) := l_rec_nm;
--      nm_debug.debug(l_rec_nm.nm_type||':'||l_rec_nm.nm_obj_type||':'||l_rec_nm.nm_begin_mp||'->'||l_rec_nm.nm_end_mp);
      --
   END LOOP;
--
-- Loop through all the old members working out where they need to be on the new element
--
   FOR i IN 1..l_nm_count
    LOOP
      split_individual_member (p_ne_id          => p_ne_id
                              ,p_ne_id_1        => p_ne_id_1
                              ,p_ne_id_2        => p_ne_id_2
                              ,p_split_measure  => p_split_measure
                              ,p_effective_date => p_effective_date
                              ,p_rec_nm         => l_tab_rec_nm(i)
                              ,p_is_group       => l_is_group
                              ,p_is_gty_partial => l_gty_is_partial
                              ,p_to_unit        => l_to_unit
                              );
   END LOOP;
--
   -- End date the member records for this NM_NE_ID_IN (and OF)
   UPDATE nm_members
    SET   nm_end_date = p_effective_date
   WHERE  nm_ne_id_in = p_ne_id_in
    AND   nm_ne_id_of = p_ne_id;
--
   Nm_Debug.proc_end(g_package_name,'split_members_by_in');
--
END split_members_by_in;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE split_individual_member (p_ne_id          nm_elements.ne_id%TYPE -- original element
                                  ,p_ne_id_1        nm_elements.ne_id%TYPE -- 1st new element
                                  ,p_ne_id_2        nm_elements.ne_id%TYPE -- 2nd new element
                                  ,p_split_measure  NUMBER                 -- the length along the original element
                                  ,p_effective_date DATE
                                  ,p_rec_nm         nm_members%ROWTYPE
                                  ,p_is_group       BOOLEAN
                                  ,p_is_gty_partial BOOLEAN
                                  ,p_to_unit        NM_UNITS.un_unit_id%TYPE
                                  ) IS
--
   TYPE tab_rec_nmh IS TABLE OF NM_MEMBER_HISTORY%ROWTYPE INDEX BY BINARY_INTEGER;
--
   l_rec_nm_new     nm_members%ROWTYPE;
   l_tab_rec_nm_new Nm3type.tab_rec_nm;
   l_new_count      PLS_INTEGER := 0;
--
   l_rec_nmh        NM_MEMBER_HISTORY%ROWTYPE;
   l_tab_rec_nmh    tab_rec_nmh;
--
   l_value          NUMBER;
   l_value_in_units NUMBER;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'split_individual_member');
--
   --
   -- Copy the values into the NM_MEMBER_HISTORY record
   --
   l_rec_nmh.nmh_nm_ne_id_in        := p_rec_nm.nm_ne_id_in;
   l_rec_nmh.nmh_nm_ne_id_of_old    := p_rec_nm.nm_ne_id_of;
   l_rec_nmh.nmh_nm_begin_mp        := p_rec_nm.nm_begin_mp;
   l_rec_nmh.nmh_nm_start_date      := p_rec_nm.nm_start_date;
   l_rec_nmh.nmh_nm_type            := p_rec_nm.nm_type;
   l_rec_nmh.nmh_nm_obj_type        := p_rec_nm.nm_obj_type;
   l_rec_nmh.nmh_nm_end_date        := p_rec_nm.nm_end_date;
   --
   IF p_rec_nm.nm_begin_mp < p_split_measure
    THEN
      -- It starts before the split on the old one..
      l_new_count                   := l_new_count + 1;
      l_rec_nm_new                  := p_rec_nm;
      l_rec_nm_new.nm_ne_id_of      := p_ne_id_1;
      l_rec_nm_new.nm_start_date    := p_effective_date;
      l_rec_nm_new.nm_end_mp        := LEAST(l_rec_nm_new.nm_end_mp,p_split_measure);
      l_tab_rec_nm_new(l_new_count) := l_rec_nm_new;
      l_rec_nmh.nmh_nm_ne_id_of_new := l_rec_nm_new.nm_ne_id_of;
      l_tab_rec_nmh(l_new_count)    := l_rec_nmh;
   END IF;
   --
   IF  p_rec_nm.nm_end_mp   > p_split_measure
    OR p_rec_nm.nm_begin_mp = p_split_measure
    THEN
      -- It ends after the split
      --  or starts right on the split (this will pick up point items only)
      l_new_count                   := l_new_count + 1;
      l_rec_nm_new                  := p_rec_nm;
      l_rec_nm_new.nm_ne_id_of      := p_ne_id_2;
      l_rec_nm_new.nm_start_date    := p_effective_date;
      l_rec_nm_new.nm_begin_mp      := GREATEST(l_rec_nm_new.nm_begin_mp,p_split_measure) - p_split_measure;
      l_rec_nm_new.nm_end_mp        := l_rec_nm_new.nm_end_mp                             - p_split_measure;
      l_tab_rec_nm_new(l_new_count) := l_rec_nm_new;
      l_rec_nmh.nmh_nm_ne_id_of_new := l_rec_nm_new.nm_ne_id_of;
      l_tab_rec_nmh(l_new_count)    := l_rec_nmh;
   END IF;
   --
   -- If this NM_NE_ID_IN is on both new elements
   --  Sort out the SLK
   --
   IF    l_new_count NOT IN (1,2)
    THEN
      Hig.raise_ner (pi_appl               => Nm3type.c_net
                    ,pi_id                 => 28
                    ,pi_supplementary_info => 'Member record found '||l_new_count||' times in split'
                    );
   ELSIF l_new_count = 1
    THEN
      -- Do nothing - Leave SLK as it is
      --  if it is only on one of the new elements
      NULL;
   ELSIF l_new_count = 2
    THEN
      IF   p_to_unit       IS NOT NULL
       AND p_rec_nm.nm_slk IS NOT NULL
       THEN
         --
         -- Only do this if the thing we are going to is linear (or inv)
         --  and there was an existing SLK (which non-linear inv will not have)
         --
         IF p_rec_nm.nm_cardinality = -1
          THEN
            l_value                     := l_tab_rec_nm_new(2).nm_end_mp - l_tab_rec_nm_new(2).nm_begin_mp;
            l_value_in_units            := Nm3unit.convert_unit (g_element_unit,p_to_unit,l_value);
            l_tab_rec_nm_new(1).nm_slk  := l_tab_rec_nm_new(1).nm_slk  + (l_value_in_units);
            l_tab_rec_nm_new(1).nm_true := l_tab_rec_nm_new(1).nm_true + (l_value_in_units);
         ELSE
            l_value                     := l_tab_rec_nm_new(1).nm_end_mp - l_tab_rec_nm_new(1).nm_begin_mp;
            l_value_in_units            := Nm3unit.convert_unit (g_element_unit,p_to_unit,l_value);
            l_tab_rec_nm_new(2).nm_slk  := l_tab_rec_nm_new(2).nm_slk  + (l_value_in_units);
            l_tab_rec_nm_new(2).nm_true := l_tab_rec_nm_new(2).nm_true + (l_value_in_units);
         END IF;
         --
      END IF;
   END IF;
   --
   FOR j IN 1..l_new_count
    LOOP
      --
      l_rec_nm_new := l_tab_rec_nm_new(j);
      --
      Nm3merge.append_nmh_to_variables(l_tab_rec_nmh(j));
      --
--         nm_debug.debug(l_rec_nm_new.nm_type||':'||l_rec_nm_new.nm_obj_type||':'||l_rec_nm_new.nm_begin_mp||'->'||l_rec_nm_new.nm_end_mp);
      Nm3net.ins_nm (l_rec_nm_new);
      --
   END LOOP;
--
   Nm_Debug.proc_end(g_package_name,'split_individual_member');
--
END split_individual_member;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE split_other_products (p_ne_id          nm_elements.ne_id%TYPE
                               ,p_ne_id_1        nm_elements.ne_id%TYPE
                               ,p_ne_id_2        nm_elements.ne_id%TYPE
                               ,p_split_measure  nm_elements.ne_length%TYPE
                               ,p_effective_date nm_elements.ne_start_date%TYPE
                               ) IS
   l_block VARCHAR2(32767);
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'split_other_products');
--
  -- Check if accidents is installed and do split accidents
    IF Hig.is_product_licensed(Nm3type.c_acc)
     THEN
       l_block :=            'BEGIN'
                  ||CHR(10)||'    accsplit.do_split'
                  ||CHR(10)||'              (pi_ne_id_old      => :p_ne_id'
                  ||CHR(10)||'              ,pi_split_measure  => :p_split_measure'
                  ||CHR(10)||'              ,pi_effective_date => :p_effective_date'
                  ||CHR(10)||'              ,pi_ne_id_new_1    => :p_ne_id_1'
                  ||CHR(10)||'              ,pi_ne_id_new_2    => :p_ne_id_2'
                  ||CHR(10)||'              );'
                  ||CHR(10)||'END;';
       EXECUTE IMMEDIATE l_block
        USING IN p_ne_id
                ,p_split_measure
                ,p_effective_date
                ,p_ne_id_1
                ,p_ne_id_2;
   END IF;
  -- Check if structures is installed and do split structures
   IF Hig.is_product_licensed(Nm3type.c_str)
    THEN
      l_block :=            'BEGIN'
                 ||CHR(10)||'    strsplit.split_data'
                 ||CHR(10)||'              (p_id        => :p_ne_id'
                 ||CHR(10)||'              ,p_chain     => :p_split_measure'
                 ||CHR(10)||'              ,p_effective => :p_effective_date'
                 ||CHR(10)||'              ,p_id1       => :p_ne_id_1'
                 ||CHR(10)||'              ,p_id2       => :p_ne_id_2'
                 ||CHR(10)||'              ,p_actioned  => TRUNC(SYSDATE)'
                 ||CHR(10)||'              );'
                 ||CHR(10)||'END;';
      EXECUTE IMMEDIATE l_block
       USING IN p_ne_id
               ,p_split_measure
               ,p_effective_date
               ,p_ne_id_1
               ,p_ne_id_2;
  END IF;
  -- Check if MM is installed and do split
   IF Hig.is_product_licensed(Nm3type.c_mai)
    THEN
      l_block :=            'BEGIN'
                 ||CHR(10)||'    maisplit.split_data'
                 ||CHR(10)||'              (p_id        => :p_ne_id'
                 ||CHR(10)||'              ,p_chain     => :p_split_measure'
                 ||CHR(10)||'              ,p_effective => :p_effective_date'
                 ||CHR(10)||'              ,p_id1       => :p_ne_id_1'
                 ||CHR(10)||'              ,p_id2       => :p_ne_id_2'
                 ||CHR(10)||'              ,p_actioned  => TRUNC(SYSDATE)'
                 ||CHR(10)||'              );'
                 ||CHR(10)||'END;';
      EXECUTE IMMEDIATE l_block
       USING IN p_ne_id
               ,p_split_measure
               ,p_effective_date
               ,p_ne_id_1
               ,p_ne_id_2;
  END IF;
  -- Check if schemes are installed and so split
   IF Hig.is_product_licensed(Nm3type.c_stp)
    THEN
      l_block :=            'BEGIN'
                 ||CHR(10)||'    stp_network_ops.do_split(pi_ne_id_old      => :pi_ne_id'
                 ||CHR(10)||'                            ,pi_split_measure  => :pi_split_measure'
                 ||CHR(10)||'                            ,pi_effective_date => :pi_effective_date'
                 ||CHR(10)||'                            ,pi_ne_id_new_1    => :pi_ne_id_new_1'
                 ||CHR(10)||'                            ,pi_ne_id_new_2    => :pi_ne_id_new_2'
                 ||CHR(10)||'                            );'
                 ||CHR(10)||'END;';
      EXECUTE IMMEDIATE l_block
       USING IN p_ne_id
               ,p_split_measure
               ,p_effective_date
               ,p_ne_id_1
               ,p_ne_id_2;
  END IF;
  -- Check if PROW is installed and so split
   IF Hig.is_product_licensed(Nm3type.c_prow)
    THEN
      l_block :=            'BEGIN'
                 ||CHR(10)||'    prowsplit.split_data( p_old_id     => :p_ne_id'
                 ||CHR(10)||'                         ,p_new_id1    => :p_ne_id_1'
                 ||CHR(10)||'                         ,p_new_id2    => :p_ne_id_2'
                 ||CHR(10)||'                         ,p_effective  => :p_effective_date'
                 ||CHR(10)||'                         );'
                 ||CHR(10)||'END;';
      EXECUTE IMMEDIATE l_block
       USING IN p_ne_id
               ,p_ne_id_1
               ,p_ne_id_2
               ,p_effective_date;
  END IF;
  -- Check if UKPMS is installed and do split
   IF Hig.is_product_licensed(Nm3type.c_ukp)
    THEN
    
      l_block :=            'BEGIN'
                 ||CHR(10)||'    ukpsplit.split( p_rse_original => :p_ne_id'
                 ||CHR(10)||'                   ,p_rse_split1   => :p_ne_id_1'
                 ||CHR(10)||'                   ,p_rse_split2   => :p_ne_id_2'
                 ||CHR(10)||'                   ,p_measure      => :p_split_measure'
                 ||CHR(10)||'                  );'
                 ||CHR(10)||'END;';
      EXECUTE IMMEDIATE l_block
       USING IN p_ne_id
               ,p_ne_id_1
               ,p_ne_id_2
               ,p_split_measure;
  END IF;
--
   Nm_Debug.proc_end(g_package_name,'split_other_products');
--
END split_other_products;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE check_other_products
                (p_ne_id             IN nm_elements.ne_id%TYPE
                ,p_chain             IN NUMBER
                ,p_effective_date    IN DATE
                ,p_errors           OUT NUMBER
                ,p_err_text         OUT VARCHAR2
                ) IS

   l_block    VARCHAR2(32767);
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'check_other_products');
--
   IF Hig.is_product_licensed(Nm3type.c_str)
    THEN
--
--      Nm_Debug.DEBUG('Check STR before splitting');
--
      l_block :=            'BEGIN'
                 ||CHR(10)||'    strsplit.check_data'
                 ||CHR(10)||'              (p_id        => :p_ne_id'
                 ||CHR(10)||'              ,p_chain     => :p_chain'
                 ||CHR(10)||'              ,p_effective => :p_effective_date'
                 ||CHR(10)||'              ,p_errors    => :p_errors'
                 ||CHR(10)||'              ,p_err_text  => :p_err_text'
                 ||CHR(10)||'              );'
                 ||CHR(10)||'END;';
      EXECUTE IMMEDIATE l_block
       USING IN p_ne_id
               ,p_chain
               ,p_effective_date
        ,IN OUT p_errors
        ,IN OUT p_err_text;
--
--  Nm_Debug.DEBUG('Check STR finished');
--
  END IF;

  -- Check if MM is installed and check for data
   IF Hig.is_product_licensed(Nm3type.c_mai)
    THEN
--
--      Nm_Debug.DEBUG('Check MAI before splitting');
--
      l_block :=            'BEGIN'
                 ||CHR(10)||'    maisplit.check_data'
                 ||CHR(10)||'              (p_id        => :p_ne_id'
                 ||CHR(10)||'              ,p_chain     => :p_chain'
                 ||CHR(10)||'              ,p_effective => :p_effective_date'
                 ||CHR(10)||'              ,p_errors    => :p_errors'
                 ||CHR(10)||'              ,p_err_text  => :p_err_text'
                 ||CHR(10)||'              );'
                 ||CHR(10)||'END;';
      EXECUTE IMMEDIATE l_block
       USING IN p_ne_id
               ,p_chain
               ,p_effective_date
        ,IN OUT p_errors
        ,IN OUT p_err_text;
--
--  Nm_Debug.DEBUG('Check MAI finished');
--
  END IF;
--
   Nm_Debug.proc_end(g_package_name,'check_other_products');
--
END check_other_products;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE do_split ( p_ne_id nm_elements.ne_id%TYPE -- the element to split
                    ,p_effective_date DATE DEFAULT  Nm3user.get_effective_date-- the date the split is effective from
                    ,p_split_measure NUMBER -- the length along the original element
                    ,p_ne_id_1             IN OUT nm_elements.ne_id%TYPE -- the new element ne_id
                    ,p_ne_id_2             IN OUT nm_elements.ne_id%TYPE        -- the 2nd new element ne_id
                    ,p_node                IN OUT nm_elements.ne_no_start%TYPE  -- the node at the split point
                    ,p_force_inheritance_of_attribs  IN     VARCHAR2                           DEFAULT 'N' -- force inheritance of all attributes on datums
                    ,p_create_node         IN     BOOLEAN DEFAULT FALSE
                    ,p_no_node_name        IN     nm_nodes.no_node_name%TYPE         DEFAULT NULL
                    ,p_no_descr            IN     nm_nodes.no_descr%TYPE             DEFAULT NULL
                    ,p_no_node_type        IN     nm_nodes.no_node_type%TYPE         DEFAULT NULL
                    ,p_no_np_id            IN     nm_nodes.no_np_id%TYPE             DEFAULT NULL
                    ,p_np_grid_east        IN     NM_POINTS.np_grid_east%TYPE        DEFAULT NULL
                    ,p_np_grid_north       IN     NM_POINTS.np_grid_north%TYPE       DEFAULT NULL
                    ,p_no_purpose          in     nm_nodes.no_purpose%type           DEFAULT NULL -- PT 03.06.08
                    ,p_ne_unique_1         IN     nm_elements.ne_unique%TYPE         DEFAULT NULL
                    ,p_ne_type_1           IN     nm_elements.ne_type%TYPE           DEFAULT NULL
                    ,p_ne_nt_type_1        IN     nm_elements.ne_nt_type%TYPE        DEFAULT NULL
                    ,p_ne_descr_1          IN     nm_elements.ne_descr%TYPE          DEFAULT NULL
                    ,p_ne_length_1         IN     nm_elements.ne_length%TYPE         DEFAULT NULL
                    ,p_ne_admin_unit_1     IN     nm_elements.ne_admin_unit%TYPE     DEFAULT NULL
                    ,p_ne_gty_group_type_1 IN     nm_elements.ne_gty_group_type%TYPE DEFAULT NULL
                    ,p_ne_owner_1          IN     nm_elements.ne_owner%TYPE          DEFAULT NULL
                    ,p_ne_name_1_1         IN     nm_elements.ne_name_1%TYPE         DEFAULT NULL
                    ,p_ne_name_2_1         IN     nm_elements.ne_name_2%TYPE         DEFAULT NULL
                    ,p_ne_prefix_1         IN     nm_elements.ne_prefix%TYPE         DEFAULT NULL
                    ,p_ne_number_1         IN     nm_elements.ne_number%TYPE         DEFAULT NULL
                    ,p_ne_sub_type_1       IN     nm_elements.ne_sub_type%TYPE       DEFAULT NULL
                    ,p_ne_group_1          IN     nm_elements.ne_group%TYPE          DEFAULT NULL
                    ,p_ne_no_start_1       IN     nm_elements.ne_no_start%TYPE       DEFAULT NULL
                    ,p_ne_no_end_1         IN     nm_elements.ne_no_end%TYPE         DEFAULT NULL
                    ,p_ne_sub_class_1      IN     nm_elements.ne_sub_class%TYPE      DEFAULT NULL
                    ,p_ne_nsg_ref_1        IN     nm_elements.ne_nsg_ref%TYPE        DEFAULT NULL
                    ,p_ne_version_no_1     IN     nm_elements.ne_version_no%TYPE     DEFAULT NULL
                    ,p_ne_unique_2         IN     nm_elements.ne_unique%TYPE         DEFAULT NULL
                    ,p_ne_type_2           IN     nm_elements.ne_type%TYPE           DEFAULT NULL
                    ,p_ne_nt_type_2        IN     nm_elements.ne_nt_type%TYPE        DEFAULT NULL
                    ,p_ne_descr_2          IN     nm_elements.ne_descr%TYPE          DEFAULT NULL
                    ,p_ne_length_2         IN     nm_elements.ne_length%TYPE         DEFAULT NULL
                    ,p_ne_admin_unit_2     IN     nm_elements.ne_admin_unit%TYPE     DEFAULT NULL
                    ,p_ne_gty_group_type_2 IN     nm_elements.ne_gty_group_type%TYPE DEFAULT NULL
                    ,p_ne_owner_2          IN     nm_elements.ne_owner%TYPE          DEFAULT NULL
                    ,p_ne_name_1_2         IN     nm_elements.ne_name_1%TYPE         DEFAULT NULL
                    ,p_ne_name_2_2         IN     nm_elements.ne_name_2%TYPE         DEFAULT NULL
                    ,p_ne_prefix_2         IN     nm_elements.ne_prefix%TYPE         DEFAULT NULL
                    ,p_ne_number_2         IN     nm_elements.ne_number%TYPE         DEFAULT NULL
                    ,p_ne_sub_type_2       IN     nm_elements.ne_sub_type%TYPE       DEFAULT NULL
                    ,p_ne_group_2          IN     nm_elements.ne_group%TYPE          DEFAULT NULL
                    ,p_ne_no_start_2       IN     nm_elements.ne_no_start%TYPE       DEFAULT NULL
                    ,p_ne_no_end_2         IN     nm_elements.ne_no_end%TYPE         DEFAULT NULL
                    ,p_ne_sub_class_2      IN     nm_elements.ne_sub_class%TYPE      DEFAULT NULL
                    ,p_ne_nsg_ref_2        IN     nm_elements.ne_nsg_ref%TYPE        DEFAULT NULL
                    ,p_ne_version_no_2     IN     nm_elements.ne_version_no%TYPE     DEFAULT NULL
                    ,p_neh_descr           IN     nm_element_history.neh_descr%TYPE  DEFAULT NULL --CWS 0108990 12/03/2010
                    ) IS
   --
   l_no_node_type nm_nodes.no_node_type%TYPE   := p_no_node_type;


   --
   c_empty_rec_ne          nm_elements%ROWTYPE;
   --
   l_grid_east  NUMBER;
   l_grid_north NUMBER;

   l_split_measure number := p_split_measure; -- need to cater for cases where the split is via a pure XY

   l_theme  nm_themes_all.nth_theme_id%type;
/*
This is a version of the private function from nm3sdo - needs to be removed asap RAC November 2008
*/
FUNCTION Get_Datum_Theme( p_nt IN NM_TYPES.nt_type%TYPE ) RETURN NM_THEMES_ALL.nth_theme_id%TYPE IS
retval NM_THEMES_ALL.nth_theme_id%TYPE;
CURSOR c_nth ( c_nt IN NM_TYPES.nt_type%TYPE ) IS
  SELECT nth_theme_id
  FROM NM_THEMES_ALL, NM_NW_THEMES, NM_LINEAR_TYPES
  WHERE nth_theme_id = nnth_nth_theme_id
  AND   nnth_nlt_id = nlt_id
  AND   nlt_g_i_d   = 'D'
  AND   nlt_nt_type = c_nt
  AND   nth_dependency = 'I'
  AND   nth_base_table_theme is null;

BEGIN
  OPEN c_nth(p_nt);
  FETCH c_nth INTO retval;
  CLOSE c_nth;
  RETURN retval;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    CLOSE c_nth;
    RETURN NULL;
END;

---------------------------------------------------------------------------------------------------------
   --
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'do_split');
--
   -- Clear out the NM_MEMBER_HISTORY variables
   Nm3merge.clear_nmh_variables;
--
   g_rec_ne_old   := Nm3net.get_ne (p_ne_id);
--

   IF NOT p_create_node THEN

      IF p_node IS NULL THEN
        Hig.raise_ner(pi_appl               => Nm3type.c_net
                     ,pi_id                 => 362);
      END IF;

      if p_np_grid_east is not null and p_np_grid_north is not null then

        l_grid_east  := p_np_grid_east;
        l_grid_north := p_np_grid_north;

      else

--        nm_debug.debug_on;
--        nm_debug.debug('The x and y values are null');

        begin
          select np_grid_east, np_grid_north
          into l_grid_east, l_grid_north
          from nm_points, nm_nodes
          where np_id = no_np_id
          and no_node_id = p_node;
        end;

      end if;


   ELSE

      IF l_no_node_type IS NULL
       THEN
         l_no_node_type := Nm3net.get_nt(g_rec_ne_old.ne_nt_type).nt_node_type;
      END IF;
      IF l_no_node_type IS NOT NULL
       THEN
           --
           -- RC changes (AE put them in)
           --  During the split, if forms or a non-spatial client has inaugurated the split, there may be no
           --  grid co-ordinates of the point. This code will add the co-ordinates.
           --
           BEGIN
              IF p_split_measure is not null and p_np_grid_east IS NULL AND p_np_grid_north IS NULL THEN
                Nm3sdm.get_datum_xy_from_measure( p_ne_id => p_ne_id,
                                                  p_measure => p_split_measure,
                                                  p_x => l_grid_east,
                                                  p_y => l_grid_north );
              ELSE

                 l_grid_east  := p_np_grid_east;
                 l_grid_north := p_np_grid_north;

              END IF;
         EXCEPTION
           -- Need a meaningful message here
           WHEN OTHERS THEN
              NULL;
         END;


         p_node := create_node_internal
                     (p_no_node_id     => p_node
                     ,p_no_node_name   => p_no_node_name
                     ,p_no_descr       => p_no_descr
                     ,p_no_node_type   => l_no_node_type
                     ,p_no_np_id       => p_no_np_id
                     ,p_effective_date => p_effective_date
                     ,p_np_grid_east   => l_grid_east
                     ,p_np_grid_north  => l_grid_north
                     ,p_no_purpose     => p_no_purpose
                     );

      END IF;
   END IF;

--nm_debug.debug('CREATED A NODE AT THE DATUM SPLIT WITH NODE ID='||p_node);
--


   if p_split_measure is null then

     l_theme := Get_Datum_Theme( g_rec_ne_old.ne_nt_type);

     l_split_measure := NM3SDO.GET_MEASURE(l_theme, p_ne_id, l_grid_east, l_grid_north ).lr_offset;

--   l_split_measure := SDO_LRS.FIND_MEASURE(NM3SDO.GET_LAYER_ELEMENT_GEOMETRY(pi_ne_id), nm3sdo.get_2d_pt(pi_np_grid_east, pi_np_grid_north), 0.005 );
   else

     l_split_measure := p_split_measure;

   end if;

   split_element (p_ne_id               => p_ne_id
                 ,p_type_of_split       => 'S'
                 ,p_effective_date      => p_effective_date
                 ,p_ne_id_1             => p_ne_id_1
                 ,p_ne_length_1         => l_split_measure
                 ,p_ne_id_2             => p_ne_id_2
                 ,p_ne_length_2         => g_rec_ne_old.ne_length - l_split_measure
                 ,p_node                => p_node
                 ,p_force_inheritance_of_attribs => 'N'
                 ,p_ne_unique_1         => p_ne_unique_1
                 ,p_ne_type_1           => p_ne_type_1
                 ,p_ne_nt_type_1        => p_ne_nt_type_1
                 ,p_ne_descr_1          => p_ne_descr_1
                 ,p_ne_admin_unit_1     => p_ne_admin_unit_1
                 ,p_ne_gty_group_type_1 => p_ne_gty_group_type_1
                 ,p_ne_owner_1          => p_ne_owner_1
                 ,p_ne_name_1_1         => p_ne_name_1_1
                 ,p_ne_name_2_1         => p_ne_name_2_1
                 ,p_ne_prefix_1         => p_ne_prefix_1
                 ,p_ne_number_1         => p_ne_number_1
                 ,p_ne_sub_type_1       => p_ne_sub_type_1
                 ,p_ne_group_1          => p_ne_group_1
                 ,p_ne_no_start_1       => p_ne_no_start_1
                 ,p_ne_no_end_1         => p_ne_no_end_1
                 ,p_ne_sub_class_1      => p_ne_sub_class_1
                 ,p_ne_nsg_ref_1        => p_ne_nsg_ref_1
                 ,p_ne_version_no_1     => p_ne_version_no_1
                 ,p_ne_unique_2         => p_ne_unique_2
                 ,p_ne_type_2           => p_ne_type_2
                 ,p_ne_nt_type_2        => p_ne_nt_type_2
                 ,p_ne_descr_2          => p_ne_descr_2
                 ,p_ne_admin_unit_2     => p_ne_admin_unit_2
                 ,p_ne_gty_group_type_2 => p_ne_gty_group_type_2
                 ,p_ne_owner_2          => p_ne_owner_2
                 ,p_ne_name_1_2         => p_ne_name_1_2
                 ,p_ne_name_2_2         => p_ne_name_2_2
                 ,p_ne_prefix_2         => p_ne_prefix_2
                 ,p_ne_number_2         => p_ne_number_2
                 ,p_ne_sub_type_2       => p_ne_sub_type_2
                 ,p_ne_group_2          => p_ne_group_2
                 ,p_ne_no_start_2       => p_ne_no_start_2
                 ,p_ne_no_end_2         => p_ne_no_end_2
                 ,p_ne_sub_class_2      => p_ne_sub_class_2
                 ,p_ne_nsg_ref_2        => p_ne_nsg_ref_2
                 ,p_ne_version_no_2     => p_ne_version_no_2
                 ,p_neh_descr           => p_neh_descr --CWS 0108990 12/03/2010
                 );

    -- CWS 0111024 Lateral Offsets Changes
  IF NVL(hig.get_sysopt('XSPOFFSET'),'N') = 'Y'
  THEN
    EXECUTE IMMEDIATE 'BEGIN ' ||
                      'xncc_herm_xsp.populate_herm_xsp( p_ne_id => :p_ne_id ' ||
                                                     ', p_ne_id_new => :p_ne_id_1 ' ||
                                                     ', p_effective_date => :p_effective_date ' ||
                                                     '); ' ||
                     'END;' USING p_ne_id, p_ne_id_1, p_effective_date;

    EXECUTE IMMEDIATE 'BEGIN ' ||
                      'xncc_herm_xsp.populate_herm_xsp( p_ne_id => :p_ne_id ' ||
                                                     ', p_ne_id_new => :p_ne_id_2 ' ||
                                                     ', p_effective_date => :p_effective_date ' ||
                                                     '); ' || 
                      'END;' USING p_ne_id, p_ne_id_2, p_effective_date;
  END IF;
--
-- RAC - split the shapes
-- AE - put changes in
--

   Nm3sdm.split_element_shapes( p_ne_id => p_ne_id,
                                p_measure => l_split_measure,
                                p_ne_id_1 => p_ne_id_1,
                                p_ne_id_2 => p_ne_id_2,
                                p_x => l_grid_east,
                                p_y => l_grid_north);
--
   split_members (p_ne_id          => p_ne_id
                 ,p_ne_id_1        => p_ne_id_1
                 ,p_ne_id_2        => p_ne_id_2
                 ,p_split_measure  => l_split_measure
                 ,p_effective_date => p_effective_date
                 );
--
   split_other_products (p_ne_id          => p_ne_id
                        ,p_ne_id_1        => p_ne_id_1
                        ,p_ne_id_2        => p_ne_id_2
                        ,p_split_measure  => l_split_measure
                        ,p_effective_date => p_effective_date
                        );
--
   IF Nm3nwad.ad_data_exist(p_ne_id) THEN

      Nm3nwad.do_ad_split( pi_old_ne_id  => p_ne_id
                         , pi_new_ne_id1 => p_ne_id_1
                         , pi_new_ne_id2 => p_ne_id_2);

   END IF;

   end_date_elements (p_ne_id          => p_ne_id
                     ,p_effective_date => p_effective_date
                     );
--
--
   -- Insert the stored NM_MEMBER_HISTORY records
   Nm3merge.ins_nmh;
--
   Nm_Debug.proc_end(g_package_name,'do_split');
--
END do_split;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE do_geo_split
                    (p_ne_id               IN     nm_elements.ne_id%TYPE       -- the element to split
                    ,p_effective_date      IN     DATE                               DEFAULT Nm3user.get_effective_date
                                                                               -- the date the split is effective from
                    ,p_split_measure       IN     NUMBER                       -- the length along the original element
                    ,p_ne_id_1             IN     nm_elements.ne_id%TYPE       -- the new element ne_id
                    ,p_ne_id_2             IN     nm_elements.ne_id%TYPE       -- the 2nd new element ne_id
                    ,p_node                IN     nm_elements.ne_no_start%TYPE -- the node at the split point
                    ,p_create_node         IN     BOOLEAN DEFAULT FALSE
                    ,p_no_node_name        IN     nm_nodes.no_node_name%TYPE         DEFAULT NULL
                    ,p_no_descr            IN     nm_nodes.no_descr%TYPE             DEFAULT NULL
                    ,p_no_node_type        IN     nm_nodes.no_node_type%TYPE         DEFAULT NULL
                    ,p_no_np_id            IN     nm_nodes.no_np_id%TYPE             DEFAULT NULL
                    ,p_np_grid_east        IN     NM_POINTS.np_grid_east%TYPE        DEFAULT NULL
                    ,p_np_grid_north       IN     NM_POINTS.np_grid_north%TYPE       DEFAULT NULL
                    ,p_no_purpose          in     nm_nodes.no_purpose%type default null -- PT 03.06.08

                    ,p_ne_unique_1         IN     nm_elements.ne_unique%TYPE         DEFAULT NULL
                    ,p_ne_type_1           IN     nm_elements.ne_type%TYPE           DEFAULT NULL
                    ,p_ne_nt_type_1        IN     nm_elements.ne_nt_type%TYPE        DEFAULT NULL
                    ,p_ne_descr_1          IN     nm_elements.ne_descr%TYPE          DEFAULT NULL
                    ,p_ne_length_1         IN     nm_elements.ne_length%TYPE         DEFAULT NULL
                    ,p_ne_admin_unit_1     IN     nm_elements.ne_admin_unit%TYPE     DEFAULT NULL
                    ,p_ne_gty_group_type_1 IN     nm_elements.ne_gty_group_type%TYPE DEFAULT NULL
                    ,p_ne_owner_1          IN     nm_elements.ne_owner%TYPE          DEFAULT NULL
                    ,p_ne_name_1_1         IN     nm_elements.ne_name_1%TYPE         DEFAULT NULL
                    ,p_ne_name_2_1         IN     nm_elements.ne_name_2%TYPE         DEFAULT NULL
                    ,p_ne_prefix_1         IN     nm_elements.ne_prefix%TYPE         DEFAULT NULL
                    ,p_ne_number_1         IN     nm_elements.ne_number%TYPE         DEFAULT NULL
                    ,p_ne_sub_type_1       IN     nm_elements.ne_sub_type%TYPE       DEFAULT NULL
                    ,p_ne_group_1          IN     nm_elements.ne_group%TYPE          DEFAULT NULL
                    ,p_ne_no_start_1       IN     nm_elements.ne_no_start%TYPE       DEFAULT NULL
                    ,p_ne_no_end_1         IN     nm_elements.ne_no_end%TYPE         DEFAULT NULL
                    ,p_ne_sub_class_1      IN     nm_elements.ne_sub_class%TYPE       DEFAULT NULL
                    ,p_ne_nsg_ref_1        IN     nm_elements.ne_nsg_ref%TYPE        DEFAULT NULL
                    ,p_ne_version_no_1     IN     nm_elements.ne_version_no%TYPE     DEFAULT NULL
                    ,p_ne_unique_2         IN     nm_elements.ne_unique%TYPE         DEFAULT NULL
                    ,p_ne_type_2           IN     nm_elements.ne_type%TYPE           DEFAULT NULL
                    ,p_ne_nt_type_2        IN     nm_elements.ne_nt_type%TYPE        DEFAULT NULL
                    ,p_ne_descr_2          IN     nm_elements.ne_descr%TYPE          DEFAULT NULL
                    ,p_ne_length_2         IN     nm_elements.ne_length%TYPE         DEFAULT NULL
                    ,p_ne_admin_unit_2     IN     nm_elements.ne_admin_unit%TYPE     DEFAULT NULL
                    ,p_ne_gty_group_type_2 IN     nm_elements.ne_gty_group_type%TYPE DEFAULT NULL
                    ,p_ne_owner_2          IN     nm_elements.ne_owner%TYPE          DEFAULT NULL
                    ,p_ne_name_1_2         IN     nm_elements.ne_name_1%TYPE         DEFAULT NULL
                    ,p_ne_name_2_2         IN     nm_elements.ne_name_2%TYPE         DEFAULT NULL
                    ,p_ne_prefix_2         IN     nm_elements.ne_prefix%TYPE         DEFAULT NULL
                    ,p_ne_number_2         IN     nm_elements.ne_number%TYPE         DEFAULT NULL
                    ,p_ne_sub_type_2       IN     nm_elements.ne_sub_type%TYPE       DEFAULT NULL
                    ,p_ne_group_2          IN     nm_elements.ne_group%TYPE          DEFAULT NULL
                    ,p_ne_no_start_2       IN     nm_elements.ne_no_start%TYPE       DEFAULT NULL
                    ,p_ne_no_end_2         IN     nm_elements.ne_no_end%TYPE         DEFAULT NULL
                    ,p_ne_sub_class_2      IN     nm_elements.ne_sub_class%TYPE       DEFAULT NULL
                    ,p_ne_nsg_ref_2        IN     nm_elements.ne_nsg_ref%TYPE        DEFAULT NULL
                    ,p_ne_version_no_2     IN     nm_elements.ne_version_no%TYPE     DEFAULT NULL
                    ) IS
--
   v_ne_id_1  nm_elements.ne_id%TYPE       := p_ne_id_1;
   v_ne_id_2  nm_elements.ne_id%TYPE       := p_ne_id_2;
   v_node     nm_elements.ne_no_start%TYPE := p_node;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'do_geo_split');
--
   check_element_can_be_split(pi_effective_date => p_effective_date);
--
   validate_split_position (pi_split_offset     => p_split_measure
                           ,pi_split_at_node    => NULL
                           ,pi_non_ambig_ne_id  => NULL
                           ,pi_non_ambig_split_offset => NULL
                           ,pi_effective_date   => p_effective_date);
--
   Nm3lock.lock_element_and_members (p_ne_id);
--
   set_for_split;


   do_split
        (p_ne_id               => p_ne_id
        ,p_effective_date      => p_effective_date
        ,p_split_measure       => p_split_measure
        ,p_ne_id_1             => v_ne_id_1
        ,p_ne_id_2             => v_ne_id_2
        ,p_node                => v_node
        ,p_create_node         => p_create_node
        ,p_no_node_name        => p_no_node_name
        ,p_no_descr            => p_no_descr
        ,p_no_node_type        => p_no_node_type
        ,p_no_np_id            => p_no_np_id
        ,p_np_grid_east        => p_np_grid_east
        ,p_np_grid_north       => p_np_grid_north
        ,p_no_purpose          => p_no_purpose    -- PT 03.06.08
        ,p_ne_unique_1         => p_ne_unique_1
        ,p_ne_type_1           => p_ne_type_1
        ,p_ne_nt_type_1        => p_ne_nt_type_1
        ,p_ne_descr_1          => p_ne_descr_1
        ,p_ne_length_1         => p_ne_length_1
        ,p_ne_admin_unit_1     => p_ne_admin_unit_1
        ,p_ne_gty_group_type_1 => p_ne_gty_group_type_1
        ,p_ne_owner_1          => p_ne_owner_1
        ,p_ne_name_1_1         => p_ne_name_1_1
        ,p_ne_name_2_1         => p_ne_name_2_1
        ,p_ne_prefix_1         => p_ne_prefix_1
        ,p_ne_number_1         => p_ne_number_1
        ,p_ne_sub_type_1       => p_ne_sub_type_1
        ,p_ne_group_1          => p_ne_group_1
        ,p_ne_no_start_1       => p_ne_no_start_1
        ,p_ne_no_end_1         => p_ne_no_end_1
        ,p_ne_sub_class_1      => p_ne_sub_class_1
        ,p_ne_nsg_ref_1        => p_ne_nsg_ref_1
        ,p_ne_version_no_1     => p_ne_version_no_1
        ,p_ne_unique_2         => p_ne_unique_2
        ,p_ne_type_2           => p_ne_type_2
        ,p_ne_nt_type_2        => p_ne_nt_type_2
        ,p_ne_descr_2          => p_ne_descr_2
        ,p_ne_length_2         => p_ne_length_2
        ,p_ne_admin_unit_2     => p_ne_admin_unit_2
        ,p_ne_gty_group_type_2 => p_ne_gty_group_type_2
        ,p_ne_owner_2          => p_ne_owner_2
        ,p_ne_name_1_2         => p_ne_name_1_2
        ,p_ne_name_2_2         => p_ne_name_2_2
        ,p_ne_prefix_2         => p_ne_prefix_2
        ,p_ne_number_2         => p_ne_number_2
        ,p_ne_sub_type_2       => p_ne_sub_type_2
        ,p_ne_group_2          => p_ne_group_2
        ,p_ne_no_start_2       => p_ne_no_start_2
        ,p_ne_no_end_2         => p_ne_no_end_2
        ,p_ne_sub_class_2      => p_ne_sub_class_2
        ,p_ne_nsg_ref_2        => p_ne_nsg_ref_2
        ,p_ne_version_no_2     => p_ne_version_no_2
        );
--
   set_for_return;

   Nm_Debug.proc_end(g_package_name,'do_geo_split');
--
END do_geo_split;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE set_ne_globals(pi_ne_id IN nm_elements.ne_id%TYPE) IS

BEGIN
  g_ne_to_split_rec      := Nm3net.get_ne(pi_ne_id => pi_ne_id);
  g_ne_to_split_ngt_rec  := Nm3net.get_gty(pi_gty => g_ne_to_split_rec.ne_gty_group_type);
  g_ne_to_split_nt_rec   := Nm3net.get_nt (pi_nt_type => g_ne_to_split_rec.ne_nt_type);
END;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_g_ne_to_split_rec RETURN nm_elements%ROWTYPE IS

BEGIN
  RETURN(g_ne_to_split_rec);
END;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_g_ne_to_split_ngt_rec RETURN nm_group_types%ROWTYPE IS

BEGIN
  RETURN(g_ne_to_split_ngt_rec);
END;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_g_ne_to_split_nt_rec RETURN NM_TYPES%ROWTYPE IS

BEGIN
  RETURN(g_ne_to_split_nt_rec);
END;
--
------------------------------------------------------------------------------------------------
--
FUNCTION can_element_be_split (pi_ne_rec         IN nm_elements%ROWTYPE
                              ,pi_effective_date IN DATE DEFAULT NULL) RETURN BOOLEAN IS

 PROCEDURE set_output_params(p_ner_appl           IN nm_errors.ner_appl%TYPE
                            ,p_ner_id             IN nm_errors.ner_id%TYPE
                            ,p_supplimentary_info IN VARCHAR2) IS

 BEGIN
    g_ner_appl := p_ner_appl;
    g_ner_id := p_ner_id;
    g_supplimentary_info := p_supplimentary_info;
 END;

BEGIN

  Nm_Debug.proc_start(g_package_name,'can_element_be_split');

  IF NVL(pi_effective_date,TRUNC(SYSDATE)) > TRUNC(SYSDATE) THEN
     set_output_params(Nm3type.c_net
                      ,165
                      ,NULL);
     RETURN(FALSE);
  END IF;

  IF NOT Nm3inv_Security.can_usr_see_all_inv_on_element(pi_ne_rec.ne_id) THEN
     set_output_params(Nm3type.c_net
                      ,172  -- User does not have access to all inventory on element
                      ,NULL);
     RETURN(FALSE);
  END IF;

  IF Nm3net.element_has_future_dated_membs(pi_ne_id => pi_ne_rec.ne_id
                                          ,pi_effective_date => pi_effective_date) THEN
     set_output_params(Nm3type.c_net
                      ,378  -- Element has memberships with a future start date
                      ,NULL);

     RETURN(FALSE);
  END IF;


  IF Nm3net.element_is_a_datum(pi_ne_type  =>  pi_ne_rec.ne_type) = FALSE
  AND
     Nm3net.element_is_a_group(pi_ne_type  =>  pi_ne_rec.ne_type) = FALSE THEN
     set_output_params(Nm3type.c_net
                      ,357  -- Operation can only be performed on datum elements and groups of sections.
                      ,NULL);
     RETURN(FALSE);
  END IF;


  IF Nm3net.element_is_a_group(pi_ne_type  =>  pi_ne_rec.ne_type) THEN

     --------------------------------------------------
     -- if a group then the element type must be linear
     --------------------------------------------------
     IF Nm3net.is_nt_linear(p_nt_type => pi_ne_rec.ne_nt_type) = 'N' THEN
        set_output_params(Nm3type.c_net
                         ,336 -- Cannot perform operation on non-linear network types"
                         ,NULL);
        RETURN(FALSE);
     END IF;


     -------------------------------------------------------------------------------------------------
     -- if a group cannot use auto-inclusion from group onto datum- cos split_group cannot handle that
     -------------------------------------------------------------------------------------------------
--     l_nt := nm3net.get_nt(pi_ne_rec.ne_nt_type);

     IF Nm3net.is_nt_inclusion(pi_ne_rec.ne_nt_type) THEN
            set_output_params(Nm3type.c_net
                             ,361  -- cannot split group
                             ,CHR(10)||'Auto-Inclusion detected between Network Type '||pi_ne_rec.ne_nt_type||' and datum network.');
            RETURN(FALSE);
     END IF;

     -----------------------------------------------------------
     -- if splitting a route then the start and the end point of
     -- the route must be non-ambiguous otherwise working
     -- out the memberships to the left of the split position is
     -- impossible
     -----------------------------------------------------------
     DECLARE
       ex_invalid_start_point EXCEPTION;
     BEGIN
        IF Nm3lrs.is_location_ambiguous(pi_ne_id     => pi_ne_rec.ne_id
                                       ,pi_offset    => Nm3net.get_min_slk(pi_ne_rec.ne_id)) THEN
            RAISE ex_invalid_start_point;
        END IF;
     EXCEPTION
       WHEN OTHERS THEN
           set_output_params(Nm3type.c_net
                            ,361  -- cannot split group
                            ,CHR(10)||'Start point of group is ambiguous.');
           RETURN(FALSE);
     END;

     DECLARE
       ex_invalid_end_point EXCEPTION;
     BEGIN
        IF Nm3lrs.is_location_ambiguous(pi_ne_id     => pi_ne_rec.ne_id
                                       ,pi_offset    => Nm3net.get_max_slk(pi_ne_rec.ne_id)) THEN
            RAISE ex_invalid_end_point;
        END IF;
     EXCEPTION
       WHEN OTHERS THEN
            set_output_params(Nm3type.c_net
                             ,361  -- cannot split group
                             ,CHR(10)||'End point of group is ambiguous.');
           RETURN(FALSE);
     END;

   END IF; -- datum or group

   --
   -- if we've got this far then split can go ahead
   --
   RETURN(TRUE);


  Nm_Debug.proc_end(g_package_name,'can_element_be_split');


END can_element_be_split;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE check_element_can_be_split(pi_ne_id          IN nm_elements.ne_id%TYPE DEFAULT NULL
                                    ,pi_effective_date IN DATE DEFAULT NULL) IS

  l_ne_to_split_rec nm_elements%ROWTYPE;

BEGIN

  Nm_Debug.proc_start(g_package_name,'check_element_can_be_split');

  --
  -- if ne_id supplied then get the whole ne record otherwise
  -- assume we're working with the ne stored in package global rowtype var
  --
  IF pi_ne_id IS NOT NULL THEN
    l_ne_to_split_rec := Nm3net.get_ne( pi_ne_id );
  ELSE
    l_ne_to_split_rec := g_ne_to_split_rec;
  END IF;

  IF NOT can_element_be_split(pi_ne_rec => l_ne_to_split_rec
                             ,pi_effective_date => pi_effective_date) THEN
          Hig.raise_ner (pi_appl    => g_ner_appl
                        ,pi_id      => g_ner_id
                        ,pi_supplementary_info => g_supplimentary_info);
  END IF;

  Nm_Debug.proc_end(g_package_name,'check_element_can_be_split');

END check_element_can_be_split;
--
------------------------------------------------------------------------------------------------
--
FUNCTION non_ambig_ref_is_valid(pi_route_ne_id            IN nm_elements.ne_id%TYPE
                               ,pi_split_offset           IN NUMBER
                               ,pi_non_ambig_ne_id        IN nm_elements.ne_id%TYPE
                               ,pi_non_ambig_split_offset IN NUMBER
                               ) RETURN BOOLEAN IS

 l_non_ambig_ne_id       nm_elements.ne_id%TYPE;
 l_non_ambig_offset      NUMBER;

BEGIN

  IF pi_non_ambig_ne_id IS NULL OR pi_non_ambig_split_offset IS NULL THEN
     RETURN(FALSE);
  END IF;

    ---------------------------------------------------------------
    -- Get non-ambiguous refs for the route and offset and ensure
    -- that the non-ambig ne_id and offset passed in is in the list
    ---------------------------------------------------------------
    Nm3wrap.get_ambiguous_lrefs(pi_parent_id => pi_route_ne_id
                               ,pi_offset    => pi_split_offset);

  FOR i IN 1..Nm3wrap.lref_count LOOP
       Nm3wrap.lref_get_row(pi_index  => i
                           ,po_ne_id  => l_non_ambig_ne_id
                           ,po_offset => l_non_ambig_offset);


       IF l_non_ambig_ne_id = pi_non_ambig_ne_id AND l_non_ambig_offset = pi_non_ambig_split_offset THEN
         RETURN(TRUE);
       END IF;
  END LOOP;

  RETURN(FALSE);

END non_ambig_ref_is_valid;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE validate_split_position (pi_ne_id                  IN nm_elements.ne_id%TYPE DEFAULT NULL
                                  ,pi_split_offset           IN NUMBER
                                  ,pi_non_ambig_ne_id        IN nm_elements.ne_id%TYPE    -- only applicable when splitting a group
                                  ,pi_non_ambig_split_offset IN NUMBER                    -- only applicable when splitting a group
                                  ,pi_split_at_node          IN nm_nodes.no_node_id%TYPE
                                  ,pi_effective_date         IN DATE
                                  ) IS


  CURSOR c_valid_nodes(cp_ne_id nm_elements.ne_id%TYPE) IS
  SELECT *
  FROM   nm_route_nodes
  WHERE  route_id = cp_ne_id
  AND    node_type != 'T'
  AND    node_id   = pi_split_at_node;

  l_nm_route_nodes_rec nm_route_nodes%ROWTYPE;

  l_from               NUMBER;
  l_to                 NUMBER;
  l_overall_length     nm_elements.ne_length%TYPE;

  l_ne_rec             nm_elements%ROWTYPE;

  l_errors   NUMBER;
  l_err_text VARCHAR2(10000);

BEGIN


  Nm_Debug.proc_start(g_package_name,'validate_split_position');

  --
  -- if ne_id supplied then get the whole ne record otherwise
  -- assume we're working with the ne stored in package global rowtype var
  --
  IF pi_ne_id IS NOT NULL THEN
    l_ne_rec := Nm3net.get_ne( pi_ne_id );
  ELSE
    l_ne_rec := g_ne_to_split_rec;
  END IF;

  check_other_products ( p_ne_id          => pi_ne_id
                        ,p_chain          => pi_split_offset
                        ,p_effective_date => pi_effective_date
                        ,p_errors         => l_errors
                        ,p_err_text       => l_err_text
                        );

  IF l_err_text IS NOT NULL  THEN
            Hig.raise_ner (pi_appl    => Nm3type.c_net
                          ,pi_id      => 361  -- element cannot be split
                          ,pi_supplementary_info => l_err_text);

  END IF;

  -----------------------------------------------------------------------------------
  -- if splitting at a node then ensure that the node is
  -- a) on the route
  -- b) is not a terminating node
  --
  ------------------------------------------------------------------------------------
  IF Nm3net.element_is_a_group(pi_ne_type => l_ne_rec.ne_type) AND pi_split_at_node IS NOT NULL THEN

     Nm3net_O.set_g_ne_id_to_restrict_on(pi_ne_id => l_ne_rec.ne_id);

     OPEN c_valid_nodes(l_ne_rec.ne_id);
     FETCH c_valid_nodes INTO l_nm_route_nodes_rec;
     IF c_valid_nodes%NOTFOUND THEN
       CLOSE c_valid_nodes;
       Hig.raise_ner (Nm3type.c_net,359);  -- "Group cannot be split at this node."
     END IF;
     CLOSE c_valid_nodes;

  ELSIF pi_split_offset IS NOT NULL THEN

    ------------------------------------------------------------------------------------
    -- if splitting at an offset then ensure that the offset is
    -- a) within start/end of datum/group length
    -- b) the offset is non-ambiguous
    ------------------------------------------------------------------------------------
    IF Nm3net.element_is_a_group(pi_ne_type  =>  l_ne_rec.ne_type) THEN
       l_from := Nm3net.get_min_slk(pi_ne_id => l_ne_rec.ne_id);
       l_to   := Nm3net.get_max_slk(pi_ne_id => l_ne_rec.ne_id);

    ELSIF Nm3net.element_is_a_datum(pi_ne_type  =>  l_ne_rec.ne_type) THEN
       l_from := 0;
       l_to    := Nm3net.Get_Ne_Length(p_ne_id  => l_ne_rec.ne_id);

    END IF;


    IF NVL(pi_split_offset,0) <= l_from OR NVL(pi_split_offset,0) >= l_to THEN
          Hig.raise_ner (pi_appl    => Nm3type.c_net
                        ,pi_id      => 358 -- Split position is invalid.
                        ,pi_supplementary_info => CHR(10)||CHR(10)||'>'||l_from||CHR(10)||'<'||l_to);
    END IF;


    IF Nm3net.element_is_a_group(pi_ne_type => l_ne_rec.ne_type) THEN


       IF NOT non_ambig_ref_is_valid(pi_route_ne_id            => l_ne_rec.ne_id
                                    ,pi_split_offset           => pi_split_offset
                                    ,pi_non_ambig_ne_id        => pi_non_ambig_ne_id
                                    ,pi_non_ambig_split_offset => pi_non_ambig_split_offset
                                    ) THEN

            Hig.raise_ner (pi_appl    => Nm3type.c_net
                          ,pi_id      => 367);--Group Offset does not coincide with Non-Ambiguous Offset.

       END IF;

    END IF;

  END IF;  -- splitting at node or offset

  Nm_Debug.proc_end(g_package_name,'validate_split_position');

END validate_split_position;
--
------------------------------------------------------------------------------------------------
--
FUNCTION datum_split_required(pi_ne_id                   IN     nm_elements.ne_id%TYPE
                             ,pi_split_at_node_id        IN     nm_nodes.no_node_id%TYPE
                             ) RETURN BOOLEAN IS

  l_ne_rec nm_elements%ROWTYPE;
  l_ngt_rec nm_group_types%ROWTYPE;

BEGIN

  Nm_Debug.proc_start(g_package_name,'datum_split_required');

  l_ne_rec  := Nm3net.get_ne( pi_ne_id );
  l_ngt_rec := Nm3net.get_gty(pi_gty => l_ne_rec.ne_gty_group_type);


    IF   Nm3net.element_is_a_datum (pi_ne_type => l_ne_rec.ne_type) THEN
      RETURN(TRUE);
    ELSIF  -- if a non-partial group and splitting at an offset
      Nm3net.element_is_a_group(pi_ne_type => l_ne_rec.ne_type) AND Nm3net.is_gty_partial(pi_gty => l_ngt_rec.ngt_group_type) = 'N' AND pi_split_at_node_id IS NULL THEN
      --
      -- we need to make sure that since we will inherit all datum element
      -- properties that the ne_unique would be re-generated to be unique
      --
      IF NOT Nm3net.ne_unique_could_be_derived(pi_nt_type => Nm3net.get_datum_nt (pi_ne_id => l_ne_rec.ne_id)) THEN
            Hig.raise_ner (pi_appl    => Nm3type.c_net
                          ,pi_id      => 361 -- Group cannot be split
                          ,pi_supplementary_info => CHR(10)||'Not possible to derive unique ID of resulting datums.');
         END IF;
         RETURN(TRUE);
    ELSE
         RETURN(FALSE);
    END IF;

    Nm_Debug.proc_end(g_package_name,'datum_split_required');

END datum_split_required;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_lref_at_node(pi_node_id         IN nm_nodes.no_node_id%TYPE
                         ,pi_ne_id_in        IN nm_members.nm_ne_id_in%TYPE
                         ,pi_before_or_after IN VARCHAR2) RETURN nm_lref IS



  CURSOR c1 IS
  SELECT nm_lref (n.nnu_ne_id, n.nnu_chain) lref
    FROM nm_node_usages n
       , nm_members m
   WHERE n.nnu_no_node_id = pi_node_id
     AND nnu_ne_id = nm_ne_id_of
     AND m.nm_ne_id_in = pi_ne_id_in
     AND Nm3net.route_direction (n.nnu_node_type, m.nm_cardinality)= DECODE(UPPER(pi_before_or_after),'B',-1,+1);

   l_supplmentary_info VARCHAR2(200);
   l_retval nm_lref;

BEGIN

  FOR recs IN c1 LOOP

   l_retval := recs.lref;
  END LOOP;

  RETURN(l_retval);

END get_lref_at_node;
--
------------------------------------------------------------------------------------------------
--
FUNCTION does_node_exist (pi_node_id  IN  nm_nodes.no_node_id%TYPE) 
RETURN BOOLEAN
IS
--
CURSOR node_cur(p_node_id  IN  nm_nodes.no_node_id%TYPE) IS
SELECT 'X'
-- CWS 0108841 Check was not looking a other tables that needed to be populated.
-- This caused a SELF NULL error when splitting a route.
/*  FROM nm_nodes
 WHERE no_node_id = p_node_id;*/
  FROM nm_node_usages n
     , nm_members m
     , nm_nodes
 WHERE n.nnu_no_node_id = pi_node_id
   AND nnu_ne_id = nm_ne_id_of
   AND no_node_id = n.nnu_no_node_id;

--
  l_dummy VARCHAR2(1) := 'Y';
  l_return_val BOOLEAN;
--
BEGIN
  OPEN node_cur(p_node_id => pi_node_id);
  FETCH node_cur INTO l_dummy;
  l_return_val:= ( l_dummy = 'X' );
  CLOSE node_cur;
  RETURN l_return_val;
END;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE get_route_split_memberships(pi_route_ne_id             IN     nm_elements.ne_id%TYPE
                                     ,pi_non_ambig_ne_id         IN     nm_elements.ne_id%TYPE
                                     ,pi_non_ambig_split_offset  IN     NUMBER
                                     ,pi_node_id                 IN     nm_nodes.no_node_id%TYPE
                                     ,po_placement_array_left    IN OUT nm_placement_array
                                     ,po_placement_array_right   IN OUT nm_placement_array) IS


 l_non_ambig_split_point_lref    nm_lref;  -- nm_lref is an object type
 l_node_split_point_lref1        nm_lref;  -- nm_lref is an object type
 l_node_split_point_lref2        nm_lref;  -- nm_lref is an object type

 l_non_ambig_route_start_lref   nm_lref;  -- nm_lref is an object type
 l_non_ambig_route_end_lref     nm_lref;  -- nm_lref is an object type

--
-- Task 0110269
-- Split fails if no node at the split point
--
  l_lref_1  nm_lref;
  l_lref_2  nm_lref;
--
  CURSOR get_new_split_pts ( c_old_ne IN NUMBER
                           , c_route  IN NUMBER ) IS
    WITH elem_hist AS
           (SELECT nm_cardinality
                 , neh.*
              FROM nm_members
                 , nm_element_history neh
             WHERE neh_ne_id_old = c_old_ne
               AND nm_ne_id_of = neh_ne_id_new
               AND nm_ne_id_in = c_route)
    SELECT CASE nm_cardinality
             WHEN 1
             THEN
               ( SELECT nm_lref ( neh_ne_id_new
                                , neh_new_ne_length )
                   FROM elem_hist
                  WHERE neh_param_1 = 1 )
             ELSE
               ( SELECT nm_lref ( neh_ne_id_new
                                , 0 )
                   FROM elem_hist
                  WHERE neh_param_1 = 2 )
           END
             start_lref
         , CASE nm_cardinality
             WHEN 1
             THEN
               ( SELECT nm_lref ( neh_ne_id_new
                                , 0 )
                   FROM elem_hist
                  WHERE neh_param_1 = 2 )
             ELSE
               ( SELECT nm_lref ( neh_ne_id_new
                                , neh_new_ne_length )
                   FROM elem_hist
                  WHERE neh_param_1 = 1 )
           END
             end_lref
      FROM elem_hist
     WHERE ROWNUM = 1;
--
BEGIN

 -- Pre-Requisites for this working
 --
 -- a) Split point must be non-ambiguous       (checked for in validate_split_position)
 -- b) Route start point must be non-ambiguous (checked for in validate_element_can_be_split)
 -- c) Route end point must be non-ambiguous   (checked for in validate_element_can_be_split)
 --
 l_non_ambig_route_start_lref   := Nm3lrs.get_distinct_offset(nm_lref(pi_route_ne_id,Nm3net.get_min_slk(pi_ne_id => pi_route_ne_id)));  -- linear ref that denotes the non-ambiguous start of route

 l_non_ambig_route_end_lref     := Nm3lrs.get_distinct_offset(nm_lref(pi_route_ne_id,Nm3net.get_max_slk(pi_route_ne_id)));  -- linear ref that denotes the non-ambiguous end of route

 IF does_node_exist (pi_node_id  => pi_node_id) THEN


       --Getting before lref for node split point
       l_node_split_point_lref1 :=   get_lref_at_node(pi_node_id         => pi_node_id
                                                     ,pi_ne_id_in        => pi_route_ne_id
                                                     ,pi_before_or_after => 'B');


       --Getting after lref for node split point
       l_node_split_point_lref2 :=   get_lref_at_node(pi_node_id         => pi_node_id
                                                     ,pi_ne_id_in        => pi_route_ne_id
                                                     ,pi_before_or_after => 'A');


    --Getting left hand placement array
    po_placement_array_left :=  Nm3pla.get_connected_extent(l_non_ambig_route_start_lref  -- from start of route
                                                           ,l_node_split_point_lref1  -- to lref at node to the right
                                                           ,pi_route_ne_id -- along route
                                                           ,NULL);


    --Getting right hand placement array'
    po_placement_array_right :=  Nm3pla.get_connected_extent(l_node_split_point_lref2  -- from lref at node to the right
                                                            ,l_non_ambig_route_end_lref  -- to end of route
                                                            ,pi_route_ne_id -- along route
                                                            ,NULL);


 ELSE

--  nm_debug.debug_on;
--  nm_debug.debug('#SPLIT : Node does not exist');
--  nm_debug.debug('#SPLIT : pi_non_ambig_ne_id '||pi_non_ambig_ne_id);
--  nm_debug.debug('#SPLIT : pi_route_ne_id '||pi_route_ne_id);

  --Getting lref for split point
  l_non_ambig_split_point_lref   := nm_lref(pi_non_ambig_ne_id, pi_non_ambig_split_offset);   -- linear ref that denotes the non-ambiguous split point
--
  IF nm3get.get_ne ( pi_ne_id           => l_non_ambig_split_point_lref.lr_ne_id
                   , pi_raise_not_found => FALSE).ne_id IS NULL
  THEN
  --
  -- End-dated lref returned
  --
--    nm_debug.debug('#SPLIT : End-dated - use new code');
    OPEN get_new_split_pts ( pi_non_ambig_ne_id, pi_route_ne_id );
    FETCH get_new_split_pts INTO l_lref_1, l_lref_2;
    CLOSE get_new_split_pts;
  ELSE
--    nm_debug.debug('#SPLIT : NOT End-dated - use old code'); 
    l_lref_1 := l_non_ambig_split_point_lref;
    l_lref_2 := l_non_ambig_split_point_lref;
  END IF;
--
--  nm_debug.debug('#SPLIT : l_non_ambig_split_point_lref = '||l_non_ambig_split_point_lref.lr_ne_id||' - '||l_non_ambig_split_point_lref.lr_offset);
--  nm_debug.debug('#SPLIT : l_lref_1 = '||l_lref_1.lr_ne_id||' - '||l_lref_1.lr_offset);
--  nm_debug.debug('#SPLIT : l_non_ambig_route_start_lref= '||l_non_ambig_route_start_lref.lr_ne_id||' - '||l_non_ambig_route_start_lref.lr_offset);
--  nm_debug.debug('#SPLIT : l_lref_2 = '||l_lref_2.lr_ne_id||' - '||l_lref_2.lr_offset);
--
   po_placement_array_left :=  Nm3pla.get_connected_extent(l_non_ambig_route_start_lref   -- from start of route
                                                          ,l_lref_1                       --l_non_ambig_split_point_lref  -- to split point
                                                          ,pi_route_ne_id                 -- along route
                                                          ,NULL);

   po_placement_array_right :=  Nm3pla.get_connected_extent(l_lref_2                      --l_non_ambig_split_point_lref  -- to split point
                                                           ,l_non_ambig_route_end_lref    -- to end of route
                                                           ,pi_route_ne_id                -- along route
                                                           ,NULL);


 END IF;

END get_route_split_memberships;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE split_group_memberships(pi_route_ne_id             IN  nm_elements.ne_id%TYPE  -- the ne_id of original route
                                 ,pi_ne_id_1                 IN  nm_elements.ne_id%TYPE  -- the new element ne_id
                                 ,pi_ne_id_2                 IN  nm_elements.ne_id%TYPE  -- the 2nd new element ne_id
                                 ,pi_effective_date          IN     DATE
                                 ,pi_non_ambig_ne_id         IN     nm_elements.ne_id%TYPE
                                 ,pi_non_ambig_split_offset  IN     NUMBER
                                 ,pi_node_id                 IN  nm_nodes.no_node_id%TYPE) IS

  l_placement_array_left    nm_placement_array;
  l_placement_array_right   nm_placement_array;

  r_nm_members              nm_members%ROWTYPE;

--
--
  PROCEDURE end_date_existing_in_members IS

  BEGIN
    UPDATE nm_members
    SET    nm_end_date = pi_effective_date
    WHERE  nm_ne_id_in = pi_route_ne_id;
  END end_date_existing_in_members;
--
--
  PROCEDURE end_date_existing_of_members IS

  BEGIN
    UPDATE nm_members
    SET    nm_end_date = pi_effective_date
    WHERE  nm_ne_id_of = pi_route_ne_id;
  END end_date_existing_of_members;
--
--
  FUNCTION get_nm_members_constants(pi_nm_ne_id_in IN nm_members.nm_ne_id_in%TYPE) RETURN nm_members%ROWTYPE IS

    CURSOR c1 IS
    SELECT *
    FROM   nm_members
    WHERE  nm_ne_id_in = pi_nm_ne_id_in;

    l_retval c1%ROWTYPE;

  BEGIN

    OPEN c1;
    FETCH c1 INTO l_retval;
    CLOSE c1;

    RETURN(l_retval);

  END get_nm_members_constants;
--
--
  PROCEDURE create_new_route_memberships(pi_ne_id             IN nm_elements.ne_id%TYPE
                                        ,pi_placement_array   IN nm_placement_array) IS


    CURSOR c_memb1 IS
    SELECT  pi_route_ne_id                  nm_ne_id_in
          , pl.pl_ne_id                     nm_ne_id_of
          , pl.pl_start                     nm_begin_mp
          , pl.pl_end                       nm_end_mp
          , pl.pl_measure                   nm_slk
    FROM TABLE ( pi_placement_array.npa_placement_array ) pl;

    CURSOR c_memb2 IS
    SELECT  *
    FROM nm_members
    WHERE nm_ne_id_of = pi_route_ne_id;

  BEGIN

    FOR i IN c_memb1 LOOP


     INSERT INTO NM_MEMBERS_ALL  ( nm_ne_id_in
                                  ,nm_ne_id_of
                                  ,nm_type
                                  ,nm_obj_type
                                  ,nm_begin_mp
                                  ,nm_start_date
                                  ,nm_end_date
                                  ,nm_end_mp
                                  ,nm_slk
                                  ,nm_cardinality
                                  ,nm_admin_unit)
     VALUES  ( pi_ne_id                   -- ne_id of new element
              ,i.nm_ne_id_of
              ,r_nm_members.nm_type       -- use same value as was on previous membership
              ,r_nm_members.nm_obj_type   -- use same value as was on previous membership
              ,i.nm_begin_mp
              ,pi_effective_date
              ,NULL
              ,i.nm_end_mp
              ,i.nm_slk
              ,r_nm_members.nm_cardinality   -- use same value as was on previous membership
              ,r_nm_members.nm_admin_unit);	 -- use same value as was on previous membership

  END LOOP;

--nm_debug.debug('setting up memberships of groups of groups based on the membership of the original element');
  -- set up memberships of groups of groups based on the membership of the original element
  FOR i IN c_memb2 LOOP


--   nm_debug.debug('nm_ne_id_in='||i.nm_ne_id_in);
--   nm_debug.debug('nm_ne_id_of='||pi_ne_id);
--   nm_debug.debug('nm_type='||i.nm_type);
--   nm_debug.debug('nm_obj_type='||i.nm_obj_type);
--   nm_debug.debug('nm_begin_mp='||i.nm_begin_mp);
--   nm_debug.debug('nm_start_date='||pi_effective_date);
--   nm_debug.debug('nm_end_date='||i.nm_end_date);
--   nm_debug.debug('nm_end_mp='||i.nm_begin_mp);
--   nm_debug.debug('nm_cardinality='||i.nm_cardinality);
--   nm_debug.debug('nm_admin_unit='||i.nm_admin_unit);

     INSERT INTO nm_members_all(nm_ne_id_in
                           ,nm_ne_id_of
                           ,nm_type
                           ,nm_obj_type
                           ,nm_begin_mp
                           ,nm_start_date
                           ,nm_end_date
                           ,nm_end_mp
                           ,nm_cardinality
                           ,nm_admin_unit)
      VALUES(i.nm_ne_id_in
            ,pi_ne_id
            ,i.nm_type
            ,i.nm_obj_type
            ,i.nm_begin_mp
            ,pi_effective_date
            ,i.nm_end_date
            ,i.nm_begin_mp
            ,i.nm_cardinality
            ,i.nm_admin_unit);

  END LOOP;

  END create_new_route_memberships;

BEGIN

 ---------------------------------------------------
 -- get placement array of original group memberships
 ----------------------------------------------------
 -- Determining existing group memberships.');
 get_route_split_memberships(pi_route_ne_id             => pi_route_ne_id
                            ,pi_non_ambig_ne_id         => pi_non_ambig_ne_id
                            ,pi_non_ambig_split_offset  => pi_non_ambig_split_offset
                            ,pi_node_id                 => pi_node_id
                            ,po_placement_array_left    => l_placement_array_left
                            ,po_placement_array_right   => l_placement_array_right);

 --
 -- get some constant values from that should be applied on the re-create of memberships
 --
 r_nm_members := get_nm_members_constants(pi_nm_ne_id_in => pi_route_ne_id);

 end_date_existing_in_members;

 --
 -- create memberships for first new group
 -- encapsulate elements up to the split point
 create_new_route_memberships(pi_ne_id            => pi_ne_id_1
                             ,pi_placement_array  => l_placement_array_left);

 --
 -- create memberships for second new group
 -- encapsulate elements after the split point
 create_new_route_memberships(pi_ne_id            => pi_ne_id_2
                             ,pi_placement_array  => l_placement_array_right);


 end_date_existing_of_members;

END split_group_memberships;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE do_split_group(pi_route_ne_id             IN     nm_elements.ne_id%TYPE
                        ,pi_ne_id_1                 IN OUT nm_elements.ne_id%TYPE  -- the new element ne_id
                        ,pi_ne_id_2                 IN OUT nm_elements.ne_id%TYPE  -- the 2nd new element ne_id
                        ,pi_effective_date          IN     DATE
                        ,pi_split_offset            IN     NUMBER
                        ,pi_non_ambig_ne_id         IN     nm_elements.ne_id%TYPE
                        ,pi_non_ambig_split_offset  IN     NUMBER
                        ,pi_split_at_node_id        IN     nm_nodes.no_node_id%TYPE
                        ,pi_create_node             IN     BOOLEAN DEFAULT FALSE
                        ,pi_node_id                 IN OUT nm_nodes.no_node_id%TYPE
                        ,pi_no_np_id                IN OUT nm_nodes.no_np_id%TYPE
                        ,pi_no_node_name            IN     nm_nodes.no_node_name%TYPE         DEFAULT NULL
                        ,pi_no_descr                IN     nm_nodes.no_descr%TYPE             DEFAULT NULL
                        ,pi_no_node_type            IN     nm_nodes.no_node_type%TYPE         DEFAULT NULL
                        ,pi_np_grid_east            IN     NM_POINTS.np_grid_east%TYPE        DEFAULT NULL
                        ,pi_np_grid_north           IN     NM_POINTS.np_grid_north%TYPE       DEFAULT NULL
                        ,pi_no_purpose              in     nm_nodes.no_purpose%type           DEFAULT NULL -- PT 03.06.08
                        ,pi_ne_unique_1             IN     nm_elements.ne_unique%TYPE         DEFAULT NULL
                        ,pi_ne_type_1               IN     nm_elements.ne_type%TYPE           DEFAULT NULL
                        ,pi_ne_nt_type_1            IN     nm_elements.ne_nt_type%TYPE        DEFAULT NULL
                        ,pi_ne_descr_1              IN     nm_elements.ne_descr%TYPE          DEFAULT NULL
                        ,pi_ne_admin_unit_1         IN     nm_elements.ne_admin_unit%TYPE     DEFAULT NULL
                        ,pi_ne_gty_group_type_1     IN     nm_elements.ne_gty_group_type%TYPE DEFAULT NULL
                        ,pi_ne_owner_1              IN     nm_elements.ne_owner%TYPE          DEFAULT NULL
                        ,pi_ne_name_1_1             IN     nm_elements.ne_name_1%TYPE         DEFAULT NULL
                        ,pi_ne_name_2_1             IN     nm_elements.ne_name_2%TYPE         DEFAULT NULL
                        ,pi_ne_prefix_1             IN     nm_elements.ne_prefix%TYPE         DEFAULT NULL
                        ,pi_ne_number_1             IN     nm_elements.ne_number%TYPE         DEFAULT NULL
                        ,pi_ne_sub_type_1           IN     nm_elements.ne_sub_type%TYPE       DEFAULT NULL
                        ,pi_ne_group_1              IN     nm_elements.ne_group%TYPE          DEFAULT NULL
                        ,pi_ne_no_start_1           IN     nm_elements.ne_no_start%TYPE       DEFAULT NULL
                        ,pi_ne_no_end_1             IN     nm_elements.ne_no_end%TYPE         DEFAULT NULL
                        ,pi_ne_sub_class_1          IN     nm_elements.ne_sub_class%TYPE      DEFAULT NULL
                        ,pi_ne_nsg_ref_1            IN     nm_elements.ne_nsg_ref%TYPE        DEFAULT NULL
                        ,pi_ne_version_no_1         IN     nm_elements.ne_version_no%TYPE     DEFAULT NULL
                        ,pi_ne_unique_2             IN     nm_elements.ne_unique%TYPE         DEFAULT NULL
                        ,pi_ne_type_2               IN     nm_elements.ne_type%TYPE           DEFAULT NULL
                        ,pi_ne_nt_type_2            IN     nm_elements.ne_nt_type%TYPE        DEFAULT NULL
                        ,pi_ne_descr_2              IN     nm_elements.ne_descr%TYPE          DEFAULT NULL
                        ,pi_ne_admin_unit_2         IN     nm_elements.ne_admin_unit%TYPE     DEFAULT NULL
                        ,pi_ne_gty_group_type_2     IN     nm_elements.ne_gty_group_type%TYPE DEFAULT NULL
                        ,pi_ne_owner_2              IN     nm_elements.ne_owner%TYPE          DEFAULT NULL
                        ,pi_ne_name_1_2             IN     nm_elements.ne_name_1%TYPE         DEFAULT NULL
                        ,pi_ne_name_2_2             IN     nm_elements.ne_name_2%TYPE         DEFAULT NULL
                        ,pi_ne_prefix_2             IN     nm_elements.ne_prefix%TYPE         DEFAULT NULL
                        ,pi_ne_number_2             IN     nm_elements.ne_number%TYPE         DEFAULT NULL
                        ,pi_ne_sub_type_2           IN     nm_elements.ne_sub_type%TYPE       DEFAULT NULL
                        ,pi_ne_group_2              IN     nm_elements.ne_group%TYPE          DEFAULT NULL
                        ,pi_ne_no_start_2           IN     nm_elements.ne_no_start%TYPE       DEFAULT NULL
                        ,pi_ne_no_end_2             IN     nm_elements.ne_no_end%TYPE         DEFAULT NULL
                        ,pi_ne_sub_class_2          IN     nm_elements.ne_sub_class%TYPE      DEFAULT NULL
                        ,pi_ne_nsg_ref_2            IN     nm_elements.ne_nsg_ref%TYPE        DEFAULT NULL
                        ,pi_ne_version_no_2         IN     nm_elements.ne_version_no%TYPE     DEFAULT NULL
                        ,p_neh_descr                IN     nm_element_history.neh_descr%TYPE  DEFAULT NULL --CWS 0108990 12/03/2010
                        ) IS


  l_new_datum_ne_id_1  nm_elements.ne_id%TYPE;   -- the new element ne_id of any datum that is created
  l_new_datum_ne_id_2  nm_elements.ne_id%TYPE;   -- the 2nd new element ne_id of any datum that is created

-- to store original route memberships
  l_placement_array_left    nm_placement_array;
  l_placement_array_right   nm_placement_array;

  l_node_id                 nm_nodes.no_node_id%TYPE;


  l_errors                NUMBER;
  l_err_text              VARCHAR2(10000);


BEGIN


 IF datum_split_required(pi_ne_id            => pi_route_ne_id
                        ,pi_split_at_node_id =>  pi_split_at_node_id) THEN
          do_split  (p_ne_id                         => pi_non_ambig_ne_id
                    ,p_ne_id_1                       => l_new_datum_ne_id_1  -- the new element ne_id
                    ,p_ne_id_2                       => l_new_datum_ne_id_2  -- the 2nd new element ne_id
                    ,p_effective_date                => pi_effective_date
                    ,p_split_measure                 => pi_non_ambig_split_offset
                    ,p_node                          => pi_node_id
                    ,p_force_inheritance_of_attribs  => 'Y'
                    ,p_no_np_id                      => pi_no_np_id
                    ,p_create_node                   => pi_create_node
                    ,p_no_node_name                  => pi_no_node_name
                    ,p_no_descr                      => pi_no_descr
                    ,p_no_node_type                  => pi_no_node_type
                    ,p_np_grid_east                  => pi_np_grid_east
                    ,p_np_grid_north                 => pi_np_grid_north
                    ,p_no_purpose                    => pi_no_purpose   -- PT 03.06.08
                    ,p_neh_descr                     => p_neh_descr --CWS 0108990 12/03/2010
                    );
 END IF;


  -----------------------------------------------------------------------------------------------------------
  -- create 2 new nm_element rowtype variables based on  inherited attribs/those that are passed through from
  -----------------------------------------------------------------------------------------------------------
  g_rec_ne_old   := Nm3net.get_ne (pi_route_ne_id);  -- store the ne record of the route to be split

  l_node_id := NVL(pi_node_id,pi_split_at_node_id);  -- grab a node id if set to determine split point - otherwise offset will still be used


  split_element (p_ne_id                      => pi_route_ne_id
                ,p_type_of_split              => 'G'  -- a group split
                ,p_effective_date             => pi_effective_date
                ,p_ne_id_1                    => pi_ne_id_1
                ,p_ne_length_1                => NULL
                ,p_ne_id_2                    => pi_ne_id_2
                ,p_ne_length_2                => NULL
                ,p_node                       => l_node_id
                ,p_force_inheritance_of_attribs => 'N'
                ,p_ne_unique_1                => pi_ne_unique_1
                ,p_ne_type_1                  => pi_ne_type_1
                ,p_ne_nt_type_1               => pi_ne_nt_type_1
                ,p_ne_descr_1                 => pi_ne_descr_1
                ,p_ne_admin_unit_1            => pi_ne_admin_unit_1
                ,p_ne_gty_group_type_1        => pi_ne_gty_group_type_1
                ,p_ne_owner_1                 => pi_ne_owner_1
                ,p_ne_name_1_1                => pi_ne_name_1_1
                ,p_ne_name_2_1                => pi_ne_name_2_1
                ,p_ne_prefix_1                => pi_ne_prefix_1
                ,p_ne_number_1                => pi_ne_number_1
                ,p_ne_sub_type_1              => pi_ne_sub_type_1
                ,p_ne_group_1                 => pi_ne_group_1
                ,p_ne_no_start_1              => pi_ne_no_start_1
                ,p_ne_no_end_1                => pi_ne_no_end_1
                ,p_ne_sub_class_1             => pi_ne_sub_class_1
                ,p_ne_nsg_ref_1               => pi_ne_nsg_ref_1
                ,p_ne_version_no_1            => pi_ne_version_no_1
                ,p_ne_unique_2                => pi_ne_unique_2
                ,p_ne_type_2                  => pi_ne_type_2
                ,p_ne_nt_type_2               => pi_ne_nt_type_2
                ,p_ne_descr_2                 => pi_ne_descr_2
                ,p_ne_admin_unit_2            => pi_ne_admin_unit_2
                ,p_ne_gty_group_type_2        => pi_ne_gty_group_type_2
                ,p_ne_owner_2                 => pi_ne_owner_2
                ,p_ne_name_1_2                => pi_ne_name_1_2
                ,p_ne_name_2_2                => pi_ne_name_2_2
                ,p_ne_prefix_2                => pi_ne_prefix_2
                ,p_ne_number_2                => pi_ne_number_2
                ,p_ne_sub_type_2              => pi_ne_sub_type_2
                ,p_ne_group_2                 => pi_ne_group_2
                ,p_ne_no_start_2              => pi_ne_no_start_2
                ,p_ne_no_end_2                => pi_ne_no_end_2
                ,p_ne_sub_class_2             => pi_ne_sub_class_2
                ,p_ne_nsg_ref_2               => pi_ne_nsg_ref_2
                ,p_ne_version_no_2            => pi_ne_version_no_2
                ,p_neh_descr                  => p_neh_descr --CWS 0108990 12/03/2010
                );


  ----------------------------------------------
  -- end date original memberships for the group
  ----------------------------------------------
  split_group_memberships(pi_route_ne_id             => pi_route_ne_id
                         ,pi_ne_id_1                 => pi_ne_id_1
                         ,pi_ne_id_2                 => pi_ne_id_2
                         ,pi_effective_date          => pi_effective_date
                         ,pi_non_ambig_ne_id         => pi_non_ambig_ne_id
                         ,pi_non_ambig_split_offset  => pi_non_ambig_split_offset
                         ,pi_node_id                 => l_node_id);


  -------------------------------------
  -- End Date Shape of Original Element
  -------------------------------------
  Nm3sdm.reshape_route(pi_ne_id          => pi_route_ne_id
                     , pi_effective_date => pi_effective_date
                     , pi_use_history    => 'Y');


  -----------------------------------------
  -- Split other products e.g. move defects
  -----------------------------------------
   split_other_products (p_ne_id          => pi_route_ne_id
                        ,p_ne_id_1        => pi_ne_id_1
                        ,p_ne_id_2        => pi_ne_id_2
                        ,p_split_measure  => pi_split_offset
                        ,p_effective_date => pi_effective_date
                        );

  -- moving any network AD associated with the original element

   IF Nm3nwad.ad_data_exist(pi_route_ne_id) THEN

      Nm3nwad.do_ad_split( pi_old_ne_id  => pi_route_ne_id
                         , pi_new_ne_id1 => pi_ne_id_1
                         , pi_new_ne_id2 => pi_ne_id_2);

   END IF;


  --End dating original group
  end_date_elements (p_ne_id          => pi_route_ne_id
                    ,p_effective_date => pi_effective_date);


  --Rescaling New Group 1
  Nm3rsc.rescale_route(pi_ne_id          => pi_ne_id_1
                      ,pi_effective_date => pi_effective_date
                      ,pi_offset_st      => 0
                      ,pi_st_element_id  => NULL
                      ,pi_use_history    => 'N'
                      ,pi_ne_start       => NULL);


  --Rescaling New Group 2
  Nm3rsc.rescale_route(pi_ne_id          => pi_ne_id_2
                      ,pi_effective_date => pi_effective_date
                      ,pi_offset_st      => 0
                      ,pi_st_element_id  => NULL
                      ,pi_use_history    => 'N'
                      ,pi_ne_start       => NULL);

END do_split_group;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE do_split_datum_or_group ( pi_ne_id                  IN     nm_elements.ne_id%TYPE -- the element to split
                                   ,pi_ne_type                IN     nm_elements.ne_type%TYPE -- ne_type of element to be split
                                   ,pi_ne_id_1                IN OUT nm_elements.ne_id%TYPE  -- the new element ne_id
                                   ,pi_ne_id_2                IN OUT nm_elements.ne_id%TYPE  -- the 2nd new element ne_id
                                   ,pi_effective_date         IN     DATE DEFAULT  Nm3user.get_effective_date-- the date the split is effective from
                                   ,pi_split_offset           IN     NUMBER
                                   ,pi_non_ambig_ne_id        IN     nm_elements.ne_id%TYPE    -- only applicable when splitting a group
                                   ,pi_non_ambig_split_offset IN     NUMBER                    -- only applicable when splitting a group
                                   ,pi_split_at_node_id       IN     nm_nodes.no_node_id%TYPE  -- only applicable when splitting a group

                                   ,pi_create_node            IN     BOOLEAN DEFAULT FALSE
                                   ,pi_node_id                IN OUT nm_elements.ne_no_start%TYPE -- the node CREATED at the split point
                                   ,pi_no_node_name           IN     nm_nodes.no_node_name%TYPE DEFAULT NULL
                                   ,pi_no_descr               IN     nm_nodes.no_descr%TYPE DEFAULT NULL
                                   ,pi_np_grid_east           IN     NM_POINTS.np_grid_east%TYPE DEFAULT NULL
                                   ,pi_np_grid_north          IN     NM_POINTS.np_grid_north%TYPE DEFAULT NULL
                                   ,pi_no_np_id               IN OUT nm_nodes.no_np_id%TYPE
                                   ,pi_no_purpose             in     nm_nodes.no_purpose%type default null -- PT 03.06.08

                                   ,pi_ne_unique_1            IN     nm_elements.ne_unique%TYPE DEFAULT NULL  -- specified attributes for element 1
                                   ,pi_ne_type_1              IN     nm_elements.ne_type%TYPE DEFAULT NULL
                                   ,pi_ne_nt_type_1           IN     nm_elements.ne_nt_type%TYPE DEFAULT NULL
                                   ,pi_ne_descr_1             IN     nm_elements.ne_descr%TYPE DEFAULT NULL
                                   ,pi_ne_length_1            IN     nm_elements.ne_length%TYPE DEFAULT NULL
                                   ,pi_ne_admin_unit_1        IN     nm_elements.ne_admin_unit%TYPE DEFAULT NULL
                                   ,pi_ne_gty_group_type_1    IN     nm_elements.ne_gty_group_type%TYPE DEFAULT NULL
                                   ,pi_ne_owner_1             IN     nm_elements.ne_owner%TYPE DEFAULT NULL
                                   ,pi_ne_name_1_1            IN     nm_elements.ne_name_1%TYPE DEFAULT NULL
                                   ,pi_ne_name_2_1            IN     nm_elements.ne_name_2%TYPE DEFAULT NULL
                                   ,pi_ne_prefix_1            IN     nm_elements.ne_prefix%TYPE DEFAULT NULL
                                   ,pi_ne_number_1            IN     nm_elements.ne_number%TYPE DEFAULT NULL
                                   ,pi_ne_sub_type_1          IN     nm_elements.ne_sub_type%TYPE DEFAULT NULL
                                   ,pi_ne_group_1             IN     nm_elements.ne_group%TYPE DEFAULT NULL
                                   ,pi_ne_no_start_1          IN     nm_elements.ne_no_start%TYPE DEFAULT NULL
                                   ,pi_ne_no_end_1            IN     nm_elements.ne_no_end%TYPE DEFAULT NULL
                                   ,pi_ne_sub_class_1         IN     nm_elements.ne_sub_class%TYPE DEFAULT NULL
                                   ,pi_ne_nsg_ref_1           IN     nm_elements.ne_nsg_ref%TYPE DEFAULT NULL
                                   ,pi_ne_version_no_1        IN     nm_elements.ne_version_no%TYPE DEFAULT NULL

                                   ,pi_ne_unique_2            IN     nm_elements.ne_unique%TYPE DEFAULT NULL  -- specified attributes for element 1
                                   ,pi_ne_type_2              IN     nm_elements.ne_type%TYPE DEFAULT NULL
                                   ,pi_ne_nt_type_2           IN     nm_elements.ne_nt_type%TYPE DEFAULT NULL
                                   ,pi_ne_descr_2             IN     nm_elements.ne_descr%TYPE DEFAULT NULL
                                   ,pi_ne_length_2            IN     nm_elements.ne_length%TYPE DEFAULT NULL
                                   ,pi_ne_admin_unit_2        IN     nm_elements.ne_admin_unit%TYPE DEFAULT NULL
                                   ,pi_ne_gty_group_type_2    IN     nm_elements.ne_gty_group_type%TYPE DEFAULT NULL
                                   ,pi_ne_owner_2             IN     nm_elements.ne_owner%TYPE DEFAULT NULL
                                   ,pi_ne_name_1_2            IN     nm_elements.ne_name_1%TYPE DEFAULT NULL
                                   ,pi_ne_name_2_2            IN     nm_elements.ne_name_2%TYPE DEFAULT NULL
                                   ,pi_ne_prefix_2            IN     nm_elements.ne_prefix%TYPE DEFAULT NULL
                                   ,pi_ne_number_2            IN     nm_elements.ne_number%TYPE DEFAULT NULL
                                   ,pi_ne_sub_type_2          IN     nm_elements.ne_sub_type%TYPE DEFAULT NULL
                                   ,pi_ne_group_2             IN     nm_elements.ne_group%TYPE DEFAULT NULL
                                   ,pi_ne_no_start_2          IN     nm_elements.ne_no_start%TYPE DEFAULT NULL
                                   ,pi_ne_no_end_2            IN     nm_elements.ne_no_end%TYPE DEFAULT NULL
                                   ,pi_ne_sub_class_2         IN     nm_elements.ne_sub_class%TYPE DEFAULT NULL
                                   ,pi_ne_nsg_ref_2           IN     nm_elements.ne_nsg_ref%TYPE DEFAULT NULL
                                   ,pi_ne_version_no_2        IN     nm_elements.ne_version_no%TYPE DEFAULT NULL
                                   ,pi_neh_descr              IN     nm_element_history.neh_descr%TYPE DEFAULT NULL --CWS 0108990 12/03/2010
                                   ) IS


 l_datum_nt     nm_types.nt_type%TYPE       := Nm3net.get_datum_nt(pi_ne_id => pi_ne_id);
 l_no_node_type nm_node_types.nnt_type%TYPE := Nm3net.get_nt(pi_nt_type => l_datum_nt).nt_node_type;
 l_effective_date DATE := TRUNC(pi_effective_date);

 l_length  number;


BEGIN
  Nm_Debug.proc_start(g_package_name,'do_split_datum_or_group');
--

  if pi_split_offset is null and pi_np_grid_east is not null and pi_np_grid_north is not null then

    l_length := SDO_LRS.FIND_MEASURE(NM3SDO.GET_LAYER_ELEMENT_GEOMETRY(pi_ne_id), nm3sdo.get_2d_pt(pi_np_grid_east, pi_np_grid_north), 0.005 );

  else
    l_length := pi_split_offset;

  end if;

   check_element_can_be_split(pi_effective_date => pi_effective_date);
--
   validate_split_position (pi_ne_id            => pi_ne_id
                           ,pi_split_offset     => l_length --pi_split_offset
                           ,pi_split_at_node    => pi_split_at_node_id
                           ,pi_non_ambig_ne_id  => pi_non_ambig_ne_id
                           ,pi_non_ambig_split_offset => pi_non_ambig_split_offset
                           ,pi_effective_date   => pi_effective_date);
--
   Nm3lock.lock_element_and_members (pi_ne_id);
--
   set_for_split;

 IF Nm3net.element_is_a_datum(pi_ne_type => pi_ne_type) THEN
            do_split(p_ne_id               => pi_ne_id
                    ,p_effective_date      => l_effective_date
                    ,p_split_measure       => l_length --pi_split_offset
                    ,p_ne_id_1             => pi_ne_id_1
                    ,p_ne_id_2             => pi_ne_id_2
                    ,p_node                => pi_node_id
                    ,p_create_node         => pi_create_node
                    ,p_no_node_name        => pi_no_node_name
                    ,p_no_descr            => pi_no_descr
                    ,p_no_node_type        => l_no_node_type
                    ,p_no_np_id            => pi_no_np_id
                    ,p_np_grid_east        => pi_np_grid_east
                    ,p_np_grid_north       => pi_np_grid_north
                    ,p_no_purpose          => pi_no_purpose     -- PT 03.06.08
                    ,p_ne_unique_1         => pi_ne_unique_1
                    ,p_ne_type_1           => pi_ne_type_1
                    ,p_ne_nt_type_1        => pi_ne_nt_type_1
                    ,p_ne_descr_1          => pi_ne_descr_1
                    ,p_ne_length_1         => pi_ne_length_1
                    ,p_ne_admin_unit_1     => pi_ne_admin_unit_1
                    ,p_ne_gty_group_type_1 => pi_ne_gty_group_type_1
                    ,p_ne_owner_1          => pi_ne_owner_1
                    ,p_ne_name_1_1         => pi_ne_name_1_1
                    ,p_ne_name_2_1         => pi_ne_name_2_1
                    ,p_ne_prefix_1         => pi_ne_prefix_1
                    ,p_ne_number_1         => pi_ne_number_1
                    ,p_ne_sub_type_1       => pi_ne_sub_type_1
                    ,p_ne_group_1          => pi_ne_group_1
                    ,p_ne_no_start_1       => pi_ne_no_start_1
                    ,p_ne_no_end_1         => pi_ne_no_end_1
                    ,p_ne_sub_class_1      => pi_ne_sub_class_1
                    ,p_ne_nsg_ref_1        => pi_ne_nsg_ref_1
                    ,p_ne_version_no_1     => pi_ne_version_no_1
                    ,p_ne_unique_2         => pi_ne_unique_2
                    ,p_ne_type_2           => pi_ne_type_2
                    ,p_ne_nt_type_2        => pi_ne_nt_type_2
                    ,p_ne_descr_2          => pi_ne_descr_2
                    ,p_ne_length_2         => pi_ne_length_2
                    ,p_ne_admin_unit_2     => pi_ne_admin_unit_2
                    ,p_ne_gty_group_type_2 => pi_ne_gty_group_type_2
                    ,p_ne_owner_2          => pi_ne_owner_2
                    ,p_ne_name_1_2         => pi_ne_name_1_2
                    ,p_ne_name_2_2         => pi_ne_name_2_2
                    ,p_ne_prefix_2         => pi_ne_prefix_2
                    ,p_ne_number_2         => pi_ne_number_2
                    ,p_ne_sub_type_2       => pi_ne_sub_type_2
                    ,p_ne_group_2          => pi_ne_group_2
                    ,p_ne_no_start_2       => pi_ne_no_start_2
                    ,p_ne_no_end_2         => pi_ne_no_end_2
                    ,p_ne_sub_class_2      => pi_ne_sub_class_2
                    ,p_ne_nsg_ref_2        => pi_ne_nsg_ref_2
                    ,p_ne_version_no_2     => pi_ne_version_no_2
                    ,p_neh_descr           => pi_neh_descr --CWS 0108990 12/03/2010
                    );
 ELSE -- assume this is a group split - checked for in do_split_group anyway
          do_split_group(pi_route_ne_id             => pi_ne_id
                        ,pi_ne_id_1                 => pi_ne_id_1
                        ,pi_ne_id_2                 => pi_ne_id_2
                        ,pi_split_offset            => pi_split_offset
                        ,pi_non_ambig_ne_id         => pi_non_ambig_ne_id
                        ,pi_non_ambig_split_offset  => pi_non_ambig_split_offset
                        ,pi_split_at_node_id        => pi_split_at_node_id
                        ,pi_effective_date          => l_effective_date
                        ,pi_create_node             => pi_create_node
                        ,pi_node_id                 => pi_node_id
                        ,pi_no_np_id                => pi_no_np_id
                        ,pi_no_node_name            => pi_no_node_name
                        ,pi_no_descr                => pi_no_descr
                        ,pi_no_node_type            => l_no_node_type
                        ,pi_np_grid_east            => pi_np_grid_east
                        ,pi_np_grid_north           => pi_np_grid_north
                        ,pi_no_purpose              => pi_no_purpose     -- PT 03.06.08
                        ,pi_ne_unique_1             => pi_ne_unique_1
                        ,pi_ne_type_1               => pi_ne_type_1
                        ,pi_ne_nt_type_1            => pi_ne_nt_type_1
                        ,pi_ne_descr_1              => pi_ne_descr_1
                        ,pi_ne_admin_unit_1         => pi_ne_admin_unit_1
                        ,pi_ne_gty_group_type_1     => pi_ne_gty_group_type_1
                        ,pi_ne_owner_1              => pi_ne_owner_1
                        ,pi_ne_name_1_1             => pi_ne_name_1_1
                        ,pi_ne_name_2_1             => pi_ne_name_2_1
                        ,pi_ne_prefix_1             => pi_ne_prefix_1
                        ,pi_ne_number_1             => pi_ne_number_1
                        ,pi_ne_sub_type_1           => pi_ne_sub_type_1
                        ,pi_ne_group_1              => pi_ne_group_1
                        ,pi_ne_no_start_1           => pi_ne_no_start_1
                        ,pi_ne_no_end_1             => pi_ne_no_end_1
                        ,pi_ne_sub_class_1          => pi_ne_sub_class_1
                        ,pi_ne_nsg_ref_1            => pi_ne_nsg_ref_1
                        ,pi_ne_version_no_1         => pi_ne_version_no_1
                        ,pi_ne_unique_2             => pi_ne_unique_2
                        ,pi_ne_type_2               => pi_ne_type_2
                        ,pi_ne_nt_type_2            => pi_ne_nt_type_2
                        ,pi_ne_descr_2              => pi_ne_descr_2
                        ,pi_ne_admin_unit_2         => pi_ne_admin_unit_2
                        ,pi_ne_gty_group_type_2     => pi_ne_gty_group_type_2
                        ,pi_ne_owner_2              => pi_ne_owner_2
                        ,pi_ne_name_1_2             => pi_ne_name_1_2
                        ,pi_ne_name_2_2             => pi_ne_name_2_2
                        ,pi_ne_prefix_2             => pi_ne_prefix_2
                        ,pi_ne_number_2             => pi_ne_number_2
                        ,pi_ne_sub_type_2           => pi_ne_sub_type_2
                        ,pi_ne_group_2              => pi_ne_group_2
                        ,pi_ne_no_start_2           => pi_ne_no_start_2
                        ,pi_ne_no_end_2             => pi_ne_no_end_2
                        ,pi_ne_sub_class_2          => pi_ne_sub_class_2
                        ,pi_ne_nsg_ref_2            => pi_ne_nsg_ref_2
                        ,pi_ne_version_no_2         => pi_ne_version_no_2
                        ,p_neh_descr                => pi_neh_descr --CWS 0108990 12/03/2010
                        );

 END IF;

 set_for_return;

 Nm_Debug.proc_end(g_package_name,'do_split_datum_or_group');
/*
EXCEPTION
  WHEN OTHERS THEN
     set_for_return;
     ROLLBACK;
     RAISE;
*/
END do_split_datum_or_group;
--
------------------------------------------------------------------------------------------------
--

END Nm3split;
/
