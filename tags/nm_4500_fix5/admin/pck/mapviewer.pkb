CREATE OR REPLACE PACKAGE BODY Mapviewer AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/mapviewer.pkb-arc   2.8   May 16 2012 11:47:08   Steve.Cooper  $
--       Module Name      : $Workfile:   mapviewer.pkb  $
--       Date into PVCS   : $Date:   May 16 2012 11:47:08  $
--       Date fetched Out : $Modtime:   May 16 2012 11:45:04  $
--       PVCS Version     : $Revision:   2.8  $


--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
   g_body_sccsid     CONSTANT  VARCHAR2(30) := '"$Revision:   2.8  $"';


FUNCTION Get_Scale RETURN NUMBER;

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
-----------------------------------------------------------------------------
--
PROCEDURE set_cent_size
           ( p_theme_id   IN NUMBER
           , p_feature_id IN VARCHAR) AS

g_sql_string VARCHAR2(2000);

BEGIN

   BEGIN
      g_sql_string := 'insert into centsize ';
      g_sql_string := g_sql_string||'select nm3sdo.get_centre_and_size(';
      g_sql_string := g_sql_string||p_theme_id;
      g_sql_string := g_sql_string||',';
      g_sql_string := g_sql_string||''''||p_feature_id||'''';
      g_sql_string := g_sql_string||') from dual';

      EXECUTE IMMEDIATE G_SQL_STRING;
      COMMIT;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         NULL;
   END;

END set_cent_size;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_cent_size_gdo
            ( p_theme_id   IN NUMBER
            , p_session_id IN NUMBER) AS

   g_sql_string VARCHAR2(2000);

BEGIN

  BEGIN
     g_sql_string := 'insert into centsize ';
     g_sql_string := g_sql_string||'select nm3sdo.get_gdo_centre_and_size(';
     g_sql_string := g_sql_string||p_session_id;
     g_sql_string := g_sql_string||') from dual';

     EXECUTE IMMEDIATE G_SQL_STRING;
     COMMIT;

   EXCEPTION
     WHEN NO_DATA_FOUND THEN
        NULL;
   END;

END set_cent_size_gdo;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_cent_size_theme AS

   g_sql_string VARCHAR2(2000);

   l_srid    NUMBER;
   l_diminfo mdsys.sdo_dim_array;
   l_geom    mdsys.sdo_geometry;

BEGIN

   BEGIN
     Select   nae.Nae_Extent
     Into     l_Geom
     From     Hig_Users         hu,
              Nm_Admin_Extents  nae
     Where    hu.Hus_User_Id        =     To_Number(Sys_Context('NM3CORE','USER_ID')) 
     And      nae.Nae_Admin_Unit    =     hu.Hus_Admin_Unit;
     
   exception
     when others then   
   
       Nm3sdo.set_diminfo_and_srid( Nm3sdo.get_nw_themes, l_diminfo, l_srid );

       l_geom := Nm3sdo.convert_dim_array_to_mbr( l_diminfo );
       
   END;       
   
   l_geom := Nm3sdo.get_centre_and_size(l_geom); 
--   IF l_srid IS NULL THEN

     BEGIN

       g_conversion_factor := Get_Scale;

     EXCEPTION
       WHEN OTHERS THEN
	     g_conversion_factor := 1;
     END;

--   ELSE

--     g_conversion_factor := 1;

--   END IF;

   BEGIN

      g_sql_string := 'insert into centsize ';
      g_sql_string := g_sql_string||'values (:l_geom )';

      EXECUTE IMMEDIATE g_sql_string USING l_geom;
      COMMIT;

      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         NULL;
   END;
END set_cent_size_theme;
--
-----------------------------------------------------------------------------
--
PROCEDURE insert_gdo
            ( pi_session_id IN gis_data_objects.GDO_SESSION_ID%TYPE
            , pi_theme_name IN gis_data_objects.GDO_THEME_NAME%TYPE DEFAULT NULL
            , pi_pk_id      IN gis_data_objects.GDO_PK_ID%TYPE
            , pi_x_val      IN gis_data_objects.GDO_X_VAL%TYPE DEFAULT NULL
            , pi_y_val      IN gis_data_objects.GDO_Y_VAL%TYPE DEFAULT NULL
            , pi_seq        IN gis_data_objects.GDO_SEQ_NO%TYPE
            , pi_rse_he_id  IN gis_data_objects.gdo_rse_he_id%TYPE DEFAULT NULL
            , pi_st_chain   IN gis_data_objects.gdo_st_chain%TYPE DEFAULT NULL
            , pi_end_chain  IN gis_data_objects.gdo_end_chain%TYPE DEFAULT NULL
            , pi_feature_id IN gis_data_objects.gdo_feature_id%TYPE DEFAULT NULL
            , pi_xsp        IN gis_data_objects.gdo_xsp%TYPE DEFAULT NULL
            , pi_offset     IN gis_data_objects.gdo_offset%TYPE DEFAULT NULL
            ) AS

