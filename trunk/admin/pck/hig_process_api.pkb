CREATE OR REPLACE PACKAGE BODY hig_process_api
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/hig_process_api.pkb-arc   3.23   Jul 04 2013 14:52:06   James.Wadsworth  $
--       Module Name      : $Workfile:   hig_process_api.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:52:06  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:50:10  $
--       Version          : $Revision:   3.23  $
--       Based on SCCS version : 
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid CONSTANT VARCHAR2(2000) := '$Revision:   3.23  $';

  g_package_name CONSTANT varchar2(30) := 'hig_process_framework';
  
  g_job_name_prefix varchar2(15) := 'PROCESS_';
  
  g_ftp_error Boolean := FALSE ;
  
  
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
FUNCTION get_current_process_in_files RETURN tab_process_files IS


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
/*
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
*/
--
---------------------------------------------------------------------------
--
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
PROCEDURE set_success_flag(pi_success_flag IN hig_processes.hp_success_flag%TYPE) IS

BEGIN

 nm3ctx.set_context(p_Attribute  => 'HP_SUCCESS_FLAG'
                   ,p_Value      =>  pi_success_flag);

END set_success_flag;
--
-----------------------------------------------------------------------------
--
FUNCTION get_success_flag RETURN hig_processes.hp_success_flag%TYPE IS

BEGIN

 RETURN(Sys_Context('NM3SQL','HP_SUCCESS_FLAG'));

END get_success_flag;
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
PROCEDURE set_current_job_run_seq(pi_job_run_seq IN hig_process_job_runs.hpjr_job_run_seq%TYPE) IS

BEGIN

 nm3ctx.set_context(p_Attribute  => 'HPJR_RUN_SEQ'
                   ,p_Value      =>  TO_CHAR(pi_job_run_seq));

END set_current_job_run_seq;
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
FUNCTION last_process_job_run(pi_process_id IN hig_processes.hp_process_id%TYPE) RETURN hig_process_job_runs.hpjr_job_run_seq%TYPE IS

 l_retval hig_process_job_runs.hpjr_job_run_seq%TYPE;

BEGIN

 select count(hpjr_process_id)
 into  l_retval 
 from hig_process_job_runs 
 where hpjr_process_id = pi_process_id;

 RETURN(l_retval);


END last_process_job_run;
--
-----------------------------------------------------------------------------
--
FUNCTION next_process_job_run(pi_process_id IN hig_processes.hp_process_id%TYPE) RETURN hig_process_job_runs.hpjr_job_run_seq%TYPE IS

BEGIN

 RETURN ( last_process_job_run(pi_process_id => pi_process_id)+1 );

END next_process_job_run;
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

 l_id := next_process_job_run(pi_process_id => get_current_process_id);

 insert into hig_process_job_runs(hpjr_process_id
                                 ,hpjr_job_run_seq
                                 ,hpjr_start
                                 )
                          values (get_current_process_id
                                ,l_id
                                ,systimestamp
                                );         


 set_current_job_run_seq(pi_job_run_seq => l_id); 
 set_success_flag(pi_success_flag => 'Y');

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
PROCEDURE process_execution_end(pi_success_flag    IN hig_processes.hp_success_flag%TYPE DEFAULT 'Y'
                               ,pi_additional_info IN VARCHAR2 DEFAULT NULL
                               ,pi_force           IN BOOLEAN DEFAULT FALSE) IS

 l_id pls_integer;
 
 PRAGMA autonomous_transaction; 
 
 l_current_process_rec  hig_processes%ROWTYPE;
 l_current_job_run_seq  hig_process_job_runs.hpjr_job_run_seq%TYPE;
 l_hpal_rec             hig_process_alert_log%ROWTYPE;
 l_force varchar2(10);
 
 l_nau_rec              nm_admin_units_all%ROWTYPE;
 l_refcursor            nm3type.ref_cursor;
 

