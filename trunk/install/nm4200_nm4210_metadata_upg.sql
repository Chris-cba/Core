------------------------------------------------------------------
-- nm4200_nm4210_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4200_nm4210_metadata_upg.sql-arc   3.0   Apr 14 2010 14:32:36   malexander  $
--       Module Name      : $Workfile:   nm4200_nm4210_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Apr 14 2010 14:32:36  $
--       Date fetched Out : $Modtime:   Apr 14 2010 14:27:00  $
--       Version          : $Revision:   3.0  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF

DECLARE
  l_temp nm3type.max_varchar2;
BEGIN
  -- Dummy call to HIG to instantiate it
  l_temp := hig.get_version;
  l_temp := nm_debug.get_version;
EXCEPTION
  WHEN others
   THEN
 Null;
END;
/

BEGIN
  nm_debug.debug_off;
END;
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Metadata for new HIG1870 form.
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 107770
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- Menu, Module and Role Metadata for HIG1870
-- 
------------------------------------------------------------------
INSERT INTO hig_modules ( hmo_module
                                , hmo_title
                                , hmo_filename
                                , hmo_module_type
                                , hmo_fastpath_invalid
                                , hmo_use_gri
                                , hmo_application
                                , hmo_menu)
SELECT 'HIG1870' hmo_module
          , 'Upgrades' hmo_title
          , 'hig1870' hmo_filename
          , 'FMX' hmo_module_type
          , 'N' hmo_fastpath_invalid
          , 'N' hmo_use_gri
          , 'HIG'hmo_application
          , 'FORM' hmo_menu
  FROM  dual
WHERE NOT EXISTS (SELECT 'X' 
                                  FROM hig_modules
                                WHERE hmo_module = 'HIG1870')
/
--
INSERT INTO hig_module_roles( HMR_MODULE
                                              , HMR_ROLE
                                              , HMR_MODE)
SELECT 'HIG1870', 'HIG_USER', 'NORMAL' 
FROM dual 
WHERE NOT EXISTS  (SELECT 'X' 
                                FROM hig_module_roles 
                                WHERE hmr_module = 'HIG1870' 
                                AND HMR_ROLE = 'HIG_USER')
UNION ALL
SELECT 'HIG1870', 'HIG_ADMIN', 'NORMAL' 
FROM dual 
WHERE NOT EXISTS (SELECT 'X' 
                                FROM hig_module_roles 
                                WHERE hmr_module = 'HIG1870' 
                                AND HMR_ROLE = 'HIG_ADMIN')
/
--
INSERT INTO HIG_STANDARD_FAVOURITES (  HSTF_PARENT
                                                                , HSTF_CHILD
                                                                , HSTF_DESCR
                                                                , HSTF_TYPE 
                                                                , HSTF_ORDER)
SELECT 'HIG_SECURITY', 'HIG1870', 'Upgrades', 'M', 6 FROM dual
WHERE NOT EXISTS (SELECT 'X' 
FROM HIG_STANDARD_FAVOURITES 
WHERE HSTF_DESCR = 'Upgrades')
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Update Contact details title to remove HIG
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108668
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- Update Contact details title to remove HIG
-- 
------------------------------------------------------------------
UPDATE hig_modules
      SET hmo_title = 'User Contact Details'
 WHERE hmo_module = 'HIG1834'
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Metadata for new HIG9140 form
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108246
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- Metadata for new HIG9140 form.
-- 
------------------------------------------------------------------
INSERT INTO hig_modules ( hmo_module
                                , hmo_title
                                , hmo_filename
                                , hmo_module_type
                                , hmo_fastpath_invalid
                                , hmo_use_gri
                                , hmo_application
                                , hmo_menu)
SELECT 'HIG9140' hmo_module
          , 'Exclude Keywords' hmo_title
          , 'hig9140' hmo_filename
          , 'FMX' hmo_module_type
          , 'N' hmo_fastpath_invalid
          , 'N' hmo_use_gri
          , 'HIG'hmo_application
          , 'FORM' hmo_menu
  FROM  dual
WHERE NOT EXISTS (SELECT 'X' 
                                  FROM hig_modules
                                WHERE hmo_module = 'HIG9140')
/
--
INSERT INTO hig_module_roles( HMR_MODULE
                                              , HMR_ROLE
                                              , HMR_MODE)
SELECT 'HIG9140', 'HIG_USER', 'NORMAL' 
FROM dual 
WHERE NOT EXISTS  (SELECT 'X' 
                                FROM hig_module_roles 
                                WHERE hmr_module = 'HIG9140' 
                                AND HMR_ROLE = 'HIG_USER')
UNION ALL
SELECT 'HIG9140', 'HIG_ADMIN', 'NORMAL' 
FROM dual 
WHERE NOT EXISTS (SELECT 'X' 
                                FROM hig_module_roles 
                                WHERE hmr_module = 'HIG9140' 
                                AND HMR_ROLE = 'HIG_ADMIN')
/
--
INSERT INTO HIG_STANDARD_FAVOURITES (  HSTF_PARENT
                                                                , HSTF_CHILD
                                                                , HSTF_DESCR
                                                                , HSTF_TYPE 
                                                                , HSTF_ORDER)
