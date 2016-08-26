--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix21.sql-arc   1.0   Aug 26 2016 10:34:54   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4700_fix21.sql  $
--       Date into PVCS   : $Date:   Aug 26 2016 10:34:54  $
--       Date fetched Out : $Modtime:   Sep 23 2015 11:37:06  $
--       PVCS Version     : $Revision:   1.0  $
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
define logfile1='nm_4700_fix21_&log_extension'
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

--
--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
--
--
--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating view v_nm_group_structure.vw
SET TERM OFF
--
SET FEEDBACK ON
start v_nm_group_structure.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating view v_nm_sub_group_structure.vw
SET TERM OFF
--
SET FEEDBACK ON
start v_nm_sub_group_structure.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating view v_nm_group_hierarchy.vw
SET TERM OFF
--
SET FEEDBACK ON
start v_nm_group_hierarchy.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating view v_nm_network_themes.vw
SET TERM OFF
--
SET FEEDBACK ON
start v_nm_network_themes.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating view v_nm_rebuild_all_nat_sdo_join.vw
SET TERM OFF
--
SET FEEDBACK ON
start v_nm_rebuild_all_nat_sdo_join.vw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Package Header
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating package header nm3sdo
SET TERM OFF
--
SET FEEDBACK ON
start nm3sdo.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating package header nm3pla
SET TERM OFF
--
SET FEEDBACK ON
start nm3pla.pkh
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Creating package header nm3layer_tool
SET TERM OFF
--
SET FEEDBACK ON
start nm3layer_tool.pkh
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Body
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating package body nm3sdo
SET TERM OFF
--
SET FEEDBACK ON
start nm3sdo.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating package body nm3sdm
SET TERM OFF
--
SET FEEDBACK ON
start nm3sdm.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating package body nm3layer_tool
SET TERM OFF
--
SET FEEDBACK ON
start nm3layer_tool.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating package body nm3pla
SET TERM OFF
--
SET FEEDBACK ON
start nm3pla.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating package body nm3invval
SET TERM OFF
--
SET FEEDBACK ON
start nm3invval.pkw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Synonyms
--------------------------------------------------------------------------------
--
SET FEEDBACK ON
BEGIN
  nm3ddl.refresh_all_synonyms;
END;
/

--
--------------------------------------------------------------------------------
-- HIG_PROCESS_TYPES
--------------------------------------------------------------------------------
--
--
SET TERM ON
PROMPT hig_process_types
SET TERM OFF

INSERT INTO HIG_PROCESS_TYPES
       (HPT_PROCESS_TYPE_ID
       ,HPT_NAME
       ,HPT_DESCR
       ,HPT_WHAT_TO_CALL
       ,HPT_INITIATION_MODULE
       ,HPT_INTERNAL_MODULE
       ,HPT_INTERNAL_MODULE_PARAM
       ,HPT_PROCESS_LIMIT
       ,HPT_RESTARTABLE
       ,HPT_SEE_IN_HIG2510
       ,HPT_POLLING_ENABLED
       ,HPT_POLLING_FTP_TYPE_ID
       ,HPT_AREA_TYPE
       )
SELECT 
        -5
       ,'Group of Groups Theme Refresh'
       ,'Refreshes Materialized views used in the production of shapefiles'
       ,'nm3layer_tool.refresh_group_of_groups;'
       ,''
       ,''
       ,''
       ,''
       ,'Y'
       ,'Y'
       ,'N'
       ,null
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PROCESS_TYPES
                   WHERE HPT_PROCESS_TYPE_ID = -5);

--
--------------------------------------------------------------------------------
-- HIG_PROCESS_TYPE_ROLES
--------------------------------------------------------------------------------
--
--
SET TERM ON
PROMPT hig_process_type_roles
SET TERM OFF

INSERT INTO HIG_PROCESS_TYPE_ROLES
       (HPTR_PROCESS_TYPE_ID
       ,HPTR_ROLE
       )
SELECT 
        -5
       ,'HIG_ADMIN' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PROCESS_TYPE_ROLES
                   WHERE HPTR_PROCESS_TYPE_ID = -5
                    AND  HPTR_ROLE = 'HIG_ADMIN');


--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4700_fix21.sql 
--
SET FEEDBACK ON
start log_nm_4700_fix21.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
commit;
--