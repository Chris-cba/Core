--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/install/aggregated_geometry_ddl.sql-arc   1.2   Apr 20 2016 16:38:32   Rob.Coupe  $
--       Module Name      : $Workfile:   aggregated_geometry_ddl.sql  $
--       Date into PVCS   : $Date:   Apr 20 2016 16:38:32  $
--       Date fetched Out : $Modtime:   Apr 20 2016 16:37:34  $
--       PVCS Version     : $Revision:   1.2  $
--
--   Author : R.A. Coupe
--
--   Script for initial installation of a table and data to allow the storage of 
--   aggregated geometry data
--
-----------------------------------------------------------------------------
-- Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--

prompt Drop any existing aggregated data

declare
   not_exists exception;
   pragma exception_init( not_exists, -942);
begin
   execute immediate ('drop table nm_inv_geometry_all');
exception
   when not_exists then null;
end;
/

prompt Create table to provide repository for aggregated geometry

CREATE TABLE nm_inv_geometry_all
(
   asset_id     INTEGER NOT NULL,
   asset_type   VARCHAR2 (4) NOT NULL,
   start_date   date NOT NULL,
   end_date     date,
   shape        MDSYS.sdo_geometry
)
/

prompt Indexes and Consraints

CREATE UNIQUE INDEX NIG_PK_IDX ON NM_INV_GEOMETRY_ALL
(ASSET_ID, asset_type, START_DATE)
/

ALTER TABLE NM_INV_GEOMETRY_ALL ADD (
  CONSTRAINT NIG_PK
  PRIMARY KEY
  (ASSET_ID, asset_type, START_DATE)
  USING INDEX NIG_PK_IDX
  ENABLE VALIDATE)
/  

create index nig_type_idx on nm_inv_geometry_all (asset_type)
/

Prompt Spatial metadata

declare
  duplicate_SDO_data exception;
  pragma exception_init( duplicate_SDO_data, -13223); -- duplicate entry for NM_INV_GEOMETRY_ALL.SHAPE in SDO_GEOM_METADATA
begin  
   insert into user_sdo_geom_metadata
   select 'NM_INV_GEOMETRY_ALL', 'SHAPE', diminfo, srid
   from user_sdo_geom_metadata where table_name = 'NM_POINT_LOCATIONS';
exception
   when duplicate_SDO_data 
     then NULL;
end;
/

Prompt Spatial Index

create index nig_spidx on nm_inv_geometry_all
(shape) indextype is mdsys.spatial_index
/

Prompt View definition

CREATE OR REPLACE FORCE VIEW NM_INV_GEOMETRY
(ASSET_ID, ASSET_TYPE, START_DATE, END_DATE, SHAPE)
AS
SELECT "ASSET_ID",
       "ASSET_TYPE",
       "START_DATE",
       "END_DATE",
       "SHAPE"
  FROM nm_inv_geometry_all;
/


declare
  duplicate_SDO_data exception;
  pragma exception_init( duplicate_SDO_data, -13223); -- duplicate entry for NM_INV_GEOMETRY_ALL.SHAPE in SDO_GEOM_METADATA
begin  
  insert into user_sdo_geom_metadata
  select 'NM_INV_GEOMETRY', 'SHAPE', diminfo, srid
  from user_sdo_geom_metadata where table_name = 'NM_INV_GEOMETRY_ALL';
exception
   when duplicate_SDO_data 
     then NULL;
end;
/

Prompt Remove header table 

declare
   not_exists exception;
   pragma exception_init( not_exists, -942);
begin
   execute immediate ('drop table nm_inv_aggr_sdo_types');
exception
   when not_exists then null;
end;
/

prompt create list of asset types that are aggregated

create table nm_inv_aggr_sdo_types
( nit_inv_type varchar2(4),
  date_created date,
  date_modified date,
  modified_by varchar2(30),
  created_by  varchar2(30),
constraint niaggr_pk primary key (nit_inv_type ))
organization index
/


CREATE OR REPLACE TRIGGER nm_inv_aggr_sdo_types_who
 BEFORE insert OR update
 ON nm_inv_aggr_sdo_types
 FOR each row
DECLARE
   l_sysdate DATE;
   l_user    VARCHAR2(30);
BEGIN
   SELECT sysdate
         ,sys_context('NM3_SECURITY_CTX', 'USERNAME' )
    INTO  l_sysdate
         ,l_user
    FROM  dual;
--
   IF inserting
    THEN
      :new.DATE_CREATED  := l_sysdate;
      :new.CREATED_BY    := l_user;
   END IF;
--
   :new.DATE_MODIFIED := l_sysdate;
   :new.MODIFIED_BY   := l_user;
--
END nm_inv_aggr_sdo_types_who;
/


begin
  NM3DDL.CREATE_SYNONYM_FOR_OBJECT('NM_INV_GEOMETRY_ALL');
  NM3DDL.CREATE_SYNONYM_FOR_OBJECT('NM_INV_GEOMETRY');
  NM3DDL.CREATE_SYNONYM_FOR_OBJECT('NM_INV_SDO_AGGR');
  NM3DDL.CREATE_SYNONYM_FOR_OBJECT('NM_INV_AGGR_SDO_TYPES');
end;
/

