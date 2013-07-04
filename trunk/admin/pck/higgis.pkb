CREATE OR REPLACE PACKAGE BODY higgis AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/higgis.pkb-arc   2.7   Jul 04 2013 15:01:10   James.Wadsworth  $
--       Module Name      : $Workfile:   higgis.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:01:10  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:59:42  $
--       Version          : $Revision:   2.7  $
--       Based on SCCS version : 1.39
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--   A GIS package intended to handle all GIS theme and connection information
--
--   Author : Rob Coupe
--
   g_body_sccsid     CONSTANT  varchar2(80) := '"$Revision:   2.7  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name CONSTANT varchar2(30) := 'higgis';

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
---------------------------------------------------------------------------
--
   PROCEDURE set_running( appid IN number, convid IN number ) IS
   BEGIN
      gis_running_flag := TRUE;
      gis_appid        := appid;
      gis_convid       := convid;
   END;
--
---------------------------------------------------------------------------
--
   FUNCTION get_running RETURN boolean IS
   BEGIN
      RETURN gis_running_flag;
   END;
--
---------------------------------------------------------------------------
--
   PROCEDURE stop_running IS
   BEGIN
      gis_running_flag := FALSE;
      gis_appid := 0;
      gis_convid := NULL;
   END;
--
---------------------------------------------------------------------------
--
   FUNCTION get_gis_dir RETURN varchar2 IS
   CURSOR c1 IS
      SELECT gp_dir_path
      FROM gis_projects;
   ret_dir varchar2(100);
   BEGIN
      OPEN c1;
      FETCH c1 INTO ret_dir;
      CLOSE c1;
      RETURN ret_dir;
   END;
--
---------------------------------------------------------------------------
--
   FUNCTION get_gis_project RETURN varchar2 IS
   CURSOR c1 IS
      SELECT gp_project
      FROM gis_projects;
   ret_proj gis_projects.gp_project%TYPE;
   BEGIN
      OPEN c1;
      FETCH c1 INTO ret_proj;
      CLOSE c1;
      RETURN ret_proj;
   END;
--
---------------------------------------------------------------------------
--
   FUNCTION get_gis_start_string RETURN varchar2 IS
   CURSOR c1 IS
      SELECT gp_dir_path||' '||gp_project
      FROM gis_projects;
   ret_proj varchar2(185);
   BEGIN
      OPEN c1;
      FETCH c1 INTO ret_proj;
      CLOSE c1;
      RETURN ret_proj;
   END;
--
---------------------------------------------------------------------------
--
   FUNCTION     get_gis_prog    RETURN varchar2 IS
   CURSOR c1 IS
      SELECT gp_dde_init_prog
      FROM gis_projects;
   ret_prog gis_projects.gp_dde_init_prog%TYPE;
   BEGIN
      OPEN c1;
      FETCH c1 INTO ret_prog;
      CLOSE c1;
      RETURN ret_prog;
   END;
--
---------------------------------------------------------------------------
--
   FUNCTION     get_gis_topic   RETURN varchar2 IS
   CURSOR c1 IS
      SELECT gp_dde_init_topic
      FROM gis_projects;
   ret_topic gis_projects.gp_dde_init_topic%TYPE;
   BEGIN
      OPEN c1;
      FETCH c1 INTO ret_topic;
      CLOSE c1;
      RETURN ret_topic;
   END;
--
---------------------------------------------------------------------------
--
   PROCEDURE get_gis_connection( appid OUT number, convid OUT number ) IS
   BEGIN
      appid  := gis_appid;
      convid := get_conv_id;
   END;
--
---------------------------------------------------------------------------
--
   FUNCTION get_session_id RETURN number IS
   CURSOR c1 IS
      SELECT gis_session_id.NEXTVAL FROM dual;

   l_ret number;
   BEGIN
      OPEN c1;
      FETCH c1 INTO l_ret;
      RETURN( l_ret );
   END;

   FUNCTION get_conv_id RETURN number IS
   BEGIN
      IF gis_convid = 0
       THEN
         gis_convid := NULL;
      END IF;
      RETURN gis_convid;
   END;
--
---------------------------------------------------------------------------
--
   FUNCTION next_theme_id RETURN number IS
   CURSOR c1 IS
      SELECT nth_theme_id_seq.NEXTVAL FROM dual;
   ret_val number;
   BEGIN
      OPEN c1;
      FETCH c1 INTO ret_val;
      CLOSE c1;
      RETURN ret_val;
   END;

   PROCEDURE set_convid( p_convid IN varchar2 ) IS
   BEGIN
      gis_convid := TO_NUMBER(p_convid) ;
   END;
--
---------------------------------------------------------------------------
--
   FUNCTION     get_theme_name( p_module_name IN varchar2, p_param_name IN varchar2 ) RETURN varchar2  IS

   CURSOR c1 IS
      SELECT gt_theme_name
      FROM gis_themes_all, gis_theme_functions_all
      WHERE gtf_gt_theme_id = gt_theme_id
      AND gtf_hmo_module = p_module_name
      AND gtf_parameter = p_param_name ;

   retval gis_themes_all.gt_theme_name%TYPE;

   BEGIN
      OPEN c1;
      FETCH c1 INTO retval;
      CLOSE c1;
      RETURN retval;
   END;
--
---------------------------------------------------------------------------
   FUNCTION     get_theme_name( p_gt_theme_id IN gis_themes_all.gt_theme_id%TYPE ) RETURN varchar2 IS
--

  CURSOR c1 IS
    SELECT gt_theme_name
    FROM gis_themes_all
    WHERE gt_theme_id = p_gt_theme_id;

  retval gis_themes_all.gt_theme_name%TYPE;

  BEGIN
    OPEN c1;
    FETCH c1 INTO retval;
    CLOSE c1;
    RETURN retval;
END;
---------------------------------------------------------------------------
--
   FUNCTION     get_theme_id ( p_theme IN varchar2) RETURN number IS

   CURSOR c1 IS
      SELECT gt_theme_id
      FROM gis_themes_all
      WHERE gt_theme_name = p_theme;

   retval number := -1;

   BEGIN
     OPEN c1;
     FETCH c1 INTO retval;
     IF c1%NOTFOUND THEN
       retval := -1;
     END IF;

     CLOSE c1;
     RETURN retval;
   END;
--
---------------------------------------------------------------------------
--
   PROCEDURE    get_route_theme( theme_id IN OUT number, theme_name IN OUT varchar2 ) IS

   CURSOR c1 IS
      SELECT gt_theme_id, gt_theme_name FROM gis_themes_all
      WHERE gt_route_theme = 'Y';

   BEGIN
     OPEN c1;
     FETCH c1 INTO theme_id, theme_name;
     IF c1%NOTFOUND THEN
       CLOSE c1;
       RAISE_APPLICATION_ERROR(-20001, 'No route theme available');
     END IF;
     CLOSE c1;
   END;
--
---------------------------------------------------------------------------
--
   PROCEDURE    update_object_ids( p_theme_id IN number, p_session_id IN number ) IS

   CURSOR c1 IS
 SELECT 'update gis_data_objects set gdo_pk_id = ( select '
               ||gt_feature_fk_column||' from '||gt_feature_table||
         ' where '||gt_feature_pk_column||' = gdo_feature_id  )'||
         ' where gdo_session_id = '||TO_CHAR( p_session_id )
        FROM gis_themes_all
 WHERE gt_theme_id = p_theme_id;

   cursor_string varchar2(2000);
   feedback  number;

   BEGIN
 OPEN c1;
 FETCH c1 INTO cursor_string;
 IF c1%NOTFOUND THEN
    NULL;
        ELSE
    hig.execute_sql( cursor_string, feedback );
 END IF;
