CREATE OR REPLACE PACKAGE BODY hig_process_framework
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/hig_process_framework.pkb-arc   3.12   Oct 07 2011 11:54:08   Steve.Cooper  $
--       Module Name      : $Workfile:   hig_process_framework.pkb  $
--       Date into PVCS   : $Date:   Oct 07 2011 11:54:08  $
--       Date fetched Out : $Modtime:   Oct 07 2011 11:53:56  $
--       Version          : $Revision:   3.12  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid CONSTANT VARCHAR2(2000) := '$Revision:   3.12  $';

  g_package_name CONSTANT varchar2(30) := 'hig_process_framework';

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
PROCEDURE insert_process_type(pi_process_type_rec IN OUT hig_process_types%ROWTYPE) IS

BEGIN
--
 pi_process_type_rec.hpt_process_type_id := NVL(pi_process_type_rec.hpt_process_type_id,nm3ddl.sequence_nextval('hpt_process_type_id_seq'));
--
 INSERT INTO hig_process_types
 VALUES pi_process_type_rec
 RETURNING hpt_process_type_id
         , hpt_name
         , hpt_descr
         , hpt_what_to_call
         , hpt_initiation_module
         , hpt_internal_module
         , hpt_internal_module_param
         , hpt_process_limit
         , hpt_restartable
         , hpt_see_in_hig2510 
         , hpt_polling_enabled
         , hpt_polling_ftp_type_id
         , hpt_area_type
      INTO pi_process_type_rec.hpt_process_type_id
         , pi_process_type_rec.hpt_name
         , pi_process_type_rec.hpt_descr
         , pi_process_type_rec.hpt_what_to_call
         , pi_process_type_rec.hpt_initiation_module
         , pi_process_type_rec.hpt_internal_module
         , pi_process_type_rec.hpt_internal_module_param
         , pi_process_type_rec.hpt_process_limit
         , pi_process_type_rec.hpt_restartable
         , pi_process_type_rec.hpt_see_in_hig2510 
         , pi_process_type_rec.hpt_polling_enabled
         , pi_process_type_rec.hpt_polling_ftp_type_id
         , pi_process_type_rec.hpt_area_type
         ;
--
END insert_process_type;
--
-----------------------------------------------------------------------------
--
FUNCTION lock_process_type(pi_process_type_id IN hig_process_types.hpt_process_type_id%TYPE) RETURN rowid IS

   CURSOR c1 IS
   SELECT ROWID
    FROM  hig_process_types
   WHERE  hpt_process_type_id = pi_process_type_id
   FOR UPDATE NOWAIT;

   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);

BEGIN


   OPEN  c1;
   FETCH c1 INTO l_retval;
   l_found := c1%FOUND;
   CLOSE c1;

   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => -20001
                    ,pi_supplementary_info => 'hig_process_types (HPT_PK)'
                                              ||CHR(10)||'hpt_process_type_id => '||pi_process_type_id
                    );
   END IF;

   RETURN l_retval;

EXCEPTION

   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => -20001
                    ,pi_supplementary_info => 'hig_process_types (HPT_PK)'
                                              ||CHR(10)||'hpt_process_type_id => '||pi_process_type_id
                    );


END lock_process_type;
--
-----------------------------------------------------------------------------
--                                    
PROCEDURE update_process_type(pi_process_type_id  IN hig_process_types.hpt_process_type_id%TYPE
                             ,pi_process_type_rec IN hig_process_types%ROWTYPE) IS

 l_rowid rowid;

BEGIN

 l_rowid := lock_process_type(pi_process_type_id => pi_process_type_id);

 UPDATE hig_process_types SET row = pi_process_type_rec WHERE rowid = l_rowid;
 
 --
 -- clear out existing connections that are no longer for 
 -- the same area type and polling ftp type as our process type
 --
 delete from hig_process_conns_by_area
 where  hptc_process_type_id = pi_process_type_rec.hpt_process_type_id
 and    hptc_area_type != pi_process_type_rec.hpt_area_type;

 delete from hig_process_conns_by_area
 where hptc_process_type_id = pi_process_type_rec.hpt_process_type_id
 and not exists (select 1
                 from hig_ftp_connections
                 where hfc_id = hptc_ftp_connection_id
                 and   hfc_hft_id = pi_process_type_rec.hpt_polling_ftp_type_id);  
 

END update_process_type;
--
-----------------------------------------------------------------------------
--                                    
PROCEDURE delete_process_type(pi_process_type_id            IN hig_process_types.hpt_process_type_id%TYPE) IS

 l_rowid rowid;

 l_count pls_integer;

BEGIN


--
-- don't allow delete of process type id process records exist for that process type
--
 SELECT count(*)
 INTO  l_count
 FROM  hig_processes
 WHERE hp_process_type_id = pi_process_type_id;
 
 IF l_count > 0 THEN
  hig.raise_ner(pi_appl => 'HIG'
               ,pi_id   => 502); --Cannot delete record as child records exist.
 END IF;

 l_rowid := lock_process_type(pi_process_type_id => pi_process_type_id);

 DELETE FROM hig_process_types WHERE rowid = l_rowid;

END delete_process_type;
--
-----------------------------------------------------------------------------
-- 
PROCEDURE insert_scheduling_frequency(pi_frequency_rec IN OUT hig_scheduling_frequencies%ROWTYPE) IS

BEGIN

 pi_frequency_rec.hsfr_frequency_id := NVL(pi_frequency_rec.hsfr_frequency_id,nm3ddl.sequence_nextval('hsfr_frequency_id_seq'));

 INSERT INTO hig_scheduling_frequencies
 VALUES pi_frequency_rec
 RETURNING hsfr_frequency_id
         , hsfr_meaning
         , hsfr_frequency
         , hsfr_interval_in_mins
     INTO  pi_frequency_rec.hsfr_frequency_id
         , pi_frequency_rec.hsfr_meaning
         , pi_frequency_rec.hsfr_frequency
         , pi_frequency_rec.hsfr_interval_in_mins;


END insert_scheduling_frequency;
--
-----------------------------------------------------------------------------
--
FUNCTION lock_scheduling_frequency(pi_frequency_id IN hig_scheduling_frequencies.hsfr_frequency_id%TYPE) RETURN rowid IS

   CURSOR c1 IS
   SELECT ROWID
    FROM  hig_scheduling_frequencies
   WHERE  hsfr_frequency_id = pi_frequency_id
   FOR UPDATE NOWAIT;

   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);

