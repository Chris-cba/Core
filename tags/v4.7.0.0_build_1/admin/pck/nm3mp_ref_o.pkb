CREATE OR REPLACE PACKAGE BODY nm3mp_ref_o AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3mp_ref_o.pkb-arc   2.2   Jul 04 2013 16:15:38   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3mp_ref_o.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:15:38  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:16  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.1
-------------------------------------------------------------------------
--   Author : Kevin Angus
--
--   nm3mp_ref_o body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.2  $';
  g_package_name CONSTANT varchar2(30) := 'nm3mp_ref_o';

  c_start constant varchar2(1) := 'S';
  c_end   constant varchar2(1) := 'E';
--
-----------------------------------------------------------------------------
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
-----------------------------------------------------------------------------
--
FUNCTION get_datum_lref(pi_route_lref in nm_lref
                       ,pi_start_end  in varchar2
                       ) RETURN nm_lref IS

  l_retval nm_lref := nm_lref(null, null);

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_datum_lref');

  nm3wrap.get_ambiguous_lrefs(pi_parent_id => pi_route_lref.get_ne_id
                             ,pi_offset    => pi_route_lref.get_offset
                             ,pi_position  => pi_start_end);
                             
  if nm3wrap.lref_count > 1
  then
    --lref is ambiguous
    hig.raise_ner(pi_appl               => nm3type.c_net
                 ,pi_id                 => 312
                 ,pi_supplementary_info => pi_route_lref.lr_ne_id || ':' || pi_route_lref.lr_offset);
  else
    nm3wrap.lref_get_row(pi_index  => 1
                        ,po_ne_id  => l_retval.lr_ne_id
                        ,po_offset => l_retval.lr_offset);
  end if;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_datum_lref');

  RETURN l_retval;

END get_datum_lref;
--
-----------------------------------------------------------------------------
--
FUNCTION get_pl_for_refs(pi_route_id         in nm_elements.ne_id%type
                        ,pi_start_ref_item   in nm_inv_items.iit_ne_id%type
                        ,pi_start_ref_offset in number
                        ,pi_end_ref_item     in nm_inv_items.iit_ne_id%type default null
                        ,pi_end_ref_offset   in number default null
                        ) RETURN nm_placement_array IS

  e_offset_out_of_range exception;
  
  c_point_loc constant boolean := pi_end_ref_offset is null;
  
  l_route_max_slk nm_members.nm_slk%type;
  l_route_min_slk nm_members.nm_slk%type;
  
  l_route_start_lref nm_lref := nm_lref(pi_route_id, NULL);
  l_route_end_lref   nm_lref := nm_lref(pi_route_id, NULL);
  
  l_datum_start_lref nm_lref := nm_lref(NULL, NULL);
  l_datum_end_lref   nm_lref := nm_lref(NULL, NULL);
  
  l_pl_arr nm_placement_array;
  
  l_error_offset number;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_pl_for_refs');

--  nm_debug.debug('get_pl_for_refs');
--  nm_debug.debug('pi_start_ref_item = ' || pi_start_ref_item);
--  nm_debug.debug('pi_start_ref_offset = ' || pi_start_ref_offset);
--  nm_debug.debug('pi_end_ref_item = ' || pi_end_ref_item);
--  nm_debug.debug('pi_end_ref_offset = ' || pi_end_ref_offset);

  ---------------------------
  --check route and ref items
  ---------------------------
  nm3mp_ref.validate_element(pi_ne_id => pi_route_id);
  
  nm3mp_ref.validate_ref_item(pi_iit_ne_id => pi_start_ref_item
                             ,pi_route_id  => pi_route_id);
  nm3mp_ref.validate_ref_item(pi_iit_ne_id => pi_end_ref_item
                             ,pi_route_id  => pi_route_id);

  --get min/max slk for checking location offsets
  l_route_max_slk := nm3net.get_max_slk(pi_ne_id => pi_route_id);
  l_route_min_slk := nm3net.get_min_slk(pi_ne_id => pi_route_id);

  ----------------------------
  --get start ref route offset
  ----------------------------
  IF pi_start_ref_item IS NOT NULL
  THEN
    l_route_start_lref.lr_offset := nm3mp_ref.get_route_offset_for_ref_item(pi_route_id => pi_route_id
                                                                           ,pi_ref_item => pi_start_ref_item)
                                      + pi_start_ref_offset;
  ELSE
    --no item supplied so use offset relative to the route
    l_route_start_lref.lr_offset := pi_start_ref_offset;
  END IF;
  
  --check start offset is in range
  IF l_route_start_lref.lr_offset NOT BETWEEN l_route_min_slk and l_route_max_slk
  then
    l_error_offset := l_route_start_lref.lr_offset;
    RAise e_offset_out_of_range;
  end if;

  --------------------------
  --get end ref route offset
  --------------------------
  if c_point_loc
  then
    l_route_end_lref := l_route_start_lref;
  else
    IF pi_end_ref_item IS NOT NULL
    THEN
      l_route_end_lref.lr_offset   := nm3mp_ref.get_route_offset_for_ref_item(pi_route_id => pi_route_id
                                                                             ,pi_ref_item => pi_end_ref_item)
                                        + pi_end_ref_offset;
    ELSE
      --no item supplied so use offset relative to the route
      l_route_end_lref.lr_offset := pi_end_ref_offset;
    end if;
  end if;
  
  --check end offset is in range
  IF l_route_end_lref.lr_offset NOT BETWEEN l_route_min_slk and l_route_max_slk
  then
    l_error_offset := l_route_end_lref.lr_offset;
    RAise e_offset_out_of_range;
  end if;
  
  -----------------
  --get datum lrefs
  -----------------
  l_datum_start_lref := get_datum_lref(pi_route_lref => l_route_start_lref
                                      ,pi_start_end  => c_start);
  
  if c_point_loc
  then
    l_datum_end_lref := l_datum_start_lref;
  else
    l_datum_end_lref   := get_datum_lref(pi_route_lref => l_route_end_lref
                                        ,pi_start_end  => c_end);
  end if;
  
  ---------------------------------------------------
  --get placement for connected sections between refs
  ---------------------------------------------------
  l_pl_arr := nm3pla.get_connected_extent(pi_st_lref   => l_datum_start_lref
                                         ,pi_end_lref  => l_datum_end_lref
                                         ,pi_route     => pi_route_id
                                         ,pi_sub_class => NULL);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_pl_for_refs');
  
  RETURN l_pl_arr;

exception
  when e_offset_out_of_range
  THEN
    hig.raise_ner(pi_appl               => nm3type.c_net
                 ,pi_id                 => 29
                 ,pi_supplementary_info => ' ' || l_error_offset || ': ' || l_route_min_slk || ' -> ' || l_route_max_slk);

END get_pl_for_refs;
--
-----------------------------------------------------------------------------
--
END nm3mp_ref_o;
/

