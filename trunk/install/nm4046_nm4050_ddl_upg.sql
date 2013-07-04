------------------------------------------------------------------
-- nm4046_nm4050_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4046_nm4050_ddl_upg.sql-arc   3.7   Jul 04 2013 14:10:28   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4046_nm4050_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:10:28  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:53:50  $
--       Version          : $Revision:   3.7  $
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------


------------------------------------------------------------------

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Change to HIG_PU table
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (JAMES WADSWORTH)
-- **** COMMENTS TO BE ADDED BY JWA ****
-- 
------------------------------------------------------------------
ALTER TABLE HIG_PU MODIFY(HPU_PID VARCHAR2(20 BYTE));

 

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Missing Indexes
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (JAMES WADSWORTH)
-- Adds the DOC_FK_DMD_IND, DOC_FK_DTP_IND, DOC_FK_HAU_IND and DOC_FK_HUS1_IND indexes
-- 
------------------------------------------------------------------
Declare
  do_nothing exception;
  pragma exception_init(do_nothing,-955);
Begin
  --
  Begin
    EXECUTE IMMEDIATE('CREATE INDEX DOC_FK_DMD_IND ON DOCS (DOC_DLC_DMD_ID)');
  Exception
    WHEN do_nothing THEN null;
    WHEN others THEN raise;
  End;
  --
  Begin
    EXECUTE IMMEDIATE('CREATE INDEX DOC_FK_DTP_IND ON DOCS (DOC_DTP_CODE)');  
  Exception
    WHEN do_nothing THEN null;
    WHEN others THEN raise;
  End;
  --
  Begin
    EXECUTE IMMEDIATE('CREATE INDEX DOC_FK_HAU_IND ON DOCS (DOC_ADMIN_UNIT)');
  Exception
    WHEN do_nothing THEN null;
    WHEN others THEN raise;
  End;
  --
  Begin
    EXECUTE IMMEDIATE('CREATE INDEX DOC_FK_HUS1_IND ON DOCS (DOC_USER_ID)');
  Exception
    WHEN do_nothing THEN null;
    WHEN others THEN raise;
  End;
  --
 End;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT nm_nw_ad_link_all added columns
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED PROBLEM MANAGER LOG#
-- 711748
-- 
-- CUSTOMER
-- Exor Corporation Ltd
-- 
-- PROBLEM
-- These changes are likely to force new forms to be generated due to signature issues.
-- Two new columns on the nm_nw_ad_link_all table should be added as well as changes to the view nm_nw_ad_link (date-tracked view).  They are:
-- 
-- '	NAD_MEMBER_ID		Number(9)
-- '	NAD_WHOLE_ROAD		Varchar2(1)
-- 
-- The whole-road flag should default to 1, ie whole-road ' this allows other data to be manipulated consistently.
-- 
-- A Trigger on the table should be built to populate the member id to be asset id if partial or the road group id if whole-road.
-- 
-- The nm3nsgasd and other packages should be modified accordingly. Creation and edit of the asd record should create the correct value of the whole-road flag.
-- 
-- An upgrade script should be built to populate the whole road from the relevant inventory attribute.
-- 
-- The generation of the members should use this normalized data on the nm_nw_ad_link_all table. The spatial generation of NSG shapes should also use this column. 
-- 
-- 
------------------------------------------------------------------

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (PRIIDU TANAVA)
-- This script adds two columns into NM_NW_AD_LINK_ALL, needed in connection with log 711748. The view NM_NW_AD_LINK needs to be recreated too, this should happen during the standard upgraded process.
-- 
------------------------------------------------------------------
alter table nm_nw_ad_link_all
disable all triggers
/


alter table nm_nw_ad_link_all
add ( nad_whole_road varchar2(1) default '1',
      nad_member_id  number(9) )
/      



update nm_nw_ad_link_all
set nad_member_id = nad_ne_id
  , nad_whole_road = '1'
/

commit;
/

alter table nm_nw_ad_link_all modify (
   nad_whole_road not null
  ,nad_member_id not null
)
/

 

update nm_nw_ad_link_all
set nad_whole_road = '0',
    nad_member_id = nad_iit_ne_id
