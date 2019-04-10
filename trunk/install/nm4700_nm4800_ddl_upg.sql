------------------------------------------------------------------
-- nm4700_nm4800_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm4700_nm4800_ddl_upg.sql-arc   1.1   Apr 10 2019 10:52:28   Chris.Baugh  $
--       Module Name      : $Workfile:   nm4700_nm4800_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Apr 10 2019 10:52:28  $
--       Date fetched Out : $Modtime:   Apr 10 2019 10:47:18  $
--       Version          : $Revision:   1.1  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2014

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
------------------------------------------------------------------
SET TERM ON
PROMPT WMS Themes tables.
SET TERM OFF
---------------------------------------
--Sequence
---------------------------------------
declare
obj_exists exception;
pragma exception_init( obj_exists, -955);
begin
execute immediate 'CREATE SEQUENCE NWT_ID_SEQ';
exception
  when obj_exists then
    NULL;
end;
/

---------------------------------------
--nm_wms_themes
---------------------------------------
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE nm_wms_themes'
                    ||'(nwt_id                 NUMBER(38)   NOT NULL'
                    ||',nwt_name               VARCHAR2(32) NOT NULL'
                    ||',nwt_is_background      VARCHAR2(1)  NOT NULL'
                    ||',nwt_transparency       NUMBER(38)   NOT NULL'
                    ||',nwt_visible_on_startup VARCHAR2(1)  NOT NULL)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE nm_wms_themes ADD (CONSTRAINT nwt_pk PRIMARY KEY(nwt_id))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE nm_wms_themes ADD (CONSTRAINT nwt_uk UNIQUE(nwt_name))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE nm_wms_themes ADD (CONSTRAINT nwt_is_background_chk CHECK(nwt_is_background IN(''Y'',''N'')))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE nm_wms_themes ADD (CONSTRAINT nwt_transparency_chk CHECK(nwt_transparency BETWEEN 0 AND 100))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE nm_wms_themes ADD (CONSTRAINT nwt_visible_on_startup_chk CHECK(nwt_visible_on_startup IN(''Y'',''N'')))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

---------------------------------------
--nm_wms_theme_roles
---------------------------------------
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE nm_wms_theme_roles'
                    ||'(nwtr_nwt_id  NUMBER(38)     NOT NULL'
                    ||',nwtr_role    VARCHAR2(30)  NOT NULL)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX nwtr_fk_hro_ind ON nm_wms_theme_roles(nwtr_role)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX nwtr_fk_nwt_ind ON nm_wms_theme_roles(nwtr_nwt_id)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE nm_wms_theme_roles ADD (CONSTRAINT nwtr_pk PRIMARY KEY(nwtr_nwt_id,nwtr_role))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE nm_wms_theme_roles ADD (CONSTRAINT nwtr_fk_hro FOREIGN KEY(nwtr_role) REFERENCES hig_roles(hro_role))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE nm_wms_theme_roles ADD (CONSTRAINT nwtr_fk_nwt FOREIGN KEY(nwtr_nwt_id) REFERENCES nm_wms_themes(nwt_id))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/


------------------------------------------------------------------
SET TERM ON
PROMPT Alert Manager Patch
SET TERM OFF
------------------------------------------------------------------------------------------------
--HIG_ALERT_TYPE_MAIL_LOOKUP, Unique Index, Primary Key
------------------------------------------------------------------------------------------------
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE  HIG_ALERT_TYPE_MAIL_LOOKUP
( HATML_ID             NUMBER        NOT NULL,
  HATML_INV_TYPE       VARCHAR2(20)              NOT NULL,
  HATML_SCREEN_TEXT    VARCHAR2(100)             NOT NULL,
  HATML_QUERY          VARCHAR2(4000)            NOT NULL,
  HATML_QUERY_COL      VARCHAR2(30)              NOT NULL,
  HATML_DATE_CREATED   DATE                      NOT NULL,
  HATML_CREATED_BY     VARCHAR2(30)         NOT NULL,
  HATML_DATE_MODIFIED  DATE                      NOT NULL,
  HATML_MODIFIED_BY    VARCHAR2(30)         NOT NULL)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

DECLARE
  obj_exists EXCEPTION;
  index_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
  PRAGMA exception_init( index_exists, -2260);
BEGIN
EXECUTE IMMEDIATE 'ALTER TABLE HIG_ALERT_TYPE_MAIL_LOOKUP ADD CONSTRAINT hatml_pk PRIMARY KEY  (hatml_id) ';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN index_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

---------------------------------------
--SYNONYM
---------------------------------------
begin
nm3ddl.create_synonym_for_object('HIG_ALERT_TYPE_MAIL_LOOKUP');
end;
/

---------------------------------------
--HIG_ALERT_TYPE_MAIL
---------------------------------------
DECLARE
  obj_exists EXCEPTION;
  column_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
  PRAGMA exception_init( column_exists, -1430);
