-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3110_nm3120_ddl_upg.sql	1.1 07/14/04
--       Module Name      : nm3110_nm3120_ddl_upg.sql
--       Date into SCCS   : 04/07/14 15:11:45
--       Date fetched Out : 07/06/13 13:57:45
--       SCCS Version     : 1.1
--
--   Product DDL upgrade script
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF

--
--------------------------------------------------------------------
-- START OF HIG_HD CHANGES (originally excluded from 3.1.1.0 upgrade)
--------------------------------------------------------------------
--
PROMPT Processing Table  'HIG_HD_COMMON_GATEWAYS' - ignore object already exists errors
CREATE TABLE hig_hd_common_gateways
  (hhg_name    VARCHAR2(30) NOT NULL
  ,hhg_descr   VARCHAR2(80) NOT NULL
  ,hhg_package VARCHAR2(30) NOT NULL
  )
/
ALTER TABLE hig_hd_common_gateways ADD CONSTRAINT hhg_pk PRIMARY KEY (hhg_name)
/
--
--------------------------------------------------------------------
-- END OF HIG_HD CHANGES (originally exluded from 3.1.1.0 upgrade)
--------------------------------------------------------------------
--

--
--------------------------------------------------------------------
-- START OF MapServer 3 Upgrade
--------------------------------------------------------------------
--
PROMPT Processing table NM_SPATIAL_EXTENTS
CREATE TABLE NM_SPATIAL_EXTENTS 
  ( nspe_id               NUMBER(38)         NOT NULL
  , nspe_owner            VARCHAR2(30)       NOT NULL
  , nspe_name             VARCHAR2(30)       NOT NULL
  , nspe_descr            VARCHAR2(4000)
  , nspe_type             VARCHAR2(4)        NOT NULL
  , nspe_boundary         MDSYS.SDO_GEOMETRY
  , nspe_date_created     DATE               NOT NULL
  , nspe_date_modified    DATE               NOT NULL
  , nspe_modified_by      VARCHAR2(30)       NOT NULL
  , nspe_created_by       VARCHAR2(30)       NOT NULL
  , mp_idx                NUMBER(11)
  )
/

PROMPT Processing table NM_THEME_GTYPES
CREATE TABLE NM_THEME_GTYPES 
  ( ntg_theme_id          NUMBER(9) NOT NULL
  , ntg_gtype             NUMBER    NOT NULL
  , ntg_seq_no            NUMBER(4) 
  )
/

PROMPT Processing table MV_ERRORS
CREATE TABLE MV_ERRORS (
   err_sequence          NUMBER,
   err_num               NUMBER,
   err_msg               VARCHAR2(1000) )
/

PROMPT Processing table CENTSIZE
CREATE TABLE CENTSIZE (
   col1 mdsys.sdo_geometry )
/

PROMPT Processing table GIS_DATA_OBJECTS
ALTER TABLE GIS_DATA_OBJECTS 
  ADD gdo_seq_no NUMBER
/

------------------------
-- Sequences required
------------------------
CREATE SEQUENCE gdo_seq_no
/

CREATE SEQUENCE mv_error_seq
/
------------------------
-- Functions required
------------------------

CREATE OR REPLACE FUNCTION STYLE_FROM_XML ( STYLE IN VARCHAR2 ) RETURN VARCHAR2 IS
  RETVAL VARCHAR2(2000);
BEGIN
  RETVAL :=
         to_char(substr(style,
                  instr(style, 'features style', 1, 1) + 16,
                 (instr(style, '>' , instr( style, 'features style', 1, 1), 1)) -
                 (instr(style, 'features style', 1, 1)) -17
           )
         );
  RETURN RETVAL;
END;
/

CREATE OR REPLACE FUNCTION getcent RETURN NUMBER IS
BEGIN
  DECLARE
    x number;
    y number;
    cent number;
    CURSOR c1 is 
      SELECT col1 
        FROM centsize;
  BEGIN
    FOR r IN c1 LOOP
      x:=r.col1.sdo_point.x;
      y:=r.col1.sdo_point.y;
      cent:=r.col1.sdo_point.z;
      dbms_output.put_line(x);
      dbms_output.put_line(y);
      dbms_output.put_line(cent);
    END LOOP;
   RETURN(cent);
 END;
END;
/

CREATE OR REPLACE FUNCTION getx  RETURN NUMBER IS
BEGIN
 DECLARE
  i number;
  x number;
  y number;
  cent number;
  CURSOR c1 IS 
   SELECT col1 
     FROM centsize;
 BEGIN
  FOR r IN c1 LOOP
    x:=r.col1.sdo_point.x;
    y:=r.col1.sdo_point.y;
    cent:=r.col1.sdo_point.z;
    dbms_output.put_line(x);
    dbms_output.put_line(y);
    dbms_output.put_line(cent);
  END LOOP;
  RETURN(x);
 END;
END;
/

CREATE OR REPLACE FUNCTION gety RETURN NUMBER IS
BEGIN
 DECLARE
  i number;
  x number;
  y number;
  cent number;
  CURSOR c1 IS 
   SELECT col1 
     FROM centsize;
 BEGIN
  FOR r IN c1 LOOP
    x:=r.col1.sdo_point.x;
    y:=r.col1.sdo_point.y;
    cent:=r.col1.sdo_point.z;
    dbms_output.put_line(x);
    dbms_output.put_line(y);
    dbms_output.put_line(cent);
  END LOOP;
  RETURN(y);
 END;
END;
/

--
--------------------------------------------------------------------
-- END OF MapServer 3 Upgrade
--------------------------------------------------------------------
--
