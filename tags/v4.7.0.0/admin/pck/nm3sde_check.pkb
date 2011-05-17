CREATE OR REPLACE PACKAGE BODY nm3sde_check
AS
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3sde_check.pkb-arc   2.2   May 17 2011 08:26:24   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3sde_check.pkb  $
--       Date into PVCS   : $Date:   May 17 2011 08:26:24  $
--       Date fetched Out : $Modtime:   May 05 2011 13:41:58  $
--       PVCS Version     : $Revision:   2.2  $
--
--------------------------------------------------------------------------------
--

  g_package_name          CONSTANT VARCHAR2(30)    := 'nm3sdo_check';
  g_body_sccsid           CONSTANT VARCHAR2(2000)  := '"$Revision:   2.2  $"';
  lf                      CONSTANT VARCHAR2(30)    := chr(10);
  g_write_to_file                  BOOLEAN         := FALSE;
  l_results                        nm3type.tab_varchar32767;
  g_location                       VARCHAR2(1000);
  g_filename                       VARCHAR2(1000);
--
--------------------------------------------------------------------------------
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
  FUNCTION get_sde_version
  RETURN VARCHAR2
  IS
    retval nm3type.max_varchar2;
  BEGIN
    SELECT  v.major||'.'|| v.minor||'.'||v.bugfix||' - '
         ||SUBSTR(v.description, 0, 50)||'  [ Release '|| v.release|| ' ]'
      INTO retval
      FROM sde.VERSION v;
    RETURN retval;
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN 
      RETURN 'Cannot find SDE version';
  END get_sde_version;
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
  PROCEDURE run_sde_check
                 ( pi_location      IN VARCHAR2 DEFAULT NULL
                 , pi_filename      IN VARCHAR2 DEFAULT NULL
                 , pi_owner         IN hig_users.hus_username%TYPE DEFAULT NULL)
  IS
    b_serverout    BOOLEAN := pi_location IS NULL OR pi_filename IS NULL;
    l_owner        hig_users.hus_username%TYPE := NVL(pi_owner, Sys_Context('NM3_SECURITY_CTX','USERNAME'));
  BEGIN
  --
  ------------------------------------------------------------------------------
  --  Report missing data for SDE layers
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
    put('*  ESRI SDE METADATA CHECKER ');
    put('*');
    put('*     Executed on : '||to_Char(sysdate,'DD-MON-YYYY HH24:MI:SS'));
    put('*');
    put('*     Running on  : '||l_owner||'@'||get_oracle_summary);
    put('*');
    put('*     SDE Version : '||nm3sde_check.get_sde_version);
    put('*');
    put('********************************************************************');
    put(lf);
  --
  ------------------------------------------------------------------------------
  --
    IF l_owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
    THEN
    --
      put(lf);
      put('  ====================================================================');
      put('  =  SDE Layers that are missing ( ** UNRESTRICTED BY ROLE ** )');
      put('  ====================================================================');
      put(lf);
    --
      SELECT '    FAIL : '||nth_feature_table||' ['||nth_theme_name||']'||' is not registered in SDE for '||l_owner
        BULK COLLECT INTO l_results
        FROM nm_themes_all
       WHERE nth_theme_type = 'SDO'
         AND NOT EXISTS (
                SELECT 1
                  FROM sde.layers
                 WHERE owner = l_owner
                   AND table_name = nth_feature_table
                   AND spatial_column = nth_feature_shape_column);
    --
      IF l_results.COUNT = 0
      THEN
        put('    PASS : All Themes for '||l_owner||' are registered in SDE Layers table');
      ELSE 
        FOR i IN 1..l_results.COUNT LOOP
          put(l_results(i));
        END LOOP;
      END IF;
    --
    END IF;
  --
  ------------------------------------------------------------------------------
  --
    put(lf);
    put('  ====================================================================');
    put('  =  SDE Layers that are missing');
    put('  ====================================================================');
    put(lf);
  --
    SELECT '    FAIL : '||nth_feature_table||' ['||nth_theme_name||']'||' is not registered in SDE for '||l_owner
      BULK COLLECT INTO l_results
      FROM nm_themes_all
     WHERE nth_theme_type = 'SDO'
       AND NOT EXISTS (
              SELECT 1
                FROM sde.layers
               WHERE owner = l_owner
                 AND table_name = nth_feature_table
                 AND spatial_column = nth_feature_shape_column)
       AND EXISTS
         (SELECT 1
            FROM nm_theme_roles, hig_user_roles
           WHERE nth_theme_id = nthr_theme_id
             AND nthr_role = hur_role
             AND hur_username = l_owner);
  --
    IF l_results.COUNT = 0
    THEN
      put('    PASS : All Themes for '||l_owner||' are registered in SDE Layers table');
    ELSE 
      FOR i IN 1..l_results.COUNT LOOP
        put(l_results(i));
      END LOOP;
    END IF;
  --
  ------------------------------------------------------------------------------
  --
    put(lf);
    put('  ====================================================================');
    put('  =  SDE Layers that refer to missing table/views');
    put('  ====================================================================');
    put(lf);
  --
    SELECT '    FAIL : '||table_name||' ['||description||']'||' is registered for user '||l_owner
         ||' but the object does not exist '
      BULK COLLECT INTO l_results
      FROM sde.layers
     WHERE owner = l_owner
       AND NOT EXISTS (
              SELECT 1
                FROM user_objects
               WHERE object_name = table_name);
  --
    IF l_results.COUNT = 0
    THEN
      put('    PASS : All SDE layers for '||l_owner||' refer to table/views that exist');
    ELSE 
      FOR i IN 1..l_results.COUNT LOOP
        put(l_results(i));
      END LOOP;
    END IF;
