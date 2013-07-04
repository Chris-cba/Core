CREATE OR REPLACE TRIGGER NM_INV_ITEMS_ALL_AU_VAL
 BEFORE INSERT OR UPDATE
 ON nm_inv_items_all
 FOR EACH ROW
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_items_all_au_val.trg	1.4 05/10/02
--       Module Name      : nm_inv_items_all_au_val.trg
--       Date into SCCS   : 02/05/10 15:59:48
--       Date fetched Out : 07/06/13 17:02:53
--       SCCS Version     : 1.4
--
--   TRIGGER NM_INV_ITEMS_ALL_AU_VAL
--    BEFORE INSERT OR UPDATE
--    ON nm_inv_items_all
--    FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
   l_inv_au_type   nm_au_types.nat_admin_type%TYPE;
   l_au_type       nm_au_types.nat_admin_type%TYPE;
--
BEGIN
--
   IF  INSERTING
    OR :OLD.iit_admin_unit != :NEW.iit_admin_unit
    THEN
      l_inv_au_type := nm3ausec.get_inv_au_type (:NEW.iit_inv_type);
      l_au_type     := nm3ausec.get_au_type     (:NEW.iit_admin_unit);
   --
      IF l_inv_au_type != l_au_type
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 237
                       ,pi_supplementary_info => l_inv_au_type||' != '||l_au_type
                       );
         --raise_application_error(-20901, 'incorrect_au');
      END IF;
   END IF;
--
--   IF   UPDATING
--    AND :NEW.iit_admin_unit != :OLD.iit_admin_unit
--    AND nm3ausec.do_locations_exist( :NEW.iit_ne_id )
--    THEN
--      raise_application_error(-20904, 'You may not update the admin unit');
--   END IF;
--
   IF NOT Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE'
    THEN
--
--    Only bother doing these checks if the user is restricted
--
      IF    UPDATING
       AND  nm3ausec.get_au_mode( Sys_Context('NM3_SECURITY_CTX','USERNAME'), :OLD.iit_admin_unit ) != nm3type.c_normal
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 240
                       ,pi_supplementary_info => nm3ausec.get_unit_code(:OLD.iit_admin_unit)
                       );
--         raise_application_error(-20902, 'You may not change this record');
      ELSIF nm3ausec.get_au_mode( Sys_Context('NM3_SECURITY_CTX','USERNAME'), :NEW.iit_admin_unit ) != nm3type.c_normal
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 241
                       ,pi_supplementary_info => nm3ausec.get_unit_code(:NEW.iit_admin_unit)
                       );
--         raise_application_error(-20903, 'You may not create data with this admin unit');
      END IF;
--
   END IF;
--
END NM_INV_ITEMS_ALL_AU_VAL;
/