BEGIN
execute immediate 'ALTER TABLE HIG_ALERT_TYPE_MAIL  ADD ( 
                                             HATM_P1_DERIVED   	VARCHAR2(1),
                                             HATM_P2_DERIVED   	VARCHAR2(1),
                                             HATM_P3_DERIVED   	VARCHAR2(1),
                                             HATM_P4_DERIVED   	VARCHAR2(1),
                                             HATM_P5_DERIVED   	VARCHAR2(1),
                                             HATM_P6_DERIVED   	VARCHAR2(1),
                                             HATM_P7_DERIVED   	VARCHAR2(1),
                                             HATM_P8_DERIVED   	VARCHAR2(1),
                                             HATM_P9_DERIVED   	VARCHAR2(1),
                                             HATM_P10_DERIVED  	VARCHAR2(1),
                                             HATM_P11_DERIVED	VARCHAR2(1),
                                             HATM_P12_DERIVED	VARCHAR2(1),
                                             HATM_P13_DERIVED	VARCHAR2(1),
                                             HATM_P14_DERIVED	VARCHAR2(1),
                                             HATM_P15_DERIVED	VARCHAR2(1),
                                             HATM_P16_DERIVED	VARCHAR2(1),
                                             HATM_P17_DERIVED	VARCHAR2(1),
                                             HATM_P18_DERIVED	VARCHAR2(1),
                                             HATM_P19_DERIVED	VARCHAR2(1),
                                             HATM_P20_DERIVED	VARCHAR2(1),
                                             HATM_PARAM_11    	VARCHAR2(500),
                                             HATM_PARAM_12    	VARCHAR2(500),
                                             HATM_PARAM_13    	VARCHAR2(500),
                                             HATM_PARAM_14    	VARCHAR2(500),
                                             HATM_PARAM_15    	VARCHAR2(500),
                                             HATM_PARAM_16    	VARCHAR2(500),
                                             HATM_PARAM_17    	VARCHAR2(500),
                                             HATM_PARAM_18    	VARCHAR2(500),
                                             HATM_PARAM_19    	VARCHAR2(500),
                                             HATM_PARAM_20    	VARCHAR2(500))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN column_exists THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/	
------------------------------------------------------------------
SET TERM ON
PROMPT Increase DOCS.DOC_REASON to 2000 chars
SET TERM OFF
alter table docs
modify doc_reason varchar2(2000)
/
------------------------------------------------------------------
SET TERM ON
PROMPT New table dm_admin_unit_scope_map
SET TERM OFF
Declare
--
   l_exception exception;
   pragma      exception_init(l_exception,-00955);
--
Begin
--
   Execute Immediate ' CREATE TABLE dm_admin_unit_scope_map              '||
                     ' (                                                 '||
                     ' dasm_admin_unit_id NUMBER NOT NULL                '||  
                     ',dasm_scope_id      NUMBER NOT NULL                '||  
                     ',dasm_scope_name    NVARCHAR2(255) NOT NULL        )';
--
Exception
  When l_exception Then
  null;
  When Others Then
  Raise ;
End ;
/

Declare
--
   l_exception exception;
   pragma      exception_init(l_exception,-02260);
--
Begin
--
   Execute Immediate ' ALTER TABLE dm_admin_unit_scope_map ADD (Constraint dasm_pk PRIMARY KEY (dasm_admin_unit_id)) ';
--
Exception
  When l_exception Then
  null;
  When Others Then
  Raise ;
End ;
/

Declare
--
   l_exception exception;
   pragma      exception_init(l_exception,-02261);
--
Begin
--
   Execute Immediate ' ALTER TABLE dm_admin_unit_scope_map ADD (Constraint dasm_uk UNIQUE (dasm_scope_id)) ';
--
Exception
  When l_exception Then
  null;
  When Others Then
  Raise ;
End ;
/

------------------------------------------------------------------
SET TERM ON
PROMPT Nm_4700_fix29
SET TERM OFF
Prompt Creating Exor_Allow_User_Proxy

Declare
  Role_Already_Exists Exception;
  Pragma Exception_Init(Role_Already_Exists,-1921);
Begin
  Execute Immediate ('Create Role Exor_Allow_User_Proxy');
Exception
  When Role_Already_Exists Then
    Null;
End;  
/
------------------------------------------------------------------
SET TERM ON
PROMPT nm_4700_fix54
SET TERM OFF
DECLARE
  constraint_exists Exception;
  Pragma Exception_Init(constraint_exists, -2275); 
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_XSP_RESTRAINTS ADD (
                                     CONSTRAINT XSR_FK_NIT 
                                     FOREIGN KEY (XSR_ITY_INV_CODE) 
                                     REFERENCES NM_INV_TYPES_ALL (NIT_INV_TYPE)
                                     ENABLE VALIDATE)';

EXCEPTION
WHEN constraint_exists
    THEN 
      Null;
END;
/
------------------------------------------------------------------
SET TERM ON
PROMPT nm_4700_fix43
SET TERM OFF
DECLARE
   not_exists   EXCEPTION;
   PRAGMA EXCEPTION_INIT (not_exists, -942);
BEGIN
   EXECUTE IMMEDIATE ('drop table nm_inv_geometry_all');
EXCEPTION
WHEN not_exists
   THEN
      NULL;
END;
/

PROMPT Create table to provide repository for aggregated geometry

CREATE TABLE nm_inv_geometry_all
(
   asset_id     INTEGER NOT NULL,
   asset_type   VARCHAR2 (4) NOT NULL,
   start_date   DATE NOT NULL,
   end_date     DATE,
   shape        MDSYS.sdo_geometry
)
/

--

DECLARE
   not_exists   EXCEPTION;
   PRAGMA EXCEPTION_INIT (not_exists, -942);
BEGIN
   EXECUTE IMMEDIATE ('drop table nm_inv_aggr_sdo_types');
EXCEPTION
   WHEN not_exists
   THEN
      NULL;
END;
/

--

CREATE UNIQUE INDEX NIG_PK_IDX
   ON NM_INV_GEOMETRY_ALL (ASSET_ID, asset_type, START_DATE)
/

ALTER TABLE NM_INV_GEOMETRY_ALL ADD (
  CONSTRAINT NIG_SDO_PK
  PRIMARY KEY
  (ASSET_ID, asset_type, START_DATE)
  USING INDEX NIG_PK_IDX
  ENABLE 
  VALIDATE)
/

CREATE INDEX nig_type_idx
   ON nm_inv_geometry_all (asset_type)
