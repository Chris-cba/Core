CREATE OR REPLACE PACKAGE BODY nm_inv_sdo_aggr
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/nm_inv_sdo_aggr.pkb-arc   1.5   Jun 30 2016 16:22:56   Rob.Coupe  $
   --       Module Name      : $Workfile:   nm_inv_sdo_aggr.pkb  $
   --       Date into PVCS   : $Date:   Jun 30 2016 16:22:56  $
   --       Date fetched Out : $Modtime:   Jun 30 2016 16:23:18  $
   --       PVCS Version     : $Revision:   1.5  $
   --
   --   Author : R.A. Coupe
   --
   --   Package for code which produces aggregated geometry for assets.
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --


   qq                       VARCHAR2 (1) := CHR (39);

   g_ds_sql                 VARCHAR2 (4000)
      :=    'SELECT m.nm_ne_id_in, '
         || 'd1.start_date,'
         || 'd1.end_date,'
         || 'm.nm_ne_id_of,'
         || 'm.nm_begin_mp,'
         || 'm.nm_end_mp, '
         || 'SDO_LRS.convert_to_std_geom (SDO_LRS.clip_geom_segment ( '
         || ' <feature_shape>, '
         || ' nm_begin_mp, '
         || ' nm_end_mp, '
         || ' 0.005)) '
         || ' shape '
         || ' FROM date_tracked_assets d1, '
         || ' nm_members_all m, '
         || ' <network_shape_table> s '
         || ' WHERE     m.nm_ne_id_in = d1.nm_ne_id_in '
         || ' AND m.nm_ne_id_of = s.<feature_pk_column> '
         || ' AND m.nm_start_date <= d1.start_date '
         || 'AND NVL (m.nm_end_date, TO_DATE ('
         || qq
         || '31123000'
         || qq
         || ', '
         || qq
         || 'DDMMYYYY'
         || qq
         || ')) >= '
         || 'd1.end_date';

   TABLE_NOT_EXISTS EXCEPTION;
   pragma exception_init ( TABLE_NOT_EXISTS, -942 );
         
   FUNCTION is_type_aggregated (
      pi_inv_type   IN nm_inv_types.nit_inv_type%TYPE)
      RETURN BOOLEAN;

   --   FUNCTION get_table_string (pi_inv_type in varchar2 )
   --      RETURN VARCHAR2;
   PROCEDURE set_index_deferred;

   PROCEDURE synch_index;

   FUNCTION gen_inv_sql (pi_inv_type   IN VARCHAR2,
                         pi_inv_id     IN INTEGER DEFAULT NULL,
                         pi_pnt_type   IN BOOLEAN)
      RETURN VARCHAR2;

   PROCEDURE gen_inv_aggr_sdo (
      pi_inv_type   IN     nm_inv_types.nit_inv_type%TYPE,
      pi_pnt_type   IN     BOOLEAN,
      po_cur           OUT VARCHAR2,
      p_limit       IN     INTEGER DEFAULT 500);

   PROCEDURE gen_ft_aggr_sdo (pi_inv_type_row   IN     nm_inv_types%ROWTYPE,
                              po_cur               OUT VARCHAR2,
                              p_limit           IN     INTEGER DEFAULT 500);


   --

   g_body_sccsid   CONSTANT VARCHAR2 (2000) := '$Revision:   1.5  $';

   nit_not_found            PLS_INTEGER := -20002;

   FUNCTION get_version
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_sccsid;
   END get_version;

   FUNCTION get_body_version
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_body_sccsid;
   END get_body_version;

   PROCEDURE gen_aggr_sdo (pi_inv_type   IN nm_inv_types.nit_inv_type%TYPE,
                           p_limit       IN INTEGER DEFAULT 500)
   IS
      l_nit_row   nm_inv_types%ROWTYPE;
      p_cur       VARCHAR2 (32767);
   BEGIN
      nm_debug.debug_on;

      IF is_type_aggregated (pi_inv_type)
      THEN
         DELETE FROM nm_inv_geometry_all
               WHERE asset_type = pi_inv_type;
      --
      ELSE
         insert into nm_inv_aggr_sdo_types (nit_inv_type ) values ( pi_inv_type );
         
