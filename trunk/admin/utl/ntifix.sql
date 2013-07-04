-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/utl/ntifix.sql-arc   3.2   Jul 04 2013 10:30:12   James.Wadsworth  $
--       Module Name      : $Workfile:   ntifix.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 10:30:12  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:17:36  $
--       Version          : $Revision:   3.2  $
--
--       Author: Chris Strettle 
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
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
