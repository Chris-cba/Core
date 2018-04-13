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
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_element_history.vw-arc   2.2   Apr 13 2018 11:47:24   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   v_nm_element_history.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:24  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:38:10  $
--       Version          : $Revision:   2.2  $
-------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
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
