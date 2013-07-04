--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)ins_x_errors.sql	1.4 08/10/01
--       Module Name      : ins_x_errors.sql
--       Date into SCCS   : 01/08/10 09:43:32
--       Date fetched Out : 07/06/13 17:07:21
--       SCCS Version     : 1.4
--
--
--   MRWA Data for NM_X_ERRORS table
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
set feedback off
--
DELETE FROM nm_x_errors
WHERE nxe_id = 501;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
501, 'Commonwealth must be 3 for local roads', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 502;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
502, 'Commonwealth class must be 2 for main roads', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 503;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
503, 'Commonwealth class must NOT be 3 for highways', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 551;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
551, 'Functional class must be P for Highways and Main roads', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 552;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
552, 'Function class must NOT be P for local roads', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 401;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
401, 'Details are not required for straight sections of road', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 402;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
402, 'Details are required for curved sections of road', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 1;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
1, 'Road is unformed, no other details are to be entered', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 21;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
21, 'Formation details must be entered', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 22;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
22, 'Formation is flat-bladed, no pavement details are to be entered', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 3;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
3, 'Formation details must be entered', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 41;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
41, 'Pavement year must not be earlier than formation year', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 42;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
42, 'Base or subbase material must be entered if pavement year exists', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 51;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
51, 'Pavement does not exist. Pavement  repair may not be entered', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 52;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
52, 'Repair year must not be earlier than pavement year', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 61;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
61, 'Pavement does not exist. Pavement shoulder may not be entered', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 621;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
621, 'Shoulder year may not be earlier than pavement year', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 622;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
622, 'Base or subbase material must be entered if shoulder year exists', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 63;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
63, 'Shoulder year must not be earlier than widening year for the same XSP', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 31;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
31, 'Pavement does not exist. Pavement widening may not be entered', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 321;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
321, 'Widening year must not be earlier than pavement year', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 322;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
322, 'Base or subbase material must be enetered if widening year exists', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 33;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
33, 'Widening year must not be later than shoulder year for the same XSP', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 101;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
101, 'Base depth must be entered', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 102;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
102, 'No base material exists. Other base details may not be entered', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 103;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
103, 'Subbase depth must be entered', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 104;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
104, 'No subbase material exists. Other subbase details may not be enetered', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 105;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
105, 'base agent is only applicable for material of gravel and limestone', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 106;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
106, 'Subbase agent is only applicable for material of gravel and limestone', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 301;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
301, 'Minimum number of trains must not exceed the maximum number of trains', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 302;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
302, 'Date inspected must not be entered with protection type 4 or 5', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 303;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
303, '-', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 351;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
351, 'Date and time open must be entered when road is opened', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 352;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
352, 'Date and time open must be more recent than date and time closed', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 353;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
353, 'A road closed to all vehicles may not be closed to any other vehicle category', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 201;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
201, 'No pavement exists. Surface lane details may not be entered', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 202;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
202, 'Surface lane year for any XSP must not be earlier than th epavement year', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 203;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
203, 'Enrichment year must not be earlier than surface year for the same XSP', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 231;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
231, 'No surface exists. Shoulder details may not be entered', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 232;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
232, 'Enrichment year must not be earlier than surface shoulder year for the same XSP', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 451;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
451, 'Details are not required when align type = 1', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 4521;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
4521, 'Align grade must be entered', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 4522;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
4522, 'K-value and sidling are not required when align type equals 2 or 3', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 4531;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
4531, 'K-value must be entered', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 4532;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
4532, 'Grade is not required when align type = 4', 'I');
--
DELETE FROM nm_x_errors
WHERE nxe_id = 5000;
INSERT INTO NM_X_ERRORS ( NXE_ID, NXE_ERROR_TEXT, NXE_ERROR_CLASS ) VALUES (
5000, 'At a given location only LCUR, RCUR or STRA may exist', 'I');
--
commit;
--
set feedback on
