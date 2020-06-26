--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm3_upg.sql-arc   1.1   Jun 26 2020 14:46:24   Chris.Baugh  $
--       Module Name      : $Workfile:   nm3_upg.sql  $
--       Date into PVCS   : $Date:   Jun 26 2020 14:46:24  $
--       Date fetched Out : $Modtime:   Jun 26 2020 14:29:52  $
--       Version          : $Revision:   1.1  $
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--  Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
-- Grab date/time to append to log file names this is standard to all upgrade/install scripts
undefine nmlogfile1
undefine nmlogfile2
col         nmlogfile1 new_value nmlogfile1 noprint
col         nmlogfile2 new_value nmlogfile2 noprint
set term off
SELECT  'core'||REPLACE('&new_version','.')||'_upg_1_'||TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' nmlogfile1 
       ,'core'||REPLACE('&new_version','.')||'_upg_2_'||TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' nmlogfile2 
from dual
/
set term on
---------------------------------------------------------------------------------------------------
-- Spool to Logfile
define nmlogfile1='&nmlogfile1'
define nmlogfile2='&nmlogfile2'

SPOOL &nmlogfile1

--get some db info
SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG','NET','DOC','AST','WMP');

WHENEVER SQLERROR CONTINUE
--
---------------------------------------------------------------------------------------------------
--                        **************** DROP POLICIES *******************
--
-- drop any policies that could be effected by table changes
-- ensure that later on - after a compile schema these policies are re-created
SET TERM ON
PROMPT Dropping Policies...
SET TERM OFF
SET DEFINE ON
SET VERIFY OFF
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'ctx'||'&terminator'||'drop_policy' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF

SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'sql'||'&terminator'||'drop_policies.sql' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        **************** TYPES   ****************
--
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'typ'||'&terminator'||'nm3typ.sql' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   DDL   *******************
SET TERM ON
PROMPT DDL Changes...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3_ddl_upg.sql' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                  **************** PACKAGE HEADERS   ****************
--
SET TERM ON
PROMPT Package Headers...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
       '&terminator'||'pck'||'&terminator'||'nm3pkh.sql' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        **************** VIEWS   ****************
SET TERM ON
PROMPT Views...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'views'||'&terminator'||'nm3views.sql' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'higviews.sql' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        **************** TRIGGERS   ****************
--
SET TERM ON
PROMPT Triggers...
SET TERM OFF
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'trg'||'&terminator'||'nm3trg.sql' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   XML SYNONYMS *******************
-- create public synonyms for xml packages. These will fail if the xml packages do not exist
SET TERM ON
prompt XML Synonyms...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'xml_synonyms.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                ****************   CREATE SDO VIEWS  *******************
--
--
SET TERM ON
PROMPT Create User SDO Views
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'create_usdo_views.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

--
---------------------------------------------------------------------------------------------------
--                ****************   MERGE ANY VIEW  *******************
--
--
SET TERM ON
PROMPT Grant MERGE ANY VIEW to PUBLIC
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'mav_grant.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        **************** APPLICATION CONTEXTS ****************
--
SET TERM ON
Prompt Application Contexts...
--SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'ctx'||'&terminator'||'nm3ctx.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                            ****************   MERGE SECURITY  *******************
SET TERM ON
prompt Merge Security...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'nm3mrg_security.pkh' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
--
---------------------------------------------------------------------------------------------------
--                  **************** PACKAGE  BODIES   ****************
--
SET TERM ON
PROMPT Package Bodies...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
       '&terminator'||'pck'||'&terminator'||'nm3pkb.sql' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'ctx'||'&terminator'||'invsec.pkw' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
--
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'nm3mrg_security.pkw' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'Java'||'&terminator'||'shapefile'||'&terminator'||'runcommand.fnw' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

--
---------------------------------------------------------------------------------------------------
--                ****************   v_geom_on_route View  *******************
--
--
SET TERM ON
PROMPT Creating v_geom_on_route View
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_geom_on_route.vw ' run_file
FROM dual
/

SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                            ****************   Create v_lb_nlt_geometry View  *******************

SET TERM ON
Prompt Setting The Version Number...
SET TERM OFF
BEGIN
  create_nlt_geometry_view;
END;
/
--
---------------------------------------------------------------------------------------------------
--                        ****************   eB Interface modules  *******************
SET TERM ON
prompt eB interface...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'eB_Interface'||
        '&terminator'||'install_eB_interface' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   Drop SDO_LRS replacement code if Oracle Spatial is installed *******************
SET TERM ON
Prompt Drop SDO_LRS replacement, if Oracle Spatial is valid...
SET TERM OFF

