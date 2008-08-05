CREATE OR replace force view nm_nodes AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_nodes.vw	1.3 03/24/05
--       Module Name      : nm_nodes.vw
--       Date into SCCS   : 05/03/24 16:23:51
--       Date fetched Out : 07/06/13 17:08:18
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
       *
 FROM  nm_nodes_all
WHERE  no_start_date <= (select nm3context.get_effective_date from dual)
 AND   NVL(no_end_date,TO_DATE('99991231','YYYYMMDD')) > (select nm3context.get_effective_date from dual)
/
