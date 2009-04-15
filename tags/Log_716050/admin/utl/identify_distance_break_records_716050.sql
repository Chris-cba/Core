-- End Date NM_INV_ITEM_GROUPINGS For Which Asset Do Not Exists
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/utl/identify_distance_break_records_716050.sql-arc   3.0   Apr 15 2009 16:20:40   lsorathia  $
--       Module Name      : $Workfile:   identify_distance_break_records_716050.sql  $
--       Date into PVCS   : $Date:   Apr 15 2009 16:20:40  $
--       Date fetched Out : $Modtime:   Apr 15 2009 16:18:56  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--
Set linesize 1000
set Pagesize 100

PROMPT Following are the Orphan Distance Break Records

SELECT ne_id, ne_unique,ne_descr,ne_start_date
FROM   nm_elements ne
WHERE  ne_type = 'D'
AND    Not Exists (SELECT 'x' FROM nm_members nm
                   WHERE  nm.nm_ne_id_of = ne.ne_id) 
/

  