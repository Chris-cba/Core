--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/trg/nm_inv_items_all_del_mem_chk.trg-arc   2.2   Jul 04 2013 09:53:24   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_inv_items_all_del_mem_chk.trg  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:53:24  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:49:30  $
--       Version          : $Revision:   2.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
CREATE OR REPLACE TRIGGER nm_inv_items_all_del_mem_chk
 BEFORE DELETE
 ON nm_inv_items_all
 FOR EACH ROW
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_items_all_del_mem_chk.trg	1.1 10/01/01
--       Module Name      : nm_inv_items_all_del_mem_chk.trg
--       Date into SCCS   : 01/10/01 11:11:25
--       Date fetched Out : 07/06/13 17:02:54
--       SCCS Version     : 1.1
--
--   TRIGGER nm_inv_items_all_del_mem_chk
--    BEFORE DELETE
--    ON nm_inv_items_all
--    FOR EACH ROW
--
   --Log 717947:Linesh:20-Feb-2009:Start
   --Added this code to stop the deletion of 
   --NM_INV_ITEMS_ALL when NM_INV_ITEM_GROUPING_ALL Exists
   CURSOR c_chk_group_exists(qp_iig_item_id nm_inv_item_groupings_all.iig_item_id%TYPE)
   IS
   SELECT Count(0) cnt
   FROM   nm_inv_item_groupings_all
   WHERE  iig_item_id = qp_iig_item_id ;
   l_cnt  Number  ;
   --Log 717947:Linesh:20-Feb-2009:End
BEGIN
   --
   IF nm3ausec.do_locations_exist( :OLD.iit_ne_id )
    THEN
      RAISE_APPLICATION_ERROR(-20001,'Cannot delete NM_INV_ITEMS_ALL records for which NM_MEMBERS_ALL records exist');
   END IF;
   --Log 717947:Linesh:20-Feb-2009:Start
   --
   OPEN  c_chk_group_exists(:OLD.iit_ne_id);
   FETCH c_chk_group_exists INTO l_cnt ;
   CLOSE c_chk_group_exists;
   IF Nvl(l_cnt,0) > 0
   THEN
       RAISE_APPLICATION_ERROR(-20001,'Cannot delete NM_INV_ITEMS_ALL records for which NM_INV_ITEM_GROUPINGS_ALL records exist');
   END IF ;
   --
   --Log 717947:Linesh:20-Feb-2009:End
END nm_inv_items_all_del_mem_chk;
/
