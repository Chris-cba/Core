-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/utl/ntifix.sql-arc   3.3   Apr 13 2018 12:53:22   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   ntifix.sql  $
--       Date into PVCS   : $Date:   Apr 13 2018 12:53:22  $
--       Date fetched Out : $Modtime:   Apr 13 2018 12:51:54  $
--       Version          : $Revision:   3.3  $
--
--       Author: Chris Strettle 
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
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