/
--

PROMPT create table as list of asset types that are aggregated

CREATE TABLE nm_inv_aggr_sdo_types
(
   nit_inv_type    VARCHAR2 (4),
   date_created    DATE,
   date_modified   DATE,
   modified_by     VARCHAR2 (30),
   created_by      VARCHAR2 (30),
   CONSTRAINT niaggr_pk
 PRIMARY KEY (nit_inv_type)
)
ORGANIZATION INDEX
/

--
ALTER TABLE NM_INV_AGGR_SDO_TYPES ADD
CONSTRAINT niaggr_fk_nit
 FOREIGN KEY
 (NIT_INV_TYPE)
 REFERENCES NM_INV_TYPES_ALL (NIT_INV_TYPE)
 ON DELETE CASCADE
 ENABLE
 VALIDATE
/
------------------------------------------------------------------
SET TERM ON
PROMPT nm_4700_fix31
SET TERM OFF
RENAME NM_AU_TYPES TO NM_AU_TYPES_FULL
/

ALTER TABLE nm_au_types_FULL
   ADD nat_exclusive VARCHAR2 (1) DEFAULT 'Y'
/

ALTER TABLE NM_AU_TYPES_FULL ADD
CONSTRAINT NM_AU_TYPES_EXCL_YN
 CHECK (nat_exclusive IN ('Y', 'N'))
 ENABLE
 VALIDATE
/

DECLARE
 trigger_not_exists exception;
 pragma exception_init (trigger_not_exists,-4080);
BEGIN
  EXECUTE IMMEDIATE 'drop trigger nm_au_types_who';
EXCEPTION
  WHEN trigger_not_exists THEN
    Null;
   WHEN others THEN
     RAISE;
END;
/
--


DECLARE
   pubsyn   VARCHAR2 (1);

BEGIN
   SELECT hov_value
     INTO pubsyn
     FROM hig_option_values
    WHERE hov_id = 'HIGPUBSYN';

--
   IF pubsyn = 'Y'
   THEN
      DECLARE
         already_exists   EXCEPTION;
         PRAGMA EXCEPTION_INIT (already_exists, -955);

      BEGIN
         EXECUTE IMMEDIATE
               'create public synonym NM_AU_TYPES_FULL for '
            || SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
            || '.NM_AU_TYPES_FULL';
         EXECUTE IMMEDIATE
               'create public synonym NM_AU_TYPES for '
            || SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
            || '.NM_AU_TYPES';
      EXCEPTION
         WHEN already_exists
         THEN
            NULL;
      END;
   END IF;
END;

/
------------------------------------------------------------------
SET TERM ON
PROMPT nm_4700_fix45
SET TERM OFF
DECLARE
   --
 
  CURSOR c1
   IS
      SELECT nm_ne_id_in,
             nm_ne_id_of,
             nm_begin_mp,
             nm_start_date,
             nm_end_mp
        FROM nm_members_all
       WHERE nm_begin_mp > nm_end_mp;
--
BEGIN
   --
   -- Disable all the triggers on NM_MEMBERS_ALL prior to the update and creation of check constraint
   EXECUTE IMMEDIATE 'ALTER TABLE nm_members_all DISABLE ALL TRIGGERS';

   -- Reverse nm_begin_mp and nm_end_mp where nm_begin_mp > nm_end_mp
   FOR l_rec IN c1
   LOOP
      UPDATE nm_members_all
         SET nm_end_mp = l_rec.nm_begin_mp,
                nm_begin_mp = l_rec.nm_end_mp
       WHERE     nm_ne_id_in = l_rec.nm_ne_id_in
             AND nm_ne_id_of = l_rec.nm_ne_id_of
             AND nm_begin_mp = l_rec.nm_begin_mp
             AND nm_start_date = l_rec.nm_start_date;
   END LOOP;
   -- Create Check Constraint to enforce nm_begin_mp <= nm_end_mp
   DECLARE
      already_exists   EXCEPTION;
      PRAGMA EXCEPTION_INIT (already_exists, -02264);
   BEGIN
      EXECUTE IMMEDIATE
            'ALTER TABLE NM_MEMBERS_ALL ADD  '
         || CHR (10)
         || 'CONSTRAINT NM_BEGIN_MP_CHK      '
         || CHR (10)
         || 'CHECK (NM_BEGIN_MP <= NM_END_MP)';
   EXCEPTION
      WHEN already_exists
      THEN
         NULL;
      WHEN OTHERS
      THEN
         RAISE;
   END;
   --Re-enable all the triggers on NM_MEMBERS_ALL
   EXECUTE IMMEDIATE 'ALTER TABLE nm_members_all ENABLE ALL TRIGGERS';
END;
/

