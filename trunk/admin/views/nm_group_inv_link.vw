CREATE OR REPLACE FORCE VIEW nm_group_inv_link AS
SELECT
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_group_inv_link.vw	1.3 03/24/05
--       Module Name      : nm_group_inv_link.vw
--       Date into SCCS   : 05/03/24 16:15:44
--       Date fetched Out : 07/06/13 17:08:05
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
        ngil.*
FROM    nm_group_inv_link_all ngil 
WHERE   ngil.ngil_start_date                                    <=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
AND     NVL(ngil.ngil_end_date, TO_DATE('99991231','YYYYMMDD')) >   To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
/
