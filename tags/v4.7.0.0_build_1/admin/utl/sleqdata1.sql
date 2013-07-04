--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/utl/sleqdata1.sql-arc   2.1   Jul 04 2013 10:30:14   James.Wadsworth  $
--       Module Name      : $Workfile:   sleqdata1.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 10:30:14  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:28:40  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
/***************************************************************************

INFO
====
As at Release 4.0

GENERATION DATE
===============
19-JUL-2006 13:11

TABLES PROCESSED
================
NM_INV_DOMAINS_ALL
NM_INV_ATTRI_LOOKUP_ALL
NM_INV_TYPES_ALL
NM_INV_TYPE_ATTRIBS_ALL
NM_INV_TYPE_ROLES

TABLE OWNER
===========
NM3DATA_SLM

MODE (A-Append R-Refresh)
========================
A

***************************************************************************/

define sccsid = '@(#)sleqdata1.sql	1.3 07/19/06'
set define off;
set feedback off;

--------------------
-- PRE-PROCESSING --
--------------------
--
-- Grab default admin type to apply to nm_inv_types_all data
--
set define on
set term off
undefine p1
col      p1  new_value p1 noprint
select nau_admin_type p1
from   nm_admin_units_all nau
where nau.nau_admin_unit = 1
/
set term on
--
------------------------------------------------------------
--


---------------------------------
-- START OF GENERATED METADATA --
---------------------------------

--
--********** NM_INV_DOMAINS_ALL **********--
--
-- Columns
-- ID_DOMAIN                      NOT NULL VARCHAR2(30)
--   ID_PK (Pos 1)
-- ID_TITLE                       NOT NULL VARCHAR2(80)
-- ID_START_DATE                  NOT NULL DATE
--   ID_START_DATE_TCHK
-- ID_END_DATE                             DATE
--   ID_END_DATE_TCHK
-- ID_DATATYPE                    NOT NULL VARCHAR2(8)
--   ID_DATATYPE_CHK
-- ID_DATE_CREATED                NOT NULL DATE
-- ID_DATE_MODIFIED               NOT NULL DATE
-- ID_MODIFIED_BY                 NOT NULL VARCHAR2(30)
-- ID_CREATED_BY                  NOT NULL VARCHAR2(30)
--
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_ITEM_CLASS'
       ,'ITEM CLASS CODES'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_ITEM_CLASS');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_PECU_TYPE'
       ,'PECU TYPE'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_PECU_TYPE');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_SWITCH_TYPE'
       ,'SWITCH TYPE'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_SWITCH_TYPE');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_TIME_ON'
       ,'TIME ON'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_TIME_ON');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_TIME_OFF'
       ,'TIME OFF'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_TIME_OFF');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_LAMP_TYPE'
       ,'LAMP TYPE'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_LAMP_TYPE');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_GEAR_TYPE'
       ,'GEAR TYPE'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_GEAR_TYPE');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_INDIV_GROUP'
       ,'INDIVIDUAL OR GROUP CONTROL'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_INDIV_GROUP');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'Y_OR_N'
       ,'YES OR NO'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'Y_OR_N');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_METERED'
       ,'METERED OR UNMETERED'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_METERED');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_MANU'
       ,'COLUMN MANUFACTURER'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_COLUMN_MANU');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_MATERIAL'
       ,'COLUMN MATERIAL'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_COLUMN_MATERIAL');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_PROTECTIVE_COAT'
       ,'PROTECTIVE COATING'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_PROTECTIVE_COAT');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_PAINT_COLOUR'
       ,'PAINT COLOUR'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_PAINT_COLOUR');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_FIXING'
       ,'COLUMN FIXING'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_COLUMN_FIXING');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_X_SECT'
       ,'COLUMN CROSS SECTION'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_COLUMN_X_SECT');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_LANTERN_MANU'
       ,'LANTERN MANUFACTURER'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_LANTERN_MANU');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_LANTERN_MODEL'
       ,'LANTERN MODEL REFERENCE NUMBER'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_LANTERN_MODEL');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_LANTERN_DISTRIBUTION'
       ,'LANTERN DISTRIBUTION'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_LANTERN_DISTRIBUTION');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_LANTERN_SETTINGS'
       ,'LANTERN SETTINGS'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_LANTERN_SETTINGS');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_LANTERN_PROTECTION'
       ,'LANTERN PROTECTION'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_LANTERN_PROTECTION');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_SIGN_DIAGRAM_NO'
       ,'SIGN DIAGRAM NUMBER'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_SIGN_DIAGRAM_NO');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_ROOT_PROTECTION'
       ,'COLUMN ROOT PROTECTION'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_COLUMN_ROOT_PROTECTION');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_FLANGE_BASE'
       ,'FLANGE BASE'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_FLANGE_BASE');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_LOCATION'
       ,'COLUMN LOCATION'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,to_date('20050704092156','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_COLUMN_LOCATION');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_ROAD_ENVIRONMNET'
       ,'ROAD ENVIRONMENT'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092157','YYYYMMDDHH24MISS')
       ,to_date('20050704092157','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_ROAD_ENVIRONMNET');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_GROUND_CONDITIONS'
       ,'GROUN CONDITIONS'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092157','YYYYMMDDHH24MISS')
       ,to_date('20050704092157','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_GROUND_CONDITIONS');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_WIND_EXPOSURE'
       ,'WIND EXPOSURE'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092157','YYYYMMDDHH24MISS')
       ,to_date('20050704092157','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_WIND_EXPOSURE');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_ENV_SITUATION'
       ,'ENVIRONMENT SITUATION'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092157','YYYYMMDDHH24MISS')
       ,to_date('20050704092157','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_ENV_SITUATION');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_DESIGNED_FOR_FATIGUE'
       ,'DESIGNED FOR FATIGUE'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092157','YYYYMMDDHH24MISS')
       ,to_date('20050704092157','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_DESIGNED_FOR_FATIGUE');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_ATTACHEMENTS'
       ,'ATTACHMENTS'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092157','YYYYMMDDHH24MISS')
       ,to_date('20050704092157','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_ATTACHEMENTS');
--
INSERT INTO NM_INV_DOMAINS_ALL
       (ID_DOMAIN
       ,ID_TITLE
       ,ID_START_DATE
       ,ID_END_DATE
       ,ID_DATATYPE
       ,ID_DATE_CREATED
       ,ID_DATE_MODIFIED
       ,ID_MODIFIED_BY
       ,ID_CREATED_BY
       )
SELECT 
        'SLEQ_EXTERNAL_INFLUENCE'
       ,'EXTERNAL INFLUENCES'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'VARCHAR2'
       ,to_date('20050704092157','YYYYMMDDHH24MISS')
       ,to_date('20050704092157','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_DOMAINS_ALL
                   WHERE ID_DOMAIN = 'SLEQ_EXTERNAL_INFLUENCE');