--
-- The gis_data_objects should now hold the PK of the relevant exor object, ready for query.
--
   END;
--
---------------------------------------------------------------------------
--
   PROCEDURE    update_feature_ids( p_theme_id IN number, p_session_id IN number ) IS

   CURSOR c1 IS
 SELECT 'update gis_data_objects set gdo_feature_id = ( select '||
                gt_feature_pk_column||' from '||gt_feature_table||
         ' where '||gt_feature_fk_column||' = gdo_pk_id  )'||
         ' where gdo_session_id = '||TO_CHAR( p_session_id )
        FROM gis_themes_all
 WHERE gt_theme_id = p_theme_id;

   cursor_string varchar2(2000);
   feedback  number;

   BEGIN
 OPEN c1;
 FETCH c1 INTO cursor_string;
 IF c1%NOTFOUND THEN
    NULL;
        ELSE
    hig.execute_sql( cursor_string, feedback );
 END IF;
--
-- The gis_data_objects should now hold the PK of the relevant feature object, ready for query in the GIS.
--
   END;
--
---------------------------------------------------------------------------
--
/*
   function     get_object_id ( p_session_id in number, p_f_id in number ) return number is

   cursor c1 is
 select 'select '||gt_feature_fk_column||' from '||gt_feature_table||
         ' where '||gt_feature_pk_column||' = '||to_char( p_f_id )
        from gis_themes_all,  gis_requests
 where gt_theme_id = gr_gt_theme_id
 and   gr_session_id = p_session_id;

   cursor_string varchar2(2000);
   feedback  number;
   retval  number;

   begin
 open c1;
 fetch c1 into cursor_string;
 if c1%notfound then
    close c1;
    dbms_output.put_line('No string!!!');
        else
    close c1;
    dbms_output.put_line( cursor_string );
    retval := higgis.fetch_sql( cursor_string ) ;
    dbms_output.put_line( 'returning '||to_char( retval ));
 end if;
--
 return retval;
   end;


   function     get_feature_id ( p_session_id in number, p_id in number ) return number is

   cursor c1 is
 select 'select '||gt_feature_pk_column||' from '||gt_feature_table||
         ' where '||gt_feature_fk_column||' = '||to_char( p_id )
        from gis_themes_all,  gis_requests
 where gt_theme_id = gr_gt_theme_id
 and   gr_session_id = p_session_id;

   cursor_string varchar2(2000);
   feedback  number;
   retval  number;

   begin
 open c1;
 fetch c1 into cursor_string;
 if c1%notfound then
    close c1;
        else
    close c1;
    retval := higgis.fetch_sql( cursor_string ) ;
 end if;
--
 return retval;
   end;
*/

--
---------------------------------------------------------------------------
--
   FUNCTION fetch_sql ( p_string IN varchar2 ) RETURN number IS

   get_obj_id  integer;
   rows_processed  integer;
   retval  number;
   ignore   integer;

   BEGIN

      dbms_output.put_line( p_string );

      get_obj_id := dbms_sql.open_cursor;

      dbms_sql.parse( get_obj_id, p_string, dbms_sql.v7 );

      dbms_sql.define_column( get_obj_id, 1, retval );

      ignore := dbms_sql.EXECUTE( get_obj_id );

      IF dbms_sql.fetch_rows( get_obj_id ) > 0 THEN
 dbms_output.put_line( 'Fetched rows');
        dbms_sql.column_value( get_obj_id,  1, retval );
 dbms_output.put_line( 'Obj id = '||TO_CHAR( retval ));
      END IF;
      IF dbms_sql.is_open( get_obj_id ) THEN
  dbms_sql.close_cursor( get_obj_id);
      END IF;

      RETURN retval;
   END;
--
---------------------------------------------------------------------------
--
/*
   procedure    create_objects_from_nw ( p_session_id in number ) is

   cursor c_pt_or_cont is
      select decode( gt_end_chain_column, null, 'P', 'C' ), nvl( gt_route_theme, 'N' )
      from gis_themes_all, gis_requests
      where gr_session_id = p_session_id
      and   gr_gt_theme_id = gt_theme_id;

   p_or_c varchar2(1);
   route_theme  varchar2(1);

   cursor c_pt is
 select 'insert into gis_data_objects '||
        '( gdo_session_id, gdo_pk_id, gdo_rse_he_id, gdo_st_chain, gdo_theme_name, gdo_xsp, gdo_offset ) '||
        'select '||to_char(p_session_id)||','||gt_pk_column||','||gt_rse_fk_column||','||
        gt_st_chain_column||','||
 ''''||gt_theme_name||''''||','||nvl( gt_xsp_column, 'null')||','||nvl( gt_offset_field,'null')||
   ' from '||gt_table_name||',road_segs,'||'gis_network_requests, gis_routes_link '||
   ' where gnr_session_id = '||to_char( gr_session_id)||
        ' and gnr_route_name = grl_route_name and grl_start < gnr_end'||
   ' and grl_end   > gnr_start '||
   ' and '||gt_rse_fk_column||' = grl_rse_he_id '||
   ' and '||gt_st_chain_column||' + grl_start  >= greatest( gnr_start, grl_start ) '||
   ' and '||gt_st_chain_column||' + grl_start  <= least( gnr_end, grl_end ) '||
   ' and grl_rse_he_id = rse_he_id '
 from gis_themes_all, gis_requests
 where gr_session_id = p_session_id
 and gr_gt_theme_id = gt_theme_id;

   cursor c_cont is
 select 'insert into gis_data_objects '||
        '( gdo_session_id, gdo_pk_id, gdo_rse_he_id, gdo_st_chain, gdo_end_chain, gdo_theme_name, gdo_xsp, gdo_offset ) '||
        'select '||to_char(p_session_id)||','||gt_pk_column||','||gt_rse_fk_column||','||
        gt_st_chain_column||','||gt_end_chain_column||','||
 ''''||gt_theme_name||''''||','||nvl( gt_xsp_column, 'null')||','||nvl( gt_offset_field,'null')||
   ' from '||gt_table_name||',road_segs,'||'gis_network_requests, gis_routes_link '||
   ' where gnr_session_id = '||to_char( gr_session_id)||
        ' and gnr_route_name = grl_route_name and grl_start < gnr_end'||
   ' and grl_end  > gnr_start '||
   ' and '||gt_rse_fk_column||' = grl_rse_he_id '||
   ' and ('||gt_st_chain_column||' + grl_start  >= greatest( gnr_start, grl_start ) '||
   ' and '||gt_st_chain_column||' + grl_start  <= least( gnr_end, grl_end ) )'||
   ' or ( '||gt_end_chain_column||' +grl_start  >= greatest( gnr_start, grl_start ) '||
   ' and '||gt_end_chain_column||' + grl_start <= least( gnr_end, grl_end ) )'||
   ' and grl_rse_he_id = rse_he_id '
 from gis_themes_all, gis_requests
 where gr_session_id = p_session_id
 and gr_gt_theme_id = gt_theme_id;

   cursor c_route is
 select 'insert into gis_data_objects ( gdo_session_id, gdo_pk_id, gdo_rse_he_id, '||
 ' gdo_theme_name ) '||
 'select '||to_char(p_session_id)||', rse_he_id, rse_he_id, '||''''||gt_theme_name||''''||
   ' from road_segs,gis_network_requests, gis_routes_link '||
   ' where gnr_session_id = '||to_char( gr_session_id)||
        ' and gnr_route_name = grl_route_name and grl_start < gnr_end '||
   ' and grl_end  > gnr_start '||
   ' and grl_rse_he_id = rse_he_id '
 from gis_themes_all, gis_requests
 where gr_session_id = p_session_id
 and gr_gt_theme_id = gt_theme_id;

   cursor_string varchar2(2000);
   feedback  number;

   begin
 open c_pt_or_cont;
 fetch c_pt_or_cont into p_or_c, route_theme;
 close c_pt_or_cont;

 dbms_output.put_line( 'Point or continuous - '||p_or_c );

 if route_theme = 'Y'  then
   open c_route;
   fetch c_route into cursor_string;
   close c_route;
 elsif  p_or_c = 'P' then
   open c_pt;
   fetch c_pt into cursor_string;
   close c_pt;
 else
   open c_cont;
   fetch c_cont into cursor_string;
   close c_cont;
 end if;

 hig.execute_sql( cursor_string, feedback );
--
-- The gis_data_objects should now hold the PK of the relevant exor object, ready for query.
--
   end;
*/

