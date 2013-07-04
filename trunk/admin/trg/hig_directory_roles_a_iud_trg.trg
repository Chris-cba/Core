CREATE OR REPLACE TRIGGER hig_directory_roles_a_iud_trg
AFTER INSERT OR UPDATE OR DELETE
ON HIG_DIRECTORY_ROLES
REFERENCING
       NEW AS NEW
       OLD AS OLD
FOR EACH ROW
DECLARE

-----------------------------------------------------------------------------
--
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/hig_directory_roles_a_iud_trg.trg-arc   2.4   Jul 04 2013 09:53:16   James.Wadsworth  $
--       Module Name      : $Workfile:   hig_directory_roles_a_iud_trg.trg  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:53:16  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:35:30  $
--       SCCS Version     : $Revision:   2.4  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------


 l_hdr_rec_old hig_directory_roles%ROWTYPE;
 l_hdr_rec_new hig_directory_roles%ROWTYPE;
 hdir_not_exists exception;
 pragma exception_init (hdir_not_exists, -20000 );

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
   begin
      hig_directories_api.revoke_role_on_directory(pi_hdr_rec => l_hdr_rec_old);
   exception
     when hdir_not_exists then
       if instr( sqlerrm, '257' ) > 0 then
          null; -- we should just remove the record.
       else
         raise;
       end if;
   end;

   END IF;

END hig_directory_roles_a_iud_trg;
/
