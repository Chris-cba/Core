--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3130_nm3200_ddl_upg.sql	1.11 02/16/05
--       Module Name      : nm3130_nm3200_ddl_upg.sql
--       Date into SCCS   : 05/02/16 08:20:46
--       Date fetched Out : 07/06/13 13:57:55
--       SCCS Version     : 1.11
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
--
--
---------------------------------------------------------------------------------------------------
--          ***************** Drop check constraint for FT asset types **************************
--
ALTER TABLE nm_inv_types_all
 DROP CONSTRAINT NIT_FT_CHECK;
--
---------------------------------------------------------------------------------------------------
--                        ****************   Start of AD changes   *******************
Prompt Associated Data Changes
Prompt =======================

Prompt Create NAD_ID Sequence
CREATE SEQUENCE nad_id_seq;

Prompt Create table NM_NW_AD_TYPES
CREATE TABLE NM_NW_AD_TYPES
(
  NAD_ID             NUMBER                NOT NULL,
  NAD_INV_TYPE       VARCHAR2(4)           NOT NULL,
  NAD_NT_TYPE        VARCHAR2(4)           NOT NULL,
  NAD_GTY_TYPE       VARCHAR2(4),
  NAD_DESCR          VARCHAR2(80),
  NAD_START_DATE     DATE                  NOT NULL,
  NAD_END_DATE       DATE,
  NAD_PRIMARY_AD     VARCHAR2(1)           NOT NULL,
  NAD_DISPLAY_ORDER  NUMBER(38)            NOT NULL,
  NAD_SINGLE_ROW     VARCHAR2(1)           NOT NULL,
  NAD_MANDATORY      VARCHAR2(1)           NOT NULL
);

COMMENT ON COLUMN NM_NW_AD_TYPES.NAD_ID            IS 'AD Types Primary Key.';
COMMENT ON COLUMN NM_NW_AD_TYPES.NAD_INV_TYPE      IS 'Inv Type for AD Type.';
COMMENT ON COLUMN NM_NW_AD_TYPES.NAD_NT_TYPE       IS 'Network Type for AD Type.';
COMMENT ON COLUMN NM_NW_AD_TYPES.NAD_GTY_TYPE      IS 'Group Type for AD Type.';
COMMENT ON COLUMN NM_NW_AD_TYPES.NAD_DESCR         IS 'AD Type Description.';
COMMENT ON COLUMN NM_NW_AD_TYPES.NAD_START_DATE    IS 'AD Type Start Date.';
COMMENT ON COLUMN NM_NW_AD_TYPES.NAD_END_DATE      IS 'AD Type End Date.';
COMMENT ON COLUMN NM_NW_AD_TYPES.NAD_PRIMARY_AD    IS 'Primary AD Type Flag.';
COMMENT ON COLUMN NM_NW_AD_TYPES.NAD_DISPLAY_ORDER IS 'AD Type Display Order.';
COMMENT ON COLUMN NM_NW_AD_TYPES.NAD_SINGLE_ROW    IS 'AD Single Row association flag.';
COMMENT ON COLUMN NM_NW_AD_TYPES.NAD_MANDATORY     IS 'AD Type is mandatory flag.';


Prompt Create Primary Key on NM_NW_AD_TYPES
ALTER TABLE NM_NW_AD_TYPES ADD (
  CONSTRAINT NAD_ID_PK PRIMARY KEY (NAD_ID));

Prompt Create FK on NM_NW_AD_TYPES to NM_GROUP_TYPES
ALTER TABLE NM_NW_AD_TYPES ADD (
  CONSTRAINT NAD_GTY_TYPE_FK FOREIGN KEY (NAD_GTY_TYPE)
    REFERENCES NM_GROUP_TYPES_ALL (NGT_GROUP_TYPE));

Prompt Create FK on NM_NW_AD_TYPES to NM_INV_TYPES
ALTER TABLE NM_NW_AD_TYPES ADD (
  CONSTRAINT NAD_INV_TYPE_FK FOREIGN KEY (NAD_INV_TYPE)
    REFERENCES NM_INV_TYPES_ALL (NIT_INV_TYPE));

Prompt Create FK on NM_NW_AD_TYPES to NM_TYPES
ALTER TABLE NM_NW_AD_TYPES ADD (
  CONSTRAINT NAD_NT_TYPE_FK FOREIGN KEY (NAD_NT_TYPE)
    REFERENCES NM_TYPES (NT_TYPE));

