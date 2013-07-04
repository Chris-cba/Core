CREATE OR REPLACE PACKAGE BODY nm3mapcapture_int AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3mapcapture_int.pkb-arc   2.6   Jul 04 2013 16:14:40   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3mapcapture_int.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:14:40  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:16  $
--       Version          : $Revision:   2.6  $
--       Based on SCCS version : 1.12
-------------------------------------------------------------------------
--   Author : Darren Cope
--
--   MapCapture File Loader 
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   --g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)nm3mapcapture_int.pkb	1.12 01/08/04"';
   g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.6  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3mapcapture_int';
--  
   SUBTYPE file_name IS varchar2(256);
--
   c_end_of_trail_file_marker CONSTANT varchar2(1) := 'Z';
   c_mapcap_dir               CONSTANT hig_option_values.hov_value%TYPE := hig.get_sysopt('MAPCAP_DIR');
   c_what                     CONSTANT user_jobs.what%TYPE              :=  g_package_name||'.batch_loader;';
   g_mapcapture_holding_table CONSTANT varchar2(30) := 'NM_LD_MC_ALL_INV_TMP';
   -- a flag to indicate if errors have occurred
   g_success                           boolean DEFAULT TRUE;

--
   TYPE rec_errors IS RECORD
       (appl      hig_errors.her_appl%TYPE
       ,error_no  hig_errors.her_no%TYPE
       ,supp_info varchar2(2000)
       ,batch_no  nm_load_batch_lock.nlbl_batch_id%TYPE
       ,in_prc    varchar2(50)
       );

   TYPE tab_errors IS TABLE OF rec_errors INDEX BY binary_integer;
   
   g_errors tab_errors;
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
FUNCTION get_mapcap_email_recipients RETURN nm3mail.tab_recipient IS
l_recip nm3mail.tab_recipient;
BEGIN
  -- construct the recipients of the email
  l_recip(1).rcpt_id   := hig.get_sysopt('MAPCAP_EML');
  l_recip(1).rcpt_type := nm3mail.c_group;
  
  RETURN l_recip;
END get_mapcap_email_recipients;
--
-----------------------------------------------------------------------------
--
PROCEDURE send_email(p_body    IN nm3type.tab_varchar32767
                    ,p_subject IN varchar2) IS
   PRAGMA AUTONOMOUS_TRANSACTION;

l_to      nm3mail.tab_recipient;
l_cc      nm3mail.tab_recipient;
l_bcc     nm3mail.tab_recipient;
BEGIN
  l_to := get_mapcap_email_recipients;
  -- now put it in the queue
  nm3mail.write_mail_complete(p_from_user        => nm3mail.get_default_nmu_id
                             ,p_subject          => p_subject
                             ,p_html_mail        => FALSE
                             ,p_tab_to           => l_to
                             ,p_tab_cc           => l_cc
                             ,p_tab_bcc          => l_bcc
                             ,p_tab_message_text => p_body);
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    COMMIT;
END send_email;
--
-----------------------------------------------------------------------------
--
PROCEDURE send_email(p_body    IN varchar2
                    ,p_subject IN varchar2) IS
l_tab_vc nm3type.tab_varchar32767;
BEGIN
  l_tab_vc(1) := p_body;
  send_email(l_tab_vc
            ,p_subject);
END send_email;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_errors IS
BEGIN
  g_errors.DELETE;
  g_success := TRUE;
END clear_errors;
--
-----------------------------------------------------------------------------
--
PROCEDURE send_error_email(pi_batch IN varchar2 DEFAULT NULL) IS

l_subject        nm_mail_message.nmm_subject%TYPE := 'MapCapture Error log';
l_error_msg_body nm3type.tab_varchar32767;
l_line           nm3type.max_varchar2;
--
PROCEDURE nl IS
BEGIN
  l_error_msg_body(l_error_msg_body.COUNT+1) := nm3type.c_newline;
END nl;
--
PROCEDURE add_line(p_to_add IN varchar2
                  ,p_add_cr IN boolean DEFAULT TRUE) IS
BEGIN
  l_error_msg_body(l_error_msg_body.COUNT+1) := p_to_add;
  IF p_add_cr THEN
    nl;
  END IF;
