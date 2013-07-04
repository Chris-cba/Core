--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3005_nm3006_metadata_upg.sql-arc   2.1   Jul 04 2013 14:21:22   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3005_nm3006_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:21:22  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:59:48  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
rem   SCCS Identifiers :-
rem   
rem       sccsid           : @(#)nm3005_nm3006_metadata_upg.sql	1.1 06/06/01
rem       Module Name      : nm3005_nm3006_metadata_upg.sql
rem       Date into SCCS   : 01/06/06 15:19:02
rem       Date fetched Out : 07/06/13 13:57:35
rem       SCCS Version     : 1.1
rem 
rem 
REM SCCS ID Keyword, do no remove
define sccsid = '"@(#)nm3005_nm3006_metadata_upg.sql	1.1 06/06/01"';
--
--nm_errors
--
UPDATE nm_errors
SET ner_descr = 'Location already designated to another admin unit.'
WHERE ner_appl = 'NET'
AND ner_id = 87;
