REM SCCS ID Keyword, do no remove
define sccsid = '@(#)temp_tables.sql	1.34 04/14/04';
/*
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)temp_tables.sql	1.34 04/14/04
--       Module Name      : temp_tables.sql
--       Date into SCCS   : 04/04/14 13:35:49
--       Date fetched Out : 07/06/13 13:59:29
--       SCCS Version     : 1.34
--
--   Temporary Tables creation script
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
*/


DROP TABLE nm_mrg_inv_items CASCADE CONSTRAINTS
/

CREATE GLOBAL TEMPORARY TABLE nm_mrg_inv_items
AS SELECT *
FROM nm_inv_items_all
WHERE 1=2
/

ALTER TABLE nm_mrg_inv_items
ADD (
  nqt_seq_no                 number        NOT NULL,
  pnt_or_cont                varchar2 (1)  NOT NULL )
/


CREATE UNIQUE INDEX nm_mrg_inv_items_pk ON
  nm_mrg_inv_items(iit_ne_id)
/

CREATE INDEX nm_mrg_inv_items_ix ON
  nm_mrg_inv_items(iit_inv_type, iit_x_sect)
/

DROP TABLE nm_mrg_members CASCADE CONSTRAINTS
/

CREATE GLOBAL TEMPORARY TABLE nm_mrg_members (
  nm_ne_id_in      number (38)   NOT NULL,
  nm_ne_id_of      number (38)   NOT NULL,
  nm_begin_mp      number        NOT NULL,
  nm_end_mp        number,
  nm_seq_no        number (38),
  inv_type         varchar2(4),
  element_length   number ,
  route_ne_id      number
  )
ON COMMIT DELETE ROWS
/
--
COMMENT ON TABLE nm_mrg_members IS 'This table is for Inventory merging, not for merging 2 elements'
/
--
CREATE INDEX nm_mrg_members_ix2 ON
  nm_mrg_members(nm_ne_id_of)
/

CREATE INDEX nm_mrg_members_ix ON
  nm_mrg_members(nm_ne_id_in)
/
CREATE INDEX nm_mrg_members_ix3 ON
  nm_mrg_members(inv_type)
/
DROP TABLE nm_mrg_members2 CASCADE CONSTRAINTS
/

CREATE GLOBAL TEMPORARY TABLE nm_mrg_members2
AS SELECT *
 FROM  nm_mrg_members
/
COMMENT ON TABLE nm_mrg_members IS 'This table is for Inventory merging, not for merging 2 elements'
/
--
ALTER TABLE nm_mrg_members2
ADD CONSTRAINT nmm2_uk
    UNIQUE (nm_ne_id_in, nm_ne_id_of, nm_begin_mp, nm_end_mp, nm_seq_no)
/

--DROP TABLE nm_pbi_members CASCADE CONSTRAINTS
--/
--
--CREATE GLOBAL TEMPORARY TABLE nm_pbi_members (
--  nm_ne_id_in      number (38)   NOT NULL,
--  nm_ne_id_of      number (38)   NOT NULL,
--  nm_begin_mp      number        NOT NULL,
--  nm_end_mp        number,
--  nm_seq_no        number (38),
--  inv_type         varchar2(4),
--  route_ne_id      number
--  )
--ON COMMIT DELETE ROWS
--/
--
--CREATE INDEX nm_pbi_members_ix2 ON
--  nm_pbi_members(nm_ne_id_of)
--/
--
--CREATE INDEX nm_pbi_members_ix ON
--  nm_pbi_members(nm_ne_id_in)
--/
--CREATE INDEX nm_pbi_members_ix3 ON
--  nm_pbi_members(inv_type)
--/
--


DROP TABLE nm_mrg_query_members_temp CASCADE CONSTRAINTS
/

CREATE GLOBAL TEMPORARY TABLE nm_mrg_query_members_temp (
  pl_id        number,
  ne_id_of     number,
  begin_mp     number,
  end_mp       number,
  measure      number,
  inv_type     varchar2 (30),
  x_sect       varchar2 (4),
  pnt_or_cont  varchar2 (1)  NOT NULL,
  value_id     number ,
  nte_seq_no   number )
ON COMMIT DELETE ROWS
/


DROP TABLE nm_mrg_query_results_temp CASCADE CONSTRAINTS
/