--
  ------------------------------------------------------------------------------
  --
    put(lf);
    put('  ====================================================================');
    put('  =  SDE Layers that refer to missing Themes');
    put('  ====================================================================');
    put(lf);
  --
    SELECT '    FAIL : '||table_name||' ['||description||']'||' is registered for user '||l_owner
         ||' but a corresponding Theme does not exist'
      BULK COLLECT INTO l_results
      FROM sde.layers
     WHERE owner = l_owner
       AND EXISTS (SELECT 1
                     FROM user_objects
                    WHERE object_name = table_name)
       AND NOT EXISTS (SELECT 1
                         FROM nm_themes_all
                        WHERE table_name = nth_feature_table);
  --
    IF l_results.COUNT = 0
    THEN
      put('    PASS : All SDE layers for '||l_owner||' refer to Themes that exist');
    ELSE 
      FOR i IN 1..l_results.COUNT LOOP
        put(l_results(i));
      END LOOP;
    END IF;
  --
  ------------------------------------------------------------------------------
  --
    put(lf);
    put('  ====================================================================');
    put('  =  SDE Layers that have missing Geometry Column metadata '); 
    put('  =  for feature columns ');
    put('  ====================================================================');
    put(lf);
  --
    SELECT '    FAIL : '||table_name||' ['||description||']'||' is registered for user '||l_owner
         ||' but the Geometry Column metadata for '||nth_feature_shape_column||' is missing'
      BULK COLLECT INTO l_results
      FROM sde.layers, nm_themes_all
     WHERE owner = l_owner
       AND table_name = nth_feature_table
       AND NOT EXISTS (
              SELECT 1
                FROM sde.geometry_columns
               WHERE f_table_schema = owner
                 AND f_geometry_column = nth_feature_shape_column)
       AND EXISTS
         (SELECT 1
            FROM nm_theme_roles, hig_user_roles
           WHERE nth_theme_id = nthr_theme_id
             AND nthr_role = hur_role
             AND hur_username = l_owner);
  --
    IF l_results.COUNT = 0
    THEN
      put('    PASS : All SDE layers for '||l_owner||' have Geometry Column metadata for feature columns');
    ELSE 
      FOR i IN 1..l_results.COUNT LOOP
        put(l_results(i));
      END LOOP;
    END IF;
