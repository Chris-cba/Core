------------------------------------------------------------------
-- nm4020_nm4040_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4020_nm4040_metadata_upg.sql-arc   3.5   Jul 04 2013 14:10:06   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4020_nm4040_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:10:06  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:20  $
--       Version          : $Revision:   3.5  $
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

------------------------------------------------------------------
DECLARE
  l_temp nm3type.max_varchar2;
BEGIN
  -- Dummy call to HIG to instantiate it
  l_temp := hig.get_version;
  l_temp := nm_debug.get_version;
EXCEPTION
  WHEN others
   THEN
 Null;
END;
/

BEGIN
  nm_debug.debug_off;
END;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New modules for Standard Text
SET TERM OFF

-- SSC  17-DEC-2007
-- 
-- DEVELOPMENT COMMENTS
-- Changes to hig_modules to include Standard Text modules:
-- HIG4010
-- Standard Text Maintenance
-- 
-- HIG4020
-- Standard Text Usage
-- 
-- HIG4025
-- My Standard Text Usuage (actually calls HIG4020 but acts differently)
-- 
-- HIG4030
-- Standard Text
------------------------------------------------------------------
Insert into HIG_MODULES (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS, 
                         HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
select 'HIG4010', 'Standard Text Maintenance', 'hig4010', 'FMX', NULL, 'N', 'N', 'HIG', 'FORM'
  from dual
 where not exists (select 1 from HIG_MODULES where HMO_MODULE = 'HIG4010');

Insert into HIG_MODULES (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS, 
                         HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
select 'HIG4020', 'Standard Text Usage', 'hig4020', 'FMX', NULL, 'N', 'N', 'HIG', 'FORM'
  from dual
 where not exists (select 1 from HIG_MODULES where HMO_MODULE = 'HIG4020');

Insert into HIG_MODULES (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS, 
                         HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
select 'HIG4025', 'My Standard Text Usuage', 'hig4020', 'FMX', NULL, 'N', 'N', 'HIG', 'FORM'
  from dual
 where not exists (select 1 from HIG_MODULES where HMO_MODULE = 'HIG4025');

Insert into HIG_MODULES (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS, 
                         HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
select 'HIG4030', 'Standard Text', 'hig4020', 'FMX', NULL, 'N', 'N', 'HIG', 'FORM'
  from dual
 where not exists (select 1 from HIG_MODULES where HMO_MODULE = 'HIG4030');

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New Module Roles for Standard Text
SET TERM OFF

-- SSC  17-DEC-2007
-- 
-- DEVELOPMENT COMMENTS
-- New modules added into hig_modules, these are the roles assigned to these modules:
-- HIG4010	HIG_ADMIN
-- HIG4020	HIG_ADMIN
-- HIG4025	HIG_USER
-- HIG4030	HIG_USER
------------------------------------------------------------------
Insert into HIG_MODULE_ROLES (HMR_MODULE, HMR_ROLE, HMR_MODE)
select 'HIG4010', 'HIG_ADMIN', 'NORMAL'
  from dual
 where not exists (select 1 from HIG_MODULE_ROLES where HMR_MODULE = 'HIG4010' and HMR_ROLE = 'HIG_ADMIN');

Insert into HIG_MODULE_ROLES (HMR_MODULE, HMR_ROLE, HMR_MODE)
select 'HIG4020', 'HIG_ADMIN', 'NORMAL'
  from dual
 where not exists (select 1 from HIG_MODULE_ROLES where HMR_MODULE = 'HIG4020' and HMR_ROLE = 'HIG_ADMIN');

Insert into HIG_MODULE_ROLES (HMR_MODULE, HMR_ROLE, HMR_MODE)
select 'HIG4025', 'HIG_USER', 'NORMAL'
  from dual
 where not exists (select 1 from HIG_MODULE_ROLES where HMR_MODULE = 'HIG4025' and HMR_ROLE = 'HIG_USER');

Insert into HIG_MODULE_ROLES (HMR_MODULE, HMR_ROLE, HMR_MODE)
select 'HIG4030', 'HIG_USER', 'NORMAL'
  from dual
 where not exists (select 1 from HIG_MODULE_ROLES where HMR_MODULE = 'HIG4030' and HMR_ROLE = 'HIG_USER');
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT TMA and NSG Hig_standard_favourites
SET TERM OFF

-- SSC  14-DEC-2007
-- 
-- DEVELOPMENT COMMENTS
-- Added hig_standard_favourites data for TMA product and additional module for NSG (Organisations and Districts, module number NSG0110)
-- For relative install metadata see nm3data2.sql delta 2.10
------------------------------------------------------------------
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'FAVOURITES', 'TMA', 'TMA', 'F', 16
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'FAVOURITES'
                        and HSTF_CHILD = 'TMA' );

Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'HIG_REFERENCE', 'HIG4010', 'Standard Text Maintenance', 'M', 19
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'HIG_REFERENCE'
                        and HSTF_CHILD = 'HIG4010' );

Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'HIG_REFERENCE', 'HIG4020', 'Standard Text Usage', 'M', 20
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'HIG_REFERENCE'
                        and HSTF_CHILD = 'HIG4020' );

INSERT INTO HIG_STANDARD_FAVOURITES
   (HSTF_PARENT ,HSTF_CHILD ,HSTF_DESCR ,HSTF_TYPE ,HSTF_ORDER)
SELECT 'HIG_REFERENCE','HIG4025','My Standard Text Usage','M',21 
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE'
                    AND  HSTF_CHILD = 'HIG4025');

Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_DATA_BATCH_PROCESSING', 'TMA_DATA_BATCH_PROCESSING_INSP', 'Inspections', 'F', 10
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_DATA_BATCH_PROCESSING'
                        and HSTF_CHILD = 'TMA_DATA_BATCH_PROCESSING_INSP' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_DATA_BATCH_PROCESSING_INSP', 'TMA5500', 'Inspection Download', 'M', 10
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_DATA_BATCH_PROCESSING_INSP'
                        and HSTF_CHILD = 'TMA5500' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_DATA_BATCH_PROCESSING_INSP', 'TMA5510', 'Inspections Batch File Summary', 'M', 60
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_DATA_BATCH_PROCESSING_INSP'
                        and HSTF_CHILD = 'TMA5510' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_DATA_BATCH_PROCESSING_INSP', 'TMA5520', 'Inspection Download to DCD', 'M', 20
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_DATA_BATCH_PROCESSING_INSP'
                        and HSTF_CHILD = 'TMA5520' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_DATA_BATCH_PROCESSING_INSP', 'TMA5530', 'Automatic Inspection Download to DCD', 'M', 30
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_DATA_BATCH_PROCESSING_INSP'
                        and HSTF_CHILD = 'TMA5530' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_DATA_BATCH_PROCESSING_INSP', 'TMA5600', 'Inspection Upload', 'M', 40
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_DATA_BATCH_PROCESSING_INSP'
                        and HSTF_CHILD = 'TMA5600' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_DATA_BATCH_PROCESSING_INSP', 'TMA5610', 'Automatic Inspection Upload', 'M', 50
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_DATA_BATCH_PROCESSING_INSP'
                        and HSTF_CHILD = 'TMA5610' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_DATA_BATCH_PROCESSING_INSP', 'TMA5620', 'Inspections Upload Transaction Summary', 'M', 70
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_DATA_BATCH_PROCESSING_INSP'
                        and HSTF_CHILD = 'TMA5620' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACT_WORKS', 'TMA1005', 'View Archived Works/Sites', 'M', 15
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACT_WORKS'
                        and HSTF_CHILD = 'TMA1005' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_REF_ACTIVITIES', 'TMA2050', 'Notice Warnings', 'M', 60
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_REF_ACTIVITIES'
                        and HSTF_CHILD = 'TMA2050' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'NSG_DATA', 'NSG0110', 'Organisations and Districts', 'M', 25
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'NSG_DATA'
                        and HSTF_CHILD = 'NSG0110' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA', 'TMA_ACTIVITIES', 'Activities', 'F', 10
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA'
                        and HSTF_CHILD = 'TMA_ACTIVITIES' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA', 'TMA_INSPECTIONS', 'Inspections', 'F', 20
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA'
                        and HSTF_CHILD = 'TMA_INSPECTIONS' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA', 'TMA_DATA_EXCHANGE', 'Data Exchange', 'F', 30
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA'
                        and HSTF_CHILD = 'TMA_DATA_EXCHANGE' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA', 'TMA_REFERENCE_DATA', 'Reference Data', 'F', 40
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA'
                        and HSTF_CHILD = 'TMA_REFERENCE_DATA' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACTIVITIES', 'TMA_ACT_WORKS', 'Works', 'F', 10
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACTIVITIES'
                        and HSTF_CHILD = 'TMA_ACT_WORKS' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACTIVITIES', 'TMA_ACT_OTHER_ACTIVITIES', 'Other Activities', 'F', 20
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACTIVITIES'
                        and HSTF_CHILD = 'TMA_ACT_OTHER_ACTIVITIES' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACTIVITIES', 'TMA_ACT_RESTRICTIONS', 'Restrictions', 'F', 30
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACTIVITIES'
                        and HSTF_CHILD = 'TMA_ACT_RESTRICTIONS' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACTIVITIES', 'TMA_ACT_FINANCIAL', 'Financial', 'F', 40
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACTIVITIES'
                        and HSTF_CHILD = 'TMA_ACT_FINANCIAL' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACTIVITIES', 'TMA_ACT_ADMINISTRATION', 'Administration', 'F', 50
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACTIVITIES'
                        and HSTF_CHILD = 'TMA_ACT_ADMINISTRATION' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACTIVITIES', 'TMA_ACT_REPORTS', 'Reports', 'F', 60
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACTIVITIES'
                        and HSTF_CHILD = 'TMA_ACT_REPORTS' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACT_ADMINISTRATION', 'TMA1130', 'Merge Unattributable Works', 'M', 10
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACT_ADMINISTRATION'
                        and HSTF_CHILD = 'TMA1130' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACT_ADMINISTRATION', 'TMA1140', 'Allocate Provisional Works', 'M', 20
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACT_ADMINISTRATION'
                        and HSTF_CHILD = 'TMA1140' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACT_FINANCIAL', 'TMA1080', 'S74 Charges', 'M', 10
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACT_FINANCIAL'
                        and HSTF_CHILD = 'TMA1080' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACT_FINANCIAL', 'TMA1090', 'Informal Works Overrun', 'M', 20
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACT_FINANCIAL'
                        and HSTF_CHILD = 'TMA1090' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACT_FINANCIAL', 'TMA1100', 'FPNs', 'M', 30
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACT_FINANCIAL'
                        and HSTF_CHILD = 'TMA1100' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACT_OTHER_ACTIVITIES', 'TMA1120', 'Licenced Works', 'M', 10
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACT_OTHER_ACTIVITIES'
                        and HSTF_CHILD = 'TMA1120' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACT_OTHER_ACTIVITIES', 'TMA1160', 'Query Licenced Works', 'M', 20
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACT_OTHER_ACTIVITIES'
                        and HSTF_CHILD = 'TMA1160' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACT_OTHER_ACTIVITIES', 'TMA1150', 'Non-Street Works Activities', 'M', 30
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACT_OTHER_ACTIVITIES'
                        and HSTF_CHILD = 'TMA1150' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACT_OTHER_ACTIVITIES', 'TMA1170', 'Query Non-Street Works Activities', 'M', 40
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACT_OTHER_ACTIVITIES'
                        and HSTF_CHILD = 'TMA1170' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACT_RESTRICTIONS', 'TMA1110', 'Restrictions', 'M', 10
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACT_RESTRICTIONS'
                        and HSTF_CHILD = 'TMA1110' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACT_RESTRICTIONS', 'TMA3020', 'Get Restriction', 'M', 20
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACT_RESTRICTIONS'
                        and HSTF_CHILD = 'TMA3020' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACT_RESTRICTIONS', 'TMA1180', 'Send All Restrictions', 'M', 30
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACT_RESTRICTIONS'
                        and HSTF_CHILD = 'TMA1180' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACT_WORKS', 'TMA1010', 'Projects', 'M', 10
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACT_WORKS'
                        and HSTF_CHILD = 'TMA1010' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACT_WORKS', 'TMA1000', 'Works', 'M', 20
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACT_WORKS'
                        and HSTF_CHILD = 'TMA1000' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACT_WORKS', 'TMA1020', 'Comments', 'M', 30
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACT_WORKS'
                        and HSTF_CHILD = 'TMA1020' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACT_WORKS', 'TMA1030', 'Review Notices', 'M', 40
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACT_WORKS'
                        and HSTF_CHILD = 'TMA1030' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACT_WORKS', 'TMA1040', 'Query Works', 'M', 50
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACT_WORKS'
                        and HSTF_CHILD = 'TMA1040' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACT_WORKS', 'TMA1050', 'Query Overrunning Works', 'M', 60
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACT_WORKS'
                        and HSTF_CHILD = 'TMA1050' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACT_WORKS', 'TMA1060', 'Error Corrections', 'M', 70
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACT_WORKS'
                        and HSTF_CHILD = 'TMA1060' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_ACT_WORKS', 'TMA1070', 'Directions', 'M', 80
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_ACT_WORKS'
                        and HSTF_CHILD = 'TMA1070' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_DATA_EXCHANGE', 'TMA_DATA_WEB_SERVICES', 'Web Services', 'F', 10
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_DATA_EXCHANGE'
                        and HSTF_CHILD = 'TMA_DATA_WEB_SERVICES' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_DATA_EXCHANGE', 'TMA_DATA_BATCH_PROCESSING', 'Batch Processing', 'F', 20
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_DATA_EXCHANGE'
                        and HSTF_CHILD = 'TMA_DATA_BATCH_PROCESSING' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_DATA_EXCHANGE', 'TMA_DATA_REPORTS', 'Reports', 'F', 30
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_DATA_EXCHANGE'
                        and HSTF_CHILD = 'TMA_DATA_REPORTS' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_DATA_WEB_SERVICES', 'TMA3000', 'Monitor Web Service Transactions', 'M', 10
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_DATA_WEB_SERVICES'
                        and HSTF_CHILD = 'TMA3000' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_DATA_WEB_SERVICES', 'TMA3010', 'Send EToN Ping', 'M', 20
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_DATA_WEB_SERVICES'
                        and HSTF_CHILD = 'TMA3010' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_INSPECTIONS', 'TMA_INSP_REPORTS', 'Reports', 'F', 500
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_INSPECTIONS'
                        and HSTF_CHILD = 'TMA_INSP_REPORTS' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_INSPECTIONS', 'TMA5000', 'Inspections', 'M', 10
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_INSPECTIONS'
                        and HSTF_CHILD = 'TMA5000' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'HIG_REFERENCE', 'HIG4025', 'My Standard Text Usage', 'M', 20
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'HIG_REFERENCE'
                        and HSTF_CHILD = 'HIG4025' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_INSPECTIONS', 'TMA5020', 'Inspections Sent/Received', 'M', 30
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_INSPECTIONS'
                        and HSTF_CHILD = 'TMA5020' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_INSPECTIONS', 'TMA5030', 'Query Inspection Defects', 'M', 40
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_INSPECTIONS'
                        and HSTF_CHILD = 'TMA5030' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_INSPECTIONS', 'TMA5100', 'Schedule Inspections', 'M', 50
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_INSPECTIONS'
                        and HSTF_CHILD = 'TMA5100' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_INSPECTIONS', 'TMA5110', 'Annual Inspection Profiles', 'M', 60
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_INSPECTIONS'
                        and HSTF_CHILD = 'TMA5110' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_INSPECTIONS', 'TMA5270', 'Defect Inspection Schedules', 'M', 70
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_INSPECTIONS'
                        and HSTF_CHILD = 'TMA5270' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_INSP_REPORTS', 'TMA6000', 'Works Inspection Report', 'M', 10
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_INSP_REPORTS'
                        and HSTF_CHILD = 'TMA6000' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_INSP_REPORTS', 'TMA6010', 'Generic Inspections Report', 'M', 20
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_INSP_REPORTS'
                        and HSTF_CHILD = 'TMA6010' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_INSP_REPORTS', 'TMA6030', 'Prospective Inspections Report', 'M', 40
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_INSP_REPORTS'
                        and HSTF_CHILD = 'TMA6030' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_INSP_REPORTS', 'TMA6040', 'Sample Inspection Quotas Report', 'M', 50
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_INSP_REPORTS'
                        and HSTF_CHILD = 'TMA6040' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_INSP_REPORTS', 'TMA6050', 'Inspection Performance', 'M', 60
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_INSP_REPORTS'
                        and HSTF_CHILD = 'TMA6050' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_INSP_REPORTS', 'TMA6060', 'Inspection Performance Hierarchy', 'M', 70
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_INSP_REPORTS'
                        and HSTF_CHILD = 'TMA6060' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_INSP_REPORTS', 'TMA6070', 'Annual Inspection Profiles', 'M', 80
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_INSP_REPORTS'
                        and HSTF_CHILD = 'TMA6070' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_INSP_REPORTS', 'TMA6080', 'Sample Inspections Invoice Report', 'M', 90
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_INSP_REPORTS'
                        and HSTF_CHILD = 'TMA6080' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_INSP_REPORTS', 'TMA6090', 'Inspections Invoice', 'M', 100
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_INSP_REPORTS'
                        and HSTF_CHILD = 'TMA6090' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_REFERENCE_DATA', 'TMA_REF_ADMINISTRATION', 'Administration', 'F', 10
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_REFERENCE_DATA'
                        and HSTF_CHILD = 'TMA_REF_ADMINISTRATION' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_REFERENCE_DATA', 'TMA_REF_ACTIVITIES', 'Activities', 'F', 20
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_REFERENCE_DATA'
                        and HSTF_CHILD = 'TMA_REF_ACTIVITIES' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_REFERENCE_DATA', 'TMA_REF_INSPECTIONS', 'Inspections', 'F', 30
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_REFERENCE_DATA'
                        and HSTF_CHILD = 'TMA_REF_INSPECTIONS' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_REFERENCE_DATA', 'TMA_REF_BATCH_PROCESSING', 'Batch Processing', 'F', 40
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_REFERENCE_DATA'
                        and HSTF_CHILD = 'TMA_REF_BATCH_PROCESSING' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_REFERENCE_DATA', 'TMA_REF_REPORTS', 'Reports', 'F', 50
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_REFERENCE_DATA'
                        and HSTF_CHILD = 'TMA_REF_REPORTS' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_REF_ACTIVITIES', 'TMA2000', 'Notice Review Rules', 'M', 10
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_REF_ACTIVITIES'
                        and HSTF_CHILD = 'TMA2000' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_REF_ACTIVITIES', 'TMA2010', 'Notice Types', 'M', 20
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_REF_ACTIVITIES'
                        and HSTF_CHILD = 'TMA2010' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_REF_ACTIVITIES', 'TMA2020', 'Works Categories', 'M', 30
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_REF_ACTIVITIES'
                        and HSTF_CHILD = 'TMA2020' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_REF_ACTIVITIES', 'TMA2030', 'Status Transitions', 'M', 40
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_REF_ACTIVITIES'
                        and HSTF_CHILD = 'TMA2030' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_REF_ACTIVITIES', 'TMA2040', 'Agreement Types', 'M', 50
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_REF_ACTIVITIES'
                        and HSTF_CHILD = 'TMA2040' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_REF_ADMINISTRATION', 'TMA0010', 'Contacts', 'M', 10
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_REF_ADMINISTRATION'
                        and HSTF_CHILD = 'TMA0010' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_REF_ADMINISTRATION', 'TMA0020', 'Street Groups', 'M', 20
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_REF_ADMINISTRATION'
                        and HSTF_CHILD = 'TMA0020' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_REF_ADMINISTRATION', 'TMA0030', 'Unassigned Streets', 'M', 30
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_REF_ADMINISTRATION'
                        and HSTF_CHILD = 'TMA0030' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_REF_ADMINISTRATION', 'TMA0040', 'User Street Groups', 'M', 40
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_REF_ADMINISTRATION'
                        and HSTF_CHILD = 'TMA0040' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_REF_ADMINISTRATION', 'TMA0050', 'My Street Groups', 'M', 50
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_REF_ADMINISTRATION'
                        and HSTF_CHILD = 'TMA0050' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_REF_INSPECTIONS', 'TMA5200', 'Inspections Metadata', 'M', 10
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_REF_INSPECTIONS'
                        and HSTF_CHILD = 'TMA5200' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_REF_REPORTS', 'TMA9000', 'Reference Data Report', 'M', 10
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_REF_REPORTS'
                        and HSTF_CHILD = 'TMA9000' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_REF_INSPECTIONS', 'TMA5300', 'Inspection Rulesets', 'M', 100
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_REF_INSPECTIONS'
                        and HSTF_CHILD = 'TMA5300' );
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
select 'TMA_REF_INSPECTIONS', 'TMA5290', 'Inspectors', 'M', 90
  from dual
  where not exists (select 1 
                      from HIG_STANDARD_FAVOURITES 
                      where HSTF_PARENT = 'TMA_REF_INSPECTIONS'
                        and HSTF_CHILD = 'TMA5290' );

Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
Select 'NSG_DATA', 'NSG0110', 'Organisations and Districts', 'M', 25
  from dual
 where not exists (select 1 from HIG_STANDARD_FAVOURITES where HSTF_PARENT = 'NSG_DATA' and HSTF_CHILD = 'NSG0110');

                      
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT,HSTF_CHILD,HSTF_DESCR,HSTF_TYPE,HSTF_ORDER)
SELECT 'TMA_REF_ACTIVITIES','TMA2060','S74 Charge Profiles','M',70 
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'TMA_REF_ACTIVITIES'
                    AND  HSTF_CHILD = 'TMA2060');

