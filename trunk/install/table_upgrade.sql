--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)table_upgrade.sql	1.17 11/08/01
--       Module Name      : table_upgrade.sql
--       Date into SCCS   : 01/11/08 14:29:21
--       Date fetched Out : 07/06/13 13:59:28
--       SCCS Version     : 1.17
--
--   Table upgrade scripts
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
ALTER TABLE nm_mrg_query
MODIFY (nmq_transient_query    DEFAULT 'Y');
--
DROP  INDEX nmsmi_pk;
--
CREATE  INDEX nmsmi_ix ON
nm_mrg_section_member_inv(nsi_mrg_job_id, nsi_mrg_section_id, nsi_inv_type, nsi_x_sect) ;
--
ALTER TABLE nm_inv_types_all
ADD (nit_foreign_pk_column  varchar2 (30));
--
ALTER TABLE nm_inv_types_all
DROP CONSTRAINT nit_ft_check;
--
ALTER TABLE nm_inv_types_all
ADD CONSTRAINT nit_ft_check
          CHECK ( DECODE(nit_table_name,NULL,0,1)
                 +DECODE(nit_lr_ne_column_name,NULL,0,1)
                 +DECODE(nit_lr_st_chain,      NULL,0,1)
                 +DECODE(nit_lr_end_chain,     NULL,0,1)
                 +DECODE(nit_foreign_pk_column,NULL,0,1)
                  IN (0,5)
                );
--
ALTER TABLE nm_mrg_section_inv_values
ADD
(nsv_attrib26 varchar2(500)
,nsv_attrib27 varchar2(500)
,nsv_attrib28 varchar2(500)
,nsv_attrib29 varchar2(500)
,nsv_attrib30 varchar2(500)
,nsv_attrib31 varchar2(500)
,nsv_attrib32 varchar2(500)
,nsv_attrib33 varchar2(500)
,nsv_attrib34 varchar2(500)
,nsv_attrib35 varchar2(500)
,nsv_attrib36 varchar2(500)
,nsv_attrib37 varchar2(500)
,nsv_attrib38 varchar2(500)
,nsv_attrib39 varchar2(500)
,nsv_attrib40 varchar2(500)
,nsv_attrib41 varchar2(500)
,nsv_attrib42 varchar2(500)
,nsv_attrib43 varchar2(500)
,nsv_attrib44 varchar2(500)
,nsv_attrib45 varchar2(500)
,nsv_attrib46 varchar2(500)
,nsv_attrib47 varchar2(500)
,nsv_attrib48 varchar2(500)
,nsv_attrib49 varchar2(500)
,nsv_attrib50 varchar2(500)
,nsv_attrib51 varchar2(500)
,nsv_attrib52 varchar2(500)
,nsv_attrib53 varchar2(500)
,nsv_attrib54 varchar2(500)
,nsv_attrib55 varchar2(500)
,nsv_attrib56 varchar2(500)
,nsv_attrib57 varchar2(500)
,nsv_attrib58 varchar2(500)
,nsv_attrib59 varchar2(500)
,nsv_attrib60 varchar2(500)
,nsv_attrib61 varchar2(500)
,nsv_attrib62 varchar2(500)
,nsv_attrib63 varchar2(500)
,nsv_attrib64 varchar2(500)
,nsv_attrib65 varchar2(500)
,nsv_attrib66 varchar2(500)
,nsv_attrib67 varchar2(500)
,nsv_attrib68 varchar2(500)
,nsv_attrib69 varchar2(500)
,nsv_attrib70 varchar2(500)
,nsv_attrib71 varchar2(500)
,nsv_attrib72 varchar2(500)
,nsv_attrib73 varchar2(500)
,nsv_attrib74 varchar2(500)
,nsv_attrib75 varchar2(500)
,nsv_attrib76 varchar2(500)
,nsv_attrib77 varchar2(500)
,nsv_attrib78 varchar2(500)
,nsv_attrib79 varchar2(500)
,nsv_attrib80 varchar2(500)
,nsv_attrib81 varchar2(500)
,nsv_attrib82 varchar2(500)
,nsv_attrib83 varchar2(500)
,nsv_attrib84 varchar2(500)
,nsv_attrib85 varchar2(500)
,nsv_attrib86 varchar2(500)
,nsv_attrib87 varchar2(500)
,nsv_attrib88 varchar2(500)
,nsv_attrib89 varchar2(500)
,nsv_attrib90 varchar2(500)
,nsv_attrib91 varchar2(500)
,nsv_attrib92 varchar2(500)
,nsv_attrib93 varchar2(500)
,nsv_attrib94 varchar2(500)
,nsv_attrib95 varchar2(500)
,nsv_attrib96 varchar2(500)
,nsv_attrib97 varchar2(500)
,nsv_attrib98 varchar2(500)
,nsv_attrib99 varchar2(500)
,nsv_attrib100 varchar2(500)
);
--
ALTER TABLE nm_saved_extent_members ADD (nsm_sub_class varchar2(4));
ALTER TABLE nm_saved_extent_members ADD (nsm_sub_class_excl varchar2(4));
ALTER TABLE nm_saved_extent_members ADD (nsm_restrict_excl_sub_class varchar2(1) DEFAULT 'N' NOT NULL);
--
ALTER TABLE nm_mrg_query_users DROP CONSTRAINT nqu_hus_fk;
--
ALTER TABLE nm_mrg_sections DROP COLUMN nms_date_created;
ALTER TABLE nm_mrg_sections DROP COLUMN nms_date_modified;
ALTER TABLE nm_mrg_sections DROP COLUMN nms_modified_by;
ALTER TABLE nm_mrg_sections DROP COLUMN nms_created_by;
ALTER TABLE nm_mrg_section_inv_values DROP COLUMN nsv_date_created;
ALTER TABLE nm_mrg_section_inv_values DROP COLUMN nsv_date_modified;
ALTER TABLE nm_mrg_section_inv_values DROP COLUMN nsv_modified_by;
ALTER TABLE nm_mrg_section_inv_values DROP COLUMN nsv_created_by;
ALTER TABLE nm_mrg_section_members DROP COLUMN nsm_date_created;
ALTER TABLE nm_mrg_section_members DROP COLUMN nsm_date_modified;
ALTER TABLE nm_mrg_section_members DROP COLUMN nsm_modified_by;
ALTER TABLE nm_mrg_section_members DROP COLUMN nsm_created_by;
ALTER TABLE nm_mrg_section_member_inv DROP COLUMN nsi_date_created;
ALTER TABLE nm_mrg_section_member_inv DROP COLUMN nsi_date_modified;
ALTER TABLE nm_mrg_section_member_inv DROP COLUMN nsi_modified_by;
ALTER TABLE nm_mrg_section_member_inv DROP COLUMN nsi_created_by;
--
prompt ADD INDEX ON nm_mrg_query_members_temp2
CREATE INDEX nmqmt2_ix ON nm_mrg_query_members_temp2 (ne_id_of, begin_mp);
--
ALTER TABLE nm_saved_extents
 ADD CONSTRAINT nse_uk
 UNIQUE (nse_name);