CREATE GLOBAL TEMPORARY TABLE nm_mrg_query_results_temp (
  ne_id        number        NOT NULL,
  inv_type     varchar2 (30)  NOT NULL,
  x_sect       varchar2 (4),
  pnt_or_cont  varchar2 (1)  NOT NULL,
  attrib1      varchar2 (500),
  attrib2      varchar2 (500),
  attrib3      varchar2 (500),
  attrib4      varchar2 (500),
  attrib5      varchar2 (500),
  attrib6      varchar2 (500),
  attrib7      varchar2 (500),
  attrib8      varchar2 (500),
  attrib9      varchar2 (500),
  attrib10     varchar2 (500),
  attrib11     varchar2 (500),
  attrib12     varchar2 (500),
  attrib13     varchar2 (500),
  attrib14     varchar2 (500),
  attrib15     varchar2 (500),
  attrib16     varchar2 (500),
  attrib17     varchar2 (500),
  attrib18     varchar2 (500),
  attrib19     varchar2 (500),
  attrib20     varchar2 (500),
  attrib21     varchar2 (500),
  attrib22     varchar2 (500),
  attrib23     varchar2 (500),
  attrib24     varchar2 (500),
  attrib25     varchar2 (500),
  attrib26     varchar2 (500),
  attrib27     varchar2 (500),
  attrib28     varchar2 (500),
  attrib29     varchar2 (500),
  attrib30     varchar2 (500),
  attrib31     varchar2 (500),
  attrib32     varchar2 (500),
  attrib33     varchar2 (500),
  attrib34     varchar2 (500),
  attrib35     varchar2 (500),
  attrib36     varchar2 (500),
  attrib37     varchar2 (500),
  attrib38     varchar2 (500),
  attrib39     varchar2 (500),
  attrib40     varchar2 (500),
  attrib41     varchar2 (500),
  attrib42     varchar2 (500),
  attrib43     varchar2 (500),
  attrib44     varchar2 (500),
  attrib45     varchar2 (500),
  attrib46     varchar2 (500),
  attrib47     varchar2 (500),
  attrib48     varchar2 (500),
  attrib49     varchar2 (500),
  attrib50     varchar2 (500),
  attrib51     varchar2 (500),
  attrib52     varchar2 (500),
  attrib53     varchar2 (500),
  attrib54     varchar2 (500),
  attrib55     varchar2 (500),
  attrib56     varchar2 (500),
  attrib57     varchar2 (500),
  attrib58     varchar2 (500),
  attrib59     varchar2 (500),
  attrib60     varchar2 (500),
  attrib61     varchar2 (500),
  attrib62     varchar2 (500),
  attrib63     varchar2 (500),
  attrib64     varchar2 (500),
  attrib65     varchar2 (500),
  attrib66     varchar2 (500),
  attrib67     varchar2 (500),
  attrib68     varchar2 (500),
  attrib69     varchar2 (500),
  attrib70     varchar2 (500),
  attrib71     varchar2 (500),
  attrib72     varchar2 (500),
  attrib73     varchar2 (500),
  attrib74     varchar2 (500),
  attrib75     varchar2 (500),
  attrib76     varchar2 (500),
  attrib77     varchar2 (500),
  attrib78     varchar2 (500),
  attrib79     varchar2 (500),
  attrib80     varchar2 (500),
  attrib81     varchar2 (500),
  attrib82     varchar2 (500),
  attrib83     varchar2 (500),
  attrib84     varchar2 (500),
  attrib85     varchar2 (500),
  attrib86     varchar2 (500),
  attrib87     varchar2 (500),
  attrib88     varchar2 (500),
  attrib89     varchar2 (500),
  attrib90     varchar2 (500),
  attrib91     varchar2 (500),
  attrib92     varchar2 (500),
  attrib93     varchar2 (500),
  attrib94     varchar2 (500),
  attrib95     varchar2 (500),
  attrib96     varchar2 (500),
  attrib97     varchar2 (500),
  attrib98     varchar2 (500),
  attrib99     varchar2 (500),
  attrib100    varchar2 (500),
  attrib101    varchar2 (500),
  attrib102    varchar2 (500),
  attrib103    varchar2 (500),
  attrib104    varchar2 (500),
  attrib105    varchar2 (500),
  attrib106    varchar2 (500),
  attrib107    varchar2 (500),
  attrib108    varchar2 (500),
  attrib109    varchar2 (500),
  attrib110    varchar2 (500),
  attrib111    varchar2 (500),
  attrib112    varchar2 (500),
  attrib113    varchar2 (500),
  attrib114    varchar2 (500),
  attrib115    varchar2 (500),
  attrib116    varchar2 (500),
  attrib117    varchar2 (500),
  attrib118    varchar2 (500),
  attrib119    varchar2 (500),
  attrib120    varchar2 (500),
  attrib121    varchar2 (500),
  attrib122    varchar2 (500),
  attrib123    varchar2 (500),
  attrib124    varchar2 (500),
  attrib125    varchar2 (500),
  attrib126    varchar2 (500),
  attrib127    varchar2 (500),
  attrib128    varchar2 (500),
  attrib129    varchar2 (500),
  attrib130    varchar2 (500),
  attrib131    varchar2 (500),
  attrib132    varchar2 (500),
  attrib133    varchar2 (500),
  attrib134    varchar2 (500),
  attrib135    varchar2 (500),
  attrib136    varchar2 (500),
  attrib137    varchar2 (500),
  attrib138    varchar2 (500),
  attrib139    varchar2 (500),
  attrib140    varchar2 (500),
  attrib141    varchar2 (500),
  attrib142    varchar2 (500),
  attrib143    varchar2 (500),
  attrib144    varchar2 (500),
  attrib145    varchar2 (500),
  attrib146    varchar2 (500),
  attrib147    varchar2 (500),
  attrib148    varchar2 (500),
  attrib149    varchar2 (500),
  attrib150    varchar2 (500),
  attrib151    varchar2 (500),
  attrib152    varchar2 (500),
  attrib153    varchar2 (500),
  attrib154    varchar2 (500),
  attrib155    varchar2 (500),
  attrib156    varchar2 (500),
  attrib157    varchar2 (500),
  attrib158    varchar2 (500),
  attrib159    varchar2 (500),
  attrib160    varchar2 (500),
  attrib161    varchar2 (500),
  attrib162    varchar2 (500),
  attrib163    varchar2 (500),
  attrib164    varchar2 (500),
  attrib165    varchar2 (500),
  attrib166    varchar2 (500),
  attrib167    varchar2 (500),
  attrib168    varchar2 (500),
  attrib169    varchar2 (500),
  attrib170    varchar2 (500),
  attrib171    varchar2 (500),
  attrib172    varchar2 (500),
  attrib173    varchar2 (500),
  attrib174    varchar2 (500),
  attrib175    varchar2 (500),
  attrib176    varchar2 (500),
  attrib177    varchar2 (500),
  attrib178    varchar2 (500),
  attrib179    varchar2 (500),
  attrib180    varchar2 (500),
  attrib181    varchar2 (500),
  attrib182    varchar2 (500),
  attrib183    varchar2 (500),
  attrib184    varchar2 (500),
  attrib185    varchar2 (500),
  attrib186    varchar2 (500),
  attrib187    varchar2 (500),
  attrib188    varchar2 (500),
  attrib189    varchar2 (500),
  attrib190    varchar2 (500),
  attrib191    varchar2 (500),
  attrib192    varchar2 (500),
  attrib193    varchar2 (500),
  attrib194    varchar2 (500),
  attrib195    varchar2 (500),
  attrib196    varchar2 (500),
  attrib197    varchar2 (500),
  attrib198    varchar2 (500),
  attrib199    varchar2 (500),
  attrib200    varchar2 (500),
  attrib201    varchar2 (500),
  attrib202    varchar2 (500),
  attrib203    varchar2 (500),
  attrib204    varchar2 (500),
  attrib205    varchar2 (500),
  attrib206    varchar2 (500),
  attrib207    varchar2 (500),
  attrib208    varchar2 (500),
  attrib209    varchar2 (500),
  attrib210    varchar2 (500),
  attrib211    varchar2 (500),
  attrib212    varchar2 (500),
  attrib213    varchar2 (500),
  attrib214    varchar2 (500),
  attrib215    varchar2 (500),
  attrib216    varchar2 (500),
  attrib217    varchar2 (500),
  attrib218    varchar2 (500),
  attrib219    varchar2 (500),
  attrib220    varchar2 (500),
  attrib221    varchar2 (500),
  attrib222    varchar2 (500),
  attrib223    varchar2 (500),
  attrib224    varchar2 (500),
  attrib225    varchar2 (500),
  attrib226    varchar2 (500),
  attrib227    varchar2 (500),
  attrib228    varchar2 (500),
  attrib229    varchar2 (500),
  attrib230    varchar2 (500),
  attrib231    varchar2 (500),
  attrib232    varchar2 (500),
  attrib233    varchar2 (500),
  attrib234    varchar2 (500),
  attrib235    varchar2 (500),
  attrib236    varchar2 (500),
  attrib237    varchar2 (500),
  attrib238    varchar2 (500),
  attrib239    varchar2 (500),
  attrib240    varchar2 (500),
  attrib241    varchar2 (500),
  attrib242    varchar2 (500),
  attrib243    varchar2 (500),
  attrib244    varchar2 (500),
  attrib245    varchar2 (500),
  attrib246    varchar2 (500),
  attrib247    varchar2 (500),
  attrib248    varchar2 (500),
  attrib249    varchar2 (500),
  attrib250    varchar2 (500),
  attrib251    varchar2 (500),
  attrib252    varchar2 (500),
  attrib253    varchar2 (500),
  attrib254    varchar2 (500),
  attrib255    varchar2 (500),
  attrib256    varchar2 (500),
  attrib257    varchar2 (500),
  attrib258    varchar2 (500),
  attrib259    varchar2 (500),
  attrib260    varchar2 (500),
  attrib261    varchar2 (500),
  attrib262    varchar2 (500),
  attrib263    varchar2 (500),
  attrib264    varchar2 (500),
  attrib265    varchar2 (500),
  attrib266    varchar2 (500),
  attrib267    varchar2 (500),
  attrib268    varchar2 (500),
  attrib269    varchar2 (500),
  attrib270    varchar2 (500),
  attrib271    varchar2 (500),
  attrib272    varchar2 (500),
  attrib273    varchar2 (500),
  attrib274    varchar2 (500),
  attrib275    varchar2 (500),
  attrib276    varchar2 (500),
  attrib277    varchar2 (500),
  attrib278    varchar2 (500),
  attrib279    varchar2 (500),
  attrib280    varchar2 (500),
  attrib281    varchar2 (500),
  attrib282    varchar2 (500),
  attrib283    varchar2 (500),
  attrib284    varchar2 (500),
  attrib285    varchar2 (500),
  attrib286    varchar2 (500),
  attrib287    varchar2 (500),
  attrib288    varchar2 (500),
  attrib289    varchar2 (500),
  attrib290    varchar2 (500),
  attrib291    varchar2 (500),
  attrib292    varchar2 (500),
  attrib293    varchar2 (500),
  attrib294    varchar2 (500),
  attrib295    varchar2 (500),
  attrib296    varchar2 (500),
  attrib297    varchar2 (500),
  attrib298    varchar2 (500),
  attrib299    varchar2 (500),
  attrib300    varchar2 (500),
  attrib301    varchar2 (500),
  attrib302    varchar2 (500),
  attrib303    varchar2 (500),
  attrib304    varchar2 (500),
  attrib305    varchar2 (500),
  attrib306    varchar2 (500),
  attrib307    varchar2 (500),
  attrib308    varchar2 (500),
  attrib309    varchar2 (500),
  attrib310    varchar2 (500),
  attrib311    varchar2 (500),
  attrib312    varchar2 (500),
  attrib313    varchar2 (500),
  attrib314    varchar2 (500),
  attrib315    varchar2 (500),
  attrib316    varchar2 (500),
  attrib317    varchar2 (500),
  attrib318    varchar2 (500),
  attrib319    varchar2 (500),
  attrib320    varchar2 (500),
  attrib321    varchar2 (500),
  attrib322    varchar2 (500),
  attrib323    varchar2 (500),
  attrib324    varchar2 (500),
  attrib325    varchar2 (500),
  attrib326    varchar2 (500),
  attrib327    varchar2 (500),
  attrib328    varchar2 (500),
  attrib329    varchar2 (500),
  attrib330    varchar2 (500),
  attrib331    varchar2 (500),
  attrib332    varchar2 (500),
  attrib333    varchar2 (500),
  attrib334    varchar2 (500),
  attrib335    varchar2 (500),
  attrib336    varchar2 (500),
  attrib337    varchar2 (500),
  attrib338    varchar2 (500),
  attrib339    varchar2 (500),
  attrib340    varchar2 (500),
  attrib341    varchar2 (500),
  attrib342    varchar2 (500),
  attrib343    varchar2 (500),
  attrib344    varchar2 (500),
  attrib345    varchar2 (500),
  attrib346    varchar2 (500),
  attrib347    varchar2 (500),
  attrib348    varchar2 (500),
  attrib349    varchar2 (500),
  attrib350    varchar2 (500),
  attrib351    varchar2 (500),
  attrib352    varchar2 (500),
  attrib353    varchar2 (500),
  attrib354    varchar2 (500),
  attrib355    varchar2 (500),
  attrib356    varchar2 (500),
  attrib357    varchar2 (500),
  attrib358    varchar2 (500),
  attrib359    varchar2 (500),
  attrib360    varchar2 (500),
  attrib361    varchar2 (500),
  attrib362    varchar2 (500),
  attrib363    varchar2 (500),
  attrib364    varchar2 (500),
  attrib365    varchar2 (500),
  attrib366    varchar2 (500),
  attrib367    varchar2 (500),
  attrib368    varchar2 (500),
  attrib369    varchar2 (500),
  attrib370    varchar2 (500),
  attrib371    varchar2 (500),
  attrib372    varchar2 (500),
  attrib373    varchar2 (500),
  attrib374    varchar2 (500),
  attrib375    varchar2 (500),
  attrib376    varchar2 (500),
  attrib377    varchar2 (500),
  attrib378    varchar2 (500),
  attrib379    varchar2 (500),
  attrib380    varchar2 (500),
  attrib381    varchar2 (500),
  attrib382    varchar2 (500),
  attrib383    varchar2 (500),
  attrib384    varchar2 (500),
  attrib385    varchar2 (500),
  attrib386    varchar2 (500),
  attrib387    varchar2 (500),
  attrib388    varchar2 (500),
  attrib389    varchar2 (500),
  attrib390    varchar2 (500),
  attrib391    varchar2 (500),
  attrib392    varchar2 (500),
  attrib393    varchar2 (500),
  attrib394    varchar2 (500),
  attrib395    varchar2 (500),
  attrib396    varchar2 (500),
  attrib397    varchar2 (500),
  attrib398    varchar2 (500),
  attrib399    varchar2 (500),
  attrib400    varchar2 (500),
  attrib401    varchar2 (500),
  attrib402    varchar2 (500),
  attrib403    varchar2 (500),
  attrib404    varchar2 (500),
  attrib405    varchar2 (500),
  attrib406    varchar2 (500),
  attrib407    varchar2 (500),
  attrib408    varchar2 (500),
  attrib409    varchar2 (500),
  attrib410    varchar2 (500),
  attrib411    varchar2 (500),
  attrib412    varchar2 (500),
  attrib413    varchar2 (500),
  attrib414    varchar2 (500),
  attrib415    varchar2 (500),
  attrib416    varchar2 (500),
  attrib417    varchar2 (500),
  attrib418    varchar2 (500),
  attrib419    varchar2 (500),
  attrib420    varchar2 (500),
  attrib421    varchar2 (500),
  attrib422    varchar2 (500),
  attrib423    varchar2 (500),
  attrib424    varchar2 (500),
  attrib425    varchar2 (500),
  attrib426    varchar2 (500),
  attrib427    varchar2 (500),
  attrib428    varchar2 (500),
  attrib429    varchar2 (500),
  attrib430    varchar2 (500),
  attrib431    varchar2 (500),
  attrib432    varchar2 (500),
  attrib433    varchar2 (500),
  attrib434    varchar2 (500),
  attrib435    varchar2 (500),
  attrib436    varchar2 (500),
  attrib437    varchar2 (500),
  attrib438    varchar2 (500),
  attrib439    varchar2 (500),
  attrib440    varchar2 (500),
  attrib441    varchar2 (500),
  attrib442    varchar2 (500),
  attrib443    varchar2 (500),
  attrib444    varchar2 (500),
  attrib445    varchar2 (500),
  attrib446    varchar2 (500),
  attrib447    varchar2 (500),
  attrib448    varchar2 (500),
  attrib449    varchar2 (500),
  attrib450    varchar2 (500),
  attrib451    varchar2 (500),
  attrib452    varchar2 (500),
  attrib453    varchar2 (500),
  attrib454    varchar2 (500),
  attrib455    varchar2 (500),
  attrib456    varchar2 (500),
  attrib457    varchar2 (500),
  attrib458    varchar2 (500),
  attrib459    varchar2 (500),
  attrib460    varchar2 (500),
  attrib461    varchar2 (500),
  attrib462    varchar2 (500),
  attrib463    varchar2 (500),
  attrib464    varchar2 (500),
  attrib465    varchar2 (500),
  attrib466    varchar2 (500),
  attrib467    varchar2 (500),
  attrib468    varchar2 (500),
  attrib469    varchar2 (500),
  attrib470    varchar2 (500),
  attrib471    varchar2 (500),
  attrib472    varchar2 (500),
  attrib473    varchar2 (500),
  attrib474    varchar2 (500),
  attrib475    varchar2 (500),
  attrib476    varchar2 (500),
  attrib477    varchar2 (500),
  attrib478    varchar2 (500),
  attrib479    varchar2 (500),
  attrib480    varchar2 (500),
  attrib481    varchar2 (500),
  attrib482    varchar2 (500),
  attrib483    varchar2 (500),
  attrib484    varchar2 (500),
  attrib485    varchar2 (500),
  attrib486    varchar2 (500),
  attrib487    varchar2 (500),
  attrib488    varchar2 (500),
  attrib489    varchar2 (500),
  attrib490    varchar2 (500),
  attrib491    varchar2 (500),
  attrib492    varchar2 (500),
  attrib493    varchar2 (500),
  attrib494    varchar2 (500),
  attrib495    varchar2 (500),
  attrib496    varchar2 (500),
  attrib497    varchar2 (500),
  attrib498    varchar2 (500),
  attrib499    varchar2 (500),
  attrib500    varchar2 (500) ) ON COMMIT DELETE ROWS
