CREATE OR REPLACE PACKAGE BODY nm3context AS
--
-----------------------------------------------------------------------------
--
-- PVCS Identifiers :-
--
-- pvcsid : $Header:   //vm_latest/archives/nm3/admin/pck/nm3context.pkb-arc   2.4   Feb 05 2008 10:50:12   jwadsworth  $
-- Module Name : $Workfile:   nm3context.pkb  $
-- Date into PVCS : $Date:   Feb 05 2008 10:50:12  $
-- Date fetched Out : $Modtime:   Feb 05 2008 10:40:00  $
-- PVCS Version : $Revision:   2.4  $
-- Based on SCCS version : 
--
--
--   Author : Jonathan Mills
--
--   Package for setting/retrieving context values
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
   g_body_sccsid     CONSTANT  varchar2(2000) :='"$Revision:   2.4  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
--all global package variables here
--
   -- This is the date format in which dates will be stored within the context
   --  values
   c_date_format     CONSTANT varchar2(20) := 'DD-MON-YYYY';
--
   TYPE tab_varchar30 IS TABLE OF varchar2(30) INDEX BY binary_integer;
   TYPE tab_boolean   IS TABLE OF boolean      INDEX BY binary_integer;
   g_tab_userenv_context tab_varchar30;
--
   g_tab_context_read_only tab_boolean;
   g_enforce_read_only     boolean := TRUE;
--
   g_application_owner             varchar2(30);
--
   TYPE tab_val IS TABLE OF varchar2(4000) INDEX BY binary_integer;
   g_tab_values        tab_val;
--
   g_context_exception EXCEPTION;
   g_context_exc_code  number;
   g_context_exc_msg   varchar2(4000);
--
   g_enterprise_edn    boolean;
--
   g_effective_date    date                  := TRUNC(SYSDATE);
   c_eff_date_name     CONSTANT varchar2(30) := 'EFFECTIVE_DATE';
--
   TYPE attrib_dets IS RECORD
      (data_type       varchar2(30)
      ,read_only       boolean
      );
--
-----------------------------------------------------------------------------
--
FUNCTION get_user_sysopt (pi_sysopt  hig_option_values.hov_id%TYPE         DEFAULT NULL
                         ,pi_userid  hig_user_options.huo_hus_user_id%TYPE DEFAULT NULL
                         ,pi_useopt  hig_user_options.huo_id%TYPE          DEFAULT NULL
                         ,pi_default varchar2                              DEFAULT NULL
                         ) RETURN varchar2;
--
-----------------------------------------------------------------------------
--
FUNCTION get_attribute_details (pi_attribute IN varchar2) RETURN attrib_dets;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_update_allowed(pi_attribute IN varchar2);
--
-----------------------------------------------------------------------------
--
PROCEDURE instantiate_data;
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
procedure initialise_context
IS
begin
   initialise_context(user);
end initialise_context ;
--
-----------------------------------------------------------------------------
--
PROCEDURE initialise_context(pi_username varchar2) 
is
   l_user_id          hig_users.hus_user_id%TYPE;
   l_hus_unrestricted hig_users.hus_unrestricted%TYPE;
--
   l_unrestricted_inv varchar2(5);
   l_unrestricted_acc varchar2(5);
   l_user             varchar2(30) := pi_username;
--
   CURSOR cs_inst IS
   SELECT instance_name
         ,host_name
         ,VERSION
    FROM  v$instance;
--
   l_instance   v$instance.instance_name%TYPE;
   l_host       v$instance.host_name%TYPE;
   l_db_version v$instance.VERSION%TYPE;
--
   l_enterprise_edn varchar2(5);
   l_dummy          varchar2(1);
--
BEGIN
--
   g_enforce_read_only := FALSE;
   g_tab_values.DELETE;
--
   FOR cs_rec IN (SELECT hus_user_id
                        ,hus_unrestricted
                        ,DECODE(hur_role
                               ,NULL,c_false
                               ,c_true
                               ) unrestricted_acc
                  FROM   hig_users
                        ,hig_user_roles
                  WHERE  hus_username = l_user
                   AND   hus_username = hur_username (+)
                   AND   hur_role (+) = 'ACC_ADMIN'
                 )
    LOOP
      -- This is declared as an in-line cursor because as this
      --  package is declared with invoker's rights if the cursor
      --  is defined explicitly it still executes with definer's
      --  rights
      l_user_id          := cs_rec.hus_user_id;
      l_hus_unrestricted := cs_rec.hus_unrestricted;
      l_unrestricted_acc := cs_rec.unrestricted_acc;
   END LOOP;
