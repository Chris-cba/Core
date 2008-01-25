CREATE OR REPLACE PACKAGE BODY Nm3sdo_Edit AS
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3sdo_edit.pkb-arc   2.2   Jan 25 2008 21:39:04   aedwards  $
--       Module Name      : $Workfile:   nm3sdo_edit.pkb  $
--       Date into SCCS   : $Date:   Jan 25 2008 21:39:04  $
--       Date fetched Out : $Modtime:   Jan 25 2008 21:38:04  $
--       SCCS Version     : $Revision:   2.2  $
--
--
--  Author :  R Coupe
--            A Edwards
--
--  Editing Oracle Spatial features package
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
--
  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid   CONSTANT  VARCHAR2(2000)  :=  '$Revision:   2.2  $';
  g_package_name  CONSTANT  VARCHAR2(30)    :=  'nm3sdo_lock';
--
-----------------------------------------------------------------------------
--
FUNCTION get_version
  RETURN VARCHAR2
IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version
  RETURN VARCHAR2
IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
/* Set SRID
*/
FUNCTION set_srid (pi_geom IN MDSYS.SDO_GEOMETRY, pi_srid IN NUMBER)
   RETURN MDSYS.SDO_GEOMETRY
IS
BEGIN
   RETURN MDSYS.SDO_GEOMETRY (pi_geom.sdo_gtype,
                              pi_srid,
                              pi_geom.sdo_point,
                              pi_geom.sdo_elem_info,
                              pi_geom.sdo_ordinates
                             );
END set_srid;
--
-----------------------------------------------------------------------------
--
/* Pass in a geometry and test to see if it's been locked in NM_AREA_LOCK
*/
FUNCTION test_space (pi_shape IN MDSYS.SDO_GEOMETRY)
   RETURN BOOLEAN
IS
--
   l_use_terminal   VARCHAR2 (1) := NVL (Hig.get_sysopt ('LOCKBYTERM'), 'Y');
   l_use_session    VARCHAR2 (1) := NVL (Hig.get_sysopt ('LOCKBYSESS'), 'N');

--
   CURSOR c1 (
      c_geom           IN   MDSYS.SDO_GEOMETRY,
      c_use_terminal   IN   VARCHAR2,
      c_use_session    IN   VARCHAR2
   )
   IS
      SELECT 1
        FROM DUAL
       WHERE EXISTS (
                SELECT 1
                  FROM NM_AREA_LOCK A
                 WHERE nal_terminal !=
                          DECODE (c_use_terminal,
                                  'Y', NVL (USERENV ('TERMINAL'), 'Unknown'),
                                  'N', nal_terminal,
                                  nal_terminal
                                 )
                   AND nal_session_id !=
                          DECODE (c_use_session,
                                  'Y', NVL (USERENV ('SESSIONID'), -1),
                                  'N', nal_session_id,
                                  nal_session_id
                                 )
                   AND sdo_filter (A.nal_area,
                                   set_srid (c_geom, NULL),
                                   'querytype=window'
                                  ) = 'TRUE');

   bingo            INTEGER;
   retval           BOOLEAN;
BEGIN
   OPEN c1 (pi_shape, l_use_terminal, l_use_session);

   FETCH c1
    INTO bingo;

   retval := c1%NOTFOUND;

   CLOSE c1;

   RETURN retval;
END test_space;
--
-----------------------------------------------------------------------------
--
/* Pass in a geometry (for the area around the feature selected for edit)
   - i.e. a rectangle projected around the feature, and add to
   NM_AREA_LOCK table for locking
*/
FUNCTION lock_space (pi_shape IN MDSYS.SDO_GEOMETRY)
   RETURN NUMBER
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   retval            NUMBER;
   nal_row           NM_AREA_LOCK%ROWTYPE;
--l_geom mdsys.sdo_geometry := aset_srid(nm3sdo.get_mbr( p_shape ), NULL);
   l_use_area_lock   VARCHAR2 (1) := NVL (Hig.get_sysopt ('SSVAREALCK'), 'N');

   FUNCTION get_next_lock_id
      RETURN INTEGER
   IS
      retval   INTEGER;
   BEGIN
      SELECT nal_seq.NEXTVAL
        INTO retval
        FROM DUAL;

      RETURN retval;
   END;