SELECT 'HIG_REFERENCE', 'HIG9140', 'Excluded Keywords', 'M', 6 FROM dual
WHERE NOT EXISTS (SELECT 'X' 
FROM HIG_STANDARD_FAVOURITES 
WHERE HSTF_DESCR = 'Excluded Keywords')
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New product option and default value
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108990
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- NETREASON product option determines of the user is asked for a reason for their change when the make a network edit.
-- 
------------------------------------------------------------------
INSERT INTO hig_option_list (hol_id
                            ,hol_product      
                            ,hol_name         
                            ,hol_remarks      
                            ,hol_domain       
                            ,hol_datatype     
                            ,hol_mixed_case   
                            ,hol_user_option  
                            ,hol_max_length)
SELECT 'NETREASON'
     , 'NET'
     , 'Record Reason for Change'
     , 'On making network edits the user will be asked to record the reason for this amendment in a popup window'
     , 'Y_OR_N'
     , 'VARCHAR2'
     , 'N'
     , 'N'
     , '1'
  FROM dual
  WHERE NOT EXISTS (SELECT 'X' 
                     FROM hig_option_list
                    WHERE HOL_ID = 'NETREASON')
/
INSERT INTO hig_option_values ( hov_id
                              , hov_value)
SELECT 'NETREASON'
     , 'Y'
  FROM dual
 WHERE NOT EXISTS (SELECT 'X' 
                     FROM hig_option_values
                    WHERE hov_id = 'NETREASON')
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Removing reference to dropped tables
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 109297
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- Removing reference to dropped tables
-- 
------------------------------------------------------------------
DELETE from HIG_CHECK_CONSTRAINT_ASSOCS 
where hcca_table_name IN ('NM_SDE_TEMP_RESCALE', 'NM_MEMBERS_SDE_TEMP')
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT PROCESS_EXECUTION Role
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 109363
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Add new role to HIG_ROLES and HIG_USER_ROLES for HIGHWAYS owner for Job execution.
-- 
------------------------------------------------------------------
INSERT INTO hig_roles
  SELECT 'PROCESS_EXECUTION','HIG','Scheduler Job Privs'
    FROM dual
   WHERE NOT EXISTS
      (SELECT 1 FROM hig_roles
        WHERE hro_role = 'PROCESS_EXECUTION');

INSERT INTO hig_user_roles
  SELECT hus_username, 'PROCESS_EXECUTION', hus_start_date
    FROM hig_users
   WHERE hus_username = USER
     AND NOT EXISTS
       (SELECT 1 FROM hig_user_roles
         WHERE hur_username = USER
           AND hur_role = 'PROCESS_EXECUTION');
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT FTP Metadata
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 109318
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Task 0109318 - FTP
-- 
------------------------------------------------------------------
INSERT INTO hig_modules
 SELECT 'HIG0100','FTP Connection Types','hig0100','FMX',NULL,'N','N','HIG','FORM'
   FROM dual
  WHERE NOT EXISTS
    (SELECT 1 FROM hig_modules
      WHERE hmo_module = 'HIG0100');

INSERT INTO hig_modules
 SELECT 'HIG0200','FTP Connections','hig0200','FMX',NULL,'N','N','HIG','FORM'
   FROM dual
  WHERE NOT EXISTS
    (SELECT 1 FROM hig_modules
      WHERE hmo_module = 'HIG0200');

INSERT INTO hig_module_roles
  SELECT 'HIG0100','HIG_ADMIN','NORMAL'
    FROM dual
   WHERE NOT EXISTS
     (SELECT 1 FROM hig_module_roles
       WHERE hmr_module = 'HIG0100'); 

INSERT INTO hig_module_roles
  SELECT 'HIG0200','HIG_ADMIN','NORMAL'
    FROM dual
   WHERE NOT EXISTS
     (SELECT 1 FROM hig_module_roles
       WHERE hmr_module = 'HIG0200');

INSERT INTO hig_standard_favourites
SELECT 'HIG','HIG_FTP','FTP','F',10
  FROM DUAL
 WHERE NOT EXISTS
   (SELECT 1 FROM hig_standard_favourites
     WHERE hstf_parent = 'HIG'
       AND hstf_child = 'HIG_FTP');

INSERT INTO hig_standard_favourites
SELECT 'HIG_FTP','HIG0100','FTP Connection Types','M',10
  FROM DUAL
 WHERE NOT EXISTS
   (SELECT 1 FROM hig_standard_favourites
     WHERE hstf_parent = 'HIG_FTP'
       AND hstf_child = 'HIG0100');

INSERT INTO hig_standard_favourites
SELECT 'HIG_FTP','HIG0200','FTP Connections','M',20
  FROM DUAL
 WHERE NOT EXISTS
   (SELECT 1 FROM hig_standard_favourites
     WHERE hstf_parent = 'HIG_FTP'
       AND hstf_child = 'HIG0200');

--
-- MIigrate the old FTP metadata from the custom FTP metadata table.
--

