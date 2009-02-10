------------------------------------------------------------------
-- nm4051_nm4052_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4051_nm4052_ddl_upg.sql-arc   3.1   Feb 10 2009 17:23:58   malexander  $
--       Module Name      : $Workfile:   nm4051_nm4052_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Feb 10 2009 17:23:58  $
--       Date fetched Out : $Modtime:   Feb 10 2009 17:22:20  $
--       Version          : $Revision:   3.1  $
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
-- end of script 
------------------------------------------------------------------

