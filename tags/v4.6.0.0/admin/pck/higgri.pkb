CREATE OR REPLACE PACKAGE BODY higgri AS
--   SCCS Identifiers :-
--
--       sccsid           : @(#)higgri.pkb	1.13 02/12/07
--       Module Name      : higgri.pkb
--       Date into SCCS   : 07/02/12 16:02:06
--       Date fetched Out : 07/06/13 14:10:35
--       SCCS Version     : 1.13
--
-- As fetched originally for NM3
--       sccsid           : @(#)higgri.pck	1.7 10/09/98
--       Module Name      : higgri.pck
--       Date into SCCS   : 98/10/09 10:57:15
--       Date fetched Out : 00/03/01 13:46:11
--       SCCS Version     : 1.7
--
--
--   Author :
--
--   The GRI package
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2000
-----------------------------------------------------------------------------
--
   g_body_sccsid     CONSTANT  varchar2(80) := '"$Revision:   2.11  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30) := 'higgri';
--
   c_gri_date_format CONSTANT  varchar2(11) := 'dd-mon-yyyy';
--
   g_gri_exc_code  binary_integer;
   g_gri_exc_msg   varchar2(2000);
   g_gri_exception EXCEPTION;
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
  FUNCTION is_module_gri( p_module IN hig_modules.hmo_module%TYPE
                        ) RETURN boolean IS
--
    CURSOR c1 (c_module hig_modules.hmo_module%TYPE) IS
      SELECT 1
       FROM  hig_modules
      WHERE  hmo_module  = p_module
       AND   hmo_use_gri = 'Y';
--
    l_dummy binary_integer;
    retval  boolean;
--
  BEGIN
    OPEN  c1 (p_module);
    FETCH c1 INTO l_dummy;
    retval := c1%FOUND;
    CLOSE c1;
--
    RETURN retval;
  END is_module_gri;
--
----------------------------------------------------------------------------------
--
  PROCEDURE parse_query (p_query     IN     varchar2
                        ,p_cursor_id IN OUT integer
                        ) AS
  BEGIN
    p_cursor_id := dbms_sql.open_cursor;
    dbms_sql.parse(p_cursor_id, p_query, dbms_sql.native);
  END parse_query;
--
----------------------------------------------------------------------------------
--
  PROCEDURE bind_query (p_cursor_id IN integer
                       ,p_variable  IN varchar2
                       ,p_value     IN varchar2
                       ,p_datatype  IN varchar2
                       ) AS
  BEGIN
    IF UPPER(p_datatype) = 'CHAR'
     THEN
      dbms_sql.bind_variable(p_cursor_id
                            ,p_variable
                            ,p_value
                            );
    ELSIF UPPER(p_datatype) = nm3type.c_date
     THEN
      dbms_sql.bind_variable(p_cursor_id
                            ,p_variable
                            ,TO_DATE(p_value,c_gri_date_format)
                            );
    ELSIF UPPER(p_datatype) = 'NUMBER'
     THEN
      dbms_sql.bind_variable(p_cursor_id
                            ,p_variable
                            ,TO_NUMBER(p_value)
                            );
    END IF;
  END bind_query;
--
----------------------------------------------------------------------------------
--
  PROCEDURE execute_query(p_cursor_id IN OUT integer) AS
    l_status integer;
  BEGIN
    l_status := dbms_sql.EXECUTE(p_cursor_id);
    dbms_sql.close_cursor(p_cursor_id);
  END execute_query;
--
----------------------------------------------------------------------------------
--
  PROCEDURE prepare_query(p_job_id IN number
                         ,p_param  IN gri_run_parameters.grp_param%TYPE
                         ,p_query  IN OUT varchar2
                         ,p_module IN varchar2) IS
      l_no_of_occurances number;
      l_indep_param      gri_param_dependencies.gpd_indep_param%TYPE;
      l_new_params       varchar2(500);
      l_datatype         gri_params.gp_param_type%TYPE;
      l_value            gri_run_parameters.grp_value%TYPE;
      l_temp_value       gri_run_parameters.grp_value%TYPE;
  --
      CURSOR c1 IS
        SELECT COUNT(0)
              ,gpd_indep_param
        FROM   gri_param_dependencies
              ,gri_params
              ,gri_run_parameters
        WHERE  gpd_module = p_module
        AND    gpd_dep_param = p_param
        AND    gp_param = p_param
        AND    grp_param = gpd_indep_param
        AND    grp_job_id = p_job_id
        GROUP BY gpd_indep_param;
   --
    BEGIN
      OPEN c1;
      LOOP
        FETCH c1 INTO l_no_of_occurances
                     ,l_indep_param;
        IF c1%NOTFOUND THEN
          EXIT;
        END IF;
        FOR i IN 1..l_no_of_occurances
        LOOP
          IF i = 1 THEN
            l_new_params := ':'||l_indep_param||TO_CHAR(i);
          ELSE
            l_new_params := l_new_params||',:'||l_indep_param||TO_CHAR(i);
          END IF;
        END LOOP;
        p_query := REPLACE(p_query,':'||l_indep_param,l_new_params);
      END LOOP;
      CLOSE c1;
  END prepare_query;
--
----------------------------------------------------------------------------------
--
  PROCEDURE bind_tag_variables(p_job_id    IN number
                              ,p_cursor_id IN integer
                              ,p_param     IN gri_run_parameters.grp_param%TYPE
                               ) AS
      l_cursor_id        integer;
      l_no_of_occurances number;
      l_datatype         gri_params.gp_param_type%TYPE;
      l_value            gri_run_parameters.grp_value%TYPE;
  --
      CURSOR c1 IS
        SELECT COUNT(0)
        FROM   gri_run_parameters
        WHERE  grp_param = p_param
        AND    grp_job_id = p_job_id;
  --
      CURSOR c2 IS
        SELECT gp_param_type
              ,grp_value
        FROM   gri_params
              ,gri_run_parameters
        WHERE  gp_param = p_param
        AND    grp_param = p_param
        AND    grp_job_id = p_job_id;
  --
  BEGIN
    OPEN c1;
    LOOP
      FETCH c1 INTO l_no_of_occurances;
      IF c1%NOTFOUND THEN
        EXIT;
      END IF;
      OPEN c2;
      FOR i IN 1..l_no_of_occurances
      LOOP
        FETCH c2 INTO l_datatype
                     ,l_value;
        IF c2%NOTFOUND THEN
          EXIT;
        END IF;
        higgri.bind_query(p_cursor_id
                      ,p_param||TO_CHAR(i)
                      ,l_value
                      ,l_datatype);
      END LOOP;
      CLOSE c2;
    END LOOP;
    CLOSE c1;
  END bind_tag_variables;
--
----------------------------------------------------------------------------------
--
  PROCEDURE bind_variables(p_job_id    IN number
                          ,p_cursor_id IN integer
                          ,p_param     IN gri_run_parameters.grp_param%TYPE
                          ,p_module    IN varchar2) AS
      l_cursor_id        integer;
      l_no_of_occurances number;
      l_indep_param      gri_param_dependencies.gpd_indep_param%TYPE;
      l_datatype         gri_params.gp_param_type%TYPE;
      l_value            gri_run_parameters.grp_value%TYPE;
  --
      CURSOR c1 IS
        SELECT COUNT(0)
              ,gpd_indep_param
        FROM   gri_param_dependencies
              ,gri_run_parameters
        WHERE  gpd_module = p_module
        AND    gpd_dep_param = p_param
        AND    grp_param = gpd_indep_param
        AND    grp_job_id = p_job_id
        GROUP BY gpd_indep_param;
  --
      CURSOR c2 IS
        SELECT gp_param_type
              ,grp_value
        FROM   gri_param_dependencies
              ,gri_params
              ,gri_run_parameters
        WHERE  gpd_module = p_module
        AND    gpd_dep_param = p_param
        AND    gp_param = grp_param
        AND    grp_param = gpd_indep_param
        AND    gpd_indep_param = l_indep_param
        AND    grp_job_id = p_job_id;
  --
  BEGIN
    OPEN c1;
    LOOP
      FETCH c1 INTO l_no_of_occurances
                   ,l_indep_param;
      IF c1%NOTFOUND THEN
        EXIT;
      END IF;
      OPEN c2;
      FOR i IN 1..l_no_of_occurances
      LOOP
        FETCH c2 INTO l_datatype
                     ,l_value;
        IF c2%NOTFOUND THEN
          EXIT;
        END IF;
        higgri.bind_query(p_cursor_id
                      ,l_indep_param||TO_CHAR(i)
                      ,l_value
                      ,l_datatype);
      END LOOP;
      CLOSE c2;
    END LOOP;
    CLOSE c1;
  END bind_variables;
--
----------------------------------------------------------------------------------
--
  PROCEDURE construct_lov(p_job_id   IN  number
                         ,p_param    IN  gri_run_parameters.grp_param%TYPE
                         ,p_module   IN  varchar2
			 ,p_restrict IN  varchar2
                         ,p_pipename IN  varchar2) AS
      l_table        gri_params.gp_table%TYPE;
      l_column       gri_params.gp_column%TYPE;
      l_descr_column gri_params.gp_descr_column%TYPE;
      l_shown_column gri_params.gp_shown_column%TYPE;
      l_where        gri_module_params.gmp_where%TYPE;
      l_query        varchar2(32767);
      l_cursor_id    integer;
      l_pipe_status  integer;
  --
      CURSOR c1 IS
        SELECT 'INSERT INTO gri_lov (gl_job_id, gl_param, gl_return, '||
               'gl_descr, gl_shown) SELECT '||TO_CHAR(p_job_id)||', '||
                nm3flx.string(p_param)||', '||gp_column||', '||gp_descr_column||
                ', '||gp_shown_column||' FROM '||gp_table||
		DECODE(p_restrict, NULL,
                       DECODE(gmp_where,NULL,'',' WHERE '||gmp_where),
		       ' WHERE '||p_restrict||
                       DECODE(gmp_where,NULL,'',' AND '||gmp_where))
        FROM   gri_params
              ,gri_module_params
        WHERE  gp_param = p_param
        AND    gmp_param = p_param
        AND    gmp_module = p_module;
  --
  BEGIN
    DELETE
    FROM   gri_lov
    WHERE  gl_job_id = p_job_id
    AND    gl_param  = p_param;
  --
    OPEN c1;
    FETCH c1 INTO l_query;
    IF c1%NOTFOUND THEN
      Raise_Application_Error(-20001,
                              hig.get_error_message('hways' ,134));
      CLOSE c1;
    END IF;
    CLOSE c1;
  --
    higgri.prepare_query(p_job_id
                     ,p_param
                     ,l_query
                     ,p_module);

    dbms_pipe.pack_message(l_query);
    l_pipe_status := dbms_pipe.send_message(p_pipename);
    IF l_pipe_status != 0 THEN
      Raise_Application_Error(-20001,
                              hig.get_error_message('hways' ,141));
    END IF;
    higgri.parse_query(l_query
                   ,l_cursor_id);

    higgri.bind_variables(p_job_id
                      ,l_cursor_id
                      ,p_param
                      ,p_module);

    higgri.execute_query(l_cursor_id);
  END construct_lov;
--
----------------------------------------------------------------------------------
--
  PROCEDURE prepare_tag_query(p_job_id IN number
                             ,p_param  IN gri_run_parameters.grp_param%TYPE
                             ,p_query  IN OUT varchar2) AS
      l_no_of_occurances number;
      l_indep_param      gri_param_dependencies.gpd_indep_param%TYPE;
      l_new_params       varchar2(500);
      l_datatype         gri_params.gp_param_type%TYPE;
      l_value            gri_run_parameters.grp_value%TYPE;
      l_temp_value       gri_run_parameters.grp_value%TYPE;
  --
      CURSOR c1 IS
        SELECT COUNT(0)
              ,grp_param
        FROM   gri_run_parameters
        WHERE  grp_param = p_param
        AND    grp_job_id = p_job_id
        GROUP BY grp_param;
  --
    BEGIN
      OPEN c1;
      LOOP
        FETCH c1 INTO l_no_of_occurances
                     ,l_indep_param;
        IF c1%NOTFOUND THEN
          EXIT;
        END IF;
        FOR i IN 1..l_no_of_occurances
        LOOP
          IF i = 1 THEN
            l_new_params := ':'||l_indep_param||TO_CHAR(i);
          ELSE
            l_new_params := l_new_params||',:'||l_indep_param||TO_CHAR(i);
          END IF;
        END LOOP;
      END LOOP;
      CLOSE c1;
      p_query := REPLACE(p_query,':'||l_indep_param,l_new_params);
  END prepare_tag_query;
--
----------------------------------------------------------------------------------
--
  PROCEDURE populate_tags(p_job_id IN  number
                         ,p_module IN  varchar2) AS
      l_query     varchar2(32767);
      l_temp      varchar2(2000);
      l_param     gri_run_parameters.grp_param%TYPE;
      l_cursor_id integer;
	l_tag_column_type	varchar2(30);
	l_varchar2	varchar2(30):=nm3type.c_varchar;

	CURSOR col_type IS
	  SELECT data_type FROM all_tab_columns,gri_modules
		WHERE owner = sys_context('NM3CORE', 'APPLICATION_OWNER')
		AND table_name = grm_tag_table
		AND column_name = grm_tag_column
		AND grm_module = p_module;

      CURSOR c1 IS
        SELECT 'INSERT INTO report_tags(rtg_job_id,rtg_tag_id,rtg_tag_id_char) (SELECT '||
               TO_CHAR(p_job_id)||','||DECODE(l_tag_column_type,l_varchar2,'ROWNUM',grm_tag_column)||','||grm_tag_column||' FROM '||
               grm_tag_table||' WHERE '||DECODE(grm_tag_where,NULL,NULL,
               grm_tag_where||' AND ')
        FROM   gri_modules
        WHERE  grm_module = p_module;

      CURSOR c2 IS
        SELECT NVL(gmp_tag_where,'1 = 1')
              ,grp_param
        FROM   gri_run_parameters
              ,gri_module_params
        WHERE  grp_job_id = p_job_id
        AND    gmp_module = p_module
        AND    gmp_param = grp_param
        AND    UPPER(gmp_tag_restriction) = 'Y'
        AND    grp_value IS NOT NULL
        GROUP  BY grp_param
                 ,gmp_tag_where;
    BEGIN
	/* Get object column type */
	OPEN col_type;
	FETCH col_type INTO l_tag_column_type;
	IF col_type%NOTFOUND THEN
		CLOSE col_type;
	      Raise_Application_Error(-20001,
                                hig.get_error_message('hways', 150,'owner',' find tag COLUMN TYPE'));
	END IF;
	CLOSE col_type;

      /* construct initial insert statement */
      OPEN c1;
      FETCH c1 INTO l_query;
      IF c1%NOTFOUND THEN
        Raise_Application_Error(-20001,
                                hig.get_error_message('hways', 133));
      END IF;
      CLOSE c1;
    /* concatenate tag_wheres for each parameter */
      OPEN c2;
      LOOP
        FETCH c2 INTO l_temp
                     ,l_param;
        IF c2%NOTFOUND THEN
          EXIT;
        END IF;
        l_query := l_query||l_temp||' AND ';
      END LOOP;
      CLOSE c2;
    /* remove trailing AND */
      l_query := SUBSTR(l_query,1,LENGTH(l_query) - 5)||')';
    /* expand any parameters into lists for multiple occurances */
      OPEN c2;
      LOOP
        FETCH c2 INTO l_temp
                     ,l_param;
        IF c2%NOTFOUND THEN
          EXIT;
        END IF;
        higgri.prepare_tag_query(p_job_id
                             ,l_param
                             ,l_query);
      END LOOP;
      CLOSE c2;
      higgri.parse_query(l_query
                     ,l_cursor_id);
    /* bind all variable in the query */
      OPEN c2;
      LOOP
        FETCH c2 INTO l_temp
                     ,l_param;
        IF c2%NOTFOUND THEN
          EXIT;
        END IF;
        higgri.bind_tag_variables(p_job_id
                              ,l_cursor_id
                              ,l_param);
      END LOOP;
      CLOSE c2;
      higgri.execute_query(l_cursor_id);
  END populate_tags;
--
----------------------------------------------------------------------------------
--
  PROCEDURE get_defaults(p_job_id IN number
                        ,p_module IN varchar2) AS

  -- 12/02/2007  CParkinson  Test Id 47393 - Fix bug when default 
  --                         value and LoV for a param.

    l_query     varchar(32767);
    l_set       varchar(32767);
    l_param     gri_run_parameters.grp_param%TYPE;
    l_lov       gri_module_params.gmp_lov%TYPE;
    l_gazetteer gri_module_params.gmp_gazetteer%TYPE;
    l_def_table gri_module_params.gmp_default_table%TYPE;
    l_def_col   gri_module_params.gmp_default_column%TYPE;
    l_cursor_id integer;
  --
    CURSOR c1 IS
      SELECT grp_param
            ,gmp_lov
            ,gmp_gazetteer
            ,gmp_default_table
            ,gmp_default_column         -- CP 12/02/2007
      FROM   gri_run_parameters
            ,gri_module_params
      WHERE  grp_job_id = p_job_id
      AND    gmp_param = grp_param
      AND    gmp_module = p_module;
  --
    CURSOR c2 IS
      SELECT 'UPDATE gri_run_parameters SET (grp_value'||
                                           ',grp_shown) ='||
             '(SELECT '||gmp_default_column||','||gmp_default_column||
             ' FROM '||gmp_default_table||' WHERE '||
             NVL(gmp_default_where,'1=1')||') WHERE grp_job_id = '
             ||TO_CHAR(p_job_id)||' AND grp_param = '||nm3flx.string(l_param)
      FROM   gri_module_params
      WHERE  gmp_module = p_module
      AND    gmp_param = l_param;
--
    CURSOR c3 IS
      SELECT 'UPDATE gri_run_parameters '||
             'SET (grp_descr,grp_shown) ='||
             '(SELECT '||gp_descr_column||','||gp_shown_column||
             ' FROM '||gp_table||' WHERE '||gp_column||' = grp_value AND '||
             NVL(gmp_default_where,'1=1')||')'||
             ' WHERE grp_job_id = '||TO_CHAR(p_job_id)||' AND grp_param = '||nm3flx.string(l_param)
      FROM   gri_module_params
            ,gri_params
      WHERE  gp_param   = l_param
      AND    gp_param   = gmp_param
      AND    gmp_module = p_module;
      
    -- CP 12/02/2007
    CURSOR c4 IS
      SELECT 'UPDATE gri_run_parameters '||
             'SET grp_descr = ''LIKE %'''||
             ' WHERE grp_job_id = '||TO_CHAR(p_job_id)||' AND grp_param = '||nm3flx.string(l_param)
      FROM   gri_module_params
            ,gri_params
      WHERE  gp_param   = l_param
      AND    gp_param   = gmp_param
      AND    gmp_module = p_module;

--
    BEGIN
    
      OPEN c1;
      LOOP
        FETCH c1 INTO l_param                    -- retrieve parameter to default
                     ,l_lov
                     ,l_gazetteer
                     ,l_def_table
                     ,l_def_col;                 -- CP 12/02/2007
        IF c1%NOTFOUND THEN
          EXIT;
        END IF;

        IF l_def_table IS NOT NULL THEN          -- only do if default exists
          OPEN c2;
          FETCH c2 INTO l_query;                 -- populate default value
          IF c2%FOUND THEN                       -- (same value in shown column
            higgri.parse_query(l_query           --  incase no LOV to populate it)
                              ,l_cursor_id);
            higgri.execute_query(l_cursor_id);


            -- CP 12/02/2007 Allow a default of % (do not overwrite shown with null)
            IF UPPER(l_lov) = 'Y' OR UPPER(l_gazetteer) = 'Y' THEN
            
              
              -- Have to check for '%' as this is how defined in GRI data!
              if l_def_col != '''%''' then
                OPEN c3;                     -- if LOV or GAZ then populate shown
                FETCH c3 INTO l_query;       -- and description columns
                IF c3%FOUND THEN
                  higgri.parse_query(l_query
                                    ,l_cursor_id);
                  higgri.execute_query(l_cursor_id);
                END IF;
                CLOSE c3;
                
              else
                open c4;
                fetch c4 into l_query;
                if c4%FOUND then
                  higgri.parse_query(l_query
                                    ,l_cursor_id);
                  higgri.execute_query(l_cursor_id);
                end if;
                close c4;                 
              end if;
              
            END IF;

          END IF;
          CLOSE c2;

        END IF;
      END LOOP;
      CLOSE c1;
  END get_defaults;
--
----------------------------------------------------------------------------------
--
  /* procedure to retrieve all the parameters required by a particular
     module. */
  PROCEDURE get_params(p_module IN  varchar2
                      ,p_job_id IN  OUT number) AS
      CURSOR c1 IS
        SELECT rtg_job_id_seq.NEXTVAL
        FROM   dual;
    --
  BEGIN
      OPEN c1;
      FETCH c1 INTO p_job_id;
      IF c1%NOTFOUND THEN
        CLOSE c1;
        Raise_Application_Error(-20001,
                                hig.get_error_message('hways', 135));
      END IF;
      CLOSE c1;
    --
      INSERT INTO gri_run_parameters ( grp_job_id
                                      ,grp_seq
                                      ,grp_param
                                      ,grp_visible )
                              SELECT   p_job_id
                                      ,gmp_seq
                                      ,gmp_param
                                      ,gmp_visible
                              FROM     gri_module_params
                              WHERE    gmp_module = p_module;
  END get_params;
--
----------------------------------------------------------------------------------
--
  PROCEDURE set_param(pi_job_id IN gri_report_runs.grr_job_id%TYPE
                     ,pi_param  IN gri_run_parameters.grp_param%TYPE
                     ,pi_value  IN gri_run_parameters.grp_value%TYPE
                     ) IS
  BEGIN
    UPDATE
      gri_run_parameters
    SET
      grp_value = pi_value
    WHERE
      grp_job_id = pi_job_id
    AND
      grp_param = pi_param;
  END set_param;
--
----------------------------------------------------------------------------------
--
  PROCEDURE validate_date(p_value IN varchar2) AS
      l_temp_date    DATE;
      l_invalid_date EXCEPTION;
  BEGIN
      IF LENGTH(p_value) < 9
       THEN
         RAISE l_invalid_date;
      END IF;
      FOR i IN 1..LENGTH(p_value)
      LOOP
        IF i < 3 AND SUBSTR(p_value,i,1) NOT BETWEEN '0' AND '9' THEN
             RAISE l_invalid_date;
        ELSIF (i = 3 OR i = 7) AND SUBSTR(p_value,i,1) != '-' THEN
            RAISE l_invalid_date;
        ELSIF i BETWEEN 4 AND 6 AND
              SUBSTR(p_value,i,1) NOT BETWEEN 'a' AND 'z' AND
              SUBSTR(p_value,i,1) NOT BETWEEN 'a' AND 'z' THEN
           RAISE l_invalid_date;
        ELSIF i > 7 AND SUBSTR(p_value,i,1) NOT BETWEEN '0' AND '9' THEN
          RAISE l_invalid_date;
        END IF;
      END LOOP;
      l_temp_date := TO_DATE(p_value,c_gri_date_format);
  EXCEPTION
     WHEN l_invalid_date
      THEN
         Raise_Application_Error(-20001,hig.get_error_message('hways', 140));
  END validate_date;
--
----------------------------------------------------------------------------------
--
  PROCEDURE validate_number(p_value IN varchar2) AS
  BEGIN
     IF NOT nm3flx.is_numeric (p_value)
      THEN
        Raise_Application_Error(-20001,hig.get_error_message('hways', 129));
     END IF;
  END validate_number;
--
----------------------------------------------------------------------------------
--
  PROCEDURE validate_int(p_value IN varchar2) AS
  BEGIN
    FOR i IN 1..LENGTH(p_value)
    LOOP
      IF (ASCII(SUBSTR(p_value,i,1)) NOT BETWEEN 48 AND 57) -- NOT BETWEEN '0' AND '9'
       THEN
        Raise_Application_Error(-20001,
                                hig.get_error_message('hways', 129));
      END IF;
    END LOOP;
  END validate_int;
--
----------------------------------------------------------------------------------
--
  PROCEDURE validate_type(p_type  IN varchar2
                         ,p_value IN varchar2
                         ) AS
      l_temp_date DATE;
    BEGIN
      IF p_type = 'number' THEN
        higgri.validate_number(p_value);
      ELSIF p_type = 'INT' THEN
        higgri.validate_int(p_value);
      ELSIF p_type = nm3type.c_date THEN
        higgri.validate_date(p_value);
      END IF;
  END validate_type;
--
----------------------------------------------------------------------------------
--
  PROCEDURE validate_param(p_job_id    IN number
                          ,p_param     IN gri_run_parameters.grp_param%TYPE
			  ,p_value     IN gri_run_parameters.grp_value%TYPE
                          ,p_module    IN varchar2
                          ,p_pipename  IN  varchar2) AS
      l_indep_param      gri_param_dependencies.gpd_indep_param%TYPE;
      l_datatype         gri_params.gp_param_type%TYPE;
      l_value            gri_run_parameters.grp_value%TYPE;
      l_query            varchar2(2000);
      l_cursor_id        integer;
      l_status           integer;
      l_pipe_status      integer;
  --
      CURSOR c1 IS
	SELECT 'SELECT 1 FROM dual WHERE '||NVL(gmp_where, '1=1')
	FROM   gri_module_params
        WHERE  gmp_module = p_module
        AND    gmp_param = p_param;
  --
      CURSOR c2 IS
        SELECT gpd_indep_param
	      ,gp_param_type
              ,DECODE(gpd_indep_param, p_param, p_value, grp_value)
        FROM   gri_param_dependencies
              ,gri_params
              ,gri_run_parameters
        WHERE  gpd_module = p_module
        AND    gpd_dep_param = p_param
        AND    gp_param = grp_param
        AND    grp_param = gpd_indep_param
        AND    grp_job_id = p_job_id
	ORDER BY grp_param;
  --
  BEGIN
    OPEN c1;
    FETCH c1 INTO l_query;
    CLOSE c1;
  --
    dbms_pipe.pack_message(l_query);
    l_pipe_status := dbms_pipe.send_message(p_pipename);
    IF l_pipe_status != 0 THEN
      Raise_Application_Error(-20001,
                              hig.get_error_message('hways' ,141));
    END IF;
  --
    higgri.parse_query(l_query
                   ,l_cursor_id);
  --
    OPEN c2;
    LOOP
      FETCH c2 INTO l_indep_param
		   ,l_datatype
		   ,l_value;
      IF c2%NOTFOUND THEN
        EXIT;
      END IF;
      higgri.bind_query(l_cursor_id
                    ,l_indep_param
		    ,l_value
		    ,l_datatype);
    END LOOP;
    CLOSE c2;
  --
    l_status := dbms_sql.EXECUTE( l_cursor_id );
    IF dbms_sql.fetch_rows(l_cursor_id) = 0 THEN
      Raise_Application_Error(-20001,
                              hig.get_error_message('hways' ,178));
    END IF;
  END validate_param;
--
----------------------------------------------------------------------------------
--
  PROCEDURE load_params (p_job_id   IN integer
                        ,p_username IN varchar2
                        ,p_module   IN varchar2
                        ,p_descr    IN varchar2) AS
  BEGIN
    DELETE FROM gri_run_parameters
    WHERE       grp_job_id = p_job_id;

    INSERT INTO gri_run_parameters (grp_job_id
                                   ,grp_seq
                                   ,grp_param
                                   ,grp_value
                                   ,grp_visible
                                   ,grp_descr
                                   ,grp_shown)
    SELECT                          p_job_id
                                   ,gsp_seq
                                   ,gsp_param
                                   ,gsp_value
                                   ,gsp_visible
                                   ,gsp_descr
                                   ,gsp_shown
    FROM                            gri_saved_params
                                   ,gri_saved_sets
    WHERE                           gss_id = gsp_gss_id
    AND                             gss_username = p_username
    AND                             gss_module = p_module
    AND                             gss_descr = p_descr;
  END load_params;
--
----------------------------------------------------------------------------------
--
  PROCEDURE save_params (p_job_id   IN integer
                        ,p_username IN varchar2
                        ,p_module   IN varchar2
                        ,p_descr    IN varchar2) AS
  BEGIN
    INSERT INTO gri_saved_sets (gss_id
                               ,gss_username
                               ,gss_module
                               ,gss_descr)
    VALUES                     (gss_id_seq.NEXTVAL
                               ,p_username
                               ,p_module
                               ,p_descr);
    INSERT INTO gri_saved_params (gsp_gss_id
                                 ,gsp_seq
                                 ,gsp_param
                                 ,gsp_value
                                 ,gsp_visible
                                 ,gsp_shown
                                 ,gsp_descr)
    SELECT                        gss_id_seq.CURRVAL
                                 ,grp_seq
                                 ,grp_param
                                 ,grp_value
                                 ,grp_visible
                                 ,grp_shown
                                 ,grp_descr
    FROM                          gri_run_parameters
    WHERE                         grp_job_id = p_job_id;
  END save_params;
--
----------------------------------------------------------------------------------
--
  PROCEDURE gri_batch_job ( p_username IN varchar2,
                            p_pwd      IN varchar2,
			    p_module IN varchar2,
			    p_param_set IN varchar2,
			    p_job_id OUT number ) IS

    l_job_id number(9);
    l_module varchar2(30) := p_module;
    l_descr  varchar2(30) := p_param_set;
    l_type   gri_modules.grm_module_type%TYPE := get_module_type ( p_module );

    CURSOR c1 IS
      SELECT rtg_job_id_seq.NEXTVAL FROM dual;

    send_error EXCEPTION;
    table_locked EXCEPTION;
    PRAGMA EXCEPTION_INIT( send_error, -20000 );
    PRAGMA EXCEPTION_INIT( table_locked, -54 );

    l_lsnr varchar2(10) := NVL(hig.get_sysopt('grilstname'),'lstner');

    spool_file varchar2(43);

    host_string varchar2(2000);

  BEGIN
    OPEN c1;
    FETCH c1 INTO l_job_id;
    CLOSE c1;

    higgri.load_params( l_job_id, Sys_Context('NM3_SECURITY_CTX','USERNAME'), l_module, l_descr );

    IF l_type = 'svr' THEN
       LOCK TABLE exor_lock IN EXCLUSIVE MODE NOWAIT;
       dbms_output.put_line( 'listener IS NOT running');
    ELSE
       p_job_id := l_job_id;
       batch_job_id := l_job_id;
    END IF;
--
--    module is client based - possibly runrep etc - just return the job_id and let it be executed from elsewhere
--
  EXCEPTION
    WHEN send_error THEN
       dbms_output.put_line('error sending job TO the server');
     WHEN table_locked THEN
       make_report_run ( Sys_Context('NM3_SECURITY_CTX','USERNAME'), l_module, l_job_id );
       host_string := p_module||' '||p_username||'/'||p_pwd||' '||TO_CHAR(l_job_id);
       COMMIT;
       hig.pipe_send( host_string, l_lsnr );
  END;
--
----------------------------------------------------------------------------------
--
  PROCEDURE make_report_run ( p_username IN varchar2,
			      p_module   IN varchar2,
			      p_job_id   IN number ) IS

  BEGIN
    INSERT INTO gri_report_runs (
         grr_job_id,
         grr_module,
         grr_username,
         grr_submit_date,
         grr_act_start_date)
    VALUES
	 ( p_job_id, p_module, p_username, SYSDATE, SYSDATE );
  END;
--
----------------------------------------------------------------------------------
--
  FUNCTION get_batch_job_id RETURN number IS
  BEGIN
    RETURN batch_job_id;
  END;
--
----------------------------------------------------------------------------------
--
  FUNCTION get_module_type ( p_module IN varchar2 ) RETURN varchar2 IS

  CURSOR c1 IS
    SELECT hmo_module_type FROM hig_modules
    WHERE hmo_module = p_module;

  retval hig_modules.hmo_module_type%TYPE;

  BEGIN
    OPEN c1;
    FETCH c1 INTO retval;
    CLOSE c1;

    RETURN retval;
  END;
--
----------------------------------------------------------------------------------
--
  FUNCTION get_module_spoolfile
	(a_job_id	IN	integer
	,a_module	IN	varchar2
  ) RETURN varchar2 AS

    CURSOR c1 IS
      SELECT grm.grm_file_type
      FROM   gri_modules grm
      WHERE  grm.grm_module = a_module
      ;
    l_file_type		gri_modules.grm_file_type%TYPE;

  BEGIN
    OPEN  c1;
    FETCH c1 INTO l_file_type;
    CLOSE c1;
    RETURN TO_CHAR( a_job_id)||'.'||l_file_type;
  END get_module_spoolfile;
--
----------------------------------------------------------------------------------
--
FUNCTION get_grr (p_grr_job_id IN gri_report_runs.grr_job_id%TYPE
                 ) RETURN gri_report_runs%ROWTYPE IS
--
   CURSOR cs_grr (c_grr_job_id gri_report_runs.grr_job_id%TYPE) IS
   SELECT *
    FROM  gri_report_runs
   WHERE  grr_job_id = c_grr_job_id;
--
   l_rec_grr gri_report_runs%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_grr');
--
   OPEN  cs_grr (p_grr_job_id);
   FETCH cs_grr INTO l_rec_grr;
   IF cs_grr%NOTFOUND
    THEN
      CLOSE cs_grr;
      g_gri_exc_code := -20071;
      g_gri_exc_msg  := 'gri_report_runs record not found';
      RAISE g_gri_exception;
   END IF;
   CLOSE cs_grr;
--
   nm_debug.proc_end(g_package_name,'get_grr');
--
   RETURN l_rec_grr;
--
EXCEPTION
--
   WHEN g_gri_exception
    THEN
      Raise_Application_Error(g_gri_exc_code,g_gri_exc_msg);
--
END get_grr;
--
----------------------------------------------------------------------------------
--
FUNCTION get_grm (p_grm_module IN gri_modules.grm_module%TYPE
                 ) RETURN gri_modules%ROWTYPE IS
--
   CURSOR cs_grm (c_grm_module gri_modules.grm_module%TYPE) IS
   SELECT *
    FROM  gri_modules
   WHERE  grm_module = upper(c_grm_module);
--
   l_rec_grm gri_modules%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_grm');
--
   OPEN  cs_grm (p_grm_module);
   FETCH cs_grm INTO l_rec_grm;
   IF cs_grm%NOTFOUND
    THEN
      CLOSE cs_grm;
      g_gri_exc_code := -20072;
      g_gri_exc_msg  := 'gri_modules record not found';
      RAISE g_gri_exception;
   END IF;
   CLOSE cs_grm;
--
   nm_debug.proc_end(g_package_name,'get_grm');
--
   RETURN l_rec_grm;
--
EXCEPTION
--
   WHEN g_gri_exception
    THEN
      Raise_Application_Error(g_gri_exc_code,g_gri_exc_msg);
--
END get_grm;
--
----------------------------------------------------------------------------------
--
FUNCTION get_gp (p_gp_param IN gri_params.gp_param%TYPE
                ) RETURN gri_params%ROWTYPE IS
--
   CURSOR cs_gp (c_gp_param IN gri_params.gp_param%TYPE) IS
   SELECT *
    FROM  gri_params
   WHERE  gp_param = p_gp_param;
--
   l_rec_gp gri_params%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_gp');
--
   OPEN  cs_gp (p_gp_param);
   FETCH cs_gp INTO l_rec_gp;
   IF cs_gp%NOTFOUND
    THEN
      CLOSE cs_gp;
      g_gri_exc_code := -20073;
      g_gri_exc_msg  := 'gri_params record not found';
      RAISE g_gri_exception;
   END IF;
   CLOSE cs_gp;
--
   nm_debug.proc_end(g_package_name,'get_gp');
--
   RETURN l_rec_gp ;
--
EXCEPTION
--
   WHEN g_gri_exception
    THEN
      Raise_Application_Error(g_gri_exc_code,g_gri_exc_msg);
--
END get_gp;
--
----------------------------------------------------------------------------------
--
FUNCTION get_tab_rec_grp (p_grp_job_id IN gri_run_parameters.grp_job_id%TYPE) RETURN nm3type.tab_rec_grp IS
--
   CURSOR cs_grp (c_grp_job_id gri_run_parameters.grp_job_id%TYPE) IS
   SELECT *
    FROM  gri_run_parameters
   WHERE  grp_job_id = c_grp_job_id
   ORDER BY grp_param;
--
   l_tab_rec_grp nm3type.tab_rec_grp;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_tab_rec_grp');
--
   FOR cs_rec IN cs_grp (p_grp_job_id)
    LOOP
      l_tab_rec_grp(l_tab_rec_grp.COUNT+1) := cs_rec;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'get_tab_rec_grp');
--
   RETURN l_tab_rec_grp;
--
END get_tab_rec_grp;
--
----------------------------------------------------------------------------------
--
FUNCTION get_tab_grp_value_from_tab_grp (p_tab_grp   IN nm3type.tab_rec_grp
                                        ,p_grp_param IN gri_run_parameters.grp_param%TYPE
                                        ) RETURN nm3type.tab_varchar2000 IS
--
   l_tab_value nm3type.tab_varchar2000;
--
BEGIN
--
   FOR i IN 1..p_tab_grp.COUNT
    LOOP
      IF p_tab_grp(i).grp_param = p_grp_param
       THEN
         l_tab_value(l_tab_value.COUNT+1) := p_tab_grp(i).grp_value;
      END IF;
   END LOOP;
--
   RETURN l_tab_value;
--
END get_tab_grp_value_from_tab_grp;
--
----------------------------------------------------------------------------------
--
FUNCTION execute_pre_process (p_grr_job_id IN gri_report_runs.grr_job_id%TYPE
                             ) RETURN hig_modules.hmo_filename%TYPE IS
--
   l_rec_grr           gri_report_runs%ROWTYPE;
   l_rec_grm           gri_modules%ROWTYPE;
   l_tab_rec_grp       nm3type.tab_rec_grp;
--
   l_tab_bind_var      nm3type.tab_varchar30;
   l_tab_bind_val      nm3type.tab_varchar2000;
   l_tab_bind_datatype nm3type.tab_varchar30;
   l_tab_bind_pre      nm3type.tab_varchar30;
   l_tab_bind_post     nm3type.tab_varchar30;
   l_bind_var          varchar2(30);
   l_bind_counter      binary_integer := 1;
   l_clob              clob;
   l_do_it             BOOLEAN;
--
   c_assignment_repl CONSTANT VARCHAR2(5) := '^^^^^';
   c_assignment      CONSTANT VARCHAR2(2) := ':=';
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'execute_pre_process');
--
   higgri.gri_filename_to_execute := NULL;
