--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/trg/user_sdo_themes_ins_trg.trg-arc   3.3   Jul 04 2013 09:58:54   James.Wadsworth  $
--       Module Name      : $Workfile:   user_sdo_themes_ins_trg.trg  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:58:54  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:58:30  $
--       Version          : $Revision:   3.3  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
  EXECUTE IMMEDIATE 'DROP TRIGGER USER_SDO_THEMES_INS_TRG';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
--
  EXECUTE IMMEDIATE
    'CREATE OR REPLACE TRIGGER '||hig.get_application_owner||'.USER_SDO_THEMES_INS_TRG '||chr(10)||
    '-------------------------------------------------------------------------'||chr(10)||
    '--   PVCS Identifiers :-'||chr(10)||
    '-- '||chr(10)||
    '--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/trg/user_sdo_themes_ins_trg.trg-arc   3.3   Jul 04 2013 09:58:54   James.Wadsworth  $'||chr(10)||
    '--       Module Name      : $Workfile:   user_sdo_themes_ins_trg.trg  $'||chr(10)||
    '--       Date into PVCS   : $Date:   Jul 04 2013 09:58:54  $'||chr(10)||
    '--       Date fetched Out : $Modtime:   Jul 04 2013 09:58:30  $'||chr(10)||
    '--       Version          : $Revision:   3.3  $'||chr(10)||
    '--       Based on SCCS version :'|| chr(10)||
    '-------------------------------------------------------------------------'||chr(10)||
    'INSTEAD OF DELETE OR INSERT OR UPDATE '||chr(10)||
    'ON '||hig.get_application_owner||'.USER_SDO_THEMES '||chr(10)|| 
    'REFERENCING NEW AS NEW OLD AS OLD '||chr(10)||
    'FOR EACH ROW '||chr(10)||
    'DECLARE '||chr(10)||
    '   l_rec_ust user_sdo_themes%ROWTYPE; '||chr(10)||
    'BEGIN '||chr(10)||
    '-- '||chr(10)||
    '  IF INSERTING '||chr(10)|| 
    '  THEN '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_ust.name             := :NEW.name; '||chr(10)||
    '    l_rec_ust.description      := :NEW.description; '||chr(10)||
    '    l_rec_ust.base_table       := :NEW.base_table; '||chr(10)||
    '    l_rec_ust.geometry_column  := :NEW.geometry_column; '||chr(10)||
    '    l_rec_ust.styling_rules    := :NEW.styling_rules; '||chr(10)||
    '  -- '||chr(10)||
    '    nm3msv_sec.do_ust_ins ( pi_username => USER '||chr(10)||
    '                          , pi_rec_ust  => l_rec_ust ); '||chr(10)||
    '  -- '||chr(10)||
    '  ELSIF DELETING '||chr(10)|| 
    '  THEN '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_ust.name             := :OLD.name; '||chr(10)||
    '    l_rec_ust.description      := :OLD.description; '||chr(10)||
    '    l_rec_ust.base_table       := :OLD.base_table; '||chr(10)||
    '    l_rec_ust.geometry_column  := :OLD.geometry_column; '||chr(10)||
    '    l_rec_ust.styling_rules    := :OLD.styling_rules; '||chr(10)||
    '  -- '||chr(10)||
    '    nm3msv_sec.do_ust_del ( pi_username => USER '||chr(10)||
    '                          , pi_rec_ust  => l_rec_ust ); '||chr(10)||
    '  -- '||chr(10)||
    '  ELSIF UPDATING '||chr(10)|| 
    '  THEN '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_ust.name             := NVL(:NEW.name, :OLD.name); '||chr(10)||
    '    l_rec_ust.description      := NVL (:NEW.description, :OLD.description); '||chr(10)||
    '    l_rec_ust.base_table       := NVL(:NEW.base_table, :OLD.base_table); '||chr(10)||
    '    l_rec_ust.geometry_column  := NVL(:NEW.geometry_column, :OLD.geometry_column); '||chr(10)||
    '    l_rec_ust.styling_rules    := NVL (:NEW.styling_rules, :OLD.styling_rules); '||chr(10)||
    '  -- '||chr(10)||
    '    nm3msv_sec.do_ust_upd ( pi_username => USER '||chr(10)||
    '                          , pi_rec_ust  => l_rec_ust ); '||chr(10)||
    '  -- '||chr(10)||
    '  END IF; '||chr(10)||
    '-- '||chr(10)||
    'END; ';
END;
/