where exists ( select 1
               from nm_inv_items_all i
               where iit_ne_id = nad_iit_ne_id
               and decode ( iit_inv_type, 'TP21', iit_chr_attrib30, 
                                          'TP22', iit_chr_attrib28,
                                          'TP23', iit_chr_attrib34,
                                          'TP51', iit_chr_attrib30,
                                          'TP52', iit_chr_attrib28,
                                          'TP53', iit_chr_attrib34 ) = '0' )

/

commit;
/



create index nad_member_id_ind on nm_nw_ad_link_all ( nad_member_id )
/



alter table nm_nw_ad_link_all
enable all triggers
/

 

-- end of upgrade


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Increase size of HOV_VALUE
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (JAMES WADSWORTH)
-- Increase in size of the hov_value column on hig_option_values.
-- 
------------------------------------------------------------------
alter table hig_option_values modify hov_value varchar2(500)
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Node Purpose column
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Add Node Purpose column to NM_NODES_ALL
-- 
------------------------------------------------------------------

-- Add Node Purpose column

alter table nm_nodes_all add (
   no_purpose varchar(240)
)
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Rebuild NM_THEMES_ALL table
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Rebuild NM_THEMES_ALL table so that column order and column defaults are consistant with table that is installed.
-- 
------------------------------------------------------------------

PROMPT Dropping Foreign Key on 'NATH_FK_NTH'
ALTER TABLE NM_AREA_THEMES DROP CONSTRAINT NATH_FK_NTH;

PROMPT Dropping Foreign Key on 'NBTH_NTH_FK'
ALTER TABLE NM_BASE_THEMES DROP CONSTRAINT NBTH_NTH_FK;

PROMPT Dropping Foreign Key on 'NBTH_BASE_FK'
ALTER TABLE NM_BASE_THEMES DROP CONSTRAINT NBTH_BASE_FK;

PROMPT Dropping Foreign Key on 'NITH_NTH_FK'
ALTER TABLE NM_INV_THEMES  DROP CONSTRAINT NITH_NTH_FK;

PROMPT Dropping Foreign Key on 'NNTH_NTH_FK'
ALTER TABLE NM_NW_THEMES   DROP CONSTRAINT NNTH_NTH_FK;

PROMPT Dropping Foreign Key on 'NTV_NTH_FK'
ALTER TABLE NM_THEMES_VISIBLE DROP CONSTRAINT NTV_NTH_FK;

PROMPT Dropping Foreign Key on 'NTF_FK_NTH'
ALTER TABLE NM_THEME_FUNCTIONS_ALL DROP CONSTRAINT NTF_FK_NTH;

PROMPT Dropping Foreign Key on 'NTG_NTH_FK'
ALTER TABLE NM_THEME_GTYPES DROP CONSTRAINT NTG_NTH_FK;

PROMPT Dropping Foreign Key on 'NTHR_FK_NTH'
ALTER TABLE NM_THEME_ROLES DROP CONSTRAINT NTHR_FK_NTH;

PROMPT Dropping Foreign Key on 'SST_NTH_FK'
ALTER TABLE STP_SCHEME_THEMES DROP CONSTRAINT SST_NTH_FK;



-- Drop all NM_THEMES_ALL table constraints

PROMPT Dropping Constraint on 'NTH_DEPENDENCY_CHK'
ALTER TABLE NM_THEMES_ALL DROP CONSTRAINT NTH_DEPENDENCY_CHK;

PROMPT Dropping Constraint on 'NTH_HPR_FK'
ALTER TABLE NM_THEMES_ALL DROP CONSTRAINT NTH_HPR_FK;

PROMPT Dropping Constraint on 'NTH_LOCN_UPD_YN_CHK'
ALTER TABLE NM_THEMES_ALL DROP CONSTRAINT NTH_LOCN_UPD_YN_CHK;

PROMPT Dropping Constraint on 'NTH_LREF_MAND_YN_CHK'
ALTER TABLE NM_THEMES_ALL DROP CONSTRAINT NTH_LREF_MAND_YN_CHK;

PROMPT Dropping Constraint on 'NTH_SNAP_THEME_YN_CHK'
ALTER TABLE NM_THEMES_ALL DROP CONSTRAINT NTH_SNAP_THEME_YN_CHK;

PROMPT Dropping Constraint on 'NTH_STORAGE_CHK'
ALTER TABLE NM_THEMES_ALL DROP CONSTRAINT NTH_STORAGE_CHK;

