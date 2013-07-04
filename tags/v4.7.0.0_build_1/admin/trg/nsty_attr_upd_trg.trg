CREATE OR REPLACE TRIGGER nsty_attr_upd_trg
BEFORE UPDATE
ON NM_AU_SUB_TYPES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nsty_attr_upd_trg.trg	1.1 04/21/05
--       Module Name      : nsty_attr_upd_trg.trg
--       Date into SCCS   : 05/04/21 11:15:53
--       Date fetched Out : 07/06/13 17:03:50
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
-- NSTY_NAT_ADMIN_TYPE
--
IF :NEW.NSTY_NAT_ADMIN_TYPE IS NOT NULL THEN
   IF   (:OLD.NSTY_NAT_ADMIN_TYPE IS NOT NULL AND :OLD.NSTY_NAT_ADMIN_TYPE != :NEW.NSTY_NAT_ADMIN_TYPE)
     OR (:OLD.NSTY_NAT_ADMIN_TYPE IS NULL)
   THEN
      l_column_label := 'Admin Type';
      RAISE ex_attribute_cannot_be_updated;
   END IF;
ELSE
   IF :OLD.NSTY_NAT_ADMIN_TYPE IS NOT NULL THEN
      l_column_label := 'Admin Type';
      RAISE ex_attribute_cannot_be_updated;
   END IF;
END IF;
 
 
--
-- NSTY_NGT_GROUP_TYPE
-- Update allowed but only if null
--
IF :NEW.NSTY_NGT_GROUP_TYPE IS NOT NULL THEN
   IF   (:OLD.NSTY_NGT_GROUP_TYPE IS NOT NULL AND :OLD.NSTY_NGT_GROUP_TYPE != :NEW.NSTY_NGT_GROUP_TYPE)
   THEN
      l_column_label := 'Group Type';
      RAISE ex_attribute_cannot_be_updated;
   END IF;
ELSE
   IF :OLD.NSTY_NGT_GROUP_TYPE IS NOT NULL THEN
      l_column_label := 'Group Type';
      RAISE ex_attribute_cannot_be_updated;
   END IF;
END IF;
 
 
--
-- NSTY_PARENT_SUB_TYPE
--
IF :NEW.NSTY_PARENT_SUB_TYPE IS NOT NULL THEN
   IF   (:OLD.NSTY_PARENT_SUB_TYPE IS NOT NULL AND :OLD.NSTY_PARENT_SUB_TYPE != :NEW.NSTY_PARENT_SUB_TYPE)
     OR (:OLD.NSTY_PARENT_SUB_TYPE IS NULL)
   THEN
      l_column_label := 'Parent Sub-Type';
      RAISE ex_attribute_cannot_be_updated;
   END IF;
ELSE
   IF :OLD.NSTY_PARENT_SUB_TYPE IS NOT NULL THEN
      l_column_label := 'Parent Sub-Type';
      RAISE ex_attribute_cannot_be_updated;
   END IF;
END IF;
 
 
--
-- NSTY_SUB_TYPE
--
IF :NEW.NSTY_SUB_TYPE IS NOT NULL THEN
   IF   (:OLD.NSTY_SUB_TYPE IS NOT NULL AND :OLD.NSTY_SUB_TYPE != :NEW.NSTY_SUB_TYPE)
     OR (:OLD.NSTY_SUB_TYPE IS NULL)
   THEN
      l_column_label := 'Sub-Type';
      RAISE ex_attribute_cannot_be_updated;
   END IF;
ELSE
   IF :OLD.NSTY_SUB_TYPE IS NOT NULL THEN
      l_column_label := 'Sub-Type';
      RAISE ex_attribute_cannot_be_updated;
   END IF;
END IF;
 
 
EXCEPTION
 WHEN ex_attribute_cannot_be_updated THEN
      hig.raise_ner(pi_appl               => nm3type.c_net
                   ,pi_id                 => 338
                   ,pi_supplementary_info => chr(10)||'['||l_column_label||']');
END nsty_attr_upd_trg;
/
