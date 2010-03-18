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
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hist_undo_views.vw-arc   2.1   Mar 18 2010 10:51:10   cstrettle  $
--       Module Name      : $Workfile:   hist_undo_views.vw  $
--       Date into PVCS   : $Date:   Mar 18 2010 10:51:10  $
--       Date fetched Out : $Modtime:   Mar 17 2010 15:42:22  $
--       Version          : $Revision:   2.1  $
-------------------------------------------------------------------------
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
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hist_undo_views.vw-arc   2.1   Mar 18 2010 10:51:10   cstrettle  $
--       Module Name      : $Workfile:   hist_undo_views.vw  $
--       Date into PVCS   : $Date:   Mar 18 2010 10:51:10  $
--       Date fetched Out : $Modtime:   Mar 17 2010 15:42:22  $
--       Version          : $Revision:   2.1  $
-------------------------------------------------------------------------
--
SELECT DISTINCT new_ne_id
              , new_ne_unique
              , new_ne_descr
              , neh_descr
           FROM v_nm_element_history
          WHERE neh_operation = 'M'
/
 