BEGIN

 l_current_process_rec := get_current_process;
 l_current_job_run_seq := get_current_job_run_seq;
 
 IF l_current_job_run_seq IS NOT NULL THEN -- only bother to go ahead with sweeping things up if we've NOT binned the current execution 

        --
        -- Set execution end context
        --
         set_success_flag(pi_success_flag => pi_success_flag); 

        --
        -- 
        --
         l_force := nm3flx.boolean_to_char(pi_force);
         
             update hig_process_job_runs
             set    hpjr_end             = systimestamp
                   ,hpjr_success_flag    = pi_success_flag
                   ,hpjr_additional_info = SUBSTR(pi_additional_info,1,500)
             where  hpjr_process_id      = l_current_process_rec.hp_process_id
             and    hpjr_job_run_seq     = l_current_job_run_seq
             and    (
                      (l_force = 'TRUE')
                    OR
                      (hpjr_end IS NULL) -- only update the job run record if it's not already been updated (perhaps by the bespoke api code that was called by the job)
                    );      
             

        --
        -- if job run record was updated then also update the process record
        --
         IF sql%ROWCOUNT = 1 THEN
           update hig_processes
           set    hp_success_flag = pi_success_flag
           where  hp_process_id   = l_current_process_rec.hp_process_id; 

           log_it(pi_process_id => l_current_process_rec.hp_process_id
                 ,pi_message    => get_process_complete_message);
         END IF;         



         --
         -- throw a record into hig_process_alert_log to trigger notifications
         --
         l_hpal_rec.hpal_success_flag      := pi_success_flag; 
         l_hpal_rec.hpal_process_type_id   := l_current_process_rec.hp_process_type_id; 
         l_hpal_rec.hpal_process_id        := l_current_process_rec.hp_process_id;
         l_hpal_rec.hpal_job_run_seq       := l_current_job_run_seq;
         l_hpal_rec.hpal_initiated_user    := l_current_process_rec.hp_initiated_by_username;
              
          IF l_current_process_rec.hp_area_type = 'ADMIN_UNIT' AND l_current_process_rec.hp_area_id IS NOT NULL THEN
             l_nau_rec := nm3get.get_nau_all(pi_nau_admin_unit =>  l_current_process_rec.hp_area_id
                                            ,pi_raise_not_found => FALSE);  
                  
             l_hpal_rec.hpal_admin_unit     := l_nau_rec.nau_admin_unit;
             l_hpal_rec.hpal_unit_code      := l_nau_rec.nau_unit_code;
             l_hpal_rec.hpal_unit_name      := l_nau_rec.nau_name;

          ELSIF l_current_process_rec.hp_area_type IN ('CONTRACTOR','CIM_CONTRACTOR') AND l_current_process_rec.hp_area_id IS NOT NULL THEN 
              
             OPEN l_refcursor FOR 'SELECT oun_unit_code, oun_name FROM org_units WHERE oun_org_id = :a' USING l_current_process_rec.hp_area_id;
             FETCH l_refcursor INTO l_hpal_rec.hpal_con_code,l_hpal_rec.hpal_con_name;
             CLOSE l_refcursor;
                 
          END IF;
          --TASK 0110519 
          --Raise Alert only non-polling process or the polling process has failed
          IF  Nvl(Sys_Context('NM3SQL','HIG_POLLING_PROCESS'),'N') = 'N'
          OR  pi_success_flag = 'N'
          THEN          
              create_alert_log (pi_hpal_rec => l_hpal_rec);
          END IF ;
              
         commit;

 END IF;

 
END process_execution_end;
--
-----------------------------------------------------------------------------
--
PROCEDURE drop_execution IS

 l_current_process_id  hig_processes.hp_process_id%TYPE;
 l_current_job_run_seq hig_process_job_runs.hpjr_job_run_seq%TYPE;

 PRAGMA autonomous_transaction;
 
