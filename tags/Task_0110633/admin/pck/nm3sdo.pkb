CREATE OR REPLACE PACKAGE BODY nm3sdo AS
--
-----------------------------------------------------------------------------
--
---   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3sdo.pkb-arc   2.49   Jan 26 2011 12:22:00   Rob.Coupe  $
--       Module Name      : $Workfile:   nm3sdo.pkb  $
--       Date into PVCS   : $Date:   Jan 26 2011 12:22:00  $
--       Date fetched Out : $Modtime:   Jan 26 2011 12:21:30  $
--       PVCS Version     : $Revision:   2.49  $
--       Based on

--
--   Author : Rob Coupe
--
--   NM3 Package for Oracle Spatial links
--
-------------------------------------------------------------------------------
-- Copyright (c) RAC
-----------------------------------------------------------------------------

   g_body_sccsid     CONSTANT VARCHAR2(2000) := '"$Revision:   2.49  $"';
   g_package_name    CONSTANT VARCHAR2 (30)  := 'NM3SDO';
   g_batch_size      INTEGER                 := NVL( TO_NUMBER(Hig.get_sysopt('SDOBATSIZE')), 10);
   g_clip_type       VARCHAR2(30)            := NVL(Hig.get_sysopt('SDOCLIPTYP'),'SDO');
--
   SUBTYPE rec_usgm IS user_sdo_geom_metadata%ROWTYPE;
   SUBTYPE rec_nth  IS NM_THEMES_ALL%ROWTYPE;
   g_usgm            rec_usgm;
   g_nth             rec_nth;

--
-- Task 0109983
-- Validate geometry - add validation errors to ignore here
--
   g_error_to_ignore  ptr_vc_array := ptr_vc_array ( ptr_vc_array_type (
                                                         ptr_vc( 1, 13011 ) -- ORA-13011: value is out of range
                                                      -- , ptr_vc( 2, 13356 ) -- ORA-13356: adjacent points are redundant
                                                  ));

   g_do_geom_validation        BOOLEAN :=  NVL(hig.get_user_or_sys_opt('SDOGEOMVAL'),'Y') = 'Y' ;

--  g_body_sccsid is the SCCS ID for the package body
--
  FUNCTION hypot
            ( x1 IN NUMBER
            , y1 IN NUMBER
            , x2 IN NUMBER
            , y2 IN NUMBER )
    RETURN NUMBER;

--
--  Task 0108546
--   Remove these functions for modifying geometries
--
--  FUNCTION strip_user_elem_info
--            ( p_elem_info IN mdsys.sdo_elem_info_array )
--    RETURN mdsys.sdo_elem_info_array;
----
--  FUNCTION modify_user_elem_info
--            ( p_elem_info IN mdsys.sdo_elem_info_array )
--    RETURN mdsys.sdo_elem_info_array;
----
--  FUNCTION strip_user_parts
--            ( p_geom IN mdsys.sdo_geometry )
--    RETURN mdsys.sdo_geometry;

  FUNCTION Sdo_Clip (  p_geom IN  mdsys.sdo_geometry,  p_st IN NUMBER, p_end IN NUMBER, p_diminfo IN mdsys.sdo_dim_array )
    RETURN mdsys.sdo_geometry;

  FUNCTION get_base_themes( p_nt IN ptr_vc_array ) RETURN ptr_array;
  FUNCTION get_base_themes( p_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE) RETURN nm_theme_array;

  FUNCTION get_base_nt ( p_ne_id IN NUMBER ) RETURN ptr_vc_array;
  FUNCTION get_base_nt ( p_nlt_id IN NUMBER ) RETURN ptr_vc_array;

  FUNCTION Get_Ne_Shapes( p_id IN ptr_array, p_th_id IN INTEGER ) RETURN nm_geom_array;

FUNCTION make_tha_from_ptr  ( p_ptr IN ptr_array )                      RETURN nm_theme_array;
FUNCTION get_distinct_ptr   (p_ptr IN ptr_array )                       RETURN ptr_array;
FUNCTION get_idx_from_value ( p_ptr IN ptr_array, p_value IN INTEGER )  RETURN INTEGER;
FUNCTION get_idx_from_id    ( p_ptr IN ptr_array, p_id IN INTEGER )     RETURN INTEGER;
FUNCTION get_id             ( p_ptr IN ptr_array, p_value IN INTEGER )  RETURN INTEGER;
FUNCTION get_idx_from_id    ( p_ptr IN ptr_num_array, p_id IN INTEGER ) RETURN INTEGER;
FUNCTION get_idx            ( p_ga IN nm_geom_array, p_id IN INTEGER )  RETURN INTEGER;


PROCEDURE add_dyn_seg_exception( p_ner          IN INTEGER,
                                 p_job_id       IN INTEGER,
         p_ne_id_in     IN INTEGER,
         p_ne_id_of     IN INTEGER  DEFAULT NULL,
         p_shape_length IN NUMBER   DEFAULT NULL,
         p_ne_length    IN NUMBER   DEFAULT NULL,
         p_start        IN NUMBER   DEFAULT NULL,
         p_end          IN NUMBER   DEFAULT NULL,
         p_sqlerrm      IN VARCHAR2 DEFAULT NULL );

PROCEDURE ins_usgm( p_table IN VARCHAR2, p_column IN VARCHAR2, p_diminfo IN mdsys.sdo_dim_array, p_srid IN NUMBER );

FUNCTION join_ntl_array( p_nth IN NM_THEMES_ALL%ROWTYPE, p_ntl IN nm_theme_list  ) RETURN nm_theme_list;

FUNCTION Get_Parts ( p_shape IN mdsys.sdo_geometry ) RETURN nm_geom_array;

FUNCTION compare_pt ( p_geom1 mdsys.sdo_geometry, p_geom2 mdsys.sdo_geometry, tol IN NUMBER ) RETURN VARCHAR2;

function local_join_ptr_array( p_pa in ptr_array, p_table in varchar2, p_key in varchar2 ) return ptr_array;
--
PROCEDURE add_segments_m ( p_geom1 IN OUT NOCOPY mdsys.sdo_geometry, p_geom2 IN mdsys.sdo_geometry,
                           p_diminfo IN mdsys.sdo_dim_array,
                           p_conn IN BOOLEAN DEFAULT FALSE );
--
FUNCTION get_list(p_theme_txt IN VARCHAR2 ) RETURN nm_theme_array;

--
--------------------------------------------------------------------------------
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
  FUNCTION set_route_name( p_route_name IN nm_elements.ne_unique%TYPE ) RETURN nm_elements.ne_id%TYPE IS
  BEGIN
    g_route_name := p_route_name;
    g_route_id   := Nm3net.get_ne_id( g_route_name );
    RETURN g_route_id;
  END;
--
-----------------------------------------------------------------------------
--

PROCEDURE set_global_metadata ( p_usgm IN user_sdo_geom_metadata%ROWTYPE ) IS
BEGIN
--Nm_Debug.DEBUG('Setting global metadata for table '||p_usgm.table_name);
  g_usgm := p_usgm;
END;
--
-----------------------------------------------------------------------------
--

PROCEDURE set_global_metadata ( p_table_name IN VARCHAR2,
                                p_column_name IN VARCHAR2,
        p_diminfo IN mdsys.sdo_dim_array,
        p_srid IN NUMBER) IS
l_usgm user_sdo_geom_metadata%ROWTYPE;
BEGIN
--Nm_Debug.DEBUG('Setting global metadata for table '||p_table_name);
  l_usgm.table_name  := p_table_name;
  l_usgm.column_name := p_column_name;
  l_usgm.diminfo     := p_diminfo;
  l_usgm.srid        := p_srid;
  set_global_metadata(l_usgm);
END;

--
-----------------------------------------------------------------------------
--
PROCEDURE set_theme_metadata ( p_nth_id IN NM_THEMES_ALL.nth_theme_id%TYPE ) IS
BEGIN
--Nm_Debug.DEBUG('Setting theme metadata for theme '||TO_CHAR(p_nth_id));
  g_nth := Nm3get.get_nth( p_nth_id );

  set_global_metadata ( get_theme_metadata( p_nth_id ) );

END;

--
-----------------------------------------------------------------------------
--

FUNCTION get_global_metadata RETURN user_sdo_geom_metadata%ROWTYPE IS
BEGIN
  RETURN g_usgm;
END;

--
-----------------------------------------------------------------------------
--


FUNCTION set_theme (p_layer IN NM_THEMES_ALL.nth_theme_id%TYPE ) RETURN BOOLEAN IS
BEGIN
  IF g_nth.nth_theme_id = p_layer THEN
    RETURN FALSE;
  ELSE
    RETURN TRUE;
  END IF;
END;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_layer_table ( p_layer IN NUMBER ) RETURN VARCHAR2 IS
  BEGIN
    RETURN Nm3get.get_nth(p_layer).nth_feature_table;
  END;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_layer_shape_column ( p_layer IN NUMBER ) RETURN VARCHAR2 IS
  BEGIN
    RETURN Nm3get.get_nth(p_layer).nth_feature_shape_column;
  END;

--
-----------------------------------------------------------------------------
--

  FUNCTION get_layer_ne_column ( p_layer IN NUMBER ) RETURN VARCHAR2 IS
  BEGIN
    RETURN Nm3get.get_nth(p_layer).nth_feature_pk_column;
  END;

--
-----------------------------------------------------------------------------
--

FUNCTION get_nw_themes RETURN nm_theme_array IS
retval nm_theme_array := Nm3array.init_nm_theme_array;
CURSOR c1 IS
  SELECT nm_theme_entry(nth_theme_id)
  FROM NM_THEMES_ALL, NM_NW_THEMES
  WHERE nnth_nth_theme_id = nth_theme_id
  AND nth_base_table_theme IS NULL
  AND NOT EXISTS ( SELECT 1 FROM NM_BASE_THEMES
                   WHERE nbth_theme_id = nth_theme_id );
BEGIN
  OPEN c1;
  FETCH c1 BULK COLLECT INTO retval.nta_theme_array;
  CLOSE c1;
  RETURN retval;
END;

--
-----------------------------------------------------------------------------
--

PROCEDURE set_diminfo_and_srid( p_themes  IN nm_theme_array,
                                p_diminfo OUT mdsys.sdo_dim_array,
        p_srid    OUT NUMBER ) IS
l_dummy int_array := Nm3array.init_int_array;
l_mbr   mdsys.sdo_geometry;
l_tol   NUMBER;
l_m_tol NUMBER;
l_srid  num_array := Nm3array.init_num_array;

CURSOR get_srids ( c_themes IN nm_theme_array ) IS
  SELECT nth_theme_id, sdo_srid
  FROM mdsys.sdo_geom_metadata_table, NM_THEMES_ALL, TABLE (c_themes.nta_theme_array ) t
  WHERE t.nthe_id = nth_theme_id
  AND   nth_feature_table = sdo_table_name
  AND   nth_feature_shape_column = sdo_column_name
  AND   sdo_owner = Hig.get_application_owner;

BEGIN
--nm_debug.debug_on;
--for i in 1..p_themes.nta_theme_array.last loop
--  nm_debug.debug( to_char(i)||' = '||to_char(p_themes.nta_theme_array(i).nthe_id));
--end loop;

   OPEN get_srids( p_themes );
   FETCH get_srids BULK COLLECT INTO l_dummy.ia, l_srid.na;
   CLOSE get_srids;

   IF l_dummy.ia(1) IS NULL THEN
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                    ,pi_id                 => 197
                    ,pi_sqlcode            => -20001
                    );

   ELSE

     FOR i IN 1..l_srid.na.LAST LOOP
    IF i = 1 THEN
      p_srid := l_srid.na(1);
    ELSIF NVL( l_srid.na(i), -999 ) != NVL( p_srid, -999 ) THEN
         Hig.raise_ner(pi_appl                => Nm3type.c_hig
                       ,pi_id                 => 280
                       ,pi_sqlcode            => -20001
                       );
--      raise_application_error( -20001, 'Inconsistent base srids' );
    END IF;
  END LOOP;
   END IF;

   SELECT sdo_aggr_mbr(Convert_Dim_Array_To_Mbr( Get_Theme_Diminfo(l.nthe_id)))
   INTO l_mbr
   FROM NM_THEMES_ALL, TABLE ( p_themes.nta_theme_array ) l
   WHERE l.nthe_id = nth_theme_id;

   SELECT MIN( LEAST( Get_Dim_Element( 1, Nm3sdo.Get_Theme_Diminfo(nth_theme_id)).sdo_tolerance ,
                      Get_Dim_Element( 2, Nm3sdo.Get_Theme_Diminfo(nth_theme_id)).sdo_tolerance )) l1
   INTO l_tol
   FROM NM_THEMES_ALL, TABLE ( p_themes.nta_theme_array ) l
   WHERE l.nthe_id = nth_theme_id;

   SELECT MIN( Get_Dim_Element( 3, Nm3sdo.Get_Theme_Diminfo(nth_theme_id)).sdo_tolerance )
   INTO l_m_tol
   FROM NM_THEMES_ALL, TABLE ( p_themes.nta_theme_array ) l
   WHERE l.nthe_id = nth_theme_id;

   p_diminfo := mdsys.sdo_dim_array(
                mdsys.sdo_dim_element( 'X', l_mbr.sdo_ordinates(1), l_mbr.sdo_ordinates(4), l_tol ),
                mdsys.sdo_dim_element( 'Y', l_mbr.sdo_ordinates(2), l_mbr.sdo_ordinates(5), l_tol ),
                mdsys.sdo_dim_element( 'M', 0, Nm3type.c_big_number, l_m_tol ));

END;
--
-----------------------------------------------------------------------------
--

PROCEDURE ins_usgm( p_table IN VARCHAR2, p_column IN VARCHAR2, p_diminfo IN mdsys.sdo_dim_array, p_srid IN NUMBER ) IS

l_usgm user_sdo_geom_metadata%ROWTYPE;

BEGIN
--Nm_Debug.DEBUG(p_table);
  l_usgm.table_name := p_table;
  l_usgm.column_name := p_column;
  l_usgm.diminfo := p_diminfo;
  l_usgm.srid := p_srid;
  ins_usgm( l_usgm );
END;

--
-----------------------------------------------------------------------------
--

   PROCEDURE ins_usgm (pi_rec_usgm IN user_sdo_geom_metadata%ROWTYPE)
   IS
   BEGIN
      --
      Nm_Debug.proc_start (g_package_name, 'ins_usgm');

--   Nm_Debug.DEBUG('inserting '||pi_rec_usgm.table_name||','||pi_rec_usgm.column_name||','||Hig.get_application_owner);
      --
      INSERT INTO mdsys.sdo_geom_metadata_table
                  (sdo_table_name, sdo_column_name,
                   sdo_diminfo, sdo_srid, sdo_owner
                  )
           VALUES (pi_rec_usgm.table_name, pi_rec_usgm.column_name,
                   pi_rec_usgm.diminfo, pi_rec_usgm.srid, Hig.get_application_owner
                  );
      --
      Nm_Debug.proc_end (g_package_name, 'ins_usgm');
   --
   END ins_usgm;

--
-----------------------------------------------------------------------------
--

PROCEDURE Copy_Ords (p_ords1 IN OUT NOCOPY mdsys.sdo_ordinate_array, p_ords2 IN mdsys.sdo_ordinate_array, p_from IN INTEGER, p_to IN INTEGER ) IS
l_last INTEGER;
BEGIN
  l_last := p_ords1.LAST;
  p_ords1.EXTEND(p_to - p_from + 1);
  FOR i IN 1..p_to - p_from + 1 LOOP
    p_ords1(l_last + i) := p_ords2(p_from + i -1);
  END LOOP;
END;

--
-----------------------------------------------------------------------------
--

FUNCTION Sdo_Clip (  p_geom IN  mdsys.sdo_geometry,  p_st IN NUMBER, p_end IN NUMBER, p_diminfo IN mdsys.sdo_dim_array )
RETURN mdsys.sdo_geometry IS
last1 INTEGER := p_geom.sdo_ordinates.LAST;
st_set BOOLEAN := FALSE;
st_id  INTEGER;
end_id INTEGER;
l_ords mdsys.sdo_ordinate_array;
k INTEGER;
l_geom mdsys.sdo_geometry;
l_pt   mdsys.sdo_geometry;
x_start NUMBER;
y_start NUMBER;
x_end   NUMBER;
y_end   NUMBER;

BEGIN
--nm_debug.debug_on;

  FOR i IN 1..last1/3 - 1 LOOP

    k := (i-1)*3;

    IF NOT st_set AND p_st <= p_geom.sdo_ordinates(k + 6) THEN


--   nm_debug.debug('Start K = '||to_char(k)||' value = '||to_char(p_geom.sdo_ordinates(k + 6)));

      l_geom := mdsys.sdo_geometry( 3302, p_geom.sdo_srid, NULL, mdsys.sdo_elem_info_array(1,2,1),
                     mdsys.sdo_ordinate_array( p_geom.sdo_ordinates(k+1), p_geom.sdo_ordinates(k+2), p_geom.sdo_ordinates(k+3),
                                    p_geom.sdo_ordinates(k+4), p_geom.sdo_ordinates(k+5), p_geom.sdo_ordinates(k+6)));


/*
        nm_debug.debug(to_char( p_geom.sdo_ordinates(k+1))||','||
                 to_char( p_geom.sdo_ordinates(k+2))||','||
        to_char( p_geom.sdo_ordinates(k+3))||','||
            to_char( p_geom.sdo_ordinates(k+4))||','||
        to_char( p_geom.sdo_ordinates(k+5))||','||
        to_char( p_geom.sdo_ordinates(k+6)));
*/


      l_pt := sdo_lrs.locate_pt( l_geom, p_diminfo, p_st );

   x_start := l_pt.sdo_ordinates(1);
   y_start := l_pt.sdo_ordinates(2);

      st_set := TRUE;
   st_id  := k+4;

      IF p_end <= p_geom.sdo_ordinates(k + 6) THEN

  end_id  := k+3;

        l_pt := sdo_lrs.locate_pt( l_geom, p_diminfo, p_end );

     x_end := l_pt.sdo_ordinates(1);
     y_end := l_pt.sdo_ordinates(2);

        EXIT;

      END IF;

      st_set := TRUE;
   st_id  := k+4;

    ELSIF p_end <= p_geom.sdo_ordinates(k + 6) THEN

--   nm_debug.debug('End  K = '||to_char(k)||' value = '||to_char(p_geom.sdo_ordinates(k + 6)));

   end_id  := k+3;

      l_geom := mdsys.sdo_geometry( 3302, p_geom.sdo_srid, NULL, mdsys.sdo_elem_info_array(1,2,1),
                     mdsys.sdo_ordinate_array( p_geom.sdo_ordinates(k+1), p_geom.sdo_ordinates(k+2), p_geom.sdo_ordinates(k+3),
                                    p_geom.sdo_ordinates(k+4), p_geom.sdo_ordinates(k+5), p_geom.sdo_ordinates(k+6)));

/*
        nm_debug.debug(to_char( p_geom.sdo_ordinates(k+1))||','||
                 to_char( p_geom.sdo_ordinates(k+2))||','||
        to_char( p_geom.sdo_ordinates(k+3))||','||
            to_char( p_geom.sdo_ordinates(k+4))||','||
        to_char( p_geom.sdo_ordinates(k+5))||','||
        to_char( p_geom.sdo_ordinates(k+6)));
*/

      l_pt := sdo_lrs.locate_pt( l_geom, p_diminfo, p_end );

      x_end := l_pt.sdo_ordinates(1);
      y_end := l_pt.sdo_ordinates(2);


   EXIT;

 END IF;


  END LOOP;

  l_ords := mdsys.sdo_ordinate_array( x_start, y_start, p_st);

  IF st_id < end_id THEN

--  nm_debug.debug('Insert ords from '||to_char( st_id)||' to '||to_char(end_id));
    Copy_Ords( l_ords, p_geom.sdo_ordinates, st_id, end_id );

  END IF;

  Copy_Ords( l_ords, mdsys.sdo_ordinate_array( x_end, y_end, p_end), 1, 3);

  RETURN mdsys.sdo_geometry( 3302, p_geom.sdo_srid, NULL, mdsys.sdo_elem_info_array(1,2,1), l_ords );


END;

--
--------------------------------------------------------------------------------------------------------------------
--

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

--
-----------------------------------------------------------------------------
--
--
  FUNCTION set_route_id( p_route_id IN nm_elements.ne_id%TYPE ) RETURN nm_elements.ne_unique%TYPE IS
  BEGIN
    g_route_name := Nm3net.get_ne_unique( p_route_id );
    g_route_id   := p_route_id;
    RETURN g_route_id;
  END;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_route_id RETURN nm_elements.ne_id%TYPE IS
  BEGIN
    RETURN g_route_id;
  END;
--
-----------------------------------------------------------------------------
--

  FUNCTION get_projection( p_layer IN NUMBER, p_ne_id IN NUMBER, p_x IN NUMBER, p_y IN NUMBER)
                             RETURN mdsys.sdo_geometry IS
  cur_string VARCHAR2(2000);

  retval mdsys.sdo_geometry;

  BEGIN

    IF set_theme( p_layer ) THEN
   set_theme_metadata( p_layer );
 END IF;

    cur_string := 'select sdo_lrs.project_pt( '||g_usgm.column_name||', :diminfo, '||
          'mdsys.sdo_geometry( 2001, :srid, null, mdsys.sdo_elem_info_array( 1,1,1), '||
          'mdsys.sdo_ordinate_array( :x, :y, null )) ) '||
    ' from '||g_usgm.table_name||
    ' where '||g_nth.nth_feature_pk_column||' = :ne_id';


--       nm_debug.debug_on;
--       nm_debug.debug( cur_string );

    EXECUTE IMMEDIATE cur_string INTO retval USING g_usgm.diminfo, g_usgm.srid, p_x, p_y, p_ne_id;
    RETURN retval;
  /*
  exception
    when others then
      raise_application_error( -20001,'Projection failed - ');
  */
  END;
--
-----------------------------------------------------------------------------
--


  FUNCTION get_measure( p_layer IN NUMBER, p_ne_id IN NUMBER, p_x IN NUMBER, p_y IN NUMBER )
                             RETURN nm_lref IS

  cur_string VARCHAR2(2000);
  retval NUMBER;

  BEGIN

    IF set_theme( p_layer ) THEN
   set_theme_metadata( p_layer );
 END IF;

    cur_string := 'select sdo_lrs.get_measure( sdo_lrs.project_pt( '||g_usgm.column_name||', :diminfo, '||
          'mdsys.sdo_geometry( 2001, :srid, null, mdsys.sdo_elem_info_array( 1,1,1), '||
          'mdsys.sdo_ordinate_array( :x, :y, null )) ), :diminfo ) '||
    ' from '||g_usgm.table_name||
    ' where '||g_nth.nth_feature_pk_column||' = :ne';

    EXECUTE IMMEDIATE cur_string INTO retval USING g_usgm.diminfo, g_usgm.srid, p_x, p_y, g_usgm.diminfo, p_ne_id ;
    RETURN nm_lref( p_ne_id, retval);
  /*
  exception
    when others then
      raise_application_error( -20002,'Measure not found - ');
  */
  END;

--
-----------------------------------------------------------------------------
--

  FUNCTION get_xy_from_measure( p_ne_id IN NUMBER, p_measure IN NUMBER)
                             RETURN mdsys.sdo_geometry deterministic IS
  l_layer   NUMBER;
  l_ne      nm_elements_all%rowtype;
  l_lr      nm_lref;


  BEGIN

    l_ne := nm3get.get_ne( p_ne_id );

    if l_ne.ne_gty_group_type is not null then

      if NM3NET.IS_GTY_LINEAR(l_ne.ne_gty_group_type) = 'Y' then

        l_lr := NM3LRS.GET_DISTINCT_OFFSET(nm_lref( p_ne_id, p_measure ), 'N');

        if l_lr.lr_ne_id is not null then

          return get_xy_from_measure( l_lr.lr_ne_id, l_lr.lr_offset );

        else

          return null;

        end if;

      else

        return null;

      end if;

    else

      l_layer := Get_Datum_Theme( Nm3get.get_ne_all( p_ne_id ).ne_nt_type );

      IF l_layer IS NULL THEN

        RETURN NULL;

      ELSE

        RETURN nm3sdo.get_xy_from_measure( p_layer => l_layer, p_ne_id => p_ne_id, p_measure => p_measure );

      END IF;

    end if;
  END;
--
-----------------------------------------------------------------------------
--

  FUNCTION get_xy_from_measure( p_layer IN NUMBER, p_ne_id IN NUMBER, p_measure IN NUMBER)
                             RETURN mdsys.sdo_geometry deterministic IS


  cur_string VARCHAR2(2000);
  l_geom mdsys.sdo_geometry;
  retval mdsys.sdo_geometry;

  BEGIN

    IF set_theme( p_layer ) THEN
   set_theme_metadata( p_layer );
 END IF;

 l_geom := Get_Layer_Element_Geometry( p_layer, p_ne_id );

 retval := sdo_lrs.locate_pt( l_geom, g_usgm.diminfo, p_measure);

-- cur_string :=  'select sdo_lrs.locate_pt( '||g_usgm.column_name||', :diminfo, :measure, 0 ) '||
--  cur_string :=  'select locate_pt( '||g_usgm.column_name||', :diminfo, :measure ) '||
--     'from '||g_usgm.table_name||
--     ' where '||g_nth.nth_feature_pk_column||' = :ne';
--
-- nm_debug.debug_on;
-- nm_debug.debug(cur_string);
--
--     EXECUTE IMMEDIATE cur_string INTO retval using g_usgm.diminfo, p_measure, p_ne_id;
    RETURN retval;

  EXCEPTION
    WHEN OTHERS THEN
        Hig.raise_ner(pi_appl                => Nm3type.c_hig
                      ,pi_id                 => 198
                      ,pi_sqlcode            => -20001
                      );
  --    raise_application_error( -20002,'Geometry not found - ');

  END;

--
-----------------------------------------------------------------------------
--


  FUNCTION get_xy_from_measure( p_layer IN NUMBER, p_lref IN nm_lref )
                             RETURN mdsys.sdo_geometry deterministic IS
  BEGIN
    RETURN get_xy_from_measure( p_layer, p_lref.lr_ne_id, p_lref.lr_offset );
  END;


--
-----------------------------------------------------------------------------
--

  FUNCTION get_x_from_pt_geometry ( p_geometry IN mdsys.sdo_geometry ) RETURN NUMBER IS
--  l_geom mdsys.sdo_geometry;
  retval NUMBER;
  BEGIN
  -- Task 0108546
  -- No longer used
  --  l_geom := strip_user_parts( p_geometry );

  --  nm_debug.debug_on;
  --  nm_debug.debug('elem 1 = '||to_char( l_geom.sdo_elem_info(1)));

    IF p_geometry.sdo_elem_info IS NULL THEN
      retval := p_geometry.sdo_point.x;
    ELSE
      retval := p_geometry.sdo_ordinates(1);
    END IF;
    RETURN retval;
  END;

--
-----------------------------------------------------------------------------
--

  FUNCTION get_y_from_pt_geometry ( p_geometry IN mdsys.sdo_geometry ) RETURN NUMBER IS
--  l_geom mdsys.sdo_geometry;
  retval NUMBER;
  BEGIN
    -- Task 0108546
    -- No longer used
    --l_geom := strip_user_parts( p_geometry) ;
    IF p_geometry.sdo_elem_info IS NULL THEN
      retval := p_geometry.sdo_point.y;
    ELSE
      retval := p_geometry.sdo_ordinates(2);
    END IF;
    RETURN retval;
  END;

--
-----------------------------------------------------------------------------
--

/* Overloaded function, this one delivers the linear interpolated point between two points
   and optionally includes the projected distance off the linear feature */
/*
function linear_interp( p_pt1 in mdsys.sdo_geometry, p_pt2 in mdsys.sdo_geometry,
                        p_n1 in number, p_n2 in number, p_n3 in number,
                        p_geometry in mdsys.sdo_geometry, p_offset_flag in varchar2 ) return mdsys.sdo_geometry is

l_m3   number;
sfac   number;
retval mdsys.sdo_geometry;

begin

--first project each point to the linear geometry and arrive at a measure and the projected distance
--from the point to the geometry. (m1, p1), (m2, p2)

--introduce a scale factor based on the numeric values

  sfac := ( p_n3 - p_n1 )/(p_n2 - p_n1);

--get the measure at the p_n3 point. This is m1 + sfac * (m2 - m1);

--l_m3 := m1 + sfac * (m2 - m1);

--If the offset flag is set, interpolate in the projected distance. This is p1 + sfac * ( p2 - p1 );

--we now have a measure along the shape and (optionally) an offset, construct the point.

  retval := mdsys.sdo_geometry( 2002, null, null,
                                mdsys.sdo_elem_info_array(1, 1, 1),
                                mdsys.sdo_ordinate_array( 1, 1 ) );

  return retval;

end;
--

*/
-----------------------------------------------------------------------------
--
/* Overloaded function, this one delivers the linear interpolated point between two measures
   Note that this version will not cater for offsets, this version is based on a network element
   and thus needs to query info from the layer */

  FUNCTION linear_interp( p_m1 IN NUMBER, p_m2 IN NUMBER, p_n1 IN NUMBER, p_n2 IN NUMBER, p_n3 IN NUMBER,
                          p_layer IN NUMBER, p_ne_id IN NUMBER ) RETURN mdsys.sdo_geometry IS

  cur_string VARCHAR2(2000);

  l_m3   NUMBER;
  sfac   NUMBER;
  retval mdsys.sdo_geometry;
  l_geometry  mdsys.sdo_geometry;

  BEGIN

    IF set_theme( p_layer ) THEN
   set_theme_metadata( p_layer );
 END IF;

    cur_string :=  'select '||g_usgm.column_name||' from '||
                               g_usgm.table_name||' where '||g_nth.nth_feature_pk_column||' = :ne';


    EXECUTE IMMEDIATE cur_string INTO l_geometry USING p_ne_id;

  --introduce a scale factor based on the numeric values

    sfac := ( p_n3 - p_n1 )/(p_n2 - p_n1);

  --get the measure at the p_n3 point. This is p_m1 + sfac * (p_m2 - p_m1);

    l_m3 := p_m1 + sfac * (p_m2 - p_m1);

  --we now have a measure along the shape , construct the point.

    retval := get_xy_from_measure( p_layer, p_ne_id, l_m3);

    RETURN retval;

  END;

--
-----------------------------------------------------------------------------
--
  FUNCTION get_placement_geometry( p_pl IN nm_placement ) RETURN mdsys.sdo_geometry IS
  l_dummy INTEGER;
  BEGIN
--  longer term, this must return the placement geometry by translating route placements to datum placement arrays and dyn-seg.
--  for now though, we just assume it must be a datum placement.

    RETURN get_shape_from_nm( p_ne_id => l_dummy,
                            p_ne_id_of => p_pl.pl_ne_id,
                            p_begin_mp => p_pl.pl_start,
                            p_end_mp   => p_pl.pl_end );
  END;

--
-----------------------------------------------------------------------------
--

  FUNCTION get_placement_geometry( p_pl_array IN nm_placement_array ) RETURN mdsys.sdo_geometry IS

  l_elem_info mdsys.sdo_elem_info_array := mdsys.sdo_elem_info_array( 1, 2, 1);
  l_null_pt   mdsys.sdo_point_type := mdsys.sdo_point_type( NULL, NULL, NULL);

  cur_string VARCHAR2(2000);

  l_geom             mdsys.sdo_geometry;

  l_reverse          mdsys.sdo_geometry;

  l_layer            NUMBER;

  retval   mdsys.sdo_geometry;

  BEGIN

  -- for each placement in the array, clip the geometry on which the placement occurs ideally these
  -- should be merged into a single shape if they are logically connected. Note that the placement array
  -- is connected. Broken placements are modeled as arrays of placement arrays.
  -- Note that this needs to be re-coded using a relational approach to the pla - then a single
  -- cursor can be opened, delivering all shapes.

    FOR ip IN 1..p_pl_array.npa_placement_array.LAST LOOP

   l_layer := Get_Datum_Theme( Nm3get.get_ne_all(p_pl_array.npa_placement_array(ip).pl_ne_id ).ne_nt_type );

      IF set_theme( l_layer ) THEN
     set_theme_metadata( l_layer );
   END IF;

      IF p_pl_array.npa_placement_array(ip).pl_start = 0 AND
         p_pl_array.npa_placement_array(ip).pl_end   =
            Nm3net.Get_Ne_Length( p_pl_array.npa_placement_array(ip).pl_ne_id ) THEN

        cur_string := 'select '||g_usgm.column_name||
             ' from '||g_usgm.table_name||
             ' where '||g_nth.nth_pk_column||' = '||p_pl_array.npa_placement_array(ip).pl_ne_id;

        EXECUTE IMMEDIATE cur_string INTO l_geom;

      ELSE

        cur_string := 'select sdo_lrs.clip_geom_segment( '||g_usgm.column_name||', :diminfo, '||
                      TO_CHAR( p_pl_array.npa_placement_array(ip).pl_start )||','||TO_CHAR( p_pl_array.npa_placement_array(ip).pl_end )||')'||
             ' from '||g_usgm.table_name||
             ' where '||g_nth.nth_feature_pk_column||' = '||p_pl_array.npa_placement_array(ip).pl_ne_id;

        EXECUTE IMMEDIATE cur_string INTO l_geom USING g_usgm.diminfo;

      END IF;

  ----   nm_debug.debug( cur_string );


      IF ip = 1 THEN

  --    --   nm_debug.debug('First');

        retval := l_geom;

      ELSE

  --    --   nm_debug.debug(to_char(ip)||' test connection');

        IF sdo_lrs.connected_geom_segments( retval, g_usgm.diminfo, l_geom,  g_usgm.diminfo ) = 'TRUE' THEN

  --      --   nm_debug.debug('Connected');

          retval := sdo_lrs.concatenate_geom_segments( retval,  g_usgm.diminfo, l_geom,  g_usgm.diminfo );

        ELSE

  --      --   nm_debug.debug('Reversing');
  --      l_reverse := sdo_lrs.reverse_geometry( l_geom, l_dim_info );

          l_reverse := reverse_geometry( l_geom );

  --      l_reverse := sdo_lrs.reverse_measure( l_geom, l_dim_info );

          IF sdo_lrs.connected_geom_segments( retval,  g_usgm.diminfo, l_reverse,  g_usgm.diminfo) = 'TRUE' THEN

  --        --   nm_debug.debug('Connected after reversing');
            retval := sdo_lrs.concatenate_geom_segments( retval,  g_usgm.diminfo, l_reverse,  g_usgm.diminfo );
          ELSE

  --          retval := add_segments( retval, l_geom );
            add_segments( retval, l_geom,  g_usgm.diminfo);
  --        --   nm_debug.debug('multi-part');
  --        we have a multipart feature

          END IF;

        END IF;
      END IF;

    END LOOP;

    RETURN retval;

  END;

--
-----------------------------------------------------------------------------
--

  FUNCTION get_placement_geometry( p_layer IN NUMBER, p_pl IN nm_placement) RETURN mdsys.sdo_geometry IS

  l_elem_info mdsys.sdo_elem_info_array := mdsys.sdo_elem_info_array( 1, 2, 1);
  l_null_pt   mdsys.sdo_point_type := mdsys.sdo_point_type( NULL, NULL, NULL);

  cur_string VARCHAR2(2000);

  l_geom             mdsys.sdo_geometry;

  BEGIN

    IF set_theme( p_layer ) THEN
   set_theme_metadata( p_layer );
 END IF;

    IF p_pl.pl_start = 0 AND
       p_pl.pl_end   = Nm3net.Get_Ne_Length( p_pl.pl_ne_id ) THEN

      cur_string := 'select '||g_usgm.column_name||
           ' from '||g_usgm.table_name||
           ' where '||g_nth.nth_pk_column||' = '||p_pl.pl_ne_id;

      EXECUTE IMMEDIATE cur_string INTO l_geom;

    ELSE

      cur_string := 'select sdo_lrs.clip_geom_segment( '||g_usgm.column_name||', :diminfo, '||
                    TO_CHAR( p_pl.pl_start )||','||TO_CHAR( p_pl.pl_end )||')'||
           ' from '||g_usgm.table_name||
           ' where '||g_nth.nth_pk_column||' = '||p_pl.pl_ne_id;

      EXECUTE IMMEDIATE cur_string INTO l_geom USING g_usgm.diminfo;

    END IF;


    RETURN l_geom;

  END;


--
-----------------------------------------------------------------------------
--

  FUNCTION add_segments ( p_geom1 IN mdsys.sdo_geometry, p_geom2 IN mdsys.sdo_geometry,
                          p_conn IN BOOLEAN DEFAULT FALSE ) RETURN mdsys.sdo_geometry IS

  -- Note that data in a function is passed by value as default. It takes a long time to instantiate the
  -- geometries if this is used. The procedure of the same name is more efficient with the arguments
  -- passed by reference. Also it is more reliable and does not lead to extraneous vertices.
  -- Not available with user-defined geometries.

  retval mdsys.sdo_geometry := p_geom1;

  l_meas NUMBER := p_geom1.sdo_ordinates(p_geom1.sdo_ordinates.LAST);
  last_1 INTEGER := p_geom1.sdo_ordinates.LAST;

  start_ic INTEGER := 1;

  BEGIN

     IF NOT p_conn OR (
            p_geom1.sdo_ordinates( last_1 - 2 ) != p_geom2.sdo_ordinates(1)  OR
            p_geom1.sdo_ordinates( last_1 - 1 ) != p_geom2.sdo_ordinates(2)  )THEN

  --   either intentionally not connected, or connected but no common ordinates
  --   so make multi-part

       retval.sdo_elem_info.EXTEND;
       retval.sdo_elem_info(retval.sdo_elem_info.LAST) := retval.sdo_ordinates.LAST + 1;

       retval.sdo_elem_info.EXTEND;
       retval.sdo_elem_info(retval.sdo_elem_info.LAST) := 2;

       retval.sdo_elem_info.EXTEND;
       retval.sdo_elem_info(retval.sdo_elem_info.LAST) := 1;

     END IF;

     IF p_conn AND
        p_geom1.sdo_ordinates( last_1 - 2 ) = p_geom2.sdo_ordinates(1) AND
        p_geom1.sdo_ordinates( last_1 - 1 ) = p_geom2.sdo_ordinates(2) THEN
        start_ic := 4;
     ELSE
        start_ic := 1;
     END IF;

     FOR ic IN start_ic..p_geom2.sdo_ordinates.LAST LOOP

        retval.sdo_ordinates.EXTEND;

        IF MOD( ic, 3) = 0 THEN
          retval.sdo_ordinates( retval.sdo_ordinates.LAST )  := p_geom2.sdo_ordinates(ic) + l_meas;
        ELSE
          retval.sdo_ordinates( retval.sdo_ordinates.LAST )  := p_geom2.sdo_ordinates(ic);
        END IF;

     END LOOP;

     RETURN retval;

  END;

--
--------------------------------------------------------------------------------------------------------------------
--
--This is coded as a procedure with in/out variables so that the arguments are passed by reference
--This avoids the time-consuming bit of instantiating the output argument.

  PROCEDURE add_segments ( p_geom1 IN OUT NOCOPY mdsys.sdo_geometry, p_geom2 IN mdsys.sdo_geometry,
                           p_diminfo IN mdsys.sdo_dim_array,
            p_conn IN BOOLEAN DEFAULT FALSE
         )  IS


  l_meas NUMBER := p_geom1.sdo_ordinates(p_geom1.sdo_ordinates.LAST);
  last_1 INTEGER := p_geom1.sdo_ordinates.LAST;

  start_ic INTEGER := 1;

  BEGIN

     IF NOT p_conn OR (
            ABS(p_geom1.sdo_ordinates( last_1 - 2 ) - p_geom2.sdo_ordinates(1)) > p_diminfo(1).sdo_tolerance OR
            ABS(p_geom1.sdo_ordinates( last_1 - 1 ) - p_geom2.sdo_ordinates(2)) > p_diminfo(2).sdo_tolerance)  THEN

  --   either intentionally not connected, or connected but no common ordinates
  --   so make multi-part
  --   but what when the geometry being added is MP

       p_geom1.sdo_elem_info.EXTEND;
       p_geom1.sdo_elem_info(p_geom1.sdo_elem_info.LAST) := p_geom1.sdo_ordinates.LAST + 1;

       p_geom1.sdo_elem_info.EXTEND;
       p_geom1.sdo_elem_info(p_geom1.sdo_elem_info.LAST) := 2;

       p_geom1.sdo_elem_info.EXTEND;
       p_geom1.sdo_elem_info(p_geom1.sdo_elem_info.LAST) := 1;

     END IF;

  -- skip the first three ordinates - ignore the measure because datum measures don't count.

     IF p_conn AND
        ABS(p_geom1.sdo_ordinates( last_1 - 2 ) - p_geom2.sdo_ordinates(1)) < p_diminfo(1).sdo_tolerance  AND
        ABS(p_geom1.sdo_ordinates( last_1 - 1 ) - p_geom2.sdo_ordinates(2)) < p_diminfo(2).sdo_tolerance THEN
        start_ic := 4;
     ELSE
        start_ic := 1;
     END IF;

     FOR ic IN start_ic..p_geom2.sdo_ordinates.LAST LOOP

        p_geom1.sdo_ordinates.EXTEND;

        IF MOD( ic, 3) = 0 THEN
          p_geom1.sdo_ordinates( p_geom1.sdo_ordinates.LAST )  := p_geom2.sdo_ordinates(ic) + l_meas;
        ELSE
          p_geom1.sdo_ordinates( p_geom1.sdo_ordinates.LAST )  := p_geom2.sdo_ordinates(ic);
        END IF;

     END LOOP;

  END;


--
--------------------------------------------------------------------------------------------------------------------
--

  PROCEDURE add_segments_m ( p_geom1 IN OUT NOCOPY mdsys.sdo_geometry, p_geom2 IN mdsys.sdo_geometry,
                             p_diminfo IN mdsys.sdo_dim_array,
                             p_conn IN BOOLEAN DEFAULT FALSE
         )  IS


  l_meas NUMBER := p_geom1.sdo_ordinates(p_geom1.sdo_ordinates.LAST);
  last_1 INTEGER := p_geom1.sdo_ordinates.LAST;

  start_ic INTEGER := 1;

  BEGIN

     IF NOT p_conn OR (
            ABS(p_geom1.sdo_ordinates( last_1 - 2 ) - p_geom2.sdo_ordinates(1)) > p_diminfo(1).sdo_tolerance OR
            ABS(p_geom1.sdo_ordinates( last_1 - 1 ) - p_geom2.sdo_ordinates(2)) > p_diminfo(2).sdo_tolerance)  THEN

  --   either intentionally not connected, or connected but no common ordinates
  --   so make multi-part
  --   but what when the geometry being added is MP

       p_geom1.sdo_elem_info.EXTEND;
       p_geom1.sdo_elem_info(p_geom1.sdo_elem_info.LAST) := p_geom1.sdo_ordinates.LAST + 1;

       p_geom1.sdo_elem_info.EXTEND;
       p_geom1.sdo_elem_info(p_geom1.sdo_elem_info.LAST) := 2;

       p_geom1.sdo_elem_info.EXTEND;
       p_geom1.sdo_elem_info(p_geom1.sdo_elem_info.LAST) := 1;

     END IF;

  -- skip the first three ordinates - ignore the measure because datum measures don't count.

     IF p_conn AND
        ABS(p_geom1.sdo_ordinates( last_1 - 2 ) - p_geom2.sdo_ordinates(1)) < p_diminfo(1).sdo_tolerance  AND
        ABS(p_geom1.sdo_ordinates( last_1 - 1 ) - p_geom2.sdo_ordinates(2)) < p_diminfo(2).sdo_tolerance THEN
        start_ic := 4;
     ELSE
        start_ic := 1;
     END IF;

     FOR ic IN start_ic..p_geom2.sdo_ordinates.LAST LOOP

        p_geom1.sdo_ordinates.EXTEND;

        IF MOD( ic, 3) = 0 THEN
          p_geom1.sdo_ordinates( p_geom1.sdo_ordinates.LAST )  := p_geom2.sdo_ordinates(ic);-- + l_meas;
        ELSE
          p_geom1.sdo_ordinates( p_geom1.sdo_ordinates.LAST )  := p_geom2.sdo_ordinates(ic);
        END IF;

     END LOOP;

  END;


--
--------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_table_diminfo( p_table IN VARCHAR2, p_column IN VARCHAR2 DEFAULT NULL ) RETURN mdsys.sdo_dim_array IS
retval mdsys.sdo_dim_array;
CURSOR c1 ( c_table IN VARCHAR2,
            c_column IN VARCHAR2 ) IS
   SELECT sdo_diminfo
   FROM mdsys.sdo_geom_metadata_table
   WHERE sdo_table_name = c_table
   AND   sdo_owner  = Hig.get_application_owner
   AND NVL( c_column, 'A') = DECODE( c_column, NULL, 'A', sdo_column_name  );

BEGIN
  OPEN c1( p_table, p_column);
  FETCH c1 INTO retval;
  IF c1%NOTFOUND THEN
    retval := NULL;
    CLOSE c1;
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                    ,pi_id                 => 197
                    ,pi_sqlcode            => -20001
                    );
-- raise_application_error( -20001, 'SDO Metadata for layer  not found' );
  ELSE
    CLOSE c1;
  END IF;
  RETURN retval;
END;

--
--------------------------------------------------------------------------------------------------------------------
--


FUNCTION get_layer_dimension( p_layer IN NM_THEMES_ALL.nth_theme_id%TYPE ) RETURN INTEGER IS
retval INTEGER;
BEGIN
  IF set_theme( p_layer ) THEN
    set_theme_metadata( p_layer );
  END IF;

  retval := g_usgm.diminfo.LAST;
  RETURN retval;
END;

--
--------------------------------------------------------------------------------------------------------------------
--

--
--------------------------------------------------------------------------------------------------------------------
--

FUNCTION remove_redundant_pts( p_layer IN NUMBER,
        p_geom IN mdsys.sdo_geometry ) RETURN mdsys.sdo_geometry IS
-- assumes 3D, single-part feature
retval mdsys.sdo_geometry := mdsys.sdo_geometry( 3302, p_geom.sdo_srid, p_geom.sdo_point,
                                    mdsys.sdo_elem_info_array(1,2,1),
                                    NULL) ;

l_elem    mdsys.sdo_elem_info_array := mdsys.sdo_elem_info_array(1,2,1);

l_elem_count INTEGER := 1;

ret_count INTEGER;

l_round1 INTEGER;
l_round2 INTEGER;
l_round3 INTEGER;


BEGIN

--nm_debug.debug_on;
--nm_debug.debug('start');

    IF set_theme( p_layer ) THEN
   set_theme_metadata( p_layer );
 END IF;

  l_round1 := Nm3unit.get_rounding( g_usgm.diminfo(1).sdo_tolerance );
  l_round2 := Nm3unit.get_rounding( g_usgm.diminfo(2).sdo_tolerance );
  l_round3 := Nm3unit.get_rounding( g_usgm.diminfo(3).sdo_tolerance );

--nm_debug.debug('Rounding 1,2 and 3 dims to '||
--               to_char(l_round1)||','||
--               to_char(l_round2)||','||
--               to_char(l_round3));


  IF p_geom.sdo_elem_info.LAST > 3 THEN
    l_elem_count := 4;
  END IF;

  IF p_geom.sdo_ordinates.LAST > 3 THEN

--  nm_debug.debug( 'first 3');

    FOR ic IN 1..3 LOOP
      IF ic = 1 THEN
     retval.sdo_ordinates := mdsys.sdo_ordinate_array(0);
  retval.sdo_ordinates(1) := ROUND( p_geom.sdo_ordinates(1), l_round1);
      ELSIF ic = 2 THEN
        retval.sdo_ordinates.EXTEND;
  retval.sdo_ordinates(2) := ROUND( p_geom.sdo_ordinates(2), l_round2);
      ELSE
        retval.sdo_ordinates.EXTEND;
  retval.sdo_ordinates(3) := ROUND( p_geom.sdo_ordinates(3), l_round3);
   END IF;

    END LOOP;

-- nm_debug.debug('4 onwards');

    FOR ic IN 4..p_geom.sdo_ordinates.LAST LOOP

      retval.sdo_ordinates.EXTEND;
      ret_count := retval.sdo_ordinates.LAST;

      IF MOD(ic, 3) = 1 THEN
         retval.sdo_ordinates(ret_count) := ROUND( p_geom.sdo_ordinates(ic), l_round1);
      ELSIF MOD(ic, 3 ) = 2 THEN
         retval.sdo_ordinates(ret_count) := ROUND( p_geom.sdo_ordinates(ic), l_round2);
      ELSE
         retval.sdo_ordinates(ret_count) := ROUND( p_geom.sdo_ordinates(ic), l_round3);
   END IF;

      IF MOD( ic, 3 ) = 0 THEN

--      use the tolerance

/*
nm_debug.debug('Compare '||to_char(retval.sdo_ordinates( ret_count ))||' with '||to_char( retval.sdo_ordinates( ret_count - 3)));
nm_debug.debug('Compare '||to_char(retval.sdo_ordinates( ret_count - 1 ))||' with '||to_char( retval.sdo_ordinates( ret_count - 4)));
nm_debug.debug('Compare '||to_char(retval.sdo_ordinates( ret_count - 2))||' with '||to_char( retval.sdo_ordinates( ret_count - 5)));
*/

        IF ABS( retval.sdo_ordinates( ret_count )     - retval.sdo_ordinates( ret_count - 3)) <= g_usgm.diminfo(3).sdo_tolerance AND
           ABS( retval.sdo_ordinates( ret_count - 1 ) - retval.sdo_ordinates( ret_count - 4)) <= g_usgm.diminfo(2).sdo_tolerance AND
           ABS( retval.sdo_ordinates( ret_count - 2 ) - retval.sdo_ordinates( ret_count - 5)) <= g_usgm.diminfo(1).sdo_tolerance THEN
--         redundant

          retval.sdo_ordinates.trim;
          retval.sdo_ordinates.trim;
          retval.sdo_ordinates.trim;


        END IF;
      END IF;
    END LOOP;
    RETURN retval;
  ELSE
    RETURN p_geom;
  END IF;
END;

--
--------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_nearest_to_xy( p_layer IN NUMBER, p_pt_geom IN mdsys.sdo_geometry ) RETURN nm_elements.ne_id%TYPE IS
BEGIN
  RETURN get_nearest_to_xy ( p_layer, p_pt_geom.sdo_point.X, p_pt_geom.sdo_point.Y);
END;

--
--------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_nearest_to_xy( p_layer IN NUMBER, p_x IN NUMBER, p_y IN NUMBER ) RETURN nm_elements.ne_id%TYPE IS

-- This function and get_nearest_theme_to_xy have converged after the removal of the nm_layers view.

cur_string VARCHAR2(2000);

retval     nm_elements.ne_id%TYPE;

BEGIN

  RETURN get_nearest_theme_to_xy( p_layer, p_x, p_y );

END;

--
--------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_nearest_to_xy_on_route( p_layer IN NUMBER,
                                     p_ne_id IN NUMBER,
                                     p_x IN NUMBER,
          p_y IN NUMBER ) RETURN nm_elements.ne_id%TYPE IS

l_pa  ptr_array;
type memcurtype is ref cursor;
memcur memcurtype;
curstr varchar2(2000);
retval     nm_elements.ne_id%TYPE;


BEGIN

  l_pa := Get_Batch_Of_Base_Nn( p_theme => p_layer, p_x => p_x, p_y => p_y );

  curstr := 'SELECT /*+cardinality( p '||to_char( l_pa.pa.last )||')*/ nm_ne_id_of '||
            ' FROM nm_members, TABLE ( :pa ) p '||
            ' WHERE nm_ne_id_in = :c_ne_id '||
            ' AND   p.ptr_value = nm_ne_id_of'||
            ' order by p.ptr_id';

  open memcur for curstr using l_pa.pa, p_ne_id;
--  OPEN c1( p_ne_id, l_pa );

  FETCH memcur INTO retval;

  CLOSE memcur;

  RETURN retval;



END;

--
--------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_nearest_theme_to_xy( p_theme IN NUMBER, p_x IN NUMBER, p_y IN NUMBER ) RETURN NUMBER IS

nthrow NM_THEMES_ALL%ROWTYPE;
nthmet user_sdo_geom_metadata%ROWTYPE;

cur_string VARCHAR2(2000);

l_pt       ptr_array;

retval     nm_elements.ne_id%TYPE;


BEGIN

  nthrow := Nm3get.get_nth( p_theme );
  nthmet := get_theme_metadata( p_theme);

  l_pt   :=  Get_Batch_Of_Base_Nn( p_theme => p_theme, p_x => p_x, p_y => p_y);

  if l_pt.pa.last is null then
    raise no_data_found;
  else
    RETURN l_pt.pa(1).ptr_value;
  end if;

END;

--
--------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_projection_to_nearest( p_layer IN NUMBER, p_pt_geom IN mdsys.sdo_geometry ) RETURN nm_lref IS

BEGIN

RETURN get_projection_to_nearest( p_layer, p_pt_geom.sdo_point.X,  p_pt_geom.sdo_point.Y);

END;


--
--------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_projection_to_nearest( p_layer IN NUMBER, p_x IN NUMBER, p_y IN NUMBER ) RETURN nm_lref IS

l_ne   nm_elements.ne_id%TYPE;
l_proj mdsys.sdo_geometry;

BEGIN

  l_ne   := get_nearest_to_xy( p_layer, p_x, p_y );

  l_proj := get_projection( p_layer, l_ne, p_x, p_y);

  RETURN nm_lref( l_ne, l_proj.sdo_ordinates(3) );
END;

--
--------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_nearest_lref( p_theme IN NM_THEMES_ALL.nth_theme_id%TYPE, p_geom IN mdsys.sdo_geometry ) RETURN nm_lref IS
--simple wrapper to get nearest snapping point.
l_theme_list nm_theme_list;
l_lref       nm_lref;
l_geom       mdsys.sdo_geometry := get_2d_pt( p_geom );
nerow        nm_elements%ROWTYPE;
BEGIN

--  l_theme_list := nm3sdo.get_nw_snaps_at_xy( p_theme, p_geom );

    l_lref := get_nearest_nw_to_xy( l_geom.sdo_point.x, l_geom.sdo_point.y, get_base_themes( p_theme ) );

--  l_lref       := nm_lref( l_theme_list.ntl_theme_list(1).ntd_pk_id, l_theme_list.ntl_theme_list(1).ntd_measure );

    nerow := Nm3get.get_ne( l_lref.lr_ne_id );

 l_lref.lr_offset := LEAST( nerow.ne_length, Nm3unit.get_formatted_value( l_lref.lr_offset, Nm3net.get_nt_units( nerow.ne_nt_type )));

    RETURN l_lref;

EXCEPTION
  WHEN OTHERS THEN
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                    ,pi_id                 => 286
                    ,pi_sqlcode            => -20001
                    );
--  raise_application_error( -20001, 'No snaps at this position');
END;

--
--------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_start_point( p_layer IN NUMBER, p_ne_id IN nm_elements.ne_id%TYPE ) RETURN mdsys.sdo_geometry IS

retval mdsys.sdo_geometry;

cur_string VARCHAR2(2000);
BEGIN

  IF set_theme( p_layer ) THEN
    set_theme_metadata( p_layer );
  END IF;

  cur_string := 'select sdo_lrs.geom_segment_start_pt( '||g_usgm.column_name||', :diminfo ) '||
                'from '||g_usgm.table_name||
                ' where '||g_nth.nth_feature_pk_column||' = :ne_id ';


  EXECUTE IMMEDIATE cur_string INTO retval USING g_usgm.diminfo, p_ne_id;

  RETURN retval;
END;

--
--------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_end_point( p_layer IN NUMBER, p_ne_id IN nm_elements.ne_id%TYPE ) RETURN mdsys.sdo_geometry IS

retval mdsys.sdo_geometry;

cur_string VARCHAR2(2000);
BEGIN
  IF set_theme( p_layer ) THEN
    set_theme_metadata( p_layer );
  END IF;

  cur_string := 'select sdo_lrs.geom_segment_end_pt( '||g_usgm.column_name||', :diminfo ) '||
                'from '||g_usgm.table_name||
                ' where '||g_nth.nth_feature_pk_column||' = :ne ';


  EXECUTE IMMEDIATE cur_string INTO retval USING g_usgm.diminfo, p_ne_id;

  RETURN retval;
END;

--
--------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_start_point( p_layer IN NUMBER, p_ne_id IN nm_elements.ne_id%TYPE,
                          p_cardinality IN nm_members.nm_cardinality%TYPE ) RETURN mdsys.sdo_geometry IS

retval mdsys.sdo_geometry;

BEGIN

  IF p_cardinality = 1 THEN
    RETURN get_start_point( p_layer, p_ne_id );
  ELSE
    RETURN get_end_point( p_layer, p_ne_id );
  END IF;
END;

--
--------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_end_point( p_layer IN NUMBER, p_ne_id IN nm_elements.ne_id%TYPE,
                          p_cardinality IN nm_members.nm_cardinality%TYPE ) RETURN mdsys.sdo_geometry IS

retval mdsys.sdo_geometry;

BEGIN

  IF p_cardinality = -1 THEN
    RETURN get_start_point( p_layer, p_ne_id );
  ELSE
    RETURN get_end_point( p_layer, p_ne_id );
  END IF;
END;

--
---------------------------------------------------------------------------------------------------------------------
--
FUNCTION Get_Layer_Element_Geometry( p_ne_id IN nm_elements.ne_id%TYPE ) RETURN mdsys.sdo_geometry IS
l_layer NUMBER;
BEGIN
  l_layer := Get_Datum_Theme( Nm3get.get_ne_all(p_ne_id).ne_nt_type);
  RETURN Get_Layer_Element_Geometry( l_layer, p_ne_id );
END;
--
---------------------------------------------------------------------------------------------------------------------
--

FUNCTION Get_Layer_Element_Geometry( p_layer IN NUMBER,
                                     p_ne_id IN nm_elements.ne_id%TYPE ) RETURN mdsys.sdo_geometry IS

retval mdsys.sdo_geometry;

cur_string VARCHAR2(2000);
BEGIN

  IF set_theme( p_layer ) THEN
    set_theme_metadata( p_layer );
  END IF;

  cur_string := 'select '||g_usgm.column_name||
                ' from '||g_usgm.table_name||
                ' where '||g_nth.nth_feature_pk_column||' = :ne ';

  EXECUTE IMMEDIATE cur_string INTO retval USING p_ne_id;

  RETURN retval;
EXCEPTION

--oracle 8i has a problem if no data is found  in this routine without the exception being handled
--it needs an exception handler but the program needs to return null where no data is found.
--It is used in the concatenantion of route shapes where a null shape will constitute a break between
--two parts of a geometry.

  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END;

--
---------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_layer_fragment_geometry( p_ne_id IN nm_elements.ne_id%TYPE,
           p_begin IN NUMBER,
           p_end   IN NUMBER ) RETURN mdsys.sdo_geometry IS

l_layer NUMBER;
BEGIN

  l_layer := Get_Datum_Theme( Nm3get.get_ne_all(p_ne_id).ne_nt_type );
  RETURN get_layer_fragment_geometry( l_layer, p_ne_id, p_begin, p_end );
END;

--
---------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_layer_fragment_geometry( p_layer IN NUMBER,
                                      p_ne_id IN nm_elements.ne_id%TYPE,
           p_begin IN NUMBER,
           p_end   IN NUMBER ) RETURN mdsys.sdo_geometry IS

retval mdsys.sdo_geometry;

l_length NUMBER := Nm3get.get_ne_all( p_ne_id ).ne_length;

cur_string VARCHAR2(2000);

BEGIN

  IF set_theme( p_layer ) THEN
    set_theme_metadata( p_layer );
  END IF;

  retval := Get_Layer_Element_Geometry( p_layer, p_ne_id );

  IF is_clipped(p_begin, p_end, l_length ) = 0 THEN

    retval := sdo_lrs.clip_geom_segment( retval, g_usgm.diminfo, p_begin, p_end );

  END IF;

  RETURN retval;
EXCEPTION

  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END;

--
---------------------------------------------------------------------------------------------------------------------
--

PROCEDURE split_element_at_measure( p_layer IN NUMBER,
                                    p_ne_id IN nm_elements.ne_id%TYPE,
                                    p_measure IN NUMBER,
                                    p_ne_id_1 IN nm_elements.ne_id%TYPE,
                                    p_ne_id_2 IN nm_elements.ne_id%TYPE,
                                    p_geom1 OUT mdsys.sdo_geometry, p_geom2 OUT mdsys.sdo_geometry ) IS

l_geom    mdsys.sdo_geometry := Get_Layer_Element_Geometry( p_layer, p_ne_id );

l_geom_1 mdsys.sdo_geometry;
l_geom_2 mdsys.sdo_geometry;

l_end    NUMBER;

BEGIN

  IF set_theme( p_layer ) THEN
    set_theme_metadata( p_layer );
  END IF;

  IF element_has_shape( p_layer, p_ne_id ) = 'TRUE' THEN

    sdo_lrs.split_geom_segment( l_geom, g_usgm.diminfo, p_measure, p_geom1, p_geom2 );

    l_end   := Nm3net.get_datum_element_length( p_ne_id ) - p_measure;

    p_geom2 := sdo_lrs.SCALE_GEOM_SEGMENT( GEOM_SEGMENT => p_geom2, DIM_ARRAY=> g_usgm.diminfo,
                  START_MEASURE => 0, END_MEASURE=> l_end , SHIFT_MEASURE=> 0 );
  ELSE
    p_geom1 := NULL;
    p_geom2 := NULL;
  END IF;
END;

--
---------------------------------------------------------------------------------------------------------------------
-- This only applies to whole element routes.
PROCEDURE merge_element_shapes ( p_layer IN NUMBER,
                                 p_ne_id_1 IN nm_elements.ne_id%TYPE,
                                 p_ne_id_2 IN nm_elements.ne_id%TYPE,
                                 p_ne_id_to_flip IN nm_elements.ne_id%TYPE,
                                 p_geom    OUT mdsys.sdo_geometry ) IS

l_geom_1  mdsys.sdo_geometry;
l_geom_2  mdsys.sdo_geometry;
l_connect NUMBER;

BEGIN

  IF set_theme( p_layer ) THEN
    set_theme_metadata( p_layer );
  END IF;

  l_connect := Nm3pla.defrag_connectivity( p_ne_id_1, p_ne_id_2 );

  IF Nm3sdo.element_has_shape( p_layer, p_ne_id_1 ) = 'TRUE' AND
     Nm3sdo.element_has_shape( p_layer, p_ne_id_2 ) = 'TRUE' THEN

    IF p_ne_id_to_flip = p_ne_id_1 THEN
      l_geom_1 := Nm3sdo.reverse_geometry( Nm3sdo.Get_Layer_Element_Geometry( p_layer, p_ne_id_1 ));
      l_geom_2 := Nm3sdo.Get_Layer_Element_Geometry( p_layer, p_ne_id_2 );
    ELSIF p_ne_id_to_flip = p_ne_id_2 THEN
      l_geom_1 := Nm3sdo.Get_Layer_Element_Geometry( p_layer, p_ne_id_1 );
      l_geom_2 := Nm3sdo.reverse_geometry(Nm3sdo.Get_Layer_Element_Geometry( p_layer, p_ne_id_2 ));
    ELSE
      l_geom_1 := Nm3sdo.Get_Layer_Element_Geometry( p_layer, p_ne_id_1 );
      l_geom_2 := Nm3sdo.Get_Layer_Element_Geometry( p_layer, p_ne_id_2 );
    END IF;

--  Need to flip the order of concatenation to preserve the measures

    IF sdo_lrs.connected_geom_segments( l_geom_1, g_usgm.diminfo, l_geom_2, g_usgm.diminfo ) = 'TRUE' THEN

      IF l_connect = -2 OR l_connect = 1 OR l_connect = 0 THEN

        p_geom := sdo_lrs.concatenate_geom_segments( l_geom_1, g_usgm.diminfo, l_geom_2, g_usgm.diminfo );

      ELSIF l_connect = 2 OR l_connect = -1 THEN

        p_geom := sdo_lrs.concatenate_geom_segments( l_geom_2, g_usgm.diminfo, l_geom_1, g_usgm.diminfo );

      END IF;

    ELSE

      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                    ,pi_id                 => 199
                    ,pi_sqlcode            => -20001
                    );
--      raise_application_error ( -20001, 'Element shapes not connected');

    END IF;


  ELSIF Nm3sdo.element_has_shape( p_layer, p_ne_id_1 ) = 'TRUE' OR
        Nm3sdo.element_has_shape( p_layer, p_ne_id_2 ) = 'TRUE' THEN

      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                    ,pi_id                 => 201
                    ,pi_sqlcode            => -20001
                    );
--    raise_application_error(-20001, 'Only one element has shape - merge prevented');

  ELSE
    p_geom := NULL;
  END IF;

END;

--
-------------------------------------------------------------------------------------------------------------------------------
--

FUNCTION recalibrate_geometry( p_layer IN NUMBER,
                               p_geom  IN OUT NOCOPY mdsys.sdo_geometry,
                               p_measure IN NUMBER,
                               p_length_to_end IN NUMBER,
                               p_ne_id IN NUMBER DEFAULT NULL)
                         RETURN mdsys.sdo_geometry IS

l_ord  mdsys.sdo_ordinate_array;
l_last INTEGER := p_geom.sdo_ordinates.LAST/3;
l_pt   mdsys.sdo_geometry;
retval mdsys.sdo_geometry;
l_shift     NUMBER := 0;
l_end       NUMBER;
l_insert_pt BOOLEAN := FALSE;

l_length    NUMBER;

BEGIN

  IF set_theme( p_layer ) THEN
    set_theme_metadata( p_layer );
  END IF;

  l_end :=  sdo_lrs.geom_segment_end_measure(p_geom, g_usgm.diminfo);

--     the p_ne_id parameter is only used to prevent mismatching lengths.

----   nm_debug.delete_debug(true);
  --   nm_debug.debug_on;

--if the start measure is zero, we only need to apply the rescale evenly across all vertices so just use the native Oracle tool.

  IF p_measure = 0 THEN

    retval := p_geom;
    sdo_lrs.redefine_geom_segment( retval, g_usgm.diminfo, 0, p_length_to_end );

  ELSE

--  need to breal the shape and redefine measures, possibly with new vertices.

    l_pt := sdo_lrs.locate_pt( p_geom, g_usgm.diminfo, p_measure);

    l_insert_pt := FALSE;

    FOR i IN 1..l_last LOOP

      IF i = 1 THEN

        --   nm_debug.debug('First point');

        l_ord := mdsys.sdo_ordinate_array( p_geom.sdo_ordinates(1));
        l_ord.EXTEND;
        l_ord(2) := p_geom.sdo_ordinates(2);
        l_ord.EXTEND;
        l_ord(3) := p_geom.sdo_ordinates(3);

      ELSE

        IF NOT l_insert_pt THEN
          --   nm_debug.debug( 'compare '||to_char(p_measure) ||' and '||to_char(p_geom.sdo_ordinates( 3*(i-1)+3 )));
          NULL;
        END IF;

        IF p_geom.sdo_ordinates( 3*(i-1)+3 ) > p_measure AND NOT l_insert_pt THEN

           --   nm_debug.debug( to_char(p_measure) ||' < point at '||to_char(p_geom.sdo_ordinates( 3*(i-1)+3 )));

           --   nm_debug.debug( 'Pt coords are '||to_char(l_pt.sdo_ordinates(1))||','||
           --                                to_char(l_pt.sdo_ordinates(2))||','||
           --                                to_char(l_pt.sdo_ordinates(3)));

           --   nm_debug.debug( 'compared with  '||to_char(p_geom.sdo_ordinates( 3*(i-1)+1))||','||
           --                                to_char(p_geom.sdo_ordinates( 3*(i-1)+2))||','||
           --                                to_char(p_geom.sdo_ordinates( 3*(i-1)+3)));

           IF l_pt.sdo_ordinates(1) <> p_geom.sdo_ordinates( 3*(i-2)+1) OR
              l_pt.sdo_ordinates(2) <> p_geom.sdo_ordinates( 3*(i-2)+2) OR
              l_pt.sdo_ordinates(3) <> p_geom.sdo_ordinates( 3*(i-2)+3) THEN

              --   nm_debug.debug( 'need to add new point');

     --       need to insert new point

              l_ord.EXTEND;
              l_ord(l_ord.LAST) := l_pt.sdo_ordinates(1);
              l_ord.EXTEND;
              l_ord(l_ord.LAST) := l_pt.sdo_ordinates(2);
              l_ord.EXTEND;
              l_ord(l_ord.LAST) := p_measure;

           END IF;

  --         l_shift := p_geom.sdo_ordinates( 3*(i -1)+3 ) - p_measure - l_pt.sdo_ordinates(3);

           l_shift :=  p_length_to_end / ( l_end - p_measure );

           --   nm_debug.debug('carry on - shifted value = '||to_char(l_shift));

           l_insert_pt := TRUE;

        END IF;

        l_ord.EXTEND;
        l_ord(l_ord.LAST) := p_geom.sdo_ordinates( 3*(i-1) + 1 );
        l_ord.EXTEND;
        l_ord(l_ord.LAST) := p_geom.sdo_ordinates( 3*(i-1) + 2 );
        l_ord.EXTEND;

        IF l_shift > 0 THEN
          l_ord(l_ord.LAST) :=  p_measure + ((p_geom.sdo_ordinates( 3*(i-1) + 3 )-p_measure) * l_shift);
        ELSE
          l_ord(l_ord.LAST) := p_geom.sdo_ordinates( 3*(i-1) + 3 );
        END IF;

      END IF;

    END LOOP;

    retval := mdsys.sdo_geometry( p_geom.sdo_gtype, p_geom.sdo_srid,
                             p_geom.sdo_point, p_geom.sdo_elem_info,
                             l_ord );

    IF p_ne_id IS NOT NULL THEN

      l_length := Nm3net.Get_Ne_Length( p_ne_id );

      IF sdo_lrs.geom_segment_end_measure ( retval, g_usgm.diminfo ) != l_length THEN

         sdo_lrs.redefine_geom_segment( retval, g_usgm.diminfo, 0, l_length );

      END IF;

    END IF;

  END IF;


  RETURN retval;

END ;

--
---------------------------------------------------------------------------------------------------------------------
--

procedure redefine_geom_segment1( p_geom in out nocopy mdsys.sdo_geometry, p_diminfo mdsys.sdo_dim_array,
                                                  p_start in number, p_end in number, dummy in integer ) is

l_dp         integer;

l_old_end    number := sdo_lrs.GEOM_SEGMENT_END_MEASURE( p_geom);
l_old_start  number := sdo_lrs.GEOM_SEGMENT_START_MEASURE( p_geom);
l_new_length number := p_end - p_start;
l_old_length number := l_old_end - l_old_start;


divide_by_zero exception;
pragma exception_init( divide_by_zero, -1476);



begin

  if p_diminfo.last < 3 then
    raise_application_error( -20001, 'Invalid dimension for handling measures');
  end if;

  l_dp := greatest(Nm3unit.get_rounding( p_diminfo(3).sdo_tolerance ) -1, 0);

  for i in 1..p_geom.sdo_ordinates.last loop
    if mod(i, 3) = 0 then
      begin
        p_geom.sdo_ordinates(i) := p_start +  round( ( (p_geom.sdo_ordinates(i) - l_old_start)* l_new_length/l_old_length ), l_dp);
      exception
        when divide_by_zero then
        null;  -- leave the ordinate the same
      end;
    end if;
  end loop;

end;

--
---------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_route_shape( p_ne_id    IN nm_elements.ne_id%TYPE,
                          p_nt       IN ptr_vc_array,
        p_th       IN ptr_array,
        p_nth_tab  IN nth_row_tab_type,
        p_diminfo  IN mdsys.sdo_dim_array,
        p_srid     IN NUMBER,
        p_part     IN VARCHAR2 DEFAULT NULL ) RETURN mdsys.sdo_geometry IS
/*

The proces sis restricted by a bug in Oracle Spatial (Oracle TAR 1558578.999), where selections using an ORDER BY clause that
selects SDO_GEOMETRY types with more that 4000+ ordinates fail with:

ORA-22813: operand value exceeds system limits

This prohibits use of array fetches with an order-by.

*/


TYPE geocurtyp IS REF CURSOR;

geocur      geocurtyp;

cur_string  VARCHAR2(2000);

geocur1     geocurtyp;

cur_string1 VARCHAR2(2000);

TYPE           tab_geom IS TABLE OF mdsys.sdo_geometry INDEX BY BINARY_INTEGER;
l_geom_tab     tab_geom;

l_cardinality  Nm3type.tab_number;
l_length       Nm3type.tab_number;
l_start        Nm3type.tab_number;
l_end          Nm3type.tab_number;
l_slk          Nm3type.tab_number;
l_true         Nm3type.tab_number;
l_end_slk      Nm3type.tab_number;
l_end_true     Nm3type.tab_number;
l_ne_id        Nm3type.tab_number;
l_ne_type      Nm3type.tab_varchar1;
l_nt_type      Nm3type.tab_varchar4;


--l_geom         mdsys.sdo_geometry;

l_last_measure NUMBER;

l_break        BOOLEAN := FALSE;
l_conn         BOOLEAN := FALSE;

retval mdsys.sdo_geometry;

j INTEGER;

l_th_id  NUMBER;

l_action VARCHAR2(10);

l_part   VARCHAR2(1);

BEGIN

--nm_debug.debug_on;

  IF p_part IS NULL THEN
    l_part  := Nm3net.is_gty_partial( Nm3get.get_ne_all( p_ne_id ).ne_gty_group_type );
  ELSE
    l_part := p_part;
  END IF;

  IF p_th.pa.LAST > 1 THEN

--  There are multiple datum types

    l_action := 'MULTIPLE';

  ELSIF p_th.pa(1).ptr_id IS NULL THEN

--  There are no known themes, go and populate the arrays.
    l_action := 'NONE';
    Hig.raise_ner(pi_appl                => Nm3type.c_hig
                 ,pi_id                 => 281
                 ,pi_sqlcode            => -20001
                    );
-- raise_application_error(-20001,'No themes');

  ELSE

--  There is only one single supplied theme.
    l_action := 'SINGLE';

  END IF;

--nm_debug.debug(l_action);

--  for i in 1..l_th.pa.last loop
--    nm_debug.debug('Type = '||l_nt.pa(i).ptr_value );
--    nm_debug.debug(' theme = '||to_char(l_th.pa(i).ptr_value ));
--  end loop;

/*
  if l_action = 'SINGLE' then


--  we can generate the datum shapes from a single array fetch for the whole route.

    cur_string := 'select nm_ne_id_of ne_id, a.ne_length, nm_begin_mp, nm_end_mp, nm_cardinality, nm_slk, nm_true, nm_end_slk, nm_end_true, a.ne_type, a.ne_nt_type, '||l_nth_row_tab(1).nth_feature_shape_column||
                             '  from nm_elements a, nm_members, '||l_nth_row_tab(1).nth_feature_table||' f'||
                             '  where nm_ne_id_in = :c_ne_id '||
                             '  and   nm_ne_id_of = a.ne_id '||
        '  and   nm_ne_id_of = f.'||l_nth_row_tab(1).nth_feature_pk_column||
                             '  order by nm_seq_no ';

    open geocur for cur_string using p_ne_id;

 fetch geocur bulk collect into l_ne_id, l_length, l_start, l_end, l_cardinality, l_slk, l_true, l_end_slk, l_end_true, l_ne_type, l_nt_type, l_geom_tab;

 close geocur;

  else
*/

/*
    for j in 1..l_nt.pa.last loop
   nm_debug.debug( to_char(j)||','||to_char( l_nt.pa(j).ptr_id)||','||l_nt.pa(j).ptr_value||','||
                                    to_char( l_th.pa(j).ptr_id)||','||to_char( l_th.pa(j).ptr_value));
    end loop;
*/

--  there are more than one theme, extract the nt type and get the theme for each nt type, retrive the shape from that theme, one at a time.
--  fill the arrays, then use a common insert process


    cur_string := 'select nm_ne_id_of ne_id, a.ne_length, nm_begin_mp, nm_end_mp, nm_cardinality, nm_slk, nm_true, nm_end_slk, nm_end_true, a.ne_type, a.ne_nt_type '||
                             '  from nm_elements a, nm_members '||
                             '  where nm_ne_id_in = :c_ne_id '||
                             '  and   nm_ne_id_of = a.ne_id '||
                             '  order by nm_seq_no, nm_slk  ';

    OPEN geocur FOR cur_string USING p_ne_id;

    FETCH geocur BULK COLLECT INTO l_ne_id, l_length, l_start, l_end, l_cardinality, l_slk, l_true, l_end_slk, l_end_true, l_ne_type, l_nt_type;

    CLOSE geocur;


    FOR i IN 1..l_ne_id.COUNT LOOP

--   nm_debug.debug('I = '||to_char(i)||', Type = '||l_nt_type(i));

     j := p_nt.get_idx_from_value( l_nt_type(i) );

--     nm_debug.debug( 'Ptr = '||to_char( j ));

      l_th_id := p_th.pa(j).ptr_value;

      l_geom_tab(i) := Nm3sdo.Get_Layer_Element_Geometry( l_th_id, l_ne_id(i) );

--    nm_debug.debug( 'Id '||to_char(l_ne_id(i))||' is type '||l_nt_type(i)||' and theme '||to_char(l_th_id));

    END LOOP;


--  end if;


  FOR i IN 1..l_ne_id.COUNT LOOP

    IF l_ne_type(i) != 'D' THEN

      IF l_geom_tab(i).sdo_elem_info IS NOT NULL THEN

--        nm_debug.debug('NE = '||to_char(l_ne_id(i))||' Elem info is not null - proceed');

--      first clip the shape if necessary and rescale it to start at the true distance?

        IF l_part = 'Y' THEN

          IF Nm3sdo.is_clipped( l_start(i), l_end(i), l_length(i) ) = 0 THEN
  --          nm_debug.debug('Clipped between '||to_char( l_start(i) )||' and '||to_char(l_end(i))||' length = '||to_char(l_length(i)));

            l_geom_tab(i) := sdo_lrs.clip_geom_segment( l_geom_tab(i), p_diminfo, l_start(i), l_end(i) );

--          nm_debug.debug('End of clip - scale');
--          l_geom := sdo_lrs.SCALE_GEOM_SEGMENT( l_geom, l_diminfo, 0,  (l_end-l_start), 0);
--          sdo_lrs.redefine_geom_segment( l_geom_tab(i), p_diminfo, 0, l_end(i)-l_start(i));
--          sdo_lrs.redefine_geom_segment( l_geom_tab(i), p_diminfo, nvl(l_slk(i),0), NVL(l_end_slk(i),0));
--          nm_debug.debug('End of scale');

--          ELSE
--            nm_debug.debug('Whole element group - no clipping');

--            sdo_lrs.redefine_geom_segment( l_geom_tab(i), p_diminfo, nvl(l_slk(i),0), NVL(l_end_slk(i), 0));
--            sdo_lrs.redefine_geom_segment( l_geom_tab(i), p_diminfo, 0, NVL(l_end_slk(i)-l_slk(i), 0));

--         NULL;

          END IF;

--        sdo_lrs.redefine_geom_segment( l_geom_tab(i), p_diminfo, nvl(l_slk(i),0), NVL(l_end_slk(i),0));

        ELSE
--           nm_debug.debug('Not clipped '||to_char( l_slk(i) )||' and '||to_char(l_end_slk(i))||' length = '||to_char(l_length(i)));
           NULL;
--         sdo_lrs.redefine_geom_segment( l_geom_tab(i), p_diminfo, nvl(l_slk(i),0), NVL(l_end_slk(i), 0));
--         sdo_lrs.redefine_geom_segment( l_geom_tab(i), p_diminfo, 0, NVL(l_end_slk(i)-l_slk(i), 0));

        END IF;

--      sdo_lrs.redefine_geom_segment( l_geom_tab(i), p_diminfo, nvl(l_slk(i),0), NVL(l_end_slk(i), 0));

        redefine_geom_segment1( l_geom_tab(i), p_diminfo, nvl(l_slk(i),0), NVL(l_end_slk(i), 0), 0);

        IF l_cardinality(i) < 0 THEN

--        nm_debug.debug('Reverse - ne_id = '||to_char(l_ne_id));

--        l_geom := sdo_lrs.reverse_geometry( l_geom, l_diminfo );

--        nm_debug.debug('Reverse measure');
          l_geom_tab(i) := Nm3sdo.reverse_geometry( l_geom_tab(i) );

--        l_geom := sdo_lrs.reverse_measure( l_geom, l_diminfo );
--        nm_debug.debug('End Reverse');

        END IF;

--      if geocur%rowcount = 1 then

        IF retval.sdo_elem_info IS NULL THEN
--          nm_debug.debug('Start '||l_slk(i)||' to '||l_end_slk(i));
--          sdo_lrs.redefine_geom_segment( l_geom_tab(i), p_diminfo, NVL(l_slk(i),0), l_end(i)-l_start(i));
--          sdo_lrs.redefine_geom_segment( l_geom_tab(i), p_diminfo, NVL(l_slk(i),0), NVL(l_end_slk(i), 0));
          retval := l_geom_tab(i);
          l_last_measure := l_end_slk(i);
--        nm_debug.debug('First one, start at '||to_char(l_slk));
        ELSE

--        concatenate the segments into one if they are connected, else multi-part

          IF l_break OR l_slk(i) IS NULL OR
             l_last_measure != l_slk(i) THEN

--          there was a break in the route previously - make mp

--          nm_debug.debug('First after a db - use MP');
--          retval := add_segments( retval, l_geom );
            add_segments_m( retval, l_geom_tab(i), p_diminfo, FALSE );

--          retval := sdo_lrs.concatenate_geom_segments( retval, p_diminfo, l_geom_tab(i), p_diminfo );

--          nm_debug.debug('End add seg');

          ELSE

--          nm_debug.debug('Test connect');

            IF sdo_lrs.connected_geom_segments( retval, p_diminfo, l_geom_tab(i), p_diminfo ) = 'TRUE' THEN

              l_conn := TRUE;

--                nm_debug.debug('concat ');
--              retval := sdo_lrs.concatenate_geom_segments( retval, l_diminfo, l_geom, l_diminfo );

--              nm_debug.debug('End concat');

            END IF;

            add_segments_m( retval, l_geom_tab(i), p_diminfo, l_conn );

--          retval := sdo_lrs.concatenate_geom_segments( retval, p_diminfo, l_geom_tab(i), p_diminfo );

--          Nm3sdo.add_segments( retval, l_geom_tab(i), p_diminfo, l_conn );
--          nm_debug.debug('Not connected - MP');
--          retval := add_segments( retval, l_geom );
--              --   nm_debug.debug('End add seg');

--          end if;

          END IF;

        END IF;

      ELSE
--        --   nm_debug.debug('NE = '||to_char(l_ne_id)||' Elem info is null - no use');
        NULL;
      END IF;
      l_break := FALSE;
      l_conn  := FALSE;
    ELSE
--    nm_debug.debug('Its a DB');
      l_break := TRUE;
      l_conn  := FALSE;
    END IF;

    l_last_measure := l_end_slk(i);

  END LOOP;

  RETURN retval;
END;
--
-----------------------------------------------------------------------------------------------------------------
--

FUNCTION get_route_shape( p_ne_id    IN nm_elements.ne_id%TYPE ) RETURN mdsys.sdo_geometry IS

l_nt   ptr_vc_array;
l_th   ptr_array;

l_nth_row_tab nth_row_tab_type;

l_diminfo mdsys.sdo_dim_array;

l_srid NUMBER;

l_part   VARCHAR2(1) := Nm3net.is_gty_partial( Nm3get.get_ne_all( p_ne_id ).ne_gty_group_type );

BEGIN

    l_nt := get_base_nt( p_ne_id => p_ne_id );

 l_th := get_base_themes( l_nt );

    FOR i IN 1..l_th.pa.LAST LOOP
      l_nth_row_tab(i) := Nm3get.get_nth( l_th.pa(i).ptr_value );
    END LOOP;

    Nm3sdo.set_diminfo_and_srid( p_themes  => make_tha_from_ptr( l_th ),
                                 p_diminfo => l_diminfo,
              p_srid    => l_srid );

    RETURN get_route_shape( p_ne_id   => p_ne_id
                        ,p_nt      => l_nt
         ,p_th      => l_th
         ,p_nth_tab => l_nth_row_tab
         ,p_diminfo => l_diminfo
         ,p_srid    => l_srid
         ,p_part    => l_part );
END;
--
-----------------------------------------------------------------------------------------------------------------
--
FUNCTION get_shape_from_ne( p_ne_id IN nm_elements.ne_id%TYPE ) RETURN mdsys.sdo_geometry IS

TYPE geocurtyp IS REF CURSOR;

geocur geocurtyp;


cur_string VARCHAR2(2000) := 'select nm_ne_id_of ne_id, a.ne_length, nm_begin_mp, nm_end_mp, nm_cardinality, nm_slk, nm_true, a.ne_type, a.ne_nt_type '||
                             '  from nm_elements a, nm_members '||
                             '  where nm_ne_id_in = :c_ne_id '||
                             '  and   nm_ne_id_of = a.ne_id '||
                             '  order by nm_seq_no ';


l_geom         mdsys.sdo_geometry;
l_cardinality  nm_members.nm_cardinality%TYPE;
l_length       nm_elements.ne_length%TYPE;
l_start        nm_members.nm_begin_mp%TYPE;
l_end          nm_members.nm_end_mp%TYPE;
l_slk          nm_members.nm_slk%TYPE;
l_true         nm_members.nm_true%TYPE;
l_ne_id        nm_elements.ne_id%TYPE;
l_ne_type      nm_elements.ne_type%TYPE;
l_nt_type      nm_elements.ne_nt_type%TYPE;

l_break        BOOLEAN := FALSE;
l_conn         BOOLEAN := FALSE;

l_layer        NUMBER;

retval mdsys.sdo_geometry;

BEGIN

----   nm_debug.debug_on;
----   nm_debug.delete_debug(true);
----   nm_debug.debug( cur_string );

  OPEN geocur FOR cur_string USING p_ne_id;
  LOOP

    FETCH geocur INTO l_ne_id, l_length, l_start, l_end, l_cardinality, l_slk, l_true, l_ne_type, l_nt_type;
    EXIT WHEN geocur%NOTFOUND;

    IF l_ne_type != 'D' THEN

   l_layer := Get_Datum_Theme( l_nt_type );

      IF set_theme( l_layer ) THEN
        set_theme_metadata( l_layer );
      END IF;

      l_geom := Get_Layer_Element_Geometry( l_layer, l_ne_id );

      IF l_geom.sdo_elem_info IS NOT NULL THEN

--      --   nm_debug.debug('NE = '||to_char(l_ne_id)||' Eleme info is not null - proceed');

--      first clip the shape if necessary and rescale it to start at the true distance?

        IF is_clipped( l_start, l_end, l_length ) = 0 THEN
--          --   nm_debug.debug('Clipped between '||to_char( l_start )||' and '||to_char(l_end)||' length = '||to_char(l_length));

            l_geom := sdo_lrs.clip_geom_segment( l_geom, g_usgm.diminfo, l_start, l_end );

        ELSE
--           --   nm_debug.debug('Not clipped '||to_char( l_start )||' and '||to_char(l_end)||' length = '||to_char(l_length));
           NULL;

        END IF;

--      if geocur%rowcount = 1 then

        IF retval.sdo_elem_info IS NULL THEN
          retval := l_geom;
--          --   nm_debug.debug('First one');
        ELSE

--        concatenate the segments into one if they are connected, else multi-part

--        retval := add_segments( retval, l_geom );

          add_segments( retval, l_geom, g_usgm.diminfo );

        END IF;

      ELSE
--      --   nm_debug.debug('NE = '||to_char(l_ne_id)||' Elem info is null - no use');
        NULL;
      END IF;
    ELSE
--    --   nm_debug.debug('Its a DB');
      NULL;
    END IF;

  END LOOP;
  CLOSE geocur;
  RETURN retval;
END;

--
-----------------------------------------------------------------------------------------
--

FUNCTION get_shape_from_ne( p_ne_id IN nm_elements.ne_id%TYPE,
                            p_effective_date IN DATE ) RETURN mdsys.sdo_geometry IS

l_stored_date DATE := Nm3user.get_effective_date;

retval mdsys.sdo_geometry;

BEGIN

  Nm3user.set_effective_date(p_date=> p_effective_date);

  retval := get_shape_from_ne( p_ne_id );

  Nm3user.set_effective_date(p_date=> l_stored_date );

  RETURN retval;

EXCEPTION
  WHEN OTHERS THEN
    Nm3user.set_effective_date(p_date=> l_stored_date );
    RAISE;
END;
--
-----------------------------------------------------------------------------------------
--
FUNCTION get_shape_from_nm( p_ne_id    nm_elements.ne_id%TYPE,
                            p_ne_id_of nm_elements.ne_id%TYPE,
                            p_begin_mp nm_members.nm_begin_mp%TYPE,
                            p_end_mp   nm_members.nm_begin_mp%TYPE ) RETURN mdsys.sdo_geometry IS
l_layer NUMBER;
l_nt    nm_elements_all.ne_nt_type%TYPE;
BEGIN
  l_nt    := Nm3get.get_ne_all( p_ne_id_of ).ne_nt_type;
  l_layer := Get_Datum_Theme( l_nt );
  IF l_layer IS NOT NULL THEN
    RETURN get_shape_from_nm( l_layer, p_ne_id, p_ne_id_of, p_begin_mp, p_end_mp );
  ELSE
    RETURN NULL;
  END IF;
END;
--
-----------------------------------------------------------------------------------------
--

FUNCTION get_shape_from_nm( p_layer IN NM_THEMES_ALL.nth_theme_id%TYPE,
                            p_ne_id IN nm_elements.ne_id%TYPE,
                            p_ne_id_of nm_elements.ne_id%TYPE,
                            p_begin_mp nm_members.nm_begin_mp%TYPE,
                            p_end_mp   nm_members.nm_begin_mp%TYPE ) RETURN mdsys.sdo_geometry IS

TYPE geocurtyp IS REF CURSOR;

geocur geocurtyp;

l_geom         mdsys.sdo_geometry;
l_length       nm_elements.ne_length%TYPE := Nm3net.get_datum_element_length( p_ne_id_of );
l_geom_length  number;
BEGIN

--    --   nm_debug.debug_on;
--    --   nm_debug.delete_debug(true);
--    --   nm_debug.debug( 'Start');

  IF set_theme( p_layer ) THEN
    set_theme_metadata( p_layer );
  END IF;

   l_geom := Get_Layer_Element_Geometry( p_layer, p_ne_id_of );
   l_geom_length := sdo_lrs.geom_segment_end_measure(l_geom);

   if abs(l_geom_length - l_length) > g_usgm.diminfo(3).sdo_tolerance then
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                    ,pi_id                 => 204
                    ,pi_sqlcode            => -20001
                    );
--    Lengths of element and shape are inconsistent
   end if;

   if p_end_mp > l_length + g_usgm.diminfo(3).sdo_tolerance then
      Hig.raise_ner(pi_appl                => Nm3type.c_net
                    ,pi_id                 => 227
                    ,pi_sqlcode            => -20001
                    );
--    Membership measures out of range of parent element
   end if;



--   nm_debug.debug( 'Got the element geometry');

   IF l_geom.sdo_elem_info IS NOT NULL THEN

--     nm_debug.debug('NE = '||to_char(p_ne_id_of)||' Eleme info is not null - proceed');

--   first clip the shape if necessary and rescale it to start at the true distance?

     IF is_clipped( p_begin_mp, p_end_mp, l_length ) = 0 THEN
--       nm_debug.debug('Clipped between '||to_char( p_begin_mp )||' and '||to_char(p_end_mp)||' length = '||to_char(l_length));

       l_geom := sdo_lrs.clip_geom_segment( l_geom, g_usgm.diminfo, least(p_begin_mp, l_geom_length), least(p_end_mp, l_geom_length) );

     ELSE
--       nm_debug.debug('Not clipped '||to_char( p_begin_mp )||' and '||to_char(p_end_mp)||' length = '||to_char(l_length));
       NULL;

     END IF;

   ELSE
--     --   nm_debug.debug('NE = '||to_char(p_ne_id_of)||' Elem info is null - no use');
     NULL;
   END IF;

   RETURN l_geom;
END;



--
-----------------------------------------------------------------------------------------
--
FUNCTION get_shape_from_ft( p_pk_id IN NUMBER,
                            p_nit   IN nm_inv_types.nit_inv_type%TYPE ) RETURN mdsys.sdo_geometry IS

TYPE geocurtyp IS REF CURSOR;

geocur   geocurtyp;
l_nit    nm_inv_types%ROWTYPE := Nm3get.get_nit( p_nit );

cur_string VARCHAR2(2000) := 'select a.ne_id, a.ne_length,'||
                                        'b.'||l_nit.NIT_LR_ST_CHAIN||' ,b.'||l_nit.NIT_LR_END_CHAIN||', a.ne_nt_type'||
                             ' from nm_elements a,'||l_nit.NIT_TABLE_NAME||'  b'||
                             ' where a.ne_id = b.'||l_nit.NIT_LR_NE_COLUMN_NAME||
                             ' and   b.'||l_nit.NIT_FOREIGN_PK_COLUMN||' = to_char(:pk_id)';

l_geom         mdsys.sdo_geometry;
l_length       nm_elements.ne_length%TYPE;
l_start        nm_members.nm_begin_mp%TYPE;
l_end          nm_members.nm_end_mp%TYPE;
l_ne_id        nm_elements.ne_id%TYPE;
l_nt           nm_elements.ne_nt_type%TYPE;
l_layer        NUMBER;

retval mdsys.sdo_geometry;

BEGIN

--  nm_debug.debug_on;
--  nm_debug.delete_debug(true);
--  nm_debug.debug( cur_string );

  OPEN geocur FOR cur_string USING p_pk_id;
  LOOP

    FETCH geocur INTO l_ne_id, l_length, l_start, l_end, l_nt;
    EXIT WHEN geocur%NOTFOUND;

 l_layer := Get_Datum_Theme( l_nt );

    IF set_theme( l_layer ) THEN
      set_theme_metadata( l_layer );
    END IF;

    l_geom := Get_Layer_Element_Geometry( l_layer, l_ne_id );

    IF l_geom.sdo_elem_info IS NOT NULL THEN

--      nm_debug.debug('NE = '||to_char(l_ne_id)||' Elem info is not null - proceed');

--      first clip the shape if necessary and rescale it to start at the true distance?

        IF is_clipped( l_start, l_end, l_length ) = 0 THEN

--        nm_debug.debug('Clipped between '||to_char( l_start )||' and '||to_char(l_end)||' length = '||to_char(l_length));

          l_geom := sdo_lrs.clip_geom_segment( l_geom, g_usgm.diminfo, l_start, l_end );

        ELSE
--         nm_debug.debug('Not clipped '||to_char( l_start )||' and '||to_char(l_end)||' length = '||to_char(l_length));
           NULL;

        END IF;

--      if geocur%rowcount = 1 then

        IF retval.sdo_elem_info IS NULL THEN
          retval := l_geom;
--          nm_debug.debug('First one');
        ELSE

--        concatenate the segments into one if they are connected, else multi-part

          add_segments( retval, l_geom, g_usgm.diminfo );

        END IF;

      ELSE
--         nm_debug.debug('NE = '||to_char(l_ne_id)||' Elem info is null - no use');
        NULL;
      END IF;
  END LOOP;
  CLOSE geocur;
  RETURN retval;
END;

--
------------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_pt_shape_from_ne( p_ne_id_of IN nm_elements.ne_id%TYPE,
                               p_measure  IN nm_members.nm_begin_mp%TYPE ) RETURN mdsys.sdo_geometry IS
l_layer NUMBER;
BEGIN
  l_layer := Get_Datum_Theme( Nm3get.get_ne(p_ne_id_of).ne_nt_type );
  RETURN get_pt_shape_from_ne( l_layer, p_ne_id_of, p_measure );
END;
--
------------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_pt_shape_from_ne( p_layer IN NM_THEMES_ALL.nth_theme_id%TYPE,
                               p_ne_id_of IN nm_elements.ne_id%TYPE,
                               p_measure  IN nm_members.nm_begin_mp%TYPE ) RETURN mdsys.sdo_geometry IS

l_geom      mdsys.sdo_geometry;

retval mdsys.sdo_geometry;

BEGIN

  IF set_theme( p_layer ) THEN
    set_theme_metadata( p_layer );
  END IF;

  l_geom := Get_Layer_Element_Geometry( p_layer, p_ne_id_of);

  IF l_geom IS NOT NULL THEN
    retval := sdo_lrs.locate_pt( l_geom, g_usgm.diminfo, p_measure );

    retval := get_2d_pt( retval );
  ELSE
    retval := NULL;
  END IF;

  RETURN retval;

END;

--
------------------------------------------------------------------------------------------------------------------------
--


PROCEDURE create_inv_data ( p_table_name  IN VARCHAR2,
                            p_inv_type    IN nm_inv_types.nit_inv_type%TYPE,
                            p_seq_name    IN VARCHAR2,
       p_pnt_or_cont IN VARCHAR2,
       p_job_id      IN NUMBER DEFAULT NULL ) IS

cur_string1 VARCHAR2(2000);
cur_string2 VARCHAR2(2000);
ins_string  VARCHAR2(2000);


l_time1      NUMBER;
l_time2      NUMBER;
l_time3      NUMBER;

l_ne          nm_elements.ne_id%TYPE;
l_ne_id_of    nm_elements.ne_id%TYPE;
l_begin_mp    nm_members.nm_begin_mp%TYPE;
l_end_mp      nm_members.nm_begin_mp%TYPE;
l_start_date  nm_members.nm_start_date%TYPE;
l_geom        mdsys.sdo_geometry;
l_objectid    NUMBER;

l_effective_date DATE := Nm3user.GET_EFFECTIVE_DATE;

l_nit   nm_inv_types%ROWTYPE := Nm3get.get_nit( p_inv_type );

l_usgm  user_sdo_geom_metadata%ROWTYPE;

l_ge   nm_geom_array    := Nm3array.init_nm_geom_array;
l_gi   nm_geom_array    := Nm3array.init_nm_geom_array;
l_pt   ptr_array;
v_pl   nm_placement_array;

v_sq   int_array := Nm3array.init_int_array;
v_it   ptr_array := Nm3array.init_ptr_array;
v_ne   ptr_array := Nm3array.init_ptr_array;
--v_idx  ptr_array := ptr_array( ptr_array_type(ptr(null,null)));
v_st   num_array := Nm3array.init_num_array;
v_nd   num_array := Nm3array.init_num_array;
v_nlt  int_array := Nm3array.init_int_array;

l_date_tab     Nm3type.tab_date;
l_end_date_tab Nm3type.tab_date;

ref_cur    Nm3type.ref_cursor;
ref_cur2   Nm3type.ref_cursor;

l_limit INTEGER := NVL( Hig.get_sysopt('SDOFETBUFF'),200);
ic      INTEGER;

l_th     ptr_array;
l_len    ptr_num_array;
l_th_id  ptr_array;
l_it_id  int_array;

l_p      INTEGER := NULL;
l_t      INTEGER := NULL;
l_l_p    INTEGER := NULL;
l_g_p    INTEGER := NULL;
l_g_len  NUMBER;

l_temp   INTEGER;

PROCEDURE set_theme_and_length( p_id IN ptr_array, po_theme OUT ptr_array, po_length OUT ptr_num_array ) IS
curstr varchar2(2000) :=
   ' ptr( i.ptr_id, nth_theme_id), ptr_num( i.ptr_id, ne_length) '||
   ' FROM nm_elements_all, NM_LINEAR_TYPES, NM_NW_THEMES, NM_THEMES_ALL, TABLE( :pa ) i '||
   ' WHERE ne_id = i.ptr_value '||
   ' AND   ne_nt_type = nlt_nt_type '||
   ' AND   nlt_g_i_d = '||''''||'D'||''''||
   ' AND   nlt_id = nnth_nlt_id '||
   ' AND   nth_theme_id = nnth_nth_theme_id '||
   ' AND   nth_base_table_theme is null ';
BEGIN

  po_theme  := Nm3array.init_ptr_array;
  po_length := Nm3array.init_ptr_num_array;

  curstr := 'select /*+cardinality ( i '||to_char( p_id.pa.last)||') */ '||curstr;

  execute immediate curstr bulk collect into po_theme.pa, po_length.pa using p_id.pa;

--nm_debug.debug_on;
--nm_debug.debug(curstr);


/*  OPEN c1( p_id );
    FETCH c1 BULK COLLECT INTO po_theme.pa, po_length.pa;
    CLOSE c1;
*/

 END;


FUNCTION set_idx ( p_val1 IN ptr_array, p_val2 IN ptr_array ) RETURN ptr_array IS
retval ptr_array := Nm3array.init_ptr_array;
CURSOR c1 ( c_val1 IN ptr_array, c_val2 IN ptr_array ) IS
  SELECT ptr( cv1.ptr_id, cv2.ptr_value )
  FROM TABLE ( c_val1.pa ) cv1,
       TABLE ( c_val2.pa ) cv2
  WHERE cv1.ptr_value = cv2.ptr_value;
BEGIN
  OPEN c1( p_val1, p_val2);
  FETCH c1 BULK COLLECT INTO retval.pa;
  CLOSE c1;
  RETURN retval;
END;

BEGIN

--  Nm_Debug.debug_on;

  IF l_nit.nit_table_name IS NULL THEN

     cur_string1 :=  ' select ptr( rownum, m.nm_ne_id_in), ptr( rownum, m.nm_ne_id_of), nm_placement( m.nm_ne_id_of, m.nm_begin_mp, m.nm_end_mp, 0), m.nm_start_date, nm_end_date '||
                        '  from nm_members_all m where nm_type = '||''''||'I'||''''||' and nm_obj_type = '||''''||l_nit.nit_inv_type||'''';
  ELSE

     cur_string1 :=  ' select ptr( rownum, a.'||l_nit.nit_foreign_pk_column||' ), ptr( rownum, a.'|| l_nit.nit_lr_ne_column_name||
                      '), nm_placement( '||l_nit.nit_lr_ne_column_name||
      ', '||l_nit.nit_lr_st_chain||
      ', '||NVL(l_nit.nit_lr_end_chain,l_nit.nit_lr_st_chain)||', 0), trunc(sysdate), null '||
                        '  from '||l_nit.nit_table_name||' a ';
  END IF;

  ins_string := 'insert into '||p_table_name||
                ' ( objectid, ne_id, ne_id_of, nm_begin_mp, nm_end_mp, start_date, end_date, geoloc ) '||
                '  values ( :l_objectid, :lne, :l_ne_id_of, :l_begin_mp, :l_end_mp, :start_date, :end_date, :lgeom )';

  cur_string2 := ' select '||p_seq_name||'.nextval from nm_members';

-- Nm_Debug.DEBUG(cur_string1);
  OPEN ref_cur FOR cur_string1;

  FETCH ref_cur BULK COLLECT INTO  v_it.pa, v_ne.pa, v_pl.npa_placement_array, l_date_tab, l_end_date_tab LIMIT l_limit;

--nm_debug.debug( 'Fetched batch'||' count = '||to_char( v_ne.pa.last ));

  WHILE v_it.pa.LAST IS NOT NULL AND v_it.pa.LAST > 0 LOOP

    l_temp := v_it.pa.LAST;

-- nm_debug.debug('count = '||to_char(l_temp));

/*
    for j in 1..v_it.pa.last loop

   nm_debug.debug(to_char(v_it.pa(j).ptr_value)||','||to_char(v_ne.pa(j).ptr_value));

 end loop;
*/
--  nm_debug.debug('Retrieve distinct ne');

-- l_pt := v_ne.get_distinct_ptr;

 l_pt := get_distinct_ptr(v_ne);


    OPEN ref_cur2 FOR cur_string2;

 FETCH ref_cur2 BULK COLLECT INTO v_sq.ia LIMIT v_it.pa.LAST;

 CLOSE ref_cur2;

--  nm_debug.debug('Distinct ne_id');

/*
    for j in 1..l_pt.pa.last loop

      nm_debug.debug( to_char( l_pt.pa(j).ptr_id )||','||to_char( l_pt.pa(j).ptr_value ));

    end loop;
*/

--  nm_debug.debug('Done - now get themes and lengths');

 set_theme_and_length( l_pt, l_th, l_len );

--  nm_debug.debug('Done - now get distinct themes');

/*

    insert into rob_dbug(p1,p2,p3,p4)
 values ( v_it, v_ne, l_pt, l_len );

*/

--  l_th_id := l_th.get_distinct_ptr;
    l_th_id := get_distinct_ptr(l_th);

--  nm_debug.debug('Done - now loop over each base theme - in this batch there are '||to_char( l_th_id.pa.last ));

    IF NOT l_th_id.Is_Empty  THEN

      FOR i IN 1..l_th_id.pa.LAST LOOP

--     nm_debug.debug('Distinct theme '||to_char( l_th_id.pa(i).ptr_id)||' = '||to_char( l_th_id.pa(i).ptr_value) );

--      nm_debug.debug('Get the shapes of the distinct ne records');

     l_ge := Get_Ne_Shapes ( l_pt, l_th_id.pa(i).ptr_value );

        IF l_ge.nga.LAST > 0 THEN

--        nm_debug.debug('WE have the geometries - if none here then do nothing - count = '||to_char(l_ge.nga.last)||' value = '||to_char( l_ge.nga(l_ge.nga.last).ng_ne_id ) );


       l_usgm := Nm3sdo.get_theme_metadata( l_th_id.pa(i).ptr_value );

--        we now have an array of geometries representing the shapes of the elements from the given theme
--        for each of the inventory in the main driving arrays, dyn-seg each if the element has got a shape.

--        nm_debug.debug('Done - now get the dynsegged shapes for theme '||to_char(l_th_id.pa(i).ptr_value)||' - j is going from 1 to '||to_char( l_temp));

         FOR j IN 1..l_temp LOOP

            BEGIN

--            nm_debug.debug('Lookup '||to_char(v_ne.pa(j).ptr_value));

--           l_p := l_pt.get_id( v_ne.pa(j).ptr_value );
           l_p := get_id( l_pt, v_ne.pa(j).ptr_value );

              l_t := get_idx_from_id(l_th,l_p);

              IF l_t IS NULL OR l_t < 0 THEN

                NULL; -- there is no theme shape - ignore this

              ELSE

--              ensure that the element in question is the correct theme

--              nm_debug.debug(to_char(l_th.pa(get_idx_from_id(l_th,l_p)).ptr_value)||' compared to '||to_char(l_th_id.pa(i).ptr_value));

          IF l_th.pa(get_idx_from_id(l_th,l_p)).ptr_value = l_th_id.pa(i).ptr_value THEN

--            if l_th.pa(l_p).ptr_value = l_th_id.pa(i).ptr_value then

--             l_l_p := l_len.get_idx_from_id( l_p );
             l_l_p := get_idx_from_id(l_len, l_p );

                  IF l_ge.nga.LAST IS NOT NULL THEN

--              l_g_p := l_ge.get_idx ( l_p );
              l_g_p := get_idx ( l_ge, l_p );

                  ELSE

              l_g_p := 0;

            END IF;

              IF l_g_p > 0 THEN

--               nm_debug.debug('ptr for '||to_char(j)||' = '||to_char(l_p)||', '||to_char(l_l_p)||', '||to_char(l_g_p));

--                 nm_debug.debug( 'I = '||to_char( v_it.pa(j).ptr_value)||' E = '||to_char( v_ne.pa(j).ptr_value)||
--                              ' idx = '||to_char(l_p)||' idxlup = '||to_char(l_pt.pa(l_p).ptr_value));

--                  nm_debug.debug( 'Geometry type = '||to_char( l_ge.nga(l_g_p).ng_geometry.sdo_gtype ));

                    l_g_len := sdo_lrs.geom_segment_end_measure( l_ge.nga(l_g_p).ng_geometry );

                    IF l_g_len != l_len.pa(l_l_p).ptr_value THEN

                IF p_job_id IS NULL THEN

                        Nm_Debug.DEBUG( 'mismatch length I = '||TO_CHAR( v_it.pa(j).ptr_value )||' e = '||TO_CHAR(v_ne.pa(j).ptr_value)||
                                     ' shape len = '||TO_CHAR(l_g_len)||' and elen = '||TO_CHAR(l_len.pa(l_l_p).ptr_value));

                      ELSE

                  add_dyn_seg_exception( 297, p_job_id, v_it.pa(j).ptr_value, v_ne.pa(j).ptr_value, l_g_len, l_len.pa(l_l_p).ptr_value );

                      END IF;

                    ELSIF v_pl.npa_placement_array(j).pl_start < 0 OR
                          v_pl.npa_placement_array(j).pl_end > l_len.pa(l_l_p).ptr_value THEN

                IF p_job_id IS NULL THEN

                   Nm_Debug.DEBUG('from '||TO_CHAR(v_pl.npa_placement_array(j).pl_start)||' to '||
                                  TO_CHAR(v_pl.npa_placement_array(j).pl_end)||' l = '||TO_CHAR(l_g_len));
                      ELSE

                  add_dyn_seg_exception( 298, p_job_id, v_it.pa(j).ptr_value, v_ne.pa(j).ptr_value, l_g_len, l_len.pa(l_l_p).ptr_value,
                                    v_pl.npa_placement_array(j).pl_start, v_pl.npa_placement_array(j).pl_end );

                  END IF;

                    ELSIF p_pnt_or_cont = 'C' and v_pl.npa_placement_array(j).pl_start >= v_pl.npa_placement_array(j).pl_end THEN

                IF p_job_id IS NULL THEN

                   Nm_Debug.DEBUG('from '||TO_CHAR(v_pl.npa_placement_array(j).pl_start)||' to '||
                                  TO_CHAR(v_pl.npa_placement_array(j).pl_end)||' l = '||TO_CHAR(l_g_len));
                      ELSE

                  add_dyn_seg_exception( 299, p_job_id, v_it.pa(j).ptr_value, v_ne.pa(j).ptr_value, l_g_len, l_len.pa(l_l_p).ptr_value,
                                    v_pl.npa_placement_array(j).pl_start, v_pl.npa_placement_array(j).pl_end, 'Point in Linear Feature Set');

                  END IF;

                    ELSE --lengths should be OK - go and get the shape

--                l_geom := l_ge.nga(l_g_p).ng_geometry;

                      l_time1 := DBMS_UTILITY.GET_TIME;

                      BEGIN

                     IF p_pnt_or_cont = 'C' THEN

                          l_geom :=  sdo_lrs.Clip_Geom_segment( l_ge.nga(l_g_p).ng_geometry,
                                                        l_usgm.diminfo,
                                                        v_pl.npa_placement_array(j).pl_start,
                                                        v_pl.npa_placement_array(j).pl_end );

                        ELSE

                          l_geom :=  sdo_lrs.locate_pt( l_ge.nga(l_g_p).ng_geometry,
                                        l_usgm.diminfo,
                                  v_pl.npa_placement_array(j).pl_start );

                        END IF;

                      EXCEPTION
                  WHEN OTHERS THEN
                          IF p_job_id IS NULL THEN
                            Hig.raise_ner(pi_appl                => Nm3type.c_hig
                                         ,pi_id                 => 282
                                         ,pi_sqlcode            => -20001
                     ,pi_supplementary_info => TO_CHAR(  v_ne.pa(j).ptr_value )||' from '||
                                                    TO_CHAR(v_pl.npa_placement_array(j).pl_start)||' to '||
                                                 TO_CHAR(v_pl.npa_placement_array(j).pl_end)
                                         );
                          ELSE

                            add_dyn_seg_exception(282, p_job_id, v_it.pa(j).ptr_value,  v_ne.pa(j).ptr_value, NULL, NULL,
                                                     v_pl.npa_placement_array(j).pl_start,
                                                     v_pl.npa_placement_array(j).pl_end, SQLERRM );
                          END IF;

--                 RAISE_APPLICATION_ERROR(-20001, 'Problem with '||to_char(  v_ne.pa(j).ptr_value )||' from '||
--                     to_char(v_pl.npa_placement_array(j).pl_start)||' to '||
--                  to_char(v_pl.npa_placement_array(j).pl_end));
                END;

                      l_time2 := DBMS_UTILITY.GET_TIME - l_time1;

                      l_time1 := DBMS_UTILITY.GET_TIME;

                      IF p_pnt_or_cont = 'C' THEN
                        l_geom.sdo_gtype := 3302;
                ELSE
                  l_geom := get_2d_pt( l_geom );
                END IF;

                      EXECUTE IMMEDIATE ins_string USING v_sq.ia(j),
                                                 v_it.pa(j).ptr_value,
                             v_ne.pa(j).ptr_value,
                       v_pl.npa_placement_array(j).pl_start,
                                                    v_pl.npa_placement_array(j).pl_end,
                      l_date_tab(j),
                      l_end_date_tab(j),
                      l_geom;

                      l_time3 := DBMS_UTILITY.GET_TIME - l_time1;

/*

                    insert into rob_test
                values ( v_pl.npa_placement_array(j).pl_ne_id, l_time2, v_pl.npa_placement_array(j).pl_start,
               v_pl.npa_placement_array(j).pl_end, l_time3 );

*/
                      COMMIT;
                    END IF;
                  END IF;
                END IF;
--              nm_debug.debug('Done - loop over next id');

              END IF;

            EXCEPTION
              WHEN OTHERS THEN NULL; -- there is no theme to represent the network - so no chance of clipping.
            END;

          END LOOP; -- use another item

        END IF;


--      nm_debug.debug('Done - do it over the next theme ');

      END LOOP; -- next theme

    END IF;

    FETCH ref_cur BULK COLLECT INTO v_it.pa, v_ne.pa, v_pl.npa_placement_array, l_date_tab, l_end_date_tab LIMIT l_limit;

--  nm_debug.debug('Next batch - go back to top of loop');

  END LOOP; --over all fetched buffers

--nm_debug.debug( 'Fetched '||to_char(ic)||' batch'||' count = '||to_char( v_ne.ia.last ));

  CLOSE ref_cur;

END;

--
------------------------------------------------------------------------------------------------------------------------
--

PROCEDURE create_nt_data( p_nth    IN NM_THEMES_ALL%ROWTYPE,
                          p_nlt_id IN NM_LINEAR_TYPES.nlt_id%TYPE,
                          p_ta     IN nm_theme_array,
                          p_job_id IN NUMBER DEFAULT NULL) IS

l_mp_gtype      NUMBER := TO_NUMBER(NVL(Hig.get_sysopt('SDOMPGTYPE'),'3302'));

cur_str1        VARCHAR2(2000);
cur_str2        VARCHAR2(2000);

l_ga            nm_geom_array := Nm3array.init_nm_geom_array;
l_seq           int_array := Nm3array.init_int_array;
l_limit         INTEGER := NVL( Hig.get_sysopt('SDOFETBUFF'),500);

l_nlt           NM_LINEAR_TYPES%ROWTYPE;

l_geom          mdsys.sdo_geometry;

l_effective_date DATE := Nm3user.get_effective_date;

l_ptr ptr_array;

l_nt            ptr_vc_array;
l_th            ptr_array;
l_nth_row_tab   nth_row_tab_type;

l_diminfo       mdsys.sdo_dim_array;
l_srid          NUMBER;

l_time1        NUMBER;
l_time2        NUMBER;
l_time3        NUMBER;

l_part   VARCHAR2(1);

l_id integer := 0;
l_ne_saved number := -999;
l_date_saved date := TO_DATE('05111605','DDMMYYYY');


l_date nm3type.tab_date;

/*
CURSOR  get_routes ( c_nt IN NM_LINEAR_TYPES.nlt_nt_type%TYPE, c_gty IN NM_LINEAR_TYPES.NLT_GTY_TYPE%TYPE ) IS
  SELECT nm_geom(ne_id, NULL)
  FROM nm_elements
  WHERE ne_nt_type = c_nt
  AND   ne_gty_group_type = c_gty
  AND EXISTS ( SELECT 1 FROM nm_members
               WHERE nm_ne_id_in = ne_id );
*/

cursor get_routes (c_nt in nm_linear_types.nlt_nt_type%type,
                   c_gty in nm_linear_types.nlt_gty_type%type ) is
with route_data as
( select nm_ne_id_in ne_id, nm_start_date start_date, nm_end_date end_date
from nm_members_all, nm_elements_all
where nm_obj_type = c_gty
and nm_ne_id_in = ne_id
--and ne_id = 114223
and ne_nt_type = c_nt
and ne_gty_group_type = c_gty
group by nm_ne_id_in, nm_start_date, nm_end_date
)
select ne_id, start_date member_date
from route_data
union
select ne_id, end_date member_date
from route_data
order by 1, 2;

l_seq_str varchar2(2000);

BEGIN


--  Nm_Debug.debug_on;
  Nm_Debug.DEBUG('background stuff retrieval');

    l_nt   := get_base_nt( p_nlt_id => p_nlt_id );

    l_th := get_base_themes( l_nt );

    l_nlt     := Nm3get.get_nlt( p_nlt_id );

    l_part := Nm3net.is_gty_partial( l_nlt.nlt_gty_type );

    FOR i IN 1..l_th.pa.LAST LOOP
      l_nth_row_tab(i) := Nm3get.get_nth( l_th.pa(i).ptr_value );
    END LOOP;

    Nm3sdo.set_diminfo_and_srid( p_themes  => make_tha_from_ptr( l_th ),
                                 p_diminfo => l_diminfo,
                                 p_srid    => l_srid );

    l_seq_str := 'select '||p_nth.nth_sequence_name||'.nextval from dual';

    cur_str2 := 'insert into '||p_nth.nth_feature_table||
                '(objectid, ne_id, geoloc, start_date, end_date) '||
                ' values ( :l_objectid, :lne, :lgeom, :start_date, :end_date )';

    nm_debug.DEBUG('all background stuff is retrieved');


    for irec in get_routes ( l_nlt.nlt_nt_type, l_nlt.nlt_gty_type )loop

    execute immediate l_seq_str into l_id;

    if irec.ne_id = l_ne_saved then
      begin
        nm3user.set_effective_date( nvl(l_date_saved, trunc(sysdate)) );

--      nm_debug.debug('Loop it = '||get_routes%rowcount||' retrieve shape, date is '||to_char(nm3user.get_effective_date));

        l_geom  :=    get_route_shape( p_ne_id   => irec.ne_id, -- l_ga.nga(i).ng_ne_id,
                                       p_nt      => l_nt,
                                       p_th      => l_th,
                                       p_nth_tab => l_nth_row_tab,
                                       p_diminfo => l_diminfo,
                                       p_srid    => l_srid,
                                       p_part    => l_part );

--      l_geom := nm3sdo.get_route_shape(irec.ne_id);

        begin
          EXECUTE IMMEDIATE cur_str2 USING l_id, irec.ne_id, l_geom, l_date_saved, irec.member_date;

          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            IF p_job_id IS NULL THEN
             Nm_Debug.DEBUG('Failed on NE_ID = '||TO_CHAR( irec.ne_id )||' - Error = '||SQLERRM );
            ELSE
             add_dyn_seg_exception( 282, p_job_id, irec.ne_id, NULL, NULL, NULL, NULL, NULL, SQLERRM );
            END IF;
        END;

        l_ne_saved := irec.ne_id;
        l_date_saved := irec.member_date;

      end;
    else
      l_ne_saved := irec.ne_id;
      l_date_saved := irec.member_date;
      -- this is the first row at a known start date
    end if;
  end loop;
end;

--
------------------------------------------------------------------------------------------------------------------------
--

PROCEDURE create_non_linear_data ( p_table_name  IN VARCHAR2,
           p_gty_type    IN VARCHAR2,
                                   p_seq_name    IN VARCHAR2,
           p_job_id      IN NUMBER DEFAULT NULL
            ) IS

cur_string1 VARCHAR2(2000);
cur_string2 VARCHAR2(2000);
ins_string  VARCHAR2(2000);


l_time1      NUMBER;
l_time2      NUMBER;
l_time3      NUMBER;

l_ne          nm_elements.ne_id%TYPE;
l_ne_id_of    nm_elements.ne_id%TYPE;
l_begin_mp    nm_members.nm_begin_mp%TYPE;
l_end_mp      nm_members.nm_begin_mp%TYPE;
l_start_date  nm_members.nm_start_date%TYPE;
l_geom        mdsys.sdo_geometry;
l_objectid    NUMBER;

l_effective_date DATE := Nm3user.GET_EFFECTIVE_DATE;

l_usgm  user_sdo_geom_metadata%ROWTYPE;

l_ge   nm_geom_array    := Nm3array.init_nm_geom_array;
l_gi   nm_geom_array    := Nm3array.init_nm_geom_array;
l_pt   ptr_array;
v_pl   nm_placement_array;

v_sq   int_array := Nm3array.init_int_array;
v_it   ptr_array := Nm3array.init_ptr_array;
v_ne   ptr_array := Nm3array.init_ptr_array;
v_st   num_array := Nm3array.init_num_array;
v_nd   num_array := Nm3array.init_num_array;
v_nlt  int_array := Nm3array.init_int_array;

l_date_tab       Nm3type.tab_date;
l_end_date_tab   Nm3type.tab_date;

ref_cur    Nm3type.ref_cursor;
ref_cur2   Nm3type.ref_cursor;

l_limit INTEGER := NVL( Hig.get_sysopt('SDOFETBUFF'),500);
ic      INTEGER;

l_th     ptr_array;
l_len    ptr_num_array;
l_th_id  ptr_array;
l_it_id  int_array;

l_p      INTEGER := NULL;
l_l_p    INTEGER := NULL;
l_g_p    INTEGER := NULL;
l_g_len  NUMBER;
l_t      INTEGER;

PROCEDURE set_theme_and_length( p_id IN ptr_array, po_theme OUT ptr_array, po_length OUT ptr_num_array ) IS
curstr varchar2(2000) :=
   ' ptr( i.ptr_id, nth_theme_id), ptr_num( i.ptr_id, ne_length) '||
   ' FROM nm_elements_all, NM_LINEAR_TYPES, NM_NW_THEMES, NM_THEMES_ALL, TABLE( :pa ) i '||
   ' WHERE ne_id = i.ptr_value '||
   ' AND   ne_nt_type = nlt_nt_type '||
   ' AND   nlt_g_i_d = '||''''||'D'||''''||
   ' AND   nlt_id = nnth_nlt_id '||
   ' AND   nth_theme_id = nnth_nth_theme_id '||
   ' AND   nth_base_table_theme is null ';
BEGIN

  po_theme  := Nm3array.init_ptr_array;
  po_length := Nm3array.init_ptr_num_array;

  curstr := 'select /*+cardinality ( i '||to_char( p_id.pa.last)||') */ '||curstr;

  execute immediate curstr bulk collect into po_theme.pa, po_length.pa using p_id.pa;

--nm_debug.debug_on;
--nm_debug.debug(curstr);


/*  OPEN c1( p_id );
    FETCH c1 BULK COLLECT INTO po_theme.pa, po_length.pa;
    CLOSE c1;
*/

 END;


FUNCTION Get_Ne_Shapes( p_id IN ptr_array, p_th_id IN INTEGER ) RETURN nm_geom_array IS
retval nm_geom_array       := Nm3array.init_nm_geom_array;
nth  NM_THEMES_ALL%ROWTYPE := Nm3get.get_nth( p_th_id );
cur_string VARCHAR2(2000);
ref_cur    Nm3type.ref_cursor;
BEGIN

  cur_string := 'select /*+cardinality (a '||to_char( p_id.pa.last)||')*/ '||
                ' nm_geom( a.ptr_id, '||TO_CHAR( nth.nth_feature_shape_column )||') from '||nth.nth_feature_table||
                ', table ( :pa ) a '||
    'where a.ptr_value = '||nth.nth_feature_pk_column ;

--nm_debug.debug( cur_string );

  OPEN ref_cur FOR cur_string USING p_id.pa;
  FETCH ref_cur BULK COLLECT INTO retval.nga;
  CLOSE ref_cur;

  RETURN retval;

END;

FUNCTION set_idx ( p_val1 IN ptr_array, p_val2 IN ptr_array ) RETURN ptr_array IS
retval ptr_array := Nm3array.init_ptr_array;
CURSOR c1 ( c_val1 IN ptr_array, c_val2 IN ptr_array ) IS
  SELECT ptr( cv1.ptr_id, cv2.ptr_value )
  FROM TABLE ( c_val1.pa ) cv1,
       TABLE ( c_val2.pa ) cv2
  WHERE cv1.ptr_value = cv2.ptr_value;
BEGIN
  OPEN c1( p_val1, p_val2);
  FETCH c1 BULK COLLECT INTO retval.pa;
  CLOSE c1;
  RETURN retval;
END;


BEGIN

--  Nm_Debug.debug_on;

  cur_string1 :=  ' select ptr( rownum, m.nm_ne_id_in), ptr( rownum, m.nm_ne_id_of), nm_placement( m.nm_ne_id_of, m.nm_begin_mp, m.nm_end_mp, 0), m.nm_start_date, m.nm_end_date '||
                        '  from nm_members_all m where nm_type = :gty and nm_obj_type = :p_type';

  ins_string := 'insert into '||p_table_name||
                ' ( objectid, ne_id, ne_id_of, nm_begin_mp, nm_end_mp, start_date, end_date, geoloc ) '||
                '  values ( :l_objectid, :lne, :l_ne_id_of, :l_begin_mp, :l_end_mp, :start_date, :end_date, :lgeom )';

  cur_string2 := ' select '||p_seq_name||'.nextval from nm_members';

  OPEN ref_cur FOR cur_string1 USING 'G', p_gty_type;

  FETCH ref_cur BULK COLLECT INTO  v_it.pa, v_ne.pa, v_pl.npa_placement_array, l_date_tab, l_end_date_tab LIMIT l_limit;

--nm_debug.debug( 'Fetched batch'||' count = '||to_char( v_ne.pa.last ));

  WHILE v_it.pa.LAST IS NOT NULL AND v_it.pa.LAST > 0 LOOP

--  nm_debug.debug('Retrieve distinct ne');

 l_pt := v_ne.get_distinct_ptr;

    OPEN ref_cur2 FOR cur_string2;

 FETCH ref_cur2 BULK COLLECT INTO v_sq.ia LIMIT v_it.pa.LAST;

 CLOSE ref_cur2;

/*
    for j in 1..l_pt.pa.last loop

      nm_debug.debug( to_char( l_pt.pa(j).ptr_id )||','||to_char( l_pt.pa(j).ptr_value ));

    end loop;
*/

--nm_debug.debug('Done - now get themes and lengths');

 set_theme_and_length( l_pt, l_th, l_len );

--nm_debug.debug('Done - now get distinct themes');

/*

    insert into rob_dbug(p1,p2,p3,p4)
 values ( v_it, v_ne, l_pt, l_len );

*/

    l_th_id := l_th.get_distinct_ptr;

--nm_debug.debug('Done - now loop over each base theme');

    IF NOT l_th_id.Is_Empty  THEN


      FOR i IN 1..l_th_id.pa.LAST LOOP

--      nm_debug.debug('Distinct theme '||to_char( l_th_id.pa(i).ptr_id)||' = '||to_char( l_th_id.pa(i).ptr_value) );

--      nm_debug.debug('Get the shapes of the distinct ne records');

     l_ge := Get_Ne_Shapes ( l_pt, l_th_id.pa(i).ptr_value );

--      nm_debug.debug('Done - now get the diminfo');

     l_usgm := Nm3sdo.get_theme_metadata( l_th_id.pa(i).ptr_value );

--      we now have an array of geometries representing the shapes of the elements from the given theme
--      for each of the inventory in the main driving arrays, dyn-seg each if the element has got a shape.

--      nm_debug.debug('Done - now get the dynsegged shapes - last = '||to_char(v_it.pa.last));

        FOR j IN 1..v_it.pa.LAST LOOP

          BEGIN


--          nm_debug.debug(to_char(j)||' Lookup j='||to_char(j)||', ne= '||to_char(v_ne.pa(j).ptr_value));

         l_p := l_pt.get_id( v_ne.pa(j).ptr_value );

            l_t := get_idx_from_id(l_th,l_p);

            IF l_t IS NULL OR l_t < 0 THEN

              NULL; -- there is no theme shape - ignore this

            ELSE


            IF l_th.pa(get_idx_from_id(l_th,l_p)).ptr_value = l_th_id.pa(i).ptr_value THEN

--        if l_th.pa(l_p).ptr_value = l_th_id.pa(i).ptr_value then

--           l_l_p := l_len.get_idx_from_id( l_p );
           l_l_p := get_idx_from_id(l_len, l_p );

                IF l_ge.nga.LAST IS NOT NULL THEN

--            l_g_p := l_ge.get_idx ( l_p );
            l_g_p := get_idx ( l_ge, l_p );

                ELSE

            l_g_p := 0;

          END IF;

            IF l_g_p > 0 THEN

--           nm_debug.debug('ptr for '||to_char(j)||' = '||to_char(l_p)||', '||to_char(l_l_p)||', '||to_char(l_g_p));

--               nm_debug.debug( 'I = '||to_char( v_it.pa(j).ptr_value)||' E = '||to_char( v_ne.pa(j).ptr_value)||
--                            ' idx = '||to_char(l_p)||' idxlup = '||to_char(l_pt.pa(l_p).ptr_value));

--                nm_debug.debug( 'Geometry type = '||to_char( l_ge.nga(l_g_p).ng_geometry.sdo_gtype ));

                  l_g_len := sdo_lrs.geom_segment_end_measure( l_ge.nga(l_g_p).ng_geometry );

/*
               if v_ne.pa(j).ptr_value = 22994417 then

                    nm_debug.debug( 'J = '||to_char(j));
           nm_debug.debug( 'last pl '||to_char( v_pl.npa_placement_array.last ));
           nm_debug.debug( 'ne = '||to_char( v_pl.npa_placement_array(j).pl_ne_id ));

           nm_debug.debug( 'llp = '||to_char(l_l_p));

           nm_debug.debug( 'len ='||to_char(l_g_len)||' elen = '||to_char(l_len.pa(l_l_p).ptr_value));

                    nm_debug.debug('start = '||to_char(v_pl.npa_placement_array(j).pl_start));

           nm_debug.debug(' end  = '||to_char(v_pl.npa_placement_array(j).pl_end ));

           nm_debug.debug(' len  = '||to_char(l_len.pa(l_l_p).ptr_value));

                  end if;
*/

                  IF l_g_len != l_len.pa(l_l_p).ptr_value THEN

              IF p_job_id IS NULL THEN

                      Nm_Debug.DEBUG( 'mismatch length I = '||TO_CHAR( v_it.pa(j).ptr_value )||' e = '||TO_CHAR(v_ne.pa(j).ptr_value)||
                                   ' shape len = '||TO_CHAR(l_g_len)||' and elen = '||TO_CHAR(l_len.pa(l_l_p).ptr_value));

                    ELSE

                add_dyn_seg_exception( 297, p_job_id, v_it.pa(j).ptr_value, v_ne.pa(j).ptr_value, l_g_len, l_len.pa(l_l_p).ptr_value );

                    END IF;

--                  exit;

                  ELSIF v_pl.npa_placement_array(j).pl_start < 0 OR
                        v_pl.npa_placement_array(j).pl_end > l_len.pa(l_l_p).ptr_value THEN

              IF p_job_id IS NULL THEN

                 Nm_Debug.DEBUG('from '||TO_CHAR(v_pl.npa_placement_array(j).pl_start)||' to '||
                                        TO_CHAR(v_pl.npa_placement_array(j).pl_end)||' l = '||TO_CHAR(l_g_len));
                    ELSE

                add_dyn_seg_exception( 298, p_job_id, v_it.pa(j).ptr_value, v_ne.pa(j).ptr_value, l_g_len, l_len.pa(l_l_p).ptr_value,
                                   v_pl.npa_placement_array(j).pl_start, v_pl.npa_placement_array(j).pl_end );

              END IF;

                ELSIF v_pl.npa_placement_array(j).pl_start >= v_pl.npa_placement_array(j).pl_end THEN

                  IF p_job_id IS NULL THEN

                   Nm_Debug.DEBUG('from '||TO_CHAR(v_pl.npa_placement_array(j).pl_start)||' to '||
                                  TO_CHAR(v_pl.npa_placement_array(j).pl_end)||' l = '||TO_CHAR(l_g_len));
                      ELSE

                   add_dyn_seg_exception( 299, p_job_id, v_it.pa(j).ptr_value, v_ne.pa(j).ptr_value, l_g_len, l_len.pa(l_l_p).ptr_value,
                                    v_pl.npa_placement_array(j).pl_start, v_pl.npa_placement_array(j).pl_end, 'Point in Linear Feature Set');

                  END IF;

                ELSE

--              l_geom := l_ge.nga(l_g_p).ng_geometry;

                    l_time1 := DBMS_UTILITY.GET_TIME;

                    BEGIN

                      l_geom :=  sdo_lrs.Clip_Geom_segment( l_ge.nga(l_g_p).ng_geometry,
                                                    l_usgm.diminfo,
                                                    v_pl.npa_placement_array(j).pl_start,
                                                    v_pl.npa_placement_array(j).pl_end );

                    EXCEPTION

                WHEN OTHERS THEN
                        IF p_job_id IS NULL THEN
                          Hig.raise_ner(pi_appl                => Nm3type.c_hig
                                       ,pi_id                 => 282
                                       ,pi_sqlcode            => -20001
                   ,pi_supplementary_info => TO_CHAR(  v_ne.pa(j).ptr_value )||' from '||
                                                    TO_CHAR(v_pl.npa_placement_array(j).pl_start)||' to '||
                                                 TO_CHAR(v_pl.npa_placement_array(j).pl_end)
                                       );
                        ELSE

                          add_dyn_seg_exception(282, p_job_id, v_it.pa(j).ptr_value,  v_ne.pa(j).ptr_value, NULL, NULL,
                                                     v_pl.npa_placement_array(j).pl_start,
                                                     v_pl.npa_placement_array(j).pl_end, SQLERRM );
                        END IF;



--               RAISE_APPLICATION_ERROR(-20001, 'Problem with '||to_char(  v_ne.pa(j).ptr_value )||' from '||
--                    to_char(v_pl.npa_placement_array(j).pl_start)||' to '||
--                 to_char(v_pl.npa_placement_array(j).pl_end));

                    END;

                    l_time2 := DBMS_UTILITY.GET_TIME - l_time1;

                    l_time1 := DBMS_UTILITY.GET_TIME;

/*
                 insert into rob
                 ( objectid, ne_id, ne_id_of, nm_begin_mp, nm_end_mp, start_date, geoloc )
                 values
                 ( 1,  v_it.pa(j).ptr_value, v_ne.pa(j).ptr_value, v_pl.npa_placement_array(j).pl_start,
                   v_pl.npa_placement_array(j).pl_end, l_date_tab(j), l_geom );
*/
                    l_geom := sdo_lrs.convert_to_std_geom (l_geom);

                    EXECUTE IMMEDIATE ins_string USING v_sq.ia(j),
                                         v_it.pa(j).ptr_value,
                v_ne.pa(j).ptr_value,
              v_pl.npa_placement_array(j).pl_start,
                                            v_pl.npa_placement_array(j).pl_end,
              l_date_tab(j),
              l_end_date_tab(j),
              l_geom;

                    l_time3 := DBMS_UTILITY.GET_TIME - l_time1;

--               insert into rob_test
--              values ( v_pl.npa_placement_array(j).pl_ne_id, l_time2, v_pl.npa_placement_array(j).pl_start,
--              v_pl.npa_placement_array(j).pl_end, l_time3 );


                    COMMIT;
                  END IF;
                END IF;
              END IF;
            END IF; -- no ptr to a valid shape

          EXCEPTION
            WHEN OTHERS THEN NULL; -- there is no shape of the clipped element - so nothing to do.
          END;

        END LOOP;  -- over all member records

--      Nm_Debug.DEBUG('Done - get the next theme');

   END LOOP; -- over individual themes
    END IF;

--  Nm_Debug.DEBUG('Next batch - go back to top of loop');

    FETCH ref_cur BULK COLLECT INTO v_it.pa, v_ne.pa, v_pl.npa_placement_array, l_date_tab, l_end_date_tab LIMIT l_limit;

--  Nm_Debug.DEBUG( 'Fetched '||TO_CHAR(ic)||' batch'||' count it = '||TO_CHAR( v_it.pa.LAST )||' count ne = '||TO_CHAR( v_ne.pa.LAST )||
--                  ' count pl = '||TO_CHAR( v_pl.npa_placement_array.LAST ));
    END LOOP; -- over all batches

  CLOSE ref_cur;

END;

--
------------------------------------------------------------------------------------------------------------------------
--


FUNCTION sample_elements_in_route( p_layer    IN  NM_THEMES_ALL.nth_theme_id%TYPE,
                       p_ne_id    IN  nm_elements.ne_id%TYPE,
                       p_interval IN  INTEGER ) RETURN mdsys.sdo_geometry IS

retval mdsys.sdo_geometry;
p_geom mdsys.sdo_geometry;
l_last INTEGER;
l_dim  INTEGER ;
l_ord  mdsys.sdo_ordinate_array := mdsys.sdo_ordinate_array(1);
l_oip  INTEGER := 4;
l_set  BOOLEAN := FALSE;


BEGIN

   p_geom := Nm3sdo.get_route_shape( p_ne_id => p_ne_id );

   l_last := p_geom.sdo_ordinates.LAST;

   IF l_last/3 < p_interval THEN
     retval := p_geom;
   ELSE

     l_ord(1) := p_geom.sdo_ordinates(1);
     l_ord.EXTEND;
     l_ord(2) := p_geom.sdo_ordinates(2);
     l_ord.EXTEND;
     l_ord(3) := p_geom.sdo_ordinates(3);

     FOR ip IN 4..p_geom.sdo_ordinates.LAST LOOP

       IF NOT l_set AND ( MOD( (ip-1)/3, p_interval ) = 0 OR ip = p_geom.sdo_ordinates.LAST - 2) THEN

          l_set := TRUE;

       END IF;

       IF l_set THEN

          l_ord.EXTEND;
          l_ord( l_oip ) := p_geom.sdo_ordinates( ip );
          l_oip := l_oip + 1;

          IF MOD((l_oip-1), 3) = 0 THEN
             l_set := FALSE;
          END IF;

       END IF;


     END LOOP;

     retval := mdsys.sdo_geometry( p_geom.sdo_gtype, p_geom.sdo_srid, p_geom.sdo_point,
                                   mdsys.sdo_elem_info_array(1,2,1), l_ord );

   END IF;

   RETURN retval;

END;

--
--------------------------------------------------------------------------------------------------------
--

FUNCTION sample_route   ( p_layer IN NM_THEMES_ALL.nth_theme_id%TYPE,
                          p_ne_id IN nm_elements.ne_id%TYPE,
                          p_interval IN INTEGER ) RETURN mdsys.sdo_geometry IS

-- exception subscript_beyond_count;
-- pragma exception_init( subscript_beyond_count, 6533);

TYPE geocurtyp IS REF CURSOR;

geocur   geocurtyp;
shapecur geocurtyp;

/*
-- problems with memory in the join of large shapes with an order - cannot use this cursor

cur_string varchar2(2000) := 'select '||nm3sdo.get_layer_shape_column(p_layer)||', nm_cardinality, nm_true '||
                             '  from nm_members, '||nm3sdo.get_layer_table(p_layer)||' '||
                             '  where nm_ne_id_in = :c_ne_id '||
                             '  and   nm_ne_id_of = '||nm3sdo.get_layer_ne_column(p_layer)||
                             '  order by nm_seq_no ';

*/

mem_string VARCHAR2(2000) := 'select nm_ne_id_of, nm_begin_mp, nm_end_mp, nm_cardinality, nm_slk, nm_true '||
                             '  from nm_members '||
                             '  where nm_ne_id_in = :c_ne_id '||
                             '  order by nm_seq_no ';

mem_string_sc VARCHAR2(2000) := 'select nm_ne_id_of, nm_begin_mp, nm_end_mp, nm_cardinality, nm_slk, nm_true '||
                             '  from nm_members, nm_elements, nm_type_subclass '||
                             '  where nm_ne_id_in = :c_ne_id '||
                             '  and   nm_ne_id_of = ne_id '||
                             '  and   nsc_sub_class = ne_sub_class '||
                             '  and   nsc_nw_type   = ne_nt_type '||
                             '  and   nsc_seq_no != 3 '||
                             '  order by nm_seq_no ';


cur_string VARCHAR2(2000);

/*
  cursor geocur( c_ne_id in nm_elements.ne_id%type)  is
  select nm_ne_id_of, nm_cardinality, nm_true
  from nm_members
  where nm_ne_id_in = c_ne_id
  and   decode(nm3flx.boolean_to_char( nm3net.is_sub_class_allowed
  order by nm_seq_no;
*/

ips INTEGER;
l_geom         mdsys.sdo_geometry;
l_cardinality  nm_members.nm_cardinality%TYPE;
l_slk          nm_members.nm_slk%TYPE;
l_true         nm_members.nm_true%TYPE;
l_last         INTEGER;
l_ord          mdsys.sdo_ordinate_array := mdsys.sdo_ordinate_array(1);
l_elem         mdsys.sdo_elem_info_array := mdsys.sdo_elem_info_array(1,2,1);
l_eip          INTEGER := 1;
l_oip          INTEGER := 4;
l_set          BOOLEAN := FALSE;
l_ne_id        nm_elements.ne_id%TYPE;
l_length       NUMBER;
l_start        NUMBER;
l_end          NUMBER;
l_total_length NUMBER := 0;


retval mdsys.sdo_geometry;

BEGIN

  IF set_theme( p_layer ) THEN
    set_theme_metadata( p_layer );
  END IF;

  --   nm_debug.debug_on;

  IF Nm3net.is_sub_class_used ( Nm3net.get_gty_type(p_ne_id)) THEN
    OPEN geocur FOR mem_string_sc USING p_ne_id;
    --   nm_debug.debug( mem_string_sc );
  ELSE
    OPEN geocur FOR mem_string USING p_ne_id;
    --   nm_debug.debug( mem_string );
  END IF;

  --   nm_debug.debug('Using:'||to_char(p_ne_id));

  LOOP

    FETCH geocur INTO l_ne_id, l_start, l_end, l_cardinality, l_slk, l_true;
    EXIT WHEN geocur%NOTFOUND;

    cur_string := 'select '||g_usgm.column_name||
                  '  from '||g_usgm.table_name||' '||
                  '  where '||g_nth.nth_feature_pk_column||' = :c_ne_id ';

    OPEN shapecur FOR cur_string USING l_ne_id;
      FETCH shapecur INTO l_geom;
      IF shapecur%FOUND THEN

        CLOSE shapecur;

        --   nm_debug.debug('Geocur '||to_char( geocur%rowcount));

        IF is_clipped( l_start, l_end, l_length ) = 0 THEN
          l_geom := sdo_lrs.clip_geom_segment( l_geom, g_usgm.diminfo, l_start, l_end );
          l_geom := sdo_lrs.SCALE_GEOM_SEGMENT( l_geom, g_usgm.diminfo, 0,  (l_end-l_start), 0);

        END IF;

        IF l_cardinality < 0 THEN
--        l_geom := sdo_lrs.reverse_geometry( l_geom, l_diminfo );

          l_geom := reverse_geometry( l_geom );

--        l_geom := sdo_lrs.reverse_measure( l_geom, l_diminfo );
          --   nm_debug.debug('Reversing');
        END IF;

        l_last := l_geom.sdo_ordinates.LAST;
        --   nm_debug.debug('Last = '||to_char(l_geom.sdo_ordinates(l_geom.sdo_ordinates.last)));

        IF l_last/3 > p_interval THEN

          IF geocur%rowcount = 1 THEN

            l_ord(1) := l_geom.sdo_ordinates(1);
            l_ord.EXTEND;
            l_ord(2) := l_geom.sdo_ordinates(2);
            l_ord.EXTEND;
            l_ord(3) := l_geom.sdo_ordinates(3);
            l_length := l_ord(3);

            --   nm_debug.debug('Instantiated with first 3');

          END IF;

          l_set := FALSE;

          FOR ip IN 4..l_last LOOP

            ips := ip;
            IF NOT l_set AND ( MOD( (ip-1)/3, p_interval ) = 0 OR ip = l_geom.sdo_ordinates.LAST - 2) THEN

              l_set := TRUE;
              --   nm_debug.debug('True at '||to_char(ip));

            END IF;

            IF l_set THEN

              l_ord.EXTEND;
              --   nm_debug.debug('setting '||to_char(l_oip)||' with '||to_char(ip));

              IF MOD((l_oip), 3) = 0 THEN
                l_length := l_ord(l_oip);
                l_set := FALSE;
                --   nm_debug.debug('False at '||to_char(ip));
                l_ord( l_oip ) := l_geom.sdo_ordinates( ip ) + l_total_length;
              ELSE
                l_ord( l_oip ) := l_geom.sdo_ordinates( ip );
              END IF;

              l_oip := l_oip + 1;

            END IF;
          END LOOP;
          l_total_length := l_ord(l_ord.LAST);

        ELSE
          IF geocur%rowcount = 1 THEN
            --   nm_debug.debug('At first one');
            l_oip := 4;
            l_ord(1) := l_geom.sdo_ordinates(1);
            l_ord.EXTEND;
            l_ord(2) := l_geom.sdo_ordinates(2);
            l_ord.EXTEND;
            l_ord(3) := l_geom.sdo_ordinates(3);
            l_length := l_ord(3);
            l_total_length := 0;
          END IF;

          FOR ip IN 4.. l_last LOOP
            l_ord.EXTEND;
            IF MOD((l_oip), 3) = 0 THEN
              l_ord(l_oip) := l_geom.sdo_ordinates(ip) + l_total_length;
              l_length := l_ord(l_oip);
            ELSE
              l_ord(l_oip) := l_geom.sdo_ordinates(ip);
            END IF;
            l_oip := l_oip + 1;
          END LOOP;

          l_total_length := l_ord(l_ord.LAST);

        END IF;
      ELSE
--      there is a break due to loss of connectivity or a distance break (no shape)

        --   nm_debug.debug('there is a break at '||to_char(l_ne_id));
        l_elem.EXTEND;
        l_eip           := l_eip + 1;
        l_elem((l_eip-1)*3 + 1) := l_oip;
        l_elem.EXTEND;
        l_elem((l_eip-1)*3 + 2) := 2;
        l_elem.EXTEND;
        l_elem((l_eip-1)*3 + 3) := 1;
      END IF;
  END LOOP;
  CLOSE geocur;

  retval := mdsys.sdo_geometry( l_geom.sdo_gtype, l_geom.sdo_srid, l_geom.sdo_point,
                                l_elem, l_ord );

  RETURN retval;

END;

--
--------------------------------------------------------------------------------------------------------------------
--

FUNCTION sample_route   ( p_layer IN NM_THEMES_ALL.nth_theme_id%TYPE,
                          p_route_name IN nm_elements.ne_unique%TYPE,
                          p_interval IN INTEGER ) RETURN mdsys.sdo_geometry IS

BEGIN
  RETURN sample_route( p_layer, Nm3net.get_ne_id(p_route_name), p_interval);
END;

--
-----------------------------------------------------------------------------
--

FUNCTION element_has_shape ( p_ne_id IN nm_elements.ne_id%TYPE ) RETURN VARCHAR2 IS


retval VARCHAR2(5) := 'FALSE';
nerow  nm_elements%ROWTYPE := Nm3get.get_ne_all( p_ne_id );

CURSOR c1 ( c_nt_type IN VARCHAR2, c_gty_type IN VARCHAR2 )IS
  SELECT nnth.nnth_nth_theme_id
  FROM NM_LINEAR_TYPES nlt, NM_NW_THEMES nnth
  WHERE nlt.NLT_ID = nnth.nnth_nlt_id
  AND NVL( c_gty_type, Nm3type.c_nvl) = NVL(nlt.NLT_GTY_TYPE, Nm3type.c_nvl)
  AND nlt.NLT_NT_TYPE = c_nt_type;

BEGIN

  FOR irec IN c1( nerow.ne_nt_type, nerow.ne_gty_group_type ) LOOP

    IF element_has_shape( irec.nnth_nth_theme_id, p_ne_id ) = 'TRUE'  THEN
      retval := 'TRUE';
      EXIT;
    END IF;

  END LOOP;

  RETURN retval;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'FALSE';
  WHEN TOO_MANY_ROWS THEN
    RETURN 'TRUE';
END;

--
-----------------------------------------------------------------------------
--

FUNCTION element_has_shape ( p_layer IN NUMBER,
                             p_ne_id IN nm_elements.ne_id%TYPE ) RETURN VARCHAR2 IS

cur_string VARCHAR2(2000);

retval VARCHAR2(5) := 'FALSE';
dummy  INTEGER;

BEGIN

 IF p_layer IS NULL THEN
   RETURN 'FALSE';
  ELSE
  IF set_theme( p_layer ) THEN
    set_theme_metadata( p_layer );
  END IF;

  cur_string  := 'select 1 from '||g_usgm.table_name||
                 ' where '||g_nth.nth_feature_pk_column||' = :ne ';

  EXECUTE IMMEDIATE cur_string INTO dummy USING p_ne_id;

  IF dummy = 1 THEN
    retval := 'TRUE';
  ELSE
    retval := 'FALSE';
  END IF;
  END IF;
  RETURN retval;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'FALSE';
  WHEN TOO_MANY_ROWS THEN
    RETURN 'TRUE';
END;

--
-----------------------------------------------------------------------------
--

-- This is not always correct - it does not take care of the other columns on the spatial table such as dates.

PROCEDURE insert_layer_shape( p_layer IN NUMBER,
                              p_ne_id IN nm_elements.ne_id%TYPE,
         p_geom  IN mdsys.sdo_geometry ) IS

cur_string VARCHAR2(2000);

BEGIN

  IF set_theme( p_layer ) THEN
    set_theme_metadata( p_layer );
  END IF;

  cur_string  := 'insert into '||g_usgm.table_name||'('||
                             g_nth.nth_feature_pk_column||','||g_usgm.column_name||')'||
                           ' values ( :ne_id, :geom )';
  EXECUTE IMMEDIATE cur_string USING p_ne_id, p_geom;

END;


--
-----------------------------------------------------------------------------
--
PROCEDURE delete_layer_shape( p_layer IN NUMBER,
                              p_ne_id IN nm_elements.ne_id%TYPE ) IS

cur_string VARCHAR2(2000);
l_nth      nm_themes_all%rowtype;

BEGIN

  l_nth := nm3get.get_nth( p_layer );

  IF l_nth.nth_base_table_theme IS NOT NULL THEN

    l_nth := Nm3get.get_nth( l_nth.nth_base_table_theme);

  END IF;

  IF set_theme( l_nth.nth_theme_id ) THEN
    set_theme_metadata( l_nth.nth_theme_id );
  END IF;

  cur_string  := 'delete from '||g_usgm.table_name||
                             ' where '||g_nth.nth_feature_pk_column||' = :ne_id ';

  EXECUTE IMMEDIATE cur_string USING p_ne_id;

END;

--
-----------------------------------------------------------------------------
--

FUNCTION rescale_layer_element( p_layer IN NUMBER,
                                p_ne_id IN nm_elements.ne_id%TYPE ) RETURN mdsys.sdo_geometry IS

retval    mdsys.sdo_geometry := Get_Layer_Element_Geometry( p_layer, p_ne_id );
l_length  nm_elements.ne_length%TYPE := Nm3net.Get_Ne_Length(p_ne_id);

l_nth      nm_themes_all%rowtype;

BEGIN

  l_nth := nm3get.get_nth( p_layer );

  IF l_nth.nth_base_table_theme IS NOT NULL THEN

    l_nth := Nm3get.get_nth( l_nth.nth_base_table_theme);

  END IF;

  IF set_theme( l_nth.nth_theme_id ) THEN
    set_theme_metadata( l_nth.nth_theme_id );
  END IF;

  sdo_lrs.redefine_geom_segment( retval, g_usgm.diminfo, 0, l_length);

   RETURN retval;
END;

--
-----------------------------------------------------------------------------
--

FUNCTION rescale_geometry( p_layer IN NUMBER,
                           p_ne_id IN nm_elements.ne_id%TYPE,
               p_geom  IN mdsys.sdo_geometry ) RETURN mdsys.sdo_geometry IS

retval    mdsys.sdo_geometry := p_geom;
l_length  nm_elements.ne_length%TYPE := Nm3net.Get_Ne_Length(p_ne_id);

BEGIN

  IF set_theme( p_layer ) THEN
    set_theme_metadata( p_layer );
  END IF;

  sdo_lrs.redefine_geom_segment( retval, g_usgm.diminfo, 0, l_length);

   RETURN retval;
END;
--
----------------------------------------------------------------------------------------------------------
--

FUNCTION Set_Srid(p_layer IN NUMBER,  p_geom mdsys.sdo_geometry ) RETURN mdsys.sdo_geometry IS
  l_srid NUMBER;
BEGIN
  IF set_theme( p_layer ) THEN
    set_theme_metadata( p_layer );
  END IF;

  RETURN mdsys.sdo_geometry(p_geom.sdo_gtype, g_usgm.srid, p_geom.sdo_point, p_geom.sdo_elem_info, p_geom.sdo_ordinates );
END;
--
-----------------------------------------------------------------------------
--

FUNCTION Set_Srid(p_geom IN mdsys.sdo_geometry, p_srid IN NUMBER ) RETURN mdsys.sdo_geometry IS
BEGIN
  RETURN mdsys.sdo_geometry(p_geom.sdo_gtype, p_srid, p_geom.sdo_point, p_geom.sdo_elem_info, p_geom.sdo_ordinates );
END;

--
-----------------------------------------------------------------------------
--

FUNCTION project(p_geom IN mdsys.sdo_geometry, p_srid IN NUMBER ) RETURN mdsys.sdo_geometry IS
BEGIN
  IF p_geom.sdo_srid IS NULL THEN
    Hig.raise_ner(pi_appl                => Nm3type.c_hig
                  ,pi_id                 => 283
                  ,pi_sqlcode            => -20001
                    );
--  raise_application_error(-20001, 'You may not project a geometry in a local cordinate system');
  END IF;

  RETURN sdo_cs.transform ( p_geom, p_srid );
END;

--
-----------------------------------------------------------------------------
--

FUNCTION get_midpoint ( p_geom IN mdsys.sdo_geometry) RETURN mdsys.sdo_geometry IS

ldim INTEGER;
ldis NUMBER;
l_geom mdsys.sdo_geometry;
retval mdsys.sdo_geometry;

BEGIN
  IF Nm3sdo.get_type_from_gtype( p_geom.sdo_gtype ) != 2 THEN
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                    ,pi_id                 => 284
                    ,pi_sqlcode            => -20001
                    );
--  RAISE_APPLICATION_ERROR( -20001, 'Mid point must apply to a line');
  ELSE

    ldim := p_geom.get_dims();
-- Nm_Debug.debug_on;
-- Nm_Debug.DEBUG( TO_CHAR(ldim ));

--
--  how do we know its an lrs? - we don't!

 IF ldim = 3 THEN
      ldis := sdo_lrs.geom_segment_end_measure(p_geom)/2;
      retval := sdo_lrs.locate_pt( p_geom, ldis );
 ELSIF ldim = 2 THEN
   l_geom := sdo_lrs.convert_to_lrs_geom( p_geom );
      ldis   := sdo_lrs.geom_segment_end_measure(l_geom)/2;
      retval := sdo_lrs.locate_pt( l_geom, ldis );
 ELSE
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                    ,pi_id                 => 285
                    ,pi_sqlcode            => -20001
                    );
--    RAISE_APPLICATION_ERROR( -20001, 'Invalid dimension for mid-point function');
    END IF;

  END IF;
--

  IF retval.sdo_point IS NULL THEN
      RETURN mdsys.sdo_geometry( 2001, retval.sdo_srid,
                    mdsys.sdo_point_type( retval.sdo_ordinates(1),  retval.sdo_ordinates(2), NULL ), NULL, NULL);
  ELSE
      RETURN mdsys.sdo_geometry( 2001, retval.sdo_srid,
                    mdsys.sdo_point_type( retval.sdo_point.x,  retval.sdo_point.y, NULL ), NULL, NULL);
  END IF;

END;

--
-----------------------------------------------------------------------------
--
FUNCTION get_2d_pt( p_x IN NUMBER, p_y IN NUMBER ) RETURN mdsys.sdo_geometry IS
retval mdsys.sdo_geometry;
l_srid NUMBER;
CURSOR c1 IS
  SELECT sdo_srid
  FROM mdsys.sdo_geom_metadata_table, NM_THEMES_ALL, TABLE ( Nm3sdo.get_nw_themes().nta_theme_array ) t
  WHERE sdo_table_name = nth_feature_table
  AND   sdo_column_name = nth_feature_shape_column
  AND   sdo_owner       = Hig.get_application_owner
  AND   nth_theme_id = t.nthe_id;
BEGIN
  OPEN c1;
  FETCH c1 INTO l_srid;
  CLOSE c1;

  retval := mdsys.sdo_geometry( 2001, l_srid, mdsys.sdo_point_type( p_x, p_y, NULL), NULL, NULL);
  RETURN retval;
EXCEPTION

  WHEN OTHERS THEN
    retval := mdsys.sdo_geometry( 2001, NULL, mdsys.sdo_point_type( p_x, p_y, NULL), NULL, NULL);
 RETURN retval;
END;
--
-----------------------------------------------------------------------------
--

FUNCTION get_2d_pt( p_geom mdsys.sdo_geometry ) RETURN mdsys.sdo_geometry IS
--l_geom mdsys.sdo_geometry;
  -- Task 0108546
  -- No longer used
  --:= strip_user_parts( p_geom );
ltype NUMBER := Nm3sdo.get_type_from_gtype(p_geom.sdo_gtype);
BEGIN

  IF ltype = 1 THEN  -- a point - test how data is stored
    IF p_geom.sdo_point IS NULL THEN
      RETURN mdsys.sdo_geometry( 2001, p_geom.sdo_srid,
                    mdsys.sdo_point_type( p_geom.sdo_ordinates(1),  p_geom.sdo_ordinates(2), NULL ), NULL, NULL);
    ELSE
      RETURN mdsys.sdo_geometry( 2001, p_geom.sdo_srid,
                    mdsys.sdo_point_type( p_geom.sdo_point.x,  p_geom.sdo_point.y, NULL ), NULL, NULL);
    END IF;

  ELSIF ltype = 2 THEN -- line - always use ordinate array

    RETURN get_2d_pt(Nm3sdo.get_midpoint( p_geom ));

  ELSIF ltype = 3 THEN -- polygon - always use ordinate array, exception when the sdo_point is used. (mapinfo often stores the centroid)

    RETURN get_2d_pt(sdo_geom.sdo_centroid( p_geom, .001 ));

  ELSE

    Hig.raise_ner(pi_appl                => Nm3type.c_hig
                 ,pi_id                 => 287
                 ,pi_sqlcode            => -20001
                 );

--  RAISE_APPLICATION_ERROR(-20001, 'Unknown geometry type - must be a point, line or polygon');
  END IF;
END;

--
-----------------------------------------------------------------------------
--


FUNCTION get_distance_points ( p_layer IN NUMBER, p_interval IN NUMBER,
                               p_geometry IN mdsys.sdo_geometry )
     RETURN mdsys.sdo_geometry IS


  retval mdsys.sdo_geometry;

  nopts INTEGER;

  l_ordinates mdsys.sdo_ordinate_array;

  l_pt_geom mdsys.sdo_geometry;
  l_end     NUMBER;

  l_geometry mdsys.sdo_geometry := p_geometry;

BEGIN

  --   nm_debug.debug_on;

  --   nm_debug.debug('Start');

  IF set_theme( p_layer ) THEN
    set_theme_metadata( p_layer );
  END IF;


  l_ordinates := mdsys.sdo_ordinate_array(0);

  IF p_interval > 0 THEN

    l_end := sdo_lrs.geom_segment_end_measure( p_geometry, g_usgm.diminfo );
    nopts := l_end/p_interval;

    --   nm_debug.debug('No of pts = '||to_char(nopts));

 FOR irec IN 1..nopts LOOP

--
--    prevent rounding errors - last point should be on the geometry
--
      IF p_interval*irec <= l_end THEN
       l_pt_geom := sdo_lrs.locate_pt( l_geometry, g_usgm.diminfo, p_interval*irec);

     --   nm_debug.debug('Pt Geom - ('||to_char(l_pt_geom.sdo_ordinates(1))||','||
        --                            to_char(l_pt_geom.sdo_ordinates(2))||')');

        IF irec > 1 THEN
        l_ordinates.EXTEND;
     END IF;

       l_ordinates(l_ordinates.LAST) := l_pt_geom.sdo_ordinates(1);

       l_ordinates.EXTEND;
     l_ordinates(l_ordinates.LAST) := l_pt_geom.sdo_ordinates(2);

      END IF;

 END LOOP;

    retval := mdsys.sdo_geometry( 2005, g_usgm.srid, NULL,
             mdsys.sdo_elem_info_array( 1,1,nopts),
    l_ordinates );
  ELSE
    retval := NULL;
  END IF;

  RETURN retval;
END get_distance_points;

--
----------------------------------------------------------------------------------------------------------
--
FUNCTION get_distance_points ( p_layer IN NUMBER, p_interval IN NUMBER, p_unit_id IN NM_UNITS.un_unit_id%TYPE,
                               p_ne_id IN NUMBER )
     RETURN mdsys.sdo_geometry IS

l_route_units NM_UNITS.un_unit_id%TYPE;

BEGIN

  l_route_units := Nm3get.get_nt( pi_nt_type => Nm3get.get_ne( p_ne_id ).ne_nt_type ).nt_length_unit;

  RETURN get_distance_points( p_layer,
                              Nm3unit.convert_unit( p_unit_id, l_route_units, p_interval),
                              Get_Layer_Element_Geometry( p_layer, p_ne_id ));
END;

--
-----------------------------------------------------------------------------
--


FUNCTION get_distance_points ( p_layer IN NUMBER, p_interval IN NUMBER, p_ne_id IN NUMBER )
     RETURN mdsys.sdo_geometry IS

BEGIN
  RETURN get_distance_points( p_layer, p_interval, Get_Layer_Element_Geometry( p_layer, p_ne_id ));
END;
--
-----------------------------------------------------------------------------
--

FUNCTION is_clipped ( p_start IN NUMBER, p_end IN NUMBER, p_length IN NUMBER ) RETURN NUMBER IS

retval NUMBER;

BEGIN
  IF p_end = p_length AND p_start = 0 THEN
    RETURN 1; -- false - no clipping;
  ELSE
    RETURN 0; -- clipped
  END IF;
END;

--
----------------------------------------------------------------------------------------------------------
--
FUNCTION get_placement_mp_geometry( p_layer IN NUMBER, p_pl_array IN nm_placement_array ) RETURN mdsys.sdo_geometry IS

cur_string VARCHAR2(2000);


retval   mdsys.sdo_geometry;

lcur          Nm3type.ref_cursor;
l_ne_id       nm_elements.ne_id%TYPE;
l_ne_length   nm_elements.ne_length%TYPE;
l_start       nm_elements.ne_length%TYPE;
l_end         nm_elements.ne_length%TYPE;
l_measure     nm_elements.ne_length%TYPE;
l_geom        mdsys.sdo_geometry;

BEGIN


  IF set_theme( p_layer ) THEN
    set_theme_metadata( p_layer );
  END IF;


    cur_string := 'select /*+cardinality( e '||to_char(p_pl_array.npa_placement_array.last)||') */ '||
       ' b.ne_length, e.pl_ne_id, e.pl_start, e.pl_end, e.pl_measure, '||
       ' decode( nm3sdo.is_clipped( e.pl_start, e.pl_end, b.ne_length), '||
       ' 1, a.'||g_usgm.column_name||', sdo_lrs.clip_geom_segment( a.'||g_usgm.column_name||', :l_dim_info, e.pl_start, e.pl_end ))'||
       ' from nm_elements b, '||g_usgm.table_name||' a, table ( '||
       '   :pl_array.npa_placement_array ) e '||
       ' where a.'||g_nth.nth_feature_pk_column||' = e.pl_ne_id '||
       ' and   b.ne_id = e.pl_ne_id ';

--  --   nm_debug.debug_on;
--  --   nm_debug.delete_debug(true);

--  --   nm_debug.debug( cur_string );

    OPEN lcur FOR cur_string USING g_usgm.diminfo, p_pl_array;

--    --   nm_debug.debug('first fetch');

    FETCH lcur INTO l_ne_length, l_ne_id, l_start, l_end, l_measure, retval;

--    --   nm_debug.debug(to_char( l_ne_id )||' '||nm3net.get_ne_unique( l_ne_id ));

--    --   nm_debug.debug( to_char( l_start )||' '||to_char( l_end ));


--    --   nm_debug.debug('Entering loop');
    WHILE lcur%FOUND LOOP

      FETCH lcur INTO l_ne_length, l_ne_id, l_start, l_end, l_measure, l_geom;

      IF lcur%FOUND THEN
/*
        --   nm_debug.debug('Found some more');

        --   nm_debug.debug(to_char( l_ne_id )||' '||nm3net.get_ne_unique( l_ne_id ));

        --   nm_debug.debug( to_char( l_start )||' '||to_char( l_end ));

        --   nm_debug.debug( to_char( l_geom.sdo_elem_info(1)));
*/

--        retval := add_segments( retval, l_geom );
        add_segments( retval, l_geom, g_usgm.diminfo );

--      else
--        --   nm_debug.debug('No more');
      END IF;
    END LOOP;

--    --   nm_debug.debug('close');
    CLOSE lcur;

  RETURN retval;

END;

--
-----------------------------------------------------------------------------
--

FUNCTION get_temp_extent_mp_geometry( p_layer      IN NUMBER,
                                      p_nte_job_id IN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                               ) RETURN mdsys.sdo_geometry IS

cur_string VARCHAR2(2000);

retval   mdsys.sdo_geometry;

lcur          Nm3type.ref_cursor;
l_ne_id       nm_elements.ne_id%TYPE;
l_ne_length   nm_elements.ne_length%TYPE;
l_start       nm_elements.ne_length%TYPE;
l_end         nm_elements.ne_length%TYPE;
l_measure     nm_elements.ne_length%TYPE;
l_geom        mdsys.sdo_geometry;

BEGIN

  IF set_theme( p_layer ) THEN
    set_theme_metadata( p_layer );
  END IF;

    cur_string := 'select b.ne_length, e.nte_ne_id_of, e.nte_begin_mp, e.nte_end_mp, '||
       ' decode( nm3sdo.is_clipped( e.nte_begin_mp, e.nte_end_mp, b.ne_length), '||
       ' 1, a.'||g_usgm.column_name||', sdo_lrs.clip_geom_segment( a.'||g_usgm.column_name||', :l_dim_info, e.nte_begin_mp, e.nte_end_mp ))'||
       ' from nm_elements b, '||g_usgm.table_name||' a, nm_nw_temp_extents e  '||
       ' where a.'||g_nth.nth_feature_pk_column||' = e.nte_ne_id_of '||
       ' and   b.ne_id = e.nte_ne_id_of '||
       ' and   e.nte_job_id = :l_nte_job_id';

    --   nm_debug.debug_on;
    --   nm_debug.delete_debug(true);

    --   nm_debug.debug( cur_string );

    OPEN lcur FOR cur_string USING g_usgm.diminfo, p_nte_job_id;

    FETCH lcur INTO l_ne_length, l_ne_id, l_start, l_end, retval;

    WHILE lcur%FOUND LOOP

      --   nm_debug.debug(to_char( l_ne_id )||' '||nm3net.get_ne_unique( l_ne_id ));

      FETCH lcur INTO l_ne_length, l_ne_id, l_start, l_end, l_geom;

--      retval := add_segments( retval, l_geom );
      add_segments( retval, l_geom, g_usgm.diminfo);

    END LOOP;

  RETURN retval;

END;
--
-----------------------------------------------------------------------------
--
  FUNCTION create_sdo_layer
            ( pi_table_name  IN user_sdo_geom_metadata.table_name%TYPE
            , pi_column_name IN user_sdo_geom_metadata.column_name%TYPE
            , pi_gtype       IN NM_THEME_GTYPES.ntg_gtype%TYPE)
    RETURN NUMBER
    /*
      AE : This procedure creates SDO metadata for a given table and column
           The table doesn't have to exist or be populated.
           Values are derived from the base layer
    */
  IS
     l_rec_usgm     user_sdo_geom_metadata%ROWTYPE;
     l_diminfo      mdsys.sdo_dim_array;
     l_srid         NUMBER;
     b_tab_exists   BOOLEAN := FALSE;
     b_view_exists  BOOLEAN := FALSE;
     l_geom         mdsys.sdo_geometry;
  --
  BEGIN
  --
    -- does table exist - and does it have any data to register from
    IF Nm3ddl.does_object_exist(pi_table_name)
    THEN
--      Nm_Debug.DEBUG ('csl - table');
      b_tab_exists := TRUE;
    END IF;

    -- get a copy of base layer for cloning -- temporary !
--    Nm_Debug.DEBUG ('csl - get base layer');

    /* TABLE/VIEW ALREADY EXISTS  */
    --
    IF b_tab_exists
    THEN

--      Nm_Debug.DEBUG ('csl true- diminfo');
      BEGIN
        l_diminfo := calculate_table_diminfo( pi_table_name, pi_column_name );
--        Nm_Debug.DEBUG ('csl --dimpass-');
      EXCEPTION
        WHEN OTHERS
        THEN
          -- if it fails to calculate - the table is empty.- revert to using base layer for now.
          IF get_dim_from_gtype(pi_gtype) = 2
          THEN
--            Nm_Debug.DEBUG ('csl --dimfail- 2001');
            l_diminfo := sdo_lrs.convert_to_std_dim_array(coalesce_nw_diminfo);
          ELSE
--            Nm_Debug.DEBUG ('csl --dimfail- 3001');
            l_diminfo := coalesce_nw_diminfo;
          END IF;
      END;

      BEGIN
        EXECUTE IMMEDIATE
            'select a.'||pi_column_name
           ||' from '||pi_table_name
        ||' a where rownum = 1'
         INTO l_geom;
--         Nm_Debug.DEBUG ('csl -pass--srid');
        -- set srid from existing shape
         l_rec_usgm.srid := l_geom.sdo_srid;
      EXCEPTION
        WHEN OTHERS
        THEN
          -- if it fails to get a row - the table/view is empty
          -- revert to using base layer for now.
--            Nm_Debug.DEBUG ('csl -fail-srrid');
          l_rec_usgm.srid := get_nw_srids;
      END;

    /* TABLE/VIEW DOES NOT EXISTS  */
    --
    ELSE
--      Nm_Debug.DEBUG ('csl --table_view doesnt exist');
      -- table/view doesn't exist, so copy the base layer diminfo for now

      -- set dimarray according to gtype
      IF get_dim_from_gtype(pi_gtype) = 2
      THEN
--       Nm_Debug.DEBUG ('csl --- 2001');
       l_diminfo := sdo_lrs.convert_to_std_dim_array(coalesce_nw_diminfo);
      ELSE
--       Nm_Debug.DEBUG ('csl --- 3001');
       l_diminfo := coalesce_nw_diminfo;
      END IF;

      -- set srid
      IF l_srid IS NULL
      THEN
        l_rec_usgm.srid := l_srid;
      END IF;

    END IF;
    --
    DECLARE
         l_tol NUMBER := Hig.get_sysopt('SDODEFTOL');
    BEGIN
        IF l_tol IS NULL THEN
           l_tol := .005;
        END IF;
        l_diminfo(1).sdo_tolerance := l_tol;
        l_diminfo(2).sdo_tolerance := l_tol;
    END;

    l_rec_usgm.table_name   := pi_table_name;
    l_rec_usgm.column_name  := pi_column_name;
    l_rec_usgm.diminfo      := l_diminfo;
    --
--    Nm_Debug.DEBUG ('csl --insert--'||l_rec_usgm.table_name||' - '||l_rec_usgm.column_name);

    ins_usgm( l_rec_usgm.table_name, l_rec_usgm.column_name, l_rec_usgm.diminfo, l_rec_usgm.srid);
/*
    INSERT INTO user_sdo_geom_metadata ( table_name, column_name, diminfo, srid )
    VALUES (l_rec_usgm.table_name, l_rec_usgm.column_name, l_rec_usgm.diminfo, l_rec_usgm.srid );
*/
--    Nm_Debug.DEBUG ('csl --insert done');
    RETURN 1;
  --
  EXCEPTION
  --
    WHEN DUP_VAL_ON_INDEX
    THEN
      -- If metadata already exists for whatever reason, wipe it out
      DELETE mdsys.sdo_geom_metadata_table
       WHERE sdo_table_name = l_rec_usgm.table_name
         AND sdo_column_name = l_rec_usgm.column_name
   AND sdo_owner       = Hig.get_application_owner;

      ins_usgm( l_rec_usgm.table_name, l_rec_usgm.column_name, l_rec_usgm.diminfo, l_rec_usgm.srid);

/*
      INSERT INTO user_sdo_geom_metadata ( table_name, column_name, diminfo, srid )
      VALUES (l_rec_usgm.table_name, l_rec_usgm.column_name, l_rec_usgm.diminfo, l_rec_usgm.srid );
*/

      RETURN 1;

    WHEN OTHERS
      THEN RAISE;
  --
  END create_sdo_layer;
--
-----------------------------------------------------------------------------
--
  FUNCTION clone_layer
            ( p_layer       IN NUMBER
            , p_table_name  IN VARCHAR2
            , p_column_name IN VARCHAR2 )
    RETURN NUMBER
  IS

  BEGIN

   set_global_metadata ( get_theme_metadata( p_layer ) );

    ins_usgm( p_table_name, p_column_name, g_usgm.diminfo, g_usgm.srid );

    RETURN 1;

  END;

--
-----------------------------------------------------------------------------
--

  FUNCTION clone_2d_from_3d_layer
            ( p_layer       IN NUMBER
            , p_table_name  IN VARCHAR2
            , p_column_name IN VARCHAR2 )
    RETURN NUMBER IS

  BEGIN
   set_global_metadata ( get_theme_metadata( p_layer ) );

    ins_usgm  ( p_table_name, p_column_name, sdo_lrs.convert_to_std_dim_array(g_usgm.diminfo), g_usgm.srid );

    RETURN 1;

  END;

--
------------------------------------------------------------------------------------------------------------------------
--

  FUNCTION clone_pt_from_line
            ( p_layer       IN NUMBER
            , p_table_name  IN VARCHAR2
            , p_column_name IN VARCHAR2 )
    RETURN NUMBER IS

  BEGIN

   set_global_metadata ( get_theme_metadata( p_layer ) );

    ins_usgm( p_table_name, p_column_name, sdo_lrs.convert_to_std_dim_array( g_usgm.diminfo), g_usgm.srid );

    RETURN 1;

  END;
--
--
------------------------------------------------------------------------------------------------------------------------
--

  FUNCTION get_sdo_pt
            ( p_layer IN NUMBER
            , p_x     IN NUMBER
            , p_y     IN NUMBER)
   RETURN MDSYS.SDO_GEOMETRY deterministic
  IS

  BEGIN

    IF set_theme( p_layer ) THEN
   set_theme_metadata( p_layer );
 END IF;

    RETURN mdsys.sdo_geometry(2001, g_usgm.srid, mdsys.sdo_point_type(p_x, p_y, NULL),NULL, NULL);

  END;

--
------------------------------------------------------------------------------------------------------------------------
--

  FUNCTION get_no_parts ( p_geom IN mdsys.sdo_geometry ) RETURN NUMBER IS
  BEGIN
    RETURN p_geom.sdo_elem_info.LAST;
  END;

-------------------------------------------------------------------------------------------------------------------------

FUNCTION get_placement_by_xy ( p_layer IN NUMBER,
                               p_x1 IN NUMBER,
                               p_y1 IN NUMBER,
                               p_x2 IN NUMBER,
                               p_y2 IN NUMBER ) RETURN nm_placement IS

retval   nm_placement;
l_start  nm_lref;
l_end    nm_lref;

BEGIN

  l_start := Nm3sdo.get_projection_to_nearest(p_layer, p_x1, p_y1);
  l_end   := Nm3sdo.get_projection_to_nearest(p_layer, p_x2, p_y2);

  IF l_start.lr_ne_id = l_end.lr_ne_id THEN

    IF l_start.lr_offset < l_end.lr_offset THEN

      RETURN nm_placement( l_start.lr_ne_id, l_start.lr_offset, l_end.lr_offset, 0 );

    ELSIF l_start.lr_offset > l_end.lr_offset THEN

      RETURN nm_placement( l_start.lr_ne_id, l_end.lr_offset, l_start.lr_offset, 0 );

    ELSE
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                    ,pi_id                 => 202
                    ,pi_sqlcode            => -20001
                    );
--       raise_application_error (-20001, 'points are the same - no distance between them');

    END IF;

  ELSE

     Hig.raise_ner(pi_appl                => Nm3type.c_hig
                   ,pi_id                 => 232
                   ,pi_sqlcode            => -20001 );

--  raise_application_error (-20002, 'Points are not on same network element');

  END IF;

  RETURN retval;

END;

--
--------------------------------------------------------------------------------
--

PROCEDURE evaluate_and_raise_geo_val ( pi_text IN VARCHAR2 )
IS
--
  l_error_code VARCHAR2(5) := SUBSTR(pi_text,1,5);
  l_count      NUMBER;
--
  FUNCTION check_for_exclusion RETURN BOOLEAN
  IS
  BEGIN
    SELECT COUNT(*) INTO l_count FROM TABLE (g_error_to_ignore.pa) val
     WHERE val.ptr_value = l_error_code;
    RETURN (l_count!=0);
  END;
--
BEGIN
-- Make sure the code is actually an oracle error code rather than TRUE!
  IF nm3flx.is_numeric(SUBSTR(pi_text,1,5))
  THEN
  -- Raise generic Invalid Geometry error with description from error code
  -- if it's not one of the excluded error codes
    IF NOT check_for_exclusion
    THEN
      hig.raise_ner( pi_appl               => 'HIG'
                   , pi_id                 => 547
                   , pi_supplementary_info => SQLERRM('-'||l_error_code));
    END IF;
  END IF;
--
END evaluate_and_raise_geo_val;

--
--------------------------------------------------------------------------------
--

PROCEDURE insert_element_shape( p_layer IN NUMBER,
                                p_ne_id IN nm_elements.ne_id%TYPE,
                                p_geom IN mdsys.sdo_geometry ) IS
--
  cur_string         VARCHAR2(2000);
  l_nth              NM_THEMES_ALL%ROWTYPE;
  l_length           nm_elements.ne_length%TYPE;
  l_geom             mdsys.sdo_geometry := p_geom;
  l_is_datum         BOOLEAN := Nm3net.element_is_a_datum( p_ne_id );
  l_validation       nm3type.max_varchar2;
--
BEGIN
--
  l_nth := nm3get.get_nth( p_layer );

  IF l_nth.nth_base_table_theme IS NOT NULL THEN

    l_nth := Nm3get.get_nth( l_nth.nth_base_table_theme);

  END IF;


  IF set_theme( l_nth.nth_theme_id ) THEN
    set_theme_metadata( l_nth.nth_theme_id );
  END IF;

--Nm_Debug.debug_on;
--Nm_Debug.DEBUG('SRID = '||TO_CHAR(p_geom.sdo_srid));

  IF g_usgm.srid != NVL(p_geom.sdo_srid, -99999) THEN

--  Nm_Debug.DEBUG('Setting SRID to '||TO_CHAR(g_usgm.srid));

    l_geom.sdo_srid := g_usgm.srid;

  END IF;

  l_length := Nm3net.Get_Ne_Length( p_ne_id );

  IF nvl(sdo_lrs.geom_segment_end_measure ( l_geom, g_usgm.diminfo ), -9999) != l_length THEN

--   nm_debug.debug_on;
--   nm_debug.debug('insert with length = '||to_char(l_length)||' and '||to_char(sdo_lrs.geom_segment_end_measure ( l_geom, g_usgm.diminfo )));

     sdo_lrs.redefine_geom_segment( l_geom, g_usgm.diminfo, 0, l_length );

  END IF;

  IF sdo_lrs.geom_segment_end_measure( l_geom, g_usgm.diminfo ) != l_length THEN

--nm_debug.debug( 'error - ne length = '||to_char(nm3net.get_datum_element_length( p_ne_id ) ));
--nm_debug.debug('shape length = '||to_char(sdo_lrs.geom_segment_end_measure( p_geom, l_diminfo ) ));
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                    ,pi_id                 => 204
                    ,pi_sqlcode            => -20001
                    );

--    raise_application_error(-20001,'Lengths of element and shape are inconsistent' );
  END IF;
--
  -- Task 0109983
  -- Validate the geometry and raise error if appropriate
  -- (task 0109983 - after system test failure - the validation was temporarily removed)
--  IF g_do_geom_validation
--  THEN
--    evaluate_and_raise_geo_val (validate_geometry(l_geom,p_layer,NULL));
--  END IF;
--
  IF use_surrogate_key = 'N' OR l_is_datum THEN

    cur_string := 'insert into '||g_usgm.table_name||' ( '||g_nth.nth_feature_pk_column||','||
                                                        g_usgm.column_name||')'||
                   'values ( :ne_val, :geom_val )';

  ELSE

    cur_string := 'insert into '||g_usgm.table_name||' ( '||g_nth.nth_feature_pk_column||','||
                                                        g_usgm.column_name||', objectid)'||
                   'select :ne_val, :geom_val, '||get_spatial_seq( p_layer )||'.nextval from dual';
  END IF;

--nm_debug.debug_on;
--nm_debug.debug(cur_string);

  EXECUTE IMMEDIATE cur_string USING p_ne_id, l_geom;


  --
  -- Task 0109633, 0109634, 0109938, 0109937, 0109936
  -- AE 07-July-2010
  --   Only call the change affected shapes if we are doing this insert element shape
  --   outside the scope of a network edit.
  --   Calling this routine during a network edit can cause problems, and it ends up being
  --   invoked from the members triggers anyway.
  --   The problem manifested using Reclassify - shorten a datum and any assets off the 
  --   end of the datum would result in this failing with a null shape - i.e. cannot insert null
  --   into asset shape table. 
  -- 
  IF NOT nm3merge.is_nw_operation_in_progress
  THEN
    --
    -- Task 0108237
    -- AE Change affected shapes to generate autoincluded group shapes.
    --
    nm3sdo.change_affected_shapes (p_layer      => g_nth.nth_theme_id,
                                   p_ne_id      => p_ne_id);
  END IF;

END;

--
-----------------------------------------------------------------------------
--
  PROCEDURE set_point_srid IS
  l_srid NUMBER;
  BEGIN
    g_point_srid := get_table_srid( 'NM_POINT_LOCATIONS', 'NPL_LOCATION' );
  END;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_point_srid RETURN NUMBER IS
  BEGIN
    RETURN g_point_srid;
  END;
--
-----------------------------------------------------------------------------
--

  FUNCTION get_table_srid ( p_table_name IN VARCHAR2, p_column_name IN VARCHAR2 ) RETURN NUMBER IS
  CURSOR c1( c_tab VARCHAR2, c_col VARCHAR2) IS
    SELECT sdo_srid
    FROM mdsys.sdo_geom_metadata_table
    WHERE sdo_table_name = c_tab
    AND   sdo_column_name = c_col
 AND   sdo_owner       = Hig.get_application_owner;
  retval NUMBER;
  BEGIN
    OPEN c1( p_table_name, p_column_name );
    FETCH c1 INTO retval;
    IF c1%NOTFOUND THEN
      CLOSE c1;
        Hig.raise_ner(pi_appl                => Nm3type.c_hig
                      ,pi_id                 => 197
                      ,pi_sqlcode            => -20001
                      );
  --    raise_application_error(-20003, 'Table is not registered');
    END IF;
    CLOSE c1;
    RETURN retval;
  END;

--
-----------------------------------------------------------------------------
--
  FUNCTION hypot ( x1 IN NUMBER, y1 IN NUMBER, x2 IN NUMBER, y2 IN NUMBER )
  RETURN NUMBER
  IS
  BEGIN
    RETURN SQRT( POWER((x2 - x1), 2) + POWER((y2 - y1), 2));
  END;

--
-----------------------------------------------------------------------------
--

  PROCEDURE add_new_inv_shapes( P_LAYER IN NUMBER,
                                P_NE_ID IN nm_elements.ne_id%TYPE,
                                P_GEOM  IN OUT NOCOPY mdsys.sdo_geometry ) IS

  CURSOR c_inv( c_base_layer IN NUMBER, c_ne_id IN NUMBER ) IS
    SELECT nth_feature_table ftab, nth_feature_pk_column pkcol, nth_feature_pk_column fkcol,
           nth_feature_shape_column geocol, nm_ne_id_in, nm_obj_type, nm_begin_mp, nm_end_mp, nm_start_date, nit_pnt_or_cont
    FROM NM_INV_THEMES, NM_THEMES_ALL, nm_members, nm_inv_types, NM_BASE_THEMES
    WHERE nith_nit_id       = nm_obj_type
 AND   nm_type           = 'I'
    AND   nit_inv_type      = nith_nit_id
    AND   nith_nth_theme_id = nth_theme_id
    AND   nbth_base_theme   = c_base_layer
 AND   nth_theme_id       = nbth_theme_id
    AND   nm_ne_id_of        = c_ne_id;

  l_geom     mdsys.sdo_geometry;

  l_st       NUMBER;
  l_end      NUMBER;
  l_last     NUMBER;

  l_length   NUMBER := Nm3net.get_datum_element_length( p_ne_id );

  BEGIN

  IF set_theme( p_layer ) THEN
    set_theme_metadata( p_layer );
  END IF;

  l_st  := sdo_lrs.geom_segment_start_measure( p_geom, g_usgm.diminfo );

  l_end := sdo_lrs.geom_segment_end_measure( p_geom, g_usgm.diminfo );

  --nm_debug.debug_on;
  --nm_debug.debug( 'New shapes for id = '||to_char( p_ne_id ));

    FOR irec IN c_inv( p_layer, p_ne_id ) LOOP

  --nm_debug.debug('Obj='||irec.nm_obj_type||' begin='||to_char(irec.nm_begin_mp)||
  --  ' end='||to_char(irec.nm_end_mp));

  --nm_debug.debug( 'geometry start and end '||to_char( l_st)||','||to_char(l_end ));

  l_last := p_geom.sdo_ordinates( p_geom.sdo_ordinates.LAST );
  --nm_debug.debug( 'geometry last '||to_char( l_last, '999999.99999999999'));

      IF single_shape_inv = 'Y' THEN
        Hig.raise_ner(pi_appl                => Nm3type.c_hig
                      ,pi_id                 => 205
                      ,pi_sqlcode            => -20001
                      );
  --      raise_application_error( -20001,'Cannot deal with this yet');
      ELSE

        IF irec.nit_pnt_or_cont = 'P' THEN

          l_geom := sdo_lrs.locate_pt( p_geom, g_usgm.diminfo, irec.nm_begin_mp );
          l_geom := mdsys.sdo_geometry( 2001, l_geom.sdo_srid,
                           mdsys.sdo_point_type( l_geom.sdo_ordinates(1),
                                                 l_geom.sdo_ordinates(2), NULL), NULL, NULL);
        ELSE

          IF is_clipped( irec.nm_begin_mp, irec.nm_end_mp, l_length ) = 0 THEN
            l_geom := sdo_lrs.clip_geom_segment( p_geom, g_usgm.diminfo, irec.nm_begin_mp, irec.nm_end_mp );
          ELSE
            l_geom := p_geom;

          END IF;

        END IF;

  --      nm_debug.debug( 'insert into '||irec.ftab||' ( '||
  --           'ne_id, ne_id_of, nm_begin_mp, nm_end_mp,'||irec.geocol||', start_date )'||
  --           ' values ( :ne_id, :ne_id_of, :nm_begin_mp, :nm_end_mp, :geom, :start_date )');

        EXECUTE IMMEDIATE 'insert into '||irec.ftab||' ( '||
             'ne_id, ne_id_of, nm_begin_mp, nm_end_mp,'||irec.geocol||', start_date )'||
             ' values ( :ne_id, :ne_id_of, :nm_begin_mp, :nm_end_mp, :geom, :start_date )'
           USING irec.nm_ne_id_in, p_ne_id, irec.nm_begin_mp, irec.nm_end_mp, l_geom, irec.nm_start_date;

      END IF;

    END LOOP;

  END;
--
-----------------------------------------------------------------------------
--
--
-- All the functions below this mark are used with Oracle 8i although their
-- functionality is reproduced directly in Oracle 9i
--
-- Since 9i is used, these are here in case of compatibility issues.

-----------------------------------------------------------------------------
--

  FUNCTION reverse_geometry ( p_geom IN mdsys.sdo_geometry,
                              p_measure IN NUMBER DEFAULT NULL)
                  RETURN mdsys.sdo_geometry IS

  -- assumes 3d, increasing measure
  -- if p_measure is null, uses the measure on the geometry, otherwise starts at
  -- the p_measure value and uses the segment length.
  --
  eleminfo  mdsys.sdo_elem_info_array;
  retval    mdsys.sdo_ordinate_array;

  iend   INTEGER := p_geom.sdo_ordinates.LAST;
  icount INTEGER;
  l_measure NUMBER := p_measure;

  ilm INTEGER;
  ilx INTEGER;
  ily INTEGER;
  ic  INTEGER;

  lparts INTEGER := Nm3sdo.get_no_parts( p_geom )/3;
  lelem  INTEGER;

  BEGIN
  --assemble the element info array
  ----   nm_debug.debug_on;
  ----   nm_debug.debug( 'reversing - no of parts = '||to_char(lparts));

    FOR j IN 1..lparts LOOP

      lelem := 3 * (lparts - j + 1) + 1;

      IF j = 1 THEN

  --    --   nm_debug.debug( 'j=1, lelem = '||to_char(lelem));

        eleminfo := mdsys.sdo_elem_info_array( 1,2,1);

      ELSE
  --    --   nm_debug.debug( 'multi-part j='||to_char(j)||' , lelem = '||to_char(lelem));
        eleminfo.EXTEND;
  --      eleminfo( eleminfo.last ) := j;
        eleminfo( eleminfo.LAST ) := iend - p_geom.sdo_elem_info(lelem) + 2;
        eleminfo.EXTEND;
        eleminfo( eleminfo.LAST ) := p_geom.sdo_elem_info(lelem+1);
        eleminfo.EXTEND;
        eleminfo( eleminfo.LAST ) := p_geom.sdo_elem_info(lelem+2);
      END IF;
    END LOOP;


    icount := iend/3;
    --   nm_debug.debug( 'ordinate count = '||to_char( icount ));


    IF p_measure IS NULL THEN
      l_measure := p_geom.sdo_ordinates( 3 );
      --   nm_debug.debug( 'Measure = '||to_char( l_measure ));
    END IF;

    FOR i IN 1..icount LOOP

      ic := 3*(i-1) + 1;

      --   nm_debug.debug( 'Loop - setting '||to_char( ic ));

      ilm := 3* (icount - i + 1);   -- the ordinates counting back from the end;
      ily := ilm - 1;
      ilx := ily - 1;

      --   nm_debug.debug( 'M '||to_char( ilm )||','||to_char( p_geom.sdo_ordinates(ilm)));
      --   nm_debug.debug( 'X '||to_char( ilx )||','||to_char( p_geom.sdo_ordinates(ilx)));
      --   nm_debug.debug( 'Y '||to_char( ily )||','||to_char( p_geom.sdo_ordinates(ily)));

      IF i = 1 THEN

        retval := mdsys.sdo_ordinate_array( p_geom.sdo_ordinates( ilx ));
        retval.EXTEND;
        retval(2) := p_geom.sdo_ordinates( ily );
        retval.EXTEND;
        retval(3) := l_measure;

      ELSE

        l_measure := l_measure + ( p_geom.sdo_ordinates(ilm + 3) - p_geom.sdo_ordinates( ilm ));

        retval.EXTEND;
        retval(ic) := p_geom.sdo_ordinates( ilx );
        retval.EXTEND;
        retval(ic+1) := p_geom.sdo_ordinates( ily );
        retval.EXTEND;
        retval(ic+2) := l_measure;

      END IF;

    END LOOP;

    RETURN mdsys.sdo_geometry( p_geom.sdo_gtype, p_geom.sdo_srid, p_geom.sdo_point,
                               eleminfo, retval );
  END;
--
-----------------------------------------------------------------------------
--

  FUNCTION get_placement_mbr( p_layer IN NUMBER, p_pl_array IN nm_placement_array ) RETURN mdsys.sdo_geometry IS


  -- replace with 9i aggr function

  CURSOR c_placement ( c_pl_array nm_placement_array ) IS
    SELECT e.pl_ne_id  pl_ne_id,
           e.pl_start  pl_start,
           e.pl_end    pl_end,
           b.ne_length ne_length,
           is_clipped ( e.pl_start, e.pl_end, b.ne_length) clip_flag
    FROM nm_elements b, TABLE ( c_pl_array.npa_placement_array ) e
    WHERE b.ne_id = e.pl_ne_id;

  retval mdsys.sdo_geometry;

  l_minx  NUMBER := 9999999999999999999;
  l_maxx  NUMBER := -9999999999999999999;

  l_miny  NUMBER := l_minx;
  l_maxy  NUMBER := l_maxx;

  l_geom     mdsys.sdo_geometry;
  l_eleminfo mdsys.sdo_elem_info_array := mdsys.sdo_elem_info_array(1, 1003, 3);

  BEGIN

  IF set_theme( p_layer ) THEN
    set_theme_metadata( p_layer );
  END IF;

    --   nm_debug.debug_on;
    --   nm_debug.delete_debug(true);

    FOR irec IN c_placement( p_pl_array) LOOP

      --   nm_debug.debug(to_char( irec.pl_ne_id )||' '||nm3net.get_ne_unique( irec.pl_ne_id ));

      --   nm_debug.debug( to_char( irec.pl_start )||' '||to_char( irec.pl_end ));

      l_geom := Get_Layer_Element_Geometry( p_layer, irec.pl_ne_id );

      IF is_clipped( irec.pl_start, irec.pl_end, irec.ne_length ) = 0 THEN

        l_geom := sdo_lrs.clip_geom_segment( l_geom, g_usgm.diminfo, irec.pl_start, irec.pl_end );

      END IF;

      GET_3D_LAYER_EXTENT ( l_geom, l_minx, l_maxx, l_miny, l_maxy );

    END LOOP;

    retval := mdsys.sdo_geometry( 2003, g_usgm.srid, NULL, l_eleminfo,
                 mdsys.sdo_ordinate_array( l_minx, l_miny, l_maxx, l_maxy ));

    RETURN retval;

  END;

--
------------------------------------------------------------------------------------------------------------------------
--
-- replace with 9i aggregate functions

  PROCEDURE get_3d_layer_extent
             ( p_geom IN     mdsys.sdo_geometry
             , minx   IN OUT NUMBER
             , maxx   IN OUT NUMBER
             , miny   IN OUT NUMBER
             , maxy   IN OUT NUMBER )
  IS
    ic         INTEGER;
    ic1        INTEGER;
    ic2        INTEGER;
    num_points INTEGER;

  BEGIN

     num_points := p_geom.sdo_ordinates.LAST/3;
     FOR ic IN 1..num_points LOOP
       ic1 := 1 + 3*( ic - 1 );
       ic2 := ic1 + 1;

       IF p_geom.sdo_ordinates( ic1 ) < minx THEN
         minx := p_geom.sdo_ordinates( ic1 );
       END IF;
       IF p_geom.sdo_ordinates( ic1 ) > maxx THEN
         maxx := p_geom.sdo_ordinates( ic1 );
       END IF;
       IF p_geom.sdo_ordinates( ic2 ) < miny THEN
         miny := p_geom.sdo_ordinates( ic2 );
       END IF;
       IF p_geom.sdo_ordinates( ic2 ) > maxy THEN
         maxy := p_geom.sdo_ordinates( ic2 );
       END IF;
     END LOOP;
  END;

--
------------------------------------------------------------------------------------------------------------------------
--


  FUNCTION npt_line ( p_geom IN mdsys.sdo_geometry, npt IN INTEGER, ipt IN INTEGER ) RETURN mdsys.sdo_geometry IS

  retval mdsys.sdo_geometry;

  lstart INTEGER := 1 + (npt-1)*3;
  lend   INTEGER := lstart + ( ipt*3 );

  ordval mdsys.sdo_ordinate_array := mdsys.sdo_ordinate_array( p_geom.sdo_ordinates(lstart));

  ic INTEGER;

  BEGIN

  --nm_debug.debug_on;
  --nm_debug.delete_debug(true);
  --nm_debug.debug('Start at '||to_char(lstart));
  --nm_debug.debug('End   at '||to_char(lend));

    ordval.EXTEND;
    ordval(2) := p_geom.sdo_ordinates(lstart+1);

    ordval.EXTEND;
    ordval(3) := p_geom.sdo_ordinates(lstart+2);

    ordval.EXTEND;
    ordval(4) := p_geom.sdo_ordinates(lend);

    ordval.EXTEND;
    ordval(5) := p_geom.sdo_ordinates(lend+1);

    ordval.EXTEND;
    ordval(6) := p_geom.sdo_ordinates(lend+2);

    retval := mdsys.sdo_geometry( 3302, p_geom.sdo_srid, p_geom.sdo_point, mdsys.sdo_elem_info_array( 1,2,1), ordval );

    RETURN retval;

  END;

--
-----------------------------------------------------------------------------
--
-- All the functions below this mark are assumed to be consistent with Oracle 9i extensions.
--
-----------------------------------------------------------------------------
--

  FUNCTION get_mbr( p_geom IN mdsys.sdo_geometry ) RETURN mdsys.sdo_geometry IS
  retval mdsys.sdo_geometry;
  BEGIN

  --nm_debug.debug_on;

    IF p_geom.get_lrs_dim > 0 THEN

       RETURN sdo_geom.sdo_mbr( sdo_lrs.convert_to_std_geom( p_geom ));

    ELSE

       RETURN sdo_geom.sdo_mbr( p_geom );
    END IF;

  END;

--
-----------------------------------------------------------------------------
--


  FUNCTION get_mbr( p_layer IN NUMBER, p_ne_id IN nm_elements.ne_id%TYPE ) RETURN mdsys.sdo_geometry IS
  l_geom mdsys.sdo_geometry;

  retval mdsys.sdo_geometry;

  BEGIN

    l_geom := get_theme_shape( p_layer, p_ne_id );

    RETURN get_mbr( l_geom );

  END;

--
-----------------------------------------------------------------------------
--

  FUNCTION get_aggr_mbr( p_layer IN NUMBER, p_ne_id IN nm_elements.ne_id%TYPE ) RETURN mdsys.sdo_geometry IS

  BEGIN
    RETURN get_placement_aggr_mbr( p_layer, Nm3pla.get_placement_from_ne( p_ne_id ));
  END;

--
-----------------------------------------------------------------------------
--


  FUNCTION get_placement_aggr_mbr( p_layer IN NUMBER, p_pl_array IN nm_placement_array ) RETURN mdsys.sdo_geometry IS

  cur_string VARCHAR2(2000);

  retval   mdsys.sdo_geometry;

  lcur          Nm3type.ref_cursor;

  BEGIN

      cur_string := 'select sdo_aggr_mbr( nm3sdo.get_placement_mp_geometry( :b_layer, :b_pl_array )) from dual';

      OPEN lcur FOR cur_string USING p_layer, p_pl_array;

      FETCH lcur INTO retval;

      RETURN retval;

  END;

--
-----------------------------------------------------------------------------------------------
-- this is used primarily in Oracle map viewer

FUNCTION get_centre_and_size( p_geom IN mdsys.sdo_geometry ) RETURN mdsys.sdo_geometry IS
--l_geom mdsys.sdo_geometry;
l_mbr  mdsys.sdo_geometry;
l_x    NUMBER;
l_y    NUMBER;
l_m    NUMBER;

l_dim    NUMBER;
l_gtype  NUMBER;

l_point  mdsys.sdo_point_type;

BEGIN

  l_mbr   := get_mbr( p_geom );

  l_dim   := p_geom.get_dims;

  if p_geom.get_lrs_dim > 0 then
    l_dim := 2;
  end if;

  l_gtype := p_geom.get_gtype;


  IF l_gtype = 1 THEN
    IF p_geom.sdo_elem_info IS NOT NULL THEN

  -- Task 0108546
  -- No longer used
  --      l_geom := strip_user_parts( p_geom );


      RETURN mdsys.sdo_geometry( 3001, p_geom.sdo_srid, mdsys.sdo_point_type( p_geom.sdo_ordinates(1), p_geom.sdo_ordinates(2), def_pt_zoom),
         NULL, NULL);
    ELSE
      l_point := p_geom.sdo_point;

      l_point.z := def_pt_zoom;

      RETURN mdsys.sdo_geometry( 3001, p_geom.sdo_srid, l_point, NULL, NULL);
    END IF;

  ELSE

    l_x := (l_mbr.sdo_ordinates(1) + l_mbr.sdo_ordinates(1+l_dim))/2;
    l_y := (l_mbr.sdo_ordinates(2) + l_mbr.sdo_ordinates(2+l_dim))/2;

    l_m := GREATEST ( ABS( l_mbr.sdo_ordinates(1+l_dim) - l_mbr.sdo_ordinates(1)),
                      ABS( l_mbr.sdo_ordinates(2+l_dim) - l_mbr.sdo_ordinates(2)) );

    IF l_m < 1.0E-12 THEN

      l_m := def_pt_zoom;

    END IF;

    l_m := l_m * 1.05;

    RETURN mdsys.sdo_geometry( 3001, l_mbr.sdo_srid, mdsys.sdo_point_type( l_x, l_y, l_m), NULL, NULL);
  END IF;

END;

-----------------------------------------------------------------------------------------------


FUNCTION get_centre_and_size( p_theme IN NUMBER, p_pk_id IN NUMBER ) RETURN mdsys.sdo_geometry IS
l_geom mdsys.sdo_geometry;
l_mbr  mdsys.sdo_geometry;

BEGIN
  l_geom := get_theme_shape( p_theme, p_pk_id );

  RETURN get_centre_and_size( l_geom );

END;

-----------------------------------------------------------------------------------------------

FUNCTION get_gdo_centre_and_size ( p_session_id IN NUMBER ) RETURN mdsys.sdo_geometry IS

cur_string Nm3type.max_varchar2;

l_x    NUMBER;
l_y    NUMBER;
l_m    NUMBER;

l_mbr  mdsys.sdo_geometry;

l_dim    NUMBER;
l_gtype  NUMBER;

l_dynamic BOOLEAN;

l_gdo     GIS_DATA_OBJECTS%ROWTYPE;
nth       NM_THEMES_ALL%ROWTYPE;

BEGIN

  SELECT * INTO l_gdo FROM GIS_DATA_OBJECTS
  WHERE gdo_session_id = p_session_id
  AND ROWNUM = 1;

  IF l_gdo.gdo_dynamic_theme = 'Y' THEN

    l_dynamic := TRUE;

  ELSE

    l_dynamic := FALSE;

  END IF;


   IF l_dynamic THEN

     cur_string := 'select sdo_aggr_mbr( nmg_geometry ) '||
                'from nm_mrg_geometry, gis_data_objects '||
       'where gdo_session_id = :session_id '||
       'and nmg_job_id = gdo_pk_id';

   ELSE

     nth := Nm3get.get_nth( Higgis.get_theme_id( l_gdo.gdo_theme_name) );

     cur_string := 'select sdo_aggr_mbr( '||nth.nth_feature_shape_column||' ) from '||nth.nth_feature_table||','||
                   ' gis_data_objects gdo where gdo_session_id = :session_id '||
                   ' and gdo_pk_id = '||nth.nth_feature_pk_column;

   END IF;

   EXECUTE IMMEDIATE cur_string INTO l_mbr USING p_session_id;

--   Nm_Debug.debug_on;
--   Nm_Debug.DEBUG( cur_string||' using '||TO_CHAR( p_session_id ));

--   Nm_Debug.DEBUG( 'mbr - gtype = '||TO_CHAR(l_mbr.sdo_gtype ));

   IF l_mbr.sdo_gtype IS NOT NULL THEN


      RETURN get_centre_and_size( l_mbr );


    ELSE

      RAISE NO_DATA_FOUND;

    END IF;

END;


--
-----------------------------------------------------------------------------------------------
--

PROCEDURE get_point_coordinates
            ( p_geom  IN MDSYS.SDO_GEOMETRY
            , p_x    OUT NUMBER
            , p_y    OUT NUMBER
            , p_m    OUT NUMBER ) IS

l_geom mdsys.sdo_geometry;

BEGIN

  IF get_type_from_gtype( p_geom.sdo_gtype ) != 1 THEN
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                    ,pi_id                 => 288
                    ,pi_sqlcode            => -20001
                    );
--    RAISE_APPLICATION_ERROR(-20001, 'Not a point geometry');
  ELSIF p_geom.sdo_point.x IS NULL THEN
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                    ,pi_id                 => 289
                    ,pi_sqlcode            => -20001
                    );
--    RAISE_APPLICATION_ERROR(-20002, 'Use sdo_point');
  ELSE
    p_x := p_geom.sdo_point.x;
    p_y := p_geom.sdo_point.y;
    p_m := p_geom.sdo_point.z;
  END IF;
END;

--
-----------------------------------------------------------------------------------------------
--



PROCEDURE get_geometry_array( p_geom IN mdsys.sdo_geometry, p_x OUT Nm3type.tab_number,
                                                            p_y OUT Nm3type.tab_number,
                                                            p_m OUT Nm3type.tab_number ) IS
CURSOR c1( c_geom IN mdsys.sdo_geometry) IS
  SELECT t.x, t.y, t.z
  FROM TABLE ( sdo_util.getvertices(c_geom)) t;

BEGIN
  OPEN c1( p_geom );
  FETCH c1 BULK COLLECT INTO p_x, p_y, p_m;
  CLOSE c1;

END;

--
-----------------------------------------------------------------------------------------------
--

PROCEDURE get_theme_pt_coords ( p_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE,
                                p_pk_id IN GIS_DATA_OBJECTS.gdo_pk_id%TYPE,
        p_x OUT NUMBER, p_y OUT NUMBER, p_z OUT NUMBER) IS

BEGIN


  get_point_coordinates( get_2d_pt(get_theme_shape( p_theme_id, p_pk_id )), p_x, p_y, p_z);


END;
--
-----------------------------------------------------------------------------------------------
--


FUNCTION get_theme_shape( p_theme_id IN NUMBER, p_pk_id IN NUMBER ) RETURN mdsys.sdo_geometry IS

-- this assumes that only one shape exists in the theme table for the PK value. If dates are used and the theme
-- should be a date-tracked view else there will be difficulties.

cur_string VARCHAR2(2000);

nth_rec NM_THEMES_ALL%ROWTYPE := Nm3get.get_nth( p_theme_id );

retval mdsys.sdo_geometry;

BEGIN

  cur_string := 'select '||nth_rec.nth_feature_shape_column||' from '||nth_rec.nth_feature_table||
                ' where '||nth_rec.nth_feature_pk_column||' = :PK_VAL';

  EXECUTE IMMEDIATE cur_string INTO retval USING p_pk_id;

  RETURN retval;

END;
--
--------------------------------------------------------------------------------------
--

FUNCTION get_theme_shape( p_theme_name IN VARCHAR2, p_pk_id IN NUMBER ) RETURN mdsys.sdo_geometry IS

-- this assumes that only one shape exists in the theme table for the PK value. If dates are used and the theme
-- should be a date-tracked view else there will be difficulties.

cur_string VARCHAR2(2000);

nth_rec NM_THEMES_ALL%ROWTYPE := Nm3get.get_nth( p_theme_name );

retval mdsys.sdo_geometry;

BEGIN

  cur_string := 'select '||nth_rec.nth_feature_shape_column||' from '||nth_rec.nth_feature_table||
                ' where '||nth_rec.nth_feature_pk_column||' = :PK_VAL';

  EXECUTE IMMEDIATE cur_string INTO retval USING p_pk_id;

  RETURN retval;

END;

---------------------------------------------------------------------------------------------

FUNCTION Get_Theme_Diminfo ( p_nth_id IN NUMBER ) RETURN mdsys.sdo_dim_array IS

CURSOR c1( c_nth_id IN NUMBER ) IS
  SELECT sdo_diminfo
  FROM NM_THEMES_ALL, mdsys.sdo_geom_metadata_table
  WHERE nth_feature_table = sdo_table_name
  AND   nth_feature_shape_column = sdo_column_name
  AND   sdo_owner = Hig.get_application_owner
  AND   nth_theme_id = c_nth_id;

retval mdsys.sdo_dim_array;

BEGIN
  OPEN c1( p_nth_id );
  FETCH c1 INTO retval;
  CLOSE c1;

  RETURN retval;

END;

--
--------------------------------------------------------------------------------------
--

FUNCTION get_dimension ( p_diminfo IN mdsys.sdo_dim_array ) RETURN NUMBER IS
BEGIN
  RETURN p_diminfo.LAST;
END;
--

--
--------------------------------------------------------------------------------------
--
FUNCTION get_theme_metadata ( p_nth_id IN NUMBER ) RETURN user_sdo_geom_metadata%ROWTYPE IS

CURSOR c1( c_nth_id IN NUMBER ) IS
  SELECT m.*
  FROM NM_THEMES_ALL, mdsys.sdo_geom_metadata_table m
  WHERE nth_feature_table = sdo_table_name
  AND   nth_feature_shape_column = sdo_column_name
  AND   sdo_owner = Hig.get_application_owner
  AND   nth_theme_id = c_nth_id;

-- AE
-- Task 0108674 - Add MDSYS prefix
dummy  mdsys.sdo_geom_metadata_table%ROWTYPE; -- assumes synonym exists

retval user_sdo_geom_metadata%ROWTYPE;

BEGIN
  OPEN c1( p_nth_id );
  FETCH c1 INTO dummy;
  CLOSE c1;

  retval.table_name := dummy.sdo_table_name;
  retval.column_name := dummy.sdo_column_name;
  retval.diminfo := dummy.sdo_diminfo;
  retval.srid := dummy.sdo_srid;

  RETURN retval;

END;

--
--------------------------------------------------------------------------------------
--
FUNCTION get_theme_gtype ( p_nth_id IN NUMBER ) RETURN NUMBER IS
--
/*
cursor c1( c_nth_id in number ) is
  select ntg_gtype from nm_theme_gtypes
  where ntg_theme_id  = c_nth_id
  order by ntg_seq_no;
*/
--
  l_nth    NM_THEMES_ALL%ROWTYPE := Nm3get.get_nth( p_nth_id );
  retval   NUMBER;
--
  FUNCTION get_gtype_from_theme
    RETURN NUMBER
  IS
    l_retval NUMBER;
  BEGIN
    SELECT ntg_gtype
      INTO l_retval
      FROM NM_THEME_GTYPES
     WHERE ntg_theme_id = p_nth_id
       AND ROWNUM = 1;
    RETURN l_retval;
  EXCEPTION
    WHEN OTHERS
      THEN RETURN NULL;
  END get_gtype_from_theme;
--
BEGIN
--
  IF  l_nth.nth_feature_table        IS NOT NULL
  AND l_nth.nth_feature_shape_column IS NOT NULL
  THEN

    retval := get_gtype_from_theme;

    IF retval IS NULL THEN
      retval := get_table_gtype( l_nth.nth_feature_table, l_nth.nth_feature_shape_column);
    END IF;
/*

    IF retval IS NULL
    THEN
      RETURN get_gtype_from_theme;
    ELSE
      RETURN retval;
    END IF;
*/
    RETURN retval;

  ELSE

     Hig.raise_ner(pi_appl                => Nm3type.c_hig
                   ,pi_id                 => 233
                   ,pi_sqlcode            => -20001
                    );
--     raise_application_error( -20001, 'No theme data available to determine gtype');

  END IF;

END;

--
--------------------------------------------------------------------------------------
--
FUNCTION get_theme_gtype_text ( p_nth_id IN NUMBER ) RETURN VARCHAR2 IS

/*
cursor c1( c_nth_id in number ) is
  select ntg_gtype from nm_theme_gtypes
  where ntg_theme_id  = c_nth_id
  order by ntg_seq_no;
*/

l_nth NM_THEMES_ALL%ROWTYPE := Nm3get.get_nth( p_nth_id );

l_type NUMBER;

BEGIN

  IF l_nth.nth_feature_table IS NOT NULL AND l_nth.nth_feature_shape_column IS NOT NULL THEN

     -- AE
     -- Ignore error raised by get_table_gtype - because get_theme_gtype_text is used in
     -- a SQL statement to build up layer list for Mapviewer, we need this to carry on,
     -- even though there is a problem with a particular feature table - otherwise
     -- Mapviewer fails to draw anything.
     BEGIN
       l_type := get_theme_gtype( p_nth_id );
       IF l_type IS NULL THEN
         l_type := get_table_gtype( l_nth.nth_feature_table, l_nth.nth_feature_shape_column);
       END IF;
     EXCEPTION
       WHEN OTHERS
       THEN RETURN 'UNKNOWN';
     END;

     l_type := MOD( MOD(l_type, 1000),100);

-- AE 21-APR-2009
-- Dont return MULTI% for multipart shapes so that Mapviewer can apply the styles
-- properly. TFL use multipart shapes for polygons and mapviewer doesnt style them

     IF l_type IN (1,5) THEN
       RETURN 'POINT';
     ELSIF l_type IN (2,6) THEN
       RETURN 'LINE' ;
     ELSIF l_type IN (3, 7) THEN
       RETURN 'POLYGON';
     ELSIF l_type = 4 THEN
       RETURN 'COLLECTION';

--     ELSIF l_type = 5 THEN
--       RETURN 'MULTIPOINT';
--     ELSIF l_type = 6 THEN
--       RETURN 'MULTILINE';
--     ELSIF l_type = 7 THEN
--       RETURN 'MULTIPOLYGON';

-- AE 21-APR-2009
-- Changes complete.

     ELSE
       RETURN 'UNKNOWN';

-- AE - we don't mind having empty tables, otherwise the whole layer
-- list fails in MSV. Return an unknown GTYPE description instead of
-- raising this error

--       Hig.raise_ner(pi_appl                => Nm3type.c_hig
--                    ,pi_id                 => 233
--                    ,pi_sqlcode            => -20001
--                    );

     END IF;

  ELSE

     Hig.raise_ner(pi_appl                => Nm3type.c_hig
                   ,pi_id                 => 233
                   ,pi_sqlcode            => -20001
                    );
--     raise_application_error( -20001, 'No theme data available to determine gtype');

  END IF;

END;


--
--------------------------------------------------------------------------------------
--

FUNCTION get_table_gtype( p_table IN VARCHAR2, p_column IN VARCHAR2, p_full_scan IN VARCHAR2 DEFAULT 'N') RETURN NUMBER IS

lstr  VARCHAR2(2000);

retval  NUMBER;

BEGIN

  IF p_full_scan = 'Y' THEN

    lstr := 'select max('||p_column||'.sdo_gtype) from '||p_table;

  ELSE

    lstr := 'select a.'||p_column||'.sdo_gtype from '||p_table||' a'||
            ' where rownum = 1';
  END IF;

  EXECUTE IMMEDIATE lstr INTO retval;

  RETURN retval;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END;


--
--------------------------------------------------------------------------------------
--

PROCEDURE register_sdo_table_as_theme ( p_table             IN VARCHAR2
                                      , p_theme_name        IN VARCHAR2
                                      , p_pk_col            IN VARCHAR2
                                      , p_fk_col            IN VARCHAR2
                                      , p_shape_col         IN VARCHAR2
                                      , p_tol                  NUMBER DEFAULT 0.005
                                      , p_cre_idx           IN VARCHAR2 DEFAULT 'N'
                                      , p_estimate_new_tol  IN VARCHAR2 DEFAULT 'N'
                                      , p_override_sdo_meta IN VARCHAR2 DEFAULT 'I'
                                      ) IS


nth NM_THEMES_ALL%ROWTYPE;

cur_string  VARCHAR2(2000);
l_mbr mdsys.sdo_geometry;
l_diminfo mdsys.sdo_dim_array;
l_geom    mdsys.sdo_geometry;
l_theme   NUMBER := Nm3seq.next_nth_theme_id_seq;
l_seq     VARCHAR2(30);

l_dim     NUMBER;
l_lrs_dim NUMBER;

l_gtype   NUMBER;

l_z_or_m  VARCHAR2(1) := 'M';

CURSOR c_pk_type( c_tab IN VARCHAR2, c_col IN VARCHAR2) IS
  SELECT data_length, data_precision, data_scale
  FROM USER_TAB_COLUMNS
  WHERE table_name = c_tab
  AND   column_name = c_col;

l_data_length    INTEGER;
l_data_precision INTEGER;
l_data_scale     INTEGER;

BEGIN

   nth.NTH_THEME_ID              := l_theme;
   nth.NTH_THEME_NAME            := p_theme_name;
   nth.NTH_TABLE_NAME            := p_table;
   nth.NTH_WHERE                 := NULL;
   nth.NTH_PK_COLUMN             := p_pk_col;
   nth.NTH_LABEL_COLUMN          := p_pk_col;
   nth.NTH_RSE_TABLE_NAME        := 'NM_ELEMENTS';
   nth.NTH_RSE_FK_COLUMN         := 'NE_ID';        -- not required
   nth.NTH_ST_CHAIN_COLUMN       := NULL;
   nth.NTH_END_CHAIN_COLUMN      := NULL;
   nth.NTH_X_COLUMN              := NULL;
   nth.NTH_Y_COLUMN              := NULL;
   nth.NTH_OFFSET_FIELD          := NULL;
   nth.NTH_FEATURE_TABLE         := p_table;
   nth.NTH_FEATURE_PK_COLUMN     := p_pk_col;
   nth.NTH_FEATURE_FK_COLUMN     := NULL; -- p_fk_col;   -- not needed
   nth.NTH_XSP_COLUMN            := NULL;
   nth.NTH_FEATURE_SHAPE_COLUMN  := p_shape_col;
   nth.NTH_HPR_PRODUCT           := 'NET';
   nth.NTH_LOCATION_UPDATABLE    := 'N';
   nth.NTH_THEME_TYPE            := 'SDO';
-- nth.NTH_BASE_THEME            := NULL;
   nth.NTH_DEPENDENCY            := 'I';
   nth.NTH_STORAGE               := 'S';
   nth.NTH_UPDATE_ON_EDIT        := 'N';
   nth.NTH_USE_HISTORY           := 'N';
   nth.NTH_LREF_MANDATORY        := 'N';
   nth.NTH_TOLERANCE             := 10;
   nth.NTH_TOL_UNITS             := 1;


   Nm3ins.ins_nth( nth );

   register_table( p_table, p_shape_col, p_cre_idx, p_tol, p_estimate_new_tol, p_override_sdo_meta);

   IF use_surrogate_key = 'Y' THEN
     l_seq := create_spatial_seq( l_theme );

     IF Hig.get_sysopt('REGSDELAY') = 'Y' THEN

       OPEN c_pk_type( p_table, p_pk_col );

       FETCH c_pk_type INTO l_data_length, l_data_precision, l_data_scale;

       IF c_pk_type%NOTFOUND OR
          l_data_length != 22 OR l_data_precision != 38 OR l_data_scale != 0 THEN

          CLOSE c_pk_type;

          Hig.raise_ner(pi_appl                => Nm3type.c_hig
                        ,pi_id                 => 234
                        ,pi_sqlcode            => -20001
                         );

--          raise_application_error(-20001, 'No suitable PK column for SDE registration' );

       END IF;

       CLOSE c_pk_type;

       IF Hig.get_sysopt('REGSDELAY') = 'Y' THEN

         EXECUTE IMMEDIATE   ' begin  '||
                             '    nm3sde.register_sde_layer ( p_theme_id => :b_nth_id);'||
                             ' end;' USING nth.nth_theme_id;
       END IF;


     END IF;
   END IF;

END;
--
--------------------------------------------------------------------------------------------------------------
--
PROCEDURE register_sdo_table_as_theme ( p_table IN VARCHAR2
                                                              , p_pk_col IN VARCHAR2
                                                              , p_fk_col IN VARCHAR2
                                                              , p_shape_col IN VARCHAR2
                                                              , p_tol NUMBER DEFAULT 0.005
                                                              ,p_cre_idx IN VARCHAR2 DEFAULT 'N'
                                                              ,p_estimate_new_tol IN VARCHAR2 DEFAULT 'N'
                                                              ,p_override_sdo_meta IN VARCHAR2 DEFAULT 'I'
                                                              ) IS
BEGIN
 register_sdo_table_as_theme ( p_table => p_table
                                             , p_theme_name => p_table
                                             , p_pk_col => p_pk_col
                                             , p_fk_col => p_fk_col
                                             , p_shape_col => p_shape_col
                                             , p_tol => p_tol
                                             ,p_cre_idx => p_cre_idx
                                             ,p_estimate_new_tol => p_estimate_new_tol
                                             ,p_override_sdo_meta => p_override_sdo_meta
                                              );
END;
--
--------------------------------------------------------------------------------------------------------------
--
FUNCTION is_table_regd ( p_feature_table IN VARCHAR2, p_col IN VARCHAR2 ) RETURN BOOLEAN IS

l_dummy NUMBER;

BEGIN

  SELECT 1 INTO l_dummy FROM mdsys.sdo_geom_metadata_table
  WHERE sdo_table_name = p_feature_table
  AND sdo_column_name = p_col
  AND sdo_owner = Hig.get_application_owner;

  RETURN TRUE;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN FALSE;
  WHEN TOO_MANY_ROWS THEN
    RETURN TRUE;
  WHEN OTHERS THEN
    RAISE;
END;

--
--------------------------------------------------------------------------------------------------------------
--

FUNCTION validate_theme ( p_theme IN NUMBER, ex_table IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER IS

nth NM_THEMES_ALL%ROWTYPE := Nm3get.get_nth( p_theme );
retval NUMBER;
l_ex_table VARCHAR2(30);

BEGIN

  l_ex_table := ex_table;

  IF ex_table IS NULL THEN
    l_ex_table := SUBSTR(nth.nth_feature_table, 1, 27)||'_EX';
    EXECUTE IMMEDIATE 'create table '||l_ex_table||' ( sdo_rowid ROWID, result varchar2(1000))';

  END IF;

  sdo_geom.validate_layer_with_context( nth.nth_feature_table, nth.nth_feature_shape_column, l_ex_table );

  EXECUTE IMMEDIATE 'select count(*) from '||l_ex_table INTO retval;

--This utility posts a comment on the number of rows processed.

  RETURN retval - 1;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0;
END;

--
--------------------------------------------------------------------------------------------------------------
--

FUNCTION get_shape_from_gdo ( p_session_id IN NUMBER ) RETURN mdsys.sdo_geometry IS


nth NM_THEMES_ALL%ROWTYPE;

CURSOR c1 (c_session_id IN NUMBER ) IS
  SELECT gdo_theme_name, gdo_x_val, gdo_y_val, gdo_pk_id
  FROM GIS_DATA_OBJECTS
  WHERE gdo_session_id = c_session_id
  ORDER BY gdo_seq_no;

l_count INTEGER := 0;
l_nth_name NM_THEMES_ALL.nth_theme_name%TYPE;

l_old_shape mdsys.sdo_geometry;
l_new_shape mdsys.sdo_geometry;

l_tab_theme Nm3type.tab_varchar30;

l_tab_x  Nm3type.tab_number;
l_tab_y  Nm3type.tab_number;
l_tab_pk Nm3type.tab_number;
l_tab_m  Nm3type.tab_number;

l_ord    mdsys.sdo_ordinate_array := mdsys.sdo_ordinate_array(NULL);

l_start  NUMBER;
l_end    NUMBER;

BEGIN

  OPEN c1 ( p_session_id );

  FETCH c1 BULK COLLECT INTO l_tab_theme, l_tab_x, l_tab_y, l_tab_pk;

  CLOSE c1;

  l_nth_name := l_tab_theme(1);

  nth := Nm3get.get_nth( l_nth_name );

  l_old_shape := Nm3sdo.get_theme_shape(nth.nth_theme_id, l_tab_pk(1) );


  IF l_old_shape.sdo_gtype = 1002 THEN


     IF l_old_shape.sdo_elem_info IS NULL THEN


        l_new_shape := mdsys.sdo_geometry( l_old_shape.sdo_gtype,
                                           l_old_shape.sdo_srid,
                                           mdsys.sdo_point_type( l_tab_x(1), l_tab_y(1), NULL),
                                           NULL, NULL );

      ELSE

        l_new_shape := mdsys.sdo_geometry( l_old_shape.sdo_gtype,
                                           l_old_shape.sdo_srid,
                                           NULL, mdsys.sdo_elem_info_array( 1, 1002, 1),
                                           mdsys.sdo_ordinate_array( l_tab_x(1), l_tab_y(1)));
      END IF;

  ELSIF l_old_shape.sdo_gtype = 1003 THEN

     IF l_old_shape.sdo_elem_info IS NULL THEN


        l_new_shape := mdsys.sdo_geometry( l_old_shape.sdo_gtype,
                                           l_old_shape.sdo_srid,
                                           mdsys.sdo_point_type( l_tab_x(1), l_tab_y(1), l_old_shape.sdo_point.z),
                                           NULL, NULL );

      ELSE

        l_new_shape := mdsys.sdo_geometry( l_old_shape.sdo_gtype,
                                           l_old_shape.sdo_srid,
                                           NULL, mdsys.sdo_elem_info_array( 1, 1002, 1),
                                           mdsys.sdo_ordinate_array( l_tab_x(1), l_tab_y(1), l_old_shape.sdo_ordinates( l_old_shape.sdo_ordinates.LAST)));
      END IF;


  ELSIF l_old_shape.sdo_gtype IN (2002, 2003, 3002, 3003 ) THEN


    FOR irec IN 1..l_tab_x.COUNT LOOP

      IF irec  > 1 THEN

         IF l_tab_theme(irec) != l_nth_name OR
            l_tab_theme(irec) IS NULL THEN

            Hig.raise_ner(pi_appl                => Nm3type.c_hig
                              ,pi_id                 => 235
                              ,pi_sqlcode            => -20001
                               );

--            raise_application_error( -20001, 'Theme must be consistent for the same session');

         END IF;

         l_ord.EXTEND;
         l_ord(l_ord.LAST) := l_tab_x(irec);

      ELSE

         l_ord(l_ord.LAST) := l_tab_x(irec);

      END IF;

      l_ord.EXTEND;
      l_ord(l_ord.LAST) := l_tab_y(irec);

    END LOOP;


    IF l_old_shape.sdo_gtype IN (2002, 2003) THEN

       l_new_shape := mdsys.sdo_geometry( l_old_shape.sdo_gtype,
                                          l_old_shape.sdo_srid,
                                          NULL, mdsys.sdo_elem_info_array( 1, 2, 1),
                                          l_ord);
    ELSIF l_old_shape.sdo_gtype = 3002 THEN

       l_new_shape := mdsys.sdo_geometry( 2002,
                                          l_old_shape.sdo_srid,
                                          NULL, mdsys.sdo_elem_info_array( 1, 2, 1),
                                          l_ord);

       l_start := l_old_shape.sdo_ordinates(3);
       l_end   := l_old_shape.sdo_ordinates(l_old_shape.sdo_ordinates.LAST);

       l_new_shape := sdo_lrs.convert_to_lrs_geom( l_new_shape, l_start, l_end );

    ELSIF l_old_shape.sdo_gtype = 3003 THEN

       l_new_shape := mdsys.sdo_geometry( 2003,
                                          l_old_shape.sdo_srid,
                                          NULL, mdsys.sdo_elem_info_array( 1, 2, 1),
                                          l_ord);

       l_start := l_old_shape.sdo_ordinates(3);
       l_end   := l_old_shape.sdo_ordinates(l_old_shape.sdo_ordinates.LAST);

       l_new_shape := sdo_lrs.convert_to_lrs_geom( l_new_shape, l_start, l_end );

    ELSE

       Hig.raise_ner(pi_appl                => Nm3type.c_hig
                     ,pi_id                 => 236
                     ,pi_sqlcode            => -20001
                      );
--       raise_application_error( -20002, 'Unknown geometry');

    END IF;

  END IF;

  RETURN l_new_shape;

END;

--
--------------------------------------------------------------------------------------------------------------
--

PROCEDURE update_shape_from_gdo ( p_session_id IN NUMBER ) IS


nth NM_THEMES_ALL%ROWTYPE;

CURSOR c1 (c_session_id IN NUMBER ) IS
  SELECT gdo_theme_name, gdo_x_val, gdo_y_val, gdo_pk_id
  FROM GIS_DATA_OBJECTS
  WHERE gdo_session_id = c_session_id
  ORDER BY gdo_seq_no;

l_count INTEGER := 0;
l_nth_name NM_THEMES_ALL.nth_theme_name%TYPE;

l_old_shape mdsys.sdo_geometry;
l_new_shape mdsys.sdo_geometry;

l_tab_theme Nm3type.tab_varchar30;

l_tab_x  Nm3type.tab_number;
l_tab_y  Nm3type.tab_number;
l_tab_pk Nm3type.tab_number;
l_tab_m  Nm3type.tab_number;

l_ord    mdsys.sdo_ordinate_array := mdsys.sdo_ordinate_array(NULL);

l_start  NUMBER;
l_end    NUMBER;

BEGIN

  OPEN c1 ( p_session_id );

  FETCH c1 BULK COLLECT INTO l_tab_theme, l_tab_x, l_tab_y, l_tab_pk;

  CLOSE c1;

  l_nth_name := l_tab_theme(1);

  nth := Nm3get.get_nth( l_nth_name );

  l_old_shape := Nm3sdo.get_theme_shape(nth.nth_theme_id, l_tab_pk(1) );


  IF l_old_shape.sdo_gtype = 1002 THEN


     IF l_old_shape.sdo_elem_info IS NULL THEN


        l_new_shape := mdsys.sdo_geometry( l_old_shape.sdo_gtype,
                                           l_old_shape.sdo_srid,
                                           mdsys.sdo_point_type( l_tab_x(1), l_tab_y(1), NULL),
                                           NULL, NULL );

      ELSE

        l_new_shape := mdsys.sdo_geometry( l_old_shape.sdo_gtype,
                                           l_old_shape.sdo_srid,
                                           NULL, mdsys.sdo_elem_info_array( 1, 1002, 1),
                                           mdsys.sdo_ordinate_array( l_tab_x(1), l_tab_y(1)));
      END IF;

  ELSIF l_old_shape.sdo_gtype = 1003 THEN

     IF l_old_shape.sdo_elem_info IS NULL THEN


        l_new_shape := mdsys.sdo_geometry( l_old_shape.sdo_gtype,
                                           l_old_shape.sdo_srid,
                                           mdsys.sdo_point_type( l_tab_x(1), l_tab_y(1), l_old_shape.sdo_point.z),
                                           NULL, NULL );

      ELSE

        l_new_shape := mdsys.sdo_geometry( l_old_shape.sdo_gtype,
                                           l_old_shape.sdo_srid,
                                           NULL, mdsys.sdo_elem_info_array( 1, 1002, 1),
                                           mdsys.sdo_ordinate_array( l_tab_x(1), l_tab_y(1), l_old_shape.sdo_ordinates( l_old_shape.sdo_ordinates.LAST)));
      END IF;


  ELSIF l_old_shape.sdo_gtype IN (2002, 2003, 3002, 3003 ) THEN


    FOR irec IN 1..l_tab_x.COUNT LOOP

      IF irec  > 1 THEN

         IF l_tab_theme(irec) != l_nth_name OR
            l_tab_theme(irec) IS NULL THEN

            Hig.raise_ner(pi_appl                => Nm3type.c_hig
                         ,pi_id                 => 235
                         ,pi_sqlcode            => -20001
                    );
--            raise_application_error( -20001, 'Theme must be consistent for the same session');

         END IF;

         l_ord.EXTEND;
         l_ord(l_ord.LAST) := l_tab_x(irec);

      ELSE

         l_ord(l_ord.LAST) := l_tab_x(irec);

      END IF;

      l_ord.EXTEND;
      l_ord(l_ord.LAST) := l_tab_y(irec);

    END LOOP;


    IF l_old_shape.sdo_gtype IN (2002, 2003) THEN

       l_new_shape := mdsys.sdo_geometry( l_old_shape.sdo_gtype,
                                          l_old_shape.sdo_srid,
                                          NULL, mdsys.sdo_elem_info_array( 1, 2, 1),
                                          l_ord);
    ELSIF l_old_shape.sdo_gtype = 3002 THEN

       l_new_shape := mdsys.sdo_geometry( 2002,
                                          l_old_shape.sdo_srid,
                                          NULL, mdsys.sdo_elem_info_array( 1, 2, 1),
                                          l_ord);

       l_start := l_old_shape.sdo_ordinates(3);
       l_end   := l_old_shape.sdo_ordinates(l_old_shape.sdo_ordinates.LAST);

       l_new_shape := sdo_lrs.convert_to_lrs_geom( l_new_shape, l_start, l_end );

    ELSIF l_old_shape.sdo_gtype = 3003 THEN

       l_new_shape := mdsys.sdo_geometry( 2003,
                                          l_old_shape.sdo_srid,
                                          NULL, mdsys.sdo_elem_info_array( 1, 2, 1),
                                          l_ord);

       l_start := l_old_shape.sdo_ordinates(3);
       l_end   := l_old_shape.sdo_ordinates(l_old_shape.sdo_ordinates.LAST);

       l_new_shape := sdo_lrs.convert_to_lrs_geom( l_new_shape, l_start, l_end );

    ELSE

       Hig.raise_ner(pi_appl                => Nm3type.c_hig
                     ,pi_id                 => 236
                     ,pi_sqlcode            => -20001
                      );
--     raise_application_error( -20002, 'Unknown geometry');

    END IF;

  END IF;

  EXECUTE IMMEDIATE 'update '||nth.nth_feature_table||
                    ' set '||nth.nth_feature_shape_column||' = :l_new_shape '||
                    ' where '||nth.nth_pk_column||' = :pk_id'
  USING l_new_shape, l_tab_pk(1);

END;

--
--------------------------------------------------------------------------------------------------------------
--

FUNCTION get_table_mbr ( p_table IN VARCHAR2,
                         p_column IN VARCHAR2 ) RETURN mdsys.sdo_geometry AS

l_diminfo mdsys.sdo_dim_array;

CURSOR c1(c_tab IN VARCHAR2, c_col IN VARCHAR2)  IS
  SELECT  diminfo
  FROM user_sdo_geom_metadata
  WHERE table_name = c_tab
  AND column_name = c_col;

retval mdsys.sdo_geometry;

BEGIN
/*
  OPEN c1(p_table, p_column);
  FETCH c1 INTO l_diminfo;

  IF c1%NOTFOUND THEN
    Hig.raise_ner(pi_appl                => Nm3type.c_hig
                 ,pi_id                 => 237
                 ,pi_sqlcode            => -20001
                    );
--    raise_application_error(-20001, 'Dimension not available' );
    CLOSE c1;
  END IF;
  CLOSE c1;
*/
  l_diminfo := get_table_diminfo(p_table, p_column);

  IF l_diminfo(3).sdo_lb IS NOT NULL THEN
      retval := mdsys.sdo_geometry( 3003, NULL, NULL, mdsys.sdo_elem_info_array( 1,3,3),
                        mdsys.sdo_ordinate_array( l_diminfo(1).sdo_lb, l_diminfo(2).sdo_lb, l_diminfo(3).sdo_lb,
                                       l_diminfo(1).sdo_ub, l_diminfo(2).sdo_ub, l_diminfo(3).sdo_ub ));
  ELSE

      retval := mdsys.sdo_geometry( 2003, NULL, NULL, mdsys.sdo_elem_info_array( 1,3,3),
                      mdsys.sdo_ordinate_array( l_diminfo(1).sdo_lb,l_diminfo(2).sdo_lb, l_diminfo(1).sdo_ub,l_diminfo(2).sdo_ub ));

  END IF;

  RETURN retval;

EXCEPTION
  WHEN SUBSCRIPT_BEYOND_COUNT THEN
    retval := mdsys.sdo_geometry( 2003, NULL, NULL, mdsys.sdo_elem_info_array( 1,3,3),
                      mdsys.sdo_ordinate_array( l_diminfo(1).sdo_lb,l_diminfo(2).sdo_lb, l_diminfo(1).sdo_ub,l_diminfo(2).sdo_ub ));

      RETURN retval;

END;

--
--------------------------------------------------------------------------------------------------------------
--

FUNCTION calculate_table_diminfo ( p_table IN VARCHAR2, p_column IN VARCHAR2,
                                   p_tol IN NUMBER DEFAULT 0.005, p_estimate_new_tol VARCHAR2 DEFAULT 'N' ) RETURN mdsys.sdo_dim_array IS


-- leave it to the user to set - will fail to generate index with redundant pts
-- so remove them or set a smaller tolerance value.

retval mdsys.sdo_dim_array;

l_gtype   NUMBER;
l_dim     NUMBER;
l_lrs_dim NUMBER;

l_mbr     mdsys.sdo_geometry;

l_tol_array num_array_type;
l_tol       NUMBER;

l_z_or_m  VARCHAR2(1) := 'M';

curstring VARCHAR2(100);


BEGIN

--Nm_Debug.debug_on;

  begin
    curstring := 'select sdo_aggr_mbr('||p_column||') from '||p_table;
    EXECUTE IMMEDIATE curstring INTO l_mbr;
  exception
    when     subscript_beyond_count then
      raise_application_error( -20006, 'Error in MBR calculation - check the gtypes are consistent');
    when no_data_found then
      raise_application_error( -20001, 'No data in table - cannot calculate the diminfo');
  end;

  if l_mbr is null then
    raise_application_error( -20001, 'No MBR calculated - cannot calculate the diminfo');
  end if;

--Nm_Debug.DEBUG( curstring );

  l_gtype := get_table_gtype( p_table, p_column );

  l_dim := get_dim_from_gtype( l_gtype );

  l_lrs_dim := get_lrs_from_gtype( l_gtype );

  IF l_dim < 2 OR l_dim > 4 THEN
    Hig.raise_ner(pi_appl                => Nm3type.c_hig
                 ,pi_id                 => 238
                 ,pi_sqlcode            => -20001
                    );
--    raise_application_error( -20001, 'Invalid dimension - must be between 2 and 4');
  END IF;

  IF l_lrs_dim > 0 THEN

    l_z_or_m := 'M';

  ELSE

    l_z_or_m := 'Z';

  END IF;

  l_tol := NVL( p_tol, 0.005);

  IF p_estimate_new_tol = 'Y' THEN

    IF get_type_from_gtype( l_gtype ) > 1 THEN
      l_tol_array := get_sample_tolerance( p_table, p_column );
    ELSE
      l_tol_array := num_array_type( l_tol, l_tol, l_tol, l_tol );
    END IF;

  ELSE
--     only deal with dim <= 4

    l_tol_array := num_array_type( l_tol, l_tol, l_tol, l_tol );

  END IF;

  IF l_dim = 2 THEN

     retval := mdsys.sdo_dim_array(
               mdsys.sdo_dim_element( 'X', l_mbr.sdo_ordinates(1), l_mbr.sdo_ordinates(3), l_tol_array(1) ),
               mdsys.sdo_dim_element( 'Y', l_mbr.sdo_ordinates(2), l_mbr.sdo_ordinates(4), l_tol_array(2) ));

   ELSIF l_dim = 3 and l_lrs_dim = 0 THEN

     retval := mdsys.sdo_dim_array(
               mdsys.sdo_dim_element( 'X', l_mbr.sdo_ordinates(1), l_mbr.sdo_ordinates(4), l_tol_array(1) ),
               mdsys.sdo_dim_element( 'Y', l_mbr.sdo_ordinates(2), l_mbr.sdo_ordinates(5), l_tol_array(2) ),
               mdsys.sdo_dim_element( l_z_or_m, l_mbr.sdo_ordinates(3), l_mbr.sdo_ordinates(6), l_tol_array(3) ));

   ELSIF l_dim = 3 and l_lrs_dim = 3 THEN

--   the measure diminfo is not significant, no point attempting to fathom the largest ne_length - just add a big-ish number.

     retval := mdsys.sdo_dim_array(
               mdsys.sdo_dim_element( 'X', l_mbr.sdo_ordinates(1), l_mbr.sdo_ordinates(3), l_tol_array(1) ),
               mdsys.sdo_dim_element( 'Y', l_mbr.sdo_ordinates(2), l_mbr.sdo_ordinates(4), l_tol_array(2) ),
               mdsys.sdo_dim_element( l_z_or_m, 0, 999999999, l_tol_array(3) ));

   ELSIF l_mbr.get_dims = 4 THEN

     retval := mdsys.sdo_dim_array(
               mdsys.sdo_dim_element( 'X', l_mbr.sdo_ordinates(1), l_mbr.sdo_ordinates(4), l_tol_array(1) ),
               mdsys.sdo_dim_element( 'Y', l_mbr.sdo_ordinates(2), l_mbr.sdo_ordinates(5), l_tol_array(2) ),
               mdsys.sdo_dim_element( 'Z', l_mbr.sdo_ordinates(2), l_mbr.sdo_ordinates(5), l_tol_array(3) ),
               mdsys.sdo_dim_element( 'M', l_mbr.sdo_ordinates(3), l_mbr.sdo_ordinates(6), l_tol_array(4) ));

   ELSE

     raise_application_error( -20005, 'Unrecognised geometry type' );

   END IF;


  RETURN retval;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
     Hig.raise_ner(pi_appl                => Nm3type.c_hig
                   ,pi_id                 => 239
                   ,pi_sqlcode            => -20001
                    );
--     raise_application_error(-20001, 'No data to base diminfo calculation');
END;



--------------------------------------------------------------------------------------------------------------

FUNCTION create_spatial_extent ( p_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE,
                                 p_nsperow  NM_SPATIAL_EXTENTS%ROWTYPE,
                                 p_whole_flag IN VARCHAR2 DEFAULT 'Y' ) RETURN NUMBER IS

  nserow   NM_SAVED_EXTENTS%ROWTYPE;
  nsperow  NM_SPATIAL_EXTENTS%ROWTYPE;
  nthrow   NM_THEMES_ALL%ROWTYPE;

  lf     VARCHAR2(1) := CHR(13);

  cur_string Nm3type.max_varchar2;

BEGIN

   nthrow := Nm3get.get_nth( p_theme_id );

   nserow.nse_id := Nm3seq.next_nse_id_seq;
   nserow.nse_owner := USER;
   nserow.nse_name  := 'Spatial Extent '||TO_CHAR(nserow.nse_id)||' from '||TO_CHAR(p_nsperow.nspe_id);
   nserow.nse_descr := NULL;
   nserow.nse_pbi   := 'N';
   Nm3extent.ins_nse( nserow );

   IF p_whole_flag = 'Y' THEN
     cur_string := ' INSERT INTO NM_SAVED_EXTENT_MEMBERS ( '||lf||
       ' NSM_NSE_ID, NSM_ID, NSM_NE_ID,  '||lf||
       ' NSM_BEGIN_MP, NSM_END_MP, NSM_BEGIN_NO, '||lf||
       ' NSM_END_NO, NSM_BEGIN_SECT, NSM_BEGIN_SECT_OFFSET, '||lf||
       ' NSM_END_SECT, NSM_END_SECT_OFFSET, NSM_SEQ_NO, '||lf||
       ' NSM_DATUM, NSM_DATE_CREATED, NSM_DATE_MODIFIED, '||lf||
       ' NSM_CREATED_BY, NSM_MODIFIED_BY, NSM_SUB_CLASS, '||lf||
       ' NSM_SUB_CLASS_EXCL, NSM_RESTRICT_EXCL_SUB_CLASS) '||lf||
       ' select :nse_id, nsm_id_seq.nextval, s.ne_id, 0, nm3net.get_ne_length( s.ne_id ),'||lf||
       ' null, null, null, null, null, null, rownum,'||''''||'Y'||''''||','||lf||
    ' sysdate, sysdate, user, user, null, null, '||''''||'N'||''''||lf||
     ' from '||nthrow.nth_feature_table||'  s,  nm_spatial_extents '||lf||
     ' where nspe_id = :nspe_id '||
     ' and sdo_relate(  s.'||nthrow.nth_feature_shape_column||' , nspe_boundary, '||''''||'mask=INSIDE querytype=WINDOW'||''''||') = '||''''||'TRUE'||'''';


   ELSE

     cur_string := ' INSERT INTO NM_SAVED_EXTENT_MEMBERS ( '||lf||
       ' NSM_NSE_ID, NSM_ID, NSM_NE_ID,  '||lf||
       ' NSM_BEGIN_MP, NSM_END_MP, NSM_BEGIN_NO, '||lf||
       ' NSM_END_NO, NSM_BEGIN_SECT, NSM_BEGIN_SECT_OFFSET, '||lf||
       ' NSM_END_SECT, NSM_END_SECT_OFFSET, NSM_SEQ_NO, '||lf||
       ' NSM_DATUM, NSM_DATE_CREATED, NSM_DATE_MODIFIED, '||lf||
       ' NSM_CREATED_BY, NSM_MODIFIED_BY, NSM_SUB_CLASS, '||lf||
       ' NSM_SUB_CLASS_EXCL, NSM_RESTRICT_EXCL_SUB_CLASS) '||lf||
       ' select :nse_id, nsm_id_seq.nextval, s.ne_id, '||lf||
       ' sdo_lrs.geom_segment_start_measure(  sdo_geom.sdo_intersection( s.'||nthrow.nth_feature_shape_column||',nspe_boundary, .05)),'||lf||
       ' sdo_lrs.geom_segment_end_measure(  sdo_geom.sdo_intersection( s.'||nthrow.nth_feature_shape_column||',nspe_boundary, .05)),'||lf||
       ' null, null, null, null, null, null, rownum,'||''''||'Y'||''''||','||lf||
    ' sysdate, sysdate, user, user, null, null, '||''''||'N'||''''||lf||
     ' from '||nthrow.nth_feature_table||'  s,  nm_spatial_extents '||lf||
     ' where nspe_id = :nspe_id '||
     ' and sdo_relate(  s.'||nthrow.nth_feature_shape_column||' , nspe_boundary, '||''''||'mask=INSIDE+TOUCH querytype=WINDOW'||''''||') = '||''''||'TRUE'||'''';


   END IF;

--   nm_debug.debug_on;
--   nm_debug.debug( cur_string );
--   nm_debug.debug_off;
   EXECUTE IMMEDIATE cur_string
   USING nserow.nse_id, p_nsperow.nspe_id;

-- Only valid when members are datums - needs extraction of datums from generic member set - not enough time.

   INSERT INTO NM_SAVED_EXTENT_MEMBER_DATUMS
   (
     NSD_NSE_ID, NSD_NSM_ID, NSD_NE_ID,
     NSD_BEGIN_MP, NSD_END_MP, NSD_SEQ_NO,
     NSD_CARDINALITY)
   SELECT nsm_nse_id, nsm_id, nsm_ne_id,
     nsm_begin_mp, nsm_end_mp, nsm_seq_no,
     1
   FROM NM_SAVED_EXTENT_MEMBERS
   WHERE nsm_nse_id = nserow.nse_id;


   RETURN nserow.nse_id;

END ;

--
--------------------------------------------------------------------------------------------------------------
--
PROCEDURE Set_Srid ( p_table IN VARCHAR2, p_column IN VARCHAR2, p_srid IN NUMBER ) IS

l_srid VARCHAR2(10);
l_ind VARCHAR2(30) := NULL;

BEGIN

  BEGIN
    l_ind := get_spatial_index( p_table, p_column );
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
  END;

  IF l_ind IS NOT NULL THEN
    EXECUTE IMMEDIATE 'drop index '||l_ind;
  END IF;

  l_srid := NVL( TO_CHAR(p_srid), 'NULL' );

  EXECUTE IMMEDIATE 'update '||p_table||' a '||
         'set a.'||p_column||' = mdsys.sdo_geometry( a.'||p_column||'.sdo_gtype,'||
         ' '||l_srid||', a.'||p_column||'.sdo_point, a.'||p_column||'.sdo_elem_info, a.'||p_column||'.sdo_ordinates )';

  EXECUTE IMMEDIATE 'update mdsys.sdo_geom_metadata_table set sdo_srid = '||l_srid||' where sdo_table_name = '||
                    ''''||p_table||''''||' and sdo_column_name = '||''''||p_column||''''||
     ' and sdo_owner = '||''''||Hig.get_application_owner||'''';

--needs to use all users in hig_users table

  IF l_ind IS NOT NULL THEN
    EXECUTE IMMEDIATE 'create index '||l_ind||' on '||p_table||' ( '||p_column||' ) indextype is mdsys.spatial_index'||
                      ' parameters ('||''''||'sdo_indx_dims=2'||''''||')';
  END IF;

END;
--
--------------------------------------------------------------------------------------------------------------
--
FUNCTION get_spatial_index( p_table IN VARCHAR2, p_column IN VARCHAR2 ) RETURN VARCHAR2 IS

CURSOR c_ind ( c_table IN VARCHAR2, c_column IN VARCHAR2 ) IS
  SELECT i.index_name
  FROM USER_INDEXES i, USER_IND_COLUMNS c
  WHERE i.table_name = c_table
  AND i.index_name = c.index_name
  AND c.column_name = c_column
  AND i.ityp_owner='MDSYS'
  AND i.ityp_name = 'SPATIAL_INDEX';

retval VARCHAR2( 30);

BEGIN

  OPEN c_ind( p_table, p_column );
  FETCH c_ind INTO retval;
  CLOSE c_ind;

  RETURN retval;

EXCEPTION

  WHEN NO_DATA_FOUND THEN
    RETURN NULL;

END;
--
--------------------------------------------------------------------------------------------------------------
--
PROCEDURE re_project ( p_table IN VARCHAR2, p_column IN VARCHAR2, p_old_srid IN NUMBER, p_new_srid IN NUMBER ) IS

l_ind VARCHAR2(30) := NULL;
l_old_srid  NUMBER;

BEGIN

  BEGIN
    l_ind := get_spatial_index( p_table, p_column );
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
  END;

  IF l_ind IS NOT NULL THEN
    EXECUTE IMMEDIATE 'drop index '||l_ind;
  END IF;

  l_old_srid := Nm3sdo.get_table_srid( p_table, p_column);

  IF l_old_srid IS NULL THEN

    Set_Srid( p_table, p_column, p_old_srid );

  ELSIF l_old_srid != p_old_srid THEN

    Hig.raise_ner(pi_appl                => Nm3type.c_hig
                 ,pi_id                 => 240
                 ,pi_sqlcode            => -20001
                        );
--    raise_application_error( -20001, 'The SRID does not match - please reset the current SRID or use the correct value' );

  END IF;

  EXECUTE IMMEDIATE 'update '||p_table||' set '||p_column||'= sdo_cs.transform( '||p_column||', '||TO_CHAR(p_new_srid)||')';

  EXECUTE IMMEDIATE 'update mdsys.sdo_geom_metadata_table set sdo_srid = '||TO_CHAR(p_new_srid)||','||
                    ' sdo_diminfo =  nm3sdo.calculate_table_diminfo('||''''||p_table||''''||','||''''||p_column||''''||')'||
     ' where sdo_table_name = '||''''||p_table||''''||' and sdo_column_name = '||''''||p_column||''''||
     ' and sdo_owner = '||Hig.get_application_owner||'''';

/*
  EXECUTE IMMEDIATE 'update user_sdo_geom_metadata set diminfo = nm3sdo.calculate_table_diminfo('||''''||p_table||''''||','||''''||p_column||''''||')'||
                    ' where table_name = '||''''||p_table||''''||
                    ' and column_name = '||''''||p_column||'''';
*/
  IF l_ind IS NULL THEN
    l_ind := SUBSTR(p_table,1,24)||'_spidx';
  END IF;

  EXECUTE IMMEDIATE ' create index '||l_ind||' on '||p_table||' ( '||p_column||')'||
                    ' indextype is mdsys.spatial_index parameters ('||''''||'sdo_indx_dims = 2'||''''||')';

END;

--
--------------------------------------------------------------------------------------------------------------
--

FUNCTION get_polygon_from_gdo( p_session_id IN NUMBER ) RETURN mdsys.sdo_geometry IS

CURSOR c1 (c_session_id IN NUMBER ) IS
  SELECT gdo_theme_name, gdo_x_val, gdo_y_val
  FROM GIS_DATA_OBJECTS
  WHERE gdo_session_id = c_session_id
  ORDER BY gdo_seq_no;

l_count INTEGER := 0;

l_new_shape mdsys.sdo_geometry;

l_tab_theme Nm3type.tab_varchar30;

l_srid   NUMBER;

l_tab_x  Nm3type.tab_number;
l_tab_y  Nm3type.tab_number;
l_tab_pk Nm3type.tab_number;
l_tab_m  Nm3type.tab_number;

l_ord    mdsys.sdo_ordinate_array := mdsys.sdo_ordinate_array(NULL);

l_start  NUMBER;
l_end    NUMBER;

l_theme  NM_THEMES_ALL%ROWTYPE;

retval mdsys.sdo_geometry;

BEGIN

  OPEN c1 ( p_session_id );

  FETCH c1 BULK COLLECT INTO l_tab_theme, l_tab_x, l_tab_y;

  CLOSE c1;

  l_theme := Nm3get.get_nth( l_tab_theme(1));
  l_srid := Nm3sdo.get_theme_metadata( l_theme.nth_theme_id ).srid;


  FOR irec IN 1..l_tab_x.COUNT LOOP

    IF irec  > 1 THEN

       IF l_tab_theme(irec) != l_theme.nth_theme_name OR
          l_tab_theme(irec) IS NULL THEN

         Hig.raise_ner(pi_appl                => Nm3type.c_hig
                      ,pi_id                 => 235
                      ,pi_sqlcode            => -20001
                       );

--        raise_application_error( -20001, 'Theme must be consistent for the same session');

       END IF;

       l_ord.EXTEND;
       l_ord(l_ord.LAST) := l_tab_x(irec);

    ELSE

       l_ord(l_ord.LAST) := l_tab_x(irec);

    END IF;

    l_ord.EXTEND;
    l_ord(l_ord.LAST) := l_tab_y(irec);

  END LOOP;

  IF l_ord(l_ord.LAST ) != l_ord(2) OR
     l_ord(l_ord.LAST - 1) != l_ord(1) THEN

     l_ord.EXTEND;
     l_ord(l_ord.LAST) := l_ord(1);
     l_ord.EXTEND;
     l_ord(l_ord.LAST) := l_ord(2);
  END IF;


  retval := mdsys.sdo_geometry( 2003, l_srid, NULL, mdsys.sdo_elem_info_array( 1, 2003, 1), l_ord );

  RETURN retval;

END;

--
----------------------------------------------------------------------------------------------------------------------------------------
--
PROCEDURE create_spatial_idx ( p_table IN VARCHAR2, p_column IN VARCHAR2 DEFAULT 'GEOLOC' ) IS

cur_string VARCHAR2(2000);

BEGIN

  BEGIN
    EXECUTE IMMEDIATE 'alter session set sort_area_size = 20000000';
  EXCEPTION
    WHEN OTHERS THEN NULL;
  END;

  cur_string := 'create index '||SUBSTR( p_table, 1, 24)||'_spidx on '||p_table||' ( '||p_column||' ) indextype is mdsys.spatial_index'||
                ' parameters ('||''''||'sdo_indx_dims=2'||''''||')';

  EXECUTE IMMEDIATE cur_string;

END;

----------------------------------------------------------------------------------------------------------------------------------------
--
PROCEDURE create_qtree_idx ( p_table IN VARCHAR2, p_column IN VARCHAR2 DEFAULT 'GEOLOC' ) IS

cur_string VARCHAR2(2000);
num_tiles  varchar2(10) := nvl(hig.get_sysopt('SDOQTTILES'), 6);

BEGIN

  BEGIN
    EXECUTE IMMEDIATE 'alter session set sort_area_size = 20000000';
  EXCEPTION
    WHEN OTHERS THEN NULL;
  END;


  cur_string := 'create index '||SUBSTR( p_table, 1, 24)||'_qtidx on '||p_table||' ( '||p_column||' ) indextype is mdsys.spatial_index'||
                ' parameters ('||''''||'sdo_level='||num_tiles||''''||')';

--nm_debug.debug_on;
--nm_debug.debug(cur_string);
  EXECUTE IMMEDIATE cur_string;

END;
--
----------------------------------------------------------------------------------------------------------------------------------------
--

PROCEDURE Change_Affected_Shapes (p_layer IN NUMBER, p_ne_id IN nm_elements.ne_id%TYPE ) IS

CURSOR c_themes ( c_layer IN NUMBER ) IS
     SELECT nth.nth_theme_id, nth.nth_feature_table, nat_gty_group_type objtype, 2 dim_setting, 'G' g_or_i
     FROM NM_THEMES_ALL nth, NM_AREA_THEMES, NM_AREA_TYPES, NM_BASE_THEMES
    WHERE nbth_base_theme = c_layer
   AND nbth_theme_id = nth_theme_id
      AND nth_update_on_edit = 'I'
      AND nth_theme_id = nath_nth_theme_id
      AND nat_id = nath_nat_id
   UNION
   SELECT nth.nth_theme_id, nth.nth_feature_table, nith_nit_id objtype,
          DECODE (nit_pnt_or_cont, 'P', 2, 'C', 3) dim_setting, 'I' g_or_i
     FROM NM_THEMES_ALL nth, NM_INV_THEMES, nm_inv_types, NM_BASE_THEMES
    WHERE nbth_base_theme = c_layer
   AND nbth_theme_id = nth_theme_id
      AND nth_update_on_edit = 'I'
      AND nth_theme_id = nith_nth_theme_id
      AND nith_nit_id = nit_inv_type
      AND nit_table_name IS NULL
   UNION
   SELECT nth.nth_theme_id, nth.nth_feature_table, nlt_gty_type objtype, 3 dim_setting, 'G' g_or_i
     FROM NM_THEMES_ALL nth, NM_NW_THEMES, NM_LINEAR_TYPES, NM_BASE_THEMES
    WHERE nbth_base_theme = c_layer
   AND nbth_theme_id = nth_theme_id
      AND nth_update_on_edit = 'I'
      AND nth_theme_id = nnth_nth_theme_id
      AND nlt_id = nnth_nlt_id
   UNION
   SELECT nth.nth_theme_id, nth.nth_feature_table, nith_nit_id objtype,
          DECODE (nit_pnt_or_cont, 'P', 2, 'C', 3) dim_setting, 'F' g_or_i
     FROM NM_THEMES_ALL nth, NM_INV_THEMES, nm_inv_types, NM_BASE_THEMES
    WHERE nbth_base_theme = c_layer
   AND nbth_theme_id = nth_theme_id
      AND nth_update_on_edit = 'I'
      AND nth_theme_id = nith_nth_theme_id
      AND nith_nit_id = nit_inv_type
      AND nit_table_name IS NOT NULL
   ORDER BY 1;

lstr VARCHAR2(2000);

get_shape_str VARCHAR2(200);

function get_dims( p_theme IN NUMBER ) RETURN INTEGER IS
l_diminfo mdsys.sdo_dim_array := get_theme_diminfo( p_theme );
BEGIN
RETURN l_diminfo.LAST;
END;


function is_ad_link_type ( p_inv_type in nm_inv_types.nit_inv_type%type ) return varchar2 is
retval varchar2(10) := 'FALSE';
begin
  select 'TRUE'
  into retval from nm_nw_ad_types
  where nad_inv_type = p_inv_type;
  return retval;
exception
  when too_many_rows then
    return 'TRUE';
  when no_data_found then
    return 'FALSE';
end;


BEGIN

--Nm_Debug.debug_on;

  FOR irec IN c_themes( p_layer ) LOOP

--     Nm_Debug.DEBUG('layer = '||TO_CHAR( p_layer )||' affecting '||TO_CHAR( irec.nth_theme_id )||' '||irec.nth_feature_table );

     IF irec.g_or_i != 'F' THEN

--     inventory/group - with member data - delete if there, then insert

--       Nm_Debug.DEBUG('Inventory/Group');

       IF irec.dim_setting = 2 THEN
          get_shape_str := 'sdo_lrs.convert_to_std_geom(nm3sdo.get_shape_from_nm( '||TO_CHAR(p_layer)||', nm_ne_id_in, nm_ne_id_of, nm_begin_mp, nm_end_mp ))';
       ELSE
          get_shape_str := 'nm3sdo.get_shape_from_nm( '||TO_CHAR(p_layer)||', nm_ne_id_in, nm_ne_id_of, nm_begin_mp, nm_end_mp )';
       END IF;

       EXECUTE IMMEDIATE 'delete from '||irec.nth_feature_table||
                         ' where ne_id_of = :ne_id ' USING p_ne_id;


--       Nm_Debug.DEBUG( 'delete from '||irec.nth_feature_table||
--                       ' where ne_id_of = :ne_id '||' using '||TO_CHAR(p_ne_id));

       IF use_surrogate_key = 'N' THEN

         lstr := 'insert into '||irec.nth_feature_table||
                          ' ( NE_ID, NE_ID_OF, NM_BEGIN_MP, NM_END_MP, GEOLOC, START_DATE, END_DATE )'||
                          'select nm_ne_id_in, nm_ne_id_of, nm_begin_mp, nm_end_mp, '||
                          get_shape_str||','||
                          ' nm_start_date, nm_end_date '||
                          ' from nm_members_all '||
                          ' where nm_ne_id_of = :ne_id '||
                          ' and nm_obj_type = :objtype'||
        ' and nm_type = :b_nm_type';

--         Nm_Debug.DEBUG(lstr);
         EXECUTE IMMEDIATE lstr USING p_ne_id, irec.objtype, irec.g_or_i;

       ELSE

         if (irec.g_or_i = 'I' and is_ad_link_type( irec.objtype ) = 'FALSE') OR
             irec.g_or_i = 'G' then

           lstr := 'insert into '||irec.nth_feature_table||
                          ' ( OBJECTID, NE_ID, NE_ID_OF, NM_BEGIN_MP, NM_END_MP, GEOLOC, START_DATE, END_DATE )'||
                          'select '||get_spatial_seq(irec.nth_theme_id)||'.nextval, nm_ne_id_in, nm_ne_id_of, nm_begin_mp, nm_end_mp, '||
                          get_shape_str||','||
                          ' nm_start_date, nm_end_date '||
                          ' from nm_members_all '||
                          ' where nm_ne_id_of = :ne_id '||
                          ' and nm_obj_type = :objtype';

         else

           lstr := 'insert into '||irec.nth_feature_table||
                          ' ( OBJECTID, NE_ID, NE_ID_OF, NM_BEGIN_MP, NM_END_MP, GEOLOC, START_DATE, END_DATE )'||
                          'select '||get_spatial_seq(irec.nth_theme_id)||'.nextval, nad_iit_ne_id, nm_ne_id_of, nm_begin_mp, nm_end_mp, '||
                          get_shape_str||','||
                          ' nm_start_date, nm_end_date '||
                          ' from nm_members_all, nm_nw_ad_link_all '||
                          ' where nm_ne_id_of = :ne_id '||
                          ' and nad_inv_type = :objtype'||
                          ' and nm_ne_id_in = nad_member_id';

         end if;

--       Nm_Debug.DEBUG(lstr );

         EXECUTE IMMEDIATE lstr USING p_ne_id, irec.objtype;

       END IF;

     ELSE -- foreign table

--       Nm_Debug.DEBUG('Foreign table');

       DECLARE

         l_nth nm_themes_all%ROWTYPE := Nm3get.get_nth( irec.nth_theme_id );

       BEGIN

         IF l_nth.nth_feature_table != l_nth.nth_table_name THEN

--         distinct FT and feature table, it could have measures or it could be 2d

--           Nm_Debug.DEBUG('distinct FT and feature table');

           IF get_dims( irec.nth_theme_id ) = 2 THEN
             get_shape_str := 'sdo_lrs.convert_to_std_geom(nm3sdo.get_shape_from_nm( '||TO_CHAR(p_layer)||
                              ', '||l_nth.nth_pk_column||
                              ', '||l_nth.nth_rse_fk_column||
                              ', '||l_nth.nth_st_chain_column||
                              ', '||l_nth.nth_end_chain_column ||'))';
        ELSE
          get_shape_str := 'nm3sdo.get_shape_from_nm( '||TO_CHAR(p_layer)||
                              ', '||l_nth.nth_pk_column||
                              ', '||l_nth.nth_rse_fk_column||
                              ', '||l_nth.nth_st_chain_column||
                              ', '||l_nth.nth_end_chain_column ||')';
        END IF;


           IF l_nth.nth_rse_fk_column IS NULL OR
              l_nth.nth_st_chain_column IS NULL OR
              l_nth.nth_end_chain_column IS NULL THEN

              RAISE_APPLICATION_ERROR(-20001, 'You need to link the feature and asset table and the network measures');


           ELSIF l_nth.nth_feature_fk_column IS NULL THEN

--            FT feature and theme tables are differenct but the link is one to one

             lstr := 'update '||l_nth.nth_feature_table||' f '||
                               'set f.'||l_nth.nth_feature_shape_column||' = ( SELECT '||get_shape_str||
                               ' FROM '||l_nth.nth_table_name||' where '||l_nth.nth_rse_fk_column||' = :ne_id '||
                               ' and  '||l_nth.nth_pk_column||' = '||l_nth.nth_feature_pk_column||' )'||
                               ' where '||l_nth.nth_feature_pk_column||' in ( select '||l_nth.nth_pk_column||
                               ' from '||l_nth.nth_table_name||' where '||l_nth.nth_rse_fk_column||' = :ne_id )';

--             Nm_Debug.debug_on;
--             Nm_Debug.DEBUG(lstr);
--             Nm_Debug.debug_off;

             EXECUTE IMMEDIATE lstr USING p_ne_id, p_ne_id;

           ELSE

--           FT feature and theme tables are distinct, metadata is OK

             lstr := 'update '||l_nth.nth_feature_table||' f '||
                               'set f.'||l_nth.nth_feature_shape_column||' = ( SELECT '||get_shape_str||
                               ' FROM '||l_nth.nth_table_name||' where '||l_nth.nth_rse_fk_column||' = :ne_id '||
                               ' and  '||l_nth.nth_pk_column||' = '||l_nth.nth_feature_fk_column||' )'||
                               ' where '||l_nth.nth_feature_fk_column||' in ( select '||l_nth.nth_pk_column||
                               ' from '||l_nth.nth_table_name||' where '||l_nth.nth_rse_fk_column||' = :ne_id )';


--             Nm_Debug.DEBUG(lstr);

             EXECUTE IMMEDIATE lstr USING p_ne_id, p_ne_id;

           END IF;

         ELSE

--         FT feature table and theme table is the same, have to perform update only

           lstr := 'update '||l_nth.nth_feature_table||' f '||
                               'set f.'||l_nth.nth_feature_shape_column||' = '||get_shape_str||
                               ' where '||l_nth.nth_feature_fk_column||' = :ne_id ';

           EXECUTE IMMEDIATE lstr USING p_ne_id;

         END IF; --distinct tables

       END;

     END IF;
   END LOOP;

END;

--

--
-------------------------------------------------------------------------------------------------------------------------------------
--


FUNCTION create_spatial_seq( p_theme_id IN NUMBER ) RETURN VARCHAR2 IS
l_seq_name VARCHAR2(30) := 'NTH_'||TO_CHAR(p_theme_id)||'_SEQ';
BEGIN
    Nm3ddl.create_object_and_syns( l_seq_name, 'create sequence '||l_seq_name||' start with 1' );

    RETURN l_seq_name;
END;

--
-------------------------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_spatial_seq( p_theme_id IN NUMBER ) RETURN VARCHAR2 IS
l_seq_name VARCHAR2(30) := 'NTH_'||TO_CHAR(p_theme_id)||'_SEQ';
BEGIN
    RETURN l_seq_name;
END;

--
-------------------------------------------------------------------------------------------------------------------------------------
--


FUNCTION get_spatial_index_type( p_table_name IN VARCHAR2) RETURN VARCHAR2 IS


CURSOR c1 ( c_table_name IN VARCHAR2 ) IS
  SELECT sdo_index_type
  FROM USER_INDEXES i, user_sdo_index_metadata m
  WHERE i.index_name = m.sdo_index_name
  AND i.table_name = c_table_name;

retval VARCHAR2(10);

BEGIN
  OPEN c1 ( p_table_name );
  FETCH c1 INTO retval;
  IF c1%NOTFOUND THEN
    CLOSE c1;
    Hig.raise_ner(pi_appl                => Nm3type.c_hig
                 ,pi_id                 => 241
                 ,pi_sqlcode            => -20001
                   );
--  raise_application_error( -20001, 'No Index on the table and column');
  END IF;

  CLOSE c1;
  RETURN retval;

END;

FUNCTION get_spatial_index_type( p_theme_id IN NUMBER ) RETURN VARCHAR2 IS
l_nth NM_THEMES_ALL%ROWTYPE := Nm3get.get_nth( p_theme_id);

BEGIN
    RETURN get_spatial_index_type( l_nth.nth_feature_table );
END;

--
-------------------------------------------------------------------------------------------------------------------------------------
--

FUNCTION Convert_Dim_Array_To_Mbr ( p_layer NUMBER ) RETURN mdsys.sdo_geometry IS

retval mdsys.sdo_geometry := NULL;

BEGIN

  IF set_theme( p_layer ) THEN
    set_theme_metadata( p_layer );
  END IF;

  retval := Convert_Dim_Array_To_Mbr( g_usgm.diminfo );

  RETURN retval;

END;

--
-------------------------------------------------------------------------------------------------------------------------------------
--

FUNCTION Convert_Dim_Array_To_Mbr ( p_diminfo IN mdsys.sdo_dim_array, p_srid IN NUMBER DEFAULT NULL ) RETURN mdsys.sdo_geometry IS

retval mdsys.sdo_geometry := NULL;

BEGIN

  IF p_diminfo.LAST = 2 THEN

    retval := mdsys.sdo_geometry( 2003, p_srid, NULL, mdsys.sdo_elem_info_array( 1, 1003, 3),
                                  mdsys.sdo_ordinate_array(  p_diminfo(1).sdo_lb,
                                                             p_diminfo(2).sdo_lb,
                                                             p_diminfo(1).sdo_ub,
                                                             p_diminfo(2).sdo_ub));
  ELSIF p_diminfo.LAST = 3 THEN

    retval := mdsys.sdo_geometry( 3003, p_srid, NULL, mdsys.sdo_elem_info_array( 1, 1003, 3),
                                  mdsys.sdo_ordinate_array(  p_diminfo(1).sdo_lb,
                                                             p_diminfo(2).sdo_lb,
                                                             p_diminfo(3).sdo_lb,
                                                             p_diminfo(1).sdo_ub,
                                                             p_diminfo(2).sdo_ub,
                                                             p_diminfo(3).sdo_ub));
  ELSIF p_diminfo.LAST = 4 THEN

    retval := mdsys.sdo_geometry( 4003, p_srid, NULL, mdsys.sdo_elem_info_array( 1, 1003, 3),
                                  mdsys.sdo_ordinate_array(  p_diminfo(1).sdo_lb,
                                                             p_diminfo(2).sdo_lb,
                                                             p_diminfo(3).sdo_lb,
                                                             p_diminfo(4).sdo_lb,
                                                             p_diminfo(1).sdo_ub,
                                                             p_diminfo(2).sdo_ub,
                                                             p_diminfo(3).sdo_ub,
                                                             p_diminfo(4).sdo_ub));
  END IF;

  RETURN retval;

END;



--
-------------------------------------------------------------------------------------------------------------------------------------
--
PROCEDURE register_table ( p_table IN VARCHAR2, p_shape_col IN VARCHAR2, p_cre_idx IN VARCHAR2,
                           p_tol IN NUMBER DEFAULT .005, p_estimate_new_tol VARCHAR2 DEFAULT 'N',
                           p_override_sdo_meta IN VARCHAR2 DEFAULT 'I' ) IS

  -- p_override_sdo_meta can take the values Y for complete override of existing registration
  --                                         N to raise an error
  --                                         I to ignore any override and use existing registration.
  curstring VARCHAR2(2000);
  l_geom     mdsys.sdo_geometry;
  l_diminfo  mdsys.sdo_dim_array;
  l_indx     VARCHAR2(30);
  l_tol_array num_array_type;
  l_dim     NUMBER;
  l_lrs_dim NUMBER;
  l_gtype   NUMBER;
  l_z_or_m  VARCHAR2(1) := 'M';
  l_create  BOOLEAN := FALSE;
  l_srid    NUMBER;
BEGIN
   IF is_table_regd ( p_table, p_shape_col) THEN

     IF p_override_sdo_meta = 'Y' THEN

       DELETE FROM mdsys.sdo_geom_metadata_table
       WHERE sdo_table_name = p_table
    AND   sdo_column_name = p_shape_col
    AND   sdo_owner = Hig.get_application_owner;

       l_create := TRUE;

     ELSIF p_override_sdo_meta = 'N' THEN

       Hig.raise_ner(pi_appl                => Nm3type.c_hig
                    ,pi_id                 => 242
                    ,pi_sqlcode            => -20001
                     );
--     raise_application_error(-20001, 'Already registered in SDO Metadata');

     ELSE

       l_create := FALSE;

     END IF;

   ELSE

     l_create := TRUE;

   END IF;

   IF l_create THEN
    --
    -- AE 17/AUG/2006
    -- Make suitable to register empty tables
      BEGIN
        l_diminfo := calculate_table_diminfo( p_table
                                            , p_shape_col
                                            , p_tol
                                            , p_estimate_new_tol  );
      EXCEPTION
        WHEN OTHERS
        THEN
          -- if it fails to calculate - the table is empty.
          -- revert to using base layer for now.
          l_diminfo := sdo_lrs.convert_to_std_dim_array(coalesce_nw_diminfo);
      END;
   --
     curstring := 'select a.'||p_shape_col||' from '||p_table||' a where rownum = 1';
   --
   -- AE 17/AUG/2006
   -- Derive the SRID even if table is empty
     BEGIN
       EXECUTE IMMEDIATE curstring INTO l_geom;
       l_srid := l_geom.sdo_srid;
     EXCEPTION
       WHEN OTHERS
       THEN
       -- if it fails to get a row - the table/view is empty
       -- revert to using base layer for now.
        l_srid := get_nw_srids;
     END;

     ins_usgm( p_table, p_shape_col, l_diminfo, l_srid );
/*
     INSERT INTO user_sdo_geom_metadata
     ( table_name, column_name, diminfo, srid )
     VALUES ( p_table, p_shape_col, l_diminfo, l_geom.sdo_srid );
*/
   END IF;

   IF p_cre_idx = 'Y' THEN

     l_indx := get_spatial_index( p_table, p_shape_col );

     IF l_indx IS NOT NULL THEN

       EXECUTE IMMEDIATE 'drop index '||l_indx;

     END IF;

     create_spatial_idx ( p_table, p_shape_col );

   END IF;

END;

--
-----------------------------------------------------------------------------------------------------------------------------------
--
-- GJ 08-OCT-2004
-- function moved to nm3unit package - to preserve any existing calls
-- leave function def'n in nm3sdo package but change to be a wrapper
--
FUNCTION get_tol_from_unit_mask ( p_unit IN NUMBER ) RETURN NUMBER IS

BEGIN
  RETURN (Nm3unit.get_tol_from_unit_mask ( p_unit => p_unit));
END;
--
-----------------------------------------------------------------------------
--

FUNCTION get_theme_mbr ( p_nth_id IN NUMBER ) RETURN mdsys.sdo_geometry IS

l_nth NM_THEMES_ALL%ROWTYPE;

BEGIN
  l_nth := Nm3get.get_nth( p_nth_id );

  RETURN get_table_mbr( l_nth.nth_feature_table, l_nth.nth_feature_shape_column );
END;

--
-----------------------------------------------------------------------------
--
FUNCTION get_theme_centre_and_size ( p_nth_id IN NUMBER ) RETURN mdsys.sdo_geometry IS

BEGIN

  RETURN get_centre_and_size( get_theme_mbr( p_nth_id) );

END;
--
-----------------------------------------------------------------------------
--

FUNCTION calculate_theme_mbr ( p_nth_id IN NUMBER ) RETURN mdsys.sdo_geometry IS

l_nth NM_THEMES_ALL%ROWTYPE := Nm3get.get_nth( p_nth_id );

BEGIN

  RETURN calculate_table_mbr( l_nth.nth_feature_table, l_nth.nth_feature_shape_column );

END;

--
-----------------------------------------------------------------------------
--

FUNCTION calculate_table_mbr ( p_table_name IN VARCHAR2, p_column IN VARCHAR2 ) RETURN mdsys.sdo_geometry IS

BEGIN

  RETURN Convert_Dim_Array_To_Mbr( calculate_table_diminfo( p_table_name, p_column ));

END;

--
-----------------------------------------------------------------------------
--
FUNCTION calculate_theme_cent_and_size ( p_nth_id IN NUMBER ) RETURN mdsys.sdo_geometry IS
BEGIN
  RETURN get_centre_and_size( calculate_theme_mbr ( p_nth_id));
END;

--
-----------------------------------------------------------------------------
--
--
-- This procedure creates a feature table and fills it with shapes derived from the database according to the related theme
-- information. It is divided into three main processing blocks - the first is to define a spatial layer for a theme derived by X,Y,
-- the second is another point theme derived by linear reference and the third is a dyn-segged linear layer.
-- The third is more complex depending on whether single part/multi-row or multi-row single part data is used.
--
-- The procedure is intended to convert data from an SDM data source where only one base layer can exist. If a dyn-seg
-- layer is to be generated, then assume the base layer can be provided in the calling syntax.
--
PROCEDURE Create_Sdo_Layer_From_Locl( p_nth_id IN NM_THEMES_ALL.nth_theme_id%TYPE, p_base_theme IN NUMBER DEFAULT NULL, p_srid IN NUMBER DEFAULT NULL ) AS

l_table_name     VARCHAR2(30);
l_column_name VARCHAR2(30);

l_base   NM_THEMES_ALL%ROWTYPE;

l_srid   NUMBER := p_srid;

l_seq_name VARCHAR2(30);

cur_string VARCHAR2(2000);

l_tol      NUMBER;

l_p_or_c   VARCHAR2(1) := 'P';

l_dummy    NUMBER;
--
------------------------------------------------------
-- This function removes the word 'WHERE' from clause
-- text. Code has been changed in this procedure
-- to handle both where clauses (with or without WHERE)
   FUNCTION format_where_clause
           (pi_where IN NM_THEMES_ALL.nth_where%TYPE)
   RETURN NM_THEMES_ALL.nth_where%TYPE
   IS
      retval NM_THEMES_ALL.nth_where%TYPE;
   BEGIN
      IF SUBSTR(pi_where, 1,5) = 'WHERE'
        THEN
         retval := SUBSTR(pi_where,7);
      ELSE
         retval := pi_where;
      END IF;
      RETURN retval;
   END;
--
------------------------------------------------------
--
BEGIN

--  Nm_Debug.debug_on;

  IF set_theme( p_nth_id ) THEN
    set_theme_metadata( p_nth_id );
  END IF;

  IF g_nth.nth_feature_table IS NULL THEN
     Hig.raise_ner(pi_appl                => Nm3type.c_hig
                  ,pi_id                 => 243
                  ,pi_sqlcode            => -20001
                   );

--    raise_application_error(-20001, 'Needs a Feature table');
  ELSIF g_nth.nth_feature_shape_column IS NULL THEN
     Hig.raise_ner(pi_appl                => Nm3type.c_hig
                  ,pi_id                 => 244
                  ,pi_sqlcode            => -20001
                   );

--    raise_application_error(-20001, 'Needs a Feature table spatial column');
  END IF;

--Lref - ideally the network table should hold the key to the spatial base layer

  IF g_usgm.srid IS NULL AND p_base_theme IS NULL THEN

--  only suitable for X,Y data

    l_srid := NULL;

  ELSIF p_base_theme IS NOT NULL THEN

    l_base := Nm3get.get_nth( p_base_theme );

 set_global_metadata( get_theme_metadata(p_base_theme));

    l_srid := Nm3sdo.get_theme_metadata( p_base_theme ).srid;

  END IF;

  cur_string := 'create table '||g_nth.nth_feature_table||'( '||
                   g_nth.nth_feature_pk_column||'   number(38) not null,'||
                   g_nth.nth_feature_shape_column||'  mdsys.sdo_geometry not null';

  IF g_nth.nth_feature_fk_column IS NOT NULL AND g_nth.nth_feature_fk_column != g_nth.nth_feature_pk_column THEN

     cur_string := cur_string||','||g_nth.nth_feature_fk_column||' number(38)';

  END IF;

  IF Nm3sdo.use_surrogate_key = 'Y' THEN

     cur_string := cur_string||',objectid   number(38)';

     l_seq_name := Nm3sdo.create_spatial_seq(p_nth_id);

  END IF;

--   Nm_Debug.DEBUG(cur_string);

  cur_string := cur_string||' )';

  Nm3ddl.create_object_and_syns( g_nth.nth_feature_table, cur_string );

--First block to derive data based on an XY column pair.

  IF g_nth.nth_x_column IS NOT NULL AND
     g_nth.nth_y_column IS NOT NULL THEN


    cur_string := 'insert into '||g_nth.nth_feature_table||' ( '||
                      g_nth.nth_feature_pk_column||','||
                      g_nth.nth_feature_shape_column;

    IF g_nth.nth_feature_fk_column IS NOT NULL AND g_nth.nth_feature_fk_column != g_nth.nth_feature_pk_column THEN

      cur_string := cur_string||', '||g_nth.nth_feature_fk_column;

    END IF;

    IF Nm3sdo.use_surrogate_key = 'Y' THEN

      cur_string := cur_string||', objectid';

    END IF;

    cur_string := cur_string||')'||
                     ' select '||g_nth.nth_pk_column||', '||
                     ' mdsys.sdo_geometry( 2001, '||NVL(TO_CHAR(l_srid),'NULL')||','||
                     ' mdsys.sdo_point_type( '||g_nth.nth_x_column||','||g_nth.nth_y_column||', null), null, null)';

    IF g_nth.nth_feature_fk_column IS NOT NULL AND g_nth.nth_feature_fk_column != g_nth.nth_feature_pk_column THEN

      cur_string := cur_string||', '||g_nth.nth_pk_column;

    END IF;

    IF Nm3sdo.use_surrogate_key = 'Y' THEN

      cur_string := cur_string||', '||l_seq_name||'.nextval';

    END IF;

    IF g_nth.nth_where IS NOT NULL
      THEN
      cur_string := cur_string||' from '||g_nth.nth_table_name
                   ||' WHERE '||format_where_clause(g_nth.nth_where);
    ELSE
      cur_string := cur_string||' from '||g_nth.nth_table_name;
    END IF;
--Nm_Debug.DEBUG(cur_string);
--    cur_string := cur_string||' and rownum = 1';

    EXECUTE IMMEDIATE cur_string;

  IF p_base_theme IS NOT NULL THEN
      l_dummy := Nm3sdo.clone_pt_from_line( p_base_theme, g_nth.nth_feature_table, g_nth.nth_feature_shape_column);
  ELSE
    register_table( g_nth.nth_feature_table, g_nth.nth_feature_shape_column, 'N');
  END IF;

 --next block deals with point item dyn-seg

  ELSIF g_nth.nth_st_chain_column IS NOT NULL AND
        g_nth.nth_end_chain_column IS NULL THEN


    IF p_base_theme IS NULL THEN
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                   ,pi_id                 => 245
                   ,pi_sqlcode            => -20001
                   );
--    raise_application_error( -20001, 'Needs a base theme to dyn-seg from');
    END IF;

    cur_string := 'insert into '||g_nth.nth_feature_table||' ( '||
                      g_nth.nth_feature_pk_column||','||
                      g_nth.nth_feature_shape_column;

    IF g_nth.nth_feature_fk_column IS NOT NULL AND g_nth.nth_feature_fk_column != g_nth.nth_feature_pk_column THEN

      cur_string := cur_string||','||g_nth.nth_feature_fk_column;

    END IF;

    IF Nm3sdo.use_surrogate_key = 'Y' THEN

       cur_string := cur_string||', objectid ';

    END IF;

    cur_string := cur_string||')'||
                   ' select a.'||g_nth.nth_pk_column||', nm3sdo.get_2d_pt(sdo_lrs.locate_pt( b.'||l_base.nth_feature_shape_column||
                   ', a.'||g_nth.nth_st_chain_column;

    IF g_nth.nth_offset_field IS NOT NULL THEN

      cur_string := cur_string||', a.'||g_nth.nth_offset_field;

    END IF;

    cur_string := cur_string||'))';

    IF g_nth.nth_feature_fk_column IS NOT NULL AND g_nth.nth_feature_fk_column != g_nth.nth_feature_pk_column THEN

      cur_string := cur_string||',a.'||g_nth.nth_rse_fk_column;

    END IF;

    IF Nm3sdo.use_surrogate_key = 'Y' THEN

       cur_string := cur_string||', '||l_seq_name||'.nextval ';

    END IF;

    cur_string := cur_string||' from '||g_nth.nth_table_name||' a,'||
                               l_base.nth_feature_table||' b'||
                     '  where a.'||g_nth.nth_rse_fk_column||' = b.'||l_base.nth_feature_pk_column;

    IF g_nth.nth_where IS NOT NULL
    THEN
         cur_string := cur_string||' AND '||format_where_clause(g_nth.nth_where);
    END IF;

--    Nm_Debug.debug_on;
--    Nm_Debug.DEBUG(cur_string);
    EXECUTE IMMEDIATE cur_string;

    l_dummy := Nm3sdo.clone_pt_from_line( p_base_theme, g_nth.nth_feature_table, g_nth.nth_feature_shape_column);

--third block dealing with linear dyn-seg

  ELSIF g_nth.nth_st_chain_column IS NOT NULL AND
        g_nth.nth_end_chain_column IS NOT NULL THEN

    IF p_base_theme IS NULL THEN
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                   ,pi_id                 => 245
                   ,pi_sqlcode            => -20001
                   );

--      raise_application_error( -20001, 'Needs a base theme to dyn-seg from');
    END IF;

    l_p_or_c := 'C';


    cur_string := 'insert into '||g_nth.nth_feature_table||' ( '||
                      g_nth.nth_feature_pk_column||','||
                      g_nth.nth_feature_shape_column;

    IF g_nth.nth_feature_fk_column IS NOT NULL AND g_nth.nth_feature_fk_column != g_nth.nth_feature_pk_column THEN

      cur_string := cur_string||','||g_nth.nth_feature_fk_column;

    END IF;

    IF Nm3sdo.use_surrogate_key = 'Y' THEN

       cur_string := cur_string||', objectid ';

    END IF;

    IF g_nth.nth_offset_field IS NOT NULL THEN

       cur_string := cur_string||')'||
                   ' select a.'||g_nth.nth_pk_column||', sdo_lrs.offset_geom_segment( '||
                   'b.'||l_base.nth_feature_shape_column||
                   ', a.'||g_nth.nth_st_chain_column||
                   ', a.'||g_nth.nth_end_chain_column||
                   ', '||g_nth.nth_offset_field||')';

    ELSE

/*
       cur_string := cur_string||')'||
                   ' select a.'||g_nth.nth_pk_column||', sdo_lrs.clip_geom_segment( '||
                   'b.'||l_base.nth_feature_shape_column||
                   ', a.'||g_nth.nth_st_chain_column||
                   ', a.'||g_nth.nth_end_chain_column||')';
*/


       cur_string := cur_string||')'||
                   ' select a.'||g_nth.nth_pk_column||',sdo_lrs.clip_geom_segment( '||
                   'b.'||l_base.nth_feature_shape_column||
                   ', a.'||g_nth.nth_st_chain_column||
                   ', a.'||g_nth.nth_end_chain_column||', '||TO_CHAR( g_usgm.diminfo(1).sdo_tolerance)||')';

    END IF;


    IF g_nth.nth_feature_fk_column IS NOT NULL AND g_nth.nth_feature_fk_column != g_nth.nth_feature_pk_column THEN

      cur_string := cur_string||',a.'||g_nth.nth_pk_column;

    END IF;

    IF Nm3sdo.use_surrogate_key = 'Y' THEN

       cur_string := cur_string||', '||l_seq_name||'.nextval ';

    END IF;

    cur_string := cur_string||' from '||g_nth.nth_table_name||' a,'||
                               l_base.nth_feature_table||' b'||
                     '  where a.'||g_nth.nth_rse_fk_column||' = b.'||l_base.nth_feature_pk_column;

    IF g_nth.nth_where IS NOT NULL
    THEN
       cur_string := cur_string||' AND '||format_where_clause(g_nth.nth_where);
    END IF;

--    Nm_Debug.DEBUG(cur_string);

    EXECUTE IMMEDIATE cur_string;

    l_dummy := Nm3sdo.clone_layer( p_base_theme, g_nth.nth_feature_table, g_nth.nth_feature_shape_column);

  ELSE

--  what else is there?

    Hig.raise_ner(pi_appl                => Nm3type.c_hig
                  ,pi_id                 => 246
                  ,pi_sqlcode            => -20001
                   );
--    raise_application_error(-20001,'Not enough info on the theme');

  END IF;


  Nm3sdo.create_spatial_idx( g_nth.nth_feature_table, g_nth.nth_feature_shape_column);


  -- A.E. 10-OCT-2006
  -- Try to create a unique constraint, otherwise create a non-unique index
  --
  DECLARE
    e_2437_dup_vals   EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_2437_dup_vals,-2437);
  BEGIN
  --
    cur_string := 'alter table '||g_nth.nth_feature_table||
                  ' ADD CONSTRAINT '||SUBSTR(g_nth.nth_feature_table,1, 27)||'_PK PRIMARY KEY '||
                     ' ( '||g_nth.nth_feature_pk_column||')';
  --
    EXECUTE IMMEDIATE cur_string;
  --
  EXCEPTION
    WHEN e_2437_dup_vals
    THEN
      EXECUTE IMMEDIATE
        'CREATE INDEX '||SUBSTR(g_nth.nth_feature_table,1, 27)||'_IND ON '||
        g_nth.nth_feature_table||' ('||g_nth.nth_feature_pk_column||')';
  END;
  -- A.E. 10-OCT-2006
  -- End of changes


  IF g_nth.nth_feature_fk_column IS NOT NULL AND g_nth.nth_feature_fk_column != g_nth.nth_feature_pk_column THEN

    cur_string := 'create index '||SUBSTR(g_nth.nth_feature_table, 1, 23)||'_FK_IDX'||' on '||
                  g_nth.nth_feature_table||' ( '||g_nth.nth_feature_fk_column||')';

--    Nm_Debug.DEBUG(cur_string);

    EXECUTE IMMEDIATE cur_string;

  END IF;

  UPDATE NM_THEMES_ALL
  SET nth_theme_type = 'SDO',
      nth_storage    = 'S'
  WHERE nth_theme_id = p_nth_id;

  IF Hig.get_sysopt('REGSDELAY') = 'Y' THEN

--  Nm_Debug.DEBUG('Register theme '||TO_CHAR(p_nth_id)||' as an sde layer');

    EXECUTE IMMEDIATE ( ' begin  '||
                        '    nm3sde.register_sde_layer( p_theme_id => '||TO_CHAR(p_nth_id)||');'||
                        ' end;' );

  END IF;

  COMMIT;

END;


--
-----------------------------------------------------------------------------
--

FUNCTION get_dim_from_gtype ( p_gtype IN NUMBER ) RETURN INTEGER IS

BEGIN
  RETURN TRUNC(p_gtype/1000);
END;

--
-----------------------------------------------------------------------------
--
FUNCTION get_lrs_from_gtype ( p_gtype IN NUMBER ) RETURN INTEGER IS

BEGIN
  RETURN TRUNC( (p_gtype - (TRUNC(p_gtype/1000) * 1000) )/ 100);
END;

--
-----------------------------------------------------------------------------
--
FUNCTION get_type_from_gtype ( p_gtype IN NUMBER ) RETURN INTEGER IS
BEGIN
  RETURN    MOD(p_gtype,10);
--trunc( p_gtype - trunc( p_gtype/100) *100);
END;
--
-----------------------------------------------------------------------------
--


FUNCTION get_sample_tolerance( p_table IN VARCHAR2,
                               p_column IN VARCHAR2,
                               p_use_lrs IN VARCHAR2 DEFAULT 'Y',
                               p_row IN NUMBER DEFAULT 10,
                               p_elem IN NUMBER DEFAULT 1,
                               p_vertex IN NUMBER DEFAULT -1 ) RETURN num_array_type IS

retval num_array_type;

cur_string VARCHAR2(2000);

TYPE geocurtyp IS REF CURSOR;

geocur geocurtyp;

l_geom     mdsys.sdo_geometry;
l_gtype    NUMBER;
l_dim      NUMBER;
l_lrs      NUMBER;
l_parts    NUMBER;
ic         INTEGER;
l_g_diff   NUMBER;
l_m_diff   NUMBER;

BEGIN

--nm_debug.delete_debug(true);
--nm_debug.debug_on;

  l_gtype := get_table_gtype( p_table, p_column);

--nm_debug.debug('Gtype = '||to_char( l_gtype ));

  IF get_type_from_gtype( l_gtype ) = 1 THEN

     Hig.raise_ner(pi_appl                => Nm3type.c_hig
                  ,pi_id                 => 247
                  ,pi_sqlcode            => -20001
                   );
--  raise_application_error(-20001, 'Tolerance cannot be found from point data' );

  END IF;

  retval := num_array_type(Nm3type.c_big_number);

  l_dim := get_dim_from_gtype( l_gtype );
  l_lrs := 0;

  l_lrs := get_lrs_from_gtype(l_gtype);

  IF p_use_lrs = 'Y' THEN
    IF l_dim = 3 THEN
      l_lrs := 3;
    END IF;
  END IF;

  FOR i IN 2..l_dim LOOP
    retval.EXTEND;
    retval(retval.LAST) := Nm3type.c_big_number;
  END LOOP;


  cur_string := 'select '||p_column||' from '||p_table;

  OPEN geocur FOR cur_string;
  LOOP

--  nm_debug.debug('Open the cursor, now fetch');

    FETCH geocur INTO l_geom;
    EXIT WHEN geocur%NOTFOUND;
    IF p_row > 0 THEN
--    nm_debug.debug('Row sample = '||to_char(geocur%rowcount));
      EXIT WHEN geocur%rowcount > p_row;
    END IF;

    -- Task 0108546
    -- No longer used
    --l_geom := strip_user_parts( l_geom );

    l_parts := get_no_parts(l_geom)/3;
--  nm_debug.debug( 'Parts = '||to_char(l_parts) );

    FOR elerec IN 1..l_parts LOOP

--    nm_debug.debug('Elem loop '||to_char( elerec ));

      EXIT WHEN elerec > p_elem;

      IF l_geom.sdo_elem_info( (elerec-1) * 3 + 2 ) > 0 THEN


        FOR vertrec IN 2..l_geom.sdo_ordinates.LAST/l_dim LOOP

  --      nm_debug.debug('Vertex  loop '||to_char( vertrec ));

          IF p_vertex > 0 THEN
            EXIT WHEN vertrec > p_vertex;
          END IF;

          ic := ( vertrec - 1) * l_dim + 1;

  --      nm_debug.debug('Using co-ordinate '||to_char(ic)||' LRSdim = '||to_char(l_lrs)||' dim = '||to_char(l_dim));

          IF l_lrs > 0 THEN

            IF l_dim = 3 THEN

  --          assume the M is th elast dimension - either dim 3 or 4

              l_g_diff := SQRT( POWER( (l_geom.sdo_ordinates( ic ) - l_geom.sdo_ordinates( ic - l_dim )), 2) +
                                POWER( (l_geom.sdo_ordinates( ic + 1 ) - l_geom.sdo_ordinates( ic + 1 - l_dim )), 2));

  --          nm_debug.debug('Tol estimate = '||to_char(l_g_diff));

            ELSIF l_dim > 3 THEN

              l_g_diff := SQRT( POWER( (l_geom.sdo_ordinates( ic ) - l_geom.sdo_ordinates( ic - l_dim )), 2) +
                              POWER( (l_geom.sdo_ordinates( ic + 1 ) - l_geom.sdo_ordinates( ic + 1 - l_dim )), 2) +
                              POWER( (l_geom.sdo_ordinates( ic + 2 ) - l_geom.sdo_ordinates( ic + 2 - l_dim )), 2));
  --          nm_debug.debug('Tol estimate = '||to_char(l_g_diff));

            ELSE

              Hig.raise_ner(pi_appl                => Nm3type.c_hig
                           ,pi_id                 => 248
                           ,pi_sqlcode            => -20001
                            );
--            raise_application_error(-20001, 'Dimension information is incomopatible with operation');

            END IF;

            l_m_diff := ABS( l_geom.sdo_ordinates( ic + l_dim -1) - l_geom.sdo_ordinates( ic - 1));
  --        nm_debug.debug('Tol estimate = '||to_char(l_m_diff));

          ELSE

  --        no use of lrs - just use a tolerance based on the dimension

            IF l_dim = 3 THEN

              l_g_diff := SQRT( POWER( (l_geom.sdo_ordinates( ic ) - l_geom.sdo_ordinates( ic - l_dim )), 2) +
                              POWER( (l_geom.sdo_ordinates( ic + 1 ) - l_geom.sdo_ordinates( ic + 1 - l_dim )), 2) +
                              POWER( (l_geom.sdo_ordinates( ic + 2 ) - l_geom.sdo_ordinates( ic + 2 - l_dim )), 2));

  --          nm_debug.debug('Tol estimate = '||to_char(l_g_diff));


            ELSIF l_dim = 2 THEN

              l_g_diff := SQRT( POWER( (l_geom.sdo_ordinates( ic ) - l_geom.sdo_ordinates( ic - l_dim )), 2) +
                                POWER( (l_geom.sdo_ordinates( ic + 1 ) - l_geom.sdo_ordinates( ic + 1 - l_dim )), 2));

  --          nm_debug.debug('Tol estimate = '||to_char(l_g_diff));
            END IF;

          END IF;

          FOR dimrec IN 1..l_dim LOOP

            IF dimrec = 1 OR dimrec = 2 OR l_lrs = 0 THEN

              IF retval(dimrec) > l_g_diff THEN
                retval(dimrec) := 0.5 * POWER(10, TRUNC( ( 1 + LOG( 10, l_g_diff))-1));
  --            nm_debug.debug('Updating - dim '||to_char(dimrec)||' tolerance '||to_char( retval(dimrec)));
              END IF;

            ELSE

              IF retval(dimrec) > l_m_diff THEN
                retval(dimrec) := 0.5 * POWER(10, TRUNC( ( 1 + LOG( 10, l_m_diff))-1));
  --            nm_debug.debug('Updating - M tolerance '||to_char( retval(dimrec)));
              END IF;

            END IF;

          END LOOP; --dimrec

        END LOOP;

      END IF;  --skip user defined geometries

    END LOOP;
  END LOOP;


--  for i in 1..l_dim loop
--    nm_debug.debug('Tol '||to_char(i)||' = '||to_char(retval(i)));
--  end loop;

  RETURN retval;

END;

--
---------------------------------------------------------------------------------------------------------------------------------
--

PROCEDURE drop_metadata ( p_object_name IN VARCHAR2 ) IS

BEGIN

    DELETE FROM mdsys.sdo_geom_metadata_table
    WHERE sdo_table_name = p_object_name
 AND   sdo_owner = Hig.get_application_owner;

END;

--
---------------------------------------------------------------------------------------------------------------------------------
--
-- Task 0108546
-- No longer used
--
--FUNCTION strip_user_elem_info( p_elem_info IN mdsys.sdo_elem_info_array )
--     RETURN mdsys.sdo_elem_info_array IS


--l_ret mdsys.sdo_elem_info_array;
--l_ind INTEGER;
--l_new INTEGER;

--BEGIN

--  l_ret := mdsys.sdo_elem_info_array();
--  l_new := 0;

--  IF p_elem_info IS NULL THEN
--    l_ret := NULL;
--  ELSE

--    FOR i IN 1..p_elem_info.LAST/3 LOOP

--      l_ind := 3*(i-1) + 2;

--      IF p_elem_info(l_ind) >  0 THEN

--        l_new := l_new+1;
--        l_ret.EXTEND;
--        l_ret(l_ret.LAST) := p_elem_info( l_ind -1 );
--        l_ret.EXTEND;
--        l_ret(l_ret.LAST) := p_elem_info( l_ind );
--        l_ret.EXTEND;
--        l_ret(l_ret.LAST) := p_elem_info( l_ind+1 );

--      END IF;
--    END LOOP;
--  END IF;

--  RETURN l_ret;
--END;

--
---------------------------------------------------------------------------------------------------------------------------------
--
-- Task 0108546
-- No longer used
--
--FUNCTION strip_user_parts ( p_geom IN mdsys.sdo_geometry ) RETURN mdsys.sdo_geometry IS

--l_ret mdsys.sdo_geometry;
--l_ord mdsys.sdo_ordinate_array;
--l_dim INTEGER := p_geom.get_dims;        --dimension of geometry
--l_new INTEGER;                           --index to the new ordinates
--l_start INTEGER;
--l_last  INTEGER;
--l_last_ord_ind INTEGER;                           --index to the last original ordinates in part

--l_elem_info mdsys.sdo_elem_info_array := p_geom.sdo_elem_info;
--l_new_elem_info mdsys.sdo_elem_info_array;

--BEGIN

--  l_new_elem_info := strip_user_elem_info( l_elem_info);

--  l_ord := mdsys.sdo_ordinate_array();

--  IF p_geom.sdo_elem_info IS NULL OR   --Either the geometry uses the point type or no restriction.
--     l_new_elem_info IS NULL THEN
--    RETURN p_geom;
--  END IF;

--  l_last := l_new_elem_info.LAST/3;

--  FOR i IN 1..l_last LOOP

--    l_start := l_new_elem_info((i-1)*3 + 1);

--    IF i = l_last THEN

--      l_last_ord_ind := p_geom.sdo_ordinates.LAST;

--    ELSE

--      l_last_ord_ind := l_last + 1;

--    END IF;

--    FOR j IN l_start..l_last_ord_ind LOOP

--      l_ord.EXTEND;
--      l_ord(l_ord.LAST) := p_geom.sdo_ordinates(j);

--    END LOOP;

--  END LOOP;

--  l_ret := mdsys.sdo_geometry ( p_geom.sdo_gtype,
--                                p_geom.sdo_srid, p_geom.sdo_point,
--                             -- Task 0108546
--                             -- No longer used
--                             --   modify_user_elem_info( l_elem_info), l_ord );
--                                l_elem_info, l_ord );

--  RETURN l_ret;
--END;

--
---------------------------------------------------------------------------------------------------------------------------------
--
-- Task 0108546
-- No longer used
--
--FUNCTION modify_user_elem_info( p_elem_info IN mdsys.sdo_elem_info_array )
--     RETURN mdsys.sdo_elem_info_array IS

--l_ret mdsys.sdo_elem_info_array;
--l_ind INTEGER;
--l_new INTEGER;

--BEGIN

--  l_ret := mdsys.sdo_elem_info_array();
--  l_new := 0;

--  IF p_elem_info IS NULL THEN
--    l_ret := NULL;
--  ELSE
--    FOR i IN 1..p_elem_info.LAST/3 LOOP

--      l_ind := 3*i - 1;

--      IF p_elem_info(l_ind) >  0 THEN

--        l_new := l_new+1;
--        l_ret.EXTEND;
--        l_ret(l_ret.LAST) := l_new;
--        l_ret.EXTEND;
--        l_ret(l_ret.LAST) := p_elem_info( l_ind );
--        l_ret.EXTEND;
--        l_ret(l_ret.LAST) := p_elem_info( l_ind+1 );

--      END IF;
--    END LOOP;
--  END IF;

--  RETURN l_ret;
--END;
--
----------------------------------------------------------------------------
--
PROCEDURE create_sub_sdo_layer (
   p_theme_id   IN   NM_THEMES_ALL.nth_theme_id%TYPE,
   p_username   IN   HIG_USERS.hus_username%TYPE)
IS
  -- Constants
   using_sdm_subuser_reg    CONSTANT BOOLEAN := Hig.get_sysopt ('SDMREGULYR') = 'Y';
   registering_sde_layers   CONSTANT BOOLEAN := Hig.get_sysopt ('REGSDELAY') = 'Y';
   using_public_synonyms    CONSTANT BOOLEAN := Hig.get_sysopt ('HIGPUBSYN') = 'Y';
--
   CURSOR c1
   IS
      SELECT s.owner, s.table_name, s.column_name, s.diminfo, s.srid
        FROM NM_THEMES_ALL, all_sdo_geom_metadata s
       WHERE nth_feature_table = table_name
         AND nth_theme_id = p_theme_id
         AND owner = Hig.get_application_owner;
--
   l_nth           NM_THEMES_ALL%ROWTYPE;
   l_user          HIG_USERS.hus_username%TYPE   := UPPER (p_username);
   l_owner         VARCHAR2 (30)
      := Nm3context.get_context (Nm3context.get_namespace,
                                 'APPLICATION_OWNER');
--
   PROCEDURE check_user (pi_username IN HIG_USERS.HUS_USERNAME%TYPE)
   IS
      l_rec_hus HIG_USERS%ROWTYPE;
   BEGIN
      l_rec_hus := Nm3user.get_hus(pi_hus_username => pi_username);
      IF l_rec_hus.HUS_USER_ID IS NULL
       THEN
         Hig.raise_ner
            ( pi_appl               => Nm3type.c_hig
            , pi_id                 => 80
            , pi_supplementary_info => pi_username);
      END IF;
   END check_user;
--
BEGIN
--
   IF using_sdm_subuser_reg
    THEN
      --
      l_nth := Nm3get.get_nth (p_theme_id);
      --
      check_user (l_user);
      --
      IF l_nth.nth_theme_type = Nm3sdo.c_sdo
       THEN
         FOR i IN c1
         LOOP
            BEGIN
           --  nm_debug.debug_on;
--               Nm_Debug.DEBUG('Create SDO data for '||l_user||'-'||i.table_name);
               INSERT INTO all_sdo_geom_metadata
                           (owner, table_name, column_name, diminfo,
                            srid
                           )
                    VALUES (l_user, i.table_name, i.column_name, i.diminfo,
                            i.srid
                           );

            EXCEPTION
               WHEN DUP_VAL_ON_INDEX THEN NULL;
               WHEN OTHERS THEN RAISE;
            END ;
         END LOOP;
         --
         IF registering_sde_layers
         AND NOT using_public_synonyms
          THEN
            BEGIN
              EXECUTE IMMEDIATE
                (' begin nm3sde.create_sub_sde_layer ( p_theme_id => '|| TO_CHAR (p_theme_id)
              || ',p_username => '''|| TO_CHAR (p_username)|| ''');'|| ' end;');
            EXCEPTION
              WHEN OTHERS
                THEN
                -- Instead of whole process falling over, log the error and carry on
                  Nm_Debug.debug_on;
                  Nm_Debug.DEBUG ('Error copying SDE layer for '||p_theme_id);
                  Nm_Debug.debug_off;
            END;

         END IF;

         IF registering_sde_layers
         AND using_public_synonyms
          THEN
            -- Create a private synonym as SDE doesn't like public ones.
            BEGIN
              Nm3ddl.create_synonym_for_object
                 ( p_object_name => l_nth.nth_feature_table
                 , p_syn_type    => 'PRIVATE' );

              EXECUTE IMMEDIATE
                 (' begin nm3sde.create_sub_sde_layer ( p_theme_id => '
                 || TO_CHAR (p_theme_id)|| ',p_username => '''||TO_CHAR (p_username)
                 || ''');'|| ' end;');
            EXCEPTION
              WHEN OTHERS
                THEN
                -- Instead of whole process falling over, log the error and carry on
                  Nm_Debug.debug_on;
                  Nm_Debug.DEBUG ('Error copying SDE layer for '||p_theme_id);
                  Nm_Debug.debug_off;
            END;

         END IF;
      END IF;
   END IF;
END create_sub_sdo_layer;
--
----------------------------------------------------------------------------
--
PROCEDURE remove_sub_sdo_layer
            ( p_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE
            , p_username IN HIG_USERS.hus_username%TYPE)
IS
  -- Constants
   using_sdm_subuser_reg CONSTANT BOOLEAN := Hig.get_sysopt ('SDMREGULYR') = 'Y';
   l_rec_nth                      NM_THEMES_ALL%ROWTYPE;
BEGIN
   IF using_sdm_subuser_reg
   THEN
      l_rec_nth := Nm3get.get_nth(p_theme_id);
      drop_sub_layer_by_table (l_rec_nth.nth_feature_table
                              ,l_rec_nth.nth_feature_shape_column
                              ,p_username);
   END IF;
END remove_sub_sdo_layer;
--
----------------------------------------------------------------------------
--
PROCEDURE drop_sub_layer_by_table
/*
   This procedure is used for clearing out subordinate users SDO metadata. This
   is called either from NM_THEME_ROLES or HIG_USER_ROLE events.
   The procedure will derive users that have metadata for a certain shape table
   OR will accept owner as a parameter

   SDE metadata will also be cleared down where appropriate
*/
            ( p_table    IN VARCHAR2
            , p_column   IN VARCHAR2
            , p_owner    IN VARCHAR2 DEFAULT NULL)

IS

   CURSOR get_sdo_owner
                  ( cp_table  IN VARCHAR2
                  , cp_column IN VARCHAR2 )
   IS
     SELECT owner
       FROM all_sdo_geom_metadata, HIG_USERS
      WHERE owner  = hus_username
        AND owner != Hig.get_application_owner
        AND table_name = cp_table
        AND column_name = cp_column;

   using_sde_layers CONSTANT BOOLEAN := Hig.get_sysopt('REGSDELAY') = 'Y';
   c_str            Nm3type.max_varchar2;
--
   PROCEDURE delete_sdo_metadata
               (pi_table_name IN VARCHAR2
               ,pi_column     IN VARCHAR2
               ,pi_owner      IN VARCHAR2)
   IS
   BEGIN
-- AE
-- Task 0108674 - Add MDSYS prefix
      DELETE FROM mdsys.sdo_geom_metadata_table
       WHERE sdo_owner = pi_owner
         AND sdo_table_name = pi_table_name
         AND sdo_column_name = pi_column;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN NULL;
      WHEN OTHERS
      THEN RAISE;
   END delete_sdo_metadata;
--
BEGIN
--
   IF p_owner IS NULL
   THEN
      FOR i IN get_sdo_owner (p_table, p_column)
       LOOP
         delete_sdo_metadata (p_table, p_column, i.owner);
      END LOOP;
      IF using_sde_layers
      THEN
         c_str := 'begin '||
                    'nm3sde.drop_sub_layer_by_table( '
                      ||Nm3flx.string(p_table)||','
                      ||Nm3flx.string(p_column)||');'
               ||' end;';
         EXECUTE IMMEDIATE c_str;
      END IF;
   ELSE
      delete_sdo_metadata (p_table, p_column, p_owner);
      IF using_sde_layers
      THEN
         c_str := 'begin '||
                     'nm3sde.drop_sub_layer_by_table( '
                       ||Nm3flx.string(p_table)||','
                       ||Nm3flx.string(p_column)||','
                       ||Nm3flx.string(p_owner)||');'
               ||' end;';
        EXECUTE IMMEDIATE c_str;
      END IF;
   END IF;
END drop_sub_layer_by_table;

----------------------------------------------------------------------------

FUNCTION get_distance( p_theme IN NUMBER, p_pk IN NUMBER, p_x IN NUMBER, p_y IN NUMBER ) RETURN NUMBER IS

cur_string VARCHAR2(2000);

retval NUMBER;

l_nth NM_THEMES_ALL%ROWTYPE;

l_nth_meta user_sdo_geom_metadata%ROWTYPE := get_theme_metadata( p_theme );

l_pt_diminfo  mdsys.sdo_dim_array;


BEGIN

  l_nth := Nm3get.get_nth( p_theme );

  l_pt_diminfo := l_nth_meta.diminfo;

  IF get_dimension( l_pt_diminfo ) = 3 THEN
    l_pt_diminfo := sdo_lrs.convert_to_std_dim_array(l_pt_diminfo);
  END IF;

  cur_string := 'select sdo_geom.sdo_distance( '||l_nth.nth_feature_shape_column||', :l_nth_diminfo, '||
        'mdsys.sdo_geometry( 2001, :l_nth_srid, mdsys.sdo_point_type( :p_x, :p_y, null), null, null), :l_diminfo )'||
  ' from  '||l_nth.nth_feature_table||
  ' where '||l_nth.nth_feature_pk_column||' = :PK';


  EXECUTE IMMEDIATE cur_string INTO retval USING l_nth_meta.diminfo, l_nth_meta.srid, p_x, p_y, l_pt_diminfo, p_pk;
  RETURN retval;

END;

----------------------------------------------------------------------------

FUNCTION within_tolerance( p_theme IN NUMBER, p_pk IN NUMBER, p_x IN NUMBER, p_y IN NUMBER ) RETURN VARCHAR2 IS

cur_string VARCHAR2(2000);

retval VARCHAR2(10);

l_dist NUMBER;

l_nth NM_THEMES_ALL%ROWTYPE;

l_nth_meta user_sdo_geom_metadata%ROWTYPE := get_theme_metadata( p_theme );

l_pt_diminfo  mdsys.sdo_dim_array;


BEGIN

  l_nth := Nm3get.get_nth( p_theme );

  l_pt_diminfo := l_nth_meta.diminfo;

  IF get_dimension( l_pt_diminfo ) = 3 THEN
    l_pt_diminfo := sdo_lrs.convert_to_std_dim_array(l_pt_diminfo);
  END IF;

  cur_string := 'select sdo_geom.sdo_distance( '||l_nth.nth_feature_shape_column||', :l_nth_diminfo, '||
        'mdsys.sdo_geometry( 2001, :l_nth_srid, mdsys.sdo_point_type( :p_x, :p_y, null), null, null), :l_diminfo )'||
  ' from  '||l_nth.nth_feature_table||
  ' where '||l_nth.nth_feature_pk_column||' = :PK';


  EXECUTE IMMEDIATE cur_string INTO l_dist USING l_nth_meta.diminfo, l_nth_meta.srid, p_x, p_y, l_pt_diminfo, p_pk;

  IF l_dist <= l_nth.nth_tolerance THEN
    retval := 'TRUE';
  ELSE
    retval := 'FALSE';
  END IF;

  RETURN retval;

END;


--
----------------------------------------------------------------------------
--

FUNCTION Make_Single_Part( p_geom IN mdsys.sdo_geometry, p_diminfo IN mdsys.sdo_dim_array ) RETURN mdsys.sdo_geometry IS

lp NUMBER;
ld NUMBER;
lnd NUMBER;
l_tol NUMBER := p_diminfo(1).sdo_tolerance;

l_geom  mdsys.sdo_geometry;

retval   mdsys.sdo_geometry;

lc      NUMBER := 0;
l_ga    nm_geom_array;

l_used  int_array := Nm3array.INIT_INT_ARRAY;

FUNCTION used ( l_ia IN OUT NOCOPY int_array, l_i IN INTEGER  ) RETURN BOOLEAN IS
l_dummy INTEGER;
BEGIN
  SELECT 1 INTO l_dummy FROM TABLE ( l_ia.ia ) a
  WHERE COLUMN_VALUE = l_i;
  RETURN TRUE;
EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;
END;

BEGIN

--  Nm_Debug.debug_on;

  l_ga := get_parts( p_geom );

  lp := l_ga.nga.LAST;

  IF lp = 1 THEN
    RETURN p_geom;
  END IF;

  ld := p_geom.get_dims;

  retval := l_ga.nga(1).ng_geometry;

  l_used.ia(1) := 1;

--  Nm_Debug.DEBUG('Set the first part');

  WHILE l_used.ia.LAST < lp LOOP

    IF lc > 20 THEN
      EXIT;
    END IF;

    lc := lc + 1;

    FOR i IN 2..lp LOOP

      IF NOT used( l_used, i ) THEN

--        Nm_Debug.DEBUG('Part '||TO_CHAR(i)||' is unused');

        IF compare_pt( Nm3sdo.get_2d_pt(sdo_lrs.geom_segment_end_pt( retval )), Nm3sdo.get_2d_pt(sdo_lrs.geom_segment_start_pt( l_ga.nga(i).ng_geometry)) , l_tol ) = 'TRUE' THEN

--          Nm_Debug.DEBUG('Part '||TO_CHAR(i)||' is connected');

          Nm3sdo.add_segments(retval, l_ga.nga(i).ng_geometry, p_diminfo, TRUE );
          l_used.ia.EXTEND;
          l_used.ia(l_used.ia.LAST) := i;
          EXIT;

        ELSIF compare_pt( Nm3sdo.get_2d_pt(sdo_lrs.geom_segment_end_pt( retval )), Nm3sdo.get_2d_pt(sdo_lrs.geom_segment_end_pt( l_ga.nga(i).ng_geometry)), l_tol ) = 'TRUE' THEN

--          Nm_Debug.DEBUG('Part '||TO_CHAR(i)||' is connected after reverse');

          l_geom := Nm3sdo.reverse_geometry(l_ga.nga(i).ng_geometry );
          Nm3sdo.add_segments(retval, l_geom, p_diminfo, TRUE);
          l_used.ia.EXTEND;
          l_used.ia(l_used.ia.LAST) := i;
          EXIT;

        ELSE

--          Nm_Debug.DEBUG( 'No connection' );
          null;

        END IF;

      END IF;

    END LOOP;

  END LOOP;

  RETURN retval;

END;

--
----------------------------------------------------------------------------
--


FUNCTION get_distance_between_parts( p_geom IN mdsys.sdo_geometry ) RETURN NUMBER IS

lp NUMBER;
ld NUMBER;
p1 NUMBER;

lpt1 mdsys.sdo_geometry;
lpt2 mdsys.sdo_geometry;

dist     Nm3type.tab_number;
sum_dist NUMBER := 0;

lc     NUMBER;

retval NUMBER;

BEGIN

  lp := Nm3sdo.get_no_parts(p_geom);
  ld := p_geom.get_dims;

--  nm_debug.debug_on;
--  nm_debug.delete_debug(true);
--  nm_debug.debug( 'Start - no of parts = '||to_char( lp )||' no of dim = '||to_char(ld ));

  IF lp > 3 THEN

    FOR i IN 2..lp/3 LOOP

      p1   := p_geom.sdo_elem_info( 3*(i-1) + 1);

--      nm_debug.debug('Break - next ordinate at '||to_char(p1));

      lpt1 := mdsys.sdo_geometry( 2001, NULL, mdsys.sdo_point_type( p_geom.sdo_ordinates( p1 - ld), p_geom.sdo_ordinates( p1 - ld + 1), NULL), NULL, NULL);

      lpt2 := mdsys.sdo_geometry( 2001, NULL, mdsys.sdo_point_type( p_geom.sdo_ordinates( p1 ), p_geom.sdo_ordinates( p1 + 1), NULL), NULL, NULL);

   dist(i) := sdo_geom.sdo_distance( lpt1, lpt2, .005);

--      nm_debug.debug( 'between ('||to_char( p_geom.sdo_ordinates( p1 - ld))||','||to_char( p_geom.sdo_ordinates( p1 - ld + 1))||') and ('||
--                                to_char( p_geom.sdo_ordinates( p1 ))||','||to_char( p_geom.sdo_ordinates( p1 + 1))||') ');

--     nm_debug.debug('distance at gap '||to_char(p1)||' = '||to_char( dist(i)));

   sum_dist := sum_dist + dist(i);

   lc := i - 1;

    END LOOP;

 retval := sum_dist/( lc );

  ELSE

    retval := 0;

  END IF;

  RETURN retval;

END;


--
----------------------------------------------------------------------------
--


FUNCTION get_objects_in_buffer( p_nth_id         IN NUMBER,
                                p_geometry       IN mdsys.sdo_geometry,
                                p_buffer         IN NUMBER,
                                p_buffer_units   IN NUMBER DEFAULT 1,
                                p_get_projection IN VARCHAR2 DEFAULT 'FALSE',
                                p_gdo_session_id IN gis_data_objects.gdo_session_id%TYPE DEFAULT NULL )
  RETURN nm_theme_list
IS

-- AE 11-JUN-2009
-- Added p_gdo_session_id parameter for sub-selections based on gis_data_objects
-- p_gdo_session_id is now picked up in the dynamic sql predicates if populated


  cur_string            nm3type.max_varchar2;
  l_pk_array            nm3type.tab_number;
  l_fk_array            nm3type.tab_number;
  l_label_array         nm3type.tab_varchar4000;  --use this so that the full amount of space is not reserved.
  l_dist_array          nm3type.tab_number;
  l_meas_array          nm3type.tab_number;
  l_feat_pk             nm3type.tab_number;
  l_l_ref               nm_lref := nm_lref(NULL, NULL);

  retval                nm_theme_list := nm_theme_list( nm_theme_list_type ( nm_theme_detail ( NULL, NULL, NULL, NULL, NULL, NULL, NULL)));
  l_detail              nm_theme_detail;

  p_nth                 nm_themes_all%ROWTYPE := nm3get.get_nth( p_nth_id );
  l_dim                 mdsys.sdo_dim_array := nm3sdo.get_theme_diminfo( p_nth_id );
  l_tol                 NUMBER ;

  lcur                  nm3type.ref_cursor;
  ic                    BINARY_INTEGER;

  l_get_projection      BOOLEAN := FALSE;
  l_c_unit              INTEGER;
  l_p_unit              INTEGER;

  l_nth                 nm_themes_all%ROWTYPE;
  l_valid               nm3type.max_varchar2;
  l_geometry            mdsys.sdo_geometry := p_geometry;

--l_distance    number;
--l_measure     number;

  FUNCTION is_nw_theme( p_theme IN NUMBER ) RETURN BOOLEAN IS
  CURSOR c1( c_theme IN NUMBER ) IS
    SELECT 1 FROM NM_NW_THEMES
    WHERE nnth_nth_theme_id = c_theme;
  dummy  INTEGER;
  retval BOOLEAN;
  BEGIN
    OPEN c1( p_theme );
    FETCH c1 INTO dummy;
    retval := c1%FOUND;
    CLOSE c1;
    RETURN retval;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN FALSE;
  END is_nw_theme;

BEGIN

  l_tol :=  Nm3sdo.get_table_diminfo( p_nth.nth_feature_table, p_nth.nth_feature_shape_column )(1).sdo_tolerance;

  l_valid := validate_geometry( l_geometry, NULL, l_tol );

-- AE 28-APR-2009
-- Rectify the polygon and validate again.
  IF l_valid != 'TRUE' AND l_geometry.sdo_gtype = 2003
  THEN
    l_geometry := sdo_util.rectify_geometry(sdo_util.remove_duplicate_vertices( l_geometry, l_tol), l_tol);
    l_valid := validate_geometry( l_geometry, NULL, l_tol );
  END IF;

  IF l_valid != 'TRUE' THEN
    IF l_valid = 'FALSE' THEN
       RAISE_APPLICATION_ERROR(-20001, 'Invalid Geometry');
    ELSE
       RAISE_APPLICATION_ERROR(-20001, 'Invalid Geometry - error code '||TO_CHAR(l_valid));
    END IF;
  END IF;


--  IF p_get_projection = 'TRUE' THEN
--    IF NOT is_nw_theme( p_nth_id ) THEN
--      Hig.raise_ner(pi_appl                => Nm3type.c_hig
--                    ,pi_id                 => 291
--                    ,pi_sqlcode            => -20001
--                    );
----    RAISE_APPLICATION_ERROR( -20001, 'Theme is not a linear referencing layer - cannot return projections');
--
--    ELSIF l_geometry.sdo_gtype != 2001 THEN
--      Hig.raise_ner(pi_appl                => Nm3type.c_hig
--                    ,pi_id                 => 292
--                    ,pi_sqlcode            => -20001
--                    );
----      RAISE_APPLICATION_ERROR( -20001, 'Cannot find position to project from');
--
--    ELSE
--      l_get_projection := ( p_get_projection = 'TRUE');
--    END IF;
--  END IF;

--RAC - the projection needs to work dynamically when used with the ID tool - it should return the disatnce to the object and, when the object s a network object,
--      it should return the distance (measure) along the object.

  l_get_projection := ( p_get_projection = 'TRUE');

  l_nth := p_nth;

  IF p_nth.nth_base_table_theme IS NOT NULL THEN
    l_nth := Nm3get.get_nth( l_nth.nth_base_table_theme);
  END IF;

  IF l_nth.nth_feature_table = l_nth.nth_table_name THEN

     cur_string := 'select distinct t.'||l_nth.nth_pk_column||',t.'||SUBSTR(l_nth.nth_label_column,1,100)||', null'||', t.'||l_nth.nth_pk_column;

     IF l_get_projection THEN

       cur_string := cur_string||', sdo_geom.sdo_distance(t.'||l_nth.nth_feature_shape_column||', :p_geometry, :l_tol )';

       IF is_nw_theme( p_nth_id ) THEN

       cur_string := cur_string||', sdo_lrs.get_measure( sdo_lrs.project_pt(t.'||l_nth.nth_feature_shape_column||', :p_geometry ))';

       ELSE

         cur_string := cur_string||', null ';

       END IF;

     END IF;

     IF p_gdo_session_id IS NOT NULL AND NOT l_get_projection
     THEN

--       cur_string := cur_string||' from '||l_nth.nth_table_name||' t, gis_data_objects g '
--           ||' where gdo_session_id = '||to_char(p_gdo_session_id)||' and gdo_pk_id = '||l_nth.nth_feature_pk_column||' and '||
--           ' sdo_within_distance ( t.'||l_nth.nth_feature_shape_column||', :shape, '||
--           ''''||'distance = '||TO_CHAR(p_buffer)||''''||' ) = '||''''||'TRUE'||'''';

-- AE 4100

       cur_string := cur_string||' from '||l_nth.nth_table_name||' t, gis_data_objects g '
           ||' where gdo_session_id = '||to_char(p_gdo_session_id)||' and gdo_pk_id = '||l_nth.nth_pk_column||' and '||
           ' sdo_within_distance ( t.'||l_nth.nth_feature_shape_column||', :shape, '||
           ''''||'distance = '||TO_CHAR(p_buffer)||''''||' ) = '||''''||'TRUE'||'''';

     else
       cur_string := cur_string||' from '||l_nth.nth_table_name||' t '
           ||' where sdo_within_distance ( t.'||l_nth.nth_feature_shape_column||', :shape, '||
           ''''||'distance = '||TO_CHAR(p_buffer)||''''||' ) = '||''''||'TRUE'||'''';
     end if;

  ELSIF p_nth.nth_feature_fk_column IS NOT NULL THEN

     cur_string := 'select distinct t.'||l_nth.nth_pk_column||',t.'||SUBSTR(l_nth.nth_label_column,1,100)||', null'||', f.'||l_nth.nth_feature_pk_column;

     IF l_get_projection THEN

       cur_string := cur_string||', sdo_geom.sdo_distance(f.'||l_nth.nth_feature_shape_column||', :p_geometry, :l_tol )';

       IF is_nw_theme( p_nth_id ) THEN

       cur_string := cur_string||', sdo_lrs.get_measure( sdo_lrs.project_pt(f.'||l_nth.nth_feature_shape_column||', :p_geometry ))';

       ELSE

         cur_string := cur_string||', null ';

       END IF;
     END IF;

     IF p_gdo_session_id IS NOT NULL and not l_get_projection
     THEN

--       cur_string := cur_string||' from '||l_nth.nth_table_name||' t, '||l_nth.nth_feature_table||' f, gis_data_objects g '
--             ||' where g.gdo_session_id = '||to_char(p_gdo_session_id)||' and g.gdo_pk_id = t.'||l_nth.nth_feature_pk_column
--             ||' and sdo_within_distance ( f.'||l_nth.nth_feature_shape_column||', :shape, '
--             ||''''||'distance = '||TO_CHAR(p_buffer)||''''||') = '||''''||'TRUE'||''''
--             ||' and t.'||l_nth.nth_pk_column||' = f.'||l_nth.nth_feature_pk_column;


-- AE 4100

       cur_string := cur_string||' from '||l_nth.nth_table_name||' t, '||l_nth.nth_feature_table||' f, gis_data_objects g '
             ||' where g.gdo_session_id = '||to_char(p_gdo_session_id)||' and g.gdo_pk_id = t.'||l_nth.nth_pk_column
             ||' and sdo_within_distance ( f.'||l_nth.nth_feature_shape_column||', :shape, '
             ||''''||'distance = '||TO_CHAR(p_buffer)||''''||') = '||''''||'TRUE'||''''
             ||' and t.'||l_nth.nth_pk_column||' = f.'||l_nth.nth_feature_pk_column;
     ELSE

       cur_string := cur_string||' from '||l_nth.nth_table_name||' t, '||l_nth.nth_feature_table||' f'
             ||' where sdo_within_distance ( f.'||l_nth.nth_feature_shape_column||', :p_geometry, '
             ||''''||'distance = '||TO_CHAR(p_buffer)||''''||') = '||''''||'TRUE'||''''
             ||' and t.'||l_nth.nth_pk_column||' = f.'||l_nth.nth_feature_fk_column;

     END IF;

   ELSE

     cur_string := 'select distinct t.'||l_nth.nth_pk_column||',t.'||SUBSTR(l_nth.nth_label_column,1,100)||', null'||', f.'||l_nth.nth_feature_pk_column;

     IF l_get_projection THEN

       cur_string := cur_string||', sdo_geom.sdo_distance(f.'||l_nth.nth_feature_shape_column||', :p_geometry, :l_tol )';

       IF is_nw_theme( p_nth_id ) THEN

       cur_string := cur_string||', sdo_lrs.get_measure( sdo_lrs.project_pt(f.'||l_nth.nth_feature_shape_column||', :p_geometry ))';

       ELSE

         cur_string := cur_string||', null ';

       END IF;

     END IF;

     IF p_gdo_session_id IS NOT NULL and not l_get_projection
     THEN

--       cur_string := cur_string||' from '||l_nth.nth_table_name||' t, '||l_nth.nth_feature_table||' f, gis_data_objects g '
--             ||' where g.gdo_session_id = '||to_char(p_gdo_session_id)||' and g.gdo_pk_id = t.'||l_nth.nth_feature_pk_column
--             ||' and sdo_within_distance ( f.'||l_nth.nth_feature_shape_column||', :shape, '
--             ||''''||'distance = '||TO_CHAR(p_buffer)||''''||') = '||''''||'TRUE'||''''
--             ||' and t.'||l_nth.nth_pk_column||' = f.'||l_nth.nth_feature_pk_column;

-- AE 4100

       cur_string := cur_string||' from '||l_nth.nth_table_name||' t, '||l_nth.nth_feature_table||' f, gis_data_objects g '
             ||' where g.gdo_session_id = '||to_char(p_gdo_session_id)||' and g.gdo_pk_id = t.'||l_nth.nth_pk_column
             ||' and sdo_within_distance ( f.'||l_nth.nth_feature_shape_column||', :shape, '
             ||''''||'distance = '||TO_CHAR(p_buffer)||''''||') = '||''''||'TRUE'||''''
             ||' and t.'||l_nth.nth_pk_column||' = f.'||l_nth.nth_feature_pk_column;

     ELSE

       cur_string := cur_string||' from '||l_nth.nth_table_name||' t, '||l_nth.nth_feature_table||' f'
             ||' where sdo_within_distance ( f.'||l_nth.nth_feature_shape_column||', :p_geometry, '
             ||''''||'distance = '||TO_CHAR(p_buffer)||''''||') = '||''''||'TRUE'||''''
             ||' and t.'||l_nth.nth_pk_column||' = f.'||l_nth.nth_feature_pk_column;

     END IF;

  END IF;

--Nm_Debug.debug_on;
--Nm_Debug.DEBUG( cur_string );

--nm_debug.debug('Execute statement');

  IF l_get_projection THEN

    IF is_nw_theme( p_nth_id ) THEN

    EXECUTE IMMEDIATE cur_string BULK COLLECT INTO l_pk_array, l_label_array, l_fk_array, l_feat_pk, l_dist_array, l_meas_array USING l_geometry, l_tol, l_geometry, l_geometry;

  ELSE

       EXECUTE IMMEDIATE cur_string BULK COLLECT INTO l_pk_array, l_label_array, l_fk_array, l_feat_pk, l_dist_array, l_meas_array USING l_geometry, l_tol, l_geometry;

    END IF;

  ELSE

    EXECUTE IMMEDIATE cur_string BULK COLLECT INTO l_pk_array, l_label_array, l_fk_array, l_feat_pk USING l_geometry;

  END IF;

--nm_debug.debug('Finished statement - returned '||to_char(l_pk_array.count));

  FOR i IN 1..l_pk_array.COUNT LOOP

    if l_pk_array(i) is not null then

      IF l_get_projection and is_nw_theme( p_nth_id ) THEN

        IF Nm3net.is_nt_datum( Nm3net.Get_Nt_Type( l_pk_array(i) ) )  = 'N' THEN

  --      make sure we are dealing in correct units. The shape lengths are in datum units.

          Nm3net.get_group_units( l_pk_array(i), l_p_unit, l_c_unit );

          l_meas_array(i) := Nm3unit.convert_unit ( l_c_unit, l_p_unit, l_meas_array(i) );

        END IF;

      END IF;

      IF i = 1 THEN

        IF l_get_projection THEN

          retval := nm_theme_list ( nm_theme_list_type ( nm_theme_detail (l_nth.nth_theme_id, l_pk_array(i), l_fk_array(i), l_label_array(i), l_dist_array(i), l_meas_array(i), l_nth.nth_theme_name)));
        ELSE
          retval := nm_theme_list ( nm_theme_list_type ( nm_theme_detail ( l_nth.nth_theme_id, l_pk_array(i), l_fk_array(i), l_label_array(i), NULL, NULL, l_nth.nth_theme_name)));
        END IF;
      ELSE
  --    nm_debug.debug(' count = '||to_char(i)||' - adding new detail');

        IF l_get_projection THEN
          retval := retval.add_detail( l_nth.nth_theme_id, l_pk_array(i), l_fk_array(i), l_label_array(i), l_dist_array(i), l_meas_array(i), l_nth.nth_theme_name);
        ELSE
          retval := retval.add_detail( l_nth.nth_theme_id, l_pk_array(i), l_fk_array(i), l_label_array(i), NULL, NULL, l_nth.nth_theme_name);
        END IF;

      END IF;

    END IF;

  END LOOP;

  IF p_nth.nth_base_table_theme IS NOT NULL THEN
-- ensure only those in the view are returned.
    retval :=  join_ntl_array( p_nth, retval );
  END IF;

  RETURN retval;

END get_objects_in_buffer;


--
----------------------------------------------------------------------------
-- Function used by itool to return all theme items for all themes within the buffer
-- (usually) of a point geometry.

FUNCTION get_objects_in_buffer( p_geometry       IN mdsys.sdo_geometry,
                                p_buffer         IN NUMBER,
                                p_buffer_units   IN NUMBER,
                                p_theme_txt      IN VARCHAR2 )
  RETURN nm_theme_list is
--
cursor c_obj ( c_theme_array  in nm_theme_array_type,
               c_geometry     in mdsys.sdo_geometry,
               c_buffer       in number,
               c_buffer_units in number ) is
select nm3sdo.get_objects_in_buffer( nthe_id, c_geometry, c_buffer, c_buffer_units, 'TRUE')
from table ( c_theme_array );

l_theme_array nm_theme_array := get_list(p_theme_txt => p_theme_txt );

l_tmp  nm_theme_list := NM3ARRAY.INIT_NM_THEME_LIST;
retval nm_theme_list := NM3ARRAY.INIT_NM_THEME_LIST;

begin
  open c_obj( l_theme_array.nta_theme_array, p_geometry, p_buffer, p_buffer_units );
  fetch c_obj into retval;
  while c_obj%found loop
    fetch c_obj into l_tmp;
    retval := retval.add_theme_list( l_tmp );
  end loop;
  close c_obj;

  return retval;
end;

--
----------------------------------------------------------------------------
--

FUNCTION get_nw_snaps_at_xy( p_nth_id IN NUMBER, p_geom IN mdsys.sdo_geometry ) RETURN nm_theme_list IS
retval nm_theme_list := nm_theme_list( nm_theme_list_type(nm_theme_detail( NULL, NULL, NULL, NULL, NULL, NULL, NULL)));
l_detail nm_theme_detail;

CURSOR c1 (c_theme IN NUMBER) IS
  SELECT nts_snap_to
  FROM NM_THEME_SNAPS, NM_NW_THEMES
  WHERE nts_theme_id = c_theme
  AND  nts_snap_to = nnth_nth_theme_id
  AND  EXISTS ( SELECT 1 FROM NM_THEME_ROLES, HIG_USER_ROLES
                WHERE hur_username = USER
    AND hur_role = nthr_role
    AND nthr_theme_id = nnth_nth_theme_id )
  ORDER BY nts_priority;

CURSOR c2 (c_theme IN NUMBER) IS
  SELECT nbth_base_theme
  FROM NM_BASE_THEMES, NM_NW_THEMES
  WHERE nbth_theme_id = c_theme
  AND  nbth_base_theme = nnth_nth_theme_id
  AND  EXISTS ( SELECT 1 FROM NM_THEME_ROLES, HIG_USER_ROLES
                WHERE hur_username = USER
    AND hur_role = nthr_role
    AND nthr_theme_id = nnth_nth_theme_id );

l_theme_list Nm3type.tab_number;

l_get_projection VARCHAR2(5) := 'TRUE';

l_nth   NM_THEMES_ALL%ROWTYPE;
l_ntl   nm_theme_list;

p_nth   NM_THEMES_ALL%ROWTYPE := Nm3get.get_nth(p_nth_id);

BEGIN

--Nm_Debug.debug_on;
--Nm_Debug.DEBUG('Getting themes to snap to for theme = '||TO_CHAR(p_nth_id));

  OPEN c1( p_nth.nth_theme_id );
  FETCH c1 BULK COLLECT INTO l_theme_list;
  CLOSE c1;

  IF l_theme_list.COUNT = 0 THEN

--  No snapping themes so use the base themes of the given layer

    OPEN c2( p_nth.nth_theme_id );
    FETCH c2 BULK COLLECT INTO l_theme_list;
    CLOSE c2;

--    RAISE_APPLICATION_ERROR(-20001,'No snapping themes');

  END IF;

  IF l_theme_list.COUNT > 0 THEN

--    Nm_Debug.DEBUG('Looping through, count = '||TO_CHAR(l_theme_list.COUNT));

    FOR i IN 1..l_theme_list.COUNT LOOP

--      Nm_Debug.DEBUG('Snapping to theme '||TO_CHAR(l_theme_list(i)));

   l_nth := Nm3get.get_nth( l_theme_list(i));

--      Nm_Debug.DEBUG('calling get objects ');

      IF Nm3nta.g_theme_array_flag AND Nm3nta.theme_in_array( l_nth.nth_theme_id, Nm3nta.g_theme_array ) OR
      NOT Nm3nta.g_theme_array_flag THEN

--      Nm_Debug.DEBUG('In theme array');

  l_ntl := Get_Objects_In_Buffer( l_nth.nth_theme_id, p_geom, l_nth.nth_tolerance, l_nth.nth_tol_units, l_get_projection );

--     Nm_Debug.debug_on;

--        Nm_Debug.DEBUG('returned from get objects ');

     IF l_ntl.ntl_theme_list.COUNT > 0 THEN

--        Nm_Debug.DEBUG('Snapped and retrieved '||l_ntl.ntl_theme_list.COUNT||' rows');

       IF l_ntl.ntl_theme_list(1).ntd_pk_id IS NOT NULL THEN

         IF retval.ntl_theme_list(1).ntd_theme_id IS NULL THEN
           retval := l_ntl;
         ELSE
           retval := retval.add_theme_list(l_ntl);
         END IF;
    END IF;
        ELSE

--        Nm_Debug.DEBUG('No rows found');
          NULL;

     END IF;
      END IF;

 END LOOP;

  END IF;

  RETURN retval;

END;
--
---------------------------------------------------------------------------------
FUNCTION get_list(p_theme_txt IN VARCHAR2 ) RETURN nm_theme_array IS

l_theme_txt VARCHAR2(2000);

retval      nm_theme_array;

linit       INTEGER := 0;
lth_id      NUMBER;

BEGIN

    IF p_theme_txt IS NOT NULL THEN

      l_theme_txt := p_theme_txt;

      WHILE INSTR( l_theme_txt, ',' ) > 0 LOOP

--        Nm_Debug.DEBUG('In loop '||l_theme_txt);

        IF INSTR( l_theme_txt, ',' ) > 0 THEN
          lth_id := TO_NUMBER(SUBSTR(l_theme_txt, 1, INSTR( l_theme_txt, ',' ) -1));
--          Nm_Debug.DEBUG('Id = '||TO_CHAR(lth_id));
        END IF;

        IF linit = 0 THEN

          retval := nm_theme_array( nm_theme_array_type(nm_theme_entry(lth_id)));
          linit := 1;

        ELSE

          retval := retval.add_theme( lth_id );

        END IF;


        l_theme_txt := SUBSTR( l_theme_txt, INSTR( l_theme_txt, ',' ) + 1);

      END LOOP;

      lth_id := TO_NUMBER(l_theme_txt);

      IF linit = 0 THEN
        retval := nm_theme_array( nm_theme_array_type(nm_theme_entry(lth_id)));
      ELSE
        retval := retval.add_theme(  lth_id );
      END IF;

      RETURN retval;

    ELSE

      RETURN nm_theme_array( nm_theme_array_type(nm_theme_entry(NULL)));
    END IF;
END;

----------------------------------------------------------------------------------
--
FUNCTION get_nw_snaps_at_xy( p_nth_id IN NUMBER,
                             p_geom IN mdsys.sdo_geometry,
                             p_theme_txt IN VARCHAR2 )
                    RETURN nm_theme_list IS
retval nm_theme_list := nm_theme_list( nm_theme_list_type(nm_theme_detail( NULL, NULL, NULL, NULL, NULL, NULL, NULL)));
l_detail nm_theme_detail;

CURSOR c1 (c_theme IN NUMBER) IS
  SELECT nts_snap_to
  FROM NM_THEME_SNAPS, NM_NW_THEMES
  WHERE nts_theme_id = c_theme
  AND  nts_snap_to = nnth_nth_theme_id
  AND  EXISTS ( SELECT 1 FROM NM_THEME_ROLES, HIG_USER_ROLES
                WHERE hur_username = USER
    AND hur_role = nthr_role
    AND nthr_theme_id = nnth_nth_theme_id )
  ORDER BY nts_priority;

CURSOR c2 (c_theme IN NUMBER) IS
  SELECT nbth_base_theme
  FROM NM_BASE_THEMES, NM_NW_THEMES
  WHERE nbth_theme_id = c_theme
  AND  nbth_base_theme = nnth_nth_theme_id
  AND  EXISTS ( SELECT 1 FROM NM_THEME_ROLES, HIG_USER_ROLES
                WHERE hur_username = USER
    AND hur_role = nthr_role
    AND nthr_theme_id = nnth_nth_theme_id );

l_theme_list Nm3type.tab_number;

l_get_projection VARCHAR2(5) := 'TRUE';

l_nth   NM_THEMES_ALL%ROWTYPE;
l_ntl   nm_theme_list;

p_nth   NM_THEMES_ALL%ROWTYPE := Nm3get.get_nth(p_nth_id);


p_theme_array nm_theme_array;

---------------------------------------------------------------------------------------


BEGIN

--  Nm_Debug.debug_on;
--  Nm_Debug.DEBUG('Getting themes to snap to for theme = '||TO_CHAR(p_nth_id));

  OPEN c1( p_nth.nth_theme_id );
  FETCH c1 BULK COLLECT INTO l_theme_list;
  CLOSE c1;


  IF l_theme_list.COUNT = 0 THEN

--  No snapping themes so use the base themes of the given layer

    OPEN c2( p_nth.nth_theme_id );
    FETCH c2 BULK COLLECT INTO l_theme_list;
    CLOSE c2;

--    RAISE_APPLICATION_ERROR(-20001,'No snapping themes');

  END IF;

  IF l_theme_list.COUNT > 0 THEN

    IF p_theme_txt IS NOT NULL THEN

      p_theme_array := get_list( p_theme_txt );

    END IF;

--    Nm_Debug.DEBUG('Looping through, count = '||TO_CHAR(l_theme_list.COUNT));

    IF p_theme_array.nta_theme_array(1).nthe_id IS NOT NULL THEN

    FOR i IN 1..l_theme_list.COUNT LOOP

--      Nm_Debug.DEBUG('Snapping to theme '||TO_CHAR(l_theme_list(i)));

   l_nth := Nm3get.get_nth( l_theme_list(i));

--      Nm_Debug.DEBUG('calling get objects ');
/*

      IF p_theme_array.nta_theme_array(1).nthe_id IS NULL THEN
        Nm_Debug.DEBUG('Theme array is null');
      ELSE
        Nm_Debug.DEBUG('Theme array is not null - '||TO_CHAR(p_theme_array.nta_theme_array(1).nthe_id));
      END IF;
*/
      IF ( p_theme_array.nta_theme_array(1).nthe_id IS NOT NULL AND Nm3nta.theme_in_array( l_nth.nth_theme_id, p_theme_array )) OR
      ( p_theme_array.nta_theme_array(1).nthe_id IS NULL ) THEN

  --      Nm_Debug.DEBUG('In theme array');

  l_ntl := Get_Objects_In_Buffer( l_nth.nth_theme_id, p_geom, l_nth.nth_tolerance, l_nth.nth_tol_units, l_get_projection );

--     nm_debug.debug_on;

--        Nm_Debug.DEBUG('returned from get objects ');

     IF l_ntl.ntl_theme_list.COUNT > 0 THEN

        nm_debug.debug('Snapped and retrieved '||l_ntl.ntl_theme_list.count||' rows');

/*
        FOR i IN l_ntl.ntl_theme_list.FIRST .. l_ntl.ntl_theme_list.LAST
        LOOP
          nm_debug.debug('Retrived PK = '||l_ntl.ntl_theme_list(i).ntd_pk_id);
          nm_debug.debug('Retrived Name = '||l_ntl.ntl_theme_list(i).ntd_name);
        END LOOP;
*/

       IF l_ntl.ntl_theme_list(1).ntd_pk_id IS NOT NULL THEN

         IF retval.ntl_theme_list(1).ntd_theme_id IS NULL THEN
           retval := l_ntl;
         ELSE
           retval := retval.add_theme_list(l_ntl);
         END IF;
    END IF;
        ELSE

--        nm_debug.debug('No rows found');
          NULL;

     END IF;
      END IF;

 END LOOP;

  END IF;

 END IF;

  RETURN retval;

END;


--
-----------------------------------------------------------------------------
--
   FUNCTION get_usgm (
      pi_table_name    IN   user_sdo_geom_metadata.table_name%TYPE,
      pi_column_name   IN   user_sdo_geom_metadata.column_name%TYPE
   )
      RETURN user_sdo_geom_metadata%ROWTYPE
   IS
      l_rec_usgm   user_sdo_geom_metadata%ROWTYPE;
-- AE
-- Task 0108674 - Add MDSYS prefix
      dummy        mdsys.sdo_geom_metadata_table%ROWTYPE;
   BEGIN
      SELECT *
        INTO dummy
        FROM mdsys.sdo_geom_metadata_table
       WHERE sdo_table_name = pi_table_name
    AND sdo_column_name = pi_column_name
    AND sdo_owner = Hig.get_application_owner;

      l_rec_usgm.table_name := dummy.sdo_table_name;
      l_rec_usgm.column_name := dummy.sdo_column_name;
      l_rec_usgm.diminfo := dummy.sdo_diminfo;
      l_rec_usgm.srid := dummy.sdo_srid;

      RETURN l_rec_usgm;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN l_rec_usgm;
      WHEN OTHERS
      THEN
         RAISE;
   END get_usgm;

--
-----------------------------------------------------------------------------
--
   PROCEDURE get_datum_xy_from_measure (
      p_ne_id     IN       NUMBER,
      p_measure   IN       NUMBER,
      p_x         OUT      NUMBER,
      p_y         OUT      NUMBER
   )
   IS
      l_nt         NM_TYPES.nt_type%TYPE
                            := Nm3get.get_ne (pi_ne_id => p_ne_id).ne_nt_type;
      l_theme_id   NM_THEMES_ALL.nth_theme_id%TYPE;
      l_geom       MDSYS.SDO_GEOMETRY;
      l_sdo        rec_usgm;
      l_rnd        NUMBER;

   BEGIN

      l_theme_id := Get_Datum_Theme (p_nt => l_nt );

      l_sdo := Nm3sdo.get_theme_metadata (l_theme_id);

      IF Nm3sdo.element_has_shape (l_theme_id, p_ne_id) = 'TRUE'
      THEN
         l_geom :=
            get_xy_from_measure (p_layer        => l_theme_id,
                                        p_ne_id        => p_ne_id,
                                        p_measure      => p_measure
                                       );
         l_sdo := get_theme_metadata (l_theme_id);

         IF l_sdo.diminfo (1).sdo_tolerance <= 0
         THEN
            l_rnd := 6;
         ELSE
            l_rnd := Nm3unit.get_rounding (l_sdo.diminfo (1).sdo_tolerance);
         END IF;

         p_x := ROUND (l_geom.sdo_ordinates (1), l_rnd);
         p_y := ROUND (l_geom.sdo_ordinates (2), l_rnd);
      ELSE
         p_x := NULL;
         p_y := NULL;
      END IF;
   END;
--
--------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_base_themes( p_nt IN ptr_vc_array ) RETURN ptr_array IS
retval ptr_array := Nm3array.init_ptr_array;
CURSOR c1 ( c_nt IN ptr_vc_array ) IS
  SELECT ptr( t.ptr_id, nth_theme_id)
  FROM NM_THEMES_ALL, TABLE( c_nt.pa ) t, NM_LINEAR_TYPES, NM_NW_THEMES
  WHERE nth_theme_id = nnth_nth_theme_id
  AND nnth_nlt_id = nlt_id
  AND t.ptr_value = nlt_nt_type
  AND nlt_g_i_d = 'D'
  AND nth_base_table_theme is null;

BEGIN
  OPEN c1( p_nt );
  FETCH c1 BULK COLLECT INTO retval.pa;
  CLOSE c1;
  RETURN retval;
END;

--
--------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_base_themes( p_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE) RETURN nm_theme_array IS

   retval nm_theme_array := Nm3array.init_nm_theme_array;
   CURSOR c_nbth ( c_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE) IS
     SELECT nm_theme_entry( nbth_base_theme )
  FROM NM_BASE_THEMES
  WHERE nbth_theme_id = c_theme_id;
   BEGIN
     OPEN c_nbth( p_theme_id );
  FETCH c_nbth BULK COLLECT INTO retval.nta_theme_array;
  CLOSE c_nbth;
  RETURN retval;
   END;
--
--------------------------------------------------------------------------------------------------------------------
--


FUNCTION get_base_nt ( p_ne_id IN NUMBER ) RETURN ptr_vc_array IS
retval ptr_vc_array := Nm3array.init_ptr_vc_array;
CURSOR c1 ( c_ne_id IN NUMBER ) IS
  SELECT ptr_vc( ROWNUM, nng_nt_type )
  FROM nm_nt_groupings, NM_ELEMENTS_ALL
  WHERE ne_id = c_ne_id
  AND   ne_gty_group_type = nng_group_type;
BEGIN
  OPEN c1( p_ne_id );
  FETCH c1 BULK COLLECT INTO retval.pa;
  CLOSE c1;
  IF retval.pa.LAST IS NULL THEN
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                    ,pi_id                 => 293
                    ,pi_sqlcode            => -20001
                    );
    RAISE_APPLICATION_ERROR(-20001, 'No NT datums for ne_id');
  END IF;
  RETURN retval;
END;

--
--------------------------------------------------------------------------------------------------------------------
--


FUNCTION get_base_nt ( p_nlt_id IN NUMBER ) RETURN ptr_vc_array IS
retval ptr_vc_array := Nm3array.init_ptr_vc_array;
CURSOR c1 ( c_nlt_id IN NUMBER ) IS
  SELECT ptr_vc( ROWNUM, nng_nt_type )
  FROM nm_nt_groupings, NM_LINEAR_TYPES
  WHERE nlt_id = c_nlt_id
  AND   nlt_gty_type = nng_group_type;
BEGIN
  OPEN c1( p_nlt_id );
  FETCH c1 BULK COLLECT INTO retval.pa;
  CLOSE c1;
  IF retval.pa.LAST IS NULL THEN
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                    ,pi_id                 => 294
                    ,pi_sqlcode            => -20001
                    );
--  raise_application_error(-20001, 'No NT type for nlt id');
  END IF;
  RETURN retval;
END;

--
--------------------------------------------------------------------------------------------------------------------
--
FUNCTION join_ptr_array( p_nth IN NM_THEMES_ALL%ROWTYPE, p_pa IN ptr_array ) RETURN ptr_array IS
curstr VARCHAR2(2000);
retval ptr_array := Nm3array.init_ptr_array;
BEGIN
  curstr := 'select /*+cardinality ( t '||to_char(p_pa.pa.last )||') */ ptr( t.ptr_id, t.ptr_value ) from table ( :pa.pa ) t, '||p_nth.nth_feature_table||
            ' where t.ptr_value = '||p_nth.nth_feature_pk_column||' order by t.ptr_id';

  EXECUTE IMMEDIATE curstr BULK COLLECT INTO retval.pa USING p_pa;

  RETURN retval;
END;

--
--------------------------------------------------------------------------------------------------------------------
--

FUNCTION Get_Batch_Of_Base_Nn( p_theme IN NUMBER, p_geom IN mdsys.sdo_geometry ) RETURN ptr_array IS

nthrow NM_THEMES_ALL%ROWTYPE;
nthbas NM_THEMES_ALL%ROWTYPE;
nthmet user_sdo_geom_metadata%ROWTYPE;

retval ptr_array := Nm3array.init_ptr_array;

cur_string VARCHAR2(2000);

BEGIN

  nthrow := Nm3get.get_nth( p_theme );
  nthbas := nthrow;

  IF nthbas.nth_base_table_theme IS NOT NULL THEN

    nthrow := Nm3get.get_nth( nthrow.nth_base_table_theme );

  END IF;

  nthmet := Nm3sdo.get_theme_metadata( p_theme);

  cur_string := 'select ptr(rownum, ft.'||nthrow.nth_feature_pk_column||') from '||nthrow.nth_feature_table||' ft '||
                'where sdo_nn( '||nthrow.nth_feature_shape_column||', :p_geom ,'||''''||
                'SDO_BATCH_SIZE='||TO_CHAR(g_batch_size)||''''||') = '||''''||'TRUE'||''''||
                ' and rownum <= :g_batch_size';


  /*
  IF nthrow.nth_feature_table != nthrow.nth_table_name THEN

    cur_string := cur_string ||
                  ' and exists ( select 1 from '||nthrow.nth_table_name||' t '||
                  ' where ft.'||NVL( nthrow.nth_feature_fk_column, nthrow.nth_feature_pk_column )||' = t.'||nthrow.nth_pk_column||')';
  END IF;
*/


  EXECUTE IMMEDIATE cur_string BULK COLLECT INTO retval.pa USING p_geom, g_batch_size;

  IF nthrow.nth_feature_table != nthrow.nth_table_name THEN

    retval := local_join_ptr_array(retval, nthrow.nth_feature_table, nthrow.nth_feature_pk_column );

  END IF;

  IF nthbas.nth_base_table_theme IS NOT NULL THEN

    retval := join_ptr_array(nthbas, retval);

  END IF;

  RETURN retval;
END;

--
--------------------------------------------------------------------------------------------------------------------------
--

FUNCTION Get_Batch_Of_Base_Nn( p_theme IN NUMBER, p_x IN NUMBER, p_y IN NUMBER ) RETURN ptr_array IS

nthmet user_sdo_geom_metadata%ROWTYPE;

retval ptr_array := Nm3array.init_ptr_array;

l_geom mdsys.sdo_geometry;

BEGIN

  nthmet := Nm3sdo.get_theme_metadata( p_theme);

  l_geom := mdsys.sdo_geometry( 2001, nthmet.srid, mdsys.sdo_point_type( p_x, p_y, NULL), NULL, NULL);

  retval := Get_Batch_Of_Base_Nn( p_theme, l_geom );

  RETURN retval;

END;

--
--------------------------------------------------------------------------------------------------------------------------
--
FUNCTION Get_Batch_Of_Base_Nn( p_theme IN NUMBER, p_geom IN mdsys.sdo_geometry, p_ne_array IN  nm_cnct_ne_array_type ) RETURN ptr_array IS

nthrow NM_THEMES_ALL%ROWTYPE;
nthbas NM_THEMES_ALL%ROWTYPE;
nthmet user_sdo_geom_metadata%ROWTYPE;

retval ptr_array := Nm3array.init_ptr_array;

cur_string VARCHAR2(2000);

BEGIN

  nthrow := Nm3get.get_nth( p_theme );
  nthbas := nthrow;

  IF nthbas.nth_base_table_theme IS NOT NULL THEN

    nthrow := Nm3get.get_nth( nthrow.nth_base_table_theme );

  END IF;

  nthmet := Nm3sdo.get_theme_metadata( p_theme);

  cur_string := 'select /*+cardinality( ne_list '||to_char(p_ne_array.last)||')*/ '||
                'ptr(rownum, ft.'||nthrow.nth_feature_pk_column||') from '||nthrow.nth_feature_table||' ft '||
                ', table ( :b_ne_array ) ne_list '||
                'where sdo_nn( '||nthrow.nth_feature_shape_column||', :p_geom ,'||''''||
                'SDO_BATCH_SIZE='||TO_CHAR(10)||''''||') = '||''''||'TRUE'||''''||
                ' and rownum <= 10 '||
                ' and ft.'||nthrow.nth_feature_pk_column||' = ne_list.ne_id';

--  Nm_Debug.debug_on;
--  Nm_Debug.DEBUG( cur_string );

  EXECUTE IMMEDIATE cur_string BULK COLLECT INTO retval.pa USING p_ne_array, p_geom;


  IF nthbas.nth_base_table_theme IS NOT NULL THEN

    retval := join_ptr_array(nthbas, retval);

  END IF;


  RETURN retval;
END;

--
--------------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_buffer_of_base_ids( p_theme IN NUMBER, p_geom IN mdsys.sdo_geometry, p_buffer IN NUMBER DEFAULT 1 ) RETURN ptr_array IS

nthrow NM_THEMES_ALL%ROWTYPE;
nthbas NM_THEMES_ALL%ROWTYPE;
retval ptr_array := Nm3array.init_ptr_array;

cur_string VARCHAR2(2000);

BEGIN

  nthrow := Nm3get.get_nth( p_theme );

  nthbas := nthrow;

  IF nthbas.nth_base_table_theme IS NOT NULL THEN

    nthrow := Nm3get.get_nth( nthrow.nth_base_table_theme );

  END IF;

  cur_string := 'select ptr(rownum, ft.'||nthrow.nth_feature_pk_column||') from '||nthrow.nth_feature_table||' ft '||
                'where sdo_within_distance ( ft.'||nthrow.nth_feature_shape_column||', :p_geometry, '
          ||''''||'distance = '||TO_CHAR(p_buffer)||''''||') = '||''''||'TRUE'||'''';


--  Nm_Debug.debug_on;
--  Nm_Debug.DEBUG( cur_string );

  EXECUTE IMMEDIATE cur_string BULK COLLECT INTO retval.pa USING p_geom;

  IF nthbas.nth_base_table_theme IS NOT NULL THEN

    retval := join_ptr_array( nthbas, retval );

  END IF;

  RETURN retval;

END;
--
--------------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_buffer_of_base_ids( p_theme IN NUMBER, p_x IN NUMBER, p_y IN NUMBER , p_buffer IN NUMBER DEFAULT 1 ) RETURN ptr_array IS

nthmet user_sdo_geom_metadata%ROWTYPE;

retval ptr_array := Nm3array.init_ptr_array;

l_geom mdsys.sdo_geometry;

BEGIN


  nthmet := Nm3sdo.get_theme_metadata( p_theme);

  l_geom := mdsys.sdo_geometry( 2001, nthmet.srid, mdsys.sdo_point_type( p_x, p_y, NULL), NULL, NULL);

  retval := get_buffer_of_base_ids( p_theme, l_geom, p_buffer );

  RETURN retval;

END;

--
--------------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_nearest_nw_to_xy ( p_x IN NUMBER, p_y IN NUMBER,
                                p_theme IN nm_theme_array ) RETURN nm_lref IS

lta    nm_theme_array := p_theme;
ld     NUMBER;
ldsav  NUMBER := Nm3type.c_big_number;
lpk    NUMBER;
lth    NUMBER;
lpksav NUMBER;
l_geom mdsys.sdo_geometry;

BEGIN

--  Nm_Debug.debug_on;

  IF lta.nta_theme_array.LAST IS NULL OR lta.nta_theme_array.LAST <= 0 OR lta.nta_theme_array(lta.nta_theme_array.LAST).nthe_id IS NULL  THEN
    lta :=   Nm3sdo.get_nw_themes;
  END IF;

  FOR i IN 1..lta.nta_theme_array.LAST LOOP

--    Nm_Debug.DEBUG( NVL( TO_CHAR( lta.nta_theme_array(i).nthe_id ), 'NULL'));

    lpk := Nm3sdo.get_nearest_theme_to_xy( lta.nta_theme_array(i).nthe_id, p_x, p_y );

-- Nm_Debug.DEBUG( 'PK = '||TO_CHAR( lpk ));

 ld := Nm3sdo.get_distance( lta.nta_theme_array(i).nthe_id, lpk, p_x, p_y );

-- Nm_Debug.DEBUG( 'dist = '||TO_CHAR( ld ));

 IF ld < ldsav THEN
   ldsav := ld;
   lpksav := lpk;
   lth    := lta.nta_theme_array(i).nthe_id;

    END IF;
  END LOOP;

  l_geom := Nm3sdo.get_projection( lth, lpksav, p_x, p_y );

--  Nm_Debug.DEBUG( 'Theme = '||TO_CHAR( lth )||' pk = '||TO_CHAR(lpksav)||' Projected m = '||TO_CHAR(l_geom.sdo_ordinates(3)));

  RETURN nm_lref( lpksav, l_geom.sdo_ordinates(3));
END;

FUNCTION get_nearest_nw_to_xy ( p_x IN NUMBER, p_y IN NUMBER ) RETURN nm_lref IS
BEGIN
  RETURN get_nearest_nw_to_xy ( p_x, p_y, nm_theme_array( nm_theme_array_type(nm_theme_entry(NULL))) );
END;

--
--------------------------------------------------------------------------------------------------------------------------
--

FUNCTION Get_Ne_Shapes( p_id IN ptr_array, p_th_id IN INTEGER ) RETURN nm_geom_array IS
retval nm_geom_array       := Nm3array.init_nm_geom_array;
nth  NM_THEMES_ALL%ROWTYPE := Nm3get.get_nth( p_th_id );
cur_string VARCHAR2(2000);
ref_cur    Nm3type.ref_cursor;
BEGIN

  cur_string := 'select /*+cardinality (a '||to_char( p_id.pa.last)||')*/ '||
                ' nm_geom( a.ptr_id, '||TO_CHAR( nth.nth_feature_shape_column )||') from '||nth.nth_feature_table||
                ', table ( :pa ) a '||
    'where a.ptr_value = '||nth.nth_feature_pk_column ;

--nm_debug.debug( cur_string );

  OPEN ref_cur FOR cur_string USING p_id.pa;
  FETCH ref_cur BULK COLLECT INTO retval.nga;
  CLOSE ref_cur;

  RETURN retval;

END;

--
--------------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_spatial_column_name ( p_table_name IN VARCHAR2 ) RETURN VARCHAR2 IS
retval VARCHAR2(30);
BEGIN
  SELECT column_name
  INTO retval
  FROM user_tab_columns
  WHERE table_name = p_table_name
  AND   data_type  = 'SDO_GEOMETRY';
  RETURN retval;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                    ,pi_id                 => 295
                    ,pi_sqlcode            => -20001
                    );
--  raise_application_error(-20001,'No geometry column on the table');
  WHEN TOO_MANY_ROWS THEN
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                    ,pi_id                 => 296
                    ,pi_sqlcode            => -20001
                    );
--  raise_application_error(-20001,'More than one geometry column, need to choose one');
END;

--
--------------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_id ( p_ptr IN ptr_array, p_value IN INTEGER ) RETURN INTEGER IS
retval INTEGER := -1;
BEGIN
  FOR i IN 1..p_ptr.pa.LAST LOOP
    IF p_ptr.pa(i).ptr_value = p_value THEN
      retval := p_ptr.pa(i).ptr_id;
    END IF;
  END LOOP;
/*
  if retval = -1 then
    nm_debug.debug('ptr not found - '||to_char(p_value));
    for i in 1..p_ptr.pa.last loop
      nm_debug.debug( 'Ptr '||to_char(p_ptr.pa(i).ptr_id)||','||to_char(p_ptr.pa(i).ptr_value));
    end loop;
 raise_application_error(-20001,'not found - see dbug');
  end if;
*/
  RETURN retval;
END get_id;
--
------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_idx_from_id( p_ptr IN ptr_array, p_id IN INTEGER ) RETURN INTEGER IS
retval INTEGER;
BEGIN
  retval := -1;
  FOR i IN 1..p_ptr.pa.LAST LOOP
    IF p_ptr.pa(i).ptr_id = p_id THEN
   retval := i;
      EXIT;
 END IF;
  END LOOP;
  RETURN retval;
END get_idx_from_id;

--
------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_idx_from_id( p_ptr IN ptr_num_array, p_id IN INTEGER ) RETURN INTEGER IS
retval INTEGER;
BEGIN
  retval := -1;
  FOR i IN 1..p_ptr.pa.LAST LOOP
    IF p_ptr.pa(i).ptr_id = p_id THEN
   retval := i;
      EXIT;
 END IF;
  END LOOP;
  RETURN retval;
END get_idx_from_id;


--
------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_idx_from_value( p_ptr IN ptr_array, p_value IN INTEGER ) RETURN INTEGER IS
retval INTEGER;
BEGIN
  retval := -1;
  FOR i IN 1..p_ptr.pa.LAST LOOP
    IF p_ptr.pa(i).ptr_value = p_value THEN
   retval := i;
      EXIT;
 END IF;
  END LOOP;
  RETURN retval;
END get_idx_from_value;

--
------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_distinct_ptr (p_ptr IN ptr_array ) RETURN ptr_array IS
retval ptr_array := Nm3array.init_ptr_array;
BEGIN
  SELECT DISTINCT ptr( 1, p.ptr_value )
  BULK COLLECT INTO retval.pa
  FROM TABLE ( p_ptr.pa ) p;
  IF retval.pa(1) IS NOT NULL THEN
    FOR i IN 1..retval.pa.LAST LOOP
   retval.pa(i).ptr_id := i;
 END LOOP;
  END IF;
  RETURN retval;
END get_distinct_ptr;

--
------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_idx ( p_ga IN nm_geom_array, p_id IN INTEGER ) RETURN INTEGER IS
retval INTEGER;
isave  INTEGER;
BEGIN
  retval := -1;
  FOR i IN 1..p_ga.nga.LAST LOOP
    isave := i;
    IF p_ga.nga(i).ng_ne_id = p_id THEN
   retval := i;
      EXIT;
 END IF;
  END LOOP;
  RETURN retval;
EXCEPTION
WHEN OTHERS THEN
--  Nm_Debug.debug_on;
--  Nm_Debug.DEBUG( TO_CHAR( p_ga.nga(isave).ng_ne_id ));
  RAISE;
END;

--
-------------------------------------------------------------------------------------------------------------------------------
--

FUNCTION coalesce_nw_diminfo( p_pct_increase IN NUMBER DEFAULT 0,
                              p_tol IN NUMBER DEFAULT NULL,
                              p_m_tol IN NUMBER DEFAULT NULL ) RETURN mdsys.sdo_dim_array AS
  retval mdsys.sdo_dim_array;
  l_mbr  mdsys.sdo_geometry;
  l_tol  NUMBER := p_tol;
  l_m_tol NUMBER := p_m_tol;
--
  ex_3d_diminfo  EXCEPTION; 
  PRAGMA         EXCEPTION_INIT(  ex_3d_diminfo,-06533 );  --ORA-06533: Subscript beyond count

BEGIN
   SELECT sdo_aggr_mbr(Convert_Dim_Array_To_Mbr( Get_Theme_Diminfo(nth_theme_id)))
   INTO l_mbr
   FROM NM_NW_THEMES, NM_THEMES_ALL, NM_LINEAR_TYPES
   WHERE nnth_nth_theme_id = nth_theme_id
   AND   nnth_nlt_id = nlt_id
   AND   nlt_g_i_d = 'D';

   l_mbr.sdo_ordinates(1) := l_mbr.sdo_ordinates(1) - ( l_mbr.sdo_ordinates(4) - l_mbr.sdo_ordinates(1)) * p_pct_increase/100;

   l_mbr.sdo_ordinates(2) := l_mbr.sdo_ordinates(2) - ( l_mbr.sdo_ordinates(5) - l_mbr.sdo_ordinates(2)) * p_pct_increase/100;

   l_mbr.sdo_ordinates(4) := l_mbr.sdo_ordinates(4) + ( l_mbr.sdo_ordinates(4) - l_mbr.sdo_ordinates(1)) * p_pct_increase/100;

   l_mbr.sdo_ordinates(5) := l_mbr.sdo_ordinates(5) + ( l_mbr.sdo_ordinates(5) - l_mbr.sdo_ordinates(2)) * p_pct_increase/100;


   IF p_tol IS NULL THEN

      SELECT MIN( LEAST( Get_Dim_Element( 1, Get_Theme_Diminfo(nth_theme_id)).sdo_tolerance ,
                         Get_Dim_Element( 2, Get_Theme_Diminfo(nth_theme_id)).sdo_tolerance )) l1
      INTO l_tol
      FROM NM_NW_THEMES, NM_THEMES_ALL, NM_LINEAR_TYPES
      WHERE nnth_nth_theme_id = nth_theme_id
      AND   nnth_nlt_id = nlt_id
      AND   nlt_g_i_d = 'D';


   END IF;

   IF p_m_tol IS NULL THEN

      SELECT MIN( Get_Dim_Element( 3, Get_Theme_Diminfo(nth_theme_id)).sdo_tolerance )
      INTO l_m_tol
      FROM NM_NW_THEMES, NM_THEMES_ALL, NM_LINEAR_TYPES
      WHERE nnth_nth_theme_id = nth_theme_id
      AND   nnth_nlt_id = nlt_id
      AND   nlt_g_i_d = 'D';


   END IF;

   retval := mdsys.sdo_dim_array(
               mdsys.sdo_dim_element( 'X', l_mbr.sdo_ordinates(1), l_mbr.sdo_ordinates(4), l_tol ),
               mdsys.sdo_dim_element( 'Y', l_mbr.sdo_ordinates(2), l_mbr.sdo_ordinates(5), l_tol ),
               mdsys.sdo_dim_element( 'M', 0, Nm3type.c_big_number, l_m_tol ));

   RETURN retval;
EXCEPTION
  WHEN ex_3d_diminfo
  THEN
    hig.raise_ner(pi_appl => nm3type.c_net, pi_id => 468 );
END;
--
-------------------------------------------------------------------------------------------------------------------------------
--
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
--
-------------------------------------------------------------------------------------------------------------------------------
--

FUNCTION make_tha_from_ptr ( p_ptr IN ptr_array ) RETURN nm_theme_array IS
retval nm_theme_array := Nm3array.init_nm_theme_array;
BEGIN
  FOR i IN 1..p_ptr.pa.LAST LOOP
    retval := retval.add_theme(p_ptr.pa(i).ptr_value);
  END LOOP;

  RETURN retval;
END;

--
---------------------------------------------------------------------------------------------------------------
--


PROCEDURE add_dyn_seg_exception( p_ner          IN INTEGER,
                                 p_job_id       IN INTEGER,
         p_ne_id_in     IN INTEGER,
         p_ne_id_of     IN INTEGER  DEFAULT NULL,
         p_shape_length IN NUMBER   DEFAULT NULL,
         p_ne_length    IN NUMBER   DEFAULT NULL,
         p_start        IN NUMBER   DEFAULT NULL,
         p_end          IN NUMBER   DEFAULT NULL,
         p_sqlerrm      IN VARCHAR2 DEFAULT NULL ) IS

BEGIN

  INSERT INTO NM3SDM_DYN_SEG_EX
  ( ndse_job_id
   ,ndse_ner_id
   ,ndse_ne_id_in
   ,ndse_ne_id_of
   ,ndse_shape_length
   ,ndse_ne_length
   ,ndse_start
   ,ndse_end
   ,ndse_sqlerrm )
  VALUES
  ( p_job_id
   ,p_ner
   ,p_ne_id_in
   ,p_ne_id_of
   ,p_shape_length
   ,p_ne_length
   ,p_start
   ,p_end
   ,p_sqlerrm );

END;
--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
--

FUNCTION join_ntl_array( p_nth IN NM_THEMES_ALL%ROWTYPE, p_ntl IN nm_theme_list  ) RETURN nm_theme_list  IS
curstr VARCHAR2(2000);
retval  nm_theme_list := Nm3array.init_nm_theme_list;
retval2 nm_theme_list := Nm3array.init_nm_theme_list;
BEGIN
  --curstr := 'select nm_theme_detail( :new_theme, a.ntd_pk_id, a.ntd_fk_id,  :new_name, a.ntd_distance, a.ntd_measure, :new_descr )   '||

  if p_nth.nth_table_name = p_nth.nth_feature_table then

    curstr := 'select /*+cardinality( a '||to_char( p_ntl.ntl_theme_list.last)||') */ '||
              ' nm_theme_detail( :new_theme, a.ntd_pk_id, a.ntd_fk_id,  t.'||p_nth.nth_label_column||', a.ntd_distance, a.ntd_measure, :new_descr )   '||
              ' FROM TABLE ( :p_ntl.ntl_theme_list ) a, '||p_nth.nth_feature_table||' t '||
              ' where a.ntd_pk_id  =  t.'||p_nth.nth_feature_pk_column||
              ' group by :new_theme, a.ntd_pk_id, a.ntd_fk_id,  t.'||p_nth.nth_label_column||', a.ntd_distance, a.ntd_measure, :new_descr '||
              ' order by  a.ntd_distance';

  else

--    curstr := 'select /*+cardinality( a '||to_char( p_ntl.ntl_theme_list.last)||') */ '||
--              ' nm_theme_detail( :new_theme, a.ntd_pk_id, a.ntd_fk_id,  '||p_nth.nth_label_column||', a.ntd_distance, a.ntd_measure, :new_descr )   '||
--              ' FROM TABLE ( :p_ntl.ntl_theme_list ) a, '||p_nth.nth_feature_table||' f,'||p_nth.nth_table_name||' t'||
--              ' where a.ntd_pk_id  = f.'||p_nth.nth_feature_pk_column||
--              ' and   f.'||p_nth.nth_feature_fk_column||' =  t.'||p_nth.nth_pk_column||
--              ' order by  a.ntd_distance';

-- AE 4100

    curstr := 'select /*+cardinality( a '||to_char( p_ntl.ntl_theme_list.last)||') */ '||
              ' nm_theme_detail( :new_theme, a.ntd_pk_id, a.ntd_fk_id,  t.'||p_nth.nth_label_column||', a.ntd_distance, a.ntd_measure, :new_descr )   '||
              ' FROM TABLE ( :p_ntl.ntl_theme_list ) a, '||p_nth.nth_feature_table||' f,'||p_nth.nth_table_name||' t'||
              ' where a.ntd_pk_id  = f.'||p_nth.nth_feature_pk_column||
              ' and   f.'||NVL(p_nth.nth_feature_fk_column,p_nth.nth_feature_pk_column)||' =  t.'||p_nth.nth_pk_column||
              ' group by :new_theme, a.ntd_pk_id, a.ntd_fk_id,  t.'||p_nth.nth_label_column||', a.ntd_distance, a.ntd_measure, :new_descr '||
              ' order by  a.ntd_distance';

  end if;

  nm_debug.debug_on;
  nm_debug.debug(curstr);
  
  EXECUTE IMMEDIATE curstr BULK COLLECT INTO retval.ntl_theme_list
    --USING p_nth.nth_theme_id, p_nth.nth_theme_name, p_nth.nth_theme_name, p_ntl;
    --USING p_nth.nth_theme_id, p_nth.nth_label_column, p_nth.nth_theme_name, p_ntl;
    USING p_nth.nth_theme_id, p_nth.nth_theme_name, p_ntl, p_nth.nth_theme_id, p_nth.nth_theme_name;

--  select nm_theme_detail( a.ntd_theme_id, a.ntd_pk_id, a.ntd_fk_id, a.ntd_name, a.ntd_distance, a.ntd_measure, a.ntd_descr )
--  bulk collect into retval2.ntl_theme_list
--  from table ( retval.ntl_theme_list ) a
--  group by ntd_theme_id, ntd_pk_id, ntd_fk_id, ntd_name, ntd_distance, ntd_measure, ntd_descr;

  RETURN retval;
END;

--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
--

FUNCTION validate_geometry 
            ( p_geom   IN mdsys.sdo_geometry
            , p_nth_id IN nm_themes_all.nth_theme_id%TYPE
            , p_tol    IN NUMBER )
  RETURN VARCHAR2 
IS
--
  l_tol       NUMBER;
  l_diminfo   mdsys.sdo_dim_array;
  l_usgm      user_sdo_geom_metadata%ROWTYPE;
  retval      VARCHAR2(100) := 'FALSE';
  l_lrs       NUMBER;
  l_dim       NUMBER;
--==
--
--
--
-- -- Task 0109983
-- -- Correct this NVL check
--   IF NVL( l_usgm.srid, Nm3type.c_big_number ) != NVL(pi_geom.sdo_srid, Nm3type.c_big_number ) 
--   THEN
--     retval := '13365: Layer SRID does not match geometry SRID';
--   ELSE
--     IF l_lrs > 0
--     THEN
--        retval := sdo_lrs.validate_lrs_geometry (pi_geom, l_usgm.diminfo);
--     ELSE
--        retval := sdo_geom.validate_geometry_with_context (pi_geom, l_usgm.diminfo);
--     END IF;
--   END IF;
--==
--
BEGIN
--
  l_dim := p_geom.get_dims ();
  l_lrs := p_geom.get_lrs_dim ();
--
  IF p_nth_id IS NULL AND p_tol IS NULL 
  THEN
    hig.raise_ner(pi_appl    => Nm3type.c_hig
                 ,pi_id      => 197
                 ,pi_sqlcode => -20001 );
--
  ELSIF p_nth_id IS NOT NULL 
  THEN
--
  --  l_diminfo := get_theme_diminfo( p_nth_id );
    l_usgm    := get_theme_metadata( p_nth_id );
--
    IF l_usgm.diminfo IS NOT NULL 
    THEN
  --
      IF NVL( l_usgm.srid, Nm3type.c_big_number ) != NVL(p_geom.sdo_srid, Nm3type.c_big_number ) 
      THEN
        retval := '13365: Layer SRID does not match geometry SRID';
      END IF;
  --
      retval := SUBSTR(sdo_geom.validate_geometry_with_context( p_geom, l_usgm.diminfo ), 1, 100);
  --
--      IF l_lrs > 0
--      THEN
--         retval := sdo_lrs.validate_lrs_geometry (p_geom, l_usgm.diminfo);
--      ELSE
--         retval := sdo_geom.validate_geometry_with_context (p_geom, l_usgm.diminfo);
--      END IF;
  --
    ELSE
  --
      IF p_tol IS NOT NULL 
      THEN
    --
        retval  := SUBSTR(sdo_geom.validate_geometry_with_context( p_geom, p_tol ), 1, 100);
      END IF;
  --
    END IF;
--
  ELSE
  --
    retval  := SUBSTR(sdo_geom.validate_geometry_with_context( p_geom, p_tol ), 1, 100);
  --
  END IF;
--
  RETURN retval;
--
END validate_geometry;
--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_shape_length ( p_geom IN mdsys.sdo_geometry, p_nth_id IN nm_themes_all.nth_theme_id%TYPE, p_tol IN NUMBER ) RETURN NUMBER IS

l_tol     NUMBER;
l_usgm    user_sdo_geom_metadata%ROWTYPE;
l_nth     nm_themes_all%ROWTYPE;
retval    NUMBER;

BEGIN

  IF p_nth_id IS NULL AND p_tol IS NULL THEN
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                    ,pi_id                 => 197
                    ,pi_sqlcode            => -20001
                    );
  ELSIF p_nth_id IS NOT NULL THEN

    l_nth := Nm3get.get_nth( p_nth_id );

    l_usgm := get_usgm( l_nth.nth_feature_table, l_nth.nth_feature_shape_column );

    retval := sdo_geom.sdo_length( p_geom, l_usgm.diminfo );

  ELSIF p_tol IS NOT NULL THEN

    retval := sdo_geom.sdo_length( p_geom, p_tol );

  END IF;

  RETURN retval;
END;

--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_srs_text( p_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE ) RETURN cs_srs.wktext%TYPE IS
retval cs_srs.wktext%TYPE;
CURSOR c1 ( c_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE ) IS
  SELECT wktext
  FROM NM_THEMES_ALL, mdsys.cs_srs c, user_sdo_geom_metadata u
  WHERE nth_theme_id = c_theme_id
  AND   nth_feature_table = table_name
  AND   nth_feature_shape_column = column_name
  AND   c.srid = u.srid;
BEGIN
  OPEN c1( p_theme_id );
  FETCH c1 INTO retval;
  CLOSE c1;
  RETURN retval;
EXCEPTION
  WHEN OTHERS THEN
    IF c1%isopen THEN
      CLOSE c1;
    END IF;
    RETURN 'UNKNOWN';
END;

--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
FUNCTION Get_Parts ( p_shape IN mdsys.sdo_geometry ) RETURN nm_geom_array IS
retval nm_geom_array := Nm3array.INIT_NM_GEOM_ARRAY;
lp NUMBER;
BEGIN
  lp := Nm3sdo.get_no_parts( p_shape )/3;
--  Nm_Debug.DEBUG('No of parts = '||TO_CHAR(lp));
  IF lp = 1 THEN
    retval.nga(1).ng_ne_id := 1;
    retval.nga(1).ng_geometry :=  p_shape;
  ELSIF lp < 1 THEN
    RAISE_APPLICATION_ERROR( -20001, 'Fault');
  ELSE
    --Nm_Debug.DEBUG('Setting first bit');
    retval.nga(1).ng_ne_id := 1;
    retval.nga(1).ng_geometry :=  sdo_util.EXTRACT( p_shape, 1, 1);
--    Nm_Debug.DEBUG('Last = '||TO_CHAR(retval.nga.LAST));
    FOR i IN 2..lp LOOP
--      Nm_Debug.DEBUG('Setting bit '||TO_CHAR(i));
      retval.nga.EXTEND;
--      Nm_Debug.DEBUG('Extend - Last = '||TO_CHAR(retval.nga.LAST));
      retval.nga(i) := nm_geom(i, sdo_util.EXTRACT( p_shape, i, 1));

    END LOOP;
  END IF;

  RETURN retval;
END;


--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
--

FUNCTION compare_pt ( p_geom1 mdsys.sdo_geometry, p_geom2 mdsys.sdo_geometry, tol IN NUMBER ) RETURN VARCHAR2 IS
retval VARCHAR2(10) := 'FALSE';
l_tol NUMBER := 0.5;
BEGIN
  Nm_Debug.DEBUG( 'compare '||TO_CHAR( p_geom1.sdo_point.x )||' with '||TO_CHAR( p_geom2.sdo_point.x )||' and  '||
                              TO_CHAR( p_geom1.sdo_point.y )||' with '||TO_CHAR( p_geom2.sdo_point.y ));
  IF ABS( p_geom1.sdo_point.x - p_geom2.sdo_point.x ) <= l_tol  AND
     ABS( p_geom1.sdo_point.y - p_geom2.sdo_point.y ) <= l_tol THEN

     retval := 'TRUE';
  END IF;
  RETURN retval;
END;
--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
FUNCTION local_join_ptr_array
           ( p_pa    IN ptr_array
           , p_table IN VARCHAR2
           , p_key   IN VARCHAR2 )
RETURN ptr_array
IS
  curstr   VARCHAR2(2000);
  retval   ptr_array := Nm3array.init_ptr_array;
BEGIN
  curstr := 'select /*+cardinality (t '||to_char(p_pa.pa.last)||')*/ ptr( t.ptr_id, t.ptr_value ) from table ( :pa.pa ) t, '||p_table||
            ' where t.ptr_value = '||p_key||' order by t.ptr_id';
  EXECUTE IMMEDIATE curstr BULK COLLECT INTO retval.pa USING p_pa;
  RETURN retval;
END;
--
--
-----------------------------------------------------------------------------
--
--
END Nm3sdo;
/


