CREATE OR REPLACE PACKAGE BODY nm3mail_pop AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3mail_pop.pkb-arc   2.3   Feb 03 2011 08:46:26   Ade.Edwards  $
--       Module Name      : $Workfile:   nm3mail_pop.pkb  $
--       Date into PVCS   : $Date:   Feb 03 2011 08:46:26  $
--       Date fetched Out : $Modtime:   Feb 02 2011 11:23:52  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version : 1.1
-------------------------------------------------------------------------
--   Author : Jonathan Mills
--
--   NM3 POP Mail Processing package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
--all global package variables here
--
  g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.3  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3mail_pop';
--
   g_encryption_key            VARCHAR2(32);
   c_pad_char        CONSTANT  VARCHAR2(1)    := CHR(134);
   c_noop_count      CONSTANT  PLS_INTEGER    := 13;
--
   g_tab_header_fields         nm3type.tab_varchar80;
--
   c_colon           CONSTANT  VARCHAR2(1)    := ':';
   c_app_owner       CONSTANT  VARCHAR2(30)   := hig.get_application_owner;
   
   c_failing_command CONSTANT  VARCHAR2(30)   := 'BADGER';
   
   c_failing_str_opt constant  hig_option_list.hol_id%type := 'POPFAILSTR';
   c_failing_string  CONSTANT  VARCHAR2(100) := NVL(hig.get_sysopt(p_option_id => c_failing_str_opt), '-ERR%'||UPPER(c_failing_command)||'%');
--
   g_retry_count               PLS_INTEGER;
   g_retry_limit     CONSTANT  PLS_INTEGER    := 3;
--
--
-- ORA-24247: Network access denied by access control list (ACL)
--
   ex_acl_failure            EXCEPTION;
   PRAGMA                    EXCEPTION_INIT(ex_acl_failure,-24247);
-----------------------------------------------------------------------------
--
FUNCTION open_connection (p_remote_host VARCHAR2
                         ,p_remote_port PLS_INTEGER
                         ,p_timeout     PLS_INTEGER
                         ) RETURN utl_tcp.connection;
--
-----------------------------------------------------------------------------
--
FUNCTION open_connection_and_logon (p_remote_host VARCHAR2
                                   ,p_remote_port PLS_INTEGER
                                   ,p_username    VARCHAR2
                                   ,p_password    VARCHAR2
                                   ,p_timeout     PLS_INTEGER
                                   ) RETURN utl_tcp.connection;
--
-----------------------------------------------------------------------------
--
PROCEDURE close_connection (p_connection IN OUT NOCOPY utl_tcp.connection);
--
-----------------------------------------------------------------------------
--
PROCEDURE close_all_connections;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_connection (p_connection IN OUT NOCOPY utl_tcp.connection);
--
-----------------------------------------------------------------------------
--
FUNCTION get_all_output (p_connection IN OUT NOCOPY utl_tcp.connection) RETURN nm3type.tab_varchar32767;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_buffer (p_connection   IN OUT NOCOPY utl_tcp.connection
                       ,p_write_buffer IN            VARCHAR2
                       );
--
-----------------------------------------------------------------------------
--
PROCEDURE instantiate_data;
--
-----------------------------------------------------------------------------
--
FUNCTION encrypt_data (p_string_in VARCHAR2) RETURN VARCHAR2;
--
-----------------------------------------------------------------------------
--
FUNCTION decrypt_data (p_string_in VARCHAR2) RETURN VARCHAR2;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmps (p_rec_nmps IN OUT nm_mail_pop_servers%ROWTYPE);
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmps_internal (pi_rec_nmps nm_mail_pop_servers%ROWTYPE,p_level PLS_INTEGER DEFAULT 3);
--
-----------------------------------------------------------------------------
--
FUNCTION build_retr_commands (pi_output nm3type.tab_varchar32767) RETURN nm3type.tab_varchar32767;
--
-----------------------------------------------------------------------------
--
FUNCTION del_arr_1_from_arr_2 (pi_arr_1 nm3type.tab_varchar32767
                              ,pi_arr_2 nm3type.tab_varchar32767
                              ) RETURN nm3type.tab_varchar32767;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_pop_output (pi_array  IN     nm3type.tab_varchar32767
                             ,po_header    OUT nm3type.tab_varchar32767
                             ,po_body      OUT nm3type.tab_varchar32767
                             ,po_full      OUT nm3type.tab_varchar32767
                             );
--
-----------------------------------------------------------------------------
--
PROCEDURE create_nmpmd (p_nmpm_id NUMBER
                       ,p_body    nm3type.tab_varchar32767
                       );
--
-----------------------------------------------------------------------------
--
PROCEDURE create_nmpmr (p_nmpm_id NUMBER
                       ,p_text    nm3type.tab_varchar32767
                       );
--
-----------------------------------------------------------------------------
--
PROCEDURE create_nmpmh (p_nmpm_id NUMBER
                       ,p_header  nm3type.tab_varchar32767
                       );
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
PROCEDURE receive_all_accounts IS
   l_tab_nmps_id nm3type.tab_number;
BEGIN
--
   nm_debug.proc_start(g_package_name,'receive_all_accounts');
--
   SELECT nmps_id
    BULK  COLLECT
    INTO  l_tab_nmps_id
    FROM  nm_mail_pop_servers;
--
   FOR i IN 1..l_tab_nmps_id.COUNT
    LOOP
      receive_individual_account (pi_nmps_id => l_tab_nmps_id(i));
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'receive_all_accounts');
--
END receive_all_accounts;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_noops (p_connection IN OUT utl_tcp.connection) IS
BEGIN
   FOR i IN 1..c_noop_count
    LOOP
      write_buffer (p_connection   => p_connection
                   ,p_write_buffer => 'NOOP'
                   );
   END LOOP;
END write_noops;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_failing_command (p_connection IN OUT utl_tcp.connection) IS
BEGIN
   write_buffer (p_connection   => p_connection
                ,p_write_buffer => c_failing_command
                );
END write_failing_command;
--
-----------------------------------------------------------------------------
--
FUNCTION is_failed_command (p_text VARCHAR2) RETURN BOOLEAN IS
BEGIN
   RETURN UPPER(p_text) LIKE c_failing_string;
END is_failed_command;
--
-----------------------------------------------------------------------------
--
PROCEDURE receive_individual_account (pi_nmps_id nm_mail_pop_servers.nmps_id%TYPE) IS
   l_rec_nmps           nm_mail_pop_servers%ROWTYPE;
   l_decrypted_password nm3type.max_varchar2;
   l_conn               utl_tcp.connection;
   l_output             nm3type.tab_varchar32767;
   l_tab_retr_command   nm3type.tab_varchar32767;
   l_header             nm3type.tab_varchar32767;
   l_body               nm3type.tab_varchar32767;
   l_full_msg           nm3type.tab_varchar32767;
   l_tab_delete         nm3type.tab_boolean;
   l_rec_nmpm           nm_mail_pop_messages%ROWTYPE;
   l_some_to_delete     BOOLEAN := FALSE;
   PROCEDURE retr_message_and_create (p_index PLS_INTEGER) IS
   BEGIN
--      nm_debug.debug('-------------------------------------------');
--      nm_debug.debug(l_tab_retr_command(p_index));
--      IF g_retry_count > 0
--       THEN
--         nm_debug.debug('Retry '||g_retry_count);
--      END IF;
--      nm_debug.debug('-------------------------------------------');
   --
      l_conn := open_connection_and_logon (p_remote_host => l_rec_nmps.nmps_server_name
                                          ,p_remote_port => l_rec_nmps.nmps_server_port
                                          ,p_username    => l_rec_nmps.nmps_username
                                          ,p_password    => l_decrypted_password
                                          ,p_timeout     => l_rec_nmps.nmps_timeout
                                          );
--
      write_failing_command (p_connection   => l_conn);
      write_buffer (p_connection   => l_conn
                   ,p_write_buffer => REPLACE(l_tab_retr_command(p_index),'RETR','TOP')||' 0'
                   );
      write_buffer (p_connection   => l_conn
                   ,p_write_buffer => 'RSET'
                   );
      write_failing_command (p_connection   => l_conn);
      write_buffer (p_connection   => l_conn
                   ,p_write_buffer => l_tab_retr_command(p_index)
                   );
      write_buffer (p_connection   => l_conn
                   ,p_write_buffer => 'QUIT'
                   );
      l_output := get_all_output (p_connection => l_conn);
   nm3tab_varchar.debug_tab_varchar (l_output);
--
      close_connection (l_conn);
--
      process_pop_output (pi_array    => l_output
                         ,po_header   => l_header
                         ,po_body     => l_body
                         ,po_full     => l_full_msg
                         );
      IF l_header.COUNT=0
       THEN
         l_tab_delete(p_index)  := FALSE;
         IF g_retry_count < g_retry_limit
          THEN
            g_retry_count := g_retry_count + 1;
            retr_message_and_create (p_index);
         END IF;
      ELSE
         l_tab_delete(p_index)  := TRUE;
         l_some_to_delete       := TRUE;
--
         l_rec_nmpm.nmpm_id            := next_nmpm_id_seq;
         l_rec_nmpm.nmpm_nmps_id       := l_rec_nmps.nmps_id;
         l_rec_nmpm.nmpm_status        := c_unprocessed;
         ins_nmpm (l_rec_nmpm);
   --
         create_nmpmh (l_rec_nmpm.nmpm_id, l_header);
   --
         create_nmpmd (l_rec_nmpm.nmpm_id, l_body);
   --
         create_nmpmr (l_rec_nmpm.nmpm_id, l_full_msg);
      END IF;
   END retr_message_and_create;
BEGIN
--
   nm_debug.proc_start(g_package_name,'receive_individual_account');
--
   l_rec_nmps           := get_nmps (pi_nmps_id => pi_nmps_id);
   l_decrypted_password := decrypt_data (l_rec_nmps.nmps_password);
--
--   nm_debug.delete_debug(TRUE);
   nm_debug.debug_on;
--   nm_debug.set_level(4);
   debug_nmps_internal (l_rec_nmps);