--
   l_rec_grr     := get_grr (p_grr_job_id);
   l_rec_grm     := get_grm (l_rec_grr.grr_module);
   l_tab_rec_grp := get_tab_rec_grp (p_grr_job_id);
--
   higgri.gri_filename_to_execute := hig.get_file_name(l_rec_grm.grm_module);
--
   higgri.last_grr_job_id := p_grr_job_id;
--
   IF l_rec_grm.grm_pre_process IS NULL
    THEN
      nm_debug.proc_end(g_package_name,'execute_pre_process');
      RETURN higgri.gri_filename_to_execute;
   END IF;
--
   l_rec_grm.grm_pre_process := REPLACE(l_rec_grm.grm_pre_process,c_assignment,c_assignment_repl);
   -- Get all the bind variables into a pl/sql table
   l_bind_var := nm3flx.extract_bind_variable(l_rec_grm.grm_pre_process
                                             ,l_bind_counter
                                             );
--
   WHILE l_bind_var IS NOT NULL
    LOOP
      l_tab_bind_var(l_tab_bind_var.COUNT+1) := REPLACE(UPPER(l_bind_var),':',NULL);
      l_bind_counter                 := l_bind_counter + 1;
      l_bind_var                     := nm3flx.extract_bind_variable(l_rec_grm.grm_pre_process
                                                                    ,l_bind_counter
                                                                    );
   END LOOP;
