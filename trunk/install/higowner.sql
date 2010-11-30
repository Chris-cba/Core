REM SCCS ID Keyword, do no remove
define sccsid = '"$Revision::   2.12     $"';
clear screen
-- creates the following tables
-- HIG_USERS
-- NM_AU_TYPES
-- NM_ADMIN_UNITS_ALL
-- NM_USER_AUS_ALL
-- NM_ADMIN_GROUPS
prompt
prompt Highways owner creation script.
prompt Exor Corporation 2003
prompt
prompt answer ALL questions, pressing RETURN AFTER EACH one
prompt

undefine p_user
undefine p_pass
undefine p_deftab
undefine p_tmptab
undefine p_startdate
undefine p_admin_type
undefine p_admin_type_descr
undefine p_admin_unit_code
undefine p_admin_unit_name

ACCEPT p_user char prompt 'ENTER THE NAME OF THE HIGHWAYS OWNER   : ';
ACCEPT p_pass  char prompt 'ENTER THE PASSWORD FOR THE TABLE OWNER : ' hide;
ACCEPT p_deftab   char prompt 'ENTER THE HIGHWAYS OWNERS DEFAULT TABLESPACE : '
ACCEPT p_tmptab   char prompt 'ENTER THE HIGHWAYS OWNER TEMPORARY TABLESPACE : '
ACCEPT p_startdate   char prompt 'ENTER SYSTEM START DATE (ALLOW FOR HISTORIC DATA) DD-MON-YYYY : '
ACCEPT p_admin_type char prompt 'ENTER THE ADMIN TYPE CODE : '
ACCEPT p_admin_type_descr char prompt 'ENTER THE DESCRIPTION FOR THE ADMIN TYPE : '
ACCEPT p_admin_unit_code char prompt 'ENTER THE ADMIN UNIT CODE : '
ACCEPT p_admin_unit_name char prompt 'ENTER THE ADMIN UNIT DESCRIPTION : '
prompt
prompt creating highways owner.............
prompt
--
SET verify OFF;
SET feedback OFF;
SET serveroutput ON
--
DECLARE
  p_user varchar2(100) := UPPER('&P_USER');
  p_pass varchar2(100) := UPPER('&P_PASS');
  p_deftab varchar2(100) := UPPER('&P_DEFTAB');
  p_tmptab varchar2(100) := UPPER('&P_TMPTAB');
  p_startdate varchar2(100) := UPPER('&P_STARTDATE');
  p_admin_type varchar2(100) := UPPER('&P_ADMIN_TYPE');
  p_admin_type_descr varchar2(100) := UPPER('&P_ADMIN_TYPE_DESCR');
  p_admin_unit_code varchar2(100) := UPPER('&P_ADMIN_UNIT_CODE');
  p_admin_unit_name varchar2(100) := UPPER('&P_ADMIN_UNIT_NAME');
--
  l_oracle9i    boolean;
  l_oracle10gr1 boolean;
  l_oracle10gr2 boolean;
  l_oracle11gr1 boolean;
  l_oracle11gr2 boolean;
--
-------------------------------------------------------------------------------
--
  FUNCTION db_is_9i RETURN boolean IS
    l_dummy pls_integer;
  BEGIN
    SELECT 1 INTO l_dummy FROM dual
     WHERE EXISTS
       (SELECT 1 FROM v$version
         WHERE UPPER(banner) LIKE '%ORACLE9I%');
    RETURN TRUE;
  EXCEPTION
    WHEN no_data_found
    THEN RETURN FALSE;
  END db_is_9i;
--
-------------------------------------------------------------------------------
--
  FUNCTION db_is_10gr1 RETURN boolean IS
    l_dummy pls_integer;
  BEGIN
    SELECT 1 INTO l_dummy FROM dual
    WHERE EXISTS
      (SELECT 1 FROM v$version
        WHERE UPPER(banner) LIKE '%10.1%');
    RETURN TRUE;
  EXCEPTION
    WHEN no_data_found
    THEN RETURN FALSE;
  END db_is_10gr1;
--
-------------------------------------------------------------------------------
--
  FUNCTION db_is_10gr2 RETURN boolean IS
    l_dummy pls_integer;
  BEGIN
    SELECT 1 INTO l_dummy FROM dual
    WHERE EXISTS
      (SELECT 1 FROM v$version
        WHERE UPPER(banner) LIKE '%10.2%');
    RETURN TRUE;
  EXCEPTION
    WHEN no_data_found
    THEN RETURN FALSE;
  END db_is_10gr2;
--
-------------------------------------------------------------------------------
--
  FUNCTION db_is_11gr1 RETURN boolean IS
    l_dummy pls_integer;
  BEGIN
    SELECT 1 INTO l_dummy FROM dual
     WHERE EXISTS
       (SELECT 1 FROM v$version
         WHERE UPPER(banner) LIKE '%11.1%');
    RETURN TRUE;
  EXCEPTION
    WHEN no_data_found
    THEN
      RETURN FALSE;
  END db_is_11gr1;
--
-------------------------------------------------------------------------------
--
  FUNCTION db_is_11gr2 RETURN boolean IS
    l_dummy pls_integer;
  BEGIN
    SELECT 1 INTO l_dummy FROM dual
     WHERE EXISTS
       (SELECT 1 FROM v$version
         WHERE UPPER(banner) LIKE '%11.2%');
    RETURN TRUE;
  EXCEPTION
    WHEN no_data_found
    THEN
      RETURN FALSE;
  END db_is_11gr2;
--
-------------------------------------------------------------------------------
--
   PROCEDURE check_listener_locks IS
