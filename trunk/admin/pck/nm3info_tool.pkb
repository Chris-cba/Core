CREATE OR REPLACE PACKAGE BODY nm3info_tool
AS
  -------------------------------------------------------------------------
  --   PVCS Identifiers :-
  --
  --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3info_tool.pkb-arc   3.0   May 06 2010 17:19:18   aedwards  $
  --       Module Name      : $Workfile:   nm3info_tool.pkb  $
  --       Date into PVCS   : $Date:   May 06 2010 17:19:18  $
  --       Date fetched Out : $Modtime:   May 06 2010 17:17:58  $
  --       Version          : $Revision:   3.0  $
  --       Based on SCCS version :
  -------------------------------------------------------------------------
  --
  --all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid   CONSTANT VARCHAR2(2000) := '$Revision:   3.0  $';
  g_package_name  CONSTANT VARCHAR2(30) := 'NM3INFO_TOOL';
  g_inv_attrs     nm3inv.tab_nita;
  g_is_ft         BOOLEAN; -- is the query a ft query
  l_sql           nm3type.tab_varchar32767;
  c_date_format   CONSTANT VARCHAR2(30):= nm3context.get_context(pi_attribute => 'USER_DATE_MASK') ;

  --
  -----------------------------------------------------------------------------
  --
  CURSOR check_tables_cur(p_theme_id nm_themes_all.nth_theme_id%TYPE)
  IS
    SELECT nth_theme_name
          ,nth_table_name
          ,nth_pk_column
          ,CASE
             WHEN nith_nit_id IS NOT NULL THEN --'Asset'
               (SELECT nvl(nit_table_name, 'NM_INV_ITEMS')
                  FROM nm_inv_types
                 WHERE nith_nit_id = nit_inv_type)
             WHEN nnth_nlt_id IS NOT NULL THEN --'Linear Network'
               'NM_ELEMENTS'
             WHEN nath_nat_id IS NOT NULL THEN --'Area Network'
               'NM_ELEMENTS'
             ELSE
               -- Unknown - use theme table
               nth_table_name
           END
             AS source_table
          ,CASE
             WHEN nith_nit_id IS NOT NULL THEN --'Asset'
                                              'ASSET'
             WHEN nnth_nlt_id IS NOT NULL THEN --'Linear Network'
                                              'NETWORK'
             WHEN nath_nat_id IS NOT NULL THEN --'Area Network'
                                              'NETWORK'
             ELSE -- Unknown - use theme table
                  'UNKNOWN'
           END
             AS source
          ,CASE
             WHEN nith_nit_id IS NOT NULL THEN --'Asset'
               nith_nit_id
             WHEN nnth_nlt_id IS NOT NULL THEN --'Linear Network'
               (SELECT nlt_nt_type
                  FROM nm_linear_types
                 WHERE nlt_id = nnth_nlt_id)
             WHEN nath_nat_id IS NOT NULL THEN --'Area Network'
               (SELECT nat_nt_type
                  FROM nm_area_types
                 WHERE nat_id = nath_nat_id)
             ELSE
               -- Unknown - use theme table
               'UNKNOWN'
           END
             AS source_type
          ,nth_label_column
      FROM nm_themes_all
          ,nm_inv_themes
          ,nm_nw_themes
          ,nm_area_themes
     WHERE     nth_theme_id = nith_nth_theme_id(+)
           AND nth_theme_id = nnth_nth_theme_id(+)
           AND nth_theme_id = nath_nth_theme_id(+)
           AND nth_theme_id = p_theme_id
           AND rownum = 1
    -- 1 row should be returned but sometimes there can be
    -- multiple nm_inv_theme records that would cause this to crash.
    ORDER BY 1;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_version
    RETURN VARCHAR2
  IS
  BEGIN
    RETURN g_sccsid;
  END get_version;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_body_version
    RETURN VARCHAR2
  IS
  BEGIN
    RETURN g_body_sccsid;
  END get_body_version;


FUNCTION get_inv_query_meaning (
  pi_inv_type      IN VARCHAR2
, pi_attrib_name   IN VARCHAR2
, pi_value         IN VARCHAR2)
  RETURN VARCHAR2
