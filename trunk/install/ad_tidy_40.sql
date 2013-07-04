-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)ad_tidy_40.sql	1.3 05/15/06
--       Module Name      : ad_tidy_40.sql
--       Date into SCCS   : 06/05/15 15:33:16
--       Date fetched Out : 07/06/13 13:56:55
--       SCCS Version     : 1.3
--
--
--   Author : Graeme Johnson
--
--
-- 1. Set start date of AD type records to be same as start date of associated network type
-- 2. Set start date of INV type to be same as start date of associated AD type
-- 3. Ensure AD is not located
-- 4. Reset start dates on Primary AD Link records to carry the start date of the element the link is associated with
-- 
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
SET HEADING OFF
SET FEEDBACK OFF
SET TERM OFF

--
-- disable any triggers that would ordinarily stop this data manipulation - they are ENABLED at the end of this script
--
alter trigger nm_nw_ad_types_as DISABLE
/
alter trigger nm_nw_ad_types_br DISABLE
/
alter trigger nm_inv_types_all_dt_trg DISABLE
/
alter trigger nm_nw_ad_link_all_dt_trg DISABLE
/
alter trigger nm_inv_items_all_b_dt_trg DISABLE
/
alter trigger nm_inv_items_all_a_dt_trg DISABLE
/
--
------------------------------------------------------------------------------------------------
--
SET TERM ON
PROMPT Setting start date of AD type records to be same as start date of associated network type...
SET TERM OFF
--
UPDATE nm_nw_ad_types
SET nad_start_date = NVL((select nau_start_date 
                           from nm_admin_units_all
	       					   ,nm_inv_types_all
			 		       where nad_inv_type = nit_inv_type
					       and   nau_admin_type = nit_admin_type
					       and   nau_level = 1), nad_start_date);

--
------------------------------------------------------------------------------------------------
--
SET TERM ON
PROMPT Setting start date of inventory type to be same as start date of associated AD type...
SET TERM OFF

UPDATE nm_inv_types_all
SET    nit_start_date = (select min(nad_start_date)  -- ensure just one record is returned 
                         from nm_nw_ad_types
  	 		             where nad_inv_type = nit_inv_type)
WHERE exists (select 'x' 
              from nm_nw_ad_types
			  where nad_inv_type = nit_inv_type);


--
------------------------------------------------------------------------------------------------
--
SET TERM ON
Prompt Ensuring AD is not located...
SET TERM OFF
delete 
from nm_members_all
where  exists (select 'x'
               from nm_nw_ad_link_all
               where nad_iit_ne_id = nm_ne_id_in
               and   nad_inv_type NOT IN ('TP21','TP22','TP23'))
/


--
------------------------------------------------------------------------------------------------
--
SET TERM ON
PROMPT Resetting start dates on Primary AD Link records to carry the start date of the element the link is associated with...
SET TERM OFF

DECLARE
 CURSOR c1 IS
 SELECT  nad_iit_ne_id
        ,nad_ne_id
	    ,TRUNC(ne_start_date) -- belt and braces  
 FROM nm_nw_ad_link_all lnk
     ,nm_nw_ad_types tps
     ,nm_elements_all
 WHERE tps.nad_id = lnk.nad_id
 and   tps.nad_primary_ad = 'Y'
 and   ne_id = lnk.nad_ne_id
 AND   lnk.nad_start_date != ne_start_date;
 
 l_tab_iit_ne_id nm3type.tab_number;
 l_tab_ne_id     nm3type.tab_number; 
 l_tab_ne_start_date nm3type.tab_date;  
 l_error         varchar2(2000);

BEGIN

 delete from nad_start_date_log_temp;
 commit;

 OPEN c1;
 FETCH c1 BULK COLLECT INTO  l_tab_iit_ne_id
                            ,l_tab_ne_id
                            ,l_tab_ne_start_date;  


  
 FOR i IN 1..l_tab_ne_id.COUNT LOOP
 
  
   BEGIN

    update nm_nw_ad_link_all  -- only update ad link if start date will remain < end date
    set    nad_start_date = l_tab_ne_start_date(i)
	where  nad_iit_ne_id  = l_tab_iit_ne_id(i)
	and    NVL(nad_end_date,l_tab_ne_start_date(i)) >= l_tab_ne_start_date(i);
	
	IF sql%ROWCOUNT != 0 THEN
  	  update nm_inv_items_all
	  set    iit_start_date = l_tab_ne_start_date(i)
      where  iit_ne_id = l_tab_iit_ne_id(i)
	  and    iit_start_date != l_tab_ne_start_date(i);
    END IF;							

  EXCEPTION
   WHEN others THEN
      l_error := sqlerrm;
      insert into nad_start_date_log_temp(nad_iit_ne_id
	                                      ,nad_ne_id
										  ,nad_start_date_new
										  ,error_message)
	  values  (l_tab_iit_ne_id(i)
             ,l_tab_ne_id(i)
			 ,l_tab_ne_start_date(i)
			 ,l_error);
  END;			 
	
 END LOOP;

 commit;
 
END;
/

SET TERM ON

select 'Primary AD Link start dates successfully reset'
from dual
where not exists (select *
                  from nad_start_date_log_temp
				  where nad_iit_ne_id is not null)
UNION
select 'Errors encountered whilst resetting Primary AD Link start dates'||chr(10)||'Please check log table nad_start_date_log_temp'
from dual
where exists (select *
              from nad_start_date_log_temp
		      where nad_iit_ne_id is not null)
/			  
				  

SET TERM OFF
--
--re-enable triggers
--
alter trigger nm_nw_ad_types_as ENABLE
/
alter trigger nm_nw_ad_types_br ENABLE
/
alter trigger nm_inv_types_all_dt_trg ENABLE
/
alter trigger nm_nw_ad_link_all_dt_trg ENABLE
/
alter trigger nm_inv_items_all_b_dt_trg ENABLE
/
alter trigger nm_inv_items_all_a_dt_trg ENABLE
/

SET TERM ON