--
   l_conn := open_connection_and_logon (p_remote_host => l_rec_nmps.nmps_server_name
                                       ,p_remote_port => l_rec_nmps.nmps_server_port
                                       ,p_username    => l_rec_nmps.nmps_username
                                       ,p_password    => l_decrypted_password
                                       ,p_timeout     => l_rec_nmps.nmps_timeout
                                       );
--
   write_buffer (p_connection   => l_conn
                ,p_write_buffer => 'STAT'
                );
--
   write_failing_command (p_connection   => l_conn);
   write_buffer (p_connection   => l_conn
                ,p_write_buffer => 'LIST'
                );
   write_buffer (p_connection   => l_conn
                ,p_write_buffer => 'QUIT'
                );
   l_output := get_all_output (p_connection => l_conn);
   nm3tab_varchar.debug_tab_varchar (l_output);
--   write_buffer (p_connection   => l_conn
--                ,p_write_buffer => 'QUIT'
--                );
--
   l_tab_retr_command := build_retr_commands (l_output);
--
   nm3tab_varchar.debug_tab_varchar (l_tab_retr_command);
--
   close_connection (l_conn);
--
   FOR i IN 1..l_tab_retr_command.COUNT
    LOOP
      g_retry_count := 0;
      retr_message_and_create (i);
   END LOOP;
--
   IF l_some_to_delete
    THEN
      l_conn := open_connection_and_logon (p_remote_host => l_rec_nmps.nmps_server_name
                                          ,p_remote_port => l_rec_nmps.nmps_server_port
                                          ,p_username    => l_rec_nmps.nmps_username
                                          ,p_password    => l_decrypted_password
                                          ,p_timeout     => l_rec_nmps.nmps_timeout
                                          );
   --
      FOR i IN 1..l_tab_retr_command.COUNT
       LOOP
         IF l_tab_delete(i)
          THEN
            write_buffer (p_connection   => l_conn
                         ,p_write_buffer => REPLACE(l_tab_retr_command(i),'RETR','DELE')
                         );
         END IF;
      END LOOP;
      write_buffer (p_connection   => l_conn
                   ,p_write_buffer => 'QUIT'
                   );
      l_output := get_all_output (p_connection => l_conn);
   nm3tab_varchar.debug_tab_varchar (l_output);
      close_connection (l_conn);
   END IF;
----
--   nm_debug.set_level(3);
--   nm_debug.debug_off;
--
   nm_debug.proc_end(g_package_name,'receive_individual_account');
--
EXCEPTION
   WHEN others
    THEN
      close_all_connections;
      RAISE;
END receive_individual_account;
--
-----------------------------------------------------------------------------
--
FUNCTION open_connection_and_logon (p_remote_host VARCHAR2
                                   ,p_remote_port PLS_INTEGER
                                   ,p_username    VARCHAR2
                                   ,p_password    VARCHAR2
                                   ,p_timeout     PLS_INTEGER
                                   ) RETURN utl_tcp.connection IS
--
   l_conn utl_tcp.connection;
--
BEGIN
--
   l_conn := open_connection (p_remote_host => p_remote_host
                             ,p_remote_port => p_remote_port
                             ,p_timeout     => p_timeout
                             );
--
   write_buffer (p_connection   => l_conn
                ,p_write_buffer => 'USER '||p_username
                );
--
   write_buffer (p_connection   => l_conn
                ,p_write_buffer => 'PASS '||p_password
                );
--
   RETURN l_conn;
--
END open_connection_and_logon;
--
-----------------------------------------------------------------------------
--
FUNCTION get_header_field_hdo_domain RETURN hig_domains.hdo_domain%TYPE IS
BEGIN
   RETURN c_header_field_domain;
END get_header_field_hdo_domain;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_nmpp_procedure (pi_nmpp_procedure nm_mail_pop_processes.nmpp_procedure%TYPE) IS
--
   l_nmpp_procedure nm_mail_pop_processes.nmpp_procedure%TYPE := UPPER(pi_nmpp_procedure);
   l_first_dot      PLS_INTEGER;
   l_package        nm3type.max_varchar2;
   l_procedure      nm3type.max_varchar2;
--
   CURSOR cs_check (c_package VARCHAR2, c_procedure VARCHAR2) IS
   SELECT 1
    FROM  dual
   WHERE  EXISTS (SELECT 1
                   FROM  all_arguments
                  WHERE  c_package IS NOT NULL
                   AND   owner        = c_app_owner
                   AND   object_name  = c_procedure
                   AND   package_name = c_package
                   AND   position     = 1
                 )
   OR     EXISTS (SELECT 1
                   FROM  all_arguments
                  WHERE  c_package IS NULL
                   AND   owner        = c_app_owner
                   AND   object_name  = c_procedure
                   AND   package_name IS NULL
                   AND   position     = 1
                 );
   l_dummy PLS_INTEGER;
   l_found BOOLEAN;
--
   PROCEDURE raise_net_28 (pi_info VARCHAR2 DEFAULT NULL) IS
   BEGIN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 28
                    ,pi_supplementary_info => pi_info
                    );
   END raise_net_28;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'validate_nmpp_procedure');
--
   IF INSTR(l_nmpp_procedure,'.',1,2) != 0
    THEN
      raise_net_28 ('"'||pi_nmpp_procedure||'" not in form "PACKAGE.PROCEDURE" or "PROCEDURE"');
   END IF;
--
   l_first_dot := INSTR(l_nmpp_procedure,'.',1,1);
--
   IF l_first_dot != 0
    THEN
      l_package := nm3flx.left(l_nmpp_procedure,(l_first_dot-1));
   END IF;
--
   l_procedure := SUBSTR(l_nmpp_procedure,(l_first_dot+1));
--
   IF   l_package IS NOT NULL
    AND NOT nm3ddl.does_object_exist (p_object_name => l_package
                                     ,p_object_type => 'PACKAGE'
                                     )
    THEN
      raise_net_28 ('Package "'||l_package||'" does not exist');
   END IF;
--
   IF   l_package IS NULL
    AND NOT nm3ddl.does_object_exist (p_object_name => l_procedure
                                     ,p_object_type => 'PROCEDURE'
                                     )
    THEN
      raise_net_28 ('Procedure "'||l_procedure||'" does not exist');
   END IF;
--
   OPEN  cs_check (l_package, l_procedure);
   FETCH cs_check INTO l_dummy;
   l_found := cs_check%FOUND;
   CLOSE cs_check;
--
   IF NOT l_found
    THEN
      raise_net_28 ('Procedure "'||pi_nmpp_procedure||'" does not exist');
   END IF;
--
   DECLARE
      l_sql   nm3type.max_varchar2;
   BEGIN
      l_sql :=            'BEGIN'
               ||CHR(10)||'   IF 1 = 2'
               ||CHR(10)||'    THEN'
               ||CHR(10)||'      '||pi_nmpp_procedure||'(0);'
               ||CHR(10)||'   END IF;'
               ||CHR(10)||'END;';
      EXECUTE IMMEDIATE l_sql;
   EXCEPTION
      WHEN others
       THEN
         raise_net_28 ('Procedure "'||pi_nmpp_procedure||'" can not be called with a single numeric parameter');
   END;
--
   nm_debug.proc_end(g_package_name,'validate_nmpp_procedure');
--
END validate_nmpp_procedure;
--
-----------------------------------------------------------------------------
--
PROCEDURE instantiate_data IS
   l_temp VARCHAR2(32);
   l_val1 NUMBER;
   l_val2 NUMBER;
   l_val3 NUMBER;
   l_val4 NUMBER;
   FUNCTION append (p_num NUMBER) RETURN VARCHAR2 IS
      l_num NUMBER := p_num + (l_val3);
   BEGIN
      RETURN CHR((l_num));
   END append;
   PROCEDURE header_append (p_field VARCHAR2) IS
   BEGIN
      g_tab_header_fields(g_tab_header_fields.COUNT+1) := UPPER(p_field);
   END header_append;
BEGIN
   --
   SELECT hco_code
    BULK  COLLECT
    INTO  g_tab_header_fields
    FROM  hig_codes
   WHERE  hco_domain = c_header_field_domain;
   --
   -- All tried to be hidden in here so that it is still hidden even when wrapped
   --
   l_val1 := 8;
   l_val2 := 8;
   l_val4 := 2;
   l_val3 := (l_val1*l_val2)/l_val4;
   l_temp := l_temp||append(1);
   l_temp := l_temp||append(32);
   l_temp := l_temp||append(3);
   l_temp := l_temp||append(4);
   l_temp := l_temp||append(5);
   l_temp := l_temp||append(62);
   l_temp := l_temp||append(6);
   l_temp := l_temp||append(10);
   l_temp := l_temp||append(8);
   l_temp := l_temp||append(9);
   l_temp := l_temp||append(48);
   l_temp := l_temp||append(63);
   l_temp := l_temp||append(91);
   l_temp := l_temp||append(11);
   l_temp := l_temp||append(94);
   l_temp := l_temp||append(92);
   l_temp := l_temp||append(93);
   l_temp := l_temp||append(91);
   l_temp := l_temp||append(57);
   l_temp := l_temp||append(2);
   l_temp := l_temp||append(26);
   l_temp := l_temp||append(31);
   l_temp := l_temp||append(30);
   l_temp := l_temp||append(28);
   l_temp := l_temp||append(45);
   l_temp := l_temp||append(15);
   l_temp := l_temp||append(14);
   l_temp := l_temp||append(12);
   l_temp := l_temp||append(60);
   l_temp := l_temp||append(61);
   l_temp := l_temp||append(59);
   l_temp := l_temp||append(80);
   g_encryption_key := l_temp;
END instantiate_data;
--
-----------------------------------------------------------------------------
--
FUNCTION encrypt_data (p_string_in VARCHAR2) RETURN VARCHAR2 IS
   l_retval        nm3type.max_varchar2;
   l_padded_string nm3type.max_varchar2;
   l_input_str_len NUMBER;
   l_padded_length NUMBER;
BEGIN
--
   nm_debug.proc_start(g_package_name,'encrypt_data');
--
   l_padded_string := p_string_in;
   l_input_str_len := LENGTH(l_padded_string);
   l_padded_length := (TRUNC((l_input_str_len/8))+1)*8;
   IF l_padded_length != l_input_str_len
    THEN
      l_padded_string := RPAD(l_padded_string,l_padded_length,c_pad_char);
   END IF;
