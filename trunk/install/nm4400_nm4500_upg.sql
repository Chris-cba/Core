--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4400_nm4500_upg.sql-arc   3.10   Jul 04 2013 14:16:28   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4400_nm4500_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:16:28  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:22  $
--       Version          : $Revision:   3.10  $
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
-- Grab date/time to append to log file names this is standard to all upgrade/install scripts
undefine log_extension
col         log_extension new_value log_extension noprint
set term off
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
set term on
---------------------------------------------------------------------------------------------------
-- Spool to Logfile
define logfile1='nm4400_nm4500_1_&log_extension'
define logfile2='nm4400_nm4500_2_&log_extension'
spool &logfile1
--get some db info
SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG','NET','DOC','AST','WMP');
---------------------------------------------------------------------------------------------------
--                        ****************   CHECK(S)   *******************
WHENEVER SQLERROR EXIT
-- Check that the DB version is correct
Declare
  Cursor c_db_version Is
  Select '11gr2' 
  From   v$version
  Where  banner Like '%11.2.0.2%';
  --
  l_11gr2 Varchar2(10);
Begin
   Open  c_db_version;
   Fetch c_db_version Into l_11gr2;
   Close c_db_version;
   --
   If l_11gr2 Is Null
   Then
    RAISE_APPLICATION_ERROR(-20001,'The database version does not comply with the certification matrix - contact exor support for further information');
   End If;
End;
/
--
---------------------------------------------------------------------------------------------------
--                        ****************   CHECK(S)   *******************
--
begin
   hig2.pre_upgrade_check (p_product               => 'HIG'
                          ,p_new_version           => '4.5.0.0'
                          ,p_allowed_old_version_1 => '4.4.0.0'
                          );
END;
/
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
        '&terminator'||'ctx'||'&terminator'||'drop_user_policy' run_file
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
        '&terminator'||'nm4400_nm4500_ddl_upg.sql' run_file
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
start '&&run_file'
SET FEEDBACK OFF

SET TERM ON
PROMPT Who Triggers
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||
       '&terminator'||'who_trg.sql' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
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
--                  **************** PACKAGE HEADERS AND BODIES   ****************
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
--                ****************   PRE_UPG_META_SYNC  *******************
--
--
SET TERM ON
PROMPT resynchronize asset metamodel related objects
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'pre_upgrade_meta_sync.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
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
spool &logfile2
SET TERM ON
start compile_all.sql
--
---------------------------------------------------------------------------------------------------
--                        ****************   CONTEXT   *******************
--The compile_all will have reset the user context so we must reinitialise it
--
SET FEEDBACK OFF
SET TERM ON
PROMPT Re-initialising Context...
SET TERM OFF
BEGIN
   nm3security.Set_User;
   nm3context.initialise_context;
   nm3user.instantiate_user;
END;
/
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
--        ****************   Remove Sub-User Objects  *******************
--
--
SET TERM ON
PROMPT Remove Sub-User Objects
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'remove_private_views.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--        ****************   REGENERATE SYSTEM BUILT OBJECTS  *******************
--
--
SET TERM ON
PROMPT Regenerate system built objects with new context functionality
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'regen.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        **************** ADD POLICIES *******************
-- re-create the policies that were dropped at the beginning of the upgrade
--
SET TERM ON
PROMPT Adding Policies...
SET TERM OFF
SET DEFINE ON
SET VERIFY OFF
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
    '&terminator'||'ctx'||'&terminator'||'add_policy' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                  ****************   METADATA  *******************
SET TERM ON
PROMPT Metadata Changes...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm4400_nm4500_metadata_upg.sql' run_file
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
--                  ****************   CREATE ACLs   *******************
SET TERM ON
Prompt Creating ACLs...
SET TERM OFF
EXECUTE nm3acl.create_standard_acls;
--
---------------------------------------------------------------------------------------------------
--                ****************   POST_UPG_META_SYNC  *******************
--
--
SET TERM ON
PROMPT resynchronize asset metamodel related objects
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'pre_upgrade_meta_sync.sql' run_file
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
SET TERM OFF
BEGIN
      hig2.upgrade('HIG','nm4400_nm4500_upg.sql','Upgrade from 4.4.0.0 to 4.5.0.0','4.5.0.0');
      hig2.upgrade('NET','nm4400_nm4500_upg.sql','Upgrade from 4.4.0.0 to 4.5.0.0','4.5.0.0');
      hig2.upgrade('DOC','nm4400_nm4500_upg.sql','Upgrade from 4.4.0.0 to 4.5.0.0','4.5.0.0');
      hig2.upgrade('AST','nm4400_nm4500_upg.sql','Upgrade from 4.4.0.0 to 4.5.0.0','4.5.0.0');
      hig2.upgrade('WMP','nm4400_nm4500_upg.sql','Upgrade from 4.4.0.0 to 4.5.0.0','4.5.0.0');
END;
/
COMMIT;
SET HEADING OFF
SELECT 'Product updated to version '||hpr_product||' ' ||hpr_version product_version
FROM hig_products
WHERE hpr_product IN ('HIG','NET','DOC','AST','WMP');
spool off
exit
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************
