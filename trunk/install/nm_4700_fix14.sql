--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix14.sql-arc   3.2   Jan 09 2015 11:26:16   Stephen.Sewell  $
--       Module Name      : $Workfile:   nm_4700_fix14.sql  $
--       Date into PVCS   : $Date:   Jan 09 2015 11:26:16  $
--       Date fetched Out : $Modtime:   Jan 09 2015 11:19:32  $
--       PVCS Version     : $Revision:   3.2  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated.
--------------------------------------------------------------------------------
--
set echo off
set linesize 120
set heading off
set feedback off
--
-- Grab date/time to append to log file name
--
undefine log_extension
col      log_extension new_value log_extension noprint
set term off
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
set term on
--
--------------------------------------------------------------------------------
--
--
-- Spool to Logfile
--
define logfile1='nm_4700_fix14_&log_extension'
spool &logfile1
--
--------------------------------------------------------------------------------
--
select 'Fix Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
--
SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG','NET');

WHENEVER SQLERROR EXIT

BEGIN
 --
 -- Check that the user isn't sys or system
 --
 IF USER IN ('SYS','SYSTEM')
 THEN
   RAISE_APPLICATION_ERROR(-20000,'You cannot install this product as ' || USER);
 END IF;

 --
 -- Check that HIG has been installed @ v4.7.0.0
 --
 hig2.product_exists_at_version (p_product        => 'HIG'
                                ,p_VERSION        => '4.7.0.0'
                                );

END;
/
WHENEVER SQLERROR CONTINUE

---------------------------------------
-- Tables nm_inv_items_all_backup and nm_inv_items_all_j
---------------------------------------
SET TERM ON 
PROMPT Creating backup and journal tables nm_inv_items_all_backup and nm_inv_items_all_j
SET TERM OFF

set serveroutput on size 200000

DECLARE
  obj_exists EXCEPTION;
  obj_notexists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
  PRAGMA exception_init( obj_notexists, -942);
