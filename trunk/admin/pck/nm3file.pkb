CREATE OR REPLACE PACKAGE BODY nm3file AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3file.pkb	1.18 12/12/06
--       Module Name      : nm3file.pkb
--       Date into SCCS   : 06/12/12 14:13:56
--       Date fetched Out : 07/06/13 14:11:32
--       SCCS Version     : 1.18
--
--
--   Author : Jonathan Mills
--
--   NM3 UTL_FILE wrapper package body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  VARCHAR2(2000) := '"@(#)nm3file.pkb	1.18 12/12/06"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  VARCHAR2(30)   := 'nm3file';
--
   c_dirrepstrn CONSTANT VARCHAR2(1) := hig.get_sysopt(p_option_id => 'DIRREPSTRN');
--
   g_files file_list;
-----------------------------------------------------------------------------
--
PROCEDURE internal_write_file (LOCATION     IN     VARCHAR2
                              ,filename     IN     VARCHAR2
                              ,max_linesize IN     BINARY_INTEGER DEFAULT c_default_linesize
                              ,write_mode   IN     VARCHAR2
                              ,all_lines    IN     nm3type.tab_varchar32767
                              );
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
-- Java procedure definition where the file listing work is done
PROCEDURE list_files("directory" IN varchar2)
AS LANGUAGE JAVA
NAME 'Util.GetFileList( java.lang.String )';
--
-----------------------------------------------------------------------------
--
-- Java procedure definition where the file delete is done
PROCEDURE del_file("directory" IN varchar2, "FileName" IN varchar2)
AS LANGUAGE JAVA
NAME 'Util.DeleteFile( java.lang.String, java.lang.String )';
--
-----------------------------------------------------------------------------
--
-- Java procedure move file
function java_move_file
   ( "fileFrom"  in varchar2
   , "fileTo"    in varchar2
   , "fromDir"   in varchar2
   , "toDir"     in varchar2
   , "overWrite" in varchar2
   ) return varchar2
AS LANGUAGE JAVA
NAME 'Util.moveFile( java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String ) return java.lang.String';
--
-----------------------------------------------------------------------------
--
procedure web_top
  ( pi_title in varchar2 
  ) is
begin 
  htp.p('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">') ; 
  htp.p('<html>');
  htp.p('<head>');
  htp.p('<link rel="stylesheet" href="docs/iamsdev.css" />');
  htp.p('<Title>Load file to an Oracle Directory');
  htp.p('</Title>');
  htp.p('</Head>');
  htp.p('<body>');
end web_top;
--
-----------------------------------------------------------------------------
--
procedure web_bottom
is
begin
  htp.p('</body>');
  htp.p('</html>');
end web_bottom;

--
-----------------------------------------------------------------------------
-- nm3clob does uses Pl/sql arrays and writes lines out
-- this is dandy if you want extra ^Ms all over the place
procedure write_blob
  ( p_blob in out nocopy blob
  , p_file_loc in varchar2
  , p_file_name in varchar2
  ) is

l_buffer        RAW(32767);
l_buffer_size   CONSTANT BINARY_INTEGER := 32767;
l_amount        BINARY_INTEGER;
l_offset        NUMBER(38);
l_file_handle   UTL_FILE.FILE_TYPE;

invalid_directory_path EXCEPTION;
PRAGMA EXCEPTION_INIT(invalid_directory_path, -29280);

BEGIN

  l_file_handle := UTL_FILE.FOPEN(p_file_loc, p_file_name, 'w', l_buffer_size);
  l_amount := l_buffer_size;
  l_offset := 1;
  BEGIN

    WHILE l_amount >= l_buffer_size
    LOOP

      DBMS_LOB.READ
        ( lob_loc    => p_blob
        , amount     => l_amount
        , offset     => l_offset
        , buffer     => l_buffer
        ) ;

      l_offset := l_offset + l_amount;

      l_buffer := replace( l_buffer, chr(13) ) ;

      UTL_FILE.PUT_RAW
        ( file      => l_file_handle
        , buffer    => l_buffer
        , autoflush => true
        );

      UTL_FILE.FFLUSH
        ( file => l_file_handle);

    END LOOP;

  EXCEPTION

    WHEN others THEN
      UTL_FILE.PUT_LINE(file => l_file_handle, buffer => '+----------------------------+');
      UTL_FILE.PUT_LINE(file => l_file_handle, buffer => '|      ***   ERROR   ***     |');
      UTL_FILE.PUT_LINE(file => l_file_handle, buffer => '+----------------------------+');
      UTL_FILE.NEW_LINE(file => l_file_handle);
      UTL_FILE.PUT_LINE(file => l_file_handle, buffer => 'WHEN OTHERS ERROR');
      UTL_FILE.PUT_LINE(file => l_file_handle, buffer => '=================');
      UTL_FILE.PUT_LINE(file => l_file_handle, buffer => '    --> SQL CODE          : ' || SQLCODE);
      UTL_FILE.PUT_LINE(file => l_file_handle, buffer => '    --> SQL ERROR MESSAGE : ' || SQLERRM);
      UTL_FILE.FFLUSH(file => l_file_handle);


  END ;

  UTL_FILE.FCLOSE(l_file_handle);

EXCEPTION

  WHEN invalid_directory_path THEN
    raise_application_error(-20001,'** ERROR ** : Invalid Directory Path: ' || p_file_loc);

END write_blob;
--
-----------------------------------------------------------------------------
--
FUNCTION get_open_mode_descr(open_mode IN VARCHAR) RETURN VARCHAR IS

BEGIN
      IF open_mode = 'R' THEN 
        RETURN('READ');
      ELSE
        RETURN('WRITE');
      END IF;
