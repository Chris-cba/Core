--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/ctx/create_context.sql-arc   2.1   Nov 13 2009 11:24:10   aedwards  $
--       Module Name      : $Workfile:   create_context.sql  $
--       Date into SCCS   : $Date:   Nov 13 2009 11:24:10  $
--       Date fetched Out : $Modtime:   Nov 13 2009 11:23:08  $
--       SCCS Version     : $Revision:   2.1  $
BEGIN
  -- Create the context in a bit of dynamic sql to allow the context
  -- to be created with the username as part of the context name
  -- This should only be run as the highways owner
  EXECUTE IMMEDIATE 'CREATE OR REPLACE CONTEXT nm3_'||SUBSTR(USER,1,26)||' USING nm3context';
END;
/
