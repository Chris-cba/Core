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
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       *
 FROM  nm_inv_item_groupings_all
WHERE  iig_start_date                                   <=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
 AND   NVL(iig_end_date,TO_DATE('99991231','YYYYMMDD')) >   To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
/
