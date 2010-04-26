CREATE OR REPLACE PACKAGE BODY doc_locations_api
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/doc_locations_api.pkb-arc   2.1   Apr 26 2010 10:37:28   aedwards  $
--       Module Name      : $Workfile:   doc_locations_api.pkb  $
--       Date into PVCS   : $Date:   Apr 26 2010 10:37:28  $
--       Date fetched Out : $Modtime:   Apr 26 2010 10:36:52  $
--       Version          : $Revision:   2.1  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid CONSTANT VARCHAR2(2000) := '$Revision:   2.1  $';
--
  g_package_name CONSTANT varchar2(30) := 'doc_locations_api';
--
  --g_temp_load_table       VARCHAR2(30) := 'DOC_FILE_TRANSFER_TEMP';
--
  g_table_name      CONSTANT VARCHAR2(30)   := 'DOC_FILE_TRANSFER_TEMP';
  g_content_col     CONSTANT VARCHAR2(30)   := 'DFTT_CONTENT';
  g_doc_id_col      CONSTANT VARCHAR2(30)   := 'DFTT_DOC_ID';
  g_revision_col    CONSTANT VARCHAR2(30)   := 'DFTT_REVISION';
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
-----------------------------------------------------------------------------
--
FUNCTION get_temp_load_table RETURN varchar2 IS
BEGIN
   RETURN g_table_name;
END get_temp_load_table;
--
-----------------------------------------------------------------------------
--
PROCEDURE map_table_to_dlc ( pi_dlc_id     IN doc_locations.dlc_id%TYPE
                           , pi_table_name IN user_tables.table_name%TYPE
                           , pi_col_prefix IN VARCHAR2 );
--
-----------------------------------------------------------------------------
--
FUNCTION get_dlc ( pi_dlc_name IN doc_locations.dlc_name%TYPE )
  RETURN doc_locations%ROWTYPE
IS
  retval doc_locations%ROWTYPE;
BEGIN
  SELECT * INTO retval
    FROM doc_locations
   WHERE dlc_name = pi_dlc_name;
  RETURN retval;
EXCEPTION
  WHEN NO_DATA_FOUND
  THEN RETURN retval;
END get_dlc;
--
-----------------------------------------------------------------------------
--
FUNCTION get_dlc ( pi_dlc_id IN doc_locations.dlc_id%TYPE )
  RETURN doc_locations%ROWTYPE
IS
  retval doc_locations%ROWTYPE;
BEGIN
  SELECT * INTO retval
    FROM doc_locations
   WHERE dlc_id = pi_dlc_id;
  RETURN retval;
EXCEPTION
  WHEN NO_DATA_FOUND
  THEN RETURN retval;
END get_dlc;
--
-----------------------------------------------------------------------------
--
FUNCTION get_dlc ( pi_doc_id IN docs.doc_id%TYPE )
  RETURN doc_locations%ROWTYPE
IS
  retval doc_locations%ROWTYPE;
BEGIN
  SELECT * INTO retval
    FROM doc_locations
   WHERE dlc_id = (SELECT doc_dlc_id FROM docs WHERE doc_id = pi_doc_id);
  RETURN retval;
EXCEPTION
  WHEN NO_DATA_FOUND
  THEN RETURN retval;
END get_dlc;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_dlc_location ( pi_dlc_id             IN doc_locations.dlc_id%TYPE 
                           , po_dlc_location_type OUT doc_locations.dlc_location_type%TYPE
                           , po_dlc_location_name OUT doc_locations.dlc_location_name%TYPE)
IS
  l_rec_dlc doc_locations%ROWTYPE;
BEGIN
--
  l_rec_dlc := get_dlc ( pi_dlc_id => pi_dlc_id );
  po_dlc_location_type := l_rec_dlc.dlc_location_type;
  po_dlc_location_name := l_rec_dlc.dlc_location_name;
--
END get_dlc_location;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_dlc_location ( pi_dlc_name           IN doc_locations.dlc_name%TYPE 
                           , po_dlc_location_type OUT doc_locations.dlc_location_type%TYPE
                           , po_dlc_location_name OUT doc_locations.dlc_location_name%TYPE)
IS
  l_rec_dlc doc_locations%ROWTYPE;
BEGIN
--
  l_rec_dlc := get_dlc ( pi_dlc_name => pi_dlc_name );
  po_dlc_location_type := l_rec_dlc.dlc_location_type;
  po_dlc_location_name := l_rec_dlc.dlc_location_name;
