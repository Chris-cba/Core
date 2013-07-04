------------------------------------------------------------------
-- nm4010_nm4022_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/nm3/install/nm4010_nm4022_ddl_upg.sql-arc   2.1   Jul 04 2013 14:09:48   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4010_nm4022_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:09:48  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:20  $
--       PVCS Version     : $Revision:   2.1  $
--       Based on SCCS version :
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
PROMPT Disabling GIS_DATA_OBJECTS primary key constraint
SET TERM OFF

-- GJ  30-JUL-2007
--
-- DEVELOPMENT COMMENTS
-- The PK constraint on GIS_DATA_OBJECTS was enabled at release 4.0.1.0, but there are still some areas of code which require the constraint to be disabled.
-- The key should revert back to being disabled and be substituted with a non-unique index.
------------------------------------------------------------------
alter table gis_data_objects disable primary key;


DECLARE
 ex_no_bother EXCEPTION;
 pragma exception_init(ex_no_bother,-955);
BEGIN
 EXECUTE IMMEDIATE ('CREATE INDEX GDO_IDX ON GIS_DATA_OBJECTS ( GDO_SESSION_ID, GDO_PK_ID )');
EXCEPTION
  WHEN ex_no_bother THEN
   Null;
END;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Grant DROP ANY SYNONYM to HIG_ADMIN role
SET TERM OFF

-- GJ  16-MAY-2007
--
-- DEVELOPMENT COMMENTS
-- HIG1832 was reporting a "You do not have permission to perform this action" error message.
-- Problem was due to lack of DROP ANY SYNONYM priv - which caused nm3sdm.Create_Msv_Feature_Views to raise the exception.
------------------------------------------------------------------
GRANT DROP ANY SYNONYM to HIG_ADMIN
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New indexes on FK constrained columns, where no suitable index already exists
SET TERM OFF

-- GJ  13-JUN-2007
--
-- DEVELOPMENT COMMENTS
-- All FK constrained columns should be indexed.
-- This DDL will add new indexes to existing tables that have been identified as needing such constraints.
------------------------------------------------------------------
DECLARE

 ex_ignore exception;
 pragma exception_init(ex_ignore,-955);

BEGIN

  BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX HAG_FK2_HAU_IND ON NM_ADMIN_GROUPS(NAG_CHILD_ADMIN_UNIT)';
   EXCEPTION
   WHEN ex_ignore THEN
      Null;
   WHEN others THEN
      RAISE;
  END;

  BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX NUA_NAU_FK_IND ON NM_USER_AUS_ALL(NUA_ADMIN_UNIT)';
  EXCEPTION
   WHEN ex_ignore THEN
      Null;
   WHEN others THEN
      RAISE;
  END;

END;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Upgrade nm_element_history
SET TERM OFF

-- AE  19-JUL-2007
--
-- DEVELOPMENT COMMENTS
-- KA: Recreate nm_element_history with new structure and populate with data from original table.
------------------------------------------------------------------
CREATE TABLE nm_element_history_old AS SELECT * FROM nm_element_history;

SET serverout ON SIZE 1000000

DECLARE
  PROCEDURE drop_con(pi_tab IN varchar2
                    ,pi_con IN varchar2
                    ) IS

    e_nonexistent_tab EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_nonexistent_tab, -942);

    e_nonexistent_con EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_nonexistent_con, -2443);

  BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ' || pi_tab || ' DROP CONSTRAINT ' || pi_con;
    dbms_output.put_line('Dropped constraint ' || pi_tab || '.' || pi_con);

  EXCEPTION
    WHEN e_nonexistent_tab
      OR e_nonexistent_con
    THEN
      NULL;

  END drop_con;
BEGIN
  drop_con(pi_tab => 'nm_members_all'
          ,pi_con => 'nmh_neh_fk');
  drop_con(pi_tab => 'acc_location_history'
          ,pi_con => 'alh_neh_fk');
  drop_con(pi_tab => 'stp_scheme_loc_datum_history'
          ,pi_con => 'ssldh_neh_fk');
  drop_con(pi_tab => 'road_int_history'
          ,pi_con => 'rih_neh_fk');
END;
/

SET serverout OFF

DROP TABLE nm_element_history CASCADE CONSTRAINTS;

CREATE TABLE nm_element_history
(
  neh_id              number(9)                 NOT NULL,
  neh_ne_id_old       number(9)                 NOT NULL,
  neh_ne_id_new       number(9)                 NOT NULL,
  neh_operation       varchar2(1)               NOT NULL,
  neh_effective_date  date                      NOT NULL,
  neh_actioned_date   date                      DEFAULT trunc(sysdate) NOT NULL,
  neh_actioned_by     varchar2(30)              DEFAULT user NOT NULL,
  neh_old_ne_length   number,
  neh_new_ne_length   number,
  neh_param_1         number,
  neh_param_2         number
);

COMMENT ON TABLE nm_element_history IS 'This table contains a list of all the split and merged section';

CREATE UNIQUE INDEX neh_pk ON nm_element_history
(neh_id);

CREATE INDEX neh_ne_id_old_new_ind ON nm_element_history
(neh_ne_id_old, neh_ne_id_new);

CREATE INDEX neh_ne_id_new_fk_ind ON nm_element_history
(neh_ne_id_new);

ALTER TABLE nm_element_history ADD (
  CONSTRAINT neh_pk
 PRIMARY KEY
 (neh_id));

ALTER TABLE nm_element_history ADD (
CONSTRAINT neh_ne_id_new_fk
FOREIGN KEY (neh_ne_id_new)
REFERENCES nm_elements_all (ne_id));

ALTER TABLE nm_element_history ADD (
CONSTRAINT neh_ne_id_old_fk
FOREIGN KEY (neh_ne_id_old)
REFERENCES nm_elements_all (ne_id));

CREATE SEQUENCE neh_id_seq
  START WITH 1
  MINVALUE 1
  NOCYCLE
  CACHE 20;

INSERT INTO
  nm_element_history(neh_id
                    ,neh_ne_id_old
                    ,neh_ne_id_new
                    ,neh_operation
                    ,neh_effective_date
                    ,neh_actioned_date
                    ,neh_actioned_by)
                    --,neh_old_ne_length
                    --,neh_new_ne_length
                    --,neh_param_1
                    --,neh_param_2)
SELECT
  neh_id_seq.NEXTVAL,
  nehv.neh_ne_id_old,
  nehv.neh_ne_id_new,
  nehv.neh_operation,
  nehv.neh_effective_date,
  nehv.neh_actioned_date,
  nehv.neh_actioned_by
FROM
  (SELECT
     neho.*
   FROM
     nm_element_history_old neho
   ORDER BY
     neho.neh_actioned_date) nehv;

DROP TABLE NM_ELEMENT_HISTORY_OLD;
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT NM_CHARACTER_SETS
SET TERM OFF

-- GJ  26-SEP-2007
--
-- ASSOCIATED LOG#
-- 709074
--
-- CUSTOMER
-- Hampshire County Council
--
-- PROBLEM
-- Two issues within SM/NM3. 1. Invalid characters in earlier closed version of USRNs and 2. Identical version of USRNs
--
-- DEVELOPMENT COMMENTS
-- To police whether or not a string contains characters within a given set a new group of tables has been introduced into which metadata can be added
------------------------------------------------------------------
CREATE TABLE NM_CHARACTER_SETS
(
  NCS_CODE         VARCHAR2(20)            NOT NULL,
  NCS_DESCRIPTION  VARCHAR2(100)           NOT NULL
)
;

