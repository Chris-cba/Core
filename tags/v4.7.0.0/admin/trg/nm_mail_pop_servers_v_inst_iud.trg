CREATE OR REPLACE TRIGGER nm_mail_pop_servers_v_inst_iud
   INSTEAD OF INSERT OR UPDATE OR DELETE
   ON nm_mail_pop_servers_v
   FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_mail_pop_servers_v_inst_iud.trg	1.1 03/07/05
--       Module Name      : nm_mail_pop_servers_v_inst_iud.trg
--       Date into SCCS   : 05/03/07 23:49:15
--       Date fetched Out : 07/06/13 17:03:15
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   NM3 POP Mail view instead of trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_rec_nmps_old nm_mail_pop_servers%ROWTYPE;
   l_rec_nmps_new nm_mail_pop_servers%ROWTYPE;
--
BEGIN
--
   l_rec_nmps_old.nmps_id                := :OLD.nmps_id;
   l_rec_nmps_old.nmps_description       := :OLD.nmps_description;
   l_rec_nmps_old.nmps_server_name       := :OLD.nmps_server_name;
   l_rec_nmps_old.nmps_server_port       := :OLD.nmps_server_port;
   l_rec_nmps_old.nmps_username          := :OLD.nmps_username;
   l_rec_nmps_old.nmps_password          := :OLD.nmps_password;
   l_rec_nmps_old.nmps_timeout           := :OLD.nmps_timeout;
--
   l_rec_nmps_new.nmps_id                := :NEW.nmps_id;
   l_rec_nmps_new.nmps_description       := :NEW.nmps_description;
   l_rec_nmps_new.nmps_server_name       := :NEW.nmps_server_name;
   l_rec_nmps_new.nmps_server_port       := :NEW.nmps_server_port;
   l_rec_nmps_new.nmps_username          := :NEW.nmps_username;
   l_rec_nmps_new.nmps_password          := :NEW.nmps_password;
   l_rec_nmps_new.nmps_timeout           := :NEW.nmps_timeout;
--
   nm3mail_pop.store_nmps_from_instead_of_trg
                            (pi_rec_nmps_old => l_rec_nmps_old
                            ,pi_rec_nmps_new => l_rec_nmps_new
                            ,pi_inserting    => INSERTING
                            ,pi_updating     => UPDATING
                            ,pi_deleting     => DELETING
                            );
--
END nm_mail_pop_servers_v_inst_iud;
/
