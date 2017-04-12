--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/exnm04070003en_updt55.sql-arc   1.0   Apr 12 2017 22:10:52   Rob.Coupe  $
--       Module Name      : $Workfile:   exnm04070003en_updt55.sql  $ 
--       Date into PVCS   : $Date:   Apr 12 2017 22:10:52  $
--       Date fetched Out : $Modtime:   Apr 12 2017 21:53:34  $
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
DEFINE logfile1='nm_4700_fix55_&log_extension'
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
  n  Varchar2(10);
Begin
  Select  hpr_version
  Into    n
  From    Hig_Products
  Where   Hpr_Product = 'LB' 
  and hpr_version in ('4.2', '4,3', '4.4', '4.5');  
  
  update Hig_Products
  set hpr_version = '4.6'
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
        values ('LB', 'Location Bridge', '4.6', '76', 99);  
      exception
	    when dup_val_on_index then
		  update hig_products set hpr_version = '4.6' where hpr_product = 'LB';
      end;
--    else
--      raise_application_error( -20001, 'LB packages are at an incorrect state for this upgrade');
--    end if; 
--  
  Exception
    when no_data_found then
      raise_application_error( -20002, 'LB has not been installed, please install prior to upgrade');
    when others then
      raise_application_error( -20003, 'There seems a problem with the LB code, please re-compile prior to running this upgrade '||sqlerrm);
  end;
  
End;
/

WHENEVER SQLERROR CONTINUE
--
prompt improved key structure on unit translation table

DECLARE
   already_exists   EXCEPTION;
   PRAGMA EXCEPTION_INIT (already_exists, -2261);
   dupl_found       EXCEPTION;
   PRAGMA EXCEPTION_INIT (dupl_found, -2299);
BEGIN
   EXECUTE IMMEDIATE
      'alter table lb_units add constraint lb_units_uk2 UNIQUE ( exor_unit_id) ';
EXCEPTION
   WHEN already_exists
   THEN
      NULL;
   WHEN dupl_found
   THEN
      raise_application_error (
         -20001,
         ' The LB_UNITS table has dulicate copies of an Exor unit ID. Please remove the duplicates prior to execution ');
END;
/

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

declare
already_exists exception;
pragma exception_init ( already_exists, -955 );
begin
   execute immediate 'CREATE TABLE LB_ELEMENT_HISTORY '||
                     ' ( '||
                     '   TRANSACTION_ID        INTEGER                 NOT NULL, '||
                     '  NEH_ID                INTEGER, '||
                     '   PRIOR_TRANSACTION_ID  INTEGER '||
                     ' ) ';
exception  
   when already_exists then NULL;
end;   
/

prompt constraints ....
declare
already_exists exception;
pragma exception_init ( already_exists, -2275 );
begin
   execute immediate 'ALTER TABLE LB_ELEMENT_HISTORY ADD  '||
                     '  CONSTRAINT lb_trans_neh_fk '||
                     ' FOREIGN KEY (NEH_ID) '||
                     ' REFERENCES NM_ELEMENT_HISTORY (NEH_ID) '||
                     ' ENABLE '||
                     ' VALIDATE ';
exception  
   when already_exists then NULL;
end;   
/

prompt indexes - lb_trans_idx1

declare
already_exists exception;
pragma exception_init ( already_exists, -955 );
begin
   execute immediate 'CREATE INDEX lb_trans_idx1 ON LB_ELEMENT_HISTORY '||
                     ' (TRANSACTION_ID, NEH_ID)';
					 exception  
   when already_exists then NULL;
end;   
/

prompt indexes - lb_trans_idx2

declare
already_exists exception;
pragma exception_init ( already_exists, -955 );
begin
   execute immediate 'CREATE INDEX lb_trans_idx2 ON LB_ELEMENT_HISTORY '||
                     ' (NEH_ID) ';
exception  
   when already_exists then NULL;
end;   
/

prompt indexes - lb_trans_idx3

