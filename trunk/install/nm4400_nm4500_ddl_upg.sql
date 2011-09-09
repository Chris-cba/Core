------------------------------------------------------------------
-- nm4400_nm4500_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4400_nm4500_ddl_upg.sql-arc   3.0   Sep 09 2011 10:39:08   Mike.Alexander  $
--       Module Name      : $Workfile:   nm4400_nm4500_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Sep 09 2011 10:39:08  $
--       Date fetched Out : $Modtime:   Sep 09 2011 10:09:54  $
--       Version          : $Revision:   3.0  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Add drop any view privilege
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 111403
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- Allows the hig owner to drop sub user views.
-- 
------------------------------------------------------------------
Begin
  EXECUTE IMMEDIATE 'GRANT DROP ANY VIEW TO  ' || User;
End;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

