CREATE OR REPLACE PACKAGE BODY hig_directories_api AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_directories_api.pkb	1.6 05/04/07
--       Module Name      : hig_directories_api.pkb
--       Date into SCCS   : 07/05/04 11:24:21
--       Date fetched Out : 07/06/13 14:10:19
--       SCCS Version     : 1.6
--
--
--   Author : Graeme Johnson 
--
--
-----------------------------------------------------------------------------
--
--  Copyright (c) exor corporation ltd, 2005
--
-----------------------------------------------------------------------------
--
   g_body_sccsid CONSTANT  VARCHAR2(2000) := '"@(#)hig_directories_api.pkb	1.6 05/04/07"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'hig_directories_api';
--
FUNCTION get_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
--
--   Function to get using HDIR_PK constraint
--
FUNCTION get (pi_hdir_name         hig_directories.hdir_name%TYPE
             ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
             ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
             ) RETURN hig_directories%ROWTYPE IS
--
   CURSOR cs_hdir IS
   SELECT /*+ FIRST_ROWS(1) INDEX(hdir HDIR_PK) */ 
          hdir_name
         ,hdir_path
         ,hdir_url
         ,hdir_comments
         ,hdir_protected
    FROM  hig_directories hdir
   WHERE  hdir.hdir_name = pi_hdir_name;
--
   l_found  BOOLEAN;
   l_retval hig_directories%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get');
--
   OPEN  cs_hdir;
   FETCH cs_hdir INTO l_retval;
   l_found := cs_hdir%FOUND;
   CLOSE cs_hdir;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_directories (HDIR_PK)'
                                              ||CHR(10)||'hdir_name => '||pi_hdir_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get');
--
   RETURN l_retval;
--
END get;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to del using HDIR_PK constraint
--
PROCEDURE del (pi_hdir_name         hig_directories.hdir_name%TYPE
              ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
              ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
              ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
              ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'del');
--
   -- Lock the row first
   l_rowid := lock_gen(
       pi_hdir_name         => pi_hdir_name
      ,pi_raise_not_found   => pi_raise_not_found
      ,pi_not_found_sqlcode => pi_not_found_sqlcode
      ,pi_locked_sqlcode    => pi_locked_sqlcode
      );
--
   IF l_rowid IS NOT NULL
    THEN
      DELETE /*+ ROWID(hdir)*/ hig_directories hdir
      WHERE hdir.ROWID = l_rowid;
   END IF;
--
   nm_debug.proc_end(g_package_name,'del');
--
END del;
--
-----------------------------------------------------------------------------
--
--
--   Function to lock using HDIR_PK constraint
--
FUNCTION lock_gen (pi_hdir_name         hig_directories.hdir_name%TYPE
                  ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                  ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                  ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                  ) RETURN ROWID IS
--
   CURSOR cs_hdir IS
   SELECT /*+ FIRST_ROWS(1) INDEX(hdir HDIR_PK) */ hdir.ROWID
    FROM  hig_directories hdir
   WHERE  hdir.hdir_name = pi_hdir_name
   FOR UPDATE NOWAIT;
--
   l_found         BOOLEAN;
   l_retval        ROWID;
   l_record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_record_locked,-54);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_gen');
--
   OPEN  cs_hdir;
   FETCH cs_hdir INTO l_retval;
   l_found := cs_hdir%FOUND;
   CLOSE cs_hdir;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'hig_directories (HDIR_PK)'
                                              ||CHR(10)||'hdir_name => '||pi_hdir_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_gen');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN l_record_locked
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 33
                    ,pi_sqlcode            => pi_locked_sqlcode
                    ,pi_supplementary_info => 'hig_directories (HDIR_PK)'
                                              ||CHR(10)||'hdir_name => '||pi_hdir_name
                    );
--
END lock_gen;
--
-----------------------------------------------------------------------------
--
--
--   Procedure to lock using HDIR_PK constraint
--
PROCEDURE lock_gen (pi_hdir_name         hig_directories.hdir_name%TYPE
                   ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                   ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
                   ,pi_locked_sqlcode    PLS_INTEGER DEFAULT -20000
                   ) IS
