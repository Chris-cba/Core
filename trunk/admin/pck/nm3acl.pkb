CREATE OR REPLACE PACKAGE BODY nm3acl
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3acl.pkb-arc   3.7   Jul 04 2013 15:15:36   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3acl.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:15:36  $
--       Date fetched Out : $Modtime:   Jul 04 2013 15:11:48  $
--       Version          : $Revision:   3.7  $
--       Based on SCCS version : 
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--

-- Access Control List wrapper for Oracle's DBMS_NETWORK_ACL_ADMIN package
-- These grants are needed at 11gr2 for use with the following packages -
--UTL_TCP 
--UTL_SMTP 
--UTL_MAIL 
--UTL_HTTP 
--UTL_INADDR

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid        CONSTANT VARCHAR2(2000) := '$Revision:   3.7  $';
  g_package_name       CONSTANT varchar2(30) := 'nm3acl';
--
  c_ftp_role           CONSTANT VARCHAR2(30) := 'FTP_USER';
  c_email_role         CONSTANT VARCHAR2(30) := 'EMAIL_USER';
--
  c_ftp_acl                     VARCHAR2(30) := Sys_Context('NM3CORE','APPLICATION_OWNER')||'_FTP_ACL.xml';
  c_email_acl                   VARCHAR2(30) := Sys_Context('NM3CORE','APPLICATION_OWNER')||'_EMAIL_ACL.xml';
--
--ORA-31003
  ex_acl_already_exists         EXCEPTION;
  PRAGMA                        EXCEPTION_INIT (ex_acl_already_exists,-31003);
--
--ORA-19279: XPTY0004 - XQuery dynamic type mismatch: expected singleton sequence - got multi-item sequence
  ex_priv_already_exists        EXCEPTION;
  PRAGMA                        EXCEPTION_INIT (ex_priv_already_exists,-19279);
--
--ORA-31001: ACL does not exist
  ex_acl_does_not_exist         EXCEPTION;
  PRAGMA                        EXCEPTION_INIT (ex_acl_does_not_exist,-31001);
--
--ORA-31003: Parent /sys/acls/ already contains child entry 
  ex_acl_child_exists           EXCEPTION;
  PRAGMA                        EXCEPTION_INIT (ex_acl_child_exists,-31003);
--
  ex_invalid_privilege          EXCEPTION;
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
  nm_debug.proc_start(g_package_name,'get_version');
  nm_debug.proc_end(g_package_name,'get_version');
  RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
  nm_debug.proc_start(g_package_name,'get_body_version');
  nm_debug.proc_end(g_package_name,'get_body_version');
  RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
FUNCTION user_has_access ( pi_host        IN VARCHAR2
                         , pi_lower_port  IN VARCHAR2
                         , pi_upper_port  IN VARCHAR2
 )
RETURN BOOLEAN
IS
  l_sql      nm3type.max_varchar2;
  l_dummy    NUMBER;
BEGIN
--
  l_sql :=         'SELECT COUNT(*) FROM user_network_acl_privileges';
  l_sql := l_sql ||' WHERE host = :pi_host';
  l_sql := l_sql ||'   AND status = ''GRANTED''';
  l_sql := l_sql ||'   AND privilege = ''connect''';
  l_sql := l_sql ||'   AND NVL(lower_port,-999) = NVL(:pi_lower_port,-999)';
  l_sql := l_sql ||'   AND NVL(upper_port,-999) = NVL(:pi_upper_port,-999)';
--
  EXECUTE IMMEDIATE l_sql INTO l_dummy USING pi_host, to_number(pi_lower_port), to_number(pi_upper_port);
--
--  nm_debug.debug(l_sql);
--  nm_debug.debug('Host = '||(pi_host));
--  nm_debug.debug('Lower port = '||to_number(pi_lower_port));
--  nm_debug.debug('Upper port = '||to_number(pi_upper_port));
--
  RETURN (l_dummy>0);