PROMPT Dropping Constraint on 'NTH_THEME_TYPE_CHK'
ALTER TABLE NM_THEMES_ALL DROP CONSTRAINT NTH_THEME_TYPE_CHK;

PROMPT Dropping Constraint on 'NTH_UK'
ALTER TABLE NM_THEMES_ALL DROP CONSTRAINT NTH_UK;

PROMPT Dropping Constraint on 'NTH_UPDATE_ON_EDIT_CHK'
ALTER TABLE NM_THEMES_ALL DROP CONSTRAINT NTH_UPDATE_ON_EDIT_CHK;

PROMPT Dropping Constraint on 'NTH_USE_HIST_YN_CHK'
ALTER TABLE NM_THEMES_ALL DROP CONSTRAINT NTH_USE_HIST_YN_CHK;

PROMPT Dropping Constraint on 'NTH_PK'
ALTER TABLE NM_THEMES_ALL DROP CONSTRAINT NTH_PK;

PROMPT Dropping Index on 'NTH_PK'
DROP INDEX NTH_PK;

PROMPT Dropping Index on 'NTH_UK'
DROP INDEX NTH_UK;

PROMPT Dropping Trigger on 'NM_THEMES_ALL_B_IU_TRG'
DROP TRIGGER NM_THEMES_ALL_B_IU_TRG;

PROMPT Dropping Trigger on 'NM_THEMES_ALL_BS_TRG'
DROP TRIGGER NM_THEMES_ALL_BS_TRG;

PROMPT Dropping Trigger on 'NM_THEMES_ALL_AS_TRG'
DROP TRIGGER NM_THEMES_ALL_AS_TRG;

PROMPT Dropping Trigger on 'NM_THEMES_ALL_AI_TRG'
DROP TRIGGER NM_THEMES_ALL_AI_TRG;

PROMPT Dropping table nm_themes_405
DROP TABLE nm_themes_405;

PROMPT Renaming 'NM_THEMES_ALL' to 'NM_THEMES_405'
RENAME nm_themes_all to nm_themes_405;

PROMPT Create table 'NM_THEMES_ALL'
CREATE TABLE NM_THEMES_ALL
 (NTH_THEME_ID NUMBER(9,0) NOT NULL
 ,NTH_THEME_NAME VARCHAR2(30) NOT NULL
 ,NTH_TABLE_NAME VARCHAR2(30) NOT NULL
 ,NTH_WHERE VARCHAR2(2000)
 ,NTH_PK_COLUMN VARCHAR2(30) NOT NULL
 ,NTH_LABEL_COLUMN VARCHAR2(30) NOT NULL
 ,NTH_RSE_TABLE_NAME VARCHAR2(30)
 ,NTH_RSE_FK_COLUMN VARCHAR2(30)
 ,NTH_ST_CHAIN_COLUMN VARCHAR2(30)
 ,NTH_END_CHAIN_COLUMN VARCHAR2(30)
 ,NTH_X_COLUMN VARCHAR2(30)
 ,NTH_Y_COLUMN VARCHAR2(30)
 ,NTH_OFFSET_FIELD VARCHAR2(30)
 ,NTH_FEATURE_TABLE VARCHAR2(30)
 ,NTH_FEATURE_PK_COLUMN VARCHAR2(30)
 ,NTH_FEATURE_FK_COLUMN VARCHAR2(30)
 ,NTH_XSP_COLUMN VARCHAR2(30)
 ,NTH_FEATURE_SHAPE_COLUMN VARCHAR2(30) DEFAULT 'SHAPE'
 ,NTH_HPR_PRODUCT VARCHAR2(6) DEFAULT 'NET' NOT NULL
 ,NTH_LOCATION_UPDATABLE VARCHAR2(1) DEFAULT 'N' NOT NULL
 ,NTH_THEME_TYPE VARCHAR2(4) DEFAULT 'LOCL'
 ,NTH_DEPENDENCY VARCHAR2(1) DEFAULT 'D' NOT NULL
 ,NTH_STORAGE VARCHAR2(1) DEFAULT 'D' NOT NULL
 ,NTH_UPDATE_ON_EDIT VARCHAR2(1) DEFAULT 'N' NOT NULL
 ,NTH_USE_HISTORY VARCHAR2(1) DEFAULT 'N' NOT NULL
 ,NTH_START_DATE_COLUMN VARCHAR2(30)
 ,NTH_END_DATE_COLUMN VARCHAR2(30)
 ,NTH_BASE_TABLE_THEME NUMBER(9)
 ,NTH_SEQUENCE_NAME VARCHAR2(30)
 ,NTH_SNAP_TO_THEME VARCHAR2(1) DEFAULT 'N' NOT NULL
 ,NTH_LREF_MANDATORY VARCHAR2(1) DEFAULT 'N' NOT NULL
 ,NTH_TOLERANCE NUMBER DEFAULT 10 NOT NULL
 ,NTH_TOL_UNITS NUMBER(4) DEFAULT 1 NOT NULL
 ,NTH_DYNAMIC_THEME VARCHAR2(1) DEFAULT 'N' NOT NULL
 )
