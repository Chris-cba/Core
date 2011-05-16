CREATE OR REPLACE PACKAGE BODY nm3inv_xattr_gen AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3inv_xattr_gen.pkb-arc   2.2   May 16 2011 14:44:56   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3inv_xattr_gen.pkb  $
--       Date into PVCS   : $Date:   May 16 2011 14:44:56  $
--       Date fetched Out : $Modtime:   Apr 04 2011 08:10:18  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.9
-------------------------------------------------------------------------
--
--   Author : Jonathan Mills
--
--   NM3 Inventory X-Attribute Trigger Generation package body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
--all global package variables here
--
--  g_body_sccsid is the SCCS ID for the package body
--
   g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.2  $';
   g_package_name    CONSTANT  varchar2(30)   := 'nm3inv_xattr_gen';
--
   g_tab_varchar     nm3type.tab_varchar32767;
--
   g_xattr_gen_exception EXCEPTION;
   g_xattr_gen_exc_code  number;
   g_xattr_gen_exc_msg   varchar2(4000);
--
   c_p_rec_iit CONSTANT varchar2(30) := 'p_rec_iit';
--
-----------------------------------------------------------------------------
--
FUNCTION replace_colon_new (p_value VARCHAR2) RETURN VARCHAR2;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_data;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_driving_conditions (p_inv_type nm_inv_types.nit_inv_type%TYPE);
--
-----------------------------------------------------------------------------
--
PROCEDURE do_validation_conditions (p_rule_id nm_x_rules.nxr_rule_id%TYPE);
--
-----------------------------------------------------------------------------
--
FUNCTION indent (p_num_spaces number) RETURN varchar2 IS
BEGIN
   RETURN RPAD(' ',p_num_spaces,' ');
END indent;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_tab_varchar IS
BEGIN
   g_tab_varchar.DELETE;
END clear_tab_varchar;
--
-----------------------------------------------------------------------------
--
PROCEDURE append (p_text varchar2
                 ,p_nl   boolean DEFAULT TRUE
                 ) IS
BEGIN
   nm3ddl.append_tab_varchar(g_tab_varchar,p_text,p_nl);
END append;
--
-----------------------------------------------------------------------------
--
PROCEDURE lock_inv_items IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_inv_items');
--
   EXECUTE IMMEDIATE 'LOCK TABLE nm_inv_items_all IN EXCLUSIVE MODE NOWAIT';
--
   nm_debug.proc_end(g_package_name,'lock_inv_items');
--
END lock_inv_items;
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
FUNCTION generate_single_inv_record_trg RETURN tab_ae IS
--
   CURSOR cs_ae IS
   SELECT *
    FROM  all_errors
   WHERE  owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   name  = c_xattr_validation_proc_name
   ORDER BY SEQUENCE;
--
   l_rec_ae tab_ae;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'generate_single_inv_record_trg');
--
   DECLARE
      l_errors_found EXCEPTION;
      PRAGMA EXCEPTION_INIT(l_errors_found,-24344);
   BEGIN
      generate_single_inv_record_trg;
   EXCEPTION
      WHEN l_errors_found
       THEN
         FOR cs_rec IN cs_ae
          LOOP
            l_rec_ae(l_rec_ae.COUNT+1) := cs_rec;
         END LOOP;
   END;
--
   nm_debug.proc_end(g_package_name,'generate_single_inv_record_trg');
--
   RETURN l_rec_ae;
--
END generate_single_inv_record_trg;
--
-----------------------------------------------------------------------------
--
PROCEDURE generate_single_inv_record_trg IS
--
   CURSOR cs_driving_inv_type IS
   SELECT nxic_inv_type, nit_descr, nit_screen_seq
    FROM  nm_x_rules
         ,nm_x_driving_conditions
         ,nm_x_inv_conditions
         ,nm_inv_types
   WHERE  nxr_type         = 3
    AND   nxr_rule_id      = nxd_rule_id
    AND   nxd_if_condition = nxic_id
    AND   nit_inv_type     = nxic_inv_type
   GROUP BY nxic_inv_type, nit_descr, nit_screen_seq
   ORDER BY nit_screen_seq;
