CREATE OR REPLACE PACKAGE BODY HIGHWAYS.sde_util AS
--
---------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sde_util.pkb-arc   1.7   Feb 23 2018 07:53:56   Upendra.Hukeri  $
--       Module Name      : $Workfile:   sde_util.pkb  $
--       Date into PVCS   : $Date:   Feb 23 2018 07:53:56  $
--       Date fetched Out : $Modtime:   Feb 22 2018 11:50:54  $
--       PVCS Version     : $Revision:   1.7  $
--
--   Author : Upendra Hukeri
--
---------------------------------------------------------------------------------------------------
-- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
---------------------------------------------------------------------------------------------------
--
--
-- all global package variables here
--
   g_body_sccsid      CONSTANT VARCHAR2(30)  := '"$Revision:   1.7  $"';
   g_package_name     CONSTANT VARCHAR2(30)  := 'sde_util';
   g_insuff_privs_msg CONSTANT VARCHAR2(100) := 'you do not have privileges to perform this action';
   --
   TYPE g_number_array IS TABLE OF sde_tables.st_table_id%TYPE
   INDEX BY BINARY_INTEGER;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION get_version
RETURN VARCHAR2
IS
BEGIN
	RETURN g_sccsid;
END get_version;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION get_body_version
RETURN VARCHAR2
IS
BEGIN
	RETURN g_body_sccsid;
END get_body_version;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION get_error_message(
                          p_plsql_unit_name IN VARCHAR2
				          )
RETURN VARCHAR2
IS
	v_back_trace VARCHAR2(32767);
	start_pos    NUMBER;
	end_pos      NUMBER;
BEGIN
	v_back_trace := SUBSTR(dbms_utility.format_error_backtrace(), 1, 32767);
	start_pos    := INSTR(v_back_trace, UPPER(g_package_name)) + LENGTH(g_package_name) + 3;
	end_pos      := INSTR(v_back_trace, CHR(10), start_pos);
	--
	RETURN SQLERRM || ' - (' || LOWER(g_package_name) || '.' || LOWER(p_plsql_unit_name) || ', ' || REPLACE(SUBSTR(v_back_trace, start_pos, end_pos), CHR(10), '') || ')';
END get_error_message;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION is_admin_user
RETURN VARCHAR2
IS
    v_result VARCHAR2(32767);
BEGIN
	SELECT 'Y'
	  INTO v_result
      FROM user_role_privs
     WHERE granted_role = 'SDE_ADMIN'
       AND username     = USER;
	--
	RETURN v_result;
EXCEPTION
	WHEN OTHERS THEN
		RETURN 'N';
END is_admin_user;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION check_for_invalid_chars(
                                p_user_input_val IN VARCHAR2
								)
RETURN CHAR
IS
BEGIN
	IF REGEXP_REPLACE(p_user_input_val,  '[^a-zA-Z0-9_$#]+', '') <> p_user_input_val THEN
		RETURN 'N';
	END IF;
	--
	RETURN 'Y';
END check_for_invalid_chars;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION validate_table_name(
                            p_table_name IN  sde_tables.st_table_name%TYPE,
							p_table_id   OUT sde_tables.st_table_id%TYPE
							)
RETURN VARCHAR2
IS
	v_result VARCHAR2(1);
BEGIN
    IF p_table_name IS NULL THEN
	    RETURN 'NULL table/view name';
	END IF;
	--
	IF check_for_invalid_chars(p_table_name) <> 'Y' THEN
		RETURN 'table/view name with special characters not allowed - ' || p_table_name || ' (allowed: A-Z a-z 0-9 _ $ #)';
	END IF;
	--
	SELECT 'Y',
	       st_table_id
	  INTO v_result,
	       p_table_id
	  FROM all_objects ao,
	       sde_tables  st
	 WHERE ao.object_name = st.st_table_name
	   AND ao.object_name = UPPER(p_table_name)
	   AND ao.object_type IN('TABLE', 'VIEW');
	--
	RETURN 'Y';
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RETURN 'table/view does not exist or access to the table/view is restricted - ' || UPPER(p_table_name);
	WHEN OTHERS THEN
		RETURN get_error_message('validate_table_name');
END validate_table_name;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION validate_table_name(
                            p_table_name IN sde_tables.st_table_name%TYPE
							)
RETURN VARCHAR2
IS
    v_table_id sde_tables.st_table_id%TYPE;
BEGIN
    RETURN validate_table_name(p_table_name, v_table_id);
END validate_table_name;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION validate_where_clause_unique(
                                     p_where_clause_unique IN  sde_where.sw_unique%TYPE,
									 p_table_name          IN  sde_tables.st_table_name%TYPE DEFAULT NULL,
									 p_where_clause_id     OUT sde_where.sw_where_id%TYPE
									 )
RETURN VARCHAR2
IS
	v_result VARCHAR2(32767);
BEGIN
	IF check_for_invalid_chars(p_where_clause_unique) <> 'Y' THEN
		RETURN 'WHERE clause unique with special characters not allowed (allowed: A-Z a-z 0-9 _ $ #)';
	END IF;
	--
	IF p_table_name IS NOT NULL THEN
	    v_result := validate_table_name(p_table_name);
	    --
	    IF v_result <> 'Y' THEN
		    RETURN v_result;
	    END IF;
	    --
		SELECT 'Y',
		       sw.sw_where_id
		  INTO v_result,
		       p_where_clause_id
		  FROM sde_where    sw,
			   sde_tables   st,
			   sde_registry sr
		 WHERE sw.sw_where_id          = sr.sr_where_id
		   AND st.st_table_id          = sr.sr_table_id
		   AND UPPER(sw.sw_unique)     = UPPER(p_where_clause_unique)
		   AND UPPER(st.st_table_name) = UPPER(p_table_name);
    ELSE
	    SELECT 'Y',
	           sw.sw_where_id
	      INTO v_result,
	           p_where_clause_id
	      FROM sde_where sw
	     WHERE UPPER(sw.sw_unique) = UPPER(p_where_clause_unique);
	END IF;
	--
	RETURN v_result;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RETURN 'WHERE clause ID - ' || UPPER(p_where_clause_unique) || ' - does not exist or is not registered with table/view - ' || UPPER(p_table_name);
	WHEN OTHERS THEN
		RETURN get_error_message('validate_where_clause_unique');
