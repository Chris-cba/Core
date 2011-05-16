CREATE OR REPLACE PACKAGE BODY nm3jobs AS 

--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3jobs.pkb-arc   3.12   May 16 2011 14:44:58   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3jobs.pkb  $
--       Date into PVCS   : $Date:   May 16 2011 14:44:58  $
--       Date fetched Out : $Modtime:   May 05 2011 09:25:18  $
--       PVCS Version     : $Revision:   3.12  $
--
--   NM3 DBMS_SCHEDULER wrapper
--
--   Author : Adrian Edwards
--
--
--------------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid          CONSTANT VARCHAR2(2000) :='"$Revision:   3.12  $"';
  g_package_name         CONSTANT VARCHAR2(30)   := 'nm3jobs';
  ex_resource_busy                EXCEPTION;
  g_default_comment               VARCHAR2(500)  := 'Created by nm3job ';
  g_args                          nm3type.tab_varchar32767;
--  ORA-00054: resource busy and acquire with NOWAIT specified
  PRAGMA                          EXCEPTION_INIT(ex_resource_busy,-54);
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
  PROCEDURE instantiate_args
  IS
  BEGIN
    g_args.DELETE;
  END instantiate_args;
--
-----------------------------------------------------------------------------
--
-- 
  PROCEDURE add_arg ( pi_arg IN VARCHAR )
  IS
  BEGIN
    IF pi_arg IS NOT NULL
    THEN
      g_args(g_args.COUNT+1) := pi_arg;
    END IF;
  END add_arg;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_job_error ( pi_job_name IN VARCHAR2 )
  RETURN VARCHAR2
  IS
    retval nm3type.max_varchar2;
  BEGIN
    SELECT SUBSTR ( additional_info,
                (INSTR(additional_info,'STANDARD_ERROR')+LENGTH('STANDARD_ERROR')+1),
                (LENGTH(additional_info)-INSTR(additional_info,'STANDARD_ERROR'))
              ) job_error
    INTO retval
    FROM dba_scheduler_job_run_details
   WHERE log_id = (SELECT MAX(log_id) 
                     FROM dba_scheduler_job_run_details
                    WHERE job_name = pi_job_name
                      AND owner = Sys_Context('NM3_SECURITY_CTX','USERNAME'));
    RETURN retval;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN NULL;
  END get_job_error;
