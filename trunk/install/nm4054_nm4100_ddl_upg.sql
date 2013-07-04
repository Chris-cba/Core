------------------------------------------------------------------
-- nm4054_nm4100_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4054_nm4100_ddl_upg.sql-arc   3.10   Jul 04 2013 14:16:24   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4054_nm4100_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:16:24  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:54:18  $
--       Version          : $Revision:   3.10  $
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT HIG USER Details Changes for TMA
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- HIG USER DETAIL Changes for TMA
-- 
------------------------------------------------------------------
BEGIN
--
DECLARE
       already_exists Exception;
       pragma exception_init(already_exists,-00955);
BEGIN
 EXECUTE IMMEDIATE ('CREATE TABLE hig_user_contacts_all '||
                    ' ( '||
                    ' huc_ID              NUMBER          ,     '||
                    ' huc_hus_user_id     Number Not Null ,     '||
                    ' huc_ADDRESS1       VARCHAR2(35),          '||
                    ' huc_ADDRESS2       VARCHAR2(35),          '||
                    ' huc_ADDRESS3       VARCHAR2(35),          '||
                    ' huc_ADDRESS4       VARCHAR2(35),          '||
                    ' huc_ADDRESS5       VARCHAR2(35),          '||
                    ' huc_tel_type_1     VARCHAR2(30),          '||
                    ' huc_TELEPHONE_1    VARCHAR2(30),          '||
                    ' huc_primary_tel_1  Varchar2(1),           '||
                    ' huc_tel_type_2     VARCHAR2(30),          '||
                    ' huc_TELEPHONE_2    VARCHAR2(30),          '||
                    ' huc_primary_tel_2  Varchar2(1),           '|| 
                    ' huc_tel_type_3     VARCHAR2(30),          '|| 
                    ' huc_TELEPHONE_3    VARCHAR2(30),          '||
                    ' huc_primary_tel_3  Varchar2(1),           '||
                    ' huc_tel_type_4     VARCHAR2(30),          '||
                    ' huc_TELEPHONE_4    VARCHAR2(30),          '||
                    ' huc_primary_tel_4  Varchar2(1),           '|| 
                    ' huc_POSTCODE       VARCHAR2(30),          '||
                    ' huc_DATE_CREATED   DATE  NOT NULL,        '||
                    ' huc_DATE_MODIFIED  DATE NOT NULL,         '||
                    ' huc_MODIFIED_BY    VARCHAR2(30) NOT NULL, '||
                    ' huc_CREATED_BY     VARCHAR2(30) NOT NULL  '||
                    ')');
EXCEPTION
When already_exists 
Then 
         Null;
WHEN others
THEN
         Raise;
END;

DECLARE
       already_exists Exception;
       pragma exception_init(already_exists,-02260);
BEGIN
 EXECUTE IMMEDIATE ('Alter table hig_user_contacts_all Add (Constraint huc_pk Primary key (huc_id) ) ');
EXCEPTION
When already_exists 
     Then 
         Null;
WHEN others
     THEN
        Raise;
END;


DECLARE
       already_exists Exception;
       pragma exception_init(already_exists,-02275);
BEGIN
 EXECUTE IMMEDIATE ('Alter table hig_user_contacts_all Add (Constraint huc_has_fk Foreign Key (huc_hus_user_id) References hig_users (hus_user_id) ON DELETE CASCADE) ');
EXCEPTION
When already_exists 
     Then 
         Null;
WHEN others
     THEN
        Raise;
END;

DECLARE
       already_exists Exception;
       pragma exception_init(already_exists,-00955);
BEGIN
 EXECUTE IMMEDIATE ('Create Index huc_hus_fk_ind On hig_user_contacts_all (huc_hus_user_id) ');
EXCEPTION
When already_exists 
Then 
         Null;
WHEN others
THEN
         Raise;
END;


DECLARE
       already_exists Exception;
       pragma exception_init(already_exists,-00955);
BEGIN
 EXECUTE IMMEDIATE ('Create sequence hig_hus_id_seq Increment by 1 Start With 1 Nocache ');
EXCEPTION
When already_exists 
Then 
         Null;
WHEN others
THEN
         Raise;
END;
--
ENd ;
/



------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Drop trigger
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Drop Trigger NM_INV_ITEMS_INSTEAD_IU
-- 
------------------------------------------------------------------
DECLARE
  ex_not_exists exception;
  pragma exception_init(ex_not_exists,-4080);
BEGIN
 EXECUTE IMMEDIATE('DROP TRIGGER NM_INV_ITEMS_INSTEAD_IU');
EXCEPTION
 WHEN ex_not_exists 
 THEN
    NULL;
 WHEN OTHERS 
 THEN
    RAISE;
