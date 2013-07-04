--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm42x0_nm4300_upg.sql-arc   3.3   Jul 04 2013 14:16:26   James.Wadsworth  $
--       Module Name      : $Workfile:   nm42x0_nm4300_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:16:26  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:22  $
--       Version          : $Revision:   3.3  $
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
undefine upg_4200_to_4300
undefine upg_4210_to_4300
undefine log_extension
undefine logfile1
undefine logfile2
col      upg_4200_to_4300  new_value upg_4200_to_4300 noprint
col      upg_4210_to_4300  new_value upg_4210_to_4300 noprint	
col      log_extension     new_value log_extension    noprint
col      logfile1          new_value logfile1         noprint
col      logfile2          new_value logfile2         noprint
--       
-------------------------------------------------------------------------
--
set term off

SELECT 'Y' upg_4200_to_4300
FROM hig_products WHERE hpr_product IN ('HIG','NET','DOC','AST','WMP') AND hpr_version = '4.2.0.0'
UNION
SELECT 'N' upg_4200_to_4300
FROM hig_products WHERE hpr_product IN ('HIG','NET','DOC','AST','WMP') AND hpr_version != '4.2.0.0'
/
SELECT 'Y' upg_4210_to_4300
FROM hig_products WHERE hpr_product IN ('HIG','NET','DOC','AST','WMP') AND hpr_version IN ('4.2.0.0','4.2.1.0')
UNION
SELECT 'N' upg_4210_to_4300
FROM hig_products WHERE hpr_product IN ('HIG','NET','DOC','AST','WMP') AND hpr_version NOT IN ('4.2.0.0','4.2.1.0')
/
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
SELECT 'nm'||replace(hpr_version,'.',Null)||'_nm4300_1_&log_extension' logfile1
FROM hig_products WHERE hpr_product = 'NET' 
/
SELECT 'nm'||replace(hpr_version,'.',Null)||'_nm4300_2_&log_extension' logfile2
FROM hig_products WHERE hpr_product = 'NET' 
/

set term on
---------------------------------------------------------------------------------------------------
--
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
                          ,p_new_version           => '4.3.0.0'
                          ,p_allowed_old_version_1 => '4.2.0.0'
                          ,p_allowed_old_version_2 => '4.2.1.0'
                          );
END;
/
WHENEVER SQLERROR CONTINUE
--
---------------------------------------------------------------------------------------------------
--    *****   Grant that is required to be able to create clusters this upg (4300) only   *****
--        *****   Here because it was needed for 4210 (TMA) DDL but not catered for   *****
-- 
SET TERM ON
PROMPT Grant Create Any Cluster
SET TERM OFF
  GRANT CREATE ANY CLUSTER TO hig_admin;
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
PROMPT 4.2.0.0 to 4.2.1.0 DDL Changes (if required)...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm4200_nm4210_ddl_upg.sql' run_file
FROM dual
WHERE '&upg_4200_to_4300' = 'Y'
UNION
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'dummy' run_file
FROM dual
WHERE '&upg_4200_to_4300' = 'N'
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
----
--
SET TERM ON
PROMPT 4.2.1.0 to 4.3.0.0 DDL Changes ...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm4210_nm4300_ddl_upg.sql' run_file
FROM dual
WHERE '&upg_4210_to_4300' = 'Y'
UNION
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'dummy' run_file
FROM dual
WHERE '&upg_4210_to_4300' = 'N'
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--               ****************   RE-RUN CONSTRAINTS   *******************
--
-- not this time around
--
--
---------------------------------------------------------------------------------------------------
--               ****************   RE-RUN INDEXES   *******************
--
-- not this time around
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
alter view network_node compile;
--
alter synonym road_seg_membs_partial compile;
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




SET TERM ON
PROMPT 4.2.0.0 to 4.2.1.0 Metadata Changes (if required)...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm4200_nm4210_metadata_upg.sql' run_file
FROM dual
WHERE '&upg_4200_to_4300' = 'Y'
UNION
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'dummy' run_file
FROM dual
WHERE '&upg_4200_to_4300' = 'N'
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
----
--
SET TERM ON
PROMPT 4.2.1.0 to 4.3.0.0 Metadata Changes ...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm4210_nm4300_metadata_upg.sql' run_file
FROM dual
WHERE '&upg_4210_to_4300' = 'Y'
UNION
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'dummy' run_file
FROM dual
WHERE '&upg_4210_to_4300' = 'N'
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF 
--
----
--
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
--                  ****************   CREATE JOBS  *******************
--
--
SET TERM ON
PROMPT Create table maintenance Jobs
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3jobs.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
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
      hig2.upgrade('HIG','nm42x0_nm4300_upg.sql','Upgrade from 4.2.0.0/4.2.1.0 to 4.3.0.0','4.3.0.0');
      hig2.upgrade('NET','nm42x0_nm4300_upg.sql','Upgrade from 4.2.0.0/4.2.1.0 to 4.3.0.0','4.3.0.0');
      hig2.upgrade('DOC','nm42x0_nm4300_upg.sql','Upgrade from 4.2.0.0/4.2.1.0 to 4.3.0.0','4.3.0.0');
      hig2.upgrade('AST','nm42x0_nm4300_upg.sql','Upgrade from 4.2.0.0/4.2.1.0 to 4.3.0.0','4.3.0.0');
      hig2.upgrade('WMP','nm42x0_nm4300_upg.sql','Upgrade from 4.2.0.0/4.2.1.0 to 4.3.0.0','4.3.0.0');
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
