CREATE OR REPLACE PACKAGE BODY nm3api_trans AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3api_trans.pkb-arc   2.2   Jul 04 2013 15:15:38   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3api_trans.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:15:38  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:08  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version :  1.3
--
--
--   Author : Rob Coupe
--
--   API package body
--
--   This package is a collection of many procedures and functions that are available
--   elsewhere. The intention is to provide a more concise and more easily accessible
--   list of programmer interface modules.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.2  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'NM3API_TRANS';
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
FUNCTION get_start( p_ne_id IN NM_ELEMENTS.NE_ID%TYPE) RETURN nm_elements.ne_id%type is
begin
   return nm3lrs.get_start( p_ne_id );
end get_start;
--
-----------------------------------------------------------------------------
--
FUNCTION get_start( p_route_unique IN NM_ELEMENTS.NE_UNIQUE%TYPE
                   ,p_nt_type      IN NM_ELEMENTS.NE_NT_TYPE%TYPE ) RETURN nm_elements.ne_id%type is
begin
  return get_start(nm3net.get_ne_id( p_route_unique, p_nt_type ));
end get_start;
--
-----------------------------------------------------------------------------
--
FUNCTION get_route_translation( p_route_lref  IN NM_LREF )  RETURN NM_LREF is
begin

  return nm3lrs.get_datum_offset( p_route_lref );

end get_route_translation;
--
-----------------------------------------------------------------------------
--
FUNCTION get_datum_translation( p_datum_lref IN NM_LREF
                               ,p_route_type IN NM_ELEMENTS.NE_GTY_GROUP_TYPE%TYPE )  RETURN NM_LREF is
begin

  return nm3lrs.get_location_offset( p_route_type, p_datum_lref );

end get_datum_translation;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ambiguous_lrefs( p_route_lref IN NM_LREF )  RETURN NM_LREF_ARRAY is
retval nm_lref_array;  --  := initialise_lref_array;

l_ne_id nm_elements.ne_id%type;
l_offset number;
begin
  retval := initialise_lref_array;
  nm3wrap.get_ambiguous_lrefs( p_route_lref.lr_ne_id, p_route_lref.lr_offset, null );
  for irec in 1..nm3wrap.lref_count loop
    nm3wrap.LREF_GET_ROW( irec,  l_ne_id, l_offset);
    retval := retval.add_element( l_ne_id, l_offset );
  end loop;
  return retval;
end get_ambiguous_lrefs;
--
-----------------------------------------------------------------------------
--
FUNCTION get_max_route_offset( p_route_id IN NM_ELEMENTS.NE_ID%TYPE )  RETURN NUMBER is
begin
  return nm3net.get_max_slk( p_route_id );
end get_max_route_offset;
--
-----------------------------------------------------------------------------
--
FUNCTION get_max_route_offset( p_route_unique IN NM_ELEMENTS.NE_UNIQUE%TYPE
                              ,p_nt_type      IN NM_ELEMENTS.NE_NT_TYPE%TYPE)  RETURN NUMBER is
  l_ne_id nm_elements.ne_id%TYPE;
begin
  l_ne_id := nm3net.get_ne_id (p_route_unique, p_nt_type);
  return get_max_route_offset(l_ne_id);
end get_max_route_offset;
--
-----------------------------------------------------------------------------
--
FUNCTION get_min_route_offset( p_route_id IN NM_ELEMENTS.NE_ID%TYPE )  RETURN NUMBER is
begin
  return nm3net.get_min_slk( p_route_id );
end get_min_route_offset;
--
-----------------------------------------------------------------------------
--
FUNCTION get_min_route_offset( p_route_unique IN NM_ELEMENTS.NE_UNIQUE%TYPE
                              ,p_nt_type      IN NM_ELEMENTS.NE_NT_TYPE%TYPE)  RETURN NUMBER is
  l_ne_id nm_elements.ne_id%TYPE;
begin
  l_ne_id := nm3net.get_ne_id (p_route_unique, p_nt_type);
  return get_min_route_offset(l_ne_id);
