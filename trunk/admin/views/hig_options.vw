CREATE OR REPLACE FORCE VIEW hig_options AS
SELECT
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/hig_options.vw-arc   2.3   Apr 13 2018 11:47:16   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   hig_options.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:16  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:31:38  $
--       Version          : $Revision:   2.3  $
-------------------------------------------------------------------------
--
--   Author : Jonathan Mills
--
--   hig_options view
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       hol_id         hop_id
      ,hol_product    hop_product
      ,hol_name       hop_name
      ,hov_value      hop_value
      ,hol_remarks    hop_remarks
      ,hol_domain     hop_domain
      ,hol_datatype   hop_datatype
      ,hol_mixed_case hop_mixed_case
      ,hol_max_length hop_max_length
 FROM  hig_option_list
      ,hig_option_values
WHERE  hol_id = hov_id (+)
/