--
END user_has_access;
--
-----------------------------------------------------------------------------
--
FUNCTION check_privilege ( pi_acl_name  IN VARCHAR2
                         , pi_user      IN VARCHAR2
                         , pi_privilege IN VARCHAR )
RETURN BOOLEAN
IS
BEGIN
  IF dbms_network_acl_admin.check_privilege(pi_acl_name,pi_user,pi_privilege) != 1
  OR  dbms_network_acl_admin.check_privilege(pi_acl_name,pi_user,pi_privilege) IS NULL
    THEN RETURN FALSE;
    ELSE RETURN TRUE;
  END IF;
--  RETURN ( dbms_network_acl_admin.check_privilege(pi_acl_name,pi_user,pi_privilege) = 1 
--        OR NOT (dbms_network_acl_admin.check_privilege(pi_acl_name,pi_user,pi_privilege) IS NULL ));
END check_privilege;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_privilege ( pi_privilege IN VARCHAR2 )
IS
BEGIN
--
  nm_debug.proc_start(g_package_name,'validate_privilege');
--
  IF LOWER(pi_privilege) NOT IN ('connect','resolve')
  THEN
    RAISE ex_invalid_privilege;
  END IF;
--
  nm_debug.proc_end(g_package_name,'validate_privilege');
--
EXCEPTION
  WHEN ex_invalid_privilege
    THEN RAISE_APPLICATION_ERROR(-20102,'Invalid ACL privilege ['||LOWER(pi_privilege)||']');
END validate_privilege;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_acl 
             ( pi_acl_name     IN VARCHAR2
             , pi_user_or_role IN VARCHAR2
             , pi_acl_descr    IN VARCHAR2  DEFAULT NULL
             , pi_is_grant     IN BOOLEAN   DEFAULT TRUE
             , pi_privilege    IN VARCHAR2  DEFAULT NULL
             , pi_start_date   IN TIMESTAMP DEFAULT SYSTIMESTAMP
             , pi_end_date     IN TIMESTAMP DEFAULT NULL
             )
IS
--   * PARAMETERS
--   *   acl          the name of the ACL. Relative path will be relative to
--   *                "/sys/acls".
--   *   description  the description attribute in the ACL
--   *   principal    the principal (database user or role) whom the privilege
--   *                is granted to or denied from
--   *   is_grant     is the privilege is granted or denied
--   *   privilege    the network privilege to be granted or denied
--   *   start_date   the start date of the access control entry (ACE). When
--   *                specified, the ACE will be valid only on and after the
--   *                specified date.
--   *   end_date     the end date of the access control entry (ACE). When
--   *                specified, the ACE will expire after the specified date.
--   *                The end_date must be greater than or equal to the
--   *                start_date.
--
  l_acl_name    nm3type.max_varchar2;
  PRAGMA AUTONOMOUS_TRANSACTION;
--
BEGIN
--
  nm_debug.proc_start(g_package_name,'create_acl');
--
  l_acl_name := CASE WHEN SUBSTR (UPPER(pi_acl_name), -3) != 'XML'
                THEN pi_acl_name||'.xml'
                ELSE pi_acl_name
                END; 
