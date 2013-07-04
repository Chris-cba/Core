REM Copyright 2013 Bentley Systems Incorporated. All rights reserved.
-- sccsid : @(#)pre_mig_inst.sql	1.20 05/14/07 
-- Module Name : pre_mig_inst.sql 
-- Date into SCCS : 07/05/14 17:19:50 
-- Date fetched Out : 07/06/13 14:09:34 
-- SCCS Version : 1.20

--
---------------------------------------------------------------------------------------
--
SET FEEDBACK OFF
SET ECHO OFF
SET TERM ON
WHENEVER SQLERROR CONTINUE
--
-- Grab date/time to append to log file names this is standard to all upgrade/install scripts
--
undefine log_extension
col      log_extension new_value log_extension noprint
set term off
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
set term on
--
---------------------------------------------------------------------------------------------------
--
--
-- Spool to Logfile
--
define logfile='pre_migration_install_&log_extension'
spool &logfile
--
---------------------------------------------------------------------------------------------------
--
select 'Installation Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MM:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;

prompt
prompt Highways by Exor - Pre-Migration Checker Setup
prompt ==============================================
PROMPT Creating Objects...
SET TERM OFF
DROP TABLE PRE_MIGRATION_CHK_CLASSES CASCADE CONSTRAINTS;

CREATE TABLE PRE_MIGRATION_CHK_CLASSES
(
  PMCL_CODE   VARCHAR2(3)                  NOT NULL,
  PMCL_LABEL  VARCHAR2(30)                 NOT NULL,
  PMCL_ORDER  NUMBER(2)                    NOT NULL
)
LOGGING 
NOCACHE
NOPARALLEL;


CREATE UNIQUE INDEX PK_PRE_MIGRATION_CHK_CLASSES ON PRE_MIGRATION_CHK_CLASSES
(PMCL_CODE)
LOGGING
NOPARALLEL;



ALTER TABLE PRE_MIGRATION_CHK_CLASSES ADD (
  CONSTRAINT PK_PRE_MIGRATION_CHK_CLASSES PRIMARY KEY (PMCL_CODE));

DROP TABLE PRE_MIGRATION_CHECK_OBJS;
--
---------------------------------------------------------------------------------------
--
CREATE TABLE PRE_MIGRATION_CHECK_OBJS
(
  TABLE_NAME   VARCHAR2(30),
  OBJECT_TYPE  CHAR(1),
  OBJECT_NAME  VARCHAR2(30),
  PRODUCT      VARCHAR2(4)
)
LOGGING 
NOCACHE
NOPARALLEL;

CREATE UNIQUE INDEX PMC_UK1
 ON PRE_MIGRATION_CHECK_OBJS(PRODUCT, OBJECT_TYPE, OBJECT_NAME);
--
---------------------------------------------------------------------------------------
--
DROP TABLE PRE_MIGRATION_CHK CASCADE CONSTRAINTS;

CREATE TABLE PRE_MIGRATION_CHK
(
  PMC_REF          VARCHAR2(50)                 NOT NULL,
  PMC_ORDER        NUMBER(3)                    NOT NULL,
  PMC_CHECK_LABEL  VARCHAR2(50),
  PMC_DESCRIPTION  VARCHAR2(2000)               NOT NULL,
  PMC_OUTCOME      VARCHAR2(20)                 DEFAULT 'UNTESTED',
  PMC_NOTES        VARCHAR2(2000),
  PMC_START        DATE,
  PMC_END          DATE,
  PMC_PMCL_CODE    VARCHAR2(3)                  NOT NULL
)
LOGGING 
NOCACHE
NOPARALLEL;


CREATE UNIQUE INDEX PMC_PK ON PRE_MIGRATION_CHK
(PMC_REF)
NOLOGGING
NOPARALLEL;


ALTER TABLE PRE_MIGRATION_CHK ADD (
  CONSTRAINT PMC_PK PRIMARY KEY (PMC_REF));
--
---------------------------------------------------------------------------------------
--
DROP TABLE PRE_MIGRATION_CHK_ISSUES CASCADE CONSTRAINTS;

CREATE TABLE PRE_MIGRATION_CHK_ISSUES
(
  PMCI_PMC_REF      VARCHAR2(50)           NOT NULL,
  PMCI_ISSUE_LABEL  VARCHAR2(200)          NOT NULL,
  PMCI_DETAILS      VARCHAR2(500)          NOT NULL
)
LOGGING 
NOCACHE
NOPARALLEL;


CREATE INDEX PMCI_IND1 ON PRE_MIGRATION_CHK_ISSUES
(PMCI_PMC_REF, PMCI_ISSUE_LABEL)
LOGGING
NOPARALLEL;
--
---------------------------------------------------------------------------------------
--
SET TERM ON
PROMPT Creating Meta-Data...
SET TERM OFF
--
INSERT INTO PRE_MIGRATION_CHK_CLASSES ( PMCL_CODE, PMCL_LABEL,
PMCL_ORDER ) VALUES ( 
'RN', 'Road Network', 1); 
INSERT INTO PRE_MIGRATION_CHK_CLASSES ( PMCL_CODE, PMCL_LABEL,
PMCL_ORDER ) VALUES ( 
'GRP', 'Groups and Memberships', 2); 
INSERT INTO PRE_MIGRATION_CHK_CLASSES ( PMCL_CODE, PMCL_LABEL,
PMCL_ORDER ) VALUES ( 
'INV', 'Inventory Data', 3); 
INSERT INTO PRE_MIGRATION_CHK_CLASSES ( PMCL_CODE, PMCL_LABEL,
PMCL_ORDER ) VALUES ( 
'INH', 'Hierarchical Inventory Data', 4); 
INSERT INTO PRE_MIGRATION_CHK_CLASSES ( PMCL_CODE, PMCL_LABEL,
PMCL_ORDER ) VALUES ( 
'INF', 'Inventory Attribute Failure', 5); 
INSERT INTO PRE_MIGRATION_CHK_CLASSES ( PMCL_CODE, PMCL_LABEL,
PMCL_ORDER ) VALUES ( 
'SPA', 'Spatial Data', 6); 
INSERT INTO PRE_MIGRATION_CHK_CLASSES ( PMCL_CODE, PMCL_LABEL,
PMCL_ORDER ) VALUES ( 
'DOC', 'Documents', 7); 
INSERT INTO PRE_MIGRATION_CHK_CLASSES ( PMCL_CODE, PMCL_LABEL,
PMCL_ORDER ) VALUES ( 
'MSC', 'Miscellaneous', 8); 
COMMIT;
--
---------------------------------------------------------------------------------------
--
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'check_points', 1, 'CHECKING POINTS', 'POINTS need X,Y (ideally).
This is NOT mandatory but if the system is to be used with a gis then it will be a pre-requisite for successful operation of SDM.  The X,Ys can be populated after the migration.'
, 'UNTESTED', NULL, NULL, NULL, 'RN'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'system_start_dates', 2, 'START DATES', 'Start dates of everything cannot pre-date the system start date (hard-coded).
This should be ascertained before onset of migration.
The start date should be the earliest possible date that any data may exist in the system.
Query the minimum start date on nodes, road_segs and inv_items_all.
Use this as an appropriate system start date. If this date is nonsense then repair it.'
, 'UNTESTED', NULL, NULL, NULL, 'RN'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'date_triggers', 3, 'DATE TRIGGERS', 'NM3 contains date triggers to validate dates entered.
This shows a list of potential invalid dates due to start dates being after end dates
'
, 'UNTESTED', NULL, NULL, NULL, 'RN'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'nodes_FK_points', 5, 'NODES', 'a) Node Usages Associated With Non-Existent Points
b) Node Usages Associated With Non-Existent Road Segs
'
, 'UNTESTED', NULL, NULL, NULL, 'RN'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'rse_node_date_check', 6, 'ROAD SECTION DATES', 'a) Nodes that post-date the start of associated section (this will be automatically reset by the migration if you do not change it).'
, 'UNTESTED', NULL, NULL, NULL, 'RN'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'check_section_class', 8, 'SECTION CLASSES', 'Checks section classes foreign key is imposed.'
, 'UNTESTED', NULL, NULL, NULL, 'RN'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'section_and_group_lengths', 10, 'SECTION AND GROUP LENGTHS', 'Show sections with an invalid length i.e. section lengths must be non-zero, not null and an integer.
Shows groups with an invalid length i.e. groups must not have a length specified.'
, 'UNTESTED', NULL, NULL, NULL, 'RN'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'check_intervals', 11, 'INTERVAL ATTRIBUTE', 'Intervals must exist for each network element.'
, 'UNTESTED', NULL, NULL, NULL, 'RN'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'check_rse_admin_unit_fk', 12, 'SECTION/GROUP ADMIN UNIT EXISTS', 'Check that admin unit specified against a section/group exists.  Also check that in road seg membs, the OF must be related to the IN by admin unit.'
, 'UNTESTED', NULL,  NULL,  NULL, 'RN'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'check_rse_unique_uppercase', 13, 'RSE_UNIQUE IS UPPERCASE', 'Check that RSE_UNIQUE is uppercase'
, 'UNTESTED', NULL, NULL, NULL, 'RN'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'groups_members', 14, 'GROUP MEMBERS', 'a) Memberships where Top Group Start Date is Pre RSE Start Date
b) Memberships where Group Start Date is Pre RSE Start Date
c) Memberships where Section Start Date is Pre RSE Start Date
d) Group of Groups with Sections/Groups of Sections with Groups'
, 'UNTESTED', NULL, NULL, NULL, 'GRP'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'sections_links_relate', 15, 'SECTION/LINK RELATIONSHIP', 'Check that every section with a linkcode has a valid link entry in Road_segs.'
, 'UNTESTED', NULL, NULL, NULL, 'GRP'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'group_exclusivity', 16, 'GROUP EXCLUSIVITY', 'Check that any group type memberships that are flagged as exclusive are indeed exclusve (i.e. a section can only be in 1 group of that type)'
, 'UNTESTED', NULL, NULL, NULL, 'GRP'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'point_contiguous', 18, 'POINT CONTIGUOUS', 'Check that point data types are not flagged as contiguous.'
, 'UNTESTED', NULL, NULL, NULL, 'INV'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'inv_locations', 20, 'INVENTORY LOCATIONS', 'Check that all inventory locations exist and that the inventory start date post dates the road start date. '
, 'UNTESTED', NULL, NULL, NULL, 'INV'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'inv_start_end_check', 23, 'INVENTORY START/END CHECK', 'a) Point Items with Multiple Locations
b) Linear Items With Start Chain >= End Chain'
, 'UNTESTED', NULL, NULL, NULL, 'INV'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'inv_start_end_count', 24, 'INVENTORY START/END COUNT', 'Check that inventory start and END measures are consistent with the sections lengths. '
, 'UNTESTED', NULL, NULL, NULL, 'INV'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'valid_xsp', 25, 'INVENTORY XSPS', 'Check that inventory XSPs are valid', 'UNTESTED'
, NULL, NULL, NULL, 'INV'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'inv_type_exclusive', 26, 'INVENTORY TYPE EXCLUSIVITY', 'Check that inventory types are exclusive and do not overlap.'
, 'UNTESTED', NULL, NULL, NULL, 'INV'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'inv_uniqueness', 27, 'INVENTORY UNIQUE KEYS', 'Check for Duplicate IIT_PRIMARY_KEYS and violation of unique constraint IIT_UK '
, 'UNTESTED', NULL, NULL, NULL, 'INV'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'inv_type_valid', 28, 'INVENTORY TYPE VALIDITY', 'Check that inventory type reference on an inventory item actually exists'
, 'UNTESTED', NULL, NULL, NULL, 'INV'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'inventory_hierarchy', 29, 'INVENTORY TYPE RELATIONS', 'a) Records Where Parent Has Valid Children of Valid Types But Parent Itself Is Of An Invalid Type
b) Records where Child Has A Valid Type But Has A Parent That Does Not Exist
c) Records where Child Item Has No Foreign Key Even Though Type Is Child Type
d) Records where Parent Type Does Not Exist
e) Records where no child records in inv_item_types'
, 'UNTESTED', NULL, NULL, NULL, 'INH'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'hier_inv_dangling', 30, 'INVENTORY HIERARCHY', 'a) Child Inv types with invalid parents
b) Child Inv Items with Parents but Invalid
c) Items with Null Foriegn/Primary Key
d) Child Items with No Parents'
, 'UNTESTED', NULL, NULL, NULL, 'INH'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'fk_incorrect1', 31, 'INVENTORY FOREIGN KEY CHECK', 'Checks that inventory foreign key field is set for mandatory sub items.'
, 'UNTESTED', NULL, NULL, NULL, 'INH'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'hier_inv_locations', 32, 'INVENTORY HIERARCHY LOCATIONS', 'Check that child inventory item locations match those of thier parents.'
, 'UNTESTED', NULL, NULL, NULL, 'INH'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'fk_incorrect2', 33, 'NON-HIERARCHICAL INVENTORY FOREIGN KEYS', 'Checks that inventory foreign key field is not in use if not hierarchical.'
, 'UNTESTED', NULL, NULL, NULL, 'INH'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'hier_inv_dates', 34, 'HIERARCHICAL INVENTORY DATES', 'Checks that parent inventory item start date is before childs and that END date is after childs.'
, 'UNTESTED', NULL, NULL, NULL, 'INH'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'check_roles', 35, 'INVENTORY CATEGORY ROLES', 'Migration of INV_CATEGORY_ROLES to individual NM_INV_TYPE_ROLES - ALL ROLES must exist as HIG_ROLES and exist as database roles'
, 'UNTESTED', NULL, NULL, NULL, 'INH'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'check_inv_attr_valid_col', 36, 'INVENTORY ATTRIBUTE COLUMN USAGE', 'Checks that inventory attributes reference a valid column on INV_ITEMS_ALL i.e. a nullable column'
, 'UNTESTED', NULL, NULL, NULL, 'INH'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'check_inv_attr', 37, 'INVENTORY ATTRIBUTES', 'Check that the column data type in which the attribute resides supports the format of the inv attr data.'
, 'UNTESTED', NULL, NULL, NULL, 'INF'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'check_lookup_varchar', 38, 'INVENTORY DOMAIN LOOKUPS', 'Check that inventory domain lookups are in character columns. '
, 'UNTESTED', NULL, NULL, NULL, 'INF'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'check_inv_min_max', 39, 'INVENTORY DOMAIN RANGE', 'Check that inventory range/domain valus are mutually exclusive'
, 'UNTESTED', NULL, NULL, NULL, 'INF'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'check_reserved_words', 40, 'NM3 RESERVED WORD CHECK', 'Check for NM3 keywords in the inventory view column definitions.'
, 'UNTESTED', NULL, NULL, NULL, 'INF'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'domain_lookup_failure', 41, 'INVENTORY DOMAIN VALUES', 'a) Attributes That Are Not Using a Valid Column in INV_ITEMS_ALL
b) Inventory Attributes With Value Not in Domain'
, 'UNTESTED', NULL, NULL, NULL, 'INF'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'check_attr_range', 43, 'ATTRIBUTE RANGE', 'Check that values are within attributes range.'
, 'UNTESTED', NULL, NULL, NULL, 'INF'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'check_attr_length', 44, 'ATTRIBUTE LENGTH', 'Check that inventory attribute length does not conflict with its values.'
, 'UNTESTED', NULL, NULL, NULL, 'INF'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'check_mandatory_attr', 45, 'CHECK MANDATORY ATTRIBUTES', 'Check that mandatory attributes are populated'
, 'UNTESTED', NULL, NULL, NULL, 'INF'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'check_shape', 46, 'SPATIAL DATA CHECKS', 'a) Each Road section should only have one shape.
b) All shapes should relate to road sections.
c) No null shapes. '
, 'UNTESTED', NULL, NULL, NULL, 'SPA'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'check_xsp_sys_flag', 51, 'XSP RESTRAINTS SYS FLAG', 'a) Check that sys_flag is either L or D
b) All xsp values should have a valid section class'
, 'UNTESTED', NULL, NULL, NULL, 'INV'); 
INSERT INTO PRE_MIGRATION_CHK ( PMC_REF, PMC_ORDER, PMC_CHECK_LABEL, PMC_DESCRIPTION, PMC_OUTCOME,
PMC_NOTES, PMC_START, PMC_END, PMC_PMCL_CODE ) VALUES ( 
'admin_unit_hierarchy', 53, 'ADMIN UNIT HIERARCHY', 'Check the integrity of Admin Unit hierarchy'
, 'UNTESTED', NULL, NULL, NULL, 'MSC'); 

DECLARE
  l_pre pre_migration_chk%ROWTYPE;
  --
  FUNCTION get_next_order RETURN pls_integer IS
    CURSOR get_next IS
    SELECT NVL(MAX(pmc_order), 0) + 1
    FROM pre_migration_chk;

    l_retval pls_integer;
  BEGIN
   OPEN get_next;
   FETCH get_next INTO l_retval;
   CLOSE get_next;
   
   RETURN l_retval;
  END get_next_order;
--
  PROCEDURE ins_chk(p_pre IN OUT pre_migration_chk%ROWTYPE) IS
  BEGIN
    -- complete any defaults
    p_pre.pmc_outcome := 'UNTESTED';
    p_pre.pmc_order   := get_next_order;
    p_pre.pmc_start   := NULL;
    p_pre.pmc_end     := NULL;  
   
    INSERT INTO pre_migration_chk
    (pmc_ref
    ,pmc_order
    ,pmc_check_label
    ,pmc_description
    ,pmc_outcome
    ,pmc_notes
    ,pmc_start
    ,pmc_end
    ,pmc_pmcl_code)
    VALUES 
    (p_pre.pmc_ref
    ,p_pre.pmc_order
    ,p_pre.pmc_check_label
    ,p_pre.pmc_description
    ,p_pre.pmc_outcome
    ,p_pre.pmc_notes
    ,p_pre.pmc_start
    ,p_pre.pmc_end
    ,p_pre.pmc_pmcl_code);
  END ins_chk;
--
BEGIN
  l_pre.pmc_ref         := 'contact_addresses';
  l_pre.pmc_check_label := 'CHECK_CONTACTS';
  l_pre.pmc_description := 'Check that contacts have valid addresses';
  l_pre.pmc_notes       := NULL;
  l_pre.pmc_pmcl_code   := 'DOC';
  ins_chk(l_pre);

  l_pre.pmc_ref         := 'missing_docs';
  l_pre.pmc_check_label := 'MISSING DOCUMENTS';
  l_pre.pmc_description := 'Document associations that are missing documents';
  l_pre.pmc_notes       := NULL;
  l_pre.pmc_pmcl_code   := 'DOC';
  ins_chk(l_pre);
  
  l_pre.pmc_ref         := 'check_users';
  l_pre.pmc_check_label := 'CHECK USERS';
  l_pre.pmc_description := 'User checks';
  l_pre.pmc_notes       := NULL;
  l_pre.pmc_pmcl_code   := 'MSC';
  ins_chk(l_pre);

  l_pre.pmc_ref         := 'disabled_constraints';
  l_pre.pmc_check_label := 'DISABLED CONSTRAINTS';
  l_pre.pmc_description := 'Disabled constraints should be enabled and any errors or non-conforming data reviewed before attempting migration.  Migration of products may fail if constraints are disabled';
  l_pre.pmc_notes       := NULL;
  l_pre.pmc_pmcl_code   := 'MSC';
  ins_chk(l_pre);
  
  l_pre.pmc_ref         := 'exor_objects';
  l_pre.pmc_check_label := 'EXOR REQUIRED OJBECTS';
  l_pre.pmc_description := 'These objects are part of the Exor 2220 release. Your system may not function correctly without these objects';
  l_pre.pmc_notes       := NULL;
  l_pre.pmc_pmcl_code   := 'MSC';
  ins_chk(l_pre);
  
  l_pre.pmc_ref         := 'extra_objects';
  l_pre.pmc_check_label := 'EXTRA ITEMS';
  l_pre.pmc_description := 'Objects that are not part of the exor product';
  l_pre.pmc_notes       := 'These objects will not be migrated. Contact Exor support if any of these obejcts are required in the migrated system';
  l_pre.pmc_pmcl_code   := 'MSC';
  ins_chk(l_pre);
  
  l_pre.pmc_ref         := 'section_domain_validity';
  l_pre.pmc_check_label := 'SECTION DOMAINS';
  l_pre.pmc_description := 'Road section attributes that are not in the corresponding domain - These values should either be modified or added to the domain';
  l_pre.pmc_notes       := Null;
  l_pre.pmc_pmcl_code   := 'RN';
  ins_chk(l_pre);
  
  l_pre.pmc_ref         := 'future_items';
  l_pre.pmc_check_label := 'FUTURE ITEMS';
  l_pre.pmc_description := 'Items that have a start date in the future.';
  l_pre.pmc_notes       := 'These items will not fail migration, but may well be incorrect';
  l_pre.pmc_pmcl_code   := 'MSC';
  ins_chk(l_pre);

  l_pre.pmc_ref         := 'other_locations';
  l_pre.pmc_check_label := 'OTHER LOCATIONS';
  l_pre.pmc_description := 'Items located outside the extent of the Section.';
  l_pre.pmc_notes       := 'These items will not fail migration, but will fail to be dynsegged for display';
  l_pre.pmc_pmcl_code   := 'MSC';
  ins_chk(l_pre);

  l_pre.pmc_ref         := 'orphan_hig_codes';
  l_pre.pmc_check_label := 'ORPHAN HIG CODES';
  l_pre.pmc_description := 'HIG_CODE domain values that dont have a corresponding entry in HIG_DOMAINS.';
  l_pre.pmc_notes       := null;
  l_pre.pmc_pmcl_code   := 'MSC';
  ins_chk(l_pre);

  l_pre.pmc_ref         := 'invalid_load_columns';
  l_pre.pmc_check_label := 'INVALID MAI LOAD Columns';
  l_pre.pmc_description := 'Attribute Columns Listed on Asset Load Definitions.';
  l_pre.pmc_notes       := null;
  l_pre.pmc_pmcl_code   := 'MSC';
  ins_chk(l_pre);

  l_pre.pmc_ref         := 'check_mai_table_columns';
  l_pre.pmc_check_label := 'MAI Column Order';
  l_pre.pmc_description := 'Column Ordering on DEFECTS, INV_ITEM_TYPES,ACTIVITIES,ACTIVITIES_REPORTS and REPAIRS';
  l_pre.pmc_notes       := null;
  l_pre.pmc_pmcl_code   := 'MSC';
  ins_chk(l_pre);

  l_pre.pmc_ref         := 'check_wo';
  l_pre.pmc_check_label := 'Works Orders Columns';
  l_pre.pmc_description := 'All Works Orders must have Road type and Road id populated';
  l_pre.pmc_notes       := null;
  l_pre.pmc_pmcl_code   := 'MSC';
  ins_chk(l_pre);

  l_pre.pmc_ref         := 'check_insp_initials';
  l_pre.pmc_check_label := 'Inspectors Initials';
  l_pre.pmc_description := 'Check that all Inventory Inspected by values exist as Users';
  l_pre.pmc_notes       := null;
  l_pre.pmc_pmcl_code   := 'MSC';
  ins_chk(l_pre);
  
  l_pre.pmc_ref         := 'section_mandatory_values';
  l_pre.pmc_check_label := 'Mandatory Section Attribute Values';
  l_pre.pmc_description := 'Check that Section Mandatory Values are populated';
  l_pre.pmc_notes       := null;
  l_pre.pmc_pmcl_code   := 'RN';
  ins_chk(l_pre);

