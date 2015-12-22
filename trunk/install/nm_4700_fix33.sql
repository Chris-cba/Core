--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix33.sql-arc   1.0   Dec 22 2015 17:20:14   Sarah.Williams  $
--       Module Name      : $Workfile:   nm_4700_fix33.sql  $
--       Date into PVCS   : $Date:   Dec 22 2015 17:20:14  $
--       Date fetched Out : $Modtime:   Dec 22 2015 17:12:06  $
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
define logfile1='nm_4700_fix33_&log_extension'
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
-- New function
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating function get_passw_exp_date
SET TERM OFF
--
SET FEEDBACK ON
start get_passw_exp_date.fnc
SET FEEDBACK OFF


--
--------------------------------------------------------------------------------
-- create New rep parameters
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating new parameters
SET TERM OFF
--
SET FEEDBACK ON
INSERT INTO GRI_PARAMS
      (
      GP_PARAM
      ,GP_PARAM_TYPE
      ,GP_TABLE
      ,GP_COLUMN
      ,GP_DESCR_COLUMN
      ,GP_SHOWN_COLUMN
      ,GP_SHOWN_TYPE
      ,GP_DESCR_TYPE
      ,GP_ORDER
      ,GP_CASE
      ,GP_GAZ_RESTRICTION
         )
SELECT  'HUS_STATUS'
             ,'CHAR'
             ,'GRI_PARAM_LOOKUP'
             ,'GPL_VALUE'
             ,'GPL_DESCR'
             ,'GPL_VALUE'
             ,'CHAR'
             ,'CHAR'
             ,null
             ,null
             ,null        
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM GRI_PARAMS
                                  WHERE GP_PARAM='HUS_STATUS');
--
INSERT INTO GRI_MODULE_PARAMS
       (
         GMP_MODULE
         ,GMP_PARAM
         ,GMP_SEQ
         ,GMP_PARAM_DESCR
         ,GMP_MANDATORY
         ,GMP_NO_ALLOWED
         ,GMP_WHERE
         ,GMP_TAG_RESTRICTION
         ,GMP_TAG_WHERE
         ,GMP_DEFAULT_TABLE
         ,GMP_DEFAULT_COLUMN
         ,GMP_DEFAULT_WHERE
         ,GMP_VISIBLE
         ,GMP_GAZETTEER
         ,GMP_LOV
         ,GMP_VAL_GLOBAL
         ,GMP_WILDCARD
         ,GMP_HINT_TEXT
         ,GMP_ALLOW_PARTIAL
         ,GMP_BASE_TABLE
         ,GMP_BASE_TABLE_COLUMN
         ,GMP_OPERATOR
       )
SELECT 
      'HIG1864'
      ,'HUS_STATUS'
      ,3
      ,'Include End Dated?'
      ,'N'
      ,1
      ,'GPL_PARAM=''HUS_STATUS'''
      ,'N'
      ,null
      ,'GRI_PARAM_LOOKUP'
      ,'GPL_VALUE'
      ,'GPL_VALUE=''N'' AND GPL_PARAM=''HUS_STATUS'''
      ,'Y'
      ,'N'
      ,'Y'
      ,null
      ,'N'
      ,'Include end dated users?'
      ,'N'
      ,null
      ,null
      ,null FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULE_PARAMS
                   WHERE GMP_MODULE = 'HIG1864'
                   AND GMP_PARAM='HUS_STATUS');
--
INSERT INTO GRI_PARAM_LOOKUP
       (
      GPL_PARAM
      ,GPL_VALUE
      ,GPL_DESCR
       )
SELECT 
      'HUS_STATUS'
      ,'Y'
      ,'Yes'
      FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM GRI_PARAM_LOOKUP
                   WHERE GPL_PARAM='HUS_STATUS'
                   AND GPL_VALUE='Y');        
--
INSERT INTO GRI_PARAM_LOOKUP
       (
      GPL_PARAM
      ,GPL_VALUE
      ,GPL_DESCR
       )
SELECT 
      'HUS_STATUS'
      ,'N'
      ,'No'
      FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM GRI_PARAM_LOOKUP
                   WHERE GPL_PARAM='HUS_STATUS'
                   AND GPL_VALUE='N');        
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4700_fix33.sql 
--
SET FEEDBACK ON
start log_nm_4700_fix33.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
commit;
--
