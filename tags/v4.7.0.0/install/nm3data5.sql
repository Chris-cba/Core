-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3data5.sql-arc   2.16   Jul 04 2013 14:09:18   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3data5.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:09:18  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:39:20  $
--       Version          : $Revision:   2.16  $
--       Table Owner      : NM3_METADATA
--       Generation Date  : 25-MAR-2011 09:31
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--   Product metadata script
--   As at Release 4.4.0.0
--
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
--
--   TABLES PROCESSED
--   ================
--   DOC_CLASS
--   DOC_MEDIA
--   DOC_LOCATIONS
--   DOC_TEMPLATE_GATEWAYS
--   DOC_TEMPLATE_COLUMNS
--   DOC_ENQUIRY_TYPES
--   HIG_USERS
--   HIG_USER_FAVOURITES
--   HIG_SYSTEM_FAVOURITES
--   NM_LOAD_DESTINATIONS
--   NM_LOAD_DESTINATION_DEFAULTS
--   NM_UPLOAD_FILE_GATEWAYS
--   NM_UPLOAD_FILE_GATEWAY_COLS
--
-----------------------------------------------------------------------------


set define off;
set feedback off;

---------------------------------
-- START OF GENERATED METADATA --
---------------------------------


----------------------------------------------------------------------------------------
-- DOC_CLASS
--
-- select * from nm3_metadata.doc_class
-- order by dcl_dtp_code
--         ,dcl_code
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT doc_class
SET TERM OFF

INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'WOLF'
       ,'Woolf'
       ,'Woolf Claim'
       ,null
       ,null
       ,'CLAM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'CLAM'
                    AND  DCL_CODE = 'WOLF');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'APPL'
       ,'Appeal'
       ,'Appeal'
       ,null
       ,null
       ,'COMP' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'COMP'
                    AND  DCL_CODE = 'APPL');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'FRML'
       ,'Formal'
       ,'Formal'
       ,null
       ,null
       ,'COMP' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'COMP'
                    AND  DCL_CODE = 'FRML');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'IFRM'
       ,'Informal'
       ,'Informal'
       ,null
       ,null
       ,'COMP' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'COMP'
                    AND  DCL_CODE = 'IFRM');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'CINC'
       ,'Commercial in Confidence'
       ,''
       ,null
       ,null
       ,'REPT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'REPT'
                    AND  DCL_CODE = 'CINC');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'CONF'
       ,'Confidential'
       ,''
       ,null
       ,null
       ,'REPT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'REPT'
                    AND  DCL_CODE = 'CONF');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'NONE'
       ,'Unclassified'
       ,''
       ,null
       ,null
       ,'REPT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'REPT'
                    AND  DCL_CODE = 'NONE');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'CINC'
       ,'Commercial in Confidence'
       ,''
       ,null
       ,null
       ,'TRO' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'TRO'
                    AND  DCL_CODE = 'CINC');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'CONF'
       ,'Confidential'
       ,''
       ,null
       ,null
       ,'TRO' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'TRO'
                    AND  DCL_CODE = 'CONF');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'NONE'
       ,'Unclassified'
       ,''
       ,null
       ,null
       ,'TRO' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'TRO'
                    AND  DCL_CODE = 'NONE');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'APPL'
       ,'Appeal'
       ,'Appeal'
       ,null
       ,null
       ,'UKNW' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'UKNW'
                    AND  DCL_CODE = 'APPL');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'CINC'
       ,'Commercial in Confidence'
       ,''
       ,null
       ,null
       ,'UKNW' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'UKNW'
                    AND  DCL_CODE = 'CINC');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'CONF'
       ,'Confidential'
       ,''
       ,null
       ,null
       ,'UKNW' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'UKNW'
                    AND  DCL_CODE = 'CONF');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'FRML'
       ,'Formal'
       ,'Formal'
       ,null
       ,null
       ,'UKNW' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'UKNW'
                    AND  DCL_CODE = 'FRML');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'IFRM'
       ,'Informal'
       ,'Informal'
       ,null
       ,null
       ,'UKNW' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'UKNW'
                    AND  DCL_CODE = 'IFRM');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'NONE'
       ,'Unclassified'
       ,''
       ,null
       ,null
       ,'UKNW' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'UKNW'
                    AND  DCL_CODE = 'NONE');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'WOLF'
       ,'Woolf'
       ,'Woolf Claim'
       ,null
       ,null
       ,'UKNW' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'UKNW'
                    AND  DCL_CODE = 'WOLF');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- DOC_MEDIA
--
-- select * from nm3_metadata.doc_media
-- order by dmd_id
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT doc_media
SET TERM OFF

INSERT INTO DOC_MEDIA
       (DMD_ID
       ,DMD_NAME
       ,DMD_DESCR
       ,DMD_DISPLAY_COMMAND
       ,DMD_SCAN_COMMAND
       ,DMD_IMAGE_COMMAND1
       ,DMD_IMAGE_COMMAND2
       ,DMD_IMAGE_COMMAND3
       ,DMD_IMAGE_COMMAND4
       ,DMD_IMAGE_COMMAND5
       ,DMD_FILE_EXTENSION
       ,DMD_START_DATE
       ,DMD_END_DATE
       ,DMD_ICON
       )
SELECT 
        0
       ,'XVIEW'
       ,'Xview media for documents.'
       ,'xv.sh'
       ,''
       ,''
       ,''
       ,''
       ,''
       ,''
       ,''
       ,null
       ,null
       ,'txt_icon.gif' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_MEDIA
                   WHERE DMD_ID = 0);
--
INSERT INTO DOC_MEDIA
       (DMD_ID
       ,DMD_NAME
       ,DMD_DESCR
       ,DMD_DISPLAY_COMMAND
       ,DMD_SCAN_COMMAND
       ,DMD_IMAGE_COMMAND1
       ,DMD_IMAGE_COMMAND2
       ,DMD_IMAGE_COMMAND3
       ,DMD_IMAGE_COMMAND4
       ,DMD_IMAGE_COMMAND5
       ,DMD_FILE_EXTENSION
       ,DMD_START_DATE
       ,DMD_END_DATE
       ,DMD_ICON
       )
SELECT 
        1
       ,'MORE'
       ,'Display ASCII files'
       ,'more'
       ,''
       ,''
       ,''
       ,''
       ,''
       ,''
       ,''
       ,null
       ,null
       ,'txt_icon.gif' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_MEDIA
                   WHERE DMD_ID = 1);
--
INSERT INTO DOC_MEDIA
       (DMD_ID
       ,DMD_NAME
       ,DMD_DESCR
       ,DMD_DISPLAY_COMMAND
       ,DMD_SCAN_COMMAND
       ,DMD_IMAGE_COMMAND1
       ,DMD_IMAGE_COMMAND2
       ,DMD_IMAGE_COMMAND3
       ,DMD_IMAGE_COMMAND4
       ,DMD_IMAGE_COMMAND5
       ,DMD_FILE_EXTENSION
       ,DMD_START_DATE
       ,DMD_END_DATE
       ,DMD_ICON
       )
SELECT 
        2
       ,'WORD_DOCUMENTS'
       ,'Microsoft word docs'
       ,'d:\Program Files\Microsoft Office\Office\winword'
       ,''
       ,'winword'
       ,''
       ,''
       ,''
       ,''
       ,'DOC'
       ,null
       ,null
       ,'doc_icon.gif' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_MEDIA
                   WHERE DMD_ID = 2);
--
INSERT INTO DOC_MEDIA
       (DMD_ID
       ,DMD_NAME
       ,DMD_DESCR
       ,DMD_DISPLAY_COMMAND
       ,DMD_SCAN_COMMAND
       ,DMD_IMAGE_COMMAND1
       ,DMD_IMAGE_COMMAND2
       ,DMD_IMAGE_COMMAND3
       ,DMD_IMAGE_COMMAND4
       ,DMD_IMAGE_COMMAND5
       ,DMD_FILE_EXTENSION
       ,DMD_START_DATE
       ,DMD_END_DATE
       ,DMD_ICON
       )
SELECT 
        3
       ,'WORD_TEMPLATES'
       ,'Microsoft Word Works Order Templates'
       ,'c:\Program Files\Microsoft Office\Office\winword'
       ,''
       ,'winword'
       ,''
       ,''
       ,''
       ,''
       ,'DOT'
       ,null
       ,null
       ,'doc_icon.gif' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_MEDIA
                   WHERE DMD_ID = 3);
--
INSERT INTO DOC_MEDIA
       (DMD_ID
       ,DMD_NAME
       ,DMD_DESCR
       ,DMD_DISPLAY_COMMAND
       ,DMD_SCAN_COMMAND
       ,DMD_IMAGE_COMMAND1
       ,DMD_IMAGE_COMMAND2
       ,DMD_IMAGE_COMMAND3
       ,DMD_IMAGE_COMMAND4
       ,DMD_IMAGE_COMMAND5
       ,DMD_FILE_EXTENSION
       ,DMD_START_DATE
       ,DMD_END_DATE
       ,DMD_ICON
       )
SELECT 
        4
       ,'EXCEL_DOCUMENTS'
       ,'Microsoft Excel Docs'
       ,'c:\Program Files\Microsoft Office\Office\excel'
       ,''
       ,'excel'
       ,''
       ,''
       ,''
       ,''
       ,'XLS'
       ,null
       ,null
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_MEDIA
                   WHERE DMD_ID = 4);
--
INSERT INTO DOC_MEDIA
       (DMD_ID
       ,DMD_NAME
       ,DMD_DESCR
       ,DMD_DISPLAY_COMMAND
       ,DMD_SCAN_COMMAND
       ,DMD_IMAGE_COMMAND1
       ,DMD_IMAGE_COMMAND2
       ,DMD_IMAGE_COMMAND3
       ,DMD_IMAGE_COMMAND4
       ,DMD_IMAGE_COMMAND5
       ,DMD_FILE_EXTENSION
       ,DMD_START_DATE
       ,DMD_END_DATE
       ,DMD_ICON
       )
SELECT 
        5
       ,'ADOBE_DOCUMENTS'
       ,'Adobe Docs'
       ,'C:\Program Files\Adobe\Reader 8.0\Reader\AcroRd32'
       ,''
       ,'AcroRd32'
       ,''
       ,''
       ,''
       ,''
       ,'PDF'
       ,null
       ,null
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_MEDIA
                   WHERE DMD_ID = 5);
--
INSERT INTO DOC_MEDIA
       (DMD_ID
       ,DMD_NAME
       ,DMD_DESCR
       ,DMD_DISPLAY_COMMAND
       ,DMD_SCAN_COMMAND
       ,DMD_IMAGE_COMMAND1
       ,DMD_IMAGE_COMMAND2
       ,DMD_IMAGE_COMMAND3
       ,DMD_IMAGE_COMMAND4
       ,DMD_IMAGE_COMMAND5
       ,DMD_FILE_EXTENSION
       ,DMD_START_DATE
       ,DMD_END_DATE
       ,DMD_ICON
       )
SELECT 
        6
       ,'JPEG_IMAGES'
       ,'Jpeg images'
       ,'C:\Program Files\Internet Explorer\IEXPLORE.EXE'
       ,''
       ,'iexplore'
       ,''
       ,''
       ,''
       ,''
       ,'JPG'
       ,null
       ,null
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_MEDIA
                   WHERE DMD_ID = 6);
--
INSERT INTO DOC_MEDIA
       (DMD_ID
       ,DMD_NAME
       ,DMD_DESCR
       ,DMD_DISPLAY_COMMAND
       ,DMD_SCAN_COMMAND
       ,DMD_IMAGE_COMMAND1
       ,DMD_IMAGE_COMMAND2
       ,DMD_IMAGE_COMMAND3
       ,DMD_IMAGE_COMMAND4
       ,DMD_IMAGE_COMMAND5
       ,DMD_FILE_EXTENSION
       ,DMD_START_DATE
       ,DMD_END_DATE
       ,DMD_ICON
       )
