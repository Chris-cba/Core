--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/typ/nm3typ.sql-arc   2.17   Apr 18 2019 12:23:36   Chris.Baugh  $
--       Module Name      : $Workfile:   nm3typ.sql  $
--       Date into PVCS   : $Date:   Apr 18 2019 12:23:36  $
--       Date fetched Out : $Modtime:   Apr 18 2019 12:22:12  $
--       Version          : $Revision:   2.17  $
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

-- first a procedure to work around any potential dependencies (bug since 10.2)


create or replace procedure drop_transient_types (p_type in varchar2 ) is
  cursor c1 is select name from user_dependencies
  where referenced_name = p_type
  and type = 'TYPE'
  and name like 'SYSTP%==';
begin
  for irec in c1 loop
    execute immediate 'drop type "'||irec.name||'"';
  end loop;
end;
/


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

DECLARE
  --
  PROCEDURE drop_type(pi_type  VARCHAR2,
                      pi_body  BOOLEAN DEFAULT FALSE)
  IS
  --
    type_not_exists  EXCEPTION;
    pragma exception_init(type_not_exists,-04043);
  --
  BEGIN
    --
	IF NOT pi_body 
	THEN
	  --
      EXECUTE IMMEDIATE 'DROP TYPE '||pi_type||' FORCE';
	ELSE
      EXECUTE IMMEDIATE 'DROP TYPE BODY '||pi_type;
	END IF;
	--
  EXCEPTION
    WHEN type_not_exists THEN
      NULL;
    WHEN OTHERS THEN
	  raise_application_error(-20001,'Could not drop TYPE '||pi_type);
  END drop_type;
  