--
ALTER TABLE nm_pbi_query
 ADD CONSTRAINT npq_uk
 UNIQUE (npq_unique);
--

prompt CREATE nm_reclass_details TABLE
CREATE TABLE nm_reclass_details
   (nrd_job_id    number                 NOT NULL
   ,nrd_old_ne_id number                 NOT NULL
   ,nrd_new_ne_id number                 NOT NULL
   ,nrd_timestamp DATE   DEFAULT SYSDATE NOT NULL
   );
--
prompt ALTER TABLE nm_reclass_details ADD CONSTRAINT nrd_pk PRIMARY KEY (nrd_job_id, nrd_old_ne_id);
ALTER TABLE nm_reclass_details
 ADD CONSTRAINT nrd_pk PRIMARY KEY (nrd_job_id, nrd_old_ne_id);
--
prompt ALTER TABLE nm_reclass_details ADD CONSTRAINT nrd_uk UNIQUE (nrd_job_id, nrd_new_ne_id);
ALTER TABLE nm_reclass_details
 ADD CONSTRAINT nrd_uk UNIQUE (nrd_job_id, nrd_new_ne_id);
--
CREATE TABLE nm_x_errors (
  nxe_id           number (9)    NOT NULL,
  nxe_error_text   varchar2 (80),
  nxe_error_class  varchar2 (3),
  CONSTRAINT nxe_pk
  PRIMARY KEY ( nxe_id ) ) ;
--
prompt RENAME nm_mrg_query_members_temp2 TO nm_mrg_query_members_temp
RENAME nm_mrg_query_members_temp2 TO nm_mrg_query_members_temp;
--
prompt ALTER TABLE nm_mrg_query_members_temp ADD (nte_seq_no number);
ALTER TABLE nm_mrg_query_members_temp
 ADD (nte_seq_no number);
--
ALTER TABLE nm_elements_all
 ADD CONSTRAINT ne_length_chk
 CHECK (DECODE(ne_type,'G',DECODE(ne_length,NULL,0,1),'P',DECODE(ne_length,NULL,0,1),'D',DECODE(ne_length,NULL,1,DECODE(ne_length,ABS(ne_length),0,1)),'S',DECODE(ne_length,NULL,1,0,1,DECODE(ne_length,ABS(ne_length),0,1)),1)=0);
