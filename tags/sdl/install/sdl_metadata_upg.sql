-----------------------------------------------------------------------------
-- sdl_metadata_upg.sql
----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/sdl_metadata_upg.sql-arc   1.1   Mar 17 2020 14:39:56   Vikas.Mhetre  $
--       Module Name      : $Workfile:   sdl_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Mar 17 2020 14:39:56  $
--       Date fetched Out : $Modtime:   Mar 17 2020 13:01:32  $
--       Version          : $Revision:   1.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF

SET TERM ON
PROMPT Inserting SDL Metadata
PROMPT Adding SDL Roles
--
INSERT INTO hig_roles (hro_role
                      ,hro_product
                      ,hro_descr)
SELECT 'SDL_ADMIN'
      ,'NET'
      ,'SDL Application Administrator'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 
                     FROM hig_roles
                    WHERE hro_role = 'SDL_ADMIN');

INSERT INTO hig_roles (hro_role
                      ,hro_product
                      ,hro_descr)
SELECT 'SDL_USER'
      ,'NET'
      ,'SDL Default User Role'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 
                     FROM hig_roles
                    WHERE hro_role = 'SDL_USER');
------------------------------------------------------------------
PROMPT Adding default SDL modules
INSERT INTO hig_modules (hmo_module
                        ,hmo_title
                        ,hmo_filename
                        ,hmo_module_type
                        ,hmo_fastpath_opts
                        ,hmo_fastpath_invalid
                        ,hmo_use_gri
                        ,hmo_application
                        ,hmo_menu)
SELECT 'SDL0001'
      ,'SDL Manage Profiles'
      ,'sdl0001'
      ,'WEB'
      ,NULL
      ,'Y'
      ,'N'
      ,'NET'
      ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_modules
                    WHERE hmo_module = 'SDL0001');
                    
INSERT INTO hig_modules (hmo_module
                        ,hmo_title
                        ,hmo_filename
                        ,hmo_module_type
                        ,hmo_fastpath_opts
                        ,hmo_fastpath_invalid
                        ,hmo_use_gri
                        ,hmo_application
                        ,hmo_menu)
SELECT 'SDL0002'
      ,'SDL Load Spatial Data'
      ,'sdl0002'
      ,'WEB'
      ,NULL
      ,'Y'
      ,'N'
      ,'NET'
      ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_modules
                    WHERE hmo_module = 'SDL0002');
------------------------------------------------------------------
PROMPT Adding SDL roles to SDL modules
INSERT INTO hig_module_roles (hmr_module
                             ,hmr_role
                             ,hmr_mode)
SELECT 'SDL0001'
      ,'SDL_ADMIN'
      ,'NORMAL'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 
                     FROM hig_module_roles
                    WHERE hmr_module = 'SDL0001'
                      AND hmr_role = 'SDL_ADMIN');
                    
INSERT INTO hig_module_roles (hmr_module
                             ,hmr_role
                             ,hmr_mode)
SELECT 'SDL0002'
      ,'SDL_ADMIN'
      ,'NORMAL'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 
                     FROM hig_module_roles
                    WHERE hmr_module = 'SDL0002'
                      AND hmr_role = 'SDL_ADMIN');

INSERT INTO hig_module_roles (hmr_module
                             ,hmr_role
                             ,hmr_mode)
SELECT 'SDL0002'
      ,'SDL_USER'
      ,'NORMAL'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 
                     FROM hig_module_roles
                    WHERE hmr_module = 'SDL0002'
                      AND hmr_role = 'SDL_USER');                     
------------------------------------------------------------------
PROMPT Adding SDL roles to highways owner
INSERT INTO hig_user_roles (hur_username
                           ,hur_role
                           ,hur_start_date)
SELECT hus_username
      ,'SDL_ADMIN'
      ,TRUNC(SYSDATE)
  FROM hig_users
 WHERE hus_is_hig_owner_flag = 'Y'
   AND NOT EXISTS (SELECT 1 
                     FROM hig_user_roles
                    WHERE hur_username = hus_username
                      AND hur_role = 'SDL_ADMIN');

INSERT INTO hig_user_roles (hur_username
                           ,hur_role
                           ,hur_start_date)
SELECT hus_username
      ,'SDL_USER'
      ,TRUNC(SYSDATE)
  FROM hig_users
 WHERE hus_is_hig_owner_flag = 'Y'
   AND NOT EXISTS (SELECT 1 
                     FROM hig_user_roles
                    WHERE hur_username = hus_username
                      AND hur_role = 'SDL_USER');
------------------------------------------------------------------
PROMPT Adding hig option for SDL map
INSERT INTO hig_option_list (hol_id
                            ,hol_product
							,hol_name
							,hol_remarks
							,hol_domain
							,hol_datatype
							,hol_mixed_case
							,hol_user_option
							,hol_max_length)
