CREATE OR REPLACE PACKAGE BODY sde_util AS
--
---------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sde_util.pkb-arc   1.2   Oct 30 2017 07:51:56   Upendra.Hukeri  $
--       Module Name      : $Workfile:   sde_util.pkb  $
--       Date into PVCS   : $Date:   Oct 30 2017 07:51:56  $
--       Date fetched Out : $Modtime:   Oct 30 2017 07:51:14  $
--       PVCS Version     : $Revision:   1.2  $
--
--   Author : Upendra Hukeri
--
---------------------------------------------------------------------------------------------------
-- Copyright (c) 2017 Bentley Systems Incorporated. All rights reserved.
---------------------------------------------------------------------------------------------------
--
--
-- all global package variables here
--
   g_body_sccsid     CONSTANT  VARCHAR2(30) := '"$Revision:   1.2  $"';
   g_package_name    CONSTANT  VARCHAR2(30) := 'sde_util';
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
FUNCTION validate_where_clause_unique(p_where_clause_unique IN sde_where.sw_unique%TYPE DEFAULT NULL)
RETURN VARCHAR2 
IS
	v_result 			VARCHAR2(1);
	v_where_clause_qry 	VARCHAR2(200);
BEGIN
	v_where_clause_qry := 'SELECT ''Y'' FROM sde_where sw WHERE EXISTS (SELECT NULL FROM user_role_privs WHERE granted_role = UPPER(sw.sw_user_role)) AND UPPER(sw_unique) = UPPER(q''[' || p_where_clause_unique || ']'')';
	--
	EXECUTE IMMEDIATE v_where_clause_qry INTO v_result;
	--
	RETURN v_result;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RETURN 'no WHERE clause found for - ' || UPPER(p_where_clause_unique);
	WHEN OTHERS THEN
		RETURN SQLERRM;
END validate_where_clause_unique;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION validate_where_clause_values(p_where_clause IN OUT VARCHAR2
									 ,p_values 		 IN 	sde_varchar_array
									 )
RETURN VARCHAR2
IS
	v_where_clause		VARCHAR2(32767) := p_where_clause;
	v_data_type 		VARCHAR2(32767) := NULL;
	v_var_start_pos		NUMBER := 1;
	v_var_end_pos		NUMBER := 0;
BEGIN
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
			RETURN 'wrong data type specified in WHERE clause, allowed data types - NUMBER DATE VARCHAR';
		END IF;
		v_var_start_pos := v_var_start_pos + 3;
	END LOOP;
	--
	RETURN 'Y';
END validate_where_clause_values;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION get_where_clause(p_where_clause IN OUT VARCHAR2
						 ,p_values 		 IN 	sde_varchar_array
						 ) 
RETURN VARCHAR2
IS
	v_where_clause		VARCHAR2(32767) := UPPER(p_where_clause);
	v_result	 		VARCHAR2(32767) := NULL;
	v_where_clause_qry 	VARCHAR2(32767) := NULL;
	v_open_count 		NUMBER := 0;
	v_close_count 		NUMBER := 0;
BEGIN
	v_result := validate_where_clause_unique(v_where_clause);
	--
	IF v_result <> 'Y' THEN
		RETURN v_result;
	ELSE
		v_where_clause_qry := 'SELECT UPPER(sw_where_clause) FROM sde_where sw WHERE EXISTS (SELECT NULL FROM user_role_privs WHERE granted_role = UPPER(sw.sw_user_role)) AND sw_unique = q''[' || v_where_clause || ']''';
		--
		EXECUTE IMMEDIATE v_where_clause_qry INTO p_where_clause;
		--
		IF p_where_clause IS NOT NULL THEN
			SELECT (LENGTH(p_where_clause) - LENGTH(REPLACE(p_where_clause, '<<?', NULL)))/3 cnt
			INTO v_open_count
			FROM DUAL;
			--
			SELECT (LENGTH(p_where_clause) - LENGTH(REPLACE(p_where_clause, '?>>', NULL)))/3 cnt
			INTO v_close_count
			FROM DUAL;
			--
			IF v_open_count > 0 THEN
				IF v_open_count = v_close_count THEN
					IF p_values IS NOT NULL THEN
						IF p_values.COUNT = v_open_count THEN
							v_result := validate_where_clause_values(p_where_clause, p_values);
							--
							RETURN v_result;
						ELSE
							RETURN 'wrong number of where clause values, required - ' || v_open_count || ', passed - ' || p_values.COUNT;
						END IF;
					ELSE 
						RETURN 'missing where clause values';
					END IF;
				ELSE
					RETURN 'malformed where clause - ' || v_where_clause || ', please contact your System Administrator';
				END IF;
			ELSIF v_open_count = 0 AND v_close_count = 0 THEN 
				RETURN 'Y';
			END IF;
		END IF;
	END IF;
