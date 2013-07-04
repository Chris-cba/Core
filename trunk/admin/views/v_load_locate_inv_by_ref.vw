create or replace force view v_load_locate_inv_by_ref
  (IIT_NE_ID, effective_date, route_id, START_REF_TYPE, START_REF_LABEL, START_REF_OFFSET, 
   END_REF_TYPE, END_REF_LABEL, END_REF_OFFSEt) As
SELECT
--   SCCS Identifiers :-
--
--       sccsid           : @(#)v_load_locate_inv_by_ref.vw	1.1 12/22/06
--       Module Name      : v_load_locate_inv_by_ref.vw
--       Date into SCCS   : 06/12/22 15:41:35
--       Date fetched Out : 07/06/13 17:08:29
--       SCCS Version     : 1.1
--
--
--   Author : Kevin Angus
--
--   v_load_locate_inv_by_ref
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
  iit.iit_ne_id,
  iit.iit_start_date effective_date,
  ne.ne_id,
  iit.iit_inv_type start_ref_type,
  iit.iit_descr    start_ref_label,
  1                start_ref_offset,
  iit.iit_inv_type end_ref_type,
  iit.iit_descr    end_ref_label,
  1                end_ref_offset
From
  nm_inv_items iit,
  nm_elements  ne
where
  1 = 2;
  