END get_open_mode_descr;
--
-----------------------------------------------------------------------------
--      
FUNCTION fopen(LOCATION     IN VARCHAR2       DEFAULT c_default_location
              ,filename     IN VARCHAR2
              ,open_mode    IN VARCHAR2
              ,max_linesize IN BINARY_INTEGER DEFAULT c_default_linesize
              ) RETURN UTL_FILE.FILE_TYPE IS
--
   l_full_filename VARCHAR2(2000) := LOCATION||c_dirrepstrn||filename;
   
   l_mode_descr VARCHAR2(5);
--
BEGIN
--
   IF  LOCATION IS NULL
    OR filename IS NULL
    THEN
      RAISE UTL_FILE.INVALID_PATH;
   END IF;
--
   IF UPPER(open_mode) NOT IN (c_read_mode,c_write_mode,c_append_mode)
    THEN
      -- Trap this one before it even gets as far at the FOPEN call
      RAISE UTL_FILE.INVALID_MODE;
   END IF;
--
   RETURN UTL_FILE.FOPEN(LOCATION, filename, open_mode, max_linesize);
--
EXCEPTION
   WHEN UTL_FILE.INVALID_PATH
    THEN
      RAISE_APPLICATION_ERROR(-20001,'file location or name was invalid');
   WHEN UTL_FILE.INVALID_MODE
    THEN
      RAISE_APPLICATION_ERROR(-20001,'the open_mode string was invalid');
   WHEN UTL_FILE.INVALID_OPERATION
    THEN
      RAISE_APPLICATION_ERROR(-20001,'file "'||l_full_filename||'" could not be opened as requested');
      
   WHEN UTL_FILE.access_denied THEN

      hig.raise_ner(pi_appl               => nm3type.c_hig
                   ,pi_id                 => 86 -- user does not have permission to perform this action
                   ,pi_sqlcode            => -20001
                   ,pi_supplementary_info => chr(10)||get_open_mode_descr(open_mode)||' privilege is not granted on directory '||upper(location)||' to '||USER);
                       
   WHEN UTL_FILE.invalid_maxlinesize
    THEN
      RAISE_APPLICATION_ERROR(-20001,'specified max_linesize is too large or too small');
END fopen;
--
-----------------------------------------------------------------------------
--
FUNCTION is_open(FILE IN UTL_FILE.FILE_TYPE) RETURN BOOLEAN IS
BEGIN
   RETURN UTL_FILE.IS_OPEN(FILE);
END is_open;
--
-----------------------------------------------------------------------------
--
PROCEDURE fclose(FILE IN OUT UTL_FILE.FILE_TYPE) IS
BEGIN
--
   UTL_FILE.FCLOSE(FILE);
--
EXCEPTION
   WHEN UTL_FILE.INVALID_FILEHANDLE
    THEN
      RAISE_APPLICATION_ERROR(-20001,'not a valid file handle');
   WHEN UTL_FILE.WRITE_ERROR
    THEN
      RAISE_APPLICATION_ERROR(-20001,'OS error occured during write operation');
      
END fclose;
--
-----------------------------------------------------------------------------
--
PROCEDURE fclose_all IS
BEGIN
--
   UTL_FILE.FCLOSE_ALL;
--
EXCEPTION
   WHEN UTL_FILE.WRITE_ERROR
    THEN
      RAISE_APPLICATION_ERROR(-20001,'OS error occured during write operation');
END fclose_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_line(FILE      IN     UTL_FILE.FILE_TYPE
                  ,buffer       OUT VARCHAR2
                  ,eof_found    OUT BOOLEAN
                  ,add_cr    IN BOOLEAN DEFAULT FALSE
                  ) IS
BEGIN
--
   eof_found := FALSE;
   buffer    := NULL;
--
   UTL_FILE.GET_LINE(FILE, buffer);
--
   IF add_cr THEN
      buffer := buffer || CHR(10);
   END IF;
--
EXCEPTION
   WHEN NO_DATA_FOUND
    THEN
      eof_found := TRUE;
   WHEN VALUE_ERROR
    THEN
      RAISE_APPLICATION_ERROR(-20001,'line to long to store in buffer');
   WHEN UTL_FILE.INVALID_FILEHANDLE
    THEN
      RAISE_APPLICATION_ERROR(-20001,'not a valid file handle');
   WHEN UTL_FILE.INVALID_OPERATION
    THEN
      RAISE_APPLICATION_ERROR(-20001,'file is not open for reading');
   WHEN UTL_FILE.READ_ERROR
    THEN
      RAISE_APPLICATION_ERROR(-20001,'OS error occurred during read');
END get_line;
--
-----------------------------------------------------------------------------
--
PROCEDURE put_line(FILE   IN UTL_FILE.FILE_TYPE
                  ,buffer IN VARCHAR2
                  ) IS
BEGIN
--
   UTL_FILE.PUT_LINE(FILE, buffer);
--
EXCEPTION
   WHEN UTL_FILE.INVALID_FILEHANDLE
    THEN
      RAISE_APPLICATION_ERROR(-20001,'not a valid file handle');
   WHEN UTL_FILE.INVALID_OPERATION
    THEN
      RAISE_APPLICATION_ERROR(-20001,'file is not open for reading');
   WHEN UTL_FILE.WRITE_ERROR
    THEN
      RAISE_APPLICATION_ERROR(-20001,'OS error occured during write operation');
END put_line;
--
-----------------------------------------------------------------------------
--
PROCEDURE put     (FILE   IN UTL_FILE.FILE_TYPE
                  ,buffer IN VARCHAR2
                  ) IS
