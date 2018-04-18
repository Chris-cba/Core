--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/doc_issued_century_repair.sql-arc   1.3   Apr 18 2018 15:39:18   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   doc_issued_century_repair.sql  $
--       Date into PVCS   : $Date:   Apr 18 2018 15:39:18  $
--       Date fetched Out : $Modtime:   Apr 18 2018 15:38:16  $
--       PVCS Version     : $Revision:   1.3  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
--------------------------------------------------------------------------------
-- doc_issued_century_repair.sql - module to repair damage by incorrect implicit date format mask being applied in the doc-loader process.
--
update docs
set doc_date_issued = to_date(to_char(doc_date_issued, 'DD-MON-RR'), 'DD-MON-RR')
where  doc_date_issued < to_date ('01-jan-0900', 'DD-MON-YYYY')
/
