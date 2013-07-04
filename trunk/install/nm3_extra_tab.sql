-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3_extra_tab.sql	1.3 11/10/03
--       Module Name      : nm3_extra_tab.sql
--       Date into SCCS   : 03/11/10 09:10:45
--       Date fetched Out : 07/06/13 13:57:31
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
-- This script contains objects that use objects not owned by ourselves
-- This prevents entry into designer
--
--

create table nm_point_locations
( npl_id number(38) not null,
  npl_location mdsys.sdo_geometry not null )
/

alter table nm_point_locations
  add constraint npl_pk primary key ( npl_id )
/

CREATE TABLE NM_SHAPES_1
(
  NS_NE_ID       NUMBER(9)                      NOT NULL,
  NS_LAYER_ID    NUMBER(9)                      NOT NULL,
  NS_START_DATE  DATE                           NOT NULL,
  NS_END_DATE    DATE,
  NS_SHAPE       NUMBER(38),
  NS_GEOMETRY    VARCHAR2(240)
)
/
