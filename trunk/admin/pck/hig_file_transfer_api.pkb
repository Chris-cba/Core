CREATE OR REPLACE PACKAGE BODY hig_file_transfer_api
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/hig_file_transfer_api.pkb-arc   3.4   Jul 04 2013 14:45:42   James.Wadsworth  $
--       Module Name      : $Workfile:   hig_file_transfer_api.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:45:42  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:43:18  $
--       Version          : $Revision:   3.4  $
--       Based on SCCS version : 
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid    CONSTANT VARCHAR2(2000) := '$Revision:   3.4  $';
  g_package_name   CONSTANT varchar2(30) := 'hig_file_transfer_api';
  g_pending        CONSTANT varchar2(30) := 'PENDING';
  g_internal       CONSTANT varchar2(30) := 'INTERNAL'; 
  g_error          CONSTANT varchar2(30) := 'ERROR';
  g_complete       CONSTANT varchar2(30) := 'TRANSFER COMPLETE';
  g_nl             CONSTANT varchar2(30) := chr(10);

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
  PROCEDURE raise_error ( pi_error IN VARCHAR2 ) IS
  BEGIN
    RAISE_APPLICATION_ERROR (-20205,pi_error);
  END raise_error;
--
-----------------------------------------------------------------------------
--
  FUNCTION check_directory ( pi_directory_name IN VARCHAR2 ) RETURN BOOLEAN IS
    l_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_count
      FROM all_directories
     WHERE directory_name = pi_directory_name;
    RETURN (l_count>0);
  END check_directory;
--
--------------------------------------------------------------------------------
--
  FUNCTION create_dir_on_fly ( pi_path IN hig_directories.hdir_path%TYPE )
    RETURN hig_directories.hdir_name%TYPE 
  IS
    retval VARCHAR2(100) := TO_CHAR(SYSTIMESTAMP,'DDHHMISSFF');
  BEGIN
    hig_directories_api.mkdir(pi_replace        => TRUE
                             ,pi_directory_name => 'HFTQ'||retval
                             ,pi_directory_path => pi_path);
    RETURN 'HFTQ'||retval;
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
-----------------------------------------------------------------------------
--
  PROCEDURE add_files_to_queue ( pi_tab_files      IN g_tab_files
                               , po_hftq_batch_no OUT hig_file_transfer_queue.hftq_batch_no%TYPE )
  IS
  --
  --  source                hig_file_transfer_queue.hftq_source%TYPE                -- Required param
  --, source_type           hig_file_transfer_queue.hftq_source_type%TYPE           -- Required param
  --, source_filename       hig_file_transfer_queue.hftq_source_filename%TYPE       -- Required param
  --, destination           hig_file_transfer_queue.hftq_destination%TYPE           -- Required param
  --, destination_type      hig_file_transfer_queue.hftq_destination_type%TYPE      -- Required param
  --, destination_filename  hig_file_transfer_queue.hftq_destination_filename%TYPE  -- Optional param - will default to source_filename
  --, direction             hig_file_transfer_queue.hftq_direction%TYPE             -- Optional param - will default to 'IN'
  --, transfer_type         hig_file_transfer_queue.hftq_transfer_type%TYPE         -- Optional param - will default to 'INTERNAL'
  --, status                hig_file_transfer_queue.hftq_status%TYPE                -- Optional param - will default to 'PENDING'
  --, condition             hig_file_transfer_queue.hftq_condition%TYPE             -- Optional param - Table WHERE Clause
  --, content               hig_file_transfer_queue.hftq_content%TYPE               -- Optional param - BLOB Content
  --, comments              hig_file_transfer_queue.hftq_comments%TYPE              -- Optional param - Remarks
  --, process_id            hig_file_transfer_queue.hftq_hp_process_id%TYPE         -- Optional param - Process ID
  --
    l_tab_queue           tab_hftq;
    l_hftq_batch_no       hig_file_transfer_queue.hftq_batch_no%TYPE;
  --
  BEGIN
  --
    IF pi_tab_files.COUNT > 0
    THEN
    --
      l_hftq_batch_no := nm3ddl.sequence_nextval('hftq_batch_no_seq');
    --
      FOR i IN 1..pi_tab_files.COUNT
      LOOP
      --
        l_tab_queue(i).hftq_batch_no             := l_hftq_batch_no;
        l_tab_queue(i).hftq_id                   := nm3ddl.sequence_nextval('hftq_id_seq');
        l_tab_queue(i).hftq_date                 := TO_DATE(TO_CHAR(SYSDATE,'DD-MON-RRRR HH24:SS:MI'),'DD-MON-RRRR HH24:SS:MI');
        l_tab_queue(i).hftq_initiated_by         := Sys_Context('NM3_SECURITY_CTX','USERNAME');
        l_tab_queue(i).hftq_direction            := NVL(pi_tab_files(i).direction,'IN');
        l_tab_queue(i).hftq_transfer_type        := NVL(pi_tab_files(i).transfer_type, g_internal);
        l_tab_queue(i).hftq_source               := pi_tab_files(i).source;
        l_tab_queue(i).hftq_source_type          := pi_tab_files(i).source_type;
        l_tab_queue(i).hftq_source_filename      := pi_tab_files(i).source_filename;
        l_tab_queue(i).hftq_source_column        := pi_tab_files(i).source_column;
        l_tab_queue(i).hftq_destination          := pi_tab_files(i).destination;
        l_tab_queue(i).hftq_destination_type     := pi_tab_files(i).destination_type;
        l_tab_queue(i).hftq_destination_column   := pi_tab_files(i).destination_column;
        l_tab_queue(i).hftq_destination_filename := NVL ( pi_tab_files(i).destination_filename, pi_tab_files(i).source_filename );
        l_tab_queue(i).hftq_status               := NVL ( pi_tab_files(i).status, g_pending );
        l_tab_queue(i).hftq_condition            := pi_tab_files(i).condition;
        l_tab_queue(i).hftq_content              := pi_tab_files(i).content;
        l_tab_queue(i).hftq_comments             := pi_tab_files(i).comments;
        l_tab_queue(i).hftq_hp_process_id        := pi_tab_files(i).process_id;
      --
        validate_file_queue_record (l_tab_queue(i));
      --
      END LOOP;
    --
    END IF;
  --
    FORALL z IN 1..l_tab_queue.COUNT
      INSERT INTO hig_file_transfer_queue VALUES l_tab_queue(z); 
  --
    po_hftq_batch_no := l_hftq_batch_no;
  --
  END add_files_to_queue;
