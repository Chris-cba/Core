CREATE OR REPLACE TRIGGER sde_where_1_trg
BEFORE INSERT OR UPDATE OR DELETE
ON sde_where
FOR EACH ROW
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/trg/sde_where_1_trg.trg-arc   1.1   Oct 30 2017 09:46:48   Upendra.Hukeri  $
--       Module Name      : $Workfile:   sde_where_1_trg.trg  $
--       Date into PVCS   : $Date:   Oct 30 2017 09:46:48  $
--       Date fetched Out : $Modtime:   Oct 30 2017 09:45:56  $
--       Version          : $Revision:   1.1  $
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
		RAISE_APPLICATION_ERROR(-20343, 'Only SDE Administrator can insert, update or delete record(s)');
	ELSE 
		:new.sw_id := sw_unique_seq.NEXTVAL;
		:new.sw_unique := UPPER(:new.sw_unique);
	END IF;
END sde_where_1_trg;
/