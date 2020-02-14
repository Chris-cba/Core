CREATE OR REPLACE PACKAGE BODY hig_relationship_api
AS
  -------------------------------------------------------------------------
  --   PVCS Identifiers :-
  --
  --       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/pck/hig_relationship_api.pkb-arc   1.5   Feb 14 2020 10:25:24   Chris.Baugh  $
  --       Module Name      : $Workfile:   hig_relationship_api.pkb  $
  --       Date into PVCS   : $Date:   Feb 14 2020 10:25:24  $
  --       Date fetched Out : $Modtime:   Feb 13 2020 16:07:14  $
  --       Version          : $Revision:   1.5  $
  --       Based on SCCS version :
  ------------------------------------------------------------------
  --   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
  ------------------------------------------------------------------
  --
  --all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.5  $';

  g_package_name   CONSTANT VARCHAR2 (30) := 'hig_relationship_api';

  g_encryption_type    PLS_INTEGER := DBMS_CRYPTO.ENCRYPT_AES256
                                    + DBMS_CRYPTO.CHAIN_CBC
                                    + DBMS_CRYPTO.PAD_PKCS5;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_version
    RETURN VARCHAR2
  IS
  BEGIN
    RETURN g_sccsid;
  END get_version;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_body_version
    RETURN VARCHAR2
  IS
  BEGIN
    RETURN g_body_sccsid;
  END get_body_version;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION f_generate_password 
    RETURN VARCHAR2 
  IS
    --
    CURSOR c_valid_pwd(pi_pwd   VARCHAR2) IS
    SELECT TRANSLATE (pi_pwd,'?0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_:*!£$.,\', '?') 
     FROM  DUAL; 
    --
    lv_pwdlength     INTEGER;
    lv_return        VARCHAR2(12);
    lv_dummy         VARCHAR2(100);
    -- 
  BEGIN
  
     -- Pick a random password length between 8 and 12
  
     lv_pwdlength := 8+MOD(ABS(DBMS_RANDOM.RANDOM), 5);
  
     -- Generate the Password
  
     LOOP
     	 --
       lv_return := DBMS_RANDOM.STRING( 'p', lv_pwdlength );
             
       OPEN c_valid_pwd(pi_pwd => lv_return);
       FETCH c_valid_pwd INTO lv_dummy;
       CLOSE c_valid_pwd;
        
       EXIT WHEN lv_dummy IS NULL;    
       -- 
     END LOOP;
  
     RETURN lv_return;
     
  END f_generate_password;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION encrypt_input(pi_input_string   VARCHAR2,
                         pi_key            RAW)
    RETURN RAW
  IS
    --
    lv_return             RAW (2000);             -- stores encrypted binary text
    --
  BEGIN
    --
    lv_return        := DBMS_CRYPTO.ENCRYPT
      (
         src => UTL_I18N.STRING_TO_RAW (pi_input_string,  'AL32UTF8'),
         typ => g_encryption_type,
         key => pi_key
      );
    --
    RETURN lv_return;
    --
  END encrypt_input;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION decrypt_input(pi_input_string   RAW,
                         pi_key           RAW)
    RETURN VARCHAR2
  IS
    lv_return             VARCHAR2(200);          
    lv_decrypted_raw      RAW (2000);             -- stores encrypted binary text
  BEGIN
    --
    --
    lv_decrypted_raw := DBMS_CRYPTO.DECRYPT
      (
         src => pi_input_string,
         typ => g_encryption_type,
         key => pi_key
      );
    --
    lv_return := UTL_I18N.RAW_TO_CHAR (lv_decrypted_raw, 'AL32UTF8');
    --
    RETURN lv_return;
    --
  END decrypt_input;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_user_key(pi_attribute1 IN  hig_relationship.hir_attribute1%TYPE)
    RETURN VARCHAR2
  IS
    --
    CURSOR c1 IS
    SELECT hir_attribute4
      FROM hig_relationship
     WHERE hir_attribute1 = pi_attribute1;
    --
    lv_key  RAW(32);
    --
  BEGIN
    --
    OPEN c1;
    FETCH c1 INTO lv_key;
    CLOSE c1;
    --
    RETURN lv_key;
    --
  END get_user_key;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION pwd_autogenerate_user(pi_username IN  VARCHAR2)
    RETURN VARCHAR2
  IS
    --
    CURSOR c1 IS
    SELECT 1 
      FROM hig_relationship
     WHERE hir_attribute3 = 'Y'
       AND pi_username = decrypt_input(pi_input_string => hir_attribute2,
                                       pi_key          => hir_attribute4);
    --
    lv_dummy    PLS_INTEGER;
    lv_return   VARCHAR2(1) := 'N';
    --
  BEGIN
    --
    OPEN c1;
    FETCH c1 INTO lv_dummy;
    IF c1%FOUND 
    THEN 
      lv_return := 'Y';
    END IF;
    CLOSE c1;
    --
    RETURN lv_return;
    --
  END pwd_autogenerate_user;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_username_orm(po_cursor     OUT sys_refcursor
                            ,pi_attribute1 IN  hig_relationship.hir_attribute1%TYPE) 
  IS
  BEGIN
    --
    -- VB6 can't cope with overloading, and Nhibernate requires ref_cursor as first param.
    -- 
    get_username(pi_attribute1 => pi_attribute1
                ,po_cursor     => po_cursor);    
    --                    
  END get_username_orm;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_username(pi_attribute1 IN  hig_relationship.hir_attribute1%TYPE
                        ,po_cursor     OUT sys_refcursor)

  IS
    --
  BEGIN
    --
    OPEN po_cursor FOR
    SELECT decrypt_input(pi_input_string => hir_attribute2,
                         pi_key          => hir_attribute4) attribute1
      FROM hig_relationship,
           dba_users,
           hig_users
     WHERE hir_attribute1 = pi_attribute1
       AND NVL(account_status, 'MISSING') != 'LOCKED'
       AND username = hus_username
       AND hus_username = decrypt_input(pi_input_string => hir_attribute2,
                                        pi_key          => hir_attribute4)
       AND NVL(hus_end_date, TRUNC(sysdate+1)) >= TRUNC(sysdate);
    --
  END get_username;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_relationship(pi_relationship IN  hig_relationship%ROWTYPE)
  IS
  BEGIN
    --
    IF pi_relationship.hir_attribute1 IS NULL OR
       pi_relationship.hir_attribute2 IS NULL 
    THEN
       RAISE_APPLICATION_ERROR( -20001, 'Mandatory details have not been provided' );
    END IF;
    --
    INSERT INTO hig_relationship
      ( hir_attribute1  
       ,hir_attribute2  
       ,hir_attribute3  
       ,hir_attribute4  
      )
    VALUES
      ( pi_relationship.hir_attribute1 
       ,pi_relationship.hir_attribute2 
       ,pi_relationship.hir_attribute3 
       ,pi_relationship.hir_attribute4 
      );
    --
  END create_relationship;
   
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE update_relationship(pi_key        IN  hig_relationship.hir_attribute1%TYPE,
                                pi_attribute1 IN  hig_relationship.hir_attribute1%TYPE,
                                pi_attribute3 IN  hig_relationship.hir_attribute3%TYPE)
  IS
  BEGIN
    --
    UPDATE hig_relationship
       SET hir_attribute1 = pi_attribute1,
           hir_attribute3 = pi_attribute3
     WHERE hir_attribute1 = pi_key;
    --
  END update_relationship;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE delete_relationship(pi_attribute1 IN  hig_relationship.hir_attribute1%TYPE)
  IS
    --
    CURSOR c1 IS
    SELECT decrypt_input(pi_input_string => hir_attribute2,
                         pi_key          => hir_attribute4) attribute1
      FROM hig_relationship
     WHERE hir_attribute1 = pi_attribute1;
    --
    lv_username   Varchar2(30);
    lt_proxies    nm3type.tab_varchar30;
    --
  BEGIN
    --
    OPEN c1;
    FETCH c1 INTO lv_username;
    CLOSE c1;
    
    DELETE FROM hig_relationship
     WHERE hir_attribute1 = pi_attribute1;
    --
    -- Remove any Proxy User details
    SELECT proxy
     BULK COLLECT INTO lt_proxies
     FROM proxy_users
    WHERE client = lv_username;
    --
    FOR i IN 1 .. lt_proxies.COUNT LOOP
      --
      EXECUTE IMMEDIATE 'ALTER USER '||lv_username||' REVOKE CONNECT THROUGH '||lt_proxies(i);
      --
    END LOOP;
    --
    COMMIT;
   
  END delete_relationship;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE refresh_auto_passwords
  IS
    --
    lv_password   VARCHAR2(100); 
    lt_usernames  nm3type.tab_varchar30;
    --
  BEGIN
    --
    Hig_Process_Api.Log_It(pi_Message => 'Auto-generated Password reset started - ' || To_Char(Sysdate,'dd-mm-yyyy hh24:mi.ss') );
    --
    SELECT decrypt_input(pi_input_string => hir_attribute2,
                         pi_key          => hir_attribute4) attribute1
     BULK COLLECT INTO lt_usernames
     FROM hig_relationship
    WHERE hir_attribute3 = 'N';
   
    FOR i IN 1 .. lt_usernames.COUNT LOOP
      --
      lv_password := f_generate_password;
      
      -- need to update mcp password details
      IF hig.is_product_licensed('MCP')
      THEN
        BEGIN
          EXECUTE IMMEDIATE
            'BEGIN '||
            '  nm3mcp_sde.STORE_PASSWORD(:pi_username, :pi_password); '||
            'END;'
          USING IN lt_usernames(i), IN lv_password;
        EXCEPTION
          WHEN OTHERS THEN NULL;
        END;
      END IF;
      
      EXECUTE IMMEDIATE 'ALTER USER '||lt_usernames(i)||' IDENTIFIED BY "'||lv_password||'"';
      --
    END LOOP;
    --
    Hig_Process_Api.Log_It(pi_Message => 'Auto-generated Password reset completed - ' || To_Char(Sysdate,'dd-mm-yyyy hh24:mi.ss') );
    --
  END refresh_auto_passwords;
--
-----------------------------------------------------------------------------
--
  FUNCTION f_hig_relationship_admin( schema_in VARCHAR2, name_in VARCHAR2)
    RETURN VARCHAR2 IS
    --
    lv_return  VARCHAR2(2000);
    --
  BEGIN
    --
    lv_return := 'EXISTS (SELECT 1
                            FROM hig_user_roles
                           WHERE hur_role = ''HIG_ADMIN''
                             AND hur_username IN (Sys_Context(''NM3_SECURITY_CTX'',''USERNAME''),Sys_Context(''NM3_SECURITY_CTX'',''ACTUAL_USERNAME'')))';
    --
    RETURN lv_return;
    
  END f_hig_relationship_admin;
--
-----------------------------------------------------------------------------
--
  FUNCTION f_hig_relationship_select( schema_in VARCHAR2, name_in VARCHAR2)
    RETURN VARCHAR2 IS
    --
    lv_return  VARCHAR2(2000);
    --
  BEGIN
    --
      lv_return := 'EXISTS (SELECT 1
                              FROM proxy_users
                             WHERE proxy = USER 
                               AND EXISTS (SELECT 1
                                             FROM DBA_ROLE_PRIVS
                                            WHERE grantee = SYS_CONTEXT (''USERENV'', ''SESSION_USER'')
                                              AND granted_role = ''PROXY_OWNER'')
                            UNION
                            SELECT 1
                              FROM hig_user_roles
                             WHERE hur_role = ''HIG_ADMIN''
                               AND hur_username IN (Sys_Context(''NM3_SECURITY_CTX'',''USERNAME''),Sys_Context(''NM3_SECURITY_CTX'',''ACTUAL_USERNAME'')))';
    --
    RETURN lv_return;
    
  END f_hig_relationship_select;
--
-----------------------------------------------------------------------------
--
END hig_relationship_api;
/