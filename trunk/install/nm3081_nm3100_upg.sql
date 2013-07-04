REM Copyright 2013 Bentley Systems Incorporated. All rights reserved.
REM @(#)nm3081_nm3100_upg.sql	1.27 01/08/04
--
spool nm3100_upg.LOG
--
--get some db info

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ( 'HIG','NET');
--
WHENEVER SQLERROR EXIT
begin
   hig2.pre_upgrade_check (p_product               => 'HIG'
                          ,p_new_version           => '3.1.0.0'
                          ,p_allowed_old_version_1 => '3.0.8.1'
                          ,p_allowed_old_version_2 => '3.0.8.2'
                          );
END;
/
WHENEVER SQLERROR CONTINUE
--
-- drop any policies that could be effected by table changes
-- ensure that later on - after a compile schema these policies are re-created
--
PROMPT Dropping Policies
SET feedback OFF
SET define ON
SET VERIFY OFF
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'ctx'||'&terminator'||'drop_policy' run_file
FROM dual
/
START '&&run_file'
SET feedback ON
--
---------------------------------------------------------------------------------------------------
--
--            **************** PUT TABLE UPGRADES HERE *******************
--
---------------------------------------------------------------------------------------------------
--
ALTER TABLE nm_type_inclusion ADD (
  CONSTRAINT nti_parent_type_uk UNIQUE (nti_nw_parent_type));

---------------------------------------------------------------------------------------------------
--Start of spatial upgrades
---------------------------------------------------------------------------------------------------
-- create the product option
set termout on
set feedback on

PROMPT Creating NM_THEMES_ALL table

-- Modify the Themes and layers etc:

CREATE TABLE NM_THEMES_ALL
 (NTH_THEME_ID NUMBER(9,0) NOT NULL
 ,NTH_THEME_NAME VARCHAR2(30) NOT NULL
 ,NTH_TABLE_NAME VARCHAR2(30) NOT NULL
 ,NTH_WHERE VARCHAR2(2000)
 ,NTH_PK_COLUMN VARCHAR2(30) NOT NULL
 ,NTH_LABEL_COLUMN VARCHAR2(30) NOT NULL
 ,NTH_RSE_TABLE_NAME VARCHAR2(30) NOT NULL
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
 ,NTH_BASE_THEME NUMBER
 ,NTH_DEPENDENCY VARCHAR2(1) DEFAULT 'D' NOT NULL
 ,NTH_STORAGE VARCHAR2(1) DEFAULT 'D' NOT NULL
 ,NTH_UPDATE_ON_EDIT VARCHAR2(1) DEFAULT 'N' NOT NULL
 )
/

COMMENT ON TABLE NM_THEMES_ALL IS 'The themes which may be available to the GIS user and how they relate to Highways data';

PROMPT Creating Primary Key on 'NM_THEMES_ALL'
ALTER TABLE NM_THEMES_ALL
 ADD CONSTRAINT NTH_PK PRIMARY KEY 
  (NTH_THEME_ID)
/


PROMPT Creating Unique Keys on 'NM_THEMES_ALL'
ALTER TABLE NM_THEMES_ALL 
 ADD ( CONSTRAINT NTH_UK UNIQUE 
  (NTH_THEME_NAME))
/

PROMPT Creating Check Constraints on 'NM_THEMES_ALL'
ALTER TABLE NM_THEMES_ALL
 ADD CONSTRAINT NTH_LOCATION_UPDATABLE_CHK CHECK (nth_location_updatable IN ('Y','N'))
 ADD CONSTRAINT NTH_THEME_TYPE_CHK CHECK (nth_theme_type IN ('SDO','SDE','LOCL'))
 ADD CONSTRAINT NTH_DEPENDENCY_CHK CHECK (nth_dependency IN ('D','I'))
 ADD CONSTRAINT NTH_STORAGE_CHK CHECK (nth_storage IN ('S','D'))
 ADD CONSTRAINT NTH_UPDATE_ON_EDIT_CHK CHECK (nth_update_on_edit IN ('D','I','N'))
/
   

PROMPT Creating Trigger NM_THEMES_ALL_B_IU_TRG on 'NM_THEMES_ALL'
CREATE OR REPLACE TRIGGER NM_THEMES_ALL_B_IU_TRG
   BEFORE INSERT OR UPDATE
   ON NM_THEMES_ALL
   FOR EACH ROW
DECLARE
--
--
BEGIN
--
   IF   :NEW.nth_location_updatable                                 = 'Y'
    AND higgis.is_product_locatable_from_gis(:NEW.nth_hpr_product) != 'Y'
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 152
                    ,pi_supplementary_info => :NEW.nth_hpr_product
                    );
   END IF;
--
END nm_themes_all_b_iu_trg;
/

PROMPT Creating Foreign Keys on 'NM_THEMES_ALL'
ALTER TABLE NM_THEMES_ALL ADD CONSTRAINT
 NTH_FK_NTH FOREIGN KEY 
  (NTH_BASE_THEME) REFERENCES NM_THEMES_ALL
  (NTH_THEME_ID) ADD CONSTRAINT
 NTH_HPR_FK FOREIGN KEY 
  (NTH_HPR_PRODUCT) REFERENCES HIG_PRODUCTS
  (HPR_PRODUCT)
/


PROMPT Creating New themes table data from old GIS_THEMES_ALL table
INSERT INTO NM_THEMES_ALL (
   NTH_THEME_ID, 
   NTH_THEME_NAME, 
   NTH_TABLE_NAME,    
   NTH_WHERE, 
   NTH_PK_COLUMN, 
   NTH_LABEL_COLUMN, 
   NTH_RSE_TABLE_NAME, 
   NTH_RSE_FK_COLUMN, 
   NTH_ST_CHAIN_COLUMN, 
   NTH_END_CHAIN_COLUMN, 
   NTH_X_COLUMN, 
   NTH_Y_COLUMN, 
   NTH_OFFSET_FIELD, 
   NTH_FEATURE_TABLE, 
   NTH_FEATURE_PK_COLUMN, 
   NTH_FEATURE_FK_COLUMN, 
   NTH_XSP_COLUMN, 
   NTH_FEATURE_SHAPE_COLUMN, 
   NTH_HPR_PRODUCT, 
   NTH_LOCATION_UPDATABLE, 
   NTH_THEME_TYPE, 
   NTH_BASE_THEME, 
   NTH_DEPENDENCY, 
   NTH_STORAGE, 
   NTH_UPDATE_ON_EDIT
)
select 
GT_THEME_ID,
GT_THEME_NAME,
GT_TABLE_NAME,
GT_WHERE,
GT_PK_COLUMN,
GT_LABEL_COLUMN,
GT_RSE_TABLE_NAME,
GT_RSE_FK_COLUMN,
GT_ST_CHAIN_COLUMN,
GT_END_CHAIN_COLUMN,
GT_X_COLUMN,
GT_Y_COLUMN,
GT_OFFSET_FIELD,
GT_FEATURE_TABLE,
GT_FEATURE_PK_COLUMN,
GT_FEATURE_FK_COLUMN,
GT_XSP_COLUMN,
GT_FEATURE_SHAPE_COLUMN,
GT_HPR_PRODUCT,
GT_LOCATION_UPDATABLE,
decode( gt_route_theme, 'Y', 'SDE', decode( gt_feature_table, null, 'LOCL', 'SDE')),
decode( gt_route_theme, 'Y', NULL),
decode( gt_route_theme, 'Y', 'I', 'D'),
decode( gt_route_theme, 'Y', 'S', 'D'),
'N'
from gis_themes_all
/

PROMPT Drop old sequence GT_THEME_ID

drop sequence gt_theme_id
/

PROMPT Create new sequence for the NM_THEMES_ALL PK

declare
  max_gt_id number;
begin
    select max( nth_theme_id ) 
    into max_gt_id
    from nm_themes_all;
    
    execute immediate 'create sequence nth_theme_id_seq start with '||to_char((nvl(max_gt_id,1)));

end;
/    

PROMPT Revision to Linear types view - used to populate new table then obsolete

CREATE TABLE NM_LINEAR_TYPES
 (NLT_ID NUMBER
 ,NLT_NT_TYPE VARCHAR2(4) NOT NULL
 ,NLT_GTY_TYPE VARCHAR2(4)
 ,NLT_DESCR VARCHAR2(80)
 ,NLT_SEQ_NO NUMBER
 ,NLT_UNITS NUMBER NOT NULL
 ,NLT_START_DATE DATE NOT NULL
 ,NLT_END_DATE DATE
 ,NLT_ADMIN_TYPE VARCHAR2(4) NOT NULL
 ,NLT_G_I_D CHAR(1) NOT NULL
 )
/

insert into nm_linear_types
  ( nlt_nt_type,
    nlt_gty_type,
    nlt_descr,
    nlt_seq_no,
    nlt_units,
    nlt_start_date,
    nlt_admin_type,
    nlt_G_I_D )
select nt_type
      ,ngt_group_type
      ,ngt_descr
      ,ngt_search_group_no
      ,nt_length_unit
      ,ngt_start_date
      ,nt_admin_type
      ,'G'
 FROM  nm_group_types
      ,nm_types
WHERE  ngt_nt_type           = nt_type
 AND   nt_linear             = 'Y'
 AND   ngt_sub_group_allowed = 'N'
UNION ALL
SELECT nin_nw_type
      ,nit_inv_type
      ,nit_descr
      ,nit_screen_seq
      ,1
      ,nit_start_date
      ,nit_admin_type
      ,'I'
 FROM  nm_inv_types, nm_inv_nw
WHERE  nit_pnt_or_cont = 'C'
 AND   nit_linear      = 'Y'
 AND   nin_nit_inv_code = nit_inv_type
union all
select nt_type
      ,null
      ,nt_descr
      ,1
      ,nt_length_unit
      ,min(nau_start_date) 
      ,nt_admin_type
      ,'D'
from nm_types, nm_admin_units
where nt_datum = 'Y'
and nt_admin_type = nau_ADMIN_TYPE
group by nt_type, nt_descr, nt_length_unit, nt_admin_type
/

create sequence nlt_id_seq;

update nm_linear_types
set nlt_id = nlt_id_seq.nextval;

commit;

alter table nm_linear_types
modify (nlt_id not null);

PROMPT Creating Primary Key on 'NM_LINEAR_TYPES'
ALTER TABLE NM_LINEAR_TYPES
 ADD CONSTRAINT NLT_PK PRIMARY KEY 
  (NLT_ID)
/

PROMPT Creating Unique Keys on 'NM_LINEAR_TYPES'
ALTER TABLE NM_LINEAR_TYPES 
 ADD ( CONSTRAINT NLT_UK UNIQUE 
  (NLT_NT_TYPE
  ,NLT_GTY_TYPE))
/

PROMPT Creating Foreign Keys on 'NM_LINEAR_TYPES'
ALTER TABLE NM_LINEAR_TYPES ADD CONSTRAINT
 NLT_FK_GTY FOREIGN KEY 
  (NLT_GTY_TYPE) REFERENCES NM_GROUP_TYPES_ALL
  (NGT_GROUP_TYPE) ON DELETE CASCADE ADD CONSTRAINT
 NLT_FK_NT FOREIGN KEY 
  (NLT_NT_TYPE) REFERENCES NM_TYPES
  (NT_TYPE) ON DELETE CASCADE
/