--
-----------------------------------------------------------------------------
--
  PROCEDURE log_transfer
              ( pi_hftq_id       IN hig_file_transfer_queue.hftq_id%TYPE
              , pi_hftq_batch_no IN hig_file_transfer_queue.hftq_batch_no%TYPE
              , pi_filename      IN hig_file_transfer_queue.hftq_source_filename%TYPE
              , pi_destination   IN hig_file_transfer_queue.hftq_destination%TYPE
              , pi_message       IN hig_file_transfer_log.hftl_message%TYPE)
  IS
    l_rec_hftl hig_file_transfer_log%ROWTYPE;
  BEGIN
  --hig_file_transfer_log
  --
    l_rec_hftl.hftl_id                  := nm3ddl.sequence_nextval(' hftl_id_seq');
    l_rec_hftl.hftl_hftq_id             := pi_hftq_id;
    l_rec_hftl.hftl_hftq_batch_no       := pi_hftq_batch_no;
    l_rec_hftl.hftl_date                := TO_DATE(TO_CHAR(SYSDATE,'DD-MON-RRRR HH24:SS:MI'),'DD-MON-RRRR HH24:SS:MI');
    l_rec_hftl.hftl_filename            := pi_filename;
    l_rec_hftl.hftl_destination_path    := pi_destination;
    l_rec_hftl.hftl_message             := pi_message;
  --
    INSERT INTO hig_file_transfer_log VALUES l_rec_hftl;
  --
  END log_transfer;
