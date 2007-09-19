CREATE OR REPLACE VIEW V_NM_SQL_CONTEXT
--   PVCS Identifiers :-
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_sql_context.vw-arc   2.0   Sep 19 2007 09:42:26   smarshall  $
--       Module Name      : $Workfile:   v_nm_sql_context.vw  $
--       Date into PVCS   : $Date:   Sep 19 2007 09:42:26  $
--       Date fetched Out : $Modtime:   Sep 19 2007 08:50:22  $
(ATTRIBUTE, VALUE)
AS 
select c.attribute, c.value
--       PVCS Version     : $Revision:   2.0  $
from session_context c
where c.namespace = 'NM_SQL'
order by c.attribute;