BEGIN
--
   UTL_FILE.PUT(FILE, buffer);
--
EXCEPTION
   WHEN UTL_FILE.INVALID_FILEHANDLE
    THEN
      RAISE_APPLICATION_ERROR(-20001,'not a valid file handle');
   WHEN UTL_FILE.INVALID_OPERATION
    THEN
      RAISE_APPLICATION_ERROR(-20001,'file is not open for reading');
   WHEN UTL_FILE.WRITE_ERROR
    THEN
      RAISE_APPLICATION_ERROR(-20001,'OS error occured during write operation');
END put;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_file (LOCATION     IN     VARCHAR2       DEFAULT c_default_location
                   ,filename     IN     VARCHAR2
                   ,max_linesize IN     BINARY_INTEGER DEFAULT c_default_linesize
                   ,all_lines       OUT nm3type.tab_varchar32767
                   ,add_cr    IN BOOLEAN DEFAULT FALSE
                   ) IS
--
   l_file   UTL_FILE.FILE_TYPE;
   l_eof    BOOLEAN;
   l_buffer VARCHAR2(32767);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_file');
--
   l_file := fopen (LOCATION,filename,c_read_mode,max_linesize);
--
   get_line(l_file,l_buffer,l_eof, add_cr);
   WHILE NOT l_eof
    LOOP
      all_lines(all_lines.COUNT+1) := l_buffer;
      get_line(l_file,l_buffer,l_eof, add_cr);
   END LOOP;
--
   fclose(l_file);
--
   nm_debug.proc_end(g_package_name,'get_file');
--
END get_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_file (LOCATION     IN     VARCHAR2       DEFAULT c_default_location
                     ,filename     IN     VARCHAR2
                     ,max_linesize IN     BINARY_INTEGER DEFAULT c_default_linesize
                     ,all_lines    IN     nm3type.tab_varchar32767
                     ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'write_file');
--
   internal_write_file (LOCATION     => LOCATION
                       ,filename     => filename
                       ,max_linesize => max_linesize
                       ,write_mode   => c_write_mode
                       ,all_lines    => all_lines
                       );
--
   nm_debug.proc_end(g_package_name,'write_file');
--
END write_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_file (LOCATION     IN     VARCHAR2       DEFAULT c_default_location
                      ,filename     IN     VARCHAR2
                      ,max_linesize IN     BINARY_INTEGER DEFAULT c_default_linesize
                      ,all_lines    IN     nm3type.tab_varchar32767
                      ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'append_file');
--
   internal_write_file (LOCATION     => LOCATION
                       ,filename     => filename
                       ,max_linesize => max_linesize
                       ,write_mode   => c_append_mode
                       ,all_lines    => all_lines
                       );
--
   nm_debug.proc_end(g_package_name,'append_file');
--
END append_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE internal_write_file (LOCATION     IN     VARCHAR2
                              ,filename     IN     VARCHAR2
                              ,max_linesize IN     BINARY_INTEGER DEFAULT c_default_linesize
                              ,write_mode   IN     VARCHAR2
                              ,all_lines    IN     nm3type.tab_varchar32767
                              ) IS
--
   l_file   UTL_FILE.FILE_TYPE;
   l_count  PLS_INTEGER;
--
BEGIN
--
--   nm_debug.debug(location);
--   nm_debug.debug(filename);
--   nm_debug.debug(max_linesize);
--   nm_debug.debug(write_mode);
   l_file := fopen (LOCATION,filename,write_mode,max_linesize);
--
   l_count := all_lines.FIRST;
--
   WHILE l_count IS NOT NULL
    LOOP
      put_line(l_file,all_lines(l_count));
      l_count := all_lines.NEXT(l_count);
   END LOOP;
--
   fclose(l_file);
--
END internal_write_file;
--
-----------------------------------------------------------------------------
--
FUNCTION file_exists( LOCATION     IN     VARCHAR2       DEFAULT c_default_location
                     ,filename     IN     VARCHAR2)
RETURN VARCHAR2
IS
  l_file UTL_FILE.FILE_TYPE;
  retval VARCHAR2(1) := 'N';
BEGIN
  -- try and open the file
  l_file := fopen (LOCATION     => LOCATION
                  ,filename     => filename
                  ,open_mode    => c_read_mode
                  );
  fclose( l_file );

  retval := 'Y';

  RETURN retval;

  EXCEPTION
  WHEN OTHERS THEN
     RETURN retval;
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE file_exists( p_location     IN     VARCHAR2       DEFAULT c_default_location
                     , p_filename     IN     VARCHAR2
                     , p_exists       IN OUT VARCHAR2)
IS
BEGIN
  p_exists := file_exists ( p_location, p_filename );
END file_exists;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_file_to_nuf (pi_filename         IN     nm_upload_files.name%TYPE
                            ,pi_all_lines        IN     nm3type.tab_varchar32767
                            ,pi_mime_type        IN     nm_upload_files.mime_type%TYPE DEFAULT NULL
                            ,pi_append_lf        IN     BOOLEAN                        DEFAULT TRUE
                            ,pi_delete_if_exists IN     BOOLEAN                        DEFAULT FALSE
                            ,pi_gateway_table    IN     VARCHAR2                       DEFAULT NULL
                            ,pi_gateway_col_1    IN     VARCHAR2                       DEFAULT NULL
                            ,pi_gateway_col_2    IN     VARCHAR2                       DEFAULT NULL
                            ,pi_gateway_col_3    IN     VARCHAR2                       DEFAULT NULL
                            ,pi_gateway_col_4    IN     VARCHAR2                       DEFAULT NULL
                            ,pi_gateway_col_5    IN     VARCHAR2                       DEFAULT NULL
                            ) IS
   l_filesize        NUMBER := 0;
   l_tab_local_lines nm3type.tab_varchar32767;
   c_mime_type    CONSTANT VARCHAR2(10) := 'text/plain';
   c_sysdate      CONSTANT DATE         := SYSDATE;
   c_content_type CONSTANT VARCHAR2(4)  := 'BLOB';
   c_dad_charset  CONSTANT VARCHAR2(5)  := 'ascii';
   l_rec_nuf      nm_upload_files%ROWTYPE;
   i              NUMBER;
   j              NUMBER := 0;