--
END get_dlc_location;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_dlc_location ( pi_doc_id             IN docs.doc_id%TYPE 
                           , po_dlc_location_type OUT doc_locations.dlc_location_type%TYPE
                           , po_dlc_location_name OUT doc_locations.dlc_location_name%TYPE)
IS
  l_rec_dlc doc_locations%ROWTYPE;
  l_dlc_id  docs.doc_dlc_id%TYPE;
BEGIN
--
  SELECT doc_dlc_id INTO l_dlc_id
    FROM docs
   WHERE doc_id = pi_doc_id;
--  
  l_rec_dlc := get_dlc ( pi_dlc_id => l_dlc_id );
--
  po_dlc_location_type := l_rec_dlc.dlc_location_type;
  po_dlc_location_name := l_rec_dlc.dlc_location_name;
--
EXCEPTION
  WHEN NO_DATA_FOUND
  THEN
    RAISE_APPLICATION_ERROR (-20101,'Cannot find DOC ID '||pi_doc_id||' in DOCS table ');
END get_dlc_location;
--
-----------------------------------------------------------------------------
--
FUNCTION get_dlc_location ( pi_doc_id IN docs.doc_id%TYPE )
  RETURN VARCHAR2
IS
  location_type   doc_locations.dlc_location_type%TYPE;
BEGIN
--
  SELECT dlc_location_type
    INTO location_type
    FROM doc_locations
   WHERE dlc_id = (SELECT doc_dlc_id 
                     FROM docs
                    WHERE doc_id = pi_doc_id);
--
  RETURN location_type;
--
EXCEPTION
  WHEN NO_DATA_FOUND
  THEN
    RAISE_APPLICATION_ERROR (-20201,'Cannot find DOC_LOCATION for '||pi_doc_id);
--
END get_dlc_location;
--
-----------------------------------------------------------------------------
--
FUNCTION get_dlc_table ( pi_doc_id IN docs.doc_id%TYPE )
  RETURN VARCHAR2
IS
  retval          doc_location_tables.dlt_table%TYPE;
  location_type   doc_locations.dlc_location_type%TYPE;
BEGIN
--
  location_type := get_dlc_location ( pi_doc_id => pi_doc_id ); 
--
  SELECT ( CASE 
             WHEN location_type = 'TABLE'
             THEN
               ( SELECT dlt_table 
                   FROM doc_location_tables
                  WHERE dlt_dlc_id = (SELECT doc_dlc_id 
                                        FROM docs
                                       WHERE doc_id = pi_doc_id ))
             WHEN location_type IN ( 'ORACLE_DIRECTORY', 'URL' )
             THEN
               ( SELECT g_table_name FROM DUAL )
           END)
    INTO retval
    FROM DUAL;
--
  RETURN retval;
----
--EXCEPTION
--  WHEN NO_DATA_FOUND
--  THEN RETURN retval;
--
END get_dlc_table;
--
-----------------------------------------------------------------------------
--
FUNCTION get_dlt ( pi_doc_id             IN docs.doc_id%TYPE )
  RETURN doc_location_tables%ROWTYPE
IS
  retval doc_location_tables%ROWTYPE;
BEGIN
--
  SELECT * INTO retval
    FROM doc_location_tables
   WHERE dlt_dlc_id = (SELECT doc_dlc_id 
                         FROM docs
                        WHERE doc_id = pi_doc_id );
  RETURN retval;
--
EXCEPTION
  WHEN NO_DATA_FOUND
  THEN RETURN retval;
END get_dlt;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_dlc_table 
            ( pi_table_name IN user_tables.table_name%TYPE
            , pi_prefix     IN VARCHAR2
            , pi_tablespace IN user_tablespaces.tablespace_name%TYPE 
            , pi_drop_first IN BOOLEAN DEFAULT FALSE )
IS
  l_table_name           user_tables.table_name%TYPE             := pi_table_name;
  l_preffered_prefix     VARCHAR(30)                             := pi_prefix;
  l_tablespace           user_tablespaces.tablespace_name%TYPE   := pi_tablespace;
  l_drop_and_recreate    BOOLEAN                                 := pi_drop_first;
  nl                     VARCHAR2(10)                            := CHR(10);
  l_create_sql           nm3type.max_varchar2;
