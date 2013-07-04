create or replace force view v_nm_element_history
(OLD_NE_ID
,NEW_NE_ID
,OLD_NE_UNIQUE
,OLD_NE_DESCR
,NEW_NE_UNIQUE
,NEW_NE_DESCR
,NEH_OPERATION
,NEH_EFFECTIVE_DATE
,NEH_ACTIONED_DATE
,NEH_ACTIONED_BY )
as select
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_element_history.sql-arc   2.2   Jul 04 2013 11:35:14   James.Wadsworth  $
--       Module Name      : $Workfile:   v_nm_element_history.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:35:14  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:30:42  $
--       Version          : $Revision:   2.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
 NEH_NE_ID_OLD
,NEH_NE_ID_NEW
,O.NE_UNIQUE
,O.NE_DESCR
,N.NE_UNIQUE
,N.NE_DESCR
,NEH_OPERATION
,NEH_EFFECTIVE_DATE
,NEH_ACTIONED_DATE
,NEH_ACTIONED_BY
from  nm_elements_all o
    , nm_elements_all n
    , nm_element_history a
where n.ne_id = neh_ne_id_new
and   o.ne_id = neh_ne_id_old
and   not exists (select 1
			from   nm_element_history b
				,nm_element_history c
			where  b.neh_ne_id_old = a.neh_ne_id_old
			and    b.neh_ne_id_new = c.neh_ne_id_old
			and    a.neh_operation != 'C')
/
