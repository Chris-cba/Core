--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/typ/nm3typ.sql-arc   2.9   Jul 04 2013 10:14:48   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3typ.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 10:14:48  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:59:36  $
--       Version          : $Revision:   2.9  $
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
set echo off
set term off
set verify off
--
--------------------------------------------------------------------------------------------
-- Short term solution to get around errors on type replace in upgrade
-- Note that should an amended type of the types defined below be used
-- the temporary solution is invalid.
--
undefine user_hist_item_ex
undefine user_hist_module_ex
undefine user_hist_modules_ex

col user_hist_item_ex    new_value user_hist_item_ex    noprint
col user_hist_module_ex  new_value user_hist_module_ex  noprint
col user_hist_modules_ex new_value user_hist_modules_ex noprint

Select 'Y' user_hist_item_ex
From   user_types
Where  type_name = 'USER_HIST_ITEM'
Union
Select 'N' user_hist_item_ex
From   Dual 
Where Not Exists (Select 1
                  From   user_types
                  Where  type_name = 'USER_HIST_ITEM'
                 )
/                         
Select 'Y' user_hist_module_ex
From   user_types
Where  type_name = 'USER_HIST_MODULE'
Union
Select 'N' user_hist_module_ex
From   Dual 
Where Not Exists (Select 1
                  From   user_types
                  Where  type_name = 'USER_HIST_MODULE'
                 )
/        
Select 'Y' user_hist_modules_ex
From   user_types
Where  type_name = 'USER_HIST_MODULES'
Union
Select 'N' user_hist_modules_ex
From   Dual 
Where Not Exists (Select 1
                  From   user_types
                  Where  type_name = 'USER_HIST_MODULES'
                 )
/
--
---------------------------------------------------------------------
-- Drop existing types in appropriate order
set term on
prompt Dropping Existing Types
set term off

BEGIN
 execute immediate ('DROP TYPE nm_dynseg_call_tbl');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE nm_dynseg_sql_tbl');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE nm_id_code_tbl');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY NM_PLACEMENT');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY NM_LREF');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY NM_PLACEMENT_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY USER_HIST_ITEM');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY NM_STATISTIC');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY NM_VALUE_DISTRIBUTION');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY NM_LREF_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY NM_THEME_LIST');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY NM_GEOM_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY NM_CNCT_NE_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY NM_CNCT_NO_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY PTR_VC_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY PTR_VC');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY PTR_NUM_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY PTR_NUM');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY PTR_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY PTR');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NUM_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_MEMBERSHIP_TBL');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_ID_TBL');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_ID_MEANING_TBL');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_ID_CODE_MEANING_TBL');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_CODE_TBL');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_CODE_NAME_MEANING_TBL');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_CODE_MEANING_TBL');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY NM_CNCT');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY INT_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY NM_THEME_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY NM_VALUE_DISTRIBUTION_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY NM_STATISTIC_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY NM_NODE_CLASS');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY USER_HIST_MODULE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY USER_HIST_MODULES');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_PLACEMENT_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_NODE_CLASS');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_MEMBERSHIP_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_ID_MEANING_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_ID_CODE_MEANING_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_CODE_NAME_MEANING_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_CODE_MEANING_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_CNCT');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE PTR_VC_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE PTR_NUM_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NUM_ARRAY_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_GEOM_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_THEME_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_THEME_LIST');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_LREF_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_VALUE_DISTRIBUTION_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_STATISTIC_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_PLACEMENT_ARRAY_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_CNCT_LINK_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_CNCT_NO_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE PTR_VC_ARRAY_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE PTR_NUM_ARRAY_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_GEOM_ARRAY_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_THEME_ARRAY_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_THEME_LIST_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE PTR_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_LREF_ARRAY_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_VALUE_DISTRIBUTION_ARR_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_STATISTIC_ARRAY_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_PLACEMENT');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE PTR_VC');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE PTR_NUM');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE PTR_ARRAY_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_GEOM');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_THEME_DETAIL');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_STATISTIC');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_VALUE_DISTRIBUTION');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_LREF');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_CNCT_LINK_ARRAY_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_CNCT_NE_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_CNCT_NO_ARRAY_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_THEME_ENTRY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE PTR');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_CNCT_NO');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_CNCT_NE_ARRAY_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_CNCT_LINK');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE INT_ARRAY');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_CNCT_NE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE INT_ARRAY_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY NM_ANALYTIC_CHUNK_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_ANALYTIC_CHUNK_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE BODY NM_ANALYTIC_HASH_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/
BEGIN
 execute immediate ('DROP TYPE NM_ANALYTIC_HASH_TYPE');
EXCEPTION
WHEN others THEN
  Null;
END;
/

BEGIN
 execute immediate ('DROP TYPE nm_ne_id_array');
EXCEPTION
WHEN others THEN
  Null;
END;
/

BEGIN
 execute immediate ('DROP TYPE nm_ne_id_type');
EXCEPTION
WHEN others THEN
  Null;
END;
/

BEGIN
 execute immediate ('DROP TYPE hig_navigator_tab');
EXCEPTION
WHEN others THEN
  Null;
END;
/

BEGIN
 execute immediate ('DROP TYPE hig_navigator_type');
EXCEPTION
WHEN others THEN
  Null;
END;
/

BEGIN
 execute immediate ('DROP TYPE nav_id');
