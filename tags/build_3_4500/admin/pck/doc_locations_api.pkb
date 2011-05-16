CREATE OR REPLACE PACKAGE BODY doc_locations_api
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/doc_locations_api.pkb-arc   2.10   May 16 2011 14:41:32   Steve.Cooper  $
--       Module Name      : $Workfile:   doc_locations_api.pkb  $
--       Date into PVCS   : $Date:   May 16 2011 14:41:32  $
--       Date fetched Out : $Modtime:   Apr 01 2011 10:37:02  $
--       Version          : $Revision:   2.10  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid CONSTANT VARCHAR2(2000) := '$Revision:   2.10  $';
--
  g_package_name CONSTANT varchar2(30) := 'doc_locations_api';
--
  --g_temp_load_table       VARCHAR2(30) := 'DOC_FILE_TRANSFER_TEMP';
--
  g_table_name      CONSTANT VARCHAR2(30)   := 'DOC_FILE_TRANSFER_TEMP';
  g_content_col     CONSTANT VARCHAR2(30)   := 'DFTT_CONTENT';
  g_doc_id_col      CONSTANT VARCHAR2(30)   := 'DFTT_DOC_ID';
  g_revision_col    CONSTANT VARCHAR2(30)   := 'DFTT_REVISION';
  g_forward_slash   CONSTANT VARCHAR2(1)    := CHR(47);
  g_back_slash      CONSTANT VARCHAR2(1)    := CHR(92);
  g_sep                      VARCHAR2(1)    := NVL(hig.get_sysopt('DIRREPSTRN'),g_back_slash);
  g_win_sep                  VARCHAR2(1)    := g_back_slash;
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
PROCEDURE get_dlc_location ( pi_doc_id             IN docs.doc_id%TYPE
                           , po_name              OUT doc_locations.dlc_name%TYPE
                           , po_location          OUT doc_locations.dlc_location_name%TYPE
                           , po_meaning           OUT doc_locations.dlc_location_name%TYPE )
IS
BEGIN
  SELECT dlc_name
       , hco_meaning
       , CASE
           WHEN dlc_location_type = 'TABLE'
           THEN
             ( SELECT dlt_content_col
                 FROM doc_location_tables
                WHERE dlt_dlc_id = dlc_id )
           WHEN dlc_location_type = 'ORACLE_DIRECTORY'
           THEN
             ( SELECT directory_path
                 FROM all_directories
                WHERE directory_name = dlc_location_name )
           WHEN dlc_location_type = 'DB_SERVER'
           THEN
             dlc_location_name
           WHEN dlc_location_type = 'APP_SERVER'
           THEN
             dlc_location_name
         END 
    INTO po_name, po_location, po_meaning
    FROM doc_locations, hig_codes
   WHERE dlc_id = (SELECT doc_dlc_id FROM docs
                    WHERE doc_id = pi_doc_id )
     AND dlc_location_type = hco_code
     AND hco_domain = 'DOC_LOCATION_TYPES';
EXCEPTION
  WHEN NO_DATA_FOUND
  THEN
    po_name := NULL;
    po_location := NULL;
    po_meaning := NULL;
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
             ELSE --WHEN location_type IN ( 'ORACLE_DIRECTORY', 'DB_SERVER' )
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
FUNCTION get_dlt ( pi_dlc_id             IN doc_locations.dlc_id%TYPE )
  RETURN doc_location_tables%ROWTYPE
IS
  retval doc_location_tables%ROWTYPE;
BEGIN
--
  SELECT * INTO retval
    FROM doc_location_tables
   WHERE dlt_dlc_id =  pi_dlc_id ;
  RETURN retval;
--
EXCEPTION
  WHEN NO_DATA_FOUND
  THEN RETURN retval;
END get_dlt;
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
     l_tab_comments(4)  := '--       pvcsid                     : $Header:   //vm_latest/archives/nm3/admin/pck/doc_locations_api.pkb-arc   2.10   May 16 2011 14:41:32   Steve.Cooper  $';
     l_tab_comments(5)  := '--       Module Name                : $Workfile:   doc_locations_api.pkb  $';
     l_tab_comments(6)  := '--       Date into PVCS             : $Date:   May 16 2011 14:41:32  $';
     l_tab_comments(7)  := '--       Date fetched Out           : $Modtime:   Apr 01 2011 10:37:02  $';
     l_tab_comments(8)  := '--       PVCS Version               : $Revision:   2.10  $';
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
  nm3ddl.create_synonym_for_object(p_object_name=>l_table_name);
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
--
  DELETE doc_location_tables
   WHERE dlt_dlc_id = pi_dlc_id;