END;
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Saved Locator Searches
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Create Saved Locator Searches objects
-- 
------------------------------------------------------------------
PROMPT Creating Table 'NM_GAZ_QUERY_ATTRIBS_SAVED'
CREATE TABLE NM_GAZ_QUERY_ATTRIBS_SAVED
 (NGQAS_NGQ_ID NUMBER(9) NOT NULL
 ,NGQAS_NGQT_SEQ_NO NUMBER(9) NOT NULL
 ,NGQAS_SEQ_NO NUMBER(9) NOT NULL
 ,NGQAS_NIT_TYPE VARCHAR2(4) NOT NULL
 ,NGQAS_ATTRIB_NAME VARCHAR2(30) NOT NULL
 ,NGQAS_OPERATOR VARCHAR2(3) DEFAULT 'AND' NOT NULL
 ,NGQAS_PRE_BRACKET VARCHAR2(5)
 ,NGQAS_POST_BRACKET VARCHAR2(5)
 ,NGQAS_CONDITION VARCHAR2(30) NOT NULL
 ,NGQAS_DATE_CREATED DATE NOT NULL
 ,NGQAS_DATE_MODIFIED DATE NOT NULL
 ,NGQAS_MODIFIED_BY VARCHAR2(30) NOT NULL
 ,NGQAS_CREATED_BY VARCHAR2(30) NOT NULL
 )
/

PROMPT Creating Table 'NM_GAZ_QUERY_SAVED'
CREATE TABLE NM_GAZ_QUERY_SAVED
 (NGQS_NGQ_ID NUMBER(9) NOT NULL
 ,NGQS_SOURCE_ID NUMBER NOT NULL
 ,NGQS_SOURCE VARCHAR2(10) NOT NULL
 ,NGQS_OPEN_OR_CLOSED VARCHAR2(1) DEFAULT 'C' NOT NULL
 ,NGQS_ITEMS_OR_AREA VARCHAR2(1) DEFAULT 'A' NOT NULL
 ,NGQS_QUERY_ALL_ITEMS VARCHAR2(1) DEFAULT 'N' NOT NULL
 ,NGQS_BEGIN_MP NUMBER
 ,NGQS_BEGIN_DATUM_NE_ID NUMBER
 ,NGQS_BEGIN_DATUM_OFFSET NUMBER
 ,NGQS_END_MP NUMBER
 ,NGQS_END_DATUM_NE_ID NUMBER
 ,NGQS_END_DATUM_OFFSET NUMBER
 ,NGQS_AMBIG_SUB_CLASS VARCHAR2(4)
 ,NGQS_DESCR VARCHAR2(2000)
 ,NGQS_QUERY_OWNER VARCHAR2(30) NOT NULL
 ,NGQS_DATE_CREATED DATE NOT NULL
 ,NGQS_DATE_MODIFIED DATE NOT NULL
 ,NGQS_MODIFIED_BY VARCHAR2(30) NOT NULL
 ,NGQS_CREATED_BY VARCHAR2(30) NOT NULL
 )
/

PROMPT Creating Table 'NM_GAZ_QUERY_TYPES_SAVED'
CREATE TABLE NM_GAZ_QUERY_TYPES_SAVED
 (NGQTS_NGQ_ID NUMBER(9) NOT NULL
 ,NGQTS_SEQ_NO NUMBER(9) NOT NULL
 ,NGQTS_ITEM_TYPE_TYPE VARCHAR2(4) NOT NULL
 ,NGQTS_ITEM_TYPE VARCHAR2(4) NOT NULL
 ,NGQTS_DATE_CREATED DATE NOT NULL
 ,NGQTS_DATE_MODIFIED DATE NOT NULL
 ,NGQTS_MODIFIED_BY VARCHAR2(30) NOT NULL
 ,NGQTS_CREATED_BY VARCHAR2(30) NOT NULL
 )
/

PROMPT Creating Table 'NM_GAZ_QUERY_VALUES_SAVED'
CREATE TABLE NM_GAZ_QUERY_VALUES_SAVED
 (NGQVS_NGQ_ID NUMBER(9) NOT NULL
 ,NGQVS_NGQT_SEQ_NO NUMBER(9) NOT NULL
 ,NGQVS_NGQA_SEQ_NO NUMBER(9) NOT NULL
 ,NGQVS_SEQUENCE NUMBER(4) NOT NULL
 ,NGQVS_VALUE VARCHAR2(4000) NOT NULL
 ,NGQVS_DATE_CREATED DATE NOT NULL
 ,NGQVS_DATE_MODIFIED DATE NOT NULL
 ,NGQVS_MODIFIED_BY VARCHAR2(30) NOT NULL
 ,NGQVS_CREATED_BY VARCHAR2(30) NOT NULL
 )
/

PROMPT Creating Primary Key on 'NM_GAZ_QUERY_ATTRIBS_SAVED'
ALTER TABLE NM_GAZ_QUERY_ATTRIBS_SAVED
 ADD (CONSTRAINT NGQAS_PK PRIMARY KEY 
  (NGQAS_NGQ_ID
  ,NGQAS_NGQT_SEQ_NO
  ,NGQAS_SEQ_NO))
/

PROMPT Creating Primary Key on 'NM_GAZ_QUERY_SAVED'
ALTER TABLE NM_GAZ_QUERY_SAVED
 ADD (CONSTRAINT NGQS_PK PRIMARY KEY 
  (NGQS_NGQ_ID))
/

PROMPT Creating Primary Key on 'NM_GAZ_QUERY_TYPES_SAVED'
ALTER TABLE NM_GAZ_QUERY_TYPES_SAVED
 ADD (CONSTRAINT NGQTS_PK PRIMARY KEY 
  (NGQTS_NGQ_ID
  ,NGQTS_SEQ_NO))
