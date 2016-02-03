CREATE OR REPLACE function get_pl_from_ft( pi_inv_type in nm_inv_types.nit_inv_type%type
                                          ,pi_pk_id in integer ) return nm_placement_array is
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/pck/get_pl_from_ft.fnc-arc   1.1   Feb 03 2016 14:05:04   Rob.Coupe  $
--       Module Name      : $Workfile:   get_pl_from_ft.fnc  $
--       Date into PVCS   : $Date:   Feb 03 2016 14:05:04  $
--       Date fetched Out : $Modtime:   Feb 03 2016 14:04:50  $
--       Version          : $Revision:   1.1  $
--
-------------------------------------------------------------------------
--   Author : Rob Coupe.
--
--   Stand alone function to translate a foreign table network reference(s) to a placement array
--   This allows the array to be translated (aggregated) to the route system.
--   This is intended as a low-impact fix for extracts from Locator. Other methods are more
--   appropriate but lead to dependencies that are difficult to manage.  
--   In fact the whole approach to extracting network data in FT tables is inefficient.
--
------------------------------------------------------------------
--   Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--                                          
l_nit  nm_inv_types%rowtype := nm3get.get_nit(pi_inv_type);
retval nm_placement_array := NM3ARRAY.INIT_NM_PLACEMENT_ARRAY;
l_sql  varchar2(2000);
begin
  l_sql := 'select cast ( collect( nm_placement( '||l_nit.nit_lr_ne_column_name||','||l_nit.nit_lr_st_chain||','||nvl(l_nit. nit_lr_end_chain, l_nit.nit_lr_st_chain)||',0)) as nm_placement_array_type )'||
           ' from '||l_nit.nit_table_name||' where '||l_nit.nit_foreign_pk_column||' = :pk ';
--nm_debug.debug_on;
--nm_debug.debug(l_sql);           
  execute immediate l_sql into retval.npa_placement_array using pi_pk_id;
  return retval;
end;
/