END get_where_clause;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION validate_column_names(p_table_name   IN  VARCHAR2
							  ,p_column_array IN  sde_varchar_2d_array
							  ,p_column_alias OUT VARCHAR2
							  ) 
RETURN VARCHAR2
IS 
	v_column_alias	 sde_varchar_array;
	v_column_comb 	 VARCHAR2(32767) := NULL;
	v_comma_pos		 INTEGER		 := 0;
	v_space_pos		 INTEGER		 := 0;
	v_column_name	 VARCHAR2(32767) := NULL;
	v_col_name_str	 VARCHAR2(32767) := NULL;
	v_cloumn_str	 VARCHAR2(32767) := NULL;
	v_column_qry	 VARCHAR2(32767) := NULL;
	v_column_count	 NUMBER			 := 0;
	v_actual_col_cnt NUMBER			 := 0;
	v_alias_name	 VARCHAR2(32767) := NULL;
BEGIN
	FOR i IN 1..p_column_array.COUNT LOOP
		v_column_alias := p_column_array(i);
		v_column_name  := v_column_alias(1);
		v_alias_name   := v_column_alias(2);
		--
		IF REGEXP_REPLACE(v_column_name, '[^a-zA-Z0-9_$#]+', '') <> v_column_name 
		OR REGEXP_REPLACE(v_alias_name,  '[^a-zA-Z0-9_$#]+', '') <> v_alias_name 
		THEN
			RETURN 'column/alias name with special characters not allowed - ' || v_column_name || ' ' || v_alias_name || ' (allowed: A-Z a-z 0-9 _ $ #)';
		END IF;
		--
		v_column_count := v_column_count + 1;
		--
		IF v_column_comb IS NULL THEN
			v_column_comb  := '''' || v_column_name || '''';
			p_column_alias := v_column_name  || ' ' || v_alias_name;
		ELSE
			v_column_comb  := v_column_comb  || ',''' || v_column_name || '''';
			p_column_alias := p_column_alias || ','   || v_column_name || ' ' || v_alias_name;
		END IF;
	END LOOP;
	--
	v_column_qry := 'SELECT COUNT(*) FROM all_tab_cols WHERE table_name = ''' || UPPER(p_table_name) || ''' AND column_name IN (' || v_column_comb || ')';
	--
	EXECUTE IMMEDIATE v_column_qry INTO v_actual_col_cnt;
	--
	IF v_column_count = v_actual_col_cnt THEN
		RETURN 'Y';
	ELSE
		p_column_alias := NULL;
		--
		RETURN 'one/many columns not found in table/view - ' || p_table_name;
	END IF;
END validate_column_names;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION validate_table_name(p_table_name IN VARCHAR2)
RETURN VARCHAR2
IS
	v_result 	VARCHAR2(1);
	v_tab_query VARCHAR2(32767);
BEGIN
	IF REGEXP_REPLACE(p_table_name, '[^a-zA-Z0-9_$#]+', '') <> p_table_name
		THEN
			RETURN 'table name with special characters not allowed - ' || p_table_name || ' (allowed: A-Z a-z 0-9 _ $ #)';
		END IF;
	--
	v_tab_query := 'SELECT ''Y'' FROM all_objects WHERE UPPER(object_name) = UPPER(q''[' ||p_table_name || ']'') AND object_type IN(''TABLE'', ''VIEW'')';
	--
	EXECUTE IMMEDIATE v_tab_query INTO v_result;
	--
	RETURN 'Y';
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RETURN 'table or view does not exist - ' || UPPER(p_table_name);
	WHEN OTHERS THEN 
		RETURN SQLERRM;
END validate_table_name;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION get_data(p_table_name   IN VARCHAR2
				 ,p_column_array IN sde_varchar_2d_array DEFAULT NULL
				 ,p_where_clause IN VARCHAR2 			 DEFAULT NULL
				 ,p_values 		 IN sde_varchar_array	 DEFAULT NULL
				 ) 
RETURN SYS_REFCURSOR 
IS
	v_query_data   		SYS_REFCURSOR;
	v_result 	   		VARCHAR2(32767) := 'Y';
	v_query 	   		VARCHAR2(32767) := NULL;
	v_where_clause 		VARCHAR2(32767) := p_where_clause;
	v_values			sde_varchar_array;
	v_column_alias		VARCHAR2(32767) := NULL;
BEGIN
	BEGIN
		IF p_table_name IS NOT NULL THEN 
			v_result := validate_table_name(p_table_name);
			--
			IF v_result = 'Y' THEN 
				IF p_column_array IS NOT NULL THEN
					v_result := validate_column_names(p_table_name, p_column_array, v_column_alias);
					--
					IF v_result <> 'Y' THEN
						v_query   := 'SELECT q''[' || v_result || ']'' get_data_exp FROM DUAL';
					ELSE
						v_query   := 'SELECT ' || v_column_alias || ' FROM ' || p_table_name;
					END IF;
				ELSE 
					v_query := 'SELECT * FROM ' || p_table_name;
				END IF;
				--
				IF v_result = 'Y' AND v_where_clause IS NOT NULL THEN
					v_result := get_where_clause(v_where_clause, p_values);
					--
					IF v_result <> 'Y' THEN
						v_query   := 'SELECT q''[' || v_result || ']'' get_data_exp FROM DUAL';
					ELSE
						v_query := v_query || ' WHERE ' || v_where_clause;
					END IF;
				END IF;
			ELSE
				v_query   := 'SELECT q''[' || v_result || ']'' get_data_exp FROM DUAL';
			END IF;
		ELSE
			v_query   := 'SELECT ''please provide table name'' get_data_exp FROM DUAL';
		END IF;
		--
		OPEN v_query_data FOR v_query;
	EXCEPTION 
		WHEN OTHERS THEN
			v_query := 'SELECT ''' || SQLERRM || ''' get_data_exp FROM DUAL';
			--
			OPEN v_query_data FOR v_query;
	END;
	--
	RETURN v_query_data;
END get_data;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION get_where_clause_details(p_where_clause_unique IN sde_where.sw_unique%TYPE DEFAULT NULL)
RETURN SYS_REFCURSOR
IS
	where_clause_details SYS_REFCURSOR;
	v_result			 VARCHAR2(32767);
BEGIN
	BEGIN
		IF p_where_clause_unique IS NULL THEN  
			OPEN where_clause_details FOR 
			SELECT sw_unique, sw_where_clause, sw_where_descr 
			FROM sde_where sw
			WHERE EXISTS (
                SELECT NULL 
                FROM user_role_privs 
                WHERE granted_role = UPPER(sw.sw_user_role)
                )
			ORDER BY sw_unique;
		ELSE
			v_result := validate_where_clause_unique(p_where_clause_unique);
			--
			IF v_result = 'Y' THEN
				OPEN where_clause_details FOR 
				SELECT sw_unique, sw_where_clause, sw_where_descr 
				FROM sde_where sw
				WHERE EXISTS (
					SELECT NULL 
					FROM user_role_privs 
					WHERE granted_role = UPPER(sw.sw_user_role)
                )
				AND UPPER(sw_unique) = UPPER(p_where_clause_unique);
			ELSE
				OPEN where_clause_details FOR 
				'SELECT q''[' || v_result || ']'' where_clause_exp FROM DUAL';
			END IF;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			OPEN where_clause_details FOR 
			'SELECT ''' || SQLERRM || ''' where_clause_exp FROM DUAL';
	END;
	--
	RETURN where_clause_details;
END get_where_clause_details; 
--
---------------------------------------------------------------------------------------------------
--
FUNCTION get_srid(p_table_name  IN  VARCHAR2
				 ,p_column_name IN  VARCHAR2
				 ,p_oracle_srid OUT NUMBER
				 ,p_epsg_srid 	OUT NUMBER
				 ) 
RETURN VARCHAR2 
IS
	result VARCHAR2(32767);
	v_srid_col_array sde_varchar_2d_array := sde_varchar_2d_array(sde_varchar_array(p_column_name, 'SHAPE'));
	v_srid_col_alias VARCHAR2(100);
BEGIN
	result := validate_column_names(p_table_name, v_srid_col_array, v_srid_col_alias);
	--
	IF result = 'Y' THEN
		--
		SELECT NVL(srid, 0) oracle_srid, NVL(sdo_cs.map_oracle_srid_to_epsg(srid), 0) epsg_srid 
		  INTO p_oracle_srid,  p_epsg_srid
		  FROM user_sdo_geom_metadata 
		 WHERE table_name  = p_table_name 
		   AND column_name = p_column_name;
		--
		RETURN 'Y';
	ELSE 
		RETURN result;
	END IF;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		p_oracle_srid := 0;
		p_epsg_srid	  := 0;
		--
		RETURN 'table/view - ' || p_table_name || ' - is not spatially registered.';
	--
	WHEN OTHERS THEN 
		p_oracle_srid := 0;
		p_epsg_srid	  := 0;
		--
		RETURN SQLERRM;
END get_srid;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION validate_srid(p_srid IN NUMBER
					  ,p_table_name  IN VARCHAR2
					  ,p_column_name IN VARCHAR2
					  )
RETURN VARCHAR2 
IS
	v_oracle_srid NUMBER;
	v_epsg_srid   NUMBER;
BEGIN
	IF REGEXP_REPLACE(p_table_name, '[^a-zA-Z0-9_$#]+', '') <> p_table_name THEN
		RETURN 'table name with special characters not allowed - ' || p_table_name || ' (allowed: A-Z a-z 0-9 _ $ #)';
	END IF;
	--
	IF REGEXP_REPLACE(p_column_name, '[^a-zA-Z0-9_$#]+', '') <> p_column_name THEN
		RETURN 'column name with special characters not allowed - ' || p_column_name || ' (allowed: A-Z a-z 0-9 _ $ #)';
	END IF;
	--
	SELECT NVL(srid, 0) oracle_srid, NVL(sdo_cs.map_oracle_srid_to_epsg(srid), 0) epsg_srid 
	  INTO v_oracle_srid, v_epsg_srid
      FROM user_sdo_geom_metadata 
	 WHERE table_name  = p_table_name 
	   AND column_name = p_column_name;
	--
	IF (v_oracle_srid = 0) OR (v_oracle_srid = p_srid) OR (v_epsg_srid = p_srid) THEN
        RETURN 'Y';
	ELSE
		RETURN 'SRID ''' || p_srid || ''' does not match the SRID in user_sdo_geom_metadata for - ' || p_table_name || ', ' || p_column_name;
	END IF;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RETURN 'Y';
	--
	WHEN OTHERS THEN
		RETURN SQLERRM;
END validate_srid;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION get_geodetic_srid_count(p_srid 	IN  NUMBER
								,p_gs_count OUT NUMBER
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
		RETURN SQLERRM;
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
	IF v_result = 'Y' THEN
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
	ELSE
		RETURN v_result;
	END IF;
EXCEPTION
	WHEN OTHERS THEN
		RETURN SQLERRM;
END init_view;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION build_dim_array(p_shp_dims 	IN 	NUMBER
						,p_min_x 		IN 	NUMBER
						,p_max_x 		IN 	NUMBER
						,p_min_y 		IN 	NUMBER
						,p_max_y 		IN 	NUMBER
						,p_min_z 		IN 	NUMBER
						,p_max_z 		IN 	NUMBER
						,p_min_measure 	IN 	NUMBER
						,p_max_measure 	IN 	NUMBER
						,p_tolerance  	IN 	NUMBER
						,p_dim_array 	OUT VARCHAR2
						)
RETURN VARCHAR2
IS
	v_not_number 			BOOLEAN := FALSE;
	v_number	 			NUMBER;
	--
	v_dim_array_base 		VARCHAR2(32767);
	v_dim_array_3_measure	VARCHAR2(32767);
	v_dim_array_3 			VARCHAR2(32767);
	v_dim_array_4 			VARCHAR2(32767);
BEGIN
	BEGIN 
		v_number := TO_NUMBER(p_max_measure);
	EXCEPTION
		WHEN OTHERS THEN 
			v_not_number := TRUE;
	END;
	--
	--
	v_dim_array_base := 'MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT(''X'', ' || p_min_x || ', ' || p_max_x || ', ' || p_tolerance || '), ' || 'MDSYS.SDO_DIM_ELEMENT(''Y'', ' || p_min_y || ', ' || p_max_y || ', ' || p_tolerance;
	--
	v_dim_array_3_measure := '), ' || 'MDSYS.SDO_DIM_ELEMENT(''Z'', ' || p_min_z || ', ' || p_max_z || ', ' || p_tolerance || '))';
	--
	v_dim_array_3 := '), ' || 'MDSYS.SDO_DIM_ELEMENT(''M'', ' || p_min_measure || ', ' || p_max_measure || ', ' || p_tolerance || '))';
	--
	IF (p_shp_dims = 2) OR (p_shp_dims = 0) THEN
		p_dim_array := v_dim_array_base;
	ELSIF (p_shp_dims = 3) AND v_not_number THEN
		p_dim_array := v_dim_array_base || v_dim_array_3_measure;
	ELSIF (p_shp_dims = 3) THEN
		p_dim_array := v_dim_array_base || v_dim_array_3;
	ELSIF (p_shp_dims = 4) THEN
		p_dim_array := v_dim_array_base || v_dim_array_3_measure || v_dim_array_3;
	END IF;
	--
	p_dim_array := p_dim_array || '))';
	--
	RETURN 'Y';
EXCEPTION 
	WHEN OTHERS THEN
		RETURN SQLERRM;
END build_dim_array;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION update_sdo_geom_metadata(p_table_name 	IN VARCHAR2
								 ,p_column_name IN VARCHAR2
								 ,p_shp_dims 	IN 	NUMBER
								 ,p_min_x 		IN 	NUMBER
								 ,p_max_x 		IN 	NUMBER
								 ,p_min_y 		IN 	NUMBER
								 ,p_max_y 		IN 	NUMBER
								 ,p_min_z 		IN 	NUMBER
								 ,p_max_z 		IN 	NUMBER
								 ,p_min_measure	IN 	NUMBER
								 ,p_max_measure	IN 	NUMBER
								 ,p_tolerance  	IN 	NUMBER
								 ) 
RETURN VARCHAR2
IS
	v_oracle_srid       NUMBER;
	v_epsg_srid         NUMBER;
	v_result 			VARCHAR2(32767);
	v_sgm_insert_query 	VARCHAR2(32767);
	v_dim_array			VARCHAR2(32767);
BEGIN
	v_result := get_srid2(v_oracle_srid, v_epsg_srid);
	--
	IF v_result = 'Y' THEN
		v_result := build_dim_array(p_shp_dims ,p_min_x ,p_max_x ,p_min_y ,p_max_y ,p_min_z ,p_max_z ,p_min_measure ,p_max_measure ,p_tolerance, v_dim_array);
		--
		IF v_result = 'Y' THEN
			v_sgm_insert_query := 'INSERT INTO user_sdo_geom_metadata VALUES (UPPER(q''[' || p_table_name || ']''), UPPER(q''[' || p_column_name || ']''), ' || v_dim_array || ', ' || v_oracle_srid || ')';
			--
			EXECUTE IMMEDIATE v_sgm_insert_query;
			--
			RETURN 'Y';
		ELSE
			RETURN v_result;
		END IF;
	ELSE
		RETURN v_result;
	END IF;
EXCEPTION 
	WHEN OTHERS THEN
		RETURN SQLERRM;
END update_sdo_geom_metadata;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION shputil(p_command IN sde_varchar_array)
RETURN VARCHAR2
	AS LANGUAGE JAVA
	NAME 'bentley.exor.gis.ShapefileUtility.callFromDB(oracle.sql.ARRAY) return java.lang.String';
--
---------------------------------------------------------------------------------------------------
--
END sde_util;
/