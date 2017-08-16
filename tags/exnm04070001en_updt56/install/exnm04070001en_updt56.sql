--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/exnm04070001en_updt56.sql-arc   1.3   Aug 16 2017 09:24:48   Rob.Coupe  $
--       Module Name      : $Workfile:   exnm04070001en_updt56.sql  $ 
--       Date into PVCS   : $Date:   Aug 16 2017 09:24:48  $
--       Date fetched Out : $Modtime:   Aug 16 2017 09:24:24  $
--       PVCS Version     : $Revision:   1.3  $
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
DEFINE logfile1='nm_4700_fix56_&log_extension'
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
	l_dummy_c VARCHAR2(1);
--
	CURSOR c1 is
      SELECT 1
      FROM DUAL
      WHERE EXISTS
              (SELECT 1
                 FROM hig_upgrades
                WHERE hup_product = 'NET' AND remarks like 'NET 4700 FIX 45%')
      AND EXISTS 
              (SELECT 1
                 FROM hig_upgrades
                WHERE hup_product = 'NET' AND remarks like 'NET 4700 FIX 43%')   	  
      AND EXISTS 
              (SELECT 1
                 FROM hig_upgrades
                WHERE hup_product = 'NET' AND remarks like 'NET 4700 FIX 32%');
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
	OPEN  c1;
	FETCH c1 INTO l_dummy_c;
	CLOSE c1;
	--
	IF l_dummy_c IS NULL THEN
		RAISE_APPLICATION_ERROR(-20001, 'NET 4700 FIXES 32, 43 and 45 must be applied before proceeding - contact exor support for further information');
	END IF;
	
	if HIG.IS_PRODUCT_LICENSED('LB') then
	  declare
	  l_dummy integer;
	  begin
	     SELECT 1
	     into l_dummy
         FROM DUAL
         WHERE EXISTS
              (SELECT 1
                 FROM hig_upgrades
                WHERE hup_product = 'LB' AND remarks like 'NET 4700 FIX 55%');
--
      exception
         when no_data_found then
            RAISE_APPLICATION_ERROR(-20002, 'Location Bridge must be patched at least with NET fix 55 before proceeding - contact exor support for further information');
      end;  
    end if;           
--
END;
/

WHENEVER SQLERROR CONTINUE
--

Prompt Database changes ....

prompt Transaction_ID sequence

declare
  already_exists exception;
  pragma exception_init (already_exists, -955 );
begin
  execute immediate 'create sequence LB_TRANSACTION_ID_SEQ start with 1';
exception
  when already_exists then NULL;
end;
/

begin
NM3DDL.CREATE_SYNONYM_FOR_OBJECT('LB_TRANSACTION_ID_SEQ');
end;
/


prompt Package body

prompt nm3recal...
start nm3recal.pkw

prompt nm3merge...
start nm3merge.pkw

prompt nm3split...
start nm3split.pkw

prompt nm3replace...
start nm3replace.pkw

prompt nm3undo...
start nm3undo.pkw

prompt nm3close...
start nm3close.pkw

--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT log_nm_4700_fix56.sql
--
SET FEEDBACK ON
start log_nm_4700_fix56.sql
SET FEEDBACK OFF
SPOOL OFF

EXIT
--