END add_line;
--
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'send_error_email');
  
  nm_debug.debug(g_errors.COUNT||' errors on stack');
  
  IF pi_batch IS NOT NULL THEN
    l_subject := l_subject || ' for batch '||pi_batch;
  END IF;
  
  FOR I IN 1..g_errors.COUNT LOOP
    
    add_line(hig.raise_and_catch_ner(pi_appl => g_errors(i).appl
                                    ,pi_id   => g_errors(i).error_no
                                    ,pi_supplementary_info => NULL));
    
    IF g_errors(i).batch_no IS NOT NULL THEN
      add_line(' found during processing of batch '||g_errors(i).batch_no);
    END IF;
    
    IF g_errors(i).in_prc IS NOT NULL THEN
      add_line(' caught in '||g_errors(i).in_prc);
    END IF;
    
  
    IF g_errors(i).supp_info IS NOT NULL THEN
      add_line('Supporting details: '||g_errors(i).supp_info);
      
    END IF;

    nl;
    nl;
    nl;
  END LOOP;
  
  IF g_errors.COUNT > 0 THEN
    send_email(p_body    => l_error_msg_body
              ,p_subject => l_subject);
  END IF;

  -- clear the errors
  clear_errors;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'send_error_email');
END send_error_email;
--
-----------------------------------------------------------------------------
--
PROCEDURE catch_error(p_appl    IN hig_errors.her_appl%TYPE DEFAULT nm3type.c_hig
                     ,p_error   IN hig_errors.her_no%TYPE   DEFAULT 207
                     ,p_supp    IN varchar2 DEFAULT NULL
                     ,p_batch   IN varchar2 DEFAULT NULL
                     ,p_in_prc  IN varchar2 DEFAULT NULL) IS

l_new_error_no pls_integer DEFAULT g_errors.COUNT +1;
BEGIN

  nm_debug.debug('Error caught in '||p_in_prc||' is '||p_supp);

  g_success := FALSE;
  
  g_errors(l_new_error_no).appl      := p_appl;
  g_errors(l_new_error_no).error_no  := p_error;
  g_errors(l_new_error_no).supp_info := p_supp;
  g_errors(l_new_error_no).batch_no  := p_batch;
  g_errors(l_new_error_no).in_prc    := p_in_prc;

END;
--
-----------------------------------------------------------------------------
-- 
PROCEDURE clear_who_trigger IS
CURSOR check_for_trigger IS
SELECT trigger_name
FROM   user_triggers
WHERE  table_name = g_mapcapture_holding_table
AND    trigger_name LIKE '%WHO';

BEGIN
  FOR i IN check_for_trigger LOOP
    EXECUTE IMMEDIATE 'DROP TRIGGER '||i.trigger_name;
  END LOOP;
  
EXCEPTION
  WHEN OTHERS THEN
    catch_error(p_appl   => nm3type.c_hig
               ,p_error  => 207
               ,p_supp   => sqlerrm
               ,p_batch  => NULL
               ,p_in_prc => 'clear_who_trigger');
END clear_who_trigger;
--
-----------------------------------------------------------------------------
--
FUNCTION get_csv_value_from_line (p_line       IN varchar2
                                 ,p_field      IN pls_integer
                                 ) RETURN varchar2 IS
   l_substr_before PLS_INTEGER;
   l_substr_after  PLS_INTEGER;
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_csv_value_from_line');
  IF p_field = 1 THEN
    l_substr_before := 1;
  ELSE
    l_substr_before := INSTR(p_line,',',1,p_field - 1)+1;
  END IF;

  l_substr_after := INSTR(p_line,',',1,p_field)-1;

  IF NVL(l_substr_after,-1) = -1 THEN
    l_substr_after := LENGTH(p_line);
  END IF;
   
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_csv_value_from_line');
                   
  RETURN nm3flx.mid(p_line,l_substr_before, l_substr_after);
   
END get_csv_value_from_line;
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
FUNCTION batch_is_locked(pi_batch IN varchar2) RETURN boolean IS

CURSOR is_locked(pi_batch IN varchar2) IS
SELECT 1
FROM   nm_load_batch_lock
WHERE  nlbl_batch_id = pi_batch;