comment on table nm_character_sets is 'Character set definitions';
comment on column nm_character_sets.ncs_code is 'Unique identifier';
comment on column nm_character_sets.ncs_description is 'Description';

ALTER TABLE NM_CHARACTER_SETS ADD (
  CONSTRAINT NCS_PK
 PRIMARY KEY
 (NCS_CODE))
;



CREATE TABLE NM_CHARACTER_SET_MEMBERS
(
  NCSM_NCS_CODE         VARCHAR2(20)       NOT NULL,
  NCSM_ASCII_CHARACTER  NUMBER(3)               NOT NULL
)
;

comment on table nm_character_set_members is 'Character set characters';
comment on column nm_character_set_members.ncsm_ncs_code is 'Unique identifier of character set';
comment on column nm_character_set_members.ncsm_ascii_character is 'ASCII Character';

ALTER TABLE NM_CHARACTER_SET_MEMBERS ADD (
  CONSTRAINT NCSM_PK
 PRIMARY KEY
 (NCSM_NCS_CODE, NCSM_ASCII_CHARACTER));


ALTER TABLE NM_CHARACTER_SET_MEMBERS ADD (
  CONSTRAINT NCSM_NCS_FK
 FOREIGN KEY (NCSM_NCS_CODE)
 REFERENCES NM_CHARACTER_SETS (NCS_CODE));

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Drop nm_special_chars table
SET TERM OFF

-- MAX  08-AUG-2007
--
-- ASSOCIATED LOG#
-- 709074
--
-- CUSTOMER
-- Hampshire County Council
--
-- PROBLEM
-- Two issues within SM/NM3. 1. Invalid characters in earlier closed version of USRNs and 2. Identical version of USRNs
--
-- DEVELOPMENT COMMENTS
-- Table dropped and contents now part of nm_character_sets and nm_character_set_members table structures and functionality under ncs_code = 'INVALID_FOR_DDL'.  Chris has updated designer for the DDL changes,
------------------------------------------------------------------
BEGIN
 EXECUTE IMMEDIATE ('drop table nm_special_chars');
EXCEPTION
  WHEN others THEN
   Null;
END;
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New table - NM_THEMES_VISIBLE
SET TERM OFF

-- AE  12-SEP-2007
--
-- DEVELOPMENT COMMENTS
-- Add new table (NM_THEMES_VISIBLE)
------------------------------------------------------------------
CREATE TABLE nm_themes_visible
  ( ntv_nth_theme_id NUMBER(9) NOT NULL
  , ntv_visible VARCHAR2(1) NOT NULL);

ALTER TABLE nm_themes_visible
 ADD (CONSTRAINT ntv_pk PRIMARY KEY (ntv_nth_theme_id));


ALTER TABLE nm_themes_visible ADD (
  CONSTRAINT ntv_visible_yn_chk
 CHECK (ntv_visible IN ('Y','N')));

ALTER TABLE nm_themes_visible ADD (
  CONSTRAINT ntv_nth_fk
 FOREIGN KEY (ntv_nth_theme_id)
 REFERENCES nm_themes_all (nth_theme_id)
    ON DELETE CASCADE);

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT IIT_LENGTH format change
SET TERM OFF

-- PT  18-SEP-2007
--
-- DEVELOPMENT COMMENTS
-- Change IIT_LENGTH from NUMBER(6) to NUMBER. This copies the iit_length values out into a table zz_iit_length_change_tmp. The table can be dropped manually once all ok. This script no longer compiles the schema.
------------------------------------------------------------------

-- dropping temp table
prompt dropping temp table ...
declare
  table_not_found exception;
  pragma exception_init(table_not_found, -942);
begin
  execute immediate 'drop table zz_iit_length_change_tmp';
exception
  when table_not_found then
    null;
end;
/


-- creating temp table
prompt creating temp table ...
create table zz_iit_length_change_tmp
pctfree 0
nologging
as
select iit_ne_id, iit_length
from nm_inv_items_all
where 1 = 0
/

-- populating temp table
prompt populating temp table ...
insert /*+ append */
into zz_iit_length_change_tmp (
  iit_ne_id, iit_length
)
select iit_ne_id, iit_length
from nm_inv_items_all
where iit_length is not null
/


-- creating temp primary key
prompt creating temp primary key ...
alter table zz_iit_length_change_tmp add (
constraint zziit_pk primary key (iit_ne_id)
)
/

-- locking nm_inv_items_all
prompt locking nm_inv_items_all ...
lock table nm_inv_items_all in exclusive mode nowait
/


-- disabling nm_inv_items_all triggers
prompt disabling nm_inv_items_all triggers ...
begin
for r in (
  select t.trigger_name from user_triggers t
  where t.table_name = 'NM_INV_ITEMS_ALL'
)
loop
  execute immediate 'alter trigger '||r.trigger_name||' disable';
end loop;
end;
/


-- updating iit_length to null
prompt updating iit_length to null ...
update nm_inv_items_all
set iit_length = null
where iit_length is not null
/


-- modifying nm_inv_items_all
prompt modifying nm_inv_items_all ...
alter table nm_inv_items_all modify (
  iit_length number
)
/


-- compile the nm_inv_items_all security policy package
-- the next step could fail otherwise
prompt compiling invsec package
alter package invsec compile
/
alter package invsec compile body
/


-- restoring iit_length values
prompt restoring iit_length values ...
update (
select i.iit_length, t.iit_length iit_length_tmp
from
   nm_inv_items_all i
  ,zz_iit_length_change_tmp t
where i.iit_ne_id = t.iit_ne_id
)
set iit_length = iit_length_tmp
/


commit
/

-- enabling nm_inv_item_triggers
prompt enabling nm_inv_item_triggers ...
begin
for r in (
  select t.trigger_name from user_triggers t
  where t.table_name = 'NM_INV_ITEMS_ALL'
)
loop
  execute immediate 'alter trigger '||r.trigger_name||' enable';
end loop;
end;
/


-- dropping temp table
-- prompt dropping temp table ...
-- drop table zz_iit_length_change_tmp
--/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT NM_MRG_NIT_DERIVATION change
SET TERM OFF

-- PT  18-SEP-2007
--
-- DEVELOPMENT COMMENTS
-- Added columns for new solution Derived Assets
------------------------------------------------------------------
ALTER TABLE NM_MRG_NIT_DERIVATION
 ADD (NMND_NT_TYPE  VARCHAR2(4))
/

ALTER TABLE NM_MRG_NIT_DERIVATION
 ADD (NMND_NGT_GROUP_TYPE  VARCHAR2(4))
/


ALTER TABLE NM_MRG_NIT_DERIVATION ADD
CONSTRAINT NMND_NT_FK
 FOREIGN KEY (NMND_NT_TYPE)
 REFERENCES NM_TYPES (NT_TYPE) ENABLE
 VALIDATE
/

