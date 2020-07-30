-----------------------------------------------------------------------------
-- sdl_themes.sql
----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/sdl_themes.sql-arc   1.2   Jul 30 2020 08:24:54   Vikas.Mhetre  $
--       Module Name      : $Workfile:   sdl_themes.sql  $
--       Date into PVCS   : $Date:   Jul 30 2020 08:24:54  $
--       Date fetched Out : $Modtime:   Jul 23 2020 21:04:46  $
--       Version          : $Revision:   1.2  $
--
-- Description: To create base table metadata and themes relating to SDL geometry tables
--
-----------------------------------------------------------------------------
--    Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
-- 
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF

SET TERM ON

PROMPT Cleaning up existing SDL themes...
-- Delete already created themes in case need to re-ran this script
DELETE FROM nm_themes_all
	  WHERE nth_feature_table IN ('SDL_LOAD_DATA',
				                  'V_SDL_LOAD_DATA',
				                  'SDL_WIP_DATUMS',
				                  'V_SDL_DATUM_ACCURACY_0_TO_20',
				                  'V_SDL_DATUM_ACCURACY',
				                  'V_SDL_TRANSFERRED_DATUMS',
				                  'SDL_WIP_NODES',
				                  'V_SDL_WIP_NODES',
				                  'V_SDL_PLINE_STATS',
				                  'V_SDL_DATUM_ACCURACY_NO_STATS',
				                  'V_SDL_DATUM_ACCURACY_20_TO_40',
				                  'V_SDL_DATUM_ACCURACY_40_TO_60',
				                  'V_SDL_DATUM_ACCURACY_60_TO_80',
				                  'V_SDL_DATUM_ACCURACY_80_TO_100',
				                  'V_SDL_DATUM_ACCURACY_OVER_100',
				                  'V_SDL_WIP_NODES_UNDER_0',
				                  'V_SDL_WIP_NODES_0_TO_1',
				                  'V_SDL_WIP_NODES_OVER_1',
				                  'V_SDL_PLINE_STATS_NO_STATS',
				                  'V_SDL_PLINE_STATS_0_TO_20',
				                  'V_SDL_PLINE_STATS_20_TO_40',
				                  'V_SDL_PLINE_STATS_40_TO_60',
				                  'V_SDL_PLINE_STATS_60_TO_80',
				                  'V_SDL_PLINE_STATS_80_TO_100',
				                  'V_SDL_PLINE_STATS_OVER_100');

DELETE FROM mdsys.sdo_geom_metadata_table
    WHERE sdo_table_name IN ('SDL_LOAD_DATA',
                             'V_SDL_LOAD_DATA',
                             'SDL_WIP_DATUMS',
                             'V_SDL_DATUM_ACCURACY_0_TO_20',
                             'V_SDL_DATUM_ACCURACY',
                             'V_SDL_TRANSFERRED_DATUMS',
                             'SDL_WIP_NODES',
                            'V_SDL_WIP_NODES',
                            'V_SDL_PLINE_STATS',
                            'V_SDL_DATUM_ACCURACY_NO_STATS',
                            'V_SDL_DATUM_ACCURACY_20_TO_40',
                            'V_SDL_DATUM_ACCURACY_40_TO_60',
                            'V_SDL_DATUM_ACCURACY_60_TO_80',
                            'V_SDL_DATUM_ACCURACY_80_TO_100',
                            'V_SDL_DATUM_ACCURACY_OVER_100',
                            'V_SDL_WIP_NODES_UNDER_0',
                            'V_SDL_WIP_NODES_0_TO_1',
                            'V_SDL_WIP_NODES_OVER_1',
                            'V_SDL_PLINE_STATS_NO_STATS',
                            'V_SDL_PLINE_STATS_0_TO_20',
                            'V_SDL_PLINE_STATS_20_TO_40',
                            'V_SDL_PLINE_STATS_40_TO_60',
                            'V_SDL_PLINE_STATS_60_TO_80',
                            'V_SDL_PLINE_STATS_80_TO_100',
                            'V_SDL_PLINE_STATS_OVER_100');
						  
DELETE FROM sde.layers 
WHERE table_name IN ('V_SDL_DATUM_ACCURACY_0_TO_20',
                     'V_SDL_DATUM_ACCURACY_20_TO_40',
                     'V_SDL_DATUM_ACCURACY_40_TO_60',
                     'V_SDL_DATUM_ACCURACY_60_TO_80',
                     'V_SDL_DATUM_ACCURACY_80_TO_100',
                     'V_SDL_DATUM_ACCURACY_NO_STATS',
                     'V_SDL_DATUM_ACCURACY_OVER_100',
                     'V_SDL_PLINE_STATS_0_TO_20',
                     'V_SDL_PLINE_STATS_20_TO_40',
                     'V_SDL_PLINE_STATS_40_TO_60',
                     'V_SDL_PLINE_STATS_60_TO_80',
                     'V_SDL_PLINE_STATS_80_TO_100',
                     'V_SDL_PLINE_STATS_NO_STATS',
                     'V_SDL_PLINE_STATS_OVER_100',
                     'V_SDL_WIP_NODES_0_TO_1',
                     'V_SDL_WIP_NODES_OVER_1',
                     'V_SDL_WIP_NODES_UNDER_0');

DELETE FROM sde.geometry_columns 
WHERE f_table_name IN ('V_SDL_DATUM_ACCURACY_0_TO_20',
                     'V_SDL_DATUM_ACCURACY_20_TO_40',
                     'V_SDL_DATUM_ACCURACY_40_TO_60',
                     'V_SDL_DATUM_ACCURACY_60_TO_80',
                     'V_SDL_DATUM_ACCURACY_80_TO_100',
                     'V_SDL_DATUM_ACCURACY_NO_STATS',
                     'V_SDL_DATUM_ACCURACY_OVER_100',
                     'V_SDL_PLINE_STATS_0_TO_20',
                     'V_SDL_PLINE_STATS_20_TO_40',
                     'V_SDL_PLINE_STATS_40_TO_60',
                     'V_SDL_PLINE_STATS_60_TO_80',
                     'V_SDL_PLINE_STATS_80_TO_100',
                     'V_SDL_PLINE_STATS_NO_STATS',
                     'V_SDL_PLINE_STATS_OVER_100',
                     'V_SDL_WIP_NODES_0_TO_1',
                     'V_SDL_WIP_NODES_OVER_1',
                     'V_SDL_WIP_NODES_UNDER_0');
					 
