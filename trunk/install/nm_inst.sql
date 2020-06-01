-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_inst.sql-arc   2.5   Jun 01 2020 14:57:44   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_inst.sql  $
--       Date into PVCS   : $Date:   Jun 01 2020 14:57:44  $
--       Date fetched Out : $Modtime:   May 12 2020 09:51:54  $
--       Version          : $Revision:   2.5  $
-------------------------------------------------------------------------
--   Copyright (c) 2017 Bentley Systems Incorporated. All rights reserved.
-------------------------------------------------------------------------
--
WHENEVER SQLERROR EXIT

/*
====================================================================================================
=           Set Version Number                                                       =
====================================================================================================
*/
VARIABLE new_version VARCHAR2(10);

EXECUTE :new_version := '4.9.0.0'

/*
====================================================================================================
=           Start of Validation Checks                                                             =
====================================================================================================
*/
--
-- Validate USER - ensure not SYS or SYSTEM
--
BEGIN
   --
      IF USER IN ('SYS','SYSTEM')
       THEN
         RAISE_APPLICATION_ERROR(-20000,'You cannot install Exor Core as ' || USER);
      END IF;
END;
/
--
-- Validate DB VERSION
--
DECLARE
  --
  CURSOR c_db_version IS
  SELECT '19c'
    FROM  v$version
   WHERE  banner LIKE '%19.0.0.0%';
  --
  l_19c Varchar2(10);

  ex_incorrect_db Exception;

BEGIN
   Open  c_db_version;
   Fetch c_db_version Into l_19c;
   Close c_db_version;
   --
   If l_19c Is Null
   Then
     Raise ex_incorrect_db;
   End If;
   --
EXCEPTION
  WHEN ex_incorrect_db THEN
    RAISE_APPLICATION_ERROR(-20000,'The database version does not comply with the Release Configuration - contact Bentley support for further information');
 WHEN others THEN
    Null;
END;
/
--
-- Obtain Core version installed
--
VARIABLE core_version VARCHAR2(10);
--
DECLARE
  --
  table_does_not_exist EXCEPTION;
  PRAGMA EXCEPTION_INIT(table_does_not_exist, -942);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'SELECT hpr_version
    FROM hig_products
   WHERE hpr_product = ''HIG''' INTO :core_version;
  --
EXCEPTION
  WHEN table_does_not_exist
   THEN
      :core_version := NULL;
END;
/
--
-- Validate upgrade path
--
DECLARE
  --
  FUNCTION f_valid_upgrade(p_product IN VARCHAR2
                          ,p_version IN VARCHAR2)
						   
   RETURN BOOLEAN IS
  --
  BEGIN
   --
   RETURN (p_product = 'CORE' AND
           (:core_version like p_version||'.%' OR 
		    :core_version = p_version OR
			:core_version IS NULL)
		   );
  END;
  --
BEGIN
  -----------------------
  -- Valid CORE Versions
  -----------------------
  IF  f_valid_upgrade('CORE','4.7') OR
      f_valid_upgrade('CORE','4.8') 
  THEN
    NULL;
  ELSE
    raise_application_error(-20000,'Cannot upgrade from CORE version '||:core_version);
  END IF;

  --
END;
/

/*
====================================================================================================
=           End of Validation Checks                                                               =
====================================================================================================
*/
--
WHENEVER SQLERROR CONTINUE
--
UNDEFINE new_version
UNDEFINE core_version
UNDEFINE exor_base
UNDEFINE run_file
UNDEFINE terminator
COL new_version new_value new_version noprint
COL core_version new_value core_version noprint
COL exor_base new_value exor_base noprint
COL run_file new_value run_file noprint
COL terminator new_value terminator noprint
--
SET verify OFF head OFF term ON
--
SELECT :new_version new_version
      ,:core_version core_version
  FROM DUAL
  ;
--
CL SCR
PROMPT
PROMPT
PROMPT Please enter the value for exor_base. This is the directory under which
PROMPT the exor software resides (eg c:\exor\ on a client PC). If the value
PROMPT entered is not correct, the process will not proceed.
PROMPT There is no default value for this value.
PROMPT
PROMPT IMPORTANT: Please ensure that the exor_base value is terminated with
PROMPT the directory seperator for your operating system
PROMPT (eg \ in Windows or / in UNIX).
PROMPT
--
ACCEPT exor_base PROMPT "Enter exor_base directory now : "
--
SELECT SUBSTR('&exor_base',(LENGTH('&exor_base'))) terminator
  FROM dual
     ;
--
SELECT DECODE('&terminator','/',NULL
                           ,'\',NULL
                               ,'inv_term') run_file
  FROM dual
     ;
--
SET term OFF
START '&run_file'
SET term ON
--
--Ensure that exor_base is not greater than 30 characters in length
--
SELECT DECODE(SIGN(30-LENGTH('&exor_base')),1,NULL,'exor_base_too_long.sql') run_file
  FROM dual
     ;
SET term OFF
START '&run_file'
SET term ON
--
PROMPT
PROMPT About to install Exor Core using exor_base : &exor_base
PROMPT
ACCEPT ok_res PROMPT "OK to Continue with this setting ? (Y/N) "

--
---------------------------------------------------------------------------------------------------
--                  ****************   CORE  *******************
SET TERM ON
PROMPT
prompt Installing/Upgrading Core ...
PROMPT
SET TERM OFF
SET DEFINE ON
SELECT CASE NVL('&core_version', 'N')
         WHEN 'N' THEN '&exor_base'||'nm3'||'&terminator'||'install'||'&terminator'||'nm3_install.sql'
         ELSE '&exor_base'||'nm3'||'&terminator'||'install'||'&terminator'||'nm3_upg.sql'
       END run_file
  FROM dual
     ;

SET FEEDBACK ON
START '&run_file'
SET FEEDBACK OFF
--
PROMPT
PROMPT The install scripts could not be found in the directory
PROMPT specified for exor_base (&exor).
PROMPT
PROMPT Please re-run the installation script and enter the correct directory name.
PROMPT
ACCEPT leave_it PROMPT "Press RETURN to exit from SQL*PLUS"