ALTER TABLE NM_MRG_NIT_DERIVATION ADD
CONSTRAINT NMND_NGT_FK
 FOREIGN KEY (NMND_NGT_GROUP_TYPE)
 REFERENCES NM_GROUP_TYPES_ALL (NGT_GROUP_TYPE) ENABLE
 VALIDATE
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Create nm_mrg_derived_inv_values_tmp
SET TERM OFF

-- PT  18-SEP-2007
--
-- DEVELOPMENT COMMENTS
-- Temp table for bulk derived assets
------------------------------------------------------------------
create global temporary table nm_mrg_derived_inv_values_tmp
(
  mrg_job_id                 number(9),
  mrg_section_id             number(9),
  iit_ne_id                  number(9),
  iit_inv_type               varchar2(4),
  iit_primary_key            varchar2(50),
  iit_start_date             date,
  iit_date_created           date,
  iit_date_modified          date,
  iit_created_by             varchar2(30),
  iit_modified_by            varchar2(30),
  iit_admin_unit             number(9),
  iit_descr                  varchar2(40),
  iit_end_date               date,
  iit_foreign_key            varchar2(50),
  iit_located_by             number(9),
  iit_position               number,
  iit_x_coord                number,
  iit_y_coord                number,
  iit_num_attrib16           number,
  iit_num_attrib17           number,
  iit_num_attrib18           number,
  iit_num_attrib19           number,
  iit_num_attrib20           number,
  iit_num_attrib21           number,
  iit_num_attrib22           number,
  iit_num_attrib23           number,
  iit_num_attrib24           number,
  iit_num_attrib25           number,
  iit_chr_attrib26           varchar2(50),
  iit_chr_attrib27           varchar2(50),
  iit_chr_attrib28           varchar2(50),
  iit_chr_attrib29           varchar2(50),
  iit_chr_attrib30           varchar2(50),
  iit_chr_attrib31           varchar2(50),
  iit_chr_attrib32           varchar2(50),
  iit_chr_attrib33           varchar2(50),
  iit_chr_attrib34           varchar2(50),
  iit_chr_attrib35           varchar2(50),
  iit_chr_attrib36           varchar2(50),
  iit_chr_attrib37           varchar2(50),
  iit_chr_attrib38           varchar2(50),
  iit_chr_attrib39           varchar2(50),
  iit_chr_attrib40           varchar2(50),
  iit_chr_attrib41           varchar2(50),
  iit_chr_attrib42           varchar2(50),
  iit_chr_attrib43           varchar2(50),
  iit_chr_attrib44           varchar2(50),
  iit_chr_attrib45           varchar2(50),
  iit_chr_attrib46           varchar2(50),
  iit_chr_attrib47           varchar2(50),
  iit_chr_attrib48           varchar2(50),
  iit_chr_attrib49           varchar2(50),
  iit_chr_attrib50           varchar2(50),
  iit_chr_attrib51           varchar2(50),
  iit_chr_attrib52           varchar2(50),
  iit_chr_attrib53           varchar2(50),
  iit_chr_attrib54           varchar2(50),
  iit_chr_attrib55           varchar2(50),
  iit_chr_attrib56           varchar2(200),
  iit_chr_attrib57           varchar2(200),
  iit_chr_attrib58           varchar2(200),
  iit_chr_attrib59           varchar2(200),
  iit_chr_attrib60           varchar2(200),
  iit_chr_attrib61           varchar2(200),
  iit_chr_attrib62           varchar2(200),
  iit_chr_attrib63           varchar2(200),
  iit_chr_attrib64           varchar2(200),
  iit_chr_attrib65           varchar2(200),
  iit_chr_attrib66           varchar2(500),
  iit_chr_attrib67           varchar2(500),
  iit_chr_attrib68           varchar2(500),
  iit_chr_attrib69           varchar2(500),
  iit_chr_attrib70           varchar2(500),
  iit_chr_attrib71           varchar2(500),
  iit_chr_attrib72           varchar2(500),
  iit_chr_attrib73           varchar2(500),
  iit_chr_attrib74           varchar2(500),
  iit_chr_attrib75           varchar2(500),
  iit_num_attrib76           number,
  iit_num_attrib77           number,
  iit_num_attrib78           number,
  iit_num_attrib79           number,
  iit_num_attrib80           number,
  iit_num_attrib81           number,
  iit_num_attrib82           number,
  iit_num_attrib83           number,
  iit_num_attrib84           number,
  iit_num_attrib85           number,
  iit_date_attrib86          date,
  iit_date_attrib87          date,
  iit_date_attrib88          date,
  iit_date_attrib89          date,
  iit_date_attrib90          date,
  iit_date_attrib91          date,
  iit_date_attrib92          date,
  iit_date_attrib93          date,
  iit_date_attrib94          date,
  iit_date_attrib95          date,
  iit_angle                  number(6,2),
  iit_angle_txt              varchar2(20),
  iit_class                  varchar2(2),
  iit_class_txt              varchar2(20),
  iit_colour                 varchar2(2),
  iit_colour_txt             varchar2(20),
  iit_coord_flag             varchar2(1),
  iit_description            varchar2(40),
  iit_diagram                varchar2(6),
  iit_distance               number(7,2),
  iit_end_chain              number(6),
  iit_gap                    number(6,2),
  iit_height                 number(6,2),
  iit_height_2               number(6,2),
  iit_id_code                varchar2(8),
  iit_instal_date            date,
  iit_invent_date            date,
  iit_inv_ownership          varchar2(4),
  iit_itemcode               varchar2(8),
  iit_lco_lamp_config_id     number(3),
  iit_length                 number,
  iit_material               varchar2(30),
  iit_material_txt           varchar2(20),
  iit_method                 varchar2(2),
  iit_method_txt             varchar2(20),
  iit_note                   varchar2(40),
  iit_no_of_units            number(3),
  iit_options                varchar2(2),
  iit_options_txt            varchar2(20),
  iit_oun_org_id_elec_board  number(8),
  iit_owner                  varchar2(4),
  iit_owner_txt              varchar2(20),
  iit_peo_invent_by_id       number(8),
  iit_photo                  varchar2(6),
  iit_power                  number(6),
  iit_prov_flag              varchar2(1),
  iit_rev_by                 varchar2(20),
  iit_rev_date               date,
  iit_type                   varchar2(2),
  iit_type_txt               varchar2(20),
  iit_width                  number(6,2),
  iit_xtra_char_1            varchar2(20),
  iit_xtra_date_1            date,
  iit_xtra_domain_1          varchar2(2),
  iit_xtra_domain_txt_1      varchar2(20),
  iit_xtra_number_1          number(10,2),
  iit_x_sect                 varchar2(4),
  iit_det_xsp                varchar2(4),
  iit_offset                 number,
  iit_x                      number,
  iit_y                      number,
  iit_z                      number,
  iit_num_attrib96           number,
  iit_num_attrib97           number,
  iit_num_attrib98           number,
  iit_num_attrib99           number,
  iit_num_attrib100          number,
  iit_num_attrib101          number,
  iit_num_attrib102          number,
  iit_num_attrib103          number,
  iit_num_attrib104          number,
  iit_num_attrib105          number,
  iit_num_attrib106          number,
  iit_num_attrib107          number,
  iit_num_attrib108          number,
  iit_num_attrib109          number,
  iit_num_attrib110          number,
  iit_num_attrib111          number,
  iit_num_attrib112          number,
  iit_num_attrib113          number,
  iit_num_attrib114          number,
  iit_num_attrib115          number
)
on commit preserve rows
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Create nm_mrg_datum_homo_chunks_tmp
SET TERM OFF

