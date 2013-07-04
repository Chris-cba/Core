--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3210_nm3211_ddl_upg.sql	1.10 05/23/06
--       Module Name      : nm3210_nm3211_ddl_upg.sql
--       Date into SCCS   : 06/05/23 15:45:02
--       Date fetched Out : 07/06/13 13:58:00
--       SCCS Version     : 1.10
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
--
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
--


---------------------------------------------------------------------------------------------
-- Derived Asset Changes
-- same pl/sql procedure as in 3210 to 4 upgrade (i.e. traps errors if already exists etc)
--
CREATE TABLE nm_mrg_nit_derivation
(nmnd_nit_inv_type          VARCHAR2(4)                                          NOT NULL
, nmnd_nmq_id                NUMBER                                              NOT NULL
, nmnd_last_refresh_date     DATE         DEFAULT TO_DATE('05111605','DDMMYYYY') NOT NULL
, nmnd_refresh_interval_days NUMBER(3)    DEFAULT 7                              NOT NULL
, nmnd_last_rebuild_date     DATE         DEFAULT TO_DATE('05111605','DDMMYYYY') NOT NULL
, nmnd_rebuild_interval_days NUMBER(3)    DEFAULT 28                             NOT NULL
, nmnd_maintain_history      VARCHAR2(1)  DEFAULT 'N'                            NOT NULL
, nmnd_nmu_id_admin          NUMBER(9)                                           NOT NULL
, nmnd_where_clause          VARCHAR2(4000)
, nmnd_date_created          DATE                                                NOT NULL
, nmnd_date_modified         DATE                                                NOT NULL
, nmnd_modified_by           VARCHAR2(30)                                        NOT NULL
, nmnd_created_by            VARCHAR2(30)                                        NOT NULL
)
/
--
ALTER TABLE nm_mrg_nit_derivation
 ADD CONSTRAINT nmnd_pk
 PRIMARY KEY (nmnd_nit_inv_type)
/
--
ALTER TABLE nm_mrg_nit_derivation
 ADD CONSTRAINT nmnd_nit_fk
 FOREIGN KEY (nmnd_nit_inv_type)
 REFERENCES nm_inv_types_all (nit_inv_type)
 ON DELETE CASCADE
/
--
ALTER TABLE nm_mrg_nit_derivation
 ADD CONSTRAINT nmnd_nmu_fk
 FOREIGN KEY (nmnd_nmu_id_admin)
 REFERENCES nm_mail_users (nmu_id)
/	
--
CREATE INDEX nmnd_nmu_fk_ind ON nm_mrg_nit_derivation(nmnd_nmu_id_admin)
/	
--
ALTER TABLE nm_mrg_nit_derivation
 ADD CONSTRAINT nmnd_maintain_history_chk
 CHECK (nmnd_maintain_history IN ('Y','N'))
/
--
ALTER TABLE nm_mrg_nit_derivation
 ADD CONSTRAINT nmnd_nmq_fk
 FOREIGN KEY (nmnd_nmq_id)
 REFERENCES nm_mrg_query_all (nmq_id)
/	
--
CREATE INDEX nmnd_nmq_fk_ind ON nm_mrg_nit_derivation (nmnd_nmq_id)
/	
--
CREATE GLOBAL TEMPORARY TABLE nm_mrg_inv_derivation_nte_temp
   (nte_job_id      NUMBER      NOT NULL
   ,item_type_type  VARCHAR2(4)
   ,item_type       VARCHAR2(4)
   )
/
-- CP 22/05/2006 Add missing constraint/index
ALTER TABLE NM_MRG_INV_DERIVATION_NTE_TEMP
 ADD (CONSTRAINT NM_MRG_INV_DERIVATION_NT_PK PRIMARY KEY 
   (NTE_JOB_ID))
/
--
CREATE TABLE nm_mrg_nit_derivation_nw
   (nmndn_nmnd_nit_inv_type VARCHAR2(4)    NOT NULL
   ,nmndn_nt_type           VARCHAR2(4)    NOT NULL
   ,nmndn_date_created      DATE           NOT NULL
   ,nmndn_date_modified     DATE           NOT NULL
   ,nmndn_modified_by       VARCHAR2(30)   NOT NULL
   ,nmndn_created_by        VARCHAR2(30)   NOT NULL
   )
/	
--
ALTER TABLE nm_mrg_nit_derivation_nw
 ADD CONSTRAINT nmndn_pk
 PRIMARY KEY (nmndn_nmnd_nit_inv_type,nmndn_nt_type)
