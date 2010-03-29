CREATE OR REPLACE PACKAGE BODY hig_process_api
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/hig_process_api.pkb-arc   3.0   Mar 29 2010 17:09:30   gjohnson  $
--       Module Name      : $Workfile:   hig_process_api.pkb  $
--       Date into PVCS   : $Date:   Mar 29 2010 17:09:30  $
--       Date fetched Out : $Modtime:   Mar 29 2010 17:08:56  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid CONSTANT VARCHAR2(2000) := '$Revision:   3.0  $';

  g_package_name CONSTANT varchar2(30) := 'hig_process_framework';
  
  g_job_name_prefix varchar2(15) := 'PROCESS_';
  
  
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
FUNCTION get_current_process_params RETURN tab_process_params IS


 CURSOR c1 IS
 SELECT *
 FROM hig_process_params
 WHERE hpp_process_id = get_current_process_id;

 l_retval tab_process_params;

BEGIN

 OPEN c1;
 FETCH c1 BULK COLLECT INTO l_retval;
 CLOSE c1;

 RETURN l_retval;

END get_current_process_params; 
--
-----------------------------------------------------------------------------
--
FUNCTION get_current_process_in_files(pi_job_run_seq IN hig_process_job_runs.hpjr_job_run_seq%TYPE) RETURN tab_process_files IS


 CURSOR c1 IS
 SELECT *
 FROM hig_process_files
 WHERE hpf_process_id = get_current_process_id
 AND   hpf_job_run_seq = get_current_job_run_seq
 AND   hpf_input_or_output = 'I';

 l_retval tab_process_files;

BEGIN

 OPEN c1;
 FETCH c1 BULK COLLECT INTO l_retval;
 CLOSE c1;

 RETURN l_retval;

END get_current_process_in_files; 
--
---------------------------------------------------------------------------
--
FUNCTION get_current_process_in_files RETURN tab_process_files IS


 CURSOR c1 IS
 SELECT *
 FROM hig_process_files
 WHERE hpf_process_id = get_current_process_id
 AND   hpf_input_or_output = 'I';
 
 l_retval tab_process_files;

BEGIN

 OPEN c1;
 FETCH c1 BULK COLLECT INTO l_retval;
 CLOSE c1;

 RETURN l_retval;

END get_current_process_in_files;



FUNCTION get_process_created_message RETURN VARCHAR2 IS

BEGIN

 RETURN nm3get.get_ner(pi_ner_appl => 'HIG'
                                ,pi_ner_id   => 510
                                ,pi_raise_not_found => FALSE).ner_descr;
                                
END get_process_created_message; 
--
-----------------------------------------------------------------------------
--
FUNCTION get_process_started_message RETURN VARCHAR2 IS

BEGIN

  RETURN(nm3get.get_ner(pi_ner_appl => 'HIG'
                       ,pi_ner_id   => 531
                       ,pi_raise_not_found => FALSE).ner_descr);

END get_process_started_message;
--
-----------------------------------------------------------------------------
--
FUNCTION get_process_complete_message RETURN VARCHAR2 IS

BEGIN

  RETURN(nm3get.get_ner(pi_ner_appl => 'HIG'
                       ,pi_ner_id   => 511
                       ,pi_raise_not_found => FALSE).ner_descr);

END get_process_complete_message;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_current_process_id(pi_process_id IN hig_processes.hp_process_id%TYPE) IS

BEGIN

 nm3ctx.set_context(p_Attribute  => 'HP_PROCESS_ID'
                   ,p_Value      =>  TO_CHAR(pi_process_id));

END set_current_process_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_current_process_id RETURN hig_processes.hp_process_id%TYPE IS

BEGIN

 RETURN(TO_NUMBER(Sys_Context('NM3SQL','HP_PROCESS_ID')));

END get_current_process_id;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_execution_start IS

 l_id pls_integer;
 PRAGMA autonomous_transaction;
 
 CURSOR c1 IS
 SELECT rowid
 FROM hig_process_files
 WHERE hpf_process_id = get_current_process_id
 AND   hpf_job_run_seq is null
 AND   hpf_input_or_output = 'I'
 FOR UPDATE OF hpf_job_run_seq;
 
 l_tab_rowid nm3type.tab_rowid;
 
 
