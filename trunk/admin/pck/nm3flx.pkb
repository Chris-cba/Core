CREATE OR REPLACE PACKAGE BODY nm3flx IS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3flx.pkb-arc   2.11   Feb 04 2011 11:27:04   Chris.Strettle  $
--       Module Name      : $Workfile:   nm3flx.pkb  $
--       Date into PVCS   : $Date:   Feb 04 2011 11:27:04  $
--       Date fetched Out : $Modtime:   Feb 04 2011 10:56:24  $
--       Version          : $Revision:   2.11  $
--       Based on SCCS version : 1.47
-------------------------------------------------------------------------
--
  g_body_sccsid      CONSTANT  VARCHAR2(2000) := '$Revision:   2.11  $';

   g_package_name    CONSTANT varchar2(30) := 'nm3flx';
-- Package variables
--
   c_numeric_chars_param_name CONSTANT nls_session_parameters.parameter%TYPE := 'NLS_NUMERIC_CHARACTERS';
--
   g_desc_tab  dbms_sql.desc_tab;
   g_desc_tab2 dbms_sql.desc_tab2;
--
   c_ora_8           CONSTANT VARCHAR2(1) := '8';
   c_base_db_version CONSTANT VARCHAR2(1) := NVL(SUBSTR(nm3context.get_context(pi_attribute => 'DB_VERSION'), 1, 1), c_ora_8);
   
  c_nvl_string       CONSTANT VARCHAR2(30) := Nm3type.c_nvl;
  c_nvl_date         CONSTANT DATE         := Nm3type.c_nvl_date;
  c_nvl_number       CONSTANT NUMBER(1)    := -1;   
--
-----------------------------------------------------------------------------
--
PROCEDURE get_cols_from_sql_internal (p_sql IN varchar2);
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
FUNCTION RIGHT(pi_string     IN varchar2
              ,pi_chars_reqd IN number
              ) RETURN varchar2 IS
--
   l_string_start_pos number := LENGTH(pi_string)-(pi_chars_reqd-1);
--
BEGIN
--
   RETURN SUBSTR(pi_string,l_string_start_pos,pi_chars_reqd);
--
END RIGHT;
--
-----------------------------------------------------------------------------
--
FUNCTION LEFT(pi_string     IN varchar2
             ,pi_chars_reqd IN number
             ) RETURN varchar2 IS
BEGIN
--
   RETURN SUBSTR(pi_string,1,pi_chars_reqd);
--
END LEFT;
--
-----------------------------------------------------------------------------
--
FUNCTION mid(pi_string    IN varchar2
            ,pi_start_pos IN number
            ,pi_end_pos   IN number
            ) RETURN varchar2 IS
--
   l_reqd_string_length number := pi_end_pos - pi_start_pos + 1;
--
BEGIN
--
   RETURN SUBSTR(pi_string,pi_start_pos,l_reqd_string_length);
--
END mid;
--
-----------------------------------------------------------------------------
--
FUNCTION string(pi_string IN varchar2) RETURN varchar2 IS
BEGIN
--
   RETURN CHR(39)||pi_string||CHR(39); -- Return 'pi_string'
--
END string;
--
-----------------------------------------------------------------------------
--
FUNCTION string_before_character (pi_string   IN varchar2
                                 ,pi_char     IN varchar2) RETURN varchar2 IS

BEGIN

  ----------------------------------------------------------------------
  -- Example pi_string    = 'table_alias.column_name'
  --         pi_char      = '.'
  --         Return value = 'table_alias'
  ----------------------------------------------------------------------
  RETURN(
         LEFT(pi_string     => pi_string
             ,pi_chars_reqd => INSTR(pi_string,pi_char)
              )
         );

END string_before_character;
--
-----------------------------------------------------------------------------
--
FUNCTION string_after_character (pi_string   IN varchar2
                                ,pi_char     IN varchar2) RETURN varchar2 IS

BEGIN

  ----------------------------------------------------------------------
  -- Example pi_string    = 'table_alias.column_name'
  --         pi_char      = '.'
  --         Return value = 'column_name'
  ----------------------------------------------------------------------
  RETURN(
         SUBSTR(
                pi_string
               ,INSTR(pi_string,pi_char) + 1
               ,LENGTH(pi_string)
              )
         );

END string_after_character;
--
-----------------------------------------------------------------------------
--
FUNCTION is_numeric(pi_string IN varchar2) RETURN boolean IS
--
   l_retval boolean;
--
BEGIN
--
   DECLARE
      l_number number;
   BEGIN
      l_number := pi_string;
      l_retval := TRUE;
   EXCEPTION
      WHEN others
       THEN
         l_retval := FALSE;
   END;
--
   RETURN l_retval;
--
END is_numeric;
--
-----------------------------------------------------------------------------
--
FUNCTION is_valid_numeric_char(pi_char IN char) RETURN boolean IS
BEGIN
--
   RETURN is_numeric (pi_char);
--
END is_valid_numeric_char;
--
-----------------------------------------------------------------------------
--
FUNCTION get_session_parameter(pi_parameter IN nls_session_parameters.parameter%TYPE
                              ) RETURN nls_session_parameters.VALUE%TYPE IS
--
   CURSOR cs_nsp (p_parameter nls_session_parameters.parameter%TYPE) IS
   SELECT VALUE
    FROM  nls_session_parameters
   WHERE  parameter = p_parameter;
--
   l_param_value nls_session_parameters.VALUE%TYPE := NULL;
--
BEGIN
--
   OPEN  cs_nsp (pi_parameter);
   FETCH cs_nsp INTO l_param_value;
   CLOSE cs_nsp;
--
   RETURN l_param_value;
--
END get_session_parameter;
--
-----------------------------------------------------------------------------
--
FUNCTION extract_bind_variable(pi_string     IN varchar2
                              ,pi_occurrence IN number DEFAULT 1
                              ) RETURN varchar2 IS
--
   l_retval varchar2(32767) := NULL;
--
   c_bind_variable_char  CONSTANT char(1) := ':';
--
   l_bind_variable_start number;
--
   l_single_char         char(1);
   l_ascii_single_char   number;
--
BEGIN
--
   l_bind_variable_start := INSTR(pi_string,c_bind_variable_char,1,pi_occurrence);
--
   IF l_bind_variable_start > 0
    THEN
--
      l_retval := c_bind_variable_char;
--
      FOR l_counter IN (l_bind_variable_start+1)..LENGTH(pi_string)
       LOOP
--
         l_single_char       := SUBSTR(pi_string,l_counter,1);
         l_ascii_single_char := ASCII(l_single_char);
--
         IF  l_ascii_single_char BETWEEN 48 AND 57  -- 0 -> 9
          OR l_ascii_single_char BETWEEN 65 AND 90  -- A -> Z
          OR l_ascii_single_char BETWEEN 97 AND 122 -- a -> z
          OR l_single_char IN ('_','$','#')
          THEN
            l_retval := l_retval||l_single_char;
         ELSE
            EXIT;
         END IF;
      END LOOP;
--
   END IF;
--
   RETURN l_retval;
--
END extract_bind_variable;
--
-----------------------------------------------------------------------------
--
FUNCTION extract_all_bind_variables(pi_string IN varchar2
                                   ) RETURN nm3type.tab_varchar80 IS

  l_bvs_tab nm3type.tab_varchar80;

  l_count pls_integer := 0;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'extract_all_bind_variables');

  LOOP
    l_count := l_count + 1;
    l_bvs_tab(l_count) := nm3flx.extract_bind_variable(pi_string     => pi_string
                                                      ,pi_occurrence => l_count);
    EXIT WHEN l_bvs_tab(l_count) IS NULL;
  END LOOP;

  --get rid of last record in array which will be NULL
  l_bvs_tab.DELETE(l_bvs_tab.COUNT);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'extract_all_bind_variables');

  RETURN l_bvs_tab;

END extract_all_bind_variables;
--
-----------------------------------------------------------------------------
--
FUNCTION validate_domain_value
            (pi_domain IN nm_type_columns.ntc_domain%TYPE
            ,pi_value  IN varchar2
            ) RETURN hig_codes.hco_meaning%TYPE IS
--
   CURSOR cs_check_valid(p_domain nm_type_columns.ntc_domain%TYPE
                        ,p_value  varchar2
                        ) IS
   SELECT hco_meaning
    FROM  hig_codes
   WHERE  hco_domain = p_domain
    AND   hco_code   = p_value;
--
   l_retval hig_codes.hco_meaning%TYPE := NULL;
--
BEGIN
--
   OPEN  cs_check_valid (pi_domain, pi_value);
   FETCH cs_check_valid INTO l_retval;
   CLOSE cs_check_valid;
--
   RETURN l_retval;
--
END validate_domain_value;
--
-----------------------------------------------------------------------------
--
PROCEDURE select_nm_type_columns
            (pi_nt_type     IN     nm_type_columns.ntc_nt_type%TYPE
            ,pi_column_name IN     nm_type_columns.ntc_column_name%TYPE
            ,po_rec_ntc        OUT nm_type_columns%ROWTYPE
            ) IS
--
   CURSOR cs_ntc (p_nt_type     nm_type_columns.ntc_nt_type%TYPE
                 ,p_column_name nm_type_columns.ntc_column_name%TYPE
                 ) IS
   SELECT *
    FROM  nm_type_columns
   WHERE  ntc_nt_type     = p_nt_type
    AND   ntc_column_name = p_column_name;
--
   l_empty_rec_ntc nm_type_columns%ROWTYPE;
--
BEGIN
--
   po_rec_ntc := l_empty_rec_ntc;
   --
   -- Get the NM_TYPE_COLUMNS values
   --
   OPEN  cs_ntc (pi_nt_type, pi_column_name);
   FETCH cs_ntc INTO po_rec_ntc;
   CLOSE cs_ntc;
