define sccsid = '@(#)nm3typ_40.sql	1.4 04/05/06'
--
set echo off
set term off
--
/* New generic types created during schemes delopment
  nm_code_meaning_tbl.tyh           
  nm_code_meaning_type.tyh          
  nm_code_name_meaning_tbl.tyh      -- in 3211, not included here
  nm_code_name_meaning_type.tyh     -- in 3211, not included here
  nm_code_tbl.tyh                   
  nm_id_code_meaning_tbl.tyh        
  nm_id_code_meaning_type.tyh       
  nm_id_meaning_tbl.tyh             
  nm_id_meaning_type.tyh            
  nm_id_tbl.tyh                               
  nm_membership_tbl.tyh             
  nm_membership_type.tyh
*/
--
prompt nm_code_meaning_type header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_code_meaning_type.tyh' run_file
from dual
/
start '&&run_file'
--
prompt nm_code_meaning_tbl header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_code_meaning_tbl.tyh' run_file
from dual
/
start '&&run_file'
--
prompt nm_code_tbl header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_code_tbl.tyh' run_file
from dual
/
start '&&run_file'
--
prompt nm_id_code_meaning_type header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_id_code_meaning_type.tyh' run_file
from dual
/
start '&&run_file'
--
prompt nm_id_code_meaning_tbl header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_id_code_meaning_tbl.tyh' run_file
from dual
/
start '&&run_file'
--
prompt nm_id_meaning_type header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_id_meaning_type.tyh' run_file
from dual
/
start '&&run_file'
--
prompt nm_id_meaning_tbl header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_id_meaning_tbl.tyh' run_file
from dual
/
start '&&run_file'
--
prompt nm_id_tbl header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_id_tbl.tyh' run_file
from dual
/
start '&&run_file'
--
prompt nm_membership_type header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_membership_type.tyh' run_file
from dual
/
start '&&run_file'
--
prompt nm_membership_tbl header
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_membership_tbl.tyh' run_file
from dual
/
start '&&run_file'
--
-- new types above here 
--
set term on

