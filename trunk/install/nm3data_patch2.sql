--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3data_patch2.sql-arc   2.1   Jul 04 2013 14:09:12   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3data_patch2.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:09:12  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:38:18  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
/***************************************************************************

INFO
====
As at Release 3.2.1.0

GENERATION DATE
===============
20-JUN-2005 11:53

TABLES PROCESSED
================
HIG_WEB_CONTXT_HLP
HIG_STANDARD_FAVOURITES

TABLE OWNER
===========
NM3DATA

MODE (A-Append R-Refresh)
========================
R

***************************************************************************/

define sccsid = '@(#)nm3data_patch2.sql	1.18 06/20/05'
set define off;
set feedback off;

--------------------
-- PRE-PROCESSING --
--------------------
delete from hig_web_contxt_hlp;
commit;
delete from hig_standard_favourites;
commit;


---------------------------------
-- START OF GENERATED METADATA --
---------------------------------

--
--********** HIG_WEB_CONTXT_HLP **********--
--
-- Columns
-- HWCH_ART_ID                    NOT NULL NUMBER(22)
--   HWCH_PK (Pos 1)
-- HWCH_PRODUCT                   NOT NULL VARCHAR2(6)
-- HWCH_MODULE                             VARCHAR2(30)
-- HWCH_BLOCK                              VARCHAR2(30)
-- HWCH_ITEM                               VARCHAR2(30)
-- HWCH_HTML_STRING               NOT NULL VARCHAR2(200)
--
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 209;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        209
       ,'NET'
       ,'NM0220'
       ,''
       ,''
       ,'/net/WebHelp/netreclassify_element__nm0220.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 210;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        210
       ,'NET'
       ,'NM0301'
       ,''
       ,''
       ,'/net/WebHelp/netasset_domains__nm0301.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 211;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        211
       ,'NET'
       ,'NM0305'
       ,''
       ,''
       ,'/net/WebHelp/netxsp_and_reversal_rules__nm0305.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 212;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        212
       ,'NET'
       ,'NM0306'
       ,''
       ,''
       ,'/net/WebHelp/netasset_xsps__nm0306.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 213;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        213
       ,'NET'
       ,'NM0410'
       ,''
       ,''
       ,'/net/WebHelp/netasset_metamodel__nm0410.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 214;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        214
       ,'NET'
       ,'NM0411'
       ,''
       ,''
       ,'/net/WebHelp/netasset_exclusive_view_creation__n.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 215;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        215
       ,'NET'
       ,'NM0415'
       ,''
       ,''
       ,'/net/WebHelp/netasset_attribute_sets__nm0415.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 216;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        216
       ,'NET'
       ,'NM0500'
       ,''
       ,''
       ,'/net/WebHelp/netnetwork_walker__nm0500.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 217;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        217
       ,'NET'
       ,'NM0510'
       ,''
       ,''
       ,'/net/WebHelp/netasset_items__nm0510.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 218;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        218
       ,'NET'
       ,'NM0511'
       ,''
       ,''
       ,'/net/WebHelp/netnm0511__reconcile_map_capture_lo.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 219;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        219
       ,'NET'
       ,'NM0530'
       ,''
       ,''
       ,'/net/WebHelp/netglobal_asset_update__nm0530.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 220;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        220
       ,'NET'
       ,'NM0550'
       ,''
       ,''
       ,'/net/WebHelp/netcross_attribute_validation_setup.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 221;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        221
       ,'NET'
       ,'NM0560'
       ,''
       ,''
       ,'/net/WebHelp/netassets_on_a_route__nm0560.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 222;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        222
       ,'NET'
       ,'NM0570'
       ,''
       ,''
       ,'/net/WebHelp/netfind_asset__nm0570.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 223;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        223
       ,'NET'
       ,'NM0580'
       ,''
       ,''
       ,'/net/WebHelp/netnm0580___create_mapcapture_metad.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 224;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        224
       ,'NET'
       ,'NM0700'
       ,''
       ,''
       ,'/net/WebHelp/netad_types__nm0700.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 225;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        225
       ,'NET'
       ,'NM1100'
       ,''
       ,''
       ,'/net/WebHelp/netgazetteer__nm1100.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 226;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        226
       ,'NET'
       ,'NM1200'
       ,''
       ,''
       ,'/net/WebHelp/netslk_calculator__nm1200.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 227;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        227
       ,'NET'
       ,'NM1201'
       ,''
       ,''
       ,'/net/WebHelp/netoffset_calculator__nm1201.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 228;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        228
       ,'NET'
       ,'NM1861'
       ,''
       ,''
       ,'/net/WebHelp/netasset_admin_unit_security_mainte.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 229;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        229
       ,'NET'
       ,'NM2000'
       ,''
       ,''
       ,'/net/WebHelp/netrecalibrate_element__nm2000.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 230;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        230
       ,'NET'
       ,'NM2000'
       ,''
       ,''
       ,'/net/WebHelp/netrecalibrate_element__nm2000.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 231;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        231
       ,'NET'
       ,'NM3010'
       ,''
       ,''
       ,'/net/WebHelp/netjob_operations__nm3010.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 232;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        232
       ,'NET'
       ,'NM3020'
       ,''
       ,''
       ,'/net/WebHelp/netjob_types__nm3020.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 233;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        233
       ,'NET'
       ,'NM3030'
       ,''
       ,''
       ,'/net/WebHelp/netroad_construction_operations_lay.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 234;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        234
       ,'NET'
       ,'NM7040'
       ,''
       ,''
       ,'/net/WebHelp/netpbi_query_setup__nm7040.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 235;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        235
       ,'NET'
       ,'NM7041'
       ,''
       ,''
       ,'/net/WebHelp/netpbi_query_results__nm7041.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 236;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        236
       ,'NET'
       ,'NM7050'
       ,''
       ,''
       ,'/net/WebHelp/netmerge_query_setup__nm7050.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 237;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        237
       ,'NET'
       ,'NM7051'
       ,''
       ,''
       ,'/net/WebHelp/netmerge_query_results__nm7051.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 238;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        238
       ,'NET'
       ,'NM7053'
       ,''
       ,''
       ,'/net/WebHelp/netmerge_query_defaults_nm7053.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 239;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        239
       ,'NET'
       ,'NM7055'
       ,''
       ,''
       ,'/net/WebHelp/netmerge_file_extract_definition__n.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 240;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        240
       ,'NET'
       ,'NM7057'
       ,''
       ,''
       ,'/net/WebHelp/netmerge_results_extract__nm7057.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 241;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        241
       ,'NET'
       ,'NMWEB0020'
       ,''
       ,''
       ,'/net/WebHelp/netweb_based_engineering_dynamic_se.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 242;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        242
       ,'NET'
       ,'NM0001'
       ,''
       ,''
       ,'/net/WebHelp/netnode_types__nm0001.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 243;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        243
       ,'NET'
       ,'NM0101'
       ,''
       ,''
       ,'/net/WebHelp/netnodes__nm0101.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 244;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        244
       ,'NET'
       ,'NM1201'
       ,''
       ,''
       ,'/net/WebHelp/netoffset_calculator__nm1201.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 245;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        245
       ,'NET'
       ,'NM7041'
       ,''
       ,''
       ,'/net/WebHelp/netpbi_query_results__nm7041.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 246;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        246
       ,'NET'
       ,'NM7040'
       ,''
       ,''
       ,'/net/WebHelp/netpbi_query_setup__nm7040.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 247;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        247
       ,'NET'
       ,'NM2000'
       ,''
       ,''
       ,'/net/WebHelp/netrecalibrate_element__nm2000.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 248;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        248
       ,'NET'
       ,'NM0220'
       ,''
       ,''
       ,'/net/WebHelp/netreclassify_element__nm0220.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 249;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        249
       ,'NET'
       ,'NM0511'
       ,''
       ,''
       ,'/net/WebHelp/netnm0511__reconcile_map_capture_lo.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 250;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        250
       ,'NET'
       ,'NM0202'
       ,''
       ,''
       ,'/net/WebHelp/netreplace_element__nm0202.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 251;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        251
       ,'NET'
       ,'NM3030'
       ,''
       ,''
       ,'/net/WebHelp/netroad_construction_operations_lay.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 252;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        252
       ,'NET'
       ,'HIG1836'
       ,''
       ,''
       ,'/net/WebHelp/netroles__hig1836.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 253;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        253
       ,'NET'
       ,'NM2000'
       ,''
       ,''
       ,'/net/WebHelp/netrecalibrate_element__nm2000.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 254;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        254
       ,'NET'
       ,'NM1200'
       ,''
       ,''
       ,'/net/WebHelp/netslk_calculator__nm1200.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 255;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        255
       ,'NET'
       ,'NM0200'
       ,''
       ,''
       ,'/net/WebHelp/netsplit_element__nm0200.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 256;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        256
       ,'NET'
       ,'NM0207'
       ,''
       ,''
       ,'/net/WebHelp/netundo_close__nm0207.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 257;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        257
       ,'NET'
       ,'NM0204'
       ,''
       ,''
       ,'/net/WebHelp/netundo_merge__nm0204.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 258;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        258
       ,'NET'
       ,'NM0205'
       ,''
       ,''
       ,'/net/WebHelp/netundo_replace__nm0205.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 158;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        158
       ,'NET'
       ,'NM0411'
       ,''
       ,''
       ,'/net/WebHelp/netasset_exclusive_view_creation__n.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 159;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        159
       ,'NET'
       ,'NM0510'
       ,''
       ,''
       ,'/net/WebHelp/netasset_items__nm0510.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 160;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        160
       ,'NET'
       ,'NM0410'
       ,''
       ,''
       ,'/net/WebHelp/netasset_metamodel__nm0410.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 161;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        161
       ,'NET'
       ,'NM0306'
       ,''
       ,''
       ,'/net/WebHelp/netasset_xsps__nm0306.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 162;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        162
       ,'NET'
       ,'NM0560'
       ,''
       ,''
       ,'/net/WebHelp/netassets_on_a_route__nm0560.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 163;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        163
       ,'NET'
       ,'NM0206'
       ,''
       ,''
       ,'/net/WebHelp/netclose_element__nm0206.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 164;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        164
       ,'NET'
       ,'NM0580'
       ,''
       ,''
       ,'/net/WebHelp/netnm0580___create_mapcapture_metad.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 165;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        165
       ,'NET'
       ,'NM0120'
       ,''
       ,''
       ,'/net/WebHelp/netcreate_network_extent__nm0120.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 166;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        166
       ,'NET'
       ,'NM0550'
       ,''
       ,''
       ,'/net/WebHelp/netcross_attribute_validation_setup.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 167;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        167
       ,'NET'
       ,'NM0105'
       ,''
       ,''
       ,'/net/WebHelp/netelements__nm0105.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 168;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        168
       ,'NET'
       ,'NM0570'
       ,''
       ,''
       ,'/net/WebHelp/netfind_asset__nm0570.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 169;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        169
       ,'NET'
       ,'NM1100'
       ,''
       ,''
       ,'/net/WebHelp/netgazetteer__nm1100.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 170;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        170
       ,'NET'
       ,'NM0530'
       ,''
       ,''
       ,'/net/WebHelp/netglobal_asset_update__nm0530.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 171;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        171
       ,'NET'
       ,'NM0004'
       ,''
       ,''
       ,'/net/WebHelp/netgroup_types__nm0004.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 172;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        172
       ,'NET'
       ,'NM0110'
       ,''
       ,''
       ,'/net/WebHelp/netgroups_of_elements__nm0110.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 173;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        173
       ,'NET'
       ,'NM0115'
       ,''
       ,''
       ,'/net/WebHelp/netgroups_of_groups__nm0115.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 174;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        174
       ,'NET'
       ,'HIG1820'
       ,''
       ,''
       ,'/net/WebHelp/netunits_and_conversions__hig1820.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 175;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        175
       ,'NET'
       ,'HIG1832'
       ,''
       ,''
       ,'/net/WebHelp/netusers__hig1832.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 176;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        176
       ,'NET'
       ,'HIG1860'
       ,''
       ,''
       ,'/net/WebHelp/netadmin_units__hig1860.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 177;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        177
       ,'NET'
       ,'NM3010'
       ,''
       ,''
       ,'/net/WebHelp/netjob_operations__nm3010.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 178;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        178
       ,'NET'
       ,'NM3020'
       ,''
       ,''
       ,'/net/WebHelp/netjob_types__nm3020.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 179;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        179
       ,'NET'
       ,'NM0201'
       ,''
       ,''
       ,'/net/WebHelp/netmerge_elements__nm0201.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 180;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        180
       ,'NET'
       ,'NM7055'
       ,''
       ,''
       ,'/net/WebHelp/netmerge_file_extract_definition__n.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 181;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        181
       ,'NET'
       ,'NM7051'
       ,''
       ,''
       ,'/net/WebHelp/netmerge_query_results__nm7051.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 182;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        182
       ,'NET'
       ,'NM7050'
       ,''
       ,''
       ,'/net/WebHelp/netmerge_query_setup__nm7050.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 183;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        183
       ,'NET'
       ,'NM7053'
       ,''
       ,''
       ,'/net/WebHelp/netmerge_query_defaults_nm7053.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 184;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        184
       ,'NET'
       ,'NM7051'
       ,''
       ,''
       ,'/net/WebHelp/netmerge_query_results__nm7051.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 185;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        185
       ,'NET'
       ,'NM7050'
       ,''
       ,''
       ,'/net/WebHelp/netmerge_query_setup__nm7050.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 186;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        186
       ,'NET'
       ,'NM7053'
       ,''
       ,''
       ,'/net/WebHelp/netmerge_query_defaults_nm7053.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 187;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        187
       ,'NET'
       ,'NM7051'
       ,''
       ,''
       ,'/net/WebHelp/netmerge_query_results__nm7051.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 188;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        188
       ,'NET'
       ,'NM7050'
       ,''
       ,''
       ,'/net/WebHelp/netmerge_query_setup__nm7050.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 189;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        189
       ,'NET'
       ,'NM7057'
       ,''
       ,''
       ,'/net/WebHelp/netmerge_results_extract__nm7057.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 190;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        190
       ,'NET'
       ,'NM0002'
       ,''
       ,''
       ,'/net/WebHelp/netnetwork_type__nm0002.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 191;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        191
       ,'NET'
       ,'NM0500'
       ,''
       ,''
       ,'/net/WebHelp/netnetwork_walker__nm0500.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 192;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        192
       ,'NET'
       ,'NM0001'
       ,''
       ,''
       ,'/net/WebHelp/netnode_types__nm0001.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 193;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        193
       ,'NET'
       ,'NM0002'
       ,''
       ,''
       ,'/net/WebHelp/netnetwork_type__nm0002.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 194;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        194
       ,'NET'
       ,'NM0004'
       ,''
       ,''
       ,'/net/WebHelp/netgroup_types__nm0004.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 195;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        195
       ,'NET'
       ,'NM0101'
       ,''
       ,''
       ,'/net/WebHelp/netnodes__nm0101.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 196;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        196
       ,'NET'
       ,'NM0105'
       ,''
       ,''
       ,'/net/WebHelp/netelements__nm0105.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 197;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        197
       ,'NET'
       ,'NM0105'
       ,''
       ,''
       ,'/net/WebHelp/netextend_route_at_end.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 198;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        198
       ,'NET'
       ,'NM0110'
       ,''
       ,''
       ,'/net/WebHelp/netgroups_of_elements__nm0110.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 199;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        199
       ,'NET'
       ,'NM0115'
       ,''
       ,''
       ,'/net/WebHelp/netgroups_of_groups__nm0115.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 200;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        200
       ,'NET'
       ,'NM0120'
       ,''
       ,''
       ,'/net/WebHelp/netcreate_network_extent__nm0120.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 201;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        201
       ,'NET'
       ,'NM0200'
       ,''
       ,''
       ,'/net/WebHelp/netsplit_element__nm0200.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 202;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        202
       ,'NET'
       ,'NM0201'
       ,''
       ,''
       ,'/net/WebHelp/netmerge_elements__nm0201.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 203;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        203
       ,'NET'
       ,'NM0202'
       ,''
       ,''
       ,'/net/WebHelp/netreplace_element__nm0202.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 204;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        204
       ,'NET'
       ,'NM0203'
       ,''
       ,''
       ,'/net/WebHelp/netundo_split__nm0203.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 205;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        205
       ,'NET'
       ,'NM0204'
       ,''
       ,''
       ,'/net/WebHelp/netundo_merge__nm0204.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 206;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        206
       ,'NET'
       ,'NM0205'
       ,''
       ,''
       ,'/net/WebHelp/netundo_replace__nm0205.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 207;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        207
       ,'NET'
       ,'NM0206'
       ,''
       ,''
       ,'/net/WebHelp/netclose_element__nm0206.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 208;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        208
       ,'NET'
       ,'NM0207'
       ,''
       ,''
       ,'/net/WebHelp/netundo_close__nm0207.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 108;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        108
       ,'HIG'
       ,'GRI0240'
       ,''
       ,''
       ,'/hig/WebHelp/higgri_module_parameters__gri0240.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 109;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        109
       ,'HIG'
       ,'GRI0220'
       ,''
       ,''
       ,'/hig/WebHelp/higgri_modules__gri0220.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 110;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        110
       ,'HIG'
       ,'GRI0250'
       ,''
       ,''
       ,'/hig/WebHelp/higgri_parameter_dependencies__gri0.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 111;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        111
       ,'HIG'
       ,'GRI0230'
       ,''
       ,''
       ,'/hig/WebHelp/higgri_parameters__gri0230.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 112;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        112
       ,'HIG'
       ,'GRI0220'
       ,''
       ,''
       ,'/hig/WebHelp/higgri_modules__gri0220.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 113;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        113
       ,'HIG'
       ,'GRI0230'
       ,''
       ,''
       ,'/hig/WebHelp/higgri_parameters__gri0230.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 114;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        114
       ,'HIG'
       ,'GRI0240'
       ,''
       ,''
       ,'/hig/WebHelp/higgri_module_parameters__gri0240.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 115;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        115
       ,'HIG'
       ,'GRI0250'
       ,''
       ,''
       ,'/hig/WebHelp/higgri_parameter_dependencies__gri0.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 116;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        116
       ,'HIG'
       ,'HIG1807'
       ,''
       ,''
       ,'/hig/WebHelp/higlaunchpad__favourites.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 117;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        117
       ,'HIG'
       ,'HIG1820'
       ,''
       ,''
       ,'/hig/WebHelp/higunits_and_conversions__hig1820.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 118;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        118
       ,'HIG'
       ,'HIG1832'
       ,''
       ,''
       ,'/hig/WebHelp/higusers__hig1832.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 119;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        119
       ,'HIG'
       ,'HIG1833'
       ,''
       ,''
       ,'/hig/WebHelp/higchange_password__hig1833.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 120;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        120
       ,'HIG'
       ,'HIG1836'
       ,''
       ,''
       ,'/hig/WebHelp/higroles__hig1836.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 121;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        121
       ,'HIG'
       ,'HIG1837'
       ,''
       ,''
       ,'/hig/WebHelp/higuser_option_administration__hig1.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 122;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        122
       ,'HIG'
       ,'HIG1838'
       ,''
       ,''
       ,'/hig/WebHelp/higuser_options__hig1838.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 123;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        123
       ,'HIG'
       ,'HIG1840'
       ,''
       ,''
       ,'/hig/WebHelp/higuser_preferences_effective_date.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 124;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        124
       ,'HIG'
       ,'HIG1850'
       ,''
       ,''
       ,'/hig/WebHelp/higreport_styles__hig1850.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 125;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        125
       ,'HIG'
       ,'Hig1860'
       ,''
       ,''
       ,'/hig/WebHelp/higadmin_units__hig1860.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 126;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        126
       ,'HIG'
       ,'HIG1880'
       ,''
       ,''
       ,'/hig/WebHelp/higmodules__hig1880.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 127;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        127
       ,'HIG'
       ,'HIG1890'
       ,''
       ,''
       ,'/hig/WebHelp/higproducts__hig1890.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 128;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        128
       ,'HIG'
       ,'HIG2010'
       ,''
       ,''
       ,'/hig/WebHelp/higcsv_loader_destination_table__hi.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 129;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        129
       ,'HIG'
       ,'HIG2020'
       ,''
       ,''
       ,'/hig/WebHelp/higcsv_loader_file_definitions_tabl.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 130;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        130
       ,'HIG'
       ,'HIG9120'
       ,''
       ,''
       ,'/hig/WebHelp/higdomains__hig9120.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 131;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        131
       ,'HIG'
       ,'HIG9130'
       ,''
       ,''
       ,'/hig/WebHelp/highig9130__product_options.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 132;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        132
       ,'HIG'
       ,'HIG9135'
       ,''
       ,''
       ,'/hig/WebHelp/higproduct_option_list__hig9135.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 133;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        133
       ,'HIG'
       ,'HIG9185'
       ,''
       ,''
       ,'/hig/WebHelp/higv3_errors__hig9185.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 134;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        134
       ,'HIG'
       ,'HIG9190'
       ,''
       ,''
       ,'/hig/WebHelp/higresource_file_generation_and_use.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 135;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        135
       ,'HIG'
       ,'HIGWEB2030'
       ,''
       ,''
       ,'/hig/WebHelp/higloadprocess_data__higweb2030.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 136;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        136
       ,'HIG'
       ,'HIGWEB2030'
       ,''
       ,''
       ,'/hig/WebHelp/higloadprocess_data__higweb2030.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 137;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        137
       ,'HIG'
       ,'HIG1880'
       ,''
       ,''
       ,'/hig/WebHelp/higmodules__hig1880.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 138;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        138
       ,'HIG'
       ,'HIG9135'
       ,''
       ,''
       ,'/hig/WebHelp/higproduct_option_list__hig9135.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 139;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        139
       ,'HIG'
       ,'HIG9130'
       ,''
       ,''
       ,'/hig/WebHelp/highig9130__product_options.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 140;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        140
       ,'HIG'
       ,'HIG1890'
       ,''
       ,''
       ,'/hig/WebHelp/higproducts__hig1890.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 141;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        141
       ,'HIG'
       ,'GIS0005'
       ,''
       ,''
       ,'/hig/WebHelp/higprojects__gis0005.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 142;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        142
       ,'HIG'
       ,'HIG1850'
       ,''
       ,''
       ,'/hig/WebHelp/higreport_styles__hig1850.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 143;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        143
       ,'HIG'
       ,'HIG1836'
       ,''
       ,''
       ,'/hig/WebHelp/higroles__hig1836.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 144;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        144
       ,'HIG'
       ,'GIS0010'
       ,''
       ,''
       ,'/hig/WebHelp/higthemes__gis0010.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 145;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        145
       ,'HIG'
       ,'HIG1820'
       ,''
       ,''
       ,'/hig/WebHelp/higunits_and_conversions__hig1820.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 146;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        146
       ,'HIG'
       ,'HIG1837'
       ,''
       ,''
       ,'/hig/WebHelp/higuser_option_administration__hig1.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 147;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        147
       ,'HIG'
       ,'HIG1838'
       ,''
       ,''
       ,'/hig/WebHelp/higuser_options__hig1838.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 148;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        148
       ,'HIG'
       ,'HIG1840'
       ,''
       ,''
       ,'/hig/WebHelp/higuser_preferences_effective_date.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 149;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        149
       ,'HIG'
       ,'HIG1832'
       ,''
       ,''
       ,'/hig/WebHelp/higusers__hig1832.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 150;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        150
       ,'HIG'
       ,'HIG1836'
       ,''
       ,''
       ,'/hig/WebHelp/higroles__hig1836.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 151;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        151
       ,'HIG'
       ,'HIG9185'
       ,''
       ,''
       ,'/hig/WebHelp/higv3_errors__hig9185.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 152;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        152
       ,'NET'
       ,'NM0700'
       ,''
       ,''
       ,'/net/WebHelp/netad_types__nm0700.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 153;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        153
       ,'NET'
       ,'NM0700'
       ,''
       ,''
       ,'/net/WebHelp/netad_types__nm0700.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 154;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        154
       ,'NET'
       ,'HIG1860'
       ,''
       ,''
       ,'/net/WebHelp/netadmin_units__hig1860.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 155;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        155
       ,'NET'
       ,'NM1861'
       ,''
       ,''
       ,'/net/WebHelp/netasset_admin_unit_security_mainte.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 156;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        156
       ,'NET'
       ,'NM0415'
       ,''
       ,''
       ,'/net/WebHelp/netasset_attribute_sets__nm0415.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 157;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        157
       ,'NET'
       ,'NM0301'
       ,''
       ,''
       ,'/net/WebHelp/netasset_domains__nm0301.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 58;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        58
       ,'DOC'
       ,'DOC0160'
       ,''
       ,''
       ,'/doc/WebHelp/docenquiry_details__doc0160.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 59;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        59
       ,'DOC'
       ,'DOC0162'
       ,''
       ,''
       ,'/doc/WebHelp/docacknowledgements__doc0162.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 60;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        60
       ,'DOC'
       ,'DOC0164'
       ,''
       ,''
       ,'/doc/WebHelp/docsummary_by_status__doc0164.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 61;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        61
       ,'DOC'
       ,'DOC0165'
       ,''
       ,''
       ,'/doc/WebHelp/docsummary_by_type__doc0165.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 62;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        62
       ,'DOC'
       ,'DOC0205'
       ,''
       ,''
       ,'/doc/WebHelp/docbatch_enquiry_printing__doc0205.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 63;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        63
       ,'DOC'
       ,'DOC0167'
       ,''
       ,''
       ,'/doc/WebHelp/docoutstanding_enquiry_actions__doc.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 64;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        64
       ,'DOC'
       ,'DOC0168'
       ,''
       ,''
       ,'/doc/WebHelp/docenquiry_damage__doc0168.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 65;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        65
       ,'DOC'
       ,'DOC0162'
       ,''
       ,''
       ,'/doc/WebHelp/docacknowledgements__doc0162.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 66;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        66
       ,'DOC'
       ,'DOC0205'
       ,''
       ,''
       ,'/doc/WebHelp/docbatch_enquiry_printing__doc0205.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 67;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        67
       ,'DOC'
       ,'HIG1815'
       ,''
       ,''
       ,'/doc/WebHelp/doccontacts__hig1815.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 68;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        68
       ,'DOC'
       ,'DOC0100'
       ,''
       ,''
       ,'/doc/WebHelp/docdocuments__doc0100.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 69;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        69
       ,'DOC'
       ,'DOC0110'
       ,''
       ,''
       ,'/doc/WebHelp/docdocument_types.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 70;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        70
       ,'DOC'
       ,'DOC0114'
       ,''
       ,''
       ,'/doc/WebHelp/doccirculation_by_person__overview.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 71;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        71
       ,'DOC'
       ,'DOC0115'
       ,''
       ,''
       ,'/doc/WebHelp/doccirculation_by_document__overvie.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 72;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        72
       ,'DOC'
       ,'DOC0116'
       ,''
       ,''
       ,'/doc/WebHelp/dockeywords.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 73;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        73
       ,'DOC'
       ,'DOC0118'
       ,''
       ,''
       ,'/doc/WebHelp/docmedia_types__overview.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 74;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        74
       ,'DOC'
       ,'DOC0120'
       ,''
       ,''
       ,'/doc/WebHelp/docdocument_associations__doc0120.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 75;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        75
       ,'DOC'
       ,'DOC0130'
       ,''
       ,''
       ,'/doc/WebHelp/docdocument_gateways.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 76;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        76
       ,'DOC'
       ,'DOC0157'
       ,''
       ,''
       ,'/doc/WebHelp/docenquiry_redirection_and_prioriti.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 77;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        77
       ,'DOC'
       ,'DOC0160'
       ,''
       ,''
       ,'/doc/WebHelp/docenquiry_details__doc0160.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 78;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        78
       ,'DOC'
       ,'DOC0162'
       ,''
       ,''
       ,'/doc/WebHelp/docacknowledgements__doc0162.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 79;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        79
       ,'DOC'
       ,'DOC0164'
       ,''
       ,''
       ,'/doc/WebHelp/docsummary_by_status__doc0164.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 80;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        80
       ,'DOC'
       ,'DOC0165'
       ,''
       ,''
       ,'/doc/WebHelp/docsummary_by_type__doc0165.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 81;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        81
       ,'DOC'
       ,'DOC0166'
       ,''
       ,''
       ,'/doc/WebHelp/docenquiry_list__doc0166.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 82;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        82
       ,'DOC'
       ,'DOC0167'
       ,''
       ,''
       ,'/doc/WebHelp/docoutstanding_enquiry_actions__doc.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 83;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        83
       ,'DOC'
       ,'DOC0168'
       ,''
       ,''
       ,'/doc/WebHelp/docenquiry_damage__doc0168.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 84;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        84
       ,'DOC'
       ,'DOC0205'
       ,''
       ,''
       ,'/doc/WebHelp/docbatch_enquiry_printing__doc0205.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 85;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        85
       ,'DOC'
       ,'DOC0120'
       ,''
       ,''
       ,'/doc/WebHelp/docdocument_associations__doc0120.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 86;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        86
       ,'DOC'
       ,'DOC0100'
       ,''
       ,''
       ,'/doc/WebHelp/docdocuments__doc0100.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 87;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        87
       ,'DOC'
       ,'DOC0168'
       ,''
       ,''
       ,'/doc/WebHelp/docenquiry_damage__doc0168.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 88;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        88
       ,'DOC'
       ,'DOC0160'
       ,''
       ,''
       ,'/doc/WebHelp/docenquiry_details__doc0160.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 89;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        89
       ,'DOC'
       ,'DOC0166'
       ,''
       ,''
       ,'/doc/WebHelp/docenquiry_list__doc0166.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 90;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        90
       ,'DOC'
       ,'DOC0157'
       ,''
       ,''
       ,'/doc/WebHelp/docenquiry_redirection_and_prioriti.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 91;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        91
       ,'DOC'
       ,'MAI1325'
       ,''
       ,''
       ,'/doc/WebHelp/docenquirydefect_priorities__mai132.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 92;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        92
       ,'DOC'
       ,'MAI1320'
       ,''
       ,''
       ,'/doc/WebHelp/docenquirytreatment_types__mai1320.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 93;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        93
       ,'DOC'
       ,'HIG1815'
       ,''
       ,''
       ,'/doc/WebHelp/doccontacts__hig1815.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 94;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        94
       ,'DOC'
       ,'HIG1880'
       ,''
       ,''
       ,'/doc/WebHelp/docmodules__overview.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 95;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        95
       ,'DOC'
       ,'HIG1880'
       ,''
       ,''
       ,'/doc/WebHelp/docmodules__overview.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 96;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        96
       ,'DOC'
       ,'DOC0167'
       ,''
       ,''
       ,'/doc/WebHelp/docoutstanding_enquiry_actions__doc.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 97;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        97
       ,'DOC'
       ,'DOC0164'
       ,''
       ,''
       ,'/doc/WebHelp/docsummary_by_status__doc0164.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 98;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        98
       ,'DOC'
       ,'DOC0165'
       ,''
       ,''
       ,'/doc/WebHelp/docsummary_by_type__doc0165.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 99;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        99
       ,'HIG'
       ,'HIG9135'
       ,''
       ,''
       ,'/hig/WebHelp/higproduct_option_list__hig9135.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 100;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        100
       ,'HIG'
       ,'HIG1860'
       ,''
       ,''
       ,'/hig/WebHelp/higadmin_units__hig1860.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 101;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        101
       ,'HIG'
       ,'HIG1833'
       ,''
       ,''
       ,'/hig/WebHelp/higchange_password__hig1833.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 102;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        102
       ,'HIG'
       ,'HIG2010'
       ,''
       ,''
       ,'/hig/WebHelp/higcsv_loader_destination_table__hi.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 103;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        103
       ,'HIG'
       ,'HIG2020'
       ,''
       ,''
       ,'/hig/WebHelp/higcsv_loader_file_definitions_tabl.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 104;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        104
       ,'HIG'
       ,'HIG9120'
       ,''
       ,''
       ,'/hig/WebHelp/higdomains__hig9120.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 105;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        105
       ,'HIG'
       ,'HIG1807'
       ,''
       ,''
       ,'/hig/WebHelp/higlaunchpad__favourites.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 106;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        106
       ,'HIG'
       ,'GIS0005'
       ,''
       ,''
       ,'/hig/WebHelp/higprojects__gis0005.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 107;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        107
       ,'HIG'
       ,'GIS'
       ,''
       ,''
       ,'/hig/WebHelp/higthemes__gis0010.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 1;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        1
       ,'ACC'
       ,''
       ,''
       ,''
       ,'/acc/WebHelp/acc.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 2;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        2
       ,'DOC'
       ,''
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 3;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        3
       ,'HIG'
       ,''
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 4;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        4
       ,'IM'
       ,''
       ,''
       ,''
       ,'/im/WebHelp/im.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 5;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        5
       ,'MAI'
       ,''
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 6;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        6
       ,'MRWA'
       ,''
       ,''
       ,''
       ,'/mrwa/WebHelp/mrwa.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 7;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        7
       ,'NET'
       ,''
       ,''
       ,''
       ,'/net/WebHelp/net.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 8;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        8
       ,'NSG'
       ,''
       ,''
       ,''
       ,'/nsg/WebHelp/nsg.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 9;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        9
       ,'ENQ'
       ,''
       ,''
       ,''
       ,'/pem/WebHelp/enq.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 10;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        10
       ,'PMS'
       ,''
       ,''
       ,''
       ,'/pms/WebHelp/pms.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 11;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        11
       ,'CLM'
       ,''
       ,''
       ,''
       ,'/slm/WebHelp/clm.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 12;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        12
       ,'STP'
       ,''
       ,''
       ,''
       ,'/stp/WebHelp/stp.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 13;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        13
       ,'STR'
       ,''
       ,''
       ,''
       ,'/str/WebHelp/str.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 14;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        14
       ,'SWR'
       ,''
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 15;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        15
       ,'TM'
       ,''
       ,''
       ,''
       ,'/tm3/WebHelp/tm.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 16;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        16
       ,'UKP'
       ,''
       ,''
       ,''
       ,'/ukp/WebHelp/ukp.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 17;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        17
       ,'USR'
       ,''
       ,''
       ,''
       ,'/usr/WebHelp/usr.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 18;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        18
       ,'ACC'
       ,'GRI0220'
       ,''
       ,''
       ,'/acc/WebHelp/accgri_modules__gri0220.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 19;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        19
       ,'ACC'
       ,'GRI0240'
       ,''
       ,''
       ,'/acc/WebHelp/accgri_module_parameters__gri0240.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 20;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        20
       ,'ACC'
       ,'GRI0250'
       ,''
       ,''
       ,'/acc/WebHelp/accgri_parameter_dependencies__gri0.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 21;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        21
       ,'ACC'
       ,'ACC2010'
       ,''
       ,''
       ,'/acc/WebHelp/accdomains__acc2010.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 22;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        22
       ,'ACC'
       ,'ACC2020'
       ,''
       ,''
       ,'/acc/WebHelp/accattributes__acc2020.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 23;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        23
       ,'ACC'
       ,'ACC2024'
       ,''
       ,''
       ,'/acc/WebHelp/accattribute_groups__overview.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 24;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        24
       ,'ACC'
       ,'ACC2030'
       ,''
       ,''
       ,'/acc/WebHelp/accitem_types__acc2030.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 25;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        25
       ,'ACC'
       ,'ACC2080'
       ,''
       ,''
       ,'/acc/WebHelp/accdiscoverer_interface__acc2080.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 26;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        26
       ,'ACC'
       ,'ACC2090'
       ,''
       ,''
       ,'/acc/WebHelp/accattribute_bands__overview.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 27;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        27
       ,'ACC'
       ,'ACC3021'
       ,''
       ,''
       ,'/acc/WebHelp/accaccidents__acc302100000088.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 28;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        28
       ,'ACC'
       ,'ACC3040'
       ,''
       ,''
       ,'/acc/WebHelp/accbulk_initialisation__overview.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 29;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        29
       ,'ACC'
       ,'ACC3050'
       ,''
       ,''
       ,'/acc/WebHelp/accbulk_maintenance__acc3050.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 30;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        30
       ,'ACC'
       ,'ACC8810'
       ,''
       ,''
       ,'/acc/WebHelp/accfactor_grids__overview.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 31;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        31
       ,'ACC'
       ,'ACC8812'
       ,''
       ,''
       ,'/acc/WebHelp/accstatistical_summary__overview.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 32;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        32
       ,'ACC'
       ,'ACC8820'
       ,''
       ,''
       ,'/acc/WebHelp/accsite_parameters__overview.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 33;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        33
       ,'ACC'
       ,'ACC8825'
       ,''
       ,''
       ,'/acc/WebHelp/accaccident_groups__overview.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 34;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        34
       ,'ACC'
       ,'ACC8830'
       ,''
       ,''
       ,'/acc/WebHelp/accapply_an_accident_query__acc8830.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 35;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        35
       ,'ACC'
       ,'ACC8835'
       ,''
       ,''
       ,'/acc/WebHelp/accaccident_group_hierarchies__over.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 36;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        36
       ,'ACC'
       ,'ACC8835'
       ,''
       ,''
       ,'/acc/WebHelp/accaccident_group_hierarchies__over.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 37;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        37
       ,'ACC'
       ,'ACC8825'
       ,''
       ,''
       ,'/acc/WebHelp/accaccident_groups__overview.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 38;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        38
       ,'ACC'
       ,'ACC3021'
       ,''
       ,''
       ,'/acc/WebHelp/accaccidents__acc302100000088.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 39;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        39
       ,'ACC'
       ,'ACC8830'
       ,''
       ,''
       ,'/acc/WebHelp/accapply_an_accident_query__acc8830.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 40;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        40
       ,'ACC'
       ,'ACC2090'
       ,''
       ,''
       ,'/acc/WebHelp/accattribute_bands__overview.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 41;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        41
       ,'ACC'
       ,'ACC3050'
       ,''
       ,''
       ,'/acc/WebHelp/accbulk_maintenance__acc3050.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 42;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        42
       ,'ACC'
       ,'ACC2024'
       ,''
       ,''
       ,'/acc/WebHelp/accattribute_groups__overview.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 43;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        43
       ,'ACC'
       ,'ACC2020'
       ,''
       ,''
       ,'/acc/WebHelp/accattributes__acc2020.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 44;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        44
       ,'ACC'
       ,'ACC3040'
       ,''
       ,''
       ,'/acc/WebHelp/accbulk_initialisation__overview.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 45;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        45
       ,'ACC'
       ,'ACC3050'
       ,''
       ,''
       ,'/acc/WebHelp/accbulk_maintenance__acc3050.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 46;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        46
       ,'ACC'
       ,'ACC2080'
       ,''
       ,''
       ,'/acc/WebHelp/accdiscoverer_interface__acc2080.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 47;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        47
       ,'ACC'
       ,'ACC2010'
       ,''
       ,''
       ,'/acc/WebHelp/accdomains__acc2010.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 48;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        48
       ,'ACC'
       ,'ACC8810'
       ,''
       ,''
       ,'/acc/WebHelp/accfactor_grids__overview.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 49;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        49
       ,'ACC'
       ,'HIG1880'
       ,''
       ,''
       ,'/acc/WebHelp/accmodules__overview.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 50;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        50
       ,'ACC'
       ,'ACC2030'
       ,''
       ,''
       ,'/acc/WebHelp/accitem_types__acc2030.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 51;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        51
       ,'ACC'
       ,'HIG1880'
       ,''
       ,''
       ,'/acc/WebHelp/accmodules__overview.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 52;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        52
       ,'ACC'
       ,'ACC8820'
       ,''
       ,''
       ,'/acc/WebHelp/accsite_parameters__overview.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 53;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        53
       ,'ACC'
       ,'ACC8812'
       ,''
       ,''
       ,'/acc/WebHelp/accstatistical_summary__overview.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 54;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        54
       ,'DOC'
       ,'GRI0220'
       ,''
       ,''
       ,'/doc/WebHelp/docgri_modules__gri0220.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 55;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        55
       ,'DOC'
       ,'GRI0240'
       ,''
       ,''
       ,'/doc/WebHelp/docgri_module_parameters__gri0240.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 56;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        56
       ,'DOC'
       ,'GRI0250'
       ,''
       ,''
       ,'/doc/WebHelp/docgri_parameter_dependencies__gri0.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 57;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        57
       ,'DOC'
       ,'DOC0166'
       ,''
       ,''
       ,'/doc/WebHelp/docenquiry_list__doc0166.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 259;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        259
       ,'NET'
       ,'NM0203'
       ,''
       ,''
       ,'/net/WebHelp/netundo_split__nm0203.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 260;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        260
       ,'NET'
       ,'HIG1820'
       ,''
       ,''
       ,'/net/WebHelp/netunits_and_conversions__hig1820.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 261;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        261
       ,'NET'
       ,'HIG1832'
       ,''
       ,''
       ,'/net/WebHelp/netusers__hig1832.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 262;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        262
       ,'NET'
       ,'HIG1836'
       ,''
       ,''
       ,'/net/WebHelp/netroles__hig1836.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 263;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        263
       ,'NET'
       ,'HIG1836'
       ,''
       ,''
       ,'/net/WebHelp/netroles__hig1836.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 264;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        264
       ,'NET'
       ,'NMWEB0020'
       ,''
       ,''
       ,'/net/WebHelp/netweb_based_engineering_dynamic_se.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 265;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        265
       ,'NET'
       ,'NM0305'
       ,''
       ,''
       ,'/net/WebHelp/netxsp_and_reversal_rules__nm0305.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 266;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        266
       ,'PMS'
       ,'PMS4410'
       ,''
       ,''
       ,'/pms/WebHelp/pmslist_of_structural_schemes_by_ro.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 267;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        267
       ,'PMS'
       ,'PMS4404'
       ,''
       ,''
       ,'/pms/WebHelp/pmsaggregate_deflectograph_results_.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 268;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        268
       ,'PMS'
       ,'PMS4402'
       ,''
       ,''
       ,'/pms/WebHelp/pmsallocate_priorities_to_schemes__.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 269;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        269
       ,'PMS'
       ,'PMS4406'
       ,''
       ,''
       ,'/pms/WebHelp/pmsdelete_structural_schemes__pms44.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 270;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        270
       ,'PMS'
       ,'PMS4410'
       ,''
       ,''
       ,'/pms/WebHelp/pmslist_of_structural_schemes_by_ro.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 271;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        271
       ,'PMS'
       ,'PMS4408'
       ,''
       ,''
       ,'/pms/WebHelp/pmsmaintain_road_construction_data_.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 272;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        272
       ,'PMS'
       ,'PMS4400'
       ,''
       ,''
       ,'/pms/WebHelp/pmsstructural_schemes__pms4400.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 273;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        273
       ,'PMS'
       ,'PMS4402'
       ,''
       ,''
       ,'/pms/WebHelp/pmsallocate_priorities_to_schemes__.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 274;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        274
       ,'PMS'
       ,'PMS4404'
       ,''
       ,''
       ,'/pms/WebHelp/pmsaggregate_deflectograph_results_.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 275;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        275
       ,'PMS'
       ,'PMS4406'
       ,''
       ,''
       ,'/pms/WebHelp/pmsdelete_structural_schemes__pms44.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 276;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        276
       ,'PMS'
       ,'PMS4408'
       ,''
       ,''
       ,'/pms/WebHelp/pmsmaintain_road_construction_data_.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 277;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        277
       ,'PMS'
       ,'PMS4410'
       ,''
       ,''
       ,'/pms/WebHelp/pmslist_of_structural_schemes_by_ro.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 278;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        278
       ,'PMS'
       ,'PMS4400'
       ,''
       ,''
       ,'/pms/WebHelp/pmsstructural_schemes__pms4400.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 279;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        279
       ,'STP'
       ,'About'
       ,''
       ,''
       ,'/stp/WebHelp/stpabout_structural_projects_manage.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 280;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        280
       ,'STP'
       ,'NM3020'
       ,''
       ,''
       ,'/stp/WebHelp/stpjob_types__nm3020.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 281;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        281
       ,'STP'
       ,'About'
       ,''
       ,''
       ,'/stp/WebHelp/stpabout_structural_projects_manage.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 282;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        282
       ,'STP'
       ,'NM3010'
       ,''
       ,''
       ,'/stp/WebHelp/stpjob_operations__nm3010.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 283;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        283
       ,'STP'
       ,'NM3020'
       ,''
       ,''
       ,'/stp/WebHelp/stpjob_types__nm3020.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 284;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        284
       ,'STP'
       ,'NM3010'
       ,''
       ,''
       ,'/stp/WebHelp/stpjob_operations__nm3010.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 285;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        285
       ,'STP'
       ,'NM3020'
       ,''
       ,''
       ,'/stp/WebHelp/stpjob_types__nm3020.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 286;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        286
       ,'STP'
       ,'STP0010'
       ,''
       ,''
       ,'/stp/WebHelp/stproad_construction_attributes__st.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 287;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        287
       ,'STP'
       ,'STP1000'
       ,''
       ,''
       ,'/stp/WebHelp/stproad_construction_data__stp1000.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 288;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        288
       ,'STP'
       ,'STP0010'
       ,''
       ,''
       ,'/stp/WebHelp/stproad_construction_attributes__st.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 289;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        289
       ,'STP'
       ,'STP1000'
       ,''
       ,''
       ,'/stp/WebHelp/stproad_construction_data__stp1000.htm' FROM DUAL;
