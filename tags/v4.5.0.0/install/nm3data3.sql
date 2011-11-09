-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3data3.sql-arc   2.28   Nov 09 2011 14:29:38   Mike.Alexander  $
--       Module Name      : $Workfile:   nm3data3.sql  $
--       Date into PVCS   : $Date:   Nov 09 2011 14:29:38  $
--       Date fetched Out : $Modtime:   Nov 09 2011 14:25:06  $
--       Version          : $Revision:   2.28  $
--       Table Owner      : NM3_METADATA
--       Generation Date  : 09-NOV-2011 14:25
--
--   Product metadata script
--   As at Release 4.4.0.0
--
--   Copyright (c) exor corporation ltd, 2011
--
--   TABLES PROCESSED
--   ================
--   HIG_ROLES
--   HIG_MODULE_ROLES
--   HIG_MODULE_KEYWORDS
--   HIG_PROCESS_AREAS
--   HIG_PROCESS_TYPES
--   HIG_PROCESS_TYPE_ROLES
--   HIG_SCHEDULING_FREQUENCIES
--   HIG_PROCESS_TYPE_FREQUENCIES
--   HIG_PROCESS_TYPE_FILES
--   HIG_MODULE_BLOCKS
--
-----------------------------------------------------------------------------


set define off;
set feedback off;

---------------------------------
-- START OF GENERATED METADATA --
---------------------------------


----------------------------------------------------------------------------------------
-- HIG_ROLES
--
-- select * from nm3_metadata.hig_roles
-- order by hro_role
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT hig_roles
SET TERM OFF

INSERT INTO HIG_ROLES
       (HRO_ROLE
       ,HRO_PRODUCT
       ,HRO_DESCR
       )
SELECT 
        'ACC_ADMIN'
       ,'ACC'
       ,'Accident Administration' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                   WHERE HRO_ROLE = 'ACC_ADMIN');
--
INSERT INTO HIG_ROLES
       (HRO_ROLE
       ,HRO_PRODUCT
       ,HRO_DESCR
       )
SELECT 
        'DOC0201'
       ,'DOC'
       ,'Role for OLE Word Template Maintenance' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                   WHERE HRO_ROLE = 'DOC0201');
--
INSERT INTO HIG_ROLES
       (HRO_ROLE
       ,HRO_PRODUCT
       ,HRO_DESCR
       )
SELECT 
        'DOC0202'
       ,'DOC'
       ,'Role for OLE Word Template User Maintenance' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                   WHERE HRO_ROLE = 'DOC0202');
--
INSERT INTO HIG_ROLES
       (HRO_ROLE
       ,HRO_PRODUCT
       ,HRO_DESCR
       )
SELECT 
        'DOC_ADMIN'
       ,'DOC'
       ,'Document Manager Administration' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                   WHERE HRO_ROLE = 'DOC_ADMIN');
--
INSERT INTO HIG_ROLES
       (HRO_ROLE
       ,HRO_PRODUCT
       ,HRO_DESCR
       )
SELECT 
        'DOC_READONLY'
       ,'DOC'
       ,'Document Manager Readonly Access' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                   WHERE HRO_ROLE = 'DOC_READONLY');
--
INSERT INTO HIG_ROLES
       (HRO_ROLE
       ,HRO_PRODUCT
       ,HRO_DESCR
       )
SELECT 
        'DOC_USER'
       ,'DOC'
       ,'Document Manager Updates' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                   WHERE HRO_ROLE = 'DOC_USER');
--
INSERT INTO HIG_ROLES
       (HRO_ROLE
       ,HRO_PRODUCT
       ,HRO_DESCR
       )
SELECT 
        'EMAIL_USER'
       ,'HIG'
       ,'Email User role' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                   WHERE HRO_ROLE = 'EMAIL_USER');
--
INSERT INTO HIG_ROLES
       (HRO_ROLE
       ,HRO_PRODUCT
       ,HRO_DESCR
       )
SELECT 
        'FTP_USER'
       ,'HIG'
       ,'FTP User role' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                   WHERE HRO_ROLE = 'FTP_USER');
--
INSERT INTO HIG_ROLES
       (HRO_ROLE
       ,HRO_PRODUCT
       ,HRO_DESCR
       )
SELECT 
        'GIS_SUPERUSER'
       ,'HIG'
       ,'GIS Super User Administration Role' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                   WHERE HRO_ROLE = 'GIS_SUPERUSER');
--
INSERT INTO HIG_ROLES
       (HRO_ROLE
       ,HRO_PRODUCT
       ,HRO_DESCR
       )
SELECT 
        'HIG_ADMIN'
       ,'HIG'
       ,'Highways Core Administration' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                   WHERE HRO_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_ROLES
       (HRO_ROLE
       ,HRO_PRODUCT
       ,HRO_DESCR
       )
SELECT 
        'HIG_READONLY'
       ,'HIG'
       ,'Highways Core Readonly Access' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                   WHERE HRO_ROLE = 'HIG_READONLY');
--
INSERT INTO HIG_ROLES
       (HRO_ROLE
       ,HRO_PRODUCT
       ,HRO_DESCR
       )
SELECT 
        'HIG_USER'
       ,'HIG'
       ,'Highways Core Updates' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                   WHERE HRO_ROLE = 'HIG_USER');
--
INSERT INTO HIG_ROLES
       (HRO_ROLE
       ,HRO_PRODUCT
       ,HRO_DESCR
       )
SELECT 
        'HIG_USER_ADMIN'
       ,'HIG'
       ,'Highways User Administration' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                   WHERE HRO_ROLE = 'HIG_USER_ADMIN');
--
INSERT INTO HIG_ROLES
       (HRO_ROLE
       ,HRO_PRODUCT
       ,HRO_DESCR
       )
SELECT 
        'NET_ADMIN'
       ,'NET'
       ,'Network Manager Administration' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                   WHERE HRO_ROLE = 'NET_ADMIN');
--
INSERT INTO HIG_ROLES
       (HRO_ROLE
       ,HRO_PRODUCT
       ,HRO_DESCR
       )