PROMPT Creating Index 'NLT_FK_GTY_IND'
CREATE INDEX NLT_FK_GTY_IND ON NM_LINEAR_TYPES
 (NLT_GTY_TYPE)
/

PROMPT Creating Index 'NLT_FK_NT_IND'
CREATE INDEX NLT_FK_NT_IND ON NM_LINEAR_TYPES
 (NLT_NT_TYPE)
/

  
PROMPT Creating Link table between linear objects and themes


PROMPT Creating Table 'NM_NW_THEMES'
CREATE TABLE NM_NW_THEMES
 (NNTH_NLT_ID NUMBER NOT NULL
 ,NNTH_NTH_THEME_ID NUMBER NOT NULL
 )
/

PROMPT Creating Primary Key on 'NM_NW_THEMES'
ALTER TABLE NM_NW_THEMES
 ADD CONSTRAINT NNTH_PK PRIMARY KEY 
  (NNTH_NLT_ID
  ,NNTH_NTH_THEME_ID)
/


PROMPT Creating Foreign Keys on 'NM_NW_THEMES'
ALTER TABLE NM_NW_THEMES ADD CONSTRAINT
 NNTH_NTH_FK FOREIGN KEY 
  (NNTH_NTH_THEME_ID) REFERENCES NM_THEMES_ALL
  (NTH_THEME_ID) ON DELETE CASCADE ADD CONSTRAINT
 NNTH_FK_NLT FOREIGN KEY 
  (NNTH_NLT_ID) REFERENCES NM_LINEAR_TYPES
  (NLT_ID) ON DELETE CASCADE
/

PROMPT Creating Index 'NNTH_FK_NLT_IND'
CREATE INDEX NNTH_FK_NLT_IND ON NM_NW_THEMES
 (NNTH_NLT_ID)
/

PROMPT Creating Index 'NNTH_NTH_FK_IND'
CREATE INDEX NNTH_NTH_FK_IND ON NM_NW_THEMES
 (NNTH_NTH_THEME_ID)
/


PROMPT Use the old GIS_THEMES_ALL table to construct at least one NW theme

insert into nm_nw_themes
( nnth_nlt_id, nnth_nth_theme_id )
select nlt_id, gt_theme_id
from gis_themes_all, nm_linear_types
where nlt_G_I_D = 'D'
and   gt_route_theme = 'Y'
/


rename NM_LAYERS to NM_LAYERS_SAVED;

CREATE OR REPLACE FORCE VIEW NM_LAYERS
(NL_LAYER_NAME, NL_LAYER_DESCR, NL_LAYER_ID, NL_TABLE_NAME, NL_COLUMN_NAME, 
 NL_GTYPE, NL_SRS_TYPE)
AS 
select
  nth_theme_name,
  nth_theme_name,
  nth_theme_id,
  nth_feature_table,
  nth_feature_pk_column,
  '3002',
  srid
from user_sdo_geom_metadata, nm_themes_all, nm_nw_themes
where table_name = nth_feature_table
and nth_theme_id = nnth_nth_theme_id
/

---------------------------------------------------------------------------------
-- A.E. 18-June-2003
---------------------------------------------------------------------------------
-- Leave this out at this stage
---------------------------------------------------------------------------------
--update nm_themes_all
--set nth_feature_table = replace( replace( nth_feature_table, user, ''), '.','')
--where nth_feature_table is not null
--/
---------------------------------------------------------------------------------



prompt Create the NM_POINT_LOCATIONS data - Note that this relies on an existing theme to populate the values


drop table nm_point_locations
/

create table nm_point_locations
( npl_id number(38) not null,
  npl_location mdsys.sdo_geometry not null )
/

alter table nm_point_locations
  add constraint npl_pk primary key ( npl_id )
/

Prompt Create a table to handle the many inventory layers that may be generated as themes

CREATE TABLE NM_INV_THEMES ( 
  NITH_NIT_ID        VARCHAR2 (4)  NOT NULL, 
  NITH_NTH_THEME_ID  NUMBER (9)    NOT NULL, 
  CONSTRAINT NITH_PK
  PRIMARY KEY ( NITH_NTH_THEME_ID, NITH_NIT_ID ) 
    USING INDEX )
/    

CREATE INDEX NITH_FK_NIT_IND ON NM_INV_THEMES
 (NITH_NIT_ID)
/

CREATE INDEX NITH_NTH_FK_IND ON NM_INV_THEMES
 (NITH_NTH_THEME_ID)
/

ALTER TABLE NM_INV_THEMES ADD  CONSTRAINT NITH_FK_NIT
 FOREIGN KEY (NITH_NIT_ID) 
  REFERENCES NM_INV_TYPES_ALL (NIT_INV_TYPE) ON DELETE CASCADE;

ALTER TABLE NM_INV_THEMES ADD  CONSTRAINT NITH_NTH_FK
 FOREIGN KEY (NITH_NTH_THEME_ID) 
  REFERENCES NM_THEMES_ALL (NTH_THEME_ID) ON DELETE CASCADE;

prompt Create a temporary table to handle the end-date logic.

CREATE global temporary TABLE NM_SDO_TRG_MEMBERS
 (
   NSTM_ID         NUMBER(9),
   NSTM_NE_ID_IN   NUMBER(9),
   NSTM_NE_ID_OF   NUMBER(9),
   NSTM_TYPE       VARCHAR2(1),
   NSTM_OBJ_TYPE   VARCHAR2(4),
   NSTM_ROWID      ROWID,
   NSTM_OPERATION  VARCHAR2(1)
 )
/
 

PROMPT Creating Table 'NM_THEME_FUNCTIONS_ALL'
CREATE TABLE NM_THEME_FUNCTIONS_ALL
 (NTF_NTH_THEME_ID NUMBER(9,0) NOT NULL
 ,NTF_HMO_MODULE VARCHAR2(30) NOT NULL
 ,NTF_PARAMETER VARCHAR2(30) NOT NULL
 ,NTF_MENU_OPTION VARCHAR2(70) NOT NULL
 ,NTF_SEEN_IN_GIS VARCHAR2(1) DEFAULT 'Y' NOT NULL
 )
/

PROMPT Creating Table 'NM_THEME_ROLES'
CREATE TABLE NM_THEME_ROLES
 (NTHR_THEME_ID NUMBER(9,0) NOT NULL
 ,NTHR_ROLE VARCHAR2(30) NOT NULL
 ,NTHR_MODE VARCHAR2(10) NOT NULL
 )
/


PROMPT Creating Primary Key on 'NM_THEME_FUNCTIONS_ALL'
ALTER TABLE NM_THEME_FUNCTIONS_ALL
 ADD CONSTRAINT NTF_PK PRIMARY KEY 
  (NTF_NTH_THEME_ID
  ,NTF_HMO_MODULE
  ,NTF_PARAMETER)
/

PROMPT Creating Primary Key on 'NM_THEME_ROLES'
ALTER TABLE NM_THEME_ROLES
 ADD CONSTRAINT NTHR_PK PRIMARY KEY 
  (NTHR_ROLE
  ,NTHR_THEME_ID)
/

PROMPT Creating Index 'NTHR_FK_HRO_IND'
CREATE INDEX NTHR_FK_HRO_IND ON NM_THEME_ROLES
 (NTHR_ROLE)
 INITRANS 2
 MAXTRANS 255
 PCTFREE 10
 STORAGE
 (
 INITIAL 65536
 MINEXTENTS 1
 MAXEXTENTS 2147483645
 )
/

PROMPT Creating Index 'NTHR_FK_NTH_IND'
CREATE INDEX NTHR_FK_NTH_IND ON NM_THEME_ROLES
 (NTHR_THEME_ID)
 INITRANS 2
 MAXTRANS 255
 PCTFREE 10
 STORAGE
 (
 INITIAL 65536
 MINEXTENTS 1
 MAXEXTENTS 2147483645
 )
/


PROMPT Creating Check Constraints on 'NM_THEME_FUNCTIONS_ALL'
ALTER TABLE NM_THEME_FUNCTIONS_ALL
 ADD CONSTRAINT NTF_SEEN_IN_GIS_CHK CHECK (NTF_SEEN_IN_GIS IN ('N', 'Y'))
/

PROMPT Creating Check Constraints on 'NM_THEME_ROLES'
ALTER TABLE NM_THEME_ROLES
 ADD CONSTRAINT NTHR_MODE_CHK CHECK (nthr_mode in ('NORMAL','READONLY'))
/
 
PROMPT Creating Foreign Keys on 'NM_THEME_FUNCTIONS_ALL'
ALTER TABLE NM_THEME_FUNCTIONS_ALL ADD CONSTRAINT
 NTF_FK_NTH FOREIGN KEY 
  (NTF_NTH_THEME_ID) REFERENCES NM_THEMES_ALL
  (NTH_THEME_ID) ON DELETE CASCADE ADD CONSTRAINT
 NTF_FK_HMO FOREIGN KEY 
  (NTF_HMO_MODULE) REFERENCES HIG_MODULES
  (HMO_MODULE) ON DELETE CASCADE
/

PROMPT Creating Index 'NTF_FK_NT_IND'
CREATE INDEX NTF_FK_NT_IND ON NM_THEME_FUNCTIONS_ALL
 (NTF_NTH_THEME_ID)
 INITRANS 2
 MAXTRANS 255
 PCTFREE 10
 STORAGE
 (
 INITIAL 65536
 MINEXTENTS 1
 MAXEXTENTS 2147483645
 )
/

PROMPT Creating Index 'NTF_FK_HMO_IND'
CREATE INDEX NTF_FK_HMO_IND ON NM_THEME_FUNCTIONS_ALL
 (NTF_HMO_MODULE)
 INITRANS 2
 MAXTRANS 255
 PCTFREE 10
 STORAGE
 (
 INITIAL 65536
 MINEXTENTS 1
 MAXEXTENTS 2147483645
 )
/

PROMPT Creating Foreign Keys on 'NM_THEME_ROLES'
ALTER TABLE NM_THEME_ROLES ADD CONSTRAINT
 NTHR_FK_NTH FOREIGN KEY 
  (NTHR_THEME_ID) REFERENCES NM_THEMES_ALL
  (NTH_THEME_ID) ON DELETE CASCADE ADD CONSTRAINT
 NTHR_FK_HRO FOREIGN KEY 
  (NTHR_ROLE) REFERENCES HIG_ROLES
  (HRO_ROLE) ON DELETE CASCADE
/

insert into nm_theme_functions_all
 (NTF_NTH_THEME_ID 
 ,NTF_HMO_MODULE 
 ,NTF_PARAMETER 
 ,NTF_MENU_OPTION 
 ,NTF_SEEN_IN_GIS )
select 
  GTF_GT_THEME_ID
, GTF_HMO_MODULE
, GTF_PARAMETER
, GTF_MENU_OPTION
, GTF_SEEN_IN_GIS
from gis_theme_functions_all;

insert into nm_theme_roles
 (NTHR_THEME_ID,
  NTHR_ROLE,
  NTHR_MODE )
select
 GTHR_THEME_ID, GTHR_ROLE, GTHR_MODE
from gis_theme_roles 
/


PROMPT Replacing the GIS_THEMES_ALL as a view to maintain SDM compatibility

rename gis_themes_all to gis_themes_all_saved;

