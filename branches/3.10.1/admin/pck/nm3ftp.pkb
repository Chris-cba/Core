CREATE OR REPLACE PACKAGE BODY nm3ftp
AS
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3ftp.pkb-arc   3.10.1.2   Feb 23 2011 16:56:38   Ade.Edwards  $
--       Module Name      : $Workfile:   nm3ftp.pkb  $
--       Date into PVCS   : $Date:   Feb 23 2011 16:56:38  $
--       Date fetched Out : $Modtime:   Feb 23 2011 16:55:40  $
--       PVCS Version     : $Revision:   3.10.1.2  $
--
--------------------------------------------------------------------------------
--
   g_reply                   t_string_table := t_string_table ();
   g_binary                  BOOLEAN        := TRUE;
   g_debug                   BOOLEAN        := TRUE;
   g_convert_crlf            BOOLEAN        := TRUE;
   g_body_sccsid    CONSTANT VARCHAR2(30)   :='"$Revision:   3.10.1.2  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name   CONSTANT VARCHAR2(30)   := 'nm3ftp';
   g_total_ops               NUMBER         := 6;
--
   g_key                     RAW(32767)     := UTL_RAW.cast_to_raw( 'I9ir9*$3FJ$d92jd"£23j)*£"kjWFSsd' );
   g_pad_chr                 VARCHAR2(1)    := '~';
   g_back_slash              VARCHAR2(1)    := '\';
   g_forward_slash           VARCHAR2(1)    := '/';
--
------------------------------------------------------------------------------
--
  FUNCTION format_with_separator ( pi_input IN VARCHAR2 )
  RETURN VARCHAR2
  IS
  BEGIN
    RETURN (
        CASE 
          WHEN SUBSTR( pi_input
                      , LENGTH(pi_input)
                      , 1) NOT IN (g_back_slash,g_forward_slash)
          THEN pi_input||g_forward_slash
          ELSE pi_input
        END );
  END format_with_separator;
--
------------------------------------------------------------------------------
--
  PROCEDURE padstring (p_text  IN OUT  VARCHAR2) IS
    l_units  NUMBER;
  BEGIN
    IF LENGTH(p_text) MOD 8 > 0 THEN
      l_units := TRUNC(LENGTH(p_text)/8) + 1;
      p_text  := RPAD(p_text, l_units * 8, g_pad_chr);
    END IF;
  END;
--
-----------------------------------------------------------------------------
--
  FUNCTION obfuscate_password ( pi_password IN VARCHAR2 )
  RETURN VARCHAR2
  IS
    l_string      nm3type.max_varchar2 := pi_password;
    retval        RAW(32767);
  BEGIN
  --
    IF pi_password IS NOT NULL
    THEN
    --
      padstring(l_string);
    --
      dbms_obfuscation_toolkit.DESEncrypt
            (  input           => UTL_RAW.cast_to_raw(l_string)
             , key             => g_key
             , encrypted_data  => retval );
    END IF;
  -- 
    RETURN retval;
  --
  END obfuscate_password;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_password ( pi_password_raw IN RAW ) RETURN VARCHAR2
  IS
    l_decrypted  VARCHAR2(32767);
  BEGIN
    IF pi_password_raw IS NOT NULL
    THEN
      dbms_obfuscation_toolkit.desdecrypt(input => pi_password_raw,
                                          key   => g_key,
                                          decrypted_data => l_decrypted);
      RETURN RTRIM(UTL_RAW.cast_to_varchar2(l_decrypted), g_pad_chr);
    ELSE
      RETURN NULL;
    END IF;
  END get_password;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_password ( pi_password IN VARCHAR2 ) RETURN VARCHAR2
  IS
    l_decrypted  VARCHAR2(32767);
  BEGIN
    IF sys_context('NM3SQL','NM3FTPPASSWORD') = 'Y'
    AND pi_password IS NOT NULL
    THEN
      dbms_obfuscation_toolkit.desdecrypt(input => pi_password,
                                          key   => g_key,
                                          decrypted_data => l_decrypted);
      RETURN RTRIM(UTL_RAW.cast_to_varchar2(l_decrypted), g_pad_chr);
    ELSE
      RETURN NULL;
    END IF;
  END get_password;
--
-----------------------------------------------------------------------------
--
--  FUNCTION ret_value ( pi_string IN VARCHAR2 
--                     , pi_code    IN VARCHAR2)
--    RETURN VARCHAR2
--  IS
--  BEGIN
--    RETURN ( CASE WHEN pi_code = '#Password#Return#String#' 
--                   AND pi_string IS NOT NULL
--                    THEN get_password ( pi_password => pi_string )
--                  ELSE NULL 
--             END);
--  END ret_value;
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
   PROCEDURE get_reply (p_conn IN OUT NOCOPY UTL_TCP.connection);
--
--------------------------------------------------------------------------------
--
   PROCEDURE debug (p_text IN VARCHAR2);
--
--------------------------------------------------------------------------------
--
   FUNCTION login (
      p_host      IN   VARCHAR2,
      p_port      IN   VARCHAR2,
      p_user      IN   VARCHAR2,
      p_pass      IN   VARCHAR2,
      p_timeout   IN   NUMBER DEFAULT NULL
   )
      RETURN UTL_TCP.connection
   IS
      l_conn   UTL_TCP.connection;
   BEGIN
      g_reply.DELETE;
      l_conn :=
            UTL_TCP.open_connection (p_host, NVL(p_port,21), tx_timeout => p_timeout);
      get_reply (l_conn);
      send_command (l_conn, 'USER ' || p_user);
      send_command (l_conn, 'PASS ' || p_pass);
      RETURN l_conn;
   END;
--
--------------------------------------------------------------------------------
--
--
--------------------------------------------------------------------------------
--
   FUNCTION get_passive (p_conn IN OUT NOCOPY UTL_TCP.connection)
      RETURN UTL_TCP.connection
   IS
      l_conn    UTL_TCP.connection;
      l_reply   VARCHAR2 (32767);
      l_host    VARCHAR (100);
      l_port1   NUMBER (10);
      l_port2   NUMBER (10);
   BEGIN
      send_command (p_conn, 'PASV');
      l_reply := g_reply (g_reply.LAST);
      l_reply :=
         REPLACE (SUBSTR (l_reply,
                          INSTR (l_reply, '(') + 1,
                          (INSTR (l_reply, ')')) - (INSTR (l_reply, '(')) - 1
                         ),
                  ',',
                  '.'
                 );
      l_host := SUBSTR (l_reply, 1, INSTR (l_reply, '.', 1, 4) - 1);
      l_port1 :=
         TO_NUMBER (SUBSTR (l_reply,
                            INSTR (l_reply, '.', 1, 4) + 1,
                              (INSTR (l_reply, '.', 1, 5) - 1
                              )
                            - (INSTR (l_reply, '.', 1, 4))
                           )
                   );
      l_port2 := TO_NUMBER (SUBSTR (l_reply, INSTR (l_reply, '.', 1, 5) + 1));
      l_conn := UTL_TCP.open_connection (l_host, 256 * l_port1 + l_port2);
      RETURN l_conn;
   END;