--
END select_nm_type_columns;
--
-----------------------------------------------------------------------------
--
FUNCTION get_domain
            (pi_nt_type     IN     nm_type_columns.ntc_nt_type%TYPE
            ,pi_column_name IN     nm_type_columns.ntc_column_name%TYPE
            ) RETURN nm_type_columns.ntc_domain%TYPE IS
--
   l_rec_ntc nm_type_columns%ROWTYPE;
--
BEGIN
--
   select_nm_type_columns
            (pi_nt_type     => pi_nt_type
            ,pi_column_name => pi_column_name
            ,po_rec_ntc     => l_rec_ntc
            );
--
   RETURN l_rec_ntc.ntc_domain;
--
END get_domain;
--
-----------------------------------------------------------------------------
--
PROCEDURE sel_nm_type_inclusion_by_child
            (pi_nt_type     IN     nm_type_inclusion.nti_nw_child_type%TYPE
            ,pi_column_name IN     nm_type_inclusion.nti_child_column%TYPE
            ,po_rec_nti        OUT nm_type_inclusion%ROWTYPE
            ) IS
--
   CURSOR cs_nti (p_child_type   nm_type_inclusion.nti_nw_child_type%TYPE
                 ,p_child_column nm_type_inclusion.nti_child_column%TYPE
                 ) IS
   SELECT *
    FROM  nm_type_inclusion
   WHERE  nti_nw_child_type = p_child_type
    AND   nti_child_column  = p_child_column;
--
BEGIN
--
   OPEN  cs_nti (pi_nt_type, pi_column_name);
   FETCH cs_nti INTO po_rec_nti;
   CLOSE cs_nti;
--
END sel_nm_type_inclusion_by_child;
--
-----------------------------------------------------------------------------
--
FUNCTION build_inclusion_sql_string
            (pi_rec_nti                IN     nm_type_inclusion%ROWTYPE
            ,pi_include_ne_id          IN     boolean DEFAULT TRUE
            ,pi_include_2nd_parent_col IN     boolean DEFAULT TRUE            
            ) RETURN varchar2 IS
--
   l_string varchar2(2000) := 'SELECT ';
   l_2nd_parent varchar2(2000) := NULL;

--
BEGIN
--


   IF pi_include_ne_id
    THEN
      l_string := l_string||'ne_id, ';
   END IF;

   IF pi_include_2nd_parent_col
   THEN
     l_2nd_parent := ', ' || pi_rec_nti.nti_parent_column;
   END IF;


-- GJ 12-MAY-2005
-- Need to select 3 columns so to be able to fire this sql through nm3ext_lov.validate_lov_value
-- i.e. to fit in with flex attrib validation which now fires for parent inclusion sql/ntc domain/ntc query
-- in the same manner
   l_string := l_string||pi_rec_nti.nti_parent_column||' code'||', ne_descr' || l_2nd_parent
                       ||' FROM nm_elements'
                       ||' WHERE ne_nt_type = '||string(pi_rec_nti.nti_nw_parent_type);

--
   RETURN l_string;
--
END build_inclusion_sql_string;
--
-----------------------------------------------------------------------------
--
FUNCTION build_inclusion_sql_string
            (pi_nt_type                IN     nm_type_columns.ntc_nt_type%TYPE
            ,pi_column_name            IN     nm_type_columns.ntc_column_name%TYPE
            ,pi_include_ne_id          IN     boolean DEFAULT TRUE
            ,pi_include_2nd_parent_col IN boolean DEFAULT TRUE                        
            ) RETURN varchar2 IS
--
   l_retval  varchar2(2000) := NULL;
--
   l_rec_nti nm_type_inclusion%ROWTYPE;
--
BEGIN
--
   sel_nm_type_inclusion_by_child
            (pi_nt_type     => pi_nt_type
            ,pi_column_name => pi_column_name
            ,po_rec_nti     => l_rec_nti
            );
--
   IF l_rec_nti.nti_nw_parent_type IS NOT NULL
    THEN
--
      l_retval := build_inclusion_sql_string
                         (pi_rec_nti                => l_rec_nti
                         ,pi_include_ne_id          => pi_include_ne_id
                         ,pi_include_2nd_parent_col => pi_include_2nd_parent_col
                         );
--
   END IF;
--
   RETURN l_retval;
--
END build_inclusion_sql_string;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_flex_column
            (pi_nt_type               IN     nm_type_columns.ntc_nt_type%TYPE
            ,pi_column_name           IN     nm_type_columns.ntc_column_name%TYPE
            ,pi_bind_variable_value   IN     varchar2 DEFAULT NULL  -- for use when validating ntc_query 
            ,po_value                 IN OUT varchar2
            ,po_ne_id                 OUT nm_elements.ne_id%TYPE
            )
IS
  e_non_mand_null_value EXCEPTION;
--
   l_rec_ntc nm_type_columns%ROWTYPE;
--
   l_flx_col_query    varchar2(2000);
   l_bind_variable    varchar2(2000);
   l_meaning          varchar2(2000);
   l_id               varchar2(2000);
   

   ex_parent_element_not_found EXCEPTION; 	
   PRAGMA EXCEPTION_INIT(ex_parent_element_not_found,-20607);
   

   ex_too_many_parent_elements EXCEPTION; 	
   PRAGMA EXCEPTION_INIT(ex_too_many_parent_elements,-20608);
   
   ex_invalid_value_from_qry exception;
   pragma exception_init (ex_invalid_value_from_qry, -20699);     
--
BEGIN
--
   --
   -- Get the NM_TYPE_COLUMNS values
   --
   select_nm_type_columns
            (pi_nt_type     => pi_nt_type
            ,pi_column_name => pi_column_name
            ,po_rec_ntc     => l_rec_ntc
            );
--
--   IF l_rec_ntc.ntc_nt_type IS NULL
--    THEN
--      g_flex_validation_exc_code := -20601;
--      g_flex_validation_exc_msg  := 'NM_TYPE_COLUMNS record not found';
--      RAISE g_flex_validation_exception;
--   END IF;

 IF l_rec_ntc.ntc_nt_type IS NOT NULL THEN
 
   IF l_rec_ntc.ntc_mandatory = 'N'
     AND po_value IS NULL
   THEN
     RAISE e_non_mand_null_value;
   END IF;

--
   --
   -- Check to see if this is part of a NM_TYPE_INCLUSION
   --
   po_ne_id := validate_nm_element_group
                      (pi_nt_type     => pi_nt_type
                      ,pi_column_name => pi_column_name
                      ,pi_value       => po_value
                      );
--
   --
   -- Check to see if mandatory
   --
   IF   l_rec_ntc.ntc_mandatory = 'Y'
    AND po_value IS NULL
    THEN
      g_flex_validation_exc_code := -20602;
      g_flex_validation_exc_msg  := 'Column is mandatory';
      RAISE g_flex_validation_exception;
   END IF;
--
   --
   -- Check string length
   --
   IF   l_rec_ntc.ntc_column_type IN ('VARCHAR2','CHAR')
    AND LENGTH(po_value)          > l_rec_ntc.ntc_str_length
    THEN
--
      g_flex_validation_exc_code := -20603;
      g_flex_validation_exc_msg  := 'Value is too long';
      RAISE g_flex_validation_exception;

   ELSIF l_rec_ntc.ntc_column_type = nm3type.c_number
    THEN
      --
      -- Check the format
      --
      IF NOT is_numeric(po_value)
       THEN
         --
         -- If there is a format mask supplied, but the passed value is not a number
         --
         g_flex_validation_exc_code := -20606;
         g_flex_validation_exc_msg  := 'Numeric Value is invalid';
         hig.raise_ner( pi_appl => 'HIG'
                      , pi_id   => 111
                      , pi_sqlcode => -20000
                      , pi_supplementary_info => po_value
                      );
      END IF;

      IF l_rec_ntc.ntc_format IS NOT NULL
       THEN
         po_value := TO_CHAR(TO_NUMBER(po_value),l_rec_ntc.ntc_format);
      END IF;

   END IF;


  l_flx_col_query := nm3flx.build_lov_sql_string (p_nt_type                    => pi_nt_type
                                                 ,p_column_name                => pi_column_name
                                                 ,p_include_bind_variable      => TRUE
                                                 ,p_replace_bind_variable_with => Null
                                                 );

  IF l_flx_col_query IS NOT NULL
    THEN
      --
      -- Check the query
      --
      l_bind_variable := extract_bind_variable(l_rec_ntc.ntc_query,1);

      IF extract_bind_variable(l_rec_ntc.ntc_query,2) IS NOT NULL
       THEN
         --
         -- If there is a second Bind Variable declared in the string
         --
         g_flex_validation_exc_code := -20609;
         g_flex_validation_exc_msg  := 'More than 1 bind variable defined in Query SQL - '||l_rec_ntc.ntc_query;
         RAISE g_flex_validation_exception;
--
      END IF;
--
-- if we have a bind variable then re-build the query string to use the bind variable value passed in to our procedure
--
      IF l_bind_variable IS NOT NULL THEN
      
        l_flx_col_query := nm3flx.build_lov_sql_string (p_nt_type                    => pi_nt_type
                                                       ,p_column_name                => pi_column_name
                                                       ,p_include_bind_variable      => FALSE
                                                       ,p_replace_bind_variable_with => pi_bind_variable_value
                                                        );
      END IF;

      nm3extlov.validate_lov_value	(p_statement => l_flx_col_query
                                        ,p_value     => po_value	
                                        ,p_meaning   => l_meaning	
                                        ,p_id        => l_id
                                        ,pi_match_col => 3) ;

      po_value := l_meaning;  -- pass the meaning back out

   END IF;
 
 END IF; --  IF l_rec_ntc.ntc_nt_type IS NOT NULL THEN	  