/	
--
ALTER TABLE nm_mrg_nit_derivation_nw
 ADD CONSTRAINT nmndn_nmnd_fk
 FOREIGN KEY (nmndn_nmnd_nit_inv_type)
 REFERENCES nm_mrg_nit_derivation (nmnd_nit_inv_type)
 ON DELETE CASCADE
/	
--
ALTER TABLE nm_mrg_nit_derivation_nw
 ADD CONSTRAINT nmndn_nt_fk
 FOREIGN KEY (nmndn_nt_type)
 REFERENCES nm_types (nt_type)
 ON DELETE CASCADE
/	
--
CREATE INDEX nmndn_nt_fk_ind ON nm_mrg_nit_derivation_nw (nmndn_nt_type)
/
--
CREATE TABLE nm_mrg_ita_derivation
   (nmid_ita_inv_type    VARCHAR2(4)    NOT NULL
   ,nmid_ita_attrib_name VARCHAR2(30)   NOT NULL
   ,nmid_seq_no          NUMBER(3)      NOT NULL
   ,nmid_derivation      VARCHAR2(4000) NOT NULL
   ,nmid_date_created    DATE           NOT NULL
   ,nmid_date_modified   DATE           NOT NULL
   ,nmid_modified_by     VARCHAR2(30)   NOT NULL
   ,nmid_created_by      VARCHAR2(30)   NOT NULL
   )
/	
--
ALTER TABLE nm_mrg_ita_derivation
 ADD CONSTRAINT nmita_pk
 PRIMARY KEY (nmid_ita_inv_type,nmid_ita_attrib_name)
/	
--
ALTER TABLE nm_mrg_ita_derivation
 ADD CONSTRAINT nmita_uk
 UNIQUE (nmid_ita_inv_type,nmid_seq_no)
/	
--
ALTER TABLE nm_mrg_ita_derivation
 ADD CONSTRAINT nmita_nmnd_fk
 FOREIGN KEY (nmid_ita_inv_type)
 REFERENCES nm_mrg_nit_derivation (nmnd_nit_inv_type)
 ON DELETE CASCADE
/	
--
ALTER TABLE nm_mrg_ita_derivation
 ADD CONSTRAINT nmita_ita_attrib_name_chk
 CHECK (nmid_ita_attrib_name = UPPER(nmid_ita_attrib_name))
/	
--
ALTER TABLE nm_mrg_ita_derivation
 ADD CONSTRAINT nmita_seq_no_chk
 CHECK (nmid_seq_no > 0)
/	
--
CREATE TABLE nm_mrg_nit_derivation_refresh
   (nmndr_nmnd_nit_inv_type   VARCHAR2(4)    NOT NULL
   ,nmndr_refresh_start_date  DATE           NOT NULL
   ,nmndr_refresh_finish_date DATE
   )
/	
--
ALTER TABLE nm_mrg_nit_derivation_refresh
 ADD CONSTRAINT nmndr_nmnd_fk
 FOREIGN KEY (nmndr_nmnd_nit_inv_type)
 REFERENCES nm_mrg_nit_derivation (nmnd_nit_inv_type)
 ON DELETE CASCADE
/	
--
CREATE INDEX nmndr_nmnd_fk_ind ON nm_mrg_nit_derivation_refresh(nmndr_nmnd_nit_inv_type)
/	
--
-- End of Derived Asset Changes
-------------------------------


-----------------------------------------------
-- Theme,Base Theme and GIS Data Object Changes
-- same pl/sql procedure as in 3210 to 4 upgrade (i.e. traps errors if already exists etc)
--
--
CREATE TABLE NM_BASE_THEMES
(
  NBTH_THEME_ID    NUMBER(9)                    NOT NULL,
  NBTH_BASE_THEME  NUMBER(9)                    NOT NULL
)
/
--
CREATE INDEX NBTH_BASE_IDX ON NM_BASE_THEMES
(NBTH_BASE_THEME)
/
--

CREATE UNIQUE INDEX NBTH_PK ON NM_BASE_THEMES
(NBTH_THEME_ID, NBTH_BASE_THEME)
/	
--
ALTER TABLE NM_BASE_THEMES ADD (
  CONSTRAINT NBTH_PK PRIMARY KEY (NBTH_THEME_ID, NBTH_BASE_THEME))
/	
--
ALTER TABLE NM_BASE_THEMES ADD (
  CONSTRAINT NBTH_BASE_FK FOREIGN KEY (NBTH_BASE_THEME) 
    REFERENCES NM_THEMES_ALL (NTH_THEME_ID)
    ON DELETE CASCADE)