BEGIN

 l_current_process_id := get_current_process_id;
 l_current_job_run_seq := get_current_job_run_seq;


 delete from hig_process_job_runs 
 where hpjr_process_id = l_current_process_id
 and   hpjr_job_run_seq = l_current_job_run_seq;

 update hig_processes
 set    hp_success_flag = 'Y'
 where  hp_process_id   = l_current_process_id;
 
 set_current_job_run_seq(pi_job_run_seq => Null);  

 commit;

END drop_execution;
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
               ,NVL(hptf_max_input_files,999999999) hptf_max_input_files 
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
 --
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
                                 ,pi_polling_flag      IN hig_processes.hp_polling_flag%TYPE           
                                 ,pi_area_id           IN hig_processes.hp_area_id%TYPE) IS
                    
 l_count_live_processes pls_integer;
 l_area_id              hig_processes.hp_area_id%TYPE;       
 l_process_type_rec     hig_process_types%ROWTYPE;
             
BEGIN

 l_process_type_rec := hig_process_framework.get_process_type(pi_process_type_id => pi_process_type_id);

 
 IF pi_polling_flag = 'Y' THEN
   l_process_type_rec.hpt_process_limit := 1; -- polling implies a limit of 1 
 END IF;


 IF l_process_type_rec.hpt_process_limit > 0 THEN
  
     SELECT count(1)  
     INTO   l_count_live_processes
     FROM   hig_processes_v
     WHERE  hp_process_type_id      = pi_process_type_id
     AND    (
               (hp_area_id = pi_area_id)
            OR 
               (pi_area_id IS NULL)
            )
     AND    (
             (hpj_next_run_date >= sysdate AND  upper(hpj_job_state) != 'DISABLED') 
           OR 
            ( upper(hpj_job_state) = 'RUNNING')
            );

     IF l_count_live_processes+1 > l_process_type_rec.hpt_process_limit THEN
        hig.raise_ner(pi_appl => 'HIG'
                     ,pi_id   => 517
                     ,pi_supplementary_info => 'Limit ['||l_process_type_rec.hpt_process_limit||']'); -- Process cannot be submitted because the limit for this process type has been reached
     END IF;
     
 END IF;     
 


END check_limit_not_reached;                                   
--
-----------------------------------------------------------------------------
--
PROCEDURE create_and_schedule_process    (pi_process_type_id           IN hig_processes.hp_process_type_id%TYPE
                                        , pi_initiated_by_username     IN hig_processes.hp_initiated_by_username%TYPE DEFAULT Sys_Context('NM3_SECURITY_CTX','USERNAME')
                                        , pi_initiated_date            IN hig_processes.hp_initiated_date%TYPE DEFAULT SYSDATE
                                        , pi_initiators_ref            IN hig_processes.hp_initiators_ref%TYPE
--                                        , pi_job_owner                 IN hig_processes.hp_job_owner%TYPE DEFAULT Sys_Context('NM3_SECURITY_CTX','USERNAME')
                                        , pi_start_date                IN date
                                        , pi_frequency_id              IN hig_processes.hp_frequency_id%TYPE
                                        , pi_polling_flag              IN hig_processes.hp_polling_flag%TYPE DEFAULT 'N'
                                        , pi_area_id                   IN hig_processes.hp_area_id%TYPE DEFAULT NULL
                                        , pi_check_file_cardinality    IN BOOLEAN DEFAULT FALSE
                                        , pi_max_failures              IN NUMBER DEFAULT Null
                                        , po_process_id                OUT hig_processes.hp_process_id%TYPE
                                        , po_job_name                  OUT hig_processes.hp_job_name%TYPE
                                        , po_scheduled_start_date      OUT date) IS
                                        

 l_process_type_rec hig_process_types%ROWTYPE;
 l_frequency_rec    hig_scheduling_frequencies%ROWTYPE;
 l_what             nm3type.max_varchar2;
 l_job_rec          dba_scheduler_jobs%ROWTYPE;
 l_full_job_name    hig_processes_v.hp_full_job_name%TYPE;
 l_job_owner        varchar2(30) := Sys_Context('NM3_SECURITY_CTX','USERNAME');
 
 l_sqlerrm nm3type.max_varchar2;
 
 
 
 PROCEDURE double_check_privs IS
 
 BEGIN
 
     IF NOT nm3user.user_has_priv(pi_priv => 'CREATE JOB') AND NOT nm3user.user_has_priv(pi_priv => 'CREATE ANY JOB')  THEN

      hig.raise_ner(pi_appl => 'HIG'
                   ,pi_id   => 126
                   ,pi_supplementary_info => 'Create Job'); -- You do not have privileges to perform this action

     END IF;

 END;
 
