------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm3_post_upg.sql-arc   1.0   Jun 01 2020 14:14:58   Chris.Baugh  $
--       Module Name      : $Workfile:   nm3_post_upg.sql  $
--       Date into PVCS   : $Date:   Jun 01 2020 14:14:58  $
--       Date fetched Out : $Modtime:   May 11 2020 15:58:38  $
--       Version          : $Revision:   1.0  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2014

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF

--
-----------------------------------------------------------------------------------------
--
SET TERM ON
PROMPT v_geom_on_route.vw
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_geom_on_route.vw ' run_file
FROM dual
/
start '&run_file'

-----------------------------------------
--Regenerate Triggers on existing alerts
-----------------------------------------
SET TERM ON
PROMPT Regenerate Triggers
SET TERM OFF

DECLARE
    l_trg_status     VARCHAR2(4000);
    l_error_text     VARCHAR2(4000);
    l_drop_trg       BOOLEAN;
    l_create_trg     BOOLEAN;
    CURSOR c_alert_type IS
        SELECT halt_id, halt_trigger_name, do.status
        FROM hig_alert_types halt, dba_triggers dt ,dba_objects do
        WHERE dt.trigger_name = halt.halt_trigger_name
        and dt.trigger_name = do.object_name and UPPER(do.object_type) = 'TRIGGER';
    type lt_halt is table of c_alert_type%ROWTYPE index by binary_integer;
    t_alert      lt_halt;
    t_alert1      lt_halt;
BEGIN
    dbms_output.put_line('Status of Triggers on existing Alerts');
    OPEN C_alert_type;
    FETCH C_alert_type BULK COLLECT INTO t_alert;
    CLOSE C_alert_type;
    FOR i IN 1..t_alert.COUNT    LOOP
        l_trg_status := hig_alert.get_trigger_status(t_alert(i).halt_trigger_name);
        DBMS_OUTPUT.PUT_LINE(t_alert(i).halt_trigger_name ||' : '||t_alert(i).STATUS);
    END LOOP;
    FOR i IN 1..t_alert.COUNT
    LOOP
      l_drop_trg := hig_alert.drop_trigger(t_alert(i).halt_id,t_alert(i).halt_trigger_name,l_error_text);
      l_create_trg := hig_alert.create_trigger(t_alert(i).halt_id,l_error_text);
    END LOOP;
    dbms_output.put_line(' ');
    dbms_output.put_line('Triggers ReGenerated: ');
    OPEN C_alert_type;
    FETCH C_alert_type BULK COLLECT INTO t_alert1;
    CLOSE C_alert_type;
    FOR i IN 1..t_alert1.COUNT
    LOOP
        l_trg_status := hig_alert.get_trigger_status(t_alert1(i).halt_trigger_name);
        DBMS_OUTPUT.PUT_LINE(t_alert1(i).halt_trigger_name||' : '||t_alert1(i).STATUS);
    END LOOP;
    dbms_output.put_line('Finished ReGeneration');
EXCEPTION
  WHEN others THEN
    NULL;
END;
/
--
--------------------------------------------------------------------------------
-- Add check constraint to NM_MEMBERS_ALL
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT Adding check constraint to NM_MEMBERS_ALL
SET TERM OFF

DECLARE
  --
  CURSOR c1 IS
  SELECT nm_ne_id_in,
         nm_ne_id_of,
         nm_begin_mp,
         nm_start_date,
         nm_end_mp
    FROM nm_members_all
   WHERE nm_begin_mp > nm_end_mp;
  --
BEGIN
  --
  -- Disable all the triggers on NM_MEMBERS_ALL prior to the update and creation of check constraint
  EXECUTE IMMEDIATE 'ALTER TABLE nm_members_all DISABLE ALL TRIGGERS';

  -- Reverse nm_begin_mp and nm_end_mp where nm_begin_mp > nm_end_mp
  FOR l_rec IN c1 LOOP

     update nm_members_all
     set nm_end_mp = l_rec.nm_begin_mp,
         nm_begin_mp = l_rec.nm_end_mp
     where nm_ne_id_in = l_rec.nm_ne_id_in
       and nm_ne_id_of = l_rec.nm_ne_id_of
       and nm_begin_mp = l_rec.nm_begin_mp
       and nm_start_date = l_rec.nm_start_date;

  END LOOP;

  -- Create Check Constraint to enforce nm_begin_mp <= nm_end_mp
  DECLARE
    already_exists EXCEPTION;
    PRAGMA exception_init( already_exists,-02264);
  BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE NM_MEMBERS_ALL ADD  '||CHR(10)||
                      'CONSTRAINT NM_BEGIN_MP_CHK      '||CHR(10)||
                      'CHECK (NM_BEGIN_MP <= NM_END_MP)';

  EXCEPTION
    WHEN already_exists THEN
      NULL;
    WHEN OTHERS THEN
      RAISE;
   END;

  --Re-enable all the triggers on NM_MEMBERS_ALL
  EXECUTE IMMEDIATE 'ALTER TABLE nm_members_all ENABLE ALL TRIGGERS';

