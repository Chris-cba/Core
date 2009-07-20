------------------------------------------------------------------
-- nm4054_nm4100_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4054_nm4100_metadata_upg.sql-arc   3.5   Jul 20 2009 16:24:46   aedwards  $
--       Module Name      : $Workfile:   nm4054_nm4100_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 20 2009 16:24:46  $
--       Date fetched Out : $Modtime:   Jul 20 2009 16:23:28  $
--       Version          : $Revision:   3.5  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009

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
PROMPT GAZAUTOQRY Product Option
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED PROBLEM MANAGER LOG#
-- 719701  Main Roads Western Australia
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- This Product option allows you to choose if you want form nm1100 to automatically query back its results
-- 
------------------------------------------------------------------
INSERT INTO hig_option_list
(
   hol_id, hol_product, hol_name, hol_remarks, hol_domain, hol_datatype, hol_mixed_case, hol_user_option
)
  SELECT 'GAZAUTOQRY',
         'HIG',
         'Gazetteer Results Auto Query',
         'This must be a Y or N. If the option is set to Y the data will automatically populate the results block in the Gazetteer when you click/tab into it.',
         'Y_OR_N',
         'VARCHAR2',
         'N',
         'Y'
  FROM DUAL
  WHERE NOT EXISTS (SELECT 'X'
                    FROM hig_option_list
                    WHERE hol_id = 'GAZAUTOQRY');

INSERT INTO hig_option_values
(
   hov_id, hov_value
)
  SELECT 'GAZAUTOQRY', 'Y'
  FROM DUAL
  WHERE NOT EXISTS (SELECT 'X'
                    FROM hig_option_values
                    WHERE hov_id = 'GAZAUTOQRY');
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Hig Options for Exclusive Group Type
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- New Hig Options added to allows user to override exclusive group type
-- 
------------------------------------------------------------------
--
INSERT into HIG_OPTIONS (
HOP_PRODUCT
,HOP_ID
,HOP_NAME
,HOP_VALUE
,HOP_REMARKS
) select
'NET'
,'GRPXCLOVWR'
,'Exclusive Group type Override'
,'N'
,'When value is set to ''Y'' this will allow user to override the Exclusive Group Type.'
from dual
where not exists (
 select 'not exists'
 from HIG_OPTIONS
where HOP_ID = 'GRPXCLOVWR'
and HOP_PRODUCT = 'NET'
);
--

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Bulk Attribute Update
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- New Error messages for bulk attribute update
-- 
------------------------------------------------------------------
INSERT INTO nm_errors
SELECT 'NET'
      , 460
      , NULL
      , 'This selected Group Type is Exclusive. The selected Network Elements will be End Dated from existing Groups of this type. Do you wish to continue?'
      , NULL
  FROM dual
 WHERE NOT EXISTS
   (SELECT 1 FROM nm_errors
     WHERE ner_appl = 'NET'
       AND ner_id = 460);

       
INSERT INTO nm_errors
SELECT 'NET'
      , 461
      , NULL
      , 'One or more of the selected Network Elements are already members of a Group of this type. Do you want to End Date existing Group Memberships for affected Elements?'
      , NULL
  FROM dual
 WHERE NOT EXISTS
   (SELECT 1 FROM nm_errors
     WHERE ner_appl = 'NET'
       AND ner_id = 461);  

INSERT INTO HIG_MODULES
       (HMO_MODULE
       ,HMO_TITLE
       ,HMO_FILENAME
       ,HMO_MODULE_TYPE
       ,HMO_FASTPATH_OPTS
       ,HMO_FASTPATH_INVALID
       ,HMO_USE_GRI
       ,HMO_APPLICATION
       ,HMO_MENU
       )
SELECT 
        'NM0116'
       ,'Bulk Network Update'
       ,'nm0116'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'NET'
       ,'FORM' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0116');
                   

INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NET_MANAGEMENT'
       ,'NM0116'
       ,'Bulk Network Update'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_NET_MANAGEMENT'
                    AND  HSTF_CHILD  = 'NM0116');
                    

INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE,HMR_MODE
       )
SELECT 
        'NM0116'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0116'
                    AND  HMR_ROLE = 'NET_ADMIN');

                    
     


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Metadata update for WEEKEND product option
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED PROBLEM MANAGER LOG#
-- 711146  Gloucestershire County Council
-- 
-- 
-- DEVELOPMENT COMMENTS (STUART MARSHALL)
-- Correction to WEEKEND metadata
-- 
------------------------------------------------------------------
update hig_option_list
set hol_remarks = 'This option must contain a list of numeric values in the range 1 to 7.
They define the days of the week which constitute the weekend in a particular country, for use in working day calculations.  The following convention must be adopted:
1=Sunday 2=Monday ... 7=Saturday.
Therefore in the UK this option will contain the value 1,7
In the Inspection Loader (MAI2200), when repairs are loaded a repair due date calculation takes place. This may be based on working days or calendar days as indicated by the defect priority rules.
In Maintain Defects (MAI3806) a similar calculation takes place when a repair is created.'
where HOL_ID = 'WEEKEND'
and HOL_PRODUCT = 'HIG';