BEGIN
  -- Disable security policies on nm_inv_items_all and nm_inv_items_all_j during this release/upgrade.
  sys.dbms_rls.enable_policy(Sys_Context('NM3_SECURITY_CTX','USERNAME'),'nm_inv_items_all','INV_AU_POLICY_READ',FALSE);
  sys.dbms_rls.enable_policy(Sys_Context('NM3_SECURITY_CTX','USERNAME'),'nm_inv_items_all','INV_AU_POLICY',FALSE);
  BEGIN
    sys.dbms_rls.enable_policy(Sys_Context('NM3_SECURITY_CTX','USERNAME'),'nm_inv_items_all_j','INV_AU_POLICY_READ',FALSE);
    sys.dbms_rls.enable_policy(Sys_Context('NM3_SECURITY_CTX','USERNAME'),'nm_inv_items_all_j','INV_AU_POLICY',FALSE);
  EXCEPTION
    when obj_notexists then
      null;
  END;
  -- Create backup table for nm_inv_items_all. If it is already present then leave it and move on.
  begin
    EXECUTE IMMEDIATE 'CREATE TABLE nm_inv_items_all_backup as select * from nm_inv_items_all';
    dbms_output.put_line('Created table nm_inv_items_all_backup.');
  exception
    when obj_exists THEN
      dbms_output.put_line('Table nm_inv_items_all_backup already exists.');
      null;
  end;

  --
  -- Drop Audit trigger NM_INV_ITEMS_ALL_AUD_BR_U from NM_INV_ITEMS_ALL if it is present as if invalid
  -- it can prevent some of the following actions from taking place.
  --
  begin
    EXECUTE IMMEDIATE 'drop trigger NM_INV_ITEMS_ALL_AUD_BR_U';
    dbms_output.put_line('Dropped trigger nm_inv_items_all_aud_br_u from nm_inv_items_all table.');
  exception
    when OTHERS then
      null;
  end;

  -- Create journal table. If it is already present then leave it and move on.
  begin
    EXECUTE IMMEDIATE 'CREATE TABLE nm_inv_items_all_j as '
                      ||'select iia.* '
                      ||'from nm_inv_items_all iia '
                      ||'where iia.iit_ne_id <> (select max(iia2.iit_ne_id) '
                      ||'from nm_inv_items_all iia2 '
                      ||'where iia2.iit_primary_key = iia.iit_primary_key)';
    dbms_output.put_line('Created table nm_inv_items_all_j.');
  exception
    when obj_exists THEN
    dbms_output.put_line('Table nm_inv_items_all_j already exists.');
    null;
  end;
  
  -- Add new columns to journal table. Don't fail if they already exist.
  begin
    EXECUTE IMMEDIATE 'ALTER TABLE nm_inv_items_all_j '
                      ||'add (IIT_AUDIT_TYPE VARCHAR2(10), PARENT_NE_ID NUMBER(9), CREATED_BY VARCHAR2(30), DATE_CREATED DATE)';
    dbms_output.put_line('Added columns to nm_inv_items_all_j.');
  exception
    when others then
      dbms_output.put_line('Columns already present in nm_inv_items_all_j.');
      null;
  end;
  -- Tie back rows to row in nm_inv_items_all - TFL
  EXECUTE IMMEDIATE 'UPDATE nm_inv_items_all_j iiaj '
                    ||'set iiaj.parent_ne_id = (select max(iia.iit_ne_id) '
                    ||'from nm_inv_items_all iia '
                    ||'where iia.iit_primary_key = iiaj.iit_primary_key '
                    ||'and iia.iit_inv_type = iiaj.iit_inv_type) '
                    ||'where iiaj.parent_ne_id is NULL';
  dbms_output.put_line('Updated parent_id in nm_inv_items_all_j.');

  -- Update audit columns added to new table
  EXECUTE IMMEDIATE 'UPDATE nm_inv_items_all_j '
                    ||'set iit_audit_type = ''M'', created_by = USER, date_created = SYSDATE';
  dbms_output.put_line('Updated audit columns in nm_inv_items_all_j.');

  -- Remove rows from nm_inv_items_all which have been copied into nm_inv_items_all_j
  EXECUTE IMMEDIATE 'DELETE from nm_inv_items_all iia '
                    ||'where iia.iit_ne_id <> (select max(iia2.iit_ne_id) from nm_inv_items_all iia2 where iia2.iit_primary_key = iia.iit_primary_key)';
  dbms_output.put_line('Removed unwanted rows from nm_inv_items_all.');

  begin
    -- Add Audit Type column to nm_inv_items_all table. Don't fail if it already exists.
    EXECUTE IMMEDIATE 'ALTER TABLE nm_inv_items_all '
                    ||'add (IIT_AUDIT_TYPE varchar2(10) default ''M'')';
    dbms_output.put_line('Added iit_audit_type column to nm_inv_items_all.');
--  exception
--    when OTHERS then
--      null;
  end;
 
  -- Disable triggers on nm_inv_items_all to prevent them firing for the following update
  EXECUTE IMMEDIATE 'ALTER TABLE nm_inv_items_all disable all triggers';

  -- Update audit column added to nm_inv_items_all
  EXECUTE IMMEDIATE 'UPDATE nm_inv_items_all '
                    ||'set iit_audit_type = ''M''';

  -- Re-enable triggers on nm_inv_items_all now update is complete
  EXECUTE IMMEDIATE 'ALTER TABLE nm_inv_items_all enable all triggers';
  dbms_output.put_line('Updated audit column in nm_inv_items_all.');

  -- Re-enable security policies on nm_inv_items_all during this release/upgrade.
  sys.dbms_rls.enable_policy(Sys_Context('NM3_SECURITY_CTX','USERNAME'),'nm_inv_items_all','INV_AU_POLICY_READ',TRUE);
  sys.dbms_rls.enable_policy(Sys_Context('NM3_SECURITY_CTX','USERNAME'),'nm_inv_items_all','INV_AU_POLICY',TRUE);
  -- Ensure enabled security policies on nm_inv_items_all_j
  sys.dbms_rls.enable_policy(Sys_Context('NM3_SECURITY_CTX','USERNAME'),'nm_inv_items_all_j','INV_AU_POLICY_READ',TRUE);
  sys.dbms_rls.enable_policy(Sys_Context('NM3_SECURITY_CTX','USERNAME'),'nm_inv_items_all_j','INV_AU_POLICY',TRUE);