SELECT 
        7
       ,'GIF_IMAGES'
       ,'GIF images'
       ,'C:\Program Files\Internet Explorer\IEXPLORE.EXE'
       ,''
       ,'iexplore'
       ,''
       ,''
       ,''
       ,''
       ,'GIF'
       ,null
       ,null
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_MEDIA
                   WHERE DMD_ID = 7);
--
INSERT INTO DOC_MEDIA
       (DMD_ID
       ,DMD_NAME
       ,DMD_DESCR
       ,DMD_DISPLAY_COMMAND
       ,DMD_SCAN_COMMAND
       ,DMD_IMAGE_COMMAND1
       ,DMD_IMAGE_COMMAND2
       ,DMD_IMAGE_COMMAND3
       ,DMD_IMAGE_COMMAND4
       ,DMD_IMAGE_COMMAND5
       ,DMD_FILE_EXTENSION
       ,DMD_START_DATE
       ,DMD_END_DATE
       ,DMD_ICON
       )
SELECT 
        8
       ,'BMP_IMAGES'
       ,'BMP Images'
       ,'C:\Program Files\Internet Explorer\IEXPLORE.EXE'
       ,''
       ,'iexplore'
       ,''
       ,''
       ,''
       ,''
       ,'BMP'
       ,null
       ,null
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_MEDIA
                   WHERE DMD_ID = 8);
--
INSERT INTO DOC_MEDIA
       (DMD_ID
       ,DMD_NAME
       ,DMD_DESCR
       ,DMD_DISPLAY_COMMAND
       ,DMD_SCAN_COMMAND
       ,DMD_IMAGE_COMMAND1
       ,DMD_IMAGE_COMMAND2
       ,DMD_IMAGE_COMMAND3
       ,DMD_IMAGE_COMMAND4
       ,DMD_IMAGE_COMMAND5
       ,DMD_FILE_EXTENSION
       ,DMD_START_DATE
       ,DMD_END_DATE
       ,DMD_ICON
       )
SELECT 
        9
       ,'CSV_FILES'
       ,'Comma Separated Files'
       ,'c:\Program Files\Microsoft Office\Office\excel'
       ,''
       ,'excel'
       ,''
       ,''
       ,''
       ,''
       ,'CSV'
       ,null
       ,null
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_MEDIA
                   WHERE DMD_ID = 9);
--
INSERT INTO DOC_MEDIA
       (DMD_ID
       ,DMD_NAME
       ,DMD_DESCR
       ,DMD_DISPLAY_COMMAND
       ,DMD_SCAN_COMMAND
       ,DMD_IMAGE_COMMAND1
       ,DMD_IMAGE_COMMAND2
       ,DMD_IMAGE_COMMAND3
       ,DMD_IMAGE_COMMAND4
       ,DMD_IMAGE_COMMAND5
       ,DMD_FILE_EXTENSION
       ,DMD_START_DATE
       ,DMD_END_DATE
       ,DMD_ICON
       )
SELECT 
        10
       ,'OUTLOOK_MESSGES'
       ,'Outlook Messages'
       ,'C:\Program Files\Internet Explorer\IEXPLORE.EXE'
       ,''
       ,'iexplore'
       ,''
       ,''
       ,''
       ,''
       ,'MSG'
       ,null
       ,null
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_MEDIA
                   WHERE DMD_ID = 10);
--
INSERT INTO DOC_MEDIA
       (DMD_ID
       ,DMD_NAME
       ,DMD_DESCR
       ,DMD_DISPLAY_COMMAND
       ,DMD_SCAN_COMMAND
       ,DMD_IMAGE_COMMAND1
       ,DMD_IMAGE_COMMAND2
       ,DMD_IMAGE_COMMAND3
       ,DMD_IMAGE_COMMAND4
       ,DMD_IMAGE_COMMAND5
       ,DMD_FILE_EXTENSION
       ,DMD_START_DATE
       ,DMD_END_DATE
       ,DMD_ICON
       )
SELECT 
        11
       ,'WEBPAGES'
       ,'Webpages'
       ,'C:\Program Files\Internet Explorer\IEXPLORE.EXE'
       ,''
       ,'iexplore'
       ,''
       ,''
       ,''
       ,''
       ,'HTML'
       ,null
       ,null
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_MEDIA
                   WHERE DMD_ID = 11);
--
INSERT INTO DOC_MEDIA
       (DMD_ID
       ,DMD_NAME
       ,DMD_DESCR
       ,DMD_DISPLAY_COMMAND
       ,DMD_SCAN_COMMAND
       ,DMD_IMAGE_COMMAND1
       ,DMD_IMAGE_COMMAND2
       ,DMD_IMAGE_COMMAND3
       ,DMD_IMAGE_COMMAND4
       ,DMD_IMAGE_COMMAND5
       ,DMD_FILE_EXTENSION
       ,DMD_START_DATE
       ,DMD_END_DATE
       ,DMD_ICON
       )
SELECT 
        12
       ,'TEXT_DOCS'
       ,'Text docs'
       ,'C:\windows\notepad'
       ,''
       ,'notepad'
       ,''
       ,''
       ,''
       ,''
       ,'TXT'
       ,null
       ,null
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_MEDIA
                   WHERE DMD_ID = 12);
--
INSERT INTO DOC_MEDIA
       (DMD_ID
       ,DMD_NAME
       ,DMD_DESCR
       ,DMD_DISPLAY_COMMAND
       ,DMD_SCAN_COMMAND
       ,DMD_IMAGE_COMMAND1
       ,DMD_IMAGE_COMMAND2
       ,DMD_IMAGE_COMMAND3
       ,DMD_IMAGE_COMMAND4
       ,DMD_IMAGE_COMMAND5
       ,DMD_FILE_EXTENSION
       ,DMD_START_DATE
       ,DMD_END_DATE
       ,DMD_ICON
       )
SELECT 
        13
       ,'DWF_FILES'
       ,'DWF Files'
       ,'"C:\Program Files\Autodesk\Autodesk Design Review\DesignReview"'
       ,''
       ,''
       ,''
       ,''
       ,''
       ,''
       ,'DWF'
       ,null
       ,null
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_MEDIA
                   WHERE DMD_ID = 13);
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- DOC_LOCATIONS
--
-- select * from nm3_metadata.doc_locations
-- order by dlc_id
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT doc_locations
SET TERM OFF

INSERT INTO DOC_LOCATIONS
       (DLC_ID
       ,DLC_NAME
       ,DLC_PATHNAME
       ,DLC_DMD_ID
       ,DLC_DESCR
       ,DLC_START_DATE
       ,DLC_END_DATE
       ,DLC_APPS_PATHNAME
       ,DLC_URL_PATHNAME
       ,DLC_LOCATION_TYPE
       ,DLC_LOCATION_NAME
       )
SELECT 
        2
       ,'WORD_DOCS'
       ,'x:\docs\'
       ,2
       ,'Word documents populated through OLE'
       ,null
       ,null
       ,''
       ,''
       ,'DB_SERVER'
       ,'x:\docs\' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_LOCATIONS
                   WHERE DLC_ID = 2);
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- DOC_TEMPLATE_GATEWAYS
--
-- select * from nm3_metadata.doc_template_gateways
-- order by dtg_template_name
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT doc_template_gateways
SET TERM OFF

INSERT INTO DOC_TEMPLATE_GATEWAYS
       (DTG_DMD_ID
       ,DTG_OLE_TYPE
       ,DTG_TABLE_NAME
       ,DTG_TEMPLATE_NAME
       ,DTG_DLC_ID
       ,DTG_TEMPLATE_DESCR
       ,DTG_POST_RUN_PROCEDURE
       )
SELECT 
        2
       ,'WORD'
       ,'DOCS'
       ,'COMPLAIN'
       ,2
       ,'General Complaint Works Instruction'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_GATEWAYS
                   WHERE DTG_TEMPLATE_NAME = 'COMPLAIN');
--
INSERT INTO DOC_TEMPLATE_GATEWAYS
       (DTG_DMD_ID
       ,DTG_OLE_TYPE
       ,DTG_TABLE_NAME
       ,DTG_TEMPLATE_NAME
       ,DTG_DLC_ID
       ,DTG_TEMPLATE_DESCR
       ,DTG_POST_RUN_PROCEDURE
       )
SELECT 
        2
       ,'WORD'
       ,'DOC_TEMPLATE_GATEWAYS'
       ,'TEMPLATE'
       ,2
       ,'Template Report'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_GATEWAYS
                   WHERE DTG_TEMPLATE_NAME = 'TEMPLATE');
--
INSERT INTO DOC_TEMPLATE_GATEWAYS
       (DTG_DMD_ID
       ,DTG_OLE_TYPE
       ,DTG_TABLE_NAME
       ,DTG_TEMPLATE_NAME
       ,DTG_DLC_ID
       ,DTG_TEMPLATE_DESCR
       ,DTG_POST_RUN_PROCEDURE
       )
SELECT 
        2
       ,'WORD'
       ,'DOC_TEMPLATE_GATEWAYS'
       ,'TEMPLATE_W97'
       ,2
       ,'Template Report for Word97'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_GATEWAYS
                   WHERE DTG_TEMPLATE_NAME = 'TEMPLATE_W97');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- DOC_TEMPLATE_COLUMNS
--
-- select * from nm3_metadata.doc_template_columns
-- order by dtc_template_name
--         ,dtc_col_alias
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT doc_template_columns
SET TERM OFF

INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'COMPLAIN'
       ,'COMPLAINTNAME(DOC_COMPL_CPR_ID)'
       ,'VARCHAR2'
       ,'CPR_NAME'
       ,6
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'COMPLAIN'
                    AND  DTC_COL_ALIAS = 'CPR_NAME');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'COMPLAIN'
       ,'DOC_COMPL_LOCATION'
       ,'VARCHAR2'
       ,'DOC_COMPL_LOCATION'
       ,4
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'COMPLAIN'
                    AND  DTC_COL_ALIAS = 'DOC_COMPL_LOCATION');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'COMPLAIN'
       ,'DOC_COMPL_REMARKS'
       ,'VARCHAR2'
       ,'DOC_COMPL_REMARKS'
       ,8
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'COMPLAIN'
                    AND  DTC_COL_ALIAS = 'DOC_COMPL_REMARKS');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'COMPLAIN'
       ,'DOC_COMPL_TARGET'
       ,'DATE'
       ,'DOC_COMPL_TARGET'
       ,7
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'COMPLAIN'
                    AND  DTC_COL_ALIAS = 'DOC_COMPL_TARGET');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'COMPLAIN'
       ,'DOC_DESCR'
       ,'VARCHAR2'
       ,'DOC_DESCR'
       ,5
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'COMPLAIN'
                    AND  DTC_COL_ALIAS = 'DOC_DESCR');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'COMPLAIN'
       ,'DOC_ID'
       ,'NUMBER'
       ,'DOC_ID'
       ,1
       ,'Y'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'COMPLAIN'
                    AND  DTC_COL_ALIAS = 'DOC_ID');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'COMPLAIN'
       ,'DOC_STATUS_CODE'
       ,'VARCHAR2'
       ,'DOC_STATUS_CODE'
       ,3
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'COMPLAIN'
                    AND  DTC_COL_ALIAS = 'DOC_STATUS_CODE');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'COMPLAIN'
       ,'COMPLAINTUSER(DOC_COMPL_USER_ID)'
       ,'VARCHAR2'
       ,'PEO_NAME'
       ,2
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'COMPLAIN'
                    AND  DTC_COL_ALIAS = 'PEO_NAME');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(1,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B1'
       ,5
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B1');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(10,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B10'
       ,14
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B10');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(100,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B100'
       ,105
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B100');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(101,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B101'
       ,104
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B101');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(102,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B102'
       ,122
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B102');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(103,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B103'
       ,106
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B103');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(104,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B104'
       ,107
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B104');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(105,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B105'
       ,108
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B105');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(106,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B106'
       ,109
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B106');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(107,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B107'
       ,110
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B107');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(108,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B108'
       ,111
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B108');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(109,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B109'
       ,112
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B109');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(11,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B11'
       ,15
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B11');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(110,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B110'
       ,113
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B110');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(111,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B111'
       ,114
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B111');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(112,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B112'
       ,115
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B112');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(113,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B113'
       ,116
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B113');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(114,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B114'
       ,117
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B114');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(115,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B115'
       ,118
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B115');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(116,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B116'
       ,119
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B116');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(117,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B117'
       ,120
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B117');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(118,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B118'
       ,121
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B118');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(119,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B119'
       ,123
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B119');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(12,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B12'
       ,16
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B12');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(120,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B120'
       ,124
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B120');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(13,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B13'
       ,17
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B13');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(14,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B14'
       ,18
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B14');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(15,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B15'
       ,19
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B15');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(16,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B16'
       ,20
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B16');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(17,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B17'
       ,21
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B17');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(18,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B18'
       ,22
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B18');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(19,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B19'
       ,23
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B19');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(2,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B2'
       ,6
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B2');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(20,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B20'
       ,24
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B20');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(21,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B21'
       ,25
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B21');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(22,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B22'
       ,26
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B22');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(23,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B23'
       ,27
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B23');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(24,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B24'
       ,28
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B24');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(25,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B25'
       ,29
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B25');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(26,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B26'
       ,30
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B26');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(27,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B27'
       ,31
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B27');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(28,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B28'
       ,32
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B28');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(29,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B29'
       ,33
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B29');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(3,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B3'
       ,7
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B3');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(30,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B30'
       ,34
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B30');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(31,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B31'
       ,35
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B31');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(32,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B32'
       ,36
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B32');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(33,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B33'
       ,37
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B33');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(34,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B34'
       ,38
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B34');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(35,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B35'
       ,39
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B35');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(36,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B36'
       ,40
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B36');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(37,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B37'
       ,41
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B37');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(38,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B38'
       ,42
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B38');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(39,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B39'
       ,43
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B39');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(4,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B4'
       ,8
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B4');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(40,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B40'
       ,44
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B40');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(41,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B41'
       ,45
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B41');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(42,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B42'
       ,46
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B42');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(43,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B43'
       ,47
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B43');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(44,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B44'
       ,48
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B44');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(45,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B45'
       ,49
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B45');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(46,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B46'
       ,50
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B46');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(47,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B47'
       ,51
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B47');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(48,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B48'
       ,52
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B48');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(49,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B49'
       ,53
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B49');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(5,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B5'
       ,9
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B5');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(50,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B50'
       ,54
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B50');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(51,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B51'
       ,55
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B51');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(52,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B52'
       ,56
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B52');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(53,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B53'
       ,57
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B53');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(54,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B54'
       ,58
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B54');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(55,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B55'
       ,59
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B55');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(56,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B56'
       ,60
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B56');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(57,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B57'
       ,61
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B57');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(58,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B58'
       ,62
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B58');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(59,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B59'
       ,63
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B59');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(6,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B6'
       ,10
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B6');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(60,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B60'
       ,64
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B60');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(61,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B61'
       ,65
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B61');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(62,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B62'
       ,66
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B62');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(63,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B63'
       ,67
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B63');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(64,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B64'
       ,68
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B64');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(65,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B65'
       ,69
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B65');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(66,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B66'
       ,70
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B66');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(67,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B67'
       ,71
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B67');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(68,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B68'
       ,72
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B68');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(69,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B69'
       ,73
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B69');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(7,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B7'
       ,11
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B7');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(70,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B70'
       ,74
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B70');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(71,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B71'
       ,75
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B71');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(72,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B72'
       ,76
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B72');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(73,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B73'
       ,77
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B73');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(74,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B74'
       ,78
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B74');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(75,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B75'
       ,79
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B75');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(76,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B76'
       ,80
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B76');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(77,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B77'
       ,81
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B77');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(78,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B78'
       ,82
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B78');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(79,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B79'
       ,83
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B79');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(8,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B8'
       ,12
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B8');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(80,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B80'
       ,84
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B80');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(81,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B81'
       ,85
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B81');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(82,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B82'
       ,86
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B82');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(83,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B83'
       ,87
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B83');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(84,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B84'
       ,88
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B84');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(85,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B85'
       ,89
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B85');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(86,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B86'
       ,90
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B86');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(87,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B87'
       ,91
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B87');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(88,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B88'
       ,92
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B88');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(89,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B89'
       ,93
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B89');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(9,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B9'
       ,13
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B9');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(90,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B90'
       ,94
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B90');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(91,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B91'
       ,95
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B91');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(92,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B92'
       ,96
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B92');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(93,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B93'
       ,97
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B93');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(94,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B94'
       ,98
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B94');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(95,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B95'
       ,99
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B95');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(96,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B96'
       ,100
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B96');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(97,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B97'
       ,101
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B97');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(98,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B98'
       ,102
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B98');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_FIELD(99,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B99'
       ,103
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'B99');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'DTG_TEMPLATE_DESCR'
       ,'VARCHAR2'
       ,'DESCR'
       ,2
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'DESCR');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_LOCATION(DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'LOCATION'
       ,3
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'LOCATION');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_MEDIA(DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'MEDIA'
       ,4
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'MEDIA');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'DTG_TEMPLATE_NAME'
       ,'VARCHAR2'
       ,'NAME'
       ,1
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'NAME');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(1,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T1'
       ,30
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T1');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(10,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T10'
       ,39
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T10');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(100,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T100'
       ,224
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T100');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(101,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T101'
       ,226
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T101');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(102,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T102'
       ,225
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T102');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(103,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T103'
       ,227
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T103');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(104,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T104'
       ,228
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T104');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(105,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T105'
       ,229
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T105');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(106,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T106'
       ,230
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T106');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(107,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T107'
       ,231
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T107');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(108,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T108'
       ,232
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T108');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(109,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T109'
       ,233
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T109');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(11,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T11'
       ,40
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T11');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(110,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T110'
       ,234
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T110');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(111,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T111'
       ,235
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T111');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(112,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T112'
       ,236
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T112');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(113,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T113'
       ,237
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T113');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(114,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T114'
       ,238
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T114');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(115,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T115'
       ,239
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T115');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(116,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T116'
       ,240
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T116');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(117,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T117'
       ,241
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T117');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(118,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T118'
       ,242
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T118');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(119,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T119'
       ,243
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T119');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(12,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T12'
       ,41
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T12');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(120,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T120'
       ,244
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T120');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(13,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T13'
       ,42
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T13');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(14,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T14'
       ,43
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T14');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(15,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T15'
       ,44
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T15');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(16,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T16'
       ,45
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T16');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(17,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T17'
       ,46
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T17');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(18,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T18'
       ,47
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T18');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(19,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T19'
       ,48
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T19');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(2,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T2'
       ,31
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T2');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(20,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T20'
       ,49
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T20');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(21,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T21'
       ,50
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T21');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(22,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T22'
       ,51
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T22');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(23,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T23'
       ,52
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T23');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(24,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T24'
       ,53
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T24');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(25,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T25'
       ,54
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T25');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(26,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T26'
       ,150
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T26');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(27,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T27'
       ,151
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T27');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(28,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T28'
       ,152
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T28');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(29,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T29'
       ,153
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T29');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(3,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T3'
       ,32
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T3');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(30,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T30'
       ,154
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T30');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(31,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T31'
       ,155
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T31');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(32,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T32'
       ,156
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T32');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(33,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T33'
       ,157
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T33');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(34,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T34'
       ,158
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T34');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(35,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T35'
       ,159
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T35');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(36,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T36'
       ,160
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T36');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(37,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T37'
       ,161
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T37');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(38,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T38'
       ,162
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T38');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(39,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T39'
       ,163
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T39');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(4,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T4'
       ,33
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T4');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(40,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T40'
       ,164
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T40');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(41,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T41'
       ,165
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T41');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(42,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T42'
       ,166
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T42');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(43,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T43'
       ,167
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T43');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(44,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T44'
       ,168
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T44');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(45,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T45'
       ,169
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T45');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(46,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T46'
       ,170
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T46');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(47,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T47'
       ,171
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T47');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(48,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T48'
       ,172
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T48');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(49,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T49'
       ,173
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T49');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(5,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T5'
       ,34
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T5');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(50,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T50'
       ,174
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T50');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(51,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T51'
       ,175
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T51');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(52,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T52'
       ,176
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T52');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(53,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T53'
       ,177
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T53');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(54,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T54'
       ,178
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T54');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(55,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T55'
       ,179
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T55');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(56,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T56'
       ,180
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T56');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(57,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T57'
       ,181
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T57');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(58,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T58'
       ,182
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T58');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(59,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T59'
       ,183
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T59');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(6,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T6'
       ,35
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T6');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(60,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T60'
       ,184
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T60');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(61,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T61'
       ,185
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T61');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(62,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T62'
       ,186
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T62');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(63,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T63'
       ,187
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T63');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(64,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T64'
       ,188
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T64');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(65,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T65'
       ,189
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T65');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(66,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T66'
       ,190
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T66');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(67,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T67'
       ,191
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T67');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(68,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T68'
       ,192
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T68');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(69,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T69'
       ,193
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T69');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(7,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T7'
       ,36
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T7');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(70,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T70'
       ,194
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T70');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(71,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T71'
       ,195
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T71');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(72,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T72'
       ,196
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T72');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(73,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T73'
       ,197
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T73');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(74,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T74'
       ,198
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T74');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(75,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T75'
       ,199
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T75');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(76,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T76'
       ,200
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T76');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(77,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T77'
       ,201
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T77');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(78,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T78'
       ,202
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T78');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(79,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T79'
       ,203
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T79');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(8,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T8'
       ,37
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T8');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(80,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T80'
       ,204
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T80');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(81,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T81'
       ,205
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T81');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(82,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T82'
       ,206
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T82');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(83,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T83'
       ,207
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T83');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(84,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T84'
       ,208
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T84');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(85,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T85'
       ,209
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T85');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(86,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T86'
       ,210
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T86');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(87,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T87'
       ,211
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T87');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(88,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T88'
       ,212
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T88');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(89,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T89'
       ,213
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T89');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(9,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T9'
       ,38
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T9');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(90,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T90'
       ,214
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T90');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(91,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T91'
       ,215
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T91');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(92,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T92'
       ,216
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T92');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(93,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T93'
       ,217
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T93');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(94,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T94'
       ,218
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T94');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(95,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T95'
       ,219
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T95');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(96,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T96'
       ,220
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T96');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(97,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T97'
       ,221
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T97');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(98,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T98'
       ,222
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T98');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_BASE_TYPE(99,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T99'
       ,223
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'T99');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(1,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W1'
       ,55
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W1');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(10,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W10'
       ,64
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W10');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(100,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W100'
       ,344
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W100');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(101,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W101'
       ,345
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W101');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(102,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W102'
       ,346
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W102');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(103,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W103'
       ,347
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W103');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(104,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W104'
       ,348
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W104');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(105,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W105'
       ,349
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W105');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(106,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W106'
       ,350
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W106');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(107,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W107'
       ,351
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W107');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(108,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W108'
       ,352
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W108');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(109,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W109'
       ,353
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W109');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(11,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W11'
       ,65
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W11');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(110,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W110'
       ,354
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W110');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(111,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W111'
       ,355
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W111');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(112,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W112'
       ,356
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W112');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(113,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W113'
       ,357
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W113');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(114,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W114'
       ,358
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W114');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(115,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W115'
       ,359
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W115');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(116,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W116'
       ,360
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W116');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(117,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W117'
       ,361
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W117');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(118,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W118'
       ,362
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W118');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(119,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W119'
       ,363
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W119');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(12,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W12'
       ,66
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W12');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(120,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W120'
       ,364
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W120');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(13,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W13'
       ,67
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W13');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(14,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W14'
       ,68
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W14');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(15,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W15'
       ,69
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W15');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(16,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W16'
       ,70
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W16');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(17,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W17'
       ,71
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W17');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(18,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W18'
       ,72
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W18');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(19,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W19'
       ,73
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W19');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(2,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W2'
       ,56
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W2');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(20,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W20'
       ,74
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W20');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(21,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W21'
       ,75
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W21');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(22,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W22'
       ,76
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W22');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(23,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W23'
       ,77
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W23');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(24,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W24'
       ,78
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W24');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(25,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W25'
       ,79
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W25');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(26,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W26'
       ,270
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W26');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(27,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W27'
       ,271
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W27');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(28,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W28'
       ,272
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W28');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(29,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W29'
       ,273
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W29');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(3,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W3'
       ,57
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W3');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(30,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W30'
       ,274
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W30');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(31,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W31'
       ,275
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W31');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(32,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W32'
       ,276
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W32');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(33,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W33'
       ,277
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W33');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(34,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W34'
       ,278
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W34');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(35,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W35'
       ,279
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W35');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(36,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W36'
       ,280
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W36');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(37,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W37'
       ,281
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W37');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(38,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W38'
       ,282
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W38');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(39,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W39'
       ,283
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W39');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(4,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W4'
       ,58
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W4');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(40,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W40'
       ,284
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W40');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(41,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W41'
       ,285
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W41');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(42,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W42'
       ,286
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W42');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(43,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W43'
       ,287
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W43');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(44,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W44'
       ,288
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W44');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(45,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W45'
       ,289
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W45');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(46,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W46'
       ,290
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W46');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(47,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W47'
       ,291
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W47');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(48,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W48'
       ,292
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W48');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(49,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W49'
       ,293
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W49');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(5,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W5'
       ,59
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W5');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(50,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W50'
       ,294
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W50');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(51,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W51'
       ,295
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W51');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(52,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W52'
       ,296
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W52');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(53,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W53'
       ,297
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W53');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(54,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W54'
       ,298
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W54');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(55,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W55'
       ,299
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W55');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(56,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W56'
       ,300
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W56');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(57,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W57'
       ,301
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W57');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(58,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W58'
       ,302
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W58');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(59,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W59'
       ,303
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W59');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(6,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W6'
       ,60
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W6');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(60,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W60'
       ,304
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W60');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(61,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W61'
       ,305
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W61');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(62,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W62'
       ,306
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W62');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(63,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W63'
       ,307
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W63');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(64,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W64'
       ,308
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W64');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(65,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W65'
       ,309
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W65');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(66,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W66'
       ,310
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W66');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(67,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W67'
       ,311
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W67');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(68,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W68'
       ,312
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W68');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(69,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W69'
       ,313
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W69');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(7,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W7'
       ,61
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W7');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(70,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W70'
       ,314
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W70');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(71,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W71'
       ,315
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W71');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(72,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W72'
       ,316
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W72');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(73,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W73'
       ,317
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W73');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(74,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W74'
       ,318
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W74');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(75,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W75'
       ,319
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W75');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(76,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W76'
       ,320
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W76');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(77,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W77'
       ,321
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W77');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(78,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W78'
       ,322
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W78');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(79,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W79'
       ,323
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W79');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(8,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W8'
       ,62
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W8');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(80,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W80'
       ,324
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W80');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(81,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W81'
       ,325
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W81');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(82,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W82'
       ,326
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W82');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(83,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W83'
       ,327
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W83');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(84,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W84'
       ,328
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W84');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(85,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W85'
       ,329
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W85');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(86,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W86'
       ,330
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W86');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(87,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W87'
       ,331
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W87');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(88,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W88'
       ,332
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W88');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(89,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W89'
       ,333
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W89');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(9,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W9'
       ,63
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W9');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(90,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W90'
       ,334
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W90');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(91,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W91'
       ,335
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W91');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(92,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W92'
       ,336
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W92');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(93,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W93'
       ,337
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W93');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(94,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W94'
       ,338
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W94');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(95,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W95'
       ,339
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W95');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(96,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W96'
       ,340
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W96');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(97,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W97'
       ,341
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W97');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(98,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W98'
       ,342
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W98');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE'
       ,'TEMPLATES.GET_WORD_FIELD(99,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W99'
       ,343
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE'
                    AND  DTC_COL_ALIAS = 'W99');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(1,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B1'
       ,5
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B1');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(10,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B10'
       ,14
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B10');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(100,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B100'
       ,104
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B100');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(101,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B101'
       ,105
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B101');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(102,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B102'
       ,106
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B102');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(103,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B103'
       ,107
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B103');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(104,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B104'
       ,108
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B104');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(105,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B105'
       ,109
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B105');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(106,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B106'
       ,110
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B106');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(107,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B107'
       ,111
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B107');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(108,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B108'
       ,112
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B108');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(109,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B109'
       ,113
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B109');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(11,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B11'
       ,15
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B11');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(110,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B110'
       ,114
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B110');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(111,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B111'
       ,115
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B111');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(112,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B112'
       ,116
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B112');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(113,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B113'
       ,117
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B113');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(114,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B114'
       ,118
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B114');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(115,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B115'
       ,119
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B115');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(116,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B116'
       ,120
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B116');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(117,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B117'
       ,121
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B117');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(118,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B118'
       ,122
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B118');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(119,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B119'
       ,123
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B119');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(12,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B12'
       ,16
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B12');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(120,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B120'
       ,124
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B120');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(13,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B13'
       ,17
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B13');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(14,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B14'
       ,18
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B14');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(15,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B15'
       ,19
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B15');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(16,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B16'
       ,20
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B16');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(17,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B17'
       ,21
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B17');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(18,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B18'
       ,22
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B18');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(19,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B19'
       ,23
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B19');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(2,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B2'
       ,6
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B2');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(20,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B20'
       ,24
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B20');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(21,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B21'
       ,25
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B21');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(22,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B22'
       ,26
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B22');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(23,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B23'
       ,27
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B23');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(24,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B24'
       ,28
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B24');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(25,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B25'
       ,29
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B25');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(26,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B26'
       ,30
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B26');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(27,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B27'
       ,31
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B27');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(28,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B28'
       ,32
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B28');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(29,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B29'
       ,33
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B29');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(3,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B3'
       ,7
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B3');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(30,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B30'
       ,34
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B30');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(31,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B31'
       ,35
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B31');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(32,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B32'
       ,36
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B32');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(33,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B33'
       ,37
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B33');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(34,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B34'
       ,38
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B34');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(35,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B35'
       ,39
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B35');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(36,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B36'
       ,40
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B36');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(37,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B37'
       ,41
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B37');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(38,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B38'
       ,42
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B38');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(39,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B39'
       ,43
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B39');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(4,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B4'
       ,8
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B4');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(40,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B40'
       ,44
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B40');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(41,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B41'
       ,45
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B41');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(42,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B42'
       ,46
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B42');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(43,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B43'
       ,47
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B43');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(44,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B44'
       ,48
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B44');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(45,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B45'
       ,49
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B45');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(46,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B46'
       ,50
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B46');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(47,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B47'
       ,51
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B47');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(48,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B48'
       ,52
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B48');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(49,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B49'
       ,53
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B49');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(5,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B5'
       ,9
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B5');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(50,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B50'
       ,54
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B50');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(51,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B51'
       ,55
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B51');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(52,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B52'
       ,56
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B52');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(53,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B53'
       ,57
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B53');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(54,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B54'
       ,58
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B54');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(55,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B55'
       ,59
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B55');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(56,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B56'
       ,60
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B56');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(57,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B57'
       ,61
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B57');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(58,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B58'
       ,62
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B58');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(59,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B59'
       ,63
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B59');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(6,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B6'
       ,10
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B6');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(60,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B60'
       ,64
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B60');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(61,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B61'
       ,65
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B61');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(62,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B62'
       ,66
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B62');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(63,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B63'
       ,67
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B63');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(64,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B64'
       ,68
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B64');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(65,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B65'
       ,69
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B65');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(66,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B66'
       ,70
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B66');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(67,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B67'
       ,71
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B67');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(68,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B68'
       ,72
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B68');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(69,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B69'
       ,73
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B69');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(7,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B7'
       ,11
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B7');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(70,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B70'
       ,74
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B70');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(71,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B71'
       ,75
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B71');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(72,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B72'
       ,76
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B72');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(73,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B73'
       ,77
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B73');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(74,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B74'
       ,78
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B74');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(75,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B75'
       ,79
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B75');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(76,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B76'
       ,80
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B76');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(77,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B77'
       ,81
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B77');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(78,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B78'
       ,82
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B78');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(79,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B79'
       ,83
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B79');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(8,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B8'
       ,12
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B8');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(80,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B80'
       ,84
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B80');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(81,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B81'
       ,85
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B81');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(82,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B82'
       ,86
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B82');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(83,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B83'
       ,87
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B83');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(84,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B84'
       ,88
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B84');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(85,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B85'
       ,89
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B85');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(86,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B86'
       ,90
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B86');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(87,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B87'
       ,91
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B87');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(88,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B88'
       ,92
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B88');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(89,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B89'
       ,93
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B89');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(9,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B9'
       ,13
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B9');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(90,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B90'
       ,94
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B90');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(91,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B91'
       ,95
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B91');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(92,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B92'
       ,96
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B92');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(93,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B93'
       ,97
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B93');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(94,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B94'
       ,98
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B94');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(95,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B95'
       ,99
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B95');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(96,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B96'
       ,100
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B96');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(97,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B97'
       ,101
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B97');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(98,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B98'
       ,102
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B98');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_FIELD(99,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'B99'
       ,103
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'B99');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'DTG_TEMPLATE_DESCR'
       ,'VARCHAR2'
       ,'DESCR'
       ,2
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'DESCR');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_LOCATION(DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'LOCATION'
       ,3
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'LOCATION');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_MEDIA(DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'MEDIA'
       ,4
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'MEDIA');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'DTG_TEMPLATE_NAME'
       ,'VARCHAR2'
       ,'NAME'
       ,1
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'NAME');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(1,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T1'
       ,125
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T1');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(10,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T10'
       ,134
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T10');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(100,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T100'
       ,224
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T100');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(101,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T101'
       ,225
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T101');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(102,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T102'
       ,226
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T102');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(103,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T103'
       ,227
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T103');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(104,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T104'
       ,228
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T104');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(105,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T105'
       ,229
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T105');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(106,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T106'
       ,230
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T106');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(107,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T107'
       ,231
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T107');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(108,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T108'
       ,232
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T108');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(109,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T109'
       ,233
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T109');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(11,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T11'
       ,135
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T11');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(110,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T110'
       ,234
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T110');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(111,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T111'
       ,235
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T111');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(112,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T112'
       ,236
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T112');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(113,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T113'
       ,237
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T113');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(114,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T114'
       ,238
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T114');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(115,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T115'
       ,239
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T115');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(116,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T116'
       ,240
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T116');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(117,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T117'
       ,241
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T117');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(118,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T118'
       ,242
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T118');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(119,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T119'
       ,243
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T119');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(12,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T12'
       ,136
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T12');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(120,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T120'
       ,244
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T120');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(13,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T13'
       ,137
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T13');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(14,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T14'
       ,138
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T14');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(15,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T15'
       ,139
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T15');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(16,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T16'
       ,140
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T16');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(17,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T17'
       ,141
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T17');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(18,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T18'
       ,142
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T18');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(19,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T19'
       ,143
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T19');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(2,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T2'
       ,126
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T2');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(20,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T20'
       ,144
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T20');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(21,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T21'
       ,145
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T21');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(22,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T22'
       ,146
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T22');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(23,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T23'
       ,147
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T23');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(24,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T24'
       ,148
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T24');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(25,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T25'
       ,149
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T25');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(26,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T26'
       ,150
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T26');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(27,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T27'
       ,151
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T27');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(28,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T28'
       ,152
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T28');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(29,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T29'
       ,153
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T29');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(3,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T3'
       ,127
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T3');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(30,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T30'
       ,154
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T30');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(31,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T31'
       ,155
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T31');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(32,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T32'
       ,156
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T32');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(33,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T33'
       ,157
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T33');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(34,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T34'
       ,158
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T34');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(35,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T35'
       ,159
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T35');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(36,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T36'
       ,160
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T36');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(37,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T37'
       ,161
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T37');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(38,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T38'
       ,162
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T38');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(39,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T39'
       ,163
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T39');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(4,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T4'
       ,128
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T4');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(40,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T40'
       ,164
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T40');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(41,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T41'
       ,165
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T41');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(42,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T42'
       ,166
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T42');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(43,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T43'
       ,167
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T43');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(44,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T44'
       ,168
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T44');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(45,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T45'
       ,169
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T45');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(46,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T46'
       ,170
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T46');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(47,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T47'
       ,171
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T47');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(48,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T48'
       ,172
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T48');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(49,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T49'
       ,173
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T49');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(5,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T5'
       ,129
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T5');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(50,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T50'
       ,174
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T50');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(51,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T51'
       ,175
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T51');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(52,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T52'
       ,176
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T52');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(53,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T53'
       ,177
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T53');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(54,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T54'
       ,178
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T54');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(55,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T55'
       ,179
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T55');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(56,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T56'
       ,180
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T56');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(57,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T57'
       ,181
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T57');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(58,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T58'
       ,182
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T58');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(59,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T59'
       ,183
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T59');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(6,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T6'
       ,130
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T6');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(60,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T60'
       ,184
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T60');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(61,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T61'
       ,185
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T61');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(62,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T62'
       ,186
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T62');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(63,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T63'
       ,187
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T63');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(64,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T64'
       ,188
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T64');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(65,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T65'
       ,189
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T65');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(66,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T66'
       ,190
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T66');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(67,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T67'
       ,191
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T67');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(68,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T68'
       ,192
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T68');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(69,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T69'
       ,193
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T69');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(7,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T7'
       ,131
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T7');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(70,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T70'
       ,194
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T70');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(71,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T71'
       ,195
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T71');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(72,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T72'
       ,196
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T72');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(73,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T73'
       ,197
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T73');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(74,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T74'
       ,198
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T74');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(75,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T75'
       ,199
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T75');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(76,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T76'
       ,200
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T76');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(77,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T77'
       ,201
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T77');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(78,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T78'
       ,202
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T78');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(79,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T79'
       ,203
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T79');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(8,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T8'
       ,132
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T8');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(80,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T80'
       ,204
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T80');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(81,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T81'
       ,205
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T81');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(82,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T82'
       ,206
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T82');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(83,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T83'
       ,207
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T83');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(84,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T84'
       ,208
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T84');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(85,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T85'
       ,209
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T85');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(86,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T86'
       ,210
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T86');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(87,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T87'
       ,211
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T87');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(88,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T88'
       ,212
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T88');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(89,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T89'
       ,213
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T89');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(9,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T9'
       ,133
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T9');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(90,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T90'
       ,214
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T90');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(91,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T91'
       ,215
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T91');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(92,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T92'
       ,216
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T92');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(93,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T93'
       ,217
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T93');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(94,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T94'
       ,218
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T94');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(95,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T95'
       ,219
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T95');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(96,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T96'
       ,220
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T96');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(97,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T97'
       ,221
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T97');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(98,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T98'
       ,222
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T98');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_BASE_TYPE(99,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'T99'
       ,223
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'T99');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(1,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W1'
       ,245
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W1');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(10,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W10'
       ,254
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W10');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(100,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W100'
       ,344
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W100');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(101,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W101'
       ,345
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W101');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(102,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W102'
       ,346
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W102');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(103,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W103'
       ,347
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W103');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(104,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W104'
       ,348
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W104');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(105,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W105'
       ,349
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W105');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(106,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W106'
       ,350
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W106');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(107,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W107'
       ,351
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W107');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(108,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W108'
       ,352
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W108');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(109,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W109'
       ,353
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W109');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(11,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W11'
       ,255
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W11');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(110,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W110'
       ,354
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W110');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(111,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W111'
       ,355
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W111');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(112,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W112'
       ,356
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W112');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(113,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W113'
       ,357
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W113');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(114,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W114'
       ,358
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W114');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(115,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W115'
       ,359
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W115');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(116,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W116'
       ,360
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W116');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(117,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W117'
       ,361
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W117');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(118,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W118'
       ,362
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W118');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(119,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W119'
       ,363
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W119');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(12,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W12'
       ,256
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W12');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(120,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W120'
       ,364
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W120');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(13,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W13'
       ,257
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W13');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(14,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W14'
       ,258
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W14');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(15,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W15'
       ,259
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W15');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(16,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W16'
       ,260
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W16');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(17,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W17'
       ,261
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W17');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(18,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W18'
       ,262
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W18');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(19,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W19'
       ,263
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W19');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(2,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W2'
       ,246
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W2');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(20,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W20'
       ,264
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W20');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(21,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W21'
       ,265
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W21');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(22,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W22'
       ,266
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W22');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(23,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W23'
       ,267
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W23');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(24,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W24'
       ,268
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W24');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(25,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W25'
       ,269
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W25');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(26,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W26'
       ,270
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W26');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(27,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W27'
       ,271
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W27');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(28,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W28'
       ,272
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W28');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(29,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W29'
       ,273
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W29');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(3,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W3'
       ,247
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W3');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(30,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W30'
       ,274
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W30');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(31,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W31'
       ,275
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W31');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(32,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W32'
       ,276
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W32');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(33,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W33'
       ,277
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W33');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(34,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W34'
       ,278
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W34');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(35,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W35'
       ,279
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W35');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(36,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W36'
       ,280
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W36');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(37,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W37'
       ,281
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W37');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(38,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W38'
       ,282
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W38');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(39,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W39'
       ,283
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W39');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(4,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W4'
       ,248
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W4');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(40,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W40'
       ,284
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W40');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(41,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W41'
       ,285
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W41');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(42,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W42'
       ,286
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W42');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(43,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W43'
       ,287
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W43');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(44,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W44'
       ,288
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W44');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(45,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W45'
       ,289
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W45');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(46,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W46'
       ,290
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W46');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(47,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W47'
       ,291
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W47');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(48,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W48'
       ,292
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W48');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(49,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W49'
       ,293
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W49');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(5,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W5'
       ,249
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W5');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(50,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W50'
       ,294
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W50');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(51,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W51'
       ,295
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W51');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(52,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W52'
       ,296
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W52');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(53,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W53'
       ,297
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W53');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(54,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W54'
       ,298
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W54');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(55,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W55'
       ,299
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W55');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(56,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W56'
       ,300
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W56');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(57,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W57'
       ,301
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W57');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(58,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W58'
       ,302
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W58');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(59,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W59'
       ,303
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W59');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(6,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W6'
       ,250
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W6');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(60,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W60'
       ,304
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W60');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(61,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W61'
       ,305
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W61');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(62,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W62'
       ,306
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W62');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(63,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W63'
       ,307
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W63');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(64,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W64'
       ,308
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W64');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(65,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W65'
       ,309
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W65');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(66,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W66'
       ,310
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W66');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(67,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W67'
       ,311
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W67');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(68,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W68'
       ,312
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W68');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(69,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W69'
       ,313
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W69');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(7,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W7'
       ,251
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W7');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(70,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W70'
       ,314
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W70');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(71,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W71'
       ,315
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W71');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(72,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W72'
       ,316
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W72');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(73,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W73'
       ,317
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W73');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(74,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W74'
       ,318
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W74');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(75,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W75'
       ,319
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W75');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(76,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W76'
       ,320
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W76');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(77,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W77'
       ,321
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W77');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(78,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W78'
       ,322
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W78');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(79,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W79'
       ,323
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W79');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(8,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W8'
       ,252
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W8');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(80,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W80'
       ,324
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W80');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(81,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W81'
       ,325
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W81');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(82,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W82'
       ,326
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W82');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(83,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W83'
       ,327
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W83');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(84,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W84'
       ,328
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W84');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(85,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W85'
       ,329
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W85');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(86,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W86'
       ,330
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W86');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(87,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W87'
       ,331
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W87');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(88,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W88'
       ,332
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W88');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(89,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W89'
       ,333
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W89');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(9,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W9'
       ,253
       ,'N'
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W9');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(90,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W90'
       ,334
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W90');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(91,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W91'
       ,335
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W91');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(92,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W92'
       ,336
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W92');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(93,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W93'
       ,337
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W93');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(94,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W94'
       ,338
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W94');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(95,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W95'
       ,339
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W95');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(96,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W96'
       ,340
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W96');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(97,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W97'
       ,341
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W97');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(98,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W98'
       ,342
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W98');
--
INSERT INTO DOC_TEMPLATE_COLUMNS
       (DTC_TEMPLATE_NAME
       ,DTC_COL_NAME
       ,DTC_COL_TYPE
       ,DTC_COL_ALIAS
       ,DTC_COL_SEQ
       ,DTC_USED_IN_PROC
       ,DTC_IMAGE_FILE
       ,DTC_FUNCTION
       )
SELECT 
        'TEMPLATE_W97'
       ,'TEMPLATES.GET_WORD_FIELD(99,DTG_TEMPLATE_NAME)'
       ,'VARCHAR2'
       ,'W99'
       ,343
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TEMPLATE_COLUMNS
                   WHERE DTC_TEMPLATE_NAME = 'TEMPLATE_W97'
                    AND  DTC_COL_ALIAS = 'W99');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- DOC_ENQUIRY_TYPES
