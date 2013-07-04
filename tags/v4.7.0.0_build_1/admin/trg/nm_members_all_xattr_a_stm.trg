CREATE OR REPLACE TRIGGER nm_members_all_xattr_a_stm
 AFTER INSERT
  OR UPDATE
 ON NM_MEMBERS_ALL
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_members_all_xattr_a_stm.trg	1.4 03/26/02
--       Module Name      : nm_members_all_xattr_a_stm.trg
--       Date into SCCS   : 02/03/26 11:11:03
--       Date fetched Out : 07/06/13 17:03:22
--       SCCS Version     : 1.4
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

   if nm3inv_xattr.g_xattr_active then
     nm3inv_xattr.process_xattr;
   end if;

END nm_members_all_xattr_a_stm;
/