BEGIN
   IF l_use_area_lock = 'Y'
   THEN
      IF test_space (pi_shape)
      THEN
         nal_row.nal_id := get_next_lock_id;
         nal_row.nal_timestamp := SYSDATE;
         nal_row.nal_terminal := NVL (USERENV ('TERMINAL'), 'Unknown');
         nal_row.nal_session_id := NVL (USERENV ('SESSIONID'), -1);
         nal_row.nal_area := pi_shape;

         INSERT INTO NM_AREA_LOCK
                     (nal_id, nal_timestamp,
                      nal_terminal, nal_session_id,
                      nal_area
                     )
              VALUES (nal_row.nal_id, nal_row.nal_timestamp,
                      nal_row.nal_terminal, nal_row.nal_session_id,
                      nal_row.nal_area
                     );

         COMMIT;
         RETURN nal_row.nal_id;
      ELSE
         RETURN -1;
      END IF;
   ELSE
      RETURN 1;
   END IF;
END lock_space;
--
-----------------------------------------------------------------------------
--
/* Allows you to validate a geometry against the Diminfo derived from the theme
*/
FUNCTION validate_geometry (
   pi_nth_theme_id   IN   NM_THEMES_ALL.nth_theme_id%TYPE,
   pi_geom           IN   MDSYS.SDO_GEOMETRY
)
   RETURN VARCHAR2
IS
   retval    VARCHAR2 (2000)       := 'FALSE';
   diminfo   MDSYS.sdo_dim_array
                                := Nm3sdo.get_theme_diminfo (pi_nth_theme_id);
   l_lrs     NUMBER;
   l_dim     NUMBER;
BEGIN
   l_dim := pi_geom.get_dims ();
   l_lrs := pi_geom.get_lrs_dim ();

   IF l_lrs > 0
   THEN
      retval := sdo_lrs.validate_lrs_geometry (pi_geom, diminfo);
   ELSE
      retval := sdo_geom.validate_geometry_with_context (pi_geom, diminfo);
   END IF;

   RETURN retval;
END;
--
-----------------------------------------------------------------------------
--
/* Pass in a geometry of the feature you wish to edit and lock it
*/
PROCEDURE lock_shape (pi_nth_id IN NUMBER, pi_pk IN NUMBER)
IS
   resource_busy   EXCEPTION;
   PRAGMA EXCEPTION_INIT (resource_busy, -54);
   c_str           VARCHAR2 (2000);
   l_nth           NM_THEMES_ALL%ROWTYPE   := Nm3get.get_nth (pi_nth_id);
   lock_id         NUMBER;
BEGIN
--get base table first - no point attempting to lock a view

   --operate on the base table theme

   --lock the spatial row first
   c_str :=
         'select '
      || l_nth.nth_feature_pk_column
      || ' from '
      || l_nth.nth_feature_table
      || ' where '
      || l_nth.nth_feature_pk_column
      || ' = :pk_id for update of '
      || l_nth.nth_feature_pk_column
      || ' nowait';

   EXECUTE IMMEDIATE c_str
               USING pi_pk;

--lock the theme base table or view - theme tables must be key-preserved??
   c_str :=
         'select '
      || l_nth.nth_pk_column
      || ' from '
      || l_nth.nth_table_name
      || ' where '
      || l_nth.nth_pk_column
      || ' = ( select '
      || l_nth.nth_feature_fk_column
      || ' from '
      || l_nth.nth_feature_table
      || '     where '
      || l_nth.nth_feature_pk_column
      || ' = :pk_id ) '
      || ' for update of '
      || l_nth.nth_pk_column
      || ' nowait';
--   nm_debug.debug_on;
   Nm_Debug.DEBUG (c_str);
--  execute immediate c_str using p_pk;
   Nm_Debug.DEBUG ('Lock space');
   lock_id := lock_space (Nm3sdo.get_theme_shape (pi_nth_id, pi_pk));
   Nm_Debug.DEBUG ('Lock id = ' || TO_CHAR (lock_id));

   IF lock_id = -1
   THEN
      RAISE resource_busy;
   END IF;
EXCEPTION
   WHEN resource_busy
   THEN
      RAISE_APPLICATION_ERROR (-20001, 'Resource busy');
