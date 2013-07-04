--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3200_nm3210_ddl_upg.sql	1.24 08/02/05
--       Module Name      : nm3200_nm3210_ddl_upg.sql
--       Date into SCCS   : 05/08/02 11:36:56
--       Date fetched Out : 07/06/13 13:57:58
--       SCCS Version     : 1.24
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
--
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
--
--
--
---------------------------------------------------------------------------------------------------
--          ***************** Start of JM Pop e-mail Changes **************************
--

CREATE TABLE nm_mail_pop_servers
   (nmps_id            NUMBER             NOT NULL
   ,nmps_description   VARCHAR2(80)       NOT NULL
   ,nmps_server_name   VARCHAR2(80)       NOT NULL
   ,nmps_server_port   NUMBER DEFAULT 110 NOT NULL
   ,nmps_username      VARCHAR2(80)       NOT NULL
   ,nmps_password      VARCHAR2(80)       NOT NULL
   ,nmps_timeout       NUMBER DEFAULT 5   NOT NULL
   )
/

ALTER TABLE nm_mail_pop_servers
 ADD CONSTRAINT nmps_pk
 PRIMARY KEY (nmps_id)
/
--
---
--
CREATE TABLE nm_mail_pop_messages
   (nmpm_id            NUMBER              NOT NULL
   ,nmpm_nmps_id       NUMBER              NOT NULL
   ,nmpm_date_created  DATE                NOT NULL
   ,nmpm_date_modified DATE                NOT NULL
   ,nmpm_modified_by   VARCHAR2(30)        NOT NULL
   ,nmpm_created_by    VARCHAR2(30)        NOT NULL
   ,nmpm_status        VARCHAR2(20)        NOT NULL
   )
/

ALTER TABLE nm_mail_pop_messages
 ADD CONSTRAINT nmpm_pk
 PRIMARY KEY (nmpm_id)
/

ALTER TABLE nm_mail_pop_messages
 ADD CONSTRAINT nmpm_nmps_fk
 FOREIGN KEY (nmpm_nmps_id)
 REFERENCES nm_mail_pop_servers (nmps_id)
 ON DELETE CASCADE
/

CREATE INDEX nmpm_nmps_fk_ind ON nm_mail_pop_messages (nmpm_nmps_id)
/
--
---
--
CREATE TABLE nm_mail_pop_message_headers
   (nmpmh_nmpm_id      NUMBER              NOT NULL
   ,nmpmh_header_field VARCHAR2(80)        NOT NULL
   ,nmpmh_header_value VARCHAR2(4000)
   )
/

ALTER TABLE nm_mail_pop_message_headers
 ADD CONSTRAINT nmpmh_pk
 PRIMARY KEY (nmpmh_nmpm_id, nmpmh_header_field)
/

ALTER TABLE nm_mail_pop_message_headers
 ADD CONSTRAINT nmpmh_nmpm_fk
 FOREIGN KEY (nmpmh_nmpm_id)
 REFERENCES nm_mail_pop_messages (nmpm_id)
 ON DELETE CASCADE
/
--
---
--
CREATE TABLE nm_mail_pop_message_details
   (nmpmd_nmpm_id      NUMBER NOT NULL
   ,nmpmd_line_number  NUMBER NOT NULL
   ,nmpmd_text         LONG
   )
/

ALTER TABLE nm_mail_pop_message_details
 ADD CONSTRAINT nmpmd_pk
 PRIMARY KEY (nmpmd_nmpm_id, nmpmd_line_number)
/

ALTER TABLE nm_mail_pop_message_details
 ADD CONSTRAINT nmpmd_nmpm_fk
 FOREIGN KEY (nmpmd_nmpm_id)
 REFERENCES nm_mail_pop_messages (nmpm_id)
 ON DELETE CASCADE
/
--
---
--
CREATE TABLE nm_mail_pop_message_raw
   (nmpmr_nmpm_id      NUMBER NOT NULL
   ,nmpmr_line_number  NUMBER NOT NULL
   ,nmpmr_text         LONG
   )
/

ALTER TABLE nm_mail_pop_message_raw
 ADD CONSTRAINT nmpmr_pk
 PRIMARY KEY (nmpmr_nmpm_id, nmpmr_line_number)
/