--
   IF g_enterprise_edn
    THEN
      l_enterprise_edn := c_true;
   ELSE
      l_enterprise_edn := c_false;
   END IF;
--
   OPEN  cs_inst;
   FETCH cs_inst INTO l_instance
                     ,l_host
                     ,l_db_version;
   CLOSE cs_inst;
--
   IF l_user_id IS NULL
    THEN
      RAISE_APPLICATION_ERROR(-20001,'User not found in HIG_USERS');
   END IF;
--
   IF l_hus_unrestricted = 'Y'
    THEN
      l_unrestricted_inv := c_true;
   ELSE
      l_unrestricted_inv := c_false;
   END IF;
--
-- EFFECTIVE_DATE
   set_context (pi_attribute => g_tab_rec_context(1).attribute_name
               ,pi_value     => g_effective_date
               );
--
-- USER_LENGTH_UNITS
   set_context (pi_attribute => g_tab_rec_context(2).attribute_name
               ,pi_value     => get_user_sysopt (pi_sysopt  => 'DEFUNITID'
                                                ,pi_userid  => l_user_id
                                                ,pi_useopt  => 'PREFUNITS'
                                                ,pi_default => '1'
                                                )
               );
--
-- USER_DATE_MASK
   set_context (pi_attribute => g_tab_rec_context(3).attribute_name
               ,pi_value     => get_user_sysopt (pi_userid  => l_user_id
                                                ,pi_useopt  => 'DATE_MASK'
                                                ,pi_default => 'DD-MON-YYYY'
                                                )
               );
--
-- DEFAULT_LENGTH_MASK
   set_context (pi_attribute => g_tab_rec_context(4).attribute_name
               ,pi_value     => '9999990.00'
               );
--
-- USER_LENGTH_MASK
   set_context (pi_attribute => g_tab_rec_context(5).attribute_name
               ,pi_value     => '9999990.00'
               );
--
-- USER_ID
   set_context (pi_attribute => g_tab_rec_context(6).attribute_name
               ,pi_value     => l_user_id
               );
--
-- UNRESTRICTED_INVENTORY
   set_context (pi_attribute => g_tab_rec_context(7).attribute_name
               ,pi_value     => l_unrestricted_inv
               );
--
-- APPLICATION_OWNER
   set_context (pi_attribute => g_tab_rec_context(8).attribute_name
               ,pi_value     => g_application_owner
               );
--
-- UNRESTRICTED_ACCIDENTS
   set_context (pi_attribute => g_tab_rec_context(9).attribute_name
               ,pi_value     => l_unrestricted_acc
               );
--
-- ENTERPRISE_EDITION
   set_context (pi_attribute => g_tab_rec_context(10).attribute_name
               ,pi_value     => l_enterprise_edn
               );
--
-- INSTANCE_NAME
   set_context (pi_attribute => g_tab_rec_context(11).attribute_name
               ,pi_value     => l_instance
               );
--
-- HOST_NAME
   set_context (pi_attribute => g_tab_rec_context(12).attribute_name
               ,pi_value     => l_host
               );
--
-- DB_VERSION
   set_context (pi_attribute => g_tab_rec_context(13).attribute_name
               ,pi_value     => l_db_version
               );
--
-- PREFERRED_LRM
   set_context (pi_attribute => g_tab_rec_context(14).attribute_name
               ,pi_value     => get_user_sysopt (pi_sysopt  => 'PREFLRM'
                                                ,pi_userid  => l_user_id
                                                ,pi_useopt  => 'PREFLRM'
                                                )
               );
--
-- ROI_ID
   set_context (pi_attribute => g_tab_rec_context(15).attribute_name
               ,pi_value     => get_user_sysopt (pi_sysopt  => NULL
                                                ,pi_userid  => l_user_id
                                                ,pi_useopt  => 'ROI_ID'
                                                )
               );