END;
/ 
  
  
--
---------------------------------------------------------------------------------------
--
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_BANDS', 'C', 'AAB_FK_AAT', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_BANDS', 'C', 'AAB_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_BANDS', 'C', 'AAB_UK1', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_DOMAIN', 'C', 'AAD_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_DOMAIN', 'C', 'AAD_UK1', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_GROUPS', 'C', 'AAG_FK_AIT', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_GROUPS', 'C', 'AAG_FK_HUS', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_GROUPS', 'C', 'AAG_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_GROUPS', 'C', 'AAG_UK1', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_LOOKUP', 'C', 'AAL_FK_AAD', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_LOOKUP', 'C', 'AAL_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_MEMBS', 'C', 'AAM_FK_AAG', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_MEMBS', 'C', 'AAM_FK_AAV', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_MEMBS', 'C', 'AAM_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_TYPES', 'C', 'AAT_FK_AAD', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_TYPES', 'C', 'AAT_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_TYPES', 'C', 'AAT_UK1', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_VALID', 'C', 'AAV_FK_AAT', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_VALID', 'C', 'AAV_FK_AIT', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_VALID', 'C', 'AAV_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_BATCH_FILES', 'C', 'ABF_FK_ALB', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_BATCH_FILES', 'C', 'ABF_FK_ALF', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_BATCH_FILES', 'C', 'ABF_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_FACTOR_GRID', 'C', 'AFG_FK_AAG', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_FACTOR_GRID', 'C', 'AFG_FK_AGR', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_FACTOR_GRID', 'C', 'AFG_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_FACTOR_GRID_ATTR', 'C', 'AFGA_FK_AFG', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_FACTOR_GRID_HEADER', 'C', 'AFGH_FK_AFG', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_FACTOR_GRID_HEADER', 'C', 'AGH_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_FACTOR_GRID_PAGE', 'C', 'AFGP_FK_AFGH', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUPS', 'C', 'AGR_FK_AGR', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUPS', 'C', 'AGR_FK_ALB', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUPS', 'C', 'AGR_FK_HUS', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUPS', 'C', 'AGR_FK_QRY', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUPS', 'C', 'AGR_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUPS', 'C', 'AGR_UN', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUP_ACCIDENTS', 'C', 'AGA_FK_ACC', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUP_ACCIDENTS', 'C', 'AGA_FK_AGR', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUP_ACCIDENTS', 'C', 'AGA_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUP_BS_DATES', 'C', 'AGB_FK_AGR', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUP_BS_DATES', 'C', 'AGB_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUP_MATRIX', 'C', 'AGM_FK_AAV_1', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUP_MATRIX', 'C', 'AGM_FK_AGR', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUP_STATISTICS', 'C', 'AGS_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_IMAGES', 'C', 'AI_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL', 'C', 'ACC_FK_AI', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL', 'C', 'ACC_FK_AIT', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL', 'C', 'ACC_FK_ALB', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL', 'C', 'ACC_FK_PARENT', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL', 'C', 'ACC_FK_TOP', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL', 'C', 'ACC_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL', 'C', 'ACC_UK1', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL_LOAD', 'C', 'ACCL_FK_ACC', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL_LOAD', 'C', 'ACCL_FK_AI', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL_LOAD', 'C', 'ACCL_FK_AIT', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL_LOAD', 'C', 'ACCL_FK_ALB', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL_LOAD', 'C', 'ACCL_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL_LOAD', 'C', 'ACCL_UN', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEM_ATTR', 'C', 'AIA_FK_AAV', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEM_ATTR', 'C', 'AIA_FK_ACC', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEM_ATTR', 'C', 'AIA_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEM_ATTR_LOAD', 'C', 'AIAL_FK_AAV', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEM_ATTR_LOAD', 'C', 'AIAL_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEM_TYPES', 'C', 'AIT_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEM_TYPES', 'C', 'AIT_UK1', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_BATCHES', 'C', 'ALB_FK_HUS', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_BATCHES', 'C', 'ALB_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_DECODE', 'C', 'ALD_FK_ALR', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_DECODE', 'C', 'ALD_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_FILES', 'C', 'ALF_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_RECORD_TYPES', 'C', 'ALRT_FK_ALF', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_RECORD_TYPES', 'C', 'ALT_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_RULES', 'C', 'ALR_FK_AAV', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_RULES', 'C', 'ALR_FK_ALRT', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_RULES', 'C', 'ALR_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_PBI_QUERY', 'C', 'QRY_FK_HUS', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_PBI_QUERY', 'C', 'QRY_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_PBI_QUERY', 'C', 'QRY_UK1', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_PBI_SQL', 'C', 'PBS_FK_PBI', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_PBI_SQL', 'C', 'PBS_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_QRY_CRITERIA', 'C', 'AQC_FK_QRY', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_QRY_CRITERIA', 'C', 'AQC_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITES_TEMP', 'C', 'ATP_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITE_PARAMETERS', 'C', 'ASP_FK_AST', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITE_PARAMETERS', 'C', 'ASP_FK_HUS', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITE_PARAMETERS', 'C', 'ASP_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITE_THRESHOLDS', 'C', 'ATH_FK_AST', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITE_THRESHOLDS', 'C', 'ATH_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITE_TYPES', 'C', 'AST_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_TMP_JUN', 'C', 'ATJ_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_TMP_ROADS', 'C', 'ATR_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_DEP', 'C', 'AVD_FK_AAV', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_DEP', 'C', 'AVD_P1', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_DEP_VALUES', 'C', 'ADV_FK_AVI', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_DEP_VALUES', 'C', 'ADV_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_INDEP', 'C', 'AVI_FK_AAV', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_INDEP', 'C', 'AVI_FK_AVD', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_INDEP', 'C', 'AVI_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_INDEP_VALUES', 'C', 'AIV_FK_AVI', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_INDEP_VALUES', 'C', 'AIV_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_SQL', 'C', 'AVS1_FK_AAV', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_SQL', 'C', 'AVS2_FK_AAV', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_SQL', 'C', 'AVS_FK_AVD', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_SQL', 'C', 'AVS_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUPS', 'G', 'INSERT_AGR_DATA', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUPS', 'G', 'UPDATE_AGR_DATA', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL', 'G', 'DELETE_ACC_ID', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_PBI_QUERY', 'G', 'INSERT_ACC_QUERY_DATA', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_BANDS', 'I', 'AAB_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_BANDS', 'I', 'AAB_UK1', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_DOMAIN', 'I', 'AAD_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_DOMAIN', 'I', 'AAD_UK1', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_GROUPS', 'I', 'AAG_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_GROUPS', 'I', 'AAG_UK1', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_LOOKUP', 'I', 'AAL_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_MEMBS', 'I', 'AAM_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_TYPES', 'I', 'AAT_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_TYPES', 'I', 'AAT_UK1', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_VALID', 'I', 'AAV_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_BATCH_FILES', 'I', 'ABF_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_FACTOR_GRID', 'I', 'AFG_IND_AGR', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_FACTOR_GRID', 'I', 'AFG_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_FACTOR_GRID_ATTR', 'I', 'AFGA_P1', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_FACTOR_GRID_HEADER', 'I', 'AGH_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_FACTOR_GRID_PAGE', 'I', 'AFGP_IND_P1', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUPS', 'I', 'AGR_IND_AGR', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUPS', 'I', 'AGR_IND_ALB', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUPS', 'I', 'AGR_IND_JOB', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUPS', 'I', 'AGR_IND_QRY', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUPS', 'I', 'AGR_IND_RSE', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUPS', 'I', 'AGR_IND_TYPE', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUPS', 'I', 'AGR_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUPS', 'I', 'AGR_UN', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUP_ACCIDENTS', 'I', 'AGA_IND_ACC', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUP_BS_DATES', 'I', 'AGB_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUP_STATISTICS', 'I', 'AGS_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_IMAGES', 'I', 'AI_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL', 'I', 'ACC_IND_AIT', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL', 'I', 'ACC_IND_DATE', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL', 'I', 'ACC_IND_NEWTOP', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL', 'I', 'ACC_IND_PARENT', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL', 'I', 'ACC_IND_RSE', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL', 'I', 'ACC_IND_TOP', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL', 'I', 'ACC_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL', 'I', 'ACC_UK1', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL_LOAD', 'I', 'ACCL_IND_BB', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL_LOAD', 'I', 'ACCL_IND_NEWTOP', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL_LOAD', 'I', 'ACCL_IND_TOP', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL_LOAD', 'I', 'ACCL_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL_LOAD', 'I', 'ACCL_UN', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEM_ATTR', 'I', 'AIA_IND_AAV', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEM_ATTR_LOAD', 'I', 'AIAL_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEM_TYPES', 'I', 'AIT_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEM_TYPES', 'I', 'AIT_UK1', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_BATCHES', 'I', 'ALB_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_DECODE', 'I', 'ALD_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_FILES', 'I', 'ALF_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_RECORD_TYPES', 'I', 'ALT_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_RULES', 'I', 'ALR_IND_AAT', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_RULES', 'I', 'ALR_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_PBI_QUERY', 'I', 'QRY_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_PBI_QUERY', 'I', 'QRY_UK1', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_PBI_SQL', 'I', 'PBS_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_QRY_CRITERIA', 'I', 'AQC_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITES_TEMP', 'I', 'ATP_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITE_PARAMETERS', 'I', 'ASP_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITE_THRESHOLDS', 'I', 'ATH_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITE_TYPES', 'I', 'AST_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_DEP', 'I', 'AVD_P1', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_DEP_VALUES', 'I', 'ADV_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_INDEP', 'I', 'AVI_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_INDEP_VALUES', 'I', 'AIV_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_SQL', 'I', 'AVS_PK', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'ACC', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'ACCBVAL', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'ACCDISC', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'ACCINIT', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'ACCLOAD', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'ACCMTRX', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'ACCQRY', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'ACCSITE', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'ACCSITE1', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'PROTO_VALIDATE', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'AAG_ID_SEQ', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'ACC_EXCL_ID_SEQ', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'ACC_ID_SEQ', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'ACC_PBI_QRY_ID_SEQ', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'AGM_ID_SEQ', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'AGR_ID_SEQ', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'AI_ID_SEQ', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'AI_SEQ', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'ALB_ID_SEQ', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'ALF_FILE_ID_SEQ', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'ALR_RULE_ID_SEQ', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'GRID_ID_SEQ', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'TMP_SITE_ID_SEQ', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_BANDS', 'T', 'ACC_ATTR_BANDS', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_DOMAIN', 'T', 'ACC_ATTR_DOMAIN', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_GROUPS', 'T', 'ACC_ATTR_GROUPS', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_LOOKUP', 'T', 'ACC_ATTR_LOOKUP', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_MEMBS', 'T', 'ACC_ATTR_MEMBS', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_TYPES', 'T', 'ACC_ATTR_TYPES', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ATTR_VALID', 'T', 'ACC_ATTR_VALID', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_BATCH_FILES', 'T', 'ACC_BATCH_FILES', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_BS_DATES', 'T', 'ACC_BS_DATES', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_CURSOR_REPORT', 'T', 'ACC_CURSOR_REPORT', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_FACTOR_GRID', 'T', 'ACC_FACTOR_GRID', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_FACTOR_GRID_ATTR', 'T', 'ACC_FACTOR_GRID_ATTR', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_FACTOR_GRID_HEADER', 'T', 'ACC_FACTOR_GRID_HEADER', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_FACTOR_GRID_PAGE', 'T', 'ACC_FACTOR_GRID_PAGE', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUPS', 'T', 'ACC_GROUPS', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUP_ACCIDENTS', 'T', 'ACC_GROUP_ACCIDENTS', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUP_BS_DATES', 'T', 'ACC_GROUP_BS_DATES', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUP_MATRIX', 'T', 'ACC_GROUP_MATRIX', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_GROUP_STATISTICS', 'T', 'ACC_GROUP_STATISTICS', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_IMAGES', 'T', 'ACC_IMAGES', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL', 'T', 'ACC_ITEMS_ALL', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEMS_ALL_LOAD', 'T', 'ACC_ITEMS_ALL_LOAD', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEM_ATTR', 'T', 'ACC_ITEM_ATTR', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEM_ATTR_LOAD', 'T', 'ACC_ITEM_ATTR_LOAD', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_ITEM_TYPES', 'T', 'ACC_ITEM_TYPES', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_BATCHES', 'T', 'ACC_LOAD_BATCHES', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_DECODE', 'T', 'ACC_LOAD_DECODE', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_FILES', 'T', 'ACC_LOAD_FILES', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_ITEM_TEMP', 'T', 'ACC_LOAD_ITEM_TEMP', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_MATCH_ACC_ID', 'T', 'ACC_LOAD_MATCH_ACC_ID', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_MATCH_ITM', 'T', 'ACC_LOAD_MATCH_ITM', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_PK_TEMP', 'T', 'ACC_LOAD_PK_TEMP', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_RECORD_TYPES', 'T', 'ACC_LOAD_RECORD_TYPES', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_LOAD_RULES', 'T', 'ACC_LOAD_RULES', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_PBI_QUERY', 'T', 'ACC_PBI_QUERY', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_PBI_SQL', 'T', 'ACC_PBI_SQL', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_QRY_CRITERIA', 'T', 'ACC_QRY_CRITERIA', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITES_TEMP', 'T', 'ACC_SITES_TEMP', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITE_ACCS', 'T', 'ACC_SITE_ACCS', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITE_ACC_CURSORS', 'T', 'ACC_SITE_ACC_CURSORS', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITE_ACC_CURSOR_NODES', 'T', 'ACC_SITE_ACC_CURSOR_NODES', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITE_ACC_NODES', 'T', 'ACC_SITE_ACC_NODES', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITE_CURSORS', 'T', 'ACC_SITE_CURSORS', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITE_CURSOR_NODES', 'T', 'ACC_SITE_CURSOR_NODES', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITE_NODES', 'T', 'ACC_SITE_NODES', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITE_PARAMETERS', 'T', 'ACC_SITE_PARAMETERS', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITE_PARTIAL_SECTIONS', 'T', 'ACC_SITE_PARTIAL_SECTIONS', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITE_SECTIONS', 'T', 'ACC_SITE_SECTIONS', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITE_THRESHOLDS', 'T', 'ACC_SITE_THRESHOLDS', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_SITE_TYPES', 'T', 'ACC_SITE_TYPES', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_TMP_JUN', 'T', 'ACC_TMP_JUN', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_TMP_ROADS', 'T', 'ACC_TMP_ROADS', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_DEP', 'T', 'ACC_VALID_DEP', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_DEP_VALUES', 'T', 'ACC_VALID_DEP_VALUES', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_INDEP', 'T', 'ACC_VALID_INDEP', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_INDEP_VALUES', 'T', 'ACC_VALID_INDEP_VALUES', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACC_VALID_SQL', 'T', 'ACC_VALID_SQL', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'ACC_SITE_ROADS', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_ACC3020', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_ACC_GROUP_ATTR', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_ACC_TOP_ITEMS', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_ACC_TOP_ITEM_ATTR', 'ACC'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'COLOURS', 'C', 'COL_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'COLOURS', 'C', 'COL_UK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'COMPLAINT_PRIORITIES', 'C', 'CPR_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'COMPLAINT_PRIORITIES', 'C', 'CPR_UK1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOCS', 'C', 'DOC_FK_CPR', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOCS', 'C', 'DOC_FK_DCL', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOCS', 'C', 'DOC_FK_DLC', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOCS', 'C', 'DOC_FK_DMD', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOCS', 'C', 'DOC_FK_DTP', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOCS', 'C', 'DOC_FK_HAU', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOCS', 'C', 'DOC_FK_HUS1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOCS', 'C', 'DOC_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ACTIONS', 'C', 'DAC_FK_DOC', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ACTIONS', 'C', 'DAC_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ACTION_HISTORY', 'C', 'DAH_FK_DAC', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ASSOCS', 'C', 'DAS_FK_DGT', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ASSOCS', 'C', 'DAS_FK_DOC', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ASSOCS', 'C', 'DAS_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_CLASS', 'C', 'DCL_FK_DTP', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_CLASS', 'C', 'DCL_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_CLASS', 'C', 'DCL_UK1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_COPIES', 'C', 'DCP_FK_DOC', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_COPIES', 'C', 'DCP_FK_HUS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_COPIES', 'C', 'DCP_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_DAMAGE', 'C', 'DDG_FK_DOC', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_DAMAGE', 'C', 'DDG_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_DAMAGE_COSTS', 'C', 'DDC_FK_DDG', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_DAMAGE_COSTS', 'C', 'DDC_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ENQUIRY_CONTACTS', 'C', 'DEC_FK_DOC', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ENQUIRY_CONTACTS', 'C', 'DEC_FK_HCT', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ENQUIRY_CONTACTS', 'C', 'DEC_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ENQUIRY_TYPES', 'C', 'DET_FK_DCL', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ENQUIRY_TYPES', 'C', 'DET_FK_DTP', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ENQUIRY_TYPES', 'C', 'DET_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ENQUIRY_TYPES', 'C', 'DET_UNQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_GATEWAYS', 'C', 'DGT_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_GATEWAYS', 'C', 'DGT_UK1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_GATE_SYNS', 'C', 'DGS_FK_DGT', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_GATE_SYNS', 'C', 'DGS_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_HISTORY', 'C', 'DHI_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ITEMS', 'C', 'DIT_FK_DOC', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ITEMS', 'C', 'DIT_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_KEYS', 'C', 'DKY_FK_DKW', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_KEYS', 'C', 'DKY_FK_DOC', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_KEYS', 'C', 'DKY_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_KEYWORDS', 'C', 'DKW_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_LOCATIONS', 'C', 'DLC_FK_DMD', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_LOCATIONS', 'C', 'DLC_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_LOCATIONS', 'C', 'DLC_UK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_MEDIA', 'C', 'DMD_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_MEDIA', 'C', 'DMD_UK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_REDIR_PRIOR', 'C', 'DRP_ID', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_STD_ACTIONS', 'C', 'DSA_FK_DCL', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_STD_ACTIONS', 'C', 'DSA_FK_DTP', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_STD_COSTS', 'C', 'DSC_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_SYNONYMS', 'C', 'DSY_FK_DKW', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_SYNONYMS', 'C', 'DSY_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_TEMPLATE_COLUMNS', 'C', 'DTC_FK_DTG', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_TEMPLATE_COLUMNS', 'C', 'DTC_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_TEMPLATE_GATEWAYS', 'C', 'DTG_FK_DGT', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_TEMPLATE_GATEWAYS', 'C', 'DTG_FK_DLC', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_TEMPLATE_GATEWAYS', 'C', 'DTG_FK_DMD', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_TEMPLATE_GATEWAYS', 'C', 'DTG_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_TEMPLATE_USERS', 'C', 'DTU_FK_DTG', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_TEMPLATE_USERS', 'C', 'DTU_FK_DTP', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_TEMPLATE_USERS', 'C', 'DTU_FK_HUS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_TEMPLATE_USERS', 'C', 'DTU_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_TYPES', 'C', 'DTP_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_TYPES', 'C', 'DTP_UK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_ASSIGNED_ROADS', 'C', 'GAR_FK_RSE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_ASSIGNED_ROADS', 'C', 'GAR_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_CONVERSATIONS', 'C', 'GC_FK_HUS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_CONVERSATIONS', 'C', 'GC_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_DATA_OBJECTS', 'C', 'GDOBJ_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_DATA_OBJECTS', 'C', 'GDO_FK_GR', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_NETWORK_REQUESTS', 'C', 'GNR_FK_GR', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_NETWORK_REQUESTS', 'C', 'GNR_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_NET_MESSAGES', 'C', 'GNM_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_REQUESTS', 'C', 'GR_FK_GC', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_REQUESTS', 'C', 'GR_FK_GTF', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_REQUESTS', 'C', 'GR_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_ROUTES_LINK', 'C', 'GRL_FK_RSE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_ROUTES_LINK', 'C', 'GRL_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_TEMP_ROAD_GROUP_MEMBS', 'C', 'GTRG_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_THEMES_ALL', 'C', 'GT_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_THEMES_ALL', 'C', 'GT_UK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_THEME_FUNCTIONS', 'C', 'GTF_FK_GT', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_THEME_FUNCTIONS', 'C', 'GTF_FK_HMO', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_THEME_FUNCTIONS', 'C', 'GTF_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_THEME_ROLES', 'C', 'GTHR_FK_GT', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_THEME_ROLES', 'C', 'GTHR_FK_HRO', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_THEME_ROLES', 'C', 'GTHR_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_UNASSIGNED_ROADS', 'C', 'GUR_FK_RSE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_UNASSIGNED_ROADS', 'C', 'GUR_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_LOV', 'C', 'GL_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_MODULES', 'C', 'GRM_FK_HMO', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_MODULES', 'C', 'GRM_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_MODULE_PARAMS', 'C', 'GMP_FK_GP', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_MODULE_PARAMS', 'C', 'GMP_FK_GRM', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_MODULE_PARAMS', 'C', 'GMP_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_PARAMS', 'C', 'GP_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_PARAM_DEPENDENCIES', 'C', 'GPD_FK_GMP1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_PARAM_DEPENDENCIES', 'C', 'GPD_FK_GMP2', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_PARAM_DEPENDENCIES', 'C', 'GPD_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_PARAM_LOOKUP', 'C', 'GPL_FK_GP', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_PARAM_LOOKUP', 'C', 'GPL_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_REPORT_RUNS', 'C', 'GRR_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_RUN_PARAMETERS', 'C', 'GRP_FK_GRR', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_RUN_PARAMETERS', 'C', 'GRP_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_SAVED_PARAMS', 'C', 'GSP_FK_GSS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_SAVED_PARAMS', 'C', 'GSP_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_SAVED_SETS', 'C', 'GSS_FK_GRM', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_SAVED_SETS', 'C', 'GSS_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_SPOOL', 'C', 'GRS_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GROUP_TYPES', 'C', 'GTY_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GROUP_TYPES', 'C', 'GTY_UK1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GROUP_TYPE_ROLES', 'C', 'GTR_FK_GTY', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GROUP_TYPE_ROLES', 'C', 'GTR_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADDRESS', 'C', 'HAD_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADMIN_GROUPS', 'C', 'HAG_FK1_HAU', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADMIN_GROUPS', 'C', 'HAG_FK2_HAU', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADMIN_GROUPS', 'C', 'HAG_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADMIN_UNITS', 'C', 'HAU_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADMIN_UNITS', 'C', 'HAU_UK1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADMIN_UNITS', 'C', 'HAU_UK2', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_CODES', 'C', 'HCO_FK_HDO', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_CODES', 'C', 'HCO_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_COLOURS', 'C', 'HCL_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_CONTACTS', 'C', 'HCT_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_CONTACT_ADDRESS', 'C', 'HCA_FK_HAD', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_CONTACT_ADDRESS', 'C', 'HCA_FK_HCT', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_CONTACT_ADDRESS', 'C', 'HCA_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_DOMAINS', 'C', 'HDO_FK_HPR', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_DOMAINS', 'C', 'HDO_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ERRORS', 'C', 'HER_FK_HPR', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ERRORS', 'C', 'HER_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HOLIDAYS', 'C', 'HHO_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_MODULES', 'C', 'HMO_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_MODULE_ROLES', 'C', 'HMR_FK_HMO', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_MODULE_ROLES', 'C', 'HMR_FK_HRO', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_MODULE_ROLES', 'C', 'HMR_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_OPTIONS', 'C', 'HOP_FK_HPR', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_OPTIONS', 'C', 'HOP_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_PRODUCTS', 'C', 'HIG_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_PRODUCTS', 'C', 'HPR_UK1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ROLES', 'C', 'HRO_FK_HPR', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ROLES', 'C', 'HRO_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_STATUS_CODES', 'C', 'HSC_FK_HSD', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_STATUS_CODES', 'C', 'HSC_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_STATUS_CODES', 'C', 'HSC_UK1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_STATUS_DOMAINS', 'C', 'HSD_FK_HPR', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_STATUS_DOMAINS', 'C', 'HSD_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_UPGRADES', 'C', 'HUP_FK_HPR', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_UPGRADES', 'C', 'HUP_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_USERS', 'C', 'HUS_FK_HAU', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_USERS', 'C', 'HUS_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_USERS', 'C', 'HUS_UK1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_USERS', 'C', 'HUS_UK2', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_USER_OPTIONS', 'C', 'HUO_FK_HUS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_USER_OPTIONS', 'C', 'HUO_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_WEB_CONTXT_HLP', 'C', 'HWCH_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INTERVALS', 'C', 'INT_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NAME_USAGES', 'C', 'NUS_FK_STREET', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NAME_USAGES', 'C', 'NUS_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NET_SEL_ATTR', 'C', 'NSA_NSCR_FK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NET_SEL_ATTR', 'C', 'NSA_NSI_FK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NET_SEL_CONTRACTS', 'C', 'NSC_NSCR_FK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NET_SEL_CRITERIA', 'C', 'NSCR_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NET_SEL_DEFECTS', 'C', 'NSD_NSCR_FK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NET_SEL_ENQUIRIES', 'C', 'NSE_NSCR_FK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NET_SEL_INV', 'C', 'NSI_NSCR_FK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NET_SEL_INV', 'C', 'NSI_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NODE_USAGES', 'C', 'NOU_FK_PUS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NODE_USAGES', 'C', 'NOU_FK_RSE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NODE_USAGES', 'C', 'NOU_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'POINTS', 'C', 'POI_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'POINT_USAGES', 'C', 'PUS_FK_POI', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'POINT_USAGES', 'C', 'PUS_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'POINT_USAGES', 'C', 'PUS_UK1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'REPORT_PARAMS', 'C', 'RPA_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'REPORT_TAGS', 'C', 'RTG_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_DEFAULTS', 'C', 'RDF_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEGS', 'C', 'RSE_FK_GTY', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEGS', 'C', 'RSE_FK_HAU', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEGS', 'C', 'RSE_FK_INT', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEGS', 'C', 'RSE_FK_POI1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEGS', 'C', 'RSE_FK_POI2', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEGS', 'C', 'RSE_FK_SCL', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEGS', 'C', 'RSE_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEGS', 'C', 'RSE_UK1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEG_MEMBS_ALL', 'C', 'RSM_FK_RSE1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEG_MEMBS_ALL', 'C', 'RSM_FK_RSE2', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEG_MEMBS_ALL', 'C', 'RSM_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SECTION_CLASSES', 'C', 'SCL_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SECT_HIST', 'C', 'SEH_FK_RSE1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SECT_HIST', 'C', 'SEH_FK_RSE2', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SECT_HIST', 'C', 'SEH_FK_RSE3', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SECT_HIST', 'C', 'SEH_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STREETS', 'C', 'STREET_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UNITS', 'C', 'UN_FK_UD', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UNITS', 'C', 'UN_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UNITS', 'C', 'UN_UK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UNIT_CONVERSIONS', 'C', 'UC_FK_UN_FROM', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UNIT_CONVERSIONS', 'C', 'UC_FK_UN_TO', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UNIT_CONVERSIONS', 'C', 'UC_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UNIT_DOMAINS', 'C', 'UD_UK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UNIT_DOMAINS', 'C', 'UK_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'COMPLAINTNAME', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'COMPLAINTUSER', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'COMPL_ADMIN_CODE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'COMPL_ADMIN_NAME', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'COMPL_CATEGORY_DESC', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'COMPL_CLASS_DESC', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'COMPL_DESC_CHUNK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'COMPL_DOMAIN', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'COMPL_ENQUIRY_NAME', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'COMPL_ENQUIRY_TYPE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'COMPL_FLAG', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'COMPL_PRIORITY', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'COMPL_ROAD_DESCR', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'COMPL_ROAD_UNIQUE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'COMPL_SOURCE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'COMPL_STATUS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'COMPL_TYPE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'ENQUIRY_DAMAGE_FDETAIL', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'ENQUIRY_DAMAGE_FTYPE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'ENQUIRY_DAMAGE_VEHICLE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'ENQUIRY_DAMAGE_VOWNER', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'ENQUIRY_DAMAGE_VREG', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'GET_ADDRESS_LINE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'GET_DATE_TIME', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'GET_TIME', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'LINE_ADDRESS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'LINE_FAX_NO', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'LINE_NAME', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'LINE_ORGANISATION', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'LINE_TELEPHONE_NO', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOCS', 'G', 'INSERT_DOC_HISTORY', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOCS', 'G', 'UPDATE_DOC_ACTIONS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ACTIONS', 'G', 'INSERT_DOC_ACTION_HISTORY', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_DATA_OBJECTS', 'G', 'INSERT_GDO', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_DATA_OBJECTS', 'G', 'UPDATE_GDO', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_REQUESTS', 'G', 'SEND_GIS_REQUEST', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEGS', 'G', 'INSERT_ROAD_SEGS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEGS', 'G', 'ROAD_CATEGORY_UPDATES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEGS', 'G', 'ROAD_LENGTH_HISTORY', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEGS', 'G', 'UPDATE_RSE_UNIQUE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SECT_HIST', 'G', 'SECHIST_DEL_DOCHIST', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SECT_HIST', 'G', 'SECHIST_INS_DOCHIST', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'COLOURS', 'I', 'COL_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'COLOURS', 'I', 'COL_UK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'COMPLAINT_PRIORITIES', 'I', 'CPR_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'COMPLAINT_PRIORITIES', 'I', 'CPR_UK1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOCS', 'I', 'DOC_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOCS', 'I', 'DOC_IND2', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOCS', 'I', 'DOC_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ACTIONS', 'I', 'DAC_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ACTIONS', 'I', 'DAC_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ACTION_HISTORY', 'I', 'DAH_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ASSOCS', 'I', 'DAS_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_CLASS', 'I', 'DCL_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_CLASS', 'I', 'DCL_UK1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_COPIES', 'I', 'DCP_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_DAMAGE', 'I', 'DDG_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_DAMAGE', 'I', 'DDG_IND2', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_DAMAGE', 'I', 'DDG_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_DAMAGE_COSTS', 'I', 'DDC_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_DAMAGE_COSTS', 'I', 'DDC_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ENQUIRY_CONTACTS', 'I', 'DEC_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ENQUIRY_TYPES', 'I', 'DET_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ENQUIRY_TYPES', 'I', 'DET_UNQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_GATEWAYS', 'I', 'DGT_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_GATEWAYS', 'I', 'DGT_UK1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_GATE_SYNS', 'I', 'DGS_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_GATE_SYNS', 'I', 'DGS_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_HISTORY', 'I', 'DHI_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ITEMS', 'I', 'DIT_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_KEYS', 'I', 'DKW_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_KEYWORDS', 'I', 'DKW_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_LOCATIONS', 'I', 'DLC_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_LOCATIONS', 'I', 'DLC_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_LOCATIONS', 'I', 'DLC_UK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_MEDIA', 'I', 'DMD_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_MEDIA', 'I', 'DMD_UK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_REDIR_PRIOR', 'I', 'DRP_CPR_IND', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_REDIR_PRIOR', 'I', 'DRP_DCL_IND', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_REDIR_PRIOR', 'I', 'DRP_DTP_IND', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_REDIR_PRIOR', 'I', 'DRP_ID', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_REDIR_PRIOR', 'I', 'DRP_ROAD_IND', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_REDIR_PRIOR', 'I', 'DRP_TYPE_IND', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_STD_ACTIONS', 'I', 'DSA_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_STD_ACTIONS', 'I', 'DSA_IND2', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_STD_COSTS', 'I', 'DSC_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_SYNONYMS', 'I', 'DSY_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_TEMPLATE_COLUMNS', 'I', 'DTC_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_TEMPLATE_GATEWAYS', 'I', 'DTG_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_TEMPLATE_USERS', 'I', 'DTU_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_TYPES', 'I', 'DTP_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_TYPES', 'I', 'DTP_UK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_ASSIGNED_ROADS', 'I', 'GAR_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_CONVERSATIONS', 'I', 'GC_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_DATA_OBJECTS', 'I', 'GDO_P1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_NETWORK_REQUESTS', 'I', 'GNR_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_NET_MESSAGES', 'I', 'GNM_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_REQUESTS', 'I', 'GR_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_ROUTES_LINK', 'I', 'GRL_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_ROUTES_LINK', 'I', 'TRATTI_IX1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_ROUTES_LINK', 'I', 'TRATTI_IX2', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_TEMP_ROAD_GROUP_MEMBS', 'I', 'GTRG_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_THEMES_ALL', 'I', 'GT_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_THEMES_ALL', 'I', 'GT_UK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_THEME_FUNCTIONS', 'I', 'GTF_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_THEME_ROLES', 'I', 'GTHR_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_UNASSIGNED_ROADS', 'I', 'GUR_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_LOV', 'I', 'GL_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_MODULES', 'I', 'GRM_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_MODULE_PARAMS', 'I', 'GMP_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_PARAMS', 'I', 'GP_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_PARAM_DEPENDENCIES', 'I', 'GPD_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_PARAM_LOOKUP', 'I', 'GPL_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_REPORT_RUNS', 'I', 'GRR_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_RUN_PARAMETERS', 'I', 'GRP_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_SAVED_PARAMS', 'I', 'GSP_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_SAVED_SETS', 'I', 'GSS_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_SPOOL', 'I', 'GRS_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GROUP_TYPES', 'I', 'GTY_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GROUP_TYPES', 'I', 'GTY_UK1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GROUP_TYPE_ROLES', 'I', 'GTR_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADDRESS', 'I', 'HAD_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADDRESS', 'I', 'HAD_IND10', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADDRESS', 'I', 'HAD_IND11', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADDRESS', 'I', 'HAD_IND12', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADDRESS', 'I', 'HAD_IND2', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADDRESS', 'I', 'HAD_IND3', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADDRESS', 'I', 'HAD_IND5', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADDRESS', 'I', 'HAD_IND6', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADDRESS', 'I', 'HAD_IND7', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADDRESS', 'I', 'HAD_IND8', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADDRESS', 'I', 'HAD_IND9', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADDRESS', 'I', 'HAD_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADDRESS_POINT', 'I', 'HDP_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADMIN_GROUPS', 'I', 'HAG_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADMIN_UNITS', 'I', 'HAU_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADMIN_UNITS', 'I', 'HAU_UK1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADMIN_UNITS', 'I', 'HAU_UK2', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_CODES', 'I', 'HCO_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_COLOURS', 'I', 'HCL_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_CONTACTS', 'I', 'HCT_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_CONTACTS', 'I', 'HCT_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_CONTACT_ADDRESS', 'I', 'HCA_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_DOMAINS', 'I', 'HDO_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ERRORS', 'I', 'HER_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HOLIDAYS', 'I', 'HHO_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_MODULES', 'I', 'HMO_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_MODULE_ROLES', 'I', 'HMR_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_OPTIONS', 'I', 'HOP_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_PRODUCTS', 'I', 'HIG_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_PRODUCTS', 'I', 'HPR_UK1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ROLES', 'I', 'HRO_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_STATUS_CODES', 'I', 'HSC_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_STATUS_CODES', 'I', 'HSC_UK1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_STATUS_DOMAINS', 'I', 'HSD_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_UPGRADES', 'I', 'HUP_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_USERS', 'I', 'HUS_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_USERS', 'I', 'HUS_UK1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_USERS', 'I', 'HUS_UK2', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_USER_OPTIONS', 'I', 'HUO_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_WEB_CONTXT_HLP', 'I', 'HWCH_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INTERVALS', 'I', 'INT_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NAME_USAGES', 'I', 'NUS_INDEX_S1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NAME_USAGES', 'I', 'NUS_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NET_SEL_ATTR', 'I', 'NSA_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NET_SEL_CRITERIA', 'I', 'NSCR_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NET_SEL_INV', 'I', 'NSI_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NODE_USAGES', 'I', 'NOU_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NODE_USAGES', 'I', 'NOU_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'POINTS', 'I', 'POI_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'POINT_USAGES', 'I', 'PUS_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'POINT_USAGES', 'I', 'PUS_UK1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'REPORT_TAGS', 'I', 'RTG_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_DEFAULTS', 'I', 'RDF_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_LENGTH_HISTORY', 'I', 'RLH_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEGS', 'I', 'RSE_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEGS', 'I', 'RSE_IND2', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEGS', 'I', 'RSE_IND3', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEGS', 'I', 'RSE_IND4', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEGS', 'I', 'RSE_IND5', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEGS', 'I', 'RSE_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEGS', 'I', 'RSE_UK1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEG_MEMBS_ALL', 'I', 'RSM_IND1', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEG_MEMBS_ALL', 'I', 'RSM_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SECTION_CLASSES', 'I', 'SCL_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SECT_HIST', 'I', 'SEH_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STREETS', 'I', 'STREET_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UNITS', 'I', 'UN_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UNITS', 'I', 'UN_UK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UNIT_CONVERSIONS', 'I', 'UC_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UNIT_DOMAINS', 'I', 'UD_UK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UNIT_DOMAINS', 'I', 'UK_PK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'COLOUR', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'DOC', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIG', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIG2', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIG3', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIGCLOSE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIGDDUE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIGGIS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIGGRI', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIGGRIRP', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIGMERGE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIGNET', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIGOLE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIGPIPE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIGRECAL', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIGREPL', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIGSPLIT', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIGUNIT', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIG_CONTACT', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIG_HD_EXTRACT', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIG_HD_INSERT', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIG_HD_QUERY', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIG_UTILITY', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'HIG_WEB_CONTEXT_HELP', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'NET1119', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'NETEDT', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'NET_SEL', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'NM3TYPE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'NM3WEB', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'NM3WEB_MAP', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'NM_DEBUG', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'OFFSETS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'PEM', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'WEB', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'CHECK_CLOSE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'CHECK_MERGE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'CHECK_RECAL', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'CHECK_REPLACE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'CHECK_SHIFT', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'CHECK_SPLITS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'CHECK_UNCLOSE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'CHECK_UNMERGE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'CHECK_UNREPLACE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'CHECK_UNSPLITS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'CREATE_COMPLAINT_HISTORY', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'EXECUTE_CLOSE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'EXECUTE_MERGE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'EXECUTE_RECAL', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'EXECUTE_REPLACE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'EXECUTE_SHIFT', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'EXECUTE_SPLITS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'EXECUTE_UNCLOSE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'EXECUTE_UNMERGE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'EXECUTE_UNREPLACE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'EXECUTE_UNSPLITS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'BT_STRING_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'DAC_ID_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'DDC_ID_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'DDG_ID_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'DIT_ID_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'DLC_ID_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'DMD_ID_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'DOC_ID_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'DRP_ID_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'ENQUIRY_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'GIS_SESSION_ID', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'GSS_ID_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'GT_THEME_ID', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'HAD_ID_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'HAU_ADMIN_UNIT_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'HCT_ID_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'HUS_USER_ID_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'NODE_ID_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'NSCR_ID_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'NSI_ID_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'POI_POINT_ID_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'RSE_HE_ID_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'RTG_JOB_ID_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'STREET_ID_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'UD_DOMAIN_ID_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'UN_UNIT_ID_SEQ', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'COLOURS', 'T', 'COLOURS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'COMPLAINT_PRIORITIES', 'T', 'COMPLAINT_PRIORITIES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOCS', 'T', 'DOCS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ACTIONS', 'T', 'DOC_ACTIONS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ACTION_HISTORY', 'T', 'DOC_ACTION_HISTORY', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ASSOCS', 'T', 'DOC_ASSOCS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_CLASS', 'T', 'DOC_CLASS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_COPIES', 'T', 'DOC_COPIES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_DAMAGE', 'T', 'DOC_DAMAGE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_DAMAGE_COSTS', 'T', 'DOC_DAMAGE_COSTS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ENQUIRY_CONTACTS', 'T', 'DOC_ENQUIRY_CONTACTS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ENQUIRY_TYPES', 'T', 'DOC_ENQUIRY_TYPES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_GATEWAYS', 'T', 'DOC_GATEWAYS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_GATE_SYNS', 'T', 'DOC_GATE_SYNS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_HISTORY', 'T', 'DOC_HISTORY', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_ITEMS', 'T', 'DOC_ITEMS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_KEYS', 'T', 'DOC_KEYS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_KEYWORDS', 'T', 'DOC_KEYWORDS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_LOCATIONS', 'T', 'DOC_LOCATIONS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_LOV_RECS', 'T', 'DOC_LOV_RECS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_MEDIA', 'T', 'DOC_MEDIA', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_REDIR_PRIOR', 'T', 'DOC_REDIR_PRIOR', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_STD_ACTIONS', 'T', 'DOC_STD_ACTIONS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_STD_COSTS', 'T', 'DOC_STD_COSTS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_SYNONYMS', 'T', 'DOC_SYNONYMS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_TEMPLATE_COLUMNS', 'T', 'DOC_TEMPLATE_COLUMNS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_TEMPLATE_GATEWAYS', 'T', 'DOC_TEMPLATE_GATEWAYS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_TEMPLATE_USERS', 'T', 'DOC_TEMPLATE_USERS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_TYPES', 'T', 'DOC_TYPES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'EXOR_LOCK', 'T', 'EXOR_LOCK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'EXOR_LSNR', 'T', 'EXOR_LSNR', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_ASSIGNED_ROADS', 'T', 'GIS_ASSIGNED_ROADS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_CONVERSATIONS', 'T', 'GIS_CONVERSATIONS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_DATA_OBJECTS', 'T', 'GIS_DATA_OBJECTS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_NETWORK_REQUESTS', 'T', 'GIS_NETWORK_REQUESTS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_NET_MESSAGES', 'T', 'GIS_NET_MESSAGES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_PROJECTS', 'T', 'GIS_PROJECTS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_REQUESTS', 'T', 'GIS_REQUESTS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_ROUTES_LINK', 'T', 'GIS_ROUTES_LINK', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_TEMP_ROAD_GROUP_MEMBS', 'T', 'GIS_TEMP_ROAD_GROUP_MEMBS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_THEMES_ALL', 'T', 'GIS_THEMES_ALL', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_THEME_FUNCTIONS', 'T', 'GIS_THEME_FUNCTIONS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_THEME_ROLES', 'T', 'GIS_THEME_ROLES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GIS_UNASSIGNED_ROADS', 'T', 'GIS_UNASSIGNED_ROADS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_LOV', 'T', 'GRI_LOV', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_MODULES', 'T', 'GRI_MODULES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_MODULE_PARAMS', 'T', 'GRI_MODULE_PARAMS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_PARAMS', 'T', 'GRI_PARAMS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_PARAM_DEPENDENCIES', 'T', 'GRI_PARAM_DEPENDENCIES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_PARAM_LOOKUP', 'T', 'GRI_PARAM_LOOKUP', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_REPORT_RUNS', 'T', 'GRI_REPORT_RUNS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_RUN_PARAMETERS', 'T', 'GRI_RUN_PARAMETERS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_SAVED_PARAMS', 'T', 'GRI_SAVED_PARAMS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_SAVED_SETS', 'T', 'GRI_SAVED_SETS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GRI_SPOOL', 'T', 'GRI_SPOOL', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GROUP_TYPES', 'T', 'GROUP_TYPES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'GROUP_TYPE_ROLES', 'T', 'GROUP_TYPE_ROLES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADDRESS', 'T', 'HIG_ADDRESS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADDRESS_POINT', 'T', 'HIG_ADDRESS_POINT', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADMIN_GROUPS', 'T', 'HIG_ADMIN_GROUPS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ADMIN_UNITS', 'T', 'HIG_ADMIN_UNITS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_CODES', 'T', 'HIG_CODES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_COLOURS', 'T', 'HIG_COLOURS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_CONTACTS', 'T', 'HIG_CONTACTS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_CONTACT_ADDRESS', 'T', 'HIG_CONTACT_ADDRESS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_DOMAINS', 'T', 'HIG_DOMAINS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ERRORS', 'T', 'HIG_ERRORS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HOLIDAYS', 'T', 'HIG_HOLIDAYS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_MODULES', 'T', 'HIG_MODULES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_MODULE_ROLES', 'T', 'HIG_MODULE_ROLES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_OPTIONS', 'T', 'HIG_OPTIONS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_PRODUCTS', 'T', 'HIG_PRODUCTS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_PU', 'T', 'HIG_PU', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_ROLES', 'T', 'HIG_ROLES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_STATUS_CODES', 'T', 'HIG_STATUS_CODES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_STATUS_DOMAINS', 'T', 'HIG_STATUS_DOMAINS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_UPGRADES', 'T', 'HIG_UPGRADES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_USERS', 'T', 'HIG_USERS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_USER_OPTIONS', 'T', 'HIG_USER_OPTIONS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_WEB_CONTXT_HLP', 'T', 'HIG_WEB_CONTXT_HLP', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INTERVALS', 'T', 'INTERVALS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NAME_USAGES', 'T', 'NAME_USAGES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NET_SEL_ATTR', 'T', 'NET_SEL_ATTR', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NET_SEL_CONTRACTS', 'T', 'NET_SEL_CONTRACTS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NET_SEL_CRITERIA', 'T', 'NET_SEL_CRITERIA', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NET_SEL_DEFECTS', 'T', 'NET_SEL_DEFECTS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NET_SEL_ENQUIRIES', 'T', 'NET_SEL_ENQUIRIES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NET_SEL_INV', 'T', 'NET_SEL_INV', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NET_SEL_ROADS', 'T', 'NET_SEL_ROADS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NODE_USAGES', 'T', 'NODE_USAGES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'POINTS', 'T', 'POINTS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'POINT_USAGES', 'T', 'POINT_USAGES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'REPORT_PARAMS', 'T', 'REPORT_PARAMS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'REPORT_TAGS', 'T', 'REPORT_TAGS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_DEFAULTS', 'T', 'ROAD_DEFAULTS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_LENGTH_HISTORY', 'T', 'ROAD_LENGTH_HISTORY', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEGS', 'T', 'ROAD_SEGS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_SEG_MEMBS_ALL', 'T', 'ROAD_SEG_MEMBS_ALL', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SECTION_CLASSES', 'T', 'SECTION_CLASSES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SECT_HIST', 'T', 'SECT_HIST', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STREETS', 'T', 'STREETS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UNITS', 'T', 'UNITS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UNIT_CONVERSIONS', 'T', 'UNIT_CONVERSIONS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UNIT_DOMAINS', 'T', 'UNIT_DOMAINS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'DOCS2VIEW', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'DOC_CONTACT', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'DOC_CONTACT_ADDRESS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'FRM45_ENABLED_ROLES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'FRM50_ENABLED_ROLES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'GIS_ROAD_SECTIONS_ALL', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'GIS_THEMES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'NAMED_SECTIONS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'NETWORK_NODE', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'ROAD_GROUPS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'ROAD_GROUPS_ALL', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'ROAD_LINKS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'ROAD_LINKS_ALL', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'ROAD_ROUTES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'ROAD_ROUTES_ALL', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'ROAD_SECTIONS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'ROAD_SECTIONS_ALL', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'ROAD_SEGMENTS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'ROAD_SEGMENTS_ALL', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'ROAD_SEG_MEMBS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'ROAD_TYPES', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_DOC_TEMPLATE_USERS', 'HIG'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_JOIN_DEFS', 'C', 'HIG_HD_HHT_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_JOIN_DEFS', 'C', 'HIG_HD_MUJ_MU_FK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_LOOKUP_JOIN_COLS', 'C', 'HIG_HD_HHO_HHL_FK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_LOOKUP_JOIN_COLS', 'C', 'HIG_HD_HO_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_LOOKUP_JOIN_DEFS', 'C', 'HIG_HD_HHL_HHU_FK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_LOOKUP_JOIN_DEFS', 'C', 'HIG_HD_HHL_OUTER_JOIN', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_LOOKUP_JOIN_DEFS', 'C', 'HIG_HD_HHL_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_MODULES', 'C', 'HIG_HD_HHM_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_MOD_USES', 'C', 'HIG_HD_HHU_HHM_FK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_MOD_USES', 'C', 'HIG_HD_HHU_LOAD_DATA_CHK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_MOD_USES', 'C', 'HIG_HD_HHU_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_SELECTED_COLS', 'C', 'HIG_HD_HHC_HHL_FK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_SELECTED_COLS', 'C', 'HIG_HD_HHC_HHU_FK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_SELECTED_COLS', 'C', 'HIG_HD_HHC_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_SELECTED_COLS', 'C', 'HIG_HD_HHC_SUMMARY_VIW', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_TABLE_JOIN_COLS', 'C', 'HIG_HD_HHJ_HHC_PARENT_FK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_TABLE_JOIN_COLS', 'C', 'HIG_HD_HHJ_HHT_FK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_TABLE_JOIN_COLS', 'C', 'HIG_HD_HHJ_HHU_CHILD_FK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_TABLE_JOIN_COLS', 'C', 'HIG_HD_HHJ_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACTIVITIES_REPORT', 'G', 'DEL_ACT_REPORT_LINES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BOQ_ITEMS', 'G', 'BOQ_AUDIT', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECTS', 'G', 'COMPLETE_DOC_STATUS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECTS', 'G', 'DEF_DUE_DATE_TIME', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECTS', 'G', 'DEF_UPDATE_DOC_STATUS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECTS', 'G', 'INSERT_DEF_MOVEMENTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECTS', 'G', 'PRE_INSERT_DEFECTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECTS', 'G', 'UPDATE_DOE_DEF_PRIORITY', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECT_PRIORITIES', 'G', 'DELETE_DOC_DEF_PRIORITIES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECT_PRIORITIES', 'G', 'INSERT_DOC_DEF_PRIORITIES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECT_PRIORITIES', 'G', 'UPDATE_DOC_DEF_PRIORITIES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEF_TREATS', 'G', 'DELETE_DOC_DEF_TREATS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEF_TREATS', 'G', 'INSERT_DOC_DEF_TREATS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_ITEMS_ALL', 'G', 'UPDATE_INV_ITEMS_ALL', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEDULES', 'G', 'UPDATE_RSE_AGENCY', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEMES', 'G', 'INSERT_SCHEME_HISTORY', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STANDARD_ITEMS', 'G', 'DUMMY_CONTRACT_DELETE', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STANDARD_ITEMS', 'G', 'DUMMY_CONTRACT_INSERT', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STANDARD_ITEMS', 'G', 'DUMMY_CONTRACT_UPDATE', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WORK_ORDERS', 'G', 'WORKS_ORDER_FGAC', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WORK_ORDERS', 'G', 'WOR_AUDIT', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WORK_ORDER_LINES', 'G', 'WOL_AUDIT', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WORK_ORDER_LINES', 'G', 'WO_CLAIMS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACTIVITIES', 'I', 'ATV_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACTIVITIES', 'I', 'ATV_INDEX_P2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACTIVITIES_REPORT', 'I', 'ARE_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACTIVITIES_REPORT', 'I', 'ARE_INDEX_P2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACTIVITIES_REPORT', 'I', 'ARE_INDEX_S1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACTIVITIES_REPORT', 'I', 'ARE_INDEX_S2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACT_FREQS', 'I', 'AFR_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACT_FREQS', 'I', 'AFR_INDEX_S1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACT_REPORT_LINES', 'I', 'ARL_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'AUTO_DEFECT_SELECTION_PRIORITY', 'I', 'ADSP_UNIQUE_IND', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BOQ_ITEMS', 'I', 'BOQ_ID', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BOQ_ITEMS', 'I', 'BOQ_INDEX_S1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BOQ_ITEMS', 'I', 'BOQ_INDEX_S2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BOQ_ITEMS', 'I', 'BOQ_INDEX_S3', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BOQ_ITEMS', 'I', 'BOQ_PARENT_ID', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BUDGETS', 'I', 'BUD_INDEX_I1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BUDGETS', 'I', 'BUD_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BUDGETS', 'I', 'BUD_INDEX_S1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BUDGETS', 'I', 'BUD_INDEX_S2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLAIM_PAYMENTS', 'I', 'CP_IND1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLAIM_PAYMENTS', 'I', 'CP_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CONTRACTOR_DISC_BANDS', 'I', 'CNB_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CONTRACTS', 'I', 'CON_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CONTRACTS', 'I', 'CON_INDEX_S1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CONTRACT_ITEMS', 'I', 'CNI_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CONTRACT_PAYMENTS', 'I', 'CNP_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CONTRACT_PAYMENTS', 'I', 'CNP_INDEX_S1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CONTRACT_SURCHARGES', 'I', 'CNS_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'COST_CENTRES', 'I', 'COC_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECTS', 'I', 'DEF_INDEX_IIT', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECTS', 'I', 'DEF_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECTS', 'I', 'DEF_INDEX_P2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECTS', 'I', 'DEF_INDEX_P3', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECTS', 'I', 'DEF_INDEX_P4', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECTS', 'I', 'DEF_INDEX_P5', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECTS', 'I', 'DEF_INDEX_S1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECTS', 'I', 'DEF_INDEX_S2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECTS', 'I', 'DEF_INDEX_S3', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECTS', 'I', 'DEF_INDEX_S6', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECTS', 'I', 'DEF_IND_SUP', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECT_PRIORITIES', 'I', 'DPR_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEF_TREATS', 'I', 'DTR_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEF_TYPES', 'I', 'DTY_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_DEF_PRIORITIES', 'I', 'DDP_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_DEF_TREATS', 'I', 'DDT_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HHINV_ITEM_ERR_1', 'I', 'HHINV_ITER1_IND1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HHINV_ITEM_ERR_2', 'I', 'HHINV_ITER2_IND2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HHINV_ITEM_ERR_3', 'I', 'HHINV_ITER3_IND3', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HHINV_LOAD_2', 'I', 'HHINV_LOAD_2_IND_1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HHINV_LOAD_2', 'I', 'HHINV_LOAD_2_IND_2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HHINV_LOAD_3', 'I', 'HHINV_LOAD_3_IND_2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HHINV_LOAD_3', 'I', 'HHINV_LOAD_3_IND_3', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HHINV_SECT_LOG', 'I', 'HHINV_SECT_IND1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HHINV_SECT_LOG', 'I', 'HHINV_SECT_IND2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HHINV_SECT_LOG', 'I', 'HHINV_SECT_IND3', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_JOIN_DEFS', 'I', 'HIG_HD_HHT_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_LOOKUP_JOIN_COLS', 'I', 'HIG_HD_HO_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_LOOKUP_JOIN_DEFS', 'I', 'HIG_HD_HHL_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_MODULES', 'I', 'HIG_HD_HHM_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_MOD_USES', 'I', 'HIG_HD_HHU_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_SELECTED_COLS', 'I', 'HIG_HD_HHC_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_TABLE_JOIN_COLS', 'I', 'HIG_HD_HHJ_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'IFF_SECT_STACK', 'I', 'ISS_PRIME', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'IHMS_ALLOCATED_AMTS', 'I', 'IHA_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'IHMS_CONVERSIONS', 'I', 'IHC_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INSURANCE_CLAIM_ACTIVITIES', 'I', 'ICA_INDEX_1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INSURANCE_CLAIM_PARAMETERS', 'I', 'ICP_REPORT_1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INSURANCE_CLAIM_PARAMETERS', 'I', 'ICP_REPORT_2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INTERFACE_BOQ', 'I', 'IBOQ_S1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INTERFACE_CLAIMS_BOQ_ALL', 'I', 'ICBOQ_S1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INTERFACE_CLAIMS_WOL_ALL', 'I', 'ICWOL_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INTERFACE_CLAIMS_WOR_ALL', 'I', 'ICWOR_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INTERFACE_COMPLETIONS_ALL', 'I', 'IC_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INTERFACE_HEADERS', 'I', 'IH_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INTERFACE_WOL', 'I', 'IWOL_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INTERFACE_WOR', 'I', 'IWOR_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_ATTRI_DOMAINS', 'I', 'IAD_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_ATTRI_DOMAINS', 'I', 'IAD_INDEX_P2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_ITEMS_ALL', 'I', 'IIT_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_ITEMS_ALL', 'I', 'IIT_INDEX_P2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_ITEMS_ALL', 'I', 'IIT_INDEX_S1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_ITEMS_ALL', 'I', 'IIT_INDEX_S2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_ITEMS_ALL', 'I', 'IIT_INDEX_S3', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_ITEM_HISTORY', 'I', 'IIH_IND_NEW_ITEM', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_ITEM_HISTORY', 'I', 'IIH_IND_RSE', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_ITEM_TYPES', 'I', 'ITY_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_ITEM_TYPES', 'I', 'ITY_INDEX_P2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_TYPE_ATTRIBS', 'I', 'ITA_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_TYPE_ATTRIBS', 'I', 'ITA_INDEX_P2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ITEM_CODE_BREAKDOWNS', 'I', 'ICB_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ITEM_CODE_BREAKDOWNS', 'I', 'ICB_INDEX_P2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ITEM_CODE_BREAKDOWNS', 'I', 'ICB_INDEX_P3', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ITEM_CODE_BREAKDOWNS', 'I', 'ICB_INDEX_P4', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ITEM_CODE_BREAKDOWNS', 'I', 'ICB_INDEX_S1', 'MAI'); 
COMMIT;
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'LAMP_CONFIGS', 'I', 'LCO_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'LOCAL_FREQS', 'I', 'LFR_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NOTICES', 'I', 'NOT_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NOTICE_DEFECTS', 'I', 'NOD_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ORG_UNITS', 'I', 'OUN_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ORG_UNITS', 'I', 'OUN_INDEX_S1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'PBI_QUERY', 'I', 'PBI_QRY_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'PEOPLE', 'I', 'PEO_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'PEOPLE', 'I', 'PEO_INDEX_S2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'RELATED_INVENTORY', 'I', 'REL_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'RELATED_MAINTENANCE', 'I', 'REM_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'REPAIRS', 'I', 'REP_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEDULES', 'I', 'SCHD_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEDULE_ITEMS', 'I', 'SCHI_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEDULE_ROADS', 'I', 'SCHR_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEMES', 'I', 'SCH_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEME_ACTIVITIES', 'I', 'SAC_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEME_ASSESSMENTS', 'I', 'SAS_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEME_CONTRACTORS', 'I', 'SCO_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEME_HISTORY', 'I', 'SHI_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEME_ROADS', 'I', 'SRO_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEME_ROADS', 'I', 'SRO_INDEX_P2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEME_ROADS', 'I', 'SRO_INDEX_S1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SECTION_FREQS', 'I', 'SFR_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SECTION_FREQS', 'I', 'SFR_INDEX_P2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STANDARD_ITEMS', 'I', 'STA_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STANDARD_ITEMS', 'I', 'STA_INDEX_S1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STANDARD_ITEM_SECTIONS', 'I', 'SIS_INDEX_S1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STANDARD_ITEM_SECTIONS', 'I', 'SIS_IND_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STANDARD_ITEM_SUB_SECTIONS', 'I', 'SISS_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STANDARD_ITEM_SUB_SECTIONS', 'I', 'SISS_INDEX_S1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_CONTRACTS_LOCK', 'I', 'TCL_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TREATMENTS', 'I', 'TRE_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TREATMENT_MODELS', 'I', 'TMO_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TREATMENT_MODELS', 'I', 'TMO_INDEX_S1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TREATMENT_MODEL_ITEMS', 'I', 'TMI_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'VALID_FOR_MAINTENANCE', 'I', 'VFM_INDEX_S1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WOL_INTERIM_PAYMENTS', 'I', 'WIP_INDEX_P2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WORK_ORDERS', 'I', 'WOR_CON_IND', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WORK_ORDERS', 'I', 'WOR_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WORK_ORDERS', 'I', 'WOR_INDEX_P3', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WORK_ORDER_CLAIMS', 'I', 'WOC_INDEX_W1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WORK_ORDER_CLAIMS', 'I', 'WOC_PK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WORK_ORDER_LINES', 'I', 'WOL_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WORK_ORDER_LINES', 'I', 'WOL_INDEX_S1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WORK_ORDER_LINES', 'I', 'WOL_INDEX_S2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WORK_ORDER_LINES', 'I', 'WOL_INDEX_S3', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WORK_ORDER_LINES', 'I', 'WOL_INDEX_S4', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WORK_ORDER_LINES', 'I', 'WOL_INDEX_S5', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WORK_ORDER_LINES', 'I', 'WOL_RSE_IND', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WO_AUDIT', 'I', 'WAD_INDEX_W1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'XSP_RESTRAINTS', 'I', 'XSR_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'XSP_REVERSAL', 'I', 'XRV_INDEX_P1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'INTERFACES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'INT_UTILITY', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'INV', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'INV_COPY', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'MAI', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'MAI2325', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'MAICLOSE', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'MAIFINM', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'MAIGIS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'MAIMERGE', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'MAIPBI', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'MAIRECAL', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'MAIREPL', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'MAIREPORTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'MAISPLIT', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'MAIWO', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'MAI_AUDIT', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'MAI_BUDGETS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'P$INTERFACE', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'PEDIF', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'PMSLAYER', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'WWO', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'ARE_BATCH_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'ARE_REPORT_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'BOQ_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'BUD_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'CNP_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'CON_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'DEF_DEFECT_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'EXT_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'FILE_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'ICB_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'IH_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'IIT_ITEM_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'INSURANCE_CLAIM_ID', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'IWOR_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'NEG_BOQ_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'NEXT_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'NOT_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'OUN_ORG_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'PBI_ID', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'PBR_ID', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'PEO_PERSON_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SCHD_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SCHEME_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SCH_RD_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'TMO_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'WOC_REF_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'WOL_CHECK_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'WOL_ID_SEQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACTIVITIES', 'T', 'ACTIVITIES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACTIVITIES_REPORT', 'T', 'ACTIVITIES_REPORT', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACTIVITY_GROUPS', 'T', 'ACTIVITY_GROUPS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACT_FREQS', 'T', 'ACT_FREQS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACT_GROUP_MEMBS', 'T', 'ACT_GROUP_MEMBS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ACT_REPORT_LINES', 'T', 'ACT_REPORT_LINES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'AUTO_DEFECT_SELECTION_PRIORITY', 'T', 'AUTO_DEFECT_SELECTION_PRIORITY', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BOQ_ITEMS', 'T', 'BOQ_ITEMS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BPR34A_TT', 'T', 'BPR34A_TT', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BPR34B_TT', 'T', 'BPR34B_TT', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BPR35A_TT', 'T', 'BPR35A_TT', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BPR35B_TT', 'T', 'BPR35B_TT', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BUDGETS', 'T', 'BUDGETS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLAIM_PAYMENTS', 'T', 'CLAIM_PAYMENTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'COLOUR_LAYER_MAP', 'T', 'COLOUR_LAYER_MAP', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CONTRACTOR_DISC_BANDS', 'T', 'CONTRACTOR_DISC_BANDS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CONTRACTOR_DISC_GROUPS', 'T', 'CONTRACTOR_DISC_GROUPS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CONTRACTS', 'T', 'CONTRACTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CONTRACT_ITEMS', 'T', 'CONTRACT_ITEMS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CONTRACT_PAYMENTS', 'T', 'CONTRACT_PAYMENTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CONTRACT_SURCHARGES', 'T', 'CONTRACT_SURCHARGES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'COST_CENTRES', 'T', 'COST_CENTRES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFAULT_TREATS', 'T', 'DEFAULT_TREATS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECTS', 'T', 'DEFECTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEFECT_PRIORITIES', 'T', 'DEFECT_PRIORITIES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEF_MOVEMENTS', 'T', 'DEF_MOVEMENTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEF_TREATS', 'T', 'DEF_TREATS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEF_TYPES', 'T', 'DEF_TYPES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DELETED_DEFECTS', 'T', 'DELETED_DEFECTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DEL_INV_ITEMS', 'T', 'DEL_INV_ITEMS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_DEF_PRIORITIES', 'T', 'DOC_DEF_PRIORITIES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'DOC_DEF_TREATS', 'T', 'DOC_DEF_TREATS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'EXT_ACTIVITIES', 'T', 'EXT_ACTIVITIES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'EXT_ACT_ROAD_USAGE', 'T', 'EXT_ACT_ROAD_USAGE', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'FINANCIAL_YEARS', 'T', 'FINANCIAL_YEARS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HHINV_HOLD_1', 'T', 'HHINV_HOLD_1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HHINV_ITEM_ERR_1', 'T', 'HHINV_ITEM_ERR_1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HHINV_ITEM_ERR_2', 'T', 'HHINV_ITEM_ERR_2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HHINV_ITEM_ERR_3', 'T', 'HHINV_ITEM_ERR_3', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HHINV_LOAD_1', 'T', 'HHINV_LOAD_1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HHINV_LOAD_2', 'T', 'HHINV_LOAD_2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HHINV_LOAD_3', 'T', 'HHINV_LOAD_3', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HHINV_ODL_LOG', 'T', 'HHINV_ODL_LOG', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HHINV_RUN_LOG', 'T', 'HHINV_RUN_LOG', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HHINV_SECT_LOG', 'T', 'HHINV_SECT_LOG', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HH_LOAD_BATCHES', 'T', 'HH_LOAD_BATCHES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HH_LOAD_RECS', 'T', 'HH_LOAD_RECS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_JOIN_DEFS', 'T', 'HIG_HD_JOIN_DEFS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_LOOKUP_JOIN_COLS', 'T', 'HIG_HD_LOOKUP_JOIN_COLS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_LOOKUP_JOIN_DEFS', 'T', 'HIG_HD_LOOKUP_JOIN_DEFS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_MODULES', 'T', 'HIG_HD_MODULES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_MOD_USES', 'T', 'HIG_HD_MOD_USES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_SELECTED_COLS', 'T', 'HIG_HD_SELECTED_COLS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'HIG_HD_TABLE_JOIN_COLS', 'T', 'HIG_HD_TABLE_JOIN_COLS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'IFF_SECT_STACK', 'T', 'IFF_SECT_STACK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'IHMS_ALLOCATED_AMTS', 'T', 'IHMS_ALLOCATED_AMTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'IHMS_CONVERSIONS', 'T', 'IHMS_CONVERSIONS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INSURANCE_CLAIM_ACTIVITIES', 'T', 'INSURANCE_CLAIM_ACTIVITIES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INSURANCE_CLAIM_PARAMETERS', 'T', 'INSURANCE_CLAIM_PARAMETERS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INTERFACE_BOQ', 'T', 'INTERFACE_BOQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INTERFACE_CLAIMS_BOQ_ALL', 'T', 'INTERFACE_CLAIMS_BOQ_ALL', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INTERFACE_CLAIMS_WOL_ALL', 'T', 'INTERFACE_CLAIMS_WOL_ALL', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INTERFACE_CLAIMS_WOR_ALL', 'T', 'INTERFACE_CLAIMS_WOR_ALL', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INTERFACE_COMPLETIONS_ALL', 'T', 'INTERFACE_COMPLETIONS_ALL', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INTERFACE_ERRONEOUS_RECORDS', 'T', 'INTERFACE_ERRONEOUS_RECORDS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INTERFACE_HEADERS', 'T', 'INTERFACE_HEADERS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INTERFACE_RUN_LOG', 'T', 'INTERFACE_RUN_LOG', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INTERFACE_WOL', 'T', 'INTERFACE_WOL', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INTERFACE_WOR', 'T', 'INTERFACE_WOR', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_ATTRI_DOMAINS', 'T', 'INV_ATTRI_DOMAINS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_ATTRI_ROW_CNT', 'T', 'INV_ATTRI_ROW_CNT', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_ITEMS_ALL', 'T', 'INV_ITEMS_ALL', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_ITEM_HISTORY', 'T', 'INV_ITEM_HISTORY', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_ITEM_TYPES', 'T', 'INV_ITEM_TYPES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_MP_ERRORS', 'T', 'INV_MP_ERRORS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_TMP', 'T', 'INV_TMP', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_TYPE_ATTRIBS', 'T', 'INV_TYPE_ATTRIBS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'INV_TYPE_COLOURS', 'T', 'INV_TYPE_COLOURS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ITEM_CODE_BREAKDOWNS', 'T', 'ITEM_CODE_BREAKDOWNS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ITY_CATEGORY_ROLES', 'T', 'ITY_CATEGORY_ROLES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'JOB_SIZES', 'T', 'JOB_SIZES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'LAMP_CONFIGS', 'T', 'LAMP_CONFIGS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'LOAD_ERRORS', 'T', 'LOAD_ERRORS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'LOCAL_FREQS', 'T', 'LOCAL_FREQS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'MAI2325_QUERY', 'T', 'MAI2325_QUERY', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'MAI2325_RESULTS', 'T', 'MAI2325_RESULTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'MAI3890_DOCTMP', 'T', 'MAI3890_DOCTMP', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'MAI3890_INVTMP', 'T', 'MAI3890_INVTMP', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'MAI3890_WKTMP', 'T', 'MAI3890_WKTMP', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NAVIGATOR', 'T', 'NAVIGATOR', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NL_AREA_USAGES', 'T', 'NL_AREA_USAGES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NOTICES', 'T', 'NOTICES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'NOTICE_DEFECTS', 'T', 'NOTICE_DEFECTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ORG_UNITS', 'T', 'ORG_UNITS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'PBI_QUERY', 'T', 'PBI_QUERY', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'PBI_QUERY_ATTRIBS', 'T', 'PBI_QUERY_ATTRIBS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'PBI_QUERY_TYPES', 'T', 'PBI_QUERY_TYPES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'PBI_RESULTS', 'T', 'PBI_RESULTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'PBI_RESULTS_INV', 'T', 'PBI_RESULTS_INV', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'PEOPLE', 'T', 'PEOPLE', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'QUERYTAB$$$', 'T', 'QUERYTAB$$$', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'RELATED_INVENTORY', 'T', 'RELATED_INVENTORY', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'RELATED_MAINTENANCE', 'T', 'RELATED_MAINTENANCE', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'REPAIRS', 'T', 'REPAIRS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'RIRF_ACTIVITIES', 'T', 'RIRF_ACTIVITIES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'RIRF_ACTIVITY_INT', 'T', 'RIRF_ACTIVITY_INT', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'RIRF_DEF_TYPES', 'T', 'RIRF_DEF_TYPES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'RIRF_SECT_FREQS', 'T', 'RIRF_SECT_FREQS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'RIRF_XSP_VALUES', 'T', 'RIRF_XSP_VALUES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEDULES', 'T', 'SCHEDULES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEDULE_ITEMS', 'T', 'SCHEDULE_ITEMS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEDULE_ROADS', 'T', 'SCHEDULE_ROADS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEMES', 'T', 'SCHEMES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEME_ACTIVITIES', 'T', 'SCHEME_ACTIVITIES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEME_ASSESSMENTS', 'T', 'SCHEME_ASSESSMENTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEME_CONTRACTORS', 'T', 'SCHEME_CONTRACTORS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEME_HISTORY', 'T', 'SCHEME_HISTORY', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SCHEME_ROADS', 'T', 'SCHEME_ROADS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SECTION_FREQS', 'T', 'SECTION_FREQS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SECT_FREQ1', 'T', 'SECT_FREQ1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SECT_FREQ2', 'T', 'SECT_FREQ2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STANDARD_ITEMS', 'T', 'STANDARD_ITEMS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STANDARD_ITEM_SECTIONS', 'T', 'STANDARD_ITEM_SECTIONS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STANDARD_ITEM_SUB_SECTIONS', 'T', 'STANDARD_ITEM_SUB_SECTIONS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_2140', 'T', 'TEMP_2140', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_ACT_LINES', 'T', 'TEMP_ACT_LINES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_BPR3100_ARE', 'T', 'TEMP_BPR3100_ARE', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_BPR3100_ARL', 'T', 'TEMP_BPR3100_ARL', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_CONTRACTS_LOCK', 'T', 'TEMP_CONTRACTS_LOCK', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_DEFECTS', 'T', 'TEMP_DEFECTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_LOAD_2', 'T', 'TEMP_LOAD_2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_PMS4440_COMMENTS', 'T', 'TEMP_PMS4440_COMMENTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_PMS4440_COMPSCHEMES', 'T', 'TEMP_PMS4440_COMPSCHEMES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_PMS4440_DEFBANDS', 'T', 'TEMP_PMS4440_DEFBANDS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_PMS4440_DEFECTS', 'T', 'TEMP_PMS4440_DEFECTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_PMS4440_DEFECT_LIST', 'T', 'TEMP_PMS4440_DEFECT_LIST', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_PMS4440_DETTRTS', 'T', 'TEMP_PMS4440_DETTRTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_PMS4440_REPORT_SECTIONS', 'T', 'TEMP_PMS4440_REPORT_SECTIONS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_PMS4440_ROADCONS', 'T', 'TEMP_PMS4440_ROADCONS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_PMS4440_STRIP_DATA', 'T', 'TEMP_PMS4440_STRIP_DATA', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_PMS4440_STRIP_HEADER', 'T', 'TEMP_PMS4440_STRIP_HEADER', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_PMS4440_STRIP_LIST', 'T', 'TEMP_PMS4440_STRIP_LIST', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_REPLACE_DEFECTS', 'T', 'TEMP_REPLACE_DEFECTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_SPLIT_LINES', 'T', 'TEMP_SPLIT_LINES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_UNMERGE_DEFECTS', 'T', 'TEMP_UNMERGE_DEFECTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_UNREPLACE_DEFECTS', 'T', 'TEMP_UNREPLACE_DEFECTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_UNSPLIT_DEFECTS', 'T', 'TEMP_UNSPLIT_DEFECTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TMP_BPR2140', 'T', 'TMP_BPR2140', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TREATMENTS', 'T', 'TREATMENTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TREATMENT_MODELS', 'T', 'TREATMENT_MODELS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TREATMENT_MODEL_ITEMS', 'T', 'TREATMENT_MODEL_ITEMS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'VALID_FOR_MAINTENANCE', 'T', 'VALID_FOR_MAINTENANCE', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'VAT_RATES', 'T', 'VAT_RATES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WOL_INTERIM_PAYMENTS', 'T', 'WOL_INTERIM_PAYMENTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WORK_ORDERS', 'T', 'WORK_ORDERS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WORK_ORDER_CLAIMS', 'T', 'WORK_ORDER_CLAIMS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WORK_ORDER_LINES', 'T', 'WORK_ORDER_LINES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WO_AUDIT', 'T', 'WO_AUDIT', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'WO_AUDIT_COLUMNS', 'T', 'WO_AUDIT_COLUMNS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'XSP_RESTRAINTS', 'T', 'XSP_RESTRAINTS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'XSP_REVERSAL', 'T', 'XSP_REVERSAL', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'BUDGET_LINES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'DEF_REP_TREAT', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'DEF_REP_TREAT_WO', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'GIS_WORK_ORDERS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'INTERFACE_CLAIMS_BOQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'INTERFACE_CLAIMS_WOL', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'INTERFACE_CLAIMS_WOR', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'INTERFACE_COMPLETIONS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'INV_ITEMS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'INV_ON_ROADS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'INV_ON_ROUTE', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'TEMP_ACTIVITIES_REPORT', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'TEMP_ACT_REPORT_LINES', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V1', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V3', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V5', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_BUDGETS', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_BUDGETS2', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_BUDGETS3', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_DISC_USAGE', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_MAI3800_AUD', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_MAI3800_BOQ', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_MAI3800_CON', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_MAI3806_DEF', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_MAI3816_NOT', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_MAI3820_WOL', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_MAI3842_WOL', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_MAI7040_DET', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_MAI7040_SUM', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_ROAD_CONSTRUCTION', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_WWO', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_WWOL', 'MAI'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ATTACHMENTS', 'C', 'CLM_ATT_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ATT_UNITS', 'C', 'CLM_ATT_FK_UNI', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ATT_UNITS', 'C', 'CLM_AUN_FK_ATT', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_BUDGETS', 'C', 'CLM_BUD_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_BUDGETS', 'C', 'CLM_BUD_UK1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_BUDGET_AMOUNTS', 'C', 'CLM_CBA_FK_BUD', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_BUDGET_AMOUNTS', 'C', 'CLM_CBA_FK_FYR', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_BUDGET_AMOUNTS', 'C', 'CLM_CBA_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_BUDGET_STATUS', 'C', 'CLM_CBS_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_BUDGET_STATUS', 'C', 'CLM_CBS_UK1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CIRCUITS', 'C', 'CLM_CIR_FK_UNI', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CIRCUITS', 'C', 'CLM_CIR_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CIRCUIT_UNITS', 'C', 'CLM_CIR_UNITS_UK1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CIRCUIT_UNITS', 'C', 'CLM_CIR_UNITS_UK2', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CIRCUIT_UNITS', 'C', 'CLM_CIU_FK_CIR', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CIRCUIT_UNITS', 'C', 'CLM_CIU_FK_FEEDER_UNI', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CIRCUIT_UNITS', 'C', 'CLM_CIU_FK_FROM_UNI', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CIRCUIT_UNITS', 'C', 'CLM_CIU_FK_UNI', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CIRCUIT_UNITS', 'C', 'CLM_CIU_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CONTRACTS', 'C', 'CLM_CON_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CONTRACT_ITEMS', 'C', 'CLM_CIT_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CONTRACT_ITEM_HISTORY', 'C', 'CLM_CIH_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ENERGY_EXTRACT_COLUMNS', 'C', 'CLM_EEC_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ENERGY_EXTRACT_COLUMNS', 'C', 'CLM_EEC_UK1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULTS', 'C', 'CLM_FAU_FK_BUD', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULTS', 'C', 'CLM_FAU_FK_FYR', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULTS', 'C', 'CLM_FAU_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULTS', 'C', 'FAU_UK1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_BUDGET_TEMPLATES', 'C', 'CLM_CFB_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_BUDGET_TEMPLATES', 'C', 'CLM_CFB_UK1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_CODES', 'C', 'CLM_FCO_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_COMM_AMOUNTS', 'C', 'CLM_CFA_FK_FCO', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_COMM_AMOUNTS', 'C', 'CLM_CFA_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_COMM_AMOUNTS', 'C', 'CLM_CFA_UK1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_INSPECTIONS', 'C', 'CLM_CFI_FK_PER', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_INSPECTIONS', 'C', 'CLM_CFI_FK_ROU', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_INSPECTIONS', 'C', 'CLM_CFI_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FINANCIAL_YEARS', 'C', 'CLM_FYR_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTABLE_COMPONENTS', 'C', 'CIC_FK_CUD', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTABLE_COMPONENTS', 'C', 'CIC_FK_PARENT', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTABLE_COMPONENTS', 'C', 'CIC_FK_TOP', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTABLE_COMPONENTS', 'C', 'CIC_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTABLE_COMPONENTS', 'C', 'CIC_UK_1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTIONS', 'C', 'CIN_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTIONS', 'C', 'INS_FK_CIB', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTION_BATCHES', 'C', 'CIB_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTION_DETAILS', 'C', 'CID_FK_CIC', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTION_DETAILS', 'C', 'CID_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ORG_UNITS', 'C', 'CLM_OUN_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_PAYMENTS', 'C', 'CLM_CPA_FK_CPR', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_PAYMENT_RUNS', 'C', 'CLM_CPR_FK_CON', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_PAYMENT_RUNS', 'C', 'CLM_CPR_FK_FYR', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_PAYMENT_RUNS', 'C', 'CLM_CPR_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_PERSONS', 'C', 'CLM_PER_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ROUTES', 'C', 'CLM_CRO_FK_PER', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ROUTES', 'C', 'CLM_ROU_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SCHEDULE_CALENDAR', 'C', 'CLM_SCD_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SCHEDULE_CALENDAR', 'C', 'CLM_SCD_UK1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SCHEDULE_ITEM_PARAMETERS', 'C', 'CLM_SIP_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNITS_ALL', 'C', 'CLM_UNI_FK_SUP_OWN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNITS_ALL', 'C', 'CLM_UNI_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_USER_DOMAIN', 'C', 'CUD_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_USER_DOMAIN', 'C', 'CUD_UK1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_USER_LOOKUP', 'C', 'CUL_FK_CUD', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_USER_LOOKUP', 'C', 'CUL_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALID_LAMPS', 'C', 'VLA_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ITEMS', 'C', 'CLM_WIT_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ORDERS', 'C', 'CLM_WOR_FK_BUD', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ORDERS', 'C', 'CLM_WOR_FK_FYR', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ORDERS', 'C', 'CLM_WOR_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ORDER_LINES', 'C', 'CLM_WLI_FK_BUD', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ORDER_LINES', 'C', 'CLM_WLI_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CONTRACT_ITEMS', 'G', 'CONTRACT_ITEM_HISTORY', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTIONS', 'G', 'CREATE_DEFAULT_INSP_DETS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ORDER_LINES', 'G', 'CLM_WIT_WLI_BD1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ATTACHMENTS', 'I', 'CLM_ATT_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_BUDGETS', 'I', 'CLM_BUD_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_BUDGETS', 'I', 'CLM_BUD_UK1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_BUDGET_AMOUNTS', 'I', 'CLM_CBA_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_BUDGET_STATUS', 'I', 'CLM_CBS_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_BUDGET_STATUS', 'I', 'CLM_CBS_UK1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CIRCUITS', 'I', 'CLM_CIR_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CIRCUIT_UNITS', 'I', 'CLM_CIR_UNITS_UK1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CIRCUIT_UNITS', 'I', 'CLM_CIR_UNITS_UK2', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CIRCUIT_UNITS', 'I', 'CLM_CIU_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CONTRACTS', 'I', 'CLM_CON_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CONTRACT_ITEMS', 'I', 'CLM_CIT_FK_CON', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CONTRACT_ITEMS', 'I', 'CLM_CIT_FK_SIT', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CONTRACT_ITEMS', 'I', 'CLM_CIT_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CONTRACT_ITEM_HISTORY', 'I', 'CLM_CIH_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ENERGY_BUDGET_GROUPS', 'I', 'VLG_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ENERGY_EXTRACT_COLUMNS', 'I', 'CLM_EEC_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ENERGY_EXTRACT_COLUMNS', 'I', 'CLM_EEC_UK1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULTS', 'I', 'CLM_FAU_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULTS', 'I', 'FAU_IND_UNI', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULTS', 'I', 'FAU_UK1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_BUDGET_TEMPLATES', 'I', 'CLM_CFB_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_BUDGET_TEMPLATES', 'I', 'CLM_CFB_UK1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_CODES', 'I', 'CLM_FCO_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_COMM_AMOUNTS', 'I', 'CLM_CFA_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_COMM_AMOUNTS', 'I', 'CLM_CFA_UK1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_HIST', 'I', 'CLM_FHI_FK_FAU', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_INSPECTIONS', 'I', 'CLM_CFI_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FINANCIAL_YEARS', 'I', 'CLM_FYR_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTABLE_COMPONENTS', 'I', 'CIC_IND_PARENT', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTABLE_COMPONENTS', 'I', 'CIC_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTABLE_COMPONENTS', 'I', 'CIC_TOP', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTABLE_COMPONENTS', 'I', 'CIC_UK_1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTIONS', 'I', 'CIN_IND_CIB', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTIONS', 'I', 'CIN_IND_UNI', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTIONS', 'I', 'CIN_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTION_BATCHES', 'I', 'CIB_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTION_DETAILS', 'I', 'CID_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ORG_UNITS', 'I', 'CLM_OUN_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_PARISHES', 'I', 'PA_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_PARISHES', 'I', 'PA_UK1_UNIQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_PATH_NAMES', 'I', 'PNA_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_PAYMENT_RUNS', 'I', 'CLM_CPR_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_PERSONS', 'I', 'CLM_PER_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_PERSONS', 'I', 'PER_UK1_UNIQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_RECHARGE_CODES', 'I', 'RCO_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_RECHARGE_CODES', 'I', 'RCO_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_REC_CLASS_CODES', 'I', 'REC_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_REC_CONTROL_GEAR_CODES', 'I', 'RCG_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_REC_CONTROL_SWITCH_CODES', 'I', 'RCS_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_REC_LAMP_CODES', 'I', 'RLC_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_REPAIRS', 'I', 'REP_PK1_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_REPAIR_ITEMS', 'I', 'RIT_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_REPAIR_ITEMS', 'I', 'RIT_FK2_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_REPAIR_ITEMS', 'I', 'RIT_FK3_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_REPAIR_ITEMS', 'I', 'RIT_PK1_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_REPAIR_SCHEDULE_ITEMS', 'I', 'RSI_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_REPAIR_SCHEDULE_ITEMS', 'I', 'RSI_FK2_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_REPAIR_SCHEDULE_ITEMS', 'I', 'RSI_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_REPORT_LOG', 'I', 'RLO_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ROAD_LIGHTING_SCHEMES', 'I', 'RSC_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ROAD_LIGHTING_SCHEMES', 'I', 'RSC_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ROUTES', 'I', 'CLM_ROU_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ROUTE_LINES', 'I', 'RLI_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ROUTE_LINES', 'I', 'RLI_FK2_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ROUTE_LINES', 'I', 'RLI_PK1_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SCHEDULES', 'I', 'SCD_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SCHEDULES', 'I', 'SCD_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SCHEDULE_CALENDAR', 'I', 'CLM_SCD_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SCHEDULE_CALENDAR', 'I', 'CLM_SCD_UK1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SCHEDULE_ITEMS', 'I', 'SIT_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SCHEDULE_ITEMS', 'I', 'SIT_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SCHEDULE_ITEMS', 'I', 'SIT_UK1_UNIQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SCHEDULE_ITEM_PARAMETERS', 'I', 'CLM_SIP_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STATUS_DAYS', 'I', 'SDA_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STATUS_DAYS', 'I', 'SDA_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STREETS', 'I', 'STR_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STREETS', 'I', 'STR_FK2_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STREETS', 'I', 'STR_IND1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STREETS', 'I', 'STR_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STREET_ALIASES', 'I', 'SAL_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STREET_ALIASES', 'I', 'SAL_FK2_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STREET_ALIASES', 'I', 'SAL_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STREET_ALIASES', 'I', 'SAL_UK1_UNIQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STREET_DESIGNATIONS', 'I', 'SDE_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STREET_DIVISIONS', 'I', 'SDI_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STREET_GROUPS', 'I', 'SGR_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STREET_GROUPS', 'I', 'SGR_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STREET_SCHEMES', 'I', 'SCH_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STREET_SCHEMES', 'I', 'SCH_FK2_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STREET_SCHEMES', 'I', 'SCH_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SWITCH_TOTALS', 'I', 'ST0_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SWITCH_TOTALS', 'I', 'STO_FK2_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SWITCH_TOTALS', 'I', 'STO_FK5_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SWITCH_TOTALS', 'I', 'STO_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SYS_DEFS', 'I', 'SDF_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SYS_DEFS', 'I', 'SDF_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_TARIFF_RATES', 'I', 'TRA_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNITS_ALL', 'I', 'CLM_UNI_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNITS_ALL', 'I', 'UNI_FK10_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNITS_ALL', 'I', 'UNI_FK11_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNITS_ALL', 'I', 'UNI_FK12_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNITS_ALL', 'I', 'UNI_FK13_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNITS_ALL', 'I', 'UNI_FK14_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNITS_ALL', 'I', 'UNI_FK15_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNITS_ALL', 'I', 'UNI_FK2_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNITS_ALL', 'I', 'UNI_FK3_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNITS_ALL', 'I', 'UNI_FK4_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNITS_ALL', 'I', 'UNI_FK5_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNITS_ALL', 'I', 'UNI_FK6_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNITS_ALL', 'I', 'UNI_FK7_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNITS_ALL', 'I', 'UNI_FK8_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNITS_ALL', 'I', 'UNI_FK9_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNITS_ALL', 'I', 'UNI_PAR_ID', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNITS_ALL', 'I', 'UNI_UNIT_TYPE', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNIT_ERRORS', 'I', 'UER_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNIT_ERRORS', 'I', 'UER_FK4_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNIT_ERRORS', 'I', 'UER_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNIT_HISTORY', 'I', 'UHI_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNIT_HISTORY', 'I', 'UHI_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNIT_MANAGERS', 'I', 'UMA_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNIT_MANAGERS', 'I', 'UMA_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNIT_MANAGERS', 'I', 'UMA_UK1_UNIQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_USER_DOMAIN', 'I', 'CUD_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_USER_DOMAIN', 'I', 'CUD_UK1', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_USER_LOOKUP', 'I', 'CUL_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALIDATION_CODES', 'I', 'VCO_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALIDATION_CODE_KEYS', 'I', 'VKE_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALID_GROUPS', 'I', 'VGR_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALID_GROUPS', 'I', 'VGR_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALID_HEIGHTS', 'I', 'VHE_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALID_HEIGHTS', 'I', 'VHE_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALID_LAMPS', 'I', 'VLA_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALID_LAMPS', 'I', 'VLA_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALID_LAMPS', 'I', 'VLA_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALID_LANTERNS', 'I', 'VLN_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALID_LANTERNS', 'I', 'VLN_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALID_UNIT_TYPES', 'I', 'VTY_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALID_UNIT_TYPES', 'I', 'VTY_FK2_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALID_UNIT_TYPES', 'I', 'VTY_FK3_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALID_UNIT_TYPES', 'I', 'VTY_PK_PRIM', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ITEMS', 'I', 'CLM_WIT_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ITEMS', 'I', 'WIT_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ITEMS', 'I', 'WIT_FK2_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ITEMS', 'I', 'WIT_FK3_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ITEMS', 'I', 'WIT_FK4_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ORDERS', 'I', 'CLM_WOR_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ORDERS', 'I', 'WOR_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ORDERS', 'I', 'WOR_FK7_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ORDER_LINES', 'I', 'CLM_WLI_PK', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ORDER_LINES', 'I', 'WLI_FK1_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ORDER_LINES', 'I', 'WLI_FK3_FRGN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ORDER_REPAIRS', 'I', 'WOR_FK_WOR_ID', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'CLMINSP', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'FCO_VALIDATE', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'OUN_VALIDATE', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'PMT_PROCESSING', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'STR_VALIDATE', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'VCO_VALIDATE', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'CLM_UNIT_STATUS_ALLOW_VALUES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'CBA_ID_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'CBS_ID_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'CFA_ID_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'CFB_ID_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'CFI_ID_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'CIH_ID_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'CIR_ID_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'CIT_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'CIU_ID_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'CLM_BATCH_ID_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'CLM_BUD_ID_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'CLM_COMP_ID_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'CLM_EEC_ID_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'CLM_INSP_ID_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'CON_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'CPA_PAY_ID_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'FAU_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'FDA_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'FHI_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'MCA_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'MCR_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'OUN_ID_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'PAR_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'PER_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'RIT_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SCD_ID_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SCD_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SDA_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SIP_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SIT_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'STR_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'UER_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'UHI_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'UNI_ID_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'VLA_ID_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'WAY_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'WIT_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'WLI_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'WOR_SEQ', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ACCOUNT_PERIODS', 'T', 'CLM_ACCOUNT_PERIODS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ARCHIVES', 'T', 'CLM_ARCHIVES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ATTACHMENTS', 'T', 'CLM_ATTACHMENTS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ATT_UNITS', 'T', 'CLM_ATT_UNITS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_BUDGETS', 'T', 'CLM_BUDGETS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_BUDGET_AMOUNTS', 'T', 'CLM_BUDGET_AMOUNTS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_BUDGET_STATUS', 'T', 'CLM_BUDGET_STATUS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CIRCUITS', 'T', 'CLM_CIRCUITS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CIRCUIT_UNITS', 'T', 'CLM_CIRCUIT_UNITS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CLASS_OF_SCHEDS', 'T', 'CLM_CLASS_OF_SCHEDS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CONTRACTOR_USERS', 'T', 'CLM_CONTRACTOR_USERS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CONTRACTS', 'T', 'CLM_CONTRACTS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CONTRACT_ITEMS', 'T', 'CLM_CONTRACT_ITEMS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CONTRACT_ITEM_HISTORY', 'T', 'CLM_CONTRACT_ITEM_HISTORY', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CONTRACT_PRIORITIES', 'T', 'CLM_CONTRACT_PRIORITIES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CONTROL_SWITCHES', 'T', 'CLM_CONTROL_SWITCHES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CONTROL_SWITCH_RATES', 'T', 'CLM_CONTROL_SWITCH_RATES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_CONTROL_SWITCH_RENTALS', 'T', 'CLM_CONTROL_SWITCH_RENTALS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_DELETED_UNITS', 'T', 'CLM_DELETED_UNITS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ENERGY_BUDGET_CODES', 'T', 'CLM_ENERGY_BUDGET_CODES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ENERGY_BUDGET_GROUPS', 'T', 'CLM_ENERGY_BUDGET_GROUPS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ENERGY_EXTRACT_COLUMNS', 'T', 'CLM_ENERGY_EXTRACT_COLUMNS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_EXPORT_DATES', 'T', 'CLM_EXPORT_DATES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULTS', 'T', 'CLM_FAULTS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_BUDGET_TEMPLATES', 'T', 'CLM_FAULT_BUDGET_TEMPLATES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_CLEARANCE', 'T', 'CLM_FAULT_CLEARANCE', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_CODES', 'T', 'CLM_FAULT_CODES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_COMM_AMOUNTS', 'T', 'CLM_FAULT_COMM_AMOUNTS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_DAMAGE', 'T', 'CLM_FAULT_DAMAGE', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_HIST', 'T', 'CLM_FAULT_HIST', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_INSPECTIONS', 'T', 'CLM_FAULT_INSPECTIONS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FAULT_NOTIFICATIONS', 'T', 'CLM_FAULT_NOTIFICATIONS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_FINANCIAL_YEARS', 'T', 'CLM_FINANCIAL_YEARS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTABLE_COMPONENTS', 'T', 'CLM_INSPECTABLE_COMPONENTS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTIONS', 'T', 'CLM_INSPECTIONS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTION_BATCHES', 'T', 'CLM_INSPECTION_BATCHES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INSPECTION_DETAILS', 'T', 'CLM_INSPECTION_DETAILS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_INTERVALS', 'T', 'CLM_INTERVALS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_LAMP_MONTH_BURNAGE', 'T', 'CLM_LAMP_MONTH_BURNAGE', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_MAINTENANCE_ACTIVITIES', 'T', 'CLM_MAINTENANCE_ACTIVITIES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_MAINTENANCE_REPAIRS', 'T', 'CLM_MAINTENANCE_REPAIRS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_MAINT_REPORT_PARAMS', 'T', 'CLM_MAINT_REPORT_PARAMS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_OLD_UNIT_TOTALS', 'T', 'CLM_OLD_UNIT_TOTALS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ORG_CONTACTS', 'T', 'CLM_ORG_CONTACTS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ORG_DIVISIONS', 'T', 'CLM_ORG_DIVISIONS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ORG_UNITS', 'T', 'CLM_ORG_UNITS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_PARISHES', 'T', 'CLM_PARISHES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_PATH_NAMES', 'T', 'CLM_PATH_NAMES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_PAYMENTS', 'T', 'CLM_PAYMENTS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_PAYMENT_RUNS', 'T', 'CLM_PAYMENT_RUNS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_PERSONS', 'T', 'CLM_PERSONS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_PRINT_FAULTS', 'T', 'CLM_PRINT_FAULTS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_RECHARGE_CODES', 'T', 'CLM_RECHARGE_CODES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_REC_CLASS_CODES', 'T', 'CLM_REC_CLASS_CODES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_REC_CONTROL_GEAR_CODES', 'T', 'CLM_REC_CONTROL_GEAR_CODES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_REC_CONTROL_SWITCH_CODES', 'T', 'CLM_REC_CONTROL_SWITCH_CODES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_REC_LAMP_CODES', 'T', 'CLM_REC_LAMP_CODES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_REPAIRS', 'T', 'CLM_REPAIRS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_REPAIR_ITEMS', 'T', 'CLM_REPAIR_ITEMS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_REPAIR_SCHEDULE_ITEMS', 'T', 'CLM_REPAIR_SCHEDULE_ITEMS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_REPORT_LOG', 'T', 'CLM_REPORT_LOG', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ROAD_LIGHTING_SCHEMES', 'T', 'CLM_ROAD_LIGHTING_SCHEMES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ROUTES', 'T', 'CLM_ROUTES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_ROUTE_LINES', 'T', 'CLM_ROUTE_LINES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SCHEDULES', 'T', 'CLM_SCHEDULES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SCHEDULE_CALENDAR', 'T', 'CLM_SCHEDULE_CALENDAR', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SCHEDULE_ITEMS', 'T', 'CLM_SCHEDULE_ITEMS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SCHEDULE_ITEM_PARAMETERS', 'T', 'CLM_SCHEDULE_ITEM_PARAMETERS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STATUS_DAYS', 'T', 'CLM_STATUS_DAYS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STATUS_TIMES', 'T', 'CLM_STATUS_TIMES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STREETS', 'T', 'CLM_STREETS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STREET_ALIASES', 'T', 'CLM_STREET_ALIASES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STREET_DESIGNATIONS', 'T', 'CLM_STREET_DESIGNATIONS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STREET_DIVISIONS', 'T', 'CLM_STREET_DIVISIONS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STREET_GROUPS', 'T', 'CLM_STREET_GROUPS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_STREET_SCHEMES', 'T', 'CLM_STREET_SCHEMES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SWITCH_TOTALS', 'T', 'CLM_SWITCH_TOTALS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_SYS_DEFS', 'T', 'CLM_SYS_DEFS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_TARIFF_RATES', 'T', 'CLM_TARIFF_RATES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNITS_ALL', 'T', 'CLM_UNITS_ALL', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNIT_ERRORS', 'T', 'CLM_UNIT_ERRORS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNIT_HISTORY', 'T', 'CLM_UNIT_HISTORY', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNIT_MANAGERS', 'T', 'CLM_UNIT_MANAGERS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_UNIT_TOTALS', 'T', 'CLM_UNIT_TOTALS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_USER_DOMAIN', 'T', 'CLM_USER_DOMAIN', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_USER_LOOKUP', 'T', 'CLM_USER_LOOKUP', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALIDATION_CODES', 'T', 'CLM_VALIDATION_CODES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALIDATION_CODE_KEYS', 'T', 'CLM_VALIDATION_CODE_KEYS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALID_GROUPS', 'T', 'CLM_VALID_GROUPS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALID_HEIGHTS', 'T', 'CLM_VALID_HEIGHTS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALID_LAMPS', 'T', 'CLM_VALID_LAMPS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALID_LANTERNS', 'T', 'CLM_VALID_LANTERNS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_VALID_UNIT_TYPES', 'T', 'CLM_VALID_UNIT_TYPES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WAYLEAVES', 'T', 'CLM_WAYLEAVES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ITEMS', 'T', 'CLM_WORK_ITEMS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ORDERS', 'T', 'CLM_WORK_ORDERS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ORDER_LINES', 'T', 'CLM_WORK_ORDER_LINES', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CLM_WORK_ORDER_REPAIRS', 'T', 'CLM_WORK_ORDER_REPAIRS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'CLM_COSTS_BUDGETS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'CLM_ORGS_AND_ADMIN_UNITS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'CLM_OWNER_AGENT', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'CLM_REPLACEMENT_VIEW', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'CLM_UNITS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'CLM_UNIT_CONTRACTOR', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'CLM_UNIT_DETAILS', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'CLM_UNIT_SUPERVISOR', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'CLM_UNIT_VIEW', 'CLM'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'OBSTRUCTIONS', 'C', 'OBS_FK_OBT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'OBSTRUCTIONS', 'C', 'OBS_FK_RIN', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'OBSTRUCTIONS', 'C', 'OBS_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'OBSTRUCTIONS', 'C', 'OBS_UK1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'OBSTRUCTION_TYPES', 'C', 'OBT_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'OBSTRUCTION_TYPES', 'C', 'OBT_UK1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_INTERSECTIONS', 'C', 'RIN_FK_STR', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_INTERSECTIONS', 'C', 'RIN_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_DOMAIN', 'C', 'SAD_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_GROUPS', 'C', 'SAG_FK_SIT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_GROUPS', 'C', 'SAG_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_GROUPS', 'C', 'SAG_UK1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_LOG', 'C', 'SLG_FK_SIA', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_LOG', 'C', 'SLG_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_LOOKUP', 'C', 'SAL_FK_SAD', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_LOOKUP', 'C', 'SAL_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_MEMBS', 'C', 'SAM_FK_SAG', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_MEMBS', 'C', 'SAM_FK_SAT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_MEMBS', 'C', 'SAM_FK_SIT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_MEMBS', 'C', 'SAM_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_TYPES', 'C', 'SAT_FK_SAD', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_TYPES', 'C', 'SAT_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_TYPES', 'C', 'SAT_UK1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_USERS', 'C', 'SAU_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_USERS', 'C', 'SUA_FK_SAG', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_VALID', 'C', 'SAV_FK_SAT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_VALID', 'C', 'SAV_FK_SIT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_VALID', 'C', 'SAV_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_DEFECT_CODES', 'C', 'SDC_FK_SIT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_DEFECT_CODES', 'C', 'STR_SDC_PKEY', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_EIF_LOOKUPS', 'C', 'SEP_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_EIF_LOOKUPS', 'C', 'SEP_RL_FK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ELEMENT_CONDITION_SCORE', 'C', 'ECS_FK_RID', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ELEMENT_CONDITION_SCORE', 'C', 'STR_ECS_PKEY', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ELEMENT_IMPORTANCE', 'C', 'EI_FK_RID', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ELEMENT_IMPORTANCE', 'C', 'EI_FK_SIT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ELEMENT_IMPORTANCE', 'C', 'EI_TR_FK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ELEMENT_IMPORTANCE', 'C', 'STR_EI_PKEY', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_EQPT', 'C', 'SEQ_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_EQPT', 'C', 'SEQ_UK1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_EQPT_LIST', 'C', 'SEL_FK_SEQ', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_EQPT_LIST', 'C', 'SEL_FK_SNT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_EQPT_LIST', 'C', 'SEL_FK_STR', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_EQPT_LIST', 'C', 'SEL_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP', 'C', 'SIP_FK_SIB', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP', 'C', 'SIP_FK_SNT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP', 'C', 'SIP_FK_STR', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP', 'C', 'SIP_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_BATCH', 'C', 'SIB_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_COMBS', 'C', 'SCO_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_COMBS', 'C', 'SCO_UK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_CYCLES', 'C', 'SIC_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_CYCLES', 'C', 'SIC_UK1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_DEF_CMP', 'C', 'SID_FK_SIT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_DEF_CMP', 'C', 'SID_FK_SIV', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_DEF_CMP', 'C', 'SID_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_INTERVALS', 'C', 'SII_FK_SNT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_INTERVALS', 'C', 'SII_FK_STR', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_INTERVALS', 'C', 'SII_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_LINES', 'C', 'SIL_FK_SIP', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_LINES', 'C', 'SIL_FK_STR', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_LINES', 'C', 'SIL_PK1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_NOTICES', 'C', 'SIN_FK_SII', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_NOTICES', 'C', 'SIN_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_SETS', 'C', 'SINS_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_SETS', 'C', 'SINS_UK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_TYPES', 'C', 'SNT_FK_SIS', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_TYPES', 'C', 'SNT_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_TYPES', 'C', 'SNT_UK1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_VALID', 'C', 'SIV_FK_SIT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_VALID', 'C', 'SIV_FK_SNT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_VALID', 'C', 'SIV_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEMS_ALL', 'C', 'STR_FK_SIC', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEMS_ALL', 'C', 'STR_FK_SIT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEMS_ALL', 'C', 'STR_FK_STR_PARENT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEMS_ALL', 'C', 'STR_FK_STR_TOP', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEMS_ALL', 'C', 'STR_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEM_ATTR', 'C', 'SIA_FK_SAT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEM_ATTR', 'C', 'SIA_FK_STR', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEM_ATTR', 'C', 'SIA_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEM_TYPES', 'C', 'SIT_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEM_TYPES', 'C', 'SIT_UK1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ORG_UNITS', 'C', 'SOU_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_PBI_QUERY', 'C', 'SPQ_FK_SIT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_PBI_QUERY', 'C', 'SPQ_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_PBI_QUERY_ATTRIBS', 'C', 'SQRA_FK_QRT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_PBI_QUERY_ATTRIBS', 'C', 'SQRA_FK_SAT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_PBI_QUERY_ATTRIBS', 'C', 'SQRA_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_PBI_QUERY_TYPES', 'C', 'SQRT_FK_QRY', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_PBI_QUERY_TYPES', 'C', 'SQRT_FK_SIT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_PBI_QUERY_TYPES', 'C', 'SQRT_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_PBI_RESULTS', 'C', 'PBI_FK_QRY', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_PBI_RESULTS', 'C', 'SPR_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_REPORT_TAGS', 'C', 'SRT_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_RULESETS', 'C', 'STR_RL_PKEY', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_SCORE_COMBINATIONS', 'C', 'SC_ACTION_VALID', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_SCORE_COMBINATIONS', 'C', 'SC_SIT_FK1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_SCORE_COMBINATIONS', 'C', 'SC_SIT_FK2', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_SCORE_COMBINATIONS', 'C', 'SC_SRT_FK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_TEMP', 'C', 'STT_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_TEMPLATES', 'C', 'STE_FK_SIT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_TEMPLATES', 'C', 'STE_FK_STE', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_TEMPLATES', 'C', 'STE_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_TYPE_LIST', 'C', 'STL_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_TYPE_RULES', 'C', 'TR_FK_RL', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_TYPE_RULES', 'C', 'TR_FK_SIT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_TYPE_RULES', 'C', 'TR_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_TYPE_RULES', 'C', 'TR_SAT_FK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_VALID_INSP_ATTR', 'C', 'SVI_FK_SIV', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_VALID_INSP_ATTR', 'C', 'SVI_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'OBSTRUCTIONS', 'I', 'OBS_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'OBSTRUCTIONS', 'I', 'OBS_UK1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'OBSTRUCTION_TYPES', 'I', 'OBT_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'OBSTRUCTION_TYPES', 'I', 'OBT_UK1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_INTERSECTIONS', 'I', 'RIN_IND_S1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_INTERSECTIONS', 'I', 'RIN_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_DOMAIN', 'I', 'SAD_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_GROUPS', 'I', 'SAG_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_GROUPS', 'I', 'SAG_UK1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_LOG', 'I', 'SLG_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_LOOKUP', 'I', 'SAL_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_MEMBS', 'I', 'SAM_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_TYPES', 'I', 'SAT_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_TYPES', 'I', 'SAT_UK1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_USERS', 'I', 'SAU_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_VALID', 'I', 'SAV_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_DEFECT_CODES', 'I', 'STR_SDC_PKEY', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_EIF_LOOKUPS', 'I', 'SEP_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ELEMENT_CONDITION_SCORE', 'I', 'STR_ECS_PKEY', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ELEMENT_IMPORTANCE', 'I', 'STR_EI_PKEY', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_EQPT', 'I', 'SEQ_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_EQPT', 'I', 'SEQ_UK1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_EQPT_LIST', 'I', 'SEL_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP', 'I', 'SIP_INDEX_S1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP', 'I', 'SIP_INDEX_S2', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP', 'I', 'SIP_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_BATCH', 'I', 'SIB_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_COMBS', 'I', 'SCO_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_COMBS', 'I', 'SCO_UK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_CYCLES', 'I', 'SIC_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_CYCLES', 'I', 'SIC_UK1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_DEF_CMP', 'I', 'SID_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_INTERVALS', 'I', 'SII_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_LINES', 'I', 'SIL_INDEX_S1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_LINES', 'I', 'SIL_INDEX_S2', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_LINES', 'I', 'SIL_PK1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_NOTICES', 'I', 'SIN_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_SETS', 'I', 'SINS_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_SETS', 'I', 'SINS_UK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_TYPES', 'I', 'SNT_INDEX_S1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_TYPES', 'I', 'SNT_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_TYPES', 'I', 'SNT_UK1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_VALID', 'I', 'SIV_INDEX_S1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEMS_ALL', 'I', 'STR_IND_S1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEMS_ALL', 'I', 'STR_IND_S2', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEMS_ALL', 'I', 'STR_IND_S3', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEMS_ALL', 'I', 'STR_IND_S4', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEMS_ALL', 'I', 'STR_IND_S5', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEMS_ALL', 'I', 'STR_IND_S6', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEMS_ALL', 'I', 'STR_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEM_ATTR', 'I', 'SIA_IND_S1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEM_ATTR', 'I', 'SIA_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEM_TYPES', 'I', 'SIT_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEM_TYPES', 'I', 'SIT_UK1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ORG_UNITS', 'I', 'SOU_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_PBI_QUERY', 'I', 'SPQ_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_PBI_QUERY_ATTRIBS', 'I', 'SQRA_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_PBI_QUERY_TYPES', 'I', 'SQRT_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_PBI_RESULTS', 'I', 'SPR_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_REPORT_TAGS', 'I', 'SRT_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_RULESETS', 'I', 'STR_RL_PKEY', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_TEMP', 'I', 'STT_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_TEMPLATES', 'I', 'STE_IND_S1', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_TEMPLATES', 'I', 'STE_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_TYPE_LIST', 'I', 'STL_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_TYPE_RULES', 'I', 'TR_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_VALID_INSP_ATTR', 'I', 'SVI_PK', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'STRBCI', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'STRCLOSE', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'STRINIT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'STRMERGE', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'STRPBI', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'STRRECAL', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'STRREPL', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'STRSPLIT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'STRUTILS', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'OBS_ID_SEQ', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'RIN_ID_SEQ', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SAG_ID_SEQ', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SIB_ID_SEQ', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SIL_ID_SEQ', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SIP_ID_SEQ', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SOU_ID_SEQ', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SRT_JOB_ID_SEQ', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'STE_ID_SEQ', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'STR_BCI_JOB_ID_SEQ', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'STR_EXCEL_ID_SEQ', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'STR_ID_SEQ', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'STR_PBI_ID_SEQ', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'STR_RULESET_ID_SEQ', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'OBSTRUCTIONS', 'T', 'OBSTRUCTIONS', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'OBSTRUCTION_TYPES', 'T', 'OBSTRUCTION_TYPES', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'ROAD_INTERSECTIONS', 'T', 'ROAD_INTERSECTIONS', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_DOMAIN', 'T', 'STR_ATTR_DOMAIN', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_GROUPS', 'T', 'STR_ATTR_GROUPS', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_LOG', 'T', 'STR_ATTR_LOG', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_LOOKUP', 'T', 'STR_ATTR_LOOKUP', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_MEMBS', 'T', 'STR_ATTR_MEMBS', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_TYPES', 'T', 'STR_ATTR_TYPES', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_USERS', 'T', 'STR_ATTR_USERS', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ATTR_VALID', 'T', 'STR_ATTR_VALID', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_BCI_TMP', 'T', 'STR_BCI_TMP', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_DEFECT_CODES', 'T', 'STR_DEFECT_CODES', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_EIF_LOOKUPS', 'T', 'STR_EIF_LOOKUPS', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ELEMENT_CONDITION_SCORE', 'T', 'STR_ELEMENT_CONDITION_SCORE', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ELEMENT_IMPORTANCE', 'T', 'STR_ELEMENT_IMPORTANCE', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_EQPT', 'T', 'STR_EQPT', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_EQPT_LIST', 'T', 'STR_EQPT_LIST', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP', 'T', 'STR_INSP', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_BATCH', 'T', 'STR_INSP_BATCH', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_COMBS', 'T', 'STR_INSP_COMBS', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_CYCLES', 'T', 'STR_INSP_CYCLES', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_DEF_CMP', 'T', 'STR_INSP_DEF_CMP', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_INTERVALS', 'T', 'STR_INSP_INTERVALS', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_LINES', 'T', 'STR_INSP_LINES', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_NOTICES', 'T', 'STR_INSP_NOTICES', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_SETS', 'T', 'STR_INSP_SETS', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_TYPES', 'T', 'STR_INSP_TYPES', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_INSP_VALID', 'T', 'STR_INSP_VALID', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEMS_ALL', 'T', 'STR_ITEMS_ALL', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEM_ATTR', 'T', 'STR_ITEM_ATTR', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ITEM_TYPES', 'T', 'STR_ITEM_TYPES', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_ORG_UNITS', 'T', 'STR_ORG_UNITS', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_PBI_QUERY', 'T', 'STR_PBI_QUERY', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_PBI_QUERY_ATTRIBS', 'T', 'STR_PBI_QUERY_ATTRIBS', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_PBI_QUERY_TYPES', 'T', 'STR_PBI_QUERY_TYPES', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_PBI_RESULTS', 'T', 'STR_PBI_RESULTS', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_PBI_SQL', 'T', 'STR_PBI_SQL', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_REPORT_TAGS', 'T', 'STR_REPORT_TAGS', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_RULESETS', 'T', 'STR_RULESETS', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_SCORE_COMBINATIONS', 'T', 'STR_SCORE_COMBINATIONS', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_TEMP', 'T', 'STR_TEMP', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_TEMPLATES', 'T', 'STR_TEMPLATES', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_TYPE_LIST', 'T', 'STR_TYPE_LIST', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_TYPE_RULES', 'T', 'STR_TYPE_RULES', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'STR_VALID_INSP_ATTR', 'T', 'STR_VALID_INSP_ATTR', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_STR5080', 'T', 'TEMP_STR5080', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TEMP_STR5084', 'T', 'TEMP_STR5084', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'STR_INSPECTION_RESULTS', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'STR_ITEMS', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_GROUP_ATTR', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_INSP_ATTR', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_INSP_ITEM', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_INSP_NOTES', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_STR_INSP_VALID', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_TOP_ITEMS', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_TOP_ITEM_ATTR', 'STR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_CSV_FILES', 'C', 'SWR_BCV_ABO_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_CSV_FILES', 'C', 'SWR_BCV_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_EXPORTS', 'C', 'SWR_BEX_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_EXPORT_FILES', 'C', 'SWR_BEF_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_FILES_PROCESSED', 'C', 'SWR_BFP_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_FILE_ERRORS', 'C', 'SWR_BFE_BCV_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_FILE_GROUPS', 'C', 'SWR_BFG_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_FILE_STRUCT', 'C', 'SWR_BFS_CK1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_FILE_STRUCT', 'C', 'SWR_BFS_CK2', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_FILE_STRUCT', 'C', 'SWR_BFS_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_FILE_VALIDATION', 'C', 'SWR_BFV_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_LOAD_ERRORS', 'C', 'SWR_BLE_BCV_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_FILE_ERRORS', 'C', 'SWR_CFE_BCV_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_FILE_STRUCT', 'C', 'SWR_CSV_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_LOAD_ERRORS', 'C', 'SWR_CLE_BCV_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_ADDITIONAL_STREET', 'C', 'SWR_TEMP_ASD_CK1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_ADDITIONAL_STREET', 'C', 'SWR_TEMP_ASD_CK2', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_HEADER', 'C', 'SWR_TEMP_HEADER_CK1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_REINST_DESIG', 'C', 'SWR_TEMP_RDE_CK1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_REINST_DESIG', 'C', 'SWR_TEMP_RDE_CK2', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_SPECIAL_DESIG', 'C', 'SWR_TEMP_SDE_CK1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_STREET', 'C', 'SWR_TEMP_STR_CK1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_STREET', 'C', 'SWR_TEMP_STR_CK2', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_STREET', 'C', 'SWR_TEMP_STR_CK3', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_STREET', 'C', 'SWR_TEMP_STR_CK4', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_STREET', 'C', 'SWR_TEMP_STR_CK5', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_STREET', 'C', 'SWR_TEMP_STR_CK6', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_STREET', 'C', 'SWR_TEMP_STR_CK7', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_STREET', 'C', 'SWR_TEMP_STR_CK8', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_STREET', 'C', 'SWR_TEMP_STR_CK9', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_STREET_XREF', 'C', 'SWR_TEMP_XREF_CK1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_STREET_XREF', 'C', 'SWR_TEMP_XREF_CK2', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_TRAILER', 'C', 'SWR_TEMP_TRAILER_CK1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ACTIVITY_STREETS_ALL', 'C', 'SWR_NAS_GIVEN_FOR', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ACTIVITY_STREETS_ALL', 'C', 'SWR_NAS_GIVEN_FOR2', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ACTIVITY_STREETS_ALL', 'C', 'SWR_NAS_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ADMIN_GROUPS', 'C', 'SWR_ADG_CHILD_OF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ADMIN_GROUPS', 'C', 'SWR_ADG_PARENT_OF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ADMIN_GROUPS', 'C', 'SWR_ADG_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AIP_LIMITS', 'C', 'SWR_APL_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ALLOWABLE_DEFECT_MESSAGES', 'C', 'SWR_ADM_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ALLOWABLE_INSP_ITEMS', 'C', 'SWR_AII_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ALLOWABLE_SITE_UPDATES', 'C', 'SWR_ASU_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ANNUAL_INSPECTION_PROFILES', 'C', 'SWR_AIP_GENERATED_FOR', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ANNUAL_INSPECTION_PROFILES', 'C', 'SWR_AIP_MONITORED_BY', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ANNUAL_INSPECTION_PROFILES', 'C', 'SWR_AIP_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AOI_POLYGONS', 'C', 'SWR_APO_FOR', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AOI_POLYGONS', 'C', 'SWR_APO_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AOI_POLYGON_POINTS', 'C', 'SWR_APP_PART_OF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AOI_POLYGON_POINTS', 'C', 'SWR_APP_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ASU_ALLOWABLE_NOTICES', 'C', 'SWR_AAN_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AUTOBATCH_OPERATIONS', 'C', 'SWR_ABO_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AUTOBATCH_PROCESSES', 'C', 'SWR_ABP_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AUTOBATCH_RULES', 'C', 'SWR_ABR_ABO_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AUTOBATCH_RULES', 'C', 'SWR_ABR_ABP_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AUTOBATCH_RULES', 'C', 'SWR_ABR_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_BATCH_MESSAGES', 'C', 'SWR_SBM_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_BATCH_TRANSACTION_LOG', 'C', 'SWR_SBT_BCV_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_BATCH_TRANSACTION_LOG', 'C', 'SWR_SBT_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_CODE_CONTROLS', 'C', 'SWR_CCO_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_CONTACTS', 'C', 'SWR_CON_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_CONTACTS', 'C', 'SWR_CON_REPRESENTATIVE_F', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_COORD_GROUPS', 'C', 'SWR_CGR_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_COORD_GROUPS', 'C', 'SWR_CGR_UK1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_COORD_GROUPS', 'C', 'SWR_CGR_USED_BY', 'SWR'); 
COMMIT;
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_DEFECT_INSP_SCHEDULES', 'C', 'SWR_DIS_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_FILE_TRANSMISSION_LOG', 'C', 'SWR_FTL_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_HOLIDAYS', 'C', 'SWR_HOL_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ILI_HIST', 'C', 'SWR_ILI_HIST_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ILI_HIST', 'C', 'SWR_ILI_IRS_HIST_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_CATEGORIES', 'C', 'SWR_ICAT_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_COSTS', 'C', 'SWR_ICO_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_ITEM_STATUS_CODES', 'C', 'SWR_IIS_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_OUTCOME_TYPES', 'C', 'SWR_IOT_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_ALL', 'C', 'SWR_IRE_CON_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_ALL', 'C', 'SWR_IRE_IOT_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_ALL', 'C', 'SWR_IRE_ITP_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_ALL', 'C', 'SWR_IRE_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_ALL', 'C', 'SWR_IRE_SCAT_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_ALL', 'C', 'SWR_IRE_WOR_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_SITES_ALL', 'C', 'SWR_IRS_IRE_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_SITES_ALL', 'C', 'SWR_IRS_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULT_LINES', 'C', 'SWR_ILI_IRS_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULT_LINES', 'C', 'SWR_ILI_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_TYPES', 'C', 'SWR_ITP_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INTERFACE_MAPS', 'C', 'SWR_IFM_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRE_HIST_ALL', 'C', 'SWR_HIST_IRE_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRE_HIST_ALL', 'C', 'SWR_IRE_HIST_CON_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRE_HIST_ALL', 'C', 'SWR_IRE_HIST_IOT_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRE_HIST_ALL', 'C', 'SWR_IRE_HIST_ITP_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRE_HIST_ALL', 'C', 'SWR_IRE_HIST_SCAT_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRE_HIST_ALL', 'C', 'SWR_IRE_HIST_WOR_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRS_HIST_ALL', 'C', 'SWR_IRS_HIST_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRS_HIST_ALL', 'C', 'SWR_IRS_IRE_HIST_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_LOCALITIES', 'C', 'SWR_LOC_PART_OF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_LOCALITIES', 'C', 'SWR_LOC_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_LOCALITIES', 'C', 'SWR_LOC_UK1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NAMING_AUTHORITIES', 'C', 'SWR_NAU_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NAMING_AUTHORITIES', 'C', 'SWR_NAU_TOW_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NAMING_AUTHORITIES', 'C', 'SWR_NAU_UK1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NAU_FOR_DOWNLOAD', 'C', 'SWR_NFD_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NAU_SOI_DEFAULTS', 'C', 'SWR_NSD_NAU_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NAU_SOI_DEFAULTS', 'C', 'SWR_NSD_ODI_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NAU_SOI_DEFAULTS', 'C', 'SWR_NSD_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NON_SWA_ACTIVITIES_ALL', 'C', 'SWR_NSA_PERFORMED_BY', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NON_SWA_ACTIVITIES_ALL', 'C', 'SWR_NSA_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_CHARGES', 'C', 'SWR_NCH_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_CHG_REPORTED', 'C', 'SWR_NCR_NWO_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_CHG_REPORTED', 'C', 'SWR_NCR_ODI_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_CHG_REPORTED', 'C', 'SWR_NCR_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_OF_WORKS', 'C', 'SWR_NWO_BCV_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_OF_WORKS', 'C', 'SWR_NWO_MADE_FOR', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_OF_WORKS', 'C', 'SWR_NWO_OF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_OF_WORKS', 'C', 'SWR_NWO_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_OF_WORKS', 'C', 'SWR_NWO_WHI_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_PURGE_PARAMETERS', 'C', 'SWR_NPA_FOR', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_PURGE_PARAMETERS', 'C', 'SWR_NPA_FOR2', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_PURGE_PARAMETERS', 'C', 'SWR_NPA_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_TYPES', 'C', 'SWR_NTY_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_TYPES', 'C', 'SWR_NTY_UK1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_WARNINGS', 'C', 'SWR_NWA_NWO_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_OPERATIONAL_DISTRICTS', 'C', 'SWR_ODI_AREA', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_OPERATIONAL_DISTRICTS', 'C', 'SWR_ODI_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ORGANISATIONS', 'C', 'SWR_SWA_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ORGANISATIONS', 'C', 'SWR_SWA_UK1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_PENDING_BATCH_CSV_FILES', 'C', 'SWR_PBF_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_RDE_SPATIAL_COORDS', 'C', 'SWR_RDC_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_RDE_SPATIAL_COORDS', 'C', 'SWR_RDC_REFERENCE_FOR', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_REF_CODES', 'C', 'SWR_RCO_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_REINSTATEMENT_CATEGORIES', 'C', 'SWR_RCA_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_REINSTATEMENT_DESIGS', 'C', 'SWR_RDE_FOR', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_REINSTATEMENT_DESIGS', 'C', 'SWR_RDE_FOR2', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_REINSTATEMENT_DESIGS', 'C', 'SWR_RDE_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_S74_CHARGES', 'C', 'SWR_SFC_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_S74_CHARGES', 'C', 'SWR_SFC_WHI_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_S74_CHARGE_COMPONENT', 'C', 'SWR_SCC_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_S74_CHARGE_COMPONENT', 'C', 'SWR_SCC_RCA_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_S74_CHARGE_COMPONENT', 'C', 'SWR_SCC_SFC_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_S74_CHARGE_COMPONENT', 'C', 'SWR_SCC_STR_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_S74_CHARGING_PROFILE', 'C', 'SWR_SSF_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SAD_SPATIAL_COORDS', 'C', 'SWR_SAC_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SAD_SPATIAL_COORDS', 'C', 'SWR_SAC_REFERENCE_FOR', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SAMPLE_INSP_CATEGORIES', 'C', 'SWR_SCAT_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SAMPLE_INSP_CATEGORY_ITEMS', 'C', 'SWR_SICI_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_ALL', 'C', 'SWR_SIT_ENTERED_BY', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_ALL', 'C', 'SWR_SIT_LOCATED_ON', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_ALL', 'C', 'SWR_SIT_OWNED_BY', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_ALL', 'C', 'SWR_SIT_OWNER_OF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_ALL', 'C', 'SWR_SIT_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_HIST_ALL', 'C', 'SWR_SIH_ENTERED_BY', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_HIST_ALL', 'C', 'SWR_SIH_LOCATED_ON', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_HIST_ALL', 'C', 'SWR_SIH_OWNED_BY', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_HIST_ALL', 'C', 'SWR_SIH_OWNER_OF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_HIST_ALL', 'C', 'SWR_SIH_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SCO_HIST', 'C', 'SWR_SCH_ORG_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SCO_HIST', 'C', 'SWR_SCH_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SCO_HIST', 'C', 'SWR_SCH_REFERENCE_FOR', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SDE_HIST', 'C', 'SWR_SDH_MADE_FOR', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SDE_HIST', 'C', 'SWR_SDH_ON', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SDE_HIST', 'C', 'SWR_SDH_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SPATIAL_COORDS', 'C', 'SWR_SCO_GIS_ID', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SPATIAL_COORDS', 'C', 'SWR_SCO_ORG_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SPATIAL_COORDS', 'C', 'SWR_SCO_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SPATIAL_COORDS', 'C', 'SWR_SCO_REFERENCE_FOR', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SPECIAL_DESIGS', 'C', 'SWR_SDE_MADE_FOR', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SPECIAL_DESIGS', 'C', 'SWR_SDE_ON', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SPECIAL_DESIGS', 'C', 'SWR_SDE_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_STATUS_TRANSITIONS', 'C', 'SWR_SST_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SPECIAL_DESIG_OF_INTEREST', 'C', 'SWR_SDO_INTEREST_FOR', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SPECIAL_DESIG_OF_INTEREST', 'C', 'SWR_SDO_INTEREST_OF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SPECIAL_DESIG_OF_INTEREST', 'C', 'SWR_SDO_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SPECIAL_DESIG_TYPES', 'C', 'SWR_STY_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SPECIAL_DESIG_TYPES', 'C', 'SWR_STY_UK1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SSD_SPATIAL_COORDS', 'C', 'SWR_SDC_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SSD_SPATIAL_COORDS', 'C', 'SWR_SDC_REFERENCE_FOR', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STANDARD_TEXT', 'C', 'SWR_STE_FOR', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STANDARD_TEXT', 'C', 'SWR_STE_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREETS_ALL', 'C', 'SWR_STR_ADDED_BY', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREETS_ALL', 'C', 'SWR_STR_IS_NAMED_BY', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREETS_ALL', 'C', 'SWR_STR_IS_PART_OF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREETS_ALL', 'C', 'SWR_STR_MAINTAINED_BY', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREETS_ALL', 'C', 'SWR_STR_OWNED_BY', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREETS_ALL', 'C', 'SWR_STR_PART_OF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREETS_ALL', 'C', 'SWR_STR_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREETS_OF_INTEREST_ALL', 'C', 'SWR_SIN_FOR', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREETS_OF_INTEREST_ALL', 'C', 'SWR_SIN_INTEREST_OF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREETS_OF_INTEREST_ALL', 'C', 'SWR_SIN_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_ADD', 'C', 'SWR_SAD_AUTH_BY', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_ADD', 'C', 'SWR_SAD_MAINT_BY', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_ADD', 'C', 'SWR_SAD_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_ADD', 'C', 'SWR_SAD_STREETS_ALL', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_ALIASES', 'C', 'SWR_SAL_ASSIGNED_TO', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_ALIASES', 'C', 'SWR_SAL_IN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_ALIASES', 'C', 'SWR_SAL_NAMED_BY', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_ALIASES', 'C', 'SWR_SAL_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_GROUPS', 'C', 'SWR_SGR_CONTAIN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_GROUPS', 'C', 'SWR_SGR_LISTED_IN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_GROUPS', 'C', 'SWR_SGR_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_SPATIAL_COORDS', 'C', 'SWR_SSC_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_SPATIAL_COORDS', 'C', 'SWR_SSC_REFERENCE_FOR', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_SPECIAL_DESIGS', 'C', 'SWR_SSD_CONSULTANT', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_SPECIAL_DESIGS', 'C', 'SWR_SSD_FOR', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_SPECIAL_DESIGS', 'C', 'SWR_SSD_OF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_SPECIAL_DESIGS', 'C', 'SWR_SSD_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_XREFS', 'C', 'SWR_STX_CROSSREF_TO', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_XREFS', 'C', 'SWR_STX_OWNED_BY', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_XREFS', 'C', 'SWR_STX_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SYSTEM_OPTIONS', 'C', 'SWR_SYS_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_TOWNS', 'C', 'SWR_TOW_IN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_TOWNS', 'C', 'SWR_TOW_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_TOWNS', 'C', 'SWR_TOW_UK1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_USERS', 'C', 'SWR_USE_PART_OF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_USERS', 'C', 'SWR_USE_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_USERS', 'C', 'SWR_USE_UK1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_USER_RESTRICTIONS', 'C', 'SWR_SUR_ODI_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_USER_RESTRICTIONS', 'C', 'SWR_SUR_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_USER_RESTRICTIONS', 'C', 'SWR_SUR_USE_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_ALL', 'C', 'SWR_WOR_CK1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_ALL', 'C', 'SWR_WOR_CONTACT', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_ALL', 'C', 'SWR_WOR_OF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_ALL', 'C', 'SWR_WOR_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_ALL', 'C', 'SWR_WOR_PROMOTED_BY', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_ALL', 'C', 'SWR_WOR_UK1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_COMMENTS', 'C', 'SWR_WCO_BCV_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_COMMENTS', 'C', 'SWR_WCO_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_COMMENTS', 'C', 'SWR_WCO_SIT_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_COMMENTS', 'C', 'SWR_WCO_WOR_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_COMMENTS_RECIPIENTS', 'C', 'SWR_WCR_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_COMMENTS_RECIPIENTS', 'C', 'SWR_WCR_WCO_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_HIST_ALL', 'C', 'SWR_WOH_CONTACT', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_HIST_ALL', 'C', 'SWR_WOH_OF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_HIST_ALL', 'C', 'SWR_WOH_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_HIST_ALL', 'C', 'SWR_WOH_PROMOTED_BY', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_HIST_ALL', 'C', 'SWR_WOH_UK1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_HIST_ALL', 'C', 'SWR_WOH_VERSION_OF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_SITES_COMBINATIONS', 'C', 'SWR_WSC_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_STATUS_TRANSITIONS', 'C', 'SWR_WST_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORK_TYPES', 'C', 'SWR_WTY_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORK_TYPES', 'C', 'SWR_WTY_UK1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WST_ALLOWABLE_NOTICES', 'C', 'SWR_WAN_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'F', 'GET_SYSOPT', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_CSV_FILES', 'I', 'SWR_BCV_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_EXPORTS', 'I', 'SWR_BEX_FILE_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_EXPORTS', 'I', 'SWR_BEX_LOAD_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_EXPORTS', 'I', 'SWR_BEX_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_EXPORT_FILES', 'I', 'SWR_BEF_LOAD_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_EXPORT_FILES', 'I', 'SWR_BEF_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_FILES_PROCESSED', 'I', 'SWR_BFP_LOAD_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_FILES_PROCESSED', 'I', 'SWR_BFP_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_FILE_ERRORS', 'I', 'SWR_BFE_FILE_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_FILE_GROUPS', 'I', 'SWR_BFG_PARENT_GROUP', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_FILE_GROUPS', 'I', 'SWR_BFG_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_FILE_STRUCT', 'I', 'SWR_BFS_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_FILE_VALIDATION', 'I', 'SWR_BFV_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_LOAD_ERRORS', 'I', 'SWR_BLE_FILE_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_COMMENTS', 'I', 'SWR_BTC_FILE_ID_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_COMMENTS', 'I', 'SWR_BTC_LOAD_ID_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_COMMENT_DETAILS', 'I', 'SWR_BTCD_FILE_ID_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_COMMENT_DETAILS', 'I', 'SWR_BTCD_LOAD_ID_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_COORDS', 'I', 'SWR_BATCH_TEMP_COORDS_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_COORDS', 'I', 'SWR_BTC_LOAD_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_DCD_ILI', 'I', 'SWR_BTDCDILI_FILE_ID_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_DCD_ILI', 'I', 'SWR_BTDCDILI_LOAD_ID_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_DCD_ILI', 'I', 'SWR_BTDCDILI_LOAD_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_DCD_IRS', 'I', 'SWR_BTDCDIRS_FILE_ID', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_DCD_IRS', 'I', 'SWR_BTDCDIRS_FILE_ID_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_DCD_IRS', 'I', 'SWR_BTDCDIRS_LOAD_ID_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_DISTRICTS', 'I', 'SWR_BTD_GROUP_PK_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_DISTRICTS', 'I', 'SWR_BTD_LOAD_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_DISTRICTS', 'I', 'SWR_BTD_SWA_ORG_REF_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_ILI', 'I', 'SWR_BTILI_FILE_ID_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_ILI', 'I', 'SWR_BTILI_LOAD_ID_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_IRE', 'I', 'SWR_BTIRE_FILE_ID_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_IRE', 'I', 'SWR_BTIRE_LOAD_ID_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_IRS', 'I', 'SWR_BTIRS_FILE_ID_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_IRS', 'I', 'SWR_BTIRS_LOAD_ID_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_OPER_DIST', 'I', 'SWR_BATCH_TEMP_OPER_DIST_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_OPER_DIST', 'I', 'SWR_BTO_LOAD_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_PROV_STREETS', 'I', 'SWR_BATCH_TMP_PROV_STREETS_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_PROV_STREETS', 'I', 'SWR_BTP_LOAD_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_SITES', 'I', 'SWR_BATCH_TEMP_SITES_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_SITES', 'I', 'SWR_BTS_LOAD_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_SITES', 'I', 'SWR_BTS_SITE_NUM_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_SPEC_DESIG', 'I', 'SWR_BATCH_TEMP_SPEC_DESIG_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_SPEC_DESIG', 'I', 'SWR_BTG_LOAD_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_WORKS', 'I', 'SWR_BATCH_TEMP_WORKS_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_WORKS', 'I', 'SWR_BTW_FILE_ID_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_WORKS', 'I', 'SWR_BTW_GROUP_PK_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_WORKS', 'I', 'SWR_BTW_LOAD_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_BATCH_RECONCILE', 'I', 'SWR_CBR_STREET_ID', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_BATCH_RECONCILE', 'I', 'SWR_CBR_USRN_IDX', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_EXPORTS', 'I', 'SWR_CEX_LOAD_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_EXPORT_FILES', 'I', 'SWR_CEF_LOAD_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_EXPORT_FILES', 'I', 'SWR_CEF_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_FILE_ERRORS', 'I', 'SWR_CFE_FILE_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_FILE_STRUCT', 'I', 'SWR_CSV_FS_IND1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_FILE_STRUCT', 'I', 'SWR_CSV_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_LOAD_ERRORS', 'I', 'SWR_CLE_FILE_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_ADDITIONAL_STREET', 'I', 'SWR_CTA_LOAD_ID_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_ADDITIONAL_STREET', 'I', 'SWR_CTA_USRN_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_HEADER', 'I', 'SWR_CTH_LOAD_ID_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_REINST_DESIG', 'I', 'SWR_CTR_LOAD_ID_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_REINST_DESIG', 'I', 'SWR_CTR_USRN_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_SPECIAL_DESIG', 'I', 'SWR_CTD_LOAD_ID_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_SPECIAL_DESIG', 'I', 'SWR_CTD_USRN_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_STREET', 'I', 'SWR_CTS_LOAD_ID_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_STREET', 'I', 'SWR_CTS_USRN_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_STREET_XREF', 'I', 'SWR_CTX_LOAD_ID_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_TRAILER', 'I', 'SWR_CTT_LOAD_ID_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ACTIVITY_STREETS_ALL', 'I', 'SWR_NAS_GIVEN_FOR2_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ACTIVITY_STREETS_ALL', 'I', 'SWR_NAS_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ADMIN_GROUPS', 'I', 'SWR_ADG_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AIP_LIMITS', 'I', 'SWR_APL_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ALLOWABLE_DEFECT_MESSAGES', 'I', 'SWR_ADM_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ALLOWABLE_INSP_ITEMS', 'I', 'SWR_AII_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ALLOWABLE_SITE_UPDATES', 'I', 'SWR_ASU_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ANNUAL_INSPECTION_PROFILES', 'I', 'SWR_AIP_GENERATED_FOR_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ANNUAL_INSPECTION_PROFILES', 'I', 'SWR_AIP_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AOI_POLYGONS', 'I', 'SWR_APO_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AOI_POLYGON_POINTS', 'I', 'SWR_APP_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ASU_ALLOWABLE_NOTICES', 'I', 'SWR_AAN_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AUTOBATCH_OPERATIONS', 'I', 'SWR_ABO_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AUTOBATCH_PROCESSES', 'I', 'SWR_ABP_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AUTOBATCH_RULES', 'I', 'SWR_ABR_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_BATCH_MESSAGES', 'I', 'SWR_SBM_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_BATCH_TRANSACTION_LOG', 'I', 'SWR_SBT_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_CODE_CONTROLS', 'I', 'SWR_CCO_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_CONTACTS', 'I', 'SWR_CON_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_COORD_GROUPS', 'I', 'SWR_CGR_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_COORD_GROUPS', 'I', 'SWR_CGR_UK1_UNIQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_DEFECT_INSP_SCHEDULES', 'I', 'SWR_DIS_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_FILE_TRANSMISSION_LOG', 'I', 'SWR_FTL_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_HOLIDAYS', 'I', 'SWR_HOL_INDEX_P1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ILI_HIST', 'I', 'SWR_ILI_HIST_ITEM_TYPE_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ILI_HIST', 'I', 'SWR_ILI_HIST_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_CATEGORIES', 'I', 'SWR_ICAT_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_COSTS', 'I', 'SWR_ICO_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_ITEM_STATUS_CODES', 'I', 'SWR_IIS_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_OUTCOME_TYPES', 'I', 'SWR_IOT_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_ALL', 'I', 'SWR_IRE_CATEGORY_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_ALL', 'I', 'SWR_IRE_DATE_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_ALL', 'I', 'SWR_IRE_DCD_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_ALL', 'I', 'SWR_IRE_INSPECTED_BY_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_ALL', 'I', 'SWR_IRE_MODIFIED_DATE_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_ALL', 'I', 'SWR_IRE_OUTCOME_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_ALL', 'I', 'SWR_IRE_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_ALL', 'I', 'SWR_IRE_RECIP_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_ALL', 'I', 'SWR_IRE_REVIEW_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_ALL', 'I', 'SWR_IRE_TYPE_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_ALL', 'I', 'SWR_IRE_WOR_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_SITES_ALL', 'I', 'SWR_IRS_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_SITES_ALL', 'I', 'SWR_IRS_RESPONSE_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULT_LINES', 'I', 'SWR_ILI_ITEM_TYPE_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULT_LINES', 'I', 'SWR_ILI_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_TYPES', 'I', 'SWR_ITP_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INTERVALS', 'I', 'SWR_INT_INDEX_P1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRE_HIST_ALL', 'I', 'SWR_IRE_HIST_CATEGORY_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRE_HIST_ALL', 'I', 'SWR_IRE_HIST_DATE_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRE_HIST_ALL', 'I', 'SWR_IRE_HIST_DCD_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRE_HIST_ALL', 'I', 'SWR_IRE_HIST_INSPECTED_BY_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRE_HIST_ALL', 'I', 'SWR_IRE_HIST_OUTCOME_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRE_HIST_ALL', 'I', 'SWR_IRE_HIST_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRE_HIST_ALL', 'I', 'SWR_IRE_HIST_RECIP_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRE_HIST_ALL', 'I', 'SWR_IRE_HIST_REVIEW_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRE_HIST_ALL', 'I', 'SWR_IRE_HIST_TYPE_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRE_HIST_ALL', 'I', 'SWR_IRE_HIST_WOR_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRS_HIST_ALL', 'I', 'SWR_IRS_HIST_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRS_HIST_ALL', 'I', 'SWR_IRS_HIST_RESPONSE_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_LOCALITIES', 'I', 'SWR_LOC_PART_OF_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_LOCALITIES', 'I', 'SWR_LOC_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_LOCALITIES', 'I', 'SWR_LOC_UK1_UNIQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NAMING_AUTHORITIES', 'I', 'SWR_NAU_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NAMING_AUTHORITIES', 'I', 'SWR_NAU_UK1_UNIQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NAU_FOR_DOWNLOAD', 'I', 'SWR_NFD_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NAU_SOI_DEFAULTS', 'I', 'SWR_NSD_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NON_SWA_ACTIVITIES_ALL', 'I', 'SWR_NSA_DATE_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NON_SWA_ACTIVITIES_ALL', 'I', 'SWR_NSA_PERFORMED_BY_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NON_SWA_ACTIVITIES_ALL', 'I', 'SWR_NSA_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_CHARGES', 'I', 'SWR_NCH_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_CHG_REPORTED', 'I', 'SWR_NCR_NWO_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_CHG_REPORTED', 'I', 'SWR_NCR_PRIM_PK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_OF_WORKS', 'I', 'SWR_NWO_BCV_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_OF_WORKS', 'I', 'SWR_NWO_NOTICE_DATE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_OF_WORKS', 'I', 'SWR_NWO_OF_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_OF_WORKS', 'I', 'SWR_NWO_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_OF_WORKS', 'I', 'SWR_NWO_STATUS_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_PURGE_PARAMETERS', 'I', 'SWR_NPA_FOR_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_PURGE_PARAMETERS', 'I', 'SWR_NPA_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_TYPES', 'I', 'SWR_NTY_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_TYPES', 'I', 'SWR_NTY_UK1_UNIQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_WARNINGS', 'I', 'SWR_NWA_ERR_NO_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_WARNINGS', 'I', 'SWR_NWA_NWO_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_OPERATIONAL_DISTRICTS', 'I', 'SWR_ODI_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ORGANISATIONS', 'I', 'SWR_SWA_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ORGANISATIONS', 'I', 'SWR_SWA_UK1_UNIQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ORGANISATIONS', 'I', 'SWR_SWA_UK2_UNIQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_PENDING_BATCH_CSV_FILES', 'I', 'SWR_PBF_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_RDE_SPATIAL_COORDS', 'I', 'SWR_RDC_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_REF_CODES', 'I', 'SWR_RCO_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_REINSTATEMENT_CATEGORIES', 'I', 'SWR_RCA_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_REINSTATEMENT_DESIGS', 'I', 'SWR_RDE_FOR_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_REINSTATEMENT_DESIGS', 'I', 'SWR_RDE_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_S74_CHARGES', 'I', 'SWR_SFC_IND_1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_S74_CHARGES', 'I', 'SWR_SFC_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_S74_CHARGE_COMPONENT', 'I', 'SWR_SCC_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_S74_CHARGING_PROFILE', 'I', 'SWR_SSF_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SAD_SPATIAL_COORDS', 'I', 'SWR_SAC_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SAMPLE_INSP_CATEGORIES', 'I', 'SWR_SCAT_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SAMPLE_INSP_CATEGORY_ITEMS', 'I', 'SWR_SICI_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SCHEDULE_TEMP', 'I', 'SWR_SHT_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SCHEDULE_TEMP', 'I', 'SWR_SHT_FK2', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SCHEDULE_TEMP', 'I', 'SWR_SHT_IND1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SCHEDULE_TEMP', 'I', 'SWR_SHT_IND2', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_ALL', 'I', 'SWR_SIT_ENTERED_BY_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_ALL', 'I', 'SWR_SIT_EXTANT_DATE_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_ALL', 'I', 'SWR_SIT_INTERIM_DATE_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_ALL', 'I', 'SWR_SIT_LOCATED_ON_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_ALL', 'I', 'SWR_SIT_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_ALL', 'I', 'SWR_SIT_START_DATE_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_ALL', 'I', 'SWR_SIT_TYPE_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_ALL', 'I', 'SWR_SIT_WARRANTY_END_DATE_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_HIST_ALL', 'I', 'SWR_SIH_ENTERED_BY_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_HIST_ALL', 'I', 'SWR_SIH_LOCATED_ON_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_HIST_ALL', 'I', 'SWR_SIH_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_HIST_ALL', 'I', 'SWR_SIH_TYPE_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SCO_HIST', 'I', 'SWR_SCH_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SDE_HIST', 'I', 'SWR_SDH_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SPATIAL_COORDS', 'I', 'SWR_SCO_EASTINGS_IND', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SPATIAL_COORDS', 'I', 'SWR_SCO_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SPECIAL_DESIGS', 'I', 'SWR_SDE_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_STATUS_TRANSITIONS', 'I', 'SWR_SST_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SPECIAL_DESIG_OF_INTEREST', 'I', 'SWR_SDO_INTEREST_FOR_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SPECIAL_DESIG_OF_INTEREST', 'I', 'SWR_SDO_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SPECIAL_DESIG_TYPES', 'I', 'SWR_STY_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SPECIAL_DESIG_TYPES', 'I', 'SWR_STY_UK1_UNIQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SSD_SPATIAL_COORDS', 'I', 'SWR_SDC_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STANDARD_TEXT', 'I', 'SWR_STE_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREETS_ALL', 'I', 'SWR_STR_IS_NAMED_BY_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREETS_ALL', 'I', 'SWR_STR_IS_PART_OF_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREETS_ALL', 'I', 'SWR_STR_NAME', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREETS_ALL', 'I', 'SWR_STR_NSG_REF_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREETS_ALL', 'I', 'SWR_STR_PART_OF_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREETS_ALL', 'I', 'SWR_STR_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREETS_OF_INTEREST_ALL', 'I', 'SWR_SIN_INTEREST_OF_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREETS_OF_INTEREST_ALL', 'I', 'SWR_SIN_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_ADD', 'I', 'SWR_SAD_AUTH_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_ADD', 'I', 'SWR_SAD_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_ALIASES', 'I', 'SWR_SAL_IN_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_ALIASES', 'I', 'SWR_SAL_NAMED_BY_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_ALIASES', 'I', 'SWR_SAL_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_GROUPS', 'I', 'SWR_SGR_CONTAIN_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_GROUPS', 'I', 'SWR_SGR_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_SPATIAL_COORDS', 'I', 'SWR_SSC_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_SPECIAL_DESIGS', 'I', 'SWR_SSD_OF_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_SPECIAL_DESIGS', 'I', 'SWR_SSD_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_XREFS', 'I', 'SWR_STX_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_XREFS', 'I', 'SWR_STX_XREF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SYSTEM_OPTIONS', 'I', 'SWR_SYS_INDEX_P1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_TEMP_1', 'I', 'SWR_TMP_FRGN1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_TEMP_1', 'I', 'SWR_TMP_FRGN2', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_TEMP_1', 'I', 'SWR_TMP_FRGN3', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_TOWNS', 'I', 'SWR_TOW_IN_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_TOWNS', 'I', 'SWR_TOW_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_TOWNS', 'I', 'SWR_TOW_UK1_UNIQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_USERS', 'I', 'SWR_USE_PART_OF_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_USERS', 'I', 'SWR_USE_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_USERS', 'I', 'SWR_USE_UK1_UNIQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_USER_RESTRICTIONS', 'I', 'SWR_SUR_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_ALL', 'I', 'SWR_WOR_CONTACT_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_ALL', 'I', 'SWR_WOR_DATE_REF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_ALL', 'I', 'SWR_WOR_ESTIMATED_END_DATE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_ALL', 'I', 'SWR_WOR_EXTERNAL_REF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_ALL', 'I', 'SWR_WOR_OF_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_ALL', 'I', 'SWR_WOR_ORIG_REF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_ALL', 'I', 'SWR_WOR_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_ALL', 'I', 'SWR_WOR_PROMOTED_BY_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_ALL', 'I', 'SWR_WOR_STATUS_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_COMMENTS', 'I', 'SWR_WCO_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_COMMENTS', 'I', 'SWR_WCO_RECIP_STATUS_TYPE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_COMMENTS', 'I', 'SWR_WCO_WOR_FK', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_COMMENTS_RECIPIENTS', 'I', 'SWR_WCR_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_HIST_ALL', 'I', 'SWR_WOH_CONTACT_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_HIST_ALL', 'I', 'SWR_WOH_OF_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_HIST_ALL', 'I', 'SWR_WOH_ORIG_REF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_HIST_ALL', 'I', 'SWR_WOH_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_HIST_ALL', 'I', 'SWR_WOH_PROMOTED_BY_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_HIST_ALL', 'I', 'SWR_WOH_STATUS_FRGN', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_SITES_COMBINATIONS', 'I', 'SWR_WSC_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_STATUS_TRANSITIONS', 'I', 'SWR_WST_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORK_TYPES', 'I', 'SWR_WTY_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORK_TYPES', 'I', 'SWR_WTY_UK1_UNIQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WST_ALLOWABLE_NOTICES', 'I', 'SWR_WAN_PK_PRIM', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'AIP_VALIDATE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'AOI_VALIDATE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'BATCH_CONSTANTS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'BATCH_EXPORT', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'BATCH_INTERFACE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'BATCH_MAP', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'BATCH_SETUP', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'BATCH_UTILS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'BATCH_VALIDATION', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'CAT_VALIDATE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'COMMENTS_INTERFACE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'CSV_EXPORT', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'CSV_INTERFACE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'GRI', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'GRI_REPORT', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'IRE_VALIDATE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'NAD_VALIDATE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'NSA_VALIDATE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'ODI_VALIDATE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'SDF_VALIDATE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'SIT_VALIDATE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'SSD_VALIDATE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'SWR_COMMENTS_EXPORT', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'SWR_CSV_UTILS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'SWR_INSPECTIONS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'SWR_INSPECTIONS_EXPORT', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'SWR_INSPECTIONS_INTERFACE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'SWR_REFERENCE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'SWR_S74_CHARGING', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'SWR_SCHEDULE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'SWR_SQL2', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'SWR_STR_VALIDATE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'SWR_UTILITY', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'SWR_VALIDATE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'WHI_VALIDATE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'WOR_VALIDATE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'EXECUTE_DDL', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'EXECUTE_SQL', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'BATCH_CSV_ID', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'BATCH_FILE_ID', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'BATCH_GROUP_PK_SEQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'BATCH_TRANS_SEQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'ERR_SEQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'NAD_SEQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SWR_APO_SEQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SWR_IRE_SEQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SWR_LOC_SEQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SWR_S74_SEQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SWR_SCO_GIS_SEQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SWR_STR_SEQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SWR_TOW_SEQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SWR_WCO_SEQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'SWR_WOR_SEQ', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_CSV_FILES', 'T', 'BATCH_CSV_FILES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_EXPORTS', 'T', 'BATCH_EXPORTS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_EXPORT_FILES', 'T', 'BATCH_EXPORT_FILES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_FILES_PROCESSED', 'T', 'BATCH_FILES_PROCESSED', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_FILE_ERRORS', 'T', 'BATCH_FILE_ERRORS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_FILE_GROUPS', 'T', 'BATCH_FILE_GROUPS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_FILE_MAP', 'T', 'BATCH_FILE_MAP', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_FILE_STRUCT', 'T', 'BATCH_FILE_STRUCT', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_FILE_VALIDATION', 'T', 'BATCH_FILE_VALIDATION', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_LOAD_ERRORS', 'T', 'BATCH_LOAD_ERRORS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_SWA_ORG_REFS', 'T', 'BATCH_SWA_ORG_REFS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_COMMENTS', 'T', 'BATCH_TEMP_COMMENTS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_COMMENT_DETAILS', 'T', 'BATCH_TEMP_COMMENT_DETAILS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_COORDS', 'T', 'BATCH_TEMP_COORDS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_DCD_ILI', 'T', 'BATCH_TEMP_DCD_ILI', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_DCD_IRE', 'T', 'BATCH_TEMP_DCD_IRE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_DCD_IRS', 'T', 'BATCH_TEMP_DCD_IRS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_DISTRICTS', 'T', 'BATCH_TEMP_DISTRICTS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_ILI', 'T', 'BATCH_TEMP_ILI', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_IRE', 'T', 'BATCH_TEMP_IRE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_IRS', 'T', 'BATCH_TEMP_IRS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_OPER_DIST', 'T', 'BATCH_TEMP_OPER_DIST', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_PROV_STREETS', 'T', 'BATCH_TEMP_PROV_STREETS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_SITES', 'T', 'BATCH_TEMP_SITES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_SPEC_DESIG', 'T', 'BATCH_TEMP_SPEC_DESIG', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'BATCH_TEMP_WORKS', 'T', 'BATCH_TEMP_WORKS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_BATCH_RECONCILE', 'T', 'CSV_BATCH_RECONCILE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_BATCH_RECONCILE_REPORT', 'T', 'CSV_BATCH_RECONCILE_REPORT', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_EXPORTS', 'T', 'CSV_EXPORTS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_EXPORT_FILES', 'T', 'CSV_EXPORT_FILES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_FILE_ERRORS', 'T', 'CSV_FILE_ERRORS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_FILE_STRUCT', 'T', 'CSV_FILE_STRUCT', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_LOAD_ERRORS', 'T', 'CSV_LOAD_ERRORS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_RECON_SEARCH_TYPES', 'T', 'CSV_RECON_SEARCH_TYPES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_ADDITIONAL_STREET', 'T', 'CSV_TEMP_ADDITIONAL_STREET', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_HEADER', 'T', 'CSV_TEMP_HEADER', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_REINST_DESIG', 'T', 'CSV_TEMP_REINST_DESIG', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_SPECIAL_DESIG', 'T', 'CSV_TEMP_SPECIAL_DESIG', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_STREET', 'T', 'CSV_TEMP_STREET', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_STREET_XREF', 'T', 'CSV_TEMP_STREET_XREF', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'CSV_TEMP_TRAILER', 'T', 'CSV_TEMP_TRAILER', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ACTIVITY_STREETS_ALL', 'T', 'SWR_ACTIVITY_STREETS_ALL', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ADMIN_GROUPS', 'T', 'SWR_ADMIN_GROUPS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AIP_LIMITS', 'T', 'SWR_AIP_LIMITS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ALLOWABLE_DEFECT_MESSAGES', 'T', 'SWR_ALLOWABLE_DEFECT_MESSAGES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ALLOWABLE_INSP_ITEMS', 'T', 'SWR_ALLOWABLE_INSP_ITEMS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ALLOWABLE_SITE_UPDATES', 'T', 'SWR_ALLOWABLE_SITE_UPDATES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ANNUAL_INSPECTION_PROFILES', 'T', 'SWR_ANNUAL_INSPECTION_PROFILES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AOI_POLYGONS', 'T', 'SWR_AOI_POLYGONS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AOI_POLYGON_POINTS', 'T', 'SWR_AOI_POLYGON_POINTS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ASU_ALLOWABLE_NOTICES', 'T', 'SWR_ASU_ALLOWABLE_NOTICES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AUTOBATCH_OPERATIONS', 'T', 'SWR_AUTOBATCH_OPERATIONS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AUTOBATCH_PROCESSES', 'T', 'SWR_AUTOBATCH_PROCESSES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_AUTOBATCH_RULES', 'T', 'SWR_AUTOBATCH_RULES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_BATCH_MESSAGES', 'T', 'SWR_BATCH_MESSAGES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_BATCH_TRANSACTION_LOG', 'T', 'SWR_BATCH_TRANSACTION_LOG', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_CODE_CONTROLS', 'T', 'SWR_CODE_CONTROLS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_CONTACTS', 'T', 'SWR_CONTACTS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_COORD_GROUPS', 'T', 'SWR_COORD_GROUPS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_DEFECT_INSP_SCHEDULES', 'T', 'SWR_DEFECT_INSP_SCHEDULES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_FILE_TRANSMISSION_LOG', 'T', 'SWR_FILE_TRANSMISSION_LOG', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_HOLIDAYS', 'T', 'SWR_HOLIDAYS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ILI_HIST', 'T', 'SWR_ILI_HIST', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_CATEGORIES', 'T', 'SWR_INSP_CATEGORIES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_COSTS', 'T', 'SWR_INSP_COSTS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_ITEM_STATUS_CODES', 'T', 'SWR_INSP_ITEM_STATUS_CODES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_OUTCOME_TYPES', 'T', 'SWR_INSP_OUTCOME_TYPES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_ALL', 'T', 'SWR_INSP_RESULTS_ALL', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULTS_SITES_ALL', 'T', 'SWR_INSP_RESULTS_SITES_ALL', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_RESULT_LINES', 'T', 'SWR_INSP_RESULT_LINES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INSP_TYPES', 'T', 'SWR_INSP_TYPES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INTERFACE_MAPS', 'T', 'SWR_INTERFACE_MAPS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_INTERVALS', 'T', 'SWR_INTERVALS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRE_HIST_ALL', 'T', 'SWR_IRE_HIST_ALL', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_IRS_HIST_ALL', 'T', 'SWR_IRS_HIST_ALL', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_LOCALITIES', 'T', 'SWR_LOCALITIES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NAMING_AUTHORITIES', 'T', 'SWR_NAMING_AUTHORITIES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NAU_FOR_DOWNLOAD', 'T', 'SWR_NAU_FOR_DOWNLOAD', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NAU_SOI_DEFAULTS', 'T', 'SWR_NAU_SOI_DEFAULTS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NON_SWA_ACTIVITIES_ALL', 'T', 'SWR_NON_SWA_ACTIVITIES_ALL', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_CHARGES', 'T', 'SWR_NOTICE_CHARGES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_CHG_REPORTED', 'T', 'SWR_NOTICE_CHG_REPORTED', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_OF_WORKS', 'T', 'SWR_NOTICE_OF_WORKS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_PURGE_PARAMETERS', 'T', 'SWR_NOTICE_PURGE_PARAMETERS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_TYPES', 'T', 'SWR_NOTICE_TYPES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_NOTICE_WARNINGS', 'T', 'SWR_NOTICE_WARNINGS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_OPERATIONAL_DISTRICTS', 'T', 'SWR_OPERATIONAL_DISTRICTS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_ORGANISATIONS', 'T', 'SWR_ORGANISATIONS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_PENDING_BATCH_CSV_FILES', 'T', 'SWR_PENDING_BATCH_CSV_FILES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_RDE_SPATIAL_COORDS', 'T', 'SWR_RDE_SPATIAL_COORDS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_REF_CODES', 'T', 'SWR_REF_CODES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_REINSTATEMENT_CATEGORIES', 'T', 'SWR_REINSTATEMENT_CATEGORIES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_REINSTATEMENT_DESIGS', 'T', 'SWR_REINSTATEMENT_DESIGS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_S74_CHARGES', 'T', 'SWR_S74_CHARGES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_S74_CHARGE_COMPONENT', 'T', 'SWR_S74_CHARGE_COMPONENT', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_S74_CHARGING_PROFILE', 'T', 'SWR_S74_CHARGING_PROFILE', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SAD_SPATIAL_COORDS', 'T', 'SWR_SAD_SPATIAL_COORDS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SAMPLE_INSP_CATEGORIES', 'T', 'SWR_SAMPLE_INSP_CATEGORIES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SAMPLE_INSP_CATEGORY_ITEMS', 'T', 'SWR_SAMPLE_INSP_CATEGORY_ITEMS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SCHEDULE_TEMP', 'T', 'SWR_SCHEDULE_TEMP', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_ALL', 'T', 'SWR_SITES_ALL', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITES_HIST_ALL', 'T', 'SWR_SITES_HIST_ALL', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SCO_HIST', 'T', 'SWR_SITE_SCO_HIST', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SDE_HIST', 'T', 'SWR_SITE_SDE_HIST', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SPATIAL_COORDS', 'T', 'SWR_SITE_SPATIAL_COORDS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_SPECIAL_DESIGS', 'T', 'SWR_SITE_SPECIAL_DESIGS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SITE_STATUS_TRANSITIONS', 'T', 'SWR_SITE_STATUS_TRANSITIONS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SPECIAL_DESIG_OF_INTEREST', 'T', 'SWR_SPECIAL_DESIG_OF_INTEREST', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SPECIAL_DESIG_TYPES', 'T', 'SWR_SPECIAL_DESIG_TYPES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SSD_SPATIAL_COORDS', 'T', 'SWR_SSD_SPATIAL_COORDS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STANDARD_TEXT', 'T', 'SWR_STANDARD_TEXT', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREETS_ALL', 'T', 'SWR_STREETS_ALL', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREETS_OF_INTEREST_ALL', 'T', 'SWR_STREETS_OF_INTEREST_ALL', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_ADD', 'T', 'SWR_STREET_ADD', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_ALIASES', 'T', 'SWR_STREET_ALIASES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_GROUPS', 'T', 'SWR_STREET_GROUPS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_SPATIAL_COORDS', 'T', 'SWR_STREET_SPATIAL_COORDS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_SPECIAL_DESIGS', 'T', 'SWR_STREET_SPECIAL_DESIGS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_STREET_XREFS', 'T', 'SWR_STREET_XREFS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SYSTEM_OPTIONS', 'T', 'SWR_SYSTEM_OPTIONS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_SYS_DEFS', 'T', 'SWR_SYS_DEFS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_TEMP_1', 'T', 'SWR_TEMP_1', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_TEMP_2', 'T', 'SWR_TEMP_2', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_TEMP_ALLOWABLE_NOTICES', 'T', 'SWR_TEMP_ALLOWABLE_NOTICES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_TOWNS', 'T', 'SWR_TOWNS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_USERS', 'T', 'SWR_USERS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_USER_RESTRICTIONS', 'T', 'SWR_USER_RESTRICTIONS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_ALL', 'T', 'SWR_WORKS_ALL', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_COMMENTS', 'T', 'SWR_WORKS_COMMENTS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_COMMENTS_RECIPIENTS', 'T', 'SWR_WORKS_COMMENTS_RECIPIENTS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_HIST_ALL', 'T', 'SWR_WORKS_HIST_ALL', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_SITES_COMBINATIONS', 'T', 'SWR_WORKS_SITES_COMBINATIONS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORKS_STATUS_TRANSITIONS', 'T', 'SWR_WORKS_STATUS_TRANSITIONS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WORK_TYPES', 'T', 'SWR_WORK_TYPES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'SWR_WST_ALLOWABLE_NOTICES', 'T', 'SWR_WST_ALLOWABLE_NOTICES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_ACTIVITY_STREETS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_ADMIN_GROUPS_V', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_CATEGORY_A_SITES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_CATEGORY_B_SITES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_CATEGORY_C_SITES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_DEFECT_RESPONSES_REQUIRED', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_DISTRICT_VIEW', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_DIS_DATES_V', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_GIS_WORKS_SITES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_INSP_RESULTS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_IRE_HIST', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_IRE_HIST_V', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_NON_SWA_ACTIVITIES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_ORG_DIST_V', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_S74_DATES_V', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_SITES', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_SITES_HIST', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_SITES_HIST_V', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_SITES_PLUS_NSWA_SITES_ALL', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_SITES_PROMOTED_V', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_SITES_V', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_SITE_SCO_HIST_V', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_SITE_SDE_HIST_V', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_STREETS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_STREETS_OF_INTEREST', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_TEMP_ALLOWABLE_NOTICES_V', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_WORKS', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_WORKS_HIST', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_WORKS_HIST_V', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'SWR_WORK_SITES_V', 'SWR'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TMP_UKP0015_RSE_MEMBS', 'C', 'UKP0015_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKP03_SUMMARY_REPORT_WHERE', 'C', 'USRW_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ACCIDENTS_AT_WORKS', 'C', 'UACW_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_AGE_WEIGHTING', 'C', 'UAW_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ANALYSIS_PERIOD', 'C', 'UANP_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ATTR_IN_PROJECT', 'C', 'UAIP_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ATTR_IN_PROJECT', 'C', 'UAIP_URS_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_AUTOMATIC_PASS', 'C', 'UAP_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_BASIC_DEFECT', 'C', 'UBD_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_BUDGET', 'C', 'UB_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_BUDGET_HEAD', 'C', 'UBH_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_BUDGET_HEAD', 'C', 'UBH_UB', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_BUDGET_HEAD_INSTANCE', 'C', 'UBHI_UBH_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_BUDGET_HEAD_INSTANCE', 'C', 'UBHI_UBI_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_BUDGET_INSTANCE', 'C', 'UBI_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_BUDGET_INSTANCE', 'C', 'UBI_UB_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CHOP_ATTRIBS', 'C', 'UCA_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CI_PAVET_FOR_FEATURE', 'C', 'UCPF_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CLOSURE_DUE_TO_WORKS', 'C', 'UKCW_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CLOSURE_TYPE', 'C', 'UCLT_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CONDITION_INDEX_REPORT', 'C', 'UCI_UAP_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CONDITION_INDEX_REPORT', 'C', 'UCI_UCS_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CONSEQUENT_COST_PER', 'C', 'UCCP_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CONSTRUCTION_TYPE', 'C', 'UCT_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_COST_OF_ACCIDENTS_WORKS', 'C', 'UCAW_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CROSS_SECTIONAL_POSITION', 'C', 'UCS_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFAULT_FEATURE_WIDTHS', 'C', 'UDW_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECTS', 'C', 'UBD_UPT_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECTS', 'C', 'UKD_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_BASE_DATE_GROUP', 'C', 'UDG_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_CALC_ATTS', 'C', 'UDCA_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_CALC_STEPS', 'C', 'UDCS_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_COMPOSITION', 'C', 'UDC_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTHS', 'C', 'UDK_UF_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTHS', 'C', 'UDL_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTHS', 'C', 'UDL_UAP_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTHS', 'C', 'UDL_UCS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTHS', 'C', 'UDL_UPT_AFTER_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTHS', 'C', 'UDL_UPT_BEFORE_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTH_CI', 'C', 'UDI_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTH_CI', 'C', 'UDI_UDK_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTH_FUNCTIONAL', 'C', 'UDF_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTH_FUNCTIONAL', 'C', 'UDF_UDL_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTH_FUNCTIONAL', 'C', 'UDF_UKD_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTH_TREATMENTS', 'C', 'UDLT_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTH_TREATMENTS', 'C', 'UDT_UDL_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_PARAMETER', 'C', 'UDP_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_PARAMETER', 'C', 'UDP_UST_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_PARAM_OPT', 'C', 'UDPO_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_PARAM_OPT', 'C', 'UDPO_USC_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_TRANSFORMATION', 'C', 'UDT_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_TRANSFORMATION', 'C', 'UDT_UKD_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_TRANSFORMATION', 'C', 'UDT_USC_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DELAY_DUE_TO_WORKS', 'C', 'UDDW_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DIVERSION_QUALITY', 'C', 'UDQ_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DRAINAGE_STATUS', 'C', 'UDS_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DURATION_OF_WORKS', 'C', 'UKDW_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_EFFECT_OF_TREATMENT', 'C', 'UET_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_EFFECT_OF_TREATMENT', 'C', 'UET_UF_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_EFFECT_OF_TREATMENT', 'C', 'UET_UG_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_EFFECT_OF_TREATMENT', 'C', 'UET_UPT_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_EFFECT_OF_TREATMENT', 'C', 'UET_URS_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_EFFECT_OF_TREATMENT', 'C', 'UET_UTT_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_EFFECT_OF_TREATMENT', 'C', 'UET_UT_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ESTIM_TREAT_UNIT_COST', 'C', 'UEU_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ESTIM_TREAT_UNIT_COST', 'C', 'UEU_UF_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ESTIM_TREAT_UNIT_COST', 'C', 'UEU_UGT_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ESTIM_TREAT_UNIT_COST', 'C', 'UEU_UTT_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FEATURE', 'C', 'UF_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FEATURE_ATTRIBUTE', 'C', 'UFA_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FEATURE_ATTRIBUTE', 'C', 'UFA_UF_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FEATURE_ATTRIBUTE_OPT', 'C', 'UFAC_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FEATURE_ATTRIBUTE_OPT', 'C', 'UFAC_UFA_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FEATURE_CI_PAVEMENT', 'C', 'UFCP_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FEATURE_CI_PAVEMENT', 'C', 'UFCP_UF_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FEATURE_CI_PAVEMENT', 'C', 'UFCP_UPT_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FEATURE_HIERARCHY', 'C', 'UFH_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FEATURE_HIERARCHY', 'C', 'UFH_UF_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FOOTWAY_STATUS', 'C', 'UFS_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FW_OPENING_FREQUENCY', 'C', 'UFF_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_GENERIC_TREATMENT', 'C', 'UG_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_INTERVENTION_LVL_HIER', 'C', 'UIH_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_INTERVENTION_LVL_HIER', 'C', 'UIH_UF_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_INTERVENTION_LVL_HIER', 'C', 'UIH_URS_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_METHOD_1_RATING_COORD', 'C', 'UM1RC_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_METHOD_2_RATING_LOOKUP', 'C', 'UM2_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_NET_SEL_MERGE', 'C', 'UNM_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_NET_SEL_MERGE', 'C', 'UNM_UAP_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_NON_PRIN_PI_UDLS', 'C', 'UNPPU_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_OVERALL_CI_CALC', 'C', 'UOC_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_OVERALL_CI_CALC', 'C', 'UOC_UF_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_OVERALL_CI_CALC', 'C', 'UOC_UPT_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_OVERALL_CI_CALC', 'C', 'UOC_URS_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_OVERALL_CI_CALC_DETAIL', 'C', 'UOD_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_OVERALL_CI_CALC_DETAIL', 'C', 'UOD_UF_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_OVERALL_CI_CALC_DETAIL', 'C', 'UOD_UPT_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_OVERALL_CI_CALC_DETAIL', 'C', 'UOD_URS_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PASS_AUDIT_ENTRIES', 'C', 'UPA_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PASS_BUDGET_INSTANCE', 'C', 'UPB_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PASS_BUDGET_INSTANCE', 'C', 'UPB_UAP_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PASS_BUDGET_INSTANCE', 'C', 'UPB_UBI_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PASS_ROAD_RUN_TIME_DETS', 'C', 'UPRTD_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PASS_SURVEY_TYPES', 'C', 'UPST_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PAVEMENT_TYPE', 'C', 'UPT_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PAVEMENT_TYPE_FOR_CONS', 'C', 'UPTC_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PAVEMENT_TYPE_FOR_CONS', 'C', 'UPTC_UPT_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PROJECTION_CURVE', 'C', 'UPC_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PROJECTION_CURVE', 'C', 'UPC_URS_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PROJECTION_CURVE_POINT', 'C', 'UCP_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PROJECTION_CURVE_POINT', 'C', 'UCP_UPC_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PROJECTION_RELATIONSHIP', 'C', 'UPR_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RANKING_CURVE', 'C', 'URC_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RANKING_CURVE', 'C', 'URC_UG_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RATING_CI_CALC_DETAIL', 'C', 'UCD_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RATING_CI_CALC_DETAIL', 'C', 'UCD_UCC_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RATING_CI_CALC_DETAIL', 'C', 'UCD_UKD_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RATING_DEFECTS', 'C', 'URD_UAP_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RATING_DEFECTS', 'C', 'URD_UKD_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RATING_LENGTH_CI_CALC', 'C', 'UCC_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RATING_LENGTH_CI_CALC', 'C', 'UCC_UF_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RATING_LENGTH_CI_CALC', 'C', 'UCC_UPT_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RMMS_UKPMS_MAPPING', 'C', 'UKPMS_ROAD_TYPE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ROAD_TYPE', 'C', 'URT_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ROUTINE_MAINT_COST', 'C', 'UKRC_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RULE_LINE_TREATMENT', 'C', 'URLT_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RULE_LINE_TREATMENT', 'C', 'URLT_UF_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RULE_LINE_TREATMENT', 'C', 'URLT_UG_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RULE_LINE_TREATMENT', 'C', 'URLT_UPT_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RULE_LINE_TREATMENT', 'C', 'URLT_UTT_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RULE_LINE_TREATMENT', 'C', 'URLT_UT_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RULE_SET', 'C', 'URS_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_SURVEY', 'C', 'US_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_SURVEY', 'C', 'US_UST_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_SURVEY_TYPE', 'C', 'UST_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TRAFFIC_LEVEL', 'C', 'UTL_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREATMENT', 'C', 'UT_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREATMENT_COMPOSITION', 'C', 'UTC_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREATMENT_TYPE', 'C', 'UTT_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREAT_COMP_SISS', 'C', 'UTS_FK_URS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREAT_COMP_SISS', 'C', 'UTS_FK_UTC', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREAT_COMP_SISS', 'C', 'UTS_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREAT_SEL_RULE_CELL', 'C', 'URC2_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREAT_SEL_RULE_LINE', 'C', 'URL_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_VALID_DEFECT', 'C', 'UVD_PK2', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_VALID_DEFECT_PARAMETER', 'C', 'UVDP_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_VALID_DEFECT_PARAM_OPT', 'C', 'UPO_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_VALID_DEFECT_PARAM_OPT', 'C', 'UPO_UKD_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_VALID_DEFECT_PARAM_OPT', 'C', 'UPO_UST_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_VALUE_OF_TIME', 'C', 'UVTI_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_VEHICULAR_TRAFFIC', 'C', 'UVT_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_VIEW_DEFINITIONS', 'C', 'UVD_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_XSP_FEATURES', 'C', 'UXF_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_XSP_FEATURES', 'C', 'UXF_UF_FK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_XSP_MAPPING', 'C', 'UXM_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_XSP_REVERSAL', 'C', 'UXR_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TMP_UKP0015_RSE_MEMBS', 'I', 'UKP0015_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TMP_UKP0095', 'I', 'TMPU95_IND_U1', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKP03_SUMMARY_REPORT_WHERE', 'I', 'USRW_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ACCIDENTS_AT_WORKS', 'I', 'UACW_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_AGE_WEIGHTING', 'I', 'UAW_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ANALYSIS_PERIOD', 'I', 'UANP_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ATTR_IN_PROJECT', 'I', 'UAIP_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_AUTOMATIC_PASS', 'I', 'UAP_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_BASIC_DEFECT', 'I', 'UBD_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_BUDGET', 'I', 'UB_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_BUDGET_HEAD', 'I', 'UBH_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_BUDGET_INSTANCE', 'I', 'UBI_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_BUDGET_REPORT', 'I', 'UBR_1_ID', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CHOP_ATTRIBS', 'I', 'UCA_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CI_PAVET_FOR_FEATURE', 'I', 'UCPF_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CLOSURE_DUE_TO_WORKS', 'I', 'UKCW_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CLOSURE_TYPE', 'I', 'UCLT_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CONDITION_INDEX_REPORT', 'I', 'UKPMS_CI_UK_1', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CONSEQUENT_COST_PER', 'I', 'UCCP_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CONSTRUCTION_TYPE', 'I', 'UCT_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_COST_OF_ACCIDENTS_WORKS', 'I', 'UCAW_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CROSS_SECTIONAL_POSITION', 'I', 'UCS_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFAULT_FEATURE_WIDTHS', 'I', 'UDW_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECTS', 'I', 'UKD_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_BASE_DATE_GROUP', 'I', 'UDG_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_CALC_ATTS', 'I', 'UDCA_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_CALC_STEPS', 'I', 'UDCS_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_COMPOSITION', 'I', 'UDC_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_COMPOSITION', 'I', 'UKPMS_DC_UK_1', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTHS', 'I', 'UDL_IDX_2', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTHS', 'I', 'UDL_IDX_3', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTHS', 'I', 'UDL_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTH_CI', 'I', 'UDI_IDX_2', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTH_CI', 'I', 'UDI_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTH_FUNCTIONAL', 'I', 'UDF_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTH_TREATMENTS', 'I', 'UDLT_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_PARAMETER', 'I', 'UDP_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_PARAM_OPT', 'I', 'UDPO_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_TRANSFORMATION', 'I', 'UDT_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEF_LEN_SUMMARY_EXTRACT', 'I', 'UDLSE_1', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DELAY_DUE_TO_WORKS', 'I', 'UDDW_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DIVERSION_QUALITY', 'I', 'UDQ_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DRAINAGE_STATUS', 'I', 'UDS_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DURATION_OF_WORKS', 'I', 'UKDW_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_EFFECT_OF_TREATMENT', 'I', 'UET_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ESTIM_TREAT_UNIT_COST', 'I', 'UEU_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FEATURE', 'I', 'UF_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FEATURE_ATTRIBUTE', 'I', 'UFA_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FEATURE_ATTRIBUTE_OPT', 'I', 'UFAC_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FEATURE_CI_PAVEMENT', 'I', 'UFCP_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FEATURE_HIERARCHY', 'I', 'UFH_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FOOTWAY_STATUS', 'I', 'UFS_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FW_OPENING_FREQUENCY', 'I', 'UFF_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_GENERIC_TREATMENT', 'I', 'UG_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_INTERVENTION_LVL_HIER', 'I', 'UIH_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_LOCAL_WEIGHTING', 'I', 'INDEX_ULW1', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_METHOD_1_RATING_COORD', 'I', 'UM1RC_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_METHOD_2_RATING_LOOKUP', 'I', 'UM2_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_NET_SEL_MERGE', 'I', 'UNM_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_NON_PRIN_PI_UDLS', 'I', 'UNPPU_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_OVERALL_CI_CALC', 'I', 'UOC_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_OVERALL_CI_CALC_DETAIL', 'I', 'UOD_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PASS_AUDIT_ENTRIES', 'I', 'UPA_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PASS_BUDGET_INSTANCE', 'I', 'UPB_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PASS_ROAD_RUN_TIME_DETS', 'I', 'UPRTD_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PASS_SURVEY_TYPES', 'I', 'UPST_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PAVEMENT_TYPE', 'I', 'UPT_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PAVEMENT_TYPE_FOR_CONS', 'I', 'UPTC_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PROJECTION_CURVE', 'I', 'UPC_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PROJECTION_CURVE_POINT', 'I', 'UCP_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PROJECTION_RELATIONSHIP', 'I', 'UPR_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RANKING_CURVE', 'I', 'URC_IDX', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RANKING_CURVE', 'I', 'URC_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RATING_CI_CALC_DETAIL', 'I', 'UCD_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RATING_DEFECTS', 'I', 'URD_IDX', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RATING_DEFECTS', 'I', 'URD_IDX_2', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RATING_DEFECTS', 'I', 'URD_ITEM_ID', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RATING_LENGTH_CI_CALC', 'I', 'UCC_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RMMS_UKPMS_MAPPING', 'I', 'URUM_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ROAD_TYPE', 'I', 'URT_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ROUTINE_MAINT_COST', 'I', 'UKRC_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RULE_LINE_TREATMENT', 'I', 'URLT_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RULE_SET', 'I', 'URS_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_SURVEY', 'I', 'US_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_SURVEY_TYPE', 'I', 'UST_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TEMP_VAR_CI_LENGTHS', 'I', 'UVCI_IDX', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TRAFFIC_LEVEL', 'I', 'UTL_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREATMENT', 'I', 'UT_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREATMENT_COMPOSITION', 'I', 'UTC_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREATMENT_TYPE', 'I', 'UTT_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREAT_COMP_SISS', 'I', 'UTS_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREAT_SEL_RULE_CELL', 'I', 'URC2_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREAT_SEL_RULE_CELL', 'I', 'URC_IDX1', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREAT_SEL_RULE_LINE', 'I', 'URL_IDX1', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_VALID_DEFECT', 'I', 'UVD_PK2', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_VALID_DEFECT_PARAMETER', 'I', 'UVDP_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_VALID_DEFECT_PARAM_OPT', 'I', 'UPO_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_VALUE_OF_TIME', 'I', 'UVTI_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_VEHICULAR_TRAFFIC', 'I', 'UVT_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_VIEW_DEFINITIONS', 'I', 'UVD_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_XSP_FEATURES', 'I', 'UXF_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_XSP_MAPPING', 'I', 'UXM_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_XSP_REVERSAL', 'I', 'UXR_PK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'UKP0005', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'UKP0006', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'UKP0008', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'UKPMS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'UKPMS03', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'UKPMS_BUDGETING', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'UKPMS_CALC_CI', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'UKPMS_DEFECTIVENESS_AND_RATING', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'UKPMS_INITIAL_DEFECTS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'UKPMS_MERGE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'UKPMS_PI_REP_SUPPORT', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'P', 'UKPMS_TREATMENT_SELECTION', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'UKPMS_MAINT_UR', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'R', 'UKPMS_RUN_PASS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'UAP_ID_SEQ', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'UB_ID_SEQ', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'UDI_ID_SEQ', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'UDL_ID_SEQ', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'UET_ID_SEQ', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'UPR_ID_SEQ', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'URL_ID_SEQ', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'S', 'URS_ID_SEQ', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TMP_UKP0015_RSE_MEMBS', 'T', 'TMP_UKP0015_RSE_MEMBS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'TMP_UKP0095', 'T', 'TMP_UKP0095', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKP03_SUMMARY_REPORT_WHERE', 'T', 'UKP03_SUMMARY_REPORT_WHERE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ACCIDENTS_AT_WORKS', 'T', 'UKPMS_ACCIDENTS_AT_WORKS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_AGE_WEIGHTING', 'T', 'UKPMS_AGE_WEIGHTING', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ANALYSIS_PERIOD', 'T', 'UKPMS_ANALYSIS_PERIOD', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ATTR_IN_PROJECT', 'T', 'UKPMS_ATTR_IN_PROJECT', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_AUTOMATIC_PASS', 'T', 'UKPMS_AUTOMATIC_PASS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_BASIC_DEFECT', 'T', 'UKPMS_BASIC_DEFECT', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_BUDGET', 'T', 'UKPMS_BUDGET', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_BUDGET_HEAD', 'T', 'UKPMS_BUDGET_HEAD', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_BUDGET_HEAD_INSTANCE', 'T', 'UKPMS_BUDGET_HEAD_INSTANCE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_BUDGET_HEAD_RULE_LINE', 'T', 'UKPMS_BUDGET_HEAD_RULE_LINE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_BUDGET_INSTANCE', 'T', 'UKPMS_BUDGET_INSTANCE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_BUDGET_REPORT', 'T', 'UKPMS_BUDGET_REPORT', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CHOP_ATTRIBS', 'T', 'UKPMS_CHOP_ATTRIBS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CI_PAVET_FOR_FEATURE', 'T', 'UKPMS_CI_PAVET_FOR_FEATURE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CLOSURE_DUE_TO_WORKS', 'T', 'UKPMS_CLOSURE_DUE_TO_WORKS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CLOSURE_TYPE', 'T', 'UKPMS_CLOSURE_TYPE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CONDITION_INDEX', 'T', 'UKPMS_CONDITION_INDEX', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CONDITION_INDEX_REPORT', 'T', 'UKPMS_CONDITION_INDEX_REPORT', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CONSEQUENT_COST_PER', 'T', 'UKPMS_CONSEQUENT_COST_PER', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CONSTRUCTION_TYPE', 'T', 'UKPMS_CONSTRUCTION_TYPE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_COST_OF_ACCIDENTS_WORKS', 'T', 'UKPMS_COST_OF_ACCIDENTS_WORKS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_CROSS_SECTIONAL_POSITION', 'T', 'UKPMS_CROSS_SECTIONAL_POSITION', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFAULT_FEATURE_WIDTHS', 'T', 'UKPMS_DEFAULT_FEATURE_WIDTHS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECTIVENESS_CALC', 'T', 'UKPMS_DEFECTIVENESS_CALC', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECTS', 'T', 'UKPMS_DEFECTS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_BASE_DATE_GROUP', 'T', 'UKPMS_DEFECT_BASE_DATE_GROUP', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_CALC_ATTS', 'T', 'UKPMS_DEFECT_CALC_ATTS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_CALC_STEPS', 'T', 'UKPMS_DEFECT_CALC_STEPS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_CATEGORY', 'T', 'UKPMS_DEFECT_CATEGORY', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_COMPOSITION', 'T', 'UKPMS_DEFECT_COMPOSITION', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTHS', 'T', 'UKPMS_DEFECT_LENGTHS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTH_CI', 'T', 'UKPMS_DEFECT_LENGTH_CI', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTH_FUNCTIONAL', 'T', 'UKPMS_DEFECT_LENGTH_FUNCTIONAL', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_LENGTH_TREATMENTS', 'T', 'UKPMS_DEFECT_LENGTH_TREATMENTS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_PARAMETER', 'T', 'UKPMS_DEFECT_PARAMETER', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_PARAM_OPT', 'T', 'UKPMS_DEFECT_PARAM_OPT', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEFECT_TRANSFORMATION', 'T', 'UKPMS_DEFECT_TRANSFORMATION', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DEF_LEN_SUMMARY_EXTRACT', 'T', 'UKPMS_DEF_LEN_SUMMARY_EXTRACT', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DELAY_DUE_TO_WORKS', 'T', 'UKPMS_DELAY_DUE_TO_WORKS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DIVERSION_QUALITY', 'T', 'UKPMS_DIVERSION_QUALITY', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DRAINAGE_STATUS', 'T', 'UKPMS_DRAINAGE_STATUS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_DURATION_OF_WORKS', 'T', 'UKPMS_DURATION_OF_WORKS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_EFFECT_OF_TREATMENT', 'T', 'UKPMS_EFFECT_OF_TREATMENT', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ESTIM_TREAT_UNIT_COST', 'T', 'UKPMS_ESTIM_TREAT_UNIT_COST', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FEATURE', 'T', 'UKPMS_FEATURE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FEATURE_ATTRIBUTE', 'T', 'UKPMS_FEATURE_ATTRIBUTE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FEATURE_ATTRIBUTE_OPT', 'T', 'UKPMS_FEATURE_ATTRIBUTE_OPT', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FEATURE_CI_PAVEMENT', 'T', 'UKPMS_FEATURE_CI_PAVEMENT', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FEATURE_HIERARCHY', 'T', 'UKPMS_FEATURE_HIERARCHY', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FOOTWAY_STATUS', 'T', 'UKPMS_FOOTWAY_STATUS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_FW_OPENING_FREQUENCY', 'T', 'UKPMS_FW_OPENING_FREQUENCY', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_GENERIC_TREATMENT', 'T', 'UKPMS_GENERIC_TREATMENT', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_INTERVENTION_LVL_HIER', 'T', 'UKPMS_INTERVENTION_LVL_HIER', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_LOCAL_WEIGHTING', 'T', 'UKPMS_LOCAL_WEIGHTING', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_METHOD_1_RATING_COORD', 'T', 'UKPMS_METHOD_1_RATING_COORD', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_METHOD_2_RATING_LOOKUP', 'T', 'UKPMS_METHOD_2_RATING_LOOKUP', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_NET_SEL_MERGE', 'T', 'UKPMS_NET_SEL_MERGE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_NON_PRIN_PI_UDLS', 'T', 'UKPMS_NON_PRIN_PI_UDLS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_OVERALL_CI_CALC', 'T', 'UKPMS_OVERALL_CI_CALC', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_OVERALL_CI_CALC_DETAIL', 'T', 'UKPMS_OVERALL_CI_CALC_DETAIL', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PASS_AUDIT_ENTRIES', 'T', 'UKPMS_PASS_AUDIT_ENTRIES', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PASS_BUDGET_INSTANCE', 'T', 'UKPMS_PASS_BUDGET_INSTANCE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PASS_ROAD_RUN_TIME_DETS', 'T', 'UKPMS_PASS_ROAD_RUN_TIME_DETS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PASS_SURVEY_TYPES', 'T', 'UKPMS_PASS_SURVEY_TYPES', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PAVEMENT_TYPE', 'T', 'UKPMS_PAVEMENT_TYPE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PAVEMENT_TYPE_FOR_CONS', 'T', 'UKPMS_PAVEMENT_TYPE_FOR_CONS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PAVEMENT_TYPE_TREAT', 'T', 'UKPMS_PAVEMENT_TYPE_TREAT', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PROJECTION_CURVE', 'T', 'UKPMS_PROJECTION_CURVE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PROJECTION_CURVE_POINT', 'T', 'UKPMS_PROJECTION_CURVE_POINT', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PROJECTION_PARAMETERS', 'T', 'UKPMS_PROJECTION_PARAMETERS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_PROJECTION_RELATIONSHIP', 'T', 'UKPMS_PROJECTION_RELATIONSHIP', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RANKING_CURVE', 'T', 'UKPMS_RANKING_CURVE', 'UKP'); 
COMMIT;
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RATING_CI_CALC_DETAIL', 'T', 'UKPMS_RATING_CI_CALC_DETAIL', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RATING_DEFECTS', 'T', 'UKPMS_RATING_DEFECTS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RATING_LENGTH_CI_CALC', 'T', 'UKPMS_RATING_LENGTH_CI_CALC', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RMMS_UKPMS_MAPPING', 'T', 'UKPMS_RMMS_UKPMS_MAPPING', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ROAD_TYPE', 'T', 'UKPMS_ROAD_TYPE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ROAD_TYPE_XSP', 'T', 'UKPMS_ROAD_TYPE_XSP', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_ROUTINE_MAINT_COST', 'T', 'UKPMS_ROUTINE_MAINT_COST', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RULE_LINE_TREATMENT', 'T', 'UKPMS_RULE_LINE_TREATMENT', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_RULE_SET', 'T', 'UKPMS_RULE_SET', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_SECT_LABEL', 'T', 'UKPMS_SECT_LABEL', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_SURVEY', 'T', 'UKPMS_SURVEY', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_SURVEY_TYPE', 'T', 'UKPMS_SURVEY_TYPE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_T1_SURVEY_TYPES', 'T', 'UKPMS_T1_SURVEY_TYPES', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TEMP_RATING_CI_CALC', 'T', 'UKPMS_TEMP_RATING_CI_CALC', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TEMP_VAR_CI_LENGTHS', 'T', 'UKPMS_TEMP_VAR_CI_LENGTHS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TRAFFIC_LEVEL', 'T', 'UKPMS_TRAFFIC_LEVEL', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREATMENT', 'T', 'UKPMS_TREATMENT', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREATMENT_COMPOSITION', 'T', 'UKPMS_TREATMENT_COMPOSITION', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREATMENT_FUNCTIONAL', 'T', 'UKPMS_TREATMENT_FUNCTIONAL', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREATMENT_TYPE', 'T', 'UKPMS_TREATMENT_TYPE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREAT_COMP_SISS', 'T', 'UKPMS_TREAT_COMP_SISS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREAT_SEL_INTVENT_LVL', 'T', 'UKPMS_TREAT_SEL_INTVENT_LVL', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREAT_SEL_RULE_CELL', 'T', 'UKPMS_TREAT_SEL_RULE_CELL', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_TREAT_SEL_RULE_LINE', 'T', 'UKPMS_TREAT_SEL_RULE_LINE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_UKP0018_TEMP', 'T', 'UKPMS_UKP0018_TEMP', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_VALID_DEFECT', 'T', 'UKPMS_VALID_DEFECT', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_VALID_DEFECT_PARAMETER', 'T', 'UKPMS_VALID_DEFECT_PARAMETER', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_VALID_DEFECT_PARAM_OPT', 'T', 'UKPMS_VALID_DEFECT_PARAM_OPT', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_VALUE_OF_TIME', 'T', 'UKPMS_VALUE_OF_TIME', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_VEHICULAR_TRAFFIC', 'T', 'UKPMS_VEHICULAR_TRAFFIC', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_VIEW_DEFINITIONS', 'T', 'UKPMS_VIEW_DEFINITIONS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_XSP_FEATURES', 'T', 'UKPMS_XSP_FEATURES', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_XSP_MAPPING', 'T', 'UKPMS_XSP_MAPPING', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
'UKPMS_XSP_REVERSAL', 'T', 'UKPMS_XSP_REVERSAL', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'UKPMS_AUTO_PASS_NETWORK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'UKPMS_CONDITION_INDICES', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'UKPMS_DEF_LEN_CI_TYPE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'UKPMS_DEF_LEN_FUNC_TYPE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'UKPMS_DEF_LEN_NETWORK', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'UKPMS_DEF_LEN_SUMMARY', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'UKPMS_MERGE_SECTION', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'UKPMS_NETWORK_NODE', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'UKPMS_TREATMENTS', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'UKPMS_TREAT_RULES', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_UKPMS_CT', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_UKPMS_CVI', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_UKPMS_CW', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_UKPMS_DEF', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_UKPMS_DUMMY', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_UKPMS_DVI', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_UKPMS_FW', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_UKPMS_HRM', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_UKPMS_KB', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_UKPMS_LJ', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_UKPMS_ROAD_SECTION', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_UKPMS_SCRIM', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_UKPMS_THRESHOLD', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_UKPMS_TJ', 'UKP'); 
INSERT INTO PRE_MIGRATION_CHECK_OBJS ( TABLE_NAME, OBJECT_TYPE, OBJECT_NAME,
PRODUCT ) VALUES ( 
NULL, 'V', 'V_UKPMS_VG', 'UKP'); 
COMMIT;
--
---------------------------------------------------------------------------------------------------
--                        **************** PACKAGES  *******************
SET TERM ON
Prompt Packages...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'pre_migration_check.pkh' run_file
from dual
/
SET TERM ON
PROMPT pre_migration_check Package Header
SET TERM OFF

SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

SET DEFINE ON
select '&exor_base'||'pre_migration_check.pkw' run_file
from dual
/
SET TERM ON
PROMPT pre_migration_check Package body
SET TERM OFF

SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

SET TERM ON

PROMPT Show Package Errors

SHOW ERROR PACKAGE pre_migration_check

SHOW ERROR PACKAGE BODY pre_migraion_check

PROMPT Done
PROMPT
PROMPT

EXIT
