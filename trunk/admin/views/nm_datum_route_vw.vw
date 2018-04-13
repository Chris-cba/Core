CREATE OR REPLACE FORCE VIEW nm_datum_route_vw
(
       NE_UNIQUE, 
       NE_DESCR, 
       START_LOC, 
       END_LOC, 
       NM_NE_ID_OF
)
AS 
SELECT  
--
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/nm_datum_route_vw.vw-arc   3.2   Apr 13 2018 11:47:16   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm_datum_route_vw.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:16  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:32:38  $
--       Version          : $Revision:   3.2  $
--       Based on SCCS version : 
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
-- 
       ne_unique, 
       ne_descr,
       nm3net.get_min_slk(ne_id) start_loc ,
       nm3net.get_max_slk(ne_id) end_loc,
       nm_ne_id_of
FROM    nm_members nm
       ,nm_elements ne
       ,nm_group_types
WHERE   nm.nm_ne_id_in = ne.ne_id
AND     nm.nm_type     = 'G'       
AND     nm_obj_type = ngt_group_type
AND     ngt_linear_flag = 'Y'
/

