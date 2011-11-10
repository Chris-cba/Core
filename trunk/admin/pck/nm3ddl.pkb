CREATE OR REPLACE PACKAGE BODY Nm3ddl AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3ddl.pkb-arc   2.26   Nov 10 2011 14:00:40   Rob.Coupe  $
--       Module Name      : $Workfile:   nm3ddl.pkb  $
--       Date into PVCS   : $Date:   Nov 10 2011 14:00:40  $
--       Date fetched Out : $Modtime:   Nov 10 2011 13:55:46  $
--       PVCS Version     : $Revision:   2.26  $
--       Based on SCCS Version     : 1.5
--
--
--   Author : Jonathan Mills
--
--   NM3 DDL package
--
-----------------------------------------------------------------------------
-- Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
--
--all global package variables here
--
   g_body_sccsid     constant varchar2(30) :='"$Revision:   2.26  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  VARCHAR2(30)   := 'nm3ddl';
--
   g_syn_exc_code    NUMBER         := -20001;
   g_syn_exc_msg     VARCHAR2(2000) := 'Unspecified error within nm3ddl';
   g_syn_exception   EXCEPTION;
--
   c_public   CONSTANT VARCHAR2(6) := 'PUBLIC';
   c_private  Constant varchar2(7) := 'PRIVATE';
--
   c_grant  CONSTANT VARCHAR2(5) := 'GRANT';
   c_revoke CONSTANT VARCHAR2(6) := 'REVOKE';
--

   CURSOR cs_users IS
   SELECT hus_username
    FROM  HIG_USERS
         ,ALL_USERS
    WHERE hus_username != Sys_Context('NM3CORE','APPLICATION_OWNER')
     AND  username      = hus_username;

--

   CURSOR cs_col_det ( c_column_name ALL_TAB_COLUMNS.column_name%TYPE
                      ,c_table_name  ALL_TAB_COLUMNS.table_name%TYPE)
   IS
   SELECT *
   FROM ALL_TAB_COLUMNS
   WHERE column_name = c_column_name
     AND table_name  = c_table_name
     AND owner       = Sys_Context('NM3CORE','APPLICATION_OWNER');

--
--- LOCAL PROCEDURES --------------------------------------------------------
--
PROCEDURE syn_exec_ddl (p_text LONG);
--
-----------------------------------------------------------------------------
--
PROCEDURE exec_ddl (p_text LONG);
--
-----------------------------------------------------------------------------
--
PROCEDURE grant_or_revoke (p_grant_or_rev IN VARCHAR2
                          ,p_username     IN VARCHAR2
                          ,p_object_name  IN VARCHAR2
                          ,p_select       IN BOOLEAN
                          ,p_insert       IN BOOLEAN
                          ,p_update       IN BOOLEAN
                          ,p_delete       IN BOOLEAN
                          ,p_with_admin   IN BOOLEAN
                          );
--
-----------------------------------------------------------------------------
--- GLOBAL PROCEDURES -------------------------------------------------------
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
PROCEDURE create_object_and_syns (p_object_name IN USER_OBJECTS.object_name%TYPE) IS
BEGIN
   create_object_and_syns (p_object_name  => p_object_name
                          ,p_tab_ddl_text => g_tab_varchar
                          );
END create_object_and_syns;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_object_and_syns (p_object_name  IN USER_OBJECTS.object_name%TYPE
                                 ,p_tab_ddl_text IN Nm3type.tab_varchar32767
                                 ) IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'create_object_and_syns');
--
   IF INSTR(UPPER(p_tab_ddl_text(1)),UPPER(p_object_name),1,1) = 0
    THEN
      g_syn_exc_code := -20307;
      g_syn_exc_msg  := 'Text "'||p_object_name||'" not found in DDL String';
      RAISE g_syn_exception;
   END IF;
--
   execute_tab_varchar (p_tab_ddl_text);
--
   create_synonym_for_object(p_object_name);
--
   Nm_Debug.proc_end(g_package_name,'create_object_and_syns');
--
EXCEPTION
--
   WHEN g_syn_exception
    THEN
      RAISE_APPLICATION_ERROR(g_syn_exc_code, g_syn_exc_msg);
--
END create_object_and_syns;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_object_and_syns (p_object_name IN USER_OBJECTS.object_name%TYPE
                                 ,p_ddl_text    IN VARCHAR2
                                 ) IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'create_object_and_syns');
--
   IF INSTR(UPPER(p_ddl_text),UPPER(p_object_name),1,1) = 0
    THEN
      g_syn_exc_code := -20307;
      g_syn_exc_msg  := 'Text "'||p_object_name||'" not found in DDL String "'||p_ddl_text||'"';
      RAISE g_syn_exception;
   END IF;
--
   exec_ddl(p_ddl_text);
--
   create_synonym_for_object(p_object_name);
--
   Nm_Debug.proc_end(g_package_name,'create_object_and_syns');
--
EXCEPTION
--
   WHEN g_syn_exception
    THEN
      RAISE_APPLICATION_ERROR(g_syn_exc_code, g_syn_exc_msg);
--
END create_object_and_syns;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_object_and_syns (p_object_name IN USER_OBJECTS.object_name%TYPE
                                 ,p_ddl_text    IN CLOB
                                 ) IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'create_object_and_syns');
--
   IF NVL(Nm3clob.lob_instr(p_ddl_text,p_object_name),0) = 0
    THEN
      g_syn_exc_code := -20307;
      g_syn_exc_msg  := 'Text "'||p_object_name||'" not found in DDL String';
      RAISE g_syn_exception;
   END IF;
--
   Nm3clob.execute_immediate_clob(p_ddl_text);
--
   create_synonym_for_object(p_object_name);
--
   Nm_Debug.proc_end(g_package_name,'create_object_and_syns');
--
EXCEPTION
--
   WHEN g_syn_exception
    THEN
      RAISE_APPLICATION_ERROR(g_syn_exc_code, g_syn_exc_msg);
--
END create_object_and_syns;
--
--------------------------------------------------------------------------------
--
PROCEDURE create_views_for_object (p_object_name IN USER_OBJECTS.object_name%TYPE)
IS
--
   PRAGMA autonomous_transaction;
--
   CURSOR check_obj_exists (p_object VARCHAR2) IS
   SELECT 'x'
    FROM  ALL_OBJECTS
   WHERE  owner       = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   object_name = p_object;
--
   l_dummy VARCHAR2(1);
--
BEGIN
--
--   Output a debug message to say entering procedure
--
   Nm_Debug.proc_start(g_package_name,'create_views_for_object');
--
   Nm_Debug.DEBUG(p_object_name);
--
   OPEN  check_obj_exists( p_object_name);
   FETCH check_obj_exists INTO l_dummy;
   IF check_obj_exists%NOTFOUND
    THEN
      CLOSE check_obj_exists;
      g_syn_exc_code := -20301;
      g_syn_exc_msg  := 'Object "'||p_object_name||'" does not exist in schema '||Sys_Context('NM3CORE','APPLICATION_OWNER');
      RAISE g_syn_exception;
   END IF;
   CLOSE check_obj_exists;
--
   FOR cs_rec IN cs_users
   LOOP
     BEGIN
       exec_ddl ('CREATE OR REPLACE FORCE VIEW '||cs_rec.hus_username||'.'||p_object_name
                 ||' AS SELECT * FROM '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||p_object_name
                 );
     EXCEPTION
       WHEN OTHERS THEN NULL;
     END;
   END LOOP;
--
   COMMIT;
-- 
   Nm_Debug.proc_end(g_package_name,'create_views_for_object');
--
EXCEPTION
--
   WHEN g_syn_exception
    THEN
      COMMIT;
      RAISE_APPLICATION_ERROR(g_syn_exc_code, g_syn_exc_msg);
--
END create_views_for_object;
--
-----------------------------------------------------------------------------
--
-- AE Create object with views instead of synonyms
PROCEDURE create_object_and_views (p_object_name IN USER_OBJECTS.object_name%TYPE) IS
BEGIN
   create_object_and_views (p_object_name  => p_object_name
                           ,p_tab_ddl_text => g_tab_varchar
                           );
END create_object_and_views;
--
-----------------------------------------------------------------------------
--
-- AE Create object with views instead of synonyms
PROCEDURE create_object_and_views (p_object_name  IN USER_OBJECTS.object_name%TYPE
                                  ,p_tab_ddl_text IN Nm3type.tab_varchar32767
                                  ) IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'create_object_and_views');
--
   IF INSTR(UPPER(p_tab_ddl_text(1)),UPPER(p_object_name),1,1) = 0
    THEN
      g_syn_exc_code := -20307;
      g_syn_exc_msg  := 'Text "'||p_object_name||'" not found in DDL String';
      RAISE g_syn_exception;
   END IF;
--
   execute_tab_varchar (p_tab_ddl_text);
--
   create_views_for_object(p_object_name);
--
   Nm_Debug.proc_end(g_package_name,'create_object_and_views');
--
EXCEPTION
--
   WHEN g_syn_exception
    THEN
      RAISE_APPLICATION_ERROR(g_syn_exc_code, g_syn_exc_msg);
--
END create_object_and_views;
--
-----------------------------------------------------------------------------
--
-- AE Create object with views instead of synonyms
PROCEDURE create_object_and_views (p_object_name IN USER_OBJECTS.object_name%TYPE
                                  ,p_ddl_text    IN VARCHAR2
                                  ) IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'create_object_and_views');
--
   IF INSTR(UPPER(p_ddl_text),UPPER(p_object_name),1,1) = 0
    THEN
      g_syn_exc_code := -20307;
      g_syn_exc_msg  := 'Text "'||p_object_name||'" not found in DDL String "'||p_ddl_text||'"';
      RAISE g_syn_exception;
   END IF;
--
   exec_ddl(p_ddl_text);
--
   create_views_for_object(p_object_name);
--
   Nm_Debug.proc_end(g_package_name,'create_object_and_views');
--
EXCEPTION
--
   WHEN g_syn_exception
    THEN
      RAISE_APPLICATION_ERROR(g_syn_exc_code, g_syn_exc_msg);
--
END create_object_and_views;
--
-----------------------------------------------------------------------------
--
-- AE Create object with views instead of synonyms
PROCEDURE create_object_and_views (p_object_name IN USER_OBJECTS.object_name%TYPE
                                  ,p_ddl_text    IN CLOB
                                  ) IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'create_object_and_views');