--
-----------------------------------------------------------------------------
--
  PROCEDURE check_entity ( pi_entity_type IN VARCHAR2
                         , pi_rec_hftq    IN hig_file_transfer_queue%ROWTYPE )
  IS
  BEGIN
  --
  ------------------------------------------------------------------------------
  --                            TABLE validation
  ------------------------------------------------------------------------------
  --
    IF pi_entity_type = 'TABLE'
    THEN
    --
      IF pi_entity_type = pi_rec_hftq.hftq_source_type
      THEN
      -- ***********************************
      --      Transferring FROM a TABLE
      -- ***********************************
      --
        IF pi_rec_hftq.hftq_content IS NULL
        THEN
        --
        -- Must be passed in on the Transfer Table to work !! 
        --
          raise_error ('Please specify source binary content');
        --
        END IF;
      --
      END IF;
    --
      IF  pi_entity_type = pi_rec_hftq.hftq_destination_type
      THEN
      -- ***********************************
      --      Transferring TO a TABLE
      -- ***********************************
      --
        IF pi_rec_hftq.hftq_destination IS NULL
        THEN
          raise_error ('Please specify a destination table');
        ELSIF NOT nm3ddl.does_object_exist(pi_rec_hftq.hftq_destination)
        THEN
          raise_error ('Please specify a valid destination table '||pi_rec_hftq.hftq_destination||' does not exist');
        ELSIF pi_rec_hftq.hftq_destination_column IS NULL
        THEN
          raise_error ('Please specify a destination column on '||pi_rec_hftq.hftq_destination);
        ELSIF pi_rec_hftq.hftq_condition IS NULL
        THEN
          raise_error ('Please specify a condition');
        ELSIF ( pi_rec_hftq.hftq_destination_filename IS NULL AND pi_rec_hftq.hftq_source_filename IS NULL )
          THEN 
          raise_error ('Please specify a destination filename');
        END IF;
      --
      END IF;
  --
  ------------------------------------------------------------------------------
  --                          DB_SERVER validation
  ------------------------------------------------------------------------------
  --
    ELSIF pi_entity_type = 'DB_SERVER'
    THEN
    --
      IF pi_entity_type = pi_rec_hftq.hftq_source_type 
      THEN
      -- ***********************************
      -- Transferring FROM a DB_SERVER path
      -- ***********************************
      --
        IF pi_rec_hftq.hftq_source IS NULL
        THEN
          raise_error ('Please specify a source database path');
        ELSIF  pi_rec_hftq.hftq_source_filename IS NULL
          THEN 
          raise_error ('Please specify a source filename');
        END IF;
      --
      END IF;
    --
      IF pi_entity_type = pi_rec_hftq.hftq_destination_type
      THEN
      -- ***********************************
      --   Transferring TO a DB_SERVER path
      -- ***********************************
      --
        IF pi_rec_hftq.hftq_destination IS NULL
        THEN
          raise_error ('Please specify a destination database path');
        ELSIF ( pi_rec_hftq.hftq_destination_filename IS NULL AND pi_rec_hftq.hftq_source_filename IS NULL )
          THEN 
          raise_error ('Please specify a destination filename');
        END IF;
      --
      END IF;
  --
  ------------------------------------------------------------------------------
  --                     ORACLE_DIRECTORY validation
  ------------------------------------------------------------------------------
  --
    ELSIF pi_entity_type = 'ORACLE_DIRECTORY'
    THEN
    -- 
      IF pi_entity_type = pi_rec_hftq.hftq_source_type
      THEN
      -- ***********************************
      -- Transferring FROM an ORACLE_DIRECTORY
      -- ***********************************
      --
        IF pi_rec_hftq.hftq_content IS NULL
        THEN
        --
        ------------------------------------------------
        -- Check to make sure we have some source data, 
        -- either via directory or blob
        ------------------------------------------------
        -- 
          IF pi_rec_hftq.hftq_source IS NULL
          THEN
            raise_error ('Please specify a source Oracle Directory or binary content');
          ELSE
          --
          ------------------------------------------------
          -- Check source oracle directory actually exists
          ------------------------------------------------
          --
            IF NOT check_directory(pi_rec_hftq.hftq_source)
            THEN
              raise_error ('Please specify a valid source Oracle Directory - '||pi_rec_hftq.hftq_source||' does not exist');
            END IF;
          --
          ------------------------------------------------
          -- Check filename is specified
          ------------------------------------------------
          --
            IF pi_rec_hftq.hftq_source_filename IS NULL
            THEN
              raise_error ('Please specify a source filename');
            END IF;
          --
          END IF;
        --
        END IF;
      --
      END IF;
    --
      IF pi_entity_type = pi_rec_hftq.hftq_destination_type
      THEN
      -- ***********************************
      -- Transferring TO an ORACLE_DIRECTORY
      -- ***********************************
      --
        IF pi_rec_hftq.hftq_destination IS NULL
        THEN
          raise_error ('Please specify a destination Oracle Directory');
        ELSIF NOT check_directory(pi_rec_hftq.hftq_destination)
        THEN
          raise_error ('Please specify a valid destination Oracle Directory - '||pi_rec_hftq.hftq_destination||' does not exist');
        END IF;
      END IF;
    --
    ELSE
      raise_error ( 'Unrecognised Transfer type '||pi_entity_type ); 
    END IF; 
  --
  END check_entity;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_file_queue_record
            ( pi_rec_hftq  IN  hig_file_transfer_queue%ROWTYPE )
IS
--
BEGIN
--
  IF pi_rec_hftq.hftq_source_type NOT IN ('ORACLE_DIRECTORY','TABLE','DB_SERVER')
  THEN
    raise_error('Invalid Source Type : '||pi_rec_hftq.hftq_source_type);
  ELSIF pi_rec_hftq.hftq_destination_type NOT IN ('ORACLE_DIRECTORY','TABLE','DB_SERVER')
  THEN
    raise_error('Invalid Destination Type : '||pi_rec_hftq.hftq_destination_type);
  END IF;
--
  CASE
  /*
  ******************************************************************************
  **            Validate the Oracle DIR to Oracle DIR transfer 
  ******************************************************************************
  */ 
    WHEN pi_rec_hftq.hftq_source_type      = 'ORACLE_DIRECTORY'
     AND pi_rec_hftq.hftq_destination_type = 'ORACLE_DIRECTORY'
    THEN
   --
      check_entity ( 'ORACLE_DIRECTORY',pi_rec_hftq );
   --
  /*
  ******************************************************************************
  **              Validate the Table to Oracle DIR transfer 
  ******************************************************************************
  */
    WHEN pi_rec_hftq.hftq_source_type      = 'TABLE'
     AND pi_rec_hftq.hftq_destination_type = 'ORACLE_DIRECTORY'
    THEN
    --
      check_entity ( 'TABLE',pi_rec_hftq );
    --
      check_entity ( 'ORACLE_DIRECTORY',pi_rec_hftq );
    --
  /*
  ******************************************************************************
  **              Validate the Oracle Directory to Table 
  ******************************************************************************
  */
    WHEN pi_rec_hftq.hftq_source_type      = 'ORACLE_DIRECTORY'
     AND pi_rec_hftq.hftq_destination_type = 'TABLE'
    THEN
    --
      check_entity ('ORACLE_DIRECTORY',pi_rec_hftq);
    --
      check_entity ('TABLE',pi_rec_hftq);
    --
  /*
  ******************************************************************************
  **                  Validate the Table to Table 
  ******************************************************************************
  */
    WHEN pi_rec_hftq.hftq_source_type      = 'TABLE'
     AND pi_rec_hftq.hftq_destination_type = 'TABLE'
    THEN
    --
      check_entity('TABLE',pi_rec_hftq);
    --
  /*
  ******************************************************************************
  **                  Validate the DB_SERVER to Table 
  ******************************************************************************
  */
    WHEN pi_rec_hftq.hftq_source_type      = 'DB_SERVER'
     AND pi_rec_hftq.hftq_destination_type = 'TABLE'
    THEN
    --
      check_entity ( 'TABLE', pi_rec_hftq );
    --
    ELSE
      NULL;
    END CASE;
  --