--
  IF pi_privilege IS NULL
  THEN
  --
  -- Grant both connect and resolve by default
  --
    BEGIN
      nm_debug.debug('Assign priv connect to '||l_acl_name);
      IF NOT check_privilege(l_acl_name,user,'connect')
      THEN
        dbms_network_acl_admin.create_acl 
          ( acl          => l_acl_name
          , description  => NVL(pi_acl_descr,l_acl_name)
          , principal    => pi_user_or_role
          , is_grant     => pi_is_grant
          , PRIVILEGE    => 'connect'
          , start_date   => pi_start_date
          , end_date     => pi_end_date);
      END IF;
    EXCEPTION
      WHEN ex_acl_does_not_exist
      THEN
        dbms_network_acl_admin.create_acl 
          ( acl          => l_acl_name
          , description  => NVL(pi_acl_descr,l_acl_name)
          , principal    => pi_user_or_role
          , is_grant     => pi_is_grant
          , PRIVILEGE    => 'connect'
          , start_date   => pi_start_date
          , end_date     => pi_end_date);
    END;
  --
    BEGIN
      nm_debug.debug('Assign priv resolve to '||l_acl_name);
      IF NOT check_privilege(l_acl_name,user,'resolve')
      THEN
        dbms_network_acl_admin.add_privilege
          ( acl        => l_acl_name 
          , principal  => pi_user_or_role
          , is_grant   => pi_is_grant
          , privilege  => 'resolve'
    --      , position   => 1
          , start_date => pi_start_date 
          , end_date   => pi_end_date);
      END IF;
    EXCEPTION
      WHEN ex_acl_does_not_exist
      THEN
        dbms_network_acl_admin.add_privilege
          ( acl        => l_acl_name 
          , principal  => pi_user_or_role
          , is_grant   => pi_is_grant
          , privilege  => 'resolve'
    --      , position   => 1
          , start_date => pi_start_date 
          , end_date   => pi_end_date);
    END;
  --
  ELSE
  --
  -- Or grant whatever the user has passed in
  --
    validate_privilege (pi_privilege) ;
  --
    BEGIN
      IF NOT check_privilege(l_acl_name,user,'resolve')
      THEN
        dbms_network_acl_admin.create_acl 
          ( acl          => l_acl_name
          , description  => NVL(pi_acl_descr,l_acl_name)
          , principal    => pi_user_or_role
          , is_grant     => pi_is_grant
          , PRIVILEGE    => LOWER(pi_privilege)
          , start_date   => pi_start_date
          , end_date     => pi_end_date);
      END IF;
    EXCEPTION
      WHEN ex_acl_does_not_exist
      THEN
        dbms_network_acl_admin.create_acl 
          ( acl          => l_acl_name
          , description  => NVL(pi_acl_descr,l_acl_name)
          , principal    => pi_user_or_role
          , is_grant     => pi_is_grant
          , PRIVILEGE    => LOWER(pi_privilege)
          , start_date   => pi_start_date
          , end_date     => pi_end_date);
    END;
  --
  END IF;
--
  COMMIT;
--
  nm_debug.proc_end(g_package_name,'create_acl');
--
--EXCEPTION
--  WHEN ex_acl_already_exists --ORA-31003
--    THEN RAISE_APPLICATION_ERROR(-20101,'ACL ['||l_acl_name||'] already exists');
END create_acl;
--
-----------------------------------------------------------------------------
--
PROCEDURE drop_acl
             ( pi_acl_name       IN VARCHAR2 )
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
--
  nm_debug.proc_start(g_package_name,'drop_acl');
--
  dbms_network_acl_admin.drop_acl(acl => pi_acl_name);
  COMMIT;
--
  nm_debug.proc_end(g_package_name,'drop_acl');
--
END drop_acl;
--
-----------------------------------------------------------------------------
--
PROCEDURE assign_acl
            ( pi_acl_name   IN VARCHAR2
            , pi_host       IN VARCHAR2
            , pi_lower_port IN NUMBER DEFAULT NULL
            , pi_upper_port IN NUMBER DEFAULT NULL )
IS
--
  PRAGMA AUTONOMOUS_TRANSACTION;
--
BEGIN
--
  nm_debug.proc_start(g_package_name,'assign_acl');
--
  nm_debug.debug('Assign : '||pi_acl_name||' - '||pi_host);
--
  dbms_network_acl_admin.assign_acl 
    ( acl         => pi_acl_name
    , host        => pi_host
    , lower_port  => pi_lower_port
    , upper_port  => pi_upper_port ); 
--
  COMMIT;
--
  nm_debug.proc_end(g_package_name,'assign_acl');
