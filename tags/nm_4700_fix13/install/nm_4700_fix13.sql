--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix13.sql-arc   1.0   Aug 26 2016 10:33:02   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4700_fix13.sql  $
--       Date into PVCS   : $Date:   Aug 26 2016 10:33:02  $
--       Date fetched Out : $Modtime:   Mar 12 2015 15:19:12  $
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
define logfile1='nm_4700_fix13_&log_extension'
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
-- Package Header
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating package header nm3rvrs
SET TERM OFF
--
SET FEEDBACK ON
start nm3rvrs.pkh
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
--

SET TERM ON 
PROMPT Creating view v_node_proximity_check.vw
SET TERM OFF
--
SET FEEDBACK ON
start v_node_proximity_check.vw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Body
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating package body nm3rvrs
SET TERM OFF
--
SET FEEDBACK ON
start nm3rvrs.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating package body nm3rsc
SET TERM OFF
--
SET FEEDBACK ON
start nm3rsc.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating package body nm3sdo
SET TERM OFF
--
SET FEEDBACK ON
start nm3sdo.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating package body nm3undo
SET TERM OFF
--
SET FEEDBACK ON
start nm3undo.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating package body nm3layer_tool
SET TERM OFF
--
SET FEEDBACK ON
start nm3layer_tool.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Creating package body nm3sdm
SET TERM OFF
--
SET FEEDBACK ON
start nm3sdm.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Creating package body nm3split
SET TERM OFF
--
SET FEEDBACK ON
start nm3split.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Creating package body nm3nwval
SET TERM OFF
--
SET FEEDBACK ON
start nm3nwval.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Creating package body nm3lrs
SET TERM OFF
--
SET FEEDBACK ON
start nm3lrs.pkw
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

SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- HIG_OPTION_LIST
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Adding new product option NODETOL into HIG_OPTION_LIST
SET TERM OFF
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
SELECT 'NODETOL'
      ,'NET'
      ,'Node Tolerance Distance'
      ,'Defines the distance from a route Offset to search for nodes'
      ,NULL
      ,'NUMBER'
      ,'N'
      ,'N'
      ,2000
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'NODETOL'
                 )
/
--
SET TERM ON 
PROMPT Adding new product option SDOMINPROJ into HIG_OPTION_LIST
SET TERM OFF
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
SELECT 'SDOMINPROJ'
      ,'NET'
      ,'Minimum Projection Distance'
      ,'The minimum measured length of a datum which may result from a split at the projection of a node onto the element geometry'
      ,NULL
      ,'NUMBER'
      ,'N'
      ,'N'
      ,2000
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SDOMINPROJ'
                 )
/
--
SET TERM ON 
PROMPT Adding new product option SDOPROXTOL into HIG_OPTION_LIST
SET TERM OFF
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
SELECT 'SDOPROXTOL'
      ,'NET'
      ,'Proximity Buffer'
      ,'Defines distance buffer (in Metres) from a selected network element, to check for nodes that can be used for network split operations'
      ,NULL
      ,'NUMBER'
      ,'N'
      ,'N'
      ,2000
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SDOPROXTOL'
                 )
/
--
--------------------------------------------------------------------------------
-- HIG_OPTION_VALUES
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Adding option values to HIG_OPTION_VALUES
SET TERM OFF
--
INSERT INTO HIG_OPTION_VALUES
           (HOV_ID, 
            HOV_VALUE
           )  
SELECT 'NODETOL'
      ,'5'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'NODETOL'
                 )
/
--
INSERT INTO HIG_OPTION_VALUES
           (HOV_ID, 
            HOV_VALUE
           )  
SELECT 'SDOMINPROJ'
      ,'0.5'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'SDOMINPROJ'
                 )
/
--
INSERT INTO HIG_OPTION_VALUES
           (HOV_ID, 
            HOV_VALUE
           )  
SELECT 'SDOPROXTOL'
      ,'50'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'SDOPROXTOL'
                 )
/

--
--------------------------------------------------------------------------------
-- NM_ERRORS
--------------------------------------------------------------------------------
--
UPDATE nm_errors
SET ner_descr = 'Position coincides with node(s). Do you wish to split at a node?'
WHERE ner_appl = 'NET'
AND ner_id = 360
/
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4700_fix13.sql 
--
SET FEEDBACK ON
start log_nm_4700_fix13.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
commit;
--