-------------------------------------
-- changes emailed from GJohnson
-------------------------------------
delete from hig_standard_favourites
where HSTF_parent like 'TMA_%BAT%'
/

INSERT INTO HIG_STANDARD_FAVOURITES 
( HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE,HSTF_ORDER ) 
VALUES ( 'TMA_DATA_BATCH_PROCESSING', 'TMA_DATA_BATCH_PROCESSING_DCD', 'DCD Inspections', 'F', 20)
/
 
INSERT INTO HIG_STANDARD_FAVOURITES 
( HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE,HSTF_ORDER ) 
VALUES ( 'TMA_DATA_BATCH_PROCESSING', 'TMA_DATA_BATCH_PROCESSING_INSP', 'Inspections', 'F', 10)
/

INSERT INTO HIG_STANDARD_FAVOURITES 
( HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE,HSTF_ORDER ) 
VALUES ( 'TMA_DATA_BATCH_PROCESSING_DCD', 'TMA5515', 'DCD Extract', 'M', 10)
/

INSERT INTO HIG_STANDARD_FAVOURITES 
( HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE,HSTF_ORDER ) 
VALUES ( 'TMA_DATA_BATCH_PROCESSING_DCD', 'TMA5520', 'Inspection Download to DCD', 'M', 20)
/

