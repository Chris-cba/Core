CREATE OR REPLACE TRIGGER nm_points_sdo_row
 BEFORE INSERT OR UPDATE OR DELETE
 ON nm_points
 FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_points_sdo_row.trg-arc   2.1   Aug 31 2007 17:01:30   malexander  $
--       Module Name      : $Workfile:   nm_points_sdo_row.trg  $
--       Date into SCCS   : $Date:   Aug 31 2007 17:01:30  $
--       Date fetched Out : $Modtime:   Aug 31 2007 16:08:18  $
--       SCCS Version     : $Revision:   2.1  $
--       Based on 
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------

BEGIN
--
-- Generated 12:15:23 26-NOV-2002
--
  --MJA add 31-Aug-07
  --New functionality to allow override
  If Not nm3net.bypass_nm_points_trgs
  Then 
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
  End If;
--
END nm_points_sdo;
/