BEGIN


   OPEN  c1;
   FETCH c1 INTO l_retval;
   l_found := c1%FOUND;
   CLOSE c1;

   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => -20001
                    ,pi_supplementary_info => 'hig_scheduling_frequencies (HSFR_PK)'
                                              ||CHR(10)||'hsfr_frequency_id => '||pi_frequency_id
                    );
   END IF;

   RETURN l_retval;

EXCEPTION

   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => -20001
                    ,pi_supplementary_info => 'hig_scheduling_frequencies (HSFR_PK)'
                                              ||CHR(10)||'hsfr_frequency_id => '||pi_frequency_id
                    );


END lock_scheduling_frequency;
--
-----------------------------------------------------------------------------
--                                    
PROCEDURE update_scheduling_frequency(pi_frequency_id  IN hig_scheduling_frequencies.hsfr_frequency_id%TYPE
                                     ,pi_frequency_rec    IN OUT hig_scheduling_frequencies%ROWTYPE) IS

 l_rowid rowid;

BEGIN

 l_rowid := lock_scheduling_frequency(pi_frequency_id => pi_frequency_id);

 UPDATE hig_scheduling_frequencies 
    SET row = pi_frequency_rec 
  WHERE rowid = l_rowid RETURNING hsfr_frequency_id
                                , hsfr_meaning
                                , hsfr_frequency
                                , hsfr_interval_in_mins
                             INTO pi_frequency_rec.hsfr_frequency_id
                                , pi_frequency_rec.hsfr_meaning
                                , pi_frequency_rec.hsfr_frequency
                                , pi_frequency_rec.hsfr_interval_in_mins;

END update_scheduling_frequency;
--
-----------------------------------------------------------------------------
--                                    
PROCEDURE delete_scheduling_frequency(pi_frequency_id  IN hig_scheduling_frequencies.hsfr_frequency_id%TYPE) IS

 l_rowid rowid;

BEGIN

 l_rowid := lock_scheduling_frequency(pi_frequency_id => pi_frequency_id);

 DELETE FROM hig_scheduling_frequencies WHERE rowid = l_rowid;

END delete_scheduling_frequency;
--
-----------------------------------------------------------------------------
--
PROCEDURE insert_process_type_frequency(pi_process_type_frequency_rec IN hig_process_type_frequencies%ROWTYPE) IS

BEGIN

 INSERT INTO hig_process_type_frequencies
 VALUES pi_process_type_frequency_rec;


END insert_process_type_frequency;
--
-----------------------------------------------------------------------------
--
FUNCTION lock_process_type_frequency(pi_process_type_id IN hig_process_type_frequencies.hpfr_process_type_id%TYPE
                                    ,pi_frequency_id    IN hig_process_type_frequencies.hpfr_frequency_id%TYPE) RETURN rowid IS

   CURSOR c1 IS
   SELECT ROWID
    FROM  hig_process_type_frequencies
   WHERE  hpfr_process_type_id = pi_process_type_id
     AND  hpfr_frequency_id    = pi_frequency_id
   FOR UPDATE NOWAIT;

   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);

BEGIN


   OPEN  c1;
   FETCH c1 INTO l_retval;
   l_found := c1%FOUND;
   CLOSE c1;

   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => -20001
                    ,pi_supplementary_info => 'hig_process_type_frequencies (HPFR_PK)'
                                              ||CHR(10)||'hpfr_process_type_id => '||pi_process_type_id||chr(10)||'hpfr_frequency_id => '||pi_frequency_id
                    );
   END IF;

   RETURN l_retval;

EXCEPTION

   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => -20001
                    ,pi_supplementary_info => 'hig_process_type_frequencies (HPFR_PK)'
                                              ||CHR(10)||'hpfr_process_type_id => '||pi_process_type_id||chr(10)||'hpfr_frequency_id => '||pi_frequency_id

                    );


END lock_process_type_frequency;
--
-----------------------------------------------------------------------------
--                                    
PROCEDURE update_process_type_frequency(pi_process_type_id            IN hig_process_type_frequencies.hpfr_process_type_id%TYPE
                                       ,pi_frequency_id               IN hig_process_type_frequencies.hpfr_frequency_id%TYPE
                                       ,pi_process_type_frequency_rec IN hig_process_type_frequencies%ROWTYPE) IS

 l_rowid rowid;

BEGIN

 l_rowid := lock_process_type_frequency(pi_process_type_id => pi_process_type_id
                                       ,pi_frequency_id    => pi_frequency_id);

 UPDATE hig_process_type_frequencies SET row = pi_process_type_frequency_rec WHERE rowid = l_rowid;

END update_process_type_frequency;
--
-----------------------------------------------------------------------------
--                                    
PROCEDURE delete_process_type_frequency(pi_process_type_id            IN hig_process_type_frequencies.hpfr_process_type_id%TYPE
                                       ,pi_frequency_id               IN hig_process_type_frequencies.hpfr_frequency_id%TYPE) IS

 l_rowid rowid;

BEGIN

 l_rowid := lock_process_type_frequency(pi_process_type_id => pi_process_type_id
                                       ,pi_frequency_id    => pi_frequency_id);

 DELETE FROM hig_process_type_frequencies WHERE rowid = l_rowid;

END delete_process_type_frequency;
--
-----------------------------------------------------------------------------
-- 
PROCEDURE insert_hptc(pi_rec IN hig_process_conns_by_area%ROWTYPE) IS

BEGIN

 INSERT INTO hig_process_conns_by_area
 VALUES pi_rec;
 
EXCEPTION
 WHEN dup_val_on_index THEN
   Null;
 WHEN others THEN
   RAISE; 


END insert_hptc;
--
-----------------------------------------------------------------------------
--
FUNCTION lock_hptc(pi_process_type_id    IN hig_process_conns_by_area.hptc_process_type_id%TYPE
                  ,pi_ftp_connection_id  IN hig_process_conns_by_area.hptc_ftp_connection_id%TYPE) RETURN rowid IS

   CURSOR c1 IS
   SELECT ROWID
    FROM  hig_process_conns_by_area
   WHERE  hptc_process_type_id = pi_process_type_id
     AND  hptc_ftp_connection_id    = pi_ftp_connection_id
   FOR UPDATE NOWAIT;

   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);

BEGIN


   OPEN  c1;
   FETCH c1 INTO l_retval;
   l_found := c1%FOUND;
   CLOSE c1;

   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => -20001
                    ,pi_supplementary_info => 'hig_process_conns_by_area (HPTC_PK)'
                                              ||CHR(10)||'hptc_process_type_id => '||pi_process_type_id||chr(10)||'hptc_ftp_connection_id => '||pi_ftp_connection_id
                    );
   END IF;

   RETURN l_retval;

