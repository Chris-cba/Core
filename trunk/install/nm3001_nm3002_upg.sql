--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3001_nm3002_upg.sql-arc   2.1   Jul 04 2013 14:21:22   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3001_nm3002_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:21:22  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:59:38  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
rem   SCCS Identifiers :-
rem
rem       sccsid           : @(#)nm3001_nm3002_upg.sql	1.7 04/18/01
rem       Module Name      : nm3001_nm3002_upg.sql
rem       Date into SCCS   : 01/04/18 14:50:15
rem       Date fetched Out : 07/06/13 13:57:33
rem       SCCS Version     : 1.7
rem
rem
REM SCCS ID Keyword, do no remove
define sccsid = '@(#)nm3001_nm3002_upg.sql	1.7 04/18/01';
--

ALTER TABLE nm_members_all
ADD nm_true number;


CREATE global TEMPORARY TABLE nm_rescale_write (
  ne_id           number (9)    NOT NULL,
  ne_no_start     number (9)    NOT NULL,
  ne_no_end       number (9)    NOT NULL,
  ne_length       number        NOT NULL,
  nm_slk          number,
  nm_true         number,
  nm_seg_no       number (9),
  nm_seq_no       number (38),
  ne_nt_type      varchar2 (4)  NOT NULL,
  nm_cardinality  number (1)    NOT NULL,
  ne_sub_class    varchar2 (4),
  s_ne_id         number (9),
  connect_level   number,
  nm_begin_mp     number,
  nm_end_mp       number ) ;


CREATE UNIQUE INDEX rscw ON
  nm_rescale_write(ne_id)
;

CREATE INDEX rscw_start ON
  nm_rescale_write(s_ne_id)
;


CREATE global TEMPORARY TABLE nm_rescale_read (
  ne_id           number (9)    NOT NULL,
  ne_no_start     number (9)    NOT NULL,
  ne_no_end       number (9)    NOT NULL,
  ne_length       number        NOT NULL,
  nm_slk          number,
  nm_true         number,
  nm_seg_no       number (9),
  nm_seq_no       number (38),
  ne_nt_type      varchar2 (4)  NOT NULL,
  nm_cardinality  number (1)    NOT NULL,
  ne_sub_class    varchar2 (4),
  s_ne_id         number (9),
  connect_level   number,
  nm_begin_mp     number,
  nm_end_mp       number ) ;


CREATE UNIQUE INDEX rscr ON
  nm_rescale_read(ne_id)
;


CREATE global TEMPORARY TABLE nm_reversal (
  ne_id          number (9)    NOT NULL,
  ne_unique      varchar2 (30)  NOT NULL,
  ne_type        varchar2 (4)  NOT NULL,
  ne_nt_type     varchar2 (4)  NOT NULL,
  ne_descr       varchar2 (80)  NOT NULL,
  ne_length      number,
  ne_admin_unit  number (9)    NOT NULL,
  ne_owner       varchar2 (4),
  ne_name_1      varchar2 (80),
  ne_name_2      varchar2 (80),
  ne_prefix      varchar2 (4),
  ne_number      varchar2 (8),
  ne_sub_type    varchar2 (2),
  ne_group       varchar2 (30),
  ne_no_start    number (9),
  ne_no_end      number (9),
  ne_sub_class   varchar2 (4),
  ne_nsg_ref     varchar2 (240),
  ne_version_no  varchar2 (240),
  ne_new_id      number (9),
  CONSTRAINT nmr_pk
  PRIMARY KEY ( ne_id ) ) ;


CREATE global TEMPORARY TABLE nm_reversal_members (
  nm_ne_id_in     number (9)    NOT NULL,
  nm_ne_id_of     number (9)    NOT NULL,
  nm_type         varchar2 (4)  NOT NULL,
  nm_obj_type     varchar2 (4)  NOT NULL,
  nm_begin_mp     number        DEFAULT 0   NOT NULL,
  nm_start_date   DATE          DEFAULT TO_DATE('05111605','DDMMYYYY')   NOT NULL,
  nm_end_date     DATE,
  nm_end_mp       number,
  nm_admin_unit   number (9)    NOT NULL,
  nm_cardinality  number (1),
  ne_sub_class    varchar2 (4),
  CONSTRAINT nrm_pk
  PRIMARY KEY ( nm_ne_id_in, nm_ne_id_of, nm_begin_mp ) ) ;


CREATE INDEX of_ind ON
  nm_reversal_members(nm_ne_id_of)
;
--
-- INVENTORY BANDING tables
--
CREATE TABLE nm_inv_type_attrib_bandings
    (itb_inv_type            varchar2(4)  NOT NULL
    ,itb_attrib_name         varchar2(30) NOT NULL
    ,itb_banding_id          number       NOT NULL
    ,itb_banding_description varchar2(60) NOT NULL
    ,itb_date_created        DATE         NOT NULL
    ,itb_date_modified       DATE         NOT NULL
    ,itb_modified_by         varchar2(30) NOT NULL
    ,itb_created_by          varchar2(30) NOT NULL
    );
--
ALTER TABLE nm_inv_type_attrib_bandings
 ADD CONSTRAINT itb_pk
 PRIMARY KEY (itb_inv_type,itb_attrib_name,itb_banding_id);
--
ALTER TABLE nm_inv_type_attrib_bandings
 ADD CONSTRAINT itb_uk
 UNIQUE (itb_banding_id);
--
ALTER TABLE nm_inv_type_attrib_bandings
ADD CONSTRAINT itb_ita_fk
FOREIGN KEY (itb_inv_type,itb_attrib_name)
REFERENCES nm_inv_type_attribs_all (ita_inv_type,ita_attrib_name)
 ON DELETE CASCADE;
--
CREATE TABLE nm_inv_type_attrib_band_dets
    (itd_inv_type            varchar2(4)  NOT NULL
    ,itd_attrib_name         varchar2(30) NOT NULL
    ,itd_itb_banding_id      number       NOT NULL
    ,itd_band_seq            number       NOT NULL
    ,itd_band_min_value      number       NOT NULL
    ,itd_band_max_value      number       NOT NULL
    ,itd_band_description    varchar2(60) NOT NULL
    ,itd_date_created        DATE         NOT NULL
    ,itd_date_modified       DATE         NOT NULL
    ,itd_modified_by         varchar2(30) NOT NULL
    ,itd_created_by          varchar2(30) NOT NULL
    );
--
ALTER TABLE nm_inv_type_attrib_band_dets
ADD CONSTRAINT itd_pk PRIMARY KEY (itd_inv_type,itd_attrib_name,itd_itb_banding_id,itd_band_seq);
--
ALTER TABLE nm_inv_type_attrib_band_dets
ADD CONSTRAINT itd_itb_fk FOREIGN KEY (itd_inv_type,itd_attrib_name,itd_itb_banding_id)
REFERENCES nm_inv_type_attrib_bandings (itb_inv_type,itb_attrib_name,itb_banding_id) ON DELETE CASCADE;
--
CREATE SEQUENCE itb_banding_id_seq;
CREATE SEQUENCE itd_band_seq_seq;
--
-- Alter for NM_MRG_QUERY_ATTRIBS to facilitate banding of attributes
--
ALTER TABLE nm_mrg_query_attribs
ADD (nqa_itb_banding_id number);
--
ALTER TABLE nm_mrg_query_attribs
 ADD CONSTRAINT nqa_itb_fk
 FOREIGN KEY (nqa_itb_banding_id)
 REFERENCES nm_inv_type_attrib_bandings (itb_banding_id)
 ON DELETE SET NULL;
--
-- Alter for NM_MRG_DEFAULT_QUERY_ATTRIBS to facilitate banding of attributes
--
ALTER TABLE nm_mrg_default_query_attribs
ADD (nda_itb_banding_id number);
--
ALTER TABLE nm_mrg_default_query_attribs
 ADD CONSTRAINT nda_itb_fk
 FOREIGN KEY (nda_itb_banding_id)
 REFERENCES nm_inv_type_attrib_bandings (itb_banding_id)
 ON DELETE SET NULL;
--
-- ADMIN UNIT security temporary table
--
CREATE global TEMPORARY TABLE nm_au_security_temp
   (nast_ne_id    number
   ,nast_au_id    number
   ,nast_ne_of    number
   ,nast_nm_begin number
   ,nast_nm_end   number
   ) ON COMMIT DELETE ROWS
/
--
CREATE INDEX nast_ne_id_of_ix ON nm_au_security_temp(nast_ne_of);
--
-- HIG_MODULE_USAGES
--
ALTER TABLE hig_module_usages ADD (
  hmu_parameter varchar2(500) );
--
--
SET define ON
SET term ON
prompt
prompt running PACKAGE headers
SET term OFF
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
       '&terminator'||'pck'||'&terminator'||'nm3pkh.sql' run_file
FROM dual
/
START '&&run_file'
--
SET define ON
SET term ON
prompt
prompt running VIEWS
SET term OFF
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
       '&terminator'||'views'||'&terminator'||'nm3views.sql' run_file
FROM dual
/
START '&&run_file'
--
SET define ON
SET term ON
prompt
prompt running PACKAGE bodies
SET term OFF
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
       '&terminator'||'pck'||'&terminator'||'nm3pkb.sql' run_file
FROM dual
/
START '&&run_file'
--
SET define ON
SET term ON
prompt
prompt running TRIGGERS
SET term OFF
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
       '&terminator'||'trg'||'&terminator'||'nm3trg.sql' run_file
FROM dual
/
START '&&run_file'
--
SET define ON
SET term ON
prompt
prompt running context
SET term OFF
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
       '&terminator'||'ctx'||'&terminator'||'nm3ctx.sql' run_file
FROM dual
/
START '&&run_file'
--
SET define ON
SET term ON
prompt
prompt running fk_indexes
SET term OFF
SELECT '&exor_base'||'nm3'||'&terminator'||'install'||
       '&terminator'||'fk_indexes.sql' run_file
FROM dual
/
START '&&run_file'


EXECUTE hig2.upgrade('NET','nm3001_nm3002_upg.sql',-
        'Upgrade from 3001 to 3002','3.0.0.2')
/

EXIT;
