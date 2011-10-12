CREATE OR REPLACE PACKAGE BODY hig AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/hig.pkb-arc   2.5.1.0   Oct 12 2011 11:59:18   Steve.Cooper  $
--       Module Name      : $Workfile:   hig.pkb  $
--       Date into SCCS   : $Date:   Oct 12 2011 11:59:18  $
--       Date fetched Out : $Modtime:   Oct 12 2011 10:56:52  $
--       SCCS Version     : $Revision:   2.5.1.0  $
--       Based on 1.39
--
--
--   Author :
--
--   HIGHWAYS application generic utilities package
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
  g_body_sccsid	CONSTANT	varchar2(2000) := '"@(#)hig.pkb	1.39 08/16/06"';
-- g_body_sccsid is the SCCS_ID of the package body

  g_package_name CONSTANT varchar2(30) := 'hig';

  g_hig_exception EXCEPTION;

  g_hig_exc_code  number;
  g_hig_exc_msg   varchar2(2000);

    CURSOR c_start_day(sdate date) IS
    SELECT TO_NUMBER(TO_CHAR( sdate, 'D' ))
    FROM dual;

    CURSOR c_interval( p_date date, p_int_code varchar2) IS
    SELECT ADD_MONTHS(
                   p_date+NVL(int_days,0)+NVL(int_hrs/24,0),
                  (NVL(int_months,0)+NVL(int_yrs*12,0)))
    FROM intervals
    WHERE int_code = p_int_code;

    CURSOR c_holidays( c_start_date date, c_end_date date ) IS
    SELECT COUNT(*) FROM hig_holidays
    WHERE hho_id BETWEEN c_start_date AND c_end_date;


FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
 -----------------------------------------------------------------------------
  -- Procedure to set the product
  --
  PROCEDURE set_product
        ( a_product             IN      varchar2
  ) AS
  BEGIN
   g_product := a_product;
  END set_product;
  -----------------------------------------------------------------------------
  -- Procedure to get the product
  --
  PROCEDURE get_product
        ( a_product             OUT      varchar2
  ) AS
  BEGIN
   a_product := g_product;
  END get_product;

  -----------------------------------------------------------------------------
  FUNCTION get_application_owner_id RETURN number IS
    CURSOR c1 IS
	  SELECT
	    hus_user_id
	  FROM
	    hig_users
	  WHERE
	    hus_username = Sys_Context('NM3CORE','APPLICATION_OWNER');

	retval number;
  BEGIN
    OPEN c1;
	  FETCH c1 INTO retval;
	CLOSE c1;

	RETURN retval;
  END get_application_owner_id;

  -----------------------------------------------------------------------------
  FUNCTION get_file_name   ( p_module  IN varchar2 )
	  RETURN varchar2 IS
  CURSOR c1 IS
    SELECT hmo_filename
    FROM hig_modules
    WHERE hmo_module = UPPER(p_module);

  retval hig_modules.hmo_filename%TYPE;

  BEGIN
    OPEN c1;
    FETCH c1 INTO retval;
    IF c1%NOTFOUND THEN
       retval := NULL;
    END IF;
    CLOSE c1;

    RETURN retval;
  END;
  -----------------------------------------------------------------------------

  FUNCTION work_days( sday IN number, ndays IN number)
           RETURN number IS

  ldays  number(2);
  istart number(2);
  iend   number(2);
  iday   number(2);
  day_string varchar2(10);
  --
  BEGIN
  --
    ldays := ndays;
  --
    day_string := get_sysopt('WEEKEND');
    IF day_string IS NULL THEN
       NULL;
    ELSE
  --
       istart := 1;
       iend   := INSTR( day_string, ',' )-1;
       IF iend < 0 THEN
          iend := LENGTH( day_string );
       END IF;
  --
  <<loop_start>>
  --
       iday := TO_NUMBER( SUBSTR( day_string, istart, iend ));
  --
       IF iday < sday THEN
          IF iday + 7 <= sday + ldays + 1 THEN
             ldays := ldays + 1;
          END IF;
       ELSIF iday > sday THEN
          IF iday <= sday + ldays THEN
             ldays := ldays + 1;
          END IF;
       ELSE
          ldays := ldays + 1;
       END IF;
  --
       day_string := SUBSTR( day_string, iend+2);
  --
       iend := INSTR( day_string, ',') -1;
       IF iend < 0 THEN
          iend := LENGTH( day_string );
       END IF;
  --
       IF LENGTH( day_string ) > 0  THEN
          GOTO loop_start;
       END IF;
  --
    END IF;
  --
    RETURN ldays;
  END work_days;
  ---------------------------------------------------------------------------

  FUNCTION we_in_period( sdate IN date, edate IN date)
        RETURN number IS

  lwedays    number(3);  /*No of non-working days in a week*/
  nrem       number(3);  /*remainder of days over an integer no of weeks*/
  nweeks     number(3);  /*whole number of weeks in period*/
  sday       number(3);  /*The start day number*/
  ldays      number(3);  /*Return variable*/
  l_we       varchar2(20); /*String of weekend days from system options*/
  n_we       number;      /* Number of weekend days */
  icount     number;      /* count of characters in a string*/
  --
  BEGIN
  --
    l_we := get_sysopt('WEEKEND');
    n_we := 0;
  <<loop_start>>
    IF LENGTH(l_we) > 0 THEN
       icount := INSTR(l_we, ',' );
       IF icount > 0 THEN
          l_we := SUBSTR( l_we, icount + 1 );
          n_we := n_we + 1;
          GOTO loop_start;
       END IF;
       lwedays := n_we + 1;
    END IF;
  --
    nweeks := TRUNC( ( edate - sdate )/ 7 );
    nrem   := MOD( (edate-sdate), 7 );
  --
    OPEN c_start_day(sdate);
    FETCH c_start_day INTO sday;
    CLOSE c_start_day;
  --
    ldays := nweeks * lwedays + work_days( sday, nrem ) - nrem;
    RETURN ldays;
  END we_in_period;
 -----------------------------------------------------------------------------------------------
  FUNCTION date_due( p_date IN date, p_int_code IN varchar2,
                      p_week_days IN boolean)
          RETURN date IS

    n_int   number;        /* number of days in interval */
    n_hol   number;        /* number of days holiday in the period */
    n_we    number;        /* number of weekend days in the period */

    n_hol_sav number;      /* no. of holdays in last iteration period */
    n_we_sav  number;      /* no. of weeekend days in last iter. period */

    l_end_date      date;  /* The end of the iteration period */
    l_end_date_new  date;  /* The end of the new iteration period */

    it_count number;       /* Iteration count */

 BEGIN

    OPEN c_interval( p_date, p_int_code );
    FETCH c_interval INTO l_end_date;
    IF c_interval%NOTFOUND THEN
       CLOSE c_interval;
       raise_ner(pi_appl               => 'HIG'
                ,pi_id                 => 442
                ,pi_supplementary_info => p_int_code);
    END IF;
    CLOSE c_interval;

    IF p_week_days THEN

 --   The interval represents a number of working days, adjust for
 --   holidays and weekend days.
 --
      n_hol_sav := 0;
      n_we_sav  := 0;
 --
      it_count := 0;
 --
 <<loop_start>>
 --
    IF it_count > 10 THEN
       GOTO end_of_lp;
    END IF;
 --
 -- Pick up the count of holidays in this (increment) period.
 --
          OPEN c_holidays( p_date, l_end_date );
          FETCH c_holidays INTO n_hol;
          CLOSE c_holidays;
 --
 -- Get the number of weekend days in the period after adding the number
 -- of days holiday.
 --
 --
          n_we := we_in_period( p_date, l_end_date+n_hol-n_hol_sav);
 --
 --
          l_end_date_new := l_end_date+n_hol-n_hol_sav+n_we-n_we_sav;
 --
 -- test for convergence of the end_dates
 --
          IF TO_CHAR( l_end_date,'DD-MON-YYYY') =
             TO_CHAR( l_end_date_new, 'DD-MON-YYYY') THEN
             GOTO end_of_lp;
          ELSE
             l_end_date := l_end_date_new;
             n_hol_sav  := n_hol;
             n_we_sav   := n_we;
             it_count := it_count + 1;
             GOTO loop_start;
          END IF;
       END IF;
 <<end_of_lp>>
    RETURN l_end_date;
 --
 END date_due;
 ------------------------------------------------------------------------------------
  PROCEDURE  execute_sql (sql_in varchar2,
                          feedback OUT integer)
  IS
    err_string varchar2(2000) := NULL;
    cur        integer      := DBMS_SQL.OPEN_CURSOR;

  BEGIN
    DBMS_SQL.PARSE (cur, sql_in, dbms_sql.v7);
    feedback := DBMS_SQL.EXECUTE( cur );
    DBMS_SQL.CLOSE_CURSOR (cur);
  EXCEPTION
    WHEN others THEN

    /* trap the error string */

       err_string := SQLERRM;

      IF DBMS_SQL.IS_OPEN( cur ) THEN
         DBMS_SQL.CLOSE_CURSOR (cur);
      END IF;

      RAISE_APPLICATION_ERROR( -20001, err_string );
    END;
  ---------------------------------------------------------------------------------
  PROCEDURE  execute_autonomous_sql (sql_in varchar2)  IS
    PRAGMA autonomous_transaction;

    err_string varchar2(2000) := NULL;