/

PROMPT Creating Primary Key on 'NM_GAZ_QUERY_VALUES_SAVED'
ALTER TABLE NM_GAZ_QUERY_VALUES_SAVED
 ADD (CONSTRAINT NGQVS_PK PRIMARY KEY 
  (NGQVS_NGQ_ID
  ,NGQVS_NGQT_SEQ_NO
  ,NGQVS_NGQA_SEQ_NO
  ,NGQVS_SEQUENCE))
/


 
PROMPT Creating Check Constraint on 'NM_GAZ_QUERY_ATTRIBS_SAVED'
ALTER TABLE NM_GAZ_QUERY_ATTRIBS_SAVED
 ADD (CONSTRAINT NGQAS_BRACKET_CHK CHECK (NGQAS_PRE_BRACKET IN ('(','((','(((','((((','(((((') 
AND NGQAS_POST_BRACKET IN (')','))',')))','))))',')))))')))
/

PROMPT Creating Check Constraint on 'NM_GAZ_QUERY_ATTRIBS_SAVED'
ALTER TABLE NM_GAZ_QUERY_ATTRIBS_SAVED
 ADD (CONSTRAINT NGQAS_OPERATOR_CHK CHECK (NGQAS_OPERATOR IN ('AND','OR')))
/
 
PROMPT Creating Check Constraint on 'NM_GAZ_QUERY_SAVED'
ALTER TABLE NM_GAZ_QUERY_SAVED
 ADD (CONSTRAINT NGQS_ENTIRE_REGION_CHK CHECK (DECODE(ngqs_query_all_items,'N'
 ,5,0)+DECODE(ngqs_source_id,-1,5,0) != 10))
/

PROMPT Creating Check Constraint on 'NM_GAZ_QUERY_SAVED'
ALTER TABLE NM_GAZ_QUERY_SAVED
 ADD (CONSTRAINT NGQS_ITEMS_OR_AREA_CHK CHECK (NGQS_ITEMS_OR_AREA IN ('I','A')))
/

PROMPT Creating Check Constraint on 'NM_GAZ_QUERY_SAVED'
ALTER TABLE NM_GAZ_QUERY_SAVED
 ADD (CONSTRAINT NGQS_OPEN_OR_CLOSED_CHK CHECK (NGQS_OPEN_OR_CLOSED IN ('O','C')))
/

PROMPT Creating Check Constraint on 'NM_GAZ_QUERY_SAVED'
ALTER TABLE NM_GAZ_QUERY_SAVED
 ADD (CONSTRAINT NGQS_QUERY_ALL_ITEMS_AREA_CHK CHECK (DECODE(NGQS_ITEMS_OR_AREA,'A',1,0)+DECODE(NGQS_QUERY_ALL_ITEMS,'Y'
 ,1,0) != 2))
/

PROMPT Creating Check Constraint on 'NM_GAZ_QUERY_SAVED'
ALTER TABLE NM_GAZ_QUERY_SAVED
 ADD (CONSTRAINT NGQS_QUERY_ALL_ITEMS_CHK CHECK (NGQS_QUERY_ALL_ITEMS IN ('Y','N')))
/
 
PROMPT Creating Check Constraint on 'NM_GAZ_QUERY_TYPES_SAVED'
ALTER TABLE NM_GAZ_QUERY_TYPES_SAVED
 ADD (CONSTRAINT NGQTS_ITEM_TYPE_TYPE_CHK CHECK (NGQTS_ITEM_TYPE_TYPE IN ('I','E')))
/
 

PROMPT Creating Foreign Key on 'NM_GAZ_QUERY_ATTRIBS_SAVED'
ALTER TABLE NM_GAZ_QUERY_ATTRIBS_SAVED ADD (CONSTRAINT
 NGQAS_NGQTS_FK FOREIGN KEY 
  (NGQAS_NGQ_ID
  ,NGQAS_NGQT_SEQ_NO) REFERENCES NM_GAZ_QUERY_TYPES_SAVED
  (NGQTS_NGQ_ID
  ,NGQTS_SEQ_NO))
/

PROMPT Creating Foreign Key on 'NM_GAZ_QUERY_TYPES_SAVED'
ALTER TABLE NM_GAZ_QUERY_TYPES_SAVED ADD (CONSTRAINT
 NGQTS_FK_NGQS FOREIGN KEY
  (NGQTS_NGQ_ID) REFERENCES NM_GAZ_QUERY_SAVED
  (NGQS_NGQ_ID) ON DELETE CASCADE)
/


PROMPT Creating Foreign Key on 'NM_GAZ_QUERY_TYPES_SAVED'
ALTER TABLE NM_GAZ_QUERY_TYPES_SAVED ADD (CONSTRAINT
 NGQTS_FK_NIT FOREIGN KEY 
  (NGQTS_ITEM_TYPE) REFERENCES NM_INV_TYPES_ALL
  (NIT_INV_TYPE) ON DELETE CASCADE)
/

