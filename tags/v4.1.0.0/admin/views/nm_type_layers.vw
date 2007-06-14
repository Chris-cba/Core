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
WHERE  ntl_start_date <= (select nm3context.get_effective_date from dual)
 AND   NVL(ntl_end_date,TO_DATE('99991231','YYYYMMDD')) > (select nm3context.get_effective_date from dual)
/
