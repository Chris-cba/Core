-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3data4.sql-arc   2.16   Aug 15 2012 09:55:18   Rob.Coupe  $
--       Module Name      : $Workfile:   nm3data4.sql  $
--       Date into PVCS   : $Date:   Aug 15 2012 09:55:18  $
--       Date fetched Out : $Modtime:   Aug 15 2012 09:54:58  $
--       Version          : $Revision:   2.16  $
--       Table Owner      : NM3_METADATA
--       Generation Date  : 15-AUG-2012 09:26
--
--   Product metadata script
--   As at Release 4.6.0.0
--
--   Copyright (c) exor corporation ltd, 2012
--
--   TABLES PROCESSED
--   ================
--   DOC_TYPES
--   GROUP_TYPE_ROLES
--   INTERVALS
--   HIG_REPORT_STYLES
--   HIG_NAVIGATOR
--   HIG_NAVIGATOR_MODULES
--
-----------------------------------------------------------------------------


set define off;
set feedback off;

---------------------------------
-- START OF GENERATED METADATA --
---------------------------------


----------------------------------------------------------------------------------------
-- DOC_TYPES
--
-- select * from nm3_metadata.doc_types
-- order by dtp_code
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT doc_types
SET TERM OFF

INSERT INTO DOC_TYPES
       (DTP_CODE
       ,DTP_NAME
       ,DTP_DESCR
       ,DTP_ALLOW_COMMENTS
       ,DTP_ALLOW_COMPLAINTS
       ,DTP_START_DATE
       ,DTP_END_DATE
       )
SELECT 
        'CLAM'
       ,'CLAIM'
       ,'Claim'
       ,'N'
       ,'Y'
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TYPES
                   WHERE DTP_CODE = 'CLAM');
--
INSERT INTO DOC_TYPES
       (DTP_CODE
       ,DTP_NAME
       ,DTP_DESCR
       ,DTP_ALLOW_COMMENTS
       ,DTP_ALLOW_COMPLAINTS
       ,DTP_START_DATE
       ,DTP_END_DATE
       )
SELECT 
        'COMM'
       ,'Comments'
       ,'Comment documents allow up to 2000 characters of text to be stored within the document record itself.  They may be recorded using the "View Associated Documents" module.'
       ,'Y'
       ,'N'
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TYPES
                   WHERE DTP_CODE = 'COMM');
--
INSERT INTO DOC_TYPES
       (DTP_CODE
       ,DTP_NAME
       ,DTP_DESCR
       ,DTP_ALLOW_COMMENTS
       ,DTP_ALLOW_COMPLAINTS
       ,DTP_START_DATE
       ,DTP_END_DATE
       )
SELECT 
        'COMP'
       ,'Complaints'
       ,'Complaints must be entered through the "Maintain Complaints" module, as there are numerous additional fields to be entered.'
       ,'N'
       ,'Y'
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TYPES
                   WHERE DTP_CODE = 'COMP');
--
INSERT INTO DOC_TYPES
       (DTP_CODE
       ,DTP_NAME
       ,DTP_DESCR
       ,DTP_ALLOW_COMMENTS
       ,DTP_ALLOW_COMPLAINTS
       ,DTP_START_DATE
       ,DTP_END_DATE
       )
SELECT 
        'CORR'
       ,'CORRESPONDENCE'
       ,'Correspondence'
       ,'N'
       ,'Y'
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TYPES
                   WHERE DTP_CODE = 'CORR');
--
INSERT INTO DOC_TYPES
       (DTP_CODE
       ,DTP_NAME
       ,DTP_DESCR
       ,DTP_ALLOW_COMMENTS
       ,DTP_ALLOW_COMPLAINTS
       ,DTP_START_DATE
       ,DTP_END_DATE
       )
SELECT 
        'CPLI'
       ,'COMPLIMENT'
       ,'Compliment'
       ,'N'
       ,'Y'
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TYPES
                   WHERE DTP_CODE = 'CPLI');
