CREATE OR replace force view nm_user_aus AS
SELECT
--
-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/nm_user_aus.vw-arc   2.5   Apr 13 2018 11:47:22   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm_user_aus.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:22  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:36:08  $
--       PVCS Version     : $Revision:   2.5  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       *
 FROM  nm_user_aus_all
WHERE  nua_end_date IS NULL
/