INSERT INTO HIG_STANDARD_FAVOURITES 
( HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE,HSTF_ORDER ) 
VALUES ( 'TMA_DATA_BATCH_PROCESSING_DCD', 'TMA5530', 'Automatic Inspection Download to DCD', 'M', 30)
/

INSERT INTO HIG_STANDARD_FAVOURITES 
( HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE,HSTF_ORDER ) 
VALUES ( 'TMA_DATA_BATCH_PROCESSING_INSP', 'TMA5500', 'Inspection Download', 'M', 10)
/

INSERT INTO HIG_STANDARD_FAVOURITES 
( HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE,HSTF_ORDER ) 
VALUES ( 'TMA_DATA_BATCH_PROCESSING_INSP', 'TMA5510', 'Inspections Batch File Summary', 'M', 40)
/

INSERT INTO HIG_STANDARD_FAVOURITES 
( HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE,HSTF_ORDER ) VALUES ( 'TMA_DATA_BATCH_PROCESSING_INSP', 'TMA5600', 'Inspection Upload', 'M', 20)
/ 

INSERT INTO HIG_STANDARD_FAVOURITES 
( HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE,HSTF_ORDER ) VALUES ( 'TMA_DATA_BATCH_PROCESSING_INSP', 'TMA5610', 'Automatic Inspection Upload', 'M', 30)
/