--
ALTER TABLE nm_reversal
 ADD (ne_sub_class_old varchar2(4));
--
SET feedback OFF
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib101 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib102 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib103 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib104 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib105 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib106 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib107 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib108 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib109 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib110 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib111 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib112 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib113 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib114 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib115 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib116 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib117 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib118 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib119 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib120 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib121 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib122 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib123 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib124 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib125 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib126 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib127 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib128 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib129 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib130 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib131 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib132 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib133 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib134 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib135 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib136 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib137 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib138 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib139 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib140 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib141 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib142 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib143 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib144 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib145 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib146 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib147 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib148 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib149 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib150 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib151 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib152 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib153 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib154 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib155 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib156 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib157 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib158 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib159 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib160 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib161 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib162 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib163 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib164 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib165 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib166 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib167 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib168 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib169 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib170 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib171 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib172 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib173 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib174 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib175 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib176 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib177 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib178 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib179 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib180 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib181 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib182 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib183 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib184 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib185 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib186 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib187 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib188 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib189 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib190 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib191 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib192 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib193 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib194 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib195 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib196 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib197 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib198 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib199 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib200 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib201 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib202 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib203 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib204 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib205 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib206 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib207 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib208 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib209 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib210 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib211 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib212 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib213 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib214 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib215 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib216 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib217 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib218 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib219 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib220 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib221 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib222 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib223 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib224 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib225 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib226 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib227 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib228 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib229 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib230 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib231 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib232 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib233 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib234 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib235 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib236 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib237 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib238 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib239 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib240 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib241 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib242 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib243 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib244 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib245 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib246 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib247 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib248 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib249 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib250 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib251 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib252 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib253 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib254 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib255 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib256 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib257 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib258 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib259 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib260 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib261 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib262 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib263 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib264 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib265 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib266 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib267 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib268 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib269 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib270 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib271 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib272 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib273 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib274 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib275 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib276 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib277 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib278 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib279 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib280 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib281 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib282 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib283 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib284 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib285 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib286 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib287 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib288 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib289 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib290 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib291 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib292 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib293 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib294 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib295 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib296 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib297 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib298 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib299 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib300 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib301 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib302 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib303 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib304 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib305 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib306 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib307 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib308 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib309 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib310 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib311 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib312 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib313 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib314 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib315 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib316 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib317 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib318 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib319 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib320 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib321 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib322 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib323 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib324 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib325 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib326 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib327 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib328 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib329 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib330 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib331 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib332 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib333 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib334 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib335 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib336 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib337 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib338 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib339 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib340 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib341 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib342 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib343 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib344 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib345 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib346 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib347 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib348 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib349 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib350 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib351 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib352 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib353 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib354 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib355 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib356 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib357 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib358 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib359 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib360 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib361 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib362 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib363 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib364 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib365 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib366 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib367 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib368 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib369 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib370 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib371 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib372 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib373 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib374 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib375 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib376 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib377 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib378 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib379 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib380 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib381 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib382 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib383 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib384 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib385 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib386 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib387 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib388 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib389 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib390 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib391 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib392 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib393 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib394 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib395 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib396 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib397 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib398 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib399 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib400 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib401 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib402 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib403 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib404 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib405 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib406 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib407 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib408 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib409 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib410 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib411 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib412 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib413 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib414 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib415 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib416 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib417 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib418 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib419 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib420 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib421 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib422 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib423 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib424 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib425 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib426 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib427 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib428 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib429 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib430 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib431 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib432 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib433 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib434 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib435 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib436 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib437 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib438 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib439 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib440 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib441 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib442 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib443 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib444 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib445 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib446 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib447 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib448 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib449 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib450 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib451 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib452 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib453 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib454 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib455 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib456 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib457 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib458 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib459 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib460 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib461 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib462 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib463 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib464 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib465 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib466 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib467 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib468 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib469 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib470 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib471 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib472 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib473 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib474 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib475 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib476 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib477 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib478 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib479 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib480 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib481 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib482 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib483 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib484 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib485 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib486 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib487 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib488 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib489 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib490 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib491 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib492 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib493 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib494 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib495 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib496 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib497 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib498 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib499 varchar2(500));
ALTER TABLE nm_mrg_section_inv_values ADD (nsv_attrib500 varchar2(500));
--
--