--
   IF NVL(Nm3clob.lob_instr(p_ddl_text,p_object_name),0) = 0
    THEN
      g_syn_exc_code := -20307;
      g_syn_exc_msg  := 'Text "'||p_object_name||'" not found in DDL String';
      RAISE g_syn_exception;
   END IF;
--
   Nm3clob.execute_immediate_clob(p_ddl_text);
--
   create_views_for_object(p_object_name);
--
   Nm_Debug.proc_end(g_package_name,'create_object_and_views');
--
EXCEPTION
--
   WHEN g_syn_exception
    THEN
      RAISE_APPLICATION_ERROR(g_syn_exc_code, g_syn_exc_msg);
--
END create_object_and_views;
--
-----------------------------------------------------------------------------
--
FUNCTION use_pub_syn RETURN BOOLEAN IS
BEGIN
--
   RETURN Hig.Get_Sysopt('HIGPUBSYN') = 'Y';
--
END use_pub_syn;
--
-----------------------------------------------------------------------------
--
Procedure Create_Syn  (
                      p_Synonym_Name            In    Dba_Synonyms.Synonym_name%Type,
                      p_Synonym_Owner           In    Dba_Synonyms.Owner%Type,
                      p_Referenced_Object_Name  In    Dba_Synonyms.Table_Name%Type,
                      p_Referenced_Owner        In    Dba_Synonyms.Table_Owner%Type    
                      )
Is
  l_No_Privs    Exception;
  Pragma Exception_Init (l_No_Privs, -1031);
  l_Ddl Varchar2(4000);   
Begin
  Nm_Debug.Debug('Nm3ddl.Create_Syn - Called');
  Nm_Debug.Debug('Parameter - p_Synonym_Name :'           || p_Synonym_Name);
  Nm_Debug.Debug('Parameter - p_Synonym_Owner :'          || p_Synonym_Owner);
  Nm_Debug.Debug('Parameter - p_Referenced_Object_Name :' || p_Referenced_Object_Name);
  Nm_Debug.Debug('Parameter - p_Referenced_Owner :'       || p_Referenced_Owner);  
  
  If      p_Synonym_Name            Is  Not Null 
    And   p_Synonym_Owner           Is  Not Null
    And   p_Referenced_Object_Name  Is  Not Null
    And   p_Referenced_Owner        Is  Not Null  Then
    
    If p_Synonym_Owner = c_public Then
      l_Ddl:='CREATE OR REPLACE PUBLIC SYNONYM '|| p_Synonym_Name  ||' FOR '|| p_Referenced_Owner ||'.'|| p_Referenced_Object_Name;
    Else
      l_Ddl:='CREATE OR REPLACE SYNONYM '|| p_Synonym_Owner || '.' || p_Synonym_Name  ||' FOR '|| p_Referenced_Owner ||'.'|| p_Referenced_Object_Name;
    End If;
    
    Nm_Debug.Debug('DDL:' || l_Ddl );
    
    Execute Immediate (l_Ddl);
        
  Else
    Nm_Debug.Debug('Parameters null');
    Raise_Application_Error( -20001, 'Parameters can not be null in call to nm3ddl.Create_Syn');
  End If;
  Nm_Debug.Debug('Nm3ddl.Create_Syn - Finished');  
Exception
  When l_No_Privs Then
    Nm_Debug.Debug('Nm3ddl.Create_Syn - Finished - Exception (l_No_Privs) ');
    Raise_Application_Error( -20303, 'User "'||User||'" does not have permission to create this synonym -' || p_Synonym_Name );    
End Create_Syn;
--
-----------------------------------------------------------------------------
--
Procedure Create_Synonym_For_Object (
                                    p_Object_Name In  User_Objects.Object_Name%Type,
                                    p_Syn_Type    In  Varchar2 Default Null
                                    )
Is
  Pragma Autonomous_Transaction;
  l_Dummy     VARCHAR2(1);
  l_Syn_Type  Varchar2(7);
--
Begin  
  l_Syn_Type:=Upper(p_Syn_Type);
  
  If      ( l_Syn_Type  Is  Null Or
            l_Syn_Type  In  (c_public,c_private)      
          )
      And (p_Object_Name Is Not Null)  Then
        
    Select  Null
    Into    l_Dummy
    From    All_Objects ao
    Where   Owner       =   Sys_Context('NM3CORE','APPLICATION_OWNER')
    And     Object_Name =   p_Object_Name
    And     Not Exists  (
                        --Objects that we don't want synonyms built for regardless.
                        Select  Null
                        From    Nm_Syn_Exempt
                        Where   ao.Object_Name      Like  Nsyn_Object_Name     
                        And     ao.Object_Type      Like  Nsyn_Object_Type                    
                        )
    And     Rownum      =   1;                        

    -- If Private or Public is specified then create a single synonym for the given user/object. 
    -- If Private then it is assumed that the synonym is for the current user. 
    If ((p_Syn_Type Is Not Null) Or (   p_Syn_Type Is Null  And Use_Pub_Syn )) Then
      Create_Syn  (
                  p_Synonym_Name            => p_Object_Name,
                  p_Synonym_Owner           =>  (                                                
                                                Case 
                                                  When p_Syn_Type = c_private Then  Sys_Context('NM3_SECURITY_CTX','USERNAME')
                                                  Else c_public
                                                  End
                                                ),
                  p_Referenced_Object_Name  => p_Object_Name,
                  p_Referenced_Owner        => Sys_Context('NM3CORE','APPLICATION_OWNER')
                  );
    Else    
      --Private (for all sub users)
      For x In  (
                Select  hu.Hus_Username  Synonym_Owner
                From    Hig_Users   hu,
                        All_Users   au
                Where   hu.Hus_Username   !=    Sys_Context('NM3CORE','APPLICATION_OWNER')
                And     au.Username       =     hu.Hus_Username
                And     Not Exists        (     Select  Null
                                                From    Dba_Synonyms  ds
                                                Where   ds.Owner         =   hu.hus_username
                                                And     ds.Synonym_Name  =   p_Object_Name
                                          )
                )    
      Loop
        Create_Syn  (
                    p_Synonym_Name            =>  p_Object_Name,
                    p_Synonym_Owner           =>  x.Synonym_Owner,
                    p_Referenced_Object_Name  =>  p_Object_Name,
                    p_Referenced_Owner        =>  Sys_Context('NM3CORE','APPLICATION_OWNER')
                    );
      End Loop;
    End If;
  Else
    Raise Value_Error;
  End If;
  
Exception
  When Value_Error Then
    Raise_Application_Error(-20001,'Parameter p_Syn_Type is Invalid, should be either Null, PRIVATE or PUBLIC and p_Object_Name should not be null.');
  When No_Data_Found Then
    Raise_Application_Error(-20301,'Object "'||p_Object_Name||'" does not exist in schema '||Sys_Context('NM3CORE','APPLICATION_OWNER') 
                                    || ' or object is listed as Exempt from synonym creation. ');
End Create_Synonym_For_Object;
--
-----------------------------------------------------------------------------
--
PROCEDURE drop_synonym_for_object (p_object_name IN USER_OBJECTS.object_name%TYPE) IS
--
  l_tab_ddl   nm3type.tab_varchar32767;
--
  CURSOR get_priv_syns_to_drop
           ( cp_object_name IN VARCHAR2 )
  IS
    SELECT 'DROP SYNONYM ' || hus_username || '.' || synonym_name
      FROM hig_users, all_users, dba_synonyms
     WHERE hus_username != Sys_Context('NM3CORE','APPLICATION_OWNER')
       AND username = hus_username
       AND owner = hus_username
       AND synonym_name = cp_object_name;
--
   PRAGMA autonomous_transaction;
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'drop_synonym_for_object');
--
   IF use_pub_syn
    THEN
--
      IF check_syn_exists (c_public,p_object_name)
       THEN
         syn_exec_ddl('DROP   PUBLIC SYNONYM '||p_object_name);
      ELSE
         g_syn_exc_code := -20304;
         g_syn_exc_msg  := 'There is no PUBLIC synonym in existence for "'||p_object_name||'"';
         RAISE g_syn_exception;
      END IF;
--
   ELSE
--
--      FOR cs_rec IN cs_users
--       LOOP
--         IF check_syn_exists (cs_rec.hus_username,p_object_name)
--          THEN
--            syn_exec_ddl ('DROP   SYNONYM '||cs_rec.hus_username||'.'||p_object_name);
--         END IF;
--      END LOOP;

        -- AE 24-SEP-2008
        -- Re-write the drop of Private synonyms for performance reasons.
      --
        OPEN get_priv_syns_to_drop ( p_object_name );
        FETCH get_priv_syns_to_drop BULK COLLECT INTO l_tab_ddl;
        CLOSE get_priv_syns_to_drop;
      --
        IF l_tab_ddl.COUNT > 0
        THEN
          FOR i IN l_tab_ddl.FIRST .. l_tab_ddl.LAST
          LOOP
            EXECUTE IMMEDIATE l_tab_ddl(i);
          END LOOP;
        END IF;
      --
   END IF;

   COMMIT; --sscanlon fix 38046 26-SEP-2006
--
--   Output a debug message to say leaving procedure
   Nm_Debug.proc_end(g_package_name,'drop_synonym_for_object');
--
EXCEPTION
--
   WHEN g_syn_exception
    THEN
      COMMIT; --sscanlon fix 38046 26-SEP-2006
      RAISE_APPLICATION_ERROR(g_syn_exc_code, g_syn_exc_msg);
--
END drop_synonym_for_object;
--
--------------------------------------------------------------------------------
--
PROCEDURE drop_views_for_object (p_object_name IN USER_OBJECTS.object_name%TYPE) IS
--
   PRAGMA autonomous_transaction;
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'drop_views_for_object');
--
   FOR cs_rec IN cs_users
   LOOP
     IF does_object_exist(p_object_name  => p_object_name
                        , p_object_owner => cs_rec.hus_username
                        , p_object_type  => 'VIEW')
     THEN
       exec_ddl ('DROP VIEW '||cs_rec.hus_username||'.'||p_object_name);
     END IF;
   END LOOP;
--
   COMMIT;
--
   Nm_Debug.proc_end(g_package_name,'drop_views_for_object');
--
EXCEPTION
--
   WHEN g_syn_exception
    THEN
      COMMIT;
      RAISE_APPLICATION_ERROR(g_syn_exc_code, g_syn_exc_msg);
