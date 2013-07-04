set termout on
set pages 1000
clear screen
spool nm2_nm3_object_setup.log
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/mig/nm2_nm3_object_setup.sql-arc   2.2   Jul 04 2013 16:49:10   James.Wadsworth  $
--       Module Name      : $Workfile:   nm2_nm3_object_setup.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:49:10  $
--       Date fetched Out : $Modtime:   Jul 04 2013 16:46:22  $
--       PVCS Version     : $Revision:   2.2  $
-----------------------------------------------------------------------------
--
--   SCCS IDENTIFIERS :-
--
-- sccsid : @(#)nm2_nm3_object_setup.sql	1.17 02/16/07
-- Module Name : nm2_nm3_object_setup.sql
-- Date into SCCS : 07/02/16 11:03:22
-- Date fetched Out : 07/02/16 11:03:34
-- SCCS Version : 1.17

--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
PROMPT ================================================================
PROMPT Migration of Core Highways and Network Manager - Migration Setup
PROMPT ================================================================

undefine p_dblink
undefine p_schema

col p_schema new_value p_schema noprint
col p_dblink new_value p_dblink noprint

set verify off head off feedback off term on serveroutput on define on

accept p_schema prompt    "Enter name of the Source Highways Owner [HIGHWAYS]: " DEFAULT HIGHWAYS

prompt
prompt If your Source Highways owner is on a different instance then enter the name of the database link
prompt across which you can point to the Source Highways Owner.
prompt Otherwise just press RETURN
prompt
prompt List of Database Links Available
prompt ================================
prompt
set heading on
select substr(db_link,1,30) link_name
     , substr(username||' on '||host,1,45)    link_points_at
from all_db_links
/
set heading off
prompt
accept p_dblink prompt   "Database link name or just press RETURN [Null]: "


select DECODE('&p_dblink',Null,Null,'@&p_dblink') p_dblink
from dual
/

BEGIN
 IF USER != hig.get_application_owner THEN
    raise_application_error(-20001,'This script must be run as the Highways Owner.');
 END IF;
END;
/

DECLARE

 g_tab_sql nm3type.tab_varchar2000;
 e_pub_syn_not_exist EXCEPTION;
 e_prv_syn_not_exist EXCEPTION;

 fin_tab_count number;

 PRAGMA EXCEPTION_INIT(e_pub_syn_not_exist, -01432);
 PRAGMA EXCEPTION_INIT(e_pub_syn_not_exist, -01434);

 PROCEDURE append(pi_sql IN VARCHAR2) IS

  v_index PLS_INTEGER;

 BEGIN

  v_index := g_tab_sql.COUNT+1;
  g_tab_sql(v_index) := pi_sql;

 END;


BEGIN
  append(pi_sql => 'drop synonym v2_INTERVALS');
  append(pi_sql => 'DROP SYNONYM v2_dba_role_privs');
  append(pi_sql => 'DROP SYNONYM v2_dba_users');
  append(pi_sql => 'DROP SYNONYM v2_role_sys_privs');
  append(pi_sql => 'DROP SYNONYM v2_hig_users');
  append(pi_sql => 'DROP SYNONYM v2_hig_address');
  append(pi_sql => 'DROP SYNONYM v2_hig_address_point');
  append(pi_sql => 'DROP SYNONYM v2_hig_admin_units');
  append(pi_sql => 'DROP SYNONYM v2_hig_admin_groups');
  append(pi_sql => 'DROP SYNONYM v2_hig_roles');
  append(pi_sql => 'DROP SYNONYM v2_hig_products');
  append(pi_sql => 'DROP SYNONYM v2_hig_domains');
  append(pi_sql => 'DROP SYNONYM v2_hig_codes');
  append(pi_sql => 'DROP SYNONYM v2_hig_contacts');
  append(pi_sql => 'DROP SYNONYM v2_hig_contact_address');
  append(pi_sql => 'DROP SYNONYM v2_hig_holidays');
  append(pi_sql => 'DROP SYNONYM v2_hig_modules');
  append(pi_sql => 'DROP SYNONYM v2_hig_module_roles');
  append(pi_sql => 'DROP SYNONYM v2_hig_status_domains');
  append(pi_sql => 'DROP SYNONYM v2_hig_status_codes');
  append(pi_sql => 'DROP SYNONYM v2_gis_projects');
  append(pi_sql => 'DROP SYNONYM v2_gis_themes_all');
  append(pi_sql => 'DROP SYNONYM v2_gis_theme_functions');
  append(pi_sql => 'DROP SYNONYM v2_gis_theme_roles');
  append(pi_sql => 'DROP SYNONYM v2_group_types');
  append(pi_sql => 'DROP SYNONYM v2_node_usages');
  append(pi_sql => 'DROP SYNONYM v2_section_classes');
  append(pi_sql => 'DROP SYNONYM v2_inv_item_types');
  append(pi_sql => 'DROP SYNONYM v2_inv_type_attribs');
  append(pi_sql => 'DROP SYNONYM v2_inv_attri_domains');
  append(pi_sql => 'DROP SYNONYM v2_xsp_restraints');
  append(pi_sql => 'DROP SYNONYM v2_hig_options');
  append(pi_sql => 'DROP SYNONYM v2_hig_user_options');
  append(pi_sql => 'DROP SYNONYM v2_inv_items_all');
  append(pi_sql => 'DROP SYNONYM v2_road_segs');
  append(pi_sql => 'DROP SYNONYM v2_road_seg_membs_all');
  append(pi_sql => 'DROP SYNONYM v2_road_seg_membs');
  append(pi_sql => 'DROP SYNONYM v2_points');
  append(pi_sql => 'DROP SYNONYM v2_point_usages');
  append(pi_sql => 'DROP SYNONYM v2_DOCS');
  append(pi_sql => 'DROP SYNONYM v2_DOC_ACTIONS');
  append(pi_sql => 'DROP SYNONYM v2_DOC_ACTION_HISTORY');
  append(pi_sql => 'DROP SYNONYM v2_DOC_ASSOCS');
  append(pi_sql => 'DROP SYNONYM v2_DOC_CLASS');
  append(pi_sql => 'DROP SYNONYM v2_DOC_COPIES');
  append(pi_sql => 'DROP SYNONYM v2_DOC_DAMAGE');
  append(pi_sql => 'DROP SYNONYM v2_DOC_DAMAGE_COSTS');
  append(pi_sql => 'DROP SYNONYM v2_DOC_ENQUIRY_CONTACTS');
  append(pi_sql => 'DROP SYNONYM v2_DOC_ENQUIRY_TYPES');
  append(pi_sql => 'DROP SYNONYM v2_DOC_GATEWAYS');
  append(pi_sql => 'DROP SYNONYM v2_DOC_GATE_SYNS');
  append(pi_sql => 'DROP SYNONYM v2_DOC_HISTORY');
  append(pi_sql => 'DROP SYNONYM v2_DOC_KEYS');
  append(pi_sql => 'DROP SYNONYM v2_DOC_KEYWORDS');
  append(pi_sql => 'DROP SYNONYM v2_DOC_LOCATIONS');
  append(pi_sql => 'DROP SYNONYM v2_DOC_LOV_RECS');
  append(pi_sql => 'DROP SYNONYM v2_DOC_MEDIA');
  append(pi_sql => 'DROP SYNONYM v2_DOC_REDIR_PRIOR');
  append(pi_sql => 'DROP SYNONYM v2_DOC_STD_ACTIONS');
  append(pi_sql => 'DROP SYNONYM v2_DOC_STD_COSTS');
  append(pi_sql => 'DROP SYNONYM v2_DOC_SYNONYMS');
  append(pi_sql => 'DROP SYNONYM v2_DOC_TEMPLATE_COLUMNS');
  append(pi_sql => 'DROP SYNONYM v2_DOC_TEMPLATE_GATEWAYS');
  append(pi_sql => 'DROP SYNONYM v2_DOC_TEMPLATE_USERS');
  append(pi_sql => 'DROP SYNONYM v2_DOC_TYPES');
  append(pi_sql => 'DROP SYNONYM v2_FINANCIAL_YEARS');

--
  append(pi_sql => 'CREATE SYNONYM v2_dba_role_privs       FOR sys.dba_role_privs&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_dba_users            FOR sys.dba_users&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_role_sys_privs       FOR sys.role_sys_privs&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_hig_users            FOR &p_schema..hig_users&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_hig_address          FOR &p_schema..hig_address&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_hig_address_point    FOR &p_schema..hig_address_point&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_hig_admin_units      FOR &p_schema..hig_admin_units&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_hig_admin_groups     FOR &p_schema..hig_admin_groups&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_hig_roles            FOR &p_schema..hig_roles&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_hig_products         FOR &p_schema..hig_products&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_hig_domains          FOR &p_schema..hig_domains&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_hig_codes            FOR &p_schema..hig_codes&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_hig_contacts         FOR &p_schema..hig_contacts&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_hig_contact_address  FOR &p_schema..hig_contact_address&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_hig_holidays         FOR &p_schema..hig_holidays&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_hig_modules          FOR &p_schema..hig_modules&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_hig_module_roles     FOR &p_schema..hig_module_roles&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_hig_status_domains   FOR &p_schema..hig_status_domains&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_hig_status_codes     FOR &p_schema..hig_status_codes&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_gis_projects         FOR &p_schema..gis_projects&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_gis_themes_all       FOR &p_schema..gis_themes_all&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_gis_theme_functions  FOR &p_schema..gis_theme_functions&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_gis_theme_roles      FOR &p_schema..gis_theme_roles&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_group_types          FOR &p_schema..group_types&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_node_usages          FOR &p_schema..node_usages&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_section_classes      FOR &p_schema..section_classes&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_inv_item_types       FOR &p_schema..inv_item_types&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_inv_type_attribs     FOR &p_schema..inv_type_attribs&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_inv_attri_domains     FOR &p_schema..inv_attri_domains&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_xsp_restraints       FOR &p_schema..xsp_restraints&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_hig_options          FOR &p_schema..hig_options&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_hig_user_options     FOR &p_schema..hig_user_options&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_inv_items_all        FOR &p_schema..inv_items_all&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_road_segs            FOR &p_schema..road_segs&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_road_seg_membs_all   FOR &p_schema..road_seg_membs_all&p_dblink');
  --append(pi_sql => 'CREATE SYNONYM v2_road_seg_membs       FOR &p_schema..road_seg_membs&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_points               FOR &p_schema..points&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_point_usages         FOR &p_schema..point_usages&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOCS                 FOR &p_schema..DOCS&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_ACTIONS          FOR &p_schema..DOC_ACTIONS&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_ACTION_HISTORY   FOR &p_schema..DOC_ACTION_HISTORY&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_ASSOCS           FOR &p_schema..DOC_ASSOCS&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_CLASS            FOR &p_schema..DOC_CLASS&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_COPIES           FOR &p_schema..DOC_COPIES&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_DAMAGE           FOR &p_schema..DOC_DAMAGE&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_DAMAGE_COSTS     FOR &p_schema..DOC_DAMAGE_COSTS&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_ENQUIRY_CONTACTS FOR &p_schema..DOC_ENQUIRY_CONTACTS&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_ENQUIRY_TYPES    FOR &p_schema..DOC_ENQUIRY_TYPES&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_GATEWAYS         FOR &p_schema..DOC_GATEWAYS&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_GATE_SYNS        FOR &p_schema..DOC_GATE_SYNS&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_HISTORY          FOR &p_schema..DOC_HISTORY&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_KEYS             FOR &p_schema..DOC_KEYS&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_KEYWORDS         FOR &p_schema..DOC_KEYWORDS&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_LOCATIONS        FOR &p_schema..DOC_LOCATIONS&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_LOV_RECS         FOR &p_schema..DOC_LOV_RECS&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_MEDIA            FOR &p_schema..DOC_MEDIA&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_REDIR_PRIOR      FOR &p_schema..DOC_REDIR_PRIOR&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_STD_ACTIONS      FOR &p_schema..DOC_STD_ACTIONS&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_STD_COSTS        FOR &p_schema..DOC_STD_COSTS&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_SYNONYMS         FOR &p_schema..DOC_SYNONYMS&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_TEMPLATE_COLUMNS FOR &p_schema..DOC_TEMPLATE_COLUMNS&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_TEMPLATE_GATEWAYS FOR &p_schema..DOC_TEMPLATE_GATEWAYS&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_TEMPLATE_USERS   FOR &p_schema..DOC_TEMPLATE_USERS&p_dblink');
  append(pi_sql => 'CREATE SYNONYM v2_DOC_TYPES            FOR &p_schema..DOC_TYPES&p_dblink');

  SELECT COUNT(*)
  into fin_tab_count
  FROM sys.dba_tables&p_dblink
  WHERE table_name LIKE 'FINANCIAL_YEARS'
  AND owner=UPPER('&p_schema');

  if fin_tab_count=0 then  --there is no old financial years table, use this one - it'll be empty
    append(pi_sql => 'CREATE SYNONYM v2_FINANCIAL_YEARS            FOR FINANCIAL_YEARS');
  else
    append(pi_sql => 'CREATE SYNONYM v2_FINANCIAL_YEARS            FOR &p_schema..FINANCIAL_YEARS&p_dblink');
  end if;


  SELECT COUNT(*)
  into fin_tab_count
  FROM sys.dba_tables&p_dblink
  WHERE table_name LIKE 'INTERVALS'
  AND owner=UPPER('&p_schema');

  if fin_tab_count=0 then  --there is no old financial years table, use this one - it'll be empty
    append(pi_sql => 'CREATE SYNONYM v2_INTERVALS            FOR INTERVALS');
  else
    append(pi_sql => 'CREATE SYNONYM v2_INTERVALS            FOR &p_schema..INTERVALS&p_dblink');
  end if;



  FOR i IN 1..g_tab_sql.COUNT LOOP
     BEGIN
       EXECUTE IMMEDIATE(g_tab_sql(i));
     EXCEPTION
       WHEN e_pub_syn_not_exist OR e_prv_syn_not_exist THEN
         NULL;
     END;
  END LOOP;

END;
/

prompt
prompt
set heading on
prompt List of Synonyms pointing at Source Highways Owner Objects
prompt ==========================================================
prompt
select substr(synonym_name,1,25) synonym_name
     , SUBSTR(table_owner||'.'||table_name,1,50) points_at
from user_synonyms
where synonym_name like 'V2%'
/

Prompt
Prompt Creating Additional Objects Required In Migration
Prompt =================================================
Prompt
--
DECLARE
  PROCEDURE drop_table_if_exists(p_table IN varchar2) IS
  BEGIN
    IF nm3ddl.does_object_exist(p_table, 'TABLE') THEN
       EXECUTE IMMEDIATE 'DROP TABLE '||p_table;
    END IF;
  END drop_table_if_exists;
BEGIN
  drop_table_if_exists('MIG_DTP_LOCAL');

--  EXECUTE IMMEDIATE 'CREATE TABLE MIG_DTP_LOCAL '||
--                    '(RSE_SYS_FLAG VARCHAR2(1) NOT NULL )';


  EXECUTE IMMEDIATE 'CREATE TABLE MIG_DTP_LOCAL '||
                    'AS SELECT rse_sys_flag, COUNT(*) rse_sys_flag_Count '||
                    'FROM v2_road_segs '||
                    'GROUP BY rse_sys_flag';

--
  drop_table_if_exists('NM2_NM3_INV_EXCEPTIONS');
--
  EXECUTE IMMEDIATE 'CREATE TABLE NM2_NM3_INV_EXCEPTIONS '||
                    '(iit_ne_id      NUMBER NOT NULL PRIMARY KEY '||
                    ',iit_start_date DATE   NOT NULL '||
                    ',iit_rse_he_id  NUMBER '||
                    ',iit_begin_mp   NUMBER '||
                    ',iit_end_mp     NUMBER '||
                    ',iit_inv_type   VARCHAR2(4) '||
                    ',iit_exception  VARCHAR2(4000) '||
                    ',timestamp      DATE DEFAULT SYSDATE NOT NULL)';
--
  drop_table_if_exists('NM2_NM3_INV_EXCEPTIONS_LOC');
--
  EXECUTE IMMEDIATE 'CREATE TABLE NM2_NM3_INV_EXCEPTIONS_LOC '||
                    '(iit_ne_id      NUMBER NOT NULL PRIMARY KEY '||
                    ',iit_start_date DATE   NOT NULL '||
                    ',iit_rse_he_id  NUMBER '||
                    ',iit_begin_mp   NUMBER '||
                    ',iit_end_mp     NUMBER '||
                    ',iit_inv_type   VARCHAR2(4) '||
                    ',iit_exception  VARCHAR2(4000) '||
                    ',timestamp      DATE DEFAULT SYSDATE NOT NULL)';

--
  drop_table_if_exists('NM2_NM3_INV_TYPE_CHANGES');
--
  EXECUTE IMMEDIATE ' CREATE TABLE nm2_nm3_inv_type_changes '||
                    '(itc_old_inv_code   VARCHAR2(4) '||
                    ',itc_sys_flag       VARCHAR2(1) '||
                    ',itc_new_inv_code   VARCHAR2(4))';
--
  drop_table_if_exists('MIGRATION_NET_MAP');
--
  EXECUTE IMMEDIATE ' CREATE TABLE migration_net_map '||
                    '(mig_ne_id NUMBER(38) '||
                    ',shape  mdsys.sdo_geometry)';
--

  drop_table_if_exists('MIGRATION_NET_MAP_MP');
--
  EXECUTE IMMEDIATE ' CREATE TABLE migration_net_map_mp '||
                    '(mig_ne_id NUMBER(38) '||
                    ',shape  mdsys.sdo_geometry)';

  EXECUTE IMMEDIATE ' CREATE index mnp_mig_ne_id on migration_net_map(mig_ne_id) ';

--
/*  drop_table_if_exists('MIGRATION_NET_MAP_REV');
--
  EXECUTE IMMEDIATE ' CREATE TABLE migration_net_map_rev '||
                    '(mig_ne_id NUMBER(38) '||
                    ',NNU_NODE_TYPE   VARCHAR2(1)'||
                    ',NNU_NO_NODE_ID  NUMBER(9)'||
                    ',NE_LENGTH       NUMBER'||
                    ',DISTANCE        NUMBER'||
                    ',shape  mdsys.sdo_geometry)';
*/
end;
/

--
-- create and old_new ne_id lookup table
--
-- Ian turnbull 7th july 2008
--
drop table mig_old_new_ne_id;

create table mig_old_new_ne_id
as
select rse_he_id
    ,ne_id_seq.nextval ne_id
from v2_road_segs;

create index old_new_ne_id_idx
on mig_old_new_ne_id(rse_he_id);


-- FOR MAINTENANCE NODES
INSERT INTO NM_NODE_TYPES
       (NNT_TYPE
       ,NNT_NAME
       ,NNT_DESCR
       ,NNT_NO_NAME_FORMAT
       )
SELECT
        'MAIN'
       ,'MAIN NODES'
       ,'Local And Classified Main Nodes'
       ,'000000000' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_NODE_TYPES
                   WHERE NNT_TYPE = 'MAIN');
COMMIT;

Prompt Complete.



Prompt

start nm2_nm3_migration.pkh

start nm2_nm3_migration.pkb

--this should already be there from the ATLAS install
--start v_hig_agency_code.vw




spool off

Prompt
Prompt Done
Prompt Please check log nm2_nm3_object_setup.log




