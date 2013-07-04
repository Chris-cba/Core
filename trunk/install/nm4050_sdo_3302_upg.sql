--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4050_sdo_3302_upg.sql-arc   3.4   Jul 04 2013 14:15:38   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4050_sdo_3302_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:15:38  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:14:56  $
--       Version          : $Revision:   3.4  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--


PROMPT
PROMPT =========================================================================
PROMPT
PROMPT Exor 4050 Spatial Data Upgrade - 3D Features
PROMPT
PROMPT =========================================================================
PROMPT
PROMPT Creating temporary function x_is_3d

CREATE OR REPLACE FUNCTION x_is_3d (tab IN VARCHAR2, col IN VARCHAR2)
   RETURN VARCHAR2
IS
   l_gtype  NUMBER;
BEGIN
   EXECUTE IMMEDIATE    'select a.'
                     || col
                     || '.sdo_gtype  from '
                     || tab
                     || ' a where rownum=1'
                INTO l_gtype;
   IF to_char(l_gtype) LIKE '3%'
   THEN 
     RETURN 'Y';
   ELSE
     RETURN 'N';
   END IF;
EXCEPTION
  WHEN OTHERS THEN RETURN 'N';
END;
/

PROMPT
PROMPT Creating temporary function x_get_index_name

CREATE OR REPLACE FUNCTION x_get_index_name (tab IN VARCHAR2, col IN VARCHAR2)
  RETURN VARCHAR2
IS
  retval VARCHAR2(30);
BEGIN
  SELECT i.index_name
    INTO retval
    FROM user_indexes i, user_ind_columns c
   WHERE i.table_name = tab
     AND c.column_name = col
     AND c.index_name = i.index_name
     AND i.index_type = 'DOMAIN';
   RETURN retval;
EXCEPTION
  WHEN OTHERS THEN RETURN NULL;
END x_get_index_name;
/

set serverout on;

PROMPT
PROMPT =========================================================================
PROMPT
PROMPT Processing spatial data - 3D geometries
PROMPT
PROMPT This process may take some time.... please wait
PROMPT
PROMPT =========================================================================
PROMPT

DECLARE
--
   TYPE rec_data IS RECORD (table_name  VARCHAR2(30)
                          , column_name VARCHAR2(30)
                          , is_3d       VARCHAR2(1)
                          , index_name  VARCHAR2(30) );
   TYPE tab_data IS TABLE OF rec_data INDEX BY BINARY_INTEGER;
   l_tab_data    tab_data;
   l_tab_gtypes  nm3type.tab_number;
   lidx          VARCHAR2 (30);
   lg_from       NUMBER;
   lg_to         NUMBER;
   l_op          VARCHAR2(2000);
   l_validation  nm3type.tab_varchar30;
--
   CURSOR c1
   IS
      WITH all_3d_layers AS
           (SELECT nth_theme_id, nth_feature_table, nth_feature_shape_column,
                   x_is_3d (nth_feature_table,
                            nth_feature_shape_column) is_3d
              FROM nm_themes_all
             WHERE nth_base_table_theme IS NULL
               AND nth_theme_type = 'SDO'
               AND EXISTS
                 (SELECT 1 FROM user_tables
                   WHERE table_name = nth_feature_table))
      SELECT nth_feature_table
           , nth_feature_shape_column
           , is_3d
           , x_get_index_name ( nth_feature_table, nth_feature_shape_column )
        FROM all_3d_layers
       WHERE is_3d = 'Y';
--
  PROCEDURE sop (text IN nm3type.max_varchar2 ) 
  IS
    PRAGMA autonomous_transaction;
  BEGIN
    dbms_output.put_line (text);
  END sop;
--
  FUNCTION get_gtypes (tab IN VARCHAR2, col IN VARCHAR2)
     RETURN nm3type.tab_number
  IS
     l_gtypes  nm3type.tab_number;
  BEGIN
     l_gtypes.DELETE;
     EXECUTE IMMEDIATE    'select unique a.'
                       || col
                       || '.sdo_gtype from '
                       || tab
                       || ' a where a.'||col||'.sdo_gtype > 3000 '
                       ||   '   and a.'||col||'.sdo_gtype < 3300 '
     BULK COLLECT INTO l_gtypes;
     RETURN l_gtypes;
  EXCEPTION
    WHEN OTHERS THEN RETURN l_gtypes;
  END get_gtypes;