--
  FUNCTION does_tablespace_exist ( pi_tablespace IN user_tablespaces.tablespace_name%TYPE )
  RETURN BOOLEAN
  IS
    l_temp NUMBER;
  BEGIN
    SELECT 1 INTO l_temp FROM user_tablespaces 
     WHERE tablespace_name = pi_tablespace;
    RETURN TRUE;
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN RETURN FALSE;
  END does_tablespace_exist;
--
BEGIN
--
  IF LENGTH(l_preffered_prefix) > 15
  THEN
    RAISE_APPLICATION_ERROR (-20101,'Prefix is too long, please choose a shortened variation ( must be less than 15 characters ))');
  END IF;
--
  IF nm3ddl.does_object_exist(l_table_name)
  THEN
    IF NOT pi_drop_first
    THEN
      RAISE_APPLICATION_ERROR (-20102,l_table_name||' already exists  - please choose another name ');
    ELSE
      BEGIN
        nm3ddl.drop_synonym_for_object(l_table_name);
      EXCEPTION
        WHEN OTHERS THEN NULL;
      END;
      EXECUTE IMMEDIATE 'DROP TABLE '||l_table_name||' CASCADE CONSTRAINTS';
    END IF;
  END IF;
--
  IF pi_tablespace IS NOT NULL
  THEN
    IF NOT does_tablespace_exist (l_tablespace)
    THEN
      RAISE_APPLICATION_ERROR (-20103,l_tablespace||' does not exists  - please choose another');
    END IF;
  END IF;
--
--------------------
-- Build the table
--------------------
--
  l_create_sql :=
    'CREATE TABLE '||l_table_name||nl||
    ' ('||l_preffered_prefix||'_DOC_ID        NUMBER(38) NOT NULL '||nl||
    ' ,'||l_preffered_prefix||'_REVISION      NUMBER(38) NOT NULL '||nl||
    ' ,'||l_preffered_prefix||'_START_DATE    DATE       NOT NULL '||nl||
    ' ,'||l_preffered_prefix||'_END_DATE      DATE '||nl||
    ' ,'||l_preffered_prefix||'_FULL_PATH     VARCHAR2(4000) '||nl||
    ' ,'||l_preffered_prefix||'_FILENAME      VARCHAR2(4000) NOT NULL '||nl||
    ' ,'||l_preffered_prefix||'_CONTENT       BLOB '||nl||
    ' ,'||l_preffered_prefix||'_AUDIT         VARCHAR2(4000) '||nl||
    ' ,'||l_preffered_prefix||'_FILE_INFO     VARCHAR2(2000) '||nl||
    ' ,'||l_preffered_prefix||'_DATE_CREATED  DATE '||nl||
    ' ,'||l_preffered_prefix||'_DATE_MODIFIED DATE '||nl||
    ' ,'||l_preffered_prefix||'_CREATED_BY    VARCHAR2(30) '||nl||
    ' ,'||l_preffered_prefix||'_MODIFIED_BY   VARCHAR2(30)) '||nl||
    CASE WHEN l_tablespace IS NOT NULL
    THEN
      ' TABLESPACE '||l_tablespace
    END||
    '';
--
--  nm_debug.debug_on;
--  nm_debug.debug(l_create_sql);
--
  EXECUTE IMMEDIATE l_create_sql;
--
----------------
-- Build the PK
----------------
--
  l_create_sql := 
    'ALTER TABLE '||l_table_name||' ADD ( '||
    '  CONSTRAINT '||l_preffered_prefix||'_PK '||
    '  PRIMARY KEY '||
    ' ('||l_preffered_prefix||'_DOC_ID, '||l_preffered_prefix||'_REVISION))'
--    ||
--    CASE WHEN l_tablespace IS NOT NULL
--    THEN
--      ' TABLESPACE '||l_tablespace
--    END
    ;
--
  EXECUTE IMMEDIATE l_create_sql;
--
----------------
-- Build the FK
----------------
--
  l_create_sql :=
    'ALTER TABLE '||l_table_name||' ADD (
       CONSTRAINT '||l_preffered_prefix||'_DOC_FK 
      FOREIGN KEY ('||l_preffered_prefix||'_DOC_ID) 
      REFERENCES DOCS (DOC_ID))'
