CREATE OR REPLACE TRIGGER nm_themes_all_b_iu_trg
   BEFORE INSERT OR UPDATE OR DELETE
   ON NM_THEMES_ALL
   FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_themes_all_b_iu_trg.trg-arc   2.5   Apr 13 2018 11:06:40   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm_themes_all_b_iu_trg.trg  $
--       Date into SCCS   : $Date:   Apr 13 2018 11:06:40  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:01:50  $
--       SCCS Version     : $Revision:   2.5  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
  c_str      nm3type.max_varchar2;
  l_mode     VARCHAR2(10);
--
BEGIN
--
   IF DELETING THEN
     IF :OLD.nth_theme_type = nm3sdo.c_sdo
      THEN
       c_str := 'begin '||
                  'nm3sdo.drop_sub_layer_by_table( '||
                     nm3flx.string(:old.nth_feature_table)||','||
                     nm3flx.string(:old.nth_feature_shape_column)||');'
             ||' end;';
       EXECUTE IMMEDIATE c_str;
     END IF;
   END IF;
--
-- AE: Removed this check - no longer applicable
--   IF :NEW.nth_location_updatable = 'Y'
--    AND higgis.is_product_locatable_from_gis(:NEW.nth_hpr_product) != 'Y'
--    THEN
--      hig.raise_ner (pi_appl               => nm3type.c_hig
--                    ,pi_id                 => 152
--                    ,pi_supplementary_info => :NEW.nth_hpr_product
--                    );
--   END IF;
--
--

--
EXCEPTION
   WHEN OTHERS THEN
      RAISE;
--
END nm_themes_all_b_iu_trg;
/