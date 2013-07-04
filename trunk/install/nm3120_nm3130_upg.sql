-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3120_nm3130_upg.sql	1.2 08/17/04
--       Module Name      : nm3120_nm3130_upg.sql
--       Date into SCCS   : 04/08/17 10:32:35
--       Date fetched Out : 07/06/13 13:57:51
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

set echo off
set linesize 120
set heading off
set feedback off
--
-- Grab date/time to append to log file names this is standard to all upgrade/install scripts
--
undefine log_extension
col         log_extension new_value log_extension noprint
set term off
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
set term on
--
----------------------------------------------------------------------------
--
--
-- Spool to Logfile
--

define logfile1='nm3120_nm3130_1_&log_extension'
define logfile2='nm3120_nm3130_2_&log_extension'
spool &logfile1

--
--get some db info

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ( 'HIG','NET');
--
--
---------------------------------------------------------------------------------------------------
--                        ****************   CHECK(S)   *******************

-- Ammend p_product to the specific product the script applies to
WHENEVER SQLERROR EXIT
begin
   hig2.pre_upgrade_check (p_product               => 'HIG'
                          ,p_new_version           => '3.1.3.0'
                          ,p_allowed_old_version_1 => '3.1.2.0'
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
--
-- THIS WILL ONLY BE REQUIRED FOR NM3 
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
--                        **************** DDL *******************
WHENEVER SQLERROR CONTINUE
SET FEEDBACK OFF

SET TERM ON
Prompt DDL Changes...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3120_nm3130_ddl_upg.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--      **************** TEMP TABLES (also used to be run after packages/views)*******************
SET TERM ON
PROMPT Temp Tables...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
'&terminator'||'temp_tables.sql' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        **************** PACKAGE HEADERS *******************

-- ************************************************************************************************ 
-- REMOVE THIS COMMENT                            
-- Ammend dir path/filenames for specific product 
-- ************************************************************************************************

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
--                        **************** PACKAGE BODIES *******************

-- ************************************************************************************************ 
-- REMOVE THIS COMMENT                            
-- Ammend dir path/filenames for specific product 
-- ************************************************************************************************

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
--   **************** VIEWS (also used to be run between headers and bodies *******************

-- ************************************************************************************************ 
-- REMOVE THIS COMMENT                            
-- Ammend dir path/filenames for specific product 
-- ************************************************************************************************

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
---------------------------------------------------------------------------------------------------
--                              **************** TRIGGERS *******************

-- ************************************************************************************************ 
-- REMOVE THIS COMMENT                            
-- Ammend dir path/filenames for specific product 
-- ************************************************************************************************

SET TERM ON
PROMPT Triggers...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'trg'||'&terminator'||'nm3trg.sql' run_file
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
START '&run_file'

spool &logfile2

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ( 'HIG','NET');

START compile_all.sql
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
--
---------------------------------------------------------------------------------------------------
--                        **************** ADD POLICIES *******************
-- re-create the policies that were dropped at the beginning of the upgrade
--

-- ************************************************************************************************ 
-- REMOVE THIS COMMENT                            
-- Ammend dir path/filenames for specific product 
-- ************************************************************************************************
-- Currently NM3 specific

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
--                        ****************   META-DATA   *******************

-- ************************************************************************************************ 
-- REMOVE THIS COMMENT                            
-- Ammend dir path/filenames for specific product 
-- ************************************************************************************************
-- Ensure all metadata changes are in <prev_rel>_<next_rel>_upg
SET TERM ON
PROMPT Meta-Data...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3120_nm3130_metadata_upg' run_file
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
select '&exor_base'||'nm3'||'&terminator'||'install'||
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
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'users_without_hig_user.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   VERSION NUMBER   *******************

-- ************************************************************************************************ 
-- REMOVE THIS COMMENT                            
-- Ammend dir path/filenames for specific product 
-- ************************************************************************************************

SET TERM ON
Prompt Setting The Version Number...
SET TERM OFF

DECLARE
   TYPE tab_prod IS TABLE OF hig_products.hpr_product%TYPE INDEX BY BINARY_INTEGER;
   l_tab_prod tab_prod;
BEGIN
   l_tab_prod(1) := 'NET';
   l_tab_prod(2) := 'HIG';
   l_tab_prod(3) := 'DOC';
   FOR i IN 1..l_tab_prod.COUNT
    LOOP
      hig2.upgrade(l_tab_prod(i),'nm3120_nm3130_upg.sql','Upgrade from 3.1.2.0 to 3.1.3.0','3.1.3.0');
   END LOOP;
END;
/
COMMIT;

SELECT 'Product update to version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ( 'HIG','NET');


spool off
exit

