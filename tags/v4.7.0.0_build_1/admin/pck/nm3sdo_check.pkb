CREATE OR REPLACE PACKAGE BODY nm3sdo_check
AS
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3sdo_check.pkb-arc   2.15   Jul 04 2013 16:29:30   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3sdo_check.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:29:30  $
--       Date fetched Out : $Modtime:   Jul 04 2013 16:26:16  $
--       PVCS Version     : $Revision:   2.15  $
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
  g_package_name          CONSTANT varchar2(30)    := 'nm3sdo_check';
  g_body_sccsid           CONSTANT varchar2(2000)  := '"$Revision:   2.15  $"';
  lf                      CONSTANT VARCHAR2(30)    := chr(10);
  g_write_to_file                  BOOLEAN         := FALSE;
  l_results                        nm3type.tab_varchar32767;
  g_location                       VARCHAR2(1000);
  g_filename                       VARCHAR2(1000);
  g_pub_syn               CONSTANT BOOLEAN         := hig.get_sysopt('HIGPUBSYN') = 'Y';
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
--------------------------------------------------------------------------------
--
  FUNCTION get_oracle_summary
  RETURN VARCHAR2
  IS
    retval nm3type.max_varchar2;
  BEGIN
     SELECT instance_name||' Oracle Version '||version||' ['||UPPER(host_name)||']'
       INTO retval
       FROM v$instance;
     RETURN retval;
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN 
      RETURN 'Cannot find Oracle version';
  END get_oracle_summary;
--
--------------------------------------------------------------------------------
--
  PROCEDURE put (pi_text IN VARCHAR2)
  IS
    local_results nm3type.tab_varchar32767;
  BEGIN
    IF NOT g_write_to_file
    THEN
      dbms_output.put_line(pi_text);
    ELSE
      local_results.DELETE;
      local_results(1):= pi_text;
      nm3file.append_file(g_location
                        , g_filename
                        , NULL
                        , local_results);
    END IF;
  END put;