/


CREATE INDEX nmqrt_ix4 ON
  nm_mrg_query_results_temp(ne_id)
/

CREATE INDEX nmqrt_ix ON
  nm_mrg_query_results_temp(inv_type)
/

--
DROP TABLE nm_mrg_query_results_temp2 CASCADE CONSTRAINTS
/
--
CREATE GLOBAL TEMPORARY TABLE nm_mrg_query_results_temp2
AS SELECT *
FROM nm_mrg_query_results_temp
/
--
ALTER TABLE nm_mrg_query_results_temp2
ADD   CONSTRAINT nmqrt2_pk
  PRIMARY KEY ( ne_id ) DISABLE
/


DROP TABLE nm_nw_temp_extents CASCADE CONSTRAINTS
/

CREATE GLOBAL TEMPORARY TABLE nm_nw_temp_extents
  (nte_job_id         number (38)           NOT NULL
  ,nte_ne_id_of       number (38)           NOT NULL
  ,nte_begin_mp       number      DEFAULT 0 NOT NULL
  ,nte_end_mp         number
  ,nte_cardinality    number
  ,nte_seq_no         number
  ,nte_route_ne_id    number
  ) ON COMMIT PRESERVE ROWS
/

CREATE INDEX nte_ix ON nm_nw_temp_extents (nte_job_id, nte_ne_id_of)
/