--
   -- Append a ; to the end of the pre process if reqd.
   IF nm3flx.right(l_rec_grm.grm_pre_process,1) != ';'
    THEN
      l_rec_grm.grm_pre_process := l_rec_grm.grm_pre_process||';';
   END IF;
--
   IF l_tab_bind_var.COUNT = 0
    THEN
      --
      -- If there are no bind variables defined
      --
      EXECUTE IMMEDIATE 'BEGIN '||l_rec_grm.grm_pre_process||' END;';
      --
   ELSE
--
      FOR i IN 1..l_tab_bind_var.COUNT
       LOOP
         DECLARE
            l_tab_val  nm3type.tab_varchar2000;
            l_bind_var gri_module_params.gmp_param%TYPE := l_tab_bind_var(i);
            l_rec_gp   gri_params%ROWTYPE;
         BEGIN
   --
            l_tab_val := get_tab_grp_value_from_tab_grp(l_tab_rec_grp
                                                       ,l_bind_var
                                                       );
   --
            IF    l_tab_val.COUNT = 0
             THEN
               g_gri_exc_code := -20074;
               g_gri_exc_msg  := 'No value found for parameter '||l_bind_var||' in preprocess procedure';
               RAISE g_gri_exception;
            ELSIF l_tab_val.COUNT > 1
             THEN
               g_gri_exc_code := -20075;
               g_gri_exc_msg  := '>1 value found for parameter '||l_bind_var||' in preprocess procedure';
               RAISE g_gri_exception;
            END IF;
   --
            l_tab_bind_val(i) := l_tab_val(1);
   --
            l_rec_gp := get_gp (l_bind_var);
   --
            IF    l_rec_gp.gp_param_type IN ('CHAR',nm3type.c_varchar)
             THEN
               l_tab_bind_datatype(i) := 'nm3type.max_varchar2';
               l_tab_bind_pre(i)      := NULL;
               l_tab_bind_post(i)     := NULL;
            ELSIF l_rec_gp.gp_param_type = nm3type.c_date
             THEN
               l_tab_bind_datatype(i) := l_rec_gp.gp_param_type;
               l_tab_bind_pre(i)      := 'TO_DATE(';
               l_tab_bind_post(i)     := ','||nm3flx.string(c_gri_date_format)||')';
            ELSE -- It's a number
               l_tab_bind_datatype(i) := l_rec_gp.gp_param_type;
               l_tab_bind_pre(i)      := 'TO_NUMBER(';
               l_tab_bind_post(i)     := ')';
            END IF;
   --
         END;
      END LOOP;
