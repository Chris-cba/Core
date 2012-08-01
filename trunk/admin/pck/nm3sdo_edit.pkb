CREATE OR REPLACE PACKAGE BODY Nm3sdo_Edit AS
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3sdo_edit.pkb-arc   2.17   Aug 01 2012 12:01:50   Rob.Coupe  $
--       Module Name      : $Workfile:   nm3sdo_edit.pkb  $
--       Date into SCCS   : $Date:   Aug 01 2012 12:01:50  $
--       Date fetched Out : $Modtime:   Aug 01 2012 12:00:12  $
--       SCCS Version     : $Revision:   2.17  $
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
  g_body_sccsid   CONSTANT  VARCHAR2(2000)  :=  '$Revision:   2.17  $';
  g_package_name  CONSTANT  VARCHAR2(30)    :=  'nm3sdo_edit';
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
Function test_theme_for_update( p_Theme in NM_THEMES_ALL.NTH_THEME_ID%TYPE ) Return Boolean is
  retval Boolean := FALSE;
  l_mode nm_theme_roles.nthr_mode%type;
begin
  select nthr_mode into l_mode 
  from nm_theme_roles, hig_user_roles
  where nthr_theme_id = p_theme
  and nthr_role = hur_role
  and hur_username = SYS_CONTEXT ('NM3_SECURITY_CTX', 'USERNAME')
  and rownum = 1
  order by nthr_mode;
--
  if l_mode = 'NORMAL' then
    retval := TRUE;
  else
    retval := FALSE;
  end if;
  return retval;
exception
  when no_data_found then
    Return FALSE;
end;

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
FUNCTION set_srid (pi_theme IN nm_themes_all.nth_theme_id%TYPE, pi_geom IN MDSYS.SDO_GEOMETRY )
   RETURN MDSYS.SDO_GEOMETRY
IS
l_usgm user_sdo_geom_metadata%ROWTYPE;
BEGIN

   l_usgm := Nm3sdo.get_theme_metadata( pi_theme );

   RETURN set_srid( pi_geom => pi_geom,
                    pi_srid => l_usgm.srid );
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
--   retval    VARCHAR2 (2000)       := 'FALSE';
--   l_usgm    user_sdo_geom_metadata%ROWTYPE := Nm3sdo.get_theme_metadata(pi_nth_theme_id);
--   l_lrs     NUMBER;
--   l_dim     NUMBER;
BEGIN
--   l_dim := pi_geom.get_dims ();
--   l_lrs := pi_geom.get_lrs_dim ();
--
--   IF NVL( l_usgm.srid, Nm3type.c_big_number ) != NVL(pi_geom.sdo_srid, Nm3type.c_big_number ) THEN
--     retval := '13365: Layer SRID does not match geometry SRID';
--   ELSE
--     IF l_lrs > 0
--     THEN
--        retval := sdo_lrs.validate_lrs_geometry (pi_geom, l_usgm.diminfo);
--     ELSE
--        retval := sdo_geom.validate_geometry_with_context (pi_geom, l_usgm.diminfo);
--     END IF;
--   END IF;
--
-- Task 0109983
-- Consolidated the two validate_geometry functions into NM3SDO to prevent any
-- circular package dependencies
--
   RETURN  nm3sdo.validate_geometry(pi_geom,pi_nth_theme_id,NULL);
--
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

  IF NOT test_theme_for_update(pi_nth_id) then
    HIG.RAISE_NER('NET', 339);
  END IF;

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
   pi_date     IN   DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
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
   
   IF NOT test_theme_for_update(pi_nth_id) then
     HIG.RAISE_NER('NET', 339);
   END IF;
   

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
                     || '      AND '||l_nth.nth_start_date_column||' = :pi_date '||';'
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
                     || '      AND '||l_nth.nth_start_date_column||' = :pi_date '||';'
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
   IF NOT test_theme_for_update(pi_nth_id) then
     HIG.RAISE_NER('NET', 339);
   END IF;

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
PROCEDURE add_sub_shape (
   pi_inv_type   IN nm_inv_types.nit_inv_type%TYPE,
   pi_pk       IN   NUMBER,
   pi_x        IN   NUMBER,
   pi_y        IN   NUMBER,
   pi_shape    IN   MDSYS.SDO_GEOMETRY,
   pi_start_dt IN   DATE DEFAULT NULL
) is
cursor c1 ( c_inv_type in nm_inv_types.nit_inv_type%TYPE,
            c_pk       in NUMBER ) is
