--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/higroles.sql-arc   2.15   Sep 16 2015 10:29:54   Steve.Cooper  $
--       Module Name      : $Workfile:   higroles.sql  $
--       Date into PVCS   : $Date:   Sep 16 2015 10:29:54  $
--       Date fetched Out : $Modtime:   Sep 16 2015 10:29:36  $
--       Version          : $Revision:   2.15  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
--
rem --------------------------------------------------------------------------
REM **************************************************************************
rem	this script creates an INITIAL SET OF ROLES AND PRIVILEGES, which
rem	may be used WHEN creating NEW oracle highways users.
REM **************************************************************************
rem	CREATE a ROLE FOR granting TO the highways administrator.

-- get the user
SET define ON

SET feedback OFF
prompt CREATE ROLE hig_admin;

DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE hig_admin';
  NULL;
EXCEPTION
WHEN role_exists
THEN 
  Null;
END;
/
-- Grant the role to the user, with admin option

BEGIN
   EXECUTE IMMEDIATE 'grant hig_admin to '||USER;
   EXECUTE IMMEDIATE 'grant hig_admin to '||USER||' with admin option';
END;
/
GRANT SELECT ANY TABLE TO hig_admin;
GRANT INSERT ANY TABLE TO hig_admin;
GRANT UPDATE ANY TABLE TO hig_admin;
GRANT DELETE ANY TABLE TO hig_admin;
GRANT LOCK ANY TABLE TO hig_admin;
GRANT CREATE ANY TABLE TO hig_admin;
GRANT CREATE ANY VIEW TO hig_admin;
GRANT EXECUTE ANY PROCEDURE TO hig_admin;
GRANT EXECUTE ANY TYPE TO hig_admin;
GRANT SELECT ANY SEQUENCE TO hig_admin;
GRANT CREATE SESSION TO hig_admin;
GRANT CREATE JOB TO hig_admin;

GRANT ALTER SESSION TO hig_admin;
GRANT CREATE PUBLIC SYNONYM TO hig_admin;
GRANT CREATE TRIGGER TO hig_admin;
GRANT CREATE SEQUENCE TO hig_admin;
GRANT CREATE ROLE TO hig_admin;
GRANT CREATE SYNONYM TO hig_admin;
GRANT CREATE PROCEDURE TO hig_admin;
GRANT CREATE USER TO hig_admin;
GRANT GRANT ANY privilege TO hig_admin;
GRANT GRANT ANY ROLE TO hig_admin;
GRANT DROP PUBLIC SYNONYM TO hig_admin;
GRANT DROP USER TO hig_admin;
GRANT ALTER USER TO hig_admin;
GRANT DROP ANY DIRECTORY TO HIG_ADMIN;
GRANT CREATE ANY DIRECTORY TO HIG_ADMIN;
GRANT DROP ANY SYNONYM TO hig_admin;
GRANT ANALYZE ANY TO hig_admin;
GRANT CREATE ANY CLUSTER TO hig_admin;

rem --------------------------------------------------------------------------
rem	CREATE a ROLE FOR granting TO highways users who may UPDATE core data

prompt CREATE ROLE hig_user;

DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE hig_user';
  NULL;
EXCEPTION
WHEN role_exists
THEN 
  Null;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'grant hig_user to '||USER;
   EXECUTE IMMEDIATE 'grant hig_user to '||USER||' with admin option';
END;
/

GRANT SELECT ANY TABLE TO hig_user;
GRANT INSERT ANY TABLE TO hig_user;
GRANT UPDATE ANY TABLE TO hig_user;
GRANT DELETE ANY TABLE TO hig_user;
GRANT LOCK ANY TABLE TO hig_user;
GRANT CREATE TABLE TO hig_user;
GRANT CREATE VIEW  TO hig_user;
GRANT CREATE SEQUENCE TO hig_user;
GRANT SELECT ANY SEQUENCE TO hig_user;
GRANT EXECUTE ANY PROCEDURE TO hig_user;
GRANT EXECUTE ANY TYPE TO hig_user;
GRANT CREATE SESSION TO hig_user;
grant select any dictionary to hig_user;
grant execute on dbms_pipe to hig_user;
grant execute on dbms_rls to hig_user;
grant execute on dbms_lock to hig_user;
grant select on dba_sys_privs to hig_user;
grant select on dba_tab_privs to hig_user;
grant select on dba_users to hig_user;
grant select on dba_role_privs to hig_user;
grant select on dba_ts_quotas to hig_user;
grant select on dba_roles to hig_user;
grant select on dba_profiles to hig_user;
GRANT ANALYZE ANY TO hig_user;

