CREATE OR REPLACE PACKAGE BODY nm3wrap AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3wrap.pkb-arc   2.2   Jul 04 2013 16:38:44   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3wrap.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:38:44  $
--       Date fetched Out : $Modtime:   Jul 04 2013 16:37:54  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.19
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--   Author : Kevin Angus
--
--     nm3wrap package. Contains functions + procedures for accessing packages that use object
--                      features in their spec. Client tools such as Forms cannot access these
--                      directly.
--
--
------------------------------------------------------------------------------------------------
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '$Revision:   2.2  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3wrap';
--
   g_pl       nm_placement_array;
--
   g_lref_tab nm3lrs.lref_table;
--
   g_wrap_exception EXCEPTION;
   g_wrap_exc_code  number;
   g_wrap_exc_msg   varchar2(2000);

function check_for_nodes ( pi_parent_id IN  nm_members.nm_ne_id_in%TYPE
                                            ,pi_parent_units in integer
                                            ,pi_datum_units  in integer
                                            ,pi_lref_tab in nm3lrs.lref_table
                                            ,pi_position in varchar2 default null) return nm3lrs.lref_table;

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
FUNCTION pop_sub_placement_array(pi_ne_id IN nm_elements.ne_id%TYPE
                                ,pi_start IN nm_elements.ne_no_start%TYPE
						                    ,pi_end   IN nm_elements.ne_no_end%TYPE
						                    ) RETURN pls_integer IS

BEGIN

  g_pl := nm3pla.get_sub_placement(nm_placement(pi_ne_id
                                               ,pi_start
                                               ,pi_end
                                               ,0));
 RETURN g_pl.placement_count;

END pop_sub_placement_array;
--
------------------------------------------------------------------------------------------------
--
FUNCTION pop_super_placement_array(pi_ne_id    IN  nm_elements.ne_id%TYPE
                                  ) RETURN pls_integer IS

BEGIN

-- g_pl := nm3pla.get_super_placement(p_pl_array => nm3pla.get_placement_from_ne(p_ne_id_in => pi_ne_id)
--                                   ,p_type     => pi_nt_type);

-- RC This allows for breaks in the inventory data.

-- RC Use the version without the restriction on NT in order to allow inventory to span
-- both local and classified routes.

-- g_pl := nm3pla.get_connected_chunks( pi_ne_id, pi_nt_type );
   g_pl := nm3pla.get_connected_chunks( pi_ne_id );

  RETURN g_pl.placement_count;
END;
--
------------------------------------------------------------------------------------------------
--
FUNCTION pop_super_placement_array(pi_ne_id    IN nm_elements.ne_id%TYPE
                                  ,pi_obj_type IN nm_members.nm_obj_type%TYPE
                                  ) RETURN pls_integer IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'pop_super_placement_array');

  g_pl := nm3pla.get_connected_chunks(pi_ne_id    => pi_ne_id
                                     ,pi_obj_type => pi_obj_type);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'pop_super_placement_array');

  RETURN g_pl.placement_count;

END pop_super_placement_array;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE return_placement(pi_index   IN  number
                          ,po_ne_id   OUT number
                          ,po_start   OUT number
                          ,po_end     OUT number
                          ,po_measure OUT number
		   		    ) IS

BEGIN

  po_ne_id   := g_pl.npa_placement_array(pi_index).pl_ne_id;
  po_start   := g_pl.npa_placement_array(pi_index).pl_start;
  po_end     := g_pl.npa_placement_array(pi_index).pl_end;
  po_measure := g_pl.npa_placement_array(pi_index).pl_measure;

END return_placement;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE get_super_placement(pi_ne_id    IN  nm_elements.ne_id%TYPE
                             ,pi_nt_type  IN  nm_types.nt_type%TYPE
                             ,po_ne_id    OUT nm_elements.ne_id%TYPE
                             ,po_begin_mp OUT nm_members.nm_begin_mp%TYPE
                             ,po_end_mp   OUT nm_members.nm_end_mp%TYPE
                             ) IS

  l_pl nm_placement_array;

BEGIN
  l_pl := nm3pla.get_super_placement(p_pl_array => nm3pla.get_placement_from_ne(p_ne_id_in => pi_ne_id)
                                    ,p_type     => pi_nt_type);

  po_ne_id    := l_pl.npa_placement_array(1).pl_ne_id;
  po_begin_mp := l_pl.npa_placement_array(1).pl_start;
  po_end_mp   := l_pl.npa_placement_array(1).pl_end;
END get_super_placement;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE rescale_group(pi_ne_id    IN nm_elements.ne_id%TYPE
                       ,pi_offset   IN number
                       ,pi_seq_flag IN varchar2               DEFAULT 'Y'
                       ) IS