BEGIN
--
   nm_debug.proc_start(g_package_name,'write_file_to_nuf');
--
   IF nm3get.get_nuf (pi_name            => pi_filename
                     ,pi_raise_not_found => FALSE
                     ).name IS NOT NULL
    THEN
      IF pi_delete_if_exists
       THEN
         nm3del.del_nuf (pi_name => pi_filename);
      ELSE
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 64
                       ,pi_supplementary_info => 'nm_upload_files.name = '||nm3flx.string(pi_filename)
                       );
      END IF;
   END IF;
--
   i := pi_all_lines.FIRST;
   WHILE i IS NOT NULL -- Like this to cope with sparse arrays
    LOOP
      j := j + 1;
      l_tab_local_lines(j) := pi_all_lines(i);
      IF   pi_append_lf
       AND LENGTH(l_tab_local_lines(j)) < 32767
       THEN
         l_tab_local_lines(j) := l_tab_local_lines(j)||CHR(10);
      END IF;
      l_filesize := l_filesize + LENGTH(l_tab_local_lines(j));
      i := pi_all_lines.NEXT(i);
   END LOOP;
--
   l_rec_nuf.name         := pi_filename;
   l_rec_nuf.mime_type    := NVL(pi_mime_type,c_mime_type);
   l_rec_nuf.doc_size     := l_filesize;
   l_rec_nuf.dad_charset  := c_dad_charset;
   l_rec_nuf.last_updated := c_sysdate;
   l_rec_nuf.content_type := c_content_type;
   l_rec_nuf.blob_content := nm3clob.clob_to_blob(nm3clob.tab_varchar_to_clob (pi_tab_vc => l_tab_local_lines));
   IF pi_gateway_table IS NOT NULL
    THEN
      l_rec_nuf.nuf_nufg_table_name    := pi_gateway_table;
      l_rec_nuf.nuf_nufgc_column_val_1 := pi_gateway_col_1;
      l_rec_nuf.nuf_nufgc_column_val_2 := pi_gateway_col_2;
      l_rec_nuf.nuf_nufgc_column_val_3 := pi_gateway_col_3;
      l_rec_nuf.nuf_nufgc_column_val_4 := pi_gateway_col_4;
      l_rec_nuf.nuf_nufgc_column_val_5 := pi_gateway_col_5;
   END IF;
--
   nm3ins.ins_nuf (l_rec_nuf);
--
   nm_debug.proc_end(g_package_name,'write_file_to_nuf');
--
END write_file_to_nuf;
--
-----------------------------------------------------------------------------
--
PROCEDURE unix2dos(pi_file IN OUT NOCOPY nm3type.tab_varchar32767) IS
BEGIN
  nm_debug.proc_start(g_package_name,'unix2dos');
  
  FOR i IN 1..pi_file.COUNT LOOP
    -- tidy up in case there are already dos CR/LF combinations in the file
    IF LENGTH(pi_file(i)) < 32767 THEN
      pi_file(i) := REPLACE(pi_file(i), CHR(13)||CHR(10), CHR(10));
      pi_file(i) := REPLACE(pi_file(i), CHR(10), CHR(13)||CHR(10));
    END IF;
  
  END LOOP;
  
  nm_debug.proc_end(g_package_name,'unix2dos');
END unix2dos;
--
-----------------------------------------------------------------------------
--
PROCEDURE unix2dos (pi_file IN OUT NOCOPY clob) IS
l_tab_vc   nm3type.tab_varchar32767:= nm3clob.clob_to_tab_varchar(pi_file);
BEGIN

  unix2dos(pi_file => l_tab_vc);
  
  pi_file := nm3clob.tab_varchar_to_clob(l_tab_vc);

  nm_debug.proc_end(g_package_name,'unix2dos');
END unix2dos;
--
-----------------------------------------------------------------------------
--
PROCEDURE unix2dos (pi_filename IN nm_upload_files.name%TYPE) IS

l_nuf nm_upload_files%ROWTYPE := nm3get.get_nuf(pi_name            => pi_filename
                                               ,pi_raise_not_found => TRUE);
l_clob clob := nm3clob.blob_to_clob(l_nuf.blob_content);
BEGIN
  
  unix2dos(l_clob);

  UPDATE nm_upload_files
  SET blob_content = nm3clob.clob_to_blob(l_clob)
  WHERE name = l_nuf.name;

END unix2dos;
--
-----------------------------------------------------------------------------
--
PROCEDURE dos2unix (pi_file IN OUT NOCOPY nm3type.tab_varchar32767) IS
BEGIN
  nm_debug.proc_start(g_package_name,'dos2unix');
   
  FOR i IN 1..pi_file.COUNT LOOP
    pi_file(i) := REPLACE(pi_file(i), CHR(13)||CHR(10), CHR(10));
  END LOOP;

  nm_debug.proc_end(g_package_name,'dos2unix');
  
