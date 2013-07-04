CREATE OR REPLACE PACKAGE BODY nm3extlov  AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3extlov.pkb-arc   2.6   Jul 04 2013 15:33:48   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3extlov.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:33:48  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:10  $
--       Version          : $Revision:   2.6  $
--       Based on SCCS version : 1.12
-------------------------------------------------------------------------
--
--   Author : Nik Stace
--
--   Extended List of Values package
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.6  $';
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

    v_statement varchar2(4000) := p_statement ;
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
        -- TASK 0109336
        -- Added following code to avoid error column ambiguously defined when same column is repeated in the SQL statement 
	  DECLARE
	  --	
          l_sql Varchar2(4000) := p_statement;
          l_ori_sql Varchar2(4000) := l_sql ;
          TYPE col IS TABLE OF Varchar(100) INDEX BY BINARY_INTEGER;
          l_col_tab col;       
          l_cnt number := 0 ;
          l_alias Varchar2(500) ;
          l_pos Number;
          l_cols_tab nm3type.tab_varchar30; 
          l_distinct Boolean ; 
        --   
	  BEGIN
	  --
           l_distinct := Substr(Trim(Substr(Upper(l_sql),7)),1,8) Like 'DISTINCT%';
           IF l_distinct
           THEN
               l_sql := Ltrim(Substr(l_sql,8));
               l_sql  := Substr(l_sql,Instr(l_sql,' ',1,1));
               l_sql := Substr(l_sql,1,Instr(Upper(l_sql),'FROM')-(1));
           ELSE
               l_sql := Substr(l_sql,8,Instr(Upper(l_sql),'FROM')-(1+8));    
           END IF;
           LOOP
              l_cnt := l_cnt + 1;
              l_pos := Instr(l_sql,',');
              IF l_pos > 0 
              THEN        
                  l_alias  := Ltrim(substr(l_sql, 1,l_pos-1))||' ' ;
                  IF Nvl(Length(Replace(Substr(l_alias,(Instr(l_alias,' '))),' ')),0) > 0
                  THEN             
                      l_col_tab(l_cnt) :=  l_alias ; 
                  ELSE
                      IF l_cnt = 1 
                      THEN
                          l_col_tab(l_cnt) := Substr(l_sql, 1,l_pos-1)||' Identifier ';
                      ELSIF l_cnt = 2 
                      THEN 
                          l_col_tab(l_cnt) :=  Substr(l_sql, 1,l_pos-1)||' Description ';
                      ELSE
                          l_col_tab(l_cnt) :=  Substr(l_sql, 1,l_pos-1)||' Value ';
                      END IF ;
                  END IF ;    
                  l_sql := Substr(l_sql,l_pos+1);
              ELSE
                  l_alias  := Ltrim(l_sql);
                  IF Instr(l_alias,' ') > 0
                  THEN  
                      IF Nvl(Length(Replace(Substr(l_alias,(Instr(l_alias,' '))),' ')),0) > 0
                      THEN
                          l_col_tab(l_cnt) :=  l_alias ; --Substr(l_alias,(Instr(l_alias,' ')));
                      ELSE
                          l_col_tab(l_cnt) :=  l_sql||' Value ';
                      END IF ;        
                  ELSE
                       l_col_tab(l_cnt) :=  l_sql||' Value ';
                  END IF  ;
                  Exit;     
              END IF ;
           END LOOP ;
           IF l_distinct 
           THEN
               l_sql:= 'SELECT DISTINCT ';
           ELSE
               l_sql:= 'SELECT ';
           END IF ;
           FOR i in 1..l_col_tab.count 
           LOOP
               IF i = 1 
               THEN
                   l_sql := l_sql ||l_col_tab(i);
               ELSIF i = 2 
               THEN 
                   l_sql := l_sql ||' ,'||l_col_tab(i);
               ELSE
                   l_sql := l_sql ||' ,'||l_col_tab(i);
               END IF;
           END LOOP;
           v_statement := l_sql ||' '||Substr(l_ori_sql,Instr(Upper(l_ori_sql),'FROM'));
           l_sql := 'SELECT';
     	     --get and add columns to query
    	     l_cols_tab := nm3flx.get_cols_from_sql(p_sql => v_statement);
           FOR l_i IN 1..l_cols_tab.COUNT
	     LOOP
	         l_sql := l_sql 
	    	 	           || Chr(10) || '  ' || l_cols_tab(l_i) || ',';
	     END LOOP;
           v_statement := Substr(l_sql, 1, Length(l_sql) - 1)|| Chr(10) || ' FROM'
	  		         || Chr(10) || '  (' || v_statement  || ')' ;  
        END ;
        -- END TASK TASK 0109336
      l_cols_tab := nm3flx.get_cols_from_sql(p_sql => v_statement);

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

      -- If we tried an and it it failed then we must need a where after all
      v_statement := v_statement|| ' ' || l_group_by||' '||l_order_by;

      --IF l_statement_has_where
      --THEN
      --  v_statement := v_statement || ' AND ' || l_equal_test ;
      --ELSE
        v_statement := v_statement || ' WHERE ' || l_equal_test ;
      --END IF;

      IF NOT nm3flx.is_select_statement_valid(v_statement) and l_statement_has_where THEN
        v_statement := l_statement_b4_where_added || ' WHERE ' || l_equal_test ;
      END IF;

      -- Just let it fail otherwise
      
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
