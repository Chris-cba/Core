CREATE OR REPLACE TRIGGER nm_type_inclusion_excl
 BEFORE INSERT
  OR UPDATE OF nti_nw_parent_type
 ON nm_type_inclusion
 FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_type_inclusion_excl.trg	1.1 09/17/01
--       Module Name      : nm_type_inclusion_excl.trg
--       Date into SCCS   : 01/09/17 15:58:30
--       Date fetched Out : 07/06/13 17:03:39
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   CURSOR cs_ngt (c_nt_type nm_type_inclusion.nti_nw_parent_type%TYPE) IS
   SELECT 1
    FROM  nm_group_types
   WHERE  ngt_nt_type         = c_nt_type
    AND   ngt_exclusive_flag != 'Y';
   l_dummy BINARY_INTEGER;
--
BEGIN
--
   OPEN  cs_ngt (:NEW.nti_nw_parent_type);
   FETCH cs_ngt INTO l_dummy;
   IF cs_ngt%FOUND
    THEN
      CLOSE cs_ngt;
      RAISE_APPLICATION_ERROR(-20052,'Non-exclusive group types cannot be a parent inclusion type');
   END IF;
   CLOSE cs_ngt;
--
END nm_type_inclusion_excl;
/