END dos2unix;
--
-----------------------------------------------------------------------------
--
PROCEDURE dos2unix (pi_file IN OUT NOCOPY clob) IS
l_tab_vc   nm3type.tab_varchar32767:= nm3clob.clob_to_tab_varchar(pi_file);
BEGIN
  nm_debug.proc_start(g_package_name,'dos2unix');
   
  dos2unix(pi_file => l_tab_vc);
  
  pi_file := nm3clob.tab_varchar_to_clob(l_tab_vc);

  nm_debug.proc_end(g_package_name,'dos2unix');
END dos2unix;
--
-----------------------------------------------------------------------------
--
PROCEDURE dos2unix (pi_filename IN nm_upload_files.name%TYPE) IS
l_nuf nm_upload_files%ROWTYPE := nm3get.get_nuf(pi_name            => pi_filename
                                               ,pi_raise_not_found => TRUE);
l_clob clob := nm3clob.blob_to_clob(l_nuf.blob_content);
BEGIN
  
  dos2unix(l_clob);

  UPDATE nm_upload_files
  SET blob_content = nm3clob.clob_to_blob(l_clob)
  WHERE name = l_nuf.name;
END dos2unix;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_file_to_dir_list (pi_file IN varchar2) IS

BEGIN
  g_files(g_files.COUNT+1) := pi_file;
END append_file_to_dir_list;
--
-----------------------------------------------------------------------------
--
FUNCTION get_files_in_directory (pi_dir       IN varchar2
                                ,pi_extension IN varchar2) RETURN file_list IS
l_ret_files file_list;
BEGIN
  nm_debug.proc_start(g_package_name,'get_files_in_directory');

  g_files.DELETE;
  list_files(pi_dir);
  
  IF pi_extension IS NOT NULL THEN
  
    FOR i IN 1..g_files.COUNT LOOP
    
      IF nm3flx.get_file_extenstion(g_files(i)) = pi_extension THEN

         l_ret_files(l_ret_files.COUNT+1) := g_files(i);
      END IF;
      
    END LOOP;

    nm_debug.proc_end(g_package_name,'get_files_in_directory');
    RETURN l_ret_files;
  
  ELSE

    -- if no file extention param is passed in
    -- and  filename is same as parse file extention 
    -- it indicates that we have a directory name - so knock those out of what is returned
    --
    FOR i IN 1..g_files.COUNT LOOP

      IF nm3flx.get_file_extenstion(g_files(i)) != g_files(i) THEN 

         l_ret_files(l_ret_files.COUNT+1) := g_files(i);
      END IF;
       
    END LOOP;
    RETURN l_ret_files;
    nm_debug.proc_end(g_package_name,'get_files_in_directory');
    RETURN g_files;
  END IF;
  
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_wildcard_files_in_dir
  (pi_dir       IN varchar2
  ,pi_wildcard  IN varchar2) RETURN file_list IS
l_ret_files file_list;
l_wildcard varchar2(200) := lower(pi_wildcard) ;
BEGIN
  l_wildcard := replace( l_wildcard, '*', '%' ) ;
  l_wildcard := replace( l_wildcard, '?', '_' ) ;
  nm_debug.proc_start(g_package_name,'get_wildcard_files_in_dir');

  g_files.DELETE;
  list_files(pi_dir);
  
  IF pi_wildcard IS NOT NULL THEN
  
    FOR i IN 1..g_files.COUNT LOOP
    
      IF lower(g_files(i)) like lower(l_wildcard) THEN
         l_ret_files(l_ret_files.COUNT+1) := g_files(i);
      END IF;
      
    END LOOP;

    nm_debug.proc_end(g_package_name,'get_wildcard_files_in_dir');
    RETURN l_ret_files;
  
  ELSE
    nm_debug.proc_end(g_package_name,'get_wildcard_files_in_dir');
    RETURN g_files;
  END IF;
  
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_file (pi_dir IN varchar2, pi_file IN varchar2) IS
l_dir varchar2(256) := pi_dir;
BEGIN 
  nm_debug.proc_start(g_package_name,'delete_file');
  
  -- add directory separator if needed
  IF substr(l_dir, -1, 1) != c_dirrepstrn THEN
    l_dir  := l_dir || c_dirrepstrn;
  END IF;
  
  del_file(l_dir, pi_file);
  
  nm_debug.proc_end(g_package_name,'delete_file');
END;
--
-----------------------------------------------------------------------------
--
FUNCTION remove_file_extension(pi_file IN varchar2) RETURN varchar2 IS
BEGIN
  RETURN substr(pi_file, 1, instr(pi_file, nm3type.c_dot) -1);
