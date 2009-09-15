--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/xml_synonyms.sql-arc   3.0   Sep 15 2009 17:10:46   malexander  $
--       Module Name      : $Workfile:   xml_synonyms.sql  $
--       Date into PVCS   : $Date:   Sep 15 2009 17:10:46  $
--       Date fetched Out : $Modtime:   Sep 15 2009 17:04:34  $
--       Version          : $Revision:   3.0  $
--
-------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2009
-------------------------------------------------------------------------
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
