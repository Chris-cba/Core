CREATE OR REPLACE PACKAGE BODY nm3sdo_dynseg
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3sdo_dynseg.pkb-arc   3.5   May 18 2011 10:59:36   Ade.Edwards  $
--       Module Name      : $Workfile:   nm3sdo_dynseg.pkb  $
--       Date into PVCS   : $Date:   May 18 2011 10:59:36  $
--       Date fetched Out : $Modtime:   May 18 2011 10:39:40  $
--       Version          : $Revision:   3.5  $
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid CONSTANT VARCHAR2(2000) := '$Revision:   3.5  $';

  g_package_name CONSTANT varchar2(30) := 'nm3sdo_dynseg';
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
FUNCTION get_dim (p_table_name IN VARCHAR2)
  RETURN NUMBER;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inv_data (p_table_name    IN VARCHAR2,
                          p_inv_type      IN VARCHAR2,
                          p_seq_name      IN VARCHAR2,
                          p_pnt_or_cont   IN VARCHAR2,
                          p_job_id        IN NUMBER)
IS
  TYPE geocurtype IS REF CURSOR;

  geocur         geocurtype;

  curstr         VARCHAR2 (4000)
     :=    '  select ' || p_seq_name || '.nextval, nm_ne_id_in, nm_ne_id_of, nm_begin_mp, nm_end_mp, '
        || '          shape, '
        || '         nm_start_date, nm_end_date, hxo_offset '
        || '  from ( '
        || '      select im.nm_ne_id_in, im.nm_ne_id_of, im.nm_begin_mp, im.nm_end_mp,  '
        || '          shape, im.nm_start_date, im.nm_end_date, hxo_offset, '
        || '         row_number() over ( partition by im.nm_ne_id_in, im.nm_ne_id_of, im.nm_begin_mp, im.nm_end_mp, hxo_nwx_x_sect order by hxo_start_date desc ) rn '
        || '      from nm_inv_items_all, nm_members_all im, nm_nsg_esu_shapes_table, herm_xsp, nm_members_all rm '
        || '      where im.nm_obj_type =  '
        || ''''  || p_inv_type  || '''' || '      and iit_inv_type =  ' || ''''  || p_inv_type || ''''
        || '      and iit_ne_id = im.nm_ne_id_in '
        || '      and im.nm_ne_id_of = ne_id '
        || '      and im.nm_ne_id_of = hxo_ne_id_of '
        || '      and hxo_nwx_x_sect = iit_x_sect '
        || '      and im.nm_ne_id_of = rm.nm_ne_id_of '
        || '      and im.nm_start_date between hxo_start_date and nvl(hxo_end_date, to_date('
        || ''''  || '31-dec-2099' || '''' || ' )) '  || '        )  '
        || '  where rn = 1 ';

  --
  TYPE l_geom_array IS TABLE OF MDSYS.sdo_geometry
                          INDEX BY BINARY_INTEGER;

  --
  l_objectid     nm3type.tab_number;
  l_ne_id        nm3type.tab_number;
  l_ne_of        nm3type.tab_number;
  l_begin        nm3type.tab_number;
  l_end          nm3type.tab_number;
  l_shape        l_geom_array;
  l_start_date   nm3type.tab_date;
  l_end_date     nm3type.tab_date;
  l_offset       nm3type.tab_number;
  --
  error_count    NUMBER;
  dml_errors     EXCEPTION;
  PRAGMA EXCEPTION_INIT (dml_errors, -24381);
