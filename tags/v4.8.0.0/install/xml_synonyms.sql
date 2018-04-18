--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/xml_synonyms.sql-arc   3.2   Apr 18 2018 16:09:58   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   xml_synonyms.sql  $
--       Date into PVCS   : $Date:   Apr 18 2018 16:09:58  $
--       Date fetched Out : $Modtime:   Apr 18 2018 16:02:12  $
--       Version          : $Revision:   3.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
--
SET define ON

SET feedback OFF

prompt CREATE PUBLIC SYNONYM xmldom;

DECLARE
  used_by_existing_obj Exception;
  Pragma Exception_Init(used_by_existing_obj, -955); 
BEGIN
  EXECUTE IMMEDIATE 'create public synonym xmldom for sys.xmldom';
  NULL;
EXCEPTION
WHEN used_by_existing_obj
THEN 
  Null;
END;
/

prompt CREATE PUBLIC SYNONYM xmlparser;

DECLARE
  used_by_existing_obj Exception;
  Pragma Exception_Init(used_by_existing_obj, -955); 
BEGIN
  EXECUTE IMMEDIATE 'create public synonym xmlparser for sys.xmlparser';
  NULL;
EXCEPTION
WHEN used_by_existing_obj
THEN 
  Null;
END;
/

prompt CREATE PUBLIC SYNONYM xslprocessor;

DECLARE
  used_by_existing_obj Exception;
  Pragma Exception_Init(used_by_existing_obj, -955); 
BEGIN
  EXECUTE IMMEDIATE 'create public synonym xslprocessor for sys.xslprocessor';
  NULL;
EXCEPTION
WHEN used_by_existing_obj
THEN 
  Null;
END;
/