--
--
--
--
--
--
--
--
--
ALTER TABLE nm_mrg_query_results_temp ADD (attrib101 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib102 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib103 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib104 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib105 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib106 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib107 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib108 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib109 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib110 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib111 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib112 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib113 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib114 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib115 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib116 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib117 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib118 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib119 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib120 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib121 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib122 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib123 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib124 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib125 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib126 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib127 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib128 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib129 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib130 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib131 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib132 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib133 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib134 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib135 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib136 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib137 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib138 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib139 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib140 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib141 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib142 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib143 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib144 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib145 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib146 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib147 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib148 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib149 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib150 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib151 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib152 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib153 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib154 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib155 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib156 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib157 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib158 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib159 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib160 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib161 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib162 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib163 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib164 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib165 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib166 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib167 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib168 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib169 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib170 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib171 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib172 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib173 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib174 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib175 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib176 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib177 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib178 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib179 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib180 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib181 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib182 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib183 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib184 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib185 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib186 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib187 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib188 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib189 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib190 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib191 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib192 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib193 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib194 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib195 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib196 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib197 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib198 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib199 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib200 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib201 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib202 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib203 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib204 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib205 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib206 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib207 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib208 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib209 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib210 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib211 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib212 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib213 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib214 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib215 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib216 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib217 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib218 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib219 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib220 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib221 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib222 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib223 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib224 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib225 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib226 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib227 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib228 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib229 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib230 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib231 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib232 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib233 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib234 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib235 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib236 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib237 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib238 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib239 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib240 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib241 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib242 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib243 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib244 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib245 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib246 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib247 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib248 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib249 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib250 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib251 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib252 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib253 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib254 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib255 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib256 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib257 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib258 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib259 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib260 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib261 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib262 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib263 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib264 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib265 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib266 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib267 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib268 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib269 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib270 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib271 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib272 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib273 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib274 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib275 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib276 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib277 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib278 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib279 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib280 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib281 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib282 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib283 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib284 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib285 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib286 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib287 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib288 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib289 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib290 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib291 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib292 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib293 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib294 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib295 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib296 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib297 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib298 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib299 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib300 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib301 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib302 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib303 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib304 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib305 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib306 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib307 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib308 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib309 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib310 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib311 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib312 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib313 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib314 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib315 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib316 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib317 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib318 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib319 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib320 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib321 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib322 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib323 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib324 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib325 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib326 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib327 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib328 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib329 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib330 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib331 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib332 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib333 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib334 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib335 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib336 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib337 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib338 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib339 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib340 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib341 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib342 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib343 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib344 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib345 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib346 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib347 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib348 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib349 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib350 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib351 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib352 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib353 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib354 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib355 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib356 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib357 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib358 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib359 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib360 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib361 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib362 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib363 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib364 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib365 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib366 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib367 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib368 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib369 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib370 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib371 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib372 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib373 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib374 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib375 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib376 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib377 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib378 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib379 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib380 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib381 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib382 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib383 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib384 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib385 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib386 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib387 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib388 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib389 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib390 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib391 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib392 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib393 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib394 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib395 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib396 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib397 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib398 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib399 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib400 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib401 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib402 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib403 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib404 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib405 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib406 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib407 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib408 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib409 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib410 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib411 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib412 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib413 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib414 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib415 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib416 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib417 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib418 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib419 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib420 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib421 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib422 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib423 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib424 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib425 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib426 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib427 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib428 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib429 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib430 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib431 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib432 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib433 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib434 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib435 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib436 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib437 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib438 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib439 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib440 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib441 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib442 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib443 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib444 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib445 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib446 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib447 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib448 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib449 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib450 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib451 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib452 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib453 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib454 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib455 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib456 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib457 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib458 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib459 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib460 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib461 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib462 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib463 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib464 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib465 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib466 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib467 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib468 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib469 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib470 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib471 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib472 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib473 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib474 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib475 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib476 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib477 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib478 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib479 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib480 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib481 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib482 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib483 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib484 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib485 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib486 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib487 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib488 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib489 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib490 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib491 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib492 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib493 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib494 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib495 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib496 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib497 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib498 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib499 varchar2(500));
ALTER TABLE nm_mrg_query_results_temp ADD (attrib500 varchar2(500));
--
ALTER TABLE gri_modules
ADD (grm_pre_process varchar2 (4000));
--
ALTER TABLE nm_au_security_temp
ADD (nast_nm_type  varchar2(4));
--
ALTER TABLE docs
MODIFY (doc_file varchar2(80));
--
prompt creating TABLE 'NM_X_INV_CONDITIONS'
CREATE TABLE nm_x_inv_conditions
 (nxic_id number(9,0) NOT NULL
 ,nxic_inv_type varchar2(4)
 ,nxic_inv_attr varchar2(30)
 ,nxic_condition varchar2(11)
 ,nxic_value_list varchar2(254)
 ,nxic_column_name varchar2(30)
 );