CREATE OR REPLACE FORCE VIEW GIS_THEMES_ALL
(GT_THEME_ID, GT_THEME_NAME, GT_TABLE_NAME, GT_WHERE, GT_PK_COLUMN, 
 GT_LABEL_COLUMN, GT_RSE_TABLE_NAME, GT_RSE_FK_COLUMN, GT_ST_CHAIN_COLUMN, GT_END_CHAIN_COLUMN, 
 GT_X_COLUMN, GT_Y_COLUMN, GT_OFFSET_FIELD, GT_FEATURE_TABLE, GT_FEATURE_PK_COLUMN, 
 GT_FEATURE_FK_COLUMN, GT_ROUTE_THEME, GT_XSP_COLUMN, GT_FEATURE_SHAPE_COLUMN, GT_HPR_PRODUCT, 
 GT_LOCATION_UPDATABLE)
AS 
select 
NTH_THEME_ID, 
NTH_THEME_NAME, 
NTH_TABLE_NAME, 
NTH_WHERE, 
NTH_PK_COLUMN, 
NTH_LABEL_COLUMN, 
NTH_RSE_TABLE_NAME, 
NTH_RSE_FK_COLUMN, 
NTH_ST_CHAIN_COLUMN, 
NTH_END_CHAIN_COLUMN, 
NTH_X_COLUMN, 
NTH_Y_COLUMN, 
NTH_OFFSET_FIELD, 
NTH_FEATURE_TABLE, 
NTH_FEATURE_PK_COLUMN, 
NTH_FEATURE_FK_COLUMN, 
decode( nlt_g_i_d, 'D', 'Y', 'N')  NTH_ROUTE_THEME, 
NTH_XSP_COLUMN, 
NTH_FEATURE_SHAPE_COLUMN, 
NTH_HPR_PRODUCT, 
NTH_LOCATION_UPDATABLE 
from nm_themes_all, 
     nm_linear_types, 
     nm_nw_themes 
where nth_theme_id = NNTH_NTH_THEME_ID (+) 
and   NLT_ID (+) = NNTH_NLT_ID;

alter view gis_themes compile;

PROMPT Replacing the GIS_THEME_ROLES as a view to maintain SDM compatibility

rename GIS_THEME_ROLES to GIS_THEME_ROLES_SAVED;

create or replace Force view gis_theme_roles
(
  GTHR_THEME_ID,
  GTHR_ROLE,
  GTHR_MODE )
as select   
  NTHR_THEME_ID,
  NTHR_ROLE,
  NTHR_MODE 
from nm_theme_roles;  

PROMPT Replacing the GIS_THEME_FUNCTIONS_ALL as a view to maintain SDM compatibility

rename GIS_THEME_FUNCTIONS_ALL to GIS_THEME_FUNCTIONS_ALL_SAVED;

CREATE or replace force view GIS_THEME_FUNCTIONS_ALL
(
  GTF_GT_THEME_ID,
  GTF_HMO_MODULE,
  GTF_PARAMETER,
  GTF_MENU_OPTION,
  GTF_SEEN_IN_GIS )
as select 
  NTF_NTH_THEME_ID,
  NTF_HMO_MODULE,
  NTF_PARAMETER,
  NTF_MENU_OPTION,
  NTF_SEEN_IN_GIS
from nm_theme_functions_all;

PROMPT Inserting new sequence (NLT_ID_SEQ) association

insert into hig_sequence_associations
(hsa_table_name,
 hsa_column_name,
 hsa_sequence_name,
 hsa_last_rebuild_date)
values
('NM_LINEAR_TYPES',
 'NLT_ID',
 'NLT_ID_SEQ',
 NULL
);

PROMPT Inserting new sequence (NTH_THEME_ID_SEQ) association

insert into hig_sequence_associations
(hsa_table_name,
 hsa_column_name,
 hsa_sequence_name,
 hsa_last_rebuild_date)
values
('NM_THEMES_ALL',
 'NTH_THEME_ID',
 'NTH_THEME_ID_SEQ',
 NULL
);

PROMPT Remove sequence association for GT_THEME_ID...
DELETE FROM hig_sequence_associations
WHERE           hsa_sequence_name = 'GT_THEME_ID';

COMMIT;

declare
  l_count number;
begin
    select count(*) into l_count from nm_layers;
    if l_count = 0 then
      raise_application_error (-20001, 'No SDO metadata for theme table');
    end if;
end;
/
---------------------------------------------------------------------------------------------------
--End of spatial upgrades
---------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------
--Start of Merge enhancements.
---------------------------------------------------------------------------------------------------

ALTER TABLE nm_mrg_output_file
 ADD (nmf_template VARCHAR2(1) DEFAULT 'N' NOT NULL)
/

ALTER TABLE nm_mrg_output_file
 ADD CONSTRAINT nmf_template_yn_chk
 CHECK (nmf_template IN ('Y','N'))
/

ALTER TABLE nm_mrg_output_file
 ADD (nmf_append_merge_au_to_path VARCHAR2(1) DEFAULT 'N' NOT NULL)
/

ALTER TABLE nm_mrg_output_file
 ADD CONSTRAINT nmf_append_mrg_au_path_yn_chk
 CHECK (nmf_append_merge_au_to_path IN ('Y','N'))
/

ALTER TABLE nm_mrg_output_file
 MODIFY (nmf_filename VARCHAR2(80))
/


ALTER TABLE nm_mrg_output_file
 ADD CONSTRAINT nmf_template_filename_chk
 CHECK (DECODE(nmf_template,'Y',0,5) + DECODE(SIGN(LENGTH(nmf_filename)-50),0,5,-1,5,1) != 1)
/

DROP TABLE nm_upload_file_gateways CASCADE CONSTRAINTS
/

CREATE TABLE nm_upload_file_gateways
   (nufg_table_name VARCHAR2(30) NOT NULL
   )
/

ALTER TABLE nm_upload_file_gateways
 ADD CONSTRAINT nufg_pk
 PRIMARY KEY (nufg_table_name)
/

ALTER TABLE nm_upload_file_gateways
 ADD CONSTRAINT nufg_table_name_upper_chk
 CHECK (nufg_table_name=UPPER(nufg_table_name))
/



DROP TABLE nm_upload_file_gateway_cols CASCADE CONSTRAINTS
/

CREATE TABLE nm_upload_file_gateway_cols
    (nufgc_nufg_table_name VARCHAR2(30) NOT NULL
    ,nufgc_seq             NUMBER(1)    NOT NULL
    ,nufgc_column_name     VARCHAR2(30) NOT NULL
    ,nufgc_column_datatype VARCHAR2(8)  NOT NULL
    )
/

ALTER TABLE nm_upload_file_gateway_cols
 ADD CONSTRAINT nufgc_pk
 PRIMARY KEY (nufgc_nufg_table_name,nufgc_seq)
/

ALTER TABLE nm_upload_file_gateway_cols
 ADD CONSTRAINT nufgc_uk
 UNIQUE (nufgc_nufg_table_name,nufgc_column_name)
/

ALTER TABLE nm_upload_file_gateway_cols
 ADD CONSTRAINT nufgc_seq_chk
 CHECK (nufgc_seq = TRUNC(nufgc_seq) AND nufgc_seq BETWEEN 1 AND 5)
/

ALTER TABLE nm_upload_file_gateway_cols
 ADD CONSTRAINT nufgc_column_datatype_chk
 CHECK (nufgc_column_datatype IN ('DATE','NUMBER','VARCHAR2'))
/

ALTER TABLE nm_upload_file_gateway_cols
 ADD CONSTRAINT nufgc_column_name_upper_chk
 CHECK (nufgc_column_name=UPPER(nufgc_column_name))
/

ALTER TABLE nm_upload_file_gateway_cols
 ADD CONSTRAINT nufgc_nufg_fk
 FOREIGN KEY (nufgc_nufg_table_name)
 REFERENCES nm_upload_file_gateways (nufg_table_name)
 ON DELETE CASCADE
/


ALTER TABLE nm_upload_files
 ADD (nuf_nufg_table_name    VARCHAR2(30)
     ,nuf_nufgc_column_val_1 VARCHAR2(80)
     ,nuf_nufgc_column_val_2 VARCHAR2(80)
     ,nuf_nufgc_column_val_3 VARCHAR2(80)
     ,nuf_nufgc_column_val_4 VARCHAR2(80)
     ,nuf_nufgc_column_val_5 VARCHAR2(80)
     )
/

ALTER TABLE nm_upload_files
 ADD CONSTRAINT nuf_nufg_fk
 FOREIGN KEY (nuf_nufg_table_name)
 REFERENCES nm_upload_file_gateways (nufg_table_name)
 ON DELETE SET NULL
/

CREATE INDEX nuf_nufg_fk_ind ON nm_upload_files (nuf_nufg_table_name);

---------------------------------------------------------------------------------------------------
--End of Merge enhancements.
---------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------
--Start of hig hd upgrades
---------------------------------------------------------------------------------------------------
PROMPT
PROMPT Creating Table HIG_HD_MODULES
CREATE TABLE HIG_HD_MODULES
(
  HHM_MODULE  VARCHAR2(30)                          NOT NULL,
  HHM_TAG     VARCHAR2(30)                          
)
LOGGING 
NOCACHE
NOPARALLEL;

COMMENT ON TABLE HIG_HD_MODULES IS 'Storage of modules used in dynamic sql creation';

PROMPT
PROMPT Creating Table HIG_HD_MOD_USES
CREATE TABLE HIG_HD_MOD_USES
(
  HHU_HHM_MODULE          VARCHAR2(30)              NOT NULL,
  HHU_TABLE_NAME          VARCHAR2(30)              NOT NULL,
  HHU_SEQ                 NUMBER                    NOT NULL,
  HHU_ALIAS               VARCHAR2(30),
  HHU_PARENT_SEQ          NUMBER,
  HHU_FIXED_WHERE_CLAUSE  VARCHAR2(500),
  HHU_LOAD_DATA           VARCHAR2(1)  DEFAULT 'N'  NOT NULL,
  HHU_HINT_TEXT	          VARCHAR2(100),
  HHU_TAG                 VARCHAR2(100)
)
LOGGING 
NOCACHE
NOPARALLEL;

COMMENT ON TABLE HIG_HD_MOD_USES IS 'Lists tables used in dynamic sql creation';

PROMPT
PROMPT Creating Table HIG_HD_LOOKUP_JOIN_DEFS
CREATE TABLE HIG_HD_LOOKUP_JOIN_DEFS
(
  HHL_HHU_HHM_MODULE           VARCHAR2(30)                  NOT NULL,
  HHL_HHU_SEQ                  NUMBER                        NOT NULL,
  HHL_JOIN_SEQ                 NUMBER                        NOT NULL,
  HHL_TABLE_NAME               VARCHAR2(30)                  NOT NULL,
  HHL_ALIAS                    VARCHAR2(30)                  NOT NULL,
  HHL_OUTER_JOIN               VARCHAR2(1)  DEFAULT 'N'      NOT NULL,
  HHL_FIXED_WHERE_CLAUSE       VARCHAR2(500)
)
LOGGING 
NOCACHE
NOPARALLEL;

COMMENT ON TABLE HIG_HD_LOOKUP_JOIN_DEFS IS 'Definitions of tables used to lookup data selected in hig_hd_selected_cols';