BEGIN

 select count(hpjr_process_id)+1
 into  l_id 
 from hig_process_job_runs 
 where hpjr_process_id = get_current_process_id;

 insert into hig_process_job_runs(hpjr_process_id
                                 ,hpjr_job_run_seq
                                 ,hpjr_start
                                 )
                          values (get_current_process_id
                                ,l_id
                                ,systimestamp
                                );         


 nm3ctx.set_context(p_Attribute  => 'HPJR_RUN_SEQ'
                   ,p_Value      =>  TO_CHAR(l_id));
                   

 --
 -- mark any input files that are attributed to this process but unattributed to a process execution
 -- with the current exection job run seq
 --
 open c1;
 fetch c1 bulk collect into l_tab_rowid;
 forall f in 1..l_tab_rowid.COUNT 
   update hig_process_files
   set hpf_job_run_seq = l_id
   where rowid = l_tab_rowid(f);
   
  commit; 

  log_it(pi_process_id => get_current_process_id
        ,pi_message    => get_process_started_message);                

END process_execution_start;
--
-----------------------------------------------------------------------------
--
FUNCTION get_current_job_run_seq RETURN hig_process_job_runs.hpjr_job_run_seq%TYPE IS

BEGIN

 RETURN(TO_NUMBER(Sys_Context('NM3SQL','HPJR_RUN_SEQ')));

END get_current_job_run_seq;
--
-----------------------------------------------------------------------------
-- 
PROCEDURE process_execution_end(pi_success_flag    IN hig_processes.hp_success_flag%TYPE DEFAULT 'Y'
                               ,pi_additional_info IN VARCHAR2 DEFAULT NULL) IS

 l_id pls_integer;
 
 PRAGMA autonomous_transaction;
 
 l_current_process_id  hig_processes.hp_process_id%TYPE;
 l_current_job_run_seq hig_process_job_runs.hpjr_job_run_seq%TYPE;
 

BEGIN

 l_current_process_id := get_current_process_id;
 l_current_job_run_seq := get_current_job_run_seq;

--
-- update the job run record if it's not already been updated (perhaps by the bespoke api code that was called by the job)
--
 update hig_process_job_runs
 set    hpjr_end             = systimestamp
       ,hpjr_success_flag    = pi_success_flag
       ,hpjr_additional_info = SUBSTR(pi_additional_info,1,500)
 where  hpjr_process_id      = l_current_process_id
 and    hpjr_job_run_seq     = l_current_job_run_seq
 and    hpjr_end IS NULL;

--
-- if job run record was updated then also update the process record
--
 IF sql%ROWCOUNT = 1 THEN
   update hig_processes
   set    hp_success_flag = pi_success_flag
   where  hp_process_id   = l_current_process_id; 

   log_it(pi_process_id => l_current_process_id
         ,pi_message    => get_process_complete_message);
 END IF;         
       
 commit;
 
--
-- this procedure should always be the last procedure called in the execution of a process
-- to make doubly sure raise an application error to stop further processing
--
 raise_application_error(-20099,'Processing stopped');
 
END process_execution_end;
--
-----------------------------------------------------------------------------
--
FUNCTION get_current_process RETURN hig_processes%ROWTYPE IS

 CURSOR c1 IS
 SELECT *
 FROM   hig_processes
 WHERE  hp_process_id = hig_process_api.get_current_process_id;
 
 l_retval hig_processes%ROWTYPE; 

BEGIN

 OPEN c1;
 FETCH c1 INTO l_retval;
 CLOSE c1;

 RETURN(l_retval);

