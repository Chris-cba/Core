--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/install/lb_ddl.sql-arc   1.7   Oct 29 2015 07:35:48   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_ddl.sql  $
--       Date into PVCS   : $Date:   Oct 29 2015 07:35:48  $
--       Date fetched Out : $Modtime:   Oct 29 2015 07:36:06  $
--       PVCS Version     : $Revision:   1.7  $
--
--   Author : R.A. Coupe
--
--   Interim DDL script to clear out metadata
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--

/*

 LB_TYPES - the interface table to eB asset types
 
*/

Prompt LB_TYPES

DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -2441);
   table_not_exists   exception;
   PRAGMA EXCEPTION_INIT (table_not_exists, -942);   
BEGIN
   EXECUTE IMMEDIATE 'ALTER TABLE LB_TYPES DROP PRIMARY KEY CASCADE ';
EXCEPTION
   WHEN not_exists
Then NULL;
   WHEN table_not_exists
Then NULL;
end;
/ 

DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -942);
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE LB_TYPES CASCADE CONSTRAINTS';
EXCEPTION
   WHEN not_exists
Then NULL;
end;
/ 

CREATE TABLE LB_TYPES
(
  LB_OBJECT_TYPE     INTEGER,
  LB_ASSET_GROUP     VARCHAR2(100 BYTE),
  LB_EXOR_INV_TYPE   VARCHAR2(4 BYTE)
)
/

COMMENT ON TABLE LB_TYPES IS 'Links of LB asset types to Exor Inv Types - needs adjustment once combined instance is available'
/

CREATE UNIQUE INDEX LBT_INV_UK ON LB_TYPES
(LB_EXOR_INV_TYPE)
/

CREATE UNIQUE INDEX LBT_OBK_IDX ON LB_TYPES
(LB_OBJECT_TYPE)
/

CREATE UNIQUE INDEX LBT_PK ON LB_TYPES
(LB_OBJECT_TYPE, LB_ASSET_GROUP)
/

ALTER TABLE LB_TYPES ADD (
  CONSTRAINT LBT_PK
  PRIMARY KEY
  (LB_OBJECT_TYPE, LB_ASSET_GROUP)
  USING INDEX LBT_PK
  ENABLE VALIDATE,
  CONSTRAINT LBT_INV_UK
  UNIQUE (LB_EXOR_INV_TYPE)
  USING INDEX LBT_INV_UK
  ENABLE VALIDATE)
/  

ALTER TABLE LB_TYPES ADD (
  CONSTRAINT LBT_FK_NIT 
  FOREIGN KEY (LB_EXOR_INV_TYPE) 
  REFERENCES NM_INV_TYPES_ALL (NIT_INV_TYPE)
  ENABLE VALIDATE)
/  

Prompt LB_SECURITY (Unused)

DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -942);
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE LB_INV_SECURITY CASCADE CONSTRAINTS';
EXCEPTION
   WHEN not_exists
Then NULL;
end;
/ 


create table LB_INV_SECURITY 
( LB_EXOR_INV_TYPE    VARCHAR2(4),
  LB_SECURITY_TYPE    VARCHAR2(10) Default 'NONE' )
/

CREATE UNIQUE INDEX LIS_PK ON LB_INV_SECURITY
(LB_EXOR_INV_TYPE)
/

ALTER TABLE LB_INV_SECURITY ADD (
  CONSTRAINT LIS_PK
  PRIMARY KEY
  (LB_EXOR_INV_TYPE)
  USING INDEX LIS_PK
  ENABLE VALIDATE)
/    
 
ALTER TABLE LB_INV_SECURITY ADD 
CONSTRAINT LB_SECURITY_TYPE_CHK
 CHECK (LB_SECURITY_TYPE in ('NONE', 'SCOPE', 'ADMIN_UNIT', 'INHERIT'))
 ENABLE
 VALIDATE
/

ALTER TABLE LB_INV_SECURITY ADD (
  CONSTRAINT LIS_FK_NIT 
  FOREIGN KEY (LB_EXOR_INV_TYPE) 
  REFERENCES NM_INV_TYPES_ALL (NIT_INV_TYPE)
  ENABLE VALIDATE)
