--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3typ_3211.sql-arc   2.1   Jul 04 2013 14:09:32   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3typ_3211.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:09:32  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:40:36  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
define sccsid = '@(#)nm3typ_3211.sql	1.5 02/15/06'
--
set echo off
set term off
--

prompt int_array header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'int_array.tyh' run_file
from dual
/
start '&&run_file'

prompt int_array_type header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'int_array_type.tyh' run_file
from dual
/
start '&&run_file'

prompt int_array body
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'int_array.tyw' run_file
from dual
/
start '&&run_file'

prompt nm_geom header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_geom.tyh' run_file
from dual
/
start '&&run_file'

prompt nm_geom_array header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_geom_array.tyh' run_file
from dual
/
start '&&run_file'

prompt nm_geom_array_type header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_geom_array_type.tyh' run_file
from dual
/
start '&&run_file'

prompt nm_geom_array body
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_geom_array.tyw' run_file
from dual
/
start '&&run_file'

prompt num_array header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'num_array.tyh' run_file
from dual
/
start '&&run_file'

prompt num_array_type header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'num_array_type.tyh' run_file
from dual
/
start '&&run_file'

prompt ptr header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr.tyh' run_file
from dual
/
start '&&run_file'

prompt ptr body
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr.tyw' run_file
from dual
/
start '&&run_file'

prompt ptr_array header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_array.tyh' run_file
from dual
/
start '&&run_file'

prompt ptr_array_type header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_array_type.tyh' run_file
from dual
/
start '&&run_file'

prompt ptr_array body
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_array.tyw' run_file
from dual
/
start '&&run_file'

prompt ptr_num header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_num.tyh' run_file
from dual
/
start '&&run_file'

prompt ptr_num body
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_num.tyw' run_file
from dual
/
start '&&run_file'

prompt ptr_num_array header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_num_array.tyh' run_file
from dual
/
start '&&run_file'

prompt ptr_num_array_type body
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_num_array_type.tyh' run_file
from dual
/
start '&&run_file'

prompt ptr_num_array body
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_num_array.tyw' run_file
from dual
/
start '&&run_file'

prompt ptr_vc header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_vc.tyh' run_file
from dual
/
start '&&run_file'

prompt ptr_vc body
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_vc.tyw' run_file
from dual
/
start '&&run_file'

prompt ptr_vc_array header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_vc_array.tyh' run_file
from dual
/
start '&&run_file'

prompt ptr_vc_array_type header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_vc_array_type.tyh' run_file
from dual
/
start '&&run_file'
--
prompt ptr_vc_array body
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_vc_array.tyw' run_file
from dual
/
start '&&run_file'
--
prompt nm_code_name_meaning_type header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_code_name_meaning_type.tyh' run_file
from dual
/
start '&&run_file'
--
prompt nm_code_name_meaning_tbl header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_code_name_meaning_tbl.tyh' run_file
from dual
/
start '&&run_file'
--

--
-- new types above here 
--
set term on

