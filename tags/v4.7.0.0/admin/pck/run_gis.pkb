CREATE OR REPLACE PACKAGE BODY Run_Gis AS
--<PACKAGE>
--   SCCS Identifiers :-
--
--       sccsid           : @(#)run_gis.pkb	1.6 06/12/07
--       Module Name      : run_gis.pkb
--       Date into SCCS   : 07/06/12 10:53:09
--       Date fetched Out : 07/06/13 15:37:51
--       SCCS Version     : 1.6
--
--       Author   Rob Coupe
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--</PACKAGE>
  g_body_sccsid     CONSTANT  VARCHAR2(2000) := '@(#)run_gis.pkb	1.6 06/12/07';
--
-----------------------------------------------------------------------------
--
  FUNCTION get_version RETURN VARCHAR2 IS
  BEGIN
     RETURN g_sccsid;
  END get_version;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_body_version RETURN VARCHAR2 IS
  BEGIN
     RETURN g_body_sccsid;
  END get_body_version;
--
-----------------------------------------------------------------------------

  PROCEDURE run_pls_module 
              ( p_module      IN VARCHAR2
              , p_param_name1 IN VARCHAR2 DEFAULT NULL, p_param_value1 IN VARCHAR2 DEFAULT NULL
              , p_param_name2 IN VARCHAR2 DEFAULT NULL, p_param_value2 IN VARCHAR2 DEFAULT NULL
              , p_param_name3 IN VARCHAR2 DEFAULT NULL, p_param_value3 IN VARCHAR2 DEFAULT NULL
              , p_param_name4 IN VARCHAR2 DEFAULT NULL, p_param_value4 IN VARCHAR2 DEFAULT NULL
              , p_param_name5 IN VARCHAR2 DEFAULT NULL, p_param_value5 IN VARCHAR2 DEFAULT NULL
              , p_param_name6 IN VARCHAR2 DEFAULT NULL, p_param_value6 IN VARCHAR2 DEFAULT NULL ) 
  IS
--
  CURSOR c1 ( c_module IN VARCHAR2) IS
    SELECT hmo_module, hmo_title, hmo_filename
      FROM hig_modules
     WHERE hmo_module = p_module
       AND EXISTS 
         ( SELECT 1
             FROM hig_module_roles, hig_user_roles
            WHERE hmr_module = hmo_module
              AND hur_role = hmr_role );
--
    l_module       hig_modules.hmo_module%TYPE; 
    l_title        hig_modules.hmo_title%TYPE;
    l_filename     hig_modules.hmo_filename%TYPE;
    c_str          VARCHAR2(2000);
    l_package      VARCHAR2(30);
    l_procedure    VARCHAR2(30);
    l_num_value    NUMBER;
--
  /*
  cursor c_arg ( c_package in varchar2, c_procedure in varchar2 ) is
  select argument_name, position, sequence, data_type
  from all_arguments
  where nvl(c_package, '~') = decode ( c_package, NULL, '~', package_name )
  and object_name = c_procedure;
  */
--
  BEGIN
  --
    OPEN c1( p_module );
    FETCH c1 INTO l_module, l_title, l_filename;
    CLOSE c1;
  --
  -- get the parameter list for the procedure
  --
  --
    IF INSTR( l_filename, '.') > 0 THEN
    --
      l_package   := SUBSTR( l_filename, 1, INSTR( l_filename, '.'));
      l_procedure := SUBSTR( l_filename, INSTR( l_filename, '.') + 1 );
    --
    ELSE
    --
      l_package   := NULL;
      l_procedure := l_filename;
    --
    END IF;

  /*  for irec in c_arg( upper(l_package), upper(l_procedure) ) loop
      null;
      nm_debug.debug('Parameter = '||irec.argument_name||' type= '||irec.data_type );
    end loop;
  */
    l_num_value := TO_NUMBER( p_param_value1 );
    c_str := ' begin '||l_filename||'( '||p_param_name1||' => :session ); end;';
  --
    EXECUTE IMMEDIATE c_str USING l_num_value;
  --
  END run_pls_module;

----------------------------------------------------------------------------
--
  PROCEDURE run_pls_module ( p_module       IN VARCHAR2,
                             p_param_name1  IN VARCHAR2 DEFAULT NULL,
                             p_param_value1 IN NUMBER   DEFAULT NULL) 
  IS
  --
    CURSOR c1 ( c_module IN VARCHAR2) IS
      SELECT hmo_module, hmo_title, hmo_filename
        FROM hig_modules
       WHERE hmo_module = p_module
         AND EXISTS 
           ( SELECT 1
               FROM hig_module_roles, hig_user_roles
              WHERE hmr_module = hmo_module
                AND hur_role = hmr_role );
  --
    l_module   hig_modules.hmo_module%TYPE;
    l_title    hig_modules.hmo_title%TYPE;
    l_filename hig_modules.hmo_filename%TYPE;
  --
  BEGIN
  --
    OPEN c1( p_module );
    FETCH c1 INTO l_module, l_title, l_filename;
    CLOSE c1;
  --
  -- get the parameter list for the procedure
  --
    EXECUTE IMMEDIATE ' begin '||l_filename||'( '||p_param_name1||' => :session ); end;' USING p_param_value1;
  --
  END run_pls_module;
--
-------------------------------------------------------------------------------------------------------------------
--
  PROCEDURE run_pls_from_gis ( p_theme  IN NUMBER
                             , p_module IN VARCHAR2
                             , p_list   IN int_array ) 
  IS
    l_sess          INTEGER := Nm3seq.next_gis_session_id;
    l_param         nm_theme_functions_all.ntf_parameter%TYPE;
    l_theme_name    nm_themes_all.nth_theme_name%TYPE;
    b_inserted      BOOLEAN := FALSE;
  BEGIN
  --
    SELECT ntf_parameter, nth_theme_name
      INTO l_param, l_theme_name
      FROM nm_theme_functions_all, nm_themes_all
     WHERE ntf_nth_theme_id = p_theme
       AND nth_theme_id = ntf_nth_theme_id
       AND ntf_hmo_module = p_module;
  --
     FOR i IN 1..p_list.ia.LAST LOOP
    --
    -- This is using a loop, rather than a simple insert from casting the array 
    -- as a table because the latter method seems to fail when executed from SQL.

      BEGIN
        INSERT INTO GIS_DATA_OBJECTS (
           gdo_session_id, gdo_pk_id,  gdo_seq_no, gdo_theme_name )
        VALUES ( l_sess, p_list.ia(i), i, l_theme_name );
      EXCEPTION WHEN OTHERS THEN
        Nm_Debug.DEBUG( SQLERRM );
      END;
    --
      b_inserted := TRUE;
    --
    END LOOP;
    --
    COMMIT;
    --     
    -- check that there is some data
    IF b_inserted
    THEN
      Run_Gis.run_pls_module( p_module=>p_module, p_param_name1 => l_param, p_param_value1 => TO_CHAR(l_sess));
    END IF;
  --
  END run_pls_from_gis;
--
-------------------------------------------------------------------------------------------------------------------
--
END;
/