PROMPT Creating Check Constraint on 'NM_NW_AD_TYPES'
ALTER TABLE NM_NW_AD_TYPES
 ADD (CONSTRAINT AVCON_1105696270_NAD_P_000 CHECK (NAD_PRIMARY_AD IN ('Y', 'N')))
/

PROMPT Creating Check Constraint on 'NM_NW_AD_TYPES'
ALTER TABLE NM_NW_AD_TYPES
 ADD (CONSTRAINT AVCON_1105696270_NAD_S_000 CHECK (NAD_SINGLE_ROW IN ('Y', 'N')))
/

PROMPT Creating Check Constraint on 'NM_NW_AD_TYPES'
ALTER TABLE NM_NW_AD_TYPES
 ADD (CONSTRAINT AVCON_1105696270_NAD_M_000 CHECK (NAD_MANDATORY IN ('Y', 'N')))
/

Prompt Create table NM_NW_AD_LINK_ALL
CREATE TABLE NM_NW_AD_LINK_ALL
(
  NAD_ID          NUMBER                        NOT NULL,
  NAD_IIT_NE_ID   NUMBER(9)                     NOT NULL,
  NAD_NE_ID       NUMBER(9)                     NOT NULL,
  NAD_START_DATE  DATE                          NOT NULL,
  NAD_END_DATE    DATE
);

COMMENT ON COLUMN NM_NW_AD_LINK_ALL.NAD_ID            IS 'AD Link FK to AD Types.';
COMMENT ON COLUMN NM_NW_AD_LINK_ALL.NAD_IIT_NE_ID     IS 'AD Link Inventory ID.';
COMMENT ON COLUMN NM_NW_AD_LINK_ALL.NAD_NE_ID         IS 'AD Link Network Element ID.';
COMMENT ON COLUMN NM_NW_AD_LINK_ALL.NAD_START_DATE    IS 'AD Link Start Date.';
COMMENT ON COLUMN NM_NW_AD_LINK_ALL.NAD_END_DATE      IS 'AD Link End Date.';

Prompt Create Index on NM_NW_AD_LINK_ALL NAD_IIT_NE_ID
CREATE INDEX NAD_IIT_NE_ID_IND ON NM_NW_AD_LINK_ALL
(NAD_IIT_NE_ID);

Prompt Create Index on NM_NW_AD_LINK_ALL NAD_NE_ID
CREATE INDEX NAD_NE_ID_IND ON NM_NW_AD_LINK_ALL
(NAD_NE_ID);

Prompt Create FK on NM_NW_AD_LINK_ALL to NM_INV_ITEMS_ALL
ALTER TABLE NM_NW_AD_LINK_ALL ADD (
  CONSTRAINT NADL_IIT_NE_ID_FK FOREIGN KEY (NAD_IIT_NE_ID)
    REFERENCES NM_INV_ITEMS_ALL (IIT_NE_ID));

Prompt Create FK on NM_NW_AD_LINK_ALL to NM_NW_AD_TYPES
ALTER TABLE NM_NW_AD_LINK_ALL ADD (
  CONSTRAINT NADL_NAD_ID_FK FOREIGN KEY (NAD_ID)
    REFERENCES NM_NW_AD_TYPES (NAD_ID));

Prompt Create FK on NM_NW_AD_LINK_ALL to NM_ELEMENTS_ALL
ALTER TABLE NM_NW_AD_LINK_ALL ADD (
  CONSTRAINT NADL_NE_ID_FK FOREIGN KEY (NAD_NE_ID)
    REFERENCES NM_ELEMENTS_ALL (NE_ID));

Prompt Create NM_NW_AD_LINK view
CREATE OR REPLACE FORCE VIEW nm_nw_ad_link (nad_id,
                                      nad_iit_ne_id,
                                      nad_ne_id,
                                      nad_start_date,
                                      nad_end_date
                                     )
AS
   SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_nw_ad_link.vw	1.2 12/22/04
