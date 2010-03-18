CREATE OR REPLACE FORCE VIEW v_nm_element_history
( old_ne_id
, new_ne_id
, old_ne_unique
, old_ne_descr
, new_ne_unique
, new_ne_descr
, neh_operation
, neh_effective_date
, neh_actioned_date
, neh_actioned_by
, neh_descr 
)
AS 
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_element_history.vw-arc   2.1   Mar 18 2010 11:02:48   cstrettle  $
--       Module Name      : $Workfile:   v_nm_element_history.vw  $
--       Date into PVCS   : $Date:   Mar 18 2010 11:02:48  $
--       Date fetched Out : $Modtime:   Mar 18 2010 10:58:28  $
--       Version          : $Revision:   2.1  $
-------------------------------------------------------------------------
--
SELECT neh_ne_id_old
     , neh_ne_id_new
     , o.ne_unique
     , o.ne_descr
     , n.ne_unique
     , n.ne_descr
     , h.neh_operation
     , h.neh_effective_date
     , h.neh_actioned_date
     , h.neh_actioned_by
     , h.neh_descr
  FROM nm_elements_all o
     , nm_elements_all n
     , nm_element_history h
 WHERE n.ne_id = h.neh_ne_id_new
   AND o.ne_id = h.neh_ne_id_old
/