--
-- select * from nm3_metadata.doc_enquiry_types
-- order by det_dtp_code
--         ,det_dcl_code
--         ,det_code
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT doc_enquiry_types
SET TERM OFF

--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- HIG_USERS
--
-- select * from nm3_metadata.hig_users
-- order by hus_user_id
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT hig_users
SET TERM OFF

INSERT INTO HIG_USERS
       (HUS_USER_ID
       ,HUS_INITIALS
       ,HUS_NAME
       ,HUS_USERNAME
       ,HUS_JOB_TITLE
       ,HUS_AGENT_CODE
       ,HUS_WOR_FLAG
       ,HUS_WOR_VALUE_MIN
       ,HUS_WOR_VALUE_MAX
       ,HUS_START_DATE
       ,HUS_END_DATE
       ,HUS_ADMIN_UNIT
       ,HUS_UNRESTRICTED
       ,HUS_WOR_AUR_MIN
       ,HUS_WOR_AUR_MAX
       ,HUS_IS_HIG_OWNER_FLAG
       )
SELECT 
        1
       ,'SYS'
       ,'System Administrator'
       ,'HIGHWAYS'
       ,'SUPV'
       ,''
       ,''
       ,null
       ,null
       ,to_date('20000101000000','YYYYMMDDHH24MISS')
       ,null
       ,1
       ,'Y'
       ,null
       ,null
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_USERS
                   WHERE HUS_USER_ID = 1);
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- HIG_USER_FAVOURITES
--
-- select * from nm3_metadata.hig_user_favourites
-- order by huf_user_id
--         ,huf_parent
--         ,huf_child
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT hig_user_favourites
SET TERM OFF

