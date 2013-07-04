------------------------------------------------------------------
-- nm4050_nm4051_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4050_nm4051_metadata_upg.sql-arc   3.4   Jul 04 2013 14:10:58   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4050_nm4051_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:10:58  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:20  $
--       Version          : $Revision:   3.4  $
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
PROMPT HIG_STANDARD_FAVOURITES
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- New data
-- 
------------------------------------------------------------------
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NSG'
       ,'NSG_ADMINISTRATION'
       ,'Administration'
       ,'F'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NSG'
                    AND  HSTF_CHILD = 'NSG_ADMINISTRATION');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NSG_ADMINISTRATION'
       ,'NSG0120'
       ,'Administer User Districts'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NSG_ADMINISTRATION'
                    AND  HSTF_CHILD = 'NSG0120');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NSG_ADMINISTRATION'
       ,'NSG0130'
       ,'My Districts'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NSG_ADMINISTRATION'
                    AND  HSTF_CHILD = 'NSG0130');

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Add Oracle LRS Geometry Types to HIG_CODES
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Add Oracle LRS Geometry Types to HIG_CODES
-- 
------------------------------------------------------------------
INSERT INTO hig_codes
SELECT 'GEOMETRY_TYPE',
       TO_NUMBER (hco_code) + 300,
       hco_meaning || ' LRS',
       hco_system,
       hco_seq + 7,
       NULL,
       NULL
  FROM hig_codes a
 WHERE hco_domain = 'GEOMETRY_TYPE' 
   AND hco_code LIKE '300%'
   AND NOT EXISTS
     (SELECT 1 FROM hig_codes b
       WHERE TO_NUMBER(b.hco_code) = TO_NUMBER (a.hco_code) + 300
         AND b.hco_domain = 'GEOMETRY_TYPE');
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Mapbuilder Upgrade
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- **** COMMENTS TO BE ADDED BY ADRIAN EDWARDS ****
-- 
------------------------------------------------------------------
------------------------------
-- Create GIS_SUPERUSER role
------------------------------


PROMPT Create GIS_SUPERUSER Role
DECLARE
  CURSOR c1 IS
    SELECT role FROM dba_roles
     WHERE role = 'GIS_SUPERUSER';
  dummy VARCHAR2(100);
BEGIN
  OPEN c1;
  FETCH c1 INTO dummy;
  CLOSE c1;
  IF dummy IS NULL
  THEN
    EXECUTE IMMEDIATE 'CREATE ROLE GIS_SUPERUSER';
  END IF;
END;
/

PROMPT Create GIS_SUPERUSER exor Role
INSERT INTO hig_roles
   (hro_role, hro_product, hro_descr)
SELECT 'GIS_SUPERUSER', 'HIG', 'GIS Super User Administration Role'
  FROM DUAL
 WHERE NOT EXISTS
   (SELECT 1 FROM hig_roles
      WHERE hro_role = 'GIS_SUPERUSER');

-----------------------------
-- Create MAPBUILDER module
-----------------------------

PROMPT Create MAPBUILDER module
INSERT INTO hig_modules
   ( hmo_module, hmo_title, hmo_filename, hmo_module_type
   , hmo_fastpath_invalid, hmo_use_gri, hmo_application, hmo_menu)
SELECT 'MAPBUILDER', 'Oracle Mapbuilder', 'mapbuilder', 'EXE', 'Y', 'N', 'HIG', 'FORM'
  FROM DUAL
 WHERE NOT EXISTS
   (SELECT 1 FROM hig_modules
     WHERE hmo_module = 'MAPBUILDER');

----------------------------------
-- Create MAPBUILDER module role
----------------------------------

PROMPT Create GIS_SUPERUSER > MAPBUILDER Module Role association
INSERT INTO hig_module_roles
   (hmr_module, hmr_role, hmr_mode)
SELECT 'MAPBUILDER', 'GIS_SUPERUSER', 'NORMAL'
  FROM DUAL
 WHERE NOT EXISTS
   (SELECT 1 FROM hig_module_roles
     WHERE hmr_module = 'MAPBUILDER'
       AND hmr_role = 'GIS_SUPERUSER');


