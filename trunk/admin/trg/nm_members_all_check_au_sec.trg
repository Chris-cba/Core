CREATE OR REPLACE TRIGGER NM_MEMBERS_ALL_CHECK_AU_SEC
 AFTER INSERT OR UPDATE ON NM_MEMBERS_ALL
BEGIN
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_members_all_check_au_sec.trg	1.1 04/17/01
--       Module Name      : nm_members_all_check_au_sec.trg
--       Date into SCCS   : 01/04/17 13:52:58
--       Date fetched Out : 07/06/13 17:03:16
--       SCCS Version     : 1.1
--
--    TRIGGER NM_MEMBERS_ALL_CHECK_AU_SEC
--    AFTER INSERT OR UPDATE ON NM_MEMBERS_ALL
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--  dbms_output.put_line( 'Checking security - after statement');
   nm3ausec.check_each_au;
END NM_MEMBERS_ALL_CHECK_AU_SEC;
/