END lock_shape;
--
-----------------------------------------------------------------------------
--
/* Pass in a Geometry and a THEME ID and ensure the shape is compatible with the
   type of geometries allowed on the Theme. (using NM_THEME_GTYPES)
*/
FUNCTION validate_shape (
   pi_nth_theme_id   IN   NM_THEMES_ALL.nth_theme_id%TYPE,
   pi_geom           IN   MDSYS.SDO_GEOMETRY
)
   RETURN VARCHAR2
IS
   retval    VARCHAR2 (10) := 'FALSE';

   CURSOR c1 (c_nth_id IN NUMBER, c_gtype IN NUMBER)
   IS
      SELECT 1
        FROM NM_THEME_GTYPES
       WHERE ntg_theme_id = c_nth_id AND ntg_gtype = c_gtype;

   l_dummy   INTEGER;
BEGIN
   OPEN c1 (pi_nth_theme_id, pi_geom.sdo_gtype);

   FETCH c1
    INTO l_dummy;

   IF c1%NOTFOUND
   THEN
      CLOSE c1;

      RETURN 'FALSE';
   END IF;

   CLOSE c1;

   RETURN 'TRUE';
EXCEPTION
   WHEN OTHERS
   THEN
      IF c1%ISOPEN
      THEN
         CLOSE c1;
      END IF;

      RAISE_APPLICATION_ERROR (-20001, 'Error');
END validate_shape;
--
-----------------------------------------------------------------------------
--
/* Check PK value
*/
FUNCTION get_fk (pi_nth_id IN NUMBER, pi_pk IN NUMBER)
  RETURN NUMBER
IS
   retval   NUMBER;
   l_nth    NM_THEMES_ALL%ROWTYPE   := Nm3get.get_nth (pi_nth_id);
   l_base   NM_THEMES_ALL%ROWTYPE;

BEGIN

   IF l_nth.nth_base_table_theme IS NOT NULL
   THEN
      l_nth := Nm3get.get_nth (l_nth.nth_base_table_theme);
   END IF;

   EXECUTE IMMEDIATE    'select '
                     || l_nth.nth_feature_fk_column
                     || '  from '
                     || l_nth.nth_feature_table
                     || ' where '
                     || l_nth.nth_feature_pk_column
                     || ' = :l_pk'
                INTO retval
               USING pi_pk;

   RETURN retval;
END get_fk;
--
-----------------------------------------------------------------------------
--
FUNCTION theme_is_inv_theme
          ( pi_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE )
  RETURN BOOLEAN
IS
  CURSOR check_inv_themes
          ( cp_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE)
  IS
     SELECT 1
       FROM NM_INV_THEMES
      WHERE nith_nth_theme_id = cp_theme_id;

  pls_check PLS_INTEGER := NULL;

BEGIN
   OPEN check_inv_themes(pi_theme_id);
   FETCH check_inv_themes INTO pls_check;
   CLOSE check_inv_themes;

   IF pls_check IS NULL
    THEN
      RETURN FALSE;
   ELSE
      RETURN TRUE;
   END IF;

END theme_is_inv_theme;
--
-----------------------------------------------------------------------------
--
/* This procedure allows you to pass in a theme id, pk value and a changed shape
   so that you can update the shape on the feature table directly - using history
   depending on value of new column on themes table - nth_use_history
*/
PROCEDURE move_reshape (
   pi_nth_id   IN   NUMBER,
   pi_pk       IN   NUMBER,
   pi_shape    IN   MDSYS.SDO_GEOMETRY,
   pi_date     IN   DATE DEFAULT Nm3user.get_effective_date
)
IS
   l_nth       NM_THEMES_ALL%ROWTYPE   := Nm3get.get_nth (pi_nth_id);
   l_base      NM_THEMES_ALL%ROWTYPE;
   l_fk        NUMBER;
   l_sqlcount  VARCHAR(5000);
   l_temp      Nm3type.max_varchar2;
