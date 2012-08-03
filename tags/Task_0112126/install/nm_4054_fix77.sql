--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4054_fix77.sql-arc   1.0   Aug 03 2012 12:26:42   Rob.Coupe  $
--       Module Name      : $Workfile:   nm_4054_fix77.sql  $
--       Date into PVCS   : $Date:   Aug 03 2012 12:26:42  $
--       Date fetched Out : $Modtime:   Aug 03 2012 12:04:40  $
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
define logfile1='nm_4054_fix77_&log_extension'
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
 -- Check that HIG has been installed @ v4.0.5.4
 --
 hig2.product_exists_at_version (p_product        => 'HIG'
                                ,p_VERSION        => '4.0.5.4'
                                );

END;
/
WHENEVER SQLERROR CONTINUE
--
--
--------------------------------------------------------------------------------
-- DDL cattchup - originally included in 4054 fix 14
--------------------------------------------------------------------------------
--
-- First the original fix 14 addressed some limitations in the nm_inv_item_groupings_all table. The format of this table was correct as described
-- in a recent correspondence from support so this part of the upgrade has improved exception handling over and above the script that was supplied in fix 14.
-- All the SQL relating to NM_INV_ITEM_GROUPINGS_ALL can be commented out if it is in the correct state at the outset. 
--
SET TERM ON 
PROMPT DDL to reconfigure NM_INV_ITEM_GROUPINGS_ALL
SET TERM OFF

SET FEEDBACK ON

BEGIN
--
   DECLARE
     ex_not_exists exception;
     pragma exception_init(ex_not_exists,-02443);
   BEGIN
     EXECUTE IMMEDIATE('ALTER TABLE NM_INV_ITEM_GROUPINGS_ALL DROP CONSTRAINT IIG_UK');
   EXCEPTION
     WHEN ex_not_exists
     THEN
        NULL;
   END;

   DECLARE
     ex_not_exists exception;
     pragma exception_init(ex_not_exists,-02443);
   BEGIN
     EXECUTE IMMEDIATE('ALTER TABLE NM_INV_ITEM_GROUPINGS_ALL DROP CONSTRAINT IIG_PK');
   EXCEPTION
     WHEN ex_not_exists
     THEN
        NULL;
   END;

   DECLARE
     ex_not_exists exception;
     pragma exception_init(ex_not_exists,-01418);
   BEGIN
     EXECUTE IMMEDIATE('DROP INDEX  IIG_PK');
   EXCEPTION
     WHEN ex_not_exists
     THEN
        NULL;
   END;

   DECLARE
     ex_not_exists exception;
     pragma exception_init(ex_not_exists,-01418);
   BEGIN
     EXECUTE IMMEDIATE('DROP INDEX  IIG_UK');
   EXCEPTION
     WHEN ex_not_exists
     THEN
        NULL;
   END;

   DECLARE
     constraint_exists exception;
     pragma exception_init(constraint_exists,-02260);
   BEGIN
     EXECUTE IMMEDIATE('ALTER TABLE NM_INV_ITEM_GROUPINGS_ALL ADD (CONSTRAINT  IIG_PK PRIMARY KEY  ( IIG_ITEM_ID,IIG_PARENT_ID,IIG_START_DATE))');
   EXCEPTION
     WHEN constraint_exists
     THEN
        NULL;
   END;   

   DECLARE
     index_exists exception;
     pragma exception_init(index_exists,-00955);
   BEGIN
     EXECUTE IMMEDIATE('CREATE INDEX IIG_IIT_FK_TOP_ID_IND ON NM_INV_ITEM_GROUPINGS_ALL (IIG_TOP_ID)');
   EXCEPTION
     WHEN index_exists
     THEN
        NULL;
   END;   
END;

SET TERM ON 
PROMPT DDL to reconfigure NM_LOAD_BATCHES
SET TERM OFF

SET FEEDBACK ON

BEGIN

--
-- This is the critical piece of DDL that is missing from the prod environment and was present in the original fix 14.
-- The original foreign key from the batch status cannot be supported due to changes in the batch header.
-- Please note that the removal of this key will mean batch status records can proliferate as removal of batches
-- used to cascade the removal of the batch status. This will need to be addressed at some stage.
--
   
   DECLARE
     ex_not_exists exception;
     pragma exception_init(ex_not_exists,-02443);
   BEGIN
     EXECUTE IMMEDIATE('ALTER TABLE nm_load_batch_status DROP CONSTRAINT nlbs_nlb_fk');
   EXCEPTION
     WHEN ex_not_exists
     THEN
        NULL;
   END;

   DECLARE
     ex_not_exists exception;
     pragma exception_init(ex_not_exists,-02443);
   BEGIN
     EXECUTE IMMEDIATE('ALTER TABLE nm_load_batches DROP CONSTRAINT nlb_pk');
   EXCEPTION
     WHEN ex_not_exists
     THEN
        NULL;
   END;

   DECLARE
     ex_not_exists exception;
     pragma exception_init(ex_not_exists,-01418);
   BEGIN
     EXECUTE IMMEDIATE('DROP INDEX nlb_pk');
   EXCEPTION
     WHEN ex_not_exists
     THEN
        NULL;
   END; 

   DECLARE
     constraint_exists exception;
     pragma exception_init(constraint_exists,-02260);
   BEGIN
     EXECUTE IMMEDIATE('ALTER TABLE nm_load_batches ADD ( CONSTRAINT  nlb_pk  primary key  (nlb_batch_no,nlb_filename))');
   EXCEPTION
     WHEN constraint_exists
     THEN
        NULL;
   END; 
END;

SET FEEDBACK OFF

-- format of date modified must be consistent with file specification

SET TERM ON 
PROMPT Update Date Format for IIT_DATE_MODIFIED
SET TERM OFF

SET FEEDBACK ON

UPDATE nm_load_file_cols 
SET    NLFC_DATE_FORMAT_MASK = 'DDMMYYYY'
WHERE  nlfc_holding_col = 'IIT_DATE_MODIFIED'
/

SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Package Header
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3mapcapture_ins_inv.pkh
SET TERM OFF
--
SET FEEDBACK ON
start nm3mapcapture_ins_inv.pkh
SET FEEDBACK OFF
--  
--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3extent.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3extent.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT nm3homo.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3homo.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT nm3inv_update.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3inv_update.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT nm3load.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3load.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT nm3load_inv_failed.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3load_inv_failed.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT nm3lrs.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3lrs.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT nm3mapcapture_int.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3mapcapture_int.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT nm3pla.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3pla.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_nm_4054_fix77.sql 
--
SET FEEDBACK ON
start log_nm_4054_fix77.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--
--