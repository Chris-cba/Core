--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/sql/tidy_user.sql-arc   3.1   Jul 04 2013 09:32:52   James.Wadsworth  $
--       Module Name      : $Workfile:   tidy_user.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:32:52  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:30:36  $
--       PVCS Version     : $Revision:   3.1  $
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
spool tidy_up.txt
alter table hig_user_roles
disable  constraint HUR_HUS_FK
/

alter table hig_user_roles disable all triggers
/

update hig_user_roles
set hur_username=user
where exists (Select 'x'
              from   hig_users
              where  hus_username = hur_username
              and    HUS_IS_HIG_OWNER_FLAG = 'Y')
/

update hig_users
set hus_username = user
where HUS_IS_HIG_OWNER_FLAG = 'Y'
/

commit;


alter table hig_user_roles
enable constraint HUR_HUS_FK
/

alter table hig_user_roles enable all triggers
/


--
SET SERVEROUTPUT ON SIZE 100000
--
DECLARE
--
   CURSOR cs_policies_to_drop (c_owner VARCHAR2) IS
   SELECT object_owner
         ,object_name
         ,policy_name
    FROM  all_policies
   WHERE  object_owner = c_owner
    AND   substr(object_name,1,7) IN ('NM_INV_','NM_MRG_');
   --
BEGIN
--
   FOR cs_rec IN cs_policies_to_drop (user)
    LOOP
      BEGIN
         dbms_rls.drop_policy (object_schema => cs_rec.object_owner
                              ,object_name   => cs_rec.object_name
                              ,policy_name   => cs_rec.policy_name
                              );
         dbms_output.put_line(cs_policies_to_drop%ROWCOUNT||'. '||cs_rec.policy_name||' on '||cs_rec.object_owner||'.'||cs_rec.object_name||' dropped');
      EXCEPTION
         WHEN others
          THEN
            dbms_output.put_line(cs_policies_to_drop%ROWCOUNT||'. ### '||cs_rec.policy_name||' on '||cs_rec.object_name||' ERROR');
            dbms_output.put_line(SUBSTR(SQLERRM,1,255));
      END;
      dbms_output.put_line('--');
   END LOOP;
