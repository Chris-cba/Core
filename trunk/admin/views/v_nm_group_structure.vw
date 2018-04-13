CREATE OR REPLACE FORCE VIEW V_NM_GROUP_STRUCTURE
(
   PARENT_GROUP_TYPE,
   CHILD_GROUP_TYPE,
   CHILD_TYPE,
   PARENT_NT_TYPE,
   CHILD_NT_TYPE,
   LEVL
)
AS
   SELECT 
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_group_structure.vw-arc   1.1   Apr 13 2018 11:47:24   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   v_nm_group_structure.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:24  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:41:12  $
--       PVCS Version     : $Revision:   1.1  $
--
--   Author : R.A. Coupe
--
--   A view to provide the group-type structure.
--
--
--------------------------------------------------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
--------------------------------------------------------------------------------------------------------------------
--
--    
          ngr_parent_group_type parent_group_type,
          ngr_child_group_type child_group_type,
          'GROUP' child_type,
          p.ngt_nt_type parent_nt_type,
          c.ngt_nt_type child_nt_type,
          1 levl
     FROM nm_group_relations, nm_group_types p, nm_group_types c
    WHERE     ngr_parent_group_type = p.ngt_group_type
          AND ngr_child_group_type = c.ngt_group_type
   UNION ALL
   SELECT nng_group_type,
          NULL,
          'DATUM',
          ngt_nt_type,
          nng_nt_type,
          1
     FROM nm_nt_groupings, nm_group_types
    WHERE ngt_group_type = nng_group_type;
