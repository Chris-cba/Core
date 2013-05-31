--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4600_fix2.sql-arc   1.0   May 31 2013 08:44:42   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4600_fix2.sql  $
--       Date into PVCS   : $Date:   May 31 2013 08:44:42  $
--       Date fetched Out : $Modtime:   Jan 08 2013 16:06:56  $
--       PVCS Version     : $Revision:   1.0  $
--
----------------------------------------------------------------------------
--   Copyright (c) 2012 Bentley Systems Incorporated.
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
define logfile1='nm_4600_fix1_&log_extension'
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
--
--------------------------------------------------------------------------------
-- DDL Upgrade to DOC_STD_ACTIONS and DOC_REDIR_PRIOR
--------------------------------------------------------------------------------
PROMPT Addition of Admin Unit column to DOC_REDIR_PRIOR
SET TERM OFF

DECLARE
  --
  already_exists EXCEPTION;
  PRAGMA exception_init( already_exists,-01430); 
  --
  lv_top_admin_unit hig_admin_units.hau_admin_unit%TYPE;
  --
  PROCEDURE get_top_admin_unit
    IS
  BEGIN
    SELECT hau_admin_unit
      INTO lv_top_admin_unit
      FROM hig_admin_units
     WHERE hau_level = 1
         ;
  EXCEPTION
    WHEN no_data_found
     THEN
        raise_application_error(-20001,'Cannot find the top admin unit.');
    WHEN others
     THEN RAISE;
  END;
BEGIN
  /*
  ||Add the Admin Unit Column.
  */
  EXECUTE IMMEDIATE('ALTER TABLE doc_redir_prior ADD(drp_admin_unit NUMBER(9))');
  /*
  ||Populate existing rows with the top Admin Unit;
  */
  get_top_admin_unit;
  --
  EXECUTE IMMEDIATE('UPDATE doc_redir_prior SET drp_admin_unit = :lv_top_admin_unit') USING lv_top_admin_unit;
  /*
  ||Make the column NOT NULL.
  */
  EXECUTE IMMEDIATE('ALTER TABLE doc_redir_prior MODIFY(drp_admin_unit NOT NULL)');
  /*
  ||Create FK for Admin Unit.
  */
  EXECUTE IMMEDIATE('CREATE INDEX drp_fk_nau_ind ON doc_redir_prior (drp_admin_unit)');
  EXECUTE IMMEDIATE('ALTER TABLE doc_redir_prior ADD (CONSTRAINT drp_fk_nau FOREIGN KEY (drp_admin_unit) REFERENCES nm_admin_units_all (nau_admin_unit))');
END;
/

------------------------------------------------------------------
SET TERM ON
PROMPT Addition of Admin Unit column to DOC_STD_ACTIONS
SET TERM OFF

DECLARE
  --
  already_exists EXCEPTION;
  PRAGMA exception_init( already_exists,-01430); 
  --
  lv_top_admin_unit hig_admin_units.hau_admin_unit%TYPE;
  --
  PROCEDURE get_top_admin_unit
    IS
  BEGIN
    SELECT hau_admin_unit
      INTO lv_top_admin_unit
      FROM hig_admin_units
     WHERE hau_level = 1
         ;
  EXCEPTION
    WHEN no_data_found
     THEN
        raise_application_error(-20001,'Cannot find the top admin unit.');
    WHEN others
     THEN RAISE;
  END;
BEGIN
  /*
  ||Add the Admin Unit Column.
  */
  EXECUTE IMMEDIATE('ALTER TABLE doc_std_actions ADD(dsa_admin_unit NUMBER(9))');
  /*
  ||Populate existing rows with the top Admin Unit;
  */
  get_top_admin_unit;
  --
  EXECUTE IMMEDIATE('UPDATE doc_std_actions SET dsa_admin_unit = :lv_top_admin_unit') USING lv_top_admin_unit;
  /*
  ||Make the column NOT NULL.
  */
  EXECUTE IMMEDIATE('ALTER TABLE doc_std_actions MODIFY(dsa_admin_unit NOT NULL)');
  /*
  ||Rebuild the Unique Index.
  */
  EXECUTE IMMEDIATE('DROP INDEX dsa_ind1');
  EXECUTE IMMEDIATE('CREATE UNIQUE INDEX dsa_ind1 ON doc_std_actions (dsa_admin_unit, dsa_dtp_code, dsa_dcl_code, dsa_doc_status, dsa_doc_type, dsa_code)');
  /*
  ||Create FK for Admin Unit.
  */
  EXECUTE IMMEDIATE('CREATE INDEX dsa_fk_nau_ind ON doc_std_actions (dsa_admin_unit)');
  EXECUTE IMMEDIATE('ALTER TABLE doc_std_actions ADD (CONSTRAINT dsa_fk_nau FOREIGN KEY (dsa_admin_unit) REFERENCES nm_admin_units_all (nau_admin_unit))');
END;
/
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
SET TERM ON 
PROMPT nm3ins.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3ins.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT nm3debug.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3debug.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4600_fix2.sql 
--
SET FEEDBACK ON
start log_nm_4600_fix2.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
--