EXCEPTION
  WHEN obj_exists THEN
    -- Re-enable security policies on nm_inv_items_all during this release/upgrade.
    sys.dbms_rls.enable_policy(Sys_Context('NM3_SECURITY_CTX','USERNAME'),'nm_inv_items_all','INV_AU_POLICY_READ',TRUE);
    sys.dbms_rls.enable_policy(Sys_Context('NM3_SECURITY_CTX','USERNAME'),'nm_inv_items_all','INV_AU_POLICY',TRUE);
    dbms_output.put_line('OBJ_EXISTS exception raised.');
   when others then
     -- Re-enable security policies on nm_inv_items_all during this release/upgrade.
     sys.dbms_rls.enable_policy(Sys_Context('NM3_SECURITY_CTX','USERNAME'),'nm_inv_items_all','INV_AU_POLICY_READ',TRUE);
     sys.dbms_rls.enable_policy(Sys_Context('NM3_SECURITY_CTX','USERNAME'),'nm_inv_items_all','INV_AU_POLICY',TRUE);
    dbms_output.put_line('OTHERS exception raised. sqlerror was '||sqlerrm);
END;
/

COMMIT;

SET TERM ON 
PROMPT Creating primary key (NM_INV_ITEMS_ALL_J_PK) on nm_inv_items_all_j.
SET TERM OFF