END get_current_process;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_file_cardinality(pi_process_id  IN hig_processes.hp_process_id%TYPE) IS

 CURSOR c1 IS
    SELECT *
    FROM 
    (
        SELECT hptf_name
              ,hptf_min_input_files
              ,hptf_max_input_files
              ,count_of_files
              ,case when count_of_files < hptf_min_input_files THEN
                520
                     when count_of_files > hptf_max_input_files THEN
                519
               ELSE
                Null
               end violation
        FROM               
        (
         SELECT hptf_file_type_id
               ,hptf_name
               ,NVL(hptf_min_input_files,0) hptf_min_input_files
               ,NVL(hptf_max_input_files,0) hptf_max_input_files 
               ,(select count(*) 
                      from hig_process_files
                      where hpf_process_id = pi_process_id
                      and   hpf_file_type_id = hptf_file_type_id) count_of_files
         FROM hig_process_type_files
             ,hig_processes 
         WHERE hp_process_id = pi_process_id
         AND   hptf_process_type_id = hp_process_type_id
         AND   hptf_input = 'Y'
        )
    )    
    where violation is not null;
       
BEGIN

 FOR i IN c1 LOOP
   IF i.violation = 519 THEN
   
       hig.raise_ner(pi_appl => 'HIG'
                    ,pi_id   => i.violation
                    ,pi_supplementary_info => i.hptf_name||'  Limit '||i.hptf_max_input_files||' Submitted '||i.count_of_files
                    );
 
   ELSE
   
       hig.raise_ner(pi_appl => 'HIG'
                    ,pi_id   => i.violation
                    ,pi_supplementary_info => i.hptf_name||'  Minimum '||i.hptf_min_input_files||' Submitted '||i.count_of_files
                    );
   
   
   END IF;                    
 
 END LOOP;  
 
END check_file_cardinality;                
--
-----------------------------------------------------------------------------
--
PROCEDURE associate_files_with_process(pi_process_id             IN hig_process_files.hpf_process_id%TYPE
                                      ,pi_job_run_seq            IN hig_process_files.hpf_job_run_seq%TYPE
                                      ,pi_tab_files              IN tab_temp_files
                                      ,pi_check_file_cardinality IN BOOLEAN DEFAULT FALSE) IS
                                      

 l_file_id hig_process_files.hpf_file_id%TYPE;

BEGIN                                                                            


--
-- to tell the process that is executed which files is should be using (if any)
--                    
 FOR f IN 1..pi_tab_files.COUNT LOOP
     
     l_file_id := nm3ddl.sequence_nextval('hpf_file_id_seq');
 
     INSERT INTO hig_process_files(hpf_file_id
                                 , hpf_process_id
                                 , hpf_job_run_seq
                                 , hpf_filename
                                 , hpf_input_or_output
                                 , hpf_destination
                                 , hpf_destination_type
                                 , hpf_file_type_id)
                          VALUES(  l_file_id
                                 , pi_process_id
                                 , pi_job_run_seq
                                 , pi_tab_files(f).filename
                                 , pi_tab_files(f).I_or_O
                                 , pi_tab_files(f).destination
                                 , pi_tab_files(f).destination_type                                 
                                 , pi_tab_files(f).file_type_id
                                 );

     IF pi_tab_files(f).destination_type = 'DATABASE_TABLE' THEN
                                 
       INSERT into hig_process_file_blobs(hpfb_file_id               
                                         ,hpfb_content)
       VALUES (l_file_id
              ,pi_tab_files(f).content);
           
     END IF;                                                                              
                                  

 END LOOP;
 
 IF pi_check_file_cardinality THEN
   check_file_cardinality(pi_process_id => pi_process_id);
 END IF;   
 
EXCEPTION
 WHEN others THEN
   ROLLBACK;
   RAISE;  
 
END associate_files_with_process; 
-- 
-----------------------------------------------------------------------------
--
PROCEDURE associate_files_with_process(pi_tab_files              IN tab_temp_files
                                      ,pi_check_file_cardinality IN BOOLEAN DEFAULT FALSE) IS
                                      
BEGIN

   associate_files_with_process(pi_process_id             => get_current_process_id
                               ,pi_job_run_seq            => get_current_job_run_seq
                               ,pi_tab_files              => pi_tab_files
                               ,pi_check_file_cardinality => pi_check_file_cardinality);


END  associate_files_with_process;                                     
--
-----------------------------------------------------------------------------
--
PROCEDURE associate_params_with_process(pi_process_id  IN hig_processes.hp_process_id%TYPE
                                       ,pi_tab_params  IN tab_temp_params) IS


