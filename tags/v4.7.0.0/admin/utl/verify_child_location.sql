-- Script to identify the discrepancy between Parent and Child location when relationship is AT
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/utl/verify_child_location.sql-arc   3.1   Jul 04 2013 10:30:14   James.Wadsworth  $
--       Module Name      : $Workfile:   verify_child_location.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 10:30:14  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:29:08  $
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
   dbms_output.put_line('Parent Id  Parent Type Parent Primary Key Relation  Child id  Child Type Child Primary Key ')      ;
   dbms_output.put_line('---------  ----------- ------------------ --------  --------  ---------- ----------------- ')      ;
   FOR par IN (SELECT *
               FROM   nm_inv_items
               WHERE  iit_inv_type IN (SELECT itg_parent_inv_type
                                       FROM   nm_inv_type_groupings)
--               AND iit_ne_id =                834382 
              )
   LOOP
   --
       FOR chi IN (SELECT DISTINCT iig_item_id iit_ne_id,nm_obj_type 
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
              
              dbms_output.put_line(rpad(par.iit_ne_id,10,' ')||' '||Rpad(par.iit_inv_type,11,' ')||' '||rpad(par.iit_primary_key,18,' ')||' '||rpad(l_itg_rec.itg_relation,9,' ')||' '||Rpad(chi.iit_ne_id,8,' ')||'  '||Rpad(chi.nm_obj_type,11)||l_iit_rec.iit_primary_key )      ;
              l_cnt := l_cnt +1 ;
              --
           EXCEPTION
              WHEN OTHERS THEN
              NULL;           
           END ;
       --       
       END LOOP;                                         
   --
   END LOOP;
   dbms_output.put_line('Total '||l_cnt||' children assets have incorrect location details ');
--
END ;   
/
