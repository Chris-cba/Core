--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/doc_issued_century_repair.sql-arc   1.2   Jul 04 2013 13:45:00   James.Wadsworth  $
--       Module Name      : $Workfile:   doc_issued_century_repair.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:45:00  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:08  $
--       PVCS Version     : $Revision:   1.2  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
--------------------------------------------------------------------------------
-- doc_issued_century_repair.sql - module to repair damage by incorrect implicit date format mask being applied in the doc-loader process.
--
update docs
set doc_date_issued = to_date(to_char(doc_date_issued, 'DD-MON-RR'), 'DD-MON-RR')
where  doc_date_issued < to_date ('01-jan-0900', 'DD-MON-YYYY')
/