/  


Prompt Asset Locations

DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -942);
BEGIN
   EXECUTE IMMEDIATE 'ALTER TABLE NM_ASSET_LOCATIONS_ALL  DROP PRIMARY KEY CASCADE';
EXCEPTION
   WHEN not_exists
Then NULL;
end;
/ 

DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -942);
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE NM_ASSET_LOCATIONS_ALL CASCADE CONSTRAINTS';
EXCEPTION
   WHEN not_exists
Then NULL;
end;
/ 

/

CREATE TABLE NM_ASSET_LOCATIONS_ALL
(
  NAL_ID             INTEGER,
  NAL_NIT_TYPE       VARCHAR2(4 BYTE),
  NAL_ASSET_ID       INTEGER,
  NAL_DESCR          VARCHAR2(240 BYTE),
  NAL_JXP            INTEGER,
  NAL_PRIMARY        VARCHAR2(1 BYTE),
  NAL_LOCATION_TYPE  VARCHAR2(1 BYTE) DEFAULT 'N',
  NAL_START_DATE     DATE,
  NAL_END_DATE       DATE,
  NAL_SECURITY_KEY   INTEGER,
  NAL_date_created   DATE,
  nal_date_modified  DATE,
  nal_created_by     VARCHAR2(30),
  nal_modified_by    VARCHAR2(30))
/

COMMENT ON TABLE NM_ASSET_LOCATIONS_ALL IS 'Instances of asset placements and juxtapositions'
/

ALTER TABLE NM_ASSET_LOCATIONS_ALL ADD 
CONSTRAINT NAL_LOCATION_TYPE_CHK
 CHECK (NAL_LOCATION_TYPE in ('N', 'G'))
 ENABLE
 VALIDATE
/

ALTER TABLE NM_ASSET_LOCATIONS_ALL modify NAL_LOCATION_TYPE NOT NULL
/

CREATE INDEX NAL_ASSET_IDX1 ON NM_ASSET_LOCATIONS_ALL
(NAL_ASSET_ID, NAL_JXP, NAL_NIT_TYPE)
/


ALTER TABLE NM_ASSET_LOCATIONS_ALL ADD (
  PRIMARY KEY
  (NAL_ID)
  USING INDEX
  ENABLE VALIDATE
)
/  

ALTER TABLE NM_ASSET_LOCATIONS_ALL ADD (
  CONSTRAINT NAL_FK_NIT 
  FOREIGN KEY (NAL_NIT_TYPE) 
  REFERENCES NM_INV_TYPES_ALL (NIT_INV_TYPE)
  ENABLE VALIDATE)
/  

CREATE INDEX nal_nit_idx ON NM_ASSET_LOCATIONS_ALL
(NAL_NIT_TYPE)
/





Prompt NAL_ID_SEQ

DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -2289);
BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE NAL_ID_SEQ';
EXCEPTION
   WHEN not_exists
Then NULL;
end;
/ 

create sequence nal_id_seq start with 1
/

prompt asset locations trigger

CREATE OR REPLACE TRIGGER NM_ASSET_LOCATIONS_ALL_WHO
BEFORE INSERT OR UPDATE
ON NM_ASSET_LOCATIONS_ALL
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
   l_sysdate DATE;
   l_user    VARCHAR2(30);
BEGIN
--
   SELECT sysdate
         ,Sys_Context('NM3_SECURITY_CTX','USERNAME')
    INTO  l_sysdate
         ,l_user
    FROM  dual;
--     
   IF inserting
    THEN
      :new.NAL_ID            := NAL_ID_SEQ.nextval;
      :new.NAL_DATE_CREATED  := l_sysdate;
      :new.NAL_CREATED_BY    := l_user;
   END IF;
--
   :new.NAL_DATE_MODIFIED := l_sysdate;
   :new.NAL_MODIFIED_BY   := l_user;
--
END NM_ASSET_LOCATIONS_ALL_WHO;
/

