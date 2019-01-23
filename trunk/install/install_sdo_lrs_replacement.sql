--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/install_sdo_lrs_replacement.sql-arc   1.0   Jan 23 2019 12:12:30   Chris.Baugh  $
--       Module Name      : $Workfile:   install_sdo_lrs_replacement.sql  $
--       Date into PVCS   : $Date:   Jan 23 2019 12:12:30  $
--       Date fetched Out : $Modtime:   Jan 22 2019 10:54:12  $
--       Version          : $Revision:   1.0  $
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
set echo off
set term off
set verify off
--
---------------------------------------------------------------------
-- Drop existing types in appropriate order
set term on
prompt Dropping Existing Types
set term off

DECLARE
  --
  PROCEDURE drop_type(pi_type  VARCHAR2)
  IS
  --
    type_not_exists  EXCEPTION;
    pragma exception_init(type_not_exists,-04043);
  --
  BEGIN
    --
    EXECUTE IMMEDIATE 'DROP TYPE '||pi_type||' FORCE';
	--
  EXCEPTION
    WHEN type_not_exists THEN
      NULL;
    WHEN OTHERS THEN
	  raise_application_error(-20001,'Could not drop TYPE '||pi_type);
  END drop_type;
  
BEGIN
  --
  drop_type('nm_vertex_tab');
  drop_type('geom_id_tab');
  drop_type('nm_vertex');
  drop_type('geom_id');
  drop_type('nm_geom_terminations');
  --
END;
/

--
--------------------------------------------------------------------------------------------
--
set term on
prompt Creating Types
set term off
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_vertex header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_vertex.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_vertex_tab header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_vertex_tab.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt geom_id header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'geom_id.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt geom_id_tab header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'geom_id_tab.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_geom_terminations header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_geom_terminations.tyh' run_file
from dual
/
start '&&run_file'

-- 
-----------------------------------PACKAGE HEADERS------------------------------------- 
-- 
SET TERM ON
PROMPT nm_sdo_geom.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm_sdo_geom.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm_sdo.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm_sdo.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT sdo_lrs.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'sdo_lrs.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
-----------------------------------PACKAGE BODIES ------------------------------------- 
-- 
SET TERM ON
PROMPT nm_sdo_geom.pkw
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm_sdo_geom.pkw' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm_sdo.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm_sdo.pkw' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT sdo_lrs.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'sdo_lrs.pkw' run_file 
FROM dual
/
start '&run_file'

SET term on


