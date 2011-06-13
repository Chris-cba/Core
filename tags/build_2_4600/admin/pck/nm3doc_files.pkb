CREATE OR REPLACE PACKAGE BODY nm3doc_files
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3doc_files.pkb-arc   2.12   Jun 13 2011 10:11:32   Ade.Edwards  $
--       Module Name      : $Workfile:   nm3doc_files.pkb  $
--       Date into PVCS   : $Date:   Jun 13 2011 10:11:32  $
--       Date fetched Out : $Modtime:   Jun 13 2011 10:08:52  $
--       Version          : $Revision:   2.12  $
--       Based on SCCS version :
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid     CONSTANT VARCHAR2(2000) := '$Revision:   2.12  $';
  g_package_name    CONSTANT VARCHAR2(30)   := 'nm3doc_files';
--
  g_sep                      VARCHAR2(1)    := NVL(hig.get_sysopt('DIRREPSTRN'),'\');
  g_dir_move                 VARCHAR2(1)    := NVL(hig.get_sysopt('DIRMOVE'),'N');
  g_win_sep                  VARCHAR2(1)    := '\';
  g_temp_load_table          VARCHAR2(30)   := 'DOC_FILE_TRANSFER_TEMP';
--
  g_table_name      CONSTANT VARCHAR2(30)   := 'DOC_FILE_TRANSFER_TEMP';
  g_content_col     CONSTANT VARCHAR2(30)   := 'DFTT_CONTENT';
  g_doc_id_col      CONSTANT VARCHAR2(30)   := 'DFTT_DOC_ID';
  g_revision_col    CONSTANT VARCHAR2(30)   := 'DFTT_REVISION';
  g_forward_slash   CONSTANT VARCHAR2(1)    := CHR(47);
  g_back_slash      CONSTANT VARCHAR2(1)    := CHR(92);
--
--------------------------------------------------------------------------------
--
  g_debug           CONSTANT BOOLEAN        := TRUE;
--
--------------------------------------------------------------------------------
--
  PROCEDURE local_debug ( pi_text IN VARCHAR2 )
  IS
  BEGIN
    nm_debug.debug(pi_text);
  END local_debug;
--
-----------------------------------------------------------------------------
--
  PROCEDURE local_debug_on 
  IS
  BEGIN
    IF g_debug
    THEN
      nm_debug.debug_on;
    END IF;
  END local_debug_on;
--
-----------------------------------------------------------------------------
--
  FUNCTION create_dir_on_fly ( pi_path IN hig_directories.hdir_path%TYPE )
    RETURN hig_directories.hdir_name%TYPE; 
--
--------------------------------------------------------------------------------
--
  PROCEDURE drop_dir_on_fly ( pi_directory IN hig_directories.hdir_name%TYPE );
--
--------------------------------------------------------------------------------
--
  PROCEDURE blob2file
               ( pi_doc_id    IN docs.doc_id%TYPE
               , pi_revision  IN NUMBER
               , pi_directory IN VARCHAR2
               , pi_filename  IN VARCHAR2);
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
  FUNCTION get_max_revision (pi_doc_id IN docs.doc_id%TYPE)
  RETURN NUMBER
  IS
    retval NUMBER;
    l_rec_dlt doc_location_tables%ROWTYPE;
  BEGIN
  --
    l_rec_dlt := doc_locations_api.get_dlt ( pi_doc_id => pi_doc_id);
  --
    IF l_rec_dlt.dlt_table IS NOT NULL
    THEN
      EXECUTE IMMEDIATE
        ' SELECT MAX('||l_rec_dlt.dlt_revision_col||') FROM '||l_rec_dlt.dlt_table||
        '  WHERE '||l_rec_dlt.dlt_doc_id_col||' = :pi_doc_id'
      INTO retval
      USING IN pi_doc_id;
      RETURN retval;
    ELSE
      RETURN NULL;
    END IF;
  --
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN RAISE_APPLICATION_ERROR (-20201,'Cannot derive a revision for '||pi_doc_id);
  END get_max_revision;
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
--
  PROCEDURE move_file_to_blob ( pi_doc_id   IN docs.doc_id%TYPE 
                              , pi_revision IN NUMBER DEFAULT NULL)
  IS
    location    VARCHAR2(30);
    filename    VARCHAR2(2000);
    l_rec_dlt   doc_location_tables%ROWTYPE;
    l_rec_dlc   doc_locations%ROWTYPE := doc_locations_api.get_dlc(pi_doc_id=>pi_doc_id);
    vblob       BLOB;
  --
  -- Task 0111178
  -- Get file extension
  --
    FUNCTION get_doc_extension ( pi_dlc_id IN doc_locations.dlc_id%TYPE ) 
      RETURN VARCHAR2 IS
      retval doc_media.dmd_file_extension%TYPE;
    BEGIN
    --
      SELECT dmd_file_extension INTO retval
        FROM doc_media, doc_locations
       WHERE dlc_dmd_id = dmd_id
         AND dlc_id = pi_dlc_id;
      RETURN retval;
    EXCEPTION
      WHEN NO_DATA_FOUND 
      THEN RAISE_APPLICATION_ERROR (-20101,'Cannot derive file extension');
    --
    END get_doc_extension;
  --
  BEGIN
  --
    l_rec_dlt := doc_locations_api.get_dlt(pi_doc_id => pi_doc_id );
  --
    local_debug_on;
  --
    IF l_rec_dlt.dlt_table IS NOT NULL
    THEN
    --
      local_debug('move_file_to_blob - start');
    --
      EXECUTE IMMEDIATE 
        ' SELECT dlc_name, '||l_rec_dlt.dlt_filename 
        ||' FROM doc_locations, docs, '||l_rec_dlt.dlt_table
       ||' WHERE dlc_id = doc_dlc_id '
         ||' AND doc_id = '||l_rec_dlt.dlt_doc_id_col
         ||' AND '||l_rec_dlt.dlt_revision_col||' = NVL(pi_revision,nm3doc_files.get_max_revision(:pi_doc_id))'
         ||' AND df_doc_id = :pi_doc_id '
      INTO location, filename
      USING IN pi_doc_id;
    --
      local_debug('move_file_to_blob - before table update');
    --
      EXECUTE IMMEDIATE 
        'UPDATE '||l_rec_dlt.dlt_table ||
          ' SET '||l_rec_dlt.dlt_content_col  ||' = nm3file.file_to_blob( :location, :filename) '||
        ' WHERE '||l_rec_dlt.dlt_doc_id_col   ||' = :pi_doc_id '||
          ' AND '||l_rec_dlt.dlt_revision_col ||' = NVL(:pi_revision,nm3doc_files.get_max_revision(:pi_doc_id))' --get_max_revision(pi_doc_id);
      USING IN location
          , IN filename 
          , IN pi_doc_id
          , IN pi_revision; 
    --
      COMMIT;
    --
      local_debug('move_file_to_blob - after table update');
    --
    ELSIF doc_locations_api.get_dlc_table(pi_doc_id=>pi_doc_id) = doc_locations_api.get_temp_load_table
    AND l_rec_dlc.dlc_location_type IN ( 'ORACLE_DIRECTORY', 'DB_SERVER' )
    THEN
    -- 
    -- Copy the file from the File to the temp BLOB table so that webutil can read
    --
      SELECT doc_file INTO filename
        FROM docs
       WHERE doc_id = pi_doc_id;
    --
    -- Task 0111178
    -- Get file extension
    -- 
      IF INSTR(filename,'.') = 0
      THEN
        filename := filename||'.'||get_doc_extension ( pi_dlc_id => l_rec_dlc.dlc_id );
      END IF; 
    --
      local_debug_on;
      local_debug( pi_doc_id||' : '||l_rec_dlc.dlc_location_name||'\'|| filename );
    --
      DECLARE
        l_dir hig_directories.hdir_name%TYPE;
      BEGIN
        l_dir := CASE WHEN l_rec_dlc.dlc_location_type = 'DB_SERVER'
                      THEN create_dir_on_fly (l_rec_dlc.dlc_location_name)
                      ELSE l_rec_dlc.dlc_location_name
                 END;
    --
        UPDATE doc_file_transfer_temp
           SET dftt_content  = nm3file.file_to_blob ( l_dir, filename )
         WHERE dftt_doc_id   = pi_doc_id
           AND dftt_revision = pi_revision ;
      --
        IF l_rec_dlc.dlc_location_type = 'DB_SERVER'
        THEN
          drop_dir_on_fly (l_dir);
        END IF;
      --
      EXCEPTION
        WHEN OTHERS
        THEN 
          IF l_rec_dlc.dlc_location_type = 'DB_SERVER' 
          THEN drop_dir_on_fly (l_dir);
          END IF;
          RAISE;
      END;
    --
    END IF;
  --
  EXCEPTION
  --
    WHEN NO_DATA_FOUND
    THEN
      RAISE_APPLICATION_ERROR (-20701,'Cannot find DOC_ID '||pi_doc_id);
  END move_file_to_blob;
--
--------------------------------------------------------------------------------
--
  FUNCTION does_df_exist ( pi_doc_id   IN docs.doc_id%TYPE
                         , pi_revision IN NUMBER )
  RETURN BOOLEAN
  IS
    l_temp NUMBER;
    l_rec_dlt   doc_location_tables%ROWTYPE;
  BEGIN
  --
    l_rec_dlt := doc_locations_api.get_dlt(pi_doc_id => pi_doc_id );
  --
    IF l_rec_dlt.dlt_table IS NOT NULL
    THEN
    --
      EXECUTE IMMEDIATE 
        ' SELECT COUNT(*) FROM '||l_rec_dlt.dlt_table||
        '  WHERE '||l_rec_dlt.dlt_doc_id_col||' = :pi_doc_id '||
        '    AND '||l_rec_dlt.dlt_revision_col||' = NVL(:pi_revision,nm3doc_files.get_max_revision(:pi_doc_id))'
      INTO l_temp
      USING IN pi_doc_id
          , IN pi_revision
          , IN pi_doc_id;
    --
      RETURN (l_temp > 0);
    --
    END IF;
  --
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
    SELECT a.filename, b.dlc_location_name
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
       --AND dlc_name = hdir_name;
       AND dlc_location_type IN ( 'ORACLE_DIRECTORY', 'DB_SERVER' )
       AND dlc_location_name = hdir_name(+) ;
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
              , pi_revision        IN NUMBER DEFAULT NULL
              , po_table_name     OUT user_tables.table_name%TYPE
              , po_column_name    OUT user_tab_columns.column_name%TYPE
              , po_pk_column      OUT user_tab_columns.column_name%TYPE
              , po_where_clause   OUT VARCHAR2
              , po_prog_title     OUT VARCHAR2
              , po_prog_sub_title OUT VARCHAR2 )
  IS
  --
    l_where_clause        nm3type.max_varchar2;
    l_progress_title      nm3type.max_varchar2                := 'Uploading ... Please Wait';
    l_progress_sub_title  nm3type.max_varchar2;
    l_rec_dlt             doc_location_tables%ROWTYPE;
  BEGIN
  --
    IF doc_locations_api.get_dlc_table(pi_doc_id) != g_temp_load_table 
    THEN
    --
      l_rec_dlt := doc_locations_api.get_dlt(pi_doc_id => pi_doc_id );
    --
      IF l_rec_dlt.dlt_table IS NOT NULL
      THEN
        l_where_clause := l_rec_dlt.dlt_doc_id_col||' = '||pi_doc_id||' AND '||
                          l_rec_dlt.dlt_revision_col ||' = '||NVL(pi_revision,get_max_revision (pi_doc_id));
      --
        po_table_name     := l_rec_dlt.dlt_table;
        po_column_name    := l_rec_dlt.dlt_content_col;
        po_pk_column      := l_rec_dlt.dlt_doc_id_col;
        po_where_clause   := l_where_clause;
        po_prog_title     := l_progress_title;
        po_prog_sub_title := l_progress_sub_title;
      END IF;
    --
    ELSE
    --
      IF pi_revision IS NULL
      THEN
        RAISE_APPLICATION_ERROR (-20101,'A revision must be specified');
      END IF;
    --
      l_where_clause := g_doc_id_col||' = '||pi_doc_id||' AND '||
                        g_revision_col ||' = '||pi_revision;
    --
      po_table_name     := g_table_name;
      po_column_name    := g_content_col;
      po_pk_column      := g_doc_id_col;
      po_where_clause   := l_where_clause;
      po_prog_title     := l_progress_title;
      po_prog_sub_title := l_progress_sub_title;
    --
    END IF;
  --
  END get_upload_info;
--
--------------------------------------------------------------------------------
--  Provide the info WebUtil needs to download the file to the client
--
  PROCEDURE get_download_info
              ( pi_doc_id          IN docs.doc_id%TYPE
              , pi_revision        IN NUMBER DEFAULT NULL
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
    l_where_clause        nm3type.max_varchar2;
    l_progress_title      nm3type.max_varchar2 := 'Downloading To Client ... Please Wait';
    l_progress_sub_title  nm3type.max_varchar2;
    l_location            nm3type.max_varchar2;
    l_filename            nm3type.max_varchar2;
  --
    l_rec_table           doc_locations_api.rec_file_record;
    l_rec_temp_table      doc_file_transfer_temp%ROWTYPE;
  --
    ex_no_file            EXCEPTION;
    ex_cannot_find_file   EXCEPTION;
    l_rec_dlt             doc_location_tables%ROWTYPE;
  --
    l_revision            NUMBER := NVL(pi_revision,get_max_revision (pi_doc_id));
  --
  BEGIN
  --
    IF doc_locations_api.get_dlc_table(pi_doc_id) != g_temp_load_table 
    THEN
    --
    ---------------------------------------------------------
    -- Retriving from a Table defined in DOC_LOCATIONS_TABLE
    ---------------------------------------------------------
    --
      l_rec_dlt := doc_locations_api.get_dlt(pi_doc_id => pi_doc_id );
    --
      IF l_rec_dlt.dlt_table IS NOT NULL
      THEN
    --
        IF does_df_exist ( pi_doc_id,l_revision )
        THEN
        --
        -- DOC_FILES_ALL record exists
        --
          l_where_clause := l_rec_dlt.dlt_doc_id_col||' = '||pi_doc_id||' AND '||
                            l_rec_dlt.dlt_revision_col ||' = '||l_revision;
        --
          po_client_file    := doc_locations_api.get_file_record ( pi_doc_id, l_revision ).filename;
          po_working_folder := get_work_folder ;
          po_table_name     := l_rec_dlt.dlt_table;
          po_column_name    := l_rec_dlt.dlt_content_col;
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
            l_rec_table.doc_id      := pi_doc_id;
            l_rec_table.revision    := 1;
            l_rec_table.start_date  := get_doc_start_date (pi_doc_id);
            l_rec_table.content     := nm3file.file_to_blob(l_location, l_filename);
            l_rec_table.filename    := l_filename;
            l_rec_table.full_path   := nm3file.get_true_dir_name(l_location)||g_sep||l_filename;
          --
            doc_locations_api.insert_file_record (l_rec_table);
          --
            l_where_clause := l_rec_dlt.dlt_doc_id_col||' = '||pi_doc_id||' AND '||
                              l_rec_dlt.dlt_revision_col ||' = '||l_revision;
          --
            po_client_file    := l_filename;
            po_working_folder := get_work_folder ;
            po_table_name     := l_rec_dlt.dlt_table;
            po_column_name    := l_rec_dlt.dlt_content_col;
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
      END IF;
    --
    ELSE
    --
    --------------------------------------------------------------
    -- Retriving from a Database Directory via Generic Temp Table
    --------------------------------------------------------------
    --
      IF pi_revision IS NULL
      THEN
        RAISE_APPLICATION_ERROR (-20101,'A revision must be specified');
      END IF;
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
        IF (INSTR(l_location,g_forward_slash) > 0
        OR INSTR(l_location,g_back_slash) > 0)
        AND  doc_locations_api.get_dlc(pi_doc_id => pi_doc_id).dlc_location_type = 'DB_SERVER'
        THEN
        -- Set to a true path i.e. DB_SERVER
          l_location := create_dir_on_fly (l_location);
        END IF;
      --
        l_rec_temp_table.dftt_doc_id      := pi_doc_id;
        l_rec_temp_table.dftt_revision    := 1;
        l_rec_temp_table.dftt_start_date  := get_doc_start_date (pi_doc_id);
        l_rec_temp_table.dftt_content     := nm3file.file_to_blob(l_location, l_filename);
        l_rec_temp_table.dftt_filename    := l_filename;
        l_rec_temp_table.dftt_full_path   := nm3file.get_true_dir_name(l_location)||g_sep||l_filename;
      --
        doc_locations_api.insert_temp_file_record (l_rec_temp_table);
      --
        l_where_clause := g_doc_id_col||' = '||pi_doc_id||' AND '||
                          g_revision_col ||' = '||l_revision;
      --
        po_client_file    := l_filename;
        po_working_folder := get_work_folder ;
        po_table_name     := g_table_name;
        po_column_name    := g_content_col;
        po_where_clause   := l_where_clause;
        po_prog_title     := l_progress_title;
        po_prog_sub_title := l_progress_sub_title;
      --
        IF (INSTR(l_location,g_forward_slash) > 0
        OR INSTR(l_location,g_back_slash) > 0)
        AND  doc_locations_api.get_dlc(pi_doc_id => pi_doc_id).dlc_location_type = 'DB_SERVER'
        THEN
          drop_dir_on_fly (l_location);
        END IF;
      --
      ELSE
      --
        RAISE ex_no_file;
      --
      END IF;
    --
    END IF;
  --
  EXCEPTION
  --
    WHEN ex_no_file
    THEN
      hig.raise_ner ( pi_appl               => 'HIG'
                    , pi_id                 => 542
                    , pi_supplementary_info => 'DOC_ID ['||pi_doc_id||'] in '||l_rec_dlt.dlt_table||' ['||l_rec_dlt.dlt_content_col ||']');
  --
    WHEN ex_cannot_find_file
    THEN 
      hig.raise_ner ( pi_appl               => 'HIG'
                    , pi_id                 => 543
                    , pi_supplementary_info => 'Filename ['||l_filename||'] on '||l_location);
  --
    WHEN OTHERS
      THEN
      IF (INSTR(l_location,g_forward_slash) > 0
        OR INSTR(l_location,g_back_slash) > 0)
        AND  doc_locations_api.get_dlc(pi_doc_id => pi_doc_id).dlc_location_type = 'DB_SERVER'
        THEN       
        drop_dir_on_fly (l_location);
      END IF;
      RAISE;
  --
  END get_download_info;
--
--------------------------------------------------------------------------------
--
  FUNCTION create_dir_on_fly ( pi_path IN hig_directories.hdir_path%TYPE )
    RETURN hig_directories.hdir_name%TYPE 
  IS
    retval VARCHAR2(100) := TO_CHAR(SYSTIMESTAMP,'DDHHMISSFF');
  BEGIN
  --
    hig_directories_api.mkdir(pi_replace        => TRUE
                             ,pi_directory_name => 'DOC'||retval
                             ,pi_directory_path => pi_path);
  --
    local_debug('Created dir on fly : '||'DOC'||retval);
  --
    RETURN 'DOC'||retval;
  --
  END;
--
--------------------------------------------------------------------------------
--
  PROCEDURE drop_dir_on_fly ( pi_directory IN hig_directories.hdir_name%TYPE )
  IS
  BEGIN
     hig_directories_api.rmdir(pi_directory_name => pi_directory);
   EXCEPTION
     WHEN others THEN
       Null;
  END;
--
  FUNCTION ora_dir_exists ( pi_directory IN hig_directories.hdir_name%TYPE )
  RETURN BOOLEAN
  IS
    l_dummy  hig_directories.hdir_name%TYPE ;
  BEGIN
    SELECT 'exists' INTO l_dummy
      FROM all_directories
     WHERE directory_name = pi_directory;
    RETURN TRUE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN FALSE;
  END ora_dir_exists;
--
--------------------------------------------------------------------------------
--  Download the file from the BLOB into an Oracle directory
--
  PROCEDURE download_from_blob_to_file
                                 ( pi_doc_id    IN docs.doc_id%TYPE
                                 , pi_revision  IN NUMBER
                                 , pi_directory IN VARCHAR2
                                 , pi_filename  IN VARCHAR2)
  IS
    l_directory       nm3type.max_varchar2;
    l_drop_dir        BOOLEAN := FALSE;
    ex_no_dir_found   EXCEPTION;
    ex_no_directory   EXCEPTION;
  BEGIN
  --
    local_debug_on;
  --
    IF pi_directory IS NULL
    THEN
      RAISE ex_no_directory;
    END IF;
  --
    BEGIN
    --
      --------------------------------
        -- Using an Oracle directory
      --------------------------------
    --
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
      IF doc_locations_api.get_dlc(pi_doc_id => pi_doc_id).dlc_location_type = 'ORACLE_DIRECTORY'
      AND NOT ora_dir_exists (l_directory)
      THEN
        RAISE NO_DATA_FOUND;
      END IF;
    --
    EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
        local_debug('Create directory on the fly'); 
        IF doc_locations_api.get_dlc(pi_doc_id => pi_doc_id).dlc_location_type = 'DB_SERVER'
        THEN
          l_directory := create_dir_on_fly ( pi_path => pi_directory );
          l_drop_dir := TRUE;
        ELSE
          --RAISE_APPLICATION_ERROR(-20502,'Directory '||pi_directory||' does not exist ');
          hig.raise_ner(pi_appl => 'HIG', pi_id => 536, pi_supplementary_info => pi_directory );
        END IF;
    END;
  --
    local_debug('Before BLOB2FILE');
  --
    local_debug(pi_doc_id||' : '||
                   pi_revision||' : '||
                   l_directory||' : '||
                   strip_filename(pi_filename));
  --
    blob2file
      ( pi_doc_id    => pi_doc_id
      , pi_revision  => pi_revision
      , pi_directory => l_directory
      , pi_filename  => strip_filename(pi_filename) );
  --
    local_debug('After BLOB2FILE');
  --
    IF l_drop_dir THEN
      local_debug('Drop dir '||l_directory);
      drop_dir_on_fly (l_directory);
    END IF; 
  --
  EXCEPTION
    WHEN ex_no_dir_found
    THEN
      IF l_drop_dir THEN
        drop_dir_on_fly ( pi_directory => l_directory );
      END IF;
      RAISE_APPLICATION_ERROR
        ( -20101,'Please define ['||pi_directory||'] as a HIG_DIRECTORY');
    WHEN ex_no_directory
    THEN
      IF l_drop_dir THEN
        drop_dir_on_fly ( pi_directory => l_directory );
      END IF;
      RAISE_APPLICATION_ERROR
        ( -20102,'Please define a directory !');
    WHEN OTHERS
    THEN
      IF l_drop_dir THEN
        drop_dir_on_fly ( pi_directory => l_directory );
      END IF;
      RAISE;
  --
  END download_from_blob_to_file;
--
--------------------------------------------------------------------------------
--
  PROCEDURE blob2file
                      ( pi_doc_id    IN docs.doc_id%TYPE
                      , pi_revision  IN NUMBER
                      , pi_directory IN VARCHAR2
                      , pi_filename  IN VARCHAR2)
  IS
    vblob   BLOB;
    l_rec_dlt             doc_location_tables%ROWTYPE;
  BEGIN
  --
    l_rec_dlt := doc_locations_api.get_dlt(pi_doc_id => pi_doc_id );
  --
    IF l_rec_dlt.dlt_table IS NOT NULL
    THEN
    --
    ----------------------------------
    -- Read from static storage table
    ----------------------------------
    --
      EXECUTE IMMEDIATE 
        'SELECT '||l_rec_dlt.dlt_content_col||' FROM '||l_rec_dlt.dlt_table||
        ' WHERE '||l_rec_dlt.dlt_doc_id_col||' = :pi_doc_id '||
        '   AND '||l_rec_dlt.dlt_revision_col||' = '||
             ' CASE '||
              '  WHEN :pi_revision IS NOT NULL'||
              '    THEN :pi_revision '||
              '  ELSE '||
              '   (SELECT MAX('||l_rec_dlt.dlt_revision_col||') FROM '||l_rec_dlt.dlt_table||
                  ' WHERE '||l_rec_dlt.dlt_doc_id_col||' = :pi_doc_id) END'
      INTO vblob
      USING IN pi_doc_id
          , IN pi_revision
          , IN pi_revision
          , IN pi_doc_id;
    --
    ELSIF doc_locations_api.get_dlc_table(pi_doc_id=>pi_doc_id) = g_temp_load_table
    THEN
    --
    ----------------------------------
    -- Read from temporary load table
    ----------------------------------
    --
      SELECT dftt_content INTO vblob 
        FROM doc_file_transfer_temp
       WHERE dftt_doc_id = pi_doc_id
         AND dftt_revision = 
              CASE
              WHEN pi_revision IS NOT NULL
                THEN pi_revision
              ELSE 
                (SELECT MAX(dftt_revision) 
                   FROM doc_file_transfer_temp
                  WHERE dftt_doc_id = pi_doc_id)
              END;
    --
    END IF;
  --
    local_debug('Length = '||length(vblob));
    local_debug('pi_directory '||pi_directory );
    local_debug('pi_filename '||pi_filename);
  --
  --
  -- Write the file out to the final destination
  --
    IF vblob IS NOT NULL
    AND doc_locations_api.get_dlc(pi_doc_id=>pi_doc_id).dlc_location_Type IN ('ORACLE_DIRECTORY','DB_SERVER')
    THEN
      nm3file.blob_to_file
        ( pi_blob             => vblob
        , pi_destination_dir  => pi_directory
        , pi_destination_file => pi_filename
        );
    END IF;
    local_debug('Written file out to '||pi_directory||' : '||pi_filename);
  --
  -- Archive the file
  --
     archive_file ( pi_doc_id   => pi_doc_id 
                  , pi_blob     => vblob
                  , pi_filename => pi_filename );
  --
  EXCEPTION
  --
    WHEN NO_DATA_FOUND
    THEN RAISE_APPLICATION_ERROR (-20601,'Cannot find BLOB content for '||pi_doc_id||' revision '||pi_revision||' in '||l_rec_dlt.dlt_table);
  END blob2file;
--
--------------------------------------------------------------------------------
--
  PROCEDURE archive_file ( pi_doc_id    IN docs.doc_id%TYPE )
  IS
    l_rec_dlc    doc_locations%ROWTYPE;
    l_rec_dlt    doc_location_tables%ROWTYPE;
    l_rec_doc    docs%ROWTYPE := nm3get.get_doc(pi_doc_id => pi_doc_id, pi_raise_not_found => FALSE );
    l_blob       BLOB;
    l_filename   nm3type.max_varchar2;
    l_dir        hig_directories.hdir_name%TYPE;
  BEGIN
  --
    local_debug_on;
    local_debug('Processed - blob is '||CASE when l_blob is null then 'empty' else 'full' end );
    l_rec_dlc := doc_locations_api.get_dlc(pi_doc_id => pi_doc_id);
  --
  -- Get the blob content from the TABLE
  --
    IF l_rec_doc.doc_id IS NULL
    AND l_rec_doc.doc_file IS NULL
    THEN 
      RETURN;
    END IF;
  --
    IF l_rec_dlc.dlc_location_type = 'TABLE'
    THEN
    --
      l_rec_dlt := doc_locations_api.get_dlt(pi_doc_id => pi_doc_id );
    --
      IF l_rec_dlt.dlt_table IS NOT NULL
      THEN
      --
      ----------------------------------
      -- Read from static storage table
      ----------------------------------
      --
        BEGIN
          EXECUTE IMMEDIATE 
            'SELECT '||l_rec_dlt.dlt_content_col||','||l_rec_dlt.dlt_filename
           ||' FROM '||l_rec_dlt.dlt_table||
            ' WHERE '||l_rec_dlt.dlt_doc_id_col||' = :pi_doc_id '||
            '   AND '||l_rec_dlt.dlt_revision_col||' = '||
                 ' CASE '||
                  '  WHEN :pi_revision IS NOT NULL'||
                  '    THEN :pi_revision '||
                  '  ELSE '||
                  '   (SELECT MAX('||l_rec_dlt.dlt_revision_col||') FROM '||l_rec_dlt.dlt_table||
                      ' WHERE '||l_rec_dlt.dlt_doc_id_col||' = :pi_doc_id) END'
          INTO l_blob, l_filename
          USING IN pi_doc_id
              , IN 1
              , IN 1
              , IN pi_doc_id;
        --
        EXCEPTION
          WHEN OTHERS
          THEN 
            nm_debug.debug_on;
            nm_debug.debug('Error getting copy from table '||l_rec_dlt.dlt_table
                        ||' for DOC '||l_rec_dlt.dlt_doc_id_col||' : '||SQLERRM);
            nm_debug.debug_off; 
        END;
      --
      END IF;
  --
  -- Get the blob content from the ORACLE_DIRECTORY
  --
    ELSIF l_rec_dlc.dlc_location_type = 'ORACLE_DIRECTORY'
    THEN
      BEGIN
        IF l_rec_doc.doc_id IS NOT NULL
        AND l_rec_doc.doc_file IS NOT NULL
        THEN
          l_filename := l_rec_doc.doc_file;
          l_blob := nm3file.file_to_blob( pi_source_dir  => l_rec_dlc.dlc_location_name
                                        , pi_source_file => l_filename);
        END IF;
      EXCEPTION
        WHEN OTHERS
        THEN 
          nm_debug.debug_on;
          nm_debug.debug('Error getting copy from location '||l_rec_dlc.dlc_location_name
                      ||' for file '||l_filename||' : '||SQLERRM);
          nm_debug.debug_off;
      END;
--
  -- Get the blob content from the DB_SERVER
  --
    ELSIF l_rec_dlc.dlc_location_type = 'DB_SERVER'
    THEN
      BEGIN
        IF l_rec_doc.doc_id IS NOT NULL
        AND l_rec_doc.doc_file IS NOT NULL
        THEN
          l_filename := l_rec_doc.doc_file;
          l_dir := create_dir_on_fly( l_rec_dlc.dlc_location_name );
          l_blob := nm3file.file_to_blob( pi_source_dir  => l_dir
                                        , pi_source_file => l_filename);
        END IF;
        drop_dir_on_fly (l_dir);
      EXCEPTION
        WHEN OTHERS
          THEN 
          drop_dir_on_fly (l_dir);
          nm_debug.debug_on;
          nm_debug.debug('Error getting copy from location '||l_rec_dlc.dlc_location_name
                      ||' for file '||l_filename||' : '||SQLERRM);
          nm_debug.debug_off;
      END;
    END IF;
  --
    local_debug_on;
    local_debug('Processed - blob is '||CASE when l_blob is not null then 'empty' else 'full' end );
  --
    IF l_blob IS NOT NULL
    THEN
      archive_file ( pi_doc_id   => pi_doc_id
                   , pi_blob     => l_blob
                   , pi_filename => l_filename );
    END IF;
  END archive_file;
--
--------------------------------------------------------------------------------
--
  PROCEDURE archive_file ( pi_doc_id    IN docs.doc_id%TYPE
                         , pi_blob      IN BLOB
                         , pi_filename  IN VARCHAR2)
  IS
    l_tab_dla doc_locations_api.g_tab_dla;
    l_blob    BLOB  := pi_blob;
    -- doc_location_archives
  BEGIN
  --
    l_tab_dla := doc_locations_api.get_archives(pi_doc_id => pi_doc_id);
  --
    IF l_tab_dla.COUNT > 0
    THEN
    --
      FOR i IN 1..l_tab_dla.COUNT
      LOOP
      --
      -- doc_location_archives
      IF l_tab_dla(i).dla_archive_type = 'ORACLE_DIRECTORY'
      THEN
      --
        BEGIN
          local_debug_on;
          local_debug ('Archive '||l_tab_dla(i).dla_archive_name||'/'||pi_filename);
          nm3file.blob_to_file
            ( pi_blob             => l_blob
            , pi_destination_dir  => l_tab_dla(i).dla_archive_name
            , pi_destination_file => pi_filename
            );
        EXCEPTION
          WHEN OTHERS 
          THEN 
            nm_debug.debug_on;
            nm_debug.debug('Error archiving '||pi_filename||' : '||SQLERRM);
            nm_debug.debug_off; 
          --RAISE_APPLICATION_ERROR (-20901,'Error archiving - '||nm3flx.parse_error_message(SQLERRM));
        END;
      --
      END IF;
      --
      END LOOP;
    --
    END IF;
  --
  END archive_file;
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
--    IF get_df(pi_dfl_doc_id, pi_dfl_revision).df_doc_id IS NULL
--    THEN
--      RAISE_APPLICATION_ERROR(-20300,'Cannot lock file - it does not exist in the database table');
--    END IF;
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
              , po_filename     OUT VARCHAR2
              , po_username     OUT doc_file_locks.dfl_username%TYPE
              , po_date         OUT doc_file_locks.dfl_date%TYPE)
  IS
    l_filename nm3type.max_varchar2;
    l_username VARCHAR2(30);
    l_date     DATE;
    l_rec_dlt             doc_location_tables%ROWTYPE;
  BEGIN
  --
    l_rec_dlt := doc_locations_api.get_dlt(pi_doc_id => pi_dfl_doc_id );
  --
    IF l_rec_dlt.dlt_table IS NOT NULL
    THEN
    --
      EXECUTE IMMEDIATE 
      'SELECT '||l_rec_dlt.dlt_filename||', dfl_username, dfl_date '||
      '  FROM doc_file_locks, '||l_rec_dlt.dlt_table ||
      ' WHERE '||l_rec_dlt.dlt_doc_id_col||' = dlf_doc_id '||
       '  AND '||l_rec_dlt.dlt_revision_col||' = dfl_revision '||
        ' AND dfl_doc_id = :pi_doc_id '||
        ' AND dfl_revision = :pi_revision '
      INTO l_filename, l_username, l_date
      USING IN pi_dfl_doc_id
          , IN pi_dfl_revision;
    --
    END IF;
  --
    po_filename := l_filename;
    po_username := l_username;
    po_date     := l_date;
  --
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
  FUNCTION get_file_size ( pi_doc_id    IN docs.doc_id%TYPE
                         , pi_revision  IN NUMBER
                         , pi_formatted IN BOOLEAN DEFAULT FALSE )
  RETURN VARCHAR2
  IS
    retval      nm3type.max_varchar2;
    l_formatted VARCHAR2(15) := nm3flx.boolean_to_char( pi_formatted );
  BEGIN
--    SELECT
--        --
--           CASE
--           WHEN l_formatted = nm3type.get_true
--           THEN
--           --
--           -- Return a nice formatted value
--           --
--             CASE
--               --------------------------------------------------------
--               -- Bytes
--               --------------------------------------------------------
--               WHEN LENGTH(df_content) < 1024
--               THEN
--                 --LENGTH(df_content)||' Bytes'
--                 LENGTH(df_content)||' B'
--               --------------------------------------------------------
--               -- Kilobytes
--               ----------------------------------------------------------
--               WHEN LENGTH(df_content) < (1024*1024)
--               THEN
--                 --ROUND(LENGTH(df_content)/1024,0)||' Kilobytes'
--                 ROUND(LENGTH(df_content)/1024,0)||' KB'
--               --------------------------------------------------------
--               -- Megabytes
--               --------------------------------------------------------
--               WHEN LENGTH(df_content) < (1024*1024*1024)
--               THEN
--                 --ROUND(LENGTH(df_content)/(1024*1024),2)||' Megabytes'
--                 ROUND(LENGTH(df_content)/(1024*1024),2)||' MB'
--               --------------------------------------------------------
--               -- Gigabytes
--               --------------------------------------------------------
--               WHEN LENGTH(df_content) < (1024*1024*1024*1024)
--               THEN
--                 --ROUND(LENGTH(df_content)/(1024*1024*1024),2)||' Gigabytes'
--                 ROUND(LENGTH(df_content)/(1024*1024*1024),2)||' GB'
--               --------------------------------------------------------
--               -- Terrabytes
--               --------------------------------------------------------
--               WHEN LENGTH(df_content) < (1024*1024*1024*1024*1024)
--               THEN
--                 ROUND(LENGTH(df_content)/(1024*1024*1024*1024),2)||' TB'
--               ELSE
--                 LENGTH(df_content)||' Bytes'
--             END
--           ELSE
--           --
--           -- Otherwise just return the length in bytes
--           --
--             LTRIM (TO_CHAR (LENGTH(df_content),'99999999999999'))
--           END
--        --
--      INTO retval
--      FROM doc_files_all
--     WHERE df_doc_id = pi_doc_id
--       AND df_revision = NVL(pi_revision, get_max_revision(pi_doc_id));
  --
    RETURN retval;
  --
  END get_file_size;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_file_size ( pi_doc_id    IN docs.doc_id%TYPE
                         , pi_revision  IN NUMBER
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
  FUNCTION get_file_size ( pi_doc_id    IN docs.doc_id%TYPE
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
    RETURN NVL(hig.get_user_or_sys_opt('WORKFOLDER'),'C:\');
    --RETURN hig.get_user_or_sys_opt('WORKFOLDER');
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
  FUNCTION get_dlc_table (pi_doc_id IN docs.doc_id%TYPE) RETURN doc_location_tables.dlt_table%TYPE
   IS
    retval doc_location_tables.dlt_table%TYPE;
  BEGIN
    RETURN doc_locations_api.get_dlc_table ( pi_doc_id => pi_doc_id );
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
----
----------------------------------------------------------------------------------
----
--  PROCEDURE set_doc_location_table ( pi_dlc_id IN doc_locations.dlc_id%TYPE
--                                   , pi_flag   IN BOOLEAN )
--  IS
--  BEGIN
--  --
--    IF pi_flag
--    THEN
--      IF get_dlc_table ( pi_dlc_id => pi_dlc_id) IS NULL
--      THEN
--        INSERT INTO doc_location_tables
--        SELECT dlt_id_seq.nextval
--             , pi_dlc_id
--             , 'DOC_FILES_ALL'
--             , 'DF_DOC_ID'
--             , 'DF_CONTENT'
--             , 'DF_REVISION'
--             , 'DF_START_DATE'
--             , 'DF_END_DATE'
--             , 'DF_FULL_PATH'
--             , 'DF_FILENAME'
--             , 'DF_AUDIT_COL'
--             , 'DF_FILE_INFO'
--           FROM dual;
--      END IF;
--    --
--    ELSE
--    --
--      DELETE doc_location_tables
--       WHERE dlt_dlc_id = pi_dlc_id
--         AND dlt_table = 'DOC_FILES_ALL';
--    --
--    END IF;
--  --
--  END set_doc_location_table;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_filename_with_doc_id ( pi_filename IN VARCHAR2
                                    , pi_doc_id   IN NUMBER )
    RETURN VARCHAR
  IS
  BEGIN
    RETURN
        SUBSTR(pi_filename,0,instr(pi_filename,g_win_sep,-1))||
               pi_doc_id||'_'||( substr (pi_filename,
                                   instr(pi_filename,g_win_sep,-1)+1));
  END get_filename_with_doc_id;
--
--------------------------------------------------------------------------------
--
END nm3doc_files;
/

