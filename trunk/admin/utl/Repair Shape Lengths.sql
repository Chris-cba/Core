--

SET SERVEROUTPUT ON
--
-- Repair the mismatched Datum Layer shape lengths
--
DECLARE
  nl      VARCHAR2(10) := CHR(10);
  l_sql   nm3type.max_varchar2;
BEGIN
  dbms_output.enable(1000000);
  dbms_output.put_line ( '# Correcting Element/Shape lengths');
--
  FOR i IN 
  (
  --
    SELECT *
      FROM nm_themes_all
     WHERE nth_theme_id IN
              (SELECT nth_theme_id
                 FROM nm_themes_all
                WHERE nth_base_table_theme IS NULL
                      AND EXISTS
                             (SELECT 'table exists'
                                FROM user_tables
                               WHERE table_name = nth_feature_table)
                      AND EXISTS
                             (SELECT 'is a datum network theme'
                                FROM v_nm_net_themes_all
                               WHERE vnnt_nth_theme_id = nth_theme_id
                                     AND vnnt_lr_type IN ('D')))
           AND NM3SDO.GET_THEME_GTYPE (nth_theme_id) = 3302
  --
  )
  LOOP
    dbms_output.put_line('================================================================================');
    dbms_output.put_line ( '## Processing Theme ['||i.nth_theme_id||'] '||i.nth_feature_table||' - Started');
  --
    l_sql := 
      'DECLARE '||nl||
      '  l_geom  MDSYS.SDO_GEOMETRY;'||nl||
      '  l_total NUMBER := 0;'||nl||
      'BEGIN '||nl||
      '  FOR z IN ( SELECT a.'||i.nth_feature_pk_column||' pk_column, '||i.nth_feature_shape_column 
                 ||', diminfo, ne_length FROM '||i.nth_feature_table||' a, nm_elements_all b , user_sdo_geom_metadata '||nl||
                  '  WHERE a.'||i.nth_feature_pk_column||' = b.ne_id '||nl||
                     ' AND table_name = '||nm3flx.string(i.nth_feature_table)||nl||
                     ' AND column_name = '||nm3flx.string(i.nth_feature_shape_column)||nl||
                     ' AND sdo_lrs.geom_segment_end_measure('||i.nth_feature_shape_column||') != ne_length )'||nl||
      '  LOOP '||nl||
         ' l_total := l_total+1;'||nl||
         ' l_geom := z.'|| i.nth_feature_shape_column||';'||nl||
         ' sdo_lrs.redefine_geom_segment (l_geom, z.diminfo, 0, z.ne_length );'||nl||
      '    UPDATE '||i.nth_feature_table||' SET '||i.nth_feature_shape_column||' = l_geom'||nl||
          ' WHERE '||i.nth_feature_pk_column||' = z.pk_column;'||nl||
      '  END LOOP;'||nl||
      '  dbms_output.put_line('||nm3flx.string('## ')||'|| l_total ||'||nm3flx.string(' rows updated')||'); '||nl||
      'END;';
  --
    EXECUTE IMMEDIATE l_sql;
    -- dbms_output.put_line ('$'||l_sql);
  --
    dbms_output.put_line ( '## Processing Theme ['||i.nth_theme_id||'] '||i.nth_feature_table||' - Finished'); 
    dbms_output.put_line('================================================================================');
  END LOOP;
  dbms_output.put_line ( '# Correcting Element/Shape lengths complete - Please review and issue a COMMIT to finish');
END;
/