BEGIN
 IF get_scheduler_state != 'UP'
 THEN
   hig.raise_ner( pi_appl => 'HIG'
                , pi_id   => 555
                );
 END IF;

 double_check_privs;

 l_process_type_rec := hig_process_framework.get_process_type(pi_process_type_id => pi_process_type_id);
 
 
 check_limit_not_reached(pi_process_type_id => l_process_type_rec.hpt_process_type_id
                        ,pi_polling_flag    => pi_polling_flag
                        ,pi_area_id         => pi_area_id);
  
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
                         , hp_what_to_call
                         , hp_polling_flag
                         , hp_area_type
                         , hp_area_id
                         , hp_area_meaning)
                   VALUES (po_process_id
                         , pi_process_type_id
                         , pi_initiated_by_username
                         , l_job_owner
                         , pi_initiated_date
                         , pi_initiators_ref
                         , po_job_name
                         , NVL(pi_frequency_id,-1) -- default frequency to -1 "Once"
                         , l_process_type_rec.hpt_what_to_call
                         , NVL(pi_polling_flag,'N')
                         , case when pi_area_id is not null then
                                 l_process_type_rec.hpt_area_type
                                else
                                 null
                                end
                         , pi_area_id
                         , case when pi_area_id is not null then
                                     hig_process_framework.area_meaning_from_id_value(l_process_type_rec.hpt_area_type,pi_area_id)
                                 else
                                     null
                                 end
                         );
--
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
--
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
--
 nm3jobs.amend_job_restartable(pi_job_name => l_full_job_name
                              ,pi_value    => l_process_type_rec.hpt_restartable = 'Y');
--
 IF pi_max_failures IS NOT NULL THEN
   nm3jobs.amend_job_max_failures(pi_job_name => l_full_job_name
                                 ,pi_value    => pi_max_failures);
 END IF;                                 
--
 enable_process(pi_process_id => po_process_id);                                    
--
 l_job_rec := hig_process_framework.get_job(pi_job_name =>  po_job_name);
--
 po_scheduled_start_date := NVL(l_job_rec.last_start_date,l_job_rec.next_run_date);                       
--
 commit;
--
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
                           ,pi_area_id              IN hig_processes.hp_area_id%TYPE
                           ,pi_scheduled_date       IN DATE) IS


 l_process_rec      hig_processes_v%ROWTYPE;
 l_process_type_rec hig_process_types%ROWTYPE;
 l_frequency_rec    hig_scheduling_frequencies%ROWTYPE;
 l_rowid            rowid;

BEGIN

 hig_process_framework.check_process_can_be_amended(pi_process_id => pi_process_id); -- double check process is still disabled
 l_rowid := lock_process(pi_process_id => pi_process_id);

 l_process_rec := hig_process_framework.get_process_and_job(pi_process_id => pi_process_id);
 l_process_type_rec := hig_process_framework.get_process_type(pi_process_type_id => l_process_rec.hp_process_type_id);
 

 