--
--    OK build it all up then
--
      nm3clob.nullify_clob(l_clob);
      nm3clob.append(l_clob,'DECLARE');
      FOR i IN 1..l_tab_bind_var.COUNT
       LOOP
         l_do_it := TRUE;
         FOR j IN 1..(i-1)
          LOOP -- check to see if we've already done it
            IF l_tab_bind_var(i) = l_tab_bind_var(j)
             THEN
              l_do_it := FALSE;
               EXIT;
            END IF;
         END LOOP;
         IF l_do_it
          THEN
            nm3clob.append(l_clob,CHR(10)||'   '||l_tab_bind_var(i)||' '
                                                ||l_tab_bind_datatype(i)
                                                ||' := '
                                                ||l_tab_bind_pre(i)
                                                ||nm3flx.string(l_tab_bind_val(i))
                                                ||l_tab_bind_post(i)
                                                ||';'
                          );
         END IF;
      END LOOP;
      nm3clob.append(l_clob,CHR(10)||'BEGIN');
      nm3clob.append(l_clob,CHR(10)||'   '||REPLACE(REPLACE(l_rec_grm.grm_pre_process,':',NULL),c_assignment_repl,c_assignment));
      nm3clob.append(l_clob,CHR(10)||'END;');
--
--      nm_debug.delete_debug(TRUE);
--      nm_debug.debug_on;
--      nm_debug.debug_clob(l_clob);
--      COMMIT;
      nm3clob.execute_immediate_clob(l_clob);