--
END validate_file_queue_record;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_transfer
IS
  l_transfer_to_from     VARCHAR2(50);
  exec_code              nm3type.max_varchar2;
  l_to_dir_name          all_directories.directory_name%TYPE;
  l_from_dir_name        all_directories.directory_name%TYPE;
BEGIN
--
  --nm_debug.debug_on;
--
  FOR i IN 1..g_tab_queue_files.COUNT
  LOOP
  --
    exec_code := NULL;
    exec_code := exec_code|| '    BEGIN '||g_nl;
    exec_code := exec_code||   '    EXECUTE IMMEDIATE '||g_nl;
  --
    IF g_tab_queue_files(i).hftq_direction = 'IN'
    THEN
    --
      IF g_tab_queue_files(i).hftq_transfer_type = g_internal
      THEN
      --
        CASE 
        /*
        ***********************************************************************
        **               Transfer Source = ORACLE_DIRECTORY
        ***********************************************************************
        */
          WHEN g_tab_queue_files(i).hftq_source_type      = 'ORACLE_DIRECTORY'
          THEN
          --
            IF g_tab_queue_files(i).hftq_destination_type = 'ORACLE_DIRECTORY'
            THEN
              exec_code := exec_code
          ||       '''BEGIN  '||g_nl;
              IF  g_tab_queue_files(i).hftq_content IS NOT NULL
              THEN
                 exec_code := exec_code
                         ||' nm3file.blob_to_file(pi_blob => :pi_blob, pi_destination_dir => nm3file.get_oracle_directory(:pi_dest_dir), pi_destination_file => :pi_dest_file); '||g_nl
                     ||'END; '''||g_nl
                  ||' USING IN OUT '||g_package_name||'.g_tab_queue_files('||i||').hftq_content'||g_nl
                       ||', IN '||g_package_name||'.g_tab_queue_files('||i||').hftq_destination'||g_nl
                       ||', IN NVL('||g_package_name||'.g_tab_queue_files('||i||').hftq_destination_filename ,'||g_nl
                       ||'         '||g_package_name||'.g_tab_queue_files('||i||').hftq_source_filename);'||g_nl;
              ELSE
                exec_code := exec_code
                         ||' nm3file.copy_file( pi_source_dir        => nm3file.get_oracle_directory(:pi_source_dir) '||g_nl
                                           ||', pi_source_file       => :pi_source_file '||g_nl
                                           ||', pi_destination_dir   => nm3file.get_oracle_directory(:pi_dest_dir) '||g_nl
                                           ||', pi_destination_file  => :pi_dest_file '||g_nl
                                           ||', pi_overwrite         => nm3flx.char_to_boolean(:pi_overwrite) '||g_nl
                                           ||', pi_leave_original    => nm3flx.char_to_boolean(:pi_leave_orig) ); '||g_nl
                     ||'END; '''||g_nl
                  ||' USING IN '||g_package_name||'.g_tab_queue_files('||i||').hftq_source'||g_nl
                       ||', IN '||g_package_name||'.g_tab_queue_files('||i||').hftq_source_filename'||g_nl
                       ||', IN '||g_package_name||'.g_tab_queue_files('||i||').hftq_destination'||g_nl
                       ||', IN NVL('||g_package_name||'.g_tab_queue_files('||i||').hftq_destination_filename ,'||g_nl
                       ||'         '||g_package_name||'.g_tab_queue_files('||i||').hftq_source_filename)'||g_nl
                       ||', IN  ''TRUE'''||g_nl
                       ||', IN  ''TRUE'''||';'||g_nl;
              END IF;
          --
            END IF;
          --
            IF g_tab_queue_files(i).hftq_destination_type = 'TABLE'
            THEN
                exec_code := exec_code
            ||       '''BEGIN  '||g_nl;
                exec_code := exec_code
                         || ' UPDATE '|| g_tab_queue_files(i).hftq_destination ||g_nl
                             || 'SET '|| g_tab_queue_files(i).hftq_destination_column ||' = :pi_blob '||g_nl
                           ||' WHERE '|| REPLACE(
                                              REPLACE (g_tab_queue_files(i).hftq_condition, 'WHERE',''),';','')||';'||g_nl
                     ||' END; '''||g_nl||
               --
                  CASE WHEN g_tab_queue_files(i).hftq_content IS NOT NULL
                  -------------------------------------------------------
                  -- BLOB already read in and passed into the file queue
                  -------------------------------------------------------
                  THEN ' USING IN '||g_package_name||'.g_tab_queue_files('||i||').hftq_content;'||g_nl
                  -------------------------------------
                  -- BLOB needs reading in from source
                  -------------------------------------
                  ELSE ' USING IN nm3file.file_to_blob(pi_source_dir  => nm3file.get_oracle_directory('||g_package_name||'.g_tab_queue_files('||i||').hftq_source'||') '||g_nl
                                                 || ' ,pi_source_file => '||g_package_name||'.g_tab_queue_files('||i||').hftq_source_filename'||') ;'||g_nl
                  END;
          --
            END IF;
          --
            IF g_tab_queue_files(i).hftq_destination_type = 'DB_SERVER'
          --
          -- Use nm3file to copy the files between oracle directories
          --
            THEN
            --
              l_to_dir_name := create_dir_on_fly ( pi_path =>g_tab_queue_files(i).hftq_destination);
            --
              exec_code := exec_code
          ||       '''BEGIN  '||g_nl;
              IF  g_tab_queue_files(i).hftq_content IS NOT NULL
              THEN
                 exec_code := exec_code
                         ||' nm3file.blob_to_file(pi_blob => :pi_blob, pi_destination_dir => :pi_dest_dir, pi_destination_file => :pi_dest_file); '||g_nl
                     ||'END; '''||g_nl
                  ||' USING IN OUT '||g_package_name||'.g_tab_queue_files('||i||').hftq_content'||g_nl
                     ---  ||', IN '||g_package_name||'.g_tab_queue_files('||i||').hftq_destination'||g_nl
                       ||', IN '||nm3flx.string(l_to_dir_name)||g_nl
                       ||', IN NVL('||g_package_name||'.g_tab_queue_files('||i||').hftq_destination_filename ,'||g_nl
                       ||'         '||g_package_name||'.g_tab_queue_files('||i||').hftq_source_filename);'||g_nl;
              ELSE
                exec_code := exec_code
                         ||' nm3file.copy_file( pi_source_dir        => nm3file.get_oracle_directory(:pi_source_dir) '||g_nl
                                           ||', pi_source_file       => :pi_source_file '||g_nl
                                           ||', pi_destination_dir   => :pi_dest_dir '||g_nl
                                           ||', pi_destination_file  => :pi_dest_file '||g_nl
                                           ||', pi_overwrite         => nm3flx.char_to_boolean(:pi_overwrite) '||g_nl
                                           ||', pi_leave_original    => nm3flx.char_to_boolean(:pi_leave_orig) ); '||g_nl
                     ||'END; '''||g_nl
                  ||' USING IN '||g_package_name||'.g_tab_queue_files('||i||').hftq_source'||g_nl
                       ||', IN '||g_package_name||'.g_tab_queue_files('||i||').hftq_source_filename'||g_nl
                       --||', IN '||g_package_name||'.g_tab_queue_files('||i||').hftq_destination'||g_nl
                       ||', IN '||nm3flx.string(l_to_dir_name)||g_nl
                       ||', IN NVL('||g_package_name||'.g_tab_queue_files('||i||').hftq_destination_filename ,'||g_nl
                       ||'         '||g_package_name||'.g_tab_queue_files('||i||').hftq_source_filename)'||g_nl
                       ||', IN  ''TRUE'''||g_nl
                       ||', IN  ''TRUE'''||';'||g_nl;
              END IF;
            --
            END IF;
        /*
        ***********************************************************************
        **              Transfer Source = DB_SERVER
        ***********************************************************************
        */
          WHEN g_tab_queue_files(i).hftq_source_type      = 'DB_SERVER'
          THEN
          --
            IF g_tab_queue_files(i).hftq_destination_type = 'DB_SERVER'
            THEN
            --
              l_to_dir_name   := create_dir_on_fly ( pi_path => g_tab_queue_files(i).hftq_destination );
              l_from_dir_name := create_dir_on_fly ( pi_path => g_tab_queue_files(i).hftq_source );
            --
              exec_code := exec_code
          ||       '''BEGIN  '||g_nl;
              IF  g_tab_queue_files(i).hftq_content IS NOT NULL
              THEN
                 exec_code := exec_code
                         ||' nm3file.blob_to_file(pi_blob => :pi_blob, pi_destination_dir => :pi_dest_dir, pi_destination_file => :pi_dest_file); '||g_nl
                     ||'END; '''||g_nl
                  ||' USING IN OUT '||g_package_name||'.g_tab_queue_files('||i||').hftq_content'||g_nl
                       --||', IN '||g_package_name||'.g_tab_queue_files('||i||').hftq_destination'||g_nl
                       ||', IN '||nm3flx.string(l_to_dir_name)||g_nl
                       ||', IN NVL('||g_package_name||'.g_tab_queue_files('||i||').hftq_destination_filename ,'||g_nl
                       ||'         '||g_package_name||'.g_tab_queue_files('||i||').hftq_source_filename);'||g_nl;
              ELSE
                exec_code := exec_code
                         ||' nm3file.copy_file( pi_source_dir        => :pi_source_dir '||g_nl
                                           ||', pi_source_file       => :pi_source_file '||g_nl
                                           ||', pi_destination_dir   => :pi_dest_dir '||g_nl
                                           ||', pi_destination_file  => :pi_dest_file '||g_nl
                                           ||', pi_overwrite         => nm3flx.char_to_boolean(:pi_overwrite) '||g_nl
                                           ||', pi_leave_original    => nm3flx.char_to_boolean(:pi_leave_orig) ); '||g_nl
                     ||'END; '''||g_nl
                  ||' USING IN '||nm3flx.string(l_from_dir_name)||g_nl
                       ||', IN '||g_package_name||'.g_tab_queue_files('||i||').hftq_source_filename'||g_nl
                       ||', IN '||nm3flx.string(l_to_dir_name)||g_nl
                       ||', IN NVL('||g_package_name||'.g_tab_queue_files('||i||').hftq_destination_filename ,'||g_nl
                       ||'         '||g_package_name||'.g_tab_queue_files('||i||').hftq_source_filename)'||g_nl
                       ||', IN  ''TRUE'''||g_nl
                       ||', IN  ''TRUE'''||';'||g_nl;
              END IF;
            --
            END IF;
          --
            IF g_tab_queue_files(i).hftq_destination_type = 'ORACLE_DIRECTORY'
            THEN
            --
              l_from_dir_name := create_dir_on_fly ( pi_path => g_tab_queue_files(i).hftq_source);
            --
              exec_code := exec_code
          ||       '''BEGIN  '||g_nl;
              IF  g_tab_queue_files(i).hftq_content IS NOT NULL
              THEN
                 exec_code := exec_code
                         ||' nm3file.blob_to_file(pi_blob => :pi_blob, pi_destination_dir => :pi_dest_dir, pi_destination_file => :pi_dest_file); '||g_nl
                     ||'END; '''||g_nl
                  ||' USING IN OUT '||g_package_name||'.g_tab_queue_files('||i||').hftq_content'||g_nl
                       ||', IN '||g_package_name||'.g_tab_queue_files('||i||').hftq_destination'||g_nl
                       ||', IN NVL('||g_package_name||'.g_tab_queue_files('||i||').hftq_destination_filename ,'||g_nl
                       ||'         '||g_package_name||'.g_tab_queue_files('||i||').hftq_source_filename);'||g_nl;
              ELSE
                exec_code := exec_code
                         ||' nm3file.copy_file( pi_source_dir        => :pi_source_dir '||g_nl
                                           ||', pi_source_file       => :pi_source_file '||g_nl
                                           ||', pi_destination_dir   => :pi_dest_dir '||g_nl
                                           ||', pi_destination_file  => :pi_dest_file '||g_nl
                                           ||', pi_overwrite         => nm3flx.char_to_boolean(:pi_overwrite) '||g_nl
                                           ||', pi_leave_original    => nm3flx.char_to_boolean(:pi_leave_orig) ); '||g_nl
                     ||'END; '''||g_nl
                  ||' USING IN '||nm3flx.string(l_from_dir_name)||g_nl
                       ||', IN '||g_package_name||'.g_tab_queue_files('||i||').hftq_source_filename'||g_nl
                       ||', IN '||g_package_name||'.g_tab_queue_files('||i||').hftq_destination'||g_nl
                       ||', IN NVL('||g_package_name||'.g_tab_queue_files('||i||').hftq_destination_filename ,'||g_nl
                       ||'         '||g_package_name||'.g_tab_queue_files('||i||').hftq_source_filename)'||g_nl
                       ||', IN  ''TRUE'''||g_nl
                       ||', IN  ''TRUE'''||';'||g_nl;
              END IF;
            --
            END IF;
          --
            IF g_tab_queue_files(i).hftq_destination_type = 'TABLE'
            THEN
            --
              l_from_dir_name := create_dir_on_fly ( pi_path => g_tab_queue_files(i).hftq_source);
            --
              exec_code := exec_code
            ||       '''BEGIN  '||g_nl;
                exec_code := exec_code
                         || ' UPDATE '|| g_tab_queue_files(i).hftq_destination ||g_nl
                             || 'SET '|| g_tab_queue_files(i).hftq_destination_column ||' = :pi_blob '||g_nl
                           ||' WHERE '|| REPLACE(
                                              REPLACE (g_tab_queue_files(i).hftq_condition, 'WHERE',''),';','')||';'||g_nl
                     ||' END; '''||g_nl||
               --
                  CASE WHEN g_tab_queue_files(i).hftq_content IS NOT NULL
                  -------------------------------------------------------
                  -- BLOB already read in and passed into the file queue
                  -------------------------------------------------------
                  THEN ' USING IN '||g_package_name||'.g_tab_queue_files('||i||').hftq_content;'||g_nl
                  -------------------------------------
                  -- BLOB needs reading in from source
                  -------------------------------------
                  ELSE ' USING IN nm3file.file_to_blob(pi_source_dir  => '||nm3flx.string(l_from_dir_name)||g_nl
                                                 || ' ,pi_source_file => '||g_package_name||'.g_tab_queue_files('||i||').hftq_source_filename'||') ;'||g_nl
                  END;
            --
            END IF;
        --
        /*
        ***********************************************************************
        **                   Transfer Source =  TABLE
        ***********************************************************************
        */
          WHEN g_tab_queue_files(i).hftq_source_type      = 'TABLE'
          THEN
          --
            IF g_tab_queue_files(i).hftq_destination_type = 'ORACLE_DIRECTORY'
            THEN
           --
              exec_code := exec_code
              ||       '''DECLARE  '||g_nl
              ||            ' l_blob_content BLOB;'||g_nl
              ||       '  BEGIN  '||g_nl;
             --
             -- Read the blob from the source table
             --
              CASE 
                WHEN g_tab_queue_files(i).hftq_content IS NULL
                THEN
                exec_code := exec_code
                      ||' SELECT '||g_tab_queue_files(i).hftq_source_column ||g_nl
                        ||' INTO l_blob_content '||g_nl
                        ||' FROM '||g_tab_queue_files(i).hftq_source ||g_nl
                       ||' WHERE '|| REPLACE(
                                        REPLACE (g_tab_queue_files(i).hftq_condition, 'WHERE',''),';','')||';'||g_nl
                    ||' -- '||g_nl
                      || ' nm3file.blob_to_file(l_blob_content, '
                                             || nm3flx.string(nm3flx.string(g_tab_queue_files(i).hftq_destination))||','
                                             || nm3flx.string(nm3flx.string(g_tab_queue_files(i).hftq_destination_filename))||');'
                   ||' END; '';'||g_nl;
                ELSE
            --
            -- Read the blob from the file queue 
            --
                exec_code := exec_code
                      || ' nm3file.blob_to_file(:blob_content, '
                                             || nm3flx.string(nm3flx.string(g_tab_queue_files(i).hftq_destination))||','
                                             || nm3flx.string(nm3flx.string(g_tab_queue_files(i).hftq_destination_filename))||');'
                   ||' END; '''||g_nl
              ||' USING IN OUT '||g_package_name||'.g_tab_queue_files('||i||').hftq_content;'||g_nl;
            --
              END CASE;
            --
            END IF;
          --
            IF g_tab_queue_files(i).hftq_destination_type = 'TABLE'
          --
            THEN
                 exec_code := exec_code
             ||       '''BEGIN  '||g_nl;
                 exec_code := exec_code
                          || ' UPDATE '|| g_tab_queue_files(i).hftq_destination ||g_nl
                              || 'SET '|| g_tab_queue_files(i).hftq_destination_column ||' = :pi_blob '||g_nl
                            ||' WHERE '|| REPLACE(
                                               REPLACE (g_tab_queue_files(i).hftq_condition, 'WHERE',''),';','')||';'||g_nl
                      ||' END; '''||g_nl||
                --
                -- Must be passed in on the transfer table - this is validated upfront so will always be set.
                --
                ' USING IN '||g_package_name||'.g_tab_queue_files('||i||').hftq_content;'||g_nl;
                --
            END IF;
         --
            IF g_tab_queue_files(i).hftq_destination_type = 'DB_SERVER'
             THEN
           --
             l_to_dir_name := create_dir_on_fly ( pi_path =>g_tab_queue_files(i).hftq_destination);
           --
               exec_code := exec_code
              ||       '''DECLARE  '||g_nl
              ||            ' l_blob_content BLOB;'||g_nl
              ||       '  BEGIN  '||g_nl;
             --
             -- Read the blob from the source table
             --
              CASE 
                WHEN g_tab_queue_files(i).hftq_content IS NULL
                THEN
                exec_code := exec_code
                      ||' SELECT '||g_tab_queue_files(i).hftq_source_column ||g_nl
                        ||' INTO l_blob_content '||g_nl
                        ||' FROM '||g_tab_queue_files(i).hftq_source ||g_nl
                       ||' WHERE '|| REPLACE(
                                        REPLACE (g_tab_queue_files(i).hftq_condition, 'WHERE',''),';','')||';'||g_nl
                    ||' -- '||g_nl
                      || ' nm3file.blob_to_file(l_blob_content, '
                                             || nm3flx.string(nm3flx.string(l_to_dir_name))||','
                                             || nm3flx.string(nm3flx.string(g_tab_queue_files(i).hftq_destination_filename))||');'
                   ||' END; '';'||g_nl;
                ELSE
            --
            -- Read the blob from the file queue 
            --
                exec_code := exec_code
                      || ' nm3file.blob_to_file(:blob_content, '
                                             || nm3flx.string(nm3flx.string(l_to_dir_name))||','
                                             || nm3flx.string(nm3flx.string(g_tab_queue_files(i).hftq_destination_filename))||');'
                   ||' END; '''||g_nl
              ||' USING IN OUT '||g_package_name||'.g_tab_queue_files('||i||').hftq_content;'||g_nl;
            --
              END CASE;
            --
            END IF;
          --
        --
        END CASE ;
      --
      END IF;
    --
    ELSIF g_tab_queue_files(i).hftq_direction = 'OUT'
    THEN
      NULL;
    END IF;
  --
    exec_code := exec_code || ' END;';
  --
    nm_debug.debug(exec_code);
  --
    BEGIN
    --
    -- Validate the record before executing it
    --
       validate_file_queue_record
             ( pi_rec_hftq => g_tab_queue_files(i) );
    --
      EXECUTE IMMEDIATE exec_code;
    --
      log_transfer
            ( pi_hftq_id       => g_tab_queue_files(i).hftq_id
            , pi_hftq_batch_no => g_tab_queue_files(i).hftq_batch_no
            , pi_filename      => NVL(g_tab_queue_files(i).hftq_destination_filename, g_tab_queue_files(i).hftq_source_filename)
            , pi_destination   => g_tab_queue_files(i).hftq_destination
            , pi_message       => 'Transfer successfully completed - '||g_tab_queue_files(i).hftq_comments
            );
    --
      UPDATE hig_file_transfer_queue
         SET hftq_status = g_complete
       WHERE hftq_id = g_tab_queue_files(i).hftq_id;
    --
      drop_dir_on_fly(l_to_dir_name);
      drop_dir_on_fly(l_from_dir_name);
    --
    EXCEPTION
      WHEN OTHERS 
      THEN
      log_transfer
            ( pi_hftq_id       => g_tab_queue_files(i).hftq_id
            , pi_hftq_batch_no => g_tab_queue_files(i).hftq_batch_no
            , pi_filename      => NVL(g_tab_queue_files(i).hftq_destination_filename, g_tab_queue_files(i).hftq_source_filename)
            , pi_destination   => g_tab_queue_files(i).hftq_destination
            , pi_message       => 'Transfer failed - '||SUBSTR(SQLERRM,0,1950)
            );
    --
      UPDATE hig_file_transfer_queue
         SET hftq_status = g_error
       WHERE hftq_id = g_tab_queue_files(i).hftq_id;
    --
      drop_dir_on_fly(l_to_dir_name);
      drop_dir_on_fly(l_from_dir_name);
    --
    END;
  --
  END LOOP;