-- PT  18-SEP-2007
--
-- DEVELOPMENT COMMENTS
-- temp table for bulk merge
------------------------------------------------------------------
CREATE global temporary TABLE nm_mrg_datum_homo_chunks_tmp
(
  NM_NE_ID_OF        NUMBER(9),
  NM_BEGIN_MP        NUMBER,
  NM_END_MP          NUMBER,
  HASH_VALUE         VARCHAR2(14),
  CHUNK_COUNT        NUMBER,
  OBJ_TYPE_COUNT     NUMBER,
  OBJ_COUNT          NUMBER,
  NM_DATE_MODIFIED   DATE,
  IIT_DATE_MODIFIED  DATE
)
on commit preserve rows
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Create nm_mrg_split_results_tmp
SET TERM OFF

-- PT  18-SEP-2007
--
-- DEVELOPMENT COMMENTS
-- temp table for bulk merge
------------------------------------------------------------------
CREATE global temporary TABLE nm_mrg_split_results_tmp
(
  NM_NE_ID_OF        NUMBER(9),
  NM_BEGIN_MP        NUMBER,
  NM_END_MP          NUMBER,
  NM_NE_ID_IN        NUMBER(9),
  NM_OBJ_TYPE        VARCHAR2(4),
  NM_TYPE            VARCHAR2(4),
  NM_DATE_MODIFIED   DATE,
  IIT_ROWID          ROWID,
  IIT_DATE_MODIFIED  DATE
)
on commit preserve rows
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Create NM_MRG_SECTION_INV_VALUES_TMP
SET TERM OFF