--
-- change attributes of the scheduled job
--

 UPDATE  hig_processes
 SET     hp_initiators_ref = pi_initiators_ref
       , hp_frequency_id   = pi_frequency_id
       , hp_what_to_call   = l_process_type_rec.hpt_what_to_call
       , hp_area_type =   case when pi_area_id is not null THEN 
                                  l_process_type_rec.hpt_area_type
                               else
                                  null
                               end
       , hp_area_id = pi_area_id
       , hp_area_meaning = case when pi_area_id is not null then
                                     hig_process_framework.area_meaning_from_id_value(l_process_type_rec.hpt_area_type,pi_area_id)
                                else
                                     null
                                end
 WHERE   rowid = l_rowid;
  

  -- 
  -- Now updated the job for this process
  --
 
  IF pi_frequency_id IS NOT NULL THEN
    l_frequency_rec := hig_process_framework.get_frequency(pi_frequency_id => pi_frequency_id);
  END IF;
 


  nm3jobs.amend_job_action(pi_job_name => l_process_rec.hp_full_job_name
                          ,pi_value    => hig_process_framework.wrapper_around_what(pi_what_to_call => l_process_type_rec.hpt_what_to_call
                                                                                   ,pi_process_id    => pi_process_id));                                                      



  nm3jobs.amend_job_start_datim (pi_job_name => l_process_rec.hp_full_job_name  
                                 ,pi_value    => pi_scheduled_date);

  nm3jobs.amend_job_interval (pi_job_name => l_process_rec.hp_full_job_name 
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

-- l_process_run_seq := NVL(get_current_job_run_seq,last_process_job_run(pi_process_id => pi_process_id));
   l_process_run_seq := get_current_job_run_seq;

IF pi_process_id IS NOT NULL AND get_current_job_run_seq IS NOT NULL THEN


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
                        ,pi_polling_flag     => l_rec.hp_polling_flag
                        ,pi_area_id          => l_rec.hp_area_id);         

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
PROCEDURE create_alert_log (pi_hpal_rec IN OUT hig_process_alert_log%ROWTYPE)
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   
   l_nau_rec nm_admin_units_all%ROWTYPE;

BEGIN

   pi_hpal_rec.hpal_id := nm3ddl.sequence_nextval('hpal_id_seq');

   INSERT INTO hig_process_alert_log VALUES pi_hpal_rec;

   Commit;

END create_alert_log;  
--
-----------------------------------------------------------------------------
--
FUNCTION get_conns_for_process(pi_process_id IN hig_processes.hp_process_id%TYPE) RETURN nm_id_tbl IS
 
 CURSOR c1 IS
 select hfc_id 
 from hig_process_polled_conns_v
 where hp_process_id = pi_process_id;
  
 l_retval nm_id_tbl;
 
BEGIN

 OPEN c1;
 FETCH c1 BULK COLLECT INTO l_retval;
 CLOSE c1;
 
 RETURN l_retval;


END get_conns_for_process;
--
-----------------------------------------------------------------------------
--
FUNCTION get_conns_for_current_process RETURN nm_id_tbl IS

BEGIN
 
 RETURN(get_conns_for_process(pi_process_id => hig_process_api.get_current_process_id));