SELECT 
        'NET_READONLY'
       ,'NET'
       ,'Network Manager Readonly Access' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                   WHERE HRO_ROLE = 'NET_READONLY');
--
INSERT INTO HIG_ROLES
       (HRO_ROLE
       ,HRO_PRODUCT
       ,HRO_DESCR
       )
SELECT 
        'NET_USER'
       ,'NET'
       ,'Network Manager Updates' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                   WHERE HRO_ROLE = 'NET_USER');
--
INSERT INTO HIG_ROLES
       (HRO_ROLE
       ,HRO_PRODUCT
       ,HRO_DESCR
       )
SELECT 
        'PROCESS_ADMIN'
       ,'HIG'
       ,'Scheduler Job Admin Privs' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                   WHERE HRO_ROLE = 'PROCESS_ADMIN');
--
INSERT INTO HIG_ROLES
       (HRO_ROLE
       ,HRO_PRODUCT
       ,HRO_DESCR
       )
SELECT 
        'PROCESS_USER'
       ,'HIG'
       ,'Scheduler Job Privs' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                   WHERE HRO_ROLE = 'PROCESS_USER');
--
INSERT INTO HIG_ROLES
       (HRO_ROLE
       ,HRO_PRODUCT
       ,HRO_DESCR
       )
SELECT 
        'WEB_USER'
       ,'HIG'
       ,'Basic NM3 Web Access' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                   WHERE HRO_ROLE = 'WEB_USER');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- HIG_MODULE_ROLES
--
-- select * from nm3_metadata.hig_module_roles
-- order by hmr_module
--         ,hmr_role
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT hig_module_roles
SET TERM OFF

INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'ABOUT'
       ,'HIG_USER'
       ,'READONLY' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'ABOUT'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'ABOUT_SERVER'
       ,'HIG_USER'
       ,'READONLY' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'ABOUT_SERVER'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'CALENDAR'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'CALENDAR'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'DOC0100'
       ,'DOC_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'DOC0100'
                    AND  HMR_ROLE = 'DOC_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'DOC0100'
       ,'DOC_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'DOC0100'
                    AND  HMR_ROLE = 'DOC_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'DOC0110'
       ,'DOC_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'DOC0110'
                    AND  HMR_ROLE = 'DOC_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'DOC0114'
       ,'DOC_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'DOC0114'
                    AND  HMR_ROLE = 'DOC_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'DOC0115'
       ,'DOC_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'DOC0115'
                    AND  HMR_ROLE = 'DOC_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'DOC0116'
       ,'DOC_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'DOC0116'
                    AND  HMR_ROLE = 'DOC_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'DOC0118'
       ,'DOC_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'DOC0118'
                    AND  HMR_ROLE = 'DOC_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'DOC0120'
       ,'DOC_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'DOC0120'
                    AND  HMR_ROLE = 'DOC_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'DOC0122'
       ,'DOC_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'DOC0122'
                    AND  HMR_ROLE = 'DOC_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'DOC0130'
       ,'DOC_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'DOC0130'
                    AND  HMR_ROLE = 'DOC_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'DOC0200'
       ,'DOC_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'DOC0200'
                    AND  HMR_ROLE = 'DOC_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'DOC0200'
       ,'DOC_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'DOC0200'
                    AND  HMR_ROLE = 'DOC_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'DOC0200'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'DOC0200'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'DOC0201'
       ,'DOC0201'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'DOC0201'
                    AND  HMR_ROLE = 'DOC0201');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'DOC0202'
       ,'DOC0202'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'DOC0202'
                    AND  HMR_ROLE = 'DOC0202');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'DOC0300'
       ,'DOC_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'DOC0300'
                    AND  HMR_ROLE = 'DOC_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'DOC0310'
       ,'DOC_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'DOC0310'
                    AND  HMR_ROLE = 'DOC_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'DOCWEB0010'
       ,'WEB_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'DOCWEB0010'
                    AND  HMR_ROLE = 'WEB_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'GIS'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'GIS'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'GIS0005'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'GIS0005'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'GIS0010'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'GIS0010'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'GIS0011'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'GIS0011'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'GIS0020'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'GIS0020'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'GISWEB0020'
       ,'WEB_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'GISWEB0020'
                    AND  HMR_ROLE = 'WEB_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'GISWEB0021'
       ,'WEB_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'GISWEB0021'
                    AND  HMR_ROLE = 'WEB_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'GRI0200'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'GRI0200'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'GRI0205'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'GRI0205'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'GRI0210'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'GRI0210'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'GRI0220'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'GRI0220'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'GRI0230'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'GRI0230'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'GRI0240'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'GRI0240'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'GRI0250'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'GRI0250'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'GRI0260'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'GRI0260'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'GRI0260'
       ,'HIG_USER'
       ,'READONLY' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'GRI0260'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'GRI9998'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'GRI9998'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'GRI9999'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'GRI9999'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG0100'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG0100'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG0200'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG0200'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1220'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1220'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1500'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1500'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1505'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1505'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1510'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1510'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1520'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1520'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1525'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1525'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1802'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1802'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1804'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1804'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1806'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1806'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1807'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1807'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1808'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1808'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1809'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1809'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1810'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1810'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1811'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1811'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1815'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1815'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1815'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1815'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1820'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1820'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1832'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1832'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1833'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1833'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1834'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1834'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1836'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1836'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1837'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1837'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1839'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1839'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1840'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1840'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1850'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1850'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1850'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1850'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1860'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1860'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1862'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1862'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1864'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1864'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1866'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1866'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1868'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1868'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1870'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1870'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1870'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1870'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1880'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1880'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1881'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1881'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1885'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1885'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1890'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1890'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1895'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1895'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1895'
       ,'HIG_USER'
       ,'READONLY' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1895'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1900'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1900'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1901'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1901'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1903'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1903'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1910'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1910'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1911'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1911'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1912'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1912'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG1950'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG1950'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG2010'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG2010'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG2020'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG2020'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG2100'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG2100'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG2500'
       ,'PROCESS_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG2500'
                    AND  HMR_ROLE = 'PROCESS_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG2510'
       ,'PROCESS_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG2510'
                    AND  HMR_ROLE = 'PROCESS_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG2515'
       ,'PROCESS_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG2515'
                    AND  HMR_ROLE = 'PROCESS_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG2520'
       ,'PROCESS_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG2520'
                    AND  HMR_ROLE = 'PROCESS_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG2530'
       ,'PROCESS_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG2530'
                    AND  HMR_ROLE = 'PROCESS_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG2540'
       ,'PROCESS_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG2540'
                    AND  HMR_ROLE = 'PROCESS_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG2550'
       ,'PROCESS_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG2550'
                    AND  HMR_ROLE = 'PROCESS_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG2600'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG2600'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG3664'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG3664'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG3664'
       ,'HIG_USER'
       ,'READONLY' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG3664'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG4010'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG4010'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG4020'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG4020'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG4025'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG4025'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG4030'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG4030'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG5000'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG5000'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG9110'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG9110'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG9115'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG9115'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG9120'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG9120'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG9125'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG9125'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG9130'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG9130'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG9135'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG9135'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG9140'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG9140'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG9140'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG9140'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG9150'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG9150'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG9170'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG9170'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG9180'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG9180'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG9185'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG9185'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG9190'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG9190'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIGHWAYS'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIGHWAYS'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIGWEB1902'
       ,'WEB_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIGWEB1902'
                    AND  HMR_ROLE = 'WEB_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIGWEB2030'
       ,'WEB_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIGWEB2030'
                    AND  HMR_ROLE = 'WEB_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'MAPBUILDER'
       ,'GIS_SUPERUSER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'MAPBUILDER'
                    AND  HMR_ROLE = 'GIS_SUPERUSER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NAVIGATOR'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NAVIGATOR'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NET1100'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NET1100'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NET1100'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NET1100'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0001'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0001'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0002'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0002'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0004'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0004'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0005'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0005'
                    AND  HMR_ROLE = 'NET_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0005'
       ,'NET_USER'
       ,'READONLY' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0005'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0101'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0101'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0105'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0105'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0106'
       ,'NET_READONLY'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0106'
                    AND  HMR_ROLE = 'NET_READONLY');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0106'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0106'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0107'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0107'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0110'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0110'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0111'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0111'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0111'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0111'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0115'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0115'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0116'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0116'
                    AND  HMR_ROLE = 'NET_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0120'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0120'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0121'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0121'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0122'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0122'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0150'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0150'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0151'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0151'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0153'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0153'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0154'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0154'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0155'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0155'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0200'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0200'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0201'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0201'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0202'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0202'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0203'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0203'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0204'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0204'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0205'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0205'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0206'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0206'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0207'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0207'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0220'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0220'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0301'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0301'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0305'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0305'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0306'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0306'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0410'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0410'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0411'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0411'
                    AND  HMR_ROLE = 'NET_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0415'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0415'
                    AND  HMR_ROLE = 'NET_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0430'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0430'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0435'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0435'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0500'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0500'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0510'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0510'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0511'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0511'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0511'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0511'
                    AND  HMR_ROLE = 'NET_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0515'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0515'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0520'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0520'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0530'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0530'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0535'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0535'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0550'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0550'
                    AND  HMR_ROLE = 'NET_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0551'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0551'
                    AND  HMR_ROLE = 'NET_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0560'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0560'
                    AND  HMR_ROLE = 'NET_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0560'
       ,'NET_READONLY'
       ,'READONLY' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0560'
                    AND  HMR_ROLE = 'NET_READONLY');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0560'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0560'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0561'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0561'
                    AND  HMR_ROLE = 'NET_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0561'
       ,'NET_READONLY'
       ,'READONLY' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0561'
                    AND  HMR_ROLE = 'NET_READONLY');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0561'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0561'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0562'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0562'
                    AND  HMR_ROLE = 'NET_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0562'
       ,'NET_READONLY'
       ,'READONLY' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0562'
                    AND  HMR_ROLE = 'NET_READONLY');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0562'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0562'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0563'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0563'
                    AND  HMR_ROLE = 'NET_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0563'
       ,'NET_READONLY'
       ,'READONLY' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0563'
                    AND  HMR_ROLE = 'NET_READONLY');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0563'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0563'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0570'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0570'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0571'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0571'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0572'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0572'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0573'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0573'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0573'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0573'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0575'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0575'
                    AND  HMR_ROLE = 'NET_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0580'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0580'
                    AND  HMR_ROLE = 'NET_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0590'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0590'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM0700'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0700'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM1100'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM1100'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM1200'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM1200'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM1201'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM1201'
                    AND  HMR_ROLE = 'NET_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM1861'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM1861'
                    AND  HMR_ROLE = 'NET_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM2000'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM2000'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM3010'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM3010'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM3010'
       ,'HIG_USER'
       ,'READONLY' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM3010'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM3020'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM3020'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM3020'
       ,'HIG_USER'
       ,'READONLY' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM3020'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM3030'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM3030'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM3030'
       ,'HIG_USER'
       ,'READONLY' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM3030'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM7040'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM7040'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM7041'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM7041'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM7050'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM7050'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM7051B'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM7051B'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM7052'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM7052'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM7052'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM7052'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM7053'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM7053'
                    AND  HMR_ROLE = 'NET_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM7055'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM7055'
                    AND  HMR_ROLE = 'NET_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM7057'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM7057'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM7058'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM7058'
                    AND  HMR_ROLE = 'NET_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NM9999'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM9999'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NMWEB0000'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NMWEB0000'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NMWEB0000'
       ,'WEB_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NMWEB0000'
                    AND  HMR_ROLE = 'WEB_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NMWEB0001'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NMWEB0001'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NMWEB0001'
       ,'WEB_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NMWEB0001'
                    AND  HMR_ROLE = 'WEB_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NMWEB0002'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NMWEB0002'
                    AND  HMR_ROLE = 'HIG_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NMWEB0002'
       ,'WEB_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NMWEB0002'
                    AND  HMR_ROLE = 'WEB_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NMWEB0003'
       ,'WEB_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NMWEB0003'
                    AND  HMR_ROLE = 'WEB_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NMWEB0004'
       ,'WEB_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NMWEB0004'
                    AND  HMR_ROLE = 'WEB_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NMWEB0010'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NMWEB0010'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NMWEB0010'
       ,'WEB_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NMWEB0010'
                    AND  HMR_ROLE = 'WEB_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NMWEB0020'
       ,'WEB_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NMWEB0020'
                    AND  HMR_ROLE = 'WEB_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NMWEB0035'
       ,'WEB_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NMWEB0035'
                    AND  HMR_ROLE = 'WEB_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NMWEB0043'
       ,'WEB_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NMWEB0043'
                    AND  HMR_ROLE = 'WEB_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NMWEB0044'
       ,'WEB_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NMWEB0044'
                    AND  HMR_ROLE = 'WEB_USER');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NMWEB7057'
       ,'WEB_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NMWEB7057'
                    AND  HMR_ROLE = 'WEB_USER');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- HIG_MODULE_KEYWORDS