------------------------------------------------------------------
SET TERM ON
PROMPT Add NM_XSP_REVERSAL constraints
SET TERM OFF
ALTER TABLE NM_XSP_REVERSAL ADD CONSTRAINT XRV_FK_OLD_XSP FOREIGN KEY (XRV_NW_TYPE, XRV_OLD_SUB_CLASS, XRV_OLD_XSP) REFERENCES NM_NW_XSP (NWX_NW_TYPE, NWX_NSC_SUB_CLASS, NWX_X_SECT) ENABLE VALIDATE;
ALTER TABLE NM_XSP_REVERSAL ADD CONSTRAINT XRV_FK_NEW_XSP FOREIGN KEY (XRV_NW_TYPE, XRV_NEW_SUB_CLASS, XRV_NEW_XSP) REFERENCES NM_NW_XSP (NWX_NW_TYPE, NWX_NSC_SUB_CLASS, NWX_X_SECT) ENABLE VALIDATE;
create index XRV_FK_NEW_XSP on nm_xsp_reversal( XRV_NW_TYPE, XRV_NEW_SUB_CLASS, XRV_NEW_XSP );
------------------------------------------------------------------
SET TERM ON
PROMPT nm_4700_fix58
SET TERM OFF
DECLARE table_exists exception; pragma exception_init (table_exists,-955);BEGIN  EXECUTE IMMEDIATE 'CREATE TABLE HIG_RELATIONSHIP                        '||CHR(10)||                    '( HIR_ATTRIBUTE1  VARCHAR2(50)               NOT NULL'||CHR(10)||                      ' ,HIR_ATTRIBUTE2  RAW(2000)                  NOT NULL'||CHR(10)||                     ' ,HIR_ATTRIBUTE3  VARCHAR2(1)  DEFAULT ''Y'' NOT NULL'||CHR(10)||                     ' ,HIR_ATTRIBUTE4  RAW(2000)                          '||CHR(10)||                     ')';EXCEPTION  WHEN table_exists THEN    Null;   WHEN others THEN     RAISE;END;/---- Add PK constraint--DECLARE constraint_exists exception; pragma exception_init (constraint_exists,-2260);BEGIN  EXECUTE IMMEDIATE 'ALTER TABLE HIG_RELATIONSHIP'||CHR(10)||                    'ADD CONSTRAINT HIR_PK PRIMARY KEY (HIR_ATTRIBUTE1)';EXCEPTION  WHEN constraint_exists THEN    Null;   WHEN others THEN     RAISE;END;/
------------------------------------------------------------------
SET TERM ON
PROMPT nm_4700_fix59
SET TERM OFF
CREATE INDEX nex_ind1 ON nm_element_xrefs(nex_id1);
CREATE INDEX nex_ind2 ON nm_element_xrefs(nex_id2);

------------------------------------------------------------------
SET TERM ON
PROMPT Location Bridge Tables
SET TERM OFF
PROMPT Creating Table 'LB_ELEMENT_HISTORY'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE LB_ELEMENT_HISTORY
 (TRANSACTION_ID INTEGER NOT NULL
 ,NEH_ID INTEGER
 ,PRIOR_TRANSACTION_ID INTEGER
 )';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Table 'LB_INV_SECURITY'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE LB_INV_SECURITY
 (LB_EXOR_INV_TYPE VARCHAR2(4)
 ,LB_SECURITY_TYPE VARCHAR2(10) DEFAULT ''NONE''
 )';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Table 'LB_NETWORK_LINK'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE GLOBAL TEMPORARY TABLE LB_NETWORK_LINK
 (LINK_ID NUMBER
 ,LINK_NAME VARCHAR2(200)
 ,START_NODE_ID NUMBER NOT NULL
 ,END_NODE_ID NUMBER NOT NULL
 ,LINK_TYPE VARCHAR2(200)
 ,ACTIVE VARCHAR2(1)
 ,LINK_LEVEL NUMBER
 ,XNW_COST NUMBER
 )';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Table 'LB_NETWORK_NO'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE GLOBAL TEMPORARY TABLE LB_NETWORK_NO
 (NODE_ID NUMBER
 ,NODE_NAME VARCHAR2(200)
 ,NODE_TYPE VARCHAR2(200)
 ,ACTIVE VARCHAR2(1)
 ,PARTITION_ID NUMBER
 ,XNO_COST NUMBER
 )';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Table 'LB_NETWORK_PATH'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE GLOBAL TEMPORARY TABLE LB_NETWORK_PATH
 (PATH_ID NUMBER
 ,PATH_NAME VARCHAR2(200)
 ,PATH_TYPE VARCHAR2(200)
 ,START_NODE_ID NUMBER NOT NULL
 ,END_NODE_ID NUMBER NOT NULL
 ,COST NUMBER
 ,SIMPLE VARCHAR2(1)
 )';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Table 'LB_NETWORK_PATH_LINK'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE GLOBAL TEMPORARY TABLE LB_NETWORK_PATH_LINK
 (PATH_ID NUMBER NOT NULL
 ,LINK_ID NUMBER NOT NULL
 ,SEQ_NO NUMBER
 )';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Table 'LB_NETWORK_SUB_PATH'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE GLOBAL TEMPORARY TABLE LB_NETWORK_SUB_PATH
 (SUBPATH_ID NUMBER
 ,SUBPATH_NAME VARCHAR2(200)
 ,SUBPATH_TYPE VARCHAR2(200)
 ,REFERENCE_PATH_ID NUMBER NOT NULL
 ,START_LINK_INDEX NUMBER NOT NULL
 ,END_LINK_INDEX NUMBER NOT NULL
 ,START_PERCENTAGE NUMBER NOT NULL
 ,END_PERCENTAGE NUMBER NOT NULL
 ,COST NUMBER
 )';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Table 'LB_OBJECTS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE LB_OBJECTS
 (OBJECT_NAME VARCHAR2(30) NOT NULL
 ,OBJECT_TYPE VARCHAR2(30) NOT NULL
 )';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Table 'LB_TYPES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE LB_TYPES
 (LB_OBJECT_TYPE INTEGER
 ,LB_ASSET_GROUP VARCHAR2(100)
 ,LB_EXOR_INV_TYPE VARCHAR2(4)
 )';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

COMMENT ON TABLE LB_TYPES IS 'Links of LB asset types to Exor Inv Types, allowing decoding from external systems such as eB'
/

PROMPT Creating Table 'LB_UNITS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE LB_UNITS
 (EXTERNAL_UNIT_ID INTEGER NOT NULL
 ,EXTERNAL_UNIT_NAME VARCHAR2(2000)
 ,EXOR_UNIT_ID NUMBER(4) NOT NULL
 ,EXOR_UNIT_NAME VARCHAR2(20) NOT NULL
 )';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