--
---------------------------------------------------------------------------
--
   PROCEDURE pop_ids_from_feature (p_session_id IN number,  p_theme IN varchar2,  p_value IN varchar2) IS
      v_sql_string  varchar2(2000) := '';
 v_gt_theme_id  number(9);
 v_gt_theme_name  varchar2(30) := UPPER(p_theme) ;
 v_gt_table_name  varchar2(30);
 v_gt_pk_column  varchar2(30);
 v_gt_feature_pk_column varchar2(30);
 v_gt_feature_fk_column varchar2(30);
      CURSOR c1 IS  SELECT  gt_theme_id            ,
      gt_table_name          ,
      gt_pk_column           ,
      gt_feature_pk_column,
      gt_feature_fk_column
    FROM   gis_themes_all
    WHERE   gt_theme_name      =  v_gt_theme_name ;

 v_feedback number(38);

   BEGIN
 IF NOT c1%isopen THEN
       OPEN c1;
 END IF;
      FETCH c1 INTO  v_gt_theme_id ,
    v_gt_table_name ,
    v_gt_pk_column ,
    v_gt_feature_pk_column,
    v_gt_feature_fk_column;

 IF  c1%NOTFOUND THEN
       CLOSE c1;
       RAISE_APPLICATION_ERROR(-20001,'GIS Theme : '||v_gt_theme_name||' does not exist');
 END IF;
      CLOSE c1;

      v_sql_string := v_sql_string || 'INSERT INTO gis_data_objects ( GDO_SESSION_ID, ';
      v_sql_string := v_sql_string ||                                'GDO_PK_ID, ';
      v_sql_string := v_sql_string ||                                'GDO_THEME_NAME) ';
      v_sql_string := v_sql_string || 'SELECT '||TO_CHAR(p_session_id)||', ';
      v_sql_string := v_sql_string ||         v_gt_pk_column||', ';
      v_sql_string := v_sql_string ||         ''''||v_gt_theme_name||''''||' ';
      v_sql_string := v_sql_string || 'FROM '||v_gt_table_name||' ';
 DECLARE
  v_tmp number;
 BEGIN
  v_tmp := p_value;
       v_sql_string := v_sql_string || 'WHERE '||v_gt_feature_fk_column||' = '||p_value;

 EXCEPTION
  WHEN value_error THEN
        v_sql_string := v_sql_string || 'WHERE '||v_gt_feature_fk_column||' = '||''''||p_value||'''';
 END;

--      dbms_output.put_line(v_sql_string );
 hig.execute_sql(v_sql_string,v_feedback);
   END;
--
---------------------------------------------------------------------------
--
   PROCEDURE    pop_ids_from_feature (p_session_id IN number, p_theme_id IN number ,  p_value IN varchar2)IS
      v_theme_name varchar2(30);
   BEGIN
      SELECT gt_theme_name
 INTO  v_theme_name
 FROM  gis_themes_all
 WHERE  gt_theme_id = p_theme_id;

 pop_ids_from_feature (p_session_id ,  v_theme_name,  p_value ) ;
   EXCEPTION
      WHEN no_data_found THEN
         NULL;
   END;
--
---------------------------------------------------------------------------
FUNCTION has_shape ( p_ne_id IN number ) RETURN boolean AS
--
   no_spatial EXCEPTION;
   PRAGMA EXCEPTION_INIT (no_spatial, -20001);
--
   l_string varchar2(2000);
--
   l_dummy  binary_integer;
   l_cur    nm3type.ref_cursor;
--
   l_retval boolean;
--
BEGIN
--
 --  if nm3sdm.prevent_operation( p_ne_id ) then
     l_string :=             'SELECT 1'
                  ||CHR(10)||' FROM  dual '
                  ||CHR(10)||'WHERE EXISTS (SELECT 1'
                  ||CHR(10)||'               FROM  '||get_spatial_table
                  ||CHR(10)||'              WHERE  '||get_spatial_pk_column||' = :ne_id'
                  ||CHR(10)||'             )';
     OPEN  l_cur FOR l_string USING p_ne_id;
     FETCH l_cur INTO l_dummy;
     l_retval := l_cur%FOUND;
     CLOSE l_cur;
--   else
--     l_retval := FALSE; -- data is held in an accessible form
--   end if;
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN no_spatial
    THEN
      RETURN FALSE;
--
END has_shape;
---------------------------------------------------------------------------
--
FUNCTION route_has_shape(pi_ne_id IN nm_elements.ne_id%TYPE
                        ) RETURN boolean IS

  TYPE typ_cs_sql IS REF CURSOR;  -- define weak REF CURSOR type
  c1 typ_cs_sql;                  -- declare cursor variable

  l_qry_str varchar2(32767);

  l_dummy pls_integer;

  l_retval boolean;

--
   no_spatial EXCEPTION;
   PRAGMA EXCEPTION_INIT (no_spatial, -20001);
--
BEGIN
  l_qry_str :=            'SELECT'
               ||CHR(10)||  '1'
               ||CHR(10)||'FROM'
               ||CHR(10)||   get_spatial_table || ','
               ||CHR(10)||  'nm_members'
               ||CHR(10)||'WHERE'
               ||CHR(10)||  'nm_ne_id_in = :p_ne_id'
               ||CHR(10)||'AND'
               ||CHR(10)||   get_spatial_pk_column || ' = nm_ne_id_of';

  OPEN c1 FOR l_qry_str USING pi_ne_id;
    FETCH c1 INTO l_dummy;
    IF c1%FOUND
    THEN
      l_retval := TRUE;
    ELSE
      l_retval := FALSE;
    END IF;
  CLOSE c1;

  RETURN l_retval;
--
EXCEPTION
--
   WHEN no_spatial
    THEN
      RETURN FALSE;