--
-- ROI_TYPE
   set_context (pi_attribute => g_tab_rec_context(16).attribute_name
               ,pi_value     => get_user_sysopt (pi_sysopt  => NULL
                                                ,pi_userid  => l_user_id
                                                ,pi_useopt  => 'ROI_TYPE'
                                                )
               );
   --      
   set_context (pi_attribute => g_tab_rec_context(17).attribute_name
               ,pi_value     => get_user_sysopt (pi_sysopt  => NULL
                                                ,pi_userid  => l_user_id
                                                ,pi_useopt  => 'DEFATTRSET'
                                                )
               );
--
   g_enforce_read_only := TRUE;
--
EXCEPTION
--
   WHEN others
    THEN
      g_enforce_read_only := TRUE;
      RAISE;
--
END initialise_context;
--
-----------------------------------------------------------------------------
--
FUNCTION get_attribute_details (pi_attribute IN varchar2) RETURN attrib_dets IS
--
   l_retval attrib_dets;
--
BEGIN
--
   IF g_tab_rec_context.COUNT = 0
    THEN
      RAISE_APPLICATION_ERROR(-20094,'Context is not initialised');
   END IF;
--
   FOR l_count IN 1..g_tab_rec_context.COUNT
    LOOP
      IF g_tab_rec_context(l_count).attribute_name = pi_attribute
       THEN
         l_retval.data_type := g_tab_rec_context(l_count).data_type;
         l_retval.read_only := g_tab_context_read_only(l_count);
         EXIT;
      END IF;
   END LOOP;
--
   IF l_retval.data_type IS NULL
    THEN
      RAISE_APPLICATION_ERROR(-20095,'Attribute is not specified for context');
   END IF;
--
   RETURN l_retval;
--
END get_attribute_details;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_context (pi_namespace IN varchar2 DEFAULT g_context_namespace
                      ,pi_attribute IN varchar2
                      ,pi_value     IN date
                      ) IS
BEGIN
--
--
   IF    pi_namespace = g_context_namespace
    THEN
      IF    pi_attribute = c_eff_date_name
       THEN
         -- If this is the EFF_DATE then set the global value
        g_effective_date := TRUNC(pi_value);
      ELSIF get_attribute_details(pi_attribute).data_type != c_date_datatype
       THEN
         -- If this is for the default context and it isn't a date
         RAISE_APPLICATION_ERROR(-20096,'Attribute is not specified as a date');
      END IF;
   END IF;
--
   set_context (pi_namespace
               ,pi_attribute
               ,TO_CHAR(pi_value,c_date_format)
               );
--
END set_context;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_context (pi_namespace IN varchar2 DEFAULT g_context_namespace
                      ,pi_attribute IN varchar2
                      ,pi_value     IN number
                      ) IS
BEGIN
--
   IF   pi_namespace                           = g_context_namespace
    AND get_attribute_details(pi_attribute).data_type != c_number_datatype
    THEN
      RAISE_APPLICATION_ERROR(-20097,'Attribute is not specified as a number');
   END IF;
--
   set_context (pi_namespace
               ,pi_attribute
               ,LTRIM(TO_CHAR(pi_value))
               );
--
END set_context;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_context (pi_namespace IN varchar2 DEFAULT g_context_namespace
                      ,pi_attribute IN varchar2
                      ,pi_value     IN varchar2
                      ) IS
BEGIN
--
   IF pi_namespace = g_context_namespace
    THEN
      check_update_allowed (pi_attribute);
   END IF;
--
   IF g_enterprise_edn
    THEN
      dbms_session.set_context(namespace => pi_namespace
                              ,ATTRIBUTE => pi_attribute
                              ,VALUE     => pi_value
                              );
   ELSE
      IF pi_namespace = g_context_namespace
       THEN
         FOR i IN 1..g_tab_rec_context.COUNT
          LOOP
            IF g_tab_rec_context(i).attribute_name = pi_attribute
             THEN
               g_tab_values(i) := pi_value;
               EXIT;
            END IF;
         END LOOP;
      END IF;
   END IF;
--
END set_context;
--
-----------------------------------------------------------------------------
--
FUNCTION get_context (pi_namespace IN varchar2 DEFAULT g_context_namespace
                     ,pi_attribute IN varchar2
                     ) RETURN varchar2 IS
