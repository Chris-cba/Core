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
BEGIN
--
    FOR cs_rec IN (SELECT view_name
                    FROM  user_views
                   WHERE  view_name = 'NM_INV_ITEMS'
                  )
     LOOP
       EXECUTE IMMEDIATE 'DROP VIEW '||cs_rec.view_name;
    END LOOP;
--
   append ('CREATE OR replace force view nm_inv_items AS',FALSE);
   append ('SELECT');
   append ('--');
   append ('--   SCCS Identifiers :-');
   append ('--');
   append ('--       sccsid           : @(#)nm_inv_items.vw	1.6 03/24/05');
   append ('--       Module Name      : nm_inv_items.vw');
   append ('--       Date into SCCS   : 05/03/24 16:18:36');
   append ('--       Date fetched Out : 07/06/13 17:08:08');
   append ('--       SCCS Version     : 1.6');
   append ('--');
   append ('-----------------------------------------------------------------------------');
   append ('--	Copyright (c) exor corporation ltd, 2001');
   append ('-----------------------------------------------------------------------------');
   append ('--');
   append ('       *');
   append (' FROM  nm_inv_items_all');
   append ('WHERE  iit_start_date <= (select nm3context.get_effective_date from dual)');
   append (' AND   NVL(iit_end_date,TO_DATE('||CHR(39)||'99991231'||CHR(39)||','||CHR(39)||'YYYYMMDD'||CHR(39)||')) >  (select nm3context.get_effective_date from dual)');
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
      append (' AND   EXISTS (SELECT 1');
      append ('                FROM  hig_users');
      append ('               WHERE  hus_username     = USER');
      append ('                AND   hus_unrestricted = '||CHR(39)||'Y'||CHR(39));
      append ('               UNION');
      append ('               SELECT 1');
      append ('                FROM  dual');
      append ('               WHERE  exists (SELECT 1');
      append ('                               FROM  NM_USER_AUS');
      append ('                                    ,NM_ADMIN_GROUPS');
      append ('                                    ,HIG_USERS');
      append ('                              WHERE  HUS_USERNAME         = USER');
      append ('                                AND  NUA_USER_ID          = HUS_USER_ID');
      append ('                               AND   NUA_ADMIN_UNIT       = NAG_PARENT_ADMIN_UNIT');
      append ('                               AND   NAG_CHILD_ADMIN_UNIT = iit_admin_unit');
      append ('                             )');
      append ('                       AND');
      append ('                      exists (SELECT 1');
      append ('                               FROM  HIG_USER_ROLES');
      append ('                                    ,NM_INV_TYPE_ROLES');
      append ('                               WHERE ITR_INV_TYPE = iit_inv_type');
      append ('                                AND  ITR_HRO_ROLE = HUR_ROLE');
      append ('                                AND  HUR_USERNAME = USER');
      append ('                             )');
      append ('              )');
   END IF;
--
   EXECUTE IMMEDIATE l_view;
--
END;
/

