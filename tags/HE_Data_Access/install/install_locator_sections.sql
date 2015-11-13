--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/install_locator_sections.sql-arc   1.0   Nov 13 2015 16:47:08   Rob.Coupe  $
--       Module Name      : $Workfile:   install_locator_sections.sql  $
--       Date into SCCS   : $Date:   Nov 13 2015 16:47:08  $
--       Date fetched Out : $Modtime:   Nov 13 2015 16:44:26  $
--       SCCS Version     : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

-- script to create new, unrestricted views for use in Locator on HE systems
--

start locator_segs.sql;

start locator_segments.sql;

start locator_sections.sql;

update nm_inv_types
set nit_table_name = 'LOCATOR_SECTIONS'
where nit_table_name = 'ROAD_SECTIONS'
/

