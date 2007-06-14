CREATE OR replace force view nm_inv_item_groupings AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_item_groupings.vw	1.3 03/24/05
--       Module Name      : nm_inv_item_groupings.vw
--       Date into SCCS   : 05/03/24 16:19:15
--       Date fetched Out : 07/06/13 17:08:08
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
       *
 FROM  nm_inv_item_groupings_all
WHERE  iig_start_date <= (select nm3context.get_effective_date from dual)
 AND   NVL(iig_end_date,TO_DATE('99991231','YYYYMMDD')) > (select nm3context.get_effective_date from dual)
/
