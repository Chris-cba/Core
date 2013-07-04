CREATE OR replace force view nm_user_aus AS
SELECT
--
-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/views/nm_user_aus.vw-arc   2.4   Jul 04 2013 11:20:52   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_user_aus.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:52  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:33:42  $
--       PVCS Version     : $Revision:   2.4  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       *
 FROM  nm_user_aus_all
WHERE  nua_end_date IS NULL
/
