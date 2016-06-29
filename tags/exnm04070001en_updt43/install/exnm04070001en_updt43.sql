--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/exnm04070001en_updt43.sql-arc   1.1   Jun 29 2016 15:53:34   Rob.Coupe  $
--       Module Name      : $Workfile:   exnm04070001en_updt43.sql  $ 
--       Date into PVCS   : $Date:   Jun 29 2016 15:53:34  $
--       Date fetched Out : $Modtime:   Jun 29 2016 15:53:34  $
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
DEFINE logfile1='nm_4700_fix43_&log_extension'
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
                WHERE hup_product = 'NET' AND remarks = 'NET 4700 FIX 37')
       AND  EXISTS
              (SELECT 1
                 FROM hig_upgrades
                WHERE hup_product = 'NET' AND remarks = 'NET 4700 FIX 21');
				
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
		RAISE_APPLICATION_ERROR(-20001, 'NET 4700 FIX 21 and 37 must be applied before proceeding - contact exor support for further information');
	END IF;

--
END;
/

WHENEVER SQLERROR CONTINUE
--


-- Installation of code to aggregate asset geometry
prompt Data Definition, indexes, synonyms and metadata

start aggregated_geometry_ddl.sql;

prompt Package header and body

start nm_inv_sdo_aggr.pkh;

start nm_inv_sdo_aggr.pkw;

prompt Modifications to package bodies

start nm3close.pkw;

start nm3homo.pkw;

start nm3sdm.pkw;

prompt Synonyms

begin
  NM3DDL.CREATE_SYNONYM_FOR_OBJECT('NM_INV_GEOMETRY_ALL');
  NM3DDL.CREATE_SYNONYM_FOR_OBJECT('NM_INV_GEOMETRY');
  NM3DDL.CREATE_SYNONYM_FOR_OBJECT('NM_INV_SDO_AGGR');
  NM3DDL.CREATE_SYNONYM_FOR_OBJECT('NM_INV_AGGR_SDO_TYPES');
end;
/

--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT log_nm_4700_fix43.sql
--
SET FEEDBACK ON
start log_nm_4700_fix43.sql
SET FEEDBACK OFF
SPOOL OFF

EXIT
--