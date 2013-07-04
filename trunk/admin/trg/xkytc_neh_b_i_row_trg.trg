CREATE OR REPLACE TRIGGER xkytc_neh_b_i_row_trg
   BEFORE INSERT
   ON nm_element_history
   FOR EACH ROW
   WHEN (NEW.neh_operation IN ('S' -- Split
                              ,'N' -- Reclassify
                              ,'M' -- Merge
                              ,'R' -- Replace
                              )
        )
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xkytc_neh_b_i_row_trg.trg	1.1 02/02/04
--       Module Name      : xkytc_neh_b_i_row_trg.trg
--       Date into SCCS   : 04/02/02 16:31:39
--       Date fetched Out : 07/06/13 17:03:56
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   Kentucky Create Securing inventory trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_ne_id nm_elements.ne_id%TYPE;
--
BEGIN
   IF :NEW.neh_operation = 'R'
    THEN -- Because of the strucure of REPLACE i need to end-date all the NEW one's that've
         -- just been created by the trigger
      l_ne_id := :NEW.neh_ne_id_new;
   ELSE
      l_ne_id := :NEW.neh_ne_id_old;
   END IF;
   xkytc_create_securing_inv.end_date_securing_inv (pi_ne_id          => l_ne_id
                                                   ,pi_effective_date => :NEW.neh_effective_date
                                                   );
END xkytc_neh_b_i_row_trg;
/
