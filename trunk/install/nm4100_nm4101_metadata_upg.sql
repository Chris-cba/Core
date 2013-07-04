------------------------------------------------------------------
-- nm4100_nm4101_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4100_nm4101_metadata_upg.sql-arc   3.1   Jul 04 2013 14:16:24   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4100_nm4101_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:16:24  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:20  $
--       Version          : $Revision:   3.1  $
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF

DECLARE
  l_temp nm3type.max_varchar2;
BEGIN
  -- Dummy call to HIG to instantiate it
  l_temp := hig.get_version;
  l_temp := nm_debug.get_version;
EXCEPTION
  WHEN others
   THEN
 Null;
END;
/

BEGIN
  nm_debug.debug_off;
END;
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Add module metadata for HIG1811 - Fill Patterns
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Add module metadata for HIG1811 - Fill Patterns
-- 
------------------------------------------------------------------
INSERT INTO hig_modules
SELECT 'HIG1811','Fill Patterns','hig1811','FMX',NULL,'N','N','HIG','FORM'
  FROM dual
WHERE NOT EXISTS
   (SELECT 1 FROM hig_modules
     WHERE hmo_module = 'HIG1811');

INSERT INTO hig_module_roles
SELECT 'HIG1811', 'HIG_USER', 'NORMAL' 
  FROM dual
 WHERE NOT EXISTS
   (SELECT 1 FROM hig_module_roles
     WHERE hmr_module = 'HIG1811'
          AND hmr_mode = 'NORMAL' );


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New error messages
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108567
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- New error messages for validatiing NM_NT_GROUPINGS and NM_GROUP_RELATIONS records
-- 
------------------------------------------------------------------
INSERT INTO nm_errors
  SELECT 'NET', 462, NULL, 'The type chosen is not a datum', NULL
    FROM dual
   WHERE NOT EXISTS
     (SELECT 1 FROM nm_errors
       WHERE ner_appl = 'NET'
         AND ner_id = 462); 

INSERT INTO nm_errors
  SELECT 'NET', 463, NULL, 'The type chosen is not allowed sub groups', NULL
    FROM dual
   WHERE NOT EXISTS
     (SELECT 1 FROM nm_errors
       WHERE ner_appl = 'NET'
         AND ner_id = 463);
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Report on invalid Network Groupings
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108567
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Report on invalid Network Groupings
-- 
------------------------------------------------------------------
DECLARE
--
  CURSOR nng_cur
  IS
    SELECT 'The Group type ['||nng_group_type ||'] cannot reference the network type ['
                             ||nng_nt_type||'] - only datums can be used' nng_descr
      FROM nm_nt_groupings 
     WHERE NOT EXISTS
       (SELECT *
          FROM nm_types 
         WHERE nt_datum = 'Y' 
           AND nng_nt_type = nt_type);
--
  CURSOR ngr_cur
  IS
    SELECT 'The Group Type ['||ngr_parent_group_type||'] cannot be the parent of Group Type [' 
                             || ngr_child_group_type ||'] as it cannot have sub groups' ngr_descr 
      FROM nm_group_relations 
     WHERE EXISTS 
       (SELECT 1 
          FROM nm_group_types 
         WHERE ngr_parent_group_type = ngt_group_type
           AND ngt_sub_group_allowed = 'N');
--
  l_tab_results  nm3type.tab_varchar32767;
  sep            nm3type.max_varchar2 := '======================================================';
--
BEGIN
--
  dbms_output.enable;
  dbms_output.put_line(sep);
  dbms_output.put_line('Performing Network Grouping Validation');
--
  OPEN nng_cur;
  FETCH nng_cur BULK COLLECT INTO l_tab_results;
  CLOSE nng_cur;
--
  IF l_tab_results.COUNT = 0
  THEN
    dbms_output.put_line('Data Is Valid');
  ELSE
    dbms_output.put_line(sep);
    FOR i IN 1..l_tab_results.COUNT
    LOOP
      dbms_output.put_line(l_tab_results(i));
    END LOOP;
  END IF;
--
  dbms_output.put_line(sep);
  dbms_output.put_line('Performing Group Relations Validation');
--
  OPEN ngr_cur;
  FETCH ngr_cur BULK COLLECT INTO l_tab_results;
  CLOSE ngr_cur;
--
  IF l_tab_results.COUNT = 0
  THEN
    dbms_output.put_line('Data Is Valid');
  ELSE
    dbms_output.put_line(sep);
    FOR i IN 1..l_tab_results.COUNT
    LOOP
      dbms_output.put_line(l_tab_results(i));
    END LOOP;
  END IF;
--   
  dbms_output.put_line(sep);
