create or replace package body nm3sdo_geom as
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3sdo_geom.pkb-arc   1.0   Oct 09 2008 12:36:44   rcoupe  $
--       Module Name      : $Workfile:   nm3sdo_geom.pkb  $
--       Date into PVCS   : $Date:   Oct 09 2008 12:36:44  $
--       Date fetched Out : $Modtime:   Oct 09 2008 12:29:58  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on

g_body_sccsid constant varchar2(30) :='"$Revision:   1.0  $"';

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

FUNCTION get_nw_srids RETURN NUMBER;
function get_feature_type ( p_geom in mdsys.sdo_geometry ) return number is
l_dim number;
l_lrs number;
begin
--  l_dim := p_geom.get_dims;
--  l_lrs := p_geom.get_lrs_dim;
  return p_geom.get_gtype; 
end;

function get_area( p_geom in mdsys.sdo_geometry, p_tolerance in number default g_tolerance, p_unit in nm_units.un_unit_id%type default 1 ) return number is
l_valid varchar2(10);
begin
  l_valid := sdo_geom.VALIDATE_GEOMETRY_WITH_CONTEXT( p_geom, p_tolerance );
  if l_valid = 'TRUE' then
    if get_feature_type( p_geom ) = 3 then
      return nm3unit.GET_FORMATTED_VALUE(sdo_geom.SDO_AREA( p_geom, p_tolerance ), 1);
    else
      raise_application_error( -20001, 'Geometry is not a polygon' );
    end if;
  else
      raise_application_error( -20002, 'Geometry is invalid' );
  end if;
  return 0;
exception
  when others then 
   return -1;  
 
end;

function get_length ( p_geom in mdsys.sdo_geometry, p_tolerance in number default g_tolerance, p_unit in nm_units.un_unit_id%type default 1 ) return number is
l_valid varchar2(10);
l_type number;
begin
  l_valid := sdo_geom.VALIDATE_GEOMETRY_WITH_CONTEXT( p_geom, p_tolerance );
  if l_valid = 'TRUE' then
    l_type := get_feature_type( p_geom );
    if l_type = 3 then
      return nm3unit.GET_FORMATTED_VALUE(sdo_geom.SDO_LENGTH(sdo_util.POLYGONTOLINE(p_geom), p_tolerance ), 1); 
    elsif l_type = 2 then
      return nm3unit.GET_FORMATTED_VALUE(sdo_geom.sdo_length(p_geom, p_tolerance ), 1);
    else
      raise_application_error( -20003, 'Geometry is not of an appropriate type' );
    end if;
  else
      raise_application_error( -20002, 'Geometry is invalid' );
  end if;
  return 0;
exception
  when others then 
   return -1;   
end;

function get_geom_from_gdo( p_gdo_session_id in number, p_gtype in number ) return mdsys.sdo_geometry is
cursor c1 ( c_gdo_id in number ) is
  select  cast( collect(gdo_x_val) as mdsys.sdo_ordinate_array ) 
  from ( select gdo_x_val from ( 
  with gdo as (
  select a.gdo_x_val, a.gdo_y_val, a.gdo_seq_no
  from gis_data_objects a
  where gdo_session_id = c_gdo_id )
  select 1 dim, gdo.gdo_x_val, gdo_seq_no from gdo
    union  all
  select 2 dim, gdo.gdo_y_val, gdo_seq_no from gdo
 )order by gdo_seq_no, dim); 
l_ords mdsys.sdo_ordinate_array;  
l_elem mdsys.sdo_elem_info_array;
begin
  open c1 (p_gdo_session_id);
  fetch c1 into l_ords;
  close c1;
  if p_gtype = 2002 then
    l_elem := mdsys.sdo_elem_info_array( 1, 2, 1 );
  elsif p_gtype = 2003 then
    l_elem := mdsys.sdo_elem_info_array( 1, 1003, 1 );
    l_ords.extend(2);
    l_ords(l_ords.last-1) := l_ords(1);
    l_ords(l_ords.last)   := l_ords(2);
  else
    raise_application_error( -20003, 'Geometry is not of an appropriate type' );
  end if;  
    
  return sdo_util.rectify_geometry(sdo_util.REMOVE_DUPLICATE_VERTICES( mdsys.sdo_geometry( p_gtype, g_srid, null, l_elem, l_ords ), 0.0001), 0.0001);
end;  

function get_geom_from_gdo( p_gdo_session_id in number, p_feature_type in varchar2 ) return mdsys.sdo_geometry is
begin
  if p_feature_type = 'LINE' then
    return get_geom_from_gdo(p_gdo_session_id, 2002);
  elsif p_feature_type = 'POLYGON' then
    return get_geom_from_gdo(p_gdo_session_id, 2003);
  else
    raise_application_error( -20003, 'Geometry is not of an appropriate type' );
  end if;  
end;
  
FUNCTION get_nw_srids RETURN NUMBER IS
CURSOR c1 IS
  SELECT sdo_srid
  FROM mdsys.sdo_geom_metadata_table,
       NM_NW_THEMES, NM_LINEAR_TYPES, NM_THEMES_ALL
  WHERE nnth_nlt_id = nlt_id
  AND   nlt_g_i_d   = 'D'
  AND   nnth_nth_theme_id = nth_theme_id
  AND   nth_feature_table = sdo_table_name
  AND   nth_feature_shape_column = sdo_column_name
  AND   sdo_owner = Hig.get_application_owner;

l_srid NUMBER;

BEGIN

  OPEN c1;
  FETCH c1 INTO l_srid;
  CLOSE c1;
  RETURN l_srid;

END;

begin
  g_srid := get_nw_srids;
end;