BEGIN
--   Nm_DebuG.debug_on;
   Nm_Debug.DEBUG('In move reshape');

   IF l_nth.nth_base_table_theme IS NOT NULL
   THEN
      l_nth := Nm3get.get_nth (l_nth.nth_base_table_theme);
   END IF;

   IF l_nth.nth_use_history = 'Y'
   THEN

      IF l_nth.nth_feature_fk_column IS NOT NULL
      THEN
        l_fk := get_fk (pi_nth_id, pi_pk);

         l_temp := 'BEGIN '
                   || 'UPDATE '|| l_nth.nth_feature_table
                   || '   SET '|| l_nth.nth_end_date_column|| ' = :l_date '
                   || ' WHERE '|| l_nth.nth_feature_pk_column|| ' = :l_pk '
                   || '   AND '|| l_nth.nth_end_date_column|| ' is null; '
                 ||' END;';

         EXECUTE IMMEDIATE l_temp
                       USING pi_date, pi_pk;

         l_temp  :=    'BEGIN '
                     ||  'INSERT INTO '||l_nth.nth_feature_table
                     ||  '( '
                     ||    l_nth.nth_feature_pk_column||', '
                     ||    l_nth.nth_feature_fk_column||', '
                     ||    l_nth.nth_feature_shape_column|| ', '
                     ||    l_nth.nth_start_date_column|| ') '
                     ||  'VALUES ('
                     ||  ' :pi_pk, :l_fk, :pi_shape, :pi_date );'
                     ||'EXCEPTION '
                     || '  WHEN DUP_VAL_ON_INDEX THEN '
                     || '   DELETE FROM '||l_nth.nth_feature_table
                     || '    WHERE '||l_nth.nth_feature_pk_column||' = :pi_pk'
                     || '      AND '||l_nth.nth_end_date_column|| ' is not null ;'
                     || '   INSERT INTO '|| l_nth.nth_feature_table
                     || '( '|| l_nth.nth_feature_pk_column|| ', '
                     ||        l_nth.nth_feature_fk_column||', '
                     ||        l_nth.nth_feature_shape_column|| ', '
                     ||        l_nth.nth_start_date_column
                     || ') VALUES ( :pi_pk, :l_fk, :pi_shape, :pi_date );'
                     ||' WHEN OTHERS THEN RAISE;'
                     ||'END;';

         EXECUTE IMMEDIATE l_temp
                    USING pi_pk, l_fk, pi_shape, pi_date;

      ELSE
      -- End date orignal feature record
         l_temp := 'BEGIN '
                   || 'UPDATE '|| l_nth.nth_feature_table
                   || '   SET '|| l_nth.nth_end_date_column|| ' = :l_date '
                   || ' WHERE '|| l_nth.nth_feature_pk_column|| ' = :l_pk '
                   || '   AND '|| l_nth.nth_end_date_column|| ' is null; '
                 ||' END;';

         EXECUTE IMMEDIATE l_temp
                       USING pi_date, pi_pk;

         -- insert_shape
        -- (with only the start date , pk, fk and shape
        -- any other attributes are not available )

         l_temp  :=    'BEGIN '
                     ||  'INSERT INTO '||l_nth.nth_feature_table
                     ||  '( '
                     ||    l_nth.nth_feature_pk_column||', '
                     ||    l_nth.nth_feature_shape_column|| ', '
                     ||    l_nth.nth_start_date_column|| ') '
                     ||  'VALUES ('
                     ||  ' :pi_pk, :pi_shape, :pi_date );'
                     ||'EXCEPTION '
                     || '  WHEN DUP_VAL_ON_INDEX THEN '
                     || '   DELETE FROM '||l_nth.nth_feature_table
                     || '    WHERE '||l_nth.nth_feature_pk_column||' = :pi_pk'
                     || '      AND '||l_nth.nth_end_date_column|| ' is not null ;'
                     || '   INSERT INTO '|| l_nth.nth_feature_table
                     || '( '|| l_nth.nth_feature_pk_column|| ', '
                     ||        l_nth.nth_feature_shape_column|| ', '
                     ||        l_nth.nth_start_date_column
                     || ') VALUES ( :pi_pk, :pi_shape, :pi_date );'
                     ||' WHEN OTHERS THEN RAISE;'
                     ||'END;';
      nm_debug.debug ('Just before insert');
         EXECUTE IMMEDIATE l_temp
                    USING pi_pk, pi_shape, pi_date;
      nm_debug.debug ('Just after insert');
      END IF;

   ELSE

     --  No use of history so just update.feature
      EXECUTE IMMEDIATE    'update '
                        || l_nth.nth_feature_table
                        || ' set '
                        || l_nth.nth_feature_shape_column
                        || ' = :l_shape where '
                        || l_nth.nth_feature_pk_column
                        || ' = :l_pk'
                  USING pi_shape, pi_pk;

      l_sqlcount := SQL%rowcount;

      IF l_sqlcount = 0
      THEN
         add_shape (
            pi_nth_id   => pi_nth_id
           ,pi_pk       => pi_pk
           ,pi_fk       => NULL
           ,pi_shape    => pi_shape
            );
       END IF;

   END IF;
   nm_debug.debug('Finished move reshape');
