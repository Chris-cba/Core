-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3120_nm3130_ddl_upg.sql	1.2 08/17/04
--       Module Name      : nm3120_nm3130_ddl_upg.sql
--       Date into SCCS   : 04/08/17 14:56:57
--       Date fetched Out : 07/06/13 13:57:50
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

set echo off
set linesize 120
set heading off
set feedback off

--
-----------------------------------------------------------------------------
-- NM_AREA_TYPES 
-----------------------------------------------------------------------------
--
CREATE SEQUENCE NAT_ID_SEQ;

CREATE TABLE NM_AREA_TYPES
(
  NAT_ID              NUMBER               NOT NULL,
  NAT_NT_TYPE         VARCHAR2(4)          NOT NULL,
  NAT_GTY_GROUP_TYPE  VARCHAR2(4)          NOT NULL,
  NAT_DESCR           VARCHAR2(80),
  NAT_SEQ_NO          NUMBER,
  NAT_START_DATE      DATE                 NOT NULL,
  NAT_END_DATE        DATE,
  NAT_SHAPE_TYPE      VARCHAR2(10)         DEFAULT 'TRACED'              NOT NULL
)
LOGGING 
NOCACHE
NOPARALLEL;


CREATE UNIQUE INDEX NATY_PK ON NM_AREA_TYPES
(NAT_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX NAT_UK ON NM_AREA_TYPES
(NAT_NT_TYPE, NAT_GTY_GROUP_TYPE)
LOGGING
NOPARALLEL;


ALTER TABLE NM_AREA_TYPES ADD (
  CONSTRAINT NATY_PK PRIMARY KEY (NAT_ID));

ALTER TABLE NM_AREA_TYPES ADD (
  CONSTRAINT NAT_UK UNIQUE (NAT_NT_TYPE, NAT_GTY_GROUP_TYPE));
--
-----------------------------------------------------------------------------
-- END OF NM_AREA_TYPES 
-----------------------------------------------------------------------------
--
 
--
-----------------------------------------------------------------------------
-- NM_AREA_THEMES 
-----------------------------------------------------------------------------
--
CREATE TABLE NM_AREA_THEMES
(
  NATH_NAT_ID        NUMBER,
  NATH_NTH_THEME_ID  NUMBER
);


CREATE INDEX NATH_FK_NTH_IND ON NM_AREA_THEMES
(NATH_NTH_THEME_ID);


CREATE UNIQUE INDEX NATH_PK ON NM_AREA_THEMES
(NATH_NTH_THEME_ID, NATH_NAT_ID);


ALTER TABLE NM_AREA_THEMES ADD (
  CONSTRAINT NATH_PK PRIMARY KEY (NATH_NTH_THEME_ID, NATH_NAT_ID));


ALTER TABLE NM_AREA_THEMES ADD (
  CONSTRAINT NATH_FK_NAT FOREIGN KEY (NATH_NAT_ID) 
    REFERENCES NM_AREA_TYPES (NAT_ID)
    ON DELETE CASCADE);

ALTER TABLE NM_AREA_THEMES ADD (
  CONSTRAINT NATH_FK_NTH FOREIGN KEY (NATH_NTH_THEME_ID) 
    REFERENCES NM_THEMES_ALL (NTH_THEME_ID)
    ON DELETE CASCADE); 
--
-----------------------------------------------------------------------------
-- END OF NM_AREA_THEMES 
-----------------------------------------------------------------------------
--