END get_conns_for_current_process; 
--
-----------------------------------------------------------------------------
--
FUNCTION do_polling_if_requested(pi_file_type_name          IN hig_process_type_files.hptf_name%TYPE
                               , pi_file_mask               IN VARCHAR2
                               , pi_binary                  IN BOOLEAN DEFAULT TRUE
                               , pi_archive_overwrite       IN BOOLEAN DEFAULT FALSE
                               , pi_remove_failed_arch      IN BOOLEAN DEFAULT FALSE) RETURN BOOLEAN IS
  --
  l_process_rec       hig_processes%ROWTYPE;
  l_process_type_rec  hig_process_types%ROWTYPE;
  l_file_type_rec     hig_process_type_files%ROWTYPE;
  --
  l_tab_ftp_connections  nm_id_tbl;        
  --
  l_files        nm3type.tab_varchar32767;
  lt_all_files   nm3type.tab_varchar32767;
  lt_extensions  nm3type.tab_varchar80;
  --
  PROCEDURE get_extensions
    IS
  BEGIN
    --
    SELECT DISTINCT UPPER(hpte_extension)
      BULK COLLECT
      INTO lt_extensions
      FROM hig_process_type_file_ext
          ,hig_process_type_files
     WHERE hptf_process_type_id = l_process_rec.hp_process_type_id
       AND hptf_input = 'Y'
       AND UPPER(hptf_name) = UPPER(pi_file_type_name)
       AND hptf_file_type_id = hpte_file_type_id
         ;
    --
  EXCEPTION
    WHEN no_data_found
     THEN
        NULL;
    WHEN others
     THEN
        RAISE;
  END get_extensions;
  --  
  PROCEDURE initialise
    IS
  BEGIN
    hig_process_api.log_it(pi_message => 'Polling...');

    l_file_type_rec := hig_process_framework.get_process_type_file(pi_process_type_id  => l_process_rec.hp_process_type_id 
                                                                  ,pi_file_type_name   => pi_file_type_name);
 
    IF l_file_type_rec.hptf_file_type_id IS NULL
     THEN
        l_process_type_rec := hig_process_framework.get_process_type(pi_process_type_id => l_process_rec.hp_process_type_id);

        hig.raise_ner(pi_appl               => 'HIG'
                     ,pi_id                 => 535 -- FILE TYPE FOR THIS PROCESS TYPE DOES NOT EXIST
                     ,pi_supplementary_info => chr(10)||'File Type ['||pi_file_type_name||']'||chr(10)||'Process Type ['||l_process_type_rec.hpt_name||']'); 
    END IF;

    IF l_file_type_rec.hptf_input_destination_type = 'ORACLE_DIRECTORY'
     THEN
        nm3file.check_directory_valid(pi_dir_name        => l_file_type_rec.hptf_input_destination
                                     ,pi_check_delimiter => FALSE);
    END IF;

    l_tab_ftp_connections := hig_process_api.get_conns_for_current_process;

    /*
    ||Build table of extensions
    */
    IF pi_file_mask IS NOT NULL
     THEN
        lt_extensions(1) := pi_file_mask;
    ELSE
        get_extensions;
    END IF;
    --
  END initialise;
  
  PROCEDURE move_files
    IS
  BEGIN
    g_ftp_error := FALSE ;
    IF l_tab_ftp_connections.COUNT > 0
     THEN
        --
        FOR i IN 1..lt_extensions.count LOOP
          hig_process_api.log_it(pi_message => 'Polling for files with extension *.'||lt_extensions(i)||' in '||l_tab_ftp_connections.COUNT||' locations');
        --
          DECLARE
           l_subscript PLS_INTEGER;
           l_error      varchar2(2000);
         
          BEGIN
            l_files:= nm3ftp.ftp_in_to_database(pi_tab_ftp_connections     => l_tab_ftp_connections
                                               ,pi_db_location_to_move_to  => l_file_type_rec.hptf_input_destination
                                               ,pi_file_mask               => lt_extensions(i)
                                               ,pi_binary                  => pi_binary
                                               ,pi_archive_overwrite       => pi_archive_overwrite
                                               ,pi_remove_failed_arch      => pi_remove_failed_arch);
                                               
          EXCEPTION 
           WHEN others THEN
              l_error     := SUBSTR(SQLERRM,1,2000);
              l_subscript := nm3ftp.g_tab_ftp_outcome.COUNT+1;
              --
              nm3ftp.g_tab_ftp_outcome.EXTEND;
              nm3ftp.g_tab_ftp_outcome(l_subscript).ftp_outcome:= 'FAIL';
              nm3ftp.g_tab_ftp_outcome(l_subscript).ftp_outcome_error := l_error;
              --
          END;
          -- TASk 0110084
          -- If any error is raised in the FTP procesing the Process outcome will be set to FAIl and error will be logged.
          FOR i IN 1..nm3ftp.g_tab_ftp_outcome.Count 
          LOOP
              IF nm3ftp.g_tab_ftp_outcome(i).ftp_outcome = 'FAIL'
              THEN
                  g_ftp_error := TRUE ; 
                  hig_process_api.log_it(pi_process_id => hig_process_api.get_current_process_id
                                        ,pi_message    => 'Failed to move the data files due to the following error in FTP processing : '||nm3ftp.g_tab_ftp_outcome(i).ftp_outcome_error
                                        ,pi_message_type => 'E'
                                        ,pi_summary_flag => 'Y' );
                  hig_process_api.process_execution_end('N');   
                  Exit;
              END IF ;
          END LOOP; 
          -- TASk 0110084
          -- Do further processing only if there are no errors in FTP processing
          IF NOT g_ftp_error
          THEN                             
              hig_process_api.log_it(pi_message => l_files.COUNT||' files found');  
              FOR j IN 1..l_files.count LOOP
                lt_all_files(lt_all_files.count+1) := l_files(j);
              END LOOP;
          ELSE
              EXIT;
          END IF ;  
        END LOOP;
    END IF;
  
  END move_files;

  PROCEDURE associate_files IS

    l_tab_files        hig_process_api.tab_temp_files;
    l_file_rec         hig_process_api.rec_temp_files;
    l_process_id       hig_processes.hp_process_id%TYPE;
    l_job_name         hig_processes.hp_job_name%TYPE;
    l_date             date;
  
  BEGIN
  
    IF lt_all_files.COUNT > 0 THEN
        --TASK 0110519 
        --Set the Context flag to indicate this is polling process and has found the file 
        nm3ctx.set_context('HIG_POLLING_PROCESS','Y');

        l_tab_files.DELETE;
        
         FOR f IN 1..lt_all_files.COUNT LOOP
                 
             l_file_rec := Null;
                 
             l_file_rec.filename         := lt_all_files(f);
             l_file_rec.file_type_id     := l_file_type_rec.hptf_file_type_id;
             l_file_rec.I_or_O           := 'I';
             l_file_rec.destination      := l_file_type_rec.hptf_input_destination;
             l_file_rec.destination_type := l_file_type_rec.hptf_input_destination_type;
             l_file_rec.content          := Null;
                 
                 
             l_tab_files(l_tab_files.COUNT+1) := l_file_rec;
                 
         END LOOP;


         hig_process_api.associate_files_with_process(pi_tab_files  => l_tab_files); -- associate all of the files found with this execution of the polling process



         FOR f IN 1..l_tab_files.COUNT LOOP -- spawn a process for each file found and associate the file with the process

                hig_process_api.initialise_temp_files;  
 
                hig_process_api.add_temp_file(pi_rec => l_tab_files(f)) ;
         
         
                         create_and_schedule_process    (pi_process_type_id           => l_process_rec.hp_process_type_id
                                                       , pi_initiators_ref            => l_process_rec.hp_initiators_ref
                                                       , pi_start_date                => sysdate
                                                       , pi_frequency_id              => -1
                                                       , pi_polling_flag              => 'N'
                                                       , pi_area_id                   => l_process_rec.hp_area_id
                                                       , po_process_id                => l_process_id
                                                       , po_job_name                  => l_job_name
                                                       , po_scheduled_start_date      => l_date);
         
                log_it('Spawned process '||hig_process_framework_utils.formatted_process_id(l_process_id)||' for '||l_tab_files(f).filename);
         
         
         END LOOP;


         hig_process_api.log_it(pi_message => 'Polling complete');
         commit;
              
    ELSE
         drop_execution;

    END IF;            
  
  END associate_files;
  
  

  