END validate_where_clause_unique;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION validate_where_clause_unique(
                                     p_where_clause_unique IN sde_where.sw_unique%TYPE,
									 p_table_name          IN sde_tables.st_table_name%TYPE DEFAULT NULL
									 )
RETURN VARCHAR2
IS
	v_where_clause_id sde_where.sw_where_id%TYPE;
BEGIN
    RETURN validate_where_clause_unique(p_where_clause_unique, p_table_name, v_where_clause_id);
END validate_where_clause_unique;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION register_table(
                       p_table_names    IN sde_varchar_array,
                       p_where_uniques IN sde_varchar_array
					   )
RETURN VARCHAR2
IS
	v_result        VARCHAR2(32767);
	v_table_ids     g_number_array;
	v_where_ids     g_number_array;
	v_where_uniques sde_varchar_array := sde_varchar_array();
	v_counter       NUMBER := 1;
BEGIN
    IF is_admin_user <> 'Y' THEN
	    RETURN g_insuff_privs_msg;
	END IF;
	--
    IF p_table_names IS NULL THEN
	    RETURN 'NULL table/view name';
	END IF;
	--
	IF  p_where_uniques IS NOT NULL 
	AND p_where_uniques.COUNT = 1 
	AND p_where_uniques(1)    = '*' 
	THEN
        FOR sw_rec IN (SELECT sw_unique FROM sde_where) LOOP
            v_where_uniques.EXTEND(1);
            --
            v_where_uniques(v_counter) := sw_rec.sw_unique;
            --
            v_counter := v_counter + 1;
        END LOOP;
    ELSE
        v_where_uniques := p_where_uniques;
	END IF;
	--
	FOR i IN 1..p_table_names.COUNT LOOP
		IF check_for_invalid_chars(p_table_names(i)) <> 'Y' THEN
			RETURN 'table/view name with special characters not allowed - ' || UPPER(p_table_names(i)) || ' (allowed: A-Z a-z 0-9 _ $ #)';
		END IF;
		--
		v_result := validate_table_name(p_table_names(i));
		--
		IF v_result = 'Y' THEN
            RETURN 'table/view already registered - ' || p_table_names(i);
		END IF;
		--
		BEGIN
			SELECT 'Y'
			  INTO v_result
			  FROM all_objects ao
			 WHERE ao.object_name = UPPER(p_table_names(i))
			   AND ao.object_type IN('TABLE', 'VIEW');
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
		        RETURN 'table/view does not exist - ' || UPPER(p_table_names(i));
		END;
	END LOOP;
	--
	IF v_where_uniques IS NOT NULL THEN 
        FOR i IN 1..v_where_uniques.COUNT LOOP 
            v_result := validate_where_clause_unique(v_where_uniques(i), NULL, v_where_ids(i)); 
            --
            IF v_result <> 'Y' THEN
                RETURN v_result;
            END IF;
        END LOOP;
    END IF;
	--
	FOR i IN 1..p_table_names.COUNT LOOP
		INSERT INTO sde_tables
		(
			st_table_name
		)
		VALUES
		(
			UPPER(p_table_names(i))
		)
		RETURNING st_table_id 
		     INTO v_table_ids(i);
		--
		BEGIN
			IF v_where_uniques IS NOT NULL THEN 
                FOR j IN 1..v_where_ids.COUNT LOOP
                    BEGIN
                        INSERT INTO sde_registry
                        (
                            sr_table_id,
                            sr_where_id
                        )
                        VALUES
                        (
                            v_table_ids(i),
                            v_where_ids(j)
                        );
                    EXCEPTION
                        WHEN DUP_VAL_ON_INDEX THEN
                            NULL;
                    END;
                END LOOP;
            END IF;
		EXCEPTION
			WHEN DUP_VAL_ON_INDEX THEN
		        NULL;
		END;
	END LOOP;
	--
	COMMIT;
	--
	RETURN 'Y';
EXCEPTION
	WHEN OTHERS THEN
		RETURN get_error_message('register_table');
END register_table;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION update_table(
                     p_table_name    IN sde_tables.st_table_name%TYPE,
                     p_update_action IN VARCHAR2                       DEFAULT 'APPEND',
                     p_where_uniques IN sde_varchar_array
					 )
RETURN VARCHAR2
IS
	v_result              VARCHAR2(32767)             := NULL;
	v_table_id            sde_tables.st_table_id%TYPE;
	v_update_action       VARCHAR2(12)                := UPPER(p_update_action);
	v_where_ids           g_number_array;
	v_validate_wu         BOOLEAN                     := TRUE;
	v_insert_registry     BOOLEAN                     := FALSE;
	v_delete_all_registry BOOLEAN                     := FALSE;
	v_delete_registry     BOOLEAN                     := FALSE;
	v_where_uniques       sde_varchar_array           := sde_varchar_array();
	v_counter             NUMBER                      := 1; 