--
  INSERT INTO doc_location_tables
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
FUNCTION get_location_type_lov_sql 
RETURN VARCHAR2
IS
BEGIN
  RETURN 'select hco_code location_type, hco_meaning description'||
          ' from hig_codes '||
          'where hco_domain = ''DOC_LOCATION_TYPES'''||
         ' order by hco_seq';
END get_location_type_lov_sql;
--
------------------------------------------------------------------------------
--
FUNCTION get_location_descr (pi_location_type IN doc_locations.dlc_location_type%TYPE)
  RETURN VARCHAR2
IS
  retval nm3type.max_varchar2;
BEGIN
--
  SELECT hco_meaning INTO retval
    FROM hig_codes
   WHERE hco_domain = 'DOC_LOCATION_TYPES'
     AND hco_code = pi_location_type;
  RETURN retval;
EXCEPTION
  WHEN NO_DATA_FOUND THEN RETURN NULL;
--
END get_location_descr;
--
--------------------------------------------------------------------------------
-- Return just the filename portion of the full path and filename
--
  FUNCTION strip_filename ( pi_full_path_and_file IN VARCHAR2 )
  RETURN VARCHAR2
  IS
    retval nm3type.max_varchar2;
  BEGIN
    retval := SUBSTR(pi_full_path_and_file
             ,INSTR(pi_full_path_and_file,g_sep,-1)+1);
    retval := SUBSTR(retval
             ,INSTR(retval,g_win_sep,-1)+1);
    RETURN retval ;
  END strip_filename;
