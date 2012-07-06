create or replace package body nm3sdo_ops as
--
--------------------------------------------------------------------------------
-- PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3sdo_ops.pkb-arc   1.3   Jul 06 2012 13:08:50   Rob.Coupe  $
--       Module Name      : $Workfile:   nm3sdo_ops.pkb  $
--       Date into PVCS   : $Date:   Jul 06 2012 13:08:50  $
--       Date fetched Out : $Modtime:   Jul 06 2012 13:08:34  $
--       PVCS Version     : $Revision:   1.3  $
--
-- Author: Rob Coupe
--
--------------------------------------------------------------------------------
--

g_body_sccsid  CONSTANT varchar2(2000)  := '"$Revision"';
procedure dbug_ids;
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
procedure remove_theme_data(p_nth_theme_id in nm_themes_all.nth_theme_id%type, p_ids in int_array_type ) is 
l_nth_row nm_themes_all%rowtype;
exec_str  varchar2(4000);
begin
--  nm_debug.debug_on;
  set_global(p_ids);
  dbug_ids;
  l_nth_row := nm3get.get_nth( p_nth_theme_id);
  exec_str :=           'begin ';
  exec_str := exec_str||' forall i in 1..nm3sdo_ops.g_ids.last ';
  exec_str := exec_str||'   delete from '||l_nth_row.nth_feature_table||' where '||nvl(l_nth_row.nth_feature_fk_column, l_nth_row.nth_feature_pk_column) ||'=  nm3sdo_ops.g_ids(i);';
  exec_str := exec_str||' end;';
--  nm_debug.debug(exec_str);
  begin
    execute immediate exec_str;
  exception
    when others then
      nm_debug.debug(sqlerrm);
    raise;
  end;
end;

procedure close_theme_data(p_nth_theme_id in nm_themes_all.nth_theme_id%type, p_ids in int_array_type, p_end_date in date ) is 
l_nth_row nm_themes_all%rowtype;
exec_str  varchar2(4000);
begin
--  nm_debug.debug_on;
  set_global(p_ids);
  dbug_ids;
  l_nth_row := nm3get.get_nth( p_nth_theme_id);
  exec_str :=           'begin ';
  exec_str := exec_str||' forall i in 1..nm3sdo_ops.g_ids.last ';
  exec_str := exec_str||'   update  '||l_nth_row.nth_feature_table||' set '||l_nth_row.nth_end_date_column||' = :p_date where '||
                         nvl(l_nth_row.nth_feature_fk_column, l_nth_row.nth_feature_pk_column) ||'=  nm3sdo_ops.g_ids(i)'||
                         ' and '||l_nth_row.nth_end_date_column||' is null;';
  exec_str := exec_str||' end;';
--  nm_debug.debug(exec_str);
  begin
    execute immediate exec_str using p_end_date;
  exception
    when others then
--      nm_debug.debug(sqlerrm);
    raise;
  end;
end;

procedure remove_spatial_data(p_ids in int_array_type)  is
cursor c1 is
select cast (collect(i.iit_ne_id) as int_array_type ) id_list, nith_nth_theme_id
from table( p_ids ) t, nm_inv_themes, nm_inv_items i, nm_themes_all
where nith_nit_id = iit_inv_type
and nth_theme_id = nith_nth_theme_id
and nth_base_table_theme is null
and i.iit_ne_id = t.column_value
and not exists ( select 1 from nm_members_all where nm_ne_id_in = i.iit_ne_id )
group by nith_nth_theme_id;
--
l_ids int_array_type;
l_nth nm_themes_all.nth_theme_id%type;

begin
--  nm_debug.debug('start of loop');
  for irec in c1 loop
--    nm_debug.debug_on;
--    nm_debug.debug('removing theme data for array ');
    remove_theme_data( irec.nith_nth_theme_id, irec.id_list );
  end loop; 
end;


procedure close_spatial_data(p_ids in int_array_type, p_end_date in date)  is
cursor c1( c_end_date in date ) is
select cast (collect(i.iit_ne_id) as int_array_type ) id_list, nith_nth_theme_id
from table( p_ids ) t, nm_inv_themes, nm_inv_items i, nm_themes_all
where nith_nit_id = iit_inv_type
and nth_theme_id = nith_nth_theme_id
and nth_base_table_theme is null 
and nth_use_history = 'Y' and nth_end_date_column is not null
and i.iit_ne_id = t.column_value
--and not exists ( select 1 from nm_members_all where nm_ne_id_in = i.iit_ne_id and nvl(nm_end_date, c_end_date+1 ) > c_end_date )
group by nith_nth_theme_id;
--
l_ids int_array_type;
l_nth nm_themes_all.nth_theme_id%type;

begin
--  nm_debug.debug('start of loop');
  for irec in c1 (p_end_date) loop
--    nm_debug.debug_on;
--    nm_debug.debug('removing theme data for array ');
    close_theme_data( irec.nith_nth_theme_id, irec.id_list, p_end_date );
  end loop; 
end;
  
procedure set_global(p_ids in int_array_type) is
begin
  g_ids := p_ids;
end;

procedure dbug_ids as
begin
  nm_debug.debug_on;
  nm_debug.debug ('IDS');
    for i in 1..g_ids.last loop
      nm_debug.debug (i||' = '||g_ids(i));
    end loop;
end;
end;