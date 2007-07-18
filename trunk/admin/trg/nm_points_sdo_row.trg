CREATE OR REPLACE TRIGGER nm_points_sdo_row
 BEFORE INSERT OR UPDATE OR DELETE
 ON nm_points
 FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_points_sdo_row.trg	1.2 05/21/04
--       Module Name      : nm_points_sdo_row.trg
--       Date into SCCS   : 04/05/21 15:26:09
--       Date fetched Out : 07/06/13 17:03:34
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------

BEGIN
--
-- Generated 12:15:23 26-NOV-2002
--
 IF nm3sdo.g_sdo_layer_available
 THEN
   IF :NEW.np_grid_east IS NOT NULL AND
      :NEW.np_grid_north IS NOT NULL THEN
  
     IF INSERTING THEN
       INSERT INTO nm_point_locations (npl_id, npl_location )
       VALUES ( :NEW.np_id,
                mdsys.sdo_geometry( 2001, nm3sdo.get_point_srid,
                mdsys.sdo_point_type(:NEW.np_grid_east, :NEW.np_grid_north, NULL),NULL, NULL));
     ELSIF UPDATING AND ((:NEW.np_grid_east != :OLD.np_grid_east ) OR
                         (:NEW.np_grid_north != :OLD.np_grid_north ))   THEN
       UPDATE nm_point_locations
       SET npl_location =
                mdsys.sdo_geometry( 2001, nm3sdo.get_point_srid,
                mdsys.sdo_point_type(:NEW.np_grid_east, :NEW.np_grid_north, NULL),NULL, NULL)
       WHERE npl_id = :NEW.np_id;
     ELSIF DELETING THEN
       DELETE FROM nm_point_locations
       WHERE npl_id = :OLD.np_id;
     END IF;
   END IF;
 END IF;
--
END nm_points_sdo;
/
