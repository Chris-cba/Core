------------------------------------------------------------------
-- nm40_nm4010_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm40_nm4010_metadata_upg.sql	1.2 04/13/07
--       Module Name      : nm40_nm4010_metadata_upg.sql
--       Date into SCCS   : 07/04/13 11:10:57
--       Date fetched Out : 07/06/13 13:59:20
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
PROMPT Re-run in the NM40 reconciliation changes
SET TERM OFF

-- GJ  03-APR-2007
-- 
-- DEVELOPMENT COMMENTS
-- These metadata changes were originally part of nm40_nm40_upg.sql
-- They allowed those customers that took initial Atlas releases to consolidate when the full release was shipped.
-- However, since this was an optional exercise, we need to ensure these changes are definitely applied at 4.0.1.0.
------------------------------------------------------------------
-- CP 11/12/2006
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 500;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,500
       ,null
       ,'This module is not available when the application is run on the web.'
       ,'' FROM DUAL;


-- KA 12/12/2006
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 443;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,443
       ,null
       ,'References must be relative to a linear route'
       ,'' FROM DUAL;



-----------------------------------------------------------------------------------
-- AE 12/12/2006 
-- full set of NM_LAYER_TREE metadata
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'ENQ'
       ,'Enquiry Manager'
       ,'F'
       ,50 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'ENQ');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'AST'
       ,'Asset Manager'
       ,'F'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'AST');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'CUS'
       ,'Custom Layers'
       ,'F'
       ,120 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'CUS');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'MAI'
       ,'Maintenance Manager'
       ,'F'
       ,60 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'MAI');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ACC'
       ,'AC1'
       ,'Accidents Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'AC1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'NET'
       ,'Network Manager'
       ,'F'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'NET');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'TOP'
       ,'ROOT'
       ,'SDO Layers'
       ,'F'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'ROOT');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ENQ'
       ,'EN1'
       ,'Enquiry Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'EN1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'AST'
       ,'AS1'
       ,'Asset Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'AS1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'CUS'
       ,'CU1'
       ,'Custom'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'CU1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'MAI'
       ,'MA1'
       ,'Defects Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'MA1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'STR'
       ,'Structures Manager'
       ,'F'
       ,70 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'STR');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'NET'
       ,'NE1'
       ,'Datum Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'NE1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'NET'
       ,'NE2'
       ,'Route Layer'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'NE2');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'NET'
       ,'NE3'
       ,'Node Layer'
       ,'M'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'NE3');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'STR'
       ,'ST1'
       ,'Structure Items'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'ST1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'CLM'
       ,'Street Lighting Manager'
       ,'F'
       ,40 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'CLM');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'CLM'
       ,'CL1'
       ,'Street Lights Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'CL1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'SWR'
       ,'Streetworks Manager'
       ,'F'
       ,80 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'SWR');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'SWR'
       ,'SW1'
       ,'Sites Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'SW1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'NSG'
       ,'Street Gazetteer Manager'
       ,'F'
       ,90 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'NSG');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'NSG'
       ,'NS1'
       ,'NSG Layers'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'NS1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'ACC'
       ,'Accidents Manager'
       ,'F'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'ACC');
                   
COMMIT;
-- AE 12/12/2006 
-- full set of NM_LAYER_TREE metadata

--KA 13/12/2006 MP Referencing
INSERT INTO HIG_USER_OPTION_LIST
       (HUOL_ID
       ,HUOL_PRODUCT
       ,HUOL_NAME
       ,HUOL_REMARKS
       ,HUOL_DOMAIN
       ,HUOL_DATATYPE
       ,HUOL_MIXED_CASE
       )
SELECT 
        'DEFITEMTYP'
       ,'NET'
       ,'Default Reference Item Type'
       ,'Default reference item type for Assets on a Route.'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_USER_OPTION_LIST
                   WHERE HUOL_ID = 'DEFITEMTYP');
                   
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 444;

INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,444
       ,null
       ,'Reference asset types must be point and allowed on the network for the asset location'
       ,'' FROM DUAL;

DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 446;

INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,446
       ,null
       ,'Reference item has more than one location'
       ,'' FROM DUAL;

DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 447;

INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,447
       ,null
       ,'Asset is not located on the specified route'
       ,'' FROM DUAL;

DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 448;

INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,448
       ,null
       ,'Asset has more than one location'
       ,'' FROM DUAL;
       
--KA : load destination and file for mp referencing
declare
  l_new_nld_id nm_load_destinations.nld_id%type;

