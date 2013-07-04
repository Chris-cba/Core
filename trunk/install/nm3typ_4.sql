--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3typ_4.sql-arc   2.1   Jul 04 2013 14:09:34   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3typ_4.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:09:34  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:40:26  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
define sccsid = '@(#)nm3typ_4.sql	1.1 02/01/06'
--
set echo off
set term off
--

prompt int_array header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'int_array.tph' run_file
from dual
/
start '&&run_file'

prompt int_array_type header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'int_array_type.tph' run_file
from dual
/
start '&&run_file'

prompt int_array body
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'int_array.tpw' run_file
from dual
/
start '&&run_file'

prompt nm_geom header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_geom.tph' run_file
from dual
/
start '&&run_file'

prompt nm_geom_array header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_geom_array.tph' run_file
from dual
/
start '&&run_file'

prompt nm_geom_array_type header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_geom_array_type.tph' run_file
from dual
/
start '&&run_file'

prompt nm_geom_array body
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_geom_array.tpw' run_file
from dual
/
start '&&run_file'

prompt num_array header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'num_array.tph' run_file
from dual
/
start '&&run_file'

prompt num_array_type header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'num_array_type.tph' run_file
from dual
/
start '&&run_file'

prompt ptr header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr.tph' run_file
from dual
/
start '&&run_file'

prompt ptr body
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr.tpw' run_file
from dual
/
start '&&run_file'

prompt ptr_array header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_array.tph' run_file
from dual
/
start '&&run_file'

prompt ptr_array_type header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_array_type.tph' run_file
from dual
/
start '&&run_file'

prompt ptr_array body
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_array.tpw' run_file
from dual
/
start '&&run_file'

prompt ptr_num header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_num.tph' run_file
from dual
/
start '&&run_file'

prompt ptr_num body
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_num.tpw' run_file
from dual
/
start '&&run_file'

prompt ptr_num_array header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_num_array.tph' run_file
from dual
/
start '&&run_file'

prompt ptr_num_array_type body
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_num_array_type.tph' run_file
from dual
/
start '&&run_file'

prompt ptr_num_array body
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_num_array.tpw' run_file
from dual
/
start '&&run_file'

prompt ptr_vc header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_vc.tph' run_file
from dual
/
start '&&run_file'

prompt ptr_vc body
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_vc.tpw' run_file
from dual
/
start '&&run_file'

prompt ptr_vc_array header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_vc_array.tph' run_file
from dual
/
start '&&run_file'

prompt ptr_vc_array_type header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_vc_array_type.tph' run_file
from dual
/
start '&&run_file'

prompt ptr_vc_array body
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_vc_array.tpw' run_file
from dual
/
start '&&run_file'

--
-- new types above here 
--
set term on