--
-- select * from nm3_metadata.hig_module_keywords
-- order by hmk_hmo_module
--         ,hmk_keyword
--         ,hmk_owner
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT hig_module_keywords
SET TERM OFF

INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'ABOUT'
       ,'About form'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'ABOUT'
                    AND  HMK_KEYWORD = 'About form'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'ABOUT_SERVER'
       ,'About Server Objects'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'ABOUT_SERVER'
                    AND  HMK_KEYWORD = 'About Server Objects'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'AUDIT'
       ,'AUDIT TABLES'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'AUDIT'
                    AND  HMK_KEYWORD = 'AUDIT TABLES'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'DOC0100'
       ,'DOCS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'DOC0100'
                    AND  HMK_KEYWORD = 'DOCS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'DOC0100'
       ,'DOCUMENTS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'DOC0100'
                    AND  HMK_KEYWORD = 'DOCUMENTS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'DOC0110'
       ,'DOCUMENT TYPES'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'DOC0110'
                    AND  HMK_KEYWORD = 'DOCUMENT TYPES'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'DOC0112'
       ,'DOCUMENT CLASSES'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'DOC0112'
                    AND  HMK_KEYWORD = 'DOCUMENT CLASSES'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'DOC0114'
       ,'CIRCULATION BY PERSON'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'DOC0114'
                    AND  HMK_KEYWORD = 'CIRCULATION BY PERSON'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'DOC0115'
       ,'CIRCULATION BY DOCUMENT'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'DOC0115'
                    AND  HMK_KEYWORD = 'CIRCULATION BY DOCUMENT'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'DOC0116'
       ,'KEYWORDS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'DOC0116'
                    AND  HMK_KEYWORD = 'KEYWORDS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'DOC0118'
       ,'MEDIA/LOCATIONS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'DOC0118'
                    AND  HMK_KEYWORD = 'MEDIA/LOCATIONS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'DOC0120'
       ,'ASSOCIATED DOCUMENTS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'DOC0120'
                    AND  HMK_KEYWORD = 'ASSOCIATED DOCUMENTS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'DOC0122'
       ,'KEYWORD SEARCH'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'DOC0122'
                    AND  HMK_KEYWORD = 'KEYWORD SEARCH'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'DOC0130'
       ,'DOCUMENT GATEWAYS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'DOC0130'
                    AND  HMK_KEYWORD = 'DOCUMENT GATEWAYS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'DOC0140'
       ,'LIST OF DOCUMENTS BY ASSOCIATI'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'DOC0140'
                    AND  HMK_KEYWORD = 'LIST OF DOCUMENTS BY ASSOCIATI'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'DOC0200'
       ,'SELECT TEMPLATE'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'DOC0200'
                    AND  HMK_KEYWORD = 'SELECT TEMPLATE'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'DOC0201'
       ,'TEMPLATES'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'DOC0201'
                    AND  HMK_KEYWORD = 'TEMPLATES'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'DOC0202'
       ,'TEMPLATE USERS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'DOC0202'
                    AND  HMK_KEYWORD = 'TEMPLATE USERS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'GIS0010'
       ,'GIS THEMES'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'GIS0010'
                    AND  HMK_KEYWORD = 'GIS THEMES'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'GRI0200'
       ,'GRI FRONT END'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'GRI0200'
                    AND  HMK_KEYWORD = 'GRI FRONT END'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'GRI0205'
       ,'SERVER BASED LISTENER FOR RUNN'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'GRI0205'
                    AND  HMK_KEYWORD = 'SERVER BASED LISTENER FOR RUNN'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'GRI0210'
       ,'GRI PAST REPORTS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'GRI0210'
                    AND  HMK_KEYWORD = 'GRI PAST REPORTS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'GRI0220'
       ,'GRI MODULES'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'GRI0220'
                    AND  HMK_KEYWORD = 'GRI MODULES'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'GRI0230'
       ,'GRI PARAMETERS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'GRI0230'
                    AND  HMK_KEYWORD = 'GRI PARAMETERS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'GRI0240'
       ,'GRI MODULE PARAMETERS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'GRI0240'
                    AND  HMK_KEYWORD = 'GRI MODULE PARAMETERS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'GRI0250'
       ,'GRI PARAMETER DEPENDENCIES'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'GRI0250'
                    AND  HMK_KEYWORD = 'GRI PARAMETER DEPENDENCIES'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'GRI9998'
       ,'GRI SERVER TEST'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'GRI9998'
                    AND  HMK_KEYWORD = 'GRI SERVER TEST'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'GRI9999'
       ,'GRI TEST REPORT'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'GRI9999'
                    AND  HMK_KEYWORD = 'GRI TEST REPORT'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG1220'
       ,'INTERVALS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG1220'
                    AND  HMK_KEYWORD = 'INTERVALS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG1802'
       ,'MENU OPTIONS FOR A USER'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG1802'
                    AND  HMK_KEYWORD = 'MENU OPTIONS FOR A USER'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG1804'
       ,'MENU OPTIONS FOR A ROLE'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG1804'
                    AND  HMK_KEYWORD = 'MENU OPTIONS FOR A ROLE'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG1806'
       ,'FASTPATH'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG1806'
                    AND  HMK_KEYWORD = 'FASTPATH'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG1807'
       ,'FAVOURITES'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG1807'
                    AND  HMK_KEYWORD = 'FAVOURITES'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG1808'
       ,'SEARCH'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG1808'
                    AND  HMK_KEYWORD = 'SEARCH'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG1809'
       ,'Run Module'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG1809'
                    AND  HMK_KEYWORD = 'Run Module'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG1810'
       ,'COLOUR PALLETTE'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG1810'
                    AND  HMK_KEYWORD = 'COLOUR PALLETTE'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG1815'
       ,'CONTACTS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG1815'
                    AND  HMK_KEYWORD = 'CONTACTS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG1820'
       ,'UNITS AND CONVERSIONS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG1820'
                    AND  HMK_KEYWORD = 'UNITS AND CONVERSIONS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG1832'
       ,'USERS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG1832'
                    AND  HMK_KEYWORD = 'USERS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG1836'
       ,'ROLES'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG1836'
                    AND  HMK_KEYWORD = 'ROLES'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG1839'
       ,'MODULE KEYWORDS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG1839'
                    AND  HMK_KEYWORD = 'MODULE KEYWORDS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG1840'
       ,'USER PREFERENCES'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG1840'
                    AND  HMK_KEYWORD = 'USER PREFERENCES'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG1860'
       ,'ADMIN UNITS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG1860'
                    AND  HMK_KEYWORD = 'ADMIN UNITS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG1862'
       ,'ADMIN UNITS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG1862'
                    AND  HMK_KEYWORD = 'ADMIN UNITS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG1864'
       ,'USERS REPORT'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG1864'
                    AND  HMK_KEYWORD = 'USERS REPORT'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG1880'
       ,'MODULES'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG1880'
                    AND  HMK_KEYWORD = 'MODULES'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG1881'
       ,'Module Usages'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG1881'
                    AND  HMK_KEYWORD = 'Module Usages'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG1890'
       ,'PRODUCTS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG1890'
                    AND  HMK_KEYWORD = 'PRODUCTS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG9110'
       ,'STATUS CODES'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG9110'
                    AND  HMK_KEYWORD = 'STATUS CODES'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG9115'
       ,'LIST OF STATUS CODES'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG9115'
                    AND  HMK_KEYWORD = 'LIST OF STATUS CODES'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG9120'
       ,'DOMAINS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG9120'
                    AND  HMK_KEYWORD = 'DOMAINS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG9125'
       ,'LIST OF STATIC REFERENCE DATA'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG9125'
                    AND  HMK_KEYWORD = 'LIST OF STATIC REFERENCE DATA'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG9130'
       ,'PRODUCT OPTIONS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG9130'
                    AND  HMK_KEYWORD = 'PRODUCT OPTIONS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG9170'
       ,'HOLIDAYS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG9170'
                    AND  HMK_KEYWORD = 'HOLIDAYS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG9180'
       ,'ERRORS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG9180'
                    AND  HMK_KEYWORD = 'ERRORS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIG9190'
       ,'TXT TO PRN CONVERSION'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIG9190'
                    AND  HMK_KEYWORD = 'TXT TO PRN CONVERSION'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'HIGHWAYS'
       ,'HIGHWAYS BY EXOR LAUNCHPAD'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'HIGHWAYS'
                    AND  HMK_KEYWORD = 'HIGHWAYS BY EXOR LAUNCHPAD'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NET1100'
       ,'GAZETTEER'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NET1100'
                    AND  HMK_KEYWORD = 'GAZETTEER'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0001'
       ,'NODE TYPES'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0001'
                    AND  HMK_KEYWORD = 'NODE TYPES'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0002'
       ,'NETWORK TYPES'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0002'
                    AND  HMK_KEYWORD = 'NETWORK TYPES'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0004'
       ,'GROUP TYPES'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0004'
                    AND  HMK_KEYWORD = 'GROUP TYPES'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0101'
       ,'NODES'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0101'
                    AND  HMK_KEYWORD = 'NODES'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0105'
       ,'ELEMENTS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0105'
                    AND  HMK_KEYWORD = 'ELEMENTS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0106'
       ,'Element Details'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0106'
                    AND  HMK_KEYWORD = 'Element Details'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0107'
       ,'ELEMENT MEMBERS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0107'
                    AND  HMK_KEYWORD = 'ELEMENT MEMBERS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0110'
       ,'GROUPS OF SECTIONS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0110'
                    AND  HMK_KEYWORD = 'GROUPS OF SECTIONS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0115'
       ,'GROUPS OF GROUPS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0115'
                    AND  HMK_KEYWORD = 'GROUPS OF GROUPS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0120'
       ,'CREATE NETWORK EXTENT'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0120'
                    AND  HMK_KEYWORD = 'CREATE NETWORK EXTENT'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0121'
       ,'CREATE GROUP'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0121'
                    AND  HMK_KEYWORD = 'CREATE GROUP'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0122'
       ,'Extent Limits'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0122'
                    AND  HMK_KEYWORD = 'Extent Limits'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0200'
       ,'SPLIT ELEMENT'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0200'
                    AND  HMK_KEYWORD = 'SPLIT ELEMENT'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0201'
       ,'MERGE ELEMENTS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0201'
                    AND  HMK_KEYWORD = 'MERGE ELEMENTS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0202'
       ,'REPLACE ELEMENT'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0202'
                    AND  HMK_KEYWORD = 'REPLACE ELEMENT'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0203'
       ,'UNDO SPLIT'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0203'
                    AND  HMK_KEYWORD = 'UNDO SPLIT'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0204'
       ,'UNDO MERGE'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0204'
                    AND  HMK_KEYWORD = 'UNDO MERGE'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0205'
       ,'UNDO REPLACE'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0205'
                    AND  HMK_KEYWORD = 'UNDO REPLACE'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0206'
       ,'CLOSE ELEMENT'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0206'
                    AND  HMK_KEYWORD = 'CLOSE ELEMENT'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0207'
       ,'UNCLOSE ELEMENT'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0207'
                    AND  HMK_KEYWORD = 'UNCLOSE ELEMENT'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0301'
       ,'INVENTORY DOMAINS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0301'
                    AND  HMK_KEYWORD = 'INVENTORY DOMAINS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0305'
       ,'XSP AND REVERSAL RULES'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0305'
                    AND  HMK_KEYWORD = 'XSP AND REVERSAL RULES'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0306'
       ,'INVENTORY XSPS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0306'
                    AND  HMK_KEYWORD = 'INVENTORY XSPS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0410'
       ,'INVENTORY METAMODEL'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0410'
                    AND  HMK_KEYWORD = 'INVENTORY METAMODEL'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0500'
       ,'NETWORK WALKER'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0500'
                    AND  HMK_KEYWORD = 'NETWORK WALKER'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0510'
       ,'INVENTORY ITEMS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0510'
                    AND  HMK_KEYWORD = 'INVENTORY ITEMS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0530'
       ,'GLOBAL INVENTORY UPDATE'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0530'
                    AND  HMK_KEYWORD = 'GLOBAL INVENTORY UPDATE'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM0550'
       ,'CROSS ATTRIBUTE VALIDATION'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM0550'
                    AND  HMK_KEYWORD = 'CROSS ATTRIBUTE VALIDATION'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM1100'
       ,'Gazetteer'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM1100'
                    AND  HMK_KEYWORD = 'Gazetteer'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM2000'
       ,'RECALIBRATE ELEMENT'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM2000'
                    AND  HMK_KEYWORD = 'RECALIBRATE ELEMENT'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM7040'
       ,'PBI QUERIES'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM7040'
                    AND  HMK_KEYWORD = 'PBI QUERIES'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM7041'
       ,'PBI QUERY RESULTS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM7041'
                    AND  HMK_KEYWORD = 'PBI QUERY RESULTS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM7050'
       ,'MERGE QUERIES'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM7050'
                    AND  HMK_KEYWORD = 'MERGE QUERIES'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM7051B'
       ,'MERGE QUERY RESULTS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM7051B'
                    AND  HMK_KEYWORD = 'MERGE QUERY RESULTS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM7052'
       ,'NERGE QUERY'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM7052'
                    AND  HMK_KEYWORD = 'NERGE QUERY'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM7053'
       ,'MERGE QUERY DEFAULTS'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM7053'
                    AND  HMK_KEYWORD = 'MERGE QUERY DEFAULTS'
                    AND  HMK_OWNER = 1);
