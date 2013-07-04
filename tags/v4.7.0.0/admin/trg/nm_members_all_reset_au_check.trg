CREATE OR REPLACE TRIGGER NM_MEMBERS_ALL_RESET_AU_CHECK
 BEFORE INSERT OR UPDATE ON nm_members_all
BEGIN
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_members_all_reset_au_check.trg	1.1 04/17/01
--       Module Name      : nm_members_all_reset_au_check.trg
--       Date into SCCS   : 01/04/17 13:53:10
--       Date fetched Out : 07/06/13 17:03:21
--       SCCS Version     : 1.1
--
--    TRIGGER NM_MEMBERS_ALL_RESET_AU_CHECK
--     BEFORE INSERT OR UPDATE ON nm_members_all
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
--  dbms_output.put_line( 'Reset index - before statement' );
   nm3ausec.clear_nm_au_security_temp;
END NM_MEMBERS_ALL_RESET_AU_CHECK;
/