-- PT  18-SEP-2007
--
-- DEVELOPMENT COMMENTS
-- temp table for bulk derived assets
------------------------------------------------------------------
CREATE GLOBAL TEMPORARY TABLE NM_MRG_SECTION_INV_VALUES_TMP
(
  NSI_MRG_SECTION_ID  NUMBER                    NOT NULL,
  NSV_MRG_JOB_ID      NUMBER                    NOT NULL,
  NSV_VALUE_ID        NUMBER                    NOT NULL,
  NSV_INV_TYPE        VARCHAR2(30)         NOT NULL,
  NSV_X_SECT          VARCHAR2(4),
  NSV_PNT_OR_CONT     VARCHAR2(1)          NOT NULL,
  NSV_ATTRIB1         VARCHAR2(500),
  NSV_ATTRIB2         VARCHAR2(500),
  NSV_ATTRIB3         VARCHAR2(500),
  NSV_ATTRIB4         VARCHAR2(500),
  NSV_ATTRIB5         VARCHAR2(500),
  NSV_ATTRIB6         VARCHAR2(500),
  NSV_ATTRIB7         VARCHAR2(500),
  NSV_ATTRIB8         VARCHAR2(500),
  NSV_ATTRIB9         VARCHAR2(500),
  NSV_ATTRIB10        VARCHAR2(500),
  NSV_ATTRIB11        VARCHAR2(500),
  NSV_ATTRIB12        VARCHAR2(500),
  NSV_ATTRIB13        VARCHAR2(500),
  NSV_ATTRIB14        VARCHAR2(500),
  NSV_ATTRIB15        VARCHAR2(500),
  NSV_ATTRIB16        VARCHAR2(500),
  NSV_ATTRIB17        VARCHAR2(500),
  NSV_ATTRIB18        VARCHAR2(500),
  NSV_ATTRIB19        VARCHAR2(500),
  NSV_ATTRIB20        VARCHAR2(500),
  NSV_ATTRIB21        VARCHAR2(500),
  NSV_ATTRIB22        VARCHAR2(500),
  NSV_ATTRIB23        VARCHAR2(500),
  NSV_ATTRIB24        VARCHAR2(500),
  NSV_ATTRIB25        VARCHAR2(500),
  NSV_ATTRIB26        VARCHAR2(500),
  NSV_ATTRIB27        VARCHAR2(500),
  NSV_ATTRIB28        VARCHAR2(500),
  NSV_ATTRIB29        VARCHAR2(500),
  NSV_ATTRIB30        VARCHAR2(500),
  NSV_ATTRIB31        VARCHAR2(500),
  NSV_ATTRIB32        VARCHAR2(500),
  NSV_ATTRIB33        VARCHAR2(500),
  NSV_ATTRIB34        VARCHAR2(500),
  NSV_ATTRIB35        VARCHAR2(500),
  NSV_ATTRIB36        VARCHAR2(500),
  NSV_ATTRIB37        VARCHAR2(500),
  NSV_ATTRIB38        VARCHAR2(500),
  NSV_ATTRIB39        VARCHAR2(500),
  NSV_ATTRIB40        VARCHAR2(500),
  NSV_ATTRIB41        VARCHAR2(500),
  NSV_ATTRIB42        VARCHAR2(500),
  NSV_ATTRIB43        VARCHAR2(500),
  NSV_ATTRIB44        VARCHAR2(500),
  NSV_ATTRIB45        VARCHAR2(500),
  NSV_ATTRIB46        VARCHAR2(500),
  NSV_ATTRIB47        VARCHAR2(500),
  NSV_ATTRIB48        VARCHAR2(500),
  NSV_ATTRIB49        VARCHAR2(500),
  NSV_ATTRIB50        VARCHAR2(500),
  NSV_ATTRIB51        VARCHAR2(500),
  NSV_ATTRIB52        VARCHAR2(500),
  NSV_ATTRIB53        VARCHAR2(500),
  NSV_ATTRIB54        VARCHAR2(500),
  NSV_ATTRIB55        VARCHAR2(500),
  NSV_ATTRIB56        VARCHAR2(500),
  NSV_ATTRIB57        VARCHAR2(500),
  NSV_ATTRIB58        VARCHAR2(500),
  NSV_ATTRIB59        VARCHAR2(500),
  NSV_ATTRIB60        VARCHAR2(500),
  NSV_ATTRIB61        VARCHAR2(500),
  NSV_ATTRIB62        VARCHAR2(500),
  NSV_ATTRIB63        VARCHAR2(500),
  NSV_ATTRIB64        VARCHAR2(500),
  NSV_ATTRIB65        VARCHAR2(500),
  NSV_ATTRIB66        VARCHAR2(500),
  NSV_ATTRIB67        VARCHAR2(500),
  NSV_ATTRIB68        VARCHAR2(500),
  NSV_ATTRIB69        VARCHAR2(500),
  NSV_ATTRIB70        VARCHAR2(500),
  NSV_ATTRIB71        VARCHAR2(500),
  NSV_ATTRIB72        VARCHAR2(500),
  NSV_ATTRIB73        VARCHAR2(500),
  NSV_ATTRIB74        VARCHAR2(500),
  NSV_ATTRIB75        VARCHAR2(500),
  NSV_ATTRIB76        VARCHAR2(500),
  NSV_ATTRIB77        VARCHAR2(500),
  NSV_ATTRIB78        VARCHAR2(500),
  NSV_ATTRIB79        VARCHAR2(500),
  NSV_ATTRIB80        VARCHAR2(500),
  NSV_ATTRIB81        VARCHAR2(500),
  NSV_ATTRIB82        VARCHAR2(500),
  NSV_ATTRIB83        VARCHAR2(500),
  NSV_ATTRIB84        VARCHAR2(500),
  NSV_ATTRIB85        VARCHAR2(500),
  NSV_ATTRIB86        VARCHAR2(500),
  NSV_ATTRIB87        VARCHAR2(500),
  NSV_ATTRIB88        VARCHAR2(500),
  NSV_ATTRIB89        VARCHAR2(500),
  NSV_ATTRIB90        VARCHAR2(500),
  NSV_ATTRIB91        VARCHAR2(500),
  NSV_ATTRIB92        VARCHAR2(500),
  NSV_ATTRIB93        VARCHAR2(500),
  NSV_ATTRIB94        VARCHAR2(500),
  NSV_ATTRIB95        VARCHAR2(500),
  NSV_ATTRIB96        VARCHAR2(500),
  NSV_ATTRIB97        VARCHAR2(500),
  NSV_ATTRIB98        VARCHAR2(500),
  NSV_ATTRIB99        VARCHAR2(500),
  NSV_ATTRIB100       VARCHAR2(500),
  NSV_ATTRIB101       VARCHAR2(500),
  NSV_ATTRIB102       VARCHAR2(500),
  NSV_ATTRIB103       VARCHAR2(500),
  NSV_ATTRIB104       VARCHAR2(500),
  NSV_ATTRIB105       VARCHAR2(500),
  NSV_ATTRIB106       VARCHAR2(500),
  NSV_ATTRIB107       VARCHAR2(500),
  NSV_ATTRIB108       VARCHAR2(500),
  NSV_ATTRIB109       VARCHAR2(500),
  NSV_ATTRIB110       VARCHAR2(500),
  NSV_ATTRIB111       VARCHAR2(500),
  NSV_ATTRIB112       VARCHAR2(500),
  NSV_ATTRIB113       VARCHAR2(500),
  NSV_ATTRIB114       VARCHAR2(500),
  NSV_ATTRIB115       VARCHAR2(500),
  NSV_ATTRIB116       VARCHAR2(500),
  NSV_ATTRIB117       VARCHAR2(500),
  NSV_ATTRIB118       VARCHAR2(500),
  NSV_ATTRIB119       VARCHAR2(500),
  NSV_ATTRIB120       VARCHAR2(500),
  NSV_ATTRIB121       VARCHAR2(500),
  NSV_ATTRIB122       VARCHAR2(500),
  NSV_ATTRIB123       VARCHAR2(500),
  NSV_ATTRIB124       VARCHAR2(500),
  NSV_ATTRIB125       VARCHAR2(500),
  NSV_ATTRIB126       VARCHAR2(500),
  NSV_ATTRIB127       VARCHAR2(500),
  NSV_ATTRIB128       VARCHAR2(500),
  NSV_ATTRIB129       VARCHAR2(500),
  NSV_ATTRIB130       VARCHAR2(500),
  NSV_ATTRIB131       VARCHAR2(500),
  NSV_ATTRIB132       VARCHAR2(500),
  NSV_ATTRIB133       VARCHAR2(500),
  NSV_ATTRIB134       VARCHAR2(500),
  NSV_ATTRIB135       VARCHAR2(500),
  NSV_ATTRIB136       VARCHAR2(500),
  NSV_ATTRIB137       VARCHAR2(500),
  NSV_ATTRIB138       VARCHAR2(500),
  NSV_ATTRIB139       VARCHAR2(500),
  NSV_ATTRIB140       VARCHAR2(500),
  NSV_ATTRIB141       VARCHAR2(500),
  NSV_ATTRIB142       VARCHAR2(500),
  NSV_ATTRIB143       VARCHAR2(500),
  NSV_ATTRIB144       VARCHAR2(500),
  NSV_ATTRIB145       VARCHAR2(500),
  NSV_ATTRIB146       VARCHAR2(500),
  NSV_ATTRIB147       VARCHAR2(500),
  NSV_ATTRIB148       VARCHAR2(500),
  NSV_ATTRIB149       VARCHAR2(500),
  NSV_ATTRIB150       VARCHAR2(500),
  NSV_ATTRIB151       VARCHAR2(500),
  NSV_ATTRIB152       VARCHAR2(500),
  NSV_ATTRIB153       VARCHAR2(500),
  NSV_ATTRIB154       VARCHAR2(500),
  NSV_ATTRIB155       VARCHAR2(500),
  NSV_ATTRIB156       VARCHAR2(500),
  NSV_ATTRIB157       VARCHAR2(500),
  NSV_ATTRIB158       VARCHAR2(500),
  NSV_ATTRIB159       VARCHAR2(500),
  NSV_ATTRIB160       VARCHAR2(500),
  NSV_ATTRIB161       VARCHAR2(500),
  NSV_ATTRIB162       VARCHAR2(500),
  NSV_ATTRIB163       VARCHAR2(500),
  NSV_ATTRIB164       VARCHAR2(500),
  NSV_ATTRIB165       VARCHAR2(500),
  NSV_ATTRIB166       VARCHAR2(500),
  NSV_ATTRIB167       VARCHAR2(500),
  NSV_ATTRIB168       VARCHAR2(500),
  NSV_ATTRIB169       VARCHAR2(500),
  NSV_ATTRIB170       VARCHAR2(500),
  NSV_ATTRIB171       VARCHAR2(500),
  NSV_ATTRIB172       VARCHAR2(500),
  NSV_ATTRIB173       VARCHAR2(500),
  NSV_ATTRIB174       VARCHAR2(500),
  NSV_ATTRIB175       VARCHAR2(500),
  NSV_ATTRIB176       VARCHAR2(500),
  NSV_ATTRIB177       VARCHAR2(500),
  NSV_ATTRIB178       VARCHAR2(500),
  NSV_ATTRIB179       VARCHAR2(500),
  NSV_ATTRIB180       VARCHAR2(500),
  NSV_ATTRIB181       VARCHAR2(500),
  NSV_ATTRIB182       VARCHAR2(500),
  NSV_ATTRIB183       VARCHAR2(500),
  NSV_ATTRIB184       VARCHAR2(500),
  NSV_ATTRIB185       VARCHAR2(500),
  NSV_ATTRIB186       VARCHAR2(500),
  NSV_ATTRIB187       VARCHAR2(500),
  NSV_ATTRIB188       VARCHAR2(500),
  NSV_ATTRIB189       VARCHAR2(500),
  NSV_ATTRIB190       VARCHAR2(500),
  NSV_ATTRIB191       VARCHAR2(500),
  NSV_ATTRIB192       VARCHAR2(500),
  NSV_ATTRIB193       VARCHAR2(500),
  NSV_ATTRIB194       VARCHAR2(500),
  NSV_ATTRIB195       VARCHAR2(500),
  NSV_ATTRIB196       VARCHAR2(500),
  NSV_ATTRIB197       VARCHAR2(500),
  NSV_ATTRIB198       VARCHAR2(500),
  NSV_ATTRIB199       VARCHAR2(500),
  NSV_ATTRIB200       VARCHAR2(500),
  NSV_ATTRIB201       VARCHAR2(500),
  NSV_ATTRIB202       VARCHAR2(500),
  NSV_ATTRIB203       VARCHAR2(500),
  NSV_ATTRIB204       VARCHAR2(500),
  NSV_ATTRIB205       VARCHAR2(500),
  NSV_ATTRIB206       VARCHAR2(500),
  NSV_ATTRIB207       VARCHAR2(500),
  NSV_ATTRIB208       VARCHAR2(500),
  NSV_ATTRIB209       VARCHAR2(500),
  NSV_ATTRIB210       VARCHAR2(500),
  NSV_ATTRIB211       VARCHAR2(500),
  NSV_ATTRIB212       VARCHAR2(500),
  NSV_ATTRIB213       VARCHAR2(500),
  NSV_ATTRIB214       VARCHAR2(500),
  NSV_ATTRIB215       VARCHAR2(500),
  NSV_ATTRIB216       VARCHAR2(500),
  NSV_ATTRIB217       VARCHAR2(500),
  NSV_ATTRIB218       VARCHAR2(500),
  NSV_ATTRIB219       VARCHAR2(500),
  NSV_ATTRIB220       VARCHAR2(500),
  NSV_ATTRIB221       VARCHAR2(500),
  NSV_ATTRIB222       VARCHAR2(500),
  NSV_ATTRIB223       VARCHAR2(500),
  NSV_ATTRIB224       VARCHAR2(500),
  NSV_ATTRIB225       VARCHAR2(500),
  NSV_ATTRIB226       VARCHAR2(500),
  NSV_ATTRIB227       VARCHAR2(500),
  NSV_ATTRIB228       VARCHAR2(500),
  NSV_ATTRIB229       VARCHAR2(500),
  NSV_ATTRIB230       VARCHAR2(500),
  NSV_ATTRIB231       VARCHAR2(500),
  NSV_ATTRIB232       VARCHAR2(500),
  NSV_ATTRIB233       VARCHAR2(500),
  NSV_ATTRIB234       VARCHAR2(500),
  NSV_ATTRIB235       VARCHAR2(500),
  NSV_ATTRIB236       VARCHAR2(500),
  NSV_ATTRIB237       VARCHAR2(500),
  NSV_ATTRIB238       VARCHAR2(500),
  NSV_ATTRIB239       VARCHAR2(500),
  NSV_ATTRIB240       VARCHAR2(500),
  NSV_ATTRIB241       VARCHAR2(500),
  NSV_ATTRIB242       VARCHAR2(500),
  NSV_ATTRIB243       VARCHAR2(500),
  NSV_ATTRIB244       VARCHAR2(500),
  NSV_ATTRIB245       VARCHAR2(500),
  NSV_ATTRIB246       VARCHAR2(500),
  NSV_ATTRIB247       VARCHAR2(500),
  NSV_ATTRIB248       VARCHAR2(500),
  NSV_ATTRIB249       VARCHAR2(500),
  NSV_ATTRIB250       VARCHAR2(500),
  NSV_ATTRIB251       VARCHAR2(500),
  NSV_ATTRIB252       VARCHAR2(500),
  NSV_ATTRIB253       VARCHAR2(500),
  NSV_ATTRIB254       VARCHAR2(500),
  NSV_ATTRIB255       VARCHAR2(500),
  NSV_ATTRIB256       VARCHAR2(500),
  NSV_ATTRIB257       VARCHAR2(500),
  NSV_ATTRIB258       VARCHAR2(500),
  NSV_ATTRIB259       VARCHAR2(500),
  NSV_ATTRIB260       VARCHAR2(500),
  NSV_ATTRIB261       VARCHAR2(500),
  NSV_ATTRIB262       VARCHAR2(500),
  NSV_ATTRIB263       VARCHAR2(500),
  NSV_ATTRIB264       VARCHAR2(500),
  NSV_ATTRIB265       VARCHAR2(500),
  NSV_ATTRIB266       VARCHAR2(500),
  NSV_ATTRIB267       VARCHAR2(500),
  NSV_ATTRIB268       VARCHAR2(500),
  NSV_ATTRIB269       VARCHAR2(500),
  NSV_ATTRIB270       VARCHAR2(500),
  NSV_ATTRIB271       VARCHAR2(500),
  NSV_ATTRIB272       VARCHAR2(500),
  NSV_ATTRIB273       VARCHAR2(500),
  NSV_ATTRIB274       VARCHAR2(500),
  NSV_ATTRIB275       VARCHAR2(500),
  NSV_ATTRIB276       VARCHAR2(500),
  NSV_ATTRIB277       VARCHAR2(500),
  NSV_ATTRIB278       VARCHAR2(500),
  NSV_ATTRIB279       VARCHAR2(500),
  NSV_ATTRIB280       VARCHAR2(500),
  NSV_ATTRIB281       VARCHAR2(500),
  NSV_ATTRIB282       VARCHAR2(500),
  NSV_ATTRIB283       VARCHAR2(500),
  NSV_ATTRIB284       VARCHAR2(500),
  NSV_ATTRIB285       VARCHAR2(500),
  NSV_ATTRIB286       VARCHAR2(500),
  NSV_ATTRIB287       VARCHAR2(500),
  NSV_ATTRIB288       VARCHAR2(500),
  NSV_ATTRIB289       VARCHAR2(500),
  NSV_ATTRIB290       VARCHAR2(500),
  NSV_ATTRIB291       VARCHAR2(500),
  NSV_ATTRIB292       VARCHAR2(500),
  NSV_ATTRIB293       VARCHAR2(500),
  NSV_ATTRIB294       VARCHAR2(500),
  NSV_ATTRIB295       VARCHAR2(500),
  NSV_ATTRIB296       VARCHAR2(500),
  NSV_ATTRIB297       VARCHAR2(500),
  NSV_ATTRIB298       VARCHAR2(500),
  NSV_ATTRIB299       VARCHAR2(500),
  NSV_ATTRIB300       VARCHAR2(500),
  NSV_ATTRIB301       VARCHAR2(500),
  NSV_ATTRIB302       VARCHAR2(500),
  NSV_ATTRIB303       VARCHAR2(500),
  NSV_ATTRIB304       VARCHAR2(500),
  NSV_ATTRIB305       VARCHAR2(500),
  NSV_ATTRIB306       VARCHAR2(500),
  NSV_ATTRIB307       VARCHAR2(500),
  NSV_ATTRIB308       VARCHAR2(500),
  NSV_ATTRIB309       VARCHAR2(500),
  NSV_ATTRIB310       VARCHAR2(500),
  NSV_ATTRIB311       VARCHAR2(500),
  NSV_ATTRIB312       VARCHAR2(500),
  NSV_ATTRIB313       VARCHAR2(500),
  NSV_ATTRIB314       VARCHAR2(500),
  NSV_ATTRIB315       VARCHAR2(500),
  NSV_ATTRIB316       VARCHAR2(500),
  NSV_ATTRIB317       VARCHAR2(500),
  NSV_ATTRIB318       VARCHAR2(500),
  NSV_ATTRIB319       VARCHAR2(500),
  NSV_ATTRIB320       VARCHAR2(500),
  NSV_ATTRIB321       VARCHAR2(500),
  NSV_ATTRIB322       VARCHAR2(500),
  NSV_ATTRIB323       VARCHAR2(500),
  NSV_ATTRIB324       VARCHAR2(500),
  NSV_ATTRIB325       VARCHAR2(500),
  NSV_ATTRIB326       VARCHAR2(500),
  NSV_ATTRIB327       VARCHAR2(500),
  NSV_ATTRIB328       VARCHAR2(500),
  NSV_ATTRIB329       VARCHAR2(500),
  NSV_ATTRIB330       VARCHAR2(500),
  NSV_ATTRIB331       VARCHAR2(500),
  NSV_ATTRIB332       VARCHAR2(500),
  NSV_ATTRIB333       VARCHAR2(500),
  NSV_ATTRIB334       VARCHAR2(500),
  NSV_ATTRIB335       VARCHAR2(500),
  NSV_ATTRIB336       VARCHAR2(500),
  NSV_ATTRIB337       VARCHAR2(500),
  NSV_ATTRIB338       VARCHAR2(500),
  NSV_ATTRIB339       VARCHAR2(500),
  NSV_ATTRIB340       VARCHAR2(500),
  NSV_ATTRIB341       VARCHAR2(500),
  NSV_ATTRIB342       VARCHAR2(500),
  NSV_ATTRIB343       VARCHAR2(500),
  NSV_ATTRIB344       VARCHAR2(500),
  NSV_ATTRIB345       VARCHAR2(500),
  NSV_ATTRIB346       VARCHAR2(500),
  NSV_ATTRIB347       VARCHAR2(500),
  NSV_ATTRIB348       VARCHAR2(500),
  NSV_ATTRIB349       VARCHAR2(500),
  NSV_ATTRIB350       VARCHAR2(500),
  NSV_ATTRIB351       VARCHAR2(500),
  NSV_ATTRIB352       VARCHAR2(500),
  NSV_ATTRIB353       VARCHAR2(500),
  NSV_ATTRIB354       VARCHAR2(500),
  NSV_ATTRIB355       VARCHAR2(500),
  NSV_ATTRIB356       VARCHAR2(500),
  NSV_ATTRIB357       VARCHAR2(500),
  NSV_ATTRIB358       VARCHAR2(500),
  NSV_ATTRIB359       VARCHAR2(500),
  NSV_ATTRIB360       VARCHAR2(500),
  NSV_ATTRIB361       VARCHAR2(500),
  NSV_ATTRIB362       VARCHAR2(500),
  NSV_ATTRIB363       VARCHAR2(500),
  NSV_ATTRIB364       VARCHAR2(500),
  NSV_ATTRIB365       VARCHAR2(500),
  NSV_ATTRIB366       VARCHAR2(500),
  NSV_ATTRIB367       VARCHAR2(500),
  NSV_ATTRIB368       VARCHAR2(500),
  NSV_ATTRIB369       VARCHAR2(500),
  NSV_ATTRIB370       VARCHAR2(500),
  NSV_ATTRIB371       VARCHAR2(500),
  NSV_ATTRIB372       VARCHAR2(500),
  NSV_ATTRIB373       VARCHAR2(500),
  NSV_ATTRIB374       VARCHAR2(500),
  NSV_ATTRIB375       VARCHAR2(500),
  NSV_ATTRIB376       VARCHAR2(500),
  NSV_ATTRIB377       VARCHAR2(500),
  NSV_ATTRIB378       VARCHAR2(500),
  NSV_ATTRIB379       VARCHAR2(500),
  NSV_ATTRIB380       VARCHAR2(500),
  NSV_ATTRIB381       VARCHAR2(500),
  NSV_ATTRIB382       VARCHAR2(500),
  NSV_ATTRIB383       VARCHAR2(500),
  NSV_ATTRIB384       VARCHAR2(500),
  NSV_ATTRIB385       VARCHAR2(500),
  NSV_ATTRIB386       VARCHAR2(500),
  NSV_ATTRIB387       VARCHAR2(500),
  NSV_ATTRIB388       VARCHAR2(500),
  NSV_ATTRIB389       VARCHAR2(500),
  NSV_ATTRIB390       VARCHAR2(500),
  NSV_ATTRIB391       VARCHAR2(500),
  NSV_ATTRIB392       VARCHAR2(500),
  NSV_ATTRIB393       VARCHAR2(500),
  NSV_ATTRIB394       VARCHAR2(500),
  NSV_ATTRIB395       VARCHAR2(500),
  NSV_ATTRIB396       VARCHAR2(500),
  NSV_ATTRIB397       VARCHAR2(500),
  NSV_ATTRIB398       VARCHAR2(500),
  NSV_ATTRIB399       VARCHAR2(500),
  NSV_ATTRIB400       VARCHAR2(500),
  NSV_ATTRIB401       VARCHAR2(500),
  NSV_ATTRIB402       VARCHAR2(500),
  NSV_ATTRIB403       VARCHAR2(500),
  NSV_ATTRIB404       VARCHAR2(500),
  NSV_ATTRIB405       VARCHAR2(500),
  NSV_ATTRIB406       VARCHAR2(500),
  NSV_ATTRIB407       VARCHAR2(500),
  NSV_ATTRIB408       VARCHAR2(500),
  NSV_ATTRIB409       VARCHAR2(500),
  NSV_ATTRIB410       VARCHAR2(500),
  NSV_ATTRIB411       VARCHAR2(500),
  NSV_ATTRIB412       VARCHAR2(500),
  NSV_ATTRIB413       VARCHAR2(500),
  NSV_ATTRIB414       VARCHAR2(500),
  NSV_ATTRIB415       VARCHAR2(500),
  NSV_ATTRIB416       VARCHAR2(500),
  NSV_ATTRIB417       VARCHAR2(500),
  NSV_ATTRIB418       VARCHAR2(500),
  NSV_ATTRIB419       VARCHAR2(500),
  NSV_ATTRIB420       VARCHAR2(500),
  NSV_ATTRIB421       VARCHAR2(500),
  NSV_ATTRIB422       VARCHAR2(500),
  NSV_ATTRIB423       VARCHAR2(500),
  NSV_ATTRIB424       VARCHAR2(500),
  NSV_ATTRIB425       VARCHAR2(500),
  NSV_ATTRIB426       VARCHAR2(500),
  NSV_ATTRIB427       VARCHAR2(500),
  NSV_ATTRIB428       VARCHAR2(500),
  NSV_ATTRIB429       VARCHAR2(500),
  NSV_ATTRIB430       VARCHAR2(500),
  NSV_ATTRIB431       VARCHAR2(500),
  NSV_ATTRIB432       VARCHAR2(500),
  NSV_ATTRIB433       VARCHAR2(500),
  NSV_ATTRIB434       VARCHAR2(500),
  NSV_ATTRIB435       VARCHAR2(500),
  NSV_ATTRIB436       VARCHAR2(500),
  NSV_ATTRIB437       VARCHAR2(500),
  NSV_ATTRIB438       VARCHAR2(500),
  NSV_ATTRIB439       VARCHAR2(500),
  NSV_ATTRIB440       VARCHAR2(500),
  NSV_ATTRIB441       VARCHAR2(500),
  NSV_ATTRIB442       VARCHAR2(500),
  NSV_ATTRIB443       VARCHAR2(500),
  NSV_ATTRIB444       VARCHAR2(500),
  NSV_ATTRIB445       VARCHAR2(500),
  NSV_ATTRIB446       VARCHAR2(500),
  NSV_ATTRIB447       VARCHAR2(500),
  NSV_ATTRIB448       VARCHAR2(500),
  NSV_ATTRIB449       VARCHAR2(500),
  NSV_ATTRIB450       VARCHAR2(500),
  NSV_ATTRIB451       VARCHAR2(500),
  NSV_ATTRIB452       VARCHAR2(500),
  NSV_ATTRIB453       VARCHAR2(500),
  NSV_ATTRIB454       VARCHAR2(500),
  NSV_ATTRIB455       VARCHAR2(500),
  NSV_ATTRIB456       VARCHAR2(500),
  NSV_ATTRIB457       VARCHAR2(500),
  NSV_ATTRIB458       VARCHAR2(500),
  NSV_ATTRIB459       VARCHAR2(500),
  NSV_ATTRIB460       VARCHAR2(500),
  NSV_ATTRIB461       VARCHAR2(500),
  NSV_ATTRIB462       VARCHAR2(500),
  NSV_ATTRIB463       VARCHAR2(500),
  NSV_ATTRIB464       VARCHAR2(500),
  NSV_ATTRIB465       VARCHAR2(500),
  NSV_ATTRIB466       VARCHAR2(500),
  NSV_ATTRIB467       VARCHAR2(500),
  NSV_ATTRIB468       VARCHAR2(500),
  NSV_ATTRIB469       VARCHAR2(500),
  NSV_ATTRIB470       VARCHAR2(500),
  NSV_ATTRIB471       VARCHAR2(500),
  NSV_ATTRIB472       VARCHAR2(500),
  NSV_ATTRIB473       VARCHAR2(500),
  NSV_ATTRIB474       VARCHAR2(500),
  NSV_ATTRIB475       VARCHAR2(500),
  NSV_ATTRIB476       VARCHAR2(500),
  NSV_ATTRIB477       VARCHAR2(500),
  NSV_ATTRIB478       VARCHAR2(500),
  NSV_ATTRIB479       VARCHAR2(500),
  NSV_ATTRIB480       VARCHAR2(500),
  NSV_ATTRIB481       VARCHAR2(500),
  NSV_ATTRIB482       VARCHAR2(500),
  NSV_ATTRIB483       VARCHAR2(500),
  NSV_ATTRIB484       VARCHAR2(500),
  NSV_ATTRIB485       VARCHAR2(500),
  NSV_ATTRIB486       VARCHAR2(500),
  NSV_ATTRIB487       VARCHAR2(500),
  NSV_ATTRIB488       VARCHAR2(500),
  NSV_ATTRIB489       VARCHAR2(500),
  NSV_ATTRIB490       VARCHAR2(500),
  NSV_ATTRIB491       VARCHAR2(500),
  NSV_ATTRIB492       VARCHAR2(500),
  NSV_ATTRIB493       VARCHAR2(500),
  NSV_ATTRIB494       VARCHAR2(500),
  NSV_ATTRIB495       VARCHAR2(500),
  NSV_ATTRIB496       VARCHAR2(500),
  NSV_ATTRIB497       VARCHAR2(500),
  NSV_ATTRIB498       VARCHAR2(500),
  NSV_ATTRIB499       VARCHAR2(500),
  NSV_ATTRIB500       VARCHAR2(500)
)
ON COMMIT DELETE ROWS
NOCACHE
/



