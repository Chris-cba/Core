--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_obj_on_route.vw-arc   1.4   Nov 28 2017 12:06:54   Chris.Baugh  $
--       Module Name      : $Workfile:   v_obj_on_route.vw  $
--       Date into PVCS   : $Date:   Nov 28 2017 12:06:54  $
--       Date fetched Out : $Modtime:   Nov 24 2017 10:24:32  $
--       Version          : $Revision:   1.4  $
-------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

DECLARE
  view_does_not_exist  EXCEPTION;
  pragma exception_init(view_does_not_exist,-12003);

BEGIN
  EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW V_OBJ_ON_ROUTE';
EXCEPTION
  WHEN view_does_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/

CREATE MATERIALIZED VIEW V_OBJ_ON_ROUTE (REFNT,REFNT_TYPE,OBJ_TYPE,OBJ_ID,SEG_ID,SEQ_ID,DIR_FLAG,NM_BEGIN_MP,NM_END_MP,M_UNIT)
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
SELECT t.*
  FROM TABLE (
          SELECT GET_LB_RPT_R_TAB (CAST (COLLECT (lb_rpt (nm_ne_id_of,
                                                          2,
                                                          nm_obj_type,
                                                          nm_ne_id_in,
                                                          NULL,
                                                          NULL,
                                                          NULL,
                                                          nm_begin_mp,
                                                          nm_end_mp,
                                                          1)) AS lb_rpt_tab),
                                   SYS_CONTEXT ('NM3SQL', 'MV_ROUTE_TYPE'),
                                   1000)
            FROM nm_members
           WHERE nm_type = 'I' and nm_obj_type NOT IN ('ALNE', 'ALTI', 'ALXE', 'TSUP', 'NEVT', 'NIG', 'NIGL' )
           and nm_obj_type IN (select distinct nm_obj_type
                                                     from nm_members 
                                                    where substr(nm_obj_type, 1,1) between 'A' and 'J')) t
UNION ALL
SELECT t.*
  FROM TABLE (
          SELECT GET_LB_RPT_R_TAB (CAST (COLLECT (lb_rpt (nm_ne_id_of,
                                                          2,
                                                          nm_obj_type,
                                                          nm_ne_id_in,
                                                          NULL,
                                                          NULL,
                                                          NULL,
                                                          nm_begin_mp,
                                                          nm_end_mp,
                                                          1)) AS lb_rpt_tab),
                                   SYS_CONTEXT ('NM3SQL', 'MV_ROUTE_TYPE'),
                                   1000)
            FROM nm_members
           WHERE nm_type = 'I' and nm_obj_type NOT IN ('ALNE', 'ALTI', 'ALXE', 'TSUP', 'NEVT', 'NIG', 'NIGL' )
           and nm_obj_type IN (select distinct nm_obj_type
                                                     from nm_members 
                                                    where substr(nm_obj_type, 1,1) between 'K' and 'Z')) t;


COMMENT ON MATERIALIZED VIEW V_OBJ_ON_ROUTE IS 'Snapshot table for all assets on a section'
/


CREATE INDEX MV_OOR_RT_IDX ON V_OBJ_ON_ROUTE
(REFNT)
/

CREATE INDEX MV_OOR_INV_IDX ON V_OBJ_ON_ROUTE
(OBJ_ID, OBJ_TYPE)
/

BEGIN
  NM3DDL.CREATE_SYNONYM_FOR_OBJECT('V_OBJ_ON_ROUTE');
END;
/