EXCEPTION
  WHEN e_non_mand_null_value
  THEN
    --no checking required
    NULL;

  WHEN ex_parent_element_not_found then
    hig.raise_ner(pi_appl => 'NET'
                 ,pi_id   => 26
                 ,pi_supplementary_info => chr(10)||pi_nt_type||chr(10)||pi_column_name||chr(10)||po_value);
                 
  WHEN ex_too_many_parent_elements then
    hig.raise_ner(pi_appl => 'NET'
                 ,pi_id   => 27
                 ,pi_supplementary_info => chr(10)||pi_nt_type||chr(10)||pi_column_name||chr(10)||po_value);
                 
                 
  WHEN ex_invalid_value_from_qry then
    hig.raise_ner(pi_appl => 'NET'
                 ,pi_id   => 389
                 ,pi_supplementary_info => chr(10)||l_rec_ntc.ntc_prompt||chr(10)||nm3flx.string(po_value));

--
   WHEN g_flex_validation_exception
    THEN
      RAISE_APPLICATION_ERROR(g_flex_validation_exc_code
                             ,g_flex_validation_exc_msg
                                     ||'...:'||pi_nt_type
                                     ||':'||pi_column_name
                                     ||':'||po_value
                             );
--
END validate_flex_column;
--
-----------------------------------------------------------------------------
--
FUNCTION validate_nm_element_group (pi_nt_type     IN nm_types.nt_type%TYPE
                                   ,pi_column_name IN nm_type_columns.ntc_column_name%TYPE
                                   ,pi_value       IN varchar2
                                   ) RETURN nm_elements.ne_id%TYPE IS
--
   l_rec_nti    nm_type_inclusion%ROWTYPE;
--
   cs_sql             nm3type.ref_cursor;
   l_matching_records number := 0;
--
   l_parent_ne_id     nm_elements.ne_id%TYPE     := NULL;
--
   l_parent_col_value varchar2(4000)             := NULL;
   l_ne_descr         nm_elements.ne_descr%TYPE  := NULL;
--
   l_sql_string       varchar2(32767);
--
BEGIN
--
   sel_nm_type_inclusion_by_child (pi_nt_type, pi_column_name, l_rec_nti);
--
   IF l_rec_nti.nti_nw_parent_type IS NOT NULL
    THEN
--
      l_sql_string := build_inclusion_sql_string(pi_rec_nti                => l_rec_nti
                                                ,pi_include_2nd_parent_col => FALSE)
                      ||' AND '||l_rec_nti.nti_parent_column||' = '||string(pi_value);
----
--      dbms_output.put_line(' Str = '||l_sql_string );
----

      OPEN  cs_sql FOR l_sql_string;
      LOOP
         FETCH cs_sql INTO l_parent_ne_id, l_parent_col_value, l_ne_descr;  -- fetch next row
         EXIT WHEN cs_sql%NOTFOUND;
         l_matching_records := l_matching_records + 1;
      END LOOP;
      CLOSE cs_sql;
--
      IF l_matching_records <> 1
       THEN
         --
         -- If <> 1 records returned by the cursor then raise an error
         --
--
         IF    l_matching_records = 0
          THEN
            g_flex_validation_exc_code := -20607;
            g_flex_validation_exc_msg  := 'Parent Element not found';
            RAISE g_flex_validation_exception;
         ELSE
            g_flex_validation_exc_code := -20608;
            g_flex_validation_exc_msg  := l_matching_records||' Parent Elements found';
            RAISE g_flex_validation_exception;
         END IF;
--
      END IF;
--
   END IF;
--
   RETURN l_parent_ne_id;
--
EXCEPTION
--
   WHEN g_flex_validation_exception
    THEN
      RAISE_APPLICATION_ERROR(g_flex_validation_exc_code
                             ,g_flex_validation_exc_msg
                                     ||':'||pi_nt_type
                                     ||':'||pi_column_name
                                     ||':'||pi_value
                             );
--
END validate_nm_element_group;
--
-----------------------------------------------------------------------------
--
FUNCTION get_flx_column_details(pi_nt_type        IN nm_types.nt_type%TYPE
                               ,pi_disp_derived   IN boolean               DEFAULT FALSE
                               ,pi_disp_inherited IN boolean               DEFAULT FALSE
                               ) RETURN tab_type_columns IS

  TYPE t_cursor IS REF CURSOR;
  c_columns   t_cursor;

  tab_columns tab_type_columns;

  v_qry varchar2(32767)         :=               'SELECT *'
                                   || CHR(10) || ' FROM  nm_type_columns'
                                   || CHR(10) || 'WHERE  ntc_nt_type   = '||nm3flx.string(pi_nt_type)
                                   || CHR(10) || '  AND  ntc_displayed = '||nm3flx.string('Y');

  v_no_inherited varchar2(4000) :=    CHR(10) || '  AND  ntc_inherit   = '||nm3flx.string('N');

  v_no_derived varchar2(4000)   :=    CHR(10) || '  AND  ntc_seq_name  IS NULL'
                                   || CHR(10) || '  AND  NOT EXISTS (SELECT 1'
                                   || CHR(10) || '                    FROM  nm_type_inclusion'
                                   || CHR(10) || '                   WHERE  nti_nw_child_type  = '||nm3flx.string(pi_nt_type)
                                   || CHR(10) || '                    AND   ntc_column_name = nti_code_control_column'
                                   || CHR(10) || '                  )';

  v_order_by varchar2(400)      :=    CHR(10) || 'ORDER BY ntc_seq_no'
                                   || CHR(10) || '        ,ntc_column_name';

BEGIN
  IF NOT(pi_disp_inherited)
  THEN
    v_qry := v_qry || v_no_inherited;
  END IF;

  IF NOT(pi_disp_derived)
  THEN
    v_qry := v_qry || v_no_derived;
  END IF;

  v_qry := v_qry || v_order_by;

  OPEN c_columns FOR v_qry;

  LOOP
    FETCH c_columns INTO tab_columns(tab_columns.COUNT + 1);
    EXIT WHEN c_columns%NOTFOUND;
  END LOOP;

  RETURN tab_columns;
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_flx_col_data(pi_ne_id       IN  nm_elements.ne_id%TYPE
                          ,pi_column_name IN  varchar2
                          ,po_value       OUT varchar2
                          ,po_meaning     OUT varchar2
                          ) AS

  v_query_txt varchar2(32767) := 'SELECT '|| pi_column_name || ', ne_nt_type FROM nm_elements WHERE ne_id = :ne_id';

  v_nt_type nm_types.nt_type%TYPE;
  v_ne_id   nm_elements.ne_id%TYPE;

BEGIN
--
  EXECUTE IMMEDIATE v_query_txt INTO po_value, v_nt_type USING pi_ne_id;
--
  po_meaning := po_value;
--
  validate_flex_column(pi_nt_type     => v_nt_type
                      ,pi_column_name => pi_column_name
                      ,po_value       => po_meaning
                      ,po_ne_id       => v_ne_id);
--
END get_flx_col_data;
--
-----------------------------------------------------------------------------
--
FUNCTION get_dec_places_from_mask (pi_format_mask IN varchar2) RETURN number IS
--
   l_retval        number                            := 0;
   l_numeric_chars nls_session_parameters.VALUE%TYPE := get_session_parameter(c_numeric_chars_param_name);
   l_found_one     boolean                           := FALSE;
--
BEGIN
--
   FOR l_count IN REVERSE 1..LENGTH(pi_format_mask)
    LOOP
      DECLARE
         l_char char(1) := SUBSTR(pi_format_mask,l_count,1);
      BEGIN
         IF INSTR(l_numeric_chars,l_char,1,1) <> 0
          THEN
            --
            -- If this is one of the numeric characters allowed (e.g. "." or ",")
            --
            l_found_one := TRUE;
            EXIT;
         ELSIF NOT is_valid_numeric_char(l_char)
          THEN
            --
            -- This is not a valid numeric
            --
            RAISE_APPLICATION_ERROR (-20001
                                    ,'Non-Numeric Character found in format mask - NM3FLX.GET_DEC_PLACES_FROM_MASK('
                                     ||string(pi_format_mask)
                                     ||')'
                                    );
         END IF;
         l_retval := l_retval + 1;
      END;
   END LOOP;
--
   IF NOT l_found_one
    THEN
      l_retval := 0;
   END IF;
--
   RETURN l_retval;
--
END get_dec_places_from_mask;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_flx_query(pi_query          IN VARCHAR2
                            ,pi_flx_type       IN VARCHAR2   -- NET for network flx col or INV for inventory flx col 
                            ,pi_type           IN VARCHAR2
                            ,pi_type_col_attr  IN VARCHAR2   -- e.g. ntc_column_name or ita_attrib
                            ) IS

 l_query_cols      nm3type.tab_varchar30;
 l_bind_vars       nm3type.tab_varchar80;
 l_single_bind_variable varchar2(80);
 l_this_ntc_rec    nm_type_columns%ROWTYPE;
 l_bind_ntc_rec    nm_type_columns%ROWTYPE;
 l_this_ita_rec    nm_inv_type_attribs%ROWTYPE;
 l_bind_ita_rec    nm_inv_type_attribs%ROWTYPE;

 --l_where_clause    nm_type_columns.ntc_query%TYPE := '...'||SUBSTR(pi_query,INSTR(pi_query,'WHERE'),LENGTH(pi_query));
 l_where_clause    nm_inv_type_attribs.ita_query%TYPE := '...'||SUBSTR(pi_query,INSTR(pi_query,'WHERE'),LENGTH(pi_query));
 
BEGIN

--
-- sql must parse
--
 IF NOT nm3flx.is_select_statement_valid (p_sql => pi_query) THEN
    hig.raise_ner(pi_appl               => 'HIG'
                 ,pi_id                 => 113
                 ,pi_supplementary_info => pi_query);

 END IF;

--
-- three columns must be defined
--
 l_query_cols := nm3flx.get_cols_from_sql(p_sql => pi_query);

 IF l_query_cols.COUNT != 3 THEN
    hig.raise_ner(pi_appl               => 'NET'
                 ,pi_id                 => 390
                 ,pi_supplementary_info => pi_query);  -- query must return 3 columns, Code, Meaning, ID
 END IF;