begin
  l_new_nld_id := nm3seq.next_nld_id_seq;

  INSERT INTO NM_LOAD_DESTINATIONS ( NLD_ID, NLD_TABLE_NAME, NLD_TABLE_SHORT_NAME, NLD_INSERT_PROC,
  NLD_VALIDATION_PROC ) VALUES ( 
  l_new_nld_id, 'V_LOAD_LOCATE_INV_BY_REF', 'LIBR', 'nm3mp_ref.locate_asset', NULL);
exception
 when dup_val_on_index then null;

 when others then raise_application_error(-20001,sqlerrm);  
END;
/


----------------------------------------------------------------
-- 705080
-- nm0530 is not  geared up to be used from locator.
-- therefore remove any theme function references to the module
----------------------------------------------------------------
delete from nm_theme_functions_all
where ntf_hmo_module = 'NM0530'
/


-- GJ 21-DEC-2006
-- 44300 - error message for additional check plugged into mai2110c.pkb
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 445;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,445
       ,null
       ,'Asset item with this primary key/asset type/start date already exists'
       ,'' FROM DUAL;

----------------------------------------------------------------
-- MH 12-JAN-2007
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'NET'
  AND  NER_ID = 438;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,438
       ,null
       ,'Query must be restricted by at least Asset Type or Primary Key or Use Advanced Query on Floating Toolbar'
       ,'More restrictive query criteria are required' FROM DUAL;
--
--
--


-- SSC
-- Meta-Data to support new modules MAI3811 and MAI3815
--------------------------------------------------------------------------
--
-- as part of this work, sort out the sub-menu of standard favourites
-- i.e. the ordering of menu options needs attention
delete from hig_standard_favourites
where hstf_parent in ('MAI_INSP','MAI_WORKS')
/
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI3808', 'Inspections', 'M', 10);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI3899', 'Inspections by Group', 'M', 20);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI3806', 'Defects', 'M', 30);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI3810', 'View Defects', 'M', 40);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI3815', 'View Defect History', 'M', 50);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI3816', 'Responses to Notices', 'M', 60);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI2730', 'Match Duplicate Defects', 'M', 70);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI2760', 'Unmatch Duplicate Defects', 'M', 80);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI2470', 'Delete Inspections', 'M', 90);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI2775', 'Batch Setting of Repair Dates', 'M', 100);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI_INSP_REPORTS', 'Reports', 'F', 110);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3800', 'Works Orders (Defects)', 'M', 10);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3800A', 'Works Orders (Cyclic)', 'M', 20);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3802', 'Maintain Work Orders - Contractor Interface', 'M', 30);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3811', 'View Work Order Line History', 'M', 40);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3805', 'Gang/Crew Allocation', 'M', 50);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3848', 'Work Orders Authorisation', 'M', 60);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3804', 'View Cyclic Maintenance Work', 'M', 70);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3860', 'Cyclic Maintenance Schedules', 'M', 80);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3862', 'Cyclic Maintenance Schedules by Road Section', 'M', 90);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3825', 'Maintenance Report', 'M', 100);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3610', 'Cancel Work Orders', 'M', 110);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3820', 'Quality Inspection Results', 'M', 120);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI1280', 'External Activities', 'M', 130);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI_WORKS_REPORTS', 'Reports', 'F', 140);
COMMIT ;

-- SS
-- Meta-Data to support new modules MAI3811 and MAI3815
--------------------------------------------------------------------------


