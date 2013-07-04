CREATE OR REPLACE PACKAGE BODY higgrirp AS
--   PVCS Identifiers :-
--
--       pvcsid               : $Header:   //vm_latest/archives/nm3/admin/pck/higgrirp.pkb-arc   2.3   Jul 04 2013 15:01:12   James.Wadsworth  $
--       Module Name          : $Workfile:   higgrirp.pkb  $
--       Date into PVCS       : $Date:   Jul 04 2013 15:01:12  $
--       Date fetched Out     : $Modtime:   Jul 04 2013 14:25:06  $
--       PVCS Version         : $Revision:   2.3  $
--       Based on SCCS version : 1.5
--
--   Author :
--
--   suite of functions used by programs/reports to retrieve GRI values
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

/* History
  11.12.07 PT write_gri_spool() rewritten to use a sequence instead of package variable for the grs_line_no
                this proc can now be safely called concurrently from multiple sessios.
                to test for gri_spool presence use gri_spool_exists() as before.
                (use dbms_lock.sleep() to give time to ohter sessions if needed)
*/

  g_body_sccsid            constant  varchar2(200) := '"$Revision:   2.3  $"';
  g_package_name           constant varchar2(30) := 'higgrirp';
  
  c_reports_file_extension CONSTANT varchar2(4) := '.rep';
--
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
  FUNCTION get_module
	(a_job_id	IN	integer
  ) RETURN varchar2 AS

    CURSOR c1 IS
      SELECT grr.grr_module
      FROM   gri_report_runs grr
      WHERE  grr.grr_job_id = a_job_id
      ;
    l_module	gri_report_runs.grr_module%TYPE;

  BEGIN
    OPEN  c1;
    FETCH c1 INTO l_module;
    CLOSE c1;
    RETURN l_module;
  END get_module;

  FUNCTION get_module_title
        (a_module IN hig_modules.hmo_module%TYPE
  ) RETURN varchar2 IS

  CURSOR c1 IS
    SELECT hmo_title
    FROM hig_modules WHERE hmo_module = a_module;

  retval hig_modules.hmo_title%TYPE;

  BEGIN
    OPEN c1;
    FETCH c1 INTO retval;
    CLOSE c1;

    RETURN retval;
  END;

  FUNCTION get_module_parameter
	(a_job_id	IN	integer
	,a_seq		IN	integer
  ) RETURN varchar2 AS

    CURSOR c1 IS
      SELECT gmp.gmp_param
      FROM   gri_report_runs grr
      ,      gri_module_params gmp
      WHERE  gmp.gmp_module = grr.grr_module
      AND    grr.grr_job_id = a_job_id
      AND    gmp.gmp_seq    = a_seq
      ;
    l_param	gri_module_params.gmp_param%TYPE;

  BEGIN
    OPEN  c1;
    FETCH c1 INTO l_param;
    CLOSE c1;
    RETURN l_param;
  END get_module_parameter;

  FUNCTION get_module_param_descr
	(a_job_id	IN	integer
	,a_param	IN	varchar2
	,a_length	IN	number	DEFAULT 30
  ) RETURN varchar2 AS

    CURSOR c1 IS
      SELECT gmp.gmp_param_descr
      FROM   gri_report_runs grr
      ,      gri_module_params gmp
      WHERE  gmp.gmp_module = grr.grr_module
      AND    gmp.gmp_param  = a_param
      AND    grr.grr_job_id = a_job_id
      ;
    l_param_descr	gri_module_params.gmp_param_descr%TYPE;

  BEGIN
    OPEN  c1;
    FETCH c1 INTO l_param_descr;
    CLOSE c1;
    RETURN RPAD( l_param_descr ,a_length)||' : ';
  END get_module_param_descr;

  FUNCTION get_module_linesize
	(a_job_id	IN	integer
  ) RETURN number AS

    CURSOR c1 IS
      SELECT grm.grm_linesize
      FROM   gri_report_runs grr
      ,      gri_modules grm
      WHERE  grm.grm_module = grr.grr_module
      AND    grr.grr_job_id = a_job_id
      ;
    l_linesize	gri_modules.grm_linesize%TYPE;

  BEGIN
    OPEN  c1;
    FETCH c1 INTO l_linesize;
    CLOSE c1;
    RETURN l_linesize;
  END get_module_linesize;

  FUNCTION get_module_pagesize
	(a_job_id	IN	integer
  ) RETURN number AS

    CURSOR c1 IS
      SELECT grm.grm_pagesize
      FROM   gri_report_runs grr
      ,      gri_modules grm
      WHERE  grm.grm_module = grr.grr_module
      AND    grr.grr_job_id = a_job_id
      ;
    l_pagesize	gri_modules.grm_pagesize%TYPE;

  BEGIN
    OPEN  c1;
    FETCH c1 INTO l_pagesize;
    CLOSE c1;
    RETURN l_pagesize;
  END get_module_pagesize;

  FUNCTION get_module_spoolpath
	(a_job_id	IN	integer,
         a_username     IN      varchar2
  ) RETURN varchar2 AS

   CURSOR c1 IS
     SELECT hmo_module_type
     FROM hig_modules, gri_report_runs
     WHERE grr_module = hmo_module
     AND   grr_job_id = a_job_id;

   CURSOR c2( c_op_id IN varchar2 ) IS
     SELECT huo_value
     FROM hig_users, hig_user_options
     WHERE huo_hus_user_id = hus_user_id
     AND huo_id = c_op_id
     AND hus_username = a_username;

   CURSOR c3 IS
     SELECT hop_value
     FROM hig_options
     WHERE hop_id = 'DIRSEPSTRN';

     dir_sep       hig_options.hop_value%TYPE;
     mod_type      hig_modules.hmo_module_type%TYPE;
     localsql_flag hig_user_options.huo_value%TYPE;
     retval        hig_user_options.huo_value%TYPE := NULL;

  BEGIN
    OPEN c1;
    FETCH c1 INTO mod_type;
    CLOSE c1;
