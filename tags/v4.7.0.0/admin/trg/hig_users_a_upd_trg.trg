CREATE OR REPLACE TRIGGER hig_users_a_upd_trg
           AFTER UPDATE ON HIG_USERS
           FOR EACH ROW
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_users_a_upd_trg.trg	1.3 12/20/02
--       Module Name      : hig_users_a_upd_trg.trg
--       Date into SCCS   : 02/12/20 10:25:55
--       Date fetched Out : 07/06/13 17:02:33
--       SCCS Version     : 1.3
--
--   TRIGGER A_I_HUS
--           AFTER INSERT ON HIG_USERS
--           FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
   IF :OLD.hus_name != :NEW.hus_name 
    THEN
    
      UPDATE HIG_USER_FAVOURITES
      SET huf_descr = :NEW.hus_name||'s Favourite Modules'
      WHERE huf_user_id = NVL(:NEW.hus_user_id, :OLD.hus_user_id)
        AND huf_parent = 'ROOT'
        AND huf_child  = 'FAVOURITES';      
  
   END IF;
END;
/