DROP TABLE nm_temp_nodes CASCADE CONSTRAINTS
/

CREATE GLOBAL TEMPORARY TABLE nm_temp_nodes(
	ntn_route_id	number        NOT NULL,
	ntn_node_id	  number        NOT NULL,
	ntn_int_road	varchar2(100),
	ntn_node_type	varchar2(4)   NOT NULL,
	ntn_poe	      number,
	ntn_seq	      number,
	CONSTRAINT nm_temp_nodes_pk PRIMARY KEY (ntn_route_id, ntn_node_id ))
ON COMMIT preserve ROWS
/

DROP  TABLE nm_rescale_write CASCADE CONSTRAINTS
/

CREATE GLOBAL TEMPORARY TABLE nm_rescale_write (
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
  nm_end_mp       number )
/


CREATE UNIQUE INDEX rscw ON
  nm_rescale_write(ne_id)
/

CREATE INDEX rscw_start ON
  nm_rescale_write(s_ne_id)
/


DROP  TABLE nm_rescale_read CASCADE CONSTRAINTS
/

CREATE GLOBAL TEMPORARY TABLE nm_rescale_read (
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
  nm_end_mp       number )
/


CREATE UNIQUE INDEX rscr ON
  nm_rescale_read(ne_id)
/


DROP  TABLE nm_reversal CASCADE CONSTRAINTS
/