--
INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
SELECT 
        'NM9999'
       ,'EXTENDED LOV'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                   WHERE HMK_HMO_MODULE = 'NM9999'
                    AND  HMK_KEYWORD = 'EXTENDED LOV'
                    AND  HMK_OWNER = 1);
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- HIG_PROCESS_AREAS
--
-- select * from nm3_metadata.hig_process_areas
-- order by hpa_area_type
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT hig_process_areas
SET TERM OFF

INSERT INTO HIG_PROCESS_AREAS
       (HPA_AREA_TYPE
       ,HPA_DESCRIPTION
       ,HPA_TABLE
       ,HPA_RESTRICTED_TABLE
       ,HPA_WHERE_CLAUSE
       ,HPA_RESTRICTED_WHERE_CLAUSE
       ,HPA_ID_COLUMN
       ,HPA_MEANING_COLUMN
       )
SELECT 
        'ADMIN_UNIT'
       ,'Admin Unit'
       ,'NM_ADMIN_UNITS'
       ,'V_NM_USER_ADMIN_UNITS'
       ,''
       ,''
       ,'NAU_ADMIN_UNIT'
       ,'SUBSTR(RPAD(NAU_UNIT_CODE,4,'' ''),1,4)||'' - ''||NAU_NAME' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PROCESS_AREAS
                   WHERE HPA_AREA_TYPE = 'ADMIN_UNIT');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- HIG_PROCESS_TYPES