------------------------------------------------------------
-- Create HIG_USER_ROLE entry for HIGHWAYS to GIS_SUPERUSER
------------------------------------------------------------
PROMPT Associate Highways OWner with GIS_SUPERUSER Role
INSERT INTO hig_user_roles
            (hur_username, hur_role, hur_start_date)
   SELECT hig.get_application_owner,
          'GIS_SUPERUSER',
          TRUNC (SYSDATE)
     FROM DUAL
    WHERE NOT EXISTS (
             SELECT 1
               FROM hig_user_roles
              WHERE hur_username = hig.get_application_owner
                AND hur_role = 'GIS_SUPERUSER');

PROMPT Grant GIS_SUPERUSER to Highways Owner
BEGIN
  EXECUTE IMMEDIATE 'GRANT GIS_SUPERUSER TO '||hig.get_application_owner;
END;
/




--------------------------------------------------
--  Apply new USER_SDO_X views to HIGHWAYS OWNER
--------------------------------------------------
PROMPT Upgrade USER_SDO_THEMES/STYLES/MAPS views for Highways Owner
BEGIN
--
  EXECUTE IMMEDIATE 
    'CREATE OR REPLACE FORCE VIEW '||hig.get_application_owner||'.user_sdo_maps '||chr(10)||
    '       (name, description, definition) '||chr(10)||
    ' AS '||chr(10)||
    '   SELECT NAME, '||chr(10)||
    '          description, '||chr(10)||
    '          definition '||chr(10)||
    '     FROM MDSYS.sdo_maps_table '||chr(10)||
    '    WHERE sdo_owner = '||nm3flx.string(hig.get_application_owner);
--
  EXECUTE IMMEDIATE 
    'CREATE OR REPLACE FORCE VIEW '||hig.get_application_owner||'.user_sdo_themes '||chr(10)||
    '        (name, description, base_table, geometry_column, styling_rules ) '||chr(10)||
    'AS '||chr(10)||
    '   SELECT NAME, '||chr(10)||
    '          description, '||chr(10)||
    '          base_table, '||chr(10)||
    '          geometry_column, '||chr(10)||
    '          styling_rules '||chr(10)||
    '     FROM MDSYS.sdo_themes_table '||chr(10)||
    '    WHERE sdo_owner = '||nm3flx.string(hig.get_application_owner);
--
  EXECUTE IMMEDIATE 
    'CREATE OR REPLACE FORCE VIEW '||hig.get_application_owner||'.user_sdo_styles 
             (name, type, description, definition, image, geometry) '||chr(10)||
    'AS '||chr(10)||
    '   SELECT NAME, '||chr(10)||
    '          TYPE, '||chr(10)||
    '          description, '||chr(10)||
    '          definition, '||chr(10)||
    '          image, '||chr(10)||
    '          geometry '||chr(10)||
    '     FROM MDSYS.sdo_styles_table '||chr(10)||
    '    WHERE sdo_owner = '||nm3flx.string(hig.get_application_owner);
--
END;
/

------------------------------------------------
-- Apply USER_SDO_X views to subordinate users
------------------------------------------------

PROMPT Rebuild USER_SDO_THEMES/STYLES/MAPS views for all subordinate users

DECLARE
--
  l_owner       VARCHAR2(30) := hig.get_application_owner;
  l_tab_views   nm3type.tab_varchar30;
--
  CURSOR all_users
  IS
    SELECT hus_username
      FROM hig_users
     WHERE hus_is_hig_owner_flag = 'N'
       AND hus_username !=  'TMAWS'
       AND EXISTS
         (SELECT 1 FROM all_users
           WHERE username = hus_username);
--
BEGIN
--
-- Drop any private synonyms first
  FOR s IN
    (SELECT owner, synonym_name
       FROM dba_synonyms
      WHERE owner IN (SELECT hus_username FROM hig_users)
        AND synonym_name IN ('USER_SDO_MAPS', 'USER_SDO_THEMES', 'USER_SDO_STYLES')
        AND owner != 'PUBLIC')
  LOOP
    EXECUTE IMMEDIATE 'DROP SYNONYM '||s.owner||'.'||s.synonym_name;
  END LOOP;
--
  l_tab_views(1) := 'USER_SDO_MAPS';
  l_tab_views(2) := 'USER_SDO_STYLES';
  l_tab_views(3) := 'USER_SDO_THEMES';
