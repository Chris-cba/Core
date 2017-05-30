CREATE OR REPLACE PACKAGE BODY hig_user_login_util AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/hig_user_login_util.pkb-arc   1.3   May 30 2017 10:49:40   Chris.Baugh  $
--       Module Name      : $Workfile:   hig_user_login_util.pkb  $
--       Date into PVCS   : $Date:   May 30 2017 10:49:40  $
--       Date fetched Out : $Modtime:   May 25 2017 15:55:36  $
--       PVCS Version     : $Revision:   1.3  $
--
--   Author : Vikas Mhetre
--
-----------------------------------------------------------------------------
-- Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
-- all global package variables here
--
   g_body_sccsid     constant varchar2(30) :='"$Revision:   1.3  $"';
--
   g_package_name    CONSTANT  VARCHAR2(30)   := 'hig_user_login_util';
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
--------------------------------------------------------------------------------------------------
--
  FUNCTION encrypt_answer( pi_answer IN hig_user_access_security.huas_answer%TYPE ) RETURN VARCHAR2
  IS
    l_string          hig_user_access_security.huas_answer%TYPE;
    l_encrypt_answer  VARCHAR2(1000);
    g_key             VARCHAR2(2078) := 'I9ir93FJd92jd';
  BEGIN
--
    l_string := RPAD( pi_answer, (TRUNC(LENGTHB(pi_answer)/8)+1)*8, CHR(0));
--
    DBMS_OBFUSCATION_TOOLKIT.DESENCRYPT
      ( input_string     => l_string,
        key_string       => g_key,
        encrypted_string => l_encrypt_answer );
--  
    RETURN l_encrypt_answer;
  END encrypt_answer;
--
--------------------------------------------------------------------------------------------------
--
  FUNCTION decrypt_answer( pi_string IN VARCHAR2) RETURN VARCHAR2
  IS
    l_answer     hig_user_access_security.huas_answer%TYPE;
    g_key        VARCHAR2(2078) := 'I9ir93FJd92jd';    
  BEGIN
--
    DBMS_OBFUSCATION_TOOLKIT.DESDECRYPT
      ( input_string     => pi_string,
        key_string       => g_key,
        decrypted_string => l_answer );
--  
    RETURN TRIM(BOTH CHR(0) FROM l_answer);
--
  END decrypt_answer;
--
--------------------------------------------------------------------------------------------------
--
  FUNCTION send_mail(msg_from_uname hig_users.hus_username%TYPE,
                     msg_to_uname   hig_users.hus_username%TYPE,
                     msg_subject    VARCHAR2,
                     msg_text       VARCHAR2 
                     ) RETURN VARCHAR2
  IS
--
    msg_from    nm_mail_users.nmu_email_address%TYPE := NULL;
    msg_to      nm_mail_users.nmu_email_address%TYPE := NULL;
    from_name   nm_mail_users.nmu_name%TYPE := NULL;
    from_uname  hig_users.hus_username%TYPE;
    user_from_text VARCHAR2(5);
--
    conn        utl_smtp.connection := NULL;
--
    mail_host hig_options.hop_value%TYPE := hig.get_user_or_sys_opt('SMTPSERVER');
    mail_port hig_options.hop_value%TYPE := hig.get_user_or_sys_opt('SMTPPORT');
    mail_domain hig_options.hop_value%TYPE := hig.get_user_or_sys_opt('SMTPDOMAIN');
--
    ------------------------------------------------------------------------------
--
    FUNCTION get_email_address(email_uname hig_users.hus_username%TYPE) 
    RETURN VARCHAR2 IS
       email_id nm_mail_users.nmu_email_address%TYPE := NULL;
    BEGIN
       SELECT nmu_email_address 
       INTO   email_id 
       FROM   nm_mail_users, hig_users 
       WHERE  nmu_hus_user_id = hus_user_id
       AND    hus_username = email_uname;

       RETURN email_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20001, 'Email address not specified in the system for user ' || email_uname);
    END get_email_address;
--
    ------------------------------------------------------------------------------
--
    PROCEDURE send_header(name IN VARCHAR2, header IN VARCHAR2) IS
    BEGIN
      utl_smtp.write_data(conn, name || ': ' || header || UTL_TCP.CRLF);
    END send_header;
--
    ------------------------------------------------------------------------------
