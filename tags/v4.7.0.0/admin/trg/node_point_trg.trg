CREATE OR REPLACE TRIGGER node_point_trg instead OF
INSERT OR UPDATE ON v_node_points
FOR EACH ROW
DECLARE
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
--   node_point_trg Trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_np_id nm_points.np_id%TYPE;
BEGIN
   -- insert the points
   l_np_id := nm3net.create_point( pi_np_grid_east  => :NEW.np_grid_east
                                  ,pi_np_grid_north => :NEW.np_grid_north
                                  ,pi_np_descr      => :NEW.np_descr
                                  );
   -- insert the nodes
   nm3net.create_node( pi_no_node_id => nm3net.get_next_node_id
                      ,pi_np_id => l_np_id
                      ,pi_start_date => :NEW.no_start_date
                      ,pi_no_descr => :NEW.no_descr
                      ,pi_no_node_type => :NEW.no_node_type
                      ,pi_no_node_name => :NEW.no_node_name
                     );
END;
/