--
-- not more than one bind variable can be specified
--
 l_bind_vars := nm3flx.extract_all_bind_variables(pi_string => pi_query);
 
 IF l_bind_vars.COUNT >1 THEN
     hig.raise_ner(pi_appl               => 'NET'
                  ,pi_id                 => 391
                  ,pi_supplementary_info => pi_query);  -- query must contain a maximum of 1 bind variable

 ELSIF l_bind_vars.COUNT = 1 THEN 

 l_single_bind_variable := UPPER(REPLACE(l_bind_vars(1),':',Null)); 
 --
 -- bind variable must be a flex column for given network/inv type
 -- 
     IF pi_flx_type = 'NET' THEN 

       -- If bind variable is not one of the flex cols on 
       -- nm_elements (but it is still a valid column name on nm_elements) 
       -- e.g. NE_UNIQUE then don't bother checking network type columns
       --
       IF nm3net.is_not_a_flex_col(pi_column_name => l_single_bind_variable) = 'Y' THEN

         Null;
 
       ELSE

         l_this_ntc_rec := nm3get.get_ntc(pi_ntc_nt_type     => pi_type
                                         ,pi_ntc_column_name => pi_type_col_attr 
                                         ,pi_raise_not_found => FALSE);

         l_bind_ntc_rec := nm3get.get_ntc(pi_ntc_nt_type     => pi_type
                                         ,pi_ntc_column_name => l_single_bind_variable
                                         ,pi_raise_not_found => FALSE);

         IF l_bind_ntc_rec.ntc_column_name IS NULL THEN

            hig.raise_ner(pi_appl               => 'NET'
                         ,pi_id                 => 392
                         ,pi_supplementary_info => chr(10)||l_where_clause);  -- bind variable must also be a network type column for this network type
                     
         ELSIF l_this_ntc_rec.ntc_seq_no <= l_bind_ntc_rec.ntc_seq_no AND l_this_ntc_rec.ntc_column_name != l_bind_ntc_rec.ntc_column_name THEN 

            hig.raise_ner(pi_appl               => 'NET'
                         ,pi_id                 => 395
                         ,pi_supplementary_info => chr(10)||chr(10)||l_bind_ntc_rec.ntc_column_name||' ('||l_bind_ntc_rec.ntc_seq_no||') >= '||l_this_ntc_rec.ntc_column_name||' ('||l_this_ntc_rec.ntc_seq_no||')');  -- Bind variable must be of a lower sequence than the current flexible attribute

         END IF;

      END IF;

    ELSIF pi_flx_type = 'INV' THEN
  

         l_this_ita_rec := nm3get.get_ita(pi_ita_inv_type    => pi_type
                                         ,pi_ita_attrib_name => pi_type_col_attr 
                                         ,pi_raise_not_found => FALSE);

         l_bind_ita_rec := nm3get.get_ita(pi_ita_inv_type     => pi_type
                                         ,pi_ita_attrib_name => l_single_bind_variable
                                         ,pi_raise_not_found => FALSE);

										 
         IF l_bind_ita_rec.ita_attrib_name IS NULL THEN

            hig.raise_ner(pi_appl               => 'NET'
                         ,pi_id                 => 393
                         ,pi_supplementary_info => chr(10)||l_where_clause);  -- bind variable must also be a network type column for this network type
                     
         ELSIF l_this_ita_rec.ita_disp_seq_no <= l_bind_ita_rec.ita_disp_seq_no AND l_this_ita_rec.ita_attrib_name != l_bind_ita_rec.ita_attrib_name THEN 

            hig.raise_ner(pi_appl               => 'NET'
                         ,pi_id                 => 395
                         ,pi_supplementary_info => chr(10)||l_bind_ita_rec.ita_attrib_name||' ('||l_bind_ita_rec.ita_disp_seq_no||') >= '||l_this_ita_rec.ita_attrib_name||' ('||l_this_ita_rec.ita_disp_seq_no||')');  -- Bind variable must be of a lower sequence than the current flexible attribute

         END IF;
										 
										 
     END IF;
 
  END IF; 
END validate_flx_query;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_ntc_query(pi_query           IN VARCHAR2
                            ,pi_ntc_nt_type     IN nm_type_columns.ntc_nt_type%TYPE
							,pi_ntc_column_name IN nm_type_columns.ntc_column_name%TYPE) IS

BEGIN
  validate_flx_query(pi_query          => pi_query
                    ,pi_flx_type       => 'NET' 
                    ,pi_type           => pi_ntc_nt_type
					,pi_type_col_attr  => pi_ntc_column_name);

END validate_ntc_query;
--
-----------------------------------------------------------------------------
--                     
PROCEDURE validate_ita_query(pi_query           IN VARCHAR2
                            ,pi_ita_inv_type    IN nm_inv_type_attribs.ita_inv_type%TYPE
							,pi_ita_attrib_name IN nm_inv_type_attribs.ita_attrib_name%TYPE) IS

BEGIN
  validate_flx_query(pi_query          => pi_query
                    ,pi_flx_type       => 'INV' 
                    ,pi_type           => pi_ita_inv_type
					,pi_type_col_attr  => pi_ita_attrib_name);

END validate_ita_query;
--
-----------------------------------------------------------------------------
--                            
FUNCTION get_flx_col_domain_sql(pi_domain IN VARCHAR2) RETURN VARCHAR2 IS

BEGIN

-- GJ following upgrade to Atlas NM0105 was falling over post query
-- appears that it's because it tries to match a value e.g. '
-- derived sql was 
-- SELECT hco_code    lup_meaning
--      , hco_meaning lup_description
--      , hco_code    lup_value 
-- FROM hig_codes 
-- WHERE hco_domain = 'AGENCY_CODE'
-- AND   lup_value = '3008' - that's the bobbins bit
--
-- so changed from
--  RETURN('SELECT hco_code lup_meaning, hco_meaning lup_description, hco_code lup_value FROM hig_codes WHERE hco_domain = '||string(pi_domain));
-- to
  RETURN('SELECT hco_code lup_meaning, hco_meaning lup_description, hco_code FROM hig_codes WHERE hco_domain = '||string(pi_domain));
  
END get_flx_col_domain_sql;
--
-----------------------------------------------------------------------------
--
FUNCTION build_lov_sql_string (p_nt_type                    IN varchar2
                              ,p_column_name                IN varchar2
                              ,p_include_bind_variable      IN BOOLEAN DEFAULT FALSE
                              ,p_replace_bind_variable_with IN VARCHAR2 DEFAULT NULL
                              ) RETURN varchar2 IS
--
   l_retval  varchar2(32767) := NULL;
--
   l_rec_ntc nm_type_columns%ROWTYPE;
--
BEGIN
--
   l_retval := build_inclusion_sql_string
                              (pi_nt_type       => p_nt_type
                              ,pi_column_name   => p_column_name
                              ,pi_include_ne_id => FALSE
                              );
--
   IF l_retval IS NULL
    THEN
--
      -- If this is not a nti_child_column
      select_nm_type_columns
            (pi_nt_type     => p_nt_type
            ,pi_column_name => p_column_name
            ,po_rec_ntc     => l_rec_ntc
            );
--
-- GJ 12-MAY-2005 don't error just return null if col not found
--      IF l_rec_ntc.ntc_nt_type IS NULL
--       THEN
--         g_flex_validation_exc_code := -20601;
--         g_flex_validation_exc_msg  := 'NM_TYPE_COLUMNS record not found';
--         RAISE g_flex_validation_exception;
--      END IF;
--


      IF l_rec_ntc.ntc_query IS NOT NULL
       THEN
         IF p_include_bind_variable THEN  -- just return the basic query bind variables and all
           l_retval := l_rec_ntc.ntc_query;
       ELSIF p_replace_bind_variable_with IS NOT NULL THEN  -- replace bind variable with given value

            IF INSTR(p_replace_bind_variable_with,'%') != 0 THEN
               hig.raise_ner(pi_appl => 'NET'
                            ,pi_id   => 394
                            ,pi_supplementary_info => chr(10)||string(l_rec_ntc.ntc_prompt));
            END IF;
         
           l_retval := REPLACE(l_rec_ntc.ntc_query
                              ,nm3flx.extract_bind_variable(l_rec_ntc.ntc_query)
--                              ,nm3flx.string(p_replace_bind_variable_with)
                              ,nm3flx.string(repl_quotes_amps_for_dyn_sql(p_replace_bind_variable_with))  -- deal with any ' characters that would be in the resulting sql string   
                              );
							  
         ELSE 
           -- This is a query so sort that out by removing any refs to bind variables
           l_retval := remove_bind_variable_refs (l_rec_ntc.ntc_query);
         END IF;  
      ELSIF l_rec_ntc.ntc_domain IS NOT NULL
       THEN
         -- This is a domain
         l_retval := get_flx_col_domain_sql(pi_domain => l_rec_ntc.ntc_domain);
      END IF;
--
     END IF;

--
-- check that whatever sql has been derived that it is valid
--
   IF l_retval IS NOT NULL AND NOT is_select_statement_valid (p_sql => l_retval) THEN
    hig.raise_ner(pi_appl => 'NET'
                 ,pi_id   => 388
                 ,pi_supplementary_info => chr(10)||string(l_rec_ntc.ntc_prompt)||chr(10)||l_retval); -- Parse error in query

   END IF;

   RETURN l_retval;
--
EXCEPTION
--
   WHEN g_flex_validation_exception
    THEN
      RAISE_APPLICATION_ERROR(g_flex_validation_exc_code,g_flex_validation_exc_msg);
--
END build_lov_sql_string;
--
-----------------------------------------------------------------------------
--
FUNCTION remove_bind_variable_refs (p_query    IN varchar2) RETURN varchar2 IS
--
   l_retval varchar2(32767) := p_query;