CREATE GLOBAL TEMPORARY TABLE nm_reversal (
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
  ne_sub_class_old  varchar2 (4) ,
  CONSTRAINT nmr_pk
  PRIMARY KEY ( ne_id ) )
/
--
--
-- ADMIN UNIT security temporary table
--
DROP TABLE nm_au_security_temp
/

CREATE GLOBAL TEMPORARY TABLE nm_au_security_temp
   (nast_ne_id    number
   ,nast_au_id    number
   ,nast_ne_of    number
   ,nast_nm_begin number
   ,nast_nm_end   number
   ,nast_nm_type  varchar2(4)
   ,nast_admin_type  varchar2(4)
   ) ON COMMIT DELETE ROWS
/
--
CREATE INDEX nast_ne_id_of_ix ON nm_au_security_temp(nast_ne_of)
/
--
DROP TABLE nm_create_group_temp
/
CREATE GLOBAL TEMPORARY TABLE nm_create_group_temp (
  ncg_job_id       number        NOT NULL,
  ncg_ne_id        number        NOT NULL,
  ncg_begin_mp     number        DEFAULT 0 NOT NULL,
  ncg_end_mp       number,
  ncg_cardinality  number,
  ncg_seq_1        number,
  ncg_seq_2        number)
ON COMMIT DELETE ROWS
/
--
DROP TABLE nm_assets_on_route
/
CREATE GLOBAL TEMPORARY TABLE nm_assets_on_route (
  nar_route_ne_id       number,
  nar_route_seq_no      number,
  nar_route_seg_no      number,
  nar_element_ne_id     number,
  nar_element_descr     varchar2 (80),
  nar_element_unique    varchar2 (30),
  nar_asset_ne_id       number,
  nar_asset_begin_mp    number,
  nar_asset_end_mp      number,
  nar_route_slk         number,
  nar_route_true        number,
  nar_asset_type        varchar2 (4),
  nar_asset_measure     number,
  nar_asset_type_descr  varchar2 (80),
  nar_asset_pk          varchar2 (30),
  nar_located_by        number,
  nar_located_pk        varchar2 (30),
  nar_located_type      varchar2 (4),
  nar_loc_type_descr    varchar2 (80),
  nar_type              varchar2 (1),
  nar_ref_post          number,
  nar_ref_pk            varchar2 (30),
  nar_ref_measure       number)