PROMPT Creating Foreign Key on 'NM_GAZ_QUERY_VALUES_SAVED'
ALTER TABLE NM_GAZ_QUERY_VALUES_SAVED ADD (CONSTRAINT
 NGQVS_NGQAS_FK FOREIGN KEY 
  (NGQVS_NGQ_ID
  ,NGQVS_NGQT_SEQ_NO
  ,NGQVS_NGQA_SEQ_NO) REFERENCES NM_GAZ_QUERY_ATTRIBS_SAVED
  (NGQAS_NGQ_ID
  ,NGQAS_NGQT_SEQ_NO
  ,NGQAS_SEQ_NO) ON DELETE CASCADE)
/

PROMPT Creating Foreign Key Index on 'NGQTS_ITEM_TYPE'
CREATE INDEX NGQTS_FK_NIT_IND
ON NM_GAZ_QUERY_TYPES_SAVED (NGQTS_ITEM_TYPE)
/

PROMPT Creating Foreign Key Index on 'NGQAS_NIT_TYPE, NGQAS_ATTRIB_NAME'
CREATE INDEX NGQAS_FK_ITA_IND
ON NM_GAZ_QUERY_ATTRIBS_SAVED (NGQAS_NIT_TYPE, NGQAS_ATTRIB_NAME)
/

PROMPT Creating Index 'NGQS_QUERY_OWNER_IND'
CREATE INDEX ngqs_query_owner_ind
ON nm_gaz_query_saved(ngqs_query_owner)
/

PROMPT Create the WHO Triggers 

DECLARE
--
   TYPE tab_comments IS TABLE of VARCHAR2(250) INDEX BY BINARY_INTEGER;
   l_tab_comments tab_comments;
--
   CURSOR cs_cols (p_table_name VARCHAR2, p_type VARCHAR2) IS
   SELECT column_name
         ,DECODE(data_type
                ,'DATE','sysdate'
                ,'VARCHAR2','user'
                ,'null'
                ) new_value
     from user_tab_columns
   where  table_name = p_table_name
    AND  (column_name    like '%'||p_type||'_BY'
          or column_name like '%DATE_'||p_type)
    order by column_id;
--
   l_trigger_name VARCHAR2(30);
--
   l_sql VARCHAR2(32767);
--
BEGIN
--
--  Stick the SCCS delta comments all into an array so that we can output this
--   as a comment within the trigger itself
   l_tab_comments(1)  := '--';
   l_tab_comments(2)  := '--   SCCS Identifiers :-';
   l_tab_comments(3)  := '--';
   l_tab_comments(4)  := '--       pvcsid                     : $Header:   //vm_latest/archives/nm3/install/nm4054_nm4100_ddl_upg.sql-arc   3.10   Jul 04 2013 14:16:24   James.Wadsworth  $';
   l_tab_comments(5)  := '--       Module Name                : $Workfile:   nm4054_nm4100_ddl_upg.sql  $';
   l_tab_comments(6)  := '--       Date into PVCS             : $Date:   Jul 04 2013 14:16:24  $';
   l_tab_comments(7)  := '--       Date fetched Out           : $Modtime:   Jul 04 2013 13:54:18  $';
   l_tab_comments(8)  := '--       PVCS Version               : $Revision:   3.10  $';
   l_tab_comments(9)  := '--';
   l_tab_comments(10) := '--   table_name_WHO trigger';
   l_tab_comments(11) := '--';
   l_tab_comments(12) := '-----------------------------------------------------------------------------';
   l_tab_comments(13) := '--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved';
   l_tab_comments(14) := '-----------------------------------------------------------------------------';
   l_tab_comments(15) := '--';
--
   dbms_output.put_line('Started WHO trigger creation');
--
   FOR cs_rec IN (SELECT utc.table_name
                        ,max(length(utc.column_name)) max_col_name_length
                   FROM  user_tab_columns utc
                        ,user_objects     ut
                  where  utc.table_name  = ut.object_name
                    AND  ut.object_type  = 'TABLE'
                    AND  ut.temporary    = 'N'
                    AND (utc.column_name    like '%CREATED_BY'
                         or utc.column_name like '%MODIFIED_BY'
                         or utc.column_name like '%DATE_CREATED'
                         or utc.column_name like '%DATE_MODIFIED'
                        )
                    AND ut.object_name not like 'BIN%'        --sscanlon fix 11JAN2008, fix for 10g installs
                    AND ut.object_name like 'NM_GAZ_QUERY%SAVED'   -- CWS 02/09/09 previous value missed the NM_GAZ_QUERY_SAVED table
                  GROUP BY utc.TABLE_NAME
                  HAVING COUNT(*) = 4
                 )
    LOOP
--
      l_trigger_name := LOWER(SUBSTR(cs_rec.table_name,1,26)||'_who');
