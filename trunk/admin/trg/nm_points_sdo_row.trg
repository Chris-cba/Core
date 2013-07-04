CREATE OR REPLACE TRIGGER nm_points_sdo_row
 BEFORE INSERT OR UPDATE OR DELETE
 ON nm_points
 FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_points_sdo_row.trg-arc   2.6   Jul 04 2013 09:54:30   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_points_sdo_row.trg  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:54:30  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:39:58  $
--       SCCS Version     : $Revision:   2.6  $
--       Based on 
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
  CURSOR npl_check(p_np_id NUMBER) IS
         SELECT 'x' 
         FROM  nm_point_locations 
         WHERE npl_id = p_np_id
         AND   npl_location IS NOT NULL;

  l_geom_exists VARCHAR2(1);

BEGIN
--
-- Generated 12:15:23 26-NOV-2002
--
  --MJA add 31-Aug-07
  --New functionality to allow override
  IF NOT nm3net.bypass_nm_points_trgs
  THEN 
     IF nm3sdo.g_sdo_layer_available
     THEN
       IF :NEW.np_grid_east IS NOT NULL AND
          :NEW.np_grid_north IS NOT NULL THEN
      
         IF INSERTING THEN
           INSERT INTO nm_point_locations (npl_id, npl_location )
           VALUES ( :NEW.np_id,
                    mdsys.sdo_geometry( 2001, nm3sdo.get_point_srid,
                    mdsys.sdo_point_type(:NEW.np_grid_east, :NEW.np_grid_north, NULL),NULL, NULL));
         ELSIF UPDATING THEN 

           OPEN npl_check(:NEW.np_id);
           FETCH npl_check INTO l_geom_exists;
           CLOSE npl_check;

           IF  :NEW.np_grid_east != NVL(:OLD.np_grid_east, -1)  
           OR  :NEW.np_grid_north != NVL(:OLD.np_grid_north, -1) 
           OR  l_geom_exists IS NULL
           THEN
             UPDATE nm_point_locations
             SET npl_location =
                      mdsys.sdo_geometry( 2001, nm3sdo.get_point_srid,
                      mdsys.sdo_point_type(:NEW.np_grid_east, :NEW.np_grid_north, NULL),NULL, NULL)
             WHERE npl_id = :NEW.np_id;
             --
             IF SQL%NOTFOUND THEN
               INSERT INTO nm_point_locations (npl_id, npl_location )
               VALUES ( :NEW.np_id,
                        mdsys.sdo_geometry( 2001, nm3sdo.get_point_srid,
                        mdsys.sdo_point_type(:NEW.np_grid_east, :NEW.np_grid_north, NULL),NULL, NULL));
             END IF;
           END IF;
           --
         ELSIF DELETING THEN
         --
           DELETE FROM nm_point_locations
           WHERE npl_id = :OLD.np_id;
         --
         END IF;
       ELSIF UPDATING THEN
       --
         DELETE nm_point_locations 
         WHERE npl_id = :NEW.np_id;
       --
       END IF;
     END IF;
  END IF;
--
END nm_points_sdo_row;
/