INSERT INTO HIG_STANDARD_FAVOURITES 
( HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE,HSTF_ORDER ) 
VALUES ( 'TMA_DATA_BATCH_PROCESSING_INSP', 'TMA5620', 'Inspections Upload Transaction Summary', 'M', 50)
/

INSERT INTO HIG_STANDARD_FAVOURITES
(HSTF_PARENT,HSTF_CHILD,HSTF_DESCR,HSTF_TYPE,HSTF_ORDER)
SELECT 'TMA_ACT_REPORTS','TMA7010','Phase Due to Complete','M',10 
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'TMA_ACT_REPORTS'
                    AND  HSTF_CHILD = 'TMA7010')
/

INSERT INTO HIG_STANDARD_FAVOURITES
(HSTF_PARENT,HSTF_CHILD,HSTF_DESCR,HSTF_TYPE,HSTF_ORDER)
SELECT 'TMA_ACT_REPORTS','TMA7020','Phase Due to Start','M',20 
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'TMA_ACT_REPORTS'
                    AND  HSTF_CHILD = 'TMA7020')
/

COMMIT;
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT script to port version 2 reports to version 4
SET TERM OFF

-- DY  09-JAN-2008
-- 
-- DEVELOPMENT COMMENTS
-- Script to copy version 2 reports into version 4.  
-- 
-- Inserts into:
-- 
-- hig_modules
-- gri_modules,
-- gri_params,
-- gri_module_params,
-- gri_param_dependencies,
-- gri_param_lookup,
-- hig_module_roles
------------------------------------------------------------------
INSERT INTO HIG_MODULES
       (HMO_MODULE
       ,HMO_TITLE
       ,HMO_FILENAME
       ,HMO_MODULE_TYPE
       ,HMO_FASTPATH_OPTS
       ,HMO_FASTPATH_INVALID
       ,HMO_USE_GRI
       ,HMO_APPLICATION
       ,HMO_MENU
       ) 