DELETE FROM sde.column_registry 
WHERE table_name IN ('V_SDL_DATUM_ACCURACY_0_TO_20',
                     'V_SDL_DATUM_ACCURACY_20_TO_40',
                     'V_SDL_DATUM_ACCURACY_40_TO_60',
                     'V_SDL_DATUM_ACCURACY_60_TO_80',
                     'V_SDL_DATUM_ACCURACY_80_TO_100',
                     'V_SDL_DATUM_ACCURACY_NO_STATS',
                     'V_SDL_DATUM_ACCURACY_OVER_100',
                     'V_SDL_PLINE_STATS_0_TO_20',
                     'V_SDL_PLINE_STATS_20_TO_40',
                     'V_SDL_PLINE_STATS_40_TO_60',
                     'V_SDL_PLINE_STATS_60_TO_80',
                     'V_SDL_PLINE_STATS_80_TO_100',
                     'V_SDL_PLINE_STATS_NO_STATS',
                     'V_SDL_PLINE_STATS_OVER_100',
                     'V_SDL_WIP_NODES_0_TO_1',
                     'V_SDL_WIP_NODES_OVER_1',
                     'V_SDL_WIP_NODES_UNDER_0');
					 
DELETE FROM user_sdo_styles
WHERE name IN ('M.SDL_DATUM_ARROW',
               'T.SDL_TITLE',
               'L.SDL_ORIG_SUBMISSION',
               'L.SDL_DATUMS',
               'L.SDL_TRANS_DATUMS',
               'L.SDL_LINE',
               'L.SDL_LINE1',
               'L.SDL_LINE2',
               'L.SDL_LINE3',
               'L.SDL_LINE4',
               'L.SDL_LINE5',
               'L.SDL_LINE6',
               'L.SDL_LINE7',
               'M.SDL_NODE',
               'M.SDL_NODE1',
               'M.SDL_NODE2',
               'M.SDL_NODE3');
					 
DECLARE
  --
  view_not_exist  EXCEPTION;
  PRAGMA exception_init( view_not_exist, -942);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP VIEW V_SDL_DATUM_ACCURACY_0_TO_20';
  --
EXCEPTION 
  WHEN view_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  view_not_exist  EXCEPTION;
  PRAGMA exception_init( view_not_exist, -942);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP VIEW V_SDL_DATUM_ACCURACY_20_TO_40';
  --
EXCEPTION 
  WHEN view_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  view_not_exist  EXCEPTION;
  PRAGMA exception_init( view_not_exist, -942);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP VIEW V_SDL_DATUM_ACCURACY_40_TO_60';
  --
EXCEPTION 
  WHEN view_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  view_not_exist  EXCEPTION;
  PRAGMA exception_init( view_not_exist, -942);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP VIEW V_SDL_DATUM_ACCURACY_60_TO_80';
  --
EXCEPTION 
  WHEN view_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  view_not_exist  EXCEPTION;
  PRAGMA exception_init( view_not_exist, -942);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP VIEW V_SDL_DATUM_ACCURACY_80_TO_100';
  --
EXCEPTION 
  WHEN view_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  view_not_exist  EXCEPTION;
  PRAGMA exception_init( view_not_exist, -942);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP VIEW V_SDL_DATUM_ACCURACY_NO_STATS';
  --
EXCEPTION 
  WHEN view_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  view_not_exist  EXCEPTION;
  PRAGMA exception_init( view_not_exist, -942);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP VIEW V_SDL_DATUM_ACCURACY_OVER_100';
  --
EXCEPTION 
  WHEN view_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  view_not_exist  EXCEPTION;
  PRAGMA exception_init( view_not_exist, -942);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP VIEW V_SDL_PLINE_STATS_0_TO_20';
  --
EXCEPTION 
  WHEN view_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  view_not_exist  EXCEPTION;
  PRAGMA exception_init( view_not_exist, -942);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP VIEW V_SDL_PLINE_STATS_20_TO_40';
  --
EXCEPTION 
  WHEN view_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  view_not_exist  EXCEPTION;
  PRAGMA exception_init( view_not_exist, -942);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP VIEW V_SDL_PLINE_STATS_40_TO_60';
  --
EXCEPTION 
  WHEN view_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  view_not_exist  EXCEPTION;
  PRAGMA exception_init( view_not_exist, -942);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP VIEW V_SDL_PLINE_STATS_60_TO_80';
  --
EXCEPTION 
  WHEN view_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  view_not_exist  EXCEPTION;
  PRAGMA exception_init( view_not_exist, -942);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP VIEW V_SDL_PLINE_STATS_80_TO_100';
  --
EXCEPTION 
  WHEN view_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  view_not_exist  EXCEPTION;
  PRAGMA exception_init( view_not_exist, -942);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP VIEW V_SDL_PLINE_STATS_NO_STATS';
  --
EXCEPTION 
  WHEN view_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  view_not_exist  EXCEPTION;
  PRAGMA exception_init( view_not_exist, -942);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP VIEW V_SDL_PLINE_STATS_OVER_100';
  --
EXCEPTION 
  WHEN view_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  view_not_exist  EXCEPTION;
  PRAGMA exception_init( view_not_exist, -942);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP VIEW V_SDL_WIP_NODES_0_TO_1';
  --
EXCEPTION 
  WHEN view_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  view_not_exist  EXCEPTION;
  PRAGMA exception_init( view_not_exist, -942);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP VIEW V_SDL_WIP_NODES_OVER_1';
  --
EXCEPTION 
  WHEN view_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  view_not_exist  EXCEPTION;
  PRAGMA exception_init( view_not_exist, -942);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP VIEW V_SDL_WIP_NODES_UNDER_0';
  --
EXCEPTION 
  WHEN view_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/

DELETE from user_sdo_maps 
WHERE name = (SELECT hov_value FROM hig_option_values WHERE hov_id = 'SDLMAPNAME');


PROMPT Create SDL Base themes...
-- Create SDL Base themes 
BEGIN
  sdl_ddl.refresh_base_sdl_themes;