EXCEPTION
  WHEN OTHERS THEN RAISE;
END;
--
-----------------------------------------------------------------------------
--
/* Allows update of a shape - pass in new geometry and it will work out the layers
   base table and update the shape
*/
PROCEDURE reshape (
   pi_nth_id   IN   NUMBER,
   pi_pk       IN   NUMBER,
   pi_shape    IN   MDSYS.SDO_GEOMETRY
)
IS
   l_nth    NM_THEMES_ALL%ROWTYPE   := Nm3get.get_nth (pi_nth_id);
   l_base   NM_THEMES_ALL%ROWTYPE;
BEGIN
   IF l_nth.nth_base_table_theme IS NOT NULL
   THEN
      l_nth := Nm3get.get_nth (l_nth.nth_base_table_theme);
   END IF;

   EXECUTE IMMEDIATE    'update '
                     || l_nth.nth_feature_table
                     || ' set '
                     || l_nth.nth_feature_shape_column
                     || ' = :l_shape where '
                     || l_nth.nth_feature_pk_column
                     || ' = :l_pk'
               USING pi_shape, pi_pk;
END;
--
-----------------------------------------------------------------------------
--
/* Update or insert a geometry for a given shape/pk value and theme
 */
PROCEDURE add_shape (
   pi_nth_id   IN   NUMBER,
   pi_pk       IN   NUMBER,
   pi_fk       IN   NUMBER,
   pi_shape    IN   MDSYS.SDO_GEOMETRY,
   pi_start_dt IN   DATE DEFAULT NULL
)
IS
   l_nth       NM_THEMES_ALL%ROWTYPE   := Nm3get.get_nth (pi_nth_id);
   lstr        Nm3type.max_varchar2;
   lf          VARCHAR2 (1)            := CHR (10);
   l_sqlcount  PLS_INTEGER;
BEGIN

   lstr := lstr || 'update ' || l_nth.nth_feature_table || lf;
   lstr := lstr || '   set ' || l_nth.nth_feature_shape_column || ' = :pi_shape'|| lf;
   lstr := lstr || '   where ' || l_nth.nth_feature_pk_column || ' = :pi_pk';

--   Nm_Debug.debug_on;
   Nm_Debug.DEBUG (lstr);

   BEGIN
--      nm_debug.debug ('X + Y = '||pi_shape.sdo_point.x||'-'||pi_shape.sdo_point.y);
      EXECUTE IMMEDIATE lstr
        USING pi_shape, pi_pk;

      l_sqlcount := SQL%rowcount;

      nm_debug.debug('SQL COUNT = '||to_char(l_sqlcount)||' - using PK_ID = '||pi_pk);
      IF l_sqlcount = 0
      THEN
         Nm_Debug.DEBUG('No data found');
         lstr := 'insert into ' || l_nth.nth_feature_table || lf;
         lstr := lstr || '       ( ' || l_nth.nth_feature_pk_column || ',';

         IF l_nth.nth_feature_fk_column IS NOT NULL THEN
            lstr := lstr || l_nth.nth_feature_fk_column || ',';
         END IF;

         IF l_nth.nth_sequence_name IS NOT NULL THEN
            lstr := lstr || ' OBJECTID ,';
         END IF;

         IF l_nth.nth_use_history = 'Y'
         AND l_nth.nth_start_date_column IS NOT NULL
         AND l_nth.nth_end_date_column   IS NOT NULL
         THEN
            lstr := lstr ||' '||l_nth.nth_start_date_column||', ';
         END IF;

         lstr := lstr || l_nth.nth_feature_shape_column || ')' || lf;
         lstr := lstr || '     values (:pk_id, ';

         IF l_nth.nth_feature_fk_column IS NOT NULL
         THEN
            lstr := lstr || ':fk_id,';
         END IF;

         IF l_nth.nth_sequence_name IS NOT NULL THEN
            lstr := lstr ||' '||l_nth.nth_sequence_name||'.nextval, ';
         END IF;

         IF l_nth.nth_use_history = 'Y'
         AND l_nth.nth_start_date_column IS NOT NULL
         AND l_nth.nth_end_date_column   IS NOT NULL
         THEN
            lstr := lstr ||'  :start_date, ';
         END IF;

         lstr := lstr || ':shape )';

         Nm_Debug.DEBUG('Inserting instead..');
         Nm_Debug.DEBUG(lstr);

         IF l_nth.nth_feature_fk_column IS NOT NULL
         THEN
         --
            IF l_nth.nth_use_history = 'Y'
            AND l_nth.nth_start_date_column IS NOT NULL
            AND l_nth.nth_end_date_column   IS NOT NULL
            THEN
            --