--
END route_has_shape;
--
---------------------------------------------------------------------------
--
FUNCTION num_shapes_on_route(pi_ne_id IN number
                            ) RETURN pls_integer IS

  l_string varchar2(4000);

  l_ne_rec nm_elements%ROWTYPE := nm3net.get_ne(pi_ne_id => pi_ne_id);

  l_count pls_integer := 0;
--
   no_spatial EXCEPTION;
   PRAGMA EXCEPTION_INIT (no_spatial, -20001);
--

BEGIN

  IF l_ne_rec.ne_type = 'S' THEN
    --we have a section so use has_shape
    IF has_shape(p_ne_id => pi_ne_id) THEN
      l_count := 1;
    END IF;

  ELSE

    IF l_ne_rec.ne_type = 'P' THEN
      --group of groups so use connect by
      l_string :=   'SELECT '
                  ||  'COUNT(*) '
                  ||'FROM '
                  ||  'nm_members '
                  ||'WHERE '
                  ||  'EXISTS (SELECT '
                  ||            '1 '
                  ||          'FROM '
                  ||             get_spatial_table || ' '
                  ||          'WHERE '
                  ||             get_spatial_pk_column || ' = nm_ne_id_of) '
                  ||'CONNECT BY '
                  ||  'PRIOR nm_ne_id_of = nm_ne_id_in '
                  ||'START WITH '
                  ||  'nm_ne_id_in = :p_ne_id ';

    ELSE
      --group of sections
      l_string :=   'SELECT '
                  ||  'COUNT(*) '
                  ||'FROM '
                  ||   get_spatial_table || ', '
                  ||  'nm_members '
                  ||'WHERE '
                  ||  'nm_ne_id_in = :p_ne_id '
                  ||'AND '
                  ||   get_spatial_pk_column || ' = nm_ne_id_of';
    END IF;

    EXECUTE IMMEDIATE l_string INTO l_count USING pi_ne_id;

  END IF;

  RETURN l_count;
--
EXCEPTION
--
   WHEN no_spatial
    THEN
      RETURN 0;

END num_shapes_on_route;
--
---------------------------------------------------------------------------
--
FUNCTION num_shapes_in_se(pi_nse_id IN nm_saved_extents.nse_id%TYPE
                         ) RETURN pls_integer IS

  l_qry_str varchar2(32767);

  l_count pls_integer;
--
   no_spatial EXCEPTION;
   PRAGMA EXCEPTION_INIT (no_spatial, -20001);

BEGIN
  l_qry_str :=            'SELECT'
               ||CHR(10)||  'COUNT(*)'
               ||CHR(10)||'FROM'
               ||CHR(10)||   get_spatial_table || ','
               ||CHR(10)||  'nm_saved_extent_member_datums'
               ||CHR(10)||'WHERE'
               ||CHR(10)||  'nsd_nse_id = :p_nse_id'
               ||CHR(10)||'AND'
               ||CHR(10)||   get_spatial_pk_column || ' = nsd_ne_id';

  EXECUTE IMMEDIATE l_qry_str INTO l_count USING pi_nse_id;

  RETURN l_count;
--
EXCEPTION
--
   WHEN no_spatial
    THEN
      RETURN 0;
END num_shapes_in_se;
--
---------------------------------------------------------------------------
--
FUNCTION get_spatial_table RETURN varchar2 AS
--
  CURSOR c1 IS
    SELECT gt_feature_table
     FROM gis_themes_all
    WHERE gt_route_theme = 'Y';
--
   retval gis_themes_all.gt_feature_table%TYPE;
--
BEGIN
--
   OPEN  c1;
   FETCH c1 INTO retval;
   IF c1%NOTFOUND
    THEN
      CLOSE c1;
      RAISE_APPLICATION_ERROR( -20001, 'Route theme not found');
   ELSE
      CLOSE c1;
      IF retval IS NULL
       THEN
         RAISE_APPLICATION_ERROR( -20001, 'Route theme table not found');
      END IF;
   END IF;
 --
   RETURN retval;
--
END get_spatial_table;
--
---------------------------------------------------------------------------
--
FUNCTION get_spatial_pk_column RETURN varchar2 AS
--
  CURSOR c1 IS
    SELECT gt_feature_pk_column
    FROM gis_themes_all
    WHERE gt_route_theme = 'Y';
--
   retval gis_themes_all.gt_feature_pk_column%TYPE;
--
BEGIN
--
   OPEN  c1;
   FETCH c1 INTO retval;
   IF c1%NOTFOUND
    THEN
      CLOSE c1;
      RAISE_APPLICATION_ERROR( -20001, 'Route theme not found');
   ELSE
     CLOSE c1;
     IF retval IS NULL
      THEN
        RAISE_APPLICATION_ERROR( -20001, 'Route theme PK column not found');
     END IF;
   END IF;
 --
   RETURN retval;
--
END get_spatial_pk_column;
--
---------------------------------------------------------------------------
--
FUNCTION get_gdo_for_session(pi_session_id IN gis_data_objects.gdo_session_id%TYPE
                            ) RETURN tab_gdo IS

  CURSOR c1(p_session_id IN gis_data_objects.gdo_session_id%TYPE) IS
    SELECT
      *
    FROM
      gis_data_objects gdo
    WHERE
      gdo.gdo_session_id = p_session_id;

  l_gdo_tab tab_gdo;

  i pls_integer := 0;

BEGIN
  FOR l_rec IN c1(p_session_id => pi_session_id)
  LOOP
    i := i + 1;

    l_gdo_tab(i).gdo_session_id := l_rec.gdo_session_id;
    l_gdo_tab(i).gdo_pk_id      := l_rec.gdo_pk_id;
    l_gdo_tab(i).gdo_rse_he_id  := l_rec.gdo_rse_he_id;
    l_gdo_tab(i).gdo_st_chain   := l_rec.gdo_st_chain;
    l_gdo_tab(i).gdo_end_chain  := l_rec.gdo_end_chain;
    l_gdo_tab(i).gdo_x_val      := l_rec.gdo_x_val;
    l_gdo_tab(i).gdo_y_val      := l_rec.gdo_y_val;
    l_gdo_tab(i).gdo_theme_name := l_rec.gdo_theme_name;
    l_gdo_tab(i).gdo_feature_id := l_rec.gdo_feature_id;
    l_gdo_tab(i).gdo_xsp        := l_rec.gdo_xsp;
    l_gdo_tab(i).gdo_offset     := l_rec.gdo_offset;
  END LOOP;

  RETURN l_gdo_tab;
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_gt (p_rec_gt nm_themes_all%ROWTYPE) IS
   l_rec_gt nm_themes_all%ROWTYPE := p_rec_gt;
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_gt');
--
   l_rec_gt.nth_location_updatable := NVL(l_rec_gt.nth_location_updatable, 'N');

   nm3ins.ins_nth (l_rec_gt);
--
   nm_debug.proc_end(g_package_name,'ins_gt');
--
END ins_gt;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_gtf (p_rec_gtf nm_theme_functions_all%ROWTYPE) IS
   l_rec_gtf nm_theme_functions_all%ROWTYPE;
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_gtf');
--
   -- Need to move seperately as the view does not have
   --  all the columns in which the table does
   l_rec_gtf.ntf_nth_theme_id       := p_rec_gtf.ntf_nth_theme_id;
   l_rec_gtf.ntf_hmo_module         := p_rec_gtf.ntf_hmo_module;
   l_rec_gtf.ntf_parameter          := p_rec_gtf.ntf_parameter;
   l_rec_gtf.ntf_menu_option        := p_rec_gtf.ntf_menu_option;
   l_rec_gtf.ntf_seen_in_gis        := 'Y';