/

PROMPT Add table comments

COMMENT ON COLUMN NM_THEMES_ALL.NTH_USE_HISTORY IS 'Flag to indicate if the spatial data supports history.';

COMMENT ON COLUMN NM_THEMES_ALL.NTH_START_DATE_COLUMN IS 'Column that holds start date, if history is used.';

COMMENT ON COLUMN NM_THEMES_ALL.NTH_END_DATE_COLUMN IS 'Column that holds end date, if history is used.';

COMMENT ON COLUMN NM_THEMES_ALL.NTH_BASE_TABLE_THEME IS 'Name of the table that holds the true spatial data.';

COMMENT ON COLUMN NM_THEMES_ALL.NTH_SEQUENCE_NAME IS 'Name of database sequence used to derive shape primary key.';

COMMENT ON COLUMN NM_THEMES_ALL.NTH_SNAP_TO_THEME IS 'Flag to denote whether snapping is appropriate.';

COMMENT ON COLUMN NM_THEMES_ALL.NTH_LREF_MANDATORY IS 'Flag to denote if theme is to be snapped to linear layer.';

COMMENT ON COLUMN NM_THEMES_ALL.NTH_TOLERANCE IS 'Snapping tolerance value.';

COMMENT ON COLUMN NM_THEMES_ALL.NTH_TOL_UNITS IS 'Unit of tolerance, unit must be translatable to spatial units.';


PROMPT Create constraint 'NTH_DEPENDENCY_CHK'
ALTER TABLE NM_THEMES_ALL ADD (
  CONSTRAINT NTH_DEPENDENCY_CHK
 CHECK (nth_dependency IN ('D','I')));

PROMPT Create constraint 'NTH_HPR_FK'
ALTER TABLE NM_THEMES_ALL ADD (
  CONSTRAINT NTH_HPR_FK 
 FOREIGN KEY (NTH_HPR_PRODUCT) 
 REFERENCES HIG_PRODUCTS (HPR_PRODUCT));

PROMPT Create constraint 'NTH_LOCN_UPD_YN_CHK'
ALTER TABLE NM_THEMES_ALL ADD (
  CONSTRAINT NTH_LOCN_UPD_YN_CHK
 CHECK (nth_location_updatable IN ('Y','N')));

PROMPT Create constraint 'NTH_LREF_MAND_YN_CHK' 
ALTER TABLE NM_THEMES_ALL ADD (
  CONSTRAINT NTH_LREF_MAND_YN_CHK
 CHECK (nth_lref_mandatory IN ('Y','N')));

PROMPT Create constraint 'NTH_PK'
ALTER TABLE NM_THEMES_ALL ADD (
  CONSTRAINT NTH_PK
 PRIMARY KEY
 (NTH_THEME_ID));

PROMPT Create constraint 'NTH_SNAP_THEME_YN_CHK'
ALTER TABLE NM_THEMES_ALL ADD (
  CONSTRAINT NTH_SNAP_THEME_YN_CHK
 CHECK (nth_snap_to_theme IN ('N','S','A')));

PROMPT Create constraint 'NTH_STORAGE_CHK' 
ALTER TABLE NM_THEMES_ALL ADD (
  CONSTRAINT NTH_STORAGE_CHK
 CHECK (nth_storage IN ('S','D')));