--
   l_rowid ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_gen');
--
   l_rowid := lock_gen
                   (pi_hdir_name         => pi_hdir_name
                   ,pi_raise_not_found   => pi_raise_not_found
                   ,pi_not_found_sqlcode => pi_not_found_sqlcode
                   ,pi_locked_sqlcode    => pi_locked_sqlcode
                   );
--
   nm_debug.proc_end(g_package_name,'lock_gen');
--
END lock_gen;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins (p_rec_hdir IN OUT hig_directories%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins');
--
--
   INSERT INTO hig_directories
   VALUES p_rec_hdir
  RETURNING hdir_name
           ,hdir_path
           ,hdir_url
           ,hdir_comments
     INTO   p_rec_hdir.hdir_name
           ,p_rec_hdir.hdir_path
           ,p_rec_hdir.hdir_url
           ,p_rec_hdir.hdir_comments;
--
   nm_debug.proc_end(g_package_name,'ins');
--
END ins;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug (pi_rec_hdir hig_directories%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug');
--
   nm_debug.debug('hdir_name     : '||pi_rec_hdir.hdir_name,p_level);
   nm_debug.debug('hdir_path     : '||pi_rec_hdir.hdir_path,p_level);
   nm_debug.debug('hdir_url      : '||pi_rec_hdir.hdir_url,p_level);
   nm_debug.debug('hdir_comments : '||pi_rec_hdir.hdir_comments,p_level);
--
   nm_debug.proc_end(g_package_name,'debug');
--
END debug;
--
-----------------------------------------------------------------------------
--
PROCEDURE enforce_protection(pi_hdir_rec_old IN hig_directories%ROWTYPE
                            ,pi_hdir_rec_new IN hig_directories%ROWTYPE
                            ,pi_action       IN VARCHAR2) IS

 ex_record_cannot_be_deleted    EXCEPTION;
 ex_attribute_cannot_be_updated EXCEPTION;
                            
BEGIN

--
-- prevent record from being deleted
--
  IF pi_action = 'D' AND pi_hdir_rec_old.hdir_protected = 'Y' THEN
    RAISE ex_record_cannot_be_deleted;

--
-- prevent hdir_name from being updated
--
  ELSIF pi_action = 'U' AND pi_hdir_rec_new.hdir_protected = 'Y' AND pi_hdir_rec_old.hdir_name != pi_hdir_rec_new.hdir_name THEN 
    RAISE ex_attribute_cannot_be_updated;
  END IF;
  
EXCEPTION
 WHEN ex_record_cannot_be_deleted THEN
   hig.raise_ner(pi_appl               => nm3type.c_hig
                ,pi_id                 => 86
                ,pi_supplementary_info => chr(10)||'Directory is protected');  

 WHEN ex_attribute_cannot_be_updated THEN
   hig.raise_ner(pi_appl               => nm3type.c_net
                ,pi_id                 => 338  
                ,pi_supplementary_info => chr(10)||'Directory is protected');
  
END enforce_protection;
--
-----------------------------------------------------------------------------
--
PROCEDURE mkdir(pi_replace        IN BOOLEAN DEFAULT TRUE
               ,pi_directory_name IN hig_directories.hdir_name%TYPE
               ,pi_directory_path IN hig_directories.hdir_path%TYPE) IS
               
 l_sql nm3type.max_varchar2;
 l_replace_sql VARCHAR2(20);
 
 ex_no_privs EXCEPTION;
 PRAGMA exception_init (ex_no_privs,-1031);
 
 pragma autonomous_transaction; -- required cos this procedure is called from trigger(s) where DDL is not permitted
        

BEGIN
  
 IF pi_replace THEN
   l_replace_sql := 'OR REPLACE';
 END IF;
 
 l_sql := 'CREATE '||l_replace_sql||' DIRECTORY '||pi_directory_name||' AS '||nm3flx.string(pi_directory_path);
 
 EXECUTE IMMEDIATE l_sql;
 
EXCEPTION
  
 WHEN ex_no_privs THEN
   hig.raise_ner(pi_appl               => nm3type.c_net
                ,pi_id                 => 236 
                ,pi_supplementary_info => chr(10)||l_sql);  

 WHEN others THEN
   hig.raise_ner(pi_appl               => nm3type.c_net
                ,pi_id                 => 28 
                ,pi_supplementary_info => chr(10)||l_sql||chr(10)||sqlerrm);  
                
END mkdir;              
--
-----------------------------------------------------------------------------
--
PROCEDURE rmdir(pi_directory_name IN hig_directories.hdir_name%TYPE) IS
               
 l_sql nm3type.max_varchar2;
 
 ex_no_privs EXCEPTION;
 PRAGMA exception_init (ex_no_privs,-1031);           

 ex_not_exists EXCEPTION;
 PRAGMA exception_init (ex_not_exists,-4043);             
 
 pragma autonomous_transaction; -- required cos this procedure is called from trigger(s) where DDL is not permitted
 
BEGIN
  
 l_sql := 'DROP DIRECTORY '||pi_directory_name;
 
 EXECUTE IMMEDIATE l_sql;
 
EXCEPTION
  
 WHEN ex_not_exists THEN
   hig.raise_ner(pi_appl               => nm3type.c_hig
                ,pi_id                 => 257
                ,pi_supplementary_info => chr(10)||l_sql);  


 WHEN ex_no_privs THEN
   hig.raise_ner(pi_appl               => nm3type.c_net
                ,pi_id                 => 236 
                ,pi_supplementary_info => chr(10)||l_sql);  

 WHEN others THEN
   hig.raise_ner(pi_appl               => nm3type.c_net
                ,pi_id                 => 28 
                ,pi_supplementary_info => chr(10)||l_sql||chr(10)||sqlerrm);  
                
END rmdir;              
--
-----------------------------------------------------------------------------
--
FUNCTION get_operation_for_mode(pi_mode IN VARCHAR2) RETURN nm3type.tab_varchar30 IS

 l_retval nm3type.tab_varchar30;

BEGIN
 
 IF UPPER(pi_mode) = 'READONLY' THEN
  l_retval(1) := 'READ';
 ELSIF UPPER(pi_mode) = 'NORMAL' THEN
  l_retval(1) := 'READ';
  l_retval(2) := 'WRITE';    
 END IF;
 
 RETURN(l_retval);

END get_operation_for_mode;
--
-----------------------------------------------------------------------------
--
PROCEDURE grant_role_on_directory(pi_hdr_rec IN hig_directory_roles%ROWTYPE) IS
               
 l_sql nm3type.max_varchar2;
 
 ex_no_privs EXCEPTION;
 PRAGMA exception_init (ex_no_privs,-1031);           

 ex_not_exists EXCEPTION;
 PRAGMA exception_init (ex_not_exists,-22930); 
 
 pragma autonomous_transaction; -- required cos this procedure is called from trigger(s) where DDL is not permitted
 
 l_tab_operations nm3type.tab_varchar30;
 
 
BEGIN
  
 l_tab_operations := get_operation_for_mode(pi_mode => pi_hdr_rec.hdr_mode);   

 FOR i IN 1..l_tab_operations.COUNT LOOP
 
   l_sql := 'GRANT '||l_tab_operations(i)||' ON DIRECTORY '||pi_hdr_rec.hdr_name||' TO '||pi_hdr_rec.hdr_role;
   EXECUTE IMMEDIATE l_sql;
   
 END LOOP;   
 
EXCEPTION
  
 WHEN ex_not_exists THEN
   hig.raise_ner(pi_appl               => nm3type.c_hig
                ,pi_id                 => 257
                ,pi_supplementary_info => chr(10)||l_sql);  


 WHEN ex_no_privs THEN
   hig.raise_ner(pi_appl               => nm3type.c_net
                ,pi_id                 => 236 
                ,pi_supplementary_info => chr(10)||l_sql);  

 WHEN others THEN
   hig.raise_ner(pi_appl               => nm3type.c_net
                ,pi_id                 => 28 
                ,pi_supplementary_info => chr(10)||l_sql||sqlerrm);  
                
END grant_role_on_directory;
--
-----------------------------------------------------------------------------
--
PROCEDURE revoke_role_on_directory(pi_hdr_rec IN hig_directory_roles%ROWTYPE) IS

       
 l_sql nm3type.max_varchar2;
 
 ex_no_privs EXCEPTION;
 PRAGMA exception_init (ex_no_privs,-1031);           

 ex_not_exists EXCEPTION;
 PRAGMA exception_init (ex_not_exists,-22930); 

 ex_already_revoked EXCEPTION;
 PRAGMA exception_init (ex_already_revoked,-1927); 
 
 pragma autonomous_transaction; -- required cos this procedure is called from trigger(s) where DDL is not permitted
 
 l_tab_operations nm3type.tab_varchar30;
 
 
BEGIN
  
 l_tab_operations := get_operation_for_mode(pi_mode => pi_hdr_rec.hdr_mode);   

 FOR i IN 1..l_tab_operations.COUNT LOOP
 
   l_sql := 'REVOKE '||l_tab_operations(i)||' ON DIRECTORY '||pi_hdr_rec.hdr_name||' FROM '||pi_hdr_rec.hdr_role;
   EXECUTE IMMEDIATE l_sql;
   
 END LOOP;   
 
EXCEPTION
  
 WHEN ex_already_revoked THEN
   Null;  

 WHEN ex_not_exists THEN
   hig.raise_ner(pi_appl               => nm3type.c_hig
                ,pi_id                 => 257
                ,pi_supplementary_info => chr(10)||l_sql);  


 WHEN ex_no_privs THEN
   hig.raise_ner(pi_appl               => nm3type.c_net
                ,pi_id                 => 236 
                ,pi_supplementary_info => chr(10)||l_sql);  

 WHEN others THEN
   hig.raise_ner(pi_appl               => nm3type.c_net
                ,pi_id                 => 28 
                ,pi_supplementary_info => chr(10)||l_sql||sqlerrm);  
                
END revoke_role_on_directory;
--
-----------------------------------------------------------------------------
--
FUNCTION directory_exists(pi_directory_name IN dba_directories.DIRECTORY_NAME%TYPE
                         ,pi_directory_path IN dba_directories.DIRECTORY_PATH%TYPE) RETURN VARCHAR2 IS

 CURSOR c1 IS                        
 SELECT 'Y'
 FROM  dba_directories
 WHERE directory_name = pi_directory_name
 AND   directory_path = pi_directory_path; 

 l_dummy VARCHAR2(1);
 
BEGIN

 OPEN c1;
 FETCH c1 INTO l_dummy;
 CLOSE c1;
 
 RETURN(NVL(l_dummy,'N'));

END directory_exists;
--
-----------------------------------------------------------------------------
--
FUNCTION hdir_exists(pi_dir_path IN dba_directories.directory_path%type) 
RETURN BOOLEAN
AS
--
CURSOR valid_dir_cur(p_dir_path dba_directories.directory_path%type)
IS
  SELECT 'X'
  FROM hig_directories
     , dba_directories
     , hig_directory_roles
     , hig_user_roles
  WHERE directory_name = hdir_name
  AND hdr_name = hdir_name
  AND hur_role = hdr_role
  AND ((rtrim(ltrim(hdir_path, '/'), '/') = rtrim(ltrim(p_dir_path, '/'), '/'))
  OR (rtrim(ltrim(hdir_path, '\'), '\') = rtrim(ltrim(p_dir_path, '\'), '\')))
  AND hur_username =  Sys_Context('NM3_SECURITY_CTX','USERNAME');
  --
  l_dummy VARCHAR2(1);
  l_return_val BOOLEAN;
--
BEGIN
  --
  OPEN valid_dir_cur(pi_dir_path);
  FETCH valid_dir_cur into l_dummy;
  --
  l_return_val:= valid_dir_cur%FOUND;
  --
  CLOSE valid_dir_cur;
  --
RETURN l_return_val;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION directory_write_permission(pi_directory_name IN dba_directories.DIRECTORY_NAME%TYPE) RETURN VARCHAR2 IS

 CURSOR c1 IS                        
 SELECT 'Y'
 FROM   all_tab_privs   atp
--      , session_roles   sro
       ,hig_user_roles  hur
 WHERE  atp.table_name  = pi_directory_name
 AND    atp.privilege   = 'WRITE'
 AND    atp.grantee     = hur.hur_role
 AND    hur.HUR_USERNAME = Sys_Context('NM3_SECURITY_CTX','USERNAME');

 l_dummy VARCHAR2(1);
 
BEGIN
-- dbms_output.put_line('pi_directory_name='||pi_directory_name);
 OPEN c1;
 FETCH c1 INTO l_dummy;
 CLOSE c1;
-- dbms_output.put_line('l_dummy='||l_dummy);
  
 RETURN(NVL(l_dummy,'N'));

END directory_write_permission;
--
-----------------------------------------------------------------------------
--
FUNCTION directory_read_permission(pi_directory_name IN dba_directories.DIRECTORY_NAME%TYPE) RETURN VARCHAR2 IS

 CURSOR c1 IS                        
 SELECT 'Y'
 FROM   all_tab_privs   atp
--      , session_roles   sro
       ,hig_user_roles  hur
 WHERE  atp.table_name  = pi_directory_name
 AND    atp.privilege   = 'READ'
 AND    atp.grantee     = hur.hur_role
 AND    hur.HUR_USERNAME = Sys_Context('NM3_SECURITY_CTX','USERNAME');


 l_dummy VARCHAR2(1);
 
BEGIN

 OPEN c1;
 FETCH c1 INTO l_dummy;
 CLOSE c1;
 
 RETURN(NVL(l_dummy,'N'));

END directory_read_permission;
--
-----------------------------------------------------------------------------
--
FUNCTION directory_role_applied(pi_hdr_name IN hig_directory_roles.hdr_name%TYPE
                               ,pi_hdr_role IN hig_directory_roles.hdr_role%TYPE
                               ,pi_hdr_mode IN hig_directory_roles.hdr_mode%TYPE) RETURN VARCHAR2 IS

 l_tab_operations nm3type.tab_varchar30;
 
 l_sql    nm3type.max_varchar2;
 l_refcur nm3type.ref_cursor;
 l_dummy  VARCHAR2(1);
  
BEGIN
  
 l_tab_operations := get_operation_for_mode(pi_mode => pi_hdr_mode);   

 FOR i IN 1..l_tab_operations.COUNT LOOP


   l_sql := 'SELECT 1 FROM  all_tab_privs WHERE table_name = '||nm3flx.string(pi_hdr_name)||' AND GRANTEE='||nm3flx.string(pi_hdr_role)||' AND PRIVILEGE='||nm3flx.string(l_tab_operations(i));   
dbms_output.put_line(l_sql);
   OPEN l_refcur FOR l_sql;
   FETCH l_refcur INTO l_dummy;
   IF l_refcur%NOTFOUND THEN
      CLOSE l_refcur;
      RETURN('N');
   END IF;
   CLOSE l_refcur;
dbms_output.put_line('l_dummy='||l_dummy);   
 END LOOP;

 RETURN('Y');
 
END directory_role_applied;
--
-----------------------------------------------------------------------------
--      
PROCEDURE check_write_allowed(pi_directory_name IN dba_directories.DIRECTORY_NAME%TYPE) IS

BEGIN

 IF directory_write_permission(pi_directory_name => pi_directory_name) = 'N' THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 264
                    ,pi_sqlcode            => -20002
                    ,pi_supplementary_info => pi_directory_name);
 END IF;
 
END check_write_allowed;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_read_allowed(pi_directory_name IN dba_directories.DIRECTORY_NAME%TYPE) IS

BEGIN

 IF directory_read_permission(pi_directory_name => pi_directory_name) = 'N' THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 263
                    ,pi_sqlcode            => -20003                    
                    ,pi_supplementary_info => pi_directory_name);
 END IF;
 
END check_read_allowed;
--
-----------------------------------------------------------------------------
--
FUNCTION has_java_priv
  ( pi_dir_name in hig_directories.hdir_name%type
  , pi_hdr_priv IN user_java_policy.action%TYPE
  , pi_user     IN user_java_policy.grantee_name%TYPE default Sys_Context('NM3_SECURITY_CTX','USERNAME')
  ) RETURN BOOLEAN is
l_count integer ;
begin
  nm_debug.proc_start(g_package_name,'has_java_priv');
  select count(*)
  into   l_count
  from   dba_java_policy
  where  type_name in ( gc_java_priv, 'SYS:' || gc_java_priv )
  and    name = get_true_dir_name(pi_dir_name)
  and    instr(action,lower(pi_hdr_priv)) > 0
  and    grantee = upper(pi_user)
  and    kind = 'GRANT'
  and    enabled = 'ENABLED'
  ;
  nm_debug.proc_end (g_package_name,'has_java_priv');
  return l_count > 0 ;
end has_java_priv;
--
-----------------------------------------------------------------------------
--
procedure grant_java_priv
  ( pi_dir_name in hig_directories.hdir_name%type
  , pi_hdr_priv IN user_java_policy.action%TYPE
  , pi_user     IN user_java_policy.grantee_name%TYPE default Sys_Context('NM3_SECURITY_CTX','USERNAME')
  ) is
begin
  nm_debug.proc_start(g_package_name,'grant_java_priv');
  DBMS_JAVA.grant_permission(upper(pi_user),gc_java_priv,get_true_dir_name(pi_dir_name), lower(pi_hdr_priv));
  DBMS_JAVA.grant_permission(upper(pi_user),gc_java_priv,get_dir_name(pi_dir_name), lower(pi_hdr_priv));
  nm_debug.proc_end (g_package_name,'grant_java_priv');
end grant_java_priv;
--
-----------------------------------------------------------------------------
--
procedure revoke_java_priv
  ( pi_dir_name in hig_directories.hdir_name%type
  , pi_hdr_priv IN user_java_policy.action%TYPE
  , pi_user     IN user_java_policy.grantee_name%TYPE default Sys_Context('NM3_SECURITY_CTX','USERNAME')
  ) 
is begin
  nm_debug.proc_start(g_package_name,'revoke_java_priv');
  -- We're doing this because we don't know if it's got SYS in
  -- front of the name or how many ways it's been granted
  -- also this way we'll get whatever directory name string
  -- the priv was granted with 
  for privs in
    ( select *
        from  dba_java_policy
       where  type_name in ( gc_java_priv, 'SYS:' || gc_java_priv )
         and  ((name = get_true_dir_name(pi_dir_name))
               OR (name = get_dir_name(pi_dir_name)))
         and  instr(action,lower(pi_hdr_priv)) > 0
         and  grantee = upper(pi_user)
         and  kind = 'GRANT'
         and  enabled = 'ENABLED'
         )
  loop
    DBMS_JAVA.revoke_permission(privs.grantee, privs.type_name, privs.name, pi_hdr_priv);
  end loop;

  nm_debug.proc_end (g_package_name,'revoke_java_priv');
end revoke_java_priv;
--
-----------------------------------------------------------------------------
--
procedure grant_all_java_priv
  ( pi_dir_name in hig_directories.hdir_name%type
  , pi_user     IN user_java_policy.grantee_name%TYPE default Sys_Context('NM3_SECURITY_CTX','USERNAME')
  ) is
begin
  nm_debug.proc_start(g_package_name,'grant_all_java_priv');
  grant_java_priv( pi_dir_name, gc_java_read,    pi_user ) ;
  grant_java_priv( pi_dir_name, gc_java_write,   pi_user ) ;
  grant_java_priv( pi_dir_name, gc_java_execute, pi_user ) ;
  grant_java_priv( pi_dir_name, gc_java_delete,  pi_user ) ;
  nm_debug.proc_end (g_package_name,'grant_all_java_priv');
end grant_all_java_priv;
--
-----------------------------------------------------------------------------
--
procedure revoke_all_java_priv
  ( pi_dir_name in hig_directories.hdir_name%type
  , pi_user     IN user_java_policy.grantee_name%TYPE default Sys_Context('NM3_SECURITY_CTX','USERNAME')
  ) is
begin
  nm_debug.proc_start(g_package_name,'revoke_all_java_priv');
  revoke_java_priv( pi_dir_name, gc_java_read,    pi_user ) ;
  revoke_java_priv( pi_dir_name, gc_java_write,   pi_user ) ;
  revoke_java_priv( pi_dir_name, gc_java_execute, pi_user ) ;
  revoke_java_priv( pi_dir_name, gc_java_delete,  pi_user ) ;
  nm_debug.proc_end (g_package_name,'revoke_all_java_priv');
end revoke_all_java_priv;
--
-----------------------------------------------------------------------------
--
FUNCTION get_true_dir_name
  (pi_loc       IN varchar2
  ) RETURN varchar2  is
l_dirname varchar2(2000) := nm3file.get_true_dir_name(pi_loc);
l_dirsep varchar2(10) := '\' ; -- '
begin
  -- We want to grant for the whole directory, which means that it needs to end
  -- with a directory separator and a hyphen
  if instr(l_dirname,'/') > 0
  then
    l_dirsep := '/' ;
  end if ;
  l_dirname := l_dirname ||
    case substr(l_dirname,-1)
      when '-'
      then
        '' 
      when l_dirsep
      then
        '-'
      else
        l_dirsep || '-'
      end  ;
    return l_dirname ;
end get_true_dir_name;
--
-----------------------------------------------------------------------------
--
FUNCTION get_dir_name(pi_loc IN varchar2) 
  RETURN VARCHAR2 IS
  --
  lv_dirname VARCHAR2(2000) := nm3file.get_true_dir_name(pi_loc);
  lv_dirsep  VARCHAR2(10)   := hig.get_sysopt('DIRREPSTRN');
  lv_retval  VARCHAR2(2000);
  --
begin
  /*
  || Return The Directory Path WITHOUT A
  || Trailing Separator.
  */
  IF substr(lv_dirname,length(lv_dirname)) = lv_dirsep
   THEN
      lv_retval := substr(lv_dirname,1,length(lv_dirname)-1);
  ELSE
      lv_retval := lv_dirname;
  END IF;
  --
  RETURN lv_retval;
  --
end get_dir_name;
--
-----------------------------------------------------------------------------
--
function get_constant
  ( p_constant_name in varchar2 ) return varchar2 is
l_workbuff varchar2(200) ;
begin
  execute immediate 'begin :x := ' || g_package_name || '.' || p_constant_name || '; end;' using out l_workbuff ;
  return l_workbuff ;
exception
  when others then
    raise_application_error(-20001,sqlerrm || ' Unknown package constant ' || p_constant_name );
end get_constant;
--
-----------------------------------------------------------------------------
--
PROCEDURE revoke_all_dir_role_privs(pi_name IN hig_directories.hdir_name%TYPE) IS
  --
  TYPE dir_privs_rec IS RECORD(grantee   all_tab_privs.grantee%TYPE
                              ,privilege all_tab_privs.privilege%TYPE);
  TYPE dir_privs_tab IS TABLE OF dir_privs_rec;
  lt_dir_privs dir_privs_tab;
  --
  lv_sql nm3type.max_varchar2;
  --
  ex_no_privs EXCEPTION;
  PRAGMA exception_init(ex_no_privs,-1031);           
  --
  ex_not_exists EXCEPTION;
  PRAGMA exception_init(ex_not_exists,-22930); 
  --
  ex_already_revoked EXCEPTION;
  PRAGMA exception_init(ex_already_revoked,-1927); 
  --
  PROCEDURE get_dir_privs IS
  BEGIN
    --
    SELECT grantee
          ,privilege
      BULK COLLECT
      INTO lt_dir_privs
      FROM all_tab_privs
     WHERE table_name = pi_name
       AND grantor != 'SYS'
         ;
    --
  EXCEPTION
    WHEN no_data_found
     THEN
        NULL;
    WHEN others
     THEN
        RAISE;
  END get_dir_privs;
  --
BEGIN
  --
  get_dir_privs;
  --
  FOR i IN 1..lt_dir_privs.count LOOP
    --
    lv_sql := 'REVOKE '||lt_dir_privs(i).privilege
            ||' ON DIRECTORY '||pi_name
            ||' FROM '||lt_dir_privs(i).grantee;
    EXECUTE IMMEDIATE lv_sql;
    --
  END LOOP;
  --
EXCEPTION
  WHEN ex_already_revoked
   THEN
      Null;  
  WHEN ex_not_exists
   THEN
      hig.raise_ner(pi_appl               => nm3type.c_hig
                   ,pi_id                 => 257
                   ,pi_supplementary_info => chr(10)||lv_sql);  
  WHEN ex_no_privs
   THEN
      hig.raise_ner(pi_appl               => nm3type.c_net
                   ,pi_id                 => 236 
                   ,pi_supplementary_info => chr(10)||lv_sql);  
  WHEN others
   THEN
      hig.raise_ner(pi_appl               => nm3type.c_net
                   ,pi_id                 => 28 
                   ,pi_supplementary_info => chr(10)||lv_sql||chr(10)||sqlerrm);  
END revoke_all_dir_role_privs;
--
-----------------------------------------------------------------------------
--
PROCEDURE grant_all_dir_roles(pi_name IN hig_directories.hdir_name%TYPE) IS
  --
  TYPE dir_roles_tab IS TABLE OF hig_directory_roles%ROWTYPE;
  lt_dir_roles dir_roles_tab;
  --
  PROCEDURE get_dir_roles IS
  BEGIN
    --
    SELECT *
      BULK COLLECT
      INTO lt_dir_roles
      FROM hig_directory_roles
     WHERE hdr_name = pi_name
         ;
    --
  EXCEPTION
    WHEN no_data_found
     THEN
        NULL;
    WHEN others
     THEN
        RAISE;
  END get_dir_roles;
  --
BEGIN
  --
  get_dir_roles;
  --
  FOR i IN 1..lt_dir_roles.count LOOP
    --
    grant_role_on_directory(pi_hdr_rec => lt_dir_roles(i));
    --
  END LOOP;
  --
END grant_all_dir_roles;
--
-----------------------------------------------------------------------------
--
PROCEDURE rebuild_all IS
  --
  TYPE dir_rec IS RECORD(hdir_name hig_directories.hdir_name%TYPE
                        ,hdir_path hig_directories.hdir_path%TYPE);
  TYPE dir_tab IS TABLE OF dir_rec;
  lt_dir dir_tab;
  --
  PROCEDURE get_dirs IS
  BEGIN
    --
    SELECT hdir_name
          ,hdir_path
      BULK COLLECT
      INTO lt_dir
      FROM hig_directories
         ;
    --
  EXCEPTION
    WHEN no_data_found
     THEN
        NULL;
    WHEN others
     THEN
        RAISE;
  END get_dirs;
  --
BEGIN
  /*
  || Get All Records From hig_directories.
  */
  get_dirs;
  --
  FOR i IN 1..lt_dir.count LOOP
    /*
    || Create Or Replace The Directory.
    */
    mkdir(pi_replace        => TRUE
         ,pi_directory_name => lt_dir(i).hdir_name
         ,pi_directory_path => lt_dir(i).hdir_path);
    /*
    || Clear Permissions Currently Granted
    || For The Directory.
    */
    revoke_all_dir_role_privs(pi_name => lt_dir(i).hdir_name);
    /*
    || Grant The Permissions Defined
    || In hig_directory_roles.
    */
    grant_all_dir_roles(pi_name => lt_dir(i).hdir_name);
    --
  END LOOP;
  --
END rebuild_all;
--
-----------------------------------------------------------------------------
--
END hig_directories_api;
/
