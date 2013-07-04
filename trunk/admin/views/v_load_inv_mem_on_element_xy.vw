CREATE OR REPLACE VIEW V_LOAD_INV_MEM_ON_ELEMENT_XY
(NE_UNIQUE, NE_NT_TYPE, BEGIN_X, BEGIN_Y, END_X, END_Y, IIT_NE_ID, 
 IIT_INV_TYPE, NM_START_DATE)
AS
SELECT
-----------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/views/v_load_inv_mem_on_element_xy.vw-arc   2.1   Jul 04 2013 11:35:12   James.Wadsworth  $
--       Module Name      : $Workfile:   v_load_inv_mem_on_element_xy.vw  $
--       Date into SCCS   : $Date:   Jul 04 2013 11:35:12  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:30:06  $
--       SCCS Version     : $Revision:   2.1  $
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
       ne_unique       ne_unique
      ,ne_nt_type      ne_nt_type
      ,TO_NUMBER(NULL) begin_x
      ,TO_NUMBER(NULL) begin_y
      ,TO_NUMBER(NULL) end_x
      ,TO_NUMBER(NULL) end_y     
      ,TO_NUMBER(NULL) iit_ne_id
      ,ne_nt_type      iit_inv_type
      ,TO_DATE(NULL)   nm_start_date
 FROM  nm_elements_all
WHERE  1=2;