PROMPT
PROMPT Creating Table HIG_HD_LOOKUP_JOIN_COLS
CREATE TABLE HIG_HD_LOOKUP_JOIN_COLS
(
  HHO_HHL_HHU_HHM_MODULE      VARCHAR2(30)                  NOT NULL,
  HHO_HHL_HHU_SEQ             NUMBER                        NOT NULL,
  HHO_HHL_JOIN_SEQ            NUMBER                        NOT NULL,
  HHO_PARENT_COL              VARCHAR2(30)                  NOT NULL,
  HHO_LOOKUP_COL              VARCHAR2(30)                  NOT NULL
)
LOGGING 
NOCACHE
NOPARALLEL;

COMMENT ON TABLE HIG_HD_LOOKUP_JOIN_COLS IS 'Columns used in lookup table joins. The join are defined in hig_hd_lookup_join_defs';

PROMPT
PROMPT Creating Table HIG_HD_SELECTED_COLS
CREATE TABLE HIG_HD_SELECTED_COLS
(
  HHC_HHU_HHM_MODULE          VARCHAR2(30)                 NOT NULL,
  HHC_HHU_SEQ                 NUMBER                       NOT NULL,
  HHC_COLUMN_SEQ              NUMBER                       NOT NULL,
  HHC_COLUMN_NAME             VARCHAR2(30)                 NOT NULL,
  HHC_SUMMARY_VIEW            VARCHAR2(1)   DEFAULT 'Y'    NOT NULL,
  HHC_DISPLAYED               VARCHAR2(1)   DEFAULT 'Y'    NOT NULL,
  HHC_ALIAS                   VARCHAR2(30),
  HHC_FUNCTION                VARCHAR2(200),
  HHC_ORDER_BY_SEQ            NUMBER,
  HHC_UNIQUE_IDENTIFIER_SEQ   NUMBER,
  HHC_HHL_JOIN_SEQ            NUMBER,
  HHC_CALC_RATIO              VARCHAR2(1),
  HHC_FORMAT                  VARCHAR2(30)
)
LOGGING 
NOCACHE
NOPARALLEL;

COMMENT ON TABLE HIG_HD_SELECTED_COLS IS 'List of columns selected from tables specified in hig_hd_mod_uses';

PROMPT
PROMPT Creating Table HIG_HD_JOIN_DEFS
CREATE TABLE HIG_HD_JOIN_DEFS
(
  HHT_HHU_HHM_MODULE       VARCHAR2(30)                 NOT NULL,
  HHT_HHU_SEQ              NUMBER                       NOT NULL,
  HHT_JOIN_SEQ             NUMBER                       NOT NULL,
  HHT_TYPE                 VARCHAR2(30)                 NOT NULL,
  HHT_DESCRIPTION          VARCHAR2(30)
)
LOGGING 
NOCACHE
NOPARALLEL;

COMMENT ON TABLE HIG_HD_JOIN_DEFS IS 'Definitions of joins between tables listed in hig_hd_mod_uses';

PROMPT
PROMPT Creating Table HIG_HD_TABLE_JOIN_COLS
CREATE TABLE HIG_HD_TABLE_JOIN_COLS
(
  HHJ_HHT_HHU_HHM_MODULE    VARCHAR2(30)            NOT NULL,
  HHJ_HHT_HHU_PARENT_TABLE  NUMBER                  NOT NULL,
  HHJ_HHT_JOIN_SEQ          NUMBER                  NOT NULL,
  HHJ_PARENT_COL            VARCHAR2(30)            NOT NULL,
  HHJ_HHU_CHILD_TABLE       NUMBER                  NOT NULL,
  HHJ_CHILD_COL             VARCHAR2(30)            NOT NULL
)
LOGGING 
NOCACHE
NOPARALLEL;

COMMENT ON TABLE HIG_HD_TABLE_JOIN_COLS IS 'Columns used in the joins defined in hig_hd_join_cols';


PROMPT Adding PRIMARY Constraint To HIG_HD_MODULES Table
ALTER TABLE HIG_HD_MODULES ADD (
  CONSTRAINT HIG_HD_HHM_PK PRIMARY KEY (HHM_MODULE));
  
PROMPT Adding PRIMARY Constraint To HIG_HD_MOD_USES Table
ALTER TABLE HIG_HD_MOD_USES ADD (
  CONSTRAINT HIG_HD_HHU_PK PRIMARY KEY (HHU_HHM_MODULE, HHU_SEQ));

PROMPT Adding FOREIGN Constraint To HIG_HD_MOD_USES Table
ALTER TABLE HIG_HD_MOD_USES ADD (
  CONSTRAINT HIG_HD_HHU_HHM_FK FOREIGN KEY (HHU_HHM_MODULE) 
    REFERENCES HIG_HD_MODULES (HHM_MODULE) ON DELETE CASCADE);

PROMPT Adding CHECK Constraint To HIG_HD_MOD_USES Table
ALTER TABLE HIG_HD_MOD_USES 
ADD CONSTRAINT HIG_HD_HHU_LOAD_DATA_CHK 
CHECK (HHU_LOAD_DATA IN ('Y', 'N'));

PROMPT Adding PRIMARY Constraint To HIG_HD_LOOKUP_JOIN_DEFS Table
ALTER TABLE HIG_HD_LOOKUP_JOIN_DEFS ADD (
  CONSTRAINT HIG_HD_HHL_PK PRIMARY KEY (HHL_HHU_HHM_MODULE, HHL_HHU_SEQ, HHL_JOIN_SEQ));

PROMPT Adding FOREIGN Constraint To HIG_HD_LOOKUP_JOIN_DEFS Table
ALTER TABLE HIG_HD_LOOKUP_JOIN_DEFS ADD (
  CONSTRAINT HIG_HD_HHL_HHU_FK FOREIGN KEY (HHL_HHU_HHM_MODULE, HHL_HHU_SEQ) 
    REFERENCES HIG_HD_MOD_USES (HHU_HHM_MODULE, HHU_SEQ)  ON DELETE CASCADE);

PROMPT Adding CHECK Constraint To HIG_HD_LOOKUP_JOIN_DEFS Table
ALTER TABLE HIG_HD_LOOKUP_JOIN_DEFS 
ADD CONSTRAINT HIG_HD_HHL_OUTER_JOIN
CHECK (HHL_OUTER_JOIN IN ('Y', 'N'));

PROMPT Adding PRIMARY Constraint To HIG_HD_LOOKUP_JOIN_COLS Table
ALTER TABLE HIG_HD_LOOKUP_JOIN_COLS ADD (
  CONSTRAINT HIG_HD_HHO_PK PRIMARY KEY (HHO_HHL_HHU_HHM_MODULE, HHO_HHL_HHU_SEQ, HHO_HHL_JOIN_SEQ, HHO_PARENT_COL, HHO_LOOKUP_COL));

PROMPT Adding FOREIGN Constraint To HIG_HD_LOOKUP_JOIN_COLS Table
ALTER TABLE HIG_HD_LOOKUP_JOIN_COLS ADD (
  CONSTRAINT HIG_HD_HHO_HHL_FK FOREIGN KEY (HHO_HHL_HHU_HHM_MODULE, HHO_HHL_HHU_SEQ, HHO_HHL_JOIN_SEQ) 
    REFERENCES HIG_HD_LOOKUP_JOIN_DEFS (HHL_HHU_HHM_MODULE, HHL_HHU_SEQ, HHL_JOIN_SEQ)  ON DELETE CASCADE);

PROMPT Adding PRIMARY Constraint To HIG_HD_SELECTED_COLS Table
ALTER TABLE HIG_HD_SELECTED_COLS ADD (
  CONSTRAINT HIG_HD_HHC_PK PRIMARY KEY (HHC_HHU_HHM_MODULE, HHC_HHU_SEQ, HHC_COLUMN_SEQ));

PROMPT Adding FOREIGN Constraint To HIG_HD_SELECTED_COLS Table
ALTER TABLE HIG_HD_SELECTED_COLS ADD (
  CONSTRAINT HIG_HD_HHC_HHU_FK FOREIGN KEY (HHC_HHU_HHM_MODULE, HHC_HHU_SEQ) 
    REFERENCES HIG_HD_MOD_USES (HHU_HHM_MODULE, HHU_SEQ) ON DELETE CASCADE);

PROMPT Adding FOREIGN Constraint To HIG_HD_SELECTED_COLS Table
ALTER TABLE HIG_HD_SELECTED_COLS ADD (
  CONSTRAINT HIG_HD_HHC_HHL_FK FOREIGN KEY (HHC_HHU_HHM_MODULE, HHC_HHU_SEQ, HHC_HHL_JOIN_SEQ) 
    REFERENCES HIG_HD_LOOKUP_JOIN_DEFS (HHL_HHU_HHM_MODULE, HHL_HHU_SEQ, HHL_JOIN_SEQ) ON DELETE CASCADE);
    
PROMPT Adding CHECK Constraint To HIG_HD_SELECTED_COLS Table
ALTER TABLE HIG_HD_SELECTED_COLS 
ADD CONSTRAINT HIG_HD_HHC_SUMMARY_VIEW 
CHECK (HHC_SUMMARY_VIEW IN ('Y', 'N'));

PROMPT Adding CHECK Constraint To HIG_HD_SELECTED_COLS Table
ALTER TABLE HIG_HD_SELECTED_COLS 
ADD CONSTRAINT HIG_HD_HHC_DISPLAYED 
CHECK (HHC_DISPLAYED IN ('Y', 'N'));

PROMPT Adding PRIMARY Constraint To HIG_HD_JOIN_DEFS Table
ALTER TABLE HIG_HD_JOIN_DEFS ADD (
  CONSTRAINT HIG_HD_HHT_PK PRIMARY KEY (HHT_HHU_HHM_MODULE, HHT_HHU_SEQ, HHT_JOIN_SEQ));

PROMPT Adding FOREIGN Constraint To HIG_HD_JOIN_DEFS Table
ALTER TABLE HIG_HD_JOIN_DEFS ADD (
  CONSTRAINT HIG_HD_MUJ_MU_FK FOREIGN KEY (HHT_HHU_HHM_MODULE, HHT_HHU_SEQ) 
    REFERENCES HIG_HD_MOD_USES (HHU_HHM_MODULE, HHU_SEQ) ON DELETE CASCADE);

PROMPT Adding PRIMARY Constraint To HIG_HD_TABLE_JOIN_COLS Table
ALTER TABLE HIG_HD_TABLE_JOIN_COLS ADD (
  CONSTRAINT HIG_HD_HHJ_PK PRIMARY KEY (HHJ_HHT_HHU_HHM_MODULE, HHJ_HHT_HHU_PARENT_TABLE, HHJ_HHT_JOIN_SEQ, HHJ_PARENT_COL, HHJ_HHU_CHILD_TABLE, HHJ_CHILD_COL));

PROMPT Adding FOREIGN Constraint To HIG_HD_TABLE_JOIN_COLS Table
ALTER TABLE HIG_HD_TABLE_JOIN_COLS ADD (
  CONSTRAINT HIG_HD_HHJ_HHT_FK FOREIGN KEY (HHJ_HHT_HHU_HHM_MODULE, HHJ_HHT_HHU_PARENT_TABLE, HHJ_HHT_JOIN_SEQ) 
    REFERENCES HIG_HD_JOIN_DEFS (HHT_HHU_HHM_MODULE, HHT_HHU_SEQ, HHT_JOIN_SEQ) ON DELETE CASCADE);

