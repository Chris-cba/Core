------------------------------------------------------------------
-- nm4010_nm4020_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4010_nm4020_ddl_upg.sql-arc   2.1   Jul 19 2007 10:21:50   gjohnson  $
--       Module Name      : $Workfile:   nm4010_nm4020_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Jul 19 2007 10:21:50  $
--       Date fetched Out : $Modtime:   Jul 19 2007 10:13:52  $
--       Version          : $Revision:   2.1  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
------------------------------------------------------------------


------------------------------------------------------------------

------------------------------------------------------------------
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Grant DROP ANY SYNONYM to HIG_ADMIN role
SET TERM OFF

-- GJ  16-MAY-2007
-- 
-- DEVELOPMENT COMMENTS
-- HIG1832 was reporting a "You do not have permission to perform this action" error message.
-- Problem was due to lack of DROP ANY SYNONYM priv - which caused nm3sdm.Create_Msv_Feature_Views to raise the exception.
------------------------------------------------------------------
GRANT DROP ANY SYNONYM to HIG_ADMIN
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New indexes on FK constrained columns, where no suitable index already exists
SET TERM OFF

-- GJ  13-JUN-2007
-- 
-- DEVELOPMENT COMMENTS
-- All FK constrained columns should be indexed.
-- This DDL will add new indexes to existing tables that have been identified as needing such constraints.
------------------------------------------------------------------
DECLARE

 ex_ignore exception;
 pragma exception_init(ex_ignore,-955);

BEGIN
 
  BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX HAG_FK2_HAU_IND ON NM_ADMIN_GROUPS(NAG_CHILD_ADMIN_UNIT)';
   EXCEPTION    
   WHEN ex_ignore THEN
      Null;
   WHEN others THEN
      RAISE;  
  END;

  BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX NUA_NAU_FK_IND ON NM_USER_AUS_ALL(NUA_ADMIN_UNIT)';
  EXCEPTION
   WHEN ex_ignore THEN
      Null;
   WHEN others THEN
      RAISE;  
  END;
  
END;
/
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

