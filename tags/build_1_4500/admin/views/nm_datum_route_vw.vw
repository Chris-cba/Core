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
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/nm_datum_route_vw.vw-arc   3.0   Jul 09 2009 12:14:08   lsorathia  $
--       Module Name      : $Workfile:   nm_datum_route_vw.vw  $
--       Date into PVCS   : $Date:   Jul 09 2009 12:14:08  $
--       Date fetched Out : $Modtime:   Jul 09 2009 11:52:42  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
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

