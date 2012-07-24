--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/doc_issued_century_repair.sql-arc   1.1   Jul 24 2012 14:49:42   Rob.Coupe  $
--       Module Name      : $Workfile:   doc_issued_century_repair.sql  $
--       Date into PVCS   : $Date:   Jul 24 2012 14:49:42  $
--       Date fetched Out : $Modtime:   Jul 24 2012 14:49:26  $
--       PVCS Version     : $Revision:   1.1  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2012 Bentley Systems Incorporated.
--------------------------------------------------------------------------------
-- doc_issued_century_repair.sql - module to repair damage by incorrect implicit date format mask being applied in the doc-loader process.
--
update docs
set doc_date_issued = to_date(to_char(doc_date_issued, 'DD-MON-RR'), 'DD-MON-RR')
where  doc_date_issued < to_date ('01-jan-0900', 'DD-MON-YYYY')
/
