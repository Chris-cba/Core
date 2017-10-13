CREATE OR REPLACE TRIGGER sde_where_1_trg
BEFORE INSERT OR UPDATE OR DELETE
ON sde_where
FOR EACH ROW
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/trg/sde_where_1_trg.trg-arc   1.0   Oct 13 2017 09:02:40   Chris.Baugh  $
--       Module Name      : $Workfile:   sde_where_1_trg.trg  $
--       Date into PVCS   : $Date:   Oct 13 2017 09:02:40  $
--       Date fetched Out : $Modtime:   Oct 13 2017 09:00:20  $
--       Version          : $Revision:   1.0  $
--
--
-----------------------------------------------------------------------------
--    Copyright (c) 2017 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
DECLARE
	CURSOR check_privilege IS
		SELECT 'Y' 
		FROM user_role_privs 
		WHERE granted_role = 'SDE_ADMIN'
		AND   username     = USER;
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
		RAISE_APPLICATION_ERROR(-20343, 'Only SDE Administrator can insert records');
	ELSE 
		:new.sw_id := sw_unique_seq.NEXTVAL;
		:new.sw_unique := UPPER(:new.sw_unique);
	END IF;
END sde_where_1_trg;
/