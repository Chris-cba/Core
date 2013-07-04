--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3002patch_metadata_upg.sql-arc   2.1   Jul 04 2013 14:21:22   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3002patch_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:21:22  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:59:40  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
rem   SCCS Identifiers :-
rem
rem       sccsid           : @(#)nm3002patch_metadata_upg.sql	1.2 05/02/01
rem       Module Name      : nm3002patch_metadata_upg.sql
rem       Date into SCCS   : 01/05/02 15:52:23
rem       Date fetched Out : 07/06/13 13:57:34
rem       SCCS Version     : 1.2
rem
rem
--
--nm_errors
--
INSERT INTO NM_ERRORS ( NER_APPL, NER_ID, NER_HER_NO, NER_DESCR ) VALUES (
'NET', 79, NULL, 'Please use the User Entered tab to edit this extent.');
--
INSERT INTO HIG_MODULES ( HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS,
HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU ) VALUES (
'SDM', 'SDM Security', 'sdm', 'EXE', NULL, 'Y', 'N', 'HIG', NULL)
;
