-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/utl/ntifix.sql-arc   3.1   Dec 20 2010 11:23:54   Chris.Strettle  $
--       Module Name      : $Workfile:   ntifix.sql  $
--       Date into PVCS   : $Date:   Dec 20 2010 11:23:54  $
--       Date fetched Out : $Modtime:   Dec 20 2010 11:23:22  $
--       Version          : $Revision:   3.1  $
--
--       Author: Chris Strettle 
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
DECLARE
   l_exception  EXCEPTION;
   PRAGMA EXCEPTION_INIT(l_exception,-02443);
--
BEGIN
--
EXECUTE IMMEDIATE 'ALTER TABLE NM_TYPE_INCLUSION DROP CONSTRAINT NTI_PARENT_TYPE_UK  DROP INDEX';
--
EXCEPTION 
WHEN l_exception THEN
    NULL;
WHEN OTHERS THEN
    RAISE;
END;
/
