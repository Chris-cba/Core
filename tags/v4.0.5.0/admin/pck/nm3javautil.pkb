CREATE OR REPLACE PACKAGE BODY nm3javautil AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3javautil.pkb	1.6 02/24/03
--       Module Name      : nm3javautil.pkb
--       Date into SCCS   : 03/02/24 09:46:47
--       Date fetched Out : 07/06/13 14:12:14
--       SCCS Version     : 1.6
--
--
--   Author : I Turnbull
--
--   nm3javautil body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
--
--all global package variables here

  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid CONSTANT VARCHAR2(2000) := '"@(#)nm3javautil.pkb	1.6 02/24/03"';

  g_package_name CONSTANT VARCHAR2(30) := 'nm3javautil';
--
   c_dirrepstrn CONSTANT VARCHAR2(1) := hig.get_sysopt(p_option_id => 'DIRREPSTRN');  
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_exec_privs( p_user     VARCHAR2
                         ,p_dir      VARCHAR2
                         ,p_filename VARCHAR2 DEFAULT '*'
                        ) IS
BEGIN
--
-- Run as Sys or have java_admin role granted to it 
-- grants execute permissions to the dir filename combination
--
--   nm_debug.proc_start(p_package_name   => g_package_name
--                      ,p_procedure_name => 'set_exec_privs');
                     
  dbms_java.grant_permission ( grantee           => p_user
                             , permission_type   => 'java.io.FilePermission'
                             , permission_name   => p_dir || c_dirrepstrn || p_filename
                             , permission_action => 'execute'
                             );

  dbms_java.grant_permission ( grantee           => p_user
                             , permission_type   => 'java.lang.RuntimePermission'
                             , permission_name   => '*'
                             , permission_action => 'writeFileDescriptor'
                             );                     


--   nm_debug.proc_end(p_package_name   => g_package_name
--                    ,p_procedure_name => 'set_exec_privs');

END set_exec_privs;
--
-----------------------------------------------------------------------------
--
PROCEDURE revoke_exec_privs( p_user     VARCHAR2
                            ,p_dir      VARCHAR2
                            ,p_filename VARCHAR2 DEFAULT '*'
                           ) IS
BEGIN
--
-- Run as Sys or have java_admin role granted to it 
-- grants execute permissions to the dir filename combination
--
--  nm_debug.proc_start(p_package_name   => g_package_name
--                     ,p_procedure_name => 'revoke_exec_privs');
  
  dbms_java.revoke_permission( grantee           => p_user
                             , permission_type   => 'java.io.FilePermission'
                             , permission_name   =>  p_dir || c_dirrepstrn || p_filename
                             , permission_action => 'execute'
                             );

  dbms_java.revoke_permission ( grantee           => p_user
                             , permission_type   => 'java.lang.RuntimePermission'
                             , permission_name   => '*'
                             , permission_action => 'writeFileDescriptor'
                             );                     


--  nm_debug.proc_end(p_package_name   => g_package_name
--                   ,p_procedure_name => 'revoke_exec_privs');

END revoke_exec_privs;
--
-----------------------------------------------------------------------------
--
PROCEDURE exec_sde_bat_file( pi_filename VARCHAR2
                            ,pi_username VARCHAR2 DEFAULT USER 
                           )
IS 
  l_sdebatdir HIG_OPTIONS.hop_value%TYPE;
  l_ret_code NUMBER;

BEGIN

  l_sdebatdir := hig.get_sysopt('SDEBATDIR'); 

  IF l_sdebatdir IS NOT NULL
  THEN 
     set_exec_privs( p_user => pi_username
                   , p_dir  => l_sdebatdir 
                   );
                              
     l_ret_code := nm3java.runthis(l_sdebatdir||c_dirrepstrn||pi_filename);       

     -- nm3java.runthis returns -1 if there is an error
     IF l_ret_code < 0 
     THEN
       hig.raise_ner( pi_appl => nm3type.c_net
                     ,pi_id   => 288
                     ,pi_supplementary_info => l_sdebatdir||c_dirrepstrn||pi_filename
                    );
                  
     END IF;     
  END IF;
    
  --dbms_output.put_line ( 'l_ret_code= ' || l_ret_code );         

END exec_sde_bat_file; 
--
-----------------------------------------------------------------------------
--
PROCEDURE set_read_privs( p_user     VARCHAR2
                         ,p_dir      VARCHAR2
                         ,p_filename VARCHAR2 DEFAULT '*'
                        ) IS
BEGIN
--
-- Run as Sys or have java_admin role granted to it 
-- grants execute permissions to the dir filename combination
--
-- nm_debug.proc_start(p_package_name   => g_package_name
--                     ,p_procedure_name => 'set_read_privs');
                     
  dbms_java.grant_permission ( grantee           => p_user
                             , permission_type   => 'java.io.FilePermission'
                             , permission_name   => p_dir || c_dirrepstrn || p_filename
                             , permission_action => 'read'
                             );

--  nm_debug.proc_end(p_package_name   => g_package_name
--                   ,p_procedure_name => 'set_read_privs');

END set_read_privs;
--
-----------------------------------------------------------------------------
--
END nm3javautil;
/ 