declare
already_exists exception;
pragma exception_init ( already_exists, -955 );
begin
   execute immediate 'CREATE INDEX lb_trans_idx3 ON LB_ELEMENT_HISTORY '||
                     ' (PRIOR_TRANSACTION_ID, TRANSACTION_ID) ';
exception  
   when already_exists then NULL;
end;   
/


prompt  Types...
prompt lb_edit_transaction...


declare
l_dummy integer;
already_exists exception;
pragma exception_init ( already_exists, -2303 );
begin
   select 1 into l_dummy from user_types where type_name = 'LB_EDIT_TRANSACTION';
exception
   when no_data_found then
   execute immediate 'CREATE OR REPLACE TYPE lb_edit_transaction as object '||
                     ' ( t_edit_id integer, '||
					 '   t_old_ne integer,  '||
					 '   t_new_ne integer,  '||
					 '   t_op varchar2(1),  '||
					 '   t_date date,  '||
					 '   t_old_len number, '||
                     '   t_new_len number, '||
					 '   t_p1 integer, '||
					 '   t_p2 integer, '||
                     '   t_id integer, '||
					 '   prior_t_id integer ) ';
-- 
   when already_exists then NULL;
end;   
/

CREATE OR REPLACE TYPE lb_edit_transaction_tab as table of lb_edit_transaction
/

prompt Exor core change to the INT_ARRAY type

drop type INT_ARRAY FORCE;

start .\admin\typ\int_array.tyh;

start .\admin\typ\int_array.tyb;

------------------------------------------------object-name changes -------------------------------------

Prompt Change of name of objects

declare
   not_exists exception;
   pragma exception_init( not_exists, -4043);
   cursor c1 is      
      select type_name, typecode
      from dba_types
      where owner = sys_context('NM3CORE', 'APPLICATION_OWNER')
      and type_name in ( 'LINEAR_ELEMENT_TYPES', 'LINEAR_ELEMENT_TYPE', 'LINEAR_LOCATION', 'LINEAR_LOCATIONS' )
      order by typecode;
begin
   for irec in c1 loop
      begin
         execute immediate 'drop type '||irec.type_name||' FORCE';
      exception
	     when not_exists then NULL;
      end;
   end loop;
end;            
/

declare
l_dummy integer;
begin 
   select 1 into l_dummy from user_types where type_name = 'LB_LINEAR_LOCATION';
exception  
   when no_data_found then
      execute immediate 'CREATE OR REPLACE '||chr(13)||chr(10)
                      ||' TYPE LB_LINEAR_LOCATION AS OBJECT( '||chr(13)||chr(10)
                      ||'    AssetId             NUMBER(38),    -- ID of the linearly located asset '||chr(13)||chr(10)
                      ||'    AssetType           NUMBER(38),    -- Type of the asset '||chr(13)||chr(10)
                      ||'    LocationId          NUMBER(38),    -- ID of the linear location '||chr(13)||chr(10)
                      ||'    LocationDescription VARCHAR2(240), -- Linear location description '||chr(13)||chr(10)
                      ||'    NetworkTypeId       INTEGER,       -- Network element type '||chr(13)||chr(10)
                      ||'    NetworkElementId    INTEGER,       -- Network element ID '||chr(13)||chr(10)
                      ||'    StartM              NUMBER,        -- Absolute position of start of linear range '||chr(13)||chr(10)
                      ||'    EndM                NUMBER,        -- Optional absolute position of end of linear range '||chr(13)||chr(10)
                      ||'    Unit                INTEGER,       -- Exor ID of Units of start and end position '||chr(13)||chr(10)
                      ||'    NetworkElementName  VARCHAR2(30),  -- Network element unique name '||chr(13)||chr(10)
                      ||'    NetworkElementDescr VARCHAR2(240), -- Optional network element description '||chr(13)||chr(10)
                      ||'    JXP                 VARCHAR2(80)); -- Juxtaposition of owning linear location ';
