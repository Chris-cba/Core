--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/nm_mrg_query.vw-arc   2.2   Jul 04 2013 11:20:34   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_mrg_query.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:34  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:45:16  $
--       Version          : $Revision:   2.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
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
   append ('CREATE OR REPLACE FORCE VIEW nm_mrg_query AS',FALSE);
   append ('SELECT');
   append ('--');
   append ('--   SCCS Identifiers :-');
   append ('--');
   append ('--       sccsid           : @(#)nm_mrg_query.vw	1.1 10/02/01');
   append ('--       Module Name      : nm_mrg_query.vw');
   append ('--       Date into SCCS   : 01/10/02 16:29:48');
   append ('--       Date fetched Out : 07/06/13 17:08:14');
   append ('--       SCCS Version     : 1.1');
   append ('--');
   append ('-----------------------------------------------------------------------------');
   append ('--	Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.');
   append ('-----------------------------------------------------------------------------');
   append ('--');
   append ('        *');
   append (' FROM   nm_mrg_query_all');
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
      append ('              WHERE  hus_unrestricted = '||CHR(39)||'Y'||CHR(39));
      append ('              UNION');
      append ('              SELECT 1');
      append ('               FROM  nm_mrg_query_roles');
      append ('                    ,hig_user_roles');
      append ('              WHERE  nqro_nmq_id  = nmq_id');
      append ('               AND   nqro_role    = hur_role');
      append ('               AND   hur_username = Sys_Context(''NM3_SECURITY_CTX'',''USERNAME'')');
      append ('             )');
   END IF;
--
   EXECUTE IMMEDIATE l_view;
--
END;
/
