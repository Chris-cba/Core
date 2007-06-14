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