rem --------------------------------------------------------------------------
rem	CREATE a ROLE FOR granting TO readonly highways users.

prompt CREATE ROLE hig_readonly;

DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE hig_readonly';
  NULL;
EXCEPTION
WHEN role_exists
THEN 
  Null;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'grant hig_readonly to '||USER;
   EXECUTE IMMEDIATE 'grant hig_readonly to '||USER||' with admin option';
END;
/
GRANT SELECT ANY TABLE TO hig_readonly;
GRANT LOCK ANY TABLE TO hig_readonly;
GRANT CREATE TABLE TO hig_readonly;
GRANT CREATE VIEW  TO hig_readonly;
GRANT SELECT ANY SEQUENCE TO hig_readonly;
GRANT EXECUTE ANY PROCEDURE TO hig_readonly;
GRANT CREATE SESSION TO hig_readonly;


rem --------------------------------------------------------------------------
rem	CREATE a ROLE FOR granting TO the document data administator

prompt CREATE ROLE doc_admin;

DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE doc_admin';
  NULL;
EXCEPTION
WHEN role_exists
THEN 
  Null;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'grant doc_admin to '||USER;
   EXECUTE IMMEDIATE 'grant doc_admin to '||USER||' with admin option';
END;
/
GRANT SELECT ANY TABLE TO doc_admin;
GRANT INSERT ANY TABLE TO doc_admin;
GRANT UPDATE ANY TABLE TO doc_admin;
GRANT DELETE ANY TABLE TO doc_admin;
GRANT LOCK ANY TABLE TO doc_admin;
GRANT CREATE TABLE TO doc_admin;
GRANT CREATE VIEW  TO doc_admin;
GRANT SELECT ANY SEQUENCE TO doc_admin;
GRANT EXECUTE ANY PROCEDURE TO doc_admin;
GRANT CREATE SESSION TO doc_admin;


rem --------------------------------------------------------------------------
rem	CREATE a ROLE FOR granting TO NORMAL document manager users

prompt CREATE ROLE doc_user;

DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE doc_user';
  NULL;
EXCEPTION
WHEN role_exists
THEN 
  Null;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'grant doc_user to '||USER;
   EXECUTE IMMEDIATE 'grant doc_user to '||USER||' with admin option';
END;
/
GRANT SELECT ANY TABLE TO doc_user;
GRANT INSERT ANY TABLE TO doc_user;
GRANT UPDATE ANY TABLE TO doc_user;
GRANT DELETE ANY TABLE TO doc_user;
GRANT LOCK ANY TABLE TO doc_user;
GRANT CREATE TABLE TO doc_user;
GRANT CREATE VIEW  TO doc_user;
GRANT SELECT ANY SEQUENCE TO doc_user;
GRANT EXECUTE ANY PROCEDURE TO doc_user;
GRANT CREATE SESSION TO doc_user;


rem --------------------------------------------------------------------------
rem	CREATE a ROLE FOR granting TO readonly document manager users

DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE doc_readonly';
  NULL;
EXCEPTION
WHEN role_exists
THEN 
  Null;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'grant doc_readonly to '||USER;
   EXECUTE IMMEDIATE 'grant doc_readonly to '||USER||' with admin option';
END;
/
GRANT SELECT ANY TABLE TO doc_readonly;
GRANT LOCK ANY TABLE TO doc_readonly;
GRANT CREATE TABLE TO doc_readonly;
GRANT CREATE VIEW  TO doc_readonly;
GRANT SELECT ANY SEQUENCE TO doc_readonly;
GRANT EXECUTE ANY PROCEDURE TO doc_readonly;
GRANT CREATE SESSION TO doc_readonly;


rem --------------------------------------------------------------------------
rem	CREATE a ROLE FOR granting TO the network data administrator

prompt CREATE ROLE net_admin;

DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE net_admin';
  NULL;
EXCEPTION
WHEN role_exists
THEN 
  Null;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'grant net_admin to '||USER;
   EXECUTE IMMEDIATE 'grant net_admin to '||USER||' with admin option';