--
   nm3ins.ins_ntf (l_rec_gtf);
--
   nm_debug.proc_end(g_package_name,'ins_gtf');
--
END ins_gtf;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_gthr (p_rec_gthr nm_theme_roles%ROWTYPE) IS
   l_rec_gthr nm_theme_roles%ROWTYPE := p_rec_gthr;
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_gthr');
--
   nm3ins.ins_nthr (l_rec_gthr);
--
   nm_debug.proc_end(g_package_name,'ins_gthr');
--
END ins_gthr;
--
---------------------------------------------------------------------------
--
FUNCTION pk_is_in_theme(pi_theme_id IN gis_themes.gt_theme_id%TYPE
                       ,pi_pk_val   IN gis_data_objects.gdo_pk_id%TYPE) 
  RETURN varchar2 
IS
--
  l_dummy           PLS_INTEGER;
  l_gt_rec          GIS_THEMES%ROWTYPE;
  c_nl     CONSTANT VARCHAR2(1) := CHR(10);
  l_qry             VARCHAR2(32767);
  l_retval          VARCHAR2(10);
--
BEGIN
--
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'pk_is_in_theme');
--
  --get theme details
  l_gt_rec := get_gt(pi_gt_theme_id => pi_theme_id);
--
  l_qry :=            'SELECT'
           || c_nl || '  1'
           || c_nl || 'FROM'
           || c_nl || '  dual'
           || c_nl || 'WHERE'
           || c_nl || '  EXISTS(SELECT'
           || c_nl || '           1'
           || c_nl || '         FROM'
           || c_nl || '           ' || l_gt_rec.gt_table_name
           || c_nl || '         WHERE';

  IF l_gt_rec.gt_where IS NOT NULL
  THEN
    --add where clause from theme
    IF UPPER(SUBSTR(l_gt_rec.gt_where, 1, 5)) = 'WHERE'
    THEN
      l_qry := l_qry||c_nl||'           '||SUBSTR(l_gt_rec.gt_where, 6);
    ELSE
      l_qry := l_qry||c_nl||'           '||l_gt_rec.gt_where;
    END IF;
  --
    l_qry := l_qry||c_nl||'         AND';
  --
  END IF;

  --add pk clause
  l_qry := l_qry||c_nl||'           '||l_gt_rec.gt_pk_column||' = :pk_val)';

  DECLARE

    e_table_not_found EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_table_not_found, -942);
    e_invalid_table EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_invalid_table, -903);

  BEGIN
    EXECUTE IMMEDIATE l_qry INTO l_dummy USING pi_pk_val;
    l_retval := nm3type.c_true;

  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
      l_retval := nm3type.c_false;

    WHEN TOO_MANY_ROWS
    THEN
      l_retval := nm3type.c_true;

    WHEN e_table_not_found
    THEN
      hig.raise_ner(pi_appl               => nm3type.c_hig
                   ,pi_id                 => 149
                   ,pi_supplementary_info =>    CHR(10)
                                             || CHR(10) || l_gt_rec.gt_theme_name
                                             || CHR(10) || l_gt_rec.gt_table_name);
    WHEN e_invalid_table
    THEN
      l_retval := nm3type.c_false;
    WHEN OTHERS
    THEN
      hig.raise_ner(pi_appl               => nm3type.c_hig
                   ,pi_id                 => 150
                   ,pi_supplementary_info =>    CHR(10)
                                             || CHR(10) || l_gt_rec.gt_theme_name
                                             || CHR(10) || nm3flx.parse_error_message(pi_msg => SQLERRM));


  END;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'pk_is_in_theme');

  RETURN l_retval;

END pk_is_in_theme;
--
---------------------------------------------------------------------------
--
FUNCTION get_theme_for_module(pi_module IN hig_modules.hmo_module%TYPE
                             ,pi_pk_val IN gis_data_objects.gdo_pk_id%TYPE DEFAULT NULL
                             ) RETURN gis_themes.gt_theme_id%TYPE IS

  c_nl CONSTANT varchar2(1) := CHR(10);

  l_qry nm3type.max_varchar2;

  l_retval gis_themes.gt_theme_id%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_theme_for_module');

  l_qry :=            'SELECT'
      || c_nl || '  gtf.gtf_gt_theme_id'
      || c_nl || 'FROM'
      || c_nl || '  gis_theme_functions_all gtf'
      || c_nl || 'WHERE'
      || c_nl || '  gtf.gtf_hmo_module = :p_module';

  IF pi_pk_val IS NOT NULL
  THEN
    l_qry :=            l_qry
             || c_nl || 'AND'
             || c_nl || '  higgis.pk_is_in_theme(gtf_gt_theme_id'
             || c_nl || '                       ,' || pi_pk_val || ') = nm3type.get_true';
  END IF;

  EXECUTE IMMEDIATE l_qry INTO l_retval USING pi_module;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_theme_for_module');

  RETURN l_retval;

EXCEPTION
  WHEN too_many_rows
  THEN
    RAISE_APPLICATION_ERROR(-20090, 'Module has more than 1 theme.');

  WHEN no_data_found
  THEN
    RAISE_APPLICATION_ERROR(-20091, 'Module has no themes.');

END get_theme_for_module;
--
---------------------------------------------------------------------------
--
FUNCTION get_nt(pi_nth_theme_id IN nm_themes_all.nth_theme_id%TYPE
               ) RETURN nm_themes_all%ROWTYPE IS
BEGIN
   RETURN nm3get.get_nth (pi_nth_theme_id);
END get_nt;
--
---------------------------------------------------------------------------
--
FUNCTION get_gt(pi_gt_theme_id IN gis_themes.gt_theme_id%TYPE
               ) RETURN gis_themes%ROWTYPE IS
--
-- This procedure exists for backwards compatability to gis_themes
--

   CURSOR cs_gt IS
   SELECT *
    FROM  gis_themes
   WHERE  gt_theme_id = pi_gt_theme_id;
--
   l_found  boolean;
   l_retval gis_themes%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_gt');
--
   OPEN  cs_gt;
   FETCH cs_gt INTO l_retval;
   l_found := cs_gt%FOUND;
   CLOSE cs_gt;
--
--   IF pi_raise_not_found AND NOT l_found
--    THEN
--      hig.raise_ner (pi_appl               => nm3type.c_hig
--                    ,pi_id                 => 67
--                    ,pi_sqlcode            => pi_not_found_sqlcode
--                    ,pi_supplementary_info => 'nm_themes_all (NTH_PK)'
--                                              ||CHR(10)||'nth_theme_id => '||pi_nth_theme_id
--                    );
--   END IF;
--
   nm_debug.proc_end(g_package_name,'get_gt');
--
   RETURN l_retval;

END get_gt;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_nga (p_nse_id nm_saved_extents.nse_id%TYPE DEFAULT NULL) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'set_nga');
--
   nm3user.set_user_roi_details (pi_roi_id   => p_nse_id
                                ,pi_roi_type => 'E'
                                );
--
   nm_debug.proc_end(g_package_name,'set_nga');
--
END set_nga;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nga RETURN nm_saved_extents.nse_id%TYPE IS
   l_rec_roi_detail nm3extent.rec_roi_details;
   l_nse_id         nm_saved_extents.nse_id%TYPE;
