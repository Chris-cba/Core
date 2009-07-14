------------------------------------------------------------------
-- nm4054_nm4100_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4054_nm4100_ddl_upg.sql-arc   3.0   Jul 14 2009 10:27:18   aedwards  $
--       Module Name      : $Workfile:   nm4054_nm4100_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Jul 14 2009 10:27:18  $
--       Date fetched Out : $Modtime:   Jul 14 2009 09:32:42  $
--       Version          : $Revision:   3.0  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009

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
  WHEN others THEN 
   Null;
END;
/

BEGIN
 EXECUTE IMMEDIATE ('Alter table hig_user_contacts_all Add (Constraint huc_pk Primary key (huc_id) ) ');
EXCEPTION
  WHEN others THEN 
   Null;
END;
/

BEGIN
 EXECUTE IMMEDIATE ('Alter table hig_user_contacts_all Add (Constraint huc_has_fk Foreign Key (huc_hus_user_id) References hig_users (hus_user_id) ON DELETE CASCADE) ');
EXCEPTION
  WHEN others THEN 
   Null;
END;
/

BEGIN
 EXECUTE IMMEDIATE ('Create Index huc_hus_fk_ind On hig_user_contacts_all (huc_hus_user_id) ');
EXCEPTION
  WHEN others THEN 
   Null;
END;
/

BEGIN
 EXECUTE IMMEDIATE ('Create sequence hig_hus_id_seq Increment by 1 Start With 1 Nocache ');
EXCEPTION
  WHEN others THEN 
   Null;
END;
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Drop trigger
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- **** COMMENTS TO BE ADDED BY ADRIAN EDWARDS ****
-- 
------------------------------------------------------------------
PROMPT Drop Trigger NM_INV_ITEMS_INSTEAD_IU

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
PROMPT Drop Unique Constraint IIG_UK
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED PROBLEM MANAGER LOG#
-- 713421  New Mexico Department of Transportation
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Drop unique constraint IIG_UK
-- 
------------------------------------------------------------------
PROMPT Drop CONSTRAINT IIG_UK

DECLARE
  ex_not_exists exception;
  pragma exception_init(ex_not_exists,-4080);
BEGIN
 EXECUTE IMMEDIATE('ALTER TABLE NM_INV_ITEM_GROUPINGS_ALL DROP CONSTRAINT IIG_UK');
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
PROMPT Bulk Attribute Update
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Objects required for nietwork bulk attrib update
-- 
------------------------------------------------------------------
CREATE OR REPLACE TYPE nm_ne_id_type AS OBJECT(ne_id NUMBER)
/
 
CREATE OR REPLACE TYPE nm_ne_id_array IS TABLE OF nm_ne_id_type 
/


CREATE OR REPLACE FORCE VIEW nm_elements_view_vw (
nev_ne_id,
nev_ne_unique ,
nev_ne_descr,
nev_ne_type,
nev_ne_nt_type ,
nev_admin_unit_descr ,
nev_ne_start_date ,
nev_ne_gty_group_type,
nev_ne_admin_unit
)
AS
SELECT 
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4054_nm4100_ddl_upg.sql-arc   3.0   Jul 14 2009 10:27:18   aedwards  $
--       Module Name      : $Workfile:   nm4054_nm4100_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Jul 14 2009 10:27:18  $
--       Date fetched Out : $Modtime:   Jul 14 2009 09:32:42  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
ne_id
      ,ne_unique 
      ,ne_descr
      ,ne_type
      ,ne_nt_type 
      ,nau_unit_code ||' - '||nau_name
      ,ne_start_date 
      ,ne_gty_group_type
      ,ne_admin_unit
FROM   nm_elements ne
      ,nm_admin_units nau
WHERE  ne.ne_admin_unit = nau.nau_admin_unit
/


CREATE OR REPLACE FORCE VIEW nm_attrib_view_vw (
nav_disp_ord,
nav_nt_type ,
nav_inv_type,
nav_col_name,
nav_col_type ,
nav_col_length ,
nav_col_mandatory ,
nav_col_domain,
nav_col_updatable,
nav_col_prompt,
nav_col_format,
nav_col_seq_no,
nav_gty_type ,
nav_parent_type_inc,
nav_child_type_inc,
nav_child_col,
nav_parent_col
)
AS
SELECT
--
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4054_nm4100_ddl_upg.sql-arc   3.0   Jul 14 2009 10:27:18   aedwards  $
--       Module Name      : $Workfile:   nm4054_nm4100_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Jul 14 2009 10:27:18  $
--       Date fetched Out : $Modtime:   Jul 14 2009 09:32:42  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
-- 
1 disp_ord,
       ntc_nt_type ,
       Null ,
       ntc_column_name ,
       ntc_column_type ,
       ntc_str_length ,
       ntc_mandatory ,
       ntc_domain,
       nm3_bulk_attrib_upd.check_col_upd(ntc_column_name,ntc_nt_type),
       ntc_prompt,
       ntc_format,
       ntc_seq_no,
       Null ,
       nm3_bulk_attrib_upd.parent_inclusion_type(ntc_column_name,ntc_nt_type) parent_type_inc,
       nm3_bulk_attrib_upd.child_inclusion_type(ntc_column_name,ntc_nt_type)  child_type_inc,
       (SELECT nti_child_column FROM nm_type_inclusion WHERE  nti_nw_parent_type = ntc_nt_type 
                                                     ) child_col,
       (SELECT nti_parent_column FROM nm_type_inclusion WHERE  nti_nw_child_type = ntc_nt_type AND nti_child_column = ntc_column_name 
                                                     ) parent_col