--
--------------------------------------------------------------------------------
--
  PROCEDURE run_sdo_check
                 ( pi_location    IN VARCHAR2 DEFAULT NULL
                 , pi_filename    IN VARCHAR2 DEFAULT NULL
                 , pi_skip_gtypes IN BOOLEAN  DEFAULT FALSE)
  IS
    b_serverout    BOOLEAN := pi_location IS NULL OR pi_filename IS NULL;
  BEGIN
  --
  ------------------------------------------------------------------------------
  --  Report missing USGM data for HIGHWAYS layers
  ------------------------------------------------------------------------------
  --
    l_results.DELETE;
  --
    IF b_serverout
    THEN
    --
      dbms_output.enable;
      g_write_to_file := FALSE;
    ELSE
    --
      g_location := pi_location;
      g_filename := pi_filename;
      g_write_to_file := TRUE;
      nm3file.write_file(g_location, g_filename, NULL, l_results);
    END IF;
  --
    put(lf);
    put('********************************************************************');
    put('*');
    put('*  SPATIAL METADATA CHECKER ');
    put('*');
    put('*     Executed on : '||to_Char(sysdate,'DD-MON-YYYY HH24:MI:SS'));
    put('*');
    put('*     Running on  : '||Sys_Context('NM3_SECURITY_CTX','USERNAME')||'@'||get_oracle_summary);
    put('*');
    put('********************************************************************');
    put(lf);      
  --
    SELECT '    FAIL : '||nth_theme_name||' ['||nth_feature_table||'.'
         ||nth_feature_shape_column||']'||' is missing from '||
         'USER_SDO_GEOM_METADATA for the Highways Owner schema ['||Sys_Context('NM3CORE','APPLICATION_OWNER')||']' 
      BULK COLLECT INTO l_results
      FROM nm_themes_all
     WHERE nth_theme_type = 'SDO'
       AND NOT EXISTS (
              SELECT 1
                FROM user_sdo_geom_metadata
               WHERE table_name = nth_feature_table
                 AND column_name = nth_feature_shape_column);
  --
    put('  ====================================================================');
    put('  =  Missing USER_SDO_GEOM_METADATA for Highways Owner themes ');
    put('  ====================================================================');
    put(lf);
  --
    IF l_results.COUNT = 0
    THEN
      put('    PASS : All Highways Owner themes are registered in USER_SDO_GEOM_METADATA');
    ELSE 
      FOR i IN 1..l_results.COUNT LOOP
        put(l_results(i));
      END LOOP;
    END IF;
  --
  -----------------------------------------------------------------------------
  --  Reports missing spatial indexes
  -----------------------------------------------------------------------------
  --
    SELECT '    FAIL : '||nth_feature_table||' is missing a spatial index on ['
         ||nth_feature_shape_column||']'
      BULK COLLECT INTO l_results
      FROM nm_themes_all
     WHERE nth_base_table_theme IS NULL
       AND EXISTS (SELECT 1
                     FROM user_tables
                    WHERE table_name = nth_feature_table)
       AND NOT EXISTS (
              SELECT 1
                FROM user_sdo_index_metadata, user_indexes
               WHERE index_name = sdo_index_name
                 AND table_name = nth_feature_table
                 AND sdo_column_name LIKE '%' || nth_feature_shape_column || '%');
  --
    put(lf);
    put('  ====================================================================');
    put('  =  Missing Spatial Indexes'); 
    put('  ====================================================================');
    put(lf);
  --
    IF l_results.COUNT = 0
    THEN
      put('    PASS : All Theme feature tables have spatial indexes');
    ELSE 
      FOR i IN 1..l_results.COUNT LOOP
        put(l_results(i));
      END LOOP;
    END IF;
  --
  -----------------------------------------------------------------------------
  --  Reports missing USGM data for subordinate users
  -----------------------------------------------------------------------------
  --
    SELECT '    FAIL : '||hus_username||' is missing USER_SDO_GEOM_METADATA for ['
         ||nth_feature_table||'.'||nth_feature_shape_column||'] theme'
      BULK COLLECT INTO l_results
      FROM MDSYS.sdo_geom_metadata_table u,
           (SELECT   hus_username, nth_feature_table, nth_feature_shape_column
                FROM (SELECT hus_username, a.nth_feature_table, a.nth_feature_shape_column
                        FROM nm_themes_all a,
                             nm_theme_roles,
                             hig_user_roles,
                             hig_users,
                             all_users
                       WHERE nthr_theme_id = a.nth_theme_id
                         AND nthr_role = hur_role
                         AND hur_username = hus_username
                         AND hus_username = username
                         AND hus_username != Sys_Context('NM3CORE','APPLICATION_OWNER')
                         AND hus_end_date IS NULL
                         AND NOT EXISTS
                         -- Ignore the TMA Webservice schemas
                           (SELECT 1 FROM all_objects o
                             WHERE o.object_name = 'GET_RECIPIENTS'
                               AND o.object_type = 'PROCEDURE'
                               AND o.owner = hus_username)
                         -- Make sure the role is actually granted 
                         AND EXISTS
                           (SELECT * FROM dba_role_privs
                             WHERE grantee = hus_username
                               AND granted_role = nthr_role)
                         AND NOT EXISTS (
                                SELECT 1
                                  FROM MDSYS.sdo_geom_metadata_table g1
                                 WHERE g1.sdo_owner = hus_username
                                   AND g1.sdo_table_name = nth_feature_table
                                   AND g1.sdo_column_name = nth_feature_shape_column)
                      UNION ALL
                      SELECT hus_username, b.nth_feature_table, b.nth_feature_shape_column
                        FROM nm_themes_all a,
                             hig_users,
                             all_users,
                             nm_themes_all b
                       WHERE b.nth_theme_id = a.nth_base_table_theme
                         AND hus_username = username
                         AND hus_end_date IS NULL
                         AND hus_username != Sys_Context('NM3CORE','APPLICATION_OWNER')
                         AND NOT EXISTS
                         -- Ignore the TMA Webservice schemas
                           (SELECT 1 FROM all_objects o
                             WHERE o.object_name = 'GET_RECIPIENTS'
                               AND o.object_type = 'PROCEDURE'
                               AND o.owner = hus_username)
                         AND NOT EXISTS (
                                SELECT 1
                                  FROM MDSYS.sdo_geom_metadata_table g1
                                 WHERE g1.sdo_owner = hus_username
                                   AND g1.sdo_table_name = b.nth_feature_table
                                   AND g1.sdo_column_name = b.nth_feature_shape_column)
                         -- Make sure we only report base table themes that we actually
                         -- have the roles to access their child View based themes
                         AND a.nth_theme_id IN (
                                SELECT z.nth_theme_id
                                  FROM nm_themes_all z, nm_theme_roles
                                 WHERE EXISTS (SELECT 1
                                                 FROM hig_user_roles
                                                WHERE hur_username = hus_username 
                                                  AND hur_role = nthr_role)
                                   AND nthr_theme_id = z.nth_theme_id))
            GROUP BY hus_username, nth_feature_table, nth_feature_shape_column)
     WHERE u.sdo_table_name = nth_feature_table
       AND u.sdo_column_name = nth_feature_shape_column
       AND u.sdo_owner = Sys_Context('NM3CORE','APPLICATION_OWNER');
  --
    put(lf);
    put('  ====================================================================');
    put('  =  Missing USER_SDO_GEOM_METADATA for Subordinate users'); 
    put('  =  based on Themes accessed via roles');
    put('  ====================================================================');
    put(lf);
  --
    IF l_results.COUNT = 0
    THEN
      put('    PASS : All Subordinate User themes are registered in USER_SDO_GEOM_METADATA');
    ELSE 
      FOR i IN 1..l_results.COUNT LOOP
         put(l_results(i));
      END LOOP;
    END IF;
  --
  ------------------------------------------------------------------------------
  -- Report missing synonyms for subordinate users objects
  ------------------------------------------------------------------------------
  --
    IF g_pub_syn
      THEN
    --
    -- Make sure there is a public synonym in existance for each theme feature object
    --
      SELECT '    FAIL : '|| nth_feature_table
             ||' public synonym is missing which needs to be based on '
             || Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'|| nth_feature_table missing_views
        BULK COLLECT INTO l_results
        FROM nm_themes_all
       WHERE nth_theme_type = 'SDO'
         AND NOT EXISTS (
                SELECT 1
                  FROM dba_objects
                 WHERE owner = 'PUBLIC'
                   AND object_name = nth_feature_table
                   AND object_type = 'SYNONYM')
       ORDER BY nth_feature_table;
    --
      ELSE
    --
    -- Make sure there is a private synonym in existance for each theme feature object
    --
        SELECT '    FAIL : '||hus_username||'.'|| nth_feature_table
               ||' private synonym is missing which needs to be based on '
               || Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'|| nth_feature_table missing_views
          BULK COLLECT INTO l_results
          FROM hig_users
             , all_users
             , nm_themes_all
             , hig_user_roles
             , nm_theme_roles
         WHERE hus_username = username
           AND hus_username != Sys_Context('NM3CORE','APPLICATION_OWNER')
           AND nth_theme_type = 'SDO'
           AND nthr_theme_id = nth_theme_id
           AND nthr_role = hur_role
           AND hur_username = hus_username
           AND hus_end_date IS NULL
           AND EXISTS
             (SELECT * FROM dba_role_privs
               WHERE grantee = hus_username
                 AND granted_role = nthr_role)
           AND NOT EXISTS
               -- Ignore the TMA Webservice schemas
                 (SELECT 1 FROM all_objects o
                   WHERE o.object_name = 'GET_RECIPIENTS'
                     AND o.object_type = 'PROCEDURE'
                     AND o.owner = hus_username)
           AND NOT EXISTS (
                  SELECT 1
                    FROM dba_objects
                   WHERE owner != Sys_Context('NM3CORE','APPLICATION_OWNER')
                     AND owner != 'PUBLIC'
                     AND object_name = nth_feature_table
                     AND object_type = 'SYNONYM')
         ORDER BY hus_username, nth_feature_table;
    --
    END IF;
  --
  --
    put(lf);
    put('  ====================================================================');
    put('  =  Missing '|| CASE WHEN g_pub_syn
                          THEN 'public synonyms.' 
                          ELSE 'private synonyms for subordinate users ' 
                          END);
  --
    IF NOT g_pub_syn 
    THEN put( '  =  based on Themes accessed via roles' ); 
    END IF;
  --
    put('  ====================================================================');
    put(lf);
  --
    IF l_results.COUNT = 0
    THEN
      put('    PASS : All Subordinate users have access to theme feature objects via the appropriate synonyms');
    ELSE 
      FOR i IN 1..l_results.COUNT LOOP
         put(l_results(i));
      END LOOP;
    END IF;
  --
  ------------------------------------------------------------------------------
  -- Report missing feature views for subordinate users for MCI objects
  ------------------------------------------------------------------------------
  --
    IF hig.is_product_licensed ('MCP')
    THEN
    --
      SELECT '    FAIL : '||hus_username||'.'|| nth_feature_table
             ||' MCI view is missing which needs to be based on '
             || Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'|| nth_feature_table missing_views
        BULK COLLECT INTO l_results
        FROM hig_users
           , all_users
           , nm_themes_all
           , hig_user_roles
           , nm_theme_roles
       WHERE hus_username = username
         AND hus_username != Sys_Context('NM3CORE','APPLICATION_OWNER')
         AND nth_theme_type = 'SDO'
         AND ( nth_feature_table LIKE 'V_MCP_EXTRACT%'
            OR nth_feature_table LIKE 'V_MCP_UPLOAD%' )
         AND nthr_theme_id = nth_theme_id
         AND nthr_role = hur_role
         AND hur_username = hus_username
         AND hus_end_date IS NULL
         AND EXISTS
           (SELECT * FROM dba_role_privs
             WHERE grantee = hus_username
               AND granted_role = nthr_role)
         AND NOT EXISTS
             -- Ignore the TMA Webservice schemas
               (SELECT 1 FROM all_objects o
                 WHERE o.object_name = 'GET_RECIPIENTS'
                   AND o.object_type = 'PROCEDURE'
                   AND o.owner = hus_username)
         AND NOT EXISTS (
                SELECT 1
                  FROM dba_objects
                 WHERE owner != Sys_Context('NM3CORE','APPLICATION_OWNER')
                   AND owner = hus_username
                   AND object_name = nth_feature_table
                   AND object_type = 'VIEW')
       ORDER BY hus_username, nth_feature_table;
    --
  --
       put(lf);
       put('  ====================================================================');
       put('  =  Missing MCI feature views for Subordinate users ');
       put('  =  based on Themes accessed via roles');
       put('  ====================================================================');
       put(lf);
     --
       IF l_results.COUNT = 0
       THEN
         put('    PASS : All Subordinate users have MCI feature views for Themes accessed via roles');
       ELSE 
         FOR i IN 1..l_results.COUNT LOOP
            put(l_results(i));
         END LOOP;
       END IF;
       
    END IF;
  --

    
  --