PROMPT Adding FOREIGN Constraint To HIG_HD_TABLE_JOIN_COLS Table
ALTER TABLE HIG_HD_TABLE_JOIN_COLS ADD (
  CONSTRAINT HIG_HD_HHJ_HHU_CHILD_FK FOREIGN KEY (HHJ_HHT_HHU_HHM_MODULE, HHJ_HHU_CHILD_TABLE) 
    REFERENCES HIG_HD_MOD_USES (HHU_HHM_MODULE, HHU_SEQ) ON DELETE CASCADE);

PROMPT Adding FOREIGN Constraint To HIG_HD_TABLE_JOIN_COLS Table
ALTER TABLE HIG_HD_TABLE_JOIN_COLS ADD (
  CONSTRAINT HIG_HD_HHJ_HHC_PARENT_FK FOREIGN KEY (HHJ_HHT_HHU_HHM_MODULE, HHJ_HHT_HHU_PARENT_TABLE) 
    REFERENCES HIG_HD_MOD_USES (HHU_HHM_MODULE, HHU_SEQ) ON DELETE CASCADE);


ALTER TABLE GRI_MODULE_PARAMS ADD (GMP_BASE_TABLE VARCHAR2(30))
/
ALTER TABLE GRI_MODULE_PARAMS ADD (GMP_BASE_TABLE_COLUMN VARCHAR2(30))
/
ALTER TABLE GRI_MODULE_PARAMS ADD (GMP_OPERATOR VARCHAR2(5))
/
---------------------------------------------------------------------------------------------------
--End of hig hd upgrades
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
--Start of IM table upgrades
---------------------------------------------------------------------------------------------------
CREATE TABLE HIG_URL_MODULES
(
  HUM_HMO_MODULE  VARCHAR2(30)             NOT NULL,
  HUM_URL         VARCHAR2(4000)           NOT NULL
);

CREATE UNIQUE INDEX HUM_PK ON HIG_URL_MODULES
(HUM_HMO_MODULE);

ALTER TABLE HIG_URL_MODULES ADD (
  CONSTRAINT HUM_PK PRIMARY KEY (HUM_HMO_MODULE));

ALTER TABLE HIG_URL_MODULES ADD (
  CONSTRAINT HUM_HMO_FK FOREIGN KEY (HUM_HMO_MODULE) 
    REFERENCES HIG_MODULES (HMO_MODULE));
---------------------------------------------------------------------------------------------------
--End of IM table upgrades
---------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------
--Start of nm_type_columns changes
---------------------------------------------------------------------------------------------------
ALTER TABLE nm_type_columns ADD (ntc_unique_format varchar2(254));

ALTER TABLE nm_type_columns ADD CONSTRAINT ntc_unique_format_chk CHECK (DECODE(ntc_unique_seq, NULL, 'N', 'V') || DECODE(ntc_unique_format, NULL, 'N', 'V') NOT IN ('NV'));

ALTER TABLE nm_type_columns MODIFY (ntc_default varchar2(254));

ALTER TABLE nm_type_columns ADD(ntc_updatable varchar2(1) DEFAULT 'Y' NOT NULL);
---------------------------------------------------------------------------------------------------
--End of nm_type_columns changes
---------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------
--Start of Group Inv Tables
---------------------------------------------------------------------------------------------------
PROMPT Group Inv Tables...
--
CREATE TABLE nm_group_inv_types
(
  ngit_ngt_group_type  varchar2(4 BYTE)         NOT NULL,
  ngit_nit_inv_type    varchar2(4 BYTE)         NOT NULL
);

CREATE INDEX ngit_fk_ngt_ind ON nm_group_inv_types
(ngit_ngt_group_type);

CREATE INDEX ngit_fk_nit_ind ON nm_group_inv_types
(ngit_nit_inv_type);

ALTER TABLE nm_group_inv_types ADD (
  CONSTRAINT ngit_pk PRIMARY KEY (ngit_ngt_group_type, ngit_nit_inv_type));

ALTER TABLE nm_group_inv_types ADD (
  CONSTRAINT ngit_uk UNIQUE (ngit_ngt_group_type));

ALTER TABLE nm_group_inv_types ADD (
  CONSTRAINT ngit_fk_ngt FOREIGN KEY (ngit_ngt_group_type) 
    REFERENCES nm_group_types_all (ngt_group_type));

ALTER TABLE nm_group_inv_types ADD (
  CONSTRAINT ngit_fk_nit FOREIGN KEY (ngit_nit_inv_type) 
    REFERENCES nm_inv_types_all (nit_inv_type));


CREATE TABLE nm_group_inv_link_all
(
  ngil_ne_ne_id    number(9)                    NOT NULL,
  ngil_iit_ne_id   number(9)                    NOT NULL,
  ngil_start_date  date                         DEFAULT TO_DATE('05111605','DDMMYYYY') NOT NULL,
  ngil_end_date    date
);

CREATE INDEX ngil_fk_iit_ind ON nm_group_inv_link_all
(ngil_iit_ne_id);

CREATE INDEX ngil_fk_ne_ind ON nm_group_inv_link_all
(ngil_ne_ne_id);

ALTER TABLE nm_group_inv_link_all ADD (
  CONSTRAINT ngil_end_date_tchk CHECK (ngil_end_date=TRUNC(ngil_end_date)));

ALTER TABLE nm_group_inv_link_all ADD (
  CONSTRAINT ngil_start_date_tchk CHECK (ngil_start_date=TRUNC(ngil_start_date)));

ALTER TABLE nm_group_inv_link_all ADD (
  CONSTRAINT ngil_pk PRIMARY KEY (ngil_ne_ne_id, ngil_iit_ne_id));

ALTER TABLE nm_group_inv_link_all ADD (
  CONSTRAINT ngil_uk UNIQUE (ngil_ne_ne_id));

ALTER TABLE nm_group_inv_link_all ADD (
  CONSTRAINT ngil_fk_iit FOREIGN KEY (ngil_iit_ne_id) 
    REFERENCES nm_inv_items_all (iit_ne_id));

ALTER TABLE nm_group_inv_link_all ADD (
  CONSTRAINT ngil_fk_ne FOREIGN KEY (ngil_ne_ne_id) 
    REFERENCES nm_elements_all (ne_id));
    
ALTER TABLE nm_inv_types_all ADD CONSTRAINT nit_cat_pnt_cont_chk
CHECK (nit_category <> 'G' OR (nit_category = 'G' AND nit_pnt_or_cont = 'C'))
/

---------------------------------------------------------------------------------------------------
--End of Group Inv Tables
---------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------
--Start of MapCapture Asset Loader
---------------------------------------------------------------------------------------------------
--
--

alter table nm_inv_type_attribs_all disable all triggers;
alter table nm_inv_type_attribs_all add (ita_keep_history_yn varchar2(1) default 'N' not null );
alter table nm_inv_type_attribs_all enable all triggers;

ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL ADD (
  CONSTRAINT ITA_HIST_YN_CHK CHECK (ita_keep_history_yn IN ('Y','N')));

alter table nm_load_files add (nlf_holding_table varchar2(30));

alter table nm_load_files modify (NLF_PATH NULL);

CREATE TABLE NM_LOAD_BATCH_LOCK
(
NLBL_BATCH_ID                     VARCHAR2(200)                     NOT NULL,
NLBL_LOCK_CREATED                 DATE          DEFAULT SYSDATE     NOT NULL
)
/
ALTER TABLE NM_LOAD_BATCH_LOCK
 ADD CONSTRAINT NM_LOAD_BATCH_LOCK_PK PRIMARY KEY 
  (NLBL_BATCH_ID)
/

