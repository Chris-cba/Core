CREATE OR REPLACE TRIGGER nmmr_b_i_trg
  BEFORE INSERT OR UPDATE
  ON nm_mail_message_recipients
  FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nmmr_b_i_trg.trg	1.2 02/01/02
--       Module Name      : nmmr_b_i_trg.trg
--       Date into SCCS   : 02/02/01 08:31:14
--       Date fetched Out : 07/06/13 17:03:47
--       SCCS Version     : 1.2
--
--
--   Author : Jonathan Mills
--
--   TRIGGER nmmr_b_i_trg
--    BEFORE INSERT OR UPDATE
--    ON nm_mail_message_recipients
--    FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   CURSOR cs_group (c_group_id NUMBER) IS
   SELECT 1
    FROM  nm_mail_groups
   WHERE  nmg_id = c_group_id;
--
   CURSOR cs_user (c_user_id NUMBER) IS
   SELECT 1
    FROM  nm_mail_users
   WHERE  nmu_id = c_user_id;
--
   l_parent_not_found EXCEPTION;
--
   l_dummy BINARY_INTEGER;
--
BEGIN
--
   IF :new.nmmr_rcpt_type = nm3mail.c_user
    THEN
--
      OPEN  cs_user(:new.nmmr_rcpt_id);
      FETCH cs_user INTO l_dummy;
      IF cs_user%NOTFOUND
       THEN
         CLOSE cs_user;
         RAISE l_parent_not_found;
      END IF;
      CLOSE cs_user;
--
   ELSIF :new.nmmr_rcpt_type = nm3mail.c_group
    THEN
--
      OPEN  cs_group(:new.nmmr_rcpt_id);
      FETCH cs_group INTO l_dummy;
      IF cs_group%NOTFOUND
       THEN
         CLOSE cs_group;
         RAISE l_parent_not_found;
      END IF;
      CLOSE cs_group;
--
   END IF;
--
EXCEPTION
--
   WHEN l_parent_not_found
    THEN
      RAISE_APPLICATION_ERROR(-20001,'Specified '||:new.nmmr_rcpt_type||' '||:new.nmmr_rcpt_id||' not found');
--
END nmmr_b_i;
/