BEGIN
--
  IF nm3ddl.does_object_exist('X_TFL_FTP_DIRS')
  THEN
    EXECUTE IMMEDIATE
    'INSERT INTO hig_ftp_types '||
    ' ( hft_id, hft_type, hft_descr ) '||
    ' SELECT hft_id_seq.NEXTVAL '||
         ' , ftp_type '||
         ' , DECODE (ftp_type,''MCP'',''Mapcapture Interface'' '||
                           ' ,''CIM'',''Contract Inteface Manager'' '||
                          ' , ''PED'',''PED'' '||
                         '  , ''TMAI'',''TMA Inspections'', ftp_type) '||
      ' FROM (SELECT UNIQUE ftp_type ' ||
               ' FROM x_tfl_ftp_dirs) a '||
     ' WHERE NOT EXISTS '||
        '(SELECT 1 ' ||
          ' FROM (SELECT UNIQUE ftp_type '||  
                  ' FROM x_tfl_ftp_dirs) b '|| 
          ' WHERE b.ftp_type = a.ftp_type)';
  --
    EXECUTE IMMEDIATE
      'INSERT INTO hig_ftp_connections a'||
      ' ( hfc_id, hfc_hft_id, hfc_name, hfc_nau_admin_unit, hfc_nau_unit_code '||
      ' , hfc_nau_admin_type, hfc_ftp_username, hfc_ftp_password, hfc_ftp_host '||
      ' , hfc_ftp_port, hfc_ftp_in_dir, hfc_ftp_out_dir, hfc_ftp_arc_in_dir '||
      ' , hfc_ftp_arc_out_dir ) '||
     ' SELECT hfc_id_seq.nextval hfc_id'||
          ' , hft_id '||
          ' , ftp_type||CASE WHEN ftp_contractor IS NOT NULL THEN ''_''||ftp_contractor END'||
          ' , nau_admin_unit '||
          ' , nau_unit_code '||
          ' , nau_admin_type '||
          ' , ftp_username '||
          ' , nm3ftp.obfuscate_password(ftp_password) '||
          ' , ftp_host '||
          ' , ftp_port '||
          ' , ftp_in_dir '||
          ' , ftp_out_dir '||
          ' , ftp_arc_in_dir '||
          ' , ftp_arc_out_dir '||
       ' FROM x_tfl_ftp_dirs, hig_ftp_types, nm_admin_units '||
      ' WHERE ftp_type = hft_type '||
        ' AND ftp_contractor = nau_unit_code(+)'||
        ' AND nau_admin_type(+) = ''NETW'''||
        ' AND NOT EXISTS '||
           ' (SELECT 1 FROM hig_ftp_connections a '||
            ' WHERE a.hfc_name = ftp_type||CASE WHEN ftp_contractor IS NOT NULL THEN ''_''||ftp_contractor END )';
  --
  END IF;
--
END;
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT All new Process Types
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Process Types across the Core product.
-- 
------------------------------------------------------------------
PROMPT Creating Alert Manager Process Type
Insert into HIG_PROCESS_TYPES
SELECT -1, 'Alert Manager', 'This Process will sent out pending Alerts every 10 minutes', 'hig_alert.run_alert_batch;', NULL,Null ,Null , NULL, 'Y', 'Y'
FROM Dual 
WHERE NOT Exists (Select 1 From HIG_PROCESS_TYPES WHERE HPT_PROCESS_TYPE_ID = -1) ;


PROMPT Creating Alert Manager Process Type Roles
Insert into HIG_PROCESS_TYPE_ROLES
SELECT -1, 'HIG_USER'
FROm dual 
WHERE not exists (SELECT 1 from HIG_PROCESS_TYPE_ROLES WHERE HPTR_PROCESS_TYPE_ID = -1);

PROMPT Creating Alert Manager Process Type Frequency
Insert into HIG_PROCESS_TYPE_FREQUENCIES
Select -1,-4,1 FRom dual
Where not exists (Select 1 from HIG_PROCESS_TYPE_FREQUENCIES WHERE HPFR_PROCESS_TYPE_ID = -1);




------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Process Framework - Domains and Codes
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108982
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- To support process framework
-- 
------------------------------------------------------------------
--
-- Start with a clear out - to make this re-runnable
--
delete from hig_codes where hco_domain in ('FILE_DESTINATIONS'
                                          ,'LOG_MESSAGE_TYPE'
                                          ,'PROCESS_SUCCESS_FLAG'                                          
                                          ,'FILE_DIRECTION'
                                          );
                                          
delete from hig_domains where hdo_domain in ('FILE_DESTINATIONS'
                                            ,'LOG_MESSAGE_TYPE'
                                            ,'PROCESS_SUCCESS_FLAG'
                                            ,'FILE_DIRECTION'
                                          );              
--
-- Domains
--
Insert into HIG_DOMAINS
   (HDO_DOMAIN, HDO_PRODUCT, HDO_TITLE, HDO_CODE_LENGTH)
 Values
   ('FILE_DESTINATIONS', 'HIG', 'Types of File Destination', 20);


Insert into HIG_DOMAINS
   (HDO_DOMAIN, HDO_PRODUCT, HDO_TITLE, HDO_CODE_LENGTH)
 Values
   ('LOG_MESSAGE_TYPE', 'HIG', 'Log Message Type', 20);   