CREATE TABLE NM_LD_MC_ALL_INV_TMP
(
  BATCH_NO                   NUMBER(9)          NOT NULL,
  RECORD_NO                  NUMBER(9)          NOT NULL,
  IIT_NE_ID                  NUMBER(9)          NOT NULL,
  IIT_INV_TYPE               VARCHAR2(4)        NOT NULL,
  IIT_PRIMARY_KEY            VARCHAR2(50),
  IIT_NE_UNIQUE              VARCHAR2(30),
  IIT_NE_NT_TYPE             VARCHAR2(4),
  NE_ID                      NUMBER,
  NM_START                   NUMBER,
  NM_END                     NUMBER,
  NAU_UNIT_CODE              VARCHAR2(10),
  IIT_START_DATE             DATE               NOT NULL,
  IIT_DATE_CREATED           DATE               NOT NULL,
  IIT_DATE_MODIFIED          DATE               NOT NULL,
  IIT_CREATED_BY             VARCHAR2(30)       NOT NULL,
  IIT_MODIFIED_BY            VARCHAR2(30)       NOT NULL,
  IIT_ADMIN_UNIT             NUMBER(9)          NOT NULL,
  IIT_DESCR                  VARCHAR2(40),
  IIT_END_DATE               DATE,
  IIT_FOREIGN_KEY            VARCHAR2(50),
  IIT_LOCATED_BY             NUMBER(9),
  IIT_POSITION               NUMBER,
  IIT_X_COORD                NUMBER,
  IIT_Y_COORD                NUMBER,
  IIT_NUM_ATTRIB16           NUMBER,
  IIT_NUM_ATTRIB17           NUMBER,
  IIT_NUM_ATTRIB18           NUMBER,
  IIT_NUM_ATTRIB19           NUMBER,
  IIT_NUM_ATTRIB20           NUMBER,
  IIT_NUM_ATTRIB21           NUMBER,
  IIT_NUM_ATTRIB22           NUMBER,
  IIT_NUM_ATTRIB23           NUMBER,
  IIT_NUM_ATTRIB24           NUMBER,
  IIT_NUM_ATTRIB25           NUMBER,
  IIT_CHR_ATTRIB26           VARCHAR2(50),
  IIT_CHR_ATTRIB27           VARCHAR2(50),
  IIT_CHR_ATTRIB28           VARCHAR2(50),
  IIT_CHR_ATTRIB29           VARCHAR2(50),
  IIT_CHR_ATTRIB30           VARCHAR2(50),
  IIT_CHR_ATTRIB31           VARCHAR2(50),
  IIT_CHR_ATTRIB32           VARCHAR2(50),
  IIT_CHR_ATTRIB33           VARCHAR2(50),
  IIT_CHR_ATTRIB34           VARCHAR2(50),
  IIT_CHR_ATTRIB35           VARCHAR2(50),
  IIT_CHR_ATTRIB36           VARCHAR2(50),
  IIT_CHR_ATTRIB37           VARCHAR2(50),
  IIT_CHR_ATTRIB38           VARCHAR2(50),
  IIT_CHR_ATTRIB39           VARCHAR2(50),
  IIT_CHR_ATTRIB40           VARCHAR2(50),
  IIT_CHR_ATTRIB41           VARCHAR2(50),
  IIT_CHR_ATTRIB42           VARCHAR2(50),
  IIT_CHR_ATTRIB43           VARCHAR2(50),
  IIT_CHR_ATTRIB44           VARCHAR2(50),
  IIT_CHR_ATTRIB45           VARCHAR2(50),
  IIT_CHR_ATTRIB46           VARCHAR2(50),
  IIT_CHR_ATTRIB47           VARCHAR2(50),
  IIT_CHR_ATTRIB48           VARCHAR2(50),
  IIT_CHR_ATTRIB49           VARCHAR2(50),
  IIT_CHR_ATTRIB50           VARCHAR2(50),
  IIT_CHR_ATTRIB51           VARCHAR2(50),
  IIT_CHR_ATTRIB52           VARCHAR2(50),
  IIT_CHR_ATTRIB53           VARCHAR2(50),
  IIT_CHR_ATTRIB54           VARCHAR2(50),
  IIT_CHR_ATTRIB55           VARCHAR2(50),
  IIT_CHR_ATTRIB56           VARCHAR2(200),
  IIT_CHR_ATTRIB57           VARCHAR2(200),
  IIT_CHR_ATTRIB58           VARCHAR2(200),
  IIT_CHR_ATTRIB59           VARCHAR2(200),
  IIT_CHR_ATTRIB60           VARCHAR2(200),
  IIT_CHR_ATTRIB61           VARCHAR2(200),
  IIT_CHR_ATTRIB62           VARCHAR2(200),
  IIT_CHR_ATTRIB63           VARCHAR2(200),
  IIT_CHR_ATTRIB64           VARCHAR2(200),
  IIT_CHR_ATTRIB65           VARCHAR2(200),
  IIT_CHR_ATTRIB66           VARCHAR2(500),
  IIT_CHR_ATTRIB67           VARCHAR2(500),
  IIT_CHR_ATTRIB68           VARCHAR2(500),
  IIT_CHR_ATTRIB69           VARCHAR2(500),
  IIT_CHR_ATTRIB70           VARCHAR2(500),
  IIT_CHR_ATTRIB71           VARCHAR2(500),
  IIT_CHR_ATTRIB72           VARCHAR2(500),
  IIT_CHR_ATTRIB73           VARCHAR2(500),
  IIT_CHR_ATTRIB74           VARCHAR2(500),
  IIT_CHR_ATTRIB75           VARCHAR2(500),
  IIT_NUM_ATTRIB76           NUMBER,
  IIT_NUM_ATTRIB77           NUMBER,
  IIT_NUM_ATTRIB78           NUMBER,
  IIT_NUM_ATTRIB79           NUMBER,
  IIT_NUM_ATTRIB80           NUMBER,
  IIT_NUM_ATTRIB81           NUMBER,
  IIT_NUM_ATTRIB82           NUMBER,
  IIT_NUM_ATTRIB83           NUMBER,
  IIT_NUM_ATTRIB84           NUMBER,
  IIT_NUM_ATTRIB85           NUMBER,
  IIT_DATE_ATTRIB86          DATE,
  IIT_DATE_ATTRIB87          DATE,
  IIT_DATE_ATTRIB88          DATE,
  IIT_DATE_ATTRIB89          DATE,
  IIT_DATE_ATTRIB90          DATE,
  IIT_DATE_ATTRIB91          DATE,
  IIT_DATE_ATTRIB92          DATE,
  IIT_DATE_ATTRIB93          DATE,
  IIT_DATE_ATTRIB94          DATE,
  IIT_DATE_ATTRIB95          DATE,
  IIT_ANGLE                  NUMBER(6,2),
  IIT_ANGLE_TXT              VARCHAR2(20),
  IIT_CLASS                  VARCHAR2(2),
  IIT_CLASS_TXT              VARCHAR2(20),
  IIT_COLOUR                 VARCHAR2(2),
  IIT_COLOUR_TXT             VARCHAR2(20),
  IIT_COORD_FLAG             VARCHAR2(1),
  IIT_DESCRIPTION            VARCHAR2(40),
  IIT_DIAGRAM                VARCHAR2(6),
  IIT_DISTANCE               NUMBER(7,2),
  IIT_END_CHAIN              NUMBER(6),
  IIT_GAP                    NUMBER(6,2),
  IIT_HEIGHT                 NUMBER(6,2),
  IIT_HEIGHT_2               NUMBER(6,2),
  IIT_ID_CODE                VARCHAR2(8),
  IIT_INSTAL_DATE            DATE,
  IIT_INVENT_DATE            DATE,
  IIT_INV_OWNERSHIP          VARCHAR2(4),
  IIT_ITEMCODE               VARCHAR2(8),
  IIT_LCO_LAMP_CONFIG_ID     NUMBER(3),
  IIT_LENGTH                 NUMBER(6),
  IIT_MATERIAL               VARCHAR2(30),
  IIT_MATERIAL_TXT           VARCHAR2(20),
  IIT_METHOD                 VARCHAR2(2),
  IIT_METHOD_TXT             VARCHAR2(20),
  IIT_NOTE                   VARCHAR2(40),
  IIT_NO_OF_UNITS            NUMBER(3),
  IIT_OPTIONS                VARCHAR2(2),
  IIT_OPTIONS_TXT            VARCHAR2(20),
  IIT_OUN_ORG_ID_ELEC_BOARD  NUMBER(8),
  IIT_OWNER                  VARCHAR2(4),
  IIT_OWNER_TXT              VARCHAR2(20),
  IIT_PEO_INVENT_BY_ID       NUMBER(8),
  IIT_PHOTO                  VARCHAR2(6),
  IIT_POWER                  NUMBER(6),
  IIT_PROV_FLAG              VARCHAR2(1),
  IIT_REV_BY                 VARCHAR2(20),
  IIT_REV_DATE               DATE,
  IIT_TYPE                   VARCHAR2(2),
  IIT_TYPE_TXT               VARCHAR2(20),
  IIT_WIDTH                  NUMBER(6,2),
  IIT_XTRA_CHAR_1            VARCHAR2(20),
  IIT_XTRA_DATE_1            DATE,
  IIT_XTRA_DOMAIN_1          VARCHAR2(2),
  IIT_XTRA_DOMAIN_TXT_1      VARCHAR2(20),
  IIT_XTRA_NUMBER_1          NUMBER(10,2),
  IIT_X_SECT                 VARCHAR2(4),
  IIT_DET_XSP                VARCHAR2(4),
  IIT_OFFSET                 NUMBER,
  IIT_X                      NUMBER,
  IIT_Y                      NUMBER,
  IIT_Z                      NUMBER,
  IIT_NUM_ATTRIB96           NUMBER,
  IIT_NUM_ATTRIB97           NUMBER,
  IIT_NUM_ATTRIB98           NUMBER,
  IIT_NUM_ATTRIB99           NUMBER,
  IIT_NUM_ATTRIB100          NUMBER,
  IIT_NUM_ATTRIB101          NUMBER,
  IIT_NUM_ATTRIB102          NUMBER,
  IIT_NUM_ATTRIB103          NUMBER,
  IIT_NUM_ATTRIB104          NUMBER,
  IIT_NUM_ATTRIB105          NUMBER,
  IIT_NUM_ATTRIB106          NUMBER,
  IIT_NUM_ATTRIB107          NUMBER,
  IIT_NUM_ATTRIB108          NUMBER,
  IIT_NUM_ATTRIB109          NUMBER,
  IIT_NUM_ATTRIB110          NUMBER,
  IIT_NUM_ATTRIB111          NUMBER,
  IIT_NUM_ATTRIB112          NUMBER,
  IIT_NUM_ATTRIB113          NUMBER,
  IIT_NUM_ATTRIB114          NUMBER,
  IIT_NUM_ATTRIB115          NUMBER,
  NLM_ERROR_STATUS           NUMBER(1) DEFAULT 0 NOT NULL,
  NLM_ACTION_CODE            VARCHAR2(1),
  NLM_X_SECT                 VARCHAR2(4),
  NLM_INVENT_DATE            DATE,
  NLM_PRIMARY_KEY            VARCHAR2(50)
)
LOGGING 
NOCACHE
NOPARALLEL;


ALTER TABLE NM_LD_MC_ALL_INV_TMP
 ADD CONSTRAINT NM_LD_MC_ALL_INV_TMP_PK PRIMARY KEY 
  (BATCH_NO
  ,RECORD_NO)
/
--  
Prompt Adding Who columns to NM_INV_ATTRI_LOOKUP_ALL
ALTER TABLE NM_INV_ATTRI_LOOKUP_ALL DISABLE ALL TRIGGERS;
ALTER TABLE NM_INV_ATTRI_LOOKUP_ALL ADD IAL_DATE_CREATED             DATE;
ALTER TABLE NM_INV_ATTRI_LOOKUP_ALL ADD IAL_DATE_MODIFIED            DATE;
ALTER TABLE NM_INV_ATTRI_LOOKUP_ALL ADD IAL_MODIFIED_BY              VARCHAR2(30);
ALTER TABLE NM_INV_ATTRI_LOOKUP_ALL ADD IAL_CREATED_BY               VARCHAR2(30);
 
 UPDATE NM_INV_ATTRI_LOOKUP_ALL SET IAL_DATE_CREATED  = SYSDATE   , IAL_DATE_MODIFIED = SYSDATE   , IAL_MODIFIED_BY   = USER   , IAL_CREATED_BY    = USER;
 COMMIT;
 
ALTER TABLE NM_INV_ATTRI_LOOKUP_ALL MODIFY IAL_DATE_CREATED             NOT NULL;
ALTER TABLE NM_INV_ATTRI_LOOKUP_ALL MODIFY IAL_DATE_MODIFIED            NOT NULL;
ALTER TABLE NM_INV_ATTRI_LOOKUP_ALL MODIFY IAL_MODIFIED_BY              NOT NULL;
ALTER TABLE NM_INV_ATTRI_LOOKUP_ALL MODIFY IAL_CREATED_BY               NOT NULL;
ALTER TABLE NM_INV_ATTRI_LOOKUP_ALL ENABLE ALL TRIGGERS;
-- 
Prompt Adding Who columns to NM_INV_DOMAINS_ALL
ALTER TABLE NM_INV_DOMAINS_ALL DISABLE ALL TRIGGERS;
ALTER TABLE NM_INV_DOMAINS_ALL ADD ID_DATE_CREATED             DATE;
ALTER TABLE NM_INV_DOMAINS_ALL ADD ID_DATE_MODIFIED            DATE;
ALTER TABLE NM_INV_DOMAINS_ALL ADD ID_MODIFIED_BY              VARCHAR2(30);
ALTER TABLE NM_INV_DOMAINS_ALL ADD ID_CREATED_BY               VARCHAR2(30);
 
 UPDATE NM_INV_DOMAINS_ALL SET ID_DATE_CREATED  = SYSDATE   , ID_DATE_MODIFIED = SYSDATE   , ID_MODIFIED_BY   = USER   , ID_CREATED_BY    = USER;
 COMMIT;
 
ALTER TABLE NM_INV_DOMAINS_ALL MODIFY ID_DATE_CREATED             NOT NULL;
ALTER TABLE NM_INV_DOMAINS_ALL MODIFY ID_DATE_MODIFIED            NOT NULL;
ALTER TABLE NM_INV_DOMAINS_ALL MODIFY ID_MODIFIED_BY              NOT NULL;
ALTER TABLE NM_INV_DOMAINS_ALL MODIFY ID_CREATED_BY               NOT NULL;
ALTER TABLE NM_INV_DOMAINS_ALL ENABLE ALL TRIGGERS;
-- 
Prompt Adding Who columns to NM_INV_TYPES_ALL
ALTER TABLE NM_INV_TYPES_ALL DISABLE ALL TRIGGERS;
ALTER TABLE NM_INV_TYPES_ALL ADD NIT_DATE_CREATED             DATE;
ALTER TABLE NM_INV_TYPES_ALL ADD NIT_DATE_MODIFIED            DATE;
ALTER TABLE NM_INV_TYPES_ALL ADD NIT_MODIFIED_BY              VARCHAR2(30);
ALTER TABLE NM_INV_TYPES_ALL ADD NIT_CREATED_BY               VARCHAR2(30);
 
 UPDATE NM_INV_TYPES_ALL SET NIT_DATE_CREATED  = SYSDATE   , NIT_DATE_MODIFIED = SYSDATE   , NIT_MODIFIED_BY   = USER   , NIT_CREATED_BY    = USER;
 COMMIT;
 