END;
/
GRANT SELECT ANY TABLE TO net_admin;
GRANT INSERT ANY TABLE TO net_admin;
GRANT UPDATE ANY TABLE TO net_admin;
GRANT DELETE ANY TABLE TO net_admin;
GRANT LOCK ANY TABLE TO net_admin;
GRANT CREATE TABLE TO net_admin;
GRANT CREATE VIEW  TO net_admin;
GRANT SELECT ANY SEQUENCE TO net_admin;
GRANT EXECUTE ANY PROCEDURE TO net_admin;
GRANT CREATE SESSION TO net_admin;


rem --------------------------------------------------------------------------
rem	CREATE a ROLE FOR granting TO NORMAL network manager users

prompt CREATE ROLE net_user;

DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE net_user';
  NULL;
EXCEPTION
WHEN role_exists
THEN 
  Null;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'grant net_user to '||USER;
   EXECUTE IMMEDIATE 'grant net_user to '||USER||' with admin option';
END;
/

GRANT SELECT ANY TABLE TO net_user;
GRANT INSERT ANY TABLE TO net_user;
GRANT UPDATE ANY TABLE TO net_user;
GRANT DELETE ANY TABLE TO net_user;
GRANT LOCK ANY TABLE TO net_user;
GRANT CREATE TABLE TO net_user;
GRANT CREATE VIEW  TO net_user;
GRANT SELECT ANY SEQUENCE TO net_user;
GRANT EXECUTE ANY PROCEDURE TO net_user;
GRANT CREATE SESSION TO net_user;


rem --------------------------------------------------------------------------
rem	CREATE a ROLE FOR granting TO readonly network manager users

prompt CREATE ROLE net_readonly;

DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE net_readonly';
  NULL;
EXCEPTION
WHEN role_exists
THEN 
  Null;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'grant net_readonly to '||USER;
   EXECUTE IMMEDIATE 'grant net_readonly to '||USER||' with admin option';
END;
/
GRANT SELECT ANY TABLE TO net_readonly;
GRANT LOCK ANY TABLE TO net_readonly;
GRANT CREATE TABLE TO net_readonly;
GRANT CREATE VIEW  TO net_readonly;
GRANT SELECT ANY SEQUENCE TO net_readonly;
GRANT EXECUTE ANY PROCEDURE TO net_readonly;
GRANT CREATE SESSION TO net_readonly;

rem -----------------------------------------------------------------
rem
rem These grants are made to ensure the privileges are available to
rem roles created under different users

GRANT        UPDATE        ON docs TO PUBLIC;
GRANT INSERT,UPDATE,DELETE ON doc_lov_recs TO PUBLIC;
GRANT INSERT,UPDATE,DELETE ON gri_lov TO PUBLIC;
GRANT INSERT,UPDATE,DELETE ON gri_report_runs TO PUBLIC;
GRANT INSERT,UPDATE,DELETE ON gri_run_parameters TO PUBLIC;
GRANT INSERT,UPDATE,DELETE ON gri_saved_params TO PUBLIC;
GRANT INSERT,UPDATE,DELETE ON gri_saved_sets TO PUBLIC;
GRANT INSERT,UPDATE,DELETE ON hig_user_options TO PUBLIC;
GRANT INSERT,UPDATE,DELETE ON report_params TO PUBLIC;
GRANT INSERT,UPDATE,DELETE ON report_tags TO PUBLIC;

rem ---------------------------------------------------------------------------
rem These roles can now be assigned to Oracle users.
rem --------------------------------------------------------------------------
rem     Create roles for new document management forms OLE Stuff

prompt CREATE ROLE doc0201;

DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE doc0201';
  NULL;
EXCEPTION
WHEN role_exists
THEN 
  Null;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'grant doc0201 to '||USER;
   EXECUTE IMMEDIATE 'grant doc0201 to '||USER||' with admin option';
END;
/

prompt CREATE ROLE doc0202;

DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE doc0202';
  NULL;
EXCEPTION
WHEN role_exists
THEN 
  Null;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'grant doc0202 to '||USER;
   EXECUTE IMMEDIATE 'grant doc0202 to '||USER||' with admin option';
END;
/

prompt CREATE ROLE sdm_user;

DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE sdm_user';
  NULL;
EXCEPTION
WHEN role_exists
THEN 
  Null;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'grant sdm_user to '||USER;
   EXECUTE IMMEDIATE 'grant sdm_user to '||USER||' with admin option';
END;
/

GRANT CREATE TABLE TO sdm_user;
GRANT CREATE SEQUENCE TO sdm_user;
GRANT CREATE TRIGGER TO sdm_user;