--
   END IF;
--
   nm_debug.proc_end(g_package_name,'execute_pre_process');
--
   RETURN higgri.gri_filename_to_execute;
--
EXCEPTION
--
   WHEN g_gri_exception
    THEN
      nm_debug.debug(g_gri_exc_code||'-'||g_gri_exc_msg);
      Raise_Application_Error(g_gri_exc_code,g_gri_exc_msg);
--
END execute_pre_process;
--
----------------------------------------------------------------------------------
--
PROCEDURE pre_process(pi_job_id    IN     gri_report_runs.grr_job_id%TYPE
                     ,pio_filename IN OUT gri_report_runs.grr_report_dest%TYPE
                     ) IS

  l_initial_filename gri_report_runs.grr_report_dest%TYPE := pio_filename;

BEGIN
  pio_filename := higgri.execute_pre_process(p_grr_job_id => pi_job_id);

  IF pio_filename <> l_initial_filename
 	THEN
 	  UPDATE
 	    gri_report_runs
    SET
      grr_report_dest = pio_filename
 	  WHERE
 	    grr_job_id = pi_job_id;
  END IF;
END;
--
----------------------------------------------------------------------------------
--
FUNCTION get_last_grr_job_id RETURN gri_report_runs.grr_job_id%TYPE IS
BEGIN
   RETURN higgri.last_grr_job_id;
