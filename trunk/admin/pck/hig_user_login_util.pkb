CREATE OR REPLACE PACKAGE BODY hig_user_login_util AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/hig_user_login_util.pkb-arc   1.0   Apr 19 2016 07:53:50   Vikas.Mhetre  $
--       Module Name      : $Workfile:   hig_user_login_util.pkb  $
--       Date into PVCS   : $Date:   Apr 19 2016 07:53:50  $
--       Date fetched Out : $Modtime:   Apr 19 2016 07:31:26  $
--       PVCS Version     : $Revision:   1.0  $
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
   g_body_sccsid     constant varchar2(30) :='"$Revision:   1.0  $"';
--
   g_package_name    CONSTANT  VARCHAR2(30)   := 'hig_user_login_util';
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
    RETURN l_answer;
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
    RETURN 'success';
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
END hig_user_login_util;
/