--
INSERT INTO DOC_TYPES
       (DTP_CODE
       ,DTP_NAME
       ,DTP_DESCR
       ,DTP_ALLOW_COMMENTS
       ,DTP_ALLOW_COMPLAINTS
       ,DTP_START_DATE
       ,DTP_END_DATE
       )
SELECT 
        'PETI'
       ,'PETITION'
       ,'Petition'
       ,'N'
       ,'Y'
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TYPES
                   WHERE DTP_CODE = 'PETI');
--
INSERT INTO DOC_TYPES
       (DTP_CODE
       ,DTP_NAME
       ,DTP_DESCR
       ,DTP_ALLOW_COMMENTS
       ,DTP_ALLOW_COMPLAINTS
       ,DTP_START_DATE
       ,DTP_END_DATE
       )
SELECT 
        'REPT'
       ,'Report'
       ,'Report'
       ,'N'
       ,'N'
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TYPES
                   WHERE DTP_CODE = 'REPT');
--
INSERT INTO DOC_TYPES
       (DTP_CODE
       ,DTP_NAME
       ,DTP_DESCR
       ,DTP_ALLOW_COMMENTS
       ,DTP_ALLOW_COMPLAINTS
       ,DTP_START_DATE
       ,DTP_END_DATE
       )
SELECT 
        'REQS'
       ,'REQUEST_FOR_SERVICE'
       ,'Request For Service'
       ,'N'
       ,'Y'
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TYPES
                   WHERE DTP_CODE = 'REQS');
--
INSERT INTO DOC_TYPES
       (DTP_CODE
       ,DTP_NAME
       ,DTP_DESCR
       ,DTP_ALLOW_COMMENTS
       ,DTP_ALLOW_COMPLAINTS
       ,DTP_START_DATE
       ,DTP_END_DATE
       )
SELECT 
        'TRO'
       ,'Traffic Regulation Order'
       ,'Traffic Regulation Order'
       ,'N'
       ,'N'
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TYPES
                   WHERE DTP_CODE = 'TRO');
--
INSERT INTO DOC_TYPES
       (DTP_CODE
       ,DTP_NAME
       ,DTP_DESCR
       ,DTP_ALLOW_COMMENTS
       ,DTP_ALLOW_COMPLAINTS
       ,DTP_START_DATE
       ,DTP_END_DATE
       )
SELECT 
        'UKNW'
       ,'Unknown Document Type'
       ,'Document upgraded at Oracle*Highways V1.6.2.0'
       ,'N'
       ,'N'
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TYPES
                   WHERE DTP_CODE = 'UKNW');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- GROUP_TYPE_ROLES
--
-- select * from nm3_metadata.group_type_roles
-- order by gtr_role
--         ,gtr_gty_group_type
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT group_type_roles
SET TERM OFF

INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_ADMIN'
       ,'AREA' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_ADMIN'
                    AND  GTR_GTY_GROUP_TYPE = 'AREA');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_ADMIN'
       ,'ASO' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_ADMIN'
                    AND  GTR_GTY_GROUP_TYPE = 'ASO');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_ADMIN'
       ,'DEPO' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_ADMIN'
                    AND  GTR_GTY_GROUP_TYPE = 'DEPO');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_ADMIN'
       ,'DIST' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_ADMIN'
                    AND  GTR_GTY_GROUP_TYPE = 'DIST');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_ADMIN'
       ,'DIVN' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_ADMIN'
                    AND  GTR_GTY_GROUP_TYPE = 'DIVN');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_ADMIN'
       ,'GIS' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_ADMIN'
                    AND  GTR_GTY_GROUP_TYPE = 'GIS');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_ADMIN'
       ,'HIER' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_ADMIN'
                    AND  GTR_GTY_GROUP_TYPE = 'HIER');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_ADMIN'
       ,'LINK' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_ADMIN'
                    AND  GTR_GTY_GROUP_TYPE = 'LINK');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_ADMIN'
       ,'PAR' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_ADMIN'
                    AND  GTR_GTY_GROUP_TYPE = 'PAR');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_ADMIN'
       ,'RP' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_ADMIN'
                    AND  GTR_GTY_GROUP_TYPE = 'RP');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_ADMIN'
       ,'SFTY' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_ADMIN'
                    AND  GTR_GTY_GROUP_TYPE = 'SFTY');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_ADMIN'
       ,'TOP' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_ADMIN'
                    AND  GTR_GTY_GROUP_TYPE = 'TOP');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_ADMIN'
       ,'TOWN' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_ADMIN'
                    AND  GTR_GTY_GROUP_TYPE = 'TOWN');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_USER'
       ,'AREA' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_USER'
                    AND  GTR_GTY_GROUP_TYPE = 'AREA');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_USER'
       ,'ASO' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_USER'
                    AND  GTR_GTY_GROUP_TYPE = 'ASO');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_USER'
       ,'DEPO' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_USER'
                    AND  GTR_GTY_GROUP_TYPE = 'DEPO');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_USER'
       ,'DIST' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_USER'
                    AND  GTR_GTY_GROUP_TYPE = 'DIST');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_USER'
       ,'DIVN' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_USER'
                    AND  GTR_GTY_GROUP_TYPE = 'DIVN');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_USER'
       ,'GIS' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_USER'
                    AND  GTR_GTY_GROUP_TYPE = 'GIS');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_USER'
       ,'HIER' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_USER'
                    AND  GTR_GTY_GROUP_TYPE = 'HIER');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_USER'
       ,'LINK' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_USER'
                    AND  GTR_GTY_GROUP_TYPE = 'LINK');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_USER'
       ,'PAR' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_USER'
                    AND  GTR_GTY_GROUP_TYPE = 'PAR');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_USER'
       ,'RP' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_USER'
                    AND  GTR_GTY_GROUP_TYPE = 'RP');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_USER'
       ,'SFTY' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_USER'
                    AND  GTR_GTY_GROUP_TYPE = 'SFTY');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_USER'
       ,'TOP' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_USER'
                    AND  GTR_GTY_GROUP_TYPE = 'TOP');
--
INSERT INTO GROUP_TYPE_ROLES
       (GTR_ROLE
       ,GTR_GTY_GROUP_TYPE
       )
SELECT 
        'NET_USER'
       ,'TOWN' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GROUP_TYPE_ROLES
                   WHERE GTR_ROLE = 'NET_USER'
                    AND  GTR_GTY_GROUP_TYPE = 'TOWN');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- INTERVALS
--
-- select * from nm3_metadata.intervals
-- order by int_code
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT intervals
SET TERM OFF

INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '100'
       ,'None'
       ,null
       ,'None'
       ,null
       ,null
       ,null
       ,0
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '100');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '101'
       ,'Not Set'
       ,null
       ,'Not Set'
       ,null
       ,null
       ,null
       ,0
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '101');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '224'
       ,'24 Hours'
       ,null
       ,'24 Hours'
       ,null
       ,null
       ,null
       ,24
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '224');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '301'
       ,' 1 Days'
       ,1
       ,' 1 Days'
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '301');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '305'
       ,' 5 Days'
       ,5
       ,' 5 Days'
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '305');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '307'
       ,' 7 Days'
       ,7
       ,' 7 Days'
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '307');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '314'
       ,'14 Days'
       ,14
       ,'14 Days'
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '314');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '321'
       ,'21 Days'
       ,21
       ,'21 Days'
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '321');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '328'
       ,'28 Days'
       ,28
       ,'28 Days'
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '328');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '335'
       ,'35 Days'
       ,35
       ,'35 Days'
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '335');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '401'
       ,' 1 Months'
       ,null
       ,' 1 Months'
       ,null
       ,null
       ,null
       ,null
       ,1
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '401');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '403'
       ,' 3 Months'
       ,null
       ,' 3 Months'
       ,null
       ,null
       ,null
       ,null
       ,3
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '403');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '406'
       ,' 6 Months'
       ,null
       ,' 6 Months'
       ,null
       ,null
       ,null
       ,null
       ,6
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '406');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '412'
       ,'12 Months'
       ,null
       ,'12 Months=4000hrs'
       ,null
       ,null
       ,null
       ,null
       ,12
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '412');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '418'
       ,'18 Months'
       ,null
       ,'18 Months=6000hrs'
       ,null
       ,null
       ,null
       ,null
       ,18
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '418');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '424'
       ,'24 Months'
       ,null
       ,'24 Months=8000hrs'
       ,null
       ,null
       ,null
       ,null
       ,24
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '424');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '430'
       ,'8000 Hr/9hr/Day'
       ,null
       ,'30 Months'
       ,null
       ,null
       ,null
       ,null
       ,30
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '430');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '501'
       ,' 1 Year'
       ,null
       ,' 1 Year'
       ,null
       ,null
       ,null
       ,null
       ,null
       ,1
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '501');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '502'
       ,' 2 Years'
       ,null
       ,' 2 Years'
       ,null
       ,null
       ,null
       ,null
       ,null
       ,2
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '502');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '503'
       ,' 3 Years'
       ,null
       ,' 3 Years'
       ,null
       ,null
       ,null
       ,null
       ,null
       ,3
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '503');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '505'
       ,' 5 Years'
       ,null
       ,' 5 Years'
       ,null
       ,null
       ,null
       ,null
       ,null
       ,5
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '505');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '506'
       ,' 6 Years'
       ,null
       ,' 6 Years'
       ,null
       ,null
       ,null
       ,null
       ,null
       ,6
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '506');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '507'
       ,' 7 Years'
       ,null
       ,' 7 Years'
       ,null
       ,null
       ,null
       ,null
       ,null
       ,7
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '507');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '510'
       ,'10 Years'
       ,null
       ,'10 Years'
       ,null
       ,null
       ,null
       ,null
       ,null
       ,10
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '510');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '700'
       ,'0 Per Year'
       ,null
       ,'Frequency  0 Per Year'
       ,null
       ,null
       ,0
       ,null
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '700');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '701'
       ,'1 Per Year'
       ,null
       ,'Frequency  1 Per Year'
       ,null
       ,null
       ,1
       ,null
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '701');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '702'
       ,'2 Per Year'
       ,null
       ,'Frequency  2 Per Year'
       ,null
       ,null
       ,2
       ,null
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '702');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '703'
       ,'3 Per Year'
       ,null
       ,'Frequency  3 Per Year'
       ,null
       ,null
       ,3
       ,null
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '703');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '704'
       ,'4 Per Year'
       ,null
       ,'Frequency  4 Per Year'
       ,null
       ,null
       ,4
       ,null
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '704');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '705'
       ,'5 Per Year'
       ,null
       ,'Frequency  5 Per Year'
       ,null
       ,null
       ,5
       ,null
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '705');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '706'
       ,'6 Per Year'
       ,null
       ,'Frequency  6 Per Year'
       ,null
       ,null
       ,6
       ,null
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '706');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '707'
       ,'7 Per Year'
       ,null
       ,'Frequency  7 Per Year'
       ,null
       ,null
       ,7
       ,null
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '707');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '708'
       ,'8 Per Year'
       ,null
       ,'Frequency  8 Per Year'
       ,null
       ,null
       ,8
       ,null
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '708');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '709'
       ,'9 Per Year'
       ,null
       ,'Frequency  9 Per Year'
       ,null
       ,null
       ,9
       ,null
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '709');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '710'
       ,'10 Per Year'
       ,null
       ,'Frequency 10 Per Year'
       ,null
       ,null
       ,10
       ,null
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '710');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '801'
       ,'1 Per Month'
       ,null
       ,'Frequency 1 Per Month'
       ,1
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '801');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '901'
       ,'1 Per Week'
       ,null
       ,'Frequency 1 Per Week'
       ,null
       ,1
       ,null
       ,null
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '901');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT 
        '999'
       ,'1 Hour'
       ,null
       ,'1 hour'
       ,null
       ,null
       ,null
       ,1
       ,null
       ,null
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '999');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- HIG_REPORT_STYLES
--
-- select * from nm3_metadata.hig_report_styles
-- order by hrs_style_name
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT hig_report_styles
SET TERM OFF