--
      l_sql := 'CREATE OR REPLACE TRIGGER '||l_trigger_name;
      l_sql := l_sql||CHR(10)||' BEFORE insert OR update';
      l_sql := l_sql||CHR(10)||' ON '||cs_rec.table_name;
      l_sql := l_sql||CHR(10)||' FOR each row';
      l_sql := l_sql||CHR(10)||'DECLARE';
      --
      FOR l_count IN 1..l_tab_comments.COUNT
       LOOP
         l_sql := l_sql||CHR(10)||l_tab_comments(l_count);
      END LOOP;
      --
      l_sql := l_sql||CHR(10)||'   l_sysdate DATE;';
      l_sql := l_sql||CHR(10)||'   l_user    VARCHAR2(30);';
      l_sql := l_sql||CHR(10)||'BEGIN';
      l_sql := l_sql||CHR(10)||'--';
      l_sql := l_sql||CHR(10)||'-- Generated '||to_char(sysdate,'HH24:MI:SS DD-MON-YYYY');
      l_sql := l_sql||CHR(10)||'--';
      l_sql := l_sql||CHR(10)||'   SELECT sysdate';
      l_sql := l_sql||CHR(10)||'         ,user';
      l_sql := l_sql||CHR(10)||'    INTO  l_sysdate';
      l_sql := l_sql||CHR(10)||'         ,l_user';
      l_sql := l_sql||CHR(10)||'    FROM  dual;';
      l_sql := l_sql||CHR(10)||'--';
      l_sql := l_sql||CHR(10)||'   IF inserting';
      l_sql := l_sql||CHR(10)||'    THEN';
--
      FOR cs_inner_rec IN cs_cols(cs_rec.table_name,'CREATED')
       LOOP
         l_sql := l_sql||CHR(10)||'      :new.'||RPAD(cs_inner_rec.column_name,cs_rec.max_col_name_length,' ')||' := l_'||cs_inner_rec.new_value||';';
      END LOOP;
--
      l_sql := l_sql||CHR(10)||'   END IF;';
      l_sql := l_sql||CHR(10)||'--';
--
      FOR cs_inner_rec IN cs_cols(cs_rec.table_name,'MODIFIED')
       LOOP
         l_sql := l_sql||CHR(10)||'   :new.'||RPAD(cs_inner_rec.column_name,cs_rec.max_col_name_length,' ')||' := l_'||cs_inner_rec.new_value||';';
      END LOOP;
--
      l_sql := l_sql||CHR(10)||'--';
--
      l_sql := l_sql||CHR(10)||'END '||l_trigger_name||';';
--
      execute immediate l_sql;
--
      l_sql := 'ALTER TRIGGER '||l_trigger_name||' COMPILE';
--
      execute immediate l_sql;
--
      dbms_output.put_line('Created trigger '||l_trigger_name);
--
   END LOOP;
--
   dbms_output.put_line('Finished WHO trigger creation');
--
END;
/

CREATE OR REPLACE FORCE VIEW V_NM_GAZ_QUERY_SAVED_ALL
(
  VNGQS_NGQS_NGQ_ID,
  VNGQS_NGQS_SOURCE_ID,
  VNGQS_NGQS_SOURCE_DESCR,
  VNGQS_NGQS_SOURCE,
  VNGQS_NGQS_OPEN_OR_CLOSED,
  VNGQS_NGQS_ITEMS_OR_AREA,
  VNGQS_NGQS_QUERY_ALL_ITEMS,
  VNGQS_NGQS_BEGIN_MP,
  VNGQS_NGQS_BEGIN_DATUM_NE_ID,
  VNGQS_NGQS_BEGIN_DATUM_OFFSET,
  VNGQS_NGQS_END_MP,
  VNGQS_NGQS_END_DATUM_NE_ID,
  VNGQS_NGQS_END_DATUM_OFFSET,
  VNGQS_NGQS_AMBIG_SUB_CLASS,
  VNGQS_NGQS_DESCR,
  VNGQS_NGQS_QUERY_OWNER,
  VNGQS_NGQS_DATE_CREATED,
  VNGQS_NGQS_DATE_MODIFIED,
  VNGQS_NGQS_MODIFIED_BY,
  VNGQS_NGQS_CREATED_BY,
  VNGQS_NGQS_ITEM_TYPE_TYPE,
  VNGQS_NGQS_ITEM_TYPE_DESCR,
  VNGQS_NGQS_ITEM_TYPE,
  VNGQS_NGQS_TYPE_DESCR
)
AS
    SELECT   
    -------------------------------------------------------------------------
    --   PVCS Identifiers :-
    --
    --       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4054_nm4100_ddl_upg.sql-arc   3.10   Jul 04 2013 14:16:24   James.Wadsworth  $
    --       Module Name      : $Workfile:   nm4054_nm4100_ddl_upg.sql  $
    --       Date into PVCS   : $Date:   Jul 04 2013 14:16:24  $
    --       Date fetched Out : $Modtime:   Jul 04 2013 13:54:18  $
    --       Version          : $Revision:   3.10  $
    --       Based on SCCS version : 
    -------------------------------------------------------------------------
             ngqs_ngq_id,
             ngqs_source_id,
             CASE
               WHEN ngqs_source = 'ROUTE' THEN nm3net.get_ne_unique (ngqs_source_id)
               WHEN ngqs_source = 'TEMP_NE' THEN 'ALL NETWORK'
             END ,
             ngqs_source,
             ngqs_open_or_closed,
             ngqs_items_or_area,
             ngqs_query_all_items,
             ngqs_begin_mp,
             ngqs_begin_datum_ne_id,
             ngqs_begin_datum_offset,
             ngqs_end_mp,
             ngqs_end_datum_ne_id,
             ngqs_end_datum_offset,
             ngqs_ambig_sub_class,
             ngqs_descr,
             ngqs_query_owner,
             ngqs_date_created,
             ngqs_date_modified,
             ngqs_modified_by,
             ngqs_created_by,
             ngqts_item_type_type,
             CASE
               WHEN ngqts_item_type_type = 'I' THEN 'Inventory'
               WHEN ngqts_item_type_type = 'E' THEN 'Network'
             END ,
             ngqts_item_type,
             CASE
               WHEN ngqts_item_type_type = 'I'
               THEN
                 (SELECT   nit_descr
                    FROM   nm_inv_types
                   WHERE   nit_inv_type = ngqts_item_type)
             END 
      FROM   nm_gaz_query_saved, nm_gaz_query_types_saved
     WHERE   ngqts_ngq_id(+) = ngqs_ngq_id;
