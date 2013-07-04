CREATE OR REPLACE FORCE VIEW v_node_points(
no_node_name, no_descr, no_node_type, no_start_date, no_end_date, np_descr, np_grid_east, np_grid_north
)
AS SELECT
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : %W% %G%
--       Module Name      : %M%
--       Date into SCCS   : %E% %U%
--       Date fetched Out : %D% %T%
--       SCCS Version     : %I%
--
--
--   Author : I Turnbull
--
--   v_node_points View
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
no_node_name, no_descr, no_node_type, no_start_date, no_end_date, np_descr, np_grid_east, np_grid_north
FROM nm_nodes
    ,nm_points
WHERE     no_np_id = np_id;
