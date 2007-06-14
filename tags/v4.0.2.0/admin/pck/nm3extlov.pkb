Create OR REPLACE PACKAGE BODY nm3extlov  AS
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3extlov.pkb	1.12 09/05/06
--       Module Name      : nm3extlov.pkb
--       Date into SCCS   : 06/09/05 12:18:17
--       Date fetched Out : 07/06/13 14:11:31
--       SCCS Version     : 1.12
--
--
--   Author : Nik Stace
--
--   Extended List of Values package
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2000
-----------------------------------------------------------------------------
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)nm3extlov.pkb	1.12 09/05/06"';
--  g_body_sccsid is the SCCS ID for the package body
-----------------------------------------------------------------------------
--
--all global package variables here
--
  TYPE var_tab IS TABLE OF varchar2(500) INDEX BY binary_integer;

  lov_table var_tab;
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
  PROCEDURE lov (p_statement IN varchar2, p_arg IN number, p_lov IN OUT rc_lov) IS
  BEGIN
    OPEN p_lov FOR p_statement USING p_arg;
  EXCEPTION
     WHEN others
        THEN          
            hig.raise_ner(pi_appl               => 'HIG'
                         ,pi_id                 => 83
                         ,pi_supplementary_info => chr(10)||p_statement);
  END;
--
-----------------------------------------------------------------------------
--
  PROCEDURE delete_table IS
  BEGIN
	lov_table.DELETE;
  END;
--
-----------------------------------------------------------------------------
--
  PROCEDURE insert_record(p_rec_num IN number, p_value IN varchar2) IS
  BEGIN
	lov_table(p_rec_num) := p_value ;
  END;
--
-----------------------------------------------------------------------------
--
  FUNCTION count_records RETURN number IS
  BEGIN
	RETURN lov_table.COUNT;
  END;
--
-----------------------------------------------------------------------------
--
  FUNCTION retrieve_record (p_rec_num IN number) RETURN varchar2 IS
  BEGIN
	RETURN lov_table(p_rec_num);
  END;
--
-----------------------------------------------------------------------------
--
  FUNCTION mid(pi_string    IN varchar2
            ,pi_start_pos IN number
            ,pi_end_pos   IN number
            ) RETURN varchar2 IS
--
   l_reqd_string_length number := pi_end_pos - pi_start_pos + 1;
--
  BEGIN
--
     RETURN SUBSTR(pi_string,pi_start_pos,l_reqd_string_length);
--
  END mid;
--
-----------------------------------------------------------------------------
--
  FUNCTION string(pi_string IN varchar2) RETURN varchar2 IS
  BEGIN
--
    RETURN CHR(39)||pi_string||CHR(39); -- Return 'pi_string'
--
  END string;
--
-----------------------------------------------------------------------------
-- 
  PROCEDURE validate_lov_value(p_statement  IN     varchar2
                              ,p_value      IN     varchar2
                              ,p_meaning       OUT varchar2
                              ,p_id            OUT varchar2
                              ,pi_match_col IN     pls_integer DEFAULT 1
                              ) IS

    e_match_col_not_in_query EXCEPTION;

    TYPE typ_cs_sql IS REF CURSOR; -- define weak REF CURSOR type
    cs_sql typ_cs_sql; -- declare cursor variable

    v_statement varchar2(2000) := p_statement ;
    l_statement_b4_where_added varchar2(2000);	

    l_group_by_pos pls_integer;
    l_group_by     nm3type.max_varchar2;
    l_order_by_pos pls_integer;
    l_order_by     nm3type.max_varchar2;
    l_equal_test   nm3type.max_varchar2;


    v_value varchar2(2000);
    v_meaning varchar2(2000) ;
    v_id varchar2(2000) ;

    l_found_records boolean ;

    l_cols_tab nm3type.tab_varchar30;

    l_statement_has_where boolean ;

  BEGIN

    IF p_statement IS NOT NULL
    THEN
      l_cols_tab := nm3flx.get_cols_from_sql(p_sql => p_statement);

      IF NOT(l_cols_tab.EXISTS(pi_match_col))
      THEN
        RAISE e_match_col_not_in_query;
      END IF;

      --does statement contain a group by clause?
      l_group_by_pos := INSTR(UPPER(v_statement), 'GROUP BY');

      IF l_group_by_pos > 0
      THEN
        --strip group by
        l_group_by := SUBSTR(v_statement, l_group_by_pos);

        v_statement := SUBSTR(v_statement, 1, LENGTH(v_statement) - LENGTH(l_group_by));
      END IF;