Prompt Location data - NM_LOC_ID_SEQ

DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -2289);
BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE NM_LOC_ID_SEQ';
EXCEPTION
   WHEN not_exists
Then NULL;
end;
/ 


create sequence NM_loc_id_seq start with 1
/

Prompt Location data - Location details table

DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -942);
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE NM_LOCATIONS_ALL CASCADE CONSTRAINTS';
EXCEPTION
   WHEN not_exists
Then NULL;
end;
/ 


CREATE TABLE NM_LOCATIONS_ALL
(
  NM_NE_ID_OF        INTEGER                    NOT NULL,
  NM_LOC_ID          INTEGER                    NOT NULL,
  NM_OBJ_TYPE        VARCHAR2(4 BYTE)           NOT NULL,
  NM_NE_ID_IN        INTEGER                    NOT NULL,
  NM_BEGIN_MP        NUMBER                     NOT NULL,
  NM_START_DATE      DATE                       NOT NULL,
  NM_END_DATE        DATE,
  NM_END_MP          NUMBER                     NOT NULL,
  NM_TYPE            VARCHAR2(4 BYTE)           NOT NULL,
  NM_SLK             NUMBER,
  NM_DIR_FLAG        INTEGER,
  NM_SECURITY_ID     NUMBER(9),
  NM_SEQ_NO          INTEGER,
  NM_SEG_NO          INTEGER,
  NM_TRUE            NUMBER,
  NM_END_SLK         NUMBER,
  NM_END_TRUE        NUMBER,
  NM_X_SECT_ST       VARCHAR2(4 BYTE),
  NM_OFFSET_ST       NUMBER,
  NM_UNIQUE_PRIMARY  VARCHAR2(1 BYTE),
  NM_PRIMARY         VARCHAR2(1 BYTE),
  NM_STATUS          INTEGER,
  TRANSACTION_ID     INTEGER,
  NM_DATE_CREATED    DATE,
  NM_DATE_MODIFIED   DATE,
  NM_MODIFIED_BY     VARCHAR2(30 BYTE),
  NM_CREATED_BY      VARCHAR2(30 BYTE),
  NM_X_SECT_END      VARCHAR2(4 BYTE),
  NM_OFFSET_END      NUMBER,
  NM_FACTOR          NUMBER,
  NM_NLT_ID          INTEGER NOT NULL
)
/

COMMENT ON TABLE NM_LOCATIONS_ALL IS 'The placement of each asset location instance '
/
 

CREATE UNIQUE INDEX NML1_LOC_ID_UK ON NM_LOCATIONS_ALL
(NM_LOC_ID)
/

CREATE UNIQUE INDEX NML1_OBJ_IDX ON NM_LOCATIONS_ALL
(NM_OBJ_TYPE, NM_LOC_ID)
/


CREATE UNIQUE INDEX NML1_OF_IDX ON NM_LOCATIONS_ALL
(NM_NE_ID_OF, NM_OBJ_TYPE, NM_LOC_ID)
/

CREATE UNIQUE INDEX NML1_IN_IDX ON NM_LOCATIONS_ALL
(NM_NE_ID_IN, NM_NE_ID_OF, NM_BEGIN_MP, NM_START_DATE, NM_OBJ_TYPE, 
NM_STATUS)
/

CREATE INDEX NML1_NLT_IDX ON NM_LOCATIONS_ALL
(NM_NLT_ID )
/

ALTER TABLE NM_LOCATIONS_ALL ADD 
CONSTRAINT nm_fk_nal
 FOREIGN KEY (NM_NE_ID_IN)
 REFERENCES NM_ASSET_LOCATIONS_ALL (NAL_ID)
 ENABLE
 VALIDATE
/

alter table nm_locations_all add (
CONSTRAINT nm_loc_UK
  UNIQUE (NM_LOC_ID)
  USING INDEX NML1_LOC_ID_UK
  ENABLE VALIDATE )
/