END remove_file_extension;
--
-----------------------------------------------------------------------------
--
/* "pure" pl/sql version (which uses flaky utl_file.move_file that won't work)
preserved here for posterity. Note that we are now using java because we
have to use it to delete the source file anyway
procedure move_file 
  ( pi_from_file  in  varchar2
  , pi_from_loc   in  varchar2 default null
  , pi_to_file    in  varchar2 default null
  , pi_to_loc     in  varchar2 default null
  , pi_overwrite  in  boolean  default false
  , po_err_no     out integer
  , po_err_mess   out varchar2
  )
  is
-- No 'to' file name assume it's the same name
l_to_file varchar2(32767) := nvl(pi_to_file,pi_from_file) ;
-- no 'to' file dir assume it's the same dir
l_to_loc varchar2(32767) := nvl(pi_to_loc,pi_from_loc) ;
l_from_handle utl_file.file_type ;
l_to_handle utl_file.file_type ;
l_line_buffer varchar2(32767) ;
b_eof_data boolean ;
l_directory_path varchar2(256) ;
begin
  nm_debug.proc_start(g_package_name,'move_file');
  if not pi_overwrite and file_exists( l_to_loc, l_to_file ) = 'Y'
  then
    raise_application_error(-20001,'move_file: "To" file ' || l_to_file || ' exists and overwrite not specified ' );
  elsif file_exists( pi_from_loc, pi_from_file ) = 'N'
  then
    raise_application_error(-20001,'move_file: "From" file ' || pi_from_file || ' does not exist ' );
  end if;
  l_from_handle := fopen( pi_from_loc, pi_from_file, c_read_mode, 32767 ) ;
  l_to_handle := fopen( l_to_loc, l_to_file, c_write_mode, 32767 ) ;
  -- We are going to do this a line at a time because of memory considerations
  -- it might be quite slow
  b_eof_data := false ;
  while true
  loop
    get_line( l_from_handle, l_line_buffer, b_eof_data ) ;
    exit when b_eof_data ;
    put_line( l_to_handle, l_line_buffer ) ;
  end loop;
  fclose_all ;
  select directory_path
  into   l_directory_path
  from   all_directories
  where  directory_name = upper( pi_from_loc ) 
  ;
  delete_file( l_directory_path, pi_from_file ) ;
  po_err_no := null ;
  po_err_mess := null ;
  nm_debug.proc_end(g_package_name,'move_file');
exception
  when others then
    nm_debug.debug( sqlerrm ) ;
    po_err_no := sqlcode ;
    po_err_mess := sqlerrm ;

end move_file;
*/
procedure move_file 
  ( pi_from_file  in  varchar2
  , pi_from_loc   in  varchar2 default null
  , pi_to_file    in  varchar2 default null
  , pi_to_loc     in  varchar2 default null
  , pi_use_hig    in  boolean  default false
  , pi_overwrite  in  boolean  default false
  , po_err_no     out integer
  , po_err_mess   out varchar2
  )
  is
-- No 'to' file name assume it's the same name
l_to_file varchar2(32767) := nvl(pi_to_file,pi_from_file) ;
-- no 'to' file dir assume it's the same dir
l_to_loc varchar2(32767) := nvl(pi_to_loc,pi_from_loc) ;
l_from_handle utl_file.file_type ;
l_to_handle utl_file.file_type ;
l_line_buffer varchar2(32767) ;
b_eof_data boolean ;
l_directory_path varchar2(256) ;
l_move_status varchar2(1) ;
begin
  nm_debug.proc_start(g_package_name,'move_file');
  po_err_no := null ;
  l_move_status := java_move_file
                   ( "fileFrom"  => pi_from_file
                   , "fileTo"    => l_to_file
                   , "fromDir"   => get_true_dir_name( pi_from_loc, pi_use_hig )
                   , "toDir"     => get_true_dir_name( l_to_loc, pi_use_hig ) 
                   , "overWrite" => case when pi_overwrite then 'Y'
                                    else 'N'
                                    end
                   ) ;
  if l_move_status = 'N'
  then
    raise_application_error(-20001,'Move file failed ' || 
          get_true_dir_name( pi_from_loc, pi_use_hig ) || pi_from_file ||
          ' -> ' ||
          get_true_dir_name( l_to_loc, pi_use_hig )  || l_to_file
          );
  end if ;
  po_err_mess := null ;
  nm_debug.proc_end(g_package_name,'move_file');
exception
  when others then
    nm_debug.debug( sqlerrm ) ;
    po_err_no := sqlcode ;
    po_err_mess := sqlerrm ;
end move_file;
--
-----------------------------------------------------------------------------
--
FUNCTION get_true_dir_name
  (pi_loc       IN varchar2
  ,pi_use_hig   in boolean
  ) RETURN varchar2  is
l_directory_path all_directories.directory_path%type ;
l_errmess varchar2(200);
begin
  nm_debug.proc_start(g_package_name,'get_true_dir_name');
  if pi_use_hig
  then
    l_errmess := ' in HIG_DIRECTORIES table' ;
    select hdir_path
      into l_directory_path
      from hig_directories
     where hdir_name = upper( pi_loc ) ;
  else
    l_errmess := ' in ALL_DIRECTORIES table' ;
    select directory_path
      into l_directory_path
      from all_directories
     where directory_name = upper( pi_loc ) 
            ;
  end if ;
  nm_debug.proc_end(g_package_name,'get_true_dir_name');
  return l_directory_path ;
exception
  when no_data_found then
    nm_debug.debug( 'get_true_dir_name: Location name "' || pi_loc || '" not found' || l_errmess ) ;
    raise_application_error(-20001,'get_true_dir_name: Location name "' || pi_loc || '" not found' || l_errmess );
end get_true_dir_name;
--
-----------------------------------------------------------------------------
--
FUNCTION get_loc_name
  (pi_path       IN varchar2
   , pi_use_hig  in boolean default false
  ) RETURN varchar2  is
l_directory_name all_directories.directory_name%type ;
l_errmess varchar2(200);
begin
  nm_debug.proc_start(g_package_name,'get_loc_name');
  if pi_use_hig
  then
    l_errmess := ' in HIG_DIRECTORIES table' ;
    select hdir_name
      into l_directory_name
      from hig_directories
     where upper(hdir_path) = upper( pi_path ) ;
  else
    l_errmess := ' in ALL_DIRECTORIES table' ;
    select directory_name
      into l_directory_name
      from all_directories
     where upper(directory_path) = upper( pi_path ) 
            ;
  end if ;
  nm_debug.proc_end(g_package_name,'get_loc_name');
  return l_directory_name ;
