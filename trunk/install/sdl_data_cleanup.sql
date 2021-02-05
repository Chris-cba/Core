-----------------------------------------------------------------------------
-- sdl_data_cleanup.sql
----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/sdl_data_cleanup.sql-arc   1.1   Feb 05 2021 10:24:52   Vikas.Mhetre  $
--       Module Name      : $Workfile:   sdl_data_cleanup.sql  $
--       Date into PVCS   : $Date:   Feb 05 2021 10:24:52  $
--       Date fetched Out : $Modtime:   Feb 05 2021 10:22:04  $
--       Version          : $Revision:   1.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2021 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
-- IMPORTANT - This script only needs to be executed to clean up the data from SDL tables before installing TDL ( 4800 Fix 7) ONLY if the SDL system has already been configured, used (if exists SDL profiles data) and TDL has not already been installed 
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF

SET TERM ON
PROMPT Cleaning up existing data from the SDL tables
DELETE FROM sdl_wip_intsct_geom;
--
DELETE FROM sdl_wip_pt_geom;
--
DELETE FROM sdl_wip_pt_arrays;
--
DELETE FROM sdl_wip_datum_nodes;
--
DELETE FROM sdl_wip_nodes;
--
DELETE FROM sdl_wip_route_nodes;
--
DELETE FROM sdl_wip_self_intersections;
--
DELETE FROM sdl_pline_statistics;
--
DELETE FROM sdl_geom_accuracy;
--
DELETE FROM sdl_validation_results;
--
DELETE FROM sdl_wip_datums;
--
DELETE FROM sdl_wip_datum_reversals;
--
DELETE FROM sdl_process_audit;
--
DELETE FROM sdl_attribute_adjustment_audit;
--
DELETE FROM sdl_load_data;
--
DELETE FROM sdl_file_submissions; 
--
DELETE FROM sdl_spatial_review_levels;
--
DELETE FROM sdl_attribute_adjustment_rules;
--
DELETE FROM sdl_datum_attribute_mapping;
--
DELETE FROM sdl_attribute_mapping;  
--
DELETE FROM sdl_user_profiles;
--
DELETE FROM sdl_profiles;  
--
------------------------------------------------------------------
SET TERM OFF
------------------------------------------------------------------
COMMIT;
------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------  