BEGIN
 
 
    --
    -- To facilitate parameter passing to the process that is executed...  
    -- 
     FOR p IN 1..pi_tab_params.COUNT LOOP

         INSERT INTO hig_process_params(hpp_process_id
                                      , hpp_seq
                                      , hpp_param_name
                                      , hpp_param_value
                                       )
                                VALUES( pi_process_id
                                      ,p                             
                                      ,pi_tab_params(p).param_name
                                      ,pi_tab_params(p).param_value
                                      );
     END LOOP;
     
END associate_params_with_process;     
--
-----------------------------------------------------------------------------
--
PROCEDURE associate_params_with_process(pi_tab_params  IN tab_temp_params) IS


BEGIN

 associate_params_with_process(pi_process_id  => get_current_process_id
                              ,pi_tab_params  => pi_tab_params);

END associate_params_with_process;
--
-----------------------------------------------------------------------------
--
PROCEDURE initialise_temp_params IS

BEGIN

 g_tab_temp_params.DELETE;

END initialise_temp_params;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_temp_param(pi_rec  IN  rec_temp_params) IS


 l_subscript pls_integer := g_tab_temp_params.COUNT+1;

BEGIN

 g_tab_temp_params(l_subscript).param_name   := pi_rec.param_name;
 g_tab_temp_params(l_subscript).param_value  := pi_rec.param_value; 
 

END add_temp_param;
--
-----------------------------------------------------------------------------
--
PROCEDURE initialise_temp_files IS

BEGIN

 g_tab_temp_files.DELETE;

END initialise_temp_files;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_temp_file(pi_rec  IN  rec_temp_files) IS


 l_subscript pls_integer := g_tab_temp_files.COUNT+1;

BEGIN

 g_tab_temp_files(l_subscript).filename         := pi_rec.filename;
 g_tab_temp_files(l_subscript).file_type_id     := pi_rec.file_type_id;
 g_tab_temp_files(l_subscript).I_or_O           := pi_rec.I_or_O;
 g_tab_temp_files(l_subscript).destination      := pi_rec.destination;
 g_tab_temp_files(l_subscript).destination_type := pi_rec.destination_type;   
 g_tab_temp_files(l_subscript).content          := pi_rec.content; 

END add_temp_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_limit_not_reached(pi_process_type_id   IN hig_process_types.hpt_process_type_id%TYPE
                                 ,pi_limit             IN hig_process_types.hpt_process_limit%TYPE) IS
                    
 l_count_live_processes pls_integer;
             
BEGIN

 IF pi_limit > 0 THEN
  
     SELECT count(1)
     INTO   l_count_live_processes
     FROM   hig_processes_v
     WHERE  hp_process_type_id = pi_process_type_id
     AND    hpj_next_run_date >= sysdate
     AND    upper(hpj_job_state) != 'DISABLED';
 
     IF l_count_live_processes+1 > pi_limit THEN
        hig.raise_ner(pi_appl => 'HIG'
                     ,pi_id   => 517
                     ,pi_supplementary_info => 'Limit ['||pi_limit||']'); -- Process cannot be submitted because the limit for this process type has been reached
     END IF;
     
 END IF;     
 


END check_limit_not_reached;                                   
--
-----------------------------------------------------------------------------
--
PROCEDURE create_and_schedule_process    (pi_process_type_id           IN hig_processes.hp_process_type_id%TYPE
                                        , pi_initiated_by_username     IN hig_processes.hp_initiated_by_username%TYPE DEFAULT USER
                                        , pi_initiated_date            IN hig_processes.hp_initiated_date%TYPE DEFAULT SYSDATE
                                        , pi_initiators_ref            IN hig_processes.hp_initiators_ref%TYPE
--                                        , pi_job_owner                 IN hig_processes.hp_job_owner%TYPE DEFAULT USER
                                        , pi_start_date                IN date
                                        , pi_frequency_id              IN hig_processes.hp_frequency_id%TYPE
                                         ,pi_check_file_cardinality    IN BOOLEAN DEFAULT FALSE
                                        , po_process_id                OUT hig_processes.hp_process_id%TYPE
                                        , po_job_name                  OUT hig_processes.hp_job_name%TYPE
                                        , po_scheduled_start_date      OUT date) IS
                                        

 l_process_type_rec hig_process_types%ROWTYPE;
 l_frequency_rec    hig_scheduling_frequencies%ROWTYPE;
 l_what             nm3type.max_varchar2;
 l_job_rec          dba_scheduler_jobs%ROWTYPE;
 l_full_job_name    hig_processes_v.hp_full_job_name%TYPE;
 l_job_owner        varchar2(30) := USER;
 
                      
