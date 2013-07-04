CREATE OR REPLACE TRIGGER nm_inv_type_groupings_a_ins
       after   insert
       on      nm_inv_type_groupings_all
       for     each row
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_type_groupings.trg	1.1 03/01/01
--       Module Name      : nm_inv_type_groupings.trg
--       Date into SCCS   : 01/03/01 16:24:43
--       Date fetched Out : 07/06/13 17:03:05
--       SCCS Version     : 1.1
--
--       TRIGGER nm_inv_type_groupings_a_ins
--       after   insert
--       on      nm_inv_type_groupings_all
--       for     each row
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
   l_rec_itg nm_inv_type_groupings%ROWTYPE;
BEGIN
--
   l_rec_itg.itg_inv_type        := :NEW.itg_inv_type;
   l_rec_itg.itg_parent_inv_type := :NEW.itg_parent_inv_type;
   l_rec_itg.itg_mandatory       := :NEW.itg_mandatory;
   l_rec_itg.itg_relation        := :NEW.itg_relation;
   l_rec_itg.itg_start_date      := :NEW.itg_start_date;
   l_rec_itg.itg_end_date        := :NEW.itg_end_date;
--
   nm3invval.validate_itg(l_rec_itg);
--
END nm_inv_type_groupings_a_ins;
/