--
--------------------------------------------------------------------------------
--
  PROCEDURE insert_temp_file_record ( pi_rec_df IN doc_file_transfer_temp%ROWTYPE )
  IS
    l_rec_table   doc_file_transfer_temp%ROWTYPE;
  BEGIN
  --
    l_rec_table.dftt_doc_id          := pi_rec_df.dftt_doc_id;
    l_rec_table.dftt_revision        := NVL(pi_rec_df.dftt_revision,1);
    l_rec_table.dftt_start_date      := NVL(pi_rec_df.dftt_start_date,To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY'));
    l_rec_table.dftt_content         := pi_rec_df.dftt_content;
    l_rec_table.dftt_full_path       := pi_rec_df.dftt_full_path;
    l_rec_table.dftt_filename        := strip_filename(pi_rec_df.dftt_full_path);
    l_rec_table.dftt_file_info       := NVL(pi_rec_df.dftt_file_info, LENGTH(pi_rec_df.dftt_content));
  -- 
    INSERT INTO doc_file_transfer_temp VALUES l_rec_table;
  --
  END insert_temp_file_record;
--
--------------------------------------------------------------------------------
-- Insert a row in doc_files_all
--
  PROCEDURE insert_file_record ( pi_rec_df IN rec_file_record )
  IS
    l_rec_table       rec_file_record;
    l_rec_dlt         doc_location_tables%ROWTYPE;
    l_rec_temp_table  doc_file_transfer_temp%ROWTYPE;
  BEGIN
  --
    l_rec_dlt := doc_locations_api.get_dlt(pi_doc_id => pi_rec_df.doc_id );
  --
    nm_debug.debug_on;
    nm_debug.debug('Inserting '||l_rec_table.full_path||' in '||l_rec_dlt.dlt_table);
  --
    l_rec_table.doc_id          := pi_rec_df.doc_id;
    l_rec_table.revision        := NVL(pi_rec_df.revision,1);
    l_rec_table.start_date      := NVL(pi_rec_df.start_date,To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY'));
    l_rec_table.content         := pi_rec_df.content;
    l_rec_table.full_path       := pi_rec_df.full_path;
    l_rec_table.filename        := NVL(pi_rec_df.filename, strip_filename(pi_rec_df.full_path));
    l_rec_table.file_info       := NVL(pi_rec_df.file_info, LENGTH(pi_rec_df.content));
  -- 
    IF l_rec_dlt.dlt_table IS NOT NULL
    THEN
      EXECUTE IMMEDIATE
        'INSERT INTO '||l_rec_dlt.dlt_table
      ||' ('
      ||'   '||l_rec_dlt.dlt_doc_id_col
      ||' , '||l_rec_dlt.dlt_revision_col
      ||' , '||l_rec_dlt.dlt_start_date_col
      ||' , '||l_rec_dlt.dlt_full_path_col
      ||' , '||l_rec_dlt.dlt_filename
      ||' , '||l_rec_dlt.dlt_content_col
      ||' , '||l_rec_dlt.dlt_audit_col
      ||' , '||l_rec_dlt.dlt_file_info_col
      ||' )'
      ||' VALUES '
      ||' ('
      ||'   :pi_doc_id '
      ||' , :pi_revision '
      ||' , :pi_start_date '
      ||' , :pi_full_path '
      ||' , :pi_filename '
      ||' , :pi_content '
      ||' , :pi_audit '
      ||' , :pi_file_info )'
      USING IN l_rec_table.doc_id
          , IN l_rec_table.revision
          , IN l_rec_table.start_date
          , IN l_rec_table.full_path
          , IN l_rec_table.filename
          , IN l_rec_table.content
          , IN l_rec_table.audit
          , IN l_rec_table.file_info;
  --
    ELSIF doc_locations_api.get_dlc(pi_doc_id => pi_rec_df.doc_id).dlc_location_Type IN ('ORACLE_DIRECTORY','DB_SERVER')
    THEN
      l_rec_temp_table.dftt_doc_id     := l_rec_table.doc_id;
      l_rec_temp_table.dftt_revision   := l_rec_table.revision;
      l_rec_temp_table.dftt_start_date := l_rec_table.start_date;
      l_rec_temp_table.dftt_content    := l_rec_table.content;
      l_rec_temp_table.dftt_full_path  := l_rec_table.full_path;
      l_rec_temp_table.dftt_filename   := l_rec_table.filename;
      l_rec_temp_table.dftt_file_info  := l_rec_table.file_info;
    -- 
      insert_temp_file_record ( pi_rec_df => l_rec_temp_table );
    -- 
    END IF;
  --
  END insert_file_record;
--
------------------------------------------------------------------------------
--
--
  FUNCTION get_file_record
                  ( pi_doc_id   IN docs.doc_id%TYPE
                  , pi_revision IN NUMBER )
  RETURN rec_file_record
  IS
    l_rec_table rec_file_record;
    l_rec_dlt   doc_location_tables%ROWTYPE;
--    doc_id        NUMBER 
--  , revision      NUMBER
--  , start_date    DATE
--  , end_date      DATE
--  , full_path     VARCHAR2(4000)
--  , filename      VARCHAR2(4000)
--  , content       BLOB
--  , audit         VARCHAR2(4000)
--  , file_info     VARCHAR2(2000)
  BEGIN
  --
    l_rec_dlt := doc_locations_api.get_dlt(pi_doc_id => pi_doc_id );
  --
    IF l_rec_dlt.dlt_table IS NOT NULL
    THEN
      EXECUTE IMMEDIATE 
        ' SELECT '||l_rec_dlt.dlt_doc_id_col||' ,'||
                    l_rec_dlt.dlt_revision_col||' ,'||
                    l_rec_dlt.dlt_start_date_col||' ,'||
                    l_rec_dlt.dlt_end_date_col||' ,'||
                    l_rec_dlt.dlt_full_path_col||' ,'||
                    l_rec_dlt.dlt_filename||' ,'||
                    l_rec_dlt.dlt_content_col||' ,'||
                    l_rec_dlt.dlt_audit_col||' ,'||
                    l_rec_dlt.dlt_file_info_col||
        '   FROM '||l_rec_dlt.dlt_table||
        '  WHERE '||l_rec_dlt.dlt_doc_id_col||' = :pi_df_doc_id '||
        '    AND '||l_rec_dlt.dlt_revision_col||' = :pi_df_revision'
      INTO l_rec_table
      USING IN pi_doc_id, IN pi_revision;
    END IF;
  --
    RETURN l_rec_table;
  --
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN RETURN l_rec_table;
  --
  END get_file_record;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_archive ( pi_dlc_id IN doc_locations.dlc_id%TYPE ) 
    RETURN doc_location_archives%ROWTYPE
  IS
    retval doc_location_archives%ROWTYPE;
  BEGIN
  --
    SELECT * INTO retval
      FROM doc_location_archives
     WHERE dla_dlc_id = pi_dlc_id;
    RETURN retval;
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN RETURN retval;
  --
  END get_archive;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_archive ( pi_doc_id IN docs.doc_id%TYPE ) 
    RETURN doc_location_archives%ROWTYPE
  IS
    retval doc_location_archives%ROWTYPE;
  BEGIN
    SELECT * INTO retval
      FROM doc_location_archives
     WHERE dla_dlc_id = ( SELECT doc_dlc_id FROM docs 
                           WHERE doc_id = pi_doc_id );
    RETURN retval;
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN RETURN retval;
  END get_archive;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_archives ( pi_dlc_id IN doc_locations.dlc_id%TYPE ) 
    RETURN g_tab_dla
  IS
    retval g_tab_dla;
  BEGIN
  --
    SELECT * BULK COLLECT INTO retval
      FROM doc_location_archives
     WHERE dla_dlc_id = pi_dlc_id;
    RETURN retval;
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN RETURN retval;
  --
  END get_archives;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_archives ( pi_doc_id IN docs.doc_id%TYPE ) 
    RETURN g_tab_dla
  IS
    retval g_tab_dla;
  BEGIN
    SELECT * BULK COLLECT INTO retval
      FROM doc_location_archives
     WHERE dla_dlc_id = ( SELECT doc_dlc_id FROM docs 
                           WHERE doc_id = pi_doc_id );
    RETURN retval;
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN RETURN retval;
  END get_archives;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_table_prefix RETURN VARCHAR2
  IS
    retval nm3type.max_varchar2;
  BEGIN
    RETURN retval;
  END get_table_prefix;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_default_tablespace RETURN user_tablespaces.tablespace_name%TYPE
  IS
    retval user_tablespaces.tablespace_name%TYPE;
  BEGIN
    SELECT default_tablespace INTO retval FROM user_users
     WHERE username = USER;
    RETURN retval;
  END get_default_tablespace;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_doc_path ( pi_dlc_id            IN doc_locations.dlc_id%TYPE 
                        , pi_include_end_slash IN BOOLEAN DEFAULT FALSE)
    RETURN doc_locations.dlc_location_name%TYPE
  IS
    l_path        doc_locations.dlc_location_name%TYPE;
    retval        doc_locations.dlc_location_name%TYPE;
    l_terminator  VARCHAR2(1);
  BEGIN
  --
    l_path := nm3file.get_path(get_dlc ( pi_dlc_id => pi_dlc_id ).dlc_location_name);
  --
    IF pi_include_end_slash 
    AND SUBSTR ( l_path, LENGTH (l_path),1 ) NOT IN (g_forward_slash,g_back_slash)
    THEN
    --
      IF INSTR(l_path,g_back_slash) > 0
        THEN l_terminator := g_back_slash;
      ELSIF INSTR(l_path,g_forward_slash) > 0
        THEN l_terminator := g_forward_slash;
      END IF;
      retval := l_path||l_terminator;
    --
    ELSE
    --
      retval := l_path;
    END IF;
  --
    RETURN retval;
  --
  END get_doc_path;
--
--
-----------------------------------------------------------------------------
--
  FUNCTION get_doc_url  ( pi_dlc_id            IN doc_locations.dlc_id%TYPE )
    RETURN doc_locations.dlc_location_name%TYPE
  IS
    l_dir_url hig_directories.hdir_url%TYPE;
  BEGIN
  --
--    RETURN NVL(hig_directories_api.get(pi_hdir_name       => get_dlc(pi_dlc_id=>pi_dlc_id).dlc_location_name
--                                      ,pi_raise_not_found => FALSE ).hdir_url
--              ,get_dlc(pi_dlc_id=>pi_dlc_id).dlc_url_pathname) ;
    RETURN NVL(get_dlc(pi_dlc_id=>pi_dlc_id).dlc_url_pathname
              ,hig_directories_api.get(pi_hdir_name       => get_dlc(pi_dlc_id=>pi_dlc_id).dlc_location_name
                                      ,pi_raise_not_found => FALSE ).hdir_url) ;
  --
  END get_doc_url;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_doc_url  ( pi_doc_id            IN docs.doc_id%TYPE )
    RETURN doc_locations.dlc_location_name%TYPE
  IS
    l_dir_url      hig_directories.hdir_url%TYPE;
    l_url          doc_locations.dlc_pathname%TYPE;
    l_dlc          doc_locations%ROWTYPE;
    l_dmd          doc_media%ROWTYPE;
    l_docs         docs%ROWTYPE;
  -- doc
  BEGIN
  --
    BEGIN
       l_docs := nm3get.get_doc(pi_doc_id  => pi_doc_id);
    EXCEPTION
       WHEN others THEN
       RETURN(Null);
    END;
  --
    IF l_docs.doc_dlc_id IS NOT NULL
    THEN
      BEGIN
        l_dlc := get_dlc(pi_dlc_id => l_docs.doc_dlc_id);
      EXCEPTION
        WHEN OTHERS THEN
          RETURN NULL;
      END;
    END IF;
  --
    IF l_docs.doc_dlc_dmd_id IS NOT NULL
    THEN
       BEGIN
         l_dmd := nm3get.get_dmd(pi_dmd_id => l_docs.doc_dlc_dmd_id);
       EXCEPTION
         WHEN others
      THEN
        RETURN(Null);
       END;
    END IF;
  --
  -- Task 0110109
  -- Get a table-based document URL via a DAD URL
  --
    IF doc_locations_api.get_dlc(pi_dlc_id=>l_docs.doc_dlc_id).dlc_location_type != 'TABLE'
    THEN
    -- Use the URL if set on the Doc Locaton record
    --
      l_url := NVL(get_dlc(pi_dlc_id=>l_docs.doc_dlc_id).dlc_url_pathname
                  ,hig_directories_api.get( pi_hdir_name      => get_dlc (pi_dlc_id=>l_docs.doc_dlc_id).dlc_location_name
                                           ,pi_raise_not_found => FALSE ).hdir_url);
      IF l_url IS NOT NULL
      THEN
      
      --
      -- Task 0110777 / 0110776
      -- Don't do this any more because some customers want a null slash - so assume the doc_location URL has it set.
      --
--      --
--      -- Append the trailing forward slash if not present
--      --
--        IF SUBSTR ( l_url, LENGTH (l_url),1 ) NOT IN (g_forward_slash,g_back_slash)
--        THEN
--          l_url := l_url||g_forward_slash;
--        END IF;
      --
      -- Task 0110777 / 0110776 DONE
      --
    --
      --
        l_url := l_url||l_docs.doc_file;
      -- 
        IF l_dmd.dmd_file_extension IS NOT NULL 
        AND INSTR(l_docs.doc_file,'.') = 0
        THEN
          l_url := l_url || '.' || l_dmd.dmd_file_extension;
        END IF;
      --
      END IF;
    ELSE
    --
    -- Table based document - get DAD URL and display it that way
    --
    --
      l_url := get_dlc( pi_dlc_id => l_docs.doc_dlc_id).dlc_url_pathname;
      IF l_url IS NOT NULL
      THEN
        l_url := l_url||pi_doc_id;
      END IF;
    --
    END IF;
  --
    RETURN l_url;
  --
  END get_doc_url;
--
--
-----------------------------------------------------------------------------
--
  FUNCTION get_doc_template_path ( pi_template_name IN doc_template_gateways.dtg_template_name%TYPE )
    RETURN doc_locations.dlc_location_name%TYPE
  IS
    retval doc_locations.dlc_location_name%TYPE;
  --
    CURSOR c1 IS
      SELECT dlc_apps_pathname
        FROM doc_locations dl
           , doc_template_gateways dtg
       WHERE dl.dlc_dmd_id = dtg.dtg_dmd_id
         AND dl.dlc_id = dtg.dtg_dlc_id
         AND dtg.dtg_template_name = pi_template_name;
  --
  BEGIN
  --
    OPEN c1;
    FETCH c1 INTO retval;
    CLOSE c1;
  --
    RETURN retval;
  --
  END get_doc_template_path;
--
--
-----------------------------------------------------------------------------
--
  PROCEDURE archive_doc_bundle_files ( pi_doc_bundle_id IN NUMBER )
  IS
  --
    l_blob                     BLOB;
    l_hftq_batch_no            hig_file_transfer_queue.hftq_batch_no%TYPE;
  --
    CURSOR get_files
    IS
      SELECT hftq_destination_filename
           , dbf_blob
           , dbfr_doc_id 
        FROM doc_bundle_files_v
           , doc_bundle_file_relations
           , hig_file_transfer_queue
           , doc_locations
           , docs
       WHERE dbf_bundle_id = pi_doc_bundle_id
         AND error_text = 'Success'
         AND dbf_driving_file_flag = 'N'
         AND dbfr_child_file_id = dbf_file_id
         AND hftq_batch_no = dbfr_hftq_batch_no
         -- Filename is unique across a batch
         AND dbfr_doc_filename = hftq_destination_filename
         AND hftq_status = 'TRANSFER COMPLETE'
         AND doc_id = dbfr_doc_id
         AND doc_dlc_id = dlc_id;
  --
    TYPE tab_files IS TABLE OF get_files%ROWTYPE INDEX BY BINARY_INTEGER;
    l_tab_files                tab_files;
  --
  BEGIN
  --
    OPEN get_files;
    FETCH get_files BULK COLLECT INTO l_tab_files;
    CLOSE get_files;
  --
    FOR i IN 1..l_tab_files.COUNT
    LOOP
    --
      FOR z IN (
          SELECT * 
            FROM doc_location_archives
           WHERE dla_dlc_id = (SELECT doc_dlc_id FROM docs
                                 WHERE doc_id = l_tab_files(i).dbfr_doc_id )
          )
      LOOP
      --
        IF z.dla_archive_type = 'ORACLE_DIRECTORY'
        THEN
          BEGIN
            nm3file.blob_to_file 
              ( pi_blob             => l_tab_files(i).dbf_blob
              , pi_destination_dir  => z.dla_archive_name
              , pi_destination_file => l_tab_files(i).hftq_destination_filename
              );
          END;
        END IF;
      --
      END LOOP;
    --
    END LOOP;
  --
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN NULL;
    WHEN TOO_MANY_ROWS
    THEN NULL;
  END archive_doc_bundle_files;
--
--
-----------------------------------------------------------------------------
--
  FUNCTION is_table_valid ( pi_table_name IN user_tables.table_name%TYPE )
    RETURN VARCHAR2
  IS
    retval VARCHAR2(1) := 'Y';
    l_prefix VARCHAR2(10);
  BEGIN
    validate_table ( pi_table_name => pi_table_name
                   , po_col_prefix => l_prefix );
    RETURN retval;
  EXCEPTION
    WHEN OTHERS
    THEN
      RETURN 'N';
  END is_table_valid;
--
-----------------------------------------------------------------------------
--
  PROCEDURE get_doc_image ( pi_doc_id IN docs.doc_id%TYPE )
  IS
  --
  --Task 0110109
  -- For a table based document, get the file and display it via the DAD using
  -- wpg_docload SYS builtin.
  --
    l_blob BLOB;
    l_dummy_file       nm3type.max_varchar2;
    l_dummy_path       nm3type.max_varchar2;
    l_table_name       nm3type.max_varchar2;
    l_column_name      nm3type.max_varchar2;
    l_where_clause     nm3type.max_varchar2;
    l_dummy_title      nm3type.max_varchar2;
    l_dummy_sub_title  nm3type.max_varchar2; 
  BEGIN
    nm3doc_files.get_download_info
      ( pi_doc_id          => pi_doc_id
      , pi_revision        => 1
      , po_client_file     => l_dummy_file
      , po_working_folder  => l_dummy_path
      , po_table_name      => l_table_name
      , po_column_name     => l_column_name
      , po_where_clause    => l_where_clause
      , po_prog_title      => l_dummy_title
      , po_prog_sub_title  => l_dummy_sub_title );
  --
    EXECUTE IMMEDIATE 'SELECT '||l_column_name||' FROM '||l_table_name||' WHERE '||l_where_clause
       INTO l_blob;
  --
    wpg_docload.download_file(l_blob );
  --
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
  END get_doc_image;
--
-----------------------------------------------------------------------------
-- 
END doc_locations_api;
/