--   
     CURSOR c1 IS
       SELECT distinct owner
         FROM dba_dml_locks
        WHERE  name = 'EXOR_LOCK';
--  
    TYPE tab_vc IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;
--  
    l_locks tab_vc;
--  
   BEGIN
    OPEN c1;
    FETCH c1 BULK COLLECT INTO l_locks;
    CLOSE c1;
--   
   IF l_locks.COUNT >0 THEN
      dbms_output.put_line('Please stop the exor listener processes on the following schemas before proceeding');
      dbms_output.put_line('==================================================================================');    
   END IF;
    FOR i IN 1..l_locks.COUNT LOOP
      dbms_output.put_line(l_locks(i));
    END LOOP;
   IF l_locks.COUNT >0 THEN
      dbms_output.put_line(chr(10));
      dbms_output.put_line(chr(10)); 
     RAISE_APPLICATION_ERROR(-20001,'Exor Listeners are running');
   END IF;
  END check_listener_locks;
--
-------------------------------------------------------------------------------
--
  PROCEDURE check_values ( p_user varchar2
                          ,p_pass varchar2
                          ,p_deftab varchar2
                          ,p_tmptab varchar2
                          ,p_startdate varchar2
                          ,p_admin_type varchar2
                          ,p_admin_type_descr varchar2
                          ,p_admin_unit_code varchar2
                          ,p_admin_unit_name varchar2
                         )
  IS
    CURSOR c_user_exists ( c_username varchar2 ) IS
      SELECT 1 FROM all_users
      WHERE username = UPPER(c_username);
--
    CURSOR c_run_as_system IS
      SELECT 1 FROM dual
      WHERE USER != 'SYSTEM';
--
      CURSOR c_check_tablespace ( c_tspace varchar2 ) IS
      SELECT 1 FROM dba_tablespaces
      WHERE tablespace_name = c_tspace;
--
    value_error EXCEPTION;
    err_msg varchar2(200);
    l_date varchar2(100) := NULL;
    l_dummy number;
--
    FUNCTION sys_priv_granted(pi_priv  IN varchar2
                             ,pi_admin IN varchar2 DEFAULT 'YES'
                             ) RETURN boolean IS

      l_dummy pls_integer;
    BEGIN
      SELECT 1 INTO l_dummy FROM dual
      WHERE EXISTS
        (SELECT 1 FROM dba_sys_privs dsp
          WHERE dsp.grantee = 'SYSTEM'
            AND dsp.PRIVILEGE = pi_priv
            AND dsp.admin_option = pi_admin);
      RETURN TRUE;
    EXCEPTION
      WHEN no_data_found THEN RETURN FALSE;
    END sys_priv_granted;
--
    FUNCTION obj_priv_granted(pi_obj   IN varchar2
                               ,pi_priv  IN varchar2
                               ,pi_admin IN varchar2 DEFAULT 'YES'
                               ) RETURN boolean IS
      l_dummy pls_integer;
    BEGIN
      SELECT 1 INTO l_dummy FROM dual
       WHERE EXISTS
         (SELECT 1 FROM dba_tab_privs dtp
           WHERE dtp.grantee = 'SYSTEM'
             AND dtp.table_name = pi_obj
             AND dtp.PRIVILEGE = pi_priv
             AND dtp.grantable = pi_admin);
      RETURN TRUE;
    EXCEPTION
      WHEN no_data_found THEN RETURN FALSE;
    END obj_priv_granted;
--
  BEGIN
--
    OPEN c_run_as_system;
    FETCH c_run_as_system INTO l_dummy;
    IF c_run_as_system%FOUND THEN
      CLOSE c_run_as_system;
      err_msg := 'Current user is not system';
      RAISE value_error;
    ELSE
       CLOSE c_run_as_system;
    END IF;