BEGIN
  --
  drop_type('nm_dynseg_call_tbl');
  drop_type('nm_dynseg_sql_tbl');
  drop_type('nm_id_code_tbl');
  drop_type('NM_PLACEMENT', TRUE);
  drop_type('NM_LREF', TRUE);
  drop_type('NM_PLACEMENT_ARRAY', TRUE);
  drop_type('USER_HIST_ITEM', TRUE);
  drop_type('NM_STATISTIC', TRUE);
  drop_type('NM_VALUE_DISTRIBUTION', TRUE);
  drop_type('NM_LREF_ARRAY', TRUE);
  drop_type('NM_THEME_LIST', TRUE);
  drop_type('NM_GEOM_ARRAY', TRUE);
  drop_type('NM_CNCT_NE_ARRAY', TRUE);
  drop_type('NM_CNCT_NO_ARRAY', TRUE);
  drop_type('PTR_VC_ARRAY', TRUE);
  drop_type('PTR_VC', TRUE);
  drop_type('PTR_NUM_ARRAY', TRUE);
  drop_type('PTR_NUM', TRUE);
  drop_type('PTR_ARRAY', TRUE);
  drop_type('PTR', TRUE);
  drop_type('NUM_ARRAY');
  drop_type('NM_MEMBERSHIP_TBL');
  drop_type('NM_ID_TBL');
  drop_type('NM_ID_MEANING_TBL');
  drop_type('NM_ID_CODE_MEANING_TBL');
  drop_type('NM_CODE_TBL');
  drop_type('NM_CODE_NAME_MEANING_TBL');
  drop_type('NM_CODE_MEANING_TBL');
  drop_type('NM_CNCT', TRUE);
  drop_type('NM_THEME_ARRAY', TRUE);
  drop_type('NM_VALUE_DISTRIBUTION_ARRAY', TRUE);
  drop_type('NM_STATISTIC_ARRAY', TRUE);
  drop_type('NM_NODE_CLASS', TRUE);
  drop_type('USER_HIST_MODULE', TRUE);
  drop_type('USER_HIST_MODULES', TRUE);
  drop_type('NM_PLACEMENT_ARRAY');
  drop_type('NM_NODE_CLASS');
  drop_type('NM_MEMBERSHIP_TYPE');
  drop_type('NM_ID_MEANING_TYPE');
  drop_type('NM_ID_CODE_MEANING_TYPE');
  drop_type('NM_CODE_NAME_MEANING_TYPE');
  drop_type('NM_CODE_MEANING_TYPE');
  drop_type('NM_CNCT');
  drop_type('PTR_VC_ARRAY');
  drop_type('PTR_NUM_ARRAY');
  drop_type('NUM_ARRAY_TYPE');
  drop_type('NM_GEOM_ARRAY');
  drop_type('NM_THEME_ARRAY');
  drop_type('NM_THEME_LIST');
  drop_type('NM_LREF_ARRAY');
  drop_type('NM_VALUE_DISTRIBUTION_ARRAY');
  drop_type('NM_STATISTIC_ARRAY');
  drop_type('NM_PLACEMENT_ARRAY_TYPE');
  drop_type('NM_CNCT_LINK_ARRAY');
  drop_type('NM_CNCT_NO_ARRAY');
  drop_type('PTR_VC_ARRAY_TYPE');
  drop_type('PTR_NUM_ARRAY_TYPE');
  drop_type('NM_GEOM_ARRAY_TYPE');
  drop_type('NM_THEME_ARRAY_TYPE');
  drop_type('NM_THEME_LIST_TYPE');
  drop_type('PTR_ARRAY');
  drop_type('NM_LREF_ARRAY_TYPE');
  drop_type('NM_VALUE_DISTRIBUTION_ARR_TYPE');
  drop_type('NM_STATISTIC_ARRAY_TYPE');
  drop_type('NM_PLACEMENT');
  drop_type('PTR_VC');
  drop_type('PTR_NUM');
  drop_type('PTR_ARRAY_TYPE');
  drop_type('NM_GEOM');
  drop_type('NM_THEME_DETAIL');
  drop_type('NM_STATISTIC');
  drop_type('NM_VALUE_DISTRIBUTION');
  drop_type('NM_LREF');
  drop_type('NM_CNCT_LINK_ARRAY_TYPE');
  drop_type('NM_CNCT_NE_ARRAY');
  drop_type('NM_CNCT_NO_ARRAY_TYPE');
  drop_type('NM_THEME_ENTRY');
  drop_type('PTR');
  drop_type('NM_CNCT_NO');
  drop_type('NM_CNCT_NE_ARRAY_TYPE');
  drop_type('NM_CNCT_LINK');
  drop_type('NM_CNCT_NE');
  drop_type('INT_ARRAY', TRUE); 
  drop_type('INT_ARRAY');
  drop_type('INT_ARRAY_TYPE');
  drop_type('NM_ANALYTIC_CHUNK_TYPE', TRUE);
  drop_type('NM_ANALYTIC_CHUNK_TYPE');
  drop_type('NM_ANALYTIC_HASH_TYPE', TRUE);
  drop_type('NM_ANALYTIC_HASH_TYPE');
  drop_type('nm_ne_id_array');
  drop_type('nm_ne_id_type');
  drop_type('hig_navigator_tab');
  drop_type('hig_navigator_type');
  drop_type('nav_id');
  --
  -- Location Bridge Types
  --
  drop_type('LB_STATS', TRUE); 
  drop_type('LB_STATS'); 
  drop_type('LB_RPT_TAB'); 
  drop_transient_types('LB_RPT');
  drop_type('LB_RPT'); 
  drop_type('LB_LOC_ERROR_TAB');
  drop_transient_types('LB_LOC_ERROR');
  drop_type('LB_LOC_ERROR');
  drop_type('LB_OBJ_ID_TAB');
  drop_transient_types('LB_OBJ_ID');
  drop_type('LB_OBJ_ID');
  drop_type('LB_RPT_GEOM_TAB');
  drop_transient_types('LB_RPT_GEOM_TAB');
  drop_transient_types('LB_RPT_GEOM');
  drop_type('LB_RPT_GEOM');
  drop_type('LB_OBJ_GEOM_TAB');
  drop_type('LB_OBJ_GEOM');
  drop_type('LB_ASSET_TYPE_NETWORK_TAB');
  drop_type('LB_ASSET_TYPE_NETWORK');
  drop_type('LB_JXP_TAB');
  drop_type('LB_JXP');
  drop_type('LB_LINEAR_REFNT_TAB');
  drop_type('LB_LINEAR_REFNT');
  drop_type('LB_LINEAR_TYPE_TAB');
  drop_type('LB_LINEAR_TYPE');
  drop_type('LB_LOCATION_ID_TAB');
  drop_type('LB_LOCATION_ID');
  drop_type('LB_REFNT_MEASURE_TAB');
  drop_type('LB_REFNT_MEASURE');
  drop_type('LB_XSP_TAB');
  drop_type('LB_XSP');
  drop_type('LB_LINEAR_LOCATIONS');
  drop_type('LB_LINEAR_LOCATION');
  drop_type('LB_EDIT_TRANSACTION_TAB');
  drop_type('LB_SNAP_TAB');
  drop_type('LB_SNAP');
  drop_type('LB_LINEAR_ELEMENT_TYPES');
  drop_type('LB_LINEAR_ELEMENT_TYPE');
  drop_type('LB_XRPT_TAB');
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
set term on
prompt nm_max_varchar_tbl header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_max_varchar_tbl.tyh' run_file
from dual
/
start '&&run_file'
--
--------------------------------------------------------------------------------------------
--
set term on
prompt nm_msv_style_size.tyh header
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'nm_msv_style_size.tyh' run_file
from dual
/
start '&&run_file'