--
--------------------------------------------------------------------------------
--
   PROCEDURE logout (
      p_conn    IN OUT NOCOPY   UTL_TCP.connection,
      p_reply   IN              BOOLEAN := TRUE
   )
   AS
   BEGIN
      send_command (p_conn, 'QUIT', p_reply);
      utl_tcp.close_connection(p_conn);
   END;
--
--------------------------------------------------------------------------------
--
   PROCEDURE send_command (
      p_conn      IN OUT NOCOPY   UTL_TCP.connection,
      p_command   IN              VARCHAR2,
      p_reply     IN              BOOLEAN := TRUE
   )
   IS
      l_result   PLS_INTEGER;
   BEGIN
      l_result := UTL_TCP.write_line (p_conn, p_command);

      -- If you get ORA-29260 after the PASV call, replace the above line with the following line.
      -- l_result := UTL_TCP.write_text(p_conn, p_command || utl_tcp.crlf, length(p_command || utl_tcp.crlf));
      IF p_reply
      THEN
         get_reply (p_conn);
      END IF;
   END;
--
--------------------------------------------------------------------------------
--
   PROCEDURE get_reply (p_conn IN OUT NOCOPY UTL_TCP.connection)
   IS
      l_reply_code   VARCHAR2 (3) := NULL;
   BEGIN
      LOOP
         g_reply.EXTEND;
         g_reply (g_reply.LAST) := UTL_TCP.get_line (p_conn, TRUE);
         DEBUG (g_reply (g_reply.LAST));

         IF l_reply_code IS NULL
         THEN
            l_reply_code := SUBSTR (g_reply (g_reply.LAST), 1, 3);
         END IF;

         IF SUBSTR (l_reply_code, 1, 1) = '5'
         THEN
            raise_application_error (-20000, g_reply (g_reply.LAST));
         ELSIF (    SUBSTR (g_reply (g_reply.LAST), 1, 3) = l_reply_code
                AND SUBSTR (g_reply (g_reply.LAST), 4, 1) = ' '
               )
         THEN
            EXIT;
         END IF;
      END LOOP;
   EXCEPTION
      WHEN UTL_TCP.end_of_input
      THEN
         NULL;
   END;
--
--------------------------------------------------------------------------------
--
   FUNCTION get_local_ascii_data (p_dir IN VARCHAR2, p_file IN VARCHAR2)
      RETURN CLOB
   IS
      l_bfile   BFILE;
      l_data    CLOB;
   BEGIN
      DBMS_LOB.createtemporary (lob_loc      => l_data,
                                CACHE        => TRUE,
                                dur          => DBMS_LOB.CALL
                               );
      l_bfile := BFILENAME (p_dir, p_file);
      DBMS_LOB.fileopen (l_bfile, DBMS_LOB.file_readonly);
      DBMS_LOB.loadfromfile (l_data, l_bfile, DBMS_LOB.getlength (l_bfile));
      DBMS_LOB.fileclose (l_bfile);
      RETURN l_data;
   END;
--
--------------------------------------------------------------------------------
--
   FUNCTION get_local_binary_data (p_dir IN VARCHAR2, p_file IN VARCHAR2)
      RETURN BLOB
   IS
      l_bfile   BFILE;
      l_data    BLOB;
   BEGIN
      DBMS_LOB.createtemporary (lob_loc      => l_data,
                                CACHE        => TRUE,
                                dur          => DBMS_LOB.CALL
                               );
      l_bfile := BFILENAME (p_dir, p_file);
      DBMS_LOB.fileopen (l_bfile, DBMS_LOB.file_readonly);
      DBMS_LOB.loadfromfile (l_data, l_bfile, DBMS_LOB.getlength (l_bfile));
      DBMS_LOB.fileclose (l_bfile);
      RETURN l_data;
   END;
--
--------------------------------------------------------------------------------
--
   FUNCTION get_remote_ascii_data (
      p_conn   IN OUT NOCOPY   UTL_TCP.connection,
      p_file   IN              VARCHAR2
   )
      RETURN CLOB
   IS
      l_conn     UTL_TCP.connection;
      l_amount   PLS_INTEGER;
      l_buffer   VARCHAR2 (32767);
      l_data     CLOB;
   BEGIN
      DBMS_LOB.createtemporary (lob_loc      => l_data,
                                CACHE        => TRUE,
                                dur          => DBMS_LOB.CALL
                               );
      l_conn := get_passive (p_conn);
      send_command (p_conn, 'RETR ' || p_file, TRUE);
      LOGOUT (l_conn, FALSE);

      BEGIN
         LOOP
            l_amount := UTL_TCP.read_text (l_conn, l_buffer, 32767);
            DBMS_LOB.writeappend (l_data, l_amount, l_buffer);
         END LOOP;
      EXCEPTION
         WHEN UTL_TCP.end_of_input
         THEN
            NULL;
         WHEN OTHERS
         THEN
            NULL;
      END;

      get_reply (p_conn);
      UTL_TCP.close_connection (l_conn);
      RETURN l_data;
   END;
--
--------------------------------------------------------------------------------
--
   FUNCTION get_remote_binary_data (
      p_conn   IN OUT NOCOPY   UTL_TCP.connection,
      p_file   IN              VARCHAR2
   )
      RETURN BLOB
   IS
      l_conn     UTL_TCP.connection;
      l_amount   PLS_INTEGER;
      l_buffer   RAW (32767);
      l_data     BLOB;
   BEGIN
      DBMS_LOB.createtemporary (lob_loc      => l_data,
                                CACHE        => TRUE,
                                dur          => DBMS_LOB.CALL
                               );
      l_conn := get_passive (p_conn);
      send_command (p_conn, 'RETR ' || p_file, TRUE);

      BEGIN
         LOOP
            l_amount := UTL_TCP.read_raw (l_conn, l_buffer, 32767);
            DBMS_LOB.writeappend (l_data, l_amount, l_buffer);
         END LOOP;
      EXCEPTION
         WHEN UTL_TCP.end_of_input
         THEN
            NULL;
         WHEN OTHERS
         THEN
            NULL;
      END;

      get_reply (p_conn);
      UTL_TCP.close_connection (l_conn);
      RETURN l_data;
   END;
