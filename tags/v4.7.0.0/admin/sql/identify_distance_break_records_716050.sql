-- End Date NM_INV_ITEM_GROUPINGS For Which Asset Do Not Exists
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/sql/identify_distance_break_records_716050.sql-arc   3.1   Jul 04 2013 09:32:52   James.Wadsworth  $
--       Module Name      : $Workfile:   identify_distance_break_records_716050.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:32:52  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:29:18  $
--       PVCS Version     : $Revision:   3.1  $
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
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

  
