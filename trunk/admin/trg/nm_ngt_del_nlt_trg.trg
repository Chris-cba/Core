CREATE OR REPLACE TRIGGER nm_ngt_del_nlt_trg
 AFTER DELETE
 ON NM_GROUP_TYPES_ALL
 FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_ngt_del_nlt_trg.trg	1.2 02/01/06
--       Module Name      : nm_ngt_del_nlt_trg.trg
--       Date into SCCS   : 06/02/01 10:47:39
--       Date fetched Out : 07/06/13 17:03:25
--       SCCS Version     : 1.2
--
--
--   Author : Adrian Edwards
--
--   Remove NM_LINEAR_TYPES record trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
-- Body of trigger removed, duplication of cascade constraint that was
-- causing mutating table error, see 703686 (FF)
-- Trigger should not be shipped but body removed in case it is shipped
-- in error
BEGIN
--
  null ;
   END IF;
--
END nm_ngt_del_nlt_trg;
/