--
BEGIN
  --
  OPEN geocur FOR curstr;

  FETCH geocur
  BULK COLLECT INTO l_objectid,
       l_ne_id,
       l_ne_of,
       l_begin,
       l_end,
       l_shape,
       l_start_date,
       l_end_date,
       l_offset
  LIMIT 100;

  BEGIN
     --
     WHILE l_objectid.COUNT > 0
     LOOP
        FOR i IN 1 .. l_objectid.COUNT
        LOOP
           BEGIN
              IF p_pnt_or_cont = 'P'
              THEN
                 l_shape (i) :=
                    SDO_LRS.CONVERT_TO_STD_GEOM (SDO_LRS.
                                                  OFFSET_GEOM_SEGMENT (
                                                    l_shape (i),
                                                    l_begin (i),
                                                    l_end (i),
                                                    l_offset (i),
                                                    g_base_tol)); --, 'arc_tolerance=0.05');
              --
              ELSE
                 l_shape (i) :=
                    SDO_LRS.OFFSET_GEOM_SEGMENT (l_shape (i),
                                                 l_begin (i),
                                                 l_end (i),
                                                 l_offset (i),
                                                 g_base_tol); --, 'arc_tolerance=0.05');
              END IF;
           EXCEPTION
              WHEN OTHERS
              THEN
                 l_shape (i) :=
                    SDO_LRS.CLIP_GEOM_SEGMENT (l_shape (i),
                                               l_begin (i),
                                               l_end (i),
                                               g_base_tol);
           END;
        END LOOP;

        --
        BEGIN
           FORALL i IN 1 .. l_objectid.COUNT
           SAVE EXCEPTIONS
              EXECUTE IMMEDIATE 'insert into ' || p_table_name
                               || '  (objectid, ne_id, ne_id_of, nm_begin_mp, nm_end_mp, geoloc, start_date, end_date ) '
                               || ' values ( :l_objectid, :l_ne_id, :l_ne_of, :l_begin, :l_end, :l_shape, :l_start_date, :l_end_date )'
                 USING l_objectid (i),
                       l_ne_id (i),
                       l_ne_of (i),
                       l_begin (i),
                       l_end (i),
                       l_shape (i),
                       l_start_date (i),
                       l_end_date (i);

           --      ' values ( l_objectid(i), l_ne_id(i), l_ne_of(i), l_begin(i), l_end(i),
           --                    l_shape(i),
           --                    l_start_date(i), l_end_date(i) );
           COMMIT;
        --
        EXCEPTION
           WHEN dml_errors
           THEN
              error_count := SQL%BULK_EXCEPTIONS.COUNT;
              nm_debug.debug ('Number of statements that failed: ' || error_count);

              FOR i IN 1 .. error_count
              LOOP
                 nm_debug.debug (  'Error #'|| i || ' occurred during ' || 'iteration #'|| SQL%BULK_EXCEPTIONS (i).ERROR_INDEX);
                 nm_debug.debug ('Error message is '|| SQLERRM (-SQL%BULK_EXCEPTIONS (i).ERROR_CODE));
              END LOOP;
        END;

        --
        FETCH geocur
        BULK COLLECT INTO l_objectid,
             l_ne_id,
             l_ne_of,
             l_begin,
             l_end,
             l_shape,
             l_start_date,
             l_end_date,
             l_offset
        LIMIT 100;
     END LOOP;
  END;
--
  CLOSE geocur;
END create_inv_data;
--
-----------------------------------------------------------------------------
--
FUNCTION get_shape (p_layer   IN NUMBER,
                    p_in      IN NUMBER,
                    p_of      IN NUMBER,
                    p_begin   IN NUMBER,
                    p_end     IN NUMBER,
                    p_xsp     IN VARCHAR2 DEFAULT NULL)
  RETURN MDSYS.sdo_geometry
IS
  --
  l_offset   NUMBER;
  l_geom     MDSYS.sdo_geometry;

  l_begin    NUMBER;
  l_end      NUMBER;
--
BEGIN
  BEGIN
     IF p_xsp IS NULL
     THEN
         EXECUTE IMMEDIATE 'SELECT hxo_offset
                              FROM herm_xsp_dt
                                 , nm_inv_items
                             WHERE iit_ne_id = :c_in
                               AND hxo_ne_id_of = :c_of
                               AND iit_x_sect = hxo_nwx_x_sect'
                     INTO l_offset
                    USING p_in,
                          p_of;
     ELSE
        EXECUTE IMMEDIATE 'SELECT hxo_offset
                             FROM herm_xsp_dt 
                            WHERE hxo_nwx_x_sect = :c_xsp 
                              AND hxo_ne_id_of = :c_of'
                     INTO l_offset
                    USING p_xsp,
                          p_of;
     END IF;
  EXCEPTION
     WHEN OTHERS
     THEN
        l_offset := NULL;
  END;

  --
  l_geom :=
     nm3sdo.get_shape_from_nm (p_layer,
                               p_in,
                               p_of,
                               p_begin,
                               p_end);

  l_begin := SDO_LRS.GEOM_SEGMENT_START_MEASURE (l_geom);      -- + 0.001;
  l_end := SDO_LRS.GEOM_SEGMENT_END_MEASURE (l_geom);          -- - 0.001;
  --
  IF l_offset IS NOT NULL
  THEN
     l_geom :=
        SDO_LRS.
         OFFSET_GEOM_SEGMENT (nm3sdo.GET_LAYER_ELEMENT_GEOMETRY (p_of),
                              p_begin,
                              p_end,
                              l_offset,
                              g_base_tol
                              );       --, 'arc_tolerance=0.05' );
  END IF;

  --
  RETURN l_geom;
--
END get_shape;
--
-----------------------------------------------------------------------------
--
FUNCTION get_offset_shape (p_iit_ne_id   IN NUMBER,
                          p_ne_id_of    IN NUMBER,
                          p_begin_mp    IN NUMBER,
                          p_end_mp      IN NUMBER)
  RETURN MDSYS.sdo_geometry
IS
  --
  retval   MDSYS.sdo_geometry;
  --