--
-- Recreate all subordinate user mapbuilder views
  FOR i IN all_users
  LOOP
  --
    FOR z IN 1..l_tab_views.COUNT
    LOOP
      BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE FORCE VIEW '||i.hus_username
                       ||'.'||l_tab_views(z)
                       ||' AS SELECT * FROM '||l_owner||'.'||l_tab_views(z);
        EXCEPTION
          WHEN OTHERS THEN dbms_output.put_line ('Error '||i.hus_username||' - '||SQLERRM);
        END;
    END LOOP;
  --
  END LOOP;
--
  FOR i IN ( SELECT owner, name, text FROM all_errors
              WHERE owner IN (SELECT hus_username FROM hig_users)
                AND name IN ('USER_SDO_MAPS', 'USER_SDO_THEMES', 'USER_SDO_STYLES'))
  LOOP
    dbms_output.put_line ('Compilation error '||i.owner||' - '||i.name||' - '||i.text);
  END LOOP;
--
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TRIGGER USER_SDO_MAPS_INS_TRG';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

PROMPT Create USER_SDO_MAPS trigger

BEGIN
--
  EXECUTE IMMEDIATE
    'CREATE OR REPLACE TRIGGER '||hig.get_application_owner||'.USER_SDO_MAPS_INS_TRG '||chr(10)||
    '------------------------------------------------------------------------- '||chr(10)||
    '--   PVCS Identifiers :- '||chr(10)||
    '-- '||chr(10)||
    '--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4050_nm4051_metadata_upg.sql-arc   3.4   Jul 04 2013 14:10:58   James.Wadsworth  $ '||chr(10)||
    '--       Module Name      : $Workfile:   nm4050_nm4051_metadata_upg.sql  $ '||chr(10)||
    '--       Date into PVCS   : $Date:   Jul 04 2013 14:10:58  $ '||chr(10)||
    '--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:20  $ '||chr(10)||
    '--       Version          : $Revision:   3.4  $ '||chr(10)||
    '--       Based on SCCS version : '||chr(10)|| 
    '------------------------------------------------------------------------- '||chr(10)||
    'INSTEAD OF DELETE OR INSERT OR UPDATE '||chr(10)||
    'ON '||hig.get_application_owner||'.USER_SDO_MAPS '||chr(10)|| 
    'REFERENCING NEW AS NEW OLD AS OLD '||chr(10)||
    'FOR EACH ROW '||chr(10)||
    'DECLARE '||chr(10)||
    '   l_rec_usm user_sdo_maps%ROWTYPE; '||chr(10)||
    'BEGIN '||chr(10)||
    '-- '||chr(10)||
    '  IF INSERTING '||chr(10)|| 
    '  THEN '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_usm.name        := :NEW.name; '||chr(10)||
    '    l_rec_usm.description := :NEW.description; '||chr(10)||
    '    l_rec_usm.definition  := :NEW.definition; '||chr(10)|| 
    '  -- '||chr(10)||
    '    nm3msv_sec.do_usm_ins ( pi_username => USER '||chr(10)||
    '                          , pi_rec_usm  => l_rec_usm ); '||chr(10)||
    '  -- '||chr(10)||
    '  ELSIF DELETING '||chr(10)|| 
    '  THEN '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_usm.name        := :OLD.name; '||chr(10)||
    '    l_rec_usm.description := :OLD.description; '||chr(10)||
    '    l_rec_usm.definition  := :OLD.definition; '||chr(10)||
    '  -- '||chr(10)||
    '    nm3msv_sec.do_usm_del ( pi_username => USER '||chr(10)||
    '                          , pi_rec_usm  => l_rec_usm ); '||chr(10)||
    '  -- '||chr(10)||
    '  ELSIF UPDATING '||chr(10)|| 
    '  THEN '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_usm.name        := NVL (:NEW.name, :OLD.name); '||chr(10)||
    '    l_rec_usm.description := NVL (:NEW.description, :OLD.description); '||chr(10)||
    '    l_rec_usm.definition  := NVL (:NEW.definition, :OLD.definition); '||chr(10)||
    '  -- '||chr(10)||
    '    nm3msv_sec.do_usm_upd ( pi_username => USER '||chr(10)||
    '                          , pi_rec_usm  => l_rec_usm ); '||chr(10)||
    '  -- '||chr(10)||
    '  END IF; '||chr(10)||
    '-- '||chr(10)||
    'END; ';
END;
/



BEGIN
  EXECUTE IMMEDIATE 'DROP TRIGGER USER_SDO_STYLES_INS_TRG';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

PROMPT Create USER_SDO_STYLES trigger

