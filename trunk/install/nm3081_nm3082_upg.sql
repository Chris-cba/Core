REM Copyright 2013 Bentley Systems Incorporated. All rights reserved.
REM '@(#)nm3081_nm3082_upg.sql	1.15 12/05/03'
--
COL run_file new_value run_file noprint
--
spool nm3082_upg.LOG
--
--get some db info
--
SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG','NET', 'DOC');
--
WHENEVER SQLERROR EXIT
begin
   hig2.pre_upgrade_check (p_product               => 'HIG'
                          ,p_new_version           => '3.0.8.2'
                          ,p_allowed_old_version_1 => '3.0.8.1'
                          );
END;
/
WHENEVER SQLERROR CONTINUE

PROMPT Dropping Policies
SET feedback OFF
SET define ON
SET VERIFY OFF
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'ctx'||'&terminator'||'drop_policy' run_file
FROM dual
/
START '&&run_file'
SET feedback ON
--
--
---------------------------------------------------------------------------------------------------
--
--            **************** PUT TABLE UPGRADES HERE *******************
--
---------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------
--Start of MapCapture Asset Loader
---------------------------------------------------------------------------------------------------

alter table nm_inv_type_attribs_all disable all triggers;
alter table nm_inv_type_attribs_all add (ita_keep_history_yn varchar2(1) default 'N' not null );
alter table nm_inv_type_attribs_all enable all triggers;

ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL ADD (
  CONSTRAINT ITA_HIST_YN_CHK CHECK (ita_keep_history_yn IN ('Y','N')));

alter table nm_load_files add (nlf_holding_table varchar2(30));

CREATE TABLE NM_LOAD_BATCH_LOCK
(
NLBL_BATCH_ID                     VARCHAR2(200)                     NOT NULL,
NLBL_LOCK_CREATED                 DATE          DEFAULT SYSDATE     NOT NULL
)
/
ALTER TABLE NM_LOAD_BATCH_LOCK
 ADD CONSTRAINT NM_LOAD_BATCH_LOCK_PK PRIMARY KEY 
  (NLBL_BATCH_ID)
/

