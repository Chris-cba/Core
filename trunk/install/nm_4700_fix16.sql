--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix16.sql-arc   1.1   Apr 29 2015 14:23:46   Shivani.Gaind  $
--       Module Name      : $Workfile:   nm_4700_fix16.sql  $
--       Date into PVCS   : $Date:   Apr 29 2015 14:23:46  $
--       Date fetched Out : $Modtime:   Apr 29 2015 14:18:52  $
--       PVCS Version     : $Revision:   1.1  $
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
define logfile1='nm_4700_fix16_&log_extension'
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

---------------------------------------
--HIG_ALERT_TYPE_MAIL_LOOKUP
---------------------------------------
SET TERM ON 
PROMPT Creating table HIG_ALERT_TYPE_MAIL_LOOKUP.
SET TERM OFF

SET FEEDBACK ON
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 
		'CREATE TABLE  HIG_ALERT_TYPE_MAIL_LOOKUP
		( HATML_ID             NUMBER                    NOT NULL,
		  HATML_INV_TYPE       VARCHAR2(20)              NOT NULL,
		  HATML_SCREEN_TEXT    VARCHAR2(100)             NOT NULL,
		  HATML_QUERY          VARCHAR2(4000)            NOT NULL,
		  HATML_QUERY_COL      VARCHAR2(30)              NOT NULL,
		  HATML_DATE_CREATED   DATE                      NOT NULL,
		  HATML_CREATED_BY     VARCHAR2(30 BYTE)         NOT NULL,
		  HATML_DATE_MODIFIED  DATE                      NOT NULL,
		  HATML_MODIFIED_BY    VARCHAR2(30 BYTE)         NOT NULL
		  )';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

SET TERM ON 
PROMPT Creating UNIQUE KEY (hatml_pk) ON HIG_ALERT_TYPE_MAIL_LOOKUP.
SET TERM OFF

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX hatml_pk ON HIG_ALERT_TYPE_MAIL_LOOKUP(hatml_id)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

SET TERM ON 
PROMPT Creating primary key (hatml_pk) on HIG_ALERT_TYPE_MAIL_LOOKUP.
SET TERM OFF

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE HIG_ALERT_TYPE_MAIL_LOOKUP ADD CONSTRAINT hatml_pk PRIMARY KEY  (hatml_id)  USING INDEX hatml_pk';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
SET FEEDBACK OFF

---------------------------------------
--HIG_ALERT_TYPE_MAIL
---------------------------------------
SET TERM ON 
PROMPT Alter table HIG_ALERT_TYPE_MAIL
SET TERM OFF

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
  BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE HIG_ALERT_TYPE_MAIL  ADD ( 
                                             HATM_P1_DERIVED   	VARCHAR2(1),
                                             HATM_P2_DERIVED   	VARCHAR2(1),
                                             HATM_P3_DERIVED   	VARCHAR2(1),
                                             HATM_P4_DERIVED   	VARCHAR2(1),
                                             HATM_P5_DERIVED   	VARCHAR2(1),
                                             HATM_P6_DERIVED   	VARCHAR2(1),
                                             HATM_P7_DERIVED   	VARCHAR2(1),
                                             HATM_P8_DERIVED   	VARCHAR2(1),
                                             HATM_P9_DERIVED   	VARCHAR2(1),
                                             HATM_P10_DERIVED  	VARCHAR2(1),
                                             HATM_P11_DERIVED	VARCHAR2(1),
                                             HATM_P12_DERIVED	VARCHAR2(1),
                                             HATM_P13_DERIVED	VARCHAR2(1),
                                             HATM_P14_DERIVED	VARCHAR2(1),
                                             HATM_P15_DERIVED	VARCHAR2(1),
                                             HATM_P16_DERIVED	VARCHAR2(1),
                                             HATM_P17_DERIVED	VARCHAR2(1),
                                             HATM_P18_DERIVED	VARCHAR2(1),
                                             HATM_P19_DERIVED	VARCHAR2(1),
                                             HATM_P20_DERIVED	VARCHAR2(1),
                                             HATM_PARAM_11    	VARCHAR2(500),
                                             HATM_PARAM_12    	VARCHAR2(500),
                                             HATM_PARAM_13    	VARCHAR2(500),
                                             HATM_PARAM_14    	VARCHAR2(500),
                                             HATM_PARAM_15    	VARCHAR2(500),
                                             HATM_PARAM_16    	VARCHAR2(500),
                                             HATM_PARAM_17    	VARCHAR2(500),
                                             HATM_PARAM_18    	VARCHAR2(500),
                                             HATM_PARAM_19    	VARCHAR2(500),
                                             HATM_PARAM_20    	VARCHAR2(500))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
