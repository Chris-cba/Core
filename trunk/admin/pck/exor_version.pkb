CREATE OR REPLACE PACKAGE BODY exor_version IS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/exor_version.pkb-arc   2.1   May 16 2011 14:42:10   Steve.Cooper  $
--       Module Name      : $Workfile:   exor_version.pkb  $
--       Date into SCCS   : $Date:   May 16 2011 14:42:10  $
--       Date fetched Out : $Modtime:   Apr 01 2011 15:50:50  $
--       SCCS Version     : $Revision:   2.1  $
--       Based on SCCS Version     : 1.2
--
--
--   Author : Jonathan Mills
--
--   exor Package version retrieval package
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2000
-----------------------------------------------------------------------------
--
   g_body_sccsid     CONSTANT  VARCHAR2(80) := '"$Revision:   2.1  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  VARCHAR2(30)   := 'exor_version';
--
   TYPE tab_evt IS TABLE OF exor_version_tab%ROWTYPE INDEX BY BINARY_INTEGER;
   g_tab_evt tab_evt;
--
-----------------------------------------------------------------------------
--
FUNCTION get_exor_version (pi_package_name IN exor_version_tab.package_name%TYPE
                          ,pi_package_type IN exor_version_tab.package_type%TYPE
                          ) RETURN exor_version_tab%ROWTYPE;
--
-----------------------------------------------------------------------------
--
FUNCTION check_proc_exists (pi_owner        IN all_arguments.owner%TYPE
                           ,pi_package_name IN all_arguments.package_name%TYPE
                           ,pi_proc_name    IN all_arguments.object_name%TYPE
                           ) RETURN BOOLEAN;
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
PROCEDURE get_versions IS
--
   PRAGMA AUTONOMOUS_TRANSACTION;
--
   CURSOR cs_evt IS
   SELECT *
    FROM  exor_version_tab
   FOR UPDATE OF version_text NOWAIT;
--
   c_package_type             CONSTANT VARCHAR2(30) := 'PACKAGE';
   c_package_body_type        CONSTANT VARCHAR2(30) := 'PACKAGE BODY';
   c_type_body_type           CONSTANT VARCHAR2(30) := 'TYPE BODY';
--
   c_package_version_function CONSTANT VARCHAR2(30) := 'GET_VERSION';
   c_body_version_function    CONSTANT VARCHAR2(30) := 'GET_BODY_VERSION';
--
   c_sysdate                  CONSTANT DATE         := SYSDATE;
--
   c_error_start              CONSTANT VARCHAR2(6)  := 'ERROR:';
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_versions');
--
   FOR cs_rec IN cs_evt
    LOOP
      g_tab_evt(g_tab_evt.COUNT+1) := cs_rec;
   END LOOP;
--
   DELETE FROM exor_version_tab;
--
   FOR cs_rec IN (SELECT object_name
                        ,object_type
                        ,last_ddl_time
                        ,DECODE(object_type
                               ,c_package_type, c_package_version_function
                               ,c_package_body_type, c_body_version_function
                               ,c_type_body_type, c_body_version_function
                               ) function_to_call
                        ,owner
                   FROM  all_objects
                  WHERE  object_type IN (c_package_type, c_package_body_type, c_type_body_type)
                   AND   owner       =  Sys_Context('NM3CORE','APPLICATION_OWNER')
                 )
    LOOP
      DECLARE
         l_rec_evt         exor_version_tab%ROWTYPE;
         l_get_new_version BOOLEAN := FALSE;
      BEGIN
--
         l_rec_evt := get_exor_version (cs_rec.object_name, cs_rec.object_type);
--
         IF l_rec_evt.package_name IS NULL
          THEN
            -- If this object has not got a row in the table
            l_get_new_version := TRUE;
         ELSIF l_rec_evt.last_ddl_time < cs_rec.last_ddl_time
          THEN
            -- If this object has been changed since this was last run
            l_get_new_version := TRUE;
         ELSIF SUBSTR(l_rec_evt.version_text,1,LENGTH(c_error_start)) = c_error_start
          THEN
            -- If there was an exception the last time we tried - have another go
            l_get_new_version := TRUE;
         END IF;
--
         IF l_get_new_version
          THEN
