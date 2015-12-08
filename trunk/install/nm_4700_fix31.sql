--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix31.sql-arc   1.1   Dec 08 2015 11:11:50   Rob.Coupe  $
--       Module Name      : $Workfile:   nm_4700_fix31.sql  $ 
--       Date into PVCS   : $Date:   Dec 08 2015 11:11:50  $
--       Date fetched Out : $Modtime:   Dec 08 2015 11:11:30  $
--       PVCS Version     : $Revision:   1.1  $
--
----------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
----------------------------------------------------------------------------
--
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
--
-- Grab date/time to append to log file name
--
UNDEFINE log_extension
COL      log_extension NEW_VALUE log_extension NOPRINT
SET TERM OFF
SELECT  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension FROM DUAL
/
SET TERM ON
--
--------------------------------------------------------------------------------
--
-- Spool to Logfile
--
DEFINE logfile1='nm_4700_fix31_&log_extension'
SPOOL &logfile1
--
--------------------------------------------------------------------------------
--
SELECT 'Fix Date ' || TO_CHAR(sysdate, 'DD-MON-YYYY HH24:MI:SS') FROM DUAL;
--
SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
--
SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG','NET');
--
--------------------------------------------------------------------------------
-- 	Check(s)
--------------------------------------------------------------------------------
--
WHENEVER SQLERROR EXIT
--
DECLARE
--
	l_dummy_c1 VARCHAR2(1);
--
BEGIN
--
-- 	Check that the user isn't sys or system
--
	IF USER IN ('SYS','SYSTEM')
	THEN
		RAISE_APPLICATION_ERROR(-20000,'You cannot install this product as ' || USER);
	END IF;
--
-- 	Check that HIG has been installed @ v4.7.0.x
--
	HIG2.PRODUCT_EXISTS_AT_VERSION  (p_product        => 'HIG'
                                        ,p_VERSION        => '4.7.0.0'
                                        );
--
-- 	Check that NET 4700 FIX 15 has already been applied
--
END;
/
WHENEVER SQLERROR CONTINUE
--
Prompt Update to error message

update nm_errors
set ner_descr = 'User does not have permission or access to all assets on the element'
where ner_id = 172
and ner_appl = 'NET'
/

Prompt Upgrades to admin-types to allow non-exclusivity

start NAT_EXCLUSIVE.SQL


Prompt Modifications to network policies

start drop_policies.sql

Prompt Modifications to package headers

start nm3ausec.pkh
start nm3job.pkh


Prompt Modifications to package bodies

Prompt nm3ausec....

start nm3ausec.pkw

Prompt invsec....

start invsec.pkw

prompt nm3inv_security....

start nm3inv_security.pkw

prompt nm3invval....

start nm3invval.pkw

prompt nm3job....

start nm3job.pkw

prompt nm3lock...

start nm3lock.pkw

prompt nm3nwval....

start nm3nwval.pkw

prompt nm3rsc....

start nm3rsc.pkw

Prompt Modifications to TRIGGERS

prompt nm_members_all_au_insert_check....

start nm_members_all_au_insert_check.trg

prompt nm_members_all_jobs_b_ins_upd....

start nm_members_all_jobs_b_ins_upd.trg

--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT log_nm_4700_fix31.sql
--
SET FEEDBACK ON
start log_nm_4700_fix31.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
--