976271--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/nm3_install.sql-arc   2.54   Jun 01 2020 14:51:58   Chris.Baugh  $
--       Module Name      : $Workfile:   nm3_install.sql  $
--       Date into PVCS   : $Date:   Jun 01 2020 14:51:58  $
--       Date fetched Out : $Modtime:   Jun 01 2020 14:48:46  $
--       PVCS Version     : $Revision:   2.54  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
--------------------------------------------------------------------------------
--
set echo off
set linesize 120
set heading off
set feedback off

--
---------------------------------------------------------------------------------------------------
--
undefine nmlogfile1
undefine nmlogfile2
col         nmlogfile1 new_value nmlogfile1 noprint
col         nmlogfile2 new_value nmlogfile2 noprint
set term off
SELECT  'core'||REPLACE('&new_version','.')||'_install_1_'||TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' nmlogfile1 
       ,'core'||REPLACE('&new_version','.')||'_install_2_'||TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' nmlogfile2 
from dual
/
set term on
---------------------------------------------------------------------------------------------------
-- Spool to Logfile
define nmlogfile1='&nmlogfile1'
define nmlogfile2='&nmlogfile2'

SPOOL &nmlogfile1
--
---------------------------------------------------------------------------------------------------
--
select 'Installation Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MM:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;

WHENEVER SQLERROR CONTINUE
--
---------------------------------------------------------------------------------------------------
--                        ****************   EXOR_CORE ACCOUNT LOCK  *******************
--
--  After intial object creation the exor_core account is not needed to be logged into, so lock it.
Alter User Exor_Core Account Lock
/
--
---------------------------------------------------------------------------------------------------
--                        ****************   TYPES  *******************
SET TERM ON
prompt Types...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm3typ.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   TABLES  *******************
SET TERM ON
prompt Tables...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3.tab' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   CONSTRAINTS  *******************
SET TERM ON
prompt Constraints...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3.con' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   INDEXES  *******************
SET TERM ON
prompt Indexes...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3.ind' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   SEQUENCES  *******************
SET TERM ON
prompt Sequences...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3.sqs' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   PACKAGE HEADERS  *******************
SET TERM ON
prompt Package Headers...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'nm3pkh.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                            ****************   INVSEC  *******************
SET TERM ON
prompt INVSEC...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'ctx'||'&terminator'||'invsec.pkh' run_file
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
SET TERM OFF
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
---------------------------------------------------------------------------------------------------
--                            ****************   VIEWS  *******************
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
--                         ****************   PACKAGE BODIES  *******************
SET TERM ON
prompt Package Bodies...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'nm3pkb.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
SET TERM OFF
--
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
--                         ****************   TRIGGERS  *******************
SET TERM ON
prompt Triggers...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'trg'||'&terminator'||'nm3trg.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                **************** synonym required for packages   ****************
--
-- Removed for Task 0108674
--
--SET TERM ON
--prompt MDSYS.SDO_GEOM_METADATA_TABLE synonym
--SET TERM OFF
--SET DEFINE ON
--Create Public Synonym sdo_geom_metadata_table for mdsys.sdo_geom_metadata_table;
--
---------------------------------------------------------------------------------------------------
--                         ****************   ROLES  *******************
SET TERM ON
prompt Roles...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'higroles' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   INIT CONTEXT *******************
SET TERM ON
prompt Set Context Values...
SET TERM OFF
SET DEFINE ON
exec nm3security.set_user;
exec nm3context.initialise_context;

commit;
/
--
---------------------------------------------------------------------------------------------------
--                         ****************   POLICIES  *******************
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
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                         ****************   HIG VIEWS  *******************
SET TERM ON
prompt HIG Views...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'higviews' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                     ****************   TRANSLATION VIEWS  *******************
SET TERM ON
prompt Translation Views...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'translation.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
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
--                        ****************   Apply SDO_LRS replacement code if Oracle Spatial is not installed *******************
SET TERM ON
Prompt Applying SDO_LRS replacement, if Oracle Spatial not installed...
SET TERM OFF

select decode(count(*), 0 , '&exor_base'||'nm3'||'&terminator'||'install'||'&terminator'||'install_sdo_lrs_replacement',
                            '&exor_base'||'nm3'||'&terminator'||'install'||'&terminator'||'dummy') run_file
from dba_registry
where comp_name='Spatial'
and status = 'VALID'
/

SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
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

SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'utl'||'&terminator'||'compile_schema.sql' run_file
FROM dual
/
START '&run_file'

spool &nmlogfile2

