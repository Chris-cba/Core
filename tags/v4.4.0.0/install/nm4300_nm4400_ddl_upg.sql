------------------------------------------------------------------
-- nm4300_nm4400_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4300_nm4400_ddl_upg.sql-arc   3.5   Apr 18 2011 16:11:30   Mike.Alexander  $
--       Module Name      : $Workfile:   nm4300_nm4400_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Apr 18 2011 16:11:30  $
--       Date fetched Out : $Modtime:   Apr 18 2011 16:06:12  $
--       Version          : $Revision:   3.5  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Dropping of incorrect index
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 110412
-- 
-- TASK DETAILS
-- The constraints on the Type Inclusion table have been modified to allow multiple parent inclusion types.
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- Table was incorrectly restricting the user to one entry per parent thing was incorrect.
-- 
------------------------------------------------------------------
DECLARE
--
   l_exception  EXCEPTION;
   PRAGMA EXCEPTION_INIT(l_exception,-02443);
--
BEGIN
--
EXECUTE IMMEDIATE 'ALTER TABLE NM_TYPE_INCLUSION DROP CONSTRAINT NTI_PARENT_TYPE_UK  DROP INDEX';
--
EXCEPTION 
WHEN l_exception THEN
    NULL;
WHEN OTHERS THEN
    RAISE;
END;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Element Description field increase
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 107857
-- 
-- TASK DETAILS
-- A number of changes have been made to allow a number of forms to show long element descriptions. This includes NM0105, NM0122, NM0510, NM0560, NM0590, NM1401, NM1861, NM7051 as well as others that reference these forms. This is ongoing work and a handful of modules such as reports still exhibit this problem.
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- Increase in field length for element description fields.
-- 
------------------------------------------------------------------
ALTER TABLE nm_assets_on_route MODIFY
(
nar_element_descr VARCHAR2(240)
)
/

ALTER TABLE nm_reversal MODIFY
(
ne_descr VARCHAR2(240)
)
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT DOCS.DOC_COMPL_LOCATION increase to 1000 chars
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 110415
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS BAUGH)
-- DOCS.DOC_COMPL_LOCATION increased to varchar2(1000)
-- 
------------------------------------------------------------------
alter table docs
modify
( doc_compl_location   varchar2(1000)
)
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New columns for NM0575_MATCHING_RECORDS table
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADE EDWARDS)
-- New columns for NM0575_MATCHING_RECORDS table
-- 
------------------------------------------------------------------
Declare
  col_exists Exception;
  Pragma Exception_Init( col_exists, -1430);
Begin
  Execute Immediate 'alter table nm0575_matching_records add asset_wholly_enclosed number';
Exception When col_exists Then
  Null;
End;
/

Declare
  col_exists Exception;
  Pragma Exception_Init( col_exists, -1430);
Begin
  Execute Immediate 'alter table nm0575_matching_records add asset_partially_enclosed number';
Exception When col_exists Then
  Null;
End;
/

Declare
  col_exists Exception;
  Pragma Exception_Init( col_exists, -1430);
Begin
  Execute Immediate 'alter table nm0575_matching_records add asset_contiguous varchar2(1)';
Exception When col_exists Then
  Null;
End;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Add new Roles for FTP and EMAIL ACL security
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 110486
-- 
-- TASK DETAILS
-- Changes in Oracle 11.2  require that access control lists (ACLs) are defined for any host the database attempts to communicate with via FTP or Email protocols. Highways will now maintain an ACL for both FTP and Email, and access is given to users via two new roles, FTP_USER and EMAIL_USER. During the 4.4 upgrade, all users will be given these roles. The roles can be revoked to control usage of FTP and EMail.
-- 
-- 
-- DEVELOPMENT COMMENTS (ADE EDWARDS)
-- Add new Roles for FTP and EMAIL ACL security
-- 
------------------------------------------------------------------
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
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON DBMS_NETWORK_ACL_ADMIN TO FTP_USER';
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
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON DBMS_NETWORK_ACL_ADMIN TO EMAIL_USER';
  EXECUTE IMMEDIATE 'GRANT EMAIL_USER to '||USER;
  EXECUTE IMMEDIATE 'GRANT EMAIL_USER to '||USER||' WITH ADMIN OPTION';
EXCEPTION
  WHEN role_exists
  THEN NULL;
END;
/


INSERT INTO HIG_ROLES
SELECT 
   'FTP_USER', 'HIG', 'FTP User role'
  FROM DUAL
 WHERE NOT EXISTS ( SELECT 1 FROM hig_roles WHERE hro_role = 'FTP_USER');

INSERT INTO HIG_ROLES
 SELECT
   'EMAIL_USER', 'HIG', 'Email User role'
   FROM DUAL
 WHERE NOT EXISTS ( SELECT 1 FROM hig_roles WHERE hro_role = 'EMAIL_USER');

INSERT INTO hig_user_roles
(hur_username, hur_role, hur_start_date)
SELECT hus_username, 'FTP_USER', hus_start_date
  FROM hig_users
 WHERE EXISTS
   (SELECT 1 FROM all_users
     WHERE username = hus_username)
   AND NOT EXISTS
   (SELECT 1 FROM hig_user_roles
     WHERE hur_username = hus_username
       AND hur_role = 'FTP_USER');
       
