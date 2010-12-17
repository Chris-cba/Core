--<PACKAGE>
-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/utl/ntifix.sql-arc   3.0   Dec 17 2010 14:23:38   Mike.Alexander  $
--       Module Name      : $Workfile:   ntifix.sql  $
--       Date into PVCS   : $Date:   Dec 17 2010 14:23:38  $
--       Date fetched Out : $Modtime:   Dec 17 2010 14:23:14  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version : 
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
----</PACKAGE>
--<GLOBVAR>
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