SELECT 'SDLMAPNAME'
      ,'NET'
	  ,'SDL Map Name'
	  ,'The name of the base map to be used by SDL.'
	  ,NULL
	  ,'VARCHAR2'
	  ,'N'
	  ,'N'
	  ,50
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_option_list
					WHERE hol_id = 'SDLMAPNAME');

INSERT INTO hig_option_values (hov_id
                              ,hov_value)
SELECT 'SDLMAPNAME'
      ,'SDL_MAP'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_option_values
					WHERE hov_id = 'SDLMAPNAME');
------------------------------------------------------------------
PROMPT Adding product domains
INSERT INTO hig_domains (hdo_domain
                        ,hdo_product
						,hdo_title
						,hdo_code_length)
SELECT 'SDL_FILE_TYPE'
       ,'NET'
	   ,'SDL File Types'
	   ,5
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_domains
					WHERE hdo_domain = 'SDL_FILE_TYPE');
					
INSERT INTO hig_domains (hdo_domain
                        ,hdo_product
						,hdo_title
						,hdo_code_length)
SELECT 'SDL_MAX_IMPORT_LEVEL'
       ,'NET'
	   ,'SDL Maximum Import level'
	   ,10
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_domains
					WHERE hdo_domain = 'SDL_MAX_IMPORT_LEVEL');

INSERT INTO hig_domains (hdo_domain
                        ,hdo_product
						,hdo_title
						,hdo_code_length)
SELECT 'SDL_TOPOLOGY_LEVEL'
       ,'NET'
	   ,'SDL Topology Level'
	   ,12
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_domains
					WHERE hdo_domain = 'SDL_TOPOLOGY_LEVEL');

INSERT INTO hig_domains (hdo_domain
                        ,hdo_product
						,hdo_title
						,hdo_code_length)
SELECT 'SDL_REVIEW_ACTION'
       ,'NET'
	   ,'SDL Spatial Review Actions'
	   ,30
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_domains
					WHERE hdo_domain = 'SDL_REVIEW_ACTION');

INSERT INTO hig_domains (hdo_domain
                        ,hdo_product
						,hdo_title
						,hdo_code_length)
SELECT 'SDL_PROCESSES'
       ,'NET'
	   ,'Processes used by SDL'
	   ,30
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_domains
					WHERE hdo_domain = 'SDL_PROCESSES');

INSERT INTO hig_domains (hdo_domain
                        ,hdo_product
						,hdo_title
						,hdo_code_length)
SELECT 'SDL_LOAD_DATA_STATUS'
       ,'NET'
	   ,'SDL load status codes for SLD_STATUS'
	   ,30
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_domains
					WHERE hdo_domain = 'SDL_LOAD_DATA_STATUS');
------------------------------------------------------------------
PROMPT Adding domain codes
INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_FILE_TYPE'
      ,'SHAPE'
	  ,'Shapefile'
	  ,'Y'
	  ,1
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_FILE_TYPE'
					  AND hco_code = 'SHAPE');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_FILE_TYPE'
      ,'GEODB'
	  ,'File Geodatabase'
	  ,'Y'
	  ,2
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_FILE_TYPE'
					  AND hco_code = 'GEODB');
------------------------------------------------------------------
INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_MAX_IMPORT_LEVEL'
      ,'UPLOAD'
	  ,'Upload File'
	  ,'Y'
	  ,1
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_MAX_IMPORT_LEVEL'
					  AND hco_code = 'UPLOAD');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_MAX_IMPORT_LEVEL'
      ,'VALIDATE'
	  ,'Validate Attributes and Review'
	  ,'Y'
	  ,2
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_MAX_IMPORT_LEVEL'
					  AND hco_code = 'VALIDATE');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_MAX_IMPORT_LEVEL'
      ,'SPATIAL'
	  ,'Spatial Analysis and Review'
	  ,'Y'
	  ,3
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_MAX_IMPORT_LEVEL'
					  AND hco_code = 'SPATIAL');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_MAX_IMPORT_LEVEL'
      ,'LOADNE'
	  ,'Load into Production Network'
	  ,'Y'
	  ,4
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_MAX_IMPORT_LEVEL'
					  AND hco_code = 'LOADNE');
------------------------------------------------------------------
INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_TOPOLOGY_LEVEL'
      ,'ENDPOINTONLY'
	  ,'Stitch End-Points Only'
	  ,'Y'
	  ,1
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_TOPOLOGY_LEVEL'
					  AND hco_code = 'ENDPOINTONLY');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_TOPOLOGY_LEVEL'
      ,'IMPORTEDDATA'
	  ,'Stitching Not Allowed'
	  ,'Y'
	  ,2
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_TOPOLOGY_LEVEL'
					  AND hco_code = 'IMPORTEDDATA');
					  
INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_TOPOLOGY_LEVEL'
      ,'FULLTOPOLOGY'
	  ,'Stitch All Intersects'
	  ,'Y'
	  ,3
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_TOPOLOGY_LEVEL'
					  AND hco_code = 'FULLTOPOLOGY');
