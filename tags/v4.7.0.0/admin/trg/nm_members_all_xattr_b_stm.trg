CREATE OR REPLACE TRIGGER nm_members_all_xattr_b_stm
 BEFORE INSERT
  OR UPDATE
 ON NM_MEMBERS_ALL
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_members_all_xattr_b_stm.trg	1.5 03/26/02
--       Module Name      : nm_members_all_xattr_b_stm.trg
--       Date into SCCS   : 02/03/26 11:11:11
--       Date fetched Out : 07/06/13 17:03:23
--       SCCS Version     : 1.5
--
--
--   Author : Rob Coupe
--
--   Xattr Validation trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

BEGIN

--
--

   nm3inv_xattr.clear_loc_xattr;
--
END nm_members_all_xattr_b_stm;
/