--get some db info
select 'Install Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MM:SS') from dual;
SELECT 'Install Running on ' ||LOWER(username||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance
    ,user_users;

START compile_all.sql
--
Declare
  view_not_exist Exception;
  Pragma Exception_Init( view_not_exist, -942);
Begin
  Execute Immediate 'alter view network_node compile';
Exception When view_not_exist
  Then
    Null;
End;
/

Declare
  view_not_exist Exception;
  Pragma Exception_Init( view_not_exist, -942);
Begin
  Execute Immediate 'alter synonym road_seg_membs_partial compile';
Exception When view_not_exist
  Then
    Null;
End;
/
--
-- This is not the case any more so shouldn't need to happen
---------------------------------------------------------------------------------------------------
--                        ****************   CONTEXT   *******************
-- The compile_all will have reset the user context so we must reinitialise it
--
--SET FEEDBACK OFF
--
--SET TERM ON
--PROMPT Reinitialising Context...
--SET TERM OFF
--BEGIN
--  nm3context.initialise_context;
--  nm3user.instantiate_user;
--END;
--/
--
---------------------------------------------------------------------------------------------------
--                        ****************   META-DATA  *******************
SET TERM ON
PROMPT Meta-Data - Create Products ..
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3data1.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF

SET TERM ON
PROMPT Meta-Data - Create Reporting Metadata ..
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3data2.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF

SET TERM ON
PROMPT Meta-Data - Create Roles ..
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3data3.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   ROLES  *******************
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
---------------------------------------------------------------------------------------------------
--                        ****************   META-DATA  *******************
SET TERM ON
PROMPT Meta-Data...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3data_install.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   Location Bridge META-DATA  *******************
PROMPT create LB_NETWORK metadata

INSERT INTO user_sdo_network_metadata (network,
                                       network_id,
                                       network_category,
                                       no_of_hierarchy_levels,
                                       no_of_partitions,
                                       node_table_name,
                                       node_cost_column,
                                       link_table_name,
                                       link_direction,
                                       link_cost_column,
                                       path_table_name,
                                       path_link_table_name,
                                       subpath_table_name)
     VALUES ('LB_NETWORK',
             1,
             'LOGICAL',
             1,
             0,
             'LB_NETWORK_NO',
             'XNO_COST',
             'LB_NETWORK_LINK',
             'UNDIRECTED',
             'XNW_COST',
             'LB_NETWORK_PATH',
             'LB_NETWORK_PATH_LINK',
             'LB_NETWORK_SUB_PATH');

--
---------------------------------------------------------------------------------------------------
--                        ****************   SYNONYMS   *******************
SET TERM ON
Prompt Creating Synonyms That Do Not Exist...
SET TERM OFF
EXECUTE nm3ddl.refresh_all_synonyms;
--
---------------------------------------------------------------------------------------------------
--                  ****************   UNIT CONVERSION FUNCTIONS  *******************
SET TERM ON
Prompt Creating Unit Conversion Functions...
SET TERM OFF
SET DEFINE ON
--exec nm3context.initialise_context --shouldn'tt need to happen at 4500
exec nm3unit.build_all_unit_conv_functions
--
---------------------------------------------------------------------------------------------------
--                  ****************   CREATE DATE TRACKED DATUMS  *******************
SET TERM ON
Prompt Create a date tracked Datum theme for each base Network theme....
SET TERM OFF
BEGIN
  nm3sdm.make_all_datum_layers_dt;
END;
/
--
---------------------------------------------------------------------------------------------------
--                  ****************   CREATE JOBS  *******************
--
--
--SET TERM ON
--PROMPT Create table maintenance Jobs
--SET TERM OFF
--SET DEFINE ON
--select '&exor_base'||'nm3'||'&terminator'||'install'||
--        '&terminator'||'nm3jobs.sql' run_file
--from dual
--/
--SET FEEDBACK ON
--start '&&run_file'
--SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                  ****************   CREATE ACLs  *******************
--
--
SET TERM ON
PROMPT Create standard ACLs
SET TERM OFF
BEGIN
  nm3acl.create_standard_acls;
END;
/
--
---------------------------------------------------------------------------------------------------
--                     ****************   RE-BUILD SEQUENCES  *******************
SET TERM ON
Prompt make sure .NEXTVAL on sequences is not less than values in associated tables...
SET TERM OFF
SET DEFINE ON
EXEC nm3ddl.rebuild_all_sequences;
--
---------------------------------------------------------------------------------------------------
--                     ****************   Create Process for housekeeping  *******************
SET TERM ON
PROMPT New process to clean up forms parameter table everyday
SET TERM OFF

------------------------------------------------------------------
--
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- New process to clean up forms parameter table everyday
--
------------------------------------------------------------------
Declare
  l_Process_Id            Hig_Processes.Hp_Process_Id%Type;
  l_Job_Name              Hig_Processes.Hp_Job_Name%Type;
  l_Scheduled_Start_Date  Date;
Begin
  -- If Process Framework is Down, start it
  IF hig_process_admin.scheduler_disabled = 'TRUE' THEN

    hig_process_admin.set_scheduler_state('UP');

  END IF;
--
  Hig_Process_Api.Create_And_Schedule_Process (
                                              pi_Process_Type_Id           =>   -3,
                                              pi_Initiators_Ref            =>   'COREHOUSE',
                                              pi_Start_Date                =>   Sysdate,
                                              pi_Frequency_Id              =>   -11,
                                              po_Process_Id                =>   l_Process_Id,
                                              po_Job_Name                  =>   l_Job_Name,
                                              po_Scheduled_Start_Date      =>   l_Scheduled_Start_Date
                                              );
	hig_process_admin.set_scheduler_state('UP');
--
   Commit;
  Dbms_Output.Put_Line('Created Core Houseleeping Process');
  Dbms_Output.Put_Line('Process_Id:'            || To_Char(l_Process_Id) );
  Dbms_Output.Put_Line('Job_Name:'              || l_Job_Name);
  Dbms_Output.Put_Line('Scheduled_Start_Date:'  || To_Char(l_Scheduled_Start_Date,'dd-mm-yyyy hh24:mi.ss'));
End;
/
--
---------------------------------------------------------------------------------------------------
--                        ****************   VERSION NUMBER   *******************
SET TERM ON
Prompt Setting The Version Number...
SET TERM OFF
BEGIN
      hig2.upgrade('HIG','nm3_install.sql','Installed','&new_version');
      hig2.upgrade('NET','nm3_install.sql','Installed','&new_version');
      hig2.upgrade('DOC','nm3_install.sql','Installed','&new_version');
      hig2.upgrade('AST','nm3_install.sql','Installed','&new_version');
      hig2.upgrade('WMP','nm3_install.sql','Installed','&new_version');
END;
/
COMMIT;
SELECT 'Product installed at version '||hpr_product||' ' ||hpr_version details
FROM hig_products
WHERE hpr_product IN ('HIG','NET','DOC','AST','WMP')
order by hpr_product;
--
spool off
exit