--       Module Name      : nm_nw_ad_link.vw
--       Date into SCCS   : 04/12/22 14:19:15
--       Date fetched Out : 04/12/22 14:19:20
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
-- Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
          "NAD_ID", "NAD_IIT_NE_ID", "NAD_NE_ID", "NAD_START_DATE",
          "NAD_END_DATE"
     FROM nm_nw_ad_link_all
    WHERE nad_start_date <= nm3context.get_effective_date
      AND NVL (nad_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >
                                                 nm3context.get_effective_date;

CREATE OR REPLACE TRIGGER NM_NW_AD_LINK_BR
BEFORE INSERT OR UPDATE
ON NM_NW_AD_LINK_ALL
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_nw_ad_link_br.trg	1.4 12/22/04
--       Module Name      : nm_nw_ad_link_br.trg
--       Date into SCCS   : 04/12/22 14:33:30
--       Date fetched Out : 04/12/22 14:34:57
--       SCCS Version     : 1.4
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved
-----------------------------------------------------------------------------
DECLARE

l_rec_nwad NM_NW_AD_LINK_ALL%ROWTYPE;

BEGIN

   nm3nwad.g_tab_nadl.DELETE;

   l_rec_nwad.nad_id             := :NEW.nad_id;
   l_rec_nwad.nad_iit_ne_id      := :NEW.nad_iit_ne_id;
   l_rec_nwad.nad_ne_id          := :NEW.nad_ne_id;
   l_rec_nwad.nad_start_date     := :NEW.nad_start_date;
   l_rec_nwad.nad_end_date       := :NEW.nad_end_date;

   nm3nwad.g_tab_nadl(nm3nwad.g_tab_nadl.COUNT+1) := l_rec_nwad;

END nm_nw_ad_link_br;
/

CREATE OR REPLACE TRIGGER NM_NW_AD_LINK_AS
AFTER INSERT OR UPDATE
ON NM_NW_AD_LINK_ALL
REFERENCING NEW AS NEW OLD AS OLD
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_nw_ad_link_as.trg	1.3 12/22/04
--       Module Name      : nm_nw_ad_link_as.trg
--       Date into SCCS   : 04/12/22 14:34:49
--       Date fetched Out : 04/12/22 14:35:16
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
DECLARE
BEGIN
   nm3nwad.process_table_nwad_link;
END nm_nw_ad_link_as;
/

--
---------------------------------------------------------------------------------------------------
--                        ****************   End of AD changes   *******************

--
---------------------------------------------------------------------------------------------------
--                        ****************   Start of SDM changes   *******************

PROMPT Create Trigger NM_THEMES_ALL_BS_TRG
CREATE OR REPLACE TRIGGER NM_THEMES_ALL_BS_TRG
BEFORE DELETE
ON NM_THEMES_ALL
REFERENCING NEW AS NEW OLD AS OLD
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_themes_all_bs_trg.trg	1.1 01/04/05
--       Module Name      : nm_themes_all_bs_trg.trg
--       Date into SCCS   : 05/01/04 11:28:18
--       Date fetched Out : 05/01/04 14:05:40
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--  Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved
-----------------------------------------------------------------------------
BEGIN
   nm3sde.g_del_theme := TRUE;
END NM_THEMES_ALL_BS_TRG;
/

PROMPT Create Trigger NM_THEMES_ALL_AS_TRG
CREATE OR REPLACE TRIGGER NM_THEMES_ALL_AS_TRG
AFTER DELETE
ON NM_THEMES_ALL
REFERENCING NEW AS NEW OLD AS OLD
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_themes_all_as_trg.trg	1.1 01/04/05
--       Module Name      : nm_themes_all_as_trg.trg
--       Date into SCCS   : 05/01/04 11:27:54
--       Date fetched Out : 05/01/04 14:05:48
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--  Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved
-----------------------------------------------------------------------------
BEGIN
   nm3sde.g_del_theme := FALSE;
END NM_THEMES_ALL_AS_TRG;
/

PROMPT Create Trigger NM_THEMES_ALL_B_IU_TRG
CREATE OR REPLACE TRIGGER nm_themes_all_b_iu_trg
   BEFORE INSERT OR UPDATE OR DELETE
   ON NM_THEMES_ALL
   FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_themes_all_b_iu_trg.trg	1.3 01/04/05
--       Module Name      : nm_themes_all_b_iu_trg.trg
--       Date into SCCS   : 05/01/04 11:34:46
--       Date fetched Out : 05/01/04 14:05:19
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
--  Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved
-----------------------------------------------------------------------------
--
c_str nm3type.max_varchar2;
--
BEGIN
--
   IF DELETING THEN
     IF :OLD.nth_theme_type = nm3sdo.c_sdo
      THEN
       c_str := 'begin '||
                  'nm3sdo.drop_sub_layer_by_table( '||
                     nm3flx.string(:old.nth_feature_table)||','||
                     nm3flx.string(:old.nth_feature_shape_column)||');'
             ||' end;';
       EXECUTE IMMEDIATE c_str;
     END IF;
   END IF;
--
   IF :NEW.nth_location_updatable = 'Y'
    AND higgis.is_product_locatable_from_gis(:NEW.nth_hpr_product) != 'Y'
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 152
                    ,pi_supplementary_info => :NEW.nth_hpr_product
                    );
   END IF;