--
  BEGIN
    IF msg_from_uname IS NULL THEN 
      from_uname := SYS_CONTEXT('NM3_SECURITY_CTX', 'USERNAME');
      user_from_text := 'ADMIN';
    ELSE
      from_uname := msg_from_uname;
      user_from_text := 'user';
    END IF;
--
    msg_from  := get_email_address(from_uname);
    msg_to    := get_email_address(msg_to_uname);
--
    SELECT nmu_name 
    INTO   from_name 
    FROM   nm_mail_users, hig_users 
    WHERE  nmu_hus_user_id = hus_user_id
    AND    hus_username = from_uname;
--
    IF msg_from IS NULL THEN
      RAISE_APPLICATION_ERROR(-20002, 'Missing email-id for ' || user_from_text || ' - ' || from_uname);
    ELSIF msg_to IS NULL THEN
      RAISE_APPLICATION_ERROR(-20003, 'Missing email-id for user - ' || msg_to_uname);
    ELSIF mail_host IS NULL OR mail_port IS NULL OR mail_domain IS NULL THEN
      RAISE_APPLICATION_ERROR(-20004, 'Missing SMTP settings. Please check the Product Options.');
    END IF;
--
    conn := utl_smtp.open_connection(host => mail_host, port => mail_port);
--
    utl_smtp.helo(conn, mail_domain);
    utl_smtp.mail(conn, msg_from);
    utl_smtp.rcpt(conn, msg_to);
--
    utl_smtp.open_data(conn);
--
    send_header('From', from_name || ' <' || msg_from || '>');
    send_header('To', msg_to);
    send_header('Subject', msg_subject);
--
    utl_smtp.write_data(conn, utl_tcp.crlf || msg_text);
    utl_smtp.close_data(conn);
    utl_smtp.quit(conn);
--
    RETURN 'Y';
--
  EXCEPTION 
    WHEN OTHERS THEN
      RETURN SQLCODE ||':'||SQLERRM;
  END send_mail;
--
--------------------------------------------------------------------------------------------------
--
  PROCEDURE alter_profile(alter_profile_text IN VARCHAR2,
                          error_code         OUT NUMBER,
                          error_message      OUT VARCHAR2) IS
  BEGIN
--
    EXECUTE IMMEDIATE alter_profile_text;
--
  EXCEPTION
    WHEN OTHERS THEN
      error_code := SQLCODE;
      error_message := SUBSTR(SQLERRM, 1, 200);
--        
  END ALTER_PROFILE;
--
--------------------------------------------------------------------------------------------------
--
/*#############################
  # APIs used by HIGLOGN form #
  #############################*/
  
--
--------------------------------------------------------------------------------------------------
--
  FUNCTION validate_password (p_username    hig_users.hus_username%TYPE,
                              p_password    VARCHAR2)
    RETURN VARCHAR2
  IS
    lv_pwd_raw      RAW (128);
    lv_enc_raw      RAW (2048);
    lv_hash_found   VARCHAR2 (300);
    --
    CURSOR c_main (cp_user IN VARCHAR2)
    IS
      SELECT SUBSTR (spare4, 3, 40) hash,
             SUBSTR (spare4, 43, 20) SALT,
             spare4
       FROM sys.user$
      WHERE name = cp_user;
    --
    lv_user         c_main%ROWTYPE;
    --
  BEGIN
    --
    OPEN  c_main (UPPER (p_username));
    FETCH c_main INTO lv_user;
    CLOSE c_main;
    --
    lv_pwd_raw := UTL_RAW.CAST_TO_RAW (p_password) || HEXTORAW (lv_user.salt);
    --
    lv_enc_raw := SYS.DBMS_CRYPTO.HASH (lv_pwd_raw, 3);
    --
    lv_hash_found := UTL_RAW.CAST_TO_VARCHAR2 (lv_enc_raw);
    --
    IF lv_enc_raw = lv_user.hash THEN
          RETURN 'Y';
    ELSE
          RETURN 'N';
    END IF;
    --
  END validate_password;