prompt CREATE ROLE web_user;
DECLARE
   l_role VARCHAR2(30) := 'WEB_USER';
   TYPE tab_varchar30 IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;
   l_tab_priv tab_varchar30;
   l_tab_obj  tab_varchar30;
BEGIN
   FOR cs_rec IN (SELECT 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM dba_roles WHERE role = l_role))
    LOOP
      BEGIN
         EXECUTE IMMEDIATE 'CREATE ROLE '||l_role;
      EXCEPTION
         WHEN others THEN null;
      END;
   END LOOP;
   --
   l_tab_priv(1)  := 'SELECT';
   l_tab_obj(1)   := 'HIG_USERS';
   l_tab_priv(2)  := 'SELECT';
   l_tab_obj(2)   := 'HIG_USER_OPTIONS';
   l_tab_priv(3)  := 'SELECT';
   l_tab_obj(3)   := 'HIG_OPTIONS';
   l_tab_priv(4)  := 'SELECT';
   l_tab_obj(4)   := 'HIG_USER_ROLES';
   l_tab_priv(5)  := 'EXECUTE';
   l_tab_obj(5)   := 'HIG';
   l_tab_priv(6)  := 'EXECUTE';
   l_tab_obj(6)   := 'HIG2';
   l_tab_priv(7)  := 'EXECUTE';
   l_tab_obj(7)   := 'HIG3';
   l_tab_priv(8)  := 'EXECUTE';
   l_tab_obj(8)   := 'NM3TYPE';
   l_tab_priv(9)  := 'EXECUTE';
   l_tab_obj(9)   := 'NM3AUSEC';
   l_tab_priv(10) := 'EXECUTE';
   l_tab_obj(10)  := 'NM3CONTEXT';
   l_tab_priv(11) := 'EXECUTE';
   l_tab_obj(11)  := 'NM3FLX';
   l_tab_priv(12) := 'EXECUTE';
   l_tab_obj(12)  := 'NM3USER';
   l_tab_priv(13) := 'EXECUTE';
   l_tab_obj(13)  := 'NM3NET';
   l_tab_priv(14) := 'EXECUTE';
   l_tab_obj(14)  := 'NM_DEBUG';
   l_tab_priv(15) := 'SELECT';
   l_tab_obj(15)  := 'NM_UPLOAD_FILES';
   l_tab_priv(16) := 'EXECUTE';
   l_tab_obj(16)  := 'NM3WEB';
   --
   FOR i IN 1..l_tab_priv.COUNT
    LOOP
      BEGIN
         EXECUTE IMMEDIATE 'GRANT '||l_tab_priv(i)||' ON '||USER||'.'||l_tab_obj(i)||' TO '||l_role;
      EXCEPTION
         WHEN others THEN null;
      END;
   END LOOP;
   --
   BEGIN
      EXECUTE IMMEDIATE 'GRANT CONNECT TO '||l_role;
   EXCEPTION
      WHEN others THEN null;
   END;
   --
   BEGIN
      EXECUTE IMMEDIATE 'GRANT '||l_role||' TO '||USER;
      EXECUTE IMMEDIATE 'GRANT '||l_role||' TO '||USER||' WITH ADMIN OPTION';
   EXCEPTION
      WHEN others THEN null;
   END;
END;
/

prompt CREATE ROLE java_admin;
DECLARE
   l_role VARCHAR2(30) := 'JAVA_ADMIN';
BEGIN
   FOR cs_rec IN (SELECT 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM dba_roles WHERE role = l_role))
    LOOP
      BEGIN
         EXECUTE IMMEDIATE 'CREATE ROLE '||l_role;
      EXCEPTION
         WHEN others THEN null;
      END;
   END LOOP;
   EXECUTE IMMEDIATE 'grant '||l_role||' to '||USER;
   EXECUTE IMMEDIATE 'grant '||l_role||' to '||USER||' with admin option';
END;
/
--
prompt CREATE ROLE hig_user_admin;
DECLARE
   l_role VARCHAR2(30) := 'HIG_USER_ADMIN';
   PROCEDURE grant_ (p_thing VARCHAR2) IS
   BEGIN
      EXECUTE IMMEDIATE 'GRANT '||p_thing||' TO '||l_role;
   EXCEPTION
      WHEN others then Null;
   END grant_;