END;
/
PROMPT Create SDL themes based on ranges using base Themes...
-- Create SDL themes based on ranges using base Themes
DECLARE
  lv_base_theme  nm_themes_all.nth_theme_id%TYPE;
BEGIN
  /*
  ||Get the base theme.
  */
  lv_base_theme := nm3get.get_nth(pi_nth_theme_name => 'SDL DATUMS AND STATS').nth_theme_id;
  /*
  ||Build the < 0 Theme
  */  
   nm3layer_tool.make_layer_where(pi_base_theme   => lv_base_theme
	                              ,pi_where_clause => 'PCT_MATCH < 0'
	                              ,pi_view_name    => 'V_SDL_DATUM_ACCURACY_NO_STATS');
	--
	UPDATE nm_themes_all
	   SET nth_theme_name = 'DATUM ACCURACY NO STATS'
	 WHERE nth_theme_name = 'V_SDL_DATUM_ACCURACY_NO_STATS'
	     ; 
  /*
  ||Build the 0 to 20 (excluding 20) Theme
  */
  nm3layer_tool.make_layer_where(pi_base_theme   => lv_base_theme
	                              ,pi_where_clause => 'PCT_MATCH >= 0 AND PCT_MATCH < 20'
	                              ,pi_view_name    => 'V_SDL_DATUM_ACCURACY_0_TO_20');
	--
	UPDATE nm_themes_all
	   SET nth_theme_name = 'DATUM ACCURACY 0 TO 20'
	 WHERE nth_theme_name = 'V_SDL_DATUM_ACCURACY_0_TO_20'
	     ;
  /*
  ||Build the 20 to 40 (excluding 40) Theme
  */
  nm3layer_tool.make_layer_where(pi_base_theme   => lv_base_theme
	                              ,pi_where_clause => 'PCT_MATCH >= 20 AND PCT_MATCH < 40'
	                              ,pi_view_name    => 'V_SDL_DATUM_ACCURACY_20_TO_40');
	--
	UPDATE nm_themes_all
	   SET nth_theme_name = 'DATUM ACCURACY 20 TO 40'
	 WHERE nth_theme_name = 'V_SDL_DATUM_ACCURACY_20_TO_40'
	     ;
  /*
  ||Build the 40 to 60 (excluding 60) Theme
  */
  nm3layer_tool.make_layer_where(pi_base_theme   => lv_base_theme
	                              ,pi_where_clause => 'PCT_MATCH >= 40 AND PCT_MATCH < 60'
	                              ,pi_view_name    => 'V_SDL_DATUM_ACCURACY_40_TO_60');
	--
	UPDATE nm_themes_all
	   SET nth_theme_name = 'DATUM ACCURACY 40 TO 60'
	 WHERE nth_theme_name = 'V_SDL_DATUM_ACCURACY_40_TO_60'
	     ;
  /*
  ||Build the 60 to 80 (excluding 80) Theme
  */
  nm3layer_tool.make_layer_where(pi_base_theme   => lv_base_theme
	                              ,pi_where_clause => 'PCT_MATCH >= 60 AND PCT_MATCH < 80'
	                              ,pi_view_name    => 'V_SDL_DATUM_ACCURACY_60_TO_80');
	--
	UPDATE nm_themes_all
	   SET nth_theme_name = 'DATUM ACCURACY 60 TO 80'
	 WHERE nth_theme_name = 'V_SDL_DATUM_ACCURACY_60_TO_80'
	     ;
  /*
  ||Build the 80 to 100 (excluding 100) Theme
  */
  nm3layer_tool.make_layer_where(pi_base_theme   => lv_base_theme
	                              ,pi_where_clause => 'PCT_MATCH >= 80 AND PCT_MATCH < 100'
	                              ,pi_view_name    => 'V_SDL_DATUM_ACCURACY_80_TO_100');
	--
	UPDATE nm_themes_all
	   SET nth_theme_name = 'DATUM ACCURACY 80 TO 100'
	 WHERE nth_theme_name = 'V_SDL_DATUM_ACCURACY_80_TO_100'
	     ;		 
		 
  /*
  ||Build the 100+ Theme
  */
  nm3layer_tool.make_layer_where(pi_base_theme   => lv_base_theme
	                              ,pi_where_clause => 'PCT_MATCH >= 100'
	                              ,pi_view_name    => 'V_SDL_DATUM_ACCURACY_OVER_100');
	--
	UPDATE nm_themes_all
	   SET nth_theme_name = 'DATUM ACCURACY OVER 100'
	 WHERE nth_theme_name = 'V_SDL_DATUM_ACCURACY_OVER_100'
	     ;
	--
	COMMIT;
	--
END;
/
DECLARE
  lv_base_theme  nm_themes_all.nth_theme_id%TYPE;
BEGIN
  /*
  ||Get the base theme.
  */
  lv_base_theme := nm3get.get_nth(pi_nth_theme_name => 'SDL BATCH NODE DATA').nth_theme_id;
  /*
  ||Build the < 0 Theme
  */  
   nm3layer_tool.make_layer_where(pi_base_theme   => lv_base_theme
	                              ,pi_where_clause => 'DISTANCE_FROM < 0'
	                              ,pi_view_name    => 'V_SDL_WIP_NODES_UNDER_0');
	--
	UPDATE nm_themes_all
	   SET nth_theme_name = 'BATCH NODE UNDER 0'
	 WHERE nth_theme_name = 'V_SDL_WIP_NODES_UNDER_0'
	     ; 
  /*
  ||Build the 0 to 1 (excluding 1) Theme
  */
  nm3layer_tool.make_layer_where(pi_base_theme   => lv_base_theme
	                              ,pi_where_clause => 'DISTANCE_FROM >= 0 AND DISTANCE_FROM < 1'
	                              ,pi_view_name    => 'V_SDL_WIP_NODES_0_TO_1');
	--
	UPDATE nm_themes_all
	   SET nth_theme_name = 'BATCH NODE 0 TO 1'
	 WHERE nth_theme_name = 'V_SDL_WIP_NODES_0_TO_1'
	     ;
  /*
  ||Build the 1+ Theme
  */
  nm3layer_tool.make_layer_where(pi_base_theme   => lv_base_theme
	                              ,pi_where_clause => 'DISTANCE_FROM >= 1'
	                              ,pi_view_name    => 'V_SDL_WIP_NODES_OVER_1');
	--
	UPDATE nm_themes_all
	   SET nth_theme_name = 'BATCH NODE OVER 1'
	 WHERE nth_theme_name = 'V_SDL_WIP_NODES_OVER_1'
	     ;
	--
	COMMIT;
	--