--
   l_retval := dbms_obfuscation_toolkit.DES3Encrypt
                        (input_string => l_padded_string
                        ,key_string   => g_encryption_key
                        ,which        => dbms_obfuscation_toolkit.ThreeKeyMode
                        ,iv_string    => Null
                        );
--
   nm_debug.proc_end(g_package_name,'encrypt_data');
--
   RETURN l_retval;
--
END encrypt_data;
--
-----------------------------------------------------------------------------
--
FUNCTION decrypt_data (p_string_in VARCHAR2) RETURN VARCHAR2 IS
   l_retval        nm3type.max_varchar2;
BEGIN
--
   nm_debug.proc_start(g_package_name,'decrypt_data');
--
   l_retval := dbms_obfuscation_toolkit.DES3Decrypt
                        (input_string => p_string_in
                        ,key_string   => g_encryption_key
                        ,which        => dbms_obfuscation_toolkit.ThreeKeyMode
                        ,iv_string    => Null
                        );
--
   l_retval := RTRIM(l_retval,c_pad_char);
--
   nm_debug.proc_end(g_package_name,'decrypt_data');
--
   RETURN l_retval;
--
END decrypt_data;
--
-----------------------------------------------------------------------------
--
PROCEDURE store_nmps_from_instead_of_trg
                            (pi_rec_nmps_old nm_mail_pop_servers%ROWTYPE
                            ,pi_rec_nmps_new nm_mail_pop_servers%ROWTYPE
                            ,pi_inserting    BOOLEAN
                            ,pi_updating     BOOLEAN
                            ,pi_deleting     BOOLEAN
                            ) IS
   l_rowid ROWID;
   l_rec_nmps nm_mail_pop_servers%ROWTYPE := pi_rec_nmps_new;
BEGIN
--
   nm_debug.proc_start(g_package_name,'store_nmps_from_instead_of_trg');
--
   IF pi_inserting
    THEN
      l_rec_nmps.nmps_password     := encrypt_data (l_rec_nmps.nmps_password);
      ins_nmps (l_rec_nmps);
   ELSIF pi_updating
    THEN
      IF pi_rec_nmps_new.nmps_password != pi_rec_nmps_old.nmps_password
       THEN
         l_rec_nmps.nmps_password := encrypt_data (l_rec_nmps.nmps_password);
      END IF;
      l_rowid := lock_nmps (pi_nmps_id => l_rec_nmps.nmps_id);
      UPDATE nm_mail_pop_servers
       SET   nmps_description = l_rec_nmps.nmps_description
            ,nmps_server_name = l_rec_nmps.nmps_server_name
            ,nmps_server_port = l_rec_nmps.nmps_server_port
            ,nmps_username    = l_rec_nmps.nmps_username
            ,nmps_password    = l_rec_nmps.nmps_password
            ,nmps_timeout     = l_rec_nmps.nmps_timeout
      WHERE  ROWID            = l_rowid;
   ELSIF pi_deleting
    THEN
      del_nmps (pi_nmps_id => pi_rec_nmps_old.nmps_id);
   END IF;
--
   nm_debug.proc_end(g_package_name,'store_nmps_from_instead_of_trg');
--
END store_nmps_from_instead_of_trg;
--
-----------------------------------------------------------------------------
--
FUNCTION open_connection (p_remote_host VARCHAR2
                         ,p_remote_port PLS_INTEGER
                         ,p_timeout     PLS_INTEGER
                         ) RETURN utl_tcp.connection IS
   l_conn utl_tcp.connection;
   l_server_not_found EXCEPTION;
   PRAGMA EXCEPTION_INIT(l_server_not_found,-29260);
BEGIN
--
   nm_debug.proc_start(g_package_name,'open_connection');
--
--
-- Task 0110486 - ensure there is an ACL for the mail server
--
   BEGIN
     nm3acl.process_email_connection ( pi_pop3_server => p_remote_host
                                     , pi_pop3_port   => p_remote_port );
--   EXCEPTION
--     WHEN OTHERS THEN NULL;
   END;
--
--   nm_debug.debug ('Opening connection for '||p_remote_host||' '||p_remote_port,4);
   l_conn := utl_tcp.open_connection (remote_host     => p_remote_host
                                     ,remote_port     => p_remote_port
--                           local_host      IN VARCHAR2    DEFAULT NULL,
--                           local_port      IN PLS_INTEGER DEFAULT NULL,
                                     ,in_buffer_size  => 32767
--                           out_buffer_size IN PLS_INTEGER DEFAULT NULL,
--                           charset         IN VARCHAR2    DEFAULT NULL,
--                           newline         IN VARCHAR2    DEFAULT CRLF,
                                     ,tx_timeout      => p_timeout
                                     );
--   nm_debug.debug ('Opened connection on '||p_remote_host||' '||p_remote_port,4);
--   debug_connection (l_conn);
--
   nm_debug.proc_end(g_package_name,'open_connection');
--
   RETURN l_conn;
--
EXCEPTION
--
   WHEN ex_acl_failure
    THEN
      close_all_connections;
      hig.raise_ner(nm3type.c_hig,551);
--
   WHEN l_server_not_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 28
                    ,pi_supplementary_info => 'Server not found ('||p_remote_host||':'||p_remote_port||')'
                    );
--
END open_connection;
--
-----------------------------------------------------------------------------
--
PROCEDURE close_connection (p_connection IN OUT NOCOPY utl_tcp.connection) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'close_connection');
--
--   nm_debug.debug('Closing connection');
--   debug_connection (p_connection);
   utl_tcp.close_connection (c => p_connection);
--
   nm_debug.proc_end(g_package_name,'close_connection');
--
END close_connection;
--
-----------------------------------------------------------------------------
--
PROCEDURE close_all_connections IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'close_all_connections');
--
   utl_tcp.close_all_connections;
--
   nm_debug.proc_end(g_package_name,'close_all_connections');
--
END close_all_connections;
--
-----------------------------------------------------------------------------
--
FUNCTION get_all_output (p_connection IN OUT NOCOPY utl_tcp.connection) RETURN nm3type.tab_varchar32767 IS
   l_retval   nm3type.tab_varchar32767;
   l_line     nm3type.max_varchar2;
   len        PLS_INTEGER;
   l_st_time  NUMBER;
   l_end_time NUMBER;
BEGIN
--   nm_debug.debug('getting output : START');
--   nm_debug.debug('available : '||utl_tcp.available(p_connection));
   l_st_time := dbms_utility.get_time;
   DECLARE
      l_timeout EXCEPTION;
      PRAGMA EXCEPTION_INIT (l_timeout, -29276);
   BEGIN
      LOOP
--         nm_debug.debug('getting line '||(l_retval.COUNT+1),4);
         len := utl_tcp.read_line (c           => p_connection
                                  ,data        => l_line
                                  ,remove_crlf => TRUE
                                  ,peek        => FALSE
                                  );
--         l_line := utl_tcp.get_line(p_connection, TRUE);
--         nm_debug.debug('line is '||l_line,4);
         l_retval(l_retval.COUNT+1) := l_line;
      END LOOP;
   EXCEPTION
      WHEN utl_tcp.end_of_input
       THEN
         NULL; -- end of input
      WHEN l_timeout
       THEN
         NULL; -- transfer timeout - generally end of input
   END;
   l_end_time := dbms_utility.get_time;
--   nm_debug.debug('Data Retrieval ('||l_retval.COUNT||' lines) took '||((l_end_time-l_st_time)/100)||'s');
   --nm_debug.debug('getting output');
   --nm3tab_varchar.debug_tab_varchar (p_tab_vc => l_retval);
   RETURN l_retval;
END get_all_output;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_buffer (p_connection   IN OUT NOCOPY utl_tcp.connection
                       ,p_write_buffer IN            VARCHAR2
                       ) IS
   len PLS_INTEGER;
BEGIN
--   nm_debug.debug('attempting : '||p_write_buffer,4);
   len := utl_tcp.write_line(p_connection, p_write_buffer);
--   nm_debug.debug('managed :...'||p_write_buffer||'...('||len||')',4);
   utl_tcp.flush(c => p_connection);
END write_buffer;
--
-----------------------------------------------------------------------------
--
FUNCTION build_retr_commands (pi_output nm3type.tab_varchar32767) RETURN nm3type.tab_varchar32767 IS
   l_retr          nm3type.tab_varchar32767;
   listing_started BOOLEAN := FALSE;
   l_line          nm3type.max_varchar2;
BEGIN
   FOR i IN 1..pi_output.COUNT
    LOOP
      IF listing_started
       THEN
         IF pi_output(i) = '.'
          THEN
            listing_started := FALSE;
            EXIT;
         END IF;
         l_line := 'RETR '||SUBSTR(pi_output(i),1,INSTR(pi_output(i),' ',1,1));
         l_retr(l_retr.COUNT+1) := RTRIM(l_line,' ');
      END IF;
--
      IF   i > 1
       AND pi_output(i) LIKE '+OK%'
       AND is_failed_command (pi_output(i-1))
       THEN
         listing_started := TRUE;
      END IF;
--
   END LOOP;
--
   RETURN l_retr;
--
END build_retr_commands;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_connection (p_connection IN OUT NOCOPY utl_tcp.connection) IS
BEGIN
--
   nm_debug.debug(' - remote_host : '||p_connection.remote_host); -- Remote host name
   nm_debug.debug(' - remote_port : '||p_connection.remote_port); -- Remote port number
   nm_debug.debug(' - local_host  : '||p_connection.local_host);  -- Local host name
   nm_debug.debug(' - local_port  : '||p_connection.local_port);  -- Local port number
   nm_debug.debug(' - charset     : '||p_connection.charset);     -- Character set for on-the-wire comm.
   nm_debug.debug(' - newline     : '||p_connection.newline);     -- Newline character sequence
   nm_debug.debug(' - tx_timeout  : '||p_connection.tx_timeout);  -- Transfer time-out value (in seconds)
   nm_debug.debug(' - private_sd  : '||p_connection.private_sd);  -- For internal use only