--
END assign_acl;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_privilege 
             ( pi_acl_name       IN VARCHAR2
             , pi_user_or_role   IN VARCHAR2
             , pi_privilege      IN VARCHAR2
             , pi_is_grant       IN BOOLEAN   DEFAULT TRUE
             , pi_start_date     IN TIMESTAMP DEFAULT SYSTIMESTAMP
             , pi_end_date       IN TIMESTAMP DEFAULT NULL
             )
IS
--
  PRAGMA AUTONOMOUS_TRANSACTION;
--
BEGIN
--
  nm_debug.proc_start(g_package_name,'add_privilege');
--
  validate_privilege (pi_privilege);
--
  IF NOT check_privilege(pi_acl_name,user,pi_privilege)
  THEN
    nm_debug.debug('adding privilege - '||pi_acl_name||' - '||user||' - '||pi_privilege);
    dbms_network_acl_admin.add_privilege
      ( acl        => pi_acl_name 
      , principal  => pi_user_or_role
      , is_grant   => pi_is_grant
      , privilege  => pi_privilege
      , start_date => pi_start_date 
      , end_date   => pi_end_date );
  ELSE
    nm_debug.debug('already has privilege - '||pi_acl_name||' - '||user||' - '||pi_privilege);
  END IF;
--
  COMMIT;
--
  nm_debug.proc_end(g_package_name,'add_privilege');
--
--EXCEPTION
--  WHEN ex_priv_already_exists --ORA-19279
--    THEN RAISE_APPLICATION_ERROR(-20102,'Privilege ['||pi_privilege||'] has already been granted to ACL ['||pi_acl_name||']');
--
END add_privilege;

--
-----------------------------------------------------------------------------
--

PROCEDURE delete_privilege ( pi_acl_name     IN VARCHAR2
                           , pi_user_or_role IN VARCHAR2
                           , pi_privilege    IN VARCHAR2
                           , pi_is_grant     IN BOOLEAN DEFAULT TRUE )
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
--
  nm_debug.proc_start(g_package_name,'delete_privilege');
--
  validate_privilege (pi_privilege);
--
  dbms_network_acl_admin.delete_privilege
    ( acl       => pi_acl_name
    , principal => pi_user_or_role
    , is_grant  => pi_is_grant
    , privilege => pi_privilege );
--
  COMMIT;
--
  nm_debug.proc_end(g_package_name,'delete_privilege');
--
END delete_privilege;
--
-----------------------------------------------------------------------------
--
PROCEDURE unassign_acl ( pi_acl_name     IN VARCHAR2
                       , pi_host         IN VARCHAR2
                       , pi_lower_port   IN INTEGER DEFAULT NULL
                       , pi_upper_port   IN INTEGER DEFAULT NULL )
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
--
  nm_debug.proc_start(g_package_name,'unassign_acl');
--
  dbms_network_acl_admin.unassign_acl
    ( acl        => pi_acl_name
    , host       => pi_host
    , lower_port => pi_lower_port
    , upper_port => pi_upper_port );
--
  COMMIT;
--
  nm_debug.proc_end(g_package_name,'unassign_acl');
--
END unassign_acl;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_ftp_connection ( pi_host IN hig_ftp_connections.hfc_ftp_host%TYPE
                                 , pi_port IN hig_ftp_connections.hfc_ftp_port%TYPE DEFAULT NULL )
IS
BEGIN
--
  nm_debug.proc_start(g_package_name,'process_ftp_connection');
--
  IF NOT nm3user.user_has_role(user,c_ftp_role)
  THEN
  -- User does not have FTP_USER role
    hig.raise_ner(pi_appl => nm3type.c_hig , pi_id => 550);
  END IF;
--
  --nm_debug.debug_on;
  nm_debug.debug('Checking '||pi_host||' for user '||user);