PROMPT Create constraint 'NTH_THEME_TYPE_CHK'
ALTER TABLE NM_THEMES_ALL ADD (
  CONSTRAINT NTH_THEME_TYPE_CHK
 CHECK (nth_theme_type IN ('SDO','SDE','LOCL')));

PROMPT Create constraint 'NTH_UK'
ALTER TABLE NM_THEMES_ALL ADD (
  CONSTRAINT NTH_UK
 UNIQUE (NTH_THEME_NAME));
 
PROMPT Create constraint 'NTH_UPDATE_ON_EDIT_CHK'
ALTER TABLE NM_THEMES_ALL ADD (
  CONSTRAINT NTH_UPDATE_ON_EDIT_CHK
 CHECK (nth_update_on_edit IN ('D','I','N')));

PROMPT Create constraint 'NTH_USE_HIST_YN_CHK'
ALTER TABLE NM_THEMES_ALL ADD (
  CONSTRAINT NTH_USE_HIST_YN_CHK
 CHECK (nth_use_history IN ('Y','N')));

PROMPT Repopulate 'NM_THEMES_ALL' table from backup
BEGIN
  FOR i IN (SELECT nth_theme_id, nth_theme_name, nth_table_name, nth_where
                 , nth_pk_column, nth_label_column, nth_rse_table_name
                 , nth_rse_fk_column, nth_st_chain_column, nth_end_chain_column
                 , nth_x_column, nth_y_column, nth_offset_field
                 , nth_feature_table, nth_feature_pk_column
                 , nth_feature_fk_column, nth_xsp_column
                 , nth_feature_shape_column, nth_hpr_product
                 , nth_location_updatable, nth_theme_type
                 , nth_dependency, nth_storage, nth_update_on_edit
                 , nth_use_history, nth_start_date_column
                 , nth_end_date_column, nth_base_table_theme
                 , nth_sequence_name, nth_snap_to_theme
                 , nth_lref_mandatory, nth_tolerance
                 , nth_tol_units, nth_dynamic_theme
              FROM nm_themes_405 )
  LOOP
    INSERT INTO nm_themes_all
      (nth_theme_id, nth_theme_name, nth_table_name, nth_where
     , nth_pk_column, nth_label_column, nth_rse_table_name
     , nth_rse_fk_column, nth_st_chain_column, nth_end_chain_column
     , nth_x_column, nth_y_column, nth_offset_field
     , nth_feature_table, nth_feature_pk_column
     , nth_feature_fk_column, nth_xsp_column
     , nth_feature_shape_column, nth_hpr_product
     , nth_location_updatable, nth_theme_type
     , nth_dependency, nth_storage, nth_update_on_edit
     , nth_use_history, nth_start_date_column
     , nth_end_date_column, nth_base_table_theme
     , nth_sequence_name, nth_snap_to_theme
     , nth_lref_mandatory, nth_tolerance
     , nth_tol_units, nth_dynamic_theme )
    VALUES (i.nth_theme_id, i.nth_theme_name, i.nth_table_name, i.nth_where
         , i.nth_pk_column, i.nth_label_column, i.nth_rse_table_name
         , i.nth_rse_fk_column, i.nth_st_chain_column, i.nth_end_chain_column
         , i.nth_x_column, i.nth_y_column, i.nth_offset_field
         , i.nth_feature_table, i.nth_feature_pk_column
         , i.nth_feature_fk_column, i.nth_xsp_column
         , i.nth_feature_shape_column, i.nth_hpr_product
         , i.nth_location_updatable, i.nth_theme_type
         , i.nth_dependency, i.nth_storage, i.nth_update_on_edit
         , i.nth_use_history, i.nth_start_date_column
         , i.nth_end_date_column, i.nth_base_table_theme
         , i.nth_sequence_name, i.nth_snap_to_theme
         , i.nth_lref_mandatory, i.nth_tolerance
         , i.nth_tol_units, i.nth_dynamic_theme);
  END LOOP;
END;
/

COMMIT;

-- Create FKs

PROMPT Creating Foreign Key on 'NM_AREA_THEMES'
ALTER TABLE NM_AREA_THEMES ADD (CONSTRAINT
 NATH_FK_NTH FOREIGN KEY 
  (NATH_NTH_THEME_ID) REFERENCES NM_THEMES_ALL
  (NTH_THEME_ID) ON DELETE CASCADE)