ALTER TABLE nm_mail_pop_message_raw
 ADD CONSTRAINT nmpmr_nmpm_fk
 FOREIGN KEY (nmpmr_nmpm_id)
 REFERENCES nm_mail_pop_messages (nmpm_id)
 ON DELETE CASCADE
/
--
---
--
CREATE TABLE nm_mail_pop_processes
   (nmpp_id          NUMBER       NOT NULL
   ,nmpp_descr       VARCHAR2(30) NOT NULL
   ,nmpp_process_seq NUMBER(2)    NOT NULL
   ,nmpp_procedure   VARCHAR2(61) NOT NULL
   ,nmpp_nmps_id     NUMBER
   )
/

ALTER TABLE nm_mail_pop_processes
 ADD CONSTRAINT nmpp_pk
 PRIMARY KEY (nmpp_id)
/

ALTER TABLE nm_mail_pop_processes
 ADD CONSTRAINT nmpp_nmps_fk
 FOREIGN KEY (nmpp_nmps_id)
 REFERENCES nm_mail_pop_servers (nmps_id)
 ON DELETE SET NULL
/

CREATE INDEX nmpp_nmps_fk_ix ON nm_mail_pop_processes (nmpp_nmps_id)
/
--
---
--
CREATE TABLE nm_mail_pop_process_conditions
   (nmppc_nmpp_id      NUMBER              NOT NULL
   ,nmppc_header_field VARCHAR2(80)        NOT NULL
   ,nmppc_header_value VARCHAR2(2000)      NOT NULL
   )
/

ALTER TABLE nm_mail_pop_process_conditions
 ADD CONSTRAINT nmppc_pk
 PRIMARY KEY (nmppc_nmpp_id,nmppc_header_field)
/

ALTER TABLE nm_mail_pop_process_conditions
 ADD CONSTRAINT nmppc_nmpp_fk
 FOREIGN KEY (nmppc_nmpp_id)
 REFERENCES nm_mail_pop_processes (nmpp_id)
 ON DELETE CASCADE
/
--
---
--
CREATE TABLE nm_mail_pop_processing_errors
    (nmppe_nmpm_id       NUMBER         NOT NULL
    ,nmppe_sqlerror_code NUMBER         NOT NULL
    ,nmppe_sqlerror_msg  VARCHAR2(4000) NOT NULL
    )
/


ALTER TABLE nm_mail_pop_processing_errors
 ADD CONSTRAINT nmppe_pk
 PRIMARY KEY (nmppe_nmpm_id)
/

ALTER TABLE nm_mail_pop_processing_errors
 ADD CONSTRAINT nmppe_nmpm_fk
 FOREIGN KEY (nmppe_nmpm_id)
 REFERENCES nm_mail_pop_messages (nmpm_id)
 ON DELETE CASCADE
/
--
---
--
CREATE SEQUENCE nmpp_id_seq
/
CREATE SEQUENCE nmpm_id_seq
/
CREATE SEQUENCE nmps_id_seq
/
--
---------------------------------------------------------------------------------------------------
--          ***************** End of JM Pop e-mail Changes **************************
--


-----------------------------------------------------------------------
-- Inv type attribs changes - column added at 3210 but not yet utilised
-----------------------------------------------------------------------
ALTER TABLE NM_INV_TYPE_ATTRIBS_ALL ADD(ITA_QUERY VARCHAR2(240))
/

