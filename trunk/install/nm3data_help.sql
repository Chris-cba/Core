-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3data_help.sql-arc   2.3   Jul 20 2009 13:55:40   aedwards  $
--       Module Name      : $Workfile:   nm3data_help.sql  $
--       Date into PVCS   : $Date:   Jul 20 2009 13:55:40  $
--       Date fetched Out : $Modtime:   Jul 20 2009 13:55:02  $
--       Version          : $Revision:   2.3  $
--       Table Owner      : NM3_METADATA
--       Generation Date  : 20-JUL-2009 13:55
--
--   Product metadata script
--   As at Release 4.1.0.0
--
--   Copyright (c) exor corporation ltd, 2009
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
       ,'HIG'
       ,''
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm' FROM DUAL;
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
       ,'IM'
       ,''
       ,''
       ,''
       ,'/im/WebHelp/im.htm' FROM DUAL;
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
       ,'MAI'
       ,''
       ,''
       ,''
       ,'/mai/WebHelp/mai.htm' FROM DUAL;
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
       ,'MRWA'
       ,''
       ,''
       ,''
       ,'/mrwa/WebHelp/mrwa.htm' FROM DUAL;
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
       ,'NET'
       ,''
       ,''
       ,''
       ,'/net/WebHelp/net.htm' FROM DUAL;
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
       ,'NSG'
       ,''
       ,''
       ,''
       ,'/nsg/WebHelp/nsg.htm' FROM DUAL;
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
       ,'ENQ'
       ,''
       ,''
       ,''
       ,'/pem/WebHelp/enq.htm' FROM DUAL;
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
       ,'PMS'
       ,''
       ,''
       ,''
       ,'/pms/WebHelp/pms.htm' FROM DUAL;
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
       ,'PROW'
       ,''
       ,''
       ,''
       ,'/prow/WebHelp/prow.htm' FROM DUAL;
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
       ,'SCH'
       ,''
       ,''
       ,''
       ,'/sch/WebHelp/sch.htm' FROM DUAL;
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
       ,'CLM'
       ,''
       ,''
       ,''
       ,'/slm/WebHelp/clm.htm' FROM DUAL;
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
       ,'STP'
       ,''
       ,''
       ,''
       ,'/stp/WebHelp/stp.htm' FROM DUAL;
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
       ,'STR'
       ,''
       ,''
       ,''
       ,'/str/WebHelp/str.htm' FROM DUAL;
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
       ,'SWR'
       ,''
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm' FROM DUAL;
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
       ,'TM'
       ,''
       ,''
       ,''
       ,'/tm/WebHelp/tm.htm' FROM DUAL;
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
       ,'UKP'
       ,''
       ,''
       ,''
       ,'/ukp/WebHelp/ukp.htm' FROM DUAL;
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
       ,'USR'
       ,''
       ,''
       ,''
       ,'/usr/WebHelp/usr.htm' FROM DUAL;
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
       ,'WMP'
       ,''
       ,''
       ,''
       ,'/wmp/WebHelp/wmp.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0150'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docenquiries__doc0150.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0166'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docenquiry_list__doc0166.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0160'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docenquiry_details__doc0160.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0162'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docacknowledgements__doc0162.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0164'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docsummary_by_status__doc0164.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0165'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docsummary_by_type__doc0165.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0205'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docbatch_enquiry_printing__doc0205.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0167'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docoutstanding_enquiry_actions__doc.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0162'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docacknowledgements__doc0162.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0205'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docbatch_enquiry_printing__doc0205.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG1815'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#doccontacts__hig1815.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0150'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docenquiries__doc0150.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0160'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docenquiry_details__doc0160.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0166'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docenquiry_list__doc0166.htm' FROM DUAL;
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
       ,'ENQ'
       ,'DOC0157'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docenquiry_redirection_and_prioriti.htm' FROM DUAL;
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
       ,'HIG'
       ,'DOC0156'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docenquiry_standard_costs_doc0156.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI1325'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docenquirydefect_priorities__mai132.htm' FROM DUAL;
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
       ,'MAI'
       ,'MAI1320'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docenquirytreatment_types__mai1320.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG1815'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#doccontacts__hig1815.htm' FROM DUAL;
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
       ,'DOC0167'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docoutstanding_enquiry_actions__doc.htm' FROM DUAL;
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
       ,'DOC0164'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docsummary_by_status__doc0164.htm' FROM DUAL;
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
       ,'DOC0165'
       ,''
       ,''
       ,'/doc/WebHelp/doc.htm#docsummary_by_type__doc0165.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG1840'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higuser_preferences__hig1840.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG1880'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higmodules__hig1880.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG9135'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higproduct_option_list__hig9135.htm' FROM DUAL;
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
       ,'HIG1860'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higadmin_units__hig1860.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG1833'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higchange_password__hig1833.htm' FROM DUAL;
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
       ,'HIG2010'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higcsv_loader_destination_table__hi.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG2020'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higcsv_loader_file_definitions_tabl.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG9120'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higdomains__hig9120.htm' FROM DUAL;
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
       ,'HIG1807'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higlaunchpad__favourites.htm' FROM DUAL;
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
       ,'GRI0240'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higgri_module_parameters__gri0240.htm' FROM DUAL;
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
       ,'GRI0220'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higgri_modules__gri0220.htm' FROM DUAL;
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
       ,'GRI0250'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higgri_parameter_dependencies__gri0.htm' FROM DUAL;
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
       ,'GRI0230'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higgri_parameters__gri0230.htm' FROM DUAL;
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
       ,'HIGWEB2030'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higloadprocess_data__higweb2030.htm' FROM DUAL;
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
       ,'HIG1880'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higmodules__hig1880.htm' FROM DUAL;
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
       ,'HIG9135'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higproduct_option_list__hig9135.htm' FROM DUAL;
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
       ,'HIG9130'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#highig9130__product_options.htm' FROM DUAL;
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
       ,'HIG1890'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higproducts__hig1890.htm' FROM DUAL;
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
       ,'HIG1850'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higreport_styles__hig1850.htm' FROM DUAL;
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
       ,'HIG1836'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higroles__hig1836.htm' FROM DUAL;
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
       ,'GIS0010'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higthemes__gis0010.htm' FROM DUAL;
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
       ,'HIG1820'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higunits_and_conversions__hig1820.htm' FROM DUAL;
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
       ,'HIG1837'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higuser_option_administration__hig1.htm' FROM DUAL;
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
       ,'HIG1840'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higuser_preferences__hig1840.htm' FROM DUAL;
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
       ,'HIG1832'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higusers__hig1832.htm' FROM DUAL;
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
       ,'HIG1836'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higroles__hig1836.htm' FROM DUAL;
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
       ,'HIG9185'
       ,''
       ,''
       ,'/hig/WebHelp/hig.htm#higv3_errors__hig9185.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0700'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netad_types__nm0700.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0700'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netad_types__nm0700.htm' FROM DUAL;
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
       ,'HIG1860'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netadmin_units__hig1860.htm' FROM DUAL;
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
       ,'AST'
       ,'NM1861'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netasset_admin_unit_security_mainte.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0415'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netasset_attribute_sets__nm0415.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0301'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netasset_domains__nm0301.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0411'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netasset_exclusive_view_creation__n.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0510'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netasset_items__nm0510.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0590'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netasset_maintenance__nm0590.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0410'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netasset_metamodel__nm0410.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0306'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netasset_xsps__nm0306.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0560'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netassets_on_a_route__nm0560.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0206'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netclose_element__nm0206.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0580'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netnm0580___create_mapcapture_metad.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0120'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netcreate_network_extent__nm0120.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0550'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netcross_attribute_validation_setup.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0575'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netdelete_global_assets__nm0575.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0420'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netderived_asset_setup__nm0420.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0105'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netelements__nm0105.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0570'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netfind_asset__nm0570.htm' FROM DUAL;
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
       ,'NET'
       ,'NM1100'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netgazetteer__nm1100.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0530'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netglobal_asset_update__nm0530.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0004'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netgroup_types__nm0004.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0110'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netgroups_of_elements__nm0110.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0115'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netgroups_of_groups__nm0115.htm' FROM DUAL;
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
       ,'NET'
       ,'NM3010'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netjob_operations__nm3010.htm' FROM DUAL;
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
       ,'NET'
       ,'NM3020'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netjob_types__nm3020.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0572'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netlocator___nm0572.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0201'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netmerge_elements__nm0201.htm' FROM DUAL;
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
       ,'AST'
       ,'NM7055'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netmerge_file_extract_definition__n.htm' FROM DUAL;
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
       ,'AST'
       ,'NM7051'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netmerge_query_results__nm7051.htm' FROM DUAL;
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
       ,'AST'
       ,'NM7050'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netmerge_query_setup__nm7050.htm' FROM DUAL;
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
       ,'AST'
       ,'NM7053'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netmerge_query_defaults_nm7053.htm' FROM DUAL;
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
       ,'AST'
       ,'NM7051'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netmerge_query_results__nm7051.htm' FROM DUAL;
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
       ,'AST'
       ,'NM7050'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netmerge_query_setup__nm7050.htm' FROM DUAL;
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
       ,'AST'
       ,'NM7053'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netmerge_query_defaults_nm7053.htm' FROM DUAL;
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
       ,'AST'
       ,'NM7051'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netmerge_query_results__nm7051.htm' FROM DUAL;
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
       ,'AST'
       ,'NM7050'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netmerge_query_setup__nm7050.htm' FROM DUAL;
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
       ,'AST'
       ,'NM7057'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netmerge_results_extract__nm7057.htm' FROM DUAL;
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
       ,'UKP'
       ,'NET1119'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netnetwork_selection__net1119.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0002'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netnetwork_type__nm0002.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0500'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netnetwork_walker__nm0500.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0105'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netelements__nm0105.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0105'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netextend_route_at_end.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0110'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netgroups_of_elements__nm0110.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0120'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netcreate_network_extent__nm0120.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0220'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netreclassify_element__nm0220.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0410'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netasset_metamodel__nm0410.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0510'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netasset_items__nm0510.htm' FROM DUAL;
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
       ,'NET'
       ,'NM1100'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netgazetteer__nm1100.htm' FROM DUAL;
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
       ,'AST'
       ,'NM7050'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netmerge_query_setup__nm7050.htm' FROM DUAL;
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
       ,'AST'
       ,'NM7055'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netmerge_file_extract_definition__n.htm' FROM DUAL;
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
       ,'AST'
       ,'NMWEB0020'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netweb_based_engineering_dynamic_se.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0001'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netnode_types__nm0001.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0101'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netnodes__nm0101.htm' FROM DUAL;
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
       ,'NET'
       ,'NM1201'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netoffset_calculator__nm1201.htm' FROM DUAL;
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
       ,'AST'
       ,'NM7041'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netpbi_query_results__nm7041.htm' FROM DUAL;
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
       ,'AST'
       ,'NM7040'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netpbi_query_setup__nm7040.htm' FROM DUAL;
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
       ,'NET'
       ,'NM2000'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netrecalibrate_element__nm2000.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0220'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netreclassify_element__nm0220.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0511'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netnm0511__reconcile_map_capture_lo.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0202'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netreplace_element__nm0202.htm' FROM DUAL;
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
       ,'NET'
       ,'NM3030'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netroad_construction_operations_lay.htm' FROM DUAL;
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
       ,'HIG1836'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netroles__hig1836.htm' FROM DUAL;
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
       ,'NET'
       ,'NM2000'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netrecalibrate_element__nm2000.htm' FROM DUAL;
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
       ,'NET'
       ,'NM1200'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netslk_calculator__nm1200.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0200'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netsplit_element__nm0200.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0207'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netundo_close__nm0207.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0204'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netundo_merge__nm0204.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0205'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netundo_replace__nm0205.htm' FROM DUAL;
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
       ,'NET'
       ,'NM0203'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netundo_split__nm0203.htm' FROM DUAL;
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
       ,'HIG1820'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netunits_and_conversions__hig1820.htm' FROM DUAL;
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
       ,'HIG1832'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netusers__hig1832.htm' FROM DUAL;
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
       ,'HIG1836'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netroles__hig1836.htm' FROM DUAL;
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
       ,'HIG1836'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netroles__hig1836.htm' FROM DUAL;
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
       ,'AST'
       ,'NMWEB0020'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netweb_based_engineering_dynamic_se.htm' FROM DUAL;
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
       ,'AST'
       ,'NM0305'
       ,''
       ,''
       ,'/net/WebHelp/net.htm#netxsp_and_reversal_rules__nm0305.htm' FROM DUAL;
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
       ,'NSG'
       ,'NSG0015'
       ,''
       ,''
       ,'/nsg/WebHelp/nsg.htm#nsgconsolidate_street_nodes__nsg001.htm' FROM DUAL;
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
       ,'NSG'
       ,'NSG0015'
       ,''
       ,''
       ,'/nsg/WebHelp/nsg.htm#nsgconsolidate_street_nodes__nsg001.htm' FROM DUAL;
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
       ,'NSG'
       ,'NSG0020'
       ,''
       ,''
       ,'/nsg/WebHelp/nsg.htm#nsgexporting_nsg_and_asd_data.htm' FROM DUAL;
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
       ,'NSG'
       ,'NSG0025'
       ,''
       ,''
       ,'/nsg/WebHelp/nsg.htm#nsggenerate_asd_placements__nsg0025.htm' FROM DUAL;
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
       ,'STP'
       ,'STP1000'
       ,''
       ,''
       ,'/stp/WebHelp/stp.htm#stproad_construction_data__stp1000.htm' FROM DUAL;
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
       ,'NM3010'
       ,''
       ,''
       ,'/stp/WebHelp/stp.htm#stpjob_operations__nm3010.htm' FROM DUAL;
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
       ,'NM3020'
       ,''
       ,''
       ,'/stp/WebHelp/stp.htm#stpjob_types__nm3020.htm' FROM DUAL;
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
       ,'STP'
       ,'STP4400'
       ,''
       ,''
       ,'/stp/WebHelp/stp.htm#stpmaintain_schemes__stp4400.htm' FROM DUAL;
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
       ,'STP'
       ,'STP0010'
       ,''
       ,''
       ,'/stp/WebHelp/stp.htm#stproad_construction_attributes__st.htm' FROM DUAL;
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
       ,'STP'
       ,'STP1000'
       ,''
       ,''
       ,'/stp/WebHelp/stp.htm#stproad_construction_data__stp1000.htm' FROM DUAL;
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
       ,'STP'
       ,'STP4401'
       ,''
       ,''
       ,'/stp/WebHelp/stp.htm#stpscheme_priorities__stp4401.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1450'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrswa_organisations__swr1450.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1461'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_district_hierarchy__swr.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1471'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrcontact_list__swr1471.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1480'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrcoordination_groups__swr1480.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1490'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrstandard_text__swr1490.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1451'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrorganisation_data_report__swr145.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1190'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_worksreinstatement_deta.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1120'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrnotice_sentreceived__swr1120.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1380'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrnon_works_activity__swr1380.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1180'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmerge_unattributable_works__swr1.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1400'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrallocate_provisional_works__swr1.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1630'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_section_74_charges__swr.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1401'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_work_types__swr1401.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1403'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_notice_types__swr1403.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1519'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_notice_charges__swr1519.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1512'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_works_rules__swr1512.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1513'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_site_rules__swr1513.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1560'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_allowable_site_updates_.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1570'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_workssites_combinations.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1640'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_section_74_charging_pro.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1070'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrquery_workssites__swr1070.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1189'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrquery_works_history__swr1189.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1390'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrview_non_works_activity__swr1390.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1328'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrchargeable_notices_invoice__swr1.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1220'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrprint_works_details__swr1220.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1159'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_with_a_section_74_duration.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1158'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_due_a_section_74_start__sw.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1157'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_due_to_complete__swr1157.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1650'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrsection_74_charges_invoice__swr1.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1225'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrgeneric_works_report__swr1225.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1209'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrexpiring_reinstatement_guarantee.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1212'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrinterim_reinstatements__6_months.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1156'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_history__swr1156.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG1807'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrnotice_analysis_report__hig1807.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1111'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_works_comments__swr1111.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1112'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrcomments_sentreceived__swr1112.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1250'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_inspection_details__swr.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1760'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrview_inspection_history__swr1760.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1750'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrinspections_sent__received__swr1.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1770'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrview_inspection_defects__swr1770.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1240'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_annual_inspection_profi.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1290'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrschedule_inspections__swr1290.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1517'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_defect_inspection_sched.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1660'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_inspection_categories__.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1670'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_sample_inspecti00000048.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1680'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_inspection_types__swr16.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1690'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_inspection_outcomes__sw.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1700'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_defect_notice_messages_.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1710'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_inspection_item_status_.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1720'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_allowable_inspection_it.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1514'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_sample_inspecti00000054.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1292'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_inspection_report__swr1292.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1230'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrgeneric_inspections_report__swr1.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1305'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrinspection_history__swr1305.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1255'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrannual_inspection_profile__swr12.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1256'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrsample_inspections_quotas_report.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1257'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrinspection_performance__swr1257.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1294'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrprospective_inspections_report__.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1325'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrsample_inspection_invoice_report.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1326'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrinspections_invoice__swr1326.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1197'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrcoordination_planning__swr1197.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1198'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrconflicting_works__swr1198.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1336'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_street_naming_authoriti.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1530'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrstreets_of_interest__swr1530.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1550'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrsoi_gazetteer_data_report__swr15.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1551'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrauthority_gazetteer_data_report_.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1601'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrautomatic_uploaddownload_utility.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1600'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swruploaddownload_utility__swr1600.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1605'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmonitor_batch_file_status__swr16.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1602'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_automatic_batch_process.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1604'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_automatic_batch_operati.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1603'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_automatic_batch_rules__.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1620'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_batch_messages__swr1620.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1610'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrbatch_files_processed__swr1610.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1780'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrbatch_file_listing__swr1780.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1060'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrsystem_definitions__swr1060.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1051'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_user_definitions__swr10.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1500'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrreference_data__swr1500.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1510'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_interface_mappings__swr.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1501'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrreference_data_report__swr1501.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1400'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrallocate_provisional_works__swr1.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1255'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrannual_inspection_profile__swr12.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1551'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrauthority_gazetteer_data_report_.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1601'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrautomatic_uploaddownload_utility.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1780'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrbatch_file_listing__swr1780.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1610'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrbatch_files_processed__swr1610.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1328'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrchargeable_notices_invoice__swr1.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1112'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrcomments_sentreceived__swr1112.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1157'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_due_to_complete__swr1157.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1198'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrconflicting_works__swr1198.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1471'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrcontact_list__swr1471.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1480'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrcoordination_groups__swr1480.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1197'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrcoordination_planning__swr1197.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1209'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrexpiring_reinstatement_guarantee.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1230'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrgeneric_inspections_report__swr1.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1225'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrgeneric_works_report__swr1225.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG1807'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrnotice_analysis_report__hig1807.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1305'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrinspection_history__swr1305.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1257'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrinspection_performance__swr1257.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1326'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrinspections_invoice__swr1326.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1750'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrinspections_sent__received__swr1.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1212'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrinterim_reinstatements__6_months.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1720'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_allowable_inspection_it.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1560'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_allowable_site_updates_.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1240'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_annual_inspection_profi.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1604'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_automatic_batch_operati.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1602'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_automatic_batch_process.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1603'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_automatic_batch_rules__.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1620'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_batch_messages__swr1620.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1517'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_defect_inspection_sched.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1700'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_defect_notice_messages_.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1461'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_district_hierarchy__swr.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1660'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_inspection_categories__.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1250'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_inspection_details__swr.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1710'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_inspection_item_status_.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1690'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_inspection_outcomes__sw.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1680'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_inspection_types__swr16.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1510'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_interface_mappings__swr.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1519'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_notice_charges__swr1519.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1403'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_notice_types__swr1403.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1670'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_sample_inspecti00000048.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1514'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_sample_inspecti00000054.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1630'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_section_74_charges__swr.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1640'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_section_74_charging_pro.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1513'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_site_rules__swr1513.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1336'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_street_naming_authoriti.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1051'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_user_definitions__swr10.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1401'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_work_types__swr1401.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1111'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_works_comments__swr1111.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1512'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_works_rules__swr1512.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1190'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_worksreinstatement_deta.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1570'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_workssites_combinations.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1180'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmerge_unattributable_works__swr1.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1605'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmonitor_batch_file_status__swr16.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1380'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrnon_works_activity__swr1380.htm' FROM DUAL;
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
       ,'HIG'
       ,'HIG1807'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrnotice_analysis_report__hig1807.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1120'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrnotice_sentreceived__swr1120.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1451'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrorganisation_data_report__swr145.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1220'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrprint_works_details__swr1220.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1294'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrprospective_inspections_report__.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1189'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrquery_works_history__swr1189.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1070'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrquery_workssites__swr1070.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1500'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrreference_data__swr1500.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1501'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrreference_data_report__swr1501.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1212'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrinterim_reinstatements__6_months.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1256'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrsample_inspections_quotas_report.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1257'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrinspection_performance__swr1257.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1157'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_due_to_complete__swr1157.htm' FROM DUAL;
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
       ,'SWR'
       ,'SWR1780'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrbatch_file_listing__swr1780.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 309;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        309
       ,'SWR'
       ,'SWR1650'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrsection_74_charges_invoice__swr1.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 310;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        310
       ,'SWR'
       ,'SWR1225'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrgeneric_works_report__swr1225.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 311;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        311
       ,'HIG'
       ,'HIG1807'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrnotice_analysis_report__hig1807.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 312;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        312
       ,'SWR'
       ,'SWR1451'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrorganisation_data_report__swr145.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 313;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        313
       ,'SWR'
       ,'SWR1292'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_inspection_report__swr1292.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 314;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        314
       ,'SWR'
       ,'SWR1230'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrgeneric_inspections_report__swr1.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 315;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        315
       ,'SWR'
       ,'SWR1305'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrinspection_history__swr1305.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 316;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        316
       ,'SWR'
       ,'SWR1328'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrchargeable_notices_invoice__swr1.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 317;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        317
       ,'SWR'
       ,'SWR1501'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrreference_data_report__swr1501.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 318;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        318
       ,'SWR'
       ,'SWR1158'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_due_a_section_74_start__sw.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 319;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        319
       ,'SWR'
       ,'SWR1325'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrsample_inspection_invoice_report.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 320;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        320
       ,'SWR'
       ,'SWR1326'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrinspections_invoice__swr1326.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 321;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        321
       ,'SWR'
       ,'SWR1471'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrcontact_list__swr1471.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 322;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        322
       ,'SWR'
       ,'SWR1220'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrprint_works_details__swr1220.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 323;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        323
       ,'SWR'
       ,'SWR1294'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrprospective_inspections_report__.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 324;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        324
       ,'SWR'
       ,'SWR1550'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrsoi_gazetteer_data_report__swr15.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 325;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        325
       ,'SWR'
       ,'SWR1551'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrauthority_gazetteer_data_report_.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 326;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        326
       ,'SWR'
       ,'SWR1159'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_with_a_section_74_duration.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 327;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        327
       ,'SWR'
       ,'SWR1610'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrbatch_files_processed__swr1610.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 328;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        328
       ,'SWR'
       ,'SWR1325'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrsample_inspection_invoice_report.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 329;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        329
       ,'SWR'
       ,'SWR1256'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrsample_inspections_quotas_report.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 330;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        330
       ,'SWR'
       ,'SWR1290'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrschedule_inspections__swr1290.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 331;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        331
       ,'SWR'
       ,'SWR1650'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrsection_74_charges_invoice__swr1.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 332;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        332
       ,'SWR'
       ,'SWR1159'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_with_a_section_74_duration.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 333;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        333
       ,'SWR'
       ,'SWR1158'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_due_a_section_74_start__sw.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 334;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        334
       ,'SWR'
       ,'SWR1550'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrsoi_gazetteer_data_report__swr15.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 335;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        335
       ,'SWR'
       ,'SWR1490'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrstandard_text__swr1490.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 336;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        336
       ,'SWR'
       ,'SWR1530'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrstreets_of_interest__swr1530.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 337;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        337
       ,'SWR'
       ,'SWR1450'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrswa_organisations__swr1450.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 338;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        338
       ,'SWR'
       ,'SWR1051'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_user_definitions__swr10.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 339;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        339
       ,'SWR'
       ,'SWR1060'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrsystem_definitions__swr1060.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 340;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        340
       ,'SWR'
       ,'SWR1070'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrquery_workssites__swr1070.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 341;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        341
       ,'SWR'
       ,'SWR1111'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_works_comments__swr1111.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 342;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        342
       ,'SWR'
       ,'SWR1112'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrcomments_sentreceived__swr1112.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 343;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        343
       ,'SWR'
       ,'SWR1120'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrnotice_sentreceived__swr1120.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 344;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        344
       ,'SWR'
       ,'SWR1156'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_history__swr1156.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 345;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        345
       ,'SWR'
       ,'SWR1157'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_due_to_complete__swr1157.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 346;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        346
       ,'SWR'
       ,'SWR1158'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_due_a_section_74_start__sw.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 347;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        347
       ,'SWR'
       ,'SWR1159'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_with_a_section_74_duration.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 348;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        348
       ,'SWR'
       ,'SWR1180'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmerge_unattributable_works__swr1.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 349;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        349
       ,'SWR'
       ,'SWR1189'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrquery_works_history__swr1189.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 350;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        350
       ,'SWR'
       ,'SWR1190'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_worksreinstatement_deta.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 351;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        351
       ,'SWR'
       ,'SWR1197'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrcoordination_planning__swr1197.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 352;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        352
       ,'SWR'
       ,'SWR1198'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrconflicting_works__swr1198.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 353;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        353
       ,'SWR'
       ,'SWR1209'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrexpiring_reinstatement_guarantee.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 354;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        354
       ,'SWR'
       ,'SWR1212'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrinterim_reinstatements__6_months.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 355;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        355
       ,'SWR'
       ,'SWR1220'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrprint_works_details__swr1220.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 356;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        356
       ,'SWR'
       ,'SWR1225'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrgeneric_works_report__swr1225.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 357;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        357
       ,'SWR'
       ,'SWR1230'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrgeneric_inspections_report__swr1.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 358;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        358
       ,'SWR'
       ,'SWR1240'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_annual_inspection_profi.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 359;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        359
       ,'SWR'
       ,'SWR1250'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_inspection_details__swr.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 360;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        360
       ,'SWR'
       ,'SWR1255'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrannual_inspection_profile__swr12.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 361;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        361
       ,'SWR'
       ,'SWR1256'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrsample_inspections_quotas_report.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 362;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        362
       ,'SWR'
       ,'SWR1257'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrinspection_performance__swr1257.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 363;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        363
       ,'SWR'
       ,'SWR1290'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrschedule_inspections__swr1290.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 364;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        364
       ,'SWR'
       ,'SWR1292'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_inspection_report__swr1292.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 365;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        365
       ,'SWR'
       ,'SWR1294'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrprospective_inspections_report__.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 366;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        366
       ,'SWR'
       ,'SWR1305'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrinspection_history__swr1305.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 367;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        367
       ,'SWR'
       ,'SWR1325'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrsample_inspection_invoice_report.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 368;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        368
       ,'SWR'
       ,'SWR1326'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrinspections_invoice__swr1326.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 369;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        369
       ,'SWR'
       ,'SWR1328'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrchargeable_notices_invoice__swr1.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 370;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        370
       ,'SWR'
       ,'SWR1336'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_street_naming_authoriti.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 371;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        371
       ,'SWR'
       ,'SWR1380'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrnon_works_activity__swr1380.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 372;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        372
       ,'SWR'
       ,'SWR1390'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrview_non_works_activity__swr1390.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 373;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        373
       ,'SWR'
       ,'SWR1400'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrallocate_provisional_works__swr1.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 374;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        374
       ,'SWR'
       ,'SWR1401'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_work_types__swr1401.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 375;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        375
       ,'SWR'
       ,'SWR1403'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_notice_types__swr1403.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 376;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        376
       ,'SWR'
       ,'SWR1450'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrswa_organisations__swr1450.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 377;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        377
       ,'SWR'
       ,'SWR1451'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrorganisation_data_report__swr145.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 378;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        378
       ,'SWR'
       ,'SWR1461'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_district_hierarchy__swr.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 379;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        379
       ,'SWR'
       ,'SWR1471'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrcontact_list__swr1471.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 380;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        380
       ,'SWR'
       ,'SWR1480'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrcoordination_groups__swr1480.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 381;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        381
       ,'SWR'
       ,'SWR1490'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrstandard_text__swr1490.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 382;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        382
       ,'SWR'
       ,'SWR1500'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrreference_data__swr1500.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 383;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        383
       ,'SWR'
       ,'SWR1501'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrreference_data_report__swr1501.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 384;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        384
       ,'SWR'
       ,'SWR1510'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_interface_mappings__swr.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 385;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        385
       ,'SWR'
       ,'SWR1512'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_works_rules__swr1512.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 386;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        386
       ,'SWR'
       ,'SWR1513'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_site_rules__swr1513.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 387;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        387
       ,'SWR'
       ,'SWR1514'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_sample_inspecti00000054.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 388;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        388
       ,'SWR'
       ,'SWR1517'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_defect_inspection_sched.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 389;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        389
       ,'SWR'
       ,'SWR1519'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_notice_charges__swr1519.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 390;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        390
       ,'SWR'
       ,'SWR1530'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrstreets_of_interest__swr1530.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 391;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        391
       ,'SWR'
       ,'SWR1550'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrsoi_gazetteer_data_report__swr15.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 392;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        392
       ,'SWR'
       ,'SWR1551'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrauthority_gazetteer_data_report_.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 393;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        393
       ,'SWR'
       ,'SWR1560'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_allowable_site_updates_.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 394;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        394
       ,'SWR'
       ,'SWR1570'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_workssites_combinations.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 395;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        395
       ,'SWR'
       ,'SWR1600'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swruploaddownload_utility__swr1600.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 396;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        396
       ,'SWR'
       ,'SWR1601'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrautomatic_uploaddownload_utility.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 397;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        397
       ,'SWR'
       ,'SWR1602'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_automatic_batch_process.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 398;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        398
       ,'SWR'
       ,'SWR1603'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_automatic_batch_rules__.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 399;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        399
       ,'SWR'
       ,'SWR1604'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_automatic_batch_operati.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 400;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        400
       ,'SWR'
       ,'SWR1605'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmonitor_batch_file_status__swr16.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 401;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        401
       ,'SWR'
       ,'SWR1610'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrbatch_files_processed__swr1610.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 402;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        402
       ,'SWR'
       ,'SWR1620'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_batch_messages__swr1620.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 403;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        403
       ,'SWR'
       ,'SWR1630'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_section_74_charges__swr.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 404;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        404
       ,'SWR'
       ,'SWR1640'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_section_74_charging_pro.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 405;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        405
       ,'SWR'
       ,'SWR1650'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrsection_74_charges_invoice__swr1.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 406;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        406
       ,'SWR'
       ,'SWR1660'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_inspection_categories__.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 407;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        407
       ,'SWR'
       ,'SWR1670'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_sample_inspecti00000048.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 408;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        408
       ,'SWR'
       ,'SWR1680'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_inspection_types__swr16.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 409;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        409
       ,'SWR'
       ,'SWR1690'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_inspection_outcomes__sw.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 410;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        410
       ,'SWR'
       ,'SWR1700'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_defect_notice_messages_.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 411;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        411
       ,'SWR'
       ,'SWR1710'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_inspection_item_status_.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 412;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        412
       ,'SWR'
       ,'SWR1720'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrmaintain_allowable_inspection_it.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 413;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        413
       ,'SWR'
       ,'SWR1750'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrinspections_sent__received__swr1.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 414;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        414
       ,'SWR'
       ,'SWR1760'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrview_inspection_history__swr1760.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 415;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        415
       ,'SWR'
       ,'SWR1770'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrview_inspection_defects__swr1770.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 416;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        416
       ,'SWR'
       ,'SWR1780'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrbatch_file_listing__swr1780.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 417;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        417
       ,'SWR'
       ,'SWR1060'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrsystem_definitions__swr1060.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 418;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        418
       ,'SWR'
       ,'SWR1600'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swruploaddownload_utility__swr1600.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 419;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        419
       ,'SWR'
       ,'SWR1770'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrview_inspection_defects__swr1770.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 420;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        420
       ,'SWR'
       ,'SWR1760'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrview_inspection_history__swr1760.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 421;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        421
       ,'SWR'
       ,'SWR1390'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrview_non_works_activity__swr1390.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 422;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        422
       ,'SWR'
       ,'SWR1158'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_due_a_section_74_start__sw.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 423;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        423
       ,'SWR'
       ,'SWR1157'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_due_to_complete__swr1157.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 424;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        424
       ,'SWR'
       ,'SWR1158'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_due_a_section_74_start__sw.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 425;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        425
       ,'SWR'
       ,'SWR1157'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_due_to_complete__swr1157.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 426;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        426
       ,'SWR'
       ,'SWR1157'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_due_to_complete__swr1157.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 427;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        427
       ,'SWR'
       ,'SWR1158'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_due_a_section_74_start__sw.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 428;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        428
       ,'SWR'
       ,'SWR1156'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_history__swr1156.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 429;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        429
       ,'SWR'
       ,'SWR1292'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_inspection_report__swr1292.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 430;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        430
       ,'SWR'
       ,'SWR1159'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_with_a_section_74_duration.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 431;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        431
       ,'SWR'
       ,'SWR1159'
       ,''
       ,''
       ,'/swr/WebHelp/swr.htm#swrworks_with_a_section_74_duration.htm' FROM DUAL;
--
DELETE FROM HIG_WEB_CONTXT_HLP
 WHERE HWCH_ART_ID = 432;
--
INSERT INTO HIG_WEB_CONTXT_HLP
       (HWCH_ART_ID
       ,HWCH_PRODUCT
       ,HWCH_MODULE
       ,HWCH_BLOCK
       ,HWCH_ITEM
       ,HWCH_HTML_STRING
       )
SELECT 
        432
       ,'HIG'
       ,'GIS'
       ,''
       ,''
       ,'/tm/WebHelp/tm.htm#tmdisplaying_traffic_data_on_a_map.htm' FROM DUAL;
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