select iig_item_id, nth_theme_id
from nm_themes_all, nm_inv_type_groupings, nm_inv_themes, nm_inv_types, nm_inv_item_groupings, nm_inv_items
where nth_base_table_theme IS NULL
        AND nth_location_updatable = 'Y'
        AND nth_theme_type         = nm3sdo.c_sdo
        AND nit_use_xy             = 'Y'
        and nit_inv_type           = nith_nit_id
        and itg_parent_inv_type    = c_inv_type
        and nith_nit_id            = itg_inv_type
        and itg_relation           = 'AT'
        and nith_nth_theme_id      = nth_theme_id
        and iig_parent_id          = c_pk
        and iit_ne_id              = iig_item_id
        and iit_inv_type           = nith_nit_id
        AND nth_x_column IS NOT NULL
        AND nth_y_column IS NOT NULL;
begin
--  
  for irec in c1 ( pi_inv_type, pi_pk ) loop

    IF NOT test_theme_for_update(irec.nth_theme_id) then
      HIG.RAISE_NER('NET', 339);
    END IF;

    update nm_inv_items
    set iit_x = pi_x,
        iit_y = pi_y
    where iit_ne_id = irec.iig_item_id;
    
    add_shape(irec.nth_theme_id, irec.iig_item_id, null, pi_shape, pi_start_dt );
    
  end loop;

