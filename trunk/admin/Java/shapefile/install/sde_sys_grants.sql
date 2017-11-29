--
---------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/Java/shapefile/install/sde_sys_grants.sql-arc   1.0   Nov 29 2017 09:45:54   Upendra.Hukeri  $
--       Module Name      : $Workfile:   sde_sys_grants.sql  $
--       Date into PVCS   : $Date:   Nov 29 2017 09:45:54  $
--       Date fetched Out : $Modtime:   Nov 29 2017 09:42:12  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : Upendra Hukeri
--
---------------------------------------------------------------------------------------------------
-- Copyright (c) 2017 Bentley Systems Incorporated. All rights reserved.
---------------------------------------------------------------------------------------------------
--
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- DBMS_JAVA GRANTS
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Granting File Permission (read,write,delete) on <<ALL FILES>>
SET TERM OFF
--
SET FEEDBACK ON
CALL dbms_java.grant_permission('SDE_USER', 'SYS:java.io.FilePermission', '<<ALL FILES>>', 'read,write,delete');
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Granting Property Permission (write) on EPSG-HSQL.directory
SET TERM OFF
--
SET FEEDBACK ON
CALL dbms_java.grant_permission('SDE_USER', 'SYS:java.util.PropertyPermission', 'EPSG-HSQL.directory', 'write');
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Granting Runtime Permission on SDE_UTIL_PATH
SET TERM OFF
--
SET FEEDBACK ON
CALL dbms_java.grant_permission('SDE_USER', 'SYS:java.lang.RuntimePermission', 'getenv.SDE_UTIL_PATH', '' );
SET FEEDBACK OFF
--
--
EXIT
--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************
---------------------------------------------------------------------------------------------------
--