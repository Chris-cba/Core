CREATE OR REPLACE TRIGGER A_I_HUS
           AFTER INSERT ON HIG_USERS
           FOR EACH ROW
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_users.trg	1.2 04/10/01
--       Module Name      : hig_users.trg
--       Date into SCCS   : 01/04/10 10:49:54
--       Date fetched Out : 07/06/13 17:02:32
--       SCCS Version     : 1.2
--
--   TRIGGER A_I_HUS
--           AFTER INSERT ON HIG_USERS
--           FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
   v_num   number;
BEGIN
   insert into hig_user_favourites
          (HUF_USER_ID
          ,HUF_PARENT
          ,HUF_CHILD
          ,HUF_DESCR
          ,HUF_TYPE
          )
   values (:new.hus_user_id
          ,'ROOT'
          ,'FAVOURITES'
          ,:new.HUS_NAME||'s Favourite Modules'
          ,'F'
          );
END;
/
ALTER TRIGGER A_I_HUS COMPILE;

CREATE OR REPLACE TRIGGER A_I_HUS_STATEMENT
           AFTER INSERT ON HIG_USERS
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_users.trg	1.2 04/10/01
--       Module Name      : hig_users.trg
--       Date into SCCS   : 01/04/10 10:49:54
--       Date fetched Out : 07/06/13 17:02:32
--       SCCS Version     : 1.2
--
--   TRIGGER A_I_HUS_STATEMENT
--           AFTER INSERT ON HIG_USERS
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_count BINARY_INTEGER;
--
   CURSOR cs_app_owner IS
   SELECT COUNT(*)
    FROM  hig_users
   WHERE  hus_is_hig_owner_flag = 'Y';
--
BEGIN
--
   OPEN  cs_app_owner;
   FETCH cs_app_owner INTO l_count;
   CLOSE cs_app_owner;
--
   IF l_count <> 1
    THEN
      RAISE_APPLICATION_ERROR(-20001,'There must be 1 and only 1 record with hus_is_hig_owner_flag set');
   END IF;
--
END A_I_HUS_STATEMENT;
/
ALTER TRIGGER A_I_HUS_STATEMENT COMPILE;


CREATE OR REPLACE TRIGGER B_U_HUS
           BEFORE UPDATE ON HIG_USERS
           FOR EACH ROW
BEGIN
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_users.trg	1.2 04/10/01
--       Module Name      : hig_users.trg
--       Date into SCCS   : 01/04/10 10:49:54
--       Date fetched Out : 07/06/13 17:02:32
--       SCCS Version     : 1.2
--
--      TRIGGER B_U_HUS
--           BEFORE UPDATE ON HIG_USERS
--           FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   IF   :NEW.hus_is_hig_owner_flag  = 'Y'
    AND :NEW.HUS_UNRESTRICTED      != 'Y'
    THEN
      RAISE_APPLICATION_ERROR(-20003,'HIG_USERS records with HUS_IS_HIG_OWNER_FLAG set to "Y" must also have HUS_UNRESTRICTED set to "Y"');
   END IF;
--
   IF :new.HUS_UNRESTRICTED != :old.HUS_UNRESTRICTED
    THEN
      IF NOT Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' then
         raise_application_error ( -20002, 'Insufficient Privileges to Update this Record');
      end if;
   end if;
--
   IF :old.hus_is_hig_owner_flag <> :new.hus_is_hig_owner_flag
    THEN
      raise_application_error ( -20001, 'Cannot update HIG_USERS.HUS_IS_HIG_OWNER_FLAG');
   END IF;
--
END B_U_HUS;
/
--
ALTER TRIGGER B_U_HUS COMPILE;
--
CREATE OR REPLACE TRIGGER B_D_HUS
   BEFORE DELETE ON HIG_USERS
   FOR EACH ROW
BEGIN
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_users.trg	1.2 04/10/01
--       Module Name      : hig_users.trg
--       Date into SCCS   : 01/04/10 10:49:54
--       Date fetched Out : 07/06/13 17:02:32
--       SCCS Version     : 1.2
--
-- TRIGGER B_D_HUS
--   BEFORE DELETE ON HIG_USERS
--   FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   IF :OLD.hus_is_hig_owner_flag = 'Y'
    THEN
      raise_application_error ( -20001, 'Must have record with hus_is_hig_owner_flag set');
   END IF;
--
END;
/
--
