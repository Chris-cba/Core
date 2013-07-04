clear screen
prompt
prompt Drop Highways owner script.
prompt exor corp. 2001
prompt
prompt answer ALL questions, pressing RETURN AFTER EACH one
prompt
--
undefine p_user
undefine p_drop_all
--
ACCEPT p_user     char prompt 'ENTER THE NAME OF THE HIGHWAYS OWNER : ';
ACCEPT p_drop_all char prompt 'DROP ALL SUBORDINATE USERS (Y/N) ?   : ';
prompt
prompt dropping highways owner.............
prompt
--
SET verify OFF;
SET feedback OFF;
set serveroutput on size 100000
--
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)drop_higowner.sql	1.3 02/21/05
--       Module Name      : drop_higowner.sql
--       Date into SCCS   : 05/02/21 14:38:52
--       Date fetched Out : 07/06/13 13:56:59
--       SCCS Version     : 1.3
--
--
--   Author : Jonathan Mills
--
--   drop_higowner script. Removes a Highways owner and optionally
--    all of it's subordinate users
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   p_user     CONSTANT varchar2(30) := UPPER('&P_USER');
   p_drop_all CONSTANT BOOLEAN      := UPPER('&p_drop_all') = 'Y';
--
   CURSOR user_exists (c_user VARCHAR2) IS
   SELECT 1
    FROM  all_users
   WHERE  username = c_user;
--
   l_dummy number;
--
   TYPE extra_things IS RECORD
      (obj_type VARCHAR2(30)
      ,obj_name VARCHAR2(30)
      );
   TYPE tab_extra_things IS TABLE OF extra_things INDEX BY BINARY_INTEGER;
   l_tab_extra_things tab_extra_things;
--
   TYPE tab_user IS TABLE OF Varchar2(30) INDEX BY BINARY_INTEGER;
   l_tab_users_to_lock tab_user;
--
-- ----------------------------------------------------------------
--
   FUNCTION is_connected (p_user VARCHAR2) RETURN BOOLEAN IS
--
      CURSOR conn (c_user VARCHAR2) IS
      SELECT 1
       FROM  v$session
      WHERE  username = c_user;
--
      l_dummy  BINARY_INTEGER;
      l_retval BOOLEAN;
--
   BEGIN
--
      OPEN  conn (p_user);
      FETCH conn INTO l_dummy;
      l_retval := conn%FOUND;
      CLOSE conn;
--
      RETURN l_retval;
--
   END is_connected;
--
-- ----------------------------------------------------------------
--
   PROCEDURE lock_user (p_user VARCHAR2) IS
      not_exists EXCEPTION;
      PRAGMA EXCEPTION_INIT(not_exists,-1918);
   BEGIN
      EXECUTE IMMEDIATE 'ALTER USER '||p_user||' ACCOUNT LOCK';
      dbms_output.put_line('LOCKED : '||p_user);
   EXCEPTION
      WHEN not_exists THEN NULL;
   END lock_user;
--
-- ----------------------------------------------------------------
--
   PROCEDURE unlock_user (p_user VARCHAR2) IS
      not_exists EXCEPTION;
      PRAGMA EXCEPTION_INIT(not_exists,-1918);
   BEGIN
      EXECUTE IMMEDIATE 'ALTER USER '||p_user||' ACCOUNT UNLOCK';
      dbms_output.put_line('UNLOCKED : '||p_user);
   EXCEPTION
      WHEN not_exists THEN NULL;
   END unlock_user;
--
-- ----------------------------------------------------------------
--
   PROCEDURE drop_user (p_user VARCHAR2) IS
      not_exists EXCEPTION;
      PRAGMA EXCEPTION_INIT(not_exists,-1918);
   BEGIN
      EXECUTE IMMEDIATE 'DROP USER '||p_user||' CASCADE';
      dbms_output.put_line('DROPPED : '||p_user);
   EXCEPTION
      WHEN not_exists THEN NULL;
   END drop_user;
--
-- ----------------------------------------------------------------
--
   PROCEDURE drop_context (p_user VARCHAR2) IS
   BEGIN
      EXECUTE IMMEDIATE 'DROP CONTEXT NM3_'||p_user;
      dbms_output.put_line('DROPPED CONTEXT : NM3_'||p_user);
   EXCEPTION
      WHEN others THEN NULL;
   END drop_context;
