--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/lb/install/lb_install.sql-arc   1.15   Aug 11 2017 15:42:32   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_install.sql  $
--       Date into PVCS   : $Date:   Aug 11 2017 15:42:32  $
--       Date fetched Out : $Modtime:   Aug 11 2017 15:30:28  $
--       PVCS Version     : $Revision:   1.15  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2017 Bentley Systems Incorporated. All rights reserved.
--------------------------------------------------------------------------------
--
set echo off
set linesize 120
set heading off
set feedback off

--
-- Grab date/time to append to log file names this is standard to all upgrade/install scripts
--
undefine log_extension
col      log_extension new_value log_extension noprint
set term off
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
set term on
--
---------------------------------------------------------------------------------------------------
--
--
-- Spool to Logfile
--
define logfile1='lb_install_1_&log_extension'
--define logfile2='lb_install_2_&log_extension'
spool &logfile1
--
---------------------------------------------------------------------------------------------------
--
select 'Installation Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MM:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;

WHENEVER SQLERROR EXIT
--
-- Check that LB has not already been installed
--
DECLARE
  l_version            VARCHAR2(10);
  ex_already_installed EXCEPTION;
  exor_core_not_configured EXCEPTION;
  
  TYPE                 refcur IS REF CURSOR;
  rc                   refcur;
  cnt                  integer;
  v_sql                VARCHAR2(1000);
  l_count              integer;

BEGIN
   --
--
-- Check NM3 installed at appropriate version 
--
   hig2.product_exists_at_version (p_product    => 'NET'
                                  ,p_version    => '4.7.0.0'
                                  );
--
--Now check if LB is already installed
--
   v_sql := 'SELECT hpr_version FROM hig_products WHERE hpr_product = ''LB''';
   --
   OPEN rc FOR v_sql;
   FETCH rc INTO l_version;
   CLOSE rc;

   IF l_version IS NOT NULL THEN
       RAISE ex_already_installed;
   END IF;
   
   l_version := '4.1';
   
   SELECT COUNT(1) INTO cnt FROM user_objects WHERE object_name = 'LB_GET';
   IF cnt <> 0 THEN
      RAISE ex_already_installed;
   END IF;
   
   select count(1) into l_count  
   from nm_nw_themes, 
        nm_themes_all, 
		nm_linear_types
   WHERE     nth_theme_id = nnth_nth_theme_id
   AND nlt_id = nnth_nlt_id
   AND nth_base_table_theme IS NULL;
   
   IF l_count <> 0 THEN
      RAISE exor_core_not_configured.
   END IF;
 
EXCEPTION
  WHEN ex_already_installed THEN
    RAISE_APPLICATION_ERROR(-20001,'LB version '||l_version||' already installed.');
  WHEN exor_core_not_configured THEN 
    RAISE_APPLICATION_ERROR( -20002, 'LB install has a pre-requisite on network and linear types and theme, please configure this in Exor core';
 WHEN others THEN
    Null;
END;
/
WHENEVER SQLERROR CONTINUE
--
---------------------------------------------------------------------------------------------------
--                        ****************   TABLES  *******************
SET TERM ON
prompt Tables...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'lb'||'&terminator'||'install'||
        '&terminator'||'lb.tab' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   INDEXES  *******************
SET TERM ON
prompt Indexes...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'lb'||'&terminator'||'install'||
        '&terminator'||'lb.ind' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   CONSTRAINTS  *******************
SET TERM ON
prompt Constraints...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'lb'||'&terminator'||'install'||
        '&terminator'||'lb.con' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   SEQUENCES  *******************
SET TERM ON
prompt Sequences...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'lb'||'&terminator'||'install'||
        '&terminator'||'lb.sqs' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

--
---------------------------------------------------------------------------------------------------
--                        ****************   TYPES  *******************
SET TERM ON
prompt Types...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'lb'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lbtyp.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

--
---------------------------------------------------------------------------------------------------
--                        ****************   PACKAGE HEADERS  *******************
SET TERM ON
prompt Package Headers...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'lb'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'lbpkh.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                            ****************   VIEWS  *******************
SET TERM ON
prompt Views...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'lb'||'&terminator'||'admin'||'&terminator'||'views'||
        '&terminator'||'lbviews.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                         ****************   PACKAGE BODIES  *******************
SET TERM ON
prompt Package Bodies...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'lb'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'lbpkb.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                         ****************   TRIGGERS  *******************
SET TERM ON
prompt Triggers...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'lb'||'&terminator'||'admin'||
        '&terminator'||'trg'||'&terminator'||'lbtrg.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

--
---------------------------------------------------------------------------------------------------
--                        ****************   eB Interface modules  *******************
SET TERM ON
prompt eB interface...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'lb'||'&terminator'||'admin'||'&terminator'||'eB_Interface'||
        '&terminator'||'install_eB_interface' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

SET TERM ON
PROMPT Meta-Data
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'lb'||'&terminator'||'install'||
        '&terminator'||'lbdata.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

--
---------------------------------------------------------------------------------------------------
--                        ****************   COMPILE SCHEMA   *******************
SET TERM ON
Prompt Compiling LB objects...
SET TERM OFF
--SPOOL OFF

--SET DEFINE ON
--SELECT '&exor_base'||'lb'||'&terminator'||'admin'||
--'&terminator'||'utl'||'&terminator'||'compile_lb_objects.sql' run_file
--FROM dual
--/
--START '&run_file'

SET DEFINE ON
Prompt Dependency Order View.
SELECT '&exor_base'||'lb'||'&terminator'||'admin'||
'&terminator'||'utl'||'&terminator'||'lb_dependendency_order.vw' run_file
FROM dual
/
START '&run_file'

SET DEFINE ON
Prompt Compilation...
SELECT '&exor_base'||'lb'||'&terminator'||'admin'||
'&terminator'||'utl'||'&terminator'||'compile_lb_objects2.sql' run_file
FROM dual
/
SET SERVEROUTPUT ON;

START '&run_file'

Prompt Creating synonyms

declare
  cursor c1 is
    select * from lb_objects l
    where object_type in ('PACKAGE', 'TABLE', 'VIEW', 'PROCEDURE', 'SEQUENCE' );
begin
  if nvl(hig.get_sysopt('HIGPUBSYN'),'Y') = 'Y' 
  then
     for irec in c1 loop
       NM3DDL.CREATE_SYNONYM_FOR_OBJECT(irec.object_name, 'PUBLIC');
     end loop;
  else
    NM3DDL.REFRESH_PRIVATE_SYNONYMS;
  end if;
end;    
/

--spool &logfile2

--get some db info
select 'Install Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MM:SS') from dual;
SELECT 'Install Running on ' ||LOWER(username||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance
    ,user_users;

--START compile_lb.sql
--
--SET FEEDBACK ON
--start &&run_file
--SET FEEDBACK OFF

--
---------------------------------------------------------------------------------------------------
--                        ***********  Product and Version Number  *******************
insert into hig_products ( hpr_product, hpr_product_name, hpr_version, hpr_key, hpr_sequence )
values ('LB', 'Location Bridge', '4.7.0.3', '76', 99);  


SET TERM ON
Prompt Setting The Version Number...
SET TERM OFF
BEGIN
      hig2.upgrade('LB','lb_install.sql','Installed','4.7.0.3');
END;
/
COMMIT;

SET TERM ON
SELECT 'Product installed at version '||hpr_product||' ' ||hpr_version details
FROM hig_products
WHERE hpr_product IN ('LB')
order by hpr_product;
--
--
spool off

exit;