BEGIN

  nm3pla.set_route_offsets(pi_ne_id
                          ,pi_offset);

  nm3pla.update_route_offsets(pi_ne_id
                             ,nm3net.get_nt_units(nm3net.get_nt_type(pi_ne_id))
                             ,pi_seq_flag);

END rescale_group;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE resequence_group(pi_ne_id IN nm_elements.ne_id%TYPE) IS
BEGIN

  nm3pla.set_route_offsets(pi_ne_id
                          ,0);

  nm3pla.resequence_route(pi_ne_id);

END resequence_group;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE get_node_details(pi_route_id               IN  nm_elements.ne_id%TYPE
                          ,pi_node_id                IN  nm_nodes.no_node_id%TYPE
                          ,po_poe_type               OUT varchar2
                          ,po_poe                    OUT number
                          ,po_intersecting_road_name OUT varchar2
                          ) IS

  l_node_class nm_node_class;

BEGIN
  l_node_class := nm3net_o.get_node_class(p_route_id => pi_route_id
                                         ,p_node_id  => pi_node_id);

  po_poe_type               := l_node_class.get_poe_type;
  po_poe                    := l_node_class.get_poe;
  po_intersecting_road_name := l_node_class.get_intersecting_road;
END get_node_details;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE get_ambiguous_lrefs(pi_parent_id IN  nm_members.nm_ne_id_in%TYPE
                             ,pi_offset    IN  number
                             ,pi_sub_class IN varchar2 DEFAULT NULL
                             ,pi_position  in varchar2 DEFAULT NULL
                             ) IS

  l_parent_units nm_units.un_unit_id%TYPE;
  l_child_units  nm_units.un_unit_id%TYPE;

BEGIN
  nm3net.get_group_units(pi_ne_id       => pi_parent_id
                        ,po_group_units => l_parent_units
                        ,po_child_units => l_child_units);

  nm3lrs.get_ambiguous_lrefs(p_parent_id    => pi_parent_id
                            ,p_parent_units => l_parent_units
                            ,p_datum_units  => l_child_units
                            ,p_offset       => pi_offset
                            ,p_lrefs        => g_lref_tab
                            ,p_sub_class    => pi_sub_class);

--rc - test the results of the lref table of amibuous lrefs in case the ambiguity
--is due to a node. In cases where the item is a point (pi_position=null) the end
--of the first element is chosen (arbitrarily). For linear data, it depends on 
--whether the position should be a start or end - if its a start (pi_position='S')
--then the start of the second element is chosen. If its an end (pi_position='E') 
--then the end of the first element is chosen.
--

--nm_debug.debug('Check the count from ambig table');

  if g_lref_tab.count > 0 then
  
--  nm_debug.debug('Count > 0 - before - '||to_char(g_lref_tab.count) );

    g_lref_tab := check_for_nodes (  pi_parent_id, l_parent_units, l_child_units ,g_lref_tab, pi_position );    

--  nm_debug.debug('Count > 0 - after -  '||to_char(g_lref_tab.count) );
    
  end if;

END get_ambiguous_lrefs;

--
------------------------------------------------------------------------------------------------
--
function check_for_nodes ( pi_parent_id IN  nm_members.nm_ne_id_in%TYPE
                                            ,pi_parent_units in integer
                                            ,pi_datum_units  in integer
                                            ,pi_lref_tab in nm3lrs.lref_table
                                            ,pi_position in varchar2 default null) return nm3lrs.lref_table is

cursor c1 ( c_lref_array in nm_lref_array,
            c_parent_id  in number,
            c_p_unit     in integer,
            c_c_unit     in integer ) is
   select lr.lr_ne_id, lr.lr_offset, nnu_node_type, nm_cardinality, nm3net.route_direction( nnu_node_type, nm_cardinality )
   from nm_node_usages, nm_members, table ( c_lref_array.nla_lref_array  ) lr
   where nnu_ne_id = lr.lr_ne_id
   and   nnu_chain = lr.lr_offset --nm3unit.convert_unit( c_p_unit, c_c_unit, lr.lr_offset )
   and nm_ne_id_in = c_parent_id
   and nm_ne_id_of = lr.lr_ne_id
   order by nm3net.route_direction( nnu_node_type, nm_cardinality ) * decode( nvl(pi_position,'S'), 'S', -1, 1);

l_lref_array    nm_lref_array;
l_lref_rec      nm3lrs.lref_record;
l_lref_tab      nm3lrs.lref_table;

lc binary_integer;
begin

  for i in 1..pi_lref_tab.count loop
  
