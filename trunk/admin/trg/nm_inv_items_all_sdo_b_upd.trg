CREATE OR REPLACE TRIGGER NM_INV_ITEMS_ALL_SDO_B_UPD
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_inv_items_all_sdo_b_upd.trg-arc   2.4   Mar 08 2019 09:28:38   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_inv_items_all_sdo_b_upd.trg  $
--       Date into SCCS   : $Date:   Mar 08 2019 09:28:38  $
--       Date fetched Out : $Modtime:   Feb 20 2019 15:50:38  $
--       SCCS Version     : $Revision:   2.4  $
--       Based on
--
--   Author  : Ade Edwards
--   Purpose : This trigger is used to grab updates to Asset coordinates
--             which are then posted to nm3sdo_edit global array for
--             regeneration of shapes
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
--
BEFORE INSERT OR UPDATE OF iit_x, iit_y, iit_z
    ON NM_INV_ITEMS_ALL
   FOR EACH ROW
DECLARE
--
  CURSOR c1 IS
  SELECT 1
  FROM nm_inv_type_groupings
 WHERE itg_inv_type = :NEW.iit_inv_type
   AND itg_relation = 'AT';

  lv_dummy   PLS_INTEGER;
  lv_row_found BOOLEAN;
  --
   l_rec_iit            nm_inv_items_all%ROWTYPE;
   coords_have_changed  BOOLEAN :=  (:NEW.iit_x != :OLD.iit_x
                                  OR :NEW.iit_y != :OLD.iit_y
                                  OR :NEW.iit_z != :OLD.iit_z)
                                  OR
                                    (:NEW.iit_x IS NOT NULL AND
                                     :OLD.iit_x IS NULL )
                                  OR
                                    (:NEW.iit_x IS NULL AND
                                     :OLD.iit_x IS NOT NULL )
                                  OR
                                    (:NEW.iit_y IS NOT NULL AND
                                     :OLD.iit_y IS NULL )
                                  OR
                                    (:NEW.iit_y IS NULL AND
                                     :OLD.iit_y IS NOT NULL )
                                  OR
                                    (:NEW.iit_z IS NOT NULL AND
                                     :OLD.iit_z IS NULL )
                                  OR
                                    (:NEW.iit_z IS NULL AND
                                     :OLD.iit_z IS NOT NULL );
--
BEGIN
--
  --MJA add 31-Aug-07
  --New functionality to allow override
  If Not nm3inv.bypass_inv_items_all_trgs
  Then
     OPEN c1;
     FETCH c1 INTO lv_dummy;
     lv_row_found := c1%FOUND;
     CLOSE c1;
     
    IF coords_have_changed AND
       NOT lv_row_found
    THEN
      l_rec_iit.iit_ne_id                 := :NEW.iit_ne_id;
      l_rec_iit.iit_inv_type              := :NEW.iit_inv_type;
      l_rec_iit.iit_primary_key           := :NEW.iit_primary_key;
      l_rec_iit.iit_start_date            := :NEW.iit_start_date;
      l_rec_iit.iit_admin_unit            := :NEW.iit_admin_unit;
      l_rec_iit.iit_descr                 := :NEW.iit_descr;
      l_rec_iit.iit_end_date              := :NEW.iit_end_date;
      l_rec_iit.iit_foreign_key           := :NEW.iit_foreign_key;
      l_rec_iit.iit_located_by            := :NEW.iit_located_by;
      l_rec_iit.iit_position              := :NEW.iit_position;
      l_rec_iit.iit_x                     := :NEW.iit_x;
      l_rec_iit.iit_y                     := :NEW.iit_y;
      l_rec_iit.iit_z                     := :NEW.iit_z;
   --
      nm3sdo_edit.g_tab_inv(nm3sdo_edit.g_tab_inv.COUNT) := l_rec_iit;
   --
    End If;
  END IF;
EXCEPTION
  WHEN OTHERS
  THEN
    RAISE;
-----------------------------------------------------------------------------
--
END nm_inv_items_all_sdo_b_upd;
/