--
---------------------------------------------------------------------------------------------------
--          ***************** Start of Admin Unit Changes  **************************
--
alter table nm_admin_units_all add (NAU_NSTY_SUB_TYPE            VARCHAR2(4))
/
alter table nm_admin_units_all add (NAU_PREFIX            VARCHAR2(10))
/
alter table nm_admin_units_all add (  NAU_POSTCODE          VARCHAR2(10))
/
alter table nm_admin_units_all add (  NAU_MINOR_UNDERTAKER  VARCHAR2(1))
/
alter table nm_admin_units_all add (  NAU_TCPIP             VARCHAR2(15))
/
alter table nm_admin_units_all add (  NAU_DOMAIN            VARCHAR2(100))
/
alter table nm_admin_units_all add (  NAU_DIRECTORY         VARCHAR2(100))
/
--
----------------
--
CREATE TABLE NM_AU_SUB_TYPES
(
  NSTY_ID               NUMBER(38)         NOT NULL,
  NSTY_NAT_ADMIN_TYPE   VARCHAR2(4)        NOT NULL,
  NSTY_SUB_TYPE         VARCHAR2(4)        NOT NULL,
  NSTY_DESCR            VARCHAR2(80)       NOT NULL,
  NSTY_PARENT_SUB_TYPE  VARCHAR2(4),
  NSTY_NGT_GROUP_TYPE   VARCHAR2(4),
  NSTY_DATE_CREATED     DATE               NOT NULL,
  NSTY_DATE_MODIFIED    DATE               NOT NULL,
  NSTY_MODIFIED_BY      VARCHAR2(30)       NOT NULL,
  NSTY_CREATED_BY       VARCHAR2(30)       NOT NULL
);

CREATE UNIQUE INDEX NSTY_UK1 ON NM_AU_SUB_TYPES
(NSTY_NAT_ADMIN_TYPE, NSTY_SUB_TYPE);

ALTER TABLE NM_AU_SUB_TYPES ADD (
  CONSTRAINT NSTY_PK PRIMARY KEY (NSTY_ID));



ALTER TABLE NM_AU_SUB_TYPES ADD (
  CONSTRAINT NSTY_UK1 UNIQUE (NSTY_NAT_ADMIN_TYPE, NSTY_SUB_TYPE));



ALTER TABLE NM_AU_SUB_TYPES ADD (
  CONSTRAINT NSTY_NAT_FK FOREIGN KEY (NSTY_NAT_ADMIN_TYPE)
    REFERENCES NM_AU_TYPES (NAT_ADMIN_TYPE));

ALTER TABLE NM_AU_SUB_TYPES ADD (
  CONSTRAINT NSTY_NGT_FK FOREIGN KEY (NSTY_NGT_GROUP_TYPE)
    REFERENCES NM_GROUP_TYPES_ALL (NGT_GROUP_TYPE));



create sequence nsty_id_seq
/
--
----------------
--
CREATE TABLE NM_AU_TYPES_GROUPINGS
(
  NATG_GROUPING        VARCHAR2(20)        NOT NULL,
  NATG_NAT_ADMIN_TYPE  VARCHAR2(4)         NOT NULL
)
/

ALTER TABLE NM_AU_TYPES_GROUPINGS ADD (
  CONSTRAINT NATG_PK PRIMARY KEY (NATG_NAT_ADMIN_TYPE,NATG_GROUPING))
/


--
---------------------------------------------------------------------------------------------------
--          ***************** End of Admin Unit Changes  **************************
--

--
---------------------------------------------------------------------------------------------------
--          ***************** Start of Locator changes **************************
--
-- Disable triggers to prevent errors when ita_displayed added to table with a default value
--
alter trigger  nm_inv_type_attribs_excl_trg disable;
alter trigger  nm_inv_type_attribs_all_dt_trg disable;
alter trigger  nm_inv_type_attribs_b_iu_trg disable;
alter trigger  nm_inv_type_attribs_all_who disable;


ALTER TABLE nm_inv_type_attribs_all ADD (ita_displayed varchar2(1) DEFAULT 'Y');

ALTER TABLE nm_inv_type_attribs_all MODIFY (ita_displayed NOT NULL);

ALTER TABLE nm_inv_type_attribs_all ADD CONSTRAINT ita_displayed_chk CHECK (ita_displayed IN ('Y', 'N'));

ALTER TABLE nm_inv_type_attribs_all ADD (ita_disp_width NUMBER(3));


alter trigger  nm_inv_type_attribs_excl_trg enable;
alter trigger  nm_inv_type_attribs_all_dt_trg enable;
alter trigger  nm_inv_type_attribs_b_iu_trg enable;
alter trigger  nm_inv_type_attribs_all_who enable;