BEGIN
    IF is_admin_user <> 'Y' THEN
	    RETURN g_insuff_privs_msg;
	END IF;
	--
	IF p_where_uniques IS NULL THEN
        RETURN 'null where id passed';
	END IF;
	--
	IF  p_where_uniques.COUNT = 1 
	AND p_where_uniques(1) = '*' 
	THEN
        v_validate_wu := FALSE;
        --
        FOR sw_rec IN (SELECT sw_unique FROM sde_where) LOOP
            v_where_uniques.EXTEND(1);
            --
            v_where_uniques(v_counter) := sw_rec.sw_unique;
            --
            v_counter := v_counter + 1;
        END LOOP;
    ELSE
        v_where_uniques := p_where_uniques;
	END IF;
	--
	v_result := validate_table_name(p_table_name, v_table_id);
	--
	IF v_result <> 'Y' THEN
		RETURN v_result;
	END IF;
	--
	IF v_update_action = 'APPEND'    THEN
		v_insert_registry := TRUE;
	ELSIF v_update_action = 'INIT'   THEN 
        IF NOT v_validate_wu THEN
            RETURN 'invalid where update action (allowed: append|delete)';
        END IF;
        --
        v_delete_all_registry := TRUE; 
        v_insert_registry     := TRUE; 
    ELSIF v_update_action = 'DELETE' THEN
		v_delete_registry := TRUE;
	ELSE
		RETURN 'invalid where update action (allowed: append|init|delete)';
	END IF;
	--
	FOR i IN 1..v_where_uniques.COUNT LOOP
        v_result := validate_where_clause_unique(v_where_uniques(i), NULL, v_where_ids(i));
        --
        IF v_result <> 'Y' THEN
            RETURN v_result;
        END IF;
	END LOOP;
	--
	IF v_delete_all_registry THEN
        DELETE FROM sde_registry
		 WHERE sr_table_id = v_table_id;
	END IF;
	--
	FOR i IN 1..v_where_ids.COUNT LOOP
		IF v_insert_registry THEN
            INSERT INTO sde_registry
            (
                sr_table_id,
                sr_where_id
            )
		    VALUES
		    (
                v_table_id,
                v_where_ids(i)
		    );
		END IF;
		--
		IF v_delete_registry THEN
            DELETE FROM sde_registry
		     WHERE sr_table_id = v_table_id
		       AND sr_where_id = v_where_ids(i);
        END IF;
	END LOOP; 
	--
	COMMIT;
	--
	RETURN 'Y';
EXCEPTION
	WHEN OTHERS THEN
		RETURN get_error_message('update_table');
END update_table;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION unregister_table(
                         p_table_names IN sde_varchar_array
					     )
RETURN VARCHAR2
IS
	v_result      VARCHAR2(32767)   := NULL;
	v_table_id    g_number_array;
	v_table_names sde_varchar_array := sde_varchar_array();
	v_counter     NUMBER            := 1;
BEGIN
    IF is_admin_user <> 'Y' THEN
	    RETURN g_insuff_privs_msg;
	END IF;
	--
	IF p_table_names IS NULL THEN
        RETURN 'null table name passed';
	END IF;
	--
	IF  p_table_names.COUNT = 1
	AND p_table_names(1)    = '*' 
	THEN
        FOR st_rec IN (SELECT st_table_name FROM sde_tables) LOOP
            v_table_names.EXTEND(1);
            --
            v_table_names(v_counter) := st_rec.st_table_name;
            --
            v_counter := v_counter + 1;
        END LOOP;
    ELSE
        v_table_names := p_table_names;
	END IF;
	--
	FOR i IN 1..v_table_names.COUNT LOOP
		v_result := validate_table_name(v_table_names(i), v_table_id(i));
		--
		IF v_result <> 'Y' THEN
			RETURN v_result;
		END IF;
	END LOOP;
	--
	FOR i IN 1..v_table_id.COUNT LOOP
		DELETE FROM sde_registry
		 WHERE sr_table_id = UPPER(v_table_id(i));
		--
		DELETE FROM sde_tables
		 WHERE st_table_id = UPPER(v_table_id(i));
	END LOOP;
	--
	COMMIT;
	--
	RETURN 'Y';
EXCEPTION
	WHEN OTHERS THEN
		RETURN get_error_message('unregister_table');
END unregister_table;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION validate_column_names(
                              p_table_name   IN  VARCHAR2,
							  p_column_array IN  sde_varchar_2d_array,
							  p_column_alias OUT VARCHAR2
							  )
RETURN VARCHAR2
IS
    v_result         VARCHAR2(32767);
	v_col_array		 sde_varchar_array := sde_varchar_array();
	v_column_alias	 sde_varchar_array;
	v_column_comb 	 VARCHAR2(32767)   := NULL;
	v_comma_pos		 INTEGER		   := 0;
	v_space_pos		 INTEGER		   := 0;
	v_column_name	 VARCHAR2(32767)   := NULL;
	v_col_name_str	 VARCHAR2(32767)   := NULL;
	v_cloumn_str	 VARCHAR2(32767)   := NULL;
	v_column_qry	 VARCHAR2(32767)   := NULL;
	v_column_count	 NUMBER			   := 0;
	v_actual_col_cnt NUMBER			   := 0;
	v_alias_name	 VARCHAR2(32767)   := NULL;
BEGIN
    v_result := validate_table_name(p_table_name);
	--
	IF v_result <> 'Y' THEN
		RETURN v_result;
	END IF;
	--
	IF p_column_array IS NULL THEN
	    RETURN 'NULL column name array';
	END IF;
	--
	FOR i IN 1..p_column_array.COUNT LOOP
		v_column_alias := p_column_array(i);
		v_column_name  := v_column_alias(1);
		v_alias_name   := v_column_alias(2);
		--
		v_col_array.EXTEND(1);
		v_col_array(v_col_array.COUNT) := v_column_name;
		--
		IF check_for_invalid_chars(v_column_name) <> 'Y'
		OR check_for_invalid_chars(v_alias_name)  <> 'Y'
		THEN
			RETURN 'column/alias name with special characters not allowed - ' || v_column_name || ' ' || v_alias_name || ' (allowed: A-Z a-z 0-9 _ $ #)';
		END IF;
		--
		v_column_count := v_column_count + 1;
		--
		IF p_column_alias IS NULL THEN
			p_column_alias := v_column_name  || ' ' || v_alias_name;
		ELSE
			p_column_alias := p_column_alias || ','   || v_column_name || ' ' || v_alias_name;
		END IF;
	END LOOP;
	--
	SELECT COUNT(*) col_count
	  INTO v_actual_col_cnt
	  FROM all_tab_cols atc,
	       sde_tables   st
	 WHERE atc.table_name = st.st_table_name
	   AND atc.table_name = UPPER(p_table_name)
	   AND atc.column_name IN (
	                           SELECT *
					           FROM TABLE(v_col_array)
					          );
	--
	IF v_column_count = v_actual_col_cnt THEN
		RETURN 'Y';
	ELSE
		p_column_alias := NULL;
		--
		RETURN 'some of the columns do not exist in the table/view or access to the table/view is restricted - ' || p_table_name;
	END IF;