END get_last_grr_job_id;
--
----------------------------------------------------------------------------------
--
PROCEDURE validate_param_lov(pi_param                IN     gri_params.gp_param%TYPE
                            ,pi_lov_query            IN     varchar2
							,pi_number_of_query_cols IN PLS_INTEGER DEFAULT 3
                            ,pio_value               IN OUT gri_run_parameters.grp_value%TYPE
                            ,pio_shown               IN OUT gri_run_parameters.grp_shown%TYPE
                            ,pio_descr               IN OUT gri_run_parameters.grp_descr%TYPE
                                 ) IS

  e_value_not_found EXCEPTION;
  ex_non_numeric    EXCEPTION;
  e_too_many_rows   EXCEPTION;
  ex_invalid_date_format EXCEPTION;

  l_gp_rec gri_params%ROWTYPE;

  l_query varchar2(32767);

  l_match_col  varchar2(2000);
  l_match_val  varchar2(32767);
  l_untouched_match_val  varchar2(32767);  
  l_match_type varchar2(2000);

  TYPE cs_ref_t IS REF CURSOR;
  cs_param_lookup cs_ref_t;
  
  l_dummy      varchar2(2000);
  
  l_tab_value nm3type.tab_varchar2000;
  l_tab_shown nm3type.tab_varchar2000;
  l_tab_descr nm3type.tab_varchar2000;
  l_date_format VARCHAR2(100);  
  
  FUNCTION date_test_passed RETURN BOOLEAN IS
    l_date_test VARCHAR2(100);
  BEGIN
      l_date_format := NVL(hig.get_sysopt('GRIDATE'),'DD-MON-YYYY');
      l_date_test   := to_char(to_date(pio_value,l_date_format),l_date_format);
      l_date_test   := to_char(to_date(pio_shown,l_date_format),l_date_format);
	  RETURN(TRUE);	  
  EXCEPTION
     WHEN others THEN
      RETURN(FALSE);
  END date_test_passed;


BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'validate_param_lov');

  l_query := pi_lov_query;

  --get parameter details
  l_gp_rec := get_gp(p_gp_param => pi_param);

--
-- ensure that date format is as expected if not then chuck out the value
--
  IF l_gp_rec.gp_param_type = 'DATE'  THEN
     IF NOT date_test_passed THEN
	   RAISE ex_invalid_date_format;
     END IF;
  END IF;	     

  IF pi_number_of_query_cols = 3 THEN

      ----------------------------------------------------------------------------------
      -- if there is an order by on the query then drop this from the query otherwise
      -- in the next steps you'll end up adding in the matching restriction after the ORDER BY
      -- which results in an invalid sql statement
      --e.g. SELECT to_char(SWA_REF) shown, UPPER(SWA_NAME) descr, to_char(SWA_REF) value
      --     FROM
      --     SWR_ORGANISATIONS
      --     WHERE
      --     1=1
      --     ORDER BY UPPER(SWA_NAME)
      --     AND
      --     SWA_REF = 3700
      ----------------------------------------------------------------------------------
      IF INSTR(UPPER(l_query), 'ORDER BY') > 0 THEN
         l_query := SUBSTR(l_query, 1, INSTR(UPPER(l_query), 'ORDER BY')-1);
      END IF;
      ----------------------------------------------------------------------------------
      -- SM 712002 08082008
      -- DOC0167 has two parameters which have group bys on them and so these also need 
      -- dropping from the query (see order by reasoning).
      ----------------------------------------------------------------------------------      
      IF INSTR(UPPER(l_query), 'GROUP BY') > 0 THEN
         l_query := SUBSTR(l_query, 1, INSTR(UPPER(l_query), 'GROUP BY')-1);
      END IF;
      ------------------------------------------------------------
      --put appropraite connector onto query for another condition
      ------------------------------------------------------------
      IF INSTR(UPPER(l_query), 'WHERE') > 0
      THEN
        l_query :=               l_query
                   || CHR(10) || 'AND';
      ELSE
        l_query :=               l_query
                   || CHR(10) || 'WHERE';
      END IF;

      -----------------------------------
      --work out column and data to match
      -----------------------------------
      IF pio_value IS NOT NULL
      THEN
        --matching on value
        l_match_col  := l_gp_rec.gp_column;
        l_match_val  := pio_value;
        l_match_type := l_gp_rec.gp_param_type;
    
      ELSIF pio_shown IS NOT NULL
      THEN
        --matching on shown
        l_match_col  := l_gp_rec.gp_shown_column;
        l_match_val  := pio_shown;
        l_match_type := l_gp_rec.gp_shown_type;
      END IF;

	  l_untouched_match_val := l_match_val;
      -----------------------------------
      --adjust value string based on type
      -----------------------------------
      IF l_match_type = 'CHAR'
      THEN
        l_match_val := check_for_quotes(l_match_val); -- 709452 
        l_match_val := nm3flx.string(l_match_val);
    
      ELSIF l_match_type = nm3type.c_date
      THEN
        l_match_val := 'To_Date(' || nm3flx.string(l_match_val) || ', ' || nm3flx.string(c_gri_date_format) || ')';
      END IF;

      -------------------------------
      --add matching details to query
      -------------------------------
      IF INSTR(l_match_val,'%') > 0 THEN
        l_query :=               l_query
                 || CHR(10) || '  ' || NVL(l_match_col,1) || ' LIKE ' || NVL(l_match_val,1)||' AND ROWNUM <=2';
      ELSE
        l_query :=               l_query
                 || CHR(10) || '  ' || NVL(l_match_col,1) || ' = ' || NVL(l_match_val,1);
      END IF;  			 


--nm_debug.debug_on;
--nm_debug.debug('THE QUERY IS'||chr(10)||l_query);

    ---------------
    --perform query
    ---------------
    OPEN cs_param_lookup FOR l_query;
      FETCH cs_param_lookup BULK COLLECT INTO l_tab_shown, l_tab_descr, l_tab_value;
    CLOSE cs_param_lookup;
   	  
    IF l_tab_value.COUNT = 0 THEN
        RAISE e_value_not_found;
    END IF;

	