--
  BEGIN
  --
    nm_debug.debug('Create the FTP ACL for the user ');
  --
    add_privilege
      ( pi_acl_name       => c_ftp_acl
      , pi_user_or_role   => USER
      , pi_privilege      => 'connect'
      );
    add_privilege
      ( pi_acl_name       => c_ftp_acl
      , pi_user_or_role   => USER
      , pi_privilege      => 'resolve'
      );
  --
    nm_debug.debug('Assign the FTP host to the '||c_ftp_acl);
  --
    assign_acl
      ( pi_acl_name   => c_ftp_acl
      , pi_host       => pi_host );
  EXCEPTION
    WHEN ex_acl_does_not_exist
    THEN
    --
    -- Standard EXOR_EMAIL ACL does not exist - create it.
    --
       create_acl 
         ( pi_acl_name     => c_ftp_acl
         , pi_user_or_role => USER );
    --
       assign_acl
         ( pi_acl_name   => c_ftp_acl
         , pi_host       => pi_host);
  END;
--
  COMMIT;
--
  nm_debug.proc_end(g_package_name,'process_ftp_connection');
--
END process_ftp_connection;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_ftp_connection ( pi_rec_hfc IN hig_ftp_connections%ROWTYPE )
IS
BEGIN
--
  nm_debug.proc_start(g_package_name,'process_ftp_connections');
--
  IF NOT nm3user.user_has_role(user,c_ftp_role)
  THEN
  -- User does not have FTP_USER role
    hig.raise_ner(pi_appl => nm3type.c_hig , pi_id => 550);
  END IF;
--
  BEGIN
  --
  -- Assign the FTP host to the standard EXOR FTP ACL
  --
    add_privilege
      ( pi_acl_name       => c_ftp_acl
      , pi_user_or_role   => USER
      , pi_privilege      => 'connect'
      );
    add_privilege
      ( pi_acl_name       => c_ftp_acl
      , pi_user_or_role   => USER
      , pi_privilege      => 'resolve'
      );

    assign_acl
      ( pi_acl_name   => c_ftp_acl
      , pi_host       => pi_rec_hfc.hfc_ftp_host );
  --
  --
  EXCEPTION
    WHEN ex_acl_does_not_exist
    THEN
    --
    -- Standard EXOR_EMAIL ACL does not exist - create it.
    --
       create_acl 
         ( pi_acl_name     => c_ftp_acl
         --, pi_user_or_role => c_email_role );
         , pi_user_or_role => USER );
    --
       assign_acl
         ( pi_acl_name   => c_ftp_acl
         , pi_host       => pi_rec_hfc.hfc_ftp_host);
  END;
  --
  BEGIN
  --
  -- Assign the FTP Archive host to the standard EXOR FTP ACL
  --
    IF pi_rec_hfc.hfc_ftp_arc_host IS NOT NULL
    THEN
      add_privilege
        ( pi_acl_name       => c_ftp_acl
        , pi_user_or_role   => USER
        , pi_privilege      => 'connect'
        );
      add_privilege
        ( pi_acl_name       => c_ftp_acl
        , pi_user_or_role   => USER
        , pi_privilege      => 'resolve'
        );
      assign_acl
        ( pi_acl_name   => c_ftp_acl
        , pi_host       => pi_rec_hfc.hfc_ftp_host );
    END IF;
  END;
  --
  --COMMIT;
--
  nm_debug.proc_end(g_package_name,'process_ftp_connections');
--
END process_ftp_connection;
--
-----------------------------------------------------------------------------
--
PROCEDURE remove_ftp_connection ( pi_rec_hfc IN hig_ftp_connections%ROWTYPE )
IS
BEGIN
--
  nm_debug.proc_start(g_package_name,'remove_ftp_connections');
--
  NULL;