/

PROMPT Creating Foreign Key on 'NM_BASE_THEMES'
ALTER TABLE NM_BASE_THEMES ADD (CONSTRAINT
 NBTH_NTH_FK FOREIGN KEY 
  (NBTH_THEME_ID) REFERENCES NM_THEMES_ALL
  (NTH_THEME_ID) ON DELETE CASCADE)
/

PROMPT Creating Foreign Key on 'NM_BASE_THEMES'
ALTER TABLE NM_BASE_THEMES ADD (CONSTRAINT
 NBTH_BASE_FK FOREIGN KEY 
  (NBTH_BASE_THEME) REFERENCES NM_THEMES_ALL
  (NTH_THEME_ID) ON DELETE CASCADE)
/

PROMPT Creating Foreign Key on 'NM_INV_THEMES'
ALTER TABLE NM_INV_THEMES ADD (CONSTRAINT
 NITH_NTH_FK FOREIGN KEY 
  (NITH_NTH_THEME_ID) REFERENCES NM_THEMES_ALL
  (NTH_THEME_ID) ON DELETE CASCADE)
/

PROMPT Creating Foreign Key on 'NM_NW_THEMES'
ALTER TABLE NM_NW_THEMES ADD (CONSTRAINT
 NNTH_NTH_FK FOREIGN KEY 
  (NNTH_NTH_THEME_ID) REFERENCES NM_THEMES_ALL
  (NTH_THEME_ID) ON DELETE CASCADE)
/

PROMPT Creating Foreign Key on 'NM_THEMES_VISIBLE'
ALTER TABLE NM_THEMES_VISIBLE ADD (CONSTRAINT
 NTV_NTH_FK FOREIGN KEY 
  (NTV_NTH_THEME_ID) REFERENCES NM_THEMES_ALL
  (NTH_THEME_ID) ON DELETE CASCADE)
/

PROMPT Creating Foreign Key on 'NM_THEME_FUNCTIONS_ALL'
ALTER TABLE NM_THEME_FUNCTIONS_ALL ADD (CONSTRAINT
 NTF_FK_NTH FOREIGN KEY 
  (NTF_NTH_THEME_ID) REFERENCES NM_THEMES_ALL
  (NTH_THEME_ID) ON DELETE CASCADE)
/

PROMPT Creating Foreign Key on 'NM_THEME_GTYPES'
ALTER TABLE NM_THEME_GTYPES ADD (CONSTRAINT
 NTG_NTH_FK FOREIGN KEY 
  (NTG_THEME_ID) REFERENCES NM_THEMES_ALL
  (NTH_THEME_ID) ON DELETE CASCADE)
/

PROMPT Creating Foreign Key on 'NM_THEME_ROLES'
ALTER TABLE NM_THEME_ROLES ADD (CONSTRAINT
 NTHR_FK_NTH FOREIGN KEY 
  (NTHR_THEME_ID) REFERENCES NM_THEMES_ALL
  (NTH_THEME_ID) ON DELETE CASCADE)
/

PROMPT Creating Foreign Key on 'STP_SCHEME_THEMES'
ALTER TABLE STP_SCHEME_THEMES ADD (CONSTRAINT
 SST_NTH_FK FOREIGN KEY
 (SST_NTH_THEME_ID) REFERENCES NM_THEMES_ALL
 (NTH_THEME_ID) ON DELETE CASCADE)
/


PROMPT Creating Trigger 'NM_THEMES_ALL_B_IU_TRG'
CREATE OR REPLACE TRIGGER nm_themes_all_b_iu_trg
   BEFORE INSERT OR UPDATE OR DELETE
   ON NM_THEMES_ALL    FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm4046_nm4050_ddl_upg.sql-arc   3.7   Jul 04 2013 14:10:28   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4046_nm4050_ddl_upg.sql  $
--       Date into SCCS   : $Date:   Jul 04 2013 14:10:28  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:53:50  $
--       SCCS Version     : $Revision:   3.7  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
  c_str      nm3type.max_varchar2;
  l_mode     VARCHAR2(10);
