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
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hist_undo_views.vw-arc   2.2   Jul 04 2013 11:20:06   James.Wadsworth  $
--       Module Name      : $Workfile:   hist_undo_views.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:06  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:00:34  $
--       Version          : $Revision:   2.2  $
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
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
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hist_undo_views.vw-arc   2.2   Jul 04 2013 11:20:06   James.Wadsworth  $
--       Module Name      : $Workfile:   hist_undo_views.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:06  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:00:34  $
--       Version          : $Revision:   2.2  $
-------------------------------------------------------------------------
--
SELECT DISTINCT new_ne_id
              , new_ne_unique
              , new_ne_descr
              , neh_descr
           FROM v_nm_element_history
          WHERE neh_operation = 'M'
/
 
