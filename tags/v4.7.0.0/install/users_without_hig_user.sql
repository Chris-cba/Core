-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)users_without_hig_user.sql	1.3 04/06/06
--       Module Name      : users_without_hig_user.sql
--       Date into SCCS   : 06/04/06 12:10:21
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.3
--
--
--   Author : Jon Mills
--
-- This script will grant hig_user role to any user that
-- does not currently have that role
-- Run this script on NM3 upgrades - after schema has been re-compiled
-- i.e. there is a dependancy on procedure GRANT_ROLE_TO_USER
-- 
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------


PROMPT granting HIG_USER to above users (if any)
DECLARE
   l_tab_users   nm3type.tab_varchar30;
   l_tab_st_date nm3type.tab_date;
   c_hig_user CONSTANT VARCHAR2(8) := 'HIG_USER';
BEGIN
   SELECT hus_username
         ,hus_start_date
    BULK  COLLECT
    INTO  l_tab_users
         ,l_tab_st_date
    FROM  hig_users
   WHERE  hus_username IS NOT NULL
    AND   NOT EXISTS (SELECT 1
                       FROM  hig_user_roles
                      WHERE  hur_username = hus_username
                       AND   hur_role     = c_hig_user
                     );
   FOR i IN 1..l_tab_users.COUNT
    LOOP
      BEGIN
        grant_role_to_user (p_user         => l_tab_users(i)
                           ,p_role         => c_hig_user
                           ,p_start_date   => l_tab_st_date(i)
                          );
      EXCEPTION
        WHEN others THEN
          Null;
      END;                          
   END LOOP;
END;
/

