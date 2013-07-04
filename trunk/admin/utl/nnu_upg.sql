--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/utl/nnu_upg.sql-arc   2.1   Jul 04 2013 10:30:12   James.Wadsworth  $
--       Module Name      : $Workfile:   nnu_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 10:30:12  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:25:32  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
 --
rename nm_node_usages to nm_node_usages_all;
--
alter table nm_node_usages_all
add (nnu_start_date DATE, nnu_end_date DATE);
--
UPDATE nm_node_usages_all
SET nnu_start_date = (SELECT no_start_date
                       FROM  nm_nodes
                      WHERE  no_node_id = nnu_no_node_id
                     )
WHERE nnu_start_date IS NULL;
--
ALTER TABLE nm_node_usages_all
MODIFY nnu_start_date DATE DEFAULT TO_DATE('05111605','DDMMYYYY') NOT NULL;
--