--
            l_rec_evt.package_name      := cs_rec.object_name;
            l_rec_evt.package_type      := cs_rec.object_type;
            l_rec_evt.last_ddl_time     := cs_rec.last_ddl_time;
            l_rec_evt.timestamp_created := c_sysdate;
--
            IF  check_proc_exists (cs_rec.owner, cs_rec.object_name, cs_rec.function_to_call)
             THEN
--
--             If the function exists then call it
--
               BEGIN
                  EXECUTE IMMEDIATE 'select '||cs_rec.object_name||'.'||cs_rec.function_to_call||'() FROM dual'
                   INTO   l_rec_evt.version_text;
               EXCEPTION
                  WHEN others
                   THEN
                     l_rec_evt.version_text := c_error_start||SUBSTR(SQLERRM,1,2000-LENGTH(c_error_start));
               END;
--
            ELSE
               l_rec_evt.version_text := 'Version function does not exist : '||cs_rec.function_to_call;
            END IF;
--
         END IF;
--
         INSERT INTO exor_version_tab
                (package_name
                ,package_type
                ,version_text
                ,last_ddl_time
                ,timestamp_created
                )
         VALUES (l_rec_evt.package_name
                ,l_rec_evt.package_type
                ,l_rec_evt.version_text
                ,l_rec_evt.last_ddl_time
                ,l_rec_evt.timestamp_created
                );
--
      END;
   END LOOP;
--
   COMMIT;
--
   nm_debug.proc_end(g_package_name,'get_versions');
--
END get_versions;
--
-----------------------------------------------------------------------------
--
FUNCTION get_exor_version (pi_package_name IN exor_version_tab.package_name%TYPE
                          ,pi_package_type IN exor_version_tab.package_type%TYPE
                          ) RETURN exor_version_tab%ROWTYPE IS
--
   l_rec_evt exor_version_tab%ROWTYPE;
--
BEGIN
--
   FOR l_count IN 1..g_tab_evt.COUNT
    LOOP
      IF   g_tab_evt(l_count).package_name = pi_package_name
       AND g_tab_evt(l_count).package_type = pi_package_type
       THEN
         l_rec_evt := g_tab_evt(l_count);
         EXIT;
      END IF;
   END LOOP;
--
   RETURN l_rec_evt;
--
END get_exor_version;
--
-----------------------------------------------------------------------------
--
FUNCTION check_proc_exists (pi_owner        IN all_arguments.owner%TYPE
                           ,pi_package_name IN all_arguments.package_name%TYPE
                           ,pi_proc_name    IN all_arguments.object_name%TYPE
                           ) RETURN BOOLEAN IS
--
   CURSOR cs_aa (p_owner        all_arguments.owner%TYPE
                ,p_package_name all_arguments.package_name%TYPE
                ,p_object_name  all_arguments.object_name%TYPE
                ) IS
   SELECT 1
    FROM  all_arguments
   WHERE  owner        = p_owner
    AND   package_name = p_package_name
    AND   object_name  = p_object_name;
--
   CURSOR cs_atm (p_owner       all_type_methods.owner%TYPE
                 ,p_type_name   all_type_methods.type_name%TYPE
                 ,p_method_name all_type_methods.method_name%TYPE
                 ) IS
   SELECT 1
    FROM  all_type_methods
   WHERE  owner       = p_owner
    AND   type_name   = p_type_name
    AND   method_name = p_method_name;
--
   l_dummy  BINARY_INTEGER;
   l_retval BOOLEAN;
--
BEGIN
--
   OPEN  cs_aa (pi_owner, pi_package_name, pi_proc_name);
   FETCH cs_aa INTO l_dummy;
   l_retval := cs_aa%FOUND;
   CLOSE cs_aa;
--
   IF NOT l_retval
    THEN
      -- If we've not found this in all_arguments
      --   have a look to see if it's an object function
      OPEN  cs_atm (pi_owner, pi_package_name, pi_proc_name);
      FETCH cs_atm INTO l_dummy;
      l_retval := cs_atm%FOUND;
      CLOSE cs_atm;
   END IF;
--
   RETURN l_retval;
--
END check_proc_exists;
--
-----------------------------------------------------------------------------
--
END exor_version;
/