--
  DECLARE
  --
    l_tab_vc  Nm3type.tab_varchar32767;
  --
    PROCEDURE append (pi_text IN Nm3type.max_varchar2)
    IS
    BEGIN
       nm3ddl.append_tab_varchar (l_tab_vc, pi_text);
    END append;
  --
  BEGIN
  --
    append('CREATE OR REPLACE TRIGGER nm_ngr_ngt_trg');
    append('--');
    append('--------------------------------------------------------------------------------');
    append('--   PVCS Identifiers :-');
    append('--');
    append('--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm4100_nm4101_metadata_upg.sql-arc   3.1   Jul 04 2013 14:16:24   James.Wadsworth  $');
    append('--       Module Name      : $Workfile:   nm4100_nm4101_metadata_upg.sql  $');
    append('--       Date into PVCS   : $Date:   Jul 04 2013 14:16:24  $');
    append('--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:20  $');
    append('--       PVCS Version     : $Revision:   3.1  $');
    append('--');
    append('--------------------------------------------------------------------------------');
    append('--');
    append('BEFORE INSERT OR UPDATE');
    append('ON nm_group_relations_all  FOR EACH ROW');
    append('--');
    append('DECLARE');
    append('  CURSOR nm_group_type_cur(p_ngr_parent_group_type nm_group_relations_all.ngr_parent_group_type%TYPE)  IS');
    append('  SELECT ''x'' ');
    append('    FROM nm_group_types ');
    append('   WHERE ngt_group_type = p_ngr_parent_group_type');
    append('     AND ngt_sub_group_allowed = ''N'';');
    append('--');
    append('  dummy VARCHAR2(1);');
    append('--');
    append('BEGIN');
    append('--');
    append('  OPEN nm_group_type_cur(:new.ngr_parent_group_type);');
    append('  FETCH nm_group_type_cur INTO dummy;');     
    append('-- ');
    append('  IF ( nm_group_type_cur%FOUND) THEN');
    append('    hig.raise_ner(''NET'',463,NULL,:new.ngr_parent_group_type );');
    append('  END IF;');
    append('  CLOSE nm_group_type_cur;');
    append('--');
    append('END nm_ngr_ngt_trg;');
  --
    nm3ddl.execute_tab_varchar (l_tab_vc);
  --
  END;
--
  DECLARE
  --
    l_tab_vc  Nm3type.tab_varchar32767;
  --
    PROCEDURE append (pi_text IN nm3type.max_varchar2)
    IS
    BEGIN
      nm3ddl.append_tab_varchar (l_tab_vc, pi_text);
    END append;
  --
  BEGIN
  --
    append('CREATE OR REPLACE TRIGGER nm_nt_gps_trg');
    append('--');
    append('--------------------------------------------------------------------------------');
    append('--   PVCS Identifiers :-');
    append('--');
    append('--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm4100_nm4101_metadata_upg.sql-arc   3.1   Jul 04 2013 14:16:24   James.Wadsworth  $');
    append('--       Module Name      : $Workfile:   nm4100_nm4101_metadata_upg.sql  $');
    append('--       Date into PVCS   : $Date:   Jul 04 2013 14:16:24  $');
    append('--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:20  $');
    append('--       PVCS Version     : $Revision:   3.1  $');
    append('--');
    append('--------------------------------------------------------------------------------');
    append('--');
    append('BEFORE INSERT OR UPDATE');
    append('ON nm_nt_groupings_all  FOR EACH ROW');
    append('--');
    append('DECLARE');
    append('  CURSOR nm_type_cur(p_nng_nt_type nm_nt_groupings_all.nng_nt_type%type)  IS');
    append('  SELECT ''x''');
    append('    FROM nm_types');
    append('   WHERE nt_datum = ''Y''');
    append('     AND nt_type = p_nng_nt_type;');
    append('--');
    append('  dummy VARCHAR2(1);');
    append('--');
    append('BEGIN');
    append('--');
    append('  OPEN nm_type_cur(:new.nng_nt_type);');
    append('  FETCH nm_type_cur INTO dummy;');     
    append('--');
    append('  IF ( nm_type_cur%NOTFOUND) THEN');
    append('    hig.raise_ner(''NET'',462,NULL,:new.nng_nt_type );');
    append('  END IF;');
    append('  CLOSE nm_type_cur;');
    append('--');
    append('END nm_nt_gps_trg;');
  --
    nm3ddl.execute_tab_varchar (l_tab_vc);
  --
  END;
--
END;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Remove RELATIVE relationship for Inv Type Groupings
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Remove RELATIVE relationship for Inv Type Groupings
-- 
------------------------------------------------------------------
DECLARE
  l_dummy VARCHAR2(1);
BEGIN
--
  SELECT '1' INTO l_dummy FROM nm_inv_type_groupings
   WHERE itg_relation = 'RELATIVE' AND ROWNUM=1;
--
  dbms_output.put_line ('Cannot remove RELATIVE - NM_INV_TYPE_GROUPINGS exist which use it');
--
EXCEPTION
  WHEN NO_DATA_FOUND
--
-- If there are no relationships using RELATIVE then we delete the code
--
  THEN
    DELETE hig_codes
     WHERE UPPER (hco_domain) = 'INV_RELATION' 
       AND UPPER (hco_code) = 'RELATIVE';
--
END;
/

------------------------------------------------------------------


------------------------------------------------------------------

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