INSERT INTO HIG_USER_FAVOURITES
       (HUF_USER_ID
       ,HUF_PARENT
       ,HUF_CHILD
       ,HUF_DESCR
       ,HUF_TYPE
       )
SELECT 
        1
       ,'ROOT'
       ,'FAVOURITES'
       ,'System Administrators Favourite Modules'
       ,'F' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_USER_FAVOURITES
                   WHERE HUF_USER_ID = 1
                    AND  HUF_PARENT = 'ROOT'
                    AND  HUF_CHILD = 'FAVOURITES');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- HIG_SYSTEM_FAVOURITES
--
-- select * from nm3_metadata.hig_system_favourites
-- order by hsf_user_id
--         ,hsf_parent
--         ,hsf_child
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT hig_system_favourites
SET TERM OFF

INSERT INTO HIG_SYSTEM_FAVOURITES
       (HSF_USER_ID
       ,HSF_PARENT
       ,HSF_CHILD
       ,HSF_DESCR
       ,HSF_TYPE
       )
SELECT 
        1
       ,'ROOT'
       ,'FAVOURITES'
       ,'System Favourites'
       ,'F' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SYSTEM_FAVOURITES
                   WHERE HSF_USER_ID = 1
                    AND  HSF_PARENT = 'ROOT'
                    AND  HSF_CHILD = 'FAVOURITES');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- NM_LOAD_DESTINATIONS