--
-- select * from nm3_metadata.hig_process_types
-- order by hpt_process_type_id
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT hig_process_types
SET TERM OFF

INSERT INTO HIG_PROCESS_TYPES
       (HPT_PROCESS_TYPE_ID
       ,HPT_NAME
       ,HPT_DESCR
       ,HPT_WHAT_TO_CALL
       ,HPT_INITIATION_MODULE
       ,HPT_INTERNAL_MODULE
       ,HPT_INTERNAL_MODULE_PARAM
       ,HPT_PROCESS_LIMIT
       ,HPT_RESTARTABLE
       ,HPT_SEE_IN_HIG2510
       ,HPT_POLLING_ENABLED
       ,HPT_POLLING_FTP_TYPE_ID
       ,HPT_AREA_TYPE
       )
SELECT 
        -2
       ,'Load Document Bundles'
       ,'Unpacks document bundle zip file(s) '||CHR(10)||'Reads the driving file(s)'||CHR(10)||'Creates document and document association records'||CHR(10)||'Moves the document files to the correct location'
       ,'doc_bundle_loader.initialise;'
       ,'DOC0300'
       ,'DOC0310'
       ,'P_PROCESS_ID'
       ,null
       ,'N'
       ,'Y'
       ,'Y'
       ,null
       ,'ADMIN_UNIT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PROCESS_TYPES
                   WHERE HPT_PROCESS_TYPE_ID = -2);
--
INSERT INTO HIG_PROCESS_TYPES
       (HPT_PROCESS_TYPE_ID
       ,HPT_NAME
       ,HPT_DESCR
       ,HPT_WHAT_TO_CALL
       ,HPT_INITIATION_MODULE
       ,HPT_INTERNAL_MODULE
       ,HPT_INTERNAL_MODULE_PARAM
       ,HPT_PROCESS_LIMIT
       ,HPT_RESTARTABLE
       ,HPT_SEE_IN_HIG2510
       ,HPT_POLLING_ENABLED
       ,HPT_POLLING_FTP_TYPE_ID
       ,HPT_AREA_TYPE
       )