--  BEGIN
--    unassign_acl
--      ( pi_acl_name   => c_ftp_acl
--      , pi_host       => pi_rec_hfc.hfc_ftp_host
----      , pi_lower_port =>
----      , pi_upper_port =>
--       );
--  END;
----
--  BEGIN
--    IF pi_rec_hfc.hfc_ftp_arc_host IS NOT NULL
--    THEN
--      unassign_acl
--        ( pi_acl_name   => c_ftp_acl
--        , pi_host       => pi_rec_hfc.hfc_ftp_arc_host
--  --      , pi_lower_port =>
--  --      , pi_upper_port =>
--         );
--    END IF;
--  END;
--
  nm_debug.proc_end(g_package_name,'remove_ftp_connections');
--
END remove_ftp_connection;
--
--------------------------------------------------------------------------------
--
PROCEDURE process_email_connection ( pi_smtp_server IN VARCHAR2
                                   , pi_smtp_port   IN NUMBER
                                   , pi_smtp_domain IN VARCHAR2 )
IS
--
-- Process SMTP email connections
--
  pragma autonomous_transaction;
BEGIN
--
  nm_debug.proc_start(g_package_name,'process_email_connection');
--
  IF NOT nm3user.user_has_role(user,c_email_role)
  THEN
  -- User does not have EMAIL_USER role
    hig.raise_ner(pi_appl => nm3type.c_hig , pi_id => 551);
  END IF;
--
  BEGIN
--    create_acl 
--      ( pi_acl_name     => c_email_acl
----         , pi_user_or_role => c_ftp_role );
--      , pi_user_or_role => USER );
  --
  -- Assign the EMAIL host to the standard EXOR MAIL ACL
  --
    add_privilege
      ( pi_acl_name       => c_email_acl
      , pi_user_or_role   => USER
      , pi_privilege      => 'connect'
      );
    add_privilege
      ( pi_acl_name       => c_email_acl
      , pi_user_or_role   => USER
      , pi_privilege      => 'resolve'
      );
  --
    assign_acl
      ( pi_acl_name   => c_email_acl
      , pi_host       => pi_smtp_server 
      , pi_lower_port => pi_smtp_port);
      
  --
  EXCEPTION
    WHEN ex_acl_does_not_exist
    THEN
    --
    -- Standard EXOR_EMAIL ACL does not exist - create it.
    --
       create_acl 
         ( pi_acl_name     => c_email_acl
         --, pi_user_or_role => c_email_role );
         , pi_user_or_role => USER );
    --
       assign_acl
         ( pi_acl_name   => c_email_acl
         , pi_host       => pi_smtp_server 
         , pi_lower_port => pi_smtp_port);
    --
  END;
  --
  COMMIT;
--
  nm_debug.proc_end(g_package_name,'process_email_connection');
--
END process_email_connection;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_email_connection ( pi_pop3_server IN VARCHAR2
                                   , pi_pop3_port   IN NUMBER )
IS
--
-- Process POP3 email connections
--
BEGIN
--
  nm_debug.proc_start(g_package_name,'process_email_connection');
--
  IF NOT nm3user.user_has_role(user,c_email_role)
  THEN
  -- User does not have EMAIL_USER role
    hig.raise_ner(pi_appl => nm3type.c_hig , pi_id => 551);
  END IF;
--
  BEGIN
--
    add_privilege
      ( pi_acl_name       => c_email_acl
      , pi_user_or_role   => USER
      , pi_privilege      => 'connect'
      );
    add_privilege
      ( pi_acl_name       => c_email_acl
      , pi_user_or_role   => USER
      , pi_privilege      => 'resolve'
      );
  --
  -- Assign the EMAIL host to the standard EXOR MAIL ACL
  --
    assign_acl
      ( pi_acl_name   => c_email_acl
      , pi_host       => pi_pop3_server 
      , pi_lower_port => pi_pop3_port);
  --
  EXCEPTION
    WHEN ex_acl_does_not_exist
    THEN
    --
    -- Standard EXOR_EMAIL ACL does not exist - create it.
    --
       create_acl 
         ( pi_acl_name     => c_email_acl
         --, pi_user_or_role => c_email_role );
         , pi_user_or_role => USER );
    --
       assign_acl
         ( pi_acl_name   => c_email_acl
         , pi_host       => pi_pop3_server 
         , pi_lower_port => pi_pop3_port);
    --
  END;
