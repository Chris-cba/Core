------------------------------------------------------------------
-- nm4052_nm4053_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4052_nm4053_ddl_upg.sql-arc   3.0   Mar 02 2009 12:27:56   malexander  $
--       Module Name      : $Workfile:   nm4052_nm4053_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Mar 02 2009 12:27:56  $
--       Date fetched Out : $Modtime:   Mar 02 2009 12:21:54  $
--       Version          : $Revision:   3.0  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Default on ITA.ITA_EXCLUSIVE
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Add default to NM_INV_TYPE_ATTRIBS_ALL.ITA_EXCLUSIVE ('N')
-- 
------------------------------------------------------------------
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL MODIFY ita_exclusive DEFAULT 'N';
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Disable trigger nm_inv_items_all_a_dt_trg
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED PROBLEM MANAGER LOG#
-- 696122
-- 
-- CUSTOMER
-- Larimer County
-- 
-- PROBLEM
-- Closing a parent asset should cascade down to child items
-- 
------------------------------------------------------------------

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Disable trigger nm_inv_items_all_a_dt_trg
-- 
------------------------------------------------------------------
SET TERM ON
PROMPT Hierarchical Asset repair...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'sql'||'&terminator'||'disabled_trigger_on_nm_inv_items_all.sql' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

