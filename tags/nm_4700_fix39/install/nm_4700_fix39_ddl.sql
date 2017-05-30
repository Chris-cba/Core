-----------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix39_ddl.sql-arc   1.0   May 30 2017 16:29:46   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4700_fix39_ddl.sql  $
--       Date into PVCS   : $Date:   May 30 2017 16:29:46  $
--       Date fetched Out : $Modtime:   May 04 2017 11:37:08  $
--       Version          : $Revision:   1.0  $
--
-----------------------------------------------------------------------------------
-- Copyright (c) 2017 Bentley Systems Incorporated.  All rights reserved.
-----------------------------------------------------------------------------------
--
DECLARE
    CURSOR sub_users IS
        SELECT  hus_username 
        FROM    hig_users
        WHERE   hus_username IS NOT NULL;
    --
BEGIN
    FOR username IN sub_users LOOP
		IF username.hus_username <> USER THEN
			BEGIN
				EXECUTE IMMEDIATE 
					'DROP SYNONYM ' || UPPER(username.hus_username) || '.ALL_SDO_STYLES';
			EXCEPTION WHEN OTHERS THEN
				NULL;
			END;
			--
			BEGIN
				EXECUTE IMMEDIATE
					'CREATE OR REPLACE FORCE VIEW ' || UPPER(username.hus_username) || '.ALL_SDO_STYLES ' ||
					' AS ' || '  SELECT * FROM ' || SYS_CONTEXT('NM3CORE', 'APPLICATION_OWNER') || '.ALL_SDO_STYLES';
			EXCEPTION WHEN OTHERS THEN
				NULL;
			END;
		END IF;
    END LOOP;
    --
END;
/