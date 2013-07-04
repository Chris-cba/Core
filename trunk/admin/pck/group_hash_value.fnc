--   SCCS Identifiers :-
--
--       sccsid           : @(#)group_hash_value.fnc	1.1 02/01/07
--       Module Name      : group_hash_value.fnc
--       Date into SCCS   : 07/02/01 16:24:14
--       Date fetched Out : 07/06/13 14:10:16
--       SCCS Version     : 1.1
--
--   Author : Priidu Tanava
--
--   A custom aggregate function used in route bulk merge sql
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------


-- note that this function must not be parallel enabled
create or replace function group_hash_value(input varchar2) return varchar2
aggregate using nm_analytic_hash_type;
/