END;
/

DECLARE
  lv_base_theme  nm_themes_all.nth_theme_id%TYPE;
BEGIN
  /*
  ||Get the base theme.
  */
  lv_base_theme := nm3get.get_nth(pi_nth_theme_name => 'SDL MATCH DETAIL').nth_theme_id;
  /*
  ||Build the < 0 Theme
  */  
   nm3layer_tool.make_layer_where(pi_base_theme   => lv_base_theme
	                              ,pi_where_clause => 'ACCURACY < 0'
	                              ,pi_view_name    => 'V_SDL_PLINE_STATS_NO_STATS');
	--
	UPDATE nm_themes_all
	   SET nth_theme_name = 'MATCH DETAIL NO STATS'
	 WHERE nth_theme_name = 'V_SDL_PLINE_STATS_NO_STATS'
	     ; 
  /*
  ||Build the 0 to 20 (excluding 20) Theme
  */
  nm3layer_tool.make_layer_where(pi_base_theme   => lv_base_theme
	                              ,pi_where_clause => 'ACCURACY >= 0 AND ACCURACY < 20'
	                              ,pi_view_name    => 'V_SDL_PLINE_STATS_0_TO_20');
	--
	UPDATE nm_themes_all
	   SET nth_theme_name = 'MATCH DETAIL 0 TO 20'
	 WHERE nth_theme_name = 'V_SDL_PLINE_STATS_0_TO_20'
	     ;
  /*
  ||Build the 20 to 40 (excluding 40) Theme
  */
  nm3layer_tool.make_layer_where(pi_base_theme   => lv_base_theme
	                              ,pi_where_clause => 'ACCURACY >= 20 AND ACCURACY < 40'
	                              ,pi_view_name    => 'V_SDL_PLINE_STATS_20_TO_40');
	--
	UPDATE nm_themes_all
	   SET nth_theme_name = 'MATCH DETAIL 20 TO 40'
	 WHERE nth_theme_name = 'V_SDL_PLINE_STATS_20_TO_40'
	     ;
  /*
  ||Build the 40 to 60 (excluding 60) Theme
  */
  nm3layer_tool.make_layer_where(pi_base_theme   => lv_base_theme
	                              ,pi_where_clause => 'ACCURACY >= 40 AND ACCURACY < 60'
	                              ,pi_view_name    => 'V_SDL_PLINE_STATS_40_TO_60');
	--
	UPDATE nm_themes_all
	   SET nth_theme_name = 'MATCH DETAIL 40 TO 60'
	 WHERE nth_theme_name = 'V_SDL_PLINE_STATS_40_TO_60'
	     ;
  /*
  ||Build the 60 to 80 (excluding 80) Theme
  */
  nm3layer_tool.make_layer_where(pi_base_theme   => lv_base_theme
	                              ,pi_where_clause => 'ACCURACY >= 60 AND ACCURACY < 80'
	                              ,pi_view_name    => 'V_SDL_PLINE_STATS_60_TO_80');
	--
	UPDATE nm_themes_all
	   SET nth_theme_name = 'MATCH DETAIL 60 TO 80'
	 WHERE nth_theme_name = 'V_SDL_PLINE_STATS_60_TO_80'
	     ;
  /*
  ||Build the 80 to 100 (excluding 100) Theme
  */
  nm3layer_tool.make_layer_where(pi_base_theme   => lv_base_theme
	                              ,pi_where_clause => 'ACCURACY >= 80 AND ACCURACY < 100'
	                              ,pi_view_name    => 'V_SDL_PLINE_STATS_80_TO_100');
	--
	UPDATE nm_themes_all
	   SET nth_theme_name = 'MATCH DETAIL 80 TO 100'
	 WHERE nth_theme_name = 'V_SDL_PLINE_STATS_80_TO_100'
	     ;		 
		 
  /*
  ||Build the 100+ Theme
  */
  nm3layer_tool.make_layer_where(pi_base_theme   => lv_base_theme
	                              ,pi_where_clause => 'ACCURACY >= 100'
	                              ,pi_view_name    => 'V_SDL_PLINE_STATS_OVER_100');
	--
	UPDATE nm_themes_all
	   SET nth_theme_name = 'MATCH DETAIL OVER 100'
	 WHERE nth_theme_name = 'V_SDL_PLINE_STATS_OVER_100'
	     ;
	--
	COMMIT;
	--
END;
/
PROMPT Inserting SDL user_sdo_styles...
-- SDL Styles
INSERT INTO user_sdo_styles (NAME, TYPE, DESCRIPTION, DEFINITION, IMAGE)
SELECT 'M.SDL_DATUM_ARROW', 'MARKER', 'SDL Datum Arrow', '<?xml version="1.0" standalone="yes"?>
<svg width="1in" height="1in">
  <desc></desc>
  <g class="marker" style="width:50;height:50;font-family:Dialog;font-size:12;font-fill:#FF0000">
    <image x="0" y="0" width="1" height="1" markerType="gif" href="dummy.gif"/>
  </g>
