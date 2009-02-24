-- End Date NM_INV_ITEM_GROUPINGS For Which Asset Do Not Exists
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/sql/update_iig_defect_717947.sql-arc   3.2   Feb 24 2009 14:43:18   lsorathia  $
--       Module Name      : $Workfile:   update_iig_defect_717947.sql  $
--       Date into PVCS   : $Date:   Feb 24 2009 14:43:18  $
--       Date fetched Out : $Modtime:   Feb 24 2009 14:39:36  $
--       PVCS Version     : $Revision:   3.2  $
--
--------------------------------------------------------------------------------
--

PROMPT End Date NM_INV_ITEM_GROUPINGS For Which Asset Do Not Exists

DECLARE
--
   TYPE iit_ne_table IS TABLe OF nm_inv_items.iit_ne_id%TYPE ;
   iit_tab iit_ne_table ;
--   
BEGIN
--
   --
   SELECT iit_id 
          BULK COLLECT  INTO iit_tab
   FROM (
   SELECT iig_item_id iit_id FROM nm_inv_item_groupings
   minus
   SELECT iit_ne_id iit_ne_id FROM nm_inv_items   
         )  ;
   --
   FORALL i IN 1..iit_tab.count
   UPDATE nm_inv_item_groupings iig
   SET    iig.iig_end_date =Nvl((SELECT Nvl(iit_end_date,Trunc(sysdate)) FROM nm_inv_items_all 
                                WHERE  iit_ne_id = iit_tab(i)),Trunc(sysdate))
   WHERE  iig.iig_item_id  = iit_tab(i) ;
   --
   Dbms_Output.Put_line('Count '||SQL%ROWCOUNT);   
   --
   COMMIT;
   --
--
END ;
/