END validate_column_names;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION validate_column_name(
                              p_table_name  IN VARCHAR2,
							  p_column_name IN VARCHAR2
							 )
RETURN VARCHAR2
IS
	v_srid_col_array sde_varchar_2d_array := sde_varchar_2d_array(sde_varchar_array(p_column_name, p_column_name));
	v_column_alias VARCHAR2(100);
BEGIN
	RETURN validate_column_names(p_table_name, v_srid_col_array, v_column_alias);
END validate_column_name;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION validate_where_clause(
                              p_where_clause IN VARCHAR2
							  )
RETURN VARCHAR2
IS
	v_open_count    NUMBER       := 0;
	v_close_count   NUMBER       := 0;
    v_data_type     VARCHAR2(12) := NULL;
	v_var_start_pos NUMBER       := 1;
	v_var_end_pos   NUMBER       := 0;
BEGIN
    IF p_where_clause IS NULL THEN
	    RETURN 'NULL WHERE clause';
	END IF;
	--
	v_open_count  := (LENGTH(p_where_clause) - LENGTH(REPLACE(p_where_clause, '<<?', NULL)))/3;
    --
	v_close_count := (LENGTH(p_where_clause) - LENGTH(REPLACE(p_where_clause, '?>>', NULL)))/3;
    --
    IF v_open_count > 0 THEN
        IF v_open_count <> v_close_count THEN
            RETURN 'malformed where clause';
		ELSE
		    FOR i IN 1..v_open_count LOOP
		        v_var_start_pos := INSTR(p_where_clause, '<<?', v_var_start_pos);
		        v_var_end_pos 	:= INSTR(p_where_clause, '?>>', v_var_start_pos);
		        v_data_type 	:= UPPER(SUBSTR(p_where_clause, (v_var_start_pos + 3), (v_var_end_pos - (v_var_start_pos + 3))));
		        --
		        IF NOT (
		           v_data_type = 'NUMBER'
				OR v_data_type = 'DATE'
				OR v_data_type = 'VARCHAR')
				THEN
		        	RETURN 'wrong data type specified in WHERE clause, allowed data types - NUMBER, DATE, VARCHAR';
		        END IF;
		        --
		        v_var_start_pos := v_var_start_pos + 3;
	        END LOOP;
		END IF;
	END IF;
	--
	RETURN 'Y';
END validate_where_clause;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION validate_where_clause_values(
                                     p_where_clause IN OUT VARCHAR2,
									 p_values 		IN 	   sde_varchar_array
									 )
RETURN VARCHAR2
IS
    v_result        VARCHAR2(32767) := NULL;
	v_data_type     VARCHAR2(32767) := NULL;
	v_var_start_pos NUMBER          := 1;
	v_var_end_pos   NUMBER          := 0;
BEGIN
    v_result := validate_where_clause(p_where_clause);
	--
	IF v_result <> 'Y' THEN
	    RETURN v_result;
	END IF;
	--
	FOR i IN 1..p_values.COUNT LOOP
		v_var_start_pos := INSTR(p_where_clause, '<<?', v_var_start_pos);
		v_var_end_pos 	:= INSTR(p_where_clause, '?>>', v_var_start_pos);
		v_data_type 	:= UPPER(SUBSTR(p_where_clause, (v_var_start_pos + 3), (v_var_end_pos - (v_var_start_pos + 3))));
		--
		IF INSTR(p_values(i), '[') > 0 OR INSTR(p_values(i), ']') > 0 THEN
			RETURN 'square brackets [] not allowed in WHERE clause values';
		END IF;
		--
		IF v_data_type = 'NUMBER' THEN
			BEGIN
				p_where_clause := SUBSTR(p_where_clause, 1, (v_var_start_pos - 1))
							   || TO_NUMBER(p_values(i))
							   || SUBSTR(p_where_clause, (v_var_end_pos + 3));
			EXCEPTION WHEN OTHERS THEN
				RETURN 'wrong value passed, value position - ' || i || ' : required - NUMBER';
			END;
		ELSIF v_data_type = 'DATE' THEN
			BEGIN
				p_where_clause := SUBSTR(p_where_clause, 1, (v_var_start_pos - 1)) || ''''
							   || TO_DATE(p_values(i)) || ''''
							   || SUBSTR(p_where_clause, (v_var_end_pos + 3));
			EXCEPTION WHEN OTHERS THEN
				RETURN 'wrong value passed, value position - ' || i || ' , required - DATE';
			END;
		ELSIF v_data_type = 'VARCHAR' THEN
			p_where_clause := SUBSTR(p_where_clause, 1, (v_var_start_pos - 1))
						   || 'q''[' || p_values(i) || ']'''
						   || SUBSTR(p_where_clause, (v_var_end_pos + 3));
		ELSE
			RETURN 'wrong data type specified in WHERE clause, allowed data types - NUMBER, DATE, VARCHAR';
		END IF;
		--
		v_var_start_pos := v_var_start_pos + 3;
	END LOOP;
	--
	RETURN 'Y';
END validate_where_clause_values;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION get_where_clause(
						 p_table_name          IN  sde_tables.st_table_name%TYPE,
                         p_where_clause_unique IN  sde_where.sw_unique%TYPE,
						 p_values 		       IN  sde_varchar_array,
						 p_where_clause        OUT sde_where.sw_where_clause%TYPE
						 )
RETURN VARCHAR2
IS
	v_result       VARCHAR2(32767) := NULL;
	v_open_count   NUMBER          := 0;
	v_close_count  NUMBER          := 0;
