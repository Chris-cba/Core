CREATE OR replace force view nm_inv_domains AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_domains.vw	1.3 03/24/05
--       Module Name      : nm_inv_domains.vw
--       Date into SCCS   : 05/03/24 16:18:01
--       Date fetched Out : 07/06/13 17:08:07
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       *
 FROM  nm_inv_domains_all
WHERE  id_start_date                                    <=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
 AND   NVL(id_end_date,TO_DATE('99991231','YYYYMMDD'))  >   To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')

/