dummy   pls_integer;
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'batch_is_locked');

  OPEN is_locked(remove_file_extension(pi_batch));
  FETCH is_locked INTO dummy;
  IF is_locked%FOUND THEN
    CLOSE is_locked;
    RETURN TRUE;
  ELSE
    CLOSE is_locked;
    nm_debug.proc_end(p_package_name   => g_package_name
                     ,p_procedure_name => 'batch_is_locked');
    RETURN FALSE;
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    catch_error(p_appl   => nm3type.c_hig
               ,p_error  => 207
               ,p_supp   => sqlerrm
               ,p_batch  => pi_batch
               ,p_in_prc => 'batch_is_locked');
END batch_is_locked;
--
-----------------------------------------------------------------------------
--
FUNCTION can_be_loaded(pi_batch IN varchar2) RETURN boolean IS
l_file_cont nm3type.tab_varchar32767;
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'can_be_loaded');
  
  -- check that the batch has not already been loaded or that it
  -- is in the process of being loaded
  IF batch_is_locked(pi_batch) THEN
    RETURN FALSE;
  END IF;
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'can_be_loaded');
  RETURN TRUE;
END can_be_loaded;
--
-----------------------------------------------------------------------------
--
FUNCTION number_of_datafiles(pi_batch in varchar2) RETURN pls_integer IS
  l_files nm3file.file_list;
  l_count pls_integer := 0;
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'number_of_datafiles');
  l_files := nm3file.get_files_in_directory(c_mapcap_dir, c_datafile_extension);
  
  FOR i IN 1..l_files.COUNT LOOP
  
    IF INSTR(remove_file_extension(l_files(i)), pi_batch) > 0 THEN
      l_count := l_count + 1;
    END IF;
  
  END LOOP;
  
  nm_debug.debug('Found '||l_count||' datafiles in batch');
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'number_of_datafiles');
  RETURN l_count;
END number_of_datafiles;
--
-----------------------------------------------------------------------------
--
FUNCTION get_inv_type_of_file(pi_batch    IN varchar2
                             ,pi_datafile IN varchar2) RETURN varchar2 IS
BEGIN
  RETURN UPPER(SUBSTR(pi_datafile, 1, INSTR(pi_datafile, pi_batch, -1) -2));
END get_inv_type_of_file;
--
-----------------------------------------------------------------------------
--
FUNCTION check_edif_date (pi_batch IN varchar2) RETURN boolean IS

CURSOR get_latest_metamodel_change IS
SELECT MAX(date_modified)
FROM 
(SELECT MAX(ial_date_modified) date_modified
FROM NM_INV_ATTRI_LOOKUP_ALL
UNION
SELECT MAX(id_date_modified)
FROM NM_INV_DOMAINS_ALL
UNION
SELECT MAX(nit_date_modified)
FROM NM_INV_TYPES_ALL
UNION
SELECT MAX(ita_date_modified)
FROM NM_INV_TYPE_ATTRIBS_ALL
UNION
SELECT MAX(itg_date_modified)
FROM NM_INV_TYPE_GROUPINGS_ALL
UNION
SELECT MAX(nwx_date_modified)
FROM NM_XSP
UNION
SELECT MAX(xsr_date_modified)
FROM XSP_RESTRAINTS
);

l_file nm3type.tab_varchar32767;
l_edif_date DATE;
l_header_file file_name := pi_batch||nm3type.c_dot||c_headfile_extension;
l_latest_change DATE;

BEGIN

  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'check_edif_date');

  -- read the header control file for details
  nm3file.get_file(location     => c_mapcap_dir
                  ,filename     => l_header_file
                  ,all_lines    => l_file);
  BEGIN
    l_edif_date := TO_DATE(l_file(1), c_edif_date_format);
  EXCEPTION
    WHEN OTHERS THEN
      catch_error(p_appl   => nm3type.c_hig
                 ,p_error  => 148
                 ,p_batch  => pi_batch
                 ,p_in_prc => NULL
                 ,p_supp   => 'Edif Date');

      RETURN FALSE;
  END;
  
  -- check all file modification dates on the inventory metamodel
  OPEN  get_latest_metamodel_change;
  FETCH get_latest_metamodel_change INTO l_latest_change;
  CLOSE get_latest_metamodel_change;
  
  IF l_latest_change > l_edif_date THEN

    catch_error(p_appl   => nm3type.c_hig
               ,p_error  => 206
               ,p_batch  => pi_batch
               ,p_in_prc => 'check_edif_date');

    RETURN FALSE;
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'check_edif_date');

  RETURN TRUE;