update hig_option_values
set hov_value = '1, 7'
where hov_id = 'WEEKEND';

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Grant Create Job to highways owner
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Add privs to create a scheduled job to Highways owner
-- 
------------------------------------------------------------------
BEGIN
  EXECUTE IMMEDIATE 'grant create job to '||user;
END;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Create maintenance jobs
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Jobs to drop data in tables
-- 
------------------------------------------------------------------
DECLARE
  ex_no_exists       EXCEPTION;
  PRAGMA             EXCEPTION_INIT (ex_no_exists,-27475);
BEGIN
--
  BEGIN
    nm3jobs.drop_job ( pi_job_name => 'CLEAROUT_GDO_DATA'
                     , pi_force    => TRUE );
  EXCEPTION
    WHEN ex_no_exists THEN NULL;
  END;
--
  BEGIN
    nm3jobs.drop_job ( pi_job_name => 'CLEAROUT_NGQI_DATA'
                     , pi_force    => TRUE );
  EXCEPTION
    WHEN ex_no_exists THEN NULL;
  END;
--
  BEGIN
    nm3jobs.drop_job ( pi_job_name => 'CLEAROUT_ND_DATA'
                     , pi_force    => TRUE );
  EXCEPTION
    WHEN ex_no_exists THEN NULL;
  END;
--
  nm3jobs.create_job
              ( pi_job_name   => 'CLEAROUT_GDO_DATA'
              , pi_job_action => 'BEGIN nm3data.cleardown_gdo; END;'
              , pi_comments   => 'Created by nm3jobs at '||SYSDATE );
--
  nm3jobs.create_job
              ( pi_job_name   => 'CLEAROUT_NGQI_DATA'
              , pi_job_action => 'BEGIN nm3data.cleardown_ngqi; END;'
              , pi_comments   => 'Created by nm3jobs at '||SYSDATE );
--
  nm3jobs.create_job
              ( pi_job_name   => 'CLEAROUT_ND_DATA'
              , pi_job_action => 'BEGIN nm3data.cleardown_nd; END;'
              , pi_comments   => 'Created by nm3jobs at '||SYSDATE );
END;
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Hig user details
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Hig User Details Metadata
-- 
------------------------------------------------------------------
INSERT INTO HIG_MODULES
       (HMO_MODULE
       ,HMO_TITLE
       ,HMO_FILENAME
       ,HMO_MODULE_TYPE
       ,HMO_FASTPATH_OPTS
       ,HMO_FASTPATH_INVALID
       ,HMO_USE_GRI
       ,HMO_APPLICATION
       ,HMO_MENU
       )
SELECT 
        'HIG1834'
       ,'Hig User Contact Details'
       ,'hig1834'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG1834');
                   
--

INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_SECURITY'
       ,'HIG1834'
       ,'User Contact Details'
       ,'M'
       ,2.1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_SECURITY'
                    AND  HSTF_CHILD = 'HIG1834');
                    
--

INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE,HMR_MODE
       )
SELECT 
        'HIG1834'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1834'
                    AND  HMR_ROLE = 'HIG_ADMIN');

                    
--

INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'USER_CONTACT_TYPES'
       ,'HIG'
       ,'User Contact Types'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'USER_CONTACT_TYPES');
                    
--

-- 

-- 
------------------------------------------------------------------
Prompt Inserting into hig_codes for USER_CONTACT_TYPES domain
--

Insert Into Hig_Codes
(
Hco_Domain,
Hco_Code,
Hco_Meaning,
Hco_System,
Hco_Seq,
Hco_Start_Date,
Hco_End_Date
)
Select  'USER_CONTACT_TYPES',
        'Work',
        'Work Number',
        'N',
        10,
        To_Date('01-JAN-1900','dd-mon-yyyy'),
        Null 
From    Dual
Where   Not Exists (Select   Null 
                    From     Hig_Codes   Hc
                    Where    hc.Hco_Domain  = 'USER_CONTACT_TYPES'
                    And      hc.Hco_Code    = 'Work'
                    );
--

Insert Into Hig_Codes
(
Hco_Domain,
Hco_Code,
Hco_Meaning,
Hco_System,
Hco_Seq,
Hco_Start_Date,
Hco_End_Date
)
Select  'USER_CONTACT_TYPES',
        'Mobile',
        'Mobile Number',
        'N',
        20,
        To_Date('01-JAN-1900','dd-mon-yyyy'),
        Null 