--
   l_bind_variable varchar2(2000);
--
   l_counter       number := 1;
--
BEGIN
--
   l_bind_variable := extract_bind_variable(p_query,l_counter);
--
   WHILE l_bind_variable IS NOT NULL
    LOOP
      --
      DECLARE
         l_bind_var_pos number := INSTR(l_retval,l_bind_variable,1,1);
         l_char_found   boolean := FALSE;
         l_ascii        number;
      BEGIN
         --
         -- Starting from the bind variable position work backwards
         --  until we find an alphabetic character as this will indicate
         --  that we are on a field defn. therefore the next space we find
         --  is the beginning of that field def. . SO just replace the whole
         --  lot with "1=1"
         --
         FOR l_count IN REVERSE 1..l_bind_var_pos
          LOOP
            l_ascii := ASCII(SUBSTR(UPPER(l_retval),l_count,1));
            IF l_ascii BETWEEN 65 AND 90
             THEN
               l_char_found := TRUE;
            ELSIF l_ascii = 32
             AND  l_char_found
             THEN
               l_retval := LEFT(l_retval,l_count)
                           ||'1=1'
                           ||SUBSTR(l_retval,l_bind_var_pos+LENGTH(l_bind_variable),LENGTH(l_retval));
               EXIT;
            END IF;
         END LOOP;
      END;
      --
      -- Increment the counter and get the next bind variable
      l_counter := l_counter + 1;
      l_bind_variable := extract_bind_variable(p_query,l_counter);
   END LOOP;
--
   RETURN l_retval;
--
END remove_bind_variable_refs;
--
-----------------------------------------------------------------------------
--
FUNCTION is_string_valid_for_object (p_string IN varchar2) RETURN boolean IS
--
   l_string        user_objects.object_name%TYPE;
   l_ascii         binary_integer;
   l_char          char(1);
   l_string_length binary_integer := LENGTH(p_string);
--
   l_retval boolean := TRUE;
--
BEGIN
--
   l_retval := (l_string_length BETWEEN 1 AND 30);
--
   l_string := UPPER(p_string);
--
   IF l_retval
    THEN
      -- If the first char is not alphabetic then FALSE
      l_char   := SUBSTR(l_string,1,1);
      l_retval := (ASCII(l_char) BETWEEN 65 AND 90) OR l_char = '_';
   END IF;
--
   IF l_retval
    THEN
      l_retval := NOT is_reserved_word (l_string);
      IF NOT l_retval
      THEN raise_application_error(-20001,l_string||' is a reserved word');
      END IF;
   END IF;
--
   IF l_retval
    THEN
      FOR l_count IN 2..l_string_length
       LOOP
         l_char  := SUBSTR(l_string,l_count,1);
         l_ascii := ASCII(l_char);
         IF   l_ascii NOT BETWEEN 65 AND 90 -- A-Z
          AND l_ascii NOT BETWEEN 48 AND 57 -- 0-9
          AND l_char  NOT IN ('_','$','#')
          THEN
            l_retval := FALSE;
            EXIT;
         END IF;
      END LOOP;
   END IF;
--
   IF l_retval
    THEN
      l_retval := NOT is_reserved_word (l_string);
   END IF;
--
   RETURN l_retval;
--
END is_string_valid_for_object;
--
-----------------------------------------------------------------------------
--
FUNCTION ten_to_power (p_mantissa number
                      ,p_exponent number
                      ) RETURN number IS
--
   l_retval number := p_mantissa;
--
BEGIN
--
   IF p_exponent <> TRUNC(p_exponent)
    THEN
      l_retval := NULL;
   ELSIF p_exponent = 0
    THEN
      l_retval := 1;
   ELSIF p_exponent > 0
    THEN
      FOR l_count IN 1..p_exponent
       LOOP
         l_retval := l_retval * 10;
      END LOOP;
   ELSIF p_exponent < 0
    THEN
      FOR l_count IN 1..(-p_exponent)
       LOOP
         l_retval := l_retval / 10;
      END LOOP;
   END IF;
--
   RETURN l_retval;
--
END ten_to_power;
--
-----------------------------------------------------------------------------
--
FUNCTION boolean_to_char (p_boolean boolean) RETURN varchar2 IS
BEGIN
   IF p_boolean
    THEN
      RETURN nm3type.c_true;
   ELSE
      RETURN nm3type.c_false;
   END IF;
END boolean_to_char;
--
-----------------------------------------------------------------------------
--
FUNCTION char_to_boolean (p_char varchar2) RETURN boolean IS
BEGIN
   RETURN (p_char = nm3type.c_true);
END char_to_boolean;
--
-----------------------------------------------------------------------------
--
PROCEDURE parse_sql_string (p_sql varchar2) IS
BEGIN
--
   g_last_parse_exception_msg := NULL;
   DECLARE
      l_c       pls_integer;
   BEGIN
      l_c := DBMS_SQL.OPEN_CURSOR;
      DBMS_SQL.PARSE(c             => l_c
                    ,STATEMENT     => p_sql
                    ,language_flag => dbms_sql.native
                    );
      DBMS_SQL.CLOSE_CURSOR(c => l_c);
   EXCEPTION
      WHEN others
       THEN
         g_last_parse_exception_msg := SQLERRM;
         IF DBMS_SQL.IS_OPEN (c => l_c)
          THEN
            DBMS_SQL.CLOSE_CURSOR(c => l_c);
         END IF;
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 83
                       ,pi_supplementary_info => p_sql||g_last_parse_exception_msg
                       );
   END;
--
END parse_sql_string;
--
-----------------------------------------------------------------------------
--
FUNCTION sql_parses_without_error (pi_sql           IN     varchar2
                                  ,po_error_message IN OUT varchar2) RETURN boolean IS

  v_sql_cursor nm3type.ref_cursor;

BEGIN
    po_error_message := NULL;
    OPEN v_sql_cursor FOR pi_sql;
    RETURN(TRUE);
EXCEPTION
  WHEN others THEN
      po_error_message := SQLERRM;
      RETURN(FALSE);

END;
--
-----------------------------------------------------------------------------
--
FUNCTION rowid_can_be_selected(pi_from IN varchar2) RETURN boolean IS

 v_dummy_query     nm3type.max_varchar2;
 v_parse_error     nm3type.max_varchar2;

BEGIN

      ---------------------------------------------------------------------
      -- test to see if rowid is a valid column to select against this table
      ---------------------------------------------------------------------
      v_dummy_query :=  nm3type.c_select|| nm3type.c_space|| 'ROWID'|| CHR(10)
                      || nm3type.c_space|| nm3type.c_from|| nm3type.c_space||pi_from;

      RETURN(
               nm3flx.sql_parses_without_error (pi_sql           => v_dummy_query
                                               ,po_error_message => v_parse_error)
            );

END rowid_can_be_selected;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_cols_from_sql_internal (p_sql IN varchar2) IS
   l_c        pls_integer;
   l_count    pls_integer;
BEGIN
--
   g_desc_tab.DELETE;
--
   l_c := DBMS_SQL.OPEN_CURSOR;
 --
   BEGIN
     DBMS_SQL.PARSE(c             => l_c
                   ,STATEMENT     => p_sql
                   ,language_flag => dbms_sql.native
                   );

   EXCEPTION
     WHEN others
      THEN
        IF DBMS_SQL.IS_OPEN (l_c)
         THEN
           DBMS_SQL.CLOSE_CURSOR(c => l_c);
        END IF;
        g_flex_validation_exc_code := -20620;
        g_flex_validation_exc_msg  := 'Error parsing sql: ' || SQLERRM;
        RAISE g_flex_validation_exception;
   END;
 --
   DBMS_SQL.DESCRIBE_COLUMNS(c       => l_c
                            ,col_cnt => l_count
                            ,desc_t  => g_desc_tab
                            );
 --
   DBMS_SQL.CLOSE_CURSOR(c => l_c);
 --
EXCEPTION
   WHEN g_flex_validation_exception
    THEN
       RAISE_APPLICATION_ERROR(g_flex_validation_exc_code, g_flex_validation_exc_msg);
--
END get_cols_from_sql_internal;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_cols_from_sql_internal2(p_sql IN varchar2) IS
   l_c        pls_integer;
   l_count    pls_integer;
BEGIN
--
   g_desc_tab2.DELETE;
--
   l_c := DBMS_SQL.OPEN_CURSOR;
 --
   BEGIN
     DBMS_SQL.PARSE(c             => l_c
                   ,STATEMENT     => p_sql
                   ,language_flag => dbms_sql.native
                   );

   EXCEPTION
     WHEN others
      THEN
        IF DBMS_SQL.IS_OPEN (l_c)
         THEN
           DBMS_SQL.CLOSE_CURSOR(c => l_c);
        END IF;
        g_flex_validation_exc_code := -20620;
        g_flex_validation_exc_msg  := 'Error parsing sql: ' || SQLERRM;
        RAISE g_flex_validation_exception;
   END;
 --
   DBMS_SQL.DESCRIBE_COLUMNS2(c       => l_c
                            ,col_cnt => l_count
                            ,desc_t  => g_desc_tab2
                            );
 --
   DBMS_SQL.CLOSE_CURSOR(c => l_c);
 --
EXCEPTION
   WHEN g_flex_validation_exception
    THEN
       RAISE_APPLICATION_ERROR(g_flex_validation_exc_code, g_flex_validation_exc_msg);
--
END get_cols_from_sql_internal2;
--
-----------------------------------------------------------------------------
--
FUNCTION get_col_dets_from_sql (p_sql IN varchar2) RETURN dbms_sql.desc_tab IS
BEGIN
   get_cols_from_sql_internal (p_sql);
   RETURN g_desc_tab;
