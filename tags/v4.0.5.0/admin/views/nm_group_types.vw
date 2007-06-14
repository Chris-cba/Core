CREATE OR replace force view nm_group_types AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_group_types.vw	1.3 03/24/05
--       Module Name      : nm_group_types.vw
--       Date into SCCS   : 05/03/24 16:16:51
--       Date fetched Out : 07/06/13 17:08:06
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
       *
 FROM  nm_group_types_all
WHERE  ngt_start_date <= (select nm3context.get_effective_date from dual)
 AND   NVL(ngt_end_date,TO_DATE('99991231','YYYYMMDD')) > (select nm3context.get_effective_date from dual)

/