/


CREATE OR REPLACE VIEW v_nm_gaz_query_saved
AS 
   SELECT 
    -------------------------------------------------------------------------
    --   PVCS Identifiers :-
    --
    --       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4054_nm4100_ddl_upg.sql-arc   3.10   Jul 04 2013 14:16:24   James.Wadsworth  $
    --       Module Name      : $Workfile:   nm4054_nm4100_ddl_upg.sql  $
    --       Date into PVCS   : $Date:   Jul 04 2013 14:16:24  $
    --       Date fetched Out : $Modtime:   Jul 04 2013 13:54:18  $
    --       Version          : $Revision:   3.10  $
    --       Based on SCCS version : 
    -------------------------------------------------------------------------
          * 
     FROM v_nm_gaz_query_saved_all
    WHERE ( vngqs_ngqs_query_owner = USER
         OR vngqs_ngqs_query_owner = 'PUBLIC');
/

CREATE OR REPLACE FORCE VIEW V_NM_GAZ_QUERY_ATTRIBS_SAVED
(
  vngqas_ngqa_ngq_id,
  vngqas_ngqa_operator,
  vngqas_ngqa_attrib_name,
  vngqas_ngqa_pre_bracket,
  vngqas_ngqa_condition,
  vngqvs_ngqv_value,
  vngqas_post_bracket
)
AS
    SELECT
    -------------------------------------------------------------------------
    --   PVCS Identifiers :-
    --
    --       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4054_nm4100_ddl_upg.sql-arc   3.10   Jul 04 2013 14:16:24   James.Wadsworth  $
    --       Module Name      : $Workfile:   nm4054_nm4100_ddl_upg.sql  $
    --       Date into PVCS   : $Date:   Jul 04 2013 14:16:24  $
    --       Date fetched Out : $Modtime:   Jul 04 2013 13:54:18  $
    --       Version          : $Revision:   3.10  $
    --       Based on SCCS version : 
    -------------------------------------------------------------------------
             ngqas_ngq_id       vngqas_ngqa_ngq_id,
             ngqas_operator     vngqas_ngqa_operator,
             ngqas_attrib_name  vngqas_ngqa_attrib_name,
             ngqas_pre_bracket  vngqas_ngqa_pre_bracket,
             ngqas_condition    vngqas_ngqa_condition,
             ngqvs_value        vngqvs_ngqv_value,
             ngqas_post_bracket vngqas_ngqa_post_bracket
      FROM   nm_gaz_query_attribs_saved
           , nm_gaz_query_values_saved
           , v_nm_gaz_query_saved
     WHERE   ngqas_ngq_id = ngqvs_ngq_id 
       AND   ngqas_ngqt_seq_no = ngqvs_ngqt_seq_no 
       AND   ngqas_seq_no = ngqvs_ngqa_seq_no
       AND   vngqs_ngqs_ngq_id = ngqas_ngq_id
  ORDER BY   ngqvs_ngq_id,
             ngqvs_ngqt_seq_no,
             ngqvs_ngqa_seq_no,
             ngqvs_sequence;
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Hierarchical Asset Changes
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Changes made to handle hierarchical asset work with different relationships likes AT IN AND DERIVED
-- 
------------------------------------------------------------------
Begin
   DECLARE
       non_exists Exception;
       pragma exception_init(non_exists,-02443);
   BEGIN
     EXECUTE IMMEDIATE('ALTER TABLE NM_INV_ITEM_GROUPINGS_ALL DROP CONSTRAINT IIG_UK');
   EXCEPTION
     When non_exists 
     Then 
         Null;
     WHEN others
     THEN
        Raise;
   END;

   DECLARE
       non_exists Exception;
       pragma exception_init(non_exists,-02443);
   BEGIN
     EXECUTE IMMEDIATE('ALTER TABLE NM_INV_ITEM_GROUPINGS_ALL DROP CONSTRAINT IIG_PK');
   EXCEPTION
     When non_exists 
     Then 
         Null;
     WHEN others
     THEN
        Raise;
   END;

   DECLARE
       non_exists Exception;
       pragma exception_init(non_exists,-01418);
   BEGIN
     EXECUTE IMMEDIATE('DROP INDEX  IIG_PK');
   EXCEPTION
     When non_exists 
     Then 
         Null;
     WHEN others
     THEN
        Raise;
   END;

   DECLARE
       non_exists Exception;
       pragma exception_init(non_exists,-01418);
   BEGIN
     EXECUTE IMMEDIATE('DROP INDEX  IIG_UK');
   EXCEPTION
     When non_exists 
     Then 
         Null;
     WHEN others
     THEN
        Raise;
   END;

 
   DECLARE
       already_exists Exception;
       pragma exception_init(already_exists,-02260);
   BEGIN     
     EXECUTE IMMEDIATE('ALTER TABLE NM_INV_ITEM_GROUPINGS_ALL ADD (CONSTRAINT  IIG_PK PRIMARY KEY  ( IIG_ITEM_ID,IIG_PARENT_ID,IIG_START_DATE))');
   EXCEPTION
     When already_exists 
     Then 
         Null;
     WHEN others
     THEN
        Raise;
   END;


   DECLARE
       already_exists Exception;
       pragma exception_init(already_exists,-00955);
   BEGIN
     EXECUTE IMMEDIATE('CREATE INDEX IIG_IIT_FK_TOP_ID_IND ON NM_INV_ITEM_GROUPINGS_ALL (IIG_TOP_ID)');
   EXCEPTION
     When already_exists 
     Then 
         Null;
     WHEN others
     THEN
         Raise;
   END;

   DECLARE
       non_exists Exception;
       pragma exception_init(non_exists,-02443);
   BEGIN
     EXECUTE IMMEDIATE('ALTER TABLE nm_load_batch_status DROP CONSTRAINT nlbs_nlb_fk');
   EXCEPTION
     When non_exists 
     Then 
         Null;
     WHEN others
     THEN
        Raise;
   END;

   DECLARE
       non_exists Exception;
       pragma exception_init(non_exists,-02443);
   BEGIN
     EXECUTE IMMEDIATE('ALTER TABLE nm_load_batches DROP CONSTRAINT nlb_pk');
   EXCEPTION
     When non_exists 
     Then 
         Null;
     WHEN others
     THEN
        Raise;
   END;

   DECLARE
       non_exists Exception;
       pragma exception_init(non_exists,-01418);
   BEGIN
     EXECUTE IMMEDIATE('DROP INDEX nlb_pk');
   EXCEPTION
     When non_exists 
     Then 
         Null;
     WHEN others
     THEN
        Raise;
   END;

   DECLARE
       already_exists Exception;
       pragma exception_init(already_exists,-02260);
   BEGIN
     EXECUTE IMMEDIATE('ALTER TABLE nm_load_batches ADD ( CONSTRAINT  nlb_pk  primary key  (nlb_batch_no,nlb_filename))');
   EXCEPTION
     When already_exists 
     Then 
         Null;
     WHEN others
     THEN
        Raise;
   END;