SELECT
        'NET5002'
       ,'Print Road Groups and their Membership'
       ,'net5002'
       ,'R25'
       ,''
       ,'N'
       ,'Y'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT '1' FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NET5002');
--                   
INSERT INTO HIG_MODULES
       (HMO_MODULE
       ,HMO_TITLE
       ,HMO_FILENAME
       ,HMO_MODULE_TYPE
       ,HMO_FASTPATH_OPTS
       ,HMO_FASTPATH_INVALID
       ,HMO_USE_GRI
       ,HMO_APPLICATION
       ,HMO_MENU
       ) 
SELECT
        'NET5003'
       ,'Print Full Sections within a Group'
       ,'net5003'
       ,'R25'
       ,''
       ,'N'
       ,'Y'
       ,'NET'
       ,'FORM' FROM DUAL
WHERE NOT EXISTS (SELECT '1' FROM HIG_MODULES
                  WHERE HMO_MODULE = 'NET5003');
--                  
INSERT INTO HIG_MODULES
       (HMO_MODULE
       ,HMO_TITLE
       ,HMO_FILENAME
       ,HMO_MODULE_TYPE
       ,HMO_FASTPATH_OPTS
       ,HMO_FASTPATH_INVALID
       ,HMO_USE_GRI
       ,HMO_APPLICATION
       ,HMO_MENU
       ) 
SELECT
        'NET5085'
       ,'Print Road Parts and their Membership'
       ,'net5085'
       ,'R25'
       ,''
       ,'N'
       ,'Y'
       ,'NET'
       ,'FORM' FROM DUAL
WHERE NOT EXISTS (SELECT '1' FROM HIG_MODULES
                  WHERE HMO_MODULE = 'NET5085');
--                  
INSERT INTO HIG_MODULES
       (HMO_MODULE
       ,HMO_TITLE
       ,HMO_FILENAME
       ,HMO_MODULE_TYPE
       ,HMO_FASTPATH_OPTS
       ,HMO_FASTPATH_INVALID
       ,HMO_USE_GRI
       ,HMO_APPLICATION
       ,HMO_MENU
       ) 
SELECT
        'NET5090'
       ,'Print Road Parts with No Sections'
       ,'net5090'
       ,'R25'
       ,'' 
       ,'N'
       ,'Y'
       ,'NET'
       ,'FORM' FROM DUAL
WHERE NOT EXISTS (SELECT '1'
                  FROM HIG_MODULES
                  where HMO_MODULE = 'NET5090');
--                  
INSERT INTO HIG_MODULES
       (HMO_MODULE
       ,HMO_TITLE
       ,HMO_FILENAME
       ,HMO_MODULE_TYPE
       ,HMO_FASTPATH_OPTS
       ,HMO_FASTPATH_INVALID
       ,HMO_USE_GRI
       ,HMO_APPLICATION
       ,HMO_MENU
       ) 
SELECT
        'NET5095'
       ,'Print Sections not Allocated to a Road Part'
       ,'net5095'
       ,'R25'
       ,''
       ,'N'
       ,'Y'
       ,'NET'
       ,'FORM' FROM DUAL
       WHERE NOT EXISTS (SELECT '1'
                         FROM HIG_MODULES
                         WHERE HMO_MODULE = 'NET5095');  
--
INSERT INTO GRI_MODULES
       (GRM_MODULE
       ,GRM_MODULE_TYPE
       ,GRM_MODULE_PATH
       ,GRM_FILE_TYPE
       ,GRM_TAG_FLAG
       ,GRM_TAG_TABLE
       ,GRM_TAG_COLUMN
       ,GRM_TAG_WHERE
       ,GRM_LINESIZE
       ,GRM_PAGESIZE
       )
SELECT 
        'NET5002'
       ,'N/A'
       ,'$PROD_HOME/bin'
       ,'lis'
       ,'N'
       ,''
       ,''
       ,''
       ,132
       ,66 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULES
                   WHERE GRM_MODULE = 'NET5002');        
--
INSERT INTO GRI_MODULES
       (GRM_MODULE
       ,GRM_MODULE_TYPE
       ,GRM_MODULE_PATH
       ,GRM_FILE_TYPE
       ,GRM_TAG_FLAG
       ,GRM_TAG_TABLE
       ,GRM_TAG_COLUMN
       ,GRM_TAG_WHERE
       ,GRM_LINESIZE
       ,GRM_PAGESIZE
       ,GRM_PRE_PROCESS
       )
SELECT 
       'NET5003'
      ,'N/A'
      ,'$PROD_HOME/bin'
      ,'lis'
      ,'Y'
      ,'ROAD_SEGS'
      ,'RSE_HE_ID'
      ,''
      ,132
      ,66
      ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULES
                   WHERE GRM_MODULE = 'NET5003'); 