--
-- CH NADL csv loader enablement
--
declare
l_chk pls_integer;
l_nld_id number;
begin

  SELECT count(*)
  INTO l_chk
  FROM nm_load_destinations
  WHERE NLD_TABLE_NAME = 'NM_NW_AD_LINK_ALL'
  AND  NLD_TABLE_SHORT_NAME = 'NWAD';
  
  IF l_chk = 0 THEN

    select nld_id_seq.nextval
    into l_nld_id
    from dual;

    INSERT INTO NM_LOAD_DESTINATIONS 
    ( NLD_ID
    , NLD_TABLE_NAME
    , NLD_TABLE_SHORT_NAME
    , NLD_INSERT_PROC
    , NLD_VALIDATION_PROC ) 
    VALUES 
    ( l_nld_id
    , 'NM_NW_AD_LINK_ALL'
    , 'NWAD'
    , ' NM3NWAD.INS_NADL'
    , NULL); 
 


    INSERT INTO NM_LOAD_DESTINATION_DEFAULTS 
    (  NLDD_NLD_ID
    , NLDD_COLUMN_NAME
    , NLDD_VALUE ) 
    VALUES 
    ( l_nld_id
    , 'NAD_END_DATE'
    , 'ne.ne_end_date'); 
  
    INSERT INTO NM_LOAD_DESTINATION_DEFAULTS 
    ( NLDD_NLD_ID
    , NLDD_COLUMN_NAME
    , NLDD_VALUE ) 
    VALUES 
    (l_nld_id
    , 'NAD_GTY_TYPE'
    , 'ne.ne_gty_group_type'); 
  
    INSERT INTO NM_LOAD_DESTINATION_DEFAULTS 
    ( NLDD_NLD_ID
    , NLDD_COLUMN_NAME
    , NLDD_VALUE ) 
    VALUES 
    (l_nld_id
    , 'NAD_IIT_NE_ID'
    , 'iit.iit_ne_id'); 
  
    INSERT INTO NM_LOAD_DESTINATION_DEFAULTS 
    ( NLDD_NLD_ID
    , NLDD_COLUMN_NAME
    , NLDD_VALUE ) 
    VALUES 
    (l_nld_id
    , 'NAD_INV_TYPE'
    , 'iit.iit_inv_type'); 
  
    INSERT INTO NM_LOAD_DESTINATION_DEFAULTS 
    ( NLDD_NLD_ID
    , NLDD_COLUMN_NAME
    , NLDD_VALUE ) 
    VALUES 
    (l_nld_id
    , 'NAD_NE_ID'
    , 'ne.ne_id'); 
  
    INSERT INTO NM_LOAD_DESTINATION_DEFAULTS 
    ( NLDD_NLD_ID
    , NLDD_COLUMN_NAME
    , NLDD_VALUE ) 
     VALUES 
    (l_nld_id
    , 'NAD_NT_TYPE'
    , 'ne.ne_nt_type'); 
   
    INSERT INTO NM_LOAD_DESTINATION_DEFAULTS 
    ( NLDD_NLD_ID
    , NLDD_COLUMN_NAME
    , NLDD_VALUE ) 
    VALUES 
    (l_nld_id
  , 'NAD_START_DATE'
  , 'ne.ne_start_Date'); 

   commit;
   
 END IF;   
 
end;
/



DECLARE
--
-- HIG_OPTION_LIST and HIG_OPTION_VALUES
--
   l_tab_hol_id         nm3type.tab_varchar30;
   l_tab_hol_product    nm3type.tab_varchar30;
   l_tab_hol_name       nm3type.tab_varchar30;
   l_tab_hol_remarks    nm3type.tab_varchar2000;
   l_tab_hol_domain     nm3type.tab_varchar30;
   l_tab_hol_datatype   nm3type.tab_varchar30;
   l_tab_hol_mixed_case nm3type.tab_varchar30;
   l_tab_hol_user_option nm3type.tab_varchar30;
   l_tab_hov_value      nm3type.tab_varchar2000;
--
   c_y_or_n CONSTANT    hig_domains.hdo_domain%TYPE := 'Y_OR_N';
--
   PROCEDURE add (p_hol_id         VARCHAR2
                 ,p_hol_product    VARCHAR2
                 ,p_hol_name       VARCHAR2
                 ,p_hol_remarks    VARCHAR2
                 ,p_hol_domain     VARCHAR2 DEFAULT Null
                 ,p_hol_datatype   VARCHAR2 DEFAULT nm3type.c_varchar
                 ,p_hol_mixed_case VARCHAR2 DEFAULT 'N'
                 ,p_hol_user_option VARCHAR2 DEFAULT 'N'
                 ,p_hov_value      VARCHAR2 DEFAULT NULL
                 ) IS
      c_count PLS_INTEGER := l_tab_hol_id.COUNT+1;
   BEGIN
      l_tab_hol_id(c_count)         := p_hol_id;
      l_tab_hol_product(c_count)    := p_hol_product;
      l_tab_hol_name(c_count)       := p_hol_name;
      l_tab_hol_remarks(c_count)    := p_hol_remarks;
      l_tab_hol_domain(c_count)     := p_hol_domain;
      l_tab_hol_datatype(c_count)   := p_hol_datatype;
      l_tab_hol_mixed_case(c_count) := p_hol_mixed_case;
      l_tab_hol_user_option(c_count) := p_hol_user_option;
      l_tab_hov_value(c_count)      := p_hov_value;
   END add;
BEGIN



--
-- 01-FEB-2007 new option for AR
--
   add(p_hol_id          => 'WEBMAPPRDS'
      ,p_hol_product     => 'WMP'
      ,p_hol_name        => 'Preferred Data Source'
      ,p_hol_remarks     => 'Preferred Data Source'
      ,p_hol_domain      => Null
      ,p_hol_datatype    => 'VARCHAR2'
      ,p_hol_mixed_case  => 'N'
      ,p_hol_user_option => 'Y'
      ,p_hov_value       => Null);
      
