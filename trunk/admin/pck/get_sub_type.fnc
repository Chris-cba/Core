CREATE OR REPLACE function get_sub_type
   ( p_obj_type in nm_group_types_all.ngt_group_type%TYPE,
     p_nt_type  in nm_types.nt_type%type )   return nm_types.nt_type%type is
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)get_sub_type.fnc	1.2 10/27/03
--       Module Name      : get_sub_type.fnc
--       Date into SCCS   : 03/10/27 12:01:45
--       Date fetched Out : 07/06/13 14:10:13
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
cursor c1( c_obj_type nm_group_types.ngt_group_type%TYPE) is
  select a.NNG_NT_TYPE
  from nm_nt_groupings_all a
  where a.NNG_GROUP_TYPE = p_obj_type;
cursor c2 is
  select NGR_CHILD_GROUP_TYPE
  from nm_group_relations_all
  connect by prior NGR_CHILD_GROUP_TYPE = NGR_PARENT_GROUP_TYPE
  start with NGR_PARENT_GROUP_TYPE = p_obj_type;
retval   nm_types.nt_type%type;
ich nm_group_relations.NGR_CHILD_GROUP_TYPE%TYPE;
begin
--nm_debug.debug_on;
--nm_debug.debug( p_obj_type||' ,  '||p_nt_type );

--is the object a group of datum?
  if p_obj_type is null then
--  its a datum - don't return anything because this is now used on groups and this should not happen
    retval := null;
--    nm_debug.debug( 'p_obj_type is null');
  else
--  it is a group - test the component members.
--    nm_debug.debug( 'its a group ');
      
    for irec in c2 loop
--    nm_debug.debug( 'in the loop');

      ich := irec.NGR_CHILD_GROUP_TYPE;

--      nm_debug.debug( 'ich = '||irec.NGR_CHILD_GROUP_TYPE);
    end loop;

/*   open c1( ich );
    fetch c1 into retval;
    close c1;
*/
--nm_debug.debug('nvl(ich, p_obj_type) = nvl('||ich||', '||p_obj_type||')');
    retval := nvl(ich, p_obj_type);    
  end if;
  return retval;
exception
  when no_data_found then
    return p_obj_type;
/*
    open c1( p_obj_type);
    fetch c1 into retval;
    close c1;
    return retval;
*/    
end;
/