exception
  when no_data_found then
    nm_debug.debug( 'get_loc_name: Path name "' || pi_path || '" not found' ) ;
    raise_application_error(-20001,'get_loc_name: Path name "' || pi_path || '" not found' );
end get_loc_name;
-----------------------------------------------------------------------------
--
procedure upload_to_dir
  ( pi_directory IN varchar2
  , pi_file_name IN varchar2
  , pi_show_html in boolean default true
  ) is
begin
  nm_debug.proc_start(g_package_name,'upload_to_dir');
  upload_to_path( get_true_dir_name( pi_directory ), pi_file_name, pi_show_html ) ;
  nm_debug.proc_end (g_package_name,'upload_to_dir');
end upload_to_dir;
--
-----------------------------------------------------------------------------
--
procedure upload_to_path
  ( pi_path      IN varchar2
  , pi_file_name IN varchar2
  , pi_show_html in boolean default true
  ) is
l_stripped_filename nm_load_batches.nlb_filename%TYPE;
l_rec_nuf nm_upload_files%rowtype ;
--l_clob clob ;
begin
  nm_debug.proc_start(g_package_name,'upload_to_path');

  --htp.p(pi_path) ;
  --htp.p(pi_file_name) ;

  if pi_show_html
  then
    web_top('Load file to an Oracle Directory');
  end if ;
  l_stripped_filename := nm3upload.strip_dad_reference(pi_file_name);

  --
  -- Something mysterious is putting extra ^M's in the file
  --
  dos2unix( pi_filename => pi_file_name ) ;

  select * 
  into   l_rec_nuf
  from   nm_upload_files
  where  name = pi_file_name ;

  /*
  l_clob := nm3clob.blob_to_clob(l_rec_nuf.blob_content);
  dos2unix(l_clob);
  nm3clob.writeclobout
    ( result => l_clob
    , file_location => pi_path
    , file_name => l_stripped_filename
    ) ;
  */

  write_blob
    ( p_blob      => l_rec_nuf.blob_content
    , p_file_loc  => get_loc_name(pi_path)
    , p_file_name => l_stripped_filename
    ) ;
  
  if pi_show_html
  then
    htp.p('File ' || l_stripped_filename || ' loaded successfully to ' || pi_path || ', you may close this window now');
    web_bottom ;
  end if ;

  nm_debug.proc_end (g_package_name,'upload_to_path');
exception
  when others then
    if pi_show_html
    then
      htp.p('ERROR: ' || l_stripped_filename || ' load failed to ' || pi_path || ', you may close this window now <br />');
      htp.p(sqlerrm);
      web_bottom ;
    else
      raise ;
    end if ;
end upload_to_path;
--
-----------------------------------------------------------------------------
--
procedure web_upload_to_dir
  is
begin
  nm_debug.proc_start(g_package_name,'web_upload_to_dir');

  web_top('Load file to an Oracle Directory');
  htp.p('<form action="./nm3file.upload_to_path" method="post" enctype="multipart/form-data">'); htp.p('  <table>');
  htp.p('    <tr>');
  htp.p('      <td>');
  htp.p('        File Name ');
  htp.p('      </td>');
  htp.p('      <td>');
  htp.p('        <input type="file" name="pi_file_name">');
  htp.p('      </td>');
  htp.p('    </tr>');
  htp.p('    <tr>');
  htp.p('      <td>');
  htp.p('        Target directory');
  htp.p('      </td>');
  htp.p('      <td>');
  htp.p('        <select name="pi_path">');
  for dirs in (select * from all_directories order by directory_name)
  loop
    htp.p('          <option value="'|| dirs.directory_path || '">' || dirs.directory_name || '</option>');
  end loop;
  htp.p('        </select>');
  htp.p('      </td>');
  htp.p('    </tr>');
  htp.p('    <tr>');
  htp.p('      <td>');
  htp.p('        <input type="submit" value="Load" />');
  htp.p('      </td>');
  htp.p('    </tr>');
  htp.p('  </table>');
  htp.p('</form>');
  web_bottom ;
  nm_debug.proc_end (g_package_name,'web_upload_to_dir');
end web_upload_to_dir;
--
-----------------------------------------------------------------------------
--
procedure web_download_from_dir
  ( pi_directory_name varchar2 default null
  ) is 
l_ret_files file_list;
begin
  nm_debug.proc_start(g_package_name,'web_download_from_dir');
  web_top('Download from Oracle Directory');
  if pi_directory_name is null
  then
    htp.p('<form action="./nm3file.web_download_from_dir" method="post">'); 
    htp.p('  <table>');
    htp.p('    <tr>');
    htp.p('      <td colspan="2">');
    htp.p('        <h1>Download from Oracle Directory</h1>');
    htp.p('      </td>');
    htp.p('    </tr>');
    htp.p('    <tr>');
    htp.p('      <td>');
    htp.p('        Directory to browse');
    htp.p('      </td>');
    htp.p('      <td>');
    htp.p('        <select name="pi_directory_name">');
    for dirs in (select * from all_directories order by directory_name)
    loop
      htp.p('          <option value="'|| dirs.directory_path || '">' || dirs.directory_name || '</option>');
    end loop;
    htp.p('        </select>');
    htp.p('      </td>');
    htp.p('    </tr>');
    htp.p('    <tr>');
    htp.p('      <td colspan="2">');
    htp.p('        <input type="submit" value="View Files" />');
    htp.p('      </td>');
    htp.p('    </tr>');
    htp.p('  </table>');
    htp.p('</form>');
  else
    htp.p('<form action="./nm3file.web_dump_file" method="post">'); 
    htp.p('  <input type="hidden" name="pi_oracle_dir" value="' || pi_directory_name || '" />' ) ;
    htp.p('  <table>');
    htp.p('    <tr>');
    htp.p('      <td colspan="2">');
    htp.p('        <h1>Download from Oracle Directory ' || pi_directory_name || '</h1>');
    htp.p('      </td>');
    htp.p('    </tr>');
    htp.p('    <tr>');
    htp.p('      <td>');
    htp.p('        Select file to download');
    htp.p('      </td>');
    htp.p('      <td>');
    htp.p('        <select name="pi_file_name">');
    l_ret_files := get_files_in_directory( pi_directory_name, null ) ;
    if l_ret_files.count > 0
    then
      for fi in 1..l_ret_files.count
      loop
        htp.p('          <option value="'|| l_ret_files(fi) || '">' || l_ret_files(fi) || '</option>');
      end loop;
    end if;
    htp.p('        </select>');
    htp.p('      </td>');
    htp.p('    </tr>');
    htp.p('    <tr>');
    htp.p('      <td colspan="2">');
    htp.p('        <input type="submit" value="Download" />');
    htp.p('      </td>');
    htp.p('    </tr>');
    htp.p('  </table>');
    htp.p('</form>');
  end if;
  nm_debug.proc_end (g_package_name,'web_download_from_dir');