ALTER TABLE NM_INV_TYPES_ALL MODIFY NIT_DATE_CREATED             NOT NULL;
ALTER TABLE NM_INV_TYPES_ALL MODIFY NIT_DATE_MODIFIED            NOT NULL;
ALTER TABLE NM_INV_TYPES_ALL MODIFY NIT_MODIFIED_BY              NOT NULL;
ALTER TABLE NM_INV_TYPES_ALL MODIFY NIT_CREATED_BY               NOT NULL;
ALTER TABLE NM_INV_TYPES_ALL ENABLE ALL TRIGGERS;
-- 
Prompt Adding Who columns to NM_INV_TYPE_ATTRIBS_ALL
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL DISABLE ALL TRIGGERS;
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL ADD ITA_DATE_CREATED             DATE;
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL ADD ITA_DATE_MODIFIED            DATE;
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL ADD ITA_MODIFIED_BY              VARCHAR2(30);
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL ADD ITA_CREATED_BY               VARCHAR2(30);
 
 UPDATE NM_INV_TYPE_ATTRIBS_ALL SET ITA_DATE_CREATED  = SYSDATE   , ITA_DATE_MODIFIED = SYSDATE   , ITA_MODIFIED_BY   = USER   , ITA_CREATED_BY    = USER;
 COMMIT;
 
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL MODIFY ITA_DATE_CREATED             NOT NULL;
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL MODIFY ITA_DATE_MODIFIED            NOT NULL;
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL MODIFY ITA_MODIFIED_BY              NOT NULL;
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL MODIFY ITA_CREATED_BY               NOT NULL;
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL ENABLE ALL TRIGGERS;
--
Prompt Adding Who columns to NM_INV_TYPE_GROUPINGS_ALL
ALTER TABLE NM_INV_TYPE_GROUPINGS_ALL DISABLE ALL TRIGGERS;
ALTER TABLE NM_INV_TYPE_GROUPINGS_ALL ADD ITG_DATE_CREATED             DATE;
ALTER TABLE NM_INV_TYPE_GROUPINGS_ALL ADD ITG_DATE_MODIFIED            DATE;
ALTER TABLE NM_INV_TYPE_GROUPINGS_ALL ADD ITG_MODIFIED_BY              VARCHAR2(30);
ALTER TABLE NM_INV_TYPE_GROUPINGS_ALL ADD ITG_CREATED_BY               VARCHAR2(30);

 
 UPDATE NM_INV_TYPE_GROUPINGS_ALL SET ITG_DATE_CREATED  = SYSDATE   , ITG_DATE_MODIFIED = SYSDATE   , ITG_MODIFIED_BY   = USER   , ITG_CREATED_BY    = USER;
 COMMIT;
 
 
ALTER TABLE NM_INV_TYPE_GROUPINGS_ALL MODIFY ITG_DATE_CREATED             NOT NULL;
ALTER TABLE NM_INV_TYPE_GROUPINGS_ALL MODIFY ITG_DATE_MODIFIED            NOT NULL;
ALTER TABLE NM_INV_TYPE_GROUPINGS_ALL MODIFY ITG_MODIFIED_BY              NOT NULL;
ALTER TABLE NM_INV_TYPE_GROUPINGS_ALL MODIFY ITG_CREATED_BY               NOT NULL;
ALTER TABLE NM_INV_TYPE_GROUPINGS_ALL ENABLE ALL TRIGGERS;
-- 
Prompt Adding Who columns to NM_XSP
ALTER TABLE NM_XSP DISABLE ALL TRIGGERS;
ALTER TABLE NM_XSP ADD NWX_DATE_CREATED             DATE;
ALTER TABLE NM_XSP ADD NWX_DATE_MODIFIED            DATE;
ALTER TABLE NM_XSP ADD NWX_MODIFIED_BY              VARCHAR2(30);
ALTER TABLE NM_XSP ADD NWX_CREATED_BY               VARCHAR2(30);
 
 UPDATE NM_XSP SET NWX_DATE_CREATED  = SYSDATE   , NWX_DATE_MODIFIED = SYSDATE   , NWX_MODIFIED_BY   = USER   , NWX_CREATED_BY    = USER;
 COMMIT;
 
ALTER TABLE NM_XSP MODIFY NWX_DATE_CREATED             NOT NULL;
ALTER TABLE NM_XSP MODIFY NWX_DATE_MODIFIED            NOT NULL;
ALTER TABLE NM_XSP MODIFY NWX_MODIFIED_BY              NOT NULL;
ALTER TABLE NM_XSP MODIFY NWX_CREATED_BY               NOT NULL;
ALTER TABLE NM_XSP ENABLE ALL TRIGGERS;
-- 
Prompt Adding Who columns to XSP_RESTRAINTS
ALTER TABLE XSP_RESTRAINTS DISABLE ALL TRIGGERS;
ALTER TABLE XSP_RESTRAINTS ADD XSR_DATE_CREATED             DATE;
ALTER TABLE XSP_RESTRAINTS ADD XSR_DATE_MODIFIED            DATE;
ALTER TABLE XSP_RESTRAINTS ADD XSR_MODIFIED_BY              VARCHAR2(30);
ALTER TABLE XSP_RESTRAINTS ADD XSR_CREATED_BY               VARCHAR2(30);
 
 UPDATE XSP_RESTRAINTS SET XSR_DATE_CREATED  = SYSDATE   , XSR_DATE_MODIFIED = SYSDATE   , XSR_MODIFIED_BY   = USER   , XSR_CREATED_BY    = USER;
 COMMIT;
 
ALTER TABLE XSP_RESTRAINTS MODIFY XSR_DATE_CREATED             NOT NULL;
ALTER TABLE XSP_RESTRAINTS MODIFY XSR_DATE_MODIFIED            NOT NULL;
ALTER TABLE XSP_RESTRAINTS MODIFY XSR_MODIFIED_BY              NOT NULL;
ALTER TABLE XSP_RESTRAINTS MODIFY XSR_CREATED_BY               NOT NULL;
ALTER TABLE XSP_RESTRAINTS ENABLE ALL TRIGGERS;
--  
---------------------------------------------------------------------------------------------------
--End of MapCapture Asset Loader
---------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------
--Start of DOCMAN/PEM porting
---------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW doc_contact ( dec_hct_id,
dec_doc_id, dec_type, dec_ref, dec_complainant,
dec_contact, hct_id, hct_org_or_person_flag, hct_vip,
hct_title, hct_salutation, hct_first_name, hct_middle_initial,
hct_surname, hct_organisation, hct_home_phone, hct_work_phone,
hct_mobile_phone, hct_fax, hct_pager, hct_email,
hct_occupation, hct_employer, hct_date_of_birth, hct_start_date,
hct_end_date, hct_notes, hca_hct_id, hca_had_id,
had_id, had_department, had_po_box, had_organisation,
had_sub_building_name_no, had_building_name, had_building_no, had_dependent_thoroughfare,
had_thoroughfare, had_double_dep_locality_name, had_dependent_locality_name, had_post_town,
had_county, had_postcode, had_notes, had_xco,
had_yco, had_osapr, had_property_type ) AS SELECT
dec_hct_id
,dec_doc_id
,dec_type
,dec_ref
,dec_complainant
,dec_contact
,hct_id
,hct_org_or_person_flag
,hct_vip
,hct_title
,hct_salutation
,hct_first_name
,hct_middle_initial
,hct_surname
,hct_organisation
,hct_home_phone
,hct_work_phone
,hct_mobile_phone
,hct_fax
,hct_pager
,hct_email
,hct_occupation
,hct_employer
,hct_date_of_birth
,hct_start_date
,hct_end_date
,hct_notes
,hca_hct_id
,hca_had_id
,had_id
,had_department
,had_po_box
,had_organisation
,had_sub_building_name_no
,had_building_name
,had_building_no
,had_dependent_thoroughfare
,had_thoroughfare
,had_double_dep_locality_name
,had_dependent_locality_name
,had_post_town
,had_county
,had_postcode
,had_notes
,had_xco
,had_yco
,had_osapr
,had_property_type
FROM   doc_enquiry_contacts, hig_contacts, hig_contact_address, hig_address
WHERE  dec_hct_id = hct_id
AND    hct_id = hca_hct_id(+)
AND    hca_had_id = had_id(+)
/


CREATE OR REPLACE VIEW doc_contact_address ( hct_id,
hct_org_or_person_flag, hct_vip, hct_title, hct_salutation,
hct_first_name, hct_middle_initial, hct_surname, hct_organisation,
hct_home_phone, hct_work_phone, hct_mobile_phone, hct_fax,
hct_pager, hct_email, hct_occupation, hct_employer,
hct_date_of_birth, hct_start_date, hct_end_date, hct_notes,
hca_hct_id, hca_had_id, had_id, had_department,
had_po_box, had_organisation, had_sub_building_name_no, had_building_name,
had_building_no, had_dependent_thoroughfare, had_thoroughfare, had_double_dep_locality_name,
had_dependent_locality_name, had_post_town, had_county, had_postcode,
had_notes, had_xco, had_yco, had_osapr, had_property_type
 ) AS SELECT
hct_id
,hct_org_or_person_flag
,hct_vip
,hct_title
,hct_salutation
,hct_first_name
,hct_middle_initial
,hct_surname
,hct_organisation
,hct_home_phone
,hct_work_phone
,hct_mobile_phone
,hct_fax
,hct_pager
,hct_email
,hct_occupation
,hct_employer
,hct_date_of_birth
,hct_start_date
,hct_end_date
,hct_notes
,hca_hct_id
,hca_had_id
,had_id
,had_department
,had_po_box
,had_organisation
,had_sub_building_name_no
,had_building_name
,had_building_no
,had_dependent_thoroughfare
,had_thoroughfare
,had_double_dep_locality_name
,had_dependent_locality_name
,had_post_town
,had_county
,had_postcode
,had_notes
,had_xco
,had_yco
,had_osapr
,had_property_type
FROM   hig_contacts, hig_contact_address, hig_address
WHERE  hct_id = hca_hct_id(+)
AND    hca_had_id = had_id(+)
/
--
---------------------------------------------------------------------------------------------------
--End of DOCMAN/PEM porting
---------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------
--HIG_STANDARD_FAVOURITES for use in HIG1807
---------------------------------------------------------------------------------------------------
--
CREATE TABLE HIG_STANDARD_FAVOURITES
(
  HSTF_PARENT  VARCHAR2(30)                NOT NULL,
  HSTF_CHILD   VARCHAR2(30)                NOT NULL,
  HSTF_DESCR   VARCHAR2(80)                NOT NULL,
  HSTF_TYPE    VARCHAR2(1)                 NOT NULL,
  HSTF_ORDER   NUMBER
)
/

