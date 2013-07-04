CREATE OR REPLACE TRIGGER nm_nt_groupings_all_b_row
   BEFORE INSERT OR UPDATE ON nm_nt_groupings_all
FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_nt_groupings_all_b_row.trg	1.1 06/04/03
--       Module Name      : nm_nt_groupings_all_b_row.trg
--       Date into SCCS   : 03/06/04 09:05:27
--       Date fetched Out : 07/06/13 17:03:28
--       SCCS Version     : 1.1
--
--
--   Author : Kevin Angus
--
--    nm_nt_groupings_all_b_row
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

  l_nng_val_rec  nm3nwval.t_nng_val_rec;

BEGIN
  l_nng_val_rec.group_type := :NEW.nng_group_type;
  l_nng_val_rec.nt_type    := :NEW.nng_nt_type;
  
  nm3nwval.pop_nng_tab(pi_nng_val_rec => l_nng_val_rec);

END nm_nt_groupings_all_b_row;
/
