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
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       *
 FROM  nm_nodes_all
WHERE  no_start_date                                    <=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
 AND   NVL(no_end_date,TO_DATE('99991231','YYYYMMDD'))  >   To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
/
