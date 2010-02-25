CREATE OR REPLACE PACKAGE BODY nm3doc_files
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3doc_files.pkb-arc   2.5   Feb 25 2010 13:56:14   aedwards  $
--       Module Name      : $Workfile:   nm3doc_files.pkb  $
--       Date into PVCS   : $Date:   Feb 25 2010 13:56:14  $
--       Date fetched Out : $Modtime:   Feb 25 2010 13:55:54  $
--       Version          : $Revision:   2.5  $
--       Based on SCCS version :
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid CONSTANT VARCHAR2(2000) := '$Revision:   2.5  $';
  g_package_name CONSTANT varchar2(30) := 'nm3doc_files';
--
  g_sep      VARCHAR2(1) := NVL(hig.get_sysopt('DIRREPSTRN'),'\');
  g_dir_move VARCHAR2(1) := NVL(hig.get_sysopt('DIRMOVE'),'N');
  g_win_sep  VARCHAR2(1) := '\';
--
  g_table_name          user_tables.table_name%TYPE         := 'DOC_FILES_ALL';
  g_column_name         user_tab_columns.column_name%TYPE   := 'DF_CONTENT';
  g_pk_column           user_tab_columns.column_name%TYPE   := 'DF_DOC_ID';
  g_revision_col        user_tab_columns.column_name%TYPE   := 'DF_REVISION';
--
  g_dot_table_name      user_tables.table_name%TYPE         := 'DOC_TEMPLATE_FILES_ALL';
  g_dot_column_name     user_tab_columns.column_name%TYPE   := 'DTF_CONTENT';
  g_dot_pk_column       user_tab_columns.column_name%TYPE   := 'DTF_TEMPLATE_NAME';
  g_dot_revision_col    user_tab_columns.column_name%TYPE   := 'DTF_REVISION';
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
--------------------------------------------------------------------------------
--
  FUNCTION get_max_revision (pi_doc_id IN doc_files_all.df_doc_id%TYPE)
  RETURN NUMBER
  IS
    retval NUMBER;
  BEGIN
  --
    SELECT MAX(df_revision) INTO retval FROM doc_files_all
     WHERE df_doc_id = pi_doc_id;
    RETURN NVL(retval,1);
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN RAISE_APPLICATION_ERROR (-20201,'Cannot derive a revision for '||pi_doc_id);
  END get_max_revision;
--
--------------------------------------------------------------------------------
--
--  FUNCTION get_max_dot_revision (pi_template_name IN doc_template_files_all.dtf_template_name%TYPE)
--  RETURN NUMBER
--  IS
--    retval NUMBER;
--  BEGIN
--  --
--    SELECT MAX(dtf_revision) INTO retval FROM doc_template_files_all
--     WHERE dtf_template_name = pi_template_name;
--    RETURN NVL(retval,1);
--  EXCEPTION
--    WHEN NO_DATA_FOUND
--    THEN RAISE_APPLICATION_ERROR (-20201,'Cannot derive a revision for '||pi_template_name);
--  END get_max_dot_revision;
--
--------------------------------------------------------------------------------
--
--  PROCEDURE insert_temp ( pi_blob IN BLOB ) IS
--  BEGIN
--    INSERT INTO doc_files_tmp
--       (dft_id, dft_content)
--    SELECT dft_id_seq.NEXTVAL
--         , pi_blob
--      FROM dual;
--  END insert_temp;
--
--------------------------------------------------------------------------------
--
  PROCEDURE blob2file ( pi_doc_id    IN doc_files_all.df_doc_id%TYPE
                      , pi_revision  IN doc_files_all.df_revision%TYPE
                      , pi_directory IN VARCHAR2
                      , pi_filename  IN VARCHAR2);
--
--------------------------------------------------------------------------------
-- Return just the filename portion of the full path and filename
--
  FUNCTION strip_filename ( pi_full_path_and_file IN VARCHAR2 )
  RETURN VARCHAR2
  IS
    retval nm3type.max_varchar2;
  BEGIN
    retval := SUBSTR(pi_full_path_and_file
             ,INSTR(pi_full_path_and_file,g_sep,-1)+1);
    retval := SUBSTR(retval
             ,INSTR(retval,g_win_sep,-1)+1);
    RETURN retval ;
  END strip_filename;
--
--------------------------------------------------------------------------------
-- Insert a row in doc_files_all
--
  PROCEDURE insert_df ( pi_rec_df IN doc_files_all%ROWTYPE )
  IS
    l_rec_df doc_files_all%ROWTYPE;
  BEGIN
  --
    l_rec_df.df_doc_id        := pi_rec_df.df_doc_id;
    l_rec_df.df_revision      := NVL(pi_rec_df.df_revision,1);
    l_rec_df.df_start_date    := NVL(pi_rec_df.df_start_date,nm3user.get_effective_date);
    l_rec_df.df_content       := pi_rec_df.df_content;
    l_rec_df.df_full_path     := pi_rec_df.df_full_path;
    l_rec_df.df_filename      := strip_filename(pi_rec_df.df_full_path);
    l_rec_df.df_file_info     := NVL(pi_rec_df.df_file_info, LENGTH(pi_rec_df.df_content));
    l_rec_df.df_date_created  := nm3user.get_effective_date;
    l_rec_df.df_date_modified := l_rec_df.df_date_created;
    l_rec_df.df_created_by    := USER;
    l_rec_df.df_modified_by   := USER;
  --
    INSERT INTO doc_files_all VALUES l_rec_df;
  --
  END insert_df;
--
--------------------------------------------------------------------------------
-- Insert a row in doc_template_files_all
--
--  PROCEDURE insert_dtf ( pi_rec_dtf IN doc_template_files_all%ROWTYPE )
--  IS
--    l_rec_dtf doc_template_files_all%ROWTYPE;
--  BEGIN
--  --
--    l_rec_dtf.dtf_template_name := pi_rec_dtf.dtf_template_name;
--    l_rec_dtf.dtf_revision      := NVL(pi_rec_dtf.dtf_revision,1);
--    l_rec_dtf.dtf_start_date    := NVL(pi_rec_dtf.dtf_start_date,nm3user.get_effective_date);
--    l_rec_dtf.dtf_content       := pi_rec_dtf.dtf_content;
--    l_rec_dtf.dtf_filename      := strip_filename(pi_rec_dtf.dtf_filename);
--    l_rec_dtf.dtf_file_info     := pi_rec_dtf.dtf_file_info;
--    l_rec_dtf.dtf_date_created  := nm3user.get_effective_date;
--    l_rec_dtf.dtf_date_modified := nm3user.get_effective_date;
--    l_rec_dtf.dtf_created_by    := USER;
--    l_rec_dtf.dtf_modified_by   := USER;
--  --
--    INSERT INTO doc_template_files_all VALUES l_rec_dtf;
--  --
--  END insert_dtf;
--
--------------------------------------------------------------------------------
-- Insert a row in doc_files
--
  FUNCTION get_df ( pi_df_doc_id IN doc_files_all.df_doc_id%TYPE
                  , pi_df_revision IN doc_files_all.df_revision%TYPE )
  RETURN doc_files_all%ROWTYPE
  IS
    l_rec_df doc_files_all%ROWTYPE;
  BEGIN
  --
    SELECT * INTO l_rec_df FROM doc_files_all
     WHERE df_doc_id = pi_df_doc_id
       AND df_revision = pi_df_revision;
    RETURN l_rec_df;
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN RETURN l_rec_df;
  --
  END get_df;
  --
--------------------------------------------------------------------------------
-- Get a row from doc_template_files_all
--
--  FUNCTION get_dtf ( pi_dtf_template_name IN doc_template_files_all.dtf_template_name%TYPE
--                   , pi_dtf_revision      IN doc_template_files_all.dtf_revision%TYPE )
--  RETURN doc_template_files_all%ROWTYPE
--  IS
--    l_rec_dtf doc_template_files_all%ROWTYPE;
--  BEGIN
--  --
--    SELECT * INTO l_rec_dtf FROM doc_template_files_all
--     WHERE dtf_template_name = pi_dtf_template_name
--       AND dtf_revision = pi_dtf_revision;
--    RETURN l_rec_dtf;
--  EXCEPTION
--    WHEN NO_DATA_FOUND
--    THEN RETURN l_rec_dtf;
--  --
--  END get_dtf;
--
--------------------------------------------------------------------------------
--
  FUNCTION move_file_to_blob ( pi_filename IN VARCHAR2
                             , pi_location IN VARCHAR2 )
  RETURN BLOB
  IS
    v_blob    BLOB ;--:= EMPTY_BLOB();
    l_bfile   BFILE;
    amt       NUMBER;
    location  VARCHAR2(30)    := pi_location;
    filename  VARCHAR2(2000)  := pi_filename;
  BEGIN
    l_bfile := BFILENAME(location, filename);
    dbms_lob.createtemporary(lob_loc => v_blob, CACHE => FALSE);
    amt := dbms_lob.getlength( l_bfile );
    dbms_lob.fileopen( l_bfile ,dbms_lob.file_readonly);
    nm_debug.debug('move_file_to_blob - before loadfromfile');
    dbms_lob.loadfromfile( v_blob, l_bfile ,amt);
    nm_debug.debug('move_file_to_blob - after loadfromfile');
    dbms_lob.fileclose( l_bfile );
    RETURN v_blob;
  END move_file_to_blob;
--
--------------------------------------------------------------------------------
--
  PROCEDURE move_file_to_blob ( pi_doc_id IN docs.doc_id%TYPE )
  IS
    location  VARCHAR2(30);
    filename  VARCHAR2(2000);
  BEGIN
  --
--    nm_debug.debug_on;
    nm_debug.debug('move_file_to_blob - start');
  --
    SELECT dlc_name, df_filename INTO location, filename
      FROM doc_locations, docs, doc_files_all
     WHERE dlc_id = doc_dlc_id
       AND doc_id = df_doc_id
       AND df_doc_id = pi_doc_id;
  --
    nm_debug.debug('move_file_to_blob - before table update');
    UPDATE doc_files_all
       SET df_content = move_file_to_blob ( filename, location )
         , df_audit = 'Updated by "move_file_to_blob" on '||to_char(sysdate,'DD-MON-YYYY HH24:MI:SS')||' by '||user
     WHERE df_doc_id = pi_doc_id
       AND df_revision = 1;--get_max_revision(pi_doc_id);
    nm_debug.debug('move_file_to_blob - after table update');
     --COMMIT;
  END move_file_to_blob;
--
--------------------------------------------------------------------------------
--
  FUNCTION does_df_exist ( pi_doc_id IN doc_files_all.df_doc_id%TYPE
                         , pi_revision IN doc_files_all.df_revision%TYPE )
  RETURN BOOLEAN
  IS
    l_temp NUMBER;
    CURSOR c1 IS
      SELECT COUNT(*) FROM doc_files_all
       WHERE df_doc_id = pi_doc_id
         AND df_revision = pi_revision;
  BEGIN
    OPEN c1; FETCH c1 INTO l_temp; CLOSE c1;
    RETURN (l_temp > 0);
  END does_df_exist;

--
--------------------------------------------------------------------------------
--
  PROCEDURE get_filename_and_location ( pi_doc_id IN docs.doc_id%TYPE
                                      , po_filename OUT VARCHAR2
                                      , po_location OUT VARCHAR )
  IS
    retval nm3type.max_varchar2;
  BEGIN
    SELECT a.filename, b.dlc_name
      INTO po_filename, po_location
      FROM
      (SELECT doc_id, doc_dlc_id,
              CASE
              WHEN instr(doc_file,'.') = 0
              THEN
                ( SELECT doc_file||'.'||dmd_file_extension
                    FROM doc_media
                   WHERE dmd_id = doc_dlc_dmd_id )
              ELSE
                doc_file
              END AS filename
      FROM docs
     ) a, doc_locations b
        , hig_directories h
     WHERE filename IS NOT NULL
       AND doc_id = pi_doc_id
       AND doc_dlc_id = dlc_id
       AND dlc_name = hdir_name;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      po_location := NULL;
      po_filename := NULL;
  END get_filename_and_location;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_doc_start_date ( pi_doc_id IN docs.doc_id%TYPE ) RETURN docs.doc_date_issued%TYPE
  IS
    retval docs.doc_date_issued%TYPE;
  BEGIN
    SELECT doc_date_issued INTO retval FROM docs
     WHERE doc_id = pi_doc_id;
    RETURN retval;
  END get_doc_start_date;
--
--------------------------------------------------------------------------------
--  Work out which table to load the file into for upload from client
--
  PROCEDURE get_upload_info
              ( pi_doc_id          IN docs.doc_id%TYPE
              , po_table_name     OUT user_tables.table_name%TYPE
              , po_column_name    OUT user_tab_columns.column_name%TYPE
              , po_pk_column      OUT user_tab_columns.column_name%TYPE
              , po_where_clause   OUT VARCHAR2
              , po_prog_title     OUT VARCHAR2
              , po_prog_sub_title OUT VARCHAR2 )
  IS
  --
    l_where_clause        nm3type.max_varchar2                := g_pk_column||'='||pi_doc_id;
    l_progress_title      nm3type.max_varchar2                := 'Uploading ... Please Wait';
    l_progress_sub_title  nm3type.max_varchar2;
  --
  BEGIN
  --
    l_where_clause := g_pk_column    ||' = '||pi_doc_id||' AND '||
                      g_revision_col ||' = '||get_max_revision (pi_doc_id);
  --
    po_table_name     := g_table_name;
    po_column_name    := g_column_name;
    po_pk_column      := g_pk_column;
    po_where_clause   := l_where_clause;
    po_prog_title     := l_progress_title;
    po_prog_sub_title := l_progress_sub_title;
  --
  END get_upload_info;
--
--------------------------------------------------------------------------------
--  Provide the info WebUtil needs to download the file to the client
--
  PROCEDURE get_download_info
              ( pi_doc_id          IN docs.doc_id%TYPE
              , po_client_file    OUT VARCHAR2
              , po_working_folder OUT VARCHAR2
              , po_table_name     OUT user_tables.table_name%TYPE
              , po_column_name    OUT user_tab_columns.column_name%TYPE
              , po_where_clause   OUT VARCHAR2
              , po_prog_title     OUT VARCHAR2
              , po_prog_sub_title OUT VARCHAR2 )
  IS
  --
    l_client_file         nm3type.max_varchar2;
    l_where_clause        nm3type.max_varchar2 := (g_pk_column)||'='||pi_doc_id;
    l_progress_title      nm3type.max_varchar2 := 'Downloading To Client ... Please Wait';
    l_progress_sub_title  nm3type.max_varchar2;
    l_location            nm3type.max_varchar2;
    l_filename            nm3type.max_varchar2;
  --
    l_rec_df              doc_files_all%ROWTYPE;
  --
    ex_no_file            EXCEPTION;
    ex_cannot_find_file   EXCEPTION;
  --
  BEGIN
  --
    IF does_df_exist ( pi_doc_id, get_max_revision(pi_doc_id) )
    THEN
    --
    -- DOC_FILES_ALL record exists
    --
      l_where_clause := g_pk_column    ||' = '||pi_doc_id||' AND '||
                        g_revision_col ||' = '||get_max_revision (pi_doc_id);
    --
      po_client_file    := get_df ( pi_doc_id, get_max_revision(pi_doc_id) ).df_filename;
      po_working_folder := get_work_folder ;
      po_table_name     := g_table_name;
      po_column_name    := g_column_name;
      po_where_clause   := l_where_clause;
      po_prog_title     := l_progress_title;
      po_prog_sub_title := l_progress_sub_title;
    --
    ELSE
    --
    -- Does not exist - load the file up into the table and
    -- create the DOC_FILES_ALL record.
    --
      get_filename_and_location (pi_doc_id, l_filename, l_location);
    --
      IF l_filename IS NOT NULL
      AND l_location IS NOT NULL
      THEN
      --
        IF nm3file.file_exists(l_location, l_filename) = 'N'
        THEN
          RAISE ex_cannot_find_file;
        END IF;
      --
        l_rec_df.df_doc_id      := pi_doc_id;
        l_rec_df.df_revision    := 1;
        l_rec_df.df_content     := move_file_to_blob(l_filename, l_location);
        l_rec_df.df_start_date  := get_doc_start_date (pi_doc_id);
        l_rec_df.df_filename    := l_filename;
        l_rec_df.df_full_path   := nm3file.get_true_dir_name(l_location)||g_sep||l_filename;
      --
        insert_df (l_rec_df);
      --
        l_where_clause := g_pk_column    ||' = '||pi_doc_id||' AND '||
                          g_revision_col ||' = '||get_max_revision (pi_doc_id);
      --
        po_client_file    := l_filename;
        po_working_folder := get_work_folder ;
        po_table_name     := g_table_name;
        po_column_name    := g_column_name;
        po_where_clause   := l_where_clause;
        po_prog_title     := l_progress_title;
        po_prog_sub_title := l_progress_sub_title;
      --
      ELSE
        RAISE ex_no_file;
      END IF;
    --
    END IF;
  --
  EXCEPTION
    WHEN ex_no_file
      THEN raise_application_error (-20101
                                   ,'DOC_ID ['||pi_doc_id||'] has a null DOC_FILE entry');
    WHEN ex_cannot_find_file
      THEN raise_application_error (-20102
                                   ,'Cannot read file ['||l_filename
                                  ||'] from location ['||l_location ||']');
  END get_download_info;
--
--------------------------------------------------------------------------------
--  Download the file from the BLOB into an Oracle directory
--
  PROCEDURE download_from_blob_to_file
                                 ( pi_doc_id    IN doc_files_all.df_doc_id%TYPE
                                 , pi_revision  IN doc_files_all.df_revision%TYPE
                                 , pi_directory IN VARCHAR2
                                 , pi_filename  IN VARCHAR2)
  IS
    l_directory       nm3type.max_varchar2;
    ex_no_dir_found   EXCEPTION;
    ex_no_directory   EXCEPTION;
  BEGIN
  --
    IF pi_directory IS NULL
    THEN
      RAISE ex_no_directory;
    END IF;
  --
    BEGIN
      ------------------------------------
      -- Using an Oracle directory
      SELECT hdir_name INTO l_directory
        FROM hig_directories
       WHERE hdir_path = CASE
                           WHEN INSTR(pi_directory,g_sep) > 0
                             THEN pi_directory
                           ELSE hdir_path
                         END
         AND hdir_name = CASE
                           WHEN INSTR(pi_directory,g_sep) = 0
                             THEN pi_directory
                           ELSE hdir_name
                         END;
    --
    EXCEPTION
      WHEN NO_DATA_FOUND
      THEN RAISE ex_no_dir_found;
    END;
  --
    blob2file
      ( pi_doc_id    => pi_doc_id
      , pi_revision  => pi_revision
      , pi_directory => l_directory
      , pi_filename  => strip_filename(pi_filename) );
  --
  EXCEPTION
    WHEN ex_no_dir_found
    THEN
      RAISE_APPLICATION_ERROR
        ( -20101,'Please define ['||pi_directory||'] as a HIG_DIRECTORY');
    WHEN ex_no_directory
    THEN
      RAISE_APPLICATION_ERROR
        ( -20102,'Please define a directory !');
  --
  END download_from_blob_to_file;
--
--------------------------------------------------------------------------------
-- Private procedure borrowed from nm3file to write the blob into a file
--
  PROCEDURE write_blob
    ( p_blob       IN OUT NOCOPY BLOB
    , p_file_loc   IN VARCHAR2
    , p_file_name  IN VARCHAR2
    )
  IS
    --l_buffer        RAW(16383);
    l_buffer        RAW (32766);
    --l_buffer_size   CONSTANT BINARY_INTEGER := 16383;
    l_buffer_size   CONSTANT BINARY_INTEGER := 32767;
    l_amount        BINARY_INTEGER;
    l_offset        NUMBER(38);
    l_file_handle   UTL_FILE.FILE_TYPE;
    invalid_directory_path EXCEPTION;
    PRAGMA EXCEPTION_INIT(invalid_directory_path, -29280);
  --
  BEGIN
  --
    l_file_handle := UTL_FILE.FOPEN(p_file_loc, p_file_name, 'w', 32760);
    l_amount := l_buffer_size;
    l_offset := 1;
  --
    BEGIN
  --
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

--    EXCEPTION
--
--      WHEN others THEN
--        UTL_FILE.PUT_LINE(file => l_file_handle, buffer => '+----------------------------+');
--        UTL_FILE.PUT_LINE(file => l_file_handle, buffer => '|      ***   ERROR   ***     |');
--        UTL_FILE.PUT_LINE(file => l_file_handle, buffer => '+----------------------------+');
--        UTL_FILE.NEW_LINE(file => l_file_handle);
--        UTL_FILE.PUT_LINE(file => l_file_handle, buffer => 'WHEN OTHERS ERROR');
--        UTL_FILE.PUT_LINE(file => l_file_handle, buffer => '=================');
--        UTL_FILE.PUT_LINE(file => l_file_handle, buffer => '    --> SQL CODE          : ' || SQLCODE);
--        UTL_FILE.PUT_LINE(file => l_file_handle, buffer => '    --> SQL ERROR MESSAGE : ' || SQLERRM);
--        UTL_FILE.FFLUSH(file => l_file_handle);


    END ;

    UTL_FILE.FCLOSE(l_file_handle);

--  EXCEPTION
--
--    WHEN invalid_directory_path THEN
--      raise_application_error(-20001,'** ERROR ** : Invalid Directory Path: ' || p_file_loc);

  END write_blob;
--
--------------------------------------------------------------------------------
--
--
  PROCEDURE write_blob2
    ( p_blob       IN OUT NOCOPY BLOB
    , p_file_loc   IN VARCHAR2
    , p_file_name  IN VARCHAR2
    )
  IS
    vblob           BLOB;
    vstart          NUMBER := 1;
    bytelen         NUMBER := 32000;
    len             NUMBER;
    my_vr           RAW(32000);
    x               NUMBER;
    l_file_handle   utl_file.file_type;

  BEGIN

--  --
    nm_debug.debug_on;
    nm_debug.debug('filename = '||p_file_name);
  --
    l_file_handle := UTL_FILE.FOPEN(p_file_loc, p_file_name, 'w', 32760);

    vstart := 1;
    bytelen := 32000;

    -- get length of blob
    len := dbms_lob.getlength(p_blob);

    -- save blob length
    x := len;

    -- select blob into variable
    vblob := p_blob;

    -- if small enough for a single write
    IF len < 32760
    THEN
      utl_file.put_raw(l_file_handle,vblob);
      utl_file.fflush(l_file_handle);
    ELSE -- write in pieces
      vstart := 1;
      WHILE vstart < len and bytelen > 0
      LOOP
        dbms_lob.read(vblob,bytelen,vstart,my_vr);

        utl_file.put_raw(l_file_handle,my_vr);
        utl_file.fflush(l_file_handle);

        -- set the start position for the next cut
        vstart := vstart + bytelen;

        -- set the end position if less than 32000 bytes
        x := x - bytelen;
        IF x < 32000 THEN
          bytelen := x;
        END IF;

      END LOOP;

    END IF;

    utl_file.fclose(l_file_handle);



  END write_blob2;
--
--------------------------------------------------------------------------------
--
  PROCEDURE write_blob3
    ( p_blob       IN OUT NOCOPY BLOB
    , p_file_loc   IN VARCHAR2
    , p_file_name  IN VARCHAR2
    )

  IS
    t_blob       BLOB    := p_blob;
    t_len        NUMBER;
    t_file_name  VARCHAR2(2000)       := p_file_name;
    t_output     UTL_FILE.file_type;
    t_TotalSize  NUMBER;
    t_position   NUMBER := 1;
    t_chucklen   NUMBER := 4096;
    t_chuck      RAW(4096);
    t_remain     NUMBER;
  BEGIN
  -- Get length of blob
    t_TotalSize := DBMS_LOB.getlength (t_blob);
    t_remain := t_TotalSize;

  -- The directory p_file_loc should exist before executing
    t_output := UTL_FILE.fopen (p_file_loc, t_file_name, 'wb', 32760);

  -- Retrieving BLOB
    WHILE t_position < t_TotalSize
     LOOP
      DBMS_LOB.READ (t_blob, t_chucklen, t_position, t_chuck);
      UTL_FILE.put_raw (t_output, t_chuck);
      UTL_FILE.fflush (t_output);
      t_position := t_position + t_chucklen;
      t_remain := t_remain - t_chucklen;
      IF t_remain < 4096
      THEN
      t_chucklen := t_remain;
      END IF;
    END LOOP;
    utl_file.fclose(t_output);
  END write_blob3;
--
--------------------------------------------------------------------------------
--
  PROCEDURE blob2file
                      ( pi_doc_id    IN doc_files_all.df_doc_id%TYPE
                      , pi_revision  IN doc_files_all.df_revision%TYPE
                      , pi_directory IN VARCHAR2
                      , pi_filename  IN VARCHAR2)
  IS
    vblob   BLOB;
  BEGIN
    SELECT df_content INTO vblob
      FROM doc_files_all
     WHERE df_doc_id = pi_doc_id
       AND df_revision =
         CASE
           WHEN pi_revision IS NOT NULL
             THEN pi_revision
           ELSE
             (SELECT MAX(df_revision) FROM doc_files_all
               WHERE df_doc_id = pi_doc_id)
         END;
  --doc_file_locks
    write_blob3
      ( p_blob      => vblob
      , p_file_loc  => pi_directory
      , p_file_name => pi_filename
      );
  --
  END blob2file;
--
--------------------------------------------------------------------------------
-- Create a doc_file_locks record
--
  PROCEDURE lock_file
               ( pi_rec_dfl IN doc_file_locks%ROWTYPE )
  IS
  BEGIN
    INSERT INTO doc_file_locks VALUES pi_rec_dfl;
  END lock_file;
--
--------------------------------------------------------------------------------
-- Get a doc_file_locks record
--
  FUNCTION get_dfl
               ( pi_dfl_doc_id   IN doc_file_locks.dfl_doc_id%TYPE
               , pi_dfl_revision IN doc_file_locks.dfl_revision%TYPE )
  RETURN doc_file_locks%ROWTYPE
  IS
    retval doc_file_locks%ROWTYPE;
  BEGIN
    SELECT * INTO retval FROM doc_file_locks
        WHERE dfl_doc_id = pi_dfl_doc_id
          AND dfl_revision = pi_dfl_revision;
    RETURN retval;
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN RETURN retval;
  END get_dfl;
--
--------------------------------------------------------------------------------
-- Lock a file based on DOC_ID and Revision
--
  PROCEDURE lock_file
               ( pi_dfl_doc_id   IN doc_file_locks.dfl_doc_id%TYPE
               , pi_dfl_revision IN doc_file_locks.dfl_revision%TYPE
               , pi_terminal     IN VARCHAR2 DEFAULT NULL )
  IS
    l_temp_dfl doc_file_locks%ROWTYPE;
  BEGIN
  --
    INSERT INTO doc_file_locks
      ( dfl_doc_id, dfl_revision, dfl_username, dfl_date, dfl_terminal )
    VALUES
      ( pi_dfl_doc_id , pi_dfl_revision, USER, SYSDATE, NVL(pi_terminal,NVL(SYS_CONTEXT ('USERENV', 'TERMINAL'),'Unknown')));
  --
  EXCEPTION
  -- File already locked
  --
    WHEN DUP_VAL_ON_INDEX
      THEN
      l_temp_dfl := get_dfl ( pi_dfl_doc_id, pi_dfl_revision);
      RAISE_APPLICATION_ERROR
        ( -20301
         ,'Document file is already locked by '
              ||l_temp_dfl.dfl_username ||' on '
              ||l_temp_dfl.dfl_date );
  --
  END lock_file;
--
--------------------------------------------------------------------------------
-- Is the file (based on DOC_ID and Revision) locked already?
--
  FUNCTION is_file_locked
              ( pi_dfl_doc_id   IN doc_file_locks.dfl_doc_id%TYPE
              , pi_dfl_revision IN doc_file_locks.dfl_revision%TYPE )
    RETURN BOOLEAN
  IS
  BEGIN
  --
    RETURN get_dfl ( pi_dfl_doc_id, pi_dfl_revision).dfl_doc_id IS NOT NULL;
  --
  END is_file_locked;
--
--------------------------------------------------------------------------------
--
  PROCEDURE get_file_lock_info
              ( pi_dfl_doc_id   IN  doc_file_locks.dfl_doc_id%TYPE
              , pi_dfl_revision IN  doc_file_locks.dfl_revision%TYPE
              , po_filename     OUT doc_files_all.df_filename%TYPE
              , po_username     OUT doc_file_locks.dfl_username%TYPE
              , po_date         OUT doc_file_locks.dfl_date%TYPE)
  IS
    l_filename nm3type.max_varchar2;
    l_username VARCHAR2(30);
    l_date     DATE;
  BEGIN
    SELECT df_filename, dfl_username, dfl_date
      INTO l_filename, l_username, l_date
      FROM doc_file_locks, doc_files_all
     WHERE df_doc_id = dfl_doc_id
       AND df_revision = dfl_revision
       AND dfl_doc_id = pi_dfl_doc_id
       AND dfl_revision = pi_dfl_revision;
  --
    po_filename := l_filename;
    po_username := l_username;
    po_date     := l_date;
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
      po_filename := NULL;
      po_username := NULL;
      po_date     := NULL;
  END get_file_lock_info;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_wildcard ( pi_wildcard IN VARCHAR2
                        , pi_description IN VARCHAR2 DEFAULT NULL )
  RETURN VARCHAR2
  IS
  BEGIN
--    RETURN ('|'||pi_wildcard||'|'||NVL(pi_description,pi_wildcard)||'|' );
    RETURN ('|'||NVL(pi_description,pi_wildcard)||'|'||pi_wildcard||'|' );
  END get_wildcard;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_file_size ( pi_doc_id    IN doc_files_all.df_doc_id%TYPE
                         , pi_revision  IN doc_files_all.df_revision%TYPE
                         , pi_formatted IN BOOLEAN DEFAULT FALSE )
  RETURN VARCHAR2
  IS
    retval      nm3type.max_varchar2;
    l_formatted VARCHAR2(15) := nm3flx.boolean_to_char( pi_formatted );
  BEGIN
    SELECT
        --
           CASE
           WHEN l_formatted = nm3type.get_true
           THEN
           --
           -- Return a nice formatted value
           --
             CASE
               --------------------------------------------------------
               -- Bytes
               --------------------------------------------------------
               WHEN LENGTH(df_content) < 1024
               THEN
                 --LENGTH(df_content)||' Bytes'
                 LENGTH(df_content)||' B'
               --------------------------------------------------------
               -- Kilobytes
               ----------------------------------------------------------
               WHEN LENGTH(df_content) < (1024*1024)
               THEN
                 --ROUND(LENGTH(df_content)/1024,0)||' Kilobytes'
                 ROUND(LENGTH(df_content)/1024,0)||' KB'
               --------------------------------------------------------
               -- Megabytes
               --------------------------------------------------------
               WHEN LENGTH(df_content) < (1024*1024*1024)
               THEN
                 --ROUND(LENGTH(df_content)/(1024*1024),2)||' Megabytes'
                 ROUND(LENGTH(df_content)/(1024*1024),2)||' MB'
               --------------------------------------------------------
               -- Gigabytes
               --------------------------------------------------------
               WHEN LENGTH(df_content) < (1024*1024*1024*1024)
               THEN
                 --ROUND(LENGTH(df_content)/(1024*1024*1024),2)||' Gigabytes'
                 ROUND(LENGTH(df_content)/(1024*1024*1024),2)||' GB'
               --------------------------------------------------------
               -- Terrabytes
               --------------------------------------------------------
               WHEN LENGTH(df_content) < (1024*1024*1024*1024*1024)
               THEN
                 ROUND(LENGTH(df_content)/(1024*1024*1024*1024),2)||' TB'
               ELSE
                 LENGTH(df_content)||' Bytes'
             END
           ELSE
           --
           -- Otherwise just return the length in bytes
           --
             LTRIM (TO_CHAR (LENGTH(df_content),'99999999999999'))
           END
        --
      INTO retval
      FROM doc_files_all
     WHERE df_doc_id = pi_doc_id
       AND df_revision = NVL(pi_revision, get_max_revision(pi_doc_id));
  --
    RETURN retval;
  --
  END get_file_size;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_file_size ( pi_doc_id    IN doc_files_all.df_doc_id%TYPE
                         , pi_revision  IN doc_files_all.df_revision%TYPE
                         , pi_formatted IN VARCHAR2 DEFAULT 'N' )
  RETURN VARCHAR2
  IS
  BEGIN
  --
    RETURN ( get_file_size ( pi_doc_id
                           , pi_revision
                           , CASE WHEN pi_formatted = 'N'
                                  THEN FALSE
                                  WHEN pi_formatted = 'Y'
                                  THEN TRUE
                             END ));
  --
  END get_file_size;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_file_size ( pi_doc_id    IN doc_files_all.df_doc_id%TYPE
                         , pi_formatted IN VARCHAR2 DEFAULT 'N' )
  RETURN VARCHAR2
  IS
  BEGIN
  --
    RETURN ( get_file_size ( pi_doc_id
                           , NULL
                           , CASE WHEN pi_formatted = 'N'
                                  THEN FALSE
                                  WHEN pi_formatted = 'Y'
                                  THEN TRUE
                             END ));
  --
  END get_file_size;
--
--------------------------------------------------------------------------------
--
-- Return the size
--    pi_size_in_bytes      Size in Bytes
--    pi_type               Either b for bits, B for Bytes, KB for KBytes, MB for MBytes
--                          GB for GBytes, TB for TBytes
--
--1/1152921504606846976 yottabyte
--1/1125899906842624 zettabyte
--1/1099511627776 exabyte
--1/1073741824 petabyte
--1/1048576 terabyte
--1/1024 gigabyte
--1 megabyte
--8 Megabits
--1024 kilobytes
--8192 Kilobits
--1048576 bytes
--2097152 nibbles
--8388608 bits
--
  FUNCTION get_size ( pi_size_in_bytes IN NUMBER
                    , pi_type          IN VARCHAR2 DEFAULT 'B')
  RETURN NUMBER
  IS
  BEGIN
  --
    RETURN ( CASE
               WHEN pi_type IS NULL
                 THEN pi_size_in_bytes
               WHEN pi_type = 'b'
                 THEN pi_size_in_bytes*8
               WHEN pi_type = 'B'
                 THEN pi_size_in_bytes
               WHEN pi_type = 'MB'
                 THEN pi_size_in_bytes/1024
               WHEN pi_type = 'GB'
                 THEN pi_size_in_bytes/1024/1024
               WHEN pi_type = 'TB'
                 THEN pi_size_in_bytes/1024/1024/1024
               WHEN pi_type = 'GB'
                 THEN pi_size_in_bytes/1024/1024/1024/1024
               ELSE
                 pi_size_in_bytes
             END );
  --
  END get_size;
--
--------------------------------------------------------------------------------
--
  PROCEDURE unlock_file
               ( pi_dfl_doc_id   IN doc_file_locks.dfl_doc_id%TYPE
               , pi_dfl_revision IN doc_file_locks.dfl_revision%TYPE)
  IS
  BEGIN
    IF is_file_locked ( pi_dfl_doc_id, pi_dfl_revision )
    THEN
      DELETE doc_file_locks
       WHERE dfl_doc_id = pi_dfl_doc_id
         AND dfl_revision = pi_dfl_revision;
    ELSE
      RAISE_APPLICATION_ERROR (-20110,'File is not locked');
    END IF;
  END unlock_file;
--
--------------------------------------------------------------------------------
-- Get the users prefered working folder
  FUNCTION get_work_folder RETURN VARCHAR2
  IS
  BEGIN
    --RETURN NVL(hig.get_user_or_sys_opt('WORKFOLDER'),'C:\');
    RETURN hig.get_user_or_sys_opt('WORKFOLDER');
  END get_work_folder;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_dlc (pi_doc_id IN docs.doc_id%TYPE) RETURN doc_locations%ROWTYPE
  IS
    retval doc_locations%ROWTYPE;
  BEGIN
    SELECT * INTO retval FROM doc_locations
      WHERE EXISTS
        (SELECT 1
            FROM docs
           WHERE doc_id = pi_doc_id
             AND dlc_id = doc_dlc_id);
    RETURN retval;
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN RETURN retval;
  END get_dlc;
--
--------------------------------------------------------------------------------
--
--  FUNCTION get_template_hdir ( pi_table_name IN user_tables.table_name%TYPE )
--    RETURN hig_directories.hdir_name%TYPE
--  IS
--    CURSOR c1
--    IS
--      SELECT dtu_template_name
--           , dtu_print_immediately
--           , dtg_dlc_id
--           , dlc_name
--           , dtg_dmd_id
--           , dmd_name
--        FROM doc_template_users
--           , doc_template_gateways
--           , doc_locations
--           , doc_media
--           , hig_directories
--       WHERE dtu_default_template = 'Y'
--         AND dtu_user_id = (SELECT hus_user_id
--                              FROM hig_users
--                             WHERE hus_username = USER)
--         AND dtu_template_name = dtg_template_name
--         AND dtg_table_name = pi_table_name
--         AND dlc_id = dtg_dlc_id
--         AND dmd_id = dtg_dmd_id
--         AND hdir_name = dlc_name;
--  --
--    l_rec_c1  c1%ROWTYPE;
--  --
--  BEGIN
--  --
--    OPEN c1;
--    FETCH c1 INTO l_rec_c1;
--    CLOSE c1;
--  --
--    RETURN l_rec_c1.dlc_name;
--  --
--  END get_template_hdir;
--
--------------------------------------------------------------------------------
-- Load a template from an existing location/file into DOC_TEMPLATE_FILES_ALL table
--  PROCEDURE load_dtf ( pi_filename      IN doc_template_files_all.dtf_filename%TYPE
--                     , pi_location      IN VARCHAR2
--                     , pi_template_name IN doc_template_files_all.dtf_template_name%TYPE)
--  IS
--    l_rec_dtf doc_template_files_all%ROWTYPE;
--  BEGIN
--  --
--    l_rec_dtf.dtf_template_name := pi_template_name;
--    l_rec_dtf.dtf_filename      := pi_filename;
--    l_rec_dtf.dtf_revision      := 1;
--    l_rec_dtf.dtf_content       := move_file_to_blob ( pi_filename, pi_location);
--    l_rec_dtf.dtf_file_info     := LENGTH(l_rec_dtf.dtf_content);
--  --
--    insert_dtf ( l_rec_dtf );
--  --
--  END load_dtf;
--
--------------------------------------------------------------------------------
--
--  PROCEDURE get_template_download_info
--                ( pi_template_name   IN doc_template_files_all.dtf_template_name%TYPE
--                , po_client_file    OUT VARCHAR2
--                , po_working_folder OUT VARCHAR2
--                , po_table_name     OUT user_tables.table_name%TYPE
--                , po_column_name    OUT user_tab_columns.column_name%TYPE
--                , po_where_clause   OUT VARCHAR2
--                , po_prog_title     OUT VARCHAR2
--                , po_prog_sub_title OUT VARCHAR2 )
--  IS
-- --
--    l_client_file         nm3type.max_varchar2;
--    l_where_clause        nm3type.max_varchar2 ;
--    l_progress_title      nm3type.max_varchar2 := 'Downloading To Client ... Please Wait';
--    l_progress_sub_title  nm3type.max_varchar2;
--  --
--  BEGIN
--  --
--    l_where_clause := g_dot_pk_column    ||' = '||nm3flx.string(pi_template_name)||' AND '||
--                      g_dot_revision_col ||' = '||get_max_dot_revision (pi_template_name);
--  --
--    --move_file_to_blob ( pi_doc_id );
--  --
--    po_client_file    := get_dtf ( pi_template_name, get_max_dot_revision(pi_template_name) ).dtf_filename;
--    po_working_folder := NVL(hig.get_user_or_sys_opt('WORKFOLDER'),'C:\') ;
--    po_table_name     := g_dot_table_name;
--    po_column_name    := g_dot_column_name;
--    po_where_clause   := l_where_clause;
--    po_prog_title     := l_progress_title;
--    po_prog_sub_title := l_progress_sub_title;
--  --
--  END get_template_download_info;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_dlc_table (pi_doc_id IN docs.doc_id%TYPE) RETURN doc_location_tables.dlt_table%TYPE
   IS
    retval doc_location_tables.dlt_table%TYPE;
  BEGIN
    SELECT dlt_table INTO retval FROM doc_location_tables, docs
     WHERE dlt_dlc_id = doc_dlc_id
       AND doc_id = pi_doc_id;
    RETURN retval;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN NULL;
  END get_dlc_table;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_dlc_table (pi_dlc_id IN doc_locations.dlc_id%TYPE) RETURN doc_location_tables.dlt_table%TYPE
   IS
    retval doc_location_tables.dlt_table%TYPE;
  BEGIN
    SELECT dlt_table INTO retval FROM doc_location_tables
     WHERE dlt_dlc_id = pi_dlc_id;
    RETURN retval;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN NULL;
  END get_dlc_table;
--
--------------------------------------------------------------------------------
--
  PROCEDURE set_doc_location_table ( pi_dlc_id IN doc_locations.dlc_id%TYPE
                                   , pi_flag   IN BOOLEAN )
  IS
  BEGIN
  --
    IF pi_flag
    THEN
      IF get_dlc_table ( pi_dlc_id => pi_dlc_id) IS NULL
      THEN
        INSERT INTO doc_location_tables
        SELECT dlt_id_seq.nextval
             , pi_dlc_id
             , 'DOC_FILES_ALL'
             , 'DF_DOC_ID'
             , 'DF_CONTENT'
             , 'DF_REVISION'
             , 'DF_START_DATE'
             , 'DF_END_DATE'
             , 'DF_FULL_PATH'
             , 'DF_FILENAME'
             , 'DF_AUDIT_COL'
             , 'DF_FILE_INFO'
           FROM dual;
      END IF;
    --
    ELSE
    --
      DELETE doc_location_tables
       WHERE dlt_dlc_id = pi_dlc_id
         AND dlt_table = 'DOC_FILES_ALL';
    --
    END IF;
  --
  END set_doc_location_table;
--
--------------------------------------------------------------------------------
--
END nm3doc_files;
/