BEGIN
	v_result := validate_where_clause_unique(p_where_clause_unique, p_table_name);
	--
	IF v_result <> 'Y' THEN
		RETURN v_result;
	END IF;
	--
	SELECT sw.sw_where_clause
	  INTO p_where_clause
	  FROM sde_where    sw,
	       sde_tables   st,
		   sde_registry sr
	 WHERE sw.sw_where_id          = sr.sr_where_id
	   AND st.st_table_id          = sr.sr_table_id
	   AND UPPER(sw.sw_unique)     = UPPER(p_where_clause_unique)
	   AND UPPER(st.st_table_name) = UPPER(p_table_name);
	--
	v_result := validate_where_clause(p_where_clause);
	--
	IF v_result <> 'Y' THEN
		RETURN v_result;
	END IF;
	--
		v_open_count := (LENGTH(p_where_clause) - LENGTH(REPLACE(p_where_clause, '<<?', NULL)))/3;
		--
		IF v_open_count > 0 THEN
			IF  p_values IS NOT NULL
			AND p_values.COUNT = v_open_count
			THEN
				v_result := validate_where_clause_values(p_where_clause, p_values);
				--
				RETURN v_result;
			ELSE
				RETURN 'missing where clause values';
			END IF;
		ELSE
			RETURN 'Y';
		END IF;
END get_where_clause;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION get_data(
                 p_table_name          IN VARCHAR2,
				 p_column_array        IN sde_varchar_2d_array     DEFAULT NULL,
				 p_where_clause_unique IN sde_where.sw_unique%TYPE DEFAULT NULL,
				 p_values              IN sde_varchar_array        DEFAULT NULL
				 )
RETURN SYS_REFCURSOR
IS
	v_query_data   		SYS_REFCURSOR;
	v_result 	   		VARCHAR2(32767) := 'Y';
	v_query 	   		VARCHAR2(32767) := NULL;
	v_where_clause 		VARCHAR2(32767) := NULL;
	v_values			sde_varchar_array;
	v_column_alias		VARCHAR2(32767) := NULL;
BEGIN
	BEGIN
		IF p_column_array IS NOT NULL THEN
			v_result := validate_column_names(p_table_name, p_column_array, v_column_alias);
			--
			IF v_result <> 'Y' THEN
				v_query   := 'SELECT q''[' || v_result || ']'' get_data_exp FROM DUAL';
			ELSE
				v_query   := 'SELECT ' || v_column_alias || ' FROM ' || p_table_name;
			END IF;
		ELSE
			v_result := validate_table_name(p_table_name);
			--
			IF v_result <> 'Y' THEN
			    v_query := 'SELECT q''[' || v_result || ']'' get_data_exp FROM DUAL';
			ELSE
			    v_query := 'SELECT * FROM ' || p_table_name;
			END IF;
		END IF;
		--
		IF v_result = 'Y' AND p_where_clause_unique IS NOT NULL THEN
			v_result := get_where_clause(p_table_name, p_where_clause_unique, p_values, v_where_clause);
			--
			IF v_result <> 'Y' THEN
				v_query := 'SELECT q''[' || v_result || ']'' get_data_exp FROM DUAL';
			ELSE
				v_query := v_query || ' WHERE ' || v_where_clause;
			END IF;
		END IF;
		--
		OPEN v_query_data FOR v_query;
	EXCEPTION
		WHEN OTHERS THEN
			v_query := 'SELECT q''[' || get_error_message('get_data') || ']'' get_data_exp FROM DUAL';
			--
			OPEN v_query_data FOR v_query;
	END;
	--
	RETURN v_query_data;
END get_data;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION get_where_clause_details(
                                 p_where_clause_unique IN sde_where.sw_unique%TYPE DEFAULT NULL
								 )
RETURN SYS_REFCURSOR
IS
	where_clause_details SYS_REFCURSOR;
	v_result			 VARCHAR2(32767);