end;
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

  IF NOT test_theme_for_update(pi_nth_id) then
    HIG.RAISE_NER('NET', 339);
  END IF;

  -- Task 0109983
  -- Validate the geometry and raise error if appropriate
  --
  nm3sdo.evaluate_and_raise_geo_val (nm3sdo.validate_geometry(pi_shape,l_nth.nth_theme_id,NULL));
  --
   lstr := lstr || 'update ' || l_nth.nth_feature_table || lf;
   lstr := lstr || '   set ' || l_nth.nth_feature_shape_column || ' = :pi_shape'|| lf;
   lstr := lstr || ' where ' || l_nth.nth_feature_pk_column    || ' = :pi_pk';

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
                USING pi_pk, pi_fk, nvl(pi_start_dt,To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')), pi_shape;
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
              USING pi_pk, nvl(pi_start_dt,To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')), pi_shape;
            --
            ELSE
              nm_debug.debug_on;
              FOR i IN (
                  SELECT id,
                         x ,
                         y
                    FROM table (sdo_util.getvertices (pi_shape)))
              LOOP
                nm_debug.debug('sdoedit X = '||i.x );
                nm_debug.debug('sdoedit Y = '||i.y );
              END LOOP;
            --
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
   l_tab_nith        tab_nith;
   l_geom            mdsys.sdo_geometry;
   l_lref            nm_lref;
   l_homo_touch_flag BOOLEAN := nm3homo.g_homo_touch_flag;
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
-- 0111341 CWS 15/7/11
  nm3homo.g_homo_touch_flag:= FALSE;
--
  FOR g_tab_inv_count IN g_tab_inv.FIRST..g_tab_inv.LAST
  LOOP
  --
  -- Get all nm_inv_theme records for inv type
    OPEN  check_for_layer (g_tab_inv(g_tab_inv_count).iit_inv_type);
    FETCH check_for_layer BULK COLLECT INTO l_tab_nith;
    CLOSE check_for_layer;
--
    nm_debug.debug(' count = '||l_tab_nith.COUNT );
--
    IF l_tab_nith.COUNT > 0
    THEN
      FOR l_tab_nith_count IN 1..l_tab_nith.COUNT
      LOOP
        l_rec_nth := Nm3get.get_nth (pi_nth_theme_id => l_tab_nith(l_tab_nith_count).nith_nth_theme_id);

        -- make sure we are acting on base table theme, location updatable flag is Y
        -- theme type is SDO, X and Y columns set on theme and check that inv type is XY

        IF  l_rec_nth.nth_base_table_theme IS NULL
        AND l_rec_nth.nth_location_updatable = 'Y'
        AND l_rec_nth.nth_theme_type = Nm3sdo.c_sdo
        AND l_rec_nth.nth_x_column IS NOT NULL
        AND l_rec_nth.nth_y_column IS NOT NULL
        AND Nm3get.get_nit(pi_nit_inv_type => g_tab_inv(g_tab_inv_count).iit_inv_type).nit_use_xy = 'Y'
        AND get_theme_gtype(l_rec_nth.nth_theme_id) = 2001
        THEN
          -- construct a new point shape
          l_geom := nm3sdo.get_2d_pt(g_tab_inv(g_tab_inv_count).iit_x, g_tab_inv(g_tab_inv_count).iit_y);

          IF is_located ( pi_inv_type => g_tab_inv(g_tab_inv_count).iit_inv_type)
          THEN
          --
          --<RAC - 3.2.1.1
            l_lref := nm3sdo.get_nearest_lref( l_rec_nth.nth_theme_id, l_geom );

            IF  l_lref.lr_ne_id IS NULL
            AND is_inv_loc_mandatory( g_tab_inv(g_tab_inv_count).iit_inv_type)
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
              , p_iit_ne_id      => g_tab_inv(g_tab_inv_count).iit_ne_id
              , p_effective_date => To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY'));
            EXCEPTION
              WHEN OTHERS
              THEN RAISE ;
            END;
          -- is located
          END IF;
         --
          add_shape
           ( pi_nth_id   => l_tab_nith(l_tab_nith_count).nith_nth_theme_id
           , pi_pk       => g_tab_inv(g_tab_inv_count).iit_ne_id
           , pi_fk       => NULL
           , pi_shape    => l_geom
           , pi_start_dt => g_tab_inv(g_tab_inv_count).iit_start_date
           );
        -- theme checks
        
          begin
            add_sub_shape
             ( pi_inv_type => l_tab_nith(l_tab_nith_count).nith_nit_id
             , pi_pk       => g_tab_inv(g_tab_inv_count).iit_ne_id
             , pi_x        => g_tab_inv(g_tab_inv_count).iit_x 
             , pi_y        => g_tab_inv(g_tab_inv_count).iit_y
             , pi_shape    => l_geom
             , pi_start_dt => g_tab_inv(g_tab_inv_count).iit_start_date
             );
          end;
        END IF;
      -- tab_nith loop
      END LOOP;
    -- tab_nith check
    END IF;
  --g_tab_inv loop
  END LOOP;
--
  nm3homo.g_homo_touch_flag := l_homo_touch_flag;
--
END process_inv_xy_update;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_inv_xy_update
         ( pi_inv_type IN nm_inv_types.nit_inv_type%TYPE )
IS
--
-- Task 0108731
-- Process the entire asset type in bulk
-- for the intial creation and refreshing
-- of the layer
--
  l_nth            nm_themes_all%ROWTYPE;
  l_nit            nm_inv_types%ROWTYPE;
  l_x_dp           nm_inv_type_attribs.ita_dec_places%TYPE;
  l_y_dp           nm_inv_type_attribs.ita_dec_places%TYPE;
  lstr             nm3type.max_varchar2;
  lf               VARCHAR2(10) := chr(10);
  l_spatial_index  user_indexes.index_name%TYPE;
  l_srid           NUMBER;
  b_defer          BOOLEAN := FALSE;
  g_nte_job_id     NM_NW_TEMP_EXTENTS.nte_job_id%TYPE;
--
  CURSOR c1 IS
    SELECT sdo_srid
      FROM mdsys.sdo_geom_metadata_table
         , nm_themes_all
         , TABLE ( nm3sdo.get_nw_themes().nta_theme_array ) t
     WHERE sdo_table_name = nth_feature_table
       AND sdo_column_name = nth_feature_shape_column
       AND sdo_owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
       AND nth_theme_id = t.nthe_id;
--
  FUNCTION is_located ( pi_inv_type IN nm_inv_types.nit_inv_type%TYPE) RETURN BOOLEAN
  IS
    l_rec_nin nm_inv_nw%ROWTYPE;
  BEGIN
    SELECT * INTO l_rec_nin FROM nm_inv_nw
    WHERE nin_nit_inv_code = pi_inv_type
      AND ROWNUM = 1;
    RETURN TRUE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN FALSE;
  END is_located;
--
BEGIN
--
-- Get the Base table Theme
  BEGIN
	  SELECT nm_themes_all.* INTO l_nth
	    FROM nm_themes_all, nm_theme_gtypes, nm_inv_types, nm_inv_themes
	   WHERE nith_nth_theme_id        = nth_theme_id
	     AND nth_dependency           = 'I'
	     AND nth_base_table_theme     IS NULL
	     AND nth_location_updatable   = 'Y'
	     AND nth_theme_type           = nm3sdo.c_sdo
	     AND nth_x_column             IS NOT NULL
	     AND nth_y_column             IS NOT NULL
	     AND ntg_theme_id             = nth_theme_id
	     AND ntg_gtype                = 2001
	     AND nit_inv_type             = nith_nit_id
	     AND nit_use_xy               = 'Y'
	     AND nith_nit_id              = pi_inv_type;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN;
  END;
--
-- Get the srid
  OPEN c1;
  FETCH c1 INTO l_srid;
  CLOSE c1;
--
-- Get the DPs for the attributes
  BEGIN
    SELECT x.ita_dec_places, y.ita_dec_places INTO l_x_dp, l_y_dp
      FROM nm_inv_type_attribs x, nm_inv_type_attribs y
     WHERE x.ita_inv_type = pi_inv_type
       AND y.ita_inv_type = pi_inv_type
       AND x.ita_attrib_name = 'IIT_X'
       AND y.ita_attrib_name = 'IIT_Y';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
  END;
--
  BEGIN
    SELECT index_name INTO l_spatial_index FROM all_indexes
     WHERE owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
       AND index_type = 'DOMAIN'
       AND table_name = l_nth.nth_feature_table;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN l_spatial_index := NULL;
  END;
--
-------------------------------------------------------------------------------
--
-- Drop the index to aim performance of the insert.
-- It is quicker to drop / insert / recreate rather than insering with index in place.
--
-- Seems to be quicker than defer the index
--
-------------------------------------------------------------------------------
--
  IF l_spatial_index IS NOT NULL
  THEN
    BEGIN
      IF b_defer
      THEN
        EXECUTE IMMEDIATE 'ALTER INDEX ' || l_spatial_index || ' PARAMETERS (''index_status=deferred'')';
      ELSE
        EXECUTE IMMEDIATE 'DROP INDEX '||l_spatial_index;
      END IF;
    EXCEPTION
    WHEN OTHERS THEN
      NULL;-- IF THE INDEX IS ALREADY DEFERRED CARRY ON.
    END;
  END IF;
--
  lstr := 'INSERT /*+ APPEND */ into ' || l_nth.nth_feature_table || lf;
  lstr := lstr || '       ( ' || l_nth.nth_feature_pk_column || ',';
--
 -- Get the sequence name
  IF l_nth.nth_sequence_name IS NOT NULL THEN
     lstr := lstr || ' OBJECTID ,';
  END IF;
--
 -- Does the table need dates?
  IF l_nth.nth_use_history = 'Y'
  AND l_nth.nth_start_date_column IS NOT NULL
  AND l_nth.nth_end_date_column   IS NOT NULL
  THEN
     lstr := lstr ||' '||l_nth.nth_start_date_column||', ';
     lstr := lstr ||' '||l_nth.nth_end_date_column||', ';
  END IF;
--
  lstr := lstr || l_nth.nth_feature_shape_column || ')' || lf;
  --lstr := lstr || '     values (:pk_id, ';
  lstr := lstr || '     select iit_ne_id, ';
--
 -- Set the sequence name
  IF l_nth.nth_sequence_name IS NOT NULL THEN
     lstr := lstr ||' '||l_nth.nth_sequence_name||'.nextval, ';
  END IF;
--
 -- Set the start/end date columns
  IF l_nth.nth_use_history = 'Y'
  AND l_nth.nth_start_date_column IS NOT NULL
  AND l_nth.nth_end_date_column   IS NOT NULL
  THEN
     lstr := lstr ||'  iit_start_date, ';
     lstr := lstr ||'  iit_end_date, ';
  END IF;
--
  lstr := lstr || ' mdsys.sdo_geometry( 2001, :l_srid, mdsys.sdo_point_type( iit_x, iit_y, NULL), NULL, NULL)';
  lstr := lstr ||'   FROM nm_inv_items_all i';
  lstr := lstr ||'  WHERE iit_inv_type = '||nm3flx.string(pi_inv_type);
  lstr := lstr ||'    AND iit_x IS NOT NULL';
  lstr := lstr ||'    AND iit_y IS NOT NULL';
  lstr := lstr ||'    AND NOT EXISTS ';
  lstr := lstr ||'      (SELECT 1 FROM '||l_nth.nth_feature_table||' s ';
  lstr := lstr ||'       WHERE i.iit_ne_id = s.'||l_nth.nth_feature_pk_column;
  lstr := lstr ||'        AND i.iit_start_date = s.'||l_nth.nth_start_date_column||')';
--
--  nm_debug.debug_on;
--  nm_debug.debug(lstr);
--
  EXECUTE IMMEDIATE lstr USING IN l_srid;
--
-------------------------------------------------------------------------------
-- Create the index - this will fail if it already exists so suppress the errors
--
-- Deferring is slower
-------------------------------------------------------------------------------
--
  IF l_spatial_index IS NOT NULL
  THEN
    IF b_defer
    THEN
      EXECUTE IMMEDIATE 'ALTER INDEX ' || l_spatial_index || ' PARAMETERS (''index_status=synchronize'')';
    ELSE
      nm3sdo.create_spatial_idx(l_nth.nth_feature_table, l_nth.nth_feature_shape_column);
    END IF;
  END IF;
--
-------------------------------------------------------------------------------
--                       Generate Members Locations
-------------------------------------------------------------------------------
--

-- Task 0110967
--  Removed the derivation of the NM_LREF in the bulk collect as it can fail if
--  not network snaps are found. This can be an issue now that the code is correctly
--  restricting on the Asset theme ID when finding the nearest network.
--
--  Performance is poor - this will be dealt with in Task 0110968 for 4.5.0.0 hopefully.
--
--
  IF is_located ( pi_inv_type => pi_inv_type)
  THEN
  --
    DECLARE
    --
      TYPE rec_lrefs IS RECORD ( iit_ne_id       nm_inv_items.iit_ne_id%TYPE
                               , iit_start_date  nm_inv_items.iit_start_date%TYPE
                               , iit_x           nm_inv_items.iit_x%TYPE
                               , iit_y           nm_inv_items.iit_y%TYPE);
                             --  , lref      nm_lref );
      TYPE tab_lrefs IS TABLE OF rec_lrefs INDEX BY BINARY_INTEGER;
    --
      l_tab_lrefs    tab_lrefs;
      limit_in       INTEGER := 1000;
      count_lrefs    INTEGER := 0;
      l_unit         nm_units.un_unit_id%TYPE;
    --
      l_lref         nm_lref;
    --
      l_theme_list   nm_theme_array := nm3array.init_nm_theme_array;
    --
      CURSOR get_lrefs (theme_id IN NUMBER)
      IS
        SELECT iit_ne_id, iit_start_date, iit_x, iit_y
--, nm3sdo.get_nearest_nw_to_xy(iit_x, iit_y)
--        SELECT iit_ne_id
--             , nm3sdo.get_nearest_lref
--                   ( theme_id
--                   , mdsys.sdo_geometry ( 2001
--                                       , l_srid
--                                       , mdsys.sdo_point_type( iit_x, iit_y, NULL)
--                                       , NULL
--                                       , NULL)
--                                        )
          FROM nm_inv_items_all a
         WHERE iit_inv_type = pi_inv_type
           AND iit_x IS NOT NULL
           AND NOT EXISTS
            (SELECT 1 FROM nm_members_all
              WHERE iit_ne_id = nm_ne_id_in
                AND nm_obj_type = pi_inv_type);
    --
    BEGIN
    --
      --nm_debug.debug_on;
    --
      OPEN get_lrefs (l_nth.nth_theme_id);
    --
      LOOP
      --
        FETCH get_lrefs BULK COLLECT INTO l_tab_lrefs LIMIT limit_in;
      --
        FOR i IN 1..l_tab_lrefs.COUNT
        LOOP
        --
          BEGIN
          --
          -- This is all very slow and ineffecient - we need to re-write this in the future.
          --
            l_lref := nm3sdo.get_nearest_lref
                        ( l_nth.nth_theme_id
                        , mdsys.sdo_geometry ( 2001
                                            , l_srid
                                            , mdsys.sdo_point_type( l_tab_lrefs(i).iit_x, l_tab_lrefs(i).iit_y, NULL)
                                            , NULL
                                            , NULL)
                                             );
          --
            l_unit := NVL(nm3get.get_nt
                             ( pi_nt_type         => nm3get.get_ne
                                                       ( pi_ne_id            => l_lref.lr_ne_id
                                                       , pi_raise_not_found  => FALSE ).ne_nt_type
                             , pi_raise_not_found => FALSE).nt_length_unit,1);
          --
            l_lref.lr_offset := nm3unit.get_formatted_value(l_lref.lr_offset,l_unit);
          --
            nm3extent.create_temp_ne
              ( l_lref.lr_ne_id
              , nm3extent.c_route
              , l_lref.lr_offset
              , l_lref.lr_offset
              , g_nte_job_id );
          --
            nm3homo.homo_update
              ( p_temp_ne_id_in  => g_nte_job_id
              , p_iit_ne_id      => l_tab_lrefs(i).iit_ne_id
              -- Task 0108731
              -- Use asset start date
              , p_effective_date => l_tab_lrefs(i).iit_start_date);
          --
          EXCEPTION
            WHEN OTHERS 
              THEN nm_debug.debug('Locating '||SQLERRM);
          END;
        --
        END LOOP;
      --
        EXIT WHEN l_tab_lrefs.COUNT = 0;
      --
      END LOOP;
    --
      CLOSE get_lrefs;
    --
    END;
  --
  END IF;
--
-------------------------------------------------------------------------------
--                 Generate Members Locations Finished
-------------------------------------------------------------------------------
--
--EXCEPTION
--  WHEN NO_DATA_FOUND THEN NULL;
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
  IF NOT test_theme_for_update(pi_nth_id) then
    HIG.RAISE_NER('NET', 339);
  END IF;

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
  IF NOT test_theme_for_update(pi_nth_id) then
    HIG.RAISE_NER('NET', 339);
  END IF;

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