BEGIN
--
   l_rec_roi_detail := nm3user.get_user_roi_details;
--
   IF l_rec_roi_detail.roi_type = 'E'
    THEN
      l_nse_id := l_rec_roi_detail.roi_id;
   END IF;
--
   RETURN l_nse_id;
--
END get_nga;
--
---------------------------------------------------------------------------
--
FUNCTION get_user_mode_for_theme (pi_gt_theme_id gis_theme_roles.gthr_theme_id%TYPE
                                 ,pi_user        hig_user_roles.hur_username%TYPE DEFAULT Sys_Context('NM3_SECURITY_CTX','USERNAME')
                                 ) RETURN gis_theme_roles.gthr_mode%TYPE IS
--
   CURSOR cs_gthr (c_theme_id gis_theme_roles.gthr_theme_id%TYPE
                  ,c_user     hig_user_roles.hur_username%TYPE
                  ) IS
   SELECT gthr_mode
    FROM  gis_theme_roles
         ,hig_user_roles
   WHERE  gthr_theme_id = c_theme_id
    AND   gthr_role     = hur_role
    AND   hur_username  = c_user
   ORDER BY gthr_mode ASC;
--
   l_retval gis_theme_roles.gthr_mode%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_user_mode_for_theme');
--
   OPEN  cs_gthr (pi_gt_theme_id, pi_user);
   FETCH cs_gthr INTO l_retval;
   CLOSE cs_gthr;
--
   nm_debug.proc_end(g_package_name,'get_user_mode_for_theme');
--
   RETURN l_retval;
--
END get_user_mode_for_theme;
--
-----------------------------------------------------------------------------
--
FUNCTION is_product_locatable_from_gis (pi_hpr_product hig_products.hpr_product%TYPE
                                       ) RETURN varchar2 IS
BEGIN
   RETURN nm3flx.i_t_e (pi_hpr_product IN (nm3type.c_net
                                          ,nm3type.c_acc
--                                          ,nm3type.c_str
                                          )
                       ,'Y'
                       ,'N'
                       );
END is_product_locatable_from_gis;
--
-----------------------------------------------------------------------------
--
FUNCTION get_roi_name  RETURN varchar2 IS
BEGIN
   RETURN SUBSTR(hig.get_ner (nm3type.c_net, 299).ner_descr,1,30);
END get_roi_name;
--
-----------------------------------------------------------------------------
--
FUNCTION get_roi_descr RETURN varchar2 IS
BEGIN
   RETURN hig.get_ner (nm3type.c_net, 299).ner_descr;
END get_roi_descr;
--
---------------------------------------------------------------------------
--
PROCEDURE create_gdo (pi_source_id                 IN     nm_pbi_query_results.nqr_source_id%TYPE
                     ,pi_source                    IN     nm_pbi_query_results.nqr_source%TYPE
                     ,pi_begin_mp                  IN     nm_members.nm_begin_mp%TYPE DEFAULT NULL
                     ,pi_end_mp                    IN     nm_members.nm_end_mp%TYPE DEFAULT NULL
                     ,pi_default_source_as_parent  IN     boolean DEFAULT FALSE
                     ,pi_ignore_non_linear_parents IN     boolean DEFAULT FALSE
                     ,pi_gt_theme_name             IN     gis_themes.gt_theme_name%TYPE
                     ,po_gdo_session_id               OUT gis_data_objects.gdo_session_id%TYPE
                     ) IS
   PRAGMA autonomous_transaction;
--
   l_nte_job_id     nm_nw_temp_extents.nte_job_id%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_gdo');
--
   nm3extent.create_temp_ne (pi_source_id                 => pi_source_id
                            ,pi_source                    => pi_source
                            ,pi_begin_mp                  => pi_begin_mp
                            ,pi_end_mp                    => pi_end_mp
                            ,po_job_id                    => l_nte_job_id
                            ,pi_default_source_as_parent  => pi_default_source_as_parent
                            ,pi_ignore_non_linear_parents => pi_ignore_non_linear_parents
                            );
--
   po_gdo_session_id := higgis.get_session_id;
--
   INSERT INTO gis_data_objects
         (gdo_session_id
         ,gdo_pk_id
         ,gdo_rse_he_id
         ,gdo_st_chain
         ,gdo_end_chain
         ,gdo_theme_name
         )
   SELECT po_gdo_session_id
         ,nte_ne_id_of
         ,nte_ne_id_of
         ,nte_begin_mp
         ,nte_end_mp
         ,pi_gt_theme_name
    FROM  nm_nw_temp_extents
   WHERE  nte_job_id = l_nte_job_id;
--
   nm_debug.proc_end(g_package_name,'create_gdo');
--
   COMMIT;
--
END create_gdo;
--
---------------------------------------------------------------------------
--
FUNCTION derive_das_table_from_gt (p_gt_table_name  gis_themes.gt_table_name%TYPE
                                  ,p_gt_hpr_product gis_themes.gt_hpr_product%TYPE
                                  ) RETURN varchar2 IS
--
   l_retval             varchar2(30);
   l_found              boolean;
   l_rec_dgt            doc_gateways%ROWTYPE;
   l_rec_dgs            doc_gate_syns%ROWTYPE;
   l_table_name         gis_themes.gt_table_name%TYPE;
--
   CURSOR cs_nit (c_table varchar2) IS
   SELECT 'NM_INV_ITEMS'
     FROM  nm_inv_types
    WHERE  nm3inv_view.derive_inv_type_view_name(nit_inv_type) = c_table;
--
   CURSOR cur_syn (c_table varchar2) IS
   SELECT dgs_dgt_table_name
     FROM  DOC_GATE_SYNS
    WHERE  dgs_table_syn = c_table;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'derive_das_table_from_gt');
--
   l_table_name := UPPER(p_gt_table_name);
--
   IF SUBSTR(l_table_name,1,Length(Sys_Context('NM3CORE','APPLICATION_OWNER')||'.')) = Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'
    THEN
      l_table_name := SUBSTR(l_table_name,Length(Sys_Context('NM3CORE','APPLICATION_OWNER')||'.')+1);
   END IF;
--
   IF p_gt_hpr_product = nm3type.c_net
    THEN
      OPEN  cs_nit (l_table_name);
      FETCH cs_nit INTO l_retval;
      l_found := cs_nit%FOUND;
      CLOSE cs_nit;
      IF NOT l_found
       THEN
         l_retval := l_table_name;
      END IF;
   --
--   ELSIF 1=2 -- other product specific derivation would have to go here (in dynamic sql).
--    THEN
--      Null;
   ELSE
      l_retval := l_table_name;
   END IF;
--
   l_rec_dgt := nm3get.get_dgt (pi_dgt_table_name => l_retval
                               , pi_raise_not_found    => FALSE);
--
   IF l_rec_dgt.dgt_table_name IS NULL THEN
     OPEN cur_syn (c_table => l_retval);
     FETCH cur_syn INTO l_retval;
     CLOSE cur_syn;
   --
     l_rec_dgt := nm3get.get_dgt ( pi_dgt_table_name => l_retval
                                 , pi_raise_not_found    => FALSE);
   --
     IF l_rec_dgt.dgt_table_name IS NULL THEN
       hig.raise_ner( pi_appl => 'NET'
                    , pi_id => 466);
     END IF;
   --
   END IF;