DECLARE
  obj_exists EXCEPTION;
  name_in_use EXCEPTION;
  pk_already_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
  PRAGMA exception_init( name_in_use, -955);
  PRAGMA exception_init( pk_already_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE nm_inv_items_all_j ADD CONSTRAINT NM_INV_ITEMS_ALL_J_PK PRIMARY KEY(parent_ne_id, iit_ne_id, iit_start_date, iit_date_modified) USING INDEX ENABLE';
EXCEPTION
  WHEN obj_exists THEN
    dbms_output.put_line('OBJ_EXISTS exception raised.');
    NULL;
  WHEN name_in_use THEN
    dbms_output.put_line('NAME_IN_USE exception raised.');
    NULL;
  WHEN pk_already_exists THEN
    dbms_output.put_line('PK_ALREADY_EXISTS exception raised.');
    NULL;
END;
/

SET TERM ON 
PROMPT Creating unique key (NM_IIT_PRIMARY_KEY_J_UK) on nm_inv_items_all_j.
SET TERM OFF

DECLARE
  obj_exists EXCEPTION;
  name_in_use EXCEPTION;
  pk_already_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
  PRAGMA exception_init( name_in_use, -955);
  PRAGMA exception_init( pk_already_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE nm_inv_items_all_j ADD CONSTRAINT NM_IIT_PRIMARY_KEY_J_UK UNIQUE (iit_primary_key, iit_inv_type, iit_start_date, iit_date_modified, date_created) USING INDEX ENABLE';
EXCEPTION
  WHEN obj_exists THEN
    dbms_output.put_line('OBJ_EXISTS exception raised.');
    NULL;
  WHEN name_in_use THEN
    dbms_output.put_line('NAME_IN_USE exception raised.');
    NULL;
  WHEN pk_already_exists THEN
    dbms_output.put_line('PK_ALREADY_EXISTS exception raised.');
    NULL;
END;
/

SET TERM ON 
PROMPT Creating non-unique index(NM_IIA_NE_ID_J_NUK) on nm_inv_items_all_j.
SET TERM OFF

DECLARE
  obj_exists EXCEPTION;
  name_in_use EXCEPTION;
  name_already_used EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
  PRAGMA exception_init( name_in_use, -955);
  PRAGMA exception_init( name_already_used, -2264);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX NM_IIA_NE_ID_J_NUK ON nm_inv_items_all_j(iit_ne_id)';
EXCEPTION
  WHEN obj_exists THEN
    dbms_output.put_line('OBJ_EXISTS exception raised.');
    NULL;
  WHEN name_in_use THEN
    dbms_output.put_line('NAME_IN_USE exception raised.');
    NULL;
  WHEN name_already_used THEN
    dbms_output.put_line('NAME_ALREADY_USED exception raised.');
    NULL;
END;
/

SET TERM ON 
PROMPT Creating non-unique index (NM_IIA_INV_TYPE_J_NUK) on nm_inv_items_all_j.
SET TERM OFF

DECLARE
  obj_exists EXCEPTION;
  name_in_use EXCEPTION;
  name_already_used EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
  PRAGMA exception_init( name_in_use, -955);
  PRAGMA exception_init( name_already_used, -2264);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX NM_IIA_INV_TYPE_J_NUK ON nm_inv_items_all_j(iit_inv_type)';
EXCEPTION
  WHEN obj_exists THEN
    dbms_output.put_line('OBJ_EXISTS exception raised.');
    NULL;
  WHEN name_in_use THEN
    dbms_output.put_line('NAME_IN_USE exception raised.');
    NULL;
  WHEN name_already_used THEN
    dbms_output.put_line('NAME_ALREADY_USED exception raised.');
    NULL;
END;
/

--
--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Type nm_attrib_history
SET TERM OFF
--
SET FEEDBACK ON
start nm_attrib_history_object_type.typ
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Creating Type nm_attrib_history_t
SET TERM OFF
--
SET FEEDBACK ON
start nm_attrib_history_t_object_type.typ
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating view nm_inv_items_eff
SET TERM OFF
--
SET FEEDBACK ON
start nm_inv_items_eff.vw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Creating view nm_inv_items
SET TERM OFF
--
SET FEEDBACK ON
start nm_inv_items.vw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Creating view nm_asset_history
SET TERM OFF
--
SET FEEDBACK ON
start nm_asset_history.vw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Package Header
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating package header nm3inv_item_aud
SET TERM OFF
--
SET FEEDBACK ON
start nm3inv_item_aud.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Updating package header nm3sdo_edit.pkh
SET TERM OFF
--
SET FEEDBACK ON
start nm3sdo_edit.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Updating package header nm3inv.pkh
SET TERM OFF
--
SET FEEDBACK ON
start nm3inv.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Updating package header nm3locator.pkh
SET TERM OFF
--
SET FEEDBACK ON
start nm3locator.pkh
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Package Body
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Updating package body nm3asset
SET TERM OFF
--
SET FEEDBACK ON
start nm3asset.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Updating package body nm3inv
SET TERM OFF
--
SET FEEDBACK ON
start nm3inv.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Creating package body nm3inv_item_aud
SET TERM OFF
--
SET FEEDBACK ON
start nm3inv_item_aud.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Creating package body nm3inv_update
SET TERM OFF
--
SET FEEDBACK ON
start nm3inv_update.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Creating package body nm3locator
SET TERM OFF
--
SET FEEDBACK ON
start nm3locator.pkw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- HIG_MODULES
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Inserting into HIG_MODULES
SET TERM OFF
--
SET FEEDBACK ON
INSERT INTO HIG_MODULES
       (HMO_MODULE
       ,HMO_TITLE
       ,HMO_FILENAME
       ,HMO_MODULE_TYPE
       ,HMO_FASTPATH_OPTS
       ,HMO_FASTPATH_INVALID
       ,HMO_USE_GRI
       ,HMO_APPLICATION
       ,HMO_MENU
       )
SELECT 
        'NM0525'
       ,'Asset Attribute History'
       ,'nm0525'
       ,'FMX'
       ,NULL
       ,'Y'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0525')
;
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- HIG_MODULE_ROLES
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Inserting into HIG_MODULE_ROLES all roles for new form NM0525 as for existing form NM0510
SET TERM OFF
--
SET FEEDBACK ON
INSERT INTO HIG_MODULE_ROLES HMR
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE)
SELECT 
        'NM0525'
       ,HMR2.HMR_ROLE
       ,HMR2.HMR_MODE
FROM HIG_MODULE_ROLES HMR2
WHERE HMR2.HMR_MODULE = 'NM0510'
AND NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES HMR3
                   WHERE HMR3.HMR_MODULE = 'NM0525'
                    AND  HMR3.HMR_ROLE = HMR2.HMR_ROLE)
;
SET FEEDBACK OFF

COMMIT;

--
--------------------------------------------------------------------------------
-- TRIGGERS
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Adding audit trigger to nm_inv_items_all table
SET TERM OFF

SET FEEDBACK ON
start nm_inv_items_all_aud_br_u.trg
SET FEEDBACK OFF

SET TERM ON 
PROMPT Adding instead of trigger to nm_inv_items view
SET TERM OFF

SET FEEDBACK ON
start nm_inv_items_instead_iu.trg
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Synonyms
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Updating all synonyms
SET TERM OFF
SET FEEDBACK ON
BEGIN
  nm3ddl.refresh_all_synonyms;
END;
/
SET FEEDBACK OFF


--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4700_fix14.sql 
--
SET FEEDBACK ON
start log_nm_4700_fix14.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
commit;
--