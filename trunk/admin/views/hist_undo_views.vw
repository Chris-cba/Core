--
-- nm_element_history views for unsplit and unmerge
--
CREATE OR REPLACE FORCE VIEW  v_nm_element_hist_unsplit ( old_ne_id
                                                        , old_ne_unique
                                                        , old_ne_descr
                                                        , neh_descr 
                                                        )
AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/hist_undo_views.vw-arc   2.3   Apr 13 2018 11:47:16   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   hist_undo_views.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:16  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:32:38  $
--       Version          : $Revision:   2.3  $
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
SELECT DISTINCT old_ne_id
              , old_ne_unique
              , old_ne_descr
              , neh_descr
           FROM v_nm_element_history
          WHERE neh_operation = 'S'
/

CREATE OR REPLACE FORCE VIEW  v_nm_element_hist_unmerge( new_ne_id
                                                       , new_ne_unique
                                                       , new_ne_descr 
                                                       , neh_descr
                                                       )
AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/hist_undo_views.vw-arc   2.3   Apr 13 2018 11:47:16   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   hist_undo_views.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:16  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:32:38  $
--       Version          : $Revision:   2.3  $
-------------------------------------------------------------------------
--
SELECT DISTINCT new_ne_id
              , new_ne_unique
              , new_ne_descr
              , neh_descr
           FROM v_nm_element_history
          WHERE neh_operation = 'M'
/
 