--  nm_debug.debug( to_char(i)||', '||to_char(pi_lref_tab(i).r_ne_id)||', '||to_char(pi_lref_tab(i).r_offset));
  
    if i = 1 then
    
      l_lref_array := nm_lref_array( nm_lref_array_type ( nm_lref( pi_lref_tab(i).r_ne_id, pi_lref_tab(i).r_offset)));

    else
    
      l_lref_array := l_lref_array.add_element( nm_lref( pi_lref_tab(i).r_ne_id, pi_lref_tab(i).r_offset) );
      
    end if;
    
  end loop;
  
--nm_debug.debug('Open cursor loop for '||to_char( pi_parent_id)||','||to_char(pi_parent_units)||','||to_char(pi_datum_units));

  for irec in c1( l_lref_array, pi_parent_id, pi_parent_units, pi_datum_units ) loop

    lc := c1%rowcount;
    
--    if lc = 1 then
      l_lref_tab(lc).r_ne_id  :=    irec.lr_ne_id;
      l_lref_tab(lc).r_offset :=    irec.lr_offset;
--    end if;

--    nm_debug.debug( to_char(lc)||', '||to_char( irec.lr_ne_id )||', '||to_char( irec.lr_offset));
    
  end loop;
  
  if lc = pi_lref_tab.count then
  
--  nm_debug.debug('Count is the same - must be node-based, no POEs');
    
    l_lref_rec := l_lref_tab(1);
    l_lref_tab.delete;
    l_lref_tab(1) := l_lref_rec;
    
    return l_lref_tab;
    
  else
          
    return pi_lref_tab;
    
  end if;
  
end check_for_nodes;
--
------------------------------------------------------------------------------------------------
--
FUNCTION lref_count RETURN pls_integer IS
BEGIN
  RETURN g_lref_tab.COUNT;
END lref_count;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE lref_get_row(pi_index  IN  pls_integer
                      ,po_ne_id  OUT nm_elements.ne_id%TYPE
                      ,po_offset OUT number
                      ) IS
BEGIN
  po_ne_id  := g_lref_tab(pi_index).r_ne_id;
  po_offset := g_lref_tab(pi_index).r_offset;
END lref_get_row;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_set_offset(pi_parent_ne_id IN nm_elements.ne_id%TYPE
                       ,pi_child_ne_id  IN nm_elements.ne_id%TYPE
                       ,pi_child_offset IN number
                       ) RETURN number IS
BEGIN
  RETURN nm3lrs.get_set_offset(p_ne_parent_id => pi_parent_ne_id
                              ,p_ne_child_id  => pi_child_ne_id
                              ,p_offset       => pi_child_offset);
END get_set_offset;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE get_relative_reference( p_parent_type   IN nm_members_all.nm_type%TYPE,
                                  p_parent_obj    IN nm_members_all.nm_obj_type%TYPE,
   				  p_child_ne_id   IN nm_members_all.nm_ne_id_of%TYPE,
   				  p_child_offset  IN nm_members_all.nm_begin_mp%TYPE,
				  p_xsp           IN nm_xsp.nwx_x_sect%TYPE,
				  p_return_ne_id  OUT nm_members_all.nm_ne_id_in%TYPE,
				  p_return_offset OUT nm_members_all.nm_begin_mp%TYPE ) IS

l_return nm_lref := nm3lrs.get_relative_reference( p_parent_type, p_parent_obj,
   				 nm_lref( p_child_ne_id, p_child_offset), p_xsp );

BEGIN
   p_return_ne_id := l_return.get_ne_id;
   p_return_offset := l_return.get_offset;
END get_relative_reference;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_inventory_attrib ( p_parent_obj    IN nm_members_all.nm_obj_type%TYPE,
   				p_child_ne_id   IN nm_members_all.nm_ne_id_of%TYPE,
   				p_child_offset  IN nm_members_all.nm_begin_mp%TYPE,
				p_xsp           IN nm_xsp.nwx_x_sect%TYPE,
				p_attrib_name   IN nm_inv_type_attribs.ita_attrib_name%TYPE ) RETURN varchar2 IS

l_ne nm_lref := nm3lrs.get_relative_reference( 'I', p_parent_obj,
   				 nm_lref( p_child_ne_id, p_child_offset), p_xsp );
l_attr_value varchar2(254);
BEGIN
  l_attr_value := nm3inv.get_attrib_value( l_ne.lr_ne_id, p_attrib_name);
  RETURN l_attr_value;
END get_inventory_attrib;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE mid_block_data(route_id        IN number
                        ,node1           IN number
                        ,node2           IN number
                        ,sub_class       IN varchar2
                        ,distance_error OUT number
                        ,ne_id          OUT number
                        ,offset         OUT number
                        ) IS