CREATE TABLE NM_LD_MC_ALL_INV_TMP
(
  BATCH_NO                   NUMBER(9)          NOT NULL,
  RECORD_NO                  NUMBER(9)          NOT NULL,
  IIT_NE_ID                  NUMBER(9)          NOT NULL,
  IIT_INV_TYPE               VARCHAR2(4)        NOT NULL,
  IIT_PRIMARY_KEY            VARCHAR2(50),
  IIT_NE_UNIQUE              VARCHAR2(30),
  IIT_NE_NT_TYPE             VARCHAR2(4),
  NE_ID                      NUMBER,
  NM_START                   NUMBER,
  NM_END                     NUMBER,
  NAU_UNIT_CODE              VARCHAR2(10),
  IIT_START_DATE             DATE               NOT NULL,
  IIT_DATE_CREATED           DATE               NOT NULL,
  IIT_DATE_MODIFIED          DATE               NOT NULL,
  IIT_CREATED_BY             VARCHAR2(30)       NOT NULL,
  IIT_MODIFIED_BY            VARCHAR2(30)       NOT NULL,
  IIT_ADMIN_UNIT             NUMBER(9)          NOT NULL,
  IIT_DESCR                  VARCHAR2(40),
  IIT_END_DATE               DATE,
  IIT_FOREIGN_KEY            VARCHAR2(50),
  IIT_LOCATED_BY             NUMBER(9),
  IIT_POSITION               NUMBER,
  IIT_X_COORD                NUMBER,
  IIT_Y_COORD                NUMBER,
  IIT_NUM_ATTRIB16           NUMBER,
  IIT_NUM_ATTRIB17           NUMBER,
  IIT_NUM_ATTRIB18           NUMBER,
  IIT_NUM_ATTRIB19           NUMBER,
  IIT_NUM_ATTRIB20           NUMBER,
  IIT_NUM_ATTRIB21           NUMBER,
  IIT_NUM_ATTRIB22           NUMBER,
  IIT_NUM_ATTRIB23           NUMBER,
  IIT_NUM_ATTRIB24           NUMBER,
  IIT_NUM_ATTRIB25           NUMBER,
  IIT_CHR_ATTRIB26           VARCHAR2(50),
  IIT_CHR_ATTRIB27           VARCHAR2(50),
  IIT_CHR_ATTRIB28           VARCHAR2(50),
  IIT_CHR_ATTRIB29           VARCHAR2(50),
  IIT_CHR_ATTRIB30           VARCHAR2(50),
  IIT_CHR_ATTRIB31           VARCHAR2(50),
  IIT_CHR_ATTRIB32           VARCHAR2(50),
  IIT_CHR_ATTRIB33           VARCHAR2(50),
  IIT_CHR_ATTRIB34           VARCHAR2(50),
  IIT_CHR_ATTRIB35           VARCHAR2(50),
  IIT_CHR_ATTRIB36           VARCHAR2(50),
  IIT_CHR_ATTRIB37           VARCHAR2(50),
  IIT_CHR_ATTRIB38           VARCHAR2(50),
  IIT_CHR_ATTRIB39           VARCHAR2(50),
  IIT_CHR_ATTRIB40           VARCHAR2(50),
  IIT_CHR_ATTRIB41           VARCHAR2(50),
  IIT_CHR_ATTRIB42           VARCHAR2(50),
  IIT_CHR_ATTRIB43           VARCHAR2(50),
  IIT_CHR_ATTRIB44           VARCHAR2(50),
  IIT_CHR_ATTRIB45           VARCHAR2(50),
  IIT_CHR_ATTRIB46           VARCHAR2(50),
  IIT_CHR_ATTRIB47           VARCHAR2(50),
  IIT_CHR_ATTRIB48           VARCHAR2(50),
  IIT_CHR_ATTRIB49           VARCHAR2(50),
  IIT_CHR_ATTRIB50           VARCHAR2(50),
  IIT_CHR_ATTRIB51           VARCHAR2(50),
  IIT_CHR_ATTRIB52           VARCHAR2(50),
  IIT_CHR_ATTRIB53           VARCHAR2(50),
  IIT_CHR_ATTRIB54           VARCHAR2(50),
  IIT_CHR_ATTRIB55           VARCHAR2(50),
  IIT_CHR_ATTRIB56           VARCHAR2(200),
  IIT_CHR_ATTRIB57           VARCHAR2(200),
  IIT_CHR_ATTRIB58           VARCHAR2(200),
  IIT_CHR_ATTRIB59           VARCHAR2(200),
  IIT_CHR_ATTRIB60           VARCHAR2(200),
  IIT_CHR_ATTRIB61           VARCHAR2(200),
  IIT_CHR_ATTRIB62           VARCHAR2(200),
  IIT_CHR_ATTRIB63           VARCHAR2(200),
  IIT_CHR_ATTRIB64           VARCHAR2(200),
  IIT_CHR_ATTRIB65           VARCHAR2(200),
  IIT_CHR_ATTRIB66           VARCHAR2(500),
  IIT_CHR_ATTRIB67           VARCHAR2(500),
  IIT_CHR_ATTRIB68           VARCHAR2(500),
  IIT_CHR_ATTRIB69           VARCHAR2(500),
  IIT_CHR_ATTRIB70           VARCHAR2(500),
  IIT_CHR_ATTRIB71           VARCHAR2(500),
  IIT_CHR_ATTRIB72           VARCHAR2(500),
  IIT_CHR_ATTRIB73           VARCHAR2(500),
  IIT_CHR_ATTRIB74           VARCHAR2(500),
  IIT_CHR_ATTRIB75           VARCHAR2(500),
  IIT_NUM_ATTRIB76           NUMBER,
  IIT_NUM_ATTRIB77           NUMBER,
  IIT_NUM_ATTRIB78           NUMBER,
  IIT_NUM_ATTRIB79           NUMBER,
  IIT_NUM_ATTRIB80           NUMBER,
  IIT_NUM_ATTRIB81           NUMBER,
  IIT_NUM_ATTRIB82           NUMBER,
  IIT_NUM_ATTRIB83           NUMBER,
  IIT_NUM_ATTRIB84           NUMBER,
  IIT_NUM_ATTRIB85           NUMBER,
  IIT_DATE_ATTRIB86          DATE,
  IIT_DATE_ATTRIB87          DATE,
  IIT_DATE_ATTRIB88          DATE,
  IIT_DATE_ATTRIB89          DATE,
  IIT_DATE_ATTRIB90          DATE,
  IIT_DATE_ATTRIB91          DATE,
  IIT_DATE_ATTRIB92          DATE,
  IIT_DATE_ATTRIB93          DATE,
  IIT_DATE_ATTRIB94          DATE,
  IIT_DATE_ATTRIB95          DATE,
  IIT_ANGLE                  NUMBER(6,2),
  IIT_ANGLE_TXT              VARCHAR2(20),
  IIT_CLASS                  VARCHAR2(2),
  IIT_CLASS_TXT              VARCHAR2(20),
  IIT_COLOUR                 VARCHAR2(2),
  IIT_COLOUR_TXT             VARCHAR2(20),
  IIT_COORD_FLAG             VARCHAR2(1),
  IIT_DESCRIPTION            VARCHAR2(40),
  IIT_DIAGRAM                VARCHAR2(6),
  IIT_DISTANCE               NUMBER(7,2),
  IIT_END_CHAIN              NUMBER(6),
  IIT_GAP                    NUMBER(6,2),
  IIT_HEIGHT                 NUMBER(6,2),
  IIT_HEIGHT_2               NUMBER(6,2),
  IIT_ID_CODE                VARCHAR2(8),
  IIT_INSTAL_DATE            DATE,
  IIT_INVENT_DATE            DATE,
  IIT_INV_OWNERSHIP          VARCHAR2(4),
  IIT_ITEMCODE               VARCHAR2(8),
  IIT_LCO_LAMP_CONFIG_ID     NUMBER(3),
  IIT_LENGTH                 NUMBER(6),
  IIT_MATERIAL               VARCHAR2(30),
  IIT_MATERIAL_TXT           VARCHAR2(20),
  IIT_METHOD                 VARCHAR2(2),
  IIT_METHOD_TXT             VARCHAR2(20),
  IIT_NOTE                   VARCHAR2(40),
  IIT_NO_OF_UNITS            NUMBER(3),
  IIT_OPTIONS                VARCHAR2(2),
  IIT_OPTIONS_TXT            VARCHAR2(20),
  IIT_OUN_ORG_ID_ELEC_BOARD  NUMBER(8),
  IIT_OWNER                  VARCHAR2(4),
  IIT_OWNER_TXT              VARCHAR2(20),
  IIT_PEO_INVENT_BY_ID       NUMBER(8),
  IIT_PHOTO                  VARCHAR2(6),
  IIT_POWER                  NUMBER(6),
  IIT_PROV_FLAG              VARCHAR2(1),
  IIT_REV_BY                 VARCHAR2(20),
  IIT_REV_DATE               DATE,
  IIT_TYPE                   VARCHAR2(2),
  IIT_TYPE_TXT               VARCHAR2(20),
  IIT_WIDTH                  NUMBER(6,2),
  IIT_XTRA_CHAR_1            VARCHAR2(20),
  IIT_XTRA_DATE_1            DATE,
  IIT_XTRA_DOMAIN_1          VARCHAR2(2),
  IIT_XTRA_DOMAIN_TXT_1      VARCHAR2(20),
  IIT_XTRA_NUMBER_1          NUMBER(10,2),
  IIT_X_SECT                 VARCHAR2(4),
  IIT_DET_XSP                VARCHAR2(4),
  IIT_OFFSET                 NUMBER,
  IIT_X                      NUMBER,
  IIT_Y                      NUMBER,
  IIT_Z                      NUMBER,
  IIT_NUM_ATTRIB96           NUMBER,
  IIT_NUM_ATTRIB97           NUMBER,
  IIT_NUM_ATTRIB98           NUMBER,
  IIT_NUM_ATTRIB99           NUMBER,
  IIT_NUM_ATTRIB100          NUMBER,
  IIT_NUM_ATTRIB101          NUMBER,
  IIT_NUM_ATTRIB102          NUMBER,
  IIT_NUM_ATTRIB103          NUMBER,
  IIT_NUM_ATTRIB104          NUMBER,
  IIT_NUM_ATTRIB105          NUMBER,
  IIT_NUM_ATTRIB106          NUMBER,
  IIT_NUM_ATTRIB107          NUMBER,
  IIT_NUM_ATTRIB108          NUMBER,
  IIT_NUM_ATTRIB109          NUMBER,
  IIT_NUM_ATTRIB110          NUMBER,
  IIT_NUM_ATTRIB111          NUMBER,
  IIT_NUM_ATTRIB112          NUMBER,
  IIT_NUM_ATTRIB113          NUMBER,
  IIT_NUM_ATTRIB114          NUMBER,
  IIT_NUM_ATTRIB115          NUMBER,
  NLM_ERROR_STATUS           NUMBER(1) DEFAULT 0 NOT NULL,
  NLM_ACTION_CODE            VARCHAR2(1),
  NLM_X_SECT                 VARCHAR2(4),
  NLM_INVENT_DATE            DATE,
  NLM_PRIMARY_KEY            VARCHAR2(50)
)
/