--
  IF NOT pi_skip_gtypes
  THEN
    ------------------------------------------------------------------------------
    -- Report unrecognised Geometry Types
    ------------------------------------------------------------------------------
    --
      DECLARE
      --
        l_tab_results nm3type.tab_varchar30;
      --
      BEGIN
        FOR i IN
          (SELECT nth_feature_table, nth_feature_shape_column
             FROM nm_themes_all, user_sdo_geom_metadata
            WHERE nth_feature_table = table_name
              AND nth_feature_shape_column = column_name
              AND nth_base_table_theme IS NULL
              AND nth_theme_type  = 'SDO'
            ORDER BY nth_theme_id
          )
        LOOP
        --
          BEGIN
            EXECUTE IMMEDIATE 'SELECT UNIQUE a.'||i.nth_feature_shape_column||'.sdo_gtype'
                             ||' FROM '||i.nth_feature_table||' a'
                            ||' WHERE NOT EXISTS '
                               ||' (SELECT 1 FROM hig_codes '
                                 ||' WHERE hco_domain = ''GEOMETRY_TYPE'''
                                   ||' AND hco_code = a.'||i.nth_feature_shape_column||'.sdo_gtype)'
            BULK COLLECT INTO l_tab_results;
          --
            IF l_tab_results.COUNT > 0
            THEN
              FOR j IN 1..l_tab_results.COUNT
              LOOP
                l_results(l_results.COUNT+1) 
                  := '    FAIL : '||i.nth_feature_table
                            ||' ['||i.nth_feature_shape_column
                            ||'] - '|| l_tab_results(j)
                            ||' is not recognised';
              END LOOP; 
            ELSE
              -- CWS 0109886 When no errors the previous searches error were shown.
              l_results.DELETE;
            END IF;
          EXCEPTION
            WHEN OTHERS
            THEN
              l_results(l_results.COUNT+1) 
                  := '    FAIL : '||i.nth_feature_table
                            ||' ['||i.nth_feature_shape_column
                            ||'] - appears to be incorrectly defined on the theme - please check';
          END;
      --
        END LOOP;
      --
      END;
    --
    --
      put(lf);
      put('  ====================================================================');
      put('  =  Unrecognised Geometry Types (Gtypes)');
      put('  ====================================================================');
      put(lf);
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : No unrecognised gtypes found');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
           put(l_results(i));
        END LOOP;
      END IF;
--
    END IF;
--
    put(lf);
    put(lf);
    put('********************************************************************');
    put('*');
    put('*  SPATIAL METADATA CHECKER COMPLETE');
    put('*');
    put('*     Finished at : '||to_Char(sysdate,'DD-MON-YYYY HH24:MI:SS'));
    put('*');
    put('********************************************************************');
    put(lf);
--
--  EXCEPTION
--    WHEN OTHERS THEN RAISE;
  END run_sdo_check; 
