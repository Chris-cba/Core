CREATE OR REPLACE TRIGGER nm_group_types_excl_nti
 BEFORE INSERT
  OR UPDATE OF ngt_exclusive_flag, ngt_nt_type
 ON nm_group_types_all
 FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_group_types_excl_nti.trg	1.1 09/17/01
--       Module Name      : nm_group_types_excl_nti.trg
--       Date into SCCS   : 01/09/17 15:58:13
--       Date fetched Out : 07/06/13 17:02:49
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   CURSOR cs_nti (c_nt_type nm_type_inclusion.nti_nw_parent_type%TYPE) IS
   SELECT 1
    FROM  nm_type_inclusion
   WHERE  nti_nw_parent_type = c_nt_type;
   l_dummy BINARY_INTEGER;
--
BEGIN
--
   IF :NEW.ngt_exclusive_flag != 'Y'
    THEN
      OPEN  cs_nti (:NEW.ngt_nt_type);
      FETCH cs_nti INTO l_dummy;
      IF cs_nti%FOUND
       THEN
         CLOSE cs_nti;
         RAISE_APPLICATION_ERROR(-20052,'Non-exclusive group types cannot be a parent inclusion type');
      END IF;
      CLOSE cs_nti;
   END IF;
--
END nm_group_types_excl_nti;
/