ALTER TABLE NM_LD_MC_ALL_INV_TMP
 ADD CONSTRAINT NM_LD_MC_ALL_INV_TMP_PK PRIMARY KEY 
  (BATCH_NO
  ,RECORD_NO)
/
--  
Prompt Adding Who columns to NM_INV_ATTRI_LOOKUP_ALL
ALTER TABLE NM_INV_ATTRI_LOOKUP_ALL DISABLE ALL TRIGGERS;
ALTER TABLE NM_INV_ATTRI_LOOKUP_ALL ADD IAL_DATE_CREATED             DATE;
ALTER TABLE NM_INV_ATTRI_LOOKUP_ALL ADD IAL_DATE_MODIFIED            DATE;
ALTER TABLE NM_INV_ATTRI_LOOKUP_ALL ADD IAL_MODIFIED_BY              VARCHAR2(30);
ALTER TABLE NM_INV_ATTRI_LOOKUP_ALL ADD IAL_CREATED_BY               VARCHAR2(30);
 
 UPDATE NM_INV_ATTRI_LOOKUP_ALL SET IAL_DATE_CREATED  = SYSDATE   , IAL_DATE_MODIFIED = SYSDATE   , IAL_MODIFIED_BY   = USER   , IAL_CREATED_BY    = USER;
 COMMIT;
 
