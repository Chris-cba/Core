CREATE OR REPLACE TRIGGER nmu_a_i_trg
  AFTER INSERT
  ON nm_mail_users
  FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nmu_a_i_trg.trg	1.1 01/30/02
--       Module Name      : nmu_a_i_trg.trg
--       Date into SCCS   : 02/01/30 16:47:49
--       Date fetched Out : 07/06/13 17:03:49
--       SCCS Version     : 1.1
--
--   Author : Jonathan Mills
--
--   TRIGGER nmu_a_i_trg
--     AFTER INSERT
--     ON nm_mail_users
--    FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
--
   INSERT INTO nm_mail_group_membership (nmgm_nmg_id,nmgm_nmu_id)
   VALUES (0,:NEW.nmu_id);
--
EXCEPTION
--
   WHEN others
    THEN
      Null;
--
END nmu_a_i_trg;
/