EXCEPTION
WHEN others THEN
  Null;
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
prompt nm_placement header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_placement.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_placement body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_placement.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_lref header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_lref.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_lref body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_lref.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_placement_array_type header and body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_placement_array_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_placement_array header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_placement_array.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_placement_array body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_placement_array.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt user_hist_module header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'user_hist_module.tyh' run_file
from dual
where '&user_hist_module_ex' = 'N'
UNION
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'dummy' run_file
FROM dual
WHERE '&user_hist_module_ex' = 'Y'
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt user_hist_module body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'user_hist_module.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt user_hist_modules header and body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'user_hist_modules.tyh' run_file
from dual
where '&user_hist_modules_ex' = 'N'
UNION
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'dummy' run_file
FROM dual
WHERE '&user_hist_modules_ex' = 'Y'
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt user_hist_item header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'user_hist_item.tyh' run_file
from dual
where '&user_hist_item_ex' = 'N'
UNION
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'dummy' run_file
FROM dual
WHERE '&user_hist_item_ex' = 'Y'
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt user_hist_item body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'user_hist_item.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_node_class header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_node_class.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_node_class body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_node_class.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_statistic header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_statistic.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_statistic body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_statistic.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_statistic_array_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_statistic_array_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_statistic_array header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_statistic_array.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_statistic_array body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_statistic_array.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_value_distribution header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_value_distribution.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_value_distribution body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_value_distribution.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_value_distribution_arr_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_value_distribution_arr_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_value_distribution_array header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_value_distribution_array.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_value_distribution_array body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_value_distribution_array.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_lref_array_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_lref_array_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_lref_array header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_lref_array.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_lref_array body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_lref_array.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_theme_entry header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_theme_entry.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_theme_detail header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_theme_detail.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_theme_list_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_theme_list_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_theme_list header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_theme_list.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_theme_array_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_theme_array_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_theme_array header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_theme_array.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_theme_array body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_theme_array.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_theme_list body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_theme_list.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt int_array_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'int_array_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt int_array header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'int_array.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt int_array body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'int_array.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_geom header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_geom.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_geom_array_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_geom_array_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_geom_array header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_geom_array.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_geom_array body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_geom_array.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt num_array_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'num_array_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt num_array header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'num_array.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt ptr header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt ptr body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt ptr_array_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_array_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt ptr_array header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_array.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt ptr_array body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_array.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt ptr_num header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_num.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt ptr_num body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_num.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt ptr_num_array_type body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_num_array_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt ptr_num_array header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_num_array.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt ptr_num_array body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_num_array.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt ptr_vc header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_vc.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt ptr_vc body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_vc.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt ptr_vc_array_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_vc_array_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt ptr_vc_array header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_vc_array.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt ptr_vc_array body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'ptr_vc_array.tyw' run_file
from dual
/
start '&&run_file'
--
--  end of transient array types
--------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------
-- start of creating transient connectivity types
--

set term on
prompt nm_cnct_no header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_cnct_no.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_cnct_no_array_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_cnct_no_array_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_cnct_no_array header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_cnct_no_array.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_cnct_ne header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_cnct_ne.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_cnct_ne_array_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_cnct_ne_array_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_cnct_ne_array header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_cnct_ne_array.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--

set term on
prompt nm_cnct_link header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_cnct_link.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_cnct_link_array_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_cnct_link_array_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_cnct_link_array header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_cnct_link_array.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_cnct header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_cnct.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_cnct_no_array body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_cnct_no_array.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_cnct_ne_array body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_cnct_ne_array.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_cnct body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_cnct.tyw' run_file
from dual
/
start '&&run_file'

--
-- end of creating transient connectivity types
--------------------------------------------------------------------------------------------


--
set term on
prompt nm_code_meaning_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_code_meaning_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_code_meaning_tbl header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_code_meaning_tbl.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_code_name_meaning_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_code_name_meaning_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_code_name_meaning_tbl header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_code_name_meaning_tbl.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_code_tbl header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_code_tbl.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_id_code_meaning_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_id_code_meaning_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_id_code_meaning_tbl header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_id_code_meaning_tbl.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_id_meaning_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_id_meaning_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_id_meaning_tbl header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_id_meaning_tbl.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_id_tbl header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_id_tbl.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_membership_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_membership_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_membership_tbl header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_membership_tbl.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_analytic_chunk_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_analytic_chunk_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_analytic_chunk_type body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_analytic_chunk_type.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_analytic_hash_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_analytic_hash_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_analytic_hash_type body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_analytic_hash_type.tyw' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_id_code_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_id_code_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_id_code_tbl header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_id_code_tbl.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--

set term on
prompt nm_dynseg_call_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_dynseg_call_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_dynseg_call_tbl header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_dynseg_call_tbl.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_dynseg_sql_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_dynseg_sql_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_dynseg_sql_tbl header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_dynseg_sql_tbl.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_ne_id_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_ne_id_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_ne_id_array header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_ne_id_array.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt hig_navigator_type header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'hig_navigator_type.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt hig_navigator_tab header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'hig_navigator_tab.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nav_id header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nav_id.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--

-- *************************************************************************************************************
-- * new types above here                                                                                      *
--                                                                                                             *
-- * Important: if you introduce new types then be aware that this script runs on install and at every upgrade *
-- * so if your type has dependants - these must be dropped in the correct order at the top of this script     *
-- *************************************************************************************************************
--
set term on

