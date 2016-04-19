CREATE OR REPLACE FORCE VIEW view_huas
(
   huas_rowid,
   huas_hus_user_id,
   huas_ques_code,
   huas_answer,
   huas_security_queslist,
   huas_birthdate,
   huas_date_created,
   huas_created_by,
   huas_date_modified,
   huas_modified_by
)
AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/view_huas.vw-arc   1.0   Apr 19 2016 09:51:32   Vikas.Mhetre  $
--       Module Name      : $Workfile:   view_huas.vw  $
--       Date into PVCS   : $Date:   Apr 19 2016 09:51:32  $
--       Date fetched Out : $Modtime:   Apr 19 2016 09:42:14  $
--       Version          : $Revision:   1.0  $
-----------------------------------------------------------------------------
--    Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
SELECT huas.rowid huas_rowid,
       huas_hus_user_id,
       huas_ques_code,
       huas_answer,
       hco_meaning huas_security_queslist,
       huas_birthdate,
       huas_date_created,
       huas_created_by,
       huas_date_modified,
       huas_modified_by
FROM hig_user_access_security huas,
     (SELECT '<Select a Security Question from list>' hco_meaning,
             '0' hco_code
      FROM   DUAL
      UNION
      SELECT hc.hco_meaning, hc.hco_code
      FROM   hig_domains hd, hig_codes hc
      WHERE  hd.hdo_domain = hc.hco_domain(+)
      AND    hd.hdo_domain = 'SECURITY_QUESTIONS'
      AND    hc.hco_end_date IS NULL) ques
WHERE huas.huas_ques_code = ques.hco_code
/