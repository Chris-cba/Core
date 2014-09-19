--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4700_fix8.sql-arc   3.0   Sep 19 2014 17:38:42   Mike.Huitson  $
--       Module Name      : $Workfile:   nm_4700_fix8.sql  $
--       Date into PVCS   : $Date:   Sep 19 2014 17:38:42  $
--       Date fetched Out : $Modtime:   Sep 19 2014 14:03:52  $
--       PVCS Version     : $Revision:   3.0  $
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
define logfile1='nm_4700_fix8_&log_extension'
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
--Sequence
---------------------------------------
SET TERM ON 
PROMPT Creating Sequence nwt_id_seq.
SET TERM OFF

SET FEEDBACK ON
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE SEQUENCE NWT_ID_SEQ';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

SET FEEDBACK OFF

---------------------------------------
--nm_wms_themes
---------------------------------------
SET TERM ON 
PROMPT Creating table nm_wms_themes.
SET TERM OFF

SET FEEDBACK ON
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE nm_wms_themes'
                    ||'(nwt_id                 NUMBER(38)   NOT NULL'
                    ||',nwt_name               VARCHAR2(32) NOT NULL'
                    ||',nwt_is_background      VARCHAR2(1)  NOT NULL'
                    ||',nwt_transparency       NUMBER(38)   NOT NULL'
                    ||',nwt_visible_on_startup VARCHAR2(1)  NOT NULL)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating primary key (nwt_pk) on nm_wms_themes.
SET TERM OFF

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE nm_wms_themes ADD (CONSTRAINT nwt_pk PRIMARY KEY(nwt_id))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

SET TERM ON 
PROMPT Creating unique key (nwt_uk) on nm_wms_themes.
SET TERM OFF

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE nm_wms_themes ADD (CONSTRAINT nwt_uk UNIQUE(nwt_name))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

SET TERM ON 
PROMPT Creating check constraint (nwt_is_background_chk) on nm_wms_themes.
SET TERM OFF

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE nm_wms_themes ADD (CONSTRAINT nwt_is_background_chk CHECK(nwt_is_background IN(''Y'',''N'')))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

SET TERM ON 
PROMPT Creating check constraint (nwt_transparency_chk) on nm_wms_themes.
SET TERM OFF

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE nm_wms_themes ADD (CONSTRAINT nwt_transparency_chk CHECK(nwt_transparency BETWEEN 0 AND 100))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

SET TERM ON 
PROMPT Creating check constraint (nwt_visible_on_startup_chk) on nm_wms_themes.
SET TERM OFF

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE nm_wms_themes ADD (CONSTRAINT nwt_visible_on_startup_chk CHECK(nwt_visible_on_startup IN(''Y'',''N'')))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

---------------------------------------
--nm_wms_theme_roles
---------------------------------------
SET TERM ON 
PROMPT Creating table nm_wms_theme_roles.
SET TERM OFF

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE nm_wms_theme_roles'
                    ||'(nwtr_nwt_id  NUMBER(9)     NOT NULL'
                    ||',nwtr_role    VARCHAR2(30)  NOT NULL)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

SET TERM ON 
PROMPT Creating index (nwtr_fk_hro_ind) on nm_wms_theme_roles.
SET TERM OFF

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX nwtr_fk_hro_ind ON nm_wms_theme_roles(nwtr_role)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

SET TERM ON 
PROMPT Creating index (nwtr_fk_nwt_ind) on nm_wms_theme_roles.
SET TERM OFF

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX nwtr_fk_nwt_ind ON nm_wms_theme_roles(nwtr_nwt_id)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

SET TERM ON 
PROMPT Creating primary key (nwtr_pk) on nm_wms_theme_roles.
SET TERM OFF

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE nm_wms_theme_roles ADD (CONSTRAINT nwtr_pk PRIMARY KEY(nwtr_nwt_id,nwtr_role))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

SET TERM ON 
PROMPT Creating foreign key (nwtr_fk_hro) on nm_wms_theme_roles.
SET TERM OFF

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE nm_wms_theme_roles ADD (CONSTRAINT nwtr_fk_hro FOREIGN KEY(nwtr_role) REFERENCES hig_roles(hro_role))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

SET TERM ON 
PROMPT Creating foreign key (nwtr_fk_nwt) on nm_wms_theme_roles.
SET TERM OFF

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE nm_wms_theme_roles ADD (CONSTRAINT nwtr_fk_nwt FOREIGN KEY(nwtr_nwt_id) REFERENCES nm_wms_themes(nwt_id))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

--
--------------------------------------------------------------------------------
-- Type
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating type nm_max_varchar_tbl
SET TERM OFF
--
SET FEEDBACK ON
start nm_max_varchar_tbl.tyh
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Header
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating package header nm3sdo_wms
SET TERM OFF
--
SET FEEDBACK ON
start nm3sdo_wms.pkh
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating view v_sdo_wms_themes.vw
SET TERM OFF
--
SET FEEDBACK ON
start v_sdo_wms_themes.vw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating view v_sdo_wms_theme_layers
SET TERM OFF
--
SET FEEDBACK ON
start v_sdo_wms_theme_layers.vw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating view v_sdo_wms_theme_params
SET TERM OFF
--
SET FEEDBACK ON
start v_sdo_wms_theme_params.vw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating view v_sdo_wms_theme_styles
SET TERM OFF
--
SET FEEDBACK ON
start v_sdo_wms_theme_styles.vw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating view v_nm_wms_themes
SET TERM OFF
--
SET FEEDBACK ON
start v_nm_wms_themes.vw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Package Body
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating package body nm3sdo_wms
SET TERM OFF
--
SET FEEDBACK ON
start nm3sdo_wms.pkw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Synonyms
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating package body nm3sdo_wms
SET TERM OFF
SET FEEDBACK ON
BEGIN
  nm3ddl.refresh_all_synonyms;
END;
/

SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- HIG_SEQUENCE_ASSOCIATIONS
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Inserting into HIG_SEQUENCE_ASSOCIATIONS
SET TERM OFF
--
SET FEEDBACK ON
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_WMS_THEMES'
       ,'NWT_ID'
       ,'NWT_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_WMS_THEMES'
                    AND  HSA_COLUMN_NAME = 'NWT_ID')
;
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
        'GIS0030'
       ,'GIS WMS Themes'
       ,'gis0030'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'GIS0030')
;
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- HIG_STANDARD_FAVOURITES
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Inserting into HIG_STANDARD_FAVOURITES
SET TERM OFF
--
SET FEEDBACK ON
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_GIS'
       ,'GIS0030'
       ,'GIS WMS Themes'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_GIS'
                    AND  HSTF_CHILD = 'GIS0030')
;
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- HIG_MODULE_ROLES
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Inserting into HIG_MODULE_ROLES
SET TERM OFF
--
SET FEEDBACK ON
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'GIS0030'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'GIS0030'
                    AND  HMR_ROLE = 'HIG_ADMIN')
;
SET FEEDBACK OFF

COMMIT;

--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4700_fix8.sql 
--
SET FEEDBACK ON
start log_nm_4700_fix8.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
commit;
--