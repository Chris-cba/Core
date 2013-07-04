--   SCCS Identifiers :-
--
--       sccsid           : @(#)group_chunk_no_seq.fnc	1.1 02/01/07
--       Module Name      : group_chunk_no_seq.fnc
--       Date into SCCS   : 07/02/01 15:48:12
--       Date fetched Out : 07/06/13 14:10:15
--       SCCS Version     : 1.1
--
--
--   Author : Priidu Tanava
--
--   A custom aggregate function used in route connectivity sql
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

-- note that this function must not be parallel enabled
create or replace function group_chunk_no_seq(input varchar2) return varchar2
aggregate using nm_analytic_chunk_type;
/