BEGIN
--
  EXECUTE IMMEDIATE
    'CREATE OR REPLACE TRIGGER '||hig.get_application_owner||'.USER_SDO_STYLES_INS_TRG '||chr(10)||
    '------------------------------------------------------------------------- '||chr(10)||
    '--   PVCS Identifiers :- '||chr(10)||
    '-- '||chr(10)||
    '--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4050_nm4051_metadata_upg.sql-arc   3.4   Jul 04 2013 14:10:58   James.Wadsworth  $ '||chr(10)||
    '--       Module Name      : $Workfile:   nm4050_nm4051_metadata_upg.sql  $ '||chr(10)||
    '--       Date into PVCS   : $Date:   Jul 04 2013 14:10:58  $ '||chr(10)||
    '--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:20  $ '||chr(10)||
    '--       Version          : $Revision:   3.4  $ '||chr(10)||
    '--       Based on SCCS version : '||chr(10)|| 
    '------------------------------------------------------------------------- '||chr(10)||
    'INSTEAD OF DELETE OR INSERT OR UPDATE '||chr(10)||
    'ON '||hig.get_application_owner||'.USER_SDO_STYLES REFERENCING NEW AS NEW OLD AS OLD '||chr(10)||
    'FOR EACH ROW '||chr(10)||
    'DECLARE '||chr(10)||
    '  l_rec_uss user_sdo_styles%ROWTYPE; '||chr(10)||
    'BEGIN '||chr(10)||
    '-- '||chr(10)||
    '  IF INSERTING '||chr(10)|| 
    '  THEN '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_uss.name         := :NEW.name; '||chr(10)||
    '    l_rec_uss.type         := :NEW.type; '||chr(10)||
    '    l_rec_uss.description  := :NEW.description; '||chr(10)||
    '    l_rec_uss.definition   := :NEW.definition; '||chr(10)||
    '    l_rec_uss.image        := :NEW.image; '||chr(10)||
    '    l_rec_uss.geometry     := :NEW.geometry; '||chr(10)||
    '  -- '||chr(10)||
    '    nm3msv_sec.do_uss_ins ( pi_username => USER '||chr(10)||
    '                          , pi_rec_uss  => l_rec_uss ); '||chr(10)||
    '  -- '||chr(10)||
    '  ELSIF DELETING '||chr(10)|| 
    '  THEN '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_uss.name         := :OLD.name; '||chr(10)||
    '    l_rec_uss.type         := :OLD.type; '||chr(10)||
    '    l_rec_uss.description  := :OLD.description; '||chr(10)||
    '    l_rec_uss.definition   := :OLD.definition; '||chr(10)||
    '    l_rec_uss.image        := :OLD.image; '||chr(10)||
    '    l_rec_uss.geometry     := :OLD.geometry; '||chr(10)||
    '  -- '||chr(10)||
    '     nm3msv_sec.do_uss_del ( pi_username => USER '||chr(10)||
    '                           , pi_rec_uss  => l_rec_uss ); '||chr(10)|| 
    '  -- '||chr(10)||
    '  ELSIF UPDATING '||chr(10)|| 
    '  THEN '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_uss.name         := NVL (:NEW.name, :OLD.name); '||chr(10)||
    '    l_rec_uss.type         := NVL (:NEW.type, :OLD.type); '||chr(10)||
    '    l_rec_uss.description  := NVL (:NEW.description, :OLD.description); '||chr(10)||
    '    l_rec_uss.definition   := NVL (:NEW.definition, :OLD.definition); '||chr(10)||
    '  -- '||chr(10)||
    '    IF :NEW.image IS NOT NULL '||chr(10)|| 
    '    THEN '||chr(10)||
    '      l_rec_uss.image     :=:NEW.image; '||chr(10)||
    '    ELSE '||chr(10)||
    '      l_rec_uss.image     :=:OLD.image; '||chr(10)||
    '    END IF; '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_uss.geometry := NVL (:NEW.geometry, :OLD.geometry); '||chr(10)||
    '  -- '||chr(10)||
    '    nm3msv_sec.do_uss_upd ( pi_username => USER '||chr(10)||
    '                          , pi_rec_uss  => l_rec_uss ); '||chr(10)||
    '  -- '||chr(10)||
    '  END IF; '||chr(10)||
    '-- '||chr(10)||
    'END; ';
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TRIGGER USER_SDO_THEMES_INS_TRG';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