IS
  l_rec_nita          nm_inv_type_attribs%ROWTYPE;
  l_qry               nm3type.max_varchar2;
  l_id                nm3type.max_varchar2;
  l_num_length        VARCHAR2 ( 50 );
  l_raise_len_error   BOOLEAN;
  l_length            NUMBER;
  retval              nm3type.max_varchar2;
--
BEGIN
  --
  -- If the value passed in is null then just exit
  --
  IF pi_value IS NULL
  THEN
    RETURN NULL;
  END IF;

  --
  l_rec_nita :=  Nm3get.get_ita ( pi_ita_inv_type      => pi_inv_type
                                , pi_ita_attrib_name   => pi_attrib_name
                                , pi_raise_not_found   => FALSE );
  --
  l_qry := Nm3inv.build_ita_lov_sql_string ( pi_ita_inv_type                 => pi_inv_type
                                           , pi_ita_attrib_name              => pi_attrib_name
                                           , pi_include_bind_variable        => TRUE
                                           , pi_replace_bind_variable_with   => NULL );
  --
  -- if we have a bind variable then re-build the query string to use the bind variable value passed in to our procedure
  --
  IF Nm3flx.extract_bind_variable ( l_qry, 1 ) IS NOT NULL
  THEN
    l_qry := Nm3inv.build_ita_lov_sql_string ( pi_ita_inv_type                 => pi_inv_type
                                             , pi_ita_attrib_name              => pi_attrib_name
                                             , pi_include_bind_variable        => FALSE
                                             , pi_replace_bind_variable_with   => NULL );
  END IF;
--
  IF l_qry IS NOT NULL
  THEN
    BEGIN
      Nm3extlov.validate_lov_value ( p_statement    => l_qry
                                   , p_value        => pi_value
                                   , p_meaning      => retval
                                   , p_id           => l_id
                                   , pi_match_col   => 3 ); -- important to match on the correct column in the sql query string
    --  po_value := l_id;

    EXCEPTION
      WHEN OTHERS
      THEN
        Hig.
        raise_ner (
                    pi_appl                 => 'NET'
                  , pi_id                   => 389
                  , pi_supplementary_info   =>   CHR ( 10 )
                                              || l_rec_nita.ita_scrn_text
                                              || CHR ( 10 )
                                              || Nm3flx.string ( pi_value ) );
    END;
  END IF;
  RETURN retval;
END get_inv_query_meaning;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION num_result_rows
    RETURN PLS_INTEGER
  IS
    CURSOR get_rows
    IS
      SELECT count(*) FROM nm_locator_results;

    l_count_rows  PLS_INTEGER;
  BEGIN
    OPEN get_rows;

    FETCH get_rows INTO l_count_rows;

    CLOSE get_rows;

    RETURN l_count_rows;
  END num_result_rows;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE add(p_text IN VARCHAR2)
  IS
  BEGIN
    nm3ddl.append_tab_varchar(l_sql, p_text);
    DBMS_OUTPUT.put_line(p_text);
  -- l_sql := l_sql || l_text || CHR(10);
  END add;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE clear_sql
  IS
  BEGIN
    l_sql.delete;
  END clear_sql;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE debug_sql
  IS
  BEGIN
    nm3tab_varchar.debug_tab_varchar(l_sql);
  END debug_sql;

FUNCTION get_inv_domain_meaning(pi_domain IN NM_INV_ATTRI_LOOKUP_ALL.ial_domain%TYPE
                               ,pi_value  IN NM_INV_ATTRI_LOOKUP_ALL.ial_value%TYPE
                               ) RETURN NM_INV_ATTRI_LOOKUP_ALL.ial_meaning%TYPE IS
BEGIN

RETURN nm3inv.get_inv_domain_meaning(pi_domain
                                    ,pi_value);