--
--------------------------------------------------------------------------------
--
  PROCEDURE run_theme_check
                 ( pi_location         IN VARCHAR2 DEFAULT NULL
                 , pi_filename         IN VARCHAR2 DEFAULT NULL
                 , pi_supress_warnings IN BOOLEAN  DEFAULT FALSE )
  IS
    l_results      nm3type.tab_varchar32767;
    b_serverout    BOOLEAN := pi_location IS NULL OR pi_filename IS NULL;
  --
  --------------------------------------------------------------------------------
  -- All checking code goes here
  --------------------------------------------------------------------------------
  --
    PROCEDURE non_sdo_layers
    IS
    BEGIN
    --
      put('  ====================================================================');
      put('  =  Themes that are not based on SDO layers');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme : '||nth_theme_name ||' ['||nth_theme_id||'] is not an SDO theme ['||nth_theme_type||']'
        BULK COLLECT INTO l_results
        FROM nm_themes_all 
       WHERE nth_theme_type != 'SDO';
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes are based on SDO layers');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END non_sdo_layers;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE null_theme_table
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that have a NULL Theme table');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme : '||nth_theme_name ||' ['||nth_theme_id||'] has a NULL nth_table_name value'
        BULK COLLECT INTO l_results
        FROM nm_themes_all
       WHERE nth_table_name IS NULL 
         AND nth_theme_type = 'SDO';
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes have Theme table set');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END null_theme_table;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE null_feature_table
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that have a NULL Feature table');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme : '||nth_theme_name ||' ['||nth_theme_id||'] has a NULL nth_feature_table value'
        BULK COLLECT INTO l_results
        FROM nm_themes_all
       WHERE nth_feature_table IS NULL 
         AND nth_theme_type = 'SDO';
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes have Feature table set');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END null_feature_table;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE unsuitable_pk_fk_cols_combi
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that have an unsuitable PK/FK combination');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme : '||nth_theme_name ||' ['||nth_theme_id||'] has an unsuitable PK/FK combination'
          || ' - [PK='||nth_feature_pk_column||'|FK='||nth_feature_fk_column||']'
        BULK COLLECT INTO l_results
        FROM nm_themes_all
       WHERE nth_feature_table IS NOT NULL
         AND nth_table_name IS NOT NULL
         AND nth_theme_type = 'SDO'
         AND nth_table_name = nth_feature_table
         AND nth_feature_fk_column IS NOT NULL
         AND nth_feature_pk_column != nth_feature_fk_column;
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes have suitable PK/FK combinations');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END unsuitable_pk_fk_cols_combi;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE non_existant_label_column
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that reference a non-existent Label Column');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme : '||nth_theme_name ||' ['||nth_theme_id||'] references a non-existent Label Column'
          || ' [nth_label_column = '||nth_label_column||']'
        BULK COLLECT INTO l_results
        FROM nm_themes_all
       WHERE NOT EXISTS 
         ( SELECT 1 FROM user_tab_columns
            WHERE table_name = nth_table_name
              AND column_name = nth_label_column )
         AND nth_theme_type = 'SDO';
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes reference suitable Label Columns');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END non_existant_label_column;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE missing_pk_column
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that reference a non-existent PK column');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme : '||nth_theme_name ||' ['||nth_theme_id||'] references a non-existent PK column'
          || ' [nth_pk_column = '||nth_pk_column||']'
        BULK COLLECT INTO l_results
        FROM nm_themes_all
       WHERE NOT EXISTS 
         ( SELECT 1 FROM user_tab_columns
            WHERE table_name = nth_table_name
              AND column_name = nth_pk_column )
         AND nth_theme_type = 'SDO';
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes reference suitable PK columns');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END missing_pk_column;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE missing_x_column
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that reference a non-existent X coordinate column');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme : '||nth_theme_name ||' ['||nth_theme_id||'] references a non-existent X coordinate column'
          || ' [nth_x_column = '||nth_x_column||']'
        BULK COLLECT INTO l_results
        FROM nm_themes_all
       WHERE NOT EXISTS (
          SELECT 1
            FROM user_tab_columns
           WHERE ( table_name = nth_table_name OR table_name = 'NM_INV_ITEMS_ALL' )
             AND column_name = NVL (nth_x_column, column_name))
         AND nth_x_column IS NOT NULL
         AND nth_theme_type = 'SDO'
         AND nth_base_table_theme IS NULL;
    --
      IF l_results.COUNT = 0
      THEN
        put('   PASS : All Themes reference suitable X coordinate columns');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE missing_y_column
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that reference a non-existent Y coordinate column');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme : '||nth_theme_name ||' ['||nth_theme_id||'] references a non-existent Y coordinate column'
          || ' [nth_y_column = '||nth_y_column||']'
        BULK COLLECT INTO l_results
        FROM nm_themes_all
       WHERE NOT EXISTS (
          SELECT 1
            FROM user_tab_columns
           WHERE ( table_name = nth_table_name OR table_name = 'NM_INV_ITEMS_ALL' )
             AND column_name = NVL (nth_y_column, column_name))
         AND nth_y_column IS NOT NULL
         AND nth_theme_type = 'SDO'
         AND nth_base_table_theme IS NULL;
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes reference suitable Y coordinate columns');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END missing_y_column;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE missing_feature_pk_column
    IS
    BEGIN
    --
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that reference a non-existent feature PK column');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme : '||nth_theme_name ||' ['||nth_theme_id||'] references a non-existent feature PK column'
          || ' [nth_feature_pk_column = '||nth_feature_pk_column||']'
        BULK COLLECT INTO l_results
        FROM nm_themes_all
       WHERE NOT EXISTS (
          SELECT 1
            FROM user_tab_columns
           WHERE table_name = nth_feature_table
             AND column_name = NVL (nth_feature_pk_column, column_name))
         AND nth_feature_pk_column IS NOT NULL
         AND nth_theme_type = 'SDO';
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes reference suitable feature PK columns');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END missing_feature_pk_column;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE missing_feature_fk_column
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that reference a non-existent feature FK column');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme : '||nth_theme_name ||' ['||nth_theme_id||'] references a non-existent feature FK column'
          || ' [nth_feature_fk_column = '||nth_feature_fk_column||']'
        BULK COLLECT INTO l_results
        FROM nm_themes_all
       WHERE NOT EXISTS (
          SELECT 1
            FROM user_tab_columns
           WHERE table_name = nth_feature_table
             AND column_name = NVL (nth_feature_fk_column, column_name))
         AND nth_feature_fk_column IS NOT NULL
         AND nth_theme_type = 'SDO';
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes reference suitable feature FK columns');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END missing_feature_fk_column;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE missing_feature_shape_column
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that reference a non-existent feature shape column');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme : '||nth_theme_name ||' ['||nth_theme_id||'] references a non-existent feature shape column'
          || ' [nth_feature_shape_column = '||nth_feature_shape_column||']'
        BULK COLLECT INTO l_results
        FROM nm_themes_all
       WHERE NOT EXISTS (
          SELECT 1
            FROM user_tab_columns
           WHERE table_name = nth_feature_table
             AND column_name = NVL (nth_feature_shape_column, column_name))
         AND nth_feature_shape_column IS NOT NULL
         AND nth_theme_type = 'SDO';
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes reference suitable feature shape columns');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END missing_feature_shape_column;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE invalid_base_themes
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that reference a non-existent base theme');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme : '||nth_theme_name ||' ['||nth_theme_id||'] references a non-existent base theme'
          || ' [nth_base_table_theme = '||nth_base_table_theme||']'
        BULK COLLECT INTO l_results
        FROM nm_themes_all a
       WHERE NOT EXISTS 
               (SELECT 1
                  FROM nm_themes_all b
                 WHERE b.nth_theme_id = a.nth_base_table_theme)
         AND nth_base_table_theme IS NOT NULL;
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes reference suitable base table themes');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END invalid_base_themes;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE invalid_snapping_themes
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that reference a non-existent snapping themes');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme : ['||nts_theme_id ||'] references a non-existent snapping theme'
          || ' ['||nts_snap_to||']'
        BULK COLLECT INTO l_results
        FROM nm_theme_snaps a
       WHERE NOT EXISTS (SELECT 1
                           FROM nm_themes_all
                          WHERE nth_theme_id = nts_snap_to);
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes reference suitable snapping themes');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END invalid_snapping_themes;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE incorrect_snapping_references
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that incorrectly snap to network themes');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme : '||a.nth_theme_name||' ['||a.nth_theme_id 
           ||'] is not allowed to reference '
           ||b.nth_theme_name||' ['||nts_snap_to||'] '
           ||'as a snapping theme [Asset Type '||nith_nit_id||' cannot reference '||nlt_nt_type||' network'
        BULK COLLECT INTO l_results
        FROM nm_theme_snaps nts,
             nm_themes_all a,
             nm_themes_all b,
             nm_nw_themes,
             nm_inv_themes,
             nm_linear_types
       WHERE nts.nts_snap_to  = nnth_nth_theme_id
         AND nts.nts_theme_id = a.nth_theme_id
         AND b.nth_theme_id   = nts.nts_snap_to
         AND nnth_nlt_id      = nlt_id
         AND nts.nts_theme_id = nith_nth_theme_id
         AND NOT EXISTS (
                  SELECT 1
                    FROM nm_inv_nw
                   WHERE nin_nit_inv_code = nith_nit_id
                     AND nin_nw_type = nlt_nt_type);
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes snap to suitable network themes');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END incorrect_snapping_references;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE no_ne_id_of_column
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that are immediate update on edit but does not have NE_ID_OF column');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme : '||nth_theme_name||' ['||nth_theme_id||'] has update on edit set to immediate but does not have NE_ID_OF column'
        BULK COLLECT INTO l_results 
        FROM nm_themes_all
       WHERE nth_update_on_edit = 'I'
         AND NOT EXISTS ( SELECT 1 FROM user_tab_columns
                           WHERE column_name = 'NE_ID_OF'
                             AND table_name = nth_feature_table );
    --
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes that are immediate update on edit have NE_ID_OF column');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END no_ne_id_of_column;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE linear_route_uoe
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that are immediate update on edit but are Linear Routes');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme : '||nth_theme_name||' ['||nth_theme_id||'] has update on edit set to immediate but is a Linear Route layer'
        BULK COLLECT INTO l_results 
        FROM nm_themes_all
       WHERE nth_update_on_edit = 'I'
         AND EXISTS ( SELECT 1 FROM v_nm_net_themes_all
                       WHERE nth_theme_id = vnnt_nth_theme_id 
                         AND vnnt_lr_type = 'G');
    --
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : No Themes that are immediate update on edit are Linear Route layers');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END linear_route_uoe;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE no_base_theme_set
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that are immediate update on edit but have no base(s) theme set');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme : '||nth_theme_name||' ['||nth_theme_id||'] has update on edit set to immediate but has no base theme(s)'
        BULK COLLECT INTO l_results 
        FROM nm_themes_all
       WHERE nth_update_on_edit = 'I'
         AND NOT EXISTS (SELECT 1
                           FROM nm_base_themes
                          WHERE nth_theme_id = nbth_theme_id);
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes that are immediate update on edit have base themes');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END no_base_theme_set;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE no_net_theme_set
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that are immediate update on edit but do not reference Network themes');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme : '||nth_theme_name|| ' ['||nth_theme_id|| '] has update on edit set to immediate but does not reference a Network theme'
        BULK COLLECT INTO l_results
        FROM nm_themes_all
       WHERE nth_update_on_edit = 'I'
         AND NOT EXISTS (
                SELECT 1
                  FROM nm_base_themes, nm_nw_themes
                 WHERE nth_theme_id = nbth_theme_id
                   AND nnth_nth_theme_id = nbth_base_theme);
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes that are immediate update on edit correctly reference Network themes');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END no_net_theme_set;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE uoe_referencing_view_themes
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that are immediate update on edit but are View based themes');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme : '||nth_theme_name|| ' ['||nth_theme_id
      || '] has update on edit set to immediate but is a View based theme - '||nth_feature_table
        BULK COLLECT INTO l_results
        FROM nm_themes_all
       WHERE nth_update_on_edit = 'I'
         AND nth_base_table_theme IS NOT NULL;
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes that are immediate update on edit are not set on View based themes');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END uoe_referencing_view_themes;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE invalid_sequence_name
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that have an invalid sequence name defined');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme : '||nth_theme_name|| ' ['||nth_theme_id
      || '] has '||nth_sequence_name||' defined but the sequence does not exist'
        BULK COLLECT INTO l_results
        FROM nm_themes_all
       WHERE nth_base_table_theme IS NULL
         AND NOT EXISTS 
         ( SELECT 1 FROM user_sequences
            WHERE sequence_name = nth_sequence_name )
         AND nth_sequence_name IS NOT NULL
         AND EXISTS
         ( SELECT 1 FROM all_tab_columns
            WHERE owner = Sys_Context('NM3CORE','APPLICATION_OWNER') 
              AND table_name = nth_feature_table
              AND column_name = 'OBJECTID'
              AND ( table_name LIKE '%_ONA_%' OR table_name LIKE '%_NIT_%' 
                 OR table_name LIKE '%_NLT_%' OR table_name LIKE '%_NAT_%' ) 
         );
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes that use theme sequences reference a sequence that exists');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END invalid_sequence_name;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE missing_triggers
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Triggers that have been used with a theme but the theme no longer exists');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme Sequence: '
             || sequence_name
             || ' should be dropped as the Theme no longer exists'
        BULK COLLECT INTO l_results
        FROM user_sequences
       WHERE sequence_name LIKE 'NTH%SEQ'
         AND NOT EXISTS (SELECT 1
                           FROM nm_themes_all
                          WHERE nth_sequence_name = sequence_name)
         AND sequence_name NOT LIKE '%THEME%';
      
      SELECT '    FAIL : Theme Trigger: '||trigger_name||' exists but Theme ['
             ||SUBSTR (trigger_name, 8, INSTR (SUBSTR (trigger_name, 8), '_') - 1)
             ||'] no longer exists'
        BULK COLLECT INTO l_results
        FROM user_triggers
       WHERE trigger_name LIKE 'NM_NTH%SDO_A_ROW_TRG'
         AND NOT EXISTS (
                SELECT 1
                  FROM nm_themes_all
                 WHERE nth_theme_id =
                          SUBSTR (trigger_name,
                                  8,
                                  INSTR (SUBSTR (trigger_name, 8), '_') - 1
                                 ));
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : No triggers exist that relate to missing Themes');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END missing_triggers;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE incorrectly_set_base_themes
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Incorrectly set Base Themes');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme '||z.nth_theme_name||' ['||z.nth_theme_id
                ||'] '||' should not be referencing '||x.nth_theme_name
                ||' ['||z.nth_theme_id
                ||'] '||' in NM_BASE_THEMES'
        BULK COLLECT INTO l_results
        FROM nm_base_themes, nm_themes_all z, nm_themes_all x
       WHERE EXISTS
         (SELECT 1 FROM nm_themes_all b
           WHERE b.nth_theme_id = nbth_base_theme
             AND b.nth_base_table_theme IS NOT NULL)
         AND z.nth_theme_id = nbth_theme_id
         AND x.nth_theme_id = nbth_base_theme;
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : No incorrect Base themes found');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END incorrectly_set_base_themes;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE out_of_step_sequences
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Out Of Step Theme Sequences');
      put('  ====================================================================');
      put(lf);
  --
      DECLARE
        l_curr_value  NUMBER;
        l_table_value NUMBER;
        b_found       BOOLEAN := FALSE;
      BEGIN
      --
        FOR i IN (
          SELECT *
            FROM nm_themes_all
           WHERE nth_sequence_name IS NOT NULL
             AND nth_base_table_theme IS NULL
             AND EXISTS (
                    (SELECT 1
                       FROM nm_nw_themes
                      WHERE nnth_nth_theme_id = nth_theme_id)
                    UNION
                    (SELECT 1
                       FROM nm_area_themes
                      WHERE nath_nth_theme_id = nth_theme_id)
                    UNION
                    (SELECT 1
                       FROM nm_inv_themes
                      WHERE nith_nth_theme_id = nth_theme_id)
                        ))
        LOOP
        --
          BEGIN
            l_curr_value := NULL;
          --
          -- Get the current sequence value
            SELECT last_number INTO l_curr_value
              FROM user_sequences
             WHERE sequence_name = i.nth_sequence_name;
          --
            IF l_curr_value IS NOT NULL
            THEN
            --
              BEGIN
              -- Get the current table MAX value of OBJECTID
                EXECUTE IMMEDIATE 'SELECT MAX(objectid) FROM '||i.nth_feature_table INTO l_table_value;
              --
              -- Compare and raise
                IF l_table_value > l_curr_value
                THEN
                  b_found := TRUE;
                  put ( '    FAIL : Theme '||i.nth_theme_name||' ['||i.nth_feature_table||'] - '
                                           ||i.nth_sequence_name||' ['||l_curr_value||
                                          '] is less than the max OBJECTID - ['||l_table_value||']');
                END IF;
              --
              EXCEPTION
                WHEN OTHERS THEN
                  put ( '    FAIL : Theme '||i.nth_theme_name||' ['||i.nth_feature_table||'] - '
                                         ||i.nth_sequence_name||' ['||l_curr_value||
                                        ' FAILED '||SQLERRM||']');
              END;
            --
            END IF;
          EXCEPTION
            WHEN NO_DATA_FOUND
            THEN NULL;
          END;
        --
        END LOOP;
        IF NOT b_found
        THEN
          put ('    PASS : All sequences are in step with feature table OBJECTIDs');
        END IF;
      --
      END;
    END out_of_step_sequences;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE non_numeric_pfk_columns
    IS
    BEGIN
  --
    ------------------------------------------------------------------------------
    --
    -- Task 0110782
    -- Trap non-numeric primary/foreign key definitions
    --
      put(lf);
      put('  ====================================================================');
      put('  =  Non-numeric primary/foreign key definitions');
      put('  ====================================================================');
      put(lf);
    --
      WITH all_bad_data AS
         (SELECT '    FAIL : Theme ' ||
                 nth_theme_name ||' ['||nth_theme_id||'] '||
                 ' has a character PK column defined on feature table ' ||
                 nth_feature_table ||
                 ' [' ||
                 nth_feature_pk_column ||
                 ']'
            FROM user_tab_columns
               , nm_themes_all
           WHERE nth_feature_table = table_name
             AND nth_feature_pk_column = column_name
             AND data_type != 'NUMBER'
          UNION ALL
          SELECT '    FAIL : Theme ' ||
                 nth_theme_name ||' ['||nth_theme_id||'] '||
                 ' has a character FK column defined on feature table ' ||
                 nth_feature_table ||
                 ' [' ||
                 nth_feature_fk_column ||
                 ']'
            FROM user_tab_columns
               , nm_themes_all
           WHERE nth_feature_table = table_name
             AND nth_feature_fk_column = column_name
             AND data_type != 'NUMBER'
          UNION ALL
          SELECT '    FAIL : Theme ' ||
                 nth_theme_name ||' ['||nth_theme_id||'] '||
                 ' has a character PK column defined on theme table ' ||
                 nth_table_name ||
                 ' [' ||
                 nth_pk_column ||
                 ']'
            FROM user_tab_columns
               , nm_themes_all
           WHERE nth_table_name = table_name
             AND nth_pk_column = column_name
             AND data_type != 'NUMBER')
        SELECT * BULK COLLECT INTO l_results
          FROM all_bad_data
      ORDER BY 1;
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All themes correctly reference numeric PK and FK columns on feature and theme tables');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END non_numeric_pfk_columns;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE check_use_history
    IS
    BEGIN
  --
    ------------------------------------------------------------------------------
    --
    -- Task 0110782
    -- Check nth_use_history column along with nth_start_date and nth_end_date
    -- columns
    --
      put(lf);
      put('  ====================================================================');
      put('  =  Use History set without Start/End date columns defined');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : Theme ' ||
             nth_theme_name ||' ['||nth_theme_id||'] '||
             ' has Use History set to ' ||nth_use_history||
             ' and Start and/or End date columns are undefined'
        BULK COLLECT INTO l_results
        FROM nm_themes_all
       WHERE nth_use_history = 'Y'
         AND nth_base_table_theme IS NULL
         AND ( nth_start_date_column IS NULL OR nth_end_date_column IS NULL);
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All themes with Use History set reference a Start and/or End date column');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    --
      put(lf);
      put('  ====================================================================');
      put('  =  Use History set but start/end date columns do not exist');
      put('  ====================================================================');
      put(lf);
    --
      WITH all_data AS
        ( SELECT 1 seq, nth_theme_id, '    FAIL : Theme ' ||nth_theme_name ||' ['||nth_theme_id||'] '||
               ' references '||nth_start_date_column||' but this column does not exist on '||nth_feature_table error_text
          FROM nm_themes_all
         WHERE nth_use_history = 'Y'
           AND nth_base_table_theme IS NULL
          AND (   nth_start_date_column IS NOT NULL 
              AND nth_end_date_column IS NOT NULL)
          AND NOT EXISTS
            (SELECT 1 FROM all_tab_columns
              WHERE owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
                AND table_name = nth_feature_table
                AND column_name = nth_start_date_column )
        UNION
        SELECT 2 seq, nth_theme_id, '    FAIL : Theme ' ||nth_theme_name ||' ['||nth_theme_id||'] '||
               ' references '||nth_end_date_column||' but this column does not exist on '||nth_feature_table error_text
          FROM nm_themes_all
         WHERE nth_use_history = 'Y'
           AND nth_base_table_theme IS NULL
          AND (   nth_start_date_column IS NOT NULL 
              AND nth_end_date_column IS NOT NULL)
          AND NOT EXISTS
            (SELECT 1 FROM all_tab_columns
              WHERE owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
                AND table_name = nth_feature_table
                AND column_name = nth_end_date_column ))
        SELECT error_text BULK COLLECT INTO l_results FROM all_data
         ORDER BY nth_theme_id, seq;
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All themes with Use History set reference a Start and/or End date column which exists on the feature table');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    --
    --
    END check_use_history;
  --
  --------------------------------------------------------------------------------
  --
