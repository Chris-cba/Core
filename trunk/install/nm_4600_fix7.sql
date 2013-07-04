--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4600_fix7.sql-arc   1.1   Jul 04 2013 13:48:10   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_4600_fix7.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:48:10  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:24  $
--       PVCS Version     : $Revision:   1.1  $
--
----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
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
define logfile1='nm_4600_fix7_&log_extension'
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
 -- Check that HIG has been installed @ v4.6.0.0
 --
 hig2.product_exists_at_version (p_product        => 'NET'
                                ,p_VERSION        => '4.6.0.0'
                                );

END;
/
WHENEVER SQLERROR CONTINUE


--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT hig_svr_util.pkw
SET TERM OFF
--
SET FEEDBACK ON
start hig_svr_util.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Metadata
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Product Options
SET TERM OFF
SET FEEDBACK OFF
--
----------------------------------------------------------------------------------------
--
MERGE INTO HIG_OPTION_LIST A USING
 (SELECT
  'UNZIPCMD' as HOL_ID,
  'HIG' as HOL_PRODUCT,
  'Command line to invoke unzip' as HOL_NAME,
  'Command line to invoke unzip such as ''c:\tools\unzip\unzip or /bin/unzip''' as HOL_REMARKS,
  NULL as HOL_DOMAIN,
  'VARCHAR2' as HOL_DATATYPE,
  'Y' as HOL_MIXED_CASE,
  'Y' as HOL_USER_OPTION,
  2000 as HOL_MAX_LENGTH
  FROM DUAL) B
ON (A.HOL_ID = B.HOL_ID)
WHEN NOT MATCHED THEN 
INSERT (
  HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, 
  HOL_DATATYPE, HOL_MIXED_CASE, HOL_USER_OPTION, HOL_MAX_LENGTH)
VALUES (
  B.HOL_ID, B.HOL_PRODUCT, B.HOL_NAME, B.HOL_REMARKS, B.HOL_DOMAIN, 
  B.HOL_DATATYPE, B.HOL_MIXED_CASE, B.HOL_USER_OPTION, B.HOL_MAX_LENGTH)
WHEN MATCHED THEN
UPDATE SET 
  A.HOL_PRODUCT = B.HOL_PRODUCT,
  A.HOL_NAME = B.HOL_NAME,
  A.HOL_REMARKS = B.HOL_REMARKS,
  A.HOL_DOMAIN = B.HOL_DOMAIN,
  A.HOL_DATATYPE = B.HOL_DATATYPE,
  A.HOL_MIXED_CASE = B.HOL_MIXED_CASE,
  A.HOL_USER_OPTION = B.HOL_USER_OPTION,
  A.HOL_MAX_LENGTH = B.HOL_MAX_LENGTH;
--
----------------------------------------------------------------------------------------
--
MERGE INTO HIG_OPTION_LIST A USING
 (SELECT
  'GUNZIPCMD' as HOL_ID,
  'HIG' as HOL_PRODUCT,
  'Command line to invoke gunzip' as HOL_NAME,
  'Command line to invoke gunzip such as ''/bin/gunzip''' as HOL_REMARKS,
  NULL as HOL_DOMAIN,
  'VARCHAR2' as HOL_DATATYPE,
  'Y' as HOL_MIXED_CASE,
  'Y' as HOL_USER_OPTION,
  2000 as HOL_MAX_LENGTH
  FROM DUAL) B
ON (A.HOL_ID = B.HOL_ID)
WHEN NOT MATCHED THEN 
INSERT (
  HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, 
  HOL_DATATYPE, HOL_MIXED_CASE, HOL_USER_OPTION, HOL_MAX_LENGTH)
VALUES (
  B.HOL_ID, B.HOL_PRODUCT, B.HOL_NAME, B.HOL_REMARKS, B.HOL_DOMAIN, 
  B.HOL_DATATYPE, B.HOL_MIXED_CASE, B.HOL_USER_OPTION, B.HOL_MAX_LENGTH)
WHEN MATCHED THEN
UPDATE SET 
  A.HOL_PRODUCT = B.HOL_PRODUCT,
  A.HOL_NAME = B.HOL_NAME,
  A.HOL_REMARKS = B.HOL_REMARKS,
  A.HOL_DOMAIN = B.HOL_DOMAIN,
  A.HOL_DATATYPE = B.HOL_DATATYPE,
  A.HOL_MIXED_CASE = B.HOL_MIXED_CASE,
  A.HOL_USER_OPTION = B.HOL_USER_OPTION,
  A.HOL_MAX_LENGTH = B.HOL_MAX_LENGTH;
--
----------------------------------------------------------------------------------------
--
MERGE INTO HIG_OPTION_LIST A USING
 (SELECT
  'TARCMD' as HOL_ID,
  'HIG' as HOL_PRODUCT,
  'Command line to invoke tar' as HOL_NAME,
  'Command line to invoke tar such as ''/bin/tar''' as HOL_REMARKS,
  NULL as HOL_DOMAIN,
  'VARCHAR2' as HOL_DATATYPE,
  'Y' as HOL_MIXED_CASE,
  'Y' as HOL_USER_OPTION,
  2000 as HOL_MAX_LENGTH
  FROM DUAL) B
ON (A.HOL_ID = B.HOL_ID)
WHEN NOT MATCHED THEN 
INSERT (
  HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, 
  HOL_DATATYPE, HOL_MIXED_CASE, HOL_USER_OPTION, HOL_MAX_LENGTH)