--
   l_if           varchar2(20);
   l_been_in_loop boolean := FALSE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'generate_single_inv_record_trg');
--
   nm3user.restricted_user_check;
--
   validate_data;
--
   lock_inv_items;
--
   clear_tab_varchar;
--
   append ('CREATE OR REPLACE PROCEDURE '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||c_xattr_validation_proc_name||' ('||c_p_rec_iit||' IN nm_inv_items_all%ROWTYPE) IS');
   append ('--');
   append ('--   SCCS Identifiers (of generating package) :-');
   append ('--');
   append ('--       sccsid           : @(#)nm3inv_xattr_gen.pkb	1.9 01/02/03');
   append ('--       Module Name      : nm3inv_xattr_gen.pkb');
   append ('--       Date into SCCS   : 03/01/02 16:08:11');
   append ('--       Date fetched Out : 07/06/13 14:12:10');
   append ('--       SCCS Version     : 1.9');
   append ('--');
   append ('--   Inventory Cross-Attribute Validation Procedure');
   append ('--');
   append ('--   ####################################################');
   append ('--   ##                                                ##');
   append ('--   ## THIS PROCEDURE IS GENERATED FROM WITHIN NM0550 ##');
   append ('--   ##            DO NOT MODIFY MANUALLY              ##');
   append ('--   ##                                                ##');
   append ('--   ####################################################');
   append ('--');
   append ('-----------------------------------------------------------------------------');
   append ('--      Copyright (c) exor corporation ltd, 2003');
   append ('-----------------------------------------------------------------------------');
   append ('--');
   append ('--  Generation Details :-');
   append ('--  Generated : '||TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS'));
   append ('--  User      : '||USER);
   append ('--  Terminal  : '||USERENV('TERMINAL'));
   append ('--');
   append (indent(3)||'x_exception EXCEPTION;');
   append (indent(3)||'x_error_no  NUMBER;');
   append ('--');
   append ('BEGIN');
   append ('--');
--
   l_if := indent(3)||'IF ';
   FOR cs_outer IN cs_driving_inv_type
    LOOP
      append (indent(3)||'--');
      append (indent(3)||'-- '||cs_outer.nit_descr);
      append (indent(3)||'--');
      append (l_if||c_p_rec_iit||'.iit_inv_type = '||nm3flx.string(cs_outer.nxic_inv_type)||' THEN');
      l_if := indent(3)||'ELSIF ';
      append ('--');
      do_driving_conditions (cs_outer.nxic_inv_type);
      l_been_in_loop := TRUE;
      append (indent(3)||'--');
      append (indent(3)||'-- End of '||cs_outer.nxic_inv_type);
      append (indent(3)||'--');
   END LOOP;
   IF l_been_in_loop
    THEN
      append (indent(3)||'END IF;');
   ELSE
      append (indent(3)||'Null;');
   END IF;
   append ('--');
   append ('EXCEPTION');
   append ('--');
   append (indent(3)||'WHEN x_exception');
   append (indent(3)||' THEN');
   append (indent(6)||'RAISE_APPLICATION_ERROR( -20760, '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||g_package_name||'.get_error_string(x_error_no));');
   append ('--');
   append ('END '||c_xattr_validation_proc_name||';');
--
--   nm_debug.delete_debug(TRUE);
--   nm_debug.debug_on;
--   nm3ddl.debug_tab_varchar(g_tab_varchar);
   nm3ddl.execute_tab_varchar(g_tab_varchar);
   clear_tab_varchar;
--
   nm_debug.proc_end(g_package_name,'generate_single_inv_record_trg');
--
EXCEPTION
--
   WHEN g_xattr_gen_exception
    THEN
      Raise_Application_Error(g_xattr_gen_exc_code,g_xattr_gen_exc_msg);
--
END generate_single_inv_record_trg;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_driving_conditions (p_inv_type nm_inv_types.nit_inv_type%TYPE) IS
--
   CURSOR cs_distinct_drivers (c_inv_type nm_inv_types.nit_inv_type%TYPE) IS
   SELECT DISTINCT nxr_rule_id, nxr_seq_no
    FROM  nm_x_rules
         ,nm_x_driving_conditions
         ,nm_x_inv_conditions
   WHERE  nxr_type         = 3
    AND   nxr_rule_id      = nxd_rule_id
    AND   nxd_if_condition = nxic_id
    AND   nxic_inv_type    = c_inv_type
   ORDER BY nxr_seq_no;
--
   CURSOR cs_driving (c_rule_id nm_x_rules.nxr_rule_id%TYPE) IS
   SELECT *
    FROM  nm_x_driving_conditions
         ,nm_x_inv_conditions
   WHERE  nxd_rule_id      = c_rule_id
    AND   nxd_if_condition = nxic_id
   ORDER BY nxd_rule_seq_no;
--
   l_been_in_loop     boolean      := FALSE;
   l_been_in_any_loop boolean      := FALSE;
--
   l_if           varchar2(30);
--
BEGIN
--
   FOR cs_outer IN cs_distinct_drivers (p_inv_type)
    LOOP
--
      l_been_in_any_loop := TRUE;
--
      l_if := indent(6)||'IF ';
      FOR cs_rec IN cs_driving (cs_outer.nxr_rule_id)
       LOOP
         append (l_if||cs_rec.nxd_and_or||cs_rec.nxd_st_char
                 ||' '||c_p_rec_iit||'.'||cs_rec.nxic_column_name||' '
                 ||cs_rec.nxic_condition||' '||replace_colon_new(cs_rec.nxic_value_list)
                 ||' '||cs_rec.nxd_end_char||' -- '||cs_rec.nxic_inv_attr
                );
         l_if           := indent(6);
         l_been_in_loop := TRUE;
      END LOOP;
   --
      IF l_been_in_loop
       THEN
         append (indent(6)||' THEN -- nxr_rule_id : '||cs_outer.nxr_rule_id||' (seq '||cs_outer.nxr_seq_no||')');
         append ('--');
         do_validation_conditions (cs_outer.nxr_rule_id);
         append (indent(6)||'END IF;');
      ELSE
         append (indent(6)||'Null;');
      END IF;
      append ('--');
--
   END LOOP;
--
   IF NOT l_been_in_any_loop
    THEN
      append (indent(6)||'Null;');
   END IF;
--
END do_driving_conditions;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_validation_conditions (p_rule_id nm_x_rules.nxr_rule_id%TYPE) IS
--
   CURSOR cs_val (c_rule_id nm_x_rules.nxr_rule_id%TYPE) IS
   SELECT *
    FROM  nm_x_val_conditions
         ,nm_x_inv_conditions
   WHERE  nxv_rule_id      = c_rule_id
    AND   nxv_if_condition = nxic_id
   ORDER BY nxv_rule_seq_no;
--
   CURSOR cs_rule (c_rule_id nm_x_rules.nxr_rule_id%TYPE) IS
   SELECT nxr_error_id
         ,nxr_descr
    FROM  nm_x_rules
   WHERE  nxr_rule_id = c_rule_id;
--
   l_if           varchar2(30) := indent(9)||'IF ';
--
   l_been_in_loop boolean      := FALSE;
--
   l_error_id     nm_x_rules.nxr_error_id%TYPE;
   l_descr        nm_x_rules.nxr_descr%TYPE;
--
   PROCEDURE do_error (p_indent NUMBER) IS
   BEGIN
      append (indent(p_indent)||'/* '||l_descr||' */');
      append (indent(p_indent)||'/* '||get_error_string(l_error_id)||' */');
      append (indent(p_indent)||'x_error_no := '||l_error_id||';');
      append (indent(p_indent)||'RAISE x_exception;');
   END do_error;
--
BEGIN
--
   OPEN  cs_rule (p_rule_id);
   FETCH cs_rule INTO l_error_id, l_descr;
   CLOSE cs_rule;
--
   FOR cs_rec IN cs_val (p_rule_id)
    LOOP
      append (l_if||cs_rec.nxv_and_or||cs_rec.nxv_st_char
              ||' '||c_p_rec_iit||'.'||cs_rec.nxic_column_name||' '
              ||cs_rec.nxic_condition||' '||replace_colon_new(cs_rec.nxic_value_list)
              ||' '||cs_rec.nxv_end_char||' -- '||cs_rec.nxic_inv_attr
             );
      l_if           := indent(9);
      l_been_in_loop := TRUE;
   END LOOP;
--
   IF l_been_in_loop
    THEN
      append (indent(9)||' THEN');
      do_error (12);
      append (indent(9)||'END IF;');
   ELSE
      do_error (9);
   END IF;
   append ('--');
--
END do_validation_conditions;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nxe(pi_nxe_id IN nm_x_errors.nxe_id%TYPE
                ) RETURN nm_x_errors%ROWTYPE IS
BEGIN
  RETURN nm3get.get_nxe (pi_nxe_id => pi_nxe_id);
END get_nxe;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nxic(pi_nxic_id IN nm_x_inv_conditions.nxic_id%TYPE
                 ) RETURN nm_x_inv_conditions%ROWTYPE IS
BEGIN
  RETURN nm3get.get_nxic (pi_nxic_id => pi_nxic_id);
END get_nxic;
--
-----------------------------------------------------------------------------
--
FUNCTION get_if_condition_text(pi_nxic_rec nm_x_inv_conditions%ROWTYPE
                              ) RETURN varchar2 IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_if_condition_text');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_if_condition_text');

  RETURN    pi_nxic_rec.nxic_inv_type
         || '.'
         || pi_nxic_rec.nxic_inv_attr
         || ' '
         || pi_nxic_rec.nxic_condition
         || ' '
         || pi_nxic_rec.nxic_value_list;