BEGIN


 l_process_type_rec := hig_process_framework.get_process_type(pi_process_type_id => pi_process_type_id);
 
 
 check_limit_not_reached(pi_process_type_id => l_process_type_rec.hpt_process_type_id
                        ,pi_limit           => l_process_type_rec.hpt_process_limit);
  
 po_process_id := nm3ddl.sequence_nextval('hp_process_id_seq');
 
 --
 -- job names need to be unique cos we need to join between hig_process_jobs and the data dictionary views based on this value
 --
 po_job_name := g_job_name_prefix||po_process_id;
 l_full_job_name := l_job_owner||'.'||po_job_name;
 
 INSERT INTO hig_processes(hp_process_id
                         , hp_process_type_id
                         , hp_initiated_by_username
                         , hp_job_owner
                         , hp_initiated_date
                         , hp_initiators_ref
                         , hp_job_name
                         , hp_frequency_id
                         , hp_what_to_call)
                   VALUES (po_process_id
                         , pi_process_type_id
                         , pi_initiated_by_username
                         , l_job_owner
                         , pi_initiated_date
                         , pi_initiators_ref
                         , po_job_name
                         , NVL(pi_frequency_id,-1) -- default frequency to -1 "Once"
                         , l_process_type_rec.hpt_what_to_call                         
                         );
                
          
 associate_files_with_process(pi_process_id             => po_process_id
                             ,pi_job_run_seq            => Null -- the job hasn't been executed yet so there is no record in hig_process_job_runs to relate to - process_execution_start will tie the files in when the hpjr record is created 
                             ,pi_tab_files              => g_tab_temp_files
                             ,pi_check_file_cardinality => pi_check_file_cardinality);
 
 g_tab_temp_files.DELETE; -- clear out so next process that's submitted doesn't re-use what's in the pl/sql table
 
 associate_params_with_process(pi_process_id  => po_process_id
                              ,pi_tab_params  => g_tab_temp_params);

 g_tab_temp_params.DELETE; -- clear out so next process that's submitted doesn't re-use what's in the pl/sql table
                             

--
-- Now schedule a job for this process
--
 
 IF pi_frequency_id IS NOT NULL THEN
  l_frequency_rec := hig_process_framework.get_frequency(pi_frequency_id => pi_frequency_id);
 END IF;
 
 --
 -- build up a string which will be executed by the resulting scheduled job
 --
 l_what := hig_process_framework.wrapper_around_what(pi_what_to_call => l_process_type_rec.hpt_what_to_call
                                                    ,pi_process_id    => po_process_id);
 
 
       nm3jobs.create_job(pi_job_name        => po_job_name
                        , pi_job_action      => l_what
                        , pi_repeat_interval => l_frequency_rec.hsfr_frequency
                        , pi_comments        => pi_initiators_ref
                        , pi_job_type        => 'PLSQL_BLOCK'
                        , pi_job_owner       => l_job_owner
                        , pi_start_date      => pi_start_date
                        , pi_end_date        => Null
                        , pi_enabled         => FALSE
                        , pi_auto_drop       => FALSE);

 nm3jobs.amend_job_restartable(pi_job_name => l_full_job_name
                              ,pi_value    => l_process_type_rec.hpt_restartable = 'Y');

 enable_process(pi_process_id => po_process_id);                                    
                        

 l_job_rec := hig_process_framework.get_job(pi_job_name =>  po_job_name);
                         
 po_scheduled_start_date := NVL(l_job_rec.last_start_date,l_job_rec.next_run_date);                       

 commit;                    

