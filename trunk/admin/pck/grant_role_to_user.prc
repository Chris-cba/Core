CREATE OR REPLACE PROCEDURE grant_role_to_user
                                  (p_user       varchar2
                                  ,p_role       varchar2
                                  ,p_admin      boolean DEFAULT FALSE
                                  ,p_start_date date    DEFAULT TRUNC(SYSDATE)
                                  ) IS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)grant_role_to_user.prc	1.2 05/21/02
--       Module Name      : grant_role_to_user.prc
--       Date into SCCS   : 02/05/21 11:10:12
--       Date fetched Out : 07/06/13 14:10:15
--       SCCS Version     : 1.2
--
--
--   Author : Jon Mills
--
--   Grants role and associated table and system privileges to user.
--
--   Must be stand alone as there are locking conflicts if it is part of a
--   package.
--
--   KA: Added sys privs loop. Upper'd role.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   CURSOR cs_atc (c_grantee varchar2) IS
   SELECT *
    FROM  all_tab_privs
   WHERE  grantee = c_grantee
     AND TABLE_NAME NOT LIKE 'BIN$%'; -- CWS 711775 LINE ADDED SO THAT RECYCLING BINS ARE NOT INCLUDED
--
   CURSOR cs_asc (c_grantee varchar2) IS
   SELECT *
    FROM  dba_sys_privs
   WHERE  grantee = c_grantee;
--
   l_role dba_roles.role%TYPE := UPPER(p_role);
--
   l_admin varchar2(30);
--
   TYPE big_vc IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
   l_tab_commands big_vc;
--
   PROCEDURE add (p_command VARCHAR2) IS
   BEGIN
      l_tab_commands(l_tab_commands.COUNT+1) := p_command;
   END add;
--
BEGIN
--  nm_debug.proc_start(p_package_name   => NULL
--                     ,p_procedure_name => 'grant_role_to_user');
--
   add ('GRANT '||l_role||' TO '||p_user);
--
   IF p_admin
    THEN
      l_admin := ' WITH ADMIN OPTION';
      add ('GRANT '||l_role||' TO '||p_user||l_admin);
   END IF;
--
   --object privileges
   FOR cs_rec IN cs_atc (l_role)
    LOOP
      add ('GRANT '||cs_rec.privilege
           ||' ON '||cs_rec.table_schema||'.'||cs_rec.table_name
           ||' TO '||p_user||l_admin
          );
   END LOOP;

   --system privileges
   FOR cs_rec IN cs_asc (l_role)
    LOOP
      add ('GRANT '||cs_rec.privilege
           ||' TO '||p_user||l_admin
          );
   END LOOP;
--
--   nm_debug.delete_debug(TRUE);
--   nm_debug.debug_on;
   FOR i IN 1..l_tab_commands.COUNT
    LOOP
--      nm_debug.debug(l_tab_commands(i));
      DECLARE
         no_role  EXCEPTION;
         PRAGMA   EXCEPTION_INIT(no_role,-1919);
         no_self  EXCEPTION;
         PRAGMA   EXCEPTION_INIT(no_self,-1749);
         no_grant EXCEPTION;
         PRAGMA   EXCEPTION_INIT(no_grant,-993);
      BEGIN
         EXECUTE IMMEDIATE l_tab_commands(i);
      EXCEPTION
         WHEN no_role OR no_self OR no_grant THEN Null;
      END;
   END LOOP;
--   nm_debug.debug_off;
--
   INSERT INTO hig_user_roles
         (hur_username
         ,hur_role
         ,hur_start_date
         )
   SELECT p_user
         ,l_role
         ,p_start_date
    FROM  dual
   WHERE  NOT EXISTS (SELECT 1
                       FROM  hig_user_roles
                      WHERE  hur_username = p_user
                       AND   hur_role     = l_role
                     )
    AND   EXISTS     (SELECT 1
                       FROM  hig_users
                      WHERE  hus_username = p_user
                     )
    AND   EXISTS     (SELECT 1
                       FROM  hig_roles
                      WHERE  hro_role     = l_role
                     );
--
--  nm_debug.proc_end(p_package_name   => NULL
--                   ,p_procedure_name => 'grant_role_to_user');

END grant_role_to_user;
/
