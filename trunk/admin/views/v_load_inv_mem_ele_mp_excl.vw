CREATE OR REPLACE FORCE VIEW v_load_inv_mem_ele_mp_excl AS
SELECT
--   SCCS Identifiers :-
--
--       sccsid           : @(#)v_load_inv_mem_ele_mp_excl.vw	1.2 12/03/03
--       Module Name      : v_load_inv_mem_ele_mp_excl.vw
--       Date into SCCS   : 03/12/03 10:03:06
--       Date fetched Out : 07/06/13 17:08:27
--       SCCS Version     : 1.2
--
--
--   Author : Jonathan Mills
--
--   Dummy view for loading nm_members records through CSV loader interface
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
       ne_unique       ne_unique
      ,ne_nt_type      ne_nt_type
      ,TO_NUMBER(Null) begin_mp
      ,TO_NUMBER(null) end_mp
      ,ne_sub_class    exclusive_subclass
      ,TO_NUMBER(Null) iit_ne_id
      ,ne_nt_type      iit_inv_type
      ,TO_DATE(null)   nm_start_date
 FROM  nm_elements_all
WHERE  1=2
/
