CREATE OR replace force view nm_inv_attri_lookup AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_attri_lookup.vw	1.3 03/24/05
--       Module Name      : nm_inv_attri_lookup.vw
--       Date into SCCS   : 05/03/24 16:17:31
--       Date fetched Out : 07/06/13 17:08:07
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       *
 FROM  nm_inv_attri_lookup_all
WHERE  ial_start_date                                   <=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
 AND   NVL(ial_end_date,TO_DATE('99991231','YYYYMMDD')) >   To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')

/
