CREATE OR REPLACE TRIGGER nm_inv_type_attribs_excl_trg
 BEFORE INSERT
  OR UPDATE OF ita_exclusive
  ON NM_INV_TYPE_ATTRIBS_ALL
  FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_type_attribs_excl_trg.trg	1.1 04/25/02
--       Module Name      : nm_inv_type_attribs_excl_trg.trg
--       Date into SCCS   : 02/04/25 08:56:36
--       Date fetched Out : 07/06/13 17:03:04
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
--
   IF :NEW.ita_exclusive = 'Y'
    THEN
      IF nm3inv.get_inv_type(:NEW.ita_inv_type).nit_exclusive != :NEW.ita_exclusive
       THEN
         hig.raise_ner (nm3type.c_net
                       ,225
                       );
      END IF;
   END IF;
--
END nm_inv_type_attribs_excl_trg;
/
