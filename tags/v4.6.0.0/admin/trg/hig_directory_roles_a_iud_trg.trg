CREATE OR REPLACE TRIGGER hig_directory_roles_a_iud_trg
AFTER INSERT OR UPDATE OR DELETE
ON    HIG_DIRECTORY_ROLES
REFERENCING
       NEW AS NEW
       OLD AS OLD
FOR EACH ROW

DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_directory_roles_a_iud_trg.trg	1.1 08/31/05
--       Module Name      : hig_directory_roles_a_iud_trg.trg
--       Date into SCCS   : 05/08/31 15:44:00
--       Date fetched Out : 07/06/13 17:02:30
--       SCCS Version     : 1.1
--
--
--   Author : G Johnson
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------


 l_hdr_rec_old hig_directory_roles%ROWTYPE;
 l_hdr_rec_new hig_directory_roles%ROWTYPE;

BEGIN

 l_hdr_rec_old.hdr_name := :OLD.hdr_name;
 l_hdr_rec_old.hdr_role := :OLD.hdr_role;
 l_hdr_rec_old.hdr_mode := :OLD.hdr_mode;

 l_hdr_rec_new.hdr_name := :NEW.hdr_name;
 l_hdr_rec_new.hdr_role := :NEW.hdr_role;
 l_hdr_rec_new.hdr_mode := :NEW.hdr_mode;

 IF INSERTING THEN
   hig_directories_api.grant_role_on_directory(pi_hdr_rec => l_hdr_rec_new);

 ELSIF UPDATING THEN
   -- remove any previously assigned roles before re-applying again
   hig_directories_api.revoke_role_on_directory(pi_hdr_rec => l_hdr_rec_old);

   hig_directories_api.grant_role_on_directory(pi_hdr_rec => l_hdr_rec_new);

 ELSIF DELETING THEN
   -- remove any previously assigned roles before re-applying again
   hig_directories_api.revoke_role_on_directory(pi_hdr_rec => l_hdr_rec_old);

 END IF;

END hig_directory_roles_a_iud_trg;
/

