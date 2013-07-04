--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3004_nm3005_metadata_upg.sql-arc   2.1   Jul 04 2013 14:21:22   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3004_nm3005_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:21:22  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:59:44  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
rem   SCCS Identifiers :-
rem   
rem       sccsid           : @(#)nm3004_nm3005_metadata_upg.sql	1.2 06/05/01
rem       Module Name      : nm3004_nm3005_metadata_upg.sql
rem       Date into SCCS   : 01/06/05 10:43:30
rem       Date fetched Out : 07/06/13 13:57:35
rem       SCCS Version     : 1.2
rem 
rem 
REM SCCS ID Keyword, do no remove
define sccsid = '"@(#)nm3004_nm3005_metadata_upg.sql	1.2 06/05/01"';
--
--nm_errors
--
UPDATE nm_errors
SET ner_descr = 'Please specify sub class.'
WHERE ner_appl = 'NET'
AND ner_id = 82;
--
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 87, NULL, 'Location already designated to another admin type.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 88, NULL, 'Invalid overhang action specified.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 89, NULL, 'Mandatory attribute cannot have a NULL new value.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 90, NULL, 'Supplied new value is invalid.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 91, NULL, 'Attribute specified more than once.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 92, NULL, 'Element is of invalid sub class.'); 
--
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'HIG', 91, NULL, 'Arrays supplied have different numbers of values.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'HIG', 92, NULL, 'All old and new values specified are the same.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'HIG', 93, NULL, ' items updated.');
--
--hig_modules
--
INSERT INTO hig_modules ( hmo_module, hmo_title, hmo_filename, hmo_module_type, hmo_fastpath_opts,
hmo_fastpath_invalid, hmo_use_gri, hmo_application, hmo_menu ) VALUES ( 
'NM0530', 'Global Inventory Update', 'nm0530', 'FMX', NULL, 'N', 'N', 'NET', 'FORM'); 
--
--hig_module_roles
--
INSERT INTO hig_module_roles ( hmr_module, hmr_role, hmr_mode ) VALUES ( 
'NM0530', 'NET_USER', 'NORMAL'); 
--
--hig_module_keywords
--
INSERT INTO hig_module_keywords ( hmk_hmo_module, hmk_keyword,
hmk_owner ) VALUES ( 
'NM0530', 'GLOBAL INVENTORY UPDATE', 1);
--