--
   nm_debug.proc_end(g_package_name,'derive_das_table_from_gt');
--
   RETURN l_retval;
--
END derive_das_table_from_gt;
--
---------------------------------------------------------------------------
--
PROCEDURE get_theme_links(pi_module           IN     hig_modules.hmo_module%TYPE
                         ,pi_table_name       IN     varchar2
                         ,pi_col_name         IN     varchar2 DEFAULT NULL
                         ,po_theme_id_tab        OUT nm3type.tab_number
                         ,po_theme_name_tab      OUT nm3type.tab_varchar30
                         ,po_theme_pk_col_tab    OUT nm3type.tab_varchar30
                         ) IS

BEGIN
  SELECT
    gt.gt_theme_id,
    gt.gt_theme_name,
    gt.gt_pk_column
  BULK COLLECT INTO
    po_theme_id_tab,
    po_theme_name_tab,
    po_theme_pk_col_tab
  FROM
    gis_themes          gt,
    gis_theme_functions gtf
  WHERE
    gt.gt_table_name = pi_table_name
  AND
    gt.gt_pk_column = NVL(pi_col_name, gt.gt_pk_column)
  AND
    gtf.gtf_hmo_module = pi_module
  AND
    gt.gt_theme_id = gtf.gtf_gt_theme_id;

END get_theme_links;
--
---------------------------------------------------------------------------
--
PROCEDURE insert_gis_autonomous(  p_gdo_session_id  IN      gis_data_objects.gdo_session_id%TYPE
                                , p_gdo_pk_id       IN          gis_data_objects.gdo_pk_id%TYPE
                                , p_gdo_rse_he_id   IN      gis_data_objects.gdo_rse_he_id%TYPE
                                , p_gdo_st_chain    IN       gis_data_objects.gdo_st_chain%TYPE
                                , p_gdo_end_chain   IN    gis_data_objects.gdo_end_chain%TYPE
                                , p_gdo_x_val       IN         gis_data_objects.gdo_x_val%TYPE
                                , p_gdo_y_val       IN         gis_data_objects.gdo_y_val%TYPE
                                , p_gdo_theme_name  IN  gis_data_objects.gdo_theme_name%TYPE
                                , p_gdo_feature_id  IN    gis_data_objects.gdo_feature_id%TYPE
                                , p_gdo_xsp         IN           gis_data_objects.gdo_xsp%TYPE
                                , p_gdo_offset      IN       gis_data_objects.gdo_offset%TYPE
                                , p_gdo_seq_no      IN       gis_data_objects.gdo_seq_no%TYPE )IS

      PRAGMA autonomous_transaction;

BEGIN

   INSERT INTO gis_data_objects
   (
    gdo_session_id
   ,gdo_pk_id
   ,gdo_rse_he_id
   ,gdo_st_chain
   ,gdo_end_chain
   ,gdo_x_val
   ,gdo_y_val
   ,gdo_theme_name
   ,gdo_feature_id
   ,gdo_xsp
   ,gdo_offset
   ,gdo_seq_no
   )
   VALUES
   (
    p_gdo_session_id
   ,p_gdo_pk_id
   ,p_gdo_rse_he_id
   ,p_gdo_st_chain
   ,p_gdo_end_chain
   ,p_gdo_x_val
   ,p_gdo_y_val
   ,p_gdo_theme_name
   ,p_gdo_feature_id
   ,p_gdo_xsp
   ,p_gdo_offset
   ,p_gdo_seq_no
   );

   COMMIT;

END insert_gis_autonomous;
--
---------------------------------------------------------------------------
--
FUNCTION get_inv_module_theme ( pi_module IN VARCHAR2,
                                pi_inv_type IN VARCHAR2 )
RETURN nm_theme_array IS

   CURSOR c1 (c_module IN VARCHAR2,
              c_inv_type IN VARCHAR2) IS
   SELECT a.theme, a.theme_id
   FROM (SELECT gt_theme_name theme, NULL, gtf_gt_theme_id theme_id
         FROM gis_theme_functions_all, gis_themes, nm_inv_themes
         WHERE nith_nth_theme_id = gt_theme_id
         AND nith_nit_id = c_inv_type
         AND gtf_hmo_module = c_module
         AND gt_theme_id = gtf_gt_theme_id) a;

   retval nm_theme_array;

BEGIN

   retval := nm_theme_array( nm_theme_array_type ( null ));

   FOR irec IN c1( pi_module, pi_inv_type)  LOOP

      IF c1%rowcount = 1 THEN

         retval := nm_theme_array( nm_theme_array_type ( nm_theme_entry(irec.theme_id )));

      ELSE

         retval := retval.add_theme( irec.theme_id );

      END IF;

   END LOOP;

   RETURN retval;

END get_inv_module_theme;
--
---------------------------------------------------------------------------
--
FUNCTION get_dynamic_theme_query ( pi_session_id in gis_data_objects.gdo_session_id%type ) return varchar2 is

l_gdo   gis_data_objects%rowtype;
l_nth   nm_themes_all%rowtype;
retval  nm3type.max_varchar2;

function is_theme_merge_query( p_nth nm_themes_all%rowtype ) return Boolean is
begin
  return ( p_nth.nth_feature_table = 'NM_MRG_GEOMETRY' );
end;

function get_gdo (pi_session_id in gis_data_objects.gdo_session_id%type ) return gis_data_objects%rowtype is
retval gis_data_objects%rowtype;
begin
  select *
  into retval
  from gis_data_objects
  where gdo_session_id = pi_session_id;
  return retval;
end;

begin

  l_gdo := get_gdo( pi_session_id );
  l_nth := nm3get.get_nth( l_gdo.gdo_theme_name );

  if l_nth.nth_dynamic_theme = 'Y' then

    if is_theme_merge_query( l_nth ) then

      retval := nm3mrg_sdo.get_mrg_dynamic_theme_query( l_gdo.gdo_pk_id );

 else

   raise_application_error(-20001, 'This functionality is not available yet' );

 end if;

  else

   raise_application_error(-20001, 'This is not a dynamic theme');

  end if;

  return retval;

end;
--
---------------------------------------------------------------------------
--
PROCEDURE get_themes_for_ne_id
            ( pi_ne_id          IN     nm_elements.ne_id%TYPE
            , pi_module         IN     hig_modules.hmo_module%TYPE
            , pi_join_to_msv    IN     BOOLEAN
            , po_nth_theme_id      OUT NUMBER
            , po_lov_sql           OUT VARCHAR2
            , po_found_true_nth    OUT BOOLEAN )
IS
--
  TYPE rec_vnnt      IS RECORD
                          (  vnnt_nth_theme_name v_nm_net_themes.vnnt_nth_theme_name%TYPE
                           , dummy               VARCHAR2(10)
                           , vnnt_nth_theme_id   v_nm_net_themes.vnnt_nth_theme_id%TYPE );
  TYPE tab_vnnt      IS TABLE OF rec_vnnt INDEX BY BINARY_INTEGER;
--
  l_tab_vnnt         tab_vnnt;
  l_tab_vnnt_datum   tab_vnnt;
  lf                 VARCHAR2(10) := chr(10);
  l_ne               nm_elements%ROWTYPE;
  l_tab_nth_theme_id nm3type.tab_number;