------------------------------------------------------------------
INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_REVIEW_ACTION'
      ,'REVIEW'
	  ,'Review'
	  ,'Y'
	  ,1
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_REVIEW_ACTION'
					  AND hco_code = 'REVIEW');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_REVIEW_ACTION'
      ,'LOAD'
	  ,'Load'
	  ,'Y'
	  ,2
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_REVIEW_ACTION'
					  AND hco_code = 'LOAD');

					  INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_REVIEW_ACTION'
      ,'SKIP'
	  ,'Skip'
	  ,'Y'
	  ,3
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_REVIEW_ACTION'
					  AND hco_code = 'SKIP');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_REVIEW_ACTION'
      ,'NO_ACTION'
	  ,'No Action'
	  ,'Y'
	  ,4
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_REVIEW_ACTION'
					  AND hco_code = 'NO_ACTION');
------------------------------------------------------------------
-- This is where a file is being transferred to the server directory and where the link is made between a file submission and the actual file
INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_PROCESSES'
      ,'NEW'
	  ,'A new file is being processed'
	  ,'Y'
	  ,1
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_PROCESSES'
					  AND hco_code = 'NEW');
					  
-- This is where the file data is being uploaded into the holding table
INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_PROCESSES'
      ,'LOAD'
	  ,'Load'
	  ,'Y'
	  ,2
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_PROCESSES'
					  AND hco_code = 'LOAD');

-- This is where the file is undergoing/undergone an attribute adjustment process.
INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_PROCESSES'
      ,'ADJUST'
	  ,'Adjust'
	  ,'Y'
	  ,3
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_PROCESSES'
					  AND hco_code = 'ADJUST');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_PROCESSES'
      ,'LOAD_VALIDATION'
	  ,'Validation and generation of working geometry'
	  ,'Y'
	  ,4
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_PROCESSES'
					  AND hco_code = 'LOAD_VALIDATION');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_PROCESSES'
      ,'TOPO_GENERATION'
	  ,'Generation of toplogical datums and nodes'
	  ,'Y'
	  ,5
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_PROCESSES'
					  AND hco_code = 'TOPO_GENERATION');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_PROCESSES'
      ,'DATUM_VALIDATION'
	  ,'Validation of geometry of datums and nodes'
	  ,'Y'
	  ,6
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_PROCESSES'
					  AND hco_code = 'DATUM_VALIDATION');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_PROCESSES'
      ,'ANALYSIS'
	  ,'Further analysis'
	  ,'Y'
	  ,7
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_PROCESSES'
					  AND hco_code = 'ANALYSIS');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_PROCESSES'
      ,'TRANSFER'
	  ,'Transfer to main database'
	  ,'Y'
	  ,8
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_PROCESSES'
					  AND hco_code = 'TRANSFER');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_PROCESSES'
      ,'REJECT'
	  ,'Reject'
	  ,'Y'
	  ,9
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_PROCESSES'
					  AND hco_code = 'REJECT');
------------------------------------------------------------------
INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_LOAD_DATA_STATUS'
      ,'NEW'
	  ,'New'
	  ,'Y'
	  ,1
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_LOAD_DATA_STATUS'
					  AND hco_code = 'NEW');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_LOAD_DATA_STATUS'
      ,'VALID'
	  ,'Valid'
	  ,'Y'
	  ,2
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_LOAD_DATA_STATUS'
					  AND hco_code = 'VALID');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_LOAD_DATA_STATUS'
      ,'INVALID'
	  ,'Invalid'
	  ,'Y'
	  ,3
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_LOAD_DATA_STATUS'
					  AND hco_code = 'INVALID');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_LOAD_DATA_STATUS'
      ,'REJECTED'
	  ,'Rejected'
	  ,'Y'
	  ,4
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_LOAD_DATA_STATUS'
					  AND hco_code = 'REJECTED');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_LOAD_DATA_STATUS'
      ,'REVIEW'
	  ,'Review'
	  ,'Y'
	  ,5
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_LOAD_DATA_STATUS'
					  AND hco_code = 'REVIEW');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_LOAD_DATA_STATUS'
      ,'LOAD'
	  ,'Load'
	  ,'Y'
	  ,6
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_LOAD_DATA_STATUS'
					  AND hco_code = 'LOAD');

INSERT INTO hig_codes (hco_domain
                      ,hco_code
					  ,hco_meaning
					  ,hco_system
					  ,hco_seq
					  ,hco_start_date
					  ,hco_end_date)
SELECT 'SDL_LOAD_DATA_STATUS'
      ,'SKIP'
	  ,'Skip'
	  ,'Y'
	  ,7
	  ,TRUNC(SYSDATE)
	  ,NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1
                     FROM hig_codes
					WHERE hco_domain = 'SDL_LOAD_DATA_STATUS'
					  AND hco_code = 'SKIP');
------------------------------------------------------------------
SET TERM OFF
------------------------------------------------------------------
COMMIT;
------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------