--      ||
--    CASE WHEN l_tablespace IS NOT NULL
--    THEN
--      ' TABLESPACE '||l_tablespace
--    END
    ;
--
  EXECUTE IMMEDIATE l_create_sql;
--
--------------------------
-- Build the WHO Triggers
--------------------------
--
--
  DECLARE
  --
     TYPE tab_comments IS TABLE of VARCHAR2(250) INDEX BY BINARY_INTEGER;
     l_tab_comments tab_comments;
  --
     CURSOR cs_cols (p_table_name VARCHAR2, p_type VARCHAR2) IS
     SELECT column_name
           ,DECODE(data_type
                  ,'DATE','sysdate'
                  ,'VARCHAR2','user'
                  ,'null'
                  ) new_value
       from user_tab_columns
     where  table_name = p_table_name
      AND  (column_name    like '%'||p_type||'_BY'
            or column_name like '%DATE_'||p_type)
      order by column_id;
  --
     l_trigger_name VARCHAR2(30);
  --
     l_sql VARCHAR2(32767);
  --
  BEGIN
  --
  --  Stick the SCCS delta comments all into an array so that we can output this
  --   as a comment within the trigger itself
     l_tab_comments(1)  := '--';
     l_tab_comments(2)  := '--   SCCS Identifiers :-';
     l_tab_comments(3)  := '--';
     l_tab_comments(4)  := '--       pvcsid                     : $Header:   //vm_latest/archives/nm3/admin/pck/doc_locations_api.pkb-arc   2.1   Apr 26 2010 10:37:28   aedwards  $';
     l_tab_comments(5)  := '--       Module Name                : $Workfile:   doc_locations_api.pkb  $';
     l_tab_comments(6)  := '--       Date into PVCS             : $Date:   Apr 26 2010 10:37:28  $';
     l_tab_comments(7)  := '--       Date fetched Out           : $Modtime:   Apr 26 2010 10:36:52  $';
     l_tab_comments(8)  := '--       PVCS Version               : $Revision:   2.1  $';
     l_tab_comments(9)  := '--';
     l_tab_comments(10) := '--   table_name_WHO trigger';
     l_tab_comments(11) := '--';
     l_tab_comments(12) := '-----------------------------------------------------------------------------';
     l_tab_comments(13) := '--    Copyright (c) exor corporation ltd, 2007';
     l_tab_comments(14) := '-----------------------------------------------------------------------------';
     l_tab_comments(15) := '--';
  --
     dbms_output.put_line('Started WHO trigger creation');
  --
     FOR cs_rec IN (SELECT utc.table_name
                          ,max(length(utc.column_name)) max_col_name_length
                     FROM  user_tab_columns utc
                          ,user_objects     ut
                    where  utc.table_name  = ut.object_name
                      AND  ut.object_type  = 'TABLE'
                      AND  ut.temporary    = 'N'
                      AND (utc.column_name    like '%CREATED_BY'
                           or utc.column_name like '%MODIFIED_BY'
                           or utc.column_name like '%DATE_CREATED'
                           or utc.column_name like '%DATE_MODIFIED'
                          )
                      AND ut.object_name = l_table_name
                    GROUP BY utc.TABLE_NAME
                    HAVING COUNT(*) = 4
                   )
      LOOP
  --
        l_trigger_name := LOWER(SUBSTR(cs_rec.table_name,1,26)||'_who');
  --
        l_sql := 'CREATE OR REPLACE TRIGGER '||l_trigger_name;
        l_sql := l_sql||CHR(10)||' BEFORE insert OR update';
        l_sql := l_sql||CHR(10)||' ON '||cs_rec.table_name;
        l_sql := l_sql||CHR(10)||' FOR each row';
        l_sql := l_sql||CHR(10)||'DECLARE';
        --
        FOR l_count IN 1..l_tab_comments.COUNT
         LOOP
           l_sql := l_sql||CHR(10)||l_tab_comments(l_count);
        END LOOP;
        --
        l_sql := l_sql||CHR(10)||'   l_sysdate DATE;';
        l_sql := l_sql||CHR(10)||'   l_user    VARCHAR2(30);';
        l_sql := l_sql||CHR(10)||'BEGIN';
        l_sql := l_sql||CHR(10)||'--';
        l_sql := l_sql||CHR(10)||'-- Generated '||to_char(sysdate,'HH24:MI:SS DD-MON-YYYY');
        l_sql := l_sql||CHR(10)||'--';
        l_sql := l_sql||CHR(10)||'   SELECT sysdate';
        l_sql := l_sql||CHR(10)||'         ,user';
        l_sql := l_sql||CHR(10)||'    INTO  l_sysdate';
        l_sql := l_sql||CHR(10)||'         ,l_user';
        l_sql := l_sql||CHR(10)||'    FROM  dual;';
        l_sql := l_sql||CHR(10)||'--';
        l_sql := l_sql||CHR(10)||'   IF inserting';
        l_sql := l_sql||CHR(10)||'    THEN';
  --
        FOR cs_inner_rec IN cs_cols(cs_rec.table_name,'CREATED')
         LOOP
           l_sql := l_sql||CHR(10)||'      :new.'||RPAD(cs_inner_rec.column_name,cs_rec.max_col_name_length,' ')||' := l_'||cs_inner_rec.new_value||';';
        END LOOP;
  --
        l_sql := l_sql||CHR(10)||'   END IF;';
        l_sql := l_sql||CHR(10)||'--';
  --
        FOR cs_inner_rec IN cs_cols(cs_rec.table_name,'MODIFIED')
         LOOP
           l_sql := l_sql||CHR(10)||'   :new.'||RPAD(cs_inner_rec.column_name,cs_rec.max_col_name_length,' ')||' := l_'||cs_inner_rec.new_value||';';
        END LOOP;
  --
        l_sql := l_sql||CHR(10)||'--';
  --
        l_sql := l_sql||CHR(10)||'END '||l_trigger_name||';';
  --
        execute immediate l_sql;
  --
        l_sql := 'ALTER TRIGGER '||l_trigger_name||' COMPILE';
  --
        execute immediate l_sql;
  --
        dbms_output.put_line('Created trigger '||l_trigger_name);
  --
     END LOOP;
  --
     dbms_output.put_line('Finished WHO trigger creation');
  --
  END;
