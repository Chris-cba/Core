--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/ctx/add_lb_policy.sql-arc   1.0   Dec 20 2018 13:37:58   Chris.Baugh  $
--       Module Name      : $Workfile:   add_lb_policy.sql  $
--       Date into PVCS   : $Date:   Dec 20 2018 13:37:58  $
--       Date fetched Out : $Modtime:   Jan 15 2015 13:06:10  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : R.A. Coupe
--
--   Location Bridge Policy Script
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--

--
SET SERVEROUTPUT ON SIZE 1000000
--
DECLARE

   l_tab_policy_name     nm3type.tab_varchar30;
   l_tab_object_name     nm3type.tab_varchar30;
   l_tab_policy_function nm3type.tab_varchar2000;
   l_tab_statement_types nm3type.tab_varchar30;
   l_tab_check_option    nm3type.tab_boolean;
   l_tab_enable          nm3type.tab_boolean;
   l_tab_static_policy   nm3type.tab_boolean;
   --
   c_application_owner   CONSTANT VARCHAR2(30) := Sys_Context('NM3CORE','APPLICATION_OWNER');
--
   l_no_fine_grained_security EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_no_fine_grained_security,-439);
   --
   PROCEDURE add_policy (p_policy_name     VARCHAR2
                        ,p_object_name     VARCHAR2
                        ,p_policy_function VARCHAR2
                        ,p_statement_types VARCHAR2
                        ,p_check_option    BOOLEAN DEFAULT TRUE
                        ,p_enable          BOOLEAN DEFAULT TRUE
                        ,p_static_policy   BOOLEAN DEFAULT FALSE
                        ) IS
      i CONSTANT PLS_INTEGER := l_tab_policy_name.COUNT + 1;
   BEGIN
      l_tab_policy_name(i)     := p_policy_name;
      l_tab_object_name(i)     := p_object_name;
      l_tab_policy_function(i) := p_policy_function;
      l_tab_statement_types(i) := p_statement_types;
      l_tab_check_option(i)    := p_check_option;
      l_tab_enable(i)          := p_enable;
      l_tab_static_policy(i)   := p_static_policy;
   END add_policy;
   --
BEGIN

   add_policy (p_policy_name     => 'LB_LOC_POLICY'
              ,p_object_name     => 'NM_LOCATIONS_ALL'
              ,p_policy_function => 'LB_SECURITY.LOC_PREDICATE'
              ,p_statement_types => 'SELECT,INSERT,UPDATE,DELETE'
              );


   add_policy (p_policy_name     => 'LB_NAL_POLICY'
              ,p_object_name     => 'NM_ASSET_LOCATIONS_ALL'
              ,p_policy_function => 'LB_SECURITY.NAL_PREDICATE'
              ,p_statement_types => 'SELECT,INSERT,UPDATE,DELETE'
              );


   FOR l_count IN 1..l_tab_policy_name.COUNT
    LOOP
      BEGIN
         dbms_rls.add_policy
            (object_schema   => c_application_owner
            ,object_name     => l_tab_object_name(l_count)
            ,policy_name     => l_tab_policy_name(l_count)
            ,function_schema => c_application_owner
            ,policy_function => l_tab_policy_function(l_count)
            ,statement_types => l_tab_statement_types(l_count)
            ,update_check    => l_tab_check_option(l_count)
            ,enable          => l_tab_enable(l_count)
            ,static_policy   => l_tab_static_policy(l_count)
            );
         dbms_output.put_line(l_count||'. '||l_tab_policy_name(l_count)||' on '||c_application_owner||'.'||l_tab_object_name(l_count)||' created');
      EXCEPTION
         WHEN l_no_fine_grained_security
          THEN
            RAISE;
         WHEN others
          THEN
            dbms_output.put_line(l_count||'. ### '||l_tab_policy_name(l_count)||' on '||l_tab_object_name(l_count)||' ERROR');
            dbms_output.put_line(SUBSTR(SQLERRM,1,255));
      END;
      dbms_output.put_line('--');
   END LOOP;
--
EXCEPTION
   WHEN l_no_fine_grained_security
    THEN
      dbms_output.put_line(SUBSTR(SQLERRM,1,255));
END;
/

