CREATE OR replace force view nm_user_aus AS
SELECT
--
-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/views/nm_user_aus.vw-arc   2.2   Nov 06 2009 13:39:54   aedwards  $
--       Module Name      : $Workfile:   nm_user_aus.vw  $
--       Date into PVCS   : $Date:   Nov 06 2009 13:39:54  $
--       Date fetched Out : $Modtime:   Nov 06 2009 13:39:24  $
--       PVCS Version     : $Revision:   2.2  $
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