COMMENT ON TABLE LB_UNITS IS 'The relation between units held in Exor and an external unit system such as eB'
/

PROMPT Creating Table 'NM_ASSET_GEOMETRY_ALL'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE NM_ASSET_GEOMETRY_ALL
 (NAG_ID INTEGER NOT NULL
 ,NAG_LOCATION_TYPE VARCHAR2(1) NOT NULL
 ,NAG_ASSET_ID NUMBER(38) NOT NULL
 ,NAG_OBJ_TYPE VARCHAR2(4) NOT NULL
 ,NAG_START_DATE DATE NOT NULL
 ,NAG_END_DATE DATE
 ,NAG_GEOMETRY SDO_GEOMETRY
 )';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Table 'NM_ASSET_LOCATIONS_ALL'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE NM_ASSET_LOCATIONS_ALL
 (NAL_ID INTEGER
 ,NAL_NIT_TYPE VARCHAR2(4)
 ,NAL_ASSET_ID INTEGER
 ,NAL_DESCR VARCHAR2(240)
 ,NAL_JXP INTEGER
 ,NAL_PRIMARY VARCHAR2(1)
 ,NAL_LOCATION_TYPE VARCHAR2(1) DEFAULT ''N'' NOT NULL
 ,NAL_START_DATE DATE
 ,NAL_END_DATE DATE
 ,NAL_SECURITY_KEY INTEGER
 ,NAL_DATE_CREATED DATE
 ,NAL_DATE_MODIFIED DATE
 ,NAL_CREATED_BY VARCHAR2(30)
 ,NAL_MODIFIED_BY VARCHAR2(30)
 )';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

COMMENT ON TABLE NM_ASSET_LOCATIONS_ALL IS 'Instances of asset placements and juxtapositions'
/

PROMPT Creating Table 'NM_ASSET_TYPE_JUXTAPOSITIONS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE NM_ASSET_TYPE_JUXTAPOSITIONS
 (NAJX_ID INTEGER NOT NULL
 ,NAJX_INV_TYPE VARCHAR2(4) NOT NULL
 ,NAJX_NJXT_ID INTEGER NOT NULL
 )';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

COMMENT ON TABLE NM_ASSET_TYPE_JUXTAPOSITIONS IS 'The list of juxtaposition types available for an asset type'
/

PROMPT Creating Table 'NM_JUXTAPOSITIONS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE NM_JUXTAPOSITIONS
 (NJX_ID INTEGER NOT NULL
 ,NJX_NJXT_ID INTEGER NOT NULL
 ,NJX_CODE INTEGER NOT NULL
 ,NJX_MEANING VARCHAR2(80) NOT NULL
 )';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

COMMENT ON TABLE NM_JUXTAPOSITIONS IS 'A list of possible juxtapositions by type'
/

PROMPT Creating Table 'NM_JUXTAPOSITION_TYPES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE NM_JUXTAPOSITION_TYPES
 (NJXT_ID INTEGER NOT NULL
 ,NJXT_NAME VARCHAR2(30) NOT NULL
 ,NJXT_DESCR VARCHAR2(80) NOT NULL
 )';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

COMMENT ON TABLE NM_JUXTAPOSITION_TYPES IS 'The domain of all types of Juxtaposition'
/

PROMPT Creating Table 'NM_LOCATIONS_ALL'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE NM_LOCATIONS_ALL
 (NM_NE_ID_OF INTEGER NOT NULL
 ,NM_LOC_ID INTEGER NOT NULL
 ,NM_OBJ_TYPE VARCHAR2(4) NOT NULL
 ,NM_NE_ID_IN INTEGER NOT NULL
 ,NM_BEGIN_MP NUMBER NOT NULL
 ,NM_START_DATE DATE NOT NULL
 ,NM_END_DATE DATE
 ,NM_END_MP NUMBER NOT NULL
 ,NM_TYPE VARCHAR2(4) NOT NULL
 ,NM_SLK NUMBER
 ,NM_DIR_FLAG INTEGER
 ,NM_SECURITY_ID NUMBER(9)
 ,NM_SEQ_NO INTEGER
 ,NM_SEG_NO INTEGER
 ,NM_TRUE NUMBER
 ,NM_END_SLK NUMBER
 ,NM_END_TRUE NUMBER
 ,NM_X_SECT_ST VARCHAR2(4)
 ,NM_OFFSET_ST NUMBER
 ,NM_UNIQUE_PRIMARY VARCHAR2(1)
 ,NM_PRIMARY VARCHAR2(1)
 ,NM_STATUS INTEGER
 ,TRANSACTION_ID INTEGER
 ,NM_DATE_CREATED DATE
 ,NM_DATE_MODIFIED DATE
 ,NM_MODIFIED_BY VARCHAR2(30)
 ,NM_CREATED_BY VARCHAR2(30)
 ,NM_X_SECT_END VARCHAR2(4)
 ,NM_OFFSET_END NUMBER
 ,NM_FACTOR NUMBER
 ,NM_NLT_ID INTEGER NOT NULL
 )';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

COMMENT ON TABLE NM_LOCATIONS_ALL IS 'The placement of each asset location instance'
/

PROMPT Creating Table 'NM_LOCATION_GEOMETRY'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE NM_LOCATION_GEOMETRY
 (NLG_ID NUMBER(38) NOT NULL
 ,NLG_LOCATION_TYPE VARCHAR2(1) DEFAULT ''N'' NOT NULL
 ,NLG_NAL_ID NUMBER(38) NOT NULL
 ,NLG_OBJ_TYPE VARCHAR2(4) NOT NULL
 ,NLG_LOC_ID INTEGER
 ,NLG_GEOMETRY SDO_GEOMETRY
 )';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