--
  BEGIN
--
	EXECUTE IMMEDIATE sql_in;
	COMMIT;
  EXCEPTION
    WHEN others THEN
--
    /* trap the error string */

       err_string := SQLERRM;
       RAISE_APPLICATION_ERROR( -20001, err_string );
    END execute_autonomous_sql;
  ---------------------------------------------------------------------------------
  FUNCTION  execute_autonomous_sql (sql_in varchar2) RETURN varchar2 IS
    PRAGMA autonomous_transaction;
--
    err_string varchar2(2000) := NULL;
--
    l_feedback varchar2(2000) := NULL;
--
  BEGIN
	EXECUTE IMMEDIATE sql_in INTO l_feedback;
	COMMIT;
        RETURN l_feedback;
  EXCEPTION
    WHEN others THEN

    /* trap the error string */

       err_string := SQLERRM;
       RAISE_APPLICATION_ERROR( -20001, err_string );
    END execute_autonomous_sql;
  ---------------------------------------------------------------------------------


  PROCEDURE  execute_ddl (sql_in IN varchar2)
  IS
    err_string varchar2(80) := NULL;

    cur1       integer := DBMS_SQL.OPEN_CURSOR;
    cur2       integer := DBMS_SQL.OPEN_CURSOR;
    feedback   integer := NULL;
  BEGIN

  /* Require the permission to commit since ddl performs an implicit commit */

    DBMS_SQL.PARSE (cur1, 'alter session enable commit in procedure',dbms_sql.v7);
    feedback := DBMS_SQL.EXECUTE (cur1);
    DBMS_SQL.CLOSE_CURSOR (cur1);
    DBMS_SQL.PARSE (cur2, sql_in, dbms_sql.v7);
    DBMS_SQL.CLOSE_CURSOR (cur2);
  EXCEPTION
    WHEN others THEN

    /* trap the error string */

      err_string := SQLERRM;

      IF DBMS_SQL.IS_OPEN( cur1 ) THEN
         DBMS_SQL.CLOSE_CURSOR (cur1);
      END IF;

      IF DBMS_SQL.IS_OPEN( cur2 ) THEN
         DBMS_SQL.CLOSE_CURSOR (cur2);
      END IF;

      RAISE_APPLICATION_ERROR( -20001, err_string );
  END execute_ddl;

  -------------------------------------------------------------------------------
  -- Fetch the value for a particular system option.
  -- The call to get_product removed by RAC on 15th September 1997.
  -- Overloaded function using the product code as argument has been removed.

  FUNCTION get_sysopt
          (p_option_id         hig_options.hop_id%TYPE)
           RETURN varchar2 IS

  CURSOR c_sys_opt IS
     SELECT hov_value
     FROM hig_option_values
     WHERE hov_id = p_option_id;

  l_option_value hig_options.hop_value%TYPE;

  BEGIN

     OPEN c_sys_opt;
     FETCH c_sys_opt INTO l_option_value;
     CLOSE c_sys_opt;

     RETURN( l_option_value );
  END get_sysopt;

  -----------------------------------------------------------------------------
  -- Get a value for a specific user option. Notice that the username is required
  -- since the schema of package procedure execution is that of the package owner.

  FUNCTION get_useopt
	 ( p_option_id         hig_user_options.huo_id%TYPE,
	   p_username          varchar2 )
	   RETURN varchar2  IS

  CURSOR c_use_opt IS
     SELECT huo_value
     FROM hig_user_options, hig_users
     WHERE huo_id = p_option_id
     AND   hus_user_id = huo_hus_user_id
     AND   hus_username = p_username;

  l_option_value hig_user_options.huo_value%TYPE;

  BEGIN

     OPEN c_use_opt;
     FETCH c_use_opt INTO l_option_value;
     CLOSE c_use_opt;

     RETURN( l_option_value );
  END get_useopt;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_useopt
	 (pi_huo_hus_user_id   hig_user_options.huo_hus_user_id%TYPE
	 ,pi_huo_id            hig_user_options.huo_id%TYPE
	 ) RETURN hig_user_options.huo_value%TYPE IS
  BEGIN
     RETURN nm3get.get_huo (pi_huo_hus_user_id => pi_huo_hus_user_id
	                   ,pi_huo_id          => pi_huo_id
	                   ,pi_raise_not_found => FALSE
	                   ).huo_value;
  END get_useopt;
  --
  -----------------------------------------------------------------------------
  -- return a HIGHWAYS application error message text for a given code
  -- (PUBLIC)

  FUNCTION get_error_message
	( a_error_appl	IN	hig_errors.her_appl%TYPE
	, a_error_code	IN	hig_errors.her_no%TYPE
	, a_string1	IN	varchar2 DEFAULT NULL
	, a_string2	IN	varchar2 DEFAULT NULL
	, a_string3	IN	varchar2 DEFAULT NULL
  ) RETURN varchar2 AS

    CURSOR c_her ( error_appl hig_errors.her_appl%TYPE
    ,              error_code hig_errors.her_no%TYPE ) IS
       SELECT her_type
       ,      her_appl||'-'||
              LPAD( TO_CHAR( her_no) ,4 ,'0')||': '||
              her_descr
       FROM   hig_errors
       WHERE  her_no   = error_code
       AND    her_appl = error_appl;

    v_error_type hig_errors.her_type%TYPE;
    v_error_text varchar2(2000);

  BEGIN
/*
    -- dbms_output.put_line( 'get_error_message( '||a_error_appl||
    ', '||To_Char( a_error_code)||
    ', '||a_string1||
    ', '||a_string2||
    ', '||a_string3||
    ')');
*/
    OPEN  c_her (a_error_appl ,a_error_code);
    FETCH c_her INTO v_error_type ,v_error_text;
    IF   (c_her%NOTFOUND) THEN
      v_error_text := 'Unknown Error Message: '||
                      a_error_appl||'-'||TO_CHAR( a_error_code);
    ELSE
      v_error_text :=
      replace_strings_in_message( v_error_text ,a_string1 ,a_string2 ,a_string3);
    END IF;
    CLOSE c_her;

--  -- dbms_output.put_line( 'RETURN( '||v_error_text||')');
    RETURN( v_error_text);
  END get_error_message;


  -----------------------------------------------------------------------------
  -- replace substitution-strings in an error message
  -- (PUBLIC)

  FUNCTION replace_strings_in_message
	( a_error_text	IN	varchar2
	, a_string1	IN	varchar2 DEFAULT NULL
	, a_string2	IN	varchar2 DEFAULT NULL
	, a_string3	IN	varchar2 DEFAULT NULL
  ) RETURN varchar2 AS

    v_error_text varchar2(2000) DEFAULT a_error_text;

  BEGIN