--
  b_group_element    BOOLEAN      := FALSE;
  b_linear_element   BOOLEAN      := FALSE;
  b_datum_element    BOOLEAN      := FALSE;
  b_found_true_nth   BOOLEAN      := TRUE;
  b_join_to_msv      BOOLEAN      := pi_join_to_msv;
  g_group_type       nm_elements.ne_gty_group_type%TYPE;
--
  l_sql              nm3type.max_varchar2;
--
  CURSOR get_datum_layer_from_group
           ( cp_gty_type IN nm_types.nt_type%TYPE )
  IS
    SELECT UNIQUE vnnt_nth_theme_name, NULL, vnnt_nth_theme_id
      FROM v_nm_net_themes
         , v_nm_msv_map_def
         , gis_theme_functions
         , nm_nt_groupings
     -- Task 0110297 and 0110288
     -- Use USER option value
     WHERE vnmd_name           = hig.get_user_or_sys_opt('WEBMAPNAME') 
       AND nng_group_type      = cp_gty_type
       AND nng_nt_type         = vnnt_nt_type
       AND vnnt_gty_type       IS NULL
       AND gtf_gt_theme_id     = vnnt_nth_theme_id
       AND gtf_hmo_module      = pi_module;
--
  l_datum_sql        nm3type.max_varchar2;
--
--   l_group_sql        nm3type.max_varchar2
--   := ' SELECT UNIQUE vnnt_nth_theme_name, NULL, vnnt_nth_theme_id '||lf||
--      '   FROM v_nm_net_themes '||lf||
--      '      , v_nm_msv_map_def '||lf||
--      '      , gis_theme_functions '||lf||
--      '      , nm_nt_groupings '||lf||
--      '  WHERE vnmd_name           = hig.get_sysopt(''WEBMAPNAME'')'||lf||
--      '    AND nng_group_type      = '||nm3flx.string(l_ne.ne_gty_group_type)||lf||
--      '    AND nng_nt_type         = vnnt_nt_type '||lf||
--      '    AND vnnt_gty_type       = vnnt_gty_type '||lf||
--      '    AND gtf_gt_theme_id     = vnnt_nth_theme_id '||lf||
--      '    AND gtf_hmo_module      = '||pi_module;
-----------------------------------------------------------------------------
BEGIN
-----------------------------------------------------------------------------
--
-- Validate ne_id and get rowtype
  l_ne := nm3get.get_ne (pi_ne_id);
  g_group_type       := l_ne.ne_gty_group_type;
--
-- Set group and/or datum flag and linear flag
-- Can be a datum group
  IF l_ne.ne_gty_group_type IS NOT NULL
  THEN
    b_group_element := TRUE;
  END IF;
  IF nm3get.get_nt(pi_nt_type => l_ne.ne_nt_type).nt_datum = 'Y'
  THEN
    b_datum_element := TRUE;
  END IF;
  IF nm3get.get_nt(pi_nt_type => l_ne.ne_nt_type).nt_linear = 'Y'
  THEN
    b_linear_element := TRUE;
  END IF;
--
  l_sql := ' SELECT vnnt_nth_theme_name, NULL, vnnt_nth_theme_id '
     ||lf||'   FROM v_nm_net_themes '
     ||lf||'      , gis_theme_functions ';
--
  IF b_join_to_msv
  THEN
    l_sql := l_sql
    ||lf||'       , v_nm_msv_map_def ';
  END IF;
--
  l_sql := l_sql
    ||lf||'  WHERE gtf_gt_theme_id = vnnt_nth_theme_id '
    ||lf||'    AND gtf_hmo_module = '||nm3flx.string(pi_module);
--
  IF b_join_to_msv
  THEN
    l_sql := l_sql
    --||lf||'    AND vnmd_name = hig.get_sysopt (''WEBMAPNAME'') '
    
    -- Task 0110288 and 0110297
    -- Use the USER option value if it exists
    ||lf||'    AND vnmd_name = hig.get_user_or_sys_opt (''WEBMAPNAME'') '
    ||lf||'    AND vnnt_nth_theme_name = vnmd_theme_name ';
  END IF;
--
  l_sql := l_sql
    ||lf||'    AND EXISTS '
    ||lf||'      ( SELECT 1 FROM DUAL '
    ||lf||'        WHERE nm3sdo.element_has_shape (vnnt_nth_theme_id,'||pi_ne_id||') = ''TRUE'' )';
--
--  nm_debug.debug_on;
--  nm_debug.debug(l_sql);
  EXECUTE IMMEDIATE l_sql
  BULK COLLECT INTO l_tab_vnnt;

--
  IF l_tab_vnnt.COUNT < 1
  THEN
    IF l_ne.ne_type NOT IN ('S','D')
    THEN
    --
     l_datum_sql := ' SELECT UNIQUE vnnt_nth_theme_name, NULL, vnnt_nth_theme_id '||lf||
     '   FROM v_nm_net_themes '||lf||
     '      , v_nm_msv_map_def '||lf||
     '      , gis_theme_functions '||lf||
     '      , nm_nt_groupings '||lf||
     -- Task 0110288 and 0110297
     -- Use the USER option value if it exists
     --'  WHERE vnmd_name           = hig.get_sysopt(''WEBMAPNAME'')'||lf||
     '  WHERE vnmd_name           = hig.get_user_or_sys_opt(''WEBMAPNAME'')'||lf||
     '    AND nng_group_type      = '||nm3flx.string(l_ne.ne_gty_group_type)||lf||
     '    AND nng_nt_type         = vnnt_nt_type '||lf||
     '    AND vnnt_gty_type       IS NULL '||lf||
     '    AND gtf_gt_theme_id     = vnnt_nth_theme_id '||lf||
     '    AND gtf_hmo_module      = '||nm3flx.string(pi_module);
    --
       OPEN get_datum_layer_from_group ( l_ne.ne_gty_group_type );
      FETCH get_datum_layer_from_group
       BULK COLLECT INTO l_tab_vnnt_datum;
      CLOSE get_datum_layer_from_group;
    --
      IF l_tab_vnnt_datum.COUNT = 1
      THEN
        po_nth_theme_id    := l_tab_vnnt_datum(1) .vnnt_nth_theme_id;
        po_lov_sql         := NULL;
        po_found_true_nth  := FALSE;
      ELSIF l_tab_vnnt_datum.COUNT > 1
      THEN
        po_nth_theme_id    := -1;
        po_lov_sql         := l_datum_sql;
        po_found_true_nth  := FALSE;
      ELSE
        RAISE_APPLICATION_ERROR (-20001, 'No Themes are available for '||l_ne.ne_unique);
      END IF;
    --
    ELSE
      RAISE_APPLICATION_ERROR (-20001, 'No Themes are available for '||l_ne.ne_unique);
    END IF;
--
  ELSIF l_tab_vnnt.COUNT = 1
    THEN
      po_nth_theme_id    := l_tab_vnnt(1).vnnt_nth_theme_id;
      po_lov_sql         := NULL;
      po_found_true_nth  := TRUE;
--
  ELSIF l_tab_vnnt.COUNT > 1
    THEN
      -- Return LOV SQL for ext LOV
      po_nth_theme_id    := -1;
      po_lov_sql         := l_sql;
      po_found_true_nth  := TRUE;

  END IF;
--
END get_themes_for_ne_id;
--
-----------------------------------------------------------------------------
--
END higgis;
/