--
BEGIN
--
   IF g_enterprise_edn
    THEN
      RETURN sys_context(pi_namespace, pi_attribute);
   ELSE
      FOR i IN 1..g_tab_rec_context.COUNT
       LOOP
         IF g_tab_rec_context(i).attribute_name = pi_attribute
          THEN
            IF g_tab_values.EXISTS(i)
             THEN
               RETURN g_tab_values(i);
            ELSE
               RETURN NULL;
            END IF;
            EXIT;
         END IF;
      END LOOP;
   END IF;
--
END get_context;
--
-----------------------------------------------------------------------------
--
FUNCTION get_context_date (pi_namespace IN varchar2 DEFAULT g_context_namespace
                          ,pi_attribute IN varchar2
                          ) RETURN date IS
--
   l_char_retval varchar2(255);
--
BEGIN
--
   IF   pi_namespace                           = g_context_namespace
    AND get_attribute_details(pi_attribute).data_type != c_date_datatype
    THEN
      RAISE_APPLICATION_ERROR(-20096,'Attribute is not specified as a date');
   END IF;
--
   l_char_retval := get_context (pi_namespace, pi_attribute);
--
   RETURN TO_DATE(l_char_retval, c_date_format);
--
END get_context_date;
--
-----------------------------------------------------------------------------
--
FUNCTION get_context_number (pi_namespace IN varchar2 DEFAULT g_context_namespace
                            ,pi_attribute IN varchar2
                            ) RETURN number IS
--
   l_char_retval varchar2(255);
--
BEGIN
--
   IF   pi_namespace                           = g_context_namespace
    AND get_attribute_details(pi_attribute).data_type != c_number_datatype
    THEN
      RAISE_APPLICATION_ERROR(-20097,'Attribute is not specified as a number');
   END IF;
--
   l_char_retval := get_context (pi_namespace, pi_attribute);
--
   RETURN TO_NUMBER(l_char_retval);
--
END get_context_number;
--
-----------------------------------------------------------------------------
--
PROCEDURE show_context IS
--
BEGIN
   show_all_context (g_context_namespace);
END show_context;
--
-----------------------------------------------------------------------------
--
PROCEDURE show_context (pi_namespace IN varchar2 DEFAULT g_context_namespace
                       ,pi_attribute IN varchar2
                       ) IS
BEGIN
   DBMS_OUTPUT.PUT_LINE(pi_namespace||'.'||pi_attribute||' : '
                        ||get_context(pi_namespace, pi_attribute)
                       );
END show_context;
--
-----------------------------------------------------------------------------
--
PROCEDURE show_all_context (pi_namespace IN varchar2 DEFAULT NULL) IS
--
   l_current_namespace    varchar2(30) := '??BADGER??';
   l_context_values_found boolean := FALSE;
--
   c_userenv_namespace CONSTANT varchar2(30) := 'USERENV';
   c_null_string       CONSTANT varchar2(10) := '#Null#';
--
BEGIN
--
   IF g_enterprise_edn
    THEN
      FOR cs_rec IN (SELECT *
                      FROM  session_context
                     WHERE  namespace = NVL(pi_namespace,namespace)
                     ORDER BY namespace
                             ,ATTRIBUTE
                    )
       LOOP
         IF l_current_namespace <> cs_rec.namespace
          THEN
            l_current_namespace := cs_rec.namespace;
            DBMS_OUTPUT.PUT_LINE(l_current_namespace);
            DBMS_OUTPUT.PUT_LINE(RPAD('-',LENGTH(l_current_namespace),'-'));
         END IF;
         DBMS_OUTPUT.PUT_LINE(RPAD(cs_rec.ATTRIBUTE,31)
                              ||': '
                              ||NVL(cs_rec.VALUE,c_null_string)
                             );
         l_context_values_found := TRUE;
      END LOOP;
   ELSE
--
      IF g_tab_values.COUNT = 0
       THEN
         RAISE_APPLICATION_ERROR(-20094,'Context is not initialised');
      END IF;
--
      FOR i IN 1..g_tab_rec_context.COUNT
       LOOP
         IF l_current_namespace <> g_context_namespace
          THEN
            l_current_namespace := g_context_namespace;
            DBMS_OUTPUT.PUT_LINE(g_context_namespace);
            DBMS_OUTPUT.PUT_LINE(RPAD('-',LENGTH(l_current_namespace),'-'));
         END IF;
         DBMS_OUTPUT.PUT_LINE(RPAD(g_tab_rec_context(i).attribute_name,31)
                              ||': '
                              ||NVL(g_tab_values(i),c_null_string)
                             );
         l_context_values_found := TRUE;
      END LOOP;
   END IF;