CREATE GLOBAL TEMPORARY TABLE NM_LOCATOR_RESULTS
(
  IIT_NE_ID                  NUMBER(9),
  IIT_INV_TYPE               VARCHAR2(4),
  IIT_PRIMARY_KEY            VARCHAR2(80),
  IIT_START_DATE             DATE,
  IIT_DATE_CREATED           DATE,
  IIT_DATE_MODIFIED          DATE,
  IIT_CREATED_BY             VARCHAR2(30),
  IIT_MODIFIED_BY            VARCHAR2(30),
  IIT_ADMIN_UNIT             NUMBER(9),
  IIT_DESCR                  VARCHAR2(40),
  IIT_END_DATE               DATE,
  IIT_FOREIGN_KEY            VARCHAR2(80),
  IIT_LOCATED_BY             NUMBER(9),
  IIT_POSITION               VARCHAR2(80),
  IIT_X_COORD                VARCHAR2(80),
  IIT_Y_COORD                VARCHAR2(80),
  IIT_NUM_ATTRIB16           VARCHAR2(80),
  IIT_NUM_ATTRIB17           VARCHAR2(80),
  IIT_NUM_ATTRIB18           VARCHAR2(80),
  IIT_NUM_ATTRIB19           VARCHAR2(80),
  IIT_NUM_ATTRIB20           VARCHAR2(80),
  IIT_NUM_ATTRIB21           VARCHAR2(80),
  IIT_NUM_ATTRIB22           VARCHAR2(80),
  IIT_NUM_ATTRIB23           VARCHAR2(80),
  IIT_NUM_ATTRIB24           VARCHAR2(80),
  IIT_NUM_ATTRIB25           VARCHAR2(80),
  IIT_CHR_ATTRIB26           VARCHAR2(80),
  IIT_CHR_ATTRIB27           VARCHAR2(80),
  IIT_CHR_ATTRIB28           VARCHAR2(80),
  IIT_CHR_ATTRIB29           VARCHAR2(80),
  IIT_CHR_ATTRIB30           VARCHAR2(80),
  IIT_CHR_ATTRIB31           VARCHAR2(80),
  IIT_CHR_ATTRIB32           VARCHAR2(80),
  IIT_CHR_ATTRIB33           VARCHAR2(80),
  IIT_CHR_ATTRIB34           VARCHAR2(80),
  IIT_CHR_ATTRIB35           VARCHAR2(80),
  IIT_CHR_ATTRIB36           VARCHAR2(80),
  IIT_CHR_ATTRIB37           VARCHAR2(80),
  IIT_CHR_ATTRIB38           VARCHAR2(80),
  IIT_CHR_ATTRIB39           VARCHAR2(80),
  IIT_CHR_ATTRIB40           VARCHAR2(80),
  IIT_CHR_ATTRIB41           VARCHAR2(80),
  IIT_CHR_ATTRIB42           VARCHAR2(80),
  IIT_CHR_ATTRIB43           VARCHAR2(80),
  IIT_CHR_ATTRIB44           VARCHAR2(80),
  IIT_CHR_ATTRIB45           VARCHAR2(80),
  IIT_CHR_ATTRIB46           VARCHAR2(80),
  IIT_CHR_ATTRIB47           VARCHAR2(80),
  IIT_CHR_ATTRIB48           VARCHAR2(80),
  IIT_CHR_ATTRIB49           VARCHAR2(80),
  IIT_CHR_ATTRIB50           VARCHAR2(80),
  IIT_CHR_ATTRIB51           VARCHAR2(80),
  IIT_CHR_ATTRIB52           VARCHAR2(80),
  IIT_CHR_ATTRIB53           VARCHAR2(80),
  IIT_CHR_ATTRIB54           VARCHAR2(80),
  IIT_CHR_ATTRIB55           VARCHAR2(80),
  IIT_CHR_ATTRIB56           VARCHAR2(80),
  IIT_CHR_ATTRIB57           VARCHAR2(80),
  IIT_CHR_ATTRIB58           VARCHAR2(80),
  IIT_CHR_ATTRIB59           VARCHAR2(80),
  IIT_CHR_ATTRIB60           VARCHAR2(80),
  IIT_CHR_ATTRIB61           VARCHAR2(80),
  IIT_CHR_ATTRIB62           VARCHAR2(80),
  IIT_CHR_ATTRIB63           VARCHAR2(80),
  IIT_CHR_ATTRIB64           VARCHAR2(80),
  IIT_CHR_ATTRIB65           VARCHAR2(80),
  IIT_CHR_ATTRIB66           VARCHAR2(80),
  IIT_CHR_ATTRIB67           VARCHAR2(80),
  IIT_CHR_ATTRIB68           VARCHAR2(80),
  IIT_CHR_ATTRIB69           VARCHAR2(80),
  IIT_CHR_ATTRIB70           VARCHAR2(80),
  IIT_CHR_ATTRIB71           VARCHAR2(80),
  IIT_CHR_ATTRIB72           VARCHAR2(80),
  IIT_CHR_ATTRIB73           VARCHAR2(80),
  IIT_CHR_ATTRIB74           VARCHAR2(80),
  IIT_CHR_ATTRIB75           VARCHAR2(80),
  IIT_NUM_ATTRIB76           VARCHAR2(80),
  IIT_NUM_ATTRIB77           VARCHAR2(80),
  IIT_NUM_ATTRIB78           VARCHAR2(80),
  IIT_NUM_ATTRIB79           VARCHAR2(80),
  IIT_NUM_ATTRIB80           VARCHAR2(80),
  IIT_NUM_ATTRIB81           VARCHAR2(80),
  IIT_NUM_ATTRIB82           VARCHAR2(80),
  IIT_NUM_ATTRIB83           VARCHAR2(80),
  IIT_NUM_ATTRIB84           VARCHAR2(80),
  IIT_NUM_ATTRIB85           VARCHAR2(80),
  IIT_DATE_ATTRIB86          VARCHAR2(80),
  IIT_DATE_ATTRIB87          VARCHAR2(80),
  IIT_DATE_ATTRIB88          VARCHAR2(80),
  IIT_DATE_ATTRIB89          VARCHAR2(80),
  IIT_DATE_ATTRIB90          VARCHAR2(80),
  IIT_DATE_ATTRIB91          VARCHAR2(80),
  IIT_DATE_ATTRIB92          VARCHAR2(80),
  IIT_DATE_ATTRIB93          VARCHAR2(80),
  IIT_DATE_ATTRIB94          VARCHAR2(80),
  IIT_DATE_ATTRIB95          VARCHAR2(80),
  IIT_ANGLE                  VARCHAR2(80),
  IIT_ANGLE_TXT              VARCHAR2(80),
  IIT_CLASS                  VARCHAR2(80),
  IIT_CLASS_TXT              VARCHAR2(80),
  IIT_COLOUR                 VARCHAR2(80),
  IIT_COLOUR_TXT             VARCHAR2(80),
  IIT_COORD_FLAG             VARCHAR2(80),
  IIT_DESCRIPTION            VARCHAR2(80),
  IIT_DIAGRAM                VARCHAR2(80),
  IIT_DISTANCE               VARCHAR2(80),
  IIT_END_CHAIN              VARCHAR2(80),
  IIT_GAP                    VARCHAR2(80),
  IIT_HEIGHT                 VARCHAR2(80),
  IIT_HEIGHT_2               VARCHAR2(80),
  IIT_ID_CODE                VARCHAR2(80),
  IIT_INSTAL_DATE            VARCHAR2(80),
  IIT_INVENT_DATE            VARCHAR2(80),
  IIT_INV_OWNERSHIP          VARCHAR2(80),
  IIT_ITEMCODE               VARCHAR2(80),
  IIT_LCO_LAMP_CONFIG_ID     VARCHAR2(80),
  IIT_LENGTH                 VARCHAR2(80),
  IIT_MATERIAL               VARCHAR2(80),
  IIT_MATERIAL_TXT           VARCHAR2(80),
  IIT_METHOD                 VARCHAR2(80),
  IIT_METHOD_TXT             VARCHAR2(80),
  IIT_NOTE                   VARCHAR2(40),
  IIT_NO_OF_UNITS            VARCHAR2(80),
  IIT_OPTIONS                VARCHAR2(80),
  IIT_OPTIONS_TXT            VARCHAR2(80),
  IIT_OUN_ORG_ID_ELEC_BOARD  VARCHAR2(80),
  IIT_OWNER                  VARCHAR2(80),
  IIT_OWNER_TXT              VARCHAR2(80),
  IIT_PEO_INVENT_BY_ID       NUMBER(8),
  IIT_PHOTO                  VARCHAR2(80),
  IIT_POWER                  VARCHAR2(80),
  IIT_PROV_FLAG              VARCHAR2(80),
  IIT_REV_BY                 VARCHAR2(80),
  IIT_REV_DATE               VARCHAR2(80),
  IIT_TYPE                   VARCHAR2(80),
  IIT_TYPE_TXT               VARCHAR2(80),
  IIT_WIDTH                  VARCHAR2(80),
  IIT_XTRA_CHAR_1            VARCHAR2(80),
  IIT_XTRA_DATE_1            VARCHAR2(80),
  IIT_XTRA_DOMAIN_1          VARCHAR2(80),
  IIT_XTRA_DOMAIN_TXT_1      VARCHAR2(80),
  IIT_XTRA_NUMBER_1          VARCHAR2(80),
  IIT_X_SECT                 VARCHAR2(80),
  IIT_DET_XSP                VARCHAR2(80),
  IIT_OFFSET                 VARCHAR2(80),
  IIT_X                      VARCHAR2(80),
  IIT_Y                      VARCHAR2(80),
  IIT_Z                      VARCHAR2(80),
  IIT_NUM_ATTRIB96           VARCHAR2(80),
  IIT_NUM_ATTRIB97           VARCHAR2(80),
  IIT_NUM_ATTRIB98           VARCHAR2(80),
  IIT_NUM_ATTRIB99           VARCHAR2(80),
  IIT_NUM_ATTRIB100          VARCHAR2(80),
  IIT_NUM_ATTRIB101          VARCHAR2(80),
  IIT_NUM_ATTRIB102          VARCHAR2(80),
  IIT_NUM_ATTRIB103          VARCHAR2(80),
  IIT_NUM_ATTRIB104          VARCHAR2(80),
  IIT_NUM_ATTRIB105          VARCHAR2(80),
  IIT_NUM_ATTRIB106          VARCHAR2(80),
  IIT_NUM_ATTRIB107          VARCHAR2(80),
  IIT_NUM_ATTRIB108          VARCHAR2(80),
  IIT_NUM_ATTRIB109          VARCHAR2(80),
  IIT_NUM_ATTRIB110          VARCHAR2(80),
  IIT_NUM_ATTRIB111          VARCHAR2(80),
  IIT_NUM_ATTRIB112          VARCHAR2(80),
  IIT_NUM_ATTRIB113          VARCHAR2(80),
  IIT_NUM_ATTRIB114          VARCHAR2(80),
  IIT_NUM_ATTRIB115          VARCHAR2(80)
)
ON COMMIT PRESERVE ROWS
NOCACHE
/


