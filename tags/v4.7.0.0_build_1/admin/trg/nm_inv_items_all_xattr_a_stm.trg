CREATE OR REPLACE TRIGGER nm_inv_items_all_xattr_a_stm
 AFTER INSERT
  OR UPDATE
 ON NM_INV_ITEMS_ALL
DECLARE
--   SCCS Identifiers :-
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_items_all_xattr_a_stm.trg	1.5 03/26/02
--       Module Name      : nm_inv_items_all_xattr_a_stm.trg
--       Date into SCCS   : 02/03/26 11:10:36
--       Date fetched Out : 07/06/13 17:02:58
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

  if nm3inv_xattr.g_xattr_active then
    nm3inv_xattr.process_item_xattr;
  end if;

--
END nm_inv_items_all_xattr_a_stm;
/
