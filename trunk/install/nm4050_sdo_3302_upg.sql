--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm4050_sdo_3302_upg.sql-arc   3.1   Aug 14 2008 08:44:20   aedwards  $
--       Module Name      : $Workfile:   nm4050_sdo_3302_upg.sql  $
--       Date into PVCS   : $Date:   Aug 14 2008 08:44:20  $
--       Date fetched Out : $Modtime:   Aug 14 2008 08:42:40  $
--       PVCS Version     : $Revision:   3.1  $
--
--------------------------------------------------------------------------------
--


PROMPT
PROMPT =========================================================================
PROMPT
PROMPT Exor 4050 Spatial Data Upgrade - Linear features
PROMPT
PROMPT =========================================================================
PROMPT
PROMPT Creating temporary function x_get_max_gtype

CREATE OR REPLACE FUNCTION x_get_max_gtype (tab IN VARCHAR2, col IN VARCHAR2)
   RETURN NUMBER
IS
   retval   NUMBER;
BEGIN
   EXECUTE IMMEDIATE    'select max( a.'
                     || col
                     || '.sdo_gtype ) from '
                     || tab
                     || ' a'
                INTO retval;

   RETURN retval;
EXCEPTION
  WHEN OTHERS THEN RETURN NULL;
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
PROMPT Processing spatial data - converting 3002 geometries to 3302
PROMPT
PROMPT This process may take some time.
PROMPT
PROMPT =========================================================================
PROMPT

DECLARE
--
   TYPE rec_data IS RECORD (table_name  VARCHAR2(30)
                          , column_name VARCHAR2(30)
                          , gtype       NUMBER
                          , index_name  VARCHAR2(30) );
   TYPE tab_data IS TABLE OF rec_data INDEX BY BINARY_INTEGER;
   l_tab_data    tab_data;
   lidx          VARCHAR2 (30);
   lg_from       NUMBER;
   lg_to         NUMBER;
   l_op          VARCHAR2(2000);
   l_validation  nm3type.tab_varchar30;
--
   CURSOR c1
   IS
      WITH all_gtypes AS
           (SELECT nth_theme_id, nth_feature_table, nth_feature_shape_column,
                   x_get_max_gtype (nth_feature_table,
                                    nth_feature_shape_column
                                  ) gtype
              FROM nm_themes_all
             WHERE nth_base_table_theme IS NULL
               AND nth_theme_type = 'SDO'
               --AND nth_feature_table = 'NM_NIT_CT_SDO'
               AND EXISTS
                 (SELECT 1 FROM user_tables
                   WHERE table_name = nth_feature_table))
      SELECT nth_feature_table
           , nth_feature_shape_column
           , gtype geom_type
           , x_get_index_name ( nth_feature_table, nth_feature_shape_column )
        FROM all_gtypes
       WHERE gtype > 3000
         AND gtype < 3300;
--
  PROCEDURE sop (text IN nm3type.max_varchar2 ) 
  IS
    PRAGMA autonomous_transaction;
  BEGIN
    dbms_output.put_line (text);
  END sop;
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
      BEGIN
      --
          l_op := 'Dropping spatial index';
        --
          IF l_tab_data(i).index_name IS NOT NULL
          THEN
            EXECUTE IMMEDIATE 'drop index ' ||l_tab_data(i).index_name ;
          END IF;
      --
          lg_from := l_tab_data(i).gtype;
          lg_to   := 300 + l_tab_data(i).gtype;
        --
          l_op := 'Updating data';
        --
          EXECUTE IMMEDIATE    'update '
                            || l_tab_data(i).table_name
                            || ' a set a.'
                            || l_tab_data(i).column_name
                            || '.sdo_gtype = '
                            || TO_CHAR (lg_to)
                            || ' where a.'
                            || l_tab_data(i).column_name
                            || '.sdo_gtype = '
                            || TO_CHAR (lg_from);
        --
          sop('Processed '||l_tab_data(i).table_name||' - '||SQL%ROWCOUNT||' rows updated');
        --
          l_op := 'Creating spatial index';
        --
          nm3sdo.create_spatial_idx (l_tab_data(i).table_name,
                                     l_tab_data(i).column_name);
        --
          l_op := 'Updating NM_THEME_GTYPES';
        --
          UPDATE nm_theme_gtypes
             SET ntg_gtype = lg_to
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
                             AND nth_feature_shape_column = l_tab_data(i).column_name)
                  );
     --
      EXCEPTION
        WHEN OTHERS
        THEN sop ('Error processing '||l_tab_data(i).table_name
                 ||' - '||l_op||' - '||SQLERRM);
      END;
    --
    END LOOP;
  --
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

DROP FUNCTION x_get_max_gtype;
DROP FUNCTION x_get_index_name;

PROMPT =========================================================================
PROMPT
PROMPT Finished
PROMPT
PROMPT =========================================================================
PROMPT
-- 


