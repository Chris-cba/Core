--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix20.sql-arc   1.0   Aug 26 2016 10:33:54   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4700_fix20.sql  $
--       Date into PVCS   : $Date:   Aug 26 2016 10:33:54  $
--       Date fetched Out : $Modtime:   Jul 16 2015 10:02:16  $
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
define logfile1='nm_4700_fix20_&log_extension'
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
-- HIG_OPTION_LIST
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT hig_option_list
SET TERM OFF

INSERT INTO HIG_OPTION_LIST 
           (HOL_ID,
            HOL_PRODUCT,
            HOL_NAME,
            HOL_REMARKS,
            HOL_DOMAIN,
            HOL_DATATYPE,
            HOL_MIXED_CASE,
            HOL_USER_OPTION,
            HOL_MAX_LENGTH
            )
SELECT 'SHPJAVASRV'
      ,'HIG'
      ,'Java Shape Tool SDE Server'
      ,'Server on which SDE is running, used by the Java Shape Tool'
      ,NULL
      ,'VARCHAR2'
      ,'N'
      ,'N'
      ,2000
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SHPJAVASRV'
                 )
/
--
INSERT INTO HIG_OPTION_LIST 
           (HOL_ID,
            HOL_PRODUCT,
            HOL_NAME,
            HOL_REMARKS,
            HOL_DOMAIN,
            HOL_DATATYPE,
            HOL_MIXED_CASE,
            HOL_USER_OPTION,
            HOL_MAX_LENGTH
            )
SELECT 'SHPJAVADB'
      ,'HIG'
      ,'Java Shape Tool SID'
      ,'Database SID used by Java Shape Tool'
      ,NULL
      ,'VARCHAR2'
      ,'N'
      ,'N'
      ,2000
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SHPJAVADB'
                 )
/
--
INSERT INTO HIG_OPTION_LIST 
           (HOL_ID,
            HOL_PRODUCT,
            HOL_NAME,
            HOL_REMARKS,
            HOL_DOMAIN,
            HOL_DATATYPE,
            HOL_MIXED_CASE,
            HOL_USER_OPTION,
            HOL_MAX_LENGTH
            )
SELECT 'SHPJAVAUP'
      ,'HIG'
      ,'Java Shape Tool upload dir.'
      ,'Upload directory used by Java Shape Tool'
      ,NULL
      ,'VARCHAR2'
      ,'N'
      ,'N'
      ,2000
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SHPJAVAUP'
                 )
/
--
INSERT INTO HIG_OPTION_LIST 
           (HOL_ID,
            HOL_PRODUCT,
            HOL_NAME,
            HOL_REMARKS,
            HOL_DOMAIN,
            HOL_DATATYPE,
            HOL_MIXED_CASE,
            HOL_USER_OPTION,
            HOL_MAX_LENGTH
            )
SELECT 'SHPJAVAEX'
      ,'HIG'
      ,'SHP Java Tool extract dir.'
      ,'Extract directory used by Java Shape Tool'
      ,NULL
      ,'VARCHAR2'
      ,'N'
      ,'N'
      ,2000
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SHPJAVAEX'
                 )
/
--
INSERT INTO HIG_OPTION_LIST 
           (HOL_ID,
            HOL_PRODUCT,
            HOL_NAME,
            HOL_REMARKS,
            HOL_DOMAIN,
            HOL_DATATYPE,
            HOL_MIXED_CASE,
            HOL_USER_OPTION,
            HOL_MAX_LENGTH
            )
SELECT 'SHPJAVABIN'
      ,'HIG'
      ,'Java Shape Tool bin directory'
      ,'Directory where Java Shape Tool executables are located on the database server'
      ,NULL
      ,'VARCHAR2'
      ,'N'
      ,'N'
      ,2000
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SHPJAVABIN'
                 )
/
--
INSERT INTO HIG_OPTION_LIST 
           (HOL_ID,
            HOL_PRODUCT,
            HOL_NAME,
            HOL_REMARKS,
            HOL_DOMAIN,
            HOL_DATATYPE,
            HOL_MIXED_CASE,
            HOL_USER_OPTION,
            HOL_MAX_LENGTH
            )
SELECT 'SHPJAVAPRT'
      ,'HIG'
      ,'Java Shape Tool Port No.'
      ,'Port Number used by Java Shape Tool'
      ,NULL
      ,'VARCHAR2'
      ,'N'
      ,'N'
      ,2000
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SHPJAVAPRT'
                 )
/
--
INSERT INTO HIG_OPTION_LIST 
           (HOL_ID,
            HOL_PRODUCT,
            HOL_NAME,
            HOL_REMARKS,
            HOL_DOMAIN,
            HOL_DATATYPE,
            HOL_MIXED_CASE,
            HOL_USER_OPTION,
            HOL_MAX_LENGTH
            )
SELECT 'SHPJAVARTE'
      ,'HIG'
      ,'Route Type'
      ,'Route Type on which the Materialized views used in shape file production are based'
      ,NULL
      ,'VARCHAR2'
      ,'N'
      ,'N'
      ,2000
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SHPJAVARTE'
                 )
/
--
--------------------------------------------------------------------------------
-- HIG_OPTION_VALUES
--------------------------------------------------------------------------------
--
--
SET TERM ON
PROMPT hig_option_values
SET TERM OFF


INSERT INTO HIG_OPTION_VALUES
           (HOV_ID, 
            HOV_VALUE
           )  
SELECT 'SHPJAVARTE'
      ,'SECT'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'SHPJAVARTE'
                 )
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
        -4
       ,'Route Materialized View Refresh'
       ,'Refreshes Materialized views used in the production of shapefiles'
       ,'lb_aggr.refresh_route_views;'
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
                   WHERE HPT_PROCESS_TYPE_ID = -4);

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
        -4
       ,'HIG_ADMIN' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PROCESS_TYPE_ROLES
                   WHERE HPTR_PROCESS_TYPE_ID = -4
                    AND  HPTR_ROLE = 'HIG_ADMIN');
--
--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Location Bridge Types
SET TERM OFF
--
SET FEEDBACK ON
start lb_data_types.sql
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Function
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating function get_lb_RPt_r_tab
SET TERM OFF
--
SET FEEDBACK ON
start get_lb_RPt_r_tab.fnw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating view v_obj_on_route.vw
SET TERM OFF
--
SET FEEDBACK ON
BEGIN
NM3CTX.SET_CONTEXT('MV_ROUTE_TYPE', hig.get_sysopt('SHPJAVARTE'));
END;
/

start v_obj_on_route.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating view v_geom_on_route.vw
SET TERM OFF
--
SET FEEDBACK ON
start v_geom_on_route.vw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Package Header
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating package header lb_aggr
SET TERM OFF
--
SET FEEDBACK ON
start lb_aggr.pkh
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Body
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating package body lb_aggr
SET TERM OFF
--
SET FEEDBACK ON
start lb_aggr.pkw
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
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4700_fix20.sql 
--
SET FEEDBACK ON
start log_nm_4700_fix20.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
commit;
--