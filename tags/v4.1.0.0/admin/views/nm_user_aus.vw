CREATE OR replace force view nm_user_aus AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_user_aus.vw	1.3 03/24/05
--       Module Name      : nm_user_aus.vw
--       Date into SCCS   : 05/03/24 16:27:21
--       Date fetched Out : 07/06/13 17:08:22
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
       *
 FROM  nm_user_aus_all
WHERE  --nua_start_date <= (select nm3context.get_effective_date from dual)
-- AND   NVL(nua_end_date,TO_DATE('99991231','YYYYMMDD')) > (select nm3context.get_effective_date from dual)
nua_end_date IS NULL
/