BEGIN

  INSERT INTO gis_data_objects
     ( gdo_session_id
	 , gdo_theme_name
	 , gdo_pk_id
	 , gdo_x_val
	 , gdo_y_val
	 , gdo_seq_no
         , gdo_rse_he_id
         , gdo_st_chain
         , gdo_end_chain
         , gdo_feature_id
         , gdo_xsp
         , gdo_offset)
  VALUES
     ( pi_session_id
	 , pi_theme_name
	 , pi_pk_id
	 , pi_x_val
	 , pi_y_val
	 , pi_seq
         , pi_rse_he_id
         , pi_st_chain
         , pi_end_chain
         , pi_feature_id
         , pi_xsp
         , pi_offset);

  COMMIT;

END insert_gdo;
--
-----------------------------------------------------------------------------
--
PROCEDURE insert_gdo_from_query
            ( pi_session_id  IN  gis_data_objects.GDO_SESSION_ID%TYPE
            , pi_pk_name     IN  VARCHAR2
            , pi_theme_name  IN  gis_data_objects.GDO_THEME_NAME%TYPE DEFAULT NULL
            , pi_theme_table IN  VARCHAR2
            , pi_predicate   IN  VARCHAR2
            , pi_query_col   IN  VARCHAR2
            ) AS
   g_sql_string VARCHAR2(2000);

BEGIN

   g_sql_string := 'insert into gis_data_objects (GDO_SESSION_ID, GDO_PK_ID, GDO_THEME_NAME) ';
   g_sql_string := g_sql_string || 'select '||pi_session_id||','||pi_pk_name||','||''''||pi_theme_name||''''||' ';
   g_sql_string := g_sql_string || 'from '||pi_theme_table;
   g_sql_string := g_sql_string || ' where upper('||pi_query_col||') like upper('||''''||pi_predicate||''''||')';

   EXECUTE IMMEDIATE g_sql_string;
   COMMIT;

END insert_gdo_from_query;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_centsize AS
BEGIN
   DELETE centsize;
   COMMIT;
END clear_centsize;
--
-----------------------------------------------------------------------------
--
PROCEDURE commit_centsize AS
BEGIN
   COMMIT;
END commit_centsize;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_pem
              ( pi_asset_id     IN  nm_inv_items.iit_ne_id%TYPE
              , pi_x_val        IN  docs.doc_compl_east%TYPE
              , pi_y_val        IN  docs.doc_compl_north%TYPE
              , pi_lr_ne_id     IN  nm_elements.ne_id%TYPE
              , pi_lr_offset    IN  NUMBER
              , pi_inv_theme_id IN  nm_themes_all.nth_theme_id%TYPE
              , pi_err_sequence IN  NUMBER
              , pi_username     IN  hig_users.hus_username%TYPE DEFAULT Sys_Context('NM3_SECURITY_CTX','USERNAME')
              , pi_session_id   IN  gis_data_objects.gdo_session_id%TYPE)
   AS -- clb 21062010 - task 0109021

   err_num  NUMBER;
   err_msg  VARCHAR2(100);
   l_doc_id NUMBER;
   l_asset_id NUMBER;

BEGIN
--
  l_asset_id := pi_asset_id;
  IF l_asset_id = 0
    THEN l_asset_id := NULL;
  END IF;
--
   EXECUTE IMMEDIATE
      'BEGIN '||
      '  pem.create_enquiry_from_xy ( :l_asset_id, :pi_x_val, :pi_y_val, :l_doc_id, :pi_lr_ne_id, :pi_lr_offset, :pi_inv_theme_id, :pi_username ); '||
      'END;'
   USING IN l_asset_id
       , IN pi_x_val
       , IN pi_y_val
       , IN OUT l_doc_id
       , IN pi_lr_ne_id
       , IN pi_lr_offset
       , IN pi_inv_theme_id
       , IN pi_username;

  /*
  || clb 21062010 - task 0109021 :Added call to insert_gdo 
  */
  insert_gdo (pi_session_id => pi_session_id
            , pi_theme_name => '0'
            , pi_pk_id      => l_doc_id
            , pi_x_val      => 0
            , pi_y_val      => 0
            , pi_seq        => 0
            );
            
   COMMIT;