ALTER TABLE NM_LOCATIONS_ALL ADD 
CONSTRAINT loc_fk_ne
 FOREIGN KEY (NM_NE_ID_OF)
 REFERENCES NM_ELEMENTS_ALL (NE_ID)
 ENABLE
 VALIDATE
/

ALTER TABLE NM_LOCATIONS_ALL ADD (
  CONSTRAINT nm_loc_nlt_fk 
  FOREIGN KEY (nm_nlt_id) 
  REFERENCES NM_LINEAR_TYPES (NLT_ID)
  ENABLE VALIDATE)
/  


CREATE OR REPLACE TRIGGER NM_LOC_ID_SEQ_USAGE_WHO
BEFORE INSERT OR UPDATE
ON NM_LOCATIONS_ALL
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
   l_sysdate DATE;
   l_user    VARCHAR2(30);
BEGIN
--
   SELECT sysdate
         ,Sys_Context('NM3_SECURITY_CTX','USERNAME')
    INTO  l_sysdate
         ,l_user
    FROM  dual;
--
    IF inserting
    THEN
      :new.NM_LOC_ID        := NM_LOC_ID_SEQ.nextval;
      :new.NM_DATE_CREATED  := l_sysdate;
      :new.NM_CREATED_BY    := l_user;
   END IF;
--
   :new.NM_DATE_MODIFIED := l_sysdate;
   :new.NM_MODIFIED_BY   := l_user;
--
END nm_locations_all_who;
/

Prompt JXP data 

DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -2441);
   table_not_exists   exception;
   PRAGMA EXCEPTION_INIT (table_not_exists, -942);   
BEGIN
   EXECUTE IMMEDIATE 'ALTER TABLE NM_JUXTAPOSITION_TYPES DROP PRIMARY KEY CASCADE';
EXCEPTION
   WHEN not_exists
Then NULL;
   WHEN table_not_exists
Then NULL;
end;
/ 


DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -942);
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE NM_JUXTAPOSITION_TYPES CASCADE CONSTRAINTS';
EXCEPTION
   WHEN not_exists
Then NULL;
end;
/ 

CREATE TABLE NM_JUXTAPOSITION_TYPES
(
  NJXT_ID     INTEGER                           NOT NULL,
  NJXT_NAME   VARCHAR2(30 BYTE)                 NOT NULL,
  NJXT_DESCR  VARCHAR2(80 BYTE)                 NOT NULL
)
/

COMMENT ON TABLE NM_JUXTAPOSITION_TYPES IS 'The domain of all types of Juxtaposition'
/

CREATE UNIQUE INDEX NJXT_UK ON NM_JUXTAPOSITION_TYPES
(NJXT_NAME)
/

CREATE UNIQUE INDEX NJXT_PK ON NM_JUXTAPOSITION_TYPES
(NJXT_ID)
/

ALTER TABLE NM_JUXTAPOSITION_TYPES ADD (
  CONSTRAINT NJXT_PK
  PRIMARY KEY
  (NJXT_ID)
  USING INDEX NJXT_PK
  ENABLE VALIDATE,
  CONSTRAINT NJXT_UK
  UNIQUE (NJXT_NAME)
  USING INDEX NJXT_UK
  ENABLE VALIDATE)
/  


DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -2441);
   table_not_exists   exception;
   PRAGMA EXCEPTION_INIT (table_not_exists, -942);   
BEGIN
   EXECUTE IMMEDIATE 'ALTER TABLE NM_JUXTAPOSITIONS DROP PRIMARY KEY CASCADE';
EXCEPTION
   WHEN not_exists
Then NULL;
   WHEN table_not_exists
Then NULL;
end;
/ 

DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -942);
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE NM_JUXTAPOSITIONS CASCADE CONSTRAINTS';
EXCEPTION
   WHEN not_exists
Then NULL;
end;
/ 



CREATE TABLE NM_JUXTAPOSITIONS
(
  NJX_ID       INTEGER                          NOT NULL,
  NJX_NJXT_ID  INTEGER                          NOT NULL,
  NJX_CODE     INTEGER                          NOT NULL,
  NJX_MEANING  VARCHAR2(80 BYTE)                NOT NULL
)
/