/	
--
ALTER TABLE NM_BASE_THEMES ADD (
  CONSTRAINT NBTH_NTH_FK FOREIGN KEY (NBTH_THEME_ID) 
    REFERENCES NM_THEMES_ALL (NTH_THEME_ID)
    ON DELETE CASCADE)
/	
--
    insert into nm_base_themes
   (  nbth_theme_id
    , nbth_base_theme )
   select nth_theme_id
        , nth_base_theme
   from nm_themes_all
   where nth_base_theme is not null
   and not exists (select 1
                   from nm_base_themes
                   where nbth_theme_id = nth_theme_id);
--
alter table nm_themes_all
drop column nth_base_theme
/
--
alter table nm_themes_all
add nth_dynamic_theme varchar2(1)
/
--
update nm_themes_all
set nth_dynamic_theme = 'N';
--
alter table nm_themes_all
modify nth_dynamic_theme not null
/   
--
alter table nm_themes_all modify nth_dynamic_theme default 'N'
/
--
alter table gis_data_objects
add gdo_dynamic_theme varchar2(1) default 'N'
/   
--
alter table gis_data_objects
add gdo_string  varchar2(2000) default null
/
--
drop table nm_layer_sets
/
--
drop view nm_layers
/
--
-- End of Theme,Base Theme and GIS Data Object Changes
------------------------------------------------------


----------------------------------------------------------------------------------------------
-- Merge Geometry Changes
-- same pl/sql procedure as in 3210 to 4 upgrade (i.e. traps errors if already exists etc)
--

CREATE TABLE NM_MRG_GEOMETRY
(
  NMG_JOB_ID      NUMBER                        NOT NULL,
  NMG_SECTION_ID  NUMBER                        NOT NULL,
  NMG_GEOMETRY    MDSYS.SDO_GEOMETRY,
  NMG_ID          INTEGER                       NOT NULL
)
/
--
CREATE UNIQUE INDEX NM_MRG_GEO_UK ON NM_MRG_GEOMETRY
(NMG_JOB_ID, NMG_SECTION_ID)
/ 
--
CREATE UNIQUE INDEX NM_MRG_GEO_PK ON NM_MRG_GEOMETRY (NMG_ID)
/ 
--
-- moved elswhere in the upgrade so that the index can be registered and then created
--
--
--CREATE INDEX NM_MRG_GEO_SPIDX ON NM_MRG_GEOMETRY
--(NMG_GEOMETRY)
--INDEXTYPE IS MDSYS.SPATIAL_INDEX
--  
--
ALTER TABLE NM_MRG_GEOMETRY ADD (
  CONSTRAINT NM_MRG_GEO_PK PRIMARY KEY (NMG_ID)
    USING INDEX)
/ 
--
ALTER TABLE NM_MRG_GEOMETRY ADD (
  CONSTRAINT NM_MRG_GEO_UK UNIQUE (NMG_JOB_ID, NMG_SECTION_ID)
    USING INDEX)
/  
--
ALTER TABLE NM_MRG_GEOMETRY ADD (
  CONSTRAINT NMGEO_FK_SCT FOREIGN KEY (NMG_job_id, nmg_section_id) 
    REFERENCES NM_MRG_SECTIONS_ALL (nms_mrg_job_id, nms_mrg_section_id )
    ON DELETE CASCADE)
/  
--
create sequence nms_id_seq
/  	
--
-- End of Merge Geometry Changes
--------------------------------




----------------------------------------
-- Start of New Spatial Server Table etc
--
CREATE TABLE NM3SDM_DYN_SEG_EX
( NDSE_ID            INTEGER,
  NDSE_JOB_ID        INTEGER,
  NDSE_NER_ID        INTEGER,
  NDSE_NE_ID_IN      INTEGER,
  NDSE_NE_ID_OF      INTEGER,
  NDSE_SHAPE_LENGTH  NUMBER,
  NDSE_NE_LENGTH     NUMBER,
  NDSE_START         NUMBER,
  NDSE_END           NUMBER,
  NDSE_SQLERRM       VARCHAR2(100)
)
/
CREATE INDEX ndse_job_idx ON nm3sdm_dyn_seg_ex ( ndse_job_id )
/
ALTER TABLE NM3SDM_DYN_SEG_EX ADD (
  CONSTRAINT NDSE_PK PRIMARY KEY (NDSE_ID)
    USING INDEX )
/	
CREATE SEQUENCE ndse_id_seq
/
--
-- End of New Spatial Server Table etc
----------------------------------------


--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************








