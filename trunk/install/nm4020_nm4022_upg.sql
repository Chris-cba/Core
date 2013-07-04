--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4020_nm4022_upg.sql-arc   2.1   Jul 04 2013 14:10:06   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4020_nm4022_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:10:06  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:20  $
--       Version          : $Revision:   2.1  $
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
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
define logfile1='nm4020_nm4022_1_&log_extension'
define logfile2='nm4020_nm4022_2_&log_extension'
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
begin
   hig2.pre_upgrade_check (p_product               => 'HIG'
                          ,p_new_version           => '4.0.2.2'
                          ,p_allowed_old_version_1 => '4.0.2.0'
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
        '&terminator'||'ctx'||'&terminator'||'drop_policy' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        **************** TYPES   ****************
--
--SET TERM OFF
--SET DEFINE ON
--SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
--        '&terminator'||'typ'||'&terminator'||'nm3typ.sql' run_file
--FROM dual
--/
--SET FEEDBACK ON
--start &&run_file
--SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   DDL   *******************
SET TERM ON
PROMPT DDL Changes...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm4020_nm4022_ddl_upg.sql' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--               ****************   RE-RUN INDEXES   *******************
--SET TERM ON
--PROMPT Re-running Indexes...
--PROMPT Ignore errors resulting from index already existing...
--SET TERM OFF
--SET DEFINE ON
--SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
--        '&terminator'||'nm3.ind' run_file
--FROM dual
--/
--SET FEEDBACK ON
--start &&run_file
--SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--               ****************   RE-RUN CONSTRAINTS   *******************
--SET TERM ON
--PROMPT Re-running Constraints...
--PROMPT Ignore errors resulting from constraint already existing...
--SET TERM OFF
--SET DEFINE ON
--SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
--        '&terminator'||'nm3.con' run_file
--FROM dual
--/
--SET FEEDBACK ON
--start &&run_file
--SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        **************** VIEWS   ****************
--SET TERM ON
--PROMPT Views...
--SET TERM OFF
--SET DEFINE ON
--SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
--        '&terminator'||'views'||'&terminator'||'nm3views.sql' run_file
--FROM dual
--/
--SET FEEDBACK ON
--start &&run_file
--SET FEEDBACK OFF
--
--SET TERM OFF
--SET DEFINE ON
--SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
--        '&terminator'||'higviews.sql' run_file
--FROM dual
--/
--SET FEEDBACK ON
--start &&run_file
--SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        **************** TRIGGERS   ****************
--
--SET TERM ON
--PROMPT Triggers...
--SET TERM OFF
--SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
--        '&terminator'||'trg'||'&terminator'||'nm3trg.sql' run_file
--FROM dual
--/
--SET FEEDBACK ON
--start &&run_file
--SET FEEDBACK OFF
--
--
---------------------------------------------------------------------------------------------------
--                  **************** PACKAGE HEADERS AND BODIES   ****************
--
SET TERM ON 
PROMPT nm3file.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3file.pkh' run_file 
FROM dual 
/ 
SET FEEDBACK ON
start '&run_file' 
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT nm3file.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3file.pkw' run_file 
FROM dual 
/ 
SET FEEDBACK ON
start '&run_file' 
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT nm3layer_tool.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3layer_tool.pkh' run_file
FROM dual 
/ 
SET FEEDBACK ON
start '&run_file'
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT nm3layer_tool.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3layer_tool.pkw' run_file
FROM dual 
/ 
SET FEEDBACK ON
start '&run_file'
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT nm3ausec_maint.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3ausec_maint.pkh' run_file
FROM dual 
/ 
SET FEEDBACK ON
start '&run_file'
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT nm3ausec_maint.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3ausec_maint.pkw' run_file
FROM dual 
/ 
SET FEEDBACK ON
start '&run_file'
SET FEEDBACK OFF
--

--SET TERM ON
--PROMPT Package Headers...
--SET TERM OFF
--SET DEFINE ON
--SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
--       '&terminator'||'pck'||'&terminator'||'nm3pkh.sql' run_file
--FROM dual
--/
--SET FEEDBACK ON
--start &&run_file
--SET FEEDBACK OFF
--
--
--SET TERM ON
--PROMPT Package Bodies...
--SET TERM OFF
--SET DEFINE ON
--SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
--       '&terminator'||'pck'||'&terminator'||'nm3pkb.sql' run_file
--FROM dual
--/
--SET FEEDBACK ON
--start &&run_file
--SET FEEDBACK OFF
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
---------------------------------------------------------------------------------------------------
--                  ****************   METADATA  *******************
SET TERM ON
PROMPT Metadata Changes...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm4020_nm4022_metadata_upg.sql' run_file
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
--                        ****************   VERSION NUMBER   *******************
SET TERM ON
Prompt Setting The Version Number...
SET TERM OFF
BEGIN
      hig2.upgrade('HIG','nm4020_nm4022_upg.sql','Upgrade from 4.0.2.0 to 4.0.2.2','4.0.2.2');
      hig2.upgrade('NET','nm4020_nm4022_upg.sql','Upgrade from 4.0.2.0 to 4.0.2.2','4.0.2.2');
      hig2.upgrade('DOC','nm4020_nm4022_upg.sql','Upgrade from 4.0.2.0 to 4.0.2.2','4.0.2.2');
      hig2.upgrade('AST','nm4020_nm4022_upg.sql','Upgrade from 4.0.2.0 to 4.0.2.2','4.0.2.2');
      hig2.upgrade('WMP','nm4020_nm4022_upg.sql','Upgrade from 4.0.2.0 to 4.0.2.2','4.0.2.2');
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