--
    IF p_user IS NULL OR
       p_pass IS NULL OR
       p_deftab IS NULL OR
       p_tmptab IS NULL OR
       p_startdate IS NULL OR
       p_admin_type IS NULL OR
       p_admin_type_descr IS NULL OR
       p_admin_unit_code IS NULL OR
       p_admin_unit_name IS NULL
    THEN
       err_msg := 'One one the values Entered is blank';
       RAISE value_error;
    END IF;
      --
    OPEN c_user_exists( p_user );
    FETCH c_user_exists INTO l_dummy;
    IF c_user_exists%FOUND THEN
       CLOSE c_user_exists;
       err_msg := 'User already exists';
       RAISE value_error;
    ELSE
       CLOSE c_user_exists;
    END IF;
   --
    OPEN c_check_tablespace ( p_deftab );
    FETCH c_check_tablespace INTO l_dummy;
    IF c_check_tablespace%NOTFOUND THEN
       CLOSE c_check_tablespace;
       err_msg := 'Default tablespace '''||p_deftab||''' does not exist';
       RAISE value_error;
    ELSE
       CLOSE c_check_tablespace;
    END IF;
    --
    OPEN c_check_tablespace ( p_tmptab );
    FETCH c_check_tablespace INTO l_dummy;
    IF c_check_tablespace%NOTFOUND THEN
       CLOSE c_check_tablespace;
       err_msg := 'Temporary tablespace '''||p_tmptab||''' does not exist';
       RAISE value_error;
    ELSE
       CLOSE c_check_tablespace;
    END IF;
      --
    IF LENGTH(p_admin_type) > 4
    THEN
       err_msg := 'Admin Type is greater than 4 characters';
       RAISE value_error;
    END IF ;
    IF LENGTH(p_admin_unit_code) > 10
    THEN
       err_msg := 'Admin Unit Code is greater than 10 characters';
       RAISE value_error;
    END IF ;
    BEGIN
       SELECT to_char(TO_DATE(p_startdate,'DD-MON-YYYY')) INTO l_date FROM dual;
    EXCEPTION
       WHEN others THEN
          err_msg := 'Start date format is incorrect.';
          RAISE value_error;
    END;
   
    IF l_oracle9i
      AND (NOT sys_priv_granted(pi_priv => 'SELECT ANY DICTIONARY')
           OR NOT obj_priv_granted(pi_obj  => 'DBMS_PIPE'
                                  ,pi_priv => 'EXECUTE')
           OR NOT obj_priv_granted(pi_obj  => 'DBMS_RLS'
                                  ,pi_priv => 'EXECUTE')
           OR NOT obj_priv_granted(pi_obj  => 'DBMS_LOCK'
                                  ,pi_priv => 'EXECUTE')
           OR NOT obj_priv_granted(pi_obj  => 'DBA_SYS_PRIVS'
                                  ,pi_priv => 'SELECT')
           OR NOT obj_priv_granted(pi_obj  => 'DBA_TAB_PRIVS'
                                  ,pi_priv => 'SELECT')
           OR NOT obj_priv_granted(pi_obj  => 'DBA_USERS'
                                  ,pi_priv => 'SELECT')
           OR NOT obj_priv_granted(pi_obj  => 'DBA_ROLE_PRIVS'
                                  ,pi_priv => 'SELECT')
           OR NOT obj_priv_granted(pi_obj  => 'DBA_TS_QUOTAS'
                                  ,pi_priv => 'SELECT')
           OR NOT obj_priv_granted(pi_obj  => 'DBA_ROLES'
                                  ,pi_priv => 'SELECT')
           OR NOT obj_priv_granted(pi_obj  => 'DBA_PROFILES'
                                  ,pi_priv => 'SELECT'))
    THEN
      -- system does not have privileges it needs
      err_msg := 'To create the Highways owner the SYSTEM user requires certain priveleges granted from SYS with the admin option (see hig_sys_grants.sql).';
      RAISE value_error;
    END IF;

  EXCEPTION
     WHEN value_error THEN
        Raise_Application_Error( -20001, 'ERROR : '||err_msg );
     WHEN others THEN
        RAISE;
  END check_values;
--
--------------------------------------------------------------------------------
--
  PROCEDURE create_user( p_user varchar2
                        ,p_pass varchar2
                        ,p_deftab varchar2
                        ,p_tmptab varchar2 )
  IS
  BEGIN
     
     -- Cannot grant quota on temporary tablespace for 10gR2

    IF l_oracle10gr2 OR l_oracle11gr1 OR l_oracle11gr2 THEN
      EXECUTE IMMEDIATE 'CREATE USER '|| p_user
           || CHR(10) ||' IDENTIFIED BY '||p_pass
           || CHR(10) ||' DEFAULT TABLESPACE '||p_deftab
           || CHR(10) ||' QUOTA UNLIMITED ON '||p_deftab
           || CHR(10) ||' TEMPORARY TABLESPACE '||p_tmptab
           || CHR(10) ||' QUOTA 0K ON SYSTEM';
    ELSE
       -- Assume its 9i or below
      EXECUTE IMMEDIATE 'CREATE USER '|| p_user
           || CHR(10) ||' IDENTIFIED BY '||p_pass
           || CHR(10) ||' DEFAULT TABLESPACE '||p_deftab
           || CHR(10) ||' QUOTA UNLIMITED ON '||p_deftab
           || CHR(10) ||' TEMPORARY TABLESPACE '||p_tmptab
           || CHR(10) ||' QUOTA UNLIMITED ON '||p_tmptab
           || CHR(10) ||' QUOTA 0K ON SYSTEM';
    END IF;    
  END create_user;
--
--------------------------------------------------------------------------------
--
  PROCEDURE do_grants ( p_user varchar2 )
  IS
  BEGIN
    EXECUTE IMMEDIATE 'GRANT ALTER SESSION TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT ALTER USER TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT ALTER TABLESPACE TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT CREATE PUBLIC SYNONYM TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT CREATE ANY SYNONYM TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT CREATE ANY TABLE TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT CREATE ANY INDEX TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT CREATE ANY TRIGGER TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT ALTER ANY TRIGGER TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT CREATE SEQUENCE TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT CREATE ROLE TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT CREATE SESSION TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT CREATE SYNONYM TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT CREATE PROCEDURE TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT CREATE USER TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT CREATE VIEW TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT CREATE ANY VIEW TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT DROP PUBLIC SYNONYM TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT DROP ANY TABLE TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT DROP USER TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT EXECUTE ANY PROCEDURE TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT GRANT ANY PRIVILEGE TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT GRANT ANY ROLE TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT INSERT ANY TABLE TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT LOCK ANY TABLE TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT SELECT ANY TABLE TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT SELECT ANY SEQUENCE TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT UPDATE ANY TABLE TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT DROP ANY TABLE TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT CREATE ANY TYPE TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT DROP ANY TYPE TO  ' || p_user;
    --EXECUTE IMMEDIATE 'GRANT ADMINISTER DATABASE TRIGGER TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT CREATE ANY CONTEXT TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT DROP ANY CONTEXT TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT CREATE SNAPSHOT TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT DELETE ANY TABLE TO  ' || p_user;
    EXECUTE IMMEDIATE 'GRANT DROP ANY DIRECTORY TO  ' || p_user;               -- Added by GJ 31-AUG-2005
    EXECUTE IMMEDIATE 'GRANT CREATE ANY DIRECTORY TO  ' || p_user;             -- Added by GJ 31-AUG-2005
    EXECUTE IMMEDIATE 'GRANT DROP ANY SYNONYM TO  ' || p_user;                 -- Added by GJ 17-MAY-2007
    EXECUTE IMMEDIATE 'GRANT ANALYZE ANY TO '||p_user||' WITH ADMIN OPTION';   -- Task 0108303  - GRANT ANALYZE ANY TO hig_user/admin
  --
    IF l_oracle9i OR l_oracle10gr1 OR l_oracle10gr2 OR l_oracle11gr1 OR l_oracle11gr2
    THEN
      EXECUTE IMMEDIATE 'grant create job to  '                  || p_user || ' with admin option'; -- Added by AE - 10-07-2009
      EXECUTE IMMEDIATE 'grant execute on sys.dbms_scheduler to '|| p_user || ' with grant option'; -- Added by AE - 10-07-2009
      EXECUTE IMMEDIATE 'grant select any dictionary to '        || p_user || ' with admin option';
      EXECUTE IMMEDIATE 'grant execute on sys.dbms_pipe to '     || p_user || ' with grant option';
      EXECUTE IMMEDIATE 'grant execute on sys.dbms_rls to '      || p_user || ' with grant option';
      EXECUTE IMMEDIATE 'grant execute on sys.dbms_lock to '     || p_user || ' with grant option';
      EXECUTE IMMEDIATE 'grant select on dba_sys_privs to '      || p_user || ' with grant option';
      EXECUTE IMMEDIATE 'grant select on dba_users to '          || p_user || ' with grant option';
      EXECUTE IMMEDIATE 'grant select on dba_role_privs to '     || p_user || ' with grant option';
      EXECUTE IMMEDIATE 'grant select on dba_ts_quotas to '      || p_user || ' with grant option';
      EXECUTE IMMEDIATE 'grant select on dba_tab_privs to '      || p_user || ' with grant option';
      EXECUTE IMMEDIATE 'grant select on dba_roles to '          || p_user || ' with grant option';
      EXECUTE IMMEDIATE 'grant select on dba_profiles to '       || p_user || ' with grant option';
    END IF;
  --
  END do_grants;
--
--------------------------------------------------------------------------------
--
  PROCEDURE create_tables ( p_user varchar2 )
  IS
  BEGIN

    -- HIG_USERS
    EXECUTE IMMEDIATE 'CREATE TABLE '||p_user||'.HIG_USERS'
         || CHR(10) ||'  (HUS_USER_ID NUMBER(9) NOT NULL'
         || CHR(10) ||'  ,HUS_INITIALS VARCHAR2(3) NOT NULL'
         || CHR(10) ||'  ,HUS_NAME VARCHAR2(30) NOT NULL'
         || CHR(10) ||'  ,HUS_USERNAME VARCHAR2(30) NOT NULL'
         || CHR(10) ||'  ,HUS_JOB_TITLE VARCHAR2(10)'
         || CHR(10) ||'  ,HUS_AGENT_CODE VARCHAR2(4)'
         || CHR(10) ||'  ,HUS_WOR_FLAG VARCHAR2(1)'
         || CHR(10) ||'  ,HUS_WOR_VALUE_MIN NUMBER(9)'
         || CHR(10) ||'  ,HUS_WOR_VALUE_MAX NUMBER(9)'
         || CHR(10) ||'  ,HUS_START_DATE DATE NOT NULL'
         || CHR(10) ||'  ,HUS_END_DATE DATE'
         || CHR(10) ||'  ,HUS_UNRESTRICTED VARCHAR2(1) DEFAULT ''N'' NOT NULL'
         || CHR(10) ||'  ,HUS_IS_HIG_OWNER_FLAG VARCHAR2(1) DEFAULT ''N'' NOT NULL'
         || CHR(10) ||'  ,HUS_ADMIN_UNIT NUMBER(9,0)'
         || CHR(10) ||'  ,HUS_WOR_AUR_MIN NUMBER(9,0)'
         || CHR(10) ||'  ,HUS_WOR_AUR_MAX NUMBER(9,0)'
         || CHR(10) ||'  )';

--
    EXECUTE IMMEDIATE 'ALTER TABLE '||p_user||'.HIG_USERS'
         || CHR(10) ||'ADD CONSTRAINT HIG_USERS_PK PRIMARY KEY (HUS_USER_ID)';

--
    EXECUTE IMMEDIATE 'ALTER TABLE '||p_user||'.HIG_USERS'
         || CHR(10) ||' ADD ( CONSTRAINT HUS_UK UNIQUE (HUS_USERNAME))';

-- AE REMOVED AT 4100 - Create Check constraints with proper names from Designer below
--
--    EXECUTE IMMEDIATE 'ALTER TABLE '||p_user||'.HIG_USERS'
--         || CHR(10) ||'ADD CONSTRAINT AVCON_3268_HUS_U_000 CHECK (HUS_UNRESTRICTED IN (''Y'', ''N''))'
--         || CHR(10) ||'ADD CONSTRAINT AVCON_3268_HUS_U_001 CHECK (HUS_UNRESTRICTED IN (''Y'', ''N''))'
--         || CHR(10) ||'ADD CONSTRAINT AVCON_3268_HUS_I_000 CHECK (HUS_IS_HIG_OWNER_FLAG IN (''Y'', ''N''))';

-- AE Create check constraints  
    EXECUTE IMMEDIATE 'ALTER TABLE '||p_user||'.HIG_USERS'
         || CHR(10) ||'ADD CONSTRAINT HUS_UNRESTRICTED_CHK CHECK (HUS_UNRESTRICTED IN (''Y'', ''N''))'
         || CHR(10) ||'ADD CONSTRAINT HUS_IS_HIG_OWNER_FLAG_CHK CHECK (HUS_IS_HIG_OWNER_FLAG IN (''Y'', ''N''))';

--
-- AE 
-- Task 0108549 - Index to control Hig Owner flag

    EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX '||p_user||'.HUS_OWNER_UNIQUE_FBI ON '||p_user||'.HIG_USERS '
         || CHR(10) ||' (decode(hus_is_hig_owner_flag, ''Y'', -999, hus_user_id ))';

--
    -- NM_AU_TYPES
    EXECUTE IMMEDIATE 'CREATE TABLE '||p_user||'.NM_AU_TYPES'
         || CHR(10) ||'  (NAT_ADMIN_TYPE VARCHAR2(4) NOT NULL'
         || CHR(10) ||'  ,NAT_DESCR VARCHAR2(80) NOT NULL'
         || CHR(10) ||'  ,NAT_DATE_CREATED DATE NOT NULL'
         || CHR(10) ||'  ,NAT_DATE_MODIFIED DATE NOT NULL'
         || CHR(10) ||'  ,NAT_MODIFIED_BY VARCHAR2(30) NOT NULL'
         || CHR(10) ||'  ,NAT_CREATED_BY VARCHAR2(30) NOT NULL'
         || CHR(10) ||'  )';

--
    EXECUTE IMMEDIATE 'ALTER TABLE '||p_user||'.NM_AU_TYPES'
         || CHR(10) ||'ADD CONSTRAINT NAT_PK PRIMARY KEY (NAT_ADMIN_TYPE)';

--
    -- NM_ADMIN_UNITS_ALL
    EXECUTE IMMEDIATE 'CREATE TABLE '||p_user||'.NM_ADMIN_UNITS_ALL'
         || CHR(10) ||' (NAU_ADMIN_UNIT NUMBER(9) NOT NULL'
         || CHR(10) ||' ,NAU_UNIT_CODE VARCHAR2(10) NOT NULL'
         || CHR(10) ||' ,NAU_LEVEL NUMBER(3) NOT NULL'
         || CHR(10) ||' ,NAU_AUTHORITY_CODE VARCHAR2(4)'
         || CHR(10) ||' ,NAU_NAME VARCHAR2(40) NOT NULL'
         || CHR(10) ||' ,NAU_ADDRESS1 VARCHAR2(60)'
         || CHR(10) ||' ,NAU_ADDRESS2 VARCHAR2(60)'
         || CHR(10) ||' ,NAU_ADDRESS3 VARCHAR2(60)'
         || CHR(10) ||' ,NAU_ADDRESS4 VARCHAR2(60)'
         || CHR(10) ||' ,NAU_ADDRESS5 VARCHAR2(60)'
         || CHR(10) ||' ,NAU_PHONE VARCHAR2(20)'
         || CHR(10) ||' ,NAU_FAX VARCHAR2(20)'
         || CHR(10) ||' ,NAU_COMMENTS VARCHAR2(254)'
         || CHR(10) ||' ,NAU_LAST_WOR_NO NUMBER(9)'
         || CHR(10) ||' ,NAU_START_DATE DATE DEFAULT TO_DATE(''05111605'',''DDMMYYYY'') NOT NULL'
         || CHR(10) ||' ,NAU_END_DATE DATE'
         || CHR(10) ||' ,NAU_ADMIN_TYPE VARCHAR2(4) NOT NULL'
         || CHR(10) ||' ,NAU_NSTY_SUB_TYPE     VARCHAR2(4)'
         || CHR(10) ||' ,NAU_PREFIX            VARCHAR2(10)'
         || CHR(10) ||' ,NAU_POSTCODE          VARCHAR2(10)'
         || CHR(10) ||' ,NAU_MINOR_UNDERTAKER  VARCHAR2(1)'
         || CHR(10) ||' ,NAU_TCPIP             VARCHAR2(15)'
         || CHR(10) ||' ,NAU_DOMAIN            VARCHAR2(100)'
         || CHR(10) ||' ,NAU_DIRECTORY         VARCHAR2(100)'
         || CHR(10) ||' ,NAU_EXTERNAL_NAME     VARCHAR2(80)'          
         || CHR(10) ||' )';

--
    EXECUTE IMMEDIATE 'ALTER TABLE '||p_user||'.NM_ADMIN_UNITS_ALL'
         || CHR(10) ||' ADD CONSTRAINT HAU_PK PRIMARY KEY (NAU_ADMIN_UNIT)';

--
    EXECUTE IMMEDIATE 'ALTER TABLE '||p_user||'.NM_ADMIN_UNITS_ALL'
         || CHR(10) ||'ADD CONSTRAINT HAU_UK1 UNIQUE '
         || CHR(10) ||'  (NAU_UNIT_CODE,'
         || CHR(10) ||'   NAU_ADMIN_TYPE) '
         || CHR(10) ||' ADD CONSTRAINT HAU_UK2 UNIQUE '
         || CHR(10) ||'  (NAU_NAME,'
         || CHR(10) ||'   NAU_ADMIN_TYPE)';
--
    EXECUTE IMMEDIATE 'ALTER TABLE '||p_user||'.NM_ADMIN_UNITS_ALL ADD CONSTRAINT'
         || CHR(10) ||'NAU_NAT_FK FOREIGN KEY '
         || CHR(10) ||'  (NAU_ADMIN_TYPE) REFERENCES '||p_user||'.NM_AU_TYPES'
         || CHR(10) ||'(NAT_ADMIN_TYPE)';
--
    EXECUTE IMMEDIATE 'CREATE INDEX '||p_user||'.NAU_ADDRESS1_IND ON '||p_user||'.NM_ADMIN_UNITS_ALL (NAU_ADDRESS1)' ;
    EXECUTE IMMEDIATE 'CREATE INDEX '||p_user||'.NAU_ADDRESS2_IND ON '||p_user||'.NM_ADMIN_UNITS_ALL (NAU_ADDRESS2)' ;
    EXECUTE IMMEDIATE 'CREATE INDEX '||p_user||'.NAU_TYPE_SUBTYPE_IND ON '||p_user||'.NM_ADMIN_UNITS_ALL (NAU_ADMIN_TYPE ,NAU_NSTY_SUB_TYPE)';
--

    -- NM_USER_AUS_ALL
    EXECUTE IMMEDIATE 'CREATE TABLE '||p_user||'.NM_USER_AUS_ALL'
         || CHR(10) ||' (NUA_USER_ID NUMBER(9) NOT NULL'
         || CHR(10) ||' ,NUA_ADMIN_UNIT NUMBER(9) NOT NULL'
         || CHR(10) ||' ,NUA_START_DATE DATE DEFAULT TO_DATE(''05111605'',''DDMMYYYY'') NOT NULL'
         || CHR(10) ||' ,NUA_END_DATE DATE'
         || CHR(10) ||' ,NUA_MODE VARCHAR2(30) DEFAULT ''NORMAL'' NOT NULL'
         || CHR(10) ||' )';

--
    EXECUTE IMMEDIATE 'ALTER TABLE '||p_user||'.NM_USER_AUS_ALL'
         || CHR(10) ||'ADD CONSTRAINT NUA_PK PRIMARY KEY'
         || CHR(10) ||'(NUA_USER_ID'
         || CHR(10) ||',NUA_ADMIN_UNIT'
         || CHR(10) ||',NUA_START_DATE)';

--
-- AE Changed AVCON check constraint to one named from Designer (NUA_MODE_CHK) for 4100
--
    EXECUTE IMMEDIATE 'ALTER TABLE '||p_user||'.nm_user_aus_all'
         || CHR(10) ||'ADD CONSTRAINT NUA_MODE_CHK CHECK (nua_mode IN (''NORMAL'', ''READONLY''))';
--
    EXECUTE IMMEDIATE 'ALTER TABLE '||p_user||'.NM_USER_AUS_ALL ADD CONSTRAINT'
         || CHR(10) ||' NUA_HUS_FK FOREIGN KEY '
         || CHR(10) ||'  (NUA_USER_ID) REFERENCES '||p_user||'.HIG_USERS'
         || CHR(10) ||'  (HUS_USER_ID) ON DELETE CASCADE ADD CONSTRAINT'
         || CHR(10) ||' NUA_NAU_FK FOREIGN KEY '
         || CHR(10) ||'  (NUA_ADMIN_UNIT) REFERENCES '||p_user||'.NM_ADMIN_UNITS_ALL'
         || CHR(10) ||'  (NAU_ADMIN_UNIT)';
          
-- GJ 13-JUN-2007
-- column(s) on an fk constraint must be indexed
-- so create index for NUA_NAU_FK 
-- one is not required for NUA_HUS_FK because NUA_USER_ID is indexed already as the leading column in NUA_PK primary key
--
    EXECUTE IMMEDIATE 'CREATE INDEX '||p_user||'.NUA_NAU_FK_IND ON '||p_user||'.NM_USER_AUS_ALL(NUA_ADMIN_UNIT)';
--          
--
    -- NM_ADMIN_GROUPS
    EXECUTE IMMEDIATE 'CREATE TABLE '||p_user||'.NM_ADMIN_GROUPS'
    || CHR(10) ||'(NAG_PARENT_ADMIN_UNIT NUMBER(9) NOT NULL'
    || CHR(10) ||' ,NAG_CHILD_ADMIN_UNIT NUMBER(9) NOT NULL'
    || CHR(10) ||' ,NAG_DIRECT_LINK VARCHAR2(1) NOT NULL'
    || CHR(10) ||' )';
--
    EXECUTE IMMEDIATE 'ALTER TABLE '||p_user||'.NM_ADMIN_GROUPS'
    || CHR(10) ||' ADD CONSTRAINT HAG_PK PRIMARY KEY'
    || CHR(10) ||'  (NAG_PARENT_ADMIN_UNIT'
    || CHR(10) ||'  ,NAG_CHILD_ADMIN_UNIT)';
--
    EXECUTE IMMEDIATE 'ALTER TABLE '||p_user||'.NM_ADMIN_GROUPS ADD CONSTRAINT'
    || CHR(10) ||' HAG_FK2_HAU FOREIGN KEY'
    || CHR(10) ||'  (NAG_CHILD_ADMIN_UNIT) REFERENCES '||p_user||'.NM_ADMIN_UNITS_ALL'
    || CHR(10) ||'  (NAU_ADMIN_UNIT) ADD CONSTRAINT'
    || CHR(10) ||' HAG_FK1_HAU FOREIGN KEY'
    || CHR(10) ||'  (NAG_PARENT_ADMIN_UNIT) REFERENCES '||p_user||'.NM_ADMIN_UNITS_ALL'
    || CHR(10) ||'  (NAU_ADMIN_UNIT)';

-- AE Added for 4100 - Check constraint NAG_DIRECT_LINK_CHK
--
    EXECUTE IMMEDIATE 'ALTER TABLE '||p_user||'.NM_ADMIN_GROUPS ADD (CONSTRAINT NAG_DIRECT_LINK_CHK CHECK (NAG_DIRECT_LINK IN (''Y'', ''N'')))';

-- GJ 13-JUN-2007
-- column(s) on an fk constraint must be indexed
-- so create index for HAG_FK2_HAU 
-- one is not required for HAG_FK1_HAU because NAG_PARENT_ADMIN_UNIT is indexed already as the leading column in HAG_PK primary key
--
    EXECUTE IMMEDIATE 'CREATE INDEX '||p_user||'.HAG_FK2_HAU_IND ON '||p_user||'.NM_ADMIN_GROUPS(NAG_CHILD_ADMIN_UNIT)';

-- AE Create new indexes for 41
--    
    EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX '||p_user||'.NAG_SINGLE_PARENT_IDX ON '||p_user||'.NM_ADMIN_GROUPS'
                    ||' (TO_CHAR(NAG_CHILD_ADMIN_UNIT)||''|''||CASE NAG_DIRECT_LINK WHEN ''N'' THEN CASE NAG_CHILD_ADMIN_UNIT '
                    ||' WHEN NAG_PARENT_ADMIN_UNIT THEN NULL ELSE TO_CHAR(NAG_PARENT_ADMIN_UNIT) END  WHEN ''Y'' THEN TO_CHAR(NAG_CHILD_ADMIN_UNIT) END)';
--
  END create_tables;
--
--------------------------------------------------------------------------------
--
  PROCEDURE insert_details ( p_user varchar2
                            ,p_startdate varchar2
                           )
  IS
  l_startdate date := to_date(p_startdate, 'DD-MON-YYYY');
  BEGIN
     -- HIG_USERS
     EXECUTE IMMEDIATE 'INSERT INTO '||p_user||'.HIG_USERS'
     || CHR(10) ||' (HUS_USER_ID'
     || CHR(10) ||' ,HUS_INITIALS'
     || CHR(10) ||' ,HUS_NAME'
     || CHR(10) ||' ,HUS_USERNAME'
     || CHR(10) ||' ,HUS_JOB_TITLE'
     || CHR(10) ||' ,HUS_AGENT_CODE'
     || CHR(10) ||' ,HUS_WOR_FLAG'
     || CHR(10) ||' ,HUS_WOR_VALUE_MIN'
     || CHR(10) ||' ,HUS_WOR_VALUE_MAX'
     || CHR(10) ||' ,HUS_START_DATE'
     || CHR(10) ||' ,HUS_END_DATE'
     || CHR(10) ||' ,HUS_ADMIN_UNIT'
     || CHR(10) ||' ,HUS_UNRESTRICTED'
     || CHR(10) ||' ,HUS_WOR_AUR_MIN'
     || CHR(10) ||' ,HUS_WOR_AUR_MAX'
     || CHR(10) ||' ,HUS_IS_HIG_OWNER_FLAG'
     || CHR(10) ||' )'
     || CHR(10) ||' VALUES ('
     || CHR(10) ||' 1'
     || CHR(10) ||' ,''SYS'''
     || CHR(10) ||' ,''SYSTEM ADMINISTRATOR'''
     || CHR(10) ||' ,UPPER('''||p_user||''')'
     || CHR(10) ||' ,''SUPV'''
     || CHR(10) ||' ,NULL'
     || CHR(10) ||' ,NULL'
     || CHR(10) ||' ,NULL'
     || CHR(10) ||' ,NULL'
     || CHR(10) ||' ,:B_STARTDATE'
     || CHR(10) ||' ,NULL'
     || CHR(10) ||' ,1'
     || CHR(10) ||' ,''Y'''
     || CHR(10) ||' ,NULL'
     || CHR(10) ||' ,NULL'
     || CHR(10) ||' ,''Y'')'
     USING l_startdate;

