CREATE OR REPLACE TRIGGER nm_type_columns_biud_row_trg
   BEFORE INSERT OR UPDATE OR DELETE ON nm_type_columns
FOR EACH ROW

DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_type_columns_biud_row_trg.trg	1.1 10/22/03
--       Module Name      : nm_type_columns_biud_row_trg.trg
--       Date into SCCS   : 03/10/22 19:03:33
--       Date fetched Out : 07/06/13 17:03:38
--       SCCS Version     : 1.1
--
--
--   Author : Kevin Angus
--
--    nm_type_columns_biu_row_trg
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
   
  l_ntc_old_rec nm_type_columns%ROWTYPE;
  l_ntc_new_rec nm_type_columns%ROWTYPE;
  
  l_db_action  varchar2(10);

BEGIN
  l_ntc_old_rec.ntc_nt_type       := :OLD.ntc_nt_type;
  l_ntc_old_rec.ntc_column_name   := :OLD.ntc_column_name;
  l_ntc_old_rec.ntc_column_type   := :OLD.ntc_column_type;
  l_ntc_old_rec.ntc_seq_no        := :OLD.ntc_seq_no;
  l_ntc_old_rec.ntc_displayed     := :OLD.ntc_displayed;
  l_ntc_old_rec.ntc_str_length    := :OLD.ntc_str_length;
  l_ntc_old_rec.ntc_mandatory     := :OLD.ntc_mandatory;
  l_ntc_old_rec.ntc_domain        := :OLD.ntc_domain;
  l_ntc_old_rec.ntc_query         := :OLD.ntc_query;
  l_ntc_old_rec.ntc_inherit       := :OLD.ntc_inherit;
  l_ntc_old_rec.ntc_string_start  := :OLD.ntc_string_start;
  l_ntc_old_rec.ntc_string_end    := :OLD.ntc_string_end;
  l_ntc_old_rec.ntc_seq_name      := :OLD.ntc_seq_name;
  l_ntc_old_rec.ntc_format        := :OLD.ntc_format;
  l_ntc_old_rec.ntc_prompt        := :OLD.ntc_prompt;
  l_ntc_old_rec.ntc_default       := :OLD.ntc_default;
  l_ntc_old_rec.ntc_default_type  := :OLD.ntc_default_type;
  l_ntc_old_rec.ntc_separator     := :OLD.ntc_separator;
  l_ntc_old_rec.ntc_unique_seq    := :OLD.ntc_unique_seq;
  l_ntc_old_rec.ntc_unique_format := :OLD.ntc_unique_format;
  
  l_ntc_new_rec.ntc_nt_type       := :NEW.ntc_nt_type;
  l_ntc_new_rec.ntc_column_name   := :NEW.ntc_column_name;
  l_ntc_new_rec.ntc_column_type   := :NEW.ntc_column_type;
  l_ntc_new_rec.ntc_seq_no        := :NEW.ntc_seq_no;
  l_ntc_new_rec.ntc_displayed     := :NEW.ntc_displayed;
  l_ntc_new_rec.ntc_str_length    := :NEW.ntc_str_length;
  l_ntc_new_rec.ntc_mandatory     := :NEW.ntc_mandatory;
  l_ntc_new_rec.ntc_domain        := :NEW.ntc_domain;
  l_ntc_new_rec.ntc_query         := :NEW.ntc_query;
  l_ntc_new_rec.ntc_inherit       := :NEW.ntc_inherit;
  l_ntc_new_rec.ntc_string_start  := :NEW.ntc_string_start;
  l_ntc_new_rec.ntc_string_end    := :NEW.ntc_string_end;
  l_ntc_new_rec.ntc_seq_name      := :NEW.ntc_seq_name;
  l_ntc_new_rec.ntc_format        := :NEW.ntc_format;
  l_ntc_new_rec.ntc_prompt        := :NEW.ntc_prompt;
  l_ntc_new_rec.ntc_default       := :NEW.ntc_default;
  l_ntc_new_rec.ntc_default_type  := :NEW.ntc_default_type;
  l_ntc_new_rec.ntc_separator     := :NEW.ntc_separator;
  l_ntc_new_rec.ntc_unique_seq    := :NEW.ntc_unique_seq;
  l_ntc_new_rec.ntc_unique_format := :NEW.ntc_unique_format;

  IF UPDATING
  THEN
    l_db_action := nm3type.c_updating;
  
  ELSIF INSERTING
  THEN
    l_db_action := nm3type.c_inserting;
  
  ELSIF DELETING
  THEN
    l_db_action := nm3type.c_deleting;
  END IF;

  nm3nwval.ntc_before_iud_row_trg(pi_ntc_old_rec => l_ntc_old_rec
                                 ,pi_ntc_new_rec => l_ntc_new_rec
                                 ,pi_db_action   => l_db_action);

END nm_type_columns_biud_row_trg;
/
