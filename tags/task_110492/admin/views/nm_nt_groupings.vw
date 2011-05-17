CREATE OR replace force view nm_nt_groupings AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_nt_groupings.vw	1.3 03/24/05
--       Module Name      : nm_nt_groupings.vw
--       Date into SCCS   : 05/03/24 16:25:12
--       Date fetched Out : 07/06/13 17:08:19
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
       *
 FROM  nm_nt_groupings_all
WHERE  nng_start_date                                   <=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
 AND   NVL(nng_end_date,TO_DATE('99991231','YYYYMMDD')) >   To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')

/