END get_if_condition_text;
--
-----------------------------------------------------------------------------
--
FUNCTION get_next_nxr_id RETURN nm_x_rules.nxr_rule_id%TYPE IS
BEGIN
  RETURN nm3seq.next_nxr_id_seq;
END get_next_nxr_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_next_nxic_id RETURN nm_x_inv_conditions.nxic_id%TYPE IS
BEGIN
  RETURN nm3seq.next_nxic_id_seq;
END get_next_nxic_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_error_string (pi_err_id IN nm_x_errors.nxe_id%TYPE ) RETURN VARCHAR2 IS
--
   CURSOR c1 (c_err_id nm_x_errors.nxe_id%TYPE) IS
   SELECT nxe_error_class||'-'||TO_CHAR(nxe_id)||' '||nxe_error_text
    FROM  nm_x_errors
   WHERE  nxe_id = pi_err_id;
--
   retval VARCHAR2(100);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_error_string');
--
   OPEN  c1 (pi_err_id);
   FETCH c1 INTO retval;
   CLOSE c1;
--
   nm_debug.proc_start(g_package_name,'get_error_string');
--
   RETURN retval;
--
END get_error_string;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_data IS
--
   CURSOR cs_all_rules IS
   SELECT *
    FROM  nm_x_rules;
--
   CURSOR cs_driving (c_rule_id nm_x_driving_conditions.nxd_rule_id%TYPE) IS
   SELECT *
    FROM  nm_x_driving_conditions
   WHERE  nxd_rule_id = c_rule_id
   ORDER BY nxd_rule_seq_no;
