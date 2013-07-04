-- Script to correct the discrepancy between Parent and Child location when relationship is AT
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/utl/upd_incorrect_child_loc_with_at_rel.sql-arc   3.1   Jul 04 2013 10:30:14   James.Wadsworth  $
--       Module Name      : $Workfile:   upd_incorrect_child_loc_with_at_rel.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 10:30:14  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:28:54  $
--       PVCS Version     : $Revision:   3.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

Set linesize 1000
set Serveroutput on

DECLARE
--
  l_ne_id Number ;  
  l_iit_rec nm_inv_items%ROWTYPE ;
  l_cnt Number := 0 ;   
  l_itg_rec nm_inv_type_groupings%ROWTYPE;
--
BEGIN
--
   dbms_output.enable(1000000);
   FOR par IN (SELECT *
               FROM   nm_inv_items
               WHERE  iit_inv_type IN (SELECT itg_parent_inv_type
                                       FROM   nm_inv_type_groupings)
--               AND iit_ne_id =                834382 
              )
   LOOP
   --
       FOR chi IN (SELECT DISTINCT iig_item_id iit_ne_id,nm_obj_type ,nm_admin_unit,nm_start_date
                   FROM   nm_inv_item_groupings iig,
                          nm_members nm
                   WHERE  iig.iig_item_id  = nm.nm_ne_id_in
                   AND    iig.iig_parent_id  = par.iit_ne_id)
                          
       LOOP
       --
           BEGIN
              --
              l_itg_rec := nm3get.get_itg(chi.nm_obj_type,par.iit_inv_type);
              SELECT ne_id INTO l_ne_id
              FROM
                  (SELECT x.pl_ne_id ne_id
                   FROM  table( NM3PLA.SUBTRACT_PL_FROM_PL(NM3PLA.GET_PLACEMENT_FROM_NE( chi.iit_ne_id ), NM3PLA.GET_PLACEMENT_FROM_NE( par.iit_ne_id )).npa_placement_array) x
                   )
              WHERE ne_id IS NOT NULL;
              l_iit_rec := nm3get.get_iit(chi.iit_ne_id);
              IF  l_itg_rec.itg_relation = 'AT'
              THEN
                  Delete FROM nm_members_all
                  WHERE  nm_ne_id_in = chi.iit_ne_id
                  AND    nm_obj_type = chi.nm_obj_type;

                  nm3invval.pc_duplicate_members
                  (pi_parent_ne_id     => par.iit_ne_id
                  ,pi_child_ne_id      => chi.iit_ne_id
                  ,pi_child_inv_type   => chi.nm_obj_type
                  ,pi_child_admin_unit => chi.nm_admin_unit
                  ,pi_child_start_date => chi.nm_start_date
                  );                            
                  l_cnt := l_cnt +1 ;
                  
              END IF ;
           --
           EXCEPTION
              WHEN OTHERS THEN
              NULL;           
           END ;
       --       
       END LOOP;                                         
   --
   END LOOP;
   dbms_output.put_line('Total '||l_cnt||' children assets with incorrect location have been corrected ');
   Commit;
--
END ;   
/