--         raise_application_error (
--            -20001,
--            'Asset type is not configured to hold aggregated geometry');
      END IF;

      l_nit_row := nm3get.get_nit (pi_inv_type, TRUE, nit_not_found);

      --
      IF l_nit_row.nit_table_name IS NULL
      THEN
         gen_inv_aggr_sdo (pi_inv_type,
                           l_nit_row.nit_pnt_or_cont = 'P',
                           p_cur,
                           p_limit);
      ELSE
         gen_ft_aggr_sdo (l_nit_row, p_cur, p_limit);
      END IF;
      
      create_aggr_sdo_view (
          pi_inv_type    => pi_inv_type );

      create_aggr_join_view (
          pi_inv_type    => pi_inv_type );


   END;

   PROCEDURE gen_inv_aggr_sdo (
      pi_inv_type   IN     nm_inv_types.nit_inv_type%TYPE,
      pi_pnt_type   IN     BOOLEAN,
      po_cur           OUT VARCHAR2,
      p_limit       IN     INTEGER DEFAULT 500)
   IS
      TYPE geocurtyp IS REF CURSOR;

      geocur         geocurtyp;
      cur_string     VARCHAR2 (32767);

      dml_errors     EXCEPTION;
      PRAGMA EXCEPTION_INIT (dml_errors, -24381);

      error_count    NUMBER;
      l_asset_id     NM3TYPE.TAB_NUMBER;
      l_asset_type   NM3TYPE.TAB_VARCHAR4;
      l_start_date   NM3TYPE.TAB_DATE;
      l_end_date     NM3TYPE.TAB_DATE;

      TYPE tab_geom IS TABLE OF MDSYS.sdo_geometry
         INDEX BY BINARY_INTEGER;

      l_geom         TAB_GEOM;
   BEGIN
      nm_debug.debug_on;
      cur_string :=
         gen_inv_sql (pi_inv_type => pi_inv_type, pi_pnt_type => pi_pnt_type);

      nm_debug.debug (cur_string);

      po_cur := cur_string;

      set_index_deferred;

      OPEN geocur FOR cur_string USING pi_inv_type, pi_inv_type, pi_inv_type;

      FETCH geocur
         BULK COLLECT INTO l_asset_id,
              l_asset_type,
              l_start_date,
              l_end_date,
              l_geom
         LIMIT p_limit;

      WHILE l_asset_id.COUNT > 0
      LOOP
         BEGIN
            FORALL i IN 1 .. l_asset_id.COUNT SAVE EXCEPTIONS
               INSERT INTO nm_inv_geometry_all (asset_id,
                                                asset_type,
                                                start_date,
                                                end_date,
                                                shape)
                    VALUES (l_asset_id (i),
                            l_asset_type (i),
                            l_start_date (i),
                            l_end_date (i),
                            l_geom (i));

            COMMIT;
         --
         EXCEPTION
            WHEN dml_errors
            THEN
               error_count := SQL%BULK_EXCEPTIONS.COUNT;
               nm_debug.debug (
                  'Number of statements that failed: ' || error_count);
         END;

         FETCH geocur
            BULK COLLECT INTO l_asset_id,
                 l_asset_type,
                 l_start_date,
                 l_end_date,
                 l_geom
            LIMIT p_limit;
      END LOOP;

      CLOSE geocur;

      COMMIT;

      SYNCH_INDEX;
   END;

   --
   PROCEDURE gen_ft_aggr_sdo (pi_inv_type_row   IN     nm_inv_types%ROWTYPE,
                              po_cur               OUT VARCHAR2,
                              p_limit           IN     INTEGER DEFAULT 500)
   IS
      TYPE geocurtyp IS REF CURSOR;

      geocur            geocurtyp;
      cur_string        VARCHAR2 (4000);

      l_pk_column       VARCHAR2 (30);
      l_st_column       VARCHAR2 (30);
      l_end_column      VARCHAR2 (30);
      l_ne_column       VARCHAR2 (30);
      l_feature_table   VARCHAR2 (30);
      l_feature_pk      VARCHAR2 (30);
      l_feature_shape   VARCHAR2 (30);
      l_nw_type         VARCHAR2 (4);

      l_asset_id        NM3TYPE.TAB_NUMBER;
      l_asset_type      NM3TYPE.TAB_VARCHAR4;
      l_start_date      NM3TYPE.TAB_DATE;

      TYPE tab_geom IS TABLE OF MDSYS.sdo_geometry
         INDEX BY BINARY_INTEGER;

      l_geom            TAB_GEOM;

      l_geom_str        VARCHAR2 (2000);

      dml_errors        EXCEPTION;
      PRAGMA EXCEPTION_INIT (dml_errors, -24381);

      error_count       NUMBER;
   BEGIN
      nm_debug.debug_on;
      --
      l_geom_str := 'sdo_aggr_union (sdoaggrtype (shape, 0.005))';

      IF pi_inv_type_row.nit_pnt_or_cont = 'P'
      THEN
         l_geom_str := 'shape';
      END IF;

      SELECT nin_nw_type,
             nth_feature_table,
             nth_feature_pk_column,
             nth_feature_shape_column
        INTO l_nw_type,
             l_feature_table,
             l_feature_pk,
             l_feature_shape
        FROM nm_inv_nw,
             nm_inv_types,
             nm_linear_types,
             nm_nw_themes,
             nm_themes_all
       WHERE     nin_nit_inv_code = nit_inv_type
             AND nin_nit_inv_code = pi_inv_type_row.nit_inv_type
             AND nin_nw_type = nlt_nt_type
             AND nlt_g_i_d = 'D'
             AND nnth_nlt_id = nlt_id
             AND nnth_nth_theme_id = nth_theme_id
             AND nth_base_table_theme IS NULL;

      --
      cur_string :=
            'SELECT asset_id, asset_type, trunc(sysdate), '
         || l_geom_str
         || ' FROM (SELECT '
         || pi_inv_type_row.nit_foreign_pk_column
         || ' asset_id, '
         || qq
         || pi_inv_type_row.nit_inv_type
         || qq
         || ' asset_type, '
         || '   SDO_LRS.convert_to_std_geom (SDO_LRS.clip_geom_segment ( '
         || l_feature_shape
         || ','
         || pi_inv_type_row.nit_lr_st_chain
         || ','
         || pi_inv_type_row.nit_lr_end_chain
         || ',0.005 )) shape '
         || ' FROM '
         || pi_inv_type_row.nit_table_name||' f '
         || ', '
         || l_feature_table ||' s '
         || ' WHERE  s.'
         || l_feature_pk
         || ' = f.'
         || pi_inv_type_row.nit_lr_ne_column_name;

      --
      cur_string := cur_string || ' ) ';

      IF pi_inv_type_row.nit_pnt_or_cont != 'P'
      THEN
         cur_string := cur_string || ' GROUP BY asset_id, asset_type ';
      END IF;

      nm_debug.debug (cur_string);

      set_index_deferred;

      po_cur := cur_string;

      OPEN geocur FOR cur_string;
