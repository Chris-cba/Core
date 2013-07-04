CREATE OR REPLACE TRIGGER nm_elements_all_a_u_trg
   AFTER UPDATE OF ne_end_date ON nm_elements_all
FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_elements_all_a_u_trg.trg	1.4 01/18/05
--       Module Name      : nm_elements_all_a_u_trg.trg
--       Date into SCCS   : 05/01/18 15:26:17
--       Date fetched Out : 07/06/13 17:02:42
--       SCCS Version     : 1.4
--
--
--    nm_elements_all_a_u_trg
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

  l_old_end_date date := :OLD.ne_end_date;
  l_new_end_date date := :NEW.ne_end_date;

BEGIN

   IF l_new_end_date IS NOT NULL
      AND (l_old_end_date IS NULL
      OR l_old_end_date <> l_new_end_date)

   THEN

    nm3nwad.end_date_linked_inv(pi_ne_id            => :NEW.ne_id
                               ,pi_nt_type          => :NEW.ne_nt_type
                               ,pi_group_type       => :NEW.ne_gty_group_type
                               ,pi_end_date         => l_new_end_date
                               ,pi_raise_if_no_link => FALSE);

  END IF;

END nm_elements_all_a_u_trg;
/

