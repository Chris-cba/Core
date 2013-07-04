--
SET SERVEROUTPUT ON SIZE 1000000
--
DECLARE
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/ctx/add_policy.sql-arc   2.4   Jul 04 2013 09:23:56   James.Wadsworth  $
--       Module Name      : $Workfile:   add_policy.sql  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:23:56  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:22:04  $
--       SCCS Version     : $Revision:   2.4  $
--       Based on SCCS Version     : 1.11
--
--   Create Inventory/Merge security policies
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
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
--   add_policy (p_policy_name     =>
--              ,p_object_name     =>
--              ,p_policy_function =>
--              ,p_statement_types =>
--              );
--
-- SELECT policies for inventory
--
   add_policy (p_policy_name     => 'INV_AU_POLICY_READ'
              ,p_object_name     => 'NM_INV_ITEMS_ALL'
              ,p_policy_function => 'INVSEC.INV_PREDICATE_READ'
              ,p_statement_types => 'SELECT'
              );
--
   add_policy (p_policy_name     => 'INV_TYPE_ROLE_POLICY_READ'
              ,p_object_name     => 'NM_INV_TYPES_ALL'
              ,p_policy_function => 'INVSEC.INV_TYPE_PREDICATE_READ'
              ,p_statement_types => 'SELECT'
              );
--
   add_policy (p_policy_name     => 'INV_TYPE_GRP_ROLE_POLICY_READ'
              ,p_object_name     => 'NM_INV_TYPE_GROUPINGS_ALL'
              ,p_policy_function => 'INVSEC.INV_ITG_PREDICATE_READ'
              ,p_statement_types => 'SELECT'
              );
--
-- INSERT,UPDATE,DELETE policies for inventory
--
   add_policy (p_policy_name     => 'INV_AU_POLICY'
              ,p_object_name     => 'NM_INV_ITEMS_ALL'
              ,p_policy_function => 'INVSEC.INV_PREDICATE'
              ,p_statement_types => 'INSERT,UPDATE,DELETE'
              );
--
   add_policy (p_policy_name     => 'INV_TYPE_ROLE_POLICY'
              ,p_object_name     => 'NM_INV_TYPES_ALL'
              ,p_policy_function => 'INVSEC.INV_TYPE_PREDICATE'
              ,p_statement_types => 'INSERT,UPDATE,DELETE'
              );
--
   add_policy (p_policy_name     => 'INV_TYPE_GROUPINGS_ROLE_POLICY'
              ,p_object_name     => 'NM_INV_TYPE_GROUPINGS_ALL'
              ,p_policy_function => 'INVSEC.INV_ITG_PREDICATE'
              ,p_statement_types => 'INSERT,UPDATE,DELETE'
              );
--
-- SELECT,INSERT,UPDATE,DELETE policies for Merge
--
--   add_policy (p_policy_name     => 'MRG_QUERY_TYPES_POLICY_UPDATE'
--              ,p_object_name     => 'NM_MRG_QUERY_TYPES_ALL'
--              ,p_policy_function => 'nm3mrg_security.mrg_nqt_predicate_update'
--              ,p_statement_types => 'INSERT,UPDATE,DELETE'
--              );
----
--   add_policy (p_policy_name     => 'MRG_QUERY_TYPES_POLICY_READ'
--              ,p_object_name     => 'NM_MRG_QUERY_TYPES_ALL'
--              ,p_policy_function => 'nm3mrg_security.mrg_nqt_predicate_read'
--              ,p_statement_types => 'SELECT'
--              );
--
   add_policy (p_policy_name     => 'MRG_QUERY_POLICY_READ'
              ,p_object_name     => 'NM_MRG_QUERY_ALL'
              ,p_policy_function => 'nm3mrg_security.mrg_nmq_predicate_read'
              ,p_statement_types => 'SELECT'
              ,p_static_policy   => TRUE
              );
--
   add_policy (p_policy_name     => 'MRG_QUERY_POLICY_UPDATE'
              ,p_object_name     => 'NM_MRG_QUERY_ALL'
              ,p_policy_function => 'nm3mrg_security.mrg_nmq_predicate_update'
              ,p_statement_types => 'UPDATE'
              ,p_static_policy   => TRUE
              );
--
   add_policy (p_policy_name     => 'MRG_QUERY_POLICY_DELETE'
              ,p_object_name     => 'NM_MRG_QUERY_ALL'
              ,p_policy_function => 'nm3mrg_security.mrg_nmq_predicate_delete'
              ,p_statement_types => 'DELETE'
              ,p_static_policy   => TRUE
              );
--
   add_policy (p_policy_name     => 'MRG_QUERY_RESULTS_POLICY'
              ,p_object_name     => 'NM_MRG_QUERY_RESULTS_ALL'
              ,p_policy_function => 'nm3mrg_security.mrg_nqr_predicate'
              ,p_statement_types => 'SELECT,INSERT,UPDATE,DELETE'
              );
--
   add_policy (p_policy_name     => 'MRG_SECTIONS_POLICY'
              ,p_object_name     => 'NM_MRG_SECTIONS_ALL'
              ,p_policy_function => 'nm3mrg_security.mrg_nms_predicate'
              ,p_statement_types => 'SELECT,INSERT,UPDATE,DELETE'
              );
--
--ecdm log 729856 - merge query has a conditional, multi-table insert statement which is an unsupported feature of the fgac. Disable insert predicate.
--
   add_policy (p_policy_name     => 'MRG_SECTION_INV_VALUES_POLICY'
              ,p_object_name     => 'NM_MRG_SECTION_INV_VALUES_ALL'
              ,p_policy_function => 'nm3mrg_security.mrg_nsv_predicate'
--            ,p_statement_types => 'SELECT,INSERT,UPDATE,DELETE'
              ,p_statement_types => 'SELECT,UPDATE,DELETE'
              );
--
   add_policy (p_policy_name     => 'MRG_DEFAULTS_POLICY'
              ,p_object_name     => 'NM_MRG_DEFAULT_QUERY_TYPES_ALL'
              ,p_policy_function => 'nm3mrg_security.mrg_ndq_predicate'
              ,p_statement_types => 'SELECT,INSERT,UPDATE,DELETE'
              );
--
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
