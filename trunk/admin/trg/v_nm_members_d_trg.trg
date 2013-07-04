CREATE OR REPLACE TRIGGER V_NM_MEMBERS_D_TRG
 INSTEAD OF DELETE
 ON V_NM_MEMBERS
 FOR EACH ROW
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)v_nm_members_d_trg.trg	1.1 01/24/05
--       Module Name      : v_nm_members_d_trg.trg
--       Date into SCCS   : 05/01/24 14:35:51
--       Date fetched Out : 07/06/13 17:03:52
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
 nm3del.del_nm
   ( :NEW.nm_ne_id_in
   , :NEW.nm_ne_id_of
   , :NEW.nm_begin_mp
   , :NEW.nm_start_date);
END;
/
