CREATE OR REPLACE PACKAGE BODY higole
AS
  --   SCCS Identifiers :-
  --
  --       sccsid           : @(#)hig_ole.pkb 1.3 06/08/05
  --       Module Name      : hig_ole.pkb
  --       Date into SCCS   : 05/06/08 09:56:27
  --       Date fetched Out : 07/06/13 14:10:24
  --       SCCS Version     : 1.3
  --
  --
  --
  --   Author : Ian Smith

  c_strdateformat   VARCHAR2 ( 100 );
  c_strvarchar      CONSTANT VARCHAR2 ( 30 ) := 'VARCHAR2';
  c_strdate         CONSTANT VARCHAR2 ( 30 ) := 'DATE';
  c_strnumeric      CONSTANT VARCHAR2 ( 30 ) := 'NUMBER';
  c_sccs_id CONSTANT VARCHAR2 ( 200 ) := '@(#)hig_ole.pck	1.9 11/04/98' ;

  mc_template_pk    VARCHAR2 ( 32767 ) := NULL;
  mc_no_of_pks      INTEGER;
  mc_delimiter      CONSTANT VARCHAR2 ( 3 ) := '$@$';
  mc_no_of_cols     INTEGER;


  FUNCTION strget_template_sql ( strtemplate   IN VARCHAR2
                               , strpkvalue    IN VARCHAR2 )
    RETURN VARCHAR2
  IS
    strreturn        VARCHAR2 ( 32767 );
    strbuildsql      VARCHAR2 ( 32767 );
    strtempcolumns   VARCHAR2 ( 32767 );
    strtablename     VARCHAR2 ( 250 );
    strpkcolumn      VARCHAR2 ( 2000 );

    column_error     EXCEPTION;
    synonym_error    EXCEPTION;
    pk_error         EXCEPTION;
  BEGIN
    strbuildsql := 'SELECT ';

    strtempcolumns := higole.strget_template_columns ( strtemplate );

    IF strtempcolumns IS NULL
    THEN
      RAISE column_error;
    END IF;

    strtablename := higole.strget_template_synonym ( strtemplate );

    IF strtablename IS NULL
    THEN
      RAISE synonym_error;
    END IF;

    strpkcolumn := higole.strget_template_pk_column ( strtemplate );

    IF strpkcolumn IS NULL
    THEN
      RAISE pk_error;
    END IF;

    strreturn :=
         strbuildsql
      || strtempcolumns
      || ' FROM '
      || strtablename
      || ' WHERE '
      || strpkcolumn
      || '='''
      || strpkvalue
      || '''';

    RETURN strreturn;
  EXCEPTION
    WHEN column_error
    THEN
      RAISE_APPLICATION_ERROR (
                                -20001
                              ,    'Unable to find columns for template <<<'
                                || strtemplate
                                || '>>>' );
    WHEN synonym_error
    THEN
      RAISE_APPLICATION_ERROR (
                                -20001
                              ,    'Unable to find synonym for template <<<'
                                || strtemplate
                                || '>>>' );
    WHEN pk_error
    THEN
      RAISE_APPLICATION_ERROR (
                                -20001
                              , 'Unable to find PK Column for template <<<'
                                || strtemplate
                                || '>>>' );
  END strget_template_sql;

  -----------------

  PROCEDURE get_template_sql ( strtemplate   IN     VARCHAR2
                             , strpkvalue    IN     VARCHAR2
                             , sql_out          OUT VARCHAR2 )
  IS
    strreturn        VARCHAR2 ( 32767 );
    strbuildsql      VARCHAR2 ( 32767 );
    strtempcolumns   VARCHAR2 ( 32767 );
    strtablename     VARCHAR2 ( 250 );
    strpkcolumn      VARCHAR2 ( 2000 );

    column_error     EXCEPTION;
    synonym_error    EXCEPTION;
    pk_error         EXCEPTION;
  BEGIN
    strbuildsql := 'SELECT ';

    strtempcolumns := higole.strget_template_columns ( strtemplate );

    IF strtempcolumns IS NULL
    THEN
      RAISE column_error;
    END IF;

    strtablename := higole.strget_template_synonym ( strtemplate );

    IF strtablename IS NULL
    THEN
      RAISE synonym_error;
    END IF;

    strpkcolumn := higole.strget_template_pk_column ( strtemplate );

    IF strpkcolumn IS NULL
    THEN
      RAISE pk_error;
    END IF;

    strreturn :=
         strbuildsql
      || strtempcolumns
      || ' FROM '
      || strtablename
      || ' WHERE '
      || strpkcolumn
      || '='''
      || strpkvalue
      || '''';

    sql_out := strreturn;
  EXCEPTION
    WHEN column_error
    THEN
      RAISE_APPLICATION_ERROR (
                                -20001
                              ,    'Unable to find columns for template <<<'
                                || strtemplate
                                || '>>>' );
    WHEN synonym_error
    THEN
      RAISE_APPLICATION_ERROR (
                                -20001
                              ,    'Unable to find synonym for template <<<'
                                || strtemplate
                                || '>>>' );
    WHEN pk_error
    THEN
      RAISE_APPLICATION_ERROR (
                                -20001
                              , 'Unable to find PK Column for template <<<'
                                || strtemplate
                                || '>>>' );
  END get_template_sql;

  --------
  --
  --------
  FUNCTION strget_sccs_id
    RETURN VARCHAR2
  IS
  BEGIN
    RETURN c_sccs_id;
  END;

  --------
  --
  --------

  FUNCTION get_default_report_type
    RETURN VARCHAR2
  IS
    CURSOR c1
    IS
      SELECT hop_value
        FROM hig_options
       WHERE hop_product = 'HIG' AND hop_id = 'DEFREPTYPE';

    strreturn   VARCHAR2 ( 100 );
  BEGIN
    OPEN c1;

    FETCH c1 INTO strreturn;

    CLOSE c1;

    RETURN strreturn;
  END;

  --------
  --
  --------


  FUNCTION strget_template_pk_column ( strtemplatename IN VARCHAR2 )
    RETURN VARCHAR2
  IS
    strreturn      VARCHAR2 ( 2000 );

    CURSOR c1
    IS
      SELECT dg.dgt_pk_col_name
        FROM DOC_GATEWAYS dg, DOC_TEMPLATE_GATEWAYS dtg
       WHERE dg.dgt_table_name = dtg.dtg_table_name
             AND dtg_template_name = strtemplatename;

    pk_not_found   EXCEPTION;
  BEGIN
    OPEN c1;

    FETCH c1 INTO strreturn;

    IF c1%NOTFOUND
    THEN
      CLOSE c1;

      RAISE pk_not_found;
    END IF;

    CLOSE c1;

    RETURN strreturn;
  EXCEPTION
    WHEN pk_not_found
    THEN
      ---Violates Pragma
      ---RAISE_APPLICATION_ERROR(-20001,'Unable to find a PK for template <<<'||strTemplateName||'>>>');
      ---RETURN 'Unable to find a PK for template <<<'||strTemplateName||'>>>';
      ---Let the main SQL module handle the generation of errors through raise_application_error
      RETURN NULL;
  END strget_template_pk_column;

  --------
  --
  --------
  FUNCTION strget_template_where ( strtemplatename IN VARCHAR2 )
    RETURN VARCHAR2
  IS
    strreturn   VARCHAR2 ( 32767 );
  BEGIN
    RETURN strreturn;
  END;

  --------
  --
  --------
  FUNCTION strget_template_columns ( strtemplate IN VARCHAR2 )
    RETURN VARCHAR2
  IS
    strreturn          VARCHAR2 ( 32767 );
    strbuildwhere      VARCHAR2 ( 32767 );

    CURSOR c1
    IS
        SELECT *
          FROM DOC_TEMPLATE_COLUMNS
         WHERE dtc_template_name = strtemplate
      ORDER BY dtc_col_seq;

    no_columns_found   EXCEPTION;
  BEGIN
    FOR recs IN c1
    LOOP
      ---Depending on the column type convert to a character for all column types
      IF UPPER ( recs.dtc_col_type ) = c_strvarchar
      THEN
        strbuildwhere :=
             strbuildwhere
          || recs.dtc_col_name
          || ' '
          || recs.dtc_col_alias
          || ',';
      ELSIF UPPER ( recs.dtc_col_type ) = c_strdate
      THEN
        strbuildwhere :=
             strbuildwhere
          || 'TO_CHAR('
          || recs.dtc_col_name
          || ','''
          || c_strdateformat
          || ''') '
          || recs.dtc_col_alias
          || ',';
      ELSIF UPPER ( recs.dtc_col_type ) = c_strnumeric
      THEN
        strbuildwhere :=
             strbuildwhere
          || 'TO_CHAR('
          || recs.dtc_col_name
          || ') '
          || recs.dtc_col_alias
          || ',';
      ELSE
        ---No type found so assume character
        strbuildwhere :=
             strbuildwhere
          || recs.dtc_col_name
          || ' '
          || recs.dtc_col_alias
          || ',';
      END IF;
    END LOOP;

    IF strbuildwhere IS NOT NULL
    THEN
      ---Strip off the last comma
      strreturn := SUBSTR ( strbuildwhere, 1, LENGTH ( strbuildwhere ) - 1 );
    ELSE
      RAISE no_columns_found;
    END IF;

    RETURN strreturn;
  EXCEPTION
    WHEN no_columns_found
    THEN
      ---RETURN 'No Columns found for template <<<'||strTemplate||'>>>';
      RETURN NULL;
  END;

  --------
  --
  --------
  FUNCTION strget_procedure_columns ( strtemplate   IN VARCHAR2
                                    , strpkvalue    IN VARCHAR2 )
    RETURN VARCHAR2
  IS
    strreturn          VARCHAR2 ( 32767 );
    strcolumns         VARCHAR2 ( 32767 );
    strbuildwhere      VARCHAR2 ( 32767 );
    strtablename       VARCHAR2 ( 2000 );
    strpkcolumn        VARCHAR2 ( 200 );
    strsql             VARCHAR2 ( 32767 );
    strcolvalues       VARCHAR2 ( 32767 );

    source_cursor      INTEGER;
    cursor_status      INTEGER;
    intcol             INTEGER;
    intlineno          INTEGER := 0;

    varchar_col        VARCHAR2 ( 255 );
    date_col           DATE;
    number_col         NUMBER;

    CURSOR c1
    IS
        SELECT *
          FROM DOC_TEMPLATE_COLUMNS
         WHERE dtc_template_name = strtemplate AND dtc_used_in_proc = 'Y'
      ORDER BY dtc_col_seq;

    no_columns_found   EXCEPTION;
    synonym_error      EXCEPTION;
    pk_error           EXCEPTION;
  BEGIN
    ---Get the View that the columns are to be selected from
    strtablename := higole.strget_template_synonym ( strtemplate );

    IF strtablename IS NULL
    THEN
      RAISE synonym_error;
    END IF;

    ---Get the Primary Key Column against which the select can be performed
    strpkcolumn := higole.strget_template_pk_column ( strtemplate );

    IF strpkcolumn IS NULL
    THEN
      RAISE pk_error;
    END IF;



    FOR recs IN c1
    LOOP
      strcolumns := strcolumns || recs.dtc_col_name || ',';
    END LOOP;

    IF strcolumns IS NOT NULL
    THEN
      ---Strip off the last comma
      strcolumns := SUBSTR ( strcolumns, 1, LENGTH ( strcolumns ) - 1 );
    ELSE
      RAISE no_columns_found;
    END IF;


    source_cursor := dbms_sql.open_cursor;

    strsql :=
         'SELECT '
      || strcolumns
      || ' FROM '
      || strtablename
      || ' WHERE '
      || strpkcolumn
      || '='''
      || strpkvalue
      || '''';
    dbms_output.put_line ( 'Sql =' || strsql );

    intlineno := 1;
    ---Now build the dynamic sql to return to values of each column
    dbms_sql.parse ( source_cursor, strsql, dbms_sql.v7 );

    intlineno := 3;


    ---Bind the Columns
    intcol := 1;

    FOR recs IN c1
    LOOP
      IF UPPER ( recs.dtc_col_type ) = c_strvarchar
      THEN
        dbms_sql.define_column ( source_cursor
                               , intcol
                               , varchar_col
                               , 255 );
      ELSIF UPPER ( recs.dtc_col_type ) = c_strdate
      THEN
        dbms_sql.define_column ( source_cursor, intcol, date_col );
      ELSIF UPPER ( recs.dtc_col_type ) = c_strnumeric
      THEN
        dbms_sql.define_column ( source_cursor, intcol, number_col );
      END IF;

      intcol := intcol + 1;
    END LOOP;

    intlineno := 4;

    ---Now get the Column Values from the Dynamic Query
    ---Reset Column Back to first one
    intcol := 1;
    ---Execute the cursor
    cursor_status := dbms_sql.EXECUTE ( source_cursor );


    ---Get the column Values
    IF dbms_sql.fetch_rows ( source_cursor ) > 0
    THEN
      FOR recs IN c1
      LOOP
        IF UPPER ( recs.dtc_col_type ) = c_strvarchar
        THEN
          dbms_sql.column_value ( source_cursor, intcol, varchar_col );
          strcolvalues := strcolvalues || '''' || varchar_col || ''',';
        ELSIF UPPER ( recs.dtc_col_type ) = c_strdate
        THEN
          dbms_sql.column_value ( source_cursor, intcol, date_col );
          strcolvalues :=
            strcolvalues || TO_CHAR ( date_col, c_strdateformat ) || ',';
        ELSIF UPPER ( recs.dtc_col_type ) = c_strnumeric
        THEN
          dbms_sql.column_value ( source_cursor, intcol, number_col );
          strcolvalues := strcolvalues || TO_CHAR ( number_col ) || ',';
        END IF;

        intcol := intcol + 1;
      END LOOP;

      IF strcolvalues IS NOT NULL
      THEN
        ---Rip off the last comma
        strcolvalues :=
          SUBSTR ( strcolvalues, 1, LENGTH ( strcolvalues ) - 1 );
      END IF;
    END IF;

    dbms_sql.close_cursor ( source_cursor );

    strreturn := strcolvalues;

    RETURN strreturn;
  EXCEPTION
    WHEN no_columns_found OR synonym_error OR pk_error
    THEN
      ---RETURN 'No Columns found for template <<<'||strTemplate||'>>>';
      RAISE_APPLICATION_ERROR ( -20000, 'Invalid Template' );
      RETURN NULL;
    WHEN OTHERS
    THEN
      IF dbms_sql.is_open ( source_cursor )
      THEN
        dbms_sql.close_cursor ( source_cursor );
      END IF;

      RAISE_APPLICATION_ERROR (
                                -20000
                              ,    SQLERRM
                                || ' At line'
                                || TO_CHAR ( intlineno ) );
      RETURN NULL;
  END;

  --------
  --
  --------

  FUNCTION strget_template_from ( strtemplate IN VARCHAR2 )
    RETURN VARCHAR2
  IS
    strreturn      VARCHAR2 ( 250 );
    strtablename   VARCHAR2 ( 250 );

    CURSOR c1
    IS
      SELECT dtg_table_name
        FROM DOC_TEMPLATE_GATEWAYS
       WHERE dtg_template_name = strtemplate;
  BEGIN
    OPEN c1;

    FETCH c1 INTO strtablename;

    CLOSE c1;

    strreturn := strtablename;

    RETURN strreturn;
  END;

  --------
  --
  --------
  FUNCTION strget_template_synonym ( strtemplate IN VARCHAR2 )
    RETURN VARCHAR2
  IS
    strreturn   VARCHAR2 ( 2000 );

    CURSOR c1
    IS
      SELECT dtg_table_name
        FROM DOC_TEMPLATE_GATEWAYS
       WHERE dtg_template_name = strtemplate;
  BEGIN
    OPEN c1;

    FETCH c1 INTO strreturn;

    CLOSE c1;

    RETURN strreturn;
  END;

  --------
  --
  --------
  FUNCTION strget_template_procedure ( strtemplate IN VARCHAR2 )
    RETURN VARCHAR2
  IS
    strreturn   VARCHAR2 ( 2000 );

    CURSOR c1
    IS
      SELECT dtg_post_run_procedure
        FROM DOC_TEMPLATE_GATEWAYS
       WHERE dtg_template_name = strtemplate;
  BEGIN
    OPEN c1;

    FETCH c1 INTO strreturn;

    CLOSE c1;

    RETURN strreturn;
  END;

  --------
  --
  --------

  FUNCTION strget_template_path ( strtemplate IN VARCHAR2 )
    RETURN VARCHAR2
  IS
--    strreturn   doc_locations.DLC_PATHNAME%TYPE;
--
--    CURSOR c1
--    IS
--      SELECT dlc_pathname
--        FROM DOC_LOCATIONS dl, DOC_TEMPLATE_GATEWAYS dtg
--       WHERE     dl.dlc_dmd_id = dtg.dtg_dmd_id
--             AND dl.dlc_id = dtg.dtg_dlc_id
--             AND dtg.dtg_template_name = strtemplate;
--  BEGIN
--    OPEN c1;
--
--    FETCH c1 INTO strreturn;
--
--    CLOSE c1;
--
--    RETURN strreturn;
  BEGIN
    RETURN doc_locations_api.get_doc_template_path(strtemplate);
  END strget_template_path;

  FUNCTION strget_template_path ( strtemplate   IN VARCHAR2
                                , strui         IN VARCHAR2 )
    RETURN VARCHAR2
  IS
--    strreturn    doc_locations.DLC_APPS_PATHNAME%TYPE;
--    strreturn2   doc_locations.DLC_PATHNAME%TYPE;
--
--    CURSOR c1
--    IS
--      SELECT dlc_apps_pathname, dlc_pathname
--        FROM DOC_LOCATIONS dl, DOC_TEMPLATE_GATEWAYS dtg
--       WHERE     dl.dlc_dmd_id = dtg.dtg_dmd_id
--             AND dl.dlc_id = dtg.dtg_dlc_id
--             AND dtg.dtg_template_name = strtemplate;
--  BEGIN
--    OPEN c1;
--
--    FETCH c1
--    INTO strreturn, strreturn2;
--
--    CLOSE c1;
--
--    IF strui = 'WEB'
--    THEN
--      RETURN strreturn;
--    ELSE
--      RETURN strreturn2;
--    END IF;
  BEGIN
    RETURN doc_locations_api.get_doc_template_path(strtemplate);
  END strget_template_path;

  --------
  --
  --------
  FUNCTION bolhas_templates ( strtable IN VARCHAR2 )
    RETURN BOOLEAN
  IS
    intcount   INTEGER;
    bolret     BOOLEAN := FALSE;
  BEGIN
    ---We need to include the user key to see if this user has templates
    SELECT COUNT ( * )
      INTO intcount
      FROM DOC_TEMPLATE_GATEWAYS
     WHERE dtg_table_name = strtable
           AND dtg_template_name IN
                 (SELECT dtu_template_name
                    FROM DOC_TEMPLATE_USERS, HIG_USERS
                   WHERE dtu_user_id = (SELECT hus_user_id
                                          FROM HIG_USERS
                                         WHERE hus_username = Sys_Context('NM3_SECURITY_CTX','USERNAME')));

    IF intcount > 0
    THEN
      bolret := TRUE;
    END IF;

    RETURN bolret;
  END;

  --------
  --
  --------

  FUNCTION intget_template_media ( strtemplate IN VARCHAR2 )
    RETURN NUMBER
  IS
    intreturn   NUMBER;

    CURSOR c1
    IS
      SELECT dtg_dmd_id
        FROM DOC_TEMPLATE_GATEWAYS
       WHERE dtg_template_name = strtemplate;
  BEGIN
    OPEN c1;

    FETCH c1 INTO intreturn;

    CLOSE c1;

    RETURN intreturn;
  END;

  --------
  --
  --------
  FUNCTION intget_template_location ( strtemplate IN VARCHAR2 )
    RETURN NUMBER
  IS
    intreturn   NUMBER;

    CURSOR c1
    IS
      SELECT dtg_dlc_id
        FROM DOC_TEMPLATE_GATEWAYS
       WHERE dtg_template_name = strtemplate;
  BEGIN
    OPEN c1;

    FETCH c1 INTO intreturn;

    CLOSE c1;

    RETURN intreturn;
  END;

  --------
  --
  --------
  PROCEDURE copytemplate ( strfromtemplate   IN VARCHAR2
                         , strtotemplate     IN VARCHAR2 )
  IS
    CURSOR c1
    IS
      SELECT 'EXISTS'
        FROM DOC_TEMPLATE_GATEWAYS
       WHERE dtg_template_name = strtotemplate;

    strdummy         VARCHAR2 ( 10 );
    template_error   EXCEPTION;
  BEGIN
    OPEN c1;

    FETCH c1 INTO strdummy;

    IF c1%FOUND
    THEN
      ---This template already exists so bog off
      RAISE template_error;
    END IF;

    CLOSE c1;

    ---First Create the Template
    INSERT INTO DOC_TEMPLATE_GATEWAYS ( dtg_dmd_id
                                      , dtg_ole_type
                                      , dtg_table_name
                                      , dtg_template_name
                                      , dtg_dlc_id
                                      , dtg_template_descr
                                      , dtg_post_run_procedure )
      SELECT dtg_dmd_id
           , dtg_ole_type
           , dtg_table_name
           , strtotemplate
           , dtg_dlc_id
           , dtg_template_descr
           , dtg_post_run_procedure
        FROM DOC_TEMPLATE_GATEWAYS
       WHERE dtg_template_name = strfromtemplate;

    ---Now Create the template Columns

    INSERT INTO DOC_TEMPLATE_COLUMNS ( dtc_template_name
                                     , dtc_col_name
                                     , dtc_col_type
                                     , dtc_col_alias
                                     , dtc_col_seq
                                     , dtc_used_in_proc )
      SELECT strtotemplate
           , dtc_col_name
           , dtc_col_type
           , dtc_col_alias
           , dtc_col_seq
           , dtc_used_in_proc
        FROM DOC_TEMPLATE_COLUMNS
       WHERE dtc_template_name = strfromtemplate;
  EXCEPTION
    WHEN template_error
    THEN
      CLOSE c1;

      RAISE_APPLICATION_ERROR (
                                -20000
                              ,    'Template ['
                                || strtotemplate
                                || '] Already Exists !' );
  END;

  --------
  --
  --------
  ---This function uses the DBMS_DESCRIBE package to check what the return type
  ---of a given function is
  FUNCTION strget_function_type ( strfunction IN VARCHAR2 )
    RETURN VARCHAR2
  IS
    strreturn        VARCHAR2 ( 12 ) := NULL;

    ---Setup Return Tables from DBMS_DESCRIBE
    overload         dbms_describe.number_table;
    c_level          dbms_describe.number_table;
    arg_name         dbms_describe.varchar2_table;
    def_val          dbms_describe.number_table;
    p_mode           dbms_describe.number_table;
    LENGTH           dbms_describe.number_table;
    PRECISION        dbms_describe.number_table;
    scale            dbms_describe.number_table;
    radix            dbms_describe.number_table;
    spare            dbms_describe.number_table;

    postable         dbms_describe.number_table;
    typetable        dbms_describe.number_table;

    inttype          INTEGER;

    does_not_exist   EXCEPTION;
    PRAGMA EXCEPTION_INIT ( does_not_exist, -20001 );
  BEGIN
    dbms_describe.describe_procedure ( strfunction
                                     , NULL
                                     , NULL
                                     , overload
                                     , postable
                                     , c_level
                                     , arg_name
                                     , typetable
                                     , def_val
                                     , p_mode
                                     , LENGTH
                                     , PRECISION
                                     , scale
                                     , radix
                                     , spare );

    ---Get the procedure/function return type
    inttype := typetable ( 1 );

    IF inttype = 1
    THEN
      strreturn := c_strvarchar;
    ELSIF inttype IN (2, 3)
    THEN
      strreturn := c_strnumeric;
    ELSIF inttype = 12
    THEN
      strreturn := c_strdate;
    END IF;

    RETURN strreturn;
  EXCEPTION
    WHEN does_not_exist
    THEN
      RETURN NULL;
  END;

  --------
  --
  --------
  FUNCTION bolparsesql ( strsql IN VARCHAR2, strerror OUT VARCHAR2 )
    RETURN BOOLEAN
  IS
    source_cursor   INTEGER := dbms_sql.open_cursor;
  BEGIN
    ---Now build the dynamic sql to return to values of each column
    dbms_sql.parse ( source_cursor, strsql, dbms_sql.v7 );
    dbms_sql.close_cursor ( source_cursor );

    RETURN TRUE;
  EXCEPTION
    WHEN OTHERS
    THEN
      dbms_sql.close_cursor ( source_cursor );
      strerror := SQLERRM;
      RETURN FALSE;
  END;

  --------
  --
  --------
  FUNCTION bolparsesql ( strsql        IN     VARCHAR2
                       , strerror         OUT VARCHAR2
                       , interrorpos      OUT INTEGER )
    RETURN BOOLEAN
  IS
    source_cursor   INTEGER := dbms_sql.open_cursor;
  BEGIN
    ---Now build the dynamic sql to return to values of each column
    dbms_sql.parse ( source_cursor, strsql, dbms_sql.v7 );
    dbms_sql.close_cursor ( source_cursor );

    RETURN TRUE;
  EXCEPTION
    WHEN OTHERS
    THEN
      interrorpos := dbms_sql.last_error_position;
      dbms_sql.close_cursor ( source_cursor );
      strerror := SQLERRM;
      RETURN FALSE;
  END;

  --------
  --
  --------

  PROCEDURE initialise_template_data ( strtemplate   IN VARCHAR2
                                     , strpkvalue    IN VARCHAR2 )
  IS
    strsql            VARCHAR2 ( 32767 );
    source_cursor     INTEGER;
    cursor_status     INTEGER;
    intcol            BINARY_INTEGER;
    intlineno         INTEGER := 0;
    intlasterrorpos   INTEGER;
    varchar_col       VARCHAR2 ( 2000 );
    date_col          DATE;
    number_col        NUMBER;

    CURSOR c1
    IS
        SELECT *
          FROM DOC_TEMPLATE_COLUMNS
         WHERE dtc_template_name = strtemplate
      ORDER BY dtc_col_seq;

    sql_error         EXCEPTION;
    NO_DATA_FOUND     EXCEPTION;
  BEGIN
    ---Trash any current data in the package PLSQL Table
    IF g_tabtemplatedata.COUNT > 0
    THEN
      g_tabtemplatedata.DELETE;
      mc_no_of_cols := 0;
    END IF;

    ---First get the template SQL
    higole.get_template_sql ( strtemplate, strpkvalue, strsql );

    IF strsql IS NULL
    THEN
      RAISE sql_error;
    END IF;

    intlineno := 1;

    IF dbms_sql.is_open ( source_cursor )
    THEN
      dbms_sql.close_cursor ( source_cursor );
    END IF;

    source_cursor := dbms_sql.open_cursor;

    ---dbms_output.put_line('Length of sql ='||to_char(length(strSQL)));

    intlineno := 2;
    ---Now build the dynamic sql to return to values of each column
    dbms_sql.parse ( source_cursor, strsql, dbms_sql.v7 );
    intlasterrorpos := dbms_sql.last_error_position;

    ---dbms_output.put_line('Error position '||to_chaR(intLastErrorPos));

    intlineno := 3;


    ---Bind the Columns
    intcol := 1;

    FOR recs IN c1
    LOOP
      ---The template SQL should always return string columns
      dbms_sql.define_column ( source_cursor
                             , intcol
                             , varchar_col
                             , 2000 );
      intcol := intcol + 1;
    END LOOP;

    intlineno := 4;

    ---Now get the Column Values from the Dynamic Query
    ---Reset Column Back to first one
    intcol := 1;

    ---Execute the cursor
    cursor_status := dbms_sql.EXECUTE ( source_cursor );
    ---dbms_output.put_line('Cursor status='||to_char(cursor_status));

    intlineno := 5;

    ---Get the column Values
    IF dbms_sql.fetch_rows ( source_cursor ) > 0
    THEN
      intlineno := 6;

      FOR recs IN c1
      LOOP
        dbms_sql.column_value ( source_cursor, intcol, varchar_col );
        ---Assign the i'th element to the retrieved column
        g_tabtemplatedata ( intcol ) := varchar_col;
        intcol := intcol + 1;
      END LOOP;
    ELSE
      RAISE NO_DATA_FOUND;
    END IF;

    dbms_sql.close_cursor ( source_cursor );
    intlineno := 7;

    mc_no_of_cols := intcol;

    intlineno := 8;
  EXCEPTION
    WHEN sql_error
    THEN
      ---RETURN 'No SQL found for template <<<'||strTemplate||'>>>';
      IF dbms_sql.is_open ( source_cursor )
      THEN
        dbms_sql.close_cursor ( source_cursor );
      END IF;

      RAISE_APPLICATION_ERROR ( -20000, 'Invalid Template' );
    WHEN NO_DATA_FOUND
    THEN
      IF dbms_sql.is_open ( source_cursor )
      THEN
        dbms_sql.close_cursor ( source_cursor );
      END IF;

      RAISE_APPLICATION_ERROR (
                                -20000
                              ,    'Invalid Primary Key <<<'
                                || strpkvalue
                                || '>>>' );
    WHEN OTHERS
    THEN
      IF dbms_sql.is_open ( source_cursor )
      THEN
        dbms_sql.close_cursor ( source_cursor );
      END IF;

      RAISE_APPLICATION_ERROR (
                                -20000
                              ,    SQLERRM
                                || ' At line - '
                                || TO_CHAR ( intlineno ) );
  END;

  --------
  --
  --------

  FUNCTION strget_template_column_data ( intcolumnpos IN INTEGER )
    RETURN VARCHAR2
  IS
    strreturn          VARCHAR2 ( 2000 );
    intdelimcount      INTEGER;
    intdelimstartpos   INTEGER;
    intdelimendpos     INTEGER;
  BEGIN
    ---If the package data table hasn't been instantiated or a request for more columns
    ---than are in template data then bomb out with null!!!

    IF intcolumnpos > mc_no_of_cols
    THEN
      RETURN NULL;
    END IF;

    ---We can forget this little lot now and just go to the indexed column !!!

    strreturn := g_tabtemplatedata ( intcolumnpos );

    /*
    if intColumnPos = 1 then
     intDelimStartPos := instr(MC_TEMPLATE_DATA,MC_DELIMITER,1)-1;
     strReturn := substr(MC_TEMPLATE_DATA,1,intDelimStartPos);
    else
     ---Find the first delimiter position
     intDelimStartPos :=instr(MC_TEMPLATE_DATA,MC_DELIMITER,1,(intColumnPos -1))+length(MC_DELIMITER);
     intDelimEndPos :=instr(MC_TEMPLATE_DATA,MC_DELIMITER,intDelimStartPos);
     strReturn := 'Start pos '||to_char(intDelimStartPos)||' end pos'||to_char(intDelimEndPos);
     ---Get the substring from these delimiter positions
     strReturn := substr(MC_TEMPLATE_DATA,intDelimStartPos,intDelimEndPos - intDelimStartPos);
    end if;
    */

    RETURN strreturn;
  END;

  --------
  --
  --------

  PROCEDURE initialise_pk_data ( strsql IN VARCHAR2 )
  IS
    strpkvalues       VARCHAR2 ( 32767 );

    source_cursor     INTEGER;
    cursor_status     INTEGER;
    intcol            INTEGER;
    intlineno         INTEGER := 0;
    introws           INTEGER := 0;
    intlasterrorpos   INTEGER;
    varchar_col       VARCHAR2 ( 2000 );
    date_col          DATE;
    number_col        NUMBER;


    sql_error         EXCEPTION;
  BEGIN
    IF strsql IS NULL
    THEN
      RAISE sql_error;
    END IF;

    intlineno := 1;

    IF dbms_sql.is_open ( source_cursor )
    THEN
      dbms_sql.close_cursor ( source_cursor );
    END IF;

    source_cursor := dbms_sql.open_cursor;

    dbms_output.
    put_line ( 'Length of sql =' || TO_CHAR ( LENGTH ( strsql ) ) );

    intlineno := 2;
    ---Now build the dynamic sql to return to values of each column
    dbms_sql.parse ( source_cursor, strsql, dbms_sql.v7 );
    intlasterrorpos := dbms_sql.last_error_position;

    dbms_output.put_line ( 'Error position ' || TO_CHAR ( intlasterrorpos ) );

    intlineno := 3;


    ---Bind the PK Column
    intcol := 1;
    dbms_sql.define_column ( source_cursor
                           , intcol
                           , varchar_col
                           , 2000 );

    intlineno := 4;

    ---Now get the Column Values from the Dynamic Query
    ---Reset Column Back to first one
    intcol := 1;

    ---Execute the cursor
    cursor_status := dbms_sql.EXECUTE ( source_cursor );
    dbms_output.put_line ( 'Cursor status=' || TO_CHAR ( cursor_status ) );

    intlineno := 5;
    intcol := 1;


    LOOP
      ---Get the column Values
      IF dbms_sql.fetch_rows ( source_cursor ) > 0
      THEN
        intlineno := 6;

        dbms_sql.column_value ( source_cursor, intcol, varchar_col );
        strpkvalues := strpkvalues || varchar_col || mc_delimiter;
        ---dbms_output.put_line('col '||to_char(intCol)||' = '||VARCHAR_COL);
        introws := introws + 1;
      ELSE
        ---No more rows in cursor so exit loop
        EXIT;
      END IF;
    END LOOP;

    dbms_sql.close_cursor ( source_cursor );
    intlineno := 7;

    mc_template_pk := strpkvalues;
    mc_no_of_pks := introws;

    intlineno := 8;
  EXCEPTION
    WHEN sql_error
    THEN
      ---RETURN 'No SQL found for template <<<'||strTemplate||'>>>';
      IF dbms_sql.is_open ( source_cursor )
      THEN
        dbms_sql.close_cursor ( source_cursor );
      END IF;

      RAISE_APPLICATION_ERROR ( -20000, 'No SQL Defined !' );
    WHEN OTHERS
    THEN
      IF dbms_sql.is_open ( source_cursor )
      THEN
        dbms_sql.close_cursor ( source_cursor );
      END IF;

      RAISE_APPLICATION_ERROR (
                                -20000
                              ,    SQLERRM
                                || ' At line - '
                                || TO_CHAR ( intlineno ) );
  END;

  --------
  --
  --------

  FUNCTION strget_template_pk_data ( introwpos IN INTEGER )
    RETURN VARCHAR2
  IS
    strreturn          VARCHAR2 ( 2000 );
    intdelimcount      INTEGER;
    intdelimstartpos   INTEGER;
    intdelimendpos     INTEGER;
  BEGIN
    ---If the package data string hasn't been instantiated or a request for more columns
    ---than are in template data then bomb out with null!!!
    IF mc_template_pk IS NULL OR introwpos > mc_no_of_pks
    THEN
      RETURN NULL;
    END IF;

    IF introwpos = 1
    THEN
      intdelimstartpos := INSTR ( mc_template_pk, mc_delimiter, 1 ) - 1;
      strreturn := SUBSTR ( mc_template_pk, 1, intdelimstartpos );
    ELSE
      ---Find the first delimiter position
      intdelimstartpos :=
        INSTR ( mc_template_pk
              , mc_delimiter
              , 1
              , ( introwpos - 1 ) )
        + LENGTH ( mc_delimiter );
      intdelimendpos :=
        INSTR ( mc_template_pk, mc_delimiter, intdelimstartpos );
      strreturn :=
           'Start pos '
        || TO_CHAR ( intdelimstartpos )
        || ' end pos'
        || TO_CHAR ( intdelimendpos );
      ---Get the substring from these delimiter positions
      strreturn :=
        SUBSTR ( mc_template_pk
               , intdelimstartpos
               , intdelimendpos - intdelimstartpos );
    END IF;

    RETURN strreturn;
  END;

  --------
  --
  --------
  FUNCTION intget_no_of_pks
    RETURN NUMBER
  IS
  BEGIN
    RETURN mc_no_of_pks;
  END;

  --------
  --
  --------

  PROCEDURE resequencetemplate ( strtemplate IN VARCHAR2 )
  IS
    intseqno   INTEGER := 1;

    CURSOR c1
    IS
        SELECT dtc_col_seq, ROWNUM, ROWID
          FROM DOC_TEMPLATE_COLUMNS
         WHERE dtc_template_name = strtemplate
      ORDER BY 1, 2;
  BEGIN
    FOR recs IN c1
    LOOP
      UPDATE DOC_TEMPLATE_COLUMNS
         SET dtc_col_seq = intseqno
       WHERE ROWID = recs.ROWID;

      intseqno := intseqno + 1;
    END LOOP;
  END;
---Instantiate Package vars on first call

BEGIN
  DECLARE
    CURSOR c1
    IS
      SELECT hop_value
        FROM hig_options
       WHERE hop_id = 'GRIDATE';
  BEGIN
    OPEN c1;

    FETCH c1 INTO c_strdateformat;

    CLOSE c1;

    IF c_strdateformat IS NULL
    THEN
      ---If the meta data for this option is not available then default it
      c_strdateformat := 'DD-MON-YYYY';
    END IF;
  END;
END higole;
/