EXCEPTION
WHEN OTHERS THEN
RETURN NULL;
END;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE build_sql(
    p_source_table     VARCHAR2
   ,p_source_pk_col    VARCHAR2
   ,p_source           VARCHAR2
   ,p_source_type      VARCHAR2
   ,p_pk_id            VARCHAR2
   ,p_label_column     nm_themes_all.nth_label_column%TYPE)
  IS
    --
    CURSOR ft_asset_attrib_cur(
      p_type             VARCHAR2
     ,p_label_column     nm_themes_all.nth_label_column%TYPE
     ,p_source_pk_col    VARCHAR2)
    IS
      SELECT attrib_name
            ,textname
            ,domain_meaning
            ,query_meaning
            ,datatype
        FROM (SELECT ita_attrib_name attrib_name
                    ,ita_scrn_text textname
                    ,ita_id_domain domain_meaning
                    ,ita_query query_meaning
                    ,ita_format datatype
                    ,ita_disp_seq_no
                FROM nm_inv_type_attribs, nm_inv_types
               WHERE     ita_inv_type = p_type
                     AND ita_inv_type = nit_inv_type
                     AND ita_displayed = 'Y'
                     AND ita_format IN ('VARCHAR2', 'CHAR', 'NUMBER', 'DATE')
                     AND ita_attrib_name <> p_source_pk_col
                     AND ita_attrib_name <> p_label_column
              UNION
              SELECT p_source_pk_col
                    ,'Primary Key'
                    ,NULL
                    ,NULL
                    ,'VARCHAR2'
                    ,-10
                FROM dual
              UNION
              SELECT p_label_column
                    ,'Description'
                    ,NULL
                    ,NULL
                    ,'VARCHAR2'
                    ,-9
                FROM dual
               WHERE p_label_column <> p_source_pk_col)
      ORDER BY ita_disp_seq_no;

    --
    CURSOR asset_attrib_cur(p_type VARCHAR2)
    IS
      SELECT attrib_name
            ,textname
            ,domain_meaning
            ,query_meaning
            ,datatype
        FROM (SELECT ita_attrib_name attrib_name
                    ,ita_scrn_text textname
                    ,ita_id_domain domain_meaning
                    ,ita_query query_meaning
                    ,ita_format datatype
                    ,ita_disp_seq_no
                FROM nm_inv_type_attribs, nm_inv_types
               WHERE     ita_inv_type = p_type
                     AND ita_inv_type = nit_inv_type
                     AND ita_displayed = 'Y'
                     AND ita_format IN ('VARCHAR2', 'CHAR', 'NUMBER', 'DATE')
              UNION
              SELECT 'iit_ne_id'
                    ,'Asset Id'
                    ,NULL
                    ,NULL
                    ,'VARCHAR2'
                    ,-10
                FROM dual
              UNION
              SELECT 'iit_inv_type'
                    ,'Asset Type'
                    ,NULL
                    ,NULL
                    ,'VARCHAR2'
                    ,-9
                FROM dual
              UNION
              SELECT 'iit_start_date'
                    ,'Start Date'
                    ,NULL
                    ,NULL
                    ,'DATE'
                    ,-8
                FROM dual
              UNION
              SELECT 'iit_end_date'
                    ,'End Date'
                    ,NULL
                    ,NULL
                    ,'DATE'
                    ,-7
                FROM dual
              UNION
              SELECT 'iit_admin_unit'
                    ,'Admin Unit'
                    ,NULL
                    ,NULL
                    ,'VARCHAR2'
                    ,-6
                FROM dual
              UNION
              SELECT 'iit_x_sect'
                    ,'X Section'
                    ,NULL
                    ,NULL
                    ,'VARCHAR2'
                    ,-5
                FROM dual)
      ORDER BY ita_disp_seq_no;
    --
    CURSOR network_attrib_cur(p_type VARCHAR2)
    IS
      SELECT attrib_name
           , textname
           , NULL query_meaning
           , domain_meaning
           , datatype
        FROM
     (SELECT ntc_column_name attrib_name
           , ntc_prompt textname
           , ntc_domain domain_meaning
           , ntc_column_type datatype
           , ntc_seq_no
        FROM nm_type_columns c
       WHERE     ntc_displayed = 'Y'
             AND ntc_nt_type = p_type
             AND ntc_column_type IN ('VARCHAR2', 'CHAR', 'NUMBER', 'DATE')
       UNION
      SELECT 'ne_unique'
           , 'Network Asset Id'
           , NULL
           , 'NUMBER'
           , -10
        FROM dual
      UNION
      SELECT 'ne_descr'
           , 'Description'
           , NULL
           , 'VARCHAR2'
           , -9
        FROM dual)
      ORDER BY ntc_seq_no;
    --
    CURSOR unknown_attrib_cur(p_table_name VARCHAR2)
    IS
      SELECT column_name attrib_name
            ,initcap(replace(column_name,'_',' ')) textname
            ,NULL domain_meaning
            ,NULL query_meaning
            ,data_type datatype
        FROM user_tab_cols
       WHERE table_name = p_table_name
             AND data_type IN ('VARCHAR2', 'CHAR', 'NUMBER', 'DATE')
             and hidden_column = 'NO'
      ORDER BY column_id;

    --
    l_attrib_name    nm3type.tab_varchar30;
    l_textname       nm3type.tab_varchar30;
    l_query_meaning  nm3type.tab_varchar4000;
    l_domain_meaning nm3type.tab_varchar30;
    l_datatype       nm3type.tab_varchar30;
  --
  BEGIN
    --
    CASE p_source
      WHEN 'ASSET' THEN
        --
        IF p_source_table = 'NM_INV_ITEMS' THEN
          OPEN asset_attrib_cur(p_source_type);
          FETCH asset_attrib_cur
          BULK COLLECT INTO l_attrib_name, l_textname, l_domain_meaning, l_query_meaning, l_datatype;
          CLOSE asset_attrib_cur;
        ELSE
          OPEN ft_asset_attrib_cur(p_source_type
                                  ,p_label_column
                                  ,p_source_pk_col);

          FETCH ft_asset_attrib_cur
          BULK COLLECT INTO l_attrib_name, l_textname, l_domain_meaning, l_query_meaning, l_datatype;

          CLOSE ft_asset_attrib_cur;
        END IF;
      --
      WHEN 'NETWORK' THEN
        --
        OPEN network_attrib_cur(p_source_type);

        FETCH network_attrib_cur
        BULK COLLECT INTO l_attrib_name, l_textname, l_domain_meaning, l_query_meaning, l_datatype;

        CLOSE network_attrib_cur;
      --
      WHEN 'UNKNOWN' THEN
        --
        OPEN unknown_attrib_cur(p_source_table);

        FETCH unknown_attrib_cur
        BULK COLLECT INTO l_attrib_name, l_textname, l_domain_meaning, l_query_meaning, l_datatype;

        CLOSE unknown_attrib_cur;
    --
    END CASE;

    --
    add('BEGIN');
    add('SELECT CAST');
    add('        ( COLLECT (nm_code_name_meaning_type');
    add('                     (Attribute');
    add('                    , Value');
    add('                    , Domain))');
    add('               AS  nm_code_name_meaning_tbl )');
    add('  INTO nm3info_tool.g_return_value');
    add('  FROM');
    add('   (WITH asset AS');
    add('      (');

    --
