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
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       *
 FROM  nm_group_types_all
WHERE  ngt_start_date                                   <=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
 AND   NVL(ngt_end_date,TO_DATE('99991231','YYYYMMDD')) >   To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')   

/