--
    -- NM_AU_TYPES
    EXECUTE IMMEDIATE 'INSERT INTO  '||p_user||'.NM_AU_TYPES'
         || CHR(10) ||'(NAT_ADMIN_TYPE '
         || CHR(10) ||',NAT_DESCR'
         || CHR(10) ||',NAT_DATE_CREATED'
         || CHR(10) ||',NAT_DATE_MODIFIED'
         || CHR(10) ||',NAT_MODIFIED_BY'
         || CHR(10) ||',NAT_CREATED_BY'
         || CHR(10) ||')'
         || CHR(10) ||' VALUES ('
         || CHR(10) ||''''||p_admin_type||''''
         || CHR(10) ||','''||p_admin_type_descr||''''
         || CHR(10) ||',SYSDATE'
         || CHR(10) ||',SYSDATE'
         || CHR(10) ||',USER'
         || CHR(10) ||',USER'
         || CHR(10) ||')';
--
    -- nm_admin_units
    EXECUTE IMMEDIATE 'INSERT INTO '||p_user||'.NM_ADMIN_UNITS_ALL'
         || CHR(10) ||' (NAU_ADMIN_UNIT'
         || CHR(10) ||' ,NAU_UNIT_CODE'
         || CHR(10) ||' ,NAU_LEVEL'
         || CHR(10) ||' ,NAU_NAME'
         || CHR(10) ||' ,NAU_START_DATE'
         || CHR(10) ||' ,NAU_ADMIN_TYPE'
         || CHR(10) ||' )'
         || CHR(10) ||' VALUES ('
         || CHR(10) ||'1'
         || CHR(10) ||','''||p_admin_unit_code||''''
         || CHR(10) ||',1'
         || CHR(10) ||','''||p_admin_unit_name||''''
         || CHR(10) ||',:b_startdate'
         || CHR(10) ||','''||p_admin_type||''''
         || CHR(10) ||')'
         USING l_startdate;
--
    -- NM_USER_AUS_ALL
    EXECUTE IMMEDIATE 'INSERT INTO '||p_user||'.NM_USER_AUS_ALL'
         || CHR(10) ||' (NUA_USER_ID'
         || CHR(10) ||' ,NUA_ADMIN_UNIT'
         || CHR(10) ||' ,NUA_START_DATE'
         || CHR(10) ||' ,NUA_END_DATE'
         || CHR(10) ||' ,NUA_MODE'
         || CHR(10) ||' )'
         || CHR(10) ||' VALUES ('
         || CHR(10) ||'1'
         || CHR(10) ||',1'
         || CHR(10) ||',:b_startdate'
         || CHR(10) ||',NULL'
         || CHR(10) ||',''NORMAL'''
         || CHR(10) ||')'
         USING l_startdate;