BEGIN
	BEGIN
		IF p_where_clause_unique IS NULL THEN
			      OPEN where_clause_details FOR
			    SELECT sw.sw_unique, 
			           sw.sw_where_clause, 
			           sw.sw_where_descr,
					   st.st_table_name
			      FROM sde_where    sw,
				       sde_tables   st,
				       sde_registry sr
			     WHERE sw.sw_where_id = sr.sr_where_id
                   AND st.st_table_id = sr.sr_table_id
			     ORDER BY sw.sw_unique, st.st_table_name;
		ELSE
			v_result := validate_where_clause_unique(p_where_clause_unique, NULL);
			--
			IF v_result = 'Y' THEN
				  OPEN where_clause_details FOR
				SELECT sw.sw_unique, 
			           sw.sw_where_clause, 
			           sw.sw_where_descr,
					   st.st_table_name
			      FROM sde_where    sw,
				       sde_tables   st,
				       sde_registry sr
			     WHERE sw.sw_where_id = sr.sr_where_id
                   AND st.st_table_id = sr.sr_table_id
				   AND UPPER(sw.sw_unique) = UPPER(p_where_clause_unique)
			     ORDER BY sw.sw_unique, st.st_table_name;
			ELSE
				OPEN where_clause_details FOR
				'SELECT q''[' || v_result || ']'' where_clause_exp FROM DUAL';
			END IF;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			OPEN where_clause_details FOR
			'SELECT ''' || get_error_message('get_where_clause_details') || ''' where_clause_exp FROM DUAL';
	END;
	--
	RETURN where_clause_details;
END get_where_clause_details;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION register_where_clause(
                               p_where_clause_unique IN sde_where.sw_unique%TYPE,
                               p_where_clause        IN sde_where.sw_where_clause%TYPE,
                               p_where_clause_descr  IN sde_where.sw_where_descr%TYPE  DEFAULT NULL,
                               p_table_names         IN sde_varchar_array              DEFAULT NULL
							  )
RETURN VARCHAR2
IS
    v_result      VARCHAR2(32767)            := NULL;
	v_sw_id       sde_where.sw_where_id%TYPE;
	v_table_id    g_number_array;
	v_table_names sde_varchar_array          := sde_varchar_array();
	v_counter     NUMBER                     := 1;
BEGIN
    IF is_admin_user <> 'Y' THEN
	    RETURN g_insuff_privs_msg;
	END IF;
	--
	IF check_for_invalid_chars(p_where_clause_unique) <> 'Y' THEN
	    RETURN 'WHERE clause unique with special characters not allowed (allowed: A-Z a-z 0-9 _ $ #)';
	END IF;
	--
	v_result := validate_where_clause(p_where_clause);
	--
	IF v_result <> 'Y' THEN
	    RETURN v_result;
	END IF;
    --
    IF p_table_names IS NOT NULL THEN 
        IF  p_table_names.COUNT = 1
        AND p_table_names(1)    = '*'
        THEN
            FOR st_rec IN (SELECT st_table_name FROM sde_tables) LOOP
                v_table_names.EXTEND(1);
                --
                v_table_names(v_counter) := st_rec.st_table_name;
                --
                v_counter := v_counter + 1;
            END LOOP;
        ELSE
            v_table_names := p_table_names;
        END IF;
        --
        FOR i IN 1..v_table_names.COUNT LOOP
            v_result := validate_table_name(v_table_names(i), v_table_id(i));
            --
            IF v_result <> 'Y' THEN
                RETURN v_result;
            END IF;
        END LOOP;
    END IF;
	--
	BEGIN
	    INSERT INTO sde_where
	    (
	        sw_unique,
            sw_where_clause,
            sw_where_descr
	    )
	    VALUES
	    (
	        UPPER(p_where_clause_unique),
	        p_where_clause,
	        p_where_clause_descr
	    )
	    RETURNING sw_where_id
	    INTO v_sw_id;
	EXCEPTION
	    WHEN DUP_VAL_ON_INDEX THEN
		    RETURN 'WHERE clause unique already present, please try another';
	END;
	--
	IF v_table_id IS NOT NULL THEN
        FOR i IN 1..v_table_id.COUNT LOOP
            BEGIN
                INSERT INTO sde_registry
                (
                    sr_table_id,
                    sr_where_id
                )
                VALUES
                (
                    v_table_id(i),
                    v_sw_id
                );
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                    NULL;
            END;
        END LOOP;
    END IF;
	--
	COMMIT;
	--
	RETURN 'Y';
EXCEPTION
	WHEN OTHERS THEN
	    RETURN get_error_message('register_where_clause');
END register_where_clause;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION update_where_clause(
                               p_where_clause_unique IN sde_where.sw_unique%TYPE,
                               p_where_clause        IN sde_where.sw_where_clause%TYPE DEFAULT NULL,
                               p_where_clause_descr  IN sde_where.sw_where_descr%TYPE  DEFAULT NULL,
                               p_table_names         IN sde_varchar_array              DEFAULT NULL,
							   p_table_update_action IN VARCHAR2                       DEFAULT 'APPEND'
							  )
RETURN VARCHAR2
IS
	v_delete_registry     BOOLEAN           := FALSE;
	v_delete_all_registry BOOLEAN           := FALSE;
	v_insert_registry     BOOLEAN           := FALSE;
	v_table_update_action VARCHAR2(6)       := UPPER(p_table_update_action);
    v_result              VARCHAR2(32767)   := NULL;
	v_table_id            g_number_array;
	v_validate_table_name BOOLEAN           := TRUE;
	v_table_names         sde_varchar_array := sde_varchar_array();
	v_counter             NUMBER            := 1;
	--
	v_sw_id               sde_where.sw_where_id%TYPE;
BEGIN
    --
    IF is_admin_user <> 'Y' THEN
	    RETURN g_insuff_privs_msg;
	END IF;
	--
	v_result := validate_where_clause_unique(p_where_clause_unique, NULL, v_sw_id);
	--
	IF v_result <> 'Y' THEN
	    RETURN v_result;
	END IF;
	--
	IF p_where_clause IS NOT NULL THEN
		v_result := validate_where_clause(p_where_clause);
		--
		IF v_result <> 'Y' THEN
			RETURN v_result;
		END IF;
	END IF;
    --
    IF p_table_names IS NOT NULL THEN
        IF  p_table_names.COUNT = 1
        AND p_table_names(1)    = '*'
        THEN
            v_validate_table_name := FALSE;
            --
            FOR st_rec IN (SELECT st_table_name FROM sde_tables) LOOP
                v_table_names.EXTEND(1);
                --
                v_table_names(v_counter) := st_rec.st_table_name;
                --
                v_counter := v_counter + 1;
            END LOOP;
        ELSE
            v_table_names := p_table_names;
        END IF;
    END IF;
    --
	IF v_table_update_action = 'APPEND'    THEN
		v_insert_registry := TRUE;
	ELSIF v_table_update_action = 'INIT'   THEN 
        IF NOT v_validate_table_name THEN
            RETURN 'invalid table update action (allowed: append|delete)';
        END IF;
        --
        v_delete_all_registry := TRUE; 
        v_insert_registry     := TRUE; 
    ELSIF v_table_update_action = 'DELETE' THEN
		v_delete_registry := TRUE;
	ELSE
		RETURN 'invalid table update action (allowed: append|init|delete)';
	END IF;
	--
	IF v_table_names IS NOT NULL THEN 
        FOR i IN 1..v_table_names.COUNT LOOP
            --
            v_result := validate_table_name(v_table_names(i), v_table_id(i));
            --
            IF v_result <> 'Y' THEN
                RETURN v_result;
            END IF;
        END LOOP;
    END IF;
	--
	IF p_where_clause IS NOT NULL THEN
        UPDATE sde_where
           SET sw_where_clause = p_where_clause
         WHERE sw_unique = p_where_clause_unique;
	END IF;
	--
	IF p_where_clause_descr IS NOT NULL THEN
        UPDATE sde_where
           SET sw_where_descr = p_where_clause_descr
         WHERE sw_unique = p_where_clause_unique;
	END IF;
    --
	IF v_table_id IS NOT NULL THEN 
        IF v_delete_all_registry THEN
            DELETE
              FROM sde_registry
             WHERE sr_where_id = v_sw_id;
        END IF;
        --
        FOR i IN 1..v_table_id.COUNT LOOP
            IF v_delete_registry THEN
                DELETE
                  FROM sde_registry
                 WHERE sr_table_id = v_table_id(i)
                   AND sr_where_id = v_sw_id;
            END IF;
            --
            IF v_insert_registry THEN
                BEGIN
                    INSERT INTO sde_registry
                    (
                        sr_table_id,
                        sr_where_id
                    )
                    VALUES
                    (
                        v_table_id(i),
                        v_sw_id
                    );
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        NULL;
                END;
            END IF;
        END LOOP;
    END IF;
	--
	COMMIT;
	--
	RETURN 'Y';
EXCEPTION
	WHEN OTHERS THEN
	    RETURN get_error_message('update_where_clause');
END update_where_clause;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION unregister_where_clause(
                                p_where_clause_uniques IN sde_varchar_array
						        )
RETURN VARCHAR2
IS
    v_result               VARCHAR2(32767);
	v_sw_id                g_number_array;
	v_table_id             sde_tables.st_table_id%TYPE;
	v_where_clause_uniques sde_varchar_array           := sde_varchar_array();
	v_counter              NUMBER                      := 1;
BEGIN
    IF is_admin_user <> 'Y' THEN
	    RETURN g_insuff_privs_msg;
	END IF;
	--
	IF p_where_clause_uniques IS NULL THEN 
        RETURN 'null where clause id passed';
	END IF;
	--
	IF  p_where_clause_uniques.COUNT = 1
	AND p_where_clause_uniques(1)    = '*' 
	THEN
        FOR sw_rec IN (SELECT sw_unique FROM sde_where) LOOP
            v_where_clause_uniques.EXTEND(1);
            --
            v_where_clause_uniques(v_counter) := sw_rec.sw_unique;
            --
            v_counter := v_counter + 1;
        END LOOP;
	ELSE
        v_where_clause_uniques := p_where_clause_uniques;
	END IF;
	--
	FOR i IN 1..v_where_clause_uniques.COUNT LOOP
        v_result := validate_where_clause_unique(v_where_clause_uniques(i), NULL, v_sw_id(i));
        --
        IF v_result <> 'Y' THEN
            RETURN v_result;
        END IF;
	END LOOP;
	--
	FOR i IN 1..v_sw_id.COUNT LOOP
        DELETE
          FROM sde_registry
         WHERE sr_where_id = v_sw_id(i);
        --
        DELETE
          FROM sde_where
         WHERE sw_where_id = v_sw_id(i);
	END LOOP;
	--
	COMMIT;
	--
	RETURN 'Y';
EXCEPTION
	WHEN OTHERS THEN
	    RETURN get_error_message('unregister_where_clause');
END unregister_where_clause;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION get_srid(
                 p_table_name  IN  VARCHAR2,
				 p_column_name IN  VARCHAR2,
				 p_oracle_srid OUT NUMBER,
				 p_epsg_srid   OUT NUMBER
				 )
RETURN VARCHAR2
IS
	v_result VARCHAR2(32767);
BEGIN
	v_result := validate_column_name(p_table_name, p_column_name);
	--
	IF v_result <> 'Y' THEN
	    RETURN v_result;
	END IF;
	--
	SELECT NVL(srid, 0) oracle_srid,
	       NVL(sdo_cs.map_oracle_srid_to_epsg(srid), 0) epsg_srid
	  INTO p_oracle_srid,  p_epsg_srid
	  FROM user_sdo_geom_metadata usgm,
	       sde_tables             st
	 WHERE usgm.table_name  = st.st_table_name
	   AND usgm.table_name  = UPPER(p_table_name)
	   AND usgm.column_name = UPPER(p_column_name);
	--
	RETURN 'Y';
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		p_oracle_srid := 0;
		p_epsg_srid	  := 0;
		--
		RETURN 'table/view - ' || UPPER(p_table_name) || ' - is not spatially registered.';
	--
	WHEN OTHERS THEN
		p_oracle_srid := 0;
		p_epsg_srid	  := 0;
		--
		RETURN get_error_message('get_srid');
END get_srid;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION validate_srid(
                      p_srid        IN NUMBER,
					  p_table_name  IN VARCHAR2,
					  p_column_name IN VARCHAR2
					  )
RETURN VARCHAR2
IS
    v_result VARCHAR2(32767);
	v_oracle_srid NUMBER;
	v_epsg_srid   NUMBER;
BEGIN
	v_result := validate_column_name(p_table_name, p_column_name);
	--
	IF v_result <> 'Y' THEN
	    RETURN v_result;
	END IF;
	--
	SELECT NVL(srid, 0) oracle_srid,
	       NVL(sdo_cs.map_oracle_srid_to_epsg(srid), 0) epsg_srid
	  INTO v_oracle_srid, v_epsg_srid
      FROM user_sdo_geom_metadata usgm,
		   sde_tables             st
	 WHERE usgm.table_name  = st.st_table_name
	   AND usgm.table_name  = UPPER(p_table_name)
	   AND usgm.column_name = UPPER(p_column_name);
	--
	IF (v_oracle_srid = 0)      OR
	   (v_oracle_srid = p_srid) OR
	   (v_epsg_srid   = p_srid)
	THEN
        RETURN 'Y';
	ELSE
		RETURN 'SRID ''' || p_srid || ''' does not match the SRID in user_sdo_geom_metadata for - ' || p_table_name || ', ' || p_column_name;
	END IF;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RETURN 'Y';
	--
	WHEN OTHERS THEN
		RETURN get_error_message('validate_srid');
END validate_srid;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION get_geodetic_srid_count(
                                p_srid 	   IN  NUMBER,
								p_gs_count OUT NUMBER
								)
RETURN VARCHAR2
IS
BEGIN
	SELECT COUNT(*) cnt
	  INTO p_gs_count
	  FROM MDSYS.GEODETIC_SRIDS
	 WHERE srid = p_srid;
	--
	RETURN 'Y';
EXCEPTION
	WHEN OTHERS THEN
		p_gs_count := -1;
		--
		RETURN get_error_message('get_geodetic_srid_count');
END get_geodetic_srid_count;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION init_view(p_table_name 		IN	VARCHAR2
				   ,p_records_deleted 	OUT	NUMBER
				  )
RETURN VARCHAR2
IS
	v_count_query VARCHAR2(100);
	v_trunc_query VARCHAR2(100);
	v_result	  VARCHAR2(32767);
BEGIN
	v_result := validate_table_name(p_table_name);
	--
	IF v_result <> 'Y' THEN
		RETURN v_result;
	END IF;
	--
	v_count_query := 'SELECT COUNT(*) FROM '|| p_table_name;
	--
	EXECUTE IMMEDIATE v_count_query INTO p_records_deleted;
	--
	IF p_records_deleted > 0 THEN
		v_trunc_query := 'TRUNCATE TABLE ' || p_table_name;
		--
		EXECUTE IMMEDIATE v_trunc_query;
	END IF;
	--
	RETURN 'Y';
EXCEPTION
	WHEN OTHERS THEN
		RETURN get_error_message('init_view');
END init_view;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION build_dim_array(
                        p_sde_dims    IN  NUMBER,
						p_min_x       IN  NUMBER,
						p_max_x       IN  NUMBER,
						p_min_y       IN  NUMBER,
						p_max_y       IN  NUMBER,
						p_min_z       IN  NUMBER,
						p_max_z       IN  NUMBER,
						p_min_measure IN  NUMBER,
						p_max_measure IN  NUMBER,
						p_tolerance   IN  NUMBER,
						p_dim_array   OUT sdo_dim_array
						)
RETURN VARCHAR2
IS
	v_not_number 			BOOLEAN := FALSE;
	v_number	 			NUMBER;
	v_dim_array_3_measure	VARCHAR2(32767);
	v_dim_array_3 			VARCHAR2(32767);
	v_dim_array_4 			VARCHAR2(32767);
BEGIN
	BEGIN
		IF v_number <= -10E38 THEN
			v_not_number := TRUE;
		END IF;
	END;
	--
	IF (p_sde_dims = 2) OR (p_sde_dims = 0) THEN
		p_dim_array := MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', p_min_x, p_max_x, p_tolerance),
										   MDSYS.SDO_DIM_ELEMENT('Y', p_min_y, p_max_y, p_tolerance)
										  );
	ELSIF (p_sde_dims = 3) THEN
		IF v_not_number THEN
			p_dim_array := MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', p_min_x, p_max_x, p_tolerance),
										       MDSYS.SDO_DIM_ELEMENT('Y', p_min_y, p_max_y, p_tolerance),
										       MDSYS.SDO_DIM_ELEMENT('Z', p_min_z, p_max_z, p_tolerance)
										      );
		ELSE
			p_dim_array := MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', p_min_x,       p_max_x,       p_tolerance),
										       MDSYS.SDO_DIM_ELEMENT('Y', p_min_y,       p_max_y,       p_tolerance),
										       MDSYS.SDO_DIM_ELEMENT('M', p_min_measure, p_max_measure, p_tolerance)
										      );
		END IF;
	ELSIF (p_sde_dims = 4) THEN
		p_dim_array := MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', p_min_x,       p_max_x,       p_tolerance),
										   MDSYS.SDO_DIM_ELEMENT('Y', p_min_y,       p_max_y,       p_tolerance),
										   MDSYS.SDO_DIM_ELEMENT('Z', p_min_z,       p_max_z,       p_tolerance),
										   MDSYS.SDO_DIM_ELEMENT('M', p_min_measure, p_max_measure, p_tolerance)
										   );
	ELSE
		RETURN 'wrong dimension information passed';
	END IF;
	--
	RETURN 'Y';
EXCEPTION
	WHEN OTHERS THEN
		RETURN get_error_message('build_dim_array');
END build_dim_array;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION update_sdo_geom_metadata(
                                 p_table_name  IN VARCHAR2,
								 p_column_name IN VARCHAR2,
								 p_srid        IN NUMBER,
								 p_sde_dims    IN NUMBER,
								 p_min_x       IN NUMBER,
								 p_max_x       IN NUMBER,
								 p_min_y       IN NUMBER,
								 p_max_y       IN NUMBER,
								 p_min_z       IN NUMBER,
								 p_max_z       IN NUMBER,
								 p_min_measure IN NUMBER,
								 p_max_measure IN NUMBER,
								 p_tolerance   IN NUMBER
								 )
RETURN VARCHAR2
IS
	v_result 			VARCHAR2(32767);
	v_sgm_insert_query 	VARCHAR2(32767);
	v_dim_array			sdo_dim_array;
BEGIN
	v_result := validate_srid(p_srid, p_table_name, p_column_name);
	--
	IF v_result <> 'Y' THEN
	    RETURN v_result;
	END IF;
	--
	v_result := build_dim_array(p_sde_dims ,p_min_x ,p_max_x ,p_min_y ,p_max_y ,p_min_z ,p_max_z ,p_min_measure ,p_max_measure ,p_tolerance, v_dim_array);
	--
	IF v_result <> 'Y' THEN
	    RETURN v_result;
	END IF;
	--
	INSERT INTO user_sdo_geom_metadata
	(
	    table_name,
	    column_name,
	    diminfo,
	    srid
	)
	VALUES
	(
	    UPPER(p_table_name),
	    UPPER(p_column_name),
	    v_dim_array,
	    p_srid
	);
	--
	COMMIT;
	--
	RETURN 'Y';
EXCEPTION
	WHEN OTHERS THEN
		RETURN get_error_message('update_sdo_geom_metadata');
END update_sdo_geom_metadata;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION shputil(
                p_command IN sde_varchar_array
				)
RETURN VARCHAR2
	AS LANGUAGE JAVA
	NAME 'bentley.exor.gis.ShapefileUtility.callFromDB(oracle.sql.ARRAY) return java.lang.String';
--
---------------------------------------------------------------------------------------------------
--
END sde_util;
/ 