--
  nm_debug.debug('Finished');
--
END create_dlc_table;
--
------------------------------------------------------------------------------
--
PROCEDURE validate_table ( pi_table_name IN user_tables.table_name%TYPE 
                         , po_col_prefix OUT VARCHAR2 )
IS
--
  l_col_prefix VARCHAR2(30);
--
  FUNCTION check_total_columns RETURN NUMBER
  IS
    retval NUMBER;
  BEGIN
    SELECT COUNT(*) INTO retval FROM user_tab_columns
     WHERE table_name  = pi_table_name
       AND 
         (  column_name LIKE '%_DOC_ID'
         OR column_name LIKE '%_REVISION'
         OR column_name LIKE '%_START_DATE'
         OR column_name LIKE '%_END_DATE'
         OR column_name LIKE '%_FULL_PATH'
         OR column_name LIKE '%_FILENAME'
         OR column_name LIKE '%_CONTENT'
         OR column_name LIKE '%_CONTENT'
         OR column_name LIKE '%_AUDIT'
         OR column_name LIKE '%_FILE_INFO'
         OR column_name LIKE '%_DATE_CREATED'
         OR column_name LIKE '%_DATE_MODIFIED'
         OR column_name LIKE '%_CREATED_BY'
         OR column_name LIKE '%_MODIFIED_BY'
         );
    RETURN retval;
    -- 13 columns
  END check_total_columns;
--
  FUNCTION check_for_prefix RETURN VARCHAR2
  IS
    retval VARCHAR2(30);
  BEGIN
    SELECT UNIQUE SUBSTR(column_name,0,(instr(column_name,'_',1)-1)) INTO retval FROM user_tab_columns
     WHERE table_name  = pi_table_name
       AND 
         (  column_name LIKE '%_DOC_ID'
         OR column_name LIKE '%_REVISION'
         OR column_name LIKE '%_START_DATE'
         OR column_name LIKE '%_END_DATE'
         OR column_name LIKE '%_FULL_PATH'
         OR column_name LIKE '%_FILENAME'
         OR column_name LIKE '%_CONTENT'
         OR column_name LIKE '%_CONTENT'
         OR column_name LIKE '%_AUDIT'
         OR column_name LIKE '%_FILE_INFO'
         OR column_name LIKE '%_DATE_CREATED'
         OR column_name LIKE '%_DATE_MODIFIED'
         OR column_name LIKE '%_CREATED_BY'
         OR column_name LIKE '%_MODIFIED_BY'
         );
    RETURN retval;
    -- 1 result
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN RETURN '-1';
    WHEN TOO_MANY_ROWS
    THEN RETURN '-2';
  END check_for_prefix;