--
BEGIN
--
   IF DELETING THEN
     IF :OLD.nth_theme_type = nm3sdo.c_sdo
      THEN
       c_str := 'begin '||
                  'nm3sdo.drop_sub_layer_by_table( '||
                     nm3flx.string(:old.nth_feature_table)||','||
                     nm3flx.string(:old.nth_feature_shape_column)||');'
             ||' end;';
       EXECUTE IMMEDIATE c_str;
     END IF;
   END IF;
--
EXCEPTION
   WHEN OTHERS THEN
      RAISE;
--
END nm_themes_all_b_iu_trg;
/

PROMPT Creating Trigger 'NM_THEMES_ALL_BS_TRG'
CREATE OR REPLACE TRIGGER NM_THEMES_ALL_BS_TRG
BEFORE DELETE
ON NM_THEMES_ALL REFERENCING NEW AS NEW OLD AS OLD
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_themes_all_bs_trg.trg	1.2 08/02/05
--       Module Name      : nm_themes_all_bs_trg.trg
--       Date into SCCS   : 05/08/02 09:59:55
--       Date fetched Out : 07/06/13 17:03:37
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--  Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved
-----------------------------------------------------------------------------
BEGIN
   Nm3sdm.g_del_theme := TRUE;
END NM_THEMES_ALL_BS_TRG;
/

PROMPT Creating Trigger 'NM_THEMES_ALL_AS_TRG'
CREATE OR REPLACE TRIGGER NM_THEMES_ALL_AS_TRG
AFTER DELETE
ON NM_THEMES_ALL REFERENCING NEW AS NEW OLD AS OLD
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_themes_all_as_trg.trg	1.2 08/02/05
--       Module Name      : nm_themes_all_as_trg.trg
--       Date into SCCS   : 05/08/02 09:59:20
--       Date fetched Out : 07/06/13 17:03:36
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--  Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved
-----------------------------------------------------------------------------
BEGIN
   Nm3sdm.g_del_theme := FALSE;
END NM_THEMES_ALL_AS_TRG;
/

PROMPT Creating Trigger 'NM_THEMES_ALL_AI_TRG'
CREATE OR REPLACE TRIGGER NM_THEMES_ALL_AI_TRG
AFTER INSERT
ON NM_THEMES_ALL REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
-- PVCS Identifiers :-
--
-- pvcsid : $Header:   //vm_latest/archives/nm3/install/nm4046_nm4050_ddl_upg.sql-arc   3.7   Jul 04 2013 14:10:28   James.Wadsworth  $
-- Module Name : $Workfile:   nm4046_nm4050_ddl_upg.sql  $
-- Date into PVCS : $Date:   Jul 04 2013 14:10:28  $
-- Date fetched Out : $Modtime:   Jul 04 2013 13:53:50  $
-- PVCS Version : $Revision:   3.7  $
-- Based on SCCS version :
-----------------------------------------------------------------------------
--  Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved
-----------------------------------------------------------------------------
BEGIN
  IF INSERTING
  THEN
    nm3sdm.maintain_ntv (:NEW.nth_theme_id,'INSERTING');
  END IF;
END NM_THEMES_ALL_AI_TRG;
/



------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT FBI to police Admin Unit relationships
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Create FBI on NM_ADMIN_GROUPS to prevent multiple parent relationships
-- 
------------------------------------------------------------------

PROMPT Create FBI on NM_ADMIN_GROUPS to prevent multiple parent relationships

BEGIN
  EXECUTE IMMEDIATE
    'CREATE UNIQUE INDEX nag_single_parent_idx ON nm_admin_groups '||
     ' ( TO_CHAR(nag_child_admin_unit)||''|''||CASE nag_direct_link '||
      '    WHEN ''N'' THEN CASE nag_child_admin_unit '||
                      ' WHEN nag_parent_admin_unit THEN NULL '||
                      ' ELSE TO_CHAR(nag_parent_admin_unit) END '||
          ' WHEN ''Y'' THEN TO_CHAR(nag_child_admin_unit) END '||
         ' ) ';
EXCEPTION
  WHEN OTHERS
  THEN
    dbms_output.put_line('Create FBI on NM_ADMIN_GROUPS to prevent multiple parent relationships');
    dbms_output.put_line ('Error occured - '||SQLERRM);
    dbms_output.put_line ('Please contact Exor Support');
END;
/
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