Insert into HIG_DOMAINS
   (HDO_DOMAIN, HDO_PRODUCT, HDO_TITLE, HDO_CODE_LENGTH)
 Values
   ('PROCESS_SUCCESS_FLAG', 'HIG', 'Process Success Flag', 3);   


Insert into HIG_DOMAINS
   (HDO_DOMAIN, HDO_PRODUCT, HDO_TITLE, HDO_CODE_LENGTH)
 Values
   ('FILE_DIRECTION', 'HIG', 'File Direction e.g. input or output', 1);


--
-- Codes for FILE_DESTINATIONS
--
Insert into HIG_CODES
   (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ)
 Values
   ('FILE_DESTINATIONS', 'DATABASE_SERVER', 'Database Server', 'Y', 
    10);


Insert into HIG_CODES
   (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ)
 Values
   ('FILE_DESTINATIONS', 'ORACLE_DIRECTORY', 'Oracle Directory', 'Y', 
    20);


Insert into HIG_CODES
   (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ)
 Values
   ('FILE_DESTINATIONS', 'DATABASE_TABLE', 'Database Table', 'Y', 
    30);


Insert into HIG_CODES
   (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ)
 Values
   ('FILE_DESTINATIONS', 'APP_SERVER', 'Application Server', 'Y', 
    40);


--
-- Codes for LOG_MESSAGE_TYPE
--
Insert into HIG_CODES
   (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ)
 Values
   ('LOG_MESSAGE_TYPE', 'W', 'Warning', 'Y', 
    20);


Insert into HIG_CODES
   (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ)
 Values
   ('LOG_MESSAGE_TYPE', 'E', 'Error', 'Y', 
    30);


Insert into HIG_CODES
   (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ)
 Values
   ('LOG_MESSAGE_TYPE', 'I', 'Information', 'Y', 
    10);

--
-- Codes for PROCESS_SUCCESS_FLAG
--
Insert into HIG_CODES
   (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ)
 Values
   ('PROCESS_SUCCESS_FLAG', 'Y', 'Success', 'Y', 
    20);


Insert into HIG_CODES
   (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ)
 Values
   ('PROCESS_SUCCESS_FLAG', 'N', 'Fail', 'Y', 
    30);


Insert into HIG_CODES
   (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ)
 Values
   ('PROCESS_SUCCESS_FLAG', 'TBD', 'To Be Determined', 'Y', 
    30);

--
-- Codes for FILE_DIRECTION
--
Insert into HIG_CODES
   (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ)
 Values
   ('FILE_DIRECTION', 'I', 'Input', 'Y', 
    10);


Insert into HIG_CODES
   (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ)
 Values
   ('FILE_DIRECTION', 'O', 'Output', 'Y', 
    20);
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Process Framework - Modules and Module Roles
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108982
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- To support process framework
-- 
------------------------------------------------------------------
--
-- Start with a clear out - to make this re-runnable
--
delete from hig_module_roles
where  hmr_module in ('HIG2500'
                     ,'HIG2510'
                     ,'HIG2515'                     
                     ,'HIG2520'
                     ,'HIG2530' 
                     ,'HIG2540'                     
                    );                                                                                    


delete from hig_modules
where  hmo_module in ('HIG2500'
                     ,'HIG2510'
                     ,'HIG2515'                     
                     ,'HIG2520'
                     ,'HIG2530' 
                     ,'HIG2540'                     
                    );                                                                                    
                     
--
-- HIG2500
--
INSERT INTO hig_modules (hmo_module,
                         hmo_title,
                         hmo_filename,
                         hmo_module_type,
                         hmo_fastpath_invalid,
                         hmo_use_gri,
                         hmo_application,
                         hmo_menu)
	 VALUES ('HIG2500',
				'Process Types',
				'hig2500',
				'FMX',
				'N',
				'N',
				'HIG',
				'FORM');

insert into hig_module_roles(hmr_module, hmr_role, hmr_mode)
values ('HIG2500','HIG_ADMIN','NORMAL');

--
-- HIG2510
--
INSERT INTO hig_modules (hmo_module,
                          hmo_title,
                        hmo_filename,
                        hmo_module_type,
                        hmo_fastpath_invalid,
                        hmo_use_gri,
                        hmo_application,
                        hmo_menu)
     VALUES ('HIG2510',
                'Submit a Process',
                'hig2510',
                'FMX',
                'N',
                'N',
                'HIG',
                'FORM');

insert into hig_module_roles(hmr_module, hmr_role, hmr_mode)
values ('HIG2510','HIG_USER','NORMAL');

--
-- HIG2515
--
INSERT INTO hig_modules (hmo_module,
                          hmo_title,
                        hmo_filename,
                        hmo_module_type,
                        hmo_fastpath_invalid,
                        hmo_use_gri,
                        hmo_application,
                        hmo_menu)
     VALUES ('HIG2515',
                'Amend a Process',
                'hig2510',
                'FMX',
                'N',
                'N',
                'HIG',
                'FORM');

insert into hig_module_roles(hmr_module, hmr_role, hmr_mode)
values ('HIG2515','HIG_ADMIN','NORMAL');


