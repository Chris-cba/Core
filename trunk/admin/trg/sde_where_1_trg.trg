CREATE OR REPLACE TRIGGER sde_where_1_trg
BEFORE INSERT OR UPDATE OR DELETE
ON sde_where
FOR EACH ROW
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/trg/sde_where_1_trg.trg-arc   1.2   Feb 23 2018 07:43:18   Upendra.Hukeri  $
--       Module Name      : $Workfile:   sde_where_1_trg.trg  $
--       Date into PVCS   : $Date:   Feb 23 2018 07:43:18  $
--       Date fetched Out : $Modtime:   Feb 19 2018 11:29:46  $
--       Version          : $Revision:   1.2  $
--
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
DECLARE
	CURSOR check_privilege IS
		SELECT 'Y' 
		  FROM user_role_privs 
		 WHERE granted_role = 'SDE_ADMIN'
		   AND username     = USER;
	--
	l_dummy_c VARCHAR2(1);
BEGIN
	OPEN  check_privilege;
	--
	FETCH check_privilege INTO l_dummy_c;
	--
	CLOSE check_privilege;
	--
	IF l_dummy_c IS NULL THEN
		RAISE_APPLICATION_ERROR(-20343, 'Only Shapefile Administrator can insert, update or delete record(s)');
	ELSE 
		IF INSERTING THEN
		    :new.sw_where_id  := sw_unique_seq_1.NEXTVAL;
		END IF;
		--
		IF INSERTING OR UPDATING THEN
		    :new.sw_unique    := UPPER(:new.sw_unique);
		END IF;
	END IF;
END sde_where_1_trg;
/