VALUES (
  B.HOL_ID, B.HOL_PRODUCT, B.HOL_NAME, B.HOL_REMARKS, B.HOL_DOMAIN, 
  B.HOL_DATATYPE, B.HOL_MIXED_CASE, B.HOL_USER_OPTION, B.HOL_MAX_LENGTH)
WHEN MATCHED THEN
UPDATE SET 
  A.HOL_PRODUCT = B.HOL_PRODUCT,
  A.HOL_NAME = B.HOL_NAME,
  A.HOL_REMARKS = B.HOL_REMARKS,
  A.HOL_DOMAIN = B.HOL_DOMAIN,
  A.HOL_DATATYPE = B.HOL_DATATYPE,
  A.HOL_MIXED_CASE = B.HOL_MIXED_CASE,
  A.HOL_USER_OPTION = B.HOL_USER_OPTION,
  A.HOL_MAX_LENGTH = B.HOL_MAX_LENGTH;
--
----------------------------------------------------------------------------------------
--
MERGE INTO HIG_OPTION_LIST A USING
 (SELECT
  'CMDSHELL' as HOL_ID,
  'HIG' as HOL_PRODUCT,
  'Location of Windows cmd shell' as HOL_NAME,
  'Location of Windows cmd shell such as ''C:\WINDOWS\system32\cmd.exe''' as HOL_REMARKS,
  NULL as HOL_DOMAIN,
  'VARCHAR2' as HOL_DATATYPE,
  'Y' as HOL_MIXED_CASE,
  'Y' as HOL_USER_OPTION,
  2000 as HOL_MAX_LENGTH
  FROM DUAL) B
ON (A.HOL_ID = B.HOL_ID)
WHEN NOT MATCHED THEN 
INSERT (
  HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, 
  HOL_DATATYPE, HOL_MIXED_CASE, HOL_USER_OPTION, HOL_MAX_LENGTH)
VALUES (
  B.HOL_ID, B.HOL_PRODUCT, B.HOL_NAME, B.HOL_REMARKS, B.HOL_DOMAIN, 
  B.HOL_DATATYPE, B.HOL_MIXED_CASE, B.HOL_USER_OPTION, B.HOL_MAX_LENGTH)
WHEN MATCHED THEN
UPDATE SET 
  A.HOL_PRODUCT = B.HOL_PRODUCT,
  A.HOL_NAME = B.HOL_NAME,
  A.HOL_REMARKS = B.HOL_REMARKS,
  A.HOL_DOMAIN = B.HOL_DOMAIN,
  A.HOL_DATATYPE = B.HOL_DATATYPE,
  A.HOL_MIXED_CASE = B.HOL_MIXED_CASE,
  A.HOL_USER_OPTION = B.HOL_USER_OPTION,
  A.HOL_MAX_LENGTH = B.HOL_MAX_LENGTH;
--
----------------------------------------------------------------------------------------
--
MERGE INTO HIG_OPTION_VALUES A USING
 (SELECT
  'UNZIPCMD' as HOV_ID,
  'unzip' as HOV_VALUE
  FROM DUAL) B
ON (A.HOV_ID = B.HOV_ID)
WHEN NOT MATCHED THEN 
INSERT (
  HOV_ID, HOV_VALUE)
VALUES (
  B.HOV_ID, B.HOV_VALUE)
WHEN MATCHED THEN
UPDATE SET 
  A.HOV_VALUE = B.HOV_VALUE;
--
----------------------------------------------------------------------------------------
--
MERGE INTO HIG_OPTION_VALUES A USING
 (SELECT
  'GUNZIPCMD' as HOV_ID,
  '/bin/gunzip' as HOV_VALUE
  FROM DUAL) B
ON (A.HOV_ID = B.HOV_ID)
WHEN NOT MATCHED THEN 
INSERT (
  HOV_ID, HOV_VALUE)
VALUES (
  B.HOV_ID, B.HOV_VALUE)
WHEN MATCHED THEN
UPDATE SET 
  A.HOV_VALUE = B.HOV_VALUE;
  
--
----------------------------------------------------------------------------------------
--
MERGE INTO HIG_OPTION_VALUES A USING
 (SELECT
  'TARCMD' as HOV_ID,
  '/bin/tar' as HOV_VALUE
  FROM DUAL) B
ON (A.HOV_ID = B.HOV_ID)
WHEN NOT MATCHED THEN 
INSERT (
  HOV_ID, HOV_VALUE)
VALUES (
  B.HOV_ID, B.HOV_VALUE)
WHEN MATCHED THEN
UPDATE SET 
  A.HOV_VALUE = B.HOV_VALUE;  
--
----------------------------------------------------------------------------------------
--
MERGE INTO HIG_OPTION_VALUES A USING
 (SELECT
  'CMDSHELL' as HOV_ID,
  'C:\WINDOWS\system32\cmd.exe' as HOV_VALUE
  FROM DUAL) B
ON (A.HOV_ID = B.HOV_ID)
WHEN NOT MATCHED THEN 
INSERT (
  HOV_ID, HOV_VALUE)
VALUES (
  B.HOV_ID, B.HOV_VALUE)
WHEN MATCHED THEN
UPDATE SET 
  A.HOV_VALUE = B.HOV_VALUE;
--
----------------------------------------------------------------------------------------
--
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4600_fix7.sql 
--
SET FEEDBACK ON
start log_nm_4600_fix7.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
--