CREATE UNIQUE INDEX NLR_PK ON NM_LOCATOR_RESULTS
(IIT_NE_ID)
/


--
---------------------------------------------------------------------------------------------------
--          ***************** End of Locator changes   **************************
--
----------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
--CN Increased column sizes
-------------------------------------------------------------------------------------------------------
--LOG 699327
-------------------------------------------------------------------------------------------------------
ALTER TABLE doc_locations
MODIFY (DLC_URL_PATHNAME varchar2(4000));

ALTER TABLE doc_locations
MODIFY (DLC_PATHNAME varchar2(4000));

ALTER TABLE doc_locations
MODIFY (DLC_APPS_PATHNAME varchar2(4000));

--------------------------------------------------------------------------------------------------------
--LOG 701414
--------------------------------------------------------------------------------------------------------

ALTER TABLE DOC_REDIR_PRIOR
MODIFY (DRP_ROAD_UNIQUE varchar2(30));
--------------------------------------------------------------------------------------------------------
--LOG 700452
--------------------------------------------------------------------------------------------------------
ALTER TABLE nm_inv_types_all
ADD (NIT_NOTES VARCHAR2(4000));

--
---------------------------------------------------------------------------------------------------------

--------------------------
-- New column on NM_ERRORS
--------------------------
ALTER TABLE NM_ERRORS
ADD (NER_CAUSE VARCHAR2(1000));