BEGIN
  
  EXECUTE IMMEDIATE  'SELECT SDO_LRS.OFFSET_GEOM_SEGMENT (shape,
                                                          :c_begin_mp,
                                                          :c_end_mp,
                                                           hxo_offset,
                                                          :g_base_tol)
                         FROM nm_inv_items
                            , herm_xsp_dt
                            , nm_nsg_esu_shapes
                        WHERE iit_ne_id = :c_iit_ne_id
                          AND hxo_ne_id_of = :c_ne_id_of
                          AND ne_id = hxo_ne_id_of
                          AND hxo_nwx_x_sect = iit_x_sect'
                         INTO retval
                        USING p_begin_mp
                            , p_end_mp
                            , g_base_tol
                            , p_iit_ne_id
                            , p_ne_id_of;

  RETURN retval;
END get_offset_shape;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_xsp (p_iit_ne_id        IN nm_inv_items.iit_ne_id%TYPE,
                     p_iit_inv_type     IN nm_inv_items.iit_inv_type%TYPE,
                     p_x_sect           IN nm_inv_items.iit_x_sect%TYPE,
                     p_effective_date   IN DATE)
IS
  l_nth        nm_themes_all%ROWTYPE;
  l_base_nth   nm_themes_all.nth_theme_id%TYPE;
  l_dim_str    VARCHAR2 (100);
--
BEGIN
  SELECT t.*
    INTO l_nth
    FROM nm_themes_all t, nm_inv_themes
   WHERE     nth_theme_id = nith_nth_theme_id
         AND nth_base_table_theme IS NULL
         AND nith_nit_id = p_iit_inv_type
         AND ROWNUM = 1;

  --
  SELECT nbth_base_theme
    INTO l_base_nth
    FROM nm_base_themes
   WHERE nbth_theme_id = l_nth.nth_theme_id;
  --
  IF get_dim (l_nth.nth_feature_table) > 2
  THEN
     l_dim_str := '(';
  ELSE
     l_dim_str := 'sdo_lrs.convert_to_std_geom(';
  END IF;

  IF l_nth.nth_xsp_column = 'IIT_X_SECT'
  THEN
     EXECUTE IMMEDIATE   'update '
                      || l_nth.nth_feature_table
                      || ' set end_date = :edate '
                      || 'where ne_id  = :iit_ne_id and end_date is null '
        USING p_effective_date, p_iit_ne_id;

     EXECUTE IMMEDIATE 'insert into ' || l_nth.nth_feature_table
                      || ' ( objectid, ne_id, ne_id_of, nm_begin_mp, nm_end_mp, geoloc, start_date, end_date ) '
                      || '  select ' || l_nth.nth_sequence_name
                      || '.nextval, :iit_ne_id, nm_ne_id_of, nm_begin_mp, nm_end_mp,  '
                      || l_dim_str
                      || ' nm3sdo_dynseg.get_shape( :base_nth, nm_ne_id_in, nm_ne_id_of, nm_begin_mp, nm_end_mp, :iit_x_sect)), :edate, null '
                      || ' from nm_members where nm_ne_id_in = :iit_ne_id '
        USING p_iit_ne_id,
              l_base_nth,
              p_x_sect,
              p_effective_date,
              p_iit_ne_id;
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND
  THEN
     NULL;                                       -- no need to do anything
  WHEN DUP_VAL_ON_INDEX
  THEN

     EXECUTE IMMEDIATE ' delete from ' || l_nth.nth_feature_table
                      || ' where ne_id = :iit_ne_id and start_date = :edate '
        USING p_iit_ne_id, p_effective_date;
     --
     EXECUTE IMMEDIATE 'insert into ' || l_nth.nth_feature_table
                      || ' ( objectid, ne_id, ne_id_of, nm_begin_mp, nm_end_mp, geoloc, start_date, end_date ) '
                      || '  select '
                      || l_nth.nth_sequence_name
                      || '.nextval, :iit_ne_id, nm_ne_id_of, nm_begin_mp, nm_end_mp,  '
                      || l_dim_str
                      || ' nm3sdo_dynseg.get_shape( :base_nth, nm_ne_id_in, nm_ne_id_of, nm_begin_mp, nm_end_mp, :iit_x_sect)), :edate, null '
                      || ' from nm_members where nm_ne_id_in = :iit_ne_id '
        USING p_iit_ne_id,
              l_base_nth,
              p_x_sect,
              p_effective_date,
              p_iit_ne_id;
END update_xsp;
--
-----------------------------------------------------------------------------
--
FUNCTION get_dim (p_table_name IN VARCHAR2)
  RETURN NUMBER
IS
  retval   NUMBER;
BEGIN
  SELECT COUNT (*)
    INTO retval
    FROM (SELECT *
            FROM user_sdo_geom_metadata, TABLE (diminfo)
           WHERE table_name = p_table_name);

  --
  RETURN retval;
EXCEPTION
  WHEN NO_DATA_FOUND
  THEN
     raise_application_error (-20001, 'Table metadata not available');
END get_dim;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_offset_flag_on
IS
BEGIN
  g_use_offset := TRUE;
END set_offset_flag_on;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_offset_flag_off
IS
BEGIN
  g_use_offset := FALSE;
END set_offset_flag_off;
--
-----------------------------------------------------------------------------
--
END nm3sdo_dynseg;
/
