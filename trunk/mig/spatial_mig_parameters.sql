-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)spatial_mig_parameters.sql	1.2 02/09/05
--       Module Name      : spatial_mig_parameters.sql
--       Date into SCCS   : 05/02/09 12:33:40
--       Date fetched Out : 07/06/13 14:09:37
--       SCCS Version     : 1.2
--
--
--   Author : Darren Cope
--
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------


set lines 80
set serveroutput on
set echo off

declare
  cursor ft is
  select SUBSTR(gt_feature_table,instr(gt_feature_table,'.')+1,length(gt_feature_table)) c_feature_table
  from   gis_themes
  where  gt_route_theme = 'Y';

  cursor sc(cp_ft VARCHAR2) is
  select SUBSTR(spatial_column ,instr(spatial_column ,'.')+1,length(spatial_column )) c_spatial_column
  from   sde.layers
  where  owner = USER
  and table_name = cp_ft;

  l_ft VARCHAR2(30);
  l_sc VARCHAR2(30);

  ex_no_ft EXCEPTION;
  ex_no_sc EXCEPTION;

BEGIN

  OPEN ft;
  FETCH ft INTO l_ft;
  IF ft%NOTFOUND THEN
    RAISE ex_no_ft;
  END IF;
  CLOSE ft;

  OPEN sc(l_ft);
  FETCH sc INTO l_sc;
  IF sc%NOTFOUND THEN
    RAISE ex_no_sc;
  END IF;
  CLOSE sc;

  dbms_output.put_line('Export Parameters');
  dbms_output.put_line('');
  dbms_output.put_Line('Feature Table : '||l_ft);
  dbms_output.put_Line('Shape Column  : '||l_sc);  

EXCEPTION
  WHEN ex_no_ft THEN
    CLOSE ft;
    RAISE_APPLICATION_ERROR(-20001,'Feature Table not found');
  WHEN ex_no_sc THEN
    CLOSE sc;
    RAISE_APPLICATION_ERROR(-20001,'Spatial Table not found');
END;
/