ALTER TABLE NM_INV_ATTRI_LOOKUP_ALL MODIFY IAL_DATE_CREATED             NOT NULL;
ALTER TABLE NM_INV_ATTRI_LOOKUP_ALL MODIFY IAL_DATE_MODIFIED            NOT NULL;
ALTER TABLE NM_INV_ATTRI_LOOKUP_ALL MODIFY IAL_MODIFIED_BY              NOT NULL;
ALTER TABLE NM_INV_ATTRI_LOOKUP_ALL MODIFY IAL_CREATED_BY               NOT NULL;
ALTER TABLE NM_INV_ATTRI_LOOKUP_ALL ENABLE ALL TRIGGERS;
-- 
Prompt Adding Who columns to NM_INV_DOMAINS_ALL
ALTER TABLE NM_INV_DOMAINS_ALL DISABLE ALL TRIGGERS;
ALTER TABLE NM_INV_DOMAINS_ALL ADD ID_DATE_CREATED             DATE;
ALTER TABLE NM_INV_DOMAINS_ALL ADD ID_DATE_MODIFIED            DATE;
ALTER TABLE NM_INV_DOMAINS_ALL ADD ID_MODIFIED_BY              VARCHAR2(30);
ALTER TABLE NM_INV_DOMAINS_ALL ADD ID_CREATED_BY               VARCHAR2(30);
 
 UPDATE NM_INV_DOMAINS_ALL SET ID_DATE_CREATED  = SYSDATE   , ID_DATE_MODIFIED = SYSDATE   , ID_MODIFIED_BY   = USER   , ID_CREATED_BY    = USER;
 COMMIT;
 
