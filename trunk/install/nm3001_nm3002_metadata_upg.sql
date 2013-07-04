--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3001_nm3002_metadata_upg.sql-arc   2.1   Jul 04 2013 14:21:22   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3001_nm3002_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:21:22  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:59:32  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
rem   SCCS Identifiers :-
rem   
rem       sccsid           : @(#)nm3001_nm3002_metadata_upg.sql	1.10 04/19/01
rem       Module Name      : nm3001_nm3002_metadata_upg.sql
rem       Date into SCCS   : 01/04/19 15:28:02
rem       Date fetched Out : 07/06/13 13:57:33 
rem       SCCS Version     : 1.10
rem
rem
REM SCCS ID Keyword, do no remove
define sccsid = '@(#)nm3001_nm3002_metadata_upg.sql	1.10 04/19/01';
--
--nm_errors
--
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES (
'NET', 61, NULL, 'Attribute has already been used for this inventory type.');
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 62, NULL, 'Some elements in this extent are not valid for the current effective date.' || CHR(10) || CHR(10) || 'This may give unpredicted results. You may wish to change the effective date using preferences.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 63, NULL, 'Cannot rescale and maintain history when group members have a start date of today or in the future.' || CHR(10) || CHR(10) || 'Would you like to rescale without maintaining history?'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 64, NULL, 'XSP reversal rules not found.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 65, NULL, 'Cannot allocate segment number.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 66, NULL, 'Cannot allocate sequence number.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 67, NULL, 'Cannot calculate new true distance.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 68, NULL, 'Cannot calculate new SLK.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 69, NULL, 'Cannot find length of rescaled element.');
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 70, NULL, 'Band has minimum value greater than maximum value.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 71, NULL, 'Bands have overlapping values.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 72, NULL, 'Banding has gaps.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 73, NULL, 'Attribute format is not valid for banding.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 74, NULL, 'Values are specified for bands to a greater precision than the attribute allows.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 75, NULL, 'Banding is valid.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 76, NULL, 'Banding to be copied is of a different format to this attribute.');
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 77, NULL, 'Location of this item is mandatory and it is not currently located.');
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'NET', 78, NULL, 'Could not calculate Distance Error between nodes for sub-class.'); 
--
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'HIG', 79, NULL, 'Cannot create synonym - object does not exist in schema.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'HIG', 80, NULL, 'User does not exist in HIG_USERS.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'HIG', 81, NULL, 'User does not have permission to create synonym.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'HIG', 82, NULL, 'Application configured to run using PUBLIC synonyms - not creating PRIVATE synonyms.'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'HIG', 83, NULL, 'Error occurred executing sql'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'HIG', 84, NULL, 'Function name not found in function text'); 
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'HIG', 85, NULL, 'Update not allowed.');
INSERT INTO nm_errors ( ner_appl, ner_id, ner_her_no, ner_descr ) VALUES ( 
'HIG', 86, NULL, 'You do not have permission to perform this action.'); 
--
UPDATE nm_errors
SET ner_descr = 'A domain required for this screen is not present which may cause it to funciton incorrectly or not at all.'
WHERE ner_appl = 'HIG'
AND ner_id = 62;
UPDATE nm_errors
SET ner_descr = 'GIS shape in place, network editing function not allowed.'
WHERE ner_appl = 'HIG'
AND ner_id = 65;
--
--hig_modules
--
INSERT INTO hig_modules ( hmo_module, hmo_title, hmo_filename, hmo_module_type, hmo_fastpath_opts,
hmo_fastpath_invalid, hmo_use_gri, hmo_application, hmo_menu ) VALUES ( 
'NM1200', 'SLK Calculator', 'nm1200', 'FMX', NULL, 'N', 'N', 'NET', 'FORM');
INSERT INTO hig_modules ( hmo_module, hmo_title, hmo_filename, hmo_module_type, hmo_fastpath_opts,
hmo_fastpath_invalid, hmo_use_gri, hmo_application, hmo_menu ) VALUES ( 
'NM0520', 'Inventory Location History', 'nm0520', 'FMX', NULL, 'Y', 'N', 'NET', 'FORM');
INSERT INTO hig_modules ( hmo_module, hmo_title, hmo_filename, hmo_module_type, hmo_fastpath_opts,
hmo_fastpath_invalid, hmo_use_gri, hmo_application, hmo_menu ) VALUES ( 
'ACC3021', 'Accidents', 'ACC3021', 'FMX', NULL, 'N', 'N', 'ACC', 'FORM');
INSERT INTO hig_modules(hmo_module             
,hmo_title              
,hmo_filename           
,hmo_module_type        
,hmo_fastpath_opts      
,hmo_fastpath_invalid
,hmo_use_gri            
,hmo_application        
,hmo_menu)
VALUES('ACC3022'
,'Accident Location'
,'ACC3022'
,'FMX'
,''
,'N'
,'N'
,'ACC'
,'FORM'
);
INSERT INTO hig_modules ( hmo_module, hmo_title, hmo_filename, hmo_module_type, hmo_fastpath_opts,
hmo_fastpath_invalid, hmo_use_gri, hmo_application, hmo_menu ) VALUES ( 
'ACC1144', 'MRWA Upload (Blood Alcohol Reading)', 'acc1144', 'FMX', NULL, 'N', 'N'
, 'ACC', 'FORM'); 
INSERT INTO hig_modules ( hmo_module, hmo_title, hmo_filename, hmo_module_type, hmo_fastpath_opts,
hmo_fastpath_invalid, hmo_use_gri, hmo_application, hmo_menu ) VALUES ( 
'ACC_SQL', 'MRWA Loader', 'acc_sql', 'FMX', NULL, 'N', 'N', 'ACC', 'FORM'); 
INSERT INTO hig_modules ( hmo_module, hmo_title, hmo_filename, hmo_module_type, hmo_fastpath_opts,
hmo_fastpath_invalid, hmo_use_gri, hmo_application, hmo_menu ) VALUES ( 
'ACC_MRWA', 'MRWA Upload (Vehicle Registration)', 'acc_mrwa', 'FMX', NULL, 'N', 'N'
, 'ACC', 'FORM'); 

