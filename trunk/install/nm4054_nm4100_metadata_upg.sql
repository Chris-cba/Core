------------------------------------------------------------------
-- nm4054_nm4100_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4054_nm4100_metadata_upg.sql-arc   3.13   Jul 04 2013 14:16:24   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4054_nm4100_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:16:24  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:20  $
--       Version          : $Revision:   3.13  $
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.

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
UPDATE hig_options
   SET hop_datatype = 'VARCHAR2'
 WHERE hop_id = 'WEEKEND'
   AND hop_product = 'HIG';

update hig_option_list
set hol_remarks = 'This option must contain a list of numeric values in the range 1 to 7.
They define the days of the week which constitute the weekend in a particular country, for use in working day calculations.  The following convention must be adopted:
7=Sunday 2=Monday ... 6=Saturday.
Therefore in the UK this option will contain the value 6,7
In the Inspection Loader (MAI2200), when repairs are loaded a repair due date calculation takes place. This may be based on working days or calendar days as indicated by the defect priority rules.
In Maintain Defects (MAI3806) a similar calculation takes place when a repair is created.'
where HOL_ID = 'WEEKEND'
and HOL_PRODUCT = 'HIG';

update hig_option_values
set hov_value = '6, 7'
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
-- Change CST: Metadata is required to show the new TMA tabs in the GIS0020.
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

INSERT INTO NM_LAYER_TREE ( NLTR_PARENT
                          , NLTR_CHILD
                          , NLTR_DESCR
                          , NLTR_TYPE
                          , NLTR_ORDER)
(SELECT 'ROOT'
      , 'TMA'
      , 'Traffic Management Act'
      , 'F'
      , 130 
FROM DUAL
WHERE NOT EXISTS (SELECT 'X'
                    FROM nm_layer_tree
                   WHERE NLTR_PARENT = 'ROOT'
                     AND NLTR_CHILD = 'TMA'));

INSERT INTO NM_LAYER_TREE ( NLTR_PARENT
                          , NLTR_CHILD
                          , NLTR_DESCR
                          , NLTR_TYPE
                          , NLTR_ORDER)
(SELECT 'TMA'
     , 'TM1'
     , 'TMA Layer'
     , 'M'
     , 10 
FROM DUAL
WHERE NOT EXISTS (SELECT 'X'
                    FROM nm_layer_tree
                   WHERE NLTR_PARENT = 'TMA'
                     AND NLTR_CHILD = 'TM1'));

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
Insert Into hig_option_list( hol_id
                           , hol_product
                           , hol_name
                           , hol_remarks
                           , hol_datatype
                           , hol_mixed_case
                           , hol_user_option
                           )
                      Select 'GRPXCLOVWR'
                           , 'NET'
                           , 'Exclusive Group type Override'
                           , 'When value is set to ''Y'' this will allow user to override the Exclusive Group Type.'
                           , 'VARCHAR2'
                           , 'N'
                           , 'N'
                      From   Dual
                      Where Not Exists( Select 1
                                        From   hig_option_list
                                        Where  hol_id = 'GRPXCLOVWR'
                                      );
                                      
Insert Into hig_option_values( hov_id
                             , hov_value
                             )
                        Select 'GRPXCLOVWR'
                             , 'N'
                        From   Dual
                        Where Not Exists( Select 1
                                          From   hig_option_values
                                          Where  hov_id = 'GRPXCLOVWR'
                                        );
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Remove redundant module
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- Remove module originally used to implement cross references between NSG streets
-- 
------------------------------------------------------------------
delete from hig_module_roles
where hmr_module = 'NM0600'
/
delete from hig_modules
where hmo_module = 'NM0600'
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Correct Non Linear Network types with Units set
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Nullify units on Non Linear network types
-- 
------------------------------------------------------------------
SET serveroutput ON
DECLARE
  CURSOR get_faulty
  IS
    SELECT nt_type, nt_unique, nt_length_unit FROM nm_types
     WHERE nt_length_unit IS NOT NULL
       AND nt_linear = 'N';
  l_tab_nt_unique nm3type.tab_varchar30;
  l_tab_nt_type   nm3type.tab_varchar4;
  l_tab_nt_unit   nm3type.tab_number;
BEGIN
--
  dbms_output.put_line ('==============================================================');
  dbms_output.put_line ('Checking for faulty non-linear network types using Unit Types');
  dbms_output.put_line ('==============================================================');
--
   OPEN get_faulty;
  FETCH get_faulty 
   BULK COLLECT INTO l_tab_nt_type, l_tab_nt_unique, l_tab_nt_unit;
  CLOSE get_faulty;