--
     EXECUTE IMMEDIATE 'INSERT INTO '||p_user||'.NM_ADMIN_GROUPS'
         || CHR(10) ||' (NAG_PARENT_ADMIN_UNIT'
         || CHR(10) ||' ,NAG_CHILD_ADMIN_UNIT'
         || CHR(10) ||' ,NAG_DIRECT_LINK'
         || CHR(10) ||' )'
         || CHR(10) ||' VALUES ('
         || CHR(10) ||' 1'
         || CHR(10) ||',1'
         || CHR(10) ||',''N'''
         || CHR(10) ||')';
--
  END insert_details;
--
--------------------------------------------------------------------------------
--
  PROCEDURE create_views ( p_user varchar2
                          ,p_admin_type varchar2 )
  IS
    success_with_compilation_error EXCEPTION;
    PRAGMA EXCEPTION_INIT( success_with_compilation_error, -24344);
  BEGIN
     EXECUTE IMMEDIATE 'CREATE OR REPLACE FORCE VIEW '||p_user||'.hig_admin_units'
          || CHR(10) ||'('
          || CHR(10) ||'hau_admin_unit,'
          || CHR(10) ||'hau_unit_code,'
          || CHR(10) ||'hau_level,'
          || CHR(10) ||'hau_authority_code,'
          || CHR(10) ||'hau_name,'
          || CHR(10) ||'hau_address1,'
          || CHR(10) ||'hau_address2,'
          || CHR(10) ||'hau_address3,'
          || CHR(10) ||'hau_address4,'
          || CHR(10) ||'hau_address5,'
          || CHR(10) ||'hau_phone,'
          || CHR(10) ||'hau_fax,'
          || CHR(10) ||'hau_comments,'
          || CHR(10) ||'hau_last_wor_no,'
          || CHR(10) ||'hau_start_date,'
          || CHR(10) ||'hau_end_date )'
          || CHR(10) ||'AS SELECT'
          || CHR(10) ||'nau_admin_unit,'
          || CHR(10) ||'nau_unit_code,'
          || CHR(10) ||'nau_level,'
          || CHR(10) ||'nau_authority_code,'
          || CHR(10) ||'nau_name,'
          || CHR(10) ||'nau_address1,'
          || CHR(10) ||'nau_address2,'
          || CHR(10) ||'nau_address3,'
          || CHR(10) ||'nau_address4,'
          || CHR(10) ||'nau_address5,'
          || CHR(10) ||'nau_phone,'
          || CHR(10) ||'nau_fax,'
          || CHR(10) ||'nau_comments,'
          || CHR(10) ||'nau_last_wor_no,'
          || CHR(10) ||'nau_start_date,'
          || CHR(10) ||'nau_end_date'
          || CHR(10) ||'FROM nm_admin_units'
          || CHR(10) ||'WHERE nau_admin_type ='''||p_admin_type||'''';
  EXCEPTION
     WHEN success_with_compilation_error THEN
         NULL;
  END create_views ;
--
--------------------------------------------------------------------------------
--
  PROCEDURE cre_context( p_user varchar2 )
  IS
  BEGIN
     -- Create the context in a bit of dynamic sql to allow the context
     -- to be created with the username as part of the context name
     -- This should only be run as the highways owner
     EXECUTE IMMEDIATE 'CREATE CONTEXT nm3_'||p_user||' USING '||p_user||'.nm3context';
  END;
--
--------------------------------------------------------------------------------
--
  PROCEDURE create_mdsys_synonym
  IS
  BEGIN
     EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM sdo_geometry FOR MDSYS.SDO_GEOMETRY';
  EXCEPTION
     WHEN OTHERS THEN NULL;
  END create_mdsys_synonym;
--
--------------------------------------------------------------------------------
--
BEGIN
--
  l_oracle9i  := db_is_9i;
  l_oracle10gr1 := db_is_10gr1;
  l_oracle10gr2 := db_is_10gr2;
  l_oracle11gr1 := db_is_11gr1;
  l_oracle11gr2 := db_is_11gr2;
--
  check_listener_locks;
-- 
  check_values ( p_user
                ,p_pass
                ,p_deftab
                ,p_tmptab
                ,p_startdate
                ,p_admin_type
                ,p_admin_type_descr
                ,p_admin_unit_code
                ,p_admin_unit_name
                );
--
  create_user( p_user => p_user
              ,p_pass => p_pass
              ,p_deftab => p_deftab
              ,p_tmptab => p_tmptab );
--
  do_grants ( p_user => p_user );
--
  create_tables ( p_user => p_user );
--
  insert_details ( p_user => p_user
                  ,p_startdate => p_startdate );
--
  create_views ( p_user
                ,p_admin_type );
--
  cre_context( p_user );
--
  create_mdsys_synonym;
--
  COMMIT;
--
END cre_higowner;
/