UPDATE hig_modules
SET hmo_title = 'Merge Query'
WHERE hmo_module = 'NM7052';
--
--hig_module_roles
--
INSERT INTO hig_module_roles ( hmr_module, hmr_role, hmr_mode ) VALUES ( 
'NM0520', 'NET_USER', 'NORMAL'); 
INSERT INTO hig_module_roles ( hmr_module, hmr_role, hmr_mode ) VALUES ( 
'NM1200', 'NET_USER', 'NORMAL');
INSERT INTO hig_module_roles(hmr_module
,hmr_role       
,hmr_mode)
VALUES('ACC3022'
,'ACC_ADMIN'
,'NORMAL'
);
INSERT INTO hig_module_roles ( hmr_module, hmr_role, hmr_mode ) VALUES ( 
'ACC3021', 'ACC_ADMIN', 'NORMAL');
INSERT INTO hig_module_roles(hmr_module
,hmr_role      
,hmr_mode)
VALUES('ACC3022'
,'ACC_USER'
,'NORMAL'
);
INSERT INTO hig_module_roles ( hmr_module, hmr_role, hmr_mode ) VALUES ( 
'ACC1144', 'ACC_ADMIN', 'NORMAL'); 
INSERT INTO hig_module_roles ( hmr_module, hmr_role, hmr_mode ) VALUES ( 
'ACC_SQL', 'ACC_ADMIN', 'NORMAL'); 
INSERT INTO hig_module_roles ( hmr_module, hmr_role, hmr_mode ) VALUES ( 
'ACC_MRWA', 'ACC_ADMIN', 'NORMAL'); 
--
--hig_options
--
INSERT INTO hig_options ( hop_id, hop_product, hop_name, hop_value,
hop_remarks ) VALUES ( 
'SQLLDR_EXE', 'HIG', 'SQL*Loader Executable', 'sqlldr', 'The name of the SQL*Loader executalbe.'); 
--
--hig_domains
--
INSERT INTO hig_domains ( hdo_domain, hdo_product, hdo_title,
hdo_code_length ) VALUES ( 
'HISTORY_OPERATION', 'HIG', 'Operations Recorded in History', 1); 
--
--hig_codes
--
INSERT INTO hig_codes ( hco_domain, hco_code, hco_meaning, hco_system, hco_seq, hco_start_date,
hco_end_date ) VALUES ( 
'HISTORY_OPERATION', 'M', 'Merge', 'Y', 3, NULL, NULL); 
INSERT INTO hig_codes ( hco_domain, hco_code, hco_meaning, hco_system, hco_seq, hco_start_date,
hco_end_date ) VALUES ( 
'HISTORY_OPERATION', 'S', 'Split', 'Y', 2, NULL, NULL); 
INSERT INTO hig_codes ( hco_domain, hco_code, hco_meaning, hco_system, hco_seq, hco_start_date,
hco_end_date ) VALUES ( 
'HISTORY_OPERATION', 'R', 'Replace', 'Y', 4, NULL, NULL); 
INSERT INTO hig_codes ( hco_domain, hco_code, hco_meaning, hco_system, hco_seq, hco_start_date,
hco_end_date ) VALUES ( 
'HISTORY_OPERATION', 'C', 'Close', 'Y', 1, NULL, NULL); 