--
  --COMMIT;
--
  nm_debug.proc_end(g_package_name,'process_email_connection');
--
END process_email_connection;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_standard_acls
IS
BEGIN
--
  nm_debug.proc_start(g_package_name,'create_standard_acls');
--
  BEGIN
  --
  ----------------------
  -- Create FTP ACL
  ----------------------
  --
    BEGIN
      create_acl 
       ( pi_acl_name     => c_ftp_acl
       , pi_user_or_role => USER );
    EXCEPTION
      WHEN ex_acl_already_exists
        THEN NULL;
    END;
  --
  ----------------------
  -- Assign FTP Hosts to ACL
  ----------------------
  --
    FOR i IN (SELECT * FROM hig_ftp_connections)
    LOOP
    --
      BEGIN
        assign_acl
          ( pi_acl_name   => c_ftp_acl
          , pi_host       => i.hfc_ftp_host );
      EXCEPTION
        WHEN ex_acl_does_not_exist
        THEN NULL;
      END;
    --
      BEGIN
        IF i.hfc_ftp_arc_host IS NOT NULL
        THEN
           assign_acl
             ( pi_acl_name   => c_ftp_acl
             , pi_host       => i.hfc_ftp_arc_host );
        END IF;
      EXCEPTION
        WHEN ex_acl_does_not_exist
        THEN NULL;
      END;
    --
    END LOOP;
  END;
--
  BEGIN
  --
  ----------------------
  -- Create MAIL ACL
  ----------------------
  --
    BEGIN
      create_acl 
       ( pi_acl_name     => c_email_acl
       , pi_user_or_role => USER );
    EXCEPTION
      WHEN ex_acl_already_exists
        THEN NULL;
    END;
  --
  ----------------------
  -- Assign SMTP Mail 
  ----------------------
  --
    DECLARE
      l_smtp_host   nm3type.max_varchar2 := hig.get_sysopt('SMTPSERVER');
      l_smtp_port   nm3type.max_varchar2 := hig.get_sysopt('SMTPPORT');
      l_smtp_domain nm3type.max_varchar2 := hig.get_sysopt('SMTPDOMAIN');
    BEGIN
    --
      IF l_smtp_port IS NOT NULL
      AND l_smtp_host IS NOT NULL
      THEN
        assign_acl
          ( pi_acl_name   => c_email_acl
          , pi_host       => l_smtp_host 
          , pi_lower_port => l_smtp_port);
      END IF;
    --
    END;
  --
  ----------------------
  -- Assign POP3 Mail 
  ----------------------
  --
    BEGIN
      FOR i IN (SELECT * FROM nm_mail_pop_servers)
      LOOP
      --
        assign_acl
          ( pi_acl_name   => c_email_acl
          , pi_host       => i.nmps_server_name 
          , pi_lower_port => i.nmps_server_port);
      --
      END LOOP;
    END;
  --
  END;
--
  COMMIT;
--
  nm_debug.proc_end(g_package_name,'create_standard_acls');
--
END create_standard_acls;
--
-----------------------------------------------------------------------------
--
PROCEDURE remove_standard_acls
IS
BEGIN
--
  nm_debug.proc_start(g_package_name,'remove_standard_acls');
--
  BEGIN
    nm3acl.drop_acl(c_ftp_acl);
  EXCEPTION
    WHEN ex_acl_does_not_exist THEN NULL;
  END;
--
  BEGIN
    nm3acl.drop_acl(c_email_acl);
  EXCEPTION
    WHEN ex_acl_does_not_exist THEN NULL;
  END;
--
  COMMIT;
--
  nm_debug.proc_end(g_package_name,'remove_standard_acls');
--
END remove_standard_acls;
--
-----------------------------------------------------------------------------
--
END nm3acl;
/