--
--------------------------------------------------------------------------------------------------
--
  FUNCTION get_user_id(pi_username  IN  VARCHAR2)
    RETURN NUMBER
  IS
    --
    CURSOR c1 IS
    SELECT hus_user_id
      FROM hig_users
     WHERE hus_username = pi_username;
     --
     lv_return      hig_users.hus_user_id%TYPE;
     lv_row_found   BOOLEAN;
     --
  BEGIN
    --
    OPEN c1;
    FETCH c1 INTO lv_return;
    lv_row_found := c1%FOUND;
    CLOSE c1;
    --
    IF lv_row_found THEN
      --
      RETURN lv_return;
      --
    ELSE
      --
      RETURN 0;
      --
    END IF;
    --
  END get_user_id;
--
--------------------------------------------------------------------------------------------------
--
  FUNCTION email_unlock(pi_username  IN  VARCHAR2)
    RETURN VARCHAR2
  IS
    --
    CURSOR c1 IS
    SELECT 1
      FROM nm_mail_users,
           hig_users
     WHERE nmu_hus_user_id = hus_user_id
       AND hus_username = pi_username;
    --
    CURSOR c2 IS
    SELECT 1
      FROM nm_mail_users,
           hig_users
     WHERE nmu_hus_user_id = hus_user_id
       AND hus_is_hig_owner_flag = 'Y'
       AND nmu_email_address IS NOT NULL;
    --
    lv_row_found       BOOLEAN;
    lv_dummy           PLS_INTEGER;
    --
  BEGIN
    --
    OPEN c1;
    FETCH c1 INTO lv_dummy;
    lv_row_found := c1%FOUND;
    CLOSE c1;
    --
    IF NOT lv_row_found  THEN
      --
      RETURN 'N';
      --
    ELSE
      --
      OPEN c2;
      FETCH c2 INTO lv_dummy;
      lv_row_found := c2%FOUND;
      CLOSE c2;
      
      IF lv_row_found THEN
        --
        RETURN 'Y';
        --
      ELSE
        --
        RETURN 'N';
      END IF;
    END IF;
    --
  END email_unlock;
--
--------------------------------------------------------------------------------------------------
--
  FUNCTION email_system_admin(pi_username  IN  VARCHAR2)
    RETURN VARCHAR2
  IS
    --
    CURSOR c1 IS
    SELECT hus_username
      FROM nm_mail_users,
           hig_users
     WHERE nmu_hus_user_id = hus_user_id
       AND hus_is_hig_owner_flag = 'Y'
       AND nmu_email_address IS NOT NULL;
    --
    lv_sys_username   hig_users.hus_username%TYPE;
    lv_email_text     VARCHAR2(32767);
    lv_result         VARCHAR2(32767);
    --
  BEGIN
    --
    lv_email_text := 'EXOR System Administrator,' || CHR(10) || 
                     'This is to notify you that user ' || UPPER(pi_username) || ' has locked their EXOR user account and requires it to be unlocked.'|| CHR(10) ||
                     'Thank you. ';
 	  --
    OPEN c1;
    FETCH c1 INTO lv_sys_username;
    CLOSE c1;
    --
    lv_result := send_mail(msg_from_uname => NVL(pi_username,SYS_CONTEXT('NM3_SECURITY_CTX', 'USERNAME'))
                          ,msg_to_uname   => lv_sys_username
                          ,msg_subject    => 'Exor Auto-generated unlock account Request'
                          ,msg_text       => lv_email_text
                          );
    --
    RETURN lv_result;
    --
  END email_system_admin;
--
--------------------------------------------------------------------------------------------------
--
  FUNCTION check_birthdate(pi_user_id   IN hig_user_access_security.huas_hus_user_id%TYPE
                          ,pi_birthdate IN VARCHAR2)
    RETURN VARCHAR2
  IS
    --
    CURSOR c1 IS
    SELECT TO_CHAR(huas_birthdate, 'DD-MON-RRRR')
      FROM hig_user_access_security
     WHERE huas_hus_user_id = pi_user_id;
    --
    lv_dob         VARCHAR2(11);
    lv_row_found   BOOLEAN;
    --
  BEGIN
    --
    OPEN c1;
    FETCH c1 INTO lv_dob;
    lv_row_found := c1%FOUND;
    CLOSE c1;
    --
    IF NOT lv_row_found THEN
      --
      RETURN 'Not Defined';
      --
    ELSIF UPPER(pi_birthdate) = UPPER(lv_dob) THEN
      --
      RETURN 'Y';
      --
    ELSE 
      --
      RETURN 'N';
      --
    END IF;
    --
  END check_birthdate;
