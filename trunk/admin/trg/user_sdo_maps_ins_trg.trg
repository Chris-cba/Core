CREATE OR REPLACE TRIGGER USER_SDO_MAPS_INS_TRG
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/trg/user_sdo_maps_ins_trg.trg-arc   3.0   Oct 02 2008 09:44:12   aedwards  $
--       Module Name      : $Workfile:   user_sdo_maps_ins_trg.trg  $
--       Date into PVCS   : $Date:   Oct 02 2008 09:44:12  $
--       Date fetched Out : $Modtime:   Oct 02 2008 09:40:10  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
INSTEAD OF DELETE OR INSERT OR UPDATE
ON USER_SDO_MAPS 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
   l_rec_usm user_sdo_maps%ROWTYPE;
BEGIN
--
  IF INSERTING 
  THEN
  --
    l_rec_usm.name        := :NEW.name;
    l_rec_usm.description := :NEW.description;
    l_rec_usm.definition  := :NEW.definition; 
  --
    nm3msv_sec.do_usm_ins ( pi_username => USER
                          , pi_rec_usm  => l_rec_usm );
  --
  ELSIF DELETING 
  THEN
  --
    l_rec_usm.name        := :OLD.name;
    l_rec_usm.description := :OLD.description;
    l_rec_usm.definition  := :OLD.definition;
  --
    nm3msv_sec.do_usm_del ( pi_username => USER
                          , pi_rec_usm  => l_rec_usm );
  --
  ELSIF UPDATING 
  THEN
  --
    l_rec_usm.name        := NVL (:NEW.name, :OLD.name);
    l_rec_usm.description := NVL (:NEW.description, :OLD.description);
    l_rec_usm.definition  := NVL (:NEW.definition, :OLD.definition);
  --
    nm3msv_sec.do_usm_upd ( pi_username => USER
                          , pi_rec_usm  => l_rec_usm );
  --
  END IF;
--
END;
/