--
--------------------------------------------------------------------------------
--
  PROCEDURE create_job
              ( pi_job_name        IN VARCHAR2
              , pi_job_action      IN VARCHAR2
              , pi_job_owner       IN VARCHAR2  DEFAULT Sys_Context('NM3_SECURITY_CTX','USERNAME')
              , pi_repeat_interval IN VARCHAR2  DEFAULT g_midnight
              , pi_comments        IN VARCHAR2  DEFAULT NULL
              , pi_job_type        IN VARCHAR2  DEFAULT 'PLSQL_BLOCK'
              , pi_start_date      IN TIMESTAMP DEFAULT SYSTIMESTAMP
              , pi_end_date        IN TIMESTAMP DEFAULT NULL
              , pi_enabled         IN BOOLEAN   DEFAULT TRUE 
              , pi_auto_drop       IN BOOLEAN   DEFAULT TRUE 
              , pi_run_synchro     IN BOOLEAN   DEFAULT TRUE)
  IS
    l_arg_count NUMBER := g_args.COUNT;
    no_create_job    EXCEPTION;
    no_create_ex_job EXCEPTION;
    scheduler_down   EXCEPTION;
    
  BEGIN
  --
     IF get_scheduler_state != 'UP'
     THEN
       RAISE scheduler_down;
     END IF;
     --
     IF NOT nm3user.user_has_priv(pi_priv => 'CREATE JOB') THEN
       RAISE no_create_job;
     END IF;
     --
     IF pi_job_type = 'EXECUTABLE' AND NOT nm3user.user_has_priv(pi_priv => 'CREATE EXTERNAL JOB') THEN
       RAISE no_create_ex_job;
     END IF;  

    IF l_arg_count = 0
    THEN
    --
      dbms_scheduler.create_job 
         ( 
           job_name        => pi_job_owner||'.'||pi_job_name
         , job_type        => pi_job_type
         , job_action      => pi_job_action
         , start_date      => pi_start_date
         , repeat_interval => pi_repeat_interval
         , end_date        => pi_end_date
         , enabled         => pi_enabled
         , auto_drop       => pi_auto_drop
         , comments        => NVL(pi_comments,g_default_comment
                                           ||' at '||SYSDATE
                                           ||' for '||pi_job_owner )
          );
    ELSE
    --
       dbms_scheduler.create_job
         ( job_name            => pi_job_owner||'.'||pi_job_name
         , job_type            => pi_job_type
         , job_action          => pi_job_action
         , number_of_arguments => l_arg_count
         , start_date          => pi_start_date
         , repeat_interval     => pi_repeat_interval
         , end_date            => pi_end_date
         , job_class           => 'DEFAULT_JOB_CLASS'
         , enabled             => FALSE
         , auto_drop           => pi_auto_drop
         , comments            => NVL(pi_comments,g_default_comment
                                           ||' at '||SYSDATE
                                           ||' for '||pi_job_owner )
         );
    --
      FOR args IN 1..g_args.COUNT
      LOOP
    --
        dbms_scheduler.set_job_argument_value 
          ( job_name            => pi_job_owner||'.'||pi_job_name
          , argument_position   => args
          , argument_value      => g_args(args));
    --
      END LOOP;
    --
      IF pi_enabled
      THEN
      --  CWS 0109403 Change made to use nm3jobs.run_job as this has extra error trapping.
      --dbms_scheduler.run_job
        nm3jobs.run_job
          ( pi_job_name            => pi_job_owner||'.'||pi_job_name
          , pi_use_current_session => pi_run_synchro);
      --
      END IF;
    --
    END IF;
  --
    instantiate_args;
  --
  EXCEPTION
    WHEN scheduler_down
    THEN 
      hig.raise_ner( pi_appl => 'HIG'
                    , pi_id   => 555
                    );
    --
    WHEN no_create_job
    THEN 
          hig.raise_ner(pi_appl => 'HIG'
                   ,pi_id   => 126
                   ,pi_supplementary_info => 'Create Job'); -- You do not have privileges to perform this action
    --
    WHEN no_create_ex_job
    THEN 
    hig.raise_ner(pi_appl => 'HIG'
                   ,pi_id   => 126
                   ,pi_supplementary_info => 'Create External Job'); -- You do not have privileges to perform this action
    --
    WHEN OTHERS 
      THEN
      instantiate_args;
      hig.raise_ner(pi_appl               => 'NET'
                   ,pi_id                 => 28
                   ,pi_supplementary_info => NVL(get_job_error(pi_job_name),SQLERRM));
  END create_job;
--
-----------------------------------------------------------------------------
--
-- Run a job immediately
--
  PROCEDURE run_job ( pi_job_name            IN VARCHAR2
                    , pi_use_current_session IN BOOLEAN DEFAULT TRUE )
  IS 
  -- CWS 0109403 When Process framework is down give the user a sensible error.
  ex_scheduler_down EXCEPTION;
  PRAGMA EXCEPTION_INIT(ex_scheduler_down, -27492);
  --
  BEGIN
    dbms_scheduler.run_job
        ( job_name            => pi_job_name
        , use_current_session => pi_use_current_session);
  EXCEPTION
  WHEN ex_scheduler_down THEN
  --
  IF nm3jobs.get_scheduler_state = 'UP' 
  THEN 
    hig.raise_ner( pi_appl => 'HIG'
                 , pi_id   => 556
                 , pi_supplementary_info => nm3flx.parse_error_message(SQLERRM)
                 );
  ELSE
    hig.raise_ner( pi_appl => 'HIG'
                 , pi_id   => 555
                 );
  END IF;
  --
  WHEN OTHERS THEN
  --
    hig.raise_ner( pi_appl => 'HIG'
                 , pi_id   => 556
                 , pi_supplementary_info => nm3flx.parse_error_message(SQLERRM)
                 );
  --
  END run_job;
--
-----------------------------------------------------------------------------
--
-- Run a job immediately
--
  PROCEDURE stop_job ( pi_job_name IN VARCHAR2
                     , pi_force    IN BOOLEAN DEFAULT FALSE)
  IS
  BEGIN
    dbms_scheduler.stop_job
        ( job_name => pi_job_name 
        , force    => pi_force );
  END stop_job;
--
-----------------------------------------------------------------------------
--
-- Drop a job
--
  PROCEDURE drop_job ( pi_job_name IN VARCHAR2
                     , pi_force    IN BOOLEAN DEFAULT FALSE)
  IS
  BEGIN
    dbms_scheduler.drop_job
        ( job_name => pi_job_name
        , force    => pi_force );
  END drop_job;