</svg>', (TO_BLOB(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW('iVBORw0KGgoAAAANSUhEUgAAAJEAAACRCAYAAADD2FojAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAadEVYdFNvZnR3YXJlAFBhaW50Lk5FVCB2My41LjEwMPRyoQAAAutJREFUeF7t3U1rG1cUBmCFLlpo00hyUneTWiOL9IPS7gqlDZhIVnDabbpsf0Kh/x/SoySTBnKTSrY1c+7M88DLMdroGl4MvscaTwAAAAAAAAAAAAAAAAAAAAAAAAAAAKAu82bzR4wX97/+5e6rV+BA0/P1XzFe7DI93/wZ887uddjb2yVqM1+tf44J+ymVqM2DxcWXMeHDPlSiN1ldfRwTyvYqUWTeXD6PCe/at0RtZufb72PCfw4tUZu7jy7ux4Trl2iX6fLy78nk+UfxNWN2kxK1mS82T2MyVrdRojb3zrZNTMbmNkvUxgplZI5Rol2sUEbkWCVqY4UyAscuURsrlAHrqkRvYoUyPJ2XKGKFMjB9lKiNFcpA9FmiNlYolctQol2sUCqWpURtrFAqlK1EbaxQKpK1RG2sUCqQvUS7WKEkV0OJ2lSxQpkv1//EKH4DkidfNOvTmGkVDy1Jk3SFUj6spE3GFUrxoJI/mVYoxQNKPcmwQikeTOpK3yuU4qGkzvS1QikeRupO1yuU4iFkGOlqhVJ8cxlOulihFN9YhpXF4uKTmEdTfFMZRu492ixjHl3xzaXuzJaXz2J2pngIqTg97NfKB5HqMj/fPozZi+KBpJ7MlptfY/aqeDDJn0yfFikeUHIn2+fWioeUnJk16x9iplM8rORK6j/cny3Xv8coHlxy5PR0+2lMMqnl0x4ni+03Mckoe4niV/bfYpJZ6hJ5IFYdMpYofvp8FZNaZCpRhttmriFDiTybqHJ9l+iz1dWDmNSsrxJNm6c/xmQIui6Rx8QMUJcl8sCqgeqiRCdnm29jMlTHLNHrXSRDd7QSuW0ej9sukdvmEbqtEs2a9eOYjNFNS+S2mRuVyG0zL12nRCfNk59iwiuHlMhtM0X7lmi+uvo8Jrzr/0o0X62/iwnv974S+Reb7K1UomM/BIqBebtE0+bJ2csX4RC7m2a3zQAAAAAAAAAAAAAAAAAAAAAAAAAAHG4y+Rfpm7IZEOaIJgAAAABJRU5ErkJggg=='))))
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM user_sdo_styles
                   WHERE NAME = 'M.SDL_DATUM_ARROW');
/
INSERT INTO user_sdo_styles (NAME, TYPE, DESCRIPTION, DEFINITION)
SELECT 'L.SDL_ORIG_SUBMISSION', 'LINE', 'SDL Original Submission', '<?xml version="1.0" standalone="yes"?>
<svg width="1in" height="1in">
<desc></desc>
<g class="line" style="fill:#FF6600;stroke-width:4">
<line class="base" style="fill:#000000;stroke-width:1" />
</g>
</svg>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM user_sdo_styles
                   WHERE NAME = 'L.SDL_ORIG_SUBMISSION');
/
INSERT INTO user_sdo_styles (NAME, TYPE, DESCRIPTION, DEFINITION)
SELECT 'L.SDL_DATUMS', 'LINE', 'SDL Datums', '<?xml version="1.0" standalone="yes"?>
<svg width="1in" height="1in">
<desc></desc>
<g class="line" style="fill:#BFFF00;stroke-width:3;marker-name:M.SDL_DATUM_ARROW;marker-position:0.75;marker-size:15;multiple-marker:true">
<line class="base" style="fill:#008000;stroke-width:1" />
</g>
</svg>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM user_sdo_styles
                   WHERE NAME = 'L.SDL_DATUMS');
/
INSERT INTO user_sdo_styles (NAME, TYPE, DESCRIPTION, DEFINITION)
SELECT 'L.SDL_TRANS_DATUMS', 'LINE', 'SDL Transferred Datums', '<?xml version="1.0" standalone="yes"?>
<svg width="1in" height="1in">
<desc></desc>
<g class="line" style="fill:#FFFF00;stroke-width:4">
<line class="base" style="fill:#7B3F00;stroke-width:1" />
</g>
</svg>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM user_sdo_styles
                   WHERE NAME = 'L.SDL_TRANS_DATUMS');
/
INSERT INTO user_sdo_styles (NAME, TYPE, DESCRIPTION, DEFINITION)
SELECT 'L.SDL_LINE', 'LINE', 'SDL Line Style', '<?xml version="1.0" standalone="yes"?>
<svg width="1in" height="1in">
<desc></desc>
<g class="line" style="fill:#FFBF00;stroke-width:3">
<line class="base" /></g>
</svg>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM user_sdo_styles
                   WHERE NAME = 'L.SDL_LINE');
/
INSERT INTO user_sdo_styles (NAME, TYPE, DESCRIPTION, DEFINITION)
SELECT 'L.SDL_LINE1', 'LINE', 'SDL Line Style1', '<?xml version="1.0" standalone="yes"?>
<svg width="1in" height="1in">
<desc></desc>
<g class="line" style="fill:#89CFF0;stroke-width:3">
<line class="base" style="fill:#000000;stroke-width:1" />
</g>
</svg>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM user_sdo_styles
                   WHERE NAME = 'L.SDL_LINE1');
/
INSERT INTO user_sdo_styles (NAME, TYPE, DESCRIPTION, DEFINITION)
SELECT 'L.SDL_LINE2', 'LINE', 'SDL Line Style2', '<?xml version="1.0" standalone="yes"?>
<svg width="1in" height="1in">
<desc></desc>
<g class="line" style="fill:#8A2BE2;stroke-width:3">
<line class="base" style="fill:#000000;stroke-width:1" />
</g>
</svg>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM user_sdo_styles
                   WHERE NAME = 'L.SDL_LINE2');
/
INSERT INTO user_sdo_styles (NAME, TYPE, DESCRIPTION, DEFINITION)
SELECT 'L.SDL_LINE3', 'LINE', 'SDL Line Style3', '<?xml version="1.0" standalone="yes"?>
<svg width="1in" height="1in">
<desc></desc>
<g class="line" style="fill:#964B00;stroke-width:3">
<line class="base" /></g>
</svg>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM user_sdo_styles
                   WHERE NAME = 'L.SDL_LINE3');
/
INSERT INTO user_sdo_styles (NAME, TYPE, DESCRIPTION, DEFINITION)
SELECT 'L.SDL_LINE4', 'LINE', 'SDL Line Style4', '<?xml version="1.0" standalone="yes"?>
<svg width="1in" height="1in">
<desc></desc>
<g class="line" style="fill:#FF7F50;stroke-width:3">
<line class="base" style="fill:#000000;stroke-width:1" />
</g>
</svg>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM user_sdo_styles
                   WHERE NAME = 'L.SDL_LINE4');
