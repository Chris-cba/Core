--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/utl/nnu_upg.sql-arc   2.2   Apr 13 2018 12:53:22   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nnu_upg.sql  $
--       Date into PVCS   : $Date:   Apr 13 2018 12:53:22  $
--       Date fetched Out : $Modtime:   Apr 13 2018 12:51:54  $
--       Version          : $Revision:   2.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
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