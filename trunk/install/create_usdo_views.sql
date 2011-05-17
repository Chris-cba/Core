--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/create_usdo_views.sql-arc   3.1   May 17 2011 08:33:20   Steve.Cooper  $
--       Module Name      : $Workfile:   create_usdo_views.sql  $
--       Date into PVCS   : $Date:   May 17 2011 08:33:20  $
--       Date fetched Out : $Modtime:   May 06 2011 10:07:02  $
--       PVCS Version     : $Revision:   3.1  $
--
--------------------------------------------------------------------------------
--

--------------------------------------------------
--  Apply new USER_SDO_X views to HIGHWAYS OWNER
--------------------------------------------------
PROMPT Upgrade USER_SDO_THEMES/STYLES/MAPS views for Highways Owner
BEGIN
--
  EXECUTE IMMEDIATE 'GRANT SELECT ON HIG_USERS TO MDSYS';
--
  EXECUTE IMMEDIATE 
    'CREATE OR REPLACE FORCE VIEW '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.user_sdo_maps '||chr(10)||
    '       (name, description, definition) '||chr(10)||
    ' AS '||chr(10)||
    '   SELECT NAME, '||chr(10)||
    '          description, '||chr(10)||
    '          definition '||chr(10)||
    '     FROM MDSYS.sdo_maps_table '||chr(10)||
    '    WHERE sdo_owner = '||nm3flx.string(Sys_Context('NM3CORE','APPLICATION_OWNER'));
--
  EXECUTE IMMEDIATE 
    'CREATE OR REPLACE FORCE VIEW '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.user_sdo_themes '||chr(10)||
    '        (name, description, base_table, geometry_column, styling_rules ) '||chr(10)||
    'AS '||chr(10)||
    '   SELECT NAME, '||chr(10)||
    '          description, '||chr(10)||
    '          base_table, '||chr(10)||
    '          geometry_column, '||chr(10)||
    '          styling_rules '||chr(10)||
    '     FROM MDSYS.sdo_themes_table '||chr(10)||
    '    WHERE sdo_owner = '||nm3flx.string(Sys_Context('NM3CORE','APPLICATION_OWNER'));
--
  EXECUTE IMMEDIATE 
    'CREATE OR REPLACE FORCE VIEW '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.user_sdo_styles 
             (name, type, description, definition, image, geometry) '||chr(10)||
    'AS '||chr(10)||
    '   SELECT NAME, '||chr(10)||
    '          TYPE, '||chr(10)||
    '          description, '||chr(10)||
    '          definition, '||chr(10)||
    '          image, '||chr(10)||
    '          geometry '||chr(10)||
    '     FROM MDSYS.sdo_styles_table '||chr(10)||
    '    WHERE sdo_owner = '||nm3flx.string(Sys_Context('NM3CORE','APPLICATION_OWNER'));
--
END;
/

------------------------------------------------
-- Apply USER_SDO_X views to subordinate users
------------------------------------------------

PROMPT Rebuild USER_SDO_THEMES/STYLES/MAPS views for all subordinate users

