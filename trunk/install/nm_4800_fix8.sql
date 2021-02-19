-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4800_fix8.sql-arc   1.0   Feb 19 2021 16:41:54   Barbara.Odriscoll  $
--       Date into PVCS   : $Date:   Feb 19 2021 16:41:54  $
--       Module Name      : $Workfile:   nm_4800_fix8.sql  $
--       Date fetched Out : $Modtime:   Feb 19 2021 16:40:42  $
--       Version          : $Revision:   1.0  $
--
-----------------------------------------------------------------------------------
-- Copyright (c) 2021 Bentley Systems Incorporated.  All rights reserved.
-----------------------------------------------------------------------------------
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
SELECT  TO_CHAR(SYSDATE, 'DDMONYYYY_HH24MISS') || '.LOG' log_extension FROM DUAL
/
SET TERM ON
--
--------------------------------------------------------------------------------
--
-- Spool to Logfile
--
DEFINE logfile1='nm_4800_fix8_&log_extension'
spool &logfile1
--
--------------------------------------------------------------------------------
--
SELECT 'Fix Date ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') FROM DUAL;

SELECT 'Install Running on ' || LOWER(USER || '@' || instance_name || '.' || host_name) || ' - DB ver : ' || version
FROM v$instance;
--
SELECT 'Current version of ' || hpr_product || ' ' || hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG', 'NET');
--
WHENEVER SQLERROR EXIT
--
BEGIN
 --
 -- Check that the user isn't SYS or SYSTEM
 --
 IF USER IN ('SYS', 'SYSTEM')
 THEN
	RAISE_APPLICATION_ERROR(-20000, 'You cannot install this product as ' || USER);
 END IF;
 --
 -- Check that NET has been installed @ v4.8.0.0
 --
 hig2.product_exists_at_version (p_product        => 'NET'
                                ,p_VERSION        => '4.8.0.0'
                                );

END;
/
--
--------------------------------------------------------------------------------
-- Package Headers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Package Header hig_alert
SET TERM OFF
--
SET FEEDBACK ON
start hig_alert.pkh
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Package Body hig_alert
SET TERM OFF
--
SET FEEDBACK ON
start hig_alert.pkw
SET FEEDBACK OFF
--
--
--------------------------------------------------------------------------------
-- Create HIG_ALERT_TYPE_CONDITIONS and HIG_QUERY_TYPE_ATTRIBUTES policies
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT Create HIG_ALERT Policies
SET TERM OFF

Declare
  Policy_Already_Exists Exception;
  Pragma Exception_Init(Policy_Already_Exists,-28101);
  n  number;
Begin

  Select  count(*)
  Into    n
  From    v$version
  Where   LOWER(banner) like '%enterprise%';
  
  IF n > 0 then
    BEGIN
     dbms_rls.add_policy
         (object_schema   => Sys_Context('NM3CORE','APPLICATION_OWNER')
         ,object_name     => 'HIG_ALERT_TYPE_CONDITIONS'
         ,policy_name     => 'HIG_ALERT_TYPE_CONDS_ADMIN'
         ,function_schema => Sys_Context('NM3CORE','APPLICATION_OWNER')
         ,policy_function => 'HIG_ALERT.HIG_ALERT_TYPE_CONDS_ADMIN'
         ,statement_types => 'INSERT,UPDATE,DELETE'
         ,update_check    => TRUE
         ,enable          => TRUE
         ,static_policy   => FALSE
         );
         
    Exception
      When Policy_Already_Exists Then
        null;
    END;    
    
    Begin
     dbms_rls.add_policy
         (object_schema   => Sys_Context('NM3CORE','APPLICATION_OWNER')
         ,object_name     => 'HIG_QUERY_TYPE_ATTRIBUTES'
         ,policy_name     => 'HIG_QUERY_TYPE_ATTRIBS_ADMIN'
         ,function_schema => Sys_Context('NM3CORE','APPLICATION_OWNER')
         ,policy_function => 'HIG_ALERT.HIG_QUERY_TYPE_ATTRIBS_ADMIN'
         ,statement_types => 'INSERT,UPDATE,DELETE'
         ,update_check    => TRUE
         ,enable          => TRUE
         ,static_policy   => FALSE
         );
    Exception
      When Policy_Already_Exists Then
        null;
    end;    
  END IF;         
End;
/
--
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Updating HIG_UPGRADES
SET TERM OFF
--
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4800_fix8.sql'
				,p_remarks        => 'NET 4800 FIX 8 (Build 1)'
				,p_to_version     => NULL
				);
	--
	COMMIT;
	--
EXCEPTION 
	WHEN OTHERS THEN
	--
		NULL;
	--
END;
/
COMMIT;
--

SPOOL OFF
--
EXIT
--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************
---------------------------------------------------------------------------------------------------
--