--
-----------------------------------------------------------------------------
--
PROCEDURE disable_job (pi_job_name IN VARCHAR2
                     , pi_force    IN BOOLEAN DEFAULT FALSE) IS
                     
BEGIN

  dbms_scheduler.disable(name  => pi_job_name
                           ,force  => pi_force);

END disable_job;
--
-----------------------------------------------------------------------------
--
PROCEDURE enable_job (pi_job_name IN VARCHAR2) IS
                     
BEGIN

  dbms_scheduler.enable(name  => pi_job_name);

END enable_job;
--
-----------------------------------------------------------------------------
--
PROCEDURE amend_job_start_datim (pi_job_name IN VARCHAR2 
                                ,pi_value    IN DATE) IS
                     
BEGIN


 DBMS_SCHEDULER.SET_ATTRIBUTE(name      => pi_job_name
                                 ,attribute => 'start_date'
                                 ,value     => pi_value);

                                
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE amend_job_interval (pi_job_name IN VARCHAR2 
                             ,pi_value    IN VARCHAR2) IS
                     
BEGIN

 DBMS_SCHEDULER.SET_ATTRIBUTE(name      => pi_job_name
                                 ,attribute => 'repeat_interval'
                                 ,value     => pi_value);
                                 
END amend_job_interval;                                  
--
-----------------------------------------------------------------------------
--
PROCEDURE amend_job_action (pi_job_name IN VARCHAR2 
                           ,pi_value    IN VARCHAR2) IS
                     
BEGIN

 DBMS_SCHEDULER.SET_ATTRIBUTE(name      => pi_job_name
                                 ,attribute => 'job_action'
                                 ,value     => pi_value);
                                 
END amend_job_action;
--
-----------------------------------------------------------------------------
--
PROCEDURE amend_job_restartable (pi_job_name    IN VARCHAR2 
                                ,pi_value       IN BOOLEAN) IS
                     
BEGIN

 DBMS_SCHEDULER.SET_ATTRIBUTE(name      => pi_job_name
                                 ,attribute => 'restartable'
                                 ,value     => pi_value);
                                 
END amend_job_restartable;
--
-----------------------------------------------------------------------------
--
PROCEDURE amend_job_max_failures (pi_job_name    IN VARCHAR2 
                                 ,pi_value       IN NUMBER) IS
                     
BEGIN

 DBMS_SCHEDULER.SET_ATTRIBUTE(name      => pi_job_name
                                 ,attribute => 'max_failures'
                                 ,value     => pi_value);
                                 
END amend_job_max_failures;
--
-----------------------------------------------------------------------------
--
PROCEDURE purge_log(
  log_history        IN PLS_INTEGER DEFAULT 0,
  which_log          IN VARCHAR2    DEFAULT 'JOB_AND_WINDOW_LOG',
  job_name           IN VARCHAR2    DEFAULT NULL) IS
  
BEGIN

 dbms_scheduler.purge_log(log_history    => log_history
                             ,which_log      => which_log
                             ,job_name       => job_name); 

END purge_log;
--
-----------------------------------------------------------------------------
--
FUNCTION evaluate_calendar_string(pi_calendar_string   IN VARCHAR2
                                 ,pi_start_date        IN  DATE DEFAULT SYSDATE
                                 ,pi_return_date_after IN  DATE DEFAULT SYSDATE
                                 ) RETURN DATE IS



 l_timestamp timestamp;

BEGIN