end;            
/


declare
l_dummy integer;
begin 
   select 1 into l_dummy from user_types where type_name = 'LB_LINEAR_ELEMENT_TYPE';
exception  
   when no_data_found then
      execute immediate 'CREATE OR REPLACE '||chr(13)||chr(10)
                      ||'TYPE LB_LINEAR_ELEMENT_TYPE  AS OBJECT( '||chr(13)||chr(10)
                      ||'   linearlyLocatableType  NUMBER,        -- ID of a linearly locatable type '||chr(13)||chr(10)
                      ||'   linearElementTypeId    NUMBER,        -- ID of the linear element type '||chr(13)||chr(10)
                      ||'   linearElementTypeName  VARCHAR2(30),  -- Unique name of the linear element type '||chr(13)||chr(10)
                      ||'   linearElementTypeDescr VARCHAR2(80),  -- Optional description of the linear element type '||chr(13)||chr(10)
                      ||'   lengthUnit             VARCHAR2(20)); -- Default length unit ';
end;                      
/


CREATE OR REPLACE 
TYPE  LB_LINEAR_ELEMENT_TYPES AS TABLE OF lb_linear_element_type;
/


CREATE OR REPLACE 
TYPE LB_LINEAR_LOCATIONS AS TABLE OF lb_linear_location;
/

update lb_objects set object_name = 'LB_'||object_name where object_name in ( 'LINEAR_ELEMENT_TYPES', 'LINEAR_ELEMENT_TYPE', 'LINEAR_LOCATION', 'LINEAR_LOCATIONS' )
/

update lb_objects set object_name = 'LB_'||substr(object_name, 3) where object_name in ( 'L_LINEAR_ELEMENT_TYPES', 'L_LINEAR_ELEMENT_TYPE', 'L_LINEAR_LOCATION', 'L_LINEAR_LOCATIONS' )
/

prompt function changes after rename...

start .\admin\eB_Interface\GetAssetLinearLocationsTab.fnc

start .\admin\eB_Interface\GetLinearElementTypes.prc

start .\admin\eB_Interface\GetNetworkLinearLocationsTab.fnc

------------------------------------------------end of impact of object-name changes -------------------------------------

prompt  Views...

start .\admin\eB_Interface\v_network_types.sql

start .\admin\views\views.sql

start .\admin\views\v_nm_nlt_data.vw;

start .\admin\pck\create_nlt_geometry_view.prc;



begin
create_nlt_geometry_view;
end;
/


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

prompt package lb_path_reg.pkh

start .\admin\pck\lb_path_reg.pkh;

prompt package lb_path.pkh

start .\admin\pck\lb_path.pkh;



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

prompt package lb_path_reg.pkb

start .\admin\pck\lb_path_reg.pkb;

prompt package lb_path.pkb;

start .\admin\pck\lb_path.pkb;

insert into lb_objects (object_name, object_type )
values
( 'LB_NW_EDIT', 'PACKAGE');

insert into lb_objects (object_name, object_type )
values
( 'LB_NW_EDIT', 'PACKAGE BODY');

insert into lb_objects (object_name, object_type )
values
( 'LB_ELEMENT_HISTORY', 'TABLE');

insert into lb_objects (object_name, object_type )
values
( 'LB_EDIT_TRANSACTION', 'TYPE');

insert into lb_objects (object_name, object_type )
values
( 'LB_EDIT_TRANSACTION_TAB', 'TYPE');



--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT Logging the upgrade - log_nm_4700_fix55.sql
--
SET FEEDBACK ON

BEGIN
--
  hig2.upgrade(p_product        => 'LB'
              ,p_upgrade_script => 'log_nm_4700_fix55.sql'
              ,p_remarks        => 'NET 4700 FIX 55 Build 3 - LB version 4.6'
              ,p_to_version     => '4.6');
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/

SET FEEDBACK OFF
SPOOL OFF

EXIT;
--