--
END drop_views_for_object;
--
--------------------------------------------------------------------------------
--
PROCEDURE create_all_priv_syns (p_user IN USER_USERS.username%TYPE) IS
--
   PRAGMA autonomous_transaction;
--
   l_rec_hus HIG_USERS%ROWTYPE;
--
   CURSOR all_objects (cp_user IN VARCHAR2) 
   IS
     SELECT object_name
       FROM ALL_OBJECTS ao
      WHERE owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
        AND (object_type IN ('TABLE'
                            ,'VIEW'
                            ,'FUNCTION'
                            ,'PACKAGE'
                            ,'PROCEDURE'
                            ,'SEQUENCE'
                            ,'TYPE'
                            )
            OR object_name IN ('RSE_HE_ID_SEQ','ROAD_SEG_MEMBS_PARTIAL','ROAD_SEGS_PARTIAL')
           )
      AND   object_name NOT IN ('SDE_EXCEPTIONS'
                               ,'SDE_LOGFILES'
                               ,'SDE_LOGFILE_DATA'
                               ,'SDE_LOGFILE_LID_GEN' -- Omit SDE_ tables
                               ,'INV_TMP'
                               ,'TEMP_ADMIN_GROUPS'
                               ,'TEMP_STR5080'
                               ,'TEMP_STR5084' -- Exclude tables created by HIG1832 (create user)
                               ,'TEMP_REPLACE_DEFECTS'   -- temp table created for MAI to support network edits
                               ,'TEMP_UNREPLACE_DEFECTS' -- temp table created for MAI to support network edits
                               ,'TEMP_UNSPLIT_DEFECTS'   -- temp table created for MAI to support network edits
                               ,'TEMP_UNMERGE_DEFECTS'   -- temp table created for MAI to support network edits
                               )
      AND   object_name NOT LIKE 'BIN$%'       -- AE ommit 10g recycle tables
      AND NOT EXISTS
        ( SELECT 1 FROM dba_synonyms
           WHERE owner = cp_user
             AND synonym_name = object_name )
      AND NOT EXISTS
        ( SELECT 1 FROM dba_views
           WHERE owner = cp_user
             AND view_name = object_name )
      --exempt certain objects from synonyms both public and private from being created.
      And     Not Exists  (
                          Select  Null
                          From    Nm_Syn_Exempt   nse
                          Where   ao.Object_Name      Like  nse.Nsyn_Object_Name     
                          And     ao.Object_Type      Like  nse.Nsyn_Object_Type                    
                          );
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'create_all_priv_syns');
--
   IF use_pub_syn
    THEN
      g_syn_exc_code := -20305;
      g_syn_exc_msg  := 'Application is configured to run using PUBLIC synonyms. Not creating private synonyms';
      RAISE g_syn_exception;
   END IF;
--
--   nm_debug.debug('Running for user : '||p_user);
--
   l_rec_hus := Nm3get.get_hus (pi_hus_username      => p_user
                               ,pi_not_found_sqlcode => -20302
                               );
--
   IF p_user = Sys_Context('NM3CORE','APPLICATION_OWNER')
    THEN -- do not create syns for highways owner as they own the objects!
      COMMIT; -- still commit for auton transaction
   ELSE
--      FOR cs_rec IN all_objects ( p_user )
--       LOOP
--         IF NOT check_syn_exists (p_user,cs_rec.object_name)
--          THEN
--            syn_exec_ddl('CREATE SYNONYM '||p_user||'.'||cs_rec.object_name
--                         ||' FOR '||g_application_owner||'.'||cs_rec.object_name
--                        );
--         END IF;
--      END LOOP;

     -- AE 02-OCT-2008
     -- Speed up this process by exluding objects that exist in the driving cursor
     -- Also, enclose object names in " " so that mixed case types are done.
     FOR cs_rec IN all_objects ( p_user )
     LOOP
       syn_exec_ddl('CREATE SYNONYM '||p_user||'."'||cs_rec.object_name
                 ||'" FOR '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'."'||cs_rec.object_name||'"' );
     END LOOP;
     
   END IF;

   commit; --sscanlon fix 38046 26-SEP-2006
--
   Nm_Debug.proc_end(g_package_name,'create_all_priv_syns');
--
EXCEPTION
--
   WHEN g_syn_exception
    THEN
      commit; --sscanlon fix 38046 26-SEP-2006
      RAISE_APPLICATION_ERROR(g_syn_exc_code, g_syn_exc_msg);
--
END create_all_priv_syns;
--
-----------------------------------------------------------------------------
--
PROCEDURE syn_exec_ddl (p_text LONG) IS
--
   l_name_in_use EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_name_in_use, -955);
--
   l_no_privs    EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_no_privs, -1031);
--
BEGIN
--
   EXECUTE IMMEDIATE p_text;
--
EXCEPTION
--
   WHEN l_name_in_use
    THEN
      -- Name already in use, so don't worry about it
      NULL;
   WHEN l_no_privs
    THEN
      g_syn_exc_code := -20303;
      g_syn_exc_msg  := 'User "'||USER||'" does not have permission to '||LOWER(LTRIM(SUBSTR(p_text,1,6),' '))||' this synonym';
      RAISE g_syn_exception;
--
END syn_exec_ddl;
--
-----------------------------------------------------------------------------
--
PROCEDURE exec_ddl (p_text LONG) IS
BEGIN
--
-- This is to get around....
--  [BUG:912223] <ml2_documents.showDocument?p_id=912223-p_database_id=BUG>.  This bug can cause a coredump when you use a
-- pl/sql variable as an argument to execute immediate and this variable was
-- filled using a cursor or a select into statement.
   EXECUTE IMMEDIATE p_text||CHR(0);
--
EXCEPTION
--
   WHEN OTHERS
    THEN
      g_syn_exc_code := -20306;
      g_syn_exc_msg  := SQLERRM;
      RAISE g_syn_exception;
--
END exec_ddl;
--
-----------------------------------------------------------------------------
--
FUNCTION check_syn_exists (p_owner IN ALL_SYNONYMS.owner%TYPE
                          ,p_name  IN ALL_SYNONYMS.synonym_name%TYPE
                          ) RETURN BOOLEAN IS
--
   CURSOR check_syn_exists (p_owner VARCHAR2, p_syn_name VARCHAR2) IS
   SELECT 'x'
    FROM  ALL_SYNONYMS
   WHERE  owner        = p_owner
    AND   synonym_name = p_syn_name
    AND   table_owner  = Sys_Context('NM3CORE','APPLICATION_OWNER');
    -- Restrict this so that only SYNS for objects owned by the appl. owner
    --  can be created/dropped so as to prevent possible misuse of this package
--
   l_retval BOOLEAN;
--
   l_dummy  VARCHAR2(1);
--
BEGIN
--
   OPEN  check_syn_exists (p_owner,p_name);
   FETCH check_syn_exists INTO l_dummy;
   l_retval := check_syn_exists%FOUND;
   CLOSE check_syn_exists;
--
   RETURN l_retval;
--
END check_syn_exists;
--
-----------------------------------------------------------------------------
--
PROCEDURE change_user_password(pi_user       IN VARCHAR2
                              ,pi_new_passwd IN VARCHAR2
                              ) IS
BEGIN
  --
  -- Task 0111425
  -- Create mcp password metadata
  -- Ammended to occur before the password is changed as the Form HIG1833 does not 
  -- issue a commit before exiting.
  --
  IF hig.is_product_licensed('MCP')
  THEN
    BEGIN
      EXECUTE IMMEDIATE
        'BEGIN '||
        '  nm3mcp_sde.STORE_PASSWORD(:pi_username, :pi_password); '||
        'END;'
      USING IN pi_user, IN pi_new_passwd;
    EXCEPTION
      WHEN OTHERS THEN NULL;
    END;
  END IF;
--
  exec_ddl('ALTER USER ' || pi_user || ' IDENTIFIED BY "' || pi_new_passwd||'"');
--
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE refresh_public_synonyms IS
----
--   PRAGMA autonomous_transaction;
----
--BEGIN
----
--   Nm_Debug.proc_start(g_package_name,'refresh_public_synonyms');
----
--   IF NOT use_pub_syn
--    THEN
--      g_syn_exc_code := -20307;
--      g_syn_exc_msg  := 'Application is configured to run using PRIVATE synonyms. Not creating PUBLIC synonyms';
--      RAISE g_syn_exception;
--   END IF;
----
--   FOR cs_rec IN cs_objects
--    LOOP
--      IF NOT check_syn_exists (c_public,cs_rec.object_name)
--       THEN
--         syn_exec_ddl('CREATE PUBLIC SYNONYM '||cs_rec.object_name
--                      ||' FOR '||g_application_owner||'.'||cs_rec.object_name
--                     );
--      END IF;
--   END LOOP;

--   commit; --sscanlon fix 38046 26-SEP-2006
--
   PRAGMA autonomous_transaction;
--

cursor cs_missing_synonyms is
       SELECT object_name
    FROM  ALL_OBJECTS
    WHERE  owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND  (object_type IN ('TABLE'
                         ,'VIEW'
                         ,'FUNCTION'
                         ,'PACKAGE'
                         ,'PROCEDURE'
                         ,'SEQUENCE'
                         ,'TYPE'
                         )
          OR object_name IN ('RSE_HE_ID_SEQ','ROAD_SEG_MEMBS_PARTIAL','ROAD_SEGS_PARTIAL')
         )
    AND   object_name NOT IN ('SDE_EXCEPTIONS'
                             ,'SDE_LOGFILES'
                             ,'SDE_LOGFILE_DATA'
                             ,'SDE_LOGFILE_LID_GEN' -- Omit SDE_ tables
                             ,'INV_TMP'
                             ,'TEMP_ADMIN_GROUPS'
                             ,'TEMP_STR5080'
                             ,'TEMP_STR5084' -- Exclude tables created by HIG1832 (create user)
                             ,'TEMP_REPLACE_DEFECTS'   -- temp table created for MAI to support network edits
                             ,'TEMP_UNREPLACE_DEFECTS' -- temp table created for MAI to support network edits
                             ,'TEMP_UNSPLIT_DEFECTS'   -- temp table created for MAI to support network edits
                             ,'TEMP_UNMERGE_DEFECTS'   -- temp table created for MAI to support network edits
                             )
    AND   object_name NOT LIKE 'BIN$%'
    AND   not exists ( select 1 from all_synonyms s
                       where s.synonym_name = object_name
                       and   s.owner = 'PUBLIC'
                       and   s.table_owner = Sys_Context('NM3CORE','APPLICATION_OWNER') );
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'refresh_private_synonyms');
--
   FOR cs_rec IN cs_missing_synonyms
   LOOP
       BEGIN
         syn_exec_ddl('CREATE PUBLIC SYNONYM '||cs_rec.object_name
                        ||' FOR '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||cs_rec.object_name
                       );
       EXCEPTION
         WHEN OTHERS THEN NULL;
       END;
   END LOOP;

   commit;