--    PROCEDURE
--    IS
--    BEGIN
--    
--    END;
  --
  --------------------------------------------------------------------------------
  -- ********* WARNINGS ***********
  --------------------------------------------------------------------------------
  --
    PROCEDURE missing_rse_table
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that reference a non-existent RSE table');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    WARNING : Theme : '||nth_theme_name ||' ['||nth_theme_id||'] references a non-existent RSE table'
          || ' [nth_rse_table_name = '||nth_rse_table_name||']'
        BULK COLLECT INTO l_results
        FROM nm_themes_all
       WHERE nth_rse_table_name IS NOT NULL
       AND NOT EXISTS 
         (SELECT 1 FROM user_objects 
           WHERE object_name = nth_rse_table_name );
    --
      IF l_results.COUNT = 0
      THEN
        put('   PASS : All Themes reference suitable RSE table(s)');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END missing_rse_table;
  -- 
  --------------------------------------------------------------------------------
  --
    PROCEDURE missing_rse_fk_column
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that reference a non-existent RSE FK column');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    WARNING : Theme : '||nth_theme_name ||' ['||nth_theme_id||'] references a non-existent RSE FK column'
          || ' [nth_rse_fk_column = '||nth_rse_fk_column||']'
        BULK COLLECT INTO l_results
        FROM nm_themes_all
       WHERE NOT EXISTS (
          SELECT 1
            FROM user_tab_columns
           WHERE table_name = nth_rse_table_name
             AND column_name = NVL (nth_rse_fk_column, column_name))
         AND nth_rse_fk_column IS NOT NULL
         AND nth_rse_table_name IS NOT NULL
         AND nth_theme_type = 'SDO';
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes reference suitable RSE FK columns');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END missing_rse_fk_column;
  --
  -------------------------------------------------------------------------------- 
  --
    PROCEDURE missing_rse_st_chain_column
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that reference a non-existent Start Chain column');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    WARNING : Theme : '||nth_theme_name ||' ['||nth_theme_id||'] references a non-existent Start Chain column'
          || ' [nth_st_chain_column = '||nth_st_chain_column||']'
        BULK COLLECT INTO l_results
        FROM nm_themes_all
       WHERE NOT EXISTS (
          SELECT 1
            FROM user_tab_columns
           WHERE table_name = nth_table_name
             AND column_name = NVL (nth_st_chain_column, column_name))
         AND nth_st_chain_column IS NOT NULL
         AND nth_theme_type = 'SDO';
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes reference suitable Start Chain columns');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END missing_rse_st_chain_column;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE missing_rse_end_chain_column
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Themes that reference a non-existent End Chain column');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    WARNING : Theme : '||nth_theme_name ||' ['||nth_theme_id||'] references a non-existent End Chain column'
          || ' [nth_end_chain_column = '||nth_end_chain_column||']'
        BULK COLLECT INTO l_results
        FROM nm_themes_all
       WHERE NOT EXISTS (
          SELECT 1
            FROM user_tab_columns
           WHERE table_name = nth_table_name
             AND column_name = NVL (nth_end_chain_column, column_name))
         AND nth_end_chain_column IS NOT NULL
         AND nth_theme_type = 'SDO';
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes reference suitable End Chain columns');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END missing_rse_end_chain_column;
  --
  --------------------------------------------------------------------------------
  --
    PROCEDURE dangling_sequences
    IS
    BEGIN
      put(lf);
      put('  ====================================================================');
      put('  =  Theme sequences that exist but the Themes have been removed');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    WARNING : Theme Sequence: '
             || sequence_name
             || ' should be dropped as the Theme no longer exists'
        BULK COLLECT INTO l_results
        FROM user_sequences
       WHERE sequence_name LIKE 'NTH%SEQ'
         AND NOT EXISTS (SELECT 1
                           FROM nm_themes_all
                          WHERE nth_sequence_name = sequence_name)
         AND sequence_name NOT LIKE '%THEME%';
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : No sequences exist that relate to missing Themes');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    END dangling_sequences;
  --
  --------------------------------------------------------------------------------
  --
