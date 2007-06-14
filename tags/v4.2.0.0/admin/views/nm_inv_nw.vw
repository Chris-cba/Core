CREATE OR replace force view nm_inv_nw AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_nw.vw	1.3 03/24/05
--       Module Name      : nm_inv_nw.vw
--       Date into SCCS   : 05/03/24 16:20:56
--       Date fetched Out : 07/06/13 17:08:09
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
       *
 FROM  nm_inv_nw_all
WHERE  nin_start_date <= (select nm3context.get_effective_date from dual)
 AND   NVL(nin_end_date,TO_DATE('99991231','YYYYMMDD')) > (select nm3context.get_effective_date from dual)

/