INSERT INTO HIG_REPORT_STYLES
       (HRS_STYLE_NAME
       ,HRS_HEADER_FILL_COLOUR
       ,HRS_BODY_FILL_COLOUR_1
       ,HRS_BODY_FILL_COLOUR_2
       ,HRS_BODY_FILL_COLOUR_H
       ,HRS_HEADER_FONT_COLOUR
       ,HRS_BODY_FONT_COLOUR_1
       ,HRS_BODY_FONT_COLOUR_2
       ,HRS_BODY_FONT_COLOUR_H
       ,HRS_IMAGE_NAME
       ,HRS_FOOTER_TEXT
       )
SELECT 
        'EXOR_CORPORATE'
       ,'R0G50B50'
       ,'R100G75B0'
       ,'R100G75B0'
       ,'R100G75B0'
       ,'R100G100B100'
       ,'R0G0B0'
       ,'R0G0B0'
       ,'R0G0B0'
       ,'exor.jpg'
       ,'Exor Leading the way in Infrastructure Asset Management Solutions... ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_REPORT_STYLES
                   WHERE HRS_STYLE_NAME = 'EXOR_CORPORATE');
--
INSERT INTO HIG_REPORT_STYLES
       (HRS_STYLE_NAME
       ,HRS_HEADER_FILL_COLOUR
       ,HRS_BODY_FILL_COLOUR_1
       ,HRS_BODY_FILL_COLOUR_2
       ,HRS_BODY_FILL_COLOUR_H
       ,HRS_HEADER_FONT_COLOUR
       ,HRS_BODY_FONT_COLOUR_1
       ,HRS_BODY_FONT_COLOUR_2
       ,HRS_BODY_FONT_COLOUR_H
       ,HRS_IMAGE_NAME
       ,HRS_FOOTER_TEXT
       )
SELECT 
        'EXOR_DEFAULT'
       ,'R75G75B75'
       ,'R88G88B88'
       ,'R88G88B88'
       ,'R0G0B0'
       ,'R0G0B0'
       ,'R0G0B0'
       ,'R0G0B0'
       ,'R100G100B100'
       ,'exor.jpg'
       ,'Exor Leading the way in Infrastructure Asset Management Solutions... ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_REPORT_STYLES
                   WHERE HRS_STYLE_NAME = 'EXOR_DEFAULT');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- HIG_NAVIGATOR
--
-- select * from nm3_metadata.hig_navigator
-- order by hnv_child_alias
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT hig_navigator
SET TERM OFF

INSERT INTO HIG_NAVIGATOR
       (HNV_HIERARCHY_TYPE
       ,HNV_PARENT_TABLE
       ,HNV_PARENT_COLUMN
       ,HNV_CHILD_TABLE
       ,HNV_CHILD_COLUMN
       ,HNV_HIERARCHY_LEVEL
       ,HNV_HIERARCHY_LABEL
       ,HNV_PARENT_ID
       ,HNV_CHILD_ID
       ,HNV_PARENT_ALIAS
       ,HNV_CHILD_ALIAS
       ,HNV_ICON_NAME
       ,HNV_ADDITIONAL_COND
       ,HNV_PRIMARY_HIERARCHY
       ,HNV_HIER_LABEL_1
       ,HNV_HIER_LABEL_2
       ,HNV_HIER_LABEL_3
       ,HNV_HIER_LABEL_4
       ,HNV_HIER_LABEL_5
       ,HNV_HIER_LABEL_6
       ,HNV_HIER_LABEL_7
       ,HNV_HIER_LABEL_8
       ,HNV_HIER_LABEL_9
       ,HNV_HIER_LABEL_10
       ,HNV_HIERARCHY_SEQ
       ,HNV_DATE_CREATED
       ,HNV_CREATED_BY
       ,HNV_DATE_MODIFIED
       ,HNV_MODIFIED_BY
       ,HNV_HPR_PRODUCT
       )