-- Repeat intervals of jobs, windows or schedules are defined using the
-- scheduler's calendar syntax. This procedure evaluates the calendar string
-- and tells you what the next execution date of a job or window will be. This
-- is very useful for testing the correct definition of the calendar string
-- without having to actually schedule the job or window.
--
-- Parameters
-- calendar_string    The to be evaluated calendar string.
-- start_date         The date by which the calendar string becomes valid.
--                    It might also be used to fill in specific items that are
--                    missing from the calendar string. Can optionally be NULL.
-- return_date_after  With the start_date and the calendar string the scheduler
--                    has sufficient information to determine all valid
--                    execution dates. By setting this argument the scheduler
--                    determines which one of all possible matches to return.
--                    When a NULL value is passed for this argument the
--                    scheduler automatically fills in systimestamp as its
--                    value.
-- next_run_date      The first timestamp that matches the calendar string and
--                    start date that occurs after the value passed in for the
--                    return_date_after argument.

 dbms_scheduler.evaluate_calendar_string(
                                               calendar_string    => pi_calendar_string
                                              ,start_date         => TO_TIMESTAMP(to_char(pi_start_date,'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS')
                                              ,return_date_after  => TO_TIMESTAMP(to_char(pi_return_date_after,'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS')
                                              ,next_run_date      => l_timestamp);

 l_timestamp :=  NVL(l_timestamp
                    ,TO_TIMESTAMP(to_char(pi_start_date,'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS')
                    );
                    
 RETURN (cast (l_timestamp as date));                    
                                              
END evaluate_calendar_string;                                               
--
-----------------------------------------------------------------------------
--             
PROCEDURE calendar_string_is_valid(pi_calendar_string  IN VARCHAR2
                                  ,po_is_valid         OUT BOOLEAN
                                  ,po_frequency        OUT PLS_INTEGER
                                  ,po_interval         OUT PLS_INTEGER
                                  ,po_bysecond         OUT dbms_scheduler.BYLIST
                                  ,po_byminute         OUT dbms_scheduler.BYLIST
                                  ,po_byhour           OUT dbms_scheduler.BYLIST
                                  ,po_byday_days       OUT dbms_scheduler.BYLIST
                                  ,po_byday_occurrence OUT dbms_scheduler.BYLIST
                                  ,po_bymonthday       OUT dbms_scheduler.BYLIST
                                  ,po_byyearday        OUT dbms_scheduler.BYLIST
                                  ,po_byweekno         OUT dbms_scheduler.BYLIST
                                  ,po_bymonth          OUT dbms_scheduler.BYLIST                                  
                                  ) IS

BEGIN

 po_is_valid := FALSE;

    dbms_scheduler.resolve_calendar_string(
                                                    calendar_string  => pi_calendar_string
                                                   ,frequency        => po_frequency 
                                                   ,interval         => po_interval 
                                                   ,bysecond         => po_bysecond 
                                                   ,byminute         => po_byminute 
                                                   ,byhour           => po_byhour 
                                                   ,byday_days       => po_byday_days 
                                                   ,byday_occurrence => po_byday_occurrence 
                                                   ,bymonthday       => po_bymonthday 
                                                   ,byyearday        => po_byyearday 
                                                   ,byweekno         => po_byweekno 
                                                   ,bymonth          => po_bymonth
                                                );
                                            
 po_is_valid := TRUE;
 
EXCEPTION

 WHEN others THEN
 
 
  po_is_valid := FALSE;                                                                                             
  po_frequency        := Null;
  po_interval         := Null;
  po_bysecond         := Null;
  po_byminute         := Null;
  po_byhour           := Null;
  po_byday_days       := Null;
  po_byday_occurrence := Null;
  po_bymonthday       := Null;
  po_byyearday        := Null;
  po_byweekno         := Null;
  po_bymonth          := Null;

END calendar_string_is_valid;
--
-----------------------------------------------------------------------------
--
FUNCTION calendar_string_is_valid(pi_calendar_string  IN VARCHAR2) RETURN BOOLEAN IS

 l_retval boolean;
 l_frequency pls_integer;
 l_interval  pls_integer;
 
 
 l_bysecond         dbms_scheduler.BYLIST;
 l_byminute         dbms_scheduler.BYLIST;
 l_byhour           dbms_scheduler.BYLIST;
 l_byday_days       dbms_scheduler.BYLIST;
 l_byday_occurrence dbms_scheduler.BYLIST;
 l_bymonthday       dbms_scheduler.BYLIST;
 l_byyearday        dbms_scheduler.BYLIST;
 l_byweekno         dbms_scheduler.BYLIST;
 l_bymonth          dbms_scheduler.BYLIST;  

BEGIN


  calendar_string_is_valid(pi_calendar_string  => pi_calendar_string
                          ,po_is_valid         => l_retval
                          ,po_frequency        => l_frequency
                          ,po_interval         => l_interval
                          ,po_bysecond         => l_bysecond
                          ,po_byminute         => l_byminute
                          ,po_byhour           => l_byhour
                          ,po_byday_days       => l_byday_days
                          ,po_byday_occurrence => l_byday_occurrence
                          ,po_bymonthday       => l_bymonthday
                          ,po_byyearday        => l_byyearday
                          ,po_byweekno         => l_byweekno
                          ,po_bymonth          => l_bymonth);                            

  RETURN(l_retval);

END calendar_string_is_valid;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_calendar_string(pi_calendar_string  IN VARCHAR2) IS

BEGIN


 IF NOT calendar_string_is_valid(pi_calendar_string => pi_calendar_string) THEN
 
      hig.raise_ner(pi_appl               => 'HIG'
                   ,pi_id                 => 515 -- Invalid frequency
                   ,pi_supplementary_info => chr(10)||pi_calendar_string  ); 
 END IF;  

END validate_calendar_string;
--
-----------------------------------------------------------------------------
--     
FUNCTION calendar_string_in_mins(pi_calendar_string  IN VARCHAR2) RETURN PLS_INTEGER IS


 l_bool boolean;
 l_frequency pls_integer;
 l_interval  pls_integer;
 l_bysecond         dbms_scheduler.BYLIST;
 l_byminute         dbms_scheduler.BYLIST;
 l_byhour           dbms_scheduler.BYLIST;
 l_byday_days       dbms_scheduler.BYLIST;
 l_byday_occurrence dbms_scheduler.BYLIST;
 l_bymonthday       dbms_scheduler.BYLIST;
 l_byyearday        dbms_scheduler.BYLIST;
 l_byweekno         dbms_scheduler.BYLIST;
 l_bymonth          dbms_scheduler.BYLIST;
 
 l_retval pls_integer := Null;  
 
BEGIN


  calendar_string_is_valid(pi_calendar_string  => pi_calendar_string
                          ,po_is_valid         => l_bool
                          ,po_frequency        => l_frequency
                          ,po_interval         => l_interval
                          ,po_bysecond         => l_bysecond
                          ,po_byminute         => l_byminute
                          ,po_byhour           => l_byhour
                          ,po_byday_days       => l_byday_days
                          ,po_byday_occurrence => l_byday_occurrence
                          ,po_bymonthday       => l_bymonthday
                          ,po_byyearday        => l_byyearday
                          ,po_byweekno         => l_byweekno
                          ,po_bymonth          => l_bymonth                          
                          ); 


--
-- only treat this as a "pure" minutely interval if there is no fancy criteria 
--
 IF  l_bysecond IS NULL 
 AND l_byminute IS NULL 
 AND l_byhour IS NULL 
 AND l_byday_days IS NULL 
 AND l_byday_occurrence IS NULL 
 AND l_bymonthday IS NULL 
 AND l_byyearday IS NULL 
 AND l_byweekno IS NULL 
 AND l_bymonth IS NULL THEN   

 
      IF l_frequency = dbms_scheduler.minutely THEN
        l_retval := l_interval;
--      ELSIF l_frequency = dbms_scheduler.Hourly THEN
--        l_retval := l_interval*60;
      END IF;
      
 END IF;      
  
 RETURN l_retval; 
 
EXCEPTION
  WHEN others THEN 
    RETURN (Null);

END calendar_string_in_mins;
--
-----------------------------------------------------------------------------
--
FUNCTION count_running_processes RETURN PLS_INTEGER IS
--
 l_retval pls_integer;
--
BEGIN
--
 SELECT COUNT(*)
 INTO l_retval
 FROM hig_processes a,
      dba_scheduler_jobs b,
      hig_users c
 WHERE a.hp_job_name = b.job_name
 AND   b.owner = c.hus_username
 AND   b.state = 'RUNNING';
   
 return (l_retval);

END count_running_processes;
--
-----------------------------------------------------------------------------
--  
FUNCTION get_scheduler_state RETURN VARCHAR2 IS

  l_scheduler_disabled dba_scheduler_global_attribute.value%TYPE;
  l_retval             varchar2(20);
--
BEGIN
--
 select value
 into l_scheduler_disabled 
 from dba_scheduler_global_attribute 
 where attribute_name='SCHEDULER_DISABLED';

 IF NVL(l_scheduler_disabled,'FALSE') = 'TRUE' THEN
 
   IF count_running_processes = 0 THEN
      l_retval := 'DOWN';
   ELSE
      l_retval := 'SHUTTING DOWN';
   END IF;
   
 ELSE
 
  l_retval := 'UP';  
         
 END IF;

 RETURN l_retval;

EXCEPTION
  WHEN no_data_found THEN
     RETURN('UP');
  WHEN others THEN
     RAISE;
--
END get_scheduler_state;
--
-----------------------------------------------------------------------------
--
END nm3jobs;
/