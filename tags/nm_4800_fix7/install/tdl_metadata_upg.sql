-----------------------------------------------------------------------------
-- tdl_metadata_upg.sql
----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/tdl_metadata_upg.sql-arc   1.0   Jan 17 2021 10:51:50   Vikas.Mhetre  $
--       Module Name      : $Workfile:   tdl_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jan 17 2021 10:51:50  $
--       Date fetched Out : $Modtime:   Jan 15 2021 17:59:28  $
--       Version          : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2021 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF

SET TERM ON
PROMPT Updating domain code length
UPDATE hig_domains 
SET hdo_code_length = 20
WHERE hdo_domain = 'SDL_FILE_TYPE';
--
PROMPT Adding domain codes
INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_PROCESSES'
      ,'FAILED'
	  ,'Failed'
	  ,'Y'
	  ,10
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_PROCESSES'
					  AND hco_code = 'FAILED');
--
INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_FILE_TYPE'
      ,'CSV'
	  ,'Comma-Separated VALUES'
	  ,'Y'
	  ,3
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_FILE_TYPE'
					  AND hco_code = 'CSV');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_FILE_TYPE'
      ,'WFS'
	  ,'Web Feature Service'
	  ,'Y'
	  ,4
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_FILE_TYPE'
					  AND hco_code = 'WFS');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_FILE_TYPE'
      ,'ESRIFEATURE'
	  ,'esri Feature Service'
	  ,'Y'
	  ,5
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_FILE_TYPE'
					  AND hco_code = 'ESRIFEATURE');
					  
INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_FILE_TYPE'
      ,'EXCEL'
	  ,'MS Excel'
	  ,'Y'
	  ,6
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_FILE_TYPE'
					  AND hco_code = 'EXCEL');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_FILE_TYPE'
      ,'ACCESS'
	  ,'MS Access'
	  ,'Y'
	  ,7
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_FILE_TYPE'
					  AND hco_code = 'ACCESS');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_FILE_TYPE'
      ,'XML'
	  ,'Extensible Markup Language'
	  ,'Y'
	  ,8
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_FILE_TYPE'
					  AND hco_code = 'XML');
					  
INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_FILE_TYPE'
      ,'JSON'
	  ,'JavaScript Object Notation'
	  ,'Y'
	  ,9
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_FILE_TYPE'
					  AND hco_code = 'JSON');
					  
--			  
PROMPT Adding TDL source type attributes
INSERT INTO sdl_source_type_attribs
  (ssta_id,
   ssta_source_type,
   ssta_attribute,
   ssta_datatype,
   ssta_size,
   ssta_default,
   ssta_domain,
   ssta_attribute_text,
   ssta_mandatory)
SELECT 
   1,
   'CSV',
   'DELIMITER',
   'VARCHAR2',
   1,
   ',',
   'CSV_DELIMITERS',
   'Delimiter',
   'Y'
FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM sdl_source_type_attribs
					WHERE ssta_id  = 1 );

INSERT INTO sdl_source_type_attribs
  (ssta_id,
   ssta_source_type,
   ssta_attribute,
   ssta_datatype,
   ssta_size,
   ssta_default,
   ssta_domain,
   ssta_attribute_text,
   ssta_mandatory)
SELECT 
  2, 
  'CSV', 
  'FIXED_LENGTH', 
  'NUMBER', 
  3, 
  null, 
  null, 
  'Fixed Length', 
  'N'
FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM sdl_source_type_attribs
					WHERE ssta_id  = 2 );
					
INSERT INTO sdl_source_type_attribs
  (ssta_id,
   ssta_source_type,
   ssta_attribute,
   ssta_datatype,
   ssta_size,
   ssta_default,
   ssta_domain,
   ssta_attribute_text,
   ssta_mandatory)
SELECT 
  3, 
  'CSV', 
  'HEADERS', 
  'VARCHAR2', 
  1, 
  'N', 
  'Y_OR_N', 
  'Headers?', 
  'Y'
FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM sdl_source_type_attribs
					WHERE ssta_id  = 3 );

INSERT INTO sdl_source_type_attribs
  (ssta_id,
   ssta_source_type,
   ssta_attribute,
   ssta_datatype,
   ssta_size,
   ssta_default,
   ssta_domain,
   ssta_attribute_text,
   ssta_mandatory)
SELECT 
   4,
   'CSV',
   'DATE_FORMAT',
   'VARCHAR2',
   20,
   'DD-MON-YYYY',
   'DATE_FORMAT_MASK',
   'Date Format',
   'N'
FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM sdl_source_type_attribs
					WHERE ssta_id  = 4 );

INSERT INTO sdl_source_type_attribs
  (ssta_id,
   ssta_source_type,
   ssta_attribute,
   ssta_datatype,
   ssta_size,
   ssta_default,
   ssta_domain,
   ssta_attribute_text,
   ssta_mandatory)
SELECT 
   5,
   'WFS',
   'CAPBILITIES_URL',
   'VARCHAR2',
   1000,
   null,
   null,
   'Capbilities URL',
   'Y'
FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM sdl_source_type_attribs
					WHERE ssta_id  = 5 );

INSERT INTO sdl_source_type_attribs
  (ssta_id,
   ssta_source_type,
   ssta_attribute,
   ssta_datatype,
   ssta_size,
   ssta_default,
   ssta_domain,
   ssta_attribute_text,
   ssta_mandatory)