--
--------------------------------------------------------------------------------
--
   PROCEDURE put_local_ascii_data (
      p_data   IN   CLOB,
      p_dir    IN   VARCHAR2,
      p_file   IN   VARCHAR2
   )
   IS
      l_out_file   UTL_FILE.file_type;
      l_buffer     VARCHAR2 (32767);
      l_amount     BINARY_INTEGER     := 32767;
      l_pos        INTEGER            := 1;
      l_clob_len   INTEGER;
   BEGIN
      l_clob_len := DBMS_LOB.getlength (p_data);
      l_out_file := UTL_FILE.fopen (p_dir, p_file, 'w', 32767);

      WHILE l_pos <= l_clob_len
      LOOP
         DBMS_LOB.READ (p_data, l_amount, l_pos, l_buffer);

         IF g_convert_crlf
         THEN
            l_buffer := REPLACE (l_buffer, CHR (13), NULL);
         END IF;

         UTL_FILE.put (l_out_file, l_buffer);
         UTL_FILE.fflush (l_out_file);
         l_pos := l_pos + l_amount;
      END LOOP;

      UTL_FILE.fclose (l_out_file);
   EXCEPTION
      WHEN OTHERS
      THEN
         IF UTL_FILE.is_open (l_out_file)
         THEN
            UTL_FILE.fclose (l_out_file);
         END IF;

         RAISE;
   END;
--
--------------------------------------------------------------------------------
--
   PROCEDURE put_local_binary_data (
      p_data   IN   BLOB,
      p_dir    IN   VARCHAR2,
      p_file   IN   VARCHAR2
   )
   IS
      l_out_file   UTL_FILE.file_type;
      l_buffer     RAW (32767);
      l_amount     BINARY_INTEGER     := 32767;
      l_pos        INTEGER            := 1;
      l_blob_len   INTEGER;
   BEGIN
      l_blob_len := DBMS_LOB.getlength (p_data);
      l_out_file := UTL_FILE.fopen (p_dir, p_file, 'wb', 32767);

      WHILE l_pos <= l_blob_len
      LOOP
         DBMS_LOB.READ (p_data, l_amount, l_pos, l_buffer);
         UTL_FILE.put_raw (l_out_file, l_buffer, TRUE);
         UTL_FILE.fflush (l_out_file);
         l_pos := l_pos + l_amount;
      END LOOP;

      UTL_FILE.fclose (l_out_file);
   EXCEPTION
      WHEN OTHERS
      THEN
         IF UTL_FILE.is_open (l_out_file)
         THEN
            UTL_FILE.fclose (l_out_file);
         END IF;

         RAISE;
   END;
--
--------------------------------------------------------------------------------
--
   PROCEDURE put_remote_ascii_data (
      p_conn   IN OUT NOCOPY   UTL_TCP.connection,
      p_file   IN              VARCHAR2,
      p_data   IN              CLOB
   )
   IS
      l_conn       UTL_TCP.connection;
      l_result     PLS_INTEGER;
      l_buffer     VARCHAR2 (32767);
      l_amount     BINARY_INTEGER     := 32767;
      l_pos        INTEGER            := 1;
      l_clob_len   INTEGER;
   BEGIN
      l_conn := get_passive (p_conn);
      send_command (p_conn, 'STOR ' || p_file, TRUE);
      l_clob_len := DBMS_LOB.getlength (p_data);

      WHILE l_pos <= l_clob_len
      LOOP
         DBMS_LOB.READ (p_data, l_amount, l_pos, l_buffer);

         IF g_convert_crlf
         THEN
            l_buffer := REPLACE (l_buffer, CHR (13), NULL);
         END IF;

         l_result := UTL_TCP.write_text (l_conn, l_buffer, LENGTH (l_buffer));
         UTL_TCP.FLUSH (l_conn);
         l_pos := l_pos + l_amount;
      END LOOP;

      UTL_TCP.close_connection (l_conn);
   END;
--
--------------------------------------------------------------------------------
--
   PROCEDURE put_remote_binary_data (
      p_conn   IN OUT NOCOPY   UTL_TCP.connection,
      p_file   IN              VARCHAR2,
      p_data   IN              BLOB
   )
   IS
      l_conn       UTL_TCP.connection;
      l_result     PLS_INTEGER;
      l_buffer     RAW (32767);
      l_amount     BINARY_INTEGER     := 32767;
      l_pos        INTEGER            := 1;
      l_blob_len   INTEGER;
   BEGIN
      l_conn := get_passive (p_conn);
      send_command (p_conn, 'STOR ' || p_file, TRUE);
      l_blob_len := DBMS_LOB.getlength (p_data);

      WHILE l_pos <= l_blob_len
      LOOP
         DBMS_LOB.READ (p_data, l_amount, l_pos, l_buffer);
         l_result := UTL_TCP.write_raw (l_conn, l_buffer, l_amount);
         UTL_TCP.FLUSH (l_conn);
         l_pos := l_pos + l_amount;
      END LOOP;

      UTL_TCP.close_connection (l_conn);
   END;
--
--------------------------------------------------------------------------------
--
   PROCEDURE get (
      p_conn        IN OUT NOCOPY   UTL_TCP.connection,
      p_from_file   IN              VARCHAR2,
      p_to_dir      IN              VARCHAR2,
      p_to_file     IN              VARCHAR2
   )
   AS
   BEGIN
      IF g_binary
      THEN
         put_local_binary_data
                              (p_data      => get_remote_binary_data
                                                                  (p_conn,
                                                                   p_from_file
                                                                  ),
                               p_dir       => p_to_dir,
                               p_file      => p_to_file
                              );
      ELSE
         put_local_ascii_data (p_data      => get_remote_ascii_data
                                                                  (p_conn,
                                                                   p_from_file
                                                                  ),
                               p_dir       => p_to_dir,
                               p_file      => p_to_file
                              );
      END IF;
   END;
--
--------------------------------------------------------------------------------
--
   PROCEDURE put (
      p_conn        IN OUT NOCOPY   UTL_TCP.connection,
      p_from_dir    IN              VARCHAR2,
      p_from_file   IN              VARCHAR2,
      p_to_file     IN              VARCHAR2
   )
   AS
   BEGIN
      IF g_binary
      THEN
         put_remote_binary_data (p_conn      => p_conn,
                                 p_file      => p_to_file,
                                 p_data      => get_local_binary_data
                                                                  (p_from_dir,
                                                                   p_from_file
                                                                  )
                                );
      ELSE
         put_remote_ascii_data (p_conn      => p_conn,
                                p_file      => p_to_file,
                                p_data      => get_local_ascii_data
                                                                  (p_from_dir,
                                                                   p_from_file
                                                                  )
                               );
      END IF;

      get_reply (p_conn);
   END;
