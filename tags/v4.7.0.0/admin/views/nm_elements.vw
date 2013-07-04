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
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       *
 FROM  nm_elements_all
WHERE  ne_start_date                                    <=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
 AND   NVL(ne_end_date,TO_DATE('99991231','YYYYMMDD'))  >   To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')

/