--
prompt creating TABLE 'NM_X_RULES'
CREATE TABLE nm_x_rules
 (nxr_rule_id number(9,0) NOT NULL
 ,nxr_type varchar2(1) NOT NULL
 ,nxr_error_id number(9,0)
 ,nxr_seq_no number(4,0)
 ,nxr_descr varchar2(80)
 );
--
prompt creating TABLE 'NM_X_DRIVING_CONDITIONS'
CREATE TABLE nm_x_driving_conditions
 (nxd_rule_id number(9,0) NOT NULL
 ,nxd_rule_seq_no number(4,0) NOT NULL
 ,nxd_rule_type varchar2(1)
 ,nxd_if_condition number(9,0)
 ,nxd_and_or varchar2(3)
 ,nxd_st_char varchar2(10)
 ,nxd_end_char varchar2(10)
 );
--
prompt creating TABLE 'NM_X_VAL_CONDITIONS'
CREATE TABLE nm_x_val_conditions
 (nxv_rule_id number(9,0) NOT NULL
 ,nxv_rule_seq_no number(4,0) NOT NULL
 ,nxv_rule_type varchar2(1)
 ,nxv_if_condition number(9,0)
 ,nxv_and_or varchar2(3)
 ,nxv_st_char varchar2(10)
 ,nxv_end_char varchar2(10)
 );
--
prompt creating PRIMARY KEY ON 'NM_X_INV_CONDITIONS'
ALTER TABLE nm_x_inv_conditions
 ADD CONSTRAINT nxic_pk PRIMARY KEY 
  (nxic_id);
--
prompt creating PRIMARY KEY ON 'NM_X_RULES'
ALTER TABLE nm_x_rules
 ADD CONSTRAINT pk_nm_x_rules PRIMARY KEY 
  (nxr_rule_id);
--
prompt creating PRIMARY KEY ON 'NM_X_DRIVING_CONDITIONS'
ALTER TABLE nm_x_driving_conditions
 ADD CONSTRAINT nxd_pk PRIMARY KEY 
  (nxd_rule_id
  ,nxd_rule_seq_no);
--
prompt creating PRIMARY KEY ON 'NM_X_VAL_CONDITIONS'
ALTER TABLE nm_x_val_conditions
 ADD CONSTRAINT nxv_pk PRIMARY KEY 
  (nxv_rule_id
  ,nxv_rule_seq_no);
