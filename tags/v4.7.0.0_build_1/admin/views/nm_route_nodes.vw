CREATE OR REPLACE FORCE VIEW nm_route_nodes AS
SELECT
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
--   Author : Graeme Johnson
--   An view flattens out the structure of view nm_route_nodes_o
--   The view returns all nodes on all routes
--   Under no circumstances should the view be used without a driving route ne_id 
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
          nrno.node_class.nc_route_id          route_id,
          nrno.ne_unique                       route_ne_unique,		   
          nrno.node_class.nc_node_id           node_id,
          nrno.node_name                       node_name,
          nrno.node_descr                      node_descr,
          nrno.node_class.nc_node_type         node_type,		   
          nrno.node_class.nc_intersecting_road intersecting_road, 
          nrno.node_class.nc_poe               poe 
FROM      nm_route_nodes_o nrno  
/
