CREATE OR replace force view nm_elements AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_elements.vw	1.3 03/24/05
--       Module Name      : nm_elements.vw
--       Date into SCCS   : 05/03/24 16:15:06
--       Date fetched Out : 07/06/13 17:08:05
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
       *
 FROM  nm_elements_all
WHERE  ne_start_date <= (select nm3context.get_effective_date from dual)
 AND   NVL(ne_end_date,TO_DATE('99991231','YYYYMMDD')) > (select nm3context.get_effective_date from dual)

/
