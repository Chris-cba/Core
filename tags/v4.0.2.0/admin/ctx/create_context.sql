--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/ctx/create_context.sql-arc   2.0   Jun 14 2007 09:25:04   smarshall  $
--       Module Name      : $Workfile:   create_context.sql  $
--       Date into SCCS   : $Date:   Jun 14 2007 09:25:04  $
--       Date fetched Out : $Modtime:   Jun 14 2007 09:24:34  $
--       SCCS Version     : $Revision:   2.0  $
BEGIN
  -- Create the context in a bit of dynamic sql to allow the context
  -- to be created with the username as part of the context name
  -- This should only be run as the highways owner
  EXECUTE IMMEDIATE 'CREATE CONTEXT nm3_'||SUBSTR(USER,1,26)||' USING nm3context';
END;
/
