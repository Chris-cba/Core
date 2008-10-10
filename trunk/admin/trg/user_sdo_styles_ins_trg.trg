BEGIN
  EXECUTE IMMEDIATE 'DROP TRIGGER USER_SDO_STYLES_INS_TRG';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

CREATE OR REPLACE TRIGGER USER_SDO_STYLES_INS_TRG
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/trg/user_sdo_styles_ins_trg.trg-arc   3.1   Oct 10 2008 10:37:14   aedwards  $
--       Module Name      : $Workfile:   user_sdo_styles_ins_trg.trg  $
--       Date into PVCS   : $Date:   Oct 10 2008 10:37:14  $
--       Date fetched Out : $Modtime:   Oct 10 2008 10:34:26  $
--       Version          : $Revision:   3.1  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
INSTEAD OF DELETE OR INSERT OR UPDATE
ON USER_SDO_STYLES REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
  l_rec_uss user_sdo_styles%ROWTYPE;
BEGIN
--
  IF INSERTING 
  THEN
  --
    l_rec_uss.name         := :NEW.name;
    l_rec_uss.type         := :NEW.type;
    l_rec_uss.description  := :NEW.description;
    l_rec_uss.definition   := :NEW.definition;
    l_rec_uss.image        := :NEW.image;
    l_rec_uss.geometry     := :NEW.geometry;
  --
    nm3msv_sec.do_uss_ins ( pi_username => USER
                          , pi_rec_uss  => l_rec_uss );
  --
  ELSIF DELETING 
  THEN
  --
    l_rec_uss.name         := :OLD.name;
    l_rec_uss.type         := :OLD.type;
    l_rec_uss.description  := :OLD.description;
    l_rec_uss.definition   := :OLD.definition;
    l_rec_uss.image        := :OLD.image;
    l_rec_uss.geometry     := :OLD.geometry;
  --
     nm3msv_sec.do_uss_del ( pi_username => USER
                           , pi_rec_uss  => l_rec_uss ); 
  --
  ELSIF UPDATING 
  THEN
  --
    l_rec_uss.name         := NVL (:NEW.name, :OLD.name);
    l_rec_uss.type         := NVL (:NEW.type, :OLD.type);
    l_rec_uss.description  := NVL (:NEW.description, :OLD.description);
    l_rec_uss.definition   := NVL (:NEW.definition, :OLD.definition);
  --
    IF :NEW.image IS NOT NULL 
    THEN
      l_rec_uss.image     :=:NEW.image;
    ELSE
      l_rec_uss.image     :=:OLD.image;
    END IF;
  --
    l_rec_uss.geometry := NVL (:NEW.geometry, :OLD.geometry);
  --
    nm3msv_sec.do_uss_upd ( pi_username => USER
                          , pi_rec_uss  => l_rec_uss );
  --
  END IF;
--
END;
/


