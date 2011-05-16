CREATE OR REPLACE procedure drop_layer ( p_table in varchar2, p_column in varchar2 default 'GEOLOC' ) is
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/drop_layer.fnc-arc   2.1   May 16 2011 14:41:32   Steve.Cooper  $
--       Module Name      : $Workfile:   drop_layer.fnc  $
--       Date into SCCS   : $Date:   May 16 2011 14:41:32  $
--       Date fetched Out : $Modtime:   Apr 01 2011 08:41:18  $
--       SCCS Version     : $Revision:   2.1  $
--       Based on SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
cur_string varchar2(2000);
qq         char := chr(39);
l_owner    varchar2(30) := Sys_Context('NM3CORE','APPLICATION_OWNER');

/*
SUBTYPE layer_record_t        IS sde.layers%ROWTYPE;
SUBTYPE geocol_record_t       IS sde.geometry_columns%ROWTYPE;
SUBTYPE registration_record_t IS sde.table_registry%ROWTYPE;
*/

begin

  cur_string := 'drop table '||p_table;

  begin
    execute immediate cur_string;
  exception
    when others then null;
  end;

  cur_string := 'drop view '||p_table;

  begin
    execute immediate cur_string;
  exception
    when others then null;
  end;

  cur_string := 'delete from user_sdo_geom_metadata where table_name = '||qq||
                p_table||qq||' and column_name = '||qq||p_column||qq;
                
  begin
    execute immediate cur_string;
--  exception
--    when others then null;
  end;

  cur_string := 'delete from nm_themes_all where nth_feature_table = '||qq||
                p_table||qq;

  begin
    execute immediate cur_string;
--  exception
--    when others then null;
  end;

  cur_string := 'delete from sde.layers '||
                ' where table_name = '||qq||p_table||qq||
                '  and   owner = '||qq||l_owner||qq;

  begin
    execute immediate cur_string;

--  exception
--    when others then null;

  end;

  cur_string := 'delete from sde.geometry_columns '||
                ' where  f_table_schema = '||qq||l_owner||qq||
                ' and    f_table_name = '||qq||p_table||qq;

  begin
    execute immediate cur_string;
--  exception
--    when others then null;
  end;

  cur_string := 'delete from sde.table_registry '||
                ' where table_name = '||qq||p_table||qq||
                ' and   owner = '||qq||l_owner||qq;

  begin
    execute immediate cur_string;
--  exception
--    when others then null;
  end;

end;
/