--         USING pi_inv_type_row.nit_inv_type, pi_inv_type_row.nit_inv_type;

      FETCH geocur
         BULK COLLECT INTO l_asset_id,
              l_asset_type,
              l_start_date,
              l_geom
         LIMIT p_limit;

      WHILE l_asset_id.COUNT > 0
      LOOP
         BEGIN
            FORALL i IN 1 .. l_asset_id.COUNT SAVE EXCEPTIONS
               INSERT INTO nm_inv_geometry_all (asset_id,
                                                asset_type,
                                                start_date,
                                                shape)
                    VALUES (l_asset_id (i),
                            l_asset_type (i),
                            l_start_date (i),
                            l_geom (i));

            COMMIT;
         --
         EXCEPTION
            WHEN dml_errors
            THEN
               error_count := SQL%BULK_EXCEPTIONS.COUNT;
               nm_debug.debug (
                  'Number of statements that failed: ' || error_count);
         END;

         FETCH geocur
            BULK COLLECT INTO l_asset_id,
                 l_asset_type,
                 l_start_date,
                 l_geom
            LIMIT p_limit;
      END LOOP;

      CLOSE geocur;

      COMMIT;

      synch_index;
   END;


   -----
   PROCEDURE create_aggr_sdo_view (
      pi_inv_type    IN nm_inv_types.nit_inv_type%TYPE,
      pi_view_name   IN VARCHAR2 DEFAULT NULL)
   IS
      l_view_name   VARCHAR2 (30)
         := NVL (pi_view_name, 'V_' || pi_inv_type || '_AGGR_SDO');
   BEGIN
      EXECUTE IMMEDIATE
            'create or replace view '
         || l_view_name
         || ' as select * from nm_inv_geometry where asset_type = '
         || ''''
         || pi_inv_type
         || ''''
         || 'AND  start_date <= (SELECT nm3context.get_effective_date FROM DUAL) '
         || 'AND NVL (end_date, TO_DATE ('
         || ''''
         || '99991231'
         || ''''
         || ', '
         || ''''
         || 'YYYYMMDD'
         || ''''
         || ')) > '
         || '     (SELECT nm3context.get_effective_date FROM DUAL) ';

      --
      BEGIN
         NM3DDL.CREATE_SYNONYM_FOR_OBJECT (l_view_name);
      END;

      --
      BEGIN
         INSERT INTO mdsys.SDO_GEOM_METADATA_TABLE (SDO_OWNER,
                                                    SDO_TABLE_NAME,
                                                    SDO_COLUMN_NAME,
                                                    SDO_DIMINFO,
                                                    SDO_SRID)
            SELECT SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER'),
                   l_view_name,
                   'SHAPE',
                   sdo_diminfo,
                   sdo_srid
              FROM mdsys.SDO_GEOM_METADATA_TABLE
             WHERE     sdo_owner =
                          SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
                   AND sdo_table_name = 'NM_INV_GEOMETRY_ALL'
                   AND sdo_column_name = 'SHAPE';
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            NULL;
      END;
   END;

   PROCEDURE create_aggr_join_view (
      pi_inv_type    IN nm_inv_types.nit_inv_type%TYPE,
      pi_view_name   IN VARCHAR2 DEFAULT NULL --      pi_aggr_view    IN VARCHAR2 DEFAULT NULL
                                             )
   IS
      l_view_name     VARCHAR2 (30)
         := NVL (pi_view_name, 'V_NM_INV_AGGR_' || pi_inv_type || '_SDO');
      --   l_aggr_view varchar2(30) := NVL (pi_aggr_view, 'V_' || pi_inv_type || '_AGGR_SDO');
      l_inv_table     VARCHAR2 (30);
      l_pk_column     VARCHAR2 (30);

      nit_not_found   PLS_INTEGER := -20002;
      l_nit_row       nm_inv_types%ROWTYPE;
   BEGIN
      l_nit_row := nm3get.get_nit (pi_inv_type, TRUE, nit_not_found);

      l_inv_table := NVL (l_nit_row.nit_table_name, 'V_NM_' || pi_inv_type);
      l_pk_column := NVL (l_nit_row.nit_foreign_pk_column, 'IIT_NE_ID');

      EXECUTE IMMEDIATE
            'create or replace view '
         || l_view_name
         || ' as select s.asset_id aggr_asset_id, i.*, s.shape aggr_shape from '
         || l_inv_table
         || ' i, nm_inv_geometry s '
         || ' where s.asset_id = '
         || l_pk_column
         || ' and s.asset_type = '
         || ''''
         || pi_inv_type
         || '''';

      --
      BEGIN
         NM3DDL.CREATE_SYNONYM_FOR_OBJECT (l_view_name);
      END;

      --
      BEGIN
         INSERT INTO mdsys.SDO_GEOM_METADATA_TABLE (SDO_OWNER,
                                                    SDO_TABLE_NAME,
                                                    SDO_COLUMN_NAME,
                                                    SDO_DIMINFO,
                                                    SDO_SRID)
            SELECT SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER'),
                   l_view_name,
                   'AGGR_SHAPE',
                   sdo_diminfo,
                   sdo_srid
              FROM mdsys.SDO_GEOM_METADATA_TABLE
             WHERE     sdo_owner =
                          SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
                   AND sdo_table_name = 'NM_INV_GEOMETRY_ALL'
                   AND sdo_column_name = 'SHAPE';
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            NULL;
      END;

   EXCEPTION
      WHEN TABLE_NOT_EXISTS
      THEN
         RAISE_APPLICATION_ERROR( -20004, 'Problem in the join view components, check the asset type metadata');
      
   END;

   --
   PROCEDURE aggregate_inv_geometry (
      pi_inv_type    IN nm_inv_types.nit_inv_type%TYPE,
      pi_iit_ne_id   IN nm_inv_items.iit_ne_id%TYPE)
   IS
      l_nit_row         nm_inv_types%ROWTYPE;

      l_table_name      VARCHAR2 (30);
      l_pk_column       VARCHAR2 (30);
      l_st_column       VARCHAR2 (30);
      l_end_column      VARCHAR2 (30);
      l_ne_column       VARCHAR2 (30);
      l_feature_table   VARCHAR2 (30);
      l_feature_pk      VARCHAR2 (30);
      l_feature_shape   VARCHAR2 (30);
      l_nw_type         VARCHAR2 (4);

      l_geom_str        VARCHAR2 (4000);
      cur_string        VARCHAR2 (32767);
      
      l_asset_id_tab nm3type.tab_number;
      l_asset_type_tab nm3type.tab_varchar4;
      l_start_date_tab nm3type.tab_date;
      l_end_date_tab nm3type.tab_date;
      TYPE tab_geom IS TABLE OF MDSYS.sdo_geometry
         INDEX BY BINARY_INTEGER;

      l_geom_tab         TAB_GEOM;
      
      TYPE geocurtyp IS REF CURSOR;

      geocur         geocurtyp;
      
   BEGIN
      nm_debug.debug_on;

      l_nit_row := nm3get.get_nit (pi_inv_type, TRUE, nit_not_found);
      --
      l_table_name := NVL (l_nit_row.nit_table_name, 'NM_MEMBERS'); -- Take date tracking out for now
      l_pk_column := NVL (l_nit_row.nit_foreign_pk_column, 'NM_NE_ID_IN');
      l_st_column := NVL (l_nit_row.nit_lr_st_chain, 'NM_BEGIN_MP');
      l_end_column := NVL (l_nit_row.nit_lr_end_chain, 'NM_END_MP');
      l_ne_column := NVL (l_nit_row.nit_lr_ne_column_name, 'NM_NE_ID_OF');

      delete from nm_inv_geometry_all
      where asset_type = pi_inv_type
      and asset_id = pi_iit_ne_id;
      --
      l_geom_str := 'sdo_aggr_union (sdoaggrtype (shape, 0.005))';

      IF l_nit_row.nit_pnt_or_cont = 'P'
      THEN
         l_geom_str := 'shape';
      END IF;

      IF l_nit_row.nit_table_name IS NULL
      THEN
         cur_string :=
            gen_inv_sql (pi_inv_type   => pi_inv_type,
                         PI_INV_ID     => pi_iit_ne_id,
                         PI_PNT_TYPE   => l_nit_row.nit_pnt_or_cont = 'P');
         nm_debug.debug(cur_string);                         

         nm_debug.debug('using type='||pi_inv_type||', ID = '||pi_iit_ne_id );

         open geocur for cur_string  USING pi_inv_type,
                  pi_iit_ne_id,
                  pi_inv_type,
                  pi_iit_ne_id,
                  pi_inv_type;

         fetch geocur bulk collect into l_asset_id_tab, l_asset_type_tab, l_start_date_tab, l_end_date_tab, l_geom_tab ;
         
         forall i in 1..l_asset_id_tab.count
         insert into nm_inv_geometry_all ( asset_id, asset_type, start_date, end_date, shape )
         values ( l_asset_id_tab(i), l_asset_type_tab(i), l_start_date_tab(i), l_end_date_tab(i), l_geom_tab(i) ) ;