END create_and_schedule_process;                           
--
-----------------------------------------------------------------------------
--
FUNCTION lock_process(pi_process_id IN hig_processes.hp_process_id%TYPE) RETURN rowid IS

   CURSOR c1 IS
   SELECT ROWID
    FROM  hig_processes
   WHERE  hp_process_id = pi_process_id
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
                    ,pi_supplementary_info => 'hig_processes (HP_PK)'
                                              ||CHR(10)||'hp_process_id => '||pi_process_id
                    );
   END IF;

   RETURN l_retval;

EXCEPTION

   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => -20001
                    ,pi_supplementary_info => 'hig_processes (HP_PK)'
                                              ||CHR(10)||'hp_process_id => '||pi_process_id
                    );


END lock_process;
--
-----------------------------------------------------------------------------
--
PROCEDURE amend_process    (pi_process_id           IN hig_processes.hp_process_id%TYPE
                           ,pi_job_name             IN hig_processes.hp_job_name%TYPE
                           ,pi_initiators_ref       IN hig_processes.hp_initiators_ref%TYPE
                           ,pi_frequency_id         IN hig_processes.hp_frequency_id%TYPE
                           ,pi_scheduled_date       IN DATE) IS


 l_frequency_rec    hig_scheduling_frequencies%ROWTYPE;
 l_full_job_name    hig_processes_v.hp_full_job_name%TYPE;
 l_rowid            rowid;

 l_hpt_what         hig_process_types.hpt_what_to_call%TYPE;
 
 CURSOR c_what IS
 SELECT hpt_what_to_call
 FROM   hig_process_types
       ,hig_processes
 WHERE  hp_process_id       = pi_process_id
 AND    hpt_process_type_id = hp_process_type_id;
                      
BEGIN

 hig_process_framework.check_process_can_be_amended(pi_process_id => pi_process_id); -- double check process is still disabled

 l_full_job_name := hig_process_framework.get_process_and_job(pi_process_id => pi_process_id).hp_full_job_name;
 
 
 hig_process_framework.check_process_can_be_amended(pi_process_Id => pi_process_Id); 

 l_rowid := lock_process(pi_process_id => pi_process_id);

 UPDATE  hig_processes
 SET     hp_initiators_ref  = pi_initiators_ref
       , hp_frequency_id   = pi_frequency_id
 WHERE   rowid = l_rowid;
  

  -- 
  -- Now updated the job for this process
  --
 
  IF pi_frequency_id IS NOT NULL THEN
    l_frequency_rec := hig_process_framework.get_frequency(pi_frequency_id => pi_frequency_id);
  END IF;
 
--
-- change attributes of the scheduled job
--
  OPEN c_what;
  FETCH c_what INTO l_hpt_what;
  CLOSE c_what;

  nm3jobs.amend_job_action(pi_job_name => l_full_job_name
                          ,pi_value    => hig_process_framework.wrapper_around_what(pi_what_to_call => l_hpt_what
                                                                                   ,pi_process_id    => pi_process_id));                                                      



  nm3jobs.amend_job_start_datim (pi_job_name => l_full_job_name  
                                 ,pi_value    => pi_scheduled_date);

  nm3jobs.amend_job_interval (pi_job_name => l_full_job_name 
                             ,pi_value    => l_frequency_rec.hsfr_frequency);



 commit;                    


END amend_process;
--
-----------------------------------------------------------------------------
--
PROCEDURE log_it(pi_process_id             IN hig_process_log.hpl_process_id%TYPE 
                ,pi_message                IN VARCHAR2
                ,pi_message_type           IN hig_process_log.hpl_message_type%TYPE default 'I'
                ,pi_summary_flag           IN hig_process_log.hpl_summary_flag%TYPE default 'Y') IS  

 PRAGMA autonomous_transaction;
 
 l_process_run_seq hig_process_job_runs.hpjr_job_run_seq%TYPE;
                
BEGIN

IF pi_process_id IS NOT NULL THEN

     l_process_run_seq := get_current_job_run_seq;

     insert into hig_process_log(hpl_process_id
                               , hpl_job_run_seq
                               , hpl_log_seq
                               , hpl_timestamp
                               , hpl_message_type
                               , hpl_summary_flag
                               , hpl_message)
                            select pi_process_id
                                   ,l_process_run_seq
                                   ,(select count(hpl_process_id)+1
                                       from hig_process_log  
                                       where hpl_process_id = pi_process_id 
                                       and hpl_job_run_seq = l_process_run_seq)        
                                   ,systimestamp
                                   ,pi_message_type
                                   ,pi_summary_flag
                                   ,NVL(SUBSTR(pi_message,1,500),' ')
                          from dual;                               
                                   
     commit;