--
  IF l_tab_nt_type.COUNT > 0
  THEN
  --
    FOR i IN 1..l_tab_nt_type.COUNT LOOP
    -- nm_units
      dbms_output.put_line ('Idenfified '||l_tab_nt_unique(i)
                         ||' illegally using unit type '
                         ||nm3get.get_un(l_tab_nt_unit(i)).un_unit_name);
    --
    END LOOP;
  --
    FORALL z IN 1..l_tab_nt_type.COUNT
      UPDATE nm_types
         SET nt_length_unit = NULL
       WHERE nt_type = l_tab_nt_type(z);
    dbms_output.put_line(SQL%ROWCOUNT||' network types corrected'); 
  --
  ELSE
    dbms_output.put_line ('No faulty non-linear network types found');
  END IF;
  dbms_output.put_line ('==============================================================');
--
END;
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Resequence ita_inv_type
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- Resequencing the ita_inv_type so that several are not set to 99 and set the  ita_inspectable on the basis of the ita_inv_type field
-- 
------------------------------------------------------------------
DECLARE

CURSOR cur_inv_type_list IS  SELECT DISTINCT ita_inv_type ita_inv_type
                               FROM nm_inv_type_attribs_all 
                              WHERE ita_disp_seq_no = 99;

  PROCEDURE resequence_inv_type(p_inv_type IN VARCHAR2) IS
  
    v_nn_count number(10);
    v_max_seq_no number(10);

    CURSOR cur_nn_atts is  select ita_inv_type
                                , ita_attrib_name
                             from NM_INV_TYPE_ATTRIBS_ALL
                            where ita_inv_type = p_inv_type
                              and ita_disp_seq_no = 99;


  BEGIN

  -- Get the number of 99 attributes
    SELECT COUNT(*) 
    INTO v_nn_count
    FROM nm_inv_type_attribs_all 
    WHERE ita_inv_type = p_inv_type
      AND ita_disp_seq_no = 99;

    -- Only continue if there are 99 values to change.
    IF v_nn_count > 0 THEN


    --Get the highest none 99 value 
    SELECT NVL(MAX(ita_disp_seq_no), 0)
     INTO v_max_seq_no
     FROM nm_inv_type_attribs_all
     WHERE ita_inv_type = p_inv_type
     AND ita_disp_seq_no <> 99;
    
    FOR rec_nn_atts IN cur_nn_atts 
    
    LOOP
        v_max_seq_no:= v_max_seq_no + 1;
        IF v_max_seq_no = 99 THEN
          v_max_seq_no:= v_max_seq_no + 1;
        END IF;
    
        UPDATE nm_inv_type_attribs_all
           SET ita_disp_seq_no = v_max_seq_no
         WHERE ita_inv_type = rec_nn_atts.ita_inv_type
           AND ita_attrib_name = rec_nn_atts.ita_attrib_name;
      END LOOP;
    
    END IF;

  END;

BEGIN

  EXECUTE IMMEDIATE 'ALTER TABLE nm_inv_type_attribs_all DISABLE ALL TRIGGERS';

  EXECUTE IMMEDIATE  'UPDATE nm_inv_type_attribs_all 
                         SET ita_inspectable = ''N''
                       WHERE ita_inspectable = ''Y''
                         AND ita_disp_seq_no = 99';

  FOR rec_inv_type_list IN cur_inv_type_list 
  LOOP
  --
    resequence_inv_type(p_inv_type => rec_inv_type_list.ita_inv_type);
  --
  END LOOP;

  EXECUTE IMMEDIATE 'ALTER TABLE nm_inv_type_attribs_all ENABLE ALL TRIGGERS';

END;
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Asset Grid Theme Functions upgrade
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108213
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Add Asset Grid NM0573 to all existing Asset themes
-- 
------------------------------------------------------------------
INSERT INTO nm_theme_functions_all
SELECT UNIQUE nth_theme_id
     , hmo_module
     , 'GIS_SESSION_ID'
     , UPPER(hmo_title) 
     , 'Y'
  FROM nm_themes_all
     , nm_inv_themes
     , hig_modules
 WHERE nith_nth_theme_id = nth_theme_id
   AND hmo_module = 'NM0573'
   AND NOT EXISTS
     (SELECT 'exists' 
        FROM nm_theme_functions_all
       WHERE ntf_nth_theme_id = nth_theme_id
         AND ntf_hmo_module   = 'NM0573'
         AND ntf_parameter    = 'GIS_SESSION_ID');
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Trim Hig Code Meanings
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED PROBLEM MANAGER LOG#
-- 722177  Exor Corporation Ltd
-- 
-- ASSOCIATED DEVELOPMENT TASK
-- 108290
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Make sure there are no leading/trailing spaces in HIG_CODE meanings
-- 
------------------------------------------------------------------
UPDATE hig_codes
   SET hco_meaning = TRIM(hco_meaning);

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT GIS0020 metadata
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Set Customer Layer item to be the last in the tree
-- 
------------------------------------------------------------------
UPDATE nm_layer_tree
   SET nltr_order = 10000
 WHERE nltr_parent = 'ROOT'
   AND nltr_child = 'CUS';


------------------------------------------------------------------


------------------------------------------------------------------

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