COMMENT ON TABLE NM_JUXTAPOSITIONS is 'A list of possible juxtapositions by type'
/


CREATE UNIQUE INDEX NJX_PK ON NM_JUXTAPOSITIONS
(NJX_ID)
/

CREATE INDEX NJX_FK_JXT_IND ON NM_JUXTAPOSITIONS
(NJX_NJXT_ID)
/

CREATE UNIQUE INDEX NJX_CODE_IDX ON NM_JUXTAPOSITIONS
( NJX_CODE, NJX_NJXT_ID )
/


ALTER TABLE NM_JUXTAPOSITIONS ADD (
  CONSTRAINT NJX_PK
  PRIMARY KEY
  (NJX_ID)
  USING INDEX NJX_PK
  ENABLE VALIDATE)
/  

ALTER TABLE NM_JUXTAPOSITIONS ADD (
  CONSTRAINT NJX_FK_JXT 
  FOREIGN KEY (NJX_NJXT_ID) 
  REFERENCES NM_JUXTAPOSITION_TYPES (NJXT_ID)
  ENABLE VALIDATE)
  /



DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -2441);
   table_not_exists   exception;
   PRAGMA EXCEPTION_INIT (table_not_exists, -942);   
BEGIN
   EXECUTE IMMEDIATE 'ALTER TABLE NM_ASSET_TYPE_JUXTAPOSITIONS DROP PRIMARY KEY CASCADE';
EXCEPTION
   WHEN not_exists
Then NULL;
   WHEN table_not_exists
Then NULL;
end;
/ 

DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -942);
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE NM_ASSET_TYPE_JUXTAPOSITIONS CASCADE CONSTRAINTS';
EXCEPTION
   WHEN not_exists
Then NULL;
end;
/ 


CREATE TABLE NM_ASSET_TYPE_JUXTAPOSITIONS
(
  NAJX_ID        INTEGER                        NOT NULL,
  NAJX_INV_TYPE  VARCHAR2(4 BYTE)               NOT NULL,
  NAJX_NJXT_ID   INTEGER                        NOT NULL
)
/

COMMENT ON TABLE NM_ASSET_TYPE_JUXTAPOSITIONS IS 'The list of juxtaposition types available for an asset type'
/


CREATE UNIQUE INDEX NAJX_PK ON NM_ASSET_TYPE_JUXTAPOSITIONS
(NAJX_ID)
/

ALTER TABLE NM_ASSET_TYPE_JUXTAPOSITIONS ADD (
  CONSTRAINT NAJX_PK
  PRIMARY KEY
  (NAJX_ID)
  USING INDEX NAJX_PK
  ENABLE VALIDATE)
/  

ALTER TABLE NM_ASSET_TYPE_JUXTAPOSITIONS ADD (
  CONSTRAINT NAJX_FK_JXT 
  FOREIGN KEY (NAJX_NJXT_ID) 
  REFERENCES NM_JUXTAPOSITION_TYPES (NJXT_ID)
  ENABLE VALIDATE,
  CONSTRAINT NAJX_FK_NIT 
  FOREIGN KEY (NAJX_INV_TYPE) 
  REFERENCES NM_INV_TYPES_ALL (NIT_INV_TYPE)
  ENABLE VALIDATE)
/  

CREATE INDEX NAJX_INV_IDX ON NM_ASSET_TYPE_JUXTAPOSITIONS ( NAJX_INV_TYPE, NAJX_NJXT_ID )
/



CREATE OR REPLACE TRIGGER nal_jxp_validation
BEFORE INSERT OR UPDATE
ON NM_ASSET_LOCATIONS_ALL
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
retval integer;
begin
  if :new.nal_jxp is not null then
    select 1 
    into retval
    from NM_ASSET_TYPE_JUXTAPOSITIONS, nm_juxtapositions
    where njx_njxt_id = najx_njxt_id
    and njx_code = :new.nal_jxp
    and najx_inv_type = :new.nal_nit_type;