END IF;
 
EXCEPTION
 when others then null;                                

END  log_it;             
--
-----------------------------------------------------------------------------
--
PROCEDURE log_it(pi_message                IN VARCHAR2
                ,pi_message_type           IN hig_process_log.hpl_message_type%TYPE default 'I'
                ,pi_summary_flag           IN hig_process_log.hpl_summary_flag%TYPE default 'Y'  ) IS

BEGIN

          log_it(pi_process_id             => get_current_process_id
                ,pi_message                => pi_message   
                ,pi_message_type           => pi_message_type
                ,pi_summary_flag           => pi_summary_flag );

END log_it;
--
-----------------------------------------------------------------------------
--
PROCEDURE log_it(pi_process_id             IN hig_process_log.hpl_process_id%TYPE 
                ,pi_tab_messages           IN nm3type.tab_varchar32767
                ,pi_message_type           IN hig_process_log.hpl_message_type%TYPE default 'I'
                ,pi_summary_flag           IN hig_process_log.hpl_summary_flag%TYPE default 'Y') IS
 
BEGIN

 FOR i IN 1..pi_tab_messages.COUNT LOOP
 
 
  log_it(pi_process_id    => pi_process_id 
        ,pi_message       => pi_tab_messages(i)
        ,pi_message_type  => pi_message_type
        ,pi_summary_flag  => pi_summary_flag);
 
 END LOOP;

END log_it;                  
--
-----------------------------------------------------------------------------
--
PROCEDURE log_it(pi_tab_messages           IN nm3type.tab_varchar32767
                ,pi_message_type           IN hig_process_log.hpl_message_type%TYPE default 'I'
                ,pi_summary_flag           IN hig_process_log.hpl_summary_flag%TYPE default 'Y') IS

BEGIN

          log_it(pi_process_id             => get_current_process_id
                ,pi_tab_messages           => pi_tab_messages   
                ,pi_message_type           => pi_message_type
                ,pi_summary_flag           => pi_summary_flag );

END log_it;
--
-----------------------------------------------------------------------------
--
PROCEDURE log_it(pi_process_id             IN hig_process_log.hpl_process_id%TYPE 
                ,pi_message_clob           IN clob
                ,pi_message_type           IN hig_process_log.hpl_message_type%TYPE default 'I'
                ,pi_summary_flag           IN hig_process_log.hpl_summary_flag%TYPE default 'Y') IS
 
 l_tab_vc nm3type.tab_varchar32767;
          
BEGIN

 l_tab_vc := nm3clob.clob_to_tab_varchar(pi_clob => pi_message_clob);
 
 
 l_tab_vc := nm3tab_varchar.cleanse_tab_vc (pi_tab_vc             => l_tab_vc
                                           ,pi_remove_blank_lines => FALSE
                                           ,pi_remove_cr          => TRUE);
 
 log_it(pi_process_id    => pi_process_id 
       ,pi_tab_messages  => l_tab_vc
       ,pi_message_type  => pi_message_type
       ,pi_summary_flag  => pi_summary_flag);

END log_it;                  
--
-----------------------------------------------------------------------------
--
PROCEDURE log_it(pi_message_clob           IN clob
                ,pi_message_type           IN hig_process_log.hpl_message_type%TYPE default 'I'
                ,pi_summary_flag           IN hig_process_log.hpl_summary_flag%TYPE default 'Y') IS

BEGIN

          log_it(pi_process_id             => get_current_process_id
                ,pi_message_clob           => pi_message_clob   
                ,pi_message_type           => pi_message_type
                ,pi_summary_flag           => pi_summary_flag );

END log_it;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_process_internal_reference(pi_internal_reference IN hig_process_job_runs.hpjr_internal_reference%TYPE) IS 


