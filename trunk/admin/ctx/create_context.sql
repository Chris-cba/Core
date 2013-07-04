--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/ctx/create_context.sql-arc   2.2   Jul 04 2013 09:23:56   James.Wadsworth  $
--       Module Name      : $Workfile:   create_context.sql  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:23:56  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:22:04  $
--       SCCS Version     : $Revision:   2.2  $
BEGIN
  -- Create the context in a bit of dynamic sql to allow the context
  -- to be created with the username as part of the context name
  -- This should only be run as the highways owner
  EXECUTE IMMEDIATE 'CREATE OR REPLACE CONTEXT nm3_'||SUBSTR(USER,1,26)||' USING nm3context';
END;
/