END;
/
--
--
--------------------------------------------------------------------------------
-- Create HIG_RELATIONSHIP policies
--------------------------------------------------------------------------------
--
--
SET TERM ON
PROMPT Drop HIG_RELATIONSHIP Policies
SET TERM OFF
--
DECLARE
  --
  no_policy Exception;
  Pragma Exception_Init(no_policy, -28102);
  --
BEGIN

  dbms_rls.drop_policy (object_schema => Sys_Context('NM3CORE','APPLICATION_OWNER')
                       ,object_name   => 'HIG_RELATIONSHIP'
                       ,policy_name   => 'hig_relationship_admin'
                        );
EXCEPTION
  WHEN no_policy THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/

DECLARE
  --
  no_policy Exception;
  Pragma Exception_Init(no_policy, -28102);
  --
BEGIN

  dbms_rls.drop_policy (object_schema => Sys_Context('NM3CORE','APPLICATION_OWNER')
                       ,object_name   => 'HIG_RELATIONSHIP'
                       ,policy_name   => 'hig_relationship_select'
                        );
EXCEPTION
  WHEN no_policy THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--

SET TERM ON
PROMPT Create HIG_RELATIONSHIP Policies
SET TERM OFF

BEGIN
  dbms_rls.add_policy
     (object_schema   => Sys_Context('NM3CORE','APPLICATION_OWNER')
     ,object_name     => 'HIG_RELATIONSHIP'
     ,policy_name     => 'hig_relationship_admin'
     ,function_schema => Sys_Context('NM3CORE','APPLICATION_OWNER')
     ,policy_function => 'hig_relationship_api.f_hig_relationship_admin'
     ,statement_types => 'INSERT,UPDATE,DELETE'
     ,update_check    => TRUE
     ,enable          => TRUE
     ,static_policy   => FALSE
     );
  --
  dbms_rls.add_policy
     (object_schema   => Sys_Context('NM3CORE','APPLICATION_OWNER')
     ,object_name     => 'HIG_RELATIONSHIP'
     ,policy_name     => 'hig_relationship_select'
     ,function_schema => Sys_Context('NM3CORE','APPLICATION_OWNER')
     ,policy_function => 'hig_relationship_api.f_hig_relationship_select'
     ,statement_types => 'SELECT'
     ,update_check    => TRUE
     ,enable          => TRUE
     ,static_policy   => FALSE
     );

END;
/
--
--------------------------------------------------------------------------------
-- CREATE PROXY_OWNER role
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT hig_roles
SET TERM OFF

DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921);
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE PROXY_OWNER';
  NULL;
EXCEPTION
WHEN role_exists
THEN
  Null;
END;
/
--
--------------------------------------------------------------------------------
-- CREATE ALERT_ADMIN role
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT hig_roles
SET TERM OFF

DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921);
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE ALERT_ADMIN';
  NULL;
EXCEPTION
WHEN role_exists
THEN
  Null;
END;
/
--
--------------------------------------------------------------------------------
-- CREATE EXOR_ALLOW_USER_PROXY role
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT Creating Role exor_allow_user_proxy
SET TERM OFF
--
DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921);
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE EXOR_ALLOW_USER_PROXY';
  NULL;
EXCEPTION
WHEN role_exists
THEN
  Null;
END;
/

--
--------------------------------------------------------------------------------
-- Grants
--------------------------------------------------------------------------------
--
GRANT CREATE TRIGGER TO ALERT_ADMIN;
GRANT DROP ANY TRIGGER TO ALERT_ADMIN;

