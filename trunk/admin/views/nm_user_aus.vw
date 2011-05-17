CREATE OR replace force view nm_user_aus AS
SELECT
--
-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/views/nm_user_aus.vw-arc   2.3   May 17 2011 08:32:44   Steve.Cooper  $
--       Module Name      : $Workfile:   nm_user_aus.vw  $
--       Date into PVCS   : $Date:   May 17 2011 08:32:44  $
--       Date fetched Out : $Modtime:   Mar 31 2011 11:51:54  $
--       PVCS Version     : $Revision:   2.3  $
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
       *
 FROM  nm_user_aus_all
WHERE  nua_end_date IS NULL
/
