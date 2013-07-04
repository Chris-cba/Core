CREATE OR REPLACE TRIGGER nm_admin_units_all_br
BEFORE DELETE OR INSERT OR UPDATE
ON NM_ADMIN_UNITS_ALL
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW

-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_admin_units_all_br.trg	1.3 11/24/05
--       Module Name      : nm_admin_units_all_br.trg
--       Date into SCCS   : 05/11/24 09:24:36
--       Date fetched Out : 07/06/13 17:02:38
--       SCCS Version     : 1.3
--
--
--   Author : Graeme Johnson
--
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

DECLARE

 l_nau_rec_old nm_admin_units_all%ROWTYPE;
 l_nau_rec_new nm_admin_units_all%ROWTYPE;
 l_index   PLS_INTEGER := nm3api_admin_unit.g_tab_nau_new.COUNT+1;

BEGIN


  l_nau_rec_old.NAU_ADMIN_UNIT       := :OLD.NAU_ADMIN_UNIT;
  l_nau_rec_old.NAU_UNIT_CODE        := :OLD.NAU_UNIT_CODE;
  l_nau_rec_old.NAU_LEVEL            := :OLD.NAU_LEVEL;
  l_nau_rec_old.NAU_AUTHORITY_CODE   := :OLD.NAU_AUTHORITY_CODE;
  l_nau_rec_old.NAU_NAME             := :OLD.NAU_NAME;
  l_nau_rec_old.NAU_ADDRESS1         := :OLD.NAU_ADDRESS1;
  l_nau_rec_old.NAU_ADDRESS2         := :OLD.NAU_ADDRESS2;
  l_nau_rec_old.NAU_ADDRESS3         := :OLD.NAU_ADDRESS3;
  l_nau_rec_old.NAU_ADDRESS4         := :OLD.NAU_ADDRESS4;
  l_nau_rec_old.NAU_ADDRESS5         := :OLD.NAU_ADDRESS5;
  l_nau_rec_old.NAU_POSTCODE         := :OLD.NAU_POSTCODE;
  l_nau_rec_old.NAU_PHONE            := :OLD.NAU_PHONE;
  l_nau_rec_old.NAU_FAX              := :OLD.NAU_FAX;
  l_nau_rec_old.NAU_START_DATE       := :OLD.NAU_START_DATE;
  l_nau_rec_old.NAU_END_DATE         := :OLD.NAU_END_DATE;
  l_nau_rec_old.NAU_ADMIN_TYPE       := :OLD.NAU_ADMIN_TYPE;
  l_nau_rec_old.NAU_NSTY_SUB_TYPE    := :OLD.NAU_NSTY_SUB_TYPE;
  l_nau_rec_old.NAU_PREFIX           := :OLD.NAU_PREFIX;
  l_nau_rec_old.NAU_MINOR_UNDERTAKER := :OLD.NAU_MINOR_UNDERTAKER;
  l_nau_rec_old.NAU_TCPIP            := :OLD.NAU_TCPIP;
  l_nau_rec_old.NAU_DOMAIN           := :OLD.NAU_DOMAIN;
  l_nau_rec_old.NAU_DIRECTORY        := :OLD.NAU_DIRECTORY;

--
-- generate primary key column value from sequence if not specified
--
 IF INSERTING AND :new.nau_admin_unit IS NULL THEN
    :new.nau_admin_unit := nm3seq.next_nau_admin_unit_seq;
 END IF;


  l_nau_rec_new.NAU_ADMIN_UNIT       := :new.NAU_ADMIN_UNIT;
  l_nau_rec_new.NAU_UNIT_CODE        := :new.NAU_UNIT_CODE;
  l_nau_rec_new.NAU_LEVEL            := :new.NAU_LEVEL;
  l_nau_rec_new.NAU_AUTHORITY_CODE   := :new.NAU_AUTHORITY_CODE;
  l_nau_rec_new.NAU_NAME             := :new.NAU_NAME;
  l_nau_rec_new.NAU_ADDRESS1         := :new.NAU_ADDRESS1;
  l_nau_rec_new.NAU_ADDRESS2         := :new.NAU_ADDRESS2;
  l_nau_rec_new.NAU_ADDRESS3         := :new.NAU_ADDRESS3;
  l_nau_rec_new.NAU_ADDRESS4         := :new.NAU_ADDRESS4;
  l_nau_rec_new.NAU_ADDRESS5         := :new.NAU_ADDRESS5;
  l_nau_rec_new.NAU_POSTCODE         := :new.NAU_POSTCODE;
  l_nau_rec_new.NAU_PHONE            := :new.NAU_PHONE;
  l_nau_rec_new.NAU_FAX              := :new.NAU_FAX;
  l_nau_rec_new.NAU_START_DATE       := :new.NAU_START_DATE;
  l_nau_rec_new.NAU_END_DATE         := :new.NAU_END_DATE;
  l_nau_rec_new.NAU_ADMIN_TYPE       := :new.NAU_ADMIN_TYPE;
  l_nau_rec_new.NAU_NSTY_SUB_TYPE    := :new.NAU_NSTY_SUB_TYPE;
  l_nau_rec_new.NAU_PREFIX           := :new.NAU_PREFIX;
  l_nau_rec_new.NAU_MINOR_UNDERTAKER := :new.NAU_MINOR_UNDERTAKER;
  l_nau_rec_new.NAU_TCPIP            := :new.NAU_TCPIP;
  l_nau_rec_new.NAU_DOMAIN           := :new.NAU_DOMAIN;
  l_nau_rec_new.NAU_DIRECTORY        := :new.NAU_DIRECTORY;

  nm3api_admin_unit.g_tab_nau_old(l_index) := l_nau_rec_old;
  nm3api_admin_unit.g_tab_nau_new(l_index) := l_nau_rec_new;

  IF INSERTING THEN
    nm3api_admin_unit.g_tab_nau_actions(l_index) := 'I';
  ELSIF UPDATING THEN
    nm3api_admin_unit.g_tab_nau_actions(l_index) := 'U';
  ELSIF DELETING THEN
    nm3api_admin_unit.g_tab_nau_actions(l_index) := 'D';
  END IF;
  	   	
END nm_admin_units_all_br;
/