PROMPT Create USER_SDO_THEMES trigger

BEGIN
--
  EXECUTE IMMEDIATE
    'CREATE OR REPLACE TRIGGER '||hig.get_application_owner||'.USER_SDO_THEMES_INS_TRG '||chr(10)||
    '-------------------------------------------------------------------------'||chr(10)||
    '--   PVCS Identifiers :-'||chr(10)||
    '-- '||chr(10)||
    '--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4050_nm4051_metadata_upg.sql-arc   3.4   Jul 04 2013 14:10:58   James.Wadsworth  $'||chr(10)||
    '--       Module Name      : $Workfile:   nm4050_nm4051_metadata_upg.sql  $'||chr(10)||
    '--       Date into PVCS   : $Date:   Jul 04 2013 14:10:58  $'||chr(10)||
    '--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:20  $'||chr(10)||
    '--       Version          : $Revision:   3.4  $'||chr(10)||
    '--       Based on SCCS version :'|| chr(10)||
    '-------------------------------------------------------------------------'||chr(10)||
    'INSTEAD OF DELETE OR INSERT OR UPDATE '||chr(10)||
    'ON '||hig.get_application_owner||'.USER_SDO_THEMES '||chr(10)|| 
    'REFERENCING NEW AS NEW OLD AS OLD '||chr(10)||
    'FOR EACH ROW '||chr(10)||
    'DECLARE '||chr(10)||
    '   l_rec_ust user_sdo_themes%ROWTYPE; '||chr(10)||
    'BEGIN '||chr(10)||
    '-- '||chr(10)||
    '  IF INSERTING '||chr(10)|| 
    '  THEN '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_ust.name             := :NEW.name; '||chr(10)||
    '    l_rec_ust.description      := :NEW.description; '||chr(10)||
    '    l_rec_ust.base_table       := :NEW.base_table; '||chr(10)||
    '    l_rec_ust.geometry_column  := :NEW.geometry_column; '||chr(10)||
    '    l_rec_ust.styling_rules    := :NEW.styling_rules; '||chr(10)||
    '  -- '||chr(10)||
    '    nm3msv_sec.do_ust_ins ( pi_username => USER '||chr(10)||
    '                          , pi_rec_ust  => l_rec_ust ); '||chr(10)||
    '  -- '||chr(10)||
    '  ELSIF DELETING '||chr(10)|| 
    '  THEN '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_ust.name             := :OLD.name; '||chr(10)||
    '    l_rec_ust.description      := :OLD.description; '||chr(10)||
    '    l_rec_ust.base_table       := :OLD.base_table; '||chr(10)||
    '    l_rec_ust.geometry_column  := :OLD.geometry_column; '||chr(10)||
    '    l_rec_ust.styling_rules    := :OLD.styling_rules; '||chr(10)||
    '  -- '||chr(10)||
    '    nm3msv_sec.do_ust_del ( pi_username => USER '||chr(10)||
    '                          , pi_rec_ust  => l_rec_ust ); '||chr(10)||
    '  -- '||chr(10)||
    '  ELSIF UPDATING '||chr(10)|| 
    '  THEN '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_ust.name             := NVL(:NEW.name, :OLD.name); '||chr(10)||
    '    l_rec_ust.description      := NVL (:NEW.description, :OLD.description); '||chr(10)||
    '    l_rec_ust.base_table       := NVL(:NEW.base_table, :OLD.base_table); '||chr(10)||
    '    l_rec_ust.geometry_column  := NVL(:NEW.geometry_column, :OLD.geometry_column); '||chr(10)||
    '    l_rec_ust.styling_rules    := NVL (:NEW.styling_rules, :OLD.styling_rules); '||chr(10)||
    '  -- '||chr(10)||
    '    nm3msv_sec.do_ust_upd ( pi_username => USER '||chr(10)||
    '                          , pi_rec_ust  => l_rec_ust ); '||chr(10)||
    '  -- '||chr(10)||
    '  END IF; '||chr(10)||
    '-- '||chr(10)||
    'END; ';
END;
/

PROMPT Recompile dependent packages

BEGIN
  EXECUTE IMMEDIATE 'ALTER PACKAGE NM3SDM COMPILE';
  EXECUTE IMMEDIATE 'ALTER PACKAGE NM3SDM COMPILE BODY';
END;
/



------------------------------------------------------------------


------------------------------------------------------------------

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