--
--------------------------------------------------------------------------------
--
   PROCEDURE get_direct (
      p_conn        IN OUT NOCOPY   UTL_TCP.connection,
      p_from_file   IN              VARCHAR2,
      p_to_dir      IN              VARCHAR2,
      p_to_file     IN              VARCHAR2
   )
   IS
      l_conn         UTL_TCP.connection;
      l_out_file     UTL_FILE.file_type;
      l_amount       PLS_INTEGER;
      l_buffer       VARCHAR2 (32767);
      l_raw_buffer   RAW (32767);
   BEGIN
      l_conn := get_passive (p_conn);
      send_command (p_conn, 'RETR ' || p_from_file, TRUE);

      IF g_binary
      THEN
         l_out_file := UTL_FILE.fopen (p_to_dir, p_to_file, 'wb', 32767);
      ELSE
         l_out_file := UTL_FILE.fopen (p_to_dir, p_to_file, 'w', 32767);
      END IF;

      BEGIN
         LOOP
            IF g_binary
            THEN
               l_amount := UTL_TCP.read_raw (l_conn, l_raw_buffer, 32767);
               UTL_FILE.put_raw (l_out_file, l_raw_buffer, TRUE);
            ELSE
               l_amount := UTL_TCP.read_text (l_conn, l_buffer, 32767);

               IF g_convert_crlf
               THEN
                  l_buffer := REPLACE (l_buffer, CHR (13), NULL);
               END IF;

               UTL_FILE.put (l_out_file, l_buffer);
            END IF;

            UTL_FILE.fflush (l_out_file);
         END LOOP;
      EXCEPTION
         WHEN UTL_TCP.end_of_input
         THEN
            NULL;
         WHEN OTHERS
         THEN
            NULL;
      END;

      UTL_FILE.fclose (l_out_file);
      UTL_TCP.close_connection (l_conn);
   EXCEPTION
      WHEN OTHERS
      THEN
         IF UTL_FILE.is_open (l_out_file)
         THEN
            UTL_FILE.fclose (l_out_file);
         END IF;

         RAISE;
   END;
--
--------------------------------------------------------------------------------
--
   PROCEDURE put_direct (
      p_conn        IN OUT NOCOPY   UTL_TCP.connection,
      p_from_dir    IN              VARCHAR2,
      p_from_file   IN              VARCHAR2,
      p_to_file     IN              VARCHAR2
   )
   IS
      l_conn         UTL_TCP.connection;
      l_bfile        BFILE;
      l_result       PLS_INTEGER;
      l_amount       PLS_INTEGER        := 32767;
      l_raw_buffer   RAW (32767);
      l_len          NUMBER;
      l_pos          NUMBER             := 1;
      ex_ascii       EXCEPTION;
   BEGIN
      IF NOT g_binary
      THEN
         RAISE ex_ascii;
      END IF;

      l_conn := get_passive (p_conn);
      send_command (p_conn, 'STOR ' || p_to_file, TRUE);
      l_bfile := BFILENAME (p_from_dir, p_from_file);
      DBMS_LOB.fileopen (l_bfile, DBMS_LOB.file_readonly);
      l_len := DBMS_LOB.getlength (l_bfile);

      WHILE l_pos <= l_len
      LOOP
         DBMS_LOB.READ (l_bfile, l_amount, l_pos, l_raw_buffer);
         DEBUG (l_amount);
         l_result := UTL_TCP.write_raw (l_conn, l_raw_buffer, l_amount);
         l_pos := l_pos + l_amount;
      END LOOP;

      DBMS_LOB.fileclose (l_bfile);
      UTL_TCP.close_connection (l_conn);
   EXCEPTION
      WHEN ex_ascii
      THEN
         raise_application_error (-20000,
                                  'PUT_DIRECT not available in ASCII mode.'
                                 );
      WHEN OTHERS
      THEN
         IF DBMS_LOB.fileisopen (l_bfile) = 1
         THEN
            DBMS_LOB.fileclose (l_bfile);
         END IF;

         RAISE;
   END;
--
--------------------------------------------------------------------------------
--
   PROCEDURE help (p_conn IN OUT NOCOPY UTL_TCP.connection)
   AS
   BEGIN
      send_command (p_conn, 'HELP', TRUE);
   END;
--
--------------------------------------------------------------------------------
--
   PROCEDURE ascii (p_conn IN OUT NOCOPY UTL_TCP.connection)
   AS
   BEGIN
      send_command (p_conn, 'TYPE A', TRUE);
      g_binary := FALSE;
   END;
--
--------------------------------------------------------------------------------
--
   PROCEDURE binary (p_conn IN OUT NOCOPY UTL_TCP.connection)
   AS
   BEGIN
      send_command (p_conn, 'TYPE I', TRUE);
      g_binary := TRUE;
   END;
--
--------------------------------------------------------------------------------
--
   PROCEDURE list (
      p_conn    IN OUT NOCOPY   UTL_TCP.connection,
      p_dir     IN              VARCHAR2,
      p_list    OUT             t_string_table,
      p_command IN VARCHAR2 DEFAULT NULL 
   )
   AS
      l_conn         UTL_TCP.connection;
      l_list         t_string_table     := t_string_table ();
      l_reply_code   VARCHAR2 (3)       := NULL;
      l_command      VARCHAR2(500)      := NVL(p_command, 'LIST');
   BEGIN
      l_conn := get_passive (p_conn);
--      send_command (p_conn, 'NLST ' || p_dir, TRUE);
      --send_command (p_conn, 'MLSD ' || p_dir, TRUE);
      --send_command (p_conn, 'MLSD', TRUE);
  
      send_command (p_conn, l_command ||' '|| p_dir, TRUE);
      --send_command (p_conn, 'LIST /aims/amp/in', TRUE);

      BEGIN
         LOOP
            l_list.EXTEND;
            l_list (l_list.LAST) := UTL_TCP.get_line (l_conn, TRUE);
            DEBUG (l_list (l_list.LAST));

            IF l_reply_code IS NULL
            THEN
               l_reply_code := SUBSTR (l_list (l_list.LAST), 1, 3);
            END IF;

            IF SUBSTR (l_reply_code, 1, 1) = '5'
            THEN
               raise_application_error (-20000, l_list (l_list.LAST));
            ELSIF (    SUBSTR (g_reply (g_reply.LAST), 1, 3) = l_reply_code
                   AND SUBSTR (g_reply (g_reply.LAST), 4, 1) = ' '
                  )
            THEN
               EXIT;
            END IF;
         END LOOP;
      EXCEPTION
         WHEN UTL_TCP.end_of_input
         THEN
            NULL;
      END;

      l_list.DELETE (l_list.LAST);
      p_list := l_list;
      UTL_TCP.close_connection (l_conn);
      get_reply (p_conn);
   END LIST;