END get_col_dets_from_sql;
--
-----------------------------------------------------------------------------
--
FUNCTION get_col_dets_from_sql2(p_sql IN varchar2) RETURN dbms_sql.desc_tab2 IS
BEGIN
   get_cols_from_sql_internal2(p_sql);
   RETURN g_desc_tab2;
END get_col_dets_from_sql2;
--
-----------------------------------------------------------------------------
--
FUNCTION get_cols_from_sql(p_sql IN varchar2
                          ) RETURN nm3type.tab_varchar30 IS
--
   l_retval   nm3type.tab_varchar30;
--
BEGIN
--
   get_cols_from_sql_internal (p_sql);
--
   FOR l_i IN 1..g_desc_tab.COUNT
    LOOP
      l_retval(l_i) := g_desc_tab(l_i).col_name;
   END LOOP;
--
   RETURN l_retval;
--
END get_cols_from_sql;
--
-----------------------------------------------------------------------------
--
FUNCTION is_select_statement_valid (p_sql varchar2) RETURN boolean IS
--
   l_retval boolean := TRUE;
--
BEGIN
--
   IF p_sql IS NOT NULL
    THEN
      BEGIN
         get_cols_from_sql_internal (p_sql);
      EXCEPTION
         WHEN others
          THEN
            l_retval := FALSE;
      END;
   END IF;
--
   RETURN l_retval;
--
END is_select_statement_valid;
--
-----------------------------------------------------------------------------
--
PROCEDURE is_select_statement_valid (p_sql varchar2) IS
BEGIN
--
   IF NOT nm3flx.is_select_statement_valid(p_sql)
    THEN
      hig.raise_ner (nm3type.c_net,121);
   END IF;
--
END is_select_statement_valid;
--
-----------------------------------------------------------------------------
--
FUNCTION get_datatype_from_int_col_type (p_col_type    IN binary_integer
                                        ,p_charsetform IN binary_integer DEFAULT NULL
                                        ,p_scale       IN binary_integer DEFAULT NULL
                                        ,p_precision   IN number         DEFAULT NULL
                                        ) RETURN user_arguments.data_type%TYPE IS
--
   CURSOR cs_decode IS
   SELECT DECODE(p_col_type
                ,0, NULL
                ,1, DECODE(p_charsetform, 2, 'NVARCHAR2', 'VARCHAR2')
                ,2, DECODE(p_scale, -127, 'FLOAT', 'NUMBER')
                ,3, 'NATIVE INTEGER'
                ,8, 'LONG'
                ,9, DECODE(p_charsetform, 2, 'NCHAR VARYING', 'VARCHAR')
                ,11, 'ROWID'
                ,12, 'DATE'
                ,23, 'RAW'
                ,24, 'LONG RAW'
                ,29, 'BINARY_INTEGER'
                ,69, 'ROWID'
                ,96, DECODE(p_charsetform, 2, 'NCHAR', 'CHAR')
                ,102, 'REF CURSOR'
                ,104, 'UROWID'
                ,105, 'MLSLABEL'
                ,106, 'MLSLABEL'
                ,110, 'REF'
                ,111, 'REF'
                ,112, DECODE(p_charsetform, 2, 'NCLOB', 'CLOB')
                ,113, 'BLOB'
                ,114, 'BFILE'
                ,115, 'CFILE'
                ,121, 'OBJECT'
                ,122, 'TABLE'
                ,123, 'VARRAY'
                ,178, 'TIME'
                ,179, 'TIME WITH TIME ZONE'
                ,180, 'TIMESTAMP'
                ,181, 'TIMESTAMP WITH TIME ZONE'
                ,231, 'TIMESTAMP WITH LOCAL TIME ZONE'
                ,182, 'INTERVAL YEAR TO MONTH'
                ,183, 'INTERVAL DAY TO SECOND'
                ,250, 'PL/SQL RECORD'
                ,251, 'PL/SQL TABLE'
                ,252, 'PL/SQL BOOLEAN'
                ,'UNDEFINED'
                )
    FROM  dual;

    CURSOR cs_decode_9i IS
    SELECT DECODE(p_col_type
                ,0, NULL
                ,1, DECODE(p_charsetform, 2, 'NVARCHAR2', 'VARCHAR2')
                ,2, DECODE (p_scale,
                             NULL, DECODE (p_precision,
                                           NULL, 'NUMBER',
                                           'FLOAT'
                                          ),
                             'NUMBER'
                            )
                ,3, 'NATIVE INTEGER'
                ,8, 'LONG'
                ,9, DECODE(p_charsetform, 2, 'NCHAR VARYING', 'VARCHAR')
                ,11, 'ROWID'
                ,12, 'DATE'
                ,23, 'RAW'
                ,24, 'LONG RAW'
                ,29, 'BINARY_INTEGER'
                ,69, 'ROWID'
                ,96, DECODE(p_charsetform, 2, 'NCHAR', 'CHAR')
                ,102, 'REF CURSOR'
                ,104, 'UROWID'
                ,105, 'MLSLABEL'
                ,106, 'MLSLABEL'
                ,110, 'REF'
                ,111, 'REF'
                ,112, DECODE(p_charsetform, 2, 'NCLOB', 'CLOB')
                ,113, 'BLOB'
                ,114, 'BFILE'
                ,115, 'CFILE'
                ,121, 'OBJECT'
                ,122, 'TABLE'
                ,123, 'VARRAY'
                ,178, 'TIME(' || p_scale || ')'
                ,179, 'TIME(' || p_scale || ')' || ' WITH TIME ZONE'
                ,180, 'TIMESTAMP(' || p_scale || ')'
                ,181, 'TIMESTAMP(' || p_scale || ')' || ' WITH TIME ZONE'
                ,231, 'TIMESTAMP(' || p_scale || ')'
                   || ' WITH LOCAL TIME ZONE'
                ,182, 'INTERVAL YEAR(' || p_precision || ') TO MONTH'
                ,183, 'INTERVAL DAY('
                   || p_precision
                   || ') TO SECOND('
                   || p_scale
                   || ')'
                ,208, 'UROWID'
                ,250, 'PL/SQL RECORD'
                ,251, 'PL/SQL TABLE'
                ,252, 'PL/SQL BOOLEAN'
                ,'UNDEFINED'
                )
    FROM  dual;
--
   l_datatype varchar2(30);
--
BEGIN
--
   IF c_base_db_version = c_ora_8
   THEN
     OPEN  cs_decode;
     FETCH cs_decode INTO l_datatype;
     CLOSE cs_decode;
   ELSE
     OPEN  cs_decode_9i;
     FETCH cs_decode_9i INTO l_datatype;
     CLOSE cs_decode_9i;
   END IF;
--
   RETURN l_datatype;
--
END get_datatype_from_int_col_type;
--
-----------------------------------------------------------------------------
--
FUNCTION get_datatype_dbms_sql_desc_rec (p_rec IN dbms_sql.desc_rec) RETURN user_arguments.data_type%TYPE IS
BEGIN
   RETURN get_datatype_from_int_col_type (p_rec.col_type
                                         ,p_rec.col_charsetform
                                         ,p_rec.col_scale
                                         ,p_rec.col_precision
                                         );
END get_datatype_dbms_sql_desc_rec;
--
-----------------------------------------------------------------------------
--
FUNCTION get_datatype_dbms_sql_desc_rec (p_rec IN dbms_sql.desc_rec2) RETURN user_arguments.data_type%TYPE IS
BEGIN
   RETURN get_datatype_from_int_col_type (p_rec.col_type
                                         ,p_rec.col_charsetform
                                         ,p_rec.col_scale
                                         ,p_rec.col_precision
                                         );
END get_datatype_dbms_sql_desc_rec;
--
-----------------------------------------------------------------------------
--
FUNCTION is_reserved_word (p_name varchar2) RETURN boolean IS
--
   -- LS 24/04/09 nm_reserve_words_vw Used: Replace the data dictionary view with Exor view to handle exclusion of Reserve Words
   -- CWS 15/02/10 nm_reserve_words_vw is no longer used. nm_rserve_words_ex will store excluded keywords instead  of them being hard coded into a view.
   CURSOR cs_resv (c_word varchar2) IS
   SELECT 1
   FROM  v$reserved_words
   WHERE  keyword = c_word
   AND reserved = 'Y'
   AND NOT EXISTS (SELECT 'X' 
                     FROM nm_reserve_words_ex 
                    WHERE nrwe_keyword = c_word
                      AND nrwe_exclude = 'Y');
--
   l_dummy  binary_integer;
--
   l_retval boolean;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'is_reserved_word');
--
   OPEN  cs_resv (p_name);
   FETCH cs_resv INTO l_dummy;
   l_retval := cs_resv%FOUND;
   CLOSE cs_resv;
--
   nm_debug.proc_end(g_package_name,'is_reserved_word');
--
   RETURN l_retval;
--
END is_reserved_word;
--
-----------------------------------------------------------------------------
--
FUNCTION repl_quotes_amps_for_dyn_sql (p_text_in varchar2) RETURN varchar2 IS
--
   l_text varchar2(32767) := p_text_in;
--
   PROCEDURE repl_char (p_char_in varchar2) IS
   BEGIN
      l_text := REPLACE (l_text,p_char_in,nm3flx.string('||CHR('||ASCII(p_char_in)||')||'));
   END repl_char;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'repl_quotes_amps_for_dyn_sql');
--
   -- Replace ' first ###########
   -- single quote;
   repl_char(CHR(39));
   --
   -- amp;
   repl_char(CHR(38));
   --
   -- LF;
   repl_char(CHR(10));
--
   nm_debug.proc_end(g_package_name,'repl_quotes_amps_for_dyn_sql');
--
   RETURN l_text;
--
END repl_quotes_amps_for_dyn_sql;
--
-----------------------------------------------------------------------------
--
FUNCTION get_file_extenstion (p_filename varchar2)
RETURN varchar2
IS
BEGIN
   nm_debug.proc_start(g_package_name , 'get_file_extenstion');
   RETURN SUBSTR(p_filename,INSTR(p_filename,'.',1)+1);
   nm_debug.proc_end(g_package_name , 'get_file_extenstion');