BEGIN

  l_process_rec           := get_current_process;
  
  IF l_process_rec.hp_polling_flag = 'Y' THEN
                              
    initialise;
  
    move_files;
   -- TASk 0110084
   -- Do further processing only if there are no errors in FTP processing
   IF NOT g_ftp_error
   THEN
       associate_files;
   END If ;
  
  END IF;  
  

  RETURN(l_process_rec.hp_polling_flag != 'Y');

END do_polling_if_requested;
--
-----------------------------------------------------------------------------
--
PROCEDURE stop_process(pi_process_id IN hig_processes.hp_process_id%TYPE
                      ,pi_reason     IN VARCHAR2)
IS
--

--
BEGIN
--
   dbms_scheduler.stop_job(g_job_name_prefix||pi_process_id);
   hig_process_api.log_it(pi_process_id    => pi_process_id
                         ,pi_message       => 'This execution has been terminated by user '||user||' on '||To_Char(Sysdate,'dd-Mon-yyyy hh24:mi:ss')
                         ,pi_message_type  => 'E'  
                         ,pi_summary_flag  => 'Y' );
   IF pi_reason IS NOT NULL
   THEN
       hig_process_api.log_it(pi_process_id    => pi_process_id
                             ,pi_message       => 'Reason to terminate : '||pi_reason
                             ,pi_summary_flag  => 'Y' );
   END IF ;
   hig_process_api.process_execution_end('N');
   nm3ctx.set_context('HP_PROCESS_ID',Null);
   nm3ctx.set_context('HPJR_RUN_SEQ',Null);