--
--------------------------------------------------------------------------------
--
   PROCEDURE rename (
      p_conn               IN OUT NOCOPY   UTL_TCP.connection,
      p_from               IN              VARCHAR2,
      p_to                 IN              VARCHAR2,
      p_archive_overwrite  IN              BOOLEAN DEFAULT FALSE,
      p_remove_failed_arch IN              BOOLEAN DEFAULT FALSE
      )
   AS
      l_conn   UTL_TCP.connection;
   BEGIN
      l_conn := get_passive (p_conn);
      IF p_archive_overwrite THEN
      -- remove archive file
        BEGIN
          send_command(p_conn, 'DELE ' || p_to, TRUE);
        EXCEPTION
        WHEN OTHERS THEN
         NULL;
        END;
      END IF;
      --
      send_command (p_conn, 'RNFR ' || p_from, TRUE);
      send_command (p_conn, 'RNTO ' || p_to, TRUE);
      LOGOUT (l_conn, FALSE);
  -- This exception removes a failed file from the in 
  -- folder if the parameter is set.
   EXCEPTION
      WHEN OTHERS THEN
      IF p_remove_failed_arch THEN
          send_command(p_conn, 'DELE ' || p_from, TRUE);
          LOGOUT (l_conn, FALSE);
      ELSE
          LOGOUT (l_conn, FALSE);
      END IF;
   END RENAME;
--
--------------------------------------------------------------------------------
--
   PROCEDURE delete (
      p_conn   IN OUT NOCOPY   UTL_TCP.connection,
      p_file   IN              VARCHAR2
   )
   AS
      l_conn   UTL_TCP.connection;
   BEGIN
      l_conn := get_passive (p_conn);
      send_command (p_conn, 'DELE ' || p_file, TRUE);
      LOGOUT (l_conn, FALSE);
   END DELETE;
--
--------------------------------------------------------------------------------
--
   PROCEDURE mkdir (p_conn IN OUT NOCOPY UTL_TCP.connection, p_dir IN VARCHAR2)
   AS
      l_conn   UTL_TCP.connection;
   BEGIN
      l_conn := get_passive (p_conn);
      send_command (p_conn, 'MKD ' || p_dir, TRUE);
      LOGOUT (l_conn, FALSE);
   END mkdir;
--
--------------------------------------------------------------------------------
--
   PROCEDURE rmdir (p_conn IN OUT NOCOPY UTL_TCP.connection, p_dir IN VARCHAR2)
   AS
      l_conn   UTL_TCP.connection;
   BEGIN
      l_conn := get_passive (p_conn);
      send_command (p_conn, 'RMD ' || p_dir, TRUE);
      LOGOUT (l_conn, FALSE);
   END rmdir;
--
--------------------------------------------------------------------------------
--
   PROCEDURE convert_crlf (p_status IN BOOLEAN)
   AS
   BEGIN
      g_convert_crlf := p_status;
   END;
--
--------------------------------------------------------------------------------
--
   PROCEDURE debug (p_text IN VARCHAR2)
   IS
   BEGIN
      IF g_debug
      THEN
         DBMS_OUTPUT.put_line (SUBSTR (p_text, 1, 255));
      END IF;
   END;
--
--------------------------------------------------------------------------------
--
  FUNCTION convert_to_results_tab ( pi_char_array IN dbms_output.chararr )
  RETURN tab_results
  IS
    retval tab_results;
    l_ind  PLS_INTEGER;
  BEGIN
  --nm_debug.debug_on;
  --nm_debug.debug('pi_char_array has '||pi_char_array.COUNT||' lines');
    IF pi_char_array.COUNT > 0
    THEN
      FOR i IN 1..pi_char_array.COUNT LOOP
        IF pi_char_array(i) IS NOT NULL
        THEN
          l_ind := retval.COUNT+1;
          retval(l_ind).l_result_line := pi_char_array(i);
        END IF;
      END LOOP;
    END IF;
    RETURN retval;
  END convert_to_results_tab;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_hft ( pi_hft_id          IN hig_ftp_types.hft_id%TYPE 
                   , pi_raise_not_found IN BOOLEAN DEFAULT TRUE )
  RETURN hig_ftp_types%ROWTYPE
  IS
    retval hig_ftp_types%ROWTYPE;
  BEGIN
    SELECT * INTO retval
      FROM hig_ftp_types
     WHERE hft_id = pi_hft_id;
    RETURN retval; 
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
      IF pi_raise_not_found 
      THEN 
        raise_application_error(-20001,'Cannot find HIG_FTP_TYPES record for ['||pi_hft_id||']');
      ELSE
        RETURN retval;
      END IF;
  END get_hft;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_hft ( pi_hft_type        IN hig_ftp_types.hft_type%TYPE 
                   , pi_raise_not_found IN BOOLEAN DEFAULT TRUE )
  RETURN hig_ftp_types%ROWTYPE
  IS
    retval hig_ftp_types%ROWTYPE;
  BEGIN
    SELECT * INTO retval
      FROM hig_ftp_types
     WHERE hft_type = pi_hft_type;
    RETURN retval; 
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
      IF pi_raise_not_found 
      THEN 
        raise_application_error(-20001,'Cannot find HIG_FTP_TYPES record for ['||pi_hft_type||']');
      ELSE
        RETURN retval;
      END IF;
  END get_hft;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_hfc ( pi_hfc_id          IN hig_ftp_connections.hfc_id%TYPE 
                   , pi_raise_not_found IN BOOLEAN DEFAULT TRUE )
  RETURN hig_ftp_connections%ROWTYPE
  IS
    retval hig_ftp_connections%ROWTYPE;
  BEGIN
    SELECT * INTO retval
      FROM hig_ftp_connections
     WHERE hfc_id = pi_hfc_id;
    RETURN retval; 
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
      IF pi_raise_not_found 
      THEN 
        raise_application_error(-20001,'Cannot find HIG_FTP_CONNECTIONS record for ['||pi_hfc_id||']');
      ELSE 
        RETURN retval;
      END IF;
  END get_hfc;