---------------------------------------------------------------------------------------------------

-----------------------------------
-- Members index changes
-----------------------------------
DROP INDEX nm_obj_type_ind;

DROP INDEX nm_ne_fk_of_ind;

CREATE INDEX NM_OBJ_TYPE_NE_ID_OF_IND ON NM_MEMBERS_ALL
(NM_NE_ID_OF, NM_OBJ_TYPE);

ALTER TABLE doc_history
MODIFY (DHI_REASON varchar2(4000));

-- DC Misc changes for equality between pgraded and installed clients

COMMENT ON TABLE HIG_USERS IS 'Details of staff employed within the admin units. Each person must have a unique Oracle username.'
/

PROMPT Creating Table 'IM_GAZ_PARAMETERS'
CREATE TABLE IM_GAZ_PARAMETERS
 (IGP_HHM_MODULE VARCHAR2(30) NOT NULL
 ,IGP_GAZ_NW_TYPE VARCHAR2(4)
 ,IGP_GAZ_GRP_TYPE VARCHAR2(4)
 ,IGP_PORTLET_DISP_MODE VARCHAR2(20)
 ,IGP_PORTLET_PROMPT VARCHAR2(200)
 ,IGP_GAZ_HELP VARCHAR2(2000)
 )
/

PROMPT Creating Primary Key on 'IM_GAZ_PARAMETERS'
ALTER TABLE IM_GAZ_PARAMETERS
 ADD (CONSTRAINT IGP_PK PRIMARY KEY
  (IGP_HHM_MODULE))