/*
    -- dbms_output.put_line( 'replace_strings_in_message( '||a_error_text||
    ', '||a_string1||
    ', '||a_string2||
    ', '||a_string3||
    ')');
*/
    IF    (a_string1 IS NOT NULL) THEN
      v_error_text := REPLACE( v_error_text ,'%s1' ,a_string1);
      IF    (a_string2 IS NOT NULL) THEN
        v_error_text := REPLACE( v_error_text ,'%s2' ,a_string2);
        IF    (a_string3 IS NOT NULL) THEN
          v_error_text := REPLACE( v_error_text ,'%s3' ,a_string3);
        END IF;
      END IF;
    END IF;

--  -- dbms_output.put_line( 'RETURN( '||v_error_text||')');
    RETURN( v_error_text);
  END replace_strings_in_message;


  -----------------------------------------------------------------------------
  -- Function to get the <owner> of a database object (table,view,cluster)
  -- Now made public (RAC Sept 1999) in order for purity levels to be set
  --

  FUNCTION get_owner
	( a_object_name	IN	varchar2
  ) RETURN varchar2 AS

  /* either user owns the object (table,view,cluster) */
    CURSOR c_uo IS
      SELECT owner
      FROM   all_objects
      WHERE  object_name = UPPER( a_object_name)
        AND  object_type <> 'SYNONYM'
	AND  owner = Sys_Context('NM3_SECURITY_CTX','USERNAME');

  /* or user has private synonym to object */
    CURSOR c_us IS
      SELECT table_owner
      FROM   all_synonyms
      WHERE  synonym_name =  UPPER( a_object_name)
	AND  owner = Sys_Context('NM3_SECURITY_CTX','USERNAME');

 /* or user has the use of a synonym for an object owned by another user */
    CURSOR c_as IS
      SELECT table_owner
      FROM   all_synonyms
      WHERE  synonym_name = UPPER( a_object_name)
	AND  owner = 'PUBLIC';

 /* or user has no access to an object with this name */
    v_owner varchar2(30);
    b_found boolean DEFAULT FALSE;

  BEGIN
--  -- dbms_output.put_line( 'get_owner( '||a_object_name||')');

    OPEN  c_uo;
    FETCH c_uo INTO v_owner;
    b_found := c_uo%FOUND;
    CLOSE c_uo;
    IF    (NOT b_found) THEN
      OPEN  c_us;
      FETCH c_us INTO v_owner;
      b_found := c_us%FOUND;
      CLOSE c_us;
      IF    (NOT b_found) THEN
        OPEN  c_as;
        FETCH c_as INTO v_owner;
        b_found := c_as%FOUND;
        CLOSE c_as;
      END IF;
    END IF;

--  -- dbms_output.put_line( 'RETURN( '||v_owner||')');
    RETURN( v_owner);
  END get_owner;
  --
  -----------------------------------------------------------------------------
  --
PROCEDURE valid_fk_hco
	(pi_hco_domain     IN     hig_codes.hco_domain%TYPE
	,pi_hco_code       IN     hig_codes.hco_code%TYPE
	,pi_effective_date IN     date DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
	,po_hco_meaning       OUT hig_codes.hco_meaning%TYPE
        ) IS
--
-- Single procedure to replace the two which existed previously
--
   CURSOR cs_hco (c_hco_domain hig_codes.hco_domain%TYPE
                 ,c_hco_code   hig_codes.hco_code%TYPE
                 ,c_eff_date   date
                 ) IS
   SELECT hco_meaning
    FROM  hig_codes hco
   WHERE  hco.hco_domain  = c_hco_domain
    AND   hco.hco_code    = c_hco_code
    AND   c_eff_date     >= NVL(hco.hco_start_date,c_eff_date)
    AND   c_eff_date     <  NVL(hco.hco_end_date,nm3type.c_big_date);
--
   l_found boolean;