ON COMMIT preserve ROWS
/

CREATE INDEX nmqmt_ix
 ON nm_mrg_query_members_temp(ne_id_of, begin_mp, end_mp)
/


DROP table nm_merge_members
/
create global temporary table nm_merge_members
as select *
from nm_members_all
where 1=2
/
--
COMMENT ON TABLE nm_merge_members IS 'This is a temporary table for merging 2 elements, not for the inventory merge'
/
--
CREATE INDEX nm_merge_members_of_ix
 ON nm_merge_members (nm_ne_id_of)
/
--
DROP TABLE nm_temp_inv_items_temp
/
--
CREATE global temporary TABLE nm_temp_inv_items_temp AS
SELECT *
 FROM  nm_temp_inv_items
WHERE  1 = 2
/
ALTER TABLE nm_temp_inv_items_temp ADD CONSTRAINT tii_temp_pk PRIMARY KEY(tii_njc_job_id, tii_ne_id, tii_ne_id_new)
/
--
DROP TABLE nm_temp_inv_members_temp
/
--
CREATE global temporary TABLE nm_temp_inv_members_temp AS
SELECT *
 FROM  nm_temp_inv_members
WHERE  1 = 2
/
ALTER TABLE nm_temp_inv_members_temp ADD CONSTRAINT tim_temp_pk PRIMARY KEY(tim_njc_job_id, tim_ne_id_in, tim_ne_id_in_new, tim_ne_id_of, tim_extent_begin_mp)
/
--

DROP TABLE NM_GAZ_QUERY;

CREATE GLOBAL TEMPORARY TABLE NM_GAZ_QUERY
(
  NGQ_ID                 NUMBER(9)                  NOT NULL
 ,NGQ_SOURCE_ID          NUMBER                     NOT NULL
 ,NGQ_SOURCE             VARCHAR2(10)               NOT NULL
 ,NGQ_OPEN_OR_CLOSED     VARCHAR2(1)  DEFAULT 'C'   NOT NULL
 ,NGQ_ITEMS_OR_AREA      VARCHAR2(1)  DEFAULT 'A'   NOT NULL
 ,NGQ_QUERY_ALL_ITEMS    VARCHAR2(1)  DEFAULT 'N'   NOT NULL
 ,NGQ_BEGIN_MP           NUMBER
 ,NGQ_BEGIN_DATUM_NE_ID  NUMBER
 ,NGQ_BEGIN_DATUM_OFFSET NUMBER
 ,NGQ_END_MP             NUMBER
 ,NGQ_END_DATUM_NE_ID    NUMBER
 ,NGQ_END_DATUM_OFFSET   NUMBER
 ,NGQ_AMBIG_SUB_CLASS    VARCHAR2(4)
)
ON COMMIT PRESERVE ROWS
/

DROP TABLE NM_GAZ_QUERY_TYPES;