--
-- 07-FEB-2007 new option for GJ
--
   add(p_hol_id          => 'ALLOWDEBUG'
      ,p_hol_product     => 'HIG'
      ,p_hol_name        => 'Allow debug'
      ,p_hol_remarks     => 'Allow debug'
      ,p_hol_domain      => 'Y_OR_N'
      ,p_hol_datatype    => 'VARCHAR2'
      ,p_hol_mixed_case  => 'N'
      ,p_hol_user_option => 'N'
      ,p_hov_value       => 'N');
      
   FORALL i IN 1..l_tab_hol_id.COUNT
      INSERT INTO hig_option_list
            (hol_id
            ,hol_product
            ,hol_name
            ,hol_remarks
            ,hol_domain
            ,hol_datatype
            ,hol_mixed_case
            ,hol_user_option
            )
      SELECT l_tab_hol_id(i)
            ,l_tab_hol_product(i)
            ,l_tab_hol_name(i)
            ,l_tab_hol_remarks(i)
            ,l_tab_hol_domain(i)
            ,l_tab_hol_datatype(i)
            ,l_tab_hol_mixed_case(i)
            ,l_tab_hol_user_option(i)
        FROM dual
      WHERE  NOT EXISTS (SELECT 1
                          FROM  hig_option_list
                         WHERE  hol_id = l_tab_hol_id(i)
                        );
--
   FORALL i IN 1..l_tab_hol_id.COUNT
      INSERT INTO hig_option_values
            (hov_id
            ,hov_value
            )
      SELECT l_tab_hol_id(i)
            ,l_tab_hov_value(i)
        FROM dual
      WHERE  l_tab_hov_value(i) IS NOT NULL
       AND   NOT EXISTS (SELECT 1
                          FROM  hig_option_values
                         WHERE  hov_id = l_tab_hol_id(i)
                        );
--
END;
/

COMMIT;

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT HSTF for NSG Forms
SET TERM OFF

-- GJ  03-APR-2007
-- 
-- ASSOCIATED LOG#
-- 707840
-- 
-- CUSTOMER
-- Western Power Distribution
-- 
-- PROBLEM
-- It would appear that during the weekend upgrade from SWM to Atlas the Gazetteer for Highways Agency 0011 was not loaded 
-- Also please see pick list from Maintain NSG Gazetteer screen which shows duplications and incorrect HA codes
-- 
-- DEVELOPMENT COMMENTS
-- Re-jig modules under the NSG_DATA branch of the tree.
-- Incorporate the two new modules NSG0070 and NSG0080
------------------------------------------------------------------
delete from hig_standard_favourites
where hstf_parent = 'NSG_DATA'
/


INSERT INTO hig_standard_favourites
            (hstf_parent
           , hstf_child
           , hstf_descr
           , hstf_type
           , hstf_order
            )
     VALUES ('NSG_DATA'
           , 'NSG0010'
           , 'NSG Gazetteer'
           , 'M'
           , 10);


INSERT INTO hig_standard_favourites
            (hstf_parent
           , hstf_child
           , hstf_descr
           , hstf_type
           , hstf_order
            )
     VALUES ('NSG_DATA'
           , 'NSG0060'
           , 'Locations'
           , 'M'
           , 20); 


INSERT INTO hig_standard_favourites
            (hstf_parent
           , hstf_child
           , hstf_descr
           , hstf_type
           , hstf_order
            )
     VALUES ('NSG_DATA'
           , 'NSG0070'
           , 'Highways Authorities'
           , 'M'
           , 30
            ); 

INSERT INTO hig_standard_favourites
            (hstf_parent
           , hstf_child
           , hstf_descr
           , hstf_type
           , hstf_order
            )
     VALUES ('NSG_DATA'
           , 'NSG0080'
           , 'Naming Authorities'
           , 'M'
           , 40
            );
            
INSERT INTO hig_standard_favourites
            (hstf_parent
           , hstf_child
           , hstf_descr
           , hstf_type
           , hstf_order
            )
     VALUES ('NSG_DATA'             
           , 'NSG_DATA_ADMIN'
           , 'Administration'
           , 'F'
           , 50); 

COMMIT;
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Remove redundant HSTF for MAI3811/MAI3815
SET TERM OFF

-- GJ  03-APR-2007
-- 
-- DEVELOPMENT COMMENTS
-- Modules no longer required
------------------------------------------------------------------
delete from hig_standard_favourites
where hstf_child in ('MAI3815','MAI3811')
/
commit
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Java priv level option
SET TERM OFF