--
  FUNCTION get_max_gtype (tab IN VARCHAR2, col IN VARCHAR2)
     RETURN number
  IS
     l_gtype  number;
  BEGIN
     EXECUTE IMMEDIATE    'select max ( a.'
                       || col
                       || '.sdo_gtype ) from '
                       || tab
                       || ' a '
     INTO l_gtype;
     RETURN l_gtype;
  END get_max_gtype;
--
BEGIN
--
  dbms_output.enable;
--
  OPEN c1;
  FETCH c1 BULK COLLECT INTO l_tab_data;
  CLOSE c1;
--  
  IF l_tab_data.COUNT > 0
  THEN
--
    FOR i IN 1..l_tab_data.COUNT
    LOOP
    --
      DECLARE
        l_gtype NUMBER;
      BEGIN
        l_tab_gtypes := get_gtypes ( l_tab_data(i).table_name
                                   , l_tab_data(i).column_name );
      --
        IF l_tab_gtypes.COUNT > 0
        THEN
      --
          l_op := 'Dropping spatial index';
        --
          IF l_tab_data(i).index_name IS NOT NULL
          THEN
            EXECUTE IMMEDIATE 'drop index ' ||l_tab_data(i).index_name ;
          END IF;
        --
          FOR g IN 1..l_tab_gtypes.COUNT
          LOOP
        --

            BEGIN
              --
                l_op := 'Updating data ['||l_tab_gtypes(g)||']';
              --
                EXECUTE IMMEDIATE    'update '
                                  || l_tab_data(i).table_name
                                  || ' a set a.'
                                  || l_tab_data(i).column_name
                                  || '.sdo_gtype = 300 + a.'|| l_tab_data(i).column_name
                                                            || '.sdo_gtype'
                                  || ' where a.'||l_tab_data(i).column_name
                                  || '.sdo_gtype = '||l_tab_gtypes(g);
              --
                sop('Processed '||l_tab_data(i).table_name||' - '||SQL%ROWCOUNT||' rows updated');
              --
           --
            EXCEPTION
              WHEN OTHERS
              THEN sop ('Error processing '||l_tab_data(i).table_name||' ['||l_tab_gtypes(g)||']'
                       ||' - '||l_op||' - '||SQLERRM);
            END;
          --
          END LOOP;
        --
          l_op := 'Creating spatial index';
        --
          nm3sdo.create_spatial_idx (l_tab_data(i).table_name,
                                     l_tab_data(i).column_name);
        --
          l_op := 'Updating NM_THEME_GTYPES';
        --
          l_gtype := get_max_gtype(l_tab_data(i).table_name,
                                   l_tab_data(i).column_name);
        --
          UPDATE nm_theme_gtypes
             SET ntg_gtype = l_gtype
           WHERE ntg_theme_id IN
                  ( SELECT nth_theme_id
                      FROM nm_themes_all
                     WHERE nth_feature_table = l_tab_data(i).table_name
                       AND nth_feature_shape_column = l_tab_data(i).column_name
                    UNION
                    SELECT nth_theme_id
                      FROM nm_themes_all a
                     WHERE nth_base_table_theme IN 
                         (SELECT nth_theme_id
                            FROM nm_themes_all b
                           WHERE nth_feature_table = l_tab_data(i).table_name
                             AND nth_feature_shape_column = l_tab_data(i).column_name));
        --
        ELSE
        --
          sop('No suitable GTypes for update on '||l_tab_data(i).table_name);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN sop('Error processing '||l_tab_data(i).table_name||' when '||l_op||' - '||SQLERRM);
      END;
    --
    END LOOP;
  --
  ELSE
  --
    sop ('No 3D layers found - nothing processed');
  END IF;
  --
  COMMIT;
--
END;
/
PROMPT 
PROMPT =========================================================================
PROMPT
PROMPT Dropping temporary functions
PROMPT

DROP FUNCTION x_is_3d;
DROP FUNCTION x_get_index_name;

PROMPT =========================================================================
PROMPT
PROMPT Finished
PROMPT
PROMPT =========================================================================
PROMPT
-- 


