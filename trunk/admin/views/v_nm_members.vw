CREATE OR REPLACE FORCE VIEW v_nm_members (nm_ne_id_in,
                                     nm_ne_id_of,
                                     nm_unique_of,
                                     nm_type,
                                     nm_obj_type,
                                     nm_begin_mp,
                                     nm_start_date,
                                     nm_end_date,
                                     nm_end_mp,
                                     nm_slk,
                                     nm_cardinality,
                                     nm_admin_unit,
                                     nm_date_created,
                                     nm_date_modified,
                                     nm_modified_by,
                                     nm_created_by,
                                     nm_seq_no,
                                     nm_seg_no,
                                     nm_true,
                                     nm_end_slk,
                                     nm_end_true
                                    )
AS
   SELECT
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)v_nm_members.vw	1.4 06/17/05
--       Module Name      : v_nm_members.vw
--       Date into SCCS   : 05/06/17 14:42:05
--       Date fetched Out : 07/06/13 17:08:35
--       SCCS Version     : 1.4
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
          "NM_NE_ID_IN", "NM_NE_ID_OF", "NE_UNIQUE", "NM_TYPE", "NM_OBJ_TYPE",
          "NM_BEGIN_MP", "NM_START_DATE", "NM_END_DATE", "NM_END_MP",
          "NM_SLK", "NM_CARDINALITY", "NM_ADMIN_UNIT", "NM_DATE_CREATED",
          "NM_DATE_MODIFIED", "NM_MODIFIED_BY", "NM_CREATED_BY", "NM_SEQ_NO",
          "NM_SEG_NO", "NM_TRUE", "NM_END_SLK", "NM_END_TRUE"
     FROM nm_members_all, nm_elements_all
    WHERE ne_id = nm_ne_id_of
      AND nm_start_date                                       <=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
      AND NVL (nm_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >   To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
/      


