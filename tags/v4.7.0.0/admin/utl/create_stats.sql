-----------------------------------------------------------------------------
--
--   SCCS IDENTIFIERS :-
--
-- sccsid : @(#)create_stats.sql	1.1 12/05/06 
-- Module Name : create_stats.sql 
-- Date into SCCS : 06/12/05 15:33:33 
-- Date fetched Out : 07/06/13 17:07:17 
-- SCCS Version : 1.1
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
begin
  dbms_stats.gather_schema_stats(USER);
  if nm3ddl.does_object_exist('SWR_UTILITY','PACKAGE') THEN
    execute immediate('swr_utility.delete_table_stats');
  end if;
end;
/