--
END debug_connection;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmps_internal (pi_rec_nmps nm_mail_pop_servers%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
   l_rec_nmps nm_mail_pop_servers%ROWTYPE;
BEGIN
   l_rec_nmps               := pi_rec_nmps;
   l_rec_nmps.nmps_password := decrypt_data (l_rec_nmps.nmps_password);
   debug_nmps (pi_rec_nmps => l_rec_nmps
              ,p_level     => p_level
              );
END debug_nmps_internal;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmps (pi_rec_nmps nm_mail_pop_servers%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmps');
--
   nm_debug.debug('nmps_id          : '||pi_rec_nmps.nmps_id,p_level);
   nm_debug.debug('nmps_description : '||pi_rec_nmps.nmps_description,p_level);
   nm_debug.debug('nmps_server_name : '||pi_rec_nmps.nmps_server_name,p_level);
   nm_debug.debug('nmps_server_port : '||pi_rec_nmps.nmps_server_port,p_level);
   nm_debug.debug('nmps_username    : '||pi_rec_nmps.nmps_username,p_level);
   nm_debug.debug('nmps_password    : '||pi_rec_nmps.nmps_password,p_level);
   nm_debug.debug('nmps_timeout     : '||pi_rec_nmps.nmps_timeout,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmps');
--
END debug_nmps;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmpm (pi_rec_nmpm nm_mail_pop_messages%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmpm');
--
   nm_debug.debug('nmpm_id            : '||pi_rec_nmpm.nmpm_id,p_level);
   nm_debug.debug('nmpm_nmps_id       : '||pi_rec_nmpm.nmpm_nmps_id,p_level);
   nm_debug.debug('nmpm_date_created  : '||pi_rec_nmpm.nmpm_date_created,p_level);
   nm_debug.debug('nmpm_date_modified : '||pi_rec_nmpm.nmpm_date_modified,p_level);
   nm_debug.debug('nmpm_modified_by   : '||pi_rec_nmpm.nmpm_modified_by,p_level);
   nm_debug.debug('nmpm_created_by    : '||pi_rec_nmpm.nmpm_created_by,p_level);
   nm_debug.debug('nmpm_status        : '||pi_rec_nmpm.nmpm_status,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmpm');
--
END debug_nmpm;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmpmh (pi_rec_nmpmh nm_mail_pop_message_headers%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmpmh');
--
   nm_debug.debug('nmpmh_nmpm_id      : '||pi_rec_nmpmh.nmpmh_nmpm_id,p_level);
   nm_debug.debug('nmpmh_header_field : '||pi_rec_nmpmh.nmpmh_header_field,p_level);
   nm_debug.debug('nmpmh_header_value : '||pi_rec_nmpmh.nmpmh_header_value,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmpmh');
--
END debug_nmpmh;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmpmd (pi_rec_nmpmd nm_mail_pop_message_details%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmpmd');
--
   nm_debug.debug('nmpmd_nmpm_id     : '||pi_rec_nmpmd.nmpmd_nmpm_id,p_level);
   nm_debug.debug('nmpmd_line_number : '||pi_rec_nmpmd.nmpmd_line_number,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmpmd');
--
END debug_nmpmd;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmpp (pi_rec_nmpp nm_mail_pop_processes%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmpp');
--
   nm_debug.debug('nmpp_id          : '||pi_rec_nmpp.nmpp_id,p_level);
   nm_debug.debug('nmpp_descr       : '||pi_rec_nmpp.nmpp_descr,p_level);
   nm_debug.debug('nmpp_process_seq : '||pi_rec_nmpp.nmpp_process_seq,p_level);
   nm_debug.debug('nmpp_procedure   : '||pi_rec_nmpp.nmpp_procedure,p_level);
   nm_debug.debug('nmpp_nmps_id     : '||pi_rec_nmpp.nmpp_nmps_id,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmpp');
--
END debug_nmpp;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_nmppc (pi_rec_nmppc nm_mail_pop_process_conditions%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_nmppc');
--
   nm_debug.debug('nmppc_nmpp_id      : '||pi_rec_nmppc.nmppc_nmpp_id,p_level);
   nm_debug.debug('nmppc_header_field : '||pi_rec_nmppc.nmppc_header_field,p_level);
   nm_debug.debug('nmppc_header_value : '||pi_rec_nmppc.nmppc_header_value,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_nmppc');
--
END debug_nmppc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMPS_PK constraint
--
PROCEDURE del_nmps (pi_nmps_id           nm_mail_pop_servers.nmps_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmps');
--
   -- Lock the row first
   l_rowid := lock_nmps
                   (pi_nmps_id           => pi_nmps_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mail_pop_servers
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmps');
--
END del_nmps;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMPM_PK constraint
--
PROCEDURE del_nmpm (pi_nmpm_id           nm_mail_pop_messages.nmpm_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmpm');
--
   -- Lock the row first
   l_rowid := lock_nmpm
                   (pi_nmpm_id           => pi_nmpm_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mail_pop_messages
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmpm');
--
END del_nmpm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMPMH_PK constraint
--
PROCEDURE del_nmpmh (pi_nmpmh_nmpm_id      nm_mail_pop_message_headers.nmpmh_nmpm_id%TYPE
                    ,pi_nmpmh_header_field nm_mail_pop_message_headers.nmpmh_header_field%TYPE
                    ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                    ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmpmh');
--
   -- Lock the row first
   l_rowid := lock_nmpmh
                   (pi_nmpmh_nmpm_id      => pi_nmpmh_nmpm_id
                   ,pi_nmpmh_header_field => pi_nmpmh_header_field
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   ,pi_locked_sqlcode     => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mail_pop_message_headers
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmpmh');
--
END del_nmpmh;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMPMD_PK constraint
--
PROCEDURE del_nmpmd (pi_nmpmd_nmpm_id     nm_mail_pop_message_details.nmpmd_nmpm_id%TYPE
                    ,pi_nmpmd_line_number nm_mail_pop_message_details.nmpmd_line_number%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmpmd');
--
   -- Lock the row first
   l_rowid := lock_nmpmd
                   (pi_nmpmd_nmpm_id     => pi_nmpmd_nmpm_id
                   ,pi_nmpmd_line_number => pi_nmpmd_line_number
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mail_pop_message_details
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmpmd');
--
END del_nmpmd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMPP_PK constraint
--
PROCEDURE del_nmpp (pi_nmpp_id           nm_mail_pop_processes.nmpp_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmpp');
--
   -- Lock the row first
   l_rowid := lock_nmpp
                   (pi_nmpp_id           => pi_nmpp_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mail_pop_processes
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmpp');
--
END del_nmpp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using NMPPC_PK constraint
--
PROCEDURE del_nmppc (pi_nmppc_nmpp_id      nm_mail_pop_process_conditions.nmppc_nmpp_id%TYPE
                    ,pi_nmppc_header_field nm_mail_pop_process_conditions.nmppc_header_field%TYPE
                    ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                    ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_nmppc');
--
   -- Lock the row first
   l_rowid := lock_nmppc
                   (pi_nmppc_nmpp_id      => pi_nmppc_nmpp_id
                   ,pi_nmppc_header_field => pi_nmppc_header_field
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   ,pi_locked_sqlcode     => pi_locked_sqlcode
                   );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE nm_mail_pop_process_conditions
      WHERE ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del_nmppc');
--
END del_nmppc;
--
-----------------------------------------------------------------------------
--
--
--   Function to get using NMPS_PK constraint
--
FUNCTION get_nmps (pi_nmps_id           nm_mail_pop_servers.nmps_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ) RETURN nm_mail_pop_servers%ROWTYPE IS
--
   CURSOR cs_nmps IS
   SELECT *
    FROM  nm_mail_pop_servers
   WHERE  nmps_id = pi_nmps_id;
--
   l_found  BOOLEAN;
   l_retval nm_mail_pop_servers%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_nmps');
--
   OPEN  cs_nmps;
   FETCH cs_nmps INTO l_retval;
   l_found := cs_nmps%FOUND;
   CLOSE cs_nmps;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mail_pop_servers (NMPS_PK)'
                                              ||CHR(10)||'nmps_id => '||pi_nmps_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_nmps');
--
   RETURN l_retval;
--
END get_nmps;
--
-----------------------------------------------------------------------------
--
--
--   Function to get using NMPM_PK constraint
--
FUNCTION get_nmpm (pi_nmpm_id           nm_mail_pop_messages.nmpm_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ) RETURN nm_mail_pop_messages%ROWTYPE IS
--
   CURSOR cs_nmpm IS
   SELECT *
    FROM  nm_mail_pop_messages
   WHERE  nmpm_id = pi_nmpm_id;
--
   l_found  BOOLEAN;
   l_retval nm_mail_pop_messages%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_nmpm');
--
   OPEN  cs_nmpm;
   FETCH cs_nmpm INTO l_retval;
   l_found := cs_nmpm%FOUND;
   CLOSE cs_nmpm;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mail_pop_messages (NMPM_PK)'
                                              ||CHR(10)||'nmpm_id => '||pi_nmpm_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_nmpm');
--
   RETURN l_retval;
--
END get_nmpm;
--
-----------------------------------------------------------------------------
--
--
--   Function to get using NMPMH_PK constraint
--
FUNCTION get_nmpmh (pi_nmpmh_nmpm_id      nm_mail_pop_message_headers.nmpmh_nmpm_id%TYPE
                   ,pi_nmpmh_header_field nm_mail_pop_message_headers.nmpmh_header_field%TYPE
                   ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                   ) RETURN nm_mail_pop_message_headers%ROWTYPE IS
--
   CURSOR cs_nmpmh IS
   SELECT *
    FROM  nm_mail_pop_message_headers
   WHERE  nmpmh_nmpm_id      = pi_nmpmh_nmpm_id
    AND   nmpmh_header_field = pi_nmpmh_header_field;
--
   l_found  BOOLEAN;
   l_retval nm_mail_pop_message_headers%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_nmpmh');
--
   OPEN  cs_nmpmh;
   FETCH cs_nmpmh INTO l_retval;
   l_found := cs_nmpmh%FOUND;
   CLOSE cs_nmpmh;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mail_pop_message_headers (NMPMH_PK)'
                                              ||CHR(10)||'nmpmh_nmpm_id      => '||pi_nmpmh_nmpm_id
                                              ||CHR(10)||'nmpmh_header_field => '||pi_nmpmh_header_field
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_nmpmh');
--
   RETURN l_retval;
--
END get_nmpmh;
--
-----------------------------------------------------------------------------
--
--
--   Function to get using NMPMD_PK constraint
--
FUNCTION get_nmpmd (pi_nmpmd_nmpm_id     nm_mail_pop_message_details.nmpmd_nmpm_id%TYPE
                   ,pi_nmpmd_line_number nm_mail_pop_message_details.nmpmd_line_number%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ) RETURN nm_mail_pop_message_details%ROWTYPE IS
--
   CURSOR cs_nmpmd IS
   SELECT *
    FROM  nm_mail_pop_message_details
   WHERE  nmpmd_nmpm_id     = pi_nmpmd_nmpm_id
    AND   nmpmd_line_number = pi_nmpmd_line_number;
--
   l_found  BOOLEAN;
   l_retval nm_mail_pop_message_details%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_nmpmd');
--
   OPEN  cs_nmpmd;
   FETCH cs_nmpmd INTO l_retval;
   l_found := cs_nmpmd%FOUND;
   CLOSE cs_nmpmd;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mail_pop_message_details (NMPMD_PK)'
                                              ||CHR(10)||'nmpmd_nmpm_id     => '||pi_nmpmd_nmpm_id
                                              ||CHR(10)||'nmpmd_line_number => '||pi_nmpmd_line_number
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_nmpmd');
--
   RETURN l_retval;
--
END get_nmpmd;
--
-----------------------------------------------------------------------------
--
--
--   Function to get using NMPP_PK constraint
--
FUNCTION get_nmpp (pi_nmpp_id           nm_mail_pop_processes.nmpp_id%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ) RETURN nm_mail_pop_processes%ROWTYPE IS
--
   CURSOR cs_nmpp IS
   SELECT *
    FROM  nm_mail_pop_processes
   WHERE  nmpp_id = pi_nmpp_id;
--
   l_found  BOOLEAN;
   l_retval nm_mail_pop_processes%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_nmpp');
--
   OPEN  cs_nmpp;
   FETCH cs_nmpp INTO l_retval;
   l_found := cs_nmpp%FOUND;
   CLOSE cs_nmpp;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mail_pop_processes (NMPP_PK)'
                                              ||CHR(10)||'nmpp_id => '||pi_nmpp_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_nmpp');
--
   RETURN l_retval;
--
END get_nmpp;
--
-----------------------------------------------------------------------------
--
--
--   Function to get using NMPPC_PK constraint
--
FUNCTION get_nmppc (pi_nmppc_nmpp_id      nm_mail_pop_process_conditions.nmppc_nmpp_id%TYPE
                   ,pi_nmppc_header_field nm_mail_pop_process_conditions.nmppc_header_field%TYPE
                   ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                   ) RETURN nm_mail_pop_process_conditions%ROWTYPE IS
--
   CURSOR cs_nmppc IS
   SELECT *
    FROM  nm_mail_pop_process_conditions
   WHERE  nmppc_nmpp_id      = pi_nmppc_nmpp_id
    AND   nmppc_header_field = pi_nmppc_header_field;
--
   l_found  BOOLEAN;
   l_retval nm_mail_pop_process_conditions%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_nmppc');
--
   OPEN  cs_nmppc;
   FETCH cs_nmppc INTO l_retval;
   l_found := cs_nmppc%FOUND;
   CLOSE cs_nmppc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mail_pop_process_conditions (NMPPC_PK)'
                                              ||CHR(10)||'nmppc_nmpp_id      => '||pi_nmppc_nmpp_id
                                              ||CHR(10)||'nmppc_header_field => '||pi_nmppc_header_field
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_nmppc');
--
   RETURN l_retval;
--
END get_nmppc;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmps (p_rec_nmps IN OUT nm_mail_pop_servers%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_nmps');
--
   p_rec_nmps.nmps_server_port               := NVL(p_rec_nmps.nmps_server_port,110 );
--
   INSERT INTO nm_mail_pop_servers
            (nmps_id
            ,nmps_description
            ,nmps_server_name
            ,nmps_server_port
            ,nmps_username
            ,nmps_password
            ,nmps_timeout
            )
     VALUES (p_rec_nmps.nmps_id
            ,p_rec_nmps.nmps_description
            ,p_rec_nmps.nmps_server_name
            ,p_rec_nmps.nmps_server_port
            ,p_rec_nmps.nmps_username
            ,p_rec_nmps.nmps_password
            ,p_rec_nmps.nmps_timeout
            )
   RETURNING nmps_id
            ,nmps_description
            ,nmps_server_name
            ,nmps_server_port
            ,nmps_username
            ,nmps_password
            ,nmps_timeout
      INTO   p_rec_nmps.nmps_id
            ,p_rec_nmps.nmps_description
            ,p_rec_nmps.nmps_server_name
            ,p_rec_nmps.nmps_server_port
            ,p_rec_nmps.nmps_username
            ,p_rec_nmps.nmps_password
            ,p_rec_nmps.nmps_timeout;
--
   nm_debug.proc_end(g_package_name,'ins_nmps');
--
END ins_nmps;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmps_v (p_rec_nmps_v IN OUT nm_mail_pop_servers_v%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_nmps');
--
   p_rec_nmps_v.nmps_server_port := NVL(p_rec_nmps_v.nmps_server_port,110 );
--
   INSERT INTO nm_mail_pop_servers_v
            (nmps_id
            ,nmps_description
            ,nmps_server_name
            ,nmps_server_port
            ,nmps_username
            ,nmps_password
            ,nmps_timeout
            )
     VALUES (p_rec_nmps_v.nmps_id
            ,p_rec_nmps_v.nmps_description
            ,p_rec_nmps_v.nmps_server_name
            ,p_rec_nmps_v.nmps_server_port
            ,p_rec_nmps_v.nmps_username
            ,p_rec_nmps_v.nmps_password
            ,p_rec_nmps_v.nmps_timeout
            );
--
   p_rec_nmps_v := get_nmps (pi_nmps_id => p_rec_nmps_v.nmps_id);
--
   nm_debug.proc_end(g_package_name,'ins_nmps');
--
END ins_nmps_v;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmpm (p_rec_nmpm IN OUT nm_mail_pop_messages%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_nmpm');
--
--
   INSERT INTO nm_mail_pop_messages
            (nmpm_id
            ,nmpm_nmps_id
            ,nmpm_date_created
            ,nmpm_date_modified
            ,nmpm_modified_by
            ,nmpm_created_by
            ,nmpm_status
            )
     VALUES (p_rec_nmpm.nmpm_id
            ,p_rec_nmpm.nmpm_nmps_id
            ,p_rec_nmpm.nmpm_date_created
            ,p_rec_nmpm.nmpm_date_modified
            ,p_rec_nmpm.nmpm_modified_by
            ,p_rec_nmpm.nmpm_created_by
            ,p_rec_nmpm.nmpm_status
            )
   RETURNING nmpm_id
            ,nmpm_nmps_id
            ,nmpm_date_created
            ,nmpm_date_modified
            ,nmpm_modified_by
            ,nmpm_created_by
            ,nmpm_status
      INTO   p_rec_nmpm.nmpm_id
            ,p_rec_nmpm.nmpm_nmps_id
            ,p_rec_nmpm.nmpm_date_created
            ,p_rec_nmpm.nmpm_date_modified
            ,p_rec_nmpm.nmpm_modified_by
            ,p_rec_nmpm.nmpm_created_by
            ,p_rec_nmpm.nmpm_status;
--
   nm_debug.proc_end(g_package_name,'ins_nmpm');
--
END ins_nmpm;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmpmh (p_rec_nmpmh IN OUT nm_mail_pop_message_headers%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_nmpmh');
--
--
   INSERT INTO nm_mail_pop_message_headers
            (nmpmh_nmpm_id
            ,nmpmh_header_field
            ,nmpmh_header_value
            )
     VALUES (p_rec_nmpmh.nmpmh_nmpm_id
            ,p_rec_nmpmh.nmpmh_header_field
            ,p_rec_nmpmh.nmpmh_header_value
            )
   RETURNING nmpmh_nmpm_id
            ,nmpmh_header_field
      INTO   p_rec_nmpmh.nmpmh_nmpm_id
            ,p_rec_nmpmh.nmpmh_header_field;
--
   nm_debug.proc_end(g_package_name,'ins_nmpmh');
--
END ins_nmpmh;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmpmd (p_rec_nmpmd IN OUT nm_mail_pop_message_details%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_nmpmd');
--
--
   INSERT INTO nm_mail_pop_message_details
            (nmpmd_nmpm_id
            ,nmpmd_line_number
            ,nmpmd_text
            )
     VALUES (p_rec_nmpmd.nmpmd_nmpm_id
            ,p_rec_nmpmd.nmpmd_line_number
            ,p_rec_nmpmd.nmpmd_text
            )
   RETURNING nmpmd_nmpm_id
            ,nmpmd_line_number
      INTO   p_rec_nmpmd.nmpmd_nmpm_id
            ,p_rec_nmpmd.nmpmd_line_number;
--
   nm_debug.proc_end(g_package_name,'ins_nmpmd');
--
END ins_nmpmd;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmpmr (p_rec_nmpmr IN OUT nm_mail_pop_message_raw%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_nmpmr');
--
--
   INSERT INTO nm_mail_pop_message_raw
            (nmpmr_nmpm_id
            ,nmpmr_line_number
            ,nmpmr_text
            )
     VALUES (p_rec_nmpmr.nmpmr_nmpm_id
            ,p_rec_nmpmr.nmpmr_line_number
            ,p_rec_nmpmr.nmpmr_text
            )
   RETURNING nmpmr_nmpm_id
            ,nmpmr_line_number
      INTO   p_rec_nmpmr.nmpmr_nmpm_id
            ,p_rec_nmpmr.nmpmr_line_number;
--
   nm_debug.proc_end(g_package_name,'ins_nmpmr');
--
END ins_nmpmr;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmpp (p_rec_nmpp IN OUT nm_mail_pop_processes%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_nmpp');
--
--
   INSERT INTO nm_mail_pop_processes
            (nmpp_id
            ,nmpp_descr
            ,nmpp_process_seq
            ,nmpp_procedure
            ,nmpp_nmps_id
            )
     VALUES (p_rec_nmpp.nmpp_id
            ,p_rec_nmpp.nmpp_descr
            ,p_rec_nmpp.nmpp_process_seq
            ,p_rec_nmpp.nmpp_procedure
            ,p_rec_nmpp.nmpp_nmps_id
            )
   RETURNING nmpp_id
            ,nmpp_descr
            ,nmpp_process_seq
            ,nmpp_procedure
            ,nmpp_nmps_id
      INTO   p_rec_nmpp.nmpp_id
            ,p_rec_nmpp.nmpp_descr
            ,p_rec_nmpp.nmpp_process_seq
            ,p_rec_nmpp.nmpp_procedure
            ,p_rec_nmpp.nmpp_nmps_id;
--
   nm_debug.proc_end(g_package_name,'ins_nmpp');
--
END ins_nmpp;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmppc (p_rec_nmppc IN OUT nm_mail_pop_process_conditions%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_nmppc');
--
--
   INSERT INTO nm_mail_pop_process_conditions
            (nmppc_nmpp_id
            ,nmppc_header_field
            ,nmppc_header_value
            )
     VALUES (p_rec_nmppc.nmppc_nmpp_id
            ,p_rec_nmppc.nmppc_header_field
            ,p_rec_nmppc.nmppc_header_value
            )
   RETURNING nmppc_nmpp_id
            ,nmppc_header_field
            ,nmppc_header_value
      INTO   p_rec_nmppc.nmppc_nmpp_id
            ,p_rec_nmppc.nmppc_header_field
            ,p_rec_nmppc.nmppc_header_value;
--
   nm_debug.proc_end(g_package_name,'ins_nmppc');
--
END ins_nmppc;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmppe (p_rec_nmppe IN OUT nm_mail_pop_processing_errors%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_nmppe');
--
   INSERT INTO nm_mail_pop_processing_errors
            (nmppe_nmpm_id
            ,nmppe_sqlerror_code
            ,nmppe_sqlerror_msg
            )
     VALUES (p_rec_nmppe.nmppe_nmpm_id
            ,p_rec_nmppe.nmppe_sqlerror_code
            ,p_rec_nmppe.nmppe_sqlerror_msg
            )
   RETURNING nmppe_nmpm_id
            ,nmppe_sqlerror_code
            ,nmppe_sqlerror_msg
      INTO   p_rec_nmppe.nmppe_nmpm_id
            ,p_rec_nmppe.nmppe_sqlerror_code
            ,p_rec_nmppe.nmppe_sqlerror_msg;
--
   nm_debug.proc_end(g_package_name,'ins_nmppe');
--
END ins_nmppe;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMPS_PK constraint
--
FUNCTION lock_nmps (pi_nmps_id           nm_mail_pop_servers.nmps_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nmps IS
   SELECT ROWID
    FROM  nm_mail_pop_servers
   WHERE  nmps_id = pi_nmps_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmps');
--
   OPEN  cs_nmps;
   FETCH cs_nmps INTO l_retval;
   l_found := cs_nmps%FOUND;
   CLOSE cs_nmps;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mail_pop_servers (NMPS_PK)'
                                              ||CHR(10)||'nmps_id => '||pi_nmps_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmps');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mail_pop_servers (NMPS_PK)'
                                              ||CHR(10)||'nmps_id => '||pi_nmps_id
                    );
--
END lock_nmps;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMPS_PK constraint
--
PROCEDURE lock_nmps (pi_nmps_id           nm_mail_pop_servers.nmps_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmps');
--
   l_rowid := lock_nmps
                   (pi_nmps_id           => pi_nmps_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmps');
--
END lock_nmps;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMPM_PK constraint
--
FUNCTION lock_nmpm (pi_nmpm_id           nm_mail_pop_messages.nmpm_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nmpm IS
   SELECT ROWID
    FROM  nm_mail_pop_messages
   WHERE  nmpm_id = pi_nmpm_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmpm');
--
   OPEN  cs_nmpm;
   FETCH cs_nmpm INTO l_retval;
   l_found := cs_nmpm%FOUND;
   CLOSE cs_nmpm;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mail_pop_messages (NMPM_PK)'
                                              ||CHR(10)||'nmpm_id => '||pi_nmpm_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmpm');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mail_pop_messages (NMPM_PK)'
                                              ||CHR(10)||'nmpm_id => '||pi_nmpm_id
                    );
--
END lock_nmpm;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMPM_PK constraint
--
PROCEDURE lock_nmpm (pi_nmpm_id           nm_mail_pop_messages.nmpm_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmpm');
--
   l_rowid := lock_nmpm
                   (pi_nmpm_id           => pi_nmpm_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmpm');
--
END lock_nmpm;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMPMH_PK constraint
--
FUNCTION lock_nmpmh (pi_nmpmh_nmpm_id      nm_mail_pop_message_headers.nmpmh_nmpm_id%TYPE
                    ,pi_nmpmh_header_field nm_mail_pop_message_headers.nmpmh_header_field%TYPE
                    ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                    ) RETURN ROWID IS
--
   CURSOR cs_nmpmh IS
   SELECT ROWID
    FROM  nm_mail_pop_message_headers
   WHERE  nmpmh_nmpm_id      = pi_nmpmh_nmpm_id
    AND   nmpmh_header_field = pi_nmpmh_header_field
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmpmh');
--
   OPEN  cs_nmpmh;
   FETCH cs_nmpmh INTO l_retval;
   l_found := cs_nmpmh%FOUND;
   CLOSE cs_nmpmh;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mail_pop_message_headers (NMPMH_PK)'
                                              ||CHR(10)||'nmpmh_nmpm_id      => '||pi_nmpmh_nmpm_id
                                              ||CHR(10)||'nmpmh_header_field => '||pi_nmpmh_header_field
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmpmh');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mail_pop_message_headers (NMPMH_PK)'
                                              ||CHR(10)||'nmpmh_nmpm_id      => '||pi_nmpmh_nmpm_id
                                              ||CHR(10)||'nmpmh_header_field => '||pi_nmpmh_header_field
                    );
--
END lock_nmpmh;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMPMH_PK constraint
--
PROCEDURE lock_nmpmh (pi_nmpmh_nmpm_id      nm_mail_pop_message_headers.nmpmh_nmpm_id%TYPE
                     ,pi_nmpmh_header_field nm_mail_pop_message_headers.nmpmh_header_field%TYPE
                     ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                     ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                     ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                     ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmpmh');
--
   l_rowid := lock_nmpmh
                   (pi_nmpmh_nmpm_id      => pi_nmpmh_nmpm_id
                   ,pi_nmpmh_header_field => pi_nmpmh_header_field
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmpmh');
--
END lock_nmpmh;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMPMD_PK constraint
--
FUNCTION lock_nmpmd (pi_nmpmd_nmpm_id     nm_mail_pop_message_details.nmpmd_nmpm_id%TYPE
                    ,pi_nmpmd_line_number nm_mail_pop_message_details.nmpmd_line_number%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) RETURN ROWID IS
--
   CURSOR cs_nmpmd IS
   SELECT ROWID
    FROM  nm_mail_pop_message_details
   WHERE  nmpmd_nmpm_id     = pi_nmpmd_nmpm_id
    AND   nmpmd_line_number = pi_nmpmd_line_number
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmpmd');
--
   OPEN  cs_nmpmd;
   FETCH cs_nmpmd INTO l_retval;
   l_found := cs_nmpmd%FOUND;
   CLOSE cs_nmpmd;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mail_pop_message_details (NMPMD_PK)'
                                              ||CHR(10)||'nmpmd_nmpm_id     => '||pi_nmpmd_nmpm_id
                                              ||CHR(10)||'nmpmd_line_number => '||pi_nmpmd_line_number
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmpmd');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mail_pop_message_details (NMPMD_PK)'
                                              ||CHR(10)||'nmpmd_nmpm_id     => '||pi_nmpmd_nmpm_id
                                              ||CHR(10)||'nmpmd_line_number => '||pi_nmpmd_line_number
                    );
--
END lock_nmpmd;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMPMD_PK constraint
--
PROCEDURE lock_nmpmd (pi_nmpmd_nmpm_id     nm_mail_pop_message_details.nmpmd_nmpm_id%TYPE
                     ,pi_nmpmd_line_number nm_mail_pop_message_details.nmpmd_line_number%TYPE
                     ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                     ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                     ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                     ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmpmd');
--
   l_rowid := lock_nmpmd
                   (pi_nmpmd_nmpm_id     => pi_nmpmd_nmpm_id
                   ,pi_nmpmd_line_number => pi_nmpmd_line_number
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmpmd');
--
END lock_nmpmd;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMPP_PK constraint
--
FUNCTION lock_nmpp (pi_nmpp_id           nm_mail_pop_processes.nmpp_id%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) RETURN ROWID IS
--
   CURSOR cs_nmpp IS
   SELECT ROWID
    FROM  nm_mail_pop_processes
   WHERE  nmpp_id = pi_nmpp_id
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmpp');
--
   OPEN  cs_nmpp;
   FETCH cs_nmpp INTO l_retval;
   l_found := cs_nmpp%FOUND;
   CLOSE cs_nmpp;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mail_pop_processes (NMPP_PK)'
                                              ||CHR(10)||'nmpp_id => '||pi_nmpp_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmpp');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mail_pop_processes (NMPP_PK)'
                                              ||CHR(10)||'nmpp_id => '||pi_nmpp_id
                    );
--
END lock_nmpp;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMPP_PK constraint
--
PROCEDURE lock_nmpp (pi_nmpp_id           nm_mail_pop_processes.nmpp_id%TYPE
                    ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                    ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmpp');
--
   l_rowid := lock_nmpp
                   (pi_nmpp_id           => pi_nmpp_id
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmpp');
--
END lock_nmpp;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using NMPPC_PK constraint
--
FUNCTION lock_nmppc (pi_nmppc_nmpp_id      nm_mail_pop_process_conditions.nmppc_nmpp_id%TYPE
                    ,pi_nmppc_header_field nm_mail_pop_process_conditions.nmppc_header_field%TYPE
                    ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                    ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                    ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                    ) RETURN ROWID IS
--
   CURSOR cs_nmppc IS
   SELECT ROWID
    FROM  nm_mail_pop_process_conditions
   WHERE  nmppc_nmpp_id      = pi_nmppc_nmpp_id
    AND   nmppc_header_field = pi_nmppc_header_field
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmppc');
--
   OPEN  cs_nmppc;
   FETCH cs_nmppc INTO l_retval;
   l_found := cs_nmppc%FOUND;
   CLOSE cs_nmppc;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'nm_mail_pop_process_conditions (NMPPC_PK)'
                                              ||CHR(10)||'nmppc_nmpp_id      => '||pi_nmppc_nmpp_id
                                              ||CHR(10)||'nmppc_header_field => '||pi_nmppc_header_field
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_nmppc');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'nm_mail_pop_process_conditions (NMPPC_PK)'
                                              ||CHR(10)||'nmppc_nmpp_id      => '||pi_nmppc_nmpp_id
                                              ||CHR(10)||'nmppc_header_field => '||pi_nmppc_header_field
                    );
--
END lock_nmppc;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using NMPPC_PK constraint
--
PROCEDURE lock_nmppc (pi_nmppc_nmpp_id      nm_mail_pop_process_conditions.nmppc_nmpp_id%TYPE
                     ,pi_nmppc_header_field nm_mail_pop_process_conditions.nmppc_header_field%TYPE
                     ,pi_raise_not_found    BOOLEAN     DEFAULT TRUE
                     ,pi_not_found_sqlcode  PLS_INTEGER DEFAULT -20000
                     ,pi_locked_sqlcode     PLS_INTEGER DEFAULT -20000
                     ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_nmppc');
--
   l_rowid := lock_nmppc
                   (pi_nmppc_nmpp_id      => pi_nmppc_nmpp_id
                   ,pi_nmppc_header_field => pi_nmppc_header_field
                   ,pi_raise_not_found    => pi_raise_not_found
                   ,pi_not_found_sqlcode  => pi_not_found_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_nmppc');
--
END lock_nmppc;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nmpp_id_seq RETURN PLS_INTEGER IS
-- Get NMPP_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NMPP_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nmpp_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nmpp_id_seq RETURN PLS_INTEGER IS
-- Get NMPP_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NMPP_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nmpp_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nmpm_id_seq RETURN PLS_INTEGER IS
-- Get NMPM_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NMPM_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nmpm_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nmpm_id_seq RETURN PLS_INTEGER IS
-- Get NMPM_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NMPM_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nmpm_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION next_nmps_id_seq RETURN PLS_INTEGER IS
-- Get NMPS_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NMPS_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_nmps_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_nmps_id_seq RETURN PLS_INTEGER IS
-- Get NMPS_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NMPS_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_nmps_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION del_arr_1_from_arr_2 (pi_arr_1 nm3type.tab_varchar32767
                              ,pi_arr_2 nm3type.tab_varchar32767
                              ) RETURN nm3type.tab_varchar32767 IS
   l_retval nm3type.tab_varchar32767;
   l_diff   PLS_INTEGER := 1;
BEGIN
--
--nm_debug.debug('pi_arr_1.COUNT   : '||pi_arr_1.COUNT);
--nm_debug.debug('pi_arr_2.COUNT   : '||pi_arr_2.COUNT);
   WHILE l_diff <= pi_arr_1.COUNT
    LOOP
      EXIT WHEN NVL(pi_arr_1(l_diff),nm3type.c_nvl) != NVL(pi_arr_2(l_diff),nm3type.c_nvl);
      l_diff := l_diff + 1;
   END LOOP;
--nm_debug.debug('l_diff   : '||l_diff);
--
   FOR i IN l_diff..pi_arr_2.COUNT
    LOOP
      l_retval(l_retval.COUNT+1) := pi_arr_2(i);
   END LOOP;
--nm_debug.debug('l_retval.COUNT   : '||l_retval.COUNT);
--
   RETURN l_retval;
--
END del_arr_1_from_arr_2;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_pop_output (pi_array  IN     nm3type.tab_varchar32767
                             ,po_header    OUT nm3type.tab_varchar32767
                             ,po_body      OUT nm3type.tab_varchar32767
                             ,po_full      OUT nm3type.tab_varchar32767
                             ) IS
   l_header_start PLS_INTEGER := Null;
   l_body_start   PLS_INTEGER := Null;
--
   l_body                     nm3type.tab_varchar32767;
   l_i            PLS_INTEGER;
--
   PROCEDURE add_data (pi_start_pos IN     PLS_INTEGER
                      ,po_array        OUT nm3type.tab_varchar32767
                      ) IS
      l_count PLS_INTEGER := 0;
      l_i     PLS_INTEGER;
   BEGIN
      FOR i IN pi_start_pos..pi_array.COUNT
       LOOP
         IF pi_array(i) = '.' --end_of_data (i)
          THEN
            EXIT;
         ELSE
            l_count := l_count + 1;
            IF SUBSTR(pi_array(i),1,2) = '..'
             THEN
               po_array(l_count) := SUBSTR(pi_array(i),2);
            ELSE
               po_array(l_count) := pi_array(i);
            END IF;
         END IF;
      END LOOP;
      l_i := l_count;
      WHILE l_i > 0
       AND  po_array.EXISTS(l_i)
       AND  NVL(po_array(l_i),'.') = '.'
       LOOP
         po_array.DELETE (l_i);
         l_i := l_i - 1;
      END LOOP;
   END add_data;
--
BEGIN
--
   FOR i IN 1..pi_array.COUNT
    LOOP
      IF is_failed_command (pi_array(i))
       THEN
         IF l_header_start IS NULL
          THEN
            l_header_start := i+2;
         ELSE
            l_body_start   := i+2;
            EXIT;
         END IF;
      END IF;
   END LOOP;
--
--   nm_debug.debug ('l_header_start =..'||l_header_start||'..');
--
   IF l_header_start IS NOT NULL
    THEN
      add_data (pi_start_pos => l_header_start
               ,po_array     => po_header
               );
   --
      add_data (pi_start_pos => (l_body_start+po_header.COUNT)
               ,po_array     => l_body
               );
   --
      add_data (pi_start_pos => l_body_start
               ,po_array     => po_full
               );
   --
      FOR i IN 1..l_body.COUNT
       LOOP
         EXIT WHEN l_body(i) IS NOT NULL;
         l_body.DELETE(i);
      END LOOP;
   --
      l_i := l_body.FIRST;
      WHILE l_i IS NOT NULL
       LOOP
         po_body(po_body.COUNT+1) := l_body(l_i);
         l_i := l_body.NEXT(l_i);
      END LOOP;
   END IF;
--
END process_pop_output;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_nmpmr (p_nmpm_id NUMBER
                       ,p_text    nm3type.tab_varchar32767
                       ) IS
   l_tab_i nm3type.tab_number;
BEGIN
   FOR i IN 1..p_text.COUNT
    LOOP
      l_tab_i(i) := i;
   END LOOP;
   FORALL i IN 1..p_text.COUNT
      INSERT INTO nm_mail_pop_message_raw
             (nmpmr_nmpm_id
             ,nmpmr_line_number
             ,nmpmr_text
             )
      VALUES (p_nmpm_id
             ,l_tab_i(i)
             ,p_text(i)
             );
END create_nmpmr;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_nmpmd (p_nmpm_id NUMBER
                       ,p_body    nm3type.tab_varchar32767
                       ) IS
   l_tab_i nm3type.tab_number;
BEGIN
   FOR i IN 1..p_body.COUNT
    LOOP
      l_tab_i(i) := i;
   END LOOP;
   FORALL i IN 1..p_body.COUNT
      INSERT INTO nm_mail_pop_message_details
             (nmpmd_nmpm_id
             ,nmpmd_line_number
             ,nmpmd_text
             )
      VALUES (p_nmpm_id
             ,l_tab_i(i)
             ,p_body(i)
             );
END create_nmpmd;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_nmpmh (p_nmpm_id NUMBER
                       ,p_header  nm3type.tab_varchar32767
                       ) IS
--
   l_rec_nmpmh nm_mail_pop_message_headers%ROWTYPE;
--
   FUNCTION colon_before_space (p_text VARCHAR2) RETURN BOOLEAN IS
      l_retval BOOLEAN := FALSE;
      l_colon_pos PLS_INTEGER;
      l_space_pos PLS_INTEGER;
   BEGIN
      l_colon_pos := INSTR(p_text,c_colon);
      l_space_pos := INSTR(p_text,' ');
      IF   l_colon_pos > 0             -- There is a :
       AND (l_colon_pos < l_space_pos  -- and it's before the first space
            OR l_space_pos = 0         --  or there is no space there at all
           )
       THEN
         l_retval := TRUE;
      END IF;
      RETURN l_retval;
   END colon_before_space;
--
   FUNCTION get_header_field (p_text VARCHAR2) RETURN VARCHAR2 IS
      c_text  CONSTANT nm3type.max_varchar2 := UPPER(p_text);
      l_field          nm3type.max_varchar2;
      l_first_colon    PLS_INTEGER;
   BEGIN
      l_first_colon := INSTR(p_text,c_colon);
      FOR i IN 1..g_tab_header_fields.COUNT
       LOOP
         IF nm3flx.left(c_text, (l_first_colon-1)) = g_tab_header_fields(i)
          THEN
            l_field := g_tab_header_fields(i);
            EXIT;
         END IF;
      END LOOP;
      RETURN l_field;
   END get_header_field;
--
   FUNCTION get_header_value (p_index PLS_INTEGER, p_field VARCHAR2) RETURN VARCHAR2 IS
      c_text  CONSTANT nm3type.max_varchar2 := UPPER(p_header(p_index));
      l_value          nm3type.max_varchar2;
   BEGIN
      l_value := SUBSTR(p_header(p_index),(LENGTH(p_field)+3));
      FOR i IN (p_index+1)..p_header.COUNT
       LOOP
         EXIT WHEN colon_before_space (p_header(i));
         l_value := l_value||p_header(i);
      END LOOP;
      RETURN l_value;
   END get_header_value;
--
BEGIN
--
   l_rec_nmpmh.nmpmh_nmpm_id := p_nmpm_id;
--
   FOR i IN 1..p_header.COUNT
    LOOP
      IF p_header(i) IS NOT NULL
       THEN
         IF colon_before_space(p_header(i))
          THEN
            -- there's a : before the first space on the line, so we may be interested
            l_rec_nmpmh.nmpmh_header_field := get_header_field (p_header(i));
            IF l_rec_nmpmh.nmpmh_header_field IS NOT NULL
             THEN
               l_rec_nmpmh.nmpmh_header_value := get_header_value (i,l_rec_nmpmh.nmpmh_header_field);
               ins_nmpmh (l_rec_nmpmh);
            END IF;
         END IF;
      END IF;
   END LOOP;
--
END create_nmpmh;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_all_accounts IS
   l_tab_nmps_id nm3type.tab_number;
BEGIN
--
   nm_debug.proc_start(g_package_name,'process_all_accounts');
   nm_debug.delete_debug(TRUE);
   nm_debug.debug_on;
--
   SELECT nmps_id
    BULK  COLLECT
    INTO  l_tab_nmps_id
    FROM  nm_mail_pop_servers;
--
   FOR i IN 1..l_tab_nmps_id.COUNT
    LOOP
      process_individual_account (pi_nmps_id => l_tab_nmps_id(i));
   END LOOP;
--
   nm_debug.debug_off;
   nm_debug.proc_end(g_package_name,'process_all_accounts');
--
END process_all_accounts;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_individual_account (pi_nmps_id nm_mail_pop_servers.nmps_id%TYPE) IS
--
   l_tab_nmpp tab_nmpp;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'process_all_accounts');
--
   SELECT *
    BULK  COLLECT
    INTO  l_tab_nmpp
    FROM  nm_mail_pop_processes
   WHERE  NVL(nmpp_nmps_id,pi_nmps_id) = pi_nmps_id
   ORDER BY nmpp_process_seq;
--
   FOR i IN 1..l_tab_nmpp.COUNT
    LOOP
      process_rule_by_account (pi_nmps_id, l_tab_nmpp(i));
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'process_all_accounts');
--
END process_individual_account;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_rule_by_account (pi_nmps_id  nm_mail_pop_servers.nmps_id%TYPE
                                  ,pi_rec_nmpp nm_mail_pop_processes%ROWTYPE
                                  ) IS
--
   l_sql       nm3type.tab_varchar32767;
--
   PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      nm3tab_varchar.append (l_sql, p_text, p_nl);
   END append;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'process_rule_by_account');
--
   validate_nmpp_procedure (pi_rec_nmpp.nmpp_procedure);
--
   g_nmpm_nmps_id := pi_nmps_id;
--
   append ('DECLARE',FALSE);
   append ('--');
   append ('   CURSOR cs_rows IS');
   append ('   SELECT *');
   append ('    FROM  nm_mail_pop_messages');
   append ('   WHERE  nmpm_nmps_id = '||g_package_name||'.g_nmpm_nmps_id');
   append ('    AND   nmpm_status  = '||g_package_name||'.c_unprocessed');
--
   SELECT *
    BULK  COLLECT
    INTO  g_tab_nmppc
    FROM  nm_mail_pop_process_conditions
   WHERE  nmppc_nmpp_id = pi_rec_nmpp.nmpp_id
   ORDER BY nmppc_header_field;
--
   FOR i IN 1..g_tab_nmppc.COUNT
    LOOP
      append ('    AND   EXISTS (SELECT 1');
      append ('                   FROM  nm_mail_pop_message_headers');
      append ('                  WHERE  nmpmh_nmpm_id = nmpm_id');
      append ('                   AND   nmpmh_header_field = '||g_package_name||'.g_tab_nmppc('||i||').nmppc_header_field');
      append ('                   AND   nmpmh_header_value = '||g_package_name||'.g_tab_nmppc('||i||').nmppc_header_value');
      append ('                 )');
   END LOOP;
--
   append (';',FALSE);
   FOR i IN 1..g_tab_nmppc.COUNT
    LOOP
      append ('--');
      append ('-- '||g_tab_nmppc(i).nmppc_header_field||' = '||nm3flx.string(nm3flx.repl_quotes_amps_for_dyn_sql(g_tab_nmppc(i).nmppc_header_value)));
   END LOOP;
   append ('--');
   append ('   l_nmpm_id nm_mail_pop_messages.nmpm_id%TYPE;');
   append ('--');
   append ('   PROCEDURE set_status (p_status VARCHAR2) IS');
   append ('      PRAGMA AUTONOMOUS_TRANSACTION;');
   append ('   BEGIN');
   append ('      UPDATE nm_mail_pop_messages');
   append ('       SET   nmpm_status = p_status');
   append ('      WHERE  nmpm_id     = l_nmpm_id;');
   append ('      COMMIT;');
   append ('   END set_status;');
   append ('--');
   append ('   PROCEDURE insert_error (p_error_code NUMBER,p_error_msg VARCHAR2) IS');
   append ('      PRAGMA AUTONOMOUS_TRANSACTION;');
   append ('      l_rec_nmppe nm_mail_pop_processing_errors%ROWTYPE;');
   append ('   BEGIN');
   append ('      l_rec_nmppe.nmppe_nmpm_id       := l_nmpm_id;');
   append ('      l_rec_nmppe.nmppe_sqlerror_code := p_error_code;');
   append ('      l_rec_nmppe.nmppe_sqlerror_msg  := p_error_msg;');
   append ('      '||g_package_name||'.ins_nmppe (l_rec_nmppe);');
   append ('      COMMIT;');
   append ('   END insert_error;');
   append ('--');
   append ('BEGIN');
   append ('--');
   append ('   OPEN  cs_rows;');
   append ('   FETCH cs_rows');
   append ('    BULK COLLECT');
   append ('    INTO '||g_package_name||'.g_tab_nmpm;');
   append ('   CLOSE cs_rows;');
   append ('--');
   append ('   FOR i IN 1..'||g_package_name||'.g_tab_nmpm.COUNT');
   append ('    LOOP');
   append ('      l_nmpm_id := '||g_package_name||'.g_tab_nmpm(i).nmpm_id;');
   append ('      set_status('||g_package_name||'.c_processing);');
   append ('      DECLARE');
   append ('         l_sqlcode NUMBER;');
   append ('         l_sqlerrm nm3type.max_varchar2;');
   append ('      BEGIN');
   append ('         '||pi_rec_nmpp.nmpp_procedure||'(l_nmpm_id);');
   append ('         set_status('||g_package_name||'.c_processed);');
   append ('      EXCEPTION');
   append ('         WHEN others');
   append ('          THEN');
   append ('            l_sqlcode := SQLCODE;');
   append ('            l_sqlerrm := SQLERRM;');
   append ('            set_status('||g_package_name||'.c_error);');
   append ('            insert_error (l_sqlcode,l_sqlerrm);');
   append ('      END;');
   append ('   END LOOP;');
   append ('--');
   append ('END;');
--
   nm3tab_varchar.debug_tab_varchar(l_sql);
   nm3ddl.execute_tab_varchar (l_sql);
--
   nm_debug.proc_end(g_package_name,'process_rule_by_account');
--
END process_rule_by_account;
--
-----------------------------------------------------------------------------
--
PROCEDURE retrieve_all_message_data (pi_nmpm_id   IN     nm_mail_pop_messages.nmpm_id%TYPE
                                    ,po_rec_nmpm     OUT nm_mail_pop_messages%ROWTYPE
                                    ,po_tab_nmpmh    OUT tab_nmpmh
                                    ,po_tab_nmpmd    OUT tab_nmpmd
                                    ,po_tab_nmpmr    OUT tab_nmpmr
                                    ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'retrieve_all_message_data');
--
   nm_debug.debug('retrieving message '||pi_nmpm_id);
--
   po_rec_nmpm := get_nmpm (pi_nmpm_id);
--
   SELECT *
    BULK  COLLECT
    INTO  po_tab_nmpmh
    FROM  nm_mail_pop_message_headers
   WHERE  nmpmh_nmpm_id = pi_nmpm_id
   ORDER BY 2;
--
   SELECT *
    BULK  COLLECT
    INTO  po_tab_nmpmd
    FROM  nm_mail_pop_message_details
   WHERE  nmpmd_nmpm_id = pi_nmpm_id
   ORDER BY 2;
--
   SELECT *
    BULK  COLLECT
    INTO  po_tab_nmpmr
    FROM  nm_mail_pop_message_raw
   WHERE  nmpmr_nmpm_id = pi_nmpm_id
   ORDER BY 2;
--
   nm_debug.proc_end(g_package_name,'retrieve_all_message_data');
--
END retrieve_all_message_data ;
--
-----------------------------------------------------------------------------
--
PROCEDURE submit_retrieve_mail_job (p_every_n_minutes number DEFAULT 5) IS
--
   PRAGMA autonomous_transaction;
--
   CURSOR cs_job (p_what user_jobs.what%TYPE) IS
   SELECT job
    FROM  user_jobs
   WHERE  UPPER(what) = UPPER(p_what);
--
   c_what CONSTANT varchar2(200) :=         'BEGIN'
                                 ||CHR(10)||'   '||g_package_name||'.receive_all_accounts;'
                                 ||CHR(10)||'   '||g_package_name||'.process_all_accounts;'
                                 ||CHR(10)||'END;';
--
   l_existing_job_id user_jobs.job%TYPE;
--
   l_job_id   binary_integer;
--
BEGIN
--
   OPEN  cs_job (c_what);
   FETCH cs_job INTO l_existing_job_id;
   IF cs_job%FOUND
    THEN
      CLOSE cs_job;
      Raise_Application_Error(-20001,'Such a job already exists - JOB_ID : '||l_existing_job_id);
   END IF;
   CLOSE cs_job;
--
   IF NVL(p_every_n_minutes,0) <= 0
    THEN
      Raise_Application_Error(-20001,'p_every_n_minutes passed must have a non null, non zero, positive value');
   END IF;
--
   dbms_job.submit
       (job       => l_job_id
       ,what      => c_what
       ,next_date => SYSDATE
       ,interval  => 'SYSDATE+('||p_every_n_minutes||'/(60*24))'
       );
--
   COMMIT;
--
END submit_retrieve_mail_job;
--
-----------------------------------------------------------------------------
--
BEGIN
   instantiate_data;
END nm3mail_pop;
/