------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Create nm_eng_dynseg_values_tmp
SET TERM OFF

-- PT  18-SEP-2007
--
-- DEVELOPMENT COMMENTS
-- Temp table for bulk eng dynseg
------------------------------------------------------------------

CREATE GLOBAL TEMPORARY TABLE nm_eng_dynseg_values_tmp
(
  GRP_OPERATION              VARCHAR2(10) NOT NULL,
  GRP_SECTION_ID             NUMBER(9)    NOT NULL,
  GRP_INV_TYPE               VARCHAR2(4)  NOT NULL,
  GRP_XSP                    VARCHAR2(4)  NOT NULL,
  GRP_VALUE_COLUMN           VARCHAR2(30) NOT NULL,
  GRP_VALUE                  VARCHAR2(50) NOT NULL,
  IIT_NE_ID                  NUMBER(9),
  IIT_INV_TYPE               VARCHAR2(4),
  IIT_PRIMARY_KEY            VARCHAR2(50),
  IIT_START_DATE             DATE,
  IIT_DATE_CREATED           DATE,
  IIT_DATE_MODIFIED          DATE,
  IIT_CREATED_BY             VARCHAR2(30),
  IIT_MODIFIED_BY            VARCHAR2(30),
  IIT_ADMIN_UNIT             NUMBER(9),
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
  IIT_LENGTH                 NUMBER,
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
  IIT_NUM_ATTRIB115          NUMBER
)
ON COMMIT PRESERVE ROWS
NOCACHE
/