ALTER TABLE NM_INV_DOMAINS_ALL MODIFY ID_DATE_CREATED             NOT NULL;
ALTER TABLE NM_INV_DOMAINS_ALL MODIFY ID_DATE_MODIFIED            NOT NULL;
ALTER TABLE NM_INV_DOMAINS_ALL MODIFY ID_MODIFIED_BY              NOT NULL;
ALTER TABLE NM_INV_DOMAINS_ALL MODIFY ID_CREATED_BY               NOT NULL;
ALTER TABLE NM_INV_DOMAINS_ALL ENABLE ALL TRIGGERS;
-- 
Prompt Adding Who columns to NM_INV_TYPES_ALL
ALTER TABLE NM_INV_TYPES_ALL DISABLE ALL TRIGGERS;
ALTER TABLE NM_INV_TYPES_ALL ADD NIT_DATE_CREATED             DATE;
ALTER TABLE NM_INV_TYPES_ALL ADD NIT_DATE_MODIFIED            DATE;
ALTER TABLE NM_INV_TYPES_ALL ADD NIT_MODIFIED_BY              VARCHAR2(30);
ALTER TABLE NM_INV_TYPES_ALL ADD NIT_CREATED_BY               VARCHAR2(30);
 
 --------------------------------------------------------------------------------------------
 -- ensure invsec package that is used by policies is valid before firing any update statement
 --------------------------------------------------------------------------------------------
 ALTER PACKAGE INVSEC COMPILE;
 ALTER PACKAGE INVSEC COMPILE BODY;
 
 UPDATE NM_INV_TYPES_ALL SET NIT_DATE_CREATED  = SYSDATE   , NIT_DATE_MODIFIED = SYSDATE   , NIT_MODIFIED_BY   = USER   , NIT_CREATED_BY    = USER;
 COMMIT;
 
ALTER TABLE NM_INV_TYPES_ALL MODIFY NIT_DATE_CREATED             NOT NULL;
ALTER TABLE NM_INV_TYPES_ALL MODIFY NIT_DATE_MODIFIED            NOT NULL;
ALTER TABLE NM_INV_TYPES_ALL MODIFY NIT_MODIFIED_BY              NOT NULL;
ALTER TABLE NM_INV_TYPES_ALL MODIFY NIT_CREATED_BY               NOT NULL;
ALTER TABLE NM_INV_TYPES_ALL ENABLE ALL TRIGGERS;
-- 
Prompt Adding Who columns to NM_INV_TYPE_ATTRIBS_ALL
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL DISABLE ALL TRIGGERS;
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL ADD ITA_DATE_CREATED             DATE;
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL ADD ITA_DATE_MODIFIED            DATE;
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL ADD ITA_MODIFIED_BY              VARCHAR2(30);
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL ADD ITA_CREATED_BY               VARCHAR2(30);
 
 UPDATE NM_INV_TYPE_ATTRIBS_ALL SET ITA_DATE_CREATED  = SYSDATE   , ITA_DATE_MODIFIED = SYSDATE   , ITA_MODIFIED_BY   = USER   , ITA_CREATED_BY    = USER;
 COMMIT;
 
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL MODIFY ITA_DATE_CREATED             NOT NULL;
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL MODIFY ITA_DATE_MODIFIED            NOT NULL;
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL MODIFY ITA_MODIFIED_BY              NOT NULL;
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL MODIFY ITA_CREATED_BY               NOT NULL;
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL ENABLE ALL TRIGGERS;
--
Prompt Adding Who columns to NM_INV_TYPE_GROUPINGS_ALL
ALTER TABLE NM_INV_TYPE_GROUPINGS_ALL DISABLE ALL TRIGGERS;
ALTER TABLE NM_INV_TYPE_GROUPINGS_ALL ADD ITG_DATE_CREATED             DATE;
ALTER TABLE NM_INV_TYPE_GROUPINGS_ALL ADD ITG_DATE_MODIFIED            DATE;
ALTER TABLE NM_INV_TYPE_GROUPINGS_ALL ADD ITG_MODIFIED_BY              VARCHAR2(30);
ALTER TABLE NM_INV_TYPE_GROUPINGS_ALL ADD ITG_CREATED_BY               VARCHAR2(30);

 --------------------------------------------------------------------------------------------
 -- ensure invsec package that is used by policies is valid before firing any update statement
 --------------------------------------------------------------------------------------------
 ALTER PACKAGE INVSEC COMPILE;
 ALTER PACKAGE INVSEC COMPILE BODY;
 
 UPDATE NM_INV_TYPE_GROUPINGS_ALL SET ITG_DATE_CREATED  = SYSDATE   , ITG_DATE_MODIFIED = SYSDATE   , ITG_MODIFIED_BY   = USER   , ITG_CREATED_BY    = USER;
 COMMIT;
 
 