EXCEPTION 
  WHEN OTHERS THEN
    catch_error(p_appl   => nm3type.c_hig
               ,p_error  => 207
               ,p_supp   => sqlerrm
               ,p_batch  => pi_batch
               ,p_in_prc => 'check_edif_date');
    RETURN FALSE;
END check_edif_date;
--
-----------------------------------------------------------------------------
--
FUNCTION batch_is_ready_to_load(pi_batch_header IN varchar2) RETURN boolean IS

l_batch             file_name := remove_file_extension(pi_batch_header);
l_trailer_file_name file_name := l_batch || nm3type.c_dot || c_trailfile_extension;
l_file              nm3type.tab_varchar32767;
l_file_checksum     pls_integer;
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'batch_is_ready_to_load');
  
  -- check that the trailer file exists and is complete
  IF nm3file.file_exists(location => c_mapcap_dir
                        ,filename => l_trailer_file_name) = 'N'  THEN

    -- trailer file does not exist do not load
    nm_debug.debug('No Trailer filename -> '||l_trailer_file_name);
    RETURN FALSE;
  END IF;
  
  -- now check contents of trailer file
  
  BEGIN
    nm3file.get_file(location     => c_mapcap_dir
                    ,filename     => l_trailer_file_name
                    ,all_lines    => l_file);
  EXCEPTION
    WHEN OTHERS THEN
      catch_error(p_appl   => nm3type.c_hig
                 ,p_error  => 207
                 ,p_supp   => 'Cannot load trailer file'
                 ,p_batch  => l_batch
                 ,p_in_prc => 'batch_is_ready_to_load');
      nm_debug.debug('cannot load trailer file');
      RETURN FALSE;
  END;
  
  -- now check that the file is complete
  -- by checking that the second field is a Z
  
  IF get_csv_value_from_line(p_line => l_file(1)
                            ,p_field => 2) != c_end_of_trail_file_marker THEN
     nm_debug.debug('second field does not match Z');
    catch_error(p_appl   => nm3type.c_hig
               ,p_error  => 207
               ,p_supp   => 'The tailer file format cannot be recognised'
               ,p_batch  => l_batch
               ,p_in_prc => 'batch_is_ready_to_load');
     RETURN FALSE;
  END IF;
  
  -- finally do the checksum
  
  BEGIN
    l_file_checksum := TO_NUMBER(get_csv_value_from_line(p_line => l_file(1)
                                ,p_field => 1));

    nm_debug.debug('Checksum is '||l_file_checksum);

  EXCEPTION
    WHEN OTHERS THEN
      nm_debug.debug('Cannot compute Checksum');
      RETURN FALSE;
  END;
  
  IF number_of_datafiles(l_batch) != l_file_checksum THEN
    nm_debug.debug('Checksum does not match files in batch '||l_batch);
    catch_error(p_appl   => nm3type.c_hig
               ,p_error  => 207
               ,p_supp   => 'Checksum '||l_file_checksum||' does not match the datafiles found, '||number_of_datafiles(l_batch)
               ,p_batch  => l_batch
               ,p_in_prc => 'batch_is_ready_to_load');
    RETURN FALSE;
  END IF;
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'batch_is_ready_to_load');
  -- we have tried all ways we can to fail and so if we get to here we should
  RETURN TRUE;
  
END batch_is_ready_to_load;
--
-----------------------------------------------------------------------------
--
FUNCTION get_files_in_batch(pi_batch IN varchar2) RETURN nm3file.file_list IS

