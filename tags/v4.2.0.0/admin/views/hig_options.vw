CREATE OR REPLACE FORCE VIEW hig_options AS
SELECT
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_options.vw	1.2 12/03/03
--       Module Name      : hig_options.vw
--       Date into SCCS   : 03/12/03 10:01:31
--       Date fetched Out : 07/06/13 17:08:02
--       SCCS Version     : 1.2
--
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
 FROM  hig_option_list
      ,hig_option_values
WHERE  hol_id = hov_id (+)
/