--
--------------------------------------------------------------------------------
--
  PROCEDURE test_connection 
                 ( pi_hfc_id    IN     hig_ftp_connections.hfc_id%TYPE
                 , pio_results  IN OUT tab_results )
  IS
    l_conn         utl_tcp.connection;
    l_char_array   dbms_output.chararr;
    l_num_lines    INTEGER := 1000000;
    l_rec_hfc      hig_ftp_connections%ROWTYPE;
    l_password     nm3type.max_varchar2;
    l_in_dir_list  t_string_table;
    l_out_dir_list t_string_table;
    PROCEDURE put_sep IS 
    BEGIN
      dbms_output.put_line (' ================================================'
                          ||'===================================================');
    END put_sep;
  BEGIN
  --
    SELECT * INTO l_rec_hfc
      FROM hig_ftp_connections
     WHERE hfc_id = pi_hfc_id;
  --
    dbms_output.enable(1000000);
  --
    put_sep;
    dbms_output.put_line (' === Testing FTP Connection ['||l_rec_hfc.hfc_name||']');
    put_sep;
  --
    IF l_rec_hfc.hfc_ftp_password IS NOT NULL
    THEN
      l_password := get_password(pi_password_raw => l_rec_hfc.hfc_ftp_password);
    END IF;
  --
  -- Test connection
  --
--    nm_debug.debug_on;
--    nm_debug.debug('Decrypted - '||l_password);
--    nm_debug.debug('Encryted - '||l_rec_hfc.hfc_ftp_password);
    l_conn := nm3ftp.login(l_rec_hfc.hfc_ftp_host
                           ,NVL(l_rec_hfc.hfc_ftp_port,21)
                           ,l_rec_hfc.hfc_ftp_username
                           ,l_password);
  --
    put_sep;
    dbms_output.put_line (' === Testing FTP Connection - Connection ['||l_rec_hfc.hfc_name||'] is valid');
    put_sep;
  --
  -- See if directories are accessable
  --

  --
    IF l_rec_hfc.hfc_ftp_in_dir IS NOT NULL
    THEN
    --
      put_sep;
      dbms_output.put_line (' === Testing FTP Connection - Connection ['||l_rec_hfc.hfc_name||'] - Check IN Directory');
      put_sep;
    --
      --send_command(p_conn => l_conn, p_command => 'LIST '||l_rec_hfc.hfc_ftp_in_dir);
      list ( p_conn   => l_conn,
             p_dir    => l_rec_hfc.hfc_ftp_in_dir,
             p_list   => l_in_dir_list );
    --
    END IF;
  --
    IF l_rec_hfc.hfc_ftp_out_dir IS NOT NULL
    THEN
    --
      put_sep;
      dbms_output.put_line (' === Testing FTP Connection - Connection ['||l_rec_hfc.hfc_name||'] - Check OUT Directory');
      put_sep;
    --
      list ( p_conn   => l_conn,
             p_dir    => l_rec_hfc.hfc_ftp_out_dir,
             p_list   => l_in_dir_list );
    --
    END IF;
  --
    DECLARE
      l_arc_host       nm3type.max_varchar2 := NVL(l_rec_hfc.hfc_ftp_arc_host,l_rec_hfc.hfc_ftp_host);
      l_arc_port       nm3type.max_varchar2 := NVL(NVL(l_rec_hfc.hfc_ftp_arc_port,l_rec_hfc.hfc_ftp_port),21);
      l_arc_username   nm3type.max_varchar2 := NVL(l_rec_hfc.hfc_ftp_arc_username,l_rec_hfc.hfc_ftp_username);
      l_arc_password   nm3type.max_varchar2 := NVL(l_rec_hfc.hfc_ftp_arc_password,l_rec_hfc.hfc_ftp_password);
      l_arc_in_folder  nm3type.max_varchar2 := l_rec_hfc.hfc_ftp_arc_in_dir;
      l_arc_out_folder nm3type.max_varchar2 := l_rec_hfc.hfc_ftp_arc_out_dir;
    BEGIN
    --
      IF l_arc_in_folder IS NOT NULL
      THEN
      --
        nm3ftp.logout(p_conn => l_conn);
      --
        put_sep;
        dbms_output.put_line (' === Testing FTP Connection - Connection ['||l_rec_hfc.hfc_name||'] - Check Archive IN Directory');
        put_sep;
        l_conn := nm3ftp.login( p_host => l_arc_host
                              , p_port => l_arc_port
                              , p_user => l_arc_username
                              , p_pass => get_password ( pi_password_raw => l_arc_password) );
      --
        list ( p_conn   => l_conn,
               p_dir    => l_arc_in_folder,
               p_list   => l_in_dir_list );
      --
      END IF;
    --
      IF l_arc_out_folder IS NOT NULL
      THEN
      --
        nm3ftp.logout(p_conn => l_conn);
      --
        put_sep;
        dbms_output.put_line (' === Testing FTP Connection - Connection ['||l_rec_hfc.hfc_name||'] - Check Archive OUT Directory');
        put_sep;
      --
        dbms_output.put_line ('Connect as '||l_arc_host||':'||l_arc_port||' - '||l_arc_username||'@'||get_password ( pi_password_raw => l_arc_password));
        l_conn := nm3ftp.login( p_host => l_arc_host
                              , p_port => l_arc_port
                              , p_user => l_arc_username
                              , p_pass => get_password ( pi_password_raw => l_arc_password) );
      --
        list ( p_conn   => l_conn,
               p_dir    => l_arc_out_folder,
               p_list   => l_in_dir_list );
      --
      END IF;
    --
    END;
  --
    put_sep;
    dbms_output.put_line (' === Testing FTP Connection - Connection ['||l_rec_hfc.hfc_name||'] - Completed Successfully ');
    put_sep;
  --
    utl_tcp.close_all_connections;
  --
    dbms_output.get_lines(l_char_array,l_num_lines);
  --
    pio_results := convert_to_results_tab (l_char_array);
  --
  EXCEPTION
    WHEN OTHERS 
      THEN
    --
      put_sep;
      dbms_output.put_line (' === Testing FTP Connection - Connection ['||l_rec_hfc.hfc_name||'] - Completed with Errors : ');
      put_sep;
    --
      utl_tcp.close_all_connections;

    --
      dbms_output.get_lines(l_char_array,l_num_lines);
    --
      pio_results := convert_to_results_tab (l_char_array);
    --
      pio_results(pio_results.COUNT+1).l_result_line := SQLERRM;
    --
  END test_connection;
