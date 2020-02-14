----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/midtier_user_definition.sql-arc   1.0   Feb 14 2020 15:22:54   Chris.Baugh  $
--       Module Name      : $Workfile:   midtier_user_definition.sql  $ 
--       Date into PVCS   : $Date:   Feb 14 2020 15:22:54  $
--       Date fetched Out : $Modtime:   Feb 14 2020 11:59:36  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
clear screen

undefine p_proxyuser
undefine p_proxypwd

ACCEPT p_proxyuser char prompt 'ENTER THE NAME OF THE MIDTIER USER : ';
ACCEPT p_proxypwd char prompt 'ENTER THE PASSWORD FOR THE MIDTIER USER : ';

prompt
prompt Creating MidTier User.............
prompt
--
--SET verify OFF;
--SET feedback OFF;
--SET serveroutput ON

  DECLARE
    --
    no_credentials   EXCEPTION;
    --
  BEGIN
    --
	IF NVL('&P_PROXYUSER','@@@') = '@@@' OR NVL('&P_PROXYPWD', '@@@') = '@@@'
	THEN
	  --
	  RAISE no_credentials;
	  --
	END IF;
	
	EXECUTE IMMEDIATE 'CREATE USER &P_PROXYUSER IDENTIFIED BY &P_PROXYPWD';
	EXECUTE IMMEDIATE 'GRANT PROXY_OWNER TO &P_PROXYUSER';
    --
  EXCEPTION 
    WHEN no_credentials 
      THEN
        RAISE_APPLICATION_ERROR(-20001,'MidTier Username and Password must be provided');
    WHEN OTHERS THEN
      RAISE;
  END;
/