--
-- select * from nm3_metadata.nm_load_destinations
-- order by nld_id
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_load_destinations
SET TERM OFF

INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        4
       ,'NM_LD_MC_ALL_INV_TMP'
       ,'MIT'
       ,'NM3MAPCAPTURE_INS_INV.INS_INV'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 4);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        34
       ,'NM_NODES_ALL'
       ,'NO_'
       ,'NM3INS.INS_NO_ALL'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 34);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        35
       ,'NM_POINTS'
       ,'NP'
       ,'NM3INS.INS_NP'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 35);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        44
       ,'V_LOAD_POINT_INV_MEM_ON_ELE'
       ,'LIPE'
       ,'nm3inv_load.load_point_on_ele'
       ,'nm3inv_load.validate_point_on_ele' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 44);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        47
       ,'NM_INV_ITEMS'
       ,'IIT'
       ,'NM3INS.INS_IIT_ALL'
       ,'NM3INV.VALIDATE_REC_IIT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 47);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        64
       ,'V_LOAD_RESIZE_ROUTE'
       ,'V_RSZ'
       ,'NM3NET_LOAD.RESIZE_ROUTE'
       ,'NM3NET_LOAD.VALIDATE_RESIZE_ROUTE' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 64);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        84
       ,'V_LOAD_LOCATE_INV_BY_REF'
       ,'LIBR'
       ,'nm3mp_ref.locate_asset'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 84);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        104
       ,'NM_NW_AD_LINK_ALL'
       ,'NWAD'
       ,' NM3NWAD.INS_NADL'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 104);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        501
       ,'V_LOAD_RESCALE_ROUTE'
       ,'V_RSC'
       ,'NM3NET_LOAD.RESCALE_ROUTE'
       ,'NM3NET_LOAD.VALIDATE_RESCALE_ROUTE' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 501);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        502
       ,'V_LOAD_RESEQ_ROUTE'
       ,'V_RSQ'
       ,'NM3NET_LOAD.RESEQ_ROUTE'
       ,'NM3NET_LOAD.VALIDATE_RESEQ_ROUTE' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 502);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        503
       ,'V_LOAD_DISTANCE_BREAK'
       ,'V_DB'
       ,'NM3NET_LOAD.CREATE_DISTANCE_BREAK'
       ,'NM3NET_LOAD.VALIDATE_DISTANCE_BREAK' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 503);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1001
       ,'DOCS'
       ,'DOC'
       ,'nm3ins.ins_doc'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1001);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1002
       ,'DOC_ACTIONS'
       ,'DAC'
       ,'nm3ins.ins_dac'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1002);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1003
       ,'DOC_ACTION_HISTORY'
       ,'DAH'
       ,'nm3ins.ins_dah'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1003);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1004
       ,'DOC_ASSOCS'
       ,'DAS'
       ,'nm3ins.ins_das'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1004);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1005
       ,'DOC_CLASS'
       ,'DCL'
       ,'nm3ins.ins_dcl'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1005);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1007
       ,'DOC_CONTACT_ADDRESS'
       ,'HCT'
       ,'nm3ins.ins_hct'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1007);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1008
       ,'DOC_COPIES'
       ,'DCP'
       ,'nm3ins.ins_dcp'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1008);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1009
       ,'DOC_DAMAGE'
       ,'DDG'
       ,'nm3ins.ins_ddg'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1009);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1010
       ,'DOC_DAMAGE_COSTS'
       ,'DDC'
       ,'nm3ins.ins_ddc'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1010);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1011
       ,'DOC_ENQUIRY_CONTACTS'
       ,'DEC_'
       ,'nm3ins.ins_dec'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1011);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1012
       ,'DOC_ENQUIRY_TYPES'
       ,'DET'
       ,'nm3ins.ins_det'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1012);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1013
       ,'DOC_GATEWAYS'
       ,'DGT'
       ,'nm3ins.ins_dgt'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1013);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1014
       ,'DOC_GATE_SYNS'
       ,'DGS'
       ,'nm3ins.ins_dgs'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1014);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1015
       ,'DOC_HISTORY'
       ,'DHI'
       ,'nm3ins.ins_dhi'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1015);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1016
       ,'DOC_KEYS'
       ,'DKY'
       ,'nm3ins.ins_dky'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1016);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1017
       ,'DOC_KEYWORDS'
       ,'DKW'
       ,'nm3ins.ins_dkw'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1017);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1018
       ,'DOC_LOCATIONS'
       ,'DLC'
       ,'nm3ins.ins_dlc'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1018);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1019
       ,'DOC_LOV_RECS'
       ,'DLR'
       ,'nm3ins.ins_dlr'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1019);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1020
       ,'DOC_MEDIA'
       ,'DMD'
       ,'nm3ins.ins_dmd'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1020);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1021
       ,'DOC_QUERY'
       ,'DQ'
       ,'nm3ins.ins_dq'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1021);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1022
       ,'DOC_QUERY_COLS'
       ,'DQC'
       ,'nm3ins.ins_dqc'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1022);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1023
       ,'DOC_STD_ACTIONS'
       ,'DSA'
       ,'nm3ins.ins_dsa'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1023);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1024
       ,'DOC_STD_COSTS'
       ,'DSC'
       ,'nm3ins.ins_dsc'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1024);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1025
       ,'DOC_SYNONYMS'
       ,'DSY'
       ,'nm3ins.ins_dsy'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1025);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1026
       ,'DOC_TEMPLATE_COLUMNS'
       ,'DTC'
       ,'nm3ins.ins_dtc'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1026);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1027
       ,'DOC_TEMPLATE_GATEWAYS'
       ,'DTG'
       ,'nm3ins.ins_dtg'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1027);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1028
       ,'DOC_TEMPLATE_USERS'
       ,'DTU'
       ,'nm3ins.ins_dtu'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1028);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1029
       ,'DOC_TYPES'
       ,'DTP'
       ,'nm3ins.ins_dtp'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1029);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1030
       ,'GIS_THEMES_ALL'
       ,'GT'
       ,'nm3ins.ins_gt'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1030);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1031
       ,'GIS_THEME_FUNCTIONS_ALL'
       ,'GTF'
       ,'nm3ins.ins_gtf'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1031);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1032
       ,'GIS_THEME_ROLES'
       ,'GTHR'
       ,'nm3ins.ins_gthr'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1032);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1033
       ,'GRI_LOV'
       ,'GL'
       ,'nm3ins.ins_gl'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1033);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1034
       ,'GRI_MODULES'
       ,'GRM'
       ,'nm3ins.ins_grm'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1034);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1035
       ,'GRI_MODULE_PARAMS'
       ,'GMP'
       ,'nm3ins.ins_gmp'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1035);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1036
       ,'GRI_PARAMS'
       ,'GP'
       ,'nm3ins.ins_gp'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1036);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1037
       ,'GRI_PARAM_DEPENDENCIES'
       ,'GPD'
       ,'nm3ins.ins_gpd'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1037);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1038
       ,'GRI_PARAM_LOOKUP'
       ,'GPL'
       ,'nm3ins.ins_gpl'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1038);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1043
       ,'GRI_SPOOL'
       ,'GRS'
       ,'nm3ins.ins_grs'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1043);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1044
       ,'HIG_ADDRESS'
       ,'HAD'
       ,'nm3ins.ins_had'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1044);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1045
       ,'HIG_CODES'
       ,'HCO'
       ,'nm3ins.ins_hco'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1045);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1046
       ,'HIG_COLOURS'
       ,'HCL'
       ,'nm3ins.ins_hcl'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1046);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1048
       ,'HIG_CONTACT_ADDRESS'
       ,'HCA'
       ,'nm3ins.ins_hca'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1048);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1049
       ,'HIG_DOMAINS'
       ,'HDO'
       ,'nm3ins.ins_hdo'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1049);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1050
       ,'HIG_ERRORS'
       ,'HER'
       ,'nm3ins.ins_her'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1050);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1051
       ,'HIG_HOLIDAYS'
       ,'HHO'
       ,'nm3ins.ins_hho'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1051);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1052
       ,'HIG_MODULES'
       ,'HMO'
       ,'nm3ins.ins_hmo'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1052);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1053
       ,'HIG_MODULE_HISTORY'
       ,'HMH'
       ,'nm3ins.ins_hmh'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1053);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1054
       ,'HIG_MODULE_KEYWORDS'
       ,'HMK'
       ,'nm3ins.ins_hmk'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1054);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1055
       ,'HIG_MODULE_ROLES'
       ,'HMR'
       ,'nm3ins.ins_hmr'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1055);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1056
       ,'HIG_MODULE_USAGES'
       ,'HMU'
       ,'nm3ins.ins_hmu'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1056);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1057
       ,'HIG_OPTION_LIST'
       ,'HOL'
       ,'nm3ins.ins_hol'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1057);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1058
       ,'HIG_OPTION_VALUES'
       ,'HOV'
       ,'nm3ins.ins_hov'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1058);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1059
       ,'HIG_STATUS_CODES'
       ,'HSC'
       ,'nm3ins.ins_hsc'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1059);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1060
       ,'HIG_STATUS_DOMAINS'
       ,'HSD'
       ,'nm3ins.ins_hsd'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1060);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1061
       ,'HIG_USER_OPTIONS'
       ,'HUO'
       ,'nm3ins.ins_huo'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1061);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1062
       ,'NM_ADMIN_GROUPS'
       ,'NAG'
       ,'nm3ins.ins_nag'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1062);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1063
       ,'NM_ADMIN_UNITS_ALL'
       ,'NAU'
       ,'nm3ins.ins_nau_all'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1063);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1064
       ,'NM_AUDIT_ACTIONS'
       ,'NAA'
       ,'nm3ins.ins_naa'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1064);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1065
       ,'NM_AUDIT_CHANGES'
       ,'NACH'
       ,'nm3ins.ins_nach'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1065);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1066
       ,'NM_AUDIT_COLUMNS'
       ,'NAC'
       ,'nm3ins.ins_nac'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1066);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1067
       ,'NM_AUDIT_KEY_COLS'
       ,'NKC'
       ,'nm3ins.ins_nkc'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1067);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1068
       ,'NM_AUDIT_TABLES'
       ,'NATAB'
       ,'nm3ins.ins_natab'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1068);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1069
       ,'NM_AUDIT_TEMP'
       ,'NATMP'
       ,'nm3ins.ins_natmp'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1069);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1070
       ,'NM_AU_TYPES'
       ,'NAT'
       ,'nm3ins.ins_nat'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1070);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1071
       ,'NM_ELEMENTS_ALL'
       ,'NE'
       ,'NM3NET.INSERT_ANY_ELEMENT'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1071);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1072
       ,'NM_ERRORS'
       ,'NER'
       ,'nm3ins.ins_ner'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1072);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1073
       ,'NM_EVENT_ALERT_MAILS'
       ,'NEA'
       ,'nm3ins.ins_nea'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1073);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1074
       ,'NM_EVENT_LOG'
       ,'NEL'
       ,'nm3ins.ins_nel'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1074);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1075
       ,'NM_EVENT_TYPES'
       ,'NET'
       ,'nm3ins.ins_net'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1075);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1076
       ,'NM_FILL_PATTERNS'
       ,'NFP'
       ,'nm3ins.ins_nfp'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1076);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1077
       ,'NM_GROUP_RELATIONS_ALL'
       ,'NGR'
       ,'nm3ins.ins_ngr_all'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1077);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1078
       ,'NM_GROUP_TYPES_ALL'
       ,'NGT'
       ,'nm3ins.ins_ngt_all'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1078);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1079
       ,'NM_INV_ATTRI_LOOKUP_ALL'
       ,'IAL'
       ,'nm3ins.ins_ial_all'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1079);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1080
       ,'NM_INV_CATEGORIES'
       ,'NIC'
       ,'nm3ins.ins_nic'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1080);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1081
       ,'NM_INV_CATEGORY_MODULES'
       ,'ICM'
       ,'nm3ins.ins_icm'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1081);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1082
       ,'NM_INV_DOMAINS_ALL'
       ,'ID_'
       ,'nm3ins.ins_id_all'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1082);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1084
       ,'NM_INV_ITEM_GROUPINGS_ALL'
       ,'IIG'
       ,'nm3ins.ins_iig_all'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1084);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1085
       ,'NM_INV_NW_ALL'
       ,'NIN'
       ,'nm3ins.ins_nin_all'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1085);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1086
       ,'NM_INV_TYPES_ALL'
       ,'NIT'
       ,'nm3ins.ins_nit_all'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1086);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1087
       ,'NM_INV_TYPE_ATTRIBS_ALL'
       ,'ITA'
       ,'nm3ins.ins_ita_all'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1087);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1088
       ,'NM_INV_TYPE_ATTRIB_BANDINGS'
       ,'ITB'
       ,'nm3ins.ins_itb'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1088);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1089
       ,'NM_INV_TYPE_ATTRIB_BAND_DETS'
       ,'ITD'
       ,'nm3ins.ins_itd'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1089);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1090
       ,'NM_INV_TYPE_COLOURS'
       ,'NITC'
       ,'nm3ins.ins_nitc'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1090);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1091
       ,'NM_INV_TYPE_GROUPINGS_ALL'
       ,'ITG'
       ,'nm3ins.ins_itg_all'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1091);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1092
       ,'NM_INV_TYPE_ROLES'
       ,'ITR'
       ,'nm3ins.ins_itr'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1092);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1093
       ,'NM_JOB_CONTROL'
       ,'NJC'
       ,'nm3job_load.load_njc'
       ,'nm3job_load.validate_njc' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1093);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1094
       ,'NM_JOB_OPERATIONS'
       ,'NJO'
       ,'nm3ins.ins_njo'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1094);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1095
       ,'NM_JOB_OPERATION_DATA_VALUES'
       ,'NJV'
       ,'nm3ins.ins_njv'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1095);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1096
       ,'NM_JOB_TYPES'
       ,'NJT'
       ,'nm3ins.ins_njt'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1096);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1097
       ,'NM_JOB_TYPES_OPERATIONS'
       ,'JTO'
       ,'nm3ins.ins_jto'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1097);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1098
       ,'NM_LAYERS'
       ,'NL'
       ,'nm3ins.ins_nl'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1098);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1099
       ,'NM_LAYER_SETS'
       ,'NLS'
       ,'nm3ins.ins_nls'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1099);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1102
       ,'NM_LOAD_DESTINATIONS'
       ,'NLD'
       ,'nm3ins.ins_nld'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1102);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1103
       ,'NM_LOAD_DESTINATION_DEFAULTS'
       ,'NLDD'
       ,'nm3ins.ins_nldd'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1103);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1104
       ,'NM_LOAD_FILES'
       ,'NLF'
       ,'nm3ins.ins_nlf'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1104);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1105
       ,'NM_LOAD_FILE_COLS'
       ,'NLFC'
       ,'nm3ins.ins_nlfc'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1105);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1106
       ,'NM_LOAD_FILE_COL_DESTINATIONS'
       ,'NLCD'
       ,'nm3ins.ins_nlcd'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1106);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1107
       ,'NM_LOAD_FILE_DESTINATIONS'
       ,'NLFD'
       ,'nm3ins.ins_nlfd'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1107);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1108
       ,'NM_MAIL_GROUPS'
       ,'NMG'
       ,'nm3ins.ins_nmg'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1108);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1109
       ,'NM_MAIL_GROUP_MEMBERSHIP'
       ,'NMGM'
       ,'nm3ins.ins_nmgm'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1109);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1110
       ,'NM_MAIL_MESSAGE'
       ,'NMM'
       ,'nm3ins.ins_nmm'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1110);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1111
       ,'NM_MAIL_MESSAGE_RECIPIENTS'
       ,'NMMR'
       ,'nm3ins.ins_nmmr'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1111);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1112
       ,'NM_MAIL_MESSAGE_TEXT'
       ,'NMMT'
       ,'nm3ins.ins_nmmt'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1112);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1113
       ,'NM_MAIL_USERS'
       ,'NMU'
       ,'nm3ins.ins_nmu'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1113);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1114
       ,'NM_MEMBERS_ALL'
       ,'NM'
       ,'nm3ins.ins_nm_all'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1114);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1116
       ,'NM_MRG_DEFAULT_QUERY_ATTRIBS'
       ,'NDA'
       ,'nm3ins.ins_nda'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1116);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1117
       ,'NM_MRG_DEFAULT_QUERY_TYPES_ALL'
       ,'NDQ'
       ,'nm3ins.ins_ndq_all'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1117);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1118
       ,'NM_MRG_INV_DERIVATION'
       ,'NMID'
       ,'nm3ins.ins_nmid'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1118);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1119
       ,'NM_MRG_OUTPUT_COLS'
       ,'NMC'
       ,'nm3ins.ins_nmc'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1119);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1120
       ,'NM_MRG_OUTPUT_COL_DECODE'
       ,'NMCD'
       ,'nm3ins.ins_nmcd'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1120);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1121
       ,'NM_MRG_OUTPUT_FILE'
       ,'NMF'
       ,'nm3ins.ins_nmf'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1121);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1122
       ,'NM_MRG_QUERY_ALL'
       ,'NMQ'
       ,'nm3ins.ins_nmq_all'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1122);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1123
       ,'NM_MRG_QUERY_ATTRIBS'
       ,'NMQA'
       ,'nm3ins.ins_nmqa'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1123);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1125
       ,'NM_MRG_QUERY_ROLES'
       ,'NQRO'
       ,'nm3ins.ins_nqro'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1125);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1126
       ,'NM_MRG_QUERY_TYPES_ALL'
       ,'NMQT'
       ,'nm3ins.ins_nmqt_all'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1126);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1127
       ,'NM_MRG_QUERY_VALUES'
       ,'NMQV'
       ,'nm3ins.ins_nmqv'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1127);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1132
       ,'NM_NODE_TYPES'
       ,'NNT'
       ,'nm3ins.ins_nnt'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1132);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1133
       ,'NM_NODE_USAGES_ALL'
       ,'NNU'
       ,'nm3ins.ins_nnu_all'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1133);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1134
       ,'NM_NT_GROUPINGS_ALL'
       ,'NNG'
       ,'nm3ins.ins_nng_all'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1134);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1135
       ,'NM_NW_PERSISTENT_EXTENTS'
       ,'NPE'
       ,'nm3ins.ins_npe'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1135);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1136
       ,'NM_OPERATIONS'
       ,'NMO'
       ,'nm3ins.ins_nmo'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1136);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1137
       ,'NM_OPERATION_DATA'
       ,'NOD'
       ,'nm3ins.ins_nod'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1137);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1138
       ,'NM_PBI_QUERY'
       ,'NPQ'
       ,'nm3ins.ins_npq'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1138);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1139
       ,'NM_PBI_QUERY_ATTRIBS'
       ,'NPQA'
       ,'nm3ins.ins_npqa'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1139);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1141
       ,'NM_PBI_QUERY_TYPES'
       ,'NPQT'
       ,'nm3ins.ins_npqt'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1141);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1142
       ,'NM_PBI_QUERY_VALUES'
       ,'NPQV'
       ,'nm3ins.ins_npqv'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1142);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1143
       ,'NM_PBI_SECTIONS'
       ,'NPS'
       ,'nm3ins.ins_nps'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1143);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1144
       ,'NM_PBI_SECTION_MEMBERS'
       ,'NPSM'
       ,'nm3ins.ins_npsm'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1144);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1146
       ,'NM_SAVED_EXTENTS'
       ,'NSE'
       ,'nm3ins.ins_nse'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1146);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1147
       ,'NM_SAVED_EXTENT_MEMBERS'
       ,'NSM'
       ,'nm3ins.ins_nsm'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1147);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1148
       ,'NM_SAVED_EXTENT_MEMBER_DATUMS'
       ,'NSD'
       ,'nm3ins.ins_nsd'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1148);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1149
       ,'NM_TYPES'
       ,'NT'
       ,'nm3ins.ins_nt'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1149);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1150
       ,'NM_TYPE_COLUMNS'
       ,'NTC'
       ,'nm3ins.ins_ntc'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1150);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1151
       ,'NM_TYPE_INCLUSION'
       ,'NTI'
       ,'nm3ins.ins_nti'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1151);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1152
       ,'NM_TYPE_LAYERS_ALL'
       ,'NTL'
       ,'nm3ins.ins_ntl_all'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1152);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1153
       ,'NM_TYPE_SUBCLASS'
       ,'NSC'
       ,'nm3ins.ins_nsc'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1153);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1154
       ,'NM_TYPE_SUBCLASS_RESTRICTIONS'
       ,'NSR'
       ,'nm3ins.ins_nsr'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1154);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1155
       ,'NM_UNITS'
       ,'UN'
       ,'nm3ins.ins_un'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1155);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1156
       ,'NM_UNIT_CONVERSIONS'
       ,'UC'
       ,'nm3ins.ins_uc'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1156);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1157
       ,'NM_UNIT_DOMAINS'
       ,'UD'
       ,'nm3ins.ins_ud'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1157);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1158
       ,'NM_UPLOAD_FILES'
       ,'NUF'
       ,'nm3ins.ins_nuf'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1158);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1159
       ,'NM_USER_AUS_ALL'
       ,'NUA'
       ,'nm3ins.ins_nua_all'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1159);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1160
       ,'NM_VISUAL_ATTRIBUTES'
       ,'NVA'
       ,'nm3ins.ins_nva'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1160);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1161
       ,'NM_XML_FILES'
       ,'NXF'
       ,'nm3ins.ins_nxf'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1161);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1162
       ,'NM_XSP'
       ,'NWX'
       ,'nm3ins.ins_nwx'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1162);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1163
       ,'NM_X_DRIVING_CONDITIONS'
       ,'NXD'
       ,'nm3ins.ins_nxd'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1163);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1164
       ,'NM_X_ERRORS'
       ,'NXE'
       ,'nm3ins.ins_nxe'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1164);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1165
       ,'NM_X_INV_CONDITIONS'
       ,'NXIC'
       ,'nm3ins.ins_nxic'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1165);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1166
       ,'NM_X_LOCATION_RULES'
       ,'NXL'
       ,'nm3ins.ins_nxl'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1166);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1167
       ,'NM_X_NW_RULES'
       ,'NXN'
       ,'nm3ins.ins_nxn'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1167);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1168
       ,'NM_X_RULES'
       ,'NXR'
       ,'nm3ins.ins_nxr'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1168);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1169
       ,'NM_X_VAL_CONDITIONS'
       ,'NXV'
       ,'nm3ins.ins_nxv'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1169);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1170
       ,'XSP_RESTRAINTS'
       ,'XSR'
       ,'nm3ins.ins_xsr'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1170);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1171
       ,'XSP_REVERSAL'
       ,'XRV'
       ,'nm3ins.ins_xrv'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1171);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1172
       ,'V_LOAD_INV_MEM_ELE_MP_AMBIG'
       ,'LIMA'
       ,'nm3inv_load.load_ele_mp_ambig'
       ,'nm3inv_load.validate_ele_mp_ambig' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1172);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1173
       ,'V_LOAD_INV_MEM_ELE_MP_EXCL'
       ,'LIMX'
       ,'nm3inv_load.load_ele_mp_excl'
       ,'nm3inv_load.validate_ele_mp_excl' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1173);
