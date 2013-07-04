DROP TABLE nm_saved_extents CASCADE CONSTRAINTS ;

CREATE TABLE nm_saved_extents (
  nse_id             number        NOT NULL,
  nse_owner          varchar2 (30)  NOT NULL,
  nse_name           varchar2 (30)  NOT NULL,
  nse_descr          varchar2 (4000),
  nse_pbi            varchar2 (1)  DEFAULT 'N' NOT NULL,
  nse_date_created   DATE          NOT NULL,
  nse_date_modified  DATE          NOT NULL,
  nse_modified_by    varchar2 (30)  NOT NULL,
  nse_created_by     varchar2 (30)  NOT NULL,
  CONSTRAINT pk_nm_saved_extents
  PRIMARY KEY ( nse_id ) );

CREATE OR REPLACE TRIGGER nm_saved_extents_who
 BEFORE INSERT OR UPDATE
 ON nm_saved_extents
 FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nse_upg.sql	1.1 03/01/01
--       Module Name      : nse_upg.sql
--       Date into SCCS   : 01/03/01 16:25:13
--       Date fetched Out : 07/06/13 17:07:25
--       SCCS Version     : 1.1
--
--   table_name_WHO trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
   l_sysdate DATE                     := SYSDATE;
   l_user    user_users.username%TYPE := USER;
--
BEGIN
--
-- Generated 16:01:48 19-FEB-2001
--
   IF INSERTING
    THEN
      :NEW.nse_date_created  := l_sysdate;
      :NEW.nse_created_by    := l_user;
   END IF;
--
   :NEW.nse_date_modified := l_sysdate;
   :NEW.nse_modified_by   := l_user;
--
END nm_saved_extents_who;
/

DROP TABLE nm_saved_extent_members CASCADE CONSTRAINTS ;

CREATE TABLE nm_saved_extent_members (
  nsm_nse_id             number        NOT NULL,
  nsm_id                 number        NOT NULL,
  nsm_ne_id              number        NOT NULL,
  nsm_begin_mp           number        NOT NULL,
  nsm_end_mp             number,
  nsm_begin_no           number,
  nsm_end_no             number,
  nsm_begin_sect         number,
  nsm_begin_sect_offset  number,
  nsm_end_sect           number,
  nsm_end_sect_offset    number,
  nsm_seq_no             number,
  nsm_datum              varchar2 (1)  NOT NULL,
  nsm_date_created       DATE          NOT NULL,
  nsm_date_modified      DATE          NOT NULL,
  nsm_created_by         varchar2 (30)  NOT NULL,
  nsm_modified_by        varchar2 (30)  NOT NULL,
  CONSTRAINT nsm_pk
  PRIMARY KEY ( nsm_nse_id, nsm_id ) );

ALTER TABLE nm_saved_extent_members ADD  CONSTRAINT nsu_nse_fk
 FOREIGN KEY (nsm_nse_id)
  REFERENCES nm_saved_extents (nse_id) DISABLE ;

CREATE INDEX nsu_nse_fk_ind ON
  nm_saved_extent_members(nsm_nse_id)
  TABLESPACE highways PCTFREE 10  STORAGE(INITIAL 1048576 NEXT 1048576 PCTINCREASE 0 )
;


CREATE OR REPLACE TRIGGER nm_saved_extent_members_who
 BEFORE INSERT OR UPDATE
 ON nm_saved_extent_members
 FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nse_upg.sql	1.1 03/01/01
--       Module Name      : nse_upg.sql
--       Date into SCCS   : 01/03/01 16:25:13
--       Date fetched Out : 07/06/13 17:07:25
--       SCCS Version     : 1.1
--
--   table_name_WHO trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
   l_sysdate DATE                     := SYSDATE;
   l_user    user_users.username%TYPE := USER;
--
BEGIN
--
-- Generated 16:01:48 19-FEB-2001
--
   IF INSERTING
    THEN
      :NEW.nsm_date_created  := l_sysdate;
      :NEW.nsm_created_by    := l_user;
   END IF;
--
   :NEW.nsm_date_modified := l_sysdate;
   :NEW.nsm_modified_by   := l_user;
--
END nm_saved_extent_members_who;
/

DROP TABLE nm_saved_extent_member_datums CASCADE CONSTRAINTS ;

CREATE TABLE nm_saved_extent_member_datums (
  nsd_nse_id       number        NOT NULL,
  nsd_nsm_id       number        NOT NULL,
  nsd_ne_id        number        NOT NULL,
  nsd_begin_mp     number        NOT NULL,
  nsd_end_mp       number,
  nsd_seq_no       number,
  nsd_cardinality  number        NOT NULL,
  CONSTRAINT nsd_pk
  PRIMARY KEY ( nsd_nse_id, nsd_nsm_id, nsd_ne_id, nsd_begin_mp ) );

ALTER TABLE nm_saved_extent_member_datums ADD  CONSTRAINT nsd_nsm_fk
 FOREIGN KEY (nsd_nse_id, nsd_nsm_id)
  REFERENCES nm_saved_extent_members (nsm_nse_id, nsm_id) ;

CREATE INDEX nsd_nsm_fk_ind ON
  nm_saved_extent_member_datums(nsd_nse_id, nsd_nsm_id)
  TABLESPACE highways PCTFREE 10  STORAGE(INITIAL 1048576 NEXT 1048576 PCTINCREASE 0 )
;

