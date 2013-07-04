------------------------------------------------------------------
-- nm40_nm4010_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm40_nm4010_ddl_upg.sql	1.2 04/13/07
--       Module Name      : nm40_nm4010_ddl_upg.sql
--       Date into SCCS   : 07/04/13 11:10:54
--       Date fetched Out : 07/06/13 13:59:19
--       SCCS Version     : 1.2
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------


------------------------------------------------------------------

------------------------------------------------------------------
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Check that appropriate database privs are granted to user
SET TERM OFF

-- GJ  03-APR-2007
-- 
-- DEVELOPMENT COMMENTS
-- Potentially someone could install 4.0 at on a clean 10g instance (even though it wasn't certified) and then attempt to upgrade to 4.0.1.0 - thinking that everything will just work...
--  
-- However if you've missed the required privs when installing using the 4.0 higowner script things could fall over.
-- 
-- This checks for that scenario
-- 
------------------------------------------------------------------
WHENEVER SQLERROR EXIT
declare
 l_dummy VARCHAR2(1) := Null;
begin

  select 'x'
  into l_dummy
  from dba_sys_privs
  where grantee = user
  and PRIVILEGE = 'SELECT ANY DICTIONARY';
  
 IF l_dummy IS NULL THEN
   RAISE no_data_found;
 END IF;
 
EXCEPTION
 WHEN others THEN
    RAISE_APPLICATION_ERROR(-20001,'Oracle privileges need to be granted to this user - run hig_sys_grants.sql as SYS and higowner_9i_privs.sql as SYSTEM');
  
END;
/
WHENEVER SQLERROR CONTINUE
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New FK constraint for NM_THEME_GTYPES
SET TERM OFF

-- GJ  03-APR-2007
-- 
-- DEVELOPMENT COMMENTS
-- New FK on NM_THEME_GTYPES requested by AE
-- First of all tidy up existing data
------------------------------------------------------------------
DECLARE
  CURSOR c1 IS
    SELECT nth_theme_id, Nm3sdo.get_theme_gtype( nth_theme_id ) ntg_gtype, 1 ntg_seq_no
    FROM NM_THEMES_ALL, user_objects
    WHERE NOT EXISTS ( SELECT 1 FROM NM_THEME_GTYPES
                   WHERE ntg_theme_id = nth_theme_id )
    AND Nm3sdo.get_theme_gtype(nth_theme_id) IS NOT NULL
    AND object_name = nth_feature_table
    AND nth_theme_type = 'SDO';
BEGIN

  DELETE FROM nm_theme_gtypes
  WHERE NOT EXISTS ( SELECT 1 FROM NM_THEMES_ALL
                     WHERE ntg_theme_id = nth_theme_id ); 

  FOR irec IN c1 LOOP
    INSERT INTO NM_THEME_GTYPES(
          ntg_theme_id, ntg_gtype, ntg_seq_no )
    VALUES ( irec.nth_theme_id, irec.ntg_gtype, irec.ntg_seq_no );
  END LOOP;
  COMMIT;
END;    
/
ALTER TABLE NM_THEME_GTYPES ADD (CONSTRAINT
 NTG_NTH_FK FOREIGN KEY 
  (NTG_THEME_ID) REFERENCES NM_THEMES_ALL
  (NTH_THEME_ID) ON DELETE CASCADE)
/



------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT 707912 DDL changes
SET TERM OFF

-- GJ  03-APR-2007
-- 
-- ASSOCIATED LOG#
-- 707912
-- 
-- CUSTOMER
-- Transport for London
-- 
-- PROBLEM
-- enhancement request on doc0150.   they wish to have two new fields to be added to form.  1. Date and time arrived on site.   2. reason for late arrival (text field).
-- 
-- DEVELOPMENT COMMENTS
-- The current practice for dealing with emergency calls within TfL is to pass the enquiry to the Term Maintenance Contractor (TMC) for actioning. 
-- The TMC's have certain Performance Indicators within their contract with TFL that relate to their effectiveness in responding to emergency calls.  
-- To measure their effectiveness TfL required the contractor to record the time they arrived on site and if late explain the reason.
-- To meet this requirement two additional attributes are needed.
-- 
------------------------------------------------------------------
declare
 ex_already_exists exception;
 pragma exception_init(ex_already_exists,-1430);
begin
 execute immediate('alter table docs add (doc_date_time_arrived DATE)');
exception
 when ex_already_exists then
   null;
 when others then
   raise_application_error(-20001,'DOC_DATE_TIME_ARRIVED not added to DOCS table'||chr(10)||sqlerrm); 
end;
/
declare
 ex_already_exists exception;
 pragma exception_init(ex_already_exists,-1430);
begin
 execute immediate('alter table docs add (doc_reason_for_later_arrival VARCHAR2(255))');
exception
 when ex_already_exists then
   null;
 when others then
   raise_application_error(-20001,'DOC_REASON_FOR_LATER_ARRIVAL not added to DOCS table'||chr(10)||sqlerrm); 
end;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Drop redundant XATRR validation trigger
SET TERM OFF

-- GJ  03-APR-2007
-- 
-- DEVELOPMENT COMMENTS
-- This trigger was shipped with the 4.0 NM3 release.
-- 
-- However, the tigger is one that is generated by an early version of the X-attr validation.
-- 
-- It should no-longer be shipped and it certainly should not be installed through either a fresh install or an upgrade.
-- 
------------------------------------------------------------------
drop trigger NM_INV_ITEMS_ALL_B_X_TRG
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Enable constraint gdobj_pk on gis_data_objects
SET TERM OFF

-- AE  03-APR-2007
-- 
-- DEVELOPMENT COMMENTS
-- Previously this constraint was shipped as DISABLED - which meant that no associated index existed.
-- 
------------------------------------------------------------------
TRUNCATE TABLE GIS_DATA_OBJECTS
/
alter table gis_data_objects enable constraint gdobj_pk
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Alter gis_data_objects gdo_pk_id to number no precision
SET TERM OFF

-- AE  03-APR-2007
-- 
-- DEVELOPMENT COMMENTS
-- Ensure GDO_PK_ID is large enough to handle Scheme shapes objectid.
------------------------------------------------------------------
alter table gis_data_objects
modify gdo_pk_id number
/

------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

