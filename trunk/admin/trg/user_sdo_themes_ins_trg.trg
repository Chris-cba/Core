CREATE OR REPLACE TRIGGER USER_SDO_THEMES_INS_TRG
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/trg/user_sdo_themes_ins_trg.trg-arc   3.0   Oct 02 2008 09:44:54   aedwards  $
--       Module Name      : $Workfile:   user_sdo_themes_ins_trg.trg  $
--       Date into PVCS   : $Date:   Oct 02 2008 09:44:54  $
--       Date fetched Out : $Modtime:   Oct 02 2008 09:40:06  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
INSTEAD OF DELETE OR INSERT OR UPDATE
ON USER_SDO_THEMES 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
   l_rec_ust user_sdo_themes%ROWTYPE;
BEGIN
--
  IF INSERTING 
  THEN
  --
    l_rec_ust.name             := :NEW.name;
    l_rec_ust.description      := :NEW.description;
    l_rec_ust.base_table       := :NEW.base_table;
    l_rec_ust.geometry_column  := :NEW.geometry_column;
    l_rec_ust.styling_rules    := :NEW.styling_rules;
  --
    nm3msv_sec.do_ust_ins ( pi_username => USER
                          , pi_rec_ust  => l_rec_ust );
  --
  ELSIF DELETING 
  THEN
  --
    l_rec_ust.name             := :OLD.name;
    l_rec_ust.description      := :OLD.description;
    l_rec_ust.base_table       := :OLD.base_table;
    l_rec_ust.geometry_column  := :OLD.geometry_column;
    l_rec_ust.styling_rules    := :OLD.styling_rules;
  --
    nm3msv_sec.do_ust_del ( pi_username => USER
                          , pi_rec_ust  => l_rec_ust );
  --
  ELSIF UPDATING 
  THEN
  --
    l_rec_ust.name             := NVL(:NEW.name, :OLD.name);
    l_rec_ust.description      := NVL (:NEW.description, :OLD.description);
    l_rec_ust.base_table       := NVL(:NEW.base_table, :OLD.base_table);
    l_rec_ust.geometry_column  := NVL(:NEW.geometry_column, :OLD.geometry_column);
    l_rec_ust.styling_rules    := NVL (:NEW.styling_rules, :OLD.styling_rules);
  --
    nm3msv_sec.do_ust_upd ( pi_username => USER
                          , pi_rec_ust  => l_rec_ust );
  --
  END IF;
--
END;
/

