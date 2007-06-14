CREATE OR replace force view nm_node_usages AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_node_usages.vw	1.3 03/24/05
--       Module Name      : nm_node_usages.vw
--       Date into SCCS   : 05/03/24 16:24:37
--       Date fetched Out : 07/06/13 17:08:17
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
       *
 FROM  nm_node_usages_all
WHERE  nnu_start_date <= (select nm3context.get_effective_date from dual)
 AND   NVL(nnu_end_date,TO_DATE('99991231','YYYYMMDD')) > (select nm3context.get_effective_date from dual)

/
