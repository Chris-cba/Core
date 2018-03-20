--
---------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/Java/shapefile/install/install_sdeutil.sql-arc   1.3   Mar 20 2018 04:36:22   Upendra.Hukeri  $
--       Module Name      : $Workfile:   install_sdeutil.sql  $
--       Date into PVCS   : $Date:   Mar 20 2018 04:36:22  $
--       Date fetched Out : $Modtime:   Mar 20 2018 03:50:02  $
--       PVCS Version     : $Revision:   1.3  $
--
--   Author : Upendra Hukeri
--
---------------------------------------------------------------------------------------------------
-- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
---------------------------------------------------------------------------------------------------
--
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
SET SERVEROUTPUT ON
--
VARIABLE tab_file_name VARCHAR2(50);
VARIABLE trg_file_name VARCHAR2(50);
--
COLUMN :tab_file_name NEW_VALUE tab_file NOPRINT;
COLUMN :trg_file_name NEW_VALUE trg_file NOPRINT;
--
-- Grab date/time to append to log file name
--
UNDEFINE sde_log_extension
COL      sde_log_extension NEW_VALUE sde_log_extension NOPRINT
SET TERM OFF
SELECT TO_CHAR(SYSDATE, 'ddmmyyyyhh24miss') || '.log' sde_log_extension FROM DUAL
/
SET TERM ON
--
--------------------------------------------------------------------------------
-- Spool to Logfile
--------------------------------------------------------------------------------
--
DEFINE sde_logfile='java_shapefile_tool_&sde_log_extension'
spool &sde_logfile
--
--------------------------------------------------------------------------------
-- TYPES
--------------------------------------------------------------------------------
--
DECLARE 
	CURSOR c1 
	IS 
	SELECT 1 
	FROM   user_objects 
	WHERE  object_name = 'SDE_VARCHAR_2D_ARRAY';
	--
	v_temp1 NUMBER := NULL;
	--
	CURSOR c2 
	IS 
	SELECT 1 
	FROM   user_objects 
	WHERE  object_name = 'SDE_VARCHAR_ARRAY';
	--
	v_temp2 NUMBER := NULL;
BEGIN
	OPEN  c1;
	FETCH c1 INTO v_temp1;
	CLOSE c1;
	--
	IF v_temp1 IS NOT NULL THEN 
		EXECUTE IMMEDIATE 'DROP TYPE SDE_VARCHAR_2D_ARRAY';
	END IF;
	--
	OPEN  c2;
	FETCH c2 INTO v_temp2;
	CLOSE c2;
	--
	IF v_temp2 IS NOT NULL THEN 
		EXECUTE IMMEDIATE 'DROP TYPE SDE_VARCHAR_ARRAY';
	END IF;
END;
/
--
SET TERM ON
PROMPT sde_varchar_array
SET TERM OFF
--
SET FEEDBACK ON
START sde_varchar_array.tyh
SET FEEDBACK OFF
--
SET TERM ON
PROMPT sde_varchar_2d_array
SET TERM OFF
--
SET FEEDBACK ON
START sde_varchar_2d_array.tyh
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- ROLES
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT Creating Role SDE_USER
SET TERM OFF
--
BEGIN
	EXECUTE IMMEDIATE 'CREATE ROLE SDE_ADMIN';
	--
	dbms_output.put_line(CHR(10) || 'Role created.' || CHR(10));
EXCEPTION
	WHEN OTHERS THEN
		-- ORA-01921: If The role name exists, ignore the error.
		IF SQLCODE = -01921 THEN
			dbms_output.put_line(CHR(10) || 'Role already exists.' || CHR(10));
		ELSE
			RAISE;
		END IF;
END;
/
--
BEGIN
	EXECUTE IMMEDIATE 'CREATE ROLE SDE_USER';
	--
	dbms_output.put_line(CHR(10) || 'Role created.' || CHR(10));
EXCEPTION
	WHEN OTHERS THEN
		-- ORA-01921: If The role name exists, ignore the error.
		IF SQLCODE = -01921 THEN
			dbms_output.put_line(CHR(10) || 'Role already exists.' || CHR(10));
		ELSE
			RAISE;
		END IF;
END;
/
--
--------------------------------------------------------------------------------
-- TABLES
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT Creating Table SDE_WHERE
SET TERM OFF
--
DECLARE
	CURSOR check_table IS
	SELECT  1 
	  FROM user_tables
	 WHERE UPPER(table_name) = 'SDE_WHERE';
	--
	v_temp NUMBER := NULL;
BEGIN
	OPEN check_table;
	FETCH check_table INTO v_temp;
	CLOSE check_table;
	--
	IF v_temp IS NULL THEN 
		:tab_file_name := 'sde_where.tab';
		:trg_file_name := 'sde_where_1_trg.trg';
	ELSE
		dbms_output.put_line(CHR(10) || 'Table already exists.' || CHR(10));
		:tab_file_name := 'null.sql';
		:trg_file_name := 'null.sql';
	END IF;
END;
/
--
SELECT :tab_file_name FROM DUAL;
@@&tab_file;
--
SELECT :trg_file_name FROM DUAL;
@@&trg_file;
--
SET TERM ON
PROMPT Creating Table SDE_TABLES
SET TERM OFF
--
DECLARE
	CURSOR check_table IS
	SELECT  1 
	  FROM user_tables
	 WHERE UPPER(table_name) = 'SDE_TABLES';
	--
	v_temp NUMBER := NULL;
BEGIN
	OPEN check_table;
	FETCH check_table INTO v_temp;
	CLOSE check_table;
	--
	IF v_temp IS NULL THEN 
		:tab_file_name := 'sde_tables.tab';
		:trg_file_name := 'sde_tables_1_trg.trg';
	ELSE
		dbms_output.put_line(CHR(10) || 'Table already exists.' || CHR(10));
		:tab_file_name := 'null.sql';
		:trg_file_name := 'null.sql';
	END IF;
END;
/
--
SELECT :tab_file_name FROM DUAL;
@@&tab_file;
--
SELECT :trg_file_name FROM DUAL;
@@&trg_file;
--
SET TERM ON
PROMPT Creating Table SDE_REGISTRY
SET TERM OFF
--
DECLARE
	CURSOR check_table IS
	SELECT  1 
	  FROM user_tables
	 WHERE UPPER(table_name) = 'SDE_REGISTRY';
	--
	v_temp NUMBER := NULL;
BEGIN
	OPEN check_table;
	FETCH check_table INTO v_temp;
	CLOSE check_table;
	--
	IF v_temp IS NULL THEN 
		:tab_file_name := 'sde_registry.tab';
	ELSE
		dbms_output.put_line(CHR(10) || 'Table already exists.' || CHR(10));
		:tab_file_name := 'null.sql';
	END IF;
END;
/
--
SET TERM OFF
SELECT :tab_file_name FROM DUAL;
--
@@&tab_file;
SET TERM ON
--
--------------------------------------------------------------------------------
-- PACKAGE HEADER
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT Creating Package Header sde_util
SET TERM OFF
--
SET FEEDBACK ON
START sde_util.pkh
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- PACKAGE BODY
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT Creating Package Body sde_util
SET TERM OFF
--
SET FEEDBACK ON
START sde_util.pkw
SET FEEDBACK OFF
--
SPOOL OFF
--
EXIT
--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************
---------------------------------------------------------------------------------------------------
--