--
INSERT INTO GRI_MODULES
       (GRM_MODULE
       ,GRM_MODULE_TYPE
       ,GRM_MODULE_PATH
       ,GRM_FILE_TYPE
       ,GRM_TAG_FLAG
       ,GRM_TAG_TABLE
       ,GRM_TAG_COLUMN
       ,GRM_TAG_WHERE
       ,GRM_LINESIZE
       ,GRM_PAGESIZE
       ,GRM_PRE_PROCESS
       )
SELECT
       'NET5085'
      ,'N/A'
      ,'$PROD_HOME/bin'
      ,'lis'
      ,'N'
      ,''
      ,''
      ,''
      ,80
      ,66
      ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULES
                   WHERE GRM_MODULE = 'NET5085');      
--
INSERT INTO GRI_MODULES
       (GRM_MODULE
       ,GRM_MODULE_TYPE
       ,GRM_MODULE_PATH
       ,GRM_FILE_TYPE
       ,GRM_TAG_FLAG
       ,GRM_TAG_TABLE
       ,GRM_TAG_COLUMN
       ,GRM_TAG_WHERE
       ,GRM_LINESIZE
       ,GRM_PAGESIZE
       ,GRM_PRE_PROCESS
       )
SELECT
       'NET5090'
      ,'N/A'
      ,'$PROD_HOME/bin'
      ,'lis'
      ,'N'
      ,''
      ,''
      ,''
      ,132
      ,66
      ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULES
                   WHERE GRM_MODULE = 'NET5090');      
--      
INSERT INTO GRI_MODULES
       (GRM_MODULE
       ,GRM_MODULE_TYPE
       ,GRM_MODULE_PATH
       ,GRM_FILE_TYPE
       ,GRM_TAG_FLAG
       ,GRM_TAG_TABLE
       ,GRM_TAG_COLUMN
       ,GRM_TAG_WHERE
       ,GRM_LINESIZE
       ,GRM_PAGESIZE
       ,GRM_PRE_PROCESS
       )
SELECT
       'NET5095'
      ,'N/A'
      ,'$PROD_HOME/bin'
      ,'lis'
      ,'N'
      ,''
      ,''
      ,''
      ,132
      ,66
      ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULES
                   WHERE GRM_MODULE = 'NET5095');  
--
INSERT INTO GRI_PARAMS
       (GP_PARAM
       ,GP_PARAM_TYPE
       ,GP_TABLE
       ,GP_COLUMN
       ,GP_DESCR_COLUMN
       ,GP_SHOWN_COLUMN
       ,GP_SHOWN_TYPE
       ,GP_DESCR_TYPE
       ,GP_ORDER
       ,GP_CASE
       ,GP_GAZ_RESTRICTION
       )
SELECT 
        'ADMIN_UNIT'
       ,'NUMBER'
       ,'HIG_ADMIN_UNITS'
       ,'HAU_ADMIN_UNIT'
       ,'HAU_NAME'
       ,'HAU_UNIT_CODE'
       ,'CHAR'
       ,''
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_PARAMS
                   WHERE GP_PARAM = 'ADMIN_UNIT');       
--
INSERT INTO GRI_PARAMS
       (GP_PARAM
       ,GP_PARAM_TYPE
       ,GP_TABLE
       ,GP_COLUMN
       ,GP_DESCR_COLUMN
       ,GP_SHOWN_COLUMN
       ,GP_SHOWN_TYPE
       ,GP_DESCR_TYPE
       ,GP_ORDER
       ,GP_CASE
       ,GP_GAZ_RESTRICTION
       )
SELECT
        'ROAD_ID'
       ,'NUMBER'
       ,'ROAD_SEGMENTS_ALL'
       ,'RSE_HE_ID'
       ,'RSE_DESCR'
       ,'RSE_UNIQUE'
       ,'CHAR'
       ,''
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_PARAMS
                   WHERE GP_PARAM = 'ROAD_ID');     
--
INSERT INTO GRI_PARAMS
       (GP_PARAM
       ,GP_PARAM_TYPE
       ,GP_TABLE
       ,GP_COLUMN
       ,GP_DESCR_COLUMN
       ,GP_SHOWN_COLUMN
       ,GP_SHOWN_TYPE
       ,GP_DESCR_TYPE
       ,GP_ORDER
       ,GP_CASE
       ,GP_GAZ_RESTRICTION
       )
SELECT
        'ALL_ROAD_GPS'
       ,'CHAR'
       ,'GRI_PARAM_LOOKUP'
       ,'GPL_VALUE'
       ,'GPL_DESCR'
       ,'GPL_VALUE'
       ,'CHAR'
       ,''
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_PARAMS
                   WHERE GP_PARAM = 'ALL_ROAD_GPS');                                              
-- 
INSERT INTO GRI_MODULE_PARAMS 
       (GMP_MODULE
       ,GMP_PARAM
       ,GMP_SEQ
       ,GMP_PARAM_DESCR
       ,GMP_MANDATORY
       ,GMP_NO_ALLOWED
       ,GMP_WHERE
       ,GMP_TAG_RESTRICTION
       ,GMP_TAG_WHERE
       ,GMP_DEFAULT_TABLE
       ,GMP_DEFAULT_COLUMN
       ,GMP_DEFAULT_WHERE
       ,GMP_VISIBLE
       ,GMP_GAZETTEER
       ,GMP_LOV
       ,GMP_VAL_GLOBAL
       ,GMP_WILDCARD
       ,GMP_HINT_TEXT
       ,GMP_ALLOW_PARTIAL
       ,GMP_BASE_TABLE
       ,GMP_BASE_TABLE_COLUMN
       ,GMP_OPERATOR
       )
SELECT 
        'NET5002'
       ,'ALL_ROAD_GPS'
       ,3
       ,'Include all Road Groups (Y/N)'
       ,'Y'
       ,1
       ,'GPL_PARAM=''ALL_ROAD_GPS'''
       ,'N'
       ,''
       ,'GRI_PARAM_LOOKUP'
       ,'GPL_VALUE'
       ,'GPL_VALUE=''N'' AND GPL_PARAM=''ALL_ROAD_GPS'''
       ,'Y'
       ,'N'
       ,'Y'
       ,''
       ,'N'
       ,''
       ,'N'
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULE_PARAMS
                   WHERE GMP_MODULE = 'NET5002'
                    AND  GMP_PARAM = 'ALL_ROAD_GPS');        
