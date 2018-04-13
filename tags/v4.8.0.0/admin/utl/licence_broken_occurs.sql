--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/utl/licence_broken_occurs.sql-arc   2.2   Apr 13 2018 12:53:22   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   licence_broken_occurs.sql  $
--       Date into PVCS   : $Date:   Apr 13 2018 12:53:22  $
--       Date fetched Out : $Modtime:   Apr 13 2018 12:49:46  $
--       Version          : $Revision:   2.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
-- This script lists the occasions when the number of concurrent sessions
-- for the defined Product is greater than the defined number of licenced
-- Users
--
prompt

undefine product
undefine licenced

accept product       char prompt 'The Product being checked: '
accept licenced      char prompt 'The number of licenced concurrent Users for the Product: '
prompt;

select substr(to_char(hpu_start,'DD-MON-YYYY HH24:MM'),1,18) "Date", hpu_product "Prod.", hpu_current "Concurrent Users"
from   hig_pu
where  hpu_product = upper('&product')
  and  hpu_current > &licenced;

