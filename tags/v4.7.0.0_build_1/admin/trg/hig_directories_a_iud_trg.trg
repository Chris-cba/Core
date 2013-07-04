CREATE OR REPLACE TRIGGER hig_directories_a_iud_trg
AFTER INSERT OR UPDATE OR DELETE
ON    HIG_DIRECTORIES
REFERENCING 
       NEW AS NEW 
       OLD AS OLD
FOR EACH ROW

DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_directories_a_iud_trg.trg	1.1 08/31/05
--       Module Name      : hig_directories_a_iud_trg.trg
--       Date into SCCS   : 05/08/31 15:38:58
--       Date fetched Out : 07/06/13 17:02:30
--       SCCS Version     : 1.1
--
--
--   Author : G Johnson
--
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

 l_hdir_rec_old  hig_directories%ROWTYPE;
 l_hdir_rec_new  hig_directories%ROWTYPE; 
 l_action        VARCHAR2(1);
 
BEGIN

--
 l_hdir_rec_old.hdir_name      := :OLD.hdir_name;
 l_hdir_rec_old.hdir_path      := :OLD.hdir_path;
 l_hdir_rec_old.hdir_path      := :OLD.hdir_url; 
 l_hdir_rec_old.hdir_comments  := :OLD.hdir_comments;
 l_hdir_rec_old.hdir_protected := :OLD.hdir_protected;  
-- 
 l_hdir_rec_new.hdir_name      := :NEW.hdir_name;
 l_hdir_rec_new.hdir_path      := :NEW.hdir_path;
 l_hdir_rec_new.hdir_path      := :NEW.hdir_url; 
 l_hdir_rec_new.hdir_comments  := :NEW.hdir_comments;
 l_hdir_rec_new.hdir_protected := :NEW.hdir_protected;  
--
 IF DELETING THEN
   l_action := 'D';
 ELSIF UPDATING THEN
   l_action := 'U';
 ELSE 
   l_action := 'I';
 END IF;   

 hig_directories_api.enforce_protection(pi_hdir_rec_old => l_hdir_rec_old
                                       ,pi_hdir_rec_new => l_hdir_rec_new
									   ,pi_action       => l_action );
 

 IF DELETING THEN
   hig_directories_api.rmdir(pi_directory_name => :OLD.hdir_name);
						   
 ELSE
   hig_directories_api.mkdir(pi_replace        => TRUE
                           ,pi_directory_name => :NEW.hdir_name
                           ,pi_directory_path => :NEW.hdir_path);
 END IF;						   
 
END hig_directories_a_iud_trg;
/