--
  FUNCTION check_pk_columns RETURN NUMBER
  IS
    retval NUMBER;
  BEGIN
    SELECT COUNT (*) INTO retval FROM user_tab_columns
     WHERE table_name  = pi_table_name
       AND 
         (  column_name LIKE '%_DOC_ID'
         OR column_name LIKE '%_REVISION'
         )
       AND data_type = 'NUMBER'
       AND nullable  = 'N';
    RETURN retval;
    -- 2 columns
    --
  END check_pk_columns;
--
  FUNCTION check_blob_column RETURN NUMBER
  IS
    retval NUMBER;
  BEGIN
    SELECT COUNT (*) INTO retval FROM user_tab_columns
     WHERE table_name  = pi_table_name
       AND 
         (  column_name LIKE '%_CONTENT'
         )
       AND data_type = 'BLOB'
       AND nullable  = 'Y';
    RETURN retval;
    -- 1 column
    --
  END check_blob_column;
--
BEGIN
  IF check_total_columns != 13
  THEN
    RAISE_APPLICATION_ERROR (-20201,'Invalid number of columns on table '||pi_table_name);
  END IF;
--
  l_col_prefix := check_for_prefix;
--
  IF l_col_prefix = '-1'
  THEN
    RAISE_APPLICATION_ERROR (-20202,'Cannot find a consistent column prefix on table '||pi_table_name);
  ELSIF l_col_prefix = '-2'
  THEN
    RAISE_APPLICATION_ERROR (-20203,'Cannot find a unique column prefix on table '||pi_table_name);
  ELSE
    po_col_prefix := l_col_prefix;
  END IF;
--
  IF check_pk_columns != 2
  THEN
    RAISE_APPLICATION_ERROR (-20204,'Nullable or invalid number of columns required for PK on table '||pi_table_name);
  END IF;
--
  IF check_blob_column != 1
  THEN
    RAISE_APPLICATION_ERROR (-20205,'Not nullable or missing BLOB column on table '||pi_table_name);
  END IF;
--
END validate_table;
--
------------------------------------------------------------------------------
--
PROCEDURE check_dlc_id ( pi_dlc_id   IN doc_locations.dlc_id%TYPE 
                       , po_dlc_rec OUT doc_locations%ROWTYPE)
IS
  l_temp doc_locations%ROWTYPE;
BEGIN
  SELECT * INTO l_temp FROM doc_locations
   WHERE dlc_id = pi_dlc_id;
  po_dlc_rec := l_temp;
EXCEPTION
  WHEN NO_DATA_FOUND
  THEN
    RAISE_APPLICATION_ERROR (-20301,'Invalid DOC_LOCATIONS.DLC_ID value ['||pi_dlc_id||']');
END check_dlc_id;
--
------------------------------------------------------------------------------
--
PROCEDURE map_table_to_dlc ( pi_dlc_id     IN doc_locations.dlc_id%TYPE
                           , pi_table_name IN user_tables.table_name%TYPE
                           , pi_col_prefix IN VARCHAR2 ) 
IS
  
BEGIN
--
  INSERT INTO doc_location_tables
        ( dlt_id, dlt_dlc_id, dlt_table, dlt_doc_id_col, dlt_revision_col
        , dlt_content_col, dlt_start_date_col, dlt_end_date_col
        , dlt_full_path_col, dlt_filename, dlt_audit_col, dlt_file_info_col)
  SELECT nm3ddl.sequence_nextval('dlt_id_seq')   dlt_id
       , pi_dlc_id                               dlt_dlc_id
       , pi_table_name                           dlt_table
       , pi_col_prefix||'_DOC_ID'                dlt_doc_id_col
       , pi_col_prefix||'_REVISION'              dlt_revision_col
       , pi_col_prefix||'_CONTENT'               dlt_content_col
       , pi_col_prefix||'_START_DATE'            dlt_start_date_col
       , pi_col_prefix||'_END_DATE'              dlt_end_date_col
       , pi_col_prefix||'_FULL_PATH'             dlt_full_path_col
       , pi_col_prefix||'_FILENAME'              dlt_filename
       , pi_col_prefix||'_AUDIT'                 dlt_audit_col
       , pi_col_prefix||'_FILE_INFO'             dlt_file_info_col
       , NULL, NULL, NULL, NULL
    FROM DUAL;
