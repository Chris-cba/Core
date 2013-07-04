CREATE OR REPLACE FORCE VIEW nm_route_nodes_o AS
SELECT
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_route_nodes_o.vw	1.1 10/26/04
--       Module Name      : nm_route_nodes_o.vw
--       Date into SCCS   : 04/10/26 14:21:07
--       Date fetched Out : 07/06/13 17:08:21
--       SCCS Version     : 1.1
--
--
--   Author : Graeme Johnson
--   An view that returns conventional table column values plus object attributes
--   The view returns all nodes on all routes
--   Under no circumstances should the view be used without a driving route ne_id 
--
--   See also: nm_route_nodes which is a view on top of this view that will 'flatten out' the structure
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       ne_unique                                        ne_unique
      ,nm3net_o.get_node_class( ne_id, nnu_no_node_id ) node_class  -- object type that presents node details
      ,no_node_name                                     node_name
      ,no_descr                                         node_descr
FROM (SELECT DISTINCT ne.ne_id
                     ,ne_unique
                     ,nu.nnu_no_node_id
                     ,nd.no_node_name
                     ,nd.no_descr					 
      FROM   nm_elements     ne
            ,nm_node_usages  nu
            ,nm_members      nm
            ,nm_nodes         nd
      WHERE  ne.ne_id    = nm3net_o.get_g_ne_id_to_restrict_on
      AND    nm_ne_id_in = ne_id 
      AND    nm_ne_id_of = nnu_ne_id
      AND    nd.no_node_id = nu.nnu_no_node_id)  -- all nodes for each group of section
/