EXCEPTION

   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => -20001
                    ,pi_supplementary_info => 'hig_process_conns_by_area (HPTC_PK)'
                                              ||CHR(10)||'hptc_process_type_id => '||pi_process_type_id||chr(10)||'hptc_ftp_connection_id => '||pi_ftp_connection_id
                    );


END lock_hptc;
--
-----------------------------------------------------------------------------
--                                    
PROCEDURE update_hptc(pi_process_type_id    IN hig_process_conns_by_area.hptc_process_type_id%TYPE
                     ,pi_ftp_connection_id  IN hig_process_conns_by_area.hptc_ftp_connection_id%TYPE
                     ,pi_rec             IN hig_process_conns_by_area%ROWTYPE) IS

 l_rowid rowid;

BEGIN

 l_rowid := lock_hptc(pi_process_type_id   => pi_process_type_id
                     ,pi_ftp_connection_id => pi_ftp_connection_id);

 UPDATE hig_process_conns_by_area SET row = pi_rec WHERE rowid = l_rowid;

END update_hptc;
--
-----------------------------------------------------------------------------
--                                    
PROCEDURE delete_hptc(pi_process_type_id    IN hig_process_conns_by_area.hptc_process_type_id%TYPE
                     ,pi_ftp_connection_id  IN hig_process_conns_by_area.hptc_ftp_connection_id%TYPE) IS

 l_rowid rowid;

BEGIN

 l_rowid := lock_hptc(pi_process_type_id   => pi_process_type_id
                     ,pi_ftp_connection_id => pi_ftp_connection_id);

 DELETE FROM hig_process_conns_by_area WHERE rowid = l_rowid;

END delete_hptc;
----
-------------------------------------------------------------------------------
----  
FUNCTION get_process_type(pi_process_type_id IN hig_process_types.hpt_process_type_id%TYPE) RETURN hig_process_types%ROWTYPE IS

 CURSOR c1 IS
 SELECT *
 FROM  hig_process_types
 WHERE hpt_process_type_id = pi_process_type_id;
 
 l_retval hig_process_types%ROWTYPE;

BEGIN

 OPEN c1;
 FETCH c1 INTO l_retval;
 CLOSE c1;
 
 RETURN l_retval;

END get_process_type;
--
-----------------------------------------------------------------------------
--
FUNCTION get_process_type(pi_process_type_name IN hig_process_types.hpt_name%TYPE) RETURN hig_process_types%ROWTYPE IS

 CURSOR c1 IS
 SELECT *
 FROM   hig_process_types
 WHERE  UPPER(hpt_name) = UPPER(pi_process_type_name);
 
 l_retval hig_process_types%ROWTYPE; 

BEGIN


 OPEN c1;
 FETCH c1 INTO l_retval;
 CLOSE c1;
 
 RETURN(l_retval);
 

END get_process_type;



FUNCTION get_process_type_from_module(pi_module IN hig_process_types.hpt_initiation_module%TYPE) RETURN hig_process_types%ROWTYPE IS

 CURSOR c1 IS
 SELECT *
 FROM  hig_process_types
 WHERE hpt_initiation_module = pi_module;
 
 l_retval hig_process_types%ROWTYPE;

BEGIN

 OPEN c1;
 FETCH c1 INTO l_retval;
 CLOSE c1;

 RETURN l_retval;

END get_process_type_from_module;
--
-----------------------------------------------------------------------------
--
FUNCTION get_frequency(pi_frequency_id IN hig_scheduling_frequencies.hsfr_frequency_id%TYPE) RETURN hig_scheduling_frequencies%ROWTYPE IS

 CURSOR c1 IS
 SELECT *
 FROM hig_scheduling_frequencies
 WHERE hsfr_frequency_id = pi_frequency_id;

 l_retval hig_scheduling_frequencies%ROWTYPE;

BEGIN

 OPEN c1;
 FETCH c1 INTO l_retval;
 CLOSE c1;

 RETURN l_retval;

END get_frequency; 
--
-----------------------------------------------------------------------------
--
FUNCTION get_process(pi_process_id IN hig_processes.hp_process_id%TYPE) RETURN hig_processes%ROWTYPE IS

 CURSOR c1 IS
 SELECT *
 FROM hig_processes
 WHERE hp_process_id = pi_process_id;

 l_retval hig_processes%ROWTYPE;

BEGIN

 OPEN c1;
 FETCH c1 INTO l_retval;
 CLOSE c1;

 RETURN l_retval;

END get_process;
--
-----------------------------------------------------------------------------
--
FUNCTION get_process_and_job(pi_process_id IN hig_processes.hp_process_id%TYPE) RETURN hig_processes_v%ROWTYPE IS

 CURSOR c1 IS
 SELECT *
 FROM hig_processes_v
 WHERE hp_process_id = pi_process_id;

 l_retval hig_processes_v%ROWTYPE;

BEGIN

 OPEN c1;
 FETCH c1 INTO l_retval;
 CLOSE c1;

 RETURN l_retval;


END get_process_and_job;
--
-----------------------------------------------------------------------------
--
FUNCTION get_process_and_job(pi_job_name IN hig_processes_v.hp_job_name%TYPE) RETURN hig_processes_v%ROWTYPE IS

 CURSOR c1 IS
 SELECT *
 FROM hig_processes_v
 WHERE hp_job_name = pi_job_name;

 l_retval hig_processes_v%ROWTYPE;

BEGIN

 OPEN c1;
 FETCH c1 INTO l_retval;
 CLOSE c1;

 RETURN l_retval;


END get_process_and_job;
--
-----------------------------------------------------------------------------
--
FUNCTION get_job(pi_job_name IN dba_scheduler_jobs.job_name%TYPE) RETURN dba_scheduler_jobs%ROWTYPE IS

 CURSOR c1 IS
 SELECT *
 FROM dba_scheduler_jobs
 WHERE job_name = pi_job_name;

 l_retval dba_scheduler_jobs%ROWTYPE;

BEGIN

 OPEN c1;
 FETCH c1 INTO l_retval;
 CLOSE c1;

 RETURN l_retval;


END get_job;
--
-----------------------------------------------------------------------------
--
FUNCTION get_process_type_file(pi_file_type_id IN hig_process_type_files.hptf_file_type_id%TYPE) RETURN hig_process_type_files%ROWTYPE IS

 CURSOR c1 IS
 SELECT *
 FROM hig_process_type_files
 WHERE hptf_file_type_id = pi_file_type_id;

 l_retval hig_process_type_files%ROWTYPE;

