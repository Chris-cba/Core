CREATE OR REPLACE TRIGGER nauall_attr_upd_trg
BEFORE UPDATE
ON NM_ADMIN_UNITS_ALL
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nauall_attr_upd_trg.trg	1.1 04/21/05
--       Module Name      : nauall_attr_upd_trg.trg
--       Date into SCCS   : 05/04/21 10:58:57
--       Date fetched Out : 07/06/13 17:02:37
--       SCCS Version     : 1.1
--
--
--   Generated Trigger to police non-updatable columns
--
--
-----------------------------------------------------------------------------
--
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
--
-----------------------------------------------------------------------------
--
DECLARE
  l_column_label VARCHAR2(50);
  ex_attribute_cannot_be_updated EXCEPTION;
BEGIN
 
 
--
-- NAU_NSTY_SUB_TYPE
-- Update allowed but only if null
--
IF :NEW.NAU_NSTY_SUB_TYPE IS NOT NULL THEN
   IF   (:OLD.NAU_NSTY_SUB_TYPE IS NOT NULL AND :OLD.NAU_NSTY_SUB_TYPE != :NEW.NAU_NSTY_SUB_TYPE)
   THEN
      l_column_label := 'Sub-Type';
      RAISE ex_attribute_cannot_be_updated;
   END IF;
ELSE
   IF :OLD.NAU_NSTY_SUB_TYPE IS NOT NULL THEN
      l_column_label := 'Sub-Type';
      RAISE ex_attribute_cannot_be_updated;
   END IF;
END IF;
 
 
EXCEPTION
 WHEN ex_attribute_cannot_be_updated THEN
      hig.raise_ner(pi_appl               => nm3type.c_net
                   ,pi_id                 => 338
                   ,pi_supplementary_info => chr(10)||'['||l_column_label||']');
END nauall_attr_upd_trg;
/
