--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3110_nm3200_upg.sql	1.1 01/20/05
--       Module Name      : nm3110_nm3200_upg.sql
--       Date into SCCS   : 05/01/20 11:00:01
--       Date fetched Out : 07/06/13 13:57:49
--       SCCS Version     : 1.1
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
--
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
--
-- Grab date/time to append to log file names this is standard to all upgrade/install scripts

undefine log_extension
col         log_extension new_value log_extension noprint
set term off
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
set term on

---------------------------------------------------------------------------------------------------


-- Spool to Logfile

define logfile1='nm3110_nm3200_1_&log_extension'
define logfile2='nm3110_nm3200_2_&log_extension'
spool &logfile1


--get some db info

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG','NET','DOC');


---------------------------------------------------------------------------------------------------
--                        ****************   CHECK(S)   *******************

WHENEVER SQLERROR EXIT
begin
   hig2.pre_upgrade_check (p_product               => 'HIG'
                          ,p_new_version           => '3.2.0.0'
                          ,p_allowed_old_version_1 => '3.1.1.0'
                          );
END;
/
WHENEVER SQLERROR CONTINUE
--
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
--                        ****************   3110 to 3120 ddl   *******************
SET TERM ON
PROMPT 3110 to 3120 DDL ...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3110_nm3120_ddl_upg' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   3120 to 3130 ddl   *******************
SET TERM ON
PROMPT 3120 to 3130 DDL...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3120_nm3130_ddl_upg' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   3130 to 3200 ddl   *******************
SET TERM ON
PROMPT 3130 to 3200 DDL...
SET TERM OFF
BEGIN
   EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM sdo_geometry FOR mdsys.sdo_geometry';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/
--
--
BEGIN
 EXECUTE IMMEDIATE 'GRANT DELETE ANY TABLE TO  ' || USER;
END;
/ 
--
-- 698127
GRANT CREATE SEQUENCE TO hig_user;
--
--
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3130_nm3200_ddl_upg' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        **************** VIEWS   ****************
SET TERM ON
prompt Views...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||
        '&terminator'||'nm3views.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        **************** TRIGGERS   ****************
--
SET TERM ON
PROMPT Triggers...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'trg'||'&terminator'||'nm3trg.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                  **************** PACKAGE HEADERS AND BODIES   ****************
SET TERM ON
PROMPT Package Headers...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'nm3pkh.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF

SET TERM ON
PROMPT Package Bodies...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'nm3pkb.sql' run_file
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
START '&run_file'

spool &logfile2


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
--                        ****************   3110 to 3120 metadata   *******************
SET TERM ON
PROMPT 3110 to 3120 metadata ...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3110_nm3120_metadata_upg' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   3120 to 3130 metadata   *******************
SET TERM ON
PROMPT 3120 to 3130 metadata...
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
--                        ****************   3130 to 3200 metadata   *******************
SET TERM ON
PROMPT 3130 to 3200 metadata...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3130_nm3200_metadata_upg' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
--
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3data_patch.sql' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
--
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3data_patch2.sql' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
--
Prompt Populating nm_theme_gtypes
DECLARE

  CURSOR c_themes IS
  SELECT nth_theme_id 
  FROM   nm_themes_all 
       , user_tables 
       , nm_inv_themes 
       , nm_inv_types 
  WHERE  nth_theme_type = 'SDO' 
  AND    nth_feature_table = table_name 
  AND    nith_nit_id = nit_inv_type 
  AND    nith_nth_theme_id = nth_theme_id 
  AND    nit_pnt_or_cont = 'P' 
  UNION 
  SELECT nth_theme_id 
  FROM   nm_themes_all 
       , user_tables 
       , nm_nw_themes 
       , nm_linear_types n 
  WHERE   nth_theme_type = 'SDO' 
  AND     nth_feature_table = table_name 
  AND     nnth_nth_theme_id = nth_theme_id 
  AND     n.nlt_id = nnth_nlt_id 
  UNION 
  SELECT nth_theme_id 
  FROM   nm_themes_all 
       , user_tables 
       , nm_area_themes 
  WHERE  nth_theme_type = 'SDO' 
  AND    nth_feature_table = table_name 
  AND    nath_nth_theme_id = nth_theme_id;

  l_gtype nm_theme_gtypes.ntg_gtype%TYPE;

BEGIN

 FOR i IN c_themes LOOP
 
 BEGIN
 
    l_gtype := nm3sdo.get_theme_gtype(i.nth_theme_id);
    
    IF l_gtype IS NOT NULL THEN
  
      INSERT INTO nm_theme_gtypes(ntg_theme_id
                                 ,ntg_gtype
                                 ,ntg_seq_no)
                          VALUES (i.nth_theme_id
                                 ,l_gtype
                                 ,1);
                                 
    END IF;
                                 
 EXCEPTION
   WHEN others THEN Null;
 END; 
 
 END LOOP;
 
 COMMIT;

END;
/
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
--
---------------------------------------------------------------------------------------------------
--                        ****************   VERSION NUMBER   *******************
SET TERM ON
Prompt Setting The Version Number...
SET TERM OFF

BEGIN
      hig2.upgrade('HIG','nm3110_nm3200_upg.sql','Upgrade from 3.1.1.0 to 3.2.0.0','3.2.0.0');
      hig2.upgrade('NET','nm3110_nm3200_upg.sql','Upgrade from 3.1.1.0 to 3.2.0.0','3.2.0.0');
      hig2.upgrade('DOC','nm3110_nm3200_upg.sql','Upgrade from 3.1.1.0 to 3.2.0.0','3.2.0.0');
END;
/
COMMIT;

SET HEADING OFF
SELECT 'Product updated to version '||hpr_product||' ' ||hpr_version product_version
FROM hig_products
WHERE hpr_product IN ('HIG','NET','DOC');


spool off
exit
--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************

