-- End Date NM_INV_ITEM_GROUPINGS For Which Asset Do Not Exists
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/sql/enddate_db_records_716050.sql-arc   3.0   Apr 15 2009 14:23:14   lsorathia  $
--       Module Name      : $Workfile:   enddate_db_records_716050.sql  $
--       Date into PVCS   : $Date:   Apr 15 2009 14:23:14  $
--       Date fetched Out : $Modtime:   Apr 15 2009 11:22:12  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
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

  