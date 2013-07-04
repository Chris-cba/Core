--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/sql/nm_4054_fix1_metadata.sql-arc   3.1   Jul 04 2013 09:32:52   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_4054_fix1_metadata.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:32:52  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:30:12  $
--       PVCS Version     : $Revision:   3.1  $
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
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

