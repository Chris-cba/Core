CREATE OR REPLACE function get_search_group_no ( p_gty in nm_group_types_all.ngt_group_type%TYPE ) return number is
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)get_search_group_no.fnc	1.1 09/03/03
--       Module Name      : get_search_group_no.fnc
--       Date into SCCS   : 03/09/03 14:38:49
--       Date fetched Out : 07/06/13 14:10:12
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--   Originally taken from 
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
ngt_row nm_group_types%rowtype;

begin

  ngt_row := nm3get.get_ngt( p_gty );
  return ngt_row.ngt_search_group_no;
end;
/