SELECT 
  6, 
  'WFS', 
  'USERNAME', 
  'VARCHAR2', 
  50, 
  null, 
  null, 
  'User Name', 
  'N'
FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM sdl_source_type_attribs
					WHERE ssta_id  = 6 );

INSERT INTO sdl_source_type_attribs
  (ssta_id,
   ssta_source_type,
   ssta_attribute,
   ssta_datatype,
   ssta_size,
   ssta_default,
   ssta_domain,
   ssta_attribute_text,
   ssta_mandatory)
SELECT 
  7, 
  'WFS', 
  'PASSWORD', 
  'VARCHAR2', 
  50, 
  null, 
  null, 
  'Password', 
  'N'
FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM sdl_source_type_attribs
					WHERE ssta_id  = 7 );

INSERT INTO sdl_source_type_attribs
  (ssta_id,
   ssta_source_type,
   ssta_attribute,
   ssta_datatype,
   ssta_size,
   ssta_default,
   ssta_domain,
   ssta_attribute_text,
   ssta_mandatory)
SELECT 
   8,
   'WFS',
   'DEFAULT_WHERE',
   'VARCHAR2',
   1000,
   null,
   null,
   'Default Where',
   'N'
FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM sdl_source_type_attribs
					WHERE ssta_id  = 8 );
					
INSERT INTO sdl_source_type_attribs
  (ssta_id,
   ssta_source_type,
   ssta_attribute,
   ssta_datatype,
   ssta_size,
   ssta_default,
   ssta_domain,
   ssta_attribute_text,
   ssta_mandatory)
SELECT 
  9, 
  'WFS', 
  'FIXED_LENGTH', 
  'NUMBER', 
  3, 
  null,
  null, 
  'Fixed Length',
  'N'
FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM sdl_source_type_attribs
					WHERE ssta_id  = 9 );

INSERT INTO sdl_source_type_attribs
  (ssta_id,
   ssta_source_type,
   ssta_attribute,
   ssta_datatype,
   ssta_size,
   ssta_default,
   ssta_domain,
   ssta_attribute_text,
   ssta_mandatory)
SELECT 
   10,
   'ESRIFEATURE',
   'CAPBILITIES_URL',
   'VARCHAR2',
   1000,
   null,
   null,
   'Capbilities URL',
   'Y'
FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM sdl_source_type_attribs
					WHERE ssta_id  = 10 );

INSERT INTO sdl_source_type_attribs
  (ssta_id,
   ssta_source_type,
   ssta_attribute,
   ssta_datatype,
   ssta_size,
   ssta_default,
   ssta_domain,
   ssta_attribute_text,
   ssta_mandatory)
SELECT 
   11,
   'ESRIFEATURE',
   'USERNAME',
   'VARCHAR2',
   50,
   null,
   null,
   'User Name',
   'N'
FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM sdl_source_type_attribs
					WHERE ssta_id  = 11 );

INSERT INTO sdl_source_type_attribs
  (ssta_id,
   ssta_source_type,
   ssta_attribute,
   ssta_datatype,
   ssta_size,
   ssta_default,
   ssta_domain,
   ssta_attribute_text,
   ssta_mandatory)
SELECT 
   12,
   'ESRIFEATURE',
   'PASSWORD',
   'VARCHAR2',
   50,
   null,
   null,
   'Password',
   'N'
FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM sdl_source_type_attribs
					WHERE ssta_id  = 12 );

INSERT INTO sdl_source_type_attribs
  (ssta_id,
   ssta_source_type,
   ssta_attribute,
   ssta_datatype,
   ssta_size,
   ssta_default,
   ssta_domain,
   ssta_attribute_text,
   ssta_mandatory)
SELECT 
   13,
   'ESRIFEATURE',
   'DEFAULT_WHERE',
   'VARCHAR2',
   1000,
   null,
   null,
   'Default Where',
   'N'
FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM sdl_source_type_attribs
					WHERE ssta_id  = 13 );

INSERT INTO sdl_source_type_attribs
  (ssta_id,
   ssta_source_type,
   ssta_attribute,
   ssta_datatype,
   ssta_size,
   ssta_default,
   ssta_domain,
   ssta_attribute_text,
   ssta_mandatory)
SELECT 
   14,
   'ESRIFEATURE',
   'FIXED_LENGTH',
   'NUMBER',
   3,
   null,
   null,
   'Fixed Length',
   'N'
FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM sdl_source_type_attribs
					WHERE ssta_id  = 14 );

--
PROMPT Adding option list
INSERT INTO hig_option_list (hol_id
                            ,hol_product
							,hol_name
							,hol_remarks
							,hol_domain
							,hol_datatype
							,hol_mixed_case
							,hol_user_option
							,hol_max_length)
SELECT 'SDLAUDITUI'
      ,'NET'
	  ,'SDL PROCESS AUDIT UI'
	  ,'A flag to enable the UI for SDL Process Audit function.'
	  ,'Y_OR_N'
	  ,'VARCHAR2'
	  ,'N'
	  ,'N'
	  ,1
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_option_list
					WHERE hol_id = 'SDLAUDITUI');

INSERT INTO hig_option_values (hov_id
                              ,hov_value)
SELECT 'SDLAUDITUI'
      ,'N'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_option_values
					WHERE hov_id = 'SDLAUDITUI');
------------------------------------------------------------------
SET TERM OFF
------------------------------------------------------------------
COMMIT;
------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------