SELECT 
        -1
       ,'Alert Manager'
       ,'This Process will sent out pending Alerts every 10 minutes'
       ,'hig_alert.run_alert_batch;'
       ,''
       ,''
       ,''
       ,null
       ,'N'
       ,'Y'
       ,'N'
       ,null
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PROCESS_TYPES
                   WHERE HPT_PROCESS_TYPE_ID = -1);
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- HIG_PROCESS_TYPE_ROLES
--
-- select * from nm3_metadata.hig_process_type_roles
-- order by hptr_process_type_id
--         ,hptr_role
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT hig_process_type_roles
SET TERM OFF

INSERT INTO HIG_PROCESS_TYPE_ROLES
       (HPTR_PROCESS_TYPE_ID
       ,HPTR_ROLE
       )
SELECT 
        -2
       ,'DOC_USER' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PROCESS_TYPE_ROLES
                   WHERE HPTR_PROCESS_TYPE_ID = -2
                    AND  HPTR_ROLE = 'DOC_USER');
--
INSERT INTO HIG_PROCESS_TYPE_ROLES
       (HPTR_PROCESS_TYPE_ID
       ,HPTR_ROLE
       )
SELECT 
        -1
       ,'HIG_USER' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PROCESS_TYPE_ROLES
                   WHERE HPTR_PROCESS_TYPE_ID = -1
                    AND  HPTR_ROLE = 'HIG_USER');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- HIG_SCHEDULING_FREQUENCIES
--
-- select * from nm3_metadata.hig_scheduling_frequencies
-- order by hsfr_frequency_id
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT hig_scheduling_frequencies
SET TERM OFF

INSERT INTO HIG_SCHEDULING_FREQUENCIES
       (HSFR_FREQUENCY_ID
       ,HSFR_MEANING
       ,HSFR_FREQUENCY
       ,HSFR_INTERVAL_IN_MINS
       )
SELECT 
        -13
       ,'Daily at Midday'
       ,'freq=daily; byhour=12; byminute=0; bysecond=0;'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SCHEDULING_FREQUENCIES
                   WHERE HSFR_FREQUENCY_ID = -13);
--
INSERT INTO HIG_SCHEDULING_FREQUENCIES
       (HSFR_FREQUENCY_ID
       ,HSFR_MEANING
       ,HSFR_FREQUENCY
       ,HSFR_INTERVAL_IN_MINS
       )
SELECT 
        -12
       ,'Daily'
       ,'freq=daily;'
       ,1440 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SCHEDULING_FREQUENCIES
                   WHERE HSFR_FREQUENCY_ID = -12);
--
INSERT INTO HIG_SCHEDULING_FREQUENCIES
       (HSFR_FREQUENCY_ID
       ,HSFR_MEANING
       ,HSFR_FREQUENCY
       ,HSFR_INTERVAL_IN_MINS
       )
SELECT 
        -11
       ,'Daily at Midnight'
       ,'freq=daily; byhour=0; byminute=0; bysecond=0;'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SCHEDULING_FREQUENCIES
                   WHERE HSFR_FREQUENCY_ID = -11);
--
INSERT INTO HIG_SCHEDULING_FREQUENCIES
       (HSFR_FREQUENCY_ID
       ,HSFR_MEANING
       ,HSFR_FREQUENCY
       ,HSFR_INTERVAL_IN_MINS
       )
SELECT 
        -10
       ,'Hourly'
       ,'freq=hourly;'
       ,60 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SCHEDULING_FREQUENCIES
                   WHERE HSFR_FREQUENCY_ID = -10);
--
INSERT INTO HIG_SCHEDULING_FREQUENCIES
       (HSFR_FREQUENCY_ID
       ,HSFR_MEANING
       ,HSFR_FREQUENCY
       ,HSFR_INTERVAL_IN_MINS
       )
SELECT 
        -9
       ,'Hourly (on the hour)'
       ,'freq=hourly; byminute=0; bysecond=0;'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SCHEDULING_FREQUENCIES
                   WHERE HSFR_FREQUENCY_ID = -9);
--
INSERT INTO HIG_SCHEDULING_FREQUENCIES
       (HSFR_FREQUENCY_ID
       ,HSFR_MEANING
       ,HSFR_FREQUENCY
       ,HSFR_INTERVAL_IN_MINS
       )
SELECT 
        -8
       ,'45 Minutes'
       ,'freq=minutely; interval=45;'
       ,45 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SCHEDULING_FREQUENCIES
                   WHERE HSFR_FREQUENCY_ID = -8);
--
INSERT INTO HIG_SCHEDULING_FREQUENCIES
       (HSFR_FREQUENCY_ID
       ,HSFR_MEANING
       ,HSFR_FREQUENCY
       ,HSFR_INTERVAL_IN_MINS
       )
SELECT 
        -7
       ,'30 Minutes'
       ,'freq=minutely; interval=30;'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SCHEDULING_FREQUENCIES
                   WHERE HSFR_FREQUENCY_ID = -7);
--
INSERT INTO HIG_SCHEDULING_FREQUENCIES
       (HSFR_FREQUENCY_ID
       ,HSFR_MEANING
       ,HSFR_FREQUENCY
       ,HSFR_INTERVAL_IN_MINS
       )
SELECT 
        -6
       ,'20 Minutes'
       ,'freq=minutely; interval=20;'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SCHEDULING_FREQUENCIES
                   WHERE HSFR_FREQUENCY_ID = -6);
--
INSERT INTO HIG_SCHEDULING_FREQUENCIES
       (HSFR_FREQUENCY_ID
       ,HSFR_MEANING
       ,HSFR_FREQUENCY
       ,HSFR_INTERVAL_IN_MINS
       )