--
   CURSOR cs_validation (c_rule_id nm_x_val_conditions.nxv_rule_id%TYPE) IS
   SELECT *
    FROM  nm_x_val_conditions
   WHERE  nxv_rule_id = c_rule_id
   ORDER BY nxv_rule_seq_no;
--
   l_prior_seq_no   NUMBER;
--
   l_rec_nxic       nm_x_inv_conditions%ROWTYPE;
   l_prior_rec_nxic nm_x_inv_conditions%ROWTYPE;
--
BEGIN
--
   FOR cs_outer IN cs_all_rules
    LOOP
--
      FOR cs_drv IN cs_driving (cs_outer.nxr_rule_id)
       LOOP
         IF cs_driving%ROWCOUNT = 1
          THEN
            IF cs_drv.nxd_and_or IS NOT NULL
             THEN
               g_xattr_gen_exc_code := -20107;
               g_xattr_gen_exc_msg  := 'Boolean connector cannot be present for first driving condition';
               RAISE g_xattr_gen_exception;
            END IF;
         ELSE
            IF l_prior_seq_no = cs_drv.nxd_rule_seq_no
             THEN
               g_xattr_gen_exc_code := -20109;
               g_xattr_gen_exc_msg  := 'Driving conditions may not have the same seq no within the same rule';
               RAISE g_xattr_gen_exception;
            END IF;
            IF cs_drv.nxd_and_or IS NULL
             THEN
               g_xattr_gen_exc_code := -20108;
               g_xattr_gen_exc_msg  := 'Boolean connector must be present for driving conditions other than the first';
               RAISE g_xattr_gen_exception;
            END IF;
         END IF;
         l_prior_seq_no := cs_drv.nxd_rule_seq_no;
         l_rec_nxic     := get_nxic(pi_nxic_id => cs_drv.nxd_if_condition);
         IF   cs_driving%ROWCOUNT > 1
          AND l_rec_nxic.nxic_inv_type != l_prior_rec_nxic.nxic_inv_type
          THEN
            g_xattr_gen_exc_code := -20103;
            g_xattr_gen_exc_msg  := 'nm_x_inv_conditions records must all be for the same INV_TYPE for the same driving condition';
            RAISE g_xattr_gen_exception;
         END IF;
         l_prior_rec_nxic := l_rec_nxic;
      END LOOP;