--
   Nm_Debug.proc_end(g_package_name,'refresh_public_synonyms');
--
EXCEPTION
--
   WHEN g_syn_exception
    THEN
      commit; --sscanlon fix 38046 26-SEP-2006
      RAISE_APPLICATION_ERROR(g_syn_exc_code, g_syn_exc_msg);
--
END refresh_public_synonyms;
--
-----------------------------------------------------------------------------
--
PROCEDURE refresh_private_synonyms IS
--
   PRAGMA autonomous_transaction;
--

cursor cs_missing_synonyms is
   SELECT hus_username, object_name
    FROM  ALL_OBJECTS, hig_users, all_users
    WHERE  owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
    and hus_is_hig_owner_flag != 'Y'
    and hus_username = username
    AND  (object_type IN ('TABLE'
                         ,'VIEW'
                         ,'FUNCTION'
                         ,'PACKAGE'
                         ,'PROCEDURE'
                         ,'SEQUENCE'
                         ,'TYPE'
                         )
          OR object_name IN ('RSE_HE_ID_SEQ','ROAD_SEG_MEMBS_PARTIAL','ROAD_SEGS_PARTIAL')
         )
    AND   object_name NOT IN ('SDE_EXCEPTIONS'
                             ,'SDE_LOGFILES'
                             ,'SDE_LOGFILE_DATA'
                             ,'SDE_LOGFILE_LID_GEN' -- Omit SDE_ tables
                             ,'INV_TMP'
                             ,'TEMP_ADMIN_GROUPS'
                             ,'TEMP_STR5080'
                             ,'TEMP_STR5084' -- Exclude tables created by HIG1832 (create user)
                             ,'TEMP_REPLACE_DEFECTS'   -- temp table created for MAI to support network edits
                             ,'TEMP_UNREPLACE_DEFECTS' -- temp table created for MAI to support network edits
                             ,'TEMP_UNSPLIT_DEFECTS'   -- temp table created for MAI to support network edits
                             ,'TEMP_UNMERGE_DEFECTS'   -- temp table created for MAI to support network edits
                             )
    AND   object_name NOT LIKE 'BIN$%'
    AND   not exists ( select 1 from all_synonyms s
                       where s.synonym_name = object_name
                       and   s.owner = hus_username
                       and   s.table_owner = Sys_Context('NM3CORE','APPLICATION_OWNER') );

BEGIN
--
   Nm_Debug.proc_start(g_package_name,'refresh_private_synonyms');
--
   FOR cs_rec IN cs_missing_synonyms
   LOOP
       BEGIN
         syn_exec_ddl('CREATE SYNONYM '||cs_rec.hus_username||'.'||cs_rec.object_name
                           ||' FOR '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||cs_rec.object_name
                     );
       EXCEPTION
         WHEN OTHERS THEN NULL;
       END;
   END LOOP;

   commit; --sscanlon fix 38046 26-SEP-2006
--
   Nm_Debug.proc_end(g_package_name,'refresh_private_synonyms');
--
EXCEPTION
--
   WHEN g_syn_exception
    THEN
      commit; --sscanlon fix 38046 26-SEP-2006
      RAISE_APPLICATION_ERROR(g_syn_exc_code, g_syn_exc_msg);
--
END refresh_private_synonyms;
--
-----------------------------------------------------------------------------
--
PROCEDURE refresh_all_synonyms IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'refresh_all_synonyms');
--
   IF use_pub_syn
    THEN
      refresh_public_synonyms;
   ELSE
      refresh_private_synonyms;
   END IF;
--
   Nm_Debug.proc_end(g_package_name,'refresh_all_synonyms');
--
END refresh_all_synonyms;
--
-----------------------------------------------------------------------------
--
PROCEDURE grant_on_object (p_grant_to     IN VARCHAR2
                          ,p_object_name  IN VARCHAR2
                          ,p_grant_select IN BOOLEAN DEFAULT TRUE
                          ,p_grant_insert IN BOOLEAN DEFAULT FALSE
                          ,p_grant_update IN BOOLEAN DEFAULT FALSE
                          ,p_grant_delete IN BOOLEAN DEFAULT FALSE
                          ,p_with_admin   IN BOOLEAN DEFAULT FALSE
                          ) IS
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'grant_on_object');
--
   grant_or_revoke (p_grant_or_rev => c_grant
                   ,p_username     => p_grant_to
                   ,p_object_name  => p_object_name
                   ,p_select       => p_grant_select
                   ,p_insert       => p_grant_insert
                   ,p_update       => p_grant_update
                   ,p_delete       => p_grant_delete
                   ,p_with_admin   => p_with_admin
                   );
--
   Nm_Debug.proc_end(g_package_name,'grant_on_object');
--
END grant_on_object;
--
-----------------------------------------------------------------------------
--
PROCEDURE revoke_from_object (p_revoke_from   IN VARCHAR2
                             ,p_object_name   IN VARCHAR2
                             ,p_revoke_select IN BOOLEAN DEFAULT TRUE
                             ,p_revoke_insert IN BOOLEAN DEFAULT FALSE
                             ,p_revoke_update IN BOOLEAN DEFAULT FALSE
                             ,p_revoke_delete IN BOOLEAN DEFAULT FALSE
                             ) IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'revoke_from_object');
--
   grant_or_revoke (p_grant_or_rev => c_grant
                   ,p_username     => p_revoke_from
                   ,p_object_name  => p_object_name
                   ,p_select       => p_revoke_select
                   ,p_insert       => p_revoke_insert
                   ,p_update       => p_revoke_update
                   ,p_delete       => p_revoke_delete
                   ,p_with_admin   => FALSE
                   );
--
   Nm_Debug.proc_end(g_package_name,'revoke_from_object');
--
END revoke_from_object;
--
-----------------------------------------------------------------------------
--
PROCEDURE grant_or_revoke (p_grant_or_rev IN VARCHAR2
                          ,p_username     IN VARCHAR2
                          ,p_object_name  IN VARCHAR2
                          ,p_select       IN BOOLEAN
                          ,p_insert       IN BOOLEAN
                          ,p_update       IN BOOLEAN
                          ,p_delete       IN BOOLEAN
                          ,p_with_admin   IN BOOLEAN
                          ) IS
--
   PRAGMA autonomous_transaction;
--
   l_grant CONSTANT BOOLEAN := (p_grant_or_rev = c_grant);
--
   l_priv VARCHAR2(50);
--
   l_ddl  VARCHAR2(32767);
--
BEGIN
--
   IF p_select
    THEN
      l_priv := 'SELECT,';
   END IF;
--
   IF p_insert
    THEN
      l_priv := l_priv||'INSERT,';
   END IF;
--
   IF p_update
    THEN
      l_priv := l_priv||'UPDATE,';
   END IF;
--
   IF p_delete
    THEN
      l_priv := l_priv||'DELETE,';
   END IF;
--
   IF l_priv IS NULL
    THEN
      g_syn_exc_code := -20308;
      g_syn_exc_msg  := 'Must be at least one of SELECT, UPDATE, DELETE, INSERT';
      RAISE g_syn_exception;
   END IF;
--
-- Trim the comma off the end
   l_priv := Nm3flx.LEFT(l_priv,LENGTH(l_priv)-1);
--
   IF l_grant
    THEN
      l_ddl := c_grant;
   ELSE
      l_ddl := c_revoke;
   END IF;
--
   l_ddl  := l_ddl||' '||l_priv||' ON '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||p_object_name;
--
   IF l_grant
    THEN
      l_ddl := l_ddl||' TO ';
   ELSE
      l_ddl := l_ddl||' FROM ';
   END IF;
--
   l_ddl  := l_ddl||p_username;
--
   IF p_with_admin
    THEN
      l_ddl := l_ddl||' WITH ADMIN OPTION';
   END IF;
--
   EXECUTE IMMEDIATE l_ddl;

   commit; --sscanlon fix 38046 26-SEP-2006
--
EXCEPTION
--
   WHEN g_syn_exception
    THEN
      commit; --sscanlon fix 38046 26-SEP-2006
      RAISE_APPLICATION_ERROR(g_syn_exc_code, g_syn_exc_msg);
--
END grant_or_revoke;
--
-----------------------------------------------------------------------------
--
FUNCTION does_object_exist_internal (p_object_name IN VARCHAR2
                                    ,p_object_type IN VARCHAR2 DEFAULT NULL
                                    ,p_owner       IN VARCHAR2 DEFAULT Sys_Context('NM3CORE','APPLICATION_OWNER')
                                    ) RETURN BOOLEAN IS
--
   CURSOR cs_obj (c_owner VARCHAR2
                 ,c_obj   VARCHAR2
                 ) IS
   SELECT object_type
    FROM  ALL_OBJECTS
   WHERE  owner       = c_owner
    AND   object_name = c_obj;
--
   l_exists BOOLEAN := FALSE;
--
BEGIN
--
   FOR cs_rec IN cs_obj (p_owner, p_object_name)
    LOOP
--
      IF  p_object_type IS NULL              -- If we dont care what type it is
       OR cs_rec.object_type = p_object_type -- or it is the correct type
       THEN
         l_exists := TRUE;
         EXIT;
      END IF;
--
   END LOOP;
--
   RETURN l_exists;
--
END does_object_exist_internal;
--
-----------------------------------------------------------------------------
--
FUNCTION does_object_exist (p_object_name IN VARCHAR2
                           ,p_object_type IN VARCHAR2 DEFAULT NULL
                           ) RETURN BOOLEAN IS
BEGIN
   RETURN does_object_exist_internal (p_object_name => p_object_name
                                     ,p_object_type => p_object_type
                                     ,p_owner       => Sys_Context('NM3CORE','APPLICATION_OWNER')
                                     );
