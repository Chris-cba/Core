BEGIN
  EXECUTE IMMEDIATE 'DROP TRIGGER USER_SDO_MAPS_INS_TRG';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
--
  EXECUTE IMMEDIATE
    'CREATE OR REPLACE TRIGGER '||hig.get_application_owner||'.USER_SDO_MAPS_INS_TRG '||chr(10)||
    '------------------------------------------------------------------------- '||chr(10)||
    '--   PVCS Identifiers :- '||chr(10)||
    '-- '||chr(10)||
    '--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/trg/user_sdo_maps_ins_trg.trg-arc   3.2   Dec 05 2008 12:00:58   aedwards  $ '||chr(10)||
    '--       Module Name      : $Workfile:   user_sdo_maps_ins_trg.trg  $ '||chr(10)||
    '--       Date into PVCS   : $Date:   Dec 05 2008 12:00:58  $ '||chr(10)||
    '--       Date fetched Out : $Modtime:   Dec 05 2008 10:02:36  $ '||chr(10)||
    '--       Version          : $Revision:   3.2  $ '||chr(10)||
    '--       Based on SCCS version : '||chr(10)|| 
    '------------------------------------------------------------------------- '||chr(10)||
    'INSTEAD OF DELETE OR INSERT OR UPDATE '||chr(10)||
    'ON '||hig.get_application_owner||'.USER_SDO_MAPS '||chr(10)|| 
    'REFERENCING NEW AS NEW OLD AS OLD '||chr(10)||
    'FOR EACH ROW '||chr(10)||
    'DECLARE '||chr(10)||
    '   l_rec_usm user_sdo_maps%ROWTYPE; '||chr(10)||
    'BEGIN '||chr(10)||
    '-- '||chr(10)||
    '  IF INSERTING '||chr(10)|| 
    '  THEN '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_usm.name        := :NEW.name; '||chr(10)||
    '    l_rec_usm.description := :NEW.description; '||chr(10)||
    '    l_rec_usm.definition  := :NEW.definition; '||chr(10)|| 
    '  -- '||chr(10)||
    '    nm3msv_sec.do_usm_ins ( pi_username => USER '||chr(10)||
    '                          , pi_rec_usm  => l_rec_usm ); '||chr(10)||
    '  -- '||chr(10)||
    '  ELSIF DELETING '||chr(10)|| 
    '  THEN '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_usm.name        := :OLD.name; '||chr(10)||
    '    l_rec_usm.description := :OLD.description; '||chr(10)||
    '    l_rec_usm.definition  := :OLD.definition; '||chr(10)||
    '  -- '||chr(10)||
    '    nm3msv_sec.do_usm_del ( pi_username => USER '||chr(10)||
    '                          , pi_rec_usm  => l_rec_usm ); '||chr(10)||
    '  -- '||chr(10)||
    '  ELSIF UPDATING '||chr(10)|| 
    '  THEN '||chr(10)||
    '  -- '||chr(10)||
    '    l_rec_usm.name        := NVL (:NEW.name, :OLD.name); '||chr(10)||
    '    l_rec_usm.description := NVL (:NEW.description, :OLD.description); '||chr(10)||
    '    l_rec_usm.definition  := NVL (:NEW.definition, :OLD.definition); '||chr(10)||
    '  -- '||chr(10)||
    '    nm3msv_sec.do_usm_upd ( pi_username => USER '||chr(10)||
    '                          , pi_rec_usm  => l_rec_usm ); '||chr(10)||
    '  -- '||chr(10)||
    '  END IF; '||chr(10)||
    '-- '||chr(10)||
    'END; ';
END;
/