--
  end if;
exception
  when no_data_found then
    raise_application_error( -20001, 'JXP value is invalid' );
end;
/

Prompt Location Geometry

DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -2441);
   table_not_exists   exception;
   PRAGMA EXCEPTION_INIT (table_not_exists, -942);   
BEGIN
   EXECUTE IMMEDIATE 'ALTER TABLE NM_LOCATION_GEOMETRY DROP PRIMARY KEY CASCADE';
EXCEPTION
   WHEN not_exists
Then NULL;
   WHEN table_not_exists
Then NULL;
end;
/ 


DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -942);
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE NM_LOCATION_GEOMETRY CASCADE CONSTRAINTS';
EXCEPTION
   WHEN not_exists
Then NULL;
end;
/ 

CREATE TABLE NM_LOCATION_GEOMETRY
(
  NLG_ID              NUMBER(38)                NOT NULL,
  NLG_LOCATION_TYPE   VARCHAR2(1) DEFAULT 'N'   NOT NULL,
  NLG_NAL_ID          NUMBER(38)                NOT NULL,
  NLG_OBJ_TYPE        VARCHAR2(4 BYTE)          NOT NULL,
  NLG_LOC_ID          INTEGER                   NULL,
  NLG_GEOMETRY  MDSYS.SDO_GEOMETRY
)
/

COMMENT ON TABLE NM_LOCATION_GEOMETRY IS 'The geometry or component geometries of an asset'
/

ALTER TABLE NM_LOCATION_GEOMETRY ADD 
CONSTRAINT NLG_LOCATION_TYPE_CHK
 CHECK (NLG_LOCATION_TYPE in ('N', 'G'))
 ENABLE
 VALIDATE
/


ALTER TABLE NM_LOCATION_GEOMETRY ADD 
CONSTRAINT NLG_LOC_ID_TYPE_CHK
 CHECK (
  decode(nlg_location_type, 'N', 0, 1) + decode( nlg_loc_id, NULL, 1, 0) in (0,2) 
 )
 ENABLE
 VALIDATE
/

CREATE INDEX NLG_OBJ_TYPE_IDX ON NM_LOCATION_GEOMETRY
(NLG_OBJ_TYPE)
/

ALTER TABLE NM_LOCATION_GEOMETRY add
CONSTRAINT NLG_FK_OBJ_TYPE
FOREIGN KEY
(NLG_OBJ_TYPE) REFERENCES NM_INV_TYPES_ALL (NIT_INV_TYPE)
/


delete from user_sdo_geom_metadata
where table_name = 'NM_LOCATION_GEOMETRY' and column_name = 'NLG_GEOMETRY'
/

Prompt Spatial registration

insert into user_sdo_geom_metadata
(table_name, column_name, diminfo, srid)
select 'NM_LOCATION_GEOMETRY', 'NLG_GEOMETRY', sdo_lrs.convert_to_std_dim_array(nm3sdo.coalesce_nw_diminfo), srid
from table(NM3SDO.GET_NW_THEMES().nta_theme_array ) t, nm_themes_all, user_sdo_geom_metadata
where nth_feature_table = table_name
and nth_feature_shape_column = column_name 
and nth_theme_id = nthe_id
and rownum = 1
/


CREATE INDEX NLG_SPIDX ON NM_LOCATION_GEOMETRY
(NLG_GEOMETRY)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
/

CREATE INDEX NLG_NAL_IDX ON NM_LOCATION_GEOMETRY
(NLG_NAL_ID)
/

CREATE INDEX NLG_LOC_IDX ON NM_LOCATION_GEOMETRY
(NLG_LOC_ID)
/


DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -2289);
BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE NLG_ID_SEQ';
EXCEPTION
   WHEN not_exists
Then NULL;
end;
/ 



CREATE SEQUENCE NLG_ID_SEQ
/

CREATE OR REPLACE TRIGGER NM_LOCATION_GEOMETRY_TRG
BEFORE INSERT
ON NM_LOCATION_GEOMETRY
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
  :new.NLG_ID := NLG_ID_SEQ.nextval;