--
INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT 
        1174
       ,'V_LOAD_INV_MEM_ON_ELEMENT'
       ,'LIME'
       ,'nm3inv_load.load_on_element'
       ,'nm3inv_load.validate_on_element' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                   WHERE NLD_ID = 1174);
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- NM_LOAD_DESTINATION_DEFAULTS
--
-- select * from nm3_metadata.nm_load_destination_defaults
-- order by nldd_nld_id
--         ,nldd_column_name
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_load_destination_defaults
SET TERM OFF

INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        34
       ,'NO_NODE_ID'
       ,'no_.no_node_name' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 34
                    AND  NLDD_COLUMN_NAME = 'NO_NODE_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        34
       ,'NO_NODE_TYPE'
       ,'''ROAD''' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 34
                    AND  NLDD_COLUMN_NAME = 'NO_NODE_TYPE');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        34
       ,'NO_NP_ID'
       ,'np.np_id' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 34
                    AND  NLDD_COLUMN_NAME = 'NO_NP_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        35
       ,'NP_DESCR'
       ,'''Migrated Point''' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 35
                    AND  NLDD_COLUMN_NAME = 'NP_DESCR');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        35
       ,'NP_ID'
       ,'nm3seq.next_np_id_seq' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 35
                    AND  NLDD_COLUMN_NAME = 'NP_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        44
       ,'IIT_NE_ID'
       ,'IIT.IIT_NE_ID' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 44
                    AND  NLDD_COLUMN_NAME = 'IIT_NE_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        47
       ,'IIT_NE_ID'
       ,'NM3NET.GET_NEXT_NE_ID' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 47
                    AND  NLDD_COLUMN_NAME = 'IIT_NE_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        104
       ,'NAD_END_DATE'
       ,'ne.ne_end_date' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 104
                    AND  NLDD_COLUMN_NAME = 'NAD_END_DATE');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        104
       ,'NAD_GTY_TYPE'
       ,'ne.ne_gty_group_type' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 104
                    AND  NLDD_COLUMN_NAME = 'NAD_GTY_TYPE');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        104
       ,'NAD_IIT_NE_ID'
       ,'iit.iit_ne_id' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 104
                    AND  NLDD_COLUMN_NAME = 'NAD_IIT_NE_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        104
       ,'NAD_INV_TYPE'
       ,'iit.iit_inv_type' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 104
                    AND  NLDD_COLUMN_NAME = 'NAD_INV_TYPE');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        104
       ,'NAD_NE_ID'
       ,'ne.ne_id' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 104
                    AND  NLDD_COLUMN_NAME = 'NAD_NE_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        104
       ,'NAD_NT_TYPE'
       ,'ne.ne_nt_type' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 104
                    AND  NLDD_COLUMN_NAME = 'NAD_NT_TYPE');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        104
       ,'NAD_START_DATE'
       ,'ne.ne_start_Date' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 104
                    AND  NLDD_COLUMN_NAME = 'NAD_START_DATE');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1001
       ,'DOC_ID'
       ,'nm3seq.next_DOC_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1001
                    AND  NLDD_COLUMN_NAME = 'DOC_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1002
       ,'DAC_ID'
       ,'nm3seq.next_DAC_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1002
                    AND  NLDD_COLUMN_NAME = 'DAC_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1009
       ,'DDG_ID'
       ,'nm3seq.next_DDG_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1009
                    AND  NLDD_COLUMN_NAME = 'DDG_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1010
       ,'DDC_ID'
       ,'nm3seq.next_DDC_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1010
                    AND  NLDD_COLUMN_NAME = 'DDC_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1018
       ,'DLC_ID'
       ,'nm3seq.next_DLC_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1018
                    AND  NLDD_COLUMN_NAME = 'DLC_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1021
       ,'DQ_ID'
       ,'nm3seq.next_DQ_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1021
                    AND  NLDD_COLUMN_NAME = 'DQ_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1044
       ,'HAD_ID'
       ,'nm3seq.next_HAD_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1044
                    AND  NLDD_COLUMN_NAME = 'HAD_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1063
       ,'NAU_ADMIN_UNIT'
       ,'nm3seq.next_NAU_ADMIN_UNIT_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1063
                    AND  NLDD_COLUMN_NAME = 'NAU_ADMIN_UNIT');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1071
       ,'NE_ID'
       ,'nm3seq.next_NE_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1071
                    AND  NLDD_COLUMN_NAME = 'NE_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1074
       ,'NEL_ID'
       ,'nm3seq.next_NEL_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1074
                    AND  NLDD_COLUMN_NAME = 'NEL_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1088
       ,'ITB_BANDING_ID'
       ,'nm3seq.next_ITB_BANDING_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1088
                    AND  NLDD_COLUMN_NAME = 'ITB_BANDING_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1089
       ,'ITD_BAND_SEQ'
       ,'nm3seq.next_ITD_BAND_SEQ_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1089
                    AND  NLDD_COLUMN_NAME = 'ITD_BAND_SEQ');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1093
       ,'NJC_JOB_ID'
       ,'nm3seq.next_NJC_JOB_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1093
                    AND  NLDD_COLUMN_NAME = 'NJC_JOB_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1094
       ,'NJO_ID'
       ,'nm3seq.next_NJO_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1094
                    AND  NLDD_COLUMN_NAME = 'NJO_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1098
       ,'NL_LAYER_ID'
       ,'nm3seq.next_NL_LAYER_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1098
                    AND  NLDD_COLUMN_NAME = 'NL_LAYER_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1099
       ,'NLS_SET_ID'
       ,'nm3seq.next_NLS_SET_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1099
                    AND  NLDD_COLUMN_NAME = 'NLS_SET_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1102
       ,'NLD_ID'
       ,'nm3seq.next_NLD_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1102
                    AND  NLDD_COLUMN_NAME = 'NLD_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1104
       ,'NLF_ID'
       ,'nm3seq.next_NLF_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1104
                    AND  NLDD_COLUMN_NAME = 'NLF_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1108
       ,'NMG_ID'
       ,'nm3seq.next_NMG_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1108
                    AND  NLDD_COLUMN_NAME = 'NMG_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1110
       ,'NMM_ID'
       ,'nm3seq.next_NMM_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1110
                    AND  NLDD_COLUMN_NAME = 'NMM_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1112
       ,'NMMT_LINE_ID'
       ,'nm3seq.next_NMMT_LINE_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1112
                    AND  NLDD_COLUMN_NAME = 'NMMT_LINE_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1113
       ,'NMU_ID'
       ,'nm3seq.next_NMU_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1113
                    AND  NLDD_COLUMN_NAME = 'NMU_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1121
       ,'NMF_ID'
       ,'nm3seq.next_NMF_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1121
                    AND  NLDD_COLUMN_NAME = 'NMF_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1122
       ,'NMQ_ID'
       ,'nm3seq.next_NMQ_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1122
                    AND  NLDD_COLUMN_NAME = 'NMQ_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1126
       ,'NQT_SEQ_NO'
       ,'nm3seq.next_NQT_SEQ_NO_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1126
                    AND  NLDD_COLUMN_NAME = 'NQT_SEQ_NO');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1138
       ,'NPQ_ID'
       ,'nm3seq.next_NPQ_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1138
                    AND  NLDD_COLUMN_NAME = 'NPQ_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1141
       ,'NQT_SEQ_NO'
       ,'nm3seq.next_NQT_SEQ_NO_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1141
                    AND  NLDD_COLUMN_NAME = 'NQT_SEQ_NO');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1146
       ,'NSE_ID'
       ,'nm3seq.next_NSE_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1146
                    AND  NLDD_COLUMN_NAME = 'NSE_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1147
       ,'NSM_ID'
       ,'nm3seq.next_NSM_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1147
                    AND  NLDD_COLUMN_NAME = 'NSM_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1155
       ,'UN_UNIT_ID'
       ,'nm3seq.next_UN_UNIT_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1155
                    AND  NLDD_COLUMN_NAME = 'UN_UNIT_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1157
       ,'UD_DOMAIN_ID'
       ,'nm3seq.next_UD_DOMAIN_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1157
                    AND  NLDD_COLUMN_NAME = 'UD_DOMAIN_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1165
       ,'NXIC_ID'
       ,'nm3seq.next_NXIC_ID_SEQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1165
                    AND  NLDD_COLUMN_NAME = 'NXIC_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1172
       ,'IIT_NE_ID'
       ,'IIT.IIT_NE_ID' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1172
                    AND  NLDD_COLUMN_NAME = 'IIT_NE_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1173
       ,'IIT_NE_ID'
       ,'IIT.IIT_NE_ID' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1173
                    AND  NLDD_COLUMN_NAME = 'IIT_NE_ID');