SELECT 
        -5
       ,'15 Minutes'
       ,'freq=minutely; interval=15;'
       ,15 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SCHEDULING_FREQUENCIES
                   WHERE HSFR_FREQUENCY_ID = -5);
--
INSERT INTO HIG_SCHEDULING_FREQUENCIES
       (HSFR_FREQUENCY_ID
       ,HSFR_MEANING
       ,HSFR_FREQUENCY
       ,HSFR_INTERVAL_IN_MINS
       )
SELECT 
        -4
       ,'10 Minutes'
       ,'freq=minutely; interval=10;'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SCHEDULING_FREQUENCIES
                   WHERE HSFR_FREQUENCY_ID = -4);
--
INSERT INTO HIG_SCHEDULING_FREQUENCIES
       (HSFR_FREQUENCY_ID
       ,HSFR_MEANING
       ,HSFR_FREQUENCY
       ,HSFR_INTERVAL_IN_MINS
       )
SELECT 
        -3
       ,'5 Minutes'
       ,'freq=minutely; interval=5;'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SCHEDULING_FREQUENCIES
                   WHERE HSFR_FREQUENCY_ID = -3);
--
INSERT INTO HIG_SCHEDULING_FREQUENCIES
       (HSFR_FREQUENCY_ID
       ,HSFR_MEANING
       ,HSFR_FREQUENCY
       ,HSFR_INTERVAL_IN_MINS
       )
SELECT 
        -2
       ,'30 Seconds'
       ,'freq=secondly; interval=30;'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SCHEDULING_FREQUENCIES
                   WHERE HSFR_FREQUENCY_ID = -2);
--
INSERT INTO HIG_SCHEDULING_FREQUENCIES
       (HSFR_FREQUENCY_ID
       ,HSFR_MEANING
       ,HSFR_FREQUENCY
       ,HSFR_INTERVAL_IN_MINS
       )
SELECT 
        -1
       ,'Once'
       ,''
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SCHEDULING_FREQUENCIES
                   WHERE HSFR_FREQUENCY_ID = -1);
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- HIG_PROCESS_TYPE_FREQUENCIES
--
-- select * from nm3_metadata.hig_process_type_frequencies
-- order by hpfr_process_type_id
--         ,hpfr_frequency_id
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT hig_process_type_frequencies
SET TERM OFF

INSERT INTO HIG_PROCESS_TYPE_FREQUENCIES
       (HPFR_PROCESS_TYPE_ID
       ,HPFR_FREQUENCY_ID
       ,HPFR_SEQ
       )
SELECT 
        -2
       ,-1
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PROCESS_TYPE_FREQUENCIES
                   WHERE HPFR_PROCESS_TYPE_ID = -2
                    AND  HPFR_FREQUENCY_ID = -1);
--
INSERT INTO HIG_PROCESS_TYPE_FREQUENCIES
       (HPFR_PROCESS_TYPE_ID
       ,HPFR_FREQUENCY_ID
       ,HPFR_SEQ
       )
SELECT 
        -1
       ,-4
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PROCESS_TYPE_FREQUENCIES
                   WHERE HPFR_PROCESS_TYPE_ID = -1
                    AND  HPFR_FREQUENCY_ID = -4);
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- HIG_PROCESS_TYPE_FILES
--
-- select * from nm3_metadata.hig_process_type_files
-- order by hptf_file_type_id
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT hig_process_type_files
SET TERM OFF

INSERT INTO HIG_PROCESS_TYPE_FILES
       (HPTF_FILE_TYPE_ID
       ,HPTF_NAME
       ,HPTF_PROCESS_TYPE_ID
       ,HPTF_INPUT
       ,HPTF_OUTPUT
       ,HPTF_INPUT_DESTINATION
       ,HPTF_INPUT_DESTINATION_TYPE
       ,HPTF_MIN_INPUT_FILES
       ,HPTF_MAX_INPUT_FILES
       ,HPTF_OUTPUT_DESTINATION
       ,HPTF_OUTPUT_DESTINATION_TYPE
       )
SELECT 
        -1
       ,'Doc Bundle'
       ,-2
       ,'Y'
       ,'N'
       ,''
       ,'ORACLE_DIRECTORY'
       ,1
       ,null
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PROCESS_TYPE_FILES
                   WHERE HPTF_FILE_TYPE_ID = -1);
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- HIG_MODULE_BLOCKS
--
-- select * from nm3_metadata.hig_module_blocks
-- order by hmb_module_name
--         ,hmb_block_name
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT hig_module_blocks
SET TERM OFF

INSERT INTO HIG_MODULE_BLOCKS
       (HMB_MODULE_NAME
       ,HMB_BLOCK_NAME
       ,HMB_DATE_CREATED
       ,HMB_DATE_MODIFIED
       ,HMB_CREATED_BY
       ,HMB_MODIFIED_BY
       )
SELECT 
        'DOC0310'
       ,'DOC_BUNDLES_V'
       ,to_date('20110325090937','YYYYMMDDHH24MISS')
       ,to_date('20110325090937','YYYYMMDDHH24MISS')
       ,'NM3_METADATA'
       ,'NM3_METADATA' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_BLOCKS
                   WHERE HMB_MODULE_NAME = 'DOC0310'
                    AND  HMB_BLOCK_NAME = 'DOC_BUNDLES_V');
--
INSERT INTO HIG_MODULE_BLOCKS
       (HMB_MODULE_NAME
       ,HMB_BLOCK_NAME
       ,HMB_DATE_CREATED
       ,HMB_DATE_MODIFIED
       ,HMB_CREATED_BY
       ,HMB_MODIFIED_BY
       )
SELECT 
        'HIG1505'
       ,'HAUD'
       ,to_date('20100920141912','YYYYMMDDHH24MISS')
       ,to_date('20100920141912','YYYYMMDDHH24MISS')
       ,'NM3_METADATA'
       ,'NM3_METADATA' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_BLOCKS
                   WHERE HMB_MODULE_NAME = 'HIG1505'
                    AND  HMB_BLOCK_NAME = 'HAUD');
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