--------------------------------------------------------------------------------------------
-- Location Bridge Types
--------------------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_stats.tyh 
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_stats.tyh' run_file
from dual
/
start '&&run_file'

 
--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_stats.tyw body
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_stats.tyw' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_rpt.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_rpt.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_rpt_tab.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_rpt_tab.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_loc_error.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_loc_error.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_loc_error_tab.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_loc_error_tab.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_obj_id.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_obj_id.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_obj_id_tab.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_obj_id_tab.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_rpt_geom.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_rpt_geom.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_rpt_geom_tab.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_rpt_geom_tab.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_obj_geom.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_obj_geom.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_obj_geom_tab.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_obj_geom_tab.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_asset_type_network.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_asset_type_network.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_asset_type_network_tab.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_asset_type_network_tab.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_jxp.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_jxp.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_jxp_tab.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_jxp_tab.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_linear_refnt.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_linear_refnt.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_linear_refnt_tab.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_linear_refnt_tab.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_linear_type.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_linear_type.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_linear_type_tab.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_linear_type_tab.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_location_id.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_location_id.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_location_id_tab.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_location_id_tab.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_refnt_measure.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_refnt_measure.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_refnt_measure_tab.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_refnt_measure_tab.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_xsp.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_xsp.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_xsp_tab.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_xsp_tab.tyh' run_file
from dual
/
start '&&run_file'

--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_linear_location.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_linear_location.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_linear_locations.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_linear_locations.tyh' run_file
from dual
/
start '&&run_file'

--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_edit_transaction.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_edit_transaction.tyh' run_file
from dual
/
start '&&run_file'

--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_edit_transaction_tab.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_edit_transaction_tab.tyh' run_file
from dual
/
start '&&run_file'

--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_snap.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_snap.tyh' run_file
from dual
/
start '&&run_file'


--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_snap_tab.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_snap_tab.tyh' run_file
from dual
/
start '&&run_file'

--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_linear_element_type.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_linear_element_type.tyh' run_file
from dual
/
start '&&run_file'

--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_linear_element_types.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_linear_element_types.tyh' run_file
from dual
/
start '&&run_file'

--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_xrpt.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_xrpt.tyh' run_file
from dual
/
start '&&run_file'

--
--------------------------------------------------------------------------------------------
--
set term on
prompt lb_xrpt_tab.tyh
set term off
set define on
set feedback off
select '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'typ'||
        '&terminator'||'lb_xrpt_tab.tyh' run_file
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