BEGIN
  nm3lrs.mid_block_data(route_id       => route_id
                       ,node1          => node1
                       ,node2          => node2
                       ,sub_class      => sub_class
                       ,distance_error => distance_error
                       ,ne_id          => ne_id
                       ,offset         => offset);
END;
--
------------------------------------------------------------------------------------------------
--
FUNCTION pop_member_placement_chunks(pi_ne_id IN nm_elements.ne_id%TYPE
                                    ) RETURN pls_integer IS
BEGIN

  g_pl := nm3pla.get_placement_chunks(p_pl => nm3pla.defrag_placement_array(nm3pla.get_placement_from_ne(pi_ne_id)));

  RETURN g_pl.placement_count;

END pop_member_placement_chunks;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE create_temp_ne_from_route(pi_route                   IN     nm_elements.ne_id%TYPE
                                   ,pi_start_ne_id             IN     nm_elements.ne_id%TYPE
                                   ,pi_start_offset            IN     number
                                   ,pi_end_ne_id               IN     nm_elements.ne_id%TYPE
                                   ,pi_end_offset              IN     number
                                   ,pi_sub_class               IN     nm_elements.ne_sub_class%TYPE
                                   ,pi_restrict_excl_sub_class IN     varchar2
                                   ,pi_homo_check              IN     boolean DEFAULT FALSE
                                   ,po_job_id                     OUT nm_nw_temp_extents.nte_job_id%TYPE) IS

  l_rvs_sub_class nm_elements.ne_sub_class%TYPE;

  l_pl_arr nm_placement_array;
--
   l_temp_ne_id      number;
   l_temp_offset     number;
--
   l_start_ne_id     number := pi_start_ne_id;
   l_start_offset    number := pi_start_offset;
   l_end_ne_id       number := pi_end_ne_id;
   l_end_offset      number := pi_end_offset;
--
   c_restrict_excl_sub_class varchar2(1);
--
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'create_temp_ne_from_route');

   --
   IF NVL(pi_restrict_excl_sub_class,'N') IN ('N','FALSE')
    THEN
      c_restrict_excl_sub_class := 'N';
   ELSE
      c_restrict_excl_sub_class := 'Y';
   END IF;
   --
   -- Round the offsets to the correct number of decimal places if necessary
   --
   l_start_offset  := TO_NUMBER(nm3unit.get_formatted_value (p_value   => l_start_offset
                                                            ,p_unit_id => nm3net.get_nt_units (nm3net.get_nt_type (l_start_ne_id))
                                                            )
                               );
   IF l_end_offset IS NOT NULL
    THEN
      l_end_offset := TO_NUMBER(nm3unit.get_formatted_value (p_value   => l_end_offset
                                                            ,p_unit_id => nm3net.get_nt_units (nm3net.get_nt_type (l_end_ne_id))
                                                            )
                               );
   END IF;
   --
   IF   l_end_ne_id  IS NOT NULL
    AND l_end_offset IS NOT NULL
    THEN
      IF nm3lrs.get_set_offset (pi_route,l_start_ne_id,l_start_offset) > nm3lrs.get_set_offset (pi_route,l_end_ne_id,l_end_offset)
       THEN
         -- Swap them over -  START > END
         l_temp_ne_id   := l_start_ne_id;
         l_temp_offset  := l_start_offset;
         --
         l_start_ne_id  := l_end_ne_id;
         l_start_offset := l_end_offset;
         --
         l_end_ne_id    := l_temp_ne_id;
         l_end_offset   := l_temp_offset;
         --
      END IF;
   ELSIF l_end_ne_id  IS NULL
     AND l_end_offset IS NULL
     THEN
      --
      l_end_ne_id    := l_start_ne_id;
      l_end_offset   := l_start_offset;
      --
   END IF;
   --
  IF c_restrict_excl_sub_class = 'N'
  THEN
    --get the opposite sub class to the one supplied
    IF pi_sub_class IS NOT NULL
    THEN
      l_rvs_sub_class := nm3rvrs.reverse_sub_class(pi_nt_type    => nm3net.get_datum_nt(pi_ne_id => pi_route)
                                                  ,pi_sub_class  => pi_sub_class
                                                  ,pi_error_flag => 'Y');
    ELSE
      l_rvs_sub_class := NULL;
    END IF;
    
    --create placement array of connected sections along route
    l_pl_arr := nm3pla.get_connected_extent(pi_st_lref   => nm_lref(l_start_ne_id, l_start_offset)
                                           ,pi_end_lref  => nm_lref(l_end_ne_id, l_end_offset)
                                           ,pi_route     => pi_route
                                           ,pi_sub_class => l_rvs_sub_class);

  ELSE
    l_pl_arr := nm3pla.get_pl_by_excl_sub_class(pi_st_lref   => nm_lref(l_start_ne_id, l_start_offset)
                                               ,pi_end_lref  => nm_lref(l_end_ne_id, l_end_offset)
                                               ,pi_route     => pi_route
                                               ,pi_sub_class => pi_sub_class);
  END IF;

  --populate temp extent with contents of placement array
  nm3extent_o.create_temp_ne_from_pl(pi_pl_arr            => l_pl_arr
                                    ,po_job_id            => po_job_id
                                    ,pi_default_parent_id => pi_route);

  --perform check for homo update if necessary
  IF pi_homo_check
    AND NOT(nm3extent.temp_ne_valid_for_homo(pi_job_id => po_job_id))
  THEN
    g_wrap_exc_code := -20020;
    g_wrap_exc_msg  := 'Extent not valid for homo update.';
    RAISE g_wrap_exception;
  END IF;
  --
  nm3extent.g_last_temp_extent_source_id := pi_route;
  nm3extent.g_last_temp_extent_source    := nm3extent.c_route;
