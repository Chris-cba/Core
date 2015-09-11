CREATE OR REPLACE PACKAGE BODY  web_user_info
AS
-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/pck/web_user_info.pkb-arc   3.8   Sep 11 2015 11:25:58   Upendra.Hukeri  $
--       Module Name      : $Workfile:   web_user_info.pkb  $
--       Date into PVCS   : $Date:   Sep 11 2015 11:25:58  $
--       Date fetched Out : $Modtime:   Sep 11 2015 07:29:00  $
--       Version          : $Revision:   3.8  $
--       Based on SCCS version :
-----------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
  -----------
  --Constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
	g_Body_Sccsid CONSTANT  VARCHAR2(2000) :=  '$Revision:   3.8  $';
  -----------
  --Variables
  -----------
	l_err_desc	VARCHAR2(32767) := NULL;
	c_true      CONSTANT  VARCHAR2(5) := 'TRUE';
    c_false     CONSTANT  VARCHAR2(5) := 'FALSE';
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN VARCHAR2 
IS
BEGIN
   RETURN g_Sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN VARCHAR2
IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_user(p_name IN VARCHAR2)
AS
BEGIN    
   set_context(UPPER(p_name), l_err_desc);
END set_user;
--
-----------------------------------------------------------------------------
--
FUNCTION set_user_fn(p_name IN VARCHAR2) RETURN VARCHAR2
AS
BEGIN
	set_user(UPPER(p_name));
	--
	RETURN l_err_desc;
	--
EXCEPTION WHEN OTHERS THEN
	RETURN SQLERRM;
	--
END set_user_fn;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_user
AS
BEGIN
  --Reset back to Actual User, in case they are different.
   nm3security.set_user;
END clear_user;
--
-----------------------------------------------------------------------------
--
FUNCTION get_user RETURN VARCHAR2
AS
BEGIN
  RETURN SYS_CONTEXT('NM3_SECURITY_CTX','USERNAME');
END get_user;
--
-----------------------------------------------------------------------------
--
FUNCTION get_hig_owner RETURN hig_users.hus_username%TYPE
IS
	l_hig_owner   hig_users.hus_username%TYPE;
	--
BEGIN
	BEGIN
		SELECT  hu.hus_username
		INTO    l_hig_owner
		FROM    hig_users   hu
		WHERE   hu.hus_is_hig_owner_flag = 'Y';
		--
	EXCEPTION WHEN NO_DATA_FOUND THEN
		RETURN(NULL);
		--
	END;
	--
    RETURN(L_HIG_OWNER);
	--
END get_hig_owner;
--
----------------------------------------------------------------------------------------------------
--
PROCEDURE set_context(pi_user_name IN hig_users.hus_username%TYPE, pi_error_msg OUT VARCHAR2)
IS
	--
	l_user_id	hig_users.hus_user_id%TYPE;
	l_err_descr	nm_errors.ner_descr%TYPE;
	--
	CURSOR GET_USER_ID IS 
		SELECT  HUS_USER_ID
		FROM    HIG_USERS 
		WHERE   HUS_USERNAME = UPPER(PI_USER_NAME);
	--
BEGIN
	OPEN get_user_id;
	FETCH get_user_id 
	INTO l_user_id;
	--
	IF get_user_id%NOTFOUND THEN
		SELECT ner_descr 
		INTO l_err_descr 
		FROM nm_errors 
		WHERE ner_appl = 'HIG' 
			AND ner_id = 80;
		--
		pi_error_msg := 'HIG-0080: ' || l_err_descr;
	ELSE
		set_context(l_user_id);
	END IF;
	--
	CLOSE get_user_id;
	--
EXCEPTION WHEN OTHERS THEN
	IF get_user_id%ISOPEN THEN
		CLOSE get_user_id;
	END IF;
	--
    pi_error_msg := SQLERRM;     
	--
END set_context;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_context(pi_user_id IN hig_users.hus_user_id%TYPE)
IS
	--
	l_user_au      NUMBER;
	l_unrestricted VARCHAR2(5);
	l_end_date     DATE;
	l_name         hig_users.hus_name%TYPE;
	l_status       VARCHAR2(100); 
	l_db_user      VARCHAR2(100);
	l_is_owner     VARCHAR2(1);
	--
	CURSOR c_get_account_status (c_useraccount VARCHAR2) IS
		SELECT account_status
		FROM   dba_users 
		WHERE  username = c_useraccount;
	--
