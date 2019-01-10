CREATE OR REPLACE PACKAGE BODY nm_gty_sdo_aggr
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/nm_gty_sdo_aggr.pkb-arc   1.0   Jan 10 2019 14:15:40   Rob.Coupe  $
   --       Module Name      : $Workfile:   nm_gty_sdo_aggr.pkb  $
   --       Date into PVCS   : $Date:   Jan 10 2019 14:15:40  $
   --       Date fetched Out : $Modtime:   Jan 10 2019 13:34:50  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : R.A. Coupe
   --
   --   Package for code which produces aggregated geometry for groups.
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
   
   g_body_sccsid   CONSTANT VARCHAR2 (2000) := '$Revision:   1.0  $';

   qq                       VARCHAR2 (1) := CHR (39);
   TABLE_NOT_EXISTS         EXCEPTION;
   PRAGMA EXCEPTION_INIT (TABLE_NOT_EXISTS, -942);

   FUNCTION get_tolerance
      RETURN NUMBER;

   g_tolerance              NUMBER := get_tolerance;
   g_chr_tol                VARCHAR2 (10) := TO_CHAR (g_tolerance);


   PROCEDURE set_gty_index_deferred;

   PROCEDURE synch_gty_index;

   procedure reg_aggr_gty_type (pi_gty_type in varchar2);

   procedure set_refresh_date (pi_gty_type in varchar2);

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


   PROCEDURE create_gty_aggr_sdo_view (
      pi_gty_type    IN nm_group_types.ngt_group_type%TYPE,
      pi_view_name   IN VARCHAR2 DEFAULT NULL)
   IS
      l_view_name   VARCHAR2 (30)
         := NVL (pi_view_name, 'V_' || pi_gty_type || '_AGGR_SDO');
   BEGIN
      EXECUTE IMMEDIATE
            'create or replace view '
         || l_view_name
         || ' as select * from nm_gty_geometry where group_type = '
         || ''''
         || pi_gty_type
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
                   AND sdo_table_name = 'NM_GTY_GEOMETRY_ALL'
                   AND sdo_column_name = 'SHAPE';
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            NULL;
      END;
   END;

   PROCEDURE create_gty_aggr_join_view (
      pi_gty_type    IN nm_group_types.ngt_group_type%TYPE,
      pi_view_name   IN VARCHAR2 DEFAULT NULL)
   IS
      l_view_name   VARCHAR2 (30)
         := NVL (pi_view_name, 'V_NM_GTY_AGGR_' || pi_gty_type || '_SDO');
      l_gty_table   VARCHAR2 (30);
      l_pk_column   VARCHAR2 (30);
   BEGIN
      SELECT 'V_NM_' || ngt_nt_type || '_' || ngt_group_type || '_NT'
        INTO l_gty_table
        FROM nm_group_types
       WHERE ngt_group_type = pi_gty_type;

      --      l_gty_table := 'V_NM_' || pi_gty_type || '_NT';
      l_pk_column := 'NE_ID';

      IF NOT nm3ddl.does_object_exist (l_gty_table, 'VIEW')
      THEN
         raise_application_error (
            -20002,
               'The group view '
            || l_gty_table
            || ' does not exist, cannot create a join view');
      END IF;

      EXECUTE IMMEDIATE
            'create or replace view '
         || l_view_name
         || ' as select s.group_id aggr_group_id, i.*, s.shape aggr_shape from '
         || l_gty_table
         || ' i, nm_gty_geometry s '
         || ' where s.group_id = '
         || l_pk_column
         || ' and s.group_type = '
         || ''''
         || pi_gty_type
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
                   AND sdo_table_name = 'NM_GTY_GEOMETRY_ALL'
                   AND sdo_column_name = 'SHAPE';
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            NULL;
      END;
   EXCEPTION
      WHEN TABLE_NOT_EXISTS
      THEN
         RAISE_APPLICATION_ERROR (
            -20004,
            'Problem in the join view components, check the group type metadata and views');
   END;


   FUNCTION is_gty_type_aggregated (
      pi_gty_type   IN nm_group_types.ngt_group_type%TYPE)
      RETURN BOOLEAN
   IS
      retval   BOOLEAN;
      dummy    INTEGER := 0;
   --
   BEGIN
      BEGIN
         SELECT 1
           INTO dummy
           FROM nm_gty_aggr_sdo_types
          WHERE NGT_GROUP_TYPE = pi_gty_type;

         retval := TRUE;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            retval := FALSE;
      END;

      RETURN retval;
   END;

   PROCEDURE set_gty_index_deferred
   IS
      already_deferred   EXCEPTION;
      PRAGMA EXCEPTION_INIT (already_deferred, -29874);
   BEGIN
      EXECUTE IMMEDIATE
            'alter index ngg_spidx parameters ('
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

   PROCEDURE SYNCH_GTY_INDEX
   IS
   BEGIN
      EXECUTE IMMEDIATE
            'alter index ngg_spidx parameters ('
         || ''''
         || 'index_status=synchronize'
         || ''''
         || ')';
   END;


   PROCEDURE aggregate_current_gty (
      pi_gty_type   IN nm_group_types.ngt_group_type%TYPE,
      p_limit       IN INTEGER DEFAULT 100)
   IS
      p_cur              VARCHAR2 (4000);
      l_table_name       VARCHAR2 (30);
      l_start_date_col   VARCHAR2 (30);
      l_end_date_col     VARCHAR2 (30);
      l_shape_col        VARCHAR2 (30);
      l_ne_col           VARCHAR2 (30);

      geocur             SYS_REFCURSOR;

      CURSOR c1
      IS
         SELECT ne_id
           FROM nm_elements
          WHERE ne_gty_group_type = pi_gty_type;

      l_ne_id            int_array_type := int_array_type (0);
      error_count        NUMBER;
      dml_errors         EXCEPTION;
      PRAGMA EXCEPTION_INIT (dml_errors, -24381);
   BEGIN
      BEGIN
         SELECT nth_feature_table,
                nth_feature_fk_column,
                nth_start_date_column,
                nth_end_date_column,
                nth_feature_shape_column
           INTO l_table_name,
                l_ne_col,
                l_start_date_col,
                l_end_date_col,
                l_shape_col
           FROM nm_area_themes, nm_area_types, nm_themes_all
          WHERE     nat_id = nath_nat_id
                AND nth_theme_id = nath_nth_theme_id
                AND nth_base_table_theme IS NULL
                AND nat_gty_group_type = pi_gty_type;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20001,
               'The base spatial representation for the group type cannot be found');
      END;

      set_gty_index_deferred;

      IF is_gty_type_aggregated (pi_gty_type)
      THEN
         DELETE FROM nm_gty_geometry_all
               WHERE group_type = pi_gty_type;

         COMMIT;
      --
      ELSE
         REG_AGGR_GTY_TYPE (pi_gty_type);
      END IF;

      set_refresh_date (pi_gty_type);

      OPEN c1;

      FETCH c1 BULK COLLECT INTO l_ne_id LIMIT p_limit;

      WHILE l_ne_id.COUNT > 0
      LOOP
         BEGIN
            EXECUTE IMMEDIATE
                  'INSERT INTO nm_gty_geometry_all (GROUP_ID, '
               || '  group_type, '
               || '  start_date, '
               || '  end_date, '
               || '  shape) '
               || ' select ne_id, :pi_group_type, min('
               || l_start_date_col
               || '), NULL, sdo_aggr_union(sdoaggrtype('
               || l_shape_col
               || ', '
               || g_chr_tol
               || ')) '
               || ' from table(:l_ne_id), '
               || l_table_name
               || ' where '
               || l_ne_col
               || ' = column_value and '
               || l_end_date_col
               || ' is null  '
               || ' group by '
               || l_ne_col
               USING pi_gty_type, l_ne_id;

            COMMIT;
            l_ne_id := int_array_type (0);
         EXCEPTION
            WHEN dml_errors
            THEN
               error_count := SQL%BULK_EXCEPTIONS.COUNT;
               nm_debug.debug (
                  'Number of statements that failed: ' || error_count);
         END;

         FETCH c1 BULK COLLECT INTO l_ne_id LIMIT p_limit;
      END LOOP;

      CLOSE c1;

      SYNCH_GTY_INDEX;
   END;

   PROCEDURE register_aggr_theme (
      p_gty_type   IN nm_group_types.ngt_group_type%TYPE,
      p_role       IN nm_theme_roles.nthr_role%TYPE)
   IS
      l_exists   INTEGER;

      l_theme    nm_themes_all.nth_theme_id%TYPE;
   BEGIN
      BEGIN
         SELECT 1
           INTO l_exists
           FROM nm_gty_aggr_sdo_types
          WHERE ngt_group_type = p_gty_type;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20001,
               'Aggregated layer is not available for this group type');
      END;

      --
      BEGIN
         SELECT 1
           INTO l_exists
           FROM nm_themes_all
          WHERE nth_feature_table = 'NM_GTY_GEOMETRY_ALL';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NM3SDO.REGISTER_SDO_TABLE_AS_THEME ('NM_GTY_GEOMETRY_ALL',
                                                'AGGREGATED GEOMETRY TABLE',
                                                'ASSET_ID',
                                                NULL,
                                                'SHAPE',
                                                g_tolerance,
                                                'N',
                                                'N',
                                                'I');
      END;

      --
      l_theme := nth_theme_id_seq.NEXTVAL;

      BEGIN
         INSERT INTO NM_THEMES_ALL (NTH_THEME_ID,
                                    NTH_THEME_NAME,
                                    NTH_TABLE_NAME,
                                    NTH_WHERE,
                                    NTH_PK_COLUMN,
                                    NTH_LABEL_COLUMN,
                                    NTH_RSE_TABLE_NAME,
                                    NTH_RSE_FK_COLUMN,
                                    NTH_ST_CHAIN_COLUMN,
                                    NTH_END_CHAIN_COLUMN,
                                    NTH_X_COLUMN,
                                    NTH_Y_COLUMN,
                                    NTH_OFFSET_FIELD,
                                    NTH_FEATURE_TABLE,
                                    NTH_FEATURE_PK_COLUMN,
                                    NTH_FEATURE_FK_COLUMN,
                                    NTH_XSP_COLUMN,
                                    NTH_FEATURE_SHAPE_COLUMN,
                                    NTH_HPR_PRODUCT,
                                    NTH_LOCATION_UPDATABLE,
                                    NTH_THEME_TYPE,
                                    NTH_DEPENDENCY,
                                    NTH_STORAGE,
                                    NTH_UPDATE_ON_EDIT,
                                    NTH_USE_HISTORY,
                                    NTH_START_DATE_COLUMN,
                                    NTH_END_DATE_COLUMN,
                                    NTH_BASE_TABLE_THEME,
                                    NTH_SEQUENCE_NAME,
                                    NTH_SNAP_TO_THEME,
                                    NTH_LREF_MANDATORY,
                                    NTH_TOLERANCE,
                                    NTH_TOL_UNITS,
                                    NTH_DYNAMIC_THEME)
            SELECT l_theme,
                   'AGGREGATED ' || p_gty_type,
                   'V_NM_GTY_AGGR_' || p_gty_type || '_SDO',
                   NULL,
                   'AGGR_ASSET_ID',
                   'AGGR_ASSET_ID',
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   'V_NM_GTY_AGGR_' || p_gty_type || '_SDO',
                   'AGGR_ASSET_ID',
                   NULL,
                   NULL,
                   'AGGR_SHAPE',
                   'NET',
                   'N',
                   'SDO',
                   'D',
                   'S',
                   'N',
                   'N',
                   NULL,
                   NULL,
                   nth_theme_id,
                   NULL,
                   'N',
                   'N',
                   10,
                   1,
                   'N'
              FROM nm_themes_all
             WHERE nth_feature_table = 'NM_GTY_GEOMETRY_ALL';
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            raise_application_error (
               -20002,
               'Aggregated asset geometry view is already registered as a theme');
      END;

      IF NVL (hig.get_sysopt ('REGSDELAY'), 'N') = 'Y'
      THEN
         EXECUTE IMMEDIATE 'begin NM3SDE.register_sde_layer (:l_theme); end'
            USING l_theme;
      END IF;

      INSERT INTO nm_theme_roles
           VALUES (l_theme, p_role, 'NORMAL');

      INSERT INTO nm_area_themes (nath_nat_id, nath_nth_theme_id)
         SELECT nat_id, l_theme
           FROM nm_area_types
          WHERE nat_gty_group_type = p_gty_type;
   END;

   FUNCTION get_tolerance
      RETURN NUMBER
   IS
      l_diminfo   sdo_dim_array;
      l_srid      INTEGER;
      l_themes    nm_theme_array := nm3sdo.get_nw_themes;
      retval      NUMBER;
   BEGIN
      nm3sdo.set_diminfo_and_srid (p_themes    => l_themes,
                                   p_diminfo   => l_diminfo,
                                   p_srid      => l_srid);
      retval := l_diminfo (1).sdo_tolerance;
      RETURN retval;
   END;

   PROCEDURE REG_AGGR_GTY_TYPE (pi_gty_type IN VARCHAR2)
   IS
   BEGIN
      IF NOT is_gty_type_aggregated (pi_gty_type)
      THEN
         INSERT INTO nm_gty_aggr_sdo_types (ngt_group_type)
              VALUES (pi_gty_type);
      END IF;
   END;

   PROCEDURE SET_REFRESH_DATE (pi_gty_type IN VARCHAR2)
   IS
   BEGIN
      UPDATE nm_gty_aggr_sdo_refresh
         SET ngas_last_refresh_date = SYSDATE
       WHERE ngas_gty_group_type = pi_gty_type;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         INSERT
           INTO nm_gty_aggr_sdo_refresh (ngas_gty_group_type,
                                         ngas_last_refresh_date)
         VALUES (pi_gty_type, SYSDATE);
   END;



   PROCEDURE refresh_gty_aggr (pi_gty_type   IN VARCHAR2,
                               pi_limit      IN INTEGER DEFAULT 100)
   IS
      p_cur              VARCHAR2 (4000);
      l_table_name       VARCHAR2 (30);
      l_start_date_col   VARCHAR2 (30);
      l_end_date_col     VARCHAR2 (30);
      l_shape_col        VARCHAR2 (30);
      l_ne_col           VARCHAR2 (30);

      geocur             SYS_REFCURSOR;

      l_ne_tab           NM3TYPE.TAB_NUMBER;
      l_start_date_tab   NM3TYPE.TAB_DATE;


      CURSOR c1 (
         c_gty_type   IN VARCHAR2)
      IS
           SELECT nm_ne_id_in
             FROM nm_members_all, nm_elements_all, nm_gty_aggr_sdo_refresh
            WHERE     nm_type = 'G'
                  AND nm_obj_type = c_gty_type
                  AND nm_ne_id_of = ne_id
                  AND ngas_gty_group_type = c_gty_type
                  AND nm_end_date IS NULL
                  AND ne_end_date IS NULL
                  AND (   nm_date_modified > ngas_last_refresh_date
                       OR ne_date_modified > ngas_last_refresh_date)
         GROUP BY nm_ne_id_in;

      l_ne_id            int_array_type := int_array_type (0);
      error_count        NUMBER;
      dml_errors         EXCEPTION;
      PRAGMA EXCEPTION_INIT (dml_errors, -24381);
   BEGIN
      BEGIN
         SELECT nth_feature_table,
                nth_feature_fk_column,
                nth_start_date_column,
                nth_end_date_column,
                nth_feature_shape_column
           INTO l_table_name,
                l_ne_col,
                l_start_date_col,
                l_end_date_col,
                l_shape_col
           FROM nm_area_themes, nm_area_types, nm_themes_all
          WHERE     nat_id = nath_nat_id
                AND nth_theme_id = nath_nth_theme_id
                AND nth_base_table_theme IS NULL
                AND nat_gty_group_type = pi_gty_type;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20001,
               'The base spatial representation for the group type cannot be found');
      END;

      set_gty_index_deferred;

      IF NOT nm_gty_sdo_aggr.is_gty_type_aggregated (pi_gty_type)
      THEN
         raise_application_error (
            -20001,
            'Aggregated group layer does not exist so cannot be refreshed');
      END IF;


      OPEN c1 (pi_gty_type);

      FETCH c1 BULK COLLECT INTO l_ne_id LIMIT pi_limit;

      WHILE l_ne_id.COUNT > 0
      LOOP
         FORALL indx IN l_ne_tab.FIRST .. l_ne_tab.LAST
            DELETE FROM nm_gty_geometry_all
                  WHERE GROUP_ID = l_ne_tab (indx);

         BEGIN
            EXECUTE IMMEDIATE
                  'INSERT INTO nm_gty_geometry_all (GROUP_ID, '
               || '  group_type, '
               || '  start_date, '
               || '  end_date, '
               || '  shape) '
               || ' select ne_id, :pi_group_type, min('
               || l_start_date_col
               || '), NULL, sdo_aggr_union(sdoaggrtype('
               || l_shape_col
               || ', '
               || g_chr_tol
               || ')) '
               || ' from table(:l_ne_tab), '
               || l_table_name
               || ' where '
               || l_ne_col
               || ' = column_value and '
               || l_end_date_col
               || ' is null  '
               || ' group by '
               || l_ne_col
               USING pi_gty_type, l_ne_id;

            COMMIT;
            l_ne_id := int_array_type (0);
         EXCEPTION
            WHEN dml_errors
            THEN
               error_count := SQL%BULK_EXCEPTIONS.COUNT;
               nm_debug.debug (
                  'Number of statements that failed: ' || error_count);
         END;

         FETCH c1 BULK COLLECT INTO l_ne_id LIMIT pi_limit;
      END LOOP;

      CLOSE c1;

      SYNCH_GTY_INDEX;
   END;
END;
/