--
      IF l_prior_rec_nxic.nxic_inv_type IS NULL
       THEN
         -- Only if we've not had a driving condition
         g_xattr_gen_exc_code := -20106;
         g_xattr_gen_exc_msg  := 'At least 1 nm_x_driving_conditions record must exist for each rule';
         RAISE g_xattr_gen_exception;
      END IF;
--
      FOR cs_val IN cs_validation (cs_outer.nxr_rule_id)
       LOOP
         IF cs_validation%ROWCOUNT = 1
          THEN
            IF cs_val.nxv_and_or IS NOT NULL
             THEN
               g_xattr_gen_exc_code := -20110;
               g_xattr_gen_exc_msg  := 'Boolean connector cannot be present for first validation condition';
               RAISE g_xattr_gen_exception;
            END IF;
         ELSE
            IF l_prior_seq_no = cs_val.nxv_rule_seq_no
             THEN
               g_xattr_gen_exc_code := -20112;
               g_xattr_gen_exc_msg  := 'Validation conditions may not have the same seq no within the same rule';
               RAISE g_xattr_gen_exception;
            END IF;
            IF cs_val.nxv_and_or IS NULL
             THEN
               g_xattr_gen_exc_code := -20111;
               g_xattr_gen_exc_msg  := 'Boolean connector must be present for validation conditions other than the first';
               RAISE g_xattr_gen_exception;
            END IF;
         END IF;
         l_prior_seq_no := cs_val.nxv_rule_seq_no;
         l_rec_nxic := get_nxic(pi_nxic_id => cs_val.nxv_if_condition);
         IF l_rec_nxic.nxic_inv_type != l_prior_rec_nxic.nxic_inv_type
          THEN
            IF cs_validation%ROWCOUNT = 1
             THEN
               g_xattr_gen_exc_code := -20104;
               g_xattr_gen_exc_msg  := 'nm_x_inv_conditions records must all be for the same INV_TYPE for driving conditions and validation conditions';
            ELSE
               g_xattr_gen_exc_code := -20105;
               g_xattr_gen_exc_msg  := 'nm_x_inv_conditions records must all be for the same INV_TYPE for the same validation condition';
            END IF;
            RAISE g_xattr_gen_exception;
         END IF;
         l_prior_rec_nxic := l_rec_nxic;
      END LOOP;
--
   END LOOP;
--
END validate_data;
--
-----------------------------------------------------------------------------
--
FUNCTION replace_colon_new (p_value VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   RETURN REPLACE(p_value,':NEW.',''||c_p_rec_iit||'.');
END replace_colon_new;
--
-----------------------------------------------------------------------------
--
END nm3inv_xattr_gen;
/