--
EXCEPTION
   WHEN OTHERS THEN
      RAISE;
--
END nm_themes_all_b_iu_trg;
/
PROMPT Create Trigger HIG_USER_ROLES_BS_TRG
CREATE OR REPLACE TRIGGER hig_user_roles_bs_trg
   BEFORE DELETE OR INSERT OR UPDATE
   ON hig_user_roles
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_user_roles_bs_trg.trg	1.1 01/04/05
--       Module Name      : hig_user_roles_bs_trg.trg
--       Date into SCCS   : 05/01/04 11:25:20
--       Date fetched Out : 05/01/04 14:06:27
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--  Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved
-----------------------------------------------------------------------------
BEGIN
   nm3sdm.g_role_idx := 0;
END hig_user_roles_bs_trg;
/

PROMPT Create Trigger HIG_USER_ROLES_AS_TRG
CREATE OR REPLACE TRIGGER hig_user_roles_as_trg
   AFTER DELETE OR INSERT OR UPDATE
   ON hig_user_roles
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_user_roles_as_trg.trg	1.1 01/04/05
--       Module Name      : hig_user_roles_as_trg.trg
--       Date into SCCS   : 05/01/04 11:24:34
--       Date fetched Out : 05/01/04 14:07:22
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--  Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved
-----------------------------------------------------------------------------
BEGIN
   nm3sdm.process_subuser_hur;
END hig_user_roles_as_trg;
/

PROMPT Create Trigger HIG_USER_ROLES_BR_TRG
CREATE OR REPLACE TRIGGER hig_user_roles_br_trg
   BEFORE DELETE OR INSERT OR UPDATE OF hur_username, hur_role
   ON hig_user_roles
   FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_user_roles_br_trg.trg	1.1 01/04/05
--       Module Name      : hig_user_roles_br_trg.trg
--       Date into SCCS   : 05/01/04 11:25:05
--       Date fetched Out : 05/01/04 14:06:15
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
-- Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
   nm3sdm.g_role_idx := nm3sdm.g_role_idx + 1;
   IF INSERTING
   THEN
      nm3sdm.set_subuser_globals_hur
        ( :NEW.hur_role, :NEW.hur_username, 'I');
   ELSIF UPDATING
   THEN
      nm3sdm.set_subuser_globals_hur
        ( :OLD.hur_role, :OLD.hur_username, 'D');

      nm3sdm.g_role_idx := nm3sdm.g_role_idx + 1;

      nm3sdm.set_subuser_globals_hur
        ( :NEW.hur_role, :NEW.hur_username, 'I');
   ELSE
      nm3sdm.set_subuser_globals_hur
        ( :OLD.hur_role, :OLD.hur_username, 'D');
   END IF;
END hig_user_roles_br_trg;
/

PROMPT Create Trigger NM_THEME_ROLES_BS_TRG
CREATE OR REPLACE TRIGGER nm_theme_roles_bs_trg
   BEFORE DELETE OR INSERT OR UPDATE
   ON nm_theme_roles
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_theme_roles_bs_trg.trg	1.1 01/04/05
--       Module Name      : nm_theme_roles_bs_trg.trg
--       Date into SCCS   : 05/01/04 11:27:07
--       Date fetched Out : 05/01/04 14:04:58
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
-- Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
   nm3sdm.g_role_idx := 0;
END nm_theme_roles_bs_trg;
/

PROMPT Create Trigger NM_THEME_ROLES_BR_TRG
CREATE OR REPLACE TRIGGER nm_theme_roles_br_trg
   BEFORE DELETE OR INSERT OR UPDATE OF nthr_role, nthr_theme_id
   ON nm_theme_roles
   FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_theme_roles_br_trg.trg	1.1 01/04/05
--       Module Name      : nm_theme_roles_br_trg.trg
--       Date into SCCS   : 05/01/04 11:26:46
--       Date fetched Out : 05/01/04 14:04:52
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
-- Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
   l_nth   nm_themes_all%ROWTYPE;