END get_file_extenstion;
--
-----------------------------------------------------------------------------
--
FUNCTION convert_seconds_to_hh_mi_ss (p_seconds number) RETURN varchar2 IS
--
   l_retval varchar2(50);
--
   l_remaining number := p_seconds;
   l_trunc     number := TRUNC(p_seconds);
   l_mod       number;
--
BEGIN
--
   IF l_remaining != l_trunc
    THEN
      l_retval    := TO_CHAR(l_remaining-l_trunc,'.00');
      l_remaining := l_trunc;
   END IF;
--
   IF l_remaining > 0
    THEN
      -- Minutes
      l_mod       := MOD(l_remaining,60);
      l_retval    := ':'||TO_CHAR(l_mod,'00')||l_retval;
      l_remaining := (l_remaining - l_mod)/60;
   END IF;
--
   IF l_remaining > 0
    THEN
      -- Hours
      l_mod       := MOD(l_remaining,60);
      l_retval    := ':'||TO_CHAR(l_mod,'00')||l_retval;
      l_remaining := (l_remaining - l_mod)/60;
   END IF;
   l_retval := l_remaining||l_retval;
--
   RETURN REPLACE(l_retval,' ',NULL);
--
END convert_seconds_to_hh_mi_ss;
--
-----------------------------------------------------------------------------
--
FUNCTION convert_hh_mi_ss_to_seconds(pi_hh_mi_ss IN VARCHAR2) RETURN VARCHAR2 IS

BEGIN

 RETURN to_char(to_date(pi_hh_mi_ss,'HH24:MI:SS'),'SSSSS');

END convert_hh_mi_ss_to_seconds;
--
-----------------------------------------------------------------------------
--
FUNCTION parse_error_code_and_message
                            (pi_msg        IN varchar2
                            ,pi_program    IN varchar2 DEFAULT 'ORA'
                            ,pi_occurrence IN number   DEFAULT 1
                            ) RETURN varchar2 IS
--
   l_error_code pls_integer;
   l_error_msg  varchar2(32767);
--
   l_retval varchar2(32767);
--
BEGIN
--
   l_error_code := parse_error_code(pi_msg        => pi_msg
                                   ,pi_program    => pi_program
                                   ,pi_occurrence => pi_occurrence
                                   );
--
   l_error_msg  := parse_error_message(pi_msg        => pi_msg
                                      ,pi_program    => pi_program
                                      ,pi_occurrence => pi_occurrence
                                      );
--
   l_retval := pi_program||TO_CHAR(l_error_code,'00000')||': '||l_error_msg;
--
   RETURN l_retval;
--
END parse_error_code_and_message;
--
-----------------------------------------------------------------------------
--
FUNCTION parse_error_message(pi_msg        IN varchar2
                            ,pi_program    IN varchar2 DEFAULT 'ORA'
                            ,pi_occurrence IN number   DEFAULT 1
                            ) RETURN varchar2 IS

  l_start_pos number;
  l_end_pos number;

  l_retval varchar2(32767);

BEGIN
	--find start position of desired occurrence
  l_start_pos := INSTR(pi_msg, pi_program || '-', pi_occurrence);

  --find end position of desired occurrence
  l_end_pos := INSTR(pi_msg, pi_program || '-', pi_occurrence + 1) - 1;

  IF NVL(l_start_pos,0) = 0
  THEN
    --no occurrences of programs' errors in message
    l_retval := NULL;
  ELSE
    l_start_pos := l_start_pos + 11;
    IF NVL(l_end_pos,-1) = -1
    THEN
      --desired occurrence is last or only in message
      l_retval := SUBSTR(pi_msg, l_start_pos);
    ELSE
      l_retval := SUBSTR(pi_msg, l_start_pos, l_end_pos - l_start_pos);
    END IF;
  END IF;

  RETURN l_retval;

END parse_error_message;
--
-----------------------------------------------------------------------------
--
FUNCTION parse_error_code(pi_msg        IN varchar2
                         ,pi_program    IN varchar2 DEFAULT 'ORA'
                         ,pi_occurrence IN number   DEFAULT 1
                         ) RETURN pls_integer IS

  l_start_pos number;

  l_retval      pls_integer;
  l_retval_char varchar2(6);
BEGIN
	--find start position of desired occurrence
  l_start_pos := INSTR(pi_msg, pi_program||'-', pi_occurrence);
--
  IF NVL(l_start_pos,0) = 0
   THEN
     --no occurrences of programs' errors in message
     l_retval := NULL;
  ELSE
     l_start_pos   := l_start_pos + 3;
     l_retval_char := SUBSTR(pi_msg, l_start_pos, 6);
     IF nm3flx.is_numeric(l_retval_char)
      THEN
        l_retval := TO_NUMBER(l_retval_char);
     ELSE
        l_retval := NULL;
     END IF;
  END IF;
--
  RETURN l_retval;
--
END parse_error_code;
--
-----------------------------------------------------------------------------
--
FUNCTION can_string_be_select_from_dual (p_string varchar2) RETURN boolean IS
   l_retval boolean;
   l_dummy  varchar2(4000);
BEGIN
   BEGIN
      EXECUTE IMMEDIATE 'SELECT '||p_string||' FROM DUAL' INTO l_dummy;
      l_retval := TRUE;
   EXCEPTION
      WHEN others
       THEN
         l_retval := FALSE;
   END;
   RETURN l_retval;
END can_string_be_select_from_dual;
--
-----------------------------------------------------------------------------
--
FUNCTION can_string_be_select_from_tab(pi_string       IN varchar2
                                      ,pi_table        IN user_tables.table_name%TYPE
                                      ,pi_remove_binds IN boolean DEFAULT TRUE
                                      ) RETURN boolean IS

  l_string nm3type.max_varchar2;

  l_dummy  nm3type.max_varchar2;

  l_retval boolean;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'can_string_be_select_from_tab');

  IF pi_remove_binds
  THEN
    l_string := REPLACE(pi_string, ':', ' ');
  ELSE
    l_string := pi_string;
  END IF;

  BEGIN
    EXECUTE IMMEDIATE 'SELECT ' || l_string || ' FROM ' || pi_table || ' WHERE rownum = 1' INTO l_dummy;
    l_retval := TRUE;
  EXCEPTION
    WHEN no_data_found
    THEN
      l_retval := TRUE;
    WHEN others
    THEN
      l_retval := FALSE;
  END;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'can_string_be_select_from_tab');

  RETURN l_retval;

END can_string_be_select_from_tab;
--
-----------------------------------------------------------------------------
--
FUNCTION i_t_e(pi_expr IN boolean
              ,pi_then IN varchar2
              ,pi_else IN varchar2
              ) RETURN varchar2 IS

  l_retval nm3type.max_varchar2;

BEGIN
  IF pi_expr
  THEN
    l_retval := pi_then;
  ELSE
    l_retval := pi_else;
  END IF;

  RETURN l_retval;
END i_t_e;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_columns_for_table(pi_table_name      IN     varchar2
                               ,pi_owner           IN     varchar2 DEFAULT hig.get_application_owner
                               ,pi_column_name     IN     varchar2 DEFAULT NULL
                               ,po_tab_column_name IN OUT nm3type.tab_varchar30
                               ,po_tab_data_type   IN OUT nm3type.tab_varchar30
                               ,po_tab_data_length IN OUT nm3type.tab_number
                               ,po_tab_nullable    IN OUT nm3type.tab_varchar4) IS

BEGIN

 nm_debug.proc_start(g_package_name , 'get_columns_for_table');

 SELECT column_name
       ,data_type
       ,data_length
       ,nullable
 BULK COLLECT
 INTO  po_tab_column_name
      ,po_tab_data_type
      ,po_tab_data_length
      ,po_tab_nullable
 FROM  all_tab_columns
 WHERE table_name = UPPER(pi_table_name)
 AND   owner = pi_owner
 AND   column_name = NVL(UPPER(pi_column_name), column_name);  -- if column named passed in then restrict query to that column

 nm_debug.proc_end(g_package_name , 'get_columns_for_table');

END get_columns_for_table;
--
-----------------------------------------------------------------------------
--
FUNCTION get_column_datatype(pi_table_name  IN varchar2
                            ,pi_column_name IN varchar2) RETURN varchar2 IS

 v_tab_column_name    nm3type.tab_varchar30;
 v_tab_data_type      nm3type.tab_varchar30;
 v_tab_data_length    nm3type.tab_number;
 v_tab_nullable       nm3type.tab_varchar4;

BEGIN

    nm3flx.get_columns_for_table(pi_table_name    => pi_table_name
                              ,pi_owner           => hig.get_application_owner
                              ,pi_column_name     => pi_column_name
                              ,po_tab_column_name => v_tab_column_name
                              ,po_tab_data_type   => v_tab_data_type
                              ,po_tab_data_length => v_tab_data_length
                              ,po_tab_nullable    => v_tab_nullable);

    RETURN (v_tab_data_type(1));

EXCEPTION

  WHEN others THEN
    RETURN('VARCHAR2');

END get_column_datatype;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_to_where_clause(pi_existing_clause      IN OUT varchar2
                             ,pi_prefix_with_where    IN     boolean
                             ,pi_column_name          IN     varchar2
                             ,pi_column_datatype      IN     varchar2 DEFAULT 'VARCHAR2'
                             ,pi_operator             IN     varchar2 DEFAULT '='
                             ,pi_string_value         IN     varchar2
                             ) IS
