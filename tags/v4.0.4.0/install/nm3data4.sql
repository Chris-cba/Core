--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3data4.sql-arc   2.1   Oct 04 2007 17:59:20   jwadsworth  $
--       Module Name      : $Workfile:   nm3data4.sql  $
--       Date into PVCS   : $Date:   Oct 04 2007 17:59:20  $
--       Date fetched Out : $Modtime:   Oct 04 2007 17:53:40  $
--       Version          : $Revision:   2.1  $
--
--   Product metadata script
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
--
/***************************************************************************

INFO
====
As at Release 4.0.2.0

GENERATION DATE
===============
04-OCT-2007 17:53

TABLES PROCESSED
================
DOC_TYPES
GROUP_TYPE_ROLES
INTERVALS
HIG_REPORT_STYLES

TABLE OWNER
===========
NM3_METADATA

MODE (A-Append R-Refresh)
========================
A

***************************************************************************/

set define off;
set feedback off;

---------------------------------
-- START OF GENERATED METADATA --
---------------------------------

--
--********** DOC_TYPES **********--
SET TERM ON
PROMPT doc_types
SET TERM OFF
--
-- Columns
-- DTP_CODE                       NOT NULL VARCHAR2(4)
--   DTP_PK (Pos 1)
-- DTP_NAME                       NOT NULL VARCHAR2(30)
--   DTP_UK (Pos 1)
-- DTP_DESCR                               VARCHAR2(254)
-- DTP_ALLOW_COMMENTS             NOT NULL VARCHAR2(1)
-- DTP_ALLOW_COMPLAINTS           NOT NULL VARCHAR2(1)
-- DTP_START_DATE                          DATE
-- DTP_END_DATE                            DATE
--
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
--********** GROUP_TYPE_ROLES **********--
SET TERM ON
PROMPT group_type_roles
SET TERM OFF
--
-- Columns
-- GTR_ROLE                       NOT NULL VARCHAR2(30)
--   GTR_PK (Pos 1)
-- GTR_GTY_GROUP_TYPE             NOT NULL VARCHAR2(4)
--   GTR_PK (Pos 2)
--
--
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
--********** INTERVALS **********--
SET TERM ON
PROMPT intervals
SET TERM OFF
--
-- Columns
-- INT_CODE                       NOT NULL VARCHAR2(4)
--   INT_PK (Pos 1)
-- INT_TRANSLATION                NOT NULL VARCHAR2(20)
-- INT_DAYS                                NUMBER(3)
-- INT_DESCR                               VARCHAR2(40)
-- INT_FREQ_PER_MONTH                      NUMBER(2)
-- INT_FREQ_PER_WEEK                       NUMBER(2)
-- INT_FREQ_PER_YEAR                       NUMBER(2)
-- INT_HRS                                 NUMBER(2)
-- INT_MONTHS                              NUMBER(2)
-- INT_YRS                                 NUMBER(2)
-- INT_START_DATE                          DATE
-- INT_END_DATE                            DATE
--
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
--********** HIG_REPORT_STYLES **********--
SET TERM ON
PROMPT hig_report_styles
SET TERM OFF
--
-- Columns
-- HRS_STYLE_NAME                 NOT NULL VARCHAR2(30)
--   HRS_PK (Pos 1)
-- HRS_HEADER_FILL_COLOUR                  VARCHAR2(30)
-- HRS_BODY_FILL_COLOUR_1                  VARCHAR2(30)
-- HRS_BODY_FILL_COLOUR_2                  VARCHAR2(30)
-- HRS_BODY_FILL_COLOUR_H                  VARCHAR2(30)
-- HRS_HEADER_FONT_COLOUR                  VARCHAR2(30)
-- HRS_BODY_FONT_COLOUR_1                  VARCHAR2(30)
-- HRS_BODY_FONT_COLOUR_2                  VARCHAR2(30)
-- HRS_BODY_FONT_COLOUR_H                  VARCHAR2(30)
-- HRS_IMAGE_NAME                          VARCHAR2(256)
-- HRS_FOOTER_TEXT                         VARCHAR2(256)
--
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
COMMIT;
--
set feedback on
set define on
--
-------------------------------
-- END OF GENERATED METADATA --
-------------------------------
--
