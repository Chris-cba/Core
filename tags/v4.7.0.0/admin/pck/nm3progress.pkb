CREATE OR REPLACE PACKAGE BODY nm3progress AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3progress.pkb-arc   2.2   Jul 04 2013 16:21:10   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3progress.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:21:10  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:18  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.2
-------------------------------------------------------------------------
--
--   Author : Graeme Johnson 
--
-----------------------------------------------------------------------------
--
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
--
-----------------------------------------------------------------------------
--
--  g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid         CONSTANT varchar2(2000) := '$Revision:   2.2  $';
  g_package_name     CONSTANT  varchar2(30)   := 'nm3progress';
  g_progress_counter  PLS_INTEGER; 
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
--
--   Function to get using PRG_UK constraint
--
FUNCTION get (pi_prg_progress_id   NM_PROGRESS.prg_progress_id%TYPE
             ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
             ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
             ) RETURN NM_PROGRESS%ROWTYPE IS
--
   CURSOR cs_prg IS
   SELECT /*+ FIRST_ROWS(1) INDEX(prg PRG_UK) */ 
          prg_progress_id
         ,prg_total_stages
         ,prg_current_stage		  
         ,prg_operation
         ,prg_error_message
         ,prg_total_count
         ,prg_current_position
    FROM  NM_PROGRESS prg
   WHERE  prg.prg_progress_id = pi_prg_progress_id;
--
   l_found  BOOLEAN; 
   l_retval NM_PROGRESS%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get');
--
   OPEN  cs_prg;
   FETCH cs_prg INTO l_retval;
   l_found := cs_prg%FOUND;
   CLOSE cs_prg;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'NM_PROGRESS (PRG_UK)'
                                              ||CHR(10)||'prg_progress_id => '||pi_prg_progress_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get');
--
   RETURN l_retval;
--
END get;
--
-----------------------------------------------------------------------------
--
--
--------------------------------------------------------------------------------
--
FUNCTION get_next_progress_id RETURN PLS_INTEGER IS

 l_retval PLS_INTEGER;

BEGIN

 SELECT prg_id_seq.NEXTVAL
 INTO l_retval
 FROM dual;
 RETURN(l_retval);
 
END get_next_progress_id;
--
--------------------------------------------------------------------------------
--
PROCEDURE initialise_progress(pi_progress_id  IN nm_progress.prg_progress_id%TYPE
                             ,pi_total_stages IN nm_progress.prg_total_stages%TYPE DEFAULT 1) IS

PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN

 g_progress_counter  :=0;

 INSERT INTO nm_progress(prg_progress_id
                        ,prg_total_stages
						,prg_current_stage)
 SELECT pi_progress_id
       ,pi_total_stages
	   ,1
 FROM dual
 WHERE NOT EXISTS (SELECT 'x' FROM nm_progress WHERE prg_progress_id=pi_progress_id);
 
 COMMIT;

END initialise_progress; 
--
--------------------------------------------------------------------------------
--
PROCEDURE record_progress(pi_progress_id      IN nm_progress.prg_progress_id%TYPE
                         ,pi_force            IN BOOLEAN DEFAULT FALSE
						 ,pi_current_stage    IN nm_progress.prg_current_stage%TYPE
                         ,pi_operation        IN nm_progress.prg_operation%TYPE
                         ,pi_total_count      IN nm_progress.prg_total_count%TYPE DEFAULT NULL
                         ,pi_current_position IN nm_progress.prg_current_position%TYPE DEFAULT NULL) IS

					  
PRAGMA AUTONOMOUS_TRANSACTION;
		  
BEGIN

 g_progress_counter := g_progress_counter+1;
 
 IF pi_force OR MOD(g_progress_counter,50) = 0 THEN   

   UPDATE nm_progress
   SET prg_current_stage = pi_current_stage 
      ,prg_operation   = substr(pi_operation,1,100)
	  ,prg_total_count = NVL(pi_total_count,0)
	  ,prg_current_position = NVL(pi_current_position,0)
   WHERE prg_progress_id = pi_progress_id;
 
   COMMIT;
   
 END IF;   	 
 
END record_progress;
--
--------------------------------------------------------------------------------
--
PROCEDURE end_progress(pi_progress_id         IN nm_progress.prg_progress_id%TYPE
                      ,pi_completion_message  IN nm_progress.prg_operation%TYPE
                      ,pi_error_message       IN nm_progress.prg_error_message%TYPE DEFAULT NULL) IS	

PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN

 UPDATE nm_progress
 SET prg_current_stage = -1
    ,prg_operation = substr(pi_completion_message,1,100)
	,prg_error_message = substr(pi_error_message,1,1000)
 WHERE prg_progress_id=pi_progress_id;
 COMMIT;

END end_progress;
--
--------------------------------------------------------------------------------
--
END nm3progress;
/