--
-- ----------------------------------------------------------------
--
   PROCEDURE get_subordinate_users (p_user VARCHAR2) IS
      TYPE ref_cur IS REF CURSOR;
      l_cur  ref_cur;
      l_user VARCHAR2(30);
   BEGIN
      OPEN  l_cur FOR 'SELECT hus_username FROM '||p_user||'.hig_users WHERE hus_username != '
                      ||CHR(39)||p_user||CHR(39)||' AND hus_is_hig_owner_flag = ''N''';
      LOOP
        FETCH l_cur INTO l_user;
        EXIT WHEN l_cur%NOTFOUND;
        l_tab_users_to_lock(l_tab_users_to_lock.COUNT+1) := l_user;
      END LOOP;
      CLOSE l_cur;
   END get_subordinate_users;
--
-- ----------------------------------------------------------------
--
   PROCEDURE drop_syns (p_syn_owner VARCHAR2
                       ,p_hig_owner VARCHAR2
                       ) IS
      l_pub VARCHAR2(30);
      l_own VARCHAR2(30);
   BEGIN
--
      IF p_syn_owner = 'PUBLIC'
       THEN
         l_pub := 'PUBLIC ';
         l_own := Null;
      ELSE
         l_pub := Null;
         l_own := p_syn_owner||'.';
      END IF;
--
      FOR cs_rec IN (SELECT *
                      FROM  all_synonyms
                     WHERE  owner       = p_syn_owner
                      AND   table_owner = p_hig_owner
                    )
       LOOP
         BEGIN
            EXECUTE IMMEDIATE 'DROP '||l_pub||'SYNONYM '||l_own||cs_rec.synonym_name;
         EXCEPTION
            WHEN others THEN NULL;
         END;
      END LOOP;
--
   END drop_syns;
--
-- ----------------------------------------------------------------
--
   PROCEDURE drop_extra (p_user VARCHAR2) IS
   BEGIN
      FOR i IN 1..l_tab_extra_things.COUNT
       LOOP
         BEGIN
            EXECUTE IMMEDIATE 'DROP '||l_tab_extra_things(i).obj_type||' '||p_user||'.'||l_tab_extra_things(i).obj_name;
            dbms_output.put_line('DROPPED : '||l_tab_extra_things(i).obj_type||' '||p_user||'.'||l_tab_extra_things(i).obj_name);
         EXCEPTION
            WHEN others
             THEN
               Null;
         END;
      END LOOP;
   END drop_extra;
--
-- ----------------------------------------------------------------
--
BEGIN
--


   OPEN  user_exists (p_user);
   FETCH user_exists INTO l_dummy;
   IF user_exists%NOTFOUND
    THEN
      CLOSE user_exists;
      RAISE_APPLICATION_ERROR(-20001,'User '||p_user||' does not exist');
   END IF;
   CLOSE user_exists;
--
   l_tab_extra_things(1).obj_type := 'TRIGGER';
   l_tab_extra_things(1).obj_name := 'INSTANTIATE_USER';
--
   get_subordinate_users (p_user);
--
   IF is_connected (p_user)
     THEN
      RAISE_APPLICATION_ERROR(-20002,'User "'||p_user||'" is connected');
   END IF;
--
   FOR i IN 1..l_tab_users_to_lock.COUNT
    LOOP
      IF is_connected (l_tab_users_to_lock(i))
       THEN
         RAISE_APPLICATION_ERROR(-20003,'Subordinate user "'||l_tab_users_to_lock(i)||'" is connected');
      END IF;
   END LOOP;
--
   -- Lock the highways owner
   lock_user (p_user);
--
   -- Lock the subordinate users
   FOR i IN 1..l_tab_users_to_lock.COUNT
    LOOP
      lock_user (l_tab_users_to_lock(i));
   END LOOP;
--
   -- Either drop the subordinate users or remove the synoynms
   FOR i IN 1..l_tab_users_to_lock.COUNT
    LOOP
      IF p_drop_all
       THEN
         drop_user  (l_tab_users_to_lock(i));
      ELSE
         drop_syns  (l_tab_users_to_lock(i),p_user);
         drop_extra (l_tab_users_to_lock(i));
      END IF;
   END LOOP;
--
   drop_syns    ('PUBLIC',p_user);
   drop_extra   (p_user);
   drop_user    (p_user);
   drop_context (p_user);
--
   IF NOT p_drop_all
    THEN
      FOR i IN 1..l_tab_users_to_lock.COUNT
       LOOP
         unlock_user (l_tab_users_to_lock(i));
      END LOOP;
   END IF;
--
END;
/