BEGIN

 OPEN c1;
 FETCH c1 INTO l_retval;
 CLOSE c1;

 RETURN l_retval;


END get_process_type_file;
--
-----------------------------------------------------------------------------
--
FUNCTION get_process_type_file(pi_process_type_id  IN hig_process_type_files.hptf_process_type_id%TYPE
                              ,pi_file_type_name   IN hig_process_type_files.hptf_name%TYPE) RETURN hig_process_type_files%ROWTYPE IS

 CURSOR c1 IS
 SELECT *
 FROM hig_process_type_files
 WHERE hptf_process_type_id = pi_process_type_id
 AND   UPPER(hptf_name) = UPPER(pi_file_type_name);

 l_retval hig_process_type_files%ROWTYPE;

BEGIN

 OPEN c1;
 FETCH c1 INTO l_retval;
 CLOSE c1;

 RETURN l_retval;


END get_process_type_file;
--
-----------------------------------------------------------------------------
--
FUNCTION hig2510_enabled_disabled_tabs(pi_process_type_id           IN hig_process_types.hpt_process_type_id%TYPE
                                      ,pi_user_selects_process_type IN BOOLEAN
                                      ,pi_polling                   IN BOOLEAN
                                      ,po_process_type_rec          IN OUT hig_process_types%ROWTYPE) RETURN nm3type.tab_boolean IS


 l_retval nm3type.tab_boolean;

 FUNCTION tab_1_enabled_disabled RETURN BOOLEAN IS -- Process Type
 
 BEGIN
  
  RETURN(pi_user_selects_process_type);
 
 
 END tab_1_enabled_disabled;
--
--
--
 FUNCTION tab_2_enabled_disabled RETURN BOOLEAN IS -- Files
 
  l_count pls_integer;
 
 BEGIN
  
  select count(*) 
  into l_count
  from hig_process_type_files
  where hptf_process_type_id = pi_process_type_id
  and   hptf_input = 'Y';
  
  RETURN(l_count > 0 and NOT pi_polling); 
 
 END tab_2_enabled_disabled;
--
--
--
 FUNCTION tab_3_enabled_disabled RETURN BOOLEAN IS -- When
 
 BEGIN
  
  RETURN(po_process_type_rec.hpt_process_type_id IS NOT NULL );
 
 
 END tab_3_enabled_disabled;
--
--
--

BEGIN

    po_process_type_rec := get_process_type(pi_process_type_id => pi_process_type_id);

    l_retval(1) := tab_1_enabled_disabled; 
    l_retval(2) := tab_2_enabled_disabled;     
    l_retval(3) := tab_3_enabled_disabled;

 RETURN l_retval;



END hig2510_enabled_disabled_tabs;
--
-----------------------------------------------------------------------------
--
FUNCTION begin_end_around_what(pi_what_to_call     IN VARCHAR2) RETURN VARCHAR2 IS

 l_retval nm3type.max_varchar2;

BEGIN

 l_retval :=            'BEGIN'||chr(10);
 l_retval := l_retval || pi_what_to_call||chr(10);
 l_retval := l_retval ||'END;'||chr(10); 

 return SUBSTR(l_retval,1,4000);
    
END begin_end_around_what;
--
-----------------------------------------------------------------------------
--
PROCEDURE parse_what (pi_what_to_call IN VARCHAR2) IS 

BEGIN

 nm3flx.parse_sql_string(p_sql => pi_what_to_call);
 
EXCEPTION

 WHEN others THEN
  hig.raise_ner(pi_appl => 'HIG'
               ,pi_id  => 512
               ,pi_supplementary_info => chr(10)||pi_what_to_call);

END parse_what;
--
-----------------------------------------------------------------------------
--
FUNCTION wrapper_around_what(pi_what_to_call     IN VARCHAR2
                            ,pi_process_id   IN hig_processes.hp_process_id%TYPE
                            ) RETURN VARCHAR2 IS
                            
 l_retval nm3type.max_varchar2;                            

 l_what hig_process_types.hpt_what_to_call%TYPE;

BEGIN

 l_what := begin_end_around_what(pi_what_to_call => pi_what_to_call);
-- parse_what (pi_what_to_call => l_what);
 l_what := nm3flx.repl_quotes_amps_for_dyn_sql(p_text_in => l_what);

 l_retval :=            'DECLARE'||chr(10);
 l_retval := l_retval ||'  ex_process_execution_end EXCEPTION;'||chr(10);
 l_retval := l_retval ||'  PRAGMA exception_init(ex_process_execution_end,-20099);'||chr(10); 

 l_retval := l_retval ||'BEGIN'||chr(10);
 
 l_retval := l_retval ||'hig_process_api.set_current_process_id(pi_process_id => '||pi_process_id||');'||chr(10);
 l_retval := l_retval ||'hig_process_api.process_execution_start;'||chr(10)||chr(10);
--
-- note that you have to do an execute immediate because if the pl/sql block we are passing back is invalid
-- it won't parse and therefore we won't fall into the exception handler and deal with the parse failure
--
--
 l_retval := l_retval ||'execute immediate ('||nm3flx.string(l_what)||');'||chr(10)||chr(10);

 --
 -- Only set successful execution end if the module being executed hasn't already set 
 -- success to N
 --
 l_retval := l_retval ||'  if NVL(hig_process_api.get_success_flag, ''Y'') != ''N'''||chr(10);
 l_retval := l_retval ||'  then '||chr(10);
 l_retval := l_retval ||'     hig_process_api.process_execution_end(''Y'',null);'||chr(10);
 l_retval := l_retval ||'  end if;'||chr(10);
 
 
 l_retval := l_retval ||'EXCEPTION'||chr(10);
 l_retval := l_retval ||'WHEN ex_process_execution_end THEN'||chr(10);
 l_retval := l_retval ||'  Null;'||chr(10); 
 l_retval := l_retval ||'WHEN others THEN'||chr(10);
 l_retval := l_retval ||'  hig_process_api.log_it(nm3flx.parse_error_message(sqlerrm),''E'');'||chr(10);
 l_retval := l_retval ||'  hig_process_api.process_execution_end(''N'',nm3flx.parse_error_message(sqlerrm));'||chr(10);

-- If a RAISE; was added then the associated dba_scheduler_jobs.job_state will be set to FAILED rather than SUCCESS
-- wherease we don't want to flag that the job failed - cos the process failure is already dealt with and flagged

-- l_retval := l_retval ||'  RAISE;'||chr(10); 
 l_retval := l_retval ||'END;';

 RETURN(l_retval);