--
  ------------------------------------------------------------------------------
  --
    put(lf);
    put('  ====================================================================');
    put('  =  SDE Layers that have missing Column Registry metadata ');
    put('  ====================================================================');
    put(lf);
  --
    SELECT '    FAIL : '||uc.table_name||' is registered for user '||l_owner
         ||' but '||'['||uc.column_name||'] is not registered in Column Registry '
      BULK COLLECT INTO l_results 
      FROM sde.layers l, nm_themes_all,  user_tab_columns uc
     WHERE l.owner = l_owner
       AND l.table_name = nth_feature_table
       AND uc.table_name = nth_feature_table
       AND NOT EXISTS (
              SELECT 1 FROM sde.column_registry c
               WHERE l.owner = c.owner
                 AND uc.column_name = c.column_name
                 AND uc.table_name = c.table_name)
       AND EXISTS
         (SELECT 1
            FROM nm_theme_roles, hig_user_roles
           WHERE nth_theme_id = nthr_theme_id
             AND nthr_role = hur_role
             AND hur_username = l_owner)
    ORDER BY l.table_name;
  --
    IF l_results.COUNT = 0
    THEN
      put('    PASS : All SDE layers for '||l_owner||' have Column Registry metadata');
    ELSE 
      FOR i IN 1..l_results.COUNT LOOP
        put(l_results(i));
      END LOOP;
    END IF;
  --
  ------------------------------------------------------------------------------
  --
    put(lf);
    put('  ====================================================================');
    put('  =  SDE Layers that have Column Registry metadata for columns that');
    put('  =  do not exist on the table');
    put('  ====================================================================');
    put(lf);
  --
    SELECT '    FAIL : '||c.table_name||' ['||c.column_name||']'||' is registered for user '||l_owner
         ||' but the column does not exist on the table'
      BULK COLLECT INTO l_results 
      FROM sde.layers l, nm_themes_all, sde.column_registry c
     WHERE l.owner = l_owner
       AND l.table_name = nth_feature_table
       AND c.table_name = nth_feature_table
       AND c.owner = l.owner
       AND NOT EXISTS (
              SELECT 1
                FROM user_tab_columns uc
               WHERE uc.column_name = c.column_name
                 AND uc.table_name = c.table_name)
       AND EXISTS
         (SELECT 1
            FROM nm_theme_roles, hig_user_roles
           WHERE nth_theme_id = nthr_theme_id
             AND nthr_role = hur_role
             AND hur_username = l_owner)
    ORDER BY l.table_name;
  --
    IF l_results.COUNT = 0
    THEN
      put('    PASS : All SDE layers for '||l_owner||' have Column Registry metadata for columns that exist on the table');
    ELSE 
      FOR i IN 1..l_results.COUNT LOOP
        put(l_results(i));
      END LOOP;
    END IF;
  
  --
  ------------------------------------------------------------------------------
  --
    put(lf);  
    put('  ====================================================================');
    put('  =  SDE Layers that have missing Table Registry metadata ');
    put('  ====================================================================');
    put(lf);
  --
    SELECT '    FAIL : '||table_name||' ['||description||']'||' is registered for user '||l_owner
         ||' but the Table Registry metadata is missing'
      BULK COLLECT INTO l_results
      FROM sde.layers l, nm_themes_all
     WHERE l.owner = l_owner
       AND l.table_name = nth_feature_table
       AND NOT EXISTS (
              SELECT 1
                FROM sde.table_registry r, user_tab_columns c
               WHERE l.owner = r.owner
                 AND r.table_name = c.table_name
                 AND r.rowid_column = c.column_name)
       AND EXISTS
         (SELECT 1
            FROM nm_theme_roles, hig_user_roles
           WHERE nth_theme_id = nthr_theme_id
             AND nthr_role = hur_role
             AND hur_username = l_owner);
  --
    IF l_results.COUNT = 0
    THEN
      put('    PASS : All SDE layers for '||l_owner||' have Table Registry metadata');
    ELSE 
      FOR i IN 1..l_results.COUNT LOOP
        put(l_results(i));
      END LOOP;
    END IF;
  --
  ------------------------------------------------------------------------------
  --
    put(lf);
    put('  ====================================================================');
    put('  =  SDE Layers that have RowID Column registered, but the column is ');
    put('  =  missing from the table');
    put('  ====================================================================');
    put(lf);
  --
    SELECT '    FAIL : '||l.table_name||' ['||l.description||']'||' is registered for user '||l_owner
         ||' but the RowID column ['||rowid_column||'] is does not exist on the table '
      BULK COLLECT INTO l_results
      FROM sde.layers l, nm_themes_all, sde.table_registry r, user_tables t
     WHERE l.owner = l_owner
       AND l.table_name = nth_feature_table
       AND nth_feature_table = t.table_name
       AND r.table_name = l.table_name
       AND r.owner = l.owner
       AND NOT EXISTS (
              SELECT 1
                FROM user_tab_columns i
               WHERE r.table_name = i.table_name
                 AND r.rowid_column = i.column_name)
       AND EXISTS
         (SELECT 1
            FROM nm_theme_roles, hig_user_roles
           WHERE nth_theme_id = nthr_theme_id
             AND nthr_role = hur_role
             AND hur_username = l_owner)
    ORDER BY l.table_name;
  --
    IF l_results.COUNT = 0
    THEN
      put('    PASS : All SDE layers for '||l_owner||' have RowID Columns registered that exist on the feature tables');
    ELSE 
      FOR i IN 1..l_results.COUNT LOOP
        put(l_results(i));
      END LOOP;
    END IF;
  --
  ------------------------------------------------------------------------------
  --
    put(lf);
    put('  ====================================================================');
    put('  =  SDE Layers that have RowID Column registered, but the column is ');
    put('  =  not the first indexed column (or not indexed at all)');
    put('  ====================================================================');
    put(lf);
  --
    SELECT '    FAIL : '||l.table_name||' ['||l.description||']'||' is registered for user '||l_owner
         ||' but the RowID column ['||rowid_column||'] is not the first indexed column'
      BULK COLLECT INTO l_results
      FROM sde.layers l, nm_themes_all, sde.table_registry r, user_tables t
     WHERE l.owner = l_owner
       AND l.table_name = nth_feature_table
       AND nth_feature_table = t.table_name
       AND r.table_name = l.table_name
       AND r.owner = l.owner
       AND NOT EXISTS (
              SELECT 1
                FROM user_ind_columns i
               WHERE l.owner = r.owner
                 AND r.table_name = i.table_name
                 AND r.rowid_column = i.column_name
                 AND i.column_position = 1)
       AND EXISTS
         (SELECT 1
            FROM nm_theme_roles, hig_user_roles
           WHERE nth_theme_id = nthr_theme_id
             AND nthr_role = hur_role
             AND hur_username = l_owner)
    ORDER BY l.table_name;
  --
    IF l_results.COUNT = 0
    THEN
      put('    PASS : All SDE layers for '||l_owner||' have RowID Columns registered being the first indexed column');
    ELSE 
      FOR i IN 1..l_results.COUNT LOOP
        put(l_results(i));
      END LOOP;
    END IF;