--
--
--********** NM_INV_ATTRI_LOOKUP_ALL **********--
--
-- Columns
-- IAL_DOMAIN                     NOT NULL VARCHAR2(30)
--   IAD_ID_FK (Pos 1)
--   IAL_PK (Pos 1)
-- IAL_VALUE                      NOT NULL VARCHAR2(30)
--   IAL_PK (Pos 2)
--   IAL_STOP_QUOTE_CHK
-- IAL_DTP_CODE                            VARCHAR2(4)
-- IAL_MEANING                    NOT NULL VARCHAR2(80)
-- IAL_START_DATE                 NOT NULL DATE
--   IAL_PK (Pos 3)
--   IAL_START_DATE_TCHK
-- IAL_END_DATE                            DATE
--   IAL_END_DATE_TCHK
-- IAL_SEQ                        NOT NULL NUMBER(4)
-- IAL_NVA_ID                              VARCHAR2(30)
--   IAL_NVA_FK (Pos 1)
-- IAL_DATE_CREATED               NOT NULL DATE
-- IAL_DATE_MODIFIED              NOT NULL DATE
-- IAL_MODIFIED_BY                NOT NULL VARCHAR2(30)
-- IAL_CREATED_BY                 NOT NULL VARCHAR2(30)
--
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_MATERIAL'
       ,'STEEL'
       ,''
       ,'Steel'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_MATERIAL'
                    AND  IAL_VALUE = 'STEEL'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_MATERIAL'
       ,'CONC'
       ,''
       ,'Concrete'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_MATERIAL'
                    AND  IAL_VALUE = 'CONC'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_MATERIAL'
       ,'ALUM'
       ,''
       ,'Aluminium'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_MATERIAL'
                    AND  IAL_VALUE = 'ALUM'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_PROTECTIVE_COAT'
       ,'EPC'
       ,''
       ,'External Protective Coating'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_PROTECTIVE_COAT'
                    AND  IAL_VALUE = 'EPC'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_PROTECTIVE_COAT'
       ,'HDG'
       ,''
       ,'Hot Dipped Galvanised'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_PROTECTIVE_COAT'
                    AND  IAL_VALUE = 'HDG'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_PROTECTIVE_COAT'
       ,'HDG+'
       ,''
       ,'Hot Dipped Galvanised + External Protective Coating'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_PROTECTIVE_COAT'
                    AND  IAL_VALUE = 'HDG+'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_PAINT_COLOUR'
       ,'BLACK'
       ,''
       ,'Black'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_PAINT_COLOUR'
                    AND  IAL_VALUE = 'BLACK'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_PAINT_COLOUR'
       ,'BLUE'
       ,''
       ,'Blue'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_PAINT_COLOUR'
                    AND  IAL_VALUE = 'BLUE'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_PAINT_COLOUR'
       ,'GREEN'
       ,''
       ,'Green'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_PAINT_COLOUR'
                    AND  IAL_VALUE = 'GREEN'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_FIXING'
       ,'PLANT'
       ,''
       ,'Plant'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_FIXING'
                    AND  IAL_VALUE = 'PLANT'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_FIXING'
       ,'FLANGE'
       ,''
       ,'Flange'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_FIXING'
                    AND  IAL_VALUE = 'FLANGE'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_FIXING'
       ,'WALL'
       ,''
       ,'Wall'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_FIXING'
                    AND  IAL_VALUE = 'WALL'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_X_SECT'
       ,'TUB'
       ,''
       ,'Tubular'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_X_SECT'
                    AND  IAL_VALUE = 'TUB'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_X_SECT'
       ,'HEX'
       ,''
       ,'Hexagonal'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_X_SECT'
                    AND  IAL_VALUE = 'HEX'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_X_SECT'
       ,'OCT'
       ,''
       ,'Octagonal'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_X_SECT'
                    AND  IAL_VALUE = 'OCT'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LANTERN_MANU'
       ,'URBIS'
       ,''
       ,'Urbis'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LANTERN_MANU'
                    AND  IAL_VALUE = 'URBIS'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LANTERN_MANU'
       ,'THORN'
       ,''
       ,'Thorn'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LANTERN_MANU'
                    AND  IAL_VALUE = 'THORN'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LANTERN_MANU'
       ,'PHILIPS'
       ,''
       ,'Philips'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LANTERN_MANU'
                    AND  IAL_VALUE = 'PHILIPS'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LANTERN_MANU'
       ,'PHOSCO'
       ,''
       ,'Phosco'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,4
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LANTERN_MANU'
                    AND  IAL_VALUE = 'PHOSCO'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LANTERN_MANU'
       ,'WHITECROFT'
       ,''
       ,'Whitecroft'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,5
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LANTERN_MANU'
                    AND  IAL_VALUE = 'WHITECROFT'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LANTERN_MODEL'
       ,'SGS306'
       ,''
       ,'SGS306'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LANTERN_MODEL'
                    AND  IAL_VALUE = 'SGS306'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LANTERN_MODEL'
       ,'ZX3'
       ,''
       ,'ZX3'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LANTERN_MODEL'
                    AND  IAL_VALUE = 'ZX3'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LANTERN_DISTRIBUTION'
       ,'TI'
       ,''
       ,'Low Threshold Increment'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LANTERN_DISTRIBUTION'
                    AND  IAL_VALUE = 'TI'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LANTERN_DISTRIBUTION'
       ,'MTI'
       ,''
       ,'Medium Threshold Increment'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LANTERN_DISTRIBUTION'
                    AND  IAL_VALUE = 'MTI'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LANTERN_DISTRIBUTION'
       ,'FG'
       ,''
       ,'Flat Glass'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LANTERN_DISTRIBUTION'
                    AND  IAL_VALUE = 'FG'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LANTERN_DISTRIBUTION'
       ,'LP'
       ,''
       ,'Low Profile'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,4
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LANTERN_DISTRIBUTION'
                    AND  IAL_VALUE = 'LP'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LANTERN_DISTRIBUTION'
       ,'CT'
       ,''
       ,'Curved Tempered'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,5
       ,''
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,to_date('20050704092338','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LANTERN_DISTRIBUTION'
                    AND  IAL_VALUE = 'CT'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LANTERN_SETTINGS'
       ,'POS11X'
       ,''
       ,'POS11X'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LANTERN_SETTINGS'
                    AND  IAL_VALUE = 'POS11X'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LANTERN_SETTINGS'
       ,'901141'
       ,''
       ,'901141'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LANTERN_SETTINGS'
                    AND  IAL_VALUE = '901141'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LANTERN_PROTECTION'
       ,'IP65'
       ,''
       ,'IP65'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LANTERN_PROTECTION'
                    AND  IAL_VALUE = 'IP65'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_SIGN_DIAGRAM_NO'
       ,'602'
       ,''
       ,'602'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_SIGN_DIAGRAM_NO'
                    AND  IAL_VALUE = '602'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_SIGN_DIAGRAM_NO'
       ,'ADS'
       ,''
       ,'ADS'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_SIGN_DIAGRAM_NO'
                    AND  IAL_VALUE = 'ADS'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_ROOT_PROTECTION'
       ,'NP'
       ,''
       ,'No Protection'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_ROOT_PROTECTION'
                    AND  IAL_VALUE = 'NP'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_ROOT_PROTECTION'
       ,'PC'
       ,''
       ,'Protective Coating'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_ROOT_PROTECTION'
                    AND  IAL_VALUE = 'PC'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_ROOT_PROTECTION'
       ,'CF'
       ,''
       ,'Full depth concrete foundation'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_ROOT_PROTECTION'
                    AND  IAL_VALUE = 'CF'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_FLANGE_BASE'
       ,'B'
       ,''
       ,'Flange Plate Buried'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_FLANGE_BASE'
                    AND  IAL_VALUE = 'B'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_FLANGE_BASE'
       ,'ENP'
       ,''
       ,'Flange Plate exposed not protected'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_FLANGE_BASE'
                    AND  IAL_VALUE = 'ENP'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_FLANGE_BASE'
       ,'EP'
       ,''
       ,'Flange Plate exposed protected'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_FLANGE_BASE'
                    AND  IAL_VALUE = 'EP'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_LOCATION'
       ,'CENTRAL RESERVE'
       ,''
       ,'Central Reserve'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_LOCATION'
                    AND  IAL_VALUE = 'CENTRAL RESERVE'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_LOCATION'
       ,'SIDE OF ROAD'
       ,''
       ,'Side of Road'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_LOCATION'
                    AND  IAL_VALUE = 'SIDE OF ROAD'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_LOCATION'
       ,'SLIP ROAD'
       ,''
       ,'Slip Road'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_LOCATION'
                    AND  IAL_VALUE = 'SLIP ROAD'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_LOCATION'
       ,'ROUNDABOUT'
       ,''
       ,'Roundabout'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,4
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_LOCATION'
                    AND  IAL_VALUE = 'ROUNDABOUT'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_LOCATION'
       ,'ON A BRIDGE'
       ,''
       ,'On a Bridge'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,5
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_LOCATION'
                    AND  IAL_VALUE = 'ON A BRIDGE'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ROAD_ENVIRONMNET'
       ,'RESIDENTIAL'
       ,''
       ,'Residential'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ROAD_ENVIRONMNET'
                    AND  IAL_VALUE = 'RESIDENTIAL'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ROAD_ENVIRONMNET'
       ,'OTHER URBAN'
       ,''
       ,'Other Urban'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ROAD_ENVIRONMNET'
                    AND  IAL_VALUE = 'OTHER URBAN'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ROAD_ENVIRONMNET'
       ,'RURAL'
       ,''
       ,'Rural'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ROAD_ENVIRONMNET'
                    AND  IAL_VALUE = 'RURAL'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ROAD_ENVIRONMNET'
       ,'MOTORWAYS'
       ,''
       ,'Motorways'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,4
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ROAD_ENVIRONMNET'
                    AND  IAL_VALUE = 'MOTORWAYS'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_GROUND_CONDITIONS'
       ,'POORLY DRAINED'
       ,''
       ,'Poorly Drained'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_GROUND_CONDITIONS'
                    AND  IAL_VALUE = 'POORLY DRAINED'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_GROUND_CONDITIONS'
       ,'WELL DRAINED'
       ,''
       ,'Well Drained'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_GROUND_CONDITIONS'
                    AND  IAL_VALUE = 'WELL DRAINED'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_WIND_EXPOSURE'
       ,'EXPOSED'
       ,''
       ,'Exposed'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_WIND_EXPOSURE'
                    AND  IAL_VALUE = 'EXPOSED'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_WIND_EXPOSURE'
       ,'NORMAL'
       ,''
       ,'Normal'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_WIND_EXPOSURE'
                    AND  IAL_VALUE = 'NORMAL'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_WIND_EXPOSURE'
       ,'SHELTERED'
       ,''
       ,'Sheltered'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_WIND_EXPOSURE'
                    AND  IAL_VALUE = 'SHELTERED'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ENV_SITUATION'
       ,'NS     '
       ,''
       ,'Near Seafront'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ENV_SITUATION'
                    AND  IAL_VALUE = 'NS     '
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ENV_SITUATION'
       ,'SIP     '
       ,''
       ,'Subject to Industrial Pollution'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ENV_SITUATION'
                    AND  IAL_VALUE = 'SIP     '
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ENV_SITUATION'
       ,'INIA'
       ,''
       ,'Inland Non Industrial Area'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ENV_SITUATION'
                    AND  IAL_VALUE = 'INIA'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_DESIGNED_FOR_FATIGUE'
       ,'YES'
       ,''
       ,'Yes'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_DESIGNED_FOR_FATIGUE'
                    AND  IAL_VALUE = 'YES'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_DESIGNED_FOR_FATIGUE'
       ,'NO'
       ,''
       ,'No'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_DESIGNED_FOR_FATIGUE'
                    AND  IAL_VALUE = 'NO'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_DESIGNED_FOR_FATIGUE'
       ,'UNKNOWN'
       ,''
       ,'Unknown'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_DESIGNED_FOR_FATIGUE'
                    AND  IAL_VALUE = 'UNKNOWN'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ATTACHEMENTS'
       ,'FNDA'
       ,''
       ,'Fitted (column not designed for attachments)'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ATTACHEMENTS'
                    AND  IAL_VALUE = 'FNDA'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ATTACHEMENTS'
       ,'FDA'
       ,''
       ,'Fitted (column designed for attachments)'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ATTACHEMENTS'
                    AND  IAL_VALUE = 'FDA'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ATTACHEMENTS'
       ,'NONE'
       ,''
       ,'No Attachements'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ATTACHEMENTS'
                    AND  IAL_VALUE = 'NONE'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_EXTERNAL_INFLUENCE'
       ,'URBAN'
       ,''
       ,'Urban'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_EXTERNAL_INFLUENCE'
                    AND  IAL_VALUE = 'URBAN'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_EXTERNAL_INFLUENCE'
       ,'RURAL'
       ,''
       ,'Rural'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_EXTERNAL_INFLUENCE'
                    AND  IAL_VALUE = 'RURAL'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_INDIV_GROUP'
       ,'GRP'
       ,''
       ,'Group'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_INDIV_GROUP'
                    AND  IAL_VALUE = 'GRP'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'Y_OR_N'
       ,'Y'
       ,''
       ,'Yes'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'Y_OR_N'
                    AND  IAL_VALUE = 'Y'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'Y_OR_N'
       ,'N'
       ,''
       ,'No'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'Y_OR_N'
                    AND  IAL_VALUE = 'N'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_METERED'
       ,'M'
       ,''
       ,'Metered'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_METERED'
                    AND  IAL_VALUE = 'M'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_METERED'
       ,'U'
       ,''
       ,'Unmetered'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_METERED'
                    AND  IAL_VALUE = 'U'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ITEM_CLASS'
       ,'SL'
       ,''
       ,'Street Lighting'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ITEM_CLASS'
                    AND  IAL_VALUE = 'SL'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ITEM_CLASS'
       ,'TS'
       ,''
       ,'Traffic Signals'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ITEM_CLASS'
                    AND  IAL_VALUE = 'TS'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ITEM_CLASS'
       ,'PB'
       ,''
       ,'Pedestrian Crossing Beacons'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ITEM_CLASS'
                    AND  IAL_VALUE = 'PB'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ITEM_CLASS'
       ,'LS'
       ,''
       ,'Lit Traffic Signs'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,4
       ,''
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,to_date('20050704092339','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ITEM_CLASS'
                    AND  IAL_VALUE = 'LS'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ITEM_CLASS'
       ,'TC'
       ,''
       ,'Traffic Cameras'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,5
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ITEM_CLASS'
                    AND  IAL_VALUE = 'TC'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ITEM_CLASS'
       ,'CO'
       ,''
       ,'Traffic Counters'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,6
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ITEM_CLASS'
                    AND  IAL_VALUE = 'CO'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ITEM_CLASS'
       ,'FP'
       ,''
       ,'Feeder Pillars'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,7
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ITEM_CLASS'
                    AND  IAL_VALUE = 'FP'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ITEM_CLASS'
       ,'MC'
       ,''
       ,'Cameras'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,8
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ITEM_CLASS'
                    AND  IAL_VALUE = 'MC'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ITEM_CLASS'
       ,'ME'
       ,''
       ,'Remote Met Equipment'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,9
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ITEM_CLASS'
                    AND  IAL_VALUE = 'ME'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ITEM_CLASS'
       ,'TM'
       ,''
       ,'Traffic Matrix Signals'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,10
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ITEM_CLASS'
                    AND  IAL_VALUE = 'TM'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ITEM_CLASS'
       ,'SC'
       ,''
       ,'School Crossing'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,11
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ITEM_CLASS'
                    AND  IAL_VALUE = 'SC'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ITEM_CLASS'
       ,'HM'
       ,''
       ,'High Mast'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,12
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ITEM_CLASS'
                    AND  IAL_VALUE = 'HM'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ITEM_CLASS'
       ,'CL'
       ,''
       ,'Catenary Lighting'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,13
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ITEM_CLASS'
                    AND  IAL_VALUE = 'CL'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_ITEM_CLASS'
       ,'OT'
       ,''
       ,'Other'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,14
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_ITEM_CLASS'
                    AND  IAL_VALUE = 'OT'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_PECU_TYPE'
       ,'TPC'
       ,''
       ,'Thermal Photo Cell'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_PECU_TYPE'
                    AND  IAL_VALUE = 'TPC'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_PECU_TYPE'
       ,'HPC'
       ,''
       ,'Hybrid Photo Cell'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_PECU_TYPE'
                    AND  IAL_VALUE = 'HPC'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_PECU_TYPE'
       ,'EPC'
       ,''
       ,'Electronic Photo Cell'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_PECU_TYPE'
                    AND  IAL_VALUE = 'EPC'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_PECU_TYPE'
       ,'EPC/L'
       ,''
       ,'Electronic Photo Cell - Latched Relay'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,4
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_PECU_TYPE'
                    AND  IAL_VALUE = 'EPC/L'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_PECU_TYPE'
       ,'CPC/T'
       ,''
       ,'Electronic Photo Cell Time Switch -Part Night Controller'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,5
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_PECU_TYPE'
                    AND  IAL_VALUE = 'CPC/T'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_SWITCH_TYPE'
       ,'24HR'
       ,''
       ,'24 Hour'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,6
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_SWITCH_TYPE'
                    AND  IAL_VALUE = '24HR'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_SWITCH_TYPE'
       ,'MAN'
       ,''
       ,'Manual'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,7
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_SWITCH_TYPE'
                    AND  IAL_VALUE = 'MAN'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_SWITCH_TYPE'
       ,'TIME'
       ,''
       ,'Timed'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,8
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_SWITCH_TYPE'
                    AND  IAL_VALUE = 'TIME'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_TIME_ON'
       ,'SUNS'
       ,''
       ,'Sunset'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_TIME_ON'
                    AND  IAL_VALUE = 'SUNS'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_TIME_ON'
       ,'DUSK'
       ,''
       ,'Dusk'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_TIME_ON'
                    AND  IAL_VALUE = 'DUSK'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_TIME_ON'
       ,'2200'
       ,''
       ,'22:00 hrs'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_TIME_ON'
                    AND  IAL_VALUE = '2200'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_TIME_OFF'
       ,'SUNR'
       ,''
       ,'Sunrise'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_TIME_OFF'
                    AND  IAL_VALUE = 'SUNR'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_TIME_OFF'
       ,'DAWN'
       ,''
       ,'Dawn'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_TIME_OFF'
                    AND  IAL_VALUE = 'DAWN'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_TIME_OFF'
       ,'700'
       ,''
       ,'07:00 hrs'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_TIME_OFF'
                    AND  IAL_VALUE = '700'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LAMP_TYPE'
       ,'SON'
       ,''
       ,'SON'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LAMP_TYPE'
                    AND  IAL_VALUE = 'SON'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LAMP_TYPE'
       ,'SON/T'
       ,''
       ,'SON/T'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LAMP_TYPE'
                    AND  IAL_VALUE = 'SON/T'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LAMP_TYPE'
       ,'SOX'
       ,''
       ,'SOX'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LAMP_TYPE'
                    AND  IAL_VALUE = 'SOX'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LAMP_TYPE'
       ,'SOX/E'
       ,''
       ,'SOX/E'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,4
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LAMP_TYPE'
                    AND  IAL_VALUE = 'SOX/E'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LAMP_TYPE'
       ,'MBF/U'
       ,''
       ,'MBF/U'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,5
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LAMP_TYPE'
                    AND  IAL_VALUE = 'MBF/U'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LAMP_TYPE'
       ,'MCF/U'
       ,''
       ,'MCF/U'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,6
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LAMP_TYPE'
                    AND  IAL_VALUE = 'MCF/U'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LAMP_TYPE'
       ,'GLS'
       ,''
       ,'GLS'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,7
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LAMP_TYPE'
                    AND  IAL_VALUE = 'GLS'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_LAMP_TYPE'
       ,'TH'
       ,''
       ,'TH'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,8
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_LAMP_TYPE'
                    AND  IAL_VALUE = 'TH'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_GEAR_TYPE'
       ,'NONE'
       ,''
       ,'None'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_GEAR_TYPE'
                    AND  IAL_VALUE = 'NONE'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_GEAR_TYPE'
       ,'SG'
       ,''
       ,'Standard Gear'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_GEAR_TYPE'
                    AND  IAL_VALUE = 'SG'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_GEAR_TYPE'
       ,'LLG'
       ,''
       ,'Low Loss Gear'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_GEAR_TYPE'
                    AND  IAL_VALUE = 'LLG'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_GEAR_TYPE'
       ,'HFG'
       ,''
       ,'High Frequency Gear'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,4
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_GEAR_TYPE'
                    AND  IAL_VALUE = 'HFG'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_GEAR_TYPE'
       ,'OG'
       ,''
       ,'Optimum Gear'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,5
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_GEAR_TYPE'
                    AND  IAL_VALUE = 'OG'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_INDIV_GROUP'
       ,'IND'
       ,''
       ,'Individual'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_INDIV_GROUP'
                    AND  IAL_VALUE = 'IND'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_MANU'
       ,'STAINTON'
       ,''
       ,'Stainton'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_MANU'
                    AND  IAL_VALUE = 'STAINTON'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_MANU'
       ,'FABRIKAT'
       ,''
       ,'Fabrikat'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,2
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_MANU'
                    AND  IAL_VALUE = 'FABRIKAT'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_MANU'
       ,'ABACUS'
       ,''
       ,'Abacus'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,3
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_MANU'
                    AND  IAL_VALUE = 'ABACUS'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_MANU'
       ,'CU'
       ,''
       ,'CU'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,4
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_MANU'
                    AND  IAL_VALUE = 'CU'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_MANU'
       ,'BRIT STEEL'
       ,''
       ,'British Steel'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,5
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_MANU'
                    AND  IAL_VALUE = 'BRIT STEEL'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
       (IAL_DOMAIN
       ,IAL_VALUE
       ,IAL_DTP_CODE
       ,IAL_MEANING
       ,IAL_START_DATE
       ,IAL_END_DATE
       ,IAL_SEQ
       ,IAL_NVA_ID
       ,IAL_DATE_CREATED
       ,IAL_DATE_MODIFIED
       ,IAL_MODIFIED_BY
       ,IAL_CREATED_BY
       )
SELECT 
        'SLEQ_COLUMN_MANU'
       ,'MALLATITE'
       ,''
       ,'Mallatite'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,6
       ,''
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,to_date('20050704092340','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_ATTRI_LOOKUP_ALL
                   WHERE IAL_DOMAIN = 'SLEQ_COLUMN_MANU'
                    AND  IAL_VALUE = 'MALLATITE'
                    AND  IAL_START_DATE = to_date('19000101000000','YYYYMMDDHH24MISS'));
--
--
--********** NM_INV_TYPES_ALL **********--
--
-- Columns
-- NIT_INV_TYPE                   NOT NULL VARCHAR2(4)
--   ITY_PK (Pos 1)
--   NIT_INV_TYPE_UPPER_CHK
-- NIT_PNT_OR_CONT                NOT NULL VARCHAR2(1)
--   NIT_CAT_PNT_CONT_CHK
--   NIT_PNT_CONTIG_CHK
-- NIT_X_SECT_ALLOW_FLAG          NOT NULL VARCHAR2(1)
--   AVCON_1119357682_NIT_X_000
-- NIT_ELEC_DRAIN_CARR            NOT NULL VARCHAR2(1)
-- NIT_CONTIGUOUS                 NOT NULL VARCHAR2(1)
--   AVCON_1119357682_NIT_C_000
--   NIT_PNT_CONTIG_CHK
-- NIT_REPLACEABLE                NOT NULL VARCHAR2(1)
--   AVCON_1119357682_NIT_R_000
-- NIT_EXCLUSIVE                  NOT NULL VARCHAR2(1)
--   AVCON_1119357682_NIT_E_000
-- NIT_CATEGORY                   NOT NULL VARCHAR2(1)
--   NIT_CAT_PNT_CONT_CHK
--   NIT_NIC_FK (Pos 1)
-- NIT_DESCR                      NOT NULL VARCHAR2(80)
-- NIT_LINEAR                     NOT NULL VARCHAR2(1)
--   AVCON_1119357682_NIT_L_000
-- NIT_USE_XY                     NOT NULL VARCHAR2(1)
--   AVCON_1119357682_NIT_U_000
-- NIT_MULTIPLE_ALLOWED           NOT NULL VARCHAR2(1)
--   AVCON_1119357682_NIT_M_000
-- NIT_END_LOC_ONLY               NOT NULL VARCHAR2(1)
--   AVCON_1119357682_NIT_E_001
-- NIT_SCREEN_SEQ                          NUMBER(3)
-- NIT_VIEW_NAME                           VARCHAR2(32)
-- NIT_START_DATE                 NOT NULL DATE
--   NIT_START_DATE_TCHK
-- NIT_END_DATE                            DATE
--   NIT_END_DATE_TCHK
-- NIT_SHORT_DESCR                         VARCHAR2(30)
-- NIT_FLEX_ITEM_FLAG             NOT NULL VARCHAR2(1)
--   AVCON_1119357682_NIT_F_000
-- NIT_TABLE_NAME                          VARCHAR2(30)
-- NIT_LR_NE_COLUMN_NAME                   VARCHAR2(30)
-- NIT_LR_ST_CHAIN                         VARCHAR2(30)
-- NIT_LR_END_CHAIN                        VARCHAR2(30)
-- NIT_ADMIN_TYPE                          VARCHAR2(4)
--   NIT_NAT_FK (Pos 1)
-- NIT_ICON_NAME                           VARCHAR2(30)
-- NIT_TOP                        NOT NULL VARCHAR2(1)
--   AVCON_1119357682_NIT_T_000
-- NIT_FOREIGN_PK_COLUMN                   VARCHAR2(30)
-- NIT_UPDATE_ALLOWED             NOT NULL VARCHAR2(1)
--   AVCON_1119357682_NIT_U_001
-- NIT_DATE_CREATED               NOT NULL DATE
-- NIT_DATE_MODIFIED              NOT NULL DATE
-- NIT_MODIFIED_BY                NOT NULL VARCHAR2(30)
-- NIT_CREATED_BY                 NOT NULL VARCHAR2(30)
-- NIT_NOTES                               VARCHAR2(4000)
--
--
INSERT INTO NM_INV_TYPES_ALL
       (NIT_INV_TYPE
       ,NIT_PNT_OR_CONT
       ,NIT_X_SECT_ALLOW_FLAG
       ,NIT_ELEC_DRAIN_CARR
       ,NIT_CONTIGUOUS
       ,NIT_REPLACEABLE
       ,NIT_EXCLUSIVE
       ,NIT_CATEGORY
       ,NIT_DESCR
       ,NIT_LINEAR
       ,NIT_USE_XY
       ,NIT_MULTIPLE_ALLOWED
       ,NIT_END_LOC_ONLY
       ,NIT_SCREEN_SEQ
       ,NIT_VIEW_NAME
       ,NIT_START_DATE
       ,NIT_END_DATE
       ,NIT_SHORT_DESCR
       ,NIT_FLEX_ITEM_FLAG
       ,NIT_TABLE_NAME
       ,NIT_LR_NE_COLUMN_NAME
       ,NIT_LR_ST_CHAIN
       ,NIT_LR_END_CHAIN
       ,NIT_ADMIN_TYPE
       ,NIT_ICON_NAME
       ,NIT_TOP
       ,NIT_FOREIGN_PK_COLUMN
       ,NIT_UPDATE_ALLOWED
       ,NIT_DATE_CREATED
       ,NIT_DATE_MODIFIED
       ,NIT_MODIFIED_BY
       ,NIT_CREATED_BY
       ,NIT_NOTES
       )
SELECT 
        'SLEQ'
       ,'P'
       ,'N'
       ,'C'
       ,'N'
       ,'Y'
       ,'N'
       ,'I'
       ,'Standard Lighting Equipement'
       ,'N'
       ,'N'
       ,'Y'
       ,'N'
       ,null
       ,'V_NM_SLEQ'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,''
       ,'N'
       ,''
       ,''
       ,''
       ,''
       ,'&p1'
       ,''
       ,'N'
       ,''
       ,'Y'
       ,to_date('20050704092707','YYYYMMDDHH24MISS')
       ,to_date('20050704092707','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPES_ALL
                   WHERE NIT_INV_TYPE = 'SLEQ');
--
--
--********** NM_INV_TYPE_ATTRIBS_ALL **********--
--
-- Columns
-- ITA_INV_TYPE                   NOT NULL VARCHAR2(4)
--   ITA_NIT_FK (Pos 1)
--   ITA_PK (Pos 1)
--   ITA_UK_VIEW_ATTRI (Pos 1)
--   ITA_UK_VIEW_COL (Pos 1)
-- ITA_ATTRIB_NAME                NOT NULL VARCHAR2(30)
--   ITA_COL_IIT_PK_MAND_CHK
--   ITA_COL_UPPER_CHK
--   ITA_PK (Pos 2)
-- ITA_DYNAMIC_ATTRIB             NOT NULL VARCHAR2(1)
-- ITA_DISP_SEQ_NO                NOT NULL NUMBER(4)
-- ITA_MANDATORY_YN               NOT NULL VARCHAR2(1)
--   ITA_COL_IIT_PK_MAND_CHK
--   ITA_EXCL_MAND_CHECK
-- ITA_FORMAT                     NOT NULL VARCHAR2(10)
--   ITA_EXCL_TYPE_CHK
--   ITA_FORMAT_CHK
-- ITA_FLD_LENGTH                 NOT NULL NUMBER(4)
-- ITA_DEC_PLACES                          NUMBER(1)
-- ITA_SCRN_TEXT                  NOT NULL VARCHAR2(30)
-- ITA_ID_DOMAIN                           VARCHAR2(30)
--   ITA_EXCL_TYPE_CHK
--   ITA_ID_FK (Pos 1)
-- ITA_VALIDATE_YN                NOT NULL VARCHAR2(1)
-- ITA_DTP_CODE                            VARCHAR2(4)
-- ITA_MAX                                 NUMBER(11,3)
-- ITA_MIN                                 NUMBER(11,3)
-- ITA_VIEW_ATTRI                 NOT NULL VARCHAR2(30)
--   ITA_UK_VIEW_ATTRI (Pos 2)
-- ITA_VIEW_COL_NAME              NOT NULL VARCHAR2(30)
--   ITA_UK_VIEW_COL (Pos 2)
-- ITA_START_DATE                 NOT NULL DATE
--   ITA_START_DATE_TCHK
-- ITA_END_DATE                            DATE
--   ITA_END_DATE_TCHK
-- ITA_QUERYABLE                  NOT NULL VARCHAR2(1)
--   AVCON_1119357682_ITA_Q_000
-- ITA_UKPMS_PARAM_NO                      NUMBER(2)
-- ITA_UNITS                               NUMBER(4)
--   ITA_NMU_FK (Pos 1)
-- ITA_FORMAT_MASK                         VARCHAR2(80)
-- ITA_EXCLUSIVE                  NOT NULL VARCHAR2(1)
--   AVCON_1119357682_ITA_E_000
--   ITA_EXCL_MAND_CHECK
--   ITA_EXCL_TYPE_CHK
--   ITA_EXCL_YN_CHK
-- ITA_KEEP_HISTORY_YN            NOT NULL VARCHAR2(1)
--   ITA_HIST_YN_CHK
-- ITA_DATE_CREATED               NOT NULL DATE
-- ITA_DATE_MODIFIED              NOT NULL DATE
-- ITA_MODIFIED_BY                NOT NULL VARCHAR2(30)
-- ITA_CREATED_BY                 NOT NULL VARCHAR2(30)
-- ITA_QUERY                               VARCHAR2(240)
-- ITA_DISPLAYED                  NOT NULL VARCHAR2(1)
--   AVCON_1119357682_ITA_D_000
--
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB26'
       ,'N'
       ,2
       ,'N'
       ,'VARCHAR2'
       ,10
       ,null
       ,'Lamp Equivalent Number'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_LAMP_EQUIVALENT_NUMBER'
       ,'V_LAMP_EQUIVALENT_NUMBER'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092841','YYYYMMDDHH24MISS')
       ,to_date('20050704092841','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB26');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB27'
       ,'N'
       ,3
       ,'N'
       ,'VARCHAR2'
       ,2
       ,null
       ,'Item Class Code'
       ,'SLEQ_ITEM_CLASS'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_ITEM_CLASS_CODE'
       ,'V_ITEM_CLASS_CODE'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092841','YYYYMMDDHH24MISS')
       ,to_date('20050704092841','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB27');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB28'
       ,'N'
       ,6
       ,'N'
       ,'VARCHAR2'
       ,5
       ,null
       ,'PECU Type'
       ,'SLEQ_PECU_TYPE'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_PECU_TYPE'
       ,'V_PECU_TYPE'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092841','YYYYMMDDHH24MISS')
       ,to_date('20050704092841','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB28');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB29'
       ,'N'
       ,9
       ,'N'
       ,'VARCHAR2'
       ,5
       ,null
       ,'Switch Type'
       ,'SLEQ_SWITCH_TYPE'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_SWITCH_TYPE'
       ,'V_SWITCH_TYPE'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092841','YYYYMMDDHH24MISS')
       ,to_date('20050704092841','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB29');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB30'
       ,'N'
       ,10
       ,'N'
       ,'VARCHAR2'
       ,5
       ,null
       ,'Time On'
       ,'SLEQ_TIME_ON'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_TIME_ON'
       ,'V_TIME_ON'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB30');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB31'
       ,'N'
       ,11
       ,'N'
       ,'VARCHAR2'
       ,5
       ,null
       ,'Time Off'
       ,'SLEQ_TIME_OFF'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_TIME_OFF'
       ,'V_TIME_OFF'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB31');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB32'
       ,'N'
       ,12
       ,'N'
       ,'VARCHAR2'
       ,5
       ,null
       ,'Lamp Type'
       ,'SLEQ_LAMP_TYPE'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_LAMP_TYPE'
       ,'V_LAMP_TYPE'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB32');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB33'
       ,'N'
       ,14
       ,'N'
       ,'VARCHAR2'
       ,4
       ,null
       ,'Gear Type'
       ,'SLEQ_GEAR_TYPE'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_GEAR_TYPE'
       ,'V_GEAR_TYPE'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB33');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB34'
       ,'N'
       ,15
       ,'N'
       ,'VARCHAR2'
       ,30
       ,null
       ,'Location'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_LOCATION'
       ,'V_LOCATION'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB34');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB35'
       ,'N'
       ,16
       ,'N'
       ,'VARCHAR2'
       ,24
       ,null
       ,'Road Name'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_ROAD_NAME'
       ,'V_ROAD_NAME'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB35');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB36'
       ,'N'
       ,17
       ,'N'
       ,'VARCHAR2'
       ,24
       ,null
       ,'Parish'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_PARISH'
       ,'V_PARISH'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB36');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB37'
       ,'N'
       ,18
       ,'N'
       ,'VARCHAR2'
       ,24
       ,null
       ,'Postal Town/County'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_POSTAL_TOWN_COUNTY'
       ,'V_POSTAL_TOWN_COUNTY'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB37');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB38'
       ,'N'
       ,19
       ,'N'
       ,'VARCHAR2'
       ,2
       ,null
       ,'Grid Ref. Letters'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_GRID_REF_LETTERS'
       ,'V_GRID_REF_LETTERS'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB38');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB39'
       ,'N'
       ,22
       ,'N'
       ,'VARCHAR2'
       ,6
       ,null
       ,'Grid Supply Point'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_GRID_SUPPLY_POINT'
       ,'V_GRID_SUPPLY_POINT'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB39');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB40'
       ,'N'
       ,23
       ,'N'
       ,'VARCHAR2'
       ,6
       ,null
       ,'Feeder Pillar ID'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_FEEDER_PILLAR_ID'
       ,'V_FEEDER_PILLAR_ID'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB40');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB41'
       ,'N'
       ,24
       ,'N'
       ,'VARCHAR2'
       ,3
       ,null
       ,'Individual or Group Control'
       ,'SLEQ_INDIV_GROUP'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_INDIVIDUAL_OR_GROUP_CONTROL'
       ,'V_INDIVIDUAL_OR_GROUP_CONTROL'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB41');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB42'
       ,'N'
       ,27
       ,'N'
       ,'VARCHAR2'
       ,8
       ,null
       ,'Grid Ref. of Exit Point'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_GRID_REF_OF_EXIT_POINT'
       ,'V_GRID_REF_OF_EXIT_POINT'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB42');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB43'
       ,'N'
       ,29
       ,'N'
       ,'VARCHAR2'
       ,1
       ,null
       ,'Metered or Unmetered'
       ,'SLEQ_METERED'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_METERED_OR_UNMETERED'
       ,'V_METERED_OR_UNMETERED'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB43');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB44'
       ,'N'
       ,30
       ,'N'
       ,'VARCHAR2'
       ,30
       ,null
       ,'REC Name'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_REC_NAME'
       ,'V_REC_NAME'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB44');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB46'
       ,'N'
       ,33
       ,'N'
       ,'VARCHAR2'
       ,12
       ,null
       ,'Column Manufacturer'
       ,'SLEQ_COLUMN_MANU'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_COLUMN_MANUFACTURER'
       ,'V_COLUMN_MANUFACTURER'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB46');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB47'
       ,'N'
       ,35
       ,'N'
       ,'VARCHAR2'
       ,5
       ,null
       ,'Column Material'
       ,'SLEQ_COLUMN_MATERIAL'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_COLUMN_MATERIAL'
       ,'V_COLUMN_MATERIAL'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB47');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB48'
       ,'N'
       ,36
       ,'N'
       ,'VARCHAR2'
       ,5
       ,null
       ,'Protective Coating'
       ,'SLEQ_PROTECTIVE_COAT'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_PROTECTIVE_COATING'
       ,'V_PROTECTIVE_COATING'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB48');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB49'
       ,'N'
       ,37
       ,'N'
       ,'VARCHAR2'
       ,6
       ,null
       ,'Paint Colour'
       ,'SLEQ_PAINT_COLOUR'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_PAINT_COLOUR'
       ,'V_PAINT_COLOUR'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB49');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB50'
       ,'N'
       ,38
       ,'N'
       ,'VARCHAR2'
       ,6
       ,null
       ,'Column Fixing'
       ,'SLEQ_COLUMN_FIXING'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_COLUMN_FIXING'
       ,'V_COLUMN_FIXING'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB50');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB51'
       ,'N'
       ,39
       ,'N'
       ,'VARCHAR2'
       ,3
       ,null
       ,'Column Cross Section'
       ,'SLEQ_COLUMN_X_SECT'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_COLUMN_CROSS_SECTION'
       ,'V_COLUMN_CROSS_SECTION'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB51');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB52'
       ,'N'
       ,42
       ,'N'
       ,'VARCHAR2'
       ,12
       ,null
       ,'Lantern Manufacturer'
       ,'SLEQ_LANTERN_MANU'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_LANTERN_MANUFACTURER'
       ,'V_LANTERN_MANUFACTURER'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB52');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB53'
       ,'N'
       ,43
       ,'N'
       ,'VARCHAR2'
       ,8
       ,null
       ,'Lantern Model Reference'
       ,'SLEQ_LANTERN_MODEL'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_LANTERN_MODEL_REFERENCE'
       ,'V_LANTERN_MODEL_REFERENCE'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB53');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB54'
       ,'N'
       ,44
       ,'N'
       ,'VARCHAR2'
       ,3
       ,null
       ,'Lantern Distribution'
       ,'SLEQ_LANTERN_DISTRIBUTION'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_LANTERN_DISTRIBUTION'
       ,'V_LANTERN_DISTRIBUTION'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB54');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB55'
       ,'N'
       ,45
       ,'N'
       ,'VARCHAR2'
       ,8
       ,null
       ,'Lantern Setting'
       ,'SLEQ_LANTERN_SETTINGS'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_LANTERN_SETTING'
       ,'V_LANTERN_SETTING'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB55');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB56'
       ,'N'
       ,46
       ,'N'
       ,'VARCHAR2'
       ,4
       ,null
       ,'Lantern Protection'
       ,'SLEQ_LANTERN_PROTECTION'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_LANTERN_PROTECTION'
       ,'V_LANTERN_PROTECTION'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB56');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB57'
       ,'N'
       ,51
       ,'N'
       ,'VARCHAR2'
       ,6
       ,null
       ,'Sign Diagram No. (if fitted)'
       ,'SLEQ_SIGN_DIAGRAM_NO'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_SIGN_DIAGRAM_NO'
       ,'V_SIGN_DIAGRAM_NO'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB57');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB58'
       ,'N'
       ,52
       ,'N'
       ,'VARCHAR2'
       ,3
       ,null
       ,'Column Root Protection'
       ,'SLEQ_COLUMN_ROOT_PROTECTION'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_COLUMN_ROOT_PROTECTION'
       ,'V_COLUMN_ROOT_PROTECTION'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB58');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB59'
       ,'N'
       ,53
       ,'N'
       ,'VARCHAR2'
       ,3
       ,null
       ,'Flange Base'
       ,'SLEQ_FLANGE_BASE'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_FLANGE_BASE'
       ,'V_FLANGE_BASE'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB59');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB60'
       ,'N'
       ,54
       ,'N'
       ,'VARCHAR2'
       ,16
       ,null
       ,'Column Location'
       ,'SLEQ_COLUMN_LOCATION'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_COLUMN_LOCATION'
       ,'V_COLUMN_LOCATION'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB60');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB61'
       ,'N'
       ,55
       ,'N'
       ,'VARCHAR2'
       ,12
       ,null
       ,'Road Environment '
       ,'SLEQ_ROAD_ENVIRONMNET'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_ROAD_ENVIRONMENT '
       ,'V_ROAD_ENVIRONMENT '
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB61');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB62'
       ,'N'
       ,56
       ,'N'
       ,'VARCHAR2'
       ,14
       ,null
       ,'Ground Conditions'
       ,'SLEQ_GROUND_CONDITIONS'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_GROUND_CONDITIONS'
       ,'V_GROUND_CONDITIONS'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB62');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB63'
       ,'N'
       ,57
       ,'N'
       ,'VARCHAR2'
       ,10
       ,null
       ,'Wind Exposure'
       ,'SLEQ_WIND_EXPOSURE'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_WIND_EXPOSURE'
       ,'V_WIND_EXPOSURE'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB63');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB64'
       ,'N'
       ,58
       ,'N'
       ,'VARCHAR2'
       ,4
       ,null
       ,'Environment Situation'
       ,'SLEQ_ENV_SITUATION'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_ENVIRONMENT_SITUATION'
       ,'V_ENVIRONMENT_SITUATION'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB64');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB65'
       ,'N'
       ,59
       ,'N'
       ,'VARCHAR2'
       ,8
       ,null
       ,'Designed for Fatigue'
       ,'SLEQ_DESIGNED_FOR_FATIGUE'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_DESIGNED_FOR_FATIGUE'
       ,'V_DESIGNED_FOR_FATIGUE'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB65');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB66'
       ,'N'
       ,60
       ,'N'
       ,'VARCHAR2'
       ,4
       ,null
       ,'Attachments'
       ,'SLEQ_ATTACHEMENTS'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_ATTACHMENTS'
       ,'V_ATTACHMENTS'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,to_date('20050704092842','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB66');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB67'
       ,'N'
       ,61
       ,'N'
       ,'VARCHAR2'
       ,5
       ,null
       ,'External Influences'
       ,'SLEQ_EXTERNAL_INFLUENCE'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_EXTERNAL_INFLUENCES'
       ,'V_EXTERNAL_INFLUENCES'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB67');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_CHR_ATTRIB68'
       ,'N'
       ,26
       ,'N'
       ,'VARCHAR2'
       ,1
       ,null
       ,'Is Item An Exit Point'
       ,'Y_OR_N'
       ,'N'
       ,''
       ,null
       ,null
       ,'V_IS_ITEM_AN_EXIT_POINT'
       ,'V_IS_ITEM_AN_EXIT_POINT'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB68');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_DATE_ATTRIB86'
       ,'N'
       ,47
       ,'N'
       ,'DATE'
       ,11
       ,null
       ,'Last Lamp Change Date'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_LAST_LAMP_CHANGE_DATE'
       ,'V_LAST_LAMP_CHANGE_DATE'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,'DD-MON-YYYY'
       ,'N'
       ,'N'
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_DATE_ATTRIB86');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_DATE_ATTRIB87'
       ,'N'
       ,48
       ,'N'
       ,'DATE'
       ,11
       ,null
       ,'Last Electrical Test'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_LAST_ELECTRICAL_TEST'
       ,'V_LAST_ELECTRICAL_TEST'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,'DD-MON-YYYY'
       ,'N'
       ,'N'
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_DATE_ATTRIB87');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_DATE_ATTRIB88'
       ,'N'
       ,49
       ,'N'
       ,'DATE'
       ,11
       ,null
       ,'Last Detailed Inspection'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_LAST_DETAILED_INSPECTION'
       ,'V_LAST_DETAILED_INSPECTION'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,'DD-MON-YYYY'
       ,'N'
       ,'N'
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_DATE_ATTRIB88');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_DATE_ATTRIB89'
       ,'N'
       ,31
       ,'N'
       ,'DATE'
       ,11
       ,null
       ,'Equipment Commission Date'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_EQUIPMENT_COMMISSION_DATE'
       ,'V_EQUIPMENT_COMMISSION_DATE'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,'DD-MON-YYYY'
       ,'N'
       ,'N'
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_DATE_ATTRIB89');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_NUM_ATTRIB100'
       ,'N'
       ,32
       ,'N'
       ,'NUMBER'
       ,6
       ,null
       ,'Installation Capital Cost'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_INSTALLATION_CAPITAL_COST'
       ,'V_INSTALLATION_CAPITAL_COST'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_NUM_ATTRIB100');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_NUM_ATTRIB101'
       ,'N'
       ,34
       ,'N'
       ,'NUMBER'
       ,2
       ,null
       ,'Mounting Height'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_MOUNTING_HEIGHT'
       ,'V_MOUNTING_HEIGHT'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_NUM_ATTRIB101');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_NUM_ATTRIB102'
       ,'N'
       ,40
       ,'N'
       ,'NUMBER'
       ,2
       ,null
       ,'Number Of Brackets'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_NUMBER_OF_BRACKETS'
       ,'V_NUMBER_OF_BRACKETS'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_NUM_ATTRIB102');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_NUM_ATTRIB103'
       ,'N'
       ,41
       ,'N'
       ,'NUMBER'
       ,2
       ,null
       ,'Bracket Projection'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_BRACKET_PROJECTION'
       ,'V_BRACKET_PROJECTION'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_NUM_ATTRIB103');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_NUM_ATTRIB104'
       ,'N'
       ,50
       ,'N'
       ,'NUMBER'
       ,4
       ,null
       ,'Sign Size'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_SIGN_SIZE'
       ,'V_SIGN_SIZE'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_NUM_ATTRIB104');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_NUM_ATTRIB16'
       ,'N'
       ,1
       ,'N'
       ,'NUMBER'
       ,10
       ,null
       ,'Agents Record Number'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_AGENTS_RECORD_NUMBER'
       ,'V_AGENTS_RECORD_NUMBER'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_NUM_ATTRIB16');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_NUM_ATTRIB17'
       ,'N'
       ,4
       ,'N'
       ,'NUMBER'
       ,2
       ,null
       ,'No of Lamps'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_NO_OF_LAMPS'
       ,'V_NO_OF_LAMPS'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_NUM_ATTRIB17');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_NUM_ATTRIB18'
       ,'N'
       ,5
       ,'N'
       ,'NUMBER'
       ,2
       ,null
       ,'No of PECUs'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_NO_OF_PECUS'
       ,'V_NO_OF_PECUS'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_NUM_ATTRIB18');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_NUM_ATTRIB19'
       ,'N'
       ,7
       ,'N'
       ,'NUMBER'
       ,4
       ,null
       ,'PECU Lux On'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_PECU_LUX_ON'
       ,'V_PECU_LUX_ON'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_NUM_ATTRIB19');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_NUM_ATTRIB20'
       ,'N'
       ,8
       ,'N'
       ,'NUMBER'
       ,4
       ,null
       ,'PECU Lux Off'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_PECU_LUX_OFF'
       ,'V_PECU_LUX_OFF'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_NUM_ATTRIB20');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_NUM_ATTRIB21'
       ,'N'
       ,13
       ,'N'
       ,'NUMBER'
       ,4
       ,null
       ,'Lamp Max Wattage'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_LAMP_MAX_WATTAGE'
       ,'V_LAMP_MAX_WATTAGE'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_NUM_ATTRIB21');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_NUM_ATTRIB22'
       ,'N'
       ,20
       ,'N'
       ,'NUMBER'
       ,7
       ,null
       ,'Grid Ref. Eastings'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_GRID_REF_EASTINGS'
       ,'V_GRID_REF_EASTINGS'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_NUM_ATTRIB22');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_NUM_ATTRIB23'
       ,'N'
       ,21
       ,'N'
       ,'NUMBER'
       ,7
       ,null
       ,'Grid Ref. Northings'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_GRID_REF_NORTHINGS'
       ,'V_GRID_REF_NORTHINGS'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_NUM_ATTRIB23');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_NUM_ATTRIB24'
       ,'N'
       ,25
       ,'N'
       ,'NUMBER'
       ,3
       ,null
       ,'Operating Percent Per Day'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_OPERATING_PERCENT_PER_DAY'
       ,'V_OPERATING_PERCENT_PER_DAY'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_NUM_ATTRIB24');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
       (ITA_INV_TYPE
       ,ITA_ATTRIB_NAME
       ,ITA_DYNAMIC_ATTRIB
       ,ITA_DISP_SEQ_NO
       ,ITA_MANDATORY_YN
       ,ITA_FORMAT
       ,ITA_FLD_LENGTH
       ,ITA_DEC_PLACES
       ,ITA_SCRN_TEXT
       ,ITA_ID_DOMAIN
       ,ITA_VALIDATE_YN
       ,ITA_DTP_CODE
       ,ITA_MAX
       ,ITA_MIN
       ,ITA_VIEW_ATTRI
       ,ITA_VIEW_COL_NAME
       ,ITA_START_DATE
       ,ITA_END_DATE
       ,ITA_QUERYABLE
       ,ITA_UKPMS_PARAM_NO
       ,ITA_UNITS
       ,ITA_FORMAT_MASK
       ,ITA_EXCLUSIVE
       ,ITA_KEEP_HISTORY_YN
       ,ITA_DATE_CREATED
       ,ITA_DATE_MODIFIED
       ,ITA_MODIFIED_BY
       ,ITA_CREATED_BY
       ,ITA_QUERY
       ,ITA_DISPLAYED
       )
SELECT 
        'SLEQ'
       ,'IIT_NUM_ATTRIB25'
       ,'N'
       ,28
       ,'N'
       ,'NUMBER'
       ,3
       ,null
       ,'Exit Point Capacity if >3KVA'
       ,''
       ,'N'
       ,''
       ,null
       ,null
       ,'V_EXIT_POINT_CAPACITY_3KVA'
       ,'V_EXIT_POINT_CAPACITY_3KVA'
       ,to_date('19000101000000','YYYYMMDDHH24MISS')
       ,null
       ,'N'
       ,null
       ,null
       ,''
       ,'N'
       ,'N'
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,to_date('20050704092843','YYYYMMDDHH24MISS')
       ,'NM3DATA_SLM'
       ,'NM3DATA_SLM'
       ,''
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'SLEQ'
                    AND  ITA_ATTRIB_NAME = 'IIT_NUM_ATTRIB25');
--
--
--********** NM_INV_TYPE_ROLES **********--
--
-- Columns
-- ITR_INV_TYPE                   NOT NULL VARCHAR2(4)
--   ITR_NIT_FK (Pos 1)
--   ITR_PK (Pos 1)
-- ITR_HRO_ROLE                   NOT NULL VARCHAR2(30)
--   ITR_PK (Pos 2)
-- ITR_MODE                       NOT NULL VARCHAR2(10)
--   AVCON_1119357682_ITR_M_000
--
--
INSERT INTO NM_INV_TYPE_ROLES
       (ITR_INV_TYPE
       ,ITR_HRO_ROLE
       ,ITR_MODE
       )
SELECT 
        'SLEQ'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ROLES
                   WHERE ITR_INV_TYPE = 'SLEQ'
                    AND  ITR_HRO_ROLE = 'HIG_USER');
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