DECLARE
--
  l_owner       VARCHAR2(30) := Sys_Context('NM3CORE','APPLICATION_OWNER');
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
    'CREATE OR REPLACE TRIGGER '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.USER_SDO_MAPS_INS_TRG '||chr(10)||
    '------------------------------------------------------------------------- '||chr(10)||
    '--   PVCS Identifiers :- '||chr(10)||
    '-- '||chr(10)||
    '--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/create_usdo_views.sql-arc   3.1   May 17 2011 08:33:20   Steve.Cooper  $ '||chr(10)||
    '--       Module Name      : $Workfile:   create_usdo_views.sql  $ '||chr(10)||
    '--       Date into PVCS   : $Date:   May 17 2011 08:33:20  $ '||chr(10)||
    '--       Date fetched Out : $Modtime:   May 06 2011 10:07:02  $ '||chr(10)||
    '--       Version          : $Revision:   3.1  $ '||chr(10)||
    '--       Based on SCCS version : '||chr(10)|| 
    '------------------------------------------------------------------------- '||chr(10)||
    'INSTEAD OF DELETE OR INSERT OR UPDATE '||chr(10)||
    'ON '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.USER_SDO_MAPS '||chr(10)|| 
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
    '    nm3msv_sec.do_usm_ins ( pi_username => Sys_Context(''NM3_SECURITY_CTX'',''USERNAME'') '||chr(10)||
    '                          , pi_rec_usm  => l_rec_usm ); '||chr(10)||
    '  -- '||chr(10)||
    '  ELSIF DELETING '||chr(10)|| 
    '  THEN '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_usm.name        := :OLD.name; '||chr(10)||
    '    l_rec_usm.description := :OLD.description; '||chr(10)||
    '    l_rec_usm.definition  := :OLD.definition; '||chr(10)||
    '  -- '||chr(10)||
    '    nm3msv_sec.do_usm_del ( pi_username => Sys_Context(''NM3_SECURITY_CTX'',''USERNAME'') '||chr(10)||
    '                          , pi_rec_usm  => l_rec_usm ); '||chr(10)||
    '  -- '||chr(10)||
    '  ELSIF UPDATING '||chr(10)|| 
    '  THEN '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_usm.name        := NVL (:NEW.name, :OLD.name); '||chr(10)||
    '    l_rec_usm.description := NVL (:NEW.description, :OLD.description); '||chr(10)||
    '    l_rec_usm.definition  := NVL (:NEW.definition, :OLD.definition); '||chr(10)||
    '  -- '||chr(10)||
    '    nm3msv_sec.do_usm_upd ( pi_username => Sys_Context(''NM3_SECURITY_CTX'',''USERNAME'') '||chr(10)||
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
    'CREATE OR REPLACE TRIGGER '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.USER_SDO_STYLES_INS_TRG '||chr(10)||
    '------------------------------------------------------------------------- '||chr(10)||
    '--   PVCS Identifiers :- '||chr(10)||
    '-- '||chr(10)||
    '--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/create_usdo_views.sql-arc   3.1   May 17 2011 08:33:20   Steve.Cooper  $ '||chr(10)||
    '--       Module Name      : $Workfile:   create_usdo_views.sql  $ '||chr(10)||
    '--       Date into PVCS   : $Date:   May 17 2011 08:33:20  $ '||chr(10)||
    '--       Date fetched Out : $Modtime:   May 06 2011 10:07:02  $ '||chr(10)||
    '--       Version          : $Revision:   3.1  $ '||chr(10)||
    '--       Based on SCCS version : '||chr(10)|| 
    '------------------------------------------------------------------------- '||chr(10)||
    'INSTEAD OF DELETE OR INSERT OR UPDATE '||chr(10)||
    'ON '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.USER_SDO_STYLES REFERENCING NEW AS NEW OLD AS OLD '||chr(10)||
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
    '    nm3msv_sec.do_uss_ins ( pi_username => Sys_Context(''NM3_SECURITY_CTX'',''USERNAME'') '||chr(10)||
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
    '     nm3msv_sec.do_uss_del ( pi_username => Sys_Context(''NM3_SECURITY_CTX'',''USERNAME'') '||chr(10)||
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
    '    nm3msv_sec.do_uss_upd ( pi_username => Sys_Context(''NM3_SECURITY_CTX'',''USERNAME'') '||chr(10)||
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
    'CREATE OR REPLACE TRIGGER '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.USER_SDO_THEMES_INS_TRG '||chr(10)||
    '-------------------------------------------------------------------------'||chr(10)||
    '--   PVCS Identifiers :-'||chr(10)||
    '-- '||chr(10)||
    '--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/create_usdo_views.sql-arc   3.1   May 17 2011 08:33:20   Steve.Cooper  $'||chr(10)||
    '--       Module Name      : $Workfile:   create_usdo_views.sql  $'||chr(10)||
    '--       Date into PVCS   : $Date:   May 17 2011 08:33:20  $'||chr(10)||
    '--       Date fetched Out : $Modtime:   May 06 2011 10:07:02  $'||chr(10)||
    '--       Version          : $Revision:   3.1  $'||chr(10)||
    '--       Based on SCCS version :'|| chr(10)||
    '-------------------------------------------------------------------------'||chr(10)||
    'INSTEAD OF DELETE OR INSERT OR UPDATE '||chr(10)||
    'ON '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.USER_SDO_THEMES '||chr(10)|| 
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
    '    nm3msv_sec.do_ust_ins ( pi_username => Sys_Context(''NM3_SECURITY_CTX'',''USERNAME'') '||chr(10)||
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
    '    nm3msv_sec.do_ust_del ( pi_username => Sys_Context(''NM3_SECURITY_CTX'',''USERNAME'') '||chr(10)||
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
    '    nm3msv_sec.do_ust_upd ( pi_username => Sys_Context(''NM3_SECURITY_CTX'',''USERNAME'') '||chr(10)||
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
