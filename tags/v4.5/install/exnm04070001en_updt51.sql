--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/lb/install/exnm04070001en_updt51.sql-arc   1.0   Jan 11 2017 22:44:34   Rob.Coupe  $
--       Module Name      : $Workfile:   exnm04070001en_updt51.sql  $ 
--       Date into PVCS   : $Date:   Jan 11 2017 22:44:34  $
--       Date fetched Out : $Modtime:   Jan 11 2017 22:43:56  $
--       PVCS Version     : $Revision:   1.0  $
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
DEFINE logfile1='nm_4700_fix51_&log_extension'
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
  Where   Hpr_Product = 'LB' ;  
  
  update Hig_Products
  set hpr_version = '4.5'
  Where Hpr_product = 'LB';
  
--
--  RAISE_APPLICATION_ERROR(-20000,'Please install NM 4700 Fix 32 before proceeding.');
--
  Exception 
    When No_Data_Found
    Then
  Declare
    lb_get_version varchar2(20);
  BEGIN
    SELECT lb_get.get_version into lb_get_version from dual;
--    if lb_get_version = '1.6' then
--  LB is installed, add the product code
      begin
	    insert into hig_products ( hpr_product, hpr_product_name, hpr_version, hpr_key, hpr_sequence )
        values ('LB', 'Location Bridge', '4.5', '76', 99);  
      exception
	    when dup_val_on_index then
		  update hig_products set hpr_version = '4.5' where hpr_product = 'LB';
      end;
--    else
--      raise_application_error( -20001, 'LB packages are at an incorrect state for this upgrade');
--    end if; 
--  
  Exception
    when no_data_found then
      raise_application_error( -20002, 'LB has not been installed, please install prior to upgrade');
    when others then
      raise_application_error( -20003, 'There seems a problem with the LB code, please re-compile prior to ruuning this upgrade '||sqlerrm);
  end;
  
End;
/

WHENEVER SQLERROR CONTINUE
--
prompt adjustment to asset-geometry index

alter table nm_asset_geometry_all
drop constraint nag_uk;

drop index NAG_ASSET_IDX;

CREATE UNIQUE INDEX NAG_ASSET_IDX ON NM_ASSET_GEOMETRY_ALL
(NAG_ASSET_ID, NAG_OBJ_TYPE, NAG_START_DATE, NAG_LOCATION_TYPE, NAG_END_DATE);


alter table nm_asset_geometry_all
add  CONSTRAINT NAG_UK
  UNIQUE (NAG_ASSET_ID, NAG_OBJ_TYPE, NAG_START_DATE, NAG_LOCATION_TYPE, NAG_END_DATE)
  USING INDEX NAG_ASSET_IDX;

prompt  Table for network edit transactions

CREATE TABLE LB_ELEMENT_HISTORY
(
  TRANSACTION_ID        INTEGER                 NOT NULL,
  NEH_ID                INTEGER,
  PRIOR_TRANSACTION_ID  INTEGER
)
/

ALTER TABLE LB_ELEMENT_HISTORY ADD 
CONSTRAINT lb_trans_neh_fk
 FOREIGN KEY (NEH_ID)
 REFERENCES NM_ELEMENT_HISTORY (NEH_ID)
 ENABLE
 VALIDATE
/

CREATE INDEX lb_trans_idx1 ON LB_ELEMENT_HISTORY
(TRANSACTION_ID, NEH_ID);

CREATE INDEX lb_trans_idx2 ON LB_ELEMENT_HISTORY
(NEH_ID);

CREATE INDEX lb_trans_idx3 ON LB_ELEMENT_HISTORY
(PRIOR_TRANSACTION_ID, TRANSACTION_ID);


prompt  Types...

CREATE OR REPLACE TYPE lb_edit_transaction as object
( t_edit_id integer, t_old_ne integer, t_new_ne integer, t_op varchar2(1), t_date date, t_old_len number, t_new_len number, t_p1 integer, t_p2 integer, t_id integer, prior_t_id integer )
/

CREATE OR REPLACE TYPE lb_edit_transaction_tab as table of lb_edit_transaction
/


prompt  Views...

start .\admin\eB_Interface\v_network_types.sql

start .\admin\views\views.sql


insert into lb_objects(object_name, object_type)
select 'V_LB_TYPE_NW_FLAGS', 'VIEW' from dual
where not exists ( select 1 from lb_objects where object_name = 'V_LB_TYPE_NW_FLAGS' and object_type = 'VIEW') ;

prompt  Package Headers ...

prompt package lb_ref.pkh

start .\admin\pck\lb_ref.pkh;

prompt package lb_ops.pkh

start .\admin\pck\lb_ops.pkh;

prompt package lb_reg.pkh

start .\admin\pck\lb_reg.pkh;

prompt package lb_get.pkh

start .\admin\pck\lb_get.pkh;

prompt package lb_load.pkh

start .\admin\pck\lb_load.pkh;

prompt package lb_loc.pkh

start .\admin\pck\lb_loc.pkh;

prompt package lb_nw_edit.pkh

start .\admin\pck\lb_nw_edit.pkh;


--
prompt Package Bodies ...

prompt package lb_ref.pkb

start .\admin\pck\lb_ref.pkb;

prompt package lb_ops.pkb

start .\admin\pck\lb_ops.pkb;

prompt package lb_reg.pkb

start .\admin\pck\lb_reg.pkb;

prompt package lb_get.pkb

start .\admin\pck\lb_get.pkb;

prompt package lb_load.pkb

start .\admin\pck\lb_load.pkb;

prompt package lb_loc.pkb

start .\admin\pck\lb_loc.pkb;

prompt package lb_nw_edit.pkb

start .\admin\pck\lb_nw_edit.pkb;


--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT Logging the upgrade - log_nm_4700_fix51.sql
--
SET FEEDBACK ON
start log_nm_4700_fix51.sql
SET FEEDBACK OFF
SPOOL OFF

EXIT;
--