--
   IF NVL(pi_namespace,c_userenv_namespace) = c_userenv_namespace
    AND g_enterprise_edn
    THEN
      l_context_values_found := TRUE;
      DBMS_OUTPUT.PUT_LINE(c_userenv_namespace);
      DBMS_OUTPUT.PUT_LINE(RPAD('-',LENGTH(c_userenv_namespace),'-'));
      FOR l_count IN 1..g_tab_userenv_context.COUNT
       LOOP
         DBMS_OUTPUT.PUT_LINE(RPAD(g_tab_userenv_context(l_count),31)
                              ||': '
                              ||NVL(get_context(c_userenv_namespace
                                               ,g_tab_userenv_context(l_count)
                                               )
                                    ,c_null_string
                                    )
                             );
      END LOOP;
   END IF;
--
   IF NOT l_context_values_found
    THEN
      DBMS_OUTPUT.PUT_LINE('No context values found');
   END IF;
--
END show_all_context;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_instantiate_user_trig (pi_new_trigger_owner IN varchar2) IS
--
   CURSOR cs_trigger (p_owner        varchar2
                     ,p_trigger_name varchar2
                     ) IS
   SELECT trigger_body
    FROM  all_triggers
   WHERE  owner        = p_owner
    AND   trigger_name = p_trigger_name;
--
   CURSOR cs_user (p_username varchar2) IS
   SELECT 'x'
    FROM  all_users
   WHERE  username = p_username;
--
   l_dummy              varchar2(1);
--
   l_application_owner  varchar2(30)  := get_context(pi_attribute => 'APPLICATION_OWNER');
   c_inst_user CONSTANT varchar2(30) := 'INSTANTIATE_USER';
--
   l_rec_at             all_triggers%ROWTYPE;
--
   l_trigger_sql        varchar2(32767);
   l_trigger_body       varchar2(32767);
--
BEGIN
--
   OPEN  cs_user (pi_new_trigger_owner);
   FETCH cs_user INTO l_dummy;
   IF cs_user%NOTFOUND
    THEN
      CLOSE cs_user;
      g_context_exc_code := -20493;
      g_context_exc_msg  := 'User '||l_application_owner||' not found';
      RAISE g_context_exception;
   END IF;
   CLOSE cs_user;
--
   OPEN  cs_trigger (l_application_owner, c_inst_user);
   FETCH cs_trigger INTO l_trigger_body;
   IF cs_trigger%NOTFOUND
    THEN
      CLOSE cs_trigger;
      g_context_exc_code := -20491;
      g_context_exc_msg  := 'Trigger '||l_application_owner||'.'||c_inst_user||' not found';
      RAISE g_context_exception;
   END IF;
--
   CLOSE cs_trigger;
--
   l_trigger_sql := 'CREATE OR REPLACE TRIGGER '||pi_new_trigger_owner||'.'||c_inst_user;
   l_trigger_sql := l_trigger_sql||CHR(10)||' AFTER LOGON ON '||pi_new_trigger_owner||'.SCHEMA';
   l_trigger_sql := l_trigger_sql||CHR(10)||l_trigger_body;
--
   EXECUTE IMMEDIATE l_trigger_sql;
--
EXCEPTION
--
   WHEN value_error
    THEN
      IF cs_trigger%isopen
       THEN
         CLOSE cs_trigger;
      END IF;
      g_context_exc_code := -20492;
      g_context_exc_msg  := 'Trigger '||l_application_owner||'.'||c_inst_user||' body too long (>32K)';
      RAISE g_context_exception;
   WHEN g_context_exception
    THEN
      RAISE_APPLICATION_ERROR(g_context_exc_code,g_context_exc_msg);
--
END create_instantiate_user_trig;
--
-----------------------------------------------------------------------------
--
FUNCTION get_effective_date RETURN date IS
BEGIN
--
   RETURN g_effective_date;
--   RETURN TO_DATE(get_context(pi_attribute => 'EFFECTIVE_DATE'),c_date_format);
--
END get_effective_date;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_update_allowed(pi_attribute IN varchar2) IS
BEGIN
   IF   g_enforce_read_only
    AND get_attribute_details(pi_attribute).read_only
    THEN
      RAISE_APPLICATION_ERROR(-20498,'Cannot set context values for read only attributes');
   END IF;
