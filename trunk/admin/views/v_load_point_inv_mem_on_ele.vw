CREATE OR REPLACE FORCE VIEW v_load_point_inv_mem_on_ele AS
SELECT
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)v_load_point_inv_mem_on_ele.vw	1.1 11/11/04
--       Module Name      : v_load_point_inv_mem_on_ele.vw
--       Date into SCCS   : 04/11/11 23:09:14
--       Date fetched Out : 07/06/13 17:08:30
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   Fake view for loading point asset locations
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       ne_unique
      ,ne_nt_type
      ,ne_length mp
      ,ne_nt_type               true_or_slk
      ,ne_id                    iit_ne_id
      ,ne_gty_group_type        iit_inv_type
      ,ne_start_date            nm_start_date
      ,ne_sub_class             ambiguous_sub_class
      ,SUBSTR(ne_sub_class,1,1) ambig_choose_start_or_end
      ,SUBSTR(ne_sub_class,1,1) guess_if_still_ambiguous
 FROM  nm_elements_all
WHERE  ROWNUM = 0
/
