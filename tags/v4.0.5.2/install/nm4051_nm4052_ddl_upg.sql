------------------------------------------------------------------
-- nm4051_nm4052_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4051_nm4052_ddl_upg.sql-arc   3.2   Feb 20 2009 14:36:16   malexander  $
--       Module Name      : $Workfile:   nm4051_nm4052_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Feb 20 2009 14:36:16  $
--       Date fetched Out : $Modtime:   Feb 20 2009 14:35:08  $
--       Version          : $Revision:   3.2  $
--
------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2009

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Addition of two new columns to DOCS table
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- New columns for recording National Indicator 14 details in PEM
-- 
------------------------------------------------------------------
ALTER TABLE docs
ADD (DOC_OUTCOME varchar2(10)
   , DOC_OUTCOME_REASON varchar2(254))
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Increase HOV.HOV_VALUE column length
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- **** COMMENTS TO BE ADDED BY ADRIAN EDWARDS ****
-- 
------------------------------------------------------------------
alter table hig_option_values
modify hov_value VARCHAR2(1000)
/

------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