ALTER TABLE NM_INV_TYPE_GROUPINGS_ALL MODIFY ITG_DATE_CREATED             NOT NULL;
ALTER TABLE NM_INV_TYPE_GROUPINGS_ALL MODIFY ITG_DATE_MODIFIED            NOT NULL;
ALTER TABLE NM_INV_TYPE_GROUPINGS_ALL MODIFY ITG_MODIFIED_BY              NOT NULL;
ALTER TABLE NM_INV_TYPE_GROUPINGS_ALL MODIFY ITG_CREATED_BY               NOT NULL;
ALTER TABLE NM_INV_TYPE_GROUPINGS_ALL ENABLE ALL TRIGGERS;
-- 
Prompt Adding Who columns to NM_XSP
ALTER TABLE NM_XSP DISABLE ALL TRIGGERS;
ALTER TABLE NM_XSP ADD NWX_DATE_CREATED             DATE;
ALTER TABLE NM_XSP ADD NWX_DATE_MODIFIED            DATE;
ALTER TABLE NM_XSP ADD NWX_MODIFIED_BY              VARCHAR2(30);
ALTER TABLE NM_XSP ADD NWX_CREATED_BY               VARCHAR2(30);
 
 UPDATE NM_XSP SET NWX_DATE_CREATED  = SYSDATE   , NWX_DATE_MODIFIED = SYSDATE   , NWX_MODIFIED_BY   = USER   , NWX_CREATED_BY    = USER;
 COMMIT;
 
ALTER TABLE NM_XSP MODIFY NWX_DATE_CREATED             NOT NULL;
ALTER TABLE NM_XSP MODIFY NWX_DATE_MODIFIED            NOT NULL;
ALTER TABLE NM_XSP MODIFY NWX_MODIFIED_BY              NOT NULL;
ALTER TABLE NM_XSP MODIFY NWX_CREATED_BY               NOT NULL;
ALTER TABLE NM_XSP ENABLE ALL TRIGGERS;
-- 
Prompt Adding Who columns to XSP_RESTRAINTS
ALTER TABLE XSP_RESTRAINTS DISABLE ALL TRIGGERS;
ALTER TABLE XSP_RESTRAINTS ADD XSR_DATE_CREATED             DATE;
ALTER TABLE XSP_RESTRAINTS ADD XSR_DATE_MODIFIED            DATE;
ALTER TABLE XSP_RESTRAINTS ADD XSR_MODIFIED_BY              VARCHAR2(30);
ALTER TABLE XSP_RESTRAINTS ADD XSR_CREATED_BY               VARCHAR2(30);
 
 UPDATE XSP_RESTRAINTS SET XSR_DATE_CREATED  = SYSDATE   , XSR_DATE_MODIFIED = SYSDATE   , XSR_MODIFIED_BY   = USER   , XSR_CREATED_BY    = USER;
 COMMIT;
 
ALTER TABLE XSP_RESTRAINTS MODIFY XSR_DATE_CREATED             NOT NULL;
ALTER TABLE XSP_RESTRAINTS MODIFY XSR_DATE_MODIFIED            NOT NULL;
ALTER TABLE XSP_RESTRAINTS MODIFY XSR_MODIFIED_BY              NOT NULL;
ALTER TABLE XSP_RESTRAINTS MODIFY XSR_CREATED_BY               NOT NULL;
ALTER TABLE XSP_RESTRAINTS ENABLE ALL TRIGGERS;
--  
---------------------------------------------------------------------------------------------------
--End of MapCapture Asset Loader
---------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------
--
--             **************** END OF TABLE UPGRADES *******************
--
---------------------------------------------------------------------------------------------------
--

