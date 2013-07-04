--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/xml_synonyms.sql-arc   3.1   Jul 04 2013 14:17:18   James.Wadsworth  $
--       Module Name      : $Workfile:   xml_synonyms.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:17:18  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:42:58  $
--       Version          : $Revision:   3.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
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