-- RC> Original code is swapped with the forall insert due to the dynamic insert raising 
--     ORA-30625: method dispatch on NULL SELF argument is disallowed
--     ORA-06512: at "MDSYS.AGGRUNION", line 30
--
--         EXECUTE IMMEDIATE
--               'insert into nm_inv_geometry_all (asset_id, asset_type, start_date, end_date, shape ) '
--            || cur_string
--            USING pi_inv_type,
--                  pi_iit_ne_id,
--                  pi_inv_type,
--                  pi_iit_ne_id,
--                  pi_inv_type;
      ELSE
         --
         cur_string :=
               'SELECT asset_id, asset_type, trunc(sysdate), '
            || l_geom_str
            || ' FROM (SELECT '
            || l_pk_column
            || ' asset_id, '
            || qq
            || pi_inv_type
            || qq
            || ' asset_type, '
            || '   SDO_LRS.convert_to_std_geom (SDO_LRS.clip_geom_segment ( '
            || l_feature_shape
            || ','
            || l_st_column
            || ','
            || l_end_column
            || ',0.005 )) shape '
            || ' FROM '
            || l_table_name
            || ', '
            || l_feature_table
            || ' WHERE   '
            || l_feature_pk
            || ' = '
            || l_ne_column
            || ' and '
            || l_pk_column
            || ' = :pi_iit_ne_id )';

         IF l_nit_row.nit_pnt_or_cont != 'P'
         THEN
            cur_string := cur_string || ' GROUP BY asset_id, asset_type ';
         END IF;

         EXECUTE IMMEDIATE
               'insert into nm_inv_geometry_all (asset_id, asset_type, start_date, shape ) '
            || cur_string
            USING pi_iit_ne_id;
      END IF;
   END;

   PROCEDURE reshape_aggregated_geometry (pi_ne_id IN nm_elements.ne_id%TYPE)
   IS
      l_inv_type_tab   NM3TYPE.TAB_VARCHAR4;
      l_inv_id_tab     NM3TYPE.TAB_NUMBER;
   BEGIN
        SELECT nm_obj_type, nm_ne_id_in
          BULK COLLECT INTO l_inv_type_tab, l_inv_id_tab
          FROM nm_members, nm_inv_aggr_sdo_types
         WHERE nm_ne_id_of = pi_ne_id AND nm_obj_type = nit_inv_type
      GROUP BY nm_obj_type, nm_ne_id_in;

      --
      FOR i IN 1 .. l_inv_type_tab.COUNT
      LOOP
         aggregate_inv_geometry (l_inv_type_tab (i), l_inv_id_tab (i));
      END LOOP;
   END;

   --
   FUNCTION is_type_aggregated (
      pi_inv_type   IN nm_inv_types.nit_inv_type%TYPE)
      RETURN BOOLEAN
   IS
      retval   BOOLEAN;
      dummy    INTEGER := 0;
   --
   BEGIN
      BEGIN
         SELECT 1
           INTO dummy
           FROM nm_inv_aggr_sdo_types
          WHERE nit_inv_type = pi_inv_type;

         retval := TRUE;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            retval := FALSE;
      END;

      RETURN retval;
   END;

   --
   FUNCTION get_table_string (pi_inv_type   IN VARCHAR2,
                              pi_inv_id     IN INTEGER DEFAULT NULL)
      RETURN VARCHAR2
   IS
      retval   VARCHAR2 (32767);
   BEGIN
      WITH string1
           AS (SELECT    g_ds_sql
                      || CASE
                            WHEN pi_inv_id IS NOT NULL
                            THEN
                               ' and nm_ne_id_in = ' || pi_inv_id || ' '
                         END
                      || ' and shape is not null '
                         sql_text
                 FROM DUAL)
      SELECT LISTAGG (sql_text, ' UNION ALL ')
                WITHIN GROUP (ORDER BY nth_feature_table)
        INTO retval
        FROM (SELECT nin_nw_type,
                     nth_feature_table,
                     nth_feature_pk_column,
                     nth_feature_shape_column,
                     REPLACE (
                        REPLACE (
                           REPLACE (sql_text,
                                    '<network_shape_table>',
                                    nth_feature_table),
                           '<feature_pk_column>',
                           nth_feature_pk_column),
                        '<feature_shape>',
                        nth_feature_shape_column)
                        SQL_TEXT
                FROM nm_inv_nw,
                     nm_inv_types,
                     nm_linear_types,
                     nm_nw_themes,
                     nm_themes_all,
                     string1
               WHERE     nin_nit_inv_code = nit_inv_type
                     AND nin_nit_inv_code = pi_inv_type
                     AND nin_nw_type = nlt_nt_type
                     AND nlt_g_i_d = 'D'
                     AND nnth_nlt_id = nlt_id
                     AND nnth_nth_theme_id = nth_theme_id
                     AND nth_base_table_theme IS NULL);

      RETURN retval;
   END;

   FUNCTION gen_inv_sql (pi_inv_type   IN VARCHAR2,
                         pi_inv_id     IN INTEGER DEFAULT NULL,
                         pi_pnt_type   IN BOOLEAN)
      RETURN VARCHAR2
   IS
      cur_string    VARCHAR2 (32767);
      geom_string   VARCHAR2 (50);
   BEGIN
      IF pi_pnt_type
      THEN
         geom_string := 'shape';
      ELSE
         geom_string := 'sdo_aggr_union (sdoaggrtype (shape, 0.005))';
      END IF;

      cur_string :=
            ' WITH date_tracked_assets '
         || ' AS (SELECT d.nm_ne_id_in, d.start_date, d.end_date '
         || ' FROM (SELECT nm_ne_id_in, '
         || ' start_date, '
         || ' LEAD ( '
         || ' start_date, '
         || ' 1) '
         || ' OVER (PARTITION BY nm_ne_id_in '
         || ' ORDER BY start_date) '
         || ' end_date '
         || ' FROM (SELECT nm_ne_id_in, nm_start_date start_date '
         || ' FROM nm_members_all '
         || ' WHERE nm_obj_type = :p_inv_type ';

      IF pi_inv_id IS NOT NULL
      THEN
         cur_string := cur_string || ' and nm_ne_id_in = :inv_id';
      END IF;

      cur_string :=
            cur_string
         || ' UNION ALL '
         || ' SELECT nm_ne_id_in, '
         || ' NVL (nm_end_date, '
         || ' TO_DATE ('
         || ''''
         || '31123000'
         || ''''
         || ', '
         || ''''
         || 'DDMMYYYY'
         || ''''
         || ')) '
         || ' FROM nm_members_all  '
         || ' WHERE nm_obj_type = :p_inv_type ';

      IF pi_inv_id IS NOT NULL
      THEN
         cur_string := cur_string || ' and nm_ne_id_in = :inv_id ';
      END IF;

      cur_string :=
            cur_string
         || ' )) d '
         || ' WHERE start_date != end_date) '
         || ' SELECT nm_ne_id_in, '
         || ' :p_inv_type,  '
         || ' start_date, '
         || ' CASE end_date '
         || ' WHEN TO_DATE ('
         || ''''
         || '31123000'
         || ''''
         || ', '
         || ''''
         || 'DDMMYYYY'
         || ''''
         || ') THEN NULL '
         || '    ELSE end_date '
         || ' END '
         || ' end_date, '
         || geom_string
         || ' shape '
         || ' FROM ( '
         || get_table_string (pi_inv_type)
         || ') group by nm_ne_id_in, start_date, end_date';

      RETURN cur_string;
   END;



   --
   PROCEDURE set_index_deferred
   IS
      already_deferred   EXCEPTION;
      PRAGMA EXCEPTION_INIT (already_deferred, -29874);
   BEGIN
      EXECUTE IMMEDIATE
            'alter index nig_spidx parameters ('
         || ''''
         || 'index_status=deferred'
         || ''''
         || ')';
   EXCEPTION
      WHEN already_deferred
      THEN
         NULL;
      WHEN OTHERS
      THEN
         RAISE;
   END;

   PROCEDURE SYNCH_INDEX
   IS
   BEGIN
      EXECUTE IMMEDIATE
            'alter index nig_spidx parameters ('
         || ''''
         || 'index_status=synchronize'
         || ''''
         || ')';
   END;
END;
/
