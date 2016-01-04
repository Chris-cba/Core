--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix31.sql-arc   1.7   Dec 21 2015 16:38:14   Rob.Coupe  $
--       Module Name      : $Workfile:   nm_4700_fix31.sql  $ 
--       Date into PVCS   : $Date:   Dec 21 2015 16:38:14  $
--       Date fetched Out : $Modtime:   Dec 21 2015 16:38:30  $
--       PVCS Version     : $Revision:   1.7  $
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
DEFINE logfile1='nm_4700_fix31_part1_&log_extension'
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
--
END;
/

DECLARE
FUNCTION check_lstner RETURN boolean IS
  l_lsnr_count number;
  table_locked EXCEPTION;
  PRAGMA EXCEPTION_INIT( table_locked, -54 );
    lock_alert number;
  BEGIN
  SAVEPOINT lstner;
  LOCK TABLE exor_lock IN EXCLUSIVE MODE NOWAIT;
  ROLLBACK TO SAVEPOINT lstner;
  RETURN FALSE;
EXCEPTION
  WHEN table_locked THEN
   ROLLBACK TO SAVEPOINT lstner;
     RETURN TRUE;
  END;

BEGIN
  IF check_lstner THEN
    dbms_output.put_line(chr(10));
    dbms_output.put_line('***************************************************************************************************');
    dbms_output.put_line('CAUTION: Exor Listeners are currently running - executing compile_all.sql could result in deadlock');
    dbms_output.put_line('***************************************************************************************************');	
  END IF;

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


Prompt Recompiling.....

spool off;

start fix31_compile

set head on
set feed on
set pages 24
set lines 132
set verify OFF
set termout on

start compile_all.sql

DEFINE logfile2='nm_4700_fix31_part2_&log_extension'
SPOOL &logfile2

Prompt New views to support access rules

Prompt v_nm_user_inv_mode....

start v_nm_user_inv_mode.vw

Prompt v_nm_user_au_mode....

start v_nm_user_au_mode.vw


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

prompt nm3recal....

start nm3recal.pkw

prompt mapviewer....

start mapviewer.pkw

prompt nm3undo....

start nm3undo.pkw

prompt nm3close....

start nm3close.pkw

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