--
END do_transfer;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_file_queue ( pi_hftq_batch_no IN hig_file_transfer_queue.hftq_batch_no%TYPE )
IS
--
  l_file_queue   tab_hftq;
  l_blob         BLOB;
--
BEGIN
--
  SELECT * BULK COLLECT INTO g_tab_queue_files
    FROM hig_file_transfer_queue
   WHERE hftq_batch_no = pi_hftq_batch_no
     AND hftq_status = g_pending
   ORDER BY hftq_id ;
  --
  IF g_tab_queue_files.COUNT > 0
  THEN
    do_transfer;
  ELSE
    RAISE_APPLICATION_ERROR (-20101,'No files marked for transfer ['||pi_hftq_batch_no||']');
  END IF;
  --
--
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE reprocess_file_queue ( pi_hftq_batch_no IN hig_file_transfer_queue.hftq_batch_no%TYPE 
                               , po_success OUT BOOLEAN
                               , po_error_message OUT VARCHAR2)
IS
--
   CURSOR check_success_cur IS
   SELECT 'X'
    FROM hig_file_transfer_queue
   WHERE hftq_batch_no = pi_hftq_batch_no
     AND hftq_status = g_error;
   
  l_file_queue   tab_hftq;
  l_blob         BLOB;
  l_dummy        varchar2(1);