END does_object_exist;
--
-----------------------------------------------------------------------------
--
FUNCTION does_object_exist (p_object_name  IN VARCHAR2
                           ,p_object_type  IN VARCHAR2 DEFAULT NULL
                           ,p_object_owner IN VARCHAR2
                           ) RETURN BOOLEAN IS
BEGIN
   RETURN does_object_exist_internal (p_object_name => p_object_name
                                     ,p_object_type => p_object_type
                                     ,p_owner       => p_object_owner
                                     );
END does_object_exist;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_tab_varchar IS
BEGIN
   g_tab_varchar.DELETE;
END delete_tab_varchar;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_tab_varchar(p_tab  IN OUT Nm3type.tab_varchar32767) IS
BEGIN
   p_tab.DELETE;
END delete_tab_varchar;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_tab_varchar (p_text VARCHAR2
                             ,p_nl   BOOLEAN DEFAULT TRUE
                             ) IS
BEGIN
   append_tab_varchar (p_tab  => g_tab_varchar
                      ,p_text => p_text
                      ,p_nl   => p_nl
                      );
END append_tab_varchar;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_tab_varchar (p_tab  IN OUT Nm3type.tab_varchar32767
                             ,p_text IN     VARCHAR2
                             ,p_nl   IN     BOOLEAN DEFAULT TRUE
                             ) IS
--
   l_count BINARY_INTEGER := p_tab.COUNT;
--
   l_string VARCHAR2(32767) := p_text;
--
BEGIN
--
   IF l_count = 0
    THEN
      l_count := 1;
      p_tab(l_count) := NULL;
   END IF;
--
   IF p_nl
    THEN
      append_tab_varchar (p_tab  => p_tab
                         ,p_text => CHR(10)
                         ,p_nl   => FALSE
                         );
   END IF;
--
   IF  LENGTH(p_text) + LENGTH(p_tab(l_count)) > 32767
    THEN
      l_count        := l_count + 1;
      p_tab(l_count) := p_text;
   ELSE
      p_tab(l_count) := p_tab(l_count)||p_text;
   END IF;
--
END append_tab_varchar;
--
-----------------------------------------------------------------------------
--
PROCEDURE execute_tab_varchar (p_debug       BOOLEAN DEFAULT FALSE
                              ,p_debug_level NUMBER  DEFAULT NULL
                              ) IS
BEGIN
   execute_tab_varchar (p_tab_varchar => g_tab_varchar
                       ,p_debug       => p_debug
                       ,p_debug_level => p_debug_level
                       );
END execute_tab_varchar;
--
-----------------------------------------------------------------------------
--
PROCEDURE execute_tab_varchar (p_tab_varchar Nm3type.tab_varchar32767
                              ,p_debug       BOOLEAN DEFAULT FALSE
                              ,p_debug_level NUMBER  DEFAULT NULL
                              ) IS
--
   c_count CONSTANT BINARY_INTEGER := p_tab_varchar.COUNT;
   --l_block          varchar2(32767);
--
   --l_temp  nm3type.tab_varchar32767;

   l_cursor INTEGER;
   l_dummy  INTEGER;

   l_varchar2a_tab DBMS_SQL.varchar2a;
--
BEGIN
--
   IF p_debug
    THEN
      debug_tab_varchar(p_tab_varchar => p_tab_varchar
                       ,p_level       => p_debug_level
                       );
   END IF;
--
   IF    c_count = 0
    THEN
      NULL;
   ELSIF c_count = 1
    THEN
      EXECUTE IMMEDIATE p_tab_varchar(c_count);
   ELSE
      --Replaced use of EXECUTE IMMEDIATE here with above calls to dbms_sql as EXECUTE IMMEDIATE
      --is not supported with strings over 32k.

      --Move our tab varchar into one expected by dbms_sql.parse.
      --Unfortunately these cannot simply be assigned but
      --must have their contents copied.
      FOR l_i IN 1..c_count
      LOOP
        l_varchar2a_tab(l_i) := p_tab_varchar(l_i);
      END LOOP;

      l_cursor := DBMS_SQL.OPEN_CURSOR;

      DBMS_SQL.PARSE(c             => l_cursor
                    ,STATEMENT     => l_varchar2a_tab
                    ,lb            => 1
                    ,ub            => c_count
                    ,lfflg         => FALSE
                    ,language_flag => DBMS_SQL.native);

      l_dummy := DBMS_SQL.EXECUTE(c => l_cursor);

      DBMS_SQL.CLOSE_CURSOR(c => l_cursor);
   END IF;

/*EXCEPTION
  WHEN OTHERS
  THEN
    IF DBMS_SQL.IS_OPEN(c => l_cursor)
    THEN
      DBMS_SQL.CLOSE_CURSOR(c => l_cursor);
    END IF;

    RAISE;*/

END execute_tab_varchar;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_tab_varchar (p_tab_varchar Nm3type.tab_varchar32767
                            ,p_level       NUMBER DEFAULT NULL
                            ) IS
BEGIN
--
   FOR i IN 1..p_tab_varchar.COUNT
    LOOP
      Nm_Debug.DEBUG(p_tab_varchar(i),p_level);
   END LOOP;
--
END debug_tab_varchar;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_tab_varchar (p_level NUMBER DEFAULT NULL) IS
BEGIN
--
   debug_tab_varchar (p_tab_varchar => g_tab_varchar
                     ,p_level       => p_level
                     );
--
END debug_tab_varchar;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_user (p_rec_hus            IN OUT HIG_USERS%ROWTYPE
                      ,p_password           IN     VARCHAR2
                      ,p_default_tablespace IN     VARCHAR2
                      ,p_temp_tablespace    IN     VARCHAR2
                      ,p_default_quota      IN     VARCHAR2
                      ,p_profile            IN     VARCHAR2
                      ) IS
--
--  ddl_error EXCEPTION;
--  PRAGMA    EXCEPTION_INIT( ddl_error, -20001 );
--  ddl_errm  varchar2(70);
--
  CURSOR cs_temp_tables_for_user IS
    SELECT object_name
    FROM   ALL_OBJECTS
    WHERE  owner       = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND    object_type = 'TABLE'
    AND    object_name LIKE 'TEMP%'
    AND    object_name NOT LIKE 'TEMP_PMS4440%'
    AND    object_name != 'TEMP_CONTRACTS_LOCK';
--
  CURSOR c2 IS
    SELECT object_name
    FROM   ALL_OBJECTS
    WHERE  owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND    object_type = 'VIEW'
    AND    object_name LIKE 'TEMP%';
--
  l_num NUMBER := '';
  l_count NUMBER := 0;
--
  CURSOR c3( c_obj_name VARCHAR2 ) IS
    SELECT 1
     FROM ALL_OBJECTS  -- caters for user objects and synonyms
    WHERE owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND    object_name = c_obj_name
    UNION
    SELECT 1
     FROM ALL_SYNONYMS
    WHERE owner IN ( Sys_Context('NM3CORE','APPLICATION_OWNER'), 'PUBLIC' )           -- caters for public synonyms
    AND synonym_name = c_obj_name;
--
  CURSOR c4 IS
    SELECT 1
    FROM ALL_TABLES
    WHERE owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND    table_name = 'INV_TMP'
    UNION
    SELECT 1
    FROM ALL_SYNONYMS
    WHERE synonym_name = 'INV_TMP'
      AND owner = 'PUBLIC';

  l_exists NUMBER;
--
   CURSOR cs_user_exists (c_username VARCHAR2) IS
   SELECT 1
    FROM  ALL_USERS
   WHERE  username = c_username;

   --sscanlon fix 704527 28AUG2007
   --users could create a user who's user name already exists on the same database
   --but in a different schema.  This fix will stop this from happening.
   --see other lines of code added as pasr of this fix by searching for:
   -- 'sscanlon fix 704527 28AUG2007'
   CURSOR cs_hig_user_exists (c_username VARCHAR2) IS
   SELECT 1
     FROM  HIG_USERS
    WHERE  hus_username = c_username;

   l_dummy PLS_INTEGER;
   l_dummy2 PLS_INTEGER; --sscanlon fix 704527 28AUG2007, new variable added to be used below

--
   l_user_already_exists      BOOLEAN;
   l_hig_user_already_exists  BOOLEAN;  --sscanlon fix 704527 28AUG2007 new boolean added to be used below
   l_found                    BOOLEAN;
--
   l_tab_vc Nm3type.tab_varchar32767;
--
   c_user_admin_role CONSTANT VARCHAR2(2000) := 'HIG_USER_ADMIN';
--
   l_tab_tables_to_copy Nm3type.tab_varchar30;
--
   PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      append_tab_varchar(l_tab_vc,p_text,p_nl);
   END append;
--
   PROCEDURE take_copy_of_table (p_table_name VARCHAR2) IS
   BEGIN
      IF       does_object_exist_internal (p_object_name => p_table_name
                                          ,p_object_type => 'TABLE'
                                          ,p_owner       => USER
                                          )
       AND NOT does_object_exist_internal (p_object_name => p_table_name
                                          ,p_object_type => 'TABLE'
                                          ,p_owner       => p_rec_hus.hus_username
                                          )
       THEN
          EXECUTE IMMEDIATE      'CREATE TABLE '||p_rec_hus.hus_username||'.'||p_table_name||' AS '
                      ||CHR(10)||'SELECT *'
                      ||CHR(10)||' FROM  '||p_table_name
                      ||CHR(10)||'WHERE  ROWNUM = 0';
     END IF;
   END take_copy_of_table;