--
-- HIG2520
--
INSERT INTO hig_modules (hmo_module,
                          hmo_title,
                        hmo_filename,
                        hmo_module_type,
                        hmo_fastpath_invalid,
                        hmo_use_gri,
                        hmo_application,
                        hmo_menu)
     VALUES ('HIG2520',
                'Process Monitor',
                'hig2520',
                'FMX',
                'N',
                'N',
                'HIG',
                'FORM');

insert into hig_module_roles(hmr_module, hmr_role, hmr_mode)
values ('HIG2520','HIG_ADMIN','NORMAL');

--
-- HIG2530
--
INSERT INTO hig_modules (hmo_module,
                          hmo_title,
                        hmo_filename,
                        hmo_module_type,
                        hmo_fastpath_invalid,
                        hmo_use_gri,
                        hmo_application,
                        hmo_menu)
     VALUES ('HIG2530',
                'Scheduling Frequencies',
                'hig2530',
                'FMX',
                'N',
                'N',
                'HIG',
                'FORM');

insert into hig_module_roles(hmr_module, hmr_role, hmr_mode)
values ('HIG2530','HIG_ADMIN','NORMAL');


--
-- HIG2540
--
INSERT INTO hig_modules (hmo_module,
                         hmo_title,
                         hmo_filename,
                         hmo_module_type,
                         hmo_fastpath_invalid,
                         hmo_use_gri,
                         hmo_application,
                         hmo_menu)
     VALUES ('HIG2540',
                'Process Execution Log',
                'hig2540',
                'FMX',
                'Y',
                'N',
                'HIG',
                'FORM');

insert into hig_module_roles(hmr_module, hmr_role, hmr_mode)
values ('HIG2540','HIG_USER','NORMAL');

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Process Framework - Launchpad
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108982
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- To support process framework
-- 
------------------------------------------------------------------
--
-- Start with a clear out - to make this re-runnable
--
delete from hig_standard_favourites where hstf_parent = 'HIG' and hstf_child = 'HIG_PROCESSES'
/

delete from hig_standard_favourites where hstf_parent = 'HIG_PROCESSES'
/


--
-- New Data
--
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
 Values
   ('HIG', 'HIG_PROCESSES', 'Processes', 'F', 
    9);
    
Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
 Values
   ('HIG_PROCESSES', 'HIG2520', 'Process Monitor', 'M', 
    10);

Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
 Values
   ('HIG_PROCESSES', 'HIG2510', 'Submit a Process', 'M', 
    20);


Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
 Values
   ('HIG_PROCESSES', 'HIG2500', 'Process Types', 'M', 
    30);

Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
 Values
   ('HIG_PROCESSES', 'HIG2530', 'Scheduling Frequencies', 'M', 
    40);
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Process Framework - Frequencies
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108982
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- To support process framework
-- 
------------------------------------------------------------------
--
-- Start with a clear out - to make this re-runnable
--
delete from hig_scheduling_frequencies
/

--
-- New Data
--
Insert into HIG_SCHEDULING_FREQUENCIES
   (HSFR_FREQUENCY_ID, HSFR_MEANING)
 Values
   (-1, 'Once');

Insert into HIG_SCHEDULING_FREQUENCIES
   (HSFR_FREQUENCY_ID, HSFR_MEANING, HSFR_FREQUENCY,HSFR_INTERVAL_IN_MINS)
 Values
   (-2, 'Minute', 'freq=minutely; interval=1;',1);


Insert into HIG_SCHEDULING_FREQUENCIES
   (HSFR_FREQUENCY_ID, HSFR_MEANING, HSFR_FREQUENCY,HSFR_INTERVAL_IN_MINS)
 Values
   (-3, '5 Minutes', 'freq=minutely; interval=5;',5);


Insert into HIG_SCHEDULING_FREQUENCIES
   (HSFR_FREQUENCY_ID, HSFR_MEANING, HSFR_FREQUENCY,HSFR_INTERVAL_IN_MINS)
 Values
   (-4, '10 Minutes', 'freq=minutely; interval=10;',10);


Insert into HIG_SCHEDULING_FREQUENCIES
   (HSFR_FREQUENCY_ID, HSFR_MEANING, HSFR_FREQUENCY,HSFR_INTERVAL_IN_MINS)
 Values
   (-5, '15 Minutes', 'freq=minutely; interval=15;',15);


Insert into HIG_SCHEDULING_FREQUENCIES
   (HSFR_FREQUENCY_ID, HSFR_MEANING, HSFR_FREQUENCY,HSFR_INTERVAL_IN_MINS)
 Values
   (-6, '20 Minutes', 'freq=minutely; interval=20;',20);


Insert into HIG_SCHEDULING_FREQUENCIES
   (HSFR_FREQUENCY_ID, HSFR_MEANING, HSFR_FREQUENCY,HSFR_INTERVAL_IN_MINS)
 Values
   (-7, '30 Minutes', 'freq=minutely; interval=30;',30);


Insert into HIG_SCHEDULING_FREQUENCIES
   (HSFR_FREQUENCY_ID, HSFR_MEANING, HSFR_FREQUENCY,HSFR_INTERVAL_IN_MINS)
 Values
   (-8, '45 Minutes', 'freq=minutely; interval=45;',45);