From    Dual
Where   Not Exists (Select   Null 
                    From     Hig_Codes   Hc
                    Where    hc.Hco_Domain  = 'USER_CONTACT_TYPES'
                    And      hc.Hco_Code    = 'Mobile'
                    );
--

Insert Into Hig_Codes
(
Hco_Domain,
Hco_Code,
Hco_Meaning,
Hco_System,
Hco_Seq,
Hco_Start_Date,
Hco_End_Date
)
Select  'USER_CONTACT_TYPES',
        'Home',
        'Home Number',
        'N',
        30,
        To_Date('01-JAN-1900','dd-mon-yyyy'),
        Null 
From    Dual
Where   Not Exists (Select   Null 
                    From     Hig_Codes   Hc
                    Where    hc.Hco_Domain  = 'USER_CONTACT_TYPES'
                    And      hc.Hco_Code    = 'Home'
                    );
--

Insert Into Hig_Codes
(
Hco_Domain,
Hco_Code,
Hco_Meaning,
Hco_System,
Hco_Seq,
Hco_Start_Date,
Hco_End_Date
)
Select  'USER_CONTACT_TYPES',
        'Fax',
        'Fax Number',
        'N',
        40,
        To_Date('01-JAN-1900','dd-mon-yyyy'),
        Null 
From    Dual
Where   Not Exists (Select   Null 
                    From     Hig_Codes   Hc
                    Where    hc.Hco_Domain  = 'USER_CONTACT_TYPES'
                    And      hc.Hco_Code    = 'Fax'
                    );
--


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Module Types
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Cosolidate HIG_CODES - Module_Type metadata from previous release
-- 
------------------------------------------------------------------
INSERT INTO hig_codes
SELECT 'MODULE_TYPE', 'APX', 'APEX Report', 'Y', 2, NULL, NULL
  FROM dual
 WHERE NOT EXISTS
  (SELECT 1 FROM hig_codes
    WHERE hco_domain = 'MODULE_TYPE'
      AND hco_code = 'APX')
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Add missing doc media entries
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (KIERAN DAWSON)
-- DOC_MEDIA metadata update
-- 
------------------------------------------------------------------
BEGIN
  INSERT INTO DOC_MEDIA (DMD_ID,
                       DMD_NAME,
                       DMD_DESCR,
                       DMD_DISPLAY_COMMAND,
                       DMD_IMAGE_COMMAND1,
                       DMD_FILE_EXTENSION,
                       DMD_ICON)
    VALUES   (3,
            'WORD_TEMPLATES',
            'Microsoft Word Works Order Templates',
            'c:\Program Files\Microsoft Office\Office\winword',
            'winword',
            'DOT',
            'doc_icon.gif');
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN NULL;
  WHEN OTHERS THEN RAISE;
END;
/

BEGIN
  INSERT INTO DOC_MEDIA (DMD_ID,
                       DMD_NAME,
                       DMD_DESCR,
                       DMD_DISPLAY_COMMAND,
                       DMD_IMAGE_COMMAND1,
                       DMD_FILE_EXTENSION)
  VALUES   (4,
            'EXCEL_DOCUMENTS',
            'Microsoft Excel Docs',
            'c:\Program Files\Microsoft Office\Office\excel',
            'excel',
            'XLS');
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN NULL;
  WHEN OTHERS THEN RAISE;
END;
/

BEGIN
  INSERT INTO DOC_MEDIA (DMD_ID,
                       DMD_NAME,
                       DMD_DESCR,
                       DMD_DISPLAY_COMMAND,
                       DMD_IMAGE_COMMAND1,
                       DMD_FILE_EXTENSION)
  VALUES   (5,
            'ADOBE_DOCUMENTS',
            'Adobe Docs',
            'C:\Program Files\Adobe\Reader 8.0\Reader\AcroRd32',
            'AcroRd32',
            'PDF');
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN NULL;
  WHEN OTHERS THEN RAISE;
END;
/

BEGIN
  INSERT INTO DOC_MEDIA (DMD_ID,
                       DMD_NAME,
                       DMD_DESCR,
                       DMD_DISPLAY_COMMAND,
                       DMD_IMAGE_COMMAND1,
                       DMD_FILE_EXTENSION)
  VALUES   (6,
            'JPEG_IMAGES',
            'Jpeg images',
            'C:\Program Files\Internet Explorer\IEXPLORE.EXE',
            'iexplore',
            'JPG');
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN NULL;
  WHEN OTHERS THEN RAISE;
END;
/