/* CWS Pre 10.2 Versions of oracle are no longer used by us. There is no need for this check. 
   FUNCTION db_is_10gr2 RETURN boolean IS

     l_dummy pls_integer;

   BEGIN
     SELECT
      1
     INTO
      l_dummy
     FROM
      dual
     WHERE
       EXISTS(SELECT
                1
              FROM
                v$version
              WHERE
                UPPER(banner) LIKE '%10.2%');

      RETURN TRUE;

    EXCEPTION
      WHEN no_data_found
      THEN
        RETURN FALSE;

   END db_is_10gr2;
*/
--
BEGIN
  --
  Nm_Debug.proc_start(g_package_name,'create_user');
  --
  IF NOT(Nm3user.user_has_role(pi_user => USER
                              ,pi_role => c_user_admin_role))
   THEN
      hig.raise_ner(pi_appl => Nm3type.c_hig
                   ,pi_id   => 146);
  END IF;
  --
  IF p_rec_hus.hus_user_id IS NULL
   THEN
      p_rec_hus.hus_user_id := Nm3seq.next_hus_user_id_seq;
  END IF;
  --
  OPEN  cs_user_exists (p_rec_hus.hus_username);
  FETCH cs_user_exists
   INTO l_dummy;
  l_user_already_exists := cs_user_exists%FOUND;
  CLOSE cs_user_exists;
  --
  --sscanlon fix 704527 28AUG2007
    IF l_user_already_exists THEN
   OPEN cs_hig_user_exists (p_rec_hus.hus_username);
   FETCH cs_hig_user_exists INTO l_dummy2;
   l_hig_user_already_exists := cs_hig_user_exists%FOUND;
   CLOSE cs_hig_user_exists;
 --
   IF NOT l_hig_user_already_exists THEN
     hig.raise_ner(pi_appl => 'HIG'
     , pi_id => 445
     , pi_supplementary_info => ' Username: '||p_rec_hus.hus_username);
   END IF;
    END IF;
  --end of sscanlon fix 704527 28AUG2007
  --
  l_tab_vc.DELETE;
  IF l_user_already_exists
   THEN
      append ('ALTER',FALSE);
  ELSE
      append ('CREATE',FALSE);
      IF p_password IS NULL
       THEN
          hig.raise_ner(pi_appl               => Nm3type.c_net
                       ,pi_id                 => 282
                       ,pi_supplementary_info => 'Password');
      END IF;
  END IF;
  --
  append(' USER '||p_rec_hus.hus_username,FALSE);
  IF p_password IS NOT NULL
   THEN
      append('IDENTIFIED BY "'||p_password||'"');
  END IF;
  --
  IF p_default_tablespace IS NOT NULL
   THEN
      append('DEFAULT TABLESPACE '||p_default_tablespace);
      IF p_default_quota IS NOT NULL
       THEN
          append(' QUOTA '||p_default_quota||' ON '||p_default_tablespace);
      END IF;
  END IF;
  --
  IF p_temp_tablespace IS NOT NULL
   THEN
      append(' TEMPORARY TABLESPACE '||p_temp_tablespace);
     -- CWS 0110443 All code is run on Oracle 11.2 now. There is no need for this code
     -- CWS Note Oracle did not support quotas on temp table spaces after 10.1 
     -- that is why this code is here.
     /* IF NOT db_is_10gr2
      THEN
        append(' QUOTA UNLIMITED ON '||p_temp_tablespace);
      END IF;*/
  END IF;
  append(' QUOTA 0k on SYSTEM');
  --
  IF p_profile IS NOT NULL
   THEN
      append('PROFILE '||p_profile);
  END IF;
  --
  execute_tab_varchar(l_tab_vc);
  l_tab_vc.DELETE;
  /*
  || Oracle User Created So Insert
  || The Record Into HIG_USERS
  */
  IF nm3get.get_hus(pi_hus_user_id     => p_rec_hus.hus_user_id
                   ,pi_raise_not_found => FALSE).hus_user_id IS NULL
   THEN
      nm3ins.ins_hus(p_rec_hus);
  END IF;
  --
  OPEN  cs_temp_tables_for_user;
  FETCH cs_temp_tables_for_user
   BULK COLLECT
   INTO l_tab_tables_to_copy;
  CLOSE cs_temp_tables_for_user;
  l_tab_tables_to_copy(l_tab_tables_to_copy.COUNT+1)   := 'HHINV_LOAD_1';
  l_tab_tables_to_copy(l_tab_tables_to_copy.COUNT+1)   := 'HHINV_LOAD_2';
  l_tab_tables_to_copy(l_tab_tables_to_copy.COUNT+1)   := 'HHINV_LOAD_3';
  l_tab_tables_to_copy(l_tab_tables_to_copy.COUNT+1)   := 'SCHEDULE';
  l_tab_tables_to_copy(l_tab_tables_to_copy.COUNT+1)   := 'SCHEDULE_TEMP';
  OPEN  c3('HHINV_HOLD_1');
  FETCH c3 INTO l_dummy;
  l_found := c3%FOUND;
  CLOSE c3;
  IF l_found
   THEN
     l_tab_tables_to_copy(l_tab_tables_to_copy.COUNT+1) := 'HHINV_HOLD_1';
  END IF;
  --
  FOR i IN 1..l_tab_tables_to_copy.COUNT LOOP
    take_copy_of_table (l_tab_tables_to_copy(i));
  END LOOP;
  --
  FOR c2_rec IN c2 LOOP
    IF NOT does_object_exist_internal(p_object_name => c2_rec.object_name
                                     ,p_object_type => 'VIEW'
                                     ,p_owner       => p_rec_hus.hus_username)
     THEN
        EXECUTE IMMEDIATE 'CREATE VIEW '||p_rec_hus.hus_username||'.'||c2_rec.object_name||' AS '
               ||CHR(10)||'SELECT *'
               ||CHR(10)||' FROM  DUAL';
     END IF;
  END LOOP;
--
----
---- This table is required for mai5021 - Trapezium Rule Report
----
-- open c4;
-- fetch c4 into l_exists;
--  if c4%found then
--     proc_input := 'CREATE TABLE '||p_rec_hus.hus_username||'.INV_TMP'
--                 ||' as select * from inv_tmp where rownum < 1';
--  else
--     proc_input := 'CREATE TABLE '||p_rec_hus.hus_username||'.INV_TMP'
--                 ||' (c varchar2(1))';
--  end if;
--  close c4;
--  operation_stage := 'INV_TMP';
--  EXECUTE IMMEDIATE (proc_input);
--
  /*
  || Commit Changes So That create_all_priv_syns
  || Can See The Record In Hig_Users.
  */
  COMMIT;
  --
  IF NOT use_pub_syn
   THEN
      create_all_priv_syns (p_rec_hus.hus_username);
  END IF;
  --
  -- Create mcp metadata
  --
  IF hig.is_product_licensed('MCP')
  THEN
    BEGIN
      EXECUTE IMMEDIATE
        'BEGIN '||
        '  nm3mcp_sde.STORE_PASSWORD(:pi_username, :pi_password); '||
        'END;'
      USING IN p_rec_hus.hus_username, IN p_password;
    EXCEPTION
      WHEN OTHERS THEN NULL;
    END;
  END IF;

  --
  --
  Nm_Debug.proc_end(g_package_name,'create_user');
  --
--EXCEPTION
--   when ddl_error then
----
--   begin
--      message( 'Error during creation of '||operation_stage );
--      ddl_errm := substr( sqlerrm, 12, 70 );
--      message( ddl_errm );
--   end;
----
--   when others then null;
--
END create_user;
--
-----------------------------------------------------------------------------
--
FUNCTION get_column_details( p_column_name ALL_TAB_COLUMNS.column_name%TYPE
                           , p_table_name  ALL_TAB_COLUMNS.table_name%TYPE
                           )
RETURN ALL_TAB_COLUMNS%ROWTYPE
IS
   CURSOR cs_col_det ( c_column_name ALL_TAB_COLUMNS.column_name%TYPE
                      ,c_table_name  ALL_TAB_COLUMNS.table_name%TYPE)
   IS
   SELECT *
   FROM ALL_TAB_COLUMNS
   WHERE column_name = c_column_name
     AND table_name  = c_table_name
     AND owner       = Sys_Context('NM3CORE','APPLICATION_OWNER');

   retval ALL_TAB_COLUMNS%ROWTYPE;
BEGIN
   Nm_Debug.proc_start(g_package_name , 'get_column_details');

   OPEN cs_col_det( p_column_name
                   ,p_table_name );

   FETCH cs_col_det INTO retval;

   IF cs_col_det%NOTFOUND
      THEN
      CLOSE cs_col_det;
      Hig.raise_ner( pi_appl    => 'HIG'
                   , pi_id      => 147
                   , pi_sqlcode => -20200
                   , pi_supplementary_info => 'Column = '||p_column_name||' Table = '||p_table_name);
   ELSE
      CLOSE cs_col_det;
   END IF;

   RETURN retval;

   Nm_Debug.proc_end(g_package_name , 'get_column_details');
END get_column_details;
--
-----------------------------------------------------------------------------
--
FUNCTION get_all_columns_for_table (p_table_name ALL_TAB_COLUMNS.table_name%TYPE
                                   ) RETURN tab_atc IS
--
   CURSOR cs_cols (c_table_name  ALL_TAB_COLUMNS.table_name%TYPE
                  ,c_app_owner   ALL_TAB_COLUMNS.owner%TYPE
                  ) IS
   SELECT *
    FROM ALL_TAB_COLUMNS
   WHERE table_name  = c_table_name
     AND owner       = c_app_owner
   ORDER BY column_id;
--
   l_tab_atc tab_atc;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_all_columns_for_table');
--
   FOR cs_rec IN cs_cols (p_table_name, Sys_Context('NM3CORE','APPLICATION_OWNER'))
    LOOP
      l_tab_atc (cs_cols%rowcount) := cs_rec;
   END LOOP;
--
   Nm_Debug.proc_end(g_package_name,'get_all_columns_for_table');
--
   RETURN l_tab_atc;
--
END get_all_columns_for_table;
--
-----------------------------------------------------------------------------
--
PROCEDURE rebuild_all_sequences IS
--
   l_tab_seq Nm3type.tab_varchar30;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'rebuild_all_sequences');
--
   SELECT hsa_sequence_name
    BULK  COLLECT
    INTO  l_tab_seq
    FROM  HIG_SEQUENCE_ASSOCIATIONS
      , all_tables
   WHERE table_name = hsa_table_name
   and   owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
   GROUP BY hsa_sequence_name;
--
   FOR i IN 1..l_tab_seq.COUNT
    LOOP
      rebuild_sequence (pi_hsa_sequence_name => l_tab_seq(i));
   END LOOP;
--
   Nm_Debug.proc_end(g_package_name,'rebuild_all_sequences');
--
END rebuild_all_sequences;
--
-----------------------------------------------------------------------------
--
PROCEDURE rebuild_sequence (pi_hsa_sequence_name HIG_SEQUENCE_ASSOCIATIONS.hsa_sequence_name%TYPE) IS
--
   PRAGMA autonomous_transaction;
