CREATE OR REPLACE FORCE VIEW V_NM_MSV_MAPS
(VNMM_NAME, VNMM_DESCRIPTION)
AS 
SELECT 
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)v_nm_msv_maps.vw	1.2 02/06/06
--       Module Name      : v_nm_msv_maps.vw
--       Date into SCCS   : 06/02/06 10:16:54
--       Date fetched Out : 07/06/13 17:08:36
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
       name
     , description 
  FROM user_sdo_maps
/

