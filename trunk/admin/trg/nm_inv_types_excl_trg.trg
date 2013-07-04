CREATE OR REPLACE TRIGGER nm_inv_types_excl_trg
 BEFORE UPDATE OF nit_exclusive
  ON NM_INV_TYPES_ALL
  FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_types_excl_trg.trg	1.1 04/25/02
--       Module Name      : nm_inv_types_excl_trg.trg
--       Date into SCCS   : 02/04/25 08:57:15
--       Date fetched Out : 07/06/13 17:03:09
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
--
   IF   :OLD.nit_exclusive != :NEW.nit_exclusive
    AND :OLD.nit_exclusive  = 'Y'
    THEN
      IF nm3inv.get_tab_ita_exclusive(:NEW.nit_inv_type).COUNT != 0
       THEN
         hig.raise_ner (nm3type.c_net
                       ,226
                       );
      END IF;
   END IF;
--
END nm_inv_types_excl_trg;
/