BEGIN

   IF NOT nm3sde.g_del_theme
   THEN
     nm3sdm.g_role_idx := nm3sdm.g_role_idx + 1;
   END IF;

   IF INSERTING
   THEN

      l_nth := nm3get.get_nth (:NEW.nthr_theme_id);
      IF l_nth.nth_theme_type = nm3sdo.c_sdo
      THEN
         nm3sdm.set_subuser_globals_nthr
           ( :NEW.nthr_role
           , :NEW.nthr_theme_id
           , 'I');
      END IF;

   ELSIF UPDATING
   THEN

      l_nth := nm3get.get_nth (:OLD.nthr_theme_id);
      IF l_nth.nth_theme_type = nm3sdo.c_sdo
      THEN
         nm3sdm.set_subuser_globals_nthr
           ( :OLD.nthr_role
           , :OLD.nthr_theme_id
           , 'D');
      END IF;

      l_nth := nm3get.get_nth (:NEW.nthr_theme_id);
      IF l_nth.nth_theme_type = nm3sdo.c_sdo
      THEN
         nm3sdm.g_role_idx := nm3sdm.g_role_idx + 1;
         nm3sdm.set_subuser_globals_nthr
           ( :NEW.nthr_role
           , :NEW.nthr_theme_id
           , 'I');
      END IF;

   ELSE

      IF NOT nm3sde.g_del_theme
      THEN
        l_nth := nm3get.get_nth (:OLD.nthr_theme_id);
        IF l_nth.nth_theme_type = nm3sdo.c_sdo
        THEN
           nm3sdm.set_subuser_globals_nthr
             ( :OLD.nthr_role
             , :OLD.nthr_theme_id
             , 'D');
        END IF;
      END IF;
   END IF;
END nm_theme_roles_br_trg;
/

PROMPT Create Trigger NM_THEME_ROLES_AS_TRG
CREATE OR REPLACE TRIGGER nm_theme_roles_as_trg
   AFTER DELETE OR INSERT OR UPDATE
   ON nm_theme_roles
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_theme_roles_as_trg.trg	1.1 01/04/05
--       Module Name      : nm_theme_roles_as_trg.trg
--       Date into SCCS   : 05/01/04 11:25:41
--       Date fetched Out : 05/01/04 14:05:07
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--  Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved
-----------------------------------------------------------------------------
BEGIN
   nm3sdm.process_subuser_nthr;
END nm_theme_roles_as_trg;
/

--
---------------------------------------------------------------------------------------------------
--                        ****************   End of SDM changes   *******************


--
---------------------------------------------------------------------------------------------------
--                     ****************   Start of 699168 Changes   *******************


Prompt Ensuring That Indexes/Constraints on NM_ADMIN_GROUPS exist
Prompt ==========================================================
--
--
Prompt HAG_PK
BEGIN
  execute immediate('ALTER TABLE NM_ADMIN_GROUPS ADD (CONSTRAINT HAG_PK PRIMARY KEY (NAG_PARENT_ADMIN_UNIT, NAG_CHILD_ADMIN_UNIT))');
EXCEPTION
WHEN others THEN
  Null;
END;
/
--
--
Prompt HAG_FK1_HAU
BEGIN
  execute immediate('ALTER TABLE NM_ADMIN_GROUPS ADD (CONSTRAINT HAG_FK1_HAU FOREIGN KEY (NAG_PARENT_ADMIN_UNIT) REFERENCES NM_ADMIN_UNITS_ALL (NAU_ADMIN_UNIT))');
EXCEPTION
WHEN others THEN
  Null;
END;
/
--
--
Prompt HAG_FK2_HAM
BEGIN
  execute immediate('ALTER TABLE NM_ADMIN_GROUPS ADD (CONSTRAINT HAG_FK2_HAM FOREIGN KEY (NAG_CHILD_ADMIN_UNIT) REFERENCES NM_ADMIN_UNITS_ALL (NAU_ADMIN_UNIT))');
EXCEPTION
WHEN others THEN
  Null;
END;
/
--
--

Prompt Ensuring That Indexes/Constraints on NM_ADMIN_UNITS_ALL exist
Prompt =============================================================
--
--
Prompt HAU_PK
BEGIN
  execute immediate('ALTER TABLE NM_ADMIN_UNITS_ALL ADD (CONSTRAINT HAU_PK PRIMARY KEY (NAU_ADMIN_UNIT))');
EXCEPTION
WHEN others THEN
  Null;
END;
/
--
--
Prompt HAU_UK1
BEGIN
  execute immediate('ALTER TABLE NM_ADMIN_UNITS_ALL ADD (CONSTRAINT HAU_UK1 UNIQUE (NAU_UNIT_CODE, NAU_ADMIN_TYPE))');
EXCEPTION
WHEN others THEN
  Null;
END;
/
--
--
Prompt HAU_UK2
BEGIN
  execute immediate('ALTER TABLE NM_ADMIN_UNITS_ALL ADD (CONSTRAINT HAU_UK2 UNIQUE (NAU_NAME, NAU_ADMIN_TYPE))');