/
INSERT INTO user_sdo_styles (NAME, TYPE, DESCRIPTION, DEFINITION)
SELECT 'L.SDL_LINE5', 'LINE', 'SDL Line Style5', '<?xml version="1.0" standalone="yes"?>
<svg width="1in" height="1in">
<desc></desc>
<g class="line" style="fill:#4B0082;stroke-width:3">
<line class="base" /></g>
</svg>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM user_sdo_styles
                   WHERE NAME = 'L.SDL_LINE5');
/
INSERT INTO user_sdo_styles (NAME, TYPE, DESCRIPTION, DEFINITION)
SELECT 'L.SDL_LINE6', 'LINE', 'SDL Line Style6', '<?xml version="1.0" standalone="yes"?>
<svg width="1in" height="1in">
<desc></desc>
<g class="line" style="fill:#FFE5B4;stroke-width:3">
<line class="base" style="fill:#000000;stroke-width:1" />
</g>
</svg>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM user_sdo_styles
                   WHERE NAME = 'L.SDL_LINE6');
/
INSERT INTO user_sdo_styles (NAME, TYPE, DESCRIPTION, DEFINITION)
SELECT 'L.SDL_LINE7', 'LINE', 'SDL Line Style7', '<?xml version="1.0" standalone="yes"?>
<svg width="1in" height="1in">
<desc></desc>
<g class="line" style="fill:#E30B5C;stroke-width:3">
<line class="base" /></g>
</svg>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM user_sdo_styles
                   WHERE NAME = 'L.SDL_LINE7');
/
INSERT INTO user_sdo_styles (NAME, TYPE, DESCRIPTION, DEFINITION)
SELECT 'M.SDL_NODE', 'MARKER', 'SDL Node marker style', '<?xml version="1.0" standalone="yes"?>
<svg width="1in" height="1in">
  <desc></desc>
  <g class="marker" style="stroke:#FF0000;fill:#FF0000;width:7;height:7;font-family:Dialog;font-size:12;font-fill:#FF0000">
    <circle cx="0" cy="0" r="0" />
  </g>
</svg>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM user_sdo_styles
                   WHERE NAME = 'M.SDL_NODE');
/
INSERT INTO user_sdo_styles (NAME, TYPE, DESCRIPTION, DEFINITION)
SELECT 'M.SDL_NODE1', 'MARKER', 'SDL Node marker style1', '<?xml version="1.0" standalone="yes"?>
<svg width="1in" height="1in">
  <desc></desc>
  <g class="marker" style="stroke:#000000;stroke-width:2.0;fill:#FFD700;width:7;height:7;font-family:Dialog;font-size:12;font-fill:#FF0000">
    <circle cx="0" cy="0" r="0" />
  </g>
</svg>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM user_sdo_styles
                   WHERE NAME = 'M.SDL_NODE1');
/
INSERT INTO user_sdo_styles (NAME, TYPE, DESCRIPTION, DEFINITION)
SELECT 'M.SDL_NODE2', 'MARKER', 'SDL Node marker style2', '<?xml version="1.0" standalone="yes"?>
<svg width="1in" height="1in">
  <desc></desc>
  <g class="marker" style="stroke:#4B0082;stroke-width:2.0;fill:#4B0082;width:7;height:7;font-family:Dialog;font-size:12;font-fill:#FF0000">
    <circle cx="0" cy="0" r="0" />
  </g>
</svg>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM user_sdo_styles
                   WHERE NAME = 'M.SDL_NODE2');
/
INSERT INTO user_sdo_styles (NAME, TYPE, DESCRIPTION, DEFINITION)
SELECT 'M.SDL_NODE3', 'MARKER', 'SDL Node marker style3', '<?xml version="1.0" standalone="yes"?>
<svg width="1in" height="1in">
  <desc></desc>
  <g class="marker" style="stroke:#008000;fill:#008000;width:7;height:7;font-family:Dialog;font-size:12;font-fill:#FF0000">
    <circle cx="0" cy="0" r="0" />
  </g>
</svg>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM user_sdo_styles
                   WHERE NAME = 'M.SDL_NODE3');
/
INSERT INTO user_sdo_styles (NAME, TYPE, DESCRIPTION, DEFINITION)
SELECT 'T.SDL_TITLE', 'TEXT', 'SDL Submission ID Title', '<?xml version="1.0" standalone="yes"?>
  <svg width="1in" height="1in" >
  <desc></desc>
    <g class="text" 
        style="font-style:plain;font-family:SansSerif;font-size:1pt;font-weight:bold;text-align:center;fill:#FFFFFF"> Hello World!
        <opoint halign="center" valign="middle"/>
        <text-along-path halign="center" valign="baseline"/>
    </g>
  </svg>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM user_sdo_styles
                   WHERE NAME = 'T.SDL_TITLE');