--
--
--********** HIG_STANDARD_FAVOURITES **********--
--
-- Columns
-- HSTF_PARENT                    NOT NULL VARCHAR2(30)
--   HSTF_CONNECT_LOOP_CHK
--   HSTF_PK (Pos 1)
-- HSTF_CHILD                     NOT NULL VARCHAR2(30)
--   HSTF_CONNECT_LOOP_CHK
--   HSTF_PK (Pos 2)
-- HSTF_DESCR                     NOT NULL VARCHAR2(80)
-- HSTF_TYPE                      NOT NULL VARCHAR2(1)
-- HSTF_ORDER                              NUMBER(22)
--
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ROOT'
  AND  HSTF_CHILD = 'FAVOURITES';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ROOT'
       ,'FAVOURITES'
       ,'Launchpad'
       ,'F'
       ,null FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR'
  AND  HSTF_CHILD = 'SWR_ORGS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR'
       ,'SWR_ORGS'
       ,'Organisations'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'FAVOURITES'
  AND  HSTF_CHILD = 'MRWA';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'MRWA'
       ,'MRWA Specifics'
       ,'F'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_ORGS'
  AND  HSTF_CHILD = 'SWR_ORG_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_ORGS'
       ,'SWR_ORG_REPORTS'
       ,'Reports'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'FAVOURITES'
  AND  HSTF_CHILD = 'ACC';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'ACC'
       ,'Accidents Manager'
       ,'F'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'FAVOURITES'
  AND  HSTF_CHILD = 'DOC';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'DOC'
       ,'Document Manager'
       ,'F'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'FAVOURITES'
  AND  HSTF_CHILD = 'HIG';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'HIG'
       ,'Highways'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'FAVOURITES'
  AND  HSTF_CHILD = 'MAI';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'MAI'
       ,'Maintenance Manager'
       ,'F'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'FAVOURITES'
  AND  HSTF_CHILD = 'NET';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'NET'
       ,'Network Manager'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'FAVOURITES'
  AND  HSTF_CHILD = 'PMS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'PMS'
       ,'Structural Projects V2'
       ,'F'
       ,10 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'FAVOURITES'
  AND  HSTF_CHILD = 'ENQ';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'ENQ'
       ,'Public Enquiry Manager'
       ,'F'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'FAVOURITES'
  AND  HSTF_CHILD = 'CLM';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'CLM'
       ,'Street Lighting Manager'
       ,'F'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'FAVOURITES'
  AND  HSTF_CHILD = 'SWR';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'SWR'
       ,'Street Works Manager'
       ,'F'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'FAVOURITES'
  AND  HSTF_CHILD = 'STP';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'STP'
       ,'Structural Projects V3'
       ,'F'
       ,11 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'FAVOURITES'
  AND  HSTF_CHILD = 'STR';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'STR'
       ,'Structures Manager'
       ,'F'
       ,12 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'FAVOURITES'
  AND  HSTF_CHILD = 'TM';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'TM'
       ,'Traffic Manager'
       ,'F'
       ,13 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS'
  AND  HSTF_CHILD = 'SWR_WORKS_QUERY';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS'
       ,'SWR_WORKS_QUERY'
       ,'Query'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR'
  AND  HSTF_CHILD = 'SWR_WORKS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR'
       ,'SWR_WORKS'
       ,'Works'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR'
  AND  HSTF_CHILD = 'SWR_COMMENTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR'
       ,'SWR_COMMENTS'
       ,'Comments'
       ,'F'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR'
  AND  HSTF_CHILD = 'SWR_INSP';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR'
       ,'SWR_INSP'
       ,'Inspections'
       ,'F'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR'
  AND  HSTF_CHILD = 'SWR_GAZ';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR'
       ,'SWR_GAZ'
       ,'Gazetteer'
       ,'F'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR'
  AND  HSTF_CHILD = 'SWR_COORD';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR'
       ,'SWR_COORD'
       ,'Coordindation'
       ,'F'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR'
  AND  HSTF_CHILD = 'SWR_BATCH';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR'
       ,'SWR_BATCH'
       ,'Batch Processing'
       ,'F'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_BATCH_REPORTS'
  AND  HSTF_CHILD = 'SWR1780';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH_REPORTS'
       ,'SWR1780'
       ,'Batch File Listing'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1710';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN_REF'
       ,'SWR1710'
       ,'Maintain Inspection Item Status Codes'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1700';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN_REF'
       ,'SWR1700'
       ,'Maintain Defect Notice Messages'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1690';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN_REF'
       ,'SWR1690'
       ,'Maintain Inspection Outcomes'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1680';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN_REF'
       ,'SWR1680'
       ,'Maintain Inpection Types'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1670';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN_REF'
       ,'SWR1670'
       ,'Maintain Sample Inspection Categories'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1660';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN_REF'
       ,'SWR1660'
       ,'Maintain Inpection Categories'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
  AND  HSTF_CHILD = 'SWR1350';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1350'
       ,'Maintain ASD Coordinates'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
  AND  HSTF_CHILD = 'SWR1220';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1220'
       ,'Print Works Details'
       ,'M'
       ,null FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1570';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1570'
       ,'Maintain Works/Sites Combinations'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1560';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1560'
       ,'Maintain Allowable Site Updates'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
  AND  HSTF_CHILD = 'SWR1159';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1159'
       ,'Works with a Section 74 Duration Challenge'
       ,'M'
       ,null FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
  AND  HSTF_CHILD = 'SWR1158';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1158'
       ,'Works Due a Section 74 Start'
       ,'M'
       ,null FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
  AND  HSTF_CHILD = 'SWR1157';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1157'
       ,'Works Due to Complete'
       ,'M'
       ,null FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_BATCH_REPORTS'
  AND  HSTF_CHILD = 'SWR1610';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH_REPORTS'
       ,'SWR1610'
       ,'Batch Files Processed'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
  AND  HSTF_CHILD = 'SWR1650';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1650'
       ,'Section 74 Charges Invoice'
       ,'M'
       ,null FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1640';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1640'
       ,'Maintain Section 74 Charging Profile'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN'
  AND  HSTF_CHILD = 'SWR1630';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN'
       ,'SWR1630'
       ,'Maintain Section 74 Charges'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
  AND  HSTF_CHILD = 'SWR1225';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1225'
       ,'Generic Works Report'
       ,'M'
       ,null FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_COMMENTS_ADMIN'
  AND  HSTF_CHILD = 'SWR1112';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_COMMENTS_ADMIN'
       ,'SWR1112'
       ,'Comments Sent/Received'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1620';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH_ADMIN_REF'
       ,'SWR1620'
       ,'Maintain Batch Messages'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
  AND  HSTF_CHILD = 'SWR1305';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_REPORTS'
       ,'SWR1305'
       ,'Inspection History'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
  AND  HSTF_CHILD = 'SWR1230';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_REPORTS'
       ,'SWR1230'
       ,'Generic Inspections Report'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
  AND  HSTF_CHILD = 'SWR1770';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN'
       ,'SWR1770'
       ,'View Inspection Defects'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
  AND  HSTF_CHILD = 'SWR1760';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN'
       ,'SWR1760'
       ,'View Inspections History'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
  AND  HSTF_CHILD = 'SWR1750';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN'
       ,'SWR1750'
       ,'Inspections Sent / Received'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1720';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN_REF'
       ,'SWR1720'
       ,'Maintain Allowable Inpection Items'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
  AND  HSTF_CHILD = 'SWR1339';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1339'
       ,'Maintain Special Designation Coordinates'
       ,'M'
       ,11 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
  AND  HSTF_CHILD = 'SWR1370';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1370'
       ,'Maintain Towns / Localities'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN'
  AND  HSTF_CHILD = 'SWR1380';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN'
       ,'SWR1380'
       ,'Non Works Activity'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_QUERY'
  AND  HSTF_CHILD = 'SWR1390';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_QUERY'
       ,'SWR1390'
       ,'View Non Works Activity'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN'
  AND  HSTF_CHILD = 'SWR1400';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN'
       ,'SWR1400'
       ,'Allocate Provisional Works'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1401';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1401'
       ,'Maintain Work Types'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1403';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1403'
       ,'Maintain Notice Types'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_ORGS_ADMIN'
  AND  HSTF_CHILD = 'SWR1450';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_ORGS_ADMIN'
       ,'SWR1450'
       ,'SWA Organisations'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_ORG_REPORTS'
  AND  HSTF_CHILD = 'SWR1451';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_ORG_REPORTS'
       ,'SWR1451'
       ,'Organisation Data Report'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_ORGS_ADMIN'
  AND  HSTF_CHILD = 'SWR1461';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_ORGS_ADMIN'
       ,'SWR1461'
       ,'Maintain District Hierarchy'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_ORGS_ADMIN'
  AND  HSTF_CHILD = 'SWR1471';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_ORGS_ADMIN'
       ,'SWR1471'
       ,'Contact List'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_ORGS_ADMIN'
  AND  HSTF_CHILD = 'SWR1480';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_ORGS_ADMIN'
       ,'SWR1480'
       ,'Coordination Groups'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_ORGS_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1490';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_ORGS_ADMIN_REF'
       ,'SWR1490'
       ,'Standard Text'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_REF_ADMIN'
  AND  HSTF_CHILD = 'SWR1500';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_REF_ADMIN'
       ,'SWR1500'
       ,'Reference Data'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_REF_REPORTS'
  AND  HSTF_CHILD = 'SWR1501';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_REF_REPORTS'
       ,'SWR1501'
       ,'Reference Data Report'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_ADMIN'
  AND  HSTF_CHILD = 'SWR1510';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_ADMIN'
       ,'SWR1510'
       ,'Maintain Interface Mappings'
       ,'M'
       ,null FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1511';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN_REF'
       ,'SWR1511'
       ,'Maintain Reinstatement Categories'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1512';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1512'
       ,'Maintain Works Rules'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1513';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1513'
       ,'Maintain Site Rules'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1514';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN_REF'
       ,'SWR1514'
       ,'Maintain Sample Inspection Category Items'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_REF_ADMIN'
  AND  HSTF_CHILD = 'SWR1515';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_REF_ADMIN'
       ,'SWR1515'
       ,'Maintain System Options'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
  AND  HSTF_CHILD = 'SWR1517';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN'
       ,'SWR1517'
       ,'Maintain Defect Inspection Schedule'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
  AND  HSTF_CHILD = 'SWR1338';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1338'
       ,'Maintain Reinstatement Designation Coordinates'
       ,'M'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
  AND  HSTF_CHILD = 'SWR1290';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN'
       ,'SWR1290'
       ,'Schedule Inspections'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
  AND  HSTF_CHILD = 'SWR1292';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_REPORTS'
       ,'SWR1292'
       ,'Works Inspection Report'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
  AND  HSTF_CHILD = 'SWR1294';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_REPORTS'
       ,'SWR1294'
       ,'Prospective Inspections Report'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
  AND  HSTF_CHILD = 'SWR1325';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_REPORTS'
       ,'SWR1325'
       ,'Sample Inspections Invoice Report'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
  AND  HSTF_CHILD = 'SWR1326';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_REPORTS'
       ,'SWR1326'
       ,'Inspections Invoice'
       ,'M'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
  AND  HSTF_CHILD = 'SWR1328';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1328'
       ,'Chargeable Notices Invoice'
       ,'M'
       ,null FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
  AND  HSTF_CHILD = 'SWR1330';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1330'
       ,'Maintain Street Gazetteer'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
  AND  HSTF_CHILD = 'SWR1332';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1332'
       ,'Maintain Street Coordinates'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
  AND  HSTF_CHILD = 'SWR1333';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1333'
       ,'Maintain Street Reinstatement Designations'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1334';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN_REF'
       ,'SWR1334'
       ,'Maintain Designation Types'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
  AND  HSTF_CHILD = 'SWR1335';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1335'
       ,'Maintain Street Special Designations'
       ,'M'
       ,10 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
  AND  HSTF_CHILD = 'SWR1336';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1336'
       ,'Maintain Street Naming Authorities'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
  AND  HSTF_CHILD = 'SWR1337';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1337'
       ,'Maintain Additional Street Data'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
  AND  HSTF_CHILD = 'SWR1209';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1209'
       ,'Expiring Reinstatement Guarantees'
       ,'M'
       ,null FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
  AND  HSTF_CHILD = 'SWR1212';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1212'
       ,'Interim Reinstatements > 6 Months Old'
       ,'M'
       ,null FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
  AND  HSTF_CHILD = 'SWR1240';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN'
       ,'SWR1240'
       ,'Maintain Annual Inspection Profiles'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
  AND  HSTF_CHILD = 'SWR1250';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN'
       ,'SWR1250'
       ,'Maintain Inspection Details'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
  AND  HSTF_CHILD = 'SWR1255';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_REPORTS'
       ,'SWR1255'
       ,'Annual Inspection Profiles'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
  AND  HSTF_CHILD = 'SWR1256';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_REPORTS'
       ,'SWR1256'
       ,'Sample Inspection Quotas Report'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
  AND  HSTF_CHILD = 'SWR1257';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_REPORTS'
       ,'SWR1257'
       ,'Inspection Performance'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_REF_ADMIN'
  AND  HSTF_CHILD = 'SWR1060';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_REF_ADMIN'
       ,'SWR1060'
       ,'System Definitions'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_QUERY'
  AND  HSTF_CHILD = 'SWR1070';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_QUERY'
       ,'SWR1070'
       ,'Query Works/Sites'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_COMMENTS_ADMIN'
  AND  HSTF_CHILD = 'SWR1111';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_COMMENTS_ADMIN'
       ,'SWR1111'
       ,'Maintain Works Comments'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN'
  AND  HSTF_CHILD = 'SWR1120';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN'
       ,'SWR1120'
       ,'Notices Sent/Received'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_REF_ADMIN'
  AND  HSTF_CHILD = 'SWR1051';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_REF_ADMIN'
       ,'SWR1051'
       ,'Maintain User Definitions'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
  AND  HSTF_CHILD = 'SWR1156';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1156'
       ,'Works History'
       ,'M'
       ,null FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN'
  AND  HSTF_CHILD = 'SWR1180';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN'
       ,'SWR1180'
       ,'Merge Unattributable Works'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_QUERY'
  AND  HSTF_CHILD = 'SWR1189';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_QUERY'
       ,'SWR1189'
       ,'Query Works History'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN'
  AND  HSTF_CHILD = 'SWR1190';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN'
       ,'SWR1190'
       ,'Maintain Works / Reinstatement Details'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
  AND  HSTF_CHILD = 'SWR1193';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1193'
       ,'Works Overdue'
       ,'M'
       ,null FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
  AND  HSTF_CHILD = 'SWR1195';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1195'
       ,'Notice Analysis Report'
       ,'M'
       ,null FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_COORD_REPORTS'
  AND  HSTF_CHILD = 'SWR1197';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_COORD_REPORTS'
       ,'SWR1197'
       ,'Coordination Planning'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_COORD_REPORTS'
  AND  HSTF_CHILD = 'SWR1198';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_COORD_REPORTS'
       ,'SWR1198'
       ,'Conflicting Works'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
  AND  HSTF_CHILD = 'SWR1530';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1530'
       ,'Streets of Interest'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_GAZ_REPORTS'
  AND  HSTF_CHILD = 'SWR1550';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_REPORTS'
       ,'SWR1550'
       ,'SOI Gazetteer Data Report'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_GAZ_REPORTS'
  AND  HSTF_CHILD = 'SWR1551';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_REPORTS'
       ,'SWR1551'
       ,'Authority Gazetteer Data Report'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN'
  AND  HSTF_CHILD = 'SWR1600';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH_ADMIN'
       ,'SWR1600'
       ,'Upload/Download Utility'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN'
  AND  HSTF_CHILD = 'SWR1601';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH_ADMIN'
       ,'SWR1601'
       ,'Automatic Upload/Download Utility'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1602';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH_ADMIN_REF'
       ,'SWR1602'
       ,'Maintain Automatic Batch Processes'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1603';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH_ADMIN_REF'
       ,'SWR1603'
       ,'Maintain Automatic Batch Rules'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1604';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH_ADMIN_REF'
       ,'SWR1604'
       ,'Maintain Automatic Batch Operations'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN'
  AND  HSTF_CHILD = 'SWR1605';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH_ADMIN'
       ,'SWR1605'
       ,'Monitor Batch File Status'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
  AND  HSTF_CHILD = 'SWR1519';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1519'
       ,'Maintain Notice Charges'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP'
  AND  HSTF_CHILD = 'SWR_INSP_ADMIN';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP'
       ,'SWR_INSP_ADMIN'
       ,'Admin'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS'
  AND  HSTF_CHILD = 'SWR_WORKS_ADMIN';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS'
       ,'SWR_WORKS_ADMIN'
       ,'Admin'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS'
  AND  HSTF_CHILD = 'SWR_WORKS_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS'
       ,'SWR_WORKS_REPORTS'
       ,'Reports'
       ,'F'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP'
  AND  HSTF_CHILD = 'SWR_INSP_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP'
       ,'SWR_INSP_REPORTS'
       ,'Reports'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_COMMENTS'
  AND  HSTF_CHILD = 'SWR_COMMENTS_ADMIN';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_COMMENTS'
       ,'SWR_COMMENTS_ADMIN'
       ,'Admin'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_ORGS'
  AND  HSTF_CHILD = 'SWR_ORGS_ADMIN';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_ORGS'
       ,'SWR_ORGS_ADMIN'
       ,'Admin'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_GAZ'
  AND  HSTF_CHILD = 'SWR_GAZ_ADMIN';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ'
       ,'SWR_GAZ_ADMIN'
       ,'Admin'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_GAZ'
  AND  HSTF_CHILD = 'SWR_GAZ_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ'
       ,'SWR_GAZ_REPORTS'
       ,'Reports'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_COORD'
  AND  HSTF_CHILD = 'SWR_COORD_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_COORD'
       ,'SWR_COORD_REPORTS'
       ,'Reports'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR'
  AND  HSTF_CHILD = 'SWR_REF';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR'
       ,'SWR_REF'
       ,'Reference Data'
       ,'F'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_REF'
  AND  HSTF_CHILD = 'SWR_REF_ADMIN';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_REF'
       ,'SWR_REF_ADMIN'
       ,'Admin'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN'
  AND  HSTF_CHILD = 'SWR_WORKS_ADMIN_REF';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN'
       ,'SWR_WORKS_ADMIN_REF'
       ,'Reference Data'
       ,'F'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
  AND  HSTF_CHILD = 'SWR_INSP_ADMIN_REF';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN'
       ,'SWR_INSP_ADMIN_REF'
       ,'Reference Data'
       ,'F'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
  AND  HSTF_CHILD = 'SWR_GAZ_ADMIN_REF';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR_GAZ_ADMIN_REF'
       ,'Reference Data'
       ,'F'
       ,12 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_BATCH'
  AND  HSTF_CHILD = 'SWR_BATCH_ADMIN';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH'
       ,'SWR_BATCH_ADMIN'
       ,'Admin'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN'
  AND  HSTF_CHILD = 'SWR_BATCH_ADMIN_REF';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH_ADMIN'
       ,'SWR_BATCH_ADMIN_REF'
       ,'Reference Data'
       ,'F'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_BATCH'
  AND  HSTF_CHILD = 'SWR_BATCH_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH'
       ,'SWR_BATCH_REPORTS'
       ,'Reports'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_ORGS_ADMIN'
  AND  HSTF_CHILD = 'SWR_ORGS_ADMIN_REF';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_ORGS_ADMIN'
       ,'SWR_ORGS_ADMIN_REF'
       ,'Reference Data'
       ,'F'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'SWR_REF'
  AND  HSTF_CHILD = 'SWR_REF_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_REF'
       ,'SWR_REF_REPORTS'
       ,'Reports'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET'
  AND  HSTF_CHILD = 'NET_NET_MANAGEMENT';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET'
       ,'NET_NET_MANAGEMENT'
       ,'Network Management'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET'
  AND  HSTF_CHILD = 'NET_NETWORK';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET'
       ,'NET_NETWORK'
       ,'Network'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET'
  AND  HSTF_CHILD = 'NET_REF';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET'
       ,'NET_REF'
       ,'Reference Data'
       ,'F'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_REF'
  AND  HSTF_CHILD = 'NM0001';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_REF'
       ,'NM0001'
       ,'Node Types'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_REF'
  AND  HSTF_CHILD = 'NM0002';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_REF'
       ,'NM0002'
       ,'Network Types'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_REF'
  AND  HSTF_CHILD = 'NM0004';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_REF'
       ,'NM0004'
       ,'Group Types'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_NET_MANAGEMENT'
  AND  HSTF_CHILD = 'NM0101';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NET_MANAGEMENT'
       ,'NM0101'
       ,'Nodes'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_NET_MANAGEMENT'
  AND  HSTF_CHILD = 'NM0105';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NET_MANAGEMENT'
       ,'NM0105'
       ,'Elements'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_NET_MANAGEMENT'
  AND  HSTF_CHILD = 'NM0110';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NET_MANAGEMENT'
       ,'NM0110'
       ,'Groups of Sections'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_NET_MANAGEMENT'
  AND  HSTF_CHILD = 'NM0115';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NET_MANAGEMENT'
       ,'NM0115'
       ,'Groups of Groups'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_NETWORK'
  AND  HSTF_CHILD = 'NM0120';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0120'
       ,'Create Network Extent'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_NETWORK'
  AND  HSTF_CHILD = 'NM0200';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0200'
       ,'Split Element'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_NETWORK'
  AND  HSTF_CHILD = 'NM0201';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0201'
       ,'Merge Elements'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_NETWORK'
  AND  HSTF_CHILD = 'NM0202';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0202'
       ,'Replace Element'
       ,'M'
       ,10 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_NETWORK'
  AND  HSTF_CHILD = 'NM0203';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0203'
       ,'Undo Split'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_NETWORK'
  AND  HSTF_CHILD = 'NM0204';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0204'
       ,'Undo Merge'
       ,'M'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_NETWORK'
  AND  HSTF_CHILD = 'NM0205';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0205'
       ,'Undo Replace'
       ,'M'
       ,11 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_NETWORK'
  AND  HSTF_CHILD = 'NM0206';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0206'
       ,'Close Element'
       ,'M'
       ,12 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_NETWORK'
  AND  HSTF_CHILD = 'NM0207';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0207'
       ,'Unclose Element'
       ,'M'
       ,13 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_NETWORK'
  AND  HSTF_CHILD = 'NM0220';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0220'
       ,'Reclassify Element'
       ,'M'
       ,15 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_NETWORK'
  AND  HSTF_CHILD = 'NM0500';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0500'
       ,'Network Walker'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_INVENTORY'
  AND  HSTF_CHILD = 'NM0510';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY'
       ,'NM0510'
       ,'Asset Items'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_INVENTORY'
  AND  HSTF_CHILD = 'NM0530';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY'
       ,'NM0530'
       ,'Global Asset Update'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_INVENTORY'
  AND  HSTF_CHILD = 'NM0560';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY'
       ,'NM0560'
       ,'Assets On A Route'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_NETWORK'
  AND  HSTF_CHILD = 'NM1200';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM1200'
       ,'SLK Calculator'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_NETWORK'
  AND  HSTF_CHILD = 'NM2000';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM2000'
       ,'Recalibrate Element'
       ,'M'
       ,14 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_QUERIES'
  AND  HSTF_CHILD = 'NM7040';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_QUERIES'
       ,'NM7040'
       ,'PBI Queries'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_QUERIES'
  AND  HSTF_CHILD = 'NM7041';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_QUERIES'
       ,'NM7041'
       ,'PBI Query Results'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_QUERIES'
  AND  HSTF_CHILD = 'NM7050';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_QUERIES'
       ,'NM7050'
       ,'Merge Queries'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_QUERIES'
  AND  HSTF_CHILD = 'NM7051';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_QUERIES'
       ,'NM7051'
       ,'Merge Query Results'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_QUERIES'
  AND  HSTF_CHILD = 'NM7053';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_QUERIES'
       ,'NM7053'
       ,'Merge Query Defaults'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_QUERIES'
  AND  HSTF_CHILD = 'NM7055';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_QUERIES'
       ,'NM7055'
       ,'Merge File Definition'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_QUERIES'
  AND  HSTF_CHILD = 'NM7057';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_QUERIES'
       ,'NM7057'
       ,'Merge Results Extract'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_NETWORK'
  AND  HSTF_CHILD = 'NM1201';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM1201'
       ,'Offset Calculator'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_QUERIES'
  AND  HSTF_CHILD = 'NMWEB0020';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_QUERIES'
       ,'NMWEB0020'
       ,'Engineering Dynamic Segmentation'
       ,'M'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_INVENTORY'
  AND  HSTF_CHILD = 'NM1861';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY'
       ,'NM1861'
       ,'Inventory Admin Unit Security Maintenance'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_INVENTORY'
  AND  HSTF_CHILD = 'NM0570';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY'
       ,'NM0570'
       ,'Find Assets'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_INVENTORY_REPORTS'
  AND  HSTF_CHILD = 'NM0562';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY_REPORTS'
       ,'NM0562'
       ,'Assets On Route Report - By Offset'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_INVENTORY_REPORTS'
  AND  HSTF_CHILD = 'NM0563';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY_REPORTS'
       ,'NM0563'
       ,'Assets On Route Report- By Type and Offset'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_INVENTORY_MAPCAP'
  AND  HSTF_CHILD = 'NM0511';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY_MAPCAP'
       ,'NM0511'
       ,'Reconcile MapCapture Load Errors'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_NETWORK'
  AND  HSTF_CHILD = 'NM1100';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM1100'
       ,'Gazetteer'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_INVENTORY'
  AND  HSTF_CHILD = 'NET_INVENTORY_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY'
       ,'NET_INVENTORY_REPORTS'
       ,'Reports'
       ,'F'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_INVENTORY'
  AND  HSTF_CHILD = 'NET_INVENTORY_MAPCAP';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY'
       ,'NET_INVENTORY_MAPCAP'
       ,'MapCapture Asset Loader'
       ,'F'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_INVENTORY_MAPCAP'
  AND  HSTF_CHILD = 'NM0580';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY_MAPCAP'
       ,'NM0580'
       ,'Create MapCapture Metadata File'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_QUERIES'
  AND  HSTF_CHILD = 'NM0120';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_QUERIES'
       ,'NM0120'
       ,'Create Network Extent'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'DOC'
  AND  HSTF_CHILD = 'DOC_DOCUMENTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC'
       ,'DOC_DOCUMENTS'
       ,'Documents'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'DOC'
  AND  HSTF_CHILD = 'DOC_REF';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC'
       ,'DOC_REF'
       ,'Reference Data'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'DOC_DOCUMENTS'
  AND  HSTF_CHILD = 'DOC0100';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC_DOCUMENTS'
       ,'DOC0100'
       ,'Documents'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'DOC_REF'
  AND  HSTF_CHILD = 'DOC0110';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC_REF'
       ,'DOC0110'
       ,'Document Types/Classes/Enquiry Types'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'DOC_DOCUMENTS'
  AND  HSTF_CHILD = 'DOC0114';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC_DOCUMENTS'
       ,'DOC0114'
       ,'Circulation by Person'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'DOC_DOCUMENTS'
  AND  HSTF_CHILD = 'DOC0115';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC_DOCUMENTS'
       ,'DOC0115'
       ,'Circulation by Document'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'DOC_REF'
  AND  HSTF_CHILD = 'DOC0116';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC_REF'
       ,'DOC0116'
       ,'Keywords'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'DOC_REF'
  AND  HSTF_CHILD = 'DOC0118';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC_REF'
       ,'DOC0118'
       ,'Media/Locations'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_LOADERS'
  AND  HSTF_CHILD = 'MAI_LOADERS_INSPECTIONS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS'
       ,'MAI_LOADERS_INSPECTIONS'
       ,'Inspections'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REPORTS'
  AND  HSTF_CHILD = 'MAI_REPORTS_AUDIT';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS'
       ,'MAI_REPORTS_AUDIT'
       ,'Audit'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'DOC_REF'
  AND  HSTF_CHILD = 'DOC0130';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC_REF'
       ,'DOC0130'
       ,'Document Gateways'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REPORTS'
  AND  HSTF_CHILD = 'MAI_REPORTS_HIST';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS'
       ,'MAI_REPORTS_HIST'
       ,'Historical'
       ,'F'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'DOC_REF_TEMPLATES'
  AND  HSTF_CHILD = 'DOC0201';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC_REF_TEMPLATES'
       ,'DOC0201'
       ,'Templates'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'DOC_REF_TEMPLATES'
  AND  HSTF_CHILD = 'DOC0202';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC_REF_TEMPLATES'
       ,'DOC0202'
       ,'Template Users'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_FINANCIAL'
  AND  HSTF_CHILD = 'MAI_FINANCIAL_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL'
       ,'MAI_FINANCIAL_REPORTS'
       ,'Reports'
       ,'F'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_CONTRACTS'
  AND  HSTF_CHILD = 'MAI_CONTRACTS_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS'
       ,'MAI_CONTRACTS_REPORTS'
       ,'Reports'
       ,'F'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS'
  AND  HSTF_CHILD = 'MAI_WORKS_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI_WORKS_REPORTS'
       ,'Reports'
       ,'F'
       ,13 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP'
  AND  HSTF_CHILD = 'MAI_INSP_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP'
       ,'MAI_INSP_REPORTS'
       ,'Reports'
       ,'F'
       ,10 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV'
  AND  HSTF_CHILD = 'MAI_INV_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV'
       ,'MAI_INV_REPORTS'
       ,'Reports'
       ,'F'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
  AND  HSTF_CHILD = 'MAI1830';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI1830'
       ,'People'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
  AND  HSTF_CHILD = 'MAI1870';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI1870'
       ,'Organisations'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_FINANCIAL'
  AND  HSTF_CHILD = 'MAI3664';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_FINANCIAL'
       ,'MAI3664'
       ,'Financial Years'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS'
  AND  HSTF_CHILD = 'MAI3825';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI3825'
       ,'Maintenance Report'
       ,'M'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_FINANCIAL'
  AND  HSTF_CHILD = 'MAI1930';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL'
       ,'MAI1930'
       ,'IHMS Allocated Amounts'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI5032';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI5032'
       ,'Print Cyclic Maintenance Done'
       ,'M'
       ,13 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'DOC_REF'
  AND  HSTF_CHILD = 'DOC_REF_TEMPLATES';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC_REF'
       ,'DOC_REF_TEMPLATES'
       ,'Templates'
       ,'F'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI'
  AND  HSTF_CHILD = 'MAI_INV';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI'
       ,'MAI_INV'
       ,'Inventory'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI'
  AND  HSTF_CHILD = 'MAI_INSP';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI'
       ,'MAI_INSP'
       ,'Inspections'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI'
  AND  HSTF_CHILD = 'MAI_WORKS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI'
       ,'MAI_WORKS'
       ,'Works'
       ,'F'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI'
  AND  HSTF_CHILD = 'MAI_CONTRACTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI'
       ,'MAI_CONTRACTS'
       ,'Contracts'
       ,'F'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI'
  AND  HSTF_CHILD = 'MAI_INTERFACES';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI'
       ,'MAI_INTERFACES'
       ,'Interfaces'
       ,'F'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI'
  AND  HSTF_CHILD = 'MAI_FINANCIAL';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI'
       ,'MAI_FINANCIAL'
       ,'Financial'
       ,'F'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI'
  AND  HSTF_CHILD = 'MAI_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI'
       ,'MAI_REPORTS'
       ,'Reports'
       ,'F'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI'
  AND  HSTF_CHILD = 'MAI_REF';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI'
       ,'MAI_REF'
       ,'Reference'
       ,'F'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI'
  AND  HSTF_CHILD = 'MAI_LOADERS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI'
       ,'MAI_LOADERS'
       ,'Loaders'
       ,'F'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF'
  AND  HSTF_CHILD = 'MAI_REF_INVENTORY';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF'
       ,'MAI_REF_INVENTORY'
       ,'Inventory'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF'
  AND  HSTF_CHILD = 'MAI_REF_INSPECTIONS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF'
       ,'MAI_REF_INSPECTIONS'
       ,'Inspections'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF'
  AND  HSTF_CHILD = 'MAI_REF_MAINTENANCE';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF'
       ,'MAI_REF_MAINTENANCE'
       ,'Maintenance'
       ,'F'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF'
  AND  HSTF_CHILD = 'MAI_REF_FINANCIAL';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF'
       ,'MAI_REF_FINANCIAL'
       ,'Financial'
       ,'F'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_FINANCIAL'
  AND  HSTF_CHILD = 'MAI_REF_FINANCIAL_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_FINANCIAL'
       ,'MAI_REF_FINANCIAL_REPORTS'
       ,'Reports'
       ,'F'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
  AND  HSTF_CHILD = 'MAI_REF_MAINTENANCE_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI_REF_MAINTENANCE_REPORTS'
       ,'Reports'
       ,'F'
       ,14 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
  AND  HSTF_CHILD = 'MAI_REF_INSPECTIONS_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI_REF_INSPECTIONS_REPORTS'
       ,'Reports'
       ,'F'
       ,11 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INVENTORY'
  AND  HSTF_CHILD = 'MAI_REF_INVENTORY_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INVENTORY'
       ,'MAI_REF_INVENTORY_REPORTS'
       ,'Reports'
       ,'F'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_LOADERS'
  AND  HSTF_CHILD = 'MAI_LOADERS_INVENTORY';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS'
       ,'MAI_LOADERS_INVENTORY'
       ,'Inventory'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
  AND  HSTF_CHILD = 'MAI3626';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI3626'
       ,'Cyclic Maintenance Inventory Rules'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE_REPORTS'
  AND  HSTF_CHILD = 'MAI5024';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE_REPORTS'
       ,'MAI5024'
       ,'Print Local Frequencies and Intervals'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_FINANCIAL'
  AND  HSTF_CHILD = 'MAI3842';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL'
       ,'MAI3842'
       ,'Deselect Items for Payment'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_FINANCIAL'
  AND  HSTF_CHILD = 'MAI3940';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL'
       ,'MAI3940'
       ,'Query Payment Run Details'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_FINANCIAL'
  AND  HSTF_CHILD = 'MAI3660';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL'
       ,'MAI3660'
       ,'Budgets'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_FINANCIAL'
  AND  HSTF_CHILD = 'MAI3662';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL'
       ,'MAI3662'
       ,'Generate Budgets for Next Year'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_FINANCIAL_REPORTS'
  AND  HSTF_CHILD = 'MAI3942';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL_REPORTS'
       ,'MAI3942'
       ,'List of Items for Payment'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_FINANCIAL_REPORTS'
  AND  HSTF_CHILD = 'MAI3944';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL_REPORTS'
       ,'MAI3944'
       ,'List of Completed Rechargeable Defects'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_FINANCIAL_REPORTS'
  AND  HSTF_CHILD = 'MAI3690';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL_REPORTS'
       ,'MAI3690'
       ,'Print Budget Exceptions Report'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_FINANCIAL'
  AND  HSTF_CHILD = 'MAI3666';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_FINANCIAL'
       ,'MAI3666'
       ,'Job Size Codes'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_FINANCIAL'
  AND  HSTF_CHILD = 'MAI3844';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_FINANCIAL'
       ,'MAI3844'
       ,'Cost Centre Codes'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_FINANCIAL'
  AND  HSTF_CHILD = 'MAI3846';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_FINANCIAL'
       ,'MAI3846'
       ,'VAT Rates'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_FINANCIAL_REPORTS'
  AND  HSTF_CHILD = 'MAI3946';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_FINANCIAL_REPORTS'
       ,'MAI3946'
       ,'List of VAT Rates'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
  AND  HSTF_CHILD = 'MAI5022';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI5022'
       ,'Print Inspectors Pocket Book'
       ,'M'
       ,19 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
  AND  HSTF_CHILD = 'MAI5011';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI5011'
       ,'Print Road Markings - Longitudinal'
       ,'M'
       ,16 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
  AND  HSTF_CHILD = 'MAI5015';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI5015'
       ,'Print Road Markings - Transverse and Special'
       ,'M'
       ,15 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
  AND  HSTF_CHILD = 'MAI5018';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI5018'
       ,'Print Sign Areas'
       ,'M'
       ,14 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
  AND  HSTF_CHILD = 'MAI30060';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI30060'
       ,'Print Historical Inventory Data'
       ,'M'
       ,12 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INVENTORY'
  AND  HSTF_CHILD = 'MAI1430';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INVENTORY'
       ,'MAI1430'
       ,'Lamp Configurations'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INVENTORY'
  AND  HSTF_CHILD = 'MAI1920';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INVENTORY'
       ,'MAI1920'
       ,'Inventory XSPs'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
  AND  HSTF_CHILD = 'MAI1240';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI1240'
       ,'Default Section Intervals'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
  AND  HSTF_CHILD = 'MAI1210';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI1210'
       ,'Local Activity Frequencies'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
  AND  HSTF_CHILD = 'MAI1205';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI1205'
       ,'Activity Groups'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
  AND  HSTF_CHILD = 'MAI3440';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI3440'
       ,'Valid For Maintenance Rules'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
  AND  HSTF_CHILD = 'MAI3628';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI3628'
       ,'Related Maintenance Activities'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
  AND  HSTF_CHILD = 'MAI5031';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI5031'
       ,'Print Electrical Inventory'
       ,'M'
       ,18 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV'
  AND  HSTF_CHILD = 'MAI2310';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV'
       ,'MAI2310'
       ,'Inventory Items'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV'
  AND  HSTF_CHILD = 'MAI2140';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV'
       ,'MAI2140'
       ,'Query Network/Inventory Data'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
  AND  HSTF_CHILD = 'MAI5035A';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5035A'
       ,'Print C Audit - Actions by Activity Area'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
  AND  HSTF_CHILD = 'MAI5034B';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5034B'
       ,'Print B Audit - Defects by Activity,Type and Time'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
  AND  HSTF_CHILD = 'MAI5035B';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5035B'
       ,'Print D Audit - Actions by Defect Type'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
  AND  HSTF_CHILD = 'MAI2315';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI2315'
       ,'Print Inventory Items (matrix format)'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
  AND  HSTF_CHILD = 'MAI5060';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5060'
       ,'Print F Audit - Defect for Point and Cont. Inv Items'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI3490';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3490'
       ,'Review Raised Works Orders'
       ,'M'
       ,12 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
  AND  HSTF_CHILD = 'MAI5070';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5070'
       ,'Print M Audit - Analysis of Cyclic Maintenance Activities'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
  AND  HSTF_CHILD = 'MAI6110';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI6110'
       ,'Print Inventory Lengths'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
  AND  HSTF_CHILD = 'MAI3905';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI3905'
       ,'Print Roadstud Defects not Set to Mandatory or Advisory'
       ,'M'
       ,11 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
  AND  HSTF_CHILD = 'MAI5037A';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5037A'
       ,'Print E Audit - Electrical Report by Link'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
  AND  HSTF_CHILD = 'MAI2325';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI2325'
       ,'Print Inventory Summary'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
  AND  HSTF_CHILD = 'MAI5010';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI5010'
       ,'Print Road Markings - Hatched Type Area'
       ,'M'
       ,17 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_LOADERS_INSPECTIONS'
  AND  HSTF_CHILD = 'MAI2224';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INSPECTIONS'
       ,'MAI2224'
       ,'Download Network Data for DCD Inspections'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
  AND  HSTF_CHILD = 'MAI5100';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI5100'
       ,'Print Defect Details (At-a-Glance)'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
  AND  HSTF_CHILD = 'MAI5038';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5038'
       ,'Print T Audit - Audit Of Costs'
       ,'M'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI3960';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3960'
       ,'Print Cyclic Maintenance Schedules'
       ,'M'
       ,15 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
  AND  HSTF_CHILD = 'MAI2790';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI2790'
       ,'Insurance Claims Reporting'
       ,'M'
       ,12 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
  AND  HSTF_CHILD = 'MAI3900';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI3900'
       ,'Print Inspection Report'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
  AND  HSTF_CHILD = 'MAI3904';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI3904'
       ,'Print Defect Notices'
       ,'M'
       ,13 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
  AND  HSTF_CHILD = 'MAI3910';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI3910'
       ,'List of Defects by Inspection Date'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
  AND  HSTF_CHILD = 'MAI3912';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI3912'
       ,'List of Notifiable Defects'
       ,'M'
       ,14 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
  AND  HSTF_CHILD = 'MAI3916';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI3916'
       ,'Summary of Notifiable/Rechargeable Defects'
       ,'M'
       ,15 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
  AND  HSTF_CHILD = 'MAI1300';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI1300'
       ,'Defect Control Data'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
  AND  HSTF_CHILD = 'MAI1315';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI1315'
       ,'Treatment Data'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
  AND  HSTF_CHILD = 'MAI3150';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI3150'
       ,'Default Treatments'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
  AND  HSTF_CHILD = 'MAI3814';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI3814'
       ,'Treatment Models'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_CONTRACTS_REPORTS'
  AND  HSTF_CHILD = 'MAI3988';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS_REPORTS'
       ,'MAI3988'
       ,'List of Standard Items'
       ,'M'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_CONTRACTS_REPORTS'
  AND  HSTF_CHILD = 'MAI3986';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS_REPORTS'
       ,'MAI3986'
       ,'List of Standard Item Sections and Sub-Sections'
       ,'M'
       ,10 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_CONTRACTS_REPORTS'
  AND  HSTF_CHILD = 'MAI3954';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS_REPORTS'
       ,'MAI3954'
       ,'Contractor Performance Report'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_CONTRACTS_REPORTS'
  AND  HSTF_CHILD = 'MAI3932';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS_REPORTS'
       ,'MAI3932'
       ,'Summary of Work Instructed by Standard Item'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_CONTRACTS_REPORTS'
  AND  HSTF_CHILD = 'MAI3934';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS_REPORTS'
       ,'MAI3934'
       ,'Summary of Work Volumes by Standard Item'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_CONTRACTS_REPORTS'
  AND  HSTF_CHILD = 'MAI3948';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS_REPORTS'
       ,'MAI3948'
       ,'Summary of Expenditure by Contract'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REPORTS_HIST'
  AND  HSTF_CHILD = 'MAI3992';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_HIST'
       ,'MAI3992'
       ,'Road Section Historical Report'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REPORTS_HIST'
  AND  HSTF_CHILD = 'MAI3994';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_HIST'
       ,'MAI3994'
       ,'Road Section Historical Statistics'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP'
  AND  HSTF_CHILD = 'MAI3808';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP'
       ,'MAI3808'
       ,'Inspections'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP'
  AND  HSTF_CHILD = 'MAI3806';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP'
       ,'MAI3806'
       ,'Defects'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP'
  AND  HSTF_CHILD = 'MAI3810';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP'
       ,'MAI3810'
       ,'View Defects'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP'
  AND  HSTF_CHILD = 'MAI3816';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP'
       ,'MAI3816'
       ,'Responses to Notices'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP'
  AND  HSTF_CHILD = 'MAI2730';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP'
       ,'MAI2730'
       ,'Match Duplicate Defects'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP'
  AND  HSTF_CHILD = 'MAI2760';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP'
       ,'MAI2760'
       ,'Unmatch Duplicate Defects'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP'
  AND  HSTF_CHILD = 'MAI2470';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP'
       ,'MAI2470'
       ,'Delete Inspections'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP'
  AND  HSTF_CHILD = 'MAI2775';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP'
       ,'MAI2775'
       ,'Batch Setting of Repair Dates'
       ,'M'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_LOADERS_INSPECTIONS'
  AND  HSTF_CHILD = 'MAI2220';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INSPECTIONS'
       ,'MAI2220'
       ,'Download Static Ref Data for DCD Inspections'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_LOADERS_INSPECTIONS'
  AND  HSTF_CHILD = 'MAI2222';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INSPECTIONS'
       ,'MAI2222'
       ,'Download Standard Item Data for DCD Inspections'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_CONTRACTS_REPORTS'
  AND  HSTF_CHILD = 'MAI3981';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS_REPORTS'
       ,'MAI3981'
       ,'List of Contractors'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_CONTRACTS'
  AND  HSTF_CHILD = 'MAI3888';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS'
       ,'MAI3888'
       ,'Standard Items'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_CONTRACTS'
  AND  HSTF_CHILD = 'MAI3886';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS'
       ,'MAI3886'
       ,'Standard Item Sections and Sub-Sections'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_CONTRACTS'
  AND  HSTF_CHILD = 'MAI3881';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS'
       ,'MAI3881'
       ,'Contractors'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_CONTRACTS'
  AND  HSTF_CHILD = 'MAI3880';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS'
       ,'MAI3880'
       ,'Contracts'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_CONTRACTS'
  AND  HSTF_CHILD = 'MAI3882';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS'
       ,'MAI3882'
       ,'Copy a Contract'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_CONTRACTS'
  AND  HSTF_CHILD = 'MAI3884';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS'
       ,'MAI3884'
       ,'Bulk Update of Contract Items'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_CONTRACTS'
  AND  HSTF_CHILD = 'MAI3624';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS'
       ,'MAI3624'
       ,'Discount Groups'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_CONTRACTS_REPORTS'
  AND  HSTF_CHILD = 'MAI3980';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS_REPORTS'
       ,'MAI3980'
       ,'Contract Details Report'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_CONTRACTS_REPORTS'
  AND  HSTF_CHILD = 'MAI3984';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS_REPORTS'
       ,'MAI3984'
       ,'List of Contract Rates'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_CONTRACTS_REPORTS'
  AND  HSTF_CHILD = 'MAI3982';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS_REPORTS'
       ,'MAI3982'
       ,'List of Contract Liabilities'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS'
  AND  HSTF_CHILD = 'MAI3820';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI3820'
       ,'Quality Inspection Results'
       ,'M'
       ,11 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS'
  AND  HSTF_CHILD = 'MAI3804';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI3804'
       ,'View Cyclic Maintenance Work'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS'
  AND  HSTF_CHILD = 'MAI3610';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI3610'
       ,'Cancel Work Orders'
       ,'M'
       ,10 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS'
  AND  HSTF_CHILD = 'MAI3860';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI3860'
       ,'Cyclic Maintenance Schedules'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS'
  AND  HSTF_CHILD = 'MAI3862';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI3862'
       ,'Cyclic Maintenance Schedules by Road Section'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS'
  AND  HSTF_CHILD = 'MAI1280';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI1280'
       ,'External Activities'
       ,'M'
       ,12 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI3906';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3906'
       ,'Print BOQ Work Order (Defects)'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI3922';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3922'
       ,'List of Defects Not Yet Instructed'
       ,'M'
       ,16 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI3924';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3924'
       ,'List of Instructed Work by Status'
       ,'M'
       ,18 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI3926';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3926'
       ,'List of Instructed Defects due for Completion'
       ,'M'
       ,19 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI3950';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3950'
       ,'List of Work for Quality Inspection'
       ,'M'
       ,21 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI3930';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3930'
       ,'List of Inventory Updates'
       ,'M'
       ,20 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI3920';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3920'
       ,'Summary of Defects Not Yet Instructed'
       ,'M'
       ,17 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI3956';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3956'
       ,'Admin Unit Performance Report'
       ,'M'
       ,23 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI3952';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3952'
       ,'Quality Inspection Performance Report'
       ,'M'
       ,22 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_FINANCIAL'
  AND  HSTF_CHILD = 'MAI3840';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL'
       ,'MAI3840'
       ,'Payment Run'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS_REPORTS'
  AND  HSTF_CHILD = 'MAI3250';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS_REPORTS'
       ,'MAI3250'
       ,'Print Defect Movements'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
  AND  HSTF_CHILD = 'MAI3470';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI3470'
       ,'Print Defect Details ( Work Orders )'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_REF'
  AND  HSTF_CHILD = 'ACC_REF_ITEM_ATTRIB';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF'
       ,'ACC_REF_ITEM_ATTRIB'
       ,'Item/Attribute'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_LOADERS_INVENTORY'
  AND  HSTF_CHILD = 'MAI2500';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INVENTORY'
       ,'MAI2500'
       ,'Download Data for Inventory Survey on DCD'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
  AND  HSTF_CHILD = 'MAI2501';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI2501'
       ,'Inventory Interface'
       ,'M'
       ,12 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_LOADERS_INSPECTIONS'
  AND  HSTF_CHILD = 'MAI2200C';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INSPECTIONS'
       ,'MAI2200C'
       ,'Inspection Loader (Part 1)'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_LOADERS_INSPECTIONS'
  AND  HSTF_CHILD = 'MAI2200D';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INSPECTIONS'
       ,'MAI2200D'
       ,'Inspection Loader (Part 2)'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INVENTORY'
  AND  HSTF_CHILD = 'MAI1910';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INVENTORY'
       ,'MAI1910'
       ,'XSP Values'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS_REPORTS'
  AND  HSTF_CHILD = 'MAI1840';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS_REPORTS'
       ,'MAI1840'
       ,'List of People'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
  AND  HSTF_CHILD = 'MAI2115';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI2115'
       ,'Print Potential Inventory Duplicates'
       ,'M'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_LOADERS_INVENTORY'
  AND  HSTF_CHILD = 'MAI5065';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INVENTORY'
       ,'MAI5065'
       ,'Print Batch with Downloaded Inventory Items'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INVENTORY_REPORTS'
  AND  HSTF_CHILD = 'MAI5200';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INVENTORY_REPORTS'
       ,'MAI5200'
       ,'Print Lamp Configurations'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE_REPORTS'
  AND  HSTF_CHILD = 'MAI5205';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE_REPORTS'
       ,'MAI5205'
       ,'Print Activity Frequencies'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INVENTORY_REPORTS'
  AND  HSTF_CHILD = 'MAI5210';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INVENTORY_REPORTS'
       ,'MAI5210'
       ,'Print Electricity Boards'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE_REPORTS'
  AND  HSTF_CHILD = 'MAI5215';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE_REPORTS'
       ,'MAI5215'
       ,'Print Interval Codes'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS_REPORTS'
  AND  HSTF_CHILD = 'MAI5220';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS_REPORTS'
       ,'MAI5220'
       ,'Print Valid Defect Types'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE_REPORTS'
  AND  HSTF_CHILD = 'MAI5225';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE_REPORTS'
       ,'MAI5225'
       ,'Print Activities'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
  AND  HSTF_CHILD = 'MAI6100';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI6100'
       ,'Print Inventory Statistics'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS_REPORTS'
  AND  HSTF_CHILD = 'MAI5235';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS_REPORTS'
       ,'MAI5235'
       ,'Print Defect Item Types'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS_REPORTS'
  AND  HSTF_CHILD = 'MAI5240';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS_REPORTS'
       ,'MAI5240'
       ,'Print Treatment Codes'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
  AND  HSTF_CHILD = 'MAI9020';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI9020'
       ,'Print Inventory Gap/Overlap'
       ,'M'
       ,11 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_FINANCIAL_REPORTS'
  AND  HSTF_CHILD = 'MAI2780';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_FINANCIAL_REPORTS'
       ,'MAI2780'
       ,'Print Item Code Breakdowns'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
  AND  HSTF_CHILD = 'MAI5125';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI5125'
       ,'Print Defect Details (Strip Plan)'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
  AND  HSTF_CHILD = 'MAI2210';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI2210'
       ,'Print Defective Advisory Roadstuds Report'
       ,'M'
       ,10 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_REF'
  AND  HSTF_CHILD = 'ACC_REF_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF'
       ,'ACC_REF_REPORTS'
       ,'Reports'
       ,'F'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_LOADERS_INVENTORY'
  AND  HSTF_CHILD = 'MAI2105C';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INVENTORY'
       ,'MAI2105C'
       ,'Reformat Road Group Inventory Data'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INVENTORY_REPORTS'
  AND  HSTF_CHILD = 'MAI5050';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INVENTORY_REPORTS'
       ,'MAI5050'
       ,'Print List of Inventory Item Types, Attributes and Values'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
  AND  HSTF_CHILD = 'MAI5075';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI5075'
       ,'Print Inventory Item Report'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
  AND  HSTF_CHILD = 'MAI2330';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI2330'
       ,'Print Summary of Inventory Changes'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
  AND  HSTF_CHILD = 'MAI9010';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI9010'
       ,'Detect Inventory Gap/Overlap'
       ,'M'
       ,10 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
  AND  HSTF_CHILD = 'MAI2320';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI2320'
       ,'Print Inventory Map'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI3480';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3480'
       ,'Print Works Order (Priced)'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI3500';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3500'
       ,'Print Works Orders Detail'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI3505';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3505'
       ,'Print Works Orders (Summary)'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI3485';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3485'
       ,'Print Works Order (Unpriced)'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI5130';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI5130'
       ,'Print Works Orders (Strip Plan)'
       ,'M'
       ,11 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_LOADERS_INSPECTIONS'
  AND  HSTF_CHILD = 'MAI2200R';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INSPECTIONS'
       ,'MAI2200R'
       ,'Bulk Inspection Load - Stage 2 Report'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
  AND  HSTF_CHILD = 'MAI5034A';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5034A'
       ,'Print A Audit - Defects by Type, Activity and Time'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
  AND  HSTF_CHILD = 'MAI5027';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI5027'
       ,'Print Defects by Defect Type'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI3907';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3907'
       ,'Print BOQ Work Order (Cyclic)'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI3909';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3909'
       ,'Print Works Order (NMA)'
       ,'M'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
  AND  HSTF_CHILD = 'MAI5080';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5080'
       ,'Print I Audit - 7 and 28 day Safety Inspection Statistics'
       ,'M'
       ,10 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_LOADERS_INVENTORY'
  AND  HSTF_CHILD = 'MAI2100C';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INVENTORY'
       ,'MAI2100C'
       ,'Inventory Loader (Part 1)'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_LOADERS_INVENTORY'
  AND  HSTF_CHILD = 'MAI2110C';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INVENTORY'
       ,'MAI2110C'
       ,'Inventory Loader (Part 2)'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS'
  AND  HSTF_CHILD = 'MAI3802';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI3802'
       ,'Maintain Work Orders - Contractor Interface'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP'
  AND  HSTF_CHILD = 'MAI3899';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP'
       ,'MAI3899'
       ,'Inspections by Group'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INTERFACES'
  AND  HSTF_CHILD = 'MAI3830';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INTERFACES'
       ,'MAI3830'
       ,'Works Order File Extract'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INTERFACES'
  AND  HSTF_CHILD = 'MAI3834';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INTERFACES'
       ,'MAI3834'
       ,'Financial Commitment File'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INTERFACES'
  AND  HSTF_CHILD = 'MAI3856';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INTERFACES'
       ,'MAI3856'
       ,'Payment Approval form'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INTERFACES'
  AND  HSTF_CHILD = 'MAI3854';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INTERFACES'
       ,'MAI3854'
       ,'Invoice Verification form'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INTERFACES'
  AND  HSTF_CHILD = 'MAI3850';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INTERFACES'
       ,'MAI3850'
       ,'Completions file'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INTERFACES'
  AND  HSTF_CHILD = 'MAI3852';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INTERFACES'
       ,'MAI3852'
       ,'Invoice file'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INTERFACES'
  AND  HSTF_CHILD = 'MAI3858';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INTERFACES'
       ,'MAI3858'
       ,'Payment Transaction file'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
  AND  HSTF_CHILD = 'MAI1320';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI1320'
       ,'Enquiry/Treatment Types'
       ,'M'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
  AND  HSTF_CHILD = 'MAI1325';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI1325'
       ,'Enquiry/Defect Priorities'
       ,'M'
       ,10 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_ANALYSIS'
  AND  HSTF_CHILD = 'ACC_ANALYSIS_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS'
       ,'ACC_ANALYSIS_REPORTS'
       ,'Reports'
       ,'F'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_IO'
  AND  HSTF_CHILD = 'ACC_IO_LOAD_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_IO'
       ,'ACC_IO_LOAD_REPORTS'
       ,'Load Reports'
       ,'F'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_LOADERS_INVENTORY'
  AND  HSTF_CHILD = 'MAI5090';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INVENTORY'
       ,'MAI5090'
       ,'Remove Successfully Loaded Inventory Batches'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_LOADERS_INSPECTIONS'
  AND  HSTF_CHILD = 'MAI5091';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INSPECTIONS'
       ,'MAI5091'
       ,'Remove Phase 1 Inspection Batches'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INVENTORY'
  AND  HSTF_CHILD = 'MAI1440';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INVENTORY'
       ,'MAI1440'
       ,'Inventory Colour Map'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI3105';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3105'
       ,'Print: Cyclic Maintenance Activities'
       ,'M'
       ,14 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_LOADERS_INSPECTIONS'
  AND  HSTF_CHILD = 'MAI3863';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INSPECTIONS'
       ,'MAI3863'
       ,'Download Inspection by Assets'
       ,'M'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
  AND  HSTF_CHILD = 'MAI5021';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI5021'
       ,'Print Inventory Areas - Trapezium Rule'
       ,'M'
       ,13 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
  AND  HSTF_CHILD = 'MAI3100';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI3100'
       ,'Print Inspection Schedules'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
  AND  HSTF_CHILD = 'MAI3902';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI3902'
       ,'Print Defect Details'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_REF_ITEM_ATTRIB'
  AND  HSTF_CHILD = 'ACC2010';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF_ITEM_ATTRIB'
       ,'ACC2010'
       ,'Domains'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS'
  AND  HSTF_CHILD = 'MAI3848';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI3848'
       ,'Work Orders Authorisation'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
  AND  HSTF_CHILD = 'MAI3803';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI3803'
       ,'Work Order Auditing Maintenance'
       ,'M'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
  AND  HSTF_CHILD = 'MAI5001';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI5001'
       ,'Inventory Item Details'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_REF_ITEM_ATTRIB'
  AND  HSTF_CHILD = 'ACC2020';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF_ITEM_ATTRIB'
       ,'ACC2020'
       ,'Attributes'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_REF_ITEM_ATTRIB'
  AND  HSTF_CHILD = 'ACC2024';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF_ITEM_ATTRIB'
       ,'ACC2024'
       ,'Attribute Group'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_REF_ITEM_ATTRIB'
  AND  HSTF_CHILD = 'ACC2030';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF_ITEM_ATTRIB'
       ,'ACC2030'
       ,'Item Control Data'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_REF'
  AND  HSTF_CHILD = 'ACC2050';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF'
       ,'ACC2050'
       ,'Cross Attribute Validation Rules'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_REF'
  AND  HSTF_CHILD = 'ACC2060';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF'
       ,'ACC2060'
       ,'Hotspot Dates'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_REF'
  AND  HSTF_CHILD = 'ACC2070';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF'
       ,'ACC2070'
       ,'Accident Images'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI3919';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3919'
       ,'Print Works Order (Enhanced)'
       ,'M'
       ,10 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_MANAGEMENT'
  AND  HSTF_CHILD = 'ACC3020';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_MANAGEMENT'
       ,'ACC3020'
       ,'Accidents v2'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_MANAGEMENT'
  AND  HSTF_CHILD = 'ACC3021';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_MANAGEMENT'
       ,'ACC3021'
       ,'Accidents'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_MANAGEMENT_ATTRIB'
  AND  HSTF_CHILD = 'ACC3040';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_MANAGEMENT_ATTRIB'
       ,'ACC3040'
       ,'Bulk Initialisation'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_MANAGEMENT_ATTRIB'
  AND  HSTF_CHILD = 'ACC3050';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_MANAGEMENT_ATTRIB'
       ,'ACC3050'
       ,'Bulk Maintenance'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
  AND  HSTF_CHILD = 'MAI3813';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI3813'
       ,'Maintain Automatic Defect Prioritisation'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_ANALYSIS'
  AND  HSTF_CHILD = 'ACC7045';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS'
       ,'ACC7045'
       ,'Queries'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_MANAGEMENT_REPORTS'
  AND  HSTF_CHILD = 'ACC8001';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_MANAGEMENT_REPORTS'
       ,'ACC8001'
       ,'Profile Report'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_REF_REPORTS'
  AND  HSTF_CHILD = 'ACC8004';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF_REPORTS'
       ,'ACC8004'
       ,'List of Attribute Domains'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS'
  AND  HSTF_CHILD = 'MAI3800';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI3800'
       ,'Works Orders (Defects)'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI'
  AND  HSTF_CHILD = 'DOC0206';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI'
       ,'DOC0206'
       ,'Batch Works Order Printing'
       ,'M'
       ,21 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_FINANCIAL_REPORTS'
  AND  HSTF_CHILD = 'MAI3692';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL_REPORTS'
       ,'MAI3692'
       ,'Print Cost Code Exceptions Report'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REPORTS'
  AND  HSTF_CHILD = 'MAI7040';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS'
       ,'MAI7040'
       ,'Parameter Based Inquiry (PBI)'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
  AND  HSTF_CHILD = 'MAI5037';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5037'
       ,'Print E Audit - Electrical Report by Ownership'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
  AND  HSTF_CHILD = 'MAI5027';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5027'
       ,'Print Defects by Defect Type'
       ,'M'
       ,11 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INVENTORY'
  AND  HSTF_CHILD = 'MAI1400';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INVENTORY'
       ,'MAI1400'
       ,'Inventory Control Data'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
  AND  HSTF_CHILD = 'MAI3812';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI3812'
       ,'Defect Priorities'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS_REPORTS'
  AND  HSTF_CHILD = 'MAI1808';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS_REPORTS'
       ,'MAI1808'
       ,'List of Organisations'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
  AND  HSTF_CHILD = 'MAI1200';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI1200'
       ,'Activities'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
  AND  HSTF_CHILD = 'MAI1230';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI1230'
       ,'Default Section Intervals Calculation'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE_REPORTS'
  AND  HSTF_CHILD = 'MAI5030';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE_REPORTS'
       ,'MAI5030'
       ,'Print Default Intervals and Frequencies'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_FINANCIAL'
  AND  HSTF_CHILD = 'MAI1940';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_FINANCIAL'
       ,'MAI1940'
       ,'Item Code Breakdowns'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_LOADERS_INVENTORY'
  AND  HSTF_CHILD = 'MAI2120';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INVENTORY'
       ,'MAI2120'
       ,'Correct Inventory Load Errors'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_LOADERS_INSPECTIONS'
  AND  HSTF_CHILD = 'MAI2250';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INSPECTIONS'
       ,'MAI2250'
       ,'Correct Inspection Load Errors'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC'
  AND  HSTF_CHILD = 'ACC_MANAGEMENT';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC'
       ,'ACC_MANAGEMENT'
       ,'Management'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC'
  AND  HSTF_CHILD = 'ACC_REF';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC'
       ,'ACC_REF'
       ,'Reference'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC'
  AND  HSTF_CHILD = 'ACC_ANALYSIS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC'
       ,'ACC_ANALYSIS'
       ,'Analysis'
       ,'F'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC'
  AND  HSTF_CHILD = 'ACC_IO';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC'
       ,'ACC_IO'
       ,'Data i/o'
       ,'F'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_MANAGEMENT'
  AND  HSTF_CHILD = 'ACC_MANAGEMENT_ATTRIB';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_MANAGEMENT'
       ,'ACC_MANAGEMENT_ATTRIB'
       ,'Attribute'
       ,'F'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_MANAGEMENT'
  AND  HSTF_CHILD = 'ACC_MANAGEMENT_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_MANAGEMENT'
       ,'ACC_MANAGEMENT_REPORTS'
       ,'Reports'
       ,'F'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_REF_REPORTS'
  AND  HSTF_CHILD = 'ACC8005';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF_REPORTS'
       ,'ACC8005'
       ,'List of Attribute Types'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_REF_REPORTS'
  AND  HSTF_CHILD = 'ACC8006';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF_REPORTS'
       ,'ACC8006'
       ,'List of Item Types'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_REF_REPORTS'
  AND  HSTF_CHILD = 'ACC8007';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF_REPORTS'
       ,'ACC8007'
       ,'List of Attribute Groups'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_REF_REPORTS'
  AND  HSTF_CHILD = 'ACC8008';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF_REPORTS'
       ,'ACC8008'
       ,'List of Valid Items and Attributes'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_ANALYSIS'
  AND  HSTF_CHILD = 'ACC8800';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS'
       ,'ACC8800'
       ,'Identify Sites'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_ANALYSIS'
  AND  HSTF_CHILD = 'ACC8810';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS'
       ,'ACC8810'
       ,'Factor Grid'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_ANALYSIS_REPORTS'
  AND  HSTF_CHILD = 'ACC8811';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS_REPORTS'
       ,'ACC8811'
       ,'Factor Grid Report'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_ANALYSIS'
  AND  HSTF_CHILD = 'ACC8812';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS'
       ,'ACC8812'
       ,'Statistical Summary'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_REF'
  AND  HSTF_CHILD = 'ACC8820';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF'
       ,'ACC8820'
       ,'Site Parameters'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_ANALYSIS'
  AND  HSTF_CHILD = 'ACC8825';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS'
       ,'ACC8825'
       ,'Accident Groups'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_ANALYSIS'
  AND  HSTF_CHILD = 'ACC8830';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS'
       ,'ACC8830'
       ,'Create Accident Groups'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_ANALYSIS'
  AND  HSTF_CHILD = 'ACC8835';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS'
       ,'ACC8835'
       ,'Accident Group Hieracrchies'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_ANALYSIS_REPORTS'
  AND  HSTF_CHILD = 'ACC8840';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS_REPORTS'
       ,'ACC8840'
       ,'Hotspot Report'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR'
  AND  HSTF_CHILD = 'STR_INSPECTIONS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR'
       ,'STR_INSPECTIONS'
       ,'Inspections'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_ANALYSIS_REPORTS'
  AND  HSTF_CHILD = 'ACC8842';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS_REPORTS'
       ,'ACC8842'
       ,'Accident Group Refresh Utility'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_IO'
  AND  HSTF_CHILD = 'ACC8890';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_IO'
       ,'ACC8890'
       ,'Load Accidents'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_IO'
  AND  HSTF_CHILD = 'ACC8891';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_IO'
       ,'ACC8891'
       ,'Accident File Load Rules'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_IO_LOAD_REPORTS'
  AND  HSTF_CHILD = 'ACC8892';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_IO_LOAD_REPORTS'
       ,'ACC8892'
       ,'External File Description'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR'
  AND  HSTF_CHILD = 'STR_REFERENCE';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR'
       ,'STR_REFERENCE'
       ,'Reference Data'
       ,'F'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR'
  AND  HSTF_CHILD = 'STR_BULK';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR'
       ,'STR_BULK'
       ,'Bulk Data Loading'
       ,'F'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR'
  AND  HSTF_CHILD = 'STR_DART';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR'
       ,'STR_DART'
       ,'D.A.R.T.'
       ,'F'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_DART'
  AND  HSTF_CHILD = 'STR7045';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_DART'
       ,'STR7045'
       ,'Dynamic Attribute Reporting Tool'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INSPECTIONS'
  AND  HSTF_CHILD = 'STR3022';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS'
       ,'STR3022'
       ,'Inspection Controls for a Structure'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INSPECTIONS'
  AND  HSTF_CHILD = 'STR3070';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS'
       ,'STR3070'
       ,'Auto-Schedule Inspections'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INSPECTIONS'
  AND  HSTF_CHILD = 'STR3072';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS'
       ,'STR3072'
       ,'Scheduled Inspections for a Structure'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_REF'
  AND  HSTF_CHILD = 'ACC2080';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF'
       ,'ACC2080'
       ,'Discoverer Interface'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_REF_ITEM_ATTRIB'
  AND  HSTF_CHILD = 'ACC2090';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF_ITEM_ATTRIB'
       ,'ACC2090'
       ,'Accident Attribute Bands'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_ANALYSIS'
  AND  HSTF_CHILD = 'ACC8827';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS'
       ,'ACC8827'
       ,'Group Removal'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INSPECTIONS'
  AND  HSTF_CHILD = 'STR3080';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS'
       ,'STR3080'
       ,'Inspection Batches'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ACC_ANALYSIS_REPORTS'
  AND  HSTF_CHILD = 'ACC8001';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS_REPORTS'
       ,'ACC8001'
       ,'Profile Report'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR'
  AND  HSTF_CHILD = 'STR_INVENTORY';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR'
       ,'STR_INVENTORY'
       ,'Inventory'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INSPECTIONS'
  AND  HSTF_CHILD = 'STR3086';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS'
       ,'STR3086'
       ,'Inspection Records for a Structure'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INSPECTIONS_REPORTS'
  AND  HSTF_CHILD = 'STR5015';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS_REPORTS'
       ,'STR5015'
       ,'Profile of an Inspection'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INSPECTIONS_REPORTS'
  AND  HSTF_CHILD = 'STR5042';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS_REPORTS'
       ,'STR5042'
       ,'List of Structures needing Specialist Equipment'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INSPECTIONS_REPORTS'
  AND  HSTF_CHILD = 'STR5070';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS_REPORTS'
       ,'STR5070'
       ,'List of Scheduled Inspections by Date'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INSPECTIONS_REPORTS'
  AND  HSTF_CHILD = 'STR5072';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS_REPORTS'
       ,'STR5072'
       ,'List of Inspections by Batch'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INSPECTIONS_REPORTS'
  AND  HSTF_CHILD = 'STR5074';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS_REPORTS'
       ,'STR5074'
       ,'List of Scheduled Inspections by Cycle'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INSPECTIONS_REPORTS'
  AND  HSTF_CHILD = 'STR5076';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS_REPORTS'
       ,'STR5076'
       ,'Summary of Scheduled Inspections by Cycle'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INSPECTIONS_REPORTS'
  AND  HSTF_CHILD = 'STR5078';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS_REPORTS'
       ,'STR5078'
       ,'List of Inspections later than Scheduled Date'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INSPECTIONS_REPORTS'
  AND  HSTF_CHILD = 'STR5080';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS_REPORTS'
       ,'STR5080'
       ,'List of Inspections later than Mandated Date'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INSPECTIONS_REPORTS'
  AND  HSTF_CHILD = 'STR5082';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS_REPORTS'
       ,'STR5082'
       ,'List of Inspection Ratings'
       ,'M'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INSPECTIONS_REPORTS'
  AND  HSTF_CHILD = 'STR5084';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS_REPORTS'
       ,'STR5084'
       ,'List of Inspection Rating Exceptions'
       ,'M'
       ,10 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INVENTORY'
  AND  HSTF_CHILD = 'STR3020';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY'
       ,'STR3020'
       ,'Structure Hierarchies and Attributes'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INVENTORY'
  AND  HSTF_CHILD = 'STR3024';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY'
       ,'STR3024'
       ,'Structure Attributes'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STP_REFERENCE'
  AND  HSTF_CHILD = 'NM7050';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE'
       ,'NM7050'
       ,'Merge Queries'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INVENTORY'
  AND  HSTF_CHILD = 'STR3060';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY'
       ,'STR3060'
       ,'Resequence Structure Hierarchies'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INVENTORY'
  AND  HSTF_CHILD = 'STR3010';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY'
       ,'STR3010'
       ,'Create Structures from a Template'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INVENTORY'
  AND  HSTF_CHILD = 'STR3030';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY'
       ,'STR3030'
       ,'Delete Structures'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INVENTORY'
  AND  HSTF_CHILD = 'STR3040';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY'
       ,'STR3040'
       ,'Bulk Initialisation of Attribute Values'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INVENTORY'
  AND  HSTF_CHILD = 'STR3050';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY'
       ,'STR3050'
       ,'Bulk Maintenance of Attribute Values'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INVENTORY_REPORTS'
  AND  HSTF_CHILD = 'STR5010';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY_REPORTS'
       ,'STR5010'
       ,'Profile of a Structure'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INVENTORY_REPORTS'
  AND  HSTF_CHILD = 'STR5050';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY_REPORTS'
       ,'STR5050'
       ,'List of Structures on a Route'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INVENTORY_REPORTS'
  AND  HSTF_CHILD = 'STR5040';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY_REPORTS'
       ,'STR5040'
       ,'List of Structures with Named Attributes'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INVENTORY_REPORTS'
  AND  HSTF_CHILD = 'STR5020';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY_REPORTS'
       ,'STR5020'
       ,'List of Obstructions with Active TROs'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INVENTORY_REPORTS'
  AND  HSTF_CHILD = 'STR5030';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY_REPORTS'
       ,'STR5030'
       ,'List of Obstructions on a Route'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_REFERENCE'
  AND  HSTF_CHILD = 'STR2010';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2010'
       ,'Attribute Domains'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_REFERENCE'
  AND  HSTF_CHILD = 'STR2020';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2020'
       ,'Attribute Types'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_REFERENCE'
  AND  HSTF_CHILD = 'STR2024';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2024'
       ,'Attribute Groups'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_REFERENCE'
  AND  HSTF_CHILD = 'STR2030';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2030'
       ,'Structure Item Types'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_REFERENCE'
  AND  HSTF_CHILD = 'STR2040';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2040'
       ,'Templates'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_REFERENCE'
  AND  HSTF_CHILD = 'STR2050';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2050'
       ,'Obstruction Types'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_REFERENCE'
  AND  HSTF_CHILD = 'STR2068';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2068'
       ,'Inspection Sets'
       ,'M'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_REFERENCE'
  AND  HSTF_CHILD = 'STR2060';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2060'
       ,'Inspection Types'
       ,'M'
       ,10 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_REFERENCE'
  AND  HSTF_CHILD = 'STR2062';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2062'
       ,'Inspection Cycles'
       ,'M'
       ,11 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_REFERENCE'
  AND  HSTF_CHILD = 'STR2064';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2064'
       ,'Inspection Equipment'
       ,'M'
       ,12 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_REFERENCE_REPORTS'
  AND  HSTF_CHILD = 'STR5004';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE_REPORTS'
       ,'STR5004'
       ,'List of Attribute Domains'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_REFERENCE_REPORTS'
  AND  HSTF_CHILD = 'STR5005';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE_REPORTS'
       ,'STR5005'
       ,'List of Attribute Types'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_REFERENCE_REPORTS'
  AND  HSTF_CHILD = 'STR5006';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE_REPORTS'
       ,'STR5006'
       ,'List of Item Types'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_REFERENCE_REPORTS'
  AND  HSTF_CHILD = 'STR5007';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE_REPORTS'
       ,'STR5007'
       ,'List of Attribute Groups'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_REFERENCE_REPORTS'
  AND  HSTF_CHILD = 'STR5008';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE_REPORTS'
       ,'STR5008'
       ,'List of Valid Item/Attributes'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_REFERENCE_REPORTS'
  AND  HSTF_CHILD = 'STR5009';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE_REPORTS'
       ,'STR5009'
       ,'List of Valid Item/Inspections'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_BULK'
  AND  HSTF_CHILD = 'STR1001';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_BULK'
       ,'STR1001'
       ,'Download Control Data into DCD File'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_BULK'
  AND  HSTF_CHILD = 'STR1002';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_BULK'
       ,'STR1002'
       ,'Download Inspection Parameters into DCD File'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_BULK'
  AND  HSTF_CHILD = 'STR1003';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_BULK'
       ,'STR1003'
       ,'Upload Inspection Records from DCD File'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_BULK'
  AND  HSTF_CHILD = 'STR1004';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_BULK'
       ,'STR1004'
       ,'Load Structures Inventory onto Database'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_REFERENCE'
  AND  HSTF_CHILD = 'STR2070';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2070'
       ,'Organisations'
       ,'M'
       ,13 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STP_REFERENCE'
  AND  HSTF_CHILD = 'STP_REFERENCE_INVENTORY';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE'
       ,'STP_REFERENCE_INVENTORY'
       ,'Inventory'
       ,'F'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INSPECTIONS'
  AND  HSTF_CHILD = 'STR3001';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS'
       ,'STR3001'
       ,'Calculate Bridge Condition Indicators'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_REFERENCE'
  AND  HSTF_CHILD = 'STR3002';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR3002'
       ,'Bridge Condition Reference Data'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_REFERENCE'
  AND  HSTF_CHILD = 'STR3003';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR3003'
       ,'Defect Code Maintenance'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INVENTORY'
  AND  HSTF_CHILD = 'STR_INVENTORY_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY'
       ,'STR_INVENTORY_REPORTS'
       ,'Reports'
       ,'F'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_INSPECTIONS'
  AND  HSTF_CHILD = 'STR_INSPECTIONS_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS'
       ,'STR_INSPECTIONS_REPORTS'
       ,'Reports'
       ,'F'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STR_REFERENCE'
  AND  HSTF_CHILD = 'STR_REFERENCE_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR_REFERENCE_REPORTS'
       ,'Reports'
       ,'F'
       ,14 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STP_ROAD'
  AND  HSTF_CHILD = 'STP1000';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_ROAD'
       ,'STP1000'
       ,'Road Construction'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STP_REFERENCE'
  AND  HSTF_CHILD = 'STP0010';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE'
       ,'STP0010'
       ,'Road Construction Attributes'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STP_ROAD'
  AND  HSTF_CHILD = 'STP3030';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_ROAD'
       ,'STP3030'
       ,'Road Construction Schemes'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STP'
  AND  HSTF_CHILD = 'STP_ROAD';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP'
       ,'STP_ROAD'
       ,'Road Construction '
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STP'
  AND  HSTF_CHILD = 'STP_REFERENCE';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP'
       ,'STP_REFERENCE'
       ,'Reference'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STP_REFERENCE_INVENTORY'
  AND  HSTF_CHILD = 'NM0301';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE_INVENTORY'
       ,'NM0301'
       ,'Asset Domains'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STP_REFERENCE_INVENTORY'
  AND  HSTF_CHILD = 'NM0410';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE_INVENTORY'
       ,'NM0410'
       ,'Inventory Metamodel'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STP_REFERENCE_INVENTORY'
  AND  HSTF_CHILD = 'NM0411';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE_INVENTORY'
       ,'NM0411'
       ,'Inventory Exclusive View Creation'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STP_REFERENCE_INVENTORY'
  AND  HSTF_CHILD = 'NM0305';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE_INVENTORY'
       ,'NM0305'
       ,'XSP and Reversal Rules'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STP_REFERENCE_INVENTORY'
  AND  HSTF_CHILD = 'NM0306';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE_INVENTORY'
       ,'NM0306'
       ,'Asset XSPs'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STP_REFERENCE_INVENTORY'
  AND  HSTF_CHILD = 'NM0550';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE_INVENTORY'
       ,'NM0550'
       ,'Cross Attribute Validation Setup'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STP_REFERENCE_INVENTORY'
  AND  HSTF_CHILD = 'NM0551';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE_INVENTORY'
       ,'NM0551'
       ,'Cross Item Validation Setup'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STP_REFERENCE'
  AND  HSTF_CHILD = 'STP_REFERENCE_JOB';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE'
       ,'STP_REFERENCE_JOB'
       ,'Job Metadata'
       ,'F'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STP_REFERENCE_JOB'
  AND  HSTF_CHILD = 'NM3020';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE_JOB'
       ,'NM3020'
       ,'Job Types'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'STP_REFERENCE_JOB'
  AND  HSTF_CHILD = 'NM3010';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE_JOB'
       ,'NM3010'
       ,'Job Operations'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_ROAD'
  AND  HSTF_CHILD = 'PMS4408';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_ROAD'
       ,'PMS4408'
       ,'Road Construction Data'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_ROAD'
  AND  HSTF_CHILD = 'PMS4404';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_ROAD'
       ,'PMS4404'
       ,'Aggregate Deflectograph Results into Bands'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_ROAD_REPORTS'
  AND  HSTF_CHILD = 'PMS4440';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_ROAD_REPORTS'
       ,'PMS4440'
       ,'Road Condition Report'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_'
  AND  HSTF_CHILD = 'PMS4448';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_'
       ,'PMS4448'
       ,'Machine Survey Results'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_ROAD_REPORTS'
  AND  HSTF_CHILD = 'PMS4442';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_ROAD_REPORTS'
       ,'PMS4442'
       ,'March Treatment Costs'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_ROAD_REPORTS'
  AND  HSTF_CHILD = 'PMS4444';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_ROAD_REPORTS'
       ,'PMS4444'
       ,'Deflectograph Summary by Admin Unit'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_SCHEME'
  AND  HSTF_CHILD = 'PMS4400';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_SCHEME'
       ,'PMS4400'
       ,'Structural Schemes'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_SCHEME'
  AND  HSTF_CHILD = 'PMS4402';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_SCHEME'
       ,'PMS4402'
       ,'Allocate Priorities to Schemes'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_SCHEME'
  AND  HSTF_CHILD = 'PMS4406';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_SCHEME'
       ,'PMS4406'
       ,'Delete Structural Schemes'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_SCHEME_REPORTS'
  AND  HSTF_CHILD = 'PMS4410';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_SCHEME_REPORTS'
       ,'PMS4410'
       ,'List of Structural Schemes'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS'
  AND  HSTF_CHILD = 'PMS_ROAD';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS'
       ,'PMS_ROAD'
       ,'Road Condition'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS'
  AND  HSTF_CHILD = 'PMS_SCHEME';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS'
       ,'PMS_SCHEME'
       ,'Scheme Manager'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS'
  AND  HSTF_CHILD = 'PMS_LOADERS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS'
       ,'PMS_LOADERS'
       ,'Loaders'
       ,'F'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS'
  AND  HSTF_CHILD = 'PMS_REFERENCE';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS'
       ,'PMS_REFERENCE'
       ,'Reference'
       ,'F'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_ROAD'
  AND  HSTF_CHILD = 'MAI2310A';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_ROAD'
       ,'MAI2310A'
       ,'View Condition Data'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_ROAD'
  AND  HSTF_CHILD = 'PMS_ROAD_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_ROAD'
       ,'PMS_ROAD_REPORTS'
       ,'Reports'
       ,'F'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_ROAD_REPORTS'
  AND  HSTF_CHILD = 'MAI7040';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_ROAD_REPORTS'
       ,'MAI7040'
       ,'Parameter Based Inquiry (PBI)'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_SCHEME'
  AND  HSTF_CHILD = 'PMS_SCHEME_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_SCHEME'
       ,'PMS_SCHEME_REPORTS'
       ,'Reports'
       ,'F'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_LOADERS'
  AND  HSTF_CHILD = 'MAI2100C';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_LOADERS'
       ,'MAI2100C'
       ,'Inventory Loader (Part 1)'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_LOADERS'
  AND  HSTF_CHILD = 'MAI2110C';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_LOADERS'
       ,'MAI2110C'
       ,'Inventory Loader (Part 2)'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_LOADERS'
  AND  HSTF_CHILD = 'MAI2120';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_LOADERS'
       ,'MAI2120'
       ,'Correct Inventory Load Errors'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_REFERENCE'
  AND  HSTF_CHILD = 'MAI3886';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_REFERENCE'
       ,'MAI3886'
       ,'Standard Item Sections and Sub-Sections'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_REFERENCE'
  AND  HSTF_CHILD = 'MAI3881';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_REFERENCE'
       ,'MAI3881'
       ,'Contractors'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_REFERENCE'
  AND  HSTF_CHILD = 'MAI1400';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_REFERENCE'
       ,'MAI1400'
       ,'Inventory Control Data'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_REFERENCE'
  AND  HSTF_CHILD = 'MAI1920';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_REFERENCE'
       ,'MAI1920'
       ,'Inventory XSPs'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_REFERENCE'
  AND  HSTF_CHILD = 'MAI1910';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_REFERENCE'
       ,'MAI1910'
       ,'XSP Values'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PMS_REFERENCE'
  AND  HSTF_CHILD = 'MAI3664';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_REFERENCE'
       ,'MAI3664'
       ,'Financial Years'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'TM'
  AND  HSTF_CHILD = 'TM_PUBLISH';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'TM'
       ,'TM_PUBLISH'
       ,'Publish'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'TM'
  AND  HSTF_CHILD = 'TM_REFERENCE';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'TM'
       ,'TM_REFERENCE'
       ,'Reference'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'TM_PUBLISH'
  AND  HSTF_CHILD = 'TMWEB0010';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'TM_PUBLISH'
       ,'TMWEB0010'
       ,'Publish Traffic Data'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'FAVOURITES'
  AND  HSTF_CHILD = 'HIG1808';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'HIG1808'
       ,'Search'
       ,'M'
       ,50 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'TM_REFERENCE'
  AND  HSTF_CHILD = 'TM0001';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'TM_REFERENCE'
       ,'TM0001'
       ,'Traffic Manager Metadata Maintenance'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'FAVOURITES'
  AND  HSTF_CHILD = 'HIG1806';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'HIG1806'
       ,'Fastpath'
       ,'M'
       ,51 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'FAVOURITES'
  AND  HSTF_CHILD = 'HIG1833';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'HIG1833'
       ,'Change Password'
       ,'M'
       ,52 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MRWA'
  AND  HSTF_CHILD = 'MRWA_ROMAN';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MRWA'
       ,'MRWA_ROMAN'
       ,'ROMAN Interface'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MRWA'
  AND  HSTF_CHILD = 'MRWA_NETWORK_EXTRACTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MRWA'
       ,'MRWA_NETWORK_EXTRACTS'
       ,'Network Extracts'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MRWA_ROMAN'
  AND  HSTF_CHILD = 'PCUIS0010';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MRWA_ROMAN'
       ,'PCUIS0010'
       ,'File Import'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MRWA_ROMAN'
  AND  HSTF_CHILD = 'PCUIS0020';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MRWA_ROMAN'
       ,'PCUIS0020'
       ,'Network Integrity Check'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MRWA_ROMAN'
  AND  HSTF_CHILD = 'PCUIS0030';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MRWA_ROMAN'
       ,'PCUIS0030'
       ,'Inventory Replace and File Output'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MRWA_NETWORK_EXTRACTS'
  AND  HSTF_CHILD = 'CLASS0010';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MRWA_NETWORK_EXTRACTS'
       ,'CLASS0010'
       ,'Classified Roads Extract'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ENQ'
  AND  HSTF_CHILD = 'PEM_ENQ';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ENQ'
       ,'PEM_ENQ'
       ,'Public Enquiries'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PEM_ENQ'
  AND  HSTF_CHILD = 'PEM_ENQ_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_ENQ'
       ,'PEM_ENQ_REPORTS'
       ,'Reports'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'ENQ'
  AND  HSTF_CHILD = 'PEM_REF';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ENQ'
       ,'PEM_REF'
       ,'Reference Data'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PEM_ENQ'
  AND  HSTF_CHILD = 'DOC0150';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_ENQ'
       ,'DOC0150'
       ,'Public Enquiries'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PEM_ENQ_REPORTS'
  AND  HSTF_CHILD = 'DOC0166';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_ENQ_REPORTS'
       ,'DOC0166'
       ,'List of Enquiries'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PEM_ENQ_REPORTS'
  AND  HSTF_CHILD = 'DOC0160';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_ENQ_REPORTS'
       ,'DOC0160'
       ,'Enquiry Details'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PEM_ENQ_REPORTS'
  AND  HSTF_CHILD = 'DOC0162';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_ENQ_REPORTS'
       ,'DOC0162'
       ,'Enquiry Acknowledgements'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PEM_ENQ_REPORTS'
  AND  HSTF_CHILD = 'DOC0164';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_ENQ_REPORTS'
       ,'DOC0164'
       ,'Summary of Enquiries by Status'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PEM_ENQ_REPORTS'
  AND  HSTF_CHILD = 'DOC0165';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_ENQ_REPORTS'
       ,'DOC0165'
       ,'Summary of Complaints by Type'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PEM_ENQ_REPORTS'
  AND  HSTF_CHILD = 'DOC0205';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_ENQ_REPORTS'
       ,'DOC0205'
       ,'Batch Complaint Printing'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PEM_ENQ_REPORTS'
  AND  HSTF_CHILD = 'DOC0167';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_ENQ_REPORTS'
       ,'DOC0167'
       ,'Enquiry Actions'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PEM_ENQ_REPORTS'
  AND  HSTF_CHILD = 'DOC0168';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_ENQ_REPORTS'
       ,'DOC0168'
       ,'Enquiry Damage'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PEM_REF'
  AND  HSTF_CHILD = 'DOC0110';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_REF'
       ,'DOC0110'
       ,'Document Types/Classes/Enquiry Types'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PEM_REF'
  AND  HSTF_CHILD = 'DOC0157';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_REF'
       ,'DOC0157'
       ,'Enquiry Redirection'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PEM_REF'
  AND  HSTF_CHILD = 'DOC0132';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_REF'
       ,'DOC0132'
       ,'Enquiry Priorities'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PEM_REF'
  AND  HSTF_CHILD = 'DOC0155';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_REF'
       ,'DOC0155'
       ,'Standard Actions'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PEM_REF'
  AND  HSTF_CHILD = 'DOC0156';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_REF'
       ,'DOC0156'
       ,'Standard Costs'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'PEM_REF'
  AND  HSTF_CHILD = 'HIG1815';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_REF'
       ,'HIG1815'
       ,'Contacts'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG'
  AND  HSTF_CHILD = 'HIG_SECURITY';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG'
       ,'HIG_SECURITY'
       ,'Security'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG'
  AND  HSTF_CHILD = 'HIG_REFERENCE';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG'
       ,'HIG_REFERENCE'
       ,'Reference Data'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG'
  AND  HSTF_CHILD = 'HIG_GRI';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG'
       ,'HIG_GRI'
       ,'GRI Data'
       ,'F'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG'
  AND  HSTF_CHILD = 'HIG_GIS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG'
       ,'HIG_GIS'
       ,'GIS Data'
       ,'F'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG'
  AND  HSTF_CHILD = 'HIG_CSV';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG'
       ,'HIG_CSV'
       ,'CSV Loader'
       ,'F'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_SECURITY'
  AND  HSTF_CHILD = 'HIG1860';
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
       ,'HIG1860'
       ,'Admin Units'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_SECURITY'
  AND  HSTF_CHILD = 'HIG1832';
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
       ,'HIG1832'
       ,'Users'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_SECURITY'
  AND  HSTF_CHILD = 'HIG1836';
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
       ,'HIG1836'
       ,'Roles'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_SECURITY'
  AND  HSTF_CHILD = 'HIG1880';
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
       ,'HIG1880'
       ,'Modules'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_SECURITY'
  AND  HSTF_CHILD = 'HIG1890';
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
       ,'HIG1890'
       ,'Products'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_SECURITY'
  AND  HSTF_CHILD = 'HIG_SECURITY_REPORTS';
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
       ,'HIG_SECURITY_REPORTS'
       ,'Reports'
       ,'F'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_SECURITY_REPORTS'
  AND  HSTF_CHILD = 'HIG1802';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_SECURITY_REPORTS'
       ,'HIG1802'
       ,'Menu Options for a User'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_SECURITY_REPORTS'
  AND  HSTF_CHILD = 'HIG1804';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_SECURITY_REPORTS'
       ,'HIG1804'
       ,'Menu Options for a Role'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_SECURITY_REPORTS'
  AND  HSTF_CHILD = 'HIG1864';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_SECURITY_REPORTS'
       ,'HIG1864'
       ,'Users Report'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_SECURITY_REPORTS'
  AND  HSTF_CHILD = 'HIG1862';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_SECURITY_REPORTS'
       ,'HIG1862'
       ,'Admin Units'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_SECURITY_REPORTS'
  AND  HSTF_CHILD = 'HIG1866';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_SECURITY_REPORTS'
       ,'HIG1866'
       ,'Users By Admin Unit'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_SECURITY_REPORTS'
  AND  HSTF_CHILD = 'HIG1868';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_SECURITY_REPORTS'
       ,'HIG1868'
       ,'User Roles'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_SECURITY_REPORTS'
  AND  HSTF_CHILD = 'HIG2100';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_SECURITY_REPORTS'
       ,'HIG2100'
       ,'Produce Database Healthcheck File'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE'
  AND  HSTF_CHILD = 'HIG9110';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG9110'
       ,'Status Codes'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE'
  AND  HSTF_CHILD = 'HIG9120';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG9120'
       ,'Domains'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE'
  AND  HSTF_CHILD = 'HIG9135';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG9135'
       ,'Product Option List'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE'
  AND  HSTF_CHILD = 'HIG9130';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG9130'
       ,'Product Options'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE'
  AND  HSTF_CHILD = 'HIG1838';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG1838'
       ,'User Options'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE'
  AND  HSTF_CHILD = 'HIG1837';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG1837'
       ,'User Option Administration'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE'
  AND  HSTF_CHILD = 'HIG1839';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG1839'
       ,'Module Keywords'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE'
  AND  HSTF_CHILD = 'HIG1881';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG1881'
       ,'Module Usages'
       ,'M'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE'
  AND  HSTF_CHILD = 'HIG1885';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG1885'
       ,'Maintain URL Modules'
       ,'M'
       ,10 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE'
  AND  HSTF_CHILD = 'HIG5000';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG5000'
       ,'Maintain Entry Points'
       ,'M'
       ,11 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE'
  AND  HSTF_CHILD = 'HIG9170';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG9170'
       ,'Holidays'
       ,'M'
       ,12 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE'
  AND  HSTF_CHILD = 'HIG9180';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG9180'
       ,'v2 Errors'
       ,'M'
       ,13 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE'
  AND  HSTF_CHILD = 'HIG9185';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG9185'
       ,'v3 Errors'
       ,'M'
       ,14 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE'
  AND  HSTF_CHILD = 'HIG1220';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG1220'
       ,'Intervals'
       ,'M'
       ,15 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE'
  AND  HSTF_CHILD = 'HIG1820';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG1820'
       ,'Units and Conversions'
       ,'M'
       ,16 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE'
  AND  HSTF_CHILD = 'HIG_REFERENCE_MAIL';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG_REFERENCE_MAIL'
       ,'Mail'
       ,'F'
       ,17 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE'
  AND  HSTF_CHILD = 'HIG_REFERENCE_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG_REFERENCE_REPORTS'
       ,'Reports'
       ,'F'
       ,18 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE_MAIL'
  AND  HSTF_CHILD = 'HIG1900';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE_MAIL'
       ,'HIG1900'
       ,'Mail Users'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE_MAIL'
  AND  HSTF_CHILD = 'HIG1901';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE_MAIL'
       ,'HIG1901'
       ,'Mail Groups'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE_MAIL'
  AND  HSTF_CHILD = 'HIGWEB1902';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE_MAIL'
       ,'HIGWEB1902'
       ,'Mail'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE_REPORTS'
  AND  HSTF_CHILD = 'HIG9125';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE_REPORTS'
       ,'HIG9125'
       ,'List of Static Reference Data'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE_REPORTS'
  AND  HSTF_CHILD = 'HIG9115';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE_REPORTS'
       ,'HIG9115'
       ,'List of Status Codes'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_GRI'
  AND  HSTF_CHILD = 'GRI0220';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_GRI'
       ,'GRI0220'
       ,'GRI Modules'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_GRI'
  AND  HSTF_CHILD = 'GRI0230';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_GRI'
       ,'GRI0230'
       ,'GRI Parameters'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_GRI'
  AND  HSTF_CHILD = 'GRI0240';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_GRI'
       ,'GRI0240'
       ,'GRI Module Parameters'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_GRI'
  AND  HSTF_CHILD = 'GRI0250';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_GRI'
       ,'GRI0250'
       ,'GRI Parameter Dependencies'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_GRI'
  AND  HSTF_CHILD = 'HIG1950';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_GRI'
       ,'HIG1950'
       ,'Discoverer API Definition'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_GRI'
  AND  HSTF_CHILD = 'HIG1850';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_GRI'
       ,'HIG1850'
       ,'Report Styles'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_GIS'
  AND  HSTF_CHILD = 'GIS0005';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_GIS'
       ,'GIS0005'
       ,'GIS Projects'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_GIS'
  AND  HSTF_CHILD = 'GIS0010';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_GIS'
       ,'GIS0010'
       ,'GIS Themes'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_CSV'
  AND  HSTF_CHILD = 'HIG2010';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_CSV'
       ,'HIG2010'
       ,'CSV Loader Destination Tables'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_CSV'
  AND  HSTF_CHILD = 'HIG2020';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_CSV'
       ,'HIG2020'
       ,'CSV Loader File Definitions Tables'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_CSV'
  AND  HSTF_CHILD = 'HIGWEB2030';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_CSV'
       ,'HIGWEB2030'
       ,'CSV File Upload'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS'
  AND  HSTF_CHILD = 'MAI3800A';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI3800A'
       ,'Works Orders (Cyclic)'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_LOADERS'
  AND  HSTF_CHILD = 'MAI_GMIS_LOADERS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS'
       ,'MAI_GMIS_LOADERS'
       ,'GMIS Interface'
       ,'F'
       ,null FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_GMIS_LOADERS'
  AND  HSTF_CHILD = 'MAI2530';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_GMIS_LOADERS'
       ,'MAI2530'
       ,'Create Route and Defect Files for GMIS Inspections'
       ,'M'
       ,10 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_GMIS_LOADERS'
  AND  HSTF_CHILD = 'MAIWEB2540';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_GMIS_LOADERS'
       ,'MAIWEB2540'
       ,'GMIS Survey File Loader'
       ,'M'
       ,11 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_GMIS_LOADERS'
  AND  HSTF_CHILD = 'MAI2550';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_GMIS_LOADERS'
       ,'MAI2550'
       ,'Correct GMIS Load File Errors'
       ,'M'
       ,12 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'FAVOURITES'
  AND  HSTF_CHILD = 'NSG';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'NSG'
       ,'Nsg Data Manager'
       ,'F'
       ,14 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NSG'
  AND  HSTF_CHILD = 'NSG_DATA';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NSG'
       ,'NSG_DATA'
       ,'Data'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NSG'
  AND  HSTF_CHILD = 'NSG_IMPORT_EXPORT';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NSG'
       ,'NSG_IMPORT_EXPORT'
       ,'Import/Export'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NSG_DATA'
  AND  HSTF_CHILD = 'NSG0030';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NSG_DATA'
       ,'NSG0030'
       ,'Cross References'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NSG_IMPORT_EXPORT'
  AND  HSTF_CHILD = 'NSG0020';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NSG_IMPORT_EXPORT'
       ,'NSG0020'
       ,'Export'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NSG_IMPORT_EXPORT'
  AND  HSTF_CHILD = 'NSG0021';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NSG_IMPORT_EXPORT'
       ,'NSG0021'
       ,'Export Log'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM'
  AND  HSTF_CHILD = 'CLM_INV';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM'
       ,'CLM_INV'
       ,'Inventory'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS'
  AND  HSTF_CHILD = 'MAI3805';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI3805'
       ,'Gang/Crew Allocation'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM'
  AND  HSTF_CHILD = 'CLM_FAULTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM'
       ,'CLM_FAULTS'
       ,'Faults'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM'
  AND  HSTF_CHILD = 'CLM_ENERGY';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM'
       ,'CLM_ENERGY'
       ,'Energy'
       ,'F'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM'
  AND  HSTF_CHILD = 'CLM_SUPER';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM'
       ,'CLM_SUPER'
       ,'Super'
       ,'F'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM'
  AND  HSTF_CHILD = 'CLM_WO';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM'
       ,'CLM_WO'
       ,'Works Order'
       ,'F'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM'
  AND  HSTF_CHILD = 'CLM_INSP';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM'
       ,'CLM_INSP'
       ,'Inspections'
       ,'F'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM'
  AND  HSTF_CHILD = 'CLM_REF';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM'
       ,'CLM_REF'
       ,'Reference'
       ,'F'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM'
  AND  HSTF_CHILD = 'CLM_ADMIN';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM'
       ,'CLM_ADMIN'
       ,'Administration'
       ,'F'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_ADMIN'
  AND  HSTF_CHILD = 'CLM0003';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_ADMIN'
       ,'CLM0003'
       ,'System Definitions'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_ENERGY'
  AND  HSTF_CHILD = 'CLM1000';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_ENERGY'
       ,'CLM1000'
       ,'Energy Rental Charges'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_ENERGY_REPORTS'
  AND  HSTF_CHILD = 'CLM1010';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_ENERGY_REPORTS'
       ,'CLM1010'
       ,'Energy Account By Parish Report'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_INV'
  AND  HSTF_CHILD = 'CLM1030';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_INV'
       ,'CLM1030'
       ,'Create Lighting Schemes'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_FAULTS'
  AND  HSTF_CHILD = 'CLM1040';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_FAULTS'
       ,'CLM1040'
       ,'Record Faults'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_FAULTS_REP'
  AND  HSTF_CHILD = 'CLM1052';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_FAULTS_REP'
       ,'CLM1052'
       ,'Report and Status Change'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_FAULTS_REP'
  AND  HSTF_CHILD = 'CLM1053';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_FAULTS_REP'
       ,'CLM1053'
       ,'List Completed/Outstanding Faults'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_FAULTS_REP'
  AND  HSTF_CHILD = 'CLM1054';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_FAULTS_REP'
       ,'CLM1054'
       ,'Outstanding Fault Statistics'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_FAULTS_REP'
  AND  HSTF_CHILD = 'CLM1057';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_FAULTS_REP'
       ,'CLM1057'
       ,'Summary of Faults to Maintenance Contractor'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_FAULTS'
  AND  HSTF_CHILD = 'CLM1058';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_FAULTS'
       ,'CLM1058'
       ,'Reset Faults'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_INV_REP'
  AND  HSTF_CHILD = 'CLM1080';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_INV_REP'
       ,'CLM1080'
       ,'Inventory Report'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_ENERGY'
  AND  HSTF_CHILD = 'CLM1090';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_ENERGY'
       ,'CLM1090'
       ,'Inventory Summary'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_ENERGY_REPORTS'
  AND  HSTF_CHILD = 'CLM1091';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_ENERGY_REPORTS'
       ,'CLM1091'
       ,'Inventory Summary Report'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_INV'
  AND  HSTF_CHILD = 'CLM1100';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_INV'
       ,'CLM1100'
       ,'Locate Units'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_INV_REP'
  AND  HSTF_CHILD = 'CLM1110';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_INV_REP'
       ,'CLM1110'
       ,'Lamp Types Report'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_INV_REP'
  AND  HSTF_CHILD = 'CLM1120';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_INV_REP'
       ,'CLM1120'
       ,'Group Control Report'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_INV'
  AND  HSTF_CHILD = 'CLM1130';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_INV'
       ,'CLM1130'
       ,'Contractor Modifications'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_STREETS'
  AND  HSTF_CHILD = 'CLM1132';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_STREETS'
       ,'CLM1132'
       ,'Parishes'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_STATIC'
  AND  HSTF_CHILD = 'CLM1140';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_STATIC'
       ,'CLM1140'
       ,'Static Data'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_ENERGY_REPORTS'
  AND  HSTF_CHILD = 'CLM1150';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_ENERGY_REPORTS'
       ,'CLM1150'
       ,'Energy Budget Recharge Report'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_SUPER'
  AND  HSTF_CHILD = 'CLM1170';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_SUPER'
       ,'CLM1170'
       ,'Supervisor Unit Update'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_INV'
  AND  HSTF_CHILD = 'CLM1180';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_INV'
       ,'CLM1180'
       ,'Unit Details'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_INV_REP'
  AND  HSTF_CHILD = 'CLM1190';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_INV_REP'
       ,'CLM1190'
       ,'Scheme Details'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_REP'
  AND  HSTF_CHILD = 'CLM1210';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_REP'
       ,'CLM1210'
       ,'Valid Codes'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_STREETS'
  AND  HSTF_CHILD = 'CLM1220';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_STREETS'
       ,'CLM1220'
       ,'Street Gazetteer'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_STREETS'
  AND  HSTF_CHILD = 'CLM1221';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_STREETS'
       ,'CLM1221'
       ,'Street Routes'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_STREETS'
  AND  HSTF_CHILD = 'CLM1222';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_STREETS'
       ,'CLM1222'
       ,'Street Sensitivities'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_STREETS'
  AND  HSTF_CHILD = 'CLM1230';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_STREETS'
       ,'CLM1230'
       ,'Street Divisions'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_STREETS'
  AND  HSTF_CHILD = 'CLM1240';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_STREETS'
       ,'CLM1240'
       ,'Street Aliases'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_WO'
  AND  HSTF_CHILD = 'CLM1260';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_WO'
       ,'CLM1260'
       ,'Print Work Order Detail'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_WO'
  AND  HSTF_CHILD = 'CLM1261';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_WO'
       ,'CLM1261'
       ,'Work Order Lamp Summary'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_WO'
  AND  HSTF_CHILD = 'CLM1265';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_WO'
       ,'CLM1265'
       ,'Print Error Codes'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_WO'
  AND  HSTF_CHILD = 'CLM1280';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_WO'
       ,'CLM1280'
       ,'Maintenance Scheduler'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_WO'
  AND  HSTF_CHILD = 'CLM1281';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_WO'
       ,'CLM1281'
       ,'Work Orders'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_FAULTS'
  AND  HSTF_CHILD = 'CLM1282';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_FAULTS'
       ,'CLM1282'
       ,'View Unit History'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_CTR'
  AND  HSTF_CHILD = 'CLM1300';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_CTR'
       ,'CLM1300'
       ,'Contract Sub Section'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_CTR'
  AND  HSTF_CHILD = 'CLM1330';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_CTR'
       ,'CLM1330'
       ,'Contract Items'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_CTR'
  AND  HSTF_CHILD = 'CLM1340';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_CTR'
       ,'CLM1340'
       ,'Contract Item Rates'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_CTR'
  AND  HSTF_CHILD = 'CLM1350';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_CTR'
       ,'CLM1350'
       ,'Repair Codes'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_FAULTS'
  AND  HSTF_CHILD = 'CLM1360';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_FAULTS'
       ,'CLM1360'
       ,'Fault Repairs'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_CTR'
  AND  HSTF_CHILD = 'CLM1370';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_CTR'
       ,'CLM1370'
       ,'Activity Codes'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_CTR'
  AND  HSTF_CHILD = 'CLM1385';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_CTR'
       ,'CLM1385'
       ,'Contract Priorities'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_ORGS'
  AND  HSTF_CHILD = 'CLM1500';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_ORGS'
       ,'CLM1500'
       ,'Organisation Details'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_ORGS'
  AND  HSTF_CHILD = 'CLM1505';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_ORGS'
       ,'CLM1505'
       ,'Contractors'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_ORGS'
  AND  HSTF_CHILD = 'CLM1510';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_ORGS'
       ,'CLM1510'
       ,'Persons'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_ORGS'
  AND  HSTF_CHILD = 'CLM1515';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_ORGS'
       ,'CLM1515'
       ,'Contractor Users'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_ORGS'
  AND  HSTF_CHILD = 'CLM1540';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_ORGS'
       ,'CLM1540'
       ,'Unit Managers'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_INV'
  AND  HSTF_CHILD = 'CLM1592';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_INV'
       ,'CLM1592'
       ,'Wayleave'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_FIN'
  AND  HSTF_CHILD = 'CLM1593';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_FIN'
       ,'CLM1593'
       ,'Financial Years'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_FIN'
  AND  HSTF_CHILD = 'CLM1594';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_FIN'
       ,'CLM1594'
       ,'Budgets'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_INV'
  AND  HSTF_CHILD = 'CLM1597';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_INV'
       ,'CLM1597'
       ,'Update Maintenance Contractor'
       ,'M'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_INV'
  AND  HSTF_CHILD = 'CLM1201';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_INV'
       ,'CLM1201'
       ,'View End Dated Units'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_INSP'
  AND  HSTF_CHILD = 'CLM2010';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_INSP'
       ,'CLM2010'
       ,'Inspection Domains'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_INSP'
  AND  HSTF_CHILD = 'CLM2020';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_INSP'
       ,'CLM2020'
       ,'Inspectable Components'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_INSP'
  AND  HSTF_CHILD = 'CLM2030';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_INSP'
       ,'CLM2030'
       ,'Inspections'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_WO'
  AND  HSTF_CHILD = 'CLM1262';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_WO'
       ,'CLM1262'
       ,'Print Work Order Summary'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_WO'
  AND  HSTF_CHILD = 'CLM1279';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_WO'
       ,'CLM1279'
       ,'Maintainence Schedule Calendar'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_FIN'
  AND  HSTF_CHILD = 'CLM1595';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_FIN'
       ,'CLM1595'
       ,'Budget Status Definitions'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_FIN'
  AND  HSTF_CHILD = 'CLM1598';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_FIN'
       ,'CLM1598'
       ,'Fault Committment Amounts'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_FIN'
  AND  HSTF_CHILD = 'CLM1599';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_FIN'
       ,'CLM1599'
       ,'Fault Budget Template Codes'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_FIN'
  AND  HSTF_CHILD = 'CLM1600';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_FIN'
       ,'CLM1600'
       ,'Payment Run'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_FIN_REP'
  AND  HSTF_CHILD = 'CLM1601';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_FIN_REP'
       ,'CLM1601'
       ,'Budget Status Report'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_ENERGY_REPORTS'
  AND  HSTF_CHILD = 'CLM1602';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_ENERGY_REPORTS'
       ,'CLM1602'
       ,'Invalid Energy Budget Codes Report'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_INV'
  AND  HSTF_CHILD = 'CLM1603';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_INV'
       ,'CLM1603'
       ,'Defect Report'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_FAULTS'
  AND  HSTF_CHILD = 'CLM1604';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_FAULTS'
       ,'CLM1604'
       ,'Inspection Fault Input'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_INV'
  AND  HSTF_CHILD = 'CLM1605';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_INV'
       ,'CLM1605'
       ,'Move Units Facility'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_ENERGY'
  AND  HSTF_CHILD = 'CLM2050';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_ENERGY'
       ,'CLM2050'
       ,'Energy Extract'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_INV'
  AND  HSTF_CHILD = 'CLM_INV_REP';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_INV'
       ,'CLM_INV_REP'
       ,'Inventory Reports'
       ,'F'
       ,11 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_FAULTS'
  AND  HSTF_CHILD = 'CLM_FAULTS_REP';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_FAULTS'
       ,'CLM_FAULTS_REP'
       ,'Fault Reports'
       ,'F'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_ENERGY'
  AND  HSTF_CHILD = 'CLM_ENERGY_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_ENERGY'
       ,'CLM_ENERGY_REPORTS'
       ,'Energy Reports'
       ,'F'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF'
  AND  HSTF_CHILD = 'CLM_REF_STREETS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF'
       ,'CLM_REF_STREETS'
       ,'Streets'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF'
  AND  HSTF_CHILD = 'CLM_REF_ORGS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF'
       ,'CLM_REF_ORGS'
       ,'Organisations'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF'
  AND  HSTF_CHILD = 'CLM_REF_STATIC';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF'
       ,'CLM_REF_STATIC'
       ,'Static Data'
       ,'F'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF'
  AND  HSTF_CHILD = 'CLM_REF_CTR';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF'
       ,'CLM_REF_CTR'
       ,'Contracts'
       ,'F'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF'
  AND  HSTF_CHILD = 'CLM_REF_FIN';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF'
       ,'CLM_REF_FIN'
       ,'Financial'
       ,'F'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF'
  AND  HSTF_CHILD = 'CLM_REF_REP';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF'
       ,'CLM_REF_REP'
       ,'Reference Reports'
       ,'F'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'CLM_REF_FIN'
  AND  HSTF_CHILD = 'CLM_REF_FIN_REP';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'CLM_REF_FIN'
       ,'CLM_REF_FIN_REP'
       ,'Budget Reporting'
       ,'F'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE_MAIL'
  AND  HSTF_CHILD = 'HIG1903';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE_MAIL'
       ,'HIG1903'
       ,'Mail Message Administration'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
  AND  HSTF_CHILD = 'MAI3918';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3918'
       ,'Works Orders (Enhanced Format)'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'NET_REF'
  AND  HSTF_CHILD = 'NM0700';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_REF'
       ,'NM0700'
       ,'Maintain AD Types'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'FAVOURITES'
  AND  HSTF_CHILD = 'UKP';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'UKP'
       ,'UKPMS'
       ,'F'
       ,15 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP'
  AND  HSTF_CHILD = 'UKP_LOAD_DATA';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP'
       ,'UKP_LOAD_DATA'
       ,'Load Data'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP'
  AND  HSTF_CHILD = 'UKP_MAINTAIN_DATA';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP'
       ,'UKP_MAINTAIN_DATA'
       ,'Maintain Data'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP'
  AND  HSTF_CHILD = 'UKP_PROCESS_DATA';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP'
       ,'UKP_PROCESS_DATA'
       ,'Process Data'
       ,'F'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP'
  AND  HSTF_CHILD = 'UKP_REFERENCE_DATA';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP'
       ,'UKP_REFERENCE_DATA'
       ,'Reference Data'
       ,'F'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_LOAD_DATA'
  AND  HSTF_CHILD = 'UKP036';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_LOAD_DATA'
       ,'UKP036'
       ,'UKPMS TRACS HMDIF Preprocessor'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_REFERENCE_DATA'
  AND  HSTF_CHILD = 'UKP0007';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_REFERENCE_DATA'
       ,'UKP0007'
       ,'Maintain Treatment Composition'
       ,'M'
       ,12 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_LOAD_DATA'
  AND  HSTF_CHILD = 'UKP030';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_LOAD_DATA'
       ,'UKP030'
       ,'UKPMS Inventory HMDIF Preprocessor'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_LOAD_DATA'
  AND  HSTF_CHILD = 'UKP032';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_LOAD_DATA'
       ,'UKP032'
       ,'UKPMS Condition HMDIF Preprocessor'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_LOAD_DATA'
  AND  HSTF_CHILD = 'UKP031';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_LOAD_DATA'
       ,'UKP031'
       ,'UKPMS Deflectograph HMDIF Preprocessor'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_LOAD_DATA'
  AND  HSTF_CHILD = 'UKP034';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_LOAD_DATA'
       ,'UKP034'
       ,'UKPMS SCRIM/HRM HMDIF Preprocessor'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_LOAD_DATA'
  AND  HSTF_CHILD = 'MAI2100C';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_LOAD_DATA'
       ,'MAI2100C'
       ,'Load Inventory - Stage 1'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_LOAD_DATA'
  AND  HSTF_CHILD = 'MAI2110C';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_LOAD_DATA'
       ,'MAI2110C'
       ,'Load Inventory - Stage 2'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_LOAD_DATA'
  AND  HSTF_CHILD = 'MAI2120';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_LOAD_DATA'
       ,'MAI2120'
       ,'Correct Inventory Load Errors'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_LOAD_DATA'
  AND  HSTF_CHILD = 'MAI5090';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_LOAD_DATA'
       ,'MAI5090'
       ,'Remove Successfully Loaded Inventory Batches'||CHR(10)||''
       ,'M'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_MAINTAIN_DATA'
  AND  HSTF_CHILD = 'MAI2310';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_MAINTAIN_DATA'
       ,'MAI2310'
       ,'Inventory'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_MAINTAIN_DATA'
  AND  HSTF_CHILD = 'MAI2140';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_MAINTAIN_DATA'
       ,'MAI2140'
       ,'Query Network/Inventory Data'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_MAINTAIN_DATA'
  AND  HSTF_CHILD = 'MAI2130';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_MAINTAIN_DATA'
       ,'MAI2130'
       ,'Delete Global Inventory'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_PROCESS_DATA'
  AND  HSTF_CHILD = 'UKP0003';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_PROCESS_DATA'
       ,'UKP0003'
       ,'Automatic Pass'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_PROCESS_DATA'
  AND  HSTF_CHILD = 'UKP0006';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_PROCESS_DATA'
       ,'UKP0006'
       ,'Maintain Budgets'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_PROCESS_DATA'
  AND  HSTF_CHILD = 'UKP0008';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_PROCESS_DATA'
       ,'UKP0008'
       ,'Maintain Treatment Unit Costs'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_PROCESS_DATA'
  AND  HSTF_CHILD = 'UKP_PROC_REPORTS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_PROCESS_DATA'
       ,'UKP_PROC_REPORTS'
       ,'Reports'
       ,'F'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_PROC_REPORTS'
  AND  HSTF_CHILD = 'UKP0011';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_PROC_REPORTS'
       ,'UKP0011'
       ,'Condition Indices Report'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_PROC_REPORTS'
  AND  HSTF_CHILD = 'UKP0016';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_PROC_REPORTS'
       ,'UKP0016'
       ,'Official Condition Indices Report'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_PROC_REPORTS'
  AND  HSTF_CHILD = 'UKP0017';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_PROC_REPORTS'
       ,'UKP0017'
       ,'Non Principal Condition Indices Report'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_PROC_REPORTS'
  AND  HSTF_CHILD = 'UKP0018';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_PROC_REPORTS'
       ,'UKP0018'
       ,'BVPI187 Footway Performance Indicator Report'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_PROC_REPORTS'
  AND  HSTF_CHILD = 'UKP0015';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_PROC_REPORTS'
       ,'UKP0015'
       ,'Defect Lengths Report'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_PROC_REPORTS'
  AND  HSTF_CHILD = 'UKP0012';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_PROC_REPORTS'
       ,'UKP0012'
       ,'Detailed Analysis of Budget Heads'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_PROC_REPORTS'
  AND  HSTF_CHILD = 'UKP0013';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_PROC_REPORTS'
       ,'UKP0013'
       ,'Summary Analysis of Budget Heads'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_PROC_REPORTS'
  AND  HSTF_CHILD = 'UKP0014';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_PROC_REPORTS'
       ,'UKP0014'
       ,'Detailed Analysis of Budget Sections'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_PROC_REPORTS'
  AND  HSTF_CHILD = 'UKP0095';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_PROC_REPORTS'
       ,'UKP0095'
       ,'Unsurveyed Network'
       ,'M'
       ,10 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_REFERENCE_DATA'
  AND  HSTF_CHILD = 'MAI1400';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_REFERENCE_DATA'
       ,'MAI1400'
       ,'Inventory Control Data'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_REFERENCE_DATA'
  AND  HSTF_CHILD = 'MAI1410';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_REFERENCE_DATA'
       ,'MAI1410'
       ,'Inventory Security'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_REFERENCE_DATA'
  AND  HSTF_CHILD = 'MAI1920';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_REFERENCE_DATA'
       ,'MAI1920'
       ,'Inventory XSPs'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_REFERENCE_DATA'
  AND  HSTF_CHILD = 'MAI1910';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_REFERENCE_DATA'
       ,'MAI1910'
       ,'XSP Values'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_REFERENCE_DATA'
  AND  HSTF_CHILD = 'UKP0009';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_REFERENCE_DATA'
       ,'UKP0009'
       ,'RMMS XSP Mapping To UKPMS XSP'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_REFERENCE_DATA'
  AND  HSTF_CHILD = 'UKP0005';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_REFERENCE_DATA'
       ,'UKP0005'
       ,'Maintain Rule Set'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_REFERENCE_DATA'
  AND  HSTF_CHILD = 'UKP0002';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_REFERENCE_DATA'
       ,'UKP0002'
       ,'Maintain Treatment Composition/SISS'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_REFERENCE_DATA'
  AND  HSTF_CHILD = 'UKP0020';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_REFERENCE_DATA'
       ,'UKP0020'
       ,'Inventory Load Tolerances'
       ,'M'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_REFERENCE_DATA'
  AND  HSTF_CHILD = 'UKP0021';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_REFERENCE_DATA'
       ,'UKP0021'
       ,'Intervention Level Hierarchy'
       ,'M'
       ,10 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_REFERENCE_DATA'
  AND  HSTF_CHILD = 'UKP0023';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_REFERENCE_DATA'
       ,'UKP0023'
       ,'Local Weighting Maintenance'
       ,'M'
       ,11 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_REFERENCE_DATA'
  AND  HSTF_CHILD = 'UKP0050';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_REFERENCE_DATA'
       ,'UKP0050'
       ,'Create UKPMS Inventory Types'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'UKP_PROC_REPORTS'
  AND  HSTF_CHILD = 'UKP0019';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_PROC_REPORTS'
       ,'UKP0019'
       ,'TTS BV96 Condition of Principal Roads'
       ,'M'
       ,9 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
  AND  HSTF_CHILD = 'MAI3630';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI3630'
       ,'Budget Allocations'
       ,'M'
       ,11 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
  AND  HSTF_CHILD = 'MAI3632';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI3632'
       ,'Asset Activities'
       ,'M'
       ,10 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE_MAIL'
  AND  HSTF_CHILD = 'HIG1910';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE_MAIL'
       ,'HIG1910'
       ,'POP3 Mail Server Definition'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE_MAIL'
  AND  HSTF_CHILD = 'HIG1911';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE_MAIL'
       ,'HIG1911'
       ,'POP3 Mail Message View'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE_MAIL'
  AND  HSTF_CHILD = 'HIG1912';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE_MAIL'
       ,'HIG1912'
       ,'POP3 Mail Processing Rules'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_REFERENCE_MAIL'
  AND  HSTF_CHILD = 'NM0572';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE_MAIL'
       ,'NM0572'
       ,'Locator'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'FAVOURITES'
  AND  HSTF_CHILD = 'AST';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'AST'
       ,'Asset Manager'
       ,'F'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'AST'
  AND  HSTF_CHILD = 'AST_REF';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'AST'
       ,'AST_REF'
       ,'Asset Reference Data'
       ,'F'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'AST'
  AND  HSTF_CHILD = 'NET_QUERIES';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'AST'
       ,'NET_QUERIES'
       ,'Asset Queries'
       ,'F'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'AST'
  AND  HSTF_CHILD = 'NET_INVENTORY';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'AST'
       ,'NET_INVENTORY'
       ,'Asset Management'
       ,'F'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'AST_REF'
  AND  HSTF_CHILD = 'NM0415';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'AST_REF'
       ,'NM0415'
       ,'Inventory Attribute Sets'
       ,'M'
       ,4 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'AST_REF'
  AND  HSTF_CHILD = 'NM0411';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'AST_REF'
       ,'NM0411'
       ,'Inventory Exclusive View Creation'
       ,'M'
       ,3 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'AST_REF'
  AND  HSTF_CHILD = 'NM0551';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'AST_REF'
       ,'NM0551'
       ,'Cross Item Validation Setup'
       ,'M'
       ,8 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'AST_REF'
  AND  HSTF_CHILD = 'NM0550';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'AST_REF'
       ,'NM0550'
       ,'Cross Attribute Validation Setup'
       ,'M'
       ,7 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'AST_REF'
  AND  HSTF_CHILD = 'NM0410';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'AST_REF'
       ,'NM0410'
       ,'Inventory Metamodel'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'AST_REF'
  AND  HSTF_CHILD = 'NM0306';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'AST_REF'
       ,'NM0306'
       ,'Asset XSPs'
       ,'M'
       ,6 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'AST_REF'
  AND  HSTF_CHILD = 'NM0305';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'AST_REF'
       ,'NM0305'
       ,'XSP and Reversal Rules'
       ,'M'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'AST_REF'
  AND  HSTF_CHILD = 'NM0301';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'AST_REF'
       ,'NM0301'
       ,'Asset Domains'
       ,'M'
       ,1 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG'
  AND  HSTF_CHILD = 'HIG_JOBS';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG'
       ,'HIG_JOBS'
       ,'Jobs'
       ,'F'
       ,5 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_JOBS'
  AND  HSTF_CHILD = 'NM3010';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_JOBS'
       ,'NM3010'
       ,'Job Operations'
       ,'M'
       ,2 FROM DUAL;
--
DELETE FROM HIG_STANDARD_FAVOURITES
 WHERE HSTF_PARENT = 'HIG_JOBS'
  AND  HSTF_CHILD = 'NM3020';
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_JOBS'
       ,'NM3020'
       ,'Job Types'
       ,'M'
       ,1 FROM DUAL;
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