--
--------------------------------------------------------------------------------------------------
--
  FUNCTION check_security_answer(pi_user_id          IN  hig_user_access_security.huas_hus_user_id%TYPE
                                ,pi_security_answer  IN  VARCHAR2)
    RETURN VARCHAR2
  IS
    --
    CURSOR c1 IS
    SELECT huas_answer
      FROM hig_user_access_security, hig_users 
     WHERE huas_hus_user_id = hus_user_id         	                                                    
       AND hus_user_id =  pi_user_id;
    --
    lv_security_answer   VARCHAR2(32767);
    lv_decrypt_answer    VARCHAR2(32767);
    lv_row_found         BOOLEAN;
    --
  BEGIN
    --
    OPEN c1;
    FETCH c1 INTO lv_security_answer;
    lv_row_found := c1%FOUND;
    CLOSE c1;
    --
    IF NOT lv_row_found THEN
      --
      RETURN 'Not Defined';
      --
    END IF;
    --
    lv_decrypt_answer := hig_user_login_util.decrypt_answer(lv_security_answer);
    --
    IF UPPER(lv_decrypt_answer) = UPPER(pi_security_answer) THEN
      --
      RETURN 'Y';  
      --
    ELSE       
      --
      RETURN 'N';   
      --
    END IF;
    --
  END check_security_answer;
--
--------------------------------------------------------------------------------------------------
--
  PROCEDURE get_login_image(po_cursor  OUT SYS_REFCURSOR)
  IS 
    --
  BEGIN
    --
    OPEN po_cursor FOR 'SELECT hig.get_sysopt(''LOGONIMAGE'')'||
                       '  FROM dual';
    --
  END get_login_image;
--
--------------------------------------------------------------------------------------------------
--
  PROCEDURE get_user_security_question(pi_user_id   IN  hig_user_access_security.huas_hus_user_id%TYPE
                                      ,po_cursor    OUT SYS_REFCURSOR)
  IS
    --
  BEGIN
    --
    OPEN po_cursor FOR 'SELECT hc.hco_meaning security_question'||
		                   '  FROM hig_domains hd, '||
		                   '       hig_codes hc, '||
		                   '       hig_user_access_security huas '||
		                   '  WHERE hd.hdo_domain = hc.hco_domain (+) '||
		                   '  AND hc.hco_code = huas.huas_ques_code '||
		                   '  AND huas.huas_hus_user_id = ' || pi_user_id || 
		                   '  AND hd.hdo_domain = ''SECURITY_QUESTIONS'''||
		                   '  AND hc.hco_end_date IS NULL';
    --
  END get_user_security_question;
--
--------------------------------------------------------------------------------------------------
--
  FUNCTION generate_user_password(pi_username  IN  VARCHAR2)
    RETURN VARCHAR2
  IS
     --
     lv_new_password   VARCHAR2(32767);
     lv_email_text     VARCHAR2(32767);
     lv_result         VARCHAR2(32767);
     --
   BEGIN
     -- Generate the new password
     lv_new_password := sys.exor_password_engine.f_generate(pi_username);
   	                               
     -- Define Email text
     lv_email_text := 'Dear EXOR user,' || CHR(10) ||
   	                  'A new password has been generated by EXOR for you. Please use this new password, along with your username, the next time you login to EXOR.' || CHR(10) ||
   	                  'Login Id: ' || UPPER(pi_username) || '' || CHR(10) ||
   	                  'Password: ' || lv_new_password || '' || CHR(10) ||
   	                  'You will be prompted to change this password the first time you login.' || CHR(10) ||
   	                  'Thank you. ';
   	                                 
     -- so now get the email id of the user from the system and send the temporary one time password to user on the registered email 
     lv_result := send_mail(msg_from_uname => NULL
                           ,msg_to_uname   => pi_username
                           ,msg_subject    => 'Exor Auto-generated Password Notification'
                           ,msg_text       => lv_email_text
                           );
   		
   	IF lv_result = 'Y' THEN		
      
       -- change the password
       nm3ddl.change_user_password(pi_user       => pi_username
                                  ,pi_new_passwd => lv_new_password);
    END IF;
    
    RETURN lv_result;
   
   END;
--
--------------------------------------------------------------------------------------------------
--
END hig_user_login_util;
/