--------------------------------------------------------------------------------
-- Package Header hig_alert
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating package header hig_alert
SET TERM OFF
--
SET FEEDBACK ON
start hig_alert.pkh
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Package Body hig_alert
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating package body hig_alert
SET TERM OFF
--
SET FEEDBACK ON
start hig_alert.pkw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- HIG_ALERT_RECIPIENTS_A_INS
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Update Trigger hig_alert_recipients_a_ins
SET TERM OFF
--
SET FEEDBACK ON
start hig_alert_recipients_a_ins.trg
SET FEEDBACK OFF


COMMIT;
--
--------------------------------------------------------------------------------
-- Who Triggers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Calling Who_Trg.sql
SET TERM OFF

SET FEEDBACK ON
start who_trg.sql
SET FEEDBACK OFF


/
--
--------------------------------------------------------------------------------
-- Create Synonyms
--------------------------------------------------------------------------------
--

SET TERM ON
Prompt Creating Synonyms
SET TERM OFF
--
Begin
  Nm3Ddl.Refresh_All_Synonyms;
End;
/


-----------------------------------------
--Regenerate Triggers on existing alerts
-----------------------------------------
SET TERM ON 
PROMPT Regenerate Triggers
SET TERM OFF

DECLARE
    l_trg_status     VARCHAR2(4000);
    l_error_text     VARCHAR2(4000);
    l_drop_trg       BOOLEAN;
    l_create_trg     BOOLEAN;
    CURSOR c_alert_type IS
        SELECT halt_id, halt_trigger_name, do.status 
        FROM hig_alert_types halt, dba_triggers dt ,dba_objects do
        WHERE dt.trigger_name = halt.halt_trigger_name
        and dt.trigger_name = do.object_name and UPPER(do.object_type) = 'TRIGGER';
    type lt_halt is table of c_alert_type%ROWTYPE index by binary_integer;      
    t_alert      lt_halt;
    t_alert1      lt_halt;
BEGIN
    dbms_output.put_line('Status of Triggers on existing Alerts');
    OPEN C_alert_type;
    FETCH C_alert_type BULK COLLECT INTO t_alert;
    CLOSE C_alert_type;
    FOR i IN 1..t_alert.COUNT    LOOP
        l_trg_status := hig_alert.get_trigger_status(t_alert(i).halt_trigger_name);
        DBMS_OUTPUT.PUT_LINE(t_alert(i).halt_trigger_name ||' : '||t_alert(i).STATUS);
    END LOOP;    
    FOR i IN 1..t_alert.COUNT
    LOOP
      l_drop_trg := hig_alert.drop_trigger(t_alert(i).halt_id,t_alert(i).halt_trigger_name,l_error_text);
      l_create_trg := hig_alert.create_trigger(t_alert(i).halt_id,l_error_text);
    END LOOP;
    dbms_output.put_line(' ');
    dbms_output.put_line('Triggers ReGenerated: ');
    OPEN C_alert_type;
    FETCH C_alert_type BULK COLLECT INTO t_alert1;
    CLOSE C_alert_type;
    FOR i IN 1..t_alert1.COUNT
    LOOP
        l_trg_status := hig_alert.get_trigger_status(t_alert1(i).halt_trigger_name);
        DBMS_OUTPUT.PUT_LINE(t_alert1(i).halt_trigger_name||' : '||t_alert1(i).STATUS);
    END LOOP;    
    dbms_output.put_line('Finished ReGeneration');
EXCEPTION
  WHEN others THEN
    NULL;    
END;
/
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4700_fix16.sql 
--
SET FEEDBACK ON
start log_nm_4700_fix16.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
COMMIT;
--
SET FEEDBACK ON