--              nm_debug.debug ('X + Y = '||
--                              pi_shape.sdo_point.x||'-'||
--                              pi_shape.sdo_point.y);
            --
              EXECUTE IMMEDIATE lstr
                USING pi_pk, pi_fk, nvl(pi_start_dt,nm3user.get_effective_date), pi_shape;
            --
            ELSE
              EXECUTE IMMEDIATE lstr
              USING pi_pk, pi_fk, pi_shape;
            END IF;
         ELSE
         --
            IF l_nth.nth_use_history = 'Y'
            AND l_nth.nth_start_date_column IS NOT NULL
            AND l_nth.nth_end_date_column   IS NOT NULL
            THEN
            --
--              nm_debug.debug ('X + Y = '||
--                              pi_shape.sdo_point.x||'-'||
--                              pi_shape.sdo_point.y);
            --
              EXECUTE IMMEDIATE lstr
              USING pi_pk, nvl(pi_start_dt,nm3user.get_effective_date), pi_shape;
            --
            ELSE
              EXECUTE IMMEDIATE lstr
              USING pi_pk, pi_shape;
            END IF;
         END IF;
      END IF;
--   EXCEPTION
--      WHEN OTHERS THEN RAISE;
   END;
--    nm_debug.debug_off;
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_inv_xy_update
  ( pi_rec_iit IN NM_INV_ITEMS_ALL%ROWTYPE )
IS
BEGIN
  g_tab_inv.DELETE;
  g_tab_inv(g_tab_inv.COUNT+1) := pi_rec_iit;
  process_inv_xy_update;
END process_inv_xy_update;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_inv_xy_update
IS
  TYPE
   tab_nith IS TABLE OF NM_INV_THEMES%ROWTYPE
   INDEX BY BINARY_INTEGER;

   CURSOR check_for_layer (cp_inv_type IN NM_INV_ITEMS_ALL.iit_inv_type%TYPE)
   IS
      SELECT *
        FROM NM_INV_THEMES
       WHERE nith_nit_id = cp_inv_type;
--
   b_located         BOOLEAN := FALSE;
   l_nw_base_layer   NUMBER;
   l_nt_type         nm_types.nt_type%TYPE;
   l_rec_nth         NM_THEMES_ALL%ROWTYPE;
   g_nte_job_id      NM_NW_TEMP_EXTENTS.nte_job_id%TYPE;
   l_nte_job_id      NM_NW_TEMP_EXTENTS.nte_job_id%TYPE;
   l_rec_iit         nm_inv_items%ROWTYPE;
   l_tab_nith        tab_nith;
   l_geom            mdsys.sdo_geometry;
   l_lref            nm_lref;
--
   FUNCTION get_theme_gtype
      (pi_theme_id IN NUMBER) RETURN NUMBER
   IS
     l_gtype NUMBER;
   BEGIN
      SELECT ntg_gtype INTO l_gtype
        FROM nm_theme_gtypes
       WHERE ntg_theme_id = pi_theme_id;
      RETURN l_gtype;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN RETURN -1;
     WHEN OTHERS THEN RAISE;
   END;