ALTER TABLE nm_eng_dynseg_values_tmp ADD (
  CONSTRAINT EDVT_PK
 PRIMARY KEY
 (GRP_OPERATION, GRP_SECTION_ID, GRP_INV_TYPE, GRP_XSP, GRP_VALUE_COLUMN, GRP_VALUE))
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT create nm_datum_criteria_tmp
SET TERM OFF

-- PT  05-OCT-2007
--
-- DEVELOPMENT COMMENTS
-- **** COMMENTS TO BE ADDED BY PT ****
------------------------------------------------------------------
CREATE GLOBAL TEMPORARY TABLE nm_datum_criteria_tmp
(
  DATUM_ID  NUMBER(9),
  BEGIN_MP  NUMBER,
  END_MP    NUMBER,
  GROUP_ID  NUMBER(9)
)
ON COMMIT PRESERVE ROWS
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT create nm_route_connectivity_tmp
SET TERM OFF

-- PT  05-OCT-2007
--
-- DEVELOPMENT COMMENTS
-- **** COMMENTS TO BE ADDED BY PT ****
------------------------------------------------------------------
CREATE GLOBAL TEMPORARY TABLE nm_route_connectivity_tmp
(
  NM_NE_ID_IN  NUMBER(9),
  CHUNK_NO     NUMBER(6),
  CHUNK_SEQ    NUMBER(6),
  NM_NE_ID_OF  NUMBER(9),
  NM_BEGIN_MP  NUMBER,
  NM_END_MP    NUMBER,
  MEASURE      NUMBER,
  END_MEASURE  NUMBER,
  NM_SLK       NUMBER,
  NM_END_SLK   NUMBER,
  NT_UNIT_IN   NUMBER(9),
  NT_UNIT_OF   NUMBER(9)
)
ON COMMIT PRESERVE ROWS
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT regenerate merge results views
SET TERM OFF

-- PT  11-OCT-2007
--
-- DEVELOPMENT COMMENTS
-- This rebuilds the merge result views for all merge queries using the new logic in nm3mrg_view.pkb 1.38
------------------------------------------------------------------
begin
for r in (
select nmq_id from nm_mrg_query_all
)
loop
  nm3mrg_view.build_view(r.nmq_id);
end loop;
end;
/
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script
------------------------------------------------------------------

