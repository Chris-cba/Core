REM **************************************************************************
REM	Copyright (c) 1996 EXOR Corporation.
REM
REM	This script sets the hig_user roles given the roles created in higroles
REM	may be used when creating new Oracle Highways users.
REM **************************************************************************

REM SCCS ID Keyword, do no remove
define sccsid = '@(#)hig_user_roles.sql	1.3 02/04/05';

-- Grant all the privs for each role
BEGIN
   FOR cs_rec IN (SELECT hus_username,hro_role,hus_start_date
                   FROM  hig_users
                        ,hig_roles
                  WHERE  hus_username = USER
                  UNION ALL
                  SELECT hus_username,'JAVA_ADMIN',hus_start_date
                   FROM  hig_users
                  WHERE  hus_username = USER
                 )
    LOOP
      grant_role_to_user (p_user       => cs_rec.hus_username
                         ,p_role       => cs_rec.hro_role
                         ,p_admin      => TRUE
                         ,p_start_date => cs_rec.hus_start_date
                         );
   END LOOP;
END;
/
--
COMMIT;
REM End of command file
REM