BEGIN

      -----------------------------------------------------
      -- Will build a where clause on the fly
      -- Initially used by hig_hd_query package but useful
      -- where building any dynamic sql queries
      -----------------------------------------------------
      nm_debug.proc_start(g_package_name, 'add_to_where_clause');

      IF pi_existing_clause IS NOT NULL THEN
         pi_existing_clause := pi_existing_clause || ' AND ';
      END IF;

      IF pi_prefix_with_where = TRUE AND pi_existing_clause IS NULL THEN
         pi_existing_clause := 'WHERE ';
      END IF;

      IF pi_column_datatype = 'NUMBER' THEN
         pi_existing_clause := pi_existing_clause || pi_column_name||pi_operator||''||pi_string_value||'';
         --------------------------
         -- e.g. where column = x
         --------------------------
      ELSE
         pi_existing_clause := pi_existing_clause || pi_column_name||pi_operator||''''||pi_string_value||'''';
         --------------------------
         -- e.g. where column = 'x'
         --------------------------
      END IF;

      nm_debug.proc_end(g_package_name, 'add_to_where_clause');

END add_to_where_clause;
--
-----------------------------------------------------------------------------
--
--
-----------------------------------------------------------------------------
--
FUNCTION string_contains_numbers ( pi_string  VARCHAR2) RETURN BOOLEAN IS
BEGIN

  IF TRANSLATE(UPPER(pi_string),
   '&' || '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ '',-', '00123456789') 
   IS NOT NULL 
  THEN 
     RETURN(TRUE);
  ELSE
     RETURN(FALSE);
  END IF ;
  
EXCEPTION
  WHEN others THEN
     RETURN(FALSE);  
END string_contains_numbers;
--
-----------------------------------------------------------------------------
-- return true if string contains any special characters (currently outside of the 
-- range 'A'-'Z', 'a'-'z' and '_')
-- Special characters - select chr(ncsm_ascii_character) from nm_character_set_members
--
FUNCTION string_contains_special_chars (pi_string IN VARCHAR2)
   RETURN BOOLEAN
IS
BEGIN
  --
  RETURN(string_has_chars_IN_set( pi_string                    => pi_string
                                , pi_tab_character_set_members => get_character_set_members(pi_character_set => 'INVALID_FOR_DDL')
                                ));  
  --
END string_contains_special_chars;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_character_set_members(pi_character_set         IN nm_character_sets.ncs_code%TYPE) RETURN nm3type.tab_varchar1 IS

  CURSOR c_ncsm
   IS
   SELECT chr(ncsm_ascii_character) char_to_check
   FROM   nm_character_set_members
   WHERE  ncsm_ncs_code = UPPER(pi_character_set);
   
   l_retval nm3type.tab_varchar1;

BEGIN
   
   OPEN c_ncsm;
   FETCH c_ncsm BULK COLLECT INTO l_retval;
   CLOSE c_ncsm;

   RETURN(l_retval);
   
END get_character_set_members;
--
----------------------------------------------------------------------------------------------
-- 
FUNCTION string_has_chars_IN_set(pi_string                  IN VARCHAR2
                                ,pi_tab_character_set_members  IN nm3type.tab_varchar1) RETURN BOOLEAN IS
--
-- for when you have a character set of all not permitted characters
-- and you want to check if a string contains any of them
--   
                                    
BEGIN 
 
   --
   -- loop thru all characters in the list of exclusion characters
   -- and make sure that there are no characters in the string that match
   --
   FOR i IN 1..pi_tab_character_set_members.COUNT LOOP
      IF INSTR (pi_string, pi_tab_character_set_members(i)) > 0
      THEN
         RETURN (TRUE);
      END IF;
   END LOOP;
   

   RETURN (FALSE);

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN (FALSE);
END string_has_chars_IN_set;
--
----------------------------------------------------------------------------------------------
--
FUNCTION string_has_chars_IN_set_vc(pi_string                     IN VARCHAR2
                                   ,pi_tab_character_set_members  IN nm3type.tab_varchar1) RETURN VARCHAR2 IS
                                
BEGIN

 RETURN(
        nm3flx.boolean_to_char(
                               p_boolean => string_has_chars_IN_set(
                                                                    pi_string                    => pi_string
                                                                   ,pi_tab_character_set_members => pi_tab_character_set_members
                                                                   )
                              )
       );                                                                   

END string_has_chars_IN_set_vc;                                
--
----------------------------------------------------------------------------------------------
--
FUNCTION string_has_chars_NOT_IN_set(pi_string                     IN VARCHAR2
                                    ,pi_tab_character_set_members  IN nm3type.tab_varchar1) RETURN BOOLEAN IS
                                       
-- for when you have a character set of all permitted characters
-- and you want to check if a string contains any additional characters

 l_char VARCHAR2(1);
 l_char_is_ok BOOLEAN;
                                    
BEGIN 
 
   --
   -- loop thru each character in the string and make sure there are 
   -- no characters that are not in the character set
   --
    FOR x IN 1..LENGTH(pi_string) LOOP
     l_char := SUBSTR(pi_string,x,1);
     l_char_is_ok := FALSE;
      FOR i IN 1..pi_tab_character_set_members.COUNT LOOP
         IF INSTR (l_char, pi_tab_character_set_members(i)) > 0
         THEN
            l_char_is_ok := TRUE;
            EXIT;
         END IF;
      END LOOP;
      IF NOT l_char_is_ok THEN
        RETURN(TRUE);
      END IF;        

    END LOOP;     

    RETURN (FALSE);

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN (FALSE);
END string_has_chars_NOT_IN_SET;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE copy_character_set( pi_from  IN nm_character_sets.ncs_code%TYPE
                            , pi_to    IN nm_character_sets.ncs_code%TYPE
                            , pi_descr IN nm_character_sets.ncs_description%TYPE
                            ) IS
BEGIN
  Insert Into nm_character_sets( ncs_code
                               , ncs_description
                               ) 
                         values( pi_to
                               , pi_descr
                               );
  --
  Insert Into nm_character_set_members( ncsm_ncs_code
                                      , ncsm_ascii_character
                                      )
                                 Select pi_to
                                      , ncsm_ascii_character
                                 From   nm_character_set_members
                                 Where  ncsm_ncs_code = pi_from; 
  --
End copy_character_set;
--
----------------------------------------------------------------------------------------------
--
FUNCTION string_is_unchanged(pi_old IN VARCHAR2
                            ,pi_new IN VARCHAR2) RETURN BOOLEAN IS
                     
BEGIN
 
 RETURN(
        NVL(pi_old,c_nvl_string) = NVL(pi_new, c_nvl_string)
       );
       
END string_is_unchanged;
--
-----------------------------------------------------------------------------
--
FUNCTION date_is_unchanged(pi_old IN DATE
                          ,pi_new IN DATE) RETURN BOOLEAN IS
                     
BEGIN
 
 RETURN(
        NVL(pi_old,c_nvl_date) = NVL(pi_new, c_nvl_date)
       );
       
END date_is_unchanged;
--
-----------------------------------------------------------------------------
--
FUNCTION number_is_unchanged(pi_old IN NUMBER
                            ,pi_new IN NUMBER) RETURN BOOLEAN IS
                     
BEGIN
 
 RETURN(
        NVL(pi_old,c_nvl_number) = NVL(pi_new, c_nvl_number)
       );
       
END number_is_unchanged;
--
-----------------------------------------------------------------------------
--
FUNCTION search_in_long( p_long           LONG
                       , p_search_val     VARCHAR2
                       , p_ignore_case    BOOLEAN DEFAULT TRUE)
  RETURN BOOLEAN
IS
  --
  l_search_block_size  NUMBER(10) := 4000 - length(p_search_val);
  l_start_position     NUMBER(10) := 1;
  l_char               VARCHAR2(32767) := substr(p_long, l_start_position, 4000);
  l_found              BOOLEAN := FALSE;
--
BEGIN
  --
  WHILE length(l_char) > 0
        AND NOT l_found
  LOOP
    --
    IF p_ignore_case THEN
      --
      IF upper(l_char) LIKE '%' || upper(p_search_val) || '%' THEN
        l_found   := TRUE;
      ELSE
        l_start_position   := l_start_position + l_search_block_size;
      END IF;
    --
    ELSE
      --
      IF l_char LIKE '%' || p_search_val || '%' THEN
        l_found   := TRUE;
      ELSE
        l_start_position   := l_start_position + l_search_block_size;
      END IF;
    --
    END IF;

    l_char   := substr(p_long, l_start_position, 4000);
  END LOOP;
  --
  RETURN l_found;
END search_in_long;
--
-----------------------------------------------------------------------------
--
FUNCTION is_string_valid_for_password (pi_password IN varchar2) 
RETURN BOOLEAN
IS
--
l_dummy VARCHAR2(2000);
--
BEGIN
  RETURN is_string_valid_for_password(pi_password => pi_password, po_reason => l_dummy);
END;
--
-----------------------------------------------------------------------------
--
FUNCTION is_string_valid_for_password (pi_password IN varchar2, po_reason OUT varchar2) 
RETURN BOOLEAN 
IS
--
   l_string_length binary_integer := LENGTH(pi_password);
   --l_invalid_chars nm3type.tab_varchar1;
--
   l_retval boolean := TRUE;
--
BEGIN
   -- Checks password is not too large
   l_retval := (l_string_length BETWEEN 1 AND 30);
   -- Check for invalid characters defined above.
   IF NOT l_retval
   THEN
     po_reason:= 'Password was greater than 30 characters';
   ELSE
      FOR lic IN 1..g_invalid_chars.COUNT 
      LOOP
        FOR l_count IN 1..l_string_length
        LOOP
           IF  SUBSTR(pi_password,l_count,1) = g_invalid_chars(lic)
           THEN
             l_retval := FALSE;
             po_reason:= 'The Character ''' || g_invalid_chars(lic) || ''' cannot be used in a password.'; 
             EXIT;
           END IF;
        END LOOP;
       --
        IF l_retval = FALSE THEN
          EXIT;
        END IF;
      END LOOP;
   END IF;
--
   RETURN l_retval;
--
END is_string_valid_for_password;
--
-----------------------------------------------------------------------------
--
END nm3flx;
/