--
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'create_temp_ne_from_route');

EXCEPTION
  WHEN g_wrap_exception
  THEN
    RAISE_APPLICATION_ERROR(g_wrap_exc_code, g_wrap_exc_msg);

END create_temp_ne_from_route;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE get_block_reference(pi_route        IN     nm_elements.ne_id%TYPE
                             ,pi_intersection IN     nm_nodes.no_node_id%TYPE
                             ,pi_sub_class    IN     nm_elements.ne_sub_class%TYPE DEFAULT NULL
                             ,pi_type         IN     nm_nodes.no_node_type%TYPE
                             ,po_ne_id           OUT nm_elements.ne_id%TYPE
                             ,po_offset          OUT number
                             ) IS

  l_lref nm_lref;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_block_reference');

  l_lref := nm3lrs.get_block_reference(pi_route        => pi_route
                                      ,pi_intersection => pi_intersection
                                      ,pi_sub_class    => pi_sub_class
                                      ,pi_type         => pi_type);

  po_ne_id  := l_lref.lr_ne_id;
  po_offset := l_lref.lr_offset;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_block_reference');
END get_block_reference;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_element_true(pi_ne_id_in IN nm_members.nm_ne_id_in%TYPE
                         ,pi_ne_id_of IN nm_members.nm_ne_id_of%TYPE
                         ) RETURN nm_members.nm_true%TYPE IS
BEGIN
  RETURN nm3lrs.get_element_true(p_ne_id_in => pi_ne_id_in
                                ,p_ne_id_of => pi_ne_id_of);
END get_element_true;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE check_relative_start_end(pi_route        IN nm_elements.ne_id%TYPE
                                  ,pi_start_sect   IN nm_elements.ne_id%TYPE
                                  ,pi_start_offset IN number
                                  ,pi_end_sect     IN nm_elements.ne_id%TYPE
                                  ,pi_end_offset   IN number
                                  ) IS

 l_start_lref nm_lref := nm_lref(pi_start_sect, pi_start_offset);
 l_end_lref nm_lref := nm_lref(pi_end_sect, pi_end_offset);

BEGIN
--   l_start_lref.lr_ne_id := pi_start_sect;
--   l_start_lref.lr_offset := pi_start_offset;
--
--   l_end_lref.lr_ne_id := pi_end_sect;
--   l_end_lref.lr_offset := pi_end_offset;

  nm3lrs.check_relative_start_end(pi_route      => pi_route
                                 ,pi_start_lref => l_start_lref
                                 ,pi_end_lref   => l_end_lref);
END check_relative_start_end;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE process_lref_tab_excl_subclass(pi_sub_class IN nm_elements.ne_sub_class%TYPE
                                        ) IS
BEGIN
  nm3lrs.process_lref_tab_excl_subclass(pio_lref_tab => g_lref_tab
                                       ,pi_sub_class => pi_sub_class);

END process_lref_tab_excl_subclass;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE get_tab_lref (p_ne_id    IN     nm_elements.ne_id%TYPE
                       ,p_offset   IN     nm_members.nm_begin_mp%TYPE
                       ,p_tab_lref IN OUT nm3lrs.lref_table
                       ) IS
BEGIN
   p_tab_lref := nm3lrs.get_tab_lref(p_ne_id,p_offset);
END get_tab_lref;
--
------------------------------------------------------------------------------------------------
--
END nm3wrap;
/