/*    CASE p_source
      WHEN 'NETWORK' THEN
        --
        add('SELECT ne_unique');
        add(', ne_descr');
      --
      ELSE
        --*/
        add('SELECT');
    --
    --END CASE;

    FOR i IN 1 .. l_attrib_name.count
    LOOP
      --
      IF l_datatype(i) IN ('VARCHAR2', 'CHAR') THEN
        IF i = 1
        --   AND p_source <> 'NETWORK' 
        THEN
          add(' ' || l_attrib_name(i));
        ELSE
          add(', ' || l_attrib_name(i));
        END IF;
      ELSIF l_datatype(i) = 'NUMBER' THEN
        IF i = 1
      --     AND p_source <> 'NETWORK' 
        THEN
          add(
            '  TO_CHAR(' || l_attrib_name(i) || ') AS ' || l_attrib_name(i));
        ELSE
          add(
            ', TO_CHAR(' || l_attrib_name(i) || ') AS ' || l_attrib_name(i));
        END IF;
      ELSIF l_datatype(i) = 'DATE' THEN
        IF i = 1
        --   AND p_source <> 'NETWORK' 
        THEN
          add('  TO_CHAR(' || l_attrib_name(i) || ', ''' || c_date_format
              || ''') AS ' || l_attrib_name(i));
        ELSE
          add(', TO_CHAR(' || l_attrib_name(i) || ', ''' || c_date_format
              || ''') AS ' || l_attrib_name(i));
        END IF;
      END IF;
    --
    END LOOP;

    --
    add('FROM ' || p_source_table);

    --
    IF p_source_table = 'NM_INV_ITEMS' THEN
      add('WHERE IIT_NE_ID = ' || p_pk_id);
    ELSIF p_source_table = 'NM_ELEMENTS' THEN
      add('WHERE NE_ID = ' || p_pk_id);
    ELSE
      add('WHERE ' || p_source_pk_col || ' = ''' || p_pk_id || '''');
    END IF;
    --
    add(')');
    --
    FOR i IN 1 .. l_attrib_name.count
    LOOP
      --
      add('SELECT ''' || l_textname(i) || ''' as Attribute');
      add(' , substr(to_char(' || l_attrib_name(i) || '),0,500) as Value');

      --ADD('     , ''Domain'' as "Domain"');
      IF l_query_meaning(i) IS NOT NULL THEN
        CASE p_source
          WHEN 'ASSET' THEN
            add(', nm3info_tool.get_inv_query_meaning(''' || p_source_type ||
                ''', ''' || l_attrib_name(i) || ''', ' || l_attrib_name(i) || ' ) as Domain');
          WHEN 'NETWORK' THEN
          /*  add(', nm3info_tool.get_inv_query_meaning(''' || p_source_type ||
                ''', ''' || l_attrib_name(i) || ''', ' || l_attrib_name(i) || ' ) as Domain');*/
            add(', NULL as Domain');
          WHEN 'UNKNOWN' THEN
            add(', NULL as Domain');
        END CASE;
        null;
      ELSIF l_domain_meaning(i) IS NOT NULL THEN
        CASE p_source
          WHEN 'ASSET' THEN
            add(', nm3info_tool.get_inv_domain_meaning(''' || l_domain_meaning(i) ||
                ''', ' || l_attrib_name(i) || ') as Domain');
          WHEN 'NETWORK' THEN
            add(', nm3flx.validate_domain_value(''' || l_domain_meaning(i) ||
                ''', ' || l_attrib_name(i) || ')  as Domain');
          WHEN 'UNKNOWN' THEN
            add(', NULL as Domain');
        END CASE;
      ELSE
        add(', NULL as Domain');
      END IF;

      --
      add('  FROM asset');

      --
      IF i < l_attrib_name.count THEN
        add('UNION ALL');
      ELSE
        add(');');
      END IF;
    --
    END LOOP;

    --
    add('END;');
  --
  END build_sql;

  FUNCTION get_item_data(pi_primary_key VARCHAR2, pi_theme_id VARCHAR2)
    RETURN nm_code_name_meaning_tbl
  AS
    --
    l_theme_id       nm_themes_all.nth_theme_id%TYPE;
    l_theme_name     nm_themes_all.nth_theme_name%TYPE;
    l_table_name     nm_themes_all.nth_table_name%TYPE;
    l_source_table   VARCHAR2(50);
    l_source         VARCHAR2(50);
    l_source_type    VARCHAR2(50);
    l_source_pk_col  nm_themes_all.nth_pk_column%TYPE;
    l_label_column   nm_themes_all.nth_label_column%TYPE;
  --
  BEGIN
    clear_sql;

    --
    OPEN check_tables_cur(pi_theme_id);

    FETCH check_tables_cur
      INTO l_theme_name
          ,l_table_name
          ,l_source_pk_col
          ,l_source_table
          ,l_source
          ,l_source_type
          ,l_label_column;

    CLOSE check_tables_cur;

    --
    build_sql(p_source_table    => l_source_table
             ,p_source_pk_col   => l_source_pk_col
             ,p_source          => l_source
             ,p_source_type     => l_source_type
             ,p_pk_id           => pi_primary_key
             ,p_label_column    => l_label_column);
    --
    nm3ddl.execute_tab_varchar(l_sql);
    --
    RETURN nm3info_tool.g_return_value;
  END get_item_data;
--
END nm3info_tool;
/