l_file          nm3type.tab_varchar32767;
l_files_to_load nm3file.file_list;
l_header_file   file_name := pi_batch||nm3type.c_dot||c_headfile_extension;
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_files_in_batch');

  -- read the header control file for details
  nm3file.get_file(location     => c_mapcap_dir
                  ,filename     => l_header_file
                  ,all_lines    => l_file);

  -- first line is the edif date
  
  -- all remaining lines are files
  FOR i IN 2..l_file.COUNT LOOP
    l_files_to_load(l_files_to_load.COUNT+1) := l_file(i);
  END LOOP;
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_files_in_batch');

  RETURN l_files_to_load;
--

EXCEPTION 
  WHEN OTHERS THEN
    catch_error(p_appl   => nm3type.c_hig
               ,p_error  => 207
               ,p_supp   => sqlerrm
               ,p_batch  => pi_batch
               ,p_in_prc => 'get_files_in_batch');

END get_files_in_batch;
--
-----------------------------------------------------------------------------
--
FUNCTION find_mapcap_batches_to_load RETURN nm3file.file_list IS
l_files     nm3file.file_list;
l_ret_files nm3file.file_list;
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'find_mapcap_batches_to_load');

  l_files := nm3file.get_files_in_directory(pi_dir       => c_mapcap_dir
                                           ,pi_extension => c_headfile_extension);
  
  nm_debug.debug(l_files.COUNT||' batch headers in directory');
  
  FOR i IN 1..l_files.COUNT LOOP
    
    IF batch_is_ready_to_load(l_files(i))
       AND can_be_loaded(l_files(i)) THEN 
      
      l_ret_files(l_ret_files.COUNT+1) := remove_file_extension(l_files(i));
      nm_debug.debug(l_ret_files(l_ret_files.LAST)||' is ready for loading');
      nm3mapcapture_ins_inv.l_mapcap_run  := 'Y'  ;
      nm3mapcapture_ins_inv.l_batch_no := nm3pbi.get_job_id ;
      nm3mapcapture_ins_inv.l_recod_no := 0 ;
    END IF;
    
  END LOOP;
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'find_mapcap_batches_to_load');

  nm_debug.debug('Returning '||l_ret_files.COUNT||' batches');
  RETURN l_ret_files;

EXCEPTION
  WHEN OTHERS THEN
    catch_error(p_appl   => nm3type.c_hig
               ,p_error  => 207
               ,p_supp   => sqlerrm
               ,p_batch  => NULL
               ,p_in_prc => 'find_mapcap_batches_to_load');
END find_mapcap_batches_to_load;
--
-----------------------------------------------------------------------------
--
FUNCTION lock_the_batch_for_loading(pi_batch IN varchar2) RETURN boolean IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  -- check if the batch has already been loaded
  -- if so return FALSE
  INSERT INTO nm_load_batch_lock
  (nlbl_batch_id)
  VALUES
  (pi_batch);
  
  COMMIT;
  

  RETURN TRUE;

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    ROLLBACK;
    RETURN FALSE;
  WHEN OTHERS THEN
    catch_error(p_appl   => nm3type.c_hig
               ,p_error  => 207
               ,p_supp   => sqlerrm
               ,p_batch  => pi_batch
               ,p_in_prc => 'lock_the_batch_for_loading');
    ROLLBACK;
    RETURN FALSE;
END lock_the_batch_for_loading;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_batch_active (pi_batch IN varchar2) IS

CURSOR c_lock_batch (p_batch nm_load_batch_lock.nlbl_batch_id%TYPE) IS
SELECT 1
FROM   nm_load_batch_lock
WHERE  nlbl_batch_id = p_batch
FOR UPDATE NOWAIT;

dummy NUMBER;
BEGIN
  -- lock the lock to ensure that no-one else can delete it
  OPEN c_lock_batch(pi_batch);
  FETCH c_lock_batch INTO dummy;
  CLOSE c_lock_batch;
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_lock (pi_batch IN varchar2) IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  
  -- clear the lock
  DELETE FROM nm_load_batch_lock
  WHERE nlbl_batch_id = pi_batch;
  
  COMMIT;
  
EXCEPTION 
  WHEN OTHERS THEN
    ROLLBACK;
END clear_lock;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_batch(pi_batch            IN varchar2
                     ,pi_batch_data_files IN nm3file.file_list) IS