END wrapper_around_what; 
--
-----------------------------------------------------------------------------
--

--FUNCTION current_time_as_char RETURN VARCHAR2 IS
--
--BEGIN
-- 
--  RETURN(nm3flx.convert_hh_mi_ss_to_seconds(to_char(sysdate,'HH24:MI:SS')));
--
--END current_time_as_char;
--
-----------------------------------------------------------------------------
--
FUNCTION process_can_run_now(pi_process_id IN hig_processes.hp_process_id%TYPE) RETURN BOOLEAN IS

BEGIN 

 RETURN UPPER(get_process_and_job(pi_process_id => pi_process_id).hpj_job_state) IN ('SCHEDULED','FAILED');

END process_can_run_now;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_process_can_run_now(pi_process_id IN hig_processes.hp_process_id%TYPE) IS

BEGIN

 IF NOT process_can_run_now(pi_process_Id => pi_process_id) THEN
    hig.raise_ner(pi_appl => 'HIG'
                 ,pi_id   => 516); -- operation is not permitted on this process
 END IF;                 

END check_process_can_run_now;
--
-----------------------------------------------------------------------------
-- 
FUNCTION process_can_be_amended(pi_process_id IN hig_processes.hp_process_id%TYPE) RETURN BOOLEAN IS

BEGIN

 RETURN process_is_disabled(pi_process_id => pi_process_id);

END process_can_be_amended;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_process_can_be_amended(pi_process_id IN hig_processes.hp_process_id%TYPE) IS

BEGIN

 IF NOT process_can_be_amended(pi_process_Id => pi_process_Id) THEN
    hig.raise_ner(pi_appl => 'HIG'
                 ,pi_id   => 516); -- operation is not permitted on this process
 END IF;                 

END check_process_can_be_amended;
--
-----------------------------------------------------------------------------
--
FUNCTION process_is_scheduled(pi_process_id IN hig_processes.hp_process_id%TYPE) RETURN BOOLEAN IS

BEGIN

 RETURN UPPER(get_process_and_job(pi_process_id => pi_process_id).hpj_job_state) IN ('SCHEDULED');

END process_is_scheduled;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_process_is_scheduled(pi_process_id IN hig_processes.hp_process_id%TYPE) IS

BEGIN

 IF NOT process_is_scheduled(pi_process_Id => pi_process_Id) THEN
    hig.raise_ner(pi_appl => 'HIG'
                 ,pi_id   => 516); -- operation is not permitted on this process
 END IF;                 

END check_process_is_scheduled;
--
-----------------------------------------------------------------------------
--
FUNCTION process_is_disabled(pi_process_id IN hig_processes.hp_process_id%TYPE) RETURN BOOLEAN IS

BEGIN

 RETURN UPPER(get_process_and_job(pi_process_id => pi_process_id).hpj_job_state) IN ('DISABLED');

END process_is_disabled;
--
-----------------------------------------------------------------------------
--
PROCEDURE tab_temp_files_from_file_list IS

  CURSOR c1 IS
    select strip_filename (hfl_filename) filename
          ,hfl_file_type_id             file_type_id
          ,'I'                          I_or_O
          ,hptf_input_destination       destination
          ,hptf_input_destination_type  destination_type
          ,hfl_content                  content
    from hig2510_file_list
        ,hig_process_type_files
    where hptf_file_type_id = hfl_file_type_id;
    
    l_retval   hig_process_api.tab_temp_files;
    
    l_rec hig_process_api.rec_temp_files;
 
BEGIN


  OPEN c1;
  FETCH c1 BULK COLLECT INTO hig_process_api.g_tab_temp_files;
  CLOSE c1;


END tab_temp_files_from_file_list;
--
-----------------------------------------------------------------------------
--
FUNCTION when_would_job_be_scheduled(pi_frequency         IN hig_scheduling_frequencies.hsfr_frequency%TYPE
                                    ,pi_start_date        IN  DATE DEFAULT SYSDATE
                                    ,pi_return_date_after IN  DATE DEFAULT SYSDATE
                                    ) RETURN DATE IS
                                    
 l_next_run_date timestamp;         
                                    
BEGIN



 return (nm3jobs.evaluate_calendar_string(pi_calendar_string => pi_frequency
                                               ,pi_start_date      => pi_start_date
                                               ,pi_return_date_after => pi_return_date_after));
 
 

END  when_would_job_be_scheduled;                                  
--
-----------------------------------------------------------------------------
--
FUNCTION when_would_job_be_scheduled(pi_frequency_id      IN hig_scheduling_frequencies.hsfr_frequency_id%TYPE
                                    ,pi_start_date        IN  DATE DEFAULT SYSDATE
                                    ,pi_return_date_after IN  DATE DEFAULT SYSDATE
                                    ) RETURN DATE IS

                                    
BEGIN

 RETURN(when_would_job_be_scheduled(pi_frequency         => get_frequency(pi_frequency_id => pi_frequency_id).hsfr_frequency
                                   ,pi_start_date        => pi_start_date
                                   ,pi_return_date_after => pi_return_date_after)); 


END when_would_job_be_scheduled;                                  
--
-----------------------------------------------------------------------------
--                                  
PROCEDURE migrate_candidate_process_type(pi_job_name              IN dba_scheduler_jobs.job_name%TYPE
                                        ,pi_process_type_name     IN hig_process_types.hpt_name%TYPE
                                        ,pi_description           IN hig_process_types.hpt_descr%TYPE
                                        ,pi_what_to_call          IN hig_process_types.hpt_what_to_call%TYPE
                                        ,pi_frequency_id          IN hig_scheduling_frequencies.hsfr_frequency_id%TYPE) IS

 PRAGMA autonomous_transaction;

 l_process_type_id hig_process_types.hpt_process_type_id%TYPE;
 l_process_id hig_processes.hp_process_id%TYPE;
 l_job_name   hig_processes.hp_job_name%TYPE;
 l_scheduled_start_date date;

BEGIN


 l_process_type_id := nm3ddl.sequence_nextval('hpt_process_type_id_seq');

 INSERT INTO hig_process_types(hpt_process_type_id, hpt_name, hpt_descr, hpt_what_to_call)
 VALUES     (l_process_type_id
            ,pi_process_type_name
            ,pi_description
            ,pi_what_to_call);

 nm3jobs.drop_job(pi_job_name => pi_job_name);


 
 insert into hig_process_type_frequencies(hpfr_process_type_id
                                        , hpfr_frequency_id
                                        , hpfr_seq)
 values(l_process_type_id
       ,pi_frequency_id
       ,1);                                        
 
 hig_process_api.create_and_schedule_process(pi_process_type_id           => l_process_type_id
                                           , pi_initiators_ref            => Null
                                           , pi_start_date                => sysdate
                                           , pi_frequency_id              => pi_frequency_id
                                           , po_process_id                => l_process_id  
                                           , po_job_name                  => l_job_name 
                                           , po_scheduled_start_date      => l_scheduled_start_date);
 
 commit;            