END check_update_allowed;
--
-----------------------------------------------------------------------------
--
FUNCTION get_namespace RETURN varchar2 IS
-- This function returns the value of g_context_namespace
BEGIN
   RETURN g_context_namespace;
END get_namespace;
--
-----------------------------------------------------------------------------
--
FUNCTION get_user_sysopt (pi_sysopt  hig_option_values.hov_id%TYPE         DEFAULT NULL
                         ,pi_userid  hig_user_options.huo_hus_user_id%TYPE DEFAULT NULL
                         ,pi_useopt  hig_user_options.huo_id%TYPE          DEFAULT NULL
                         ,pi_default varchar2                              DEFAULT NULL
                         ) RETURN varchar2 IS
--
   CURSOR cs_useopt (c_user_id hig_user_options.huo_hus_user_id%TYPE
                    ,c_opt_id  hig_user_options.huo_id%TYPE
                    ) IS
   SELECT huo_value
    FROM  hig_user_options
   WHERE  huo_hus_user_id = c_user_id
    AND   huo_id          = c_opt_id;
--
   CURSOR cs_sysopt (c_opt_id hig_option_values.hov_id%TYPE) IS
   SELECT hov_value
    FROM  hig_option_values
   WHERE  hov_id   = c_opt_id;
--
   l_found  boolean := FALSE;
   l_retval hig_option_values.hov_value%TYPE;
--
BEGIN
--
   IF   pi_userid IS NOT NULL
    AND pi_useopt IS NOT NULL
    THEN
      OPEN  cs_useopt (pi_userid,pi_useopt);
      FETCH cs_useopt INTO l_retval;
      l_found := cs_useopt%FOUND;
      CLOSE cs_useopt;
   END IF;
--
   IF NOT l_found
    THEN
--
      IF pi_sysopt IS NOT NULL
       THEN
         OPEN  cs_sysopt (pi_sysopt);
         FETCH cs_sysopt INTO l_retval;
         l_found := cs_sysopt%FOUND;
         CLOSE cs_sysopt;
      END IF;
--
      IF NOT l_found
       THEN
         l_retval := pi_default;
      END IF;
--
   END IF;
--
   RETURN l_retval;
--
END get_user_sysopt;
--
-----------------------------------------------------------------------------
--
PROCEDURE instantiate_data IS
--
   CURSOR cs_hig_owner (p_flag varchar2) IS
   SELECT hus_username
    FROM  hig_users
   WHERE  hus_is_hig_owner_flag = p_flag
    OR    p_flag IS NULL;
   l_dummy hig_users.hus_username%TYPE;
--
   CURSOR cs_enterprise_edn IS
   SELECT 'x'
    FROM  v$version
   WHERE  banner LIKE '%Enterprise Edition%'
    OR    banner LIKE '%Personal%';
--
BEGIN
--
   OPEN  cs_hig_owner ('Y');
   FETCH cs_hig_owner INTO g_application_owner;
   IF cs_hig_owner%NOTFOUND
    THEN
      -- there is none with the hus_is_hig_owner_flag set to Y
      CLOSE cs_hig_owner;
      OPEN  cs_hig_owner (NULL);
      FETCH cs_hig_owner INTO l_dummy;
      IF cs_hig_owner%FOUND
       THEN
         NULL; -- This should never happen
      ELSE
         --
         -- If there is no record found and there are no records in hig_users
         --  therefore the only time this can happen is
         --  when this runs are part of the install, so the application
         --  owner will be the current user
         --
         g_application_owner := USER;
      END IF;
   END IF;
   CLOSE cs_hig_owner;
--
   OPEN  cs_enterprise_edn;
   FETCH cs_enterprise_edn INTO l_dummy;
   g_enterprise_edn := cs_enterprise_edn%FOUND;
   CLOSE cs_enterprise_edn;
--
   g_context_namespace := 'NM3_'||SUBSTR(g_application_owner,1,26);
--
-- Initialise the variables here to avoid any possible trouble with
--  these values not being set. Problem crept up after EXISTING_STATE_OF_PACKAGES
--  error caused this record to lose it's values
--
   g_tab_rec_context.DELETE;