COMMENT ON TABLE NM_LOCATION_GEOMETRY IS 'The geometry or component geometries of an asset'
/


------------------------------------------------------------------
SET TERM ON
PROMPT Location Bridge Indexes
SET TERM OFF
PROMPT Creating Index 'LB_TRANS_IDX1'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX LB_TRANS_IDX1 ON LB_ELEMENT_HISTORY
 (TRANSACTION_ID
 ,NEH_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Index 'LB_TRANS_IDX2'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX LB_TRANS_IDX2 ON LB_ELEMENT_HISTORY
 (NEH_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Index 'LB_TRANS_IDX3'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX LB_TRANS_IDX3 ON LB_ELEMENT_HISTORY
 (PRIOR_TRANSACTION_ID
 ,TRANSACTION_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Index 'LB_NETWORK_PATH_LINK_IDX'
DECLARE
  obj_exists EXCEPTION;
  col_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
  PRAGMA exception_init( col_exists, -1408);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX LB_NETWORK_PATH_LINK_IDX ON LB_NETWORK_PATH_LINK
 (PATH_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN col_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Index 'LBT_OBK_IDX'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX LBT_OBK_IDX ON LB_TYPES
 (LB_OBJECT_TYPE)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Index 'NAG_ASSET_IDX'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX NAG_ASSET_IDX ON NM_ASSET_GEOMETRY_ALL
 (NAG_ASSET_ID
 ,NAG_OBJ_TYPE
 ,NAG_START_DATE
 ,NAG_LOCATION_TYPE
 ,NAG_END_DATE)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Index 'NAG_ID_IDX'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX NAG_ID_IDX ON NM_ASSET_GEOMETRY_ALL
 (NAG_ASSET_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Index 'NAG_OBJ_TYPE_IDX'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX NAG_OBJ_TYPE_IDX ON NM_ASSET_GEOMETRY_ALL
 (NAG_OBJ_TYPE)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Index 'NAL_ASSET_IDX1'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX NAL_ASSET_IDX1 ON NM_ASSET_LOCATIONS_ALL
 (NAL_ASSET_ID
 ,NAL_JXP
 ,NAL_NIT_TYPE)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Index 'NAL_NIT_IDX'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX NAL_NIT_IDX ON NM_ASSET_LOCATIONS_ALL
 (NAL_NIT_TYPE)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Index 'NAJX_INV_IDX'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX NAJX_INV_IDX ON NM_ASSET_TYPE_JUXTAPOSITIONS
 (NAJX_INV_TYPE
 ,NAJX_NJXT_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Index 'NJX_CODE_IDX'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX NJX_CODE_IDX ON NM_JUXTAPOSITIONS
 (NJX_CODE
 ,NJX_NJXT_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Index 'NJX_FK_JXT_IND'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX NJX_FK_JXT_IND ON NM_JUXTAPOSITIONS
 (NJX_NJXT_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Index 'NML1_IN_IDX'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX NML1_IN_IDX ON NM_LOCATIONS_ALL
 (NM_NE_ID_IN
 ,NM_NE_ID_OF
 ,NM_BEGIN_MP
 ,NM_START_DATE
 ,NM_OBJ_TYPE
 ,NM_STATUS)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Index 'NML1_LOC_ID_UK'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX NML1_LOC_ID_UK ON NM_LOCATIONS_ALL
 (NM_LOC_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Index 'NML1_NLT_IDX'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX NML1_NLT_IDX ON NM_LOCATIONS_ALL
 (NM_NLT_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Index 'NML1_OBJ_IDX'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX NML1_OBJ_IDX ON NM_LOCATIONS_ALL
 (NM_OBJ_TYPE
 ,NM_LOC_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Index 'NML1_OF_IDX'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX NML1_OF_IDX ON NM_LOCATIONS_ALL
 (NM_NE_ID_OF
 ,NM_OBJ_TYPE
 ,NM_LOC_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Index 'NLG_LOC_IDX'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX NLG_LOC_IDX ON NM_LOCATION_GEOMETRY
 (NLG_LOC_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Index 'NLG_NAL_IDX'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX NLG_NAL_IDX ON NM_LOCATION_GEOMETRY
 (NLG_NAL_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Index 'NLG_OBJ_TYPE_IDX'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX NLG_OBJ_TYPE_IDX ON NM_LOCATION_GEOMETRY
 (NLG_OBJ_TYPE)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/


------------------------------------------------------------------
SET TERM ON
PROMPT Location Bridge Constraints
SET TERM OFF
PROMPT Creating Primary Key on 'LB_INV_SECURITY'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE LB_INV_SECURITY
 ADD (CONSTRAINT LIS_PK PRIMARY KEY 
  (LB_EXOR_INV_TYPE))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Primary Key on 'LB_NETWORK_LINK'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE LB_NETWORK_LINK
 ADD (CONSTRAINT LB_NETWORK_LINK_PK PRIMARY KEY 
  (LINK_ID))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Primary Key on 'LB_NETWORK_NO'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE LB_NETWORK_NO
 ADD (CONSTRAINT LB_NETWORK_NO_PK PRIMARY KEY 
  (NODE_ID))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Primary Key on 'LB_NETWORK_PATH'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE LB_NETWORK_PATH
 ADD (CONSTRAINT LB_NETWORK_PATH_PK PRIMARY KEY 
  (PATH_ID))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Primary Key on 'LB_NETWORK_PATH_LINK'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE LB_NETWORK_PATH_LINK
 ADD (CONSTRAINT LB_NETWORK_PATH_LINK_PK PRIMARY KEY 
  (PATH_ID
  ,LINK_ID
  ,SEQ_NO))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Primary Key on 'LB_NETWORK_SUB_PATH'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE LB_NETWORK_SUB_PATH
 ADD (CONSTRAINT LB_NETWORK_SUB_PATH_PK PRIMARY KEY 
  (SUBPATH_ID
  ,REFERENCE_PATH_ID))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Primary Key on 'LB_OBJECTS'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE LB_OBJECTS
 ADD (CONSTRAINT LB_OBJECTS_PK PRIMARY KEY 
  (OBJECT_NAME
  ,OBJECT_TYPE))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Primary Key on 'LB_TYPES'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE LB_TYPES
 ADD (CONSTRAINT LBT_PK PRIMARY KEY 
  (LB_OBJECT_TYPE
  ,LB_ASSET_GROUP))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Primary Key on 'NM_ASSET_GEOMETRY_ALL'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_ASSET_GEOMETRY_ALL
 ADD (CONSTRAINT NM_ASSET_GEOMETRY_ALL_PK PRIMARY KEY 
  (NAG_ID))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Primary Key on 'NM_ASSET_LOCATIONS_ALL'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_ASSET_LOCATIONS_ALL
 ADD (CONSTRAINT NM_ASSET_LOCATIONS_ALL_PK PRIMARY KEY 
  (NAL_ID))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Primary Key on 'NM_ASSET_TYPE_JUXTAPOSITIONS'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_ASSET_TYPE_JUXTAPOSITIONS
 ADD (CONSTRAINT NAJX_PK PRIMARY KEY 
  (NAJX_ID))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Primary Key on 'NM_JUXTAPOSITIONS'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_JUXTAPOSITIONS
 ADD (CONSTRAINT NJX_PK PRIMARY KEY 
  (NJX_ID))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Primary Key on 'NM_JUXTAPOSITION_TYPES'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_JUXTAPOSITION_TYPES
 ADD (CONSTRAINT NJXT_PK PRIMARY KEY 
  (NJXT_ID))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Unique Key on 'LB_TYPES'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE LB_TYPES
 ADD (CONSTRAINT LBT_INV_UK UNIQUE 
  (LB_EXOR_INV_TYPE))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Unique Key on 'LB_UNITS'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE LB_UNITS
 ADD (CONSTRAINT LB_UNITS_UK1 UNIQUE 
  (EXTERNAL_UNIT_ID))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Unique Key on 'LB_UNITS'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE LB_UNITS
 ADD (CONSTRAINT LB_UNITS_UK2 UNIQUE 
  (EXOR_UNIT_ID))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Unique Key on 'NM_ASSET_GEOMETRY_ALL'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_ASSET_GEOMETRY_ALL
 ADD (CONSTRAINT NAG_UK UNIQUE 
  (NAG_ASSET_ID
  ,NAG_OBJ_TYPE
  ,NAG_START_DATE
  ,NAG_LOCATION_TYPE
  ,NAG_END_DATE))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Unique Key on 'NM_JUXTAPOSITIONS'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_JUXTAPOSITIONS
 ADD (CONSTRAINT NJX_UK UNIQUE 
  (NJX_NJXT_ID
  ,NJX_CODE))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Unique Key on 'NM_JUXTAPOSITION_TYPES'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_JUXTAPOSITION_TYPES
 ADD (CONSTRAINT NJXT_UK UNIQUE 
  (NJXT_NAME))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Unique Key on 'NM_LOCATIONS_ALL'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_LOCATIONS_ALL
 ADD (CONSTRAINT NM_LOC_UK UNIQUE 
  (NM_LOC_ID))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

      
PROMPT Creating Check Constraint on 'LB_INV_SECURITY'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE LB_INV_SECURITY
 ADD (CONSTRAINT LB_SECURITY_TYPE_CHK CHECK (LB_SECURITY_TYPE in (''NONE'', ''SCOPE'', ''ADMIN_UNIT'', ''INHERIT'')))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/
                           
   
PROMPT Creating Check Constraint on 'NM_ASSET_LOCATIONS_ALL'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_ASSET_LOCATIONS_ALL
 ADD (CONSTRAINT NAL_LOCATION_TYPE_CHK CHECK (NAL_LOCATION_TYPE in (''N'', ''G'')))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/
     
    
PROMPT Creating Check Constraint on 'NM_LOCATION_GEOMETRY'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_LOCATION_GEOMETRY
 ADD (CONSTRAINT NLG_LOCATION_TYPE_CHK CHECK (NLG_LOCATION_TYPE in (''N'', ''G'')))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Check Constraint on 'NM_LOCATION_GEOMETRY'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_LOCATION_GEOMETRY
 ADD (CONSTRAINT NLG_LOC_ID_TYPE_CHK CHECK (decode(nlg_location_type, ''N''
, 0, 1) + decode( nlg_loc_id, NULL, 1, 0) in (0,2)))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/
    
PROMPT Creating Foreign Key on 'LB_INV_SECURITY'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE LB_INV_SECURITY ADD (CONSTRAINT
 LIS_FK_NIT FOREIGN KEY 
  (LB_EXOR_INV_TYPE) REFERENCES NM_INV_TYPES_ALL
  (NIT_INV_TYPE))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Foreign Key on 'LB_TYPES'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE LB_TYPES ADD (CONSTRAINT
 LBT_FK_NIT FOREIGN KEY 
  (LB_EXOR_INV_TYPE) REFERENCES NM_INV_TYPES_ALL
  (NIT_INV_TYPE))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Foreign Key on 'LB_UNITS'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE LB_UNITS ADD (CONSTRAINT
 LB_UNITS_FK1 FOREIGN KEY 
  (EXOR_UNIT_ID) REFERENCES NM_UNITS
  (UN_UNIT_ID))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Foreign Key on 'NM_ASSET_GEOMETRY_ALL'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_ASSET_GEOMETRY_ALL ADD (CONSTRAINT
 NAG_FK_OBJ_TYPE FOREIGN KEY 
  (NAG_OBJ_TYPE) REFERENCES NM_INV_TYPES_ALL
  (NIT_INV_TYPE))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Foreign Key on 'NM_ASSET_LOCATIONS_ALL'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_ASSET_LOCATIONS_ALL ADD (CONSTRAINT
 NAL_FK_NIT FOREIGN KEY 
  (NAL_NIT_TYPE) REFERENCES NM_INV_TYPES_ALL
  (NIT_INV_TYPE))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Foreign Key on 'NM_ASSET_TYPE_JUXTAPOSITIONS'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_ASSET_TYPE_JUXTAPOSITIONS ADD (CONSTRAINT
 NAJX_FK_JXT FOREIGN KEY 
  (NAJX_NJXT_ID) REFERENCES NM_JUXTAPOSITION_TYPES
  (NJXT_ID))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Foreign Key on 'NM_ASSET_TYPE_JUXTAPOSITIONS'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_ASSET_TYPE_JUXTAPOSITIONS ADD (CONSTRAINT
 NAJX_FK_NIT FOREIGN KEY 
  (NAJX_INV_TYPE) REFERENCES NM_INV_TYPES_ALL
  (NIT_INV_TYPE))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Foreign Key on 'NM_JUXTAPOSITIONS'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_JUXTAPOSITIONS ADD (CONSTRAINT
 NJX_FK_JXT FOREIGN KEY 
  (NJX_NJXT_ID) REFERENCES NM_JUXTAPOSITION_TYPES
  (NJXT_ID))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Foreign Key on 'NM_LOCATIONS_ALL'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_LOCATIONS_ALL ADD (CONSTRAINT
 NM_FK_NAL FOREIGN KEY 
  (NM_NE_ID_IN) REFERENCES NM_ASSET_LOCATIONS_ALL
  (NAL_ID))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Foreign Key on 'NM_LOCATION_GEOMETRY'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_LOCATION_GEOMETRY ADD (CONSTRAINT
 NLG_FK_LOC FOREIGN KEY 
  (NLG_LOC_ID) REFERENCES NM_LOCATIONS_ALL
  (NM_LOC_ID))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

PROMPT Creating Foreign Key on 'NM_LOCATION_GEOMETRY'
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_LOCATION_GEOMETRY ADD (CONSTRAINT
 NLG_FK_OBJ_TYPE FOREIGN KEY 
  (NLG_OBJ_TYPE) REFERENCES NM_INV_TYPES_ALL
  (NIT_INV_TYPE))';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

-- The following constraints have been added manually as designer will not gernerate due to datatype inconsistencies
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_LOCATIONS_ALL ADD 
CONSTRAINT LOC_FK_NE
 FOREIGN KEY (NM_NE_ID_OF)
 REFERENCES NM_ELEMENTS_ALL (NE_ID)
 ENABLE
 VALIDATE';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_LOCATIONS_ALL ADD (
  CONSTRAINT NM_LOC_NLT_FK 
  FOREIGN KEY (nm_nlt_id) 
  REFERENCES NM_LINEAR_TYPES (NLT_ID)
  ENABLE VALIDATE)';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/
  
DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE NM_LOCATION_GEOMETRY ADD (
  CONSTRAINT NLG_FK_NAL 
  FOREIGN KEY (NLG_NAL_ID) 
  REFERENCES NM_ASSET_LOCATIONS_ALL (NAL_ID)
  ENABLE VALIDATE)';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

DECLARE
  con_exists EXCEPTION;
  PRAGMA exception_init( con_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE LB_ELEMENT_HISTORY ADD (
  CONSTRAINT LB_TRANS_NEH_FK 
  FOREIGN KEY (NEH_ID) 
  REFERENCES NM_ELEMENT_HISTORY (NEH_ID) ON DELETE CASCADE
  ENABLE VALIDATE) ';
EXCEPTION
  WHEN con_exists THEN
    NULL;
  WHEN OTHERS THEN 
    RAISE;
END;
/

------------------------------------------------------------------
SET TERM ON
PROMPT Location Bridge Sequences
SET TERM OFF
PROMPT Creating Sequence 'LB_TRANSACTION_ID_SEQ'
CREATE SEQUENCE LB_TRANSACTION_ID_SEQ
 START WITH 1
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/

PROMPT Creating Sequence 'NAG_ID_SEQ'
CREATE SEQUENCE NAG_ID_SEQ
 START WITH 1
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/

PROMPT Creating Sequence 'NAJX_ID_SEQ'
CREATE SEQUENCE NAJX_ID_SEQ
 START WITH 1
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/

PROMPT Creating Sequence 'NAL_ID_SEQ'
CREATE SEQUENCE NAL_ID_SEQ
 START WITH 1
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/

PROMPT Creating Sequence 'NJXT_ID_SEQ'
CREATE SEQUENCE NJXT_ID_SEQ
 START WITH 1
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/

PROMPT Creating Sequence 'NJX_ID_SEQ'
CREATE SEQUENCE NJX_ID_SEQ
 START WITH 1
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/

PROMPT Creating Sequence 'NLG_ID_SEQ'
CREATE SEQUENCE NLG_ID_SEQ
 START WITH 1
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/

PROMPT Creating Sequence 'NM_LOC_ID_SEQ'
CREATE SEQUENCE NM_LOC_ID_SEQ
 START WITH 1
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

