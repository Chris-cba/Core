CREATE OR REPLACE TRIGGER gis_themes_all_b_iu_trg
   BEFORE INSERT OR UPDATE
   ON GIS_THEMES_ALL
   FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)gis_themes_all_b_iu_trg.trg	1.1 08/08/02
--       Module Name      : gis_themes_all_b_iu_trg.trg
--       Date into SCCS   : 02/08/08 14:17:56
--       Date fetched Out : 07/06/13 17:02:29
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   TRIGGER gis_themes_all_b_iu_trg
--      BEFORE INSERT OR UPDATE
--      ON GIS_THEMES_ALL
--      FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
--
   IF   :NEW.gt_location_updatable                                 = 'Y'
    AND higgis.is_product_locatable_from_gis(:NEW.gt_hpr_product) != 'Y'
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 152
                    ,pi_supplementary_info => :NEW.gt_hpr_product
                    );
   END IF;
--
END gis_themes_all_b_iu_trg;
/