--
INSERT INTO GRI_MODULE_PARAMS 
       (GMP_MODULE
       ,GMP_PARAM
       ,GMP_SEQ
       ,GMP_PARAM_DESCR
       ,GMP_MANDATORY
       ,GMP_NO_ALLOWED
       ,GMP_WHERE
       ,GMP_TAG_RESTRICTION
       ,GMP_TAG_WHERE
       ,GMP_DEFAULT_TABLE
       ,GMP_DEFAULT_COLUMN
       ,GMP_DEFAULT_WHERE
       ,GMP_VISIBLE
       ,GMP_GAZETTEER
       ,GMP_LOV
       ,GMP_VAL_GLOBAL
       ,GMP_WILDCARD
       ,GMP_HINT_TEXT
       ,GMP_ALLOW_PARTIAL
       ,GMP_BASE_TABLE
       ,GMP_BASE_TABLE_COLUMN
       ,GMP_OPERATOR
       )
SELECT 
        'NET5002'
       ,'ADMIN_UNIT'
       ,1
       ,'Admin Unit'
       ,'Y'
       ,1
       ,'(HAU_ADMIN_UNIT IN (SELECT HAG_CHILD_ADMIN_UNIT FROM HIG_ADMIN_GROUPS WHERE HAG_PARENT_ADMIN_UNIT IN (SELECT HUS_ADMIN_UNIT FROM HIG_USERS WHERE HUS_USERNAME = USER)))'
       ,'N'
       ,''
       ,'HIG_ADMIN_UNITS'
       ,'HAU_ADMIN_UNIT'
       ,'HAU_ADMIN_UNIT = (SELECT MAX(HUS_ADMIN_UNIT) FROM HIG_USERS WHERE HUS_USERNAME = USER)'
       ,'Y'
       ,'N'
       ,'Y'
       ,''
       ,'N'
      ,''
       ,'N'
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULE_PARAMS
                   WHERE GMP_MODULE = 'NET5002'
                    AND  GMP_PARAM = 'ADMIN_UNIT');       
--
INSERT INTO GRI_MODULE_PARAMS 
       (GMP_MODULE
       ,GMP_PARAM
       ,GMP_SEQ
       ,GMP_PARAM_DESCR
       ,GMP_MANDATORY
       ,GMP_NO_ALLOWED
       ,GMP_WHERE
       ,GMP_TAG_RESTRICTION
       ,GMP_TAG_WHERE
       ,GMP_DEFAULT_TABLE
       ,GMP_DEFAULT_COLUMN
       ,GMP_DEFAULT_WHERE
       ,GMP_VISIBLE
       ,GMP_GAZETTEER
       ,GMP_LOV
       ,GMP_VAL_GLOBAL
       ,GMP_WILDCARD
       ,GMP_HINT_TEXT
       ,GMP_ALLOW_PARTIAL
       ,GMP_BASE_TABLE
       ,GMP_BASE_TABLE_COLUMN
       ,GMP_OPERATOR
       )
SELECT 
        'NET5002'
       ,'ROAD_ID'
       ,2
       ,'Road Id'
       ,'N'
       ,1
       ,'RSE_ADMIN_UNIT IN (SELECT HAG_CHILD_ADMIN_UNIT FROM HIG_ADMIN_GROUPS WHERE HAG_PARENT_ADMIN_UNIT = :ADMIN_UNIT)'
       ,'N'
       ,''
       ,''
       ,''
       ,''
       ,'Y'
       ,'Y'
       ,'N'
       ,'road_id'
       ,'N'
       ,''
       ,'N'
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULE_PARAMS
                   WHERE GMP_MODULE = 'NET5002'
                    AND  GMP_PARAM = 'ROAD_ID'); 
--                       
INSERT INTO GRI_MODULE_PARAMS 
       (GMP_MODULE
       ,GMP_PARAM
       ,GMP_SEQ
       ,GMP_PARAM_DESCR
       ,GMP_MANDATORY
       ,GMP_NO_ALLOWED
       ,GMP_WHERE
       ,GMP_TAG_RESTRICTION
       ,GMP_TAG_WHERE
       ,GMP_DEFAULT_TABLE
       ,GMP_DEFAULT_COLUMN
       ,GMP_DEFAULT_WHERE
       ,GMP_VISIBLE
       ,GMP_GAZETTEER
       ,GMP_LOV
       ,GMP_VAL_GLOBAL
       ,GMP_WILDCARD
       ,GMP_HINT_TEXT
       ,GMP_ALLOW_PARTIAL
       ,GMP_BASE_TABLE
       ,GMP_BASE_TABLE_COLUMN
       ,GMP_OPERATOR
       )
SELECT 
        'NET5003'
       ,'ADMIN_UNIT'
       ,1
       ,'Admin Unit'
       ,'Y'
       ,1
       ,'(HAU_ADMIN_UNIT IN (SELECT HAG_CHILD_ADMIN_UNIT FROM HIG_ADMIN_GROUPS WHERE HAG_PARENT_ADMIN_UNIT IN (SELECT HUS_ADMIN_UNIT FROM HIG_USERS WHERE HUS_USERNAME = USER)))'
       ,'N'
       ,''
       ,'HIG_ADMIN_UNITS'
       ,'HAU_ADMIN_UNIT'
       ,'HAU_ADMIN_UNIT = (SELECT MAX(HUS_ADMIN_UNIT) FROM HIG_USERS WHERE HUS_USERNAME = USER)'
       ,'Y'
       ,'N'
       ,'Y'
       ,''
       ,'N'
       ,''
       ,'N'
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULE_PARAMS
                   WHERE GMP_MODULE = 'NET5003'
                    AND  GMP_PARAM = 'ADMIN_UNIT');
--
INSERT INTO GRI_MODULE_PARAMS 
       (GMP_MODULE
       ,GMP_PARAM
       ,GMP_SEQ
       ,GMP_PARAM_DESCR
       ,GMP_MANDATORY
       ,GMP_NO_ALLOWED
       ,GMP_WHERE
       ,GMP_TAG_RESTRICTION
       ,GMP_TAG_WHERE
       ,GMP_DEFAULT_TABLE
       ,GMP_DEFAULT_COLUMN
       ,GMP_DEFAULT_WHERE
       ,GMP_VISIBLE
       ,GMP_GAZETTEER
       ,GMP_LOV
       ,GMP_VAL_GLOBAL
       ,GMP_WILDCARD
       ,GMP_HINT_TEXT
       ,GMP_ALLOW_PARTIAL
       ,GMP_BASE_TABLE
       ,GMP_BASE_TABLE_COLUMN
       ,GMP_OPERATOR
       )