END NM_LOCATION_GEOMETRY_TRG;
/


ALTER TABLE NM_LOCATION_GEOMETRY ADD (
  PRIMARY KEY
  (NLG_ID)
  USING INDEX
  ENABLE VALIDATE)
/  

ALTER TABLE NM_LOCATION_GEOMETRY ADD (
  CONSTRAINT NLG_FK_LOC 
  FOREIGN KEY (NLG_LOC_ID) 
  REFERENCES NM_LOCATIONS_ALL (NM_LOC_ID)
  ENABLE VALIDATE)
/  

ALTER TABLE NM_LOCATION_GEOMETRY ADD (
  CONSTRAINT NLG_FK_NAL 
  FOREIGN KEY (NLG_NAL_ID) 
  REFERENCES NM_ASSET_LOCATIONS_ALL (NAL_ID)
  ENABLE VALIDATE)
/  


Prompt Location Bridge Inventory Category

INSERT into nm_inv_categories
( nic_category, nic_descr )
select 'L', 'Location Bridge'
from dual
where not exists ( select 1 from nm_inv_categories where nic_category = 'L' )
/

Prompt Location Bridge - Admin Unit

insert into nm_au_types
(nat_admin_type, nat_descr )
select 'NONE', 'No Admin-Unit Security'
from dual
where not exists ( select 1 from nm_au_types where nat_admin_type = 'NONE' )
/ 

DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -942);
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE NM_ASSET_GEOMETRY_ALL CASCADE CONSTRAINTS';
EXCEPTION
   WHEN not_exists
Then NULL;
end;
/ 

Prompt Asset Aggregated Geometry 

CREATE TABLE NM_ASSET_GEOMETRY_ALL
(
  NAG_ID             INTEGER                    NOT NULL,
  NAG_LOCATION_TYPE  VARCHAR2(1 BYTE)           NOT NULL,
  NAG_ASSET_ID       NUMBER(38)                 NOT NULL,
  NAG_OBJ_TYPE       VARCHAR2(4 BYTE)           NOT NULL,
  NAG_START_DATE     DATE                       NOT NULL,
  NAG_END_DATE       DATE,
  NAG_GEOMETRY       MDSYS.SDO_GEOMETRY
)
/

CREATE INDEX NAG_ID_IDX ON NM_ASSET_GEOMETRY_ALL
(NAG_ASSET_ID)
/


CREATE INDEX NAG_OBJ_TYPE_IDX ON NM_ASSET_GEOMETRY_ALL
(NAG_OBJ_TYPE)
/

--  There is no statement for index HIGHWAYS.SYS_C00119096.
--  The object is created when the parent object is created.

CREATE UNIQUE INDEX NAG_ASSET_IDX ON NM_ASSET_GEOMETRY_ALL
(NAG_ASSET_ID, NAG_OBJ_TYPE, NAG_START_DATE, NAG_LOCATION_TYPE)
/

delete from user_sdo_geom_metadata
where table_name = 'NM_ASSET_GEOMETRY_ALL' and column_name = 'NAG_GEOMETRY'
/

insert into user_sdo_geom_metadata
(table_name, column_name, diminfo, srid)
select 'NM_ASSET_GEOMETRY_ALL', 'NAG_GEOMETRY', sdo_lrs.convert_to_std_dim_array(nm3sdo.coalesce_nw_diminfo), srid
from table(NM3SDO.GET_NW_THEMES().nta_theme_array ) t, nm_themes_all, user_sdo_geom_metadata
where nth_feature_table = table_name
and nth_feature_shape_column = column_name 
and nth_theme_id = nthe_id
and rownum = 1
/


CREATE INDEX NAG_SPIDX ON NM_ASSET_GEOMETRY_ALL
(NAG_GEOMETRY)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
/

DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -2289);
BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE NAG_ID_SEQ';
EXCEPTION
   WHEN not_exists
Then NULL;
end;
/ 

create sequence nag_id_seq start with 1
/

