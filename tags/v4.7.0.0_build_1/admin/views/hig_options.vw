CREATE OR REPLACE FORCE VIEW hig_options AS
SELECT
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_options.vw-arc   2.2   Jul 04 2013 11:20:04   James.Wadsworth  $
--       Module Name      : $Workfile:   hig_options.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:04  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:33:40  $
--       Version          : $Revision:   2.2  $
-------------------------------------------------------------------------
--
--   Author : Jonathan Mills
--
--   hig_options view
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
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