--
BEGIN
--
  SELECT * BULK COLLECT INTO g_tab_queue_files
    FROM hig_file_transfer_queue
   WHERE hftq_batch_no = pi_hftq_batch_no
     AND hftq_status = g_error
   ORDER BY hftq_id ;
  --
  IF g_tab_queue_files.COUNT > 0
  THEN
    do_transfer;
    COMMIT;
    
    OPEN check_success_cur;
    FETCH check_success_cur INTO l_dummy;
    CLOSE check_success_cur;
    --
    IF l_dummy IS NULL THEN
      po_success:= TRUE;
    ELSE
      po_success:= FALSE;
      po_error_message := 'Load Unsuccessful: Some files were not transfered.';
    END IF;
  ELSE
    po_success:= FALSE;
    po_error_message := 'Load Unsuccessful: No files need to be retransfered for batch ['||pi_hftq_batch_no||']';
  END IF;
  --
--
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE reprocess_files ( pi_hftq_tab IN tab_file_id)
IS
--
  l_file_queue   tab_hftq;
  l_blob         BLOB;
  l_dummy        varchar2(1);
--
BEGIN
--
  FOR i IN pi_hftq_tab.FIRST..pi_hftq_tab.LAST LOOP
  --
  SELECT * INTO g_tab_queue_files(i)
    FROM hig_file_transfer_queue
   WHERE hftq_id = pi_hftq_tab(i);
  --
  END LOOP;
  --
  IF g_tab_queue_files.COUNT > 0
  THEN
    do_transfer;
    COMMIT;
  END IF;
  commit;
  --
--
END;
--
-----------------------------------------------------------------------------
--
END hig_file_transfer_api;
/