--
prompt creating FOREIGN keys ON 'NM_X_INV_CONDITIONS'
ALTER TABLE nm_x_inv_conditions ADD CONSTRAINT
 nxic_nit_fk FOREIGN KEY 
  (nxic_inv_type) REFERENCES nm_inv_types_all
  (nit_inv_type);
--
prompt creating FOREIGN keys ON 'NM_X_RULES'
ALTER TABLE nm_x_rules ADD CONSTRAINT
 nxr_nxe_fk FOREIGN KEY 
  (nxr_error_id) REFERENCES nm_x_errors
  (nxe_id);
--
prompt creating FOREIGN keys ON 'NM_X_DRIVING_CONDITIONS'
ALTER TABLE nm_x_driving_conditions ADD CONSTRAINT
 nxd_nxr_fk FOREIGN KEY 
  (nxd_rule_id) REFERENCES nm_x_rules
  (nxr_rule_id) ADD CONSTRAINT
 nxd_nxic_fk FOREIGN KEY 
  (nxd_if_condition) REFERENCES nm_x_inv_conditions
  (nxic_id);
--
prompt creating FOREIGN keys ON 'NM_X_VAL_CONDITIONS'
ALTER TABLE nm_x_val_conditions ADD CONSTRAINT
 nxv_nxic_fk FOREIGN KEY 
  (nxv_if_condition) REFERENCES nm_x_inv_conditions
  (nxic_id) ADD CONSTRAINT
 nxv_nxr_fk FOREIGN KEY 
  (nxv_rule_id) REFERENCES nm_x_rules
  (nxr_rule_id);
--
prompt creating INDEX 'NXIC_NIT_FK_IND'
CREATE INDEX nxic_nit_fk_ind ON nm_x_inv_conditions
 (nxic_inv_type);
--
prompt creating INDEX 'NXR_NXE_FK_IND'
CREATE INDEX nxr_nxe_fk_ind ON nm_x_rules
 (nxr_error_id);
--
prompt creating INDEX 'NXD_NXIC_FK_IND'
CREATE INDEX nxd_nxic_fk_ind ON nm_x_driving_conditions
 (nxd_if_condition);
--
prompt creating INDEX 'NXD_NXR_FK_IND'
CREATE INDEX nxd_nxr_fk_ind ON nm_x_driving_conditions
 (nxd_rule_id);
--
prompt creating INDEX 'NXV_NXIC_FK_IND'
CREATE INDEX nxv_nxic_fk_ind ON nm_x_val_conditions
 (nxv_if_condition);
--
prompt creating INDEX 'NXV_NXR_FK_IND'
CREATE INDEX nxv_nxr_fk_ind ON nm_x_val_conditions
 (nxv_rule_id);
--
prompt creating TABLE 'NM_MRG_QUERY_ROLES'
CREATE TABLE nm_mrg_query_roles
 (nqro_nmq_id number(38) NOT NULL
 ,nqro_role varchar2(30) NOT NULL
 ,nqro_mode varchar2(10) NOT NULL
 );
--
prompt renaming nm_mrg_query
RENAME nm_mrg_query TO nm_mrg_query_all;
--
prompt renaming nm_mrg_query_types
RENAME nm_mrg_query_types TO nm_mrg_query_types_all;
--
prompt renaming nm_mrg_query_results
RENAME nm_mrg_query_results TO nm_mrg_query_results_all;
--
prompt renaming nm_mrg_query_results
RENAME nm_mrg_query_results TO nm_mrg_query_results_all;
--
prompt renaming nm_mrg_sections
RENAME nm_mrg_sections TO nm_mrg_sections_all;
--
prompt renaming nm_mrg_section_inv_values
RENAME nm_mrg_section_inv_values TO nm_mrg_section_inv_values_all;
--
prompt renaming nm_mrg_default_query_types
RENAME nm_mrg_default_query_types TO nm_mrg_default_query_types_all;
--
ALTER TABLE nm_mrg_query_results_all
ADD (nqr_admin_unit number(9));

UPDATE
  nm_mrg_query_results_all
SET
  nqr_admin_unit = 10;

ALTER TABLE nm_mrg_query_results_all
MODIFY (nqr_admin_unit NOT NULL);
--
prompt adding gp_gaz_restriction TO gri_params...
ALTER TABLE gri_params ADD(gp_gaz_restriction varchar2(6));
--
prompt adding gmp_allow_partial TO gri_module_params...
ALTER TABLE gri_module_params ADD(gmp_allow_partial varchar2(1) DEFAULT 'N');

UPDATE
  gri_module_params
SET
  gmp_allow_partial = 'N';
  
ALTER TABLE gri_module_params MODIFY(gmp_allow_partial NOT NULL);
--

