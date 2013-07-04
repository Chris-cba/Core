-- End Date NM_INV_ITEM_GROUPINGS For Which Asset Do Not Exists
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/utl/enddate_db_records_716050.sql-arc   3.1   Jul 04 2013 10:30:10   James.Wadsworth  $
--       Module Name      : $Workfile:   enddate_db_records_716050.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 10:30:10  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:22:22  $
--       PVCS Version     : $Revision:   3.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--

PROMPT End Date Orphan Distance Break Records

UPDATE nm_elements ne
SET    ne_end_date = Trunc(sysdate)
WHERE  ne_id IN ( SELECT ne_id
                  FROM   nm_elements ne
                  WHERE  ne_type = 'D'
                  AND    Not Exists (SELECT 'x' FROM nm_members nm
                                     WHERE  nm.nm_ne_id_of = ne.ne_id) 
                 )      
AND    ne_type = 'D'
/

  
