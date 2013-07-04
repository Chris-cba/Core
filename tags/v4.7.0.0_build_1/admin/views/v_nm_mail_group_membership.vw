CREATE OR REPLACE FORCE VIEW v_nm_mail_group_membership AS
SELECT
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)v_nm_mail_group_membership.vw	1.2 12/03/03
--       Module Name      : v_nm_mail_group_membership.vw
--       Date into SCCS   : 03/12/03 10:06:11
--       Date fetched Out : 07/06/13 17:08:34
--       SCCS Version     : 1.2
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       nmgm.*
      ,nmu.nmu_name
      ,nmu.nmu_email_address
      ,nmg.nmg_name
 FROM  nm_mail_group_membership nmgm
      ,nm_mail_users            nmu
      ,nm_mail_groups           nmg
WHERE  nmgm_nmu_id = nmu_id
 AND   nmgm_nmg_id = nmg_id
/
