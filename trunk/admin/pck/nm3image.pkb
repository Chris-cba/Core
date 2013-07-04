CREATE OR REPLACE PACKAGE BODY nm3image AS
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3image.pkb	1.1 10/28/05
--       Module Name      : nm3image.pkb
--       Date into SCCS   : 05/10/28 09:08:58
--       Date fetched Out : 07/06/13 14:11:47
--       SCCS Version     : 1.1
--
--   Author : Ade Edwards
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  VARCHAR2(2000) := '@(#)nm3image.pkb	1.1 10/28/05';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  VARCHAR2(30)   := 'NM3IMAGE';
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
--
  PROCEDURE load ( pi_image_name    IN VARCHAR2
                 , pi_img_dir_name  IN VARCHAR2
                 , pi_img_table     IN user_tables.table_name%TYPE
                 , pi_img_column    IN user_tab_columns.column_name%TYPE
                 , pi_img_uk_column IN user_tab_columns.column_name%TYPE
                 , pi_img_uk_value  IN VARCHAR2 )
  IS
    v_bfile     BFILE;
    v_blob      BLOB;
    l_sql       nm3type.max_varchar2;
  --
    e_no_blob   EXCEPTION;
  --
    FUNCTION check_for_blob_column
               ( pi_table_name  IN VARCHAR2
               , pi_column_name IN VARCHAR2 )
      RETURN BOOLEAN IS
      l_dummy NUMBER;
    BEGIN
      SELECT 1
        INTO l_dummy
        FROM user_tab_columns
       WHERE table_name = pi_table_name
         AND column_name  = pi_column_name
         AND data_type = 'BLOB';
       RETURN TRUE;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN RETURN FALSE;
      WHEN OTHERS THEN RAISE;
    END check_for_blob_column;
  --
  BEGIN
  --
     nm_debug.debug_on;
     nm_debug.debug('Check column make sure its blob');
  -- Check to make sure destination table/column is correct
    IF NOT check_for_blob_column ( pi_img_table, pi_img_column )
    THEN
      RAISE e_no_blob;
    END IF;
  --
  -- Build up dynamic statement
    l_sql := ' UPDATE '||pi_img_table
           ||'    SET '||pi_img_column||' = empty_blob()'
           ||'  WHERE '||pi_img_uk_column||' = '||nm3flx.string(pi_img_uk_value)
           ||' RETURNING '||pi_img_column||' INTO :v_blob';

    nm_debug.debug('Execute '||l_sql);
    EXECUTE IMMEDIATE l_sql RETURNING INTO v_blob;
  --
    v_bfile := BFILENAME(pi_img_dir_name, pi_image_name);
    Dbms_Lob.Fileopen(v_bfile, Dbms_Lob.File_Readonly);
    Dbms_Lob.Loadfromfile(v_blob, v_bfile, Dbms_Lob.Getlength(v_bfile));
    Dbms_Lob.Fileclose(v_bfile);
    COMMIT;
  EXCEPTION
    WHEN e_no_blob
    THEN
      RAISE_APPLICATION_ERROR(-20501, 'Table '||pi_img_table||', column '
                                  ||pi_img_column||' is not a BLOB datatype');
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
  END load;
--
-----------------------------------------------------------------------------
--
  PROCEDURE get ( pi_img_table     IN user_tables.table_name%TYPE
                , pi_img_column    IN user_tab_columns.column_name%TYPE
                , pi_img_uk_column IN user_tab_columns.column_name%TYPE
                , pi_img_uk_value  IN VARCHAR2
                , pi_img_type      IN VARCHAR2 DEFAULT 'bmp'
        --        , po_image         IN OUT BLOB )
                , po_image         IN OUT LONG RAW ) 
  IS
    v_blob  BLOB;
    v_amt   NUMBER := 30;
    v_off   NUMBER := 1;
    v_raw   RAW(4096);
    l_sql   nm3type.max_varchar2;
  BEGIN
    l_sql := 'SELECT '||pi_img_column
           ||'  FROM '||pi_img_table
           ||' WHERE '||pi_img_uk_column||' = '||nm3flx.string(pi_img_uk_value);
  --
    nm_debug.debug_on;
    nm_debug.debug(l_sql);
    EXECUTE IMMEDIATE l_sql INTO v_blob;
  --
--     Owa_Util.Mime_Header('image/' || pi_img_type);
--   -- nm_layer_tree
--     BEGIN
--       LOOP
--         Dbms_Lob.Read(v_blob, v_amt, v_off, v_raw);
--         
--         Htp.Prn(Utl_Raw.Cast_To_Varchar2(v_raw));
--         v_off := v_off + v_amt;
--         v_amt := 4096;
--       END LOOP;
--     EXCEPTION
--       WHEN NO_DATA_FOUND THEN 
--         NULL;
--     END;
  --
    Dbms_Lob.Read(v_blob, v_amt, v_off, v_raw);
--    po_image := v_blob;
    po_image := v_raw;
  --
  END get;
--
-----------------------------------------------------------------------------
--
  PROCEDURE get_img_tab
              ( pi_img_table     IN user_tables.table_name%TYPE
              , pi_img_column    IN user_tab_columns.column_name%TYPE
              , pi_img_uk_column IN user_tab_columns.column_name%TYPE
              , pi_img_uk_value  IN VARCHAR2
              , pi_img_type      IN VARCHAR2 DEFAULT 'bmp'
              , po_results       IN OUT tab_image_lr )
  IS
    l_tab_image tab_image_lr;
--    l_image     BLOB;
    l_image     LONG RAW;
  --
  BEGIN
  --
    get ( pi_img_table     => pi_img_table
        , pi_img_column    => pi_img_column
        , pi_img_uk_column => pi_img_uk_column
        , pi_img_uk_value  => pi_img_uk_value
        , pi_img_type      => pi_img_type
        , po_image         => l_image );
  --
    l_tab_image.DELETE;
    l_tab_image(1).pi_image :=   l_image;
    po_results              :=   l_tab_image;
  --
  END get_img_tab;
--
END nm3image;