CREATE GLOBAL TEMPORARY TABLE NM_GAZ_QUERY_TYPES
(
  NGQT_NGQ_ID         NUMBER(9)                  NOT NULL
 ,NGQT_SEQ_NO         NUMBER(9)                  NOT NULL
 ,NGQT_ITEM_TYPE_TYPE VARCHAR2(4)                NOT NULL
 ,NGQT_ITEM_TYPE      VARCHAR2(4)                NOT NULL
)
ON COMMIT PRESERVE ROWS
/

DROP TABLE NM_GAZ_QUERY_ATTRIBS;

CREATE GLOBAL TEMPORARY TABLE NM_GAZ_QUERY_ATTRIBS
(
  NGQA_NGQ_ID         NUMBER(9)                  NOT NULL
 ,NGQA_NGQT_SEQ_NO    NUMBER(9)                  NOT NULL
 ,NGQA_SEQ_NO         NUMBER(9)                  NOT NULL
 ,NGQA_ATTRIB_NAME    VARCHAR2(30)               NOT NULL
 ,NGQA_OPERATOR       VARCHAR2(3)  DEFAULT 'AND' NOT NULL
 ,NGQA_PRE_BRACKET    VARCHAR2(5)
 ,NGQA_POST_BRACKET   VARCHAR2(5)
 ,NGQA_CONDITION      VARCHAR2(30)               NOT NULL
)
ON COMMIT PRESERVE ROWS
/


DROP TABLE NM_GAZ_QUERY_VALUES;

CREATE GLOBAL TEMPORARY TABLE NM_GAZ_QUERY_VALUES
(
  NGQV_NGQ_ID         NUMBER(9)                  NOT NULL
 ,NGQV_NGQT_SEQ_NO    NUMBER(9)                  NOT NULL
 ,NGQV_NGQA_SEQ_NO    NUMBER(9)                  NOT NULL
 ,NGQV_SEQUENCE       NUMBER(4)                  NOT NULL
 ,NGQV_VALUE          VARCHAR2(4000)             NOT NULL
)
ON COMMIT PRESERVE ROWS
/


ALTER TABLE NM_GAZ_QUERY ADD (
  CONSTRAINT NGQ_PK PRIMARY KEY (NGQ_ID))
/

ALTER TABLE NM_GAZ_QUERY_ATTRIBS ADD (
  CONSTRAINT NGQA_PK PRIMARY KEY (NGQA_NGQ_ID, NGQA_NGQT_SEQ_NO, NGQA_SEQ_NO))
/

ALTER TABLE NM_GAZ_QUERY_TYPES ADD (
  CONSTRAINT NGQT_PK PRIMARY KEY (NGQT_NGQ_ID, NGQT_SEQ_NO))
/

ALTER TABLE NM_GAZ_QUERY_VALUES ADD (
  CONSTRAINT NGQV_PK PRIMARY KEY (NGQV_NGQ_ID, NGQV_NGQT_SEQ_NO, NGQV_NGQA_SEQ_NO, NGQV_SEQUENCE))
/


CREATE INDEX NGQA_NGQT_FK_IND ON NM_GAZ_QUERY_ATTRIBS
(NGQA_NGQ_ID, NGQA_NGQT_SEQ_NO)
/

CREATE INDEX NGQV_NGQA_FK_IND ON NM_GAZ_QUERY_VALUES
(NGQV_NGQ_ID, NGQV_NGQT_SEQ_NO, NGQV_NGQA_SEQ_NO)
/

ALTER TABLE NM_GAZ_QUERY_TYPES ADD
  CONSTRAINT NGQT_ITEM_TYPE_TYPE_CHK
  CHECK (NGQT_ITEM_TYPE_TYPE IN ('I','E'))
/

ALTER TABLE NM_GAZ_QUERY ADD
  CONSTRAINT NGQ_ITEMS_OR_AREA_CHK
  CHECK (NGQ_ITEMS_OR_AREA IN ('I','A'))
/
ALTER TABLE NM_GAZ_QUERY ADD
  CONSTRAINT NGQ_QUERY_ALL_ITEMS_CHK
  CHECK (NGQ_QUERY_ALL_ITEMS IN ('Y','N'))
/
ALTER TABLE NM_GAZ_QUERY ADD
  CONSTRAINT NGQ_QUERY_ALL_ITEMS_AREA_CHK
  CHECK (DECODE(NGQ_ITEMS_OR_AREA,'A',1,0)+DECODE(NGQ_QUERY_ALL_ITEMS,'Y',1,0) != 2)
/


ALTER TABLE NM_GAZ_QUERY_ATTRIBS ADD
  CONSTRAINT NGQA_OPERATOR_CHK
  CHECK (NGQA_OPERATOR IN ('AND','OR'))
/

ALTER TABLE NM_GAZ_QUERY_ATTRIBS ADD
  CONSTRAINT NGQA_BRACKET_CHK
  CHECK (    NGQA_PRE_BRACKET  IN ('(','((','(((','((((','(((((')
         AND NGQA_POST_BRACKET IN (')','))',')))','))))',')))))')
        )
/


ALTER TABLE NM_GAZ_QUERY
 ADD CONSTRAINT NGQ_OPEN_OR_CLOSED_CHK
 CHECK (NGQ_OPEN_OR_CLOSED IN ('O','C'))
/

ALTER TABLE nm_gaz_query
 ADD CONSTRAINT ngq_entire_region_chk
 CHECK (DECODE(ngq_query_all_items,'N',5,0)+DECODE(ngq_source_id,-1,5,0) != 10)