End ;
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Drop NM_THEMES_ALL_405 table
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Drop NM_THEMES_ALL_405 - Created in a previous upgrade, needs to be dropped.
-- 
------------------------------------------------------------------
DECLARE
  ex_not_exists exception;
  pragma exception_init(ex_not_exists,-942);
BEGIN
  EXECUTE IMMEDIATE('DROP TABLE NM_THEMES_405');
EXCEPTION
  WHEN ex_not_exists THEN
     NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Increase HOV_VALUE to 2000
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Increase HOV_VALUE to 2000 characters.
-- 
------------------------------------------------------------------
ALTER TABLE hig_option_values MODIFY hov_value VARCHAR2(2000)
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Add NM_CARDINALITY to NM_ROUTE_CONECTIVITY_TMP
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Add new column NM_CARDINALITY to NM_ROUTE_CONNECTIVITY
-- 
------------------------------------------------------------------
ALTER TABLE NM_ROUTE_CONNECTIVITY_TMP ADD NM_CARDINALITY NUMBER(38)
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT NM_ELEMENT_HISTORY
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Replace Unique index on NM_ELEMENT_HISTORY with a non-unique one to handle opereration on the same date.
-- 
------------------------------------------------------------------
DECLARE
  ex_not_exist  EXCEPTION;
  PRAGMA EXCEPTION_INIT(ex_not_exist,-1418);
BEGIN
  BEGIN
    EXECUTE IMMEDIATE 'DROP INDEX NEH_NE_ID_OLD_NEW_IND';
  EXCEPTION
    WHEN ex_not_exist THEN NULL;
  END;
  EXECUTE IMMEDIATE 'CREATE INDEX NEH_NE_ID_OLD_NEW_IND '||
                    ' ON NM_ELEMENT_HISTORY (NEH_NE_ID_OLD,NEH_NE_ID_NEW)';
END;
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Disabled PK on NM_MRG_QUERY_RESULTS_TEMP2
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Disabled PK on NM_MRG_QUERY_RESULTS_TEMP2 - Created for consistency
-- 
------------------------------------------------------------------
Declare
  nonex_constr Exception;
  Pragma Exception_Init( nonex_constr, -2443);
Begin
  Execute Immediate('ALTER TABLE NM_MRG_QUERY_RESULTS_TEMP2 DROP CONSTRAINT NMQRT2_PK');
Exception When nonex_constr
          Then
            Null;
End;
/

ALTER TABLE NM_MRG_QUERY_RESULTS_TEMP2
 ADD (CONSTRAINT NMQRT2_PK PRIMARY KEY 
  (NE_ID)
  DISABLE)
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Disabled PK on REPORT_PARAMS
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Disabled PK on REPORT_PARAMS - Created for consistency
-- 
------------------------------------------------------------------
Declare
  nonex_constr Exception;
  Pragma Exception_Init( nonex_constr, -2443);