--    PROCEDURE
--    IS
--    BEGIN
--    
--    END;
  --
  -------------------------------------------------------------------------------- 
  -- End of checking code
  --------------------------------------------------------------------------------
  --
  BEGIN
  --
    l_results.DELETE;
  --
    IF b_serverout
    THEN
    --
      dbms_output.enable;
      g_write_to_file := FALSE;
    ELSE
    --
      g_location := pi_location;
      g_filename := pi_filename;
      g_write_to_file := TRUE;
      nm3file.write_file(g_location, g_filename, NULL, l_results);
    END IF;
  --
  ------------------------------------------------------------------------------
  --
    put(lf);
    put('********************************************************************');
    put('*');
    put('*  THEME CHECKER ');
    put('*');
    put('*     Executed on : '||to_Char(sysdate,'DD-MON-YYYY HH24:MI:SS'));
    put('*');
    put('*     Running on  : '||Sys_Context('NM3_SECURITY_CTX','USERNAME')||'@'||get_oracle_summary);
  --
    IF pi_supress_warnings
    THEN
      put('*');
      put('*     WARNINGS SUPRESSED ');
      put('*');
    END IF;
  --
    put('*');
    put('********************************************************************');
    put(lf);
  --
    put(' ********************************************************************');
    put(' *');
    put(' *  FAILURE CHECKS ');
    put(' *');
    put(' *    These checks are failures and could potentially have a serious ');
    put(' *    impact on the functionality of the product.'); 
    put(' *');
    put(' ********************************************************************');
    put(lf);
    put(lf);
  --
    non_sdo_layers;
  --
    null_theme_table;
  --
    null_feature_table;
  --
    unsuitable_pk_fk_cols_combi;
  --
    non_numeric_pfk_columns;
  --
    non_existant_label_column;
  --
    missing_pk_column;
  --
    missing_x_column;
  --
    missing_y_column;
  --
    missing_feature_pk_column;
  --
    missing_feature_fk_column;
  --
    missing_feature_shape_column;
  --
    check_use_history;
  --
    no_base_theme_set;
  --
    no_net_theme_set;
  --
    invalid_base_themes;
  --
    incorrectly_set_base_themes;
  --
    invalid_snapping_themes;
  --
    incorrect_snapping_references;
  --
    no_ne_id_of_column;
  --
    linear_route_uoe;
  --
    uoe_referencing_view_themes;
  --
    invalid_sequence_name;
  --
    out_of_step_sequences;
  --
    missing_triggers;
  --
    IF NOT pi_supress_warnings
    THEN
    --
      put(lf);
      put(lf);
      put(' ********************************************************************');
      put(' *');
      put(' *  WARNING CHECKS ');
      put(' *');
      put(' *    These checks are warnings and should not have a serious ');
      put(' *    impact on the functionality of the product.'); 
      put(' *    However, they should be addressed for completeness and for ');
      put(' *    compatibility with possible future product changes. ');
      put(' *');
      put(' ********************************************************************');
      put(lf);
      put(lf);
    --
      missing_rse_table;
    --
      missing_rse_fk_column;
    --
      missing_rse_st_chain_column;
    --
      missing_rse_end_chain_column;
    --
      dangling_sequences;
    --
    END IF;
  --
  ------------------------------------------------------------------------------
  --
    put(lf);
    put(lf);
    put('********************************************************************');
    put('*');
    put('*  THEME CHECKER COMPLETE');
    put('*');
    put('*     Finished at : '||to_Char(sysdate,'DD-MON-YYYY HH24:MI:SS'));
    put('*');
    put('********************************************************************');
    put(lf);
  --
  END run_theme_check;
--
--------------------------------------------------------------------------------
--
END nm3sdo_check;
/
