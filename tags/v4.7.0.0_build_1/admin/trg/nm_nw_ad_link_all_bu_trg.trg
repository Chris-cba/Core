CREATE OR REPLACE TRIGGER nm_nw_ad_link_all_bu_trg
       BEFORE  UPDATE
       ON      nm_nw_ad_link_all
       FOR     EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_nw_ad_link_all_bu_trg.trg	1.1 07/18/06
--       Module Name      : nm_nw_ad_link_all_bu_trg.trg
--       Date into SCCS   : 06/07/18 15:38:19
--       Date fetched Out : 07/06/13 17:03:29
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
BEGIN
--
   IF :OLD.nad_end_date IS NULL AND :NEW.nad_end_date IS NOT NULL THEN

         -- cascade the end dating of the link down to the inv item
         UPDATE nm_inv_items_all
          SET   iit_end_date   = :NEW.nad_end_date
         WHERE  iit_ne_id      = :OLD.nad_iit_ne_id
		 AND    iit_end_date IS NULL; 

   END IF;
   --
--
END nm_nw_ad_link_all_bu_trg;
/