/

PROMPT Creating Foreign Key on 'IM_GAZ_PARAMETERS'
ALTER TABLE IM_GAZ_PARAMETERS ADD (CONSTRAINT
 IGP_HHM_FK FOREIGN KEY
  (IGP_HHM_MODULE) REFERENCES HIG_MODULES
  (HMO_MODULE))
/

PROMPT Creating Table 'IM_JUMP_NODES'
CREATE TABLE IM_JUMP_NODES
 (IJN_HHU_MODULE VARCHAR2(30) NOT NULL
 ,IJN_HHU_SEQ NUMBER NOT NULL
 ,IJN_JUMP_LEVEL NUMBER NOT NULL
 ,IJN_BUTTON_TEXT VARCHAR2(80) NOT NULL
 )
/

PROMPT Creating Primary Key on 'IM_JUMP_NODES'
ALTER TABLE IM_JUMP_NODES
 ADD (CONSTRAINT IJN_PK PRIMARY KEY
  (IJN_HHU_MODULE
  ,IJN_HHU_SEQ
  ,IJN_JUMP_LEVEL))
/

PROMPT Creating Foreign Key on 'IM_JUMP_NODES'
ALTER TABLE IM_JUMP_NODES ADD (CONSTRAINT
 IJN_HHU_FK FOREIGN KEY
  (IJN_HHU_MODULE
  ,IJN_HHU_SEQ) REFERENCES HIG_HD_MOD_USES
  (HHU_HHM_MODULE
  ,HHU_SEQ))
/

PROMPT Creating Table 'NM3_SECTOR_GROUPS'
CREATE TABLE NM3_SECTOR_GROUPS
 (SEC_SECTOR VARCHAR2(30) NOT NULL
 ,SEC_SECTOR_NAME VARCHAR2(50) NOT NULL
 ,SEC_QUERY VARCHAR2(2000)
 ,SEC_SEQ NUMBER(9)
 ,SEC_EXEC_OK VARCHAR2(1)
 ,SEC_COMMENTS VARCHAR2(2000)
 ,SEC_MEMBERS NUMBER(9)
 ,SEC_QUERY_INDEX NUMBER(4)
 ,SEC_PARISH_AREA VARCHAR2(1)
 ,SEC_ADMIN_UNIT NUMBER(9)
 )
/

PROMPT Creating Primary Key on 'NM3_SECTOR_GROUPS'
ALTER TABLE NM3_SECTOR_GROUPS
 ADD (CONSTRAINT SEC_PK PRIMARY KEY
  (SEC_SECTOR
  ,SEC_SECTOR_NAME))
/

PROMPT Creating Index 'RSCR'
CREATE INDEX RSCR ON NM_RESCALE_READ
 (NE_ID)
/

PROMPT Add primary key to nm_nw_ad_link_all table
ALTER TABLE NM_NW_AD_LINK_ALL ADD (
  CONSTRAINT NADL_PK PRIMARY KEY (NAD_IIT_NE_ID, NAD_START_DATE))
/

--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************