--
--------------------------------------------------------------------------------
--
  FUNCTION test_connection 
                 ( pi_hfc_id    IN     hig_ftp_connections.hfc_id%TYPE )
  RETURN BOOLEAN
  IS
  --
    l_conn         utl_tcp.connection;
    l_char_array   dbms_output.chararr;
    l_num_lines    INTEGER := 100;
    l_rec_hfc      hig_ftp_connections%ROWTYPE;
    l_password     nm3type.max_varchar2;
    l_in_dir_list  t_string_table;
    l_out_dir_list t_string_table;
  --
  BEGIN
  --
    SELECT * INTO l_rec_hfc
      FROM hig_ftp_connections
     WHERE hfc_id = pi_hfc_id;
  --
    IF l_rec_hfc.hfc_ftp_password IS NOT NULL
    THEN
      l_password := get_password(pi_password_raw => l_rec_hfc.hfc_ftp_password);
    END IF;
  --
    l_conn := nm3ftp.login(l_rec_hfc.hfc_ftp_host
                           ,NVL(l_rec_hfc.hfc_ftp_port,21)
                           ,l_rec_hfc.hfc_ftp_username
                           ,l_password);
  --
    utl_tcp.close_all_connections;
  --
    RETURN TRUE;
  --
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
      RAISE_APPLICATION_ERROR (-20101,'Invalid FTP connection ID ['||pi_hfc_id||']');
  --
    WHEN OTHERS
    THEN
    --
      utl_tcp.close_all_connections;
    --
      RETURN FALSE;
    --
  END test_connection;
--
--------------------------------------------------------------------------------
--
  FUNCTION list_all_files_coming_in
              ( pi_hfc_id    IN     hig_ftp_connections.hfc_id%TYPE )
    RETURN nm3type.tab_varchar32767
  IS
    retval         nm3type.tab_varchar32767;
    l_rec_hfc      hig_ftp_connections%ROWTYPE;
    l_password     hig_ftp_connections.hfc_ftp_password%TYPE;
    l_conn         utl_tcp.connection;
    l_in_dir_list  t_string_table;
  BEGIN
  --
    l_rec_hfc := get_hfc ( pi_hfc_id => pi_hfc_id );
  --
    IF l_rec_hfc.hfc_ftp_password IS NOT NULL
    THEN
      l_password := get_password(pi_password_raw => l_rec_hfc.hfc_ftp_password);
    END IF;
  --
    l_conn := nm3ftp.login(l_rec_hfc.hfc_ftp_host
                          ,NVL(l_rec_hfc.hfc_ftp_port,21)
                          ,l_rec_hfc.hfc_ftp_username
                          ,l_password);
  --
    IF l_rec_hfc.hfc_ftp_in_dir IS NOT NULL
    THEN
    --
      --send_command(p_conn => l_conn, p_command => 'LIST '||l_rec_hfc.hfc_ftp_in_dir);
      list ( p_conn    => l_conn,
             p_dir     => l_rec_hfc.hfc_ftp_in_dir,
             p_list    => l_in_dir_list,
             p_command => 'NLST' );
    --
      FOR in_files IN 1..l_in_dir_list.COUNT LOOP
      --
        retval(in_files) := l_in_dir_list(in_files); 
      --
      END LOOP;
    --
    END IF;
  --
    utl_tcp.close_all_connections;
  --
    RETURN retval;
  --
  EXCEPTION
  WHEN OTHERS
  THEN 
  -- If there is an error return the empty value
  RETURN retval;
  END list_all_files_coming_in;
--
--------------------------------------------------------------------------------
--
  FUNCTION list_all_files_coming_in
              ( pi_hft_id    IN     hig_ftp_types.hft_id%TYPE)
    RETURN nm3type.tab_varchar32767
  IS
    retval  nm3type.tab_varchar32767;
    l_local nm3type.tab_varchar32767;
  BEGIN
  --
    FOR i IN 
      (SELECT hfc_id FROM hig_ftp_connections
        WHERE hfc_hft_id = pi_hft_id)
    LOOP
    --
      l_local := list_all_files_coming_in
                    ( pi_hfc_id   => i.hfc_id );
    --
      FOR l IN 1..l_local.COUNT LOOP
      --
        retval(retval.COUNT+1) := l_local(l);
      --
      END LOOP;
    --
    END LOOP;
  --
    RETURN retval;
  --
  END list_all_files_coming_in;
--
--------------------------------------------------------------------------------
--
  FUNCTION list_all_files_coming_in
              ( pi_hft_type    IN     hig_ftp_types.hft_type%TYPE)
    RETURN nm3type.tab_varchar32767
  IS
    l_rec_hft hig_ftp_types%ROWTYPE;
    retval    nm3type.tab_varchar32767;
  BEGIN
  --
    l_rec_hft :=  get_hft ( pi_hft_type        => pi_hft_type
                          , pi_raise_not_found => FALSE );
    IF l_rec_hft.hft_id IS NOT NULL
    THEN
    --
      retval := list_all_files_coming_in
                    ( pi_hft_id => l_rec_hft.hft_id);
    --
    END IF;
  --
    RETURN retval;
  --
  END list_all_files_coming_in;
--
--------------------------------------------------------------------------------
--
  FUNCTION ftp_in_to_database
              ( pi_tab_ftp_connections     NM_ID_TBL 
              , pi_db_location_to_move_to  IN VARCHAR2
              , pi_file_mask               IN VARCHAR2
              , pi_binary                  IN BOOLEAN DEFAULT TRUE
              , pi_archive_overwrite       IN BOOLEAN DEFAULT FALSE
              , pi_remove_failed_arch      IN BOOLEAN DEFAULT FALSE)  RETURN nm3type.tab_varchar32767 IS

    l_temp_tab     nm3type.tab_varchar32767;
    l_files_tab    nm3type.tab_varchar32767;
    l_retval       nm3type.tab_varchar32767;
    l_include_file BOOLEAN; 
    l_filename     nm3type.max_varchar2;
    l_db_dir       VARCHAR2(50) := nm3file.get_oracle_directory(pi_path => pi_db_location_to_move_to);
    l_password     nm3type.max_varchar2;
    l_conn         utl_tcp.connection;
  --


  BEGIN

