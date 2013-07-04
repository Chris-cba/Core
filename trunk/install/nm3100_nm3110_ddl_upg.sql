REM Copyright 2013 Bentley Systems Incorporated. All rights reserved.
REM @(#)nm3100_nm3110_ddl_upg.sql	1.6 06/21/04

set echo off
set linesize 120
set heading off
set feedback off

--
-----------------
-- HIG_HD CHANGES
-----------------
--
CREATE TABLE hig_hd_mod_parameters (
hhp_hhm_module           varchar2(30) NOT NULL,
hhp_parameter            varchar2(80) NOT NULL,
hhp_default_value        varchar2(200));


COMMENT ON TABLE hig_hd_mod_parameters IS 'Lists parameter definitions used in queries';

COMMENT ON COLUMN hig_hd_mod_parameters.hhp_hhm_module IS 'Module Name, (FK) to hig_hd_modules';

COMMENT ON COLUMN hig_hd_mod_parameters.hhp_parameter IS 'Parameter name';

COMMENT ON COLUMN hig_hd_mod_parameters.hhp_default_value IS 'Default value of the parameter';

ALTER TABLE hig_hd_mod_parameters ADD (CONSTRAINT hig_hd_hhp_pk PRIMARY KEY (hhp_hhm_module, hhp_parameter));

ALTER TABLE hig_hd_mod_parameters ADD (CONSTRAINT hig_hd_hhp_hhm_fk FOREIGN KEY (hhp_hhm_module) REFERENCES hig_hd_modules (hhm_module) ON DELETE CASCADE);


ALTER TABLE hig_hd_lookup_join_cols ADD (HHO_HHL_JOIN_TO_LOOKUP NUMBER);

COMMENT ON COLUMN hig_hd_lookup_join_cols.hho_hhl_join_to_lookup IS 'The lookup join table the column joins to. If null then the column is joined to the driving table';

ALTER TABLE hig_hd_lookup_join_cols ADD (CONSTRAINT hig_hd_hho_hhl_lookup_fk FOREIGN KEY (HHO_HHL_HHU_HHM_MODULE, HHO_HHL_HHU_SEQ, HHO_HHL_JOIN_TO_LOOKUP) REFERENCES hig_hd_lookup_join_defs (HHL_HHU_HHM_MODULE, HHL_HHU_SEQ, HHL_JOIN_SEQ) ON DELETE CASCADE);



--
-----------------
-- XSP CHANGES
-----------------
--

RENAME nm_xsp TO nm_nw_xsp;

RENAME xsp_restraints TO nm_xsp_restraints;

RENAME xsp_reversal TO nm_xsp_reversal;

--
-----------------
-- NSG CHANGES
-----------------
--
CREATE INDEX NP_GRID_IND ON NM_POINTS
(NP_GRID_EAST, NP_GRID_NORTH)
/


--
-----------------
-- MISC CHANGES
-----------------
--

--
--Make hig_modules.hmo_filename larger
--
ALTER TABLE hig_modules MODIFY (hmo_filename varchar2(255));

--
--Make gis_projects.gp_project larger
--
ALTER TABLE gis_projects MODIFY (gp_project varchar2(80));

--
--Table to store parts of HTML files uploaded through the mod_plsql gateway
--
create table NM_UPLOAD_FILESPART
(DOCUMENT VARCHAR2(256)
,PART      VARCHAR2(256)
,UPLOADED  CHAR(1)
,constraint NUFPART_PK primary key( document, part )
)
/

--
-- New column to support DOC interaction with IM
--
ALTER TABLE DOC_MEDIA ADD (DMD_ICON VARCHAR2(80))
/

-- 
-- NMU_HUS_FK is not cascading. It should be ON DELETE SET NULL
--
ALTER TABLE NM_MAIL_USERS DROP
  CONSTRAINT NMU_HUS_FK 
/
ALTER TABLE NM_MAIL_USERS ADD 
  CONSTRAINT NMU_HUS_FK FOREIGN KEY (NMU_HUS_USER_ID) 
    REFERENCES HIG_USERS (HUS_USER_ID)
    ON DELETE SET NULL
/


--
-- NM_MAIL_GROUPS has a unique index on NMG_NAME, but no UNIQUE constraint. 
-- Whilst this is fine form a data point of view, what it of course means is that there is not a 
-- get_nmg function generated in nm3get as it operates by constraint. 
--
DROP INDEX NMG_UK
/

ALTER TABLE nm_mail_groups
 ADD CONSTRAINT nmg_uk
 UNIQUE (nmg_name)
/


--
-- Ensure that favourites cannot be set up in a loop
--
ALTER TABLE HIG_USER_FAVOURITES
 ADD CONSTRAINT HUF_CONNECT_LOOP_CHK
 CHECK (huf_parent != huf_child)
/
ALTER TABLE HIG_SYSTEM_FAVOURITES
 ADD CONSTRAINT HSF_CONNECT_LOOP_CHK
 CHECK (hsf_parent != hsf_child)
/
ALTER TABLE HIG_STANDARD_FAVOURITES
 ADD CONSTRAINT HSTF_CONNECT_LOOP_CHK
 CHECK (hstf_parent != hstf_child)
/