-- GJ 24-MAY-2005
-- Strip off order by as well
--
      --does statement contain a group by clause?
      l_order_by_pos := INSTR(UPPER(v_statement), 'ORDER BY');

      IF l_order_by_pos > 0
      THEN
        --strip group by
        l_order_by := SUBSTR(v_statement, l_order_by_pos);

        v_statement := SUBSTR(v_statement, 1, LENGTH(v_statement) - LENGTH(l_order_by));
      END IF;

      IF INSTR(v_statement,'1 =:x') > 0
      THEN
        v_statement := REPLACE(v_statement , '1 =:x', '1 =1');
      END IF;
	  
	  
      --    GJ 25-MAY-2005
      --    found that rather complex select statements being passed in with occurrances
      --    of 'WHERE' and 'AND' confusing the logic I've commented out
      --    Had to work an alternative approach - kind of a 'suck it and see'
      --    i.e. try with a 'WHERE' and if that doesn't work then try with an 'AND'

      -- FJF reinstated this code to do the naive thing and then check for invalid stuff because
      -- it was being called thousands of times and failing
      l_statement_b4_where_added := v_statement;
      l_statement_has_where := INSTR(UPPER(v_statement), 'WHERE') > 0 ;
      l_equal_test := l_cols_tab(pi_match_col) || ' = :1' ;
      IF l_statement_has_where
      THEN
        v_statement := v_statement || ' AND ' || l_equal_test ;
      ELSE
        v_statement := v_statement || ' WHERE ' || l_equal_test ;
      END IF;

      -- If we tried an and it it failed then we must need a where after all
      IF NOT nm3flx.is_select_statement_valid(v_statement) and l_statement_has_where THEN
        v_statement := l_statement_b4_where_added || ' WHERE ' || l_equal_test ;
      END IF;

      -- Just let it fail otherwise

      v_statement := v_statement|| ' ' || l_group_by;
      
      --
      -- Assume that the restriction on column = value passed in 
      -- will be added to the query where clause as the first part e.g. as a 'WHERE'
      --
	  
--nm_debug.debug_on;
--nm_debug.debug('v_statement='||v_statement);
--nm_debug.debug_off;

      BEGIN
        -- Changed to use bind variable, less parsing hopefully
        OPEN cs_sql FOR v_statement USING p_value ; 
        FETCH cs_sql INTO v_value ,v_meaning,v_id ;
        l_found_records := cs_sql%found ;
        CLOSE cs_sql;

      EXCEPTION
        WHEN others
        THEN
            hig.raise_ner(pi_appl               => 'HIG'
                         ,pi_id                 => 83
                         ,pi_supplementary_info => chr(10)||v_statement);
--          g_flex_validation_exc_code := -20699;
--          g_flex_validation_exc_msg := SQLERRM||' - '||v_statement;
--          RAISE g_flex_validation_exception;
      END;

      IF not l_found_records
      THEN
        g_flex_validation_exc_code := -20699;
        g_flex_validation_exc_msg := SQLERRM || ' - ' || v_statement;
        RAISE g_flex_validation_exception;
      END IF;

      p_meaning := v_meaning;
      p_id := v_id;
    ELSE
      p_meaning := NULL;
      p_id := NULL;
    END IF;
--
  EXCEPTION
    WHEN e_match_col_not_in_query
    THEN
      hig.raise_ner(pi_appl               => nm3type.c_net
                   ,pi_id                 => 28
                   ,pi_supplementary_info => 'match_col_not_in_query (' || pi_match_col || ')');

    WHEN g_flex_validation_exception
    THEN
      Raise_Application_Error(g_flex_validation_exc_code
                             ,g_flex_validation_exc_msg
                                     ||':'||p_statement
                                     ||':'||p_value);

  END;
--
-----------------------------------------------------------------------------
--
  PROCEDURE validate_gen_lov_value	(	p_statement IN varchar2
						, 	p_value IN varchar2
						,	p_meaning OUT varchar2
						,	p_id OUT varchar2) IS

	TYPE typ_cs_sql IS REF CURSOR; -- define weak REF CURSOR type
	cs_sql typ_cs_sql; -- declare cursor variable

	v_statement	varchar2(2000) := p_statement ;

	v_value	varchar2(2000) ;
	v_meaning	varchar2(2000) ;
	v_id		varchar2(2000) ;
	l_found_records boolean ;
  
	v_column_name varchar2(30);

	v_first_pos number := INSTR(v_statement,',') + 1 ;
	v_second_pos number := INSTR(v_statement,',',1,2) -1;

BEGIN

  IF p_statement IS NOT NULL THEN
    v_column_name := LTRIM(RTRIM(mid(v_statement,v_first_pos ,v_second_pos )));
    IF INSTR(UPPER(v_statement),' WHERE ') > 0 THEN
      v_statement := v_statement||' AND '||v_column_name||' = :1 ' ;
    ELSE
      v_statement := v_statement||' WHERE '||v_column_name||' = :1 ' ;
    END IF;
    
    BEGIN
      -- Use bind variable, less parsing and no need to call
      -- nm3flx.wibble_my_hamster
      OPEN cs_sql FOR v_statement using p_value ;
      FETCH cs_sql INTO v_id ,v_value ,v_meaning;
      l_found_records := cs_sql%found ;
      CLOSE cs_sql;
    EXCEPTION
      WHEN others THEN
        g_flex_validation_exc_code := -20699;
        g_flex_validation_exc_msg := SQLERRM||' - '||v_statement;
        RAISE g_flex_validation_exception;
    END;
    IF not l_found_records
    then
      g_flex_validation_exc_code := -20698;
      g_flex_validation_exc_msg := 'no ROWS selected BY query SQL-'||v_statement;
      RAISE g_flex_validation_exception;
    END IF;
    
    p_meaning := v_meaning;
    p_id := v_id;
  ELSE
    p_meaning := NULL;
    p_id := NULL;
  END IF;
END;
--
-----------------------------------------------------------------------------
--
END nm3extlov ;
/