BEGIN
  INSERT INTO DOC_MEDIA (DMD_ID,
                       DMD_NAME,
                       DMD_DESCR,
                       DMD_DISPLAY_COMMAND,
                       DMD_IMAGE_COMMAND1,
                       DMD_FILE_EXTENSION)
  VALUES   (7,
            'GIF_IMAGES',
            'GIF images',
            'C:\Program Files\Internet Explorer\IEXPLORE.EXE',
            'iexplore',
            'GIF');
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN NULL;
  WHEN OTHERS THEN RAISE;
END;
/

BEGIN
  INSERT INTO DOC_MEDIA (DMD_ID,
                       DMD_NAME,
                       DMD_DESCR,
                       DMD_DISPLAY_COMMAND,
                       DMD_IMAGE_COMMAND1,
                       DMD_FILE_EXTENSION)
  VALUES   (8,
            'BMP_IMAGES',
            'BMP Images',
            'C:\Program Files\Internet Explorer\IEXPLORE.EXE',
            'iexplore',
            'BMP');
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN NULL;
  WHEN OTHERS THEN RAISE;
END;
/

BEGIN
  INSERT INTO DOC_MEDIA (DMD_ID,
                       DMD_NAME,
                       DMD_DESCR,
                       DMD_DISPLAY_COMMAND,
                       DMD_IMAGE_COMMAND1,
                       DMD_FILE_EXTENSION)
  VALUES   (9,
            'CSV_FILES',
            'Comma Separated Files',
            'c:\Program Files\Microsoft Office\Office\excel',
            'excel',
            'CSV');
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN NULL;
  WHEN OTHERS THEN RAISE;
END;
/

BEGIN
  INSERT INTO DOC_MEDIA (DMD_ID,
                       DMD_NAME,
                       DMD_DESCR,
                       DMD_DISPLAY_COMMAND,
                       DMD_IMAGE_COMMAND1,
                       DMD_FILE_EXTENSION)
  VALUES   (10,
            'OUTLOOK_MESSGES',
            'Outlook Messages',
            'C:\Program Files\Internet Explorer\IEXPLORE.EXE',
            'iexplore',
            'MSG');
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN NULL;
  WHEN OTHERS THEN RAISE;
END;
/

BEGIN
  INSERT INTO DOC_MEDIA (DMD_ID,
                       DMD_NAME,
                       DMD_DESCR,
                       DMD_DISPLAY_COMMAND,
                       DMD_IMAGE_COMMAND1,
                       DMD_FILE_EXTENSION)
  VALUES   (11,
            'WEBPAGES',
            'Webpages',
            'C:\Program Files\Internet Explorer\IEXPLORE.EXE',
            'iexplore',
            'HTML');
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN NULL;
  WHEN OTHERS THEN RAISE;
END;
/

BEGIN
  INSERT INTO DOC_MEDIA (DMD_ID,
                       DMD_NAME,
                       DMD_DESCR,
                       DMD_DISPLAY_COMMAND,
                       DMD_IMAGE_COMMAND1,
                       DMD_FILE_EXTENSION)
  VALUES   (12,
            'TEXT_DOCS',
            'Text docs',
            'C:\windows\notepad',
            'notepad',
            'TXT');
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN NULL;
  WHEN OTHERS THEN RAISE;
END;
/

BEGIN
  INSERT INTO DOC_MEDIA (
                          DMD_ID,
                          DMD_NAME,
                          DMD_DESCR,
                          DMD_DISPLAY_COMMAND,
                          DMD_FILE_EXTENSION
           )
  VALUES   (
               13,
               'DWF_FILES',
               'DWF Files',
               '"C:\Program Files\Autodesk\Autodesk Design Review\DesignReview"',
               'DWF'
           );
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN NULL;
  WHEN OTHERS THEN RAISE;
END;
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Layer Tool Tree
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Consolidate the MAI addtion from previous releases.
-- 
------------------------------------------------------------------
INSERT INTO nm_layer_tree
   SELECT   'MAI',
            'WOL',
            'Work Order Lines Layer',
            'M',
            '20'
     FROM   DUAL
    WHERE   NOT EXISTS (SELECT   1
                          FROM   nm_layer_tree
                         WHERE   nltr_parent = 'MAI' 
                           AND nltr_child = 'WOL');


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Update hig_option_list and hig_option_values
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (KIERAN DAWSON)
-- Update hig_option_list and hig_option_values
-- 
------------------------------------------------------------------
  Insert into HIG_OPTION_LIST
   (HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DATATYPE, HOL_MIXED_CASE,
      HOL_USER_OPTION)
 Values
   ('GRPXCLOVWR', 'NET', 'Exclusive Group type Override',
      'When value is set to ''Y'' this will allow user to override the Exclusive Group Type.'
      , 'VARCHAR2', 'N', 'N');

Insert into HIG_OPTION_VALUES
   (HOV_ID, HOV_VALUE)
 Values
   ('GRPXCLOVWR', 'N');
------------------------------------------------------------------


------------------------------------------------------------------

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