---------------------------------------------------------------------------------------------------
--                      **************** PACKAGES *******************
---------------------------------------------------------------------------------------------------
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3load_inv_failed.pkh' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3load_inv_failed.pkw' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3pedif.pkh' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3pedif.pkw' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3xml_load.pkh' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3xml_load.pkw' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3inv_view.pkh' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3inv_view.pkw' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3load.pkh' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3load.pkw' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3mapcapture_int.pkh' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3mapcapture_int.pkw' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3mapcapture_ins_inv.pkh' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3mapcapture_ins_inv.pkw' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3file.pkh' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3file.pkw' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3type.pkh' run_file
FROM dual
/
--
START '&run_file'
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3web_mail.pkh' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3web_mail.pkw' run_file
FROM dual
/
--
START '&run_file'
--
START '&run_file'
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3web_load.pkh' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3web_load.pkw' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3net.pkw' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3reclass.pkw' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3homo.pkw' run_file
FROM dual
/
--
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'pck'||'&terminator'||'nm3lrs.pkw' run_file
FROM dual
/
--
START '&run_file'
---------------------------------------------------------------------------------------------------
--                      **************** VIEWS *******************
---------------------------------------------------------------------------------------------------
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'views'||'&terminator'||'v_nm_ld_mc_all_inv_batches.vw' run_file
FROM dual
/
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'views'||'&terminator'||'nm_inv_type_attribs.vw' run_file
FROM dual
/
START '&run_file'
--
SET echo OFF
SET term OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'trg'||'&terminator'||'who_trg.sql' run_file
FROM dual
/
START '&run_file'
--
spool OFF
prompt compile_schema_script
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'utl'||'&terminator'||'compile_schema.sql' run_file
FROM dual
/
START '&run_file'
--
spool nm3082_upg_2.LOG
--get some db info
SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG','NET');

START compile_all.sql

------------------------------------------
--The compile_all will have reset the user
--context so we must reinitialise it
------------------------------------------
PROMPT Reinitialising context...
BEGIN
  nm3context.initialise_context;
  nm3user.instantiate_user;
END;
/
--
prompt Adding policies...
--
--
SET feedback OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'ctx'||'&terminator'||'add_policy' run_file
FROM dual
/
START '&&run_file'
--
---------------------------------------------------------------------------------------------------
--                      **************** METADATA *******************
---------------------------------------------------------------------------------------------------
PROMPT Metadata upgrade
SET feedback OFF
SET define ON
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'nm3081_nm3082_metadata_upg' run_file
FROM dual
/
START '&&run_file'
----------------------------------------------------------------------------------------------------
prompt upgrade_the_version_number
DECLARE
   TYPE tab_prod IS TABLE OF hig_products.hpr_product%TYPE INDEX BY BINARY_INTEGER;
   l_tab_prod tab_prod;
BEGIN
   l_tab_prod(1) := 'NET';
   l_tab_prod(2) := 'HIG';
   l_tab_prod(3) := 'DOC';
   FOR i IN 1..l_tab_prod.COUNT
    LOOP
      hig2.upgrade(l_tab_prod(i),'nm3081_nm3082_upg.sql','Upgrade from 3.0.8.1 to 3.0.8.2','3.0.8.2');
   END LOOP;
END;
/
COMMIT;
--
--
--- Run all post upgrade stuff here ---------------------------------------------------------
--
PROMPT Recreating inventory views
BEGIN
  NM3INV_VIEW.CREATE_ALL_INV_VIEWS;
  nm3inv_view.create_all_inv_on_route_view;
END;
/
--
--- /Run all post upgrade stuff here ---------------------------------------------------------
--
SELECT 'Product update to version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG', 'NET', 'DOC');
--
EXIT