Insert into HIG_SCHEDULING_FREQUENCIES
   (HSFR_FREQUENCY_ID, HSFR_MEANING, HSFR_FREQUENCY)
 Values
   (-9, 'Hourly (on the hour)', 'freq=hourly; byminute=0; bysecond=0;');

Insert into HIG_SCHEDULING_FREQUENCIES
   (HSFR_FREQUENCY_ID, HSFR_MEANING, HSFR_FREQUENCY)
 Values
   (-10, 'Hourly', 'freq=hourly;');

Insert into HIG_SCHEDULING_FREQUENCIES
   (HSFR_FREQUENCY_ID, HSFR_MEANING, HSFR_FREQUENCY)
 Values
   (-11, 'Daily at Midnight', 'freq=daily; byhour=0; byminute=0; bysecond=0;');

Insert into HIG_SCHEDULING_FREQUENCIES
   (HSFR_FREQUENCY_ID, HSFR_MEANING, HSFR_FREQUENCY)
 Values
   (-12, 'Daily', 'freq=daily;');

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Process Framework - Error Messages
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108982
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- To support process framework
-- 
------------------------------------------------------------------
--
-- Start with a clear out - to make this re-runnable
--
delete from nm_errors where ner_appl = 'HIG' and ner_id in (510
                                                           ,511
                                                           ,512
                                                           ,513
                                                           ,514
                                                           ,515
                                                           ,516
                                                           ,517
                                                           ,518
                                                           ,519
                                                           ,520
                                                           ,521
                                                           ,522
                                                           ,530
                                                           ,531
                                                           ,532
                                                           ,533
                                                           ,534
                                                           ,535
                                                           ,536)
/