--
END map_table_to_dlc;
--
------------------------------------------------------------------------------
--
PROCEDURE check_dlct
            ( pi_dlc_id     IN doc_location_tables.dlt_dlc_id%TYPE 
            , pi_table_name IN VARCHAR2 )
IS
  l_temp NUMBER;
BEGIN
  SELECT 1 INTO l_temp FROM doc_location_tables
   WHERE dlt_dlc_id = pi_dlc_id
     AND dlt_table = pi_table_name;
  RAISE_APPLICATION_ERROR(-20502,'Location and table combination already exists (doc_location_tables)');
EXCEPTION
  WHEN NO_DATA_FOUND
  THEN
    RETURN;
  WHEN TOO_MANY_ROWS
  THEN
    RAISE_APPLICATION_ERROR(-20501,'More than one location and table combination exists (doc_location_tables)');
END check_dlct;
--
------------------------------------------------------------------------------
--
PROCEDURE map_table_to_doc_location ( pi_dlc_id     IN doc_locations.dlc_id%TYPE
                                    , pi_table_name IN user_tables.table_name%TYPE 
                                    , pi_prefix     IN VARCHAR2 DEFAULT NULL
                                    , pi_tablespace IN user_tablespaces.tablespace_name%TYPE DEFAULT NULL
                                    , pi_drop_first IN BOOLEAN DEFAULT FALSE )
IS
  l_rec_dlc      doc_locations%ROWTYPE;
  l_col_prefix   VARCHAR2(30);
--
  FUNCTION get_prefix RETURN VARCHAR2 IS
    retval VARCHAR2(30);
  BEGIN
    SELECT UNIQUE SUBSTR(column_name,0,(instr(column_name,'_',1)-1)) INTO retval FROM user_tab_columns
     WHERE table_name  = pi_table_name
       AND 
         (  column_name LIKE '%_DOC_ID'
         OR column_name LIKE '%_REVISION'
         OR column_name LIKE '%_START_DATE'
         OR column_name LIKE '%_END_DATE'
         OR column_name LIKE '%_FULL_PATH'
         OR column_name LIKE '%_FILENAME'
         OR column_name LIKE '%_CONTENT'
         OR column_name LIKE '%_CONTENT'
         OR column_name LIKE '%_AUDIT'
         OR column_name LIKE '%_FILE_INFO'
         OR column_name LIKE '%_DATE_CREATED'
         OR column_name LIKE '%_DATE_MODIFIED'
         OR column_name LIKE '%_CREATED_BY'
         OR column_name LIKE '%_MODIFIED_BY'
         );
    RETURN retval;
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN RAISE_APPLICATION_ERROR (-20401,'Cannot derive a column prefix from table '||pi_table_name);
    WHEN TOO_MANY_ROWS
    THEN RAISE_APPLICATION_ERROR (-20402,'Cannot derive a unique column prefix from table '||pi_table_name);
  END get_prefix;
--
BEGIN
--
  check_dlc_id 
    ( pi_dlc_id  => pi_dlc_id 
    , po_dlc_rec => l_rec_dlc );
--
  check_dlct
    ( pi_dlc_id     => pi_dlc_id
    , pi_table_name => pi_table_name );
--
  IF (( nm3ddl.does_object_exist( pi_table_name, 'TABLE' ) AND pi_drop_first )
   OR ( NOT nm3ddl.does_object_exist( pi_table_name, 'TABLE' ) ))
  THEN
    create_dlc_table 
              ( pi_table_name => pi_table_name
              --, pi_prefix     => NVL (pi_prefix, get_prefix )
              , pi_prefix     => pi_prefix
              , pi_tablespace => pi_tablespace
              , pi_drop_first => pi_drop_first );
  END IF;
--
  validate_table 
    ( pi_table_name => pi_table_name 
    , po_col_prefix => l_col_prefix );
--
  map_table_to_dlc 
    ( pi_dlc_id     => pi_dlc_id
    , pi_table_name => pi_table_name
    , pi_col_prefix => l_col_prefix ) ;
--
END map_table_to_doc_location;
--
------------------------------------------------------------------------------
--
END doc_locations_api;
/