--
  FUNCTION is_inv_loc_mandatory 
     (p_nit_inv_type   IN   nm_inv_types.nit_inv_type%TYPE) RETURN BOOLEAN
  IS
     CURSOR c1 (c_inv IN nm_inv_types.nit_inv_type%TYPE)
     IS
       SELECT 1 FROM nm_inv_nw
        WHERE nin_nit_inv_code = c_inv 
          AND nin_loc_mandatory = 'Y';
     l_dummy   NUMBER;
     retval    BOOLEAN;
  BEGIN
    OPEN c1 (p_nit_inv_type);
    FETCH c1 INTO l_dummy;
    retval := c1%FOUND;
    CLOSE c1;
    RETURN retval;
  END is_inv_loc_mandatory;
--
  FUNCTION is_located ( pi_inv_type IN nm_inv_types.nit_inv_type%TYPE)
  RETURN BOOLEAN
  IS
    l_rec_nin nm_inv_nw%ROWTYPE;
  BEGIN
    SELECT *
    INTO l_rec_nin
    FROM nm_inv_nw
    WHERE nin_nit_inv_code = pi_inv_type
      AND ROWNUM = 1;
    RETURN TRUE;
  EXCEPTION
    WHEN NO_DATA_FOUND
      THEN RETURN FALSE;
    WHEN OTHERS
      THEN RAISE;
  END is_located;
--
BEGIN
--
--  Nm_Debug.debug_on;
--
  FOR i IN g_tab_inv.FIRST..g_tab_inv.LAST
  LOOP
  --
    l_rec_iit := g_tab_inv(i);
  --
  -- Get all nm_inv_theme records for inv type
    OPEN  check_for_layer (l_rec_iit.iit_inv_type);
    FETCH check_for_layer BULK COLLECT INTO l_tab_nith;
    CLOSE check_for_layer;
--
    nm_debug.debug(' count = '||l_tab_nith.COUNT );
--
    IF l_tab_nith.COUNT > 0
    THEN
      FOR i IN 1..l_tab_nith.COUNT
      LOOP
        l_rec_nth := Nm3get.get_nth (pi_nth_theme_id => l_tab_nith(i).nith_nth_theme_id);

        -- make sure we are acting on base table theme, location updatable flag is Y
        -- theme type is SDO, X and Y columns set on theme and check that inv type is XY

        IF  l_rec_nth.nth_base_table_theme IS NULL
        AND l_rec_nth.nth_location_updatable = 'Y'
        AND l_rec_nth.nth_theme_type = Nm3sdo.c_sdo
        AND l_rec_nth.nth_x_column IS NOT NULL
        AND l_rec_nth.nth_y_column IS NOT NULL
        AND Nm3get.get_nit(pi_nit_inv_type => l_rec_iit.iit_inv_type).nit_use_xy = 'Y'
        AND get_theme_gtype(l_rec_nth.nth_theme_id) = 2001
        THEN
          -- construct a new point shape
          l_geom := nm3sdo.get_2d_pt(l_rec_iit.iit_x, l_rec_iit.iit_y);

          IF is_located ( pi_inv_type => l_rec_iit.iit_inv_type)
          THEN
          --
          --<RAC - 3.2.1.1
            l_lref := nm3sdo.get_nearest_lref( l_rec_nth.nth_theme_id, l_geom );

            IF  l_lref.lr_ne_id IS NULL 
            AND is_inv_loc_mandatory( l_rec_iit.iit_inv_type) 
            THEN
              RAISE_APPLICATION_ERROR( -20001, 'Failure to locate mandatory inventory type');
            END IF;
          --RAC>
          --
            nm3extent.create_temp_ne
                ( l_lref.lr_ne_id
                , Nm3extent.c_route
                , l_lref.lr_offset
                , l_lref.lr_offset
                , g_nte_job_id );
          --
            BEGIN
              Nm3homo.homo_update
              ( p_temp_ne_id_in  => g_nte_job_id
              , p_iit_ne_id      => l_rec_iit.iit_ne_id
              , p_effective_date => nm3user.get_effective_date);
            EXCEPTION
              WHEN OTHERS
              THEN RAISE ;
            END;
          -- is located
          END IF;
         --
          add_shape
           ( pi_nth_id   => l_tab_nith(i).nith_nth_theme_id
           , pi_pk       => l_rec_iit.iit_ne_id
           , pi_fk       => NULL
           , pi_shape    => l_geom
           );
        -- theme checks
        END IF;
      -- tab_nith loop
      END LOOP;
    -- tab_nith check
    END IF;
  --g_tab_inv loop
  END LOOP;