CREATE OR REPLACE TRIGGER NM_ASSET_GEOMETRY_ALL_TRG
BEFORE INSERT
ON NM_ASSET_GEOMETRY_ALL
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
  :new.NAG_ID := NAG_ID_SEQ.nextval;
END NM_ASSET_GEOMETRY_ALL_TRG;
/


ALTER TABLE NM_ASSET_GEOMETRY_ALL ADD (
  PRIMARY KEY
  (NAG_ID)
  USING INDEX
  ENABLE VALIDATE,
  CONSTRAINT NAG_UK
  UNIQUE (NAG_ASSET_ID, NAG_OBJ_TYPE, NAG_START_DATE, NAG_LOCATION_TYPE)
  USING INDEX NAG_ASSET_IDX
  ENABLE VALIDATE)
/  

ALTER TABLE NM_ASSET_GEOMETRY_ALL ADD (
  CONSTRAINT NAG_FK_OBJ_TYPE 
  FOREIGN KEY (NAG_OBJ_TYPE) 
  REFERENCES NM_INV_TYPES_ALL (NIT_INV_TYPE)
  ENABLE VALIDATE)
/

CREATE OR REPLACE FORCE VIEW NM_ASSET_GEOMETRY
(
   NAG_ID,
   NAG_LOCATION_TYPE,
   NAG_ASSET_ID,
   NAG_OBJ_TYPE,
   NAG_START_DATE,
   NAG_END_DATE,
   NAG_GEOMETRY
)
AS
   SELECT "NAG_ID",
          "NAG_LOCATION_TYPE",
          "NAG_ASSET_ID",
          "NAG_OBJ_TYPE",
          "NAG_START_DATE",
          "NAG_END_DATE",
          "NAG_GEOMETRY"
     FROM nm_asset_geometry_all
    WHERE     nag_start_date <=
                 TO_DATE (SYS_CONTEXT ('NM3CORE', 'EFFECTIVE_DATE'),
                          'DD-MON-YYYY')
          AND NVL (nag_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >
                 TO_DATE (SYS_CONTEXT ('NM3CORE', 'EFFECTIVE_DATE'),
                          'DD-MON-YYYY');

DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -942);
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE LB_UNITS CASCADE CONSTRAINTS';
EXCEPTION
   WHEN not_exists
Then NULL;
end;
/ 

Prompt units 

CREATE TABLE lb_units
(
   external_unit_id    INTEGER NOT NULL,
   external_unit_name  VARCHAR2(2000),
   exor_unit_id        NUMBER(4) NOT NULL,
   exor_unit_name      VARCHAR2(20) NOT NULL,
      CONSTRAINT lb_units_uk1 UNIQUE ( external_unit_id )
--      ,
--      CONSTRAINT lb_units_uk2 UNIQUE ( exor_unit_name )
);

ALTER TABLE lb_units ADD CONSTRAINT lb_units_fk1
FOREIGN KEY ( exor_unit_id ) REFERENCES nm_units( un_unit_id );


/*
CREATE TABLE lb_users
(
   external_username   VARCHAR2 (300),
   exor_user_id        INTEGER,
   exor_username       VARCHAR2 (100),
   CONSTRAINT lb_users_pk PRIMARY KEY (external_username)
);

alter table lb_users add constraint lb_users_fk_hus
foreign key (exor_user_id ) references hig_users(hus_user_id);

*/

Prompt Object registry

DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -942);
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE LB_OBJECTS CASCADE CONSTRAINTS';
EXCEPTION
   WHEN not_exists
Then NULL;
end;
/ 

create table lb_objects ( object_name varchar2(30), object_type varchar2(30))
/

CREATE UNIQUE INDEX LB_OBJECTS_PK ON LB_OBJECTS
(OBJECT_NAME, OBJECT_TYPE)
/

ALTER TABLE LB_OBJECTS ADD (
  PRIMARY KEY
  (OBJECT_NAME, OBJECT_TYPE)
  USING INDEX LB_OBJECTS_PK
  ENABLE VALIDATE)
/  


prompt "DDL Completed"