l_header_file  file_name := pi_batch||nm3type.c_dot||c_headfile_extension;
l_trailer_file file_name := pi_batch||nm3type.c_dot||c_trailfile_extension;
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'clear_batch');

  nm_debug.debug('clearing lock for batch'||pi_batch);

  -- delete the files from the server
  nm3file.delete_file(pi_dir  => c_mapcap_dir
                     ,pi_file => l_header_file);
  nm3file.delete_file(pi_dir  => c_mapcap_dir
                     ,pi_file => l_trailer_file);
  FOR i IN 1..pi_batch_data_files.COUNT LOOP
    nm3file.delete_file(pi_dir  => c_mapcap_dir
                       ,pi_file => pi_batch_data_files(i));
  END LOOP;

  clear_lock(pi_batch => pi_batch);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'clear_batch');
EXCEPTION
  WHEN OTHERS THEN
    catch_error(p_appl   => nm3type.c_hig
               ,p_error  => 207
               ,p_supp   => sqlerrm
               ,p_batch  => pi_batch
               ,p_in_prc => 'clear_batch');
END clear_batch;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_from_holding(pi_csv_batch_no IN nm_load_batches.nlb_batch_no%TYPE) IS
BEGIN
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'load_from_holding');

  IF lock_the_batch_for_loading(pi_csv_batch_no) THEN

    set_batch_active(pi_csv_batch_no);

    nm3load.load_batch(p_batch_no => pi_csv_batch_no);

    nm3load.produce_log_email(p_nlb_batch_no   => pi_csv_batch_no
                             ,p_produce_as_htp => FALSE
                             ,p_send_to        => get_mapcap_email_recipients);
  
    clear_lock(pi_batch => pi_csv_batch_no);
    nm_debug.debug('Second stage Complete');

  ELSE
    nm_debug.debug('Cannot obtain batch lock for'||pi_csv_batch_no);
  END IF;
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'load_from_holding');
END load_from_holding;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_batch(pi_batch IN varchar2) IS

l_nlf                  nm_load_files%ROWTYPE;
l_files_in_batch       nm3file.file_list;
l_inv_type             nm_inv_types_all.nit_inv_type%TYPE;
l_csv_loader_batch_num pls_integer;
l_end_dated_iit_loaded Boolean := False;
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'load_batch');
  
  -- first check that we can load the batch
  -- check the edif date
  IF lock_the_batch_for_loading(pi_batch) 
  AND check_edif_date(pi_batch) 
  THEN    
    --
    -- LS made changes to deal with hierarchical asset
    nm3mapcapture_ins_inv.l_mapcap_run  := 'Y'  ;
    nm3mapcapture_ins_inv.l_iit_ne_tab.delete;
    nm3mapcapture_ins_inv.l_iit_tab.delete;
    
    -- we have a batch to load
    l_files_in_batch := get_files_in_batch(pi_batch);
    
    -- now for every file in the batch load it!
    FOR i_file IN 1..l_files_in_batch.COUNT LOOP
      -- load batch into holding table
      l_inv_type := get_inv_type_of_file(pi_batch    => pi_batch
                                        ,pi_datafile => l_files_in_batch(i_file));
      
      nm_debug.debug('Loading Inventory type '|| l_inv_type ||' from batch '||pi_batch);
      l_nlf := nm3get.get_nlf(pi_nlf_unique => nm3inv_view.get_mapcapture_csv_unique_ref(l_inv_type));
 
      l_csv_loader_batch_num := nm3load.transfer_to_holding(p_nlf_id       => l_nlf.nlf_id 
                                                           ,p_file_name    => l_files_in_batch(i_file)
                                                           ,p_batch_source => 'S');
    
    END LOOP;
    -- we have now loaded the batch into the holding table
    nm_debug.debug('Attempting Second stage Load');
    --load_from_holding(pi_csv_batch_no => l_csv_loader_batch_num);
    nm3mapcapture_ins_inv.run_batch(nm3mapcapture_ins_inv.l_batch_no);
    nm3mapcapture_ins_inv.l_mapcap_run  := 'N'  ;
    --
    clear_batch(pi_batch            => pi_batch
               ,pi_batch_data_files => l_files_in_batch);
  END IF;   
  send_error_email(pi_batch);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'load_batch');
