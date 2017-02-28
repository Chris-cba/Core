----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4500_fix51.sql-arc   1.0   Feb 28 2017 16:26:20   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4500_fix51.sql  $ 
--       Date into PVCS   : $Date:   Feb 28 2017 16:26:20  $
--       Date fetched Out : $Modtime:   Jul 20 2016 12:05:54  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
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
DEFINE logfile1='nm_4500_fix51_&log_extension'
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
 -- Check that NET has been installed @ v4.5.0.0
 --
 hig2.product_exists_at_version (p_product        => 'NET'
                                ,p_VERSION        => '4.5.0.0'
                                );

END;
/
WHENEVER SQLERROR CONTINUE
--
--------------------------------------------------------------------------------
-- View Definitions
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating View v_nm_ordered_members.vw
SET TERM OFF
--
SET FEEDBACK ON
START v_nm_ordered_members.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating View v_nm_route_view.vw
SET TERM OFF
--
SET FEEDBACK ON
START v_nm_route_view.vw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Package Headers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating Package Header nm3undo.pkh
SET TERM OFF
--
SET FEEDBACK ON
START nm3undo.pkh
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating Package Body nm3asset.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3asset.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body nm3close.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3close.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body nm3homo.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3homo.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body nm3inv_load.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3inv_load.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body nm3rsc.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3rsc.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body nm3undo.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3undo.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body nm3wrap.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3wrap.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Add check constraint to NM_MEMBERS_ALL
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Adding check constraint to NM_MEMBERS_ALL
SET TERM OFF

DECLARE
  --
  CURSOR c1 IS
  SELECT nm_ne_id_in,
         nm_ne_id_of,
         nm_begin_mp,
         nm_start_date,
         nm_end_mp
    FROM nm_members_all
   WHERE nm_begin_mp > nm_end_mp;
  --
BEGIN
  --
  -- Disable all the triggers on NM_MEMBERS_ALL prior to the update and creation of check constraint
  EXECUTE IMMEDIATE 'ALTER TABLE nm_members_all DISABLE ALL TRIGGERS';
  
  -- Reverse nm_begin_mp and nm_end_mp where nm_begin_mp > nm_end_mp
  FOR l_rec IN c1 LOOP
  
     update nm_members_all
     set nm_end_mp = l_rec.nm_begin_mp,
         nm_begin_mp = l_rec.nm_end_mp
     where nm_ne_id_in = l_rec.nm_ne_id_in
       and nm_ne_id_of = l_rec.nm_ne_id_of
       and nm_begin_mp = l_rec.nm_begin_mp
       and nm_start_date = l_rec.nm_start_date;
     
  END LOOP;
  
  -- Create Check Constraint to enforce nm_begin_mp <= nm_end_mp
  DECLARE
    already_exists EXCEPTION;
    PRAGMA exception_init( already_exists,-02264);
  BEGIN    
    EXECUTE IMMEDIATE 'ALTER TABLE NM_MEMBERS_ALL ADD  '||CHR(10)||
                      'CONSTRAINT NM_BEGIN_MP_CHK      '||CHR(10)||
                      'CHECK (NM_BEGIN_MP <= NM_END_MP)';
                      
  EXCEPTION 
    WHEN already_exists THEN
      NULL;
    WHEN OTHERS THEN
      RAISE;
   END;
   
  --Re-enable all the triggers on NM_MEMBERS_ALL
  EXECUTE IMMEDIATE 'ALTER TABLE nm_members_all ENABLE ALL TRIGGERS';
  
END;
/

--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4500_fix51.sql
SET TERM OFF
--
SET FEEDBACK ON
START log_nm_4500_fix51.sql
SET FEEDBACK OFF
--
SPOOL OFF
--
EXIT
--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************
---------------------------------------------------------------------------------------------------
--
