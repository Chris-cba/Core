--    '@(#)title.sql	1.1 04/18/01' - SCCS INFO
--    The two minus signs are needed to make the line a COMMENT line
--    The word REM does NOT work.

SELECT hus_username,
       hau_name
FROM   hig_admin_units,
       hig_users
WHERE
       hus_admin_unit = hau_admin_unit
       and hus_username = Sys_Context('NM3_SECURITY_CTX','USERNAME')