EXCEPTION
WHEN others THEN
  Null;
END;
/
--
--
Prompt NAU_NAT_FK
BEGIN
  execute immediate('ALTER TABLE NM_ADMIN_UNITS_ALL ADD (CONSTRAINT NAU_NAT_FK FOREIGN KEY (NAU_ADMIN_TYPE) REFERENCES NM_AU_TYPES (NAT_ADMIN_TYPE))');
EXCEPTION
WHEN others THEN
  Null;
END;
/

--
---------------------------------------------------------------------------------------------------
--                     ****************   End of 699168 Changes   *******************


--
---------------------------------------------------------------------------------------------------
--                   ****************   Start of Spatial Changes   *******************


--**************************************** NM_THEME_GTYPES ********************************************

Prompt Spatial Changes - NM_THEME_GTYPES
Prompt =================================

DELETE FROM NM_THEME_GTYPES
/
ALTER TABLE NM_THEME_GTYPES
ADD (CONSTRAINT  NTG_UK UNIQUE (NTG_THEME_ID))
/
ALTER TABLE NM_THEME_GTYPES
ADD NTG_XML_URL           VARCHAR2(256)
/


--**************************************** NM_THEMES_ALL ********************************************

Prompt Spatial Changes - NM_THEMES_ALL
Prompt ===============================

-- disable trigger that becomes invalid when table altered
ALTER TRIGGER nm_themes_all_b_iu_trg DISABLE;


------------------
-- NTH_USE_HISTORY
------------------
ALTER TABLE NM_THEMES_ALL
ADD NTH_USE_HISTORY        VARCHAR2(1)  -- added as null but will be changed to not null
/
COMMENT ON COLUMN NM_THEMES_ALL.NTH_USE_HISTORY IS 'Flag to indicate if the spatial data supports history.'
/
-- set NTH_USE_HISTORY='Y' on dyns layers
UPDATE NM_THEMES_ALL NTH
SET    NTH_USE_HISTORY = 'Y'
WHERE  NTH_DEPENDENCY = 'D'
AND    EXISTS (SELECT 'I'
               FROM   NM_THEMES_ALL NTH2
               WHERE  NTH2.NTH_THEME_ID = NTH.NTH_BASE_THEME
               AND    NTH2.NTH_DEPENDENCY = 'I')
/
-- set NTH_USE_HISTORY='N' on everything else
UPDATE NM_THEMES_ALL NTH
SET    NTH_USE_HISTORY = 'N'
WHERE  NTH_USE_HISTORY IS NULL
/
ALTER TABLE NM_THEMES_ALL
MODIFY NTH_USE_HISTORY     DEFAULT 'N' NOT NULL
/
ALTER TABLE NM_THEMES_ALL
ADD (CONSTRAINT NTH_USE_HISTORY_CHK CHECK (NTH_USE_HISTORY IN ('Y','N') ) )
/


------------------------
-- NTH_START_DATE_COLUMN
------------------------
ALTER TABLE NM_THEMES_ALL
ADD NTH_START_DATE_COLUMN   VARCHAR2(30)
/
COMMENT ON COLUMN NM_THEMES_ALL.NTH_START_DATE_COLUMN   IS 'Column that holds start date, if history is used.'
/
-- SET 'START_DATE' TO BE DEFAULT VALUE FOR NTH_START_DATE_COLUMN ON DYNS LAYERS
UPDATE NM_THEMES_ALL NTH
SET    NTH_START_DATE_COLUMN = 'START_DATE'
WHERE  NTH_DEPENDENCY = 'D'
AND    EXISTS (SELECT 'I'
               FROM   NM_THEMES_ALL NTH2
               WHERE  NTH2.NTH_THEME_ID = NTH.NTH_BASE_THEME
               AND    NTH2.NTH_DEPENDENCY = 'I')
/

----------------------
-- NTH_END_DATE_COLUMN
----------------------
ALTER TABLE NM_THEMES_ALL
ADD NTH_END_DATE_COLUMN     VARCHAR2(30)
/
COMMENT ON COLUMN NM_THEMES_ALL.NTH_END_DATE_COLUMN   IS 'Column that holds start date, if history is used.'
/
-- SET 'END_DATE' TO BE DEFAULT VALUE FOR NTH_END_DATE_COLUMN ON DYNS LAYERS
UPDATE NM_THEMES_ALL NTH
SET    NTH_END_DATE_COLUMN = 'END_DATE'
WHERE  NTH_DEPENDENCY = 'D'
AND    EXISTS (SELECT 'I'
               FROM   NM_THEMES_ALL NTH2
               WHERE  NTH2.NTH_THEME_ID = NTH.NTH_BASE_THEME
               AND    NTH2.NTH_DEPENDENCY = 'I')