--
   g_tab_rec_context(1).attribute_name  := c_eff_date_name;
   g_tab_rec_context(1).data_type       := c_date_datatype;
   g_tab_context_read_only(1)           := FALSE;
   g_tab_rec_context(2).attribute_name  := 'USER_LENGTH_UNITS';
   g_tab_rec_context(2).data_type       := c_number_datatype;
   g_tab_context_read_only(2)           := FALSE;
   g_tab_rec_context(3).attribute_name  := 'USER_DATE_MASK';
   g_tab_rec_context(3).data_type       := c_varchar_datatype;
   g_tab_context_read_only(3)           := FALSE;
   g_tab_rec_context(4).attribute_name  := 'DEFAULT_LENGTH_MASK';
   g_tab_rec_context(4).data_type       := c_varchar_datatype;
   g_tab_context_read_only(4)           := FALSE;
   g_tab_rec_context(5).attribute_name  := 'USER_LENGTH_MASK';
   g_tab_rec_context(5).data_type       := c_varchar_datatype;
   g_tab_context_read_only(5)           := FALSE;
   g_tab_rec_context(6).attribute_name  := 'USER_ID';
   g_tab_rec_context(6).data_type       := c_number_datatype;
   g_tab_context_read_only(6)           := TRUE;
   g_tab_rec_context(7).attribute_name  := 'UNRESTRICTED_INVENTORY';
   g_tab_rec_context(7).data_type       := c_varchar_datatype;
   g_tab_context_read_only(7)           := TRUE;
   g_tab_rec_context(8).attribute_name  := 'APPLICATION_OWNER';
   g_tab_rec_context(8).data_type       := c_varchar_datatype;
   g_tab_context_read_only(8)           := TRUE;
   g_tab_rec_context(9).attribute_name  := 'UNRESTRICTED_ACCIDENTS';
   g_tab_rec_context(9).data_type       := c_varchar_datatype;
   g_tab_context_read_only(9)           := TRUE;
   g_tab_rec_context(10).attribute_name := 'ENTERPRISE_EDITION';
   g_tab_rec_context(10).data_type      := c_varchar_datatype;
   g_tab_context_read_only(10)          := TRUE;
   g_tab_rec_context(11).attribute_name := 'INSTANCE_NAME';
   g_tab_rec_context(11).data_type      := c_varchar_datatype;
   g_tab_context_read_only(11)          := TRUE;
   g_tab_rec_context(12).attribute_name := 'HOST_NAME';
   g_tab_rec_context(12).data_type      := c_varchar_datatype;
   g_tab_context_read_only(12)          := TRUE;
   g_tab_rec_context(13).attribute_name := 'DB_VERSION';
   g_tab_rec_context(13).data_type      := c_varchar_datatype;
   g_tab_context_read_only(13)          := TRUE;
   g_tab_rec_context(14).attribute_name := 'PREFERRED_LRM';
   g_tab_rec_context(14).data_type      := c_varchar_datatype;
   g_tab_context_read_only(14)          := FALSE;
   g_tab_rec_context(15).attribute_name := 'ROI_ID';
   g_tab_rec_context(15).data_type      := c_number_datatype;
   g_tab_context_read_only(15)          := FALSE;
   g_tab_rec_context(16).attribute_name := 'ROI_TYPE';
   g_tab_rec_context(16).data_type      := c_varchar_datatype;
   g_tab_context_read_only(16)          := FALSE;
   g_tab_rec_context(17).attribute_name := 'DEFAULT_INV_ATTR_SET';
   g_tab_rec_context(17).data_type      := c_number_datatype;
   g_tab_context_read_only(17)          := FALSE;
--
   g_tab_userenv_context.DELETE;
--
-- Returns the operating system identifier for the client of the current session. "Virtual" in TCP/IP.ž
   g_tab_userenv_context(1)  := 'TERMINAL';
-- Returns the language and territory currently used by the session, along with the database
--  character set in the form: language_territory.characterset.ž
   g_tab_userenv_context(2)  := 'LANGUAGE';
-- Returns abbreviation for the language name.ž
   g_tab_userenv_context(3)  := 'LANG';
-- Returns auditing session identifier.ž
   g_tab_userenv_context(4)  := 'SESSIONID';
-- Returns the instance identification number of the current instance.ž
   g_tab_userenv_context(5)  := 'INSTANCE';
-- Returns available auditing entry identifier.ž
   g_tab_userenv_context(6)  := 'ENTRYID';