DECLARE
  --
  CURSOR c1 IS
  select count(*)
   from dba_registry 
  where comp_name='Spatial'
    and status = 'VALID';
  --
  lv_return      PLS_INTEGER;
  obj_not_exist  EXCEPTION;
  PRAGMA exception_init( obj_not_exist, -4043);
  --
BEGIN
--
  OPEN c1;
  FETCH c1 INTO lv_return;
  CLOSE c1;
  
  IF lv_return = 1
  THEN
    --
	EXECUTE IMMEDIATE 'DROP package sdo_lrs';
  END IF;
  --
EXCEPTION 
  WHEN obj_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--------------------------------------------------------------------------------
-- Grant privileges to PROXY_OWNER Role
--------------------------------------------------------------------------------

prompt Grant privileges to PROXY_OWNER Role

DECLARE
  role_exists EXCEPTION;
  PRAGMA EXCEPTION_INIT(role_exists, -1921);
BEGIN
  EXECUTE IMMEDIATE 'GRANT CREATE SESSION to PROXY_OWNER';
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON hig_sso_api to PROXY_OWNER';
EXCEPTION
  WHEN role_exists
  THEN NULL;
END;
/
--
---------------------------------------------------------------------------------------------------
--                        ****************   COMPILE SCHEMA   *******************
SET TERM ON
Prompt Creating Compiling Schema Script...
SET TERM OFF
SPOOL OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'utl'||'&terminator'||'compile_schema.sql' run_file
FROM dual
/
start '&run_file'
spool &nmlogfile2
SET TERM ON
start compile_all.sql
--
---------------------------------------------------------------------------------------------------
--                        ****************   CONTEXT   *******************
--The compile_all will have reset the user context so we must reinitialise it
--
SET FEEDBACK OFF
SET TERM ON
PROMPT Reinitialising Context...
SET TERM OFF
BEGIN
  nm3context.initialise_context;
  nm3user.instantiate_user;
END;
/
---------------------------------------------------------------------------------------------------
--                        **************** ADD POLICIES *******************
-- re-create the policies that were dropped at the beginning of the upgrade
--
SET TERM ON
prompt Apply Policies if using Oracle Enterprise Edition...
SET TERM OFF
SET DEFINE ON
SELECT DECODE(INSTR(UPPER(banner), 'ENTERPRISE'),
                    0, '&exor_base'||'nm3'||'&terminator'||'install'||'&terminator'||'dummy',
                       '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'ctx'||'&terminator'||'add_policy'
                       ) run_file
  FROM v$version
WHERE UPPER(banner) LIKE '%ORACLE DATABASE%'
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
---------------------------------------------------------------------------------------------------
--                  ****************   METADATA  *******************
SET TERM ON
PROMPT Metadata Changes...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3_metadata_upg.sql' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3data_help.sql' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   SYNONYMS   *******************
SET TERM ON
Prompt Creating Synonyms That Do Not Exist...
SET TERM OFF
EXECUTE nm3ddl.refresh_all_synonyms;
--
---------------------------------------------------------------------------------------------------
--                        ****************   ROLES   *******************
SET TERM ON
Prompt Updating HIG_USER_ROLES...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
    '&terminator'||'hig_user_roles.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
--
SET TERM ON
Prompt Ensuring all users have HIG_USER role...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
    '&terminator'||'users_without_hig_user.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   POST UPGRADE SCRIPT   *******************
SET TERM ON
Prompt Post Upgrade Script...
SET TERM OFF
--
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
    '&terminator'||'nm3_post_upg.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   Create SDL Themes *******************

SET TERM ON
PROMPT Create SDL Themes
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'sdl_themes.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
--
---------------------------------------------------------------------------------------------------
--                        ****************   Create SDL Spatial Indexes *******************

SET TERM ON
PROMPT Create SDL Spatial Indexes
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'sdl_spidx.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   VERSION NUMBER   *******************
SET TERM ON
Prompt Setting The Version Number...
--SET TERM OFF
BEGIN
      hig2.upgrade('HIG','nm3_upg.sql','Upgrade from &core_version to &new_version','&new_version');
      hig2.upgrade('NET','nm3_upg.sql','Upgrade from &core_version to &new_version','&new_version');
      hig2.upgrade('DOC','nm3_upg.sql','Upgrade from &core_version to &new_version','&new_version');
      hig2.upgrade('AST','nm3_upg.sql','Upgrade from &core_version to &new_version','&new_version');
      hig2.upgrade('WMP','nm3_upg.sql','Upgrade from &core_version to &new_version','&new_version');
END;
/
COMMIT;
SET HEADING OFF
SELECT 'Product updated to version '||hpr_product||' ' ||hpr_version product_version
FROM hig_products
WHERE hpr_product IN ('HIG','NET','DOC','AST','WMP');

spool off
exit;

---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************