--
INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
       (NLDD_NLD_ID
       ,NLDD_COLUMN_NAME
       ,NLDD_VALUE
       )
SELECT 
        1174
       ,'IIT_NE_ID'
       ,'IIT.IIT_NE_ID' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATION_DEFAULTS
                   WHERE NLDD_NLD_ID = 1174
                    AND  NLDD_COLUMN_NAME = 'IIT_NE_ID');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- NM_UPLOAD_FILE_GATEWAYS
--
-- select * from nm3_metadata.nm_upload_file_gateways
-- order by nufg_table_name
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_upload_file_gateways
SET TERM OFF

INSERT INTO NM_UPLOAD_FILE_GATEWAYS
       (NUFG_TABLE_NAME
       )
SELECT 
        'NM_LOAD_BATCHES' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UPLOAD_FILE_GATEWAYS
                   WHERE NUFG_TABLE_NAME = 'NM_LOAD_BATCHES');
--
INSERT INTO NM_UPLOAD_FILE_GATEWAYS
       (NUFG_TABLE_NAME
       )
SELECT 
        'NM_LOAD_FILES' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UPLOAD_FILE_GATEWAYS
                   WHERE NUFG_TABLE_NAME = 'NM_LOAD_FILES');
--
INSERT INTO NM_UPLOAD_FILE_GATEWAYS
       (NUFG_TABLE_NAME
       )
SELECT 
        'NM_MRG_QUERY_RESULTS' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UPLOAD_FILE_GATEWAYS
                   WHERE NUFG_TABLE_NAME = 'NM_MRG_QUERY_RESULTS');
--
--
--
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- NM_UPLOAD_FILE_GATEWAY_COLS
--
-- select * from nm3_metadata.nm_upload_file_gateway_cols
-- order by nufgc_nufg_table_name
--         ,nufgc_seq
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_upload_file_gateway_cols
SET TERM OFF

INSERT INTO NM_UPLOAD_FILE_GATEWAY_COLS
       (NUFGC_NUFG_TABLE_NAME
       ,NUFGC_SEQ
       ,NUFGC_COLUMN_NAME
       ,NUFGC_COLUMN_DATATYPE
       )
SELECT 
        'NM_LOAD_BATCHES'
       ,1
       ,'NLB_BATCH_NO'
       ,'NUMBER' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UPLOAD_FILE_GATEWAY_COLS
                   WHERE NUFGC_NUFG_TABLE_NAME = 'NM_LOAD_BATCHES'
                    AND  NUFGC_SEQ = 1);
--
INSERT INTO NM_UPLOAD_FILE_GATEWAY_COLS
       (NUFGC_NUFG_TABLE_NAME
       ,NUFGC_SEQ
       ,NUFGC_COLUMN_NAME
       ,NUFGC_COLUMN_DATATYPE
       )
SELECT 
        'NM_LOAD_FILES'
       ,1
       ,'NLF_ID'
       ,'NUMBER' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UPLOAD_FILE_GATEWAY_COLS
                   WHERE NUFGC_NUFG_TABLE_NAME = 'NM_LOAD_FILES'
                    AND  NUFGC_SEQ = 1);
--
INSERT INTO NM_UPLOAD_FILE_GATEWAY_COLS
       (NUFGC_NUFG_TABLE_NAME
       ,NUFGC_SEQ
       ,NUFGC_COLUMN_NAME
       ,NUFGC_COLUMN_DATATYPE
       )
SELECT 
        'NM_MRG_QUERY_RESULTS'
       ,1
       ,'NQR_MRG_JOB_ID'
       ,'NUMBER' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_UPLOAD_FILE_GATEWAY_COLS
                   WHERE NUFGC_NUFG_TABLE_NAME = 'NM_MRG_QUERY_RESULTS'
                    AND  NUFGC_SEQ = 1);
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
