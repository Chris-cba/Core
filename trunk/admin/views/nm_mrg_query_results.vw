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
   append ('CREATE OR REPLACE FORCE VIEW nm_mrg_query_results AS',FALSE);
   append ('SELECT');
   append ('--');
   append ('--   SCCS Identifiers :-');
   append ('--');
   append ('--       sccsid           : @(#)nm_mrg_query_results.vw	1.1 10/02/01');
   append ('--       Module Name      : nm_mrg_query_results.vw');
   append ('--       Date into SCCS   : 01/10/02 16:30:34');
   append ('--       Date fetched Out : 07/06/13 17:08:15');
   append ('--       SCCS Version     : 1.1');
   append ('--');
   append ('-----------------------------------------------------------------------------');
   append ('--	Copyright (c) exor corporation ltd, 2001');
   append ('-----------------------------------------------------------------------------');
   append ('--');
   append ('        *');
   append (' FROM   nm_mrg_query_results_all');
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
      append ('WHERE EXISTS (SELECT 1 FROM nm_mrg_query_executable WHERE nmq_id = nqr_nmq_id)');
      append (' AND EXISTS (SELECT 1');
      append ('              FROM  hig_users');
      append ('             WHERE  hus_username     = Sys_Context(''NM3_SECURITY_CTX'',''USERNAME'')');
      append ('              AND   hus_unrestricted = '||CHR(39)||'Y'||CHR(39));
      append ('             UNION');
      append ('             SELECT 1');
      append ('              FROM  nm_user_aus');
      append ('                   ,nm_admin_groups');
      append ('                   ,hig_users');
      append ('             WHERE  hus_username         = Sys_Context(''NM3_SECURITY_CTX'',''USERNAME'')');
      append ('              AND   nua_user_id          = hus_user_id');
      append ('              AND   nua_admin_unit       = nag_parent_admin_unit');
      append ('              AND   nag_child_admin_unit = nqr_admin_unit');
      append ('            )');
   END IF;
--
   EXECUTE IMMEDIATE l_view;
--
END;
/

SELECT text
 FROM  user_errors
WHERE  name = 'NM_MRG_QUERY_RESULTS'
/