/*
nm_debug.debug_on;
for i in (select column_value from table(pi_tab_ftp_connections) ) loop
nm_debug.debug('connection id = '||i.column_value);
end loop;
*/


    FOR i IN (SELECT a.* 
                FROM hig_ftp_connections a
                , table(pi_tab_ftp_connections)  b 
               WHERE a.hfc_id = b.column_value ) LOOP 

    --
      l_temp_tab.DELETE;
      l_files_tab.DELETE;
    --
      l_temp_tab := nm3ftp.list_all_files_coming_in
                        ( pi_hfc_id => i.hfc_id );
    --
      FOR files In 1..l_temp_tab.COUNT 
      LOOP
        --
          l_temp_tab(files) := 
             SUBSTR(l_temp_tab(files)
             , INSTR(l_temp_tab(files),g_forward_slash,-1)+1
             ,( LENGTH(l_temp_tab(files)) 
               - INSTR(l_temp_tab(files),g_forward_slash,-1))
              );
      END LOOP;
    --
    ---------------------------------------
    -- Filter out any files we don't want
    ---------------------------------------
    --
      IF pi_file_mask IS NOT NULL
      THEN
      --
        FOR e IN 1..l_temp_tab.COUNT 
        LOOP
        --
          IF UPPER(l_temp_tab(e)) LIKE UPPER ('%'||pi_file_mask||'%')
          THEN
             l_files_tab(l_files_tab.COUNT+1) := l_temp_tab(e);
          END IF;
        --
        END LOOP;
      --
      ELSE
      --
        l_files_tab := l_temp_tab;
      --
      END IF;
    --
      FOR f IN 1..l_files_tab.COUNT 
      LOOP
      --
      --
      ------------------------------------------------------------------------
      -- Move file from ftp in to database named in pi_db_location_to_move_to 
      ------------------------------------------------------------------------
      --
        IF i.hfc_ftp_password IS NOT NULL
        THEN
          l_password := get_password( pi_password_raw => i.hfc_ftp_password );
        END IF;
      --
        l_conn := nm3ftp.login(i.hfc_ftp_host
                               ,NVL(i.hfc_ftp_port,21)
                               ,i.hfc_ftp_username
                               ,l_password);
      --
        IF pi_binary
        THEN
          binary (p_conn => l_conn);
        ELSE
          ascii  (p_conn => l_conn);
        END IF;
      --
        BEGIN
        --
          get (
                p_conn        => l_conn,
                p_from_file   => format_with_separator(i.hfc_ftp_in_dir)||l_files_tab(f),
                p_to_dir      => l_db_dir,
                p_to_file     => l_files_tab(f)
              );
          -- Task 0110503
          -- Remove the file from the ftp location once the file is copied onto the database
          nm3ftp.delete(p_conn   => l_conn
                       ,p_file   => format_with_separator(i.hfc_ftp_in_dir)||l_files_tab(f));

        --
        ------------------------------------------------------------------------
        -- Move file from ftp in to ftp archive in if 
        -- the hig_ftp_connections record has an archived in 
        ------------------------------------------------------------------------
        --
          BEGIN
            IF i.hfc_ftp_arc_in_dir IS NOT NULL
            THEN
            --
            -- If the Archive location is on the same server as the main connection
            -- then use the same conneciton and do a rename
            --
              IF  NVL(i.hfc_ftp_arc_host,i.hfc_ftp_host)         = i.hfc_ftp_host
              AND NVL(i.hfc_ftp_port,21)                         = NVL(i.hfc_ftp_arc_port,21)
              AND NVL(i.hfc_ftp_arc_username,i.hfc_ftp_username) = i.hfc_ftp_username
              THEN
                  -- Replace the Rename to Put to copy the file from databse to FTP archival folder
                  nm3ftp.put(p_conn      => l_conn,
                             p_from_dir  => l_db_dir,
                             p_from_file => l_files_tab(f),
                             p_to_file   => format_with_separator(i.hfc_ftp_arc_in_dir)||l_files_tab(f));
              ELSE
              --
              -- Connect to the different archive server and archive the files
              --
                DECLARE
                  l_arc_conn utl_tcp.connection;
                BEGIN
                --
                  l_arc_conn := nm3ftp.login( p_host => i.hfc_ftp_arc_host
                                            , p_port => NVL(i.hfc_ftp_arc_port,21)
                                            , p_user => i.hfc_ftp_arc_username
                                            , p_pass => get_password( pi_password_raw => i.hfc_ftp_arc_password ));
                --
                  IF pi_binary
                  THEN binary (p_conn => l_arc_conn);
                  ELSE ascii  (p_conn => l_arc_conn);
                  END IF;
                --
                  nm3ftp.put(p_conn      => l_arc_conn,
                             p_from_dir  => l_db_dir,
                             p_from_file => l_files_tab(f),
                             p_to_file   => format_with_separator(i.hfc_ftp_arc_in_dir)||l_files_tab(f));
                --

                  nm3ftp.logout(p_conn => l_arc_conn);
                --
                EXCEPTION
                  WHEN OTHERS
                  THEN
                    nm3ftp.logout(p_conn => l_arc_conn);
                    utl_tcp.close_all_connections;
                END;
              --
              END IF;
            END IF;
          EXCEPTION
            WHEN OTHERS 
            THEN utl_tcp.close_all_connections; 
          END;
        --
          utl_tcp.close_all_connections;
        --
        ----------------------------------------
        -- Send the name of the moved file out
        ----------------------------------------
        --
          l_retval(l_retval.COUNT+1) := l_files_tab(f);
        --
        EXCEPTION
          WHEN OTHERS
          THEN utl_tcp.close_all_connections;
        --
        END;
      --
      END LOOP;
    --
    END LOOP; 
  --
    RETURN(l_retval);
  --
  EXCEPTION
  --
    WHEN OTHERS 
      THEN
      utl_tcp.close_all_connections;
      RAISE;
  --
  END ftp_in_to_database;
--
--------------------------------------------------------------------------------
--
FUNCTION ftp_in_to_database
              ( pi_ftp_type                IN hig_ftp_types.hft_type%TYPE
              , pi_db_location_to_move_to  IN VARCHAR2
              , pi_file_mask               IN VARCHAR2
              , pi_binary                  IN BOOLEAN DEFAULT TRUE
              , pi_archive_overwrite       IN BOOLEAN DEFAULT FALSE
              , pi_remove_failed_arch      IN BOOLEAN DEFAULT FALSE) RETURN nm3type.tab_varchar32767 IS


 l_tab_ftp_connections NM_ID_TBL := new NM_ID_TBL();


 CURSOR c_all_conns_for_type IS
 select hfc_id
   from hig_ftp_connections a
       ,hig_ftp_types b
  where b.hft_type = pi_ftp_type
    and a.hfc_hft_id = b.hft_id;  
 

BEGIN

 OPEN c_all_conns_for_type;
 FETCH c_all_conns_for_type BULK COLLECT INTO l_tab_ftp_connections;
 CLOSE c_all_conns_for_type;

 RETURN(
        ftp_in_to_database(
                           pi_tab_ftp_connections     => l_tab_ftp_connections 
                         , pi_db_location_to_move_to  => pi_db_location_to_move_to 
                         , pi_file_mask               => pi_file_mask 
                         , pi_binary                  => pi_binary 
                         , pi_archive_overwrite       => pi_archive_overwrite 
                         , pi_remove_failed_arch      => pi_remove_failed_arch 
                           )
       );


END ftp_in_to_database;
--
--------------------------------------------------------------------------------
--
END nm3ftp;
/

