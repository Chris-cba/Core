--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix37.sql-arc   1.2   Jul 08 2016 13:02:12   Rob.Coupe  $
--       Module Name      : $Workfile:   nm_4700_fix37.sql  $ 
--       Date into PVCS   : $Date:   Jul 08 2016 13:02:12  $
--       Date fetched Out : $Modtime:   Jul 08 2016 13:01:32  $
--       PVCS Version     : $Revision:   1.2  $
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
DEFINE logfile1='nm_4700_fix37_&log_extension'
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

Declare
  n  Varchar2(1);
Begin
  Select  Null
  Into    n
  From    Hig_Products
  Where   Hpr_Product = 'NSG' 
     and  Hpr_Key is not NULL
     and  Not EXISTS
             ( select 1 from Hig_Upgrades
               Where   Hup_Product     =   'NET'
               And     From_Version    =   '4.7.0.1'
               And     Upgrade_Script  =   'exnm04070001en_updt32.sql'	
			   );
--
  RAISE_APPLICATION_ERROR(-20000,'Please install NM 4700 Fix 32 before proceding.');
--
  Exception 
  When No_Data_Found
Then
  NULL;
End;
/

Declare
  n  Varchar2(1);
Begin
  select Null into n
  From Hig_Products
  Where   Hpr_Product     =   'NET'
  And     Hpr_Key         is not NULL
  And     not exists ( select 1 from Hig_Upgrades
                       where hup_product = 'NET'
					   And     From_Version    in ( '4.7.0.1', '4.7.0.0')
                       And     Upgrade_Script  =   'log_nm_4700_fix31.sql'
					   );
  RAISE_APPLICATION_ERROR(-20000,'Please install NM 4700 Fix 31 before proceding.');
exception
  when no_data_found then
    NULL;
End;
/


WHENEVER SQLERROR CONTINUE
--

Prompt Modifications to package bodies

Prompt nm3close....

start nm3close.pkw

Prompt nm3undo....

start nm3undo.pkw


--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT log_nm_4700_fix37.sql
--
SET FEEDBACK ON
start log_nm_4700_fix37.sql
SET FEEDBACK OFF
SPOOL OFF

EXIT
--