--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/trg/user_sdo_styles_ins_trg.trg-arc   3.3   Jul 04 2013 09:58:54   James.Wadsworth  $
--       Module Name      : $Workfile:   user_sdo_styles_ins_trg.trg  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:58:54  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:58:24  $
--       Version          : $Revision:   3.3  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
  EXECUTE IMMEDIATE 'DROP TRIGGER USER_SDO_STYLES_INS_TRG';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
--
  EXECUTE IMMEDIATE
    'CREATE OR REPLACE TRIGGER '||hig.get_application_owner||'.USER_SDO_STYLES_INS_TRG '||chr(10)||
    '------------------------------------------------------------------------- '||chr(10)||
    '--   PVCS Identifiers :- '||chr(10)||
    '-- '||chr(10)||
    '--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/trg/user_sdo_styles_ins_trg.trg-arc   3.3   Jul 04 2013 09:58:54   James.Wadsworth  $ '||chr(10)||
    '--       Module Name      : $Workfile:   user_sdo_styles_ins_trg.trg  $ '||chr(10)||
    '--       Date into PVCS   : $Date:   Jul 04 2013 09:58:54  $ '||chr(10)||
    '--       Date fetched Out : $Modtime:   Jul 04 2013 09:58:24  $ '||chr(10)||
    '--       Version          : $Revision:   3.3  $ '||chr(10)||
    '--       Based on SCCS version : '||chr(10)|| 
    '------------------------------------------------------------------------- '||chr(10)||
    'INSTEAD OF DELETE OR INSERT OR UPDATE '||chr(10)||
    'ON '||hig.get_application_owner||'.USER_SDO_STYLES REFERENCING NEW AS NEW OLD AS OLD '||chr(10)||
    'FOR EACH ROW '||chr(10)||
    'DECLARE '||chr(10)||
    '  l_rec_uss user_sdo_styles%ROWTYPE; '||chr(10)||
    'BEGIN '||chr(10)||
    '-- '||chr(10)||
    '  IF INSERTING '||chr(10)|| 
    '  THEN '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_uss.name         := :NEW.name; '||chr(10)||
    '    l_rec_uss.type         := :NEW.type; '||chr(10)||
    '    l_rec_uss.description  := :NEW.description; '||chr(10)||
    '    l_rec_uss.definition   := :NEW.definition; '||chr(10)||
    '    l_rec_uss.image        := :NEW.image; '||chr(10)||
    '    l_rec_uss.geometry     := :NEW.geometry; '||chr(10)||
    '  -- '||chr(10)||
    '    nm3msv_sec.do_uss_ins ( pi_username => USER '||chr(10)||
    '                          , pi_rec_uss  => l_rec_uss ); '||chr(10)||
    '  -- '||chr(10)||
    '  ELSIF DELETING '||chr(10)|| 
    '  THEN '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_uss.name         := :OLD.name; '||chr(10)||
    '    l_rec_uss.type         := :OLD.type; '||chr(10)||
    '    l_rec_uss.description  := :OLD.description; '||chr(10)||
    '    l_rec_uss.definition   := :OLD.definition; '||chr(10)||
    '    l_rec_uss.image        := :OLD.image; '||chr(10)||
    '    l_rec_uss.geometry     := :OLD.geometry; '||chr(10)||
    '  -- '||chr(10)||
    '     nm3msv_sec.do_uss_del ( pi_username => USER '||chr(10)||
    '                           , pi_rec_uss  => l_rec_uss ); '||chr(10)|| 
    '  -- '||chr(10)||
    '  ELSIF UPDATING '||chr(10)|| 
    '  THEN '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_uss.name         := NVL (:NEW.name, :OLD.name); '||chr(10)||
    '    l_rec_uss.type         := NVL (:NEW.type, :OLD.type); '||chr(10)||
    '    l_rec_uss.description  := NVL (:NEW.description, :OLD.description); '||chr(10)||
    '    l_rec_uss.definition   := NVL (:NEW.definition, :OLD.definition); '||chr(10)||
    '  -- '||chr(10)||
    '    IF :NEW.image IS NOT NULL '||chr(10)|| 
    '    THEN '||chr(10)||
    '      l_rec_uss.image     :=:NEW.image; '||chr(10)||
    '    ELSE '||chr(10)||
    '      l_rec_uss.image     :=:OLD.image; '||chr(10)||
    '    END IF; '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_uss.geometry := NVL (:NEW.geometry, :OLD.geometry); '||chr(10)||
    '  -- '||chr(10)||
    '    nm3msv_sec.do_uss_upd ( pi_username => USER '||chr(10)||
    '                          , pi_rec_uss  => l_rec_uss ); '||chr(10)||
    '  -- '||chr(10)||
    '  END IF; '||chr(10)||
    '-- '||chr(10)||
    'END; ';
END;
/