--
  ------------------------------------------------------------------------------
  --
    put(lf);
    put('  ====================================================================');
    put('  =  SDE Layers that have incorrect EFlags metadata');
    put('  ====================================================================');
    put(lf);
  --
    DECLARE
      l_tabs    nm3type.tab_varchar30;
      l_cols    nm3type.tab_varchar30;
      l_eflags  nm3type.tab_number;
      l_gtype   NUMBER;
      no_errors BOOLEAN := TRUE;
    BEGIN
      SELECT nth_feature_table, nth_feature_shape_column, eflags
        BULK COLLECT INTO l_tabs, l_cols, l_eflags
        FROM nm_themes_all, sde.layers l
       WHERE nth_theme_type = 'SDO'
         AND EXISTS (SELECT 1
                       FROM user_tables t
                      WHERE t.table_name = nth_feature_table)
         AND nth_feature_table = l.table_name
         AND nth_feature_shape_column = l.spatial_column
         AND l.owner = l_owner
         AND EXISTS
           (SELECT 1
              FROM nm_theme_roles, hig_user_roles
             WHERE nth_theme_id = nthr_theme_id
               AND nthr_role = hur_role
               AND hur_username = l_owner);
    --
      IF l_tabs.COUNT>0
      THEN
    --
        FOR i IN 1..l_tabs.COUNT
        LOOP
      --
          IF l_tabs(i) IS NOT NULL AND l_cols(i) IS NOT NULL
          AND l_eflags(i) IS NOT NULL
          THEN
        --
            BEGIN
              EXECUTE IMMEDIATE 'SELECT max(a.'||l_cols(i)||'.sdo_gtype) from '||l_tabs(i)||' a'
              INTO l_gtype;
            --
              IF nm3sde.convert_to_sde_eflag(l_gtype) != l_eflags(i)
              THEN
                no_errors := FALSE;
                put('    FAIL : '||l_tabs(i)||' ['||l_cols(i)||']'||' is registered for user '||l_owner
                  ||' but the EFlag value ['||l_eflags(i)
                  ||'] should be ['||nm3sde.convert_to_sde_eflag(l_gtype)
                  ||'] for GType '||l_gtype);
              END IF;
            --
            EXCEPTION
              WHEN NO_DATA_FOUND
                THEN NULL;
            END;
        --
          END IF;
      --
        END LOOP;
      --
        IF no_errors
        THEN
          put('    PASS : All SDE layers for '||l_owner||' have correct EFlags');
        ELSE
          put(lf);
          put('    FAIL : Please check all dependent layers that are registered as views of the above layers');
        END IF;
    --
      END IF;
  --
    END;
  --
  ------------------------------------------------------------------------------
  --
    put(lf);
    put(lf);
    put('********************************************************************');
    put('*');
    put('*  ESRI SDE METADATA CHECKER ');
    put('*');
    put('*     Finished at : '||to_Char(sysdate,'DD-MON-YYYY HH24:MI:SS'));
    put('*');
    put('********************************************************************');
    put(lf);
--
--  EXCEPTION
--    WHEN OTHERS THEN RAISE;
  END run_sde_check; 
--
--------------------------------------------------------------------------------
--
END nm3sde_check;
/
