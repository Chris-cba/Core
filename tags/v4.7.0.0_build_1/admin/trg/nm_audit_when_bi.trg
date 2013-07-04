CREATE OR REPLACE TRIGGER nm_audit_when_bi
BEFORE INSERT
ON NM_AUDIT_WHEN
FOR EACH ROW
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_audit_when_bi.trg	1.1 01/11/06
--       Module Name      : nm_audit_when_bi.trg
--       Date into SCCS   : 06/01/11 14:52:50
--       Date fetched Out : 07/06/13 17:02:41
--       SCCS Version     : 1.1
--
--
--   Author : Graeme Johnson
--
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN

--
-- Generator PK value
--

  IF :NEW.naw_id IS NULL THEN
   :NEW.naw_id := nm3_tab_naw.next_naw_id_seq;
  END IF;   

END nm_audit_when_bi;
/