--
END;
/

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
   c_application_owner   CONSTANT VARCHAR2(30) := user;
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
              ,p_statement_types => 'UPDATE'
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
   add_policy (p_policy_name     => 'MRG_SECTION_INV_VALUES_POLICY'
              ,p_object_name     => 'NM_MRG_SECTION_INV_VALUES_ALL'
              ,p_policy_function => 'nm3mrg_security.mrg_nsv_predicate'
              ,p_statement_types => 'SELECT,INSERT,UPDATE,DELETE'
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

BEGIN
  -- Create the context in a bit of dynamic sql to allow the context
  -- to be created with the username as part of the context name
  -- This should only be run as the highways owner
  EXECUTE IMMEDIATE 'DROP CONTEXT nm3_'||SUBSTR(USER,1,26);
  EXECUTE IMMEDIATE 'CREATE CONTEXT nm3_'||SUBSTR(USER,1,26)||' USING nm3context';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/


PROMPT Creating Table 'NM_UPLOAD_FILES'
CREATE TABLE NM_UPLOAD_FILES
 (NAME VARCHAR2(256) NOT NULL
 ,MIME_TYPE VARCHAR2(128)
 ,DOC_SIZE NUMBER
 ,DAD_CHARSET VARCHAR2(128)
 ,LAST_UPDATED DATE
 ,CONTENT_TYPE VARCHAR2(128)
 ,BLOB_CONTENT BLOB
 ,NUF_NUFG_TABLE_NAME VARCHAR2(30)
 ,NUF_NUFGC_COLUMN_VAL_1 VARCHAR2(80)
 ,NUF_NUFGC_COLUMN_VAL_2 VARCHAR2(80)
 ,NUF_NUFGC_COLUMN_VAL_3 VARCHAR2(80)
 ,NUF_NUFGC_COLUMN_VAL_4 VARCHAR2(80)
 ,NUF_NUFGC_COLUMN_VAL_5 VARCHAR2(80)
 )
/

PROMPT Creating Primary Key on 'NM_UPLOAD_FILES'
ALTER TABLE NM_UPLOAD_FILES
 ADD CONSTRAINT NUF_PK PRIMARY KEY 
  (NAME)
/

PROMPT Creating Foreign Keys on 'NM_UPLOAD_FILES'
ALTER TABLE NM_UPLOAD_FILES ADD CONSTRAINT
 NUF_NUFG_FK FOREIGN KEY 
  (NUF_NUFG_TABLE_NAME) REFERENCES NM_UPLOAD_FILE_GATEWAYS
  (NUFG_TABLE_NAME)
/

PROMPT Creating Index 'NUF_NUFG_FK_IND'
CREATE INDEX NUF_NUFG_FK_IND ON NM_UPLOAD_FILES
 (NUF_NUFG_TABLE_NAME)
/

PROMPT Creating Table 'NM_XML_LOAD_ERRORS'
CREATE TABLE NM_XML_LOAD_ERRORS
 (NXL_BATCH_ID NUMBER(9) NOT NULL
 ,NXL_RECORD_ID NUMBER NOT NULL
 ,NXL_ERROR VARCHAR2(4000) NOT NULL
 ,NXL_DATA CLOB
 ,NXL_PROCESSED VARCHAR2(1)
 )
/

PROMPT Creating Primary Key on 'NM_XML_LOAD_ERRORS'
ALTER TABLE NM_XML_LOAD_ERRORS
 ADD CONSTRAINT NM_XML_LOAD_ERRORS_PK PRIMARY KEY 
  (NXL_BATCH_ID
  ,NXL_RECORD_ID)
/

PROMPT Creating Foreign Keys on 'NM_XML_LOAD_ERRORS'
ALTER TABLE NM_XML_LOAD_ERRORS ADD CONSTRAINT
 NXL_NXB_FK FOREIGN KEY 
  (NXL_BATCH_ID) REFERENCES NM_XML_LOAD_BATCHES
  (NXB_BATCH_ID) ON DELETE CASCADE
/

PROMPT Creating Table 'NM_XML_FILES'
CREATE TABLE NM_XML_FILES
 (NXF_FILE_TYPE VARCHAR2(30) NOT NULL
 ,NXF_TYPE VARCHAR2(4) NOT NULL
 ,NXF_DESCR VARCHAR2(80) NOT NULL
 ,NXF_DOC CLOB
 ,NXF_DATE_CREATED DATE NOT NULL
 ,NXF_DATE_MODIFIED DATE NOT NULL
 ,NXF_MODIFIED_BY VARCHAR2(30) NOT NULL
 ,NXF_CREATED_BY VARCHAR2(30) NOT NULL
 )
/

PROMPT Creating Primary Key on 'NM_XML_FILES'
ALTER TABLE NM_XML_FILES
 ADD CONSTRAINT NM_XML_FILES_PK PRIMARY KEY 
  (NXF_FILE_TYPE
  ,NXF_TYPE)
/

PROMPT Creating Table 'NM_MAPCAP_LOAD_ERR'
CREATE TABLE NM_MAPCAP_LOAD_ERR
 (ML_BATCH_ID NUMBER NOT NULL
 ,ML_LOAD_DATE DATE NOT NULL
 ,ML_INS_STR CLOB NOT NULL
 ,ML_ERROR VARCHAR2(100) NOT NULL
 ,ML_PROCESSED VARCHAR2(1) DEFAULT 'N'
 )
/

CREATE TABLE HIG_USER_HISTORY
 (HUH_USER_ID NUMBER(9) NOT NULL
 ,HUH_USER_HISTORY USER_HIST_ITEM
 )
 NOCACHE
/



CREATE TABLE MAI_GMIS_LOAD_BATCHES
 (GLB_LOAD_BATCH NUMBER(9) NOT NULL
 ,GLB_LINE_NUMBER NUMBER(8)
 ,GLB_LOAD_FILE CLOB
 ,GLB_LOAD_ERRORS VARCHAR2(1) DEFAULT 'Y'
 ,GLB_DATE_CREATED DATE
 ,GLB_DATE_MODIFIED DATE
 ,GLB_CREATED_BY VARCHAR2(30)
 ,GLB_MODIFIED_BY VARCHAR2(30)
 ,GLB_ERROR_TEXT VARCHAR2(200)
 ,GLB_ERROR_DATA VARCHAR2(500)
 )
 NOCACHE
/


-- Create and grant the roles
--
BEGIN
--
  FOR i IN
    (SELECT 'create role '||hro_role sql_string 
       FROM hig_roles
      WHERE NOT EXISTS
         (SELECT 1 FROM dba_roles
           WHERE ROLE = hro_role))
  LOOP
    dbms_output.put_line (i.sql_string);
    EXECUTE IMMEDIATE i.sql_string;
  END LOOP;
--
  FOR i IN
    (SELECT 'grant '||hur_role||' to '||user sql_string
       FROM hig_user_roles
      WHERE hur_username = user)
  LOOP
    dbms_output.put_line (i.sql_string);
    EXECUTE IMMEDIATE i.sql_string;
  END LOOP;
--
END;
/

-- Create view spatial metadata that'll be missing
DECLARE
   CURSOR tabs
   IS
      SELECT table_name, column_name, diminfo, srid
        FROM user_sdo_geom_metadata
       WHERE table_name LIKE 'NM_NIT%'
          OR table_name LIKE 'NM_NAT%'
          OR table_name LIKE 'NM_NLT%'
          OR table_name LIKE 'NM_ONA%';
BEGIN
   FOR i IN tabs
   LOOP
     BEGIN
       INSERT INTO user_sdo_geom_metadata
                   (table_name, column_name, diminfo, srid)
            VALUES ('V_' || i.table_name, i.column_name, i.diminfo, i.srid);
     EXCEPTION
       WHEN OTHERS THEN NULL;
     END;
   --
     BEGIN
       INSERT INTO user_sdo_geom_metadata
                   (table_name, column_name, diminfo,srid)
            VALUES ('V_' || i.table_name || '_DT', i.column_name, i.diminfo,i.srid);
     EXCEPTION
       WHEN OTHERS THEN NULL;
     END;
   END LOOP;
END;
/

spool off
@compile_schema
@compile_all