--
END stop_process;
--
--
--
FUNCTION  valid_process_of_type_exists(pi_process_type_id IN hig_process_types.hpt_process_type_id%TYPE) RETURN BOOLEAN IS

 l_count pls_integer;
 
BEGIN


 SELECT count(hp_process_type_id)
 INTO l_count
 FROM hig_processes
 WHERE hp_process_type_id = pi_process_type_id
 and exists (select 1
             from dba_scheduler_jobs
             where job_name = hp_job_name
             and state in ('SCHEDULED','RUNNING'));

 RETURN l_count > 0;
 
END  valid_process_of_type_exists;
--
--
--
FUNCTION  valid_process_of_type_exists(pi_process_type_name IN hig_process_types.hpt_name%TYPE) RETURN BOOLEAN IS

BEGIN

 RETURN valid_process_of_type_exists(pi_process_type_id => hig_process_framework.get_process_type(pi_process_type_name => pi_process_type_name).hpt_process_type_id);

END valid_process_of_type_exists;
--
--
--
PROCEDURE valid_process_of_type_exists(pi_process_type_id IN hig_processes.hp_process_type_id%TYPE) IS

 l_hpt_rec hig_process_types%ROWTYPE;

BEGIN


 IF NOT hig_process_api.valid_process_of_type_exists(pi_process_type_id => pi_process_type_id) THEN
 
   l_hpt_rec := hig_process_framework.get_process_type(pi_process_type_id => pi_process_type_id);

   hig.raise_ner(pi_appl => 'HIG'
                 , pi_id => 548 -- 'Application is not configured correctly.'
                 , pi_supplementary_info => 'A '||chr(39)||l_hpt_rec.hpt_name||chr(39)||' process must exist and be valid.');

 END IF;

END valid_process_of_type_exists; 
--
--
--
PROCEDURE valid_process_of_type_exists(pi_process_type_name IN hig_process_types.hpt_name%TYPE) IS

BEGIN

 valid_process_of_type_exists(pi_process_type_id =>  hig_process_framework.get_process_type(pi_process_type_name => pi_process_type_name).hpt_process_type_id);

END valid_process_of_type_exists;
--
-----------------------------------------------------------------------------
--  
FUNCTION get_scheduler_state RETURN VARCHAR2 IS
--
BEGIN
RETURN nm3jobs.get_scheduler_state;
END get_scheduler_state;
--
-----------------------------------------------------------------------------
--
FUNCTION count_running_processes RETURN PLS_INTEGER IS
BEGIN
RETURN nm3jobs.count_running_processes;
END count_running_processes;
--
-----------------------------------------------------------------------------
--
END hig_process_api;
/


