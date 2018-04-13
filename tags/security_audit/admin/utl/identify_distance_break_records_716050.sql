-- End Date NM_INV_ITEM_GROUPINGS For Which Asset Do Not Exists
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/utl/identify_distance_break_records_716050.sql-arc   3.2   Apr 13 2018 12:53:22   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   identify_distance_break_records_716050.sql  $
--       Date into PVCS   : $Date:   Apr 13 2018 12:53:22  $
--       Date fetched Out : $Modtime:   Apr 13 2018 12:49:46  $
--       PVCS Version     : $Revision:   3.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
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

  
