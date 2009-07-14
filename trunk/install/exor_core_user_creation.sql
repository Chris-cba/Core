-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/exor_core_user_creation.sql-arc   3.0   Jul 14 2009 09:16:12   lsorathia  $
--       Module Name      : $Workfile:   exor_core_user_creation.sql  $
--       Date into PVCS   : $Date:   Jul 14 2009 09:16:12  $
--       Date fetched Out : $Modtime:   Jul 14 2009 09:14:38  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version : 1.1
--       This scripts creates new user EXOR_CORE 
-------------------------------------------------------------------------
BEGIN
--
   EXECUTE IMMEDIATE 'CREATE USER exor_core IDENTIFIED BY exor_core' ;

   EXECUTE IMMEDIATE 'GRANT CONNECT TO exor_core' ;

   EXECUTE IMMEDIATE 'GRANT RESOURCE TO exor_core' ;

   EXECUTE IMMEDIATE 'GRANT CREATE ANY CONTEXT TO exor_core' ;   

   EXECUTE IMMEDIATE 'GRANT Create Public Synonym TO exor_core' ; 
--
EXCEPTION
   WHEN OTHERS THEN
   Null ;
END ;
/