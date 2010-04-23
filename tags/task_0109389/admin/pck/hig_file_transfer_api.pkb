CREATE OR REPLACE PACKAGE BODY hig_file_transfer_api
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/hig_file_transfer_api.pkb-arc   3.0   Apr 23 2010 14:19:08   malexander  $
--       Module Name      : $Workfile:   hig_file_transfer_api.pkb  $
--       Date into PVCS   : $Date:   Apr 23 2010 14:19:08  $
--       Date fetched Out : $Modtime:   Apr 23 2010 14:18:46  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid    CONSTANT VARCHAR2(2000) := '$Revision:   3.0  $';
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
      l_tab_queue(i).hftq_initiated_by         := USER;
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
PROCEDURE do_transfer
IS
  l_transfer_to_from VARCHAR2(50);
  exec_code          nm3type.max_varchar2;
BEGIN
--
  nm_debug.debug_on;
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
        --
          WHEN g_tab_queue_files(i).hftq_source_type      = 'ORACLE_DIRECTORY'
           AND g_tab_queue_files(i).hftq_destination_type = 'ORACLE_DIRECTORY'
        --
        -------------------------------------------------
        -- Transfer Oracle Directory >> Oracle Directory
        -------------------------------------------------
        --
        -- Use nm3file to copy the files between oracle directories
        --
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
          WHEN g_tab_queue_files(i).hftq_source_type      = 'ORACLE_DIRECTORY'
           AND g_tab_queue_files(i).hftq_destination_type = 'TABLE'
        --
        -------------------------------------------------
        -- Transfer Oracle Directory >> Table
        -------------------------------------------------
        --
        --
        -- Use nm3file to copy the files between oracle directories
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
                 CASE WHEN g_tab_queue_files(i).hftq_content IS NOT NULL
                 -------------------------------------------------------
                 -- BLOB already read in and passed into the file queue
                 -------------------------------------------------------
                 THEN ' USING IN '||g_package_name||'.g_tab_queue_files('||i||').hftq_content;'||g_nl
                 -------------------------------------
                 -- BLOB needs reading in from source
                 -------------------------------------
                 ELSE ' USING IN nm3file.file_to_blob(pi_source_dir  => nm3file.get_oracle_directory(nm3flx.string('||g_package_name||'.g_tab_queue_files('||i||').hftq_source'||')) '||g_nl
                                                || ' ,pi_source_file => nm3flx.string('||g_package_name||'.g_tab_queue_files('||i||').hftq_source_filename'||')) ;'||g_nl
                 END;
        --
--
--          WHEN g_tab_queue_files(i).hftq_source_type      = 'TABLE'
--           AND g_tab_queue_files(i).hftq_destination_type = 'ORACLE_DIRECTORY'
--        --
--        -------------------------------------------------
--        -- Transfer Oracle Directory >> Table
--        -------------------------------------------------
--        --
--        --
--        -- Use nm3file to copy the files between oracle directories
--        --
--          THEN
--               exec_code := exec_code
--           ||       '''BEGIN  '||g_nl;
--               exec_code := exec_code
--                        || ' UPDATE '|| g_tab_queue_files(i).hftq_destination ||g_nl
--                            || 'SET '|| g_tab_queue_files(i).hftq_destination_column ||' = :pi_blob '||g_nl
--                          ||' WHERE '|| REPLACE(
--                                             REPLACE (g_tab_queue_files(i).hftq_condition, 'WHERE',''),';','')||';'||g_nl
--                    ||' END; '''||g_nl||
--              --
--                 CASE WHEN g_tab_queue_files(i).hftq_content IS NOT NULL
--                 -------------------------------------------------------
--                 -- BLOB already read in and passed into the file queue
--                 -------------------------------------------------------
--                 THEN ' USING IN '||g_package_name||'.g_tab_queue_files('||i||').hftq_content;'||g_nl
--                 -------------------------------------
--                 -- BLOB needs reading in from source
--                 -------------------------------------
--                 ELSE ' USING IN nm3file.file_to_blob(pi_source_dir  => nm3file.get_oracle_directory(nm3flx.string('||g_package_name||'.g_tab_queue_files('||i||').hftq_source'||')) '||g_nl
--                                                || ' ,pi_source_file => nm3flx.string('||g_package_name||'.g_tab_queue_files('||i||').hftq_source_filename'||')) ;'||g_nl
--                 END;
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
