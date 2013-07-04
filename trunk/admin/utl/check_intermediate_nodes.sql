--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/utl/check_intermediate_nodes.sql-arc   2.1   Jul 04 2013 10:29:56   James.Wadsworth  $
--       Module Name      : $Workfile:   check_intermediate_nodes.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 10:29:56  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:20:06  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

REM Copyright 2013 Bentley Systems Incorporated. All rights reserved.
REM @(#)check_intermediate_nodes.sql	1.1 11/14/03

set pages 9999
set echo off
set feedback off
set linesize 132 
set heading off

cl scr
--
prompt Highways By Exor
prompt ================
prompt
prompt INFO: Analysing Network......
prompt

set term off
spool check_intermediate_nodes.log


select 'Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MM:SS') from dual
/
SELECT 'Instance/User ' ||LOWER(username||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance
    ,user_users
/

set heading on

ttitle left '******************************************************************' skip -
       left '* Intermediate Nodes With Connectivty to Nodes on Other Sections *' skip -
       left '******************************************************************' skip 2

column c_i_node                   format a10         heading 'Node'
column c_i_section                format 99999999    heading 'Section'
column c_i_section_unique         format a20         heading 'Unique'
column c_i_section_descr          format a20         heading 'Section Descr'
--column c_i_node_connect_to_node   format a10      
column c_conn_to_section          format 99999999    heading 'Connected2' 
column c_conn_node_type           format a5          heading 'Type'
column c_conn_section_unique      format a20         heading 'Unique'
column c_conn_section_descr       format a20         heading 'Section Descr'


break on c_i_node skip 1 on report


compute count of c_i_node on report

SELECT   nu1.nou_pus_node_id  c_i_node
        ,nu1.nou_rse_he_id    c_i_section
        ,rse1.rse_unique      c_i_section_unique
	,SUBSTR(rse1.rse_descr,1,20)       c_i_section_descr
-- 	,nu2.nou_pus_node_id  c_i_node_connect_to_node
 	,nu2.nou_rse_he_id    c_conn_to_section
 	,nu2.NOU_NODE_TYPE    c_conn_node_type
	,rse2.rse_unique      c_conn_section_unique
	,SUBSTR(rse2.rse_descr,1,20)       c_conn_section_descr		
FROM     node_usages nu1
        ,road_segs   rse1
        ,node_usages nu2
        ,road_segs   rse2		
WHERE    nu1.NOU_NODE_TYPE = 'I'
AND      nu2.nou_pus_node_id  = nu1.nou_pus_node_id
AND      nu2.nou_rse_he_id   != nu1.nou_rse_he_id
AND      rse1.rse_he_id = nu1.nou_rse_he_id
AND      rse2.rse_he_id = nu2.nou_rse_he_id
ORDER BY nu1.nou_pus_node_id;

rem ---------------------------------------------------------------------------

spool off

set term on
set feedback on 
set pagesize 30 
set linesize 80

ttitle off
prompt Done
Prompt Please review check_intermediate_nodes.log
Prompt
prompt
edit check_intermediate_nodes.log

