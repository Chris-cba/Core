CREATE OR replace force view nm_group_relations AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_group_relations.vw	1.3 03/24/05
--       Module Name      : nm_group_relations.vw
--       Date into SCCS   : 05/03/24 16:16:16
--       Date fetched Out : 07/06/13 17:08:06
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       *
 FROM  nm_group_relations_all
WHERE  ngr_start_date                                   <=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
 AND   NVL(ngr_end_date,TO_DATE('99991231','YYYYMMDD')) >   To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')

/