/

-----------------------
-- NTH_BASE_TABLE_THEME
-----------------------
ALTER TABLE NM_THEMES_ALL
ADD NTH_BASE_TABLE_THEME    NUMBER(9)
/
COMMENT ON COLUMN NM_THEMES_ALL.NTH_BASE_TABLE_THEME  IS 'Name of the table that holds the true spatial data.'
/
--------------------
-- NTH_SEQUENCE_NAME
--------------------
ALTER TABLE NM_THEMES_ALL
ADD NTH_SEQUENCE_NAME       VARCHAR2(30)
/
COMMENT ON COLUMN NM_THEMES_ALL.NTH_SEQUENCE_NAME  IS 'Name of database sequence used to derive shape primary key.'
/
UPDATE NM_THEMES_ALL
SET    NTH_SEQUENCE_NAME = 'NTH_'||TO_CHAR(NTH_THEME_ID)||'_SEQ'
WHERE  NTH_THEME_TYPE = 'SDO'
AND  HIG.GET_SYSOPT('SDOSURKEY') = 'Y'
AND EXISTS (SELECT 'sequence is there'
            FROM   user_sequences
            WHERE  sequence_name = 'NTH_'||TO_CHAR(NTH_THEME_ID)||'_SEQ');
/

--------------------
-- NTH_SNAP_TO_THEME
--------------------
ALTER TABLE NM_THEMES_ALL
ADD NTH_SNAP_TO_THEME       VARCHAR2(1)
/
COMMENT ON COLUMN NM_THEMES_ALL.NTH_SNAP_TO_THEME  IS 'Flag to denote whether snapping is appropriate.'
/
UPDATE NM_THEMES_ALL
SET    NTH_SNAP_TO_THEME = 'N'
/
ALTER TABLE NM_THEMES_ALL
MODIFY NTH_SNAP_TO_THEME     DEFAULT 'N' NOT NULL
/
ALTER TABLE NM_THEMES_ALL
ADD (CONSTRAINT NTH_SNAP_TO_THEME_CHK CHECK (NTH_SNAP_TO_THEME IN ('N','S','A') ) )
/
---------------------
-- NTH_LREF_MANDATORY
---------------------
ALTER TABLE NM_THEMES_ALL
ADD NTH_LREF_MANDATORY      VARCHAR2(1)
/
COMMENT ON COLUMN NM_THEMES_ALL.NTH_LREF_MANDATORY  IS 'Flag to denote if theme is to be snapped to linear layer.'
/
UPDATE NM_THEMES_ALL
SET    NTH_LREF_MANDATORY = 'N'
/
ALTER TABLE NM_THEMES_ALL
MODIFY NTH_LREF_MANDATORY     DEFAULT 'N' NOT NULL
/
ALTER TABLE NM_THEMES_ALL
ADD (CONSTRAINT NTH_LREF_MANDATORY_CHK CHECK (NTH_LREF_MANDATORY IN ('Y','N') ) );

----------------
-- NTH_TOLERANCE
----------------
ALTER TABLE NM_THEMES_ALL
ADD NTH_TOLERANCE           NUMBER
/
COMMENT ON COLUMN NM_THEMES_ALL.NTH_TOLERANCE  is 'Snapping tolerance value.'
/
UPDATE NM_THEMES_ALL
SET    NTH_TOLERANCE = 10
/
ALTER TABLE NM_THEMES_ALL
MODIFY NTH_TOLERANCE       DEFAULT 10 NOT NULL
/

----------------
-- NTH_TOL_UNITS
----------------
ALTER TABLE NM_THEMES_ALL
ADD NTH_TOL_UNITS           NUMBER(4)
/
COMMENT ON COLUMN NM_THEMES_ALL.NTH_TOL_UNITS IS 'Unit of tolerance, unit must be translatable to spatial units.'
/
UPDATE NM_THEMES_ALL
SET    NTH_TOL_UNITS = 1
/
ALTER TABLE NM_THEMES_ALL
MODIFY NTH_TOL_UNITS       DEFAULT 1 NOT NULL
/


---------------------
-- NTH_RSE_TABLE_NAME
---------------------
ALTER TABLE NM_THEMES_ALL
MODIFY NTH_RSE_TABLE_NAME NULL
/


-- enable trigger that becomes invalid when table altered
ALTER TRIGGER nm_themes_all_b_iu_trg ENABLE;




