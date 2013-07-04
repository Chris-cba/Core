undefine p_deftab

ACCEPT p_deftab   char prompt 'ENTER THE HIGHWAYS OWNERS DEFAULT TABLESPACE : '

SET verify OFF;
SET feedback OFF;
SET serveroutput ON

-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/exor_core_user_creation.sql-arc   3.4   Jul 04 2013 13:45:14   James.Wadsworth  $
--       Module Name      : $Workfile:   exor_core_user_creation.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:45:14  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:59:46  $
--       Version          : $Revision:   3.4  $
--       Based on SCCS version : 1.1
--       This scripts creates new user EXOR_CORE 
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
DECLARE
--
   l_default_tablespace Varchar2(100) := UPPER('&P_DEFTAB');
   l_invalid_tablespace Exception;
   pragma exception_init(l_invalid_tablespace,-00959);   
-- 
BEGIN
--
   EXECUTE IMMEDIATE 'CREATE USER exor_core IDENTIFIED BY exor_core Default Tablespace '||l_default_tablespace ;

   EXECUTE IMMEDIATE 'GRANT CONNECT TO exor_core' ;

   EXECUTE IMMEDIATE 'GRANT RESOURCE TO exor_core' ;

   EXECUTE IMMEDIATE 'GRANT CREATE ANY CONTEXT TO exor_core' ;   

   EXECUTE IMMEDIATE 'GRANT Create Public Synonym TO exor_core' ; 
   
   EXECUTE IMMEDIATE 'Grant Select on Sys.Dba_Scheduler_Jobs To Exor_Core';
   
   Dbms_Output.Put_Line('User Exor_CORE created successfully');
--
EXCEPTION
   WHEN l_invalid_tablespace 
   THEN
       Raise_Application_Error(-20001,'Error while creating user EXOR_CORE : Invalid Tablesapce Name '||Chr(10)||
                                      'Please run the script again with the valid Tablesapce Name');
   When Others 
   THEN
       Null; 
END ;
/

SET verify On;
SET feedback On