SELECT 
        'Assets'
       ,''
       ,''
       ,'nm_inv_items_all'
       ,'iit_ne_id'
       ,1
       ,'Asset'
       ,''
       ,'nm_inv_items_all.iit_ne_id'
       ,''
       ,'-AST1'
       ,'asset'
       ,''
       ,'Y'
       ,'iit_inv_type'
       ,'hig_nav.concate_label(hig_nav.get_asset_type_descr(iit_inv_type))'
       ,'hig_nav.concate_label(iit_ne_id)'
       ,'hig_nav.concate_label(iit_primary_key)'
       ,'hig_nav.concate_label(hig_nav.get_admin_unit_name(iit_admin_unit))'
       ,'hig_nav.concate_label(iit_start_date)'
       ,'hig_nav.concate_label(iit_end_date)'
       ,''
       ,''
       ,''
       ,null
       ,to_date('20120518104105','YYYYMMDDHH24MISS')
       ,'HIGHWAYS'
       ,to_date('20120518104105','YYYYMMDDHH24MISS')
       ,'HIGHWAYS'
       ,'AST' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_NAVIGATOR
                   WHERE HNV_CHILD_ALIAS = '-AST1');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- HIG_NAVIGATOR_MODULES
--
-- select * from nm3_metadata.hig_navigator_modules
-- order by hnm_module_name
--         ,hnm_module_param
--         ,hnm_hierarchy_label
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT hig_navigator_modules
SET TERM OFF

INSERT INTO HIG_NAVIGATOR_MODULES
       (HNM_MODULE_NAME
       ,HNM_MODULE_PARAM
       ,HNM_PRIMARY_MODULE
       ,HNM_SEQUENCE
       ,HNM_TABLE_NAME
       ,HNM_FIELD_NAME
       ,HNM_HIERARCHY_LABEL
       ,HNM_DATE_CREATED
       ,HNM_CREATED_BY
       ,HNM_DATE_MODIFIED
       ,HNM_MODIFIED_BY
       )
SELECT 
        'NM0510'
       ,'query_inv_item'
       ,'Y'
       ,1
       ,''
       ,''
       ,'Asset'
       ,to_date('20100222165343','YYYYMMDDHH24MISS')
       ,'DORSET'
       ,to_date('20100222165343','YYYYMMDDHH24MISS')
       ,'DORSET' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_NAVIGATOR_MODULES
                   WHERE HNM_MODULE_NAME = 'NM0510'
                    AND  HNM_MODULE_PARAM = 'query_inv_item'
                    AND  HNM_HIERARCHY_LABEL = 'Asset');
--
INSERT INTO HIG_NAVIGATOR_MODULES
       (HNM_MODULE_NAME
       ,HNM_MODULE_PARAM
       ,HNM_PRIMARY_MODULE
       ,HNM_SEQUENCE
       ,HNM_TABLE_NAME
       ,HNM_FIELD_NAME
       ,HNM_HIERARCHY_LABEL
       ,HNM_DATE_CREATED
       ,HNM_CREATED_BY
       ,HNM_DATE_MODIFIED
       ,HNM_MODIFIED_BY
       )
SELECT 
        'NM0590'
       ,'query_inv_item'
       ,'N'
       ,2
       ,''
       ,''
       ,'Asset'
       ,to_date('20100330174305','YYYYMMDDHH24MISS')
       ,'DORSET'
       ,to_date('20100330174305','YYYYMMDDHH24MISS')
       ,'DORSET' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_NAVIGATOR_MODULES
                   WHERE HNM_MODULE_NAME = 'NM0590'
                    AND  HNM_MODULE_PARAM = 'query_inv_item'
                    AND  HNM_HIERARCHY_LABEL = 'Asset');
--
--
--
----------------------------------------------------------------------------------------

--
COMMIT;
--
set feedback on
set define on
--
-------------------------------
-- END OF GENERATED METADATA --
-------------------------------
--