-- Returns TRUE if you currently have the DBA role enabled and FALSE if you do not. ž
   g_tab_userenv_context(7)  := 'ISDBA';
-- Returns up to 64 bytes of user session information that can be stored by an
--  application using the DBMS_APPLICATION_INFO package.ž
   g_tab_userenv_context(8)  := 'CLIENT_INFO';
-- Returns the territory of the current session.ž
   g_tab_userenv_context(9)  := 'NLS_TERRITORY';
-- Returns the currency symbol of the current session.ž
   g_tab_userenv_context(10) := 'NLS_CURRENCY';
-- Returns the NLS calendar used for dates in the current session.ž
   g_tab_userenv_context(11) := 'NLS_CALENDAR';
-- Returns the current date format of the current session.ž
   g_tab_userenv_context(12) := 'NLS_DATE_FORMAT';
-- Returns the language used for expressing dates in the current session.ž
   g_tab_userenv_context(13) := 'NLS_DATE_LANGUAGE';
-- Indicates whether the sort base is binary or linguistic.ž
   g_tab_userenv_context(14) := 'NLS_SORT';
-- Returns the name of the user whose privilege the current session is under. Can be different from
--  SESSION_USER from within a stored procedure (such as an invoker-rights procedure).ž
   g_tab_userenv_context(15) := 'CURRENT_USER';
-- Returns the user ID of the user whose privilege the current session is under. Can can be
--  different from SESSION_USERID from within a stored procedure (such as an invoker-rights procedure).ž
   g_tab_userenv_context(16) := 'CURRENT_USERID';
-- Returns the database user name by which the current user is authenticated.ž
   g_tab_userenv_context(17) := 'SESSION_USER';
-- Returns the identifier of the database user name by which the current user is authenticated.ž
   g_tab_userenv_context(18) := 'SESSION_USERID';
-- Returns the name of the default schema being used in the current session. This can be changed
--  with an ALTER SESSION SET SCHEMA statement.ž
   g_tab_userenv_context(19) := 'CURRENT_SCHEMA';
-- Returns the identifier of the default schema being used in the current session. This can be
--  changed with an ALTER SESSION SET SCHEMAID statement.ž
   g_tab_userenv_context(20) := 'CURRENT_SCHEMAID';
-- Returns the name of the database user (typically middle tier) who opened the current session
--  on behalf of SESSION_USER.ž
   g_tab_userenv_context(21) := 'PROXY_USER';
-- Returns the identifier of the database user (typically middle tier) who opened the current
--  session on behalf of SESSION_USER.ž
   g_tab_userenv_context(22) := 'PROXY_USERID';
-- Returns the domain of the database as specified in the DB_DOMAIN initialization parameter.ž
   g_tab_userenv_context(23) := 'DB_DOMAIN';
-- Returns the name of the database as specified in the DB_NAME initialization parameter.ž
   g_tab_userenv_context(24) := 'DB_NAME';
-- Returns the name for the hose machine on which the database is running.ž
   g_tab_userenv_context(25) := 'HOST';
-- Returns the operating system username of the client process that initiated the database session.ž
   g_tab_userenv_context(26) := 'OS_USER';
-- Returns the external name of the database user.ž
   g_tab_userenv_context(27) := 'EXTERNAL_NAME';
-- Returns the IP address of the machine from which the client is connected.ž
   g_tab_userenv_context(28) := 'IP_ADDRESS';
-- Returns the protocol named in the connect string (PROTOCOL=protocol).ž
   g_tab_userenv_context(29) := 'NETWORK_PROTOCOL';
-- Returns the background job ID.ž
   g_tab_userenv_context(30) := 'BG_JOB_ID';
-- Returns the foreground job ID.ž
   g_tab_userenv_context(31) := 'FG_JOB_ID';
-- Shows how the user was authenticated (DATABASE, OS, NETWORK, PROXY).ž
   g_tab_userenv_context(32) := 'AUTHENTICATION_TYPE';
-- Returns the data being used to authenticate the login user. (Returns the certificate
--  content, if one exists.)
   g_tab_userenv_context(33) := 'AUTHENTICATION_DATA';
--
END instantiate_data;
--
-----------------------------------------------------------------------------
--
BEGIN
--
   instantiate_data;
--
END nm3context;
/
