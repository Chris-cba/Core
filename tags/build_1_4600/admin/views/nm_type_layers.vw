CREATE OR replace force view nm_type_layers AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_type_layers.vw	1.3 03/24/05
--       Module Name      : nm_type_layers.vw
--       Date into SCCS   : 05/03/24 16:26:40
--       Date fetched Out : 07/06/13 17:08:21
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
       *
 FROM  nm_type_layers_all
WHERE  ntl_start_date                                   <=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
 AND   NVL(ntl_end_date,TO_DATE('99991231','YYYYMMDD')) >   To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
/