end get_min_route_offset;
--
-----------------------------------------------------------------------------
--
FUNCTION get_length ( p_ne_id IN NM_ELEMENTS.NE_ID%TYPE )  RETURN NUMBER is
begin
  return nm3net.get_ne_length( p_ne_id );
end get_length;
--
-----------------------------------------------------------------------------
--
FUNCTION get_length ( p_route_unique IN NM_ELEMENTS.NE_UNIQUE%TYPE
                     ,p_nt_type      IN NM_ELEMENTS.NE_NT_TYPE%TYPE)  RETURN NUMBER is
  l_ne_id nm_elements.ne_id%TYPE;
begin
  l_ne_id := nm3net.get_ne_id (p_route_unique, p_nt_type);
  return get_length(l_ne_id);
end get_length;

--
-----------------------------------------------------------------------------
--
FUNCTION initialise_lref_array (pi_ne_id   IN number DEFAULT NULL
                                    ,pi_offset  IN number DEFAULT NULL
                                    ) RETURN nm_lref_array IS
--
   this_nla nm_lref_array;
--
BEGIN
--
   this_nla := nm_lref_array(nm_lref_array_type(nm_lref(pi_ne_id
                                                       ,pi_offset
                                                       )));
   RETURN this_nla;
--
END initialise_lref_array;

--
-----------------------------------------------------------------------------
--

FUNCTION defrag_placement_array (npl_array nm_placement_array) RETURN nm_placement_array IS
begin
  return nm3pla.defrag_placement_array( npl_array );
end defrag_placement_array;

--
-----------------------------------------------------------------------------
--
FUNCTION get_connected_arrays ( p_ne_id   IN nm_elements.ne_id%TYPE
                               ,p_nt_type IN nm_types.nt_type%TYPE
                              ) RETURN nm_placement_array IS

begin
  return nm3pla.get_connected_chunks( p_ne_id, p_nt_type );
end get_connected_arrays;
--
-----------------------------------------------------------------------------
--

Function get_placement_from_obj ( p_ne_id IN nm_elements.ne_id%type ) return nm_placement_array  IS
begin
  return nm3pla.get_placement_from_ne( p_ne_id );
end get_placement_from_obj;
--
-----------------------------------------------------------------------------
--

FUNCTION  get_linear_route_translation ( npl_placement IN nm_placement ) RETURN nm_placement_array IS
begin
  return nm3pla.defrag_placement_array( nm3pla.get_sub_placement( npl_placement ));
end get_linear_route_translation;

--
-----------------------------------------------------------------------------
--
FUNCTION initialise_placement (p_ne_id   IN number DEFAULT NULL
                              ,p_start   IN number DEFAULT NULL
                              ,p_end     IN number DEFAULT NULL
                              ,p_measure IN number DEFAULT NULL
                              ) RETURN nm_placement IS

begin
  return nm3pla.initialise_placement (p_ne_id, p_start, p_end, p_measure );
end initialise_placement;
--
-----------------------------------------------------------------------------
--
FUNCTION initialise_placement_array (p_ne_id   IN number DEFAULT NULL
                                    ,p_start   IN number DEFAULT NULL
                                    ,p_end     IN number DEFAULT NULL
                                    ,p_measure IN number DEFAULT NULL
                                    ) RETURN nm_placement_array IS

begin
  return nm3pla.initialise_placement_array (p_ne_id, p_start, p_end, p_measure );
end initialise_placement_array;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ne_id ( p_route_unique IN NM_ELEMENTS.NE_UNIQUE%TYPE
                    ,p_nt_type      IN NM_ELEMENTS.NE_NT_TYPE%TYPE)  RETURN NUMBER is

begin
  return nm3net.get_ne_id( p_route_unique, p_nt_type );
end get_ne_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ne_unique (p_ne_id IN nm_elements.ne_id%TYPE) RETURN nm_elements.ne_unique%TYPE IS
BEGIN
   RETURN nm3net.get_ne_unique(p_ne_id);
END get_ne_unique;
--
-----------------------------------------------------------------------------
--
END nm3api_trans;
/