EXCEPTION

    WHEN OTHERS THEN
       err_num := SQLCODE;
       err_msg := SUBSTR(SQLERRM, 1, 100);
       INSERT INTO mv_errors (err_sequence, err_num, err_msg)
          VALUES (pi_err_sequence, err_num, err_msg);
       COMMIT;

END create_pem;
--
-----------------------------------------------------------------------------
--
FUNCTION get_doc_id RETURN NUMBER IS

BEGIN
   RETURN g_doc_id;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_user_or_sys_opt
           ( pi_option   IN hig_options.hop_id%TYPE
		   , pi_username IN VARCHAR2)
  RETURN VARCHAR2 IS

BEGIN
  RETURN NVL(Hig.get_useopt(p_option_id => pi_option
	                       ,p_username  => pi_username)
	        ,Hig.get_sysopt(p_option_id => pi_option));
END;
--
-----------------------------------------------------------------------------
--
FUNCTION msv_available RETURN BOOLEAN IS

BEGIN
 RETURN(Hig.get_sysopt('WEBMAPMSV')  IS NOT NULL);
END msv_available;
--
-----------------------------------------------------------------------------
--
FUNCTION web_gis_available RETURN BOOLEAN IS

BEGIN
 RETURN(Hig.get_sysopt('WEBMAPSERV')  IS NOT NULL);
END web_gis_available;

--
-----------------------------------------------------------------------------
--

FUNCTION get_conversion_factor RETURN NUMBER IS
BEGIN
  RETURN g_conversion_factor;
END;

--
-----------------------------------------------------------------------------
--


FUNCTION Get_Scale RETURN NUMBER IS

l_len      NUMBER;
l_geom_len NUMBER;
l_unit     NUMBER;
retval     NUMBER;

l_nth_id   NUMBER;

l_nth      nm_themes_all%ROWTYPE;

cur_str    VARCHAR2(2000);

rcur       Nm3type.ref_cursor;

BEGIN

--get the first base-datum layer

  SELECT nth.nth_theme_id, nt_length_unit
  INTO l_nth_id, l_unit
  FROM nm_themes_all nth, nm_nw_themes, nm_linear_types, nm_types
  WHERE nth_theme_id = nnth_nth_theme_id
  AND   nt_type = nlt_nt_type
  AND   nnth_nlt_id = nlt_id
  AND   nlt_g_i_d = 'D'
  AND   nth_base_table_theme is null
  AND   ROWNUM = 1;

  l_nth := Nm3get.get_nth( l_nth_id );

--get the ratio of ne_length to feature length (after unit conversion) and set an appropriate scale factor.

  cur_str := 'select avg(a.ne_length), avg(sdo_geom.sdo_length( nm3sdo.set_srid(b.'||l_nth.nth_feature_shape_column||',null), .00005 )) '||
             ' from nm_elements a, '||l_nth.nth_feature_table||' b '||
             ' where a.ne_id = b.'||l_nth.nth_feature_pk_column||' and rownum < 11';

  EXECUTE IMMEDIATE cur_str INTO l_len, l_geom_len;

  IF l_unit != 1 THEN
    l_len := Nm3unit.convert_unit( l_unit, 1, l_len );
  END IF;

  retval :=  l_len/l_geom_len;

  RETURN retval;

END;
--
-----------------------------------------------------------------------------
--
  PROCEDURE delete_gdo
              ( pi_session_id IN gis_data_objects.gdo_session_id%TYPE )
  IS
  BEGIN
    DELETE gis_data_objects
     WHERE gdo_session_id = pi_session_id;
  --
    COMMIT;
  --
  END delete_gdo;
--
-----------------------------------------------------------------------------
--
  PROCEDURE create_highlight_data ( p_query in varchar2, p_id in integer ) is
  curstr varchar2(2000);
  qq varchar2(1) := chr(39);
  begin
    curstr := 'insert into mv_highlight '||
            '  ( mv_id, mv_feat_type, mv_geometry ) '||
            ' select '||p_id||', feat_type, shape '||
            ' from ( select decode (a.shape.sdo_gtype, 2001, '||qq||'POINT'||qq||', '||qq||'LINE'||qq||' ) feat_type,'||
            '     shape from ( '|| p_query||') a '||
            ')';
--  nm_debug.debug_on;
--  nm_debug.debug(curstr);
    execute immediate curstr;
    commit;
end;

--
-----------------------------------------------------------------------------
--

END Mapviewer;
/