BEGIN

 
     set_process_internal_reference(pi_process_id         => get_current_process_id
                                   ,pi_run_seq            => get_current_job_run_seq
                                   ,pi_internal_reference => pi_internal_reference);


END set_process_internal_reference;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_process_internal_reference(pi_process_id         IN hig_process_job_runs.hpjr_process_id%TYPE
                                        ,pi_run_seq            IN hig_process_job_runs.hpjr_job_run_seq%TYPE
                                        ,pi_internal_reference IN hig_process_job_runs.hpjr_internal_reference%TYPE) IS 

 PRAGMA autonomous_transaction;
 
BEGIN

 update hig_process_job_runs
 set hpjr_internal_reference = pi_internal_reference
 where hpjr_process_id =  pi_process_id
 and   hpjr_job_run_seq = pi_run_seq;
 
 commit; 


END set_process_internal_reference;
--
-----------------------------------------------------------------------------
--
FUNCTION disable_process(pi_process_id IN hig_processes.hp_process_id%TYPE) RETURN hig_processes_v.hp_full_job_name%TYPE IS

 l_rec hig_processes_v%ROWTYPE;

BEGIN
 
 --
 -- can only disable a process which is scheduled to run
 --
 hig_process_framework.check_process_is_scheduled(pi_process_id => pi_process_id);

 l_rec := hig_process_framework.get_process_and_job(pi_process_id => pi_process_id);

 nm3jobs.disable_job(pi_job_name => l_rec.hp_full_job_name);
 
 RETURN(l_rec.hp_full_job_name); 
 
END disable_process;
--
-----------------------------------------------------------------------------
--
PROCEDURE disable_process(pi_process_id IN hig_processes.hp_process_id%TYPE) IS

 l_full_job_name hig_processes_v.hp_job_name%TYPE;

BEGIN

 l_full_job_name := disable_process(pi_process_id => pi_process_id);

END disable_process;
--
-----------------------------------------------------------------------------
--
PROCEDURe enable_process(pi_process_id IN hig_processes.hp_process_id%TYPE) IS

 l_rec hig_processes_v%ROWTYPE;

BEGIN
 
 l_rec := hig_process_framework.get_process_and_job(pi_process_id => pi_process_id);

 check_limit_not_reached(pi_process_type_id  => l_rec.hp_process_type_id
                        ,pi_limit            => l_rec.hp_process_limit);         

 nm3jobs.enable_job(pi_job_name => l_rec.hp_full_job_name);
 
-- RETURN(l_rec.hp_full_job_name); 
 
END enable_process;
--
-----------------------------------------------------------------------------
--
PROCEDURE drop_process(pi_process_id IN hig_processes.hp_process_id%TYPE) IS

 l_sqlerrm nm3type.max_varchar2;
 l_process_rec hig_processes_v%ROWTYPE;
 
PRAGMA autonomous_transaction;

BEGIN

 l_process_rec := hig_process_framework.get_process_and_job(pi_process_id => pi_process_id);
 
 delete from hig_processes where hp_process_id = pi_process_id;
 
 nm3jobs.drop_job(pi_job_name => l_process_rec.hp_full_job_name); 
 
 commit;
 
EXCEPTION
  WHEN others THEN
     l_sqlerrm := sqlerrm;
     ROLLBACK;
     
     hig.raise_ner(pi_appl               => 'HIG'
                  ,pi_id                 => 514 -- Process could not be dropped
                  ,pi_supplementary_info => nm3flx.parse_error_message(l_sqlerrm)  );  

END drop_process; 
--
-----------------------------------------------------------------------------
--
PROCEDURE run_process_now(pi_process_id IN hig_processes.hp_process_id%TYPE) IS


 l_sqlerrm nm3type.max_varchar2;
 l_process_rec hig_processes_v%ROWTYPE;
 
PRAGMA autonomous_transaction;

BEGIN

 l_process_rec := hig_process_framework.get_process_and_job(pi_process_id => pi_process_id);
 
 nm3jobs.run_job(pi_job_name            => l_process_rec.hp_full_job_name
                ,pi_use_current_session => FALSE);
 
 commit;
 
END run_process_now; 
--
-----------------------------------------------------------------------------
--



END hig_process_api;
/