BEGIN
	IF g_account_unrestricted = 'N' OR g_account_unrestricted IS NULL THEN
		RAISE_APPLICATION_ERROR(-20001, 'A restricted or unknown user cannot use this function');
	END IF;
	--
	BEGIN
		SELECT  hus_admin_unit 
				,DECODE(hus_unrestricted, 'Y', c_true, c_false)
				,hus_end_date
				,hus_name
				,hus_username
				,hus_is_hig_owner_flag
		INTO    l_user_au
				,l_unrestricted
				,l_end_date
				,l_name
				,l_db_user
				,l_is_owner
		FROM    hig_users 
		WHERE   hus_user_id = pi_user_id;
		--
		-- 	IF L_UNRESTRICTED = 'Y' THEN
		--		RAISE_APPLICATION_ERROR (-20201, 'CANNOT SET CONTEXT FOR UNRESTRICTED USER ');     
		--	END IF ;
		--
		IF l_end_date IS NOT NULL THEN        
			RAISE_APPLICATION_ERROR(-20202, 'Exor HIG User (' || l_name || ') is end dated');
		END IF ;  
		--
		OPEN  c_get_account_status(l_db_user);
		FETCH c_get_account_status
		INTO  l_status;
		--
		CLOSE c_get_account_status;        
		--
		IF l_status NOT IN ('OPEN', 'EXPIRED(GRACE)') THEN
			RAISE_APPLICATION_ERROR(-20202, 'Exor DB User (' || l_db_user || ') Account Status - ' || l_status);
		END IF ;          
		--
	EXCEPTION WHEN NO_DATA_FOUND THEN
		RAISE_APPLICATION_ERROR (-20204, 'Given HIG User ID (' || pi_user_id || ') is not found');     
	END ;
    -- 
	nm3security.set_user (l_db_user);
	--
	nm3ctx.set_core_context (p_attribute => 'USER_ID' 				 ,p_value => pi_user_id);
  --nm3ctx.set_core_context (p_attribute => 'APPLICATION_OWNER' 	 ,p_value => get_hig_owner);
	nm3ctx.set_core_context (p_attribute => 'EFFECTIVE_DATE' 		 ,p_value => TO_CHAR(TRUNC(SYSDATE),'DD-MON-YYYY'));
	nm3ctx.set_core_context (p_attribute => 'USER_ADMIN_UNIT' 		 ,p_value => l_user_au);
	nm3ctx.set_core_context (p_attribute => 'UNRESTRICTED_INVENTORY' ,p_value => l_unrestricted );
	nm3ctx.set_core_context (p_attribute => 'HIG_OWNER' 			 ,p_value => l_is_owner);
	--
END set_context;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_contexts IS
BEGIN
	DBMS_SESSION.CLEAR_ALL_CONTEXT('NM3SQL');
	DBMS_SESSION.CLEAR_ALL_CONTEXT('NM3CORE');
	DBMS_SESSION.CLEAR_ALL_CONTEXT('NM3_SECURITY_CTX');
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_subuser AS
	sub_user hig_users.hus_username%TYPE;
	target_cookie owa_cookie.cookie;
	error_msg VARCHAR(32767);
BEGIN
	target_cookie := owa_cookie.get ('SUBUSERNAME');
	--
	IF target_cookie.num_vals != 0 THEN
		sub_user := target_cookie.vals (1);
		--
		set_context(sub_user, error_msg);
		--
		IF error_msg IS NOT NULL THEN
			htp.p('<script>alert("Error occured while setting context for user - ' || sub_user || '.\n' || error_msg || '.\n\n' || 'Results will be shown as HIGHWAYS OWNER.");</script>');
		END IF;
	END IF;
END set_subuser;
--
-----------------------------------------------------------------------------
--
BEGIN
  SELECT 	hus_user_id, hus_unrestricted, hus_is_hig_owner_flag
  INTO 		g_account_user_id, g_account_unrestricted, g_account_owner
  FROM 		hig_users
  WHERE 	hus_username = USER;
--
-----------------------------------------------------------------------------
--
END  web_user_info;
/         