end web_download_from_dir;
--</PROC>
--
-----------------------------------------------------------------------------
--
procedure web_dump_file
  ( pi_file_name in varchar2
  , pi_oracle_dir in varchar2
  ) 
is
l_lines nm3type.tab_varchar32767 ;
begin
  nm_debug.proc_start(g_package_name,'web_dump_file');
  -- This tells the browser that the file type isn't html and to save
  -- it somewhere
  htp.p( 'Content-type: application/octet-stream' );
  htp.p( 'Content-Disposition: attachment; filename="' || pi_file_name || '"' ) ;
  htp.p( '' ) ;
  get_file 
    ( LOCATION     => pi_oracle_dir
    , filename     => pi_file_name
    , max_linesize => 32767
    , all_lines    => l_lines
    ) ;

  for i in  1..l_lines.count
  loop
    htp.p(l_lines(i)) ;
  end loop;

  nm_debug.proc_end (g_package_name,'web_dump_file');

end web_dump_file;
--
-----------------------------------------------------------------------------
--
FUNCTION parse_dir_and_or_filename(pi_name           IN VARCHAR2
                                  ,pi_sep_on_end     IN BOOLEAN  DEFAULT TRUE
                                  ,pi_separator      IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 IS
 
   l_retval          VARCHAR2(2000);
   l_sep             hig_option_values.hov_value%TYPE;
 
BEGIN

  IF pi_separator IS NULL THEN
     l_sep := NVL(hig.get_sysopt('DIRREPSTRN'),'\'); --'
  ELSE
     l_sep := pi_separator;
  END IF;
   
   --
   -- take the value of pi_name and replace any separator chars with the standard separator
   -- also append a separator onto the end of the string/ensure that there is not one on the end of the string
   --   
   -- Example 1
   --
   -- pi_name           e:\utl_file
   -- pi_sep_on_end     TRUE
   -- pi_separator      \
   --
   -- l_retval          e:\utl_file\
   --   
   -- Example 2
   --
   -- pi_name           e:\utl_file\
   -- pi_sep_on_end     FALSE
   -- pi_separator      \
   --
   -- l_retval          e:\utl_file
   --
   -- Example 3
   --
   -- pi_name           e:\utl_file
   -- pi_sep_on_end     TRUE
   -- pi_separator      /
   --
   -- l_retval          e:/utl_file/
   --   
    
   
      l_retval := REPLACE(pi_name,'\',l_sep); --'
      l_retval := REPLACE(pi_name,'/',l_sep);
 
     --------------------------------------------------------------
     -- Ensure that the directory/file name has/hasn't a separator on the end
     --------------------------------------------------------------
     IF pi_sep_on_end THEN
       IF  substr(l_retval,length(l_retval),1)= l_sep then -- already has sep 
          Null;
       ELSE
        l_retval := l_retval||l_sep;  -- append sep
       END IF;
     ELSE
       IF  substr(l_retval,length(l_retval),1)= l_sep then -- remove sep
          l_retval := substr(l_retval,1,length(l_retval)-1);
       ELSE -- already without sep
          Null;  
       END IF;
     END IF;
     
     RETURN(l_retval);
   
END parse_dir_and_or_filename;
--
-----------------------------------------------------------------------------
-- 
procedure check_directory_valid( pi_dir_name in varchar2 ) is
  l_ora_dir varchar2(2000) := nvl(nm3file.get_true_dir_name(pi_loc => pi_dir_name, pi_use_hig => false),'<NULL>') ;
  l_hig_dir varchar2(2000) := nvl(nm3file.get_true_dir_name(pi_loc => pi_dir_name, pi_use_hig => true ),'<Null>') ;
begin
  if l_ora_dir <> l_hig_dir then
    raise_application_error(-20000,pi_dir_name || ': Oracle and Highways directory definitions are not aligned properly, please contact your system administrator'
                            || chr(10) || 'Oracle = ' ||  l_ora_dir || chr(10) || 'Highways = ' || l_hig_dir );
  end if ;
  if substr(l_ora_dir,-1) <> c_dirrepstrn then
    raise_application_error(-20000,'Directory names must end with a delimiter : "' || c_dirrepstrn || '", please contact your system administrator' ); 
  end if ;
end check_directory_valid ;
--
-----------------------------------------------------------------------------
--
END nm3file;
/
