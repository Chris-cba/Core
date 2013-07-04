CREATE OR REPLACE TRIGGER nm_group_inv_link_all_biu_trg
   BEFORE INSERT OR UPDATE ON nm_group_inv_link_all
FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_group_inv_link_all_biu_trg.trg	1.1 10/15/03
--       Module Name      : nm_group_inv_link_all_biu_trg.trg
--       Date into SCCS   : 03/10/15 14:58:58
--       Date fetched Out : 07/06/13 17:02:46
--       SCCS Version     : 1.1
--
--
--   Author : Kevin Angus
--
--    nm_group_inv_link_all_biu_trg
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
  nm3group_inv.check_link_types(pi_ne_ne_id  => :NEW.ngil_ne_ne_id
                               ,pi_iit_ne_id => :NEW.ngil_iit_ne_id);

END nm_group_inv_link_all_biu_trg;
/