/



DROP TABLE nm_gaz_query_item_list
/
CREATE TABLE nm_gaz_query_item_list
   (ngqi_job_id         NUMBER      NOT NULL
   ,ngqi_item_type_type VARCHAR2(1) NOT NULL
   ,ngqi_item_type      VARCHAR2(4) NOT NULL
   ,ngqi_item_id        NUMBER      NOT NULL
   )
/

ALTER TABLE nm_gaz_query_item_list
 ADD CONSTRAINT ngqi_pk
 PRIMARY KEY
   (ngqi_job_id
   ,ngqi_item_type_type
   ,ngqi_item_type
   ,ngqi_item_id
   )
/
--
DROP TABLE nm_assets_on_route_holding
/
--
CREATE GLOBAL TEMPORARY TABLE nm_assets_on_route_holding
   (narh_job_id                   NUMBER      NOT NULL
   ,narh_ne_id_in                 NUMBER(9)   NOT NULL
   ,narh_item_x_sect              VARCHAR2(4)
   ,narh_ne_id_of_begin           NUMBER(9)   NOT NULL
   ,narh_begin_mp                 NUMBER      NOT NULL
   ,narh_ne_id_of_end             NUMBER(9)   NOT NULL
   ,narh_end_mp                   NUMBER      NOT NULL
   ,narh_seq_no                   NUMBER      NOT NULL
   ,narh_seg_no                   NUMBER      NOT NULL
   ,narh_item_type_type           VARCHAR2(4) NOT NULL
   ,narh_item_type                VARCHAR2(4) NOT NULL
   ,narh_nm_type                  VARCHAR2(4) NOT NULL
   ,narh_nm_obj_type              VARCHAR2(4) NOT NULL
   ,narh_placement_begin_mp       NUMBER      NOT NULL
   ,narh_placement_end_mp         NUMBER      NOT NULL
   ,narh_reference_item_id        NUMBER
   ,narh_begin_reference_begin_mp NUMBER
   ,narh_begin_reference_end_mp   NUMBER
   ,narh_end_reference_begin_mp   NUMBER
   ,narh_end_reference_end_mp     NUMBER
   )
   ON COMMIT PRESERVE ROWS
/

ALTER TABLE nm_assets_on_route_holding
 ADD CONSTRAINT
 narh_pk PRIMARY KEY
         (narh_job_id
         ,narh_ne_id_in
         ,narh_ne_id_of_begin
         ,narh_begin_mp
         )
/

CREATE INDEX narh_item_type_ix ON nm_assets_on_route_holding
 (narh_job_id,narh_item_type_type,narh_item_type)
/

drop table nm_rescale_seg_tree;


create global temporary table nm_rescale_seg_tree
   ( nrt_parent_seg_no number,
     nrt_child_seg_no  number,
     nrt_parent_sub_class number,
     nrt_child_sub_class  number,
     nrt_connect_level    number )
/

alter table nm_rescale_seg_tree
add constraint nrt_pk primary key
( nrt_parent_seg_no, nrt_child_seg_no )
/

alter table nm_rescale_seg_tree
add ( constraint nrt_uk unique
( nrt_child_seg_no, nrt_parent_seg_no ))
/

create unique index nrt_uk on nm_rescale_seg_tree
( nrt_child_seg_no, nrt_parent_seg_no )
/

DROP TABLE nm_assets_on_route_store_att
/

CREATE GLOBAL TEMPORARY TABLE nm_assets_on_route_store_att
(
  narsa_job_id     number                       NOT NULL,
  narsa_iit_ne_id  number                       NOT NULL,
  narsa_value      varchar2(4000)
)
ON COMMIT DELETE ROWS
/

ALTER TABLE nm_assets_on_route_store_att ADD (
  CONSTRAINT narsa_pk PRIMARY KEY (narsa_job_id, narsa_iit_ne_id))
/

DROP TABLE nm_assets_on_route_store_att_d
/

CREATE GLOBAL TEMPORARY TABLE nm_assets_on_route_store_att_d
(
  narsd_job_id       number                     NOT NULL,
  narsd_iit_ne_id    number                     NOT NULL,
  narsd_attrib_name  varchar2(30)               NOT NULL,
  narsd_seq_no       number                     NOT NULL,
  narsd_value        varchar2(4000),
  narsd_scrn_text    varchar2(30)
)
ON COMMIT DELETE ROWS
/

ALTER TABLE nm_assets_on_route_store_att_d ADD (
  CONSTRAINT narsd_pk PRIMARY KEY (narsd_job_id, narsd_iit_ne_id, narsd_attrib_name))
/

DROP TABLE NM_SDO_TRG_MEMBERS
/

CREATE global temporary TABLE NM_SDO_TRG_MEMBERS
 (
   NSTM_ID         NUMBER(9),
   NSTM_NE_ID_IN   NUMBER(9),
   NSTM_NE_ID_OF   NUMBER(9),
   NSTM_TYPE       VARCHAR2(1),
   NSTM_OBJ_TYPE   VARCHAR2(4),
   NSTM_ROWID      ROWID,
   NSTM_OPERATION  VARCHAR2(1)
 )
/


