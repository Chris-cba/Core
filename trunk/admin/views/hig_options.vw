CREATE OR REPLACE FORCE VIEW hig_options AS
SELECT
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_options.vw-arc   2.1   Feb 04 2010 10:18:50   cstrettle  $
--       Module Name      : $Workfile:   hig_options.vw  $
--       Date into PVCS   : $Date:   Feb 04 2010 10:18:50  $
--       Date fetched Out : $Modtime:   Feb 04 2010 10:17:48  $
--       Version          : $Revision:   2.1  $
-------------------------------------------------------------------------
--
--   Author : Jonathan Mills
--
--   hig_options view
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2002
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