-- MH  03-APR-2007
-- 
-- DEVELOPMENT COMMENTS
-- New Product Option used by hig1895.fmx to determine which Java Privs Tab(s) To Enable.
------------------------------------------------------------------
--
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'JPRIVLEVEL'
       ,'HIG'
       ,'Java Privs Level'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'JPRIVLEVEL');

--
INSERT INTO HIG_CODES
       (HCO_DOMAIN
       ,HCO_CODE
       ,HCO_MEANING
       ,HCO_SYSTEM
       ,HCO_SEQ
       ,HCO_START_DATE
       ,HCO_END_DATE
       )
SELECT 
        'JPRIVLEVEL'
       ,'R'
       ,'Role Level'
       ,'Y'
       ,1
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'JPRIVLEVEL'
                    AND  HCO_CODE = 'R');
--
INSERT INTO HIG_CODES
       (HCO_DOMAIN
       ,HCO_CODE
       ,HCO_MEANING
       ,HCO_SYSTEM
       ,HCO_SEQ
       ,HCO_START_DATE
       ,HCO_END_DATE
       )
SELECT 
        'JPRIVLEVEL'
       ,'U'
       ,'User Level'
       ,'Y'
       ,2
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'JPRIVLEVEL'
                    AND  HCO_CODE = 'U');
--
INSERT INTO HIG_CODES
       (HCO_DOMAIN
       ,HCO_CODE
       ,HCO_MEANING
       ,HCO_SYSTEM
       ,HCO_SEQ
       ,HCO_START_DATE
       ,HCO_END_DATE
       )
SELECT 
        'JPRIVLEVEL'
       ,'B'
       ,'Both Role And User Level'
       ,'Y'
       ,3
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'JPRIVLEVEL'
                    AND  HCO_CODE = 'B');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       ,HOL_USER_OPTION
       )
SELECT 
        'JPRIVLEVEL'
       ,'HIG'
       ,'Java Privs Level'
       ,'Level at Which Java Priviliges Are Granted For Oracle Directories, R = Role, U = User, B = Both'
       ,'JPRIVLEVEL'
       ,'VARCHAR2'
       ,'N'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'JPRIVLEVEL');
--
INSERT INTO HIG_OPTION_VALUES
       (HOV_ID
       ,HOV_VALUE
       )
SELECT 
        'JPRIVLEVEL'
       ,'R' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'JPRIVLEVEL');
--
COMMIT;
--
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Add Schemes Manager SDO Layer option for GIS0020
SET TERM OFF

-- AE  04-APR-2007
-- 
-- DEVELOPMENT COMMENTS
-- Create entries in NM_LAYER_TREE so that GIS0020 can allow user to create Scheme ROAD CONSTRUCTION and ASSET SDO layers
------------------------------------------------------------------
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'STP'
       ,'SP1'
       ,'Schemes Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'SP1');
--
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT 
        'ROOT'
       ,'STP'
       ,'Schemes Manager'
       ,'F'
       ,100 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'STP');

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Refresh Merge Views
SET TERM OFF

-- GJ  05-APR-2007
-- 
-- ASSOCIATED LOG#
-- 706744
-- 
-- CUSTOMER
-- Main Roads Western Australia
-- 
-- PROBLEM
-- There is a bug in merge file output whereby the view which created to facilitate the extraction of the data (in my case MRG_OUTPUT_25_V (where 25 is the NMF_ID)). This error is occurring because the standard merge view no longer has the NMS_MRG_JOB_ID column, but instead has NQR_MRG_JOB_ID
-- 
-- DEVELOPMENT COMMENTS
-- Refresh merge views
------------------------------------------------------------------
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
       '&terminator'||'utl'||'&terminator'||'refresh_merge_views.sql' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Update NMWEB0043 HIG_MODULES
SET TERM OFF

-- JWA  12-APR-2007
-- 
-- ASSOCIATED LOG#
-- 708160
-- 
-- CUSTOMER
-- Exor Corporation Ltd
-- 
-- PROBLEM
-- Clive Hackforth says the metadata for nmweb0043 points to nm3 file.web_download_from_dir   It should point to nm3file.web_upload_to_dir.     Please amend.
-- 
-- DEVELOPMENT COMMENTS
-- HIG_MODULES was pointing at the incorrect file.
------------------------------------------------------------------
update hig_modules set hmo_filename = 'nm3file.web_download_to_dir' where hmo_module = 'NMWEB0043';
------------------------------------------------------------------


------------------------------------------------------------------

------------------------------------------------------------------
COMMIT
/
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