Begin
  Execute Immediate('ALTER TABLE REPORT_PARAMS DROP CONSTRAINT RPA_PK');
Exception When nonex_constr
          Then
            Null;
End;
/

ALTER TABLE REPORT_PARAMS
 ADD (CONSTRAINT RPA_PK PRIMARY KEY 
  (REP_SESSIONID)
  DISABLE)
/

Declare
  no_index_ex Exception;
  Pragma Exception_Init( no_index_ex, -1418);
Begin
  Execute Immediate('DROP INDEX RPA_PK_IDX');
Exception When no_index_ex
          Then
            Null;
End;
/

CREATE INDEX RPA_PK_IDX ON REPORT_PARAMS
 (REP_SESSIONID)
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Recreate Check Constraints for HIGOWNER generated tables
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Recreate check constraints created as AVCON with named constraints from Designer
-- 
------------------------------------------------------------------
BEGIN
  FOR i IN 
    ( SELECT * FROM user_constraints
       WHERE constraint_name LIKE 'AVCON%' )
  LOOP
    EXECUTE IMMEDIATE 'ALTER TABLE '||i.table_name||' DROP CONSTRAINT '||i.constraint_name;
  END LOOP;
END;
/

PROMPT Creating Check Constraint on 'NM_USER_AUS_ALL'
ALTER TABLE NM_USER_AUS_ALL
 ADD (CONSTRAINT NUA_MODE_CHK CHECK (nua_mode IN ( 'NORMAL' , 'READONLY' )))
/

PROMPT Creating Check Constraint on 'HIG_USERS'
ALTER TABLE HIG_USERS
 ADD (CONSTRAINT HUS_IS_HIG_OWNER_FLAG_CHK CHECK (HUS_IS_HIG_OWNER_FLAG IN ( 'Y' , 'N' )))
/

PROMPT Creating Check Constraint on 'HIG_USERS'
ALTER TABLE HIG_USERS
 ADD (CONSTRAINT HUS_UNRESTRICTED_CHK CHECK (HUS_UNRESTRICTED IN ( 'Y' , 'N' )))
/

PROMPT Creating Check Constraint on 'NM_ADMIN_GROUPS'
ALTER TABLE NM_ADMIN_GROUPS
 ADD (CONSTRAINT NAG_DIRECT_LINK_CHK CHECK (NAG_DIRECT_LINK IN ('Y', 'N')))
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New Column ITA_INSPECTABLE
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- New column ITA_INSPECTABLE
-- 
------------------------------------------------------------------
ALTER TABLE nm_inv_type_attribs_all DISABLE ALL TRIGGERS
/

ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL 
ADD ITA_INSPECTABLE VARCHAR2(1) DEFAULT 'Y' NOT NULL 
/

ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL 
ADD (CONSTRAINT ITA_INSP_YN_CHK
     CHECK (ITA_INSPECTABLE IN ('Y','N'))
    )
/

ALTER TABLE nm_inv_type_attribs_all ENABLE ALL TRIGGERS
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Drop GDO PK
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Consolidate changes to GDO table
-- 
------------------------------------------------------------------
DECLARE
  non_exists Exception;
  pragma exception_init(non_exists,-02443);
BEGIN
  EXECUTE IMMEDIATE 
    'ALTER TABLE GIS_DATA_OBJECTS DROP CONSTRAINT GDOBJ_PK';
EXCEPTION
  WHEN NON_EXISTS THEN NULL;
  WHEN OTHERS THEN RAISE;
END;
/

DECLARE
  non_exists Exception;
  pragma exception_init(non_exists,-955);
BEGIN
  EXECUTE IMMEDIATE 
    'CREATE INDEX GDO_IDX ON GIS_DATA_OBJECTS '
     ||' (GDO_SESSION_ID '
     ||' ,GDO_PK_ID)';
EXCEPTION
  WHEN NON_EXISTS THEN NULL;
  WHEN OTHERS THEN RAISE;
END;
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Drop GDR
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Drop redundant table GIS_DATA_RESTRICTIONS and NM3SDO_GDR package
-- 
------------------------------------------------------------------
-- Drop GIS_DATA_RESTRICTIONS table

DECLARE
  not_exists EXCEPTION;
  PRAGMA EXCEPTION_INIT(not_exists,-00942);
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE GIS_DATA_RESTRICTIONS';
EXCEPTION
  WHEN NOT_EXISTS THEN NULL;
END;
/


-- Drop package nm3sdo_gdr

DECLARE
  not_exists EXCEPTION;
  PRAGMA EXCEPTION_INIT(not_exists,-04043);
BEGIN
  EXECUTE IMMEDIATE 'DROP PACKAGE NM3SDO_GDR';
EXCEPTION
  WHEN NOT_EXISTS THEN NULL;
END;
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Drop NM_SPECIAL_CHARS
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Drop redundant table NM_SPECIAL_CHARS
-- 
------------------------------------------------------------------
-- Drop NM_SPECIAL_CHARS table

DECLARE
  not_exists EXCEPTION;
  PRAGMA EXCEPTION_INIT(not_exists,-00942);
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE NM_SPECIAL_CHARS';
EXCEPTION
  WHEN NOT_EXISTS THEN NULL;
END;
/


------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