END migrate_candidate_process_type;
--
-----------------------------------------------------------------------------
--
PROCEDURE initialise_hfl IS

BEGIN

 delete from  hig2510_file_list;

END initialise_hfl;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_type_files_wildcards(pi_process_type_id IN hig_process_types.hpt_process_type_id%TYPE
                                      ,po_wildcards       OUT nm3type.tab_varchar80 
                                      ,po_descriptions    OUT nm3type.tab_varchar80
                                      ) IS 

 CURSOR c1 IS
 SELECT DISTINCT '*.'||REPLACE(hpte_extension,'.',null)
 FROM   hig_process_type_file_ext
       ,hig_process_type_files
 WHERE  hptf_process_type_id = pi_process_type_id 
 AND    hptf_input = 'Y'
 AND    hpte_file_type_id = hptf_file_type_id  
 UNION  
 SELECT '*.*'
 FROM   dual; 
 
 l_retval nm3type.tab_varchar80;       
 
BEGIN

 OPEN c1;
 FETCH c1 BULK COLLECT INTO po_wildcards;
 CLOSE c1;
 
 po_descriptions := po_wildcards;

END process_type_files_wildcards;
--
-----------------------------------------------------------------------------
--
FUNCTION get_file_type_from_filename(pi_process_type_id IN hig_process_types.hpt_process_type_id%TYPE
                                    ,pi_filename        IN VARCHAR2) RETURN hig_process_type_files%ROWTYPE IS


 CURSOR c1 IS
 SELECT hptf.*
 FROM   hig_process_type_files hptf
 WHERE  hptf_process_type_id = pi_process_type_id  
 AND    hptf_input = 'Y'
 AND    EXISTS (SELECT 'a match on extension'
                FROM   hig_process_type_file_Ext 
                WHERE  hpte_file_type_id = hptf_file_type_id
                AND    upper(hpte_extension) = UPPER(nm3flx.get_file_extenstion(pi_filename)))
 ORDER BY hptf_file_type_id;
 
 l_retval hig_process_type_files%ROWTYPE;
 
                               
BEGIN


 OPEN c1;
 FETCH c1 INTO l_retval;
 CLOSE c1;
 
 RETURN(l_retval);


END get_file_type_from_filename;                               
--
-----------------------------------------------------------------------------
--
FUNCTION strip_filename ( pi_full_path_and_file IN VARCHAR2 ) RETURN VARCHAR2 IS
    retval nm3type.max_varchar2;
