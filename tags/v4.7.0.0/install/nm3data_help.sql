-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3data_help.sql-arc   2.9   Jul 04 2013 14:08:58   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3data_help.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:08:58  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:18  $
--       Version          : $Revision:   2.9  $
--       Table Owner      : NM3_METADATA
--       Generation Date  : 25-MAR-2011 09:31
--
--   Product metadata script
--   As at Release 4.4.0.0
--
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
--
--   TABLES PROCESSED
--   ================
--   HIG_WEB_CONTXT_HLP
--
-----------------------------------------------------------------------------


set define off;
set feedback off;

--------------------
-- PRE-PROCESSING --
--------------------
delete from hig_web_contxt_hlp;


---------------------------------
-- START OF GENERATED METADATA --
---------------------------------


----------------------------------------------------------------------------------------
-- HIG_WEB_CONTXT_HLP
--
-- select * from nm3_metadata.hig_web_contxt_hlp
-- order by hwch_art_id
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT hig_web_contxt_hlp
SET TERM OFF

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
       ,'AST'
       ,''
       ,''
       ,''
       ,'/ast/WebHelp/ast.htm' FROM DUAL;
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
       ,'AVM'
       ,''
       ,''
       ,''
       ,'/avm/WebHelp/avm.htm' FROM DUAL;
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
       ,'DOC'
       ,''
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm' FROM DUAL;
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
       ,'ENQWT'
       ,''
       ,''
       ,''
       ,'/enqwt/WebHelp/enqwt.htm' FROM DUAL;
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
       ,'HAI'
       ,''
       ,''
       ,''
       ,'/hai/WebHelp/hai.htm' FROM DUAL;
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
       ,'HIG'
       ,''
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm' FROM DUAL;
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
       ,'IM'
       ,''
       ,''
       ,''
       ,'/im/WebHelp/im.htm' FROM DUAL;
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
       ,'IMF'
       ,''
       ,''
       ,''
       ,'/imf/WebHelp/imf.htm' FROM DUAL;
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
       ,'MAI'
       ,''
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm' FROM DUAL;
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
       ,'MCP'
       ,''
       ,''
       ,''
       ,'/mcp/WebHelp/mcp.htm' FROM DUAL;
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
       ,'MRWA'
       ,''
       ,''
       ,''
       ,'/mrwa/WebHelp/mrwa.htm' FROM DUAL;
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
       ,'NET'
       ,''
       ,''
       ,''
       ,'/net/WebHelp/net.htm' FROM DUAL;
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
       ,'NSG'
       ,''
       ,''
       ,''
       ,'/nsg/WebHelp/nsg.htm' FROM DUAL;
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
       ,'ENQ'
       ,''
       ,''
       ,''
       ,'/pem/WebHelp/enq.htm' FROM DUAL;
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
       ,'PLA'
       ,''
       ,''
       ,''
       ,'/pla/WebHelp/pla.htm' FROM DUAL;
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
       ,'PMS'
       ,''
       ,''
       ,''
       ,'/pms/WebHelp/pms.htm' FROM DUAL;
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
       ,'PROW'
       ,''
       ,''
       ,''
       ,'/prow/WebHelp/prow.htm' FROM DUAL;
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
       ,'SAF'
       ,''
       ,''
       ,''
       ,'/saf/WebHelp/saf.htm' FROM DUAL;
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
       ,'SCH'
       ,''
       ,''
       ,''
       ,'/sch/WebHelp/sch.htm' FROM DUAL;
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
       ,'CLM'
       ,''
       ,''
       ,''
       ,'/slm/WebHelp/clm.htm' FROM DUAL;
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
       ,'STP'
       ,''
       ,''
       ,''
       ,'/stp/WebHelp/stp.htm' FROM DUAL;
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
       ,'STR'
       ,''
       ,''
       ,''
       ,'/str/WebHelp/str.htm' FROM DUAL;
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
       ,'SWR'
       ,''
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm' FROM DUAL;
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
       ,'TM'
       ,''
       ,''
       ,''
       ,'/tm/WebHelp/tm.htm' FROM DUAL;
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
       ,'TMA'
       ,''
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm' FROM DUAL;
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
       ,'TMA_PR'
       ,''
       ,''
       ,''
       ,'/tma_pr/WebHelp/tma_pr.htm' FROM DUAL;
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
       ,'UKP'
       ,''
       ,''
       ,''
       ,'/ukp/WebHelp/ukp.htm' FROM DUAL;
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
       ,'USR'
       ,''
       ,''
       ,''
       ,'/usr/WebHelp/usr.htm' FROM DUAL;
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
       ,'WMP'
       ,''
       ,''
       ,''
       ,'/wmp/WebHelp/wmp.htm' FROM DUAL;
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
       ,'WOWT'
       ,''
       ,''
       ,''
       ,'/wowt/WebHelp/wowt.htm' FROM DUAL;
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
       ,'AVM'
       ,'VM1020'
       ,''
       ,''
       ,'/avm/WebHelp/avm.htm#avmasset_register_types__vm1020.htm' FROM DUAL;
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
       ,'AVM'
       ,'VM1030'
       ,''
       ,''
       ,'/avm/WebHelp/avm.htm#avmasset_registers__vm1030.htm' FROM DUAL;
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
       ,'AVM'
       ,'VM1050'
       ,''
       ,''
       ,'/avm/WebHelp/avm.htm#avmasset_valuation_report__vm1050.htm' FROM DUAL;
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
       ,'AVM'
       ,'VM1010'
       ,''
       ,''
       ,'/avm/WebHelp/avm.htm#avmasset_valuation_rule_sets__vm101.htm' FROM DUAL;
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
       ,'AVM'
       ,'VM1040'
       ,''
       ,''
       ,'/avm/WebHelp/avm.htm#avmasset_valuations__vm1040.htm' FROM DUAL;
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
       ,'AVM'
       ,'VM1044'
       ,''
       ,''
       ,'/avm/WebHelp/avm.htm#avmclose_valuation__vm1044.htm' FROM DUAL;
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
       ,'AVM'
       ,'VM1060'
       ,''
       ,''
       ,'/avm/WebHelp/avm.htm#avmvaluation_report_definitions__vm.htm' FROM DUAL;
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
       ,'AVM'
       ,'VM1054'
       ,''
       ,''
       ,'/avm/WebHelp/avm.htm#avmvaluation_ruleset_report__vm1054.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0150'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docenquiries__doc0150.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0166'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docenquiry_list__doc0166.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0160'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docenquiry_details__doc0160.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0162'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docacknowledgements__doc0162.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0164'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docsummary_by_status__doc0164.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0165'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docsummary_by_type__doc0165.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0205'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docbatch_enquiry_printing__doc0205.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0167'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docoutstanding_enquiry_actions__doc.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG1815'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#doccontacts__hig1815.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0157'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docenquiry_redirection_and_prioriti.htm' FROM DUAL;
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
       ,'HIG'
       ,'DOC0156'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docenquiry_standard_costs_doc0156.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI1325'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docenquirydefect_priorities__mai132.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI1320'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docenquirytreatment_types__mai1320.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG1840'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higuser_preferences__hig1840.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG1880'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higmodules__hig1880.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG9135'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higproduct_option_list__hig9135.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG1860'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higadmin_units__hig1860.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG1833'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higchange_password__hig1833.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG2010'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higcsv_loader_destination_table__hi.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG2020'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higcsv_loader_file_definitions_tabl.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG9150'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higdiscoverer_api_definition__hig91.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG9120'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higdomains__hig9120.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG1807'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higlaunchpad__favourites.htm' FROM DUAL;
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
       ,'HIG'
       ,'GRI0240'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higgri_module_parameters__gri0240.htm' FROM DUAL;
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
       ,'HIG'
       ,'GRI0220'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higgri_modules__gri0220.htm' FROM DUAL;
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
       ,'HIG'
       ,'GRI0250'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higgri_parameter_dependencies__gri0.htm' FROM DUAL;
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
       ,'HIG'
       ,'GRI0230'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higgri_parameters__gri0230.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIGWEB2030'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higloadprocess_data__higweb2030.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG9130'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#highig9130__product_options.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG1890'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higproducts__hig1890.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG1850'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higreport_styles__hig1850.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG1836'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higroles__hig1836.htm' FROM DUAL;
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
       ,'HIG'
       ,'GIS0010'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higthemes__gis0010.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG1820'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higunits_and_conversions__hig1820.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG1837'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higuser_option_administration__hig1.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG1832'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higusers__hig1832.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG9185'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higv3_errors__hig9185.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI2500'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maidownload_inventory_survey_data_t.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI2224'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maidownload_network_data_for_dcd_in.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI2220'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maidownload_static_reference_data_f.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI2222'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maidownload_standard_item_data_for_.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3863'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maidownload_inspections_by_assets__.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3630'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maibudget_allocations__mai3630.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI2200C'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiload_bulk_inspection_dat00000088.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI2200D'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiload_bulk_inspection_dat00000089.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI2250'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maicorrect_inspection_load_errors__.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3900'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiinspection_report__mai3900.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI5027'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maidefects_by_defect_type__mai5027.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3902'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maidefect_details__mai3902.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3470'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maidefect_details_works_order__mai3.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI5100'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maidefect_details_ataglance__mai510.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI5125'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maidefect_details_strip_plan__mai51.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3100'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiinspection_schedules__mai3100.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI5025'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maidetailed_inspection_work_done__m.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI2210'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maidefective_advisory_roadstuds__ma.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3905'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#mairoadstud_defects_not_set_to_mand.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI2790'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiinsurance_claims__mai2790.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3904'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maidefect_notices__mai3904.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3912'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#mainotifiable_defects__mai3912.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3916'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#mainotifiable_defects_summary__mai3.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3690'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiprint_budget_exceptions_report__.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3692'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiprint_cost_code_exceptions_repor.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI2780'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiprint_item_code_breakdowns__mai2.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3980'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maicontract_details_report__mai3980.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3984'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#mailist_of_contract_rates__mai3984.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3982'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#mailist_of_contract_liabilities__ma.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3948'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maisummary_of_expenditure_by_contra.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3981'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#mailist_of_contractors__mai3981.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3954'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maicontractor_performance_report__m.htm' FROM DUAL;
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
       ,'Audit'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiworks_order_audit.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3485'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiwork_order_unpriced__mai3485.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3480'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiwork_order_priced__mai3480.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3800'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiboq_work_order_defects__mai3800.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3500'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiwork_order_detail__mai3500.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3505'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiworks_order_summary__mai3505.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI5130'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiwork_order_strip_plan__mai5130.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3490'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maireview_raised_works_orders__mai3.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3922'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maidefects_not_yet_instructed__mai3.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3920'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maisummary_of_defects_not_yet_instr.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3924'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiinstructed_work_by_status__mai39.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3926'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiinstructed_defects_due_for_compl.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3930'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiinventory_updates__mai3930.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3950'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiwork_for_quality_inspection__mai.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3952'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiquality_inspection_performance__.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3956'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiadmin_unit_performance__mai3956.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3907'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiboq_work_order_cyclic__mai3907.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI5032'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maicyclic_maintenance_done__mai5032.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3960'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maicyclic_maintenance_schedules__ma.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI1200'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiactivities_mai1200__overview.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI1205'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiactivity_groups_mai1205__overvie.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3632'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiasset_activities__mai3632.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI2775'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maibatch_setting_of_repair_dates__m.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3884'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maibulk_update_of_contract_items__m.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3610'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maicancel_works_orders__mai3610.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3881'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maicontractors__mai3881.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3880'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maicontracts__mai3880.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3882'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maicopy_a_contract__mai3882.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI2312'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maicopymove_inventory__mai2312.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3844'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maicost_centre_codes__mai3844.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3628'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#mairelated_maintenance_activities__.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3862'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maicyclic_maintenance_schedules_by_.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3626'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maicyclic_maintenance_inventory_rul.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3801'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiworks_order_cyclic__mai3801.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3440'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maivalid_for_maintenance_rules__mai.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3804'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiview_cyclic_maintenance_work__ma.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI1240'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maidefault_section_intervals__overr.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3150'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maidefault_treatments_mai3150__over.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI1300'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maidefect_control_data_mai1300__ove.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3812'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maidefect_priorities_mai3812__overv.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3910'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maidefects_by_inspection_date__mai3.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI2470'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maidelete_inspections_mai2470__over.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3842'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maideselect_items_for_payment__mai3.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3624'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maidiscount_groups__mai3624.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3664'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maifinancial_years__mai3664.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3662'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maigenerate_budgets_for_next_year__.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3899'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maihow_to_use_inspections_by_group_.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI1930'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiihms_allocated_amounts__mai1930.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG1220'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiinterval_codes__hig1220.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3666'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maijob_size_codes__mai3666.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3802'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiworks_orders_contractor__mai3802.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3250'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maimaintenance_reports__mai3250.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI2730'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maimatch_duplicate_defects__mai2730.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3840'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maipayment_run__mai3840.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3820'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiquality_inspection_results__mai3.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3940'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiquery_payment_run_details__mai39.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3816'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#mairesponses_to_notices__ma00000380.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3888'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maistandard_items_mai3888__overview.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI1315'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maitreatment_data_mai1315__overview.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI2760'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiunmatch_duplicate_defects_mai276.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3846'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maivat_rates__mai3846.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3810'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiview_defects_by_section_mai3810.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3803'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiworks_order_auditing_setup__mai3.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI3848'
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm#maiworks_order_authorisation__mai38.htm' FROM DUAL;
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
       ,'NM0700'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netad_types__nm0700.htm' FROM DUAL;
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
       ,'AST'
       ,'NM1861'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netasset_admin_unit_security_mainte.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0415'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netasset_attribute_sets__nm0415.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0301'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netasset_domains__nm0301.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0411'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netasset_exclusive_view_creation__n.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0510'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netasset_items__nm0510.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0590'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netasset_maintenance__nm0590.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0410'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netasset_metamodel__nm0410.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0306'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netasset_xsps__nm0306.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0560'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netassets_on_a_route__nm0560.htm' FROM DUAL;
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
       ,'NM0206'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netclose_element__nm0206.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0580'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netnm0580___create_mapcapture_metad.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0120'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netcreate_network_extent__nm0120.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0550'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netcross_attribute_validation_setup.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0575'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netdelete_global_assets__nm0575.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0420'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netderived_asset_setup__nm0420.htm' FROM DUAL;
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
       ,'NM0105'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netelements__nm0105.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0570'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netfind_asset__nm0570.htm' FROM DUAL;
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
       ,'NM1100'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netgazetteer__nm1100.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0530'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netglobal_asset_update__nm0530.htm' FROM DUAL;
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
       ,'NM0004'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netgroup_types__nm0004.htm' FROM DUAL;
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
       ,'NM0110'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netgroups_of_elements__nm0110.htm' FROM DUAL;
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
       ,'NM0115'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netgroups_of_groups__nm0115.htm' FROM DUAL;
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
       ,'NM3010'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netjob_operations__nm3010.htm' FROM DUAL;
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
       ,'NM3020'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netjob_types__nm3020.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0572'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netlocator___nm0572.htm' FROM DUAL;
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
       ,'NM0201'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netmerge_elements__nm0201.htm' FROM DUAL;
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
       ,'AST'
       ,'NM7055'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netmerge_file_extract_definition__n.htm' FROM DUAL;
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
       ,'AST'
       ,'NM7051'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netmerge_query_results__nm7051.htm' FROM DUAL;
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
       ,'AST'
       ,'NM7050'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netmerge_query_setup__nm7050.htm' FROM DUAL;
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
       ,'AST'
       ,'NM7053'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netmerge_query_defaults_nm7053.htm' FROM DUAL;
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
       ,'AST'
       ,'NM7057'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netmerge_results_extract__nm7057.htm' FROM DUAL;
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
       ,'UKP'
       ,'NET1119'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netnetwork_selection__net1119.htm' FROM DUAL;
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
       ,'NM0002'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netnetwork_type__nm0002.htm' FROM DUAL;
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
       ,'NM0500'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netnetwork_walker__nm0500.htm' FROM DUAL;
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
       ,'NM0220'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netreclassify_element__nm0220.htm' FROM DUAL;
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
       ,'AST'
       ,'NMWEB0020'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netweb_based_engineering_dynamic_se.htm' FROM DUAL;
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
       ,'NM0001'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netnode_types__nm0001.htm' FROM DUAL;
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
       ,'NM0101'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netnodes__nm0101.htm' FROM DUAL;
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
       ,'NM1201'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netoffset_calculator__nm1201.htm' FROM DUAL;
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
       ,'AST'
       ,'NM7041'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netpbi_query_results__nm7041.htm' FROM DUAL;
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
       ,'AST'
       ,'NM7040'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netpbi_query_setup__nm7040.htm' FROM DUAL;
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
       ,'NM2000'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netrecalibrate_element__nm2000.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0511'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netnm0511__reconcile_map_capture_lo.htm' FROM DUAL;
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
       ,'NM0202'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netreplace_element__nm0202.htm' FROM DUAL;
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
       ,'NM3030'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netroad_construction_operations_lay.htm' FROM DUAL;
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
       ,'NM1200'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netslk_calculator__nm1200.htm' FROM DUAL;
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
       ,'NM0200'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netsplit_element__nm0200.htm' FROM DUAL;
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
       ,'NM0207'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netundo_close__nm0207.htm' FROM DUAL;
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
       ,'NM0204'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netundo_merge__nm0204.htm' FROM DUAL;
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
       ,'NM0205'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netundo_replace__nm0205.htm' FROM DUAL;
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
       ,'NM0203'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netundo_split__nm0203.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0305'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netxsp_and_reversal_rules__nm0305.htm' FROM DUAL;
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
       ,'NSG'
       ,'NSG0015'
       ,''
       ,''
       ,'/nsg/WebHelp/nsg.htm#nsgconsolidate_street_nodes__nsg001.htm' FROM DUAL;
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
       ,'NSG'
       ,'NSG0020'
       ,''
       ,''
       ,'/nsg/WebHelp/nsg.htm#nsgexporting_nsg_and_asd_data.htm' FROM DUAL;
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
       ,'NSG'
       ,'NSG0025'
       ,''
       ,''
       ,'/nsg/WebHelp/nsg.htm#nsggenerate_asd_placements__nsg0025.htm' FROM DUAL;
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
       ,'STP'
       ,'STP1000'
       ,''
       ,''
       ,'/stp/WebHelp/stp.htm#stproad_construction_data__stp1000.htm' FROM DUAL;
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
       ,'STP'
       ,'STP4400'
       ,''
       ,''
       ,'/stp/WebHelp/stp.htm#stpmaintain_schemes__stp4400.htm' FROM DUAL;
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
       ,'STP'
       ,'STP0010'
       ,''
       ,''
       ,'/stp/WebHelp/stp.htm#stproad_construction_attributes__st.htm' FROM DUAL;
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
       ,'STP'
       ,'STP4401'
       ,''
       ,''
       ,'/stp/WebHelp/stp.htm#stpscheme_priorities__stp4401.htm' FROM DUAL;
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
       ,'HIG'
       ,'GIS'
       ,''
       ,''
       ,'/tm/WebHelp/tm.htm#tmdisplaying_traffic_data_on_a_map.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA2040'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpagreement_types__tma2040.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA5110'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpannual_inspection_profiles__tma5.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA5530'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpautomatic_inspection_dow00000025.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA5610'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpautomatic_inspection_upload__tma.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA0010'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpcontacts__tma0010.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA7070'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpcoordination_planning__tma7070.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA5515'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpdcd_extract__tma5515.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA5270'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpdefect_inspection_schedules__tma.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA1070'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpdirections_tma1070.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA1100'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpfixed_penalty_notices__tma1100.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA3020'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpget_restrictions__tma3020.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA5510'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpinspection_batch_file_summary__t.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA5500'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpinspection_download__tma5500.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA5520'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpinspection_download_to_dcd__tma5.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA6090'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpinspection_invoice_report__tma60.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA6050'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpinspection_performance_report__t.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA5300'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpinspection_rulesets__tma5300.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA5600'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpinspection_upload__tma5600.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA5620'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpinspection_upload_transaction_su.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA5000'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpinspections__tma5000.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA5200'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpinspections_metadata__tma5200.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA5020'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpinspections_sentreceived__tma502.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA5290'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpinspectors__tma5290.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA7090'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpinterim_sites_greater_than_6_mon.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA3000'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpmonitor_web_services_tra00000009.htm' FROM DUAL;
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
       ,'NSG'
       ,'NSG0130'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpmy_districts__nsg0130.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG4025'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpmy_standard_text__hig4025.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA0050'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpmy_street_groups__tma0050.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA1150'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpnon_street_works_activities__tma.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA2000'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpnotice_review_rules__tma2000.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA2010'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpnotice_types__tma2010.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA2050'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpnotice_warnings__tma2050.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA7080'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpnotices_with_an_agreement__tma70.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA1001'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpnoticing_assistant__tma1001.htm' FROM DUAL;
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
       ,'TMA_PR'
       ,'TMA2090'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helppermit_fee_profile__tma2090.htm' FROM DUAL;
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
       ,'TMA_PR'
       ,'TMA2070'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helppermit_fees__tma2070.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA7510'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helppermit_invoice__tma7510.htm' FROM DUAL;
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
       ,'TMA_PR'
       ,'TMA2080'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helppermit_schemes__tma2080.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA7500'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helppermit_status__tma7500.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA7040'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpphase_confirmation_required__tma.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA7030'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpphase_due_to_be_cancelled__tma70.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA7010'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpphase_due_to_complete__tma7010.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA7100'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpphase_with_a_section_74_charge__.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA7050'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpphase_without_a_full_registratio.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA7440'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpprint_blank_notice_pro_forma__tm.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA7450'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpprint_blank_permit_notice_pro_fo.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA7520'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpprint_permit_notice__tma7520.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA1010'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpprojects__tma1010.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA1190'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpquery_fpns__tma1190.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA5030'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpquery_inspection_defects__tma503.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA1170'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpquery_non_street_works_activitie.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA1050'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpquery_overrunning_works__tma1050.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA1040'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpquery_works__tma1040.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA1110'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helprestrictions__tma1110.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA1030'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpreview_notice__tma1030.htm' FROM DUAL;
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
       ,'TMA'
       ,'TMA6080'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpsample_inspection_invoice_report.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 290;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        290
       ,'TMA'
       ,'TMA6040'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpsample_inspection_quota_report__.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 291;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        291
       ,'TMA'
       ,'TMA5100'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpschedule_inspections__tma5100.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 292;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        292
       ,'TMA'
       ,'TMA1080'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpsection_74_charges__tma1080.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 293;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        293
       ,'TMA'
       ,'TMA2060'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpsection_74_charges_profile__tma2.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 294;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        294
       ,'TMA'
       ,'TMA1180'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpsend_all_restrictions__tma1180.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 295;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        295
       ,'TMA'
       ,'TMA3030'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpsend_od_data__tma3030.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 296;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        296
       ,'TMA'
       ,'TMA7060'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpsites_without_a_full_registrion_.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 297;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        297
       ,'HIG'
       ,'HIG4010'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpstandard_text__hig4010.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 298;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        298
       ,'HIG'
       ,'HIG4020'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpstandard_text_usage__hig4020.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 299;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        299
       ,'TMA'
       ,'TMA2030'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpstatus_transitions__tma2030.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 300;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        300
       ,'TMA'
       ,'TMA0020'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpstreet_groups__tma0020.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 301;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        301
       ,'TMA'
       ,'TMA0030'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpunassigned_streets__tma0030.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 302;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        302
       ,'HIG'
       ,'HIG1834'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpuser_contact_details__hig1834.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 303;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        303
       ,'TMA'
       ,'TMA0040'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpuser_street_groups__tma0040.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 304;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        304
       ,'TMA'
       ,'TMA1005'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpview_archived_workssites__tma100.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 305;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        305
       ,'TMA'
       ,'TMA1810'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpview_notices__tma1810.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 306;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        306
       ,'TMA'
       ,'TMA2020'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpwork_categories__tma2020.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 307;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        307
       ,'TMA'
       ,'TMA6000'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpwork_inspection_report__tma6000.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 308;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        308
       ,'TMA'
       ,'TMA1000'
       ,''
       ,''
       ,'/tma/WebHelp/tma.htm#tma_helpworks__tma1000.htm' FROM DUAL;
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
