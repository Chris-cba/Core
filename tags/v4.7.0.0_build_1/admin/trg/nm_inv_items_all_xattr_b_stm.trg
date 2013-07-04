CREATE OR REPLACE TRIGGER nm_inv_items_all_xattr_b_stm
 BEFORE INSERT
  OR UPDATE
 ON NM_INV_ITEMS_ALL
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_items_all_xattr_b_stm.trg	1.5 03/26/02
--       Module Name      : nm_inv_items_all_xattr_b_stm.trg
--       Date into SCCS   : 02/03/26 11:10:47
--       Date fetched Out : 07/06/13 17:02:59
--       SCCS Version     : 1.5
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

   nm3inv_xattr.clear_inv_xattr;
--
END nm_inv_items_all_xattr_b_stm;
/