ALTER TABLE HIG_STANDARD_FAVOURITES ADD (
  CONSTRAINT HSTF_PK PRIMARY KEY (HSTF_PARENT, HSTF_CHILD)
    USING INDEX )
/    
---------------------------------------------------------------------------------------------------
--End of HIG_STANDARD_FAVOURITES for use in HIG1807
---------------------------------------------------------------------------------------------------
--
SET serverout ON SIZE 1000000
DECLARE
  TYPE t_varchar30_tab IS TABLE OF varchar2(30) INDEX BY binary_integer; 
  l_grantees_tab t_varchar30_tab;
BEGIN
  --get users with hig_user role
  --except app owner as privs cannot be granted to self.
  --script higowner_9i_privs.sql must be run before this
  SELECT
    hur.hur_username
  BULK COLLECT INTO
    l_grantees_tab
  FROM
    hig_user_roles hur,
    hig_users      hus
  WHERE
    hus.hus_is_hig_owner_flag = 'N'
  AND
    hus.hus_username = hur.hur_username
  AND
    hur.hur_role = 'HIG_USER';
  
  --add hig_user role itself to array
  l_grantees_tab(0) := 'HIG_USER';
  
  DBMS_OUTPUT.PUT_LINE('===============================================================');
  DBMS_OUTPUT.PUT_LINE('About to grant privileges required on 9i to users.');
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('Warning: the following may fail with insufficient privileges');
  DBMS_OUTPUT.PUT_LINE('         errors if the script higowner_9i_privs.sql has not');
  DBMS_OUTPUT.PUT_LINE('         been run as SYSTEM.');
  DBMS_OUTPUT.PUT_LINE('         If it does fail, run the script and rerun the upgrade.');
  DBMS_OUTPUT.PUT_LINE('');
  
  --grant privs to hig_user
  FOR l_i IN 0..l_grantees_tab.COUNT - 1
  LOOP
    BEGIN
      DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE('Granting 9i privs to ' || l_grantees_tab(l_i) || '...'); 
      EXECUTE IMMEDIATE 'grant select any dictionary to ' || l_grantees_tab(l_i);
      EXECUTE IMMEDIATE 'grant select on dba_sys_privs to ' || l_grantees_tab(l_i);
      EXECUTE IMMEDIATE 'grant select on dba_users to ' || l_grantees_tab(l_i);
      EXECUTE IMMEDIATE 'grant select on dba_role_privs to ' || l_grantees_tab(l_i);
      EXECUTE IMMEDIATE 'grant select on dba_ts_quotas to ' || l_grantees_tab(l_i);
      EXECUTE IMMEDIATE 'grant select on dba_tab_privs to ' || l_grantees_tab(l_i);
      EXECUTE IMMEDIATE 'grant select on dba_roles to ' || l_grantees_tab(l_i);
      EXECUTE IMMEDIATE 'grant select on dba_profiles to ' || l_grantees_tab(l_i);
      EXECUTE IMMEDIATE 'grant execute on dbms_pipe to ' || l_grantees_tab(l_i);
      EXECUTE IMMEDIATE 'grant execute on dbms_rls to ' || l_grantees_tab(l_i);
      EXECUTE IMMEDIATE 'grant execute on dbms_lock to ' || l_grantees_tab(l_i);
    EXCEPTION
      WHEN others
      THEN
        DBMS_OUTPUT.PUT_LINE('*Error Granting 9i privs to ' || l_grantees_tab(l_i) || ':');
        DBMS_OUTPUT.PUT_LINE(SQLERRM); 
    END; 
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('===============================================================');
END;
/
SET serverout OFF
--
---------------------------------------------------------------------------------------------------
--
--             **************** END OF TABLE UPGRADES *******************
--
---------------------------------------------------------------------------------------------------
--
--
---------------------------------------------------------------------------------------------------
-- creating synonym required for hig_hd_insert package
---------------------------------------------------------------------------------------------------
create public synonym xslprocessor for sys.xslprocessor;

SET define ON
SET feedback OFF
prompt save insetad_of TRIGGERS
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'trg'||'&terminator'||'save_instead_trg.sql' run_file
FROM dual
/
START '&run_file'
--
--SET define ON
--SET feedback OFF
--prompt Types
--SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
--'&terminator'||'typ'||'&terminator'||'nm3typ.sql' run_file
--FROM dual
--/
--START '&run_file'
--
prompt temp TABLES
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
'&terminator'||'temp_tables.sql' run_file
FROM dual
/
START '&run_file'
--
--
SET define ON
SET feedback OFF
prompt PACKAGE headers
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3pkh.sql' run_file
FROM dual
/
START '&run_file'
--
--
SET define ON
SET feedback OFF
--PROMPT Views
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'views'||'&terminator'||'nm3views.sql' run_file
FROM dual
/
START '&run_file'
--
--
SET define ON
SET feedback OFF
prompt PACKAGE bodies
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3pkb.sql' run_file
FROM dual
/
START '&run_file'
--
--
SET define ON
SET feedback OFF
prompt VIEWS
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'views'||'&terminator'||'nm3views.sql' run_file
FROM dual
/
START '&run_file'
--
prompt temp TABLES
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
'&terminator'||'temp_tables.sql' run_file
FROM dual
/
START '&run_file'
--
SET define ON
SET feedback OFF
prompt TRIGGERS
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'trg'||'&terminator'||'nm3trg.sql' run_file
FROM dual
/
START '&run_file'
--
spool OFF
prompt compile_schema_script
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'utl'||'&terminator'||'compile_schema.sql' run_file
FROM dual
/
START '&run_file'

spool nm3100_upg_2.LOG
--get some db info

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ( 'HIG','NET');

START compile_all.sql
--
------------------------------------------
--The compile_all will have reset the user
--context so we must reinitialise it
------------------------------------------
PROMPT Reinitialising context...
BEGIN
  nm3context.initialise_context;
  nm3user.instantiate_user;
END;
/
--
prompt policies
--
--
SET feedback OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'ctx'||'&terminator'||'add_policy' run_file
FROM dual
/
START '&&run_file'
--
PROMPT Metadata upgrade
SET feedback OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3081_nm3100_metadata_upg' run_file
FROM dual
/
START '&&run_file'
--
--
SET define ON
SET feedback OFF
prompt Ensure certain metadata exists
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
'&terminator'||'nm3data_patch.sql' run_file
FROM dual
/
START '&run_file'
--
SET define ON
SET feedback OFF
prompt Ensure certain metadata exists
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
'&terminator'||'nm3data_patch2.sql' run_file
FROM dual
/
START '&run_file'
--
prompt upgrade_the_version_number
DECLARE
   TYPE tab_prod IS TABLE OF hig_products.hpr_product%TYPE INDEX BY BINARY_INTEGER;
   l_tab_prod tab_prod;
BEGIN
   l_tab_prod(1) := 'NET';
   l_tab_prod(2) := 'HIG';
   l_tab_prod(3) := 'DOC';
   FOR i IN 1..l_tab_prod.COUNT
    LOOP
      hig2.upgrade(l_tab_prod(i),'nm3081_nm3100_upg.sql','Upgrade from 3.0.8.1/3.0.8.2 to 3.1.0.0','3.1.0.0');
   END LOOP;
END;
/
COMMIT;
--
prompt CREATE synonyms that don't exist
EXECUTE nm3ddl.refresh_all_synonyms;
--
prompt recreate inventory VIEWS
EXEC nm3inv_view.create_all_inv_views;
--
prompt recreate inventory ON route VIEWS
EXEC nm3inv_view.create_all_inv_on_route_view;
--
PROMPT make sure .NEXTVAL on sequences is not less than values in associated tables
EXEC nm3ddl.rebuild_all_sequences;
--
SET feedback OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'trg'||'&terminator'||'restore_instead_trg.sql' run_file
FROM dual
/
START '&&run_file'
--
--- Run all post upgrade stuff here ---------------------------------------------------------
--
--
-- Performing population of linear types
--
PROMPT Populating Linear Types
PROMPT
SET serverout ON SIZE 1000000
SET lines 132
DECLARE

   CURSOR c_nm_types IS
      SELECT * from nm_types
       WHERE nt_datum = 'Y' 
         AND nt_linear = 'Y';
		 
   l_rec_nlt NM_LINEAR_TYPES%ROWTYPE;		 
		 
   CURSOR c_nm_group_types IS
      SELECT * from nm_group_types_all
       WHERE ngt_linear_flag = 'Y'
         AND ngt_sub_group_allowed = 'N';

   CURSOR c_get_unit(cp_nt_type IN nm_group_types_all.ngt_nt_type%TYPE) IS 
      SELECT * 
        FROM nm_types
       WHERE nt_type = cp_nt_type;
	 
   l_rec_nt	NM_TYPES%ROWTYPE;		 
		
BEGIN
   FOR recs IN c_nm_types LOOP
      BEGIN
         l_rec_nlt.nlt_id         := nm3seq.next_nlt_id_seq;
	 l_rec_nlt.nlt_nt_type    := recs.nt_type;
	 l_rec_nlt.nlt_descr      := recs.nt_descr;
	 l_rec_nlt.nlt_seq_no	  := 1;
	 l_rec_nlt.nlt_units	  := recs.nt_length_unit;
	 l_rec_nlt.nlt_start_date := trunc(sysdate);
	 l_rec_nlt.nlt_admin_type := recs.nt_admin_type;
	 l_rec_nlt.nlt_g_i_d	  := 'D';
  	 nm3ins.ins_nlt(p_rec_nlt => l_rec_nlt);
      EXCEPTION
         WHEN OTHERS THEN
             dbms_output.put_line('Error populating linear type from nm_types for '||'- '
                                   ||recs.nt_type||' - '||recs.nt_descr);
      END;
   END LOOP
   
   COMMIT;
   
   FOR recs IN c_nm_group_types LOOP
      BEGIN
   
         OPEN c_get_unit(cp_nt_type => recs.ngt_nt_type);
  	 FETCH c_get_unit INTO l_rec_nt;
	 CLOSE c_get_unit;

	 l_rec_nlt.nlt_id         := nm3seq.next_nlt_id_seq;
	 l_rec_nlt.nlt_nt_type    := recs.ngt_nt_type;
	 l_rec_nlt.nlt_gty_type	  := recs.ngt_group_type;
	 l_rec_nlt.nlt_descr      := recs.ngt_descr;
	 l_rec_nlt.nlt_seq_no	  := recs.ngt_search_group_no;
         l_rec_nlt.nlt_units	  := l_rec_nt.nt_length_unit;
	 l_rec_nlt.nlt_start_date := recs.ngt_start_date;
         l_rec_nlt.nlt_admin_type :=  l_rec_nt.nt_admin_type;
	 l_rec_nlt.nlt_g_i_d	  := 'G';
  	 nm3ins.ins_nlt(p_rec_nlt => l_rec_nlt);
      EXCEPTION 
          WHEN OTHERS THEN
              dbms_output.put_line('Error populating linear type from nm_group_types for '||'- '
                                    ||recs.ngt_nt_type||' - '||recs.ngt_group_type||' - '||recs.ngt_descr);
      END;
   END LOOP
   COMMIT;
END;
/

--
--- /Run all post upgrade stuff here ---------------------------------------------------------
--

SELECT 'Product update to version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ( 'HIG','NET');
--
EXIT