SELECT 
        'NET5003'
       ,'ROAD_ID'
       ,2
       ,'Road Id'
       ,'Y'
       ,1
       ,'RSE_ADMIN_UNIT IN (SELECT HAG_CHILD_ADMIN_UNIT FROM HIG_ADMIN_GROUPS WHERE HAG_PARENT_ADMIN_UNIT = :ADMIN_UNIT)'
       ,'Y'
       ,'RSE_HE_ID IN (SELECT :ROAD_ID FROM DUAL UNION SELECT RSM_RSE_HE_ID_OF FROM ROAD_SEG_MEMBS WHERE RSM_END_DATE IS NULL CONNECT BY PRIOR RSM_RSE_HE_ID_OF = RSM_RSE_HE_ID_IN START WITH RSM_RSE_HE_ID_IN = :ROAD_ID)'
       ,''
       ,''
       ,''
       ,'Y'
       ,'Y'
       ,'N'
       ,'road_id'
       ,'N'
       ,''
       ,'N'
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULE_PARAMS
                   WHERE GMP_MODULE = 'NET5003'
                    AND  GMP_PARAM = 'ROAD_ID');
--                     
INSERT INTO GRI_MODULE_PARAMS 
       (GMP_MODULE
       ,GMP_PARAM
       ,GMP_SEQ
       ,GMP_PARAM_DESCR
       ,GMP_MANDATORY
       ,GMP_NO_ALLOWED
       ,GMP_WHERE
       ,GMP_TAG_RESTRICTION
       ,GMP_TAG_WHERE
       ,GMP_DEFAULT_TABLE
       ,GMP_DEFAULT_COLUMN
       ,GMP_DEFAULT_WHERE
       ,GMP_VISIBLE
       ,GMP_GAZETTEER
       ,GMP_LOV
       ,GMP_VAL_GLOBAL
       ,GMP_WILDCARD
       ,GMP_HINT_TEXT
       ,GMP_ALLOW_PARTIAL
       ,GMP_BASE_TABLE
       ,GMP_BASE_TABLE_COLUMN
       ,GMP_OPERATOR
       )
SELECT
        'NET5085'
       ,'ROAD_ID'
       ,1
       ,'Road Part'
       ,'N'
       ,1
       ,'RSE_GTY_GROUP_TYPE=''RP'''
       ,'N'
       ,''
       ,''
       ,''
       ,''
       ,'Y'
       ,'N'
       ,'Y'
       ,''
       ,'N'
       ,'Enter the Road Part'
       ,'N'
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULE_PARAMS
                   WHERE GMP_MODULE = 'NET5085'
                    AND  GMP_PARAM = 'ROAD_ID');                           
--         
INSERT INTO GRI_PARAM_DEPENDENCIES
       (GPD_MODULE
       ,GPD_DEP_PARAM
       ,GPD_INDEP_PARAM
       )
SELECT
        'NET5002'
       ,'ROAD_ID'
       ,'ADMIN_UNIT' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM GRI_PARAM_DEPENDENCIES
                   WHERE GPD_MODULE = 'NET5002'
                    AND  GPD_DEP_PARAM = 'ROAD_ID'
                    AND  GPD_INDEP_PARAM = 'ADMIN_UNIT');
--
INSERT INTO GRI_PARAM_DEPENDENCIES
       (GPD_MODULE
       ,GPD_DEP_PARAM
       ,GPD_INDEP_PARAM
       )
SELECT
        'NET5003'
       ,'ROAD_ID'
       ,'ADMIN_UNIT' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM GRI_PARAM_DEPENDENCIES
                   WHERE GPD_MODULE = 'NET5003'
                    AND  GPD_DEP_PARAM = 'ROAD_ID'
                    AND  GPD_INDEP_PARAM = 'ADMIN_UNIT');
--                              
INSERT INTO GRI_PARAM_LOOKUP
       (GPL_PARAM
       ,GPL_VALUE
       ,GPL_DESCR
       )
SELECT 
        'ALL_ROAD_GPS'
       ,'N'
       ,'No' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_PARAM_LOOKUP
                   WHERE GPL_PARAM = 'ALL_ROAD_GPS'
                    AND  GPL_VALUE = 'N');
--
INSERT INTO GRI_PARAM_LOOKUP
       (GPL_PARAM
       ,GPL_VALUE
       ,GPL_DESCR
       )
SELECT 
        'ALL_ROAD_GPS'
       ,'Y'
       ,'Yes' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_PARAM_LOOKUP
                   WHERE GPL_PARAM = 'ALL_ROAD_GPS'
                    AND  GPL_VALUE = 'Y');   
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NET5002'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                  WHERE HMR_MODULE = 'NET5002'
                  AND HMR_ROLE = 'NET_ADMIN');
--                  
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       ) 
SELECT
        'NET5003'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                  WHERE HMR_MODULE = 'NET5003'
                  AND HMR_ROLE = 'HIG_USER');
--                  
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       ) 
SELECT
        'NET5085'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                  WHERE HMR_MODULE = 'NET5085'
                  AND HMR_ROLE = 'NET_ADMIN');
--                  
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT
       'NET5090'
      ,'NET_ADMIN'
      ,'NORMAL' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                  WHERE HMR_MODULE = 'NET5090'
                  AND HMR_ROLE = 'NET_ADMIN');
--                  
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT
       'NET5095'
      ,'NET_ADMIN'
      ,'NORMAL' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                  WHERE HMR_MODULE = 'NET5095'
                  AND HMR_ROLE = 'NET_ADMIN');
                                    

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT nm_error 501
SET TERM OFF

-- GJ  15-JAN-2008
-- 
-- DEVELOPMENT COMMENTS
-- New error - called in nm3xml package
------------------------------------------------------------------
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,501
       ,null
       ,'XML Read error'
       ,'Error suggests XML is not ''well formed''' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 501);

commit;
------------------------------------------------------------------


------------------------------------------------------------------

------------------------------------------------------------------
COMMIT
/
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