--
-- if punter has entered a like condition and there are more than one matching records
-- then preserve the LIKE otherwise use the first (only) matching record returned by the query
--	
    IF INSTR(l_match_val,'%') > 0 AND l_tab_value.COUNT > 1 THEN
  	     pio_value := l_untouched_match_val;
	     pio_shown := l_untouched_match_val;
	     pio_descr := 'LIKE '||l_untouched_match_val;
    ELSE
  	     pio_value := l_tab_value(1);
	     pio_shown := l_tab_shown(1);
		 --pio_descr := l_tab_descr(1);
		 -- KD task 0108516 15/10/2009
	     pio_descr := substr(l_tab_descr(1),1,100);
	END IF;
  
  ELSIF pi_number_of_query_cols = 1 THEN
  
nm_debug.debug_on;
nm_debug.debug('abc THE QUERY IS'||chr(10)||l_query);
nm_debug.debug_off; 
    ---------------
    --perform query
    ---------------
    OPEN cs_param_lookup FOR l_query;
      FETCH cs_param_lookup INTO l_dummy;
      IF cs_param_lookup%NOTFOUND
      THEN
        CLOSE cs_param_lookup;
        RAISE e_value_not_found;
      END IF;
    CLOSE cs_param_lookup;
	    
    IF pio_value IS NOT NULL THEN
      pio_shown := pio_value;
    ELSIF pio_shown IS NOT NULL THEN
      pio_value := pio_shown;  
    END IF;	
	
    IF INSTR(l_match_val,'%') > 0 THEN	
  	  pio_descr := 'LIKE '||pio_value;
    END IF;	  

    IF l_gp_rec.gp_param_type = 'NUMBER' THEN 
	     IF NOT nm3flx.is_numeric(pi_string => pio_value) OR NOT nm3flx.is_numeric(pi_string => pio_value) THEN 
             RAISE ex_non_numeric;
         END IF;
    END IF;
	
  END IF;  -- number of query cols

--
-- Return value in correct case
--
  IF l_gp_rec.gp_case = 'UPPER' THEN
    pio_value := UPPER(pio_value);
    pio_shown := UPPER(pio_shown);	
  ELSIF	l_gp_rec.gp_case = 'LOWER' THEN
    pio_value := LOWER(pio_value);
    pio_shown := LOWER(pio_shown);	
  END IF;		
  
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'validate_param_lov');

EXCEPTION
  WHEN e_value_not_found
  THEN
    Raise_Application_Error(-20076, 'Parameter value not found. ' || pi_param || '= ' || l_match_val);

  WHEN ex_non_numeric
  THEN
    Raise_Application_Error(-20077, 'Only Numeric values allowed ');
	
  WHEN ex_invalid_date_format THEN
    hig.raise_ner('HIG',148);	

END;  
--
----------------------------------------------------------------------------------
--
FUNCTION get_gri_param_query(pi_module IN gri_modules.grm_module%TYPE
                            ,pi_param  IN gri_params.gp_param%TYPE
                            ) RETURN varchar2 IS
  
  l_query varchar2(32767);
  l_order gri_params.gp_order%TYPE;

  --
  -- if the gri_parameter has not got a table specified (e.g. date parameters such as "FROM_DATE") thene "select 1 from dual where..."
  -- else "select <value>, <shown>, <meaning> from <tab> where..."  
  --
  -- note - this function does return bind variables and all
  -- GRI0200 has a program unit called apply_dependencies that replaces
  -- the bind variables with actual values entered in the from
  --
  CURSOR c1(p_module gri_modules.grm_module%TYPE
           ,p_param  gri_params.gp_param%TYPE) IS
       SELECT    'SELECT '
       || DECODE (gp_table,
                  NULL, '1 FROM DUAL ',
                     DECODE (NVL (gp_shown_type, 'CHAR'),
                             'CHAR', NULL,
                             'to_char('
                            )
                  || gp_shown_column
                  || DECODE (NVL (gp_shown_type, 'CHAR'), 'CHAR', NULL, ')')
                  || ' shown,'
                  || CHR (10)
                  || DECODE (NVL (gp_descr_type, 'CHAR'),
                             'CHAR', NULL,
                             'to_char('
                            )
                  || gp_descr_column
                  || DECODE (NVL (gp_descr_type, 'CHAR'), 'CHAR', NULL, ')')
                  || ' descr,'
                  || CHR (10)
                  || DECODE (gp_param_type, 'CHAR', NULL, 'to_char(')
                  || gp_column
                  || DECODE (gp_param_type, 'CHAR', NULL, ')')
                  || ' value '
                  || CHR (10)
                  || ' FROM '
                  || gp_table
                 )
       || CHR (10)
       || ' WHERE '
       || NVL (gmp_where, '1=1'),
       gp_order		   
    from   gri_params
          ,gri_module_params
    where  gp_param = p_param
    and    gmp_param = p_param
    and    gmp_module = p_module;
    
BEGIN      
  OPEN c1(p_module => pi_module
         ,p_param  => pi_param);
  FETCH c1 INTO l_query, l_order;
  IF c1%FOUND
  THEN
    CLOSE c1;
    
    IF l_order IS NOT NULL
    THEN
      l_query := l_query || ' order by ' || l_order;
    END IF;
  ELSE
  	CLOSE c1;
  END IF;
  -- LOG 716424
  -- Task  0107234 
  -- LS 06/09 Build the lov SQL only if the Parameter has lov flag is checked 
  -- else return dummy sql 
  IF Nvl(nm3get.get_gmp(pi_module,pi_param).gmp_lov,'N')       = 'Y'
  OR Nvl(nm3get.get_gmp(pi_module,pi_param).gmp_gazetteer,'N') = 'Y'
  THEN
      RETURN l_query;
  ELSE
      RETURN  'SELECT 1 FROM DUAL WHERE 1=1' ;
  END IF ;
--
END get_gri_param_query;
--
----------------------------------------------------------------------------------
--
FUNCTION check_for_quotes(p_str varchar2) RETURN VARCHAR2 IS
--
  l_str_ret    varchar2(1000);
  l_char       varchar2(500);
  l_prev_ascii pls_integer;
--
BEGIN
--
  -- The purpose of this function is to identify an apostrophe within a string and then add an additional single quote if one is found.
  -- e.g FISHERMAN'S AVENUE becomes FISHERMAN''S AVENUE. This ensures that any dynamic sql that uses such strings work correctly. 
  -- Currently,the function is called from GRI0200 and SWR1225   
--
  for i in 1 .. length(p_str) loop
  --
  -- There are two parts to the if statement. 
  -- The first part checks that each character of a string is in the a-z or A-Z range and that the previous character was a single quote.
  -- The second part checks that the character before the single quote was also in the a-z or A-Z range. 
  -- Only when both parts are true is an extra single quote added.      
  --
   if (((ascii (substr(p_str,i,1)) between 97 and 122) or (ascii (substr(p_str,i,1)) between 65 and 90) ) and l_prev_ascii = 39 ) 
        and ((ascii (substr(p_str,i-2,1)) between 97 and 122) or (ascii (substr(p_str,i-2,1)) between 65 and 90))
     then
        l_str_ret := substr(p_str,1,i-1)||chr(39)||substr(p_str,i,length(p_str));
     end if; 
--
     if i > 1 then
        l_prev_ascii := ascii(substr(p_str,i,1)); 
     end if;
--
  end loop;  
--
  return nvl(l_str_ret,p_str);
--
END check_for_quotes;

END higgri;
/

