--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/metadata_upg.sql-arc   2.1   Jul 04 2013 13:46:36   James.Wadsworth  $
--       Module Name      : $Workfile:   metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:46:36  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:27:28  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
REM SCCS ID Keyword, do no remove
define sccsid = '@(#)metadata_upg.sql	1.1 04/04/01';
--
--nm_errors
--
INSERT INTO NM_ERRORS ( NER_APPL, NER_ID, NER_HER_NO, NER_DESCR ) VALUES (
'NET', 61, NULL, 'Attribute has already been used for this inventory type.');
--
INSERT INTO NM_ERRORS ( NER_APPL, NER_ID, NER_HER_NO, NER_DESCR ) VALUES ( 
'HIG', 79, NULL, 'Cannot create synonym - object does not exist in schema.'); 
INSERT INTO NM_ERRORS ( NER_APPL, NER_ID, NER_HER_NO, NER_DESCR ) VALUES ( 
'HIG', 80, NULL, 'User does not exist in HIG_USERS.'); 
INSERT INTO NM_ERRORS ( NER_APPL, NER_ID, NER_HER_NO, NER_DESCR ) VALUES ( 
'HIG', 81, NULL, 'User does not have permission to create synonym.'); 
INSERT INTO NM_ERRORS ( NER_APPL, NER_ID, NER_HER_NO, NER_DESCR ) VALUES ( 
'HIG', 82, NULL, 'Application configured to run using PUBLIC synonyms - not creating PRIVATE synonyms.'); 
INSERT INTO NM_ERRORS ( NER_APPL, NER_ID, NER_HER_NO, NER_DESCR ) VALUES ( 
'HIG', 83, NULL, 'Error occurred executing sql'); 
INSERT INTO NM_ERRORS ( NER_APPL, NER_ID, NER_HER_NO, NER_DESCR ) VALUES ( 
'HIG', 84, NULL, 'Function name not found in function text'); 
--
UPDATE NM_ERRORS
SET NER_DESCR = 'A domain required for this screen is not present which may cause it to funciton incorrectly or not at all.'
WHERE NER_APPL = 'HIG'
AND NER_ID = 62;
--
--hig_modules
--
INSERT INTO HIG_MODULES ( HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS,
HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU ) VALUES ( 
'NM1200', 'SLK Calculator', 'nm1200', 'FMX', NULL, 'N', 'N', 'NET', 'FORM');
INSERT INTO HIG_MODULES ( HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS,
HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU ) VALUES ( 
'NM0520', 'Inventory Location History', 'nm0520', 'FMX', NULL, 'Y', 'N', 'NET', 'FORM');
--
--hig_module_roles
--
INSERT INTO HIG_MODULE_ROLES ( HMR_MODULE, HMR_ROLE, HMR_MODE ) VALUES ( 
'NM0520', 'NET_USER', 'NORMAL'); 
INSERT INTO HIG_MODULE_ROLES ( HMR_MODULE, HMR_ROLE, HMR_MODE ) VALUES ( 
'NM1200', 'NET_USER', 'NORMAL'); 