--
-- We need the mod type since if it a SVR module it will always use the server output path.
-- If it is a SQL script then it may be on the client or the server and further investigation
-- is required. Allow FMX to be treated as SQL
--
   IF mod_type IN ( 'SQL', 'FMX' ) THEN
      OPEN c2( 'REPSQLPLUS' );
      FETCH c2 INTO localsql_flag;
      IF c2%FOUND THEN
--
--      Hence module is sql and is executed locally, use the client path.
--
	CLOSE c2;
	OPEN c2( 'REPCLIPATH');
	FETCH c2 INTO retval;
      END IF;
      CLOSE c2;
    END IF;

--
--  If the module is not sql or if no client path exists or is sql but executed on the server
--  we need to return the server output path.
--
    IF retval IS NULL THEN
       OPEN c2( 'REPOUTPATH' );
       FETCH c2 INTO retval;
       CLOSE c2;

       OPEN c3;
       FETCH c3 INTO dir_sep;
       CLOSE c3;

       retval := retval||dir_sep;
    END IF;

    RETURN retval;
END;


  FUNCTION get_module_spoolfile
	(a_job_id	IN	integer
  ) RETURN varchar2 AS

    CURSOR c1 IS
      SELECT grm.grm_file_type
      FROM   gri_report_runs grr
      ,      gri_modules grm
      WHERE  grm.grm_module = grr.grr_module
      AND    grr.grr_job_id = a_job_id
      ;
    l_file_type		gri_modules.grm_file_type%TYPE;

  BEGIN
    OPEN  c1;
    FETCH c1 INTO l_file_type;
    CLOSE c1;
    RETURN TO_CHAR( a_job_id)||'.'||l_file_type;
  END get_module_spoolfile;

  PROCEDURE get_parameter
	(a_job_id	IN	integer
	,a_param	IN	varchar2
	,a_value	IN OUT	varchar2
	,a_descr	IN OUT	varchar2
	,a_shown	IN OUT	varchar2
  ) AS

    CURSOR c1 IS
      SELECT grp.grp_value
      ,      grp.grp_descr
      ,      grp.grp_shown
      FROM   gri_run_parameters grp
      WHERE  grp.grp_job_id = a_job_id
      AND    grp.grp_param  = a_param
      ;

  BEGIN
    OPEN  c1;
    FETCH c1 INTO a_value ,a_descr ,a_shown;
    CLOSE c1;
  END get_parameter;

  FUNCTION get_parameter_value
	(a_job_id	IN	integer
	,a_param	IN	varchar2
  ) RETURN varchar2 AS

    CURSOR c1 IS
      SELECT grp.grp_value
      FROM   gri_run_parameters grp
      WHERE  grp.grp_job_id = a_job_id
      AND    grp.grp_param  = a_param
      ;
    l_value	gri_run_parameters.grp_value%TYPE;

  BEGIN
    OPEN  c1;
    FETCH c1 INTO l_value;
    CLOSE c1;
    RETURN l_value;
  END get_parameter_value;

  FUNCTION get_parameter_shown
	(a_job_id	IN	integer
	,a_param	IN	varchar2
  ) RETURN varchar2 AS

    CURSOR c1 IS
      SELECT grp.grp_shown
      FROM   gri_run_parameters grp
      WHERE  grp.grp_job_id = a_job_id
      AND    grp.grp_param  = a_param
      ;
    l_shown	gri_run_parameters.grp_shown%TYPE;

  BEGIN
    OPEN  c1;
    FETCH c1 INTO l_shown;
    CLOSE c1;
    RETURN l_shown;
  END get_parameter_shown;

  FUNCTION get_parameter_descr
	(a_job_id	IN	integer
	,a_param	IN	varchar2
  ) RETURN varchar2 AS

    CURSOR c1 IS
      SELECT grp.grp_descr
      FROM   gri_run_parameters grp
      WHERE  grp.grp_job_id = a_job_id
      AND    grp.grp_param  = a_param
      ;
    l_descr	gri_run_parameters.grp_descr%TYPE;

  BEGIN
    OPEN  c1;
    FETCH c1 INTO l_descr;
    CLOSE c1;
    RETURN l_descr;
  END get_parameter_descr;

  FUNCTION get_selection_criteria
	(a_job_id	IN	integer
	,a_param	IN	varchar2
  ) RETURN varchar2 AS

    CURSOR c1 IS
      SELECT gmp.gmp_param_descr
      ,      grp.grp_shown
      ,      grp.grp_descr
      FROM   gri_report_runs grr
      ,      gri_module_params gmp
      ,      gri_run_parameters grp
      WHERE  gmp.gmp_module = grr.grr_module
      AND    grp.grp_job_id = grr.grr_job_id
      AND    gmp.gmp_param  = grp.grp_param
      AND    grr.grr_job_id = a_job_id
      AND    gmp.gmp_param  = a_param
      ;
    l_linesize		gri_modules.grm_linesize%TYPE;
    l_param_descr	gri_module_params.gmp_param_descr%TYPE;
    l_shown		gri_run_parameters.grp_shown%TYPE;
    l_descr		gri_run_parameters.grp_descr%TYPE;
    l_length		number DEFAULT 30;

  BEGIN
    l_linesize := get_module_linesize( a_job_id);
    OPEN  c1;
    FETCH c1 INTO l_param_descr ,l_shown ,l_descr;
    CLOSE c1;
    RETURN RPAD( l_param_descr ,l_length)||' : '||l_shown||'  '||l_descr;
  END get_selection_criteria;
  
  PROCEDURE init_rpt ( p_module IN  gri_modules.grm_module%TYPE
		   , p_user   OUT varchar2
		   , p_client OUT nm_admin_units.nau_name%TYPE
		   , p_title  OUT hig_modules.hmo_title%TYPE ) IS    
    --
    CURSOR c_get_name
    IS
    SELECT hau_name
    FROM hig_admin_units,
               hig_users
    WHERE hus_admin_unit  = hau_admin_unit
    AND hus_username = Sys_Context('NM3_SECURITY_CTX','USERNAME');
    --
    CURSOR c_get_module
    IS
    SELECT hmo_title
    FROM hig_modules,
         gri_modules
    WHERE UPPER (grm_module) = UPPER (p_module)
    AND hmo_module = grm_module;
    --
  BEGIN
    --
    p_user:=Sys_Context('NM3_SECURITY_CTX','USERNAME');
    --
    OPEN c_get_name;
    FETCH c_get_name INTO p_client;
    CLOSE c_get_name;
    --
    OPEN c_get_module;
    FETCH c_get_module INTO p_title;
    CLOSE c_get_module;
  --
  END;  	/* End of procedure INIT_RPT */
  
  
  -- PT write_gri_spool rewritten to use a sequence instead of package variable for the grs_line_no
  procedure write_gri_spool(
     a_job_id in integer
    ,a_message in varchar2
  )
  is
    --l_line_no gri_spool.grs_line_no%type;
    pragma autonomous_transaction;
    
  begin
    insert into gri_spool (
       grs_job_id, grs_line_no, grs_text
    )
    values (
      a_job_id, grs_line_no_seq.nextval, a_message
    )
    returning grs_line_no into higgrirp.grs_line_no;
    commit;
  
  exception
    when others then
      rollback;
      raise;
      
  end;
    
-----------------------------------------------------------------------------
--
FUNCTION gri_spool_exists(pi_job_id IN gri_spool.grs_job_id%TYPE) RETURN BOOLEAN IS

 CURSOR c1 IS
 SELECT 'x'
 FROM   gri_spool
 WHERE  grs_job_id = pi_job_id;
 
 v_dummy VARCHAR2(1) := Null;


BEGIN

 OPEN c1;
 FETCH c1 INTO v_dummy;
 CLOSE c1;
 
 IF v_dummy IS NOT NULL THEN
    RETURN(TRUE);
 ELSE
    RETURN(FALSE);
 END IF;

END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_reports_file_extension RETURN varchar2 IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_reports_file_extension');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_reports_file_extension');

  RETURN c_reports_file_extension;

END get_reports_file_extension;
--
-----------------------------------------------------------------------------
--
END higgrirp;
/