--**************************************** NM_THEME_SNAPS ********************************************


Prompt Spatial Changes - NM_THEME_SNAPS
Prompt ================================
CREATE TABLE NM_THEME_SNAPS(NTS_THEME_ID      NUMBER(9) NOT NULL
                           ,NTS_SNAP_TO       NUMBER(9) NOT NULL
                           ,NTS_PRIORITY      NUMBER(4) NOT NULL
                           )
/
ALTER TABLE NM_THEME_SNAPS
ADD (CONSTRAINT  NTS_PK PRIMARY KEY (NTS_THEME_ID,NTS_SNAP_TO))
/
COMMENT ON TABLE NM_THEME_SNAPS IS 'List of themes onto which locations will be snapped.'
/
COMMENT ON COLUMN NM_THEME_SNAPS.NTS_THEME_ID  IS 'Theme being snapped.'
/
COMMENT ON COLUMN NM_THEME_SNAPS.NTS_SNAP_TO   IS 'Theme to snap to.'
/
COMMENT ON COLUMN NM_THEME_SNAPS.NTS_PRIORITY  IS 'Priority of the snap for this nts_theme_id'
/

--**************************************** NM_AREA_LOCK ********************************************

Prompt Spatial Changes - NM_AREA_LOCK
Prompt ==============================
CREATE TABLE NM_AREA_LOCK(NAL_ID           NUMBER(38)         NOT NULL
                         ,NAL_TIMESTAMP    DATE               NOT NULL
                         ,NAL_TERMINAL     VARCHAR2(30)       NOT NULL
                         ,NAL_SESSION_ID   NUMBER(38)         NOT NULL
                         ,NAL_AREA         MDSYS.SDO_GEOMETRY NOT NULL)
/
ALTER TABLE NM_AREA_LOCK
ADD (CONSTRAINT  NAL_PK PRIMARY KEY (NAL_ID))
/
CREATE SEQUENCE NAL_SEQ NOCACHE
/
COMMENT ON TABLE NM_AREA_LOCK IS 'Table is used to hold spatial locks.'
/
COMMENT ON COLUMN NM_AREA_LOCK.NAL_ID  IS 'Surrogate key populated from NAL_SEQ.'
/
COMMENT ON COLUMN NM_AREA_LOCK.NAL_TIMESTAMP  IS 'Timestamp.'
/
COMMENT ON COLUMN NM_AREA_LOCK.NAL_TERMINAL  IS 'Terminal.'
/
COMMENT ON COLUMN NM_AREA_LOCK.NAL_SESSION_ID  IS 'Session ID'
/
COMMENT ON COLUMN NM_AREA_LOCK.NAL_AREA  IS 'Locked area'
/
--
---------------------------------------------------------------------------------------------------
--                   ****************   End of Spatial Changes   *******************


--
---------------------------------------------------------------------------------------------------
--                   ****************   Start of Misc Changes   *******************

-- JM 23-DEC-04
-- The NLCD_SOURCE_COL column on NM_LOAD_FILE_COL_DESTINATIONS is a VARCHAR2(100). What I have found in the past (and am currently finding!), is that 100 chars is not enough when you are basing a
-- columns value on function calls Ÿ especially ones using the nm3get functions which require you to name your variables.
--
alter table nm_load_file_col_destinations
modify (NLCD_SOURCE_COL        VARCHAR2(2000))
/


-- FJF 10-Jan-05
-- Drop duplicate check constraints
ALTER TABLE NM_TYPE_COLUMNS
 DROP CONSTRAINT AVCON_10406_NTC_D_000
 DROP CONSTRAINT AVCON_10406_NTC_M_000
 DROP CONSTRAINT AVCON_10406_NTC_I_000
/

-- Duplicates first part of primary key
drop index ngqa_ngqt_fk_ind
/

-- In Designer
create index NP_GRID_IND on NM_POINTS
( NP_GRID_EAST
, NP_GRID_NORTH
)
/

-- MH add sequence for autogenerated filenames using hig_ole.excel
-- over the web.
CREATE SEQUENCE NM3_EXCEL_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
 NOCACHE
/

-- DC remove rescale entries for element history
-- the referential integrity on member history will ensure that the members are also deleted

DELETE FROM hig_codes
WHERE hco_domain = 'HISTORY_OPERATION'
AND   hco_code = 'L'
/

DELETE FROM nm_element_history
WHERE neh_operation = 'L'
/


--
---------------------------------------------------------------------------------------------------
--                   ****************   End of Misc Changes   *******************


--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************