EXCEPTION
  WHEN OTHERS THEN     
    nm3mapcapture_ins_inv.l_mapcap_run  := 'N'  ;
    catch_error(p_appl   => nm3type.c_hig
               ,p_error  => 207
               ,p_supp   => sqlerrm
               ,p_batch  => NULL
               ,p_in_prc => 'load_batch');
    nm_debug.debug('reraising the exception');
    RAISE;
END load_batch;
--
-----------------------------------------------------------------------------
--
PROCEDURE call_loader(pi_batch IN nm3file.file_list) IS
BEGIN
  FOR i IN 1..pi_batch.COUNT LOOP
    nm_debug.debug('Processing batch '||pi_batch(i));
    load_batch(pi_batch(i));
  END LOOP;
  
EXCEPTION
  WHEN OTHERS THEN
    catch_error(p_appl   => nm3type.c_hig
               ,p_error  => 207
               ,p_supp   => sqlerrm
               ,p_batch  => NULL
               ,p_in_prc => 'load_batch');
    send_error_email;
END call_loader;
--
-----------------------------------------------------------------------------
--
PROCEDURE batch_loader (p_debug IN boolean DEFAULT FALSE) IS
 l_batch_list nm3file.file_list;
BEGIN
  
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'batch_loader');

  IF Sys_Context('NM3CORE','APPLICATION_OWNER') IS NULL
  THEN
    nm3context.initialise_context;
  END IF;
  
  IF p_debug THEN
    nm_debug.delete_debug(TRUE);
    nm_debug.debug_on;
    nm_debug.set_level(p_level => 4);
  END IF;
  
  clear_errors;
  -- who triggers cannot exist on the holding table cos we want to preserve 
  -- the date modified provided by MapCapture
  clear_who_trigger;
  
  IF g_success THEN
    l_batch_list := find_mapcap_batches_to_load;
  END IF;
  
  -- clear the errors found so far
  send_error_email;
  
  -- if there are batches ready to load
  IF l_batch_list.COUNT > 0 THEN
    call_loader(l_batch_list);
  END IF;
  
  IF p_debug THEN
     nm_debug.debug_off;
  END IF;
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'batch_loader');
EXCEPTION
  WHEN OTHERS THEN
    catch_error(p_appl   => nm3type.c_hig
               ,p_error  => 207
               ,p_supp   => sqlerrm
               ,p_batch  => NULL
               ,p_in_prc => 'batch_loader');
    send_error_email;
END batch_loader;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_mapcapture_loader_job IS
PRAGMA AUTONOMOUS_TRANSACTION;
--
   CURSOR cs_job (p_what user_jobs.what%TYPE) IS
   SELECT job
    FROM  user_jobs
   WHERE  UPPER(what) = UPPER(p_what);
--

  c_interval CONSTANT hig_options.hop_value%TYPE := nvl(hig.get_sysopt('MAPCAP_INT'), 60);

  l_existing_job pls_integer;
  l_job          pls_integer;
BEGIN

  OPEN  cs_job (c_what);
  FETCH cs_job INTO l_existing_job;
  IF cs_job%FOUND THEN
    CLOSE cs_job;
    hig.raise_ner(pi_appl => 'HIG'
                 ,pi_id   => 143);
  END IF;
  CLOSE cs_job;
  
  dbms_job.submit(job      => l_job
                 ,what     => c_what
                 ,interval => 'sysdate + '||c_interval||'/(1440)');

  COMMIT;

END create_mapcapture_loader_job;
--
-----------------------------------------------------------------------------
--
PROCEDURE drop_mapcapture_loader_job IS
PRAGMA AUTONOMOUS_TRANSACTION;
--
   CURSOR cs_job (p_what user_jobs.what%TYPE) IS
   SELECT job
    FROM  user_jobs
   WHERE  UPPER(what) = UPPER(p_what);
--
  l_existing_job pls_integer;
BEGIN

  OPEN  cs_job (c_what);
  FETCH cs_job INTO l_existing_job;
  
  IF cs_job%FOUND THEN
    dbms_job.remove(job => l_existing_job);
  END IF;

  CLOSE cs_job;

  COMMIT;

END drop_mapcapture_loader_job;
--
-----------------------------------------------------------------------------
--
END nm3mapcapture_int;
/
