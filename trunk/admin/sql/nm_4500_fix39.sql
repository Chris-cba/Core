--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/sql/nm_4500_fix39.sql-arc   3.0   Nov 19 2014 09:58:14   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_4500_fix39.sql  $
--       Date into PVCS   : $Date:   Nov 19 2014 09:58:14  $
--       Date fetched Out : $Modtime:   Nov 19 2014 09:57:36  $
--       PVCS Version     : $Revision:   3.0  $
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
define logfile1='nm_4500_fix39_&log_extension'
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
 -- Check that HIG has been installed @ v4.5.0.0
 --
 hig2.product_exists_at_version (p_product        => 'HIG'
                                ,p_VERSION        => '4.5.0.0'
                                );

END;
/
WHENEVER SQLERROR CONTINUE
--
--------------------------------------------------------------------------------
-- HIG_CODES
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Inserting into HIG_CODES
SET TERM OFF
--
SET FEEDBACK ON
INSERT INTO HIG_CODES
            (HCO_CODE
            ,HCO_DOMAIN
            ,HCO_END_DATE
            ,HCO_MEANING
            ,HCO_SEQ
            ,HCO_START_DATE
            ,HCO_SYSTEM
            )
SELECT 'REMOTE_SERVER'
           ,'DOC_LOCATION_TYPES'
           ,NULL
           ,'Remote File Server'
           ,50
           ,NULL
           ,'Y'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'DOC_LOCATION_TYPES'
                     AND HCO_CODE = 'REMOTE_SERVER'
                 )
/                               
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- HIG_OPTION_LIST
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Adding new product option MSREMSVR into HIG_OPTION_LIST
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
SELECT 'MSREMSVR'
      ,'DOC'
      ,'Flag for managed service'
      ,'Set flag to Y for managed service installations'
      ,'Y_OR_N'
      ,'VARCHAR2'
      ,'N'
      ,'N'
      ,1
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'MSREMSVR'
                 )
/
--
SET TERM ON 
PROMPT Adding option value to HIG_OPTION_VALUES
SET TERM OFF
--
INSERT INTO HIG_OPTION_VALUES
           (HOV_ID, 
            HOV_VALUE
           )  
SELECT 'MSREMSVR'
      ,'N'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'MSREMSVR'
                 )
/
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4500_fix39.sql 
--
SET FEEDBACK ON
start log_nm_4500_fix39.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
commit;
--