--
   c_nl CONSTANT VARCHAR2(1) := CHR(10);

   l_tab_table_name  Nm3type.tab_varchar30;
   l_tab_col_name    Nm3type.tab_varchar30;
   l_tab_hsa_rowid   Nm3type.tab_rowid;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'rebuild_sequence');
--
   SELECT hsa_table_name
         ,hsa_column_name
         ,ROWID
    BULK  COLLECT
    INTO  l_tab_table_name
         ,l_tab_col_name
         ,l_tab_hsa_rowid
    FROM  HIG_SEQUENCE_ASSOCIATIONS
   WHERE  hsa_sequence_name = pi_hsa_sequence_name
   FOR UPDATE OF hsa_last_rebuild_date NOWAIT;
--
   DECLARE
--
      no_hsa                  EXCEPTION;
      sequence_does_not_exist EXCEPTION;
      PRAGMA EXCEPTION_INIT (sequence_does_not_exist,-2289);
--
      l_max_value       PLS_INTEGER;
      l_current_value   PLS_INTEGER;
      l_max_val_for_tab PLS_INTEGER;
      l_difference      PLS_INTEGER;
      l_plsql           Nm3type.max_varchar2;
      l_cur             Nm3type.ref_cursor;
--
   BEGIN
   --
      IF l_tab_hsa_rowid.COUNT = 0
       THEN
         RAISE no_hsa;
      END IF;
   --
      OPEN  l_cur FOR 'SELECT '||pi_hsa_sequence_name||'.NEXTVAL FROM DUAL';
      FETCH l_cur INTO l_current_value;
      CLOSE l_cur;
   --
      l_max_value       := 0;
   --
      FOR i IN 1..l_tab_hsa_rowid.COUNT
       LOOP
   --
         DECLARE
            table_does_not_exist    EXCEPTION;
            PRAGMA EXCEPTION_INIT (table_does_not_exist,-942);
            column_does_not_exist   EXCEPTION;
            PRAGMA EXCEPTION_INIT (table_does_not_exist,-904);
         BEGIN
            l_max_val_for_tab := 0;
            OPEN  l_cur FOR 'SELECT MAX('||l_tab_col_name(i)||') FROM '||l_tab_table_name(i);
            FETCH l_cur INTO l_max_val_for_tab;
            CLOSE l_cur;
      --
            IF l_max_val_for_tab > l_max_value
             THEN
               l_max_value := l_max_val_for_tab;
            END IF;
      --
         EXCEPTION
            WHEN table_does_not_exist
             OR  column_does_not_exist
             THEN
               -- Set the rowid to null in the array so
               --  the last_rebuild_date is not updated
               l_tab_hsa_rowid(i) := NULL;
         END;
   --
      END LOOP;
   --
      IF l_max_value <> l_current_value
      THEN
        --work out difference between current and required values
        IF l_max_value > l_current_value
        THEN
          l_difference := l_max_value - l_current_value;
        ELSE
          l_difference :=  0 - l_current_value + l_max_value;
        END IF;

        --set sequence to increment by difference
        EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || pi_hsa_sequence_name || ' INCREMENT BY ' || l_difference||' MINVALUE 0';

        --select from sequence to take it to required level
        l_plsql :=            'DECLARE'
                   || c_nl || '  l_dummy number;'
                   || c_nl || '  CURSOR cs_nextval IS'
                   || c_nl || '    SELECT'
                   || c_nl || '      ' || pi_hsa_sequence_name || '.NEXTVAL'
                   || c_nl || '    FROM'
                   || c_nl || '      nm_errors;'
                   || c_nl || 'BEGIN'
                   || c_nl || '  OPEN cs_nextval;'
                   || c_nl || '    FETCH cs_nextval INTO l_dummy;'
                   || c_nl || '  CLOSE cs_nextval;'
                   || c_nl || 'END;';

        EXECUTE IMMEDIATE l_plsql;

        --set sequence increment back to 1
        EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || pi_hsa_sequence_name || ' INCREMENT BY 1 MINVALUE 0';
      END IF;
   --
      FORALL i IN 1..l_tab_hsa_rowid.COUNT
         UPDATE HIG_SEQUENCE_ASSOCIATIONS
          SET   hsa_last_rebuild_date = SYSDATE
         WHERE  ROWID                 = l_tab_hsa_rowid(i);
   EXCEPTION
      WHEN no_hsa
        OR sequence_does_not_exist
       THEN
         NULL;
   END;
--
   COMMIT;
--
   Nm_Debug.proc_end(g_package_name,'rebuild_sequence');
--
END rebuild_sequence;
--
-----------------------------------------------------------------------------
--
PROCEDURE refresh_materialized_views(pi_mask  IN VARCHAR2) IS

  v_tab_mv  Nm3type.tab_varchar80;

  CURSOR c1 IS
  SELECT object_name
  FROM   DBA_OBJECTS
  WHERE owner = USER
  AND object_type = 'MATERIALIZED VIEW'
  AND object_name LIKE pi_mask||'%';

BEGIN
--
   Nm_Debug.proc_start(g_package_name,'refresh_materialized_views');
--
  OPEN c1;
  FETCH c1 BULK COLLECT INTO v_tab_mv;
  CLOSE c1;

  FOR i IN 1..v_tab_mv.COUNT LOOP
    ---------------------------------------------------------------------------------
    -- Example
    -- BEGIN
    --    dbms_mview.REFRESH('SWR_COUNTIES','C');
    -- END;
    ---------------------------------------------------------------------------------
    EXECUTE IMMEDIATE('BEGIN dbms_mview.REFRESH('''||v_tab_mv(i)||''',''C''); END;');
  END LOOP;

--
   Nm_Debug.proc_end(g_package_name,'refresh_materialized_views');
--

END refresh_materialized_views;
--
-----------------------------------------------------------------------------
--
FUNCTION column_exists(pi_table_view_name VARCHAR2
                      ,pi_column_name     VARCHAR2) RETURN BOOLEAN IS

 l_atc_rec ALL_TAB_COLUMNS%ROWTYPE;

BEGIN

 OPEN cs_col_det (pi_column_name
                 ,pi_table_view_name);
 FETCH cs_col_det INTO l_atc_rec;
 CLOSE cs_col_det;

 IF l_atc_rec.column_name IS NOT NULL THEN
    RETURN(TRUE);
 ELSE
    RETURN(FALSE);
 END IF;

END column_exists;
--
-----------------------------------------------------------------------------
--
PROCEDURE analyse_table
            ( pi_table_name          IN USER_TABLES.table_name%TYPE )
IS
BEGIN
  analyse_table
    ( pi_table_name           => pi_table_name
    , pi_schema               => USER
    , pi_estimate_percentage  => NULL
    , pi_auto_sample_size     => FALSE );
END analyse_table;
--
-----------------------------------------------------------------------------
--
PROCEDURE analyse_table
            ( pi_table_name          IN USER_TABLES.table_name%TYPE
            , pi_schema              IN ALL_USERS.USERNAME%TYPE
            , pi_estimate_percentage IN NUMBER                       DEFAULT NULL
            , pi_auto_sample_size    IN VARCHAR2                     DEFAULT 'FALSE' )
IS
  b_auto_sample  BOOLEAN  := pi_auto_sample_size = 'TRUE';
BEGIN
  analyse_table
    ( pi_table_name           => pi_table_name
    , pi_schema               => pi_schema
    , pi_estimate_percentage  => pi_estimate_percentage
    , pi_auto_sample_size     => b_auto_sample );
EXCEPTION
  WHEN OTHERS THEN RAISE;
END analyse_table;
--
-----------------------------------------------------------------------------
--
PROCEDURE analyse_table
            ( pi_table_name          IN USER_TABLES.table_name%TYPE
            , pi_schema              IN ALL_USERS.USERNAME%TYPE
            , pi_estimate_percentage IN NUMBER                       DEFAULT NULL
            , pi_auto_sample_size    IN BOOLEAN                      DEFAULT FALSE )
IS
--
  l_percentage  NUMBER;
  l_schema      VARCHAR2(30);
  l_string      VARCHAR2(250);

  CURSOR c_sdo (c_table_name IN VARCHAR2) IS
    SELECT sdo_index_table
    FROM user_sdo_index_info
    WHERE table_name = c_table_name;
--
BEGIN
--
  IF NOT does_object_exist
          ( p_object_name => pi_table_name
          , p_object_type => 'TABLE')
  THEN
    Hig.raise_ner
       ( pi_appl               => Nm3type.c_hig
       , pi_id                 => 257
       , pi_supplementary_info => pi_schema||'.'||pi_table_name );
  END IF;
--
  IF pi_auto_sample_size
  THEN
    l_percentage := dbms_stats.auto_sample_size;
  ELSE
    l_percentage := pi_estimate_percentage;
  END IF;
--
  l_string :=
    'BEGIN '||
    '  dbms_stats.gather_table_stats'||
    '    (ownname          => '||Nm3flx.string(pi_schema)||
    '   , tabname          => '||Nm3flx.string(pi_table_name)||
    '   , estimate_percent => '||NVL(l_percentage,100)||
    '    );'||
    'END;';
--
  EXECUTE IMMEDIATE l_string;

  BEGIN

    FOR irec IN c_sdo ( pi_table_name ) LOOP

      l_string :=
        'BEGIN '||
        '  dbms_stats.gather_table_stats'||
        '    (ownname          => '||Nm3flx.string(pi_schema)||
        '   , tabname          => '||Nm3flx.string(irec.sdo_index_table)||
        '   , estimate_percent => '||100||
        '    );'||
        'END;';
    --
    --  EXECUTE IMMEDIATE l_string;
    -- AE : removed this, as it caused performance problems (!) believe it or not..!
    --      the spatial index table (MDRT/MDQT) tables must NOT be analysed.

    END LOOP;

  EXCEPTION

    WHEN OTHERS THEN NULL;
--  If sdo is not installed this will not work. Most cases the loop will not be
--  executed.
  END;

--
EXCEPTION
  WHEN OTHERS THEN RAISE;
END analyse_table;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_sub_sdo_views
            ( pi_sub_username IN VARCHAR2)
IS
---------------------------------------------
-- create user_sdo_xxx views for a given user
-- called from post-forms-commit on HIG1832
--
-- cannot be done as part of nm3user.create_user
-- due to permisssions (i.e. must be that the views of the user cannot be created
-- until the user is assigned roles)
-- so it is done on post-forms-commit instead
---------------------------------------------
  PROCEDURE create_user_sdo_maps IS

  BEGIN

    --
    -- drop priv synonym if it exists (which is why there's a when others null exception handler)
    --
    BEGIN
      EXECUTE IMMEDIATE 'DROP SYNONYM '||UPPER(pi_sub_username)||'.USER_SDO_MAPS';
    EXCEPTION
      WHEN others THEN
        Null;
    END;


    EXECUTE IMMEDIATE
      'CREATE OR REPLACE FORCE VIEW '||UPPER(pi_sub_username)||'.user_sdo_maps '||
      'AS '||'   SELECT * FROM '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.user_sdo_maps';
  EXCEPTION
    WHEN OTHERS THEN
      -- raise_application_error(-20001,'Failed to create view USER_SDO_MAPS'||chr(10)||nm3flx.parse_error_message(sqlerrm));
      -- 712315 removed above line to stop creation of users falling over in hig1832 and allow the creation of user_sdo_maps view.
      NULL;

  END create_user_sdo_maps;
  --
  --
  --
  PROCEDURE create_user_sdo_themes IS

  BEGIN

    --
    -- drop priv synonym if it exists (which is why there's a when others null exception handler)
    --
    BEGIN
      EXECUTE IMMEDIATE 'DROP SYNONYM '||UPPER(pi_sub_username)||'.USER_SDO_THEMES';
    EXCEPTION
      WHEN others THEN
        Null;
    END;


    EXECUTE IMMEDIATE
      'CREATE OR REPLACE FORCE VIEW '||UPPER(pi_sub_username)||'.user_sdo_themes '||
      'AS '||'   SELECT * FROM '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.user_sdo_themes';
  EXCEPTION
    WHEN OTHERS THEN
      -- raise_application_error(-20001,'Failed to create view USER_SDO_THEMES'||chr(10)||nm3flx.parse_error_message(sqlerrm));
      -- 712315 removed above line to stop creation of users falling over in hig1832 and allow the creation of user_sdo_themes view.
      NULL;
  END create_user_sdo_themes;
  --
  --
  --
  PROCEDURE create_user_sdo_styles IS

  BEGIN

    --
    -- drop priv synonym if it exists (which is why there's a when others null exception handler)
    --
    BEGIN
      EXECUTE IMMEDIATE 'DROP SYNONYM '||UPPER(pi_sub_username)||'.USER_SDO_STYLES';
    EXCEPTION
      WHEN others THEN
        Null;
    END;


    EXECUTE IMMEDIATE
      'CREATE OR REPLACE FORCE VIEW '||UPPER(pi_sub_username)||'.user_sdo_styles '||
      ' AS '||'  SELECT * FROM '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.user_sdo_styles';
  EXCEPTION
    WHEN OTHERS THEN
      -- raise_application_error(-20001,'Failed to create view USER_SDO_STYLES'||chr(10)||nm3flx.parse_error_message(sqlerrm));
      -- 712315 removed above line to stop creation of users falling over in hig1832 and allow the creation of user_sdo_styles view.
      NULL;
  END create_user_sdo_styles;


BEGIN

  --
  IF Nm3get.get_hus (pi_hus_username => pi_sub_username ).hus_is_hig_owner_flag != 'Y' THEN

    create_user_sdo_maps;

    create_user_sdo_themes;

    create_user_sdo_styles;
--
--RC> Task 0108742 - we do not want subordinate user views or synonyms - these can be created when a user is allocated
--    a role or a role is allocated to a theme. The code in nm3sdm was modified to create the synonyms rather than views
--    but neither are required here.
--     nm3sdm.create_msv_feature_views ( pi_username => pi_sub_username );

 END IF;

END create_sub_sdo_views;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_all_styles_view
IS
  l_view_sql       nm3type.max_varchar2;
  l_tab_usernames  nm3type.tab_varchar30;
  lf               VARCHAR2(10) := CHR(10);
BEGIN
  l_view_sql := 'CREATE OR REPLACE VIEW mdsys.ALL_SDO_STYLES'||lf||
                ' ( OWNER '       ||lf||
                ' , NAME '        ||lf||
                ' , TYPE '        ||lf||
                ' , DESCRIPTION ' ||lf||
                ' , DEFINITION '  ||lf||
                ' , IMAGE '       ||lf||
                ' , GEOMETRY) '   ||lf||
                ' AS ';
--
  SELECT owner
    BULK COLLECT INTO l_tab_usernames
    FROM dba_objects
   WHERE object_name = 'HIG_USERS'
     AND object_type = 'TABLE';
--
  FOR i IN 1..l_tab_usernames.COUNT
  LOOP
    l_view_sql := l_view_sql||lf||
                  'SELECT HUS_USERNAME OWNER '||lf||
                  '     , NAME '||lf||
                  '     , TYPE '||lf||
                  '     , DESCRIPTION '||lf||
                  '     , DEFINITION '||lf||
                  '     , IMAGE '||lf||
                  '     , GEOMETRY '||lf||
                  '  FROM MDSYS.SDO_STYLES_TABLE '||lf||
                  '     , '||l_tab_usernames(i)||'.HIG_USERS'||lf||
                  '  WHERE sdo_owner = '||nm3flx.string(l_tab_usernames(i))||lf||
                  '    AND hus_username IS NOT NULL ';
    IF i != l_tab_usernames.COUNT
    THEN
      l_view_sql := l_view_sql||lf||'UNION ALL';
    END IF;
  END LOOP;
--
--   nm_debug.debug_on;
--   nm_debug.debug(l_view_sql);
  EXECUTE IMMEDIATE l_view_sql;
--
EXCEPTION
  WHEN NO_DATA_FOUND
    THEN raise_application_error (-20001,'No users found');
  WHEN OTHERS
    THEN RAISE;
END create_all_styles_view;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_pck_referenced_col_diffs(pi_package_name    IN VARCHAR2
                                      ,pi_schema1         IN VARCHAR2
            ,pi_schema2         IN VARCHAR2) IS
  CURSOR c1 IS
  SELECT a.*
  FROM   all_tab_columns a
       , all_dependencies c
  where  c.owner  = upper(pi_schema1)
  and    table_name = referenced_name
  and    a.owner = upper(pi_schema1)
  and    name = upper(pi_package_name)
  and    type = 'PACKAGE'
  and not exists ( select 1
                   from   all_tab_columns b
                   where  b.table_name = a.table_name
                   and    b.owner = upper(pi_schema2)
                   and b.column_name  = a.column_name
                   and b.column_id    = a.column_id
                   and b.data_type    = a.data_type
            )
  order by table_name, column_name;

  tab_lines nm3type.tab_varchar32767;


  PROCEDURE append(pi_text IN  nm3type.max_varchar2) IS

  BEGIN
    tab_lines(tab_lines.COUNT+1) := pi_text;
  END append;

BEGIN

 append('TABLE.COLUMN');

 FOR recs IN c1 LOOP
   append(recs.table_name||'.'||recs.column_name);
 END LOOP;

   nm3file.write_file (filename     => pi_package_name||'_'||pi_schema1||'_'||pi_schema2||'.txt'
              ,all_lines    => tab_lines
               );


END get_pck_referenced_col_diffs;
--
-----------------------------------------------------------------------------
--
FUNCTION get_sccs_comments
          ( pi_sccs_id   IN  VARCHAR2  DEFAULT NULL
          , pi_w         IN  VARCHAR2  DEFAULT NULL
          , pi_g         IN  VARCHAR2  DEFAULT NULL
          , pi_m         IN  VARCHAR2  DEFAULT NULL
          , pi_e         IN  VARCHAR2  DEFAULT NULL
          , pi_u         IN  VARCHAR2  DEFAULT NULL
          , pi_d         IN  VARCHAR2  DEFAULT NULL
          , pi_t         IN  VARCHAR2  DEFAULT NULL
          , pi_i         IN  VARCHAR2  DEFAULT NULL
          , pi_copyright IN  VARCHAR2  DEFAULT NULL )
RETURN VARCHAR2
IS
  lf     VARCHAR2(4)   := chr(10);
  l_sccs VARCHAR2(200) := pi_sccs_id;
  l_w    VARCHAR2(100) := NVL(pi_w,'%'||'W'||'%');
  l_g    VARCHAR2(100) := NVL(pi_g,'%'||'G'||'%');
  l_m    VARCHAR2(100) := NVL(pi_m,'%'||'M'||'%');
  l_e    VARCHAR2(100) := NVL(pi_e,'%'||'E'||'%');
  l_u    VARCHAR2(100) := NVL(pi_u,'%'||'U'||'%');
  l_d    VARCHAR2(100) := NVL(pi_d,'%'||'D'||'%');
  l_t    VARCHAR2(100) := NVL(pi_t,'%'||'T'||'%');
  l_i    VARCHAR2(100) := NVL(pi_i,'%'||'I'||'%');
  l_c    VARCHAR2(100) := NVL(pi_copyright,'Copyright (c) exor corporation ltd, 2006');
BEGIN
--
  IF l_sccs IS NULL
  THEN
    l_sccs := l_w||' '||l_g;
  END IF;
  RETURN
    '-----------------------------------------------------------------------------'||lf||
    '--'||lf||
    '--   SCCS Identifiers :- '||lf||
    '-- '||lf||
    '--       sccsid           : '||l_sccs||lf||
    '--       Module Name      : '||l_m||lf||
    '--       Date into SCCS   : '||l_e||' '||l_u||lf||
    '--       Date fetched Out : '||l_d||' '||l_t||lf||
    '--       SCCS Version     : '||l_i||lf||
    '-- '||lf||
    '-----------------------------------------------------------------------------'||lf||
    '--  '||l_c||' '||lf||
    '-----------------------------------------------------------------------------';
--
END get_sccs_comments;
--
-----------------------------------------------------------------------------
--
FUNCTION sequence_nextval(pi_sequence_name IN VARCHAR2) RETURN PLS_INTEGER IS
 
l_refcur nm3type.ref_cursor;
l_retval PLS_INTEGER;

BEGIN

 OPEN l_refcur for 'select '||pi_sequence_name||'.nextval from dual';
 FETCH l_refcur INTO l_retval;
 CLOSE l_refcur;

 RETURN(l_retval); 

END sequence_nextval;
--
-----------------------------------------------------------------------------
--
END Nm3ddl;
/