BEGIN
   FOR cs_rec IN (SELECT 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM dba_roles WHERE role = l_role))
    LOOP
      BEGIN
         EXECUTE IMMEDIATE 'CREATE ROLE '||l_role;
      EXCEPTION
         WHEN others THEN null;
      END;
   END LOOP;
   --grant_ ('ADMINISTER DATABASE TRIGGER');
   grant_ ('CREATE ANY SYNONYM');
   grant_ ('DROP ANY SYNONYM');
   grant_ ('CREATE USER');
   grant_ ('ALTER USER');
   grant_ ('CREATE ANY TABLE');
   grant_ ('CREATE ANY TRIGGER');
   grant_ ('CREATE ANY VIEW');
   EXECUTE IMMEDIATE 'grant '||l_role||' to '||USER;
   EXECUTE IMMEDIATE 'grant '||l_role||' to '||USER||' with admin option';
END;
/

-- Task 0109363
-- Create job privs
DECLARE
  role_exists EXCEPTION;
  PRAGMA EXCEPTION_INIT(role_exists, -1921); 
BEGIN
  BEGIN
    EXECUTE IMMEDIATE 'CREATE ROLE PROCESS_USER';
  EXCEPTION
    WHEN role_exists
    THEN NULL;
  END;
  EXECUTE IMMEDIATE 'GRANT CREATE JOB TO PROCESS_USER';
  EXECUTE IMMEDIATE 'GRANT CREATE EXTERNAL JOB TO PROCESS_USER';
  EXECUTE IMMEDIATE 'GRANT PROCESS_USER to '||USER;
  EXECUTE IMMEDIATE 'GRANT PROCESS_USER to '||USER||' WITH ADMIN OPTION';
EXCEPTION
  WHEN role_exists
  THEN NULL;
END;
/


DECLARE
  role_exists EXCEPTION;
  PRAGMA EXCEPTION_INIT(role_exists, -1921); 
BEGIN
  BEGIN
    EXECUTE IMMEDIATE 'CREATE ROLE PROCESS_ADMIN';
  EXCEPTION
    WHEN role_exists
    THEN NULL;
  END;
  EXECUTE IMMEDIATE 'GRANT CREATE ANY JOB TO PROCESS_ADMIN';
  EXECUTE IMMEDIATE 'GRANT CREATE EXTERNAL JOB TO PROCESS_ADMIN';
  EXECUTE IMMEDIATE 'GRANT MANAGE SCHEDULER TO PROCESS_ADMIN';
  EXECUTE IMMEDIATE 'GRANT PROCESS_ADMIN to '||USER;
  EXECUTE IMMEDIATE 'GRANT PROCESS_ADMIN to '||USER||' WITH ADMIN OPTION';
EXCEPTION
  WHEN role_exists
  THEN NULL;
END;
/

-- Task 0110486
-- FTP and EMAIL user roles for ACL access
DECLARE
  role_exists EXCEPTION;
  PRAGMA EXCEPTION_INIT(role_exists, -1921); 
BEGIN
  BEGIN
    EXECUTE IMMEDIATE 'CREATE ROLE FTP_USER';
  EXCEPTION
    WHEN role_exists
    THEN NULL;
  END;
  EXECUTE IMMEDIATE 'GRANT execute on DBMS_NETWORK_ACL_ADMIN to FTP_USER';
  EXECUTE IMMEDIATE 'GRANT FTP_USER to '||USER;
  EXECUTE IMMEDIATE 'GRANT FTP_USER to '||USER||' WITH ADMIN OPTION';
EXCEPTION
  WHEN role_exists
  THEN NULL;
END;
/


DECLARE
  role_exists EXCEPTION;
  PRAGMA EXCEPTION_INIT(role_exists, -1921); 
BEGIN
  BEGIN
    EXECUTE IMMEDIATE 'CREATE ROLE EMAIL_USER';
  EXCEPTION
    WHEN role_exists
    THEN NULL;
  END;
  EXECUTE IMMEDIATE 'GRANT execute on DBMS_NETWORK_ACL_ADMIN to EMAIL_USER';
  EXECUTE IMMEDIATE 'GRANT EMAIL_USER to '||USER;
  EXECUTE IMMEDIATE 'GRANT EMAIL_USER to '||USER||' WITH ADMIN OPTION';
EXCEPTION
  WHEN role_exists
  THEN NULL;
END;
/

Declare
  Role_Already_Exists Exception;
  Pragma Exception_Init(Role_Already_Exists,-1921);
Begin
  Execute Immediate ('Create Role Exor_Allow_User_Proxy');
Exception
  When Role_Already_Exists Then
    Null;
End;  
/

--
REM End of command file
rem