INSERT INTO hig_user_roles
(hur_username, hur_role, hur_start_date)
SELECT hus_username, 'EMAIL_USER', hus_start_date
  FROM hig_users
 WHERE EXISTS
   (SELECT 1 FROM all_users
     WHERE username = hus_username)
   AND NOT EXISTS
   (SELECT 1 FROM hig_user_roles
     WHERE hur_username = hus_username
       AND hur_role = 'EMAIL_USER');

BEGIN
  FOR i IN
    (SELECT 'GRANT FTP_USER TO '||username l_sql
       FROM all_users, hig_users
      WHERE hus_username = username
        AND hus_is_hig_owner_flag = 'N'
     UNION
     SELECT 'GRANT EMAIL_USER TO '||username l_sql
       FROM all_users, hig_users
      WHERE hus_username = username
        AND hus_is_hig_owner_flag = 'N'
     UNION
     SELECT 'GRANT EXECUTE ON DBMS_NETWORK_ACL_ADMIN TO '||username l_sql
       FROM all_users, hig_users
      WHERE hus_username = username
        AND hus_is_hig_owner_flag = 'N')
  LOOP
    EXECUTE IMMEDIATE i.l_sql;
  END LOOP;
END;
/



------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New grant for PROCESS_ADMIN Role
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 109403
-- 
-- TASK DETAILS
-- Introduced functionalty to allow the Process Framework to be switched off.
-- 
-- A new Form HIG2550 Process Framework Administration has been introduced to show the Status of the Process Framework and to allow it to be shut down/started.
-- 
-- Additional pre-upgrade/pre-install checks have been added to product upgrade and install scripts to shut down the framework and to ensure that there are no running processes.
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- New grant for PROCESS_ADMIN Role. Added to allow users to use new HIG2550 form without priv errors
-- 
------------------------------------------------------------------
BEGIN
  EXECUTE IMMEDIATE 'GRANT MANAGE SCHEDULER TO PROCESS_ADMIN';
  EXECUTE IMMEDIATE 'GRANT MANAGE SCHEDULER TO '||USER||' with admin option';
END;
/

BEGIN
  FOR i IN
    (SELECT 'GRANT MANAGE SCHEDULER TO '||username l_sql
       FROM all_users, dba_role_privs, hig_users
      WHERE grantee = username
        AND granted_role IN ('PROCESS_ADMIN')
        AND hus_username = username
        AND hus_is_hig_owner_flag = 'N')
  LOOP
    EXECUTE IMMEDIATE i.l_sql;
  END LOOP;
END;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Remove redundant context
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- Remove redundant context as specified in task 110733.
-- 
------------------------------------------------------------------
Declare
  Context_Not_Exists Exception;
  Pragma Exception_Init(Context_Not_Exists, -4043); 
Begin
  Begin
    Execute Immediate 'Drop Context NM_SQL';
  Exception
    When Context_Not_Exists
    Then Null;
  End;
End;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Remove Case Constraint
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 110868
-- 
-- TASK DETAILS
-- Restore Case formatting of domain controlled attributes
-- 
-- 
-- DEVELOPMENT COMMENTS (ADE EDWARDS)
-- Remove Case Constraint
-- 
------------------------------------------------------------------

ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL DROP CONSTRAINT ITA_CASE_CHK;


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Remove MV Highlight PK Constraint
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADE EDWARDS)
-- Remove MV Highlight PK Constraint
-- 
------------------------------------------------------------------
PROMPT Drop the Primary Key constraint

DECLARE
  ex_not_exists EXCEPTION;
  PRAGMA EXCEPTION_INIT (ex_not_exists,-02443);
BEGIN
  EXECUTE IMMEDIATE 
    'ALTER TABLE MV_HIGHLIGHT DROP CONSTRAINT MV_HIGHLIGHT_PK';
EXCEPTION
  WHEN ex_not_exists THEN NULL;
END;
/

PROMPT Create a non-unique index to replace it

DECLARE
  ex_not_exists EXCEPTION;
  PRAGMA EXCEPTION_INIT (ex_not_exists,-01418);
BEGIN
  EXECUTE IMMEDIATE
    'DROP INDEX MV_HIGHLIGHT_IND';
  EXECUTE IMMEDIATE
    'CREATE INDEX MV_HIGHLIGHT_IND ON MV_HIGHLIGHT(MV_ID, MV_FEAT_TYPE)';
EXCEPTION
  WHEN ex_not_exists 
  THEN 
    EXECUTE IMMEDIATE
      'CREATE INDEX MV_HIGHLIGHT_IND ON MV_HIGHLIGHT(MV_ID, MV_FEAT_TYPE)';
END;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Remove Type Inclusion UK Constraint
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADE EDWARDS)
-- Remove Type Inclusion UK Constraint
-- 
------------------------------------------------------------------
DECLARE
   l_exception  EXCEPTION;
   PRAGMA EXCEPTION_INIT(l_exception,-02443);
--
BEGIN
--
EXECUTE IMMEDIATE 'ALTER TABLE NM_TYPE_INCLUSION DROP CONSTRAINT NTI_PARENT_TYPE_UK  DROP INDEX';
--
EXCEPTION 
WHEN l_exception THEN
    NULL;
WHEN OTHERS THEN
    RAISE;
END;
/

------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