--
-- New Data
--
Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_DESCR)
 Values
   ('HIG', 510, 'Process Created');
   
Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_DESCR)
 Values
   ('HIG', 511, 'Process Complete');

Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_DESCR)
 Values
   ('HIG', 512, 'Code is invalid and will not execute');

Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_DESCR)
 Values
   ('HIG', 513, 'No changes are permitted');



Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_DESCR)
 Values
   ('HIG', 514, 'Process could not be dropped');

Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_DESCR)
 Values
   ('HIG', 515, 'Invalid calendar string');

Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_DESCR)
 Values
   ('HIG', 516, 'Operation is not permitted on this process');


Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_DESCR)
 Values
   ('HIG', 517, 'Process cannot be submitted because the limit for this process type has been reached');


Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_DESCR)
 Values
   ('HIG', 518, 'Uploading ... Please Wait');


Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_DESCR)
 Values
   ('HIG', 519, 'The maximum number of files of a given type has been exceeded.');

Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_DESCR)
 Values
   ('HIG', 520, 'The minimum number of files of a given type have not been submitted.');



Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_DESCR)
 Values
   ('HIG', 521, 'No additional information is available for this process execution');


Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_DESCR)
 Values
   ('HIG', 522, 'Location is invalid.'||chr(10)||'Where necessary, locations must end with a ''\'' or ''/''');
   
Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_DESCR)
 Values
   ('HIG', 530, 'No log to view - Process execution has not yet started.');
   
Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_DESCR)
 Values
   ('HIG', 531, 'Process Started');   
   
Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_DESCR, NER_CAUSE)
 Values
   ('HIG', 532, 'Extension contains invalid characters.', '%*. are not permitted.');

Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_DESCR)
 Values
   ('HIG', 533, 'You are not permitted to submit a process.  
Review process types and process type roles using the ''Process Types'' module.');

Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_DESCR)
 Values
   ('HIG', 534, 'Process Type does not exist');

Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_DESCR)
 Values
   ('HIG', 535, 'File Type for this Process Type does not exist');

Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_DESCR)
 Values
   ('HIG', 536, 'Directory does not exist');

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Process Framework - Sequence Associations
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108982
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- To support process framework
-- 
------------------------------------------------------------------
--
-- Start with a clear out - to make this re-runnable
--
delete from HIG_SEQUENCE_ASSOCIATIONS where  hsa_table_name in ('HIG_FILE_LIST'
                                                               ,'HIG_PROCESSES'
                                                               ,'HIG_PROCESS_FILES'
                                                               ,'HIG_PROCESS_TYPES'
                                                               ,'HIG_PROCESS_TYPE_FILES'
                                                               ,'HIG_SCHEDULING_FREQUENCIES');

--
-- New Data
--
Insert into HIG_SEQUENCE_ASSOCIATIONS
   (HSA_TABLE_NAME, HSA_COLUMN_NAME, HSA_SEQUENCE_NAME)
 Values
   ('HIG_FILE_LIST', 'HFL_ID', 'HFL_ID_SEQ');

Insert into HIG_SEQUENCE_ASSOCIATIONS
   (HSA_TABLE_NAME, HSA_COLUMN_NAME, HSA_SEQUENCE_NAME)
 Values
   ('HIG_PROCESSES', 'HP_PROCESS_ID', 'HP_PROCESS_ID_SEQ');

Insert into HIG_SEQUENCE_ASSOCIATIONS
   (HSA_TABLE_NAME, HSA_COLUMN_NAME, HSA_SEQUENCE_NAME)
 Values
   ('HIG_PROCESS_FILES', 'HPF_FILE_ID', 'HPF_FILE_ID_SEQ');

Insert into HIG_SEQUENCE_ASSOCIATIONS
   (HSA_TABLE_NAME, HSA_COLUMN_NAME, HSA_SEQUENCE_NAME)
 Values
   ('HIG_PROCESS_TYPES', 'HPT_PROCESS_TYPE_ID', 'HPT_PROCESS_TYPE_ID_SEQ');

Insert into HIG_SEQUENCE_ASSOCIATIONS
   (HSA_TABLE_NAME, HSA_COLUMN_NAME, HSA_SEQUENCE_NAME)
 Values
   ('HIG_PROCESS_TYPE_FILES', 'HPTF_FILE_TYPE_ID', 'HPTF_FILE_TYPE_ID_SEQ');

Insert into HIG_SEQUENCE_ASSOCIATIONS
   (HSA_TABLE_NAME, HSA_COLUMN_NAME, HSA_SEQUENCE_NAME)
 Values
   ('HIG_SCHEDULING_FREQUENCIES', 'HSFR_FREQUENCY_ID', 'HSFR_FREQUENCY_ID_SEQ');
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Process Framework - Check Constraint Associations
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108982
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- To support process framework
-- 
------------------------------------------------------------------
--
-- Start with a clear out - to make this re-runnable
--
delete from hig_check_constraint_assocs where hcca_table_name like 'HIG_PROCESS%'
/

--
-- New Data
--
Insert into HIG_CHECK_CONSTRAINT_ASSOCS
   (HCCA_CONSTRAINT_NAME, HCCA_TABLE_NAME, HCCA_NER_APPL, HCCA_NER_ID)
 Values
   ('HPTF_INPUT_DESTINATION_CHK', 'HIG_PROCESS_TYPE_FILES', 'HIG', 522);

Insert into HIG_CHECK_CONSTRAINT_ASSOCS
   (HCCA_CONSTRAINT_NAME, HCCA_TABLE_NAME, HCCA_NER_APPL, HCCA_NER_ID)
 Values
   ('HPTF_OUTPUT_DESTINATION_CHK', 'HIG_PROCESS_TYPE_FILES', 'HIG', 522);

Insert into HIG_CHECK_CONSTRAINT_ASSOCS
   (HCCA_CONSTRAINT_NAME, HCCA_TABLE_NAME, HCCA_NER_APPL, HCCA_NER_ID)
 Values
   ('HPF_DESTINATION_CHK', 'HIG_PROCESS_FILES', 'HIG', 522);
   

Insert into HIG_CHECK_CONSTRAINT_ASSOCS
   (HCCA_CONSTRAINT_NAME, HCCA_TABLE_NAME, HCCA_NER_APPL, HCCA_NER_ID)
 Values
   ('HPTE_EXTENSION_CHARACTER_CHK', 'HIG_PROCESS_TYPE_FILE_EXT', 'HIG', 532);
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New Category for Audit/Alert Assets
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108984
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- New category 'A' introduced to create assets for Audit and Alert
-- 
------------------------------------------------------------------
INSERT INTO nm_inv_categories (NIC_CATEGORY,NIC_DESCR) 
SELECT 'A','Alert and Audit Metamodels'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM nm_inv_categories
                   WHERE NIC_CATEGORY = 'A');


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Navigator/Audit/Alert Error Messages
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108984
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- ASSOCIATED DEVELOPMENT TASK
-- 108985
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- ASSOCIATED DEVELOPMENT TASK
-- 108986
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Navigator/Audit/Alert Error Messages
-- 
------------------------------------------------------------------
--
-- Start with a clear out - to make this re-runnable
--
delete from nm_errors where ner_appl = 'HIG' and ner_id in (523,524,525,526,527,528,529,537)
/


--
-- New Data
--

INSERT INTO nm_errors
SELECT 'HIG'
      , 523
      , NULL
      , 'Unable to create trigger.'
      , NULL
  FROM dual
 WHERE NOT EXISTS
   (SELECT 1 FROM nm_errors
     WHERE ner_appl = 'HIG'
       AND ner_id = 523);



INSERT INTO nm_errors
SELECT 'HIG'
      , 524
      , NULL
      , 'Database trigger exists against this audit record, please drop the trigger before deleting this record.'
      , NULL
  FROM dual
 WHERE NOT EXISTS
   (SELECT 1 FROM nm_errors
     WHERE ner_appl = 'HIG'
       AND ner_id = 524);


INSERT INTO nm_errors
SELECT 'HIG'
      , 525
      , NULL
      , 'Invalid Query.'
      , NULL
  FROM dual
 WHERE NOT EXISTS
   (SELECT 1 FROM nm_errors
     WHERE ner_appl = 'HIG'
       AND ner_id = 525);

INSERT INTO nm_errors
SELECT 'HIG'
      , 526
      , NULL
      , 'The alert Schedule Method must be selected before proceeding.'
      , NULL
  FROM dual
 WHERE NOT EXISTS
   (SELECT 1 FROM nm_errors
     WHERE ner_appl = 'HIG'
       AND ner_id = 526);


INSERT INTO nm_errors
SELECT 'HIG'
      , 527
      , NULL
      , 'The trigger must be re-created to reflect changes made to the alert definition.  Please use the Create Trigger button.'
      , NULL
  FROM dual
 WHERE NOT EXISTS
   (SELECT 1 FROM nm_errors
     WHERE ner_appl = 'HIG'
       AND ner_id = 527);

INSERT INTO nm_errors
SELECT 'HIG'
      , 528
      , NULL
      , 'Name is already in use.'
      , NULL
  FROM dual
 WHERE NOT EXISTS
   (SELECT 1 FROM nm_errors
     WHERE ner_appl = 'HIG'
       AND ner_id = 528);

INSERT INTO nm_errors
SELECT 'HIG'
      , 529
      , NULL
      , 'Conditions and operators will be set to default values in Normal Query mode.'
      , NULL
  FROM dual
 WHERE NOT EXISTS
   (SELECT 1 FROM nm_errors
     WHERE ner_appl = 'HIG'
       AND ner_id = 529);

INSERT INTO nm_errors
SELECT 'HIG'
      , 537
      , NULL
      , 'Cannot delete this query, it is linked with the Alert.'
      , NULL
  FROM dual
 WHERE NOT EXISTS
   (SELECT 1 FROM nm_errors
     WHERE ner_appl = 'HIG'
       AND ner_id = 537);

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Navigator/Audit/Alert  - Modules and Module Roles
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108984
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- ASSOCIATED DEVELOPMENT TASK
-- 108985
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- ASSOCIATED DEVELOPMENT TASK
-- 108986
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Navigator/Audit/Alert  - Modules and Module Roles
-- 
------------------------------------------------------------------
--
-- Start with a clear out - to make this re-runnable
--
delete from  HIG_MODULE_BLOCKS where hmb_module_name = 'HIG1505';

delete from hig_module_roles
where  hmr_module in ('HIG1520',
                      'HIG1525',
                      'HIG1500',
                      'HIG1505',
                      'NAVIGATOR'                    
                    );                                                                                    


delete from hig_modules
where  hmo_module in ('HIG1520',
                      'HIG1525',
                      'HIG1500',
                      'HIG1505',
                      'NAVIGATOR'                    
                    );                                                                                    
                     
--
-- New Data
--

insert into hig_modules  values('HIG1520','Alert Setup','hig1520','fmx',null,'N','N','HIG','FORM');

insert into hig_module_roles  values('HIG1520','HIG_ADMIN','NORMAL');

insert into hig_modules  values('HIG1525','Alert Logs','hig1525','fmx',null,'N','N','HIG','FORM');

insert into hig_module_roles  values('HIG1525','HIG_USER','NORMAL');

insert into hig_modules  values('NAVIGATOR','Navigator','navigator','fmx',null,'N','N','HIG','FORM');

insert into hig_module_roles  values('NAVIGATOR','HIG_USER','NORMAL');


insert into hig_modules  values('HIG1500','Audit Setup','hig1500','fmx',null,'N','N','HIG','FORM');

insert into hig_module_roles  values('HIG1500','HIG_ADMIN','NORMAL');

insert into hig_modules  values('HIG1505','Audits','hig1505','fmx',null,'N','N','HIG','FORM');

insert into hig_module_roles  values('HIG1505','HIG_USER','NORMAL');

insert into HIG_MODULE_BLOCKS values ('HIG1505','HAUD',sysdate,null,user,null)  ;


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Navigator/Audit/Alert - Launchpad
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108984
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- ASSOCIATED DEVELOPMENT TASK
-- 108985
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- ASSOCIATED DEVELOPMENT TASK
-- 108986
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Navigator/Audit/Alert - Launchpad
-- 
------------------------------------------------------------------
Insert into hig_standard_favourites 
Select 'HIG_REFERENCE_MAIL','HIG1520','Alert Setup','M',8 from dual
Where Not Exists (Select 1 from hig_standard_favourites Where hstf_parent = 'HIG_REFERENCE_MAIL' And hstf_child = 'HIG1520')  ;

Insert into hig_standard_favourites 
Select 'HIG_REFERENCE_MAIL','HIG1525','Alert Logs','M',8 from dual
Where Not Exists (Select 1 from hig_standard_favourites Where hstf_parent = 'HIG_REFERENCE_MAIL' And hstf_child = 'HIG1525');

Insert into hig_standard_favourites 
Select 'HIG_REFERENCE','HIG1500','Audit Setup','M',22 from dual
Where Not Exists (Select 1 from hig_standard_favourites Where hstf_parent = 'HIG_REFERENCE' And hstf_child = 'HIG1500')  ;

Insert into hig_standard_favourites 
Select 'HIG_REFERENCE','HIG1505','Audit Details','M',23 from dual
Where Not Exists (Select 1 from hig_standard_favourites Where hstf_parent = 'HIG_REFERENCE' And hstf_child = 'HIG1505');


Insert into hig_standard_favourites 
Select 'NET_INVENTORY','NAVIGATOR','EXOR Navigator','M',41 from dual
Where Not Exists (Select 1 from hig_standard_favourites Where hstf_parent = 'NET_INVENTORY' And hstf_child = 'NAVIGATOR');

------------------------------------------------------------------


------------------------------------------------------------------

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