--
END process_inv_xy_update;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_xy
 ( pi_table_name IN VARCHAR2
 , pi_pk_column  IN VARCHAR2
 , pi_x_column   IN VARCHAR2
 , pi_y_column   IN VARCHAR2
 , pi_pk_value   IN VARCHAR2
 , pi_x_value    IN NUMBER
 , pi_y_value    IN NUMBER
 )
IS
   nl   CONSTANT VARCHAR2(1)  := CHR(10);

   lstr VARCHAR2(2000);
BEGIN
  lstr := 'BEGIN'
||nl||'   UPDATE '||pi_table_name
||nl||'    SET   '||pi_x_column ||' = '||pi_x_value
||nl||'         ,'||pi_y_column ||' = '||pi_y_value
||nl||'   WHERE  '||pi_pk_column||' = '||pi_pk_value||';'
||nl||'END;';

Nm_Debug.DEBUG( lstr );
EXECUTE IMMEDIATE lstr;
END update_xy;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_point_lref
 ( pi_table_name IN VARCHAR2
 , pi_pk_column  IN VARCHAR2
 , pi_rse_column IN VARCHAR2
 , pi_st_chain   IN VARCHAR2
 , pi_lref_value IN nm_lref
 , pi_pk_value   IN VARCHAR2
 )
IS
   nl   CONSTANT VARCHAR2(1)  := CHR(10);
BEGIN
   EXECUTE IMMEDIATE
      'BEGIN'
||nl||'  UPDATE '||pi_table_name
||nl||'     SET '||pi_rse_column||' = '||pi_lref_value.lr_ne_id
||nl||'       , '||pi_st_chain||' = '
                 ||Nm3unit.get_formatted_value( pi_lref_value.lr_offset
                 , Nm3net.get_nt_units_from_ne(pi_lref_value.lr_ne_id))
||nl||'   WHERE '||pi_pk_column||' = '||pi_pk_value||';'
||nl||'END;';
END update_point_lref;
--
-----------------------------------------------------------------------------
--
PROCEDURE end_date_shape
          ( pi_nth_id IN NUMBER
          , pi_pk     IN NUMBER
          , pi_date   IN DATE )
IS
   l_nth       NM_THEMES_ALL%ROWTYPE   := Nm3get.get_nth (pi_nth_id);
   lstr        Nm3type.max_varchar2;
   lf          VARCHAR2 (1)            := CHR (10);
   l_sqlcount  PLS_INTEGER;
BEGIN
   IF l_nth.nth_end_date_column IS NOT NULL
   AND l_nth.nth_use_history = 'Y'
   THEN
     lstr := lstr || 'update ' || l_nth.nth_feature_table || lf;
     lstr := lstr || '   set ' || l_nth.nth_end_date_column || ' = :pi_date'|| lf;
     lstr := lstr || '   where ' || l_nth.nth_feature_pk_column || ' = :pi_pk'|| lf;
     lstr := lstr || '     and ' ||l_nth.nth_end_date_column || ' is null';
     EXECUTE IMMEDIATE lstr USING IN pi_date, pi_pk;
   END IF;
END end_date_shape;
--
------------------------------------------------------------------------------
--
PROCEDURE delete_shape
          ( pi_nth_id IN NUMBER
          , pi_pk     IN NUMBER)
IS
  l_nth        NM_THEMES_ALL%ROWTYPE   := Nm3get.get_nth (pi_nth_id);
   lstr        Nm3type.max_varchar2;
   lf          VARCHAR2 (1)            := CHR (10);
BEGIN
  IF l_nth.nth_feature_table IS NOT NULL
  AND l_nth.nth_feature_shape_column IS NOT NULL
  THEN
    lstr := lstr || 'delete ' || l_nth.nth_feature_table || lf;
    lstr := lstr || ' where ' || l_nth.nth_feature_pk_column || ' = :pi_pk';
    EXECUTE IMMEDIATE lstr USING IN pi_pk;
  END IF;
END delete_shape;
--
------------------------------------------------------------------------------
--
END Nm3sdo_Edit;
/