--
BEGIN
--
   OPEN  cs_hco (c_hco_domain => pi_hco_domain
                ,c_hco_code   => pi_hco_code
                ,c_eff_date   => NVL(pi_effective_date,To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY'))
                );
   FETCH cs_hco INTO po_hco_meaning;
   l_found := cs_hco%FOUND;
   CLOSE cs_hco;
--
   IF NOT l_found
    THEN
      hig.raise_ner(pi_appl                => nm3type.c_hig
                    ,pi_id                 => 109
                    ,pi_sqlcode            => -20001
                    ,pi_supplementary_info => '"'||pi_hco_domain||'" -> "'||pi_hco_code||'"'
                    );
--       RAISE_APPLICATION_ERROR(-20001
--                              ,replace_strings_in_message(g_thing_does_not_exist
--                                                         ,pi_hco_domain
--                                                         )
--                              );
   END IF;
--
END valid_fk_hco;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE valid_fk_hco
        (pi_hco_domain     IN hig_codes.hco_domain%TYPE
        ,pi_hco_code       IN hig_codes.hco_code%TYPE
	,pi_effective_date IN date
        ) IS
     l_hco_meaning hig_codes.hco_meaning%TYPE;
  BEGIN
     valid_fk_hco
	(pi_hco_domain     => pi_hco_domain
	,pi_hco_code       => pi_hco_code
	,pi_effective_date => pi_effective_date
	,po_hco_meaning    => l_hco_meaning
        );
  END valid_fk_hco;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE valid_fk_hco
        (pi_hco_domain IN hig_codes.hco_domain%TYPE
        ,pi_hco_code   IN hig_codes.hco_code%TYPE
        ) IS
  BEGIN
     valid_fk_hco
	(pi_hco_domain     => pi_hco_domain
	,pi_hco_code       => pi_hco_code
	,pi_effective_date => To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
        );
  END valid_fk_hco;
  --
  -----------------------------------------------------------------------------
  --
  -- Procedure to validate and return foreign key value
  -- Changed by RAC 15th September 1997 - Overloaded version using the product
  -- code as an argument has been dropped, this version does not use the product
  -- code as part of the lookup.
  PROCEDURE valid_fk_hco
	( a_hco_domain	IN	hig_codes.hco_domain%TYPE
	, a_hco_code	IN	hig_codes.hco_code%TYPE
	, a_hco_meaning	IN OUT	hig_codes.hco_meaning%TYPE
  ) AS
  BEGIN
    valid_fk_hco
	(pi_hco_domain     => a_hco_domain
	,pi_hco_code       => a_hco_code
	,pi_effective_date => To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
	,po_hco_meaning    => a_hco_meaning
        );
  END valid_fk_hco;
  --
  -----------------------------------------------------------------------------
  -- Procedure to validate and return foreign key value (Overloaded in
  -- the use of the date at which th evalidation is to apply. )
  -- The date is passed as a varchar2 of a specified mask since Pl/SQL 1
  -- differs in the way date parameters are held to PL/SQL 2.
  --
  PROCEDURE valid_fk_hco
	( a_hco_domain	IN	hig_codes.hco_domain%TYPE
	, a_hco_code	IN	hig_codes.hco_code%TYPE
	, a_hco_meaning	IN OUT	hig_codes.hco_meaning%TYPE
	, a_effective   IN      varchar2
	, a_date_mask   IN      varchar2 := 'DD-MON-YYYY'
  ) AS
     l_eff_date date;
  BEGIN
    IF a_effective IS NOT NULL
     THEN
      l_eff_date := TO_DATE(a_effective,a_date_mask);
    ELSE
      l_eff_date := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
    END IF;
    valid_fk_hco
	(pi_hco_domain     => a_hco_domain
	,pi_hco_code       => a_hco_code
	,pi_effective_date => l_eff_date
	,po_hco_meaning    => a_hco_meaning
        );
  END valid_fk_hco;
--
-----------------------------------------------------------------------------
--
 FUNCTION code_is_in_domain(pi_hco_code   IN hig_codes.hco_code%TYPE
                           ,pi_hco_domain IN hig_codes.hco_domain%TYPE
                           ) RETURN BOOLEAN IS
 
 l_retval BOOLEAN := TRUE;
                            
 BEGIN
 
  IF pi_hco_code IS NOT NULL THEN


    BEGIN
       hig.valid_fk_hco(pi_hco_domain  =>  upper(pi_hco_domain)
                       ,pi_hco_code    =>  pi_hco_code);
       l_retval := TRUE;
    EXCEPTION
       WHEN others THEN
         l_retval := FALSE;
    END;                      
    
                                                
  END IF;                           

  RETURN(l_retval);
  
END code_is_in_domain;
--
-----------------------------------------------------------------------------
--
  -----------------------------------------------------------------------------
  -- Function to return nau_unit_code
  --
  FUNCTION get_hau_unit_code
	( a_nau_admin_unit	IN	nm_admin_units.nau_admin_unit%TYPE) RETURN varchar2
	IS
		v_nau_unit_code nm_admin_units.nau_unit_code%TYPE := NULL;
		CURSOR c1 IS 	SELECT 	nau_unit_code
					FROM 		nm_admin_units
					WHERE  	nau_admin_unit = a_nau_admin_unit;
	BEGIN
		OPEN c1;
		FETCH c1 INTO v_nau_unit_code ;
		CLOSE c1;
		RETURN v_nau_unit_code ;
	END;

  -----------------------------------------------------------------------------
  -- Procedure to validate nau_authority_code
  --
  PROCEDURE valid_fk_hau
	( a_nau_authority_code	IN	nm_admin_units.nau_authority_code%TYPE) AS


  CURSOR c_nau IS
      SELECT 'exists'
      FROM nm_admin_units
      WHERE nau_authority_code = a_nau_authority_code
      AND ( EXISTS ( SELECT 'exists'
                     FROM nm_admin_groups, hig_users, nm_user_aus
                     WHERE nag_child_admin_unit = nua_admin_unit
                     AND   nag_parent_admin_unit = nau_admin_unit
                     AND   hus_username = Sys_Context('NM3_SECURITY_CTX','USERNAME')
                     AND   hus_user_id = nua_user_id) );

  l_exists char(6);

  b_notfound boolean DEFAULT FALSE;

  BEGIN
    -- dbms_output.put_line('valid_fk_hau( '||a_nau_authority_code||')');

    OPEN c_nau;
    FETCH c_nau INTO l_exists;
    b_notfound := c_nau%NOTFOUND;
    CLOSE c_nau;

    IF (b_notfound) THEN
       RAISE_APPLICATION_ERROR( -20001
         ,replace_strings_in_message(g_thing_does_not_exist,a_nau_authority_code));
    END IF;

    -- dbms_output.put_line('valid_fk_hau( OUT: '||a_nau_authority_code||')');
  END valid_fk_hau;
/*
  PROCEDURE valid_fk_hau
        ( a_hau_authority_code  IN      hig_admin_units.hau_authority_code%type
        , a_hau_admin_unit      IN      hig_admin_units.hau_admin_unit%type
        , a_hau_name            IN OUT  hig_admin_units.hau_name%type) AS

  cursor c_hau is
      select hau1.hau_name
      from hig_admin_units hau1
      where hau1.hau_admin_unit = a_hau_admin_unit
      and   exists ( select 'exists'
                     from hig_admin_groups, hig_users
                     where hag_parent_admin_unit = hus_admin_unit
                     and hag_child_admin_unit = hau1.hau_admin_unit
                     and hus_username = user )
      and ( exists ( select 'exists'
                     from hig_admin_units hau2, hig_admin_groups
                     where hau2.hau_authority_code = nvl(a_hau_authority_code,
                                             hau2.hau_authority_code )
                     and   hau2.hau_admin_unit = hag_parent_admin_unit
                     and   hag_child_admin_unit = hau1.hau_admin_unit )
            or     exists ( select 'exists'
                            from hig_admin_units hau2, hig_admin_groups
                            where hau2.hau_authority_code = nvl( a_hau_authority_code,
                                             hau2.hau_authority_code )
                            and   hau2.hau_admin_unit = hau1.hau_admin_unit
                            and   hag_child_admin_unit = hag_parent_admin_unit));

  b_notfound BOOLEAN DEFAULT FALSE;

  BEGIN
    -- dbms_output.put_line('valid_fk_hau( '||a_hau_name||')');

    OPEN c_hau;
    FETCH c_hau INTO a_hau_name;
    b_notfound := c_hau%NOTFOUND;
    CLOSE c_hau;

    IF (b_notfound) THEN
       raise_application_error( -20001
         ,replace_strings_in_message(g_thing_does_not_exist,a_hau_admin_unit));
    END IF;

    -- dbms_output.put_line('valid_fk_hau( OUT: '||a_hau_name||')');
  END valid_fk_hau;
*/

  PROCEDURE populate_globals (a_agent_code OUT hig_users.hus_agent_code%TYPE,
                            a_rmms_flag  OUT hig_options.hop_value%TYPE,
                            a_path_name  OUT hig_products.hpr_path_name%TYPE) IS

  l_product hig_products.hpr_product%TYPE;

  CURSOR c1 IS SELECT hus_agent_code
               FROM hig_users
               WHERE hus_username = Sys_Context('NM3_SECURITY_CTX','USERNAME');

  CURSOR c2 IS SELECT hop_value
               FROM hig_options
               WHERE hop_id = 'RMMSFLAG';

  CURSOR c3 IS SELECT hpr_path_name
               FROM hig_products
               WHERE hpr_product = l_product;
  BEGIN

    get_product(l_product);

    OPEN c1;
    FETCH c1 INTO a_agent_code;
    CLOSE c1;

    OPEN c2;
    FETCH c2 INTO a_rmms_flag;
    CLOSE c2;

    OPEN c3;
    FETCH c3 INTO a_path_name;
    CLOSE c3;

  END populate_globals;

--
-- Standard pipe stuff
--
   PROCEDURE pipe_receive ( info      OUT varchar2,
                            pipe_name IN  varchar2 ) IS
   s number;
   BEGIN
      s := DBMS_PIPE.RECEIVE_MESSAGE(pipe_name, 10);
      IF s<> 0 THEN
         RAISE_APPLICATION_ERROR( -20000, 'Send error');
      ELSE
         DBMS_PIPE.UNPACK_MESSAGE( info );
      END IF;
   END;

   PROCEDURE pipe_send ( info varchar2, pipe_name IN varchar2 ) IS
   s number;
   BEGIN
      DBMS_PIPE.PACK_MESSAGE( info );
      s := DBMS_PIPE.SEND_MESSAGE(pipe_name, 10);
      IF s<> 0 THEN
         RAISE_APPLICATION_ERROR( -20000, 'Send error');
      END IF;
   END;


   FUNCTION check_lstner RETURN boolean IS


    l_lsnr_count number;
    table_locked EXCEPTION;
    --
    PRAGMA EXCEPTION_INIT( table_locked, -54 );
    lock_alert number;

    BEGIN
      SAVEPOINT lstner;
      LOCK TABLE exor_lock IN EXCLUSIVE MODE NOWAIT;

      ROLLBACK TO SAVEPOINT lstner;
      RETURN FALSE;
    EXCEPTION
      WHEN table_locked THEN
        ROLLBACK TO SAVEPOINT lstner;
	RETURN TRUE;
     END;

  FUNCTION get_product_path RETURN varchar2 IS
  CURSOR c1 IS
    SELECT hpr_path_name
    FROM hig_products
    WHERE hpr_product = g_product;

  l_return varchar2(80);

  BEGIN
    OPEN c1;
    FETCH c1 INTO  l_return;
    IF c1%NOTFOUND THEN
      NULL;
    END IF;
    CLOSE c1;
    RETURN l_return;
  END;


  --
  --  Get identifier based on the table, select and where clause
  --
  FUNCTION get_id_from_descr (table_name IN varchar2,
                              select_column IN varchar2,
                              where_column IN varchar2,
                              where_val IN varchar2) RETURN varchar2 IS


	id_val varchar2(255);
	source_cursor integer;
	strsql varchar2(1000);
	ignore integer;

  BEGIN


	-- Build sql string
	source_cursor := DBMS_SQL.OPEN_CURSOR;
	strsql := 'SELECT ' || select_column || ' ';
	strsql := strsql || 'FROM ' || table_name || ' ';
	strsql := strsql || 'WHERE ' || where_column || ' = ''' || where_val || '''';

    -- dbms_output.put_line (strsql);

	DBMS_SQL.PARSE(source_cursor, strsql, dbms_sql.v7);
	DBMS_SQL.DEFINE_COLUMN(source_cursor, 1, id_val, 255);
	ignore := DBMS_SQL.EXECUTE(source_cursor);


	IF DBMS_SQL.FETCH_ROWS(source_cursor) > 0 THEN
	  DBMS_SQL.COLUMN_VALUE(source_cursor, 1, id_val);
    ELSE
      id_val := NULL;
    END IF;

	DBMS_SQL.CLOSE_CURSOR(source_cursor);

    RETURN (id_val);

	EXCEPTION
		WHEN others THEN
			IF DBMS_SQL.IS_OPEN(source_cursor) THEN
				DBMS_SQL.CLOSE_CURSOR(source_cursor);
			END IF;
			RETURN NULL;
  END;

  -----------------------------------------------------------------------------
  -- Procedure to validate and return foreign key value for hig_status_codes

  PROCEDURE valid_fk_hsc
	( a_hsc_domain_code	IN	hig_status_codes.hsc_domain_code%TYPE
	, a_hsc_status_code	IN	hig_status_codes.hsc_status_code%TYPE
	, a_hsc_status_name IN OUT hig_status_codes.hsc_status_name%TYPE
  ) AS

  CURSOR c_hsc IS
    SELECT hsc_status_name
    FROM hig_status_codes hsc,hig_status_domains hsd
    WHERE hsd.hsd_domain_code = hsc.hsc_domain_code
    AND   hsc.hsc_domain_code  = a_hsc_domain_code
    AND   hsc.hsc_status_code =    a_hsc_status_code
    AND   SYSDATE BETWEEN NVL(hsc_start_date,SYSDATE)
                  AND     NVL(hsc_end_date,SYSDATE);

  b_notfound boolean DEFAULT FALSE;

  BEGIN

    OPEN c_hsc;
    FETCH c_hsc INTO a_hsc_status_name;
    b_notfound := c_hsc%NOTFOUND;
    CLOSE c_hsc;

    IF (b_notfound) THEN
       RAISE_APPLICATION_ERROR( -20001
         ,replace_strings_in_message(g_thing_does_not_exist,a_hsc_domain_code));
    END IF;

    -- dbms_output.put_line('valid_fk_hsc( OUT: '||a_hsc_status_name||')');
  END valid_fk_hsc;

  -----------------------------------------------------------------------------
  -- Function to validate dates from a given Varchar string against the
  -- DATE_FORMAT_MASK Domain
FUNCTION date_convert (value_in IN date) RETURN date IS
BEGIN
   RETURN value_in;
END date_convert;
FUNCTION date_convert (value_in IN varchar2) RETURN date IS
--
   CURSOR mask_cur IS
   SELECT *
    FROM (SELECT Sys_Context('NM3CORE','USER_DATE_MASK') date_mask
                ,-1                         date_sequence
           FROM  dual
          UNION
          SELECT hco_code date_mask
                ,hco_seq  data_sequence
           FROM  hig_codes
          WHERE  hco_domain = 'DATE_FORMAT_MASK'
          UNION
          SELECT nm3type.c_full_date_time_format   date_mask
                ,0                                 date_sequence
           FROM  dual
        )
   ORDER BY date_sequence;
--
   l_date_mask           varchar2(32767);
   return_value          date            := NULL;
   value_int             varchar2(32767) := UPPER (value_in);
   c_fx         CONSTANT varchar2(2)     := 'FX';
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'date_convert');
--
-- If there is a time portion of this date, but it is midnight
   IF nm3flx.RIGHT(value_int,9) = ' 00:00:00'
    THEN
      value_int := nm3flx.LEFT (value_int,LENGTH(value_int)-9);
   END IF;
--
   FOR cs_rec IN mask_cur
    LOOP
      BEGIN
         l_date_mask := cs_rec.date_mask;
         IF SUBSTR(l_date_mask,1,2) != c_fx
          THEN
            l_date_mask := c_fx||l_date_mask; -- Force Fixed Length matching
         END IF;
         return_value := TO_DATE (value_int, l_date_mask);
         EXIT;
      EXCEPTION
         WHEN others
          THEN
            return_value := NULL;
      END;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'date_convert');
--
   /* Return the converted date */
   RETURN return_value;
--
END date_convert;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION is_module_fastpath_invalid(pi_module IN hig_modules.hmo_module%TYPE) RETURN varchar2 IS
    CURSOR c1 IS
	  SELECT
        hmo_fastpath_invalid
	  FROM
	    hig_modules
	  WHERE
	    hmo_module = pi_module;

	retval hig_modules.hmo_fastpath_invalid%TYPE;
  BEGIN
    OPEN c1;
	  FETCH c1 INTO retval;
	CLOSE c1;

	RETURN retval;
  END is_module_fastpath_invalid;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_module_title
        (a_module IN hig_modules.hmo_module%TYPE
  ) RETURN hig_modules.hmo_title%TYPE IS

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
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_domain_seq(pi_domain IN hig_domains.hdo_domain%TYPE
                         ,pi_value  IN hig_codes.hco_code%TYPE
                         ) RETURN hig_codes.hco_seq%TYPE IS

    CURSOR c1 IS
      SELECT
        hc.hco_seq
      FROM
        hig_codes hc
      WHERE
        hc.hco_domain = pi_domain
      AND
        hc.hco_code = pi_value;

    l_retval hig_codes.hco_seq%TYPE;

  BEGIN
    OPEN c1;
      FETCH c1 INTO l_retval;
      IF c1%NOTFOUND THEN
        RAISE_APPLICATION_ERROR( -20001, 'Domain value does not exist.');
      END IF;
    CLOSE c1;

    RETURN l_retval;

  END get_domain_seq;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION domain_exists(pi_domain IN hig_domains.hdo_domain%TYPE
                        ) RETURN boolean IS

    CURSOR c1 IS
      SELECT
        1
      FROM
        hig_domains hd
      WHERE
        hd.hdo_domain = pi_domain;

    l_temp   pls_integer;
    l_retval boolean := FALSE;

  BEGIN
    OPEN c1;
      FETCH c1 INTO l_temp;
      IF c1%FOUND THEN
        l_retval := TRUE;
      END IF;
    CLOSE c1;

    RETURN l_retval;
  END domain_exists;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION is_product_licensed ( pi_product varchar2 )
     RETURN boolean
     IS
        CURSOR c1 ( c_product varchar2) IS
  	  SELECT 1
  	  FROM hig_products
  	  WHERE hpr_product = c_product
  	    AND hpr_key IS NOT NULL;
  --
  	  dummy number := NULL;
  --
  	  retval boolean := TRUE;
  --
     BEGIN
        OPEN c1( pi_product );
  	  FETCH c1 INTO dummy;
  	  IF c1%NOTFOUND THEN
  	     retval := FALSE;
  	  END IF;
  	  CLOSE c1;
  	  RETURN retval;
     END is_product_licensed;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_module_details(pi_module IN     hig_modules.hmo_module%TYPE
                              ,po_hmo       OUT hig_modules%ROWTYPE
                              ,po_mode      OUT hig_module_roles.hmr_mode%TYPE
                              ) IS

    CURSOR c_module(p_module IN hig_modules.hmo_module%TYPE) IS
      SELECT
        *
      FROM
        hig_modules hmo
      WHERE
        hmo.hmo_module = p_module;

    CURSOR c_mode(p_module IN hig_modules.hmo_module%TYPE) IS
      SELECT
        hmr.hmr_mode
      FROM
        hig_module_roles hmr,
        hig_user_roles   hur
      WHERE
        hmr_module = p_module
      AND
        hmr_role = hur.hur_role
      AND
        hur.hur_username = Sys_Context('NM3_SECURITY_CTX','USERNAME')
      ORDER BY
        hmr.hmr_mode;

  BEGIN
    OPEN c_module(p_module => UPPER(pi_module));
      FETCH c_module INTO po_hmo;
      IF c_module%NOTFOUND
      THEN
        CLOSE c_module;

        g_hig_exc_code := -20009;
        g_hig_exc_msg  := 'Module ' || pi_module || ' does not exist.';

        RAISE g_hig_exception;
      END IF;
    CLOSE c_module;

    OPEN c_mode(p_module => UPPER(pi_module));
      FETCH c_mode INTO po_mode;
    CLOSE c_mode;

  EXCEPTION
    WHEN g_hig_exception
    THEN
      RAISE_APPLICATION_ERROR(g_hig_exc_code, g_hig_exc_msg);

  END get_module_details;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_hpr(pi_product hig_products.hpr_product%TYPE
                  ) RETURN hig_products%ROWTYPE IS

    CURSOR c_hpr(p_product hig_products.hpr_product%TYPE) IS
      SELECT
        *
      FROM
        hig_products hpr
      WHERE
        hpr.hpr_product = p_product;

    l_retval hig_products%ROWTYPE;

  BEGIN
    OPEN c_hpr(p_product => pi_product);
      FETCH c_hpr INTO l_retval;
      IF c_hpr%NOTFOUND
      THEN
        CLOSE c_hpr;

        g_hig_exc_code := -20010;
        g_hig_exc_msg  := 'Product ' || pi_product || ' does not exist.';

        RAISE g_hig_exception;

      END IF;
    CLOSE c_hpr;

    RETURN l_retval;

  EXCEPTION
    WHEN g_hig_exception
    THEN
      RAISE_APPLICATION_ERROR(g_hig_exc_code, g_hig_exc_msg);

  END get_hpr;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE ins_hur(pi_hur_rec IN hig_user_roles%ROWTYPE
                   ) IS
  BEGIN
    INSERT INTO
      hig_user_roles
          (hur_username
          ,hur_role
          ,hur_start_date
          )
    VALUES(pi_hur_rec.hur_username
          ,pi_hur_rec.hur_role
          ,pi_hur_rec.hur_start_date
          );
  END ins_hur;
  --
  -----------------------------------------------------------------------------
  --  
  FUNCTION get_user_or_sys_opt(pi_option IN hig_options.hop_id%TYPE
	                            ) RETURN varchar2 IS
	BEGIN
		RETURN NVL(hig.get_useopt(p_option_id => pi_option
	                           ,p_username  => Sys_Context('NM3_SECURITY_CTX','USERNAME'))
	            ,hig.get_sysopt(p_option_id => pi_option));
	END;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_ner(pi_appl IN nm_errors.ner_appl%TYPE
                  ,pi_id   IN nm_errors.ner_id%TYPE
                  ) RETURN nm_errors%ROWTYPE IS

    CURSOR cs_ner(p_appl nm_errors.ner_appl%TYPE
                 ,p_id   nm_errors.ner_id%TYPE) IS
    SELECT *
    FROM nm_errors
    WHERE ner_appl = p_appl
    AND ner_id = p_id;

    l_retval nm_errors%ROWTYPE;

  BEGIN

    nm_debug.proc_start(p_package_name   => g_package_name
                       ,p_procedure_name => 'get_ner');

    OPEN cs_ner(p_appl => pi_appl
               ,p_id   => pi_id);
    FETCH cs_ner INTO l_retval;
    IF cs_ner%NOTFOUND THEN

       CLOSE cs_ner;
       
       l_retval.ner_appl  :=  'HIG';
       l_retval.ner_id    :=  -1;
       l_retval.ner_descr :=  'nm_errors - ner_appl = '||pi_appl||' ner_id = '||pi_id;
       
    ELSE
    
       CLOSE cs_ner;
    
    END IF;

    nm_debug.proc_end(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_ner');

    RETURN l_retval;

  END get_ner;
  --
  -----------------------------------------------------------------------------
  --
   PROCEDURE raise_ner( pi_appl               IN nm_errors.ner_appl%TYPE
                      , pi_id                 IN nm_errors.ner_id%TYPE
                      , pi_sqlcode            IN pls_integer DEFAULT -20000
                      , pi_supplementary_info IN varchar2    DEFAULT NULL
                      ) IS
--
     l_rec_ner nm_errors%ROWTYPE;
--
     l_sqlcode pls_integer := ABS(pi_sqlcode) * (-1);
     l_sqlerrm varchar2(32767);
--
     l_id_char varchar2(5);
--
  BEGIN
     --
   
     DECLARE
        l_ner_not_found EXCEPTION;
       
     BEGIN
        
        nm_debug.debug('calling get_ner to get the error record');
        l_rec_ner := get_ner(pi_appl,pi_id);
        
        IF l_rec_ner.ner_id =  -1 THEN

           RAISE l_ner_not_found;
         
        END IF;
        
     EXCEPTION
        WHEN l_ner_not_found
         THEN
          
           l_sqlcode := null;
           l_rec_ner.ner_descr := 'Error not found in NM_ERRORS - ';
     
     END;
     --
    
     l_id_char := LTRIM(TO_CHAR(pi_id,'0000'),' ');
     --
     IF  ABS(l_sqlcode) NOT BETWEEN 20000 AND 20999
      OR l_sqlcode IS NULL
      THEN
        l_sqlcode := -20000;
     END IF;
     --
     l_sqlerrm := pi_appl||'-'||l_id_char||': '||l_rec_ner.ner_descr;
     --
     IF pi_supplementary_info IS NOT NULL
      THEN
        l_sqlerrm := l_sqlerrm||': '||pi_supplementary_info;
     END IF;
     --
     -- MJA add 03-Sep-07
     IF l_rec_ner.ner_cause IS NOT NULL
     THEN
       l_sqlerrm := l_sqlerrm||chr(10)||': '||l_rec_ner.ner_cause;
     END IF;
     --
     g_last_ner_appl  := pi_appl;
     g_last_ner_id    := pi_id;
     g_last_ner_suppl := pi_supplementary_info;

     RAISE_APPLICATION_ERROR(l_sqlcode,l_sqlerrm);
     --
  END raise_ner;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION raise_and_catch_ner (pi_appl               IN nm_errors.ner_appl%TYPE
                               ,pi_id                 IN nm_errors.ner_id%TYPE
                               ,pi_supplementary_info IN varchar2    DEFAULT NULL
                               ) RETURN varchar2 IS
  --
     l_retval nm3type.max_varchar2;
  --
  BEGIN
  --
     DECLARE
        l_caught EXCEPTION;
        PRAGMA EXCEPTION_INIT(l_caught,-20998);
     BEGIN
        hig.raise_ner (pi_appl               => pi_appl
                      ,pi_id                 => pi_id
                      ,pi_sqlcode            => -20998
                      ,pi_supplementary_info => pi_supplementary_info
                      );
     EXCEPTION
        WHEN l_caught
         THEN
           l_retval := nm3flx.parse_error_message(SQLERRM);
     END;
  --
     RETURN l_retval;
  --
  END raise_and_catch_ner;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION check_last_ner(pi_appl IN nm_errors.ner_appl%TYPE
                         ,pi_id   IN nm_errors.ner_id%TYPE
                         ) RETURN boolean IS

    c_nvl varchar2(5) := 'ö$%^';

    l_retval boolean;

  BEGIN
    nm_debug.proc_start(p_package_name   => g_package_name
                       ,p_procedure_name => 'check_last_ner');

    l_retval := (pi_appl = NVL(g_last_ner_appl, c_nvl)
                 AND
                 pi_id = NVL(g_last_ner_id, -1));

    nm_debug.proc_end(p_package_name   => g_package_name
                     ,p_procedure_name => 'check_last_ner');

    RETURN l_retval;

  END check_last_ner;
--
-----------------------------------------------------------------------------
--
FUNCTION get_hig_domain_lov_sql (pi_hdo_domain       hig_domains.hdo_domain%TYPE
                                ,pi_include_order_by boolean DEFAULT TRUE
                                ) RETURN varchar2 IS
--
   l_retval varchar2(5000);
--
BEGIN
   l_retval :=       'SELECT hco_code lup_meaning, hco_meaning lup_description, hco_code lup_value'
          ||CHR(10)||' FROM  hig_codes'
          ||CHR(10)||'WHERE  hco_domain = '||nm3flx.string(pi_hdo_domain);
   IF pi_include_order_by
    THEN
      l_retval := l_retval
          ||CHR(10)||'ORDER BY hco_seq, hco_code';
   END IF;
   RETURN l_retval;
END get_hig_domain_lov_sql;
  --
  -----------------------------------------------------------------------------
  --
PROCEDURE set_useopt (pi_huo_hus_user_id hig_user_options.huo_hus_user_id%TYPE
                     ,pi_huo_id          hig_user_options.huo_id%TYPE
                     ,pi_huo_value       hig_user_options.huo_value%TYPE
                     ) IS
--
   l_rec_huo hig_user_options%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'set_useopt');
--
   l_rec_huo.huo_hus_user_id := pi_huo_hus_user_id;
   l_rec_huo.huo_id          := pi_huo_id;
   l_rec_huo.huo_value       := pi_huo_value;
--
   nm3del.del_huo (pi_huo_hus_user_id => l_rec_huo.huo_hus_user_id
                  ,pi_huo_id          => l_rec_huo.huo_id
                  ,pi_raise_not_found => FALSE
                  );
--
   IF pi_huo_value IS NOT NULL
    THEN
      nm3ins.ins_huo (p_rec_huo => l_rec_huo);
   END IF;
--
   nm_debug.proc_end(g_package_name,'set_useopt');
--
END set_useopt;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_opt (pi_hov_id          hig_option_values.hov_id%TYPE
                  ,pi_hov_value       hig_option_values.hov_value%TYPE
                     ) IS
--
   l_rec_hov hig_option_values%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'set_opt');
--
   l_rec_hov.hov_id          := pi_hov_id;
   l_rec_hov.hov_value       := pi_hov_value;
--
   nm3del.del_hov (pi_hov_id          => l_rec_hov.hov_id
                  ,pi_raise_not_found => FALSE
                  );
--
   IF pi_hov_value IS NOT NULL
    THEN
      nm3ins.ins_hov (p_rec_hov => l_rec_hov);
   END IF;
--
   nm_debug.proc_end(g_package_name,'set_opt');
--
END set_opt;
--
-----------------------------------------------------------------------------
--
PROCEDURE raise_constraint_violation_ner (pi_constraint_name IN hig_check_constraint_assocs.hcca_constraint_name%TYPE
                                         ,pi_sqlcode         IN pls_integer DEFAULT -20000
                                         ) IS
--
   CURSOR cs_hcca (c_hcca_constraint_name hig_check_constraint_assocs.hcca_constraint_name%TYPE) IS
   SELECT *
    FROM  hig_check_constraint_assocs
   WHERE  hcca_constraint_name = c_hcca_constraint_name;
--
   l_rec_hcca           hig_check_constraint_assocs%ROWTYPE;
   l_found              boolean;
   l_supplementary_info varchar2(61);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'raise_constraint_violation_ner');
--
   OPEN  cs_hcca (pi_constraint_name);
   FETCH cs_hcca INTO l_rec_hcca;
   l_found := cs_hcca%FOUND;
   CLOSE cs_hcca;
--
   IF NOT l_found
    THEN
      l_rec_hcca.hcca_ner_appl := nm3type.c_hig;
      l_rec_hcca.hcca_ner_id   := 169;
      l_supplementary_info     := pi_constraint_name;
--   ELSE
--      l_supplementary_info     := l_rec_hcca.hcca_table_name||'.'||l_rec_hcca.hcca_constraint_name;
   END IF;
--
   nm_debug.proc_end(g_package_name,'raise_constraint_violation_ner');
--
   hig.raise_ner (pi_appl               => l_rec_hcca.hcca_ner_appl
                 ,pi_id                 => l_rec_hcca.hcca_ner_id
                 ,pi_sqlcode            => pi_sqlcode
                 ,pi_supplementary_info => l_supplementary_info
                 );
--
END raise_constraint_violation_ner;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_user_instantiated IS
BEGIN
   IF Sys_Context('NM3CORE','APPLICATION_OWNER') IS NULL
    THEN
      dbms_session.reset_package;
      hig.raise_ner (pi_appl => nm3type.c_hig
                    ,pi_id   => 182
                    );
   END IF;
END check_user_instantiated;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_user_is_current IS
--
   CURSOR cs_hus IS
   SELECT *
    FROM  hig_users
   WHERE  hus_user_id = Sys_Context('NM3CORE','USER_ID');
--
   l_found                  BOOLEAN;
   l_rec_hus                hig_users%ROWTYPE;
   l_ner_id                 nm_errors.ner_id%TYPE;
   l_supp_info              VARCHAR2(500);
   c_trunc_sysdate CONSTANT DATE := TRUNC(SYSDATE);
--
BEGIN
--
   OPEN  cs_hus;
   FETCH cs_hus INTO l_rec_hus;
   l_found := cs_hus%FOUND;
   CLOSE cs_hus;
--
   IF NOT l_found
    THEN
      l_ner_id    := 67;
      l_supp_info := 'HIG_USERS';
   ELSIF c_trunc_sysdate NOT BETWEEN l_rec_hus.hus_start_date AND NVL(l_rec_hus.hus_end_date,(c_trunc_sysdate+1))
    THEN
      l_ner_id    := 184;
   END IF;
--
   IF l_ner_id IS NOT NULL
    THEN
      dbms_session.reset_package;
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => l_ner_id
                    ,pi_supplementary_info => l_supp_info
                    );
   END IF;
--
END check_user_is_current;
--
-----------------------------------------------------------------------------
--
FUNCTION raise_and_catch_constraint_ner (pi_constraint_name IN hig_check_constraint_assocs.hcca_constraint_name%TYPE
                                        ) RETURN varchar2 IS
--
   l_retval nm3type.max_varchar2;
--
BEGIN
--
   DECLARE
      l_caught EXCEPTION;
      PRAGMA EXCEPTION_INIT(l_caught,-20998);
   BEGIN
      raise_constraint_violation_ner(pi_constraint_name => pi_constraint_name
                                    ,pi_sqlcode         => -20998);
   EXCEPTION
      WHEN l_caught
       THEN
         l_retval := nm3flx.parse_error_message(SQLERRM);
   END;
--
   RETURN l_retval;
--
END raise_and_catch_constraint_ner;
--
-----------------------------------------------------------------------------
--
FUNCTION get_constraint_from_error_text(pi_error_text IN varchar2
                                       ) RETURN user_constraints.constraint_name%TYPE IS

  c_left_brace_pos  CONSTANT pls_integer := INSTR(pi_error_text, '(');
  c_right_brace_pos CONSTANT pls_integer := INSTR(pi_error_text, ')');
  c_dot_pos         CONSTANT pls_integer := INSTR(pi_error_text, '.', c_left_brace_pos);

  l_start_pos pls_integer;

  l_retval user_constraints.constraint_name%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_constraint_from_error_text');

  IF c_dot_pos > 0
    AND c_dot_pos < c_right_brace_pos
  THEN
    l_start_pos := c_dot_pos + 1;
  ELSE
    l_start_pos := c_left_brace_pos + 1;
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_constraint_from_error_text');

  RETURN SUBSTR(pi_error_text, l_start_pos, c_right_brace_pos - l_start_pos);

END get_constraint_from_error_text;
--
-----------------------------------------------------------------------------
--
FUNCTION huol_already_set(pi_huol_id IN hig_user_option_list.huol_id%TYPE) RETURN BOOLEAN IS


  CURSOR c1 IS
  SELECT 'X'
  FROM   hig_user_options
  WHERE  huo_id = pi_huol_id;
  
  l_dummy VARCHAR2(1) := Null;
  
BEGIN


 OPEN c1;
 FETCH c1 INTO l_dummy;
 CLOSE c1;
 
 RETURN(l_dummy IS NOT NULL);

END huol_already_set;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_user_option_tree_data( po_tab_initial_state    IN OUT nm3type.tab_number
                                    ,po_tab_depth            IN OUT nm3type.tab_number
                                    ,po_tab_label            IN OUT nm3type.tab_varchar80
                                    ,po_tab_icon             IN OUT nm3type.tab_varchar30
                                    ,po_tab_data             IN OUT nm3type.tab_varchar30
                                    ,po_tab_parent           IN OUT nm3type.tab_varchar30) IS
						 
 l_tab_order_by_prod         nm3type.tab_number; 
 l_tab_initial_state_prod    nm3type.tab_number;
 l_tab_depth_prod            nm3type.tab_number;
 l_tab_label_prod            nm3type.tab_varchar80;
 l_tab_icon_prod             nm3type.tab_varchar30;
 l_tab_data_prod             nm3type.tab_varchar30;
 l_tab_parent_prod           nm3type.tab_varchar30;   

 l_tab_order_by         nm3type.tab_number; 
 l_tab_initial_state    nm3type.tab_number;
 l_tab_depth            nm3type.tab_number;
 l_tab_label            nm3type.tab_varchar80;
 l_tab_icon             nm3type.tab_varchar30;
 l_tab_data             nm3type.tab_varchar30;
 l_tab_parent           nm3type.tab_varchar30;
 
 l_nextrec              PLS_INTEGER;

 CURSOR c_products IS
      SELECT
             1                               initial_state
            ,2                           depth
            ,hpr_product_name                      LABEL
            ,'fdrclose'                  icon
            ,hpr_product                      DATA
            ,'PRODUCTS'                     PARENT
      FROM hig_products
      WHERE EXISTS (SELECT 'x' 
                    FROM hig_user_option_list_all
                    WHERE huol_product = hpr_product)
      ORDER BY DECODE(HPR_PRODUCT,'HIG',1,'NET',2,3);	
--
----------------- 
--
 PROCEDURE get_root_of_tree(po_tab_initial_state    IN OUT nm3type.tab_number
                           ,po_tab_depth            IN OUT nm3type.tab_number
                           ,po_tab_label            IN OUT nm3type.tab_varchar80
                           ,po_tab_icon             IN OUT nm3type.tab_varchar30
                           ,po_tab_data             IN OUT nm3type.tab_varchar30
                           ,po_tab_parent           IN OUT nm3type.tab_varchar30) IS

 
 BEGIN


      SELECT
             1                               initial_state
            ,1                               depth
            ,'Products'                      LABEL
            ,'fdrclose'                      icon
            ,'PRODUCTS'                      DATA
            ,'ROOT'                          PARENT
      BULK COLLECT INTO 
              po_tab_initial_state
             ,po_tab_depth
             ,po_tab_label
             ,po_tab_icon
             ,po_tab_data
             ,po_tab_parent
      FROM
            dual;
	  
 END get_root_of_tree;
--
-----------------
--
 PROCEDURE get_options_for_product(pi_start_with           IN     hig_products.hpr_product%TYPE
                                  ,po_tab_initial_state    IN OUT nm3type.tab_number
                                  ,po_tab_depth            IN OUT nm3type.tab_number
                                  ,po_tab_label            IN OUT nm3type.tab_varchar80
                                  ,po_tab_icon             IN OUT nm3type.tab_varchar30
                                  ,po_tab_data             IN OUT nm3type.tab_varchar30
                                  ,po_tab_parent           IN OUT nm3type.tab_varchar30
                                  ,po_tab_order_by         IN OUT nm3type.tab_number) IS

 BEGIN

      SELECT
             0                               initial_state
            ,3                               depth
            ,huol_name                       LABEL
            ,'exormini'                      icon
            ,huol_id                         DATA
            ,pi_start_with                   PARENT
            ,Null                            order_by
      BULK COLLECT INTO
              po_tab_initial_state
             ,po_tab_depth
             ,po_tab_label
             ,po_tab_icon
             ,po_tab_data
             ,po_tab_parent
             ,po_tab_order_by
      FROM hig_user_option_list_all -- i.e. pick explicit user options and product options flagged as user options
	  WHERE huol_product = pi_start_with
	  ORDER BY huol_id;
 
 END get_options_for_product;
 

BEGIN


  ---------------------------
  -- Get the root of the menu
  ---------------------------
  get_root_of_tree(po_tab_initial_state    => po_tab_initial_state
                  ,po_tab_depth            => po_tab_depth
                  ,po_tab_label            => po_tab_label
                  ,po_tab_icon             => po_tab_icon
                  ,po_tab_data             => po_tab_data
                  ,po_tab_parent           => po_tab_parent);
				  
  FOR i IN c_products LOOP
   
       l_nextrec := po_tab_initial_state.COUNT+1;
	 
	   po_tab_initial_state(l_nextrec)  := i.initial_state;
       po_tab_depth(l_nextrec)          := i.depth;
       po_tab_label(l_nextrec)          := i.label;
       po_tab_icon(l_nextrec)           := i.icon;
       po_tab_data(l_nextrec)           := i.data;
       po_tab_parent(l_nextrec)         := i.parent;


    
     get_options_for_product(pi_start_with           => i.data
                            ,po_tab_initial_state    => l_tab_initial_state
                            ,po_tab_depth            => l_tab_depth  
                            ,po_tab_label            => l_tab_label 
                            ,po_tab_icon             => l_tab_icon
                            ,po_tab_data             => l_tab_data
                            ,po_tab_parent           => l_tab_parent
                            ,po_tab_order_by         => l_tab_order_by);
						
    FOR opt IN 1..l_tab_data.COUNT LOOP        
         l_nextrec := po_tab_initial_state.COUNT+1;
	 
         po_tab_initial_state(l_nextrec) := l_tab_initial_state(opt);
         po_tab_depth(l_nextrec)         := l_tab_depth(opt);		 
         po_tab_label(l_nextrec)         := l_tab_label(opt);	     						
         po_tab_icon(l_nextrec)          := l_tab_icon(opt);
         po_tab_data(l_nextrec)          := l_tab_data(opt);
         po_tab_parent(l_nextrec)        := l_tab_parent(opt);
		 
 	END LOOP;  -- options 				

  
  END LOOP; -- products				  
				  

END get_user_option_tree_data;
--
-----------------------------------------------------------------------------
-- cannot go into nm3get or a generated package cos hig_user_option_list_all is a view
--
FUNCTION get_huol_all (pi_huol_id            hig_user_option_list_all.huol_id%TYPE
                      ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                      ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                      ) RETURN hig_user_option_list_all%ROWTYPE IS
--
   CURSOR cs_huol IS
   SELECT /*+ INDEX (hol HOL_PK) */ *
    FROM  hig_user_option_list_all huol
   WHERE  huol.huol_id = pi_huol_id;
--
   l_found  BOOLEAN;
   l_retval hig_option_list%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_huol_all');
--
   OPEN  cs_huol;
   FETCH cs_huol INTO l_retval;
   l_found := cs_huol%FOUND;
   CLOSE cs_huol;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_user_option_list'
                                              ||CHR(10)||'huol_id => '||pi_huol_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_huol');
--
   RETURN l_retval;
--
END get_huol_all;
--
-----------------------------------------------------------------------------
--
Function Get_Application_Owner Return Varchar2
Is
Begin
  --  This is a backwards compatible version of this procedure/function, since not all products made the required changes in time for 4500.
  --  this shares the same header as the 4400 version but uses 4500 contexts behind the scenes.
  --  this function should not be used for any new development and will be removed in a future release.
   Return (Sys_Context('NM3CORE','APPLICATION_OWNER'));
End Get_Application_Owner;
--
-----------------------------------------------------------------------------
--
Function Is_Enterprise_Edition Return Boolean
Is
Begin
  --  This is a backwards compatible version of this procedure/function, since not all products made the required changes in time for 4500.
  --  this shares the same header as the 4400 version but uses 4500 contexts behind the scenes.
  --  this function should not be used for any new development and will be removed in a future release.
  Return (Sys_Context('NM3CORE','ENTERPRISE_EDITION') = 'TRUE');
      
End Is_Enterprise_Edition;


--
-----------------------------------------------------------------------------
--
/* MAIN */
BEGIN  /* hig - automatic variables */

  check_user_instantiated;
  check_user_is_current;
/* Commented due to a requirement to set purity levels
  IF    (g_application_owner IS NULL) THEN
    raise_application_error( -20000 ,'hig.g_application_owner IS NULL.');
  END IF;
*/

  /* return the language under which the application is running */
  g_language := 'english';

  /* instantiate common error messages */
  g_thing_already_exists := get_error_message( 'HWAYS' ,122);
  g_thing_does_not_exist := get_error_message( 'HWAYS' ,121);
END hig;
/
