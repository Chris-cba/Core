--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm405x_nm4100_upg.sql-arc   3.1   Jul 21 2009 12:57:24   malexander  $
--       Module Name      : $Workfile:   nm405x_nm4100_upg.sql  $
--       Date into PVCS   : $Date:   Jul 21 2009 12:57:24  $
--       Date fetched Out : $Modtime:   Jul 21 2009 12:57:02  $
--       Version          : $Revision:   3.1  $
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
-- Grab date/time to append to log file names this is standard to all upgrade/install scripts
undefine log_extension
undefine five_two_to_4100
undefine five_three_to_4100
undefine five_four_to_4100
undefine log_extension
undefine logfile1
undefine logfile2
col      five_two_to_4100    new_value five_two_to_4100   noprint
col      five_three_to_4100  new_value five_three_to_4100 noprint	
col      five_four_to_4100   new_value five_four_to_4100  noprint
col      log_extension new_value log_extension noprint
col      logfile1 new_value logfile1 noprint
col      logfile2 new_value logfile2 noprint
--       
-------------------------------------------------------------------------
--
set term off

SELECT 'Y' five_two_to_4100
FROM hig_products WHERE hpr_product IN ('HIG','NET','DOC','AST','WMP') AND hpr_version = '4.0.5.2'
UNION
SELECT 'N' five_two_to_4100
FROM hig_products WHERE hpr_product IN ('HIG','NET','DOC','AST','WMP') AND hpr_version != '4.0.5.2'
/
SELECT 'Y' five_three_to_4100
FROM hig_products WHERE hpr_product IN ('HIG','NET','DOC','AST','WMP') AND hpr_version IN ('4.0.5.2','4.0.5.3')
UNION
SELECT 'N' five_three_to_4100
FROM hig_products WHERE hpr_product IN ('HIG','NET','DOC','AST','WMP') AND hpr_version NOT IN ('4.0.5.2','4.0.5.3')
/
SELECT 'Y' five_four_to_4100
FROM hig_products WHERE hpr_product IN ('HIG','NET','DOC','AST','WMP') AND hpr_version IN ('4.0.5.2','4.0.5.3','4.0.5.4')
UNION
SELECT 'N' five_four_to_4100
FROM hig_products WHERE hpr_product IN ('HIG','NET','DOC','AST','WMP') AND hpr_version NOT IN ('4.0.5.2','4.0.5.3','4.0.5.4')
/
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
SELECT 'nm'||replace(hpr_version,'.',Null)||'_nm4100_1_&log_extension' logfile1
FROM hig_products WHERE hpr_product = 'NET' 
/
SELECT 'nm'||replace(hpr_version,'.',Null)||'_nm4100_2_&log_extension' logfile2
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
                          ,p_new_version           => '4.1.0.0'
                          ,p_allowed_old_version_1 => '4.0.5.4'
                          ,p_allowed_old_version_2 => '4.0.5.3'
                          ,p_allowed_old_version_3 => '4.0.5.2'
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
PROMPT 4.0.5.2 to 4.0.5.3 DDL Changes (if required)...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm4052_nm4053_ddl_upg.sql' run_file
FROM dual
WHERE '&five_two_to_4100' = 'Y'
UNION
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'dummy' run_file
FROM dual
WHERE '&five_two_to_4100' = 'N'
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
----
--
SET TERM ON
PROMPT 4.0.5.3 to 4.0.5.4 DDL Changes (if required)...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm4053_nm4054_ddl_upg.sql' run_file
FROM dual
WHERE '&five_two_to_4100' = 'Y'
UNION
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'dummy' run_file
FROM dual
WHERE '&five_two_to_4100' = 'N'
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF   
--
----
--
SET TERM ON
PROMPT 4.0.5.4 to 4.1.0.0 DDL Changes ...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm4054_nm4100_ddl_upg.sql' run_file
FROM dual
WHERE '&five_four_to_4100' = 'Y'
UNION
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'dummy' run_file
FROM dual
WHERE '&five_four_to_4100' = 'N'
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--               ****************   RE-RUN INDEXES   *******************
--
-- not this time around
--
--
---------------------------------------------------------------------------------------------------
--               ****************   RE-RUN CONSTRAINTS   *******************
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
SET TERM ON
PROMPT INVSEC Package Body...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'admin'||
         '&terminator'||'ctx'||'&terminator'||'invsec.pkw' run_file
from dual
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
PROMPT 4.0.5.2 to 4.0.5.3 Metadata Changes (if required)...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm4052_nm4053_metadata_upg.sql' run_file
FROM dual
WHERE '&five_two_to_4100' = 'Y'
UNION
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'dummy' run_file
FROM dual
WHERE '&five_two_to_4100' = 'N'
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF 
--
----
--
SET TERM ON
PROMPT 4.0.5.3 to 4.0.5.4 Metadata Changes (if required)...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm4053_nm4054_metadata_upg.sql' run_file
FROM dual
WHERE '&five_three_to_4100' = 'Y'
UNION
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'dummy' run_file
FROM dual
WHERE '&five_three_to_4100' = 'N'
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF 
--
----
--
SET TERM ON
PROMPT 4.0.5.4 to 4.1.0.0 Metadata Changes ...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm4054_nm4100_metadata_upg.sql' run_file
FROM dual
WHERE '&five_four_to_4100' = 'Y'
UNION
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'dummy' run_file
FROM dual
WHERE '&five_four_to_4100' = 'N'
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
      hig2.upgrade('HIG','nm405x_nm4100_upg.sql','Upgrade from 4.0.5.2/4.0.5.3/4.0.5.4 to 4.1.0.0','4.1.0.0');
      hig2.upgrade('NET','nm405x_nm4100_upg.sql','Upgrade from 4.0.5.2/4.0.5.3/4.0.5.4 to 4.1.0.0','4.1.0.0');
      hig2.upgrade('DOC','nm405x_nm4100_upg.sql','Upgrade from 4.0.5.2/4.0.5.3/4.0.5.4 to 4.1.0.0','4.1.0.0');
      hig2.upgrade('AST','nm405x_nm4100_upg.sql','Upgrade from 4.0.5.2/4.0.5.3/4.0.5.4 to 4.1.0.0','4.1.0.0');
      hig2.upgrade('WMP','nm405x_nm4100_upg.sql','Upgrade from 4.0.5.2/4.0.5.3/4.0.5.4 to 4.1.0.0','4.1.0.0');
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