FROM   nm_type_columns ntc
union
select 2 disp_ord,
       ita_inv_type,
       nad_nt_type ,
       ita_attrib_name,
       ita_format,
       ita_fld_length,
       ita_mandatory_yn,
       ita_id_domain,'Y' ,
       ita_scrn_text,
       ita_format,
       ita_disp_seq_no ,
       nad_gty_type   ,
       Null ,
       Null,
       Null,
       Null 
FROM   nm_inv_type_attribs ita,nm_nw_ad_types nad
WHERE  ita.ita_inv_type =  nad.nad_inv_type
AND    nad_primary_ad   = 'Y'
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Saved Locator Searches
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- **** COMMENTS TO BE ADDED BY ADRIAN EDWARDS ****
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
 NGQAS_ITA_FK FOREIGN KEY 
  (NGQAS_NIT_TYPE
  ,NGQAS_ATTRIB_NAME) REFERENCES NM_INV_TYPE_ATTRIBS_ALL
  (ITA_INV_TYPE
  ,ITA_VIEW_COL_NAME) ON DELETE CASCADE)
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
 NGQTS_NGQS_FK FOREIGN KEY 
  (NGQTS_NGQ_ID) REFERENCES NM_GAZ_QUERY_SAVED
  (NGQS_NGQ_ID) ON DELETE CASCADE)
/

PROMPT Creating Foreign Key on 'NM_GAZ_QUERY_TYPES_SAVED'
ALTER TABLE NM_GAZ_QUERY_TYPES_SAVED ADD (CONSTRAINT
 NGQTS_NIT_FK FOREIGN KEY 
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
   l_tab_comments(4)  := '--       pvcsid                     : $Header:   //vm_latest/archives/nm3/install/nm4054_nm4100_ddl_upg.sql-arc   3.0   Jul 14 2009 10:27:18   aedwards  $';
   l_tab_comments(5)  := '--       Module Name                : $Workfile:   nm4054_nm4100_ddl_upg.sql  $';
   l_tab_comments(6)  := '--       Date into PVCS             : $Date:   Jul 14 2009 10:27:18  $';
   l_tab_comments(7)  := '--       Date fetched Out           : $Modtime:   Jul 14 2009 09:32:42  $';
   l_tab_comments(8)  := '--       PVCS Version               : $Revision:   3.0  $';
   l_tab_comments(9)  := '--';
   l_tab_comments(10) := '--   table_name_WHO trigger';
   l_tab_comments(11) := '--';
   l_tab_comments(12) := '-----------------------------------------------------------------------------';
   l_tab_comments(13) := '--    Copyright (c) exor corporation ltd, 2007';
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
                    AND ut.object_name like 'NM_GAZ_QUERY_%_SAVED'
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
    --       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4054_nm4100_ddl_upg.sql-arc   3.0   Jul 14 2009 10:27:18   aedwards  $
    --       Module Name      : $Workfile:   nm4054_nm4100_ddl_upg.sql  $
    --       Date into PVCS   : $Date:   Jul 14 2009 10:27:18  $
    --       Date fetched Out : $Modtime:   Jul 14 2009 09:32:42  $
    --       Version          : $Revision:   3.0  $
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
    --       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4054_nm4100_ddl_upg.sql-arc   3.0   Jul 14 2009 10:27:18   aedwards  $
    --       Module Name      : $Workfile:   nm4054_nm4100_ddl_upg.sql  $
    --       Date into PVCS   : $Date:   Jul 14 2009 10:27:18  $
    --       Date fetched Out : $Modtime:   Jul 14 2009 09:32:42  $
    --       Version          : $Revision:   3.0  $
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
    --       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4054_nm4100_ddl_upg.sql-arc   3.0   Jul 14 2009 10:27:18   aedwards  $
    --       Module Name      : $Workfile:   nm4054_nm4100_ddl_upg.sql  $
    --       Date into PVCS   : $Date:   Jul 14 2009 10:27:18  $
    --       Date fetched Out : $Modtime:   Jul 14 2009 09:32:42  $
    --       Version          : $Revision:   3.0  $
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
-- end of script 
------------------------------------------------------------------

