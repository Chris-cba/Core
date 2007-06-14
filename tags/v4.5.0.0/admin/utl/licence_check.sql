-- Licence check script. Output contents of HIG_PU table.
-- If the Maximum number of concurrent users for any Product exceeds the number of 
-- concurrently licensed users for that Product then the terms of Exor's licence have
-- been broken
--
select hpu_product "Prod.", max(hpu_current) "Max Concurrent Users"
from   hig_pu
group by hpu_product;