BEGIN

    retval := SUBSTR(pi_full_path_and_file
             ,INSTR(pi_full_path_and_file,'\',-1)+1);
    retval := SUBSTR(retval
             ,INSTR(retval,'/',-1)+1);

    RETURN retval ;

END strip_filename;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_hfl_blob_to_file(pi_id IN hig2510_file_list.hfl_id%TYPE) IS


 CURSOR c1 IS
 SELECT *
 FROM   hig2510_file_list
 WHERE  hfl_id = pi_id;

BEGIN

 FOR f IN c1 LOOP

                Nm3file.write_blob
                  ( p_blob      => f.hfl_content
                  , p_file_loc  => f.hfl_destination
                  , p_file_name => strip_filename(f.hfl_filename)
                  );

 END LOOP;

END write_hfl_blob_to_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_hfl_flags(pi_id              IN hig2510_file_list.hfl_id%TYPE
                       ,pi_read_flag       IN hig2510_file_list.hfl_read_flag%TYPE
                       ,pi_error_flag      IN hig2510_file_list.hfl_error_flag%TYPE
                       ,pi_error_text      IN VARCHAR2) IS
    

                            
BEGIN

 update hig2510_file_list
 set hfl_read_flag  = pi_read_flag
    ,hfl_error_flag = pi_error_flag
    ,hfl_error_text = SUBSTR(pi_error_text,1,500)
 where hfl_id = pi_id;
 
 commit;

END set_hfl_flags;                                                                 
--
-----------------------------------------------------------------------------
--
FUNCTION log_text_as_clob(pi_process_id            IN hig_process_log.hpl_process_id%TYPE
                         ,pi_job_run_seq           IN hig_process_log.hpl_job_run_seq%TYPE
                         ,pi_only_summary_messages IN varchar2) RETURN CLOB IS



   CURSOR c_log_text(cp_process_id            IN hig_process_log.hpl_process_id%TYPE
                    ,cp_job_run_seq           IN hig_process_log.hpl_job_run_seq%TYPE
                    ,cp_only_summary_messages IN VARCHAR2) IS
  

     SELECT 1 log_order
           ,'Execution Details'||chr(10)
          ||'================='||chr(10)
          ||'Process Type           : '||hp_process_type_name||chr(10)
          ||'Process ID             : '||hp_formatted_process_id||chr(10)
          ||'Execution Seq          : '||hpjr_job_run_seq||chr(10)
          || case when hp_area_type_description is not null and hp_area_meaning is not null then
              'Area Type              : '||hp_area_type_description||chr(10)
            ||'Area                   : '||hp_area_meaning||chr(10)
            else
              null
            end
          ||'Initiator              : '||a.hp_initiated_by_username||chr(10)
          ||'Initator Reference     : '||a.hp_initiators_ref||chr(10)
          ||'Outcome                : '||hp_success_flag_meaning||chr(10)
          ||'Database               : '||Sys_Context('NM3_SECURITY_CTX','USERNAME')||chr(10)||chr(10)
          ||'Timings'||chr(10)
          ||'======='||chr(10)     
          ||'Start Date             : '||hpjr_start||chr(10)
          ||'End Date               : '||hpjr_end     ||chr(10)
          || case when EXTRACT (DAY FROM hpjr_end - hpjr_start) > 0 then
              'Days                   : '||EXTRACT (DAY FROM hpjr_end - hpjr_start)||chr(10)
            else
              Null
            end
          || case when EXTRACT (HOUR FROM hpjr_end - hpjr_start) > 0 then
              'Hours                  : '||EXTRACT (HOUR FROM hpjr_end - hpjr_start)||chr(10)
            else
              Null
            end
          || case when EXTRACT (MINUTE FROM hpjr_end - hpjr_start) > 0 then
            'Minutes                : '||EXTRACT (MINUTE FROM hpjr_end - hpjr_start)||chr(10)
            else
              Null
            end
          || case when ROUND(EXTRACT (SECOND FROM hpjr_end - hpjr_start),0) > 0 then
            'Seconds                : '||ROUND(EXTRACT (SECOND FROM hpjr_end - hpjr_start),0)||chr(10)
            else
              Null
            end
          ||case when hp_polling_flag = 'Y' THEN
             chr(10)||'Polled Locations'||chr(10)
                    ||'================'||chr(10)
            else
             null
            end
        FROM hig_processes_v a
           , hig_process_job_runs b
        WHERE hp_process_id = cp_process_id
        AND   hpjr_process_id = hp_process_id
        AND   hpjr_job_run_seq = cp_job_run_seq
  UNION ALL
    SELECT 2 log_order
            ,hfc_ftp_host||'    '||hfc_ftp_in_dir||chr(10)
    FROM hig_process_polled_conns_v
    WHERE hp_process_id = pi_process_id       
  UNION ALL
  SELECT 3 log_order
         ,chr(10)||'Log'||chr(10)
          ||'==='||chr(10)||chr(10)
  FROM dual
  UNION ALL
  SELECT 4 log_order
        ,to_char(qry.hpl_date,'DD-MON-YYYY HH24:MI:SS')||'   '||qry.hpl_message||chr(10) log_text
   FROM (SELECT hpl_date
               ,hpl_message
         FROM   hig_process_log_v
         WHERE hpl_process_id = cp_process_Id
         AND   hpl_job_run_seq = cp_job_run_seq
         AND  (   
               (cp_only_summary_messages = 'Y' and  hpl_summary_flag = 'Y')
           OR
              (cp_only_summary_messages != 'Y')
            )   
       order by hpl_job_run_seq,hpl_log_seq asc) qry;


   l_tab_order  nm3type.tab_number;
   l_tab_c_text nm3type.tab_varchar32767;
      
BEGIN

  OPEN c_log_text(cp_process_id            => pi_process_id
             ,cp_job_run_seq           => pi_job_run_seq
             ,cp_only_summary_messages => pi_only_summary_messages);
  FETCH c_log_text BULK COLLECT INTO l_tab_order, l_tab_c_text;
  CLOSE c_log_text;

  RETURN(nm3clob.tab_varchar_to_clob (pi_tab_vc => l_tab_c_text));


END log_text_as_clob;
--
-----------------------------------------------------------------------------
--
FUNCTION log_text_as_blob(pi_process_id            IN hig_process_log.hpl_process_id%TYPE
                         ,pi_job_run_seq           IN hig_process_log.hpl_job_run_seq%TYPE
                         ,pi_only_summary_messages IN varchar2) RETURN BLOB IS

   l_tab_c_text nm3type.tab_varchar32767;
   
BEGIN

 RETURN(
         nm3clob.clob_to_blob(log_text_as_clob(pi_process_id            => pi_process_id
                                             ,pi_job_run_seq           => pi_job_run_seq
                                             ,pi_only_summary_messages => pi_only_summary_messages)
                             )
       );

END log_text_as_blob;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_log_blob_to_temp_table(pi_process_id            IN hig_process_log.hpl_process_id%TYPE
                                      ,pi_job_run_seq           IN hig_process_log.hpl_job_run_seq%TYPE
                                      ,pi_only_summary_messages IN varchar2) IS

 l_blob blob;
 
BEGIN


  l_blob := log_text_as_blob(pi_process_id            => pi_process_id
                            ,pi_job_run_seq           => pi_job_run_seq
                            ,pi_only_summary_messages => pi_only_summary_messages);
         
  
  delete from  hig_process_temp_log;
                        
  insert into hig_process_temp_log(log_blob) values (l_blob); 

END write_log_blob_to_temp_table;
--
-----------------------------------------------------------------------------
--
FUNCTION process_execution_has_started(pi_process_id     IN hig_process_job_runs.hpjr_process_id%TYPE 
                                      ,pi_job_run_seq    IN hig_process_job_runs.hpjr_job_run_seq%TYPE) RETURN BOOLEAN IS

 l_count pls_integer;
                                      
BEGIN

 select count(*)
 into l_count
 from  hig_process_job_runs
 where hpjr_process_id = pi_process_id
 and   hpjr_job_run_seq = pi_job_run_seq
 and   hpjr_start is not null;
 
 return (l_count > 0);


END process_execution_has_started;                                      
--
-----------------------------------------------------------------------------
--
PROCEDURE process_execution_has_started(pi_process_id     IN hig_process_job_runs.hpjr_process_id%TYPE 
                                       ,pi_job_run_seq    IN hig_process_job_runs.hpjr_job_run_seq%TYPE) IS
                                       
BEGIN

 IF NOT  process_execution_has_started(pi_process_id     => pi_process_id 
                                      ,pi_job_run_seq    => pi_job_run_seq) THEN

   hig.raise_ner(pi_appl => 'HIG'
                ,pi_id   => 530); -- No log to view - Process execution has not yet started.
                
 END IF;
 
END process_execution_has_started;                                                                     
--
-----------------------------------------------------------------------------
--
FUNCTION get_hpa_rec(pi_area_type IN hig_process_areas.hpa_area_type%TYPE) RETURN hig_process_areas%ROWTYPE IS

 CURSOR c1 IS
 SELECT *
 FROM   hig_process_areas
 WHERE  hpa_area_type = pi_area_type;
 
 l_retval hig_process_areas%ROWTYPE;

BEGIN

 OPEN c1;
 FETCH c1 INTO l_retval;
 CLOSE c1;
 
 RETURN l_retval;
 

END get_hpa_rec;


FUNCTION area_meaning_from_id_value(pi_area_type        IN hig_process_areas.hpa_area_type%TYPE
                                   ,pi_area_id_value    IN varchar2) RETURN varchar2 IS
 
 CURSOR c1 IS
 SELECT 'select SUBSTR('||hpa_meaning_column||',1,100) meaning from '||hpa_table||' where '||hpa_id_column||' = :a'
 FROM   hig_process_areas
 WHERE  hpa_area_type = pi_area_type;
 
 l_sql       nm3type.max_varchar2;
 l_retval    nm3type.max_varchar2;
 l_refcursor nm3type.ref_cursor;
 l_not_found constant varchar2(20) := 'Not Found';
                                  
BEGIN

 OPEN c1;
 FETCH c1 INTO l_sql;
 CLOSE c1;
 
 IF l_sql IS NOT NULL THEN
    OPEN l_refcursor FOR l_sql USING pi_area_id_value;
    FETCH l_refcursor INTO l_retval;
    CLOSE l_refcursor;
 END IF;  

 RETURN(NVL(l_retval,l_not_found));
 
EXCEPTION
 WHEN others THEN
     RETURN l_not_found;

END area_meaning_from_id_value; 
--
-----------------------------------------------------------------------------
--
FUNCTION area_visible_to_user(pi_area_type       IN hig_process_areas.hpa_area_type%TYPE
                             ,pi_area_id_value   IN VARCHAR2) RETURN VARCHAR2 IS


 CURSOR c1 IS
 SELECT 'select ''Y'' from '||NVL(hpa_restricted_table,hpa_table)||' where '||hpa_id_column||' = :a'
 FROM   hig_process_areas
 WHERE  hpa_area_type = pi_area_type;
 
 l_sql       nm3type.max_varchar2;
 l_dummy     varchar2(1) := 'N';
 l_refcursor nm3type.ref_cursor;
 l_not_found constant varchar2(20) := 'Not Found';
                                  
BEGIN


 OPEN c1;
 FETCH c1 INTO l_sql;
 CLOSE c1;

 IF l_sql IS NOT NULL THEN
    OPEN l_refcursor FOR l_sql USING pi_area_id_value;
    FETCH l_refcursor INTO l_dummy;
    CLOSE l_refcursor;
 END IF;  

 RETURN(NVL(l_dummy,'N'));
 
EXCEPTION
 WHEN others THEN
     RETURN(NVL(l_dummy,'N'));

END area_visible_to_user;
--
-----------------------------------------------------------------------------
--
FUNCTION process_type_area_lov(pi_process_type_id     IN hig_process_types.hpt_process_type_id%TYPE
                              ,pi_restricted_list     IN varchar2 DEFAULT 'N'
                              ,pi_include_dummy       IN varchar2 DEFAULT 'N') RETURN VARCHAR2 IS
 

 CURSOR c1 IS
 SELECT 
               'select meaning, id'||chr(10)
             ||'from'||chr(10)
             ||'('||chr(10)
             || case when pi_include_dummy = 'Y' then
                  'select 1 seq, ''None'' meaning, null id from dual'||chr(10)
                   ||'union all'||chr(10)
                  else
                   null
                  end 
            || case when pi_restricted_list = 'Y' THEN 
                          'select 2 seq, SUBSTR('||hpa_meaning_column||',1,100) meaning, TO_CHAR('||hpa_id_column||') id from '||NVL(hpa_restricted_table,hpa_table)||chr(10)||' where '||NVL(hpa_restricted_where_clause,'1=1')||chr(10)
                     else 
                          'select 2 seq, SUBSTR('||hpa_meaning_column||',1,100) meaning, TO_CHAR('||hpa_id_column||') id from '||hpa_table||chr(10)||' where '||NVL(hpa_where_clause,'1=1')||chr(10)
                     end                                                                         
             ||')'||chr(10)
             ||' order by seq,meaning' the_sql
 FROM   hig_process_areas
      , hig_process_types
 WHERE  hpt_process_type_id = pi_process_type_id
 AND    hpa_area_type = hpt_area_type;
 
 l_retval    nm3type.max_varchar2;
                                  
BEGIN

 OPEN c1;
 FETCH c1 INTO l_retval;
 CLOSE c1;
 
 IF l_retval IS NULL THEN
 
  IF pi_include_dummy = 'Y' THEN
    RETURN('select ''None'' meaning, null id from dual');
  ELSE
    RETURN('select null meaning, null from dual where 1=2');
  END IF;  
  
 ELSE 
  RETURN(l_retval);
 END IF; 
 
EXCEPTION
 WHEN others THEN
     RETURN Null;

END process_type_area_lov; 
--
-----------------------------------------------------------------------------
--                                  
FUNCTION process_type_polling_area_lov(pi_process_type_id  IN hig_process_types.hpt_process_type_id%TYPE
                                      ,pi_restricted_list  IN VARCHAR2 DEFAULT 'N'
                                      ,pi_include_dummy       IN varchar2 DEFAULT 'N') RETURN VARCHAR2 IS



 l_retval varchar2(2000);
                              
BEGIN
       
   l_retval :=          'select meaning, id'||chr(10);
   l_retval := l_retval||'from'||chr(10);
   l_retval := l_retval||'('||chr(10);   
   l_retval := l_retval||'               select distinct 2 seq, hptc_area_meaning meaning, TO_CHAR(hptc_area_id_value) id'||chr(10);
   l_retval := l_retval||'               from  hig_process_conns_by_area_v'||chr(10);                           
   l_retval := l_retval||'               where hptc_process_type_id = '||pi_process_type_id||chr(10);                           
   
   IF pi_restricted_list = 'Y' THEN
     l_retval := l_retval||'               and hig_process_framework.area_visible_to_user(hptc_area_type,hptc_area_id_value) = ''Y'''||chr(10);
   END IF;
    
   IF pi_include_dummy = 'Y' THEN
     l_retval := l_retval||'               UNION ALL'||chr(10);               
     l_retval := l_retval||'               select 1 seq, ''None'' meaning, null from dual'||chr(10);   
   END IF;
   
   l_retval := l_retval||')'||chr(10);              
   l_retval := l_retval||'order by seq,meaning';
         

   RETURN(l_retval);
   
END process_type_polling_area_lov;
--
-----------------------------------------------------------------------------
--
FUNCTION get_scheduler_state RETURN VARCHAR2 
IS
BEGIN
  --
  RETURN hig_process_api.get_scheduler_state;
  --
END get_scheduler_state;
--
-----------------------------------------------------------------------------
--
FUNCTION disable_check_scheduler_down
RETURN BOOLEAN
IS 
--
  NO_PRIVS EXCEPTION;
  PRAGMA EXCEPTION_INIT(NO_PRIVS, -27486);
--
BEGIN
--
  dbms_scheduler.set_scheduler_attribute('SCHEDULER_DISABLED', 'TRUE');
--
  RETURN hig_process_api.count_running_processes = 0;
EXCEPTION
 WHEN NO_PRIVS THEN
 --
  BEGIN
   RETURN hig_process_api.count_running_processes = 0;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN TRUE;
  END;
 --  
 WHEN OTHERS THEN
  RETURN TRUE;
 --
END disable_check_scheduler_down;
--
END hig_process_framework;
/
