--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/nm_mrg_sections.vw-arc   2.3   Apr 13 2018 11:47:20   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm_mrg_sections.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:20  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:36:08  $
--       Version          : $Revision:   2.3  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
DECLARE
   l_view VARCHAR2(32767);
--
   CURSOR cs_enterprise_edn IS
   SELECT 'x'
    FROM  v$version
   WHERE  banner LIKE '%Enterprise Edition%'
    OR    banner LIKE '%Personal%';
--
   l_dummy cs_enterprise_edn%ROWTYPE;
--
   l_enterprise_edn BOOLEAN;
--
   PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      IF p_nl
       THEN
         append (CHR(10),FALSE);
      END IF;
      l_view := l_view||p_text;
   END append;
--
BEGIN
   append ('CREATE OR REPLACE FORCE VIEW nm_mrg_sections AS',FALSE);
   append ('SELECT');
   append ('--');
   append ('--   SCCS Identifiers :-');
   append ('--');
   append ('--       sccsid           : @(#)nm_mrg_sections.vw	1.1 10/02/01');
   append ('--       Module Name      : nm_mrg_sections.vw');
   append ('--       Date into SCCS   : 01/10/02 16:30:45');
   append ('--       Date fetched Out : 07/06/13 17:08:17');
   append ('--       SCCS Version     : 1.1');
   append ('--');
   append ('-----------------------------------------------------------------------------');
   append ('--	Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.');
   append ('-----------------------------------------------------------------------------');
   append ('--');
   append ('        *');
   append (' FROM   nm_mrg_sections_all');
--
   OPEN  cs_enterprise_edn;
   FETCH cs_enterprise_edn INTO l_dummy;
   l_enterprise_edn := cs_enterprise_edn%FOUND;
   CLOSE cs_enterprise_edn;
--
   IF NOT l_enterprise_edn
    THEN
      --
      -- If we are running on Standard Edn then put the restrictions which are normally
      --  sorted by the Policies into the views
      --
--
      append ('WHERE EXISTS (SELECT 1');
      append ('               FROM  hig_users');
      append ('              WHERE  hus_username = Sys_Context(''NM3_SECURITY_CTX'',''USERNAME'')');
      append ('               AND   hus_unrestricted = '||CHR(39)||'Y'||CHR(39));
      append ('              UNION');
      append ('              SELECT 1');
      append ('               FROM  nm_mrg_query_results');
      append ('              WHERE  nms_mrg_job_id = nqr_mrg_job_id');
      append ('             )');
      append ('WITH CHECK OPTION');
   END IF;
--
   EXECUTE IMMEDIATE l_view;
--
END;
/

SELECT text
 FROM  user_errors
WHERE  name = 'NM_MRG_SECTIONS'
/

