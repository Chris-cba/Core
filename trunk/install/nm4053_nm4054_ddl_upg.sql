------------------------------------------------------------------
-- nm4053_nm4054_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4053_nm4054_ddl_upg.sql-arc   3.2   Jul 04 2013 14:15:40   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4053_nm4054_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:15:40  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:20  $
--       Version          : $Revision:   3.2  $
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Removed the decimal place constraint
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED PROBLEM MANAGER LOG#
-- 698292
-- 
-- CUSTOMER
-- Kansas DOT
-- 
-- PROBLEM
-- When running merge results extract from a result set that had either Meaning or Both selected for domain values and the merge query definition selected a number attribute, an invalid number error occurs.What the app is doing is populating the units definition for the attribute (such as metersinv) into the attribute value.  The error is being generated because a text value has been written to a number column.
-- 
------------------------------------------------------------------

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Log-698292 Made chnages to working of Nm7055
-- 
------------------------------------------------------------------
alter table NM_MRG_OUTPUT_COLS drop constraint NMC_DEC_PLACES_CHK ;

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Removed decimal place constraint
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED PROBLEM MANAGER LOG#
-- 698292
-- 
-- CUSTOMER
-- Kansas DOT
-- 
-- PROBLEM
-- When running merge results extract from a result set that had either Meaning or Both selected for domain values and the merge query definition selected a number attribute, an invalid number error occurs.What the app is doing is populating the units definition for the attribute (such as metersinv) into the attribute value.  The error is being generated because a text value has been written to a number column.
-- 
------------------------------------------------------------------

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Log-698292 Made chnages to working of Nm7055
-- 
------------------------------------------------------------------
alter table NM_MRG_OUTPUT_COLS drop constraint NMC_DISP_DP_CHK2;

------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