/
PROMPT Inserting SDL user_sdo_themes...
-- SDL Layers
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'ORIGINAL SDL SUBMISSION', null, 'V_SDL_LOAD_DATA', 'SLD_WORKING_GEOMETRY', '<?xml version="1.0" standalone="yes"?>
<styling_rules>
  <rule>
    <features style="L.SDL_ORIG_SUBMISSION"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Layers ]]> </value>
    </tag>
    <tag>
      <name> DisplayedAtStartup </name>
      <value> <![CDATA[ Y ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'ORIGINAL SDL SUBMISSION');
/
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'SDL MATCH DETAIL', null, 'V_SDL_PLINE_STATS', 'GEOM', '<?xml version="1.0" standalone="yes"?>
<styling_rules key_column="ID">
  <rule>
    <features style="L.SDL_LINE"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Layers ]]> </value>
    </tag>
    <tag>
      <name> DisplayedAtStartup </name>
      <value> <![CDATA[ N ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'DATUM ACCURACY 0 TO 20')
/
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'SDL TRANSFERRED DATUMS', null, 'V_SDL_TRANSFERRED_DATUMS', 'GEOM', '<?xml version="1.0" standalone="yes"?>
<styling_rules>
  <rule>
    <features style="L.SDL_TRANS_DATUMS"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>    
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Layers ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'SDL TRANSFERRED DATUMS')
/
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'SDL BATCH NODE DATA', null, 'V_SDL_WIP_NODES', 'NODE_GEOM', '<?xml version="1.0" standalone="yes"?>
<styling_rules key_column="NODE_ID">
  <rule>
    <features style="M.SDL_NODE"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Layers ]]> </value>
    </tag>
    <tag>
      <name> DisplayedAtStartup </name>
      <value> <![CDATA[ N ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'SDL BATCH NODE DATA')
/
-- SDL Datums and Stats
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'SDL DATUMS AND STATS', null, 'V_SDL_DATUM_ACCURACY', 'GEOM', '<?xml version="1.0" standalone="yes"?>
<styling_rules key_column="SWD_ID">
  <rule>
    <features style="L.SDL_DATUMS"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Layers ]]> </value>
    </tag>
    <tag>
      <name> DisplayedAtStartup </name>
      <value> <![CDATA[ N ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'SDL DATUMS AND STATS')
/
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'DATUM ACCURACY 0 TO 20', null, 'V_SDL_DATUM_ACCURACY_0_TO_20', 'GEOM', '<?xml version="1.0" standalone="yes"?>
<styling_rules>
  <rule>
    <features style="L.SDL_LINE1"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Datums and Stats ]]> </value>
    </tag>
    <tag>
      <name> DisplayedAtStartup </name>
      <value> <![CDATA[   N   ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'DATUM ACCURACY 0 TO 20')
/
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'DATUM ACCURACY 20 TO 40', null, 'V_SDL_DATUM_ACCURACY_20_TO_40', 'GEOM', '<?xml version="1.0" standalone="yes"?>
<styling_rules>
  <rule>
    <features style="L.SDL_LINE2"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Datums and Stats ]]> </value>
    </tag>
    <tag>
      <name> DisplayedAtStartup </name>
      <value> <![CDATA[   N   ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'DATUM ACCURACY 20 TO 40')
/
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'DATUM ACCURACY 40 TO 60', null, 'V_SDL_DATUM_ACCURACY_40_TO_60', 'GEOM', '<?xml version="1.0" standalone="yes"?>
<styling_rules>
  <rule>
    <features style="L.SDL_LINE3"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Datums and Stats ]]> </value>
    </tag>
    <tag>
      <name> DisplayedAtStartup </name>
      <value> <![CDATA[   N   ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'DATUM ACCURACY 40 TO 60')
/
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'DATUM ACCURACY 60 TO 80', null, 'V_SDL_DATUM_ACCURACY_60_TO_80', 'GEOM', '<?xml version="1.0" standalone="yes"?>
<styling_rules>
  <rule>
    <features style="L.SDL_LINE4"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Datums and Stats ]]> </value>
    </tag>
    <tag>
      <name> DisplayedAtStartup </name>
      <value> <![CDATA[   N   ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'DATUM ACCURACY 60 TO 80')
/
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'DATUM ACCURACY 80 TO 100', null, 'V_SDL_DATUM_ACCURACY_80_TO_100', 'GEOM', '<?xml version="1.0" standalone="yes"?>
<styling_rules>
  <rule>
    <features style="L.SDL_LINE5"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Datums and Stats ]]> </value>
    </tag>
    <tag>
      <name> DisplayedAtStartup </name>
      <value> <![CDATA[   N   ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'DATUM ACCURACY 80 TO 100')
/
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'DATUM ACCURACY OVER 100', null, 'V_SDL_DATUM_ACCURACY_OVER_100', 'GEOM', '<?xml version="1.0" standalone="yes"?>
<styling_rules>
  <rule>
    <features style="L.SDL_LINE6"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Datums and Stats ]]> </value>
    </tag>
    <tag>
      <name> DisplayedAtStartup </name>
      <value> <![CDATA[   N   ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'DATUM ACCURACY OVER 100')
/
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'DATUM ACCURACY NO STATS', null, 'V_SDL_DATUM_ACCURACY_NO_STATS', 'GEOM', '<?xml version="1.0" standalone="yes"?>
<styling_rules>
  <rule>
    <features style="L.SDL_LINE7"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Datums and Stats ]]> </value>
    </tag>
    <tag>
      <name> DisplayedAtStartup </name>
      <value> <![CDATA[   N   ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'DATUM ACCURACY NO STATS')
/
-- SDL Match Details
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'MATCH DETAIL 0 TO 20', null, 'V_SDL_PLINE_STATS_0_TO_20', 'GEOM', '<?xml version="1.0" standalone="yes"?>
<styling_rules>
  <rule>
    <features style="L.SDL_LINE1"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Match Details ]]> </value>
    </tag>
    <tag>
      <name> DisplayedAtStartup </name>
      <value> <![CDATA[ N ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'MATCH DETAIL 0 TO 20')
/
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'MATCH DETAIL 20 TO 40', null, 'V_SDL_PLINE_STATS_20_TO_40', 'GEOM', '<?xml version="1.0" standalone="yes"?>
<styling_rules>
  <rule>
    <features style="L.SDL_LINE2"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Match Details ]]> </value>
    </tag>
    <tag>
      <name> DisplayedAtStartup </name>
      <value> <![CDATA[ N ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'MATCH DETAIL 20 TO 40')
/
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'MATCH DETAIL 40 TO 60', null, 'V_SDL_PLINE_STATS_40_TO_60', 'GEOM', '<?xml version="1.0" standalone="yes"?>
<styling_rules>
  <rule>
    <features style="L.SDL_LINE3"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Match Details ]]> </value>
    </tag>
    <tag>
      <name> DisplayedAtStartup </name>
      <value> <![CDATA[ N ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'MATCH DETAIL 40 TO 60')
/
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'MATCH DETAIL 60 TO 80', null, 'V_SDL_PLINE_STATS_60_TO_80', 'GEOM', '<?xml version="1.0" standalone="yes"?>
<styling_rules>
  <rule>
    <features style="L.SDL_LINE4"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Match Details ]]> </value>
    </tag>
    <tag>
      <name> DisplayedAtStartup </name>
      <value> <![CDATA[ N ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'MATCH DETAIL 60 TO 80')
/
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'MATCH DETAIL 80 TO 100', null, 'V_SDL_PLINE_STATS_80_TO_100', 'GEOM', '<?xml version="1.0" standalone="yes"?>
<styling_rules>
  <rule>
    <features style="L.SDL_LINE5"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Match Details ]]> </value>
    </tag>
    <tag>
      <name> DisplayedAtStartup </name>
      <value> <![CDATA[ N ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'MATCH DETAIL 80 TO 100')
/
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'MATCH DETAIL OVER 100', null, 'V_SDL_PLINE_STATS_OVER_100', 'GEOM', '<?xml version="1.0" standalone="yes"?>
<styling_rules>
  <rule>
    <features style="L.SDL_LINE6"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Match Details ]]> </value>
    </tag>
    <tag>
      <name> DisplayedAtStartup </name>
      <value> <![CDATA[ N ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'MATCH DETAIL OVER 100')
/
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'MATCH DETAIL NO STATS', null, 'V_SDL_PLINE_STATS_NO_STATS', 'GEOM', '<?xml version="1.0" standalone="yes"?>
<styling_rules>
  <rule>
    <features style="L.SDL_LINE7"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Match Details ]]> </value>
    </tag>
    <tag>
      <name> DisplayedAtStartup </name>
      <value> <![CDATA[ N ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'MATCH DETAIL NO STATS')
/
-- SDL Batch Nodes
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'BATCH NODE 0 TO 1', null, 'V_SDL_WIP_NODES_0_TO_1', 'NODE_GEOM', '<?xml version="1.0" standalone="yes"?>
<styling_rules key_column="NODE_ID">
  <rule>
    <features style="M.SDL_NODE1"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Batch Nodes ]]> </value>
    </tag>
    <tag>
      <name> DisplayedAtStartup </name>
      <value> <![CDATA[ N ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'BATCH NODE 0 TO 1')
/
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'BATCH NODE OVER 1', null, 'V_SDL_WIP_NODES_OVER_1', 'NODE_GEOM', '<?xml version="1.0" standalone="yes"?>
<styling_rules key_column="NODE_ID">
  <rule>
    <features style="M.SDL_NODE2"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Batch Nodes ]]> </value>
    </tag>
    <tag>
      <name> DisplayedAtStartup </name>
      <value> <![CDATA[   N   ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'BATCH NODE OVER 1')
/
INSERT INTO USER_SDO_THEMES (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
SELECT 'BATCH NODE UNDER 0', null, 'V_SDL_WIP_NODES_UNDER_0', 'NODE_GEOM', '<?xml version="1.0" standalone="yes"?>
<styling_rules key_column="NODE_ID">
  <rule>
    <features style="M.SDL_NODE3"> </features>
    <label column="BATCH_ID" style="T.SDL_TITLE"> 1 </label>
  </rule>
  <custom_tags>
    <tag>
      <name> LegendGroup </name>
      <value> <![CDATA[ SDL Batch Nodes ]]> </value>
    </tag>
    <tag>
      <name> DisplayedAtStartup </name>
      <value> <![CDATA[   N   ]]> </value>
    </tag>
  </custom_tags>
</styling_rules>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_THEMES
                   WHERE NAME = 'BATCH NODE UNDER 0')
/
PROMPT Inserting SDL Base Map entry...
INSERT INTO USER_SDO_MAPS (NAME, DESCRIPTION, DEFINITION)
SELECT (SELECT hov_value FROM hig_option_values WHERE hov_id = 'SDLMAPNAME'), 'SDL Base Map', '<?xml version="1.0" standalone="yes"?>
<map_definition>
    <theme name="ORIGINAL SDL SUBMISSION" min_scale="600000.0" max_scale="-Infinity" scale_mode="RATIO"/>
    <theme name="SDL DATUMS AND STATS" min_scale="100000.0" max_scale="-Infinity" scale_mode="RATIO"/>
    <theme name="SDL TRANSFERRED DATUMS" min_scale="600000.0" max_scale="-Infinity" scale_mode="RATIO"/>
    <theme name="DATUM ACCURACY NO STATS" min_scale="100000.0" max_scale="-Infinity" scale_mode="RATIO"/>
    <theme name="DATUM ACCURACY 0 TO 20" min_scale="100000.0" max_scale="-Infinity" scale_mode="RATIO"/>
    <theme name="DATUM ACCURACY 20 TO 40" min_scale="100000.0" max_scale="-Infinity" scale_mode="RATIO"/>
    <theme name="DATUM ACCURACY 40 TO 60" min_scale="100000.0" max_scale="-Infinity" scale_mode="RATIO"/>
    <theme name="DATUM ACCURACY 60 TO 80" min_scale="100000.0" max_scale="-Infinity" scale_mode="RATIO"/>
    <theme name="DATUM ACCURACY 80 TO 100" min_scale="100000.0" max_scale="-Infinity" scale_mode="RATIO"/>
    <theme name="DATUM ACCURACY OVER 100" min_scale="100000.0" max_scale="-Infinity" scale_mode="RATIO"/>
    <theme name="BATCH NODE UNDER 0" min_scale="600000.0" max_scale="-Infinity" scale_mode="RATIO"/>
    <theme name="BATCH NODE 0 TO 1" min_scale="600000.0" max_scale="-Infinity" scale_mode="RATIO"/>
    <theme name="BATCH NODE OVER 1" min_scale="600000.0" max_scale="-Infinity" scale_mode="RATIO"/>
    <theme name="MATCH DETAIL NO STATS" min_scale="100000.0" max_scale="-Infinity" scale_mode="RATIO"/>
    <theme name="MATCH DETAIL 0 TO 20" min_scale="100000.0" max_scale="-Infinity" scale_mode="RATIO"/>
    <theme name="MATCH DETAIL 20 TO 40" min_scale="100000.0" max_scale="-Infinity" scale_mode="RATIO"/>
    <theme name="MATCH DETAIL 40 TO 60" min_scale="100000.0" max_scale="-Infinity" scale_mode="RATIO"/>
    <theme name="MATCH DETAIL 60 TO 80" min_scale="100000.0" max_scale="-Infinity" scale_mode="RATIO"/>
    <theme name="MATCH DETAIL 80 TO 100" min_scale="100000.0" max_scale="-Infinity" scale_mode="RATIO"/>
    <theme name="MATCH DETAIL OVER 100" min_scale="100000.0" max_scale="-Infinity" scale_mode="RATIO"/>
  </map_definition>'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                    FROM USER_SDO_MAPS
                   WHERE NAME = (SELECT hov_value FROM hig_option_values WHERE hov_id = 'SDLMAPNAME